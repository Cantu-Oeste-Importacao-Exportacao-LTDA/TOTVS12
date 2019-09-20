#include "rwmake.ch"  
#include "TopConn.ch"

// Ponto:	Na entrada da fun��o de baixa.
// Observa��es:	Criado para pr�-validar os dados a serem exibidos na tela. N�o h� a possibilidade 
// de alterar esses dados nesse momento..	
// Retorno Esperado:	.T. ou .F.	
User Function FA080CHK()
Local lRet	:= .T.
Local aArea	:= GetArea()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

cSql := "SELECT E2.E2_SALDO, E2.E2_PREFIXO, E2.E2_NUM, E2.E2_PARCELA "
cSql += "FROM "+RetSqlName("SE2")+" E2 "
cSql += "WHERE E2.D_E_L_E_T_ <> '*' "
cSql += "AND E2.E2_FILIAL = '"+xFilial("SE2")+"' "
cSql += "AND E2.E2_FORNECE = '"+SE2->E2_FORNECE+"'  AND E2.E2_LOJA = '"+SE2->E2_LOJA+"' "
cSql += "AND E2.E2_TIPO = 'NDF' "
cSql += "AND E2.E2_SALDO > 0 "
TCQUERY cSql NEW ALIAS TMPSE2
TMPSE2->(DbSelectArea("TMPSE2"))
TMPSE2->(DbGotop())
If !TMPSE2->(Eof())
	If MsgBox ("Existem NDFs em aberto (" +TMPSE2->E2_PREFIXO + " - " + TMPSE2->E2_NUM + " " + TMPSE2->E2_PARCELA + ;
			"), deseja compensa-las?","Escolha","YESNO")
		lRet	:= .F.
	Endif
Endif
TMPSE2->(DbCloseArea("TMPSE2"))

RestArea(aArea)

Return(lRet)