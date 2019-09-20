#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

// Faz a validacao se o vendedor pode ser usado para o cliente selecionado
User Function VldVend()
Local lRet := .F.  

//здддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁChama funГЦo para monitor uso de fontes customizadosЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("ZZ5")
dbSetOrder(01)
lRet := dbSeek(xFilial("ZZ5") + M->C5_VEND1 + M->C5_CLIENTE + M->C5_LOJA)
Return lRet


// Traz o vendedor padrao e a classe de valor apСs informar os dados do cliente
User Function GetVendCli()
Local aArea := GetArea()
Local cCli := M->C5_CLIENTE
Local cLoja := M->C5_LOJACLI
Local cSql := ""
Local aVendSeg := {}

//здддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁChama funГЦo para monitor uso de fontes customizadosЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
U_USORWMAKE(ProcName(),FunName())

cSql := "SELECT ZZ5_VEND, ZZ5_SEGMEN, ZZ5_TABELA, ZZ5_CC FROM " + RetSqlName("ZZ5") + " ZZ5 WHERE ZZ5_FILIAL = '" + xFilial("ZZ5") + "' AND "
cSql += "ZZ5_CLIENT = '" + cCli + "' AND ZZ5_LOJA = '" + cLoja + "' AND D_E_L_E_T_ <> '*'"
TCQUERY cSql NEW ALIAS "ZZ5VND"
While ZZ5VND->(!Eof())
	aAdd(aVendSeg, {ZZ5VND->ZZ5_VEND, ZZ5VND->ZZ5_SEGMEN, ZZ5VND->ZZ5_TABELA, ZZ5_CC})
	ZZ5VND->(dbSkip())
EndDo

ZZ5VND->(dbCloseArea())

if len(aVendSeg) == 1
	M->C5_VEND1 := aVendSeg[1,1]
	M->C5_X_CLVL := aVendSeg[1,2]
	M->C5_TABELA := aVendSeg[1,3]
	M->C5_X_CC	 := aVendSeg[1,4]
	
elseif len(aVendSeg) > 1 .And. Empty(M->C5_COTACAO)
  MostraSel(aVendSeg)
EndIf
RestArea(aArea)
Return M->C5_VEND1

// Mostra um dialogo para selecionar os vendedores
Static Function MostraSel(aVendSeg)
Local aItens := {}
Local cVend
Local cSegment
Local oDlg1
Local cOpcVend := "1"
Local cDescSeg := ""
Local aArea := Z22->(GetArea())

Local cCODCC := Space(09)
Local cDESCC := Space(09)

dbSelectArea("CTH")
dbSetOrder(01)

dbSelectArea("CTT")
dbSetOrder(01)

For nX := 1 to len(aVendSeg)
	cVend := aVendSeg[nX, 1] + " - " + Posicione("SA3", 01, xFilial("SA3") + aVendSeg[nX, 1], "A3_NREDUZ") // Obtem o nome reduzido
	// ObtИm o armazИm
	if CTH->(dbSeek(xFilial("CTH") + aVendSeg[nX, 2]))
		cDescSeg := StrTran(AllTrim(CTH->CTH_DESC01), "SEGMENTO DE", "")
	else
		cDescSeg := Space(6)
	EndIf

	if CTT->(dbSeek(xFilial("CTT") + aVendSeg[nX, 4]))
		cDESCC := AllTrim(CTT->CTT_DESC01)
	else
		cDESCC := Space(09)
	EndIf
		
	aAdd(aItens, AllTrim(Str(nX,0)) + "= (" + aVendSeg[nX, 2] +  " - " + cDescSeg +	")(" + aVendSeg[nX, 4] +  " - " + cDESCC +	") " + cVend)
Next
Z22->(RestArea(aArea))

@ 000,000 TO 115,500 DIALOG oDlg1 TITLE "Selecione o Vendedor"
@ 010,010 Say "(Segmento - Desc. Segmento) Vendedor :"
@ 020,010 COMBOBOX cOpcVend ITEMS aItens SIZE 230,50
@ 035,130 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

nX := Val(cOpcVend)

M->C5_VEND1 := aVendSeg[nX,1]
M->C5_X_CLVL := aVendSeg[nX,2]
M->C5_TABELA := aVendSeg[nX,3]                
M->C5_X_CC   := aVendSeg[nX,4]                

Return