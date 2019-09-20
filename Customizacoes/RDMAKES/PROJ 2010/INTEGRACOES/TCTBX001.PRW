#Include "rwmake.ch"

/*----------------------------------------------------------------------------+
| Programa   : TCTBX001 | 			            | Data: 20.07.08  |
+-----------------------------------------------------------------------------+
| Descricao  : Geracao de Arquivos TXT para a Escrita Fiscal New              |
+-----------------------------------------------------------------------------+
| Uso        : Gera ENtradas/Saídas para ContaOeste                           |
+----------------------------------------------------------------------------*/

User Function TCTBX001()
Private cPerg	:= "TCTBX0" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Criacao das Perguntas
sfCriaPerg()

If ! Pergunte(cPerg,.T.)
	Return
EndIF

Processa({|| sfProcessa() })

Return


//Funcao Responsavel pela Geracao dos Arquivos
Static Function sfProcessa()

cArqSaida	:= mv_par04 +"\NF_Saidas.txt"
cArqEntrada	:= mv_par04 +"\NF_Entrada.txt"

If mv_par03 == 1
	
	sfEntradas()
	
ElseIf mv_par03 == 2
	
	sfSaidas()
	
ElseIf mv_par03 == 3
	
	sfSaidas()
	sfEntradas()
	
EndIf

MsgStop("Processamento Ok!")

Return

//Funcao Responsavel pela Geracao das Informacoes das Notas de Saida
Static Function sfSaidas()

Local aCliFor	:= {}
Local aProdutos	:= {}
Local aCmpSaida	:= {}
Local aItemCFOP	:= {}
Local aItemNF	:= {}
Local cContrib	:= ""
Local nIsenIPI	:= 0
Local nOutrIPI	:= 0

//Cria Arquivo de Trabalho Temporario
aAdd( aCmpSaida,{"LINHA"	,"C",500,0} )
cArqTrbS := CriaTrab( aCmpSaida,.T. )

If Select("TRBS") <> 0
	DbSelectArea("TRBS")
	DbCloseArea()
EndIf

Use &cArqTrbS Alias TRBS New
DBSelectArea("TRBS")

//Processando as Saidas de Notas
aInd     := {}
dbSelectArea("SF2") ; dbSetOrder(1)
dbGotop()
cIndex := CriaTrab(nil,.f.)
AADD(aInd,cIndex)

cFiltro	:= 'F2_FILIAL == "'+xFilial("SF2")+'" .and. '
cFiltro	+= 'DTOS(F2_EMISSAO) >= "'+DtoS(mv_par01)+'" .and. DTOS(F2_EMISSAO) <= "'+DtoS(mv_par02)+'" '

cKey   := IndexKey()
IndRegua("SF2",cIndex,cKey,,cFiltro, OemToAnsi("Selecionando Registros...") )
nIndex := RetIndex("SF2")
DbSelectArea("SF2")
#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbGoTop()

//Cria e abre arquivo texto
nHdl	:= fCreate(cArqSaida)
cEOL    := "CHR(13)+CHR(10)"
cEOL	:= &cEOL

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqSaida+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//Processa linhas
dbSelectArea("SF2")
SF2->(dbGotop())
Procregua( SF2->(RecCount()) )
While SF2->( !Eof() )
	
	Incproc("Notas de Saida...")
	
	If SF2->F2_TIPO == "D"
		dbSelectArea("SA2") ; SA2->(dbSetOrder(1))
		SA2->( dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA) )
		
		//Alimenta Vetor com informacoes do Fornecedor
		If aScan( aCliFor , {|x| x[1] == "SA2" .and. x[2] == SF2->F2_CLIENTE .and. x[3] == SF2->F2_LOJA } ) == 0
			aAdd( aCliFor , { "SA2" , SF2->F2_CLIENTE , SF2->F2_LOJA } )
		EndIf
		
		cCNPJCliFor	:= SA2->A2_CGC
		cContrib	:= If(!Empty(SA2->A2_INSCR),"S","N")
		
	Else
		dbSelectArea("SA1") ; SA1->(dbSetorder(1))
		SA1->( dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA) )
		
		//Alimenta Vetor com informacoes do Cliente
		If aScan( aCliFor , {|x| x[1] == "SA1" .and. x[2] == SF2->F2_CLIENTE .and. x[3] == SF2->F2_LOJA } ) == 0
			aAdd( aCliFor , { "SA1" , SF2->F2_CLIENTE , SF2->F2_LOJA } )
		EndIf
		
		cCNPJCliFor	:= SA1->A1_CGC
		cContrib	:= If(!Empty(SA1->A1_INSCR),"S","N")
		
	EndIf
	
	//Itens da NF
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	
	//Zera Vetor com Itens da Nf
	aItemNF	:= {}
	
	While SD2->(!Eof()) .and. SD2->D2_FILIAL == SF2->F2_FILIAL .and. SD2->D2_DOC == SF2->F2_DOC .and. SD2->D2_SERIE == SF2->F2_SERIE ;
		.and. SD2->D2_CLIENTE == SF2->F2_CLIENTE .and. SD2->D2_LOJA == SF2->F2_LOJA
		
		//Adiciona Produtos
		If aScan( aProdutos , SD2->D2_COD ) == 0
			aAdd( aProdutos , SD2->D2_COD )
		EndIf
		
		//Monta Linha dos itens da NF
		cLinhaItem	:= "F;"
		cLinhaItem	+= SD2->D2_ITEM +";"
		cLinhaItem	+= SD2->D2_COD +";"
		cLinhaItem	+= SD2->D2_CLASFIS +";" //Situacao Tributaria
		cLinhaItem	+= SD2->D2_UM +";"
		cLinhaItem	+= Str(SD2->D2_QUANT  ,14,2) +";"
		cLinhaItem	+= Str(SD2->D2_PRCVEN ,14,2) +";"
		cLinhaItem	+= Str(SD2->D2_TOTAL  ,16,2) +";"
		cLinhaItem	+= Str(SD2->D2_BASEICM,14,2) +";"//Base ICMS
		cLinhaItem	+= Str(SD2->D2_PICM   , 6,2) +";"//Aliquota ICMS
		cLinhaItem	+= Str(SD2->D2_VALICM ,14,2) +";"//Valor ICMS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Isenta ICMS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras ICMS
		cLinhaItem	+= Str(SD2->D2_BASEIPI,14,2) +";"//Base Calculo IPI
		cLinhaItem	+= Str(SD2->D2_IPI    , 6,2) +";"//Aliquota IPI
		cLinhaItem	+= Str(SD2->D2_VALIPI ,14,2) +";"//Valor IPI
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Isentas IPI
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras IPI
		cLinhaItem	+= Str(SD2->D2_BASEISS,14,2) +";"//Base Calculo ISS
		cLinhaItem	+= Str(SD2->D2_ALIQISS, 6,2) +";"//Aliquota ISS
		cLinhaItem	+= Str(SD2->D2_VALISS ,14,2) +";"//Valor ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Isentas ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Base Calculo Sub Trib
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Aliquota Sub Trib
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Valor sub Trib
		cLinhaItem	+= Str(SD2->D2_DESCON ,14,2) +";"//Valor Desconto
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Valor Despesa Acessoria
		cLinhaItem	+= "1;"//Tipo Estoque: 1-Proprio, 2-Outros, 3-Diversos
		
		//Itens da NF
		aAdd( aItemNF , cLinhaItem )
		
		SD2->(dbSkip())
	EndDo
	
	//Zera as Variaveis do IPI e CFOP
	nIsenIPI	:= 0
	nOutrIPI	:= 0
	aItemCFOP	:= {}
	
	//Gera Informacoes do CFOP
	dbSelectArea("SF3")
	SF3->(dbSetOrder(1))
	SF3->(dbSeek(xFilial("SF3")+ DtoS(SF2->F2_EMISSAO) + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA ) )
	
	While SF3->(!Eof()) .and. SF3->F3_FILIAL == xFilial("SF3") .and. DtoS(SF3->F3_EMISSAO) == DtoS(SF2->F2_EMISSAO) ;
		.and. SF3->F3_NFISCAL == SF2->F2_DOC .and. SF3->F3_SERIE == SF2->F2_SERIE ;
		.and. SF3->F3_CLIEFOR == SF2->F2_CLIENTE .and. SF3->F3_LOJA == SF2->F2_LOJA
		
		//Quando a condição de pagamento da nota for igual 040 vai mandar o cfop + 001 se não cfop + 002 (Gustavo)
		cLinha	:= "D;"
		cLinha	+= AllTrim(SF3->F3_CFO)  //+ If(SF2->F2_COND=="040","001","002") +";"
		cLinha	+= "002;"
		cLinha	+= "1;"
		cLinha	+= Str(SF3->F3_VALCONT,14,2) +";"
		cLinha	+= Str(SF3->F3_BASEICM,14,2) +";"
		cLinha	+= Str(SF3->F3_ALIQICM, 6,2) +";"
		cLinha	+= Str(SF3->F3_VALICM ,14,2) +";"
		cLinha	+= Str(SF3->F3_ISENICM,14,2) +";"
		cLinha	+= Str(SF3->F3_OUTRICM,14,2) +";"
		cLinha	+= Str( 0 ,14,2) +";" //Valor Exclusao Adicional
		cLinha	+= ";"
		
		//Adiciona Inforamacoes do CFOP
		aAdd( aItemCFOP , cLinha )
		
		nIsenIPI	+= SF3->F3_ISENIPI
		nOutrIPI	+= SF3->F3_OUTRIPI
		
		SF3->(dbSkip())
	EndDo
	
	//Grava Informacoes do Cabecalho da NF
	cLinha := "C;"
	cLinha += SM0->M0_CGC +";"
	cLinha += cCNPJCliFor +";"
	cLinha += SF2->F2_DOC +";"
	cLinha += SF2->F2_DOC +";"
	cLinha += SF2->F2_ESPECIE +";"
	cLinha += SF2->F2_SERIE +";"
	cLinha += ";" //Sub-Serie
	cLinha += DtoC(SF2->F2_EMISSAO) +";"
	cLinha += Str(SF2->F2_VALBRUT,14,2) +";"
	cLinha += Str(SF2->F2_VALBRUT,14,2) +";"
	cLinha += Str(SF2->F2_VALIPI,14,2) +";"
	cLinha += Str( nOutrIPI ,14,2) +";" //Valor Isentas IPI	
	cLinha += Str( nIsenIPI ,14,2) +";" //Valor Outras IPI
	cLinha += cContrib +";"
	cLinha += Str( 0 ,14,2) +";"
	cLinha += SM0->M0_ESTCOB +";"
	cLinha += SM0->M0_CIDCOB +";"
	cLinha += ";"//Observacao
	cLinha += "01;" //Tabela SINTEGRA
	cLinha += "P;"
	cLinha += If(SF2->F2_FRETE>0,"1","2") +";" //Frete: 1-CIF / 2-FOB
	cLinha += ";" //Adicional ISS
	cLinha += "N;" //Cancelado
	cLinha += "N;" //Conciliado
	cLinha += ";" //Chave de Origem do Lancamento
	
	RecLock("TRBS",.t.)
	TRBS->LINHA	:= cLinha
	MsUnLock("TRBS")
	
	//Grava Informacoes Referente às CFOP
	For nCFOP := 1 to Len(aItemCFOP)
		RecLock("TRBS",.t.)
		TRBS->LINHA	:= aItemCFOP[nCFOP]
		MsUnLock("TRBS")
	Next nCFOP
	
	//Grava Informacoes dos Itens da NF
	For nItem := 1 to Len(aItemNF)
		RecLock("TRBS",.t.)
		TRBS->LINHA	:= aItemNF[nItem]
		MsUnLock("TRBS")
	Next nItem
	
	//Passa para a proxima NF
	SF2->(dbSkip())
	
EndDo

//Busca Notas Fiscais Canceladas
sfNfCancelada()

//Gera o Arquivo TXT
//1. Clientes/Fornecedores
For nPos := 1 to Len(aCliFor)
	cLinha	:= "A;"
	
	If aCliFor[nPos,1] == "SA1" //Clientes
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1") + aCliFor[nPos,2] + aCliFor[nPos,3] ) )
		
		cLinha	+= SA1->A1_NOME +";"
		cLinha	+= If(Len(AllTrim(SA1->A1_CGC))>11,"2","1") +";"
		cLinha	+= SA1->A1_CGC +";"
		cLinha	+= ";" //Logradouro
		cLinha	+= Left(SA1->A1_END,40) +";"
		cLinha	+= ";" //Numero
		cLinha	+= ";" //Complemento
		cLinha	+= SA1->A1_BAIRRO +";"
		cLinha	+= SA1->A1_EST +";"
		cLinha	+= SA1->A1_MUN +";"
		cLinha	+= SA1->A1_CEP +";"
		cLinha	+= SA1->A1_DDD +";"
		cLinha	+= Left(SA1->A1_TEL,13) +";"
		cLinha	+= If(SA1->A1_TIPO=="L","S","N") +";"
		cLinha	+= SA1->A1_INSCRUR +";"
		cLinha	+= SA1->A1_INSCR +";"
		cLinha	+= SA1->A1_EMAIL +";"
		cLinha	+= SA1->A1_HPAGE +";"
		cLinha	+= cEol
		
	Else //Fornecedores
		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2") + aCliFor[nPos,2] + aCliFor[nPos,3] ) )
		
		cLinha	+= SA2->A2_NOME+";"
		cLinha	+= If(Len(AllTrim(SA2->A2_CGC))>11,"2","1") +";"
		cLinha	+= SA2->A2_CGC +";"
		cLinha	+= ";" //Logradouro
		cLinha	+= Left(SA2->A2_END,40) +";"
		cLinha	+= ";" //Numero
		cLinha	+= ";" //Complemento
		cLinha	+= SA2->A2_BAIRRO +";"
		cLinha	+= SA2->A2_EST +";"
		cLinha	+= SA2->A2_MUN +";"
		cLinha	+= SA2->A2_CEP +";"
		cLinha	+= SA2->A2_DDD +";"
		cLinha	+= Left(SA2->A2_TEL,13) +";"
		cLinha	+= "N;" //Produtor Rural
		cLinha	+= ";" //Inscr Prod Rural
		cLinha	+= SA2->A2_INSCR +";"
		cLinha	+= SA2->A2_EMAIL +";"
		cLinha	+= SA2->A2_HPAGE +";"
		cLinha	+= cEol
		
	EndIf
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
Next nPos

//2. Produtos
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
For nPos := 1 to Len(aProdutos)
	SB1->(dbSeek( xFilial("SB1")+aProdutos[nPos] ))
	
	cLinha	:= "B;"
	cLinha	+= SM0->M0_CGC +";"
	cLinha	+= SB1->B1_COD +";"
	cLinha	+= SB1->B1_GRUPO +";"
	cLinha	+= Left(SB1->B1_DESC,50) +";"
	cLinha	+= SB1->B1_POSIPI +";" //Classificacao Fiscal
	cLinha	+= SB1->B1_UM +";"
	cLinha	+= cEol
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
Next nPos


//3. Notas e CFOP
dbSelectArea("TRBS")
TRBS->(dbGoTop())
While TRBS->(!Eof())
	
	cLinha	:= TRBS->LINHA
	cLinha	+= cEol
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
	TRBS->(dbSkip())
EndDo

//Fecha arquivo texto
fClose(nHdl)

//Desfaz filtro do indregua
dbSelectArea("SF2")
RetIndex("SF2")
Set Filter to
For nI:=1 to Len(aInd)
	if File(aInd[nI]+OrdBagExt())
		Ferase(aInd[nI]+OrdBagExt())
	Endif
Next

Return

//Funcao Responsavel pela Geracao das Informacoes das Notas de Entrada
Static Function sfEntradas()

Local aCliFor	:= {}
Local aProdutos	:= {}
Local aCmpEntra	:= {}
Local aItemCFOP	:= {}
Local aCenCusto	:= {}
Local aItemNF	:= {}
Local nIsenIPI	:= 0
Local nOutrIPI	:= 0

//Cria Arquivo de Trabalho Temporario
aAdd( aCmpEntra,{"LINHA"	,"C",500,0} )
cArqTrbE := CriaTrab( aCmpEntra,.T. )

If Select("TRBE") <> 0
	DbSelectArea("TRBE")
	DbCloseArea()
EndIf

Use &cArqTrbE Alias TRBE New
DBSelectArea("TRBE")

//Processando as Saidas de Notas
aInd     := {}
dbSelectArea("SF1") ; dbSetOrder(1)
dbGotop()
cIndex := CriaTrab(nil,.f.)
AADD(aInd,cIndex)

//Alterado o filtro para tratar o campo F1_DTDIGIT, conforme solicitacao do Gustavo (TI)
cFiltro	:= 'F1_FILIAL == "'+xFilial("SF1")+'" .and. '
cFiltro	+= 'DTOS(F1_DTDIGIT) >= "'+DtoS(mv_par01)+'" .and. DTOS(F1_DTDIGIT) <= "'+DtoS(mv_par02)+'" '

cKey   := IndexKey()
IndRegua("SF1",cIndex,cKey,,cFiltro, OemToAnsi("Selecionando Registros...") )
nIndex := RetIndex("SF1")
DbSelectArea("SF1")
#IFNDEF TOP
	DbSetIndex(cIndex+OrdBagExt())
#ENDIF
DbSetOrder(nIndex+1)
DbGoTop()

//Cria e abre arquivo texto
nHdl	:= fCreate(cArqEntrada)
cEOL    := "CHR(13)+CHR(10)"
cEOL	:= &cEOL

If nHdl == -1
	MsgAlert("O arquivo de nome "+cArqEntrada+" nao pode ser executado! Verifique os parametros.","Atencao!")
	Return
Endif

//Processa linhas
dbSelectArea("SF1")
SF1->(dbGotop())
Procregua( SF1->(RecCount()) )

While SF1->( !Eof() )
	
	Incproc("Notas de Entrada...")
	
	If SF1->F1_TIPO # "D"
		dbSelectArea("SA2") ; dbSetOrder(1)
		dbSeek(xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		If aScan( aCliFor , {|x| x[1] == "SA2" .and. x[2] == SF1->F1_FORNECE .and. x[3] == SF1->F1_LOJA } ) == 0
			aAdd( aCliFor , { "SA2" , SF1->F1_FORNECE , SF1->F1_LOJA } )
		EndIf
		
		cCNPJCliFor	:= SA2->A2_CGC
		cEstOrigem	:= SA2->A2_EST
		
	Else
		dbSelectArea("SA1") ; dbSetorder(1)
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		
		If aScan( aCliFor , {|x| x[1] == "SA1" .and. x[2] == SF1->F1_FORNECE .and. x[3] == SF1->F1_LOJA } ) == 0
			aAdd( aCliFor , { "SA1" , SF1->F1_FORNECE , SF1->F1_LOJA } )
		EndIf
		
		cCNPJCliFor	:= SA1->A1_CGC
		cEstOrigem	:= SA1->A1_EST
		
	EndIf
	
	//Itens da NF
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	
	//Zera Vetor Contendo Informacoes do Centros de Custos
	aCenCusto	:= {}
	aItemNF		:= {}
	
	While SD1->(!Eof()) .and. SD1->D1_FILIAL == SF1->F1_FILIAL .and. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE ;
		.and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA
		
		//Adiciona Produtos
		If aScan( aProdutos , SD1->D1_COD ) == 0
			aAdd( aProdutos , SD1->D1_COD )
		EndIf
		
		//Monta Linha dos itens da NF
		cLinhaItem	:= "F;"
		cLinhaItem	+= SD1->D1_ITEM +";"
		cLinhaItem	+= SD1->D1_COD +";"
		cLinhaItem	+= SD1->D1_CLASFIS +";" //Situacao Tributaria
		cLinhaItem	+= SD1->D1_UM +";"
		cLinhaItem	+= Str(SD1->D1_QUANT  ,14,2) +";"
		cLinhaItem	+= Str(SD1->D1_VUNIT  ,14,2) +";"
		cLinhaItem	+= Str(SD1->D1_TOTAL  ,16,2) +";"
		cLinhaItem	+= Str(SD1->D1_BASEICM,14,2) +";"//Base ICMS
		cLinhaItem	+= Str(SD1->D1_PICM   , 6,2) +";"//Aliquota ICMS
		cLinhaItem	+= Str(SD1->D1_VALICM ,14,2) +";"//Valor ICMS
		cLinhaItem	+= Str(SD1->D1_VALIPI ,14,2) +";"//Rever Isenta ICMS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras ICMS
		cLinhaItem	+= Str(SD1->D1_BASEIPI,14,2) +";"//Base Calculo IPI
		cLinhaItem	+= Str(SD1->D1_IPI    , 6,2) +";"//Aliquota IPI
		cLinhaItem	+= Str(SD1->D1_VALIPI ,14,2) +";"//Valor IPI
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Isentas IPI
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras IPI
		cLinhaItem	+= Str(SD1->D1_BASEISS,14,2) +";"//Base Calculo ISS
		cLinhaItem	+= Str(SD1->D1_ALIQISS, 6,2) +";"//Aliquota ISS
		cLinhaItem	+= Str(SD1->D1_VALISS ,14,2) +";"//Valor ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Isentas ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Outras ISS
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Base Calculo Sub Trib
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Aliquota Sub Trib
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Valor sub Trib
		cLinhaItem	+= Str( 0             ,14,2) +";"//Valor Desconto
		cLinhaItem	+= Str( 0             ,14,2) +";"//Rever Valor Despesa Acessoria
		cLinhaItem	+= "1;"//Tipo Estoque: 1-Proprio, 2-Outros, 3-Diversos
		
		//Itens da NF
		aAdd( aItemNF , cLinhaItem )
		
		//Calcula o Valor por Centro de Custo
		If !Empty(SD1->D1_CC)
			nPosCC := aScan( aCenCusto , {|x| x[1] == SD1->D1_CC }  )
			If nPosCC == 0
				aAdd( aCenCusto , { SD1->D1_CC , SD1->D1_TOTAL } )
			Else
				aCenCusto[nPosCC,2] += SD1->D1_TOTAL
			EndIf
		EndIf
		
		SD1->(dbSkip())
	EndDo
	
	//Zera as Variaveis do IPI e CFOP
	nIsenIPI	:= 0
	nOutrIPI	:= 0
	aItemCFOP	:= {}
	
	//Busca Informacoes das CFOPs
	dbSelectArea("SF3")
	SF3->(dbSetOrder(1))
	SF3->(dbSeek(xFilial("SF3")+ DtoS(SF1->F1_DTDIGIT) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) )
	
	While SF3->(!Eof()) .and. SF3->F3_FILIAL == xFilial("SF3") .and. DtoS(SF3->F3_ENTRADA) == DtoS(SF1->F1_DTDIGIT) ;
		.and. SF3->F3_NFISCAL == SF1->F1_DOC .and. SF3->F3_SERIE == SF1->F1_SERIE ;
		.and. SF3->F3_CLIEFOR == SF1->F1_FORNECE .and. SF3->F3_LOJA == SF1->F1_LOJA
		
		//se a condicao de pagamento for igual a 040 colocar cfop+001
		//se a condicao for diferente de 040 colocar o cfop+002
		//mas se a nota tiver ipi ignorar esta regra e colocar o cfop+003
		cLinha	:= "D;"
		cLinha	+= AllTrim(SF3->F3_CFO)
		
		If SF3->F3_VALIPI > 0
			cLinha += "003" +";"
		Else
			cLinha += "002" +";"
		EndIf
		
		cLinha	+= "1;"
		cLinha	+= Str(SF3->F3_VALCONT,14,2) +";"
		cLinha	+= Str(SF3->F3_BASEICM,14,2) +";"
		cLinha	+= Str(SF3->F3_ALIQICM, 6,2) +";"
		cLinha	+= Str(SF3->F3_VALICM ,14,2) +";"
		cLinha	+= Str(SF3->F3_ISENICM,14,2) +";"
		cLinha	+= Str(SF3->F3_OUTRICM,14,2)+";"
		cLinha	+= Str( 0 ,14,2) +";"
		cLinha	+= ";"
		
		//Adiciona inforamacoes do CFOP
		aAdd( aItemCFOP , cLinha )
		
		nIsenIPI	+= SF3->F3_ISENIPI
		nOutrIPI	+= SF3->F3_OUTRIPI
		
		SF3->(dbSkip())
	EndDo
	
	cLinha := "C;"
	cLinha += SM0->M0_CGC +";"
	cLinha += cCNPJCliFor +";"
	cLinha += SF1->F1_DOC +";"
	cLinha += sfEntEspec(SF1->F1_ESPECIE) +";"
	cLinha += SF1->F1_SERIE +";"
	cLinha += ";" //Sub-Serie
	cLinha += DtoC(SF1->F1_DTDIGIT) +";"
	cLinha += DtoC(SF1->F1_EMISSAO) +";"
	cLinha += Str(SF1->F1_VALBRUT,14,2) +";"
	cLinha += Str(SF1->F1_BASEIPI,14,2) +";"
	cLinha += Str(SF1->F1_VALIPI,14,2) +";"
	cLinha += Str( nOutrIPI ,14,2) +";" //Valor Isentas IPI
	cLinha += Str( nIsenIPI ,14,2) +";" //Valor Outras IPI
	cLinha += Str( 0 ,14,2) +";" //Base Calculo FunRural
	cLinha += Str( 0 ,14,2) +";" //Aliquota FunRural
	cLinha += Str( 0 ,14,2) +";" //Valor FunRural
	cLinha += cEstOrigem +";"
	cLinha += ";" //Observacao
	cLinha += If(Left(SF1->F1_ESPECIE,3)=="CTR","08","01") +";"
	cLinha += "P" +";"
	cLinha += If(SF2->F2_FRETE>0,"1","2") +";" //Frete: 1-CIF / 2-FOB
	cLinha += ";" //Adicional ISS
	cLinha += "N;" //Cancelado
	cLinha += "N;" //Conciliado
	cLinha += ";" //Chave de Origem do Lancamento
	
	RecLock("TRBE",.t.)
	TRBE->LINHA	:= cLinha
	MsUnLock("TRBE")
	
	//Grava Informacoes Referente às CFOP
	For nCFOP := 1 to Len(aItemCFOP)
		RecLock("TRBE",.t.)
		TRBE->LINHA	:= aItemCFOP[nCFOP]
		MsUnLock("TRBE")
	Next nCFOP
	
	//Grava Informacoes dos Itens da NF
	For nItem := 1 to Len(aItemNF)
		RecLock("TRBE",.t.)
		TRBE->LINHA	:= aItemNF[nItem]
		MsUnLock("TRBE")
	Next nItem
	
	//Calcula a Porcentagem dos Centros de Custos
	For nCC := 1 to Len(aCenCusto)
		cLinha	:= "O;"
		cLinha	+= aCenCusto[nCC,1] +";"
		cLinha	+= Str( (aCenCusto[nCC,2] * 100) / SF1->F1_VALMERC , 6,2 ) +";" //Percentual
		//cLinha	+= Str( aCenCusto[nCC,2] , 14,2 ) +";" //Valor
		
		RecLock("TRBE",.t.)
		TRBE->LINHA	:= cLinha
		MsUnLock("TRBE")
		
	Next nCC
	
	SF1->(dbSkip())
	
EndDo

//Gera o Arquivo TXT
//1. Clientes/Fornecedores
For nPos := 1 to Len(aCliFor)
	cLinha	:= "A;"
	
	If aCliFor[nPos,1] == "SA1" //Clientes
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial("SA1") + aCliFor[nPos,2] + aCliFor[nPos,3] ) )
		
		cLinha	+= SA1->A1_NOME+";"
		cLinha	+= If(Len(AllTrim(SA1->A1_CGC))>11,"2","1") +";"
		cLinha	+= SA1->A1_CGC +";"
		cLinha	+= ";" //Logradouro
		cLinha	+= Left(SA1->A1_END,40) +";"
		cLinha	+= ";" //Numero
		cLinha	+= ";" //Complemento
		cLinha	+= Left(SA1->A1_BAIRRO,30) +";"
		cLinha	+= SA1->A1_EST +";"
		cLinha	+= Left(SA1->A1_MUN,50) +";"
		cLinha	+= SA1->A1_CEP +";"
		cLinha	+= SA1->A1_DDD +";"
		cLinha	+= Left(SA1->A1_TEL,13) +";"
		cLinha	+= If(SA1->A1_TIPO=="L","S","N") +";"
		cLinha	+= SA1->A1_INSCRUR +";"
		cLinha	+= SA1->A1_INSCR +";"
		cLinha	+= SA1->A1_EMAIL +";"
		cLinha	+= SA1->A1_HPAGE +";"
		cLinha	+= cEol
		
	Else //Fornecedores
		dbSelectArea("SA2")
		SA2->( dbSetOrder(1) )
		SA2->( dbSeek( xFilial("SA2") + aCliFor[nPos,2] + aCliFor[nPos,3] ) )
		
		cLinha	+= SA2->A2_NOME+";"
		cLinha	+= If(Len(AllTrim(SA2->A2_CGC))>11,"2","1") +";"
		cLinha	+= SA2->A2_CGC +";"
		cLinha	+= ";" //Logradouro
		cLinha	+= Left(SA2->A2_END,40) +";"
		cLinha	+= ";" //Numero
		cLinha	+= ";" //Complemento
		cLinha	+= Left(SA2->A2_BAIRRO,30) +";"
		cLinha	+= SA2->A2_EST +";"
		cLinha	+= Left(SA2->A2_MUN,50) +";"
		cLinha	+= SA2->A2_CEP +";"
		cLinha	+= SA2->A2_DDD +";"
		cLinha	+= Left(SA2->A2_TEL,13) +";"
		cLinha	+= "N;" //Produtor Rural
		cLinha	+= ";" //Inscr Prod Rural
		cLinha	+= SA2->A2_INSCR +";"
		cLinha	+= SA2->A2_EMAIL +";"
		cLinha	+= SA2->A2_HPAGE +";"
		cLinha	+= cEol
		
	EndIf
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
Next nPos

//2. Produtos
dbSelectArea("SB1")
SB1->(dbSetOrder(1))
For nPos := 1 to Len(aProdutos)
	SB1->(dbSeek( xFilial("SB1")+aProdutos[nPos] ))
	
	cLinha	:= "B;"
	cLinha	+= SM0->M0_CGC +";"
	cLinha	+= SB1->B1_COD +";"
	cLinha	+= SB1->B1_GRUPO +";"
	cLinha	+= Left(SB1->B1_DESC,50) +";"
	cLinha	+= SB1->B1_POSIPI +";" //Classificacao Fiscal
	cLinha	+= SB1->B1_UM +";"
	cLinha	+= cEol
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
Next nPos


//3. Notas e Informacoes (CFOP, Centro de Custo, etc...)
dbSelectArea("TRBE")
TRBE->(dbGoTop())
While TRBE->(!Eof())
	
	cLinha	:= TRBE->LINHA
	cLinha	+= cEol
	
	//Grava a Linha no Arquivo Texto
	fWrite(nHdl,cLinha,Len(cLinha))
	
	TRBE->(dbSkip())
EndDo

//Fecha arquivo texto
fClose(nHdl)

//Desfaz filtro do indregua
dbSelectArea("SF1")
RetIndex("SF1")
Set Filter to
For nI:=1 to Len(aInd)
	if File(aInd[nI]+OrdBagExt())
		Ferase(aInd[nI]+OrdBagExt())
	Endif
Next

Return

//Funcao Responsavel pela Criacao do Grupo de Perguntas
Static Function sfCriaPerg()
Local aRegistros := {}

aAdd(aRegistros,{cPerg,"01","Do Periodo            ?","Do Periodo            ?","Do Periodo            ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistros,{cPerg,"02","Ate Periodo           ?","Ate Periodo           ?","Ate Periodo           ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistros,{cPerg,"03","Tipos de Movimentos   ?","Tipos de Movimentos   ?","Tipos de Movimentos   ?","mv_ch3","N",01,0,1,"C","","mv_par03","Entradas","","","","","Saidas","","","","","Ambos","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegistros,{cPerg,"04","Gerar na Unidade      ?","Gerar na unidade      ?","Gerar na unidade      ?","mv_ch4","C",02,0,1,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

dbSelectArea("SX1")
For i:=1 to Len(aRegistros)
	If !dbSeek(cPerg+aRegistros[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegistros[i])
				FieldPut(j,aRegistros[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return

//Retorna a Especie Correta para Notas de Entrada
Static Function sfEntEspec(cEspExt)
Local cRet	:= ""

cEspExt	:= AllTrim(cEspExt)

If cEspExt = "CA"
	cRet := "CA"
ElseIf cEspExt = "CTR"
	cRet := "CTRC"
ElseIf cEspExt $ "NF_NFCEE_NFE_NFPS_NFST_NTST"
	cRet := "NF"
EndIf

Return cRet

//funcao que Adiciona as Notas Fiscais
Static Function sfNfCancelada()
Local vCFOP		:= {}
Local cNFCancel	:= ""

Local nIsenIPI	:= 0
Local nOutrIPI	:= 0

Local nValBrut	:= 0
Local nBasIPI	:= 0
Local nValIPI	:= 0

If Select("qNFC") != 0
	qNFC->(dbCloseArea())
EndIf

cQueryNF := "SELECT * FROM "+RetSqlName("SF3")+" SF3 "
cQueryNF += "WHERE F3_FILIAL = '"+xFilial("SF3")+"' "
cQueryNF += "AND F3_DTCANC != '"+Space(8)+"' AND F3_OBSERV = 'NF CANCELADA' "
cQueryNF += "AND F3_EMISSAO >= '"+DtoS(mv_par01)+"' AND F3_EMISSAO <= '"+DtoS(mv_par02)+"' "
cQueryNF += "AND D_E_L_E_T_ = '' "
cQueryNF += "ORDER BY F3_NFISCAL"

dbUseArea(.T., "TOPCONN", TCGENQRY(,,cQueryNF), "qNFC", .F., .T.)

dbSelectArea("qNFC")
qNFC->(dbGoTop())

cNFCancel	:= qNFC->F3_NFISCAL

While qNFC->(!Eof())
	
	nIsenIPI	+= qNFC->F3_ISENIPI
	nOutrIPI	+= qNFC->F3_OUTRIPI
	
	nValBrut	+= qNFC->F3_VALCONT
	nBasIPI		+= qNFC->F3_BASEIPI
	nValIPI		+= qNFC->F3_VALIPI
	
	//Grava Informacoes do Cabecalho da NF
	cLinha := "C;"
	cLinha += SM0->M0_CGC +";"
	cLinha += Posicione("SA1",1,xFilial("SA1")+ qNFC->F3_CLIEFOR + qNFC->F3_LOJA , "A1_CGC" ) +";"
	cLinha += qNFC->F3_NFISCAL +";"
	cLinha += qNFC->F3_NFISCAL +";"
	cLinha += qNFC->F3_ESPECIE +";"
	cLinha += qNFC->F3_SERIE +";"
	cLinha += ";" //Sub-Serie
	cLinha += DtoC(StoD(qNFC->F3_EMISSAO)) +";"
	cLinha += Str( nValBrut ,14,2) +";" //Valor Contabil
	cLinha += Str( nBasIPI  ,14,2) +";" //Base IPI
	cLinha += Str( nValIPI  ,14,2) +";" //Valor IPI
	cLinha += Str( nOutrIPI ,14,2) +";" //Valor Outras IPI
	cLinha += Str( nIsenIPI ,14,2) +";" //Valor Isentas IPI
	
	cLinha += If(!Empty(SA2->A2_INSCR),"S","N") +";" //Contrib ICMS ?
	cLinha += Str( 0 ,14,2) +";"
	cLinha += SM0->M0_ESTCOB +";"
	cLinha += SM0->M0_CIDCOB +";"
	cLinha += ";"//Observacao
	cLinha += "01;" //Tabela SINTEGRA
	cLinha += "P;"
	cLinha += "1;" //If(SF2->F2_FRETE>0,"1","2") +";" //Frete: 1-CIF / 2-FOB ////////REVER
	cLinha += ";" //Adicional ISS
	cLinha += "S;" //Cancelado
	cLinha += "N;" //Conciliado
	cLinha += ";" //Chave de Origem do Lancamento
	
	//--GRAVA A LINHA DO CFOP DA NOTA
	//Quando a condição de pagamento da nota for igual 040 vai mandar o cfop + 001 se não cfop + 002 (Gustavo)
	cLinhaCF	:= "D;"
	cLinhaCF	+= AllTrim(qNFC->F3_CFO) + "002;" //+ If(SF2->F2_COND=="040","001","002") +";" //REVER
	cLinhaCF	+= "1;"
	cLinhaCF	+= Str( 0 ,14,2) +";"
	cLinhaCF	+= Str( 0 ,14,2) +";"
	cLinhaCF	+= Str( 0 , 6,2) +";"
	cLinhaCF	+= Str( 0 ,14,2) +";"
	cLinhaCF	+= Str( 0 ,14,2) +";"
	cLinhaCF	+= Str( 0 ,14,2) +";"
	cLinhaCF	+= Str( 0 ,14,2) +";" //Valor Exclusao Adicional
	cLinhaCF	+= ";"
	
	//Adiciona Inforamacoes do CFOP
	aAdd( vCFOP , cLinhaCF )
	//--FIM LINHA CFOP
	
	
	qNFC->(dbSkip())
	
	If qNFC->F3_NFISCAL != cNFCancel
		
		//Grava no Arq Temporario o Cabecalho da Nota
		RecLock("TRBS",.t.)
		TRBS->LINHA	:= cLinha
		MsUnLock("TRBS")
		
		//Grava Informacoes Referente às CFOP
		For nCFOP := 1 to Len(vCFOP)
			RecLock("TRBS",.t.)
			TRBS->LINHA	:= vCFOP[nCFOP]
			MsUnLock("TRBS")
		Next nCFOP
		
		//Zera as Variaveis
		nIsenIPI	:= 0
		nOutrIPI	:= 0
		vCFOP		:= {}
		
		nValBrut	:= 0
		nBasIPI		:= 0
		nValIPI		:= 0
		
		cNFCancel	:= qNFC->F3_NFISCAL
	EndIf
	
EndDo

Return
