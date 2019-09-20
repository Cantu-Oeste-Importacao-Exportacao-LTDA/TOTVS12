#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA290       ºAutor  ³Rafael Parma      º Data ³  30/05/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE sobre faturas a pagar, executado durante a gravação dos  º±±
±±º          ³dados da fatura no SE2 e antes da contabilização.           º±±
±±º          ³Grava dados complementares (Centro Custo/Segmento).         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-------------------------------*
User Function FA290()
*-------------------------------*
Local aAreaTMP  := GetArea()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName()) 

	MsAguarde( {|| fMultiNAT(SE2->E2_FILIAL,SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,SE2->E2_TIPO,SE2->E2_FORNECE,SE2->E2_LOJA,SE2->E2_VALOR) }, "Rateio de multi-naturezas... Aguarde!")	
	
	RestArea(aAreaTMP)

Return



//** Rateio de multi-naturezas sobre fatura.
Static Function fMultiNAT(cFILTIT,cPRFTIT,cNUMTIT,cPARTIT,cTIPTIT,cFORTIT,cLOJTIT,nVLRTIT)

Local aAreaTMP	:= GetArea()
Local cAliasTMP := GetNextAlias()
Local aMULTINAT	:= {}
Local nI, nJ := 0

	cFILTIT := LEFT(cFILTIT,TAMSX3("E2_FILIAL")[1])
	cPRFTIT := LEFT(cPRFTIT,TAMSX3("E2_PREFIXO")[1])
	cNUMTIT := LEFT(cNUMTIT,TAMSX3("E2_NUM")[1])
	cPARTIT := LEFT(cPARTIT,TAMSX3("E2_PARCELA")[1])
	cTIPTIT := LEFT(cTIPTIT,TAMSX3("E2_TIPO")[1])
	cFORTIT := LEFT(cFORTIT,TAMSX3("E2_FORNECE")[1])
	cLOJTIT := LEFT(cLOJTIT,TAMSX3("E2_LOJA")[1])

    
	cQuery := "	SELECT		SE2.E2_FILIAL,							"
	cQuery += "				SE2.E2_PREFIXO,							"
	cQuery += "				SE2.E2_NUM,								"
	cQuery += "				SE2.E2_PARCELA,							"
	cQuery += "				SE2.E2_TIPO,							"
	cQuery += "				SE2.E2_FORNECE,							"
	cQuery += "				SE2.E2_LOJA,							"
	cQuery += "				SE2.E2_MULTNAT,							"
	cQuery += "				SE2.E2_NATUREZ,							"
	cQuery += "				SE2.E2_CCD,								"		
	cQuery += "				SE2.E2_CLVLDB,							"
	cQuery += "				SE2.E2_VALOR							"		
	cQuery += " FROM 		" + RetSqlName("SE2")+ " SE2			"
	cQuery += " WHERE 		SE2.E2_FILIAL	= '" + cFILTIT + "'		"
	cQuery += " AND			SE2.E2_FATPREF	= '" + cPRFTIT + "'		"
	cQuery += " AND			SE2.E2_FATURA	= '" + cNUMTIT + "'		"
	cQuery += " AND			SE2.E2_TIPOFAT	= '" + cTIPTIT + "'		"
	cQuery += " AND			SE2.D_E_L_E_T_ != '*' 					"
	cQuery += "	ORDER BY	SE2.E2_FILIAL,							"
	cQuery += "				SE2.E2_PREFIXO,							"
	cQuery += "				SE2.E2_NUM,								"
	cQuery += "				SE2.E2_PARCELA,							"
	cQuery += "				SE2.E2_TIPO,							"
	cQuery += "				SE2.E2_FORNECE,							"
	cQuery += "				SE2.E2_LOJA								"	

	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
 		If (cAliasTMP)->E2_MULTNAT != "1"	//--Sem Rateio de Multi-Natureza
			//--Natureza
			If Len(aMULTINAT) == 0
				nPOSNAT := 0
			Else
				nPOSNAT := aScan ( aMULTINAT, { |x| x[1] == (cAliasTMP)->E2_NATUREZ } )
			EndIf
			If nPOSNAT == 0
				aAdd ( aMULTINAT, { (cAliasTMP)->E2_NATUREZ, {}, 0, 0 } )
				nPOSNAT := Len(aMULTINAT)
			EndIf                       
			
			//--Rateio CC/CLVL
			If Len(aMULTINAT[nPOSNAT][02]) == 0
				nPOSRAT := 0                                                  					
			Else                                                              
				nPOSRAT := aScan ( aMULTINAT[nPOSNAT][02], { |x| x[1] == (cAliasTMP)->E2_CCD .and. x[2] == (cAliasTMP)->E2_CLVLDB } )
			EndIf
			If nPOSRAT == 0
				aAdd ( aMULTINAT[nPOSNAT][02], { (cAliasTMP)->E2_CCD, (cAliasTMP)->E2_CLVLDB, 0, 0 } )	
				nPOSRAT := Len(aMULTINAT[nPOSNAT][02])
			EndIf
			aMULTINAT[nPOSNAT][02][nPOSRAT][03] += (cAliasTMP)->E2_VALOR
		 
		 Else	//--Com Rateio Multi-Natureza

			dbSelectArea("SEV")
			dbSetOrder(1)
			If dbSeek((cAliasTMP)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
				While SEV->(!EOF()) .AND. 	SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == ;
											(cAliasTMP)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
						
					If SEV->EV_RATEICC != "1"	//--Sem Rateio de CC/CLVL

						//--Natureza
						If Len(aMULTINAT) == 0
							nPOSNAT := 0
						Else
							nPOSNAT := aScan ( aMULTINAT, { |x| x[1] == SEV->EV_NATUREZ } )
						EndIf
						If nPOSNAT == 0
							aAdd ( aMULTINAT, { SEV->EV_NATUREZ, {}, 0, 0 } )
							nPOSNAT := Len(aMULTINAT)
						EndIf                       
						
						//--Rateio CC/CLVL
						If Len(aMULTINAT[nPOSNAT][02]) == 0
							nPOSRAT := 0                                                  					
						Else                                                              
							nPOSRAT := aScan ( aMULTINAT[nPOSNAT][02], { |x| x[1] == "" .and. x[2] == "" } )
						EndIf
						If nPOSRAT == 0
							aAdd ( aMULTINAT[nPOSNAT][02], { "", "", 0, 0 } )	
							nPOSRAT := Len(aMULTINAT[nPOSNAT][02])
						EndIf
						aMULTINAT[nPOSNAT][02][nPOSRAT][03] += SEV->EV_VALOR
		
					Else	//--Com Rateio de CC/CLVL

						dbSelectArea("SEZ")
						dbSetOrder(1)	//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
						If dbSeek((cAliasTMP)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+SEV->EV_NATUREZ)
							While SEZ->(!EOF()) .AND. 	SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == ;
														(cAliasTMP)->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+SEV->EV_NATUREZ
								
								//--Natureza
								If Len(aMULTINAT) == 0
									nPOSNAT := 0
								Else
									nPOSNAT := aScan ( aMULTINAT, { |x| x[1] == SEV->EV_NATUREZ } )
								EndIf
								If nPOSNAT == 0
									aAdd ( aMULTINAT, { SEV->EV_NATUREZ, {}, 0, 0 } )
									nPOSNAT := Len(aMULTINAT)
								EndIf                       
								
								//--Rateio CC/CLVL
								If Len(aMULTINAT[nPOSNAT][02]) == 0
									nPOSRAT := 0                                                  					
								Else                                                              
									nPOSRAT := aScan ( aMULTINAT[nPOSNAT][02], { |x| x[1] == SEZ->EZ_CCUSTO .and. x[2] == SEZ->EZ_CLVL } )
								EndIf
								If nPOSRAT == 0
									aAdd ( aMULTINAT[nPOSNAT][02], { SEZ->EZ_CCUSTO, SEZ->EZ_CLVL, 0, 0 } )	
									nPOSRAT := Len(aMULTINAT[nPOSNAT][02])
								EndIf
								aMULTINAT[nPOSNAT][02][nPOSRAT][03] += SEZ->EZ_VALOR

								SEZ->(dbSkip())
							Enddo
						EndIf
						
					EndIf
					SEV->(dbSkip())
				Enddo
			EndIf				 
		 EndIf
			
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	If Len(aMULTINAT) > 0
		//--Calcula o valor total por natureza
		nTOTFAT := 0
		For nI := 1 to Len(aMULTINAT)
			nTOTNAT := 0
			If Len(aMULTINAT[nI][02]) > 0
				For nJ := 1 to Len(aMULTINAT[nI][02])
					nTOTNAT += aMULTINAT[nI][02][nJ][03]
				Next nJ
				//--Calcula o percentual por CC/CLVL
				For nJ := 1 to Len(aMULTINAT[nI][02])
					aMULTINAT[nI][02][nJ][04] := Round( (aMULTINAT[nI][02][nJ][03]*100)/nTOTNAT, 2)
				Next nJ
			EndIf         
			nTOTFAT += nTOTNAT
			aMULTINAT[nI][03] := nTOTNAT
		Next nI
		//--Calcula o percentual por natureza
		For nI := 1 to Len(aMULTINAT)
			aMULTINAT[nI][04] := Round( (aMULTINAT[nI][03]*100)/nTOTFAT, 2)
		Next nI

		//Redefine os percentuais de acordo com o valor da fatura
		If nTOTFAT != nVLRTIT
			nTOTFIN := 0
			nPRCMLT := 1
			If nTOTFAT > nVLRTIT
				nPRCMLT := Round( (100-((nVLRTIT*100)/nTOTFAT))*-1, 2)
			Else
				nPRCMLT := Round( 100-((nVLRTIT*100)/nTOTFAT), 2)
			EndIf
			
			For nI := 1 to Len(aMULTINAT)
				nTOTNAT := 0
				If Len(aMULTINAT[nI][02]) > 0
					For nJ := 1 to Len(aMULTINAT[nI][02])
						aMULTINAT[nI][02][nJ][03] := Round ( aMULTINAT[nI][02][nJ][03] + ((aMULTINAT[nI][02][nJ][03]*nPRCMLT)/100), 2)
						nTOTNAT += aMULTINAT[nI][02][nJ][03]
					Next nJ
					//--Define percentual por CC/CLVL
					For nJ := 1 to Len(aMULTINAT[nI][02])
						aMULTINAT[nI][02][nJ][04] := Round( (aMULTINAT[nI][02][nJ][03]*100)/nTOTNAT, 2)
					Next nJ
				EndIf         
				nTOTFIN += nTOTNAT
				aMULTINAT[nI][03] := nTOTNAT
			Next nI
			//--Redefine o percentual por natureza
			For nI := 1 to Len(aMULTINAT)
				aMULTINAT[nI][04] := Round( (aMULTINAT[nI][03]*100)/nTOTFIN, 2)
			Next nI
		EndIf
		                 
		//--Atualização das tabelas de rateio de multi-naturezas.
		If Len(aMULTINAT) == 1 .and. Len(aMULTINAT[Len(aMULTINAT)][02]) == 1
			If RecLock("SE2",.F.)
				SE2->E2_MULTNAT := "2"	//--Não
				SE2->E2_NATUREZ	:= aMULTINAT[01][01]
				SE2->E2_CLVLDB	:= aMULTINAT[01][02][01][02]
				SE2->E2_CCD		:= aMULTINAT[01][02][01][01]
				SE2->(MsUnLock())
			EndIf
		Else          
			nTOTSEV := 0			
			nTOTSEZ := 0
			If RecLock("SE2",.F.)
				SE2->E2_MULTNAT := "1"	//--Sim
				SE2->E2_CLVLDB	:= Space(TAMSX3("E2_CLVLDB")[1])
				SE2->E2_CCD		:= Space(TAMSX3("E2_CCD")[1])
				SE2->(MsUnLock())
			EndIf
			For nI := 1 to Len(aMULTINAT)
				If RecLock("SEV",.T.)
					SEV->EV_FILIAL	:= SE2->E2_FILIAL
					SEV->EV_PREFIXO	:= SE2->E2_PREFIXO
					SEV->EV_NUM		:= SE2->E2_NUM
					SEV->EV_PARCELA	:= SE2->E2_PARCELA
					SEV->EV_TIPO	:= SE2->E2_TIPO
					SEV->EV_CLIFOR	:= SE2->E2_FORNECE
					SEV->EV_LOJA	:= SE2->E2_LOJA
					SEV->EV_RECPAG	:= "P"
					SEV->EV_IDENT	:= "1"
				  	SEV->EV_NATUREZ	:= aMULTINAT[nI][01]
				  	SEV->EV_PERC	:= aMULTINAT[nI][04]/100
				  	SEV->EV_VALOR	:= aMULTINAT[nI][03]				  	
				  	nTOTSEV			+= Round(aMULTINAT[nI][03],2)
					If Len(aMULTINAT[nI][02]) == 0
						SEV->EV_RATEICC	:= "2"
						SEV->(MsUnLock())
					Else
						If Len(aMULTINAT[nI][02]) == 1 .AND. Empty(aMULTINAT[nI][02][01][01])
							SEV->EV_RATEICC	:= "2"
							SEV->(MsUnLock())
						Else															
							SEV->EV_RATEICC	:= "1"
							SEV->(MsUnLock())               							
							For nJ := 1 to Len(aMULTINAT[nI][02])
								If RecLock("SEZ",.T.)
									SEZ->EZ_FILIAL	:= SE2->E2_FILIAL
									SEZ->EZ_PREFIXO	:= SE2->E2_PREFIXO
									SEZ->EZ_NUM		:= SE2->E2_NUM
									SEZ->EZ_PARCELA	:= SE2->E2_PARCELA
									SEZ->EZ_TIPO	:= SE2->E2_TIPO
									SEZ->EZ_CLIFOR	:= SE2->E2_FORNECE
									SEZ->EZ_LOJA	:= SE2->E2_LOJA
									SEZ->EZ_RECPAG	:= "P"
									SEZ->EZ_IDENT	:= "1"
								  	SEZ->EZ_NATUREZ	:= aMULTINAT[nI][01]
								  	SEZ->EZ_CCUSTO	:= aMULTINAT[nI][02][nJ][01]
								  	SEZ->EZ_CLVL	:= aMULTINAT[nI][02][nJ][02]
								  	SEZ->EZ_PERC	:= aMULTINAT[nI][02][nJ][04]/100
								  	SEZ->EZ_VALOR	:= aMULTINAT[nI][02][nJ][03]
								  	nTOTSEZ 		+= aMULTINAT[nI][02][nJ][03]								  	
								  	//--Ajuste de arredondamento
								  	If nI == Len(aMULTINAT) .and. nJ == Len(aMULTINAT[nI][02]) .and. Round(nTOTSEZ,2) != Round(nVLRTIT,2)
								  		nVLRDIF := Round(nVLRTIT,2) - Round(nTOTSEZ,2)
								  		SEZ->EZ_VALOR += nVLRDIF
								  	EndIf								  	
								  	SEZ->(MsUnLock())
								 EndIf
							Next nJ
						EndIf					
					EndIf    
					//--Ajuste de arredondamento
					If nI == Len(aMULTINAT) .and. Round(nTOTSEV,2) != Round(nVLRTIT,2)
						nVLRDIF := Round(nVLRTIT,2) - Round(nTOTSEV,2)
						If RecLock("SEV",.F.)
							SEV->EV_VALOR += nVLRDIF
							SEV->(MsUnLock())
						EndIf
					EndIf
					
					
				EndIf
			Next nI
		EndIf		
	EndIf

	RestArea(aAreaTMP)

Return
