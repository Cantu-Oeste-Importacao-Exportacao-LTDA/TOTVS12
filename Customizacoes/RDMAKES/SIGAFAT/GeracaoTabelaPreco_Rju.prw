#include "protheus.ch"
#include "rwmake.ch"

User Function OM010FIL()

Private cVendedor := Space(06)
Private cFilVend := .T.
Private oDlg 
Private nOpca := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cQuery := "SELECT B1_COD,B1_DESC,B1_PRV1, B2_CM1 "
cQuery += "FROM "+RetSqlName("SB1")+ " SB1 "
cQuery += "INNER JOIN " +RetSqlName("SB2")+ " SB2 ON B2_COD = B1_COD "
cQuery += "WHERE "
cQuery += "B1_FILIAL ='"+xFilial("SB1")+"' AND "
cQuery += "B2_FILIAL ='"+xFilial("SB2")+"' AND "
cQuery += "B1_COD >= '"+mv_par01+"' AND "
cQuery += "B1_COD <= '"+mv_par02+"' AND "
cQuery += "B1_GRUPO >= '"+mv_par03+"' AND "
cQuery += "B1_GRUPO <= '"+mv_par04+"' AND "
cQuery += "B1_TIPO >= '"+mv_par05+"' AND "
cQuery += "B1_TIPO <= '"+mv_par06+"' AND "
cQuery += "B1_MSBLQL <> '1' AND "
cQuery += "(B2_QATU > 0) AND "
cQuery += "SB1.D_E_L_E_T_ = ' ' AND SB2.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY B1_COD "
Return cQuery