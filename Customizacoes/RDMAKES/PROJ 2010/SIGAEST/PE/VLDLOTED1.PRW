#Include 'Protheus.ch'
#Include 'ParmType.ch'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDLOTED1  ºAutor  ³Cleidisson Draszewski º Data ³  23/10/18 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.  ³Validação de condicao de pagamento documento de entrada. Caso  º±±
±±º       ³a cond de pagamento do cadastro de forncedor esteja em branco  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function validaltd1()
Local lRet := .T. 
Local aArea   := GetArea()
Local cLote := ALLTRIM(SB1->B1_RASTRO) 
Local cMsgHtml := ''


DbSelectArea("SB1")
DbSetOrder(1)
dbGoTop()

if   (cLote = 'L')
 		cMsgHtml := '<h1>ATENÇÃO</h1>'
 		cMsgHtml := '<br><br>'
 		cMsgHtml := 'PRODUTO CONTROLA LOTE <br><br><b>**OBRIGATÓRIO PREENCHER CAMPO LOTE** </b>' 
 		//Alert("PRODUTO CONTROLA LOTE. ****OBRIGATÓRIO PREENCHER O CAMPO LOTE***** !!!") 		
 		Alert(cMsgHtml)
        lRet := .T.	
	EndIf 
	
SA2->(MsUnlock())
RestArea(aArea)

Return lRet