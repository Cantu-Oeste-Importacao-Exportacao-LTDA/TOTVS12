#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NGMNTSD3  �Autor  � Paulo D. Ferreira  � Data �  28/10/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada chamado depois que gravou o registro      ���
���          � no 'SD3' relacionado ao insumo reportado na Finaliza��o    ���
���          � da Ordem de Servi�o.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function  NGMNTSD3() 

Local aArea := GetArea()    

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                    
//�����������������������������������������������������������������������������������Ŀ
//�                                                                                   �
//� Grava no Movimento Interno (SD3) o Segmento conforme informado no Cadastro do Bem.�
//� Ser� utilizado para a Contabiliza��o dos Movimentos da Manuten��o.                �
//�                                                                                   �
//�������������������������������������������������������������������������������������

		RecLock("SD3",.F.)
		SD3->D3_CLVL := ST9->T9_X_CLVL
		SD3->(MsUnlock())
		
	RestArea(aArea)
	
Return