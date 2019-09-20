#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP530002     �Autor  �J&@N           � Data �  08/06/12   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o chamada pelo lan�amento padr�o 530 - 002            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade Gerencial                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                                         
User Function LP530002()
Local lRet := .F.      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

lRet := FORMULA("P05") .and.; 
				FORMULA("P10")

Return lRet
