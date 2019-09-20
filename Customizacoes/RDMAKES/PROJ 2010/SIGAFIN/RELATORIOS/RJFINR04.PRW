#include "rwmake.ch"  
#include "topconn.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFINR04    บAutor  ณRafael Parma      บ Data ณ  23/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExtrato de movimenta็๕es do caixinha (SEU).                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       
*--------------------------*
User Function RJFINR04()         
*--------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "EXTRATO CAIXINHA"
Local nLin          := 80
Local Cabec1 		:= "DATA DIG.  HISTำRICO                  BENEFICIมRIO                    CำD.MOT.  NฺM.ADTO         ENTRADA           SAอDA      SALDO"
Local Cabec2 		:= ""
Local imprime       := .T.
Local aOrd          := {"Data Digita็ใo","Adiantamento","Motorista + Adiantamento"}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RJFINR04" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RJFINR04"
Private cPerg       := "RJFINR0004"
Private cString     := "SEU"
Private STRING_NULL := "" 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea(cString)
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AjustaSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]
	 
	If nOrdem == 1
		titulo := ALLTRIM(titulo) + " - POR DATA DIGITAวรO"
	ElseIf nOrdem == 2        
		titulo := ALLTRIM(titulo) + " - POR ADIANTAMENTO"
	Else
		titulo := ALLTRIM(titulo) + " - POR MOTORISTA + ADIANTAMENTO"
	EndIf
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Rafael Parma       บ Data ณ  22/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*---------------------------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*

Local cQuery    := STRING_NULL
Local cAliasTMP := GetNextAlias()
Local nTOTENT := 0
Local nTOTSAI := 0
Local nTOTSLD := 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de registros                                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	cQuery := "	SELECT																	" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_FILIAL,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_TIPO,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_CAIXA,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_HISTOR,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_BENEF,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_CODMOT,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_NROADIA,													" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_DTDIGIT,													" + chr(13)+ chr(10)	
	cQuery += "			SEU.EU_VALOR													" + chr(13)+ chr(10)
	cQuery += "	FROM " + RetSQLName("SEU") + " SEU		   								" + chr(13)+ chr(10)
	cQuery += "	WHERE 									   								" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_FILIAL = '" + xFilial("SEU") + "' 						" + chr(13)+ chr(10)
	cQuery += "	AND		SEU.EU_DTDIGIT BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'			" + chr(13)+ chr(10)
	cQuery += "	AND		SEU.EU_CODMOT BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + mv_par03 + "' AND '" + mv_par04 + "'						" + chr(13)+ chr(10)
	cQuery += "	AND		SEU.EU_CAIXA = '" + mv_par05 + "'								" + chr(13)+ chr(10)
	cQuery += "	AND		SEU.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	cQuery += "	ORDER BY																" + chr(13)+ chr(10)
	cQuery += "			SEU.EU_FILIAL,													" + chr(13)+ chr(10)
	If nOrdem == 1
		cQuery += "		SEU.EU_DTDIGIT 													" + chr(13)+ chr(10)
	ElseIf nOrdem == 2                	
		cQuery += "		SEU.EU_NROADIA,													" + chr(13)+ chr(10)
		cQuery += "		SEU.EU_DTDIGIT 													" + chr(13)+ chr(10)
	Else
		cQuery += "		SEU.EU_CODMOT,													" + chr(13)+ chr(10)
		cQuery += "		SEU.EU_NROADIA,													" + chr(13)+ chr(10)
		cQuery += "		SEU.EU_DTDIGIT 													" + chr(13)+ chr(10)
	EndIf
	
	
	memowrite("RJFINR04.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		nTOTSLD := fCalcSLD()
	EndIf
	SetRegua((cAliasTMP)->(RecCount()))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Percorre itens selecionados para impressใo                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	While (cAliasTMP)->(!EOF())

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica o cancelamento pelo usuario...                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do cabecalho do relatorio. . .                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		If nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			//-- Imprime saldo anterior do caixinha na primeira pแgina
			If nLin == 80
				nLin := 8
				@nLin,000 PSAY "SALDO ANTERIOR: "
				@nLin,121 PSAY nTOTSLD	PICTURE "@E 9,999,999.99"				
				nLin += 2
			Else
				nLin := 8
			EndIf

		Endif

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressใo dos dados                                                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	    
		//cabec1 := "DATA DIG.  HISTำRICO                  BENEFICIมRIO                    CำD.MOT.  NฺM.ADTO         ENTRADA           SAอDA        SALDO"
		//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
		//           0         1         2         3         4         5         6         7         8         9         10        11        12        13
		If (cAliasTMP)->EU_TIPO == "00" .AND. !Empty((cAliasTMP)->EU_NROADIA)
			(cAliasTMP)->(dbSkip())
			Loop	
		EndIf
		

		@nLin,000 PSAY DTOC(STOD((cAliasTMP)->EU_DTDIGIT))
		@nLin,011 PSAY (cAliasTMP)->EU_HISTOR		
		@nLin,038 PSAY SUBSTR((cAliasTMP)->EU_BENEF,1,30)
		@nLin,070 PSAY (cAliasTMP)->EU_CODMOT		
		@nLin,080 PSAY (cAliasTMP)->EU_NROADIA
		If (cAliasTMP)->EU_TIPO $ "02/10"
			@nLin,092 PSAY (cAliasTMP)->EU_VALOR	PICTURE "@E 9,999,999.99"
			nTOTSLD += (cAliasTMP)->EU_VALOR
			nTOTENT += (cAliasTMP)->EU_VALOR
		Else
			@nLin,109 PSAY (cAliasTMP)->EU_VALOR	PICTURE "@E 9,999,999.99"		
			nTOTSLD -= (cAliasTMP)->EU_VALOR
			nTOTSAI += (cAliasTMP)->EU_VALOR
		EndIf
		@nLin,121 PSAY nTOTSLD 	PICTURE "@E 9,999,999.99"

		nLin := nLin + 1 
	    
		IncRegua()
		(cAliasTMP)->(dbSkip())
	   
	EndDo
	
	(cAliasTMP)->(dbCloseArea())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Impressใo dos totalizadores                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	If nTOTSAI != 0 .or. nTOTENT != 0
        
		nLin := nLin + 1 
		@nLin,000 PSAY "TOTAL: "
		@nLin,092 PSAY nTOTENT	PICTURE "@E 9,999,999.99"
		@nLin,109 PSAY nTOTSAI	PICTURE "@E 9,999,999.99"
		@nLin,121 PSAY nTOTSLD	PICTURE "@E 9,999,999.99"
	
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfCalcSLD   บAutor  ณRafael Parma       บ Data ณ  23/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para cแlculo do saldo anterior do caixinha.บฑฑ
ฑฑบ          ณ            .                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function fCalcSLD()  
*--------------------------*
Local nSLDANT := 0
Local cDATANT := ""
Local cAliasSLD := GetNextAlias()


	
	/*
	If nOrdem != 3	// Ordem diferente de Motorista, no caso de ordem por motorista recupera saldo de todos os movimentos.

		//-- Recupera ๚ltimo registro de transfer๊ncia de saldo do caixinha
	
		cQuery := "	SELECT		MAX(SEU.R_E_C_N_O_) SEURECNO				   					" + chr(13)+ chr(10)
		cQuery += "	FROM " + RetSQLName("SEU") + " SEU						   					" + chr(13)+ chr(10)
		cQuery += "	WHERE		SEU.EU_FILIAL   = '" + xFilial("SEU") + "'						" + chr(13)+ chr(10)
		cQuery += "	AND			SEU.EU_CAIXA    = '" + mv_par05 + "'							" + chr(13)+ chr(10)
		cQuery += "	AND			SEU.EU_TIPO     = '11'											" + chr(13)+ chr(10) 
		cQuery += "	AND			SEU.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSLD)
		
		dbSelectArea(cAliasSLD)
		(cAliasSLD)->(dbGoTop())
		If !(cAliasSLD)->(EOF())
			If (cAliasSLD)->SEURECNO > 0
				nLASTRE := (cAliasSLD)->SEURECNO
			EndIf
		EndIf
		(cAliasSLD)->(dbCloseArea())
	
	EndIf
		
	
	//-- Recalcula o saldo at้ a data de inicio do relat๓rio.
	cQuery := "	SELECT 	SUM(CASE WHEN ( SEU.EU_TIPO = '02' OR SEU.EU_TIPO = '10' ) THEN 	" + chr(13)+ chr(10)
	cQuery += "				SEU.EU_VALOR ELSE (	CASE WHEN ( SEU.EU_TIPO >= '90' OR 			" + chr(13)+ chr(10)
	cQuery += "		 		(SEU.EU_TIPO = '00'  AND SEU.EU_NROADIA != '          ' ) ) 	" + chr(13)+ chr(10)
	cQuery += "		 		THEN 0 ELSE (SEU.EU_VALOR*(-1)) END ) END ) SALDO				" + chr(13)+ chr(10)
	cQuery += "	FROM " + RetSQLName("SEU") + " SEU											" + chr(13)+ chr(10)
	cQuery += "	WHERE		SEU.EU_FILIAL   = '" + xFilial("SEU") + "'						" + chr(13)+ chr(10)
	cQuery += "	AND			SEU.EU_DTDIGIT  < '" + dtos(mv_par01) + "'						" + chr(13)+ chr(10)
	cQuery += "	AND			SEU.EU_CODMOT BETWEEN											" + chr(13)+ chr(10)
	cQuery += "				'" + mv_par03 + "' AND '" + mv_par04 + "'						" + chr(13)+ chr(10)		
	cQuery += "	AND			SEU.EU_CAIXA    = '" + mv_par05 + "'							" + chr(13)+ chr(10)
	cQuery += "	AND			SEU.R_E_C_N_O_  > " + cValToChar(nLASTRE) + "					" + chr(13)+ chr(10) 
	cQuery += "	AND			SEU.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	
	*/

	cQuery := "	SELECT		MAX(FIJ.FIJ_DATA) FIJ_DATA					   					" + chr(13)+ chr(10)
	cQuery += "	FROM " + RetSQLName("FIJ") + " FIJ						   					" + chr(13)+ chr(10)
	cQuery += "	WHERE		FIJ.FIJ_FILIAL   = '" + xFilial("FIJ") + "'						" + chr(13)+ chr(10)
	cQuery += "	AND			FIJ.FIJ_CODCX    = '" + mv_par05 + "'							" + chr(13)+ chr(10)
	cQuery += "	AND			FIJ.FIJ_DATA     < '" + dtos(mv_par01) + "'						" + chr(13)+ chr(10)
	cQuery += "	AND			FIJ.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)	

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSLD)
	
	dbSelectArea(cAliasSLD)
	(cAliasSLD)->(dbGoTop())
	If !(cAliasSLD)->(EOF())	
		cDATANT := (cAliasSLD)->FIJ_DATA
	EndIf
	(cAliasSLD)->(dbCloseArea())	

    
	If cDATANT != ""
		
		cQuery := "	SELECT		FIJ_SALDO									   					" + chr(13)+ chr(10)
		cQuery += "	FROM " + RetSQLName("FIJ") + " FIJ						   					" + chr(13)+ chr(10)
		cQuery += "	WHERE		FIJ.FIJ_FILIAL   = '" + xFilial("FIJ") + "'						" + chr(13)+ chr(10)
		cQuery += "	AND			FIJ.FIJ_CODCX    = '" + mv_par05 + "'							" + chr(13)+ chr(10)
		cQuery += "	AND			FIJ.FIJ_DATA     = '" + cDATANT  + "'  							" + chr(13)+ chr(10)
		cQuery += "	AND			FIJ.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)	
	
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSLD)
		
		dbSelectArea(cAliasSLD)
		(cAliasSLD)->(dbGoTop())
		If !(cAliasSLD)->(EOF())	
			nSLDANT := (cAliasSLD)->FIJ_SALDO
		EndIf
		(cAliasSLD)->(dbCloseArea())	
	
	EndIf

Return (nSLDANT)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  23/02/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
 	aAdd(aRegs,{cPerg,"01","Data Digita็ใo De   ?","Data Digita็ใo De   ?","Data Digita็ใo De   ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Data Digita็ใo At้  ?","Data Digita็ใo At้  ?","Data Digita็ใo At้  ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"03","Motorista De        ?","Motorista De        ?","Motorista De        ?","mv_ch3","C",TAMSX3("EU_CODMOT")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "DA4","","",""})
	aAdd(aRegs,{cPerg,"04","Motorista At้       ?","Motorista At้       ?","Motorista At้       ?","mv_ch4","C",TAMSX3("EU_CODMOT")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "DA4","","",""})
	aAdd(aRegs,{cPerg,"05","Caixinha            ?","Caixinha            ?","Caixinha            ?","mv_ch5","C",TAMSX3("EU_CAIXA")[1] ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SET","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil