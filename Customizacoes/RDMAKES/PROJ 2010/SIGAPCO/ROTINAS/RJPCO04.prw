
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJPCO04   �Autor  �Joel Lipnharski     � Data �  04/20/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Lan�amentos de Integra��o FINA560 (Caixinha) com PCO        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RJPCO04(cOpc)

Local aArea   := GetArea() 
Local _Reg    := SEU->(Recno())

Private _cReturn := "" 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Do Case

	Case cOpc == "CO"
		If EMPTY(SEU->EU_NROADIA)
			RetCO(SEU->EU_CONTA)
		Else
			RetCO(POSICIONE("SEU",1,XFILIAL("SEU")+SEU->EU_NROADIA,"SEU->EU_CONTA"))
		EndIf

	Case cOpc == "CC"
		If EMPTY(SEU->EU_NROADIA)
			_cReturn := SEU->EU_CCD
		Else
			_cReturn := POSICIONE("SEU",1,XFILIAL("SEU")+SEU->EU_NROADIA,"SEU->EU_CCD")
		EndIf

	Case cOpc == "CLVL"
		If EMPTY(SEU->EU_NROADIA)
			_cReturn := SEU->EU_CLVLDB
		Else
			_cReturn := POSICIONE("SEU",1,XFILIAL("SEU")+SEU->EU_NROADIA,"SEU->EU_CLVLDB")
		EndIf
EndCase

dbSelectArea("SEU")
SEU->(dbGoto(_Reg))
RestArea(aArea)

Return(_cReturn)

/*BEGINDOC
//��������������������������������������������������������t�
//�Posiciona CT1 retornando Conta Orcamentaria cadastrada.�
//���������������������������������������������������������
ENDDOC*/

Static Function RetCO(_cVarAux)

DbSelectArea("CT1")
DbSetOrder(1)
DbSeek(xFilial("CT1")+Alltrim(_cVarAux))
	_cReturn := Alltrim(CT1->CT1_X_CO) 

Return()