#include "TOTVS.CH"
#include "RWMAKE.CH"    

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103FIN   ºAutor  ³Rafael Parma       º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a confirmação documento de º±±
±±º          ³entrada, utilizado para validação sobre as datas/valores de º±±
±±º          ³vencimento dos títulos relacionados ao pedido de compras.   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User FuncTion XMT103FIN()    
*--------------------------*
Local aLocArea := GetArea() 
Local aFLUXO   := {}
Local aPEDIDOS := {} 
Local aCLVALOR := {}
Local aLocHead := PARAMIXB[1]      // aHeader do getdados apresentado no folter Financeiro.
Local aLocCols := PARAMIXB[2]      // aCols do getdados apresentado no folter Financeiro.
Local lLocRet  := PARAMIXB[3]      // Flag de validações anteriores padrões do sistema. 
Local nPCODPRD := aScan(aHeader, { |x| x[2] = "D1_COD"})
Local nPCODTES := aScan(aHeader, { |x| x[2] = "D1_TES"})
Local nPOSCLVL := aScan(aHeader, { |x| x[2] = "D1_CLVL"})
Local nPOSPED  := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local nPITEPED := aScan(aHeader, { |x| x[2] = "D1_ITEMPC"})
Local cCLVLMUP := ALLTRIM(SuperGetMV("MV_X_CLERE",,""))      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³02/06/15 - VALIDA SE É CHAMADA DA ROTINA DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ISINCALLSTACK("U_SCHCLACTE")

	If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S" .and. lLocRet
		If Len(aCols) > 0
			For nI := 1 to Len(aCols)
				If !Empty(aCols[nI][nPosPED])

					If Len(aPEDIDOS) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aPEDIDOS, {|x| x[1] == aCols[nI][nPosPED] } )
					EndIf                               
					If nPOS == 0
						aAdd ( aPEDIDOS, { aCols[nI][nPosPED] } )
					EndIf
					If Len(aCLVALOR) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aCLVALOR, {|x| x[1] == aCols[nI][nPosCLVL] } )
					EndIf                               
					If nPOS == 0
						aAdd ( aCLVALOR, { aCols[nI][nPosCLVL] } )
					EndIf
                    
					//-- Verifica se o item foi incluído no pedido com C7_FLUXO = "N" e utiliza TES com F4_DUPLIC = "S".					
					If ! Empty(aCols[nI][nPosPED]) .and. ! Empty(aCols[nI][nPITEPED])
						dbSelectArea("SC7")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek ( xFilial("SC7") + aCols[nI][nPosPED] + aCols[nI][nPITEPED] )
							If SC7->C7_FLUXO == "N"
								If Posicione("SF4",1,xFilial("SF4")+aCols[nI][nPCODTES],"F4_DUPLIC") == "S"
									aAdd ( aFLUXO, { aCols[nI][nPosPED], aCols[nI][nPITEPED], aCols[nI][nPCODPRD] } )
								EndIf	
							EndIf
						EndIf					
					EndIf
							
				EndIf
			Next nI
		EndIf
		If Len(aPEDIDOS) > 0
			/* Multiplos pedidos somente para compras do segmento de transportes */
			If Len(aPEDIDOS) > 1 .and. Len(aCLVALOR) > 0
				For nA := 1 to Len(aCLVALOR)
					If ! aCLVALOR[nA,01] $ cCLVLMUP
						lLocRet := .F.
						Exit
					EndIf
				Next nA
				If !lLocRet
					Aviso("Atenção","Somente poderá ser utilizado mais que um pedido para inclusão do documento de entrada para o(s) seguinte(s) segmento(s): "+cCLVLMUP,{"OK"},2)
				EndIf
			EndIf
			If lLocRet				
				MsAguarde( {|| fCheckPAR(aPEDIDOS, aFLUXO, aLocCols, @lLocRet) }, "Verificando títulos a pagar... Aguarde!")					
			EndIf
		Else
			/* Documento de entrada sem pedido */
			lLocRet := fCheckVCTO(aLocCols)
		EndIf
		//Guilherme 26/05/14 - Verificação dos títulos de retenção de IRRF que devem ter código de retenção e informado GERA DIRF = SIM
		If lLocRet 
			lLocRet := fCheckIrrf()
		EndIF
	EndIf 

EndIf  

RestArea(aLocArea)

Return (lLocRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckPAR  ºAutor  ³Rafael Parma       º Data ³  20/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica datas/valores informados no documento com datas/   º±±
±±º          ³valores informados no pedido de compras.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------------------------------------*
Static Function fCheckPAR(aPEDIDOS, aFLUXO, aLocCols, lRet)
*----------------------------------------------------------*
Local aDADOS 	:= {}
Local lRetDAT 	:= .T.
Local lRetVAL 	:= .T.
Local lRetCtr 	:= .F.
Local nMARGSUP 	:= SuperGetMV("MV_X_MARSP",,0)
Local nMVNDPAV 	:= SuperGetMV("MV_X_NDPAV",,5)		//--Margem mínima com o número de dias para documentos de entrada com pedido e parcelas a vencer a partir da data atual.
Local nMVNDPJV 	:= SuperGetMV("MV_X_NDPJV",,7)		//--Margem mínima com o número de dias para documentos de entrada com pedido e parcelas já vencidas a partir da data atual.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Localiza pedido relacionado ao documento                     		   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aPEDIDOS) > 0
		For nX := 1 to Len(aPEDIDOS)
			dbSelectArea("Z11")          
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("Z11") + aPEDIDOS[nX,01] )
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + aPEDIDOS[nX,01]		
					If Len(aDADOS) == 0
						nPOS := 0
					Else
						nPOS := aScan ( aDADOS, {|x| x[1] == Z11->Z11_VENCTO } )
					EndIf        
					If nPOS == 0
						aAdd (aDADOS, { Z11->Z11_VENCTO, Z11->Z11_VALOR, Z11->Z11_PARCEL } )
					Else
						aDADOS[nPOS,02] += Z11->Z11_VALOR
					EndIf
					Z11->(dbSkip())		
				Enddo
			Else //Guilherme 12/05/14 - validação nos pedidos de contratos	
				dbSelectArea("SC7")          
				dbSetOrder(1)
				dbGoTop()
				If DbSeek( xFilial("SC7") + aPEDIDOS[nX,01])
					If !Empty(Alltrim(SC7->C7_CONTATO))					
						While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + aPEDIDOS[nX,01]		
							If Len(aDADOS) == 0
								nPOS := 0
							Else
								nPOS := aScan ( aDADOS, {|x| x[1] == SC7->C7_DATPRF } )
							EndIf        
							If nPOS == 0
								aAdd (aDADOS, { SC7->C7_DATPRF, SC7->C7_TOTAL,Space(3) } )
							Else
								aDADOS[nPOS,02] += SC7->C7_TOTAl
							EndIf
							SC7->(dbSkip())		
						Enddo
						
						If Len(aDADOS) > 0                                       
							For nI := 1 to Len(aDADOS) 
								nPOS := aScan ( aLocCols, {|x| x[2] == aDADOS[nI][01] } )
								If nPOS == 0  
									dDtPed 	:= aDADOS[nI][01]									
									lRetDAT := .F.
									lRetCtr	:= .T.							
									Exit 	
								EndIf
						   	Next nI
						EndIf
					EndIf
				EndIf						
			EndIf
		Next nX
	EndIf
			
	If Len(aDADOS) > 0
		For nI := 1 to Len(aDADOS) 
			// Flavio - 29/01/2011 - alterado para que quando o valor estiver zerado nao validar a data, 
			// nos casos em que é digitado bonificação e a data de emissao fica bloqueada
			nPOS := aScan ( aLocCols, {|x| x[2] == aDADOS[nI][01] .Or. x[3] == 0  } )
			If nPOS == 0
				lRetDAT := .F.
				Exit
			Else                                                                                            
				// Se moeda 1 valida valor, caso contrário somente data de vencimento.
				If NMOEDACOR == 1 .and. POSICIONE("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST") != "EX"	
					If aLocCols[nPOS][03] > ( aDADOS[nI][02] + nMARGSUP )
						lRetVAL := .F.
						Exit
					EndIf 
				EndIf
			EndIf
		Next nI
		
		//--Verifica se o vencimento informado no documento é menor que o do pedido (não é permitido).
		lCHECKPARC := .T.
		If ! lRetDAT .and. Len(aLocCols) > 0
			For nI := 1 to Len(aLocCols)
				If aLocCols[nI][03] > 0
					For nJ := 1 to Len(aDADOS) 
						If (aLocCols[nI][01] == aDADOS[nJ][03]) .OR. ( Empty(aLocCols[nI][01]) .AND. (aDADOS[nJ][03])=="001" ) //--Número da parcela
							If aLocCols[nI][02]	< aDADOS[nJ][01]
								lCHECKPARC := .F.        
								Exit
							EndIf
						EndIf
					Next nJ
				EndIf
			Next nI
		EndIf

		//--Validação das datas de vencimentos com margens, a partir da data atual e não database.
		If lCHECKPARC
			//--Parcela do fluxo já vencida
			lPARVENCDA := .F.
			For nI := 1 to Len(aDADOS) 
	        	If aDADOS[nI][01] <= date()
	        		lPARVENCDA := .T.
	        		Exit
	        	EndIf
	        Next nI
	        
	        lMARGEM := .T.
			For nI := 1 to Len(aLocCols)
				If aLocCols[nI][03] > 0
					If lPARVENCDA .and. aLocCols[nI][02] <= (date()+nMVNDPJV)
						lMARGEM := .F.
						Exit
					ElseIf !lPARVENCDA .and. aLocCols[nI][02] <= (date()+nMVNDPAV)
						lMARGEM := .F.
						Exit
					EndIf
				EndIf
			Next nI			
			lRetDAT := lMARGEM
		EndIf
			                            
		//Guilherme 12/05/14 - caso as datas do pedido não sejam as mesmas do Doct. de Entrada.
		If !lRetDAT .AND. lRetCtr
			Aviso("Atenção!","A data de vencimento da nota fiscal não confere com a data de vencimento do pedido: "+DtoC(dDtPed),{"OK"},2)	
			lRet := .F.	
		EndIf    
		
		If !lRetCtr // Adicionado para que nao verifique as mensagens caso seja pedido gerado de contrato contrato. Guilherme 12/05/14                                          		       
			If ! lRetDAT  
			
				cTEXTO := "As datas de vencimento informadas no documento são inferiores às informadas no pedido."+chr(10)+chr(13)
				cTEXTO += "São permitidos lançamentos somente com vencimento igual ou superior ao informado no pedido."+chr(10)+chr(13)
				cTEXTO += "Ou as datas de vencimento informadas no documento estão fora do prazo mínimo aceito pelo financeiro."+chr(10)+chr(13)
				cTEXTO += cValToChar(nMVNDPJV)+" dias para pedidos com parcelas já vencidas."+chr(10)+chr(13)
				cTEXTO += cValToChar(nMVNDPAV)+" dias para pedidos com parcelas não vencidas."
				Aviso("Aviso", cTEXTO, {"OK"}, 3)			
				lRet := .F.
				
			ElseIf ! lRetVAL .and. ! __lValidPED 
						
				If Len(aFLUXO) > 0 
					
					cTEXTO := "Não é possível inserir o documento de entrada, pois os itens relacionados abaixo possuem o campo Fluxo Caixa = NÃO "
					cTEXTO += "no pedido de compras e estão sendo utilizados com TES que gera financeiro! "+chr(10)+chr(13)
					For nI := 1 to Len(aFLUXO)
						cTEXTO += "Número pedido: "+aFLUXO[nI,01]+" - Item pedido: "+aFLUXO[nI,02]+" - Produto: "+aFLUXO[nI,03]+chr(10)+chr(13)
					Next nI
					Aviso("Atenção", cTEXTO, {"OK"}, 3)
					nRet := 2	
					
				Else
				
					If ! FVALTOL()
						nRet := Aviso("Aviso", 	"Os valores informados no documento são diferentes dos informados no pedido."+chr(13)+chr(10)+;
												"Deseja utilizar liberação do superior?", {"Sim", "Não"}, 2) 
					Else
						nRet := 3
					EndIf
					
				EndIf
				
				If nRet == 1
					If fLogSUP()
						lRet := .T.
					Else
						lRet := .F.
					EndIf
				ElseIf nRet == 2			
					lRet := .F. 
				Else
					lRet := .T. 
				EndIf
				
			Else 
	
				If Len(aFLUXO) > 0 
					cTEXTO := "Não é possível inserir o documento de entrada, pois os itens relacionados abaixo possuem o campo Fluxo Caixa = NÃO "
					cTEXTO += "no pedido de compras e estão sendo utilizados com TES que gera financeiro! "+chr(10)+chr(13)
					For nI := 1 to Len(aFLUXO)
						cTEXTO += "Número pedido: "+aFLUXO[nI,01]+" - Item pedido: "+aFLUXO[nI,02]+" - Produto: "+aFLUXO[nI,03]+chr(10)+chr(13)
					Next nI
					Aviso("Atenção", cTEXTO, {"OK"}, 3)
					lRet := .F.
				Else				
					lRet := .T.			
				EndIf
				
			EndIf 
		EndIf //Guilherme 12/05/14 - Fim
	Else
                   
		If Len(aFLUXO) > 0 
			cTEXTO := "Não é possível inserir o documento de entrada, pois os itens relacionados abaixo possuem o campo Fluxo Caixa = NÃO "
			cTEXTO += "no pedido de compras e estão sendo utilizados com TES que gera financeiro! "+chr(10)+chr(13)
			For nI := 1 to Len(aFLUXO)
				cTEXTO += "Número pedido: "+aFLUXO[nI,01]+" - Item pedido: "+aFLUXO[nI,02]+" - Produto: "+aFLUXO[nI,03]+chr(10)+chr(13)
			Next nI
			Aviso("Atenção", cTEXTO, {"OK"}, 3)
			lRet := .F.
		EndIf	
	
	EndIf		

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLogSUP    ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Janela de login do superior, autorizando inclusão do pedido º±±
±±º          ³de compras.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------*
Static Function fLogSUP()
*----------------------------------------*
Local lRet := .T.
Private cUSRSUP := Space(15)
Private cPASSUP := Space(15)
Private nOpcao  := 0
Private oDlgPASS

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Janela de autorização                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DEFINE MSDIALOG oDlgPASS FROM 000,000 TO 160,200 TITLE "Autorização de inclusão"  OF oDlgPASS PIXEL
	@ 005, 005 TO 050, 095 OF oDlgPASS  PIXEL 
	@ 013,010 SAY "Usuário:" OF oDlgPASS PIXEL
	@ 012,040 GET cUSRSUP  SIZE 050,10 WHEN .T. VALID (!Vazio()) OF oDlgPASS PIXEL
	@ 028,010 SAY "Senha:" OF oDlgPASS PIXEL
	@ 027,040 GET cPASSUP  SIZE 050,10 WHEN .T. PASSWORD VALID (!Vazio()) OF oDlgPASS PIXEL
				
	DEFINE SBUTTON FROM 060, 040 TYPE 1 ACTION ( fValPass(cUSRSUP, cPASSUP, @nOpcao) )  ENABLE OF oDlgPASS PIXEL
	DEFINE SBUTTON FROM 060, 070 TYPE 2 ACTION (oDlgPASS:End()) ENABLE OF oDlgPASS PIXEL
	
	ACTIVATE MSDIALOG oDlgPASS CENTERED
	
	If nOpcao == 0
		lRet := .F.
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fValPass   ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação de usuário/senha do superior.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------*
Static Function fValPass(cUSRSUP, cPASSUP, nOpcao)
*-------------------------------------------------*
Local lRet	:= .T.
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o usuario digitado tem permissao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !(AllTrim(cUSRSUP)$AllTrim(SuperGetMV("MV_X_USPDC",,"N")))
		Aviso("Aviso", "Este usuário não foi definido como superior.", {"OK"}, 2)
		lRet:=.F.
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa no arquivo de senhas o usuario e valida a senha digitada       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lRet
		PswOrder(2)
		PswSeek(cUSRSUP,.T.)
		If !PswName(cPASSUP)
			HELP("",1,"INVSENHA")
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		nOpcao := 1
		oDlgPASS:End()
		__cUserLibP := cUSRSUP
		__lValidPED := .T.
	EndIf
	         
	
Return (lRet)

/* GUSTAVO 29/06/2016 - ESSE PONTO DE ENTRADA NÃO É MAIS NECESSÁRIO
// Ponto de entrada para obter os vencimentos confome o pedido de compra
User Function A103CND2()
Local aLocArea := GetArea() 
Local aDupl    := ParamIXB
Local aFLUXO   := {}
Local aPEDIDOS := {} 
Local aCLVALOR := {}
Local nPCODPRD := aScan(aHeader, { |x| x[2] = "D1_COD"})
Local nPCODTES := aScan(aHeader, { |x| x[2] = "D1_TES"})
Local nPOSCLVL := aScan(aHeader, { |x| x[2] = "D1_CLVL"})
Local nPOSPED  := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local nPITEPED := aScan(aHeader, { |x| x[2] = "D1_ITEMPC"})
Local cCLVLMUP := ALLTRIM(SuperGetMV("MV_X_CLERE",,""))
Local lLocRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
	If Len(aCols) > 0
		For nI := 1 to Len(aCols)
			If !Empty(aCols[nI][nPosPED])
				If Len(aPEDIDOS) == 0
					nPOS := 0
				Else
					nPOS := aScan ( aPEDIDOS, {|x| x[1] == aCols[nI][nPosPED] } )
				EndIf                               
				If nPOS == 0
					aAdd ( aPEDIDOS, { aCols[nI][nPosPED] } )
				EndIf
				If Len(aCLVALOR) == 0
					nPOS := 0
				Else
					nPOS := aScan ( aCLVALOR, {|x| x[1] == aCols[nI][nPosCLVL] } )
				EndIf                               
				If nPOS == 0
					aAdd ( aCLVALOR, { aCols[nI][nPosCLVL] } )
				EndIf
                    
				//-- Verifica se o item foi incluído no pedido com C7_FLUXO = "N" e utiliza TES com F4_DUPLIC = "S".					
				If ! Empty(aCols[nI][nPosPED]) .and. ! Empty(aCols[nI][nPITEPED])
					
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("SC7") + aCols[nI][nPosPED] + aCols[nI][nPITEPED] )
						If SC7->C7_FLUXO == "N"
							If Posicione("SF4",1,xFilial("SF4")+aCols[nI][nPCODTES],"F4_DUPLIC") == "S"
								aAdd ( aFLUXO, { aCols[nI][nPosPED], aCols[nI][nPITEPED], aCols[nI][nPCODPRD] } )
							EndIf	
						EndIf
					EndIf					
				EndIf
						
			EndIf
		Next nI
	EndIf
	If Len(aPEDIDOS) > 0
		// Multiplos pedidos somente para compras do segmento de transportes //
		If Len(aPEDIDOS) > 1 .and. Len(aCLVALOR) > 0
			For nA := 1 to Len(aCLVALOR)
				If ! aCLVALOR[nA,01] $ cCLVLMUP
					lLocRet := .F.
					Exit
				EndIf
			Next nA
			If !lLocRet
				Aviso("Atenção","Somente poderá ser utilizado mais que um pedido para inclusão do documento de entrada para o(s) seguinte(s) segmento(s): "+cCLVLMUP,{"OK"},2)
			EndIf
		EndIf
		If lLocRet			
			// verifica as parcelas
			If Len(aPEDIDOS) > 0
				aDADOS := {}
				For nX := 1 to Len(aPEDIDOS)
					dbSelectArea("Z11")          
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("Z11") + aPEDIDOS[nX,01] )
						While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + aPEDIDOS[nX,01]		
							If Len(aDADOS) == 0
								nPOS := 0
							Else
								nPOS := aScan ( aDADOS, {|x| x[1] == Z11->Z11_VENCTO } )
							EndIf        
							If nPOS == 0
								aAdd (aDADOS, { Z11->Z11_VENCTO, Z11->Z11_VALOR } )
							Else
								aDADOS[nPOS,02] += Z11->Z11_VALOR
							EndIf
							Z11->(dbSkip())		
						Enddo
					EndIf
				Next nX
			EndIf
					
			If Len(aDADOS) > 0
				For nI := 1 to Len(aDADOS) 
					// Flavio - 29/01/2011 - alterado para que quando o valor estiver zerado nao validar a data, 
					// nos casos em que é digitado bonificação e a data de emissao fica bloqueada
					nPOS := aScan ( aDupl, {|x| x[1] == aDADOS[nI][01] } )
					If nPOS == 0
						if MsgYesNo("Datas de vencimento inconforme com o pedido. Corrigir?")
						  // seta a data conforme pedido
						  if (Len(aDupl) < nI)
						  	aAdd(aDupl, aClone(aDupl[Len(aDupl)]))
						  	aDupl[nI][02] := aDADOS[nI][02] // seta o valor, caso não exista parcelas suficientes
						  EndIf
							aDupl[nI][01] := aDADOS[nI][01] // seta a data
						else
							lRetDAT := .F.
							Exit
						endif
					EndIf
				Next nI
			EndIf
			
		EndIf
	EndIf
EndIf
     
RestArea(aLocArea)
Return aDupl     
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FVALTOL    ºAutor  ³Rafael Parma       º Data ³  14/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação de cadastro sobre rotina de tolerânciaº±±
±±º          ³de recebimento.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------*
Static Function FVALTOL()
*-------------------------------------------------*
Local lRet := .F.
Local lExist := .F.
Local nPCODPRD := aScan(aHeader, { |x| x[2] = "D1_COD"})
Local nPCODGRP := aScan(aHeader, { |x| x[2] = "D1_GRUPO"})
Local nPITEVLR := aScan(aHeader, { |x| x[2] = "D1_VUNIT"})
Local nPITEQTD := aScan(aHeader, { |x| x[2] = "D1_QUANT"})
Local nPOSNPED := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local nPITEPED := aScan(aHeader, { |x| x[2] = "D1_ITEMPC"})


	If Len(aCols) > 0
		For nI := 1 to Len(aCols)
			//--Tolerancia de recebimento
			dbSelectArea("AIC")
			dbSetOrder(2)	//--AIC_FILIAL+AIC_FORNEC+AIC_LOJA+AIC_PRODUT+AIC_GRUPO
			dbGoTop()
			If dbSeek(xFilial("AIC")+CA100FOR+CLOJA)
				While !AIC->(EOF()) .AND. AIC->(AIC_FILIAL+AIC_FORNEC+AIC_LOJA) == xFilial("AIC")+CA100FOR+CLOJA
					If AIC->AIC_PRODUT == aCols[nI,nPCODPRD] .OR. ( Empty(AIC->AIC_PRODUT) .AND. AIC->AIC_GRUPO == aCols[nI,nPCODGRP] )
						lExist := .T.
						//--Percentual de quantidade
						If AIC->AIC_PQTDE > 0
							dbSelectArea("SC7")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( xFilial("SC7") + aCols[nI][nPOSNPED] + aCols[nI][nPITEPED] )
								If aCols[nI,nPITEQTD] > SC7->C7_QUANT
									nPERQTD := Round ( ( (aCols[nI,nPITEQTD] * 100)/SC7->C7_QUANT ) - 100, 2)									
									If nPERQTD <= AIC->AIC_PQTDE
										lRet := .T.
										Exit
									EndIf
								EndIf							
							EndIf						
						EndIf
						//--Percentual de preço						
						If AIC->AIC_PPRECO > 0
							dbSelectArea("SC7")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( xFilial("SC7") + aCols[nI][nPOSNPED] + aCols[nI][nPITEPED] )
								If aCols[nI,nPITEVLR] > SC7->C7_PRECO
									nPERVLR := Round ( ( (aCols[nI,nPITEVLR] * 100)/SC7->C7_PRECO ) - 100, 2)
									If nPERVLR <= AIC->AIC_PPRECO
										lRet := .T.
										Exit
									EndIf
								EndIf															
							EndIf
						EndIf    
						
					EndIf
					AIC->(dbSkip())
				Enddo			
			EndIf
		Next nI
		
	EndIf
	
	If lExist .and. !lRet
		Aviso("Aviso","Quantidades/valores dos itens do documento não estão dentro do nível de tolerância cadastrado para o fornecedor.",{"OK"})
	EndIf

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckVCTO ºAutor  ³Rafael Parma       º Data ³  24/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação das datas de vencimento das parcelas  º±±
±±º          ³quando documento de entrada não possuir pedido de venda.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCheckVCTO(aLocCols)
Local lRet := .T.
Local nMVNDDJV := SuperGetMV("MV_X_NDDJV",,7)		//--Margem mínima com o número de dias para documentos de entrada sem pedido e parcelas a vencer a partir da data atual.

	If Len(aLocCols) > 0
		For nI := 1 to Len(aLocCols)
			If aLocCols[nI][03] > 0
				If aLocCols[nI][02] <= (date()+nMVNDDJV)
					lRet := .F.
					Exit
				EndIf
			EndIf
		Next nI		    
	EndIf              
	
	If ! lRet 
		cTEXTO := "As datas de vencimento informadas no documento estão fora do prazo mínimo aceito pelo financeiro."+chr(10)+chr(13)
		cTEXTO += cValToChar(nMVNDDJV)+" dias para documento sem pedido de compras."+chr(10)+chr(13)
		cTEXTO += "Deseja utilizar liberação do superior?"
		nRet := Aviso("Aviso", cTEXTO, {"Sim", "Não"}, 2) 
		If nRet == 1
			lRet := fLogSUP()
		EndIf	
	EndIf
			
Return (lRet)  

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckIrrf ºAutor  ³Guilherme Poyer    º Data ³  26/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação da retenção de IRRF quando tiver      º±±
±±º          ³obrigado o usuário colocar GERA DIRF = SIM e código de Ret. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCheckIrrf() 
Local lRet 		:= .T.
Local cNat	 	:= MaFisRet(,"NF_NATUREZA")
Local nValIr    := 0

For i:=1 to Len(PARAMIXB[2])
	if PARAMIXB[2][i][4] > 0
		nValIr += PARAMIXB[2][i][4] 	
	EndIf	
Next i

// Verifica se Valor do IR está preenchido para dar continuidade */
If nValIr > 0
	If !Empty(Alltrim(cNat))
		DbselectArea("SED")
		DbsetOrder(1)
		IF DbSeek(xFilial("SED")+Alltrim(cNat))
			If (SED->ED_CALCIRF == 'S') .AND. (cDirf <> '1')
				Aviso("Atenção","Nota com Retenção de IRRF, é necessário informar GERA DIRF=SIM na Aba IMPOSTOS!",{"OK"},2)
				lRet:=.F.
			Else 
				If SED->ED_CALCIRF <> 'S'
					nRet:= Aviso("Aviso","Natureza "+Alltrim(cNat)+" não caltula IRRF, mas existe valor do imposto na nota,deseja continuar?",{"Sim","Não"},2)
					If nRet == 2
						lRet:=.F. 		
					EndIf		
				EndIf                                                                                                                           			
			EndIf
		Else
			MSgInfo("Natureza "+Alltrim(cNat)+" não encontrada!") 
			lRet := .F.
		EndIf 
		SED->(DbCloseArea())			
	EndIf
EndIf
		
Return(lRet)