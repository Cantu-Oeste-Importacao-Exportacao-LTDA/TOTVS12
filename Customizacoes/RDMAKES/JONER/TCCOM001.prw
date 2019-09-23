#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TCCOM001  ºAutor  ³Marcelo Joner        º Data ³ 04/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela execução de regras de estorno de    º±±
±±º          ³classificação e classificação automática de documento de en-º±±
±±º          ³trada o qual não gerou financeiro.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Totvs Cascavel                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function TCCOM001()

Local aArea			:= GetArea()
Local aLinha			:= {}
Local aCabSF1			:= {}
Local aIteSD1			:= {}
Local aDetTES			:= {}
Local lGeraSE2		:= .F.
Local lExecuta		:= .F.

Private lMsErroAuto	:= .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa demais regras apenas para notas do tipo N-Normal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If SF1->F1_TIPO == "N"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica se existem itens com TES que gera financeiro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	dbSelectArea("SD1")
	SD1->(dbSetOrder(1))
	SD1->(dbGoTop())
	If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA .AND. SD1->D1_TIPO == SF1->F1_TIPO
			dbSelectArea("SF4")
			SF4->(dbSetOrder(1))
			SF4->(dbGoTop())
			If SF4->(dbSeek(xFilial("SF4") + SD1->D1_TES))
				If SF4->F4_DUPLIC == "S"
					lGeraSE2 := .T.
					exit
				EndIf
			EndIf
			
			SD1->(dbSkip())
		End
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Havendo itens que geram financeiro, verifica se existe SE2 para à nota fiscal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If lGeraSE2
			dbSelectArea("SE2")
			SE2->(dbSetOrder(6))
			SE2->(dbGoTop())
			If SE2->(dbSeek(xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))
				lExecuta := .F.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso à reclassificação ajustou o financeiro, encaminha workflow informando à respeito³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If Type("__nExeClas") == "N"
					If __nExeClas > 0
						COM001WF("DOCUMENTO DE ENTRADA RECLASSIFICADO AUTOMATICAMENTE - FUNCAO U_TCCOM001()", "DOCUMENTO DE ENTRADA - CLASSIFICADO E COM FINANCEIRO GERADO")
					EndIf
				EndIf
				
				Public __nExeClas := Nil
			Else
				lExecuta := .T.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Cria variavel publica para controle do número de execuções de reclassificação automática para o documento de entrada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If Type("__nExeClas") != "N"
					Public __nExeClas := 1
				Else
					__nExeClas++
				EndIf
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Havendo inconsistências no Financeiro, tenta estornar à classificação e classificar novamente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If lExecuta
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Efetua o estorno da classificação do Documento de Entrada³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		SD1->(dbGoTop())
		If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA .AND. SD1->D1_TIPO == SF1->F1_TIPO
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Salva o TES utilizado atualmente no item do Documento de Entrada³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				AADD(aDetTES, {SD1->D1_ITEM, SD1->D1_TES})
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Adiciona o item do Documento de Entrada para estorno da classificação³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				aIteSD1 := {}
				AADD(aIteSD1, {"D1_ITEM"		, SD1->D1_ITEM	, NIL})
				AADD(aIteSD1, {"D1_COD"		, SD1->D1_COD		, NIL})
				AADD(aIteSD1, {"D1_QUANT"	, SD1->D1_QUANT	, NIL})
				AADD(aIteSD1, {"D1_VUNIT"	, SD1->D1_VUNIT	, NIL})
				AADD(aIteSD1, {"D1_TOTAL"	, SD1->D1_TOTAL	, NIL})
				AADD(aIteSD1, {"D1_TES"		, SD1->D1_TES		, NIL})
				
				AADD(aLinha, aIteSD1)
				
				SD1->(dbSkip())
			End
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Prepara array do cabeçalho para estorno da classificação³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			AADD(aCabSF1, {"F1_TIPO"		, SF1->F1_TIPO	, NIL})
			AADD(aCabSF1, {"F1_FORMUL"	, SF1->F1_FORMUL	, NIL})
			AADD(aCabSF1, {"F1_DOC"		, SF1->F1_DOC		, NIL})
			AADD(aCabSF1, {"F1_SERIE"	, SF1->F1_SERIE	, NIL})
			AADD(aCabSF1, {"F1_EMISSAO"	, SF1->F1_EMISSAO	, NIL})
			AADD(aCabSF1, {"F1_FORNECE"	, SF1->F1_FORNECE	, NIL})
			AADD(aCabSF1, {"F1_LOJA"		, SF1->F1_LOJA	, NIL})
			AADD(aCabSF1, {"F1_ESPECIE"	, SF1->F1_ESPECIE	, NIL})
			AADD(aCabSF1, {"F1_COND"		, SF1->F1_COND	, NIL})
			AADD(aCabSF1, {"F1_STATUS"	, SF1->F1_STATUS	, NIL})
			
			MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabSF1, aLinha, 7,, 0)
			  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Caso ocorreu erro, alerta o usuário e aborta o processo³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If lMsErroAuto 
				ShowHelpDlg("Atenção", {"Este documento de entrada não gerou títulos à pagar. Não foi possível realizar o estorno de classificação do mesmo de forma automática."}, 5, {"Por favor, efetue à exclusão desta nota fiscal e inclua novamente."}, 5)
				MOSTRAERRO()
			Else 
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Caso já reclassificou mais de três vezes e não gerou financeiro, aborta o processo³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				If __nExeClas > 3
					Public __nExeClas := Nil
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Não havendo sucesso na reclassificação automática, encaminha workflow informando à respeito³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					COM001WF("DOCUMENTO DE ENTRADA RECLASSIFICADO AUTOMATICAMENTE E COM PROBLEMAS NA GERACAO DO FINANCEIRO - FUNCAO U_TCCOM001()", "DOCUMENTO DE ENTRADA - A CLASSIFICAR")
					
					ShowHelpDlg("Atenção", {"Este documento de entrada não gerou títulos à pagar. Não foi possível realizar à reclassificação do mesmo de forma automática."}, 5, {"Por favor, efetue à classificação manual desta nota fiscal de entrada."}, 5)
					Return
				Else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Após estornar à classificação, classifica novamente utilizando os TES que estavam salvos³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					aLinha := {}
					aCabSF1:= {}
					
					dbSelectArea("SD1")
					SD1->(dbSetOrder(1))
					SD1->(dbGoTop())
					If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
						While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA .AND. SD1->D1_TIPO == SF1->F1_TIPO
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Efetua busca do TES utilizado anteriormente para o item do Documento de Entrada³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							cCodTES := ""
							For nI := 1 To Len(aDetTES)
								If aDetTES[nI][1] == SD1->D1_ITEM
									cCodTES := aDetTES[nI][2]
									exit
								EndIf
							Next nI
							
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Adiciona o item do Documento de Entrada para estorno da classificação³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							aIteSD1 := {}
							dbSelectArea("SX3")
							SX3->(dbSetOrder(1))
							SX3->(dbSeek("SD1"))   
							While SX3->(!EOF()) .AND. SX3->X3_ARQUIVO == "SD1"
								If X3Uso(SX3->X3_USADO) .AND. SX3->X3_CONTEXT != "V"
									If ALLTRIM(SX3->X3_CAMPO) == "D1_TES"
										AADD(aIteSD1, {ALLTRIM(SX3->X3_CAMPO), cCodTES, NIL})
									Else
										Do Case
											Case SX3->X3_TIPO == "C"
												If !EMPTY(&("SD1->" + ALLTRIM(SX3->X3_CAMPO)))
													AADD(aIteSD1, {ALLTRIM(SX3->X3_CAMPO), &("SD1->" + ALLTRIM(SX3->X3_CAMPO)), NIL})
												EndIf
											
											Case SX3->X3_TIPO == "N"
												If &("SD1->" + ALLTRIM(SX3->X3_CAMPO)) > 0
													AADD(aIteSD1, {ALLTRIM(SX3->X3_CAMPO), &("SD1->" + ALLTRIM(SX3->X3_CAMPO)), NIL})
												EndIf
											
											OtherWise
												AADD(aIteSD1, {ALLTRIM(SX3->X3_CAMPO), &("SD1->" + ALLTRIM(SX3->X3_CAMPO)), NIL})
										EndCase
									EndIf
								EndIf
								
								SX3->(dbSkip())
							End
							
							AADD(aLinha, aIteSD1)
							
							SD1->(dbSkip())
						End
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Composição do cabeçalho do Documento Fiscal³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						AADD(aCabSF1, {"F1_FORMUL"	, SF1->F1_FORMUL	, NIL})
						AADD(aCabSF1, {"F1_ESPECIE"	, SF1->F1_ESPECIE	, NIL})
						AADD(aCabSF1, {"F1_DOC"		, SF1->F1_DOC		, NIL})
						AADD(aCabSF1, {"F1_SERIE"	, SF1->F1_SERIE	, NIL})
						AADD(aCabSF1, {"F1_TIPO"		, SF1->F1_TIPO	, NIL})
						AADD(aCabSF1, {"F1_EMISSAO"	, SF1->F1_EMISSAO	, NIL})
						AADD(aCabSF1, {"F1_FORNECE"	, SF1->F1_FORNECE	, NIL})
						AADD(aCabSF1, {"F1_LOJA"		, SF1->F1_LOJA	, NIL})    
						AADD(aCabSF1, {"F1_FRETE"	, SF1->F1_FRETE	, NIL})
						AADD(aCabSF1, {"F1_SEGURO"	, SF1->F1_SEGURO	, NIL})
						AADD(aCabSF1, {"F1_DESPESA"	, SF1->F1_DESPESA	, NIL})  
						AADD(aCabSF1, {"F1_COND"		, SF1->F1_COND	, NIL})  
						AADD(aCabSF1, {"F1_TRANSP"	, SF1->F1_TRANSP	, NIL})
						AADD(aCabSF1, {"F1_PLACA"	, SF1->F1_PLACA	, NIL})
						AADD(aCabSF1, {"F1_PLIQUI"	, SF1->F1_PLIQUI	, NIL})
						AADD(aCabSF1, {"F1_PBRUTO"	, SF1->F1_PBRUTO	, NIL})
						AADD(aCabSF1, {"F1_VOLUME1"	, SF1->F1_VOLUME1	, NIL})
						AADD(aCabSF1, {"F1_ESPECI1"	, SF1->F1_ESPECI1	, NIL})
						AADD(aCabSF1, {"F1_TPFRETE"	, SF1->F1_TPFRETE	, NIL})
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Prepara funções de calculo fiscal do ERP³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If MaFisFound()
							MaFisEnd()
						EndIf
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Execua função automática de inclusão do documento³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ	      
						MATA103(aCabSF1, aLinha, 4, .F.)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						//³Caso ocorreu erro na rotina automática, alerta o usuário e aborta a efetivação³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
						If lMsErroAuto
							ShowHelpDlg("Atenção", {"Este documento de entrada não gerou títulos à pagar. Não foi possível reclassificar o mesmo de forma automática."}, 5, {"Por favor, efetue à exclusão desta nota fiscal e inclua novamente."}, 5)
							MOSTRAERRO()
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

RestArea(aArea)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³COM001WF  ºAutor  ³Marcelo Joner        º Data ³ 04/04/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pelo envio de workflow quando ocorreu in-º±±
±±º          ³consistência na inclusão de Documento de Entrada em relação º±±
±±º          ³ao financeiro do mesmo.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Totvs Cascavel                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function COM001WF(cDetObs, cDetSit)

Local cStatus 	:= SPACE(6)
Local cEmails		:= "suporte@cantu.com.br;cleidisson.draszewski@cantu.com.br;"
Local cAssunto	:= "DOCUMENTO ENTRADA X FINANCEIRO - FILIAL " + cFilAnt + " " + ALLTRIM(UPPER(FWFilialName()))

Default cDetObs	:= ""
Default cDetSit	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa regras caso exista observação e situação informados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If !EMPTY(cDetObs) .AND. !EMPTY(cDetSit)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\nf_sem_financeiro.htm")
	oProcess:cSubject := cAssunto
	oProcess:cTo  := cEmails
	                        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o cabeçalho do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oHtml:= oProcess:oHTML
	oHtml:ValByName("FILIAL"		, cFilAnt + " - " + ALLTRIM(UPPER(FWFilialName()))) 
	oHtml:ValByName("EMISSAO"	, DTOC(dDataBase)) 
	oHtml:ValByName("DOCUMENTO"	, ALLTRIM(SF1->F1_DOC) + "\" + ALLTRIM(SF1->F1_SERIE))
	oHtml:ValByName("FORNECEDOR", ALLTRIM(SA2->A2_COD) + "\" + ALLTRIM(SA2->A2_LOJA) + "-" + ALLTRIM(SA2->A2_NOME))
	oHtml:ValByName("OBSERVACAO", ALLTRIM(cDetObs))
	oHtml:ValByName("STATUS"		, ALLTRIM(cDetSit))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess:Start()
EndIf

Return