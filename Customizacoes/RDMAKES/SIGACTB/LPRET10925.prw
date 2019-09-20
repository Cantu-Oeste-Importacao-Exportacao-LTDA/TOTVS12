#include "protheus.ch"
#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RET10925  �Autor  �Paulo Donizeti      � Data �  29/09/2009 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para verificar se o Documento de Entrada conteve     ���
���          � Reten��o de PIS/Cofins/CSLL/IRRF para considerar no        ���
���          � Lan�amento Padr�o da Integra��o Cont�bil.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Lan�amento Padr�o - Compras / Ponto Sul e Imports          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RET10925()

Private _nVlrMoeda1	:= 0 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())  
		  
dbSelectArea("SE2")
dbSetOrder(6)       // E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
If dbSeek(xFilial("SE2")+ SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC)				
	
	IF SE2->E2_VRETPIS > 0 .OR. SE2->E2_VRETCOF > 0 .OR. SE2->E2_VRETCSL > 0
		_nVlrMoeda1 := SF1->F1_VALMERC - SE2->E2_VRETPIS - SE2->E2_VRETCOF - SE2->E2_VRETCSL - SE2->E2_IRRF
	ELSE
		_nVlrMoeda1 := SF1->F1_VALMERC - SE2->E2_IRRF
    ENDIF
ENDIF

Return (_nVlrMoeda1)