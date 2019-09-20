#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F340VLD   �Autor  �Gustavo Lattmann    � Data �  05/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de Entrada que permite validar se um t�tulo ser� ou   ���
���          �n�o compensado na rotina de compensa��o a pagar.            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
���Chamado   � 13132		                                              ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function F340VLD()   

Local lRet := .T. 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())


//��������������������������������������������������������������������������������Ŀ
//�Por quest�es de hist�rico na contabilidade a origem da compensa��o deve ser a NF�
//����������������������������������������������������������������������������������
If ALLTRIM(SE2->E2_TIPO) $ "PA/NDF"  
	lRet := .F.
	ShowHelpDlg("Aten��o!", {"A origem da compensa��o n�o deve ser do tipo PA ou NFD."},5,;
							{"Favor selecionar o t�tulo normal para completar o processo. Ex: NF, FT, DP."},5)
EndIf   


Return lRet