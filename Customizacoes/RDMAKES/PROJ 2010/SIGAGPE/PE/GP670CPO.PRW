#INCLUDE "RWMAKE.CH"                              
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGP670CPO     บAutor  ณRafael Parma     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Ponto de entrada na integracao dos titulos GPE-FINANCEIRO. บฑฑ
ฑฑบDesc.     ณ Utilizado para inclusใo de tํtulos por segmento.           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-----------------------------------------------------*
User Function GP670CPO()
*-----------------------------------------------------*
Private STRING_NULL := ""
Private aAreaTEMP := GetArea()
Private cMVFOLMES := ALLTRIM(GETMV("MV_FOLMES"))
Private aDADOSTIT := {}
Private aDADOSEXP := {} 
Private nTOTALRAT := 0
Private nTOTCTIND := 0
Private nTOTCTDET := 0
Private cTIPCONTR := STRING_NULL
Private cCODVERBA := STRING_NULL
Private cTableFOL := STRING_NULL	
Private cFieldCCT := STRING_NULL
Private cFieldVER := STRING_NULL
Private cFieldMAT := STRING_NULL
Private cFieldVAL := STRING_NULL
Private cFieldFIL := STRING_NULL 
Private cFiltroTAB := STRING_NULL 
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If SuperGetMv("MV_X_ATCLV",,"N") == "S"

		If ! Empty(RC1->RC1_MAT) .or. Empty(RC1->RC1_CC)
			If ! Empty(RC1->RC1_MAT)
				If RecLock("SE2",.F.)                                                            
					SE2->E2_CCD := IIF(!Empty(RC1->RC1_CC),RC1->RC1_CC,Posicione("SRA",1,xFilial("SRA")+RC1->RC1_MAT,"RA_CC"))
					SE2->E2_CLVLDB := Posicione("SRA",1,xFilial("SRA")+RC1->RC1_MAT,"RA_X_SEGME")
					SE2->(MsUnLock())                                                            
				EndIf
			EndIf
			//-- Nใo realiza o procedimento, gera o tํtulo por funcionแrio --//
			Return
		EndIf
		
		dbSelectArea("RC0")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("RC0") + RC1->RC1_CODTIT )
		
			Do Case
				Case RC1->RC1_CODTIT == "110"
					cFiltroTAB := " AND	TAB.RC_CC = '020101001'		"		
				
				Case RC1->RC1_CODTIT == "100"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA  = '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

				Case RC1->RC1_CODTIT == "150"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA != '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

				Case RC1->RC1_CODTIT == "250"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA  = '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

				Case RC1->RC1_CODTIT == "300"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA != '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

				Case RC1->RC1_CODTIT == "350"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA  = '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

				Case RC1->RC1_CODTIT == "400"                               
					cFiltroTAB := " AND	SRA.RA_CTDEPSA != '"+Space(TAMSX3("RA_CTDEPSA")[1])+"'		"		

			EndCase
						
			cFiltroRA := IIF( !EMPTY(RC0->RC0_FILTRF), RC0->RC0_FILTRF , STRING_NULL )
			cFiltroRC := IIF( !EMPTY(RC0->RC0_FILTRV), RC0->RC0_FILTRV , STRING_NULL )
		 
		
			If RC0->RC0_TIPTIT == "2" .and. !Empty(RC0->RC0_ALIAS)
				cCODVERBA := RJ670SEP(RC0->RC0_VERBAS)
			Else
				If RC1->RC1_CODTIT == "000"	//-- GPS FOLHA
					//-- verbas fixas referentes a GPS FOLHA
					cCODVERBA := "'401','403','405','778','779','780'"
				ElseIf RC1->RC1_CODTIT == "200"	//-- IRRF FOLHA
					cCODVERBA := "'407','409','411','413','415'"				
				Else
					Alert("Falta definir verbas...")
					Return
				EndIf
			EndIf		        
			                          
			//Guilherme - Testes
			If !Empty(RC0->RC0_ALIAS)
				cTableFOL := RC0->RC0_ALIAS         							
			Else                           
				If RC1->RC1_CODTIT == "000" //-- GPS FOLHA
					cTableFOL := "SRC"			
				ElseIf RC1->RC1_CODTIT == "200"	//-- IRRF 
					//-- Mes atual SIGAGPE, busca dados tabela de movimento atual.
					If Year(RC1->RC1_DTBUSI) == Val(SubSTR(cMVFOLMES,1,4)) .and. Month(RC1->RC1_DTBUSI) == Val(SubSTR(cMVFOLMES,5,2))
						cTableFOL := "SRC"			
					Else                            
					//-- Mes anterior, busca dados tabela de acumulados.
						cTableFOL := "SRD"			
					EndIf
				EndIf
			EndIf
			
			cFieldCCT := SubSTR(cTableFOL,2,2)+"_CC"
			cFieldVER := SubSTR(cTableFOL,2,2)+"_PD"
			cFieldMAT := SubSTR(cTableFOL,2,2)+"_MAT"
			If cTableFOL != "SRK"
				cFieldVAL := SubSTR(cTableFOL,2,2)+"_VALOR"
			Else
				cFieldVAL := SubSTR(cTableFOL,2,2)+"_VALORTO"
			EndIf

			If cTableFOL == "SRZ"
				cFieldVAL := SubSTR(cTableFOL,2,2)+"_VAL"
			EndIf


			cFieldFIL := SubSTR(cTableFOL,2,2)+"_FILIAL"   
			
			cTFolBKP := cTableFOL // Guilherme 15/12/11 variแvel criada para armazenar a tabela SRI para o calculo do 13บ
			
			If cTableFOL == "SRI"
				cTableFOL := "RI"+cEmpAnt+cValToChar(Year(mv_par07))+"13"
			EndIf 
			
			// Guilherme 15/12/11 - nao estava calculando a parcela do 13บ, pois ainda nao existia a tabela RIeeaamm criada e assim nao integrava os titulos 
			If !TCCanOpen(cTableFOL) 
				cTableFOL := cTFolBKP	 
			endif	
					
			//-- Seleciona registros agrupados por centro de custo e segmento.
			If RC1->RC1_CODTIT == "000"	// GPS FOLHA
				FGETARRAY(.T.,.F.,.T.)   				      
			Else   
				FGETARRAY(.T.,.F.,.F.)         
			Endif
	
			//-- Quando tํtulo de GPS FOLHA devem ser descontados os valores de algumas verbas dos movimentos --//
			If RC1->RC1_CODTIT == "000"	// GPS FOLHA
				cCODVERBA := FSRVINSS()
				If cCODVERBA != STRING_NULL  
					FGETARRAY(.F.,.F.,.T.) 
				EndIf
			EndIf  
			
			//-- Dedu็ใo dos valores para os funcionแrios demitidos somente para tํtulos de FGTS FOLHA (050)
			If RC1->RC1_CODTIT == "050"	// FGTS FOLHA
				FGETARRAY(.F.,.T.,.F.) 					
			EndIf
	
			//-- Busca valores acumulados quando perํodo atual igual MV_FOLMES
			If RC1->RC1_CODTIT == "200"	// IRRF FOLHA
				//-- Mes atual SIGAGPE, busca dados tabela de movimento atual.
				If Year(RC1->RC1_DTBUSI) == Val(SubSTR(cMVFOLMES,1,4)) .and. Month(RC1->RC1_DTBUSI) == Val(SubSTR(cMVFOLMES,5,2))
			    	cTableFOL := "SRD"
					cFieldCCT := SubSTR(cTableFOL,2,2)+"_CC"
					cFieldVER := SubSTR(cTableFOL,2,2)+"_PD"
					cFieldMAT := SubSTR(cTableFOL,2,2)+"_MAT"
					cFieldVAL := SubSTR(cTableFOL,2,2)+"_VALOR"
					cFieldFIL := SubSTR(cTableFOL,2,2)+"_FILIAL"	 
					FGETARRAY(.T.,.F.,.F.)          					
				EndIf		
			EndIf		
			
			If Len(aDADOSTIT) > 0 
				
				lTITOK := .T.
				
				If nTOTALRAT != RC1->RC1_VALOR
				                              
					If RC1->RC1_CODTIT != "000" // GPS FOLHA
					    
					    lTITOK := .F.
					    cTEXTO := chr(10)+chr(13)
					    cTEXTO += "Valor Tํtulo: R$ "+TRANSFORM(RC1->RC1_VALOR,"@E 9,999,999.99")+chr(10)+chr(13)
					    For nR := 1 to Len(aDADOSTIT)
					    	cTEXTO += "Centro Custo: " + ALLTRIM(aDADOSTIT[nR,1]) + " - Segmento: " + ALLTRIM(aDADOSTIT[nR,2]) + " - Valor: R$ "+TRANSFORM(aDADOSTIT[nR,3],"@E 9,999,999.99")+chr(10)+chr(13)
					    Next nR
					    cTEXTO += "Total Rateio: R$ "+TRANSFORM(nTOTALRAT,"@E 9,999,999.99")+chr(10)+chr(13)			    
					    cTEXTO += "Os valores utilizados no calculo podem ser exportados para o excel para confer๊ncia, para isso utilizar op็ใo VIS.EXCEL."
					    cTEXTO := "O Valor do rateio de centro de custo/segmento ้ diferente do valor do tํtulo ("+RC1->RC1_NUMTIT+"), verifique!" + cTEXTO
						nRet := Aviso("Aviso",cTEXTO,{"OK","VIS.EXCEL"},3)
						If nRet == 2
							fExpEXCEL()
						EndIf						
					Else
						
						If nTOTCTIND == RC1->RC1_VALOR
							cTIPCONTR := "1"
						ElseIf nTOTCTDET == RC1->RC1_VALOR
							cTIPCONTR := "2"
						Else
						    lTITOK := .F.
						    cTEXTO := chr(10)+chr(13)
						    cTEXTO += "Valor Tํtulo: R$ "+TRANSFORM(RC1->RC1_VALOR,"@E 9,999,999.99")+chr(10)+chr(13)
						    For nR := 1 to Len(aDADOSTIT)
						    	If aDADOSTIT[nR,04] == "1"
						    		cTIPCONTR := "INDETERMINADO"
						    	Else
						    		cTIPCONTR := "DETERMINADO"
						    	EndIf
						    	cTEXTO += "Tipo Contrato: " + cTIPCONTR + " - Centro Custo: " + ALLTRIM(aDADOSTIT[nR,1]) + " - Segmento: " + ALLTRIM(aDADOSTIT[nR,2]) + " - Valor: R$ "+TRANSFORM(aDADOSTIT[nR,3],"@E 9,999,999.99")+chr(10)+chr(13)
						    Next nR
						    cTEXTO += "Total DETERMINADO: R$ "+TRANSFORM(nTOTCTDET,"@E 9,999,999.99")+chr(10)+chr(13)			    
						    cTEXTO += "Total INDETERMINADO: R$ "+TRANSFORM(nTOTCTIND,"@E 9,999,999.99")+chr(10)+chr(13)
						    cTEXTO += "Os valores utilizados no calculo podem ser exportados para o excel para confer๊ncia, para isso utilizar op็ใo VIS.EXCEL."
						    cTEXTO := "O Valor do rateio de centro de custo/segmento ้ diferente do valor do tํtulo ("+RC1->RC1_NUMTIT+"), verifique!" + cTEXTO			    
							nRet := Aviso("Aviso",cTEXTO,{"OK","VIS.EXCEL"},3)
							If nRet == 2
								fExpEXCEL()
							EndIf
						EndIf
					
					EndIf
				Else
				
					If RC1->RC1_CODTIT == "000" // GPS FOLHA

						If nTOTCTIND == RC1->RC1_VALOR
							cTIPCONTR := "1"
						ElseIf nTOTCTDET == RC1->RC1_VALOR
							cTIPCONTR := "2"
						EndIf
					
					EndIf
				
				EndIf	
				
				If Len(aDADOSTIT) > 1 .and. lTITOK
					Begin Transaction

						//-- Recupera dados do titulo de origem --//
						cPRFTIT := SE2->E2_PREFIXO
						cNUMTIT := SE2->E2_NUM
						cTIPTIT := SE2->E2_TIPO
						cPARTIT := SE2->E2_PARCELA
						cNATTIT := SE2->E2_NATUREZ
						cFORTIT := SE2->E2_FORNECE
						cLOJTIT := SE2->E2_LOJA
						dEMITIT := SE2->E2_EMISSAO
						dVCTTIT := SE2->E2_VENCTO
						dVRETIT := SE2->E2_VENCREA
						nVALTIT := SE2->E2_VALOR
		
						//-- Exclusใo do titulo de origem --//
						aAreaEXC := GetArea()
						aFINA050 := {}
						AADD( aFINA050, { "E2_FILIAL"  , xFilial("SE2")	,Nil } )
						AADD( aFINA050, { "E2_PREFIXO" , cPRFTIT		,Nil } )
						AADD( aFINA050, { "E2_NUM"	   , cNUMTIT		,Nil } )
						AADD( aFINA050, { "E2_PARCELA" , cPARTIT		,Nil } )
						AADD( aFINA050, { "E2_TIPO"	   , cTIPTIT		,Nil } )
						AADD( aFINA050, { "E2_FORNECE" , cFORTIT		,Nil } )
						AADD( aFINA050, { "E2_LOJA"	   , cLOJTIT		,Nil } )
						
						MSExecAuto( {|x, y, z| Fina050(x, y, z) }, aFINA050,, 5) 
						
					
						If lMsErroAuto
							Mostraerro()
							lRet := .F.
						Else
							
							RestArea(aAreaEXC)
						
							//-- Inclusใo de titulos por centro de custo/segmento --//
							nPRC := 0
							For nRI := 1 to Len(aDADOSTIT)
							
								//GPS FOLHA
								If RC1->RC1_CODTIT != "000" .OR. ( RC1->RC1_CODTIT == "000" .AND. cTIPCONTR == aDADOSTIT[nRI,04] )
									
									
									nPRC += 1
									aAreaEXC := GetArea()
									aFINA050 := {	{"E2_FILIAL"	, xFilial("SE2")		 				,	Nil},;      
													{"E2_PREFIXO"	, cPRFTIT		 						,	Nil},;      
									  				{"E2_NUM"		, cNUMTIT			 					,	Nil},;      
													{"E2_PARCELA"	, STRZero(nPRC,TAMSX3("E2_PARCELA")[1])	,	Nil},;      
													{"E2_TIPO"		, cTIPTIT				 				,	Nil},;      
													{"E2_NATUREZ"	, cNATTIT								,	Nil},;  					
													{"E2_FORNECE"	, cFORTIT		        				,	Nil},;      
													{"E2_LOJA"		, cLOJTIT			  					,	Nil},;          
													{"E2_EMISSAO"	, dEMITIT			 					,  	Nil},;
													{"E2_VENCTO"	, dVCTTIT								,	Nil},;
													{"E2_VENCREA"	, dVRETIT								,	Nil},;
													{"E2_CCD"		, aDADOSTIT[nRI,01]	  					,	Nil},;
													{"E2_CLVLDB"	, aDADOSTIT[nRI,02]	  					,	Nil},;
													{"E2_VALOR"		, aDADOSTIT[nRI,03]			  			,	Nil} }
		

									MSExecAuto({|x,y,z| FINA050(x,y,z)}, aFINA050,,3)
									If lMsErroAuto
										DisarmTransaction()
										Mostraerro()
										Exit
									Else
										RestArea(aAreaEXC)
									EndIf 										
								
								EndIf	
							Next nRI							

						EndIf     

					End Transaction
		   		    //-- Na execu็ใo do MSEXECAUTO a tabela RC1 perde o RECLOCK realizado antes da chamada deste PE. --//
		   		    If !RC1->(EOF())
			   		    If RecLock("RC1",.F.)
			   		    EndIf
			  		EndIf
		   		
		   		ElseIf Len(aDADOSTIT) == 1 .and. lTITOK
		   			//-- Titulo ๚nico sem rateio, grava dados de centro de custo/segmento..--//
		   			If RecLock("SE2",.F.)
		   				SE2->E2_CCD := aDADOSTIT[01,01] 
		   				SE2->E2_CLVLDB := aDADOSTIT[01,02]
		   				SE2->(MsUnLock())
		   			EndIf
		   			
		   		EndIf
			EndIf
	
		EndIf
	
	EndIf

	RestArea(aAreaTEMP)
	
Return	
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJ670SEP     บAutor  ณRafael Parma     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recupera c๓digos de verbas das defini็๕es.                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/	
*-----------------------------------------------------*
Static Function RJ670SEP(cSTRING)
*-----------------------------------------------------*
Local cTRANSF := STRING_NULL
	
	cSTRING := ALLTRIM(cSTRING)	
	If Len(cSTRING) > 0
		cTRANSF := "'"
		For nR := 1 to Len(cSTRING)
			cSUBSTR := SubSTR(cSTRING,nR,1)
			If cSUBSTR != "0" .and. Val(cSUBSTR) == 0
				cTRANSF += "','"
			Else
				cTRANSF += SubSTR(cSTRING,nR,1)
			EndIf
		Next nR               
		If SubSTR(cTRANSF,Len(cTRANSF)-1,1) != "'"
			cTRANSF += "'"
		EndIf
	EndIf       
	          
	
Return (cTRANSF)      
      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSRVINSS     บAutor  ณRafael Parma     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recupera verbas de dedu็ใo de INSS.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------------------*
Static Function FSRVINSS()
*-----------------------------------------------------*
Local cDEDINSS := STRING_NULL

	dbSelectArea("SRV")
	dbSetOrder(1)
	dbGoTop()
	While !SRV->(EOF())
		If SRV->RV_DEDINSS == "S"
			cDEDINSS += "'"+SRV->RV_COD+"',"
		EndIf
		SRV->(dbSkip())
	Enddo   
	If Len(cDEDINSS) > 0
		cDEDINSS := SubSTR(cDEDINSS,1,Len(cDEDINSS)-1)		
	EndIf 

Return (cDEDINSS)  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFGETARRAY    บAutor  ณRafael Parma     บ Data ณ  25/04/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recupera dados do movimento e atualiza sobre array.        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------------------*
Static Function FGETARRAY(lADIC, lDEMIT, lTPCONT)                              
*-----------------------------------------------------*
Local cAliasTMP := GetNextAlias()                      
    
	cQuery := " SELECT 	TAB."+cFieldCCT+", 									   		"+chr(10)+chr(13)
	If lTPCONT
		cQuery += " 	SRA.RA_TPCONTR,  									  		"+chr(10)+chr(13)
	EndIf
	cQuery += " 		SRA.RA_X_SEGME,  									  		"+chr(10)+chr(13)
	cQuery += " 		SUM(TAB."+cFieldVAL+") VALOR 						  		"+chr(10)+chr(13)        
	cQuery += " FROM " + RetSQLName(cTableFOL) + " TAB			 			  		"+chr(10)+chr(13)
	cQuery += " INNER JOIN " + RetSQLName("SRA") + " SRA 		   			  		"+chr(10)+chr(13)
	cQuery += " ON 		SRA.RA_FILIAL = TAB." + cFieldFIL + " 		 		 		"+chr(10)+chr(13)
	cQuery += " AND		SRA.RA_MAT    = TAB." + cFieldMAT + " 		 		 		"+chr(10)+chr(13)
	cQuery += " WHERE 	SRA.RA_FILIAL = '" + xFilial("SRA") + "'			  		"+chr(10)+chr(13)
	If lDEMIT   
	    cQuery += " AND  SRA.RA_SITFOLH  = 'D'								   		"+chr(10)+chr(13)
	    cQuery += " AND SubSTR(SRA.RA_DEMISSA,1,6) = '" + RC1->RC1_X_DARQ + "' 	 	"+chr(10)+chr(13)
	EndIf
    cQuery += " AND 	TAB."+cFieldCCT+" = '" + RC1->RC1_CC  + "'			   		"+chr(10)+chr(13)
    cQuery += " AND 	TAB."+cFieldVER+" IN (" + cCODVERBA + ")			 		"+chr(10)+chr(13)
    If cTableFOL == "SRC"
    	If RC1->RC1_CODTIT == "200"	// IRRF FOLHA
	    	cQuery += " AND TAB.RC_DATA BETWEEN  '" + dtos(RC1->RC1_DTBUSI) + "' 	"+chr(10)+chr(13)
	    	cQuery += " AND 			    	 '" + dtos(RC1->RC1_DTBUSF) + "' 	"+chr(10)+chr(13)
	    EndIf
    ElseIf cTableFOL == "SRD"
    	If  RC1->RC1_CODTIT == "050" //FGTS FOLHA
    		cQuery += " AND TAB.RD_DATARQ  = '" + RC1->RC1_X_DARQ + "' 			  	"+chr(10)+chr(13)
    	ElseIf RC1->RC1_CODTIT == "200"	// IRRF FOLHA
	    	cQuery += " AND TAB.RD_DATPGT BETWEEN  '" + dtos(RC1->RC1_DTBUSI) + "' 	"+chr(10)+chr(13)
	    	cQuery += " AND 			    	   '" + dtos(RC1->RC1_DTBUSF) + "' 	"+chr(10)+chr(13)
	    EndIf
    ElseIf cTableFOL == "SRR"
    	cQuery += " AND TAB.RR_DATAPAG BETWEEN '" + dtos(mv_par07) + "' 	 		"+chr(10)+chr(13)
    	cQuery += " AND 					   '" + dtos(mv_par08) + "' 	 		"+chr(10)+chr(13)
    ElseIf cTableFOL == "SRK"
    	cQuery += " AND SUBSTR(TAB.RK_DTMOVI,1,6) = '" + RC1->RC1_X_DARQ + "' 	 	"+chr(10)+chr(13)
    EndIf
    If cFiltroTAB != STRING_NULL 
    	cQuery += cFiltroTAB
    EndIf
    cQuery += " AND 	TAB.D_E_L_E_T_ <> '*' 								  		"+chr(10)+chr(13)
    cQuery += " AND 	SRA.D_E_L_E_T_ <> '*' 										"+chr(10)+chr(13)
	cQuery += " GROUP BY					 										"+chr(10)+chr(13)
	cQuery += " 			TAB."+cFieldCCT+", 										"+chr(10)+chr(13)
	If lTPCONT
		cQuery += " 		SRA.RA_TPCONTR,  									  	"+chr(10)+chr(13)
	EndIf
	cQuery += " 			SRA.RA_X_SEGME  										"+chr(10)+chr(13)
	cQuery += " ORDER BY					 										"+chr(10)+chr(13)
	If lTPCONT
		cQuery += " 		SRA.RA_TPCONTR,  									  	"+chr(10)+chr(13)
	EndIf
	cQuery += " 			TAB."+cFieldCCT+", 										"+chr(10)+chr(13)
	cQuery += " 			SRA.RA_X_SEGME  										"+chr(10)+chr(13)
       
	//Aviso("SQL", cQuery, {"OK"}, 3)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
  
					
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF()) 
		
		If lADIC
			//-- GPS FOLHA - Verbas de dedu็๕es sobre agrupamentos.. --//
			If RC1->RC1_CODTIT == "000" .and. lTPCONT
				nPOS := aScan ( aDADOSTIT, {|x| x[1] == (cAliasTMP)->&(cFieldCCT) .and. x[2] == (cAliasTMP)->RA_X_SEGME .and. x[4] == (cAliasTMP)->RA_TPCONTR } )
			Else
				nPOS := aScan ( aDADOSTIT, {|x| x[1] == (cAliasTMP)->&(cFieldCCT) .and. x[2] == (cAliasTMP)->RA_X_SEGME } )
			EndIf			
		
			If nPOS == 0
				aAdd ( aDADOSTIT, { (cAliasTMP)->&(cFieldCCT), (cAliasTMP)->RA_X_SEGME, (cAliasTMP)->VALOR, "1" } )
			Else
				aDADOSTIT[Len(aDADOSTIT),03] += (cAliasTMP)->VALOR
			EndIf
			nTOTALRAT += (cAliasTMP)->VALOR 
			
			//-- GPS FOLHA - Atualiza variแveis pelo tipo do contrato. --//
			If RC1->RC1_CODTIT == "000" .and. lTPCONT
				If (cAliasTMP)->RA_TPCONTR == "1"
					nTOTCTIND += (cAliasTMP)->VALOR
				Else
					nTOTCTDET += (cAliasTMP)->VALOR
					aDADOSTIT[Len(aDADOSTIT),04] := (cAliasTMP)->RA_TPCONTR 
				EndIf
			EndIf			
			
		ElseIf Len(aDADOSTIT) > 0
			//-- GPS FOLHA - Verbas de dedu็๕es sobre agrupamentos.. --//
			If RC1->RC1_CODTIT == "000" .and. lTPCONT
				nPOS := aScan ( aDADOSTIT, {|x| x[1] == (cAliasTMP)->&(cFieldCCT) .and. x[2] == (cAliasTMP)->RA_X_SEGME .and. x[4] == (cAliasTMP)->RA_TPCONTR } )
			Else
				nPOS := aScan ( aDADOSTIT, {|x| x[1] == (cAliasTMP)->&(cFieldCCT) .and. x[2] == (cAliasTMP)->RA_X_SEGME } )
			EndIf
			If nPOS != 0
				aDADOSTIT[nPOS,03] -= (cAliasTMP)->VALOR
				nTOTALRAT -= (cAliasTMP)->VALOR
				//-- GPS FOLHA
				If RC1->RC1_CODTIT == "000" .and. lTPCONT
					If (cAliasTMP)->RA_TPCONTR == "1"
						nTOTCTIND -= (cAliasTMP)->VALOR
					Else
						nTOTCTDET -= (cAliasTMP)->VALOR
					EndIf
				EndIf				
			Else
				aAdd ( aDADOSTIT, { (cAliasTMP)->&(cFieldCCT), (cAliasTMP)->RA_X_SEGME, (cAliasTMP)->VALOR, "1" } )
				nTOTALRAT -= (cAliasTMP)->VALOR
				//-- GPS FOLHA
				If RC1->RC1_CODTIT == "000" .and. lTPCONT
					If (cAliasTMP)->RA_TPCONTR == "1"
						nTOTCTIND -= (cAliasTMP)->VALOR
					Else
						nTOTCTDET -= (cAliasTMP)->VALOR
					EndIf
				EndIf				
			EndIf			
		EndIf
		
		(cAliasTMP)->(dbSkip())

	Enddo                      
	(cAliasTMP)->(dbCloseArea())

	cQuery := " SELECT 	TAB."+cFieldCCT+", 									   		"+chr(10)+chr(13)
	cQuery += " 		TAB."+cFieldVER+", 									   		"+chr(10)+chr(13)
	cQuery += " 		SRA.RA_MAT,		  									  		"+chr(10)+chr(13)	
	If lTPCONT
		cQuery += " 	SRA.RA_TPCONTR,  									  		"+chr(10)+chr(13)
	EndIf
	cQuery += " 		SRA.RA_X_SEGME,  									  		"+chr(10)+chr(13)
	cQuery += " 		SUM(TAB."+cFieldVAL+") VALOR 						  		"+chr(10)+chr(13)
	cQuery += " FROM " + RetSQLName(cTableFOL) + " TAB			 			  		"+chr(10)+chr(13)
	cQuery += " INNER JOIN " + RetSQLName("SRA") + " SRA 		   			  		"+chr(10)+chr(13)
	cQuery += " ON 		SRA.RA_FILIAL = TAB." + cFieldFIL + " 		 		 		"+chr(10)+chr(13)
	cQuery += " AND		SRA.RA_MAT    = TAB." + cFieldMAT + " 		 		 		"+chr(10)+chr(13)
	cQuery += " WHERE 	SRA.RA_FILIAL = '" + xFilial("SRA") + "'			  		"+chr(10)+chr(13)
	If lDEMIT   
	    cQuery += " AND  SRA.RA_SITFOLH  = 'D'								   		"+chr(10)+chr(13)
	    cQuery += " AND SubSTR(SRA.RA_DEMISSA,1,6) = '" + RC1->RC1_X_DARQ + "' 	 	"+chr(10)+chr(13)
	EndIf
    cQuery += " AND 	TAB."+cFieldCCT+" = '" + RC1->RC1_CC  + "'			   		"+chr(10)+chr(13)
    cQuery += " AND 	TAB."+cFieldVER+" IN (" + cCODVERBA + ")			 		"+chr(10)+chr(13)
    If cTableFOL == "SRC"
    	If RC1->RC1_CODTIT == "200"	// IRRF FOLHA
	    	cQuery += " AND TAB.RC_DATA BETWEEN  '" + dtos(RC1->RC1_DTBUSI) + "' 	"+chr(10)+chr(13)
	    	cQuery += " AND 			    	 '" + dtos(RC1->RC1_DTBUSF) + "' 	"+chr(10)+chr(13)
	    EndIf
    ElseIf cTableFOL == "SRD"
    	If  RC1->RC1_CODTIT == "050" //FGTS FOLHA
    		cQuery += " AND TAB.RD_DATARQ  = '" + RC1->RC1_X_DARQ + "' 			  	"+chr(10)+chr(13)
    	ElseIf RC1->RC1_CODTIT == "200"	// IRRF FOLHA
	    	cQuery += " AND TAB.RD_DATPGT BETWEEN  '" + dtos(RC1->RC1_DTBUSI) + "' 	"+chr(10)+chr(13)
	    	cQuery += " AND 			    	   '" + dtos(RC1->RC1_DTBUSF) + "' 	"+chr(10)+chr(13)
	    EndIf
    ElseIf cTableFOL == "SRR"
    	cQuery += " AND TAB.RR_DATAPAG BETWEEN '" + dtos(mv_par07) + "' 	 		"+chr(10)+chr(13)
    	cQuery += " AND 					   '" + dtos(mv_par08) + "' 	 		"+chr(10)+chr(13)
    ElseIf cTableFOL == "SRK"
    	cQuery += " AND SUBSTR(TAB.RK_DTMOVI,1,6) = '" + RC1->RC1_X_DARQ + "' 	 	"+chr(10)+chr(13)
    EndIf
    If cFiltroTAB != STRING_NULL 
    	cQuery += cFiltroTAB
    EndIf
    cQuery += " AND 	TAB.D_E_L_E_T_ <> '*' 								  		"+chr(10)+chr(13)
    cQuery += " AND 	SRA.D_E_L_E_T_ <> '*' 										"+chr(10)+chr(13)
	cQuery += " GROUP BY					 										"+chr(10)+chr(13)
	cQuery += " 			TAB."+cFieldCCT+", 										"+chr(10)+chr(13)
	cQuery += " 			TAB."+cFieldVER+", 									   	"+chr(10)+chr(13)
	cQuery += " 			SRA.RA_MAT,  									  		"+chr(10)+chr(13)
	If lTPCONT
		cQuery += " 		SRA.RA_TPCONTR,  									  	"+chr(10)+chr(13)
	EndIf
	cQuery += " 			SRA.RA_X_SEGME  										"+chr(10)+chr(13)
	cQuery += " ORDER BY					 										"+chr(10)+chr(13)
	cQuery += " 			SRA.RA_MAT,  									  		"+chr(10)+chr(13)
	cQuery += " 			TAB."+cFieldVER+", 									   	"+chr(10)+chr(13)
	If lTPCONT
		cQuery += " 		SRA.RA_TPCONTR,  									  	"+chr(10)+chr(13)
	EndIf
	cQuery += " 			TAB."+cFieldCCT+", 										"+chr(10)+chr(13)
	cQuery += " 			SRA.RA_X_SEGME  										"+chr(10)+chr(13)
       

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

					
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		aAdd ( aDADOSEXP, { (cAliasTMP)->RA_MAT, (cAliasTMP)->&(cFieldVER), (cAliasTMP)->&(cFieldCCT), (cAliasTMP)->RA_X_SEGME, (cAliasTMP)->VALOR } )
		(cAliasTMP)->(dbSkip())
	Enddo                      
	(cAliasTMP)->(dbCloseArea())
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExpEXCEL    บAutor  ณRafael Parma     บ Data ณ  17/06/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exporta dados para Microsoft Excel.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------------------*
Static Function fExpEXCEL()                            
*-----------------------------------------------------* 

Local cArquivo := GetNextAlias()
Local cPath	   := AllTrim(GetTempPath())

Private cArqTxt := cPath+cArquivo+".txt"
Private nHdl    := fCreate(cArqTxt)

	If nHdl == -1
	    MsgAlert("O arquivo "+cArqTxt+" nใo pode ser executado! Verifique os parโmetros.","Aten็ใo!")
	    Return
	Endif	
	
	If ! ApOleClient( 'MsExcel' ) 
	 	MsgStop("MsExcel nใo instalado!")
	 	Return
	EndIf

	cLin := "MATRICULA" 	 + ";"
	cLin += "VERBA" 		 + ";"
	cLin += "CENTROCUSTO"	 + ";"
	cLin += "SEGMENTO"		 + ";"
	cLin += "VALOR" 		 + CHR(13)

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
            Return
        Endif
    Endif	

	For nI := 1 to Len(aDADOSEXP)
		
		cLin := aDADOSEXP[nI,01] + ";"
		cLin += aDADOSEXP[nI,02] + ";"
		cLin += aDADOSEXP[nI,03] + ";"
		cLin += aDADOSEXP[nI,04] + ";"
		cLin += TRANSFORM(aDADOSEXP[nI,05],"@E 9,999,999.99") + CHR(13)


	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na grava็ใo do arquivo. Continua?","Aten็ใo!")
	            Exit
	        Endif
	    Endif	
	
	Next nI
	
	fClose(nHdl)

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cArqTxt ) // Abre uma planilha
	oExcelApp:SetVisible(.T.) 
		
Return
