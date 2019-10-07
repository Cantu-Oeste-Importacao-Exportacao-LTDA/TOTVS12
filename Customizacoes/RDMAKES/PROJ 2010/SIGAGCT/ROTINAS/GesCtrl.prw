#Include "PROTHEUS.CH"
#Include "rwmake.ch"
#include "TBICONN.CH"
#include "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GesCtrl    ºAutor  ³Flavio Dias        º Data ³  10/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍº±±
±±ºDesc.     ³Rotina desenvolvida para substituir a gestão de contrato    º±±
±±           ³Neste fonte se localizará a manutenção do contrato 		  º±±
±±           ³possibilitando a inclusão, alteração e exclusão do mesmo	  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

/************************************************************
 Rotina desenvolvida para substituir a gestão de contrato
 Neste fonte se localizará a manutenção do contrato possibilitando
 a inclusão, alteração e exclusão do mesmo.
 ************************************************************/
User Function GesCtrl()
Local cAlias := "Z39"
Private cCadastro := "Manutenção de Contratos"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "U_MNTGESCT", 0, 2})
aAdd(aRotina, {"Incluir"   , "U_MNTGESCT", 0, 3})
aAdd(aRotina, {"Alterar"   , "U_MNTGESCT", 0, 4})
aAdd(aRotina, {"Excluir"   , "U_MNTGESCT", 0, 5})
aAdd(aRotina, {"Suspender"  , "U_MNTGESCT", 0, 6}) // suspende o pagamento de um mês em específico
aAdd(aRotina, {"Cancelar"   , "U_MNTGESCT", 0, 7})
aAdd(aRotina, {"Fazer Medição", "U_INCMEDGCT", 0, 8})
aAdd(aRotina, {"Excluir Medição", "U_EXCMEDGCT", 0, 9})
aAdd(aRotina, {"Prox. Medições", "U_PROMEDGCT", 0, 10})

//VARIAVEIS AFILL IMPORT
Public lImpOk     := .F.
Public lxAbre     := .T.
Public aCabImp    := {}
Public axOcorren  := {}
Public xaHPFin    := {}
Public xaDesPFinP := {}
Public xaVetPFinP := {}
Public xcPCNumImp := ""
Public xcPCNum2   := "" 
Public xcMenPImp  := ""	
Public xnHPFin    := 0
Public xoLbxPRE1  := Nil
Public xbLinePRE1 := Nil
Public xoMenPImp  := Nil
Public xoAbert    := LoadBitmap( GetResources(), "ENABLE" )
Public xoSaldo    := LoadBitmap( GetResources(), "BR_AMARELO" )
Public xoFecha    := LoadBitmap( GetResources(), "DISABLE" )
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MNTGESCT   ºAutor  ³Flavio Dias        º Data ³  10/04/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Manutencao de um contrato, inlcusão, alteracao e exclusão.  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MNTGESCT( cAlias, nReg, nOpc )
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
Local aSize     := MsAdvSize( .F. )
Local aButtons  := {	{ "S4WB011N"   , { || GdSeek(oGetD, OemtoAnsi("Localizar")) }, OemtoAnsi("Localizar"), OemtoAnsi("Localizar") } }
Local oFld
Local aFieldMed := {"Z41_SEQMED", "Z41_SEQUEN", "Z41_DATMED", "Z41_PRODUT", "Z41_QUANT", "Z41_VALMED", "Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_VALPRE", "Z41_NUMPED", "Z41_OBSMED"}
Local aFieldTit := {"E2_PREFIXO","E2_NUM","E2_PARCELA","E2_EMISSAO","E2_VALOR","E2_VENCTO"}
Local aColsMed := {}
Local aColsTit := {}
Local aHeaderTit := {}
Local aHeaderMed := {}
Local oGetTit
Local oGetMed

Private _bHabilita           := .T. // Variavel utilizada no X3_WHEN dos campos do SZ3
PRIVATE aCols   := {}
PRIVATE aHeader := {}

// Usados na tela de parcelas
Private aColsEx := {}
Private aHeaderEx := {}

Private oDlg
Private oGetD
Private oEnch
Private aTELA[0][0]
Private aGETS[0]
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (nOpc == 5 .And. Z39->Z39_QTDMED > 0)
	MsgStop("Não pode ser excluído contrato com medições efetuadas")
	Return
endif

if ((nOpc > 3 .And. nOpc # 8) .And. Z39->Z39_STATUS $ "02/03")
	MsgStop("Operação não permitida para contrato Cancelado ou Finalizado")
	Return
endif

// valida se o usuário tem permissão
if ((nOpc > 3) .And. (AllTrim(Z39->Z39_USER) # Trim(cUserName) .AND.;
			 AllTrim(Z39->Z39_USER2) # Trim(cUserName) .AND. ;
			 AllTrim(Z39->Z39_USER3) # Trim(cUserName) .AND. Upper(AllTrim(cUserName)) # "ADMINISTRADOR" ))
	MsgStop("Usuário não tem permissão sobre o contrato")
	Return
endif

// seta a opção usada
if nOpc == 3
	_cOpcao := "I"
Elseif nOpc == 4
	_cOpcao := "A"
Elseif nOpc == 5
	_cOpcao := "E"
Elseif nOpc == 6
	_cOpcao := "S"
Elseif nOpc == 7
	_cOpcao := "C"
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
  aHeader      := {}
  aCols        := {}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("Z39")                
cNumCon := ""
if (_cOpcao == "I")
	cNumCon := GetSXENUM("Z39", "Z39_NUM")
EndIf

RegToMemory("Z39",(_cOpcao == "I"))
M->Z39_NUM := cNumCon

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria cabecalho da gride                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SX2->( dbSetOrder( 1 ) )
SX2->( dbSeek("Z40") )
dbSelectArea("SX3")
dbSetOrder(01)
dbSeek("Z40")
aHeader:={}
While !Eof().And.(X3_ARQUIVO = "Z40")                                     
  If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
			!AllTrim(SX3->X3_CAMPO) $ "Z40_FILIAL|Z40_NUM" )
		_nUsado++
		aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT} )
	EndIf                                                              
  SX3->( dbSkip() )                                                  
End                                                                  

aCols:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando Itens no gride³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
if (_cOpcao != "I")
	M->Z39_NUM := Z39->Z39_NUM
	dbSelectArea("Z40")
	dbSetOrder(1)
	dbSeek(xFilial("Z40")+Z39->Z39_NUM)    
	While (!Eof()) .And. (Z40->Z40_FILIAL+Z40->Z40_NUM == Z39->Z39_FILIAL + Z39->Z39_NUM)
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
EndIf


If (Len(aCols) = 0)   
	aCols:= {Array(_nUsado+1)}
	aCols[1,_nUsado+1]:=.F.
	For _ni:=1 to _nUsado
	  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
	_nPosIt := aScan(aHeader, { |x| x[2] = "Z40_SEQUEN"})
	aCols[1,_nPosIt] := "01"
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executa a Modelo 3                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cTitulo:="Manutenção Contrato"
_cAliasEnchoice:="Z39"
_cAliasGetD:="Z40"
_cTudOk:="U_GesCtrlTOK()"
_cFieldOk:="AllwaysTrue()"
_aCpoEnchoice := {}
_nModelo := 1
_lF3 := .F.
_lMemoria := .T.
_lColumn := .F.
_caTela := "" 
_lNoFolder := .F.
_lProperty := .F.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cabecalho do Z39                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3")
dbSeek("Z39")
While !Eof() .And. X3_ARQUIVO == cAlias  
  If X3USO(x3_usado).And.cNivel>=x3_nivel
	   Aadd(_aCpoEnchoice,x3_campo)
  Endif
  dbSkip()
End 

if (nOpc == 3)
	M->Z39_USER := cUsername
end
              
aObjects := {}
AAdd( aObjects, { 100, 100, .T., .F. } )
AAdd( aObjects, { 100, 100, .T., .T. } )

aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
aPosObj := MsObjSize( aInfo, aObjects )

_aPos := {002,aPosObj[2,2],102,aPosObj[2,4]}
if M->Z39_QTDMED > 0
	_aAlterEnch := {"Z39_QUANT", "Z39_USER", "Z39_USER2","Z39_USER3", "Z39_ALTSEG", "Z39_ALTVAL"}
	aAltGetD := {"Z40_QUANT", "Z40_TOTAL", "Z40_STATUS"}
else
	_aAlterEnch := aClone(_aCpoEnchoice)
	aAltGetD := {"Z40_PRODUT", "Z40_SEGTO", "Z40_CC", "Z40_CONTA", "Z40_QUANT", "Z40_TOTAL", "Z40_STATUS"}
endif
 
_lRet := .F. 

nOpcGrid := iif(nOpc > 5, 2, nOpc)

//  obtém as medições efetuadas
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFieldMed)
  If SX3->(DbSeek(aFieldMed[nX]))
    Aadd(aHeaderMed, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"allwaystrue()",;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

//  busca os dados do banco
aColsMed := {}
dbSelectArea("Z41")
dbSetOrder(01)
if (_cOpcao != "I")          //Validar para quando for inclusão não mostrar a medição do último contrato - Gustavo 24/02/2014
	dbSeek(xFilial("Z41") + Z39->Z39_NUM)   
	while xFilial("Z41") + Z39->Z39_NUM == Z41_FILIAL + Z41_NUM
 		aFieldFill := {}
 		For nX := 1 to Len(aFieldMed)
			aAdd(aFieldFill, &(aFieldMed[nX]))
		Next nX
 		aAdd(aFieldFill, .F.)
 		aAdd(aColsMed, aFieldFill)
 		dbskip()   
	enddo
EndIf

// Se estiver em branco, adiciona uma linha para não dar erro
if Len(aColsMed) == 0
	aFieldFill := {}
	For nX := 1 to Len(aFieldMed)
		aAdd(aFieldFill, CriaVar(aFieldMed[nX]))
	Next nX                                                                              
	aAdd(aFieldFill, .F.)
	aAdd(aColsMed, aFieldFill)
endif
// Ordena os itens da medição por sequência de medição e sequencia de item.
aSort(aColsMed,,,{ |x,y| x[1]+x[2] < y[1]+y[2]})

//  obtém os títulos
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFieldTit)
  If SX3->(DbSeek(aFieldTit[nX]))
    Aadd(aHeaderTit, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"allwaystrue()",;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

// busca os dados do banco
aColsTit := {}
dbSelectArea("SE2")
dbSetOrder(06)// FILIAL + FORNECEDOR + LOJA + PREFIXO + NUMERO + PARCELA + TIPO
dbSeek(xFilial("SE2") + Z39->Z39_FORNECE + Z39->Z39_LOJA + "GCT" + Z39->Z39_NUM)
while xFilial("SE2") + Z39->Z39_FORNECE + Z39->Z39_LOJA + "GCT" + Z39->Z39_NUM == E2_FILIAL + E2_FORNECE + E2_LOJA + E2_PREFIXO + E2_NUM
	aFieldFill := {}
	if (AllTrim(E2_TIPO) == 'PR')
		For nX := 1 to Len(aFieldTit)
			aAdd(aFieldFill, &(aFieldTit[nX]))
		Next nX
		aAdd(aFieldFill, .F.)
		aAdd(aColsTit, aFieldFill)
	endif
	dbskip()
enddo

// Se estiver em branco, adiciona uma linha para não dar erro
if Len(aColsTit) == 0
	aFieldFill := {}
	For nX := 1 to Len(aFieldTit)
		aAdd(aFieldFill, CriaVar(aFieldTit[nX]))
	Next nX
	aAdd(aFieldFill, .F.)
	aAdd(aColsTit, aFieldFill)
endif


DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 000, 000 FOLDER oFld SIZE 10, 10 OF oDlg ITEMS "Contrato","Medições","Títulos Provisórios" COLORS 0, 16777215 PIXEL  
	oFld:Align := CONTROL_ALIGN_ALLCLIENT

	Enchoice(_cAliasEnchoice, nReg, nOpcGrid, /*aCRA*/, /*cLetra*/, /*cTexto*/,;
		_aCpoEnchoice, _aPos, _aAlterEnch, _nModelo, /*nColMens*/,;
		/*cMensagem*/,/*cTudoOk*/, oFld:aDialogs[1], _lF3, _lMemoria,_lColumn,;
		_caTela, _lNoFolder, _lProperty)
   
	oGetD:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3] - 30,aPosObj[2,4], nOpcGrid,"AllwaysTrue","AllwaysTrue","+Z40_SEQUEN+" ,.T., ;
				aAltGetD, ,.F., iif(M->Z39_QTDMED == 0, 999, Len(aCols)), "U_GesctlrFOK",,,"U_GesctlrDOK", oFld:aDialogs[1])
				
	// Browse das medições
	oGetMed := MsNewGetDados():New( aPosObj[2,1] - 80, aPosObj[2,2], aPosObj[2,3] -30, aPosObj[2,4], GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", {},, 999, "AllwaysTrue", "", "AllwaysTrue", oFld:aDialogs[2], aHeaderMed, aColsMed)
	@005, 005 BUTTON "Abrir Pedido" Action OpenPed(oGetMed) of oFld:aDialogs[2] PIXEL
	@005, 140 BUTTON "Gerar Pré-Nota" Action GeraPreNF(oGetMed) of oFld:aDialogs[2] PIXEL
	// Browse das parcelas
	oGetTit := MsNewGetDados():New( aPosObj[2,1] - 80, aPosObj[2,2], aPosObj[2,3] -30, aPosObj[2,4], GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", {},, 999, "AllwaysTrue", "", "AllwaysTrue", oFld:aDialogs[3], aHeaderTit, aColsTit)
	@005, 005 BUTTON "Abrir Título" Action OpenTit(oGetTit) of oFld:aDialogs[3]  PIXEL
	
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| _lRet:=.T., Iif(U_GesCtrlTOK(nOpc), oDlg:End(),_lRet:=.F.)  } , {||fVoltaSxe(_cOpcao),oDlg:End()},,aButtons)

//_lRet:=Modelo3(cCadastro,_cAliasEnchoice,_cAliasGetD,_aCpoEnchoice,_cLinOk,_cTudOk,_nOpcE,_nOpcG,_cFieldOk) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Executar processamento                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If _lRet
  
  // Mostra tela para verificar as parcelas geradas
  if !VldParcela(_cOpcao)
  	Return
  EndIf
  If _cOpcao $ "I/A/S/C"
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

                                                                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se o usuário está cancelando um processo de exclusão para fazer RollBack do SXE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fVoltaSxe(cOpcao)
if cOpcao == "I"
	RollBackSXE()
EndIf
Return Nil

// Função para visualizar o pedido gerado
Static Function OpenPed(oGrid)
Local nLin := oGrid:oBrowse:nAt
Local aArea := GetArea()
Local aOldHeader	:= aClone(aHeader),;
		aOldaCols	:= aClone(aCols),;
		aOldaRotina	:= aClone(aRotina),;
		cFilOld     := cFilAnt

Private __CCPGPEDC := ""
if !Empty(oGrid:aCols[nLin, 1])
	dbSelectArea("SC7")
	dbSetOrder(01)
	dbSeek(xFilial("SC7") + oGrid:aCols[nLin, 11])
	MatA120(SC7->C7_TIPO,,,2)
	RestArea(aArea)
	aHeader	:= aClone(aOldHeader)
	aCols		:= aClone(aOldaCols)
	aRotina	:= aClone(aOldaRotina)
	cFilant  := cFilOld
endif
Return

// Função que faz a geração da pré-nota do pedido
Static Function GeraPreNF(oGrid)
Local nLin := oGrid:oBrowse:nAt
Local aArea := GetArea()
Local aOldHeader	:= aClone(aHeader),;
		aOldaCols	:= aClone(aCols),;
		aOldaRotina	:= aClone(aRotina),;
		cFilOld     := cFilAnt

if !Empty(oGrid:aCols[nLin, 1])
	

  MsgInfo("Ainda não implementado")

	RestArea(aArea)
	aHeader	:= aClone(aOldHeader)
	aCols		:= aClone(aOldaCols)
	aRotina	:= aClone(aOldaRotina)
	cFilant  := cFilOld
endif
Return

// Funcao para abrir o título selecionado
Static Function OpenTit(oGrid)
Local nLin := oGrid:oBrowse:nAt
Local aArea := GetArea()
Local aOldHeader	:= aClone(aHeader),;
		aOldaCols	:= aClone(aCols),;
		aOldaRotina	:= aClone(aRotina),;
		cFilOld     := cFilAnt
if !Empty(oGrid:aCols[nLin, 1])
	dbSelectArea("SE2")
	dbSetOrder(01) 
	// FILIAL + PREFIXO + NUMERO + PARCELA + TIPO + FORNECEDOR + LOJA
	dbSeek(xFilial("SE2") + oGrid:aCols[nLin, 1] + oGrid:aCols[nLin, 2] + oGrid:aCols[nLin, 3] + "PR " + M->Z39_FORNEC + M->Z39_LOJA)
	AxVisual("SE2", SE2->(RecNo()), 2)
	RestArea(aArea)
	aHeader	:= aClone(aOldHeader)
	aCols		:= aClone(aOldaCols)
	aRotina	:= aClone(aOldaRotina)
	cFilant  := cFilOld
endif
Return

// Exibição e validação das parcelas do contrato
Static Function VldParcela(_cOpcao)
Local lOk := .T.
Local nX
Local aFieldFill := {}
Local aFields := {"E2_PREFIXO","E2_NUM","E2_PARCELA","E2_EMISSAO","E2_VALOR","E2_VENCTO"}
Local aAlterFields := {"E2_VALOR", "E2_VENCTO"}
Local aButtons  := {	{ "S4WB011N"   , { || GdSeek(oGetTit, OemtoAnsi("Localizar")) }, OemtoAnsi("Localizar"), OemtoAnsi("Localizar") },;
											{"NOTE",{||U_GCtrTotPar()}, "Totalizar", "Totalizar"} }
											// {"POSCLI" , {|| U_RJ120PAR(.T.,.T.,.F.) }, "Fluxo de caixa", "Fluxo CX" }
Private oDlg2
Private oGetTit

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"allwaystrue()",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values    
  // Faz seleção no SE2 pelo número do contrato
  cSql := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_EMISSAO, E2_VALOR, E2_VENCTO FROM " + RetSqlName("SE2")
  cSql += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' "
  cSql += " AND E2_NUM = '" + M->Z39_NUM + "' AND D_E_L_E_T_ = ' ' AND E2_TIPO = 'PR' AND E2_PREFIXO = 'GCT' "
  cSql += " ORDER BY E2_PREFIXO, E2_NUM, E2_VENCTO "
  TcQuery cSql New Alias "TMPSE2" 
  
  TCSetField('TMPSE2', "E2_EMISSAO", "D", 8, 0)
  TCSetField('TMPSE2', "E2_VENCTO", "D", 8, 0)
  
  // Inicia a vigência na primeira parcela
  dDataPar = M->Z39_DTINIV
  cParcAt := "000"
  nValCT := 0
  
  // obtém o valor
  nPosTot 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_TOTAL"})
  if (_cOpcao != "X")
	  For nX := 1 to len(aCols)
	  	if !aCols[nX, Len(aHeader) + 1]
	  		nValCt += aCols[nX, nPosTot]
	  	endif
	  Next nX
	else
		// localiza pelo alias z40.
		Z40->(dbSetOrder(01))
		Z40->(dbSeek(xFilial("Z40") + M->Z39_NUM))
		while xFilial("Z40")+M->Z39_NUM == Z40->Z40_FILIAL + Z40->Z40_NUM
			nValCt += Z40->Z40_TOTAL
			Z40->(dbSkip())
		enddo
		_cOpcao := "A"
	endif
  
  nParc := M->Z39_QUANT - M->Z39_QTDMED
  nAdd := 0  
  aFieldFill := {}
  
  // Faz o rateio de quanto ainda falta para pagar, de acordo com as medições
  nValPag := Round(nValCt * (nParc / M->Z39_QUANT), 2)
  nValPend := nValPag
  While TMPSE2->(!Eof())
    For nX := 1 to Len(aFields)	    
	    Aadd(aFieldFill, TMPSE2->(FieldGet(nX)))
	  Next nX
	  Aadd(aFieldFill, .F.)
	  Aadd(aColsEx, aFieldFill)    
  	
  	// Atualiza a data da parcela
  	dDataPar := TMPSE2->E2_VENCTO
  	// atualiza a parcela
  	cParcAt  := TMPSE2->E2_PARCELA
  	
  	// atualiza o valor restante a pagar
  	nValPend -= TMPSE2->E2_VALOR
  	
  	aFieldFill := {}
  	nAdd ++
  	
  	TMPSE2->(dbSkip())  	
  EndDo
  
  TMPSE2->(dbCloseArea())
  
  // adiciona novos registros, caso não existam no banco de dados
  While (nAdd < nParc) .And. _cOpcao $ "I/A" // somente na inclusão / alteração valida
  	// atualiza as informações de acordo com a última parcela
  	cParcAt := Soma1(cParcAt)
  	dDataPar += 30
  	
  	// faz o cálculo do rateio da parcela
  	nValParc := Round(nValPend / (nParc - nAdd), 2)
  	nValPend -= nValParc
  	
  	
  	// {"E2_PREFIXO","E2_NUM","E2_PARCELA","E2_EMISSAO","E2_VALOR","E2_VENCTO"}
  	aAdd(aFieldFill, "GCT")
  	aAdd(aFieldFill, M->Z39_NUM)
  	aAdd(aFieldFill, cParcAt)
  	aAdd(aFieldFill, dDataBase)
  	aAdd(aFieldFill, nValParc)
  	aAdd(aFieldFill, dDataPar)
  	
  	Aadd(aFieldFill, .F.)
	  Aadd(aColsEx, aFieldFill)
  	nAdd++
  	
  	aFieldFill := {}  	
  EndDo
  
  // valida se pode altear algo
	if !(_cOpcao $ "I/A")
		aAlterFields := {}
	endif
  
  DEFINE MSDIALOG oDlg2 TITLE "Parcelas do Contrato" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
  
  @ 035,004 Say "Contrato: " + M->Z39_NUM OF oDlg2 COLORS 0, 16777215 PIXEL
  @ 035,080 Say "Parcelas Pendentes: " + Str(nParc, 3, 0)
	@ 045,004 Say "Descrição: " + M->Z39_DESCRI OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 055,004 Say "Valor Contrato: " + Transform(nValCT, "@E 999,999,999.99") OF oDlg2 COLORS 0, 16777215 PIXEL
	@ 065,004 Say "Valor Pendente: " + Transform(nValPag, "@E 999,999,999.99") OF oDlg2 COLORS 0, 16777215 PIXEL

  oGetTit := MsNewGetDados():New( 075, 003, 194, 344, GD_UPDATE+GD_DELETE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg2, aHeaderEx, aColsEx)

  ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar(oDlg2, {|| Iif(!(_cOpcao $ "I/A") .Or.GctParOk(nValPag, nParc), (oDlg2:End(), lOk:=.T.), lOk:=.F.)  } , {||oDlg2:End()},,aButtons)
  
Return lOK

// Função para totalizar as parcelas
User Function GCtrTotPar()
Local nTotPar := 0 
Local aColsTit := oGetTit:aCols
Local nPosVal := aScan(aHeaderEx, {|x| AllTrim(x[2]) == "E2_VALOR"} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For nX := 1 to len(aColsTit)
	if !aColsTit[nX, Len(aHeaderEx) + 1]
		nTotPar += aColsTit[nX, nPosVal]
	endif
Next nX
MsgInfo("Valor informado da parcelas: " + Str(nTotPar, 12, 2))
Return

// Validação das parcelas para inclusão / alteração
Static Function GctParOk(nValAb, nParCT)
Local lOk := .T.
Local nPosData := aScan(aHeaderEx, {|x| AllTrim(x[2]) == "E2_VENCTO" } )
Local nPosValor := aScan(aHeaderEx, {|x| AllTrim(x[2]) == "E2_VALOR" } )
Local nValParc := 0
Local nParDig := 0

aColsEx := oGetTit:aCols

// Verifica as datas das parcelas se estão ok
For nX := 1 to Len(aColsEx)
 	
 	if (aColsEx[nX, len(aHeaderEx) + 1])
 		Loop
 	Endif
  
	nParDig ++

	if (aColsEx[nX, nPosData] < M->Z39_DTINIV)
		lOk := .F.
		MsgInfo("Data da parcela não pode ser menor da data de vigência")
	EndIf
	
	// valida a ordem de vencimento
	if (nX > 1)
		if (aColsEx[nX, nPosData] < aColsEx[nX-1, nPosData])
			lOk := .F.
			MsgInfo("Data do vencimento da parcela subsequente não pode ser menor que a data da parcela anterior, linha" + Str(nX, 2, 1))
		EndIf
	EndIf
	
	if (aColsEx[nX, nPosValor] <= 0)
		lOk := .F.
		MsgInfo("Valor da parcela não pode ser zerado")
	EndIf
	    
	nValParc += aColsEx[nX, nPosValor]
Next nX

// Verifica os valores das parcelas se fecha com o contrato

if (nValParc != nValAb)
	lOk := .F.
	MsgInfo("Valor das parcelas não confere com o valor em aberto")
EndIf

// Verifica o número de parcelas digitadas
if (nParDig != nParCT)
  lOk := .F.
  MsgInfo("Número de parcelas não confere com parcelas restantes do contrato")
EndIf

Return lOk

// Validação de todo o contrato
User Function GesCtrlTOK(nOpc)
Local cMsgErros := ""
Local lOk := .T.
Local nPosProd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_PRODUT"})
Local nPosQtde 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_QUANT"})
Local nPosTot 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_TOTAL"})
Local nPosSeg 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_SEGTO"})
Local nPosCC  	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_CC"})
Local nPosCta 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_CONTA"})
Local nPosStat 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_STATUS"})
Local nPosQtMd 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_QTMED"})

Local CLRF := Char(13) + char(10)
Local nRegZ39 := Z39->(RecNo())
Z39->(dbSetOrder(01))
// valida todas as linhas do contrato

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Empty(M->Z39_NUM)
	cMsgErros += " -> Número do contrato é obrigatório" + CRLF
endIf

if Empty(M->Z39_DESCRI)
	cMsgErros += " -> Descrição do contrato é obrigatório" + CRLF
endIf


if Empty(M->Z39_PERIOD)
	cMsgErros += " -> Período é obrigatório" + CRLF
endIf

if (M->Z39_QUANT == 0)
	cMsgErros += " -> Informe a quantidade" + CRLF
endif

if Empty(M->Z39_USER)
	cMsgErros += " -> Informe o usuário" + CRLF
endif

if Empty(M->Z39_FORNEC)
	cMsgErros += " -> Informe o fornecedor " + CRLF
endif

if Empty(M->z39_LOJA)
	cMsgErros += " -> Informe a loja do fornecedor" + CRLF
endif

// valida informações erradas
if Z39->(dbSeek(xFilial("Z39") + M->Z39_NUM))
	if (Z39->(RecNo()) != nRegZ39) .Or. (nOpc == 3)
		cMsgErros += " -> Já existe contrato com o número informado" + CRLF
	EndIf
endif

if (M->Z39_QUANT < M->Z39_QTDMED)
  cMsgErros += " -> Quantidade informada no contrato inferior a quantide medida" + CRLF
endif
    
SA2->(dbSetOrder(01))
if SA2->(!dbSeek(xFilial("SA2") + M->Z39_FORNECE + M->Z39_LOJA))
	cMsgErros += " -> Fornecedor não localizado" + CRLF
endif

PswOrder(2)
if !PswSeek(Trim(M->Z39_USER)) .And. !Empty(M->Z39_USER)
	cMsgErros += " -> Usuário inválido" + CRLF
EndIf

if !PswSeek(Trim(M->Z39_USER2)) .And. !Empty(M->Z39_USER2)
	cMsgErros += " -> Usuário 2 inválido" + CRLF
EndIf

if !PswSeek(Trim(M->Z39_USER3)) .And. !Empty(M->Z39_USER3)
	cMsgErros += " -> Usuário 3 inválido" + CRLF
EndIf
                   
CTT->(dbSetOrder(01))
CTH->(dbSetOrder(01))
CT1->(dbSetOrder(01))
SB1->(dbSetOrder(01))


if Empty(aCols[Len(aCols), nPosProd])
	aCols[Len(aCols), Len(aHeader) + 1] := .T. // exclui a linha em branco no final do grid
EndIf

// Valida todas as linhas do contrato, se possuem produto, quantidade, total, segmento, centro de custo e conta contábil
For nX := 1 to Len(aCols)
	
	if (aCols[nX, Len(aHeader) + 1] .And. aCols[nX, nPosQtMd] > 0) // se estiver excluído e existir medição será preciso alterara situação do item para finalizado ou cancelado
		cMsgErros += " -> Não é possível excluir um item com medição. Altere a situação do item para cancelado ou finalizado, linha " + aCols[nX, 1] + CRLF		
	EndIf
	
	
	if (aCols[nX, Len(aHeader) + 1]) // linha excluída  
		Loop
	EndIf
  
	// Produto
	cProd := aCols[nX, nPosProd]
	if Empty(cProd)
		cMsgErros += " -> Produto não informado para a linha " + aCols[nX, 1] + CRLF
	endIf
	
	if SB1->(!dbSeek(xFilial("SB1") + aCols[nX, nPosProd]))
		cMsgErros += " -> Produto " + aCols[nX, nPosProd] + " não existe, linha " + aCols[nX, 1] + CRLF
	endif
	
	// Quantidade
	if (aCols[nX, nPosQtde] <= 0)
		cMsgErros += " -> Informe a quantidade para o produto " + aCols[nX, nPosProd] + ", linha " + aCols[nX, 1] + CRLF
	endif
	
	// Valor Total
	if (aCols[nX, nPosTot] <= 0)
		cMsgErros += " -> Informe o valor para o produto " + aCols[nX, nPosProd] + ", linha " + aCols[nX, 1] + CRLF
	endif
	
	// Segmento
	if CTH->(!dbSeek(xFilial("CTH") + aCols[nX, nPosSeg])) .Or. Empty(aCols[nX, nPosSeg]) .Or. Len(AllTrim(aCols[nX, nPosSeg])) < 9
		cMsgErros += " -> Segmento " + aCols[nX, nPosSeg] + " não existe, está em branco ou não é analítico, linha " + aCols[nX, 1] + CRLF
	endif
	
	// Centro de Custo
	if CTT->(!dbSeek(xFilial("CTT") + aCols[nX, nPosCC])) .Or. Empty(aCols[nX, nPosCC]) .Or. Len(AllTrim(aCols[nX, nPosCC])) < 9
		cMsgErros += " -> Centro de custo " + aCols[nX, nPosCC] + " não existe, está em branco ou não é analítico, linha " + aCols[nX, 1] + CRLF
	endif
	
	// Conta Contábil
	if CT1->(!dbSeek(xFilial("CT1") + aCols[nX, nPosCta])) .Or. Empty(aCols[nX, nPosCta]) .Or. Len(AllTrim(aCols[nX, nPosCta])) < 9
		cMsgErros += " -> Conta contábil " + aCols[nX, nPosCta] + " não existe ou está em branco, linha " + aCols[nX, 1] + CRLF
	endif
	
	if CT1->(dbSeek(xFilial("CT1") + aCols[nX, nPosCta]))
		if (CT1->CT1_CLASSE != "2")
			cMsgErros += " -> Conta contábil " + aCols[nX, nPosCta] + " não é analítica, linha " + aCols[nX, 1] + CRLF
		endif
	endif
Next nX

// apresenta as mensagens de erro
if !Empty(cMsgErros)
	lOk := .F.
	Aviso("Erros", cMsgErros,{"OK"},3)
EndIf

Z39->(dbGoTo(nRegZ39))
Return lOk

// Validação se pode excluir
User Function GesctlrDOK()
Local lOk := .T.
Local nLinAt 	:= oGetD:oBrowse:nAt  // Linha atual
Local nPosQMed 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_QTMED"})
lOk := (aCols[nLinAt, nPosQMed] == 0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (!lOk)
	MsgStop("Linha não pode ser excluída porque existem medições efetuadas. Altere o status do item para Cancelado ou Finalizado.")
endIf
Return lOk

User Function GesctlrFOK()
Local lOk := .T.
Local cVarAtu 	:= ReadVar() // valor que está sendo editado
Local nPosis  	:= oGetD:oBrowse:nColPos // coluna atual
Local nLinAt 	:= oGetD:oBrowse:nAt  // Linha atual
Local cCpo 		:= Trim(aHeader[nPosis, 2]) // campo que está sendo editado
Local nPosQMed 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_QTMED"})
Local nPosVMed 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "Z40_VALMED"})
Local oVarAtu := @(&cVarAtu)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (aCols[nLinAt, nPosQMed] > 0) // já foi medido alguma quantidade
	if (cCpo == "Z40_QUANT")
		if (oVarAtu < aCols[nLinAt, nPosQMed])
			lOk := .F.
			(&cVarAtu) := aCols[nLinAt, nPosQMed]
			aCols[nLinAt, nPosis] := aCols[nLinAt, nPosQMed]
			MsgStop("Quantidade informda abaixo da quantidade medida")
		EndIf		
	elseif (cCpo == "Z40_TOTAL")
	  if (oVarAtu < aCols[nLinAt, nPosVMed])
			lOk := .F.
			MsgStop("Valor informado abaixo do valor medido")
			(&cVarAtu) := aCols[nLinAt, nPosVMed]
			aCols[nLinAt, nPosis] := aCols[nLinAt, nPosVMed]
		EndIf
	elseif (cCpo == "Z40_STATUS")
		// verificar validações para o status
	else		
		lOk := .F.
	endif
EndIf	
Return lOk

// Faz a gravação dos dados no banco
Static Function GravaDados(_cOpcao)
Local _nPosDel      := Len(aHeader) + 1
Local _nPosIt      := aScan(aHeader, { |x| x[2] = "Z40_SEQUEN"})
Local _cCampo     := ""

Begin Transaction
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gravo o Cabecalho ³    Caso precise gravar dados na tabela de cabecalho Habilite
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SX3") // Posiciono o SX3 pra gravar o cabecalho
dbSeek("Z39")
nDeletado := 0
if (_cOpcao == "S")
	For nX := 1 to len(aColsEx)
		if (aColsEx[nX, Len(aColsEx[nX])])
			nDeletado++
		EndIf
	Next nX	
EndIf

// Atualiza com a quantidade medida, mas não altera nos itens
if (nDeletado > 0)
	M->Z39_QTDMED := M->Z39_QTDMED + nDeletado
endIf
     
// se não há mais parcelas a medir, finaliza o contrato
if (M->Z39_QTDMED >= M->Z39_QUANT)
	M->Z39_STATUS := "02" // Finalizado
endif

if (_cOpcao == "C") // CANCELAR
	M->Z39_STATUS := "03"
endif

If RecLock("Z39", (_cOpcao = "I"))

	While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO = "Z39")
		_cCampo := SX3->X3_CAMPO
		If _cCampo = "Z39_FILIAL"
  		&_cCampo := xFilial("Z39") 
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
	dbSelectArea("Z40")
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Varrendo o aCols...³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For _ni := 1 to Len(aCols)
	  
	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  //³Se encontrou o item gravado no banco...³
	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		dbSelectArea("Z40")
		dbSetOrder(1)
		If dbSeek(xFilial("Z40") + M->Z39_NUM + aCols[_ni][_nPosIt])
  		// Se a linha estiver deletada...
 			If (aCols[_ni][_nPosDel])
	  		RecLock("Z40",.F.)
	  		dbDelete()
	  		MsUnLock()
 		  Else
	   	  //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	  //³Altera o Item...³
	   	  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  	  RecLock("Z40",.F.)
	  	  
	  	  For _nii := 1 to Len(aHeader)
	  		  _cCampo := ALLTRIM(aHeader[_nii,2])
	  		  if !(&_cCampo == aCols[_ni, _nii])
	  		  	&_cCampo := aCols[_ni, _nii]
	  		  endif
	      Next
	  	  MSUnlock()

 		  EndIf
    Else
      If !(aCols[_ni][_nPosDel])
	      RecLock("Z40",.T.)
	  		Z40_FILIAL := xFilial("Z40")
	  		Z40_NUM    := M->Z39_NUM
		   	For _nii := 1 to Len(aHeader)
					_cCampo := ALLTRIM(aHeader[_nii,2])
					&_cCampo := aCols[_ni, _nii]
		   	Next
 				MSUnlock()
  		EndIf
		EndIf
	Next  
	
EndIf
LanFinGCT()
End Transaction

// Faz o lançamento do financeiro separado      


Return

// Faz os lançamentos financeiros dos títulos
Static Function LanFinGCT()
Local nPosParc 	:= aScan(aHeaderEx,{|x| AllTrim(x[2]) == "E2_PARCELA"})
Local nPosVal 	:= aScan(aHeaderEx,{|x| AllTrim(x[2]) == "E2_VALOR"})
Local nPosDtEmi	:= aScan(aHeaderEx,{|x| AllTrim(x[2]) == "E2_EMISSAO"})
Local nPosDtVen	:= aScan(aHeaderEx,{|x| AllTrim(x[2]) == "E2_VENCTO"})

//aColsEx := oGetTit:aCols

// faz o lançamento financeiro de acordo com aColsEx e aHeaderEx
SE2->(dbSetOrder(01))

Z40->(dbSetOrder(01))
Z40->(dbSeek(xFilial("Z40") + Z39->Z39_NUM))
cSegmen := Z40->Z40_SEGTO
cCC     := Z40->Z40_CC

cMV_PRGCT := SuperGetMV("MV_X_PRGCT", , "2701001")

For nX := 1 to Len(aColsEx)
	// verifica se o título existe então seta para alterar
	// FILIAL + PREFIXO + NUMERO + PARCELA + TIPO + FORNECEDOR + LOJA
	
	if SE2->(dbSeek(xFilial("SE2") + "GCT" + Z39->Z39_NUM + aColsEx[nX, nPosParc] + "PR " + Z39->Z39_FORNEC + Z39->Z39_LOJA))
		
		// Faz somente a atualização, ou exclusão
	 	RecLock("SE2", .F.)
	 	if (aColsEx[nX, Len(aHeaderEx) + 1]) .OR. (Z39->Z39_STATUS $ "02/03")
			SE2->(dbDelete())
		else
			SE2->E2_VENCTO := aColsEx[nX, nPosDtVen]
			SE2->E2_VENCREA:= DataValida(aColsEx[nX, nPosDtVen])
			SE2->E2_VALOR  := aColsEx[nX, nPosVal]
		endIf
		
	 	SE2->(MsUnlock())
	else
		// faz a inclusão do título
		cHISTORI := "GCT :"+ Z39->Z39_NUM +" Par :" + aColsEx[nX, nPosParc] + " - " + Z39->Z39_DESCRI
		lMsErroAuto := .F. 
		aTitulo := {{"E2_FILIAL"	, xFilial("SE2")		 		,	Nil},;      
								{"E2_PREFIXO"	, "GCT"	 							  , Nil},;      
								{"E2_NUM"		, 	Z39->Z39_NUM	 				,	Nil},;      
								{"E2_PARCELA"	, aColsEx[nX, nPosParc] ,	Nil},;      
								{"E2_TIPO"		, "PR"					 				,	Nil},;      
								{"E2_NATUREZ"	, cMV_PRGCT							,	Nil},;  					
								{"E2_FORNECE"	, Z39->Z39_FORNEC   		,	Nil},;      
								{"E2_LOJA"		, Z39->Z39_LOJA	  			,	Nil},;
								{"E2_EMISSAO"	, aColsEx[nX, nPosDtEmi], Nil},;
								{"E2_VENCTO"	, aColsEx[nX, nPosDtVen],	Nil},;
								{"E2_VENCREA"	, DataValida(aColsEx[nX , nPosDtVen])	,	Nil},;
								{"E2_VALOR"		, aColsEx[nX, nPosVal]	,	Nil},;
								{"E2_HIST"		, cHISTORI			  			,	Nil},;
								{"E2_LA"	 	  , "S"		   						  ,	Nil},;
								{"E2_CLVLDB"	, cSegmen			  			  ,	Nil},;
								{"E2_CCD"		  , cCC			 				      ,	Nil} }
						
		MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)  
		If lMsErroAuto
			DisarmTransaction()
			Mostraerro()
		EndIf
	EndIf
	
Next nX

Return

// FUNÇÃO QUE FAZ A EXCLUSAO DOS DADOS NO BANCO
Static Function ExcluiDados()
Begin Transaction
  dbSelectArea("Z40")
  dbSeek(xFilial("Z40") + M->Z39_NUM)
  While !EOF() .And. Z40_NUM == M->Z39_NUM
    RecLock("Z40",.F.)
    dbDelete()
    MSUnlock()
    dbSkip()     
  End
  
  // exclui as parcelas restantes
  dbSelectArea("SE2")
  dbSetOrder(01)
  SE2->(dbSeek(xFilial("SE2") + "GCT" + Z39->Z39_NUM)) //  + aColsEx[nX, nPosParc] + "PR " + Z39->Z39_FORNEC + Z39->Z39_LOJA)
  While (SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM == xFilial("SE2") + "GCT" + Z39->Z39_NUM)
  	if (Z39->Z39_FORNEC + Z39->Z39_LOJA + "PR " == SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_TIPO)
  		RecLock("SE2", .F.)
  		SE2->(dbDelete())
  		SE2->(MsUnlock())
  	endif
  	SE2->(dbSkip())
  EndDo
    
  dbSelectArea("Z39")
  RecLock("Z39",.F.)
  dbDelete()
  MSUnlock()
    
End Transaction
Return

// Função responsável por fazer as medições no gestão de contratos
User Function INCMEDGCT(cAlias, nReg, nOpc)
Local aArea := GetArea()
Private aCols := {}
Private aHeader := {}
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())    
      
if ((nOpc == 9) .And. Z39->Z39_STATUS $ "02/03")
	MsgStop("Não é possível fazer medição para contrato cancelado ou finalizado")
	Return
endif

// valida se o usuário tem permissão
if ((nOpc > 3) .And. (AllTrim(Z39->Z39_USER) # Trim(cUserName) .AND.;
			 AllTrim(Z39->Z39_USER2) # Trim(cUserName) .AND. ;
			 AllTrim(Z39->Z39_USER3) # Trim(cUserName) .AND. Upper(AllTrim(cUserName)) # "ADMINISTRADOR" ))
	MsgStop("Usuário logado não tem permissão sobre o contrato")
	Return
endif


// verifica se o contrato está em aberto e existe quantidade a ser medida
if (Z39->Z39_QUANT <= Z39->Z39_QTDMED)
	MsgInfo("Não há mais medições a serem efetuadas para o contrato selecionado")
	Return
endif

// Busca os itens possíveis de serem medidos, de acordo com a situação de cada item
lOk := ShowNewMed()

if (lOk)	
	// Limpa as colunas excluídas
	aColTmp := {}
	nPos := 1
	while nPos <= Len(aCols)
		if (!aCols[nPos, Len(aHeader) + 1])
			aAdd(aColTmp, aClone(aCols[nPos]))
		endIf	
		nPos ++
	enddo
	aCols := aColTmp
	IncPedComp()
endif

RestArea(aArea)
Return


// Função que busca as informações da medição e possibilita ao usuário informar um novo item
// Exibição e validação das parcelas do contrato
Static Function ShowNewMed()
Local nX
Local aFieldFill := {}
Local aFields := {"Z41_SEQUEN","Z41_PRODUT","Z41_QUANT","Z41_VALMED","Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_VALPRE", "Z41_QTREST", "Z41_VLREST", "Z41_NUMPED", "Z41_OBSMED"}
Local aAlterFields := {"Z41_QUANT", "Z41_VALMED", "Z41_OBSMED"}
Local aButtons  := {	{ "S4WB011N"   , { || GdSeek(oGetMed, OemtoAnsi("Localizar")) }, OemtoAnsi("Localizar"), OemtoAnsi("Localizar") },;
											{"ORDEM",{||ASort(aCols,,,{ |x,y| x[oGetMed:oBrowse:nColPos] < y[oGetMed:oBrowse:nColPos]})}, "Ordem", "Ordem"},;
											{"S4WB001N",{|| U_MEDADPROD()}, "Incluir", "Incluir"} }
Local _opdlgGet
Local _lRet := .F.
Local alSize
Local nOpcGrid := GD_UPDATE+GD_DELETE
Private oDlg
Private oGetMed
Private nQtMed := 1
Private nTotal := 0
Private oGetTot

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"allwaystrue()",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
  if !Z39->Z39_ALTVAL
		aAlterFields := {"Z41_OBSMED"}
		nOpcGrid := GD_UPDATE
  endif

  // faz o diálogo solicitando o número de medições a efetuar
  /*alSize   		:= MsAdvSize()  
  DEFINE MSDIALOG _opdlgGet TITLE "Quantidade a medir" From alSize[1],alSize[2] to (alSize[1]+080),(alSize[2]+195) PIXEL
  @10, 005 MSGET oGetVal VAR nQtMed Picture "@E 999" of _opdlgGet PIXEL
  DEFINE SBUTTON FROM (alSize[1]+28),(alSize[2]+57) TYPE 1 ACTION(eVal( {|| ( _opdlgGet:End())  } )) ENABLE Of _opdlgGet

	ACTIVATE DIALOG _opdlgGet CENTERED*/
	
	
  // Define field values
  // adiciona os itens com base no Z40
  dbSelectArea("Z40")
  dbSetOrder(01)
  dbSeek(xFilial("Z40") + Z39->Z39_NUM)
  while (xFilial("Z40") + Z39->Z39_NUM == Z40_FILIAL + Z40_NUM)
		aFieldFill := {}
		// "Z41_SEQUEN","Z41_PRODUT","Z41_QUANT","Z41_VALMED","Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_VALPRE", "Z41_QTREST", "Z41_VLREST", "Z41_NUMPED"
		if (Z40_QUANT - Z40_QTMED) > 0
			aAdd(aFieldFill, Z40_SEQUEN)
			aAdd(aFieldFill, Z40_PRODUT)
			nQuant := (nQtMed / (Z39->Z39_QUANT - Z39->Z39_QTDMED)) * (Z40_QUANT - Z40_QTMED)
			nValor := (nQtMed / (Z39->Z39_QUANT - Z39->Z39_QTDMED)) * (Z40_TOTAL - Z40_VALMED)
			aAdd(aFieldFill, Round(nQuant,2))
			aAdd(aFieldFill, Round(nValor,2))
			aAdd(aFieldFill, Z40_SEGTO)
			aAdd(aFieldFill, Z40_CC)
			aAdd(aFieldFill, Z40_CONTA)
			aAdd(aFieldFill, Round(nValor, 2))
			aAdd(aFieldFill, Z40_QUANT - Z40_QTMED)  // Quantidade restante
			aAdd(aFieldFill, Z40_TOTAL - Z40_VALMED) // Valor restante
			aAdd(aFieldFill, Space(6)) // Número do pedido
			aAdd(aFieldFill, Space(150))
			aAdd(aFieldFill, .F.)
			aAdd(aCols, aFieldFill)
		endif
		Z40->(dbSkip())
  enddo  
  
  aSize     := MsAdvSize( .F. )
  aObjects := {}
	AAdd( aObjects, { 057, 057, .T., .F. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
	aPosObj := MsObjSize( aInfo, aObjects )

  
  DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

	@ 035,004 Say "Contrato: " + Z39->Z39_NUM OF oDlg COLORS 0, 16777215 PIXEL
	@ 035,080 Say "Medições Pendentes: " + Str(Z39->Z39_QUANT - Z39->Z39_QTDMED, 3, 0) OF oDlg COLORS 0, 16777215 PIXEL
	@ 035,190 Say "Total Lançado: " OF oDlg COLORS 0, 16777215 PIXEL
	@ 033,240 MSGet oGetTot VAR nTotal Picture  "@E 999,999,999.99" Size 50, 10 WHEN .F. OF oDlg COLORS 0, 16777215 PIXEL
	@ 046,004 Say "Descrição: " + AllTrim(Z39->Z39_DESCRI) OF oDlg COLORS 0, 16777215 PIXEL
	
   
	oGetMed:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpcGrid,"U_MedCtrlLOK","AllwaysTrue","" ,.T., ;
				aAlterFields, ,.F., Len(aCols), "AllwaysTrue",,,"AllwaysTrue")
	oGetMed:cLinhaOk := "U_MedCtrlLOK"
	
	// totaliza
	U_MedCtrlLOK()
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| MedCtrTOK(@_lRet) } , {||oDlg:End()},,aButtons)
	
Return _lRet

// Função para totalizar os valores
User Function MedCtrlLOK()
Local nX
Local nPosValM := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VALMED"})
//Alert("Passou")
nTotal := 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For nX := 1 to len(aCols)
	if !aCols[nX, Len(aHeader) + 1]
		nTotal += aCols[nX, nPosValM]
	EndIf
Next nX
oGetTot:Refresh()
Return .T.

Static Function MedCtrTOK(lRet)
Local lOk := .T.
Local nPosValM := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VALMED"})
Local nPosQtde := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_QUANT"})
Local nPosQtdP := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_QTREST"})
Local nPosValP := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VLREST"})

// Faz a validação da medição do contrato
For nX := 1 to len(aCols)
	if !(aCols[nX, Len(aHeader) + 1])
		
		if aCols[nX, nPosQtde] <= 0
			MsgInfo("Informe a quantidade para o item " + Str(nX,3))
			lOk := .F.
		endif
		
		if aCols[nX, nPosQtde] > aCols[nX, nPosQtdP]
			MsgInfo("Quantidade medida maior que a quantidade restante para o item " + Str(nX,3))
			lOk := .F.
		endif
		
		if aCols[nX, nPosValM] <= 0
			MsgInfo("Informe o valor para o item " + Str(nX,3))
			lOk := .F.
		endif
		
		if aCols[nX, nPosValM] > aCols[nX, nPosValP]
			MsgInfo("Valor medido maior que o valor restante para o item " + Str(nX,3))
			lOk := .F.
		endif
		
	endif
Next nX
lRet := lOk
if (lOk)
	oDlg:End()
endif
Return

// Adiciona novo produto na medição
User Function MedAdProd()
Local alSize
Local _lRet := .F.
Local _opdlgGet
Local _aCpoEnchoice := {}
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Verifica se pode adicionar um novo item, necessário permissão para alterar segmento / centro de custo
if !Z39->Z39_ALTSEG
	MsgInfo("Não permitido adicionar produtos conforme configuração do contrato")
	Return
endif

RegToMemory(("Z40"),.T.)
// faz a tela solicitando as informações a serem gravadas no próximo item da NF	
alSize:= MsAdvSize()
Aadd(_aCpoEnchoice,"Z40_NUM")
Aadd(_aCpoEnchoice,"Z40_PRODUT")
Aadd(_aCpoEnchoice,"Z40_DESCRI")
Aadd(_aCpoEnchoice,"Z40_QUANT")
Aadd(_aCpoEnchoice,"Z40_TOTAL")
Aadd(_aCpoEnchoice,"Z40_SEGTO")
Aadd(_aCpoEnchoice,"Z40_CC")
Aadd(_aCpoEnchoice,"Z40_CONTA")

_lF3 := .F.
_lMemoria := .T.
_lColumn := .F.
_caTela := "" 
_lNoFolder := .F.
_lProperty := .F.

_aAlterEnch := {"Z40_PRODUT","Z40_QUANT","Z40_TOTAL","Z40_SEGTO","Z40_CC","Z40_CONTA"}

// obtém a última ordem
Z40->(dbGotop())
Z40->(dbSetOrder(01))
Z40->(dbSeek(xFilial("Z40") + Z39->Z39_NUM))

cSeq := "01"
while (Z40->Z40_FILIAL+Z40->Z40_NUM == xFilial("Z40") + Z39->Z39_NUM)
	cSeq := Z40->Z40_SEQUEN
	Z40->(dbSkip())
enddo

cSeq := Soma1(cSeq)
M->Z40_NUM := Z39->Z39_NUM
M->Z40_SEQUEN := cSeq

_aPos := {015,003,120,310}

	DEFINE MSDIALOG _opdlgGet TITLE "Novo item do contrato" FROM alSize[1],alSize[2] to (alSize[1]+240),(alSize[2]+622) PIXEL
	
	Enchoice("Z40", 0, 3, /*aCRA*/, /*cLetra*/, /*cTexto*/,;
		_aCpoEnchoice, _aPos, _aAlterEnch, 1, /*nColMens*/,;
		/*cMensagem*/,/*cTudoOk*/, _opdlgGet)
	
	ACTIVATE MSDIALOG _opdlgGet CENTERED ON INIT EnchoiceBar(_opdlgGet, {|| _lRet:=.T., _opdlgGet:End()} , {||_opdlgGet:End()})

if (_lRet)
	// valida produto, quantidade, valor, centro de custo, segmento
	if !ExistCpo("SB1", M->Z40_PRODUTO)
		_lRet := .F.
		MsgInfo("Produto não informado ou em branco")
	endIf
	
	if !ExistCpo("CTH", M->Z40_SEGTO)
		_lRet := .F.
		MsgInfo("Segmento não informado ou em branco")
	endIf
	
	if !ExistCpo("CTT", M->Z40_CC)
		_lRet := .F.
		MsgInfo("Centro de Custo não informado ou em branco")
	endIf
	
	if !ExistCpo("CT1", M->Z40_CONTA)
		_lRet := .F.
		MsgInfo("Conta Contábil não informado ou em branco")
	endIf
	
	// verifica se já existe produto, segmento e centro de custo para as informações preenchidas
	Z40->(dbSetOrder(02))
	If Z40->(dbSeek(xFilial("Z40") + Z39->Z39_NUM + M->Z40_PRODUT + M->Z40_SEGTO + M->Z40_CC))
		MsgInfo("Produto já existe para o segmento e centro de custo informado")
		_lRet := .F.
	EndIf
	
	if (_lRet)
	  // Faz a inclusão na Z40
	  RecLock("Z40", .T.)
	  Z40->Z40_FILIAL := xFilial("Z40")	
	  Z40->Z40_NUM 		:= Z39->Z39_NUM
	  Z40->Z40_SEQUEN := cSeq
	  Z40->Z40_PRODUT := M->Z40_PRODUT
	  Z40->Z40_DESCRI := M->Z40_DESCRI
	  Z40->Z40_QUANT  := M->Z40_QUANT
	  Z40->Z40_TOTAL  := M->Z40_TOTAL
	  Z40->Z40_SEGTO  := M->Z40_SEGTO
	  Z40->Z40_CC     := M->Z40_CC
	  Z40->Z40_CONTA  := M->Z40_CONTA
	  Z40->Z40_STATUS := "01"
	  Z40->(MsUnlock())
	  aAdd(aCols, aClone(aCols[Len(aCols)]))
	  nLinha := Len(aCols)
	  
	  // "Z41_SEQUEN","Z41_PRODUT","Z41_QUANT","Z41_VALMED","Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_VALPRE", "Z41_QTREST", "Z41_VLREST", "Z41_NUMPED"
	  aCols[nLinha, 1] := cSeq
	  aCols[nLinha, 2] := M->Z40_PRODUT
	  aCols[nLinha, 3] := M->Z40_QUANT
	  aCols[nLinha, 4] := M->Z40_TOTAL
	  aCols[nLinha, 5] := M->Z40_SEGTO
	  aCols[nLinha, 6] := M->Z40_CC
	  aCols[nLinha, 7] := M->Z40_CONTA
	  aCols[nLinha, 8] := 0 // Valor previsto fica zerado devido ao item ser novo
	  aCols[nLinha, 9] := M->Z40_QUANT
	  aCols[nLinha,10] := M->Z40_TOTAL
	  aCols[nLinha,11] := Space(6)
	  aCols[nLinha,12] := Space(150)
	  
	endif
EndIf

Return

// Função que faz a iclusão do pedido, 
// mostrando o mesmo na tela
Static Function IncPedComp()                 
Local lOk := .F.
Local nPosProd := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_PRODUT"})
Local nPosQtde:= aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_QUANT"})
Local nPosValM := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VALMED"})
Local nPosSegm := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_SEGMEN"})
Local nPosCC := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_CC"})
Local nPosConta := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_CONTA"})  
Local nPosObs := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_OBSMED"}) //Gustavo 24/02/2014
Local cItem := "0000"
Local aItens := {}
Local dDataParc := dDataBase
Local _opdlgGet
Local oGetVal
// variáveis que guardam as informações referente ao contrato
Private aColsGCT := aClone(aCols)
Private aHeaderGCT := aClone(aHeader)
Private __GCTNUM := Z39->Z39_NUM
Private __CCPGPEDC := Space(3)
Private __nVALPEDC := 0
Private __APARCPED := {}
Private __APARGCT := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variáveis do cabeçalho do pedido.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA2->(dbSetOrder(01))
SA2->(dbSeek(xFilial("SA2")+Z39->Z39_FORNEC+Z39->Z39_LOJA))

cSql := "SELECT R_E_C_N_O_ AS RNO, E2_VENCREA, E2_VALOR FROM " + RetSqlName("SE2")
cSql += " WHERE E2_FILIAL = '" + xFilial("SE2") + "' "
cSql += " AND E2_NUM = '" + Z39->Z39_NUM + "' AND D_E_L_E_T_ = ' ' AND E2_TIPO = 'PR' AND E2_PREFIXO = 'GCT' "
cSql += " ORDER BY E2_PREFIXO, E2_NUM, E2_VENCTO "

TcQuery cSql New Alias "TMPSE2" 
TCSetField('TMPSE2', "E2_VENCREA", "D", 8, 0)
if TMPSE2->(!Eof())
	dDataParc := TMPSE2->E2_VENCREA
	nRec := TMPSE2->RNO
	aAdd(__APARGCT, {TMPSE2->E2_VENCREA, TMPSE2->E2_VALOR})
Else
	TMPSE2->(dbCloseArea())
	MsgStop("Não foi localizado título provisório no contas a pagar.","Título provisório não encontrado.")
	Return Nil
endif

TMPSE2->(dbCloseArea())

// Solicita a data de vencimento da parcela, mostrando a primeira data de vencimento do contrato
/*alSize := MsAdvSize()  
DEFINE MSDIALOG _opdlgGet TITLE "Data do Vencimento" From alSize[1],alSize[2] to (alSize[1]+080),(alSize[2]+230) PIXEL
  @10, 005 MSGET oGetVal VAR dDataParc  VALID (dDataParc >= dDataBase) of _opdlgGet PIXEL
  DEFINE SBUTTON FROM (alSize[1]+28),(alSize[2]+57) TYPE 1 ACTION(eVal( {|| ( _opdlgGet:End())  } )) ENABLE Of _opdlgGet

ACTIVATE DIALOG _opdlgGet CENTERED*/

//Gustavo 18/08/15 - Ajustado para puxar próximo número mesmo que outro pedido seja incluído
//cNumero := CriaVar("C7_NUM",.T.)     
cNumero := GetSxeNum("SC7","C7_NUM")
		   	
aCab := { 	{"C7_NUM"     , cNumero			, NIL},;		// Numero do Pedido
			{"C7_EMISSAO" , dDatabase		, NIL},;		// Data de Emissao
			{"C7_FORNECE" , Z39->Z39_FORNEC , NIL},;		// Fornecedor
			{"C7_LOJA"	  , Z39->Z39_LOJA	, NIL},;     	// Loja do Fornecedor
			{"C7_COND"	  , SA2->A2_COND    , NIL},;     	// Condicao de Pagamento
			{"C7_CONTATO" , Z39->Z39_NUM	, NIL},; 		// Contato
			{"C7_FILENT"  , xFilial("SC7")	, NIL}}			// Filial de Entrega

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define variáveis de itens do pedido.                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//cFORPGT := "BO"
For nX := 1 to len(aCols)
	// se tiver excluído não processa
	if aCols[nX, Len(aHeader) + 1]
		loop
	endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek ( xFilial("SB1") + aCols[nX, nPosProd])
	
	cItem := Soma1(cItem,TAMSX3("C7_ITEM")[1])
	
	aAdd( aItens,{	{"C7_ITEM",	cItem			, NIL},; 		// Numero do Item
			      	{"C7_PRODUTO" ,	SB1->B1_COD 	, NIL},; 		// Codigo do Produto
			      	{"C7_UM"      ,	SB1->B1_UM      , NIL},; 		// Unidade de Medida
			      	{"C7_QUANT"   ,	aCols[nX, nPosQtde], NIL},;  		// Quantidade
			      	{"C7_PRECO"   ,	aCols[nX, nPosValM] / aCols[nX, nPosQtde]	, NIL},; 		// Preco
			      	{"C7_DATPRF"  ,	dDatabase		, NIL},; 		// Data De Entrega
			      	{"C7_FORMPAG" ,	SA2->A2_FORMPAG    		, NIL},; 		// Forma de pagamento
			      	{"C7_FLUXO"   ,	"S"			 	, NIL},; 		// Fluxo de Caixa (S/N)
			      	{"C7_CLVL"    ,	aCols[nX, nPosSegm]	, NIL},; 		// Classe Valor
			      	{"C7_CC"   	  ,	aCols[nX, nPosCC]			 	, NIL},; 		// Centro de custo
			      	{"C7_LOCAL"   ,	SB1->B1_LOCPAD	, NIL},;  // Localização
			      	{"C7_DATPRF"  ,	dDataParc	, NIL},;   
			      	{"C7_OBS"			, aCols[nX, nPosObs], NIL},; //Obs da medição - Gustavo 24/02/2014
			      	{"C7_CONTA"   ,	aCols[nX, nPosConta], NIL}}) 		// Conta contábil     

	__nVALPEDC += aCols[nX, nPosValM]
	
Next nX

// atualiza o valor da parcela
__APARGCT[01,02] := __nVALPEDC

Begin Transaction
// Excluí o título provisório para permitir o fluxo de caixa.
SE2->(dbGoto(nRec))
RecLock("SE2", .F.)
SE2->(dbDelete())
SE2->(MsUnlock())
lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Função de inclusão do pedido de compras.               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Faz a inclusão mas mostrando a tela para o usuário confirmar
MATA120(1, aCab, aItens, 3)
//SC7->(dbSetOrder(01))
//SC7->(dbSeek(xFilial("SC7") + cNumero))

// caso deu erro ou não encontrou o pedido é porquê não foi incluído
If lMsErroAuto //.Or. Empty(SC7->C7_NUM)
	ROLLBACKSX8() // exclui a reserva de número de pedido
	DisarmTransaction() // para os casos que dá erro no PCO ou erro em outra parte
	MostraErro()
	lRet := .F.	
else
	ConfirmSX8()
	SetPedGCT()
	dbCommit()
	MsgInfo("Medição efetuada com sucesso. Número do pedido: " + SC7->C7_NUM)
EndIf

End Transaction

Return

// insere a medição e seta o número do pedido
Static Function SetPedGCT()
Local nX
Local nPosSeq := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_SEQUEN"})
Local nPosProd := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_PRODUT"})
Local nPosQtde:= aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_QUANT"})
Local nPosValM := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VALMED"})
Local nPosSegm := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_SEGMEN"})
Local nPosCC := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_CC"})
Local nPosConta := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_CONTA"})
Local nPosVPre := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_VALPRE"})
Local nPosObs := aScan(aHeader, {|x| AllTrim(x[2]) == "Z41_OBSMED"})

// ordena pelo sequencial dos registros
ASort(aColsGCT,,,{ |x,y| x[1] < y[1]})
// faz a atualização do pedido no aCols e grava os dados no banco.
for nX := 1 to Len(aColsGCT)
	
	// atualiza o valor previsto para novos itens
	if (aColsGCT[nX, nPosVPre] == 0)
		aColsGCT[nX, nPosVPre] := aColsGCT[nX, nPosValM]
	endif
	
	dbSelectArea("Z41")
	RecLock("Z41", .T.)
	Z41_FILIAL := xFilial("Z41")
	Z41_NUM    := Z39->Z39_NUM
	Z41_SEQUEN := aColsGCT[nX, nPosSeq]
	Z41_SEQMED := StrZero(Z39->Z39_QTDMED + 1, TamSX3("Z41_SEQMED")[1])
	Z41_PRODUT := aColsGCT[nX, nPosProd]
	Z41_QUANT  := aColsGCT[nX, nPosQtde]
	Z41_VALMED := aColsGCT[nX, nPosValM]
	Z41_SEGMEN := aColsGCT[nX, nPosSegm]
	Z41_CC     := aColsGCT[nX, nPosCC]
	Z41_CONTA  := aColsGCT[nX, nPosConta]
	Z41_VALPRE := aColsGCT[nX, nPosVPre]
	Z41_NUMPED := SC7->C7_NUM
	Z41_OBSMED := aColsGCT[nX, nPosObs]
	Z41_DATMED := dDataBase
	Z41->(MsUnlock())
	
	// atualiza no Z40 a quantidade e o valor medido
	dbSelectArea("Z40")
	dbSetOrder(01)
	dbSeek(xFilial("Z40") + Z39->Z39_NUM + aColsGCT[nX, nPosSeq])
	RecLock("Z40", .F.)
	Z40_QTMED := Z40_QTMED + aColsGCT[nX, nPosQtde]
	Z40_VALMED := Z40_VALMED + aColsGCT[nX, nPosValM]
	
	// finaliza a medição do item caso já atingiu a quantidade informada
	if (Z40_QTMED >= Z40_QUANT)
		Z40_STATUS := "03" 
	endif
	Z40->(MsUnlock())
next nX

// atualiza a quantidade medida no cabeçalho do contrato
dbSelectArea("Z39")
RecLock("Z39", .F.)
Z39_QTDMED += 1      
// finaliza o contrato caso atingiu o número de medições a efetuar
if (Z39_QTDMED >= Z39_QUANT)
	Z39_STATUS := "02"
endif
Z39->(MsUnlock())
Return

// Função responsável por excluir uma medição efetuada, para contratos finalizados ou em aberto.
User Function ExcMedGCT(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local aFields := {"Z41_SEQMED", "Z41_SEQUEN", "Z41_PRODUT", "Z41_QUANT", "Z41_VALMED", "Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_NUMPED"}
Local lRet := .F.
Local oDlg2
Local oGetMed
Local aColsMed := {}
Local aHeaderMed := {}
Private aCols := {}
Private aHeader := {}
// Usados na tela de parcelas
Private aColsEx := {}
Private aHeaderEx := {}          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
      
if ((nOpc == 9) .And. Z39->Z39_STATUS $ "02/03")
	MsgStop("Não é possível fazer medição para contrato cancelado ou finalizado")
	Return
endif

// valida se o usuário tem permissão
if ((nOpc > 3) .And. (AllTrim(Z39->Z39_USER) # Trim(cUserName) .AND.;
			 AllTrim(Z39->Z39_USER2) # Trim(cUserName) .AND. ;
			 AllTrim(Z39->Z39_USER3) # Trim(cUserName) .AND. Upper(AllTrim(cUserName)) # "ADMINISTRADOR" ))
	MsgStop("Usuário logado não tem permissão sobre o contrato")
	Return
endif


// verifica se o contrato está em aberto e existe quantidade a ser medida
if (Z39->Z39_QUANT <= Z39->Z39_QTDMED)
	MsgInfo("Não há mais medições a serem efetuadas para o contrato selecionado")
	Return
endif

// Monta tela com os detalhes da última medição
// obtém a última medição
cSql := "select z41_seqmed from " + RetSqlName("Z41")
cSql += " where Z41_NUM = '" + Z39->Z39_NUM + "' " 
cSql += " and Z41_FILIAL = '" + Z39->Z39_FILIAL + "' "
cSql += " and d_e_l_e_t_ <> '*' "
cSql += " order by Z41_SEQMED desc "
TcQuery cSql New Alias "TMPZ41"
cSeqExc := TMPZ41->Z41_SEQMED
TMPZ41->(dbCloseArea())

if Empty(cSeqExc)
	MsgInfo("Não há medições a excluir.")
	Return
endif

cSql := "select r_e_c_n_o_ as RNO, Z41_SEQMED, Z41_SEQUEN, Z41_PRODUT, Z41_QUANT, Z41_VALMED, Z41_SEGMEN, Z41_CC, Z41_CONTA, Z41_NUMPED "
cSql += " from " + RetSqlName("Z41")
cSql += " where Z41_NUM = '" + Z39->Z39_NUM + "' " 
cSql += " and Z41_FILIAL = '" + Z39->Z39_FILIAL + "' "
cSql += " and Z41_SEQMED = '" + cSeqExc + "' "
cSql += " and d_e_l_e_t_ <> '*' " 

TcQuery cSql New Alias "TMPZ41"

aHeaderMed := {}                          
Aadd(aHeaderMed, {"Nro. Reg.","RNO","",12,0,"allwaystrue()", ,"N",,"R","",""})
// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeaderMed, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"allwaystrue()",;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

aColsMed := {}

While TMPZ41->(!Eof())
	aFieldFil := {}
	For nX := 1 to TMPZ41->(fCount())
		aAdd(aFieldFil, TMPZ41->(FieldGet(nX)))
	Next nX
	aAdd(aFieldFil, .F.)
	aAdd(aColsMed, aFieldFil)
	TMPZ41->(dbSkip())
Enddo
TMPZ41->(dbCloseArea())


// Busca os dados do z40 que são usados na medição
dbSelectArea("SX3")
dbSetOrder(01)
dbSeek("Z40")
aHeader:={}
_NUSADO := 0
While !Eof().And.(X3_ARQUIVO = "Z40")
  If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
			!AllTrim(SX3->X3_CAMPO) $ "Z40_FILIAL|Z40_NUM" )
		_nUsado++
		aadd(aHeader,{ AllTrim(X3Titulo()),;
			SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			SX3->X3_TAMANHO,;
			SX3->X3_DECIMAL,;
			SX3->X3_VALID,;
			SX3->X3_USADO,;
			SX3->X3_TIPO,;
			SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT} )
	EndIf
  SX3->( dbSkip() )
End

aCols:={}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adicionando Itens no gride³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("Z40")
dbSetOrder(1)
dbSeek(xFilial("Z40")+Z39->Z39_NUM)    
While (!Eof()) .And. (Z40->Z40_FILIAL+Z40->Z40_NUM == Z39->Z39_FILIAL + Z39->Z39_NUM)
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
Enddo

// Exibe a medição
DEFINE MSDIALOG oDlg2 TITLE "Excluir Medição" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
  
@ 015,004 Say "Contrato: " + Z39->Z39_NUM OF oDlg2 COLORS 0, 16777215 PIXEL
@ 025,004 Say "Descrição: " + Z39->Z39_DESCRI OF oDlg2 COLORS 0, 16777215 PIXEL
@ 035,004 Say "Medição: " + cSeqExc OF oDlg2 COLORS 0, 16777215 PIXEL
@ 048,004 Say "Itens medidos: " OF oDlg2 COLORS 0, 16777215 PIXEL

oGetMed := MsNewGetDados():New( 056, 003, 194, 344, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", {},, Len(aCols), "AllwaysTrue", "", "AllwaysTrue", oDlg2, aHeaderMed, aColsMed)

ACTIVATE MSDIALOG oDlg2 CENTERED ON INIT EnchoiceBar(oDlg2, {|| lRet:=.T., oDlg2:End() } , {||oDlg2:End()})

if !lRet
	Return
endif

aArea      := GetArea()
aOldHeader	:= aClone(aHeader)
aOldaCols	:= aClone(aCols)
aOldaRotina	:= aClone(aRotina)
cFilOld     := cFilAnt 
cPedido := aColsMed[01, aScan(aHeaderMed, {|x| AllTrim(x[2]) == "Z41_NUMPED"})]

// Posiciona no pedido a ser excluído
dbSelectArea("SC7")
dbSetOrder(01)
dbSeek(xFilial("SC7") + cPedido)

// tenta fazer a exclusão do pedido por execauto 
Begin Transaction

if !Empty(cPedido) .And. SC7->C7_NUM == cPedido
	MatA120(SC7->C7_TIPO,,,5)
endif
             
aCols := aOldaCols
aHeader := aOldHeader
aRotina := aOldaRotina
cFilAnt := cFilOld

SC7->(dbSetOrder(01))

lRet := SC7->(!dbSeek(xFilial("SC7") + cPedido))

if (lRet)
	RecLock("Z39", .F.)
	Z39->Z39_QTDMED := Z39->Z39_QTDMED - 1
	Z39->(MsUnlock())
	
	// Exclui a medição efetuada
	For nX := 1 to len(aColsMed)
		Z41->(dbGoTo(aColsMed[nX, 01]))
		RecLock("Z41", .F.)
		Z41->(dbDelete())
		Z41->(MsUnlock())
	Next nX
	    
	// "Z41_SEQMED", "Z41_SEQUEN", "Z41_PRODUT", "Z41_QUANT", "Z41_VALMED", "Z41_SEGMEN", "Z41_CC", "Z41_CONTA", "Z41_NUMPED"
	nPosSeqIt := aScan(aHeaderMed, {|x| AllTrim(x[2]) == "Z41_SEQUEN"})
	nPosQuant := aScan(aHeaderMed, {|x| AllTrim(x[2]) == "Z41_QUANT"})
	nPosVal   := aScan(aHeaderMed, {|x| AllTrim(x[2]) == "Z41_VALMED"})
	
	// Retorna a quantidade medida no Z40
	For nX := 1 to Len(aColsMed)
		Z40->(dbSetOrder(01))
		if Z40->(dbSeek(xFilial("Z40") + Z39->Z39_NUM + Trim(aColsMed[nX, nPosSeqIt])))
			RecLock("Z40", .F.)
			Z40->Z40_QTMED  := Z40->Z40_QTMED - aColsMed[nX, nPosQuant]
			Z40->Z40_VALMED := Z40->Z40_VALMED - aColsMed[nX, nPosVal]
			// Se estiver finalizado seta o item como em aberto
			if (Z40->Z40_STATUS == "03")
				Z40->Z40_STATUS := "01"
			endif
			Z40->(MsUnlock())		
		endif
	Next nX

	// exibe a tela de parcelas para que seja incluido a parcela faltante
	// Esta linha é necessária pois a função VldParcela() trabalha com o M->
	RegToMemory(("Z39"),.F.)
	lRet := VldParcela("X")
	                              
	if (lRet)
		// Grava as parcelas alteradas
		LanFinGCT()
		// Confirma as alterações	
		dbCommit()
	endif
endif

// Desfaz as alterações caso ocorreu erro
if (!lRet)
	DisarmTransaction()
endif

End Transaction

// Restaura as variáveis alteradas
RestArea(aArea)

Return

// Função que mostra ao usuário as próximas medições, fixando da data atual até 30 dias
User Function ProMedGCT()
Local aRotBkp := aClone(aRotina)
Local cFiltro := ""
Local cAlias := "SE2"
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFiltro := "DTOS(E2_VENCTO) >= '" + dToS(dDataBase) + "' .AND. E2_PREFIXO = 'GCT' .AND. E2_TIPO = 'PR' .AND. E2_FILIAL = '" + xFilial("SE2") + "' "
cFiltro += " .AND. DTOS(E2_VENCTO) <= '" + dToS(dDataBase + 30) + "' "

aRotina := {}
aAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})

dbSelectArea("SE2")
dbSetOrder(01)

SET FILTER TO &cFiltro

mBrowse(6, 1, 22, 75, cAlias)

SET FILTER TO

aRotina := aClone(aRotBkp)

Return