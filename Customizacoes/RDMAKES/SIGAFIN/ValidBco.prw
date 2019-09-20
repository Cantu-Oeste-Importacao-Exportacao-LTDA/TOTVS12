#include "rwmake.ch"
#include "topconn.ch" 
/****************************************************
 Fun��o para validar se pode ser impresso boleto 
 no banco informado e na data informada
 ****************************************************/
User Function ValidBco(cBanco, cAgencia, cConta)
Local aArea := GetArea()
Local lRet := .T. 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if SA6->(FieldPos("A6_EMITBOL")) > 0
	dbSelectArea("SA6")
	dbSetOrder(01)
	if dbSeek(xfilial("SA6") + cBanco + cAgencia + cConta)
		lRet := A6_EMITBOL
	EndIf
	if (!lRet)
		Alert("N�o podem ser impressos boletos neste banco e nesta data!")
	EndIf
EndIf
RestArea(aArea)
Return lRet


/****************************************************
 Fun��o para validar se o nosso n�mero j� foi usado no banco 
 e n�o permitir duplica��o, tendo por chave o portador, 
 nosso n�mero e filial
 ****************************************************/
User Function ValidNNum(cBanco, cNossoNum)
Local lNDuplic := .F.
Local cSql := ""

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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