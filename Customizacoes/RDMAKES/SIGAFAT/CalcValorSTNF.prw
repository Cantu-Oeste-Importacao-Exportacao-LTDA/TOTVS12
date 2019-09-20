#include "rwmake.ch"
#include "topconn.ch"
/**************************************************/
// Testa a função que traz os valores de mensagens de ST.
/**************************************************/
User Function TstMsgST()
Local oDlg1
Local cProduto := Space(15)
Local nBase := 0, nValor := 0
Local nQuant := 1      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 400,430 DIALOG oDlg1 TITLE "Teste de valores de ST"
@ 005,005 TO 060,160
@ 020,010 Say "Produto"
@ 020,100 Get cProduto Size 30, 50 F3 "SB1"
@ 030,010 Say "Valor Base"
@ 030,100 Get nBase Size 30, 50 Picture "@E 999999" when .F.
@ 040,010 Say "Valor ST"
@ 040,100 Get nValor Size 30, 50 Picture "@E 999999"  when .F.
@ 095,100 BMPBUTTON TYPE 1 ACTION (nBase := 0, nValor := 0, AddSTVal(cProduto, nQuant, @nBase, @nValor))
@ 095,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return 
/**************************************************/
// Adiciona o valor e base de ST nas variaveis nBase e nValor, que devem ser passadas como referencia
/**************************************************/
User Function AddSTVal(cProd, nQtde, nBase, nValor)
Local aArea := GetArea()
Local cSql := ""                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// monta o sql buscando apenas o valor de icms de substituiçao tributária da última compra
cSql := "SELECT (D1_BRICMS / D1_QUANT) AS BASEST, (D1_ICMSRET / D1_QUANT) AS VALORST "
cSql += "FROM " + RetSqlName("SD1") + " SD1 INNER JOIN " + RetSqlName("SF1") + " SF1 ON (D1_FILIAL = F1_FILIAL) AND (D1_DOC = F1_DOC) "
cSql += " AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA "
cSql += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON (F4_CODIGO = D1_TES) AND (F4_FILIAL = '" + xFilial("SF4") + "') "
cSql += "AND F4_INCSOL = 'S' AND SF4.D_E_L_E_T_ = ' ' " // filtra se calcula icms solidário, pois tem os retornos que nao deve considerar
cSql += "WHERE RTRIM(D1_COD) = '" + AllTrim(cProd) + "' AND F1_FILIAL = '" + xFilial("SF1") + "' "
cSql += "AND F1_TIPO = 'N' "
cSql += "AND SD1.D_E_L_E_T_ = ' ' "
cSql += "AND SF1.D_E_L_E_T_ = ' ' "
//cSql += "ORDER BY F1_EMISSAO DESC FETCH FIRST 1 ROWS ONLY " 
//cSql += "AND ROWNUM = 1 "
cSql += "ORDER BY F1_EMISSAO DESC "
  
// executa a query e retorna no arquivo
TCQUERY cSql NEW ALIAS "TMP"
  
if TMP->(!Eof()) // adiciona os valores da retençao de icms, multiplicado pela quantidade dos produtos que formam vendidos
  nBase += Round(TMP->BASEST * nQtde, 2)
  nValor += Round(TMP->VALORST * nQtde, 2)
EndIf

TMP->(dbCloseArea())

RestArea(aArea)
Return nil

User Function GetMsgSTNF(nBase, nValor)
Local cMsg := ""
// formatar a mensagem da forma que a mesma deve aparecer na observaçao da NF
if (nBase > 0 .And. nValor > 0)
	cMsg := "Base de calculo ICMS Substituição R$ " + AllTrim(Transform(nBase, "@E 99,999,999.99")) + ;
          " - ICMS Retido R$ " + AllTrim(Transform(nValor, "@E 99,999,999.99"))
EndIf
Return cMsg

/*
	Faz o cálculo pelo sistema novo, no qual usa a tabela ZZ9
*/

User Function AddSTVl2(cProd, nQtde, nBase, nValor)
Local aArea := GetArea()
Local cSql := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("ZZ9")
ZZ9->(dbSetOrder(01))
if ZZ9->(dbSeek(xFilial("ZZ9") + cProd))
	nBase += Round((ZZ9->ZZ9_BASEST * nQtde), 2)
	nValor += Round((ZZ9->ZZ9_VALST * nQtde), 2)
EndIf

RestArea(aArea)
Return nil


User Function ExpCalcST()
Local nFile := fCreate("c:\" + cEmpAnt + "_" + cFilAnt + "_creditost.txt")
Local nValor, nBase              

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SB1")
While SB1->(!Eof()) .And. xFilial("SB1") == SB1->B1_FILIAL
	if !(SB1->B1_LOCPAD == "05")
		SB1->(dbSkip())
		loop
	EndIf
	nValor := 0
	nBase := 0	
	
	U_AddSTVal(SB1->B1_COD, 1, nBase, nValor)
	
	fWrite(SB1->B1_COD + "   " + Str(nBase) + Str(nValor))
	SB1->(dbSkip())	
Enddo

fClose(nFile)
Return                          