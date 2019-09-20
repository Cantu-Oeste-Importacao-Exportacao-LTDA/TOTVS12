#INCLUDE "PROTHEUS.CH"
/*******************************************/
/* Guilherme Poyer 25-02-13 verificar estrutura de produtos ao incluir uma produ豫o, colocado o programa na valida豫o do campo C2_PRDUTO
/********************************************/
User Function veEstr()
cProduto   := M->C2_PRODUTO
lEstrutura := .T.    

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

If !SG1->(dbSeek(xFilial("SG1") + cProduto))
	Alert("PRODUTO NAO POSSUI ESTRUTURA CADASTRADA, VERIFIQUE!!")
	lEstrutura := .F.
EndIf
		     	
Return(lEstrutura)