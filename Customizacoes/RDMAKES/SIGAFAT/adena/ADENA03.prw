#include "protheus.ch"

User function ADENA03()
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
{ OemToAnsi('Visualizar'),'Adena02V', 0 , 2},;		//'&Visualizar'
{ OemToAnsi('Incluir'),'Adena02I', 0 , 3},; 		//'&Incluir'
{ OemToAnsi('Alterar'),'Adena02A', 0 , 4},; 		//'&Alterar'
{ OemToAnsi('Excluir'),'Adena02D', 0 , 5,3} }  	//'&Excluir'


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader e aCols utilizando a funcao FillGetDados.      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZX2")
dbSetOrder(1)
If !dbSeek(xFilial("ZX2")) //tabela vazia
	lInclui := .T.
	nOpcx := 3
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FillGetDados(3,"ZX2",1,,,,,,,,,.T.,,,)
	
Else
	lInclui := .F.
	nOpcx := 4
	
	cSeek  := xFilial("ZX2")
	cWhile := "ZX2->ZX2_FILIAL"
	
	bCondicao := {|| SoftLock("ZX2") }
	bTrue     := {|| lContinua := lContinua }
	bFalse    := {|| lContinua := .F. }
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Sintaxe da FillGetDados(/*nOpcX*/,/*Alias*/,/*nOrdem*/,/*cSeek*/,/*bSeekWhile*/,/*uSeekFor*/,/*aNoFields*/,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,/*lEmpty*/,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/) |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	FillGetDados(nOpcX,"ZX2",1,cSeek,{|| &cWhile },{{bCondicao,bTrue,bFalse}},,,,,,,,,)
EndIf

DEFINE FONT oBold NAME "Arial" SIZE 0, -12 BOLD

DEFINE MSDIALOG oDlg TITLE "Logística % Frete" FROM 009,000 TO 030,080

oGet := MSGetDados():New(10,20,140,315,nOpcx,,,,.T.,,,,300)

@ 145,220 BUTTON "Cancelar" SIZE 040,010 FONT oDlg:oFont ACTION (oDlg:End()) OF oDlg PIXEL
@ 145,265 BUTTON "Salvar" 	SIZE 040,010 FONT oDlg:oFont ACTION (If(oGet:TudoOk(),(nOpcA:=1,oDlg:End()),Nil)) OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

If nOpcA == 1
	
	Begin Transaction
	ADENA03GRV()
	EvalTrigger()
	End Transaction
	
EndIf

If !lInclui
	MsUnlockAll()
EndIf

Return

Static Function ADENA03GRV()

Local nPosRecno := Len(aHeader)
Local nX        := 0
Local nY        := 0

dbSelectArea("ZX2")

For nx := 1 to Len(aCols)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se esta deletado                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !aCols[nx][Len(aCols[nx])]
		If aCols[nX][nPosRecno] > 0
			dbGoto(aCols[nX][nPosRecno])
			RecLock('ZX2',.F.)
		Else
			RecLock('ZX2',.T.)
		EndIf
		ZX2->ZX2_FILIAL	:= xFilial("ZX2")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza os dados contidos na GetDados                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For ny := 1 to Len(aHeader)
			If aHeader[ny][10] # 'V'
				ZX2->(FieldPut(FieldPos(Trim(aHeader[ny][2])),aCols[nx][ny]))
			Endif
		Next
		MsUnlock()
	Else
		If aCols[nX][nPosRecno] > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Exclui o registro do ZX2                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea('ZX2')
			dbGoto(aCols[nX][nPosRecno])
			RecLock('ZX2',.F.,.T.)
			dbDelete()
			MsUnlock()
		EndIf
	EndIf
Next

Return .T.
