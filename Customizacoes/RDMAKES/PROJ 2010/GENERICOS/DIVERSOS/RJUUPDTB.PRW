#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

//-- PROGRAMAS DE AJUSTES GENERICOS SOBRE TABELAS...

*--------------------------*
User Function RJUUPDTB()
*--------------------------*  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	MsAguarde( {|| fUpdCAD()}, "Aguarde...", "Processando dados..." )
Return

*--------------------------*
Static Function fUpdCAD()   
*--------------------------*

Local cEMPATU := cEmpAnt
Local cFILATU := cFilAnt
Local cMODIMP := "FAT"
Local aDADOSEMP := {}	 

    
	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If ! SM0->M0_CODIGO $ "00/70"
			If Len(aDADOSEMP) == 0
				nPOS := 0
			Else
				nPOS := aScan ( aDADOSEMP, { |x| x[1] == SM0->M0_CODIGO } )
			EndIf
			If nPOS == 0
				aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL } )
			EndIf		
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)
	
	
	For nE := 1 to Len(aDADOSEMP)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Prepara ambiente/módulo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SM0")
		dbSetOrder(1)
		If !dbSeek ( aDADOSEMP[nE][01] )
			Alert("Empresa "+aDADOSEMP[nE][01]+" não existente no SIGAMAT.")
			Loop   
		EndIf

		RpcClearEnv()
		RPCSetType(3)
		                                              
		PREPARE ENVIRONMENT EMPRESA (aDADOSEMP[nE][01]) FILIAL (aDADOSEMP[nE][02]) MODULO cMODIMP 
		
		
		dbSelectArea("SM0")
		aAreaSM0 := SM0->(GetArea())
		SM0->(dbSetOrder(1))
		SM0->(dbGoTop())
		dbSeek(aDADOSEMP[nE][01])
		
		While !SM0->(EOF()) .and. SM0->M0_CODIGO == aDADOSEMP[nE][01]
		
			dbSelectArea("SZA")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(SM0->M0_CODFIL)
			While !SZA->(EOF()) .AND. SZA->ZA_FILIAL == SM0->M0_CODFIL
				If RecLock("SZA",.F.)
					SZA->(dbDelete())
					SZA->(MsUnLock())
				EndIf
				SZA->(dbSkip())
			Enddo                    
			
			cFile := lower("\procdepara\sza500.dtc")
			If File(cFile)
		    	MsOpEndbf(.T.,"CTREECDX",cFile,"TAB",.F.,.F.,.F.,.F.)			

				TAB->(DbSelectArea("TAB"))				
				TAB->(dbGoTop())
				While TAB->(!EOF())
					RecLock("SZA",.T.)
					for iX := 1 to TAB->(FCount())
						cCampo := TAB->(FieldName(iX))
						If ALLTRIM(cCampo) != "ZA_FILIAL"
							nPos := ("SZA")->(FieldPos(cCampo))
							If (nPos > 0)
								("SZA")->(FieldPut(nPos, TAB->&cCampo))
							EndIf
						Else
							SZA->ZA_FILIAL := SM0->M0_CODFIL
						EndIf
					Next
					("SZA")->(MsUnLock())
					TAB->(dbSkip())
				EndDo
				TAB->(dbCloseArea())
			EndIf
				    	
				    	
			dbSelectArea("SM0")
			SM0->(dbSkip())
		Enddo
		RestArea(aAreaSM0)
		
	Next nE	
	
	RpcClearEnv()
	RPCSetType(3)
	                                              
	PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO cMODIMP 	

	MsgInfo("processo concluido!")	
Return	   


//-- AJUSTES SOBRE CONTRATOS
*--------------------------*
User Function RJUUPZ12()
*--------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	MsAguarde( {|| fUpdZ12()}, "Aguarde...", "Processando dados..." )
Return

*--------------------------*
Static Function fUpdZ12()   
*--------------------------*

Local cAliasTMP := GetNextAlias()
Local cAliasDET := GetNextAlias()
Local aCONTRATO := {}

	cQuery := "	SELECT Z12_FILIAL, Z12_CONTRA, Z12_ATIVO, Z12_VENDED, Z12_NOMVEN, Z12_GRPCLI, Z12_CODCLI, Z12_LOJCLI, Z12_DATINI, Z12_DATFIN, 'Z13300' TAB "
	cQuery += "	FROM TOTVS10.Z12300  Z12300 "
	cQuery += "	WHERE Z12300.D_E_L_E_T_ != '*' "
	cQuery += "	UNION ALL "
	cQuery += "	SELECT Z12_FILIAL, Z12_CONTRA, Z12_ATIVO, Z12_VENDED, Z12_NOMVEN, Z12_GRPCLI, Z12_CODCLI, Z12_LOJCLI, Z12_DATINI, Z12_DATFIN, 'Z13310' TAB "
	cQuery += "	FROM TOTVS10.Z12310  Z12310 "
	cQuery += "	WHERE Z12310.D_E_L_E_T_ != '*' "
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de produtos com quantidade de vendas maior que em estoque    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While (cAliasTMP)->(!EOF())
		If Len(aCONTRATO) == 0
			nPOS := 0
		Else
			nPOS := aScan ( aCONTRATO, {|x| x[3] == (cAliasTMP)->Z12_VENDED } )
		EndIf                                 
		
		If nPOS == 0
			
			cQuery := "	SELECT Z13_CONTRA, Z13_ITEM, Z13_CODGRP, Z13_DESGRP, Z13_CODPRD, Z13_DESPRD, Z13_PERCOM "
			cQuery += "	FROM " + (cAliasTMP)->TAB 
			cQuery += "	WHERE D_E_L_E_T_ != '*' AND Z13_FILIAL = '"+(cAliasTMP)->Z12_FILIAL+"' AND Z13_CONTRA = '"+(cAliasTMP)->Z12_CONTRA+"' "
			
				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasDET)
				
				dbSelectArea(cAliasDET)
				(cAliasDET)->(dbGoTop())
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtro de produtos com quantidade de vendas maior que em estoque    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				aAdd ( aCONTRATO, {(cAliasTMP)->Z12_CONTRA, (cAliasTMP)->Z12_ATIVO, (cAliasTMP)->Z12_VENDED, (cAliasTMP)->Z12_NOMVEN,;
				 (cAliasTMP)->Z12_GRPCLI, (cAliasTMP)->Z12_CODCLI, (cAliasTMP)->Z12_LOJCLI, (cAliasTMP)->Z12_DATINI, (cAliasTMP)->Z12_DATFIN, {} } )
				nPOS := Len(aCONTRATO)
				
				While (cAliasDET)->(!EOF())
					aAdd ( aCONTRATO[nPOS][10], { (cAliasDET)->Z13_ITEM, (cAliasDET)->Z13_CODGRP, (cAliasDET)->Z13_DESGRP, ;
					(cAliasDET)->Z13_CODPRD, (cAliasDET)->Z13_DESPRD, (cAliasDET)->Z13_PERCOM } )
				    (cAliasDET)->(dbSkip())
				Enddo
				(cAliasDET)->(dbCloseArea())
			
		EndIf
		
		(cAliasTMP)->(dbSkip())               		
	Enddo	
	(cAliasTMP)->(dbCloseArea())
	
	
	If Len(aCONTRATO) > 0
		For nI := 1 to Len(aCONTRATO)
			dbSelectArea("Z12")
			If RecLock("Z12", .T.)
				cCONT := STRZero(nI,TAMSX3("Z12_CONTRA")[1])
				Z12->Z12_FILIAL := "99"
				Z12->Z12_CONTRA := cCONT
				Z12->Z12_ATIVO  := aCONTRATO[nI][02]
				Z12->Z12_VENDED := aCONTRATO[nI][03]
				Z12->Z12_NOMVEN := aCONTRATO[nI][04]
				Z12->Z12_GRPCLI := aCONTRATO[nI][05]
				Z12->Z12_CODCLI := aCONTRATO[nI][06]
				Z12->Z12_LOJCLI := aCONTRATO[nI][07]
				Z12->Z12_DATINI := CTOD(aCONTRATO[nI][08])
				Z12->Z12_DATFIN := CTOD(aCONTRATO[nI][09])
				
				dbSelectArea("Z13")
				For nJ := 1 to Len(aCONTRATO[nI][10])
					If RecLock("Z13",.T.)
						Z13->Z13_FILIAL := "99"
						Z13->Z13_CONTRA := cCONT
						Z13->Z13_ITEM   := aCONTRATO[nI][10][nJ][01]
						Z13->Z13_CODGRP := aCONTRATO[nI][10][nJ][02]
						Z13->Z13_DESGRP := aCONTRATO[nI][10][nJ][03]
						Z13->Z13_CODPRD := aCONTRATO[nI][10][nJ][04]
						Z13->Z13_DESPRD := aCONTRATO[nI][10][nJ][05]
						Z13->Z13_PERCOM	:= aCONTRATO[nI][10][nJ][06]
						Z13->(MsUnLock())
					Endif
				Next nJ 
				Z12->(MsUnLock())
			EndIf		
		Next nI
	EndIf
	 
	Alert("Processo concluido! FIM") 

Return  


*--------------------------*
User Function RJUUPZ13()
*--------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	MsAguarde( {|| fUpdZ13()}, "Aguarde...", "Processando dados..." )
Return

*--------------------------*
Static Function fUpdZ13()   
*--------------------------*

	dbSelectArea("Z13")
	dbGoTop()
	While !EOF()
		If RecLock("Z13",.F.)
			If !Empty(Z13->Z13_CODGRP)
				Z13->Z13_DESGRP := POSICIONE("SBM",1,xFilial("SBM")+Z13->Z13_CODGRP,"BM_DESC")
			EndIf
			If !Empty(Z13->Z13_CODPRD)
				Z13->Z13_DESPRD := POSICIONE("SB1",1,xFilial("SB1")+Z13->Z13_CODPRD,"B1_DESC")
			EndIf
			Z13->(MsUnLock())
		EndIf
		Z13->(dbSkip())
	Enddo
	
	Alert("OK")

Return     



//--AJUSTE SOBRE CODIGOS DE FORNECEDORES ESTRANGEIROS
*--------------------------*
User Function RJUUPEX()
*--------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	MsAguarde( {|| fUpdEXP()}, "Aguarde...", "Processando dados..." )
Return

*--------------------------*
Static Function fUpdEXP()   
*--------------------------*
Local nSEQ := 1
	Alert("INICIO")
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbGoTop()
	dbSeek(xFilial("SA2") + "EX" )
	While !EOF() .and. SA2->A2_FILIAL + SubSTR(SA2->A2_COD,1,2) == xFILIAL("SA2")+"EX"
		If RecLock("SA2",.F.)
			SA2->A2_COD := "EX"+STRZero(nSEQ,TAMSX3("A2_COD")[1]-2)
			nSEQ += 1
			SA2->(MsUnLock())
		EndIf
		SA2->(dbSkip())
	Enddo
	
	Alert("OK "+str(nSEQ))

Return     



//-- AJUSTA CLASSE DE VALOR SOBRE VENDAS DO SIGALOJA/FRONTLOJA
*--------------------------*
User Function RJUUPCL()
*--------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	MsAguarde( {|| fUpdCLVL()}, "Aguarde...", "Processando dados..." )
Return

*--------------------------*
Static Function fUpdCLVL()   
*--------------------------*
Local cXCLVLF := ALLTRIM(GETMV("MV_X_CLVLF"))
	
	dbSelectArea("SL1")
	dbSetOrder(1)
	dbGoTop() 
	ProcRegua(RecCount())
	
	While !SL1->(EOF())           
	
		If Empty(SL1->L1_X_CLVL) .and. cXCLVLF != ""
  			
  			IncProc("Documento: "+SL1->L1_DOC+"/"+SL1->L1_SERIE)
  			
  			If RecLock("SL1",.F.)
  				SL1->L1_X_CLVL := cXCLVLF
  				SL1->(MsUnLock())
  			EndIf
  			
			cFILDOC := SL1->L1_FILIAL
			cCLIDOC := SL1->L1_CLIENTE
			cLOJDOC := SL1->L1_LOJA
			cNUMDOC := SL1->L1_DOC
			cSERDOC := SL1->L1_SERIE

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza título campo classe de valor                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			dbSelectArea("SE1")
			dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
			dbGoTop()
			If dbSeek (cFILDOC + cCLIDOC + cLOJDOC + cSERDOC + cNUMDOC )
				While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == cFILDOC+cCLIDOC+cLOJDOC+cSERDOC+cNUMDOC
					If Empty(SE1->E1_CLVLCR)
						If RecLock("SE1", .F.)
							SE1->E1_CLVLCR := cXCLVLF
							SE1->(MsUnLock())					
						EndIf
					EndIf
					SE1->(dbSkip())
				Enddo
			EndIf
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza itens documento campo classe de valor                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			dbSelectArea("SD2")
			dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			dbGoTop()
			If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )
				While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFILDOC+cNUMDOC+cSERDOC+cCLIDOC+cLOJDOC
					If Empty(SD2->D2_CLVL)
						If RecLock("SD2",.F.)
							SD2->D2_CLVL := cXCLVLF
							SD2->(MsUnLock())
						EndIf
					EndIf
					SD2->(dbSkip())
				Enddo
			EndIf

		EndIf
		
		SL1->(dbSkip())
	Enddo
	
	Alert("Processo concluído!")

Return

//-- ATUALIZA ENTIDADES CONTABEIS SOBRE MOVIMENTACOES (SE1/DT6/SD3).
*-------------------------------*
User Function RJACLMNT()
*-------------------------------*

Local nREG := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar SEGMENTO CC ITEM do DA3 de acordo com ST9?","Atualização","YESNO") 		
		
	dbSelectArea("ST9")
	ST9->(dBSetOrder(1))
	ST9->(dBGotop()) 
	While !ST9->(EOF())
		dbSelectArea("DA3")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("DA3") + ST9->T9_CODTMS )
			If RecLock("DA3",.F.)
				DA3->DA3_X_SEGM := ST9->T9_X_CLVL
				DA3->DA3_X_ITEM := ST9->T9_ITEMCTA  
				DA3->DA3_X_CC   := ST9->T9_CCUSTO
				DA3->(MsUnLock())
				nREG += 1
			EndIf
		EndIf
		ST9->(dbSkip())
	Enddo
	Alert("Processo concluido! Atualizados: "+STR(nREG))
EndIf




If MsgBox("Ajusta campo classe de valor sobre registros relacionados abastecimento manual (SD3) ?","Atualização","YESNO")

	//-- Atualiza classe de valor do cadastro de bens sobre movimento interno.
	nTQN := 0
	dbSelectArea("TQN")
	dbSetOrder(1)
	dbGoTop()
	While !TQN->(EOF())
		dbSelectArea("ST9")
		ST9->(dBSetOrder(1))
		ST9->(dBGotop()) 
		If ST9->(dbSeek(xFilial("ST9") + TQN->TQN_FROTA ))
			If !Empty(ST9->T9_X_CLVL)
				dbSelectArea("SD3")
				dbSetOrder(4)
				dbGoTop()
				If dbSeek( xFilial("SD3") + TQN->TQN_NUMSEQ )
					If Empty(SD3->D3_CLVL) .OR. Empty(SD3->D3_ITEMCTA)
						If RecLock("SD3",.F.)
							SD3->D3_CLVL := ST9->T9_X_CLVL
							SD3->D3_ITEMCTA := ST9->T9_ITEMCTA
							SD3->D3_ITEM := ""
							SD3->(MsUnlock())
							nTQN += 1
						EndIf
					EndIf
					
				EndIf
			EndIf
		EndIf
		TQN->(dbSkip())
	Enddo
	Alert("TQN OK N. REGISTROS: "+cValToChar(nTQN))
EndIf


If MsgBox("Ajusta campo classe de valor sobre registros relacionados a viagens (SE1/SD2/DT6) ?","Atualização","YESNO")
	
	//-- Atualiza classe de valor, cc, item contabil sobre registros relacionados as viagens.
	nDTQ := 0
	dbSelectArea("DTQ")
	dbSetOrder(1)
	dbGoTop()
	While !DTQ->(EOF())
	
		lUpdate := .F.
		dbSelectArea("DTR") // Veiculos da viagem
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("DTR") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
			dbSelectArea("DA3")	// Veiculos
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("DA3") + DTR->DTR_CODVEI )
				If !Empty(DA3->DA3_X_CC) .or. !Empty(DA3->DA3_X_ITEM) .or. !Empty(DA3->DA3_X_SEGM)
					lUpdate := .T.
				EndIf
			EndIf
		EndIf
	
		If lUpdate
			
			dbSelectArea("DUD")	// Movimentos de viagem
			dbSetOrder(2)
			dbGoTop()			
			If dbSeek ( xFilial("DUD") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
				While !DUD->(EOF()) .and. DUD->DUD_FILIAL + DUD->DUD_FILORI + DUD->DUD_VIAGEM == xFilial("DUD") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM
					
					dbSelectArea("SE1") // Contas a receber
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("SE1") + DUD->DUD_SERIE + DUD->DUD_DOC )
						While !SE1->(EOF()) .and. SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM == xFilial("SE1") + DUD->DUD_SERIE + DUD->DUD_DOC
							If RecLock("SE1",.F.)
								If Empty(SE1->E1_CLVLCR)
									SE1->E1_CLVLCR	:= DA3->DA3_X_SEGM
								EndIf
								If Empty(SE1->E1_CCC)
									SE1->E1_CCC		:= DA3->DA3_X_CC
								EndIf
								If Empty(SE1->E1_ITEMC)
									SE1->E1_ITEMC   := DA3->DA3_X_ITEM
								EndIf
								SE1->(MsUnLock())								
							EndIf                							
							SE1->(dbSkip())
						Enddo
					EndIf

					dbSelectArea("SD2") // Itens do Documento Saida - Paulo
					dbSetOrder(3)       // D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					dbGoTop()
					If dbSeek ( xFilial("SD2")  + DUD->DUD_DOC + DUD->DUD_SERIE )
						While !SD2->(EOF()) .and. SD2->D2_FILIAL + SD2->D2_SERIE + SD2->D2_DOC  == xFilial("SD2") + DUD->DUD_SERIE + DUD->DUD_DOC
							If RecLock("SD2",.F.)
								If Empty(SD2->D2_CLVL)
									SD2->D2_CLVL   := DA3->DA3_X_SEGM
								EndIf
								If Empty(SD2->D2_CCUSTO)
									SD2->D2_CCUSTO := DA3->DA3_X_CC								
								EndIf
								If Empty(SD2->D2_ITEMCC)
									SD2->D2_ITEMCC := DA3->DA3_X_ITEM								
								EndIf
								SD2->(MsUnLock())								
							EndIf                							
							SD2->(dbSkip())
						Enddo
					EndIf

					
					dbSelectArea("DT6")	// Documentos de Transporte      
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("DT6") + DUD->DUD_FILDOC + DUD->DUD_DOC + DUD->DUD_SERIE )
						If RecLock("DT6",.F.)
							If Empty(DT6->DT6_X_SEGM)
								DT6->DT6_X_SEGM	:= DA3->DA3_X_SEGM
							EndIf
							If Empty(DT6->DT6_X_CC)
								DT6->DT6_X_CC	:= DA3->DA3_X_CC
							EndIf
							If Empty(DT6->DT6_X_ITEM)
								DT6->DT6_X_ITEM := DA3->DA3_X_ITEM
							EndIf
							DT6->(MsUnLock())
							nDTQ += 1                 							
						EndIf
					EndIf
					
					DUD->(dbSkip())
				Enddo
			EndIf
		EndIf
	
		dbSelectArea("DTQ")
		DTQ->(dbSkip())		            
	
	Enddo
    
	Alert("DTQ OK N. REGISTROS: "+cValToChar(nDTQ))
	
EndIf

If MsgBox("Ajusta campo item cta sobre registros relacionados aos bens ST9 ?","Atualização","YESNO")
	
	nST9 := 0
	dbSelectArea("ST9")
	ST9->(dBSetOrder(1))
	ST9->(dBGotop()) 	
	While !ST9->(EOF())
		dbSelectArea("CTD")
		dbSetOrder(4)
		dbGoTop()
		If dbSeek ( xFilial("CTD") + ST9->T9_CODBEM )
			If RecLock("ST9",.F.)
				ST9->T9_ITEMCTA := CTD->CTD_ITEM
				ST9->(MsUnLock())
				nST9 += 1
			EndIf
		EndIf
		ST9->(dbSkip())
	Enddo
	Alert("ST9 OK N. REGISTROS: "+cValToChar(nST9))
	
EndIf

Return


//-- AJUSTA SEGMENTO, CENTRO DE CUSTO E ITEM CONTABIL SOBRE TABELAS DE VENDAS E COMPRAS
*------------------------*
User Function RJAJCLVL()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar CENTRO CUSTO, SEGMENTO E ITEM CONTABIL ?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| fUCLVL() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*------------------------*
Static Function fUCLVL()
*------------------------*                          

Local cCCDEF := ALLTRIM(GETMV("MV_X_CCDEF"))
Local cCLDEF := ALLTRIM(GETMV("MV_X_CLVLF"))
Local aDADOSFIL := {}

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aDADOSFIL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	
	If Len(aDADOSFIL) > 0
		For nI := 1 To Len(aDADOSFIL)

		    //-- DOCUMENTO DE SAIDA
			dbSelectArea("SF2")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(aDADOSFIL[nI,01])        
			While !SF2->(EOF()) .and. SF2->F2_FILIAL == aDADOSFIL[nI,01]
				
				dbSelectArea("SD2")
				dbSetOrder(3)
				dbGoTop()
				If dbSeek( aDADOSFIL[nI,01] + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA )
					
					oProcUPD:IncRegua1(SF2->F2_DOC)
					
					cCODCL := ""
					cCODCC := ""
					cCODIT := ""
					
					//-- DEFINE VALOR PARA VARIAVEL DE SEGMENTO
					If "EC" $ SF2->F2_SERIE
						
						dbSelectArea("SL1")
						dbSetOrder(2)
						dbGoTop()
						If dbSeek( aDADOSFIL[nI,01] + SF2->F2_SERIE + SF2->F2_DOC + SD2->D2_PDV )
							If Empty(SL1->L1_X_CLVL)
								
								//-- ARMAZEM x VENDEDOR x CLASSE VALOR
								dbSelectArea("Z22")
								dbSetOrder(1)
								dbGoTop()
								If dbSeek( xFilial("Z22") + SF2->F2_VEND1 )
								    While !Z22->(EOF()) .and. Z22->Z22_FILIAL + Z22->Z22_CODVEN == xFilial("Z22") + SF2->F2_VEND1
								    	If Z22->Z22_ARMAZ == SD2->D2_LOCAL .and. !Empty(Z22->Z22_CODCVL)
								    		cCLDEF := Z22->Z22_CODCVL
								    		Exit
								    	EndIf
								    	Z22->(dbSkip())
								    Enddo							
								EndIf						
								
								If RecLock("SL1",.F.)
									SL1->L1_X_CLVL := cCLDEF
									SL1->(MsUnLock())
								Endif
							EndIf
							cCODCL := SL1->L1_X_CLVL
						EndIf
					
					Else
					
						dbSelectArea("SC5")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek( aDADOSFIL[nI,01] + SD2->D2_PEDIDO )
							If !Empty(SC5->C5_X_CLVL)
								cCODCL := SC5->C5_X_CLVL
							Else
								//-- ARMAZEM x VENDEDOR x CLASSE VALOR
								dbSelectArea("Z22")
								dbSetOrder(1)
								dbGoTop()
								If dbSeek( xFilial("Z22") + SF2->F2_VEND1 )
								    While !Z22->(EOF()) .and. Z22->Z22_FILIAL + Z22->Z22_CODVEN == xFilial("Z22") + SF2->F2_VEND1
								    	If Z22->Z22_ARMAZ == SD2->D2_LOCAL .and. !Empty(Z22->Z22_CODCVL)
								    		cCODCL := Z22->Z22_CODCVL
								    		Exit
								    	EndIf
								    	Z22->(dbSkip())
								    Enddo							
								EndIf
								
							EndIf
						EndIf
					
					EndIf
					
					//-- DEFINE VALOR PARA VARIAVEL DE CENTRO DE CUSTO
					If ! "DB" $ SF2->F2_TIPO 
						cCODCC := cCCDEF
					EndIf
						
					//-- DEFINE VALOR PARA VARIAVEIS CASO SEJA DOCUMENTO DO TMS
					dbSelectArea("DT6")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("DT6") + SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE )
						cCODCL := DT6->DT6_X_SEGM
						cCODCC := DT6->DT6_X_CC
						cCODIT := DT6->DT6_X_ITEM
					EndIf
				
					//-- ATUALIZA ITENS DOCUMENTO
					While !SD2->(EOF()) .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
		                lUpdCL := .F.
		                If Empty(SD2->D2_CLVL)
		                	lUpdCL := .T.
		                EndIf       
		                
						If RecLock("SD2",.F.)
							If cCODCC != ""
								SD2->D2_CCUSTO := cCODCC
							EndIf
							If cCODIT != ""
								SD2->D2_ITEMCC := cCODIT
							EndIf
							If lUpdCL
								SD2->D2_CLVL := cCODCL
							EndIf
		
							SD2->(MsUnLock())
						EndIf
					
						SD2->(dbSkip())
					Enddo
					
					//-- ATUALIZA TITULOS A RECEBER
					dbSelectArea("SE1")
					dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
					dbGoTop()
					If dbSeek (aDADOSFIL[nI,01] + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC )
						While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == aDADOSFIL[nI,01] + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC
			                
			                lUpdCL := .F.
			                If Empty(SE1->E1_CLVLCR)
			                	lUpdCL := .T.
			                EndIf   					
							
							If RecLock("SE1", .F.)              
								If cCODCC != ""
									SE1->E1_CCC := cCODCC
								EndIf
								If cCODIT != ""
									SE1->E1_ITEMC := cCODIT
								EndIf
								If lUpdCL
									SE1->E1_CLVLCR := cCODCL
								EndIf
								
								SE1->(MsUnLock())					
							EndIf
							SE1->(dbSkip())
						Enddo
					EndIf
		
				EndIf
				
				dbSelectArea("SF2")
				SF2->(dbSkip())
			Enddo
			SET FILTER TO 

		Next nI
		
	EndIf			

Return





//-- AJUSTA SEGMENTO, CENTRO DE CUSTO E ITEM CONTABIL SOBRE TABELAS DE VENDAS E COMPRAS SOBRE DEVOLUCOES
*------------------------*
User Function RJAJCLDV()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar CENTRO CUSTO, SEGMENTO E ITEM CONTABIL s/ DEVOLUCOES?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| fUCLDV() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*------------------------*
Static Function fUCLDV()
*------------------------*                          
Local aDADOSFIL := {}

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aDADOSFIL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	
	If Len(aDADOSFIL) > 0
		For nI := 1 To Len(aDADOSFIL)

		    //-- DOCUMENTO DE SAIDA
			dbSelectArea("SF2")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(aDADOSFIL[nI,01])        
			While !SF2->(EOF()) .and. SF2->F2_FILIAL == aDADOSFIL[nI,01]
				If SF2->F2_TIPO == "D"
					oProcUPD:IncRegua1("SF2: "+SF2->F2_DOC)
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbGoTop()
					If dbSeek( aDADOSFIL[nI,01] + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA )
						While !SD2->(EOF()) .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == aDADOSFIL[nI,01] + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
							dbSelectArea("SD1")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( aDADOSFIL[nI,01] + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_ITEMORI )
								If RecLock("SD2",.F.)
									SD2->D2_CLVL    := SD1->D1_CLVL
									SD2->D2_CCUSTO  := SD1->D1_CC
									SD2->D2_ITEMCC  := SD1->D1_ITEMCTA
									SD2->(MsUnLock())
								EndIf		
							EndIf	
							SD2->(dbSkip())
						Enddo
					EndIf
				EndIf
				SF2->(dbSkip())
			Enddo
			
		    //-- DOCUMENTO DE ENTRADA
			dbSelectArea("SF1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(aDADOSFIL[nI,01])        
			While !SF1->(EOF()) .and. SF1->F1_FILIAL == aDADOSFIL[nI,01]
				If SF1->F1_TIPO == "D"
					oProcUPD:IncRegua1("SF1: "+SF1->F1_DOC)
					dbSelectArea("SD1")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek( aDADOSFIL[nI,01] + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
						lSE1 := .F.
						While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == aDADOSFIL[nI,01] + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
							dbSelectArea("SD2")
							dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM 
							dbGoTop()
							If dbSeek( aDADOSFIL[nI,01] + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI )				
								If RecLock("SD1",.F.)
									SD1->D1_CLVL    := SD2->D2_CLVL    
									SD1->D1_CC      := SD2->D2_CCUSTO 
									SD1->D1_ITEMCTA := SD2->D2_ITEMCC 
									SD1->(MsUnLock())
								EndIf
							    
							    //-- NCC
								If ! lSE1
									dbSelectArea("SE1")
									dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
									dbGoTop()
									If dbSeek ( aDADOSFIL[nI,01] + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC )
										While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == aDADOSFIL[nI,01] + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC
											If RecLock("SE1", .F.)
												SE1->E1_CLVLCR  := SD2->D2_CLVL
												SE1->E1_CCC  	:= SD2->D2_CCUSTO
												SE1->E1_ITEMC   := SD2->D2_ITEMCC
												SE1->(MsUnLock())					
											EndIf										
											SE1->(dbSkip())
											lSE1 := .T.
										Enddo
									EndIf
								EndIf
								
							EndIf
							
							SD1->(dbSkip())
						Enddo
					EndIf

				EndIf
				SF1->(dbSkip())
			Enddo
		Next nI
	EndIf

Return  







//-- AJUSTA RATEIO DE SEGMENTO SOBRE TITULOS DE DOCUMENTOS DE ENTRADA COM MAIS DE UM SEGMENTO.
*------------------------*
User Function RATCLSE2()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar RATEIO DE SEGMENTO SOBRE ENTRADAS1 ?","Atualização","YESNO")                                            
    nRET := 0
	oProcUPD := MsNewProcess():New({|| fRATCLVL(@nRET) },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*-----------------------------*
Static Function fRATCLVL(nRET)
*-----------------------------*                          
Local aFILIAL := {}
Local aDADOS  := {}
Local nTOTAL  := 0

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aFILIAL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	
	If Len(aFILIAL) > 0
		For nI := 1 To Len(aFILIAL)

		    //-- DOCUMENTO DE ENTRADA
			dbSelectArea("SF1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek(aFILIAL[nI,01])        
			While !SF1->(EOF()) .and. SF1->F1_FILIAL == aFILIAL[nI,01]
				If ! SF1->F1_TIPO $ "D/B"
					
					oProcUPD:IncRegua1("FILIAL: " + aFILIAL[nI,01] + " - SF1: "+SF1->F1_DOC+"/"+SF1->F1_SERIE + " - REGISTRO: "+ cValToChar(nRET) )
					
					nRET += 1
					nTOTAL := 0
					aDADOS := {}
					
					//-- Recupera as classes de valores do documento.
					dbSelectArea("SD1")
					dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM	
					dbGoTop()
					If dbSeek( aFILIAL[nI,01] + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
						While !SD1->(EOF()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == aFILIAL[nI,01]+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
							If ! Empty(SD1->D1_CLVL)
								nPOS := aScan ( aDADOS, {|x| x[1] == SD1->D1_CLVL } )
								If nPOS == 0
									aAdd ( aDADOS, { SD1->D1_CLVL, SD1->D1_CC, SD1->D1_TOTAL, 0 } )
								Else
									aDADOS[nPOS,03] += SD1->D1_TOTAL
								EndIf
								nTOTAL += SD1->D1_TOTAL
							EndIf
							SD1->(dbSkip())
						Enddo
					EndIf
				
					If Len(aDADOS) > 0                         
						//-- Define os percentuais para cada segmento no rateio.
						If Len(aDADOS) > 1 .and. nTOTAL > 0
							For nS := 1 to Len(aDADOS)
								nPERC := Round(( aDADOS[nS,03] * 100 ) / nTOTAL, 2)
								aDADOS[nS,04] := nPERC
							Next nS
						EndIf
						
						//-- Popula títulos com segmentos/centros de custo do documento de entrada.
						dbSelectArea("SE2")
						dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
						dbGoTop()
						If dbSeek ( aFILIAL[nI,01]+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC )

							While ! SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM	== ;
									aFILIAL[nI,01]+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
								
								If Len(aDADOS) == 1
									If RecLock("SE2",.F.)
										SE2->E2_CLVLDB := aDADOS[01,01]
										SE2->E2_CCD    := aDADOS[01,02]
										SE2->(MsUnLock())							
									EndIf
								Else
									
									//-- Inclusão de rateio de segmentos.
									cSeqCV4 := GetSx8Num("CV4", "CV4_SEQUEN")
									While !MayIUseCode( cSeqCV4 )  //verifica se esta na memoria, sendo usado
										// busca o proximo numero disponivel 
										cSeqCV4 := Soma1(cSeqCV4)                                                                                                             	
									EndDo					
									If RecLock("SE2",.F.)
										SE2->E2_CCD    := aDADOS[01,02]
										SE2->E2_CLVLDB := Space(TAMSX3("E2_CLVLDB")[1])
										SE2->E2_RATEIO := "S"							
										SE2->E2_ARQRAT := aFILIAL[nI,01]+dtos(SF1->F1_EMISSAO)+cSeqCV4
										SE2->(MsUnLock())							
									EndIf
									cITSEQ := STRZero(1,TAMSX3("CV4_ITSEQ")[1])
									For nZ := 1 to Len(aDADOS)
										If RecLock("CV4",.T.)
											CV4->CV4_FILIAL	:= aFILIAL[nI,01]
											CV4->CV4_SEQUEN	:= cSeqCV4
											CV4->CV4_DTSEQ	:= SF1->F1_EMISSAO
											CV4->CV4_PERCEN := aDADOS[nZ,04]
											CV4->CV4_VALOR  := (SE2->E2_VALOR * aDADOS[nZ,04])/100
											CV4->CV4_CLVLDB := aDADOS[nZ,01]
											CV4->CV4_ITSEQ  := cITSEQ
											CV4->(MsUnLock())
										EndIf
										cITSEQ := STRZero(Val(cITSEQ)+1,TAMSX3("CV4_ITSEQ")[1])
									Next nZ
								EndIf
								SE2->(dbSkip())
							Enddo

						EndIf
					EndIf
				EndIf			
				dbSelectArea("SF1")
				SF1->(dbSkip())
			Enddo
		Next nI
	EndIf		

	
Return
                                                                                       


//-- ATUALIZACAO DO SALDO DE PARCELAS DO CIAP DE ACORDO COM REGISTROS DE APROPRIACOES TABELA SFA.
*--------------------------*
User Function RJM906F9()
*--------------------------*
Local lRet	  := .T.
Local aSF9	  := {}
Local aFILIAL := {}
Local nLimite := 0
Local dLei102 := SuperGetMv("MV_DATCIAP")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aFILIAL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	
	If Len(aFILIAL) > 0
		For nI := 1 To Len(aFILIAL)

			dbSelectArea("SF9")
			dbSetOrder(1)      
			dbGoTop()
			ProcRegua(SF9->(LastRec ()))
			dbSeek (aFILIAL[nI,01])
			Do While !(SF9->(Eof ())) .And. (aFILIAL[nI,01]==SF9->F9_FILIAL)
				nLimite	:= 	Iif (SF9->F9_DTENTNE>=dLei102, SuperGetMv ("MV_LC102"), 60)
				Begin Transaction
					If RecLock ("SF9", .F.)
						
						SF9->F9_QTDPARC	:= iif(SF9->F9_QTDPARC==0,	nLimite,SF9->F9_QTDPARC)  
						SF9->F9_SLDPARC	:=	SF9->F9_QTDPARC 
						//
						DbSelectArea ("SFA")
						SFA->(DbSetOrder (1))
						If (SFA->(MsSeek (aFILIAL[nI,01]+SF9->F9_CODIGO)))
							Do While !SFA->(Eof()) .And. aFILIAL[nI,01]==SFA->FA_FILIAL .And. SF9->F9_CODIGO==SFA->FA_CODIGO
								SF9->F9_SLDPARC	-=	1
								SFA->(DbSkip ())
							EndDo
						EndIf
						If SF9->F9_SLDPARC < 0
							SF9->F9_SLDPARC := 0
						EndIf
						If !Empty(SF9->F9_DTEMINS)
							SF9->F9_SLDPARC := 0
						EndIf
						If SF9->F9_DTENTNE < ctod("01/01/2007")
							SF9->F9_SLDPARC := 0
						EndIf
						SF9->(MsUnLock())
					EndIf
				End Transaction
				//
				aAdd (aSF9, {SubStr (AllTrim (SF9->F9_CODIGO), 1, 6),;
					SubStr (AllTrim (SF9->F9_DESCRI), 1, 40),;
					SF9->F9_DTENTNE,;
					Str (SF9->F9_QTDPARC, 2),;
					Str (SF9->F9_QTDPARC-SF9->F9_SLDPARC, 2),;
					Str (SF9->F9_SLDPARC, 2)})
			//
				dbSelectArea("SF9")
				SF9->(dbSkip())
				IncProc ()
			EndDo
		Next nI
	EndIf
			//
	If (Len (aSF9)>0)
		Alert("Processo concluido, registros atualizados: "+STR(LEN(aSF9)))
	Else
		Alert("Nenhuma atualização efetuada.")		
	EndIf                                     
	
Return
 
 
 
 
               
//-- ATUALIZACAO DO PERCENTUAL DE COMISSAO DE ACORDO COM OS CONTRATOS SOBRE PEDIDO DE VENDA E DOCUMENTO DE SAIDA
*------------------------*
User Function RJUPCOM()
*------------------------*
Local aDADOS := {}
local cPerg := "RJUPCOM"
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//aAdd (aDADOS,{xFilial("SC5")})

If MsgBox("Ajustar COMISSOES SOBRE DOCUMENTOS DE SAIDA ?","Atualização","YESNO")                                            
	
	
	AjustaSX1(cPerg)
	
	If pergunte(cPerg, .T.)
	
		//For nI := 1 to Len(aDADOS)
			oProcUPD := MsNewProcess():New({|| FJUPCOM(/*aDADOS[nI,01]*/) },"Atualizando registros "/*+aDADOS[nI,01]+" "*/ ,"Aguarde!",.F.)
			oProcUPD:Activate()                                                                                    
		//Next nI
	
	EndIf

	MsgInfo("Processo concluído!")
	
Endif

Static Function FJUPCOM(cFILANT) 
*********************************
Local hEnter  := Chr( 13 )
Local nREG    := 0
Local cSql    := ""
Local cNUMPED := ""
Local cSERIE  := ""
Local cCODVEN := ""
Local cCODCLI := ""
Local cLOJCLI := ""
Local cORIGEM := ""
Local dEMISSA := CTOD( "  /  /  " )

cSql := "SELECT * " + Chr( 13 )
cSql += "  FROM (    SELECT 'SC5'           ORIGEM  ," + hEnter
cSql += "                    SC5.C5_FILIAL  FILIAL  ," + hEnter
cSql += "                    SC5.C5_NUM     NUMERO  ," + hEnter
cSql += "                    ''             SERIE   ," + hEnter
cSql += "                    SC5.C5_VEND1   VENDEDOR," + hEnter
cSql += "                    SC5.C5_CLIENTE CLIENTE ," + hEnter
cSql += "                    SC5.C5_LOJACLI LOJA    ," + hEnter
cSql += "                    SC5.C5_EMISSAO EMISSAO  " + hEnter
cSql += "               FROM " + RetSQLName( "SC5" ) + " SC5 " + hEnter
cSql += "              WHERE SC5.C5_FILIAL   = '"+xFilial("SC5")+"'" + hEnter
cSql += "                AND SC5.C5_VEND1   >= '" + MV_PAR01 + "' AND SC5.C5_VEND1   <= '" + MV_PAR02 + "'" + hEnter
cSql += "                AND ( ( SC5.C5_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SC5.C5_EMISSAO <= '" + DTOS( MV_PAR04 ) + " ' ) )" + hEnter
cSql += "                AND SC5.D_E_L_E_T_ != '*'" + hEnter
cSql += " " + hEnter
cSql += "    UNION ALL" + hEnter 
cSql += " " + hEnter
cSql += "             SELECT 'SL1'          ORIGEM  ," + hEnter
cSql += "                    SL1.L1_FILIAL  FILIAL  ," + hEnter
cSql += "                    SL1.L1_NUM     NUMERO  ," + hEnter
cSql += "                    SL1.L1_SERIE   SERIE   ," + hEnter
cSql += "                    SL1.L1_VEND    VENDEDOR," + hEnter
cSql += "                    SL1.L1_CLIENTE CLIENTE ," + hEnter
cSql += "                    SL1.L1_LOJA    LOJA    ," + hEnter
cSql += "                    SL1.L1_EMISSAO EMISSAO  " + hEnter
cSql += "               FROM " + RetSQLName( "SL1" ) + " SL1 " + hEnter
cSql += "              WHERE SL1.L1_FILIAL   = '"+xFilial("SL1")+"'" + hEnter
cSql += "                AND SL1.L1_VEND    >= '" + MV_PAR01 + "' AND SL1.L1_VEND    <= '" + MV_PAR02 + "' " + hEnter
cSql += "                AND ( ( SL1.L1_EMISSAO >= '" + DTOS( MV_PAR03 ) + "' ) AND ( SL1.L1_EMISSAO <= '" + DTOS( MV_PAR04 ) + "' ) )  " + hEnter
cSql += "                AND SL1.D_E_L_E_T_ != '*' )" + hEnter
cSql += " ORDER BY FILIAL, " + hEnter
cSql += "          VENDEDOR" + hEnter

Memowrite( "FJUPCOM.sql", cSql )

//If Aviso("Conteúdo SQL",ChangeQuery(cSql),{"Continuar?","Abortar?"},3) != 1
	//Return
//EndIf

TcQuery cSql New Alias "TMPSC5"

dBSelectArea( "TMPSC5" )
TMPSC5->( dBGoTop( ) )

While !TMPSC5->( EOF( ) )
	
	nREG    += 1
	lFOUNDC := .F.
	cCODCON := ""
	
	cNUMPED := TMPSC5->NUMERO   // TMPSC5->C5_NUM
	cCODVEN := TMPSC5->VENDEDOR // TMPSC5->C5_VEND1
	cCODCLI := TMPSC5->CLIENTE  // TMPSC5->C5_CLIENTE
	cLOJCLI := TMPSC5->LOJA     // TMPSC5->C5_LOJACLI
	dEMISSA := TMPSC5->EMISSAO  // TMPSC5->C5_EMISSAO
	cORIGEM := TMPSC5->ORIGEM
	
	oProcUPD:IncRegua1("PEDIDO: " +cNUMPED+ " - REGISTRO: "+ cValToChar(nREG) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + cliente    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dBSelectArea( "Z12" )	  // CABECALHO CONTRATOS VENDEDORES
	Z12->( dBSetOrder( 3 ) )  // Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
	Z12->( dBGoTop() )
	If Z12->( dbSeek ( xFilial( "Z12" ) + cCODVEN + cCODCLI ) )
		While !Z12->( EOF( ) ) .AND. ( Z12->Z12_FILIAL == xFilial( "Z12" ) ) .AND. ( Z12->Z12_VENDED == cCODVEN ) .AND. ( Z12->Z12_CODCLI == cCODCLI )
			
			If !Empty( Z12->Z12_LOJCLI ) .AND. Z12->Z12_LOJCLI != cLOJCLI
				Z12->(dbSkip())
				Loop
			EndIf
			
			If Z12->Z12_ATIVO == "S"
				cCODCON := Z12->Z12_CONTRA
				lFOUNDC := .T.
				Exit
			EndIf
			
			Z12->(dbSkip())
		Enddo
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + grupo de clientes    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ! lFOUNDC
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona sobre cliente do pedido                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dBSelectArea( "SA1" )
		SA1->( dBSetOrder( 1 ) )
		SA1->( dbSeek( xFilial("SA1") + cCODCLI + cLOJCLI ) )
		
		If !Empty( SA1->A1_GRPVEN )
			dBSelectArea( "Z12" )		//CABECALHO CONTRATOS VENDEDORES
			Z12->( dBSetOrder( 2 ) )	//Z12_FILIAL+Z12_VENDED+Z12_GRPCLI
			Z12->( dbGoTop() )
			If Z12->( dbSeek ( xFilial( "Z12" ) + cCODVEN + SA1->A1_GRPVEN ) )
				While !Z12->( EOF( ) ) .AND. ( Z12->Z12_FILIAL == xFilial( "Z12" ) ) .AND. ( Z12->Z12_VENDED == cCODVEN ) .AND. ( Z12->Z12_GRPCLI == SA1->A1_GRPVEN )
					
					If Z12->Z12_ATIVO == "S"
						cCODCON := Z12->Z12_CONTRA
						lFOUNDC := .T.
						Exit
					EndIf
					
					Z12->( dBSkip( ) )
				Enddo
			EndIf
		EndIf
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato apenas para o vendedor       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ! lFOUNDC
		dBSelectArea( "Z12" )  		//CABECALHO CONTRATOS VENDEDORES
		Z12->( dBSetOrder( 3 ) )	//Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
		Z12->( dBGoTop() )
		If Z12->( dBSeek( xFilial("Z12") + cCODVEN ) )
			While !Z12->( EOF( ) ) .AND. ( Z12->Z12_FILIAL == xFilial( "Z12" ) ) .AND. ( Z12->Z12_VENDED == cCODVEN )
				
				If !Empty( Z12->Z12_CODCLI )
					Z12->( dBSkip( ) )
					Loop
				EndIf
				
				If !Empty(Z12->Z12_GRPCLI)
					Z12->(dbSkip())
					Loop
				EndIf
				
				If Z12->Z12_ATIVO == "S"
					cCODCON := Z12->Z12_CONTRA
					lFOUNDC := .T.
					Exit
				EndIf
				
				Z12->(dbSkip())
			Enddo
			
		EndIf
		
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se contrato existe                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lFOUNDC
		dBSelectArea( "Z12" )		//CABECALHO CONTRATOS VENDEDORES
		Z12->( dBSetOrder( 1 ) )	//Z12_FILIAL+Z12_CONTRA+Z12_VENDED
		Z12->( dBGoTop( ) )
		Z12->( dBSeek( xFilial( "Z12" ) + cCODCON ) )
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se contrato ativo e dentro do intervalo de datas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Z12->Z12_ATIVO == "S" .AND. ( dEMISSA >= DTOS( Z12->Z12_DATINI ) ) .AND. ( dEMISSA <= DTOS( Z12->Z12_DATFIN ) )
			
			If cORIGEM == "SC5"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens do pedido de venda                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SC6" )
				SC6->( dBSetOrder( 1 ) )
				SC6->( dBGoTop( ) )
				If SC6->( dBSeek ( xFilial("SC6") + cNUMPED ) )
					While !SC6->( EOF( ) ) .AND. ( SC6->C6_FILIAL == xFilial("SC6") ) .AND. ( SC6->C6_NUM == cNUMPED )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						dBSelectArea( "SB1" )
						SB1->( dbSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o contrato possui o produto do pedido         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dBSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
						Z13->( dBSetOrder( 3 ) )		//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD
						Z13->( dBGoTop( ) )
						If Z13->( dbSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SC6->C6_PRODUTO ) )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Altera comissão do item conforme percentual do contrato.       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If RecLock( "SC6", .F. )
								SC6->C6_COMIS5 := SC6->C6_COMIS1
								SC6->C6_COMIS1 := Z13->Z13_PERCOM
								SC6->(MsUnLock())
							EndIf
							
						Else
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o grupo de produto do pedido     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dbSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
							Z13->( dBSetOrder( 2 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
							Z13->( dbGoTop( ) )
							If Z13->( dBSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SB1->B1_GRUPO ) )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If RecLock( "SC6", .F. )
									SC6->C6_COMIS5 := SC6->C6_COMIS1
									SC6->C6_COMIS1 := Z13->Z13_PERCOM
									SC6->(MsUnLock())
								EndIf
							//Guilherme 08/11/13 - Utilizado para tratar a comissao do produto quando não tem contrato.
							Else								   					
								dBSelectArea( "SB1" )
								SB1->( dbSetOrder( 1 ) )
								SB1->( dBGoTop( ) )
								If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )									
								  	If RecLock( "SC6", .F. )
										SC6->C6_COMIS5 := SC6->C6_COMIS1
										SC6->C6_COMIS1 := SB1->B1_COMIS
										SC6->(MsUnLock())
									EndIf															
								EndIf
							EndIf
							//Guilherme 08/11/13 - FIM
							
						EndIf
						
						SC6->(dbSkip())
					Enddo
					
				EndIf
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens do documento de saida                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SD2" )
				SD2->( dBSetOrder( 8 ) )	//D2_FILIAL+D2_PEDIDO+D2_ITEMPV
				SD2->( dbGoTop( ) )
				If SD2->( dBSeek ( xFilial("SD2") + cNUMPED ) )
					While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_PEDIDO == cNUMPED )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						dBSelectArea( "SB1" )
						SB1->( dBSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o contrato possui o produto do pedido         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						dBSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
						Z13->( dBSetOrder( 3 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD
						Z13->( dBGoTop( ) )
						If Z13->( dBSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SD2->D2_COD ) )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Altera comissão do item conforme percentual do contrato.       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If RecLock( "SD2", .F. )
								SD2->D2_COMIS5 := SD2->D2_COMIS1
								SD2->D2_COMIS1 := Z13->Z13_PERCOM
								SD2->(MsUnLock())
							EndIf
							
						Else
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o grupo de produto do pedido     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "Z13" )	//ITENS CONTRATOS VENDEDORES
							Z13->( dBSetOrder( 2 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
							Z13->( dBGoTop() )
							If Z13->( dbSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SB1->B1_GRUPO ) )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If RecLock( "SD2", .F. )
									SD2->D2_COMIS5 := SD2->D2_COMIS1
									SD2->D2_COMIS1 := Z13->Z13_PERCOM
									SD2->(MsUnLock())																					
								EndIf
							//Guilherme 08/11/13 - Utilizado para tratar a comissao do produto quando não tem contrato.
							Else							
								dBSelectArea( "SB1" )
								SB1->( dbSetOrder( 1 ) )
								SB1->( dBGoTop( ) )
								If SB1->( dBSeek( xFilial( "SB1" ) + SD2->D2_COD ) )									
								  	If RecLock( "SD2", .F. )
										SD2->D2_COMIS5 := SD2->D2_COMIS1
										SD2->D2_COMIS1 := SB1->B1_COMIS
										SD2->(MsUnLock())	
									EndIf															
								EndIf
							EndIf
							//Guilherme 08/11/13 - FIM							
						EndIf
						
						SD2->(dbSkip())
					Enddo
					
				EndIf
				
			ElseIf cORIGEM == "SL1"
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre venda - orçamento                                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SL1" )
				SL1->( dBSetOrder( 1 ) ) // L1_FILIAL+L1_NUM
				SL1->( dBGoTop( ) )
				If SL1->( MsSeek ( xFilial("SL1") + cNUMPED ) )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens da venda - orçamento                       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SL2" )
					SL2->( dBSetOrder( 3 ) ) //L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO
					SL2->( dBGoTop( ) )
					If SL2->( MsSeek ( xFilial("SC5") + cNUMPED ) )
						While !SL2->( EOF( ) ) .AND. ( SL2->L2_FILIAL == xFilial("SC5") ) .AND. ( SL2->L2_SERIE == SL1->L1_SERIE ) .AND. ( SL2->L2_DOC == SL1->L1_DOC )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona sobre o cadastro de produto.                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "SB1" )
							SB1->( dbSetOrder( 1 ) )
							SB1->( dBGoTop( ) )
							SB1->( dBSeek( xFilial( "SB1" ) + SL2->L2_PRODUTO ) )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o produto do pedido         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
							Z13->( dBSetOrder( 3 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD
							Z13->( dBGoTop( ) )
							If Z13->( dBSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SL2->L2_PRODUTO ) )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If RecLock( "SL1", .F. )
									SL1->L1_COMIS := Z13->Z13_PERCOM
									SL1->( MsUnLock( ) )
								EndIf								
								
								Exit
								
							Else
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o grupo de produto do pedido     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
								Z13->( dBSetOrder( 2 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
								Z13->( dBGoTop( ) )
								If Z13->( dBSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SB1->B1_GRUPO ) )
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If RecLock( "SL1", .F. )
										SL1->L1_COMIS := Z13->Z13_PERCOM
										SL1->( MsUnLock( ) )
									EndIf
									
									Exit
									
								//Guilherme 08/11/13 - Utilizado para tratar a comissao do produto quando não tem contrato.
								Else							
									dBSelectArea( "SB1" )
									SB1->( dbSetOrder( 1 ) )
									SB1->( dBGoTop( ) )
									If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )									
								  		If RecLock( "SL1", .F. )
											SL1->L1_COMIS := SB1->B1_COMIS
											SL1->( MsUnLock( ) )
										EndIf									
										Exit										
									EndIf
								//Guilherme 08/11/13 - FIM								
								EndIf
								
							EndIf
							
							SL2->( dBSkip( ) )
						Enddo
						
					EndIf
					
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Percorre itens do documento de saida                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dBSelectArea( "SD2" )
					SD2->( dBSetOrder( 3 ) )	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
					SD2->( dbGoTop( ) )
					If SD2->( dBSeek ( xFilial("SD2") + SL1->L1_DOC + SL1->L1_SERIE + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
						While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_DOC == SL1->L1_DOC ) .AND. ( SD2->D2_SERIE == SL1->L1_SERIE )  .AND. ( SD2->D2_CLIENTE == SL1->L1_CLIENTE ) .AND. ( SD2->D2_LOJA == SL1->L1_LOJA  )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Posiciona sobre o cadastro de produto.                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							
							dBSelectArea( "SB1" )
							SB1->( dBSetOrder( 1 ) )
							SB1->( dBGoTop( ) )
							SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica se o contrato possui o produto do pedido         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							dBSelectArea( "Z13" )		//ITENS CONTRATOS VENDEDORES
							Z13->( dBSetOrder( 3 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD
							Z13->( dBGoTop( ) )
							If Z13->( dBSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SD2->D2_COD ) )
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If RecLock( "SD2", .F. )
									SD2->D2_COMIS5 := SD2->D2_COMIS1
									SD2->D2_COMIS1 := Z13->Z13_PERCOM
									SD2->(MsUnLock())
								EndIf
								
							Else
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Verifica se o contrato possui o grupo de produto do pedido     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dBSelectArea( "Z13" )	//ITENS CONTRATOS VENDEDORES
								Z13->( dBSetOrder( 2 ) )	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
								Z13->( dBGoTop() )
								If Z13->( dbSeek( xFilial( "Z13" ) + Z12->Z12_CONTRA + SB1->B1_GRUPO ) )
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ Altera comissão do item conforme percentual do contrato.       ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If RecLock( "SD2", .F. )
										SD2->D2_COMIS5 := SD2->D2_COMIS1
										SD2->D2_COMIS1 := Z13->Z13_PERCOM
										SD2->( MsUnLock( ) )
									EndIf
								
								//Guilherme 08/11/13 - Utilizado para tratar a comissao do produto quando não tem contrato.
								Else							
									dBSelectArea( "SB1" )
									SB1->( dbSetOrder( 1 ) )
									SB1->( dBGoTop( ) )
									If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )									
									  	If RecLock( "SD2", .F. )
											SD2->D2_COMIS5 := SD2->D2_COMIS1
											SD2->D2_COMIS1 := SB1->B1_COMIS
											SD2->(MsUnLock())	
										EndIf															
									EndIf							
								//Guilherme 08/11/13 - FIM									
								EndIf
								
							EndIf
							
							SD2->( dBSkip( ) )
							
						Enddo
						
					EndIf
					
				Endif
				
			Endif
			
		EndIf

	// Guilherme 10/01/2014 para tratar quando o vendedor nao tem contrato
	Else
	
		If cORIGEM == "SC5"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do pedido de venda                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SC6" )
			SC6->( dBSetOrder( 1 ) )
			SC6->( dBGoTop( ) )
			If SC6->( dBSeek ( xFilial("SC6") + cNUMPED ) )
				While !SC6->( EOF( ) ) .AND. ( SC6->C6_FILIAL == xFilial("SC6") ) .AND. ( SC6->C6_NUM == cNUMPED )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro de produto.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dBSelectArea( "SB1" )
					SB1->( dbSetOrder( 1 ) )
					SB1->( dBGoTop( ) )
					SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) ) 
					If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )									
						If RecLock( "SC6", .F. )
							SC6->C6_COMIS5 := SC6->C6_COMIS1
							SC6->C6_COMIS1 := SB1->B1_COMIS
							SC6->(MsUnLock())
						EndIf															
					EndIf
			
					SC6->(dbSkip())										
				EndDo 
				
			EndIf
		    
	   		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do documento de saida                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SD2" )
			SD2->( dBSetOrder( 8 ) )	//D2_FILIAL+D2_PEDIDO+D2_ITEMPV
			SD2->( dbGoTop( ) )
			If SD2->( dBSeek ( xFilial("SD2") + cNUMPED ) )
				While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_PEDIDO == cNUMPED )
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro de produto.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dBSelectArea( "SB1" )
					SB1->( dBSetOrder( 1 ) )
					SB1->( dBGoTop( ) )
					SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
					If SB1->( dBSeek( xFilial( "SB1" ) + SD2->D2_COD ) )									
						If RecLock( "SD2", .F. )
							SD2->D2_COMIS5 := SD2->D2_COMIS1
							SD2->D2_COMIS1 := SB1->B1_COMIS
							SD2->(MsUnLock())	
						EndIf															
					EndIf					        
		        	SD2->(dBSkip())
				EndDo
			
			EndIf		
					
		ElseIf cORIGEM == "SL1"	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre venda - orçamento                                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SL1" )
			SL1->( dBSetOrder( 1 ) ) // L1_FILIAL+L1_NUM
			SL1->( dBGoTop( ) )
			If SL1->( MsSeek ( xFilial("SL1") + cNUMPED ) )
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Percorre itens da venda - orçamento                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dBSelectArea( "SL2" )
				SL2->( dBSetOrder( 3 ) ) //L2_FILIAL+L2_SERIE+L2_DOC+L2_PRODUTO
				SL2->( dBGoTop( ) )
				If SL2->( MsSeek ( xFilial("SC5") + cNUMPED ) )
					While !SL2->( EOF( ) ) .AND. ( SL2->L2_FILIAL == xFilial("SC5") ) .AND. ( SL2->L2_SERIE == SL1->L1_SERIE ) .AND. ( SL2->L2_DOC == SL1->L1_DOC )
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Posiciona sobre o cadastro de produto.                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						dBSelectArea( "SB1" )
						SB1->( dbSetOrder( 1 ) )
						SB1->( dBGoTop( ) )
						SB1->( dBSeek( xFilial( "SB1" ) + SL2->L2_PRODUTO ) )
						If SB1->( dBSeek( xFilial( "SB1" ) + SC6->C6_PRODUTO ) )									
							If RecLock( "SL1", .F. )
								SL1->L1_COMIS := SB1->B1_COMIS
								SL1->( MsUnLock( ) )
							EndIf									
							Exit										
						EndIf
						SL2->( dBSkip( ) )
					EndDo
				EndIf  									
			EndIf								
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do documento de saida                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dBSelectArea( "SD2" )
			SD2->( dBSetOrder( 3 ) )	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			SD2->( dbGoTop( ) )
			If SD2->( dBSeek ( xFilial("SD2") + SL1->L1_DOC + SL1->L1_SERIE + SL1->L1_CLIENTE + SL1->L1_LOJA ) )
				While !SD2->( EOF()) .AND. ( SD2->D2_FILIAL == xFilial("SD2") ) .AND. ( SD2->D2_DOC == SL1->L1_DOC ) .AND. ( SD2->D2_SERIE == SL1->L1_SERIE )  .AND. ( SD2->D2_CLIENTE == SL1->L1_CLIENTE ) .AND. ( SD2->D2_LOJA == SL1->L1_LOJA  )
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro de produto.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dBSelectArea( "SB1" )
					SB1->( dBSetOrder( 1 ) )
					SB1->( dBGoTop( ) )
					SB1->( dBSeek( xFilial("SB1") + SD2->D2_COD ) )
					If SB1->( dBSeek( xFilial( "SB1" ) + SD2->D2_COD ) )									
					  	If RecLock( "SD2", .F. )
							SD2->D2_COMIS5 := SD2->D2_COMIS1
							SD2->D2_COMIS1 := SB1->B1_COMIS
							SD2->(MsUnLock())	
						EndIf															
					EndIf
					SD2->( dBSkip( ) )
				EndDo					
		  	EndIF
		EndIf		
	
	EndIf
	
	TMPSC5->( dBSkip( ) )
Enddo

TMPSC5->(DbCloseArea())

Return

//-- ATUALIZACAO DA ALIQUOTA DE IPI SOBRE O CADASTRO DE PRODUTOS COM BASE NO CADASTRO DE INDICADORES
*------------------------*
User Function RJUPIPI()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar ALIQUOTA DE IPI?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| FJUPIPI() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*---------------------------*
Static Function FJUPIPI() 
*---------------------------*
Local nREG := 0

	dbSelectArea("SBZ")
	dbSetOrder(1)
	dbGoTop()
	dbSeek ( xFilial("SBZ") )
	While !SBZ->(EOF()) .and. SBZ->BZ_FILIAL == xFilial("SBZ")
		
		nREG += 1
		oProcUPD:IncRegua1("PRODUTO: " +SBZ->BZ_COD+ " - REGISTRO: "+ cValToChar(nREG) )
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("SB1")+SBZ->BZ_COD)			
			If SBZ->BZ_IPI != 0 .and. SB1->B1_IPI == 0
				If RecLock("SB1",.F.)
					SB1->B1_IPI := SBZ->BZ_IPI
					SB1->(MsUnLock())
				EndIf
			EndIf
		EndIf
		
		SBZ->(dbSkip())
	Enddo
		
Return



*------------------------*
User Function RJUPSEU()
*------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Atualiza codigo veiculo sobre viagem?","Atualização","YESNO") 

	dbSelectArea("SEU")
	dBSetOrder(1)
	dBGotop() 	
	While !SEU->(EOF())                                                       	
		If !Empty(SEU->EU_VIAGEM) .and. SubSTR(SEU->EU_CODDES,1,3) == "101"			
			dbSelectArea("DTR")
			dbSetOrder(1)
			dbGoTop() 
			If dbSeek(xFilial("DTR")+SEU->EU_FILORI+SEU->EU_VIAGEM)
				If RecLock("SEU",.F.)
					SEU->EU_CODVEI := DTR->DTR_CODVEI
					SEU->EU_NRREND := "VG:"+SEU->EU_VIAGEM
					SEU->EU_VIAGEM := Space(TAMSX3("EU_VIAGEM")[1])
					SEU->(MsUnLock())
				EndIf
			EndIf
		EndIf
		SEU->(dbSkip())
	Enddo
	
	Alert("Processo concluído!")
EndIf
                 

If MsgBox("Atualiza entidades contabeis da viagem?","Atualização","YESNO") 
	dbSelectArea("SEU")
	dBSetOrder(1)
	dBGotop() 	
	While !SEU->(EOF())                                                       	
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
						//SEU->EU_ITEMD  := DA3->DA3_X_ITEM 
						SEU->EU_CCD    := DA3->DA3_X_CC   
						SEU->(MsUnLock())
					EndIf
				EndIf
			EndIf
		EndIf
		
		If !Empty(SEU->EU_CODDES) .and. !Empty(SEU->EU_NROADIA)
	   		cCONTA := ""
	   		nRECNO := SEU->(RECNO())
			dbSelectArea("SEU")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("DA3") + SEU->EU_NROADIA )	
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
			
		
		SEU->(dbSkip())
	Enddo
	
	Alert("Processo concluído!")   
EndIf

Return    

*------------------------*
User Function RJUPTQN()
*------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Atualiza codigo veiculo sobre viagem?","Atualização","YESNO") 

	dbSelectArea("TQN")
	dBSetOrder(1)
	dBGotop() 	
	While !TQN->(EOF())                                                       	
		TQN->(dbSkip())
	Enddo
EndIf

Return

	
	
	

//-- ATUALIZACAO DE ENTIDADES CONTABEIS SOBRE COMISSOES
*------------------------*
User Function RJUPSE3()
*------------------------*
Private oProcUPD
Private cPERG := "RJUPSE3000"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar entidades contabeis sobre registros de comissões ?","Atualização","YESNO")                                            
    AjSX1SE3()
    Pergunte(cPERG,.T.)
	oProcUPD := MsNewProcess():New({|| FJUPSE3() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*---------------------------*
Static Function FJUPSE3() 
*---------------------------*
Local nREG := 0

	dbSelectArea("SE3")
	dbSetOrder(2)
	dbGoTop()
	If Empty(mv_par01)
		cSEEK := xFilial("SE3")
	Else
		cSEEK := xFilial("SE3") + mv_par01
	EndIf
	dbSeek ( cSEEK )
	While !SE3->(EOF()) .and. SE3->E3_FILIAL == xFilial("SE3") .and. SE3->E3_VEND <= mv_par02
		
		If Empty(SE3->E3_CLVLDB) .OR. Empty(SE3->E3_CCD)
		
			nREG += 1
			oProcUPD:IncRegua1("DOCUMENTO: "+SE3->E3_PREFIXO+"/"+SE3->E3_NUM+ " - REGISTRO: "+ cValToChar(nREG) )
			
			
			If ALLTRIM(SE3->E3_TIPO) == "NF"	
				
				dbSelectArea("SD2")
				dbSetOrder(3)
				dbGoTop()
				If dbSeek(xFilial("SD2")+SE3->E3_NUM+SE3->E3_PREFIXO)			
					If !Empty(SD2->D2_CLVL)
						If RecLock("SE3",.F.)
							SE3->E3_CLVLDB := SD2->D2_CLVL
							SE3->E3_CCD    := SD2->D2_CCUSTO
							SE3->(MsUnLock())
						EndIf
					EndIf
				EndIf
			
			ElseIf ALLTRIM(SE3->E3_TIPO) == "NCC"
	
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("SD1")+SE3->E3_NUM+SE3->E3_PREFIXO+SE3->E3_CODCLI+SE3->E3_LOJA)				
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbGoTop()
					If dbSeek(xFilial("SD1")+SD1->D1_NFORI+SD1->D1_SERIORI)					
						If !Empty(SD2->D2_CLVL)
							If RecLock("SE3",.F.)
								SE3->E3_CLVLDB := SD2->D2_CLVL
								SE3->E3_CCD    := SD2->D2_CCUSTO
								SE3->(MsUnLock())
							EndIf
						EndIf
					EndIf
				EndIf
				
			ElseIf ALLTRIM(SE3->E3_TIPO) == "FT" .or. ALLTRIM(SE3->E3_TIPO) == "CH"
	
				dbSelectArea("SE1")
				dbSetOrder(2)
				dbGoTop()
				If dbSeek(xFilial("SE1")+SE3->E3_CODCLI+SE3->E3_LOJA+SE3->E3_PREFIXO+SE3->E3_NUM)				
					If !Empty(SE1->E1_CLVLCR)
						If RecLock("SE3",.F.)
							SE3->E3_CLVLDB := SE1->E1_CLVLCR
							SE3->E3_CCD    := SE1->E1_CCC
							SE3->(MsUnLock())
						EndIf
					EndIf
					
				EndIf
			EndIf  
		
		EndIf
		
		SE3->(dbSkip())
	Enddo
		
Return	     


*--------------------------*
Static Function AjSX1SE3()
*--------------------------*
aRegs  := {} 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Vendedor De         ?","Vendedor De         ?","Vendedor De         ?","mv_ch1","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"02","Vendedor Ate        ?","Vendedor Ate        ?","Vendedor Ate        ?","mv_ch2","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil





//-- AJUSTES SOBRE TES DE VENDAS SIGALOJA
*------------------------*
User Function RJUPTES()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar TES S/ VENDAS?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| FJUPTES() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif

*---------------------------*
Static Function FJUPTES() 
*---------------------------*
Local nREG := 0
Local aFILIAL := {}
Local cXLJIPI := GETMV("MV_X_LJIPI")
Local cTESSAI := SuperGetMV("MV_TESSAI",,"501")

	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aFILIAL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	
	If Len(aFILIAL) > 0
		For nI := 1 To Len(aFILIAL)
		
			dbSelectArea("SD2")
			dbSetOrder(5)	//D2_FILIAL+DTOS(D2_EMISSAO)+D2_NUMSEQ 
			dbGoTop()
			dbSeek ( aFILIAL[nI,01] + "20110302" )
			While !SD2->(EOF()) .and. SD2->D2_FILIAL == aFILIAL[nI,01] .and. SD2->D2_EMISSAO <= ctod("04/03/2011")
		
				If SD2->D2_TES == "704" .and. !EMPTY(SD2->D2_PDV)
				
					nREG += 1
					oProcUPD:IncRegua1("DOC/ITEM: " +SD2->D2_DOC+"/"+SD2->D2_ITEM +" - REGISTRO: "+ cValToChar(nREG) )
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbGoTop()
					dbSeek( xFilial("SB1") + SD2->D2_COD )			
						
					dbSelectArea("SBZ")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek( aFILIAL[nI,01] + SD2->D2_COD )			
						If Empty(SB1->B1_IPI) .AND. ! SubSTR(SB1->B1_GRUPO,1,2) $ cXLJIPI
							If RecLock("SD2",.F.)
								SD2->D2_OP  := SD2->D2_TES
								SD2->D2_TES := SBZ->BZ_TS
								SD2->(MsUnLock())
								
								If SD2->D2_TES == "508"
									If RecLock("SD2",.F.) 
										SD2->D2_OP  := ""
										SD2->D2_VALICM := 0
										SD2->D2_VALIPI := 0
										SD2->D2_BASEICM := 0
										SD2->D2_BASEIPI := 0
										SD2->D2_BASIMP4 := 0										
										SD2->D2_BASIMP5 := 0										
										SD2->D2_BASIMP6 := 0																														
										SD2->D2_ALQIMP4 := 0										
										SD2->D2_ALQIMP5 := 0
										SD2->D2_ALQIMP6 := 0
										SD2->D2_VALIMP4 := 0
										SD2->D2_VALIMP5 := 0
										SD2->D2_VALIMP6 := 0
										SD2->D2_CLASFIS := SB1->B1_ORIGEM + "40"
										SD2->(MsUnLock())
									EndIf
								EndIf
								
							EndIf     
						EndIf
					EndIf
				
				EndIf				
				SD2->(dbSkip())
				
			Enddo
		
		Next nI
	EndIf
	
	Alert("registros processados: "+cValToChar(nREG))
		
Return  




//-- AJUSTES SOBRE TES DE VENDAS SIGALOJA
*------------------------*
User Function RJUPDECP()
*------------------------*
Private oProcUPD

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar titulos a pagar com contratos de descontos de fornecedores?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| FJUPDECP() },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")

Endif




*--------------------------*
Static Function FJUPDECP()
*--------------------------*
Local aArea := GetArea()
Local nATUREG := 0
Local nTOTDES := 0 
Local nNUMTIT := 0
Local nVALTOT := 0
Local aFILIAL := {}
Local cCODDES := ""
Local lFOUNDR := .F.  

	/*
	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO == cEmpAnt
			aAdd ( aFILIAL, { SM0->M0_CODFIL } )
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)
	*/

	aAdd ( aFILIAL, { "06" } )

	
	If Len(aFILIAL) > 0
		For nI := 1 To Len(aFILIAL)

			dbSelectArea("SF1")
			dbSetOrder(1)
			dbGoTop()
			dbSeek ( aFILIAL[nI,01] ) 		
			While !SF1->(EOF()) .and. SF1->F1_FILIAL == aFILIAL[nI,01]
				

				// Caso seja documento de Devolução/Beneficiamento
				If SF1->F1_TIPO $ "D/B"	.or. SF1->F1_EMISSAO <= ctod("28/02/2011")
					SF1->(dbSkip())
					Loop
				EndIf

				cCODDES := ""
				nTOTDES := 0 
				nNUMTIT := 0
				nVALTOT := 0
				lFOUNDR := .F.  
								
				cCodFil := aFILIAL[nI,01]
				cCodDoc := SF1->F1_DOC
				cCodSer := SF1->F1_SERIE
				cCodFor := SF1->F1_FORNECE
				cCodLoj	:= SF1->F1_LOJA

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica a existência de regra de bonificação por fornecedor + loja  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				dbSelectArea("Z30")	//CABECALHO DESCONTOS FIXOS FORN
				dbSetOrder(2)	//Z30_FILIAL+Z30_FORNEC+Z30_LOJFOR                                                                                                                               
				dbGoTop()
			    If dbSeek ( cCodFil + cCodFor + cCodLoj)
			    	While !Z30->(EOF()) .and. Z30->Z30_FILIAL == cCodFil .and. Z30->Z30_FORNEC == cCodFor .and. Z30->Z30_LOJFOR == cCodLoj
			    	    
			    		If Z30->Z30_ATIVO == "S"
			    			cCODDES := Z30->Z30_NUMERO
			    			lFOUNDR := .T.
			    			Exit
			    		EndIf
			    			
			    		Z30->(dbSkip())
			    	Enddo
			    	
			    ElseIf dbSeek ( cCodFil + cCodFor )
			    	
			    	While !Z30->(EOF()) .and. Z30->Z30_FILIAL == cCodFil .and. Z30->Z30_FORNEC == cCodFor
			    	    
			    	    If !Empty(Z30->Z30_LOJFOR) .and. Z30->Z30_LOJFOR != cCodLoj
			    	    	Z30->(dbSkip())
			    	    	Loop
			    	    EndIf
			    	        		
			    		If Z30->Z30_ATIVO == "S"
			    			cCODDES := Z30->Z30_NUMERO
			    			lFOUNDR := .T.
			    			Exit
			    		EndIf
			    			
			    		Z30->(dbSkip())
			    	Enddo    
			    	
			    EndIf
			
			
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se encontrou a regra de bonificação              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
			 
			    If lFOUNDR
			 
			
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se regra ativa e dentro do intervalo de datas    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea("Z30")	//CABECALHO BONIFICACOES PEDIDOS
					dbSetOrder(1)	//Z30_FILIAL+Z30_NUMERO 
					dbGoTop()
				    dbSeek ( cCodFil + cCODDES )	
			    	If Z30->Z30_ATIVO == "S" .and. SF1->F1_EMISSAO >= Z30->Z30_DATINI .and. SF1->F1_EMISSAO <= Z30->Z30_DATFIN  
					          
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Percorre itens da nota fiscal e calcula valor da bonificação      ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
					                                                       
						dbSelectArea("SD1")
						dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
						dbGoTop()
						If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj )
							While !SD1->(EOF()) .and. SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA == cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj
								
								dbSelectArea("Z31")	//ITENS DESCONTOS FIXOS FORN    
								dbSetOrder(2)	//Z31_FILIAL+Z31_NUMERO+Z31_CODPRD                                                                                                                                
								dbGoTop()
								If dbSeek ( cCodFil + cCODDES + SD1->D1_COD ) 
								
									nTOTDES += Round( ( SD1->D1_TOTAL * Z31->Z31_PERDES ) / 100, 2 )
								
								Else
								 
									dbSelectArea("Z31")	//ITENS DESCONTOS FIXOS FORN    
									dbSetOrder(1)	//Z31_FILIAL+Z31_NUMERO+Z31_CODGRP
									dbGoTop()
									If dbSeek ( cCodFil + cCODDES + SD1->D1_GRUPO ) 
									
										nTOTDES += Round( ( SD1->D1_TOTAL * Z31->Z31_PERDES ) / 100, 2 )
									
									EndIf
								EndIf
								
								SD1->(dbSkip())
							Enddo		
						EndIf
						          
						If nTOTDES != 0
				
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								    
							nNUMTIT := 0
							nVALTOT := 0
							dbSelectArea("SE2")
							dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO 	
							dbGoTop()
							If dbSeek ( cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc )
								While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == cCodFil+cCodFor+cCodLoj+cCodSer+cCodDoc
									nNUMTIT += 1
									nVALTOT += SE2->E2_SALDO
									SE2->(dbSkip())
								Enddo
							EndIf
							   
							Begin Transaction
							
								dbSelectArea("SE2")
								dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO 	
								dbGoTop()
								If dbSeek ( cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc )
									While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == cCodFil+cCodFor+cCodLoj+cCodSer+cCodDoc
			 							If SE2->E2_SALDO == SE2->E2_VALOR
				 							If RecLock("SE2", .F.)
												
												//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
												//³ Atualiza desconto sobre título...  ³
												//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
												SE2->E2_DECRESC := Round ( ( nTOTDES * SE2->E2_SALDO ) / nVALTOT, 2 ) 
												SE2->E2_SDDECRE := SE2->E2_DECRESC
											
												SE2->(MsUnLock()) 
												nATUREG += 1
												
											EndIf
										EndIf
										SE2->(dbSkip())
									Enddo
								EndIf
							
							End Transaction
						
						EndIf
					
					EndIf
					
				EndIf
				
				SF1->(dbSkip())
			Enddo
		Next nI
	EndIf
	
	Alert("registros atualizados: "+STR(nATUREG))
			
Return   


//-- AJUSTES SOBRE ENTIDADES CONTABEIS-MANUTENCAO DE ATIVOS
*------------------------*
User Function RJUPDCT9()
*------------------------*
Private oProcUPD
Private nRecATU := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Ajustar entidades contábeis das movimentações do módulo de manutenção de ativos?","Atualização","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| FJUPDCT9(@nRecATU) },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído! Número de registros processados: "+cValToChar(nRecATU))

Endif
*-----------------------------------*
Static Function FJUPDCT9(nRecATU)
*-----------------------------------*

	dbSelectArea("STJ")
	dbSetOrder(1)
	dbGoTop()
	While ! STJ->(EOF())
		dbSelectArea("ST9")
		dbSetOrder(1)
		If dbSeek( xFilial("ST9")+STJ->TJ_CODBEM )
			dbSelectArea("SD3")
			dbSetOrder(11)
			If dbSeek( STJ->(TJ_FILIAL+TJ_ORDEM) )
				While !SD3->(EOF()) .and. SD3->(D3_FILIAL+D3_ORDEM) == STJ->(TJ_FILIAL+TJ_ORDEM)
					If SD3->D3_CF == "RE0" .and. ALLTRIM(SD3->D3_COD) != "98010006" .and. Empty(SD3->D3_CLVL)
						If RecLock("SD3",.F.)
							SD3->D3_CLVL := ST9->T9_X_CLVL
							SD3->(MsUnLock())
							nRecATU+= 1
						EndIf
					EndIf
					SD3->(dbSkip())
				Enddo
			EndIf
		EndIf
		STJ->(dbSkip())
	Enddo

Return



//-- ESTORNO DE MOVIMENTACOES SAG
*--------------------------*
User Function RJUEXD3SAG()
*--------------------------*
Private oProcUPD
Private nRecATU := 0
Private nRecERR := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Confirma estordo das movimentações SAG?","SAG","YESNO")                                            

	oProcUPD := MsNewProcess():New({|| FJUEXD3SAG(@nRecATU,@nRecERR) },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído! Número de registros processados OK: "+cValToChar(nRecATU)+" KO: "+cValToChar(nRecERR))

Endif
*------------------------------------*
Static Function FJUEXD3SAG(nRecATU,nRecERR)
*------------------------------------*
Private lMsErroAuto := .F.
    
	dbSelectArea("SD3")
	dbSetOrder(6)	//--D3_FILIAL+DTOS(D3_EMISSAO)+D3_NUMSEQ+D3_CHAVE+D3_COD
	dbGoTop()
	dbSeek ( "04" + "20110929" )
	While !SD3->(EOF()) .AND. SD3->D3_FILIAL == "04" .AND. DTOS(SD3->D3_EMISSAO) >= "20110928" 

		If SD3->D3_TM $ "510/511/110"
			
			lMsErroAuto := .F.
			
			aArraySD3 	:= {	{"D3_FILIAL"	,SD3->D3_FILIAL		,Nil},;
								{"D3_TM"		,SD3->D3_TM			,Nil},;
								{"D3_COD"		,SD3->D3_COD		,Nil},;
								{"D3_QUANT"		,SD3->D3_QUANT		,Nil},;
								{"D3_LOCAL"		,SD3->D3_LOCAL		,Nil},;
								{"D3_CHAVE"		,SD3->D3_CHAVE		,Nil},;								
								{"D3_EMISSAO"	,SD3->D3_EMISSAO	,Nil},;
								{"D3_NUMSEQ"	,SD3->D3_NUMSEQ		,Nil},;
								{"INDEX"		,4					,Nil} }
							
			MATA240(aArraySD3,5)
			
			If !lMsErroAuto
				nRecATU += 1
			Else
				nRecERR += 1
			EndIf
		EndIf
		
		SD3->(dbSkip())
	Enddo
	
Return



//-- ESTORNO DE MOVIMENTACOES SAG
*--------------------------*
User Function RJDELD3SAG()
*--------------------------*
Private oProcUPD
Private cPERGSX1 := "RJDELD3SAG"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If ALLTRIM(UPPER(CUSERNAME)) == "SOLANGE"
		AjSX1SD3(cPERGSX1)
		If Pergunte(cPERGSX1,.T.)
			If MsgBox("Confirma a exclusão FÍSICA dos movimentos internos do SAG (110/111/510/511) para filial 04 empresa 50 conforme parâmetros informados?","SAG","YESNO")                                            
				oProcUPD := MsNewProcess():New({|| FDELD3SAG() },"Atualizando registros... " ,"Aguarde!",.F.)
				oProcUPD:Activate()
				MsgInfo("Processo concluído! Deverão ser executadas as rotinas de acerto do saldo atual e recálculo do custo médio.")
			Endif                 
		EndIf
	Else        
		MsgInfo("Usuário sem permissão para executar esta rotina!")
	EndIf

Return

*------------------------------------*
Static Function FDELD3SAG()
*------------------------------------*

	cQuery := " DELETE FROM SD3500 WHERE D3_FILIAL = '04' "
	cQuery += " AND D3_COD BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cQuery += " AND D3_TM IN ('510','511','110','111') 
	cQuery += " AND D3_EMISSAO BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "
	TCSQLEXEC(cQuery)
	
Return

*--------------------------*
Static Function AjSX1SD3(cPERGSX1)
*--------------------------*
aRegs  := {}          

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPERGSX1,"01","Produto De          ?","Produto De          ?","Produto De          ?","mv_ch1","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","",""})
	aAdd(aRegs,{cPERGSX1,"02","Produtor Até        ?","Produtor Até        ?","Produtor Até        ?","mv_ch2","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","",""})
	aAdd(aRegs,{cPERGSX1,"03","Data De             ?","Data De             ?","Data De             ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPERGSX1,"04","Data Até            ?","Data Até            ?","Data Até            ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	

	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPERGSX1 + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ajustaSX1 ºAutor  ³ Roberto Rosin      º Data ³ 19/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cria o grupo de perguntas para o ajuste de comissão do ven-º±±
±±º          ³ dedor.                                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function ajustaSX1(cPerg)
	
	PutSx1(cPerg,"01","Vendedor"          ,"Vendedor"         ,"Vendedor"         ,"mv_ch1","C",TAMSX3("A3_COD")[1],0,0,"G","","SA3","","","mv_par01")
	PutSx1(cPerg,"02","Vendedor"          ,"Vendedor"         ,"Vendedor"         ,"mv_ch2","C",TAMSX3("A3_COD")[1],0,0,"G","","SA3","","","mv_par02")
	PutSx1(cPerg,"03","Data de"           ,"Data de"          ,"Data de"          ,"mv_ch3","D",                 08,0,0,"G","","   ","","","mv_par03")
	PutSx1(cPerg,"04","Data até"          ,"Data até"         ,"Data até"         ,"mv_ch4","D",                 08,0,0,"G","","   ","","","mv_par04")
	
return