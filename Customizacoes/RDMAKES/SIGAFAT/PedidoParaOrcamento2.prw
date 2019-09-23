#Include "PROTHEUS.CH"
#Include "rwmake.ch"

User Function RJLOJP03()
************************
Local cPerg         := "RJLOJP03X1"
Local cArqLog       := Lower( "RJLOJP03_" + StrTran( DTOC( Date() ), "/", "" ) + "_" + StrTran( Time(), ":", "" ) + ".log" )
Local aSize         := MsAdvSize()
Local aObjects      := {}
Local aInfo         := {}
Local aPosObj       := {}
Local aSLQ          := {}
Local aSLR          := {}
Local aView         := {}
Local nOption       := 0
Local nModuloOrg    := nModulo

Private nHldLog		:= 0
Private cIndSC5_1   := ""
Private cMarca	    := GetMark()
Private lInverte    := .F.
Private cAliasSC5   := ""
Private nItensSel   := 0         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1( cPerg )

If Pergunte( cPerg, .T. )
	
	cAliasSC5 := GetNextAlias()
	
	MsgRun( "Buscando Pedidos de Vendas...", "Aguarde...", {|| aView := RJLOJP03C5( cPerg, @cAliasSC5  ) } )

	AAdd( aObjects, { 315, 100, .T., .T. } )
	
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ],1, 1 }
	aPosObj := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE DIALOG oDlgPed TITLE " Pedidos de Venda " FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] of oMainWnd PIXEL
	oMS                      := MsSelect():New( cAliasSC5, "C5_OK", , aView , @lInverte, @cMarca, { aPosObj[ 1 ][ 1 ] +10,aPosObj[ 1 ][ 2 ]+4,aPosObj[ 1 ][ 3 ] - 5,aPosObj[ 1 ][ 4 ] } ,,, oDlgPed,, )
	oMS:bMark                := { || RJLOJP3MK1( ), ObjectMethod( oMS:oBrowse,"Refresh()" ) }
	oMS:oBrowse:bAllMark     := { || RJLOJP3MKL( ), ObjectMethod( oMS:oBrowse,"Refresh()" ) }
	oMS:oBrowse:lHasMark     := .T.
	oMS:oBrowse:lCanAllMark  := .T.
	ObjectMethod( oMS:oBrowse, "Refresh()" )
	
	ACTIVATE DIALOG  oDlgPed CENTERED ON INIT ;
	                ( EnchoiceBar( oDlgPed, { || iif( nItensSel == 0, ( Alert( "Selecione algum pedido para prosseguir..." ), .F. ),  ;
	                                             iif( MsgYesNo( "Deseja exportar os itens selecionados (" + Alltrim( Str( nItensSel ) ) + " Pedidos) ?", "Atenção" ), ;
	                                             ( nHldLog :=  fCreate( cArqLog ), Processa( {|| RJLOJP03GO( cAliasSC5 ) }, "Aguarde...", "Efetuando exportação dos pedidos selecionados...",.F.), ;
	                                             fClose( nHldLog ), oDlgPed:End() ), .F. ) ) },{|| oDlgPed:End() } ), ( CursorArrow(), SysRefresh() ) )
	
	dBSelectArea( cAliasSC5 )
	( cAliasSC5 )->( dBSetIndex( cIndSC5_1 ) )
	( cAliasSC5 )->( dBClearIndex() )
	
	
	fErase( cIndSC5_1 + OrdBagExt() )
		
Endif

nModulo := nModuloOrg

Return( .T. )


Static Function RJLOJP03C5( pcPerg, pcAlias )
*********************************************
Local hEnter    := Chr( 13 )
Local lOk       := .F.
Local cQuery    := ""
Local cFields   := ""
Local cTabTMP2  := ""
Local lFirst    := .T.
Local lShare    := .T.
Local lReadOnly := .F.
Local aView     := {}
Local aStruct   := {}
Local lAdd      := .F.
Local nTamOK    := 0
Local cAliasSQL := pcAlias
Local cAliasTMP := GetNextAlias()

If Select( cAliasSQL ) > 0
	( cAliasSQL )->( dBCloseArea( ) )
Endif

If Select( cAliasTMP ) > 0
	( cAliasTMP )->( dBCloseArea( ) )
Endif

Pergunte( pcPerg, .F. )

dBSelectArea( "SX3" )
SX3->( dBSetOrder( 2 ) )
SX3->( dBGoTop() )
SX3->( MsSeek( "C5_OK" ) )
aAdd( aView  , { SX3->X3_CAMPO, ""          , ""                 , SX3->X3_PICTURE } )
aAdd( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO    , SX3->X3_DECIMAL } )
nTamOK := SX3->X3_TAMANHO

SX3->( dBSetOrder( 1 ) )
SX3->( dBGoTop() )
SX3->( dBSeek( "SC5" ) )
While !SX3->( Eof() ) .And. SX3->X3_ARQUIVO == "SC5"
	lAdd := .F.
	If ( ( X3Uso( SX3->X3_USADO ) .AND. ( cNivel >= SX3->X3_NIVEL ) .AND. ( SX3->X3_BROWSE == "S" ) ) )// .And. ( SX3->X3_CONTEXT == "R" .OR. SX3->X3_CONTEXT == " " ) ) )
		lAdd := .T.
		aAdd( aView  , { SX3->X3_CAMPO, ""          , AllTrim(X3Titulo()), SX3->X3_PICTURE } )
		aAdd( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO    , SX3->X3_DECIMAL } )
	Else
		If Alltrim( SX3->X3_CAMPO ) == "C5_EMISSAO"
			lAdd := .T.
			aAdd( aStruct, { SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL } )
		Endif
	Endif
	
	If lAdd
		
		If lFirst
			cFields += "SC5." + SX3->X3_CAMPO
			lFirst  := .F.
		Else
			cFields += "," + hEnter + "           SC5." + SX3->X3_CAMPO
		Endif
		
	Endif
	
	SX3->( dBSkip() )

Enddo

aAdd( aStruct, { "SC5RECNO", "N", 14, 0 } )
cFields += "," + hEnter + "           SC5.R_E_C_N_O_ SC5RECNO"

cQuery := "   SELECT '" + Space( nTamOK ) + "' C5_OK,      " + hEnter
cQuery += "           " + cFields + hEnter
cQuery += "     FROM  " + RetSqlName( "SC5" ) + " SC5 " + hEnter
cQuery += "    WHERE SC5.C5_FILIAL                       = '" + xFilial( "SC5" ) + "'" + hEnter
cQuery += "      AND SC5.C5_NOTA                         = '" + Space( TamSX3( 'C5_NOTA' )[ 1 ] ) + "'" + hEnter
cQuery += "      AND UPPER(SUBSTR(SC5.C5_MENNOTA, 1, 5)) = 'CUPOM'" + hEnter
cQuery += "      AND ( ( SC5.C5_EMISSAO                 >= '" + DTOS( MV_PAR01 ) + "' ) And ( SC5.C5_EMISSAO <= '" + DTOS( MV_PAR02 ) + "') )" + hEnter
cQuery += "      AND ( ( SC5.C5_VEND1                   >= '" + MV_PAR03         + "' ) And ( SC5.C5_VEND1   <= '" + MV_PAR04         + "') )" + hEnter
cQuery += "      AND SC5.C5_TIPO                    NOT IN ('D','B')" + hEnter
cQuery += "      AND SC5.D_E_L_E_T_                     <> '*'" + hEnter

cQuery += " ORDER BY SC5.C5_EMISSAO, SC5.C5_CLIENTE, SC5.C5_LOJACLI, SC5.C5_NUM" + hEnter

dBUseArea( .T., "TOPCONN", TcGenQry(,,ChangeQuery( cQuery ) ), cAliasSQL, .T., .T. )

For nX := 1 To Len( aStruct )
	If aStruct[ nX ][ 2 ] <> "C" .And. FieldPos( aStruct[ nX ][ 1 ] ) <> 0
		TcSetField( cAliasSQL, aStruct[ nX ][ 1 ], aStruct[ nX ][ 2 ], aStruct[ nX ][ 3 ], aStruct[ nX ][ 4 ] )
	EndIf
Next nX                                         

cTabTMP2   := CriaTrab( aStruct, .T. )
cIndSC5_1  := CriaTrab( , .F. )

dBUseArea( .T.,, cTabTMP2, cAliasTMP, lShare, lReadOnly )

( cAliasSQL )->( dBGoTop() )
While !( cAliasSQL )->( Eof() )
	RecLock( cAliasTMP, .T. )

	For nI := 1 To ( cAliasSQL )->( FCount() )
		( cAliasTMP )->( FieldPut( nI, ( cAliasSQL )->&( FieldName( nI ) ) ) )
	Next

	( cAliasTMP )->( MsUnlock() )

	( cAliasSQL )->( dBSkip() )
Enddo

pcAlias := cAliasTMP

IndRegua( pcAlias, cIndSC5_1,"DTOS( C5_EMISSAO ) + C5_CLIENTE + C5_LOJACLI + C5_NUM" )

( pcAlias )->( dBClearIndex( ) )
( pcAlias )->( dbSetIndex( cIndSC5_1 + OrdBagExt() ) )

( pcAlias )->( dBGoTop( ) )

Return( aView )


Static Function fGravaLog( cTexto )                                                       
***********************************
Local cSTR := TIME() + " - " + cTexto + CHR( 13 ) + CHR( 10 )

fWrite( nHldLog, cSTR, Len( cSTR ) )

Return


Static Function AjustaSX1( cPerg )
**********************************
Local aRegs  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd( aRegs,{ cPerg, "01","Emissao de ?   ","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""    } )
aAdd( aRegs,{ cPerg, "02","Emissao ate ?  ","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""    } )
aAdd( aRegs,{ cPerg, "03","Vendedor de ?  ","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","" } )
aAdd( aRegs,{ cPerg, "04","Vendedor ate ? ","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","" } )


dBSelectArea( "SX1" )
SX1->( dbSetOrder(1) )

For i := 1 To Len( aRegs )
	SX1->( dBGoTop() )
	
	If !SX1->( dBSeek( cPerg + aRegs[ i ][ 2 ] ) )
		RecLock( "SX1", .T. )
		For j := 1 to SX1->( FCount() )
			If j <= Len( aRegs[ i ] )
				SX1->( FieldPut( j, aRegs[ i ][ j ] ) )
			Endif
		Next
		SX1->( MsUnlock() )
	Endif
	
Next

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RJLOJP3MK1 º Autor ³ Lincoln Rossetto  º Data ³ 13/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável marcar/desmarcar os itens do pedido      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FAT005Z                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RJLOJP3MK1(  )
******************************
Local aArea := ( cAliasSC5 )->( GetArea( ) )

RecLock ( cAliasSC5, .F. )

If IsMark( "C5_OK", cMarca, lInverte )
   ( cAliasSC5 )->C5_OK := cMarca
   nItensSel++
Else
   ( cAliasSC5 )->C5_OK := Space( TamSX3( "C5_OK" )[1] )
   nItensSel--
EndIf 

( cAliasSC5 )->( MsUnLock() )
ObjectMethod( oMS:oBrowse, "Refresh()" )
           
RestArea( aArea )

Return( .T. )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RJLOJP3MKL º Autor ³ Lincoln Rossetto  º Data ³ 13/05/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável marcar/desmarcar todos os itens do pedidoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FAT005Z                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RJLOJP3MKL(  )
******************************
Local aArea   := ( cAliasSC5 )->( GetArea( ) )
Local nRegAtu := ( cAliasSC5 )->( RecNo( ) )

( cAliasSC5 )->( dBGoTop( ) )
If !( cAliasSC5 )->( Eof() ) .And. !( cAliasSC5 )->( Bof() )

	While !( cAliasSC5 )->( Eof( ) )
		RecLock ( cAliasSC5, .F. )
		If Empty( ( cAliasSC5 )->C5_OK )
			( cAliasSC5 )->C5_OK := cMarca
			nItensSel++
		else
			( cAliasSC5 )->C5_OK := Space( TamSX3( "C5_OK" )[1] )
			nItensSel--
		EndIf
		( cAliasSC5 )->( MsUnLock ( ) )
		( cAliasSC5 )->( dBSkip( ) )
	Enddo

EndIf 

( cAliasSC5 )->( dBGoto ( nRegAtu ) )

ObjectMethod( oMS:oBrowse,"Refresh()" )

RestArea( aArea )

Return( .T. )


Static Function RJLOJP03GO( cAliasSC5 )		
***************************************
Local cNumDAV     := Space( TamSX3( "L1_NUMORC" )[ 1 ] )
Local cNumOrc     := Space( TamSX3( "L1_NUM"    )[ 1 ] )
Local cCondicao   := "!Empty( C5_OK )"
Local aLog        := {}
Local aSLQ        := {}
Local aSLR        := {}
Local aSL4        := {}
Local lOk         := .F.
Local oOK         := LoadBitmap( GetResources(), 'CHECKED'   )
Local oNO         := LoadBitmap( GetResources(), 'NOCHECKED' )
Local aObjects    := {}
Local aInfo       := {}
Local aPosObj     := {}
Local aLinDet     := {}
Local aCabTit     := { "", "Pedido", "Emissão", "Cliente", "Loja" }
Local aLenTits    := { 12, 30      , 35       , 35       , 20     }
Local lFlag       := .T.
Local lFirst      := .T.
Local aSize       := MsAdvSize( , .F. , 430 )


Private lMsHelpAuto := .T. // Variavel de controle interno do ExecAuto
Private lMsErroAuto := .F. // Variavel que informa a ocorrência de erros no ExecAuto
Private INCLUI      := .T. // Variavel necessária para o ExecAuto identificar que se trata de uma inclusão
Private ALTERA      := .F. // Variavel necessária para o ExecAuto identificar que se trata de uma inclusão//Indica inclusão

lMsHelpAuto         := .T.
lMsErroAuto         := .F.

nModulo := 12	//--SIGALOJA

( cAliasSC5 )->( dBGoTop() )

ProcRegua( nItensSel )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa os procedimentos de inclusão do orçamento\atendimento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Begin Transaction
	
	( cAliasSC5 )->( dBSetFilter( { ||&( cCondicao ) }, cCondicao ) )
	( cAliasSC5 )->( dBGoTop() )
	
	While !( cAliasSC5 )->( Eof() )
	
		If !Empty( ( cAliasSC5 )->C5_OK )
		    
			nGoTo   := ( cAliasSC5 )->SC5RECNO
			
			dBSelectArea( "SC5" )
			SC5->( dBSetOrder( 1 ) )
			SC5->( dBGoTo( nGoTo ) )
			
			If ( ( cAliasSC5 )->C5_NUM  == SC5->C5_NUM )
			
				cNumOrc := GETSXENUM( "SL1", "L1_NUM"    )
				cNumDAV := GETSXENUM( "SL1", "L1_NUMORC" )
				aSLQ    := {}
				aSLR    := {}
				aSL4    := {}
				
				dBSelectArea( "SL1" )
				SL1->( dBSetOrder( 13 ) )
				SL1->( dBGoTop() )
				While SL1->( dBSeek( xFilial( "SL1" ) + "P" + cNumDAV ) )
					cNumDAV := GetSxENum( "SL1", "L1_NUMORC" )
					SL1->( dBGoTop() )
				Enddo

				dBSelectArea( "SL1" )
				SL1->( dBSetOrder( 1 ) )
				SL1->( dBGoTop() )
				While SL1->( dBSeek( xFilial( "SL1" ) + cNumOrc ) )
					cNumOrc := GetSxENum( "SL1", "L1_NUM" )
					SL1->( dBGoTop() )
				Enddo

				SL1->( dBGoTop() )

				dBSelectArea( "SA1" )
				SA1->( dBSetOrder(1) ) 
				SA1->( dBGoTop() )
				SA1->( dBSeek( xFilial( "SA1" ) + SC5->C5_CLIENTE + SC5->C5_LOJACLI ) )
				
				aSLQ := { { "L1_FILIAL" , xFilial( "SL1" )                  , Nil },;
				          { "L1_EMISSAO", SC5->C5_EMISSAO                   , Nil },;
				          { "L1_NUM"    , cNumOrc                           , Nil },;
				          { "L1_NUMORC" , cNumDAV                           , Nil },;
				          { "L1_TPORC"  , "P"                               , Nil },;
				          { "L1_COMIS"  , SC5->C5_COMIS1                    , Nil },;
				          { "L1_VEND2"  , SC5->C5_VEND2                     , Nil },;
				          { "L1_VEND3"  , SC5->C5_VEND3                     , Nil },;
				          { "L1_CLIENTE", SC5->C5_CLIENTE                   , Nil },;
				          { "L1_LOJA"   , SC5->C5_LOJACLI                   , Nil },;
				          { "L1_TIPOCLI", SC5->C5_TIPOCLI                   , Nil },;
				          { "L1_DESCONT", SC5->C5_DESCONT + SC5->C5_DESCFI  , Nil },;
				          { "L1_DTLIM"  , dDataBase                         , Nil },;
				          { "L1_CONDPG" , SC5->C5_CONDPAG                   , Nil },;
				          { "L1_CONFVEN", "SSSSSSSSNSSS"                    , Nil },;
				          { "L1_HORA"   , Time()                            , Nil },;
				          { "L1_TPFRET" , SC5->C5_TPFRETE                   , Nil },;
				          { "L1_IMPRIME", "1N"                              , Nil },;
				          { "L1_MOEDA"  , SC5->C5_MOEDA                     , Nil },;
				          { "L1_TXMOEDA", SC5->C5_TXMOEDA                   , Nil },;
				          { "L1_VEND"   , SC5->C5_VEND1                     , Nil },;
				          { "L1_FRETE"  , SC5->C5_FRETE	                    , Nil },;
				          { "L1_SEGURO" , SC5->C5_SEGURO                    , Nil },;
				          { "L1_DESPESA", SC5->C5_DESPESA                   , Nil },;
				          { "L1_X_CLVL" , SC5->C5_X_CLVL                    , Nil }}
				

				dBSelectArea( "SC5" )
				SC6->( dBSetOrder(1) )
				SC6->( dBGoTop() )
				SC6->( MsSeek( xFilial( 'SC6' ) + SC5->C5_NUM ) )
				While !SC6->( Eof() ) .And. ( ( SC6->C6_FILIAL + SC6->C6_NUM ) == ( SC5->C5_FILIAL + SC5->C5_NUM ) )
				
					aAdd( aSLR, { { "L2_FILIAL" ,	xFilial( "SL2" ), Nil },;
					              { "L2_NUM"    ,	cNumOrc         , Nil },;
					              { "L2_ITEM"   ,	SC6->C6_ITEM    , Nil },;
					              { "L2_PRODUTO",	SC6->C6_PRODUTO , Nil },;
					              { "L2_DESCRI" ,	SC6->C6_DESCRI  , Nil },;
					              { "L2_QUANT"  ,	SC6->C6_QTDVEN  , Nil },;
					              { "L2_VRUNIT" ,	SC6->C6_PRCVEN  , Nil },;
					              { "L2_VLRITEM", SC6->C6_VALOR   , Nil },;
					              { "L2_LOCAL"  , SC6->C6_LOCAL   , Nil },;
					              { "L2_UM"     ,	SC6->C6_UM      , Nil },;
					              { "L2_DESC"   , SC6->C6_DESCONT , Nil },;
					              { "L2_VALDESC", SC6->C6_VALDESC , Nil },;
					              { "L2_TES"    ,	SC6->C6_TES     , Nil },;
					              { "L2_CF"     ,	SC6->C6_CF      , Nil },;
					              { "L2_EMISSAO", SC5->C5_EMISSAO , Nil },;
					              { "L2_GRADE"  , "N"             , Nil },;
					              { "L2_VEND"   ,	SC5->C5_VEND1   , Nil },;
					              { "L2_TABELA" ,	SC5->C5_TABELA  , Nil },;
					              { "L2_PRCTAB" , 0               , Nil },;
					              { "L2_LOTECTL", SC6->C6_LOTECTL , Nil }} )
					
					SC6->( dBSkip() )
					
				Enddo

				
				aAdd( aSL4, { { "L4_FILIAL" , xFilial( "SL4" )                          , NIL },;
							  { "L4_NUM"    , cNumOrc	                                , NIL },;
							  { "L4_DATA"   , ddatabase	                                , NIL },;
							  { "L4_FORMA"  , Padr( "R$", TamSX3( "L4_FORMA" )[ 1 ] )   , NIL },;
							  { "L4_ADMINIS", Padr( "R$", TamSX3( "L4_ADMINIS" )[ 1 ] ) , NIL },;
							  { "L4_FORMAID", Padr( "R$", TamSX3( "L4_FORMAID" )[ 1 ] ) , NIL },;
							  { "L4_MOEDA"  , SC5->C5_MOEDA        	         	        , NIL } } )
							
				aSL4 := FWVetByDic( aSL4, "SL4", .T. )
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Executa rotina automática de inclusão do orçamento³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				lGrava := Lj7GrvOrc( aSLQ, aSLR, aSL4, .T., .F. )[1]
				
				If !lGrava
					RollBackSx8()
					DISARMTRANSACTION()
					fGravaLog( "ERRO na gravação do orçamento: "+MostraErro() )
					conout( "ERRO na gravação do orçamento: "+MostraErro() )
					aAdd( aLog, { "X", SC5->C5_NUM, DTOC( SC5->C5_EMISSAO ), SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Erro na gravação do orçamento" } )
				Else
					ConfirmSx8()
					fGravaLog( "Orçamento gravado com sucesso! Número: "+cNumOrc )
					conout( "Orçamento gravado com sucesso! Número: "+cNumOrc )
					aAdd( aLog, { "!", SC5->C5_NUM, DTOC( SC5->C5_EMISSAO ), SC5->C5_CLIENTE, SC5->C5_LOJACLI, "Orçamento gravado com sucesso!" } )
					MsgRun( "Excluindo pedido...","", {|| RJLOJP03DL() } )
				Endif
				
			Else
				
				aAdd( aLog, { ( cAliasSC5 )->C5_NUM, "X", "Não Encontrado" } )
				
			Endif
			
		Endif
		
		IncProc()
		( cAliasSC5 )->( dBSkip() )
	Enddo
	
	For nX := 1 To Len( aLog )
		lFlag := .T.
		
		If aLog[ nX ][ 1 ] == "X"
			lFlag := .F.
		Endif

		aAdd( aLinDet, { lFlag           ,;
		                 aLog[ nX ][ 2 ] ,;
		                 aLog[ nX ][ 3 ] ,;
		                 aLog[ nX ][ 4 ] ,;
		                 aLog[ nX ][ 5 ] ,;
		                 aLog[ nX ][ 6 ] } )
	Next

	aSize[ 1 ] /= 1.9
	aSize[ 2 ] /= 1.9
	aSize[ 3 ] /= 1.9
	aSize[ 4 ] /= 1.9
	aSize[ 5 ] /= 1.9
	aSize[ 6 ] /= 1.9
	aSize[ 7 ] /= 1.9
	
	AAdd( aObjects, { 315,  75, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj  := MsObjSize( aInfo, aObjects,.T.)
	
	DEFINE DIALOG oDlgLog TITLE "Log de geração..." FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL
	
	oBrowse := TWBrowse():New( aPosObj[ 1 ][ 1 ]+5,aPosObj[ 1 ][ 2 ],( oDlgLog:nWidth / 2 ) - 6, ( oDlgLog:nHeight / 2 )  -45,, aCabTit, aLenTits, oDlgLog,,,,,,,,,,,,.F.,,.T.,,.T.,,.T.,.T. )
	
	oBrowse:SetArray( aLinDet )
	oBrowse:bLine      := {|| { If( aLinDet[ oBrowse:nAt ][ 01 ], oOK, oNO ),aLinDet[ oBrowse:nAt ][ 02 ] , ;
	                                aLinDet[ oBrowse:nAt ][ 03 ]                                          , aLinDet[ oBrowse:nAt ][ 04 ] , ;
	                                aLinDet[ oBrowse:nAt ][ 05 ]                                          , aLinDet[ oBrowse:nAt ][ 06 ] } }
	
	oBrowse:bLDblClick := {|| aLinDet[oBrowse:nAt][1] := !aLinDet[oBrowse:nAt][1], oBrowse:DrawSelect()}
	
	
	ACTIVATE DIALOG oDlgLog CENTERED ON INIT ( EnchoiceBar(oDlgLog,{|| ( oDlgLog:End() ) },{|| ( oDlgLog:End() ) } ), ( CursorArrow(), SysRefresh() ) )

	
End Transaction

MsgInfo( "Processo Finalizado!" )

Return( Nil )




Static Function RJLOJP03DL()
****************************

nMCusto :=  If( SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val( SuperGetMv( "MV_MCUSTO" ) ) )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estorna o Item do Pedido de Venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dBSelectArea( "SC6" )
SC6->( dBSetOrder(1) )
SC6->( dBGoTop() )
SC6->( MsSeek( xFilial( "SC6" ) + SC5->C5_NUM ) )
While ( ( SC5->C5_FILIAL + SC5->C5_NUM ) == ( SC6->C6_FILIAL + SC6->C6_NUM ) )

	dBSelectArea( "SF4" )
	SF4->( dBSetOrder( 1 ) )
	SF4->( dBGoTop() )
	SF4->( MsSeek( xFilial( "SF4" ) + SC6->C6_TES ) )

	If ( SF4->F4_ESTOQUE == "S" )
		dBSelectArea( "SB2" )
		SB2->( dBSetOrder(1) )
		SB2->( dBGoTop() )
		
		If SB2->( MsSeek( xFilial( "SB2" ) + SC6->C6_PRODUTO + SC6->C6_LOCAL ) )
			RecLock( "SB2", .F. )
				SB2->B2_QPEDVEN -= (SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE	)
				SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE, 0, 2)				
			SB2->( MsUnLock() )
			
		Endif
		
	EndIf
	
	If ( SF4->F4_DUPLIC == "S" )
		nQtdVen := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
		
		If ( nQtdVen > 0 )
			
			RecLock( "SA1", .F. )
		   		SA1->A1_SALPED -= xMoeda( nQtdVen * SC6->C6_PRCVEN , SC5->C5_MOEDA , nMCusto , SC5->C5_EMISSAO )
			SA1->( MsUnLock() )
			
		EndIf
		
	EndIf
	
	
	dBSelectArea( "SC9" )
	SC9->( dBSetOrder(1) )
	SC9->( dBGoTop() )
	SC9->( MsSeek( xFilial( "SC9" ) + SC6->C6_NUM + SC6->C6_ITEM ) )

	While ( !SC9->( Eof() ) .And. SC9->C9_FILIAL == xFilial( "SC9" ) .And. SC9->C9_PEDIDO == SC6->C6_NUM .And. SC9->C9_ITEM   == SC6->C6_ITEM )

		If ( SC9->C9_BLCRED <> "10"  .And. SC9->C9_BLEST <> "10" )
			Begin Transaction
				a460Estorna(.T.)
			End Transaction
		EndIf

		SC9->( dbSkip() )
	EndDo

	dBSelectArea( "SC6" )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000100","02","MATA410")
	RecLock( "SC6", .F. )
		SC6->( dBDelete() )
	SC6->( MsUnLock() )
	
	SC6->( dbSkip())
	
EndDo

RecLock( "SC5", .F. )
	SC5->( dBDelete() )
SC5->( MsUnLock() )

Return Nil