#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA456L   ºAutor  ³Rafael Parma        º Data ³  06/07/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado após a gravação de todas as libe-º±±
±±º          ³rações do pedido de vendas (Liberação Manual) tabela SC9.   º±±
±±º          ³nOpca = 1(OK) / nOpca = 3(Rejeita) / nOpca = 4(Libera Todos)º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*-------------------------*
User Function MTA456L()
*-------------------------*
Local nOpca := ParamIxb[1]
Local aArea := GetArea()
Local lRet  := .F.        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se pedido esta liberado e seta flag.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If nOpca == 1 .OR. nOpca == 4	
		lRet := U_RJCHKSC9(SC5->C5_NUM)
		If lRet
			If RecLock("SC5",.F.)
				SC5->C5_X_BLQ := "N"
				SC5->(MsUnLock())				
			EndIf
		Else
			If RecLock("SC5",.F.)
				SC5->C5_X_BLQ := "S"
				SC5->(MsUnLock())				
			EndIf			
		EndIf		
	EndIf
		         
	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCHKSC9  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por verificar se o pedido possui algum   º±±
±±º          ³tipo de bloqueio.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*-------------------------------*
User Function RJCHKSC9(cNUMPED)   
*-------------------------------*
Local cAliasTMP := GetNextAlias()
Local aAreaTMP  := GetArea()
Local lRet  := .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                        
    dbSelectArea("SC5")
    dbSetOrder(1)
    dbSeek( xFilial("SC5") + cNUMPED )
    If ! Empty(SC5->C5_BLQ)
    	Return (lRet)
	Else
            		
		cQuery := "	SELECT COUNT(*) NUMREG 							"+CHR(10)+CHR(13)
		cQuery += "	FROM " + RetSQLName("SC9") + " 					"+CHR(10)+CHR(13)
		cQuery += "	WHERE C9_FILIAL   = '" + xFilial("SC9") + "'	"+CHR(10)+CHR(13)
		cQuery += "	AND	  C9_PEDIDO   = '" + cNUMPED + "' 			"+CHR(10)+CHR(13)
		cQuery += "	AND	  D_E_L_E_T_  = ' ' 						"+CHR(10)+CHR(13)
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		lFound := (cAliasTMP)->NUMREG != 0
		(cAliasTMP)->(dbCloseArea())
	    
	    If lFound
	    
			cQuery := "	SELECT COUNT(*) NUMREG 										"+CHR(10)+CHR(13)
			cQuery += "	FROM " + RetSQLName("SC9") + " 								"+CHR(10)+CHR(13)
			cQuery += "	WHERE C9_FILIAL   = '" + xFilial("SC9") + "'				"+CHR(10)+CHR(13)
			cQuery += "	AND	  C9_PEDIDO   = '" + cNUMPED + "' 						"+CHR(10)+CHR(13)
			cQuery += "	AND	  C9_NFISCAL  = '"+Space(TAMSX3("C9_NFISCAL")[1])+"' 	"+CHR(10)+CHR(13)
			cQuery += "	AND	  ( C9_BLEST  NOT IN ('  ','10','09')					"+CHR(10)+CHR(13)
			cQuery += "	OR	  	C9_BLCRED NOT IN ('  ','10','09') )					"+CHR(10)+CHR(13)
			cQuery += "	AND	  D_E_L_E_T_  = ' ' 									"+CHR(10)+CHR(13)  
	
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			lRet := (cAliasTMP)->NUMREG == 0
			(cAliasTMP)->(dbCloseArea())
						
		EndIf
		
	EndIf
	
	RestArea(aAreaTMP)
	
Return (lRet)