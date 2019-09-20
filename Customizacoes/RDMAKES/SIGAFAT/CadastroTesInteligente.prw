#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CadRegPlm         ³Autor ³ Flavio Dias    ³ Data ³30/10/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cadastro de regra de venda no palm												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CadTesInt()
Local aArea := GetArea()
Private cCadastro := "Cadastro de Tes Inteligente"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		     {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"U_MntTesInt" ,0 ,3} ,;
                     {"Alterar"    ,"U_MntTesInt" ,0 ,4} ,;
                     {"Excluir"    ,"U_MntTesInt" ,0 ,5} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// funcao que monta a tela para editar as regras de venda do palm
 	
//U_MntCadReg(cAlias)
mBrowse( 6,1,22,75,"SFM")
// retorna o ambiente anterior
RestArea(aArea)

Return

/********************************************************/
// Função para montar a tela de cadastro das Tes Inteligente
/********************************************************/
User Function MntTesInt(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2	
Local aCpoAlt := {}
Private aHeader := {}
Private aCOLS := {}
Private aREG := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// monta o aHeader
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL .And. !(AllTrim(X3_CAMPO) $ "FM_CLIENTE/FM_LOJACLI/FM_FORNECE/FM_LOJAFOR")
		aAdd( aHeader, { Trim( X3Titulo() ),;
		X3_CAMPO,;
		X3_PICTURE,;
		X3_TAMANHO,; 
		X3_DECIMAL,; 
		X3_VALID,;
		X3_USADO,;
		X3_TIPO,;
		X3_ARQUIVO,;
		X3_CONTEXT})
		// adiciona na lista de itens a editar
		if !("FILIAL" # X3_CAMPO)
			Aadd(aCpoAlt, X3_CAMPO)
		EndIf
	Endif
	dbSkip()
End
RestArea(aArea)

// Monta o ACols conforme os dados
dbSelectArea("SFM")
if (nOpc <> 3)
SFM->(dbSeek(xFilial("SFM")))
	While !EOF() .And. SFM->FM_FILIAL == xFilial("SFM")	
		aAdd( aREG, SFM->( RecNo() ) )
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
else // inclusão
	aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader )
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[1, Len( aHeader )+1 ] := .F.
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 400, 600 PIXEL OF oMainWnd

	oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_BOTTOM
			
	oGet := MSGetDados():New(0,0,0,0,nOpc, , .T., "", .T., ;
		{"FM_TIPO", "FM_TS", "FM_GRTRIB", "FM_PRODUTO", "FM_GRPROD", "FM_EST", "FM_POSIPI", "FM_X_CONTA" }, , .T., 256)
//	oGet := MSGetDados():New(0,0,0,0,1   , , .T., "", .F., {"X6_CONTEUD"}, , , Len(aCols))
	
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| GrvTesInt(cAlias, nOpc), ODlg:End(), Nil }, {|| oDlg:End() })
Return


/********************************************************/
// Função para gravar os dados na tabela, avaliando exclusão e alteração
/********************************************************/
Static Function GrvTesInt(cAlias, nOpc)
Local aArea := GetArea()
Local nI := 0
Local nX := 0
Local cItem := "00"

// Exclusão
if (nOpc == 5)
  For nI := 1 To Len( aCOLS )
		dbGoTo(aREG[nI])
		RecLock(cAlias,.F.)
		dbDelete()
		MsUnLock()
	Next nI
  Return
EndIf

// Inclusão
if (nOpc == 3) 
Endif
// Alteração
For nI := 1 To Len(aCols)	
	// se o item já existe
	If nI <= Len( aREG )
		dbGoTo( aREG[nI] )
		RecLock(cAlias,.F.)
		// se foi excluído
		If aCOLS[nI, Len(aHeader)+1]
			dbDelete()
		Endif
	Else
		RecLock(cAlias,.T.)		
	Endif
	
	If !aCOLS[nI, Len(aHeader)+1]
	  // contador dos registros para sempre gravar na ordem correta
	  cItem := Soma1(cItem)		
	  FieldPut( FieldPos( "FM_FILIAL" ), xFilial(cAlias) )
		For nX := 1 To Len( aHeader )
		  if !("_FILIAL" $ aHeader[nX, 2])
//		  	FieldPut( FieldPos( aHeader[nX, 2] ),  )
//		  elseif ("_SEQ" $ aHeader[nX, 2])		    
//		  else
			  FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			EndIf
		Next nX
	Endif
	MsUnLock()
Next nI
RestArea( aArea )
Return