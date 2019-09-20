#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJGPE07   �Autor  �Luiz Gamero Prado   � Data �  03/03/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para ajustar o valor a ser importado utilizando      ��
���          � o conteudo das posicoes 11 A 21, pois nao ponto no arquivo��
���          � para a geracao do centavo - arquivo coopercred             ���
�������������������������������������������������������������������������͹��
���Uso       � P10 - GRUPO CANTU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function RJGPE07()
Local _Matricula := " "
Local _VLR       := " "          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

_VLR := substr(txt,16,04) + "." + substr(txt,20,02)

Return _vlr