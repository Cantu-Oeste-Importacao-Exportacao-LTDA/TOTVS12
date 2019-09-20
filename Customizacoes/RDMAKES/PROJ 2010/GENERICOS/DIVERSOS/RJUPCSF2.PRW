#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/** AJUSTE PIS/COFINS SOBRE REGISTROS DE VENDAS **/
*-------------------------------*
User Function RJUPCSF2()
*-------------------------------*
Private cArqTxt := "\system\rjupcsf2_"+cEmpAnt+"_"+dtos(ddatabase)+"_"+strtran(time(),":","")+".log"
Private cPerg := "RJUPCSF200"
Private nHdl
Public cMarca := GetMark() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
    
	Aviso("Atenção","Este programa tem por objetivo zerar os valores de PIS/COFINS sobre itens de documentos de saída, conforme produtos selecionados.",{"OK"},2)
	AjSX1PC()
	If Pergunte(cPerg,.T.)
		nHdl := fCreate(cArqTxt)
		If nHdl != -1
			fSelReg(mv_par01, mv_par02)
			fClose(nHdl)
		Else
			Alert("Impossível criar arquivo de log.")
		EndIf				
	EndIf           

		
Return


*-----------------------------*
Static Function AjSX1PC()
*-----------------------------*
aRegs  := {} 
aAdd(aRegs,{cPerg,"01","Grupo De        ?","Grupo De        ?","Grupo De        ?","mv_ch1","C",TAMSX3("B1_GRUPO")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})
aAdd(aRegs,{cPerg,"02","Grupo Ate       ?","Grupo Ate       ?","Grupo Ate       ?","mv_ch2","C",TAMSX3("B1_GRUPO")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})

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

*------------------------------------------*
Static Function fSelReg(cGRPDE,cGRPAT)
*------------------------------------------*
Local cAliasTMP := GetNextAlias()
Private aDADOSPRD := {}

	cQuery := "	SELECT B1_COD, B1_DESC FROM " + RetSQLName("SB1") + " WHERE B1_GRUPO BETWEEN '"+cGRPDE+"' AND '"+cGRPAT+"' AND D_E_L_E_T_ != '*' "
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		aAdd ( aDADOSPRD, { (cAliasTMP)->B1_COD , (cAliasTMP)->B1_DESC } )		
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	If Len(aDADOSPRD) > 0
		U_fWinFIL(aDADOSPRD)
	Else
		Alert("Nenhum registro selecionado.")
	EndIf

Return



*---------------------------------*
User Function fWinFIL(aDADOSPRD)     
*---------------------------------* 
Private aArea     := GetArea()
Private cEMPEXEC  := cEmpAnt
Private nOpcao    := 0
Private aCampos   := {}
Private lInverte  := .F.    
Private cDlgTitle := "Selecionar Produtos"
Private oDlgFIL      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())



	aStruct := {}
	aAdd( aStruct, {"TMP_OK"  ,"C", 02, 0} )
	aAdd( aStruct, {"TMP_COD" ,"C", 15, 0} )
	aAdd( aStruct, {"TMP_DES" ,"C", 60, 0} )

	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,"TMPSF2", .F.,.F. )
	dbSelectArea("TMPSF2")
	Index on TMP_COD to &cArqTrab


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza temporarios                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aDADOSPRD) > 0
		For nINDFIL := 1 to Len(aDADOSPRD)
		    dbSelectArea("TMPSF2")
		    RecLock("TMPSF2",.T.)
		    TMPSF2->TMP_OK	:= Space(02)
		    TMPSF2->TMP_COD	:= aDADOSPRD[nINDFIL,01]
		    TMPSF2->TMP_DES	:= aDADOSPRD[nINDFIL,02]
		    MsUnLock("TMPSF2")
		Next nINDFIL
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos para mostrar no BROWSE padrao                      ³
	//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AADD(aCampos,{"TMP_OK"  ,"" ," "          ," " })
	AADD(aCampos,{"TMP_COD" ,"" ,"Código"     ," " })
	AADD(aCampos,{"TMP_DES" ,"" ,"Descrição"  ," " })


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria dialogo para usuario selecionar as filiais   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("TMPSF2")
	dbGoTop()

	DEFINE MSDIALOG oDlgFIL TITLE cDlgTitle From 1,1 To 400,500 OF oMainWnd PIXEL
	
	oMark := MsSelect():New("TMPSF2","TMP_OK",,aCampos,@lInverte,@cMarca,{1,1,180,250})
          
	@ 190,140 BMPBUTTON TYPE 1 ACTION (nOpcao := 1, Close(oDlgFIL) )
	@ 190,170 BMPBUTTON TYPE 2 ACTION (nOpcao := 2, Close(oDlgFIL) )

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fRegSel(oMark, cMarca, oDlgFIL)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(oMark, cMarca, oDlgFIL)}


	ACTIVATE MSDIALOG oDlgFIL CENTERED


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa filiais selecionadas                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If nOpcao == 1
	   	aPRODUTOS := {}
	   	dbSelectArea("TMPSF2")
		dbGoTop()
		While !EOF()
	    	If ! Empty(TMPSF2->TMP_OK)
	    		aAdd ( aPRODUTOS, TMPSF2->TMP_COD )
	    	EndIf
	    	dbSkip()
	 	Enddo          
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha alias temporarios                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	dbSelectArea("TMPSF2")
	dbCloseArea("TMPSF2")
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*")
	
	If nOpcao == 1 .and. Len(aPRODUTOS) > 0
		oProcUPD := MsNewProcess():New({|| fRJUPCSF2(aPRODUTOS) },"Atualizando registros "+cEmpAnt+" " ,"Aguarde!",.F.)
		oProcUPD:Activate()
		MsgInfo("Processo concluído!")	
	Else
		Alert("Nenhum produto foi selecionado.")
	EndIf
	
	RestArea(aArea) 
	
Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-----------------------------------------------*
Static Function fRegSel(oMark, cMarca, oDlgFIL)
*-----------------------------------------------*

	If Marked("TMP_OK")
		RecLock("TMPSF2",.F.)
		Replace TMPSF2->TMP_OK With cMarca
		MsUnlock()
	Else
		RecLock("TMPSF2",.F.)
		Replace TMPSF2->TMP_OK With Space(02)
		MsUnlock()
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oDlgFIL:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marcador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*------------------------------------------------*
Static Function fMarkAll(oMark, cMarca, oDlgFIL)
*------------------------------------------------*
Local nREC := Recno()    
    
	dbGoTop()
	While !EOF()
		RecLock("TMPSF2",.F.)
		If Empty(TMPSF2->TMP_OK)
			Replace TMPSF2->TMP_OK With cMarca
		Else
			Replace TMPSF2->TMP_OK With Space(02)
		Endif
		MsUnlock()
		dbSkip()
	EndDo  
	
	dbGoTo(nREC)
	oMark:oBrowse:Refresh(.t.)
	oDlgFIL:Refresh()

Return .T. 


*------------------------------------------------*
Static Function fRJUPCSF2(aPRODUTOS)              
*------------------------------------------------*
                     
	For nW := 1 to Len(aPRODUTOS)
	
		dbSelectArea("SD2")
		dbSetOrder(1)
		dbGoTop()
		dbSeek( xFilial("SD2") + aPRODUTOS[nW] )        
		While !SD2->(EOF()) .and. SD2->D2_FILIAL == xFilial("SD2") .and. SD2->D2_COD == aPRODUTOS[nW]
			
			oProcUPD:IncRegua1("FILIAL: "+cFilAnt+" - DOCUMENTO: "+SD2->D2_DOC+"/"+SD2->D2_SERIE+" - PRODUTO: "+SD2->D2_COD)
			cLIN := "SD2;" + SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM + SD2->D2_COD + ";"
			cLIN += cValToChar(SD2->D2_VALIMP5) + ";"
			cLIN += cValToChar(SD2->D2_VALIMP6) + ";"
			cLIN += cValToChar(SD2->D2_BASIMP5) + ";"
			cLIN += cValToChar(SD2->D2_BASIMP6) + ";" + chr(10)+chr(13)						
			
			fWrite(nHdl,cLin,Len(cLin))
			
			If RecLock("SD2",.F.)
				SD2->D2_VALIMP5 := 0
				SD2->D2_VALIMP6 := 0
				SD2->D2_BASIMP5 := 0
				SD2->D2_BASIMP6 := 0
				SD2->(MsUnLock())
			EndIf
			
			dbSelectArea("SFT")
			dbSetOrder(1)//-- FT_FILIAL+FT_TIPOMOV+FT_SERIE+FT_NFISCAL+FT_CLIEFOR+FT_LOJA+FT_ITEM+FT_PRODUTO
			dbGoTop() 			
			If dbSeek( xFilial("SFT") + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM )        

				cLIN := "SFT;" + xFilial("SFT") + "S" + SD2->D2_SERIE + SD2->D2_DOC + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_ITEM + ";"
				cLIN += cValToChar(SFT->FT_VALCOF) + ";"
				cLIN += cValToChar(SFT->FT_VALPIS) + ";"
				cLIN += cValToChar(SFT->FT_BASEPIS) + ";"
				cLIN += cValToChar(SFT->FT_BASECOF) + ";" 
				cLIN += SFT->FT_CSTCOF + ";"
				cLIN += SFT->FT_CSTPIS + ";" + chr(10)+chr(13)						
				
				fWrite(nHdl,cLin,Len(cLin))
	
				If RecLock("SFT",.F.)
					SFT->FT_VALCOF  := 0
					SFT->FT_VALPIS  := 0
					SFT->FT_BASEPIS := 0
					SFT->FT_BASECOF := 0
					SFT->FT_CSTCOF  := "06" // Codigo da Situação Tributaria do Cofins (Aliquota Zero)
					SFT->FT_CSTPIS  := "06" // Codigo da Situação Tributaria do PIS (Aliquota Zero)
					SFT->(MsUnLock())
				EndIf
			EndIf
									
			SD2->(dbSkip())
		Enddo

	Next nW
	
Return