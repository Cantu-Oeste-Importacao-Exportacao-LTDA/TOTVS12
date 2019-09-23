#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCOMP03   บAutor  ณRafael Parma       บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo dos detalhes das caracteristicas de    บฑฑ
ฑฑบ          ณprodutos.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJCOMP03()
*-------------------------*


Private cCadastro := "Detalhes de Caracteristicas"           

Private aRotina	:= {{"Pesquisar"   ,"AxPesqui"    ,0, 1},;
					{"Visualizar"  ,"U_RJCP03OX"  ,0, 2},;
					{"Relacionar"  ,"U_RJCP03OX"  ,0, 4} }

Private cString := "Z03"  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

mBrowse(6,1,22,75,cString)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCP03OX   บAutor  ณRafael Parma       บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de manuten็ใo de itens de caracteristicas de pruduto.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJCP03OX( cAlias, nReg, nOpc )

Local aArea        := GetArea()
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
Local aGet         := {}
Local aTravas      := {}
Local aEntidade    := {}
Local aRecZ04      := {}
Local aChave       := {}

Local cSeekZ04     := ""
Local cEntidade    := "Z04"

Local lGravou      := .F.
Local lTravas      := .T.

Local nCntFor      := 0
Local nUsado       := 0
Local nPosUser     := 0
Local nOpcA        := 0
Local nScan        := 0
Local nLoop        := 0

Local oDlg
Local oGetD
Local oGetCpo

PRIVATE aCols      := {}
PRIVATE aHeader    := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Posiciona a entidade                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	
	cZ03_COD  := Z03->Z03_CODIGO
    cZ03_DESC := Z03->Z03_DESC
	
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbSeek( cEntidade ) )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidade)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidade )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z04_FILIAL|Z04_CODIGO" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				SX3->X3_VALID,;
				SX3->X3_USADO,;
				SX3->X3_TIPO,;
				SX3->X3_ARQUIVO,;
				SX3->X3_CONTEXT } )
		EndIf
		
		SX3->( dbSkip() )
	EndDo
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols                                                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cEntidade)
	dbSetOrder(1)
        (cEntidade)->(dbGoTop())
        
	cSeekZ04 := xFilial( cEntidade ) + cZ03_COD

	If (cEntidade)->( MsSeek( cSeekZ04 ) )
		While ( !Eof() .And. cSeekZ04 == Z04->Z04_FILIAL + Z04->Z04_CODIGO  )

			If ( SoftLock(cEntidade ) )
				AAdd(aTravas,{ Alias() , RecNo() })
				AAdd(aCols,Array(nUsado+1))
				AAdd(aRecZ04, (cEntidade)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeader[nCntFor][10] != "V" )
						aCols[Len(aCols)][nCntFor] := Z04->(FieldGet(FieldPos(aHeader[nCntFor][2])))
					Else
						aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
					EndIf
				Next
				aCols[Len(aCols)][nUsado+1] := .F.
			Else
				lTravas := .F.
			EndIf
			(cEntidade)->( dbSkip()   )
		EndDo
	EndIf

	If Empty( aCols )
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[1][nUsado+1] := .F.

	EndIf

	If ( lTravas )

		AAdd( aObjects, { 100,  44, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 021,005 SAY OemToAnsi("C๓digo: ") 			SIZE 050,009 OF oDlg PIXEL 
		@ 020,030 GET oGetCpo  VAR cZ03_COD	  			SIZE 030,009 OF oDlg PIXEL WHEN .F.
		@ 021,080 SAY OemToAnsi("Caracterํstica: ") 	SIZE 040,009 OF oDlg PIXEL 
		@ 020,120 GET oGetCpo VAR cZ03_DESC				SIZE 100,009 OF oDlg PIXEL WHEN .F.

		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpc,"U_RJCP03LnOk()","AllwaysTrue", ,.T.)			
	
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| nOpcA:=1, Iif(U_RJCP03TdOk(), oDlg:End(),nOpcA:=0)  } , {||oDlg:End()})
		

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJCP03GRV( cEntidade, aRecZ04 )
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
		RollBackSx8()
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
ฑฑบPrograma  ณRJCP03LnOk   บAutor  ณRafael Parma     บ Data ณ  30/09/10   บฑฑ
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
User Function RJCP03LnOk()
*------------------------------*  
Local lRet := .T.
Local nPDET := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_DETALH"})
Local nPCPC := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_COMPC"})
Local nPCHC := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_CHAVC"})
Local nPSQC := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_SEQC"})
Local nPCPD := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_COMPD"})
Local nPCHD := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_CHAVD"})
Local nPSQD := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_SEQD"})
Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	
	If ! (aCols[n][nUsado+1])
		If aCols[n][nPCPC] == "S" .and. ( Empty(aCols[n][nPCHC]) .or. Empty(aCols[n][nPSQC]) )
			MsgAlert("Favor preencher os campos de composi็ใo de c๓digo!")
			lRet := .F.	
		EndIf                           
		
		If lRet
			If aCols[n][nPCPC] == "S" .and. ( aCols[n][nPCPD] != "S" .or. Empty(aCols[n][nPCHD]) .or. Empty(aCols[n][nPSQD]) )
				MsgAlert("Favor preencher os campos de composi็ใo de descri็ใo quando o detalhe compor o c๓digo!")
				lRet := .F.			
			EndIf
		EndIf
		       
		If lRet
			If aCols[n][nPCPD] == "S" .and. ( Empty(aCols[n][nPCHD]) .or. Empty(aCols[n][nPSQD]) )
				MsgAlert("Favor preencher os campos de composi็ใo de descri็ใo!")
				lRet := .F.	
			EndIf
		EndIf
			
	EndIf
	
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If !aCols[nI][nUsado+1]
			If n != nI .and. aCols[nI,nPDET] == aCols[n,nPDET]
				MsgAlert("C๓digo de detalhe jแ informado!")
				lRet := .F.
				Exit
			EndIf                          
			If n != nI .and. aCols[nI,nPCHC] == aCols[n,nPCHC] .and. aCols[n][nPCPC] == "S" .and. aCols[nI][nPCPC] == "S"
				MsgAlert("Chave de c๓digo do detalhe jแ informado!")
				lRet := .F.
				Exit
			EndIf                          
			If n != nI .and. aCols[nI,nPCHD] == aCols[n,nPCHD] .and. aCols[n][nPCPD] == "S" .and. aCols[nI][nPCPD] == "S"
				MsgAlert("Chave de descri็ใo do detalhe jแ informado!")
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
ฑฑบPrograma  ณRJCP03TdOk   บAutor  ณRafael Parma     บ Data ณ  30/09/10   บฑฑ
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
User Function RJCP03TdOk()
*------------------------------*  
Local lRet := .T.
Local nPDET := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_DETALH"})
Local nPCPC := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_COMPC"})
Local nPCHC := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_CHAVC"})
Local nPCPD := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_COMPC"})
Local nPCHD := aScan(aHeader,{|x| AllTrim(x[2])=="Z04_CHAVD"})
Local nMaxFor   := Len(aCols)
Local nUsado    := Len(aHeader)
Local lTestaDel := nUsado <> Len(aCols[1])

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
   
	
	For nI := 1 to Len(aCols)              
		// verifica se existe registro duplicado
		If ! aCols[nI][Len(aCols[nI])]			
			For nJ := 1 to Len(aCols)			
				If nJ != nI 
					If aCols[nI,nPDET] == aCols[nJ,nPDET] .and. ! aCols[nJ][Len(aCols[nJ])]	
						MsgAlert("O c๓digo do detalhe "+ ALLTRIM(aCols[nI,nPDET]) +" estแ duplicado!")
						lRet := .F.
						Exit
					EndIf
					If aCols[nI,nPCHC] == aCols[nJ,nPCHC] .and. ! aCols[nJ][Len(aCols[nJ])] .and. aCols[n][nPCPC] == "S" .and. aCols[nI][nPCPC] == "S"	
						MsgAlert("O c๓digo da chave de c๓digo "+ ALLTRIM(aCols[nI,nPCHC]) +" estแ duplicado!")
						lRet := .F.
						Exit
					EndIf
					If aCols[nI,nPCHD] == aCols[nJ,nPCHD] .and. ! aCols[nJ][Len(aCols[nJ])] .and. aCols[n][nPCPD] == "S" .and. aCols[nI][nPCPD] == "S"	
						MsgAlert("O c๓digo da chave de descri็ใo "+ ALLTRIM(aCols[nI,nPCHD]) +" estแ duplicado!")
						lRet := .F.
						Exit
					EndIf														
				EndIf
			Next nJ
		EndIf                         		
	Next nI	

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCP03GRV  บAutor  ณRafael Parma       บ Data ณ  27/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para grava็ใo dos dados.                    ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RJCP03GRV( cEntidade, aRecZ04, lExclui )

Local cSeekZ04  := ""
Local lGravou   := .F.
Local nLoop     := 0
Local nLoop2    := 0

DEFAULT lExclui := .F.

If lExclui

	cSeekZ04 := xFilial( cEntidade ) + M->CZ03_COD
	(cEntidade)->( dbSetOrder(1) )
	If (cEntidade)->( dbSeek( cSeekZ04 ) )
		lGravou := .T.
		While !(cEntidade)->( EOF() ) .And. cSeekZ04 == Z04->Z04_FILIAL + Z04->Z04_CODIGO
			RecLock( cEntidade, .F. )
			(cEntidade)->( dbDelete() )
			(cEntidade)->( MsUnLock() ) 			
			(cEntidade)->( dbSkip() )
		EndDo 	
	EndIf 	                  
	
Else

	For nLoop := 1 To Len( aCols )
		lGravou := .T.
		If GDDeleted( nLoop )
			If nLoop <= Len( aRecZ04 )
				(cEntidade)->( MsGoto( aRecZ04[ nLoop ] ) ) 	
				RecLock( cEntidade, .F. )
				(cEntidade)->( dbDelete() )
				(cEntidade)->( MsUnlock() ) 		
			EndIf
		Else
			If nLoop <= Len( aRecZ04 )
				(cEntidade)->( MsGoto( aRecZ04[ nLoop ] ) ) 	
				RecLock( cEntidade, .F. )
			Else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Inclui e grava os campos chave                                         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				RecLock( cEntidade, .T. ) 		
				Z04->Z04_FILIAL  := xFilial( cEntidade )
				Z04->Z04_CODIGO  := M->CZ03_COD
				
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava os demais campos                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nLoop2 := 1 To Len( aHeader )
				If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z04_FILIAL|Z04_CODIGO" )
					Z04->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
				EndIf
			Next nLoop2
			
			//--Tratamento B2B Vertis
			If Z04->Z04_EB2B == "S"
				Z04->Z04_AB2B := "S"
			EndIf			

			Z04->( MsUnlock() )

		EndIf

	Next nLoop

EndIf 	

Return( lGravou )
