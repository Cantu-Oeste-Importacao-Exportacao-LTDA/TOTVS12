/*
���Programa �MA330SEQ �Autor �Microsiga � Data � 11/04/02 ���
�������������������������������������������������������������������������͹��
���Desc. �Altera a ordem das movimentacoes(DE7/RE7), produtos = "PA", ���
��� �na rotina do calculo do custo medio ���
   Rotina para acerto de custo desmontagem de produtos.
�����������������������������������������������������������������������������*/
User Function MA330SEQ()   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

_cOrdem := ParamIxb[1]
//_cProd := GetAdvFval("SB1","B1_TIPO",xFilial("SB1") + SD3->D3_COD,1)
If ParamIxb[2] == "SD3"
If D3_CF $ "RE6"//"RE7/DE7"
_cOrdem := "299"
Endif
Endif
Return(_cOrdem)