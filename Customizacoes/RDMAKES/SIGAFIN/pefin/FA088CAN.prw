#include "rwmake.ch"     
#include "topconn.ch" 

//Ponto de entrada chamado no cancelamento de baixas por recebimentos diversos
//Guilherme 18/06/2013 para tratar os titulos que foram baixados por recebimentos diversos para limpar o motivo de baixa quando excluir o recebimento diverso
User Function FA088CAN()
Local aArea		:= GetArea()
Local cNum		:= SEL->EL_NUMERO
Local cPrfx		:= SEL->EL_PREFIXO
Local cTipo		:= SEL->EL_TIPO   
Local cParce	:= SEL->EL_PARCELA
Local cClie		:= SEL->EL_CLIORIG
Local cLoja		:= SEL->EL_LOJORIG  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SE1")
dbSetOrder(2)
If Dbseek(xFilial("SE1")+cClie+cLoja+cPrfx+cNum+cParce+cTipo)		
	If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. !Empty(AllTrim(SE1->E1_PEFINMB)) .AND. Empty(AllTrim(SE1->E1_PEFINEX))
		RecLock("SE1",.F.)
		SE1->E1_PEFINMB := Space(6)
		MsUnlock("SE1")   
	Endif     
EndIf		               

RestArea(aArea)     

Return
