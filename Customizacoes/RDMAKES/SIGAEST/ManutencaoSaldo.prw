#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutSald  | Autor | Flavio Dias      | Data | 08.06.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar a quantidade empenhada e reservada de um produto  |
//+--------------------------------------------------------------------+
//| Uso    |Rju Vitoriono                                              |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de Origem, Grupo Tributário, Tes,
 Exporta para Palm, Filial de Venda, Peso Bruto, Peso Líquido,
 Unidade de Medida, Bloqueado, Segunda Unidade de Medida, Conversao,
 Tipo da Conversao, Preço de Venda e Desconto Máximo
  
 * Funçao modificada para para que seja possível alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTSALD()
Private cCadastro := "Manutenção de saldos empenhado e reservado" 
Private aRotina := {}
Private aFixe := {}
Private cAlias := "SB2" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Private aCampos := {} // array que contém os campos utilizados

aAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar"   , "U_AltSldPd", 0, 4})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return

User Function AltSldPd()
Local nSaldoEmp := SB2->B2_QEMP
Local nSaldoRes := SB2->B2_RESERVA
Local oDlg
Local lAlt := .F.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 001, 001 TO 300,700 DIALOG oDlg TITLE "Alterar saldo empenhado e reservado"
@ 040, 020 SAY 'Produto : ' + SB2->B2_COD + " - " + Posicione("SB1", 01, xFilial("SB1") + SB2->B2_COD, "B1_DESC")
@ 055, 020 SAY "Saldo Empenhado: "
@ 055, 080 Get nSaldoEmp SIZE 70,50 Picture "@E 999,999.99"
@ 070, 020 SAY "Saldo Reservado: " 
@ 070, 080 Get nSaldoRes SIZE 70,50 Picture "@E 999,999.99"
//@ 180,310 BMPBUTTON TYPE 01 ACTION (lAlt := .T. ,Close(oDlg))
//@ 180,280 BMPBUTTON TYPE 02 ACTION (Close(oDlg))
//ACTIVATE DIALOG oDlg CENTERED 
ACTIVATE DIALOG oDlg CENTER ON INIT ;
	EnchoiceBar(oDlg,{|| (lAlt := .T.), oDlg:End(), Nil }, {|| oDlg:End() })
//	EnchoiceBar(oDlg,{|| GravaPrc(cAlias), ODlg:End(), Nil }, {|| oDlg:End() })
	
if (lAlt)
	RecLock("SB2", .F.)
	SB2->B2_QEMP := nSaldoEmp
	SB2->B2_RESERVA := nSaldoRes
	SB2->(MsUnlock())
EndIf
Return