#Include 'Protheus.ch'

/*/{Protheus.doc} XMLCTE14
(Ponto de entrada para editar Centro de Custo e Segmento antes de iniciar o lançamento da nota pela rotina MATA103 para editar campos Contábeis)
@type function
@author marce
@since 21/11/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function XMLCTE14()

	Local	aAreaOld	:= GetArea()
	Local	aCabF1		:= ParamIxb[1]
	Local	aItensD1	:= ParamIxb[2] // {{{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}},;
	//			   {{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}}}
	Local	oDlgCte14
	Local	oGetD1
	Local	aHeaderD1	:= {}
	Local	aColsD1		:= {}
	Local	iD1,iD2,iD3,iD4
	Local	lContinua	:= .F. 
	Local	aAlterD1	:= {}
	Local	aButtons	:= {} // Caso se deseja adicionar alguma consulta na tela, já fica a opção de adicionar funções 

	If lAutoExec
		Return .T. 
	Endif
	// Adiciona campos que poderão ser alterados/editados
	If GetNewPar("XM_LD1CONT",.F.)
		Aadd(aAlterD1,"D1_CONTA")
	Endif

	If GetNewPar("XM_LD1CCUS",.F.)
		Aadd(aAlterD1,"D1_CC")
	Endif

	If GetNewPar("XM_LD1CLVL",.F.)
		Aadd(aAlterD1,"D1_CLVL")
	Endif

	If GetNewPar("XM_LD1ITCC",.F.)
		Aadd(aAlterD1,"D1_ITEMCTA")
	Endif

	For iD1	:= 1 To Len(aItensD1)
		For iD2	:= 1 To Len(aItensD1[iD1])
			DbSelectArea("SX3")
			DbSetOrder(2)
			If DbSeek(aItensD1[iD1,iD2,1])
				// Se não existir a coluna ainda 
				If aScan(aHeaderD1,{|x| AllTrim(x[2]) == Alltrim(aItensD1[iD1,iD2,1])}) == 0
					Aadd(aHeaderD1		,{	TRIM(X3Titulo())	,;
					SX3->X3_CAMPO	,;
					SX3->X3_PICTURE	,;
					SX3->X3_TAMANHO	,;
					SX3->X3_DECIMAL	,;
					SX3->X3_VALID	,;
					SX3->X3_USADO	,;
					SX3->X3_TIPO	,;
					SX3->X3_F3		,;
					SX3->X3_CONTEXT	,;
					SX3->X3_CBOX	,;
					SX3->X3_RELACAO ,;
					SX3->X3_WHEN	,;
					SX3->X3_VISUAL	,;
					SX3->X3_VLDUSER	,;
					SX3->X3_PICTVAR	,;
					IIf(!Empty(SX3->X3_OBRIGAT),.T.,.F.)})
				Endif
			Endif
		Next
	Next

	// { {{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}},;
	//	 {{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}}}
	// aTotItem = aItensD1 
	For iD1	:= 1 To Len(aItensD1)
		Aadd(aColsD1,Array(Len(aHeaderD1)+1))

		For iD2	:= 1 To Len(aHeaderD1)
			iD3 	:=  aScan(aItensD1[iD1],{|x| AllTrim(x[1]) == Alltrim(aHeaderD1[iD2,2])})

			If iD3 > 0
				aColsD1[iD1,iD2] 	:= aItensD1[iD1,iD3,2]
			Endif
		Next
		aColsD1[iD1,Len(aHeaderD1)+1] := .F.
	Next



	DEFINE MSDIALOG oDlgCte14 TITLE (ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" Dados para lançamento do CTE") FROM 001,001 TO 220,1000 PIXEL

	oGetD1Cte:= MsNewGetDados():New(030,005,100,495,GD_UPDATE,"AllwaysTrue()"/*cLinhaOk*/,"AllwaysTrue()"/*cTudoOk*/,"",aAlterD1,1/*nFreeze*/,Len(aColsD1)/*nMax*/,"AllWaysTrue()"/*cCampoOk*/,"AllwaysTrue()"/*cSuperApagar*/,"AllWaysTrue()"/*cApagaOk*/,oDlgCte14,@aHeaderD1,@aColsD1,{|| .T.})
	oMulti:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT


	ACTIVATE MSDIALOG oDlgCte14 CENTERED ON INIT EnchoiceBar(oDlgCte14,{|| lContinua := .T. ,oDlgCte14:End()},{||oDlgCte14:End()},,aButtons)

	If lContinua
		// { {{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}},;
		//	 {{"D1_FILIAL"	,xFilial("SD1"),Nil},{"D1_COD",SC7->C7_PRODUTO,Nil}}}
		// aTotItem = aItensD1 
		// Efetua alteração dos campos permitidos de alteração
		For iD1 := 1 To Len(aItensD1)
			For iD2	:= 1 To Len(aItensD1[iD1])
				For iD3 := 1 To Len(aAlterD1)
					If Alltrim(aAlterD1[iD3]) == Alltrim(aItensD1[iD1,iD2,1])
						For iD4 := 1 To Len(oGetD1Cte:aHeader)
							If Alltrim(oGetD1Cte:aHeader[iD4,2]) == Alltrim(aAlterD1[iD3])
								aTotItem[iD1,iD2,2]	:= oGetD1Cte:aCols[iD1,iD4]
							Endif
						Next
					Endif
				Next	
			Next
		Next
	Endif

	RestArea(aAreaOld)

Return .T. 

