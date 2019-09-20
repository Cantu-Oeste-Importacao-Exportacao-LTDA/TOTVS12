#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJPCO02    ºAutor  ³Rafael Parma       º Data ³  31/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Contém as validações chamadas em pontos de lançamentos.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------*
User Function RJPCO02( cPTOLAN, cITEM )
*----------------------------------------*
Local lRet 		:= .T. 
Local aRet 		:= {}
Local aAreaTMP 	:= GetArea()   
Local nTOTATU	   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	DO CASE
	
	//DOCUMENTO DE ENTRADA - INCLUSAO DE DOCUMENTO DE ENTRADA - IT 
	CASE cPTOLAN == "000054" .and. cITEM == "01"	
                                                                      
		lRet := GDFIELDGET('D1_RATEIO')#'1'.AND.EMPTY(GDFIELDGET('D1_PEDIDO'))
		
		If lRet
			lRet := POSICIONE("SF4",1,XFILIAL("SF4")+GDFIELDGET('D1_TES'),"F4_DUPLIC")=="S"
		EndIf
		
		//-- Verifica alteração da chave do pedido. --//
		If ! lRet
			If !EMPTY(GDFIELDGET('D1_ITEMPC'))
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("SC7")+GDFIELDGET('D1_PEDIDO')+GDFIELDGET('D1_ITEMPC'))				
					lRet := GDFIELDGET('D1_CONTA') != SC7->C7_CONTA .OR. GDFIELDGET('D1_CC') != SC7->C7_CC .OR. GDFIELDGET('D1_CLVL') != SC7->C7_CLVL							
				EndIf			
			EndIf
		EndIf
		
	//DOCUMENTO DE ENTRADA - INCLUSAO DE DOCUMENTO DE ENTRADA - RA
	CASE cPTOLAN == "000054" .and. cITEM == "09"	
	
		lRet := EMPTY(cRJUPED)
		If lRet
			lRet := POSICIONE("SF4",1,XFILIAL("SF4")+cRJUTES,"F4_DUPLIC")=="S"
		EndIf
		
		//-- Verifica alteração da chave do pedido. --//
		If ! lRet
			If !EMPTY(cRJUIPC)
				dbSelectArea("SC7")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("SC7")+cRJUPED+cRJUIPC)				
					lRet := GDFIELDGET('DE_CONTA') != SC7->C7_CONTA .OR. GDFIELDGET('DE_CC') != SC7->C7_CC .OR. GDFIELDGET('DE_CLVL') != SC7->C7_CLVL							
				EndIf			
			EndIf
		EndIf
		
	//PEDIDO DE COMPRAS - INCLUSAO DE PEDIDO DE COMPRAS - ITENS   				
	CASE cPTOLAN == "000052" .and. cITEM == "01" 	
	
		If Inclui .or. IsInCallStack("A120COPIA")  //Gustavo 17/08 - Copias de pedido
			
			lRet := GDFIELDGET('C7_FLUXO')#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",GDFIELDGET('C7_CONTA')),'CNTA100')//.AND.GDFIELDGET('C7_CC')#'020207002'
			aRet := { lRet, IIF ( lRet, GDFIELDGET('C7_TOTAL'), 0 ) }
			
			RestArea(aAreaTMP)
			Return (aRet)
			
		ElseIf Altera
		
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SC7")+CA120NUM+GDFIELDGET('C7_ITEM'))
				
				lRet := GDFIELDGET('C7_FLUXO')#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",GDFIELDGET('C7_CONTA')),'CNTA100')//.AND.GDFIELDGET('C7_CC')#'020207002'
				
				If lRet
					
					lAltCHAVE := GDFIELDGET('C7_CONTA') != SC7->C7_CONTA .OR. GDFIELDGET('C7_CC') != SC7->C7_CC .OR. GDFIELDGET('C7_CLVL') != SC7->C7_CLVL
					
					If GDFIELDGET('C7_TOTAL') <= SC7->C7_TOTAL .and. ! lAltCHAVE
					
						aRet := { lRet, 0 }
					
					ElseIf GDFIELDGET('C7_TOTAL') > SC7->C7_TOTAL .and. ! lAltCHAVE
					
						aRet := { lRet, GDFIELDGET('C7_TOTAL') - SC7->C7_TOTAL  }
					
					ElseIf lAltCHAVE                                             
					
						aRet := { lRet, GDFIELDGET('C7_TOTAL')   }
					
					EndIf 
				
				Else
					
					aRet := { lRet, 0 }
				
				EndIf
				
			Else

				lRet := GDFIELDGET('C7_FLUXO')#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",GDFIELDGET('C7_CONTA')),'CNTA100')//.AND.GDFIELDGET('C7_CC')#'020207002'
				aRet := { lRet, IIF ( lRet, GDFIELDGET('C7_TOTAL'), 0 ) }			
			
			EndIf
			
			aRet := { lRet, 0 }   //Guilherme 15/06/15 erro nas cópias de pedido
			
			RestArea(aAreaTMP)
			Return (aRet)			
		
		EndIf
		
	//PEDIDO DE COMPRAS COM RATEIO
	CASE cPTOLAN == "000052" .and. cITEM == "08" 	

		nPosPerc := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_PERC"} )
		nPosCta  := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_CONTA"} )
		nPosCC   := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_CC"} )
		nPosCLVL := aScan(aHeader,{|x| AllTrim(x[2]) == "CH_CLVL"} )

	    nPosFlux := aScan(aOrigHeader,{|x| AllTrim(x[2]) == "C7_FLUXO"} )
		nPosTot  := aScan(aOrigHeader,{|x| AllTrim(x[2]) == "C7_TOTAL"} )
		nPosIt   := aScan(aOrigHeader,{|x| AllTrim(x[2]) == "C7_ITEM"} )
		
		If Inclui
			
			lRet := aOrigAcols[nOrigN][nPosFlux]#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",aCols[n][nPosCta]),'CNTA100')
			aRet := { lRet, IIF ( lRet, (aOrigAcols[nOrigN][nPosTot]*acols[n][nPosPerc])/100, 0 ) }
			
			RestArea(aAreaTMP)
			Return (aRet)
			
		ElseIf Altera
		
			dbSelectArea("SCH")
			dbSetOrder(2)
			dbGoTop()
			If dbSeek(xFilial("SCH")+CA120NUM+aOrigAcols[nOrigN][nPosIt])
				
				lRet := aOrigAcols[nOrigN][nPosFlux]#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",aCols[n][nPosCta]),'CNTA100')
				nTotAtu := (aOrigAcols[nOrigN][nPosTot]*acols[n][nPosPerc])/100
				nTotAnt := (SC7->C7_TOTAL*SCH->CH_PERC)/100
				
				If lRet
					
					lAltCHAVE := aCols[n][nPosCta] != SCH->CH_CONTA .OR. aCols[n][nPosCC] != SCH->CH_CC .OR. aCols[n][nPosCLVL] != SCH->CH_CLVL
					
					If nTotAtu <= nTotAnt .and. ! lAltCHAVE
					
						aRet := { lRet, 0 }
					
					ElseIf nTotAtu > nTotAnt .and. ! lAltCHAVE
					
						aRet := { lRet, nTotAtu - nTotAnt  }
					
					ElseIf lAltCHAVE                                             
					
						aRet := { lRet, nTotAtu   }
					
					EndIf 
				
				Else
					
					aRet := { lRet, 0 }
				
				EndIf
				
			Else

				lRet := aOrigAcols[nOrigN][nPosFlux]#'N'.AND.U_RJPCO03(U_RJPCO01("CT1->CT1_X_CO",aCols[n][nPosCta]),'CNTA100')
				aRet := { lRet, IIF ( lRet, nTotAtu, 0 ) }			
			
			EndIf
			
			RestArea(aAreaTMP)
			Return (aRet)			
		
		EndIf
	
	END CASE
	
	//Erros nas cópias de pedidos Guilherme 15/05/15
	/*If Len(aRet) == 0 
		aRet := { lRet, 0 }
	EndIf
	*/
	
	//Erro no Pedido de Compras Protheus 12 21/07/2017
	If Len(aRet) == 0
		If Inclui .And. FUNNAME() == "MATA121" 	
			aRet := { lRet, 1 }
		Endif
	Endif
	
	
	RestArea(aAreaTMP)

Return (IIF(Len(aRet) == 0,lRet,aRet)) //Gustavo 18/06/15 - Problemas documento de entrada com pedidos.