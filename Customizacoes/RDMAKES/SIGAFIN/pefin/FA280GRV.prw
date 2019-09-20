#INCLUDE "rwmake.ch"
#include "topconn.ch"  

/*Guilherme 20.06.13 para sinalizar os títulos que goram marcados na fatura.
/****************************************************************
** GRAVA O MOTIVO DE BAIXA NOS TÌTULOS QUE ORIGINARAM A FATURA **
*****************************************************************/ 
User Function FA280GRV()
Local cMotBx 	 := "02" // "02 – Pagamento da dívida" 
Local aArea		 := GetArea()  
Local nPosPrf  := aScan(aHeader,{|x| AllTrim(x[2]) == "E1_PREFIXO"})
Local nPosNum  := aScan(aHeader,{|x| AllTrim(x[2]) == "E1_NUM"})
Local nPosPar  := aScan(aHeader,{|x| AllTrim(x[2]) == "E1_PARCELA"})
Local nPosTip  := aScan(aHeader,{|x| AllTrim(x[2]) == "E1_TIPO"})
Local nPosVlr  := aScan(aHeader,{|x| AllTrim(x[2]) == "E1_VLCRUZ"})    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

_Numero := aCols[1, nPosNum]

//verificar campos E1_FATURA para selecionar os títulos...
cSql := "SELECT E1.E1_NUM,E1.E1_PREFIXO,E1.E1_PARCELA,E1.E1_TIPO,E1.E1_FATURA,E1.E1_PEFININ,E1.E1_PEFINMB,E1.E1_SALDO "
cSql += "  FROM " + RetSqlName("SE1")+ " E1  "
cSql += " WHERE E1.D_E_L_E_T_ <> '*' "
cSql += "   AND E1.E1_FILIAL = '"+xFilial("SE2")+"' "
cSql += "   AND E1.E1_FATURA = '"+_Numero+"' "
cSql += "ORDER BY E1.E1_FILIAL,E1.E1_NUM,E1.E1_PARCELA "

TCQUERY cSql NEW ALIAS "TMP2"

While TMP2->(!Eof()) 
	cNum := TMP2->E1_NUM
	cPar := TMP2->E1_PARCELA
	cPfx := TMP2->E1_PREFIXO
	cTpo := TMP2->E1_TIPO
	If !Empty(AllTrim(TMP2->E1_PEFININ)) .AND. Empty(AllTrim(TMP2->E1_PEFINMB)) .AND. (TMP2->E1_SALDO == 0)			
  		DbselectArea("SE1")
  		DbSetOrder(1)
  		If Dbseek(xFilial("SE1")+cPfx+cNum+cPar+cTpo)
	  		SE1->(Reclock("SE1",.F.))
				SE1->E1_PEFINMB := cMotBx	
			  SE1->(MsUnlock())        
			EndIF			  
	Endif   
	
	TMP2->(Dbskip())
End Do

DBCLOSEAREA("TMP2")  

//** Rateio de multi-naturezas sobre fatura.
For nIFAT := 1 to Len(aCols)
	cCODCLI := IIF(Empty(cCliFat),cCli,cCliFat)
	cLOJCLI := IIF(Empty(cLojaFat),cLoja,cLojaFat)
	MsAguarde( {|| fMultiNAT(xFilial("SE1"),aCols[nIFAT,nPosPrf],aCols[nIFAT,nPosNum],aCols[nIFAT,nPosPar],aCols[nIFAT,nPosTip],cCODCLI,cLOJCLI,aCols[nIFAT,nPosVlr]) }, "Rateio de multi-naturezas... Aguarde!")	
Next nIFAT


RestArea(aArea)

Return()


//** Rateio de multi-naturezas sobre fatura.
Static Function fMultiNAT(cFILTIT,cPRFTIT,cNUMTIT,cPARTIT,cTIPTIT,cCLITIT,cLOJTIT,nVLRTIT)

Local aAreaTMP	:= GetArea()
Local cAliasTMP := GetNextAlias()
Local aMULTINAT	:= {}
Local nI, nJ := 0

	cFILTIT := LEFT(cFILTIT,TAMSX3("E1_FILIAL")[1])
	cPRFTIT := LEFT(cPRFTIT,TAMSX3("E1_PREFIXO")[1])
	cNUMTIT := LEFT(cNUMTIT,TAMSX3("E1_NUM")[1])
	cPARTIT := LEFT(cPARTIT,TAMSX3("E1_PARCELA")[1])
	cTIPTIT := LEFT(cTIPTIT,TAMSX3("E1_TIPO")[1])
	cCLITIT := LEFT(cCLITIT,TAMSX3("E1_CLIENTE")[1])
	cLOJTIT := LEFT(cLOJTIT,TAMSX3("E1_LOJA")[1])


	cQuery := "	SELECT		SE1.E1_FILIAL,							"
	cQuery += "				SE1.E1_PREFIXO,							"
	cQuery += "				SE1.E1_NUM,								"
	cQuery += "				SE1.E1_PARCELA,							"
	cQuery += "				SE1.E1_TIPO,							"
	cQuery += "				SE1.E1_CLIENTE,							"
	cQuery += "				SE1.E1_LOJA								"
	cQuery += " FROM 		" + RetSqlName("SE1")+ " SE1			"
	cQuery += " WHERE 		SE1.E1_FILIAL	= '" + cFILTIT + "'		"
	cQuery += " AND			SE1.E1_FATPREF	= '" + cPRFTIT + "'		"
	cQuery += " AND			SE1.E1_FATURA	= '" + cNUMTIT + "'		"
	cQuery += " AND			SE1.E1_TIPOFAT	= '" + cTIPTIT + "'		"
	cQuery += " AND			SE1.D_E_L_E_T_ != '*' 					"
	cQuery += "	ORDER BY	SE1.E1_FILIAL,							"
	cQuery += "				SE1.E1_PREFIXO,							"
	cQuery += "				SE1.E1_NUM,								"
	cQuery += "				SE1.E1_PARCELA,							"
	cQuery += "				SE1.E1_TIPO,							"
	cQuery += "				SE1.E1_CLIENTE,							"
	cQuery += "				SE1.E1_LOJA								"	

	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	
		dbSelectArea("SE1")
		dbSetOrder(2)
		If dbSeek((cAliasTMP)->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))
      		
      		If SE1->E1_MULTNAT != "1"	//--Sem Rateio de Multi-Natureza
				//--Natureza
				If Len(aMULTINAT) == 0
					nPOSNAT := 0
				Else
					nPOSNAT := aScan ( aMULTINAT, { |x| x[1] == SE1->E1_NATUREZ } )
				EndIf
				If nPOSNAT == 0
					aAdd ( aMULTINAT, { SE1->E1_NATUREZ, {}, 0, 0 } )
					nPOSNAT := Len(aMULTINAT)
				EndIf                       
				
				//--Rateio CC/CLVL
				If Len(aMULTINAT[nPOSNAT][02]) == 0
					nPOSRAT := 0                                                  					
				Else                                                              
					nPOSRAT := aScan ( aMULTINAT[nPOSNAT][02], { |x| x[1] == SE1->E1_CCC .and. x[2] == SE1->E1_CLVLCR } )
				EndIf
				If nPOSRAT == 0
					aAdd ( aMULTINAT[nPOSNAT][02], { SE1->E1_CCC, SE1->E1_CLVLCR, 0, 0 } )	
					nPOSRAT := Len(aMULTINAT[nPOSNAT][02])
				EndIf
				aMULTINAT[nPOSNAT][02][nPOSRAT][03] += SE1->E1_VALOR
			 
			 Else	//--Com Rateio Multi-Natureza

				dbSelectArea("SEV")
				dbSetOrder(1)
				If dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
					While SEV->(!EOF()) .AND. 	SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == ;
												SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
							
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
							If dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+SEV->EV_NATUREZ)
								While SEZ->(!EOF()) .AND. 	SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == ;
															SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+SEV->EV_NATUREZ
									
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
		dbSelectArea("SE1")
		dbSetOrder(2)
		dbGoTop()                                                        
		If dbSeek(cFILTIT+cCLITIT+cLOJTIT+cPRFTIT+cNUMTIT+cPARTIT+cTIPTIT)
			If Len(aMULTINAT) == 1 .and. Len(aMULTINAT[Len(aMULTINAT)][02]) == 1
				If RecLock("SE1",.F.)
					SE1->E1_MULTNAT := "2"	//--Não
					SE1->E1_NATUREZ	:= aMULTINAT[01][01]
					SE1->E1_CLVLCR	:= aMULTINAT[01][02][01][02]
					SE1->E1_CCC		:= aMULTINAT[01][02][01][01]
					SE1->(MsUnLock())
				EndIf
			Else
				nTOTSEV := 0			
				nTOTSEZ := 0			
				If RecLock("SE1",.F.)
					SE1->E1_MULTNAT := "1"	//--Sim
					SE1->E1_CLVLCR	:= Space(TAMSX3("E1_CLVLCR")[1])
					SE1->E1_CCC		:= Space(TAMSX3("E1_CCC")[1])
					SE1->(MsUnLock())
				EndIf
				For nI := 1 to Len(aMULTINAT)
					If RecLock("SEV",.T.)
						SEV->EV_FILIAL	:= SE1->E1_FILIAL
						SEV->EV_PREFIXO	:= SE1->E1_PREFIXO
						SEV->EV_NUM		:= SE1->E1_NUM
						SEV->EV_PARCELA	:= SE1->E1_PARCELA
						SEV->EV_TIPO	:= SE1->E1_TIPO
						SEV->EV_CLIFOR	:= SE1->E1_CLIENTE
						SEV->EV_LOJA	:= SE1->E1_LOJA
						SEV->EV_RECPAG	:= "R"
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
										SEZ->EZ_FILIAL	:= SE1->E1_FILIAL
										SEZ->EZ_PREFIXO	:= SE1->E1_PREFIXO
										SEZ->EZ_NUM		:= SE1->E1_NUM
										SEZ->EZ_PARCELA	:= SE1->E1_PARCELA
										SEZ->EZ_TIPO	:= SE1->E1_TIPO
										SEZ->EZ_CLIFOR	:= SE1->E1_CLIENTE
										SEZ->EZ_LOJA	:= SE1->E1_LOJA
										SEZ->EZ_RECPAG	:= "R"
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
	EndIf

	RestArea(aAreaTMP)

Return
