#Include "PROTHEUS.CH"
#Include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FatTransp ºAutor  ³Flavio Dias         º Data ³  10/07/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Fatura para ser usada no transporte para controle dos      º±±
±±º          ³ CTRC efetuados no sistema                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cantu Vitorino - Transporte                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function FatTransp()
Private cCadastro := "Fatura de Transporte"
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
								    {"Visualizar", "U_ManSZF", 0, 2},;								    
								    {"Incluir", "U_ManSZF", 0, 3},;
								    {"Alterar", "U_ManSZF", 0, 4},;
								    {"Excluir", "U_ManSZF", 0, 5},;
								    {"Imprimir", "U_IMPFATTR", 0, 6}}
Private cAlias := "SZF"
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea(cAlias)
DbSetOrder(01)
MBrowse(6, 1, 22, 75, cAlias)
Return Nil

/******************************************/
// Função que faz a manutenção no SZF e SZG, manipulando os dados da fatura do transporte
/******************************************/
User Function ManSZF(cAlias, nReg, nOpc)
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// seta a opção usada
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
dbSelectArea("SZF")
RegToMemory(("SZF"),(_cOpcao = "I"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria cabecario da gride                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("SZG")
aHeader:={}
While !Eof().And.(X3_ARQUIVO = "SZG")                                     //¿
  If (x3_campo = "ZG_CODIGO")                                            //³Suprimir o codigo da gride 
	  dbSkip()                                                         //³Caso queira suprimir algum 
	  Loop                                                            //³campo da grid acrescenta-lo
  EndIf                                                                   //³junto ao campo zo_mat
																					   //³
  If X3USO(x3_usado).And.cNivel>=x3_nivel                                 //³Criacao da gride SZG
    _nUsado:=_nUsado+1                                                      //³O primeiro campo da chave do 
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
dbSelectArea("SZG")
dbSetOrder(1)
dbSeek(xFilial("SZG")+ZF_CODIGO)    
While (!Eof()) .And. (ZG_CODIGO = M->ZF_CODIGO)
  aADD(aCols,Array(_nUsado+1))
  For _ni:=1 to _nUsado
		If aHeader[_ni,10] = "V"
			aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2])
		Else
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		EndIf
	Next 
	aCols[Len(aCols),_nUsado+1]:=.F.
	dbSkip()
End     
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quando o numero de itens for igual a zero, isso ocorre na inclusao de dados novos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/
If (Len(aCols) = 0)   
  aCols:= {Array(_nUsado+1)}
  aCols[1,_nUsado+1]:=.F.
	For _ni:=1 to _nUsado
	  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
	_nPosIt := aScan(aHeader, { |x| x[2] = "ZG_SEQ"})
	aCols[1,_nPosIt] := "01"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Modelo 3                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTitulo:="Fatura Transporte"
_cAliasEnchoice:="SZF"
_cAliasGetD:="SZG"
_cLinOk:="U_LINOK()"
_cTudOk:="U_LINOK()"
_cFieldOk:="AllwaysTrue()"
_aCpoEnchoice := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do SZF                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("SZF")
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
Local _nPosIt      := aScan(aHeader, { |x| x[2] = "ZG_SEQ"})
Local _cCampo     := ""
Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravo o Cabecalho ³    Caso precise gravar dados na tabela de cabecalho Habilite
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX3") // Posiciono o SX3 pra gravar o cabecalho
dbSeek("SZF")

If RecLock("SZF", (_cOpcao = "I"))

	While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO = cAlias)
		_cCampo := SX3->X3_CAMPO
		If _cCampo = "ZF_FILIAL"
  		&_cCampo := xFilial("SZF") 
		Else
	    If X3USO(SX3->X3_USADO) .And. (cNivel>=SX3->X3_NIVEL)
		    &_cCampo := M->&_cCampo    
	  	Endif
  	EndIf
		SX3->(dbSkip())
	End 
  MsUnlock()                     
  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Gravo os itens...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SZG")
	dbSetOrder(1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varrendo o aCols...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _ni := 1 to Len(aCols)
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Se encontrou o item gravado no banco...³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		dbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek(xFilial("SZG") + M->ZF_CODIGO + aCols[_ni][_nPosIt])
  		// Se a linha estiver deletada...
 			If (aCols[_ni][_nPosDel])
	  		RecLock("SZG",.F.)
	  		dbDelete()
	  		MsUnLock()
 		  Else
	   	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	  //³Altera o Item...³
	   	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  	  RecLock("SZG",.F.)
	  	  For _nii := 1 to Len(aHeader)
	  		  _cCampo := ALLTRIM(aHeader[_nii,2])
	  		  &_cCampo := aCols[_ni, _nii]
	      Next
	  	  MSUnlock()
 		  EndIf      
    Else
      If !(aCols[_ni][_nPosDel])
	      RecLock("SZG",.T.)
	  		ZG_FILIAL := xFilial("SZG")
	  		ZG_CODIGO    := M->ZF_CODIGO
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
  dbSelectArea("SZG")
  dbSeek(xFilial("SZG") + M->ZF_CODIGO)
  While !EOF() .And.     ZG_CODIGO == M->ZF_CODIGO 
    RecLock("SZG",.F.)
    dbDelete()
    MSUnlock()
    dbSkip()     
  End
  dbSelectArea("SZF")
  RecLock("SZF",.F.)
  dbDelete()
  MSUnlock()
End Transaction
Return

/**************************************************/
// Validação de digitação da linha do grid e no final
// para calcular o valor total e o sub-total
/**************************************************/
User Function LinOk()
Local i
Local nSoma := 0
Local aPosTot := aScan(aHeader, { |x| x[2] = "ZG_TOTAL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

for i:= 1 to Len(aCols)
  nSoma := aCols[i, aPosTot]
Next i
M->ZF_SUBTOT := nSoma
M->ZF_TOTAL := M->ZF_SUBTOT + M->ZF_ENVMANU + M->ZF_IMPOSTO + M->ZF_IMPOST2
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpFatTr  ºAutor  ³Flavio Dias         º Data ³  10/09/08 º  ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão da fatura de transporte usado pela cantu Vitorino º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpFatTr(cAlias, nReg, nOpc)

Local cCodigo := SZF->ZF_CODIGO
Local cNome, cCidade, cUF, cCep, cTelefone, cEndereco
Local aTexto := {}
Local wnrel := "FatTransp"
Local cTitulo := "Fatura Transporte"
Local cDesc1 := "Fatura de CTRC"
Local cDesc2 := ""
Local Tamanho := "P"
Local Limite := 80

Private aOrd := {"Padrao"}
Private aLinha:={}
Private aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg:=""
Private cabec1,cabec2,titulo,wnrel,tamanho:="M",nomeprog:="FatTransp"
Private nLastKey := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Public oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0

SetPrvt("aCA,CCADASTRO,ASAYS,ABUTTONS,NOPCA,ARETURN")
SetPrvt("NLASTKEY,CPERG")
SetPrvt("OFONT1,OFONT2,OFONT3,OFONT4,OFONT5,OFONT11,OFONT12,OFONT13,OFONT14,OFONT15")
SetPrvt("OPRN,NTPAG")

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.
SetPrvt("nLinha,nColuna")

// wnrel  := SetPrint("SZF",wnrel,"",@cTitulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)

// SetDefault(aReturn,"SZF")

nLM  :=  100	//Left Margin
nRM  := 2261	//Right Margin
nTM  :=  100	//Top Margin
nBM  := 3300	//Botton Margin
nRH  :=   50	//Line Height   original:50
nCW  :=   26	//Character Width
nRow :=    1	//Linha atual
nCol :=    1	//Coluna Atual
nRP  := nTM+3	//Posicao da Primeira Linha Atual
nCP  := nLM+3	//Posicao da Primeira Coluna Atual
nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
nCD  := nLM+0	//Posicao da Primeira Coluna (divisao) Atual
nLinha  := 1
nColuna := 1

dbSelectArea("SM0")                   // * Sigamat.emp
xNOME_EMP :=SM0->M0_NOMECOM
xEND_EMP  :=SM0->M0_ENDCOB   
xCOMP_EMP  :=SM0->M0_COMPCOB
xBAIR_EMP  :=SM0->M0_BAIRCOB
xTEL_EMP  :=SM0->M0_TEL
xFAX_EMP  :=SM0->M0_FAX
xCEP_EMP  :=SM0->M0_CEPCOB
xCID_EMP  :=SM0->M0_CIDCOB
xEST_EMP  :=SM0->M0_ESTCOB 
xCGC_EMP  :=SM0->M0_CGC 
xINSC_EMP :=SM0->M0_INSC

oPrn:=TMSPrinter():New()
oPrn:SetPortrait() // ou SetLandscape()
oPrn:SetPage(9)	//Folha A4
oPrn:Setup()

SA1->(DbSetOrder(01))
SA1->(DbSeek(xFilial("SA1") + SZF->ZF_CLIENTE + SZF->ZF_LOJA))
cNome := SA1->A1_NOME
cEndereco := SA1->A1_End
cCidade := SA1->A1_MUN
cUF := SA1->A1_EST
cCep := SA1->A1_CEP
cTelefone := SA1->A1_TEL

oPrn:Say(0,0," ",oFont1)							//Inicio

// Parte do cabeçalho da empresa
oPrn:Box(nTM,nLM,3200,nRM)							//Box q ocupa todo espaco da folha
oPrn:Box(nTM+1,nLM+1,3200-1,nRM-1)					//Box adicional p/ aumentar a largura do box acima
oPrn:Box(nTM+2,nLM+2,3200-2,nRM-2)					//Idem
oPrn:SayBitmap(nRP+15,nCP+15,"lgrl50.bmp",294,141)	//Logo Cantu

PrintS(1, 15, Upper(xNOME_EMP), 4)
PrintS(1 ,65 , "Número:    " + SZF->ZF_CODIGO,3)
PrintS(2 ,15 , AllTrim(xEND_EMP)+" "+AllTrim(xCOMP_EMP)+" "+AllTrim(xBAIR_EMP),3)
PrintS(2 ,65 , "Emissão:     " + DToC(SZF->ZF_EMISSAO),3)

PrintS(3 ,15 , "FONE: (" + SubStr(xTEL_EMP,2,2) + ") " + SubStr(xTEL_EMP,4,8),3)
PrintS(3 ,65, "Vencimento:" + DToC(SZF->ZF_VENCIME),3)
PrintS(4 ,15, "CNPJ: " + xCGC_EMP + "      IE:" + xINSC_EMP,3)
PrintS(4 ,65, "Moeda:        " + AllTrim(SZF->ZF_MOEDA),3)
DrawH(5, 1, 84, 3)
PrintS(6, 35, "F A T U R A", 5)

nPag += 1

PrintS(8 ,02, "Cliente:",3)
PrintS(8 ,13, AllTrim(cNome),3)
// PrintS(8, 50, "Data Emissão:", 3)
// PrintS(8, 65, DToS(SZF->ZF_EMISSAO), 3)

PrintS(9, 02, "Endereço:", 3)
PrintS(9, 13, AllTrim(cEndereco), 3)
PrintS(10, 02, "Cidade:", 3)
PrintS(10, 13, AllTrim(cCidade) + " - " + cUF + "  CEP " + cCep, 3)
PrintS(11, 02, "Telefone:", 3)
PrintS(11, 13, cTelefone, 3)
PrintS(12, 02, "Exportador:", 3)
PrintS(12, 13, Posicione("SA1",01, xFilial("SA1") + SZF->ZF_EXPORTA + SZF->ZF_LOJAEXP, "A1_NOME"), 3)
PrintS(13, 02, "Importador:", 3)
PrintS(13, 13, Posicione("SA1",01, xFilial("SA1") + SZF->ZF_IMPORTA + SZF->ZF_LOJAIMP, "A1_NOME"), 3)
PrintS(14, 02, "CRT:", 3)
PrintS(14, 13, SZF->ZF_CRT, 3)
DrawH (15, 1, 84, 3)
PrintS(16, 02, "Qtde", 3)
PrintS(16, 10, "Descrição", 3)
PrintS(16, 59, "Preço Unit.", 3)
PrintS(16, 74, "Total", 3)
DrawH (17, 1, 84, 3)
// desenha as linhas verticais
DrawV(17,09,56,3)
DrawV(17,56,56,3)
DrawV(17,70,62,3)
nLinha := 18

SZG->(DbSetOrder(01))
SZG->(DbSeek(xFilial("SZG") + SZF->ZF_CODIGO))
While (SZG->ZG_CODIGO == SZF->ZF_CODIGO) .And. SZG->(!Eof()) .And. SZG->ZG_FILIAL == xFilial("SZG")
	PrintS(nLinha, 01, Transform(SZG->ZG_QTDE, "@E 9,999"), 3)
	aTexto := {}
	QuebraTexto(aTexto, SZG->ZG_DESCRI, 60)
	PrintS(nLinha, 10, aTexto[1], 3)  
  PrintS(nLinha, 59, Transform(SZG->ZG_PRCUNI, "@E 999,999.99"), 3)
  PrintS(nLinha, 72, Transform(SZG->ZG_TOTAL, "@E 9,999,999.99"), 3)  
  For i:= 2 to Len(aTexto)
    nLinha++
    PrintS(nLinha, 10, aTexto[i], 3)
  Next i
  nLinha++
  SZG->(DbSkip())
EndDo
nLinha := 56

DrawH(nLinha, 1, 84, 3)
// linha que divide os totalizadores
DrawV(nLinha,50,62,3)
nLinha++
PrintS(nLinha, 51, "Sub Total", 3)
PrintS(nLinha, 72, Transform(SZF->ZF_SUBTOT, "@E 9,999,999.99"), 3)
nLinha++
PrintS(nLinha, 51, "Envio e Manuseio", 3)
PrintS(nLinha, 72, Transform(SZF->ZF_ENVMANU, "@E 9,999,999.99"), 3)
nLinha++
PrintS(nLinha, 51, "Impostos", 3)
PrintS(nLinha, 72, Transform(SZF->ZF_IMPOSTO, "@E 9,999,999.99"), 3)
nLinha++
PrintS(nLinha, 51, "Impostos", 3)
PrintS(nLinha, 72, Transform(SZF->ZF_IMPOST2, "@E 9,999,999.99"), 3)
nLinha++
PrintS(nLinha, 51, "TOTAL (" + AllTrim(SZF->ZF_MOEDA) + ")", 4)
PrintS(nLinha, 70, Transform(SZF->ZF_TOTAL, "@E 9,999,999.99"), 4)

oPrn:EndPage()

Set Device To Screen
If aReturn[5] == 1
	Set Printer To
	OurSpool(WnRel)
Endif

FT_PFlush()	
oPrn:Preview()
MS_FLUSH()

Return .T.

// Função que divide o texto conforme as linhas necessárias
Static Function QuebraTexto(aRet, cTexto, nTam)
Local nLi, nCt
Local cMensagem 
// Faz a impressão do Memo que contém os dados adicionais da NF
if (aRet == nil)
  aRet := {}
EndIf
nLi := MLCount(cTexto, nTam, 2, .T.)
For nCt := 1 to nLi 
  cMensagem := MemoLine(cTexto, nTam, nCt, 2, .T.)  
  aAdd(aRet, cMensagem)
Next

Static Function PrintS(pfRow,pfCol,pfText,pfFont)
	oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
	oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
	oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
	oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
	oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
	oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
	oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
	oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
	oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. ) 
	oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )
	Do Case 
		Case pfFont == 1
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont1)
		Case pfFont == 2
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont2)
		Case pfFont == 3				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont3)
		Case pfFont == 4
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont4)
		Case pfFont == 5
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont5)		
		Case pfFont == 11
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont11)
		Case pfFont == 12
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont12)
		Case pfFont == 13				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont13)
		Case pfFont == 14		
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont14)
		Case pfFont == 15
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont15)		
	EndCase	
Return

Static Function DrawH(dhRow,dhCol,dhWidth,dhPen)
	While dhPen >= 1
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
		dhPen:=dhPen-1
	EndDo
Return

Static Function DrawV(dvRow,dvCol,dvHeight,dvPen) 
	If dvRow==0 	//Ajuste para quando a linha comecar na posicao zero.
		nLineZero:=10
	Else
		nLineZero:=0
	EndIf
	While dvPen >= 1
		oPrn:Line (nRD+(nRH*(dvRow-1))+nLineZero,nCD+(nCW*(dvCol-1))+(dvPen-1),nRD+(nRH*(dvHeight-1)),nCD+(nCW*(dvCol-1))+(dvPen-1) )
		dvPen:=dvPen-1
	EndDo
Return