#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � RELISTCOB  � Autor � Flavio Dias         � Data �13/06/2011���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da relat�rio de listas de cobran�a de acordo com   ���
���a lista gerada                                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � RELISTCOB(void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Cantu                                                      ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RELISTCOB()

Local oReport   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If FindFunction("TRepInUse")
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef �Autor  �Alexandre Inacio Lemes �Data  �19.05.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emiss�o da rela��o de amarracao Produto X Fornecedor       ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oSection 
Local oCell
Local bPend := ({|| iif(ZZJ->ZZJ_STATUS == "01", 1, 0)})
Local bEfet := ({|| iif(ZZJ->ZZJ_STATUS == "02", 1, 0)})
Local bProrog := ({|| iif(ZZJ->ZZJ_STATUS == "03", 1, 0)})
Local bCanc := ({|| iif(ZZJ->ZZJ_STATUS == "04", 1, 0)})
Local bReag := ({|| iif(ZZJ->ZZJ_STATUS == "05", 1, 0)})
Local bNAtend := ({|| iif(ZZJ->ZZJ_STATUS == "06", 1, 0)})

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("RELISTCOB","Lista de cobran�a","RELISTCOB", {|oReport| ReportPrint(oReport)},;
			"Rela��o de listas de cobran�a"+" "+"Ser� impresso o relat�rio de listas de cobran�a de modo sint�tico ou anal�tico") //"Relacao de Amarracao Produtos x Fornecedor"##"Este programa tem como objetivo , relacionar os produtos e seus"##"respectivos Fornecedores."
AjustPerg("RELISTCOB")
Pergunte("RELISTCOB",.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oSection := TRSection():New(oReport,"Cabe�alho da Cobran�a",{"ZZI"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
//������������������������������������������������������������������������Ŀ
//�Criacao da celulas da secao do relatorio                                �
//�                                                                        �
//�TRCell():New                                                            �
//�ExpO1 : Objeto TSection que a secao pertence                            �
//�ExpC2 : Nome da celula do relat�rio. O SX3 ser� consultado              �
//�ExpC3 : Nome da tabela de referencia da celula                          �
//�ExpC4 : Titulo da celula                                                �
//�        Default : X3Titulo()                                            �
//�ExpC5 : Picture                                                         �
//�        Default : X3_PICTURE                                            �
//�ExpC6 : Tamanho                                                         �
//�        Default : X3_TAMANHO                                            �
//�ExpL7 : Informe se o tamanho esta em pixel                              �
//�        Default : False                                                 �
//�ExpB8 : Bloco de c�digo para impressao.                                 �
//�        Default : ExpC2                                                 �
//�                                                                        �
//��������������������������������������������������������������������������

oSection:SetHeaderPage()

TRCell():New(oSection,"ZZI_CODIGO","ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_NOMELI"   ,"ZZI",/*Titulo*/,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_STATUS"   ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_USUARI"  ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_DATAAT"   ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//oSection:SetNoFilter("ZZI")

oClientes := TRSection():New(oSection,"Clientes da Cobran�a",{"ZZJ"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oClientes,"ZZJ_SEQUEN","ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_CODCLI"   ,"ZZJ",/*Titulo*/,/*Picture*/, ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_LOJCLI"   ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_NOMECL"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_SALDO"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_STATUS"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_DATAAT"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_DATAPR"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_USUARI"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

// Faz os totalizadores
TRFunction():New(oClientes:Cell("ZZJ_SALDO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)

// Faz o c�lculo dos atendimentos
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Pendentes",/*cPicture*/,bPend,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Efetuados",/*cPicture*/,bEfet,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Prorogados",/*cPicture*/,bProrog,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Cancelados",/*cPicture*/,bCanc,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Reagendados",/*cPicture*/,bReag,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"N�o Atendidos",/*cPicture*/,bNAtend,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"COUNT",/*oBreak*/,"Total Atendimentos",/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)

oCliObs  := TRSection():New(oClientes,"Observa��o da Cobran�a",{"SA1"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
// N�o imprime o cabe�alho
oCliObs:SetHeaderBreak(.F.)

TRCell():New(oCliObs,"A1_X_OBCOB"  ,"SA1",/*Titulo*/,/*Picture*/,200,.F.,/*{|| code-block de impressao }*/)


oTitulos := TRSection():New(oClientes,"T�tulos do cliente",{""},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTitulos,"E1_MSEMP","SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_FILIAL"   ,"SE1TMP",/*Titulo*/,/*Picture*/, ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_TIPO"   ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_PREFIXO"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_NUM"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_PARCELA"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"DEMISSAO"  ,"    ","Emissao",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dEmissao })
TRCell():New(oTitulos,"DVENCTO"   ,"    ","Vencimento",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dVencto })
TRCell():New(oTitulos,"E1_SITUACA"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_X_SCOBR"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_SALDO"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oTitulos:Cell("E1_SITUACA"):SetCBox("0=Carteira;1=Cob.Simples;2=Descontada;3=Caucionada;4=Vinculada;5=Advogado;6=Judicial;7=Cob Caucao Descont")

// C�lculo do valor total dos t�tulos
TRFunction():New(oTitulos:Cell("E1_SALDO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)
// E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_VENCTO, E1_SITUACA, E1_X_SCOBR, E1_SALDO


Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin�Autor  �Alexandre Inacio Lemes �Data  �19/05/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Imprime o Relatorio definido pela funcao ReportDef MATR190. ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local oSection  := oReport:Section(1)
Local oCliente  := oSection:Section(1)
Local oCliObs   := oCliente:Section(1)
Local oTitulo   := oCliente:Section(2)
Local cCodLista  := ""


#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

Private dEmissao := dDataBase
Private dVencto := dDataBase

// Faz o c�lculo dos valores dos t�tulos em aberto


//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("ZZI")
dbSetOrder(2)
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Transforma parametros Range em expressao SQL                            �	
	//��������������������������������������������������������������������������
	MakeSqlExpr(oReport:uParam)
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	oReport:Section(1):BeginQuery()	
	
	cAliasZZI := GetNextAlias()
	
	BeginSql Alias cAliasZZI
	SELECT ZZI_CODIGO, ZZI_NOMELI, ZZI_STATUS, ZZI_USUARI, ZZI_DATAAT
	FROM %table:ZZI% ZZI
	WHERE 	ZZI_CODIGO >= %Exp:mv_par01% AND 
			ZZI_CODIGO <= %Exp:mv_par02% AND 
			LOWER(ZZI_USUARI) >= %Exp:Lower(mv_par03)% AND 
			LOWER(ZZI_USUARI) <= %Exp:Lower(mv_par04)% AND
			ZZI.%notDel%
		
	ORDER BY %Order:ZZI% 
			
	EndSql 
	//������������������������������������������������������������������������Ŀ
	//�Metodo EndQuery ( Classe TRSection )                                    �
	//�                                                                        �
	//�Prepara o relat�rio para executar o Embedded SQL.                       �
	//�                                                                        �
	//�ExpA1 : Array com os parametros do tipo Range                           �
	//�                                                                        �
	//��������������������������������������������������������������������������
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		
//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �				
//��������������������������������������������������������������������������
TRPosition():New(oSection,"ZZI",2,{|| xFilial("ZZI") + (cAliasZZI)->ZZI_CODIGO})
//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������

SE1->(dbSetOrder(01))
SA1->(dbSetOrder(01))

oReport:SetMeter(ZZI->(LastRec()))

oSection:Init()

dbSelectArea(cAliasZZI)
While !oReport:Cancel() .And. !(cAliasZZI)->(Eof())

	If oReport:Cancel()
		Exit
	EndIf
    
	oSection:PrintLine()
	ZZJ->(dbSetOrder(01))
	ZZJ->(dbSeek(xFilial("ZZJ") + (cAliasZZI)->ZZI_CODIGO))	
	
	oCliente:Init()
	While ZZJ->ZZJ_FILIAL + ZZJ->ZZJ_CODLIS == xFilial("ZZJ") + (cAliasZZI)->ZZI_CODIGO	
		
		If !( ZZJ->ZZJ_DATAAT >= mv_par08 .and. ZZJ->ZZJ_DATAAT <= mv_par09 .and. ZZJ->ZZJ_CODCLI >= mv_par10 .and.  ZZJ->ZZJ_CODCLI <= mv_par11 )
			ZZJ->(dbSkip())
			Loop
		EndIf
		
		oCliente:PrintLine()
		
		// Faz a impress�o dos dados de cobran�a
		If (MV_PAR06 == 1)
			oCliObs:Init()
			
			SA1->(dbSeek(xFilial("SA1") + ZZJ->ZZJ_CODCLI+ZZJ->ZZJ_LOJCLI))
			oCliObs:PrintLine()
			
			oCliObs:Finish()
		EndIf
		
		// Avalia se deve imprimir os t�tulos
		if mv_par05 == 1

			// Impress�o dos t�tulos
			oTitulo:Init()
			TitCliente(ZZJ->ZZJ_CODCLI, ZZJ->ZZJ_LOJCLI)
			
			// Faz o controle de impress�o do dos t�tulos
			While SE1TMP->(!Eof())
				dEmissao := StoD(SE1TMP->E1_EMISSAO)
				dVencto  := StoD(SE1TMP->E1_VENCTO)
				oTitulo:PrintLine()	
				
				SE1TMP->(dbSkip())
			EndDo
			
			oTitulo:Finish()
			
			SE1TMP->(dbCloseArea())
			
		EndIf
		
		If (mv_par06 == 1)
			oReport:ThinLine() 
			oReport:SkipLine()
			// oReport:FatLine()
		EndIf
		
		ZZJ->(dbSkip())
		
	EndDo
	oCliente:Finish()
    
	oReport:IncMeter()
	
	// Imprime uma linha para dividir antes de vir a pr�xima lista de cobran�a
	oReport:FatLine()
	
	DbSelectArea(cAliasZZI)
	DbSkip()
EndDo

(cAliasZZI)->(DbCloseArea())

oSection:Finish()

Return NIL

// Faz o ajuste das perguntas
Static Function AjustPerg(cPerg)
PutSx1(cPerg,"01","Lista de ?","Lista de ?","Lista de  ?", "mv_lde", "C", 6, 0, ,"G", "", "ZZI", "", "","MV_PAR01")
PutSx1(cPerg,"02","Lista ate ?","Lista ate ?","Lista ate  ?", "mv_lat", "C", 6, 0, ,"G", "", "ZZI", "", "","MV_PAR02")
PutSx1(cPerg,"03","Usuario de ?","Usuario de ?","Usuario de  ?", "mv_ude", "C", 15, 0, ,"G", "", "US3", "", "","MV_PAR03")
PutSx1(cPerg,"04","Usuario ate ?","Usuario ate ?","Usuario ate  ?", "mv_uat", "C", 15, 0, ,"G", "", "US3", "", "","MV_PAR04")
PutSx1(cPerg,"05","Imprimir Titulos ?","Imprimir Titulos ?","Imprimir Titulos  ?", "mv_iti", "N", 1, 0, ,"C", "", "", "", "","MV_PAR05","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"06","Imprimir Observa��o ?","Imprimir Observa��o ?","Imprimir Observa��o ?", "mv_iob", "N", 1, 0, ,"C", "", "", "", "","MV_PAR06","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"07","Baixas retroativas ?","Baixas retroativas ?","Baixas retroativas ?", "mv_pre", "N", 1, 0, ,"C", "", "", "", "","MV_PAR07","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"08","Atendimento de ?","Atendimento de ?","Atendimento de  ?", "mv_lde", "D", 6, 0, ,"G", "", "", "", "","MV_PAR08")
PutSx1(cPerg,"09","Atendimento ate ?","Atendimento ate ?","Atendimento ate  ?", "mv_lat", "D", 6, 0, ,"G", "", "", "", "","MV_PAR09")
PutSx1(cPerg,"10","Cliente de ?","Cliente de ?","Cliente de  ?", "mv_lde", "C", 6, 0, ,"G", "", "SA1", "", "","MV_PAR10")
PutSx1(cPerg,"11","Cliente ate ?","Cliente ate ?","Cliente ate  ?", "mv_lat", "C", 6, 0, ,"G", "", "SA1", "", "","MV_PAR11")

Return

// T�tulos do Cliente
// Busca com posi��o retroativa na data do atendimento da lista ou data atual
Static Function TitCliente(cCod, cLoja)
Local aEmps := {"30", "31", "50", "60", "70"}
Local nX
Local cSql:= ""
//For nX := 1 to len(aEmps)

	//cSql += iif(Empty(cSql), "", " UNION ")
  cSql += "SELECT '" + SubStr(retSqlName("SE1"),4,2) + "' AS E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, 
  cSql += " E1_VENCTO, E1_SITUACA, E1_X_SCOBR, E1_SALDO FROM " + retSqlName("SE1") + " WHERE "
  if (MV_PAR07 == 1)
	  cSql += "(E1_SALDO > 0 OR E1_BAIXA > '" + dToS(Iif(Empty(ZZI->ZZI_DATAAT), date() - 1, ZZI->ZZI_DATAAT - 1)) + "') "
	Else
		cSql += " E1_SALDO > 0 "
	EndIf
  cSql += " AND D_E_L_E_T_ <> '*' AND E1_CLIENTE = '" +cCod + "' AND E1_LOJA = '" + cLoja + "' "
  cSql += " AND E1_VENCREA <= '" + dToS(Iif(Empty(ZZI->ZZI_DATAAT), date() - 1, ZZI->ZZI_DATAAT - 1)) + "' "
  
//Next

TcQuery cSql New Alias "SE1TMP"

Return