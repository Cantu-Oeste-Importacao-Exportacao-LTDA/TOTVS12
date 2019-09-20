#include "protheus.ch"
/*/
+----------+----------+-------+-----------------------+------+-----------+
|Programa  | SF1100I  | Autor | Rafael Parma          | Data | 22/04/05  |
+----------+----------+-------+-----------------------+------+-----------+
|Descricao | Ponto de Entrada na NF de entrada, executado qdo a NF for   |
|          | de devoluçao. É feita a gravação da natureza, informada     | 
|          | pelo usuário, por padrão o sistema grava a natureza definida|
|          | no cadastro de usuário. O segundo campo gravado é o código  |
|          | do vendedor, o qual o sistema, por padrão, não grava nada.  |
+----------+-------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu Verduras                         |
+----------+-------------------------------------------------------------+
/*/
User Function SF1100I() 

Local lDescInc := .T.  //Caso o cliente possua desconto incondicional e mesmo assim deva compensar automatico

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³02/06/15 - VALIDA SE FOI CHAMADO PELA ROTINA DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ISINCALLSTACK("U_SCHCLACTE")
	
	If SF1->F1_TIPO == "D"

		dbSelectArea("SE1")
		dbSetOrder(2) // FILIAL + CLIENTE + LOJA + PREFIXO + TITULO
		dbGoTop()
		If dbSeek(xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)	
			While !EOF() .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == ;
			                   xFilial("SE1")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC                                           
				RecLock("SE1",.f.)
				SE1->E1_NATUREZ := MAFISRET(,"NF_NATUREZA")
   		        dbSelectArea("SA1")               //incluido por Eder Gasparin 02/07/05
		        dbSetOrder(1) // FILIAL + CODIGO + LOJA
				If dbSeek(xFilial("SA1")+SE1->E1_Cliente+SE1->E1_Loja)
                   SE1->E1_VEND1 := SA1->A1_VEND
				EndIf                             //fim bloco incluido por Eder Gasparin
				SE1->(MsUnLock())
				dbSelectArea("SE1")
				dbSetOrder(2) 
				dbSkip()			
			Enddo
		Endif
		
		
        //Gustavo - Inicio 31/07/2014
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o cliente possui desconto incondicional e se deve compensar automatico caso possua.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        dbSelectArea("Z16")
        Z16->(dbSetOrder(3)) // Z16_FILIAL + Z16_CODCLI + Z16_LOJCLI
        Z16->(dbGoTop())
        If dbSeek(xFilial("Z16")+SF1->F1_FORNECE)  
        	While(!EOF()) .and. SF1->F1_FORNECE == Z16->Z16_CODCLI
	        	If Z16->Z16_ATIVO == "S" .and. SF1->F1_EMISSAO >= Z16->Z16_DATINI .and. SF1->F1_EMISSAO <= Z16->Z16_DATFIN .and. Z16->Z16_REGRA == 'I' .and. ALLTRIM(SuperGetMV("MV_X_DESIN",,"N")) == 'N'   
	        		lDescInc := .F. //Indica que não deve compensar
	    		EndIf
		    	Z16->(dbSkip())
	    	EndDo
        EndIf
        //Gustavo - Fim 31/07/2014
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Processamento da rotina de compensação automatica devolução de vendas.  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ALLTRIM(SuperGetMV("MV_X_ACPAV",,"N")) == "S" .AND. SF1->F1_TIPO == "D"
			If ALLTRIM(SuperGetMV("MV_X_ACPAF",,"N")) == "S"
				If SF1->F1_FORMUL == "S" .and. lDescInc	
					fCompDEV( SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA )
				EndIf                        				
			Else
				If lDescInc                             
					fCompDEV( SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA )
				EndIF
			EndIf
		EndIf
	Endif
	
	// 26/04/2011 - Flavio - reimplementado ponto de entrada
	// Alterado para gravar o usuario que está incluindo o documento de entrada
	// Grava o usuário que fez a classificação do documento
	if SF1->(FieldPos("F1_USUARIO")) > 0
		RecLock("SF1", .F.)
		SF1->F1_USUARIO = SubStr(cUsuario, 07, 15)		
		SF1->(MsUnlock())
	EndIf

EndIf
	
Return .T.




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCompDEV    ºAutor  ³Rafael Parma      º Data ³  20/02/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por realizar a compensação automática en-º±±
±±º          ³tre os títulos do documento de vendas e devolução.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*--------------------------------------------------------------------------*
Static Function fCompDEV( cCodFil, cCodDoc, cCodSer, cCodFor, cCodLoj )
*--------------------------------------------------------------------------*
Local aArea := GetArea()
Local aTITREC := {}
Local aTITNCC := {}         
Local nTOTREC := 0
Local nTOTNCC := 0
Local cDOCORI := ""
Local cSERORI := ""
Local cCODBCO := ""
Local cNOSNUM := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o pergunte da rotina de compensação financeira³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PERGUNTE("AFI340",.F.)
	lContabiliza:= MV_PAR11 == 1
	lAglutina	:= MV_PAR08 == 1
	lDigita		:= MV_PAR09 == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza número e serie do documento de origem                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodFor + cCodLoj )
	
		If !Empty(SD1->D1_NFORI) .and. !Empty(SD1->D1_SERIORI)
			cDOCORI := SD1->D1_NFORI
			cSERORI := SD1->D1_SERIORI
			
			dbSelectArea("SF2")
			dbSetOrder(1)	//F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA+F2_FORMUL+F2_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SF2") + SD1->D1_NFORI + SD1->D1_SERIORI + cCodFor + cCodLoj )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena títulos do documento de origem com saldo                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
			
				dbSelectArea("SE1")
				dbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
				dbGoTop()
				If dbSeek ( xFilial("SE1") + SF2->(F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC) )
					While !SE1->(EOF()) .and. SE1->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM) == ;
										xFilial("SE1") + SF2->(F2_CLIENTE + F2_LOJA + F2_SERIE + F2_DOC)
						If SE1->E1_SALDO > 0
							aAdd ( aTITREC, SE1->(RECNO()) )
							nTOTREC += SE1->E1_SALDO
						EndIf
						cCODBCO := ALLTRIM(SE1->E1_PORTADO) + "/" + ALLTRIM(SE1->E1_AGEDEP) + "/" + ALLTRIM(SE1->E1_CONTA)
						cNOSNUM := ALLTRIM(SE1->E1_NUMBCO)
						SE1->(dbSkip())
					Enddo				
				EndIf
			
			EndIf
		
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazena títulos do documento de devolução com saldo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    

		dbSelectArea("SE1")
		dbSetOrder(2)	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		dbGoTop()
		If dbSeek ( cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc )
			While !SE1->(EOF()) .and. SE1->(E1_FILIAL + E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM) == ;
								 cCodFil + cCodFor + cCodLoj + cCodSer + cCodDoc 
				If SE1->E1_SALDO > 0 .and. SE1->E1_TIPO == "NCC"
					aAdd ( aTITNCC, SE1->(RECNO()) )            
					nTOTNCC += SE1->E1_SALDO
				EndIf
				SE1->(dbSkip())
			Enddo				
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a compensação entre os títulos contas a pagar.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    

	If Len(aTITREC) > 0 .and. Len(aTITNCC) > 0
	    
		If ! MaIntBxCR(3,aTITREC,,aTITNCC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.})
			Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)
			
		Else      

			//--Atualização de campo referente ao SERASA
			For nX := 1 to Len(aTITREC)
				dbSelectArea("SE1")
				dbGoTo(aTITREC[nX])
				If !SE1->(EOF()).AND.!SE1->(BOF())
					If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
						If RecLock("SE1",.F.)
							SE1->E1_PEFINMB := "02"	// "02 – Renegociação da dívida" 	
							SE1->(MsUnlock())
						EndIf
					Endif
				EndIf
			Next nX
						
		
			If nTOTREC < nTOTNCC
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio de workflow - diferença de valores                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							
				cMOTIVO := "SALDO TOTAL DOS TÍTULOS DE VENDAS MENOR QUE O VALOR DO TÍTULO NCC - DEVOLUÇÃO."
				fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)
				
			Else

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio de workflow - diferença de valores                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							
				cMOTIVO := "COMPENSAÇÃO DE TÍTULO NCC - DEVOLUÇÃO REALIZADA COM SUCESSO."
				fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)
				
			EndIf
			
		EndIf
	
	ElseIf Len(aTITNCC) > 0 .and. Len(aTITREC) == 0


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envio de workflow - saldo título de compras zerado                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

		cMOTIVO := "TÍTULOS DE VENDAS SEM SALDO PARA COMPENSAR COM TÍTULO NCC - DEVOLUÇÃO."
		fWFCMPDVV(cMOTIVO, nTOTNCC, nTOTREC, SF1->F1_FORNECE, SF1->F1_LOJA, cSERORI, cDOCORI, cCodSer, cCodDoc, cCODBCO, cNOSNUM)
		
	EndIf                        
	
	
	RestArea(aArea)

Return      
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWFCMPDVV  ºAutor  ³Rafael Parma       º Data ³  20/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para enviar workflow informativo sobre compensação   º±±
±±º          ³devolução de vendas.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

Static Function fWFCMPDVV( cMOTIVO, nTOTNCC, nTOTREC, cCLIENTE, cLOJCLI, cSERORI, cDOCORI, cSERDEV, cDOCDEV, cCODBCO, cNOSNUM )
Local aArea  := GetArea()
Local cEmail := ""
Local oProcess
    
	conout("WF - WFCMPDVV - INICIO DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO VENDAS")
	
	// Busca o email da configuracao
	cEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFCMPDVV", "ZWF_EMAIL"))
	
	If cEmail == "" 
		conout("WF - WFCMPDVV - E-MAIL NAO LOCALIZADO - PROCESSO: WFCMPDVV")
		Return
	EndIf


	oProcess := TWFProcess():New( "WFCMPDVV", "DEVOLUCAO DE VENDAS")
	oProcess:NewTask( "WFCMPDVV", "\workflow\wfcmpdvv.html")
	
	oProcess:cSubject :=  "WF - COMPENSAÇÃO FINANCEIRA - DEVOLUÇÃO DE VENDAS" 
							
	oHTML := oProcess:oHTML
	                                             
	oHtml:ValByName("DDATABASE"	, DTOC(ddatabase)	)
	oHtml:ValByName("CUSUARIO"	, ALLTRIM(UPPER(CUSERNAME)))
	oHtml:ValByName("CMOTIVO"	, ALLTRIM(UPPER(cMOTIVO)))
	oHtml:ValByName("cCLIENTE"	, cCLIENTE+"/"+cLOJCLI+"-"+ALLTRIM(Posicione("SA2",1,xFilial("SA2")+cCLIENTE+cLOJCLI,"A2_NOME")))
	oHtml:ValByName("CEMPRESA"	, ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)

	oHtml:ValByName("NVALDEV"	, Transform(nTOTNCC, "@E 999,999,999.99"))
	oHtml:ValByName("NVALVEN"	, Transform(nTOTREC, "@E 999,999,999.99"))
	oHtml:ValByName("CDOCORI"	, cDOCORI+"/"+cSERORI	)
	oHtml:ValByName("CDOCDEV"	, cDOCDEV+"/"+cSERDEV	)
	
	If nTOTREC > 0
		cVBAIXA := "Valor compensado: "+Transform(nTOTREC, "@E 999,999,999.99")
	Else
		cVBAIXA := " "
	EndIf
	
	oHtml:ValByName("CVBAIXA"	, cVBAIXA	)
	oHtml:ValByName("CCODBCO"	, cCODBCO	)
	oHtml:ValByName("CNOSNUM"	, cNOSNUM	)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa itens do array                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oProcess:cTo  := LOWER(cEmail) 
	
	conout("WF - WFCMPDVV - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - WFCMPDVV - FIM DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO VENDAS")

	RestArea(aArea)
	
Return