#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltDtCT2 ºAutor  ³Flavio Dias        º Data ³  20/12/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Altera a data de um lançamento contábil, sem precisar abrir º±±
±±º          ³todos os lancamentos                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Todas as empresas, alteracao da data de um lancto contábil º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ManSE5()
Local cAlias := "SE5"
Private cCadastro := "Manutenção de Segmento do Movimento Financeiro"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar", "U_ALTSEGSE5", 0, 4})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil

User Function ALTSEGSE5(cAlias, nOpc)
Local oDlg
Local oGet
Private cSE5_CCD := SE5->E5_CCD
Private cSE5_CLVLDB := SE5->E5_CLVLDB
Private cSE5_CCC    := SE5->E5_CCC
Private cSE5_CLVLCR := SE5->E5_CLVLCR
Private cSE5_NATUREZ:= SE5->E5_NATUREZ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 300, 470 Dialog oDlg Title "Alterar Segmento do Movimento Financeiro"
@ 21, 10 SAY "C.Custo Deb:"  
@ 18, 50 GET cSE5_CCD f3 "CTT" valid (empty(cSE5_CCD) .or. existCpo("CTT",cSE5_CCD)) SIZE 40, 10 

@ 36, 10 SAY "Segmento Deb:"
@ 33, 50 GET cSE5_CLVLDB F3 "CTH" valid (empty(cSE5_CLVLDB) .or. existCpo("CTH",cSE5_CLVLDB)) SIZE 40, 20

@ 51, 10 SAY "C.Custo Crd:"
@ 48, 50 GET cSE5_CCC F3 "CTT" valid (empty(cSE5_CCC) .or. existCpo("CTT",cSE5_CCC)) SIZE 40, 30

@ 66, 10 SAY "Segmento Crd:" 
@ 63, 50 GET cSE5_CLVLCR F3 "CTH" valid (empty(cSE5_CLVLCR) .or. existCpo("CTH",cSE5_CLVLCR)) SIZE 40, 40

@ 81, 10 SAY "Natureza:" 
@ 78, 50 GET cSE5_NATUREZ F3 "SED" valid (empty(cSE5_NATUREZ) .or. existCpo("SED",cSE5_NATUREZ)) SIZE 44, 50

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaSGSE5(), ODlg:End(), Nil }, {|| oDlg:End() })
Return Nil

// Faz a gravação da Data no SE5
Static Function GravaSGSE5()
dbSelectArea("SE5")
RecLock("SE5", .F.)
SE5->E5_CCD     := cSE5_CCD
SE5->E5_CLVLDB  := cSE5_CLVLDB
SE5->E5_CCC     := cSE5_CCC	
SE5->E5_CLVLCR  := cSE5_CLVLCR
SE5->E5_NATUREZ := cSE5_NATUREZ
MsUnlock()
Return Nil