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
User Function CadRegPlm()
Local aArea := GetArea()
Private cCadastro := "Cadastro de Regras para Palm"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		     {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"U_MntCadReg" ,0 ,3} ,;
                     {"Alterar"    ,"U_MntCadReg" ,0 ,4} ,;
                     {"Excluir"    ,"U_MntCadReg" ,0 ,5} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// funcao que monta a tela para editar as regras de venda do palm
 	
//U_MntCadReg(cAlias)
mBrowse( 6,1,22,75,"SZI")
// retorna o ambiente anterior
RestArea(aArea)

Return

/********************************************************/
// Função para montar a tela de cadastro das regras do palm
/********************************************************/
User Function MntCadReg(cAlias, nReg, nOpc)
Local aArea := GetArea()
Local oDlg
Local oGet
Local oTPanel1
Local oTPAnel2	
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
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
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
	Endif
	dbSkip()
End
RestArea(aArea)

// Monta o ACols conforme os dados
dbSelectArea("SZI")
if (nOpc <> 3)
SZI->(dbSeek(xFilial("SZI")))
	While !EOF() .And. SZI->ZI_FILIAL == xFilial("SZI")	
		aAdd( aREG, SZI->( RecNo() ) )
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
	//aCOLS[1, GdFieldPos("ZI_SEQ")] := "01"
	aCOLS[1, Len( aHeader )+1 ] := .F.
EndIf

DEFINE MSDIALOG oDlg TITLE cCadastro From 0,0 To 400, 600 PIXEL OF oMainWnd

	oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
	oTPanel2:Align := CONTROL_ALIGN_BOTTOM
			
	oGet := MSGetDados():New(0,0,0,0,nOpc, , .T., "", .T., ;
		{"ZI_GRPCLI", "ZI_TIPCLI", "ZI_GRPPROD", "ZI_CODARM", "ZI_CONDPAG", "ZI_DESCMAX", "ZI_VALMIN"}, ;
		, .T., 256)
	
	oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

ACTIVATE MSDIALOG oDlg ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| GrvRegPlm(cAlias, nOpc), ODlg:End(), Nil }, {|| oDlg:End() })
Return


/********************************************************/
// Função para gravar os dados na tabela, avaliando exclusão e alteração
/********************************************************/
Static Function GrvRegPlm(cAlias, nOpc)
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
	  FieldPut( FieldPos( "ZI_FILIAL" ), xFilial(cAlias) )
	  FieldPut( FieldPos( "ZI_SEQ" ), cItem )
		For nX := 1 To Len( aHeader )
		  if ("_FILIAL" $ aHeader[nX, 2])
		  	FieldPut( FieldPos( aHeader[nX, 2] ),  )
		  elseif ("_SEQ" $ aHeader[nX, 2])
		    
		  else
			  FieldPut( FieldPos( aHeader[nX, 2] ), aCOLS[nI, nX] )
			EndIf
		Next nX
	Endif
	MsUnLock()
Next nI
 RestArea( aArea )
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ XEXPHZI             ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exportacao do cadastro de regras para venda no palm 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function XEXPHZI()
Local cAlias := "SZI"            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(01)
dbSeek(xFilial(cAlias))
ConOut("Inicio da exportacao de regras do palm")
While (cAlias)->(!Eof()) .And. (cAlias)->ZI_FILIAL == xFilial(cAlias)
	dbSelectArea("HZI")
	dbSetOrder(1)
	If !dbSeek(xFilial(cAlias) + (cAlias)->ZI_SEQ)
		RecLock("HZI",.T.)
	Else
		RecLock("HZI",.F.)
	EndIf
	
	HZI->HZI_FILIAL	:= xFilial(cAlias)
	HZI->HZI_ID	:= ""
	HZI->HZI_SEQ := SZI->ZI_SEQ
	HZI->HZI_GRPCLI := SZI->ZI_GRPCLI
	HZI->HZI_TIPCLI := SZI->ZI_TIPCLI
	HZI->HZI_GRPPRO := SZI->ZI_GRPPROD
	HZI->HZI_CODARM := SZI->ZI_CODARM
	HZI->HZI_CONDPA := SZI->ZI_CONDPAG
	HZI->HZI_DESMAX := SZI->ZI_DESCMAX
	HZI->HZI_VALMIN := SZI->ZI_VALMIN
	HZI->HZI_INTR := "I"
	HZI->HZI_VER := HHNextVer("","HZI")
	
	HZI->(MsUnlock())
	
	(cAlias)->(dbSkip())	
EndDo

ConOut("Fim da exportacao de regras do palm")

HHUpdCtr("","HZI")	

Return NIL
