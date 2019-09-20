#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120ENCMD ºAutor  ³Rafael Parma       º Data ³  01/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado no encerramento da medição, no   º±±
±±º          ³momento em que é gerado o Pedido de Compras.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function CN120ENCMD()
*--------------------------*
Local aAreaTMP := GetArea()
Local cNUMPED  := SC7->C7_NUM
Local lRateio  := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	//--Inclui rateio contábil do contrato aos itens do pedido.
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("SC7")+cNUMPED )
		While !SC7->(EOF()) .and. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cNUMPED
		
			dbSelectArea("CNZ")
			dbSetOrder(2)
			dbGoTop()

//		If dbSeek( xFilial("CNZ")+CN9->CN9_NUMERO+SC7->(C7_CONTREV+C7_MEDICAO+C7_ITEMED) )  Guilherme 02/01/12 - readequar o fonte para ver. atu.
			If dbSeek( xFilial("CNZ")+CN9->CN9_NUMERO+SC7->C7_CONTREV+SC7->C7_MEDICAO+SubSTR(SC7->C7_ITEMED,1,TAMSX3("CNZ_ITCONT")[1]) )
				If CNZ->CNZ_PERC > 0
					lRateio := .T.
//				While !CNZ->(EOF()) .and. CNZ->(CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_ITCONT) == xFilial("CNZ")+CN9->CN9_NUMERO+SC7->(C7_CONTREV+C7_MEDICAO+C7_ITEMED) Guilherme 02/01/12 - readequar o fonte para ver. atu.
					While !CNZ->(EOF()) .and. CNZ->(CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_ITCONT) == xFilial("CNZ")+CN9->CN9_NUMERO+SC7->C7_CONTREV+SC7->C7_MEDICAO+SubSTR(SC7->C7_ITEMED,1,TAMSX3("CNZ_ITCONT")[1])
						If RecLock("SCH",.T.)
							SCH->CH_FILIAL	:= xFilial("SCH")
							SCH->CH_PEDIDO	:= SC7->C7_NUM
							SCH->CH_FORNECE	:= SC7->C7_FORNECE
							SCH->CH_LOJA	:= SC7->C7_LOJA
							SCH->CH_ITEMPD	:= SC7->C7_ITEM
							SCH->CH_ITEM	:= CNZ->CNZ_ITEM
							SCH->CH_PERC	:= CNZ->CNZ_PERC
							SCH->CH_CC		:= CNZ->CNZ_CC
							SCH->CH_CONTA	:= CNZ->CNZ_CONTA
							SCH->CH_ITEMCTA	:= CNZ->CNZ_ITEMCT
							SCH->CH_CLVL	:= CNZ->CNZ_CLVL
							SCH->CH_CUSTO1	:= CNZ->CNZ_VALOR1							
							SCH->(MsUnLock())
						EndIf
						CNZ->(dbSkip())
					Enddo
					If RecLock("SC7",.F.)
						SC7->C7_RATEIO := "1"
						SC7->(MsUnLock())
					EndIf	
				EndIf
				
				dbSelectArea("CNZ")
				dbSetOrder(1)
				dbGoTop()
				dbSeek( xFilial("CNZ")+CN9->CN9_NUMERO )
				While !CNZ->(EOF()) .and. CNZ->(CNZ_FILIAL+CNZ_CONTRA) == xFilial("CNZ")+CN9->CN9_NUMERO
					If RecLock("CNZ",.F.)
						CNZ->CNZ_FORNEC	:= SC7->C7_FORNECE
						CNZ->CNZ_LJFORN	:= SC7->C7_LOJA
						CNZ->(MsUnLock())
					EndIf
					CNZ->(dbSkip())
				Enddo
			EndIf
			If !lRateio
				dbSelectArea('CNB')//Tabela de itens de medição
				dbSetOrder(1)
				dbGoTop() 
				If dbSeek( xFilial('CNB')+SC7->C7_CONTRA+SC7->C7_CONTREV+SC7->C7_PLANILH+STRZERO(VAL(SC7->C7_ITEM),3) )
					dbSelectArea("SC7")
					If RecLock("SC7",.F.)
						SC7->C7_CC      := CNB->CNB_X_CC
						SC7->C7_CONTA   := CNB->CNB_CONTA
						SC7->C7_ITEMCTA := CNB->CNB_X_ITEM    
						SC7->C7_CLVL    := CNB->CNB_X_CLVL
						SC7->(MsUnLock())
					EndIf
				EndIf
			EndIf
			SC7->(dbSkip())						
		Enddo
	EndIf

	
	//--Gravação do número da medição sobre tabela auxiliar.
	If Type("__aRECZ33") != "U"
		If Len(__aRECZ33) > 0
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("SC7")+cNUMPED )		
				For nI := 1 to Len(__aRECZ33)
					dbSelectArea("Z33")
					Z33->(dbGoTo(__aRECZ33[nI]))
					If !Z33->(EOF()) .OR. Z33->(BOF())
				 		If RecLock("Z33",.F.)
							Z33->Z33_MEDICA := SC7->C7_MEDICAO
							Z33->Z33_ITEMED := SC7->C7_ITEMED
				 			Z33->(MsUnLock())                 				 			
				 		EndIf		
					EndIf
				Next nI
			EndIf
		EndIf		
		__aRECZ33 := {}
	EndIf
	
	RestArea(aAreaTMP)
	
Return