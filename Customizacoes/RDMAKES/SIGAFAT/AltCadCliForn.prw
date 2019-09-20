//+--------------------------------------------------------------------+
//| Rotina | AltCadClF | Autor  | Flavio Dias      | Data | 25.07.2008 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar dados específicos de cliente e fornecedor.        |
//+--------------------------------------------------------------------+
//| Uso    |Cantu Geral	                                               |
//+--------------------------------------------------------------------+
#Include "Protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function AltCadCli()
	AltCad("SA1", "A1_")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
Return Nil

User Function AltCadFor()
	AltCad("SA2", "A2_")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

Return Nil

/* Função para listar os produtos de determinada tabela de preço, permitindo a alteração do valor dos mesmos*/
Static Function AltCad(cTab, cPref)
Local aArea
Local i
Local cSql
Private cCadastro := "Manutenção de Cadastro - " + cTab
Private aRotina := {}
Private cAlias := cTab // GetNextAlias()
Private nOpc := 4
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private aFixe := {}
Private aCampos := {}

            // desc, Nome, Tipo, Tamanho, Decimal, Picture
aAdd(aFixe, {"Filial", cPref + "FILIAL", "C", 2, 0, "@!"})
aAdd(aFixe, {"Código", cPref + "COD", "C", 6, 0, "@!"})
aAdd(aFixe, {"Cod. Municip", cPref + "COD_MUN", "C", 6, 0, "@!"})
aAdd(aFixe, {"Endereço", cPref + "END", "C", 40, 0, "@!"})  
aAdd(aFixe, {"Município", cPref + "MUN", "C", 40, 0, "@!"})
aAdd(aFixe, {"CNPJ", cPref + "CGC", "C", 14, 0, "@!"})
aAdd(aFixe, {"IE", cPref + "INSCR", "C", 18, 0, "@!"})
aAdd(aFixe, {"Bairro", cPref + "BAIRRO", "C", 30, 0, "@!"})
aAdd(aFixe, {"CEP", cPref + "CEP", "C", 8, 0, "@!"})
aAdd(aFixe, {"DDD", cPref + "DDD", "C", 3, 0, "@!"})
aAdd(aFixe, {"Telefone", cPref + "TEL", "C", 15, 0, "@!"})
aAdd(aFixe, {"Bloqueado", cPref + "MSBLQL", "C", 1, 0, "@!"})
aAdd(aFixe, {"Risco", cPref + "RISCO", "C", 1, 0, "@!"}) // nao usado
aAdd(aFixe, {"Raz. Social", cPref + "NOME", "C", 40, 0, "@!"}) // nao usado
aAdd(aFixe, {"Loja", cPref + "LOJA", "C", 2, 0, "@!"})
aAdd(aFixe, {"UF", cPref + "EST", "C", 2, 0, "@!"})

aArea := GetArea()

// tem que ter a variavel pq é usada no GetDados
aAdd( aRotina, {"Alterar"    ,'U_EdtCliFor',0,nOpc})
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Consultar", "U_GetCadCli", 0, 2})

dbSelectArea(cAlias)

MBrowse(6, 1, 22, 75, cAlias, aFixe)

// retorna o ambiente anterior
RestArea(aArea)

Return

/*******************************************************************
 Funcao usada para editar o registro que está sendo exibido no browse acima
 nao foi possivel usar a funcao enchoice, nao apareciam os dados e 
 foi feito os gets manuais - Flavio - 15/12/2008
 *******************************************************************/
User Function EdtCliFor(cAlias, nReg, nOpc)
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2
Local caTela := ""
Local cConsEst := ""

Private cCodMun := (cAlias)->&(aFixe[3,2])
Private cEnd := (cAlias)->&(aFixe[4,2])
Private cMun := (cAlias)->&(aFixe[5,2])
Private cCnpj := (cAlias)->&(aFixe[6,2])
Private cIE := (cAlias)->&(aFixe[7,2])
Private cBairro := (cAlias)->&(aFixe[8,2])
Private cCep := (cAlias)->&(aFixe[9,2])
Private cDDD := (cAlias)->&(aFixe[10,2])
Private cTel := (cAlias)->&(aFixe[11,2])
Private cBlq := (cAlias)->&(aFixe[12,2])
//Private cRisco := (cAlias)->&(aFixe[13,2])
Private cUF := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if cAlias == "SA1"
  cUF = (cAlias)->A1_EST
Else
  cUF = (cAlias)->A2_EST
EndIf

@ 100, 100 To 440, 630 Dialog oDlg Title cCadastro

@ 20, 10 SAY aFixe[3, 1]
@ 20, 60 GET cCodMun Size 40, 10 F3 "CC2GER"
@ 35, 10 SAY aFixe[5, 1]
@ 35, 60 Get cMun Size 100, 10
@ 50, 10 SAY aFixe[4, 1] 
@ 50, 60 GET cEnd SIZE 150, 10
@ 65, 10 Say aFixe[6, 1]
@ 65, 60 Get cCnpj Size 100, 10 VALID CGC(cCnpj)
@ 80, 10 Say aFixe[7, 1]
@ 80, 60 Get cIE Size 100, 10
@ 95, 10 Say aFixe[8, 1]
@ 95, 60 Get cBairro Size 100, 10
@ 110, 10 Say aFixe[9, 1]
@ 110, 60 Get cCep Size 100, 10
@ 125, 10 Say aFixe[10, 1]
@ 125, 60 Get cDDD Size 100, 10
@ 140, 10 Say aFixe[11, 1]
@ 140, 60 Get cTel Size 100, 10

ACTIVATE DIALOG oDlg CENTER ON INIT ;
EnchoiceBar(oDlg,{|| GravaAlt(cAlias), ODlg:End(), Nil }, {|| oDlg:End() })

Return

/***********************************************************************************
 Funcao para grava os dados no alias passado por parametro, do registro posicionado
 ***********************************************************************************/
Static Function GravaAlt(cAlias)

RecLock(cAlias, .F.)

(cAlias)->&(aFixe[3,2]) := cCodMun
(cAlias)->&(aFixe[4,2]) := cEnd
(cAlias)->&(aFixe[5,2]) := cMun
(cAlias)->&(aFixe[6,2]) := cCnpj
(cAlias)->&(aFixe[7,2]) := cIE
(cAlias)->&(aFixe[8,2]) := cBairro
(cAlias)->&(aFixe[9,2]) := cCep
(cAlias)->&(aFixe[10,2]) := cDDD
(cAlias)->&(aFixe[11,2]) := cTel

(cAlias)->(MsUnlock())
Return .T.