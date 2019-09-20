#INCLUDE "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GPM030EX  �Autor  �Luiz Prado          � Data �  23/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada excluir movimento tabela Z26 caso a mesma ���
���          � tenha sido liberada atraves do calculo de ferias           ���
�������������������������������������������������������������������������͹��
���Uso       � P10 - Especifico GRUPO CANTU                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function GPM030EX() 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("Z26")
DbSetorder(4)
DbGotop()
If dbSeek(xFilial("Z26") + SRF->RF_MAT + DtoS(SRF->RF_DATABAS) )
	RecLock("Z26",.F.)
	Z26->Z26_LIBERA  := "N"
	Z26->Z26_USERLI := " "
	Z26->Z26_DTLIBER := CtoD("  /  /  ")
	Z26->Z26_OBS := "Efetuado exclusao calc ferias. Efetuado estorno da liberacao "
	Z26->(MSUnLock())
endif

Return
