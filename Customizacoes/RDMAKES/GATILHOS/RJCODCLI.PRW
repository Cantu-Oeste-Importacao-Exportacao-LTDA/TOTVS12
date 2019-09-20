#INCLUDE "RWMAKE.CH"
#INCLUDE "TopConn.ch"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCLIFOR   บAutor  ณGUILHERME          บ Data ณ  29/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPREENCHER O CODIGO DO CLIENTE QUANDO ษ DO TIPO "X"          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
*/

*-----------------------------*
User Function RJCODCLI()
*-----------------------------* 
Local _Nro 	 := Space(09)
Local _Query := ''
Local cTeste := ''  
Local aArea  := GetArea()   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DBSELECTAREA("SA1")

cSql := "SELECT MAX(A1.A1_COD) AS CODIGO " 
cSql += "FROM " + RetSqlName("SA1")+" A1 "      
cSql += "WHERE A1.D_E_L_E_T_ <> '*' "
cSql += "AND A1.A1_COD LIKE '%EX%' "
cSql += "ORDER BY A1.A1_COD "

cSql := ChangeQuery(cSql)                   

TcQuery cSql NEW ALIAS "TMPCF"
TMPCF->(DbSelectArea("TMPCF"))

cTeste := substr(TMPCF->CODIGO,3,7)
_Nro := "EX"+Soma1(cTeste)

//_Nro := TMPCF->CODIGO+1

DbSelectArea("TMPCF")
TMPCF->(DbCloseArea())

RestArea(aArea)

Return(_Nro) 	