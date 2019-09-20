#Include "PROTHEUS.CH"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FatTransp ºAutor  ³Flavio Dias         º Data ³  10/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monitoramento de pedidos nao sincronizados do palm         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cantu Vitorino - Faturamento                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MANUTHC5()
Private cCadastro := "Pedidos Palm com rejeição"
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
								    {"Visualizar", "u_ManHC5", 0, 2},;								    
								    {"Alterar", "U_ManHC5", 0, 4},;
								    {"Excluir", "U_ManHC5", 0, 5}}
Private cAlias := "HC5"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea(cAlias)
DbSetOrder(01)
// faz o filtro para mostrar somente os pedidos não sincronizados
HC5->(DbSetFilter({|| HC5->HC5_STATUS == "N  "}, "(0 == 0)"))
MBrowse(6, 1, 22, 75, cAlias)
HC5->(DbClearFilter())
Return Nil

/******************************************/
// Função que faz a manutenção no HC5 e HC6, permitindo excluir ou alterar os pedidos que vieram do palm
/******************************************/
User Function ManHC5(cAlias, nReg, nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local  _aCpoEnchoice      := {}      
Local  _aHeaderSave    := {}
Local  _aColsSave         := {}
Local  _cTitulo          := ""
Local  _cAliasEnchoice     := ""
Local  _cAliasGetD          := ""
Local  _cLinOk               := ""
Local  _cTudOk               := ""
Local  _cFieldOk          := ""
Local  _nUsado           := 0
Local  _ni                     := 0 
Local  _nPosIt           := 0
Local  _nOpcE               := 0 
Local  _nOpcG               := 0
Local _cOpcao := "V"
Private _bHabilita           := .T. // Variavel utilizada no X3_WHEN dos campos do SZ3
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private lRetOk := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// seta a opção usada
if nOpc == 3
  _cOpcao := "A"
Elseif nOpc == 4
  _cOpcao := "E"
//Elseif nOpc == 5
//  _cOpcao := "E"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case _cOpcao ="I"; _nOpcE:=3 ; _nOpcG:=3; _bHabilita := .T. 
  Case _cOpcao ="A"; _nOpcE:=4 ; _nOpcG:=3; _bHabilita := .F. 
  Case _cOpcao ="V"; _nOpcE:=2 ; _nOpcG:=2; _bHabilita := .F. 
  Case _cOpcao ="E"; _nOpcE:=2 ; _nOpcG:=2; _bHabilita := .F. 
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se o aHeader e o aCols estiverem declarados (se esta       ³
//³rotina estiver sendo chamada de outra qq, como o MATA103), ³
//³guardo os valores dos mesmos para depois restaurar.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If (Type("aHeader")!="U")
  _aHeaderSave := aClone(aHeader)
  _aColsSave   := aClone(aCols)    
  aHeader       := {}
  aCols            := {}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("HC5")
RegToMemory(("HC5"),(_cOpcao = "I"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria cabecario da gride                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Mod2aHeader()                                                                        //Ù

aCols:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando Itens no gride³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("HC6")
dbSetOrder(1)
dbSeek(xFilial("HC6") + HC5->HC5_ID + HC5->HC5_NUM)    
While (!Eof()) .And. (xFilial("HC6") + HC5->HC5_ID + HC5->HC5_NUM = HC6_FILIAL + HC6_ID + HC6_NUM)
  aADD(aCols,Array(Len(aHeader)+1))
  For _ni:=1 to Len(aHeader)
		If aHeader[_ni,10] = "V"
			aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2])
		Else
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		EndIf
	Next 
	aCols[Len(aCols),Len(aHeader)+1]:=.F.
	dbSkip()
End     
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando o numero de itens for igual a zero, isso ocorre na inclusao de dados novos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
If (Len(aCols) = 0)   
  aCols:= {Array(Len(aHeader)+1)}
  aCols[1,Len(aHeader)+1]:=.F.
	For _ni:=1 to Len(aHeader)
	  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
	_nPosIt := aScan(aHeader, { |x| x[2] = "HC6_ITEM"})
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Modelo 3                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTitulo:="Pedidos do Palm com Rejeição"
_cAliasEnchoice:="HC5"
_cAliasGetD:="HC6"
_cLinOk:="AllwaysTrue()"
_cTudOk:="AllwaysTrue()"
_cFieldOk:="AllwaysTrue()"
_aCpoEnchoice := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do HC5                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("HC5")
While !Eof() .And. X3_ARQUIVO == cAlias  
  If X3USO(x3_usado).And.cNivel>=x3_nivel
	   Aadd(_aCpoEnchoice,x3_campo)
  Endif
  dbSkip()
End    

_lRet := Mnt_HC5(cAlias)
//Modelo3(cCadastro,_cAliasEnchoice,_cAliasGetD,_aCpoEnchoice,_cLinOk,_cTudOk,_nOpcE,_nOpcG,_cFieldOk)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executar processamento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lRet
  If _cOpcao = "I" .Or. _cOpcao = "A"
	  GravaDados(_cOpcao)
  Elseif _cOpcao = "E"
	  ExcluiDados()
  EndIf
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Se existe o aHeader backupeado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Len(_aHeaderSave) > 0    
  aHeader := aClone(_aHeaderSave)
  aCols   := aClone(_aColsSave)    
EndIf
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³GravaDadosºAutor ³FLAVIO Dias           º Data ³ 07/10/2008 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que gravara os dados da Modelo 3...                 º±±
±±º          ³ _cOpcao = Opcao de Operacao ("INCLUIR" ou "ALTERAR")       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 - CEPROMAT                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function GravaDados(_cOpcao)
Local _nPosDel      := Len(aHeader) + 1
Local _nPosIt      := aScan(aHeader, { |x| x[2] = "ZG_SEQ"})
Local _cCampo     := ""
Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravo o Cabecalho ³    Caso precise gravar dados na tabela de cabecalho Habilite
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbSelectArea("SX3") // Posiciono o SX3 pra gravar o cabecalho
//dbSeek("HC5")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava os itens...³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("HC6")
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Varrendo o aCols...³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
For _ni := 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se encontrou o item gravado no banco...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	dbSelectArea("HC6")
	dbSetOrder(1)
	HC6->(DbSeek(xFilial("HC6") + HC5->HC5_ID + HC5->HC5_NUM + aCols[_ni, 1]))
	// Se a linha estiver deletada...
	If (aCols[_ni][_nPosDel])
  	RecLock("HC6",.F.)
  	dbDelete()
  	MsUnLock() 	
	EndIf      
Next  
End Transaction
Return           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³ExcluiDadosºAutor ³FLAVIO SILVA        º Data ³ 13/05/2002 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao que excluira os dados da Modelo 3...                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP5 - CEPROMAT                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ExcluiDados()
Begin Transaction
  dbSelectArea("HC6")
  dbSeek(xFilial("HC6") + HC5->HC5_ID + HC5->HC5_NUM)
  While !EOF() .And.     HC6->HC6_FILIAL + HC6->HC6_ID + HC6->HC6_NUM == xFilial("HC6") + HC5->HC5_ID + HC5->HC5_NUM
    RecLock("HC6",.F.)
    dbDelete()
    MSUnlock()
    dbSkip()     
  End
  dbSelectArea("HC5")
  RecLock("HC5",.F.)
  dbDelete()
  MSUnlock()
End Transaction
Return

/**************************************************************************
 Funçao para permitir a exclusão de um produto vindo do palm, 
 permitindo que seja sincronizado os demais sem erro.
 **************************************************************************/
Static Function Mnt_HC5(cAlias)
    
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2	

dbSelectArea( cAlias )

DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

	oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.T.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_BOTTOM
			
	oGet := MSGetDados():New(0,0,0,0,1, , .T., "", .T., {}, , , Len(aCols))
	
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
EnchoiceBar(oDlg,{|| (lRetOk := .T.), ODlg:End(), Nil }, {|| oDlg:End() })
Return lRetOk

// Cria o objeto aHeader
Static Function Mod2aHeader()
aHeader := {}
// Montagem do aHeader
aAdd(aHeader,{"Item"		,"HC6_ITEM","@!",3,0,"AllwaysTrue()", "","C","","R"})
aAdd(aHeader,{"Produto"		,"HC6_PROD","@!",15,0,"AllwaysTrue()", "SB1","C","","R"})
aAdd(aHeader,{"Quantidade"	,"HC6_QTDVEN","@E 999,999,999.9999",12,4,"AllwaysTrue()", "","N","","R"})
aAdd(aHeader,{"Preço","HC6_PRCVEN","@E 999,999,999.9999",40,0,"AllwaysTrue()", "","N","","R"})
aAdd(aHeader,{"Total","HC6_VALOR","@E 999,999,999.9999",8,0,"AllwaysTrue()", "","N","","R"}) 

Return