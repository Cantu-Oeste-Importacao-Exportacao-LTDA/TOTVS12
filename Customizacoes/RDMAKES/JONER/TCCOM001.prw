#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �TCCOM001  �Autor  �Marcelo Joner        � Data � 04/04/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de estorno de    ���
���          �classifica��o e classifica��o autom�tica de documento de en-���
���          �trada o qual n�o gerou financeiro.                          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Totvs Cascavel                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//����������������������������������������������������������
//�Executa demais regras apenas para notas do tipo N-Normal�
//���������������������������������������������������������
If SF1->F1_TIPO == "N"
	
	//�������������������������������������������������������
	//�Verifica se existem itens com TES que gera financeiro�
	//�������������������������������������������������������
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
		
		//�������������������������������������������������������������������������������
		//�Havendo itens que geram financeiro, verifica se existe SE2 para � nota fiscal�
		//�������������������������������������������������������������������������������
		If lGeraSE2
			dbSelectArea("SE2")
			SE2->(dbSetOrder(6))
			SE2->(dbGoTop())
			If SE2->(dbSeek(xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC))
				lExecuta := .F.
				
				//���������������������������������������������������������������������������������������
				//�Caso � reclassifica��o ajustou o financeiro, encaminha workflow informando � respeito�
				//���������������������������������������������������������������������������������������
				If Type("__nExeClas") == "N"
					If __nExeClas > 0
						COM001WF("DOCUMENTO DE ENTRADA RECLASSIFICADO AUTOMATICAMENTE - FUNCAO U_TCCOM001()", "DOCUMENTO DE ENTRADA - CLASSIFICADO E COM FINANCEIRO GERADO")
					EndIf
				EndIf
				
				Public __nExeClas := Nil
			Else
				lExecuta := .T.
				
				//����������������������������������������������������������������������������������������������������������������������
				//�Cria variavel publica para controle do n�mero de execu��es de reclassifica��o autom�tica para o documento de entrada�
				//����������������������������������������������������������������������������������������������������������������������
				If Type("__nExeClas") != "N"
					Public __nExeClas := 1
				Else
					__nExeClas++
				EndIf
			EndIf
		EndIf
	EndIf
	
	//�����������������������������������������������������������������������������������������������
	//�Havendo inconsist�ncias no Financeiro, tenta estornar � classifica��o e classificar novamente�
	//�����������������������������������������������������������������������������������������������
	If lExecuta
		
		//�����������������������������������������������������������
		//�Efetua o estorno da classifica��o do Documento de Entrada�
		//�����������������������������������������������������������
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		SD1->(dbGoTop())
		If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
			While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA .AND. SD1->D1_TIPO == SF1->F1_TIPO
				
				//������������������������������������������������������������������
				//�Salva o TES utilizado atualmente no item do Documento de Entrada�
				//������������������������������������������������������������������
				AADD(aDetTES, {SD1->D1_ITEM, SD1->D1_TES})
				
				//�����������������������������������������������������������������������
				//�Adiciona o item do Documento de Entrada para estorno da classifica��o�
				//�����������������������������������������������������������������������
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
			
			//����������������������������������������������������������
			//�Prepara array do cabe�alho para estorno da classifica��o�
			//����������������������������������������������������������
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
			  
			//���������������������������������������������������������
			//�Caso ocorreu erro, alerta o usu�rio e aborta o processo�
			//���������������������������������������������������������
			If lMsErroAuto 
				ShowHelpDlg("Aten��o", {"Este documento de entrada n�o gerou t�tulos � pagar. N�o foi poss�vel realizar o estorno de classifica��o do mesmo de forma autom�tica."}, 5, {"Por favor, efetue � exclus�o desta nota fiscal e inclua novamente."}, 5)
				MOSTRAERRO()
			Else 
				
				//������������������������������������������������������������������������������������
				//�Caso j� reclassificou mais de tr�s vezes e n�o gerou financeiro, aborta o processo�
				//������������������������������������������������������������������������������������
				If __nExeClas > 3
					Public __nExeClas := Nil
					
					//���������������������������������������������������������������������������������������������
					//�N�o havendo sucesso na reclassifica��o autom�tica, encaminha workflow informando � respeito�
					//���������������������������������������������������������������������������������������������
					COM001WF("DOCUMENTO DE ENTRADA RECLASSIFICADO AUTOMATICAMENTE E COM PROBLEMAS NA GERACAO DO FINANCEIRO - FUNCAO U_TCCOM001()", "DOCUMENTO DE ENTRADA - A CLASSIFICAR")
					
					ShowHelpDlg("Aten��o", {"Este documento de entrada n�o gerou t�tulos � pagar. N�o foi poss�vel realizar � reclassifica��o do mesmo de forma autom�tica."}, 5, {"Por favor, efetue � classifica��o manual desta nota fiscal de entrada."}, 5)
					Return
				Else
					
					//������������������������������������������������������������������������������������������
					//�Ap�s estornar � classifica��o, classifica novamente utilizando os TES que estavam salvos�
					//������������������������������������������������������������������������������������������
					aLinha := {}
					aCabSF1:= {}
					
					dbSelectArea("SD1")
					SD1->(dbSetOrder(1))
					SD1->(dbGoTop())
					If SD1->(dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
						While SD1->(!EOF()) .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE .AND. SD1->D1_FORNECE == SF1->F1_FORNECE .AND. SD1->D1_LOJA == SF1->F1_LOJA .AND. SD1->D1_TIPO == SF1->F1_TIPO
							
							//���������������������������������������������������������������������������������
							//�Efetua busca do TES utilizado anteriormente para o item do Documento de Entrada�
							//���������������������������������������������������������������������������������
							cCodTES := ""
							For nI := 1 To Len(aDetTES)
								If aDetTES[nI][1] == SD1->D1_ITEM
									cCodTES := aDetTES[nI][2]
									exit
								EndIf
							Next nI
							
							//�����������������������������������������������������������������������
							//�Adiciona o item do Documento de Entrada para estorno da classifica��o�
							//�����������������������������������������������������������������������
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
						
						//���������������������������������������������
						//�Composi��o do cabe�alho do Documento Fiscal�
						//���������������������������������������������
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
						
						//������������������������������������������
						//�Prepara fun��es de calculo fiscal do ERP�
						//������������������������������������������
						If MaFisFound()
							MaFisEnd()
						EndIf
						
						//���������������������������������������������������
						//�Execua fun��o autom�tica de inclus�o do documento�
						//���������������������������������������������������	      
						MATA103(aCabSF1, aLinha, 4, .F.)
						
						//��������������������������������������������������������������������������������
						//�Caso ocorreu erro na rotina autom�tica, alerta o usu�rio e aborta a efetiva��o�
						//��������������������������������������������������������������������������������
						If lMsErroAuto
							ShowHelpDlg("Aten��o", {"Este documento de entrada n�o gerou t�tulos � pagar. N�o foi poss�vel reclassificar o mesmo de forma autom�tica."}, 5, {"Por favor, efetue � exclus�o desta nota fiscal e inclua novamente."}, 5)
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �COM001WF  �Autor  �Marcelo Joner        � Data � 04/04/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pelo envio de workflow quando ocorreu in-���
���          �consist�ncia na inclus�o de Documento de Entrada em rela��o ���
���          �ao financeiro do mesmo.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Totvs Cascavel                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function COM001WF(cDetObs, cDetSit)

Local cStatus 	:= SPACE(6)
Local cEmails		:= "suporte@cantu.com.br;cleidisson.draszewski@cantu.com.br;"
Local cAssunto	:= "DOCUMENTO ENTRADA X FINANCEIRO - FILIAL " + cFilAnt + " " + ALLTRIM(UPPER(FWFilialName()))

Default cDetObs	:= ""
Default cDetSit	:= ""

//�������������������������������������������������������������
//�Executa regras caso exista observa��o e situa��o informados�
//�������������������������������������������������������������
If !EMPTY(cDetObs) .AND. !EMPTY(cDetSit)

	//�������������������������������������
	//�Monta o objeto de envio do workflow�
	//�������������������������������������
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\nf_sem_financeiro.htm")
	oProcess:cSubject := cAssunto
	oProcess:cTo  := cEmails
	                        
	//�������������������������������
	//�Monta o cabe�alho do workflow�
	//�������������������������������
	oHtml:= oProcess:oHTML
	oHtml:ValByName("FILIAL"		, cFilAnt + " - " + ALLTRIM(UPPER(FWFilialName()))) 
	oHtml:ValByName("EMISSAO"	, DTOC(dDataBase)) 
	oHtml:ValByName("DOCUMENTO"	, ALLTRIM(SF1->F1_DOC) + "\" + ALLTRIM(SF1->F1_SERIE))
	oHtml:ValByName("FORNECEDOR", ALLTRIM(SA2->A2_COD) + "\" + ALLTRIM(SA2->A2_LOJA) + "-" + ALLTRIM(SA2->A2_NOME))
	oHtml:ValByName("OBSERVACAO", ALLTRIM(cDetObs))
	oHtml:ValByName("STATUS"		, ALLTRIM(cDetSit))
	
	//������������������
	//�Envia o workflow�
	//������������������
	oProcess:Start()
EndIf

Return