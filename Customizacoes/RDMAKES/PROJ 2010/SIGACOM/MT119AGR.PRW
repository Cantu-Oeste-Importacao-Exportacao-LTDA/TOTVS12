#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT119AGR   ºAutor  ³TOTVS CASCAVEL     º Data ³  27/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a inclusão do documento de º±±
±±º          ³conhecimento de importação.                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------*
User Function MT119AGR()
*----------------------------*
Local aAreaTMP := GetArea()           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	// Alimenta classe de valor sobre os títulos	
	MsAguarde( {|| fUpdCLVL() }, "Atualizando classe de valor... Aguarde!")
	MsAguarde( {|| U_fAtuImp(cNFiscal, cSerie, cA100For, cLoja) }, "Atualizando títulos de impostos... Aguarde!")	 	 
	
	
	RestArea(aAreaTMP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdCLVL   ºAutor  ³TOTVS CASCAVEL     º Data ³  27/02/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualiza campo classe de valor sobre os títulos do documento.±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fUpdCLVL()
*----------------------------*
Local aAreaTMP := GetArea()
Local nTOTAL := 0
Local nVSEST := 0
Local aDADOS := {}

	Begin Transaction
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera as classes de valores do documento.                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
		
		dbSelectArea("SD1")
		dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM	
		dbGoTop()
		If dbSeek( xFilial("SD1") + cNFiscal + cSerie + cA100For + cLoja )
			While !SD1->(EOF()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == xFilial("SD1")+cNFiscal+cSerie+cA100For+cLoja
				If ! Empty(SD1->D1_CLVL)
					nPOS := aScan ( aDADOS, {|x| x[1] == SD1->D1_CLVL } )
					If nPOS == 0
						aAdd ( aDADOS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_TOTAL, 0 } )
					Else
						aDADOS[nPOS,03] += SD1->D1_TOTAL
					EndIf
					nTOTAL += SD1->D1_TOTAL
				EndIf
				nVSEST += SD1->D1_VALSES
				SD1->(dbSkip())
			Enddo
		EndIf                           
		
		
		//--Grava valor do sest/senat dos itens em campo customizado no cabeçalho.
		If nVSEST > 0
			cQuery := " UPDATE " + RetSQLName("SF1") + " SET F1_X_SEST = "+cValToChar(nVSEST)
			cQuery += " WHERE	F1_FILIAL	= '"+xFilial("SF1")+"'	"
			cQuery += " AND		F1_DOC		= '"+cNFiscal+"'		"
			cQuery += " AND		F1_SERIE	= '"+cSerie+"'			"
			cQuery += " AND		F1_FORNECE	= '"+cA100For+"'		"
			cQuery += " AND		F1_LOJA		= '"+cLoja+"'  			"
			TCSQLEXEC(cQuery)	
		EndIf
		
		
	
		If Len(aDADOS) > 0                         
			//-- Define os percentuais para cada segmento no rateio.
			If Len(aDADOS) > 1 .and. nTOTAL > 0
				For nI := 1 to Len(aDADOS)
					nPERC := Round(( aDADOS[nI,03] * 100 ) / nTOTAL, 2)
					aDADOS[nI,04] := nPERC
				Next nI
			EndIf
			
			//-- Popula títulos com segmentos/centros de custo do documento de entrada.
			dbSelectArea("SE2")
			dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SE2")+cA100For+cLoja+cSerie+cNFiscal )
				While ! SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM	== ;
						xFilial("SE2")+cA100For+cLoja+cSerie+cNFiscal
										
					If Len(aDADOS) == 1
						If RecLock("SE2",.F.)
							SE2->E2_CLVLDB := aDADOS[01,01]
							SE2->E2_CCD    := aDADOS[01,02]
							SE2->(MsUnLock())							
						EndIf
					EndIf
					SE2->(dbSkip())
				Enddo
			EndIf
		EndIf
		
		//-- Atualização tabela SEZ - Distrib de Naturezas em CC --//
		dbSelectArea("SDE")
		dbSetOrder(1)	//DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA+DE_ITEMNF+DE_ITEM
		dbGoTop()
		If dbSeek ( xFilial("SDE")+cNFiscal+cSerie+cA100For+cLoja )	
			While !SDE->(EOF()) .and. SDE->(DE_FILIAL+DE_DOC+DE_SERIE+DE_FORNECE+DE_LOJA) == xFilial("SDE")+cNFiscal+cSerie+cA100For+cLoja			
				dbSelectArea("SEZ")
				dbSetOrder(1)	//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
				dbGoTop()
				If dbSeek ( xFilial("SEZ")+cSerie+cNFiscal )
					While !SEZ->(EOF()) .and. EZ_FILIAL+EZ_PREFIXO+EZ_NUM == xFilial("SEZ")+cSerie+cNFiscal
						If SEZ->(EZ_CLIFOR+EZ_LOJA+EZ_CCUSTO+EZ_CLVL) == (cA100For+cLoja+SDE->DE_CC+SDE->DE_CLVL) .AND. Empty(SEZ->EZ_X_CONTA)
							If RecLock("SEZ",.F.)
								SEZ->EZ_X_CONTA := SDE->DE_CONTA
								SEZ->(MsUnLock())							
							EndIf
						EndIf
						SEZ->(dbSkip())
					Enddo
				EndIf
				SDE->(dbSkip())
			Enddo
		EndIf
		
	End Transaction
		
	RestArea(aAreaTMP)
	
Return
