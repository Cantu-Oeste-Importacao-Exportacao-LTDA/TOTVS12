#INCLUDE "MATR080.CH"
#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR080R3 ³ Autor ³ Alexandre Inacio Lemes³ Data ³10/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da Rela‡„o de Notas Fiscais (Antigo)               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Baseado no original de Claudinei M. Benzi  Data  05/09/1991³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡…o ³ PLANO DE MELHORIA CONTINUA        ³Programa    MATR080.PRX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data       	|BOPS               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³           	|                 ³±±
±±³      02  ³ Ricardo Berti            ³ 06/02/2006	| 092436          ³±±
±±³      03  ³                          ³           	|                 ³±±
±±³      04  ³ Ricardo Berti            ³ 06/02/2006	| 092436          ³±±
±±³      05  ³                          ³           	|                 ³±±
±±³      06  ³                          ³           	|                 ³±±
±±³      07  ³                          ³           	|                 ³±±
±±³      08  ³                          ³           	|                 ³±±
±±³      09  ³                          ³           	|                 ³±±
±±³      10  ³ Ricardo Berti            ³ 06/02/2006	| 092436          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Matr080RE()

LOCAL titulo     := STR0001	//"Rela‡„o de Notas Fiscais"
LOCAL cDesc1     := STR0002	//"Emiss„o da Rela‡„o de Notas de Compras"
LOCAL cDesc2     := STR0003	//"A op‡„o de filtragem deste relat¢rio s¢ ‚ v lida na op‡„o que lista os"
LOCAL cDesc3     := STR0004	//"itens. Os parƒmetros funcionam normalmente em qualquer op‡„o."
LOCAL cString    := "SD1"
LOCAL wnrel      := "MATR080"
LOCAL nomeprog   := "MATR080"
LOCAL lRet		 := .T.

PRIVATE Tamanho  := "M"
PRIVATE limite   := 132
PRIVATE aOrdem   := {OemToAnsi(STR0005),OemToAnsi(STR0006),OemToAnsi(STR0043),OemToAnsi(STR0059),OemToAnsi(STR0062)}		//" Por Nota           "###" Por Produto        "###" Por Data Digitacao "###" Por Data Emissao "###" Por Fornecedor "
PRIVATE cPerg    := "MTR080"
PRIVATE aReturn  := {OemToAnsi(STR0007), 1,OemToAnsi(STR0008), 2, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE lEnd     := .F.
PRIVATE m_pag    := 1
PRIVATE li       := 80
PRIVATE nLastKey := 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSx1()
Pergunte("MTR080",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01 // Produto de                                       ³
//³ mv_par02 // Produto ate                                      ³
//³ mv_par03 // Data de                                          ³
//³ mv_par04 // Data ate                                         ³
//³ mv_par05 // Lista os itens da nota                           ³
//³ mv_par06 // Grupo de                                         ³
//³ mv_par07 // Grupo ate                                        ³
//³ mv_par08 // Fornecedor de                                    ³
//³ mv_par09 // Fornecedor ate                                   ³
//³ mv_par10 // Almoxarifado de                                  ³
//³ mv_par11 // Almoxarifado ate                                 ³
//³ mv_par12 // De  Nota                                         ³
//³ mv_par13 // Ate Nota                                         ³
//³ mv_par14 // De  Serie                                        ³
//³ mv_par15 // Ate Serie                                        ³
//³ mv_par16 // Do  Tes                                          ³
//³ mv_par17 // Ate Tes                                          ³
//³ mv_par18 // Moeda                                            ³
//³ mv_par19 // Otras moedas                                     ³
//³ mv_par20 // Imprime Total                                    ³
//³ mv_par21 // Descricao do produto                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrdem,,Tamanho)

lRet := ! ( nLastKey == 27 )
If lRet
	SetDefault(aReturn,cString)
	lRet := ! ( nLastKey == 27 )
Endif
If lRet
	RptStatus({|lEnd| C080Imp(@lEnd,wnRel,cString,nomeprog,Titulo)},Titulo)
Else
	dbSelectArea(cString)
	dbSetOrder(1)
	dbClearFilter()
EndIf

Return(lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C080IMP  ³ Autor ³ Alex Lemes            ³ Data ³10/05/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ C080Imp(ExpL1,ExpC1,ExpC2,ExpC3,ExpC4)					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1 = controle para interrupcao pelo usuario		      ³±±
±±³          ³ ExpC1 = nome do relatorio	                              ³±±
±±³          ³ ExpC2 = Alias do arquivo principal     		              ³±±
±±³          ³ ExpC3 = nome do programa 			                      ³±±
±±³          ³ ExpC4 = titulo do relatorio           		              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR080			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C080Imp(lEnd,WnRel,cString,nomeprog,Titulo)

LOCAL cCabec      := ""
LOCAL cabec1      := ""
LOCAL cabec2      := ""
LOCAL cQuery	  := ""
LOCAL cDocAnt     := ""
LOCAL cCodAnt     := ""
LOCAL cbText      := ""
LOCAL cQryAd      := ""     
LOCAL cName       := ""
LOCAL cAliasSF1   := "SF1"
LOCAL cAliasSD1   := "SD1"
LOCAL cAliasSB1   := "SB1"
LOCAL cAliasSA1   := "SA1"
LOCAL cAliasSA2   := "SA2"
LOCAL cAliasSF4   := "SF4"
LOCAL cIndex 	  := CriaTrab("",.F.)
LOCAL cForCli     := ""
LOCAL cMuni       := ""
LOCAL cFornF1     := ""
LOCAL cLojaF1     := ""
LOCAL cDocF1      := ""
LOCAL cSerieF1    := ""
LOCAL cCondF1     := ""
LOCAL cTipoF1     := ""
LOCAL cDescri     := ""
LOCAL cFornAnt    := ""
LOCAL nMoedaF1    := 0
LOCAL nTxMoedaF1  := 0
LOCAL nFreteF1    := 0
LOCAL nDespesaF1  := 0
LOCAL nSeguroF1   := 0
LOCAL nValTotF1   := 0
LOCAL nIndex	  := 0
LOCAL nValMerc    := 0
LOCAL nValDesc    := 0
LOCAL nValIcm     := 0
LOCAL nValIpi     := 0
LOCAL nValImpInc  := 0
LOCAL nValImpNoInc:= 0
LOCAL nTotGeral   := 0
LOCAL nTotGerImp  := 0
LOCAL nTotDesco   := 0
LOCAL nTotFrete   := 0
LOCAL nTotSeguro  := 0
LOCAL nTotDesp    := 0
LOCAL nTotProd    := 0
LOCAL nTotQger    := 0
LOCAL nTotData    := 0
LOCAL nTotForn    := 0
LOCAL nTotquant   := 0
LOCAL nTGerIcm    := 0
LOCAL nTGerIpi    := 0
LOCAL nTGImpInc   := 0
LOCAL nTGImpNoInc := 0
LOCAL nImpInc     := 0
LOCAL nImpNoInc   := 0
LOCAL nImpos      := 0
LOCAL nPosNome    := 0
LOCAL nTamNome    := 0
LOCAL cbCont      := 0
LOCAL nLinha      := 0
LOCAL nTaxa       := 1
LOCAL nMoeda      := 1
LOCAL nTamDesc    := 28
LOCAL nDecs       := Msdecimais(mv_par18)
LOCAL nOrdem 	  := aReturn[8]
LOCAL lQuery      := .F.
LOCAL lImp	      := .F.
LOCAL lFiltro     := .T.
LOCAL lDescLine   := .T.
LOCAL lPrintLine  := .F.
LOCAL lEasy       := If(GetMV("MV_EASY")=="S",.T.,.F.)
LOCAL aTamSXG     := TamSXG("001")
LOCAL aTamSXG2    := TamSXG("002")
LOCAL aImpostos   := {} 
LOCAL aStrucSF1   := {}
LOCAL aStrucSD1   := {}
LOCAL dDtDig      := dDataBase
LOCAL dDataAnt    := dDataBase
LOCAL dEmissaoF1  := dDataBase
LOCAL dDtDigitF1  := dDataBase
LOCAL aCampos   :={}                     
LOCAL nX       := 0
Local nY       := 0
LOCAL cAlias   := Alias()
LOCAL nIndice  := indexord()
LOCAL nIncCol  := 0     
Local nTotUser := 0// Guilherme 17-05-12 Totalizador de notas por usuário

PRIVATE nTipo  	 := IIF(aReturn[4]=1,15,18)
#IFDEF TOP
DbSelectArea("SX3")
DbSetOrder(2)
DbSeek("D1_VALIMP") 
While !Eof() .And. X3_ARQUIVO == "SD1" .And. X3_CAMPO = "D1_VALIMP"
	AAdd(aCampos,X3_CAMPO)     
	DbSkip()
EndDo   
DbSelectArea(cAlias)
DbSetOrder(nIndice)
#ENDIF 
If cPaisLoc == "MEX"
	Tamanho  := "G"
	limite   := 220
	nIncCol  := 12
Endif	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define o Cabecalho em todas as Ordens do Relatorio           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Regua 			                      1         2         3         4         5         6         7         8         9        10        11        12        13
//		            	       0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
If nOrdem == 1 .And. mv_par05 == 1
	nPosNome := 92
	nTamNome := 34
	cabec1   := STR0011 + " - Usuario: " + mv_par23	//"RELACAO DOS ITENS DAS NOTAS"
	cCabP1 := "CODIGO               D E S C R I C A O             CFO  TE      ICMS      IPI   LOCAL   QUANTIDADE   VALOR UNITARIO      VALOR TOTAL"
	cCabec   := IIF(cPaisLoc == "BRA",cCabP1,STR0050)	//"CODIGO DO MATERIAL   D E S C R I C A O             CFO  TE  ICM  IPI  LOCAL             QUANTIDADE   VALOR UNITARIO      VALOR TOTAL"
Elseif nOrdem == 1 .And. mv_par05 == 2
	nPosNome := 35
	nTamNome := 30
	cabec2   := IIF(cPaisLoc == "MEX",STR0079,STR0034)	//"                  EMISSAO   FORNEC "
	If aTamSXG[1]  !=  aTamSXG[3] //"NUMERO       SER   DATA     CODIGO               RAZAO SOCIAL         PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1   := IIF(cPaisLoc == "MEX", STR0077, STR0047)        // 123456789012  123 99/99/9999 12345678901234567890 1234567890123456 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Else                                                       //"NUMERO       SER   DATA     CODIGO RAZAO SOCIAL                       PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1   := IIF(cPaisLoc == "BRA", STR0033, IIF(cPaisLoc == "MEX",STR0078,STR0053))  // 123456789012 123 99/99/9999 123456 123456789012345678901234567890 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Endif
Elseif nOrdem == 2
	nPosNome := 29
	nTamNome := 30
	cabec1   := STR0036	 //"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
	If aTamSXG[1] != aTamSXG[3]			                     //"NUMERO       EMISSAO    FORNEC               RAZAO SOCIAL    LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO     VALOR TOTAL"
		cCabec  := IIF(cPaisLoc == "BRA", STR0048, IIF(cPaisLoc == "MEX",STR0080,STR0054)) // 012345678901 99/99/9999 12345678901234567890 1234567890123456 12 123 123 12345 12345 1  1234567890123 12345678901234  12345678901234
	Else
		cCabec  := IIF(cPaisLoc == "MEX",STR0081,STR0037)	   //"NUMERO       EMISSAO    FORNEC RAZAO SOCIAL                  LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO     VALOR TOTAL"
		// 						  012345678901 99/99/9999 123456 12345679012345678901234567890  12 123 123 12345 12345 1  1234567890123 12345678901234   12345678901234
	Endif
Elseif (nOrdem == 3 .Or. nOrdem == 4) .And. mv_par05 == 1
	nPosNome    := 35
	nTamNome    := 23
	cabec1      := STR0036	 //"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
	If aTamSXG[1] != aTamSXG[3]                             //"NUMERO       PRODUTO         FORNEC              RAZAO SOCIAL LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
		cCabec  := IIF(cPaisLoc == "BRA", STR0049, IIF(cPaisLoc == "MEX",STR0082,STR0055)) // 123456789012 123456789012345 12345678901234567890 12345678901 12 123 001 12345 12345 1  9,999,999,999 99,999,999,999 9999,999,999,999
	Else                         //"NUMERO       PRODUTO         FORNEC RAZAO SOCIAL              LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
		cCabec  := IIF(cPaisLoc == "MEX",STR0083,STR0044)	     // 123456789012 123456789012345 123456 1234567890123456789012345 12 123 001 12345 12345 1  9,999,999,999 99,999,999,999 9999,999,999,999
	Endif
Elseif (nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5) .And. mv_par05 == 2
	nPosNome := 35
	nTamNome := 30
	cabec2   := Iif(nOrdem == 3,STR0058,STR0060)	//"                  DIGITAC   FORNEC "
	If cPaisLoc == "MEX"
		cabec2 := Space(nIncCol)+cabec2
	Endif
	If aTamSXG[1] != aTamSXG[3]   //"NUMERO       SER   DATA     CODIGO               RAZAO SOCIAL         PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1 := IIF(cPaisLoc == "MEX", STR0077, STR0047)         // 123456789012  123 99/99/9999 12345678901234567890 1234567890123456 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Else                                                     //"NUMERO       SER   DATA     CODIGO RAZAO SOCIAL                       PRACA       PGTO     ICM            IPI       TOTAL MERCADORIA"
		cabec1 := IIF(cPaisLoc == "BRA", STR0033, IIF(cPaisLoc == "MEX",STR0078,STR0053))  // 123456789012 123 99/99/9999 123456 123456789012345678901234567890 123456789012345 XXX 999,999,999.99 999,999,999.99 9,999,999,999.99
	Endif
Elseif nOrdem == 5 .And. mv_par05 == 1
	cabec1 := STR0036	 //"RELACAO DAS NOTAS FISCAIS DE COMPRAS"
	                     //"NUMERO       PRODUTO           DIGITACAO      EMISSAO         LC CFO TE  ICM   IPI   TP    QUANTIDADE VALOR UNITARIO      VALOR TOTAL"
	cCabec := IIF(cPaisLoc == "MEX", STR0084, STR0063)	 // 123456789012 123456789012345   1234567890     1234567890      12 123 001 12345 12345 1  9,999,999,999 99,999,999,999 9999,999,999,999
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso nao utilize tamanho min, considera tamanho max e altera  ³
//³layout de impressao ref grupo 001                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aTamSXG[1] != aTamSXG[3]
	nPosNome += aTamSXG[4]-aTamSXG[3]
	nTamNome -= aTamSXG[4]-aTamSXG[3]
EndIf

If aTamSXG2[1] != aTamSXG2[3]
	nPosNome += aTamSXG2[4]-aTamSXG2[3]
	nTamNome -= aTamSXG2[4]-aTamSXG2[3]
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona a Ordem de todos os Arquivos usados no Relatorio   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
dbSelectArea("SA2")
dbSetOrder(1)
dbSelectArea("SB1")
dbSetOrder(1)
dbSelectArea("SF4")
dbSetOrder(1)
dbselectarea("SF1")
dbsetorder(1)
dbSelectArea("SD1")
dbSetOrder(1)

#IFDEF TOP
   If (TcSrvType()#'AS/400')
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Query para SQL                 ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      aStrucSF1 := SF1->(dbStruct())
      aStrucSD1 := SD1->(dbStruct())
      cALiasSF1 := "QRYSD1"
      cAliasSD1 := "QRYSD1"
      cALiasSB1 := IIF(!lEasy,"QRYSD1","SB1")
      cALiasSA1 := "QRYSD1"
      cALiasSA2 := "QRYSD1"
	  lQuery :=.T.
	  
	  cQuery := "SELECT "
	  If nOrdem == 1
	     cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
      ElseIf nOrdem == 2 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 3 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 4 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 5 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_ITEM,"
      Endif    

 	  cQuery += "D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_VALFRE,D1_DESPESA,D1_SEGURO,D1_PEDIDO,D1_ITEMPC,"      
	  cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
      For nX := 1 To Len(acampos)
			cQuery +=acampos[nX]+"," 		 		
	  Next nX
 
      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³Esta rotina foi escrita para adicionar no select os campos         ³
      //³usados no filtro do usuario quando houver, a rotina acrecenta      ³
      //³somente os campos que forem adicionados ao filtro testando         ³
      //³se os mesmo já existem no select ou se forem definidos novamente   ³
      //³pelo o usuario no filtro, esta rotina acrecenta o minimo possivel  ³
      //³de campos no select pois pelo fato da tabela SD1 ter muitos campos |
      //³e a query ter UNION ao adicionar todos os campos do SD1 estava     |
      //³derrubando o TOP CONNECT e abortando o sistema.                    |
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
      If !Empty(aReturn[7])
		 For nX := 1 To SD1->(FCount())
		 	cName := SD1->(FieldName(nX))
		 	If AllTrim( cName ) $ aReturn[7]
	      		If aStrucSD1[nX,2] <> "M"  
	      			If !cName $ cQuery .And. !cName $ cQryAd
		        		cQryAd += cName +","
		          	Endif 	
		       	EndIf
			EndIf 			       	
		 Next nX
      Endif    
     
      cQuery += cQryAd		
  
      cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
      cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_VALBRUT,"
      
      // parte customizada - Flavio - 17/03/2010
      cQuery += "F1_IRRF, F1_ISS, F1_VALPIS, F1_VALCOFI, F1_VALCSLL, F1_VALIRF, F1_INSS, F1_ESPECIE, "
                                 
      // Verifica se os campos existem
      if SF1->(FieldPos("F1_USUARIO")) > 0
      	cQuery += "F1_USUARIO, "
      EndIf
      
      if SF1->(FieldPos("F1_NATUREZ")) > 0
      	cQuery += "F1_NATUREZ, "
      EndIf

      If !lEasy        
         cQuery += "B1_DESC,B1_GRUPO,"
      EndIf

    cQuery += "A1_NOME,A1_MUN, A1_CGC, SD1.R_E_C_N_O_ SD1RECNO "
	  cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"

      If !lEasy
	     cQuery += RetSqlName("SB1")+" SB1 ,"
      EndIf

	  cQuery += RetSqlName("SA1")+" SA1  "
      cQuery += "WHERE "
      cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
  	  cQuery += "NOT ("+IsRemito(3,'SF1.F1_TIPODOC')+ ") AND "
	  cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
 	  cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
      cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
      cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
      cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
      cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
      cQuery += "SD1.D1_TIPO IN ('D','B') AND "
      cQuery += "SD1.D1_TIPODOC = SF1.F1_TIPODOC AND "
      cQuery += "SD1.D_E_L_E_T_ <> '*' AND "
      
      If !lEasy        	        
         cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
         cQuery += "SB1.B1_COD = SD1.D1_COD AND "
         cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
      EndIf
      
	  cQuery += "SA1.A1_FILIAL ='"+xFilial("SA1")+"' AND "
	  cQuery += "SA1.A1_COD = SD1.D1_FORNECE AND "
	  cQuery += "SA1.A1_LOJA = SD1.D1_LOJA AND "
	  cQuery += "SA1.D_E_L_E_T_ <> '*' AND "
	  cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
	  cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
	  cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
	  cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
	  cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
	  cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
	  cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
	  cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
	  cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
	  cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
	  cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
	  cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
	  cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
	  cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' AND "
	  cQuery += "D1_TES >= '"  	        + MV_PAR16	+ "' AND "
	  cQuery += "D1_TES <= '"  	        + MV_PAR17	+ "' "
      cQuery += "UNION "

	  cQuery += "SELECT "
	  If nOrdem == 1
	     cQuery += "SD1.D1_FILIAL,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD,SD1.D1_ITEM,"
      ElseIf nOrdem == 2 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_COD,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 3 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_DTDIGIT,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 4 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_EMISSAO,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_FORNECE,SD1.D1_LOJA,"
      ElseIf nOrdem == 5 
	     cQuery += "SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_DOC,SD1.D1_SERIE,SD1.D1_ITEM,"
      Endif    

      cQuery += "D1_DTDIGIT,D1_COD,D1_QUANT,D1_VUNIT,D1_TOTAL,D1_VALFRE,D1_DESPESA,D1_SEGURO,D1_PEDIDO,D1_ITEMPC,"
	  cQuery += "D1_TES,D1_IPI,D1_PICM,D1_TIPO,D1_CF,D1_GRUPO,D1_LOCAL,D1_ITEM,D1_EMISSAO,D1_VALDESC,D1_ICMSRET,D1_VALICM,D1_VALIPI,"
 	  For nX := 1 To Len(acampos)
			cQuery +=acampos[nX]+","
 	  Next nX
     
      cQuery += cQryAd		      		
      cQuery += "F1_FILIAL,F1_MOEDA,F1_TXMOEDA,F1_DTDIGIT,F1_TIPO,F1_COND,F1_VALICM,F1_VALIPI,F1_VALIMP1,"
      cQuery += "F1_FRETE,F1_DESPESA,F1_SEGURO,F1_DESCONT,F1_VALMERC,F1_DOC,F1_SERIE,F1_EMISSAO,F1_FORNECE,F1_LOJA,F1_VALBRUT,"
      
      // parte customizada - Flavio - 17/03/2010
      cQuery += "F1_IRRF, F1_ISS, F1_VALPIS, F1_VALCOFI, F1_VALCSLL, F1_VALIRF, F1_INSS, F1_ESPECIE, "
                                 
      // Verifica se os campos existem
      if SF1->(FieldPos("F1_USUARIO")) > 0
      	cQuery += "F1_USUARIO, "
      EndIf
      
      if SF1->(FieldPos("F1_NATUREZ")) > 0
      	cQuery += "F1_NATUREZ, "
      EndIf
      
      If !lEasy        
         cQuery += "B1_DESC,B1_GRUPO,"
      EndIf

      cQuery += "A2_NOME,A2_MUN, A2_CGC, SD1.R_E_C_N_O_ SD1RECNO "
	  cQuery += "FROM "+RetSqlName("SF1")+" SF1 ,"+RetSqlName("SD1")+" SD1 ,"

      If !lEasy        	  
	     cQuery += RetSqlName("SB1")+" SB1 ,"
      EndIf

	  cQuery += RetSqlName("SA2")+" SA2 "
      cQuery += "WHERE "
      cQuery += "SF1.F1_FILIAL='"+xFilial("SF1")+"' AND "
	  cQuery += "SF1.D_E_L_E_T_ <> '*' AND "
 	  cQuery += "NOT ("+IsRemito(3,'SF1.F1_TIPODOC')+ ") AND "
	  cQuery += "SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
      cQuery += "SD1.D1_DOC = SF1.F1_DOC AND "
      cQuery += "SD1.D1_SERIE = SF1.F1_SERIE AND "
      cQuery += "SD1.D1_FORNECE = SF1.F1_FORNECE AND "
      cQuery += "SD1.D1_LOJA = SF1.F1_LOJA AND "
      cQuery += "SD1.D1_TIPO NOT IN ('D','B') AND "                       
      cQuery += "SD1.D1_TIPODOC = SF1.F1_TIPODOC AND "
      cQuery += "SD1.D_E_L_E_T_ <> '*' AND "

      If !lEasy        	        
         cQuery += "SB1.B1_FILIAL ='"+xFilial("SB1")+"' AND "
         cQuery += "SB1.B1_COD = SD1.D1_COD AND "
         cQuery += "SB1.D_E_L_E_T_ <> '*' AND "
      EndIf
      
	  cQuery += "SA2.A2_FILIAL ='"+xFilial("SA2")+"' AND "
	  cQuery += "SA2.A2_COD = SD1.D1_FORNECE AND "
	  cQuery += "SA2.A2_LOJA = SD1.D1_LOJA AND "
	  cQuery += "SA2.D_E_L_E_T_ <> '*' AND "
	  cQuery += "D1_COD >= '"  		    + MV_PAR01	+ "' AND "
	  cQuery += "D1_COD <= '"  	        + MV_PAR02	+ "' AND "
	  cQuery += "D1_DTDIGIT >= '" + DTOS(MV_PAR03)	+ "' AND "
	  cQuery += "D1_DTDIGIT <= '" + DTOS(MV_PAR04)	+ "' AND "
	  cQuery += "D1_GRUPO >= '"  		+ MV_PAR06	+ "' AND "
	  cQuery += "D1_GRUPO <= '"  		+ MV_PAR07	+ "' AND "
	  cQuery += "D1_FORNECE >= '"  		+ MV_PAR08	+ "' AND "
	  cQuery += "D1_FORNECE <= '"  		+ MV_PAR09	+ "' AND "
	  cQuery += "D1_LOCAL >= '"  		+ MV_PAR10	+ "' AND "
	  cQuery += "D1_LOCAL <= '"  		+ MV_PAR11	+ "' AND "
	  cQuery += "D1_DOC >= '"  	    	+ MV_PAR12	+ "' AND "
	  cQuery += "D1_DOC <= '"  		    + MV_PAR13	+ "' AND "
	  cQuery += "D1_SERIE >= '"  		+ MV_PAR14	+ "' AND "
	  cQuery += "D1_SERIE <= '"  		+ MV_PAR15	+ "' AND "
	  cQuery += "D1_TES >= '"  	        + MV_PAR16	+ "' AND "
	  cQuery += "D1_TES <= '"  	        + MV_PAR17	+ "' "

	  If nOrdem == 1
	     cQuery += " ORDER BY 1,2,3,4,5,6,7"		
      ElseIf nOrdem == 2 
	     cQuery += " ORDER BY 1,2,3,4,5,6"		
      ElseIf nOrdem == 3 
	     cQuery += " ORDER BY 1,2,3,4,5,6"
      ElseIf nOrdem == 4 
	     cQuery += " ORDER BY 1,2,3,4,5,6"
      ElseIf nOrdem == 5 
	     cQuery += " ORDER BY 1,2,3,4,5,6"
      Endif
	  cQuery := ChangeQuery(cQuery)

	  dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'QRYSD1', .T., .T.)

    For nX := 1 to Len(aStrucSD1)
         If aStrucSD1[nX,2] != 'C' .And. FieldPos(aStrucSD1[nx,1]) > 0
            TCSetField('QRYSD1', aStrucSD1[nX,1], aStrucSD1[nX,2],aStrucSD1[nX,3],aStrucSD1[nX,4])
         EndIf	
      Next nX

      For nX := 1 to Len(aStrucSF1)
         If aStrucSF1[nX,2] != 'C'.And. FieldPos(aStrucSF1[nx,1]) > 0
            TCSetField('QRYSD1', aStrucSF1[nX,1], aStrucSF1[nX,2],aStrucSF1[nX,3],aStrucSF1[nX,4])
         EndIf	
      Next nX
   Else 
#ENDIF        

cQuery 	+= "D1_FILIAL=='"+xFilial("SD1")+"'.And.D1_DOC>='"+mv_par12+"'.And.D1_DOC<='"+mv_par13+"'"
cQuery	+= ".And.D1_SERIE>='"+mv_par14+"'.And.D1_SERIE<='"+mv_par15+"'.And."
cQuery 	+= "D1_COD>='"+mv_par01+"'.And.D1_COD<='"+mv_par02+"'.And."
cQuery 	+= "DTOS(D1_DTDIGIT)>='"+DTOS(mv_par03)+"'.And.DTOS(D1_DTDIGIT)<='"+DTOS(mv_par04)+"'"
cQuery  += ".And. !("+IsRemito(2,'SD1->D1_TIPODOC')+")"			
If nOrdem == 1
   dbSetOrder(1)
   IndRegua("SD1",cIndex,IndexKey(),,cQuery)
Elseif nOrdem == 2
   dbSetOrder(2)
   IndRegua("SD1",cIndex,IndexKey(),,cQuery)
Elseif nOrdem == 3
	IndRegua("SD1",cIndex,"D1_FILIAL+DTOS(D1_DTDIGIT)+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA",,cQuery)
Elseif nOrdem == 4
   dbSetOrder(3)
   IndRegua("SD1",cIndex,IndexKey(),,cQuery)
Elseif nOrdem == 5
	IndRegua("SD1",cIndex,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_DOC+D1_SERIE+D1_ITEM",,cQuery)
Endif

nIndex := RetIndex("SD1")

#IFNDEF TOP
	dbSetIndex(cIndex+OrdBagExt())
#ENDIF

dbSetOrder(nIndex+1)

if nOrdem == 2
	dbSeek(xFilial("SD1")+mv_par01,.T.)
Else
	dbSeek(xFilial("SD1"),.T.)
Endif

#IFDEF TOP	
   Endif
#ENDIF                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona o cabecalho da Nota Fiscal                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lQuery
	(cAliasSF1)->(dbseek(xFilial("SF1")+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA))
EndIf	
nTaxa  := (cAliasSF1)->F1_TXMOEDA
nMoeda := (cAliasSF1)->F1_MOEDA
dDtDig := (cAliasSF1)->F1_DTDIGIT

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona Area do While e retorna o total Elementos da regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbselectArea(cAliasSD1)
SetRegua(SD1->(RecCount()))

cDocAnt := (cAliasSD1)->D1_FILIAL + (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA

nNumDocs := 0

While !Eof() .And. (cAliasSD1)->D1_FILIAL == xFilial("SD1") 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se cancelado pelo usuario                            	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lEnd
		@PROW()+1,001 PSAY STR0013	//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	                                                        
	If IsRemito(1,"SD1->D1_TIPODOC")
		dbSkip()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a validacao dos filtros do usuario           	     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lFiltro := IIf((!Empty(aReturn[7]).And.!&(aReturn[7])) .Or.;
	(D1_COD     < mv_par01 .Or. D1_COD     > mv_par02) .Or. ;
	(D1_DTDIGIT < mv_par03 .Or. D1_DTDIGIT > mv_par04) .Or. ;
	(D1_GRUPO   < mv_par06 .Or. D1_GRUPO   > mv_par07) .Or. ;
	(D1_FORNECE < mv_par08 .Or. D1_FORNECE > mv_par09) .Or. ;
	(D1_LOCAL   < mv_par10 .Or. D1_LOCAL   > mv_par11) .Or. ;
	(D1_DOC     < mv_par12 .Or. D1_DOC     > mv_par13) .Or. ;
	(D1_SERIE   < mv_par14 .Or. D1_SERIE   > mv_par15) .Or. ;
	(D1_TES     < mv_par16 .Or. D1_TES     > mv_par17),.F.,.T.)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica moeda nao imprimir com moeda diferente da escolhida  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par19 == 2
		if if((cAliasSF1)->F1_MOEDA == 0,1,(cAliasSF1)->F1_MOEDA) != mv_par18
			lFiltro := .F.
		Endif
	Endif
	
	// Flavio,  23-03-2010
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtra pelo usuáro                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if SF1->(FieldPos("F1_USUARIO")) > 0 .And. !Empty(mv_par23)
		if upper(ALLTRIM((cAliasSD1)->F1_USUARIO)) != upper(ALLTRIM(mv_par23))
			lFiltro := .F.
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Nota Fiscal Cancelada.                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	#IFDEF SHELL
		If D1_CANCEL == "S"
			lFiltro := .F.
		EndIf
	#ENDIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza Nota Fiscal sem TES de acordo com parametro         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If mv_par22 == 2 .And. Empty(D1_TES)
		lFiltro := .F.
	Endif
	
	If lFiltro
		
		If li > 56
			cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
		Endif
		
		lImp := .T.
		cDescri := ""
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o parametro para imprimir a descricao do produto    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Empty(mv_par21)
			mv_par21 := "B1_DESC"
		ElseIf AllTrim(mv_par21) == "B5_CEME" // Impressao da descricao cientifica do Produto.
			dbSelectArea("SB5")
			dbSetOrder(1)
			If dbSeek( xFilial("SB5")+(cAliasSD1)->D1_COD )
				cDescri := Alltrim(B5_CEME)
			EndIf
		ElseIf AllTrim(mv_par21) == "C7_DESCRI" // Impressao da descricao do Produto no pedido de compras.
			dbSelectArea("SC7")
			dbSetOrder(4)
			If dbSeek( xFilial("SC7")+(cAliasSD1)->D1_COD+(cAliasSD1)->D1_PEDIDO+(cAliasSD1)->D1_ITEMPC )
				cDescri := Alltrim(SC7->C7_DESCRI)
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz a Quebra da Linha de descricao para todas ordens do Rela.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lDescLine == .T.
			
			If nOrdem == 1 .And. mv_par05 == 1
				li++
				@li,000 PSAY "NRO :" + (cAliasSD1)->D1_DOC + " " + (cAliasSD1)->D1_SERIE + " - " +	(cAliasSD1)->F1_ESPECIE	 //" NUMERO : "
				@li,026+nIncCol PSAY STR0027 + Dtoc((cAliasSD1)->D1_EMISSAO)		                     //" EMISSAO: "
				@li,045+nIncCol PSAY STR0028 + Dtoc((cAliasSD1)->D1_DTDIGIT)		                     //" DIG.:    "
				@li,061+nIncCol PSAY STR0029 + (cAliasSD1)->D1_TIPO				                     //" TIPO:    "
				
				If (cAliasSD1)->D1_TIPO $ "BD"
					@li,068+nIncCol PSAY "CLI: " // + (cAliasSD1)->D1_FORNECE + " " + (cAliasSD1)->D1_LOJA	 //" CLIENTE    : "
					If !lQuery
						(cAliasSA1)->(dbSeek(xFilial("SA1") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
					Endif
					@li,76+nIncCol PSAY (cAliasSA1)->A1_CGC + SUBSTR((cAliasSA1)->A1_NOME,1,30)
				Else
					@li,068+nIncCol PSAY "FORN:" //+ (cAliasSD1)->D1_FORNECE + " " + (cAliasSD1)->D1_LOJA	 //" FORNECEDOR : "
					If !lQuery
						(cAliasSA2)->(dbSeek(xFilial("SA2") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
						@li,76+nIncCol PSAY (cAliasSA2)->A2_CGC + SUBSTR((cAliasSA2)->A2_NOME,1,30)
					Else
						@li,76+nIncCol PSAY (cAliasSA1)->A1_CGC + SUBSTR((cAliasSA1)->A1_NOME,1,30)
					Endif
				EndIf
				
				li++
				@li,000 PSAY cCabec
				li++
				
			Elseif nOrdem == 2
				@li,000 PSAY STR0038 + (cAliasSD1)->D1_COD		  //"PRODUTO : "
				@li,027 PSAY STR0039		                      //"DESCRICAO : "
				
				If !lQuery .Or. lEasy
					(cAliasSB1)->(dbSeek(xFilial("SB1") + (cAliasSD1)->D1_COD))
				EndIf
				
				If Empty(cDescri) .Or. AllTrim(mv_par21) == "B1_DESC" // Impressao da descricao generica do Produto.
					cDescri := Alltrim((cAliasSB1)->B1_DESC)
				EndIf
				
				dbSelectArea(cAliasSD1)
				nLinha:= MLCount(cDescri,nTamDesc)
				@ li,040 PSAY MemoLine(cDescri,nTamDesc,1)
				@li ,72 PSAY STR0040			                 //"GRUPO : "
				@li ,81 PSAY (cAliasSB1)->B1_GRUPO				
				For nX := 2 To nLinha
					li++
					If li > 56
						cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
					Endif
					@ li,040 PSAY Memoline(cDescri,nTamDesc,nX)
				Next nX
												
				li++
				@li,000 PSAY cCabec
				cCodAnt   := (cAliasSD1)->D1_COD
				nTotProd  := 0
				nTotQuant := 0
				
			Elseif nOrdem == 3 .Or. nOrdem == 4
				If mv_par05 == 1
					@li,000 PSAY IIf(nOrdem == 3,STR0045,STR0061) //"DATA DE DIGITACAO : "  ### "DATA DE EMISSAO : "
					@li,020 PSAY IIf(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
					@li+1,0 PSAY cCabec
				Endif
				li++
				dDataAnt := IIf(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
			Elseif nOrdem == 5
				If mv_par05 == 1
					@li,000 PSAY STR0064 //"FORNECEDOR :"

					If (cAliasSD1)->D1_TIPO $ "BD"
						If !lquery
							(cAliasSA1)->(dbSeek(xFilial("SA1") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
						Endif
						@li,020 PSAY (cAliasSD1)->D1_FORNECE+" "+(cAliasSD1)->D1_LOJA+" "+(cAliasSA1)->A1_NOME
					Else
						If !lquery
							(cAliasSA2)->(dbSeek(xFilial("SA2") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
							@li,020 PSAY (cAliasSD1)->D1_FORNECE+" "+(cAliasSD1)->D1_LOJA+" "+(cAliasSA2)->A2_NOME
						Else
							@li,020 PSAY (cAliasSD1)->D1_FORNECE+" "+(cAliasSD1)->D1_LOJA+" "+(cAliasSA1)->A1_NOME
						Endif
					EndIf
		
					@li+1,0 PSAY cCabec
				Endif
				li++
				cFornAnt := (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA
			Endif
			lDescLine := .F.
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona o F4 para todas as ordens quando nao for query TES  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		(cAliasSF4)->(dbSeek(xFilial("SF4") + (cAliasSD1)->D1_TES))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Impressao do corpo do relatorio para todas as ordens          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOrdem == 1 .Or. (nOrdem == 3 .And. mv_par05 == 2) .Or. (nOrdem == 4 .And. mv_par05 == 2) .Or. (nOrdem == 5 .And. mv_par05 == 2)
			
			If mv_par05 == 1
				
				@li,00 PSAY (cAliasSD1)->D1_COD

				If !lQuery .Or. lEasy
					(cAliasSB1)->(dbSeek(xFilial("SB1") + (cAliasSD1)->D1_COD))
				EndIf
				
				If Empty(cDescri) .Or. AllTrim(mv_par21) == "B1_DESC" // Impressao da descricao generica do Produto.
					cDescri := Alltrim((cAliasSB1)->B1_DESC)
				EndIf
				
				If Empty(cDescri) 
					cDescri := Space(28)
				Endif
				
				dbSelectArea(cAliasSD1)
				nLinha:= MLCount(cDescri,nTamDesc)
				@ li,021 PSAY MemoLine(cDescri,nTamDesc,1)
				For nX := 2 To nLinha
					li++
					If li > 56
						cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
					Endif
					@ li,021 PSAY Memoline(cDescri,nTamDesc,nX)
				Next nX
				
				If cPaisLoc <> "BRA"
					
					nImpInc	  := 0
					nImpNoInc := 0
					nImpos	  := 0
					
					aImpostos := TesImpInf((cAliasSD1)->D1_TES)
					For nY := 1 to Len(aImpostos)
						cCampImp := (cAliasSD1)+"->" + (aImpostos[nY][2])
						nImpos   := &cCampImp
						nImpos   := xmoeda(nImpos,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
						If ( aImpostos[nY][3] == "1" )
							nImpInc	+= nImpos
						Else
							If aImpostos[nY][3] == "2" 
								nImpinc -= nImpos
							Else
								nImpNoInc += nImpos
							Endif
						EndIf
					Next
					
					@li,051 PSAY (cAliasSD1)->D1_TES
					@li,055 PSAY nImpNoInc   Picture TM(nImpNoInc,9)
					@li,065 PSAY nImpInc     Picture TM(nImpInc,9)
					@li,078 PSAY (cAliasSD1)->D1_LOCAL
					
					nValImpInc	+= nImpInc
					nValImpNoInc+= nImpNoInc
					nValMerc 	:= nValMerc + xmoeda((cAliasSD1)->D1_TOTAL,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
					
					nTgImpInc 	+= nImpInc
					nTgImpNoInc += nImpNoInc
					nTotGeral 	:= nTotGeral + xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
					
					nValMerc    += nImpInc
					nTotGeral   += nImpInc
				Else
					@li,050 PSAY (cAliasSD1)->D1_CF
					@li,056 PSAY (cAliasSD1)->D1_TES
					@li,060 PSAY (cAliasSD1)->D1_PICM    Picture "@E 9,999.99"
					@li,070 PSAY (cAliasSD1)->D1_IPI     Picture "@E 9,999.99"
					@li,080 PSAY (cAliasSD1)->D1_LOCAL

          nValIcm   += (cAliasSD1)->D1_VALICM
          nValIpi   += (cAliasSD1)->D1_VALIPI						
          nTgerIcm  += (cAliasSD1)->D1_VALICM
          nTgerIpi  += (cAliasSD1)->D1_VALIPI

					If (cAliasSF4)->F4_AGREG != "N"
						nValMerc  := nValMerc + (cAliasSD1)->D1_TOTAL + (cAliasSD1)->D1_ICMSRET
						nTotGeral := nTotGeral + (cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
			            If (cAliasSF4)->F4_AGREG = "I"
				           nValMerc  += (cAliasSD1)->D1_VALICM
				           nTotGeral += (cAliasSD1)->D1_VALICM
                        Endif 
					Else 
						nTotGeral := nTotGeral - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Soma valor do IPI caso a nota nao seja compl. de IPI    	 ³
					//³ e o TES Calcula IPI nao seja "R"                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (cAliasSF4)->(dbSeek(xFilial("SF4") + (cAliasSD1)->D1_TES))
						If (cAliasSD1)->D1_TIPO != "P" .And. (cAliasSF4)->F4_IPI != "R"
							nValMerc  += (cAliasSD1)->D1_VALIPI
							nTotGeral += (cAliasSD1)->D1_VALIPI
						EndIf
					Else
						If (cAliasSD1)->D1_TIPO != "P"
							nValMerc  += (cAliasSD1)->D1_VALIPI
							nTotGeral += (cAliasSD1)->D1_VALIPI
						EndIf
					EndIf
				EndIf
				
				@li,084 PSAY (cAliasSD1)->D1_QUANT		Picture tm((cAliasSD1)->D1_QUANT,14)
				@li,101 PSAY xmoeda((cAliasSD1)->D1_VUNIT,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_VUNIT",14,mv_par18)
				@li,115 PSAY xmoeda((cAliasSD1)->D1_TOTAL,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
				li++
				
				nValDesc  += xmoeda((cAliasSD1)->D1_VALDESC,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
				nTotDesco += xmoeda((cAliasSD1)->D1_VALDESC,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
				
			ElseIf mv_par05 == 2
				
				nTotUser++   //Guilherme
				
				If cPaisLoc <> "BRA"
					aImpostos := TesImpInf((cAliasSD1)->D1_TES)
					For nY := 1 to Len(aImpostos)
						cCampImp := (cAliasSD1)+"->" + (aImpostos[nY][2])
						nImpos   := &cCampImp
						nImpos   := xmoeda(nImpos,(cAliasSF1)->F1_MOEDA,mv_par18,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
						If ( aImpostos[nY][3] == "1" )
							nImpInc	+= nImpos
						Else
							If aImpostos[nY][3] == "2" 
								nImpInc -= nImpos
							Else
								nImpNoInc += nImpos
							Endif
						EndIf
					Next
					nValMerc := nValMerc + xmoeda(D1_TOTAL - D1_VALDESC,(cAliasSF1)->F1_MOEDA,mv_par18,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
				Else

                    nValIcm  += (cAliasSD1)->D1_VALICM
                    nValIpi  += (cAliasSD1)->D1_VALIPI
					
					If (cAliasSF4)->F4_AGREG != "N"
						nValMerc := nValMerc + (cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
			            If (cAliasSF4)->F4_AGREG = "I"
				            nValMerc += (cAliasSD1)->D1_VALICM
                        Endif 
					Else	
						nValMerc := nValMerc - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
					Endif
					
					If (cAliasSF4)->(dbSeek(xFilial("SF4") + (cAliasSD1)->D1_TES))
						nValMerc += IF((cAliasSF1)->F1_TIPO != "P" .And. (cAliasSF4)->F4_IPI != "R",(cAliasSD1)->D1_VALIPI,0)
					Else
						nValMerc += IF((cAliasSF1)->F1_TIPO != "P",(cAliasSD1)->D1_VALIPI,0)
					EndIf
				EndIf
			Endif
		Else
			li++
			@li,00 PSAY (cAliasSD1)->D1_DOC
			If nOrdem == 2
				@li,13+nIncCol PSAY (cAliasSD1)->D1_EMISSAO
				@li,22+nIncCol PSAY (cAliasSD1)->D1_FORNECE
			Elseif nOrdem == 3 .Or. nOrdem == 4
				@li,13+nIncCol PSAY (cAliasSD1)->D1_COD
				@li,28+nIncCol PSAY (cAliasSD1)->D1_FORNECE
			Elseif nOrdem == 5
				@li,13+nIncCol PSAY (cAliasSD1)->D1_COD
				@li,30+nIncCol PSAY (cAliasSD1)->D1_EMISSAO
				@li,44+nIncCol PSAY (cAliasSD1)->D1_DTDIGIT
			Endif
			
			If nOrdem <> 5			
				If (cAliasSD1)->D1_TIPO $ "BD"
					If !lquery
						(cAliasSA1)->(dbSeek(xFilial("SA1") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
					Endif
					@li,nPosNome+nIncCol PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
				Else
					If !lquery
					(cAliasSA2)->(dbSeek(xFilial("SA2") + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA))
						@li,nPosNome+nIncCol PSAY SUBSTR((cAliasSA2)->A2_NOME,1,nTamNome)
					Else
						@li,nPosNome+nIncCol PSAY SUBSTR((cAliasSA1)->A1_NOME,1,nTamNome)
					Endif
				EndIf				
			EndIf
			
			@li,060+nIncCol PSAY (cAliasSD1)->D1_LOCAL
			If cPaisLoc == "BRA"
				@li,063 PSAY (cAliasSD1)->D1_CF
				@li,069 PSAY (cAliasSD1)->D1_TES
				@li,073 PSAY (cAliasSD1)->D1_PICM	Picture "@E 9,999.99"
			Else
				@li,069+nIncCol PSAY (cAliasSD1)->D1_TES
			EndIf
			@li,079+nIncCol PSAY (cAliasSD1)->D1_IPI		Picture "@E 9,999.99"
			@li,085+nIncCol PSAY (cAliasSD1)->D1_TIPO
			@li,088+nIncCol PSAY (cAliasSD1)->D1_QUANT	    Picture TM((cAliasSD1)->D1_QUANT,13)
			@li,102+nIncCol PSAY xmoeda((cAliasSD1)->D1_VUNIT,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_VUNIT",14,mv_par18)
			@li,118+nIncCol PSAY xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SD1","D1_TOTAL",14,mv_par18)
			
			If (cAliasSF4)->F4_AGREG != "N"
				nTotProd  += xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
				nTotQuant += (cAliasSD1)->D1_QUANT
				nTotData  += xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,,nDecs+1,nTaxa)
				nTotForn  += xmoeda((cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,,nDecs+1,nTaxa)
			    If (cAliasSF4)->F4_AGREG = "I"
				    nTotProd  += xmoeda((cAliasSD1)->D1_VALICM,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
				    nTotData  += xmoeda((cAliasSD1)->D1_VALICM,nMoeda,mv_par18,,nDecs+1,nTaxa)
				    nTotForn  += xmoeda((cAliasSD1)->D1_VALICM,nMoeda,mv_par18,,nDecs+1,nTaxa)
                Endif 
			Else
				nTotProd  -= xmoeda((cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
				nTotData  -= xmoeda((cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,,nDecs+1,nTaxa)				
				nTotForn  -= xmoeda((cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET,nMoeda,mv_par18,,nDecs+1,nTaxa)				
			Endif  

			If cPaisLoc <> "BRA" // Inserido BOPS 92436
				aImpostos := TesImpInf((cAliasSD1)->D1_TES)
				For nY := 1 to Len(aImpostos)
					cCampImp := (cAliasSD1)+"->" + (aImpostos[nY][2])
					nImpos   := &cCampImp
					nImpos   := xmoeda(nImpos,(cAliasSF1)->F1_MOEDA,mv_par18,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
					If ( aImpostos[nY][3] == "1" )
						nImpInc	+= nImpos
					Else
						If aImpostos[nY][3] == "2" 
							nImpInc -= nImpos
						Else
							nImpNoInc += nImpos
						Endif
					EndIf
				Next
				nValMerc := nValMerc + xmoeda(D1_TOTAL - D1_VALDESC,(cAliasSF1)->F1_MOEDA,mv_par18,(cAliasSF1)->F1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)
			Else
                nValIcm  += (cAliasSD1)->D1_VALICM
                nValIpi  += (cAliasSD1)->D1_VALIPI
				
				If (cAliasSF4)->F4_AGREG != "N"
					nValMerc := nValMerc + (cAliasSD1)->D1_TOTAL - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
		            If (cAliasSF4)->F4_AGREG = "I"
			            nValMerc += (cAliasSD1)->D1_VALICM
                    Endif 
				Else	
					nValMerc := nValMerc - (cAliasSD1)->D1_VALDESC + (cAliasSD1)->D1_ICMSRET
				Endif
					
				If (cAliasSF4)->(dbSeek(xFilial("SF4") + (cAliasSD1)->D1_TES))
					nValMerc += IF((cAliasSF1)->F1_TIPO != "P" .And. (cAliasSF4)->F4_IPI != "R",(cAliasSD1)->D1_VALIPI,0)
				Else
					nValMerc += IF((cAliasSF1)->F1_TIPO != "P",(cAliasSD1)->D1_VALIPI,0)
				EndIf
			EndIf
            lPrintLine:= .T.

		Endif
  		
		nTotFrete += xmoeda((cAliasSD1)->D1_VALFRE,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
		nTotSeguro+= xmoeda((cAliasSD1)->D1_SEGURO ,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
		nTotDesp  += xmoeda((cAliasSD1)->D1_DESPESA,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
			  		
		cFornF1     := (cAliasSF1)->F1_FORNECE
		cLojaF1     := (cAliasSF1)->F1_LOJA
		cDocF1      := (cAliasSF1)->F1_DOC
		cSerieF1    := (cAliasSF1)->F1_SERIE
		cTipoF1     := (cAliasSF1)->F1_TIPO
		cCondF1     := (cAliasSF1)->F1_COND
		nMoedaF1    := (cAliasSF1)->F1_MOEDA
		nTxMoedaF1  := (cAliasSF1)->F1_TXMOEDA
		nFreteF1    := (cAliasSF1)->F1_FRETE
		nDespesaF1  := (cAliasSF1)->F1_DESPESA
		nSeguroF1   := (cAliasSF1)->F1_SEGURO
		nValTotF1   := (cAliasSF1)->F1_VALBRUT
		dEmissaoF1  := (cAliasSF1)->F1_EMISSAO
		dDtDigitF1  := (cAliasSF1)->F1_DTDIGIT
		
		// variáveis dos impostos
		cNFSE2 := (cAliasSD1)->F1_FILIAL + (cAliasSD1)->F1_FORNECE + (cAliasSD1)->F1_LOJA + (cAliasSD1)->F1_SERIE + (cAliasSD1)->F1_DOC
		// obtém a parte dos outros impostos de pis, confins, csll, e irf
		// F1_IRRF, F1_ISS, F1_VALPIS, F1_VALCOFI, F1_VALCSLL, F1_VALIRF, F1_INSS"
		cImpostos :=  "PIS : " + Transform((cAliasSD1)->F1_VALPIS, "@E 99,999.99") + "  |  " + ;
								  "COFINS : " + Transform((cAliasSD1)->F1_VALCOFI, "@E 99,999.99") + "  |  " + ;
								  "CSLL : " + Transform((cAliasSD1)->F1_VALCSLL, "@E 99,999.99") + "  |  " + ;
									"ISS : " + Transform((cAliasSD1)->F1_ISS, "@E 99,999.99") + "  |  " + ;
									"INSS : " + Transform((cAliasSD1)->F1_INSS, "@E 99,999.99") + "  |  " + ;
									"IRF : " + Transform((cAliasSD1)->F1_VALIRF, "@E 99,999.99")
									
		nTotNFLiq := nValMerc - nValDesc + nTotDesp + nTotFrete + nTotSeguro - (cAliasSD1)->F1_VALPIS - (cAliasSD1)->F1_VALCOFI - ;
								(cAliasSD1)->F1_VALCSLL - (cAliasSD1)->F1_ISS - (cAliasSD1)->F1_INSS - (cAliasSD1)->F1_VALIRF		
		
		If lQuery
			cForCli  := (cAliasSF1)->A1_NOME
			cMuni    := (cAliasSF1)->A1_MUN
		Endif
		
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Incrementa a Regua de processamento no salto do registro      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea(cAliasSD1)
	dbSkip()
	cbCont++
	IncRegua()
	
	If nOrdem == 1 .Or. (nOrdem == 3 .And. mv_par05 == 2) .Or. (nOrdem == 4 .And. mv_par05 == 2) .Or. (nOrdem == 5 .And. mv_par05 == 2)
		
		If ((cAliasSD1)->D1_FILIAL + (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA <> cDocAnt)
			
			If (nValIcm + nValMerc + nValIpi + nValImpInc + nValImpNoInc) > 0
			            
			  // incrementa o número de documentos gerados
				nNumDocs++
				
				If mv_par05 == 1
				
					li++
						//STR0014 + cCondF1		                 //"COND. PAGTO :"
					@li,000 PSAY "Tot. Liq: " + Transform(nTotNFLiq, "@E 9,999,999.99")
					
					@li,029 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051) //"TOTAL ICM :"					
					If ( cPaisLoc == "BRA" )
						@li,040 PSAY nValIcm   	Picture tm((cAliasSF1)->F1_VALICM,15)
						@li,056 PSAY STR0016							 //"TOTAL IPI :"
						@li,067 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI,15)
						
					Else
						@li,045 PSAY nValImpNoInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
						@li,061 PSAY STR0056							 //"TOTAL IPI :"   "TOT. I.INC.:"
						@li,077 PSAY nValImpInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
					EndIf
					
					aDups = {}					
					cNatDupl := ""					
					If !(cTipoF1 $ "BD")
						nDupl := 1
						SE2->(dbSetOrder(06)) //filial+fornecedor+loja+prefixo+num
						SE2->(dbSeek(cNFSE2)) // variavel que está acima, pois aqui já passou todos os dados
						while ((SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM) == cNFSE2 .And. nDupl < 7)
							if (SE2->E2_TIPO != "NF")
							  SE2->(dbSkip())
								loop
							EndIf // Numero, Valor, Vencimento
							cNatDupl := AllTrim(SE2->E2_NATUREZ) + " - " + Posicione("SED", 01, xFilial("SED") + SE2->E2_NATUREZ, "ED_DESCRIC")
							nValLiq := SE2->E2_VALOR - SE2->E2_ISS - SE2->E2_INSS - SE2->E2_CSLL - SE2->E2_COFINS - SE2->E2_PIS
							Aadd(aDups, {SE2->E2_NUM + " " + SE2->E2_PARCELA, DTOC(SE2->E2_VENCTO), Transform(nValLiq, "@E 99,999,999.99")})
							SE2->(dbSkip())
							nDupl++
						EndDo
						
						while (Len(aDups) < 6)
							Aadd(aDups, {"", "", ""})
						EndDo
					EndIf
					
					// Imprime a natureza
					@li, 088 PSAY "Natureza: " + cNatDupl					
					
					// imprime a parte dos outros impostos de pis, confins, csll, e irf
					li++
					// F1_IRRF, F1_ISS, F1_VALPIS, F1_VALCOFI, F1_VALCSLL, F1_VALIRF, F1_INSS"
					@li,000 PSAY cImpostos
					
					li++
					@li,000 PSAY STR0017							    //"FRETE :"
					@li,010 PSAY xmoeda(nTotFrete,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_FRETE",15,mv_par18)
					@li,029 PSAY STR0018							    //"DESP.:"
					@li,040 PSAY xmoeda(nTotDesp + nTotSeguro,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)Picture pesqpict("SF1","F1_DESPESA",15,mv_par18)
					@li,056 PSAY STR0019							    //"DESC.:"
					@li,067 PSAY nValDesc Picture pesqpict("SF1","F1_DESCONT",15,mv_par18)
					@li,096 PSAY STR0020							    //"TOTAL NOTA   :"
					if mv_par20 == 2
						@li,115 PSAY (nValMerc - nValDesc) + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_VALMERC",17,mv_par18)
						nTotGeral := nTotGeral + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
					else
						@li,115 PSAY xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_VALMERC",17,mv_par18)
						nTotGeral := nTotGeral - (nValMerc - nValDesc) + xmoeda( nValTotF1 ,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
					endIf
					
					// imprime as duplicatas
					If !(cTipoF1 $ "BD")
						// primeira linha de duplicatas
						if (aDups[1, 1] != "")
							li++							
							cDpLIn1 := ADups[1, 1] + "    " + ADups[1, 2] + " " + ADups[1, 3]
							cDpLIn2 := ADups[2, 1] + "    " + ADups[2, 2] + " "  + ADups[2, 3]
							cDpLIn3 := ADups[3, 1] + "    " + ADups[3, 2] + " " + ADups[3, 3]
							cLinImp = cDpLin1 + iif(ADups[2, 1] != "","  |  " + cDpLin2, "") + iif(ADups[3, 1] != "","  |  " + cDpLin3, "" )
							@ li, 00  PSAY cLinImp
						EndIf
												
						// primeira linha de duplicatas
						if (aDups[4, 1] != "")
							li++
							cDpLIn1 := ADups[4, 1] + "    " + ADups[4, 2] + " " + ADups[4, 3]
							cDpLIn2 := ADups[5, 1] + "    " + ADups[5, 2] + " " + ADups[5, 3]
							cDpLIn3 := ADups[6, 1] + "    " + ADups[6, 2] + " " + ADups[6, 3]
							cLinImp = cDpLin1 + iif(ADups[5, 1] != "","  |  " + cDpLin2, "") + iif(ADups[6, 1] != "","  |  " + cDpLin3, "" )
							@ li, 00  PSAY cLinImp							
						EndIf
						
					EndIf
					
					li++
	  	    @li,000 PSAY __PrtThinLine()

				ElseIf mv_par05 == 2
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime a linha da nota fiscal                               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					@li,000 PSAY cDocF1
					@li,013+nIncCol PSAY cSerieF1
					@li,017+nIncCol PSAY Iif(nOrdem == 3,dDtDigitF1,dEmissaoF1)
					@li,028+nIncCol PSAY cFornF1
					
					If cTipoF1 $ "BD"
						If !lQuery
							(cAliasSA1)->(dbSeek( xFilial("SA1") + (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA ))
							@li,nPosNome+nIncCol PSAY SubStr((cAliasSA1)->A1_NOME,1,nTamNome)
							@li,066+nIncCol PSAY SubStr((cAliasSA1)->A1_MUN,1,15)
						Else
							@li,nPosNome+nIncCol PSAY SubStr(cForCli,1,nTamNome)
							@li,066+nIncCol PSAY SubStr(cMuni,1,15)
						Endif
					Else
						If !lQuery
							(cAliasSA2)->(dbSeek( xFilial("SA2") + (cAliasSF1)->F1_FORNECE + (cAliasSF1)->F1_LOJA))
							@li,nPosNome+nIncCol PSAY SubStr((cAliasSA2)->A2_NOME,1,nTamNome)
							@li,066+nIncCol PSAY SubStr((cAliasSA2)->A2_MUN,1,15)
						Else
							@li,nPosNome+nIncCol PSAY SubStr(cForCli,1,nTamNome)
							@li,066+nIncCol PSAY SubStr(cMuni,1,15)
						Endif
					EndIf
					@li,082+nIncCol PSAY cCondF1 Picture "!!!"
					If ( cPaisLoc == "BRA" )
						@li,086 PSAY nValIcm    Picture tm((cAliasSF1)->F1_VALICM ,14)
						@li,101 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI ,14)
						If mv_par20 == 2
							@li,115 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
						else
					   	@li,115 PSAY xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_VALMERC",17,mv_par18)
					 	endif
						nTgerIcm += nValIcm
						nTgerIpi += nValIpi
					Else
						@li,93+nIncCol PSAY nImpInc+nImpNoInc  Picture pesqpict("SF1","F1_VALIMP1",14,mv_par18)
						If mv_par20 == 2 // total listado
							@li,115+nIncCol PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
						else
							@li,115+nIncCol PSAY xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa) Picture pesqpict("SF1","F1_VALMERC",17,mv_par18)
						endif
						nTgImpInc   += nImpInc
						nTgImpNoInc += nImpNoInc

					EndIf
					li++
					
					If mv_par20 == 2
						nTotGeral:= nTotGeral + nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
						nTotData := nTotData + nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
						nTotForn := nTotForn + nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
					Else
						nTotGeral:= nTotGeral + xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
						nTotData := nTotData + xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
						nTotForn := nTotForn + xmoeda(nValTotF1,nMoeda,mv_par18,dDtDig,nDecs+1,nTaxa)
					EndIf
                    
                    If nOrdem == 5
						If cFornAnt != (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA 
							lDescLine := .T.
							li++
							@li,000  PSAY STR0065	// "TOTAL DO FORNECEDOR :"
							@li,115+nIncCol  PSAY  nTotForn  Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
							li++
						    @li,000 PSAY __PrtThinLine()
							li++
							nTotForn := 0
						Endif				
                    Else                                                      
						If (dDataAnt != (cAliasSD1)->D1_DTDIGIT) .And. nOrdem == 3 .Or. (dDataAnt != (cAliasSD1)->D1_EMISSAO) .And. nOrdem == 4 
							lDescLine := .T.
							li++
							@li,000  PSAY STR0046		//"TOTAL NA DATA : "
							@li,115+nIncCol  PSAY  nTotData  Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
							li++
			    			@li,000 PSAY __PrtThinLine()
							li++
					        nTotData := 0
						Endif	
                    EndIf
					
				Endif
				
			Endif
			
			cDocAnt := (cAliasSD1)->D1_FILIAL + (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA
			
			nValIpi     := 0
			nValMerc    := 0
			nValDesc    := 0
			nTotDesp    := 0
			nTotFrete   := 0
			nTotSeguro  := 0
			nValIcm     := 0
			nValImpInc	:= 0
			nValImpNoInc:= 0
			nImpInc		:= 0
			nImpNoInc	:= 0
			If nOrdem <> 3 .Or. nOrdem <> 4 .Or. nOrdem <> 5
				lDescLine  := .T.
			Endif
		Endif

	Elseif nOrdem == 2
		
		If cCodant != (cAliasSD1)->D1_COD .And. lPrintLine
			lDescLine := .T.
			li++
			@li,000  PSAY  STR0041		//"TOTAL DO PRODUTO : "
			@li,085+nIncCol  PSAY  nTotQuant Picture pesqpict("SD1","D1_TOTAL",16)
			@li,115+nIncCol  PSAY  nTotProd  Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
			li++

			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051)	        //"TOTAL ICMS:"
			If ( cPaisLoc == "BRA" )
				@li,040 PSAY nValIcm    Picture tm((cAliasSF1)->F1_VALICM ,15)
				@li,057 PSAY STR0016			                            //"TOTAL IPI :"
				@li,068 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI ,15)
				@li,084 PSAY STR0066 //"TOTAL C/IMP.:"
				@li,097 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgerIcm += nValIcm
				nTgerIpi += nValIpi
			Else
				@li,040 PSAY nImpNoInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,057 PSAY STR0056			                            //"TOTAL INI :" "TOT. I.INC.:"
				@li,069 PSAY nImpInc   Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,085 PSAY STR0025         								// TOTAL :
				@li,093 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgImpInc   += nImpInc
				nTgImpNoInc += nImpNoInc
			EndIf
			nTotGerImp += nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
			li++

		 	@li,000 PSAY __PrtThinLine()
			li++
			nTotQger   += nTotQuant
			nTotGeral  += nTotProd
			nValIpi     := 0
			nValMerc    := 0
			nValDesc    := 0
			nTotDesp    := 0
			nTotFrete   := 0
			nTotSeguro  := 0
			nValIcm     := 0
			nValImpInc	:= 0
			nValImpNoInc:= 0
			nImpInc		:= 0
			nImpNoInc	:= 0
	        lPrintLine := .F.
		Endif
		
	Elseif nOrdem == 3 .Or. nOrdem == 4 
		
		If dDataAnt != Iif(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO) .And. lPrintLine // nTotData > 0 
			lDescLine := .T.
			li++
			@li,000  PSAY STR0046		//"TOTAL NA DATA : "
			@li,115+nIncCol  PSAY  nTotData  Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
			li++

			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051)	        //"TOTAL ICMS:"
			If ( cPaisLoc == "BRA" )
				@li,040 PSAY nValIcm    Picture tm((cAliasSF1)->F1_VALICM ,15)
				@li,057 PSAY STR0016			                            //"TOTAL IPI :"
				@li,068 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI ,15)
				@li,084 PSAY STR0066 //"TOTAL C/IMP.:"
				@li,097 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgerIcm += nValIcm
				nTgerIpi += nValIpi
			Else
				@li,040 PSAY nImpNoInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,057 PSAY STR0056			                            //"TOTAL INI :"
				@li,069 PSAY nImpInc   Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,085 PSAY STR0025         								// TOTAL
				@li,093 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgImpInc   += nImpInc
				nTgImpNoInc += nImpNoInc
			EndIf
			nTotGerImp += nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
			li++

		    @li,000 PSAY __PrtThinLine()
			li++
			nTotGeral += nTotData
			dDataAnt := Iif(nOrdem == 3,(cAliasSD1)->D1_DTDIGIT,(cAliasSD1)->D1_EMISSAO)
			nTotData := 0
			nValIpi     := 0
			nValMerc    := 0
			nValDesc    := 0
			nTotDesp    := 0
			nTotFrete   := 0
			nTotSeguro  := 0
			nValIcm     := 0
			nValImpInc	:= 0
			nValImpNoInc:= 0
			nImpInc		:= 0
			nImpNoInc	:= 0
            lPrintLine := .F.
		Endif

	Elseif nOrdem == 5 
		
		If cFornAnt != (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA .And. lPrintLine // nTotForn > 0 
			lDescLine := .T.
			li++
			@li,000  PSAY STR0065	// "TOTAL DO FORNECEDOR :"
			@li,115+nIncCol  PSAY  nTotForn  Picture pesqpict("SD1","D1_TOTAL",17,mv_par18)
			li++

			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051)	        //"TOTAL ICMS:"
			If ( cPaisLoc == "BRA" )
				@li,040 PSAY nValIcm    Picture tm((cAliasSF1)->F1_VALICM ,15)
				@li,057 PSAY STR0016			                            //"TOTAL IPI :"
				@li,068 PSAY nValIpi    Picture tm((cAliasSF1)->F1_VALIPI ,15)
				@li,084 PSAY STR0066 //"TOTAL C/IMP.:"
				@li,097 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgerIcm += nValIcm
				nTgerIpi += nValIpi
			Else
				@li,040 PSAY nImpNoInc+nImpNoInc Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,057 PSAY STR0056			                            //"TOTAL INI :" "TOT. I.INC.:"
				@li,069 PSAY nImpInc   Picture pesqpict("SF1","F1_VALIMP1",15,mv_par18)
				@li,085 PSAY STR0025         								// TOTAL :
				@li,093 PSAY (nValMerc + nTotDesp + nTotFrete + nTotSeguro) Picture tm((cAliasSF1)->F1_VALMERC,17)
				nTgImpInc   += nImpInc
				nTgImpNoInc += nImpNoInc
			EndIf
			nTotGerImp += nValMerc + xmoeda( nTotDesp + nTotFrete + nTotSeguro ,nMoeda,mv_par18,dDtDigitF1,nDecs+1,nTxMoedaF1)
			li++

		    @li,000 PSAY __PrtThinLine()
			li++
			nTotGeral += nTotForn
			cFornAnt := (cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA
			nTotForn := 0
			nValIpi     := 0
			nValMerc    := 0
			nValDesc    := 0
			nTotDesp    := 0
			nTotFrete   := 0
			nTotSeguro  := 0
			nValIcm     := 0
			nValImpInc	:= 0
			nValImpNoInc:= 0
			nImpInc		:= 0
			nImpNoInc	:= 0
	  		lPrintLine := .F.
		Endif
		
	Endif
	
	If !lquery
		(cAliasSF1)->(dbseek( xFilial("SF1") + (cAliasSD1)->D1_DOC + (cAliasSD1)->D1_SERIE + (cAliasSD1)->D1_FORNECE + (cAliasSD1)->D1_LOJA)) //posiciona o cabecalho da nota
	Endif
	
	nTaxa  := (cAliasSF1)->F1_TXMOEDA
	nMoeda := (cAliasSF1)->F1_MOEDA
	dDtDig := (cAliasSF1)->F1_DTDIGIT
	
EndDo

If lImp
	li++
	
	If li > 56
		cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	Endif
	
	@li,000  PSAY STR0042	                                                 //"T O T A L  G E R A L : "
	
	If nOrdem == 1 .And. MV_PAR05 == 1
		If (nTgerIcm + nTgerIpi + nTotGeral + nTgImpInc + nTgImpNoInc) > 0
			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0022,STR0052)	        //"ICMS :"
			If ( cPaisLoc=="BRA" )
				@li,036 PSAY nTgerIcm		Picture tm(nTGerIcm,15)
				@li,052 PSAY STR0023			                            //"IPI :"
				@li,063 PSAY nTgerIpi		Picture tm(nTGerIpi,15)				
			Else
				@li,036 PSAY nTgImpNoInc Picture tm(nTGImpNoInc,15,nDecs)
				@li,052 PSAY STR0057			                            //"IPI :"
				@li,063 PSAY nTgImpInc Picture tm(nTGImpInc,15,nDecs)				
			EndIf
			@li,080 PSAY STR0024			                               //"DESC.:"
			@li,088 PSAY nTotDesco Picture tm(nTotDesco,13,nDecs)
			@li,105 PSAY STR0025			                               //"TOTAL :"
		Endif
		nIncCol := 0
		li++
	@li, 00 PSAY "Total de Documentos: " + AllTrim(Str(nNumDocs))			
	ElseIf (nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 5) .And. MV_PAR05 == 2
		If (cPaisLoc == "BRA")
			@li,086 PSAY nTgerIcm  Picture tm(nTGerIcm,14)
			@li,101 PSAY nTgerIpi  Picture tm(nTGerIpi,14)
		Else
			@li,93+nIncCol PSAY nTgImpInc+nTgImpNoInc  Picture tm(nTGImpInc,14,nDecs)
		Endif
	ElseIf nOrdem == 2
		@li,087+nIncCol  PSAY  nTotQger  Picture pesqpict("SD1","D1_QUANT",14)
	Endif
	
	@li,115+nIncCol PSAY nTotGeral Picture tm(nTotGeral,17,nDecs)

	If nOrdem == 2 .Or. ( (nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem ==5) .And. MV_PAR05 == 1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Linha de total adicional p/ a quebra, com totais de Impostos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If (nTgerIcm + nTgerIpi + nTotGerImp + nTgImpInc + nTgImpNoInc) > 0
			li++
			@li,027 PSAY IIF(cPaisLoc == "BRA",STR0015,STR0051)	        //"TOTAL ICMS:"
			If ( cPaisLoc=="BRA" )
				@li,040 PSAY nTgerIcm		Picture tm(nTGerIcm,15)
				@li,057 PSAY STR0016			                            //"TOTAL IPI :"
				@li,068 PSAY nTgerIpi		Picture tm(nTGerIpi,15)				
				@li,084 PSAY STR0066 //"TOTAL C/IMP.:"
				@li,097 PSAY nTotGerImp Picture tm(nTotGerImp,17,nDecs)
			Else
				@li,040 PSAY nTgImpNoInc Picture tm(nTGImpNoInc,15,nDecs)
				@li,057 PSAY STR0056			                            //"TOTAL INI :""TOT. I.INC.:"
				@li,069 PSAY nTgImpInc Picture tm(nTGImpInc,15,nDecs)				        
				@li,085 PSAY STR0025         								// TOTAL
				@li,093 PSAY nTotGerImp Picture tm(nTotGerImp,17,nDecs)
			EndIf
		Endif
  EndIf
	
	//Guilherme 
	If li > 56
		cabec(Titulo,cabec1,cabec2,nomeprog,Tamanho,nTipo)
	Endif
	
	li++
	@li,000 PSAY 'Total de Notas - '+Alltrim(MV_PAR23)+' : '
	@li,030 PSAY nTotuser Picture "@E 99,999"
 // Guilherme
		
	roda(cbcont,cbtext,Tamanho)
Endif

#IFDEF TOP
	dbSelectArea(cAliasSD1)
	dbCloseArea()
#ENDIF

dbSelectArea("SD1")
dbClearFilter()
dbSetOrder(1)

RetIndex("SD1")
If File(cIndex+OrdBagExt())
	Ferase(cIndex+OrdBagExt())
Endif

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif
MS_FLUSH()
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSX1    ³Autor ³ Aline Correa do Vale ³Data³23/11/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta perguntas do SX1                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATR080                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}  

cPerg := "MTR080"
cPerg := PADR(cPerg,len(SX1->X1_GRUPO))

Aadd( aHelpPor, "Selecione de onde buscar a descricao dos" )
Aadd( aHelpPor, "produtos na nota fiscal de entrada, os  " )
Aadd( aHelpPor, "campos permitidos sao B1_DESC cadastro  " )
Aadd( aHelpPor, "de produtos, B5_CEME descricao cientific" )
Aadd( aHelpPor, "a do produto e C7_DESCRI descricao no Pe" )
Aadd( aHelpPor, "dido de compras, se o parametro estiver " )
Aadd( aHelpPor, "em branco a descricao usada sera B1_DESC" )

Aadd( aHelpEng, "Select the source product description.  " )
Aadd( aHelpEng, "The allowed fields are B1_DESC (products" )
Aadd( aHelpEng, " file), B5_CEME (product's scientific   " )
Aadd( aHelpEng, "description), C7_DESCRI (purchase order " )
Aadd( aHelpEng, "description). If the parameter is empty," )
Aadd( aHelpEng, "the description will be extracted from  " )
Aadd( aHelpEng, "B1_DESC.                                " )

Aadd( aHelpSpa, "Elija de donde buscar la descripcion de " )
Aadd( aHelpSpa, "los productos, los campos permitidos son" )
Aadd( aHelpSpa, "B1_DESC archivo de productos, B5_CEME   " )
Aadd( aHelpSpa, "descripcion cientifica del producto y   " )
Aadd( aHelpSpa, "C7_DESCRI descripcion en el pedido de   " )
Aadd( aHelpSpa, "compras,cuando el parametro este en blan" )
Aadd( aHelpSpa, "co, la descripcion usada sera la B1_DESC" )

PutSx1(cPerg,"21","Descricao do produto ","Descripcion Prodc.","Product Description  ","mv_chl","C",10,0,0,"G","","","","","mv_par21","","","","B1_DESC " ," "," "," "," "," "," "," "," "," ","","","")

PutSX1Help("P.MTR08021.",aHelpPor,aHelpEng,aHelpSpa)	 

/*-----------------------MV_PAR22--------------------------*/
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Listar apenas Notas Fiscais com TES     " )
Aadd( aHelpPor, "Sim ou Nao                              " )

Aadd( aHelpEng, "Only list Invoices with TES             " )
Aadd( aHelpEng, "Yes or No                               " )

Aadd( aHelpSpa, "Listar solo Facturas con TES            " ) 
Aadd( aHelpSpa, "Si o No                                 " )  

PutSx1(cPerg,"22","Somente NF com TES ?","Solo Fact.con TES ?","Only Inv with TES ?","mv_chm",;
"N",1,0,0,"C","","","","","mv_par22","Nao","No","No","","Sim","Si","Yes","","","","","","","","","",;
aHelpPor,aHelpEng,aHelpSpa)

PutSx1(cPerg,"23","Nome do Usuario","Nome do Usuario","Nome do Usuario ?","mv_chn",;
"C",20,0,0,"G","","","","","mv_par23","","","","","","","","","","","","","","","","")

Return Nil