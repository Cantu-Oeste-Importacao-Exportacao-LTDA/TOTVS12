#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"

User Function SldPedL()
Local cFilial := xFilial("SC9")
Local aArea := GetArea()
Local cPerg := "REFSLD"
Local cSql := ""
Private cAlias := GetNextAlias()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Ajusta o SX1 para as perguntas e os parametros necessários
// Clientes
PutSx1(cPerg, "01", "Cliente Inicial ?", "Cliente Inicial ?", "Cliente Inicial ?", "mv_cin", "C", 9, 0, ,"G", "", "SA1", "", "","MV_PAR01")
PutSx1(cPerg, "02", "Cliente Final ?", 	"Cliente Final ?", "Cliente Final ?", "mv_cfi", "C", 9, 0, ,"G", "", "SA1", "", "","MV_PAR02")

Pergunte(cPerg)

// Select que passa por todas as empresas verificando o saldo de pedidos em aberto por cliente. 

cSqlSaldo := "SELECT C9_CLIENTE, C9_LOJA, SUM(C9_SALDO) C9_SALDO FROM ( "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9070 C9 "
cSqlSaldo += "INNER JOIN SC5070 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "   C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "   C5.C5_TIPO = 'N' AND "
cSqlSaldo += "   C9_CLIENTE >= '" + MV_PAR01 + "' AND " 
cSqlSaldo += "   C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9080 C9 "
cSqlSaldo += "INNER JOIN SC5080 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9090 C9 "
cSqlSaldo += "INNER JOIN SC5090 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9100 C9 "
cSqlSaldo += "INNER JOIN SC5500 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9200 C9 "
cSqlSaldo += "INNER JOIN SC5200 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9300 C9 "
cSqlSaldo += "INNER JOIN SC5300 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9310 C9 "
cSqlSaldo += "INNER JOIN SC5310 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9400 C9 "
cSqlSaldo += "INNER JOIN SC5400 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9500 C9 "
cSqlSaldo += "INNER JOIN SC5500 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9600 C9 "
cSqlSaldo += "INNER JOIN SC5600 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "UNION ALL "
cSqlSaldo += "SELECT C9_CLIENTE, C9_LOJA, SUM(C9.C9_QTDLIB*C9.C9_PRCVEN) AS C9_SALDO FROM SC9700 C9 "
cSqlSaldo += "INNER JOIN SC5700 C5 "
cSqlSaldo += "ON C9_PEDIDO = C5_NUM AND "
cSqlSaldo += "   C9_FILIAL = C5.C5_FILIAL "
cSqlSaldo += "WHERE C9_BLCRED = '  ' AND "
cSqlSaldo += "      C9.D_E_L_E_T_ = ' ' AND "
cSqlSaldo += "      C5.C5_TIPO = 'N' AND "
cSqlSaldo += "      C9_CLIENTE >= '" + MV_PAR01 + "' AND "
cSqlSaldo += "      C9_CLIENTE <= '" + MV_PAR02 + "' "
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA )" 
cSqlSaldo += "GROUP BY C9_CLIENTE, C9_LOJA "
cSqlSaldo += "ORDER BY C9_CLIENTE, C9_LOJA "

//Cria um alias para armazenar as informações do SQL
TCQUERY cSqlSaldo NEW ALIAS "TMPSLD"

aCposTmp := {}
aFixe := {}

// Campos que serão adicionados a um arquivo temporário
aAdd(aFixe, {"Cliente", "C9_CLIENTE"	, "C", 9, 0, "@!"})
aAdd(aFixe, {"Cliente", "C9_LOJA"		, "C", 4, 0, "@!"})
aAdd(aFixe, {"Cliente", "C9_SALDO"		, "N", 15, 2, "@E 999,999,999.99"}) 

For i:= 1 to len(aFixe)
  aAdd(aCposTmp, {aFixe[i, 2], aFixe[i, 3], aFixe[i, 4], aFixe[i, 5]})
Next i

// Cria o arquivo temporário com os campos armazenados no aCposTmp
cArqTmp 	:= CriaTrab(aCposTmp,.T.)
// Atribui nome cAlias para o arquivo temporário criado
dbUseArea( .T.,, cArqTmp, cAlias, .T. , .F. )
dbSelectArea(cAlias)
TMPSLD->(DbGoTop())

// Inclui os valores do alias TMPSLD no arquivo temporário cAlias
While !("TMPSLD")->(Eof())
  RecLock(cAlias, .T.)
  C9_CLIENTE 	:= TMPSLD->C9_CLIENTE
  C9_LOJA 		:= TMPSLD->C9_LOJA
  C9_SALDO 		:= Round(TMPSLD->C9_SALDO,2)
  MsUnlock()
  TMPSLD->(DbSkip())
EndDo

TMPSLD->(DbCloseArea())
dbSelectArea(cAlias)

// Cria índice no arquivo temporário cAlias
cArqInd := CriaTrab(NIL,.f.)
IndRegua(cAlias,cArqInd,"C9_CLIENTE+C9_LOJA",,,"Selecionando Registros...")
DbSetOrder(01)

// Select para buscar todos os clientes
cSqlCli := "SELECT A1_COD, A1_LOJA "
cSqlCli += "FROM " + RetSqlName("SA1") + " A1 "
cSqlCli += "WHERE A1.D_E_L_E_T_ <> '*' AND "
cSqlCli += "      A1.A1_COD >= '" + MV_PAR01 + "' AND "
cSqlCli += "      A1.A1_COD <= '" + MV_PAR02 + "' 
cSqlCli += "ORDER BY A1_COD, A1_LOJA"

TCQUERY cSqlCli NEW ALIAS "TMPSA1"
DbSelectArea("TMPSA1")
DbGoTop()

While (!TMPSA1->(Eof()))
  SA1->(DbSetOrder(01))
 	if SA1->(DbSeek(xFilial("SA1") + TMPSA1->A1_COD + TMPSA1->A1_LOJA))
  	RecLock("SA1", .F.)
 		
 		// Verifica se o cliente consta na tabela temporária de pedidos em aberto. Se sim, 
 		// atribui o saldo no campo A1_SALPEDL, senão atribui valor 0
 		if (cAlias)->(DbSeek(TMPSA1->A1_COD + TMPSA1->A1_LOJA))
			SA1->A1_SALPED := (cAlias)->C9_SALDO 			
		else
			SA1->A1_SALPED := 0
 		EndIf
		SA1->(MsUnlock())
	EndIf
	
	TMPSA1->(DbSkip())
end do

TMPSA1->(DbCloseArea())
(cAlias)->(DbCloseArea())

RestArea(aArea)
Return nil