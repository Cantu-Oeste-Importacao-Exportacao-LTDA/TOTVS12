#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJGPE05   �Autor  �Luiz Gamero Prado   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para identificar o numero da matricula do funcionario��
���          � atraves do codigo do pis do funcionario conforme consta na ���
���          � posicao 105 a 115 do arquivo da sicon                      ���
�������������������������������������������������������������������������͹��
���Uso       � P10 - GRUPO CANTU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function RJGPE05()
Local _Matricula := " "
Local _cic       := substr(txt,105,11) 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbselectarea("SRA")
DbSetOrder(5)
DbGoTop()
If dbSeek(xFilial("SRA") + _cic )
	_Matricula := SRA->RA_MAT
endif
Return _Matricula