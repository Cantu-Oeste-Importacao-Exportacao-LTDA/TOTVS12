#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS010END �Autor  �Rafael Parma         � Data �  15/03/2013 ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado ap�s a inclus�o/altera��o de registro na rotina���
���          �Tabela de pre�o (DA0).                                      ���
�������������������������������������������������������������������������͹��
���Uso       �CANTU                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------*
User Function OS010END()
*-------------------------* 
Local aAreaTMP := GetArea() 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
	
	//--Tratamento B2B Vertis
	If DA0->DA0_X_EB2B == "S"
		Begin Transaction
			If RecLock("DA0",.F.)
				DA0->DA0_X_AB2B := "S"
				DA0->(MsUnLock())
			EndIf
			cQuery := " UPDATE "+RetSQLName("DA1")+" SET DA1_X_AB2B = 'S' WHERE DA1_FILIAL = '"+DA0->DA0_FILIAL+"' AND DA1_CODTAB = '"+DA0->DA0_CODTAB+"' "
			TCSQLEXEC(cQuery)
		End Transaction
	EndIf
	
	RestArea(aAreaTMP)
			
Return
