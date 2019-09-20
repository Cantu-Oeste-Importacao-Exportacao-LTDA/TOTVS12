#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F565VAL     ºAutor  ³Rafael Parma      º Data ³  30/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE sobre liquidação a pagar, será utilizado para informar   º±±
±±º          ³dados necessários à gravação complementar dos titulos.      º±±
±±º          ³Grava dados complementares (Centro Custo/Segmento).         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-------------------------------*
User Function F565VAL()
*-------------------------------*
Local aAreaTMP  := GetArea()      
Local cAliasTMP := GetNextAlias()
Local cCCD	    := Space(TAMSX3("E2_CCD")[1])
Local cCLVLDB   := Space(TAMSX3("E2_CLVLDB")[1])       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	cQuery := "		SELECT	SE2.E2_CLVLDB, SE2.E2_CCD 				"
	cQuery += "		FROM " + RetSQLName("SE2") + " SE2				"
	cQuery += "		INNER JOIN " + RetSQLName("SE5") + " SE5		"
	cQuery += "		ON  SE2.E2_FILIAL   = SE5.E5_FILIAL				"
	cQuery += "		AND SE2.E2_PREFIXO  = SE5.E5_PREFIXO			"
	cQuery += "		AND SE2.E2_NUM		= SE5.E5_NUMERO				"
	cQuery += "		AND SE2.E2_TIPO		= SE5.E5_TIPO  				"
	cQuery += "		AND SE2.E2_PARCELA	= SE5.E5_PARCELA			"
	cQuery += "		AND SE2.E2_FORNECE	= SE5.E5_CLIFOR 			"
	cQuery += "		AND SE2.E2_LOJA   	= SE5.E5_LOJA   			"	
	cQuery += "		WHERE							  				"
	cQuery += "		SE2.E2_FILIAL   	= '" + xFilial("SE2") + "'  "
	cQuery += "		AND SE5.E5_DOCUMEN  = '" + SE2->E2_NUMLIQ + "'	"
	cQuery += "		AND SE5.E5_SITUACA != 'C'						"
	cQuery += "		AND SE2.D_E_L_E_T_ != '*'						"
	cQuery += "		AND SE5.D_E_L_E_T_ != '*'						"
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		cCCD	:= (cAliasTMP)->E2_CCD
		cCLVLDB := (cAliasTMP)->E2_CLVLDB
	EndIf
	(cAliasTMP)->(dbCloseArea())

	
	dbSelectArea("SE2")
	If RecLock("SE2",.F.)          
		SE2->E2_CCD		:= cCCD
		SE2->E2_CLVLDB	:= cCLVLDB 
		SE2->(MsUnLock())
	EndIf                        
	                    
	RestArea(aAreaTMP)

Return