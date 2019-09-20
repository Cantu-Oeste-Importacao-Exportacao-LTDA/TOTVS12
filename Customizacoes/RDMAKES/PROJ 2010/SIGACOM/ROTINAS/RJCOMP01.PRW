#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FWPrintSetup.ch" 
#INCLUDE "RPTDEF.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCOMP01   บAutor  ณRafael Parma       บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de confer๊ncia cega sobre documentos   บฑฑ
ฑฑบ          ณde entrada.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJCOMP1A()
*-------------------------*

PRIVATE aRotina := { { OemToAnsi("Pesquisar")   	,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar")  	,"U_RJC01WIN" , 0 , 2} ,;
					 { OemToAnsi("Incluir")     	,"U_RJC01WIN" , 0 , 3} ,;
					 { OemToAnsi("Ticket")			,"U_RJC01TIC" , 0 , 5} ,;
					 { OemToAnsi("Diverg๊ncias")	,"U_RJC01PRT" , 0 , 6} ,;					 
					 { OemToAnsi("Imprimir Mapa")	,"U_RJC01LST" , 0 , 7}  }					 
					 
PRIVATE cCadastro := OemToAnsi("Mapa de confer๊ncia cega")

PRIVATE cAlias := "Z00"       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
     
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	mBrowse(6, 1, 22, 75, cAlias)
	
Return(.T.)


*-------------------------*
User Function RJCOMP1B()
*-------------------------*

PRIVATE aRotina := { { OemToAnsi("Pesquisar")  ,"AxPesqui"   , 0 , 1} ,;
					 { OemToAnsi("Visualizar") ,"U_RJC01WIN" , 0 , 2} ,;
					 { OemToAnsi("Conferir")   ,"U_RJC01CON" , 0 , 4} }
					 
PRIVATE cCadastro := OemToAnsi("Mapa de confer๊ncia cega")

PRIVATE cAlias := "Z00"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
     
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAlias)
	SET FILTER TO EMPTY(Z00->Z00_DTCON)
	
	mBrowse(6, 1, 22, 75, cAlias)
	
	SET FILTER TO 
	
Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC01WIN   บAutor  ณRafael Parma       บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de confer๊ncia cega sobre documentos   บฑฑ
ฑฑบ          ณde entrada.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
*--------------------------------------------------------------*
User Function RJC01WIN( cAlias, nReg, nOpc, xVar, nOper )       
*--------------------------------------------------------------*

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}
Local aRecZ01    := {}
Local aRecZ02    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ01 := {}
Local aFldsNwZ02 := {}
Local aAlterEnch := {}
Local aCpoEnch   := {}
Local nRegE      := 0
Local nModelo    := 3
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T.
Local lNoFolder  := .F. 
Local lProperty  := .F.   		
Local bCampo     := {|nCPO| Field(nCPO)}
Local aPages     := {}
Local nOpcNewGd  := IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cCHAVE     := Z00->Z00_COD
Local cAliasZ0    := "Z00"
Local cSeekZ01   := ""
Local cSeekZ02   := ""
Local cEntidZ1   := "Z01"
Local cEntidZ2   := "Z02"
Local cItem      := "Z01_SEQ" 
Local lGravou    := .F.
Local lTravas    := .T.
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
Local oDlgEmp    

PRIVATE nPosItem := 0
PRIVATE aColsZ01  := {}
PRIVATE aHeadZ01  := {}
PRIVATE aColsZ02  := {}
PRIVATE aHeadZ02  := {}
PRIVATE STRING_NULL := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DEFAULT nOper    := 1  

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefine numera็ใo da confer๊ncia cega                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc == 3
		cNUMOP := GetNextNUMCC()
	Else
		cNUMOP := Z00->Z00_COD
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ0)
	RegToMemory(cAliasZ0, .T., .F.)                                          
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc == 3
			
		For i := 1 TO FCount()
			If ALLTRIM(Eval(bCampo, i)) == "Z00_COD" 
				M->&(Eval(bCampo, i)) := cNUMOP
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_DTINC"
				M->&(Eval(bCampo, i)) := dDataBase
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_HRINC"
				M->&(Eval(bCampo, i)) := SubSTR(TIME(),1,5)
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_USINC"
				M->&(Eval(bCampo, i)) := UPPER(cUserName)
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_DTCON"
				M->&(Eval(bCampo, i)) := ctod(STRING_NULL)
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_HRCON"
				M->&(Eval(bCampo, i)) := STRING_NULL
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_USCON"
				M->&(Eval(bCampo, i)) := STRING_NULL 
			ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_OBS"
				M->&(Eval(bCampo, i)) := Space(TAMSX3("Z00_OBS")[1])
			EndIf
		Next i                  
	
	Else
	
		For i := 1 TO FCount()
			M->&(Eval(bCampo, i)) := FieldGet(i)
		Next i                  
	
	EndIf

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ0)
	While !Eof().and.(x3_arquivo==cAliasZ0)
	   If X3USO(x3_usado).and.cNivel>=x3_nivel
	      AADD(aCpoEnch,x3_campo)
	   Endif
	   dbSkip()
	End
	AADD(aAlterEnch,"Z00_OBS")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ01 - TABELA Z01                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ1)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ1 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z01_FILIAL|Z01_COD" )
			nUsado++
	
			aAdd(aHeadZ01,{AllTrim(X3Titulo()),;
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
			
			If ( AllTrim(SX3->X3_CAMPO) == "Z01_SEQ" )
				nPosItem := nUsado
			Endif
			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z01                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidZ1)
	dbSetOrder(1)
    (cEntidZ1)->(dbGoTop())
        
	If nOpc == 2
	
		cSeekZ01 := xFilial( cEntidZ1 ) + cNUMOP
	
		If (cEntidZ1)->( MsSeek( cSeekZ01 ) )
			While ( !Eof() .And. cSeekZ01 == Z01->Z01_FILIAL + Z01->Z01_COD )
	
				If ( SoftLock(cEntidZ1 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ01,Array(nUsado+1))
					AAdd(aRecZ01, (cEntidZ1)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ01[nCntFor][10] != "V" )
							aColsZ01[Len(aColsZ01)][nCntFor] := Z01->(FieldGet(FieldPos(aHeadZ01[nCntFor][2])))
						Else
							aColsZ01[Len(aColsZ01)][nCntFor] := CriaVar(aHeadZ01[nCntFor,2])
						EndIf
					Next
					aColsZ01[Len(aColsZ01)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ1)->( dbSkip()   )
			EndDo
		EndIf
	EndIf
	
	
	If Empty( aColsZ01 )
		AAdd(aColsZ01,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ01[1,nCntFor] := CriaVar(aHeadZ01[nCntFor,2], .F. )
		Next nCntFor
		aColsZ01[1][nUsado+1] := .F.
		aColsZ01[1][nPosItem] := StrZero(1,TamSx3(cItem)[1])
	EndIf
	aFldsNwZ01 := aFldsNwTMP
    nCntFor := 0
    nUsado  := 0


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ02 - TABELA Z02                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ2)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ2 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z02_FILIAL|Z02_COD" )
			nUsado++
			                                                 
			If "U_" $ SX3->X3_CBOX 
				cLISTAOPC := &(SX3->X3_CBOX)
			Else
				cLISTAOPC := SX3->X3_CBOX
			EndIf

			aAdd(aHeadZ02,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              cLISTAOPC,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsNwTMP, SX3->X3_CAMPO)
			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z02                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea(cEntidZ2)
	dbSetOrder(1)
 	(cEntidZ2)->(dbGoTop())
    
    If nOpc == 2    
		
		cSeekZ02 := xFilial( cEntidZ2 ) + cNUMOP
	
		If (cEntidZ2)->( MsSeek( cSeekZ02 ) )
			While ( !Eof() .And. cSeekZ02 == Z02->Z02_FILIAL + Z02->Z02_COD )
	
				If ( SoftLock(cEntidZ2 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ02,Array(nUsado+1))
					AAdd(aRecZ02, (cEntidZ2)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ02[nCntFor][10] != "V" )
							aColsZ02[Len(aColsZ02)][nCntFor] := Z02->(FieldGet(FieldPos(aHeadZ02[nCntFor][2])))
						Else
							aColsZ02[Len(aColsZ02)][nCntFor] := CriaVar(aHeadZ02[nCntFor,2])
						EndIf
					Next
					aColsZ02[Len(aColsZ02)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ2)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ02 )
		AAdd(aColsZ02,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ02[1,nCntFor] := CriaVar(aHeadZ02[nCntFor,2], .F. )
		Next nCntFor
		aColsZ02[1][nUsado+1] := .F.
	EndIf
	
	aFldsNwZ02 := aFldsNwTMP
	
	If ( lTravas )

		AAdd( aObjects, { 080, 080, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ0,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Notas Fiscais","Produtos"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ01 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "U_RJCP01LnOk", "U_RJCP01TdOk", "+" + cItem, , 000, 001,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ01 ,aColsZ01 )
		oGetZ02 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcVisul, STRING_NULL, STRING_NULL, , aFldsNwZ02, 000, 999,, STRING_NULL, .F., oFolder:aDialogs[2], aHeadZ02 ,aColsZ02 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ01:TudoOk().and.oGetZ02:TudoOk(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJUCP01INC( oGetZ01, aCpoEnch )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
			
		EndIf  
		
	EndIf
	
	If ( __lSx8 )
		
	EndIf
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor
	
	If nOpc == 3 .and. nOpcA == 1
		If MsgYesNo("Deseja imprimir ticket do mapa de confer๊ncia cega?")
			U_RJC01TIC()
		EndIf
	EndIf

	RestArea( aArea )

Return(lGravou)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUCP01INC บAutor  ณRafael Parma       บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que grava os dados relacionados a confer๊ncia cega.   ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------*
Static Function RJUCP01INC( oGetZ01, aCpoEnch )
*---------------------------------------------------------*

Local cSeekZ01  := ""
Local cLISTDOC  := ""
Local cEntZ00   := "Z00"
Local cEntZ01   := "Z01"
Local cEntZ02   := "Z02"
Local lGravou   := .F.
Local nLoop     := 0
Local nLoop2    := 0
Local aLISTDOC  := {}
Private aCols   := oGetZ01:aCols
Private aHeader := oGetZ01:aHeader


	Begin Transaction
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava dados do cabecalho                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		
		dbSelectArea(cEntZ00)
		dbSetOrder(1)
		If dbSeek(xFilial(cEntZ00)+M->Z00_COD)
			While .T.
		   		M->Z00_COD := GetNextNUMCC()		
		   		dbSelectArea(cEntZ00)
				dbSetOrder(1)
				If !dbSeek(xFilial(cEntZ00)+M->Z00_COD)
					Exit
				EndIf
			Enddo
		EndIf
			
		If Len(aCpoEnch) > 0
			If RecLock(cEntZ00,.T.)
				Z00->Z00_FILIAL := xFilial(cEntZ00)
				For nI := 1 to Len(aCpoEnch)
					&("Z00->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
				Next nI
				Z00->(MsUnLock())
			EndIf		
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava dados de itens - notas fiscais                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		For nLoop := 1 To Len( aCols )
						
			lGravou := .T.
			If GDDeleted( nLoop )
				
				dbSelectArea(cEntZ01)
				dbSetOrder(3)	//Z01_FILIAL+Z01_COD+Z01_SEQ
				dbGoTop()
				If dbSeek ( xFilial(cEntZ01) + M->Z00_COD + aCols[nLoop,nPosItem] )
					RecLock( cEntZ01, .F. )
					(cEntZ01)->( dbDelete() )
					(cEntZ01)->( MsUnlock() ) 		
				EndIf
				
			Else
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Inclui e grava os campos chave                                         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
				dbSelectArea(cEntZ01)
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial(cEntZ01) + M->Z00_COD + aCols[nLoop,nPosItem] )
					RecLock( cEntZ01, .F. )
				Else			
					RecLock( cEntZ01, .T. ) 		
					Z01->Z01_FILIAL := xFilial( cEntZ01 )
					Z01->Z01_COD    := M->Z00_COD	
				EndIf
	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Grava os demais campos                                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

				For nLoop2 := 1 To Len( aHeader )
					If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z01_FILIAL|Z01_COD" )
						Z01->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
					EndIf
				Next nLoop2
	
				(cEntZ01)->(MsUnlock())
	
			EndIf
			
			cLISTDOC += "'" + Z01->Z01_DOC + Z01->Z01_SERIE + Z01->Z01_FORNEC + Z01->Z01_LOJA + "',"
            aAdd ( aLISTDOC, { Z01->Z01_FILIAL, Z01->Z01_DOC, Z01->Z01_SERIE, Z01->Z01_FORNEC, Z01->Z01_LOJA } )
			
		Next nLoop


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Busca e grava produtos das notas fiscais                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		
		If Len(cListDOC) > 0              
		                               
			aLISTPRD  := {}
			cLISTDOC  := SubSTR(cListDOC,1,Len(cListDOC)-1)
		    cAliasTMP := GetNextAlias() 
		    
			cQuery := "	SELECT  SD1.D1_ITEM, 														" + CHR(13)
			cQuery += "			SD1.D1_COD															" + CHR(13)
			cQuery += "	FROM " + RetSQLName("SD1") + " SD1											" + CHR(13)
			cQuery += "	WHERE  																		" + CHR(13)
			cQuery += "			SD1.D1_FILIAL   = '" + xFilial("SD1") + "'	 						" + CHR(13)
			cQuery += "	AND		SD1.D1_DOC || SD1.D1_SERIE || SD1.D1_FORNECE || SD1.D1_LOJA 		" + CHR(13)
			cQuery += "			IN (" + cListDOC + ")												" + CHR(13)			
			cQuery += "	AND		SD1.D_E_L_E_T_ != '*'												" + CHR(13)
	
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)

			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())	
			While !(cAliasTMP)->(EOF())
				aAdd ( aLISTPRD , { (cAliasTMP)->D1_ITEM, (cAliasTMP)->D1_COD } )
				(cAliasTMP)->(dbSkip())
			Enddo
			(cAliasTMP)->(dbCloseArea())			
			
			If Len(aLISTPRD) > 0
				For nI := 1 to Len(aLISTPRD)  
					
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+aLISTPRD[nI,02])
					
					If RecLock(cEntZ02,.T.)
						Z02->Z02_FILIAL := xFilial(cEntZ02)
						Z02->Z02_COD    := M->Z00_COD
						Z02->Z02_ITEM   := aLISTPRD[nI,01]
						Z02->Z02_PRODUT := aLISTPRD[nI,02]
						Z02->Z02_DESC   := SB1->B1_DESC
						Z02->(MsUnLock())
					EndIf				
					
				Next nI
			EndIf
			
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Atualiza codigo da conferencia cega sobre documento                    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			If Len(aLISTDOC) > 0
				For nI := 1 to Len(aLISTDOC)
					
					dbSelectArea("SF1")			
					dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
					dbGoTop()
					If dbSeek( aLISTDOC[nI,01] + aLISTDOC[nI,02] + aLISTDOC[nI,03] + aLISTDOC[nI,04] + aLISTDOC[nI,05] )
						If RecLock("SF1",.F.)
							SF1->F1_X_CODCC := M->Z00_COD
							SF1->(MsUnLock())
						EndIf
					EndIf
					
				Next nI
			EndIf
		
		EndIf

	End Transaction		


Return( lGravou )


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCP01LnOk   บAutor  ณRafael Parma     บ Data ณ  24/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da MsGetDados.                                     ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          
*------------------------------*
User Function RJCP01LnOk()
*------------------------------*  
Local lRet := .T.
Local nPDOC := aScan(aHeader,{|x| AllTrim(x[2])=="Z01_DOC"})
Local nPSER := aScan(aHeader,{|x| AllTrim(x[2])=="Z01_SERIE"})
Local nPFOR := aScan(aHeader,{|x| AllTrim(x[2])=="Z01_FORNEC"})
Local nPLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="Z01_LOJA"})
Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SF1")			
	dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
	dbGoTop()
	If ! dbSeek( xFilial("SF1") + aCols[n,nPDOC] + aCols[n,nPSER] + aCols[n,nPFOR] + aCols[n,nPLOJ] )
		lRet := .F.
		MsgAlert("Documento nใo existente para este fornecedor!")
	Else
		If !Empty(SF1->F1_STATUS)
			lRet := .F.
			MsgAlert("Documento jแ classificado!")		
		ElseIf !Empty(SF1->F1_X_CODCC)
			lRet := .F.
			MsgAlert("Documento jแ informado na confer๊ncia n๚mero: "+SF1->F1_X_CODCC)				
		EndIf	
	EndIf
	
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If ( (lTestaDel .And. !aCols[nI][nUsado+1]) .Or. !lTestaDel )
			If n != nI .and. aCols[nI,nPDOC] == aCols[n,nPDOC] .and. aCols[nI,nPSER] == aCols[n,nPSER] .and. ;
				aCols[n,nPFOR] == aCols[nI,nPFOR] .and. aCols[nI,nPLOJ] == aCols[nI,nPLOJ]
				MsgAlert("Documento jแ relacionado para esta confer๊ncia!")
				lRet := .F.
			EndIf                          
		EndIf
	Next nI	

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCP01TdOk   บAutor  ณRafael Parma     บ Data ณ  24/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValidacao da EnchoiseBar.                                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                          

*------------------------------*
User Function RJCP01TdOk()
*------------------------------*  
Local lRet := .T.
Return (lRet)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetNextNUMCC บAutor  ณRafael Parma     บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecupera pr๓ximo n๚mero vแlido.                              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------------------*
Static Function GetNextNUMCC()
*-----------------------------------------*
Local cRET := ""
Local cX2MODO := "E"
Local cAliasTMP := GetNextAlias()

	dbSelectArea("SX2")
	dbSetOrder(1)
	If dbSeek("Z00")
		cX2MODO := SX2->X2_MODO	
	EndIf
	
	cQuery := "	SELECT MAX(Z00.Z00_COD) Z00_COD FROM " + RetSQLName("Z00") + " Z00 WHERE Z00.D_E_L_E_T_ != '*' "
	If cX2MODO == "E"
		cQuery += " AND Z00.Z00_FILIAL = '" + xFilial("Z00") + "' "
	EndIf
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())	
	If Empty((cAliasTMP)->Z00_COD)	
		cRET := STRZero(1,TamSX3("Z00_COD")[1])	
    Else
		cRET := STRZero(Val((cAliasTMP)->Z00_COD)+1,TamSX3("Z00_COD")[1])	
    EndIf
	(cAliasTMP)->(dbCloseArea())
	
Return (cRET)  






/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC01CON   บAutor  ณRafael Parma       บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de confer๊ncia cega sobre os produtos. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
 
*--------------------------------------------------------------*
User Function RJC01CON( cAlias, nReg, nOpc, xVar, nOper )       
*--------------------------------------------------------------*

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}  
Local aRecZ02    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ02 := {}
Local aAlterEnch := {}
Local aCpoEnch   := {}
Local nRegE      := 0
Local nModelo    := 3
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T.
Local lNoFolder  := .F. 
Local lProperty  := .F.   		
Local bCampo     := {|nCPO| Field(nCPO)}
Local aPages     := {}
Local nOpcNewGd  := IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cCHAVE     := Z00->Z00_COD
Local cAliasZ0    := "Z00"
Local cSeekZ02   := ""
Local cEntidZ2   := "Z02"
Local lGravou    := .F.
Local lTravas    := .T.
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
Local oDlgEmp    

PRIVATE nPosItem := 0
PRIVATE aColsZ02  := {}
PRIVATE aHeadZ02  := {}

DEFAULT nOper    := 1  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ0)
	
	If !Empty(Z00->Z00_DTCON)
		Aviso("Aten็ใo", "A confer๊ncia jแ foi realizada!", {"OK"}, 2)
		Return
	EndIf
	
	cNUMOP := Z00->Z00_COD
	RegToMemory(cAliasZ0, .T., .F.)                                          
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For i := 1 TO FCount()
		If ALLTRIM(Eval(bCampo, i)) == "Z00_COD" 
			M->&(Eval(bCampo, i)) := cNUMOP
		ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_DTCON"
			M->&(Eval(bCampo, i)) := dDataBase
		ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_HRCON"
			M->&(Eval(bCampo, i)) := SubSTR(TIME(),1,5)
		ElseIf ALLTRIM(Eval(bCampo, i)) == "Z00_USCON"
			M->&(Eval(bCampo, i)) := UPPER(cUserName)
		Else 
			M->&(Eval(bCampo, i)) := FieldGet(i)
		EndIf
	Next i                  

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ0)
	While !Eof().and.(x3_arquivo==cAliasZ0)
	   If X3USO(x3_usado).and.cNivel>=x3_nivel
	      AADD(aCpoEnch,x3_campo)
	   Endif
	   dbSkip()
	End
	AADD(aAlterEnch,"Z00_OBS")                     
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ02 - TABELA Z02                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ2)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ2 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z02_FILIAL|Z02_COD" )
			nUsado++
			
			If "U_" $ SX3->X3_CBOX 
				cLISTAOPC := &(ALLTRIM(SX3->X3_CBOX))
			Else
				cLISTAOPC := SX3->X3_CBOX
			EndIf             			
			
				
			aAdd(aHeadZ02,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              cLISTAOPC,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsNwTMP, SX3->X3_CAMPO)
			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z02                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea(cEntidZ2)
	dbSetOrder(1)
 	(cEntidZ2)->(dbGoTop())
    
	cSeekZ02 := xFilial( cEntidZ2 ) + cNUMOP

	If (cEntidZ2)->( MsSeek( cSeekZ02 ) )
		While ( !Eof() .And. cSeekZ02 == Z02->Z02_FILIAL + Z02->Z02_COD )

			If ( SoftLock(cEntidZ2 ) )
				AAdd(aTravas,{ Alias() , RecNo() })
				AAdd(aColsZ02,Array(nUsado+1))
				AAdd(aRecZ02, (cEntidZ2)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeadZ02[nCntFor][10] != "V" )
						aColsZ02[Len(aColsZ02)][nCntFor] := Z02->(FieldGet(FieldPos(aHeadZ02[nCntFor][2])))
					Else
						aColsZ02[Len(aColsZ02)][nCntFor] := CriaVar(aHeadZ02[nCntFor,2])
					EndIf
				Next
				aColsZ02[Len(aColsZ02)][nUsado+1] := .F.
			Else
				lTravas := .F.
			EndIf
			(cEntidZ2)->( dbSkip()   )
		EndDo
	EndIf

	If Empty( aColsZ02 )
		AAdd(aColsZ02,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ02[1,nCntFor] := CriaVar(aHeadZ02[nCntFor,2], .F. )
		Next nCntFor
		aColsZ02[1][nUsado+1] := .F.
	EndIf
	
	aFldsNwZ02 := aFldsNwTMP
	
	If ( lTravas )

		AAdd( aObjects, { 080, 080, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ0,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Produtos"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ02 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "AllwaysTrue()", "AllwaysTrue()", , , 000, Len(aColsZ02),, "", .F., oFolder:aDialogs[1], aHeadZ02 ,aColsZ02 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ02:TudoOk(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJUCP01CON( oGetZ02, aCpoEnch )
				If ( lGravou )
					EvalTrigger()
					If ( __lSx8 )
						ConfirmSx8()
					EndIf
				EndIf
			End Transaction
			
		EndIf  
		
	EndIf
	
	If ( __lSx8 )
		
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
ฑฑบPrograma  ณRJUCP01CON บAutor  ณRafael Parma       บ Data ณ  23/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que grava as quantidades de confer๊ncia.              ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------*
Static Function RJUCP01CON( oGetZ02, aCpoEnch )
*---------------------------------------------------------*

Local cLISTDOC  := ""
Local cEntZ00   := "Z00"
Local cEntZ02   := "Z02"
Local lGravou   := .F.
Local nLoop     := 0
Local nLoop2    := 0
Local aLISTDOC  := {}
Private aCols   := oGetZ02:aCols
Private aHeader := oGetZ02:aHeader
Private nPosITE := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_ITEM"})
Private nPosPRD := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_PRODUT"})
Private nPosQTD := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_QUANT"})
Private nPosTEB := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_TPEMB"})
Private nPosSIT := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_SITPRD"})
Private nPosDES := aScan(aHeader,{|x| AllTrim(x[2])=="Z02_DESTIN"})

	Begin Transaction
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grava dados do cabecalho                                               ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		
		dbSelectArea(cEntZ00)
		dbSetOrder(1)
		If dbSeek(xFilial(cEntZ00)+M->Z00_COD)
			
			If Len(aCpoEnch) > 0
				If RecLock(cEntZ00,.F.)
					Z00->Z00_FILIAL := xFilial(cEntZ00)
					For nI := 1 to Len(aCpoEnch)
						&("Z00->"+aCpoEnch[nI]) := &("M->"+aCpoEnch[nI])
					Next nI
					Z00->(MsUnLock())
				EndIf		
			EndIf
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava dados de itens produtos                                          ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			For nLoop := 1 To Len( aCols )
							
				If nPosITE > 0
				
					dbSelectArea(cEntZ02)
					dbSetOrder(3)	//Z02_FILIAL+Z02_COD+Z02_ITEM+Z02_PRODUT
					dbGoTop()
					If dbSeek ( xFilial(cEntZ02) + M->Z00_COD + aCols[nLoop,nPosITE] + aCols[nLoop,nPosPRD] )
						RecLock( cEntZ02, .F. )
						Z02->Z02_QUANT  := aCols[nLoop,nPosQTD]
						Z02->Z02_TPEMB  := aCols[nLoop,nPosTEB]
						Z02->Z02_SITPRD := aCols[nLoop,nPosSIT]
						Z02->Z02_DESTIN := aCols[nLoop,nPosDES] 
						(cEntZ02)->(MsUnlock())
					EndIf
					
				Else
				
					dbSelectArea(cEntZ02)
					dbSetOrder(1)	//Z02_FILIAL+Z02_COD+Z02_PRODUT
					dbGoTop()
					If dbSeek ( xFilial(cEntZ02) + M->Z00_COD + aCols[nLoop,nPosPRD] )
						RecLock( cEntZ02, .F. )
						Z02->Z02_QUANT  := aCols[nLoop,nPosQTD]
						(cEntZ02)->(MsUnlock())
					EndIf

				
				EndIf
		
			Next nLoop

		EndIf

	End Transaction		


Return( lGravou )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC01TIC    บAutor  ณRafael Parma      บ Data ณ  14/10/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo ticket para motorista.                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

*--------------------------*
User Function RJC01TIC()         
*--------------------------*     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
 
	nheight07  := 7
	nHeight08  := 8
	nHeight09  := 9
	nHeight10  := 10
	nHeight11  := 11
	nHeight12  := 12
	nheight13  := 13
	nHeight15  := 15
	
	lBold	   := .T.
	lUnderLine := .T.
	
	oFont1	:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
	oFont2  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont3  := TFont():New( "Arial",,nHeight10,,lBold,,,,,!lUnderLine )
	oFont4  := TFont():New( "Arial",,nHeight11,,lBold,,,,,!lUnderLine )
	oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
	oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
	oFont7  := TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
	oFont8  := TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
	oFont9  := TFont():New( "Arial",,nheight10,,lBold,,,,,!lUnderLine )
	lFirst	:= .T.
	
	cNomePDF := CriaTrab(,.F.)
	
	lAdjustToLegacy := .F. // Inibe legado de resolu็ใo com a TMSPrinter
	lDisableSetup   := .T.    

	oPrn    := FWMSPrinter():New(cNomePDF, IMP_PDF, lAdjustToLegacy, , lDisableSetup, , , , .F., , .F.) //TMSPrinter():New()
	//oPen    := TPen():New(,7,CLR_BLACK,oPrn)

	oPrn:SetPortrait()
	oPrn:Setup()

	oPrn:StartPage()
	
	oPrn:Box( 0005, 0005, 0450, 0860 )			
	oPrn:Say( 0050, 0030, ALLTRIM(SM0->M0_NOMECOM), oFont2, 100 )		
	oPrn:Say( 0120, 0075, "CONFERENCIA MAPA CEGO", oFont5, 100 )
	oPrn:Say( 0170, 0300, dtoc(ddatabase)+" - "+SubSTR(Time(),1,5), oFont2, 100 )
	oPrn:Say( 0220, 0150, "NฺMERO: "+Z00->Z00_COD, oFont6, 100 )	
	oPrn:Say( 0410, 0030, "SR. MOTORISTA FAVOR ENTREGAR AO CONFERENTE. OBRIGADO!", oFont1, 100 )
	MSBAR3("EAN13", 2.5, 2.1, Z00->Z00_FILIAL+Z00->Z00_COD+Z00->Z00_FILIAL, oPrn,.F.,,,,0.6,,,,.F.)	
	oPrn:EndPage() 
	oPrn:Preview()	


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC01PRT    บAutor  ณRafael Parma      บ Data ณ  27/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de produtos comprados x entregues.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

*--------------------------*
User Function RJC01PRT()         
*--------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "PRODUTOS COMPRADOS X ENTREGUES"                       
Local nLin          := 80
Local Cabec1 		:= "PRODUTO                                         TIPO DA       SITUAวรO    DESTINAวรO    QUANTIDADE        QUANTIDADE      QTDE TOTAL"
Local Cabec2 		:= "                                                EMBALAGEM     PRODUTO     PRODUTO       NOTA FISCAL       ENTREGUE        DIVERGENTE"
Local imprime       := .T.
Local aOrd          := {"Nota Fiscal"}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RJC01PRT" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RJC01PRT"
Private cPerg       := "RJC01PRT01"
Private cString     := "SF1"
Private STRING_NULL := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea(cString)
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AjustaSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]
	 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Rafael Parma       บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

*---------------------------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*
Local aNOTASFIS := {}
Local aPRODUTOS := {}
Local cQuery    := STRING_NULL
Local cAliasTMP := GetNextAlias()
Local nDOCNOTAF := 0
Local nDOCENTRE := 0
Local nDOCDIVER := 0
Local nCONNOTAF := 0
Local nCONENTRE := 0
Local nCONDIVER := 0
Local nTOTNOTAF := 0
Local nTOTENTRE := 0
Local nTOTDIVER := 0
Local aLIST_TPE := FOPCFLD(U_RJC1LSTF("Z3"))	//Tipo de embalagem
Local aLIST_STP := FOPCFLD(U_RJC1LSTF("Z4"))	//Situa็ใo do produto
Local aLIST_DST := FOPCFLD(U_RJC1LSTF("Z5"))	//Destina็ใo do produto

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro de documentos                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	cQuery := "	SELECT																	" + chr(13)
	cQuery += "			Z01.Z01_COD,													" + chr(13)
	cQuery += "			Z01.Z01_DOC,													" + chr(13)
	cQuery += "			Z01.Z01_SERIE,													" + chr(13)
	cQuery += "			Z01.Z01_FORNEC,													" + chr(13)
	cQuery += "			Z01.Z01_LOJA													" + chr(13)
	cQuery += "	FROM " + RetSQLName("Z01") + " Z01		   								" + chr(13)
	cQuery += "	WHERE 									   								" + chr(13)
	cQuery += "			Z01.Z01_FILIAL   = '" + xFilial("Z01") + "'						" + chr(13)
	If mv_par06 == 1
		cQuery += "	AND	Z01.Z01_DOC BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'	" + chr(13)
		cQuery += "	AND	Z01.Z01_SERIE    = '" + mv_par03 + "' 							" + chr(13)
	Else	
		cQuery += "	AND	Z01.Z01_COD BETWEEN '" + mv_par04 + "' AND '" + mv_par05 + "'	" + chr(13)
	EndIf
	cQuery += "	AND	Z01.D_E_L_E_T_      != '*'											" + chr(13)
	cQuery += "	ORDER BY																" + chr(13)
	cQuery += "			Z01.Z01_COD,													" + chr(13)
	cQuery += "			Z01.Z01_DOC,													" + chr(13)
	cQuery += "			Z01.Z01_SERIE,													" + chr(13)
	cQuery += "			Z01.Z01_FORNEC,													" + chr(13)
	cQuery += "			Z01.Z01_LOJA													" + chr(13)
	
	memowrite("RJCOMP01_01.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Percorre itens e adiciona ao array de documentos                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	While (cAliasTMP)->(!EOF())
	    
		If Len(aNOTASFIS) == 0
			nPOS := 0
		Else
			nPOS := aScan ( aNOTASFIS, {|x| x[1] ==  (cAliasTMP)->Z01_COD } )
		EndIf                                 
		
		If nPOS == 0
			aAdd ( aNOTASFIS , { (cAliasTMP)->Z01_COD, {} } )
			aAdd ( aPRODUTOS , { (cAliasTMP)->Z01_COD, {} } )
			nPOS := Len(aNOTASFIS)
		EndIf
		
		If nPOS != 0
			aAdd ( aNOTASFIS[nPOS][02], { (cAliasTMP)->Z01_DOC, (cAliasTMP)->Z01_SERIE, (cAliasTMP)->Z01_FORNEC, (cAliasTMP)->Z01_LOJA, {} } )
		EndIf
		
		IncRegua()
		(cAliasTMP)->(dbSkip())
	Enddo
	
	(cAliasTMP)->(dbCloseArea())


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Recupera produtos dos documentos                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ


    If Len(aNOTASFIS) > 0       
    
		SetRegua(Len(aNOTASFIS))    
    	For nI := 1 to Len(aNOTASFIS)

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Filtro de produtos de documentos                                    ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			
			cQuery := "	SELECT																	" + chr(13)
			cQuery += "			Z02.Z02_ITEM,													" + chr(13)
			cQuery += "			Z02.Z02_PRODUT,													" + chr(13)
			cQuery += "			Z02.Z02_SITPRD,													" + chr(13)
			cQuery += "			Z02.Z02_DESTIN,													" + chr(13)
			cQuery += "			Z02.Z02_TPEMB, 													" + chr(13)
			cQuery += "			Z02.Z02_QUANT 													" + chr(13)
			cQuery += "	FROM " + RetSQLName("Z02") + " Z02		   								" + chr(13)
			cQuery += "	WHERE 									   								" + chr(13)
			cQuery += "			Z02.Z02_FILIAL   = '" + xFilial("Z02")   + "'					" + chr(13)
			cQuery += "	AND		Z02.Z02_COD      = '" + aNOTASFIS[nI,01] + "'					" + chr(13)
			cQuery += "	AND		Z02.D_E_L_E_T_  != '*'											" + chr(13)
			cQuery += "	ORDER BY																" + chr(13)
			cQuery += "			Z02.Z02_PRODUT													" + chr(13)
			
			memowrite("RJCOMP01_02.SQL",cQuery)
			
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			
			While (cAliasTMP)->(!EOF())			    
				aAdd ( aPRODUTOS[nI][02], { (cAliasTMP)->Z02_PRODUT, (cAliasTMP)->Z02_QUANT, (cAliasTMP)->Z02_TPEMB, (cAliasTMP)->Z02_SITPRD, (cAliasTMP)->Z02_DESTIN, (cAliasTMP)->Z02_ITEM } )
				(cAliasTMP)->(dbSkip())
			Enddo
			
			(cAliasTMP)->(dbCloseArea())
            Incregua()
            
    	Next nI
    

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Percorre itens da nota fiscal                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
		SetRegua(Len(aNOTASFIS))    
    	For nI := 1 to Len(aNOTASFIS)
			For nJ := 1 to Len(aNOTASFIS[nI][02])
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Filtro de produtos dos documentos                                   ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				
				cQuery := "	SELECT																	" + chr(13)
				cQuery += "			SD1.D1_ITEM, 													" + chr(13)
				cQuery += "			SD1.D1_COD,														" + chr(13)
				cQuery += "			SD1.D1_DESCRI, 													" + chr(13)
				cQuery += "			SD1.D1_QUANT 													" + chr(13)
				cQuery += "	FROM " + RetSQLName("SD1") + " SD1		   								" + chr(13)
				cQuery += "	INNER JOIN " + RetSQLName("SF1") + " SF1		   						" + chr(13)
				cQuery += "	ON		SD1.D1_FILIAL   = SF1.F1_FILIAL									" + chr(13)
				cQuery += "	AND		SD1.D1_DOC      = SF1.F1_DOC									" + chr(13)				
				cQuery += "	AND		SD1.D1_SERIE    = SF1.F1_SERIE									" + chr(13)
				cQuery += "	AND		SD1.D1_FORNECE  = SF1.F1_FORNECE								" + chr(13)
				cQuery += "	AND		SD1.D1_LOJA     = SF1.F1_LOJA									" + chr(13)								
				cQuery += "	WHERE 									   								" + chr(13)
				cQuery += "			SD1.D1_FILIAL   = '" + xFilial("SD1") + "'						" + chr(13)
				cQuery += "	AND		SD1.D1_DOC      = '" + aNOTASFIS[nI][02][nJ][01] + "'			" + chr(13)
				cQuery += "	AND		SD1.D1_SERIE    = '" + aNOTASFIS[nI][02][nJ][02] + "'			" + chr(13)
				cQuery += "	AND		SD1.D1_FORNECE  = '" + aNOTASFIS[nI][02][nJ][03] + "'			" + chr(13)
				cQuery += "	AND		SD1.D1_LOJA     = '" + aNOTASFIS[nI][02][nJ][04] + "'			" + chr(13)								
				cQuery += "	AND		SF1.F1_X_CODCC  = '" + aNOTASFIS[nI][01] + "'					" + chr(13)
				cQuery += "	AND		SD1.D_E_L_E_T_ != '*'											" + chr(13)
				cQuery += "	AND		SF1.D_E_L_E_T_ != '*'											" + chr(13)
				cQuery += "	ORDER BY																" + chr(13)
				cQuery += "			SD1.D1_ITEM  													" + chr(13)
				
				memowrite("RJCOMP01_03.SQL",cQuery)
				
				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)			
				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())
				
				While (cAliasTMP)->(!EOF())			    
					aAdd ( aNOTASFIS[nI][02][nJ][05], { (cAliasTMP)->D1_COD, (cAliasTMP)->D1_DESCRI, (cAliasTMP)->D1_QUANT, (cAliasTMP)->D1_ITEM } )
					(cAliasTMP)->(dbSkip())
				Enddo
				
				(cAliasTMP)->(dbCloseArea())
	            Incregua()
	   		
	   		Next nJ
    	Next nI
    	
    	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressใo dos documentos                                            ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
		SetRegua(Len(aNOTASFIS))    
    	For nI := 1 to Len(aNOTASFIS)

			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9    	
                                           
			dbSelectArea("Z00")
			dbSetOrder(1)
			dbSeek ( xFilial("Z00") + aNOTASFIS[nI][01] )
			
			@nLin,000 PSAY "CONFERENCIA: "+aNOTASFIS[nI][01]
			@nLin,040 PSAY "DATA: "+dtoc(Z00->Z00_DTCON)
			@nLin,060 PSAY "HORA: "+Z00->Z00_HRCON
			@nLin,080 PSAY "CONF.POR: "+Z00->Z00_USCON
			nLin += 2

    		
			For nJ := 1 to Len(aNOTASFIS[nI][02])

				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Verifica o cancelamento pelo usuario...                             ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
				If lAbortPrint
					@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
					Exit
				Endif
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
				If nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
		
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressใo dos dados                                                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			    
			    If nDOCNOTAF != 0
					
					@nLin,000 PSAY "TOTAL DOCUMENTO -----> "
					@nLin,088 PSAY nDOCNOTAF PICTURE "@E 99,999,999.99"
					@nLin,105 PSAY nDOCENTRE PICTURE "@E 99,999,999.99"
					@nLin,120 PSAY nDOCDIVER PICTURE "@E 99,999,999.99"
					
					nLin += 2     					
					nDOCNOTAF := 0
					nDOCENTRE := 0
					nDOCDIVER := 0
					
				EndIf
				    
				dbSelectArea("SF1")
				dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
				dbSeek ( xFilial("SF1") + aNOTASFIS[nI][02][nJ][01] + aNOTASFIS[nI][02][nJ][02] + aNOTASFIS[nI][02][nJ][03] + aNOTASFIS[nI][02][nJ][04])
								
				dbSelectArea("SA2")
				dbSetOrder(1)	//A2_FILIAL+A2_COD+A2_LOJA
				dbSeek ( xFilial("SA2") + aNOTASFIS[nI][02][nJ][03] + aNOTASFIS[nI][02][nJ][04] )
				
				@nLin,000 PSAY "DOCUMENTO: "+aNOTASFIS[nI][02][nJ][01]+"/"+aNOTASFIS[nI][02][nJ][02] 
				@nLin,030 PSAY "EMISSAO: "+dtoc(SF1->F1_EMISSAO)				
				@nLin,060 PSAY "FORNECEDOR: "+aNOTASFIS[nI][02][nJ][03]+"/"+aNOTASFIS[nI][02][nJ][04]+"-"+SA2->A2_NOME
			    nLin ++
			    
			    If Empty(SF1->F1_STATUS)
				    @nLin,000 PSAY "OBS: ** DOCUMENTO NAO CLASSIFICADO **"
				    nLin ++
			    EndIf
				
				For nK := 1 to Len(aNOTASFIS[nI][02][nJ][05])
				
					nPOSPRD := aScan ( aPRODUTOS[nI][02], { |x| x[1] == aNOTASFIS[nI][02][nJ][05][nK][01] .and. x[6] == aNOTASFIS[nI][02][nJ][05][nK][04] } )
					
					nQDTDDIV  := aPRODUTOS[nI][02][nPOSPRD][02] - aNOTASFIS[nI][02][nJ][05][nK][03]

					nDOCNOTAF += aNOTASFIS[nI][02][nJ][05][nK][03]
					nDOCENTRE += aPRODUTOS[nI][02][nPOSPRD][02]
					nDOCDIVER += nQDTDDIV
					nCONNOTAF += aNOTASFIS[nI][02][nJ][05][nK][03]
					nCONENTRE += aPRODUTOS[nI][02][nPOSPRD][02]
					nCONDIVER += nQDTDDIV
					nTOTNOTAF += aNOTASFIS[nI][02][nJ][05][nK][03]
					nTOTENTRE += aPRODUTOS[nI][02][nPOSPRD][02]
					nTOTDIVER += nQDTDDIV

/*
		Local Cabec1 		:=  "PRODUTO                                                             QUANTIDADE              QUANTIDADE              QTDE TOTAL"
		Local Cabec2 		:=  "                                                                    NOTA FISCAL             ENTREGUE                DIVERGENTE"
*/
					//cabec1 := "PRODUTO                                         TIPO DA       SITUAวรO    DESTINAวรO    QUANTIDADE        QUANTIDADE      QTDE TOTAL"
					//cabec2 := "                                                EMBALAGEM     PRODUTO     PRODUTO       NOTA FISCAL       ENTREGUE        DIVERGENTE"
					//           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
					//           0         1         2         3         4         5         6         7         8         9        10         11       12        13				
		
					cPRODUTO := ALLTRIM(aNOTASFIS[nI][02][nJ][05][nK][01]) + "-" + ALLTRIM(aNOTASFIS[nI][02][nJ][05][nK][02])
					cTIPOEMB := " "
					cSITUPRD := " "
					cDESTPRD := " "					
					nPOS := aScan ( aLIST_TPE, { |x| x[1] == aPRODUTOS[nI][02][nPOSPRD][03] } )
					If nPOS != 0
						cTIPOEMB := aLIST_TPE[nPOS][02]
					EndIf
					nPOS := aScan ( aLIST_STP, { |x| x[1] == aPRODUTOS[nI][02][nPOSPRD][04] } )
					If nPOS != 0
						cSITUPRD := aLIST_STP[nPOS][02]
					EndIf
					nPOS := aScan ( aLIST_DST, { |x| x[1] == aPRODUTOS[nI][02][nPOSPRD][05] } )
					If nPOS != 0
						cDESTPRD := aLIST_DST[nPOS][02]
					EndIf

					@nLin,000 PSAY SubSTR(cPRODUTO,1,46)
					@nLin,048 PSAY SubSTR(cTIPOEMB,1,12)
					@nLin,062 PSAY SubSTR(cSITUPRD,1,12)
					@nLin,074 PSAY SubSTR(cDESTPRD,1,12)										
					@nLin,088 PSAY aNOTASFIS[nI][02][nJ][05][nK][03] 	PICTURE "@E 9,999,999.99"
					@nLin,105 PSAY aPRODUTOS[nI][02][nPOSPRD][02] 		PICTURE "@E 9,999,999.99"
					@nLin,120 PSAY nQDTDDIV								PICTURE "@E 9,999,999.99"
				    nLin ++
					
				Next nK	            	            
	   		                       
	   		
	   		Next nJ                 

			If nDOCNOTAF != 0
	
				@nLin,000 PSAY "TOTAL DOCUMENTO -----> "
				@nLin,088 PSAY nDOCNOTAF PICTURE "@E 9,999,999.99"
				@nLin,105 PSAY nDOCENTRE PICTURE "@E 9,999,999.99"
				@nLin,120 PSAY nDOCDIVER PICTURE "@E 9,999,999.99"
				nLin += 2
			
				@nLin,000 PSAY "TOTAL CONFERENCIA ---> "
				@nLin,088 PSAY nCONNOTAF PICTURE "@E 9,999,999.99"
				@nLin,105 PSAY nCONENTRE PICTURE "@E 9,999,999.99"
				@nLin,120 PSAY nCONDIVER PICTURE "@E 9,999,999.99"
				nLin += 2
				
				nDOCNOTAF := 0
				nDOCENTRE := 0
				nDOCDIVER := 0
				nCONNOTAF := 0
				nCONENTRE := 0
				nCONDIVER := 0
				
			EndIf        
	
	   		Incregua()	   		
    	Next nI
    	
    			
		If nTOTNOTAF != 0

			@nLin,000 PSAY "TOTAL GERAL ---------> "
			@nLin,088 PSAY nTOTNOTAF PICTURE "@E 9,999,999.99"
			@nLin,105 PSAY nTOTENTRE PICTURE "@E 9,999,999.99"
			@nLin,120 PSAY nTOTDIVER PICTURE "@E 9,999,999.99"

		EndIf
	
	EndIf
		
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  27/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Documento De        ?","Documento De        ?","Documento De        ?","mv_ch1","C",TAMSX3("F1_DOC")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SF1","","018",""})
	aAdd(aRegs,{cPerg,"02","Documento At้       ?","Documento At้       ?","Documento At้       ?","mv_ch2","C",TAMSX3("F1_DOC")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SF1","","018",""})
	aAdd(aRegs,{cPerg,"03","Serie               ?","Serie               ?","Serie               ?","mv_ch3","C",TAMSX3("F1_SERIE")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Confer๊ncia De      ?","Confer๊ncia De      ?","Confer๊ncia De      ?","mv_ch4","C",TAMSX3("Z00_COD")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "Z00000","","",""})
	aAdd(aRegs,{cPerg,"05","Confer๊ncia At้     ?","Confer๊ncia At้     ?","Confer๊ncia At้     ?","mv_ch5","C",TAMSX3("Z00_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "Z00000","","",""})
	aAdd(aRegs,{cPerg,"06","Filtrar Por         ?","Filtrar Por         ?","Filtrar Por         ?","mv_ch6","N",01,0,1,"C","","mv_par06","Documento","Documento","Documento","","","Confer๊ncia","Confer๊ncia","Confer๊ncia","","","","","","","","","","","","","","","","", "","","",""})		
		
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC01LST    บAutor  ณRafael Parma      บ Data ณ  07/12/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de lista de produtos para processo de confer๊ncia บฑฑ
ฑฑบ          ณmanual.                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/       

*--------------------------*
User Function RJC01LST()         
*--------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//Guilherme tela para escolher tipo de impressao Retrato ou Paisagem
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "PRODUTOS - MAPA CEGO"
Local imprime       := .T.
Local aOrd          := {"C๓digo","Descri็ใo","Item NF"}
Local nLin          := 80 
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private nomeprog    := "RJC01LST" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RJC01LST"
Private cPerg       := "RJC01LST01"
Private cString     := "SF1"
Private STRING_NULL := ""  
Private lContinue 	:= .F.  
//Guilherme 06/07/11 para selecionar tipo de impressao: retrato/paisagem
aTpImp	:= {'Retrato','Paisagem'}     
cTpImp	:= 'Retrato'

@ 000,000 TO 100,200 DIALOG oDlg1 TITLE "Tipo do Impressao"
@ 010,010 Say "Formato de Impressao :"
@ 020,010 COMBOBOX cTpImp ITEMS aTpImp SIZE 80,50
@ 035,010 BMPBUTTON TYPE 1 ACTION (Close(oDlg1), lContinue := .T.)
ACTIVATE DIALOG oDlg1 CENTER

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

IF !lContinue
	return
endif                               

If cTpImp == Alltrim('Retrato')   // guilherme                                                                         
	Cabec1 		:= "ITEM PRODUTO                        TIPO DA    SITUAวรO  DESTINAวรO  QUANTIDADE"
	Cabec2 		:= "                                    EMBALAGEM  PRODUTO               ENTREGUE  "
	limite      := 080
	tamanho     := "P"
Else   
    Cabec1 		:= "ITEM PRODUTO                                                                                                                                                                 TIPO DA      SITUAวรO  DESTINAวรO    QUANTIDADE"
	Cabec2 		:= "                                                                                                                                                                             EMBALAGEM    PRODUTO                 ENTREGUE  "
	limite      := 220
	tamanho     := "G"
EndIf
//Guilherme
	
	dbSelectArea(cString)
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AjSX1LST()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]
	 
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//Guilherme Adicionado o parametro tpIpm(Tipo de impressao Retrato/Paisagem)
	RptStatus({|| RunRepLST(Cabec1,Cabec2,@Titulo,nLin,nOrdem,cTpImp) },Titulo)
	
Return       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Rafael Parma       บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
  // Guilherme adicionado parametro para tipo de impressao tpImp(Retrato/Paisagem)
*---------------------------------------------------------------------*
Static Function RunRepLST(Cabec1,Cabec2,Titulo,nLin,nOrdem,cTpImp)
*---------------------------------------------------------------------*
Local cCODCCINI := mv_par01
Local cCODCCFIN := mv_par02
Local nPRD 		:= 0

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Busca produtos do mapa cego                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	dbSelectArea("Z00")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("Z00") + cCODCCINI )
		While !Z00->(EOF()) .and. Z00->Z00_COD >= cCODCCINI .and. Z00->Z00_COD <= cCODCCFIN
		    dbSelectArea("Z02")
		    If nOrdem == 1
		    	dbSetOrder(1)
		    ElseIf nOrdem == 2		    
		    	dbSetOrder(2)
		    Else
		    	dbSetOrder(3)
		    EndIf
		    dbGoTop()
		    If dbSeek ( xFilial("Z02") + Z00->Z00_COD )
		    	
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
               	cTitREL := ALLTRIM(Titulo) + " - " + Z02->Z02_COD 
				Cabec(cTitREL,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9
				nPRD := 0    	
			    	
		    	While !Z02->(EOF()) .and. Z02->Z02_FILIAL + Z02->Z02_COD == xFilial("Z02") + Z00->Z00_COD
		    		
					If lAbortPrint
						@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
						Exit
					Endif
				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Impressao do cabecalho do relatorio. . .                            ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
					If nLin > 65
						Cabec(cTitREL,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
			
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Impressใo dos dados                                                 ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
					///          1         2         3         4         5         7         8         
					///01234567890123456789012345678901234567890123456789012345678901234567890
					//"SEQ PRODUTO                        TIPO DA    SITUAวรO  DESTINAวรO  QUANTIDADE"
					
					nPRD += 1
					cSTRING := ALLTRIM(Z02->Z02_PRODUT)+"-"+ALLTRIM(Z02->Z02_DESC)
					
					If cTpImp == Alltrim('Retrato')  // Guilherme
						@nLin,000 PSAY STRZero(Val(Z02->Z02_ITEM),3)                     
						@nLin,004 PSAY SubSTR(cSTRING,1,30)
						@nLin,036 PSAY Replicate("_",06)
						@nLin,047 PSAY Replicate("_",06)					
						@nLin,057 PSAY Replicate("_",06)					
						@nLin,070 PSAY Replicate("_",10)
						nLin += 2 
					Else // Guilherme  Colocado para separar impressao retrato ou paisagem
						@nLin,000 PSAY STRZero(Val(Z02->Z02_ITEM),3)                     
						@nLin,004 PSAY Alltrim(cSTRING)
						@nLin,173 PSAY Replicate("_",06)
						@nLin,186 PSAY Replicate("_",06)					
						@nLin,198 PSAY Replicate("_",06)					
						@nLin,210 PSAY Replicate("_",10)
						nLin += 2 
					EndIf    // Guilherme
					
		    		Z02->(dbSkip())
		    	Enddo
			EndIf

			If nPRD > 0
			
				If nLin > 55
					Cabec(cTitREL,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
				Endif
										
				// Guilherme 14/04/11 
				// Gustavo 27/10/15 - Incluso quadro TIPO DE CARGA				  
				@nLin,000 PSAY "CARREGAMENTO:                            TIPO CARGA:"
				nLin += 2            
				@nLin,000 PSAY "TERCEIROS(DIA)   : [       ]             GRANEL    : [       ]"
				nLin += 2                         
				@nLin,000 PSAY "TERCEIROS(NOITE) : [       ]             PALET     : [       ]"
				nLin += 2                         
				@nLin,000 PSAY "CANTU/PRำPRIO    : [       ]             CAIXAS    : [       ]"
				nLin += 2
				// fim guilherme

				@nLin,000 PSAY "LEGENDA: "
				nLin += 1            
				@nLin,000 PSAY "TIPO DA EMBALAGEM: "+U_RJC1LSTF("Z3")
				nLin += 1            
				@nLin,000 PSAY "SITUAวรO DO PRODUTO: "+U_RJC1LSTF("Z4")
				nLin += 1            
				@nLin,000 PSAY "DESTINAวรO DO PRODUTO: "+U_RJC1LSTF("Z5")
				nLin += 1            
		
			EndIf
			dbSelectArea("Z00")
			Z00->(dbSkip())
            
            //-- Gustavo 07/10/15
			nLin += 2
			@nLin,000 PSAY "REPASSE: "
			nLin += 1	
			@nLin,000 PSAY Replicate("_",80)
			nLin += 1	
			@nLin,000 PSAY "PRODUTO: " 
			@nLin,020 PSAY "QUANTIDADE: "
			@nLin,044 PSAY "PESO: "
			@nLin,068 PSAY "LIXO: "
			nLin += 2		                 
			@nLin,000 PSAY Replicate("_",12)
			@nLin,020 PSAY Replicate("_",12)			
			@nLin,044 PSAY Replicate("_",12)
			@nLin,068 PSAY Replicate("_",12)
			nLin += 2
			@nLin,000 PSAY Replicate("_",12)
			@nLin,020 PSAY Replicate("_",12)			
			@nLin,044 PSAY Replicate("_",12)
			@nLin,068 PSAY Replicate("_",12)
			nLin += 1
			@nLin,000 PSAY Replicate("_",80)
			//-- Fim Gustavo 07/10
			
		Enddo
	Endif
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  27/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjSX1LST()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Confer๊ncia De      ?","Confer๊ncia De      ?","Confer๊ncia De      ?","mv_ch1","C",TAMSX3("Z00_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "Z00000","","",""})
	aAdd(aRegs,{cPerg,"02","Confer๊ncia At้     ?","Confer๊ncia At้     ?","Confer๊ncia At้     ?","mv_ch2","C",TAMSX3("Z00_COD")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "Z00000","","",""})
		
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJC1LSTF   บAutor  ณRafael Parma       บ Data ณ  17/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por buscar a lista de op็๕es de campos   บฑฑ
ฑฑบ          ณa partir do codigo da tabela no SX5.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*------------------------------*
User Function RJC1LSTF(cTAB)
*------------------------------*
Local cLISTA := ""

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SX5")
	dbSetOrder(1)
	dbGoTop()                                                 
	If dbSeek(xFilial("SX5")+cTAB)
		While !SX5->(EOF()) .and. SX5->X5_FILIAL == xFilial("SX5") .and. SX5->X5_TABELA == cTAB
			cLISTA += ALLTRIM(SX5->X5_CHAVE)+"="+ALLTRIM(SX5->X5_DESCRI)+";"
			SX5->(dbSkip())
		Enddo
		cLISTA := SubSTR(cLISTA,1,Len(cLISTA)-1)
	EndIf 
	
Return (cLISTA)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFOPCFLD    บAutor  ณRafael Parma       บ Data ณ  17/05/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por retornar a lista de op็๕es de campos บฑฑ
ฑฑบ          ณa partir do codigo da tabela no SX5 sobre array.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/    

*--------------------------------------*
Static Function FOPCFLD(cLISTA)
*--------------------------------------*
Local aDADOS := {}                
Local lCOD   := .F.
Local cCOD   := ""
Local cDES   := ""

	cLISTA := ALLTRIM(cLISTA)       
	If Len(cLISTA) > 0            
		For nX := 1 to Len(cLISTA)
			If ! lCOD .and. ! SubSTR(cLISTA,nX,1) $ "=;"
				cCOD += SubSTR(cLISTA,nX,1)
			ElseIf ! lCOD .and. SubSTR(cLISTA,nX,1) == "="
				lCOD := .T.
			ElseIf lCOD .and. ! SubSTR(cLISTA,nX,1) $ "=;"
				cDES += SubSTR(cLISTA,nX,1)
			ElseIf lCOD .and. SubSTR(cLISTA,nX,1) == ";"
				aAdd ( aDADOS, {cCOD , cDES} )
				lCOD := .F.
				cCOD := ""
				cDES := ""
			EndIf
		Next nX                               
		aAdd ( aDADOS, { cCOD , cDES } )
	EndIf
	
Return (aDADOS)