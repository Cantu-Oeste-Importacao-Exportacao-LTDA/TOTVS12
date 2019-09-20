#Include "PROTHEUS.CH"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CadKitProd ºAutor  ³Flavio Dias         º Data ³  10/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ CAdastro de Kit de produtos para o Pocket                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cantu Vitorino - SFA                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function CadKitProd()
Private cCadastro := "Kit de Produtos"
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
								    {"Visualizar", "U_ManKitPr", 0, 2},;								    
								    {"Incluir", "U_ManKitPr", 0, 3},;
								    {"Alterar", "U_ManKitPr", 0, 4},;
								    {"Excluir", "U_ManKitPr", 0, 5}}
Private cAlias := "ZZD"      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea(cAlias)
DbSetOrder(01)
MBrowse(6, 1, 22, 75, cAlias)
Return Nil

/******************************************/
// Função que faz a manutenção no ZZD e ZZE, manipulando os dados de kit de produto
/******************************************/
User Function ManKitPr(cAlias, nReg, nOpc)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
Local  _aCpoEnchoice	:= {}      
Local  _aHeaderSave := {}
Local  _aColsSave   := {}
Local  _cTitulo		:= ""
Local  _cAliasEnchoice	:= ""
Local  _cAliasGetD  := ""
Local  _cLinOk      := ""
Local  _cTudOk      := ""
Local  _cFieldOk    := ""
Local  _nUsado      := 0
Local  _ni          := 0 
Local  _nPosIt      := 0
Local  _nOpcE       := 0 
Local  _nOpcG       := 0
Local _cOpcao 		:= "V"
Private _bHabilita	:= .T. // Variavel utilizada no X3_WHEN dos campos do SZ3
// seta a opção usada

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if nOpc == 3
  _cOpcao := "I"
Elseif nOpc == 4
  _cOpcao := "A"
Elseif nOpc == 5
  _cOpcao := "E"
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
dbSelectArea("ZZD")
RegToMemory(("ZZD"),(_cOpcao = "I"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria cabecalho da gride                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("ZZE")
aHeader:={}
While !Eof().And.(X3_ARQUIVO = "ZZE")                               //¿
  If (x3_campo = "ZZE_FILIAL") .Or. (x3_campo = "ZZE_CODKIT")       //³Suprimir o codigo da gride 
	  dbSkip()                                                        //³Caso queira suprimir algum 
	  Loop                                                            //³campo da grid acrescenta-lo
  EndIf                                                             //³junto ao campo zo_mat
																					   //³
  If X3USO(x3_usado).And.cNivel>=x3_nivel                           //³Criacao da gride SZG
    _nUsado:=_nUsado+1                                              //³O primeiro campo da chave do 
	  Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;         //³indice deve ser retirado da grid
	  x3_tamanho, x3_decimal,"AllwaysTrue()",;                        //³obrigatoriamente. Neste caso
	  x3_usado, x3_tipo, x3_arquivo, x3_context } )                   //³ "ZO_MAT"
  Endif                                                                   //³
  dbSkip()                                                              //³
End                                                                         //Ù

aCols:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando Itens no gride³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZZE")
dbSetOrder(1)
dbSeek(xFilial("ZZE")+M->ZZD_CODKIT)
While (!Eof()) .And. (ZZE_CODKIT = M->ZZD_CODKIT) .And. (ZZE_FILIAL = xFilial("ZZE"))
  aADD(aCols,Array(_nUsado+1))
  For _ni:=1 to _nUsado
		If aHeader[_ni,10] = "V"
			aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2])
		Else
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		EndIf
	Next 
	aCols[Len(aCols),_nUsado+1]:=.F.
	ZZE->(dbSkip())
End     

If (Len(aCols) = 0)   
  aCols:= {Array(_nUsado+1)}
  aCols[1,_nUsado+1]:=.F.
	For _ni:=1 to _nUsado
	  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
//	_nPosIt := aScan(aHeader, { |x| x[2] = "ZG_SEQ"})
//	aCols[1,_nPosIt] := "01"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Modelo 3                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTitulo:="Kit de Produtos"
_cAliasEnchoice:="ZZD"
_cAliasGetD:="ZZE"
_cLinOk:="AllwaysTrue()"
_cTudOk:="AllwaysTrue()"
_cFieldOk:="AllwaysTrue()"
_aCpoEnchoice := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do ZZD                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("ZZD")
While !Eof() .And. X3_ARQUIVO == cAlias  
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		Aadd(_aCpoEnchoice,x3_campo)
	Endif
	dbSkip()
End    

_lRet:=Modelo3(cCadastro,_cAliasEnchoice,_cAliasGetD,_aCpoEnchoice,_cLinOk,_cTudOk,_nOpcE,_nOpcG,_cFieldOk)
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
Local _nPosIt      := aScan(aHeader, { |x| x[2] = "ZZE_CODPRO"})
Local _cCampo     := ""
Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravo o Cabecalho ³    Caso precise gravar dados na tabela de cabecalho Habilite
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3") // Posiciono o SX3 pra gravar o cabecalho
dbSeek("ZZD")

If RecLock("ZZD", (_cOpcao = "I"))

	While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO = cAlias)
		_cCampo := SX3->X3_CAMPO
		If _cCampo = "ZZD_FILIAL"
  		&_cCampo := xFilial("ZZD") 
		Else
	    If X3USO(SX3->X3_USADO) .And. (cNivel>=SX3->X3_NIVEL)
		    &_cCampo := M->&_cCampo    
	  	Endif
  	EndIf
		SX3->(dbSkip())
	End 
  MsUnlock()                     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava os itens...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("ZZE")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varrendo o aCols...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _ni := 1 to Len(aCols)
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Se encontrou o item gravado no banco...³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		dbSelectArea("ZZE")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZE") + M->ZZD_CODKIT + aCols[_ni][_nPosIt])
  		// Se a linha estiver deletada...
 			If (aCols[_ni][_nPosDel])
	  		RecLock("ZZE",.F.)
	  		dbDelete()
	  		MsUnLock()
 		  Else
	   	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	  //³Altera o Item...³
	   	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  	  RecLock("ZZE",.F.)
	  	  For _nii := 1 to Len(aHeader)
	  		  _cCampo := ALLTRIM(aHeader[_nii,2])
	  		  &_cCampo := aCols[_ni, _nii]
	      Next
	  	  MSUnlock()
 		  EndIf      
    Else
      If !(aCols[_ni][_nPosDel])
	      RecLock("ZZE",.T.)
	  		ZZE_FILIAL := xFilial("ZZE")
	  		ZZE_CODKIT := M->ZZD_CODKIT
		   	For _nii := 1 to Len(aHeader)
					_cCampo := ALLTRIM(aHeader[_nii,2])
					&_cCampo := aCols[_ni, _nii]
		   	Next
 				MSUnlock()
  		EndIf
		EndIf
	Next  
EndIf
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
  dbSelectArea("ZZE")
  dbSetOrder(01)
  dbSeek(xFilial("ZZE") + M->ZZD_CODKIT)
  While !EOF() .And.     ZZE_CODKIT == M->ZZD_CODKIT
    RecLock("ZZE",.F.)
    dbDelete()
    MSUnlock()
    dbSkip()     
  End
  dbSelectArea("ZZD")
  RecLock("ZZD",.F.)
  dbDelete()
  MSUnlock()
End Transaction
Return