#include "RWMAKE.CH"
#include "TBICONN.CH"
User Function F440LIQ()
Local lCalc := .T.
Local dDtBxIni   

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

ZZL->(dbSetOrder(01))
if (ZZL->(dbSeek(xFilial("ZZL") + SE1->E1_CLVLCR)))
	dDtBxIni := ZZL->ZZL_DATACO
else
	dDtBxIni := SE1->E1_EMISSAO // Considera o dia atual, para n�o calcular comiss�o
EndIf

lCalc := (SE1->E1_EMISSAO >= dDtBxIni)

/*if (lCalc)
	Alert("Calculado comissao para titulo " + SE1->E1_NUM + " com emissao em " + DtoC(SE1->E1_EMISSAO) + " e baixa em " + DtoC(SE5->E5_DATA))
else
	Alert("N�o calculado comissao para titulo " + SE1->E1_NUM + " com emissao em " + DtoC(SE1->E1_EMISSAO) + " e baixa em " + DtoC(SE5->E5_DATA))
EndIf*/
Return lCalc