#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTA655SEN ºAutor  ³Rafael Parma        º Data ³  14/01/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado após a confirmação da rotina de  º±±
±±º          ³abastecimento manual (MNTA655).                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------*
User Function MNTA655SEN() 
*-------------------------------*      
Local lRet     := .T.
Local lSE2     := .F.
Local aArea    := GetArea()
Local cSEGMENT := ""
Local cCENTROC := ""
Local cITEMCON := ""
Local cXPRFTCB := ALLTRIM(GETMV("MV_X_PRFTC"))
Local cXNATTCB := ALLTRIM(GETMV("MV_X_NATTC"))
Local cXCPPNAB := ALLTRIM(GETMV("MV_X_CPPNA"))
Local cHISTORI := ALLTRIM("ABAST.:"+M->TQN_NABAST)
Local cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
Local cTIPOTIT := "DP"
Private lMsErroAuto := .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 	   
	//-- Se tanque preenchido abastacimento local, não deverá ser realizadas as operações abaixo.
	If Empty(M->TQN_TANQUE)
	
		//-- Caso seja cupom fiscal e fornecedor estrangeiro, irá ser gerado título contas a pagar.
	 /*	If M->TQN_X_NFCF == "C" .and. POSICIONE("SA2",1,xFilial("SA2")+M->TQN_POSTO+M->TQN_LOJA,"A2_EST") == "EX"
		
		    //-- Verifica existencia de titulo para o abastecimento.
		    cHISTORI += Space(TAMSX3("E2_HIST")[1]-Len(cHISTORI))
		    dbSelectArea("SE2") 
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("SE2") + cXPRFTCB + M->TQN_NOTFIS + cPARCELA + cTIPOTIT +  M->TQN_POSTO + M->TQN_LOJA )	    
		    	lSE2 := .T.
		    EndIf
		    
		    If !lSE2
		    	
			    dbSelectArea("DA3")
			    dbSetOrder(1)
			    dbGoTop()
			    If dbSeek( xFilial("DA3") + M->TQN_PLACA )
					cSEGMENT := DA3->DA3_X_SEGM
					cCENTROC := DA3->DA3_X_CC
					cITEMCON := DA3->DA3_X_ITEM				    
			    Else
			    	dbSelectArea("ST9")
			    	dbSetOrder(1)
			    	dbGoTop()
			    	If dbSeek( xFilial("ST9")+M->TQN_PLACA )
					    dbSelectArea("DA3")
					    dbSetOrder(1)
					    dbGoTop()
					    If dbSeek( xFilial("DA3") + SubSTR(ST9->T9_NOME,1,TAMSX3("DA3_COD")[1]) )
							cSEGMENT := DA3->DA3_X_SEGM
							cCENTROC := DA3->DA3_X_CC
							cITEMCON := DA3->DA3_X_ITEM				    
					    EndIf				    	
			    	EndIf			    	
			    EndIf                  
			    
				nMOEDA := M->TQN_X_MOED		    
				If M->TQN_X_MOED == 0
					nMOEDA := 1
				EndIf
				
				nVALOR := M->TQN_VALTOT
				
				If M->TQN_X_MOED > 1 .AND. M->TQN_X_TAXA > 0
					nVALOR := nVALOR * M->TQN_X_TAXA
				EndIf
				
				cCONDPAG := Posicione("SA2",1,xFILIAL("SA2")+M->TQN_POSTO+M->TQN_LOJA,"A2_COND")
				If Empty(cCONDPAG)
					If Day(M->TQN_DTABAS) <= 15
						dVENCTO := LastDate(M->TQN_DTABAS)						
					Else                                
						dVENCTO := LastDate(M->TQN_DTABAS) + 15
					EndIf
				Else
					aVENCTO := Condicao(nVALOR,cCONDPAG,,M->TQN_DTABAS)
					dVENCTO := aVENCTO[1][1]
				EndIf
					
				lMsErroAuto := .F. 
				aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		, Nil },;      
								{"E2_PREFIXO"	, cXPRFTCB		 		, Nil },;      
				  				{"E2_NUM"		, M->TQN_NOTFIS	 		, Nil },;      
								{"E2_PARCELA"	, cPARCELA				, Nil },;      
								{"E2_TIPO"		, cTIPOTIT				, Nil },;      
								{"E2_NATUREZ"	, cXNATTCB				, Nil },;  					
								{"E2_FORNECE"	, M->TQN_POSTO		    , Nil },;      
								{"E2_LOJA"		, M->TQN_LOJA			, Nil },;          
								{"E2_MOEDA"		, nMOEDA				, Nil },;										          
								{"E2_TXMOEDA"	, M->TQN_X_TAXA			, Nil },;										
								{"E2_EMISSAO"	, M->TQN_DTABAS		 	, Nil },;
								{"E2_VENCTO"	, dVENCTO				, Nil },;
								{"E2_VENCREA"	, DataValida(dVENCTO)	, Nil },;
								{"E2_VALOR"		, nVALOR			  	, Nil },;
								{"E2_HIST"		, cHISTORI			  	, Nil },;
								{"E2_CLVLDB"	, cSEGMENT			  	, Nil },;
								{"E2_CCD"		, cCENTROC			  	, Nil },;
								{"E2_ITEMD"		, cITEMCON			  	, Nil } }					
			
				MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
				
				If lMsErroAuto
					DisarmTransaction()
					Mostraerro()
				Else											
					M->TQN_DTCON := M->TQN_DTABAS				
				EndIf
			    			
	        EndIf */
		
		//-- Caso seja nota fiscal e fornecedor nacional, realiza a inclusão de pré-nota ao fornecedor.
	 If M->TQN_X_NFCF == "N" .and. POSICIONE("SA2",1,xFilial("SA2")+M->TQN_POSTO+M->TQN_LOJA,"A2_EST") != "EX"	        
		    
		    dbSelectArea("DA3")
		    dbSetOrder(1)
		    dbGoTop()
		    If dbSeek( xFilial("DA3") + M->TQN_PLACA )
				cSEGMENT := DA3->DA3_X_SEGM
				cCENTROC := DA3->DA3_X_CC
				cITEMCON := DA3->DA3_X_ITEM	
		    Else
		    	dbSelectArea("ST9")
		    	dbSetOrder(1)
		    	dbGoTop()
		    	If dbSeek( xFilial("ST9")+M->TQN_PLACA )
				    dbSelectArea("DA3")
				    dbSetOrder(1)
				    dbGoTop()
				    If dbSeek( xFilial("DA3") + SubSTR(ST9->T9_NOME,1,TAMSX3("DA3_COD")[1]) )
						cSEGMENT := DA3->DA3_X_SEGM
						cCENTROC := DA3->DA3_X_CC
						cITEMCON := DA3->DA3_X_ITEM				    
				    EndIf				    	
		    	EndIf			    	
	    	EndIf
	    	    
		    cNUMDOC  := STRZero(Val(M->TQN_NOTFIS),TAMSX3("F1_DOC")[1])
			aCabec := {}
			aadd(aCabec,{"F1_TIPO"   	, "N"				})
			aadd(aCabec,{"F1_FORMUL" 	, "N"				})
			aadd(aCabec,{"F1_DOC"    	, cNUMDOC			})
			aadd(aCabec,{"F1_SERIE"  	, M->TQN_X_SERI		})
			aadd(aCabec,{"F1_EMISSAO"	, M->TQN_DTABAS		})
			aadd(aCabec,{"F1_FORNECE"	, M->TQN_POSTO		})
			aadd(aCabec,{"F1_LOJA"   	, M->TQN_LOJA		})
			aadd(aCabec,{"F1_ESPECIE"	, "NFE"				})
	
			aItens := {}
			aLinha := {}
			aadd(aLinha,{"D1_COD"  		, cXCPPNAB			, nil	})
			aadd(aLinha,{"D1_QUANT"		, M->TQN_QUANT		, nil	})
			aadd(aLinha,{"D1_VUNIT"		, M->TQN_VALUNI		, nil	})
			aadd(aLinha,{"D1_TOTAL"		, M->TQN_VALTOT		, nil	})
			aadd(aLinha,{"D1_CLVL"		, cSEGMENT			, nil	})
			aadd(aLinha,{"D1_CC"		, cCENTROC 			, nil	})
			aadd(aLinha,{"D1_ITEMCTA"	, cITEMCON			, nil	})
			aadd(aItens,aLinha)
			
			MsExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
			
			If lMsErroAuto
				Mostraerro()
			Else											
				M->TQN_DTCON := M->TQN_DTABAS		
			EndIf
			
		EndIf
	
	EndIf
	RestArea(aArea)

Return (lRet)
