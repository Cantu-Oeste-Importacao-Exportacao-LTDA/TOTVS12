#include "TOTVS.CH"
#include "TOPCONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM141GRV    ºAutor  ³Rafael Parma      º Data ³  13/01/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada, localizado no TMSA141 (Geração de Viagens º±±
±±º          ³Coleta / Entrega), é executado após Incluir/Alterar/Excluir º±±
±±º          ³uma determinada viagem de Coleta/Entrega.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function TM141GRV()
*----------------------------*
Local aArea   := GetArea()
Local nOpcx   := PARAMIXB[1]
Local lUpdate := .F.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
    
	If nOpcx == 3 .OR. nOpcx == 4
		
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
								SE1->E1_CLVLCR := DA3->DA3_X_SEGM
								SE1->E1_CCC	   := DA3->DA3_X_CC
								SE1->E1_ITEMC  := DA3->DA3_X_ITEM
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
								SD2->D2_CLVL   := DA3->DA3_X_SEGM
								SD2->D2_CCUSTO := DA3->DA3_X_CC								
								SD2->D2_ITEMCC := DA3->DA3_X_ITEM
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
							DT6->DT6_X_SEGM	:= DA3->DA3_X_SEGM
							DT6->DT6_X_CC	:= DA3->DA3_X_CC
							DT6->DT6_X_ITEM := DA3->DA3_X_ITEM
							DT6->(MsUnLock())                 							
						EndIf
					EndIf  
					
				    //-- Atualiza registros de comissões.
					dbSelectArea("SE3")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek( xFilial("SE3") + DUD->DUD_SERIE + DUD->DUD_DOC )
						While !SE3->(EOF()) .and. SE3->E3_FILIAL + SE3->E3_PREFIXO + SE3->E3_NUM == xFilial("SE3") + DUD->DUD_SERIE + DUD->DUD_DOC
							If RecLock("SE3",.F.)
								SE3->E3_CCD    := DA3->DA3_X_CC
								SE3->E3_CLVLDB := DA3->DA3_X_SEGM
								SE3->(MsUnLock())
							EndIf
							SE3->(dbSkip())
						Enddo
					EndIf					
					
					DUD->(dbSkip())
				Enddo
			EndIf
		EndIf
	    
		//-- Envio de workflow com ficha cadastral do motorista/veículo. --//		
		If ALLTRIM(SuperGetMV("MV_X_ATWFC",,"N")) == "S"
			fSendWF()
		EndIf
		
	EndIf
	
	RestArea(aArea)
	
Return                                                                       


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSendWF     ºAutor  ³Rafael Parma      º Data ³  18/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Workflow para envio de e-mail ao solicitante com os dados doº±±
±±º          ³veículo/motorista.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------*
Static Function fSendWF()
*-------------------------------*
Local oProcess
Local lSendWF  := .F.
Local cEmail   := ""
Local cEmailCC := ""
Local cCONTATO := ALLTRIM(SuperGetMV("MV_X_CNWFC",,"N"))
Local aArea    := GetArea()
    
	conout("WF - TM141GRV - INICIO DO ENVIO DE EMAIL - COTACAO DE FRETE ")
	
	// Busca o email da configuracao
	cEmailCC  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "TM141GRV", "ZWF_EMAIL"))
	
	
	dbSelectArea("DTR") // Veiculos da viagem
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("DTR") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
		
		dbSelectArea("DA3")	// Veiculos
		dbSetOrder(1)
		dbGoTop()
		dbSeek ( xFilial("DA3") + DTR->DTR_CODVEI )
  

		dbSelectArea("DUP")	// Motoristas da Viagem          
		dbSetOrder(1)
		dbGoTop()			
		If dbSeek ( xFilial("DUP") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
				
			dbSelectArea("DA4")
			dbSetOrder(1)
			dbSeek( xFilial("DA4") + DUP->DUP_CODMOT )
			
		
		EndIf
		
		dbSelectArea("DTP")	// Lote de Entrada Notas Fiscais 
		dbSetOrder(3)
		dbGoTop()			
		If dbSeek ( xFilial("DTP") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
			
			dbSelectArea("DT6")	// Documentos de Transporte      
			dbSetOrder(2)
			dbGoTop()
			If dbSeek ( xFilial("DT6") + DTP->DTP_FILORI + DTP->DTP_LOTNFC )
			
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbGoTop()
				dbSeek ( xFilial("SA1") + DT6->DT6_CLIREM + DT6->DT6_LOJREM )
				If Empty(SA1->A1_EMAIL)
					MsgAlert("E-mail do remetente não preenchido, não será enviado workflow.")
				Else
					cEmail  := SA1->A1_EMAIL
				EndIf
				
				lSendWF := .T.
				
				dbSelectArea("DTC")	//Doc Cliente para Transporte   
				dbSetOrder(1)	//DTC_FILIAL+DTC_FILORI+DTC_LOTNFC+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC+DTC_NUMSOL
				dbGoTop()
				dbSeek( xFilial("DTC") + DTP->DTP_FILORI + DTP->DTP_LOTNFC )
								
			EndIf             
		EndIf
	EndIf
			          
	
	If lSendWF 
		
		oProcess := TWFProcess():New( "TM141GRV", "DADOS VEICULO/CARRETA/MOTORISTA")
		oProcess:NewTask( "TM141GRV", "\workflow\WFFICVM.HTML")
		
		oProcess:cSubject :=  "WF - DADOS VEICULO/CARRETA/MOTORISTA" 
								
		oHTML := oProcess:oHTML
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DA EMPRESA		                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SM0")
		
		oHtml:ValByName("CRAZAOSOC1", UPPER(ALLTRIM(SM0->M0_NOMECOM)) 	)  		
		oHtml:ValByName("CCPFCNPJ1"	, TRANSFORM( SM0->M0_CGC, "@R 99.999.999/9999-99" )	)
		oHtml:ValByName("CRGIE1"	, SM0->M0_INSC	)
		oHtml:ValByName("CMUNICIP1"	, UPPER(ALLTRIM(SM0->M0_CIDCOB)) 	)
		oHtml:ValByName("CBAIRRO1"	, UPPER(ALLTRIM(SM0->M0_BAIRCOB)) 	)
		oHtml:ValByName("CENDERECO1", UPPER(ALLTRIM(SM0->M0_ENDCOB)) 	)
		oHtml:ValByName("CCEP1" 	, ALLTRIM(SM0->M0_CEPCOB) 	)
		oHtml:ValByName("CNUMTEL1"	, SubSTR(ALLTRIM(SM0->M0_TEL),2,Len(ALLTRIM(SM0->M0_TEL)))	)
		oHtml:ValByName("CNUMFAX1"	, SubSTR(ALLTRIM(SM0->M0_FAX),2,Len(ALLTRIM(SM0->M0_FAX)))	)
		oHtml:ValByName("CCONTATO1"	, cCONTATO	)
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO VEÍCULO		                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
		
		oHtml:ValByName("CPLACAV"	, DA3->DA3_PLACA	)
		oHtml:ValByName("CCHASSIV"	, DA3->DA3_CHASSI	)
		oHtml:ValByName("CRENAVANV"	, DA3->DA3_RENAVA	)
	
		dbSelectArea("SX5")	// Marca Veiculo
		dbSetOrder(1)
		dbSeek( xFilial("SX5") + "M6" + DA3->DA3_MARVEI )
	
		oHtml:ValByName("CMARCAV"	, UPPER(ALLTRIM(SX5->X5_DESCRI)) )
		oHtml:ValByName("CMODELOV"	, UPPER(ALLTRIM(DA3->DA3_X_MOD)) )
		oHtml:ValByName("CANOV"		, DA3->DA3_ANOMOD +"/"+DA3->DA3_ANOFAB )
		oHtml:ValByName("CCAPACIDV" , IIF(DA3->DA3_CAPACN!=0,cValToChar(DA3->DA3_CAPACN)+"CV"," ") )
		
		cCATEGORIA := IIF(DA3->DA3_FROVEI=='1',"PROPRIO",IIF(DA3->DA3_FROVEI=='2',"ALUGUEL","AGREGADO"))
		
		oHtml:ValByName("CCATEGORV"	, cCATEGORIA )
		oHtml:ValByName("CESPECIEV"	, UPPER(ALLTRIM(DA3->DA3_X_ESP))	)
		oHtml:ValByName("CMUNICIPV"	, UPPER(ALLTRIM(DA3->DA3_MUNPLA))+"-"+DA3->DA3_ESTPLA	)
		cCOMBUSTIVEL := IIF(DA3->DA3_X_COM=='1',"DIESEL",IIF(DA3->DA3_X_COM=='2',"GASOLINA",IIF(DA3->DA3_X_COM=='3',"ETANOL","FLEX")))
	
		oHtml:ValByName("CCOMBUSV"	, cCOMBUSTIVEL ) 
		
		dbSelectArea("SX5")	// Cor Veiculo
		dbSetOrder(1)
		dbSeek( xFilial("SX5") + "M7" + DA3->DA3_CORVEI )
			
		oHtml:ValByName("CCORV"		, UPPER(ALLTRIM(SX5->X5_DESCRI)) )
	                                                                      
		CSIMRT := " "	// Veiculo Rastreado = SIM
		CNAORT := " "	// Veiculo Rastreado = NAO
		
		// Veiculo Rastreado
		If DA3->DA3_VEIRAS == "1"
			CSIMRT := "X"
		Else
			CNAORT := "X"
		EndIf	
		             
	   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DA CARRETA		                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
		
		dbSelectArea("DA3")	// Localiza carreta da estrutura do bem
		dbSetOrder(5) 	//DA3_FILIAL+DA3_CODBEM+DA3_COD
		dbGoTop()
		dbSeek( xFilial("DA3") + DTR->DTR_CODRB1 )
	
		
		oHtml:ValByName("CPLACAC"	, DA3->DA3_PLACA	)
		oHtml:ValByName("CCHASSIC"	, DA3->DA3_CHASSI	)
		oHtml:ValByName("CRENAVANC"	, DA3->DA3_RENAVA	)
	
		dbSelectArea("SX5")	// Marca Veiculo
		dbSetOrder(1)
		dbSeek( xFilial("SX5") + "M6" + DA3->DA3_MARVEI )
	
		oHtml:ValByName("CMARCAC"	, UPPER(ALLTRIM(SX5->X5_DESCRI)) )
			
		oHtml:ValByName("CMODELOC"	, UPPER(ALLTRIM(DA3->DA3_X_MOD)) )
		oHtml:ValByName("CANOC"		, DA3->DA3_ANOMOD +"/"+DA3->DA3_ANOFAB )
		oHtml:ValByName("CCAPACIDC" , IIF(DA3->DA3_CAPACN!=0,cValToChar(DA3->DA3_CAPACN)," ") ) 
		
		cCATEGORIA := IIF(DA3->DA3_FROVEI=='1',"PROPRIO",IIF(DA3->DA3_FROVEI=='2',"ALUGUEL","AGREGADO"))
		
		oHtml:ValByName("CCATEGORC"	, cCATEGORIA )
		
		dbSelectArea("SX5")	// Cor Veiculo
		dbSetOrder(1)
		dbSeek( xFilial("SX5") + "M7" + DA3->DA3_CORVEI )
			
		oHtml:ValByName("CCORC"		, UPPER(ALLTRIM(SX5->X5_DESCRI))	)		
	
		oHtml:ValByName("CMUNICIPC"	, UPPER(ALLTRIM(DA3->DA3_MUNPLA))+"-"+DA3->DA3_ESTPLA	)
		oHtml:ValByName("CESPECIEC"	, UPPER(ALLTRIM(DA3->DA3_X_ESP))	)
	
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO MOTORISTA		                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oHtml:ValByName("CNOMEMOT"	, UPPER(ALLTRIM(DA4->DA4_NOME))		)
		oHtml:ValByName("CCPFMOT"	, TRANSFORM( DA4->DA4_CGC, "@R 999.999.999-99" ) )
		oHtml:ValByName("CDTEMCPF"	, DTOC(DA4->DA4_X_DCPF) )
		oHtml:ValByName("CRGMOT"	, ALLTRIM(DA4->DA4_RG)	)
		oHtml:ValByName("CDTEMRG"	, DTOC(DA4->DA4_RGDT)	)
		oHtml:ValByName("CDTNASC"	, DTOC(DA4->DA4_DATNAS)	)
		oHtml:ValByName("CCNHMOT"	, ALLTRIM(DA4->DA4_NUMCNH) )
		oHtml:ValByName("CNREGMOT"	, ALLTRIM(DA4->DA4_REGCNH) )
		oHtml:ValByName("CVCTOCNH"	, DTOC(DA4->DA4_DTVCNH) )
		oHtml:ValByName("CCATCNH"	, ALLTRIM(DA4->DA4_CATCNH) )
		oHtml:ValByName("CPANCARY"	, ALLTRIM(DA4->DA4_X_PANC) )
		oHtml:ValByName("CVCTOPANC"	, DTOC(DA4->DA4_X_VPAN) )
		oHtml:ValByName("CNOMEPAI"	, UPPER(ALLTRIM(DA4->DA4_PAI))	)	
		oHtml:ValByName("CNOMEMAE"	, UPPER(ALLTRIM(DA4->DA4_MAE))	)
		oHtml:ValByName("CMUNICMOT"	, UPPER(ALLTRIM(DA4->DA4_MUN))	)
		oHtml:ValByName("CBAIRMOT"	, UPPER(ALLTRIM(DA4->DA4_BAIRRO))	)
		oHtml:ValByName("CENDERMOT"	, UPPER(ALLTRIM(DA4->DA4_END))	)
		oHtml:ValByName("CCEPMOT"	, DA4->DA4_CEP	)
		oHtml:ValByName("CNUMTELM"	, DA4->DA4_TEL	)
		oHtml:ValByName("CCONTAT1"	, ALLTRIM(DA4->DA4_X_CON1) )
		oHtml:ValByName("CTELCON1"	, DA4->DA4_X_TEL1 )
		oHtml:ValByName("CCONTAT2"	, ALLTRIM(DA4->DA4_X_CON2) )
		oHtml:ValByName("CTELCON2"	, DA4->DA4_X_TEL2 )
		oHtml:ValByName("CCONTAT3"	, ALLTRIM(DA4->DA4_X_CON3) )
		oHtml:ValByName("CTELCON3"	, DA4->DA4_X_TEL1 )
		
		CSIMVR := " "	// Vitima de roubo = SIM
		CNAOVR := " " 	// Vitima de roubo = NAO
		CQTDVR := " " 	// Vitima de roubo = N VEZES
		CSIMAC := " " 	// Envolvido em acidente = SIM
		CNAOAC := " " 	// Envolvido em acidente = NAO
		CQTDAC := " " 	// Envolvido em acidente = N VEZES
		
		// Vitima de roubo
		If DA4->DA4_X_VROU == "S"
			CSIMVR := "X"
		Else
			CNAOVR := "X"
		EndIf
		If DA4->DA4_X_NROU != 0
			CQTDVR := cValToChar(DA4->DA4_X_NROU)
		EndIf
		
		// Envolvido em acidente
		If DA4->DA4_X_ACID == "S"
			CSIMAC := "X"
		Else
			CNAOAC := "X"
		EndIf
		If DA4->DA4_X_NACI != 0
			CQTDAC := cValToChar(DA4->DA4_X_NACI)
		EndIf	
		
		oHtml:ValByName("CSIMVR"	, CSIMVR	)
		oHtml:ValByName("CNAOVR"	, CNAOVR	)
		oHtml:ValByName("CQTDVR"	, CQTDVR	)			
		oHtml:ValByName("CSIMAC"	, CSIMAC	)
		oHtml:ValByName("CNAOAC"	, CNAOAC	)
		oHtml:ValByName("CQTDAC"	, CQTDAC	)	
		oHtml:ValByName("CSIMRT"	, CSIMRT	)
		oHtml:ValByName("CNAORT"	, CNAORT	)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ DADOS DO PROPRIETÁRIO 	                                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		dbSelectArea("SM0")
		dbSetOrder(1)
		dbSeek("5001")	// Código Empresa/Filial Matriz
		
		oHtml:ValByName("CRAZAOSOC2", UPPER(ALLTRIM(SM0->M0_NOMECOM)) 	)
		oHtml:ValByName("CCPFCNPJ2"	, TRANSFORM( SM0->M0_CGC, "@R 99.999.999/9999-99" )	)
		oHtml:ValByName("CRGIE2"	, SM0->M0_INSC	)
		oHtml:ValByName("CMUNICIP2"	, UPPER(ALLTRIM(SM0->M0_CIDCOB)) 	)
		oHtml:ValByName("CBAIRRO2"	, UPPER(ALLTRIM(SM0->M0_BAIRCOB)) 	)
		oHtml:ValByName("CENDERECO2", UPPER(ALLTRIM(SM0->M0_ENDCOB)) 	)
		oHtml:ValByName("CCEP2" 	, ALLTRIM(SM0->M0_CEPCOB) 	)
		oHtml:ValByName("CNUMTEL2"	, SubSTR(ALLTRIM(SM0->M0_TEL),2,Len(ALLTRIM(SM0->M0_TEL)))	)
		oHtml:ValByName("CNUMFAX2"	, SubSTR(ALLTRIM(SM0->M0_FAX),2,Len(ALLTRIM(SM0->M0_FAX)))	)
		oHtml:ValByName("CCONTATO2"	, cCONTATO	)
	
		If cEmail != "" .or. cEmailCC != ""
			
			If cEmail != "" .and. cEmailCC != ""
				cEmail := cEmail + ";" + cEmailCC
			ElseIf cEmailCC != ""
				cEmail := cEmailCC
			EndIf
			
			oProcess:cTo  := LOWER(cEmail)
			
			ConOut("WF - TM141GRV - E-MAIL ENVIADO PARA: " + oProcess:cTo)
		
			// inicia o processo de envio de workflow
			oProcess:Start()	
			
			// finaliza o processo
			oProcess:Finish()
			
			conout("WF - TM141GRV - FIM DO ENVIO DE EMAIL - COTACAO DE FRETE ")
		
			RestArea(aArea)
		
			If ! Empty(SA1->A1_EMAIL)
				Aviso("Aviso", "Workflow enviado ao remetente com sucesso!", {"OK"}, 2)				
			EndIf	
			                             
		EndIf
		
	EndIf 
	
Return 