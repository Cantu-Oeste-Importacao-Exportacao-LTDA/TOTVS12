#include "TOTVS.CH"
#include "TOPCONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA120BUT   ºAutor  ³Rafael Parma       º Data ³  06/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para adicionar botões ao pedido de compras.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function MA120BUT()
*----------------------------*
Local aRet := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
		aAdd(aRet, {"POSCLI" , {|| U_RJ120PAR(.T.,.T.,.T.) }, "Fluxo de caixa", "Fluxo CX" } ) 
	EndIf
		
Return (aRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJ120PAR   ºAutor  ³Rafael Parma       º Data ³  06/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para visualização de registros fluxo de caixa comprasº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------*
User Function RJ120PAR(lPEDIDO, lRetorno, lJanela, lGCT)
*-------------------------------------------------*
PRIVATE STRING_NULL := ""
PRIVATE lChkALL     := .F.
PRIVATE lChkSLD     := .F.
PRIVATE lChkFIE     := .F.
PRIVATE nUsado      := 0
PRIVATE nOpcao      := 0
PRIVATE nVALPED     := 0
PRIVATE nVALORI     := 0
PRIVATE nSLDINI     := 0  
PRIVATE nTOTFIE     := 0
PRIVATE nOPCPAR		:= GD_INSERT + GD_UPDATE + GD_DELETE
PRIVATE aTravas     := {}
PRIVATE aRecFCX     := {}
PRIVATE aColsFCX    := {}
PRIVATE aHeadFCX    := {}
PRIVATE aFldsFCX    := {}   
PRIVATE aRecPAR     := {}
PRIVATE aHeadPAR    := {}
PRIVATE aHdAlPAR	:= {}
PRIVATE aFldsPAR    := {}
PRIVATE aPARCELA    := {}
PRIVATE cNEWCOND    := STRING_NULL
PRIVATE cDESCOND    := Space(TAMSX3("E4_DESCRI")[1])
PRIVATE dFDATPRC    := ddatabase
PRIVATE dFDATADE    := ddatabase
PRIVATE dFDATATE    := ddatabase+30
PRIVATE cEntZ10     := "Z10"
PRIVATE cSeekFCX    := STRING_NULL
PRIVATE cCA120NUM   := STRING_NULL

PRIVATE nPDATPRF := 0
PRIVATE dPDATPRF := dFDATADE  

PRIVATE dFDATDEANT  := dFDATADE
PRIVATE dFDATATANT  := dFDATATE
PRIVATE cCONDPGANT  := cNEWCOND
PRIVATE lChkALLANT  := lChkALL
PRIVATE lChkSLDANT  := lChkSLD

PRIVATE oDlgFLUXO
PRIVATE oCheckBox
PRIVATE oGetPAR
PRIVATE oGetFCX 

DEFAULT lRetorno := .T.
DEFAULT lGCT := .F.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                          
	//-- Pedido compras de comissões.
	If "RJFINP01" $ FUNNAME()
		Return
	EndIf            
	
	//--Janela pedido compras/atualiza cotação
	If lJanela
	
		nPDATPRF   := IIF(lPEDIDO .OR. lGCT,aScan(aHeader,{|x| AllTrim(x[2])=="C7_DATPRF"}),aScan(aHeader,{|x| AllTrim(x[2])=="C8_DATPRF"}))
		cNEWCOND   := cCONDICAO  
		cCA120NUM  := CA120NUM
		cCONDPGANT := cNEWCOND
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Data prevista de entrega                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(aCols[01][nPDATPRF])
			dPDATPRF := aCols[01][nPDATPRF]
		EndIf
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualização do array de valores                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lPEDIDO
			//-- SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE
			nPosFLX := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_FLUXO'})
			nPosTOT := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_TOTAL'})
			nPosIPI := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_VALIPI'})
			nPosST 	:= aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ICMSRET'}) //Gustavo 18/05/15 - Alterado para validar ST no Fluxo de Caixa.			
			If Len(aCols) > 0
				For nI := 1 to Len(aCols)
					If !aCols[nI][Len(aCols[nI])] .and. aCols[nI,nPosFLX] == "S"
						nVALPED += aCols[nI,nPosTOT]+aCols[nI,nPosIPI]+aCols[nI,nPosST] //Gustavo 18/05/15 - Alterado para validar ST no Fluxo de Caixa.
					EndIf
				Next nI
				nVALPED += aValores[03]	//Valor total do frete
				nVALPED += aValores[04]	//Valor total da despesa
				nVALPED += aValores[07]	//Valor total do seguro
				nVALPED -= aValores[02]	//Valor total do desconto									
			Else
				nVALPED := aValores[06]	// Total do Pedido		
			EndIf
		
		Elseif (lGCT)
			nVALORI := __nVALPEDC
			nVALPED := __nVALPEDC	// Total da medição
		Else
			nVALORI := nVALPED
			nVALPED := a150Var[08]	// Total da Cotação

		EndIf

	Else //-- Opção do menu
		
		nPDATPRF   := SC7->C7_DATPRF
		cNEWCOND   := SC7->C7_COND
		cCA120NUM  := SC7->C7_NUM
		cCONDPGANT := cNEWCOND
		
		aAreaSC7 := SC7->(GetArea())
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial("SC7")+cCA120NUM)
		While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7")+cCA120NUM
			If SC7->C7_FLUXO == "S"
				nVALPED += SC7->C7_TOTAL + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE + SC7->C7_ICMSRET //Gustavo 18/05/15 - Alterado para validar ST no Fluxo de Caixa.
			EndIf
			SC7->(dbSkip())
		Enddo
		RestArea(aAreaSC7)
	
	EndIf
              

	If lPEDIDO

		//-- Verifica se existe título PA relacionado ao pedido.
		dbSelectArea("FIE")
		dbSetOrder(1)
		If dbSeek ( xFilial("FIE") + "P" + cCA120NUM )
			lChkFIE := .T.
			While ! FIE->(EOF()) .and. FIE->(FIE_FILIAL+FIE_CART+FIE_PEDIDO) == xFilial("FIE") + "P" + cCA120NUM
				nTOTFIE += FIE->FIE_VALOR
				FIE->(dbSkip())
			Enddo		
		EndIf
		
		nVALORI := nVALPED
		nVALPED := Round(nVALPED - nTOTFIE, 2)

	EndIf
		
                                                                                

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recupera vencimentos/valores da condição de pagamento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lPEDIDO   
		//-- Gustavo 17/09/15
		// Caso o pedido esteja sendo visualizado pelo documento de entrada
		// Chama o ponto de entrada para criar as variáveis públicas.
		If !IsInCallStack("U_MT120BRW()")
			U_MT120BRW()		
		EndIf  
		//-- Fim Gustavo 17/09/2015
		If __cCPGPEDC != cNEWCOND .or. __nVALPEDC != nVALPED
			__aPARCPED := {}
			__cFILPEDC := Space(02)
			__cNUMPEDC := Space(06)
			__cCPGPEDC := cNEWCOND
			__nVALPEDC := nVALPED
	        			
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("Z11") + cCA120NUM )
				aPARCELA := {}
				
				If nVALPED > 0
					While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + cCA120NUM					
						aAdd (aPARCELA, { Z11->Z11_VENCTO, Z11->Z11_VALOR } )
						Z11->(dbSkip())		
					Enddo
				EndIf
					
			Else
				aPARCELA := Condicao(nVALPED,cNEWCOND,,dPDATPRF)
			EndIf
		EndIf
	Elseif (lGCT) // Flavio - 23/04/2012 - Validação para gestão de contratos customizada
		aPARCELA := aClone(__APARGCT)
	Else
		If __cCPGCOTC != cNEWCOND .or. __nVALCOTC != nVALPED
			__aPARCCOT := {}
			__cFILCOTC := Space(02)
			__cNUMCOTC := Space(06)
			__cCPGCOTC := cNEWCOND
			__nVALCOTC := nVALPED
	
			dbSelectArea("Z11")
			dbSetOrder(2)	//Z11_FILIAL+Z11_COTACA+Z11_FORNEC+Z11_LOJA+DTOS(Z11_VENCTO) 
			dbGoTop()
			If dbSeek( xFilial("Z11")+cA150Num+cA150Forn+cA150Loj )
				aPARCELA := {}
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL+Z11->Z11_COTACA+Z11->Z11_FORNEC+Z11->Z11_LOJA == xFilial("Z11")+cA150Num+cA150Forn+cA150Loj
					aAdd (aPARCELA, { Z11->Z11_VENCTO, Z11->Z11_VALOR } )
					Z11->(dbSkip())		
				Enddo
			Else
				aPARCELA := Condicao(nVALPED,cNEWCOND,,dPDATPRF)
			EndIf
		EndIf	
	EndIf
	
		
	If Len(aPARCELA) > 0
		dFDATADE := aPARCELA[01][01]
		For nI := 1 to Len(aPARCELA)
			If dFDATATE < aPARCELA[nI][01]+15	
				dFDATATE := aPARCELA[nI][01]+15	
			EndIf
		Next nI
	ElseIf Len(__aPARCPED) > 0
		dFDATADE := __aPARCPED[01][01]
	EndIf

	cDESCOND := Posicione("SE4",1,xFilial("SE4")+cNEWCOND,"E4_DESCRI")


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aHeadFCX - TABELA PAR                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("Z11_VENCTO")
	aAdd(aHeadPAR,{AllTrim(X3Titulo()),;
			              SX3->X3_CAMPO,;
			              SX3->X3_PICTURE,;
			              SX3->X3_TAMANHO,;
			              SX3->X3_DECIMAL,;
			              "U_RJ120VDT(.T.)",;
			              SX3->X3_USADO,;
			              SX3->X3_TIPO,;
			              SX3->X3_F3,;
			              SX3->X3_CONTEXT,;
			              SX3->X3_CBOX,;
			              SX3->X3_RELACAO,;
			              ".T."})
	aAdd (aHdAlPAR, SX3->X3_CAMPO)			              				
	dbSeek("Z11_VALOR")
	aAdd(aHeadPAR,{AllTrim("Valor Parcela"),;
			              SX3->X3_CAMPO,;
			              SX3->X3_PICTURE,;
			              SX3->X3_TAMANHO,;
			              SX3->X3_DECIMAL,;
			              "U_RJ120VDT(.F.)",;
			              SX3->X3_USADO,;
			              SX3->X3_TIPO,;
			              SX3->X3_F3,;
			              SX3->X3_CONTEXT,;
			              SX3->X3_CBOX,;
			              SX3->X3_RELACAO,;
			              ".T."})				
	aAdd (aHdAlPAR, SX3->X3_CAMPO)
	dbSeek("Z10_BLOQ")
	aAdd(aHeadPAR,{AllTrim(X3Titulo()),;
			              SX3->X3_CAMPO,;
			              SX3->X3_PICTURE,;
			              SX3->X3_TAMANHO,;
			              SX3->X3_DECIMAL,;
			              SX3->X3_VALID,;
			              SX3->X3_USADO,;
			              SX3->X3_TIPO,;
			              SX3->X3_F3,;
			              SX3->X3_CONTEXT,;
			              SX3->X3_CBOX,;
			              SX3->X3_RELACAO,;
			              ".T."})				
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aCols - TABELA PAR                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

	If lPEDIDO
		
		If Len(aPARCELA) > 0 .and. ( Len(__aPARCPED) == 0 .or. ( __cFILPEDC != xFilial("SC7") .and. __cNUMPEDC != cCA120NUM  ) ) 		
			__cNUMPEDC := cCA120NUM
			__cFILPEDC := xFilial("SC7")
			__aPARCPED := {}		
			For nI := 1 to Len(aPARCELA)  
				AAdd(__aPARCPED,Array(4))
				__aPARCPED[nI][01] := aPARCELA[nI][01]
				__aPARCPED[nI][02] := aPARCELA[nI][02]
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica disponibilidade da data de vencimento                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
						
				cDATABLOQ := "S"
				dbSelectArea("Z10")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("Z10") + dtos(aPARCELA[nI][01]) )
					If Z10->Z10_BLOQ == "N"
						nSALDOEST := U_RJFC01SC()
						/* RETIRADA VALIDACAO DE SALDO.
						If nSALDOEST >= aPARCELA[nI][02]
							cDATABLOQ := "N"           							
						EndIf                          
						*/                                                      
						cDATABLOQ := "N"
					EndIf
				EndIf
				
				__aPARCPED[nI][03] := cDATABLOQ
				__aPARCPED[nI][04] := .F.
			Next nI
		EndIf
	Elseif(lGCT)
		aPARCELA := aClone(__APARGCT)
		__APARGCT := {}
		
		AAdd(__APARGCT,Array(4))
		__APARGCT[01][01] := aPARCELA[01][01]
		__APARGCT[01][02] := aPARCELA[01][02]
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica disponibilidade da data de vencimento                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
						
		cDATABLOQ := "S"
		dbSelectArea("Z10")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("Z10") + dtos(aPARCELA[01][01]) )
			If Z10->Z10_BLOQ == "N"			
				nSALDOEST := U_RJFC01SC()
				/* RETIRADA VALIDACAO DE SALDO.
				If nSALDOEST >= aPARCELA[01][02]
					cDATABLOQ := "N"           					
				EndIf                          
				*/                                              
				cDATABLOQ := "N"           					
			EndIf
		EndIf
				
		__APARGCT[01][03] := cDATABLOQ
		__APARGCT[01][04] := .F.		
		
	Else // Cotação de compra
		
		If Len(aPARCELA) > 0 .and. ( Len(__aPARCCOT) == 0 .or. ( __cFILCOTC != xFilial("SC8") .and. __cNUMCOTC != cA150Num .and. __cFORCOTC != cA150Forn .and. __cLOJCOTC != cA150Loj ) ) 		
			__cNUMCOTC := cA150Num
			__cFILCOTC := xFilial("SC7")
			__cFORCOTC := cA150Forn
			__cLOJCOTC := cA150Loj
			__aPARCCOT := {}		
			For nI := 1 to Len(aPARCELA)  
				AAdd(__aPARCCOT,Array(4))
				__aPARCCOT[nI][01] := aPARCELA[nI][01]
				__aPARCCOT[nI][02] := aPARCELA[nI][02]
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica disponibilidade da data de vencimento                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
						
				cDATABLOQ := "S"
				dbSelectArea("Z10")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("Z10") + dtos(aPARCELA[nI][01]) )
					If Z10->Z10_BLOQ == "N"                                                                                                					
						nSALDOEST := U_RJFC01SC()
						/* RETIRADA VALIDACAO DE SALDO.
						If nSALDOEST >= aPARCELA[nI][02]
							cDATABLOQ := "N"
						EndIf                          
						*/
						cDATABLOQ := "N"
					EndIf
				EndIf
				
				__aPARCCOT[nI][03] := cDATABLOQ
				__aPARCCOT[nI][04] := .F.
			Next nI
		EndIf 
		
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aHeadFCX - TABELA FCX                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nUsado := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntZ10)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntZ10 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z10_FILIAL|Z10_SLDANT|Z10_VLRENT|Z10_VLRSAI|Z10_VLRPDC||Z10_SLDATU|Z10_SLDMAN|Z10_SLDEST" )
			nUsado++
			
			aAdd(aHeadFCX,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsFCX, SX3->X3_CAMPO)
			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem do aCols - TABELA FCX                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea(cEntZ10)
 	dbSetOrder(1)
 	(cEntZ10)->(dbGoTop())
	cSeekFCX := xFilial( cEntZ10 ) + dtos(dFDATADE)
	
	If dbSeek ( cSeekFCX )
		While !(cEntZ10)->(EOF()) .and. Z10->Z10_FILIAL == xFilial( cEntZ10 ) .and. dtos(Z10->Z10_DATA) >= dtos(dFDATADE) .and. dtos(Z10->Z10_DATA) <= dtos(dFDATATE)
		                            
			nSALDOEST := U_RJFC01SC()
			/* RETIRADA VALIDACAO DE SALDO.
			If (cEntZ10)->Z10_BLOQ == "N" .and. nSALDOEST > nVALPED
			*/  
			If (cEntZ10)->Z10_BLOQ == "N"
				dFDATPRC := Z10->Z10_DATPRC
				AAdd(aColsFCX,Array(nUsado+1))
				AAdd(aRecFCX, (cEntZ10)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeadFCX[nCntFor][10] != "V" )
						If aHeadFCX[nCntFor][02] != "Z10_SLDANT" .and. aHeadFCX[nCntFor][02] != "Z10_SLDEST"          
							aColsFCX[Len(aColsFCX)][nCntFor] := Z10->(FieldGet(FieldPos(aHeadFCX[nCntFor][2])))
						ElseIf aHeadFCX[nCntFor][02] == "Z10_SLDEST"          
							aColsFCX[Len(aColsFCX)][nCntFor] := nSALDOEST
						Else
							nSLDINI := Z10->(FieldGet(FieldPos(aHeadFCX[nCntFor][2])))
							aColsFCX[Len(aColsFCX)][nCntFor] := CriaVar(aHeadFCX[nCntFor,2])
						EndIf
					Else
						aColsFCX[Len(aColsFCX)][nCntFor] := CriaVar(aHeadFCX[nCntFor,2])
					EndIf
				Next
				aColsFCX[Len(aColsFCX)][nUsado+1] := .F.
			EndIf
			(cEntZ10)->(dbSkip())
		EndDo
	EndIf

	
	If Empty( aColsFCX )
		AAdd(aColsFCX,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsFCX[1,nCntFor] := CriaVar(aHeadFCX[nCntFor,2], .F. )
		Next nCntFor
		aColsFCX[1][nUsado+1] := .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta janela                                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      

	dFDATDEANT  := dFDATADE
	dFDATATANT  := dFDATATE
	cCONDPGANT  := cNEWCOND 
	lChkALLANT  := lChkALL
	lChkSLDANT  := lChkSLD


	If nVALPED > 0

		DEFINE DIALOG oDlgFLUXO TITLE "Consulta de fluxo de caixa para compras" FROM 0,0 TO 460,800 PIXEL
	
	// QUADRO SALDO BANCARIO	
	//	@ 0.5,0.5 TO 002,050
	
		@ 0.5,0.5 TO 002,029
		@ 014,010 SAY "Total do Pedido:" OF oDlgFLUXO PIXEL
		@ 012,065 MSGET nVALORI  SIZE 045,10 PICTURE "@E 999,999,999.99" WHEN .F. OF oDlgFLUXO PIXEL
		@ 014,125 SAY "Data Entrega:" OF oDlgFLUXO PIXEL
		@ 012,175 MSGET dPDATPRF SIZE 045,10  WHEN .F. OF oDlgFLUXO PIXEL
	
	// VALOR SALDO BANCARIO
	//	@ 014,245 SAY "Saldo Bancário ("+dtoc(dFDATPRC)+"):" OF oDlgFLUXO PIXEL
	//	@ 012,325 MSGET nSLDINI  SIZE 045,10 PICTURE "@E 999,999,999.99" WHEN .F. OF oDlgFLUXO PIXEL
	
		@ 2.5,0.5 TO 006,029
		@ 042,010 SAY "Cond. Pagto:" OF oDlgFLUXO PIXEL
		@ 040,065 MSGET cNEWCOND SIZE 045,10 F3 "SE4" VALID (fUpdCP(lPEDIDO)) WHEN .T. OF oDlgFLUXO PIXEL
		@ 040,125 MSGET cDESCOND SIZE 050,10 WHEN .F. OF oDlgFLUXO PIXEL
		@ 057,010 SAY "Filtrar Período:" OF oDlgFLUXO PIXEL
		@ 055,065 MSGET dFDATADE SIZE 045,10 VALID (MsAguarde({|| fSetFilter(1), "Aguarde!"})) WHEN .T. OF oDlgFLUXO PIXEL
		@ 055,125 MSGET dFDATATE SIZE 040,10 VALID (MsAguarde({|| fSetFilter(2), "Aguarde!"})) WHEN .T. OF oDlgFLUXO PIXEL	
	//	@ 071,010 CHECKBOX oCheckBox VAR lChkALL PROMPT "Fluxo Compartilhado (Filiais) " SIZE 100,7 PIXEL OF oDlgFLUXO ON CHANGE (MsAguarde({|| fSetFilter(3), "Aguarde!"}))
		
	// FLAG SALDO BANCARIO COMPOE FLUXO
	//	@ 071,125 CHECKBOX oCheckBox VAR lChkSLD PROMPT "Saldo Bancário Compõe Fluxo"  SIZE 100,7 PIXEL OF oDlgFLUXO ON CHANGE (MsAguarde({|| fSetFilter(4), "Aguarde!"}))
	//	oGetPAR := MsNewGetDados():New( 035, 240, 085, 400, 0, STRING_NULL, STRING_NULL, , aFldsFCX, 000, 999,, STRING_NULL, .F., , aHeadPAR ,__aPARCPED )		    
	                            
		oGetPAR := MsNewGetDados():New( 008, 240, 085, 400, nOPCPAR, "AllwaysTrue()", "AllwaysTrue()", , aHdAlPAR, 000, 099,, STRING_NULL, .T., , aHeadPAR ,IIF(lPEDIDO,__aPARCPED,iif(lGCT, __APARGCT, __aPARCCOT)) )		    
		oGetFCX := MsNewGetDados():New( 090, 005, 200, 400, 0, STRING_NULL, STRING_NULL, , aFldsFCX, 000, 999,, STRING_NULL, .F., , aHeadFCX ,aColsFCX )

		If  nTOTFIE > 0
			@ 212,010 SAY "Total PA:" OF oDlgFLUXO PIXEL
			@ 210,065 MSGET nTOTFIE  SIZE 045,10 PICTURE "@E 999,999,999.99" WHEN .F. OF oDlgFLUXO PIXEL

			@ 212,125 SAY "Saldo Restante:" OF oDlgFLUXO PIXEL
			@ 210,175 MSGET nVALPED  SIZE 045,10 PICTURE "@E 999,999,999.99" WHEN .F. OF oDlgFLUXO PIXEL
		EndIf	
	
		DEFINE SBUTTON FROM 210, 330 TYPE 1 ACTION (nOpcao:=1,IIf(U_RJ120VDV(.F.,.F.,oGetPAR),oDlgFLUXO:End(),nOpcao:=0))ENABLE OF oDlgFLUXO PIXEL
		DEFINE SBUTTON FROM 210, 360 TYPE 2 ACTION (nOpcao:=2,oDlgFLUXO:End())ENABLE OF oDlgFLUXO PIXEL
		
		ACTIVATE DIALOG oDlgFLUXO CENTERED 
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Define nova condicao a janela principal                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
		
		If nOpcao == 1
			If lJanela
				CCONDICAO := cNEWCOND
				CDESCCOND := cDESCOND
				If lPEDIDO
					__cCPGPEDC := CCONDICAO 
					__aPARCPED := oGetPAR:aCols
				Elseif lGCT
					__cCPGPEDC := CCONDICAO
					__aPARGCT  := oGetPAR:aCols
				Else
					__cCPGCOTC := CCONDICAO 
					__aPARCCOT := oGetPAR:aCols
				EndIf
			Else				
				aAreaSC7 := SC7->(GetArea())
				__cCPGPEDC := cNEWCOND
				__aPARCPED := oGetPAR:aCols
				lRet := .F.
				MsAguarde( { || lRet := U_RJ120VCP(dPDATPRF,nVALPED) }, "Verificando datas de pagamento..."  )
				If lRet
					U_fUpdZ10(cCA120NUM, 4 )
				EndIf
				RestArea(aAreaSC7)
			EndIf
			lRetorno := .T.
		Else
			lRetorno := .F.
		EndIf 
		
	Else
		
		lRetorno := .T.
		
	EndIf
		
Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdCP     ºAutor  ³Rafael Parma       º Data ³  06/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para atualizar GetDados de vencimentos/valores.      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------*
Static Function fUpdCP(lPEDIDO)
*---------------------------------*

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação condição pagamento                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//Gustavo 18/05/15 - Alterado para recalcular o valor das parcelas em casos que o pedido tenha ST
	If ALLTRIM(FunName()) == "GESCTRL" 
		If cCONDPGANT == cNEWCOND
			Return (.T.)
		EndIf  
	EndIf	 
      
    If !ExistCPO("SE4",cNEWCOND)
       	Return (.F.)
    Else
    	cDESCOND := Posicione("SE4",1,xFilial("SE4")+cNEWCOND,"E4_DESCRI")
    EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualização do array de valores                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lPEDIDO
		nVALPED := aValores[06]	// Total do Pedido
	Else
		nVALPED := a150Var[08]	// Total da Cotação
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recupera vencimentos/valores da condição de pagamento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	oGetPAR:aCols := {}
	aPARCELA := Condicao(nVALPED,cNEWCOND,,dPDATPRF)

	If Len(aPARCELA) > 0
		For nI := 1 to Len(aPARCELA)  
			AAdd(oGetPAR:aCols,Array(4))
			oGetPAR:aCols[nI][01] := aPARCELA[nI][01]
			oGetPAR:aCols[nI][02] := aPARCELA[nI][02]

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Verifica disponibilidade da data de vencimento                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
					
			cDATABLOQ := "S"
			dbSelectArea("Z10")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("Z10") + dtos(aPARCELA[nI][01]) )
				If Z10->Z10_BLOQ == "N"
					nSALDOEST := U_RJFC01SC()
					/* RETIRADA VALIDACAO DE SALDO.
					If nSALDOEST >= aPARCELA[nI][02]
						cDATABLOQ := "N"
					EndIf                          
					*/                  
					cDATABLOQ := "N"
				EndIf         
			EndIf
			
			oGetPAR:aCols[nI][03] := cDATABLOQ
			oGetPAR:aCols[nI][04] := .F.
		Next nI
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza variaveis de controle/ambiente                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
	
	cCONDPGANT := cNEWCOND
	oGetPAR:Refresh()
	oDlgFLUXO:Refresh()

Return (.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSetFilter ºAutor  ³Rafael Parma       º Data ³  06/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para filtrar registros tabela fluxo de caixa compras.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*---------------------------------*
Static Function fSetFilter(nDAT)
*---------------------------------*

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se os parametros de filtros foram alterados                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      

	If nDAT == 1
		If dFDATDEANT == dFDATADE
			Return (.T.)
		EndIf
	ElseIf nDAT == 2
		If dFDATATANT == dFDATATE
			Return (.T.)
		EndIf
	ElseIf nDAT == 3
		If lChkALLANT == lChkALL
			Return (.T.)
		EndIf
	Else
		If lChkSLDANT == lChkSLD
			Return (.T.)
		EndIf
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Filtro de dados tabela fluxo caixa compras                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      

	oGetFCX:aCols := {}
	
	If lChkALL 
		cSeekFIL := "ZZ"
	Else                
		cSeekFIL := xFilial(cEntZ10)
	EndIf           

	dbSelectArea(cEntZ10)
 	dbSetOrder(1)
 	(cEntZ10)->(dbGoTop())
	cSeekFCX := cSeekFIL + dtos(dFDATADE)


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recalculo do saldo acumulado retroativo                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
    nSALDOAC := nSLDINI
    If lChkSLD
    	If dFDATADE > ddatabase
        	dbSeek( cSeekFIL + dtos(ddatabase) )
        	While !Z10->(EOF()) .and. Z10->Z10_FILIAL == cSeekFIL .and. Z10->Z10_DATA < dFDATADE
        		nSALDOAC += ( Z10->Z10_VLRENT - ( Z10->Z10_VLRSAI + Z10->Z10_VLRPDC ))
        		Z10->(dbSkip())
        	Enddo
        EndIf
    EndIf
	


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza aCols do fluxo de caixa                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
	
	dbSelectArea(cEntZ10)
 	dbSetOrder(1)
 	(cEntZ10)->(dbGoTop())
	If dbSeek ( cSeekFCX )
		While !(cEntZ10)->(EOF()) .and. Z10->Z10_FILIAL == cSeekFIL .and. dtos(Z10->Z10_DATA) >= dtos(dFDATADE) .and. dtos(Z10->Z10_DATA) <= dtos(dFDATATE)	

			nSALDOEST := U_RJFC01SC()
			/* RETIRADA VALIDACAO DE SALDO.
			If (cEntZ10)->Z10_BLOQ == "N" .and. nSALDOEST > nVALPED
			*/
			If (cEntZ10)->Z10_BLOQ == "N"
				AAdd(oGetFCX:aCols,Array(nUsado+1))
				AAdd(aRecFCX, (cEntZ10)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeadFCX[nCntFor][10] != "V" )					
						If aHeadFCX[nCntFor][02] != "Z10_SLDANT" .and. aHeadFCX[nCntFor][02] != "Z10_SLDEST"
							oGetFCX:aCols[Len(oGetFCX:aCols)][nCntFor] := Z10->(FieldGet(FieldPos(aHeadFCX[nCntFor][2])))
						ElseIf aHeadFCX[nCntFor][02] == "Z10_SLDEST"          
							oGetFCX:aCols[Len(oGetFCX:aCols)][nCntFor] := nSALDOEST
						Else
							If !lChkSLD
								oGetFCX:aCols[Len(oGetFCX:aCols)][nCntFor] := CriaVar(aHeadFCX[nCntFor,2])					
							Else
								oGetFCX:aCols[Len(oGetFCX:aCols)][nCntFor] := nSALDOAC
							EndIf
						EndIf
					Else
						oGetFCX:aCols[Len(oGetFCX:aCols)][nCntFor] := CriaVar(aHeadFCX[nCntFor,2])
					EndIf
				Next
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Atualiza variável de saldo                                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
				If lChkSLD
					nSALDOAC += ( Z10->Z10_VLRENT - ( Z10->Z10_VLRSAI + Z10->Z10_VLRPDC ))
				EndIf
					
				oGetFCX:aCols[Len(oGetFCX:aCols)][nUsado+1] := .F.
			EndIf
			(cEntZ10)->( dbSkip() )
		EndDo
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza variaveis de controle/ambiente                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      
	
	dFDATDEANT := dFDATADE
	dFDATATANT := dFDATATE
	lChkALLANT := lChkALL
	lChkSLDANT := lChkSLD
	
	oGetFCX:Refresh()
	oDlgFLUXO:Refresh()	

Return (.T.) 
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJ120VDV ºAutor  ³ Rafael Parma      º Data ³  29/11/2010   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar para validacao da MsGetDados.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------*
User Function RJ120VDV(lPAR,lTRG,oOBJ)
*-------------------------------------*
Local aArea  := GetArea()
Local nTOTAL := 0
Local lRet   := .T.
Default oOBJ := nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                      
    
	//-- Digitação dos dados..
	If lTRG	
		If Len(aCols) > 0
			For nI := 1 to Len(aCols)  
				If !aCols[nI][Len(aCols[nI])]
					If lPAR									
						nTOTAL += aCols[nI][02]
						nVALOR := aCols[nI][02]
						If n == nI 
							sDATAV := dtos(M->Z11_VENCTO)
							
							If M->Z11_VENCTO < ddatabase
								MsgInfo("A data de vencimento deve ser maior ou igual a database!")
								Return .F.
							EndIf
							
						Else                             
							sDATAV := dtos(aCols[nI][01])
						EndIf
					Else
						If n == nI
							nTOTAL += M->Z11_VALOR
							nVALOR := M->Z11_VALOR
						Else
							nTOTAL += aCols[nI][02]
							nVALOR := aCols[nI][02]					
						EndIf
						sDATAV := dtos(aCols[nI][01])
					Endif
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Verifica disponibilidade da data de vencimento                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
					
					dbSelectArea("Z10")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("Z10") + sDATAV )
						If Z10->Z10_BLOQ == "N"                                                                                
							nSALDOEST := U_RJFC01SC()
							/* RETIRADA VALIDACAO DE SALDO.
							If nSALDOEST < nVALOR
								aCols[nI][03] := "S"													
							Else
								aCols[nI][03] := "N"
							EndIf                          
							*/                      
							aCols[nI][03] := "N"
						Else
							aCols[nI][03] := "S"
						EndIf
					Else
						aCols[nI][03] := "S"
					EndIf
				EndIf
			Next nI
		
			If ALLTRIM(FUNNAME()) $ "MATA121-MATA122"
				If nTOTAL > __nVALPEDC            
					MsgInfo("O valor total das parcelas não é igual ao valor total do pedido, verifique!")
					lRet := .F.
				EndIf
			Else
				If nTOTAL > __nVALCOTC            
					MsgInfo("O valor total das parcelas não é igual ao valor total do pedido, verifique!")
					lRet := .F.
				EndIf
			EndIf
				
		EndIf 
	
	Else	//-- Confirmação da validação..

		lNumDayMin := .F.
		nNumDayMin := SuperGetMV("MV_X_NDMPC",,0)
		
		lNumDayPas := .F.
		nNumDayPas := SuperGetMV("MV_X_NDMPS",,0)

		If Len(oOBJ:aCols) > 0
			For nI := 1 to Len(oOBJ:aCols)  
				If !oOBJ:aCols[nI][Len(oOBJ:aCols[nI])]
					nTOTAL += oOBJ:aCols[nI][02]  

					If oOBJ:aCols[nI][01] < ( ddatabase + nNumDayPas )
						lNumDayPas := .T.
					EndIf
					
					If oOBJ:aCols[nI][01] < ( ddatabase + nNumDayMin )
						lNumDayMin := .T.
					EndIf
				EndIf
			Next nI
		EndIf				
	    
		If ALLTRIM(FUNNAME()) $ "MATA121-MATA122"
			If nTOTAL != __nVALPEDC
				MsgInfo("O valor total das parcelas não é igual ao valor total do pedido, verifique!")
				lRet := .F.
			EndIf
		Elseif ALLTRIM(FUNNAME()) == "GESCTRL"
			If nTOTAL != __nVALPEDC
				MsgInfo("O valor total das parcelas não é igual ao valor total do pedido, verifique!")
				lRet := .F.
			EndIf
		Else
			If nTOTAL != __nVALCOTC
				MsgInfo("O valor total das parcelas não é igual ao valor total do pedido, verifique!")
				lRet := .F.
			EndIf
		EndIf
		
		//-- Número mínimo de dias para o vencimento.
		If lNumDayMin
			MsgInfo("Exite(m) parcela(s) com data de vecimento menor que a data mínima permitida ("+cValToChar(nNumDayMin)+") dias.")
			lRet := .F.
		ElseIf lNumDayPas                                                                                                            
			MsgInfo("Exite(m) parcela(s) com data de vecimento menor que a data mínima permitida ("+cValToChar(nNumDayPas)+") dias, porém o pedido poderá ser liberado pelo supervisor.")
		EndIf

	EndIf
	
	RestArea(aArea)
	        
Return (lRet)
                              


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJ120VDT ºAutor  ³ Rafael Parma      º Data ³  25/01/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar para validação dos dados (data/valor) infor-±±
±±º          ³ mados pelo usuário na janela do fluxo de caixas.           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------------*
User Function RJ120VDT(lVENCTO)
*--------------------------------* 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//-- Campo: Data
	If lVENCTO
		dbSelectArea("Z10")
		dbSetOrder(1)
		dbGoTop()     
		//-- Localiza data para verificar se existe saldo.
		If dbSeek ( xFilial("Z10") + dtos(M->Z11_VENCTO) )
		    //-- Verifica se data bloqueada.
			If Z10->Z10_BLOQ == "N"         
				//-- Verifica saldo da data.
				nSALDOEST := U_RJFC01SC()
				/* RETIRADA VALIDACAO DE SALDO.
				If nSALDOEST >= oGetPAR:aCols[n][02]
					oGetPAR:aCols[n][03] := "N"
				Else
					oGetPAR:aCols[n][03] := "S"
				EndIf                          
				*/                             
				oGetPAR:aCols[n][03] := "N"
			Else
				oGetPAR:aCols[n][03] := "S"
			EndIf         
		Else
			oGetPAR:aCols[n][03] := "S"
		EndIf

	Else                 
	
		//-- Campo: Valor
		dbSelectArea("Z10")
		dbSetOrder(1)
		dbGoTop()
		//-- Localiza data para verificar se existe saldo.
		If dbSeek ( xFilial("Z10") + dtos(oGetPAR:aCols[n][01]) )  
			//-- Verifica se data bloqueada.
			If Z10->Z10_BLOQ == "N"
				//-- Verifica saldo da data.
				nSALDOEST := U_RJFC01SC()
				/* RETIRADA VALIDACAO DE SALDO.
				If nSALDOEST >= M->Z11_VALOR
					oGetPAR:aCols[n][03] := "N"
				Else
					oGetPAR:aCols[n][03] := "S"
				EndIf                          
				*/                             
				oGetPAR:aCols[n][03] := "N"
			Else
				oGetPAR:aCols[n][03] := "S"
			EndIf         
		Else
			oGetPAR:aCols[n][03] := "S"
		EndIf
	
	EndIf
		
	oGetPAR:aCols[n][04] := .F.

	oGetPAR:Refresh()
	oDlgFLUXO:Refresh()
	

Return (.T.)