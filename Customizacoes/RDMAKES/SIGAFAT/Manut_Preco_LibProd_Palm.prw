//+--------------------------------------------------------------------+
//| Rotina | AltPrcPneu | Autor | Flavio Dias      | Data | 25.07.2008 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar o preço do produto.                               |
//+--------------------------------------------------------------------+
//| Uso    |Cantu Cascavel - Pneu                                      |
//+--------------------------------------------------------------------+
#Include "Protheus.ch"
#include "rwmake.ch"

User Function AltPrcPneu()      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  AltPrcProd(AllTrim(GetMV("MV_TABPRBA")))
Return Nil

/* Função para listar os produtos de determinada tabela de preço, permitindo a alteração do valor dos mesmos*/
Static Function AltPrcProd(cTabBase)
Local aArea
Local cArqInd := ""
Local cFilSB1 := ""
Local cAliasDB := GetNextAlias()
Local i, cArq
Private cCadastro := "Manutenção de Produtos/Preço"
Private aRotina := {}
Private cAlias := GetNextAlias()
Private nOpc := 4
Private cTabela := cTabBase
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aFixe := {}
Private aCampos := {}

            // desc, Nome, Tipo, Tamanho, Decimal, Picture
aAdd(aFixe, {"Filial", "B1_FILIAL", "C", 2, 0, "@!"})
aAdd(aFixe, {"Código", "B1_COD", "C", 15, 0, "@!"})
aAdd(aFixe, {"Descrição", "B1_DESC", "C", 50, 0, "@!"})
aAdd(aFixe, {"Preço Venda", "B1_PRV1", "N", 14, 2, "@E 999,999,999.99"})
aAdd(aFixe, {"Exporta SFA", "B1_EXPALM", "C", 1, 0, "@!"})

// campos para criar o arquivo de trabalho
For i:= 1 to len(aFixe)
  aAdd(aCampos, {aFixe[i, 2], aFixe[i, 3], aFixe[i, 4], aFixe[i, 5]})
Next i

aArea := GetArea()

BeginSql Alias cAliasDB
  Select B1_FILIAL, B1_COD, B1_DESC, B1_PRV1, B1_EXPALM
  From %Table:SB1% SB1
  Inner Join %Table:DA1% DA1 on B1_COD = DA1_CODPRO
  WHERE SB1.D_E_L_E_T_ = " "
    and DA1.D_E_L_E_T_ = " "
    and B1_FILIAL = %xFilial:SB1%
    and DA1_FILIAL = %xFilial:DA1%
    and DA1_CODTAB = %Exp:cTabBase%
  Order by B1_COD
EndSql

cArq := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArq,cAlias, .T. , .F. )

dbSelectArea(cAlias)

ProcRegua((cAliasDB)->(LastRec()))

While !(cAliasDB)->(Eof())
  RecLock(cAlias, .T.)
  B1_FILIAL := (cAliasdB)->B1_FILIAL
  B1_COD := (cAliasdB)->B1_COD
  B1_DESC := (cAliasdB)->B1_DESC
  B1_PRV1 := (cAliasdB)->B1_PRV1
  B1_EXPALM := (cAliasdB)->B1_EXPALM
  MsUnlock()
  (cAliasdB)->(DbSkip())
  IncProc()
EndDo

(cAliasDB)->(DbCloseArea())

dbSelectArea(cAlias)
// tem que ter a variavel pq é usada no GetDados
aAdd( aRotina, {"Alterar"    ,'U_EdtPrcProd',0,nOpc})

dbSelectArea(cAlias)

// cria um índice a ser usado
cArqInd := CriaTrab(NIL,.f.)

IndRegua(cAlias,cArqInd,"B1_COD",,cFilSB1,"Selecionando Registros...")

dbSetOrder(01)

MBrowse(6, 1, 22, 75, cAlias, aFixe)

(cAlias)->(DbCloseArea())

// retorna o ambiente anterior
RestArea(aArea)

fErase(cArqInd)

Return

/*******************************************************************
 Funcao usada para editar o registro que está sendo exibido no browse acima
 nao foi possivel usar a funcao enchoice, nao apareciam os dados e 
 foi feito os gets manuais - Flavio - 15/12/2008
 *******************************************************************/
User Function EdtPrcProd(cAlias, nReg, nOpc)

Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Local aCampo := {"B1_FILIAL", "B1_COD", "B1_DESC", "B1_PRV1", "B1_EXPALM"}
Local aCpoAlt := {"B1_PRV1", "B1_EXPALM"}
Local caTela := ""
Local oItens := {"1-SIM", "2-NÃO"}

Private nPreco := (cAlias)->B1_PRV1
Private cExpSfa := iif((cAlias)->B1_EXPALM == "1", oItens[1], oItens[2])

@ 100, 100 To 240, 470 Dialog oDlg Title cCadastro

@ 20, 10 SAY "Produto:" 
@ 20, 60 SAY AllTrim((cAlias)->B1_COD) + " - " + (cAlias)->B1_DESC
@ 35, 10 SAY "Preço Venda:" 
@ 35, 60 GET nPreco SIZE 40, 10 Picture "@E 9999999.99" Valid nPreco >= 0
@ 50, 10 SAY "Exporta SFA:"
@ 50, 60 ComboBox cExpSfa Items oItens Size 50, 40

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaPrc(cAlias), ODlg:End(), Nil }, {|| oDlg:End() })

Return

/***********************************************************************************
 Funcao para grava os dados no sb1 de preco base e exportacao para o palm
 ***********************************************************************************/
Static Function GravaPrc(cAlias)
SB1->(DbSetOrder(01))
SB1->(DbSeek(xFilial("SB1") + AllTrim((cAlias)->B1_COD)))
RecLock("SB1", .F.)
SB1->B1_PRV1 := nPreco
SB1->B1_EXPALM := SubStr(cExpSfa, 1, 1)
SB1->(MsUnlock())

// altera o aquivo em memória atual
RecLock(cAlias, .F.)
(cAlias)->B1_PRV1 := nPreco
(cAlias)->B1_EXPALM := SubStr(cExpSfa, 1,1)
(cAlias)->(MsUnlock())

Return .T. 