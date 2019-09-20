#INCLUDE "MATR580.CH"
#Include "FIVEWIN.Ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR580  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estatistica de Venda por Ordem de Vendedor                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR580(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar Indexacao com vendedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ BRUNO        ³18/11/98³XXXXXX³Tratamento dos impostos para localizaco-³±±
±±³              ³        ³      ³es no exterior.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Viviani      ³19/11/98³18137 ³Acerto do MV_PAR09 e MV_PAR08 que esta- ³±±
±±³              ³        ³      ³vam invertidos em cDupli e cEstoq       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Viviani      ³25/11/98³Melhor³Acrescimo do xMoeda p/ conversao.       ³±±
±±³ Edson        ³30/03/99³xxxxxx³Passar tamanho na SetPrint.             ³±±
±±³ Marcello     ³26/08/00³oooooo³Impressao de casas decimais de acordo   ³±±
±±³              ³        ³      ³com a moeda selecionada.                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FATVENLIQ()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt  := ""
Local titulo := OemToAnsi(STR0001)	//"Faturamento por Vendedor"
Local cDesc1 := OemToAnsi(STR0002)	//"Este relatorio emite a relacao de faturamento. Podera ser"
Local cDesc2 := OemToAnsi(STR0003)	//"emitido por ordem de Cliente ou por Valor (Ranking).     "
Local CbCont,cabec1,cabec2,wnrel
Local tamanho:="M"
Local limite :=132
Local cString:="SF2"
Local lContinua := .T.
Local cMoeda,nMoeda
Local cNFiscal

PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="FATVENLIQ"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="MTR580"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR580",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01         // A partir da data                         ³
//³ mv_par02         // Ate a data                               ³
//³ mv_par03         // Do Vendedor                              ³
//³ mv_par04         // Ao Vendedor                              ³
//³ mv_par05         // Ordem (decrescente)?                     ³
//³ mv_par06         // Moeda                                    ³
//³ mv_par07         // Inclui Devolu‡„o                         ³
//³ mv_par08         // TES Qto Faturamento                      ³
//³ mv_par09         // TES Qto Estoque                          ³
//³ mv_par10         // Converte a moeda da devolucao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "FATVENLIQ"            //Nome Default do relatorio em Disco
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C580Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C580IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR580			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C580Imp(lEnd,WnRel,cString)

Local titulo := OemToAnsi(STR0001)		//"Faturamento por Vendedor"


Local CbCont,cabec1,cabec2
Local tamanho:="P"


Local aCampos := {}
Local aCmpDup := {}
Local aTam	  := {}
Local nAg1:=0,nAg2:=0,nAg3:=0,nRank:=0,nAg4:=0,cVend
Local nTotVTab := 0, nTotVVend := 0
Local nMoeda, cMoeda:="" 
Local cEstoq := If( (MV_PAR09 == 1),"S",If( (MV_PAR09 == 2),"N","SN" ) )
Local cDupli := If( (MV_PAR08 == 1),"S",If( (MV_PAR08 == 2),"N","SN" ) )

Private aTamVal:= { 16, 2 }

Private nDecs:=msdecimais(mv_par06)
Private nPrzMedTot := 0
Private nPrzMedPrTot := 0

nTipo:=IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
nMoeda := mv_par06
cMoeda := GetMv("MV_MOEDA"+LTrim(STR(nMoeda)))

titulo := OemToAnsi("FATURAMENTO POR VENDEDOR")

cabec1 := OemToAnsi("CODIGO  NOME DO VENDEDOR                                Valor   Desconto  Prazo    Prazo")
cabec2 := OemToAnsi("                                                        Venda    Médio  Realizado Previsto")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTam:=TamSX3("F2_VEND1")
AADD(aCampos,{ "TB_VEND"   ,"C",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_EMISSAO")
AADD(aCampos,{ "TB_EMISSAO","D",aTam[1],aTam[2] } )
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR1 ","N",aTam[1],aTam[2] } ) // valor total sem icms
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR2 ","N",aTam[1],aTam[2] } ) // valor total
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR3 ","N",aTam[1],aTam[2] } ) // total mais ipi
aTam:=TamSX3("F2_VALFAT")
AADD(aCampos,{ "TB_VALOR4 ","N",aTam[1],aTam[2] } ) // valor limpo

AADD(aCampos,{ "TB_VALTAB ","N",aTam[1],aTam[2] } ) // valor de tabela

AADD(aCampos,{ "TB_DESCME ","N",6,2 } )

aTam:=TamSX3("F2_DESPEZA")
AADD(aCampos,{ "TB_PRAZO  ", "N",8,2 } )
AADD(aCampos,{ "TB_PRAZOPR", "N",8,2 } )

aTam:=TamSX3("F2_DOC")
AADD(aCampos,{ "TB_DOC    ","C",aTam[1],aTam[2] } )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq 	:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomArq,"TRB", .T. , .F. )
cNomArq1 := Subs(cNomArq,1,7)+"A"
IndRegua("TRB",cNomArq1,"TB_VEND",,,STR0011)		//"Selecionando Registros..."
aTamVal 	:= TamSX3("F2_VALFAT")
cNomArq2 := Subs(cNomArq,1,7)+"B"
IndRegua("TRB",cNomArq2,"(STRZERO(TB_VALOR3,aTamVal[1],aTamVal[2]))",,,STR0011)		//"Selecionando Registros..."
dbClearIndex()
dbSetIndex(cNomArq1+OrdBagExt())
dbSetIndex(cNomArq2+OrdBagExt())

// criacao do arquivo de duplicatas
AADD(aCmpDup,{ "DP_VALOR ","N",16,2 } )
AADD(aCmpDup,{ "DP_PRAZO ","N",8,2 } )
AADD(aCmpDup,{ "DP_PRAZOP","N",8,2 } )
AADD(aCmpDup,{ "DP_VEND  ","C",6,0 } )

cNomArq 	:= CriaTrab(aCmpDup,.T.)
dbUseArea( .T.,, cNomArq,"DUP", .T. , .F. )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrab(cEstoq,cDupli)

dbSelectArea("TRB")
SetRegua(LastRec())
If ( MV_PAR05 = 2 )
	dbSetOrder(2)
Else
	dbSetOrder(1)
EndIF
dbGoBottom()
cNFiscal := TB_DOC
While !Bof()
	
	IF lEnd
		@Prow()+1,001 PSAY STR0012		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	IncRegua()
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	cVend := TB_VEND
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se ‚ venda sem vendedor                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !Empty( cVend )
		dbSelectArea("SA3")
		dbSeek(xFilial()+cVend)
		
		@li,00 PSAY A3_COD + " " +Left(A3_NOME,40)
	ELSE
		@li,00 PSAY "******" + " " + STR0013	//"Venda Sem Vendedor"
	ENDIF
	
	dbSelectArea("TRB")
	/*
	@li,050 PSAY TB_VALOR1 PicTure tm(TB_VALOR1,14,nDecs)	
	@li,066 PSAY TB_VALOR2 PicTure tm(TB_VALOR2,14,nDecs)
	@li,082 PSAY TB_DESCME PicTure "@E 99.99"
	@li,098 PSAY TB_PRAZO  PicTure "@E 999.99"
	@li,120 PSAY ((TB_VALOR3-TB_VALOR4)*100)/TB_VALOR3 PicTure "999.99"*/
	
	@li,050 PSAY TB_VALOR2 PicTure tm(TB_VALOR2,14,nDecs)
	@li,066 PSAY TB_DESCME PicTure "@E 99.99"
	@li,074 PSAY TB_PRAZO  PicTure "@E 999.99"
	@li,082 PSAY TB_PRAZOPR  PicTure "@E 999.99"
	
	
	nTotVTab += TB_VALTAB
	nTotVVend += TB_VALOR2

	IF mv_par05 == 2
		nRank++
	//	@li,111 PSAY nRank	PicTure "9999"
	EndIF
	li++
	/*
	nAg1 := nAg1 + TB_VALOR1
	nAg2 := nAg2 + TB_VALOR2
	nAg3 := nAg3 + TB_VALOR3
	nAg4 := nAg4 + TB_VALOR4	
	cNFiscal := TB_DOC*/
	dbSkip(-1)
EndDo                                                    
@li, 000 PSAY Replicate("_",80)
li++
IF li != 80
	@li, 000 PSAY "T O T A L --->"
	/*
	@li, 050 PSAY nAg1 PicTure tm(nAg1,14,nDecs)
	@li, 066 PSAY nAg2 PicTure tm(nAg2,14,nDecs)
	@li, 082 PSAY nAg3 PicTure tm(nAg3,14,nDecs)
	@li, 098 PSAY nAg4 PicTure tm(nAg3,14,nDecs)
	@li, 120 PSAY ((nAg3-nAg4)*100)/nAg3 PicTure "999.99"	
	*/
	
	@li,050 PSAY nTotVVend PicTure tm(TB_VALOR2,14,nDecs)
	@li,066 PSAY ((nTotVTab - nTotVVend) * 100)/nTotVTab PicTure "@E 99.99"
	@li,074 PSAY nPrzMedTot  PicTure "@E 999.99"
	@li,082 PSAY nPrzMedPrTot  PicTure "@E 999.99"
	
	
	roda(cbcont,cbtxt)
EndIF

dbSelectArea( "TRB" )
dbCloseArea()
fErase(cNomArq+GetDBExtension())
fErase(cNomArq1+OrdBagExt())
fErase(cNomArq2+OrdBagExt())


dbSelectArea( "DUP" )
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab  ³ Autor ³ Wagner Xavier         ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho para emissao de Estat.de Fatur.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraTrab()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTrab(cEstoq,cDupli)
Local nContador,nTOTAL,nVALICM,nVALIPI
Local nVendedor:= Fa440CntVen()
Local cVendedor:= ""
Local aVend    := {}
Local cVend    := ""
Local aImpostos:= {}
Local nImpos	:=0.00
Local lContinua:= .F.
Local nMoedNF	 :=	1
Local nTaxa		:=	0
Local cNameSD1  :=	""
Local cNameSF1  :=	""
Local cNameSD2  :=	""
Local cNameSF2  :=	""
Local cNameSF4  :=	""
Local cFilterQry:=	""
Local cAddField	:=	""
Local cQuery	:=	""
Local cQryAd    :=  ""
Local cName     :=  ""
Local aCampos	:=	{}
Local nCampo	:=	0
Local cCampo	:=	""
Local cAliasSD2	:=	""
Local cAliasSD1	:=	""
Local cSD2Old	:=	""
Local cSD1Old	:=	""
Local aStru		:=	{}
Local nStru		:=	0
Local nPos		:=	0
Local nValor	:=	0
Local nY        := 	0
Local aFilUsrSF1:= {}
Local lFiltro   := .T.
Local lMR580FIL := ExistBlock("MR580FIL")
Local dtMoedaDev:= CtoD("")
Local nX := 0
Local cNFSer    := ""

Private cCampImp

If lMR580FIL
	aFilUsrSF1 := ExecBlock("MR580FIL",.F.,.F.,aReturn[7])
EndIf

dbSelectArea("SD2")
dbSetOrder(5)
dbSelectArea("SD1")
dbSetOrder(6)

cAliasSD2:=	GetNextAlias()

cNameSD2 := RetSqlName("SD2")
cNameSF2 := RetSqlName("SF2")
cNameSF4 := RetSqlName("SF4")
                   
cAddField	:=	""

If SF2->(FieldPos("F2_TXMOEDA")) > 0
	cAddField += ", F2_TXMOEDA"
EndIf

If SF2->(FieldPos("F2_MOEDA")) > 0
	cAddField += ", F2_MOEDA"
EndIf

cVendedor := "1"
For nCampo := 1 To nVendedor
	cCampo := "F2_VEND"+cVendedor
	If SF2->(FieldPos(cCampo)) > 0
		cFilterQry += "(" + cCampo + " between '" + mv_par03 + "' and '" + mv_par04 + "') or "
		cAddField += ", " + cCampo
	EndIf
	cVendedor := Soma1(cVendedor,1)
Next nCampo

cQuery := "SELECT  SD2.*, F2_EMISSAO, F2_TIPO, F2_DOC, F2_FRETE, F2_SEGURO, F2_DESPESA, F2_FRETAUT, F2_ICMSRET" + cAddField

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Esta Rotina adiciona a cQuery os campos selecionados pelo usuario  |
    //³no filtro do usuario.                                              |
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
aStru := SF2->(dbStruct())	
    If !Empty(aReturn[7])
       For nX := 1 To SF2->(FCount())
           cName := SF2->(FieldName(nX))
           If AllTrim( cName ) $ aReturn[7]
           If aStru[nX,2] <> "M"  
      		  If !cName $ cQuery .And. !cName $ cQryAd
	        	cQryAd += ","+cName
	          Endif 	
	       EndIf
           EndIf 			       	
       Next nX
    Endif         
    cQuery += cQryAd 

cQuery += " FROM " + cNameSD2 + " SD2, " + cNameSF4 + " SF4, " + cNameSF2 + " SF2 "
cQuery += " where D2_FILIAL  = '" + xFilial("SD2") + "'"
cQuery += " and D2_EMISSAO between '" + DTOS(mv_par01) + "' and '" + DTOS(mv_par02) + "'"
cQuery += " and D2_TIPO NOT IN ('D', 'B')"
cQuery += " and F2_FILIAL  = '" + xFilial("SF2") + "'"
cQuery += " and (" + Left(cFilterQry,Len(cFilterQry)-4) + ")"
cQuery += " and D2_DOC     = F2_DOC"
cQuery += " and D2_SERIE   = F2_SERIE"
cQuery += " and D2_CLIENTE = F2_CLIENTE"
cQuery += " and D2_LOJA    = F2_LOJA"
cQuery += " and NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ")"
cQuery += " and F4_FILIAL  = '" + xFilial("SF4") + "'"
cQuery += " and F4_CODIGO  = D2_TES"
cQuery += " and SD2.D_E_L_E_T_ = ' '"
cQuery += " and SF2.D_E_L_E_T_ = ' '"
cQuery += " and SF4.D_E_L_E_T_ = ' '"
cQuery += " ORDER BY " + SQLORDER (SD2->(INDEXKEY()))

cQuery := ChangeQuery(cQuery)     

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD2,.T.,.T.)
    
aStru := SD2->(dbStruct())
For nStru := 1 To Len(aStru)
	If aStru[nStru,2] <> "C"
		TcSetField(cAliasSD2,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
	EndIf
Next nStru

aStru	:= SF2->(dbStruct())	
aCampos	:= {"F2_EMISSAO","F2_FRETE","F2_SEGURO","F2_DESPESA","F2_FRETAUT","F2_ICMSRET"}
For nCampo := 1 To Len(aCampos)
	nPos := aScan(aStru,{|x|AllTrim(x[1])==aCampos[nCampo]})
	If aStru[nPos,2] <> "C"
		TcSetField(cAliasSD2,aStru[nPos,1],aStru[nPos,2],aStru[nPos,3],aStru[nPos,4])
	EndIf
Next nCampo

SetRegua(SD2->(LastRec())+SD1->(LastRec()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa Faturamento                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !Eof()
	
     //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
     //³Processa Filtro do Usuario para Query                                   ³
     //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	 If !Empty(aReturn[7]).And.!&(aReturn[7]) 
	     dbSelectArea(cAliasSD2)
	     dbSkip()
	     Loop
	 Endif    

    IncRegua()
	nTOTAL :=0
	nVALICM:=0
	nVALIPI:=0

	nTaxa	:=	IIf((cAliasSD2)->(FieldPos("F2_TXMOEDA"))>0,(cAliasSD2)->F2_TXMOEDA,0)		
	nMoedNF	:=	IIf((cAliasSD2)->(FieldPos("F2_MOEDA"))>0,(cAliasSD2)->F2_MOEDA,0)

	If AvalTes((cAliasSD2)->D2_TES,cEstoq,cDupli)
		If cPaisLoc	==	"BRA"
			nVALICM += xMoeda((cAliasSD2)->D2_VALICM,1,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1)
			nVALIPI += xMoeda((cAliasSD2)->D2_VALIPI,1,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1)
		Endif
		nTotal	+=	xMoeda((cAliasSD2)->D2_TOTAL,nMoedNF,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1,nTaxa)
	
		If ( nTotal <> 0 )
			cVendedor := "1"
			For nContador := 1 To nVendedor
				dbSelectArea("TRB")
				dbSetOrder(1)
				cVend := (cAliasSD2)->(FieldGet(FieldPos("F2_VEND"+cVendedor)))
				cVendedor := Soma1(cVendedor,1)
				If cVend >= mv_par03 .And. cVend <= mv_par04
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Se vendedor em branco, considera apenas 1 vez        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Empty(cVend) .and. nContador > 1
						Loop
					Endif
					
					If ( aScan(aVend,cVend)==0 )
						Aadd(aVend,cVend)
					EndIf
					If (dbSeek( cVend ))
						RecLock("TRB",.F.)
					Else
						RecLock("TRB",.T.)
					EndIF
					Replace TB_VEND    With cVend
					Replace TB_EMISSAO With (cAliasSD2)->F2_EMISSAO
					Replace TB_VALOR2  With TB_VALOR2+IIF((cAliasSD2)->F2_TIPO == "P",0,nTOTAL)
					Replace TB_VALTAB  With TB_VALTAB +IIF((cAliasSD2)->F2_TIPO == "P",0,(cAliasSD2)->D2_QUANT * (cAliasSD2)->D2_PRUNIT) // ver o valor unitário da tabela
					
					If ( cPaisLoc=="BRA" )
						Replace TB_VALOR1  With TB_VALOR1+(nTOTAL-nVALICM)
						Replace TB_VALOR3  With TB_VALOR3+IIF((cAliasSD2)->F2_TIPO == "P",0,nTotal)+nVALIPI
						nAux := IIF((cAliasSD2)->F2_TIPO == "P",0,nTotal)+nVALIPI
						Replace TB_VALOR4  With TB_VALOR4+fDescFin((cAliasSD2)->D2_FILIAL,(cAliasSD2)->D2_DOC,(cAliasSD2)->D2_SERIE,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_COD,nAux)
						// faz o cálculo para as duplicatas
						if ((cAliasSD2)->D2_DOC + (cAliasSD2)->D2_SERIE) != cNFSer
						  ContDupl(cAliasSD2)
						  cNFSer := (cAliasSD2)->D2_DOC + (cAliasSD2)->D2_SERIE
						EndIf
						
					Else
						Replace TB_VALOR1  With TB_VALOR1+nTOTAL
						Replace TB_VALOR3  With TB_VALOR3+IIF((cAliasSD2)->F2_TIPO == "P",0,nTotal)
						nAux := IIF((cAliasSD2)->F2_TIPO == "P",0,nTotal)
						Replace TB_VALOR4  With TB_VALOR4+fDescFin((cAliasSD2)->D2_FILIAL,(cAliasSD2)->D2_DOC,(cAliasSD2)->D2_SERIE,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_COD,nAux)
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Pesquiso pelas caracteristicas de cada imposto               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						aImpostos:=TesImpInf((cAliasSD2)->D2_TES)
						For nY:=1 to Len(aImpostos)
							cCampImp:=(cAliasSD2)+"->"+(aImpostos[nY][2])
							nImpos	:=	xMoeda(&cCampImp.,nMoedNF,mv_par06,(cAliasSD2)->D2_EMISSAO,nDecs+1,nTaxa)
							If ( aImpostos[nY][3]=="1" )
								Replace TB_VALOR3  With TB_VALOR3 + nImpos
								Replace TB_VALOR4  With TB_VALOR4 + nImpos									
								
							ElseIf ( aImpostos[nY][3]=="2" )
								Replace TB_VALOR1  With TB_VALOR1 - nImpos
							EndIf
						Next
					EndIf
					Replace TB_DOC	    With (cAliasSD2)->F2_DOC
					MsUnlock()
				Endif
			Next nContador
		EndIf
	EndIf

	dbSelectArea(cAliasSD2)
	cSD2Old	:= (cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA		
	nValor3 := xMoeda((cAliasSD2)->F2_FRETE+(cAliasSD2)->F2_SEGURO+(cAliasSD2)->F2_DESPESA+(cAliasSD2)->F2_FRETAUT+(cAliasSD2)->F2_ICMSRET,nMoedNF,mv_par06,(cAliasSD2)->F2_EMISSAO,nDecs+1,nTaxa)		
	dbSkip()
	If Eof() .Or. ( (cAliasSD2)->D2_DOC+(cAliasSD2)->D2_SERIE+(cAliasSD2)->D2_CLIENTE+(cAliasSD2)->D2_LOJA!= cSD2Old )
		For nContador := 1 To Len(aVend)
			dbSelectArea("TRB")
			dbSetOrder(1)
			dbSeek(aVend[nContador])
			RecLock("TRB",.F.)
			TRB->TB_VALOR3	+= nValor3
			TRB->TB_VALOR4	+= fDescFin((cAliasSD2)->D2_FILIAL,(cAliasSD2)->D2_DOC,(cAliasSD2)->D2_SERIE,(cAliasSD2)->D2_CLIENTE,(cAliasSD2)->D2_LOJA,(cAliasSD2)->D2_COD,nValor3)
			MsUnLock()
		Next nContador
		aVend := {}
	EndIf
	dbSelectArea(cAliasSD2)
EndDo
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa Devolucao                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( MV_PAR07 == 1 )

	cAliasSD1:= GetNextAlias()

	cNameSD1 := RetSqlName("SD1")
	cNameSF1 := RetSqlName("SF1")

	cAddField	:=	""
	cQryAd      :=  ""	   
	
	If cPaisLoc == "BRA"
		cVendedor := "1"
		For nCampo := 1 To nVendedor
			cCampo := "F2_VEND"+cVendedor
			If SF2->(FieldPos(cCampo)) > 0
				cFilterQry += "(" + cCampo + " between '" + mv_par03 + "' and '" + mv_par04 + "') or "
				cAddField	+= ", " + cCampo
			EndIf
			cVendedor := Soma1(cVendedor,1)
		Next nCampo
	Else
		For nCampo := 0 To 35
			cCampo := "F1_VEND"+Soma1(AllTrim(Str(nCampo)),1)
			If SF1->(FieldPos(cCampo)) > 0
				cFilterQry += "(" + cCampo + " between '" + mv_par03 + "' and '" + mv_par04 + "') or "
				cAddField	+= ", " + cCampo
			EndIf
		Next nCampo
		If SF1->(FieldPos("F1_TXMOEDA")) > 0
			cAddField += ", F1_TXMOEDA"
		EndIf
		If SF1->(FieldPos("F1_MOEDA")) > 0
			cAddField += ", F1_MOEDA"
		EndIf
		If SF1->(FieldPos("F1_FRETINC")) > 0
			cAddField += ", F1_FRETINC"
		EndIf
	EndIf
		
	cQuery := "select SD1.*, F1_EMISSAO, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_FRETE, F1_DESPESA, F1_SEGURO, F1_ICMSRET, F1_DTDIGIT, F2_EMISSAO" + cAddField

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³Esta Rotina adiciona a cQuery os campos retornados na string de filtro do  |
    //³ponto de entrada MR580FIL.                                                 |
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
	If lMR580FIL
		aStru := SF1->(dbStruct())	
	    If !Empty(aFilUsrSF1[1])
	       For nX := 1 To SF1->(FCount())
	           cName := SF1->(FieldName(nX))
	           If AllTrim( cName ) $ aFilUsrSF1[1]
		           If aStru[nX,2] <> "M"  
		      		  If !cName $ cQuery .And. !cName $ cQryAd
			        	cQryAd += ","+cName
			          Endif 	
			       EndIf
	           EndIf 			       	
	       Next nX
	    Endif         
	    cQuery += cQryAd 
	EndIf

	cQuery += " from " + cNameSD1 + " SD1, " + cNameSF4 + " SF4, " + cNameSF2 + " SF2, " + cNameSF1 + " SF1 "
	cQuery += " where D1_FILIAL  = '" + xFilial("SD1") + "'"
	cQuery += " and D1_DTDIGIT between '" + DTOS(mv_par01) + "' and '" + DTOS(mv_par02) + "'"
	cQuery += " and D1_TIPO = 'D'"
	cQuery += " and NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ")"
	cQuery += " and F4_FILIAL  = '" + xFilial("SF4") + "'"
	cQuery += " and F4_CODIGO  = D1_TES"
	cQuery += " and F2_FILIAL  = '" + xFilial("SF2") + "'"
	cQuery += " and F2_DOC     = D1_NFORI   "
	cQuery += " and F2_SERIE   = D1_SERIORI "
	cQuery += " and F2_CLIENTE = D1_FORNECE "
	cQuery += " and F2_LOJA    = D1_LOJA "
	cQuery += " and F1_FILIAL  = '" + xFilial("SF1") + "'"
	cQuery += " and F1_DOC     = D1_DOC     "
	cQuery += " and F1_SERIE   = D1_SERIE"
	cQuery += " and F1_FORNECE = D1_FORNECE"
	cQuery += " and F1_LOJA    = D1_LOJA"
	cQuery += " and SD1.D_E_L_E_T_ = ' '"
	cQuery += " and SF4.D_E_L_E_T_ = ' '"
	cQuery += " and SF2.D_E_L_E_T_ = ' '"
	cQuery += " and SF1.D_E_L_E_T_ = ' '"
	cQuery += " and (" + Left(cFilterQry,Len(cFilterQry)-4) + ")"
	cQuery += " ORDER BY " + SQLORDER (SD1->(INDEXKEY()))
	
	cQuery := ChangeQuery(cQuery)
	
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSD1,.T.,.T.)

	aStru := SD1->(dbStruct())
	For nStru := 1 To Len(aStru)
		If aStru[nStru,2] <> "C"
			TcSetField(cAliasSD1,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
		EndIf
	Next nStru

	aStru := SF2->(dbStruct())
	For nStru := 1 To Len(aStru)
		If aStru[nStru,2] <> "C"
			TcSetField(cAliasSD1,aStru[nStru,1],aStru[nStru,2],aStru[nStru,3],aStru[nStru,4])
		EndIf
	Next nStru

	aStru	:= SF1->(dbStruct())
	aCampos	:= {"F1_EMISSAO","F1_FRETE","F1_DESPESA","F1_SEGURO","F1_ICMSRET","F1_DTDIGIT"}
	For nCampo := 1 To Len(aCampos)
		nPos := aScan(aStru,{|x|AllTrim(x[1])==aCampos[nCampo]})
		If aStru[nPos,2] <> "C"
			TcSetField(cAliasSD1,aStru[nPos,1],aStru[nPos,2],aStru[nPos,3],aStru[nPos,4])
		EndIf
	Next nCampo
	
	While !Eof()
		IncRegua()
		nTOTAL :=0
		nVALICM:=0
		nVALIPI:=0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processa o ponto de entrada com o filtro do usuario para devolucoes.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lMR580FIL
     			lFiltro := .T.
			dbSelectArea("SF1")
			dbSetOrder(1)
			MsSeek(xFilial("SF1")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA)
			If !Empty(aFilUsrSF1[1]).And.!&(aFilUsrSF1[1]) 
				dbSelectArea(cAliasSD1)
                    lFiltro := .F.
			Endif    
            EndIf

            If lFiltro             			
			If MV_PAR10 == 1 .Or. Empty((cAliasSD1)->F2_EMISSAO)           
				DtMoedaDev  := (cAliasSD1)->F1_DTDIGIT
			Else
				DtMoedaDev  := (cAliasSD1)->F2_EMISSAO
			EndIf  
            
			If cPaisLoc == "BRA"
				If AvalTes((cAliasSD1)->D1_TES,cEstoq,cDupli)

					nVALICM := xMoeda((cAliasSD1)->D1_VALICM,1,mv_par06,DtMoedaDev,nDecs+1)
					nVALIPI := xMoeda((cAliasSD1)->D1_VALIPI,1,mv_par06,DtMoedaDev ,nDecs+1)
					nTOTAL  := xMoeda(((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC),1,mv_par06,DtMoedaDev,nDecs+1)
					cVendedor := "1"
					For nContador := 1 TO nVendedor
						dbSelectArea("TRB")
						dbSetOrder(1)
						cVend := (cAliasSD1)->(FieldGet((cAliasSD1)->(FieldPos("F2_VEND"+cVendedor))))
						cVendedor := Soma1(cVendedor,1)
						If cVend >= MV_PAR03 .And. cVend <= MV_PAR04
							If Empty(cVend) .and. nContador > 1
								Loop
							EndIf
							If ( aScan(aVend,cVend) == 0 )
								AADD(aVend,cVend)
							EndIf
							If nTOTAL > 0
								If (dbSeek( cVend ))
									RecLock("TRB",.F.)
								Else
									RecLock("TRB",.T.)
								EndIf
								Replace TB_VEND    With cVend
								Replace TB_EMISSAO With (cAliasSD1)->F1_EMISSAO
								Replace TB_VALOR2  With TB_VALOR2-nTOTAL
								Replace TB_VALOR1  With TB_VALOR1-(nTOTAL-nVALICM)
								Replace TB_VALOR3  With TB_VALOR3-nTOTAL-nVALIPI
								Replace TB_VALOR4  With TB_VALOR4-fDescFin((cAliasSD1)->D1_FILIAL,(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_SERIORI,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_COD,(nTOTAL-nVALIPI))
								Replace TB_DOC	    With (cAliasSD1)->F1_DOC
								
								// Parte de desconto médio - apenas copia o valor de tabela
								Replace TB_VALTAB With TB_VALTAB -nTotal

								MsUnlock()
							EndIf
						Endif
					Next nContador
				EndIf
			Else
				If AvalTes((cAliasSD1)->D1_TES,cEstoq,cDupli)
					nTaxa	:=	IIf((cAliasSD1)->(FieldPos("F1_TXMOEDA"))>0,(cAliasSD1)->F1_TXMOEDA,0)
					nMoedNF	:=	IIF((cAliasSD1)->(FieldPos("F1_MOEDA"))>0,(cAliasSD1)->F1_MOEDA,1)
 					nTOTAL	:= xMoeda(((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC),nMoedNF,mv_par06,DtMoedaDev,nDecs+1,nTaxa)
					cVendedor := "1"
					For nContador := 1 TO 1
						dbSelectArea("TRB")
						dbSetOrder(1)
						cVend := (cAliasSD1)->(FieldGet((cAliasSD1)->(FieldPos("F1_VEND"+cVendedor))))
						cVendedor := Soma1(cVendedor,1)
						If cVend >= MV_PAR03 .And. cVend <= MV_PAR04
							If Empty(cVend) .and. nContador > 1
								Loop
							EndIf
							If ( aScan(aVend,cVend) == 0 )
								AADD(aVend,cVend)
							EndIf
							If nTOTAL > 0
								If (dbSeek( cVend ))
									RecLock("TRB",.F.)
								Else
									RecLock("TRB",.T.)
								EndIf
								Replace TB_VEND    With cVend
								Replace TB_EMISSAO With (cAliasSD1)->F1_EMISSAO
								Replace TB_VALOR2  With TB_VALOR2-nTOTAL
								Replace TB_VALOR1  With TB_VALOR1-nTOTAL
								Replace TB_VALOR3  With TB_VALOR3-nTotal
								Replace TB_VALOR4  With TB_VALOR4-fDescFin((cAliasSD1)->D1_FILIAL,(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_SERIORI,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_COD,nTotal)
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Pesquiso pelas caracteristicas de cada imposto               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
								For nY:=1 to Len(aImpostos)
									cCampImp:="SD1->"+(aImpostos[nY][2])
									nImpos	:=	xMoeda(&cCampImp.,nMoedNF,mv_par06,DtMoedaDev,nDecs+1,nTaxa)
									If ( aImpostos[nY][3]=="1" )
										Replace TB_VALOR3  With TB_VALOR3 - nImpos
										Replace TB_VALOR4  With TB_VALOR4 - nImpos
										
									ElseIf ( aImpostos[nY][3]=="2" )
										Replace TB_VALOR1  With TB_VALOR1 + nImpos
									EndIf
								Next nY
								Replace TB_DOC	    With (cAliasSD1)->F1_DOC
							Endif							
							MsUnlock()
						EndIf
					Next nContador
				Endif
			Endif
			dbSelectArea(cAliasSD1)
			cSD1Old := (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA
			If ( cPaisLoc=="BRA")
				nValor3	:= xMoeda((cAliasSD1)->F1_FRETE+(cAliasSD1)->F1_DESPESA+(cAliasSD1)->F1_SEGURO+(cAliasSD1)->F1_ICMSRET,1,mv_par06,DtMoedaDev,nDecs+1)
			Else
				nValor3	:= xMoeda(IIf((cAliasSD1)->(FieldPos("F1_FRETINC"))>0.And.(cAliasSD1)->F1_FRETINC<> "S",;
						(cAliasSD1)->F1_FRETE,0);
						+(cAliasSD1)->F1_DESPESA,nMoedNF,mv_par06,DtMoedaDev,nDecs+1,nTaxa)
			EndIf                  
		EndIf
		
		dbSelectArea(cAliasSD1)
		dbSkip()
		
		If lFiltro				
			If Eof() .Or. ( (cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA != cSD1Old)
				FOR nContador := 1 TO Len(aVend)
					dbSelectArea("TRB")
					dbSetOrder(1)
					cVend := aVend[nContador]
					dbSeek( cVend )
					RecLock("TRB",.F.)
					Replace TB_VALOR3  With TB_VALOR3-nValor3
					Replace TB_VALOR4  With TB_VALOR4-fDescFin((cAliasSD1)->D1_FILIAL,(cAliasSD1)->D1_NFORI,(cAliasSD1)->D1_SERIORI,(cAliasSD1)->D1_FORNECE,(cAliasSD1)->D1_LOJA,(cAliasSD1)->D1_COD,nValor3)
					
					nValor3	:= 0
					MsUnlock()
				Next nContador
				aVend:={}
			EndIf				
		EndIf			
		dbSelectArea(cAliasSD1)
	EndDo                                                       
	dbCloseArea()	
EndIf

// faz o calculo do desconto medio das vendas das duplicatas
DbSelectArea("DUP")
IndRegua("DUP","DUPIND01","DP_VEND",," ","")
DUP->(DBSetOrder(01))
TRB->(DBGoTop())
While (TRB->(!Eof()))
  RecLock("TRB", .F.)
  aPrazo := CalcPrazo(.F.)
  TRB->TB_PRAZO := aPrazo[1]
  TRB->TB_PRAZOPR := aPrazo[2]
  TRB->TB_DESCME :=  Round((1 - (TRB->TB_VALOR2 / TRB->TB_VALTAB)) * 100, 2)
  MsUnlock()
  TRB->(DbSkip())
EndDo

aPrazo := CalcPrazo(.T.)
nPrzMedTot := aPrazo[1]
nPrzMedPrTot := aPrazo[2]
	
Return .T.

// calcula o prazo médio das vendas do vendedor ou do geral, de acordo com o parametro lTotal
Static Function CalcPrazo(lTotal)
Local nPrazoMedio
Local nPrazoMedioPR 
Local nMultValor := 0
Local nMultValorR := 0
Local nSomaValor := 0

if (lTotal)
  DUP->(DbGoTop())
Else
  DUP->(DbSeek(TRB->TB_VEND))
EndIf

if (lTotal .Or. DUP->(Found()))
  While (TRB->TB_Vend == DUP->DP_VEND .Or. lTotal) .And. (DUP->(!Eof()))
    nMultValor += DUP->DP_Valor * DUP->DP_Prazo
    nMultValorP += DUP->DP_Valor * DUP->DP_PrazoP
    nSomaValor += DUP->DP_Valor
    DUP->(DbSkip())              
  EndDo
  nPrazoMedio := Round(nMultValor / nSomaValor, 2)
  nPrazoMedioPR := Round(nMultValorP / nSomaValor, 2)
EndIf

Return {nPrazoMedio, nPrazoMedioPR}

Static Function fDescFin(cpFILIAL,cpDOC,cpSERIE,cpCLIENTE,cpLOJA,cpPRODUTO,npValor)
Local nValRet := npValor
Local nTmp    := 0
Local cArea   := GetArea()                        
                                         
dbSelectArea("SF2")
dbSetOrder(2)
If dbSeek(cpFILIAL+cpCLIENTE+cpLOJA+cpDOC+cpSERIE)
	If SF2->F2_DESVEN > 0
		nTmp    := Round((SF2->F2_DESVEN * SF2->F2_VALBRUT) / 100,2)
		nValRet := nValRet - Round((nValRet * nTmp) / SF2->F2_VALBRUT,2)		
	Endif
Endif                                    

                          
RestArea(cArea)

Return nValRet


// contabiliza o prazo médio das duplicatas
Static Function ContDupl(cAliasSD2)
Local aArea := GetArea()
Local cNf
dbSelectArea("DUP")
SE1->(dbSetOrder(01))
If SE1->(dbSeek(xFilial("SE1") + (cAliasSD2)->D2_Serie + (cAliasSD2)->D2_Doc))
  cNF := xFilial("SE1") + (cAliasSD2)->D2_Serie + (cAliasSD2)->D2_Doc
  While SE1->(!Eof()) .And. cNf == (xFilial("SE1") + SE1->E1_Prefixo + SE1->E1_NUM)
    RecLock("DUP", .T.)
    
    DUP->DP_VALOR := SE1->E1_Valor
    DUP->DP_VEND  := (cAliasSD2)->F2_Vend1 // seta o vendedor para a duplicata, para calcular o prazo médio por vendedor
    
    if (SE1->E1_TIPO == "NCC") 
      DUP->DP_PRAZO := 0
    Else                                            // 
      DUP->DP_PRAZO := Iif(Empty(SE1->E1_BAIXA), iif(SE1->E1_VencRea > Date(), SE1->E1_VencRea - SE1->E1_Emissao, Date() - SE1->E1_Emissao), SE1->E1_Baixa - SE1->E1_Emissao)
      DUP->DP_PRAZOP := SE1->E1_VENCREA - SE1->E1_Emissao
    EndIf
    
    MsUnlock("DUP")
    SE1->(DbSkip())
  EndDo
EndIf

Restarea(aArea)
Return Nil

Static Function MediaPond(nMedAt, nValAt, nMedMov, nValMov)
Local nMedia := 0
nMedia := (nMedAt * nValAt) + (nMedNov * nValMov)
nMedia := nMedia / (nMedAt + nMedMov)
Return nMedia