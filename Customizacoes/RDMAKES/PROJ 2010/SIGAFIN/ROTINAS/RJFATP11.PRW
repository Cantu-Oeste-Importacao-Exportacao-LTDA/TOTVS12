#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFATP11  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  24/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de centro de distribui็ใo Vertico.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJFATP11()
*---------------------------------------------------------------------------*

PRIVATE cAlias 		:= "Z60"
PRIVATE cCadastro	:= OemToAnsi("Centro de Distribui็ใo Vertico")   
PRIVATE STRING_NULL := ""
PRIVATE aRotina := { { OemToAnsi("Pesquisar")  		,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar") 		,"U_RJF11WIN" , 0 , 2} ,;
					 { OemToAnsi("Incluir")    		,"U_RJF11WIN" , 0 , 3} ,;
					 { OemToAnsi("Alterar")    		,"U_RJF11WIN" , 0 , 4} ,;
					 { OemToAnsi("Excluir")    		,"U_RJF11WIN" , 0 , 5} }  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
					 					 
					 					 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	mBrowse(6,1,22,75,cAlias)
	
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF11WIN  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de centro de distribui็ใo Vertico.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF11WIN( cAlias, nReg, nOpc, xVar, nOper )       
*---------------------------------------------------------------------------*

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}  
Local aRecZ61    := {}
Local aRecZ62    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ61 := {}
Local aFldsNwZ62 := {}
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
Local cCHAVE     := Z60->Z60_CODCD
Local cAliasZ60  := "Z60"
Local cSeekZ61   := STRING_NULL
Local cEntidZ61  := "Z61"
Local cSeekZ62   := STRING_NULL
Local cEntidZ62  := "Z62"
Local lGravou    := .F.
Local lTravas    := .T.
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
PRIVATE oDlgEmp

PRIVATE aColsZ61  := {}
PRIVATE aColsZ61E := {}
PRIVATE aHeadZ61  := {}
PRIVATE oGetZ61 

PRIVATE aColsZ62  := {}
PRIVATE aColsZ62E := {}
PRIVATE aHeadZ62  := {}
PRIVATE oGetZ62

DEFAULT nOper    := 1  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoice         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ60)
	RegToMemory(cAliasZ60, .T., .T., .T.)                                          
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
		For i := 1 TO FCount()
			M->&(Eval(bCampo, i)) := FieldGet(i)
		Next i                  
	EndIf
	
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ60)
	While !Eof().and.(x3_arquivo==cAliasZ60)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
	  		If nOpc != 5
		   		If nOpc == 4
			   		If !ALLTRIM(x3_campo) $ "Z60_CODCD/Z60_CODEM/Z60_CODFL/Z60_AB2B"
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
	//ณMontagem do aHeadZ61 - TABELA Z61                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aFldsNwTMP := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ61)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ61 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z61_CODCD" )
			nUsado++
			aAdd(aHeadZ61,{AllTrim(X3Titulo()),;
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
		EndIf
		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z61                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
	
		dbSelectArea(cEntidZ61)
		dbSetOrder(1)
	 	(cEntidZ61)->(dbGoTop())
	    
		cSeekZ61 := xFilial( cEntidZ61 ) + cCHAVE
	
		If (cEntidZ61)->( MsSeek( cSeekZ61 ) )
			While ( !Eof() .And. cSeekZ61 == Z61->Z61_FILIAL + Z61->Z61_CODCD )
	
				If ( SoftLock(cEntidZ61 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ61,Array(nUsado+1))
					AAdd(aRecZ61, (cEntidZ61)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ61[nCntFor][10] != "V" )
							aColsZ61[Len(aColsZ61)][nCntFor] := Z61->(FieldGet(FieldPos(aHeadZ61[nCntFor][2])))
						Else
							aColsZ61[Len(aColsZ61)][nCntFor] := CriaVar(aHeadZ61[nCntFor,2])
						EndIf
					Next
					aColsZ61[Len(aColsZ61)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ61)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ61 )
		AAdd(aColsZ61,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ61[1,nCntFor] := CriaVar(aHeadZ61[nCntFor,2], .F. )
		Next nCntFor
		aColsZ61[1][nUsado+1] := .F.
	EndIf
	
	If Empty( aColsZ61E )
		AAdd(aColsZ61E,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ61E[1,nCntFor] := CriaVar(aHeadZ61[nCntFor,2], .F. )
		Next nCntFor
		aColsZ61E[1][nUsado+1] := .F.
	EndIf
	
	aFldsNwZ61 := aFldsNwTMP


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ62 - TABELA Z62                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aFldsNwTMP := {}  
	nUsado := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ62)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ62 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z62_CODCD" )
			nUsado++
			aAdd(aHeadZ62,{AllTrim(X3Titulo()),;
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
		EndIf
		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z62                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
	
		dbSelectArea(cEntidZ62)
		dbSetOrder(1)
	 	(cEntidZ62)->(dbGoTop())
	    
		cSeekZ62 := xFilial( cEntidZ62 ) + cCHAVE
	
		If (cEntidZ62)->( MsSeek( cSeekZ62 ) )
			While ( !Eof() .And. cSeekZ62 == Z62->Z62_FILIAL + Z62->Z62_CODCD )
	
				If ( SoftLock(cEntidZ62 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ62,Array(nUsado+1))
					AAdd(aRecZ62, (cEntidZ62)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ62[nCntFor][10] != "V" )
							aColsZ62[Len(aColsZ62)][nCntFor] := Z62->(FieldGet(FieldPos(aHeadZ62[nCntFor][2])))
						Else
							aColsZ62[Len(aColsZ62)][nCntFor] := CriaVar(aHeadZ62[nCntFor,2])
						EndIf
					Next
					aColsZ62[Len(aColsZ62)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ62)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ62 )
		AAdd(aColsZ62,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ62[1,nCntFor] := CriaVar(aHeadZ62[nCntFor,2], .F. )
		Next nCntFor
		aColsZ62[1][nUsado+1] := .F.
	EndIf
	
	If Empty( aColsZ62E )
		AAdd(aColsZ62E,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ62E[1,nCntFor] := CriaVar(aHeadZ62[nCntFor,2], .F. )
		Next nCntFor
		aColsZ62E[1][nUsado+1] := .F.
	EndIf
	
	aFldsNwZ62 := aFldsNwTMP
              

	If ( lTravas )

		AAdd( aObjects, { 070, 070, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ60,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,STRING_NULL,oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Estados","Transportadores"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ61 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJF11VUF()", "AllwaysTrue()", , , 000, 99,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ61 ,aColsZ61 )
		oGetZ62 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJF11VTR()", "AllwaysTrue()", , , 000, 99,, STRING_NULL, .T., oFolder:aDialogs[2], aHeadZ62 ,aColsZ62 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ61:TudoOk().and.oGetZ62:TudoOk().and.U_RF11VTOK(nOpc),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJUFP11GRV( oGetZ61, oGetZ62, aCpoEnch, lDelete )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
			
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
ฑฑบPrograma  ณRJUFP11GRVบAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para gravar os dados.                       ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function RJUFP11GRV( oGetZ61, oGetZ62, aCpoEnch, lDel )
*---------------------------------------------------------------------------*

Local cEntZ60   := "Z60"
Local cEntZ61   := "Z61"
Local cEntZ62   := "Z62"
Local lGravou   := .F.
Local lExist    := .F.
Local nLoop     := 0
Local nLoop2    := 0
Private aCols1  := oGetZ61:aCols
Private aHeader1:= oGetZ61:aHeader
Private aCols2  := oGetZ62:aCols
Private aHeader2:= oGetZ62:aHeader
Private nCODUF  := aScan(aHeader1,{|x| AllTrim(x[2])=="Z61_CODUF"})
Private nCODFR  := aScan(aHeader2,{|x| AllTrim(x[2])=="Z62_CODFR"})
Private nLOJFR  := aScan(aHeader2,{|x| AllTrim(x[2])=="Z62_LOJFR"})

	Begin Transaction

		If lDel 
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Exclusใo dos dados                                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
			dbSelectArea(cEntZ60)
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial(cEntZ60) + M->Z60_CODCD )
				If RecLock(cEntZ60,.F.)
					(cEntZ60)->(dbDelete())
					(cEntZ60)->(MsUnLock())
				EndIf
				//--Exclusใo UF
				dbSelectArea(cEntZ61)
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ61) + M->Z60_CODCD )
					While !EOF() .and. Z61->(Z61_FILIAL+Z61_CODCD) == xFilial(cEntZ61) + M->Z60_CODCD
						If RecLock(cEntZ61,.F.)
							(cEntZ61)->(dbDelete())
							(cEntZ61)->(MsUnLock())						
						EndIf
						(cEntZ61)->(dbSkip())
					Enddo				
				EndIf              
				//--Exclusใo Transportadores
				dbSelectArea(cEntZ62)
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ62) + M->Z60_CODCD )
					While !EOF() .and. Z62->(Z62_FILIAL+Z62_CODCD) == xFilial(cEntZ61) + M->Z60_CODCD
						If RecLock(cEntZ62,.F.)
							(cEntZ62)->(dbDelete())
							(cEntZ62)->(MsUnLock())						
						EndIf
						(cEntZ62)->(dbSkip())
					Enddo				
				EndIf              
			EndIf				
		
		Else
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados do cabecalho                                               ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
			
			dbSelectArea(cEntZ60)
			dbSetOrder(1)
			If dbSeek( xFilial(cEntZ60) + M->Z60_CODCD )
				lExist := .T.
			EndIf	
			
			If Len(aCpoEnch) > 0
				If RecLock(cEntZ60,!lExist)
					Z60->Z60_FILIAL := xFilial(cEntZ60)
					Z60->Z60_AB2B	:= "S"
					For nI := 1 to Len(aCpoEnch)
						&("Z60->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
					Next nI
					Z60->(MsUnLock())
				EndIf		
			EndIf
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados de campos Z61                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Len(aCols1) > 0               

				For nLoop := 1 To Len( aCols1 )
					lGravou := .T.
					If GDDeleted( nLoop, aHeader1, aCols1 )
						If nLoop <= Len( aCols1 )
							dbSelectArea(cEntZ61)
							dbSetOrder(1)	
							dbGoTop()
							If dbSeek ( xFilial(cEntZ61) + M->Z60_CODCD + aCols1[nLoop,nCODUF] )	
								RecLock( cEntZ61, .F. )
								(cEntZ61)->( dbDelete() )
								(cEntZ61)->( MsUnlock() ) 		
							EndIf
						EndIf
					Else
						If nLoop <= Len( aCols1 )
			
							dbSelectArea(cEntZ61)
							dbSetOrder(1)
							dbGoTop()
							If !dbSeek ( xFilial(cEntZ61) + M->Z60_CODCD + aCols1[nLoop,nCODUF] )
								RecLock( cEntZ61, .T. ) 		
								Z61->Z61_FILIAL := xFilial( cEntZ61 )
								Z61->Z61_CODCD  := M->Z60_CODCD
							Else
								RecLock( cEntZ61, .F. )
							EndIf
				
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Grava os demais campos                                                 ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
							For nLoop2 := 1 To Len( aHeader1 )
								If ( aHeader1[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader1[nLoop2,2] ) $ "Z61_FILIAL/Z61_CODCD" )
									Z61->(FieldPut(FieldPos(aHeader1[nLoop2,2]),aCols1[nLoop,nLoop2]))
								EndIf
							Next nLoop2				
							(cEntZ61)->(MsUnlock()) 						
						EndIf
					EndIf
				Next nLoop
			EndIf
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados de campos Z62                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Len(aCols2) > 0               

				For nLoop := 1 To Len( aCols2 )
					lGravou := .T.
					If GDDeleted( nLoop, aHeader2, aCols2 )
						If nLoop <= Len( aCols2 )
							dbSelectArea(cEntZ62)
							dbSetOrder(1)	
							dbGoTop()
							If dbSeek ( xFilial(cEntZ62) + M->Z60_CODCD + aCols2[nLoop,nCODFR] + aCols2[nLoop,nLOJFR] )	
								RecLock( cEntZ62, .F. )
								(cEntZ62)->( dbDelete() )
								(cEntZ62)->( MsUnlock() ) 
							EndIf
						EndIf
					Else
						If nLoop <= Len( aCols2 )

							dbSelectArea(cEntZ62)
							dbSetOrder(1)
							dbGoTop()
							If !dbSeek ( xFilial(cEntZ62) + M->Z60_CODCD + aCols2[nLoop,nCODFR] + aCols2[nLoop,nLOJFR] )
								RecLock( cEntZ62, .T. ) 		
								Z62->Z62_FILIAL := xFilial( cEntZ62 )
								Z62->Z62_CODCD  := M->Z60_CODCD
							Else
								RecLock( cEntZ62, .F. )
							EndIf

							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Grava os demais campos                                                 ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

							For nLoop2 := 1 To Len( aHeader2 )
								If ( aHeader2[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader2[nLoop2,2] ) $ "Z62_FILIAL/Z62_CODCD" )
									Z62->(FieldPut(FieldPos(aHeader2[nLoop2,2]),aCols2[nLoop,nLoop2]))
								EndIf
							Next nLoop2				
							(cEntZ62)->(MsUnlock()) 						
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
ฑฑบPrograma  ณRJF11LCP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo da MsGetDados - campos.                            ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*---------------------------------------------------------------------------*
User Function RJF11VUF()
*---------------------------------------------------------------------------*
Local lRet 	 := .T.
Local nCODUF := aScan(oGetZ61:aHeader,{|x| AllTrim(x[2])=="Z61_CODUF" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	For nI := 1 to Len(aCols)              
		If ! aCols[n][Len(aCols[n])]         
			//-- verifica se existe registro duplicado
			If n != nI .and. !aCols[nI][Len(aCols[nI])] .and. aCols[nI,nCODUF] == aCols[n,nCODUF]
				Aviso("Aviso","Este estado jแ foi informado!",{"OK"})
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
ฑฑบPrograma  ณZ61CODUF  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo do campo Z61_CODUF.                                ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*---------------------------------------------------------------------------*
User Function Z61CODUF()
*---------------------------------------------------------------------------*
Local lRet 	 := .T.
Local nCODUF := aScan(oGetZ61:aHeader,{|x| AllTrim(x[2])=="Z61_CODUF" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If !Empty(aCols[n,nCODUF]) .and. aCols[n,nCODUF] <> M->Z61_CODUF
		Aviso("Aviso","Nใo poderแ ser alterado registro, somente ้ permitida a inclusใo e exclusใo!",{"OK"})
		lRet := .F.
	EndIf
	
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF11VTR  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo sobre confirma็ใo do processo.                     ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*---------------------------------------------------------------------------*
User Function RJF11VTR()
*---------------------------------------------------------------------------*
Local lRet := .T.
Local nCODFR := aScan(oGetZ62:aHeader,{|x| AllTrim(x[2])=="Z62_CODFR" })
Local nLOJFR := aScan(oGetZ62:aHeader,{|x| AllTrim(x[2])=="Z62_LOJFR" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	For nI := 1 to Len(aCols)              
		If ! aCols[n][Len(aCols[n])]         
			//-- verifica se existe registro duplicado
			If n != nI .and. !aCols[nI][Len(aCols[nI])] .and. aCols[nI,nCODFR] == aCols[n,nCODFR] .and. aCols[nI,nLOJFR] == aCols[n,nLOJFR]
				Aviso("Aviso","C๓digo/Loja jแ foi informado!",{"OK"})
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
ฑฑบPrograma  ณZ62CODFR  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo sobre o campo Z62_CODFR.                           ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*---------------------------------------------------------------------------*
User Function Z62CODFR()
*---------------------------------------------------------------------------*
Local lRet := .T.
Local nCODFR := aScan(oGetZ62:aHeader,{|x| AllTrim(x[2])=="Z62_CODFR" })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If !Empty(aCols[n,nCODFR]) .and. aCols[n,nCODFR] <> M->Z62_CODFR
		Aviso("Aviso","Nใo poderแ ser alterado registro, somente ้ permitida a inclusใo e exclusใo!",{"OK"})
		lRet := .F.
	EndIf

Return (lRet)
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRF11VTOK  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida็ใo sobre a janela.                                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*---------------------------------------------------------------------------*
User Function RF11VTOK(nOpc)
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea()
Local lRet := .T.                

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
                     
	If nOpc == 3	//--Inclusao
		dbSelectArea("Z60")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(xFilial("Z60")+M->Z60_CODCD)
			Aviso("Aviso","Jแ existe centro de distribui็ใo para esta empresa e filial.",{"OK"})
			lRet := .F.
		EndIf
	EndIf 
	
	RestArea(aAreaTMP)

Return (lRet)     
     