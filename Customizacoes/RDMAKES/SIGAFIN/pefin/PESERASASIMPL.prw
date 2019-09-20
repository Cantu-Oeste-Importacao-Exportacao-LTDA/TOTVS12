#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

User Function SERASA01()         
Local lRet	:= .T.
Local _cAlias	:= PARAMIXB[1]
Local _aArea	:= GetArea()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cSql := "SELECT A1.A1_COD, A1.A1_LOJA "
cSql += "FROM "+RetSqlName("SA1")+" A1 "
cSql += "WHERE A1.A1_FILIAL = '"+xFilial("SA1")+"' "
cSql += "AND A1.A1_COD = '"+(_cAlias)->E1_CLIENTE+"' AND A1.A1_LOJA = '"+(_cAlias)->E1_LOJA+"' "
cSql += "AND A1.A1_RISCO <> 'A' AND A1.A1_X_SERAS <> 'N' "
cSql += "AND A1.D_E_L_E_T_  <> '*' "
cSql := ChangeQuery(cSql)
TcQuery cSql NEW ALIAS "TMPSA1"
TMPSA1->(DbSelectArea("TMPSA1"))
TMPSA1->(DbGotop())
If TMPSA1->(Eof())
	lRet	:= .F.
Endif
TMPSA1->(DbCloseArea())

RestArea(_aArea)

Return(lRet)