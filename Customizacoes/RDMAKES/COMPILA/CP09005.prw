#Include "Protheus.Ch"
#Include "rwmake.Ch"
#Include "TopConn.Ch"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"     


//#DEFINE aCpoCabec	{"ZE1_GRUPO","ZE1_PRODUTO"}
#DEFINE aCpoCabec	{"ZE1_PEDIDO"}

//| TABELA
#DEFINE D_ALIAS 'ZE1'
#DEFINE D_TITULO 'Rateio Cartao'
#DEFINE D_ROTINA 'CP09005'
#DEFINE D_MODEL 'ZE1MODEL'
#DEFINE D_MODELMASTER 'ZE1MASTER'
#DEFINE D_VIEWMASTER 'VIEW_ZE1'

/*/{Protheus.doc} CP09005
Realiza Rateio de Pedido de Venda
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
User Function CP09005()

	Local oBrowse

	Private lDesOper	:= .F.
	Private lDesAmbi	:= .F.

	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias(D_ALIAS)
	oBrowse:SetDescription(D_TITULO)

	oBrowse:Activate()

Return(NIL)


/*/{Protheus.doc} MenuDef
Botoes do MBrowser    
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'             OPERATION 1 ACCESS 0
	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0                         
	ADD OPTION aRotina TITLE 'Incluir'  ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0  	
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0
	//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.'+D_ROTINA OPERATION 9 ACCESS 0
	ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.'+D_ROTINA OPERATION 8 ACCESS 0
	//ADD OPTION aRotina TITLE 'Legenda'  ACTION 'eval(oBrowse:aColumns[1]:GetDoubleClick())'             OPERATION 1 ACCESS 0



Return(aRotina)


/*/{Protheus.doc} ModelDef
Definicoes do Model   
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function ModelDef()

	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruZE1 := FWFormStruct( 1, D_ALIAS, { |cCampo| CPOCABEC(cCampo) } /*bAvalCampo*/,/*lViewUsado*/ )
	Local oStItemZE1 := FWFormStruct( 1, D_ALIAS, /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel, nI 


	/*------------------------------------------------------ Augusto Ribeiro | 12/10/2017 - 5:40:45 PM
	Altera inicializador Padrão dos itens para não apresentar erro de campo
	obrigatorio nao preenchido
	------------------------------------------------------------------------------------------*/
	FOR nI := 1 to len(aCpoCabec)
		oStItemZE1:SetProperty(aCpoCabec[nI], MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, '"*"'))
	NEXT nI



	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New(D_ROTINA+'MODEL',/*bPreValidacao*/, {  |oModel| U_CP09005V("MODEL_POS", oModel ) },{  |oModel| GRVDADOS( oModel ) }  , {||RollbackSX8(), .T.} )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'ZE1MASTER', /*cOwner*/, oStruZE1, /*bPreValidacao*/ { |oModel, nLine, cAction, cField| PRELMOD(oModel, nLine, cAction, cField) }, /*bPosValidacao*/, /*bCarga*/ )
	oModel:AddGrid( 'ZE1ITENS', 'ZE1MASTER', oStItemZE1, /* { |oModel, nLine, cAction, cField| PRELMOD(oModel, nLine, cAction, cField) } */ , {  |oModel| U_CP09005V("LINHA_POS", oModel ) }/*{ |oModel, nLine, cAction, cField| POSLMOD(oModel, nLine, cAction, cField) } bLinePost*/, /*bPreVal*/,	 /*bPosVal*/, /*BLoad*/ )


	//oModel:AddCalc( 'CP09TOTAIS', 'ZE1MASTER', 'ZE1ITENS', 'ZE1_VALOR' , 'TOTALTICKET', 'FORMULA', /*bCond */	, /*bInitValue*/ , 'Valor Pedido' , {|oModel| 100/*IIF(oModel:GetValue("ZE1MASTER","L1_VLRTOT") > 0, oModel:GetValue("SE1MASTER","L1_VLRTOT"),  oModel:GetValue("SE1MASTER","L1_VLRTOT") )*/ }, /*nTamanho*/, /*nDecimal*/)
	oModel:AddCalc( 'CP09TOTAIS', 'ZE1MASTER', 'ZE1ITENS', 'ZE1_VALOR' , 'TOTALLIQ'	, 'SUM', /*bCond */		, /*bInitValue*/ , 'Valor Rateado' ,/* bFormula */, /*nTamanho*/, /*nDecimal*/)
	//oModel:AddCalc( 'CP09TOTAIS', 'ZE1MASTER', 'ZE1ITENS', 'ZE1_VALOR' , 'SALDODES'	, 'FORMULA', /*bCond */	, /*bInitValue*/ , 'Saldo' , {|oModel| oModel:GetValue("CP09TOTAIS","TOTALTICKET") - oModel:GetValue("CP09TOTAIS","TOTALLIQ") }, /*nTamanho*/, /*nDecimal*/)


	//oModel:SetRelation( 'ZA3VALEMP',	{{ 'ZA3_FILIAL', 'ZA1_FILIAL' }, { 'ZA3_CODIGO', 'ZA1_CODIGO' } , { 'ZA3_REV', 'ZA1_REV' }},"ZA3_FILIAL+ZA3_CODIGO+ZA3_REV" )
	oModel:SetRelation( 'ZE1ITENS',	{{ 'ZE1_FILIAL', 'XFILIAL("SC5")' }, { 'ZE1_PEDIDO', 'C5_NUM' } },  ZE1->( IndexKey( 1 ) ) )


	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'ZE1MASTER' ):SetPrimaryKey( { 'ZE1_FILIAL', 'ZE1_PEDIDO', 'ZE1_ITEM'} )
	//oModel:GetModel( 'ZAWITENS' ):SetUniqueLine( { 'ZAW_FILIAL', 'ZAW_CODIND' } )

	//Se torna obrigatório contéudo da linha do Grid informado
	//oModel:GetModel( 'ZE1ITENS' ):SetOptional(.T.)
	//oModel:GetModel( 'ZAWITENS' ):SetOptional(.T.)

	//Se torna a apenas visual o contéudo da Linha do Grid informado
	//oModel:GetModel( 'ZE1MASTER' ):SetOnlyView ( .T. )   

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( D_TITULO )

	// Liga o controle de nao repeticao de linha
	//oModel:GetModel( 'ZE1ITENS' ):SetUniqueLine( { 'ZE1_CODCTR','ZE1_REVCTR','ZE1_ITECTR' } )


	//oStItemZE1:SetProperty( 'ZE1_FILIAL' , MODEL_FIELD_WHEN   , {|| .T.})


	// Liga a validação da ativacao do Modelo de Dados
	//oModel:SetVldActivate( { |oModel,cAcao| U_FAT06VLD('MODEL_ACTIVE', oModel) } )

Return(oModel)

/*/{Protheus.doc} ViewDef
Definicoes da View
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/  
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( D_ROTINA )
	// Para a interface (View) a função FWFormStruct, traz para a estrutura os campos conforme o nível, uso ou módulo. 
	Local oStruZE1 := FWFormStruct( 2, D_ALIAS,  { |cCampo| CPOCABEC(cCampo) })
	Local oStItemZE1 := FWFormStruct( 2, D_ALIAS, { |cCampo| !CPOCABEC(cCampo) })

	Local oView, cOrdemCpo, nI
	Local aCpoView 	:= {} 


	oStruZE1:SetProperty( '*'				, MVC_VIEW_CANCHANGE  , .F. )
	oStItemZE1:SetProperty( 'ZE1_DESCFO'		, MVC_VIEW_CANCHANGE  , .F. )

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	// Cria o objeto de Estrutura 

	// Cria o objeto de Estrutura
	oCalcTot := FWCalcStruct( oModel:GetModel( 'CP09TOTAIS') )

	//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
	oView:AddField( 'VIEW_CALC', oCalcTot, 'CP09TOTAIS' )


	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( D_VIEWMASTER , oStruZE1 , D_MODELMASTER )
	oView:AddGrid ( 'VIEW_ZE1ITEM'   , oStItemZE1 , 'ZE1ITENS' )
	//oView:AddGrid ( 'VIEW_ZAW'   , oStructZAW , 'ZAWITENS' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'SUPERIOR'  	, 20   )    
	oView:CreateHorizontalBox( 'INFERIOR'  	, 60   )
	oView:CreateHorizontalBox( 'RODAPE' 	, 20   )

	//oView:CreateVerticalBox( 'LEFT_INF1'	, 48 , 'INFERIOR' )
	//oView:CreateVerticalBox( 'RIGHT_INF'	, 52 , 'INFERIOR' )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( D_VIEWMASTER, 'SUPERIOR' )
	oView:SetOwnerView( "VIEW_ZE1ITEM"  ,  'INFERIOR' )
	oView:SetOwnerView( "VIEW_CALC"  , 'RODAPE' )

	//oView:SetOwnerView( "VIEW_ZAW" , 'RIGHT_INF' )

	oView:AddIncrementField( 'VIEW_ZE1ITEM', 'ZE1_ITEM' )

	// Informa os titulos dos box da View
	oView:EnableTitleView(D_VIEWMASTER,'Pedido')
	oView:EnableTitleView('VIEW_ZE1ITEM','Rateio')
	oView:EnableTitleView('VIEW_CALC','Totalizador')
	//oView:EnableTitleView('VIEW_ZAW','Histórico de indíces %')


	oView:SetFieldAction(  'ZE1_VALOR',   {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
	oView:SetFieldAction(  'ZE1_FORMPG',  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )
	oView:SetFieldAction(  'ZE1_AUTORI',  {  |oView,  cIDView,  cField,  xValue|  GITECTR(  oView,  cIDView, cField, xValue ) } )


	oView:SetCloseOnOk({||.T.})


Return(oView)



/*/{Protheus.doc} GRVDADOS
Grava Dados
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function GRVDADOS(oModel)
	Local lRet	:= .T.
	Local nOperation	:= oModel:GetOperation()
	Local oModCabec	:= oModel:GetModel(D_MODELMASTER)
	Local oModItem		:= oModel:GetModel('ZE1ITENS')
	Local cCodTicket	:= ""
	Local nI, nY


	IF nOperation == 3 .OR. nOperation == 4
		FOR nI := 1 to oModItem:Length()

			oModItem:GoLine( nI )


			FOR nY := 1 TO LEN(aCpoCabec)	
				oModItem:LOADVALUE(aCpoCabec[nY], oModCabec:GetValue(aCpoCabec[nY]))	
			NEXT nY

		next nI
	ENDIF


	aRet	:= GRVMODEL(oModItem)


Return(lRet)



/*/{Protheus.doc} POSMODEL
Validação Pos Model
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function POSMODEL(oModel)
	Local lRet	:= .T.
	Local nY, nAux
	Local nOperation	:= oModel:GetOperation()


Return(lRet)


/*/{Protheus.doc} GRVMODEL
Grava dados da Model no banco
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function GRVMODEL(oObjeto)
	Local aRet	:= {.F.,""}
	Local nOperation := oObjeto:GetOperation()
	Local cOldAlias	:= ""
	Local bBefore,bAfter,nOperation,oSuperObjeto, bAfterSTTS
	Local nY, nX, nLen, cAlias

	bBefore 	:= {|| .T.}
	bAfter		:= {|| .T.}
	bAfterSTTS	:= {|| .T.}

	cAlias	:= oObjeto:oFormModelStruct:GetTable()[FORM_STRUCT_TABLE_ALIAS_ID]

	IF !EMPTY(cAlias)

		aRelation := oObjeto:GetRelation()
		aDados    := oObjeto:GetData()
		aStruct   := oObjeto:oFormModelStruct:GetFields()
		IF ALLTRIM(oObjeto:ClassName()) == "FWFORMGRID"

			If (nOperation == MODEL_OPERATION_INSERT) .OR. (nOperation == MODEL_OPERATION_UPDATE)

				For nY := 1 To Len(aDados)
					oObjeto:GoLine(nY)
					lLock     := .F.
					nNextOper := 0
					//--------------------------------------------------------------------
					//Verifica o tipo de atualicao ( Insert ou Update )
					//--------------------------------------------------------------------
					If aDados[nY][MODEL_GRID_ID] <> 0
						//--------------------------------------------------------------------
						//Verifica se uma das linhas foi atualizada
						//--------------------------------------------------------------------
						For nX := 1 To Len(aStruct)
							If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX]
								lLock := .T.
								Exit
							EndIf
						Next nX
						If aDados[nY][MODEL_GRID_DELETE] .Or. lLock
							(cAlias)->(MsGoto(aDados[nY][MODEL_GRID_ID]))
							RecLock(cAlias,.F.)
							lLock     := .T.
						EndIf
						nNextOper := nOperation
						If aDados[nY][MODEL_GRID_DELETE]
							nNextOper := MODEL_OPERATION_DELETE
						EndIf
					Else				
						For nX := 1 To Len(aStruct)
							If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX] .And. !aDados[nY][MODEL_GRID_DELETE]
								lLock     := .T.
								nNextOper := nOperation
								Exit
							EndIf
						Next nX
						If lLock
							//--------------------------------------------------------------------
							//Quando as estruturas sao da mesma tabela - Modelo 2
							//--------------------------------------------------------------------
							If (nY == 1 .And. cAlias == cOldAlias)
								RecLock(cAlias,.F.)
							Else
								RecLock(cAlias,.T.)
							EndIf
						EndIf
					EndIf
					If lLock
						//--------------------------------------------------------------------
						//Executa o bloco de código de Pre-atualização
						//--------------------------------------------------------------------
						If !Empty(bBefore)
							(cAlias)->(Eval(bBefore,oObjeto,oObjeto:cID,cAlias))
						EndIf
						//--------------------------------------------------------------------
						//Verifica se a linha foi deletada
						//--------------------------------------------------------------------
						If aDados[nY][MODEL_GRID_DELETE]
							(cAlias)->(dbDelete())
						Else
							//--------------------------------------------------------------------
							//Efetua a gravacao dos campos                    
							//--------------------------------------------------------------------
							For nX := 1 To Len(aStruct)
								If aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_UPDATE][nX] .Or. aDados[nY][MODEL_GRID_ID] == 0
									If (cAlias)->(FieldPos(aStruct[nX][MODEL_FIELD_IDFIELD])) > 0
										(cAlias)->(FieldPut(FieldPos(aStruct[nX][MODEL_FIELD_IDFIELD]),aDados[nY][MODEL_GRID_DATA][MODEL_GRIDLINE_VALUE][nX]))
									EndIf
								EndIf
							Next nX
							If (cAlias)->(FieldPos(PrefixoCpo(cAlias)+"_FILIAL")) > 0 .And. nOperation == MODEL_OPERATION_INSERT .And. !Empty(xFilial(cAlias))
								(cAlias)->(FieldPut(FieldPos(PrefixoCpo(cAlias)+"_FILIAL"),xFilial(cAlias)))
							EndIf
							//--------------------------------------------------------------------
							//Efetua a gravacao das chaves estrangeiras       
							//--------------------------------------------------------------------
							For nX := 1 To Len(aRelation[MODEL_RELATION_RULES])
								oModel := Nil							
								If oObjeto:GetModel():GetIdField(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET],@oModel) == 0
									xValue := &(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET])
								Else								
									xValue := oModel:GetValue(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_TARGET])
								EndIf
								(cAlias)->(FieldPut(FieldPos(aRelation[MODEL_RELATION_RULES][nX][MODEL_RELATION_RULES_ORIGEM]),xValue))
							Next nX
							//--------------------------------------------------------------------
							//Efetua a gravacao do modelo 2                   
							//--------------------------------------------------------------------
							If (nY <> 1 .And. cAlias == cOldAlias)
								aOldDados := oSuperObjeto:GetData()
								For nX := 1 To Len(aOldDados)
									If aOldDados[nX][MODEL_DATA_UPDATE] .Or. (nOperation == MODEL_OPERATION_INSERT)
										If (cAlias)->(FieldPos(aOldDados[nX][MODEL_DATA_IDFIELD])) > 0
											(cAlias)->(FieldPut(FieldPos(aOldDados[nX][MODEL_DATA_IDFIELD]),aOldDados[nX][MODEL_DATA_VALUE]))
										EndIf
									EndIf
								Next nX						
							EndIf
						EndIf
						//--------------------------------------------------------------------
						//Efetua a gravacao do bloco de código de pos-validação
						//--------------------------------------------------------------------
						(cAlias)->(Eval(bAfter,oObjeto,oObjeto:cID,cAlias))
					EndIf
					//--------------------------------------------------------------------
					//Seleciona o modelos em que este é proprietário.
					//--------------------------------------------------------------------
					/*If nNextOper <> 0
					For nX := 1 To Len(aModel[MODEL_STRUCT_OWNER])
					ExFormCommit(aModel[MODEL_STRUCT_OWNER][nX],bBefore,bAfter,nNextOper,oObjeto)						
					Next nX
					EndIf*/
				Next nY


				aRet	:= {.T.,""}


			ELSE

				If oObjeto:ClassName()=="FWFORMGRID"
					//--------------------------------------------------------------------
					//Efetua a gravacao da estrutura FWFORMGRID
					//--------------------------------------------------------------------
					If !Empty(cAlias)
						For nY := 1 To Len(aDados)
							lLock     := .F.
							oObjeto:GoLine(nY)
							//--------------------------------------------------------------------
							//Verifica o tipo de atualicao ( Insert ou Update )
							//--------------------------------------------------------------------
							If aDados[nY][MODEL_GRID_ID] <> 0
								(cAlias)->(MsGoto(aDados[nY][MODEL_GRID_ID]))
								RecLock(cAlias,.F.)
								lLock     := .T.
							EndIf
							If lLock
								/*
								//--------------------------------------------------------------------
								//Seleciona o modelos em que este é proprietário.
								//--------------------------------------------------------------------
								For nX := 1 To Len(aModel[MODEL_STRUCT_OWNER])
								ExFormCommit(aModel[MODEL_STRUCT_OWNER][nX],bBefore,bAfter,nNextOper,oObjeto)
								Next nX
								//--------------------------------------------------------------------
								//Executa o bloco de código de Pre-atualização
								//--------------------------------------------------------------------
								If !Empty(bBefore)
								(cAlias)->(Eval(bBefore,oObjeto,oObjeto:cID,cAlias))
								EndIf
								*/
								//--------------------------------------------------------------------
								//Efetua a gravacao dos campos                    
								//--------------------------------------------------------------------
								(cAlias)->(dbDelete())
								//--------------------------------------------------------------------
								//Efetua a gravacao do bloco de código de pos-validação
								//--------------------------------------------------------------------
								(cAlias)->(Eval(bAfter,oObjeto,oObjeto:cID,cAlias))
							EndIf
						Next nY
					EndIf	
				EndIf		


				aRet	:= {.T.,""}
			ENDIF

		ELSEIF ALLTRIM(oModCabec:ClassName())  == "FWFORMFIELDS"
			aRet[2] := "FWFORMFIELDS nao implementada." 
		ENDIF
	ENDIF


Return(aRet)



/*/{Protheus.doc} PRELMOD
Pre-Validacao 
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function PRELMOD(oModel, nLine, cAction, cField)
	Local lRet 		:= .T.
	Local oModFull		:= oModel:GetModel()
	Local nOperation := oModel:GetOperation()
	Local oView

	cAction := ALLTRIM(cAction)

	IF nOperation == MODEL_OPERATION_INSERT 
		//	oModel:LoadValue("ZE1_FILAUX ", XFILIAL("ZE1"))
	ENDIF 

	//oModel:LoadValue("ZE1_ITEM", STRZERO(oModel:GetLine(),3))

	//IF cAction == 'CANSETVALUE' .AND. (nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE) 
	//
	//	IF EMPTY(oModel:GetValue("ZE1_CODREF"))
	//		oView	:= FWViewActive()
	//
	//		oModel:LoadValue("ZE1_CODREF", oModFull:GetValue("ZE1MASTER", "ZE1_CODIGO"))
	//		
	//		/*
	//		oModel:LoadValue("ZE1_CODCTR", oModFull:GetValue("ZE1MASTER", "ZE1_CODCTR"))
	//		//oModel:LoadValue("ZE1_REVCTR", oModFull:GetValue("ZE1MASTER", "ZE1_REVCTR"))		
	//		oModel:LoadValue("ZE1_REVCTR", ZA2->ZA2_REV)
	//		oModel:LoadValue("ZE1_CODCLI", oModFull:GetValue("ZE1MASTER", "ZE1_CODCLI"))
	//		oModel:LoadValue("ZE1_LOJA", oModFull:GetValue("ZE1MASTER", "ZE1_LOJA"))		
	//		oModel:LoadValue("ZE1_UM", oModFull:GetValue("ZE1MASTER", "ZE1_UM"))
	//		
	//		//oModel:LoadValue("ZE1_MANIF", oModFull:GetValue("ZE1MASTER", "ZE1_MANIF"))
	//		oModel:LoadValue("ZE1_PLACA", oModFull:GetValue("ZE1MASTER", "ZE1_PLACA"))
	//		oModel:LoadValue("ZE1_NOMMOT", oModFull:GetValue("ZE1MASTER", "ZE1_NOMMOT"))		
	//		oModel:LoadValue("ZE1_DTENT", oModFull:GetValue("ZE1MASTER", "ZE1_DTENT"))
	//		oModel:LoadValue("ZE1_HRENT", oModFull:GetValue("ZE1MASTER", "ZE1_HRENT"))		
	//		oModel:LoadValue("ZE1_DTSAI", oModFull:GetValue("ZE1MASTER", "ZE1_DTSAI"))
	//		oModel:LoadValue("ZE1_HRSAI", oModFull:GetValue("ZE1MASTER", "ZE1_HRSAI"))
	//		
	//		oModel:LoadValue("ZE1_TIPCLI", oModFull:GetValue("ZE1MASTER", "ZE1_TIPCLI"))
	//		oModel:LoadValue("ZE1_CODORI", ZA2->ZA2_CODORI)
	//		oModel:LoadValue("ZE1_TARA", oModFull:GetValue("ZE1MASTER", "ZE1_TARA"))
	//		oModel:LoadValue("ZE1_TRANSP", oModFull:GetValue("ZE1MASTER", "ZE1_TRANSP"))
	//		oModel:LoadValue("ZE1_CODGER", oModFull:GetValue("ZE1MASTER", "ZE1_CODGER"))
	//		oModel:LoadValue("ZE1_BALENT", oModFull:GetValue("ZE1MASTER", "ZE1_BALENT"))
	//		oModel:LoadValue("ZE1_BALSAI", oModFull:GetValue("ZE1MASTER", "ZE1_BALSAI"))
	//		oModel:LoadValue("ZE1_CODSET", oModFull:GetValue("ZE1MASTER", "ZE1_CODSET"))
	//		oModel:LoadValue("ZE1_CODCIR", oModFull:GetValue("ZE1MASTER", "ZE1_CODCIR"))
	//		oModel:LoadValue("ZE1_PSSAI", oModFull:GetValue("ZE1MASTER", "ZE1_TARA"))
	//		
	//		oModel:LoadValue("ZE1_CODNAT", oModFull:GetValue("ZE1MASTER", "ZE1_CODNAT"))		
	//		oModel:LoadValue("ZE1_LOTE", oModFull:GetValue("ZE1MASTER", "ZE1_LOTE"))
	//		oModel:LoadValue("ZE1_COTA", oModFull:GetValue("ZE1MASTER", "ZE1_COTA"))
	//		
	//		IF lDesOper
	//			oModel:LoadValue("ZE1_ORIREG", "2")
	//		ELSEIF lDesAmbi
	//			oModel:LoadValue("ZE1_ORIREG", "4")		
	//		ENDIF
	//		
	//		oModel:LoadValue("ZE1_OBS", "")
	//		*/
	//		oView:Refresh()
	//	ENDIF
	//
	//ELSEIF cAction == 'DELETE' //.AND.  EMPTY(oModel:GetValue("ZE1_CODREF"))
	//
	//	ROLLBACKSX8()
	//	
	//ENDIF



Return(lRet)


/*/{Protheus.doc} GITECTR
Preenche demais campos como Gatilho via SetFieldAction
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function GITECTR( oView,  cIDView, cField, xValue)
	Local oModFull 		:= oView:GetModel()
	Local oModItem 		:= oModFull:GetModel('ZE1ITENS')
	Local cMsgAviso, nI, nY, nTotLen
	Local aColsEmp		:= {}
	Local nOperation 	:= oModFull:GetOperation()
	Local aSaveLines 	:= FWSaveRows()
	Local cCodAut		:= ""
	Local nLinhAt		:= oModItem:Goline(aSaveLines[1][2])
	/*
	O valor 3 quando é uma inclusão;
	O valor 4 quando é uma alteração;
	O valor 5 quando é uma exclusão.
	*/

	oModFull:SetValue("ZE1MASTER","ZE1_PEDIDO", M->C5_NUM )


	IF ALLTRIM(cField) == "ZE1_FORMPG"
		IF ExistCpo("SX5","24"+ oModItem:GetValue("ZE1_FORMPG") )
			oModItem:LoadValue("ZE1_DESCFO", LEFT(Posicione("SX5",1,xFilial("SX5")+"24" + oModItem:GetValue("ZE1_FORMPG") ,"X5_DESCRI"),30) )
		ELSE
			Help(" ",1,"Forma Pagto.",," A Forma Pagto. é invalida. " ,4,5)
			oModItem:LoadValue("ZE1_FORMPG", "")
		ENDIF 
	ENDIF 

	IF ALLTRIM(cField) == "ZE1_AUTORI"
		cCodAut :=  ALLTRIM(oModItem:GetValue("ZE1_AUTORI"))
		
		For nI := 1 To oModItem:Length()
			oModItem:GoLine( nI )
			
			IF cCodAut == ALLTRIM(oModItem:GetValue("ZE1_AUTORI")) .AND. nLinhAt <> nI 
				Help(" ",1,"Autorizacao Invalida",," O codigo de autorizacao " + cCodAut + " já foi utilizado na linha " + ALLTRIM(STR(nI)) ,4,5)
				oModItem:GoLine( nLinhAt )
				oModItem:LoadValue("ZE1_AUTORI", "")
				oModItem:GoLine( nI )
			ENDIF 
		Next
	ENDIF 

	FWRestRows( aSaveLines )

	oView:Refresh()	   

Return NIL 




/*/{Protheus.doc} POSLMOD
POS-Validacao
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
Static Function POSLMOD(oModel, nLine, cAction, cField)
	Local lRet 	   		:= .T.
	Local oModFull		:= oModel:GetModel()
	Local nOperation 	:= oModel:GetOperation()
	Local oView

	//cAction := ALLTRIM(cAction)

	//oModel:LoadValue("ZE1_CODIGO", oModFull:GetValue("ZE1MASTER", "ZE1_CODIGO"))
	//oModel:LoadValue("ZE1_ITEM", STRZERO(oModel:GetLine(),3))

	IF nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE

		IF EMPTY(oModel:GetValue("ZE1_ITECTR"))
			lRet := .F.
			Help(" ",1,"ZE1_ITECTR",,"Item de contrato esta vazio. Campo de preenchimento obrigatorio" ,4,5)			
		ENDIF



	ENDIF



Return(lRet)



/*/{Protheus.doc} CPOCABEC
(long_description)
@author Augusto Ribeiro | www.compila.com.br
@since 12/10/2017
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CPOCABEC(cCampo)
	Local lRet	:= .F.

	Default cCampo	:= ""

	cCampo	:= ALLTRIM(cCampo)


	IF ASCAN(aCpoCabec, cCampo) > 0
		lRet	:= .T.
	ENDIF
	/*
	IF cCampo == "ZE1_CODIGO" .OR.;
	cCampo == "ZE1_DESC"

	lRet	:= .T.

	ENDIF

	*/

Return(lRet)


/*/{Protheus.doc} CP09005V
validação após a confirmação dos dados.
@author Fabio Sales | www.compila.com.br
@since 13/01/2019
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function CP09005V(cModel, oModel)

	Local lRet		:= .F.
	Local nOperation:= oModel:GetOperation()
	Local cMsgErro	:= ""
	Local oModZE1	:= Nil
	Local oModFull	:= Nil
	Local nLenZE1	:= 0
	Local clCodAut	:= ""
	Local clCodAdq	:= ""
	Local clFormPg	:= ""
	Local nI
	
	Default cModel	:= ""
		
	/*----------------
		PRE VALIDACOES ANTES DE ABRIR A INTERFACE 
	-------------------*/
	IF nOperation == MODEL_OPERATION_VIEW
	
		lRet	:= .T.
		
	/*--------------------------------------------
		MODEL_POS - Validações na confirmação
		LINHA_POS - validações da linha.
	-------------------*/
		
	ELSEIF cModel $ "MODEL_POS|LINHA_POS"
		
		IF cModel == "LINHA_POS"
		
			oModFull	:= oModel:GetModel()		
			oModZE1		:= oModFull:GetModel("ZE1ITENS")
			
		ELSE
						
			oModZE1	:= oModel:GetModel( 'ZE1ITENS' )			
			
		ENDIF
		
		nLenZE1	:= oModZE1:Length()
		
	 	FOR nI := 1 TO nLenZE1
	 	
			oModZE1:GoLine( nI )
			
			IF !(oModZE1:IsDeleted())
				
				clFormPg := Alltrim(oModZE1:GetValue("ZE1_FORMPG"))
				
				IF clFormPg == "CC" .OR. clFormPg == "CD"
										
					clCodAut := ALLTRIM(oModZE1:GetValue("ZE1_AUTORI"))
					clCodAdq := ALLTRIM(oModZE1:GetValue("ZE1_CODADQ"))
					
					IF  EMPTY(clCodAut) .OR. EMPTY(clCodAdq)
					
						cMsgErro := "Código de autorização ou adiquirente não podem está vazio para as formas de pagamento CC ou CD."
						EXIT
						
					ENDIF

					IF clCodAdq <> "004"  .OR. (clCodAdq == "004" .AND. clFormPg == "CC") //| RedeCard
						
						IF LEN(clCodAut) <> 6
						
							cMsgErro := "Adiquirentes diferentes de 004 possuem 6 dígitos no código de autorização."
							EXIT
							
						ENDIF
						
					ELSE
					
						IF !(LEN(clCodAut) > 6 .AND. LEN(clCodAut) <= 12) //LEN(clCodAut) <> 12
						
							cMsgErro := "Venda a débito da adquirente REDE, deve-se infomar o Comprovante de Venda (Maior que 6 digitos)."
							
						ENDIF
					
					ENDIF
	
				ENDIF
				
			ENDIF
					
		NEXT nI
		
	ENDIF
		
	IF EMPTY(cMsgErro)
		lRet := .T.
	ELSE
		lRet := .F.
		Help(" ",1,"CP09005V-"+cModel,,cMsgErro,4,5)
	ENDIF

Return(lRet)
