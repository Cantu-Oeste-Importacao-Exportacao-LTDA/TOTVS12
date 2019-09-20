#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN110VLCRO ºAutor  ³Rafael Parma       º Data ³  31/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE utilizado para validar o painel de parcelas geradas do   º±±
±±º          ³cronograma, permitindo ou não a gravação do mesmo.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function CN110VLCRO()
*--------------------------*
Local lRet     := .T.
Local aAreaTMP := GetArea()
Local nOpcao   := ParamIxb[1]
Local aCols    := ParamIxb[2]
Local aHeader  := ParamIxb[3]
Local nPosPARC := aScan( aHeader,{|x| AllTrim(x[2]) == 'CNF_PARCEL'} )
Local nXINDICE := 0
Local cREVISAO := Space(TAMSX3("CNF_REVISA")[1])

Public oCNB_CONTA  := Space(TAMSX3("CNB_CONTA")[1])
Public oCNB_VLUNIT := 0
Public oCNB_REALI  := 0
Public oCNB_X_CC   := Space(TAMSX3("CNB_X_CC")[1])
Public oCNB_X_CLVL := Space(TAMSX3("CNB_X_CLVL")[1])
Public oCNF_PRUMED := ctod("")
Public oCNS_CONTRA := Space(TAMSX3("CNS_CONTRA")[1])
Public oCNS_PARCEL := Space(TAMSX3("CNS_PARCEL")[1])
Public oCNS_ITEM   := Space(TAMSX3("CNS_ITEM")[1])
Public oCNS_SLDQTD := 0
                                                              
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If nOpcao == 3 .or. nOpcao == 4	//Inclusão/Alteração
 
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Validação dos lançamentos                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	
		If !Empty(M->CNF_REVISA) .and. Val(M->CNF_REVISA) > 0
        	nREVISAO := Val(M->CNF_REVISA)-1
            If nREVISAO > 0
            	cREVISAO := STRZero(nREVISAO,TAMSX3("CNF_REVISA")[1])
            EndIf
         EndIf
	
		For nXINDICE := 1 to Len(aCols) 

			//--Cronograma Financeiro Contrato
			dbSelectArea("CNF")
			dbSetOrder(3)
			dbSeek(xFilial("CNF")+M->CNF_CONTRA+M->CNF_REVISA+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])

			//--Cronograma Fisico             
			dbSelectArea("CNS")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(xFilial("CNS")+M->CNF_CONTRA+M->CNF_REVISA+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])
			
			While !CNS->(EOF()) .and. CNS->CNS_FILIAL==xFilial("CNS").and. CNS->CNS_CONTRA==M->CNF_CONTRA .and. CNS->CNS_REVISA==M->CNF_REVISA ;
				.and. CNS->CNS_CRONOG==M->CNF_NUMERO .and. CNS->CNS_PARCEL==aCols[nXINDICE,nPosPARC]
		
				//--Itens das Planilhas Contratos 
				dbSelectArea("CNB")
				dbSetOrder(1)                                                                                 		
				dbGoTop()                                                                                     
				If dbSeek(xFilial("CNB")+M->CNF_CONTRA+M->CNF_REVISA+CNS->CNS_PLANI+CNS->CNS_ITEM)	        	
		        	dbSelectArea("AKI")
		        	dbSetOrder(1)
		        	If dbSeek(xFilial("AKI")+"999008")
		        		//-- Verifica se esta ativo
		        		If AKI->AKI_ATIVO == "LBOK"
		        										
							//-- Popula variáveis da revisão anterior
							nRECCNS  := CNS->(RECNO())
							nRECCNB  := CNB->(RECNO())
							cITEMCNS := CNS->CNS_ITEM
							
							oCNB_CONTA  := Space(TAMSX3("CNB_CONTA")[1])
							oCNB_VLUNIT := 0
							oCNB_REALI  := 0
							oCNB_X_CC   := Space(TAMSX3("CNB_X_CC")[1])
							oCNB_X_CLVL := Space(TAMSX3("CNB_X_CLVL")[1])
							oCNF_PRUMED := ctod("")
							oCNS_CONTRA := Space(TAMSX3("CNS_CONTRA")[1])
							oCNS_PARCEL := Space(TAMSX3("CNS_PARCEL")[1])
							oCNS_ITEM   := Space(TAMSX3("CNS_ITEM")[1])
							oCNS_SLDQTD := 0		
						
				            //-- Revisão anterior
				            If !Empty(M->CNF_REVISA) 
				            	
								//--Cronograma Fisico             
								dbSelectArea("CNS")
								dbSetOrder(1)
								dbGoTop()
								If dbSeek(xFilial("CNS")+M->CNF_CONTRA+cREVISAO+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC]+cITEMCNS)
									//--Itens das Planilhas Contratos 
									dbSelectArea("CNB")
									dbSetOrder(1)                                                                                 		
									dbGoTop()                                                                                     
									If dbSeek(xFilial("CNB")+M->CNF_CONTRA+cREVISAO+CNS->CNS_PLANI+cITEMCNS)	        					
										oCNB_CONTA  := CNB->CNB_CONTA
										oCNB_VLUNIT := CNB->CNB_VLUNIT
										oCNB_REALI  := CNB->CNB_REALI
										oCNB_X_CC   := CNB->CNB_X_CC
										oCNB_X_CLVL := CNB->CNB_X_CLVL
										oCNF_PRUMED := CNF->CNF_PRUMED
										oCNS_CONTRA := CNS->CNS_CONTRA
										oCNS_PARCEL := CNS->CNS_PARCEL
										oCNS_ITEM   := CNS->CNS_ITEM
										oCNS_SLDQTD := CNS->CNS_SLDQTD 																		
									EndIf			
								EndIf
							
							EndIf		
							
							//-- Retorna a revisão atual
							CNS->(dbGoTo(nRECCNS))
							CNB->(dbGoTo(nRECCNB))
		        			
		        			lRet := PcoVldLan("999008","01","CN110VLCRO")
		        		EndIf
		        	EndIf
				EndIf			
				If !lRet
					Exit
				Endif
				CNS->(dbSkip())
			Enddo
			If !lRet
				Exit
			EndIf             	
		Next nXINDICE
                     

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Execução dos lançamentos                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		
		If lRet

            //-- Revisão anterior
            If !Empty(M->CNF_REVISA) 
            		            
				For nXINDICE := 1 to Len(aCols)  
						
					//--Cronograma Financeiro Contrato
					dbSelectArea("CNF")
					dbSetOrder(3)
					dbSeek(xFilial("CNF")+M->CNF_CONTRA+M->CNF_REVISA+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])				
					
					//--Cronograma Fisico             
					dbSelectArea("CNS")
					dbSetOrder(1)
					dbGoTop()
					dbSeek(xFilial("CNS")+M->CNF_CONTRA+cREVISAO+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])
					PCOINILAN("999008")
					While !CNS->(EOF()) .and. CNS->CNS_FILIAL==xFilial("CNS").and. CNS->CNS_CONTRA==M->CNF_CONTRA .and. CNS->CNS_REVISA==cREVISAO ;
						.and. CNS->CNS_CRONOG==M->CNF_NUMERO .and. CNS->CNS_PARCEL==aCols[nXINDICE,nPosPARC]
				
						//--Itens das Planilhas Contratos 
						dbSelectArea("CNB")
						dbSetOrder(1)                                                                                 		
						dbGoTop()                                                                                     
						If dbSeek(xFilial("CNB")+M->CNF_CONTRA+cREVISAO+CNS->CNS_PLANI+CNS->CNS_ITEM)	        	
							PCODETLAN("999008","02","CN110VLCRO")
						EndIf			
						CNS->(dbSkip())
					Enddo
					PCOFINLAN("999008")
	
				Next nXINDICE
			
			EndIf
			
	        //-- Revisão atual
			For nXINDICE := 1 to Len(aCols)

				//--Cronograma Financeiro Contrato
				dbSelectArea("CNF")
				dbSetOrder(3)
				dbSeek(xFilial("CNF")+M->CNF_CONTRA+M->CNF_REVISA+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])
				
				//--Cronograma Fisico             
				dbSelectArea("CNS")
				dbSetOrder(1)
				dbGoTop()
				dbSeek(xFilial("CNS")+M->CNF_CONTRA+M->CNF_REVISA+M->CNF_NUMERO+aCols[nXINDICE,nPosPARC])
				PCOINILAN("999008")
				While !CNS->(EOF()) .and. CNS->CNS_FILIAL==xFilial("CNS").and. CNS->CNS_CONTRA==M->CNF_CONTRA .and. CNS->CNS_REVISA==M->CNF_REVISA ;
					.and. CNS->CNS_CRONOG==M->CNF_NUMERO .and. CNS->CNS_PARCEL==aCols[nXINDICE,nPosPARC]
			
					//--Itens das Planilhas Contratos 
					dbSelectArea("CNB")
					dbSetOrder(1)                                                                                 		
					dbGoTop()                                                                                     
					If dbSeek(xFilial("CNB")+M->CNF_CONTRA+M->CNF_REVISA+CNS->CNS_PLANI+CNS->CNS_ITEM)	        	
						PCODETLAN("999008","03","CN110VLCRO")
					EndIf			
					CNS->(dbSkip())
				Enddo
				PCOFINLAN("999008")

			Next nXINDICE
		
		EndIf
		
	EndIf
	
	RestArea(aAreaTMP)

Return (lRet)
