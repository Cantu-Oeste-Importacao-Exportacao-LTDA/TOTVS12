#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
???Programa  ?          ? Autor ? Eder Gasparin Data ?         27/06/10   ???
?????????????????????????????????????????????????????????????????????????????
???Descricao ? Geração de arquivo para integração com armazem             ???
???          ? logístico NEMAG-Vinho                                      ???
?????????????????????????????????????????????????????????????????????????????
???Uso       ? 						                 ???
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

User Function expNemag()
Private cPerg := "EXPNEMAG"
ValidPerg(cPerg)      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !Pergunte(cPerg,.T.)
  Return
EndIf

if (MV_PAR04 == 1)
	GeraNFSai()
Else
	GeraNFEnt()
EndIf
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Fun??o    ? RUNCONT  ? Autor ? AP5 IDE            ? Data ?  08/03/10   ???
????????????????????????????????????????????????????????????????????????????
???Descri??o ? Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ???
???          ? monta a janela com a regua de processamento.               ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Programa principal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function GeraNFSai()

Local cNomeArq, cHeaderArq, cHeaderNF, cDetailNf, cTrailerNF, cTrailerArq, cHora
Local nQProd := 0
Local nQProdTot := 0
Local cData := DToS(MV_PAR02)
Local aCpos := {}
Local cSeq := SuperGetMV("MV_SQNEMAG", , "0000000")
Static nHdl := 0
cHora := time()
cExtensao := ".RET" //"ENT" para nf de entrada e "RET" para nf de saída (Verificar parametro )

cSeq := Soma1(cSeq)

CriaParametro()

cNomeArq := AllTrim(MV_PAR03) + "T" + cSeq + cExtensao

PutMv("MV_SQNEMAG",cSeq)

//Cria e abre arquivo texto
nHdl	:= fCreate(cNomeArq)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser criado! Verifique os parametros.","Atencao!")
	Return
Endif

// INICIO DAS NOTAS DE SAIDA
BeginSql Alias "TMPSF2"
	SELECT f2.f2_filial, f2.f2_doc, f2.f2_emissao, f2.f2_serie, f2.f2_valbrut, f2.f2_pbruto, 
               d2.d2_cod, d2.d2_quant, d2.D2_PRCVEN, f2.f2_cliente, f2.f2_loja, f2.f2_transp,
               D2_SEGUM, D2_QTSEGUM, C6_IMPUNI
	from %table:SF2% F2
	left join %table:SD2% D2 on f2_filial = d2_filial and f2_doc = d2_doc and d2_serie = f2_serie
	left join %table:SC6% C6 ON d2_filial = c6_filial and d2_pedido = c6_num and d2_itempv = c6_item	
	where F2.D_E_L_E_T_ <> '*' AND D2.D_E_L_E_T_ <> '*' and C6.D_E_L_E_T_ <> '*'
	and f2_emissao >= %Exp:DTOS(MV_PAR01)%
	and f2_emissao <= %Exp:DTOS(MV_PAR02)%
	and f2_filial = %xFilial:SF2%
	order by f2_filial, f2_doc, f2_serie, d2_item
EndSql

aDbf := {}
Aadd(aDbf, {"F2_OK", "C", 2, 0})
//Aadd(aDbf, {"F2_FILIAL", "C", 2, 0})
Aadd(aDbf, {"F2_DOC", "C", 6, 0})
Aadd(aDbf, {"F2_SERIE", "C", 3, 0})
Aadd(aDbf, {"F2_CLIENTE", "C", 6, 0})
Aadd(aDbf, {"F2_LOJA", "C", 2, 0})

cArq    := CriaTrab(aDbf, .T.)

Use (cArq) Alias TMPSQL Shared New


TMPSF2->(DbGotop())
cChaveNF := ""
dbSelectArea("TMPSQL")
While TMPSF2->(!Eof())
	if(cChaveNF <> TMPSF2->F2_DOC+TMPSF2->F2_SERIE)
	  RecLock("TMPSQL", .T.)
//	  F2_FILIAL := TMPSF2->F2_FILIAL
	  F2_DOC := TMPSF2->F2_DOC
	  F2_SERIE := TMPSF2->F2_SERIE
	  F2_CLIENTE := TMPSF2->F2_CLIENTE
	  F2_LOJA := TMPSF2->F2_LOJA
	  MsUnlock()
	  cChaveNF := TMPSF2->F2_DOC+TMPSF2->F2_SERIE
	EndIf
	TMPSF2->(DbSkip())
EndDo

cArqInd := CriaTrab(NIL, .F.)

//controla o indice da tabela temporaria
IndRegua("TMPSQL", cArqInd, "f2_doc+f2_serie",,, "Selecionando Registros...")

cMarca := GetMark(,"TMPSQL", "F2_OK")

// Montagem dos campos do MBrowse
AAdd(aCpos, {"F2_OK", ,"", "@!"})
//AAdd(aCpos, {"F2_FILIAL", , "Filial", "@!"} )
AAdd(aCpos, {"F2_DOC", , "Nota Fiscal", "@!"})
AAdd(aCpos, {"F2_SERIE", , "Série", "@!"})
AAdd(aCpos, {"F2_CLIENTE", , "Cliente", "@!"})
AAdd(aCpos, {"F2_LOJA", , "Loja", "@!"})

linverte := .F.

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecione as Notas Fiscais"
//@ 001,001 TO 170,350 BROWSE oBrw Alias "TMPSQL" MARK "F2_OK" 
oMark := MsSelect():New("TMPSQL",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,350})
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
@ 180,310 BMPBUTTON TYPE 01 ACTION (Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
         
// traz os documentos que estao marcados
aDocs := {}
dbSelectArea("TMPSQL")
TMPSQL->(dbGoTop())
While TMPSQL->(!Eof())
	if IsMark("F2_OK", ThisMark(), ThisInv()) // Marcado("TMPSQL", "F2_OK",cMarca,lInverte)
		aAdd(aDocs, TMPSQL->F2_DOC + TMPSQL->F2_SERIE)
	endIf
	TMPSQL->(dbSkip())
EndDo
     
// apaga os arquivos temporários
TMPSQL->(dbCloseArea())
if File(cArqInd+OrdBagExt())
	Ferase(cArqInd+OrdBagExt()) // arquivo de indice
EndIF

If File(cArq+GetDBExtension())                              
	FErase(cArq+GetDBExtension())    //arquivo de trabalho
Endif

dbSelectArea("TMPSF2")
ProcRegua(RecCount())
TMPSF2->(DbGotop())
While TMPSF2->(!Eof())
//Saidas
IncProc()

cHeaderArq := "0" 			// Indicador
cTransp := Posicione("SA4", 01, xFilial("SA4") + iif(Empty(MV_PAR07), TMPSF2->F2_TRANSP, MV_PAR07), "A4_CGC")

While Empty(cTransp)
	Alert("Transportador não informada. Informe o transportador!")
	Pergunte(cPerg,.T.)
	cTransp := Posicione("SA4", 01, xFilial("SA4") + iif(Empty(MV_PAR07), TMPSF2->F2_TRANSP, MV_PAR07), "A4_CGC")
EndDo

cHeaderArq += PadR(cTransp, 15, ' ') // CNPJ da Transportadora

SA1->(dbSetOrder(01))
	
Write(cHeaderArq)
cChaveNF := ""
While !TMPSF2->(Eof())	         
	
	// verifica se está marcado
	if aScan(aDocs, TMPSF2->F2_DOC + TMPSF2->F2_SERIE) == 0
		TMPSF2->(DbSkip())
		Loop
	EndIf
	
	if (cChaveNF <> TMPSF2->F2_DOC + TMPSF2->F2_SERIE)
		// seta o cabeçalho da NF Nova
		if !Empty(TMPSF2->F2_DOC)
			cHeaderNF := "1" 			// Indicador
			cHeaderNF += TMPSF2->f2_doc	 	// Nro. Nota Fiscal
			SA1->(DbSeek(xFilial("SA1") + TMPSF2->F2_CLIENTE + TMPSF2->F2_LOJA)) 
			cHeaderNF += SA1->A1_CGC 		// CNPJ Cliente
			cHeaderNF += SUBSTR(SA1->A1_NOME, 1, 40)	// Nome do Cliente
			cHeaderNF += SUBSTR(SA1->A1_END, 1, 40)		// Endereço do Cliente
			cHeaderNF += PADR(SUBSTR(SA1->A1_MUN, 1, 30), 30, ' ')		// Municipio do Cliente
			cHeaderNF += SA1->A1_EST		// Estado do cliente
			cHeaderNF += SA1->A1_CEP		// Cep do Cliente
			cHeaderNF += Replicate(' ', 4) // Regiao do cliente
			cHeaderNF += PADR(AllTrim(SA1->A1_INSCR), 18, ' ')	// Inscrição estadual do Cliente
			cHeaderNF += Replicate('0', 4) // Número de volumes
			cHeaderNF += Replicate('0', 4) // Metragem cúbica
			cHeaderNF += PadL(Transform(TMPSF2->f2_pbruto, "@E 99999"), 5, '0') // peso bruto			
			cHeaderNF += PadL(Transform(TMPSF2->f2_valbrut * 100, "@E 9999999999"), 10, '0')	// Valor total da nota
			cHeaderNF += TMPSF2->f2_serie	// Serie da Nota Fiscal
			cHeaderNF += Replicate(' ', 3) + Replicate('0', 16)+ "NN" + Replicate('0', 7)// Estab + Data Ent + Peso c/ decimais + supermercados  + met cubica
			cHeaderNF += Replicate(' ', 30) + '00' + Replicate(' ', 32) + Replicate('0', 95)
			cEmiss := TMPSF2->F2_EMISSAO
			cHeaderNF += SubStr(cEmiss, 7, 2) + SubStr(cEmiss, 5, 2) + SubStr(cEmiss, 1, 4)// Emissao da NF
			
			Write(cHeaderNF)
		EndIf
		nQProd := 0
	EndIf
	
	cChaveNF := TMPSF2->F2_DOC + TMPSF2->F2_SERIE
	
	// Aceita somente valores inteiros
	nQtd := if(TMPSF2->C6_IMPUNI == "2", TMPSF2->D2_QTSEGUM,TMPSF2->D2_QUANT)
	nQtd := Round(nQtd, 0) * 1000
	
	cDetailNF := "2"
	cDetailNF += PadR(TMPSF2->D2_COD, 20, ' ')	 	// Código do Produto
	cDetailNF += PadL(AllTrim(Transform(nQtd, "@E 99999999999")), 11, '0')// Quantidade	
	cDetailNF += Replicate(' ', 3) // Complemento
	cDetailNF += Replicate(' ', 10) // Lote
	cDetailNF += PadR('CANTU',15) // Depositante
	
	Write(cDetailNF)
	
	// Totalizadores
	nqProd += nQtd
	nQProdTot += nQtd
	
	TMPSF2->(DbSkip())
	
	if (cChaveNF <> TMPSF2->F2_DOC + TMPSF2->F2_SERIE)		
		// seta a quantidade de NFS
		cTrailerNF := "3" 			// Indicador
		cTrailerNF += PadL(AllTrim(Transform(nQProd, "@E 999999999999")), 12, '0')			 	// Total das quantidade da nota
		Write(cTrailerNF)
	EndIf
EndDo

cTrailerArq:= "9" 			// Indicador
cTrailerArq+= PadL(AllTrim(Transform(nQProdTot, "@E 999999999999")), 12, '0')	// Total das quantidades de todas as notas

Write(cTrailerArq)
FClose(nHdl)
EndDo

TMPSF2->(DbCloseArea())

Return Nil

// Função que escreve cada linha do arquivo
Static Function Write(cLin)
cEOL    := "CHR(13)+CHR(10)"
cEOL	:= &cEOL
cLin += cEOL
If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		Break
	Endif
Endif

Return Nil


/*****************************************************************
 Geração das NFs de Entrada
 ****************************************************************/
Static Function GeraNFEnt()
Local cNomeArq, cHeaderArq, cHeaderNF, cDetailNf, cTrailerNF, cTrailerArq, cHora
Local nQProd := 0
Local nQProdTot := 0
Local cData := DToS(MV_PAR02)
Local aCpos := {}
Local cSeq := SuperGetMV("MV_SQNEMAG", , "0000000")
Static nHdl := 0
cHora := time()
cExtensao := ".ENT" //"ENT" para nf de entrada e "RET" para nf de saída (Verificar parametro )

//cNomeArq := AllTrim(MV_PAR03) + "T" + substr(cData, 7, 2) + SubStr(cData, 5, 2) + SubStr(cData, 3, 2) + SubStr(cHora,1,1) + cExtensao

cSeq := Soma1(cSeq)

CriaParametro()

cNomeArq := AllTrim(MV_PAR03) + "T" + cSeq + cExtensao

PutMv("MV_SQNEMAG",cSeq)

//Cria e abre arquivo texto
nHdl	:= fCreate(cNomeArq)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cNomeArq+" nao pode ser criado! Verifique os parametros.","Atencao!")
	Return
Endif

// INICIO DAS NOTAS DE ENTRADA
BeginSql Alias "TMPSF1"
	SELECT f1.f1_filial, f1.f1_DOC, f1.f1_emissao, f1.f1_serie, f1.f1_fornece, f1.f1_loja,
               d1.d1_cod, d1.d1_quant, d1.d1_vunit, f1.f1_transp
	from %table:SF1% F1
	left join %table:SD1% D1 on f1_filial = d1_filial and f1_doc = d1_doc and d1_serie = f1_serie and f1_fornece = d1_fornece and f1_loja = d1_loja        
	where F1.D_E_L_E_T_ <> '*' AND D1.D_E_L_E_T_ <> '*'
	and f1_emissao >= %Exp:DTOS(MV_PAR01)%
	and f1_emissao <= %Exp:DTOS(MV_PAR02)%
	and f1_filial = %xFilial:SF1%
	and f1_tipo = 'N'
	order by f1_filial, f1_doc, f1_serie, f1_fornece, f1_loja, d1_cod
EndSql
                      
aDbf := {}
Aadd(aDbf, {"F1_OK", "C", 2, 0})
//Aadd(aDbf, {"F2_FILIAL", "C", 2, 0})
Aadd(aDbf, {"F1_DOC", "C", 6, 0})
Aadd(aDbf, {"F1_SERIE", "C", 3, 0})
Aadd(aDbf, {"F1_FORNECE", "C", 6, 0})
Aadd(aDbf, {"F1_LOJA", "C", 2, 0})

cArq    := CriaTrab(aDbf, .T.)

Use (cArq) Alias TMPSQL Shared New


TMPSF1->(DbGotop())
cChaveNF := ""
dbSelectArea("TMPSQL")
While TMPSF1->(!Eof())
	if(cChaveNF <> TMPSF1->F1_DOC+TMPSF1->F1_SERIE+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA)
	  RecLock("TMPSQL", .T.)
//	  F1_FILIAL := TMPSF1->F2_FILIAL
	  F1_DOC := TMPSF1->F1_DOC
	  F1_SERIE := TMPSF1->F1_SERIE
	  F1_FORNECE := TMPSF1->F1_FORNECE
	  F1_LOJA := TMPSF1->F1_LOJA
	  MsUnlock()
	  cChaveNF := TMPSF1->F1_DOC+TMPSF1->F1_SERIE+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA
	EndIf
	TMPSF1->(DbSkip())
EndDo

cArqInd := CriaTrab(NIL, .F.)

//controla o indice da tabela temporaria
IndRegua("TMPSQL", cArqInd, "F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA",,, "Selecionando Registros...")

cMarca := GetMark(,"TMPSQL", "F1_OK")

// Montagem dos campos do MBrowse
AAdd(aCpos, {"F1_OK", ,"", "@!"})
//AAdd(aCpos, {"F2_FILIAL", , "Filial", "@!"} )
AAdd(aCpos, {"F1_DOC", , "Nota Fiscal", "@!"})
AAdd(aCpos, {"F1_SERIE", , "Série", "@!"})
AAdd(aCpos, {"F1_FORNECE", , "Fornecedor", "@!"})
AAdd(aCpos, {"F1_LOJA", , "Loja", "@!"})

linverte := .F.

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecione as Notas Fiscais"
//@ 001,001 TO 170,350 BROWSE oBrw Alias "TMPSQL" MARK "F2_OK" 
oMark := MsSelect():New("TMPSQL",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,350})
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
@ 180,310 BMPBUTTON TYPE 01 ACTION (Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
         
// traz os documentos que estao marcados
aDocs := {}
dbSelectArea("TMPSQL")
TMPSQL->(dbGoTop())
While TMPSQL->(!Eof())
	if IsMark("F1_OK", ThisMark(), ThisInv()) // Marcado("TMPSQL", "F2_OK",cMarca,lInverte)
	  aAdd(aDocs, TMPSQL->F1_DOC+TMPSQL->F1_SERIE+TMPSQL->F1_FORNECE+TMPSQL->F1_LOJA)
	endIf
	TMPSQL->(dbSkip())
EndDo
     
// apaga os arquivos temporários
TMPSQL->(dbCloseArea())
if File(cArqInd+OrdBagExt())
	Ferase(cArqInd+OrdBagExt()) // arquivo de indice
EndIF

If File(cArq+GetDBExtension())
	FErase(cArq+GetDBExtension())    //arquivo de trabalho
Endif

///////////////////////////////////////////////////

dbSelectArea("TMPSF1")
TMPSF1->(dbGoTop())
ProcRegua(RecCount()) 
/*HEADER ( Arquivo )
Campo					Formato		Posição			Obrig.
Indicador				'0' (Fixo)	1     -    1	X
Flag de Alteração (*)	X(01)		2     -    2	
Referência Anterior (**)X(08)		3     -   10	
CNPJ Fornecedor			9(14)		11   -   24	
Nome Fornecedor			X(50)		25   -   74	*/
cHeaderArq := "0" 			// Indicador
cHeaderArq += " " 			// Flag de alteração
cHeaderArq += PadR(SubStr(MV_PAR06, 7), 7, ' ')	        // Referencia ao nome do arquivo anterior
SA2->(DbSetOrder(01))
SA2->(DbSeek(xFilial("SA2") + TMPSF1->f1_fornece + TMPSF1->f1_loja))
cHeaderArq += PadL(AllTrim(SA2->A2_CGC), 14, '0')		// CNPJ Fornecedor
cHeaderArq += PadR(SubStr(SA2->A2_NOME, 1, 50), 50, ' ')	    // Nome Fornecedor
Write(cHeaderArq)

cChaveNF := ""
While !TMPSF1->(Eof())

  // avalia se deve ou nao processar a nota de entrada
  // verifica se está marcado
	if aScan(aDocs, TMPSF1->F1_DOC+TMPSF1->F1_SERIE+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA) == 0
		TMPSF1->(DbSkip())
		Loop
	EndIf	         
	
	if (cChaveNF <> TMPSF1->F1_DOC + TMPSF1->F1_SERIE + TMPSF1->F1_FORNECE + TMPSF1->F1_LOJA)
		// seta o cabeçalho da NF Nova
		/*HEADER ( N.F. )
		Campo					Formato		Posição			Obrig.
		Indicador				'1' (Fixo)	1     -    	1	X
		Número da Nota Fiscal	9(6)		2     -    	7	X
		Emissão da Nota Fiscal	DDMMAAAA	8    -   	15	X 	(*)
		Série da Nota Fiscal	X(3)		16  -   	18	X 	(*)
		No. NF. Eletrônica (**)	9(9)		19  -   	27	*/
		if !Empty(TMPSF1->F1_DOC)
			cHeaderNF := "1" 			// Indicador
			cHeaderNF += TMPSF1->F1_DOC	 	// Nro. Nota Fiscal
			cEmiss := TMPSF1->F1_EMISSAO
			cHeaderNF += SubStr(cEmiss, 7, 2) + SubStr(cEmiss, 5, 2) + SubStr(cEmiss, 1, 4) 	// Emissao
			cHeaderNF += TMPSF1->F1_SERIE	// Serie da Nota Fiscal
//			cHeaderNF += Replicate('0', 9)	// No. NF. Eletrônica
			Write(cHeaderNF)
		EndIf
		nQProd := 0
	EndIf
	
	cChaveNF := TMPSF1->F1_DOC + TMPSF1->F1_SERIE + TMPSF1->F1_FORNECE + TMPSF1->F1_LOJA
	/*
	Campo  				Formato		Posição			Obrig.
	Indicador			'2' (Fixo)	1     -      1	X
	Código do Produto	X(20)		2     -    21	X
	Quantidade			9(8)V9(3)	22   -    32	X
	Lote				X(10)		33   -    42	
	Complemento			X(3)		43   -    45	
	Data de Validade	DDMMAAAA	46   -    53	
	Depositante			X(15)		54   -    68	X
	Preço Unitário		9(7)V9(2)	69   -    77	X (*)*/	
	
	cDetailNF := "2" 			// Indicador
	cDetailNF += PadR(TMPSF1->D1_COD, 20, ' ')	 	// Código do Produto
	cDetailNF += PadL(AllTrim(Transform(TMPSF1->D1_QUANT * 1000, "@E 99999999999")), 11, '0')// Quantidade
	cDetailNF += Replicate(' ', 10) // Lote
	cDetailNF += Replicate(' ', 3) // Complemento
	cDetailNF += Replicate(' ', 8) // Data de validade
	//cDetailNF += SM0->M0_CGC + ' ' // Depositante
	cDetailNF += PadR("CANTU", 15)//SM0->M0_CGC + ' ' // Depositante
	cDetailNF += PadL(AllTrim(Transform(TMPSF1->d1_vunit * 100, "@E 999999999")), 9, '0')// Valor Unitário
	// cDetailNF += " " // Prédio
	// cDetailNF += "   " // Rua
	// cDetailNF += "   " // Bloco
	// cDetailNF += "   " // Apto
	// Preco Uni com 6 casas decimais
	// cDetailNF += PadL(AllTrim(Transform(TMPSF2->D2_PRCVEN * 1000000, "@E 9999999999999")), 13, '0')
	// cDetailNF += Replicate(' ', 10) // Complemento
	Write(cDetailNF)
	
	// Totalizadores
	nqProd += TMPSF1->D1_QUANT
	nQProdTot += TMPSF1->D1_QUANT
	
	TMPSF1->(DbSkip())
	
	if (cChaveNF <> TMPSF1->F1_DOC + TMPSF1->F1_SERIE + TMPSF1->F1_FORNECE + TMPSF1->F1_LOJA)		
		// seta a quantidade de NFS
		cTrailerNF := "3" 			// Indicador
		cTrailerNF += PadL(AllTrim(Transform(nQProd * 1000, "@E 999999999999")), 12, '0')			 	// Total das quantidade da nota
		Write(cTrailerNF)
	EndIf
EndDo

cTrailerArq:= "9" 			// Indicador
cTrailerArq+= PadL(AllTrim(Transform(nQProdTot * 1000, "@E 999999999999")), 12, '0')	// Total das quantidades de todas as notas

Write(cTrailerArq)

FClose(nHdl)
TMPSF1->(DbCloseArea())

/*IncProc()
cHeaderArq := "0" 			// Indicador
cTransp := Posicione("SA4", 01, xFilial("SA4") + TMPSF1->F1_TRANSP, "A4_CGC")
cHeaderArq += PadR(cTransp, 15, ' ') // CNPJ da Transportadora
	
cHeaderNF := "1" 			// Indicador
cHeaderNF += cAliasTmp->f2_doc	 	// Nro. Nota Fiscal
cHeaderNF += cAliasTmp->a1_cgc 		// CNPJ Cliente
cHeaderNF += cAliasTmp->a1->nome	// Nome do Cliente
cHeaderNF += cAliasTmp->a1->end		// Endereço do Cliente
cHeaderNF += cAliasTmp->a1->mun		// Municipio do Cliente
cHeaderNF += cAliasTmp->a1->est		// Estado do cliente
cHeaderNF += cAliasTmp->a1->cep		// Cep do Cliente
cHeaderNF += cAliasTmp->a1->inscr	// Inscrição estadual do Cliente
cHeaderNF += cAliasTmp->f2->valbrut	// Valor total da nota
cHeaderNF += cAliasTmp->f2->serie	// Serie da Nota Fiscal
cHeaderNF += cAliasTmp->f2->pbruto	// Peso total da nota
cHeaderNF += cAliasTmp->f2->emissao	// Data de emissao

cDetailNF := "2" 			// Indicador
cDetailNF += cAliasTmp->d2_doc	 	// Código do Produto
cDetailNF += cAliasTmp->d2_quant 	// Quantidade
cDetailNF += cAliasTmp->d1_vunit 	// Valor Unitário

cTrailerNF := "3" 			// Indicador
cTrailerNF += cAliasTmp-> qtdVol			 	// Total das quantidade da nota

cTrailerArq:= "3" 			// Indicador
cTrailerArq+= 				// Total das quantidades de todas as notas*/


Return Nil

Static Function ValidPerg(cPerg)
cPerg := PADR(cPerg, Len(SX1->X1_GRUPO))
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Data Inicial  ","Data Inicial","Data Inicial","mv_ch1","D",08,0,0,"G","","MV_PAR01")
PutSx1(cPerg,"02","Data Final    ","Data Final","Data Final","mv_ch2","D",08,0,0,"G","","MV_PAR02")
PutSx1(cPerg,"03","Diretorio  ","Diretorio","Diretorio","mv_ch3","C",30,0,0,"G","","MV_PAR03")
PutSx1(cPerg,"04","Tipo de NF","Tipo de NF","Tipo de NF", "mv_ch4", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR04","Saida","Saida","Saida", "","Entrada","Entrada","Entrada")
PutSx1(cPerg,"05","Tipo Envio","Tipo Envio","Tipo Envio", "mv_ch5", "N", 1, 0, 0,"C", "", "", "", "","MV_PAR05","Inclusao","Inclusao","Inclusao", "","Cancela","Cancela","Cancela")
PutSx1(cPerg,"06","Arq. Anterior","Arq. Anterior?","Arq. Anterior ?", "mv_ch6", "C",30,0,0,"G","", "", "", "","MV_PAR06")
PutSx1(cPerg,"07","Transportador","Transportador","Transportador", "mv_ch6", "C",6,0,0,"G","", "SA4", "", "","MV_PAR07")
Return

static function CriaParametro()
dbSelectArea("SX6")
dbSetOrder(01)
if !dbSeek("  MV_SQNEMAG")
	RecLock("SX6", .T.)
	SX6->X6_FIL := "  "
	SX6->X6_VAR := "MV_SQNEMAG"
	SX6->X6_TIPO := "C"
  SX6->X6_DESCRIC := "Sequencia de geracao de arquivos para integracao"
  SX6->X6_DESC1   := "com o software Nemag, customizacao para o vinho  "
	SX6->X6_CONTEUD := "0000001"
  SX6->X6_PROPRI  := "S"
  SX6->X6_PYME    := "S"
  MsUnLock()
EndIf
Return nil