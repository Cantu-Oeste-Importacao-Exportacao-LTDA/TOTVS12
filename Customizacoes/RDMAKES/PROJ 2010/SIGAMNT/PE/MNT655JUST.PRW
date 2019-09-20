#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNT655JUST ºAutor  ³Rafael Parma        º Data ³  17/01/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado após a confirmação de exclusão   º±±
±±º          ³rotina de abastecimento manual (MNTA655).                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------*
User Function MNT655JUST()       
*-------------------------------*
Local lRet := .T.
Local aArea    := GetArea()
Local cTIPOTIT := "DP "
Local cXPRFTCB := ALLTRIM(GETMV("MV_X_PRFTC"))
Local cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])

Private	lMsErroAuto := .F. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	                        		                        
	//-- Exclusão de título gerado na inclusão do abastecimento manual.
	If TQN->TQN_X_NFCF == "C" .and. POSICIONE("SA2",1,xFilial("SA2")+TQN->TQN_POSTO+TQN->TQN_LOJA,"A2_EST") == "EX"
		
		aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		,	Nil},;      
						{"E2_PREFIXO"	, cXPRFTCB	   			,	Nil},;      
		  				{"E2_NUM"		, TQN->TQN_NOTFIS		,	Nil},;      
						{"E2_PARCELA"	, cPARCELA				,	Nil},;      
						{"E2_TIPO"		, cTIPOTIT	    		,	Nil},;      
						{"E2_FORNECE"	, TQN->TQN_POSTO	 	,	Nil},;      
						{"E2_LOJA"		, TQN->TQN_LOJA		  	,	Nil} }      
	
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
		
		If lMsErroAuto
			DisarmTransaction()
			Mostraerro()
		EndIf				
	
	//-- Exclusão documento de pré-nota gerado na inclusão do abastecimento manual.	
	ElseIf TQN->TQN_X_NFCF == "N" .and. POSICIONE("SA2",1,xFilial("SA2")+TQN->TQN_POSTO+TQN->TQN_LOJA,"A2_EST") != "EX"	
	                       
	    
	    cNUMDOC  := STRZero(Val(TQN->TQN_NOTFIS),TAMSX3("F1_DOC")[1])
		aCabec := {}
		aadd(aCabec,{"F1_TIPO"   	, "N"				})
		aadd(aCabec,{"F1_FORMUL" 	, "N"				})
		aadd(aCabec,{"F1_DOC"    	, cNUMDOC			})
		aadd(aCabec,{"F1_SERIE"  	, TQN->TQN_X_SERI	})
		aadd(aCabec,{"F1_EMISSAO"	, TQN->TQN_DTABAS	})
		aadd(aCabec,{"F1_FORNECE"	, TQN->TQN_POSTO	})
		aadd(aCabec,{"F1_LOJA"   	, TQN->TQN_LOJA		})
		aadd(aCabec,{"F1_ESPECIE"	, "NFE"				})

		aItens := {}
		aLinha := {}
		aadd(aLinha,{"D1_COD"  		, cXCPPNAB			, nil	})
		aadd(aLinha,{"D1_QUANT"		, TQN->TQN_QUANT	, nil	})
		aadd(aLinha,{"D1_VUNIT"		, TQN->TQN_VALUNI	, nil	})
		aadd(aLinha,{"D1_TOTAL"		, TQN->TQN_VALTOT	, nil	})
		aadd(aItens,aLinha)
		
		MsExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,5)
		
		If lMsErroAuto
			DisarmTransaction()
			Mostraerro()
		EndIf
			
	EndIf
	
	//-- Atualiza classe de valor no movimento interno.
	dbSelectArea("ST9")	// Bens
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("ST9") + TQN->TQN_FROTA )
		If !Empty(ST9->T9_X_CLVL)
			dbSelectArea("SD3")
			dbSetOrder(4)
			dbGoTop()
			If dbSeek( xFilial("SD3") + TQN->TQN_NUMSEQ )
				If RecLock("SD3",.F.)
					SD3->D3_CLVL := ST9->T9_X_CLVL
				EndIf
			EndIf
		EndIf
	EndIf 
	
	RestArea(aArea)	
	
Return (lRet)
