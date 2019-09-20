#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CadVendCli        ³Autor ³ Flavio Dias    ³ Data ³10/12/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cadastro de Vendedores X Cliente 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CadVendCli()
Local aArea := GetArea()
Private cCadastro := "Cadastro Vendedores X Cliente"
Private aCores := {}

Private aRotina := { {"Pesquisar"  			,"AxPesqui"  		,0 ,1},;
					 					 {"Visualizar" 			,"AxVisual"  		,0 ,2},;
                     {"Incluir"    			,"U_MntVenCli" 	,0 ,3},;
                     {"Alterar"    			,"U_MntVenCli" 	,0 ,4},;                     
                     {"Excluir"    			,"U_MntVenCli" 	,0 ,5},;
                     {"Copiar"     			,"U_MntVenCli" 	,0 ,6},;
                     {"Altera Vendedor" ,"U_AltVenCli" 	,0 ,6},;
                     {"Replica p/ Emp"	,"U_ReplZZ5" 		,0 ,6},;
                     {"Relatorio"  			,"U_RVendcli" 	,0 ,6}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³funcao que monta a tela para editar as regras de venda do palm³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mBrowse( 6,1,22,75,"ZZ5")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ
//³Retorna o ambiente anterior³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RestArea(aArea)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ
//³Função para montar a tela de cadastro das regras do palm³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆ

User Function MntVenCli(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local nX
Local aFieldFill := {}
Local aFields := {"ZZ5_CLIENT","ZZ5_LOJA","ZZ5_TABELA"}
Local aAlterFields := {"ZZ5_CLIENT","ZZ5_LOJA","ZZ5_TABELA"}
Local aButtons  := {	{ "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("Ordenar"), OemtoAnsi("Ordenar") }, ;
								      { "S4WB011N"   , { || GdSeek(oGet, OemtoAnsi("Localizar")) }, OemtoAnsi("Localizar"), OemtoAnsi("Localizar") },;
								      { "NOTE"   		 , { || U_ZZ5PorMun() }, OemtoAnsi("Gera p/ mun"), OemtoAnsi("Gera p/ mun") } }
								      
								      
Local nOpcNewGd  := IIf ( nOpc == 2 .Or. nOpc == 5 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )

Private aHeader := {}
Private aCOLS := {}
Private cVend := Space(6)
Private cSegment := Space(9)
Private cSegOld := ZZ5->ZZ5_SEGMENT
Private oGet
Private cDescVen := Space(40)
Private cDescSeg := Space(40)

Private cCODCC := Space(09)
Private cDESCC := Space(40)

// Monta o aHeader
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Flavio - 18/08/2011                                                             ³
//³Ajustado para permitir gravar mais de uma tabela de preço para um mesmo cliente.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

aAdd( aHeader, { "N. Reg",;
		"ZZ5_RNO",;
		"",;
		14,; 
		0,; 
		,;
		,;
		"N",;
		,;
		"R"})

  
RestArea(aArea)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta o ACols conforme os dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea(cAlias)
dbSetOrder(4) // FILIAL + VENDEDOR + SEGMENTO + CC
if (nOpc != 3 .and. nOpc != 6)
	cVend := ZZ5->ZZ5_VEND
	cSegment := ZZ5->ZZ5_SEGMENT
	cCODCC := ZZ5->ZZ5_CC	
	ZZ5->(dbSeek(xFilial("ZZ5") + cVend + cSegment + cCODCC))
	While !EOF() .And. ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_VEND + ZZ5->ZZ5_SEGMENT + ZZ5->ZZ5_CC == xFilial("ZZ5") + cVend + cSegment + cCODCC
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader ) -1
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)			
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)] := ZZ5->(RecNo())
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso for selecionada a opção de cópia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ElseIf nOpc == 6
	cVend := ZZ5->ZZ5_VEND
	cSegment := ZZ5->ZZ5_SEGMENT
	cCODCC := ZZ5->ZZ5_CC	
	ZZ5->(dbSeek(xFilial("ZZ5") + cVend + cSegment + cCODCC))
	While !EOF() .And. ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_VEND + ZZ5->ZZ5_SEGMENT + ZZ5->ZZ5_CC == xFilial("ZZ5") + cVend + cSegment + cCODCC
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader ) -1
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)			
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)] := ZZ5->(RecNo())
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End
	
		
//ÚÄÄÄÄÄÄÄÄ¿
//³Inclusão³
//ÀÄÄÄÄÄÄÄÄÙ

Else 
	aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader ) -1
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, Len( aHeader ) ] := 0
	aCOLS[1, Len( aHeader )+1 ] := .F.	
	cVend := Space(6)
	cSegment := Space(9)
	cCODCC := Space(09)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Alimenta as descrições³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

GetVend(cVend)
GetSeg(cSegment)
GetCC(cCODCC)

DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000, 000  TO 500, 540 COLORS 0, 16777215 PIXEL
	
  @ 000, 000 MSPANEL oPanel1 SIZE 250, 060 OF oDlg COLORS 0, 16777215 RAISED
  
  @ 005, 004 SAY oSay1 PROMPT "Vendedor:" SIZE 033, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 004, 040 MSGET oVend VAR cVend SIZE 066, 010 WHEN (nOpc == 3 .or. nOpc == 6) VALID GetVend(cVend) OF oPanel1 COLORS 0, 16777215 F3 "SA3" PIXEL
  @ 006, 116 SAY oSay3 PROMPT cDescVen SIZE 160, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  
  @ 020, 004 SAY oSay2 PROMPT "Segmento:" SIZE 030, 007 OF oPanel1 COLORS 0, 16777215 PIXEL  
  @ 019, 040 MSGET oSegment VAR cSegment SIZE 067, 010 WHEN (nOpc != 5) VALID (GetSeg(cSegment) .And.; 
  																																						 Len(AllTrim(cSegment)) == 9 .And.;
  																																						 AvalSeg(cVend,cSegment)) OF oPanel1 COLORS 0, 16777215 F3 "CTH" PIXEL
  @ 021, 116 SAY oSay4 PROMPT cDescSeg SIZE 160, 007 OF oPanel1 COLORS 0, 16777215 PIXEL

  @ 035, 004 SAY oSay2 PROMPT "Centro Custo:" SIZE 030, 007 OF oPanel1 COLORS 0, 16777215 PIXEL  
  @ 034, 040 MSGET oSegment VAR cCODCC SIZE 067, 010 WHEN (nOpc != 5) VALID (GetCC(cCODCC) .And. Len(AllTrim(cCODCC)) == 9 .and. ValidCC(cCodCC)) OF oPanel1 COLORS 0, 16777215 F3 "CTT" PIXEL
  @ 036, 116 SAY oSay4 PROMPT cDESCC SIZE 160, 007 OF oPanel1 COLORS 0, 16777215 PIXEL

  @ 065, 000 MSPANEL oPanel2 SIZE 250, 230 OF oDlg COLORS 0, 16777215 RAISED	                                  
	
	oGet := MsNewGetDados():New( 000, 000, 229, 249, nOpcNewGd, "U_ZZ5LOK()", "AllwaysTrue", "", aAlterFields,, 9999, "AllwaysTrue", "", "AllwaysTrue", oPanel2, aHeader, aCols)
	
	// Don't change the Align Order
  oPanel1:Align := CONTROL_ALIGN_TOP
  oPanel2:Align := CONTROL_ALIGN_ALLCLIENT
  oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
EnchoiceBar(oDlg,{|| GrvVendCli(cAlias, nOpc, cVend, cSegment, cCODCC), ODlg:End(), Nil }, {|| oDlg:End() },,aButtons)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄğ
//³Busca descrição do vendedor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄğ

Static Function GetVend(cVend)
cDescVen := Posicione("SA3", 01, xFilial("SA3") + cVend, "A3_NOME")
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que busca descrição do segmento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GetSeg(cSegment)
cDescSeg := Posicione("CTH", 01, xFilial("CTH") + cSegment, "CTH_DESC01")
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca descrição do centro de custo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GetCC(cCODCC)
cDESCC := Posicione("CTT", 01, xFilial("CTT") + cCODCC, "CTT_DESC01")
Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para gravar os dados na tabela, avaliando exclusão e alteração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GrvVendCli(cAlias, nOpc, cVend, cSegment, cCODCC)
Local aArea := GetArea()
Local aCols := oGet:aCols
Local nI := 0
Local nX := 0

nPosCli  := aScan(aHeader, {|x| x[2] = "ZZ5_CLIENT"})
nPosLoja := aScan(aHeader, {|x| x[2] = "ZZ5_LOJA"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Alteração e Inclusao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DbSelectArea("ZZ5")
ZZ5->(dbSetOrder(03))  // FILIAL + VENDEDOR + CLIENTE + LOJA + SEGMENTO

//ÚÄÄÄÄÄÄÄÄØ
//³Exclusão³
//ÀÄÄÄÄÄÄÄÄØ

if (nOpc == 5)
  For nI := 1 To Len(aCols)
		if DbSeek(xFilial("ZZ5") + cVend + aCols[nI, nPosCli] + aCols[nI, nPosLoja] + cSegment)
			RecLock("ZZ5",.F.)
			ZZ5->(DbDelete())                       
			ZZ5->(MsUnLock())
		EndIf
	Next nI
  Return
EndIf

If (nOpc == 6)
	nPosCli := aScan(oGet:aHeader, {|x| AllTrim(x[2]) == "ZZ5_CLIENT"})
	nPosLoj := aScan(oGet:aHeader, {|x| AllTrim(x[2]) == "ZZ5_LOJA"})
	nPosTab := aScan(oGet:aHeader, {|x| AllTrim(x[2]) == "ZZ5_TABELA"})
	
	For nI := 1 to Len(oGet:aCols)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'¿
		//³Verifica se o registro já existe para evitar cadastro em duplicidade ou erro de inclusão³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ'Ù
		
		lFound := BuscaInf(oGet:aCols[nI, nPosCli], oGet:aCols[nI, nPosLoj], oGet:aCols[nI, nPosTab],;
											 cVend, cSegment, cCODCC)
		if !lFound .and. (oGet:aCols[nI, Len(oGet:aHeader)+1] == .F.)
			RecLock("ZZ5", .T.)
			ZZ5->ZZ5_FILIAL := xFilial("ZZ5")
			ZZ5->ZZ5_CLIENT := oGet:aCols[nI, nPosCli]
			ZZ5->ZZ5_LOJA   := oGet:aCols[nI, nPosLoj]
			ZZ5->ZZ5_VEND   := cVend
			ZZ5->ZZ5_TABELA := oGet:aCols[nI, nPosTab]
			ZZ5->ZZ5_SEGMEN := cSegment
			ZZ5->ZZ5_CC     := cCodCC
			ZZ5->(MsUnlock())
		EndIf
		
	Next nI
Else

	For nI := 1 To Len(oGet:aCols)
		
		lFound := oGet:aCols[nI, Len(aHeader)] > 0
		If lFound
			ZZ5->(dbGoTo(oGet:aCols[nI, Len(aHeader)]))
			RecLock(cAlias,.F.)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³se foi excluído³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If oGet:aCOLS[nI, Len(aHeader)+1]
				dbDelete()
			Endif
		Else
			RecLock(cAlias,.T.)		
		Endif
		
		If !oGet:aCOLS[nI, Len(aHeader)+1]
			FieldPut( FieldPos( "ZZ5_FILIAL" ), xFilial(cAlias) )	  
			For nX := 1 To Len( aHeader ) -1
				FieldPut( FieldPos( aHeader[nX, 2] ), oGet:aCOLS[nI, nX] )		
			Next nX
			FieldPut( FieldPos( "ZZ5_SEGMEN" ), cSegment )
			FieldPut( FieldPos( "ZZ5_CC" ), cCODCC )	  
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
			//³seta o vendedor tambem, caso tenha sido alterado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù
			
			if (ZZ5_VEND <> cVend)
				FieldPut( FieldPos( "ZZ5_VEND" ), cVend )	  
			EndIf
	
		Endif
		MsUnLock()
	Next nI
EndIf

RestArea( aArea )

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ
//³Faz a ordenação dos dados para facilitar a busca das informações³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ

User function OrdenaGrd()
Local nOrdem := 0
Local aItems := {}//{"Coluna 1", "Coluna 2", "Coluna 3", "Coluna 4", "Coluna 5", "Coluna 6", "Coluna 7"}
Local cCombo := ""
Local oDlg

For i := 1 to len(aHeader)
  Aadd(aItems, aHeader[i, 1])	
Next i

DEFINE MSDIALOG oDlg TITLE "Selecione a Ordem " FROM 0, 0  TO 70, 450 COLORS 0, 16777215 PIXEL
@  15,  15 ComboBox cCombo Items aItems Size 50, 90 of oDlg COLORS 0, 16777215 PIXEL
Activate Dialog oDlg Centered ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() })
nOrdem := aScan(aItems, cCombo)
if (nOrdem > 0)
	ASort(oGet:aCols,,,{ |x,y| x[nOrdem] < y[nOrdem]})
EndIf
Return Nil                                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Gera por Muncipio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User function ZZ5PorMun()
Local oDlg
Local lGera := .F.
Local aArea := GetArea()
Local oGet1
Local oGet2
Local oGet3
Local oGet4
Local oSay1
Local oSay2
Local oSay3
Local cDesMun := Space(40)
Private cCodMun := Space(5)
Private cUF := Space(2)
Private cTab := Space(3)

DEFINE MSDIALOG oDlg TITLE "Gerar por Muncípio" FROM 0, 0  TO 140, 450 COLORS 0, 16777215 PIXEL
@ 15, 15 SAY oSay1 PROMPT "Estado" of oDlg COLORS 0, 16777215 PIXEL
@ 15, 60 MSGET oGet1 VAR cUF PICTURE "@!" SIZE 40, 10 of oDlg COLORS 0, 16777215 PIXEL
@ 30, 15 Say oSay2 PROMPT "Muncipio"  of oDlg COLORS 0, 16777215 PIXEL
@ 30, 60 MsGet oGet2 VAR cCodMun Size 40, 10 Valid !Empty(cCodMun) Of oDlg COLORS 0, 16777215 F3 "CC2GER" PIXEL
@ 30, 100 MsGet oGet3 VAR cDesMun Size 40, 10 When .F. Of oDlg COLORS 0, 16777215 PIXEL
@ 45, 15 Say oSay3 PROMPT "Tab. Preço" Size 40, 10 Of oDlg COLORS 0, 16777215 PIXEL
@ 45, 60 MsGet oGet4 VAR cTab Size 40, 10 Of oDlg COLORS 0, 16777215 F3 "DA0" PIXEL
ACTIVATE DIALOG oDlg Centered ON INIT ;
EnchoiceBar(oDlg,{|| lGera := .T., oDlg:End(), Nil}, {|| oDlg:End() })

if lGera
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca os clientes do município e adiciona os mesmos na listagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cFiltro := "A1_COD_MUN == '" + AllTrim(cCodMun) + "' .AND. A1_EST == '" + cUF + "' "
	dbSelectArea("SA1")
	dbSetOrder(01)
	SET Filter TO &cFiltro
	
	SA1->(dbGoTop())
	
	if SA1->(!Eof()) .And. Len(oGet:aCols) == 1 .And. Empty(oGet:aCols[1,1])
		oGet:aCols := {}
	EndIf
	
	While SA1->(!Eof())
		nPos := aScan(oGet:aCols, {|x| x[1] == SA1->A1_COD .And. x[2] == SA1->A1_LOJA })
		if nPos = 0
			aAdd(oGet:aCols, {SA1->A1_COD, SA1->A1_LOJA, cTab, .F.})
		EndIf
		SA1->(dbSkip())
	EndDo
	
	dbSelectArea("SA1")	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Limpa o filtro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET FILTER TO 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Atualiza os dados do Grid³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	oGet:Refresh()
EndIf

RestArea(aArea)
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Altera o codigo do vendedor e segmento para o vendedor selecionado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function AltVenCli(cAlias, nReg, nOpc)
Local cVend := ZZ5->ZZ5_VEND
Local oDlg
Local cVendNew := Space(6)
Local oVend
Local oSeg
Local cSegment := ZZ5->ZZ5_SEGMEN
Local cVendDesc                  
Local lCont := .F.               
Local cCODCC := ZZ5->ZZ5_CC


SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cVendDesc := cVend + " - " + SA3->A3_NREDUZ

DEFINE MSDIALOG oDlg TITLE "Informe o novo vendedor e segmento" FROM 0, 0  TO 170, 350 COLORS 0, 16777215 PIXEL
@  10,  05 Say "Vendedor Atual: " + cVendDesc of oDlg COLORS 0, 16777215 PIXEL
@  25,  05 Say "Vendedor Novo: " of oDlg COLORS 0, 16777215 PIXEL
@  25,  60 MsGet oVend VAR cVendNew Size 50, 10 VALID (!Empty(cVendNew) .and. AvalSeg(cVendNew,cSegment)) F3 "SA3" of oDlg COLORS 0, 16777215 PIXEL
@  40,  05 Say "Segmento: " of oDlg COLORS 0, 16777215 PIXEL
@  40,  60 MsGet oSeg VAR cSegment Size 50, 10 VALID !Empty(cSegment) F3 "CTH" of oDlg COLORS 0, 16777215 PIXEL
@  55,  05 Say "Centro Custo: " of oDlg COLORS 0, 16777215 PIXEL
@  55,  60 MsGet oSeg VAR cCODCC Size 50, 10 VALID !Empty(cCODCC) F3 "CTT" of oDlg COLORS 0, 16777215 PIXEL

Activate Dialog oDlg Centered ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })

if !Empty(cVend) .And. !Empty(cSegment) .And. !Empty(cCODCC) .And. lCont
	CTH->(dbSetOrder(01))
	CTT->(dbSetOrder(01))
	if SA3->(dbSeek(xFilial("SA3") + cVendNew)) .And. Len(AllTrim(cSegment)) == 9 .And. CTH->(dbSeek(xFilial("CTH") + cSegment)) ;
	.And. Len(AllTrim(cCODCC)) == 9 .And. CTT->(dbSeek(xFilial("CTT") + cCODCC))
		dbSelectArea("ZZ5")
		dbGoTo(nReg)
		RecLock("ZZ5", .F.)
		ZZ5->ZZ5_VEND   := cVendNew
		ZZ5->ZZ5_SEGMEN := cSegment
		ZZ5->ZZ5_CC 	:= cCODCC
		ZZ5->(MsUnlock())
	Else
		Alert("Vendedor, segmento ou centro de custo não encontrado ou segmento/centro de custo não é analítico!")
	EndIf
EndIf
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD
//³Função para replicar os dados do ZZ5 para outras filiais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD

User Function ReplZZ5()
Local aAreaSM0 		:= SM0->(GetArea())
Local aItens 		:= {}
Local cEmpFil 		:= ""
Local lCont 		:= .F.
Local aVendSeg 		:= {}
Local aDADOSEMP 	:= {}
Private lChkBox 	:= .T.
Private cDescVen 	:= ""
Private cDescSeg 	:= ""
Private cDESCC 		:= ""
Private cVend		:= ""
Private cSegment 	:= ""       
Private cCODCC  	:= ""       
Private cTabPrc		:= ""  
Private cSegAnt		:= ""     
Private cCCant 		:= ""     
Private cVendAnt	:= ""

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

AtuaVal()

cSegAnt := cSegment  
cCCAnt  := cCODCC
cVendAnt:= cVend

DEFINE MSDIALOG oDlg TITLE "SELECIONE A EMPRESA/FILIAL PARA REPLICAR" FROM 0, 0  TO 240, 500 COLORS 0, 16777215 PIXEL

@ 005, 004 SAY oSaySeg 		PROMPT "Empresa/Filial: " 		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 045, 004 SAY oSay1 		PROMPT "Vendedor:" 				SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 045, 116 SAY oSay3 		PROMPT cDescVen 				SIZE 160, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 060, 004 SAY oSay2 		PROMPT "Segmento:" 				SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL  
@ 060, 116 SAY oSay4 		PROMPT cDescSeg 				SIZE 160, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 075, 004 SAY oSay5 		PROMPT "Centro Custo:" 	   		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL  
@ 075, 116 SAY oSay6 		PROMPT cDESCC 					SIZE 160, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 090, 004 SAY oSay7 		PROMPT "Tab. Preço:" 			SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL  

@ 015, 004 MSCOMBOBOX oCboBox VAR cEmpFil ITEMS aItens SIZE 120, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 032, 004 CHECKBOX oChkBox VAR lChkBox PROMPT "Mantém Vend., Seg., C.C. e Tab.Preço de Origem?" ON CHANGE AtuaVal() SIZE 130, 008 OF oDlg COLORS 0, 16777215 PIXEL
                                                      
@ 043, 040 MSGET oVend 		VAR cVend 		SIZE 066, 010 WHEN !lChkBox VALID GetVend(cVend) OF oDlg COLORS 0, 16777215 F3 "SA3" PIXEL
@ 058, 040 MSGET oSegment VAR cSegment 	SIZE 067, 010 WHEN !lChkBox VALID (GetSeg(cSegment) .And.; 
																																				 		Len(AllTrim(cSegment)) == 9 .And.;
																																				 		AvalSeg(cVend,cSegment)) OF oDlg COLORS 0, 16777215 F3 "CTH" PIXEL
@ 073, 040 MSGET oCodCC 	VAR cCODCC 		SIZE 067, 010 WHEN !lChkBox VALID (GetCC(cCODCC) .And. Len(AllTrim(cCODCC)) == 9 .and. ValidCC(cCodCC)) OF oDlg COLORS 0, 16777215 F3 "CTT" PIXEL
@ 088, 040 MSGET oTabPrc 	VAR cTabPrc 	SIZE 067, 010 WHEN !lChkBox OF oDlg COLORS 0, 16777215 F3 "DA0" PIXEL

ACTIVATE DIALOG oDlg CENTERED ON INIT ; 
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })

if lCont
	
	aArea := GetArea()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca os itens atuais³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("ZZ5")
	dbSetOrder(04)
	dbSeek(xFilial("ZZ5") + cVendAnt + cSegAnt + cCCAnt)
	While !EOF() .And. ZZ5->ZZ5_FILIAL + ZZ5->ZZ5_VEND + ZZ5->ZZ5_SEGMENT + ZZ5->ZZ5_CC == xFilial("ZZ5") + cVendAnt + cSegAnt + cCCAnt
		aAdd( aVendSeg, {ZZ5_CLIENT, ZZ5_LOJA, cTabPrc} )		
		dbSkip()
	End
	
	aEmpFilAt := {SM0->M0_CODIGO, SM0->M0_CODFIL}
	 
	 
	nPos := aScan(aItens, cEmpFil)
	
	if nPos > 0
	                                             
		RpcClearEnv()
		RpcSetType(3)	
		RpcSetEnv(aDADOSEMP[nPos][1],aDADOSEMP[nPos][2],,,,GetEnvServer(),{ "ZZ5" })
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida Amarração de Vendedor e Segmento na Empresa de Destino³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		lAchou 	  := AvalSeg(cVend, cSegment)
    	lCancela  := .F.
        
		While !lAchou .and. !lCancela

      		if !lAchou 
				lAchou := AvalSeg(cVend, cSegment)
			EndIf
			if !lAchou 
				lCancela := .T.
			EndIf
		EndDo              
		
		lTab := .T.
		DbSelectArea("DA0")
		DA0->(DbSetOrder(1))
		if !DA0->(DbSeek(xFilial("DA0") + aVendSeg[01, 03]))
			MsgAlert("A tabela de preço informada não existe na Empresa/Filial: "+ AllTrim(cEmpFil) +".")		
			lTab := .F.
		EndIf
		
		if lCancela .or. !lTab
			MsgAlert("A operação foi cancelada!")

			RpcClearEnv()
			RpcSetEnv(aEmpFilAt[1],aEmpFilAt[2],,,,GetEnvServer(),{ "ZZ5" })	
			
			RestArea(aArea)
			
			Return				
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz a gravação dos dados na outra empresa/filial ³
		//³Alteração e Inclusao                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
		dbSelectArea("ZZ5")
		ZZ5->(dbSetOrder(03))  // FILIAL + VENDEDOR + CLIENTE + LOJA + SEGMENTO
		
		For nI := 1 To Len(aVendSeg)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Antes de incluir, valida se o registro já existe.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			lFound := dbSeek(xFilial("ZZ5") + cVend + aVendSeg[nI,1] + aVendSeg[nI,2] + cSegment)			
			
			If !lFound
				RecLock("ZZ5", .T.)		
				FieldPut( FieldPos( "ZZ5_CLIENT" ), aVendSeg[nI,1])
				FieldPut( FieldPos( "ZZ5_LOJA" )	, aVendSeg[nI,2])				
				FieldPut( FieldPos( "ZZ5_TABELA" ), aVendSeg[nI,3])				
				FieldPut( FieldPos( "ZZ5_SEGMEN" ), cSegment )
				FieldPut( FieldPos( "ZZ5_CC" )		, cCODCC )
				FieldPut( FieldPos( "ZZ5_VEND" )	, cVend )
				FieldPut( FieldPos( "ZZ5_FILIAL" ), xFilial("ZZ5"))
				MsUnLock() 
				
	    	EndIf
	  	Next nI
	  
		RpcClearEnv()
		RpcSetEnv(aEmpFilAt[1],aEmpFilAt[2],,,,GetEnvServer(),{ "ZZ5" })	
	  
	  	MsgInfo("Fim do processo de cópia da carteira de clientes para a empresa "+ cEmpFil)
	               
	EndIf
	
	RestArea(aArea)
			
EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Validação de Centro de Custo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function ValidCC(cCCusto)
Local lRet := .F.

DbSelectArea("CTT")
CTT->(DbSetOrder(1))
CTT->(DbGoTop())

if CTT->(DbSeek(xFilial("CTT") + cCCusto))
	lRet := .T.
Else
	Alert("Centro de Custo "+AllTrim(cCCusto)+" inválido.")
EndIf

Return lRet 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Validação de Cliente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

User Function ZZ5LOK()
Local lRet := .T. 
Local Ni := oGet:nAt
Local aCols := oGet:aCols
local aAreaZZ5 := ZZ5->(getArea())
local aRecDel  := {}

DbSelectArea("SA1")
SA1->(DbSetOrder(1)) // CLIENTE + LOJA
SA1->(DbGoTop())
if SA1->(!DbSeek(xFilial("SA1") + aCols[Ni][1] + aCols[Ni][2]))
	
	lRet := .F.   
	Alert("Cliente "+AllTrim(aCols[Ni][1]+"/"+AllTrim(aCols[Ni][2]))+" inválido.")   
	
Else

	//guarda os registros deletados da tela aberta para nao ser considerado no loop abaixo
	for nJ:=1 to len(aCols)
		if aCols[nJ, len (aHeader)+1] 
	         aadd(aRecDel, aCols[nJ][4]) 
		endif
	next nI
	
	
	ZZ5->(dbSetOrder(3)) //filial+vend+cliente+loja
	if ZZ5->(dbSeek(xFilial('ZZ5')+cVend+aCols[Ni][1]+aCols[Ni][2])) 
	
		while ZZ5->(!EOF()) .AND. ZZ5->(ZZ5_FILIAL+ZZ5_VEND+ZZ5_CLIENT+ZZ5_LOJA+ZZ5_TABELA)==xFilial('ZZ5')+cVend+aCols[Ni][1]+aCols[Ni][2]+aCols[nI][3]
	
	         if ZZ5->(RECNO())!= aCols[Ni][4] .and.  ascan ( aRecDel, {|x| x == ZZ5->(RECNO()) } )==0  //nao analiza o registo atual da tabela com o do acols pois é o mesmo
	         	
	         	lRet :=.F.
	         	Alert("Ja existe uma amarração para este cliente")
				
	         endif
	         
	         ZZ5->(dbSkip())
		enddo  
		
	endif

endif
RestArea(aAreaZZ5)

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que verifica se o registro já existe antes de ser incluído.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function BuscaInf(cCliente, cLoja, cTabela, cVend, cSegmen)
Local lRet := .F.
Local cSql := ""
Local cEOL := CHR(13)+CHR(10)

cSql := "SELECT ZZ5.R_E_C_N_O_ FROM "+ RetSqlName("ZZ5") +" ZZ5 " +cEol
cSql += "WHERE ZZ5.ZZ5_FILIAL = '"+ xFilial("ZZ5") +"' "          +cEol
cSql += "  AND ZZ5.ZZ5_CLIENT = '"+ cCliente +"' "                +cEol
cSql += "  AND ZZ5.ZZ5_LOJA   = '"+ cLoja +"' "                   +cEol
cSql += "  AND ZZ5.ZZ5_VEND   = '"+ cVend +"' "                   +cEol
cSql += "  AND ZZ5.ZZ5_TABELA = '"+ cTabela +"' "                 +cEol
cSql += "  AND ZZ5.ZZ5_SEGMEN = '"+ cSegmen +"' "                 +cEol
cSql += "  AND ZZ5.D_E_L_E_T_ <> '*' "

TCQUERY cSql NEW ALIAS "ZZ5TMP"

DbSelectArea("ZZ5TMP")
ZZ5TMP->(DbGoTop())

if RecCount() > 0
	lRet := .T.
EndIf       

ZZ5TMP->(DbCloseArea())

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para validar se o Segento x Vend tem Armazem na tabela Z22³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AvalSeg(cVend, cSegment)
Local lRet := .F.
Local lResposta := .F.

DbSelectArea("Z22")
Z22->(DbSetOrder(1))

If Z22->(DbSeek(xFilial("Z22") + cVend + cSegment))
	lRet := .T.
Else
  lResposta := MsgYesNo("Não foi encontrado armazém relacionado ao vendedor "+AllTrim(cVend)+;
							  				 " e ao segmento "+AllTrim(cSegment)+" informados. Para prosseguir, cadastre a amarração na rotina"+;
							  				 " Atualização >> Específicos Cantu >> Arm x Vend x Classe Vlr."+;
							  				 " Deseja cadastrar essa amarração agora?", "Importante!")
  If lResposta
  	U_RJFATP05()			 
		If Z22->(DbSeek(xFilial("Z22") + cVend + cSegment))
			lRet := .T.  		 
		EndIf       
	EndIf
	
EndIf

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Atualiza informações dos campos ao setar ou remover a marcação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AtuaVal()

cVend := ZZ5->ZZ5_VEND
cDescVen := ""
GetVend(cVend)

cSegment := ZZ5->ZZ5_SEGMENT
cDescSeg := ""
GetSeg(cSegment)

cCODCC := ZZ5->ZZ5_CC
cDesCC := ""
GetCC(cCodCC)
                                           
cTabPrc := ZZ5->ZZ5_TABELA

Return