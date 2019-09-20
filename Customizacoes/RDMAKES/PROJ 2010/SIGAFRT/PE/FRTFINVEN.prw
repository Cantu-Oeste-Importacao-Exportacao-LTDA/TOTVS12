#include "rwmake.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FRTFINVEN  �Autor  �Microsiga          � Data �  19/11/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada localizado ap�s a grava��o dos dados da    ���
���          �venda - FRONTLOJA. Atualiza��o do segmento sobre tabelas.   ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function FRTFINVEN()      
*-----------------------------*
Local aArea := GetArea()
Local cCODCLI   := SL1->L1_CLIENTE
Local cLOJCLI   := SL1->L1_LOJA
Local cVEND     := SL1->L1_VEND
Local aVendSEG  := {}       
Local bReturn   := .F.      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - FRTFINVEN - " + "INICIO")

	//���������������������������������������������������������������������������Ŀ
	//� Se habilitado par�metro para gravar campo segmento sobre vendas           �
	//�����������������������������������������������������������������������������	
	If ALLTRIM(SuperGetMV("MV_X_AVCVA",,"N")) == "S" 
	
		dbSelectArea("ZZ5")
		dbSetOrder(3)
		dbGoTop()
		If dbSeek ( xFilial("ZZ5") + cVEND + cCODCLI + cLOJCLI )
			While !ZZ5->(EOF()) .and. ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_VEND + ZZ5->ZZ5_CLIENT + ZZ5->ZZ5_LOJA == xFilial("ZZ5") + cVEND + cCODCLI + cLOJCLI
				aAdd(aVendSEG, { ZZ5->ZZ5_SEGMEN, Posicione("CTH", 01, xFilial("CTH") + ZZ5->ZZ5_SEGMEN, "CTH_DESC01") } )
				ZZ5->(dbSkip())                                             
			Enddo
		Else       
			
			//����������������������������������������������������������������������������Ŀ
			//� Se n�o existir relacionamento, utiliza segmento default da empresa/filial  �
			//������������������������������������������������������������������������������			
		    cCODCLVL := ALLTRIM(GetMV("MV_X_CLVLF"))
		    If cCODCLVL != ""
				aAdd(aVendSEG, { cCODCLVL } )
			EndIf
			
		EndIf

		//��������������������������������������������������Ŀ
		//� Atualiza segmento sobre tabela de vendas         �
		//����������������������������������������������������		

		If Len(aVendSEG) == 1
			If RecLock("SL1",.F.)
				SL1->L1_X_CLVL := aVendSeg[1,1]
				SL1->(MsUnLock())
			EndIf
		ElseIf Len(aVendSeg) > 1
			fViewSeLQ(aVendSEG)
		Else
			Alert("N�o ser� gravado o campo segmento para esta venda! Informar ao departamento de TI.")
		EndIf


		//��������������������������������������������������Ŀ
		//� Atualiza armaz�m sobre itens de vendas           �
		//����������������������������������������������������		
		dbSelectArea("Z22")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("Z22") + cVEND + SL1->L1_X_CLVL )
			dbSelectArea("SL2")              
			dbSetOrder(1)
			dbGoTop()
			dbSeek ( xFilial("SL2") + SL1->L1_NUM )
			While !SL2->(EOF()) .and. SL2->L2_FILIAL + SL2->L2_NUM == xFilial("SL2") + SL1->L1_NUM
				If RecLock("SL2",.F.)
					SL2->L2_LOCAL := Z22->Z22_ARMAZ			
					SL2->(MsUnLock())
				EndIf
				SL2->(dbSkip())
			EndDo   
		EndIf

	EndIf
	
	RestArea(aArea)

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - FRTFINVEN - " + "FIM")
			
Return({.T.,0})

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fViewSeLQ  �Autor  �Rafael Parma       � Data �  10/01/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Mostra um dialogo para selecionar os segmentos.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*----------------------------------------*
Static Function fViewSeLQ(aVendSEG)
*----------------------------------------*
Local aItens := {}
Local cOpcVend := "1"
Local oDlg1

	For nX := 1 to len(aVendSEG)
		aAdd(aItens, Str(nX, 1, 0) + "= (" + aVendSeg[nX, 1] + ") " + aVendSeg[nX, 2])
	Next nX
	
	@ 000,000 TO 115,330 DIALOG oDlg1 TITLE "Selecione o Segmento"
	@ 010,010 Say "(Segmento):"
	@ 020,010 COMBOBOX cOpcVend ITEMS aItens SIZE 140,50
	@ 035,070 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
	
	ACTIVATE DIALOG oDlg1 CENTER
	
	nX := Val(cOpcVend)
	If RecLock("SL1",.F.)
		SL1->L1_X_CLVL := aVendSeg[nX,1]
		SL1->(MsUnLock())
	EndIf

Return