#include "protheus.ch"

User function ADENA04()
Local oBold
Local lInclui := .F.
Local nOpca		 := 0
Local nOpcx		 := 0
Local lContinua	 := .T.
Local bTrue      := {||.T.}
Local bFalse     := {||.T.}

Private aCols	 := {}
Private aHeader	 := {}

PRIVATE aRotina 	:= {	{ OemToAnsi('Pesquisar'),'AxPesqui', 0 , 1},;		//'Pesquisar'
{ OemToAnsi('Visualizar'),'Adena04V', 0 , 2},;		//'&Visualizar'
{ OemToAnsi('Incluir'),'Adena04I', 0 , 3},; 		//'&Incluir'
{ OemToAnsi('Alterar'),'Adena04A', 0 , 4},; 		//'&Alterar'
{ OemToAnsi('Excluir'),'Adena04D', 0 , 5, 3} }  	//Excluir

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader e aCols utilizando a funcao FillGetDados.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZX3")
dbSetOrder(1)
If !dbSeek(xFilial("ZX3")) //tabela vazia
	lInclui := .T.
	nOpcx := 3
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FillGetDados(3,"ZX3",1,,,,,,,,,.T.,,,)
	
Else
	lInclui := .F.
	nOpcx := 4
	
	cSeek  := xFilial("ZX3")
	cWhile := "ZX3->ZX3_FILIAL"
	
	bCondicao := {|| SoftLock("ZX3") }
	bTrue     := {|| lContinua := lContinua }
	bFalse    := {|| lContinua := .F. }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FillGetDados(nOpcX,"ZX3",1,cSeek,{|| &cWhile },{{bCondicao,bTrue,bFalse}},,,,,,,,,)
EndIf

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg TITLE "Cadastro de Local x Transportadora" FROM 009,000 TO 030,130

oGet := MSGetDados():New(10,20,140,515,nOpcx,,,,.T.,,,,300)

@ 145,175 BUTTON "Importar" SIZE 040,010 FONT oDlg:oFont ACTION (U_IMPTRANS(),oDlg:End()) OF oDlg PIXEL
@ 145,220 BUTTON "Cancelar" SIZE 040,010 FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
@ 145,265 BUTTON "Salvar" 	SIZE 040,010 FONT oDlg:oFont ACTION (If(oGet:TudoOk(),(nOpcA:=1,oDlg:End()),Nil)) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcA == 1
	
	Begin Transaction
	ADENA04GRV()
	EvalTrigger()
	End Transaction
	
EndIf

If !lInclui
	MsUnlockAll()
EndIf

Return

Static Function ADENA04GRV()

Local nPosRecno := Len(aHeader)
Local nX        := 0
Local nY        := 0

dbSelectArea("ZX3")

For nx := 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta deletado                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[nx][Len(aCols[nx])]
		If aCols[nX][nPosRecno] > 0
			dbGoto(aCols[nX][nPosRecno])
			RecLock('ZX3',.F.)
		Else
			RecLock('ZX3',.T.)
		EndIf
		ZX3->ZX3_FILIAL	:= xFilial("ZX3")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os dados contidos na GetDados                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny := 1 to Len(aHeader)
			If aHeader[ny][10] # 'V'
				ZX3->(FieldPut(FieldPos(Trim(aHeader[ny][2])),aCols[nx][ny]))
			Endif
		Next
		MsUnlock()
	Else
		If aCols[nX][nPosRecno] > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui o registro do ZX3                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('ZX3')
			dbGoto(aCols[nX][nPosRecno])
			RecLock('ZX3',.F.,.T.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
Next

Return .T.
