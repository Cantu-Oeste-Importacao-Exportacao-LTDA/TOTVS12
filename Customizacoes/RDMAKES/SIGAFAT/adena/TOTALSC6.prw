#INCLUDE "rwmake.ch"

User Function TOTALSC6()
Local aArea		:= GetArea()
Local _nTotalSC6:= 0

dbSelectArea("SC6")
dbSetOrder(1)
dbSeek(SC9->C9_FILIAL+SC9->C9_PEDIDO)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While SC6->(!EOF()) .AND. SC9->C9_FILIAL == SC6->C6_FILIAL .AND. SC9->C9_PEDIDO == SC6->C6_NUM
    
	_nTotalSC6 += SC6->C6_VALOR

	dbSelectArea("SC6")
	SC6->(DbSkip())

EndDo

RestArea(aArea)

Return _nTotalSC6