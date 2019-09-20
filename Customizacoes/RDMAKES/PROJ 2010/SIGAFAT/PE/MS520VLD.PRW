/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MS520VLD  ºAutor  ³Joel Lipnharski     º Data ³  04/20/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE que ativa lançamento do PCO para EXCLUSAO de Nota Fiscal º±±
±±º          ³ref. Devolução de Compras se a Nota de Entrada c/Rat.CC     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MS520VLD()

Local aAreaSF2 := SF2->( GetArea() )
Local aAreaSD2 := SD2->( GetArea() )
Local aAreaSD1 := SD1->( GetArea() )
Local aAreaSDE := SDE->( GetArea() )
Local lOk := .T.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If SF2->F2_TIPO == 'D'
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbGoTop()
	If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
		While !SD2->(EOF()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA==xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbGoTop()
			If DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
				If SD1->D1_RATEIO == '1'
					DbSelectArea("SDE")
					DbSetOrder(1)
					DbGoTop()
					If Dbseek(xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
						PCOINILAN("999003")
						While !SDE->(EOF()) .AND. SDE->DE_FILIAL+SDE->DE_DOC+SDE->DE_SERIE+SDE->DE_FORNECE+SDE->DE_LOJA+SDE->DE_ITEMNF==xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM
							Begin Transaction
							PCODETLAN("999003","01","MS520VLD")
							End Transaction
							SDE->( dbSkip() )
						EndDo
						PCOFINLAN("999003")
					EndIf
				EndIf
			EndIf
			DbSelectArea("SD2")
			SD2->( dbSkip() )
		EndDo
	EndIf
EndIf


          
RestArea(aAreaSF2)
RestArea(aAreaSD2)
RestArea(aAreaSD1)
RestArea(aAreaSDE)
                    
// Flavio - controle de fretes na exclusão da NF
// lOk := ValFreteExc() Adriano, permitir excluir nota fiscal (Abaixo existe a validação propria da Cantu) Conforme e-mail do dia 17-07-12

if (lOk)    
	If FindFunction("U_ValidExNF")
		lOk := U_ValidExNF(SF2->F2_ESPECIE, SF2->F2_SERIE+SF2->F2_DOC)
	EndIf
EndIf

Return lOk

/*****************************************************************
Valida a exclusão da NF, não permitindo excluir caso 
haja uma carga amarrada com a mesma
*****************************************************************/
Static Function ValFreteExc()
Local lOk := .T.
Local _cPed	:= ""
ZZS->(dbSetOrder(5))
DbSelectArea("SD2")
DbSetOrder(3)
DbGoTop()
If DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	While !SD2->(EOF()) .AND. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA ==;
	                          SF2->F2_FILIAL+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA .AND. lOk
		if ZZS->(dbSeek(xFilial("ZZS") + cEmpAnt + cFilAnt + SD2->D2_PEDIDO))
			If !AllTrim(SD2->D2_PEDIDO) $ _cPed
				SA4->(dbSetOrder(1)) 
				SA4->(dbSeek(xFilial("SA4")+ZZS->ZZS_CODTRA))
				cCgcFor := SA4->A4_CGC		
	
				SA2->(dbSetOrder(3))
				SA2->(dbSeek(xFilial("SA2")+cCgcFor))			
				lOk := lOk .And. U_ValNFSFrt(SF2->F2_DOC,SF2->F2_PREFIXO,SA2->A2_COD,SA2->A2_LOJA)
				If lOk 
					RecLock("ZZS", .F.)
						ZZS->(DbDelete())
				  	ZZS->(MsUnlock())
				Endif
				_cPed	+= AllTrim(SD2->D2_PEDIDO)+"/"
			Endif
		EndIf
		SD2->(DbSkip())
	EndDo
EndIf
Return lOk
