#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VRETDES     ºAutor  ³Rafael Parma      º Data ³  24/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o cliente/grupo do cliente possui regra de boni-º±±
±±º          ³ficacao e retorna valor desconto, utilizado no LP 620.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
*--------------------------*
User Function VRETDES() 
*--------------------------*
Local aArea   := GetArea()
Local nRECSD2 := SD2->(RECNO())
Local cCodFil := SF2->F2_FILIAL
Local cCodDoc := SF2->F2_DOC
Local cCodSer := SF2->F2_SERIE
Local cCodCli := SF2->F2_CLIENTE
Local cCodLoj := SF2->F2_LOJA
Local dEmissao:= SF2->F2_EMISSAO
Local cCODBON := ""
Local cTIPDES := ""
Local nTOTBON := 0 
Local nNUMTIT := 0
Local nVALTOT := 0 
Local nTOTDES := 0
Local lFOUNDR := .F.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de regra de bonificação por cliente + loja     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SF2->F2_TIPO $ "D/B"	// Caso seja documento de Devolução/Utiliza fornecedor
		RestArea(aArea)
		Return (0)
	EndIf

	dbSelectArea("SD2")
	dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
		While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj
			//--Valor do desconto
			nTOTDES += SD2->D2_X_DECRE
			cTIPDES := SD2->D2_X_TPDEC
			SD2->(dbSkip())
		Enddo		
	EndIf
	
	If cTIPDES == "C" //--Condicional
		RestArea(aArea)
		Return (0)
	ElseIf cTIPDES == "I" .and. nTOTDES > 0
		RestArea(aArea)
		Return (nTOTDES)
	Else 
		nTOTDES := 0

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de contratos de redes para o cliente ...       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		
		aRet := U_RJCHKCRC("S", cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao)
		If !Empty(aRet[2])
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens da nota fiscal e calcula valor da bonificação      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
				                                                       
			dbSelectArea("SD2")
			dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			dbGoTop()
			If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
				While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj
					//--Percentual de desconto
					nTOTBON += Round( ( SD2->D2_TOTAL * aRet[1] ) / 100, 2 )
					SD2->(dbSkip())
				Enddo		
			EndIf
			
			If nTOTBON != 0
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    
				nNUMTIT := 0
				nVALTOT := 0
				dbSelectArea("SE1")
				dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
				dbGoTop()
				If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
					While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
						nNUMTIT += 1
						nVALTOT += SE1->E1_SALDO
						SE1->(dbSkip())
					Enddo
				EndIf
				
				
				dbSelectArea("SE1")
				dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
				dbGoTop()
				If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
					While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza bonificação sobre os titulos com valor correspondente               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						nTOTDES += Round ( ( nTOTBON * SE1->E1_SALDO ) / nVALTOT, 2 ) 
						SE1->(dbSkip())
					Enddo
				EndIf			
			
			EndIf	
	  
		Else
		
			dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
			dbSetOrder(3)	//Z16_FILIAL+Z16_CODCLI+Z16_LOJCLI
			dbGoTop()
		  	If dbSeek ( xFilial("Z16") + cCodCli + cCodLoj)
			   	While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_CODCLI == cCodCli .and. Z16->Z16_LOJCLI == cCodLoj	    	    
			    		If Z16->Z16_ATIVO == "S"
			    			cCODBON := Z16->Z16_CODIGO
			    			lFOUNDR := .T.
			    			Exit
			    		EndIf	    			
			   		Z16->(dbSkip())
			   	Enddo	    	
		 	ElseIf dbSeek ( xFilial("Z16") + cCodCli )
		    	While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_CODCLI == cCodCli
		    	    If !Empty(Z16->Z16_LOJCLI) .and. Z16->Z16_LOJCLI != cCodLoj
		    	    	Z16->(dbSkip())
		    	    	Loop
		    	    EndIf
		    		If Z16->Z16_ATIVO == "S"
		    			cCODBON := Z16->Z16_CODIGO
		    			lFOUNDR := .T.
		    			Exit
		    		EndIf
		    		Z16->(dbSkip())
		    	Enddo    
			EndIf
		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica a existência de contrato para o grupo de cliente                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
		    
		 	If ! lFOUNDR 	    
				        
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona sobre cadastro de cliente                            ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek ( xFilial("SA1") + cCodCli + cCodLoj )
		   		If !Empty(SA1->A1_GRPVEN)
				    	
					dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
					dbSetOrder(2)	//Z16_FILIAL+Z16_GRPCLI
					dbGoTop()
				    If dbSeek ( xFilial("Z16") + SA1->A1_GRPVEN )
				    	While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_GRPCLI == SA1->A1_GRPVEN
				    	    
				    		If Z16->Z16_ATIVO == "S"
				    			cCODBON := Z16->Z16_CODIGO
				    			lFOUNDR := .T.
				    			Exit
				    		EndIf
				    				    			
				    		Z16->(dbSkip())
				    	Enddo    	
				    EndIf
			    EndIf	 
			       
			EndIf
		
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se encontrou a regra de bonificação              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
		    
		 If lFOUNDR
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se regra ativa e dentro do intervalo de datas    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
				dbSetOrder(1)	//Z16_FILIAL+Z16_CODIGO 
				dbGoTop()
			  	dbSeek ( xFilial("Z16") + cCODBON )	
		    	If Z16->Z16_ATIVO == "S" .and. SF2->F2_EMISSAO >= Z16->Z16_DATINI .and. SF2->F2_EMISSAO <= Z16->Z16_DATFIN  
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens da nota fiscal e calcula valor da bonificação      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
				                                                       
					dbSelectArea("SD2")
					dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					dbGoTop()
					If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
						While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj
							
							dbSelectArea("Z17")	//ITENS BONIFICACOES PEDIDOS
							dbSetOrder(3)	//Z17_FILIAL+Z17_CODIGO+Z17_CODPRD 
							dbGoTop()
							If dbSeek ( xFilial("Z17") + cCODBON + SD2->D2_COD ) 
								nTOTBON += Round( ( SD2->D2_TOTAL * Z17_PRCBON ) / 100, 2 )
							Else
								dbSelectArea("Z17")	//ITENS BONIFICACOES PEDIDOS
								dbSetOrder(2)	//Z17_FILIAL+Z17_CODIGO+Z17_CODGRP
								dbGoTop()
								If dbSeek ( xFilial("Z17") + cCODBON + SD2->D2_GRUPO ) 
									nTOTBON += Round( ( SD2->D2_TOTAL * Z17_PRCBON ) / 100, 2 )
								Else
									nTAMGRP := TAMSX3("B1_GRUPO")[1] - 2
									If dbSeek ( xFilial("Z17") + cCODBON + SUBSTR(SD2->D2_GRUPO,1,2) + Space(nTAMGRP) , .T. )
										nTOTBON += Round( ( SD2->D2_TOTAL * Z17_PRCBON ) / 100, 2 )
									EndIf
								EndIf
							EndIf
							
							SD2->(dbSkip())
						Enddo		
					EndIf
					
					If nTOTBON != 0
			
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							    
						nNUMTIT := 0
						nVALTOT := 0
						dbSelectArea("SE1")
						dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
						dbGoTop()
						If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
							While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
								nNUMTIT += 1
								nVALTOT += SE1->E1_VALOR
								SE1->(dbSkip())
							Enddo
						EndIf
						
					
						
						dbSelectArea("SE1")
						dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
						dbGoTop()
						If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
							While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza bonificação sobre os titulos com valor correspondente               ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If Z16->Z16_REGRA == "I"
									nTOTDES += Round ( ( nTOTBON * SE1->E1_VALOR ) / nVALTOT, 2 ) 
								EndIf
								SE1->(dbSkip())
							Enddo
						EndIf
					EndIf
					
				EndIf
			EndIf
		Endif
	
	EndIf
	
	dbSelectArea("SD2")
	dbGoTo(nRECSD2)
		
	RestArea(aArea)

Return (nTOTDES)     




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VRETBON     ºAutor  ³Rafael Parma      º Data ³  24/08/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o cliente/grupo do cliente possui regra de boni-º±±
±±º          ³ficacao incondicional e retorna valor logico.               º±±
±±º          ³Utilizado no LP 650/061.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
*--------------------------*
User Function VRETBON() 
*--------------------------*
Local aArea   := GetArea()
Local nRECSD1 := SD1->(RECNO())
Local cCodFil := SD1->D1_FILIAL
Local cCodDoc := SD1->D1_DOC
Local cCodSer := SD1->D1_SERIE
Local cCodCli := SD1->D1_FORNECE
Local cCodLoj := SD1->D1_LOJA
Local dEmissao:= SD1->D1_EMISSAO
Local cCODBON := ""
Local lFOUNDR := .F.
Local lINCOND := .F.   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de regra de bonificação por cliente + loja     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SD1->D1_TIPO != "D"	// Caso seja documento diferente de Devolução
		Return (lINCOND)
	EndIf

	dEmiSAIDA := Posicione("SD2", 3, SD1->D1_FILIAL + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI, "D2_EMISSAO")
	If !Empty(dEmiSAIDA)
		dEmissao := dEmiSAIDA
	EndIf

	dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
	dbSetOrder(3)	//Z16_FILIAL+Z16_CODCLI+Z16_LOJCLI
	dbGoTop()
	If dbSeek ( xFilial("Z16") + cCodCli + cCodLoj)
   		While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_CODCLI == cCodCli .and. Z16->Z16_LOJCLI == cCodLoj	    	    
    		If Z16->Z16_ATIVO == "S"
    			cCODBON := Z16->Z16_CODIGO
    			lFOUNDR := .T.
    			Exit
    		EndIf	    			
   			Z16->(dbSkip())
   		Enddo	    	
	ElseIf dbSeek ( xFilial("Z16") + cCodCli )
 		While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_CODCLI == cCodCli
    		If !Empty(Z16->Z16_LOJCLI) .and. Z16->Z16_LOJCLI != cCodLoj
    	    	Z16->(dbSkip())
    	    	Loop
    	 	EndIf
    		If Z16->Z16_ATIVO == "S"
    			cCODBON := Z16->Z16_CODIGO
    			lFOUNDR := .T.
    			Exit
    		EndIf
    		Z16->(dbSkip())
    	Enddo            
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o grupo de cliente                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek ( xFilial("SA1") + cCodCli + cCodLoj )

   	If !Empty(SA1->A1_GRPVEN)      
		dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
		dbSetOrder(2)	//Z16_FILIAL+Z16_GRPCLI
		dbGoTop()
	    If dbSeek ( xFilial("Z16") + SA1->A1_GRPVEN )
	    	While !Z16->(EOF()) .and. Z16->Z16_FILIAL == xFilial("Z16") .and. Z16->Z16_GRPCLI == SA1->A1_GRPVEN
	    		If Z16->Z16_ATIVO == "S"
	    			cCODBON := Z16->Z16_CODIGO
	    			lFOUNDR := .T.
	    			Exit
	    		EndIf
	    		Z16->(dbSkip())
	    	Enddo    	
	    EndIf            
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se encontrou a regra de bonificação              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
    
	 If lFOUNDR
	                                   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se regra ativa e dentro do intervalo de datas    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
		dbSetOrder(1)	//Z16_FILIAL+Z16_CODIGO 
		dbGoTop()
		dbSeek ( xFilial("Z16") + cCODBON )	                                                          
		If Z16->Z16_ATIVO == "S" .and. dEmissao >= Z16->Z16_DATINI .and. dEmissao <= Z16->Z16_DATFIN  
			If Z16->Z16_REGRA != "C"
				lINCOND := .T.
			EndIf        
		EndIf
	EndIf
	
	dbSelectArea("SD1")
	dbGoTo(nRECSD1)
	
	RestArea(aArea)                

Return (lINCOND)