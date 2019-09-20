#include "rwmake.ch"
#include "topconn.ch" 
/****************************************************
 Função para validar se pode ser impresso boleto 
 no banco informado e na data informada
 ****************************************************/
User Function ValidBco(cBanco, cAgencia, cConta)
Local aArea := GetArea()
Local lRet := .T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if SA6->(FieldPos("A6_EMITBOL")) > 0
	dbSelectArea("SA6")
	dbSetOrder(01)
	if dbSeek(xfilial("SA6") + cBanco + cAgencia + cConta)
		lRet := A6_EMITBOL
	EndIf
	if (!lRet)
		Alert("Não podem ser impressos boletos neste banco e nesta data!")
	EndIf
EndIf
RestArea(aArea)
Return lRet


/****************************************************
 Função para validar se o nosso número já foi usado no banco 
 e não permitir duplicação, tendo por chave o portador, 
 nosso número e filial
 ****************************************************/
User Function ValidNNum(cBanco, cNossoNum)
Local lNDuplic := .F.
Local cSql := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cSql := "SELECT E1_NUMBCO AS NUMBCO FROM " + retSqlName("SE1") + " "
cSql += "WHERE E1_NUMBCO = '" + cNossoNum + "' "
cSql += "  AND E1_PORTADO = '" + cBanco + "' "
cSql += "  AND D_E_L_E_T_ <> '*' "
cSql += "ORDER BY NUMBCO"

TCQUERY cSql NEW ALIAS "SE1BCO"

DbSelectArea("SE1BCO")
SE1BCO->(dbGoTop())
lNDuplic := Empty(SE1BCO->NUMBCO)
SE1BCO->(dbCloseArea())
Return lNDuplic