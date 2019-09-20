#Include "PROTHEUS.CH"
//#Include "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CadVendCli        ³Autor ³ Flavio Dias    ³ Data ³10/12/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cadastro de Metas de Caixas x Vendedor										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CadMetaCx()
Local aArea := GetArea()
Private cCadastro := "Cadastro Metas x Quantidade"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		     {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"U_MntMetaCx" ,0 ,3} ,;
                     {"Alterar"    ,"U_MntMetaCx" ,0 ,4} ,;                     
                     {"Excluir"    ,"U_MntMetaCx" ,0 ,5} ,;
                     {"Copiar"     ,"U_MntMetaCx" ,0 ,6} }
                     // {"Relatorio"  ,"U_RVendcli" , 0 ,6}
                     // {"Replica p/ Emp", "U_ReplZZ5", 0, 6},;
                     // {"Altera Vendedor"  ,"U_AltVenCli" ,0 ,6},;
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

// funcao que monta a tela para editar as regras de venda do palm
 	
//U_MntCadReg(cAlias)
mBrowse( 6,1,22,75,"SCT")
// retorna o ambiente anterior
RestArea(aArea)

Return

/********************************************************/
// Função para montar a tela de cadastro das regras do palm
/********************************************************/
User Function MntMetaCx(cAlias, nReg, nOpc)
Local aArea := GetArea()
//Local cVend := Space(6)
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local nX
Local aFieldFill := {}
Local aFields := {"CT_SEQUEN","CT_PRODUTO","CT_QUANT", "CT_VALOR"} // ,"CT_VALOR"
Local aAlterFields := {"CT_PRODUTO","CT_QUANT", "CT_VALOR"} // "CT_SEQUEN", 
// 	{ "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("Ordenar"), OemtoAnsi("Ordenar") }, ;
Local aButtons  := {{ "S4WB011N"   , { || GdSeek(oGet, OemtoAnsi("Localizar")) }, OemtoAnsi("Localizar"), OemtoAnsi("Localizar") },;
								      { "NOTE"   , { || U_SCTPorGrp() }, OemtoAnsi("Gera / Grupo"), OemtoAnsi("Gera / Grupo") } }
								      
								      
Local nOpcNewGd  := IIf ( nOpc == 2 .Or. nOpc == 5 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )

Private aHeader := {}
Private aCOLS := {}
Private aREG := {}
Private cVend := Space(6)
Private cSegment := Space(9)
Private cSegOld := SCT->CT_CLVL
Private oGet
Private cDescVen := Space(40)
Private cDescSeg := Space(40)
Private cDocumen := Space(9)
Private cDescDoc := Space(40)
Private dData := dDataBase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Monta o aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX
  
RestArea(aArea)

// Monta o ACols conforme os dados
dbSelectArea(cAlias)
dbSetOrder(1) // FILIAL + Doc
if (nOpc != 3)
	cDoc := SCT->CT_DOC
	cSegment := SCT->CT_CLVL
	cDocumen := SCT->CT_DOC
	cDescDoc := SCT->CT_DESCRI
	cVend := SCT->CT_VEND
	dData := SCT->CT_DATA
	SCT->(dbSeek(xFilial("SCT") + cDoc))
	While !EOF() .And. SCT->CT_FILIAL + SCT->CT_DOC == xFilial("SCT") + cDoc
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)			
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End
	if (nOpc == 6)
		nOpc := 3
	EndIf
else // inclusão
	aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, Len( aHeader )+1 ] := .F.
	// Inicializa o incremento
	aCols[1, 1] := "001"
	cVend := Space(6)                            
	cSegment := Space(9)
	cDocumen := GetSXENum("SCT", "CT_DOC")
EndIf

// Alimenta as descrições
GetVend(cVend)
GetSeg(cSegment)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000, 000  TO 500, 540 COLORS 0, 16777215 PIXEL
	
	@ 000, 000 MSPANEL oPanel1 SIZE 250, 065 OF oDlg COLORS 0, 16777215 RAISED
  @ 005, 004 SAY oSay1 PROMPT "Vendedor:" SIZE 033, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 004, 040 MSGET oVend VAR cVend SIZE 066, 010 WHEN (nOpc == 3) VALID GetVend(cVend) OF oPanel1 COLORS 0, 16777215 F3 "SA3" PIXEL
  @ 006, 116 SAY oSay3 PROMPT cDescVen SIZE 160, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 020, 004 SAY oSay2 PROMPT "Segmento:" SIZE 030, 007 OF oPanel1 COLORS 0, 16777215 PIXEL  
  @ 019, 040 MSGET oSegment VAR cSegment SIZE 067, 010 WHEN (nOpc != 5) VALID (GetSeg(cSegment) .And. Len(AllTrim(cSegment)) == 9) OF oPanel1 COLORS 0, 16777215 F3 "CTH" PIXEL
  @ 021, 116 SAY oSay4 PROMPT cDescSeg SIZE 160, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 035, 004 SAY "Documento: " SIZE 033, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 034, 040 MSGET cDocumen SIZE 067, 010 WHEN (nOpc == 3) OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 034, 120 MSGET cDescDoc SIZE 100, 010 WHEN (nOpc != 5) OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 050, 004 SAY "Data: " SIZE 033, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 049, 040 MSGET dData SIZE 067, 010 WHEN (nOpc != 5) OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 055, 000 MSPANEL oPanel2 SIZE 250, 230 OF oDlg COLORS 0, 16777215 RAISED	                                  
	
	oGet := MsNewGetDados():New( 000, 000, 229, 249, nOpcNewGd, "AllwaysTrue", "AllwaysTrue", "+CT_SEQUEN+", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oPanel2, aHeader, aCols)
	
	// Don't change the Align Order
  oPanel1:Align := CONTROL_ALIGN_TOP
  oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
  oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| GrvVendCli(cAlias, nOpc, cVend, cSegment), ODlg:End(), Nil }, {|| oDlg:End() },,aButtons)
Return

// Funcao de validacao
Static Function GetVend(cVend)
cDescVen := Posicione("SA3", 01, xFilial("SA3") + cVend, "A3_NOME")
Return .T.

// Funcao de validacao
Static Function GetSeg(cSegment)
cDescSeg := Posicione("CTH", 01, xFilial("CTH") + cSegment, "CTH_DESC01")
Return .T.


/********************************************************/
// Função para gravar os dados na tabela, avaliando exclusão e alteração
/********************************************************/
Static Function GrvVendCli(cAlias, nOpc, cVend, cSegment)
Local aArea := GetArea()
Local nI := 0
Local nX := 0

// Alteração e Inclusao
SCT->(dbSetOrder(01))  // FILIAL + DOC
nPosSeq := aScan(aHeader, {|x| x[2] = "CT_SEQUEN"})

// Exclusão
if (nOpc == 5)
  For nI := 1 To Len( oGet:aCOLS )
		lFound := dbSeek(xFilial("SCT") + cDocumen)
		While (lFound)
			RecLock(cAlias,.F.)
			dbDelete()                       
			MsUnLock()
			lFound := dbSeek(xFilial("SCT") + cDocumen)
		EndDo
	Next nI
  Return
EndIf

For nI := 1 To Len(oGet:aCols)

	// valida se o item já existe
	cSeq := oGet:aCOLS[nI, nPosSeq]
	if (nOpc != 3)
		lFound := dbSeek(xFilial("SCT") + cDocumen + cSeq)
	else
		lFound := dbSeek(xFilial("SCT") + cDocumen + cSeq)	
	EndIf
	
	If lFound
		RecLock(cAlias,.F.)
		// se foi excluído
		If oGet:aCOLS[nI, Len(aHeader)+1]
			dbDelete()
		Endif
	Else
		RecLock(cAlias,.T.)		
	Endif
	
	If !oGet:aCOLS[nI, Len(aHeader)+1]
		FieldPut( FieldPos( "CT_FILIAL" ), xFilial(cAlias) )	  
		For nX := 1 To Len( aHeader )
			FieldPut( FieldPos( aHeader[nX, 2] ), oGet:aCOLS[nI, nX] )		
		Next nX
		
		FieldPut( FieldPos( "CT_CLVL" ), cSegment )
		FieldPut( FieldPos( "CT_DOC" ), cDocumen )
		FieldPut( FieldPos( "CT_DESCRI" ), cDescDoc )
//		FieldPut( FieldPos( "CT_VALOR" ), 0 )
		FieldPut( FieldPos( "CT_DATA" ), dData )
		
		// seta o vendedor tambem, caso tenha sido alterado
		if (CT_VEND <> cVend)
			FieldPut( FieldPos( "CT_VEND" ), cVend )	  
		EndIf
	Endif
	MsUnLock()
Next nI

if (nOpc == 3)
	ConfirmSX8()
EndIf

RestArea( aArea )



Return


/*******************************************
// Gera por Grupo
 ******************************************/
User function SCTPorGrp()
Local oDlg
Local lGera := .F.
Local aArea := GetArea()
Local cDesGrupo := Space(40)
Local cNumSeq := '001'
Private cGrupoD := Space(4)
Private cGrupoA := Space(4)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg TITLE "Gerar por Grupo" FROM 0, 0  TO 100, 450 COLORS 0, 16777215 PIXEL
@ 15, 15 SAY "Grupo de:" of oDlg COLORS 0, 16777215 PIXEL
@ 15, 60 MSGET cGrupoD PICTURE "@!" SIZE 40, 10 of oDlg COLORS 0, 16777215 F3 "SBM" PIXEL
@ 30, 15 SAY "Grupo até:" of oDlg COLORS 0, 16777215 PIXEL
@ 30, 60 MSGET cGrupoA PICTURE "@!" SIZE 40, 10 of oDlg COLORS 0, 16777215 F3 "SBM" PIXEL
ACTIVATE DIALOG oDlg Centered ON INIT ;
EnchoiceBar(oDlg,{|| lGera := .T., oDlg:End(), Nil}, {|| oDlg:End() })

if lGera
	// Busca os clientes do município e adiciona os mesmos na listagem
	cFiltro := "B1_GRUPO >= '" + AllTrim(cGrupoD) + "' .AND. B1_GRUPO <= '" + AllTrim(cGrupoA) + "' "
	dbSelectArea("SB1")
	dbSetOrder(01)
	SET Filter TO &cFiltro
	
	SB1->(dbGoTop())
	
	if SB1->(!Eof()) .And. Len(oGet:aCols) == 1 .And. Empty(oGet:aCols[1,2])
		oGet:aCols := {}
	else // busca o último número sequencial
		cNumSeq := oGet:aCols[Len(oGet:aCols),1]
		cNumSeq := Soma1(cNumSeq)
	EndIf
	
	While SB1->(!Eof())
		nPos := aScan(oGet:aCols, {|x| x[2] == SB1->B1_COD})
		if nPos = 0
			aAdd(oGet:aCols, {cNumSeq, SB1->B1_COD, 1, 0, .F.})
			cNumSeq := Soma1(cNumSeq)			
		EndIf
		SB1->(dbSkip())
	EndDo
	
	dbSelectArea("SB1")	
	// Limpa o filtro
	SET FILTER TO 
	
	// Atualiza os dados do Grid
	oGet:Refresh()
EndIf

RestArea(aArea)
Return Nil

/*******************************************
// Altera o codigo do vendedor e segmento para o vendedor selecionado
 ******************************************/
/*User Function AltVenCli(cAlias, nReg, nOpc)
Local cVend := ZZ5->ZZ5_VEND
Local oDlg
Local cVendNew := Space(6)
Local oVend
Local oSeg
Local cSegment := ZZ5->ZZ5_SEGMEN
Local cVendDesc
Local lCont := .F.

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cVendDesc := cVend + " - " + SA3->A3_NREDUZ

DEFINE MSDIALOG oDlg TITLE "Informe o novo vendedor e segmento" FROM 0, 0  TO 140, 350 COLORS 0, 16777215 PIXEL
@  20,  05 Say "Vendedor Atual: " + cVendDesc of oDlg COLORS 0, 16777215 PIXEL
@  35,  05 Say "Vendedor Novo: " of oDlg COLORS 0, 16777215 PIXEL
@  35,  60 MsGet oVend VAR cVendNew Size 50, 10 VALID !Empty(cVendNew) F3 "SA3" of oDlg COLORS 0, 16777215 PIXEL
@  50,  05 Say "Segmento: " of oDlg COLORS 0, 16777215 PIXEL
@  50,  60 MsGet oSeg VAR cSegment Size 50, 10 VALID !Empty(cSegment) F3 "CTH" of oDlg COLORS 0, 16777215 PIXEL
Activate Dialog oDlg Centered ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })
if !Empty(cVend) .And. !Empty(cSegment) .And. lCont
	CTH->(dbSetOrder(01))
	if SA3->(dbSeek(xFilial("SA3") + cVendNew)) .And. Len(AllTrim(cSegment)) == 9 .And. CTH->(dbSeek(xFilial("CTH") + cSegment))
		dbSelectArea("ZZ5")
		dbGoTo(nReg)
		RecLock("ZZ5", .F.)
		ZZ5->ZZ5_VEND   := cVendNew
		ZZ5->ZZ5_SEGMEN := cSegment
		ZZ5->(MsUnlock())
	Else
		Alert("Vendedor ou segmento não encontrado ou segmento não é analítico!")
	EndIf
EndIf
Return Nil*/

/***************************************************
 Função para replicar os dados do ZZ5 para outras filiais
 ***************************************************/

/*User Function ReplZZ5()
Local aAreaSM0 := SM0->(GetArea())
Local aItens := {}
Local cEmpFil := ""
Local lCont := .F.
Local aVendSeg := {}
Local aDADOSEMP := {}

aAreaSM0 := SM0->(GetArea())

SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While ! SM0->(EOF())
	if !(SM0->M0_CODFIL $ "00/99")	
		aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL, } )
		aAdd ( aItens, AllTrim(SM0->M0_NOME) + " / " + AllTrim(SM0->M0_FILIAL))	
	EndIf
	SM0->(dbSkip())
Enddo
RestArea(aAreaSM0)
 
cEmpFil := aItens[1]

DEFINE MSDIALOG oDlg TITLE "Selecione a empresa e filial a replicar os dados" FROM 0, 0  TO 100, 350 COLORS 0, 16777215 PIXEL
@  20,  05 Say "Empresa / Filial: " of oDlg COLORS 0, 16777215 PIXEL
@  30,  05 ComboBox cEmpFil Items aItens size 120, 10 of oDlg COLORS 0, 16777215 PIXEL
Activate Dialog oDlg Centered ON INIT ; 
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })

if lCont
	
	aArea := GetArea()
	
	// Busca os itens atuais
	cVend := ZZ5->ZZ5_VEND
	cSegment := ZZ5->ZZ5_SEGMENT
	dbSelectArea("ZZ5")
	dbSetOrder(04)
	dbSeek(xFilial("ZZ5") + cVend + cSegment)
	While !EOF() .And. ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_VEND + ZZ5->ZZ5_SEGMENT == xFilial("ZZ5") + cVend + cSegment
		aAdd( aVendSeg, {ZZ5_CLIENT, ZZ5_LOJA, ZZ5_TABELA} )		
		dbSkip()
	End
	
	aEmpFilAt := {SM0->M0_CODIGO, SM0->M0_CODFIL}
	 
	 
	nPos := aScan(aItens, cEmpFil)
	
	if nPos > 0
	                                             
		RpcClearEnv()
		RpcSetType(3)	
		RpcSetEnv(aDADOSEMP[nPos][1],aDADOSEMP[nPos][2],,,,GetEnvServer(),{ "ZZ5" })
		
		// faz a gravação dos dados na outra empresa/filial 
		// Alteração e Inclusao
		dbSelectArea("ZZ5")
		ZZ5->(dbSetOrder(03))  // FILIAL + VENDEDOR + CLIENTE + LOJA + SEGMENTO

		For nI := 1 To Len(aVendSeg)
		
			lFound := dbSeek(xFilial("ZZ5") + cVend + aVendSeg[nI,1] + aVendSeg[nI,2] + cSegment)			
			
			If !lFound
				RecLock("ZZ5", .T.)		
				
				ZZ5_CLIENT := aVendSeg[nI,1]
				ZZ5_LOJA := aVendSeg[nI,2]
				ZZ5_TABELA := aVendSeg[nI,3]
				
				FieldPut( FieldPos( "ZZ5_SEGMEN" ), cSegment )
				// seta o vendedor tambem, caso tenha sido alterado
				FieldPut( FieldPos( "ZZ5_VEND" ), cVend )
				FieldPut( FieldPos( "ZZ5_FILIAL" ), xFilial("ZZ5"))
				MsUnLock()
	    EndIf
	  Next nI
	  
		RpcClearEnv()
		RpcSetEnv(aEmpFilAt[1],aEmpFilAt[2],,,,GetEnvServer(),{ "ZZ5" })	
	               
	EndIf
	
	RestArea(aArea)
			
EndIf

Return*/
