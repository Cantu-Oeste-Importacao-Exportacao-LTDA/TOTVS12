#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TopConn.ch" 	 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCLIFOR   บAutor  ณGUILHERME          บ Data ณ  29/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPREENCHER O CODIGO DO FORNECEDOR QUANDO ษ DO TIPO OUTROS    บฑฑ
ฑฑบ          ณCOM EX                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/

*-----------------------------*
User Function RJCODFOR()
*-----------------------------* 
Local _Nro 	 := Space(09)
Local _Query := ''
Local aArea  := GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DBSELECTAREA("SA2")

cSql := "SELECT SUBSTR(MAX(A2.A2_COD),01,02) || LPAD(SUBSTR(MAX(A2.A2_COD),03,07)+1,7,'0') AS CODIGO " 
cSql += "FROM " + RetSqlName("SA2")+" A2 "      
cSql += "WHERE A2.D_E_L_E_T_ <> '*' "
cSql += "  AND A2.A2_COD LIKE '%EX%' "
cSql += "  AND SUBSTR(A2.A2_COD, 08, 02) BETWEEN '00' AND '99' "

cSql := ChangeQuery(cSql)
TcQuery cSql NEW ALIAS "TMPCF"
TMPCF->(DbSelectArea("TMPCF"))

_Nro := TMPCF->CODIGO

DbSelectArea("TMPCF")
TMPCF->(DbCloseArea())

RestArea(aArea)

Return(_Nro) 	