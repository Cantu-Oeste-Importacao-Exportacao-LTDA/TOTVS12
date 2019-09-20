#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN100VST   ºAutor  ³Rafael Parma       º Data ³  01/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE executado na alteração da situação do contrato. Executa  º±±
±±º          ³validação de orçamento (PCO) na ativação do contrato.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function CN100VST()
*--------------------------*
Local lRet     := .T.
Local cSITUACA := ParamIxb[1]
Local aAreaTMP := GetArea()
Local aPLANILH := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If cSITUACA == "05"	//Vigente                     
	
		//--Cronograma Financeiro Contrato
		dbSelectArea("CNF")
		dbSetOrder(2)
		dbSeek(xFilial("CNF")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
		While !CNF->(EOF()) .and. CNF->(CNF_FILIAL+CNF_CONTRA+CNF_REVISA) == xFilial("CNF")+CN9->CN9_NUMERO+CN9->CN9_REVISA
			
			//--Cronograma Fisico             
			dbSelectArea("CNS")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("CNS")+CNF->(CNF_CONTRA+CNF_REVISA+CNF_NUMERO+CNF_PARCEL) )
			While !CNS->(EOF()) .and. CNS->CNS_FILIAL==xFilial("CNS").and. CNS->CNS_CONTRA==CNF->CNF_CONTRA .and. CNS->CNS_REVISA==CNF->CNF_REVISA ;
				.and. CNS->CNS_CRONOG == CNF->CNF_NUMERO .and. CNS->CNS_PARCEL == CNF->CNF_PARCEL
		
				//--Itens das Planilhas Contratos 
				dbSelectArea("CNB")
				dbSetOrder(1)                                                                                 		
				dbGoTop()                                                                                     
				If dbSeek(xFilial("CNB")+CNF->CNF_CONTRA+CNF->CNF_REVISA+CNS->CNS_PLANI+CNS->CNS_ITEM)	        	
		        	lRet := PcoVldLan("999009","01","CN100VST")
				EndIf			
				If !lRet
					Exit
				Endif
				CNS->(dbSkip())
			Enddo
			If !lRet
				Exit
			EndIf             	
			CNF->(dbSkip())
		Enddo
		
	EndIf
		
	If cSITUACA $ "01/05/08" .and. lRet 	// Cancelar/Vigente/Finalizar
	
		//--Cronograma Financeiro Contrato
		dbSelectArea("CNF")
		dbSetOrder(2)
		dbSeek(xFilial("CNF")+CN9->CN9_NUMERO+CN9->CN9_REVISA)
		While !CNF->(EOF()) .and. CNF->(CNF_FILIAL+CNF_CONTRA+CNF_REVISA) == xFilial("CNF")+CN9->CN9_NUMERO+CN9->CN9_REVISA
			
			//--Cronograma Fisico             
			dbSelectArea("CNS")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("CNS")+CNF->(CNF_CONTRA+CNF_REVISA+CNF_NUMERO+CNF_PARCEL) )
			PCOINILAN("999009")
			While !CNS->(EOF()) .and. CNS->CNS_FILIAL==xFilial("CNS").and. CNS->CNS_CONTRA==CNF->CNF_CONTRA .and. CNS->CNS_REVISA==CNF->CNF_REVISA ;
				.and. CNS->CNS_CRONOG == CNF->CNF_NUMERO .and. CNS->CNS_PARCEL == CNF->CNF_PARCEL		
				//--Itens das Planilhas Contratos 
				dbSelectArea("CNB")
				dbSetOrder(1)                                                                                 		
				dbGoTop()                                                                                     
				If dbSeek(xFilial("CNB")+CNF->CNF_CONTRA+CNF->CNF_REVISA+CNS->CNS_PLANI+CNS->CNS_ITEM)	        	
		        	If cSITUACA == "05"
		        		PCODETLAN("999009","01","CN100VST")
		        	Else
		        		PCODETLAN("999009","02","CN100VST")
		        	EndIf
				EndIf			
				CNS->(dbSkip())
			Enddo
			PCOFINLAN("999009")
			CNF->(dbSkip())
		Enddo
	
	EndIf
	      
	
	If lRet
		dbSelectArea("CN1")
		dbSetOrder(1)
		If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)		
			If CN1->CN1_CTRFIX == "2"
				If cSITUACA == "05"	//--Vigente                     
					U_RJUGCT01(.F.,.T.)
				ElseIf cSITUACA $ "01/08" //-- Cancelar/Finalizar
					U_RJUGCT1E()
				EndIf                                   
			EndIf
		EndIf
	EndIf
			
	
	RestArea(aAreaTMP)

Return (lRet)
