#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJPCO03  �Autor  �Joel Lipnharski       � Data � 18/04/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Programa para verificar se o lancamento devera ser feito   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � PROTHEUS                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RJPCO03(cConta,cOpcao)

Local bReturn := .T.  
Local cConta 
Local cOpcao
Local aArea   := GetArea()      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())


If Empty(cConta) .OR. (cOpcao == 'CNTA100' .AND. ( ISINCALLSTACK("CNTA100").OR.ISINCALLSTACK("CNTA120") ) )
	bReturn := .F.
EndIf

RestArea(aArea)

Return(bReturn)