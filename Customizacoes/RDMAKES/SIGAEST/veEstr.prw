#INCLUDE "PROTHEUS.CH"
/*******************************************/
/* Guilherme Poyer 25-02-13 verificar estrutura de produtos ao incluir uma produção, colocado o programa na validação do campo C2_PRDUTO
/********************************************/
User Function veEstr()
cProduto   := M->C2_PRODUTO
lEstrutura := .T.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !SG1->(dbSeek(xFilial("SG1") + cProduto))
	Alert("PRODUTO NAO POSSUI ESTRUTURA CADASTRADA, VERIFIQUE!!")
	lEstrutura := .F.
EndIf
		     	
Return(lEstrutura)