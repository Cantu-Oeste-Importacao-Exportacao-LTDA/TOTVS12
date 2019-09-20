#INCLUDE "TOTVS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT010BRW บAutor  ณRafael Parma         บ Data ณ  09/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPE utilizado para adicionar novas op็๕es de menu da Mbrowse.บฑฑ
ฑฑบ          ณCadastro de produtos (MATA010).                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
User Function MT010BRW()
*--------------------------*
Local aRotUser := {}     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	 AAdd( aRotUser, { 'Importadores'       , "U_RJM10IMP", 0, 6 } )
	 aAdd( aRotUser, { 'Inf. Adic. do Vinho', "U_INFADVIN", 0, 6 } )

Return (aRotUser)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJM10IMP บAutor  ณRafael Parma         บ Data ณ  09/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelacionamento de produtos x importadores.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User Function RJM10IMP()
*--------------------------*
Local aArea        := GetArea()
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
Local aGet         := {}
Local aTravas      := {}
Local aEntidade    := {}
Local aRecZ33      := {}
Local aChave       := {}
Local cB1_COD      := ""
Local cB1_DESC     := ""
Local cSeekZ33     := ""
Local cEntidade    := "Z33"
Local lGravou      := .F.
Local lTravas      := .T.

Local nCntFor      := 0
Local nUsado       := 0
Local nOpcA        := 0
Local nScan        := 0
Local nLoop        := 0

Local oDlg
Local oGetD
Local oGet
Local oGet2

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
	
	cB1_COD  := SB1->B1_COD
	cB1_DESC := SB1->B1_DESC
	
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbSeek( cEntidade ) )

	cNomEnt := X2NOME()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Array do Cabecalho                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("B1_COD")
	aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})
	dbSeek("B1_DESC")                                 
	aadd(aGet,{X3Titulo(),SX3->X3_PICTURE,SX3->X3_F3})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeader                                                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidade)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidade )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z33_FILIAL|Z33_PRODUT" )
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
        
	cSeekZ33 := xFilial( cEntidade ) + SB1->B1_COD

	If (cEntidade)->( MsSeek( cSeekZ33 ) )
		While ( !Eof() .And. cSeekZ33 == Z33->Z33_FILIAL + Z33->Z33_PRODUT )

			If ( SoftLock(cEntidade ) )
				AAdd(aTravas,{ Alias() , RecNo() })
				AAdd(aCols,Array(nUsado+1))
				AAdd(aRecZ33, (cEntidade)->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeader[nCntFor][10] != "V" )
						aCols[Len(aCols)][nCntFor] := Z33->(FieldGet(FieldPos(aHeader[nCntFor][2])))
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

		@ 019,005 SAY OemToAnsi("Produto:") SIZE 040,009 OF oDlg PIXEL 
		@ 018,050 GET oGet  VAR cB1_COD  SIZE 120,009 OF oDlg PIXEL WHEN .F.
		@ 031,050 GET oGet2 VAR cB1_DESC SIZE 120,009 OF oDlg PIXEL WHEN .F.

		oGetd:=MsGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], 3,"AllwaysTrue","AllwaysTrue",,.T.)			
		
		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,If(oGetd:TudoOk(),oDlg:End(),nOpcA:=0)},{||oDlg:End()})

		If ( nOpcA == 1 )
			Begin Transaction
				lGravou := RJM10GZ3( cEntidade, aRecZ33 )
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
ฑฑบPrograma  ณRJM10GZ3   บAutor  ณRafael Parma       บ Data ณ  09/09/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para grava็ใo dos dados relacionados.                 ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTOTVS                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RJM10GZ3( cEntidade, aRecZ33, lExclui )

Local cSeekZ33  := ""
Local lGravou   := .F.
Local nLoop     := 0
Local nLoop2    := 0
DEFAULT lExclui := .F.

nPROD := aScan(aHeader,{|x| AllTrim(x[2])=="Z33_PRODUT"})
nPFOR := aScan(aHeader,{|x| AllTrim(x[2])=="Z33_FORNEC"})
nPLOJ := aScan(aHeader,{|x| AllTrim(x[2])=="Z33_LOJA"})

If lExclui

	cSeekZ33 := xFilial( cEntidade ) + SB1->B1_COD
	(cEntidade)->( dbSetOrder(1) )
	If (cEntidade)->( dbSeek( cSeekZ33 ) )
		lGravou := .T.
		While !(cEntidade)->( EOF() ) .And. cSeekZ33 == Z33->Z33_FILIAL + Z33->Z33_PRODUT
			RecLock( cEntidade, .F. )
			(cEntidade)->( dbDelete() )
			(cEntidade)->( MsUnLock() )
			dbSelectArea(cEntidade)			
			(cEntidade)->( dbSkip() )
		EndDo 	
	EndIf 	
Else

	For nLoop := 1 To Len( aCols )
		lGravou := .T.
		If GDDeleted( nLoop )
			If nLoop <= Len( aRecZ33 )
				(cEntidade)->( MsGoto( aRecZ33[ nLoop ] ) ) 	
				RecLock( cEntidade, .F. )
				(cEntidade)->( dbDelete() )
				(cEntidade)->( MsUnlock() ) 		
			EndIf
		Else

			If nLoop <= Len( aRecZ33 )
				(cEntidade)->( MsGoto( aRecZ33[ nLoop ] ) ) 	
				RecLock( cEntidade, .F. )  

			Else
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Inclui e grava os campos chave                                         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				RecLock( cEntidade, .T. ) 		
				Z33->Z33_FILIAL  := xFilial( cEntidade )
				Z33->Z33_PRODUT  := SB1->B1_COD
				
			EndIf

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Grava os demais campos                                                 ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			For nLoop2 := 1 To Len( aHeader )
				If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z33_FILIAL|Z33_PRODUT" )
					Z33->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
				EndIf
				
			Next nLoop2

			Z33->( MsUnlock() )

		EndIf

	Next nLoop
    

EndIf 	

Return( lGravou ) 



User Function FUPDZ33()

Local aDADOS := {}

	aAdd(aDADOS,{"00163222","0001","CANTU FUTURA IMPORTACAO E EXPORTACAO LTDA"})
	aAdd(aDADOS,{"02731684","0001","FRUTAS CANTU NORDESTE LTDA"})
	aAdd(aDADOS,{"02731684","0002","FRUTAS CANTU NORDESTE LTDA"})
	aAdd(aDADOS,{"02731684","0003","FRUTAS CANTU NORDESTE LTDA"})
	aAdd(aDADOS,{"02731684","0004","FRUTAS CANTU NORDESTE LTDA"})
	aAdd(aDADOS,{"03588984","0001","CANTU OESTE IMPORTACAO E EXPORTACAO LTDA"})
	aAdd(aDADOS,{"03588984","0002","CANTU OESTE IMPORTACAO E EXPORTACAO LTDA"})
	aAdd(aDADOS,{"03588984","0003","CANTU OESTE IMPORTACAO E EXPORTACAO LTDA"})
	aAdd(aDADOS,{"04991662","0001","CANTU IMPORTACAO E EXPORTACAO LTDA"})
	aAdd(aDADOS,{"07144456","0001","CANTU SAO JOAQUIM BENEF DE FRUTAS LTDA"})
	aAdd(aDADOS,{"08888040","0001","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0002","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0003","CANTU COMERCIO DE PNEUMATICOS LTDA."})
	aAdd(aDADOS,{"08888040","0004","CANTU COMERCIO DE PNEUMATICO LTDA"})
	aAdd(aDADOS,{"08888040","0005","CANTU COMERCIO DE PNEUMATICO LTDA"})
	aAdd(aDADOS,{"08888040","0006","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0007","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0008","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0009","CANTU COMERCIO DE PNEUMATICOS LTDA"})
	aAdd(aDADOS,{"08888040","0010","CANTU COMERCIO DE PNEUMATICOS LTDA."})
	aAdd(aDADOS,{"10158356","0001","AMAZON DISTRIBUIDORA DE PNEUS E AUTOPECAS"})
	aAdd(aDADOS,{"10158356","0002","AMAZON DISTRIBUIDORA DE PNEUS E AUTOPECAS"})
	aAdd(aDADOS,{"10158356","0003","AMAZON DISTRIBUIDORA DE PNEUS E AUTOPECAS"})
	aAdd(aDADOS,{"12940644","0001","CANTU COMERCIO DE PRODUTOS ALIMENTICIOS CONGELADOS LTDA"})
	aAdd(aDADOS,{"78575149","0001","RJU COM E BENEF DE FRUTAS E VERDURAS LTD"})
	aAdd(aDADOS,{"78575149","0004","RJU COM E BENEF DE FRUTAS E VERDURAS LTD"})
	aAdd(aDADOS,{"78575149","0005","RJU COM BENEF DE FRUTAS E VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0006","RJU COM BENEF DE FRUTAS E VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0007","RJU COM BENEF DE FRUTAS E VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0008","RJU COM BENEF DE FRUTAS E VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0013","RJU COM BENEF DE FRUTAS E VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0014","RJU COM E BENEF DE FRUTAS E VERDURAS LTD"})
	aAdd(aDADOS,{"78575149","0015","RJU COM E BENEF. FRUTAS E V. LTDA - 0014"})
	aAdd(aDADOS,{"78575149","0017","RJU COM. E BENEF DE FRUTAS E VERDURAS LT"})
	aAdd(aDADOS,{"78575149","0018","RJU COM E BENEF DE FRUTAS VERDURAS LTDA"})
	aAdd(aDADOS,{"78575149","0019","RJU COM E BENEF DE FRUTAS VERDURAS LTDA"})
 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())	

dbSelectArea("SB1")
dbSetOrder(1)
dbGoTop()
While !SB1->(EOF())
	For nIND := 1 to Len(aDADOS)	
		If RecLock("Z33",.T.)
			Z33->Z33_FILIAL := xFilial("Z33")
			Z33->Z33_PRODUT := SB1->B1_COD
			Z33->Z33_FORNEC := aDADOS[nIND,01]
			Z33->Z33_LOJA   := aDADOS[nIND,02]
			Z33->Z33_NOME   := aDADOS[nIND,03]			
			Z33->(MsUnLock())
		EndIf	                
	Next nIND
	SB1->(dbSkip())
Enddo
	   
Alert("Processo concluido")

Return  