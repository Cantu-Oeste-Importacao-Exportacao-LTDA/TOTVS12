#include "rwmake.ch"
#include "TopConn.ch"
/* Função para manutencao data tabela de preço por cliente e por vendedor*/
User Function ManZZ5()
Local aArea := GetArea()
Private cCadastro := "Cadastro de Vendedor X Cliente X Tabela de Preço"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		     {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"U_MntZZ5" ,0 ,3} ,;
                     {"Alterar"    ,"U_MntZZ5" ,0 ,4} ,;
                     {"Excluir"    ,"U_MntZZ5" ,0 ,5} }    
                     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// funcao que monta a tela para editar as regras de venda do palm
Alert("Utilize a rotina 'VendxCliXSegxTab.prc'. Esta rotina foi descontinuada.")	
Return
//U_MntCadReg(cAlias)
mBrowse( 6,1,22,75,"ZZ5")
// retorna o ambiente anterior
RestArea(aArea)

Return

/********************************************************/
// Função para montar a tela de cadastro das Tes Inteligente
/********************************************************/
User Function MntZZ5(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2	
Local aCpoAlt := {}
Private aHeader := {}
Private aCOLS := {}
//Private aREG := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// monta o aHeader
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek( cAlias )
While !EOF() .And. X3_ARQUIVO == cAlias
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL //.And. !(AllTrim(X3_CAMPO) $ "ZZ5_CLIENT/ZZ5_LOJA")
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

// Flavio - 18/08/2011
// Ajustado para permitir gravar mais de uma tabela de preço para um mesmo cliente.
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

// Monta o ACols conforme os dados
dbSelectArea("ZZ5")
if (nOpc <> 3)
ZZ5->(dbSeek(xFilial("ZZ5")))
	While !EOF() .And. ZZ5->ZZ5_FILIAL == xFilial("ZZ5")	
//		aAdd( aREG, ZZ5->( RecNo() ) )
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader ) - 1
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
else // inclusão
	aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
	For nI := 1 To Len( aHeader ) -1
		aCOLS[1, nI] := CriaVar( aHeader[nI, 2], .T. )
	Next nI
	aCOLS[Len(aCOLS),Len(aHeader)] := 0
	aCOLS[1, Len( aHeader )+1 ] := .F.
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 400, 600 PIXEL OF oMainWnd

	oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_BOTTOM
	oGet := MSGetDados():New(0,0,0,0,nOpc, , .T., "", .T., ;
		{"ZZ5_CLIENT", "ZZ5_LOJA", "ZZ5_VEND", "ZZ5_TABELA"}, , .T., 256)
	
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| GrvZZ5(cAlias, nOpc), ODlg:End(), Nil }, {|| oDlg:End() })
Return


/********************************************************/
// Função para gravar os dados na tabela, avaliando exclusão e alteração
/********************************************************/
Static Function GrvZZ5(cAlias, nOpc)
Local aArea := GetArea()
Local nI := 0
Local nX := 0
Local cItem := "00"

// Exclusão
if (nOpc == 5)
  For nI := 1 To Len( aCOLS )
  	if (aCOLS[nI, Len(aHeader)] > 0)	
			dbGoTo(aCOLS[nI, Len(aHeader)])
			RecLock(cAlias,.F.)
			dbDelete()
			MsUnLock()
		EndIf
	Next nI
  Return
EndIf

Alert(nOpc)

// Inclusão
if (nOpc == 3) 
Endif
// Alteração
For nI := 1 To Len(aCols)	
	// se o item já existe
	If (aCOLS[nI, Len(aHeader)] > 0)
		dbGoTo( aCOLS[nI, Len(aHeader)] )
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
	  FieldPut( FieldPos( "ZZ5_FILIAL" ), xFilial(cAlias) )
		For nX := 1 To Len( aHeader ) -1
		  if !("_FILIAL" $ aHeader[nX, 2])
			FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			EndIf
		Next nX
	Endif
	MsUnLock()
Next nI
RestArea( aArea )
Return