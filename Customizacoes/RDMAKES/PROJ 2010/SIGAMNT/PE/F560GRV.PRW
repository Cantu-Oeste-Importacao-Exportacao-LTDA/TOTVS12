#include "PROTHEUS.CH"
#include "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F560GRV   ºAutor  ³Rafael Parma       º Data ³  25/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. utilizado para gravar entidades contabeis apos inclusao±±
±±º          ³ de movimento no caixinha com DESPESAS direto.Para despesas º±±
±±º          ³ lançadas com a rotina de Prestação de Contas é utilizado o º±±
±±º          ³ PE F560GRV2.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

//Obs:Manter esse PE igual ao PE F560GRV2

*------------------------*
User Function F560GRV()
*------------------------*
Local cCONTA 	:= ""         
Local cNROADIA 	:= ""
Local aArea  	:= GetArea()
Local nRECNO 	:= SEU->(RECNO())   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  
	If !Empty(SEU->EU_CODVEI)
		dbSelectArea("DA3")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("DA3") + SEU->EU_CODVEI )
			If RecLock("SEU",.F.)
				SEU->EU_CLVLDB := DA3->DA3_X_SEGM 
				SEU->EU_ITEMD  := DA3->DA3_X_ITEM 
				SEU->EU_CCD    := DA3->DA3_X_CC   
				SEU->(MsUnLock())
			EndIf
		EndIf
	ElseIf !Empty(SEU->EU_VIAGEM)
		dbSelectArea("DTR")
		dbSetOrder(1)
		dbGoTop() 
		If dbSeek(xFilial("DTR")+SEU->EU_FILORI+SEU->EU_VIAGEM)
			dbSelectArea("DA3")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("DA3") + DTR->DTR_CODVEI )
				If RecLock("SEU",.F.)
					SEU->EU_CLVLDB := DA3->DA3_X_SEGM 
					SEU->EU_CCD    := DA3->DA3_X_CC   
					SEU->(MsUnLock())
				EndIf
			EndIf
		EndIf
	EndIf
	
	
	If !Empty(SEU->EU_CODDES) .and. !Empty(SEU->EU_NROADIA)
		cCONTA 		:= ""
		cNROADIA 	:= SEU->EU_NROADIA
		dbSelectArea("SEU")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SEU") + cNROADIA )	
			cCONTA := SEU->EU_CONTA
		EndIf		           
		SEU->(dbGoTo(nRECNO))
	
		If cCONTA != ""
			dbSelectArea("SEU")
			If RecLock("SEU",.F.)
				SEU->EU_CONTAC := cCONTA
				SEU->(MsUnLock())			
			EndIf	
		EndIf
		
	EndIf
		
	RestArea(aArea)
                        
Return