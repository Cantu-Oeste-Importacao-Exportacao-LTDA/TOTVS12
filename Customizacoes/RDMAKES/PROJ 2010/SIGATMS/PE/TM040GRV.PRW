#include "TOTVS.CH"
#include "TOPCONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TM040GRV   ºAutor  ³Rafael Parma       º Data ³  13/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a gravação de dados tabela º±±
±±º          ³DT4 (TMSA040-Cotação Fretes).                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function TM040GRV()
*----------------------------*
Local nOpcx := PARAMIXB[1]  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se workflow com ficha cadastral deve ser enviada.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If ALLTRIM(SuperGetMV("MV_X_ATWFC",,"N")) == "S" .and. nOpcx == 3
   		U_RJT040WF(.F.)		
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJT460WF   ºAutor  ³Rafael Parma      º Data ³  14/10/10   º±±
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
User Function RJT040WF(lMsgOK)
*-------------------------------*
Local oProcess
Local cEmail   := ""
Local cEmailCC := ""
Local cCONTATO := ALLTRIM(SuperGetMV("MV_X_CNWFC",,"N"))
Local aArea    := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
    
	conout("WF - TM040GRV - INICIO DO ENVIO DE EMAIL - COTACAO DE FRETE ")
	
	// Busca o email da configuracao 
	cEmailCC  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "TM040GRV", "ZWF_EMAIL"))

	// Busca o email do solicitante
	dbSelectArea("DUE")		//Tabela de solicitante
	dbSetOrder(1)	//DUE_FILIAL+DUE_DDD+DUE_TEL 
	dbGoTop()
	dbSeek( xFilial("DUE") + DT4->DT4_DDD + DT4->DT4_TEL )
	If Empty(DUE->DUE_EMAIL)
		MsgAlert("E-mail do solicitante não preenchido, não será enviado workflow.")
		Return
	Else
		cEmail := DUE->DUE_EMAIL
	EndIf


	oProcess := TWFProcess():New( "TM040GRV", "DADOS VEICULO/CARRETA/MOTORISTA")
	oProcess:NewTask( "TM040GRV", "\workflow\WFFICVM.HTML")
	
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
	
	dbSelectArea("DA3")	// Veiculo
	dbSetOrder(1)
	dbSeek( xFilial("DA3") + DT4->DT4_X_CODV )
	
	oHtml:ValByName("CPLACAV"	, DA3->DA3_PLACA	)
	oHtml:ValByName("CCHASSIV"	, DA3->DA3_CHASSI	)
	oHtml:ValByName("CRENAVANV"	, DA3->DA3_RENAVA	)

	dbSelectArea("SX5")	// Marca Veiculo
	dbSetOrder(1)
	dbSeek( xFilial("SX5") + "M6" + DA3->DA3_MARVEI )

	oHtml:ValByName("CMARCAV"	, UPPER(ALLTRIM(SX5->X5_DESCRI)) )
	oHtml:ValByName("CMODELOV"	, UPPER(ALLTRIM(DA3->DA3_X_MOD)) )
	oHtml:ValByName("CANOV"		, DA3->DA3_ANOMOD +"/"+DA3->DA3_ANOFAB )
	oHtml:ValByName("CCAPACIDV" , IIF(DA3->DA3_CAPACN!=0,cValToChar(DA3->CAPACN)+"CV"," ") )
	
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
	             
	// Estrutura de bens
    dbSelectArea("STC")
    dbSetOrder(1)
    dbSeek( xFilial("STC") + DA3->DA3_CODBEM )
    
   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ DADOS DA CARRETA		                                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	
	dbSelectArea("DA3")	// Carreta
	dbSetOrder(5) 	//DA3_FILIAL+DA3_CODBEM+DA3_COD
	dbSeek( xFilial("DA3") + STC->TC_COMPONE )
	
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
	
	dbSelectArea("DA4")
	dbSetOrder(1)
	dbSeek( xFilial("DA4") + DT4->DT4_X_CODM )
	
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
		
	
		ConOut("WF - TM040GRV - E-MAIL ENVIADO PARA: " + oProcess:cTo)
	
		// inicia o processo de envio de workflow
		oProcess:Start()	
		
		// finaliza o processo
		oProcess:Finish()
		
		conout("WF - TM040GRV - FIM DO ENVIO DE EMAIL - COTACAO DE FRETE ")
	
		RestArea(aArea)
	
		If lMsgOK
			Aviso("Aviso", "Workflow enviado com sucesso!", {"OK"}, 2)				
		EndIf	
	
	EndIf

Return 