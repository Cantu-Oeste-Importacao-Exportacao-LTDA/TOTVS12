//+--------------------------------------------------------------------+
//| Rotina | Varias   | Autor | Flavio Dias        | Data | 07.08.2008 |
//+--------------------------------------------------------------------+
//| Descr. | Edição de parametros de data para fiscal                  |
//+--------------------------------------------------------------------+
//| Uso    | Específico Cantu                                          |
//+--------------------------------------------------------------------+
#Include "Protheus.ch"
/*************************************************************
 Controle de data de fechamento do estoque
 *************************************************************/
User Function DtFecEst()
	local aArea
	Private cCadastro := "Data de Fechamento do Estoque"
	Private aRotina := {}
	Private cAlias := "SX6"	
	Private nOpc := 4 
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
  
  aArea := GetArea()
	
	SX6->(dbSetOrder(1))
  
  // seta o filtro , foi usado o método ao invés do string pq tava dando erro
	SX6->(DbSetFilter({|| X6_VAR == "MV_ULMES  "}, "(0 == 0)"))
 	
 	// tem que ter a variavel pq é usada no GetDados
  aAdd( aRotina, {"Alterar"    ,'U_Mod2Mnt',0,nOpc})
	
	SX6->(dbGoTop())
	
	Mod2Mnt(cAlias)
	
	SX6->(DBClearFilter())
	
	// retorna o ambiente anterior
	RestArea(aArea)
	
Return


/*************************************************************
 Controle de data de bloqueio de movimentação do estoque
 *************************************************************/
User Function DtBlqEst()
	local aArea
	Private cCadastro := "Data de Bloqueio do Estoque"
	Private aRotina := {}
	Private cAlias := "SX6"	
	Private nOpc := 4
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
  
  aArea := GetArea()
	
	SX6->(dbSetOrder(1))
  
  // seta o filtro , foi usado o método ao invés do string pq tava dando erro
	SX6->(DbSetFilter({|| X6_VAR == "MV_DBLQMOV"}, "(0 == 0)"))
 	
 	// tem que ter a variavel pq é usada no GetDados
  aAdd( aRotina, {"Alterar"    ,'U_Mod2Mnt',0,nOpc})
	
	SX6->(dbGoTop())
	
	Mod2Mnt(cAlias)
	
	SX6->(DBClearFilter())
	
	// retorna o ambiente anterior
	RestArea(aArea)
	
Return

//+--------------------------------------------------------------------+
//| Rotina | Mod2aHeader | Autor | Robson Luiz (rleg) |Data|01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aHeader.                       |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+
Static Function Mod2aHeader()

  //Montagem do aHeader
  aAdd(aHeader,{"Filial"		,"X6_FIL","@!",2,0,"AllwaysTrue()", "","C","","R"})
  aAdd(aHeader,{"Parâmetro"	,"X6_VAR","@!",15,0,"AllwaysTrue()", "","C","","R"})
  aAdd(aHeader,{"Descricao","X6_DESCRIC","@!",40,0,"AllwaysTrue()", "","C","","R"})
  aAdd(aHeader,{"Data","X6_CONTEUD","@D",8,0,"AllwaysTrue()", "","D","","R"}) 

Return

//+--------------------------------------------------------------------+
//| Rotina | Mod2aCOLS | Autor | Robson Luiz (rleg) |Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para montar o vetor aCOLS.                         |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+
Static Function Mod2aCOLS( cAlias)
	Local aArea := GetArea()
	Local nI := 0	
	
  dbSelectArea("SX6")
	SX6->(dbGoTop())
	While !EOF()		
		aAdd( aREG, SX6->( RecNo() ) )
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		For nI := 1 To Len( aHeader )
			If aHeader[nI,10] == "V"
				aCOLS[Len(aCOLS),nI] := CriaVar(aHeader[nI,2],.T.)
			Elseif nI == 4 // O quarto campo é o conteúdo do campo de data, que precisa ser formatado
			  aCOLS[Len(aCOLS),nI] := SToD(AllTrim(SX6->X6_CONTEUD))
			Else
				aCOLS[Len(aCOLS),nI] := FieldGet(FieldPos(aHeader[nI,2]))
			Endif
		Next nI
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		dbSkip()
	End	
	
	Restarea( aArea )
Return

//+--------------------------------------------------------------------+
//| Rotina | Mod2GrvA | Autor | Robson Luiz (rleg) | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para gravar os dados na alteração.                 |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+
Static Function Mod2GrvA()
	Local aArea := GetArea()
	Local nI := 0
	Local nX := 0
	
	For nI := 1 To Len( aREG )
		If nI <= Len( aREG )
			// posiciona
			dbGoTo( aREG[nI] )
			// bloqueia o registro
			RecLock("SX6",.F.)			
		
			If !aCOLS[nI, Len(aHeader)+1]  // avalia se foi alterado (o último campo guarda esta informação)
				SX6->X6_CONTEUD := DToS(aCols[nI, 4])
			Endif
			// Desbloqueia
			MsUnLock()
		EndIf
	Next nI
 RestArea( aArea )
Return


//+--------------------------------------------------------------------+
//| Rotina | Mod2Mnt | Autor | Robson Luiz (rleg)  | Data | 01.01.2007 |
//+--------------------------------------------------------------------+
//| Descr. | Rotina para Visualizar, Alterar e Excluir dados.          |
//+--------------------------------------------------------------------+
//| Uso    | Para treinamento e capacitação.                           |
//+--------------------------------------------------------------------+
Static Function Mod2Mnt(cAlias)
    
	Local oDlg
	Local oGet
	Local oTPanel1
	Local oTPAnel2	
	Private aHeader := {}
	Private aCOLS := {}
	Private aREG := {}
	
	dbSelectArea( cAlias )
	// alimenta a variável aHeader
	Mod2aHeader()
	// alimenta a variável aCols
	Mod2aCOLS( cAlias)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From 8,0 To 28,80 OF oMainWnd

		oTPanel2 := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel2:Align := CONTROL_ALIGN_BOTTOM
				
		oGet := MSGetDados():New(0,0,0,0,1, , .T., "", .F., {"X6_CONTEUD"}, , , Len(aCols))
		
		oGet:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	
	ACTIVATE MSDIALOG oDlg CENTER ON INIT ;
	EnchoiceBar(oDlg,{|| Mod2GrvA(), ODlg:End(), Nil }, {|| oDlg:End() })
Return