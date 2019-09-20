#include "rwmake.ch"     
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ NFS4001C ¦ Autor ¦  Eder Gasparin       ¦ Data ¦ 10/11/07  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Rotina para exclusão de complemento de custo, que alimenta ¦¦¦
¦¦¦          ¦ o campo SF1.F1_SD3.                                        ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico cliente CANTU - Uso genér.para todas as empresas¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
User Function EXCLCPCUS() //EXCLUSAO DE COMPLEMENTO DE CUSTO  
Local cDocSD3 := ""
Local aArea := GetArea()
Local cPerg := "CLPCUS"
Local lExclui := .T.   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Pergunte(cPerg)                                                    

DbSelectArea("SF1")
SF1->(DbSetOrder(1))               // FILIAL+DOC+SERIE+FORNECEDOR+LOJA+TIPO
SF1->(dbGotop())
If !DbSeek(xFilial("SF1")+MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04)
	Alert("Nota Fiscal nao encontrada!")
	Return
else
	cDocSD3 := SF1->F1_SD3	
	if (empty(cDocSD3))
	  Alert("Não existe complemento de custo para a NF informada.")
	Else
		ExcluiCompl(cDocSD3)
  /*
  // localiza no SD3 e excluí o complemento de custo se o mesmo existir
  SD3->(DbSetOrder(02)) // Filial + Doc + Cod. Produto
  
  if AllTrim(cDocSD3) != "" .And. SD3->(DbSeek(xFilial("SD3") + cDocSD3))
    
  	While (SD3->D3_Filial == xFilial("SD3")) .And. (SD3->D3_DOC == cDocSD3)
  	  
  	  // valida a emissao
  	  lExclui := MsgBox("Excluir o complemento de custo do produto " + SD3->D3_COD + " Valor: " + ;
  	  		Transform(SD3->D3_CUSTO1, "@E 999,999.99") + " ?", ;
  	  		"Complemento de custo do Produto", "YESNO")
  	  if (lExclui)
	  	  RecLock("SD3", .F.)	  	  
	  	  SD3->(DbDelete())
	  	  SD3->(MsUnlock())	
	  	EndIf
  	  
  	  SD3->(DbSkip())
  	EndDo
  EndIf*/
  
	  lExclui := MsgBox("Excluir o complemento de custo da NF " + SF1->F1_DOC + " Série: " + ;
	  								 SF1->F1_SERIE, "Excluir Complemento de custo?", "YESNO")
	  if (lExclui)
	  	RecLock("SF1",.F.)
	  	cDocSD3 := SF1->F1_SD3
	  	SF1->F1_SD3 := " "
	  	MsUnlock("SF1")  
	  	MsgInfo("Complemento de custo da NF "+mv_par01+" - Prefixo "+mv_par02+" foi excluído")
	  EndIf
	EndIf
EndIf   	   
RestArea(aArea)
Return


Static Function ExcluiCompl(cDocSD3)
Local aArea
Local cArqInd := ""
Local cFilSB1 := ""
Local cAliasDB := GetNextAlias()
Local i, cArq
Private cAlias := GetNextAlias()
Private nOpc := 4
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aFixe := {}
Private aCampos := {}
Private cCadastro := "Complemento de Custo"
Private aRotina := {}

            // desc, Nome, Tipo, Tamanho, Decimal, Picture
aAdd(aFixe, {"Filial", "D3_FILIAL", "C", 2, 0, "@!"})
aAdd(aFixe, {"Produto", "D3_COD", "C", 15, 0, "@!"})
aAdd(aFixe, {"Custo", "D3_CUSTO", "N", 14, 2, "@E 999,999,999.99"})
aAdd(aFixe, {"Sequencia", "D3_NUMSEQ", "C", 6, 0, "@!"})

// campos para criar o arquivo de trabalho
For i:= 1 to len(aFixe)
  aAdd(aCampos, {aFixe[i, 2], aFixe[i, 3], aFixe[i, 4], aFixe[i, 5]})
Next i

BeginSql Alias cAliasDB
  Select D3_FILIAL, D3_COD, D3_CUSTO1, D3_NUMSEQ
  From %Table:SD3% SD3
  WHERE SD3.D_E_L_E_T_ = " "
    and D3_FILIAL = %xFilial:SD3%
    and D3_DOC = %Exp:cDocSD3%
  Order by D3_DOC
EndSql

cArq := CriaTrab(aCampos, .T.)

dbUseArea( .T.,, cArq,cAlias, .T. , .F. )

dbSelectArea(cAlias)

ProcRegua((cAliasDB)->(LastRec()))

While !(cAliasDB)->(Eof())
  RecLock(cAlias, .T.)
  D3_FILIAL := (cAliasdB)->D3_FILIAL
  D3_COD := (cAliasdB)->D3_COD
  D3_CUSTO := (cAliasdB)->D3_CUSTO1
  D3_NUMSEQ := (cAliasdB)->D3_NUMSEQ
  MsUnlock()
  (cAliasdB)->(DbSkip())
  IncProc()
EndDo

(cAliasDB)->(DbCloseArea())

dbSelectArea(cAlias)
// tem que ter a variavel pq é usada no GetDados

//aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Excluir", "U_EXCCPL", 0, 6})

// cria um índice a ser usado
cArqInd := CriaTrab(NIL,.f.)

IndRegua(cAlias,cArqInd,"D3_COD",,cFilSB1,"Selecionando Registros...")

dbSetOrder(01)

MBrowse(6, 1, 22, 75, cAlias, aFixe)

(cAlias)->(DbCloseArea())

fErase(cArqInd)

Return nil

User Function EXCCPL(cAlias, nReg, nOpc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SD3->(DbSetOrder(04))
SD3->(DbSeek(xFilial("SD3") + (cAlias)->D3_NUMSEQ))

// Exclui do SD3
RecLock("SD3", .F.)
SD3->(DbDelete())
SD3->(MsUnlock())

// Exclui do trb
RecLock(cAlias, .F.)
(cAlias)->(DbDelete())
(cAlias)->(MsUnlock())
Return .T.