#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VRETPIS   �Autor  �Paulo Donizeti      � Data �  29/09/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para verificar o valor de Reten��o do PIS            ���
���          � do Documento de Entrda, este valor ser� considerardo no    ���
���          � Lan�amento Padr�o da Integra��o Cont�bil.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Lan�amento Padr�o - Compras / Ponto Sul e Imports          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VRETPIS()

Private _nVRETPIS := 0  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName()) 
		  
dbSelectArea("SE2")
dbSetOrder(6)       // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
If dbSeek(xFilial("SE2")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC)				
	
	IF SE2->E2_VRETPIS > 0 
	
		_nVRETPIS := SE2->E2_VRETPIS
	
	ENDIF
ENDIF

Return (_nVRETPIS)