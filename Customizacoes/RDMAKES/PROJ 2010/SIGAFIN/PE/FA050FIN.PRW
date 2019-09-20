#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA050FIN    ºAutor  ³Rafael Parma      º Data ³  29/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para tratamento de campo customizado quando campo título º±±
±±º          ³com prefixo "REB", seleção de título correspondente CR.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-------------------------------*
User Function FA050FIN()
*-------------------------------*
Private aArea   := GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If SE2->E2_PREFIXO == "REB"
	
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA )
			fMarkSE1()
		Endif			
	EndIf

	RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMarkSE1    ºAutor  ³Rafael Parma      º Data ³  29/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para tratamento de campo customizado quando campo título º±±
±±º          ³com prefixo "REB", seleção de título correspondente CR.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*---------------------------------*
Static Function fMarkSE1()     
*---------------------------------* 
Private cAliasTMP := GetNextAlias()
Private nOpcao    := 0
Private aCampos   := {}
Private aDADOSTIT := {}
Private lInverte  := .F.    
Private cDlgTitle := "Selecionar título de origem"
Private oDlgFIL


	cQuery := "	SELECT												"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_PREFIXO,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_NUM,										"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_PARCELA,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_TIPO,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_CLIENTE,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_LOJA,									"+CHR(10)+CHR(13)
	cQuery += "		SA1.A1_NOME,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_VALOR,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_VENCREA									"+CHR(10)+CHR(13)								
	cQuery += "	FROM " + RetSQLName("SE1") + " SE1          		"+CHR(10)+CHR(13)
	cQuery += "	INNER JOIN " + RetSQLName("SA1") + " SA1			"+CHR(10)+CHR(13)
	cQuery += "	ON 	SE1.E1_CLIENTE = SA1.A1_COD						"+CHR(10)+CHR(13)
	cQuery += "	AND	SE1.E1_LOJA    = SA1.A1_LOJA					"+CHR(10)+CHR(13)	
	cQuery += "	WHERE												"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_FILIAL  = '"+xFilial("SE1")+"'			"+CHR(10)+CHR(13)
	cQuery += " AND	SA1.A1_CGC     = '"+SA2->A2_CGC+"'     			"+CHR(10)+CHR(13)
	cQuery += " AND	SE1.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)
	cQuery += " AND	SA1.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)	
	cQuery += " ORDER BY											"+CHR(10)+CHR(13)	
	cQuery += "		SE1.E1_PREFIXO,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_NUM, 									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_PARCELA,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE1.E1_VENCREA									"+CHR(10)+CHR(13)								
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		aAdd ( aDADOSTIT, { (cAliasTMP)->E1_PREFIXO,;
							(cAliasTMP)->E1_NUM,	;
							(cAliasTMP)->E1_PARCELA,;
							(cAliasTMP)->E1_TIPO,	;							
							(cAliasTMP)->E1_CLIENTE,;
							(cAliasTMP)->E1_LOJA,	;
							(cAliasTMP)->A1_NOME,	;
							(cAliasTMP)->E1_VALOR,	;
							(cAliasTMP)->E1_EMISSAO,;
							(cAliasTMP)->E1_VENCREA } )
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	

	If Len(aDADOSTIT) > 0
	
		aStruct := {}
		aAdd( aStruct, {"E1_OK"  	 ,"C", 02, 0} )
		aAdd( aStruct, {"E1_PREFIXO" ,"C", TAMSX3("E1_PREFIXO")[1], 0} )
		aAdd( aStruct, {"E1_NUM" 	 ,"C", TAMSX3("E1_NUM")[1], 	0} )
		aAdd( aStruct, {"E1_PARCELA" ,"C", TAMSX3("E1_PARCELA")[1], 0} )
		aAdd( aStruct, {"E1_TIPO" 	 ,"C", TAMSX3("E1_TIPO")[1], 	0} )
		aAdd( aStruct, {"E1_CLIENTE" ,"C", TAMSX3("E1_CLIENTE")[1], 0} )
		aAdd( aStruct, {"E1_LOJA" 	 ,"C", TAMSX3("E1_LOJA")[1], 	0} )
		aAdd( aStruct, {"A1_NOME" 	 ,"C", TAMSX3("A1_NOME")[1], 	0} )
		aAdd( aStruct, {"E1_VALOR" 	 ,"N", TAMSX3("E1_VALOR")[1], TAMSX3("E1_VALOR")[2]} )
		aAdd( aStruct, {"E1_EMISSAO" ,"D", 8, 0} )
		aAdd( aStruct, {"E1_VENCREA" ,"D", 8, 0} )		
	
		cArqTrab := CriaTrab(aStruct, .T.)
		dbUseArea(.T.,, cArqTrab ,"TMPSE1", .F.,.F. )
		dbSelectArea("TMPSE1")
		Index on E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA to &cArqTrab
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza temporarios                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		For nINDFIL := 1 to Len(aDADOSTIT)
		    dbSelectArea("TMPSE1")
		    RecLock("TMPSE1",.T.)
		    TMPSE1->E1_OK	:= Space(02)
		    TMPSE1->E1_PREFIXO	:= aDADOSTIT[nINDFIL,01]
		    TMPSE1->E1_NUM		:= aDADOSTIT[nINDFIL,02]
		    TMPSE1->E1_PARCELA	:= aDADOSTIT[nINDFIL,03]
		    TMPSE1->E1_TIPO		:= aDADOSTIT[nINDFIL,04]		    		    
		    TMPSE1->E1_CLIENTE	:= aDADOSTIT[nINDFIL,05]
		    TMPSE1->E1_LOJA		:= aDADOSTIT[nINDFIL,06]
		    TMPSE1->A1_NOME		:= aDADOSTIT[nINDFIL,07]		    		    
		    TMPSE1->E1_VALOR	:= aDADOSTIT[nINDFIL,08]
		    TMPSE1->E1_EMISSAO	:= stod(aDADOSTIT[nINDFIL,09])
		    TMPSE1->E1_VENCREA	:= stod(aDADOSTIT[nINDFIL,10])
		    MsUnLock("TMPSE1")
		Next nINDFIL
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos para mostrar no BROWSE padrao                      ³
		//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		AADD(aCampos,{"E1_OK"  		,"" 	," "        	," " })
		AADD(aCampos,{"E1_PREFIXO"	,"" 	,"Prefixo"  	," " })
		AADD(aCampos,{"E1_NUM" 		,"" 	,"Número"  		," " })
		AADD(aCampos,{"E1_PARCELA"	,""		,"Parcela"  	," " })
		AADD(aCampos,{"E1_TIPO"		,"" 	,"Tipo"  		," " })
		AADD(aCampos,{"E1_CLIENTE"	,"" 	,"Cliente"  	," " })
		AADD(aCampos,{"E1_LOJA"		,"" 	,"Loja"  		," " })
		AADD(aCampos,{"A1_NOME"		,"" 	,"Nome"  		," " })
		AADD(aCampos,{"E1_VALOR"	,"" 	,"Valor"  		," " })
		AADD(aCampos,{"E1_EMISSAO"	,"" 	,"Emissão"  	," " })
		AADD(aCampos,{"E1_VENCREA"	,"" 	,"Vencimento"  	," " })
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria dialogo para usuario selecionar as filiais   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("TMPSE1")
		dbGoTop()
	
		DEFINE MSDIALOG oDlgFIL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
		
		oMark := MsSelect():New("TMPSE1","E1_OK",,aCampos,@lInverte,@cMarca,{1,1,180,350})
	          
		@ 185,270 BMPBUTTON TYPE 1 ACTION (nOpcao := 1, Close(oDlgFIL) )
		@ 185,300 BMPBUTTON TYPE 2 ACTION (nOpcao := 2, Close(oDlgFIL) )
	
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
		   	aDADOSTIT := {}
		   	dbSelectArea("TMPSE1")
			dbGoTop()
			While ! TMPSE1->(EOF())
		    	If ! Empty(TMPSE1->E1_OK)   	    	
		    		If RecLock("SE2",.F.)
		    			SE2->E2_X_TPPCO := xFilial("SE2")+TMPSE1->E1_PREFIXO+TMPSE1->E1_NUM+TMPSE1->E1_PARCELA+TMPSE1->E1_TIPO+TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA
		    			SE2->(MsUnLock())  
		    			DbSelectArea("SE1")
						DbSetOrder(1)
						DbGoTop()
						If DbSeek(SE2->E2_X_TPPCO)	
							PCOINILAN("999007")
							Begin Transaction
								PCODETLAN("999007","01","FA050FIN")
							End Transaction
							PCOFINLAN("999007")										
						EndIf			
		    			Exit
		    		EndIf	    		
		    	EndIf
		    	TMPSE1->(dbSkip())
		 	Enddo          
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha alias temporarios                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		dbSelectArea("TMPSE1")
		dbCloseArea("TMPSE1")
		FErase(cArqTrab+OrdBagExt())
		FErase(cArqTrab+".*")   
		
	EndIf
			
Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-----------------------------------------------*
Static Function fRegSel(oMark, cMarca, oDlgFIL)
*-----------------------------------------------*
Local lMark := .F.
Local nREC := TMPSE1->(RECNO())

	If Marked("E1_OK")
		dbGoTop()
		While !EOF()  
			If nREC != TMPSE1->(RECNO())
				If TMPSE1->E1_OK != Space(02)
					lMark := .T.
					Exit
				EndIf
			EndIf
			dbSkip()
		EndDo
		If lMark
			Alert("Já existe registro selecionado, deve ser informado apenas um título!")		
			dbGoTop()
			While !EOF()
				RecLock("TMPSE1",.F.)
				Replace TMPSE1->E1_OK With Space(02)
				MsUnlock()
				dbSkip()
			EndDo 
		EndIf
		dbGoTo(nREC)	  

	Else
		RecLock("TMPSE1",.F.)
		Replace TMPSE1->E1_OK With Space(02)
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

    Alert("Apenas um registro poderá ser selecionado!")
	oMark:oBrowse:Refresh(.t.)
	oDlgFIL:Refresh()

Return .T. 
