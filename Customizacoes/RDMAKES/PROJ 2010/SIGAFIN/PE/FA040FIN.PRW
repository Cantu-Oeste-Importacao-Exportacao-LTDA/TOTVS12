#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA040FIN    ºAutor  ³Rafael Parma      º Data ³  29/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para tratamento de campo customizado quando campo título º±±
±±º          ³com prefixo "REB", seleção de título correspondente CP.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-------------------------------*
User Function FA040FIN()
*-------------------------------*
Private aArea   := GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If SE1->E1_PREFIXO == "REB"
	
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA )
			fMarkSE2()
		Endif			
	EndIf

	RestArea(aArea)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fMarkSE2    ºAutor  ³Rafael Parma      º Data ³  29/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE para tratamento de campo customizado quando campo título º±±
±±º          ³com prefixo "REB", seleção de título correspondente CP.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*---------------------------------*
Static Function fMarkSE2()     
*---------------------------------* 
Private cAliasTMP := GetNextAlias()
Private nOpcao    := 0
Private aCampos   := {}
Private aDADOSTIT := {}
Private lInverte  := .F.    
Private cDlgTitle := "Selecionar título de origem"
Private oDlgFIL


	cQuery := "	SELECT												"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_PREFIXO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_NUM,										"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_PARCELA,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_TIPO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_FORNECE,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_LOJA,									"+CHR(10)+CHR(13)
	cQuery += "		SA2.A2_NOME,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VALOR,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VENCREA									"+CHR(10)+CHR(13)								
	cQuery += "	FROM " + RetSQLName("SE2") + " SE2          		"+CHR(10)+CHR(13)
	cQuery += "	INNER JOIN " + RetSQLName("SA2") + " SA2			"+CHR(10)+CHR(13)
	cQuery += "	ON 	SE2.E2_FORNECE = SA2.A2_COD						"+CHR(10)+CHR(13)
	cQuery += "	AND	SE2.E2_LOJA    = SA2.A2_LOJA					"+CHR(10)+CHR(13)	
	cQuery += "	WHERE												"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_FILIAL  = '"+xFilial("SE2")+"'			"+CHR(10)+CHR(13)
	cQuery += " AND	SA2.A2_CGC     = '"+SA1->A1_CGC+"'     			"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)
	cQuery += " AND	SA2.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)	
	cQuery += " ORDER BY											"+CHR(10)+CHR(13)	
	cQuery += "		SE2.E2_PREFIXO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_NUM, 									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_PARCELA,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VENCREA									"+CHR(10)+CHR(13)								
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		aAdd ( aDADOSTIT, { (cAliasTMP)->E2_PREFIXO,;
							(cAliasTMP)->E2_NUM,	;
							(cAliasTMP)->E2_PARCELA,;
							(cAliasTMP)->E2_TIPO,	;							
							(cAliasTMP)->E2_FORNECE,;
							(cAliasTMP)->E2_LOJA,	;
							(cAliasTMP)->A2_NOME,	;
							(cAliasTMP)->E2_VALOR,	;
							(cAliasTMP)->E2_EMISSAO,;
							(cAliasTMP)->E2_VENCREA } )
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	

	If Len(aDADOSTIT) > 0
	
		aStruct := {}
		aAdd( aStruct, {"E2_OK"  	 ,"C", 02, 0} )
		aAdd( aStruct, {"E2_PREFIXO" ,"C", TAMSX3("E2_PREFIXO")[1], 0} )
		aAdd( aStruct, {"E2_NUM" 	 ,"C", TAMSX3("E2_NUM")[1], 	0} )
		aAdd( aStruct, {"E2_PARCELA" ,"C", TAMSX3("E2_PARCELA")[1], 0} )
		aAdd( aStruct, {"E2_TIPO" 	 ,"C", TAMSX3("E2_TIPO")[1], 	0} )
		aAdd( aStruct, {"E2_FORNECE" ,"C", TAMSX3("E2_FORNECE")[1], 0} )
		aAdd( aStruct, {"E2_LOJA" 	 ,"C", TAMSX3("E2_LOJA")[1], 	0} )
		aAdd( aStruct, {"A2_NOME" 	 ,"C", TAMSX3("A2_NOME")[1], 	0} )
		aAdd( aStruct, {"E2_VALOR" 	 ,"N", TAMSX3("E2_VALOR")[1], TAMSX3("E2_VALOR")[2]} )
		aAdd( aStruct, {"E2_EMISSAO" ,"D", 8, 0} )
		aAdd( aStruct, {"E2_VENCREA" ,"D", 8, 0} )		
	
		cArqTrab := CriaTrab(aStruct, .T.)
		dbUseArea(.T.,, cArqTrab ,"TMPSE2", .F.,.F. )
		dbSelectArea("TMPSE2")
		Index on E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA to &cArqTrab
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza temporarios                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
		For nINDFIL := 1 to Len(aDADOSTIT)
		    dbSelectArea("TMPSE2")
		    RecLock("TMPSE2",.T.)
		    TMPSE2->E2_OK	:= Space(02)
		    TMPSE2->E2_PREFIXO	:= aDADOSTIT[nINDFIL,01]
		    TMPSE2->E2_NUM		:= aDADOSTIT[nINDFIL,02]
		    TMPSE2->E2_PARCELA	:= aDADOSTIT[nINDFIL,03]
		    TMPSE2->E2_TIPO		:= aDADOSTIT[nINDFIL,04]		    		    
		    TMPSE2->E2_FORNECE	:= aDADOSTIT[nINDFIL,05]
		    TMPSE2->E2_LOJA		:= aDADOSTIT[nINDFIL,06]
		    TMPSE2->A2_NOME		:= aDADOSTIT[nINDFIL,07]		    		    
		    TMPSE2->E2_VALOR	:= aDADOSTIT[nINDFIL,08]
		    TMPSE2->E2_EMISSAO	:= stod(aDADOSTIT[nINDFIL,09])
		    TMPSE2->E2_VENCREA	:= stod(aDADOSTIT[nINDFIL,10])
		    MsUnLock("TMPSE2")
		Next nINDFIL

		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Campos para mostrar no BROWSE padrao                      ³
		//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		AADD(aCampos,{"E2_OK"  		,"" 	," "        	," " })
		AADD(aCampos,{"E2_PREFIXO"	,"" 	,"Prefixo"  	," " })
		AADD(aCampos,{"E2_NUM" 		,"" 	,"Número"  		," " })
		AADD(aCampos,{"E2_PARCELA"	,""		,"Parcela"  	," " })
		AADD(aCampos,{"E2_TIPO"		,"" 	,"Tipo"  		," " })
		AADD(aCampos,{"E2_FORNECE"	,"" 	,"Fornecedor"  	," " })
		AADD(aCampos,{"E2_LOJA"		,"" 	,"Loja"  		," " })
		AADD(aCampos,{"A2_NOME"		,"" 	,"Nome"  		," " })
		AADD(aCampos,{"E2_VALOR"	,"" 	,"Valor"  		," " })
		AADD(aCampos,{"E2_EMISSAO"	,"" 	,"Emissão"  	," " })
		AADD(aCampos,{"E2_VENCREA"	,"" 	,"Vencimento"  	," " })
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria dialogo para usuario selecionar as filiais   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		dbSelectArea("TMPSE2")
		dbGoTop()
	
		DEFINE MSDIALOG oDlgFIL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
		
		oMark := MsSelect():New("TMPSE2","E2_OK",,aCampos,@lInverte,@cMarca,{1,1,180,350})
	          
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
		   	dbSelectArea("TMPSE2")
			dbGoTop()
			While ! TMPSE2->(EOF())
		    	If ! Empty(TMPSE2->E2_OK)   	    	
		    		If RecLock("SE1",.F.)
		    			SE1->E1_X_TPPCO := xFilial("SE1")+TMPSE2->E2_PREFIXO+TMPSE2->E2_NUM+TMPSE2->E2_PARCELA+TMPSE2->E2_TIPO+TMPSE2->E2_FORNECE+TMPSE2->E2_LOJA
		    			SE1->(MsUnLock())
		    			DbSelectArea("SE2")
						DbSetOrder(1)
						DbGoTop()
						If DbSeek(SE1->E1_X_TPPCO)	
							If SE2->E2_MULTNAT == '1'        //MULTINATUREZAS
								DbSelectArea("SEZ") 
								DbSetOrder(1)
								DbGoTop()
								If DbSeek(ALLTRIM(SE1->E1_X_TPPCO))
									PCOINILAN("999006")
									While !SEZ->( EOF() ) .AND. SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA)==ALLTRIM(SE1->E1_X_TPPCO)
										Begin Transaction
											PCODETLAN("999006","02","FA040FIN")
										End Transaction					
										SEZ->( dbskip() ) 
									EndDo 
									PCOFINLAN("999006")			
							    EndIf		    
							Else 
								PCOINILAN("999006")
								Begin Transaction
									PCODETLAN("999006","01","FA040FIN")
								End Transaction
								PCOFINLAN("999006")										
							EndIf			
						EndIf    
						Exit
		    		EndIf	    		
		    	EndIf
		    	TMPSE2->(dbSkip())
		 	Enddo          
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha alias temporarios                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		dbSelectArea("TMPSE2")
		dbCloseArea("TMPSE2")
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
Local nREC := TMPSE2->(RECNO())

	If Marked("E2_OK")
		dbGoTop()
		While !EOF()  
			If nREC != TMPSE2->(RECNO())
				If TMPSE2->E2_OK != Space(02)
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
				RecLock("TMPSE2",.F.)
				Replace TMPSE2->E2_OK With Space(02)
				MsUnlock()
				dbSkip()
			EndDo 
		EndIf
		dbGoTo(nREC)	  

	Else
		RecLock("TMPSE2",.F.)
		Replace TMPSE2->E2_OK With Space(02)
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
