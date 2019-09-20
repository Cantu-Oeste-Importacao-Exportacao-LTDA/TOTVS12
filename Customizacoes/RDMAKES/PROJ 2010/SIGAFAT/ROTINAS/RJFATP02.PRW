#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFATP02   บAutor  ณRafael Parma       บ Data ณ  18/10/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de regras de descontos de comiss๕es.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJFATP02()
*-------------------------*

PRIVATE aRotina := { { OemToAnsi("Pesquisar")  		,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar") 		,"U_RJF02WIN" , 0 , 2} ,;
					 { OemToAnsi("Incluir")    		,"U_RJF02WIN" , 0 , 3} ,;
					 { OemToAnsi("Alterar")    		,"U_RJF02WIN" , 0 , 4} ,;
					 { OemToAnsi("Excluir")    		,"U_RJF02WIN" , 0 , 5} ,;
					 { OemToAnsi("Copiar p/ Vend"),"U_Z14PVend" , 0 , 6} ,;
					 { OemToAnsi("Copiar p/ Filial"),"U_Z14PFili", 0,  6}}
					 
PRIVATE cCadastro  := OemToAnsi("Descontos de comiss๕es")
PRIVATE cAlias     := "Z14"

PRIVATE aCores	   := {{ "Z14_ATIVO == 'S'"	, 'ENABLE'    },;
				       { "Z14_ATIVO != 'S'"	, 'DISABLE'   } }
				       
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
ฑฑบPrograma  ณRJF02WIN   บAutor  ณRafael Parma       บ Data ณ  18/10/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de regras de descontos de comiss๕es.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
*--------------------------------------------------------------*
User Function RJF02WIN( cAlias, nReg, nOpc, xVar, nOper )       
*--------------------------------------------------------------*

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}  
Local aRecZ15    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ15 := {}
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
Local cCHAVE     := Z14->Z14_CODIGO
Local cAliasZ14  := "Z14"
Local cSeekZ15   := STRING_NULL
Local cEntidZ15  := "Z15"
Local cItemZ15   := "Z15_ITEM"
Local lGravou    := .F.
Local lTravas    := .T.
Local nPosItem   := 0
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
Local oDlgEmp    

PRIVATE aColsZ15  := {}
PRIVATE aHeadZ15  := {}


DEFAULT nOper    := 1  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ14)
	RegToMemory(cAliasZ14, .T., .T., .T.)                                          
	
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
	dbSeek(cAliasZ14)
	While !Eof().and.(x3_arquivo==cAliasZ14)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
	  		If nOpc != 5
		   		If ALLTRIM(x3_campo) == "Z14_CODIGO"
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
	//ณMontagem do aHeadZ15 - TABELA Z15                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ15)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ15 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z15_FILIAL|Z15_CODIGO" )
			nUsado++
			
			aAdd(aHeadZ15,{AllTrim(X3Titulo()),;
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
			If ( AllTrim(SX3->X3_CAMPO)== cItemZ15 )
				nPosItem := nUsado
			Endif			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z15                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
		
		dbSelectArea(cEntidZ15)
		dbSetOrder(1)
	 	(cEntidZ15)->(dbGoTop())
	    
		cSeekZ15 := xFilial( cEntidZ15 ) + cCHAVE
	
		If (cEntidZ15)->( MsSeek( cSeekZ15 ) )
			While ( !Eof() .And. cSeekZ15 == Z15->Z15_FILIAL + Z15->Z15_CODIGO )
	
				If ( SoftLock(cEntidZ15 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ15,Array(nUsado+1))
					AAdd(aRecZ15, (cEntidZ15)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ15[nCntFor][10] != "V" )
							aColsZ15[Len(aColsZ15)][nCntFor] := Z15->(FieldGet(FieldPos(aHeadZ15[nCntFor][2])))
						Else
							aColsZ15[Len(aColsZ15)][nCntFor] := CriaVar(aHeadZ15[nCntFor,2])
						EndIf
					Next
					aColsZ15[Len(aColsZ15)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ15)->( dbSkip()   )
			EndDo
		EndIf
		RollBackSX8()
	
	EndIf
	
	If Empty( aColsZ15 )
		AAdd(aColsZ15,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ15[1,nCntFor] := CriaVar(aHeadZ15[nCntFor,2], .F. )
		Next nCntFor
		aColsZ15[1][nUsado+1] := .F.
		aColsZ15[1][nPosItem] := StrZero(1,TamSx3(cItemZ15)[1])
	EndIf
	
	aFldsNwZ15 := aFldsNwTMP

	If ( lTravas )

		AAdd( aObjects, { 080, 080, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ14,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Faixas de comiss๕es"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ15 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJFP2LCP()", "AllwaysTrue()", "+" + cItemZ15, , 000, 99,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ15 ,aColsZ15 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ15:TudoOk().AND.U_RJFP2TOK(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJUFP02GRV( oGetZ15, aCpoEnch, lDelete )
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
ฑฑบPrograma  ณRJUFP01GRV บAutor  ณRafael Parma       บ Data ณ  18/10/2010 บฑฑ
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
Static Function RJUFP02GRV( oGetZ15, aCpoEnch, lDel )
*-----------------------------------------------------------------*

Local cEntZ14   := "Z14"
Local cEntZ15   := "Z15"
Local lGravou   := .F.
Local lExist    := .F.
Local nLoop     := 0
Local nLoop2    := 0
Private aCols   := oGetZ15:aCols
Private aHeader := oGetZ15:aHeader
Private nPField := aScan(aHeader,{|x| AllTrim(x[2])=="Z15_ITEM"})

	Begin Transaction

		If lDel 
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Exclusใo dos dados                                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
			dbSelectArea(cEntZ14)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial(cEntZ14)+M->Z14_CODIGO)
				
				If RecLock(cEntZ14, .F.)
					(cEntZ14)->(dbDelete())
					(cEntZ14)->(MsUnLock())
				EndIf				   

				dbSelectArea(cEntZ15)
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ15) + M->Z14_CODIGO )
					While !EOF() .and. Z15->Z15_FILIAL + Z15->Z15_CODIGO == xFilial(cEntZ15) + M->Z14_CODIGO
						If RecLock(cEntZ15, .F.)
							(cEntZ15)->(dbDelete())
							(cEntZ15)->(MsUnLock())						
						EndIf
						dbSkip()
					Enddo				
				EndIf				
			
			EndIf				
		
		Else
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados do cabecalho                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			dbSelectArea(cEntZ14)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial(cEntZ14) + M->Z14_CODIGO )
				lExist := .T.
			EndIf	
			
			If Len(aCpoEnch) > 0
				If RecLock(cEntZ14,!lExist)
					Z14->Z14_FILIAL := xFilial(cEntZ14)
					For nI := 1 to Len(aCpoEnch)
						&("Z14->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
					Next nI
					Z14->(MsUnLock())
				EndIf		
			EndIf
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados de campos Z15                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			If Len(aCols) > 0               

				For nLoop := 1 To Len( aCols )
				
					lGravou := .T.
					If GDDeleted( nLoop )
						If nLoop <= Len( aCols )
							dbSelectArea(cEntZ15)
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ15) + M->Z14_CODIGO + aCols[nLoop,nPField] )	
								If RecLock( cEntZ15, .F. )
									(cEntZ15)->( dbDelete() )
									(cEntZ15)->( MsUnlock() ) 		
								EndIf
							EndIf
						EndIf
					Else
						If nLoop <= Len( aCols )
			
							dbSelectArea(cEntZ15)
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( xFilial(cEntZ15) + M->Z14_CODIGO + aCols[nLoop,nPField] )
								RecLock( cEntZ15, .F. )
							Else			
								RecLock( cEntZ15, .T. ) 		
								Z15->Z15_FILIAL := xFilial( cEntZ15 )
								Z15->Z15_CODIGO := M->Z14_CODIGO
							EndIf
				
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Grava os demais campos                                                 ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
							For nLoop2 := 1 To Len( aHeader )
								If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z15_FILIAL|Z15_CODIGO" )
									Z15->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
								EndIf
							Next nLoop2				
							(cEntZ15)->(MsUnlock()) 						
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
ฑฑบPrograma  ณRJCP6LCR     บAutor  ณRafael Parma     บ Data ณ  18/10/2010 บฑฑ
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
User Function RJFP2LCP()
*------------------------------*  
Local lRet := .T.
Local nPGRP := aScan(aHeader,{|x| AllTrim(x[2])=="Z15_CODGRP"})
Local nPPRD := aScan(aHeader,{|x| AllTrim(x[2])=="Z15_CODPRD"})

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
		EndIf		
	Next nI	

Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCP6TOK     บAutor  ณRafael Parma     บ Data ณ  18/10/2010 บฑฑ
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
User Function RJFP2TOK()
*------------------------------*  
Local aArea := GetArea()
Local lRet := .T.
Local lAtivo    := .F.
Local lGerente  := .F.
Local lSupervis := .F.
Local lVendedor := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida o preenchimento dos campos do vendedor, supervisor e gerente    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	If	( !Empty(M->Z14_CODVEN) .and. ( !Empty(M->Z14_CODSUP) .or. !Empty(M->Z14_CODGER) )) .or. ;
		( !Empty(M->Z14_CODSUP) .and. ( !Empty(M->Z14_CODVEN) .or. !Empty(M->Z14_CODGER) )) .or. ;
		( !Empty(M->Z14_CODGER) .and. ( !Empty(M->Z14_CODVEN) .or. !Empty(M->Z14_CODSUP) ))
		MsgAlert("Deverแ ser informado apenas o c๓digo do vendedor ou supervisor ou gerente!")
		lRet := .F.
	EndIf

	If Empty(M->Z14_CODVEN) .and. Empty(M->Z14_CODSUP) .and. Empty(M->Z14_CODGER)
		MsgAlert("Deverแ ser informado o c๓digo do vendedor ou supervisor ou gerente!")
		lRet := .F.
	EndIf                                
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Valida็ใo sobre contrato ativo jแ existente com as mesmas caracterํsticas   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lRet .and. M->Z14_ATIVO == "S"
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Define parโmetro de busca                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		If !Empty(M->Z14_CODVEN) 
			lVendedor := .T.
		ElseIf !Empty(M->Z14_CODSUP)
			lSupervis := .T.
		Else
			lGerente := .T.
		EndIf

		If lVendedor
			dbSelectArea("Z14")
			dbSetOrder(2)	//Z14_FILIAL+Z14_CODVEN
		 	dbGoTop()
		 	If dbSeek ( xFilial("Z14") + M->Z14_CODVEN )
		 		While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODVEN == M->Z14_CODVEN
		 			If Z14->Z14_CODIGO != M->Z14_CODIGO
			 			If Z14->Z14_ATIVO == "S"
			 				lAtivo := .T.
			 				Exit
			 			EndIf
			 		EndIf
	 				Z14->(dbSkip())
	 			Enddo
	 		EndIf
	 		
		 	If lAtivo
		 		MsgAlert("Jแ existe um contrato ATIVO para este vendedor!")
		 		lRet := .F.
		 	EndIf	 		 		
	 		
	 		
	 	ElseIf lSupervis
			dbSelectArea("Z14")
			dbSetOrder(3)	//Z14_FILIAL+Z14_CODSUP
		 	dbGoTop()
		 	If dbSeek ( xFilial("Z14") + M->Z14_CODSUP )
		 		While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODSUP == M->Z14_CODSUP
		 			If Z14->Z14_CODIGO != M->Z14_CODIGO
			 			If Z14->Z14_ATIVO == "S"
			 				lAtivo := .T.
			 				Exit
			 			EndIf
			 		EndIf
	 				Z14->(dbSkip())
	 			Enddo       
	 		EndIf
	 		
		 	If lAtivo
		 		MsgAlert("Jแ existe um contrato ATIVO para este supervisor!")
		 		lRet := .F.
		 	EndIf	 		 		
	 			 	
	 	Else
			dbSelectArea("Z14")
			dbSetOrder(4)	//Z14_FILIAL+Z14_CODGER
		 	dbGoTop()
		 	If dbSeek ( xFilial("Z14") + M->Z14_CODGER )
		 		While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODGER == M->Z14_CODGER
		 			If Z14->Z14_CODIGO != M->Z14_CODIGO
			 			If Z14->Z14_ATIVO == "S"
			 				lAtivo := .T.
			 				Exit
			 			EndIf
			 		EndIf
	 				Z14->(dbSkip())
	 			Enddo	 		 	
	 		EndIf

		 	If lAtivo
		 		MsgAlert("Jแ existe um contrato ATIVO para este gerente!")
		 		lRet := .F.
		 	EndIf	 	
	 	
	 	EndIf
	EndIf
	

	RestArea(aArea)	                               
	
Return (lRet)


// Faz a c๓pia para o vendedor
User Function Z14PVend()
Local nPosZ14 := Z14->(RecNo())
Local aArea := GetArea()
Local cCodigo := Z14->Z14_CODIGO
local oDlg
Local oVend
Local cVendDesc
Local cVendNew := Z14->Z14_CODVEN
Local lCont := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + Z14->Z14_CODVEN))

cVendDesc := Z14->Z14_CODVEN + " - " + SA3->A3_NREDUZ

DEFINE MSDIALOG oDlg TITLE "Informe o novo vendedor" FROM 0, 0  TO 140, 350 COLORS 0, 16777215 PIXEL
@  20,  05 Say "Vendedor Atual: " + cVendDesc of oDlg COLORS 0, 16777215 PIXEL
@  35,  05 Say "Vendedor Novo: " of oDlg COLORS 0, 16777215 PIXEL
@  35,  60 MsGet oVend VAR cVendNew Size 50, 10 VALID !Empty(cVendNew) F3 "SA3" of oDlg COLORS 0, 16777215 PIXEL
Activate Dialog oDlg Centered ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })

if Empty(cVendNew) .OR. (cVendNew == Z14->Z14_CODVEN)
	MsgInfo("Vendedor em branco ou nใo selecionado!")
	Return
EndIf

if !lCont 
	Return
EndIf

dDatIni := Z14->Z14_DATINI
dDatFin := Z14->Z14_DATFIN

BeginSql Alias "Z15TMP"
	SELECT Z15.* FROM %TABLE:Z15% Z15 
	WHERE %NOTDEL%
		AND Z15_FILIAL = %EXP:Z14->Z14_FILIAL%
		AND Z15_CODIGO = %EXP:Z14->Z14_CODIGO%
	ORDER BY Z15_ITEM
EndSql

dbSelectArea("Z14")

cCodNew := GetSxeNum("Z14", "Z14_CODIGO")

RecLock("Z14", .T.)
Z14->Z14_FILIAL := xFilial("Z14")
Z14->Z14_CODIGO := cCodNew
Z14->Z14_ATIVO := "S"
Z14->Z14_CODVEN := cVendNew
Z14->Z14_NOMVEN := Posicione("SA3", 01, xFilial("SA3") + cVendNew, "A3_NREDUZ")
// Z14->Z14_CODSUP := 
Z14->Z14_DATINI := dDatIni
Z14->Z14_DATFIN := dDatFin
Z14->(MsUnlock())
ConfirmSx8()

cSeq := "001"

While Z15TMP->(!Eof())
	RecLock("Z15", .T.)
	Z15->Z15_FILIAL := xFilial("Z15")
	Z15->Z15_CODIGO := cCodNew
	Z15->Z15_ITEM := cSeq
	Z15->Z15_CODGRP := Z15TMP->Z15_CODGRP
	Z15->Z15_DESGRP := Z15TMP->Z15_DESGRP
	Z15->Z15_CODPRD := Z15TMP->Z15_CODPRD
	Z15->Z15_DESPRD := Z15TMP->Z15_DESPRD
	Z15->Z15_PRCINI := Z15TMP->Z15_PRCINI
	Z15->Z15_PRCFIN := Z15TMP->Z15_PRCFIN
	Z15->Z15_PRCDES := Z15TMP->Z15_PRCDES

	Z15->(MsUnlock())
	
	cSeq := Soma1(cSeq)
	
	Z15TMP->(dbSkip())
EndDo

Z15TMP->(dbCloseArea())

RestArea(aArea)
Return


// Copia para outras filiais /empresas
User Function Z14PFili()
Local nPosZ14 := Z14->(RecNo())
Local aArea := GetArea()
Local cCodigo := Z14->Z14_CODIGO
Local cVend := Z14->Z14_CODVEN
local oDlg
Local oFilNew
Local cFilNew := xFilial("Z14")
Local lCont := .F.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg TITLE "Informe a Nova Filial" FROM 0, 0  TO 140, 350 COLORS 0, 16777215 PIXEL
@  20,  05 Say "Filial Atual: " + Z14->Z14_FILIAL of oDlg COLORS 0, 16777215 PIXEL
@  35,  05 Say "Filial Nova: " of oDlg COLORS 0, 16777215 PIXEL
@  35,  60 MsGet oFilNew VAR cFilNew Size 50, 10 VALID !Empty(cFilNew) of oDlg COLORS 0, 16777215 PIXEL
Activate Dialog oDlg Centered ON INIT ; // CENTER
EnchoiceBar(oDlg,{|| lCont := .T.,oDlg:End() }, {|| oDlg:End() })

if Empty(cFilNew) .OR. (cFilNew == Z14->Z14_FILIAL)
	MsgInfo("Filial em branco ou jแ existente!")
	Return
EndIf

if !lCont 
	Return
EndIf

dDatIni := Z14->Z14_DATINI
dDatFin := Z14->Z14_DATFIN

BeginSql Alias "Z15TMP"
	SELECT Z15.* FROM %TABLE:Z15% Z15 
	WHERE %NOTDEL%
		AND Z15_FILIAL = %EXP:Z14->Z14_FILIAL%
		AND Z15_CODIGO = %EXP:Z14->Z14_CODIGO%
	ORDER BY Z15_ITEM
EndSql

dbSelectArea("Z14")

cSqlNextCod := "SELECT MAX(Z14_CODIGO) AS SEQ FROM " + RetSqlName("Z14") + " Z14 WHERE D_E_L_E_T_ <> '*' AND Z14_FILIAL = '" + cFilNew + "'"

TcQuery cSqlNextCod NEW ALIAS "Z14SEQ"

if Z14SEQ->(!Eof())
	cCodNew := Soma1(PadL(Z14SEQ->SEQ, 9, "0"))
else
	cCodNew := "000000001"
EndIf

dbCloseArea("Z14SEQ")

RecLock("Z14", .T.)
Z14->Z14_FILIAL := cFilNew
Z14->Z14_CODIGO := cCodNew
Z14->Z14_ATIVO := "S"
Z14->Z14_CODVEN := cVend
Z14->Z14_NOMVEN := Posicione("SA3", 01, xFilial("SA3") + cVend, "A3_NREDUZ")
// Z14->Z14_CODSUP := 
Z14->Z14_DATINI := dDatIni
Z14->Z14_DATFIN := dDatFin
Z14->(MsUnlock())

cSeq := "001"

While Z15TMP->(!Eof())
	RecLock("Z15", .T.)
	Z15->Z15_FILIAL := cFilNew
	Z15->Z15_CODIGO := cCodNew
	Z15->Z15_ITEM := cSeq
	Z15->Z15_CODGRP := Z15TMP->Z15_CODGRP
	Z15->Z15_DESGRP := Z15TMP->Z15_DESGRP
	Z15->Z15_CODPRD := Z15TMP->Z15_CODPRD
	Z15->Z15_DESPRD := Z15TMP->Z15_DESPRD
	Z15->Z15_PRCINI := Z15TMP->Z15_PRCINI
	Z15->Z15_PRCFIN := Z15TMP->Z15_PRCFIN
	Z15->Z15_PRCDES := Z15TMP->Z15_PRCDES

	Z15->(MsUnlock())
	
	cSeq := Soma1(cSeq)
	
	Z15TMP->(dbSkip())
EndDo

Z15TMP->(dbCloseArea())

RestArea(aArea)
Return