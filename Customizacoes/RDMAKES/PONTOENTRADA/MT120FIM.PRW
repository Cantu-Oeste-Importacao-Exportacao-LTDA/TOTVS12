#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT120FIM   บAutor  ณRafael Parma       บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina executada ap๓s a grava็ใo do pedido de compras.      บฑฑ
ฑฑบ          ณInclusใo de tํtulos provis๓rios - CP.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------*
User Function MT120FIM()
*---------------------------*
Local nOpcao := PARAMIXB[1]   // Op็ใo Escolhida pelo usuario 
Local cNumPC := PARAMIXB[2]   // Numero do Pedido de Compras
Local nOpcA  := PARAMIXB[3]   // Indica se a a็ใo foi Cancelada = 0  ou Confirmada = 1.  

Public STRING_NULL := ""  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If nOpcA == 1 // Confirmada 
	   
	    If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S" 
		    If nOpcao == 3 .or. nOpcao == 4 .or. nOpcao == 5
		    	
				MsAguarde( { || U_fUpdZ10(cNumPC, nOpcao ) }, "Atualizando tabela do fluxo de caixa..."  )
				
			EndIf
		EndIf      
 	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณControle de al็adas por famํlia de produtos do compras.                 ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 	
 		If ALLTRIM(SuperGetMV("MV_X_CTRAC",,"N")) == "S"
	 		If nOpcao == 3 .or. nOpcao == 4
	 			MsAguarde( { || fUpdSCR(cNumPC) }, "Atualizando aprovadores por famํlia..."  )	 			
	 		EndIf
	 	EndIf                                                                                 


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAtualiza campos pedido de importa็ใo                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 	
		
		//Gustavo 13/11/14 - Tratado pra em casos de contrato nใo gravar os campos de importa็ใo 
	 	If (nOpcao == 3 .or. nOpcao == 4) .and. ALLTRIM(FunName()) != "GESCTRL"  
	 		fProcIS(cNumPC)
	 	EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEnvio de workflow para aprovacao.                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 	

	 	dbSelectArea("SC7")
	 	dbSetOrder(1)
	 	dbSeek(xFilial("SC7")+cNumPC)	 	
	 	EXECBLOCK("CTMAT01",.F.,.F.)
	 	
	 	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณChama fun็ใo para monitor uso de fontes customizadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		U_USORWMAKE(ProcName(),FunName())	 	
	 	
 	EndIf
 	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdZ10    บAutor  ณRafael Parma       บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para gravar valor do pedido de compras na tabela de  บฑฑ
ฑฑบ          ณfluxo de caixa do compras.                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------------*
User Function fUpdZ10(cNumPC, nOpcao)
*--------------------------------------*
Local aArea    := GetArea()
Local aRECNDEL := {}
Local nVALDESP := 0
Local nVALSEGU := 0
Local nVALFRET := 0
Local nVALTPED := 0
Local nVALTOLD := 0 
Local nVALTFIE := 0

                                                       

Local cCODNATP := ALLTRIM(GETMV("MV_X_NTTPR")) 

Local cPREFIXP := ALLTRIM(GETMV("MV_X_PRTPR"))
Local cCODTIPP := "PR" 
Local aCLVLPRV := {}
Local cCONDPGT := STRING_NULL
Local cCODFORN := STRING_NULL
Local cLOJFORN := STRING_NULL
Local cEMLFORN := STRING_NULL
Local cNOMFORN := STRING_NULL
Local cCOMPRAD := STRING_NULL
Local cFILCOMP := "ZZ"
Local lBloqueado := .F.
Local dPDATPRF := ddatabase
Private lMsErroAuto := .F.
  
Private aDADOSWF := {}
Private aPARCELA := {}

Private aTitulo	 := {} // array auxiliar inclusao contas a pagar
Private aAuxEv	 := {} // array auxiliar do rateio multinaturezas
Private aRatEvEz := {} // array do rateio multinaturezas
Private aAuxEz   := {} // array auxiliar de multiplos centros de custo
Private aRatEz   := {} // array do rateio de centro de custo em multiplas naturezas	 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())						


	Begin Transaction
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณCaso de Altera็ใo/Exclusใo do pedido, deduz valor do fluxo de caixa nas datas de vencimento do pedido  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		If nOpcao == 4 .or. nOpcao == 5	// Altera็ใo/Exclusใo
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("Z11") + cNumPC )
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + cNumPC					
					aAdd (aRECNDEL, Z11->(RecNO()) )
					dbSelectArea("Z10")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("Z10") + dtos(Z11->Z11_VENCTO) )
						If RecLock("Z10",.F.)
							Z10->Z10_VLRPDC -= Z11->Z11_VALOR
							Z10->(MsUnLock())
						EndIf
					EndIf 
					// Atualiza saldo do fluxo compartilhado
					If dbSeek ( cFILCOMP + dtos(Z11->Z11_VENCTO) )
						If RecLock("Z10",.F.)
							Z10->Z10_VLRPDC -= Z11->Z11_VALOR
							Z10->(MsUnLock())
						EndIf
					EndIf			   
								    
					lMsErroAuto := .F. 
					cNUMTITULO := Z11->Z11_PEDIDO + Space(TAMSX3("E2_NUM")[1]-TAMSX3("Z11_PEDIDO")[1])
					aTitulo := {	{"E2_FILIAL"	, Z11->Z11_FILIAL		,	Nil},;      
									{"E2_PREFIXO"	, Z11->Z11_PREFIX		,	Nil},;      
					  				{"E2_NUM"		, cNUMTITULO			,	Nil},;      
									{"E2_PARCELA"	, Z11->Z11_PARCEL		,	Nil},;      
									{"E2_TIPO"		, Z11->Z11_TIPO    		,	Nil},;      
									{"E2_FORNECE"	, Z11->Z11_FORNEC		,	Nil},;      
									{"E2_LOJA"		, Z11->Z11_LOJA  		,	Nil},;
									{"E2_VALOR"		, Z11->Z11_VALOR  		,	Nil} }      
				
					MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
						Exit
					EndIf				
					
					Z11->(dbSkip())					
				Enddo
			EndIf

			// Elimina registros referente as parcelas do pedido		
			If Len(aRECNDEL) > 0
				For nI := 1 to Len(aRECNDEL)
					dbSelectArea("Z11")
					dbGoTop()				
					dbGoTo(aRECNDEL[nI])
					If !Z11->(EOF()) .and. RecLock("Z11",.F.)
						Z11->(dbDelete())
						Z11->(MsUnLock())
					EndIf				
				Next nI
			EndIf			

		
		EndIf          
		
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณRecupera dados do pedido incluido/alterado.                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		If nOpcao == 3 .or. nOpcao == 4	// Inclusใo/Altera็ใo
		
			dbSelectArea("SC7")
			dbSetOrder(1)
			If dbSeek( xFilial("SC7") + cNumPC )
			    
			    lSup := .F.
			    If ! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645" .AND. ! "RJFINP01" $ FUNNAME()	 
				    If Type("__cUSRSUP") == "C"
				    	If __cUSRSUP != STRING_NULL
				    		lSup := .T.
				    	EndIf
				    EndIf
				EndIf
				
				cCOMPRAD := SC7->C7_USER
			    
			    
			    
			    While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC
					If SC7->C7_CONAPRO == "B"
						lBloqueado := .T.
					EndIf

					If SC7->C7_FLUXO == "S"  .OR. ALLTRIM(FUNNAME()) == "CNTA120" //--Medicao de contrato
					
						nVALDESP += SC7->C7_DESPESA
						nVALSEGU += SC7->C7_SEGURO
						nVALFRET += SC7->C7_VALFRE
						nVALTPED += SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE
						dPDATPRF := SC7->C7_DATPRF
						cCONDPGT := SC7->C7_COND
						cCODFORN := SC7->C7_FORNECE
						cLOJFORN := SC7->C7_LOJA
						//Atualiza campo com o supervidor que autorizou o pedido
						If lSup
							If RecLock("SC7",.F.)
								SC7->C7_X_SUPAUT := __cUSRSUP
								SC7->(MsUnLock())
							EndIf
						EndIf
						
						//--Tratamento de segmento/centro custo do tํtulo provis๓rio...
						nPOSCLVL := 0
						nTOTITEM := SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE
						
						If SC7->C7_RATEIO != "1"
							If Len(aCLVLPRV) != 0
								nPOSCLVL := aScan (aCLVLPRV, {|x| x[1] == SC7->C7_CLVL .and. x[2] == SC7->C7_CC })
							EndIf
							If nPOSCLVL == 0
								aAdd (aCLVLPRV, { SC7->C7_CLVL, SC7->C7_CC, nTOTITEM } )
							Else
								aCLVLPRV[nPOSCLVL,03] += nTOTITEM
							EndIf
						Else
							//--Tratamento sobre rateio contแbil do item do PC
							dbSelectArea("SCH")
							dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
							dbSeek(SC7->(C7_FILIAL+C7_NUM+C7_ITEM))
							While !SCH->(EOF()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD) == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
								nVALRAT := Round((nTOTITEM*SCH->CH_PERC)/100,2)
								If Len(aCLVLPRV) != 0
									nPOSCLVL := aScan (aCLVLPRV, {|x| x[1] == SCH->CH_CLVL .and. x[2] == SCH->CH_CC })
								EndIf
								If nPOSCLVL == 0
									aAdd (aCLVLPRV, { SCH->CH_CLVL, SCH->CH_CC, nVALRAT } )
								Else
									aCLVLPRV[nPOSCLVL,03] += nVALRAT
								EndIf
								SCH->(dbSkip())
							Enddo
						EndIf
						
						aAdd ( aDADOSWF, {cNumPC, SC7->C7_EMISSAO, SC7->C7_COND, SC7->C7_ITEM, ALLTRIM(SC7->C7_PRODUTO)+"/"+SC7->C7_DESCRI, SC7->C7_QUANT, SC7->C7_PRECO, SC7->C7_TOTAL, SC7->C7_VALIPI, SC7->C7_DATPRF } )
					
					EndIf
						
					SC7->(dbSkip())	    
			    Enddo        

				//-- Verifica se existe tํtulo PA relacionado ao pedido.
				dbSelectArea("FIE")
				dbSetOrder(1)
				If dbSeek ( xFilial("FIE") + "P" + cNumPC )
					While ! FIE->(EOF()) .and. FIE->(FIE_FILIAL+FIE_CART+FIE_PEDIDO) == xFilial("FIE") + "P" + cNumPC
						nVALTFIE += FIE->FIE_VALOR
						FIE->(dbSkip())
					Enddo		
				EndIf
				
				nVALTPED := Round(nVALTPED - nVALTFIE,2)
				
				
		
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณRecupera vencimentos/valores da condi็ใo de pagamento                   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
				If ! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645" .AND. ! "RJFINP01" $ FUNNAME()	 
					aPARCELA := __aPARCPED
					__aPARCPED := {}				
					__cNUMPEDC := Space(06)
					__cFILPEDC := Space(02)
					__cCPGPEDC := Space(03)                        					
					__nVALPEDC := 0  
					
				Else
					aPARCELA := Condicao(nVALTPED,cCONDPGT,,dPDATPRF)				   
					
				EndIf                     
                                                  

				If Len(aPARCELA) > 0
					
					For nI := 1 to Len(aPARCELA)
						
						If ! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645" .AND. ! "RJFINP01" $ FUNNAME()
							lPARC := !aPARCELA[nI][Len(aPARCELA[nI])]
						Else
							lPARC := .T.
						EndIf

						If lPARC					
					
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณAtualiza tabela de fluxo de caixa                                       ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  
							dbSelectArea("Z10")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( xFilial("Z10") + dtos(aPARCELA[nI][01]) )
								If RecLock("Z10",.F.)
									Z10->Z10_VLRPDC += aPARCELA[nI][02]
									Z10->(MsUnLock())								
								EndIf
							EndIf
	                        // Atualiza saldo do fluxo compartilhado      
							If dbSeek ( cFILCOMP + dtos(aPARCELA[nI][01]) )
								If RecLock("Z10",.F.)
									Z10->Z10_VLRPDC += aPARCELA[nI][02]
									Z10->(MsUnLock())								
								EndIf
							EndIf
							
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณAdiciona registros dos tํtulos provis๓rios relacionados ao pedido           ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ 
							dbSelectArea("Z11")
							If RecLock("Z11",.T.)
								Z11->Z11_FILIAL := xFilial("Z11")
								Z11->Z11_PEDIDO := cNumPC
								Z11->Z11_VENCTO := aPARCELA[nI][01]
								Z11->Z11_VALOR  := aPARCELA[nI][02]
								Z11->Z11_PREFIX := cPREFIXP
								Z11->Z11_PARCEL := STRZero(nI,TAMSX3("E2_PARCELA")[1])
								Z11->Z11_TIPO   := cCODTIPP
								Z11->Z11_FORNEC := cCODFORN
								Z11->Z11_LOJA   := cLOJFORN
								Z11->Z11_DATPRC := ddatabase
								Z11->(MsUnLock())
							EndIf 
	
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณInclui tํtulo provis๓rio                                                    ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ	

							lMsErroAuto := .F.
							aTitulo	 := {} // array auxiliar inclusao contas a pagar
							aAuxEv	 := {} // array auxiliar do rateio multinaturezas
							aRatEvEz := {} // array do rateio multinaturezas
							aAuxEz   := {} // array auxiliar de multiplos centros de custo
							aRatEz   := {} // array do rateio de centro de custo em multiplas naturezas							
							
							aAdd (aTitulo, {"E2_FILIAL"		, xFilial("SE2")		 				,	Nil} )
							aAdd (aTitulo, {"E2_PREFIXO"	, cPREFIXP		 						,	Nil} )      
							aAdd (aTitulo, {"E2_NUM"		, cNumPC			 					,	Nil} )      
							aAdd (aTitulo, {"E2_PARCELA"	, STRZero(nI,TAMSX3("E2_PARCELA")[1])	,	Nil} )      
							aAdd (aTitulo, {"E2_TIPO"		, cCODTIPP				 				,	Nil} )      
							aAdd (aTitulo, {"E2_NATUREZ"	, cCODNATP								,	Nil} )  					
							aAdd (aTitulo, {"E2_FORNECE"	, cCODFORN		        				,	Nil} )      
							aAdd (aTitulo, {"E2_LOJA"		, cLOJFORN			  					,	Nil} )          
							aAdd (aTitulo, {"E2_EMISSAO"	, dDataBase			 					,  	Nil} )
							aAdd (aTitulo, {"E2_VENCTO"		, aPARCELA[nI][01]						,	Nil} )
							aAdd (aTitulo, {"E2_VENCREA"	, DataValida(aPARCELA[nI][01])			,	Nil} )
							aAdd (aTitulo, {"E2_VALOR"		, aPARCELA[nI][02]	  					,	Nil} )
						
							
							If Len(aCLVLPRV) == 1
							
								aAdd (aTitulo, {"E2_MULTNAT"	, "2"				  				,	Nil} )
								aAdd (aTitulo, {"E2_CLVLDB"		, aCLVLPRV[01,01]	  				,	Nil} )
								aAdd (aTitulo, {"E2_CCD"		, aCLVLPRV[01,02]	  				,	Nil} )
							
							
							ElseIf Len(aCLVLPRV) > 0
							
								aAdd (aTitulo, {"E2_MULTNAT"	, "1"				  				,	Nil} )

								//--Adicionando o vetor da natureza
								aadd( aAuxEv ,{"EV_NATUREZ"	, cCODNATP								,	Nil} )//natureza a ser rateada
								aadd( aAuxEv ,{"EV_VALOR"	, aPARCELA[nI][02]						,	Nil} )//valor do rateio na natureza
								aadd( aAuxEv ,{"EV_PERC"	, 100									,	Nil} )//percentual do rateio na natureza
								aadd( aAuxEv ,{"EV_RATEICC" , "1"									,	Nil} )//indicando que hแ rateio por centro de custo

								//Adicionando multiplos centros de custo
								nTOTRAT := 0
								For nCLVL := 1 to Len(aCLVLPRV)
									
									//Tratamento de arredondamento de valor
									nVALRAT := Round((aCLVLPRV[nCLVL,03]/Len(aPARCELA)),2)
									nTOTRAT += nVALRAT
									If nCLVL == Len(aCLVLPRV)
										If nTOTRAT != aPARCELA[nI][02]
											If nTOTRAT > aPARCELA[nI][02]
												nDIF := Round(nTOTRAT-aPARCELA[nI][02],2)
												nVALRAT -= nDIF
											Else
												nDIF := Round(aPARCELA[nI][02]-nTOTRAT,2)
												nVALRAT += nDIF
											EndIf
										EndIf
									EndIf
									
									aAuxEz:={}								                    
									aadd( aAuxEz ,{"EZ_CCUSTO" , aCLVLPRV[nCLVL,02]					, Nil })//centro de custo da natureza
									aadd( aAuxEz ,{"EZ_VALOR"  , nVALRAT							, Nil })//valor do rateio neste centro de custo
									aadd( aAuxEz ,{"EZ_ITEMCTA", ''									, Nil })//valor do rateio neste item
									aadd( aAuxEz ,{"EZ_CLVL"   , aCLVLPRV[nCLVL,01]					, Nil })//valor do rateio neste segmento
									aadd( aAuxEz ,{"INDEX"     , 2									, Nil })
									aadd(aRatEz,aAuxEz)							
								Next nCLVL
								
								aadd(aAuxEv,{"AUTRATEICC" 	, aRatEz   								,	Nil })//recebendo dentro do array da natureza os multiplos centros de custo
								aAdd(aRatEvEz,	aAuxEv)	//adicionando a natureza ao rateio de multiplas naturezas
								
								aAdd(aTitulo,{"AUTRATEEV"	,ARatEvEz  								, 	Nil })//adicionando ao vetor aCab o vetor do rateio
							
							EndIf
							aTitulo := FWVetByDic( aTitulo, 'SE2' )
							
							nOldMod := nModulo
							nModulo := 6
							MsExecAuto({ |x,y,z| FINA050(x,y,z)},aTitulo,,3)
							nModulo := nOldMod

							If lMsErroAuto
								DisarmTransaction()
								Mostraerro()
								Exit							
							EndIf 						
											
						EndIf
					Next nI    
					
				EndIf
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณFuncao de workflow ao fornecedor                                        ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  				
				
				If Len(aDADOSWF) > 0 .and. Len(aPARCELA) > 0
					dbSelectArea("SA2")
					dbSetOrder(1)
					If dbSeek( xFilial("SA2") + cCODFORN + cLOJFORN )
						If !Empty(SA2->A2_EMAIL)
							cEMLFORN := SA2->A2_EMAIL
							cNOMFORN := SA2->A2_NOME
						EndIf
					EndIf 
					
					If cEMLFORN == STRING_NULL
						If ALLTRIM(FUNNAME()) != "RJFINP01" 
							Aviso("Aviso", "Nใo serแ enviada c๓pia do pedido ao fornecedor pois o e-mail nใo estแ informado no cadastro!", {"OK"}, 2)
						EndIf
					EndIf
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSe pedido nใo bloqueado envia workflow                                  ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  								
				    /*@aqui
					If ! lBloqueado							
						U_RJ120WFPC( cNOMFORN, cEMLFORN, aDADOSWF, aPARCELA, nVALTPED, nVALDESP, nVALSEGU, nVALFRET, cCOMPRAD )
					EndIf
				    */
				EndIf
					  			
			EndIf	            
		EndIf
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณEnvia workflow ao responsแvel quando pedido alterado.                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  		
		If nOpcao == 4 // Altera็ใo
			fSendWFRES(cNumPC)		
		EndIf
	
	End Transaction
		
	RestArea(aArea)	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJ120WFPC  บAutor  ณRafael Parma       บ Data ณ  08/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para enviar workflow pedido de compras.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------------------------------------------------------------------------------------------*
User Function RJ120WFPC( cNOMFOR, cEMLFORN, aWFDADOS, aPARCELA, nVALTPED, nVALDESP, nVALSEGU, nVALFRET, cCOMPRAD )
*-------------------------------------------------------------------------------------------------------------------*
Local oProcess
Local STRING_NULL := ""
Local cEMAILCC := STRING_NULL
Local cEMAILCP := STRING_NULL
Local aArea    := GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
    
  CNUMPCOM := aWFDADOS[01][01] 
  DATEMISS := aWFDADOS[01][02]
  CCONDPGT := aWFDADOS[01][03]
    
	conout("WF - WFPEDCOM - INICIO DO ENVIO DE EMAIL - PEDIDO DE COMPRAS ")
	
	// Busca o email da configuracao
	cEMAILCC  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFPEDCOM", "ZWF_EMAIL"))

	oProcess := TWFProcess():New( "WFPEDCOM", "PEDIDO DE COMPRAS")
	oProcess:NewTask( "WFPEDCOM", "\workflow\wfpedcom.html")
	
	oProcess:cSubject :=  "WF - PEDIDO DE COMPRAS" 

	oHTML := oProcess:oHTML

	PswOrder(1)
	If PswSeek(cCOMPRAD)				
	    cCOMPRAD := PswRet()[1][2]
	    cEMAILCP := PswRet()[1][14]
	EndIf

	oHtml:ValByName("CFORNECE", cNOMFOR		)	
	oHtml:ValByName("CNUMPCOM", CNUMPCOM	)
	oHtml:ValByName("DATEMISS", dtoc(DATEMISS)	)
	oHtml:ValByName("CUSUARIO", ALLTRIM(UPPER(cCOMPRAD))	)
	oHtml:ValByName("CCONDPGT", ALLTRIM(Posicione("SE4",1,xFilial("SE4")+CCONDPGT,"E4_DESCRI"))	)

	oHtml:ValByName("NVALTPED", Transform(nVALTPED, "@E 999,999,999.99"))
	oHtml:ValByName("NVALDESP", Transform(nVALDESP, "@E 999,999,999.99"))
	oHtml:ValByName("NVALSEGU", Transform(nVALSEGU, "@E 999,999,999.99"))
	oHtml:ValByName("NVALFRET", Transform(nVALFRET, "@E 999,999,999.99"))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processa itens do array                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	For nI := 1 to Len(aWFDADOS)	
	  	AAdd((oHtml:ValByName("IT.ITEM" ))	, aWFDADOS[nI][04]   		)     
	 	AAdd((oHtml:ValByName("IT.PROD" ))	, aWFDADOS[nI][05]   		)     
	  	AAdd((oHtml:ValByName("IT.QTDE" ))	, Transform(aWFDADOS[nI][06], "@E 999,999,999.99")	)     
	  	AAdd((oHtml:ValByName("IT.VUNT" ))	, Transform(aWFDADOS[nI][07], "@E 999,999,999.99")	)     	
	  	AAdd((oHtml:ValByName("IT.VTOT" ))	, Transform(aWFDADOS[nI][08], "@E 999,999,999.99")	)     	
	  	AAdd((oHtml:ValByName("IT.VIPI" ))	, Transform(aWFDADOS[nI][09], "@E 999,999,999.99")	)     	
	  	AAdd((oHtml:ValByName("IT.ENTR" ))	, dtoc(aWFDADOS[nI][10])	)     	
	Next NI                         
	
	For nI := 1 to Len(aPARCELA)	
	  	AAdd((oHtml:ValByName("PG.PARC" ))	, StrZERO(nI,02)			)     
	 	AAdd((oHtml:ValByName("PG.VCTO" ))	, dtoc(aPARCELA[nI][01])	)     
	  	AAdd((oHtml:ValByName("PG.VALP" ))	, Transform(aPARCELA[nI][02], "@E 999,999,999.99")	)     
	Next NI                         

	cENDMAIL := STRING_NULL
	If ALLTRIM(cEMAILCP) != STRING_NULL
		cENDMAIL += cEMAILCP + ";"
	EndIf                         
	If ALLTRIM(cEMAILCC) != STRING_NULL
		cENDMAIL += cEMAILCC + ";"
	EndIf                         
	If ALLTRIM(cEMLFORN) != STRING_NULL
		cENDMAIL += cEMLFORN + ";"
	EndIf                         
	
   	oProcess:cTo  := LOWER(cEMAILCP) + ";" + LOWER(cEMAILCC) + ";" + LOWER(cEMLFORN) 
	//oProcess:cTo  := 'helpdesk.ti@grupocantu.com.br'
	ConOut("WF - WFPEDCOM - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - WFPEDCOM - FIM DO ENVIO DE EMAIL - PEDIDO DE COMPRAS ")

	RestArea(aArea)
	

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSendWFRES บAutor  ณRafael Parma       บ Data ณ  01/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para enviar workflow ao responsแvel quando pedido forบฑฑ
ฑฑบ          ณalterado.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------*
Static Function fSendWFRES(cNumPC)
*----------------------------------*
Local oProcess
Local cEndEmail := STRING_NULL
Local aArea     := GetArea()
    
	conout("WF - WFPCAVISO - INICIO DO ENVIO DE EMAIL - ALTERAวรO PEDIDO DE COMPRAS ")
	
	// Busca o email da configuracao
	cEndEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFPCAVISO", "ZWF_EMAIL"))
	
	If ALLTRIM(cEndEmail) == STRING_NULL
		Return
	Endif

	oProcess := TWFProcess():New( "WFPCAVISO", "ALTERAวรO PEDIDO DE COMPRAS")
	oProcess:NewTask( "WFPCAVISO", "\workflow\wfpcaviso.html")
	
	oProcess:cSubject :=  "WF - AVISO ALTERAวรO DO PEDIDO DE COMPRAS" 
							
	oHTML := oProcess:oHTML
	                                        
	oHtml:ValByName("CFILIAL", 	SM0->M0_NOME						) 
	oHtml:ValByName("CNUMPCOM", cNumPC								)
	oHtml:ValByName("DDATABAS", dtoc(ddatabase) + " / " + time()	)
	oHtml:ValByName("CUSUARIO", ALLTRIM(UPPER(CUSERNAME))			)

	oProcess:cTo  := LOWER(cEndEmail) 
	
	ConOut("WF - WFPCAVISO - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - WFPCAVISO - FIM DO ENVIO DE EMAIL - ALTERAวรO PEDIDO DE COMPRAS")

	RestArea(aArea)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdSCR    บAutor  ณRafael Parma       บ Data ณ  15/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para definir aprovador de acordo com relacionamento  บฑฑ
ฑฑบ          ณAprovadores x Famํlia.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------*
Static Function fUpdSCR(cNumPC)
*---------------------------------*
Local aAreaTMP := GetArea()     
Local aCODFAM  := {}
Local aCODAPR  := {}
Local aAPRATU  := {}
Local aAPRPAD  := {}
Local cGRPAPR  := STRING_NULL
Local cCODAPR  := STRING_NULL
Local cTipoPC  := "PC"


	If ALLTRIM(FUNNAME()) == "MATA122"
		cTipoPC := "AE"
	EndIf

     
	/**
		Verifica se o pedido/AE possui aprovadores, caso possua verifica se o mesmo irแ gerar movimento financeiro,
		caso nใo gere movimento financeiro elimina registros de controle de al็adas.
	**/
	           
	lFLUXO := .F.
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("SCR") + cTipoPC + cNumPC )

		//Pedidos de Compra
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbGoTop()
		dbSeek ( xFilial("SC7") + cNumPC )
		While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC		
			//-- Caso nใo seja pedido do gestใo de contratos 
			If Empty(SC7->C7_CONTRA) .AND. ALLTRIM(FUNNAME()) != "CNTA120" .AND. SC7->C7_FLUXO == "S" 
				lFLUXO := .T.
				Exit
			EndIf          			
			SC7->(dbSkip())
		Enddo
		
		If !lFLUXO
		
			//-- elimina os aprovadores e aprova o pedido.
	  		While !SCR->(EOF()) .and. SCR->CR_FILIAL + SCR->CR_TIPO + SubSTR(SCR->CR_NUM,1,TAMSX3("C7_NUM")[1]) == xFilial("SCR") + cTipoPC + cNumPC
		    	If RecLock("SCR",.F.)
		    		SCR->(dbDelete())
		    		SCR->(MsUnLock())
		    	EndIf
		    	dbSelectArea("SCR")
		    	SCR->(dbSkip())
			Enddo 
				
			dbSelectArea("SC7")
			dbSetOrder(1)
			dbGoTop()
			dbSeek ( xFilial("SC7") + cNumPC )			                                                                       
			While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC
				If RecLock("SC7", .F.)
					SC7->C7_APROV := ""
					SC7->C7_CONAPRO := "L"
					SC7->(MsUnLock())
				EndIf
				dbSelectArea("SC7")
				SC7->(dbSkip())
			Enddo
			
			RestArea(aAreaTMP)
			Return    			
			
		EndIf           
	EndIf
	                             	
	RestArea(aAreaTMP)		     
	
     
	//Documentos com Alcada
	dbSelectArea("SCR")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("SCR") + cTipoPC + cNumPC )
	    

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณArmazena todas as famํlias para o grupo de produto                      ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  	
		
		//Pedidos de Compra
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbGoTop()
		dbSeek ( xFilial("SC7") + cNumPC )
		
		//-- Caso seja pedido do gestใo de contratos elimina os aprovadores e aprova o pedido.
		If ! Empty(SC7->C7_CONTRA) .OR. ALLTRIM(FUNNAME()) == "CNTA120"
	  		While !SCR->(EOF()) .and. SCR->CR_FILIAL + SCR->CR_TIPO + SubSTR(SCR->CR_NUM,1,TAMSX3("C7_NUM")[1]) == xFilial("SCR") + cTipoPC + cNumPC
		    	If RecLock("SCR",.F.)
		    		SCR->(dbDelete())
		    		SCR->(MsUnLock())
		    	EndIf
		    	dbSelectArea("SCR")
		    	SCR->(dbSkip())
			Enddo                                                                        
			While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC
				If RecLock("SC7", .F.)
					SC7->C7_APROV := ""
					SC7->C7_CONAPRO := "L"
					SC7->(MsUnLock())
				EndIf
				dbSelectArea("SC7")
				SC7->(dbSkip())
			Enddo
			RestArea(aAreaTMP)    
			Return			
		EndIf
		
		While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC
			// Produtos
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek ( xFilial("SB1") + SC7->C7_PRODUTO )

			// Famํlia x Grupo Produtos (grupo sintetico)
			lSINTETICO := .F.
			dbSelectArea("Z27")
			dbSetOrder(2)	//Z27_FILIAL+Z27_CODGRP+Z27_CODIGO 
			dbGoTop()
			If dbSeek ( xFilial("Z27") + SubSTR(SB1->B1_GRUPO,1,2) )
				While !Z27->(EOF()) .and. Z27->Z27_FILIAL+SubSTR(Z27->Z27_CODGRP,1,2) == xFilial("Z27") + SubSTR(SB1->B1_GRUPO,1,2)
					
					If Len(ALLTRIM(Z27->Z27_CODGRP)) != 2
						Z27->(dbSkip())
						Loop
					EndIf
					
					// Famํlia X Aprovadores
					dbSelectArea("Z29")
					dbSetOrder(2)	//Z29_FILIAL+Z29_CODFAM+Z29_CODAPR
					dbGoTop()
					If !dbSeek ( xFilial("Z29") + Z27->Z27_CODIGO )
						Z27->(dbSkip())
						Loop
					Else
						//Valida็ใo demais regras cadastro de aprovadores x famํlias.
						If !fVLDCONTZ29()
							Z27->(dbSkip())
							Loop
						EndIf
					EndIf						
					
					If Len(aCODFAM) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aCODFAM , {|x| x[1] == Z27->Z27_CODIGO } )
					EndIf
					If nPOS == 0
						aAdd ( aCODFAM, { Z27->Z27_CODIGO, Z27->Z27_CODGRP } )
					EndIf            
					
					lSINTETICO := .T.
					Z27->(dbSkip())
				Enddo
			EndIf

			// Famํlia x Grupo Produtos 
			dbSelectArea("Z27")
			dbSetOrder(2)	//Z27_FILIAL+Z27_CODGRP+Z27_CODIGO 
			dbGoTop()
			If dbSeek ( xFilial("Z27") + SB1->B1_GRUPO )
				While !Z27->(EOF()) .and. Z27->Z27_FILIAL+Z27->Z27_CODGRP == xFilial("Z27") + SB1->B1_GRUPO
					
					// Famํlia X Aprovadores
					dbSelectArea("Z29")
					dbSetOrder(2)	//Z29_FILIAL+Z29_CODFAM+Z29_CODAPR
					dbGoTop()
					If !dbSeek ( xFilial("Z29") + Z27->Z27_CODIGO )
						Z27->(dbSkip())
						Loop
					Else
						//Valida็ใo demais regras cadastro de aprovadores x famํlias.
						If !fVLDCONTZ29()     
							Z27->(dbSkip())
							Loop
						EndIf
					EndIf

					
					If Len(aCODFAM) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aCODFAM , {|x| x[1] == Z27->Z27_CODIGO } )
					EndIf
					If nPOS == 0
						aAdd ( aCODFAM, { Z27->Z27_CODIGO, Z27->Z27_CODGRP } )
					EndIf
					
					lSINTETICO := .T.
					Z27->(dbSkip())
				Enddo
			EndIf
			
			
			// Famํlia x Grupo Produtos (produto)
			dbSelectArea("Z27")
			dbSetOrder(4)	//Z27_FILIAL+Z27_PRODUT+Z27_CODIGO 
			dbGoTop()
			If dbSeek ( xFilial("Z27") + SB1->B1_COD )
				While !Z27->(EOF()) .and. Z27->Z27_FILIAL+Z27->Z27_PRODUT == xFilial("Z27")+SB1->B1_COD
					
					// Famํlia X Aprovadores
					dbSelectArea("Z29")
					dbSetOrder(2)	//Z29_FILIAL+Z29_CODFAM+Z29_CODAPR
					dbGoTop()
					If !dbSeek ( xFilial("Z29") + Z27->Z27_CODIGO )
						Z27->(dbSkip())
						Loop
					Else
						//Valida็ใo demais regras cadastro de aprovadores x famํlias.
						If !fVLDCONTZ29()     
							Z27->(dbSkip())
							Loop
						EndIf
					EndIf

					
					If Len(aCODFAM) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aCODFAM , {|x| x[1] == Z27->Z27_CODIGO } )
					EndIf
					If nPOS == 0
						aAdd ( aCODFAM, { Z27->Z27_CODIGO, Z27->Z27_CODGRP } )
					EndIf
					
					lSINTETICO := .T.
					Z27->(dbSkip())
				Enddo
			EndIf
			
					
			If !lSINTETICO
				aAdd ( aCODFAM, { STRING_NULL, SB1->B1_GRUPO } )
			Endif                   
			
			cGRPAPR := SC7->C7_APROV
			SC7->(dbSkip())			
		Enddo
		

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณArmazena todas os aprovadores do grupo de aprova็ใo                     ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  	

		// Grupo de Aprovadores
		dbSelectArea("SAL")
		dbSetOrder(1)	//AL_FILIAL+AL_COD+AL_ITEM
		dbGoTop()
		If dbSeek( xFilial("SAL") + cGRPAPR )
			aAdd ( aCODAPR, { SCR->CR_APROV, {}, STRING_NULL, SAL->AL_USER } )
			
			// Famํlia X Aprovadores
			dbSelectArea("Z29")
			dbSetOrder(1)	//Z29_FILIAL+Z29_CODAPR+Z29_CODFAM				
			If dbSeek ( xFilial("Z29") + SCR->CR_APROV )
				While !Z29->(EOF()) .and. Z29->Z29_FILIAL + Z29->Z29_CODAPR == xFilial("Z29") + SCR->CR_APROV			
					If fVLDCONTSC7(cNumPC)
						aAdd ( aCODAPR[Len(aCODAPR)][02], { Z29->Z29_CODFAM } )
					EndIf
					Z29->(dbSkip())
				Enddo
			EndIf
			
			While !SAL->(EOF()) .and. SAL->AL_FILIAL + SAL->AL_COD == xFilial("SAL") + cGRPAPR                
				
				If SCR->CR_APROV == SAL->AL_APROV
					aCODAPR[01][03] := SAL->AL_NIVEL
					SAL->(dbSkip())
					Loop
				EndIf
				
				// Aprovadores
				dbSelectArea("SAK")
				dbSetOrder(1)
				If dbSeek( xFilial("SAK") + SAL->AL_APROV )
					If SAK->AK_LIMMAX >= SCR->CR_TOTAL
						If Len(aCODAPR) == 0
							nPOS := 0
						Else                                                     
							nPOS := aScan ( aCODAPR, {|x| x[1] == SAK->AK_COD } )
						EndIf        
						If nPOS == 0
							aAdd ( aCODAPR, { SAK->AK_COD, {}, SAL->AL_NIVEL, SAL->AL_USER } )
							
							// Famํlia X Aprovadores
							dbSelectArea("Z29")
							dbSetOrder(1)	//Z29_FILIAL+Z29_CODAPR+Z29_CODFAM				
							If dbSeek ( xFilial("Z29") + SAK->AK_COD )
								While !Z29->(EOF()) .and. Z29->Z29_FILIAL + Z29->Z29_CODAPR == xFilial("Z29") + SAK->AK_COD			
									If fVLDCONTSC7(cNumPC)     
										aAdd ( aCODAPR[Len(aCODAPR)][02], { Z29->Z29_CODFAM } )
									EndIf
									Z29->(dbSkip())
								Enddo 
							EndIf
																		
						EndIf
					EndIf
				EndIf
				
				SAL->(dbSkip())
			Enddo
		EndIf


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณVerifica possํveis aprovadores                                          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  	
		
		nPOSAPR := 0
		aCODFAM := aSort( aCODFAM,,, {|x,y| x[2] < y[2] } )	
		
		If Len(aCODFAM) > 0 .and. Len(aCODAPR) > 0
			For nI := 1 to Len(aCODAPR)
				nPOS := 0
				cGRP := STRING_NULL
				For nJ := 1 to Len(aCODFAM)
					nPOS := aScan ( aCODAPR[nI][02], {|x| x[1] == aCODFAM[nJ][01] } )
					If nPOS != 0
						Exit
					EndIf
					cGRP := aCODFAM[nJ][02]
				Next nJ

				If nPOS != 0               
					If Len(aCODAPR[nI][02]) > 0
						aAdd ( aAPRATU , { aCODAPR[nI][01], nI } )
					Endif
				EndIf
			Next nI
		EndIf
		
		    
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAltera c๓digo do aprovador                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  	

  		While !SCR->(EOF()) .and. SCR->CR_FILIAL + SCR->CR_TIPO + SubSTR(SCR->CR_NUM,1,TAMSX3("C7_NUM")[1]) == xFilial("SCR") + cTipoPC + cNumPC
	    	aAdd ( aAPRPAD, { SCR->CR_APROV } )
	    	dbSelectArea("SCR")
	    	SCR->(dbSkip())
		Enddo
        
		If Len(aAPRATU) > 0
		
			lExitApr := .F.
			lAponApr := .F.
			For nU := 1 to Len(aAPRATU)
				If aScan ( aAPRPAD, {|x| x[1] == aAPRATU[nU][1] }) != 0
					lExitApr := .T.
				EndIf
			Next nU
		
			dbSelectArea("SCR")
			dbSetOrder(1)
			dbGoTop()                                                                                                                               		
			dbSeek ( xFilial("SCR") + cTipoPC + cNumPC )                                                                                            
			While !SCR->(EOF()) .and. SCR->CR_FILIAL + SCR->CR_TIPO + SubSTR(SCR->CR_NUM,1,TAMSX3("C7_NUM")[1]) == xFilial("SCR") + cTipoPC + cNumPC
			    
				nPOS := aScan( aAPRATU , {|x| x[1] == SCR->CR_APROV })
                
				//--Existe aprovador para a famํlia, por้m nใo ้ o aprovador atual, elimina o aprovador para o pedido.
				If lExitApr .and. nPOS == 0
					If RecLock("SCR",.F.)
						SCR->(dbDelete())						
						SCR->(MsUnLock())					
					EndIf
					

				//--Nใo existe aprovadores para a famํlia, verifica o c๓digo do nํvel, se diferente do nํvel 01 elimina aprovador, caso seja nํvel seta o primeiro aprovador do grupo.
				ElseIf !lExitApr
					If RecLock("SCR",.F.)
						If SCR->CR_NIVEL == "01" .AND. !lAponApr
							SCR->CR_APROV  := aCODAPR[aAPRATU[01][02]][01]							
							SCR->CR_USER   := aCODAPR[aAPRATU[01][02]][04]														
							lAponApr := .T.
						Else
							SCR->(dbDelete())						
						EndIf
						SCR->(MsUnLock())					
					EndIf                                   
					
				//--Existe aprovador para a famํlia e ้ o aprovador atual, verifica o nํvel, caso nใo esteja no nํvel de 01 de aprova็ใo, seta como aprovador primแrio.
				ElseIf nPOS != 0
					If SCR->CR_NIVEL != "01"
						If RecLock("SCR",.F.)
							SCR->CR_NIVEL  := "01"
							SCR->CR_STATUS := "02" 
							SCR->(MsUnLock())					
						EndIf
					EndIf  
					
				EndIf				
		    	
		    	dbSelectArea("SCR")
		    	SCR->(dbSkip())
			
			Enddo   					
		EndIf	
		
	EndIf
	
	RestArea(aAreaTMP)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcIS   บAutor  ณRafael Parma        บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por gravar dados especificos referente a บฑฑ
ฑฑบ          ณintegra็ใo Import SYS.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------*
Static Function fProcIS(cPEDIDO)
*---------------------------------*
Local aAreaTMP := GetArea()

	dbSelectArea("SC7")
	dbSetOrder(1)
	If dbSeek(xFilial("SC7")+cPEDIDO)
		If POSICIONE("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EST") == "EX"
			While !SC7->(EOF()) .and. SC7->(C7_FILIAL+C7_NUM) == xFilial("SC7")+cPEDIDO	
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)				
					dbSelectArea("SBM")
					dbSetOrder(1)
					If dbSeek( xFilial("SBM")+SB1->B1_GRUPO )
						If SBM->BM_X_ESYS == "S"
							If RecLock("SC7",.F.)
								SC7->C7_X_ESYS	:= "S"
								SC7->C7_X_INCOT	:= __cINCOTER	//C๓digo Incoterms
								SC7->C7_X_TOIMP	:= __cORDIMPO 	//Ordem Importa็ใo
								SC7->C7_X_VTRAN	:= __cVIATRAN	//Via Transporte					
								SC7->C7_X_CADQU	:= __cCODADQU	//C๓digo Adquirente
								SC7->C7_X_LADQU	:= __cLOJADQU	//Loja Adquirente 
							EndIf
						EndIf
					EndIf					
				EndIf          				
				
				SC7->(dbSkip())
			Enddo
		EndIf
	EndIf
	
	RestArea(aAreaTMP)
	
Return	 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJM120IS  บAutor  ณRafael Parma        บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela com campos especificos referente a integra็ใo Import บฑฑ
ฑฑบ          ณSYS.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*-----------------------------*
User Function RJM120IS(cCAMPO)         
*-----------------------------*
Local aAreaTMP := GetArea()
Local nOpca := 0
Local lRet  := .T.

Private cCODINC := Space(TAMSX3("YJ_COD")[1])
Private cDESINC := Space(TAMSX3("YJ_DESCR")[1])
Private cTABINC := "SYJ"
Private cCODTOI := Space(TAMSX3("CTH_CLVL")[1])
Private cDESTOI := Space(TAMSX3("CTH_DESC01")[1])
Private cTABTOI := "CTH"
Private cCODVTR := Space(TAMSX3("YQ_VIA")[1])
Private cDESVTR := Space(TAMSX3("YQ_DESCR")[1])
Private cTABVTR := "SYQ"
Private cCODADQ := Space(TAMSX3("A1_COD")[1])
Private cLOJADQ := Space(TAMSX3("A1_LOJA")[1])
Private cNOMADQ := Space(TAMSX3("A1_NOME")[1])
Private cTABADQ := "SA1"   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	If POSICIONE("SA2",1,xFilial("SA2")+cA120Forn+cA120Loj,"A2_EST") == "EX"

		If POSICIONE("SE4",1,xFilial("SE4")+CCONDICAO,"E4_TIPO") != "1"
			Aviso("Aviso","Nใo poderแ ser utilizada condi็ใo de pagamento com tipo diferente de 1 para importa็ใo.",{"OK"})
			Return (.F.)
		EndIf
		
		If CA120NUM == SC7->C7_NUM

			cCODINC := SC7->C7_X_INCOT
			FVLDTAB(cTABINC,cCODINC,,@cDESINC)
			cCODTOI := SC7->C7_X_TOIMP
			FVLDTAB(cTABTOI,cCODTOI,,@cDESTOI)			
			cCODVTR := SC7->C7_X_VTRAN
			FVLDTAB(cTABVTR,cCODVTR,,@cDESVTR)
			cCODADQ := SC7->C7_X_CADQU
			cLOJADQ := SC7->C7_X_LADQU
			FVLDTAB(cTABADQ,cCODADQ,cLOJADQ,@cNOMADQ)

		EndIf
	 
		DEFINE MSDIALOG oDlg FROM 001,001 TO 200,560 TITLE "Pedido de importa็ใo"  OF oMainWnd PIXEL

		@ 010,010 SAY "Incoterms: "  SIZE 50,10 OF oDlg PIXEL 
		@ 010,060 MSGET cCODINC  F3 cTABINC VALID (FVLDTAB(cTABINC,cCODINC,,@cDESINC)) SIZE 050,10 OF oDlg PIXEL
		@ 010,140 MSGET cDESINC  WHEN .F. SIZE 120,10 OF oDlg PIXEL

		@ 025,010 SAY "Ordem Importa็ใo: "  SIZE 50,10 OF oDlg PIXEL 
		@ 025,060 MSGET cCODTOI  F3 cTABTOI VALID (FVLDTAB(cTABTOI,cCODTOI,,@cDESTOI)) SIZE 050,10 OF oDlg PIXEL
		@ 025,140 MSGET cDESTOI  WHEN .F. SIZE 120,10 OF oDlg PIXEL

		@ 040,010 SAY "Via Transporte: "  SIZE 50,10 OF oDlg PIXEL 
		@ 040,060 MSGET cCODVTR  F3 cTABVTR VALID (FVLDTAB(cTABVTR,cCODVTR,,@cDESVTR)) SIZE 050,10 OF oDlg PIXEL
		@ 040,140 MSGET cDESVTR  WHEN .F. SIZE 120,10 OF oDlg PIXEL

		@ 055,010 SAY "Adquirente: "  SIZE 50,10 OF oDlg PIXEL 
		@ 055,060 MSGET cCODADQ  F3 cTABADQ VALID (FVLDTAB(cTABADQ,cCODADQ,cLOJADQ,@cNOMADQ)) SIZE 050,10 OF oDlg PIXEL
		@ 055,110 MSGET cLOJADQ  VALID (FVLDTAB(cTABADQ,cCODADQ,cLOJADQ,@cNOMADQ)) SIZE 025,10 OF oDlg PIXEL
		@ 055,140 MSGET cNOMADQ  WHEN .F. SIZE 120,10 OF oDlg PIXEL
		
		DEFINE SBUTTON FROM 080, 220 TYPE 1 ACTION (nOpca:=1,oDlg:End())ENABLE OF oDlg PIXEL
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		If nOpca == 1
			fVld120IS()	
		EndIf
		
	EndIf            
	
	RestArea(aAreaTMP)
	
	
Return (lRet)
             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJM120IS  บAutor  ณRafael Parma        บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela com campos especificos referente a integra็ใo Import บฑฑ
ฑฑบ          ณSYS.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------------------------------------*
Static Function FVLDTAB(cTABSX5,cCHAVE1,cCHAVE2,cDESC)        
*--------------------------------------------------------*
Local lRet := .T.
                 
	If !Empty(cCHAVE1)
		If cTABSX5 == "SA1"
			cSEEKEY := cCHAVE1
			If !Empty(cCHAVE2)
				cSEEKEY += cCHAVE2
			EndIf
		Else
			cSEEKEY := cCHAVE1
		EndIf
		dbSelectArea(cTABSX5)
		dbSetOrder(1)
		If dbSeek(xFilial(cTABSX5)+cSEEKEY)
			If cTABSX5 == "SA1"
				cDESC := SA1->A1_NOME
			ElseIf cTABSX5 == "SYQ"  
				cDESC := SYQ->YQ_DESCR
			ElseIf cTABSX5 == "SYJ"  
				cDESC := SYJ->YJ_DESCR
			ElseIf cTABSX5 == "CTH"  
				cDESC := CTH->CTH_DESC01
			EndIf			
		Else
			lRet := .F.
		EndIf
	Else
		If cTABSX5 != "SA1"
			lRet := .F.
		EndIf
	EndIf


Return (lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJM120IS  บAutor  ณRafael Parma        บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela com campos especificos referente a integra็ใo Import บฑฑ
ฑฑบ          ณSYS.                                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-----------------------------*
Static Function fVld120IS()        
*-----------------------------*
Local lRet := .T.

	__cINCOTER := cCODINC	//C๓digo Incoterms
	__cORDIMPO := cCODTOI	//Ordem Importa็ใo
	__cVIATRAN := cCODVTR	//Via Transporte
	__cCODADQU := cCODADQ	//C๓digo Adquirente
	__cLOJADQU := cLOJADQ	//Loja Adquirente     
	    
Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUPCTCNT บAutor  ณRafael Parma        บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por atualiza็ใo dos campos contแbeis sobreฑฑ
ฑฑบ          ณitem do pedido com base nos campos do contrato de compras.  บฑฑ
ฑฑบ          ณUtilizado na valida็ใo do usuแrio do campo C7_FORMPAG.      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*-----------------------------*
User Function RJUPCTCNT()         
*-----------------------------*
Local lRet := .T.
Local aAreaTMP := GetArea()
Local nPCCUS   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CC'})
Local nPCLVL   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CLVL'})
Local nPCONT   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_CONTA'})
Local nPITEM   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_ITEMCTA'})
Local nPPROD   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local nPNUMSC  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})  
Local nPITESC  := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName()) 
                   
	//--Pedido de Autoriza็ใo de Entrega
	If nTipoPed == 2 .and. nPPROD > 0 .and. nPNUMSC > 0 .and. nPITESC > 0
		
		//--Contrato de compras
		dbSelectArea("SC3")
		dbSetOrder(3)	//--C3_FILIAL+C3_PRODUTO+C3_NUM+C3_ITEM
		If dbSeek(xFilial("SC3")+aCols[n,nPPROD]+aCols[n,nPNUMSC]+aCols[n,nPITESC])

			If nPCLVL > 0
				aCols[n][nPCLVL] := SC3->C3_X_CLVL
			EndIf
			If nPCONT > 0
				aCols[n][nPCONT] := SC3->C3_X_CONTA
			EndIf
			If nPITEM > 0
				aCols[n][nPITEM] := SC3->C3_X_ITEMC
			EndIf
			If nPCCUS > 0
				aCols[n][nPCCUS] := SC3->C3_CC
			EndIf
			
		EndIf
	EndIf
	
	RestArea(aAreaTMP)

Return (lRet)

             
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVLDCONTZ29  บAutor  ณRafael Parma     บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela valida็ใo de dados contแbeis sobre  บฑฑ
ฑฑบ          ณregras do cadastro de Aprovadores x Famํlias.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*-----------------------------*
Static Function fVLDCONTZ29()     
*-----------------------------*
Local aAreaTMP	:= GetArea()
Local lRet 		:= .T.
Local aRECNOCL	:= {}
Local aRECNOCC	:= {}
Local aRECNODT	:= {}

	If SC7->C7_RATEIO != "1"
		//--Verifica se atente aos demais requisitos (segmento, centro de custo e data de/ate)
		nRECNOAT := Z29->(RECNO())
		dbSelectArea("Z29")
		dbSetOrder(2)
		//--Armazena RECNO dos registros que atentem a regra de segmento.
		While !Z29->(EOF()) .AND. Z29->(Z29_FILIAL+Z29_CODFAM) == xFilial("Z29")+Z27->Z27_CODIGO
			If !Empty(Z29->Z29_CLVL)
				nLENCPO := LEN(ALLTRIM(Z29->Z29_CLVL))
				If nLENCPO != TAMSX3("Z29_CLVL")[1]
					If SUBSTR(SC7->C7_CLVL,1,nLENCPO) == ALLTRIM(Z29->Z29_CLVL)
						aAdd ( aRECNOCL, { Z29->(RECNO()) } )
					EndIf
				Else
					If SC7->C7_CLVL == Z29->Z29_CLVL
						aAdd ( aRECNOCL, { Z29->(RECNO()) } )
					EndIf
				EndIf
			Else
				aAdd ( aRECNOCL, { Z29->(RECNO()) } )
			EndIf
			Z29->(dbSkip())
		Enddo          
	Else
		//--Tratamento sobre rateio contแbil do item do PC
		dbSelectArea("SCH")
		dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
		dbSeek(SC7->(C7_FILIAL+C7_NUM+C7_ITEM))
		While !SCH->(EOF()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD) == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
			//--Verifica se atente aos demais requisitos (segmento, centro de custo e data de/ate)
			nRECNOAT := Z29->(RECNO())
			dbSelectArea("Z29")
			dbSetOrder(2)
			//--Armazena RECNO dos registros que atentem a regra de segmento.
			While !Z29->(EOF()) .AND. Z29->(Z29_FILIAL+Z29_CODFAM) == xFilial("Z29")+Z27->Z27_CODIGO
				If !Empty(Z29->Z29_CLVL)
					nLENCPO := LEN(ALLTRIM(Z29->Z29_CLVL))
					If nLENCPO != TAMSX3("Z29_CLVL")[1]
						If SUBSTR(SCH->CH_CLVL,1,nLENCPO) == ALLTRIM(Z29->Z29_CLVL)
							aAdd ( aRECNOCL, { Z29->(RECNO()) } )
						EndIf
					Else
						If SCH->CH_CLVL == Z29->Z29_CLVL
							aAdd ( aRECNOCL, { Z29->(RECNO()) } )
						EndIf
					EndIf
				Else
					aAdd ( aRECNOCL, { Z29->(RECNO()) } )
				EndIf
				Z29->(dbSkip())
			Enddo          
			SCH->(dbSkip())
		Enddo
	EndIf
	
	                        
	If SC7->C7_RATEIO != "1"
		dbSelectArea("Z29")
		dbSetOrder(2)
		Z29->(dbGoTo(nRECNOAT))
		//--Armazena RECNO dos registros que atentem a regra de centro de custo.
		While !Z29->(EOF()) .AND. Z29->(Z29_FILIAL+Z29_CODFAM) == xFilial("Z29")+Z27->Z27_CODIGO
			If !Empty(Z29->Z29_CC)
				nLENCPO := LEN(ALLTRIM(Z29->Z29_CC))
				If nLENCPO != TAMSX3("Z29_CC")[1]
					If SUBSTR(SC7->C7_CC,1,nLENCPO) == ALLTRIM(Z29->Z29_CC)
						aAdd ( aRECNOCC, { Z29->(RECNO()) } )
					EndIf
				Else
					If SC7->C7_CC == Z29->Z29_CC
						aAdd ( aRECNOCC, { Z29->(RECNO()) } )
					EndIf
				EndIf
			Else
				aAdd ( aRECNOCC, { Z29->(RECNO()) } )
			EndIf
			Z29->(dbSkip())
		Enddo          
	Else
		//--Tratamento sobre rateio contแbil do item do PC
		dbSelectArea("SCH")
		dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
		dbSeek(SC7->(C7_FILIAL+C7_NUM+C7_ITEM))
		While !SCH->(EOF()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD) == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
			dbSelectArea("Z29")
			dbSetOrder(2)
			Z29->(dbGoTo(nRECNOAT))
			//--Armazena RECNO dos registros que atentem a regra de centro de custo.
			While !Z29->(EOF()) .AND. Z29->(Z29_FILIAL+Z29_CODFAM) == xFilial("Z29")+Z27->Z27_CODIGO
				If !Empty(Z29->Z29_CC)
					nLENCPO := LEN(ALLTRIM(Z29->Z29_CC))
					If nLENCPO != TAMSX3("Z29_CC")[1]
						If SUBSTR(SCH->CH_CC,1,nLENCPO) == ALLTRIM(Z29->Z29_CC)
							aAdd ( aRECNOCC, { Z29->(RECNO()) } )
						EndIf
					Else
						If SCH->CH_CC == Z29->Z29_CC
							aAdd ( aRECNOCC, { Z29->(RECNO()) } )
						EndIf
					EndIf
				Else
					aAdd ( aRECNOCC, { Z29->(RECNO()) } )
				EndIf
				Z29->(dbSkip())
			Enddo
			SCH->(dbSkip())
		Enddo
	EndIf

	dbSelectArea("Z29")
	dbSetOrder(2)          
	Z29->(dbGoTo(nRECNOAT))
	//--Armazena RECNO dos registros que atentem a regra de datas.
	While !Z29->(EOF()) .AND. Z29->(Z29_FILIAL+Z29_CODFAM) == xFilial("Z29")+Z27->Z27_CODIGO
		If !Empty(Z29->Z29_VALDE) .OR. !Empty(Z29->Z29_VALATE)
			If !Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO >= Z29->Z29_VALDE .AND. Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			ElseIf Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO <= Z29->Z29_VALATE .AND. !Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			ElseIf !Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO >= Z29->Z29_VALDE .AND. SC7->C7_EMISSAO <= Z29->Z29_VALATE .AND. !Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			EndIf
		Else
			aAdd ( aRECNODT,  { Z29->(RECNO()) } )
		EndIf
		Z29->(dbSkip())
	Enddo          
	
	//--Verifica se atente aos requisitos definidos no cadastro de Aprovadores x Famํlias
	If Len(aRECNOCL) > 0 .AND. Len(aRECNOCC) > 0 .AND. Len(aRECNODT) > 0
		lEXIST := .F.
		For nI := 1 to Len(aRECNOCL)
	   		nPOSCC := aScan( aRECNOCC, {|x| x[1] == aRECNOCL[nI][01] } )
	   		nPOSDT := aScan( aRECNODT, {|x| x[1] == aRECNOCL[nI][01] } )
	   		If nPOSCC != 0 .AND. nPOSDT != 0
	   			lEXIST := .T.
	   			Exit
	   		EndIf
		Next nI
		If !lEXIST
			lRet := .F.						
		EndIf
	Else
		lRet := .F.
	EndIf
	
	RestArea(aAreaTMP)

Return (lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfVLDCONTSC7  บAutor  ณRafael Parma     บ Data ณ  12/09/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela valida็ใo de dados contแbeis sobre  บฑฑ
ฑฑบ          ณregras do cadastro de Aprovadores x Famํlias.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*-------------------------------------*
Static Function fVLDCONTSC7(cNUMPED)     
*-------------------------------------*
Local aAreaTMP	:= GetArea()
Local lRet		:= .T.
Local aRECNOCL	:= {}
Local aRECNOCC	:= {}
Local aRECNODT	:= {}

	//--Verifica se atente aos demais requisitos (segmento, centro de custo e data de/ate)
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbGoTop()
	dbSeek ( xFilial("SC7") + cNUMPED )
	//--Armazena RECNO dos registros que atentem a regra de segmento.
	While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNUMPED
		If !Empty(Z29->Z29_CLVL)
			If SC7->C7_RATEIO != "1"	
				nLENCPO := LEN(ALLTRIM(Z29->Z29_CLVL))
				If nLENCPO != TAMSX3("Z29_CLVL")[1]
					If SUBSTR(SC7->C7_CLVL,1,nLENCPO) == ALLTRIM(Z29->Z29_CLVL)
						aAdd ( aRECNOCL, { Z29->(RECNO()) } )
					EndIf
				Else
					If SC7->C7_CLVL == Z29->Z29_CLVL
						aAdd ( aRECNOCL, { Z29->(RECNO()) } )
					EndIf
				EndIf
			Else
				dbSelectArea("SCH")
				dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
				dbSeek(SC7->(C7_FILIAL+C7_NUM+C7_ITEM))
				While !SCH->(EOF()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD) == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
					nLENCPO := LEN(ALLTRIM(Z29->Z29_CLVL))
					If nLENCPO != TAMSX3("Z29_CLVL")[1]
						If SUBSTR(SCH->CH_CLVL,1,nLENCPO) == ALLTRIM(Z29->Z29_CLVL)
							aAdd ( aRECNOCL, { Z29->(RECNO()) } )
						EndIf
					Else
						If SCH->CH_CLVL == Z29->Z29_CLVL
							aAdd ( aRECNOCL, { Z29->(RECNO()) } )
						EndIf
					EndIf
					SCH->(dbSkip())
				Enddo
			EndIf			
		Else
			aAdd ( aRECNOCL, { Z29->(RECNO()) } )
		EndIf
		SC7->(dbSkip())
	Enddo          
	
	dbSelectArea("SC7")
	dbSetOrder(1)
	dbGoTop()
	dbSeek ( xFilial("SC7") + cNUMPED )
	//--Armazena RECNO dos registros que atentem a regra de centro de custo.
	While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNUMPED
		If !Empty(Z29->Z29_CC)
			If SC7->C7_RATEIO != "1"	
				nLENCPO := LEN(ALLTRIM(Z29->Z29_CC))
				If nLENCPO != TAMSX3("Z29_CC")[1]
					If SUBSTR(SC7->C7_CC,1,nLENCPO) == ALLTRIM(Z29->Z29_CC)
						aAdd ( aRECNOCC, { Z29->(RECNO()) } )
					EndIf
				Else
					If SC7->C7_CC == Z29->Z29_CC
						aAdd ( aRECNOCC, { Z29->(RECNO()) } )
					EndIf
				EndIf
			Else
				dbSelectArea("SCH")
				dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD+CH_ITEM
				dbSeek(SC7->(C7_FILIAL+C7_NUM+C7_ITEM))
				While !SCH->(EOF()) .and. SCH->(CH_FILIAL+CH_PEDIDO+CH_ITEMPD) == SC7->(C7_FILIAL+C7_NUM+C7_ITEM)
					nLENCPO := LEN(ALLTRIM(Z29->Z29_CC))
					If nLENCPO != TAMSX3("Z29_CC")[1]
						If SUBSTR(SCH->CH_CC,1,nLENCPO) == ALLTRIM(Z29->Z29_CC)
							aAdd ( aRECNOCC, { Z29->(RECNO()) } )
						EndIf
					Else
						If SCH->CH_CC == Z29->Z29_CC
							aAdd ( aRECNOCC, { Z29->(RECNO()) } )
						EndIf
					EndIf
					SCH->(dbSkip())
				Enddo
			EndIf
		Else
			aAdd ( aRECNOCC, { Z29->(RECNO()) } )
		EndIf
		SC7->(dbSkip())
	Enddo          

	dbSelectArea("SC7")
	dbSetOrder(1)
	dbGoTop()
	dbSeek ( xFilial("SC7") + cNUMPED )
	//--Armazena RECNO dos registros que atentem a regra de datas.
	While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNUMPED
		If !Empty(Z29->Z29_VALDE) .OR. !Empty(Z29->Z29_VALATE)
			If !Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO >= Z29->Z29_VALDE .AND. Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			ElseIf Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO <= Z29->Z29_VALATE .AND. !Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			ElseIf !Empty(Z29->Z29_VALDE) .AND. SC7->C7_EMISSAO >= Z29->Z29_VALDE .AND. SC7->C7_EMISSAO <= Z29->Z29_VALATE .AND. !Empty(Z29->Z29_VALATE)
				aAdd ( aRECNODT,  { Z29->(RECNO()) } )
			EndIf
		Else
			aAdd ( aRECNODT,  { Z29->(RECNO()) } )
		EndIf
		SC7->(dbSkip())
	Enddo          
	
	//--Verifica se atente aos requisitos definidos no cadastro de Aprovadores x Famํlias
	If Len(aRECNOCL) > 0 .AND. Len(aRECNOCC) > 0 .AND. Len(aRECNODT) > 0
		lEXIST := .F.
		For nI := 1 to Len(aRECNOCL)
	   		nPOSCC := aScan( aRECNOCC, {|x| x[1] == aRECNOCL[nI][01] } )
	   		nPOSDT := aScan( aRECNODT, {|x| x[1] == aRECNOCL[nI][01] } )
	   		If nPOSCC != 0 .AND. nPOSDT != 0
	   			lEXIST := .T.
	   			Exit
	   		EndIf
		Next nI
		If !lEXIST
			lRet := .F.						
		EndIf
	Else
		lRet := .F.
	EndIf
	
	RestArea(aAreaTMP)
	
Return (lRet)
