#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030INC   ºAutor  ³Rafael Parma        º Data ³  18/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após inclusão do cliente, envia º±±
±±º          ³e-mail ao superior do usuário que informar limite de créditoº±±
±±º          ³com valor superior ao valor permitido.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function M030INC()
*-------------------------*
	Local nOpc	  := PARAMIXB
	Local aAreaSA1:= SA1->(GetArea())
	
	//DEVAIR 09/03/2015
	//se clicar em confirmar. Evita reclock quando está em EOF no caso de desistir da inclusão do cliente
	if nOpc == 1 
	
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
		
		If RecLock("SA1",.F.)
			//--Tratamento ImportSYS
			SA1->A1_X_ESYS := "S"
			
			//--Tratamento B2B Vertis
			If SA1->A1_X_EB2B == "S"
				SA1->A1_X_AB2B := "S"
			EndIf
			SA1->(MsUnLock())
		EndIf	 	


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
		 
	endif
	
	RestArea(aAreaSA1)
Return .T.  