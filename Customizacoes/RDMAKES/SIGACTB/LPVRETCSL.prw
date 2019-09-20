#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � VRETCSL  �Autor  �Paulo Donizeti      � Data �  29/09/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para verificar o valor de Reten��o da CSLL           ���
���          � do Documento de Entrda, este valor ser� considerardo no    ���
���          � Lan�amento Padr�o da Integra��o Cont�bil.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Lan�amento Padr�o - Compras / Ponto Sul e Imports          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VRETCSL()

Private _nVRETCSL := 0              

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
		  
dbSelectArea("SE2")
dbSetOrder(6)       // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
If dbSeek(xFilial("SE2")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC)				
	
	IF SE2->E2_VRETCSL > 0 
	
		_nVRETCSL := SE2->E2_VRETCSL
	
	ENDIF
ENDIF

Return (_nVRETCSL)