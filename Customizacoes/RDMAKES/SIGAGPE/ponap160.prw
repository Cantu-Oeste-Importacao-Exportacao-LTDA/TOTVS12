#INCLUDE "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ponap160  �Autor  �Luiz Gamero Prado    � Data �  26/11/10  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada para alimentar o conteudo do campo        ���
���          � ra_x_dturn (cadastro de funcionarios                       ���
�������������������������������������������������������������������������͹��
���Uso       � P10 - Especifico GRUPO CANTU                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION PONAP160()
DbSelectArea("SR6")
dbSetOrder(1)
dbSeek(xFilial( "SR6" ) + SRA->RA_TNOTRAB )
RecLock("SRA",.F.)
RA_X_DTURN := SR6->R6_DESC
MsUnlock()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return