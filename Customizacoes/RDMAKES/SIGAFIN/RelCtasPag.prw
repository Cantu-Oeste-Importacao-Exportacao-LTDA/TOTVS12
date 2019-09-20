#INCLUDE "SGFIN19.CH"
#Include "PROTHEUS.Ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FINR150	³ Autor ³ Wagner Xavier   	     ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR150(void)															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parƒmetros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SgFin19()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Vari veis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Imprime a posi‡„o dos titulos a pagar relativo a data base"
Local cDesc2 :=OemToAnsi(STR0002)  //"do sistema."
LOCAL cDesc3 :=""
LOCAL wnrel
LOCAL cString:="SE2"
LOCAL nRegEmp := SM0->(RecNo())
Local dOldDtBase := dDataBase
Local dOldData := dDataBase

PRIVATE aReturn := { OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE nomeprog:="FINR150"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg	 :="FIN150"
PRIVATE nJuros  :=0
PRIVATE tamanho:="G"

PRIVATE titulo  := ""
PRIVATE cabec1
PRIVATE cabec2
Private _dPerIni
Private _dPerFin

Private _aResumo := {}
Private _aRMes	 := {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabe‡alhos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := OemToAnsi(STR0005)  //"Posicao dos Titulos a Pagar"
cabec1 := OemToAnsi(STR0006)  //"Codigo Nome do Fornecedor   PRF-Numero         Tp  Natureza    Data de  Vencto   Vencto  Banco  Valor Original |        Titulos vencidos          | Titulos a vencer | Porta-|  Vlr.juros ou   Dias   Historico     "
cabec2 := OemToAnsi(STR0007)  //"                            Parcela                            Emissao  Titulo    Real                         |  Valor nominal   Valor corrigido |   Valor nominal  | dor   |   permanencia   Atraso               "

//Nao retire esta chamada. Verifique antes !!!
//Ela é necessaria para o correto funcionamento da pergunte 36 (Data Base)
PutDtBase()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()
AjustMoeda("FIN150","15")
pergunte  ("FIN150",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros ³
//³ mv_par01	  // do Numero 			  ³
//³ mv_par02	  // at‚ o Numero 		  ³
//³ mv_par03	  // do Prefixo			  ³
//³ mv_par04	  // at‚ o Prefixo		  ³
//³ mv_par05	  // da Natureza  	     ³
//³ mv_par06	  // at‚ a Natureza		  ³
//³ mv_par07	  // do Vencimento		  ³
//³ mv_par08	  // at‚ o Vencimento	  ³
//³ mv_par09	  // do Banco			     ³
//³ mv_par10	  // at‚ o Banco		     ³
//³ mv_par11	  // do Fornecedor		  ³
//³ mv_par12	  // at‚ o Fornecedor	  ³
//³ mv_par13	  // Da Emiss„o			  ³
//³ mv_par14	  // Ate a Emiss„o		  ³
//³ mv_par15	  // qual Moeda			  ³
//³ mv_par16	  // Imprime Provis¢rios  ³
//³ mv_par17	  // Reajuste pelo vencto ³
//³ mv_par18	  // Da data contabil	  ³
//³ mv_par19	  // Ate data contabil	  ³
//³ mv_par20	  // Imprime Rel anal/sint³
//³ mv_par21	  // Considera  Data Base?³
//³ mv_par22	  // Cons filiais abaixo ?³
//³ mv_par23	  // Filial de            ³
//³ mv_par24	  // Filial ate           ³
//³ mv_par25	  // Loja de              ³
//³ mv_par26	  // Loja ate             ³
//³ mv_par27 	  // Considera Adiantam.? ³
//³ mv_par28	  // Imprime Nome 		  ³
//³ mv_par29	  // Outras Moedas 		  ³
//³ mv_par30     // Imprimir os Tipos    ³
//³ mv_par31     // Nao Imprimir Tipos	  ³
//³ mv_par32     // Consid. Fluxo Caixa  ³
//³ mv_par33     // DataBase             ³
//³ mv_par34     // Tipo de Data p/Saldo ³
//³ mv_par35     // Tit. Emissao Futura  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

#IFDEF TOP
	IF TcSrvType() == "AS/400" .and. Select("__SE2") == 0
		ChkFile("SE2",.f.,"__SE2")
	Endif
#ENDIF

wnrel := "FINR150"            //Nome Default do relatorio em Disco
aOrd	:= {OemToAnsi(STR0008),OemToAnsi(STR0009),OemToAnsi(STR0010) ,;  //"Por Numero"###"Por Natureza"###"Por Vencimento"
	OemToAnsi(STR0011),OemToAnsi(STR0012),OemToAnsi(STR0013),OemToAnsi(STR0014) }  //"Por Banco"###"Fornecedor"###"Por Emissao"###"Por Cod.Fornec."
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa150Imp(@lEnd,wnRel,cString)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura empresa / filial original    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SM0->(dbGoto(nRegEmp))
cFilAnt := SM0->M0_CODFIL

//Acerta a database de acordo com a database real do sistema
If mv_par21 == 1    // Considera Data Base
	dDataBase := dOldDtBase
Endif	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ FA150Imp ³ Autor ³ Wagner Xavier 		  ³ Data ³ 02.10.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Posi‡„o dos Titulos a Pagar										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA150Imp(lEnd,wnRel,cString)										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd	  - A‡Æo do Codeblock										  ³±±
±±³			 ³ wnRel   - T¡tulo do relat¢rio 									  ³±±
±±³			 ³ cString - Mensagem										 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Gen‚rico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FA150Imp(lEnd,wnRel,cString)

LOCAL CbCont
LOCAL CbTxt

LOCAL limite := 220
LOCAL nOrdem :=0
LOCAL nQualIndice := 0
LOCAL lContinua := .T.
LOCAL nTit0:=0,nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0
LOCAL nTot0:=0,nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTotTit:=0,nTotJ:=0,nTotJur:=0
LOCAL nFil0:=0,nFil1:=0,nFil2:=0,nFil3:=0,nFil4:=0,nFilTit:=0,nFilJ:=0,nFilJur:=0
LOCAL cCond1,cCond2,cCarAnt,nSaldo:=0,nAtraso:=0,nSaldoNom:=0
LOCAL aCampos:={},aTam:={}
LOCAL dDataReaj
LOCAL dDataAnt := dDataBase , lQuebra
LOCAL nMestit0:= nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
LOCAL dDtContab
LOCAL	cIndexSe2
LOCAL	cChaveSe2
LOCAL	nIndexSE2
LOCAL cFilDe,cFilAte
Local aStru := SE2->(dbStruct()), ni
Local nTotsRec := SE2->(RecCount())
Local aTamFor := TAMSX3("E2_FORNECE")
Local nDecs := Msdecimais(mv_par15)
Local lFr150Flt := EXISTBLOCK("FR150FLT")
Local cFr150Flt
Local aNat	:= {} // Customização 

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE dBaixa := dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ponto de entrada para Filtrar 										  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Localiza‡”es ArgentinaÄÙ
If lFr150Flt
	cFr150Flt := EXECBLOCK("Fr150FLT",.f.,.f.)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impress„o do Cabe‡alho e Rodap‚ ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt  := OemToAnsi(STR0015)  //"* indica titulo provisorio, P indica Saldo Parcial"
cbcont := 0
li 	 := 80
m_pag  := 1

nOrdem := aReturn[8]
cMoeda := LTrim(Str(mv_par15))
Titulo += OemToAnsi(STR0035)+GetMv("MV_MOEDA"+cMoeda)  //" em "

dbSelectArea ( "SE2" )
Set Softseek On

If mv_par22 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par23
	cFilAte:= mv_par24
Endif

//Acerta a database de acordo com o parametro
If mv_par21 == 1    // Considera Data Base
	dDataBase := mv_par33
Endif	

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !Eof() .and. M0_CODIGO == cEmpAnt .and. M0_CODFIL <= cFilAte

	dbSelectArea("SE2")
	cFilAnt := SM0->M0_CODFIL

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery := "SELECT * "
			cQuery += "  FROM "+	RetSqlName("SE2")
			cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
			cQuery += "   AND D_E_L_E_T_ <> '*' "
		endif
	#ENDIF

	IF nOrdem == 1
		SE2->(dbSetOrder(1))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par03+mv_par01,.T.)
		#ENDIF
		cCond1 := "E2_PREFIXO <= mv_par04"
		cCond2 := "E2_PREFIXO"
		titulo += OemToAnsi(STR0016)  //" - Por Numero"
		nQualIndice := 1
	Elseif nOrdem == 2
		SE2->(dbSetOrder(2))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par05,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par05,.T.)
		#ENDIF
		cCond1 := "E2_NATUREZ <= mv_par06"
		cCond2 := "E2_NATUREZ"
		titulo += OemToAnsi(STR0017)  //" - Por Natureza"
		nQualIndice := 2
	Elseif nOrdem == 3
		SE2->(dbSetOrder(3))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+Dtos(mv_par07),.T.)
		#ENDIF
		cCond1 := "E2_VENCREA <= mv_par08"
		cCond2 := "E2_VENCREA"
		titulo += OemToAnsi(STR0018)  //" - Por Vencimento"
		nQualIndice := 3
	Elseif nOrdem == 4
		SE2->(dbSetOrder(4))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par09,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par09,.T.)
		#ENDIF
		cCond1 := "E2_PORTADO <= mv_par10"
		cCond2 := "E2_PORTADO"
		titulo += OemToAnsi(STR0031)  //" - Por Banco"
		nQualIndice := 4
	Elseif nOrdem == 6
		SE2->(dbSetOrder(5))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+DTOS(mv_par13),.T.)
		#ENDIF
		cCond1 := "E2_EMISSAO <= mv_par14"
		cCond2 := "E2_EMISSAO"
		titulo += OemToAnsi(STR0019)  //" - Por Emissao"
		nQualIndice := 5
	Elseif nOrdem == 7
		SE2->(dbSetOrder(6))
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				dbSeek(xFilial("SE2")+mv_par11,.T.)
			else
				cOrder := SqlOrder(indexkey())
			endif
		#ELSE
			dbSeek(xFilial("SE2")+mv_par11,.T.)
		#ENDIF			
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE"
		titulo += OemToAnsi(STR0020)  //" - Por Cod.Fornecedor"
		nQualIndice := 6
	Else
		cChaveSe2 := "E2_FILIAL+E2_NOMFOR+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO"
		#IFDEF TOP
			if TcSrvType() == "AS/400"
				cIndexSe2 := CriaTrab(nil,.f.)
				IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
				nIndexSE2 := RetIndex("SE2")
				dbSetOrder(nIndexSe2+1)
				dbSeek(xFilial("SE2"))
			else
				cOrder := SqlOrder(cChaveSe2)
			endif
		#ELSE
			cIndexSe2 := CriaTrab(nil,.f.)
			IndRegua("SE2",cIndexSe2,cChaveSe2,,Fr150IndR(),OemToAnsi(STR0021))  // //"Selecionando Registros..."
			nIndexSE2 := RetIndex("SE2")
			dbSetIndex(cIndexSe2+OrdBagExt())
			dbSetOrder(nIndexSe2+1)
			dbSeek(xFilial("SE2"))
		#ENDIF
		cCond1 := "E2_FORNECE <= mv_par12"
		cCond2 := "E2_FORNECE+E2_LOJA"
		titulo += OemToAnsi(STR0022)  //" - Por Fornecedor"
		nQualIndice := IndexOrd()
	EndIF

	If mv_par20 == 1
		titulo += OemToAnsi(STR0023)  //" - Analitico"
	Else
		titulo += OemToAnsi(STR0024)  // " - Sintetico"
		cabec1 := OemToAnsi(STR0033)  // "                                                                                          |        Titulos vencidos         |    Titulos a vencer     |           Valor dos juros ou                       (Vencidos+Vencer)"
		cabec2 := OemToAnsi(STR0034)  // "                                                                                          | Valor nominal   Valor corrigido |      Valor nominal      |            com. permanencia                                         "
	EndIf

	dbSelectArea("SE2")
	cFilterUser:=aReturn[7]

	Set Softseek Off

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			cQuery += " AND E2_NUM     BETWEEN '"+ mv_par01+ "' AND '"+ mv_par02 + "'"
			cQuery += " AND E2_PREFIXO BETWEEN '"+ mv_par03+ "' AND '"+ mv_par04 + "'"
			cQuery += " AND (E2_MULTNAT = '1' OR (E2_NATUREZ BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"'))"
			cQuery += " AND E2_VENCREA BETWEEN '"+ DTOS(mv_par07)+ "' AND '"+ DTOS(mv_par08) + "'"
			cQuery += " AND E2_PORTADO BETWEEN '"+ mv_par09+ "' AND '"+ mv_par10 + "'"
			cQuery += " AND E2_FORNECE BETWEEN '"+ mv_par11+ "' AND '"+ mv_par12 + "'"
			cQuery += " AND E2_EMISSAO BETWEEN '"+ DTOS(mv_par13)+ "' AND '"+ DTOS(mv_par14) + "'"
			cQuery += " AND E2_LOJA    BETWEEN '"+ mv_par25 + "' AND '"+ mv_par26 + "'"

		//Considerar titulos cuja emissao seja maior que a database do sistema
		If mv_par35 == 2
			cQuery += " AND E2_EMISSAO <= '" + DTOS(dDataBase) +"'"
		Endif

			If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
				cQuery += " AND E2_TIPO IN "+FormatIn(mv_par30,";") 
			ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
				cQuery += " AND E2_TIPO NOT IN "+FormatIn(mv_par31,";")
			EndIf
			If mv_par32 == 1
				cQuery += " AND E2_FLUXO <> 'N'"
			Endif
			cQuery += " ORDER BY "+ cOrder

			cQuery := ChangeQuery(cQuery)

			dbSelectArea("SE2")
			dbCloseArea()
			dbSelectArea("SA2")

			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE2', .F., .T.)

			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C'
					TCSetField('SE2', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		endif
	#ENDIF

	SetRegua(nTotsRec)
	
	If MV_MULNATP .And. nOrdem == 2
		Finr155(cFr150Flt, lEnd, @nTot0, @nTot1, @nTot2, @nTot3, @nTotTit, @nTotJ )
		#IFDEF TOP
			if TcSrvType() != "AS/400"
				dbSelectArea("SE2")
				dbCloseArea()
				ChKFile("SE2")
				dbSetOrder(1)
			endif
		#ENDIF
		If Empty(xFilial("SE2"))
			Exit
		Endif
		dbSelectArea("SM0")
		dbSkip()
		Loop
	Endif

	While &cCond1 .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

		IF lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
			Exit
		End

		IncRegua()

		dbSelectArea("SE2")

		Store 0 To nTit1,nTit2,nTit3,nTit4,nTit5

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Carrega data do registro para permitir ³
		//³ posterior analise de quebra por mes.	 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

		cCarAnt := &cCond2

		While &cCond2 == cCarAnt .and. !Eof() .and. lContinua .and. E2_FILIAL == xFilial("SE2")

			IF lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0025)  //"CANCELADO PELO OPERADOR"
				Exit
			End

			IncRegua()

			dbSelectArea("SE2")

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSkip()
				Loop
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario no ponto de entrada.             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lFr150flt
				If &cFr150flt
					DbSkip()
					Loop
				Endif
			Endif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se trata-se de abatimento ou provisorio, ou ³
			//³ Somente titulos emitidos ate a data base				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE2->E2_TIPO $ MVABATIM .Or. (SE2 -> E2_EMISSAO > dDataBase .and. mv_par35 == 2)
				dbSkip()
				Loop
			EndIF
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos provis¢rios		   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E2_TIPO $ MVPROVIS .and. mv_par16 == 2
				dbSkip()
				Loop
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se ser  impresso titulos de Adiantamento	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG .and. mv_par27 == 2
				dbSkip()
				Loop
			EndIF

			// dDtContab para casos em que o campo E2_EMIS1 esteja vazio
			// compatibilizando com a vers„o 2.04 que n„o gerava para titulos
			// de ISS e FunRural

			dDtContab := Iif(Empty(SE2->E2_EMIS1),SE2->E2_EMISSAO,SE2->E2_EMIS1)

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se esta dentro dos parametros ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IF E2_NUM < mv_par01      .OR. E2_NUM > mv_par02 .OR. ;
					E2_PREFIXO < mv_par03  .OR. E2_PREFIXO > mv_par04 .OR. ;
					E2_NATUREZ < mv_par05  .OR. E2_NATUREZ > mv_par06 .OR. ;
					E2_VENCREA < mv_par07  .OR. E2_VENCREA > mv_par08 .OR. ;
					E2_PORTADO < mv_par09  .OR. E2_PORTADO > mv_par10 .OR. ;
					E2_FORNECE < mv_par11  .OR. E2_FORNECE > mv_par12 .OR. ;
					E2_EMISSAO < mv_par13  .OR. E2_EMISSAO > mv_par14 .OR. ;
					(E2_EMISSAO > dDataBase .and. mv_par35 == 2) .OR. dDtContab  < mv_par18 .OR. ;
					E2_LOJA    < mv_par25  .OR. E2_LOJA    > mv_par26 .OR. ;
					dDtContab  > mv_par19  .Or. !&(fr150IndR())

				dbSkip()
				Loop
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se titulo, apesar do E2_SALDO = 0, deve aparecer ou ³
			//³ nÆo no relat¢rio quando se considera database (mv_par21 = 1) ³
			//³ ou caso nÆo se considere a database, se o titulo foi totalmen³
			//³ te baixado.																  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SE2")
			IF !Empty(SE2->E2_BAIXA) .and. Iif(mv_par21 == 2 ,SE2->E2_SALDO == 0 ,;
					(SE2->E2_SALDO == 0 .and. SE2->E2_BAIXA <= dDataBase))
				dbSkip()
				Loop
			EndIF

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se deve imprimir outras moedas³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If mv_par29 == 2 // nao imprime
				if SE2->E2_MOEDA != mv_par15 //verifica moeda do campo=moeda parametro
					dbSkip()
					Loop
				endif	
			Endif

			dbSelectArea("SA2")
			MSSeek(xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA)
			dbSelectArea("SE2")

			// Verifica se existe a taxa na data do vencimento do titulo, se nao existir, utiliza a taxa da database
			If SE2->E2_VENCREA < dDataBase
				If mv_par17 == 2 .And. RecMoeda(SE2->E2_VENCREA,cMoeda) > 0
					dDataReaj := SE2->E2_VENCREA
				Else
					dDataReaj := dDataBase
				EndIf	
			Else
				dDataReaj := dDataBase
			EndIf

			If mv_par21 == 1
				nSaldo := SaldoTit(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_NATUREZ,"P",SE2->E2_FORNECE,mv_par15,dDataReaj,,SE2->E2_LOJA,,If(mv_par34==1,SE2->E2_TXMOEDA,Nil))
				// Subtrai decrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_DECRESC > 0 .And. SE2->E2_SDDECRE == 0
					nSAldo -= SE2->E2_DECRESC
				Endif
				// Soma Acrescimo para recompor o saldo na data escolhida.
				If Str(SE2->E2_VALOR,17,2) == Str(nSaldo,17,2) .And. SE2->E2_ACRESC > 0 .And. SE2->E2_SDACRES == 0
					nSAldo += SE2->E2_ACRESC
				Endif
			Else
				nSaldo := xMoeda((SE2->E2_SALDO+SE2->E2_SDACRES-SE2->E2_SDDECRE),SE2->E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
			Endif
			If ! (SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG) .And. ;
			   ! ( MV_PAR21 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo

				//Quando considerar Titulos com emissao futura, eh necessario
				//colocar-se a database para o futuro de forma que a Somaabat()
				//considere os titulos de abatimento
				If mv_par34 == 1
					dOldData := dDataBase
					dDataBase := CTOD("31/12/40")
				Endif

				nSaldo-=SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,"P",mv_par15,dDataReaj,SE2->E2_FORNECE,SE2->E2_LOJA)

				If mv_par34 == 1
					dDataBase := dOldData
				Endif
			EndIf

			nSaldo:=Round(NoRound(nSaldo,3),2)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconsidera caso saldo seja menor ou igual a zero   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nSaldo <= 0
				dbSkip()
				Loop
			Endif

			IF li > 58
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF

			If mv_par20 == 1
				@li,	0 PSAY SE2->E2_FORNECE+"-"+SE2->E2_LOJA+"-"+SubStr( SE2->E2_NOMFOR, 1, 15 )
				li := IIf (aTamFor[1] > 6,li+1,li)
				@li, 26 PSAY SE2->E2_PREFIXO+"-"+SE2->E2_NUM+"-"+SE2->E2_PARCELA
				@li, 47 PSAY SE2->E2_TIPO
				@li, 51 PSAY SE2->E2_NATUREZ // Adriano
				@li, 62 PSAY SE2->E2_EMISSAO
				@Li, 73 PSAY SE2->E2_VENCTO
				@li, 84 PSAY SE2->E2_VENCREA
				@li, 96 PSAY xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture PesqPict("SE2","E2_VALOR",14,MV_PAR15)
			EndIf
			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSetOrder( nQualIndice )
				Endif
			#ELSE
				dbSetOrder( nQualIndice )
			#ENDIF

			If dDataBase > SE2->E2_VENCREA 		//vencidos
				If mv_par20 == 1
					@ li, 112 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,14,nDecs)
				EndIf
				nJuros:=0
				dBaixa:=dDataBase
				fa080Juros(mv_par15)
				dbSelectArea("SE2")

				// Inicio Adriano 
				// 21/02/2008
				nPosicao  := ascan(aNat,{|_x| SE2->E2_NATUREZ == _x[1]})
				If nPosicao > 0
					aNat[nPosicao,2]	+= (xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1))
					aNat[nPosicao,3]	+= 0 
					aNat[nPosicao,4]	+= ((nSaldo+nJuros)*If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1))
				Else
					aAdd(aNat,{SE2->E2_NATUREZ,(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1));
					,0,((nSaldo+nJuros)*If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1))})
				EndIf
				// Fim 

				If mv_par20 == 1
					@li,129 PSAY (nSaldo+nJuros)*If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo+nJuros,14,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nTit1 -= nSaldo
					nTit2 -= nSaldo+nJuros
				    nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nMesTit1 -= nSaldo
					nMesTit2 -= nSaldo+nJuros
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nTit1 += nSaldo
					nTit2 += nSaldo+nJuros
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nMesTit1 += nSaldo
					nMesTit2 += nSaldo+nJuros
				Endif
				nTotJur += (nJuros)
				nMesTitJ += (nJuros)
			Else				  //a vencer

				// Inicio Adriano
				// 21/02/2008
				nPosicao  := ascan(aNat,{|_x| SE2->E2_NATUREZ == _x[1]})
				If nPosicao > 0
					aNat[nPosicao,2]	+= (xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1))
					aNat[nPosicao,3]	+= (nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)) 
					aNat[nPosicao,4]	+= 0
				Else
					aAdd(aNat,{SE2->E2_NATUREZ,(xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0) * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1));
					,(nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1)),0})
				EndIf
				// Fim 

				If mv_par20 == 1
					@li,147 PSAY nSaldo  * If(SE2->E2_TIPO$MV_CPNEG+"/"+MVPAGANT, -1,1) Picture TM(nSaldo,14,nDecs)
				EndIf
				If SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG
					nTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nTit3 -= nSaldo
					nTit4 -= nSaldo
				  	nMesTit0 -= xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nMesTit3 -= nSaldo
					nMesTit4 -= nSaldo
				Else
					nTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nTit3 += nSaldo
					nTit4 += nSaldo
					nMesTit0 += xMoeda(SE2->E2_VALOR,SE2->E2_MOEDA,mv_par15,SE2->E2_EMISSAO,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)
					nMesTit3 += nSaldo
					nMesTit4 += nSaldo
				Endif
			Endif
			If mv_par20 == 1
				@Li,165 PSAY SE2->E2_PORTADO
			EndIf
			If nJuros > 0
				If mv_par20 == 1
					@Li,173 PSAY nJuros Picture PesqPict("SE2","E2_JUROS",12,MV_PAR15)
				EndIf
				nJuros := 0
			Endif

			IF dDataBase > E2_VENCREA
				nAtraso:=dDataBase-E2_VENCTO
				IF Dow(E2_VENCTO) == 1 .Or. Dow(E2_VENCTO) == 7
					IF Dow(dBaixa) == 2 .and. nAtraso <= 2
						nAtraso:=0
					EndIF
				EndIF
				nAtraso:=IIF(nAtraso<0,0,nAtraso)
				IF nAtraso>0
					If mv_par20 == 1
						@li,189 PSAY nAtraso Picture "9999"
					EndIf
				EndIF
			EndIF
			If mv_par20 == 1
				@li,194 PSAY SUBSTR(SE2->E2_HIST,1,24)+ ;
					IIF(E2_TIPO $ MVPROVIS,"*"," ")+ ;
					Iif(nSaldo == xMoeda(E2_VALOR,E2_MOEDA,mv_par15,dDataReaj,ndecs+1,If(mv_par34==1,SE2->E2_TXMOEDA,Nil),0)," ","P")
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Carrega data do registro para permitir ³
			//³ posterior analise de quebra por mes.	 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dDataAnt := Iif(nOrdem == 3, SE2->E2_VENCREA, SE2->E2_EMISSAO)

			dbSkip()
			nTotTit ++
			nMesTTit ++
			nFiltit++
			nTit5 ++
			If mv_par20 == 1
				li ++
			EndIf

		EndDO

		IF nTit5 > 0 .and. nOrdem != 1
			SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)
			If mv_par20 == 1
				li++
			EndIf
		EndIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica quebra por mes					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lQuebra := .F.
		If nOrdem == 3 .and. Month(SE2->E2_VENCREA) # Month(dDataAnt)
			lQuebra := .T.
		Elseif nOrdem == 6 .and. Month(SE2->E2_EMISSAO) # Month(dDataAnt)
			lQuebra := .T.
		Endif
		If lQuebra .and. nMesTTit # 0
			ImpMes150(nMesTit0,nMesTit1,nMesTit2,nMesTit3,nMesTit4,nMesTTit,nMesTitJ,nDecs)
			nMesTit0 := nMesTit1 := nMesTit2 := nMesTit3 := nMesTit4 := nMesTTit := nMesTitj := 0
		Endif

		dbSelectArea("SE2")

		nTot0 += nTit0
		nTot1 += nTit1
		nTot2 += nTit2
		nTot3 += nTit3
		nTot4 += nTit4
		nTotJ += nTotJur

		nFil0 += nTit0
		nFil1 += nTit1
		nFil2 += nTit2
		nFil3 += nTit3
		nFil4 += nTit4
		nFilJ += nTotJur
		Store 0 To nTit0,nTit1,nTit2,nTit3,nTit4,nTit5,nTotJur
	Enddo					

	dbSelectArea("SE2")		// voltar para alias existente, se nao, nao funciona
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par22 == 1 .and. SM0->(Reccount()) > 1
		ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilj,nDecs)
	Endif
	Store 0 To nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ
	If Empty(xFilial("SE2"))
		Exit
	Endif

	#IFDEF TOP
		if TcSrvType() != "AS/400"
			dbSelectArea("SE2")
			dbCloseArea()
			ChKFile("SE2")
			dbSetOrder(1)
		endif
	#ENDIF

	dbSelectArea("SM0")
	dbSkip()
EndDO

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

IF li != 80
	If mv_par20 == 1
		li +=2
	Endif
	ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,aNat)
	cbcont := 1
	roda(cbcont,cbtxt,"G")
EndIF
Set Device To Screen

#IFNDEF TOP
	dbSelectArea( "SE2" )
	dbClearFil()
	RetIndex( "SE2" )
	If !Empty(cIndexSE2)
		FErase (cIndexSE2+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		dbSelectArea("SE2")
		dbCloseArea()
		ChKFile("SE2")
		dbSetOrder(1)
	else
		dbSelectArea( "SE2" )
		dbClearFil()
		RetIndex( "SE2" )
		If !Empty(cIndexSE2)
			FErase (cIndexSE2+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF	

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif

li := 80
tamanho := "P"
wnrel := "RESUMO"
titulo	:= "RESUMO TITULOS A PAGAR"
__AIMPRESS[1]	:= 1
wnrel := SetPrint("",wnrel,"",@titulo,"RESUMO CONTAS A PAGAR","","",.F.,aOrd,,Tamanho,,,,,.T.,)

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)
/*
// Inicio Adriano
// 21/02/2008
If Len(aNat) > 1
	If mv_par20 == 1
		li	:= 80
		IF li > 60
			nAtuSM0 := SM0->(Recno())
			SM0->(dbGoto(nRegSM0))
			Cabec1	:= "CODIGO   DESCRIÇÃO                     |  VALOR ORIGINAL|   VALOR A PAGAR|   %   |"
			Cabec2 	:= "         NATUREZA                      |                 |                |PAGAR |" 
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
			SM0->(dbGoTo(nAtuSM0)) 
			li += 1		
			@Li, 00 Psay "RESUMO A PAGAR PERIODO - "+DtoC(_dPerIni)+" A "+DtoC(_dPerFin)
			li += 1	
		EndIF
		_nTot2	:= 0
		_nTot3	:= 0
		_nTot4	:= 0
		_nRes2	:= 0
		_nRes3	:= 0	
		_nRes4	:= 0
			
		For nR := 1 to Len(aNat)
			_nTot2	+= aNat[nR,2] // Valor Original
			_nTot3	+= aNat[nR,3] // Valor A Vencer
			_nTot4	+= aNat[nR,4] // Valor Vencido
		next Nr
		aSort(aNat,,,{|x,y|x[1]<y[1]})
		_cNatual	:= SubStr(aNat[1,1],1,2)
		For nR := 1 to Len(aNat)
			IF li > 60
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
			EndIF                                  	
			If SubStr(aNat[nR,1],1,2) <> _cNatual
				@li,000 Psay _cNatual
				@li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+Substr(_cNatual,1,2),"ED_DESCRIC"),1,30)
				@li,042 Psay _nRes2 Picture TM(nTot0,14,nDecs)
				@li,059 Psay _nRes3 Picture TM(nTot0,14,nDecs)
	
				@li,074 Psay (_nRes3 / (_nTot3+_nTot4) )*100 Picture "@E 999.999"
				@li,081 Psay "%"
				li += 2
				_nRes2	:= 0
				_nRes3	:= 0
				@li,000 Psay SubStr(aNat[nR,1],1,7)
			    @li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+aNat[nR,1],"ED_DESCRIC"),1,30)
				@li,042 Psay aNat[nR,2] Picture TM(nTot0,14,nDecs)
				@li,059 Psay (aNat[nR,3]+aNat[nR,4]) Picture TM(nTot0,14,nDecs)
				@li,074 Psay ((aNat[nR,3]+aNat[nR,4]) / (_nTot3+_nTot4) )*100 Picture "@E 999.999"
				@li,081 Psay "%"
				_nRes2	+= aNat[nR,2]
				_nRes3	+= (aNat[nR,3]+aNat[nR,4])
				li+=1
			Else
				@li,000 Psay SubStr(aNat[nR,1],1,7)
			    @li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+aNat[nR,1],"ED_DESCRIC"),1,30)
				@li,042 Psay aNat[nR,2] Picture TM(nTot0,14,nDecs)
				@li,059 Psay (aNat[nR,3]+aNat[nR,4]) Picture TM(nTot0,14,nDecs)
				@li,074 Psay ((aNat[nR,3]+aNat[nR,4]) / (_nTot3+_nTot4) )*100 Picture "@E 999.999"
				@li,081 Psay "%"
				_nRes2	+= aNat[nR,2]
				_nRes3	+= (aNat[nR,3]+aNat[nR,4])
				li+=1
			Endif
			_cNatual	:= SubStr(aNat[nR,1],1,2)		
		Next nR
		@li,000 Psay _cNatual
		@li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+Substr(_cNatual,1,2),"ED_DESCRIC"),1,30)
		@li,042 Psay _nRes2 Picture TM(nTot0,14,nDecs)
		@li,059 Psay _nRes3 Picture TM(nTot0,14,nDecs)
		@li,074 Psay (_nRes3 / (_nTot3+_nTot4) )*100 Picture "@E 999.999"
		@li,081 Psay "%"
		li += 2
		@li,000 PSAY OemToAnsi(STR0027)
		@li,042 Psay _nTot2 Picture TM(nTot0,14,nDecs)
		@li,059 Psay (_nTot3+_nTot4) Picture TM(nTot0,14,nDecs)
	Endif
Endif 
If mv_par36 ==1
	li += 4
	If li <= 55
		@li, 00 Psay "RESUMO PAGO ANUAL - "+DtoC(mv_par07)+" A "+DtoC(mv_par08)
		li += 1
		@li,00 Psay "CODIGO   DESCRIÇÃO                     |      VALOR PAGO|         %|"
		li += 1
		@li,00 Psay "         NATUREZA                      |                |      PAGO|" 
		li += 2
		Cabec1	:= "CODIGO   DESCRIÇÃO                     |      VALOR PAGO|         %|"
		Cabec2 	:= "         NATUREZA                      |                |      PAGO|" 
	Else
		li := 80
	Endif	
	If Len(_aResumo) > 1
		If mv_par20 == 1
			IF li > 60
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))                                                                  	
				Cabec1	:= "CODIGO   DESCRIÇÃO                     |      VALOR PAGO|         %|"
				Cabec2 	:= "         NATUREZA                      |                |      PAGO|" 
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				SM0->(dbGoTo(nAtuSM0))
				li += 1		
				@Li, 00 Psay "RESUMO PAGO ANUAL - "+DtoC(mv_par07)+" A "+DtoC(mv_par08)
				li += 1
			EndIF
			_nTot2	:= 0
			_nTot3	:= 0
			_nTot4	:= 0
			_nRes2	:= 0
			_nRes3	:= 0	
			_nRes4	:= 0
				
			For nR := 1 to Len(_aResumo)
				_nTot2	+= _aResumo[nR,2] // Total Geral Pago
			next Nr
			aSort(_aResumo,,,{|x,y|x[1]<y[1]})
			_cNatual	:= SubStr(_aResumo[1,1],1,2)
			For nR := 1 to Len(_aResumo)
				IF li > 60
					nAtuSM0 := SM0->(Recno())
					SM0->(dbGoto(nRegSM0))
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
					SM0->(dbGoTo(nAtuSM0))
					li += 1
					@Li, 00 Psay "RESUMO PAGO ANUAL - "+DtoC(mv_par07)+" A "+DtoC(mv_par08)
					li += 1
				EndIF                                  	
				If SubStr(_aResumo[nR,1],1,2) <> _cNatual
					@li,000 Psay _cNatual
					@li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+Substr(_cNatual,1,2),"ED_DESCRIC"),1,30)
					@li,042 Psay _nRes2 Picture TM(nTot0,14,nDecs)
					@li,057 Psay (_nRes2 / (_nTot2) )*100 Picture "@E 999.99999"
					@li,066 Psay "%"
					li += 2
	
					_nRes2	:= 0
					@li,000 Psay SubStr(_aResumo[nR,1],1,7)
				    @li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+_aResumo[nR,1],"ED_DESCRIC"),1,30)
					@li,042 Psay _aResumo[nR,2] Picture TM(nTot0,14,nDecs)
					@li,057 Psay (_aResumo[nR,2] / _nTot2)*100 Picture "@E 999.99999"
					@li,066 Psay "%"
					_nRes2	+= _aResumo[nR,2]
	
					li+=1
				Else
					@li,000 Psay SubStr(_aResumo[nR,1],1,7)
				    @li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+_aResumo[nR,1],"ED_DESCRIC"),1,30)
					@li,042 Psay _aResumo[nR,2] Picture TM(nTot0,14,nDecs)
					@li,057 Psay (_aResumo[nR,2] / _nTot2 )*100 Picture "@E 999.99999"
					@li,066 Psay "%"
					_nRes2	+= _aResumo[nR,2]
					li+=1
				Endif
				_cNatual	:= SubStr(_aResumo[nR,1],1,2)		
			Next nR
			@li,000 Psay _cNatual
			@li,008 Psay SubStr(POSICIONE("SED",1,xFilial("SED")+Substr(_cNatual,1,2),"ED_DESCRIC"),1,30)
			@li,042 Psay _nRes2 Picture TM(nTot0,14,nDecs)
			@li,057 Psay (_nRes2 / _nTot2 )*100 Picture "@E 999.99999"
			@li,066 Psay "%"
			li += 2
			@li,000 PSAY OemToAnsi(STR0027)
			@li,042 Psay _nTot2 Picture TM(nTot0,14,nDecs)
		Endif
	Endif 
	
	// Fim
Endif
*/
Set Device To Screen
If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	ourspool(wnrel)
Endif	

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SubTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR SUBTOTAL DO RELATORIO 									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ SubTot150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
// Adriano
Static Function SubTot150(nTit0,nTit1,nTit2,nTit3,nTit4,nOrdem,cCarAnt,nTotJur,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

If mv_par20 == 1
	li++
EndIf

IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

if nOrdem == 1 .Or. nOrdem == 3 .Or. nOrdem == 4 .Or. nOrdem == 6
	@li,000 PSAY OemToAnsi(STR0026)  //"S U B - T O T A L ----> "
	@li,028 PSAY cCarAnt
ElseIf nOrdem == 2
	dbSelectArea("SED")
	dbSeek(xFilial("SED")+cCarAnt)
	@li,000 PSAY cCarAnt +" "+SED->ED_DESCRIC
Elseif nOrdem == 5
	@Li,000 PSAY IIF(mv_par28 == 1,SA2->A2_NREDUZ,SA2->A2_NOME)+" "+Substr(SA2->A2_TEL,1,15)
ElseIf nOrdem == 7
	@li,000 PSAY SA2->A2_COD+" " + SA2->A2_LOJA+" "+Substr(SA2->A2_NOME,1,65)+" "+Substr(SA2->A2_TEL,1,15)
Endif

@li,096 PSAY nTit0		 Picture TM(nTit0,14,nDecs)
@li,112 PSAY nTit1		 Picture TM(nTit1,14,nDecs)
@li,129 PSAY nTit2		 Picture TM(nTit2,14,nDecs)
@li,147 PSAY nTit3		 Picture TM(nTit3,14,nDecs)
If nTotJur > 0
	@li,173 PSAY nTotJur 	 Picture TM(nTotJur,12,nDecs)
Endif
@li,204 PSAY nTit2+nTit3 Picture TM(nTit2+nTit3,16,nDecs)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpTot150 ³ Autor ³ Wagner Xavier 		  ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTot150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpTot150(nTot0,nTot1,nTot2,nTot3,nTot4,nTotTit,nTotJ,nDecs,aNat)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0027)  //"T O T A L   G E R A L ----> "
@li,028 PSAY "("+ALLTRIM(STR(nTotTit))+" "+IIF(nTotTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"

@li,096 PSAY nTot0		 Picture TM(nTot0,14,nDecs)
@li,112 PSAY nTot1		 Picture TM(nTot1,14,nDecs)
@li,129 PSAY nTot2		 Picture TM(nTot2,14,nDecs)
@li,147 PSAY nTot3		 Picture TM(nTot3,14,nDecs)
@li,173 PSAY nTotJ		 Picture TM(nTotJ,12,nDecs)
@li,204 PSAY nTot2+nTot3 Picture TM(nTot2+nTot3,16,nDecs)
li+=2

// Inicio Adriano
// 21/02/2008
/*
_dPerIni := mv_par07
_dPerFin := mv_par08
If MV_PAR36 == 1
//	_dIni	:= SubStr(DtoS(Date()),1,4)+"0101" // Considerando data do servidor do sistema.
//	_dFin	:= SubStr(DtoS(Date()),1,4)+"1231" // Considerando data do servidor do sistema.
	
	_dIni	:= SubStr(DtoS(dDataBase),1,4)+"0101" // Considerando data base do sistema.
	_dFin	:= SubStr(DtoS(dDataBase),1,4)+"1231" // Considerando data base do sistema.

	_dPerIni := mv_par07
	_dPerFin := mv_par08
	
	mv_par07	:= StoD(_dIni)
	mv_par08    := StoD(_dFin)
	
	U_SGFIN19B(mv_par01,mv_par02,mv_par03,mv_par04,mv_par05,mv_par06,mv_par07,mv_par08,mv_par09,mv_par10,mv_par11,mv_par12,mv_par13,mv_par14,mv_par15,mv_par16,mv_par17,mv_par18,mv_par19,mv_par20,mv_par21,mv_par22,mv_par23,mv_par24,mv_par25,mv_par26,mv_par27,mv_par28,mv_par29,mv_par30,mv_par31,mv_par32,mv_par33,mv_par34,mv_par35,cOrder)
Endif

If mv_par36 ==1
	aResAno	:= {}
	DbSelectArea("SZK")
	DbSetOrder(1)
	DbGotop()
	While !eof("SZK")              
		If SZK->ZK_ANO <> "2010"
			nPosicao := ascan(aResAno,{|_x| SZK->ZK_ANO+SubStr(SZK->ZK_NATUREZ,1,2) == _x[1]})
			If nPosicao > 0                     	
				aResAno[nPosicao][2]	+= SZK->ZK_SALDO
			Else
				aADD(aResAno,{SZK->ZK_ANO+SubStr(SZK->ZK_NATUREZ,1,2),SZK->ZK_SALDO})
			Endif
		Endif
		DbSkip()
	End
	
	If Len(_aResumo) > 1   
		For nR := 1 to Len(_aResumo)
			nPosicao := ascan(aResAno,{|_x| "2010"+SubStr(_aResumo[nR,1],1,2) == _x[1]})
			If nPosicao > 0                     	
				aResAno[nPosicao][2]	+= _aResumo[nR,2]
			Else
				aADD(aResAno,{"2010"+SubStr(_aResumo[nR,1],1,2),_aResumo[nR,2]})
			Endif
		Next nR
	Endif
	
	If Len(aResAno) > 1
		If mv_par20 == 1
	
			nNatAtu	:= 11
			nT05	:= 0
			nT06	:= 0
			nT07	:= 0
			nT08	:= 0
			nT09	:= 0
			nT10	:= 0						
			While nNatAtu < 31
				If (nNatAtu > 18 .AND. nNatAtu < 29) .OR. (nNatAtu > 31)
				//(nNatAtu > 18 .AND. nNatAtu < 30) .OR. (nNatAtu > 31)
					nNatAtu ++
					Loop
				Endif			
			
				nPosicao := ascan(aResAno,{|_x| "2005"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT05 += aResAno[nPosicao,2]
				Endif
			
				nPosicao := ascan(aResAno,{|_x| "2006"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT06 += aResAno[nPosicao,2]
				Endif
		
				nPosicao := ascan(aResAno,{|_x| "2007"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT07 += aResAno[nPosicao,2]
				Endif
				
				nPosicao := ascan(aResAno,{|_x| "2008"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT08 += aResAno[nPosicao,2]
				Endif			
				nPosicao := ascan(aResAno,{|_x| "2009"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT09 += aResAno[nPosicao,2]
				Endif
				nPosicao := ascan(aResAno,{|_x| "2010"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
					nT10 += aResAno[nPosicao,2]
				Endif											
				nNatAtu ++
			End
			li += 3
			IF li > 58
				Cabec1	:= "|             NATUREZA              |        PAGO 2005      %     |       PAGO 2006      %     |       PAGO 2007      %     |       PAGO 2008      %     |       PAGO 2009      %     |       PAGO 2010      %     |"
				Cabec2 	:= "|                                   |                             |                            |                            							                              |"
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				li += 1
			EndIF
			nNatAtu	:= 11
			@li, 00 Psay "|             NATUREZA              |        PAGO 2005      %     |       PAGO 2006      %     |       PAGO 2007      %     |       PAGO 2008      %     |       PAGO 2009      %     |       PAGO 2010      %     |"
			li += 2
			While nNatAtu < 31
				If (nNatAtu > 18 .AND. nNatAtu < 30) .OR. (nNatAtu > 31)
				//(nNatAtu > 18 .AND. nNatAtu < 30) .OR. (nNatAtu > 31)
					nNatAtu ++
					Loop
				Endif			
				IF li > 58
					Cabec1	:= "|             NATUREZA              |        PAGO 2005      %     |       PAGO 2006      %     |       PAGO 2007      %     |       PAGO 2008      %     |       PAGO 2009      %     |       PAGO 2010      %     |"
					Cabec2 	:= "|                                   |                             |                            |                            							                              |"
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
					li += 1
				EndIF
				nPosicao := ascan(aResAno,{|_x| "2005"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao = 0 
						nPosicao := ascan(aResAno,{|_x| "2008"+AllTrim(STR(nNatAtu)) == _x[1]})
				Endif
				@li, 00 Psay "|"
				@li, 01 Psay SubStr(aResAno[nPosicao,1],5,2)
				@li, 03 Psay " - "+SubStr(POSICIONE("SED",1,xFilial("SED")+AllTrim(SubStr(aResAno[nPosicao,1],5,2)),"ED_DESCRIC"),1,30)+"|"
				nPosicao := ascan(aResAno,{|_x| "2005"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 038 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 055 PSAY ((aResAno[nPosicao,2] / nT05) * 100) Picture "@E 999.99999"
			    	@li, 064 Psay "%"+" |"
				Endif
				nPosicao := ascan(aResAno,{|_x| "2006"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 067 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 084 PSAY ((aResAno[nPosicao,2] / nT06) * 100) Picture "@E 999.99999"
			    	@li, 093 Psay "%"+" |"
				Endif
				nPosicao := ascan(aResAno,{|_x| "2007"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 096 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 113 PSAY ((aResAno[nPosicao,2] / nT07) * 100) Picture "@E 999.99999"
				   	@li, 122 Psay "%"+" |"
				Endif
				nPosicao := ascan(aResAno,{|_x| "2008"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 125 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 142 PSAY ((aResAno[nPosicao,2] / nT08) * 100) Picture "@E 999.99999"
				   	@li, 151 Psay "%"+" |"
				Endif
				nPosicao := ascan(aResAno,{|_x| "2009"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 154 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 171 PSAY ((aResAno[nPosicao,2] / nT08) * 100) Picture "@E 999.99999"
				   	@li, 180 Psay "%"+" |"
				Endif								
				nPosicao := ascan(aResAno,{|_x| "2010"+AllTrim(STR(nNatAtu)) == _x[1]})
				If nPosicao > 0
				   	@li, 183 Psay aResAno[nPosicao,2] Picture "@E 9,999,999,999.99"
			    	@li, 200 PSAY ((aResAno[nPosicao,2] / nT09) * 100) Picture "@E 999.99999"
				Endif
			   	@li, 209 Psay "%"+" |"			   	
				nNatAtu ++
				li ++
			End
			IF li > 58
				Cabec1	:= "|             NATUREZA              |        PAGO 2005      %     |       PAGO 2006      %     |       PAGO 2007      %     |       PAGO 2008      %     |"
				Cabec2 	:= "|                                   |                             |                            |                            							 |"
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
				li += 1
			EndIF
			@li, 00 Psay "|            TOTAL GERAL            |"
			@li, 038 Psay nT05 Picture "@E 9,999,999,999.99"
			@li, 066 Psay "|"
			@li, 067 Psay nT06 Picture "@E 9,999,999,999.99"
			@li, 095 Psay "|"
			@li, 096 Psay nT07 Picture "@E 9,999,999,999.99"
			@li, 124 Psay "|"
			@li, 125 Psay nT08 Picture "@E 9,999,999,999.99"
			@li, 153 Psay "|"
			@li, 154 Psay nT09 Picture "@E 9,999,999,999.99"
			@li, 182 Psay "|"			
			@li, 183 Psay nT10 Picture "@E 9,999,999,999.99"
			@li, 211 Psay "|"			
		Endif
	Endif
Endif
_nTotG	:= 0
_nTotM	:= 0
If mv_par36 == 1
	aPer	:= {}
	li += 4
	_Mes	:= AllTrim(Str(month(date())))+"/"+AllTrim(Str(Year(Date())))
	Cabec1	:= "|             NATUREZA              |       A PAGAR PERIODO       |         PAGO MES           |"
	Cabec2 	:= "|                                   |     "+DtoC(_dPerIni)+" A "+DtoC(_dPerFin)+"     |          "+_Mes+"         % |"
	
	IF li > 58
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	Else
		@li, 00 Psay Cabec1	
		li += 1
		@li, 00 Psay Cabec2
		li += 2
	Endif
	
	_nTotG	:= 0
	_nTotM	:= 0
	
	If Len(aNat) > 0
		For nR := 1 To Len(aNat)
			If (Val(SubStr(aNat[nR,1],1,2)) < 19 .AND. Val(SubStr(aNat[nR,1],1,2)) > 10) .OR. (Val(SubStr(aNat[nR,1],1,2)) < 31 .AND. Val(SubStr(aNat[nR,1],1,2)) > 29)
				nPosicao := ascan(aPer,{|_x| SubStr(aNat[nR,1],1,2) == _x[1]})
				If nPosicao > 0                     	
					aPer[nPosicao][2]	+= (aNat[nR,3]+aNat[nR,4])
				Else
					aADD(aPer,{SubStr(aNat[nR,1],1,2),(aNat[nR,3]+aNat[nR,4])})
				Endif
				_nTotG += (aNat[nR,3]+aNat[nR,4])
			Endif
		Next nR
		For nR := 1 To Len(_aRMes)
			_nTotM += _aRMes[nR,2]
		Next nR
		
		nNatAtu	:= 11		
		While nNatAtu < 31
			If (nNatAtu > 18 .AND. nNatAtu < 30) .OR. (nNatAtu > 31)
				nNatAtu ++
				Loop
			Endif
			IF li > 58            
				cabec(titulo,Cabec1,Cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
			Endif
			@li, 000 Psay "|"
			@li, 001 Psay AllTrim(Str(nNatAtu))
			@li, 003 Psay " - "+SubStr(POSICIONE("SED",1,xFilial("SED")+AllTrim(Str(nNatAtu)),"ED_DESCRIC"),1,30)+"|"
			nPosicao := ascan(aPer,{|_x| AllTrim(STR(nNatAtu)) == _x[1]})
			If nPosicao > 0
			   	@li, 038 Psay aPer[nPosicao,2] Picture "@E 9,999,999,999.99"
		    	@li, 055 PSAY ((aPer[nPosicao,2] / _nTotG) * 100) Picture "@E 999.99999"
			Endif
			@li, 064 Psay "%"+" |"
			nPosicao := ascan(_aRMes,{|_x| AllTrim(STR(nNatAtu)) == _x[1]})
			If nPosicao > 0
			   	@li, 067 Psay _aRMes[nPosicao,2] Picture "@E 9,999,999,999.99"
		    	@li, 084 PSAY ((_aRMes[nPosicao,2] / _nTotM) * 100) Picture "@E 999.99999"
			Endif
	    	@li, 093 Psay "%"+" |"
			li ++
			nNatAtu ++
		End
	Endif
Endif
@li, 006 Psay "TOTAL A PAGAR PERIODO   --->  |"
@li, 038 Psay _nTotG Picture "@E 9,999,999,999.99"
@li, 066 Psay "|"
@li, 067 Psay _nTotM Picture "@E 9,999,999,999.99"
@li, 095 Psay "|"
// Fim 
*/

Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ImpMes150 ³ Autor ³ Vinicius Barreira	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³IMPRIMIR TOTAL DO RELATORIO - QUEBRA POR MES					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpMes150() 															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ 																			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
STATIC Function ImpMes150(nMesTot0,nMesTot1,nMesTot2,nMesTot3,nMesTot4,nMesTTit,nMesTotJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0030)  //"T O T A L   D O  M E S ---> "
@li,028 PSAY "("+ALLTRIM(STR(nMesTTit))+" "+IIF(nMesTTit > 1,OemToAnsi(STR0028),OemToAnsi(STR0029))+")"  //"TITULOS"###"TITULO"

@li,096 PSAY nMesTot0   Picture TM(nMesTot0,14,nDecs)
@li,112 PSAY nMesTot1	Picture TM(nMesTot1,14,nDecs)
@li,129 PSAY nMesTot2	Picture TM(nMesTot2,14,nDecs)
@li,147 PSAY nMesTot3	Picture TM(nMesTot3,14,nDecs)
@li,173 PSAY nMesTotJ	Picture TM(nMesTotJ,12,nDecs)
@li,204 PSAY nMesTot2+nMesTot3 Picture TM(nMesTot2+nMesTot3,16,nDecs)
li+=2
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil150³ Autor ³ Paulo Boschetti 	     ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil150()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico				   									 			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil150(nFil0,nFil1,nFil2,nFil3,nFil4,nFilTit,nFilJ,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li++
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF
@li,000 PSAY OemToAnsi(STR0032)+" "+cFilAnt  //"T O T A L   F I L I A L ----> " 

@li,096 PSAY nFil0        Picture TM(nFil0,14,nDecs)
@li,112 PSAY nFil1        Picture TM(nFil1,14,nDecs)
@li,129 PSAY nFil2        Picture TM(nFil2,14,nDecs)
@li,147 PSAY nFil3        Picture TM(nFil3,14,nDecs)
@li,173 PSAY nFilJ		  Picture TM(nFilJ,12,nDecs)
@li,204 PSAY nFil2+nFil3 Picture TM(nFil2+nFil3,16,nDecs)
li+=2
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fr150Indr ³ Autor ³ Wagner           	  ³ Data ³ 12.12.94 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 																  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fr150IndR()
Local cString
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ ATENCAO !!!!                                               ³
//³ N„o adiconar mais nada a chave do filtro pois a mesma est  ³
//³ com 254 caracteres.                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cString := 'E2_FILIAL="'+xFilial()+'".And.'
cString += '(E2_MULTNAT="1" .OR. (E2_NATUREZ>="'+mv_par05+'".and.E2_NATUREZ<="'+mv_par06+'")).And.'
cString += 'E2_FORNECE>="'+mv_par11+'".and.E2_FORNECE<="'+mv_par12+'".And.'
cString += 'DTOS(E2_VENCREA)>="'+DTOS(mv_par07)+'".and.DTOS(E2_VENCREA)<="'+DTOS(mv_par08)+'".And.'
cString += 'DTOS(E2_EMISSAO)>="'+DTOS(mv_par13)+'".and.DTOS(E2_EMISSAO)<="'+DTOS(mv_par14)+'"'
If !Empty(mv_par30) // Deseja imprimir apenas os tipos do parametro 30
	cString += '.And.E2_TIPO$"'+mv_par30+'"'
ElseIf !Empty(Mv_par31) // Deseja excluir os tipos do parametro 31
	cString += '.And.!(E2_TIPO$'+'"'+mv_par31+'")'
EndIf
IF mv_par32 == 1  // Apenas titulos que estarao no fluxo de caixa
	cString += '.And.(E2_FLUXO!="N")'	
Endif
		
Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ PutDtBase³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 18/07/02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta parametro database do relat[orio.                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Finr150.                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function PutDtBase()
Local _sAlias	:= Alias()

dbSelectArea("SX1")
dbSetOrder(1)
If MsSeek("FIN15033")
	//Acerto o parametro com a database
	RecLock("SX1",.F.)
	Replace x1_cnt01		With "'"+DTOC(dDataBase)+"'"
	MsUnlock()	
Endif
If MsSeek("FIN15036")
	RecLock("SX1",.F.)
	x1_presel	:= 2
//	x1_cnt01	:= "2"
	MsUnlock()
Endif

dbSelectArea(_sAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Claudio D. de Souza º Data ³08.07.2004   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Insere novas perguntas ao sx1                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINR150                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1()

Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

Aadd( aHelpPor, "Indica que o valor será convertido de  "  )
Aadd( aHelpPor, 'acordo com a "Taxa contradada" ou  de  '  )
Aadd( aHelpPor, 'acordo com a "Taxa normal". Se for esco-' )
Aadd( aHelpPor, 'lhida "Taxa contratada", o valor será  '  )
Aadd( aHelpPor, "convertido pela taxa contradada para o "  )
Aadd( aHelpPor, 'titulo. Se for escolhida "Taxa Normal" '  )
Aadd( aHelpPor, 'o valor será convertido pela taxa da   '  )
Aadd( aHelpPor, 'data base do sistema, ou se o titulo   '  )
Aadd( aHelpPor, 'estiver vencido, pela taxa da data     '  )
Aadd( aHelpPor, 'informada na pergunta'             		  )
Aadd( aHelpPor, '"Converte Venci Por?"'  		              )

Aadd( aHelpSpa, "Indica que el valor se convertira de "	)
Aadd( aHelpSpa, 'acuerdo con la "Tasa contratada" o la' 	)
Aadd( aHelpSpa, '"Tasa normal". Si se elige la ' 			)
Aadd( aHelpSpa, '"Tasa contratada", el valor se  '     	)
Aadd( aHelpSpa, "convertira por la tasa contratada para"	) 
Aadd( aHelpSpa, 'el titulo. Si se elige la "Tasa Normal"')
Aadd( aHelpSpa, 'el valor se convertira por la tasa de la')
Aadd( aHelpSpa, 'fecha base del sistema o, si el titulo'	)
Aadd( aHelpSpa, 'estuviera vencido, por la tasa de la '	)
Aadd( aHelpSpa, 'fecha informada en la pregunta '			)
Aadd( aHelpSpa, '"¿Convierte Venc Por?"' )            

Aadd( aHelpEng, "Determine if the value will be converted "	)
Aadd( aHelpEng, 'according to the "Hired rate" or to the  '	)
Aadd( aHelpEng, '"Normal rate". If a "Hired rate" is '  		)
Aadd( aHelpEng, 'chosen, the value will be converted by'		)
Aadd( aHelpEng, "the rate hired for the bill. However, if "	)
Aadd( aHelpEng, 'a "Normal rate" is chosen, the value will'	)
Aadd( aHelpEng, 'be converted by the rate of the system   '	) 
Aadd( aHelpEng, 'base date, or if the bill is due, this   '	) 
Aadd( aHelpEng, 'will be converted by the rate of the '		) 
Aadd( aHelpEng, 'informed date found in query'					)
Aadd( aHelpEng, '"Convert Due Date By?"'							)

PutSx1( "FIN150", "34","Quanto a Taxa?","¿Cuanto a tasa?","How about rate?","mv_chs","N",1,0,1,"C","","","","",;
			"mv_par34","Taxa Contratada","Tasa contratada","Hired Rate","","Taxa Normal","Tasa Normal","Normal Rate","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)

aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, 'Selecione "Sim" para que sejam         '  )
Aadd( aHelpPor, 'considerados no relatório, títulos cuja'  )
Aadd( aHelpPor, 'emissão seja em data posterior a database' )
Aadd( aHelpPor, 'do relatório, ou "Não" em caso contrário'  )

Aadd( aHelpSpa, 'Seleccione "Sí" para que se consideren en'	)
Aadd( aHelpSpa, 'el informe los títulos cuya emisión sea en')
Aadd( aHelpSpa, 'fecha posterior a la fecha base de dicho '	)
Aadd( aHelpSpa, 'informe o "No" en caso contrario'	)

Aadd( aHelpEng, 'Choose "Yes" for bills which issue date '	)
Aadd( aHelpEng, 'is posterior to the report base date in ' 	)
Aadd( aHelpEng, 'the report, otherwise "No"' 			)

PutSx1( "FIN150", "35","Tit. Emissao Futura?","Tit.Emision Futura  ","Future Issue Bill   ","mv_cht","N",1,0,2,"C","","","","","mv_par35","Sim","Si","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
PutSx1( "FIN150", "36","Imp. Resumo Anual  ?","Imp. Resumo Anual  ?","Imp. Resumo Anual  ?","mv_chu","N",1,0,2,"C","","","","","mv_par36","Sim","Si","Yes","","Nao","No","No","","","","","","","","","","","","")
                         
Return