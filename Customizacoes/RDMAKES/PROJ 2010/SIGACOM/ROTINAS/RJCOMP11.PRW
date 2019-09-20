#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCOMP11   บAutor  ณRafael Parma       บ Data ณ  21/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de regras de descontos fixos para for- บฑฑ
ฑฑบ          ณnecedores, aplicada na inclusใo documento de entrada.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJCOMP11()
*-------------------------*

PRIVATE aRotina := { { OemToAnsi("Pesquisar")  		,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar") 		,"U_RJC11WIN" , 0 , 2} ,;
					 { OemToAnsi("Incluir")    		,"U_RJC11WIN" , 0 , 3} ,;
					 { OemToAnsi("Alterar")    		,"U_RJC11WIN" , 0 , 4} ,;
					 { OemToAnsi("Excluir")    		,"U_RJC11WIN" , 0 , 5} } 
					 
PRIVATE cCadastro  := OemToAnsi("Descontos Fixos Fornecedores")

PRIVATE cAlias     := "Z30"

PRIVATE aCores	   := {{ "Z30_ATIVO == 'S'"	, 'ENABLE'    },;
				       { "Z30_ATIVO != 'S'"	, 'DISABLE'   } }
				       
PUBLIC STRING_NULL := ""   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	mBrowse(6, 1, 22, 75, cAlias,,,,,,aCores)
	
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC11WIN   บAutor  ณRafael Parma       บ Data ณ  21/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de regras de descontos fixos para for- บฑฑ
ฑฑบ          ณnecedores, aplicada na inclusใo documento de entrada.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
*--------------------------------------------------------------*
User Function RJC11WIN( cAlias, nReg, nOpc, xVar, nOper )       
*--------------------------------------------------------------*

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}  
Local aRecZ31    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ31 := {}
Local aAlterEnch := {}
Local aCpoEnch   := {}
Local nRegE      := 0
Local nModelo    := 3
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T.
Local lNoFolder  := .F. 
Local lProperty  := .F. 
Local lDelete    :=  IIf ( nOpc == 5 , .T., .F.)
Local bCampo     := {|nCPO| Field(nCPO)}
Local aPages     := {}
Local nOpcNewGd  := IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cCHAVE     := Z30->Z30_NUMERO
Local cAliasZ30  := "Z30"
Local cSeekZ31   := STRING_NULL
Local cEntidZ31  := "Z31"
Local cItemZ31   := "Z31_ITEM"
Local lGravou    := .F.
Local lTravas    := .T.
Local nPosItem   := 0
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
Local oDlgEmp    

PRIVATE aColsZ31  := {}
PRIVATE aHeadZ31  := {}


DEFAULT nOper    := 1  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ30)
	RegToMemory(cAliasZ30, .T., .T., .T.)                                          
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
		For i := 1 TO FCount()
			M->&(Eval(bCampo, i)) := FieldGet(i)
		Next i                  
	EndIf
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ30)
	While !Eof().and.(x3_arquivo==cAliasZ30)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
	  		If nOpc != 5
		   		If ALLTRIM(x3_campo) == "Z30_NUMERO"
		      		If nOpc != 4
		      			AADD(aAlterEnch,x3_campo)
		      		EndIf
		     	Else
		     		AADD(aAlterEnch,x3_campo)
		     	EndIf
		  	EndIf		   
		Endif
		dbSkip()
	End                     
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ31 - TABELA Z31                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ31)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ31 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z31_FILIAL|Z31_NUMERO" )
			nUsado++
			
			aAdd(aHeadZ31,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsNwTMP, SX3->X3_CAMPO)
			If ( AllTrim(SX3->X3_CAMPO)== cItemZ31 )
				nPosItem := nUsado
			Endif			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z31                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
		
		dbSelectArea(cEntidZ31)
		dbSetOrder(3)
	 	(cEntidZ31)->(dbGoTop())
	    
		cSeekZ31 := xFilial( cEntidZ31 ) + cCHAVE
	
		If (cEntidZ31)->( MsSeek( cSeekZ31 ) )
			While ( !Eof() .And. cSeekZ31 == Z31->Z31_FILIAL + Z31->Z31_NUMERO )
	
				If ( SoftLock(cEntidZ31 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ31,Array(nUsado+1))
					AAdd(aRecZ31, (cEntidZ31)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ31[nCntFor][10] != "V" )
							aColsZ31[Len(aColsZ31)][nCntFor] := Z31->(FieldGet(FieldPos(aHeadZ31[nCntFor][2])))
						Else
							aColsZ31[Len(aColsZ31)][nCntFor] := CriaVar(aHeadZ31[nCntFor,2])
						EndIf
					Next
					aColsZ31[Len(aColsZ31)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ31)->( dbSkip()   )
			EndDo
		EndIf
		RollBackSX8()
	
	EndIf
	
	If Empty( aColsZ31 )
		AAdd(aColsZ31,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ31[1,nCntFor] := CriaVar(aHeadZ31[nCntFor,2], .F. )
		Next nCntFor
		aColsZ31[1][nUsado+1] := .F.
		aColsZ31[1][nPosItem] := StrZero(1,TamSx3(cItemZ31)[1])
	EndIf
	
	aFldsNwZ31 := aFldsNwTMP

	If ( lTravas )

		AAdd( aObjects, { 080, 080, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ30,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Regras de Descontos"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ31 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJC11LCP()", "AllwaysTrue()", "+" + cItemZ31, , 000, 999,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ31 ,aColsZ31 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ31:TudoOk().AND.U_RJC11TOK(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJCP11GRV( oGetZ31, aCpoEnch, lDelete )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
			
		Else
			RollBackSX8()
		EndIf  
		
	EndIf
	
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou) 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUFP01GRV บAutor  ณRafael Parma       บ Data ณ  21/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para gravar os dados.                       ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------------------------------*
Static Function RJCP11GRV( oGetZ31, aCpoEnch, lDel )
*-----------------------------------------------------------------*

Local cEntZ30   := "Z30"
Local cEntZ31   := "Z31"
Local lGravou   := .F.
Local lExist    := .F.
Local nLoop     := 0
Local nLoop2    := 0
Private aCols   := oGetZ31:aCols
Private aHeader := oGetZ31:aHeader
Private nPField := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_ITEM"})

	Begin Transaction

		If lDel 
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Exclusใo dos dados                                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
			dbSelectArea(cEntZ30)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial(cEntZ30)+M->Z30_NUMERO)
				
				If RecLock(cEntZ30, .F.)
					(cEntZ30)->(dbDelete())
					(cEntZ30)->(MsUnLock())
				EndIf				   

				dbSelectArea(cEntZ31)
				dbSetOrder(3)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO )
					While !EOF() .and. Z31->Z31_FILIAL + Z31->Z31_NUMERO == xFilial(cEntZ31) + M->Z30_NUMERO
						If RecLock(cEntZ31, .F.)
							(cEntZ31)->(dbDelete())
							(cEntZ31)->(MsUnLock())						
						EndIf
						dbSkip()
					Enddo				
				EndIf				
			
			EndIf				
		
		Else
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados do cabecalho                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			dbSelectArea(cEntZ30)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial(cEntZ30) + M->Z30_NUMERO )
				lExist := .T.
			EndIf	
			
			If Len(aCpoEnch) > 0
				If RecLock(cEntZ30,!lExist)
					Z30->Z30_FILIAL := xFilial(cEntZ30)
					For nI := 1 to Len(aCpoEnch)
						&("Z30->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
					Next nI
					Z30->(MsUnLock())
				EndIf		
			EndIf
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados de campos Z31                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			If Len(aCols) > 0               

				For nLoop := 1 To Len( aCols )
				
					lGravou := .T.
					If GDDeleted( nLoop )
						If nLoop <= Len( aCols )
							dbSelectArea(cEntZ31)
							dbSetOrder(3)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO + aCols[nLoop,nPField] )	
								If RecLock( cEntZ31, .F. )
									(cEntZ31)->( dbDelete() )
									(cEntZ31)->( MsUnlock() ) 		
								EndIf
							EndIf
						EndIf
					Else
						If nLoop <= Len( aCols )
			
							dbSelectArea(cEntZ31)
							dbSetOrder(3)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ31) + M->Z30_NUMERO + aCols[nLoop,nPField] )
								RecLock( cEntZ31, .F. )
							Else			
								RecLock( cEntZ31, .T. ) 		
								Z31->Z31_FILIAL := xFilial( cEntZ31 )
								Z31->Z31_NUMERO := M->Z30_NUMERO
							EndIf
				
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Grava os demais campos                                                 ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
							For nLoop2 := 1 To Len( aHeader )
								If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z31_FILIAL|Z31_NUMERO" )
									Z31->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
								EndIf
							Next nLoop2				
							(cEntZ31)->(MsUnlock()) 						
						EndIf
					EndIf
					
				Next nLoop
				
			EndIf


		EndIf
	
	End Transaction		


Return( lGravou )  

                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC11LCP     บAutor  ณRafael Parma     บ Data ณ  21/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da MsGetDados.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function RJC11LCP()
*------------------------------*  
Local lRet := .T.
Local nPGRP := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_CODGRP"})
Local nPPRD := aScan(aHeader,{|x| AllTrim(x[2])=="Z31_CODPRD"})

Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If ! aCols[n][Len(aCols[n])]
			If !Empty(aCols[n,nPPRD]) .and. !Empty(aCols[n,nPGRP])
		   		MsgAlert("Deverแ ser informado apenas o c๓digo do grupo de produtos ou o c๓digo do produto!")
		   		lRet := .F.
				Exit
			EndIf
			If 	( !Empty(aCols[nI,nPPRD]) .and. !Empty(aCols[n,nPPRD]) .and. aCols[nI,nPPRD] == aCols[n,nPPRD] .and. n != nI ) .or. ;
				( !Empty(aCols[nI,nPGRP]) .and. !Empty(aCols[n,nPGRP]) .and. aCols[nI,nPGRP] == aCols[n,nPGRP] .and. n != nI )
		   		MsgAlert("C๓digo do grupo de produtos ou c๓digo do produto jแ informado!")
		   		lRet := .F.
				Exit
			EndIf			
		EndIf
	Next nI	

Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC11TOK     บAutor  ณRafael Parma     บ Data ณ  21/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao do browse.                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function RJC11TOK()
*------------------------------*  
Local aArea := GetArea()
Local lRet := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida o preenchimento dos campos do c๓digo do fornecedor              ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	If Empty(M->Z30_FORNEC)
		MsgAlert("Deverแ ser informado o c๓digo do fornecedor!")
		lRet := .F.
	EndIf                                
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo sobre a regra ativa, jแ existente com as mesmas caracterํsticas   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lRet .and. M->Z30_ATIVO == "S"
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Define parโmetro de busca                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
 		lAtivo := .F.
		dbSelectArea("Z30")
		dbSetOrder(2)	//Z30_FILIAL+Z30_FORNEC+Z30_LOJFOR
	 	dbGoTop()
	 	If dbSeek ( xFilial("Z30") + M->Z30_FORNEC )
	 		While !Z30->(EOF()) .and. Z30->Z30_FILIAL == xFilial("Z30") .and. Z30->Z30_FORNEC == M->Z30_FORNEC
	 			
	 			If !Empty(M->Z30_LOJFOR) .and. Z30->Z30_LOJFOR != M->Z30_LOJFOR
	 				Z30->(dbSkip())
	 				Loop
	 			EndIf
	 			
	 			If Z30->Z30_NUMERO != M->Z30_NUMERO
		 			If Z30->Z30_ATIVO == "S"
		 				lAtivo := .T.
		 				Exit
		 			EndIf
		 		EndIf
 				Z30->(dbSkip())             
 				
 			Enddo       
 		EndIf
 		
	 	If lAtivo
	 		MsgAlert("Jแ existe um contrato ativo para este fornecedor!")
	 		lRet := .F.
	 	EndIf	 		 		
 			 	
	EndIf
	

	RestArea(aArea)	                               
	
Return (lRet)
