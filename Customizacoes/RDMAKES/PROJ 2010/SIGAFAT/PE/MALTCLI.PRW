#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MALTCLI   ºAutor  ³Rafael Parma        º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após alteração do cliente, enviaº±±
±±º          ³e-mail ao superior do usuário que informar limite de créditoº±±
±±º          ³com valor superior ao valor permitido.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function MALTCLI()
*-------------------------*

	If SA1->A1_LC > 0
		dbSelectArea("Z21")
		dbSetOrder(1)
		If dbSeek ( xFilial("Z21") + __CUSERID )
			If SA1->A1_LC > Z21->Z21_LC
				
				If !Empty(Z21->Z21_SUP)
					PswOrder(1)
					If PswSeek(Z21->Z21_SUP)
					    cEMAILUSR := PswRet()[1][14]
						If ALLTRIM(cEMAILUSR) != ""
							U_RJSMLCCL(cEMAILUSR)					
						EndIf
					EndIf
				EndIf
				
			EndIf
		EndIf	
	EndIf
	// Adriano 31-12-2010.
	// Grava data da ultima alteração cadastral. 
	// Sistema de vendas SIM3G utiliza essa data para atualizar os dados cadastrais do cliente.
	SA1->(Reclock("SA1",.F.))
		SA1->A1_X_DTALT	:= dDataBase
		
		//--Tratamento ImportSYS
		SA1->A1_X_ESYS := "S"
		
		//--Tratamento B2B Vertis
		If SA1->A1_X_EB2B == "S"
			SA1->A1_X_AB2B := "S"
		EndIf
	SA1->(MsUnlock("SA1"))	
	
	
	/*
	
	Envia dados de cliente para Salesforce
	
	@author devair.tonon
	@since 13/02/2015
	@version 1.0
	
	*/                               
	lMVXINTSF := SuperGetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := SuperGetMv('MV_X_SFJOB', .F. ,.F.)
	if SA1->(FIELDPOS("A1_X_ENVSF"))!=0 .and. SA1->A1_X_ENVSF == "S" .AND. lMVXINTSF
		if findfunction("U_SFCLI001")  
			if lMVXSFJOB                                                                       
				StartJob('U_SFCLI001',GetEnvServer(),.F., SA1->A1_COD, SA1->A1_LOJA, lMVXSFJOB, cEmpAnt, cFilAnt )       
			else
				U_SFCLI001(SA1->A1_COD, SA1->A1_LOJA, .F.)
			endif
		endif
	endif

Return .T.  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJSMLCCL  ºAutor  ³Rafael Parma        º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para envio de e-mail ao superior sobre limite crédito.±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------*
User Function RJSMLCCL(cEMAILUSR)
*------------------------------------*
Local oProcess
Local cEmail  := ""
Local nTOTDIV := 0
Local aArea   := GetArea()
 
	conout("WF - RJSMLCCL - INICIO DO ENVIO DE EMAIL - LIMITE DE CREDITO")
	
	oProcess := TWFProcess():New( "RJSMLCCL", "LIMITE DE CREDITO")
	oProcess:NewTask( "WFCONFC", "\workflow\rjsmlccl.html")
	
	oProcess:cSubject :=  "WF - AVISO: LIMITE DE CRÉDITO MAIOR QUE O PERMITIDO" 
							
	oHTML := oProcess:oHTML
	                                             
	oHtml:ValByName("EMPRESA", ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)
	oHtml:ValByName("CLIENTE", SA1->A1_COD +"/"+ SA1->A1_LOJA +"-"+ SA1->A1_NOME	)
	oHtml:ValByName("DATABAS", dtoc(ddatabase)	)
	oHtml:ValByName("USUARIO", ALLTRIM(UPPER(CUSERNAME))	)
	oHtml:ValByName("LMTPERM", Transform(Z21->Z21_LC, "@E 999,999,999.99")	) 
	oHtml:ValByName("LMTCLIE", Transform(SA1->A1_LC,  "@E 999,999,999.99")	) 
	

	oProcess:cTo  := LOWER(cEMAILUSR)
	ConOut("WF - RJSMLCCL - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()

	conout("WF - RJSMLCCL - FIM DO ENVIO DE EMAIL -  LIMITE DE CREDITO")
	RestArea(aArea)
	
Return