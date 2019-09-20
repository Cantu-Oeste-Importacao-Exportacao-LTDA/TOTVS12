#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPEREL04 ºAutor  ³TOTVS CASCAVEL       º Data ³  23/04/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório Funcionários x Cestas Básicas.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GPEREL04()
************************
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aSays       := {}
Local aButtons    := {}
Local cArqTxt     := ''

Public ___lRet    := .T.

Private cPerg     := "RJGR4RTPXB"
Private nFaltas13 := 0
Private dDtPesq1  := CTOD( "  /  /  " )
Private dDtPesq2  := CTOD( "  /  /  " )
Private aImp      := {}
Private aTotais   := {}
Private aAbonados := {}
Private nImpHrs   := 0
Private aRetSX1   := {}


Private cCadastro := OemToAnsi( "Funcionários x Cestas Básicas" )   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aAdd( aSays, "Esta rotina tem por objetivo gerar planilha eletrônica EXCEL" )
aAdd( aSays, "de acordo com os parametros informados pelo usuario para de-" )
aAdd( aSays, "monstração de relação de Funcionários x Cestas Básicas"    )
aAdd( aSays, "Conforme parâmetros informados."  )

aRetSX1 := AjustaSX1( cPerg )

aAdd( aButtons, { 1, .T., { || Processa( {|| RunReport( cPerg ) }, "Aguarde...", "Verificando movimentos...",.F.) } } )
aAdd( aButtons, { 5, .T., { || Pergunte( cPerg, .T. ) } } )
aAdd( aButtons, { 2, .T., { |o| o:oWnd:End() } } )

FormBatch( cCadastro, aSays, aButtons ,,,428)

Return

Static Function RunReport( cPerg )
**********************************
Local lShare     := .T.
Local lReadOnly  := .F.
Local cAliasSPC  := GetNextAlias()
Local cAliasSPO  := GetNextAlias()
Local cAliasPrin := GetNextAlias()
Local cAliasFlts := GetNextAlias()
Local cAliasAtrs := GetNextAlias()
Local cAliasFeri := GetNextAlias()
Local cAliasAtes := GetNextAlias()
Local nRecs      := 0
Local dDataD     := CTOD( "  /  /  " )
Local dDataA     := CTOD( "  /  /  " )
Local aDados     := {}
Local cBuffer    := ""
Local cMsg       := ""
Local cOrder     := ""
Local cQuery     := ""
Local cDirDocs   := MsDocPath()
Local cArquivo   := Upper( CriaTrab(, .F.) )
Local cPath	   	 := ALLTRIM( GetTempPath() )
Local nHdl       := 0
Local cFile      := ""
Local cFilialDe  := ""
Local cFilialAte := ""
Local cFuncionDe := ""
Local cFuncionAt := ""
Local cSindicDe  := ""
Local cSindicAt  := ""
Local cPeriodo   := ""
Local cEventFlts := ""
Local cEventAtrs := ""
Local cEventFers := ""
Local cEventAtes := ""
Local nOrdena    := 0
Local cLastFil	 := "__cLastFil__"
Local aPerClose  := {}
Local cPerClose  := ""
Local cHtml		 := ""
Local cAviso	

Local aComplPer		:= {}
Local aAbonosPer	:= {}
Local cFil			:= ""
Local cMat			:= ""
Local cTno			:= ""
Local cLastFil		:= "__cLastFil__"
Local cAcessaSRA	:= &("{ || " + ChkRH("GPEREL04","SRA","2") + "}")
Local cSeq			:= ""
Local cTurno		:= ""
Local cHtml			:= ""
Local lSPJExclu		:= !Empty( xFilial("SPJ") )
Local lSP9Exclu		:= !Empty( xFilial("SP9") )
Local nCount		:= 0.00
Local nX			:= 0.00
Local lMvAbosEve	:= .F.
Local lMvSubAbAp	:= .F.
Local lAfasta       := .F.
Local nTotalRecs    := 0
Local nRecAtu       := 0
Local cAfasta       := ""

Private aFuncFunc  := {SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1), SPACE(1)}		
Private aMarcacoes := {}
Private aTabPadrao := {}
Private aTabCalend := {}
Private aPeriodos  := {}
Private aId		   := {}
Private aBoxSPC	   := LoadX3Box("PC_TPMARCA") 
Private aBoxSPH	   := LoadX3Box("PH_TPMARCA")
Private cHeader    := ""
Private dIniCale   := CTOD( "//" )	//-- Data Inicial a considerar para o Calendario
Private dFimCale   := CTOD( "//" )	//-- Data Final a considerar para o calendario
Private dMarcIni   := CTOD( "//" )	//-- Data Inicial a Considerar para Recuperar as Marcacoes
Private dMarcFim   := CTOD( "//" )	//-- Data Final a Considerar para Recuperar as Marcacoes
Private dIniPonMes := CTOD( "//" )	//-- Data Inicial do Periodo em Aberto 
Private dFimPonMes := CTOD( "//" )	//-- Data Final do Periodo em Aberto 
Private lImpAcum   := .F.
Private cFilSPA	   := xFilial("SPA", SRA->RA_FILIAL)

Pergunte( cPerg, .F. )

FilialDe	:= MV_PAR01 // Filial  De
FilialAte	:= MV_PAR02 // Filial  Ate
TurDe		:= MV_PAR03 // Turno De
TurAte		:= MV_PAR04 // Turno Ate
MatDe		:= MV_PAR05 // Matricula De
MatAte		:= MV_PAR06 // Matricula Ate
cSit		:= MV_PAR07 // Situacao
cCat		:= MV_PAR08 // Categoria
dPerIni     := MV_PAR09 // Data Contendo o Inicio do Periodo de Apontamento
dPerFim     := MV_PAR10 // Data Contendo o Fim  do Periodo de Apontamento
cSindicDe   := MV_PAR11 // Sindicato de
cSindicAt   := MV_PAR12 // Sindicato até
aVrbFaltas  := StrTokArr( MV_PAR13 ,",")
aVrbAtraso  := StrTokArr( MV_PAR14 ,",")
aEvnAtesta  := StrTokArr( MV_PAR15 ,",")
nOrdem      := MV_PAR16 // Ordem de Impressão
nImpHrs		:= 3        // Imprimir horas Calculadas/Inform/Ambas/NA
nImpAut		:= 3        // Demonstrar horas Autoriz/Nao Autorizadas
nCopias		:= 1   	    // N£mero de C¢pias
lSemMarc	:= 2        // Imprime para Funcion rios sem Marca‡oes
lSexagenal	:= .T.     	// Horas em  (Sexagenal/Centesimal)
lImpRes		:= .T.		// Imprime eventos a partir do resultado ?
lImpTroca   := .T.   	// Imprime Descricao Troca de Turnos ou o Atual 
lImpExcecao := .T.		// Imprime Descricao da Excecao no Lugar da do Afastamento 
lTerminal   := .F.

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Como a Cada Periodo Lido reinicializamos as Datas Inicial e Fi³
³nal preservamos-as nas variaveis: dCaleIni e dCaleFim.		   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dIniCale   := dPerIni   //-- Data Inicial a considerar para o Calendario
dFimCale   := dPerFim   //-- Data Final a considerar para o calendario

//-- Correção da conversão das verbas de String para Array 
For nW := 1 To Len( aVrbFaltas )
	aVrbFaltas[ nW ] := Alltrim( StrTran( aVrbFaltas[ nW ], "'", "" ) )
Next

//-- Correção da conversão das verbas de String para Array 
For nW := 1 To Len( aVrbAtraso )
	aVrbAtraso[ nW ] := Alltrim( StrTran( aVrbAtraso[ nW ], "'", "" ) )
Next

//-- Correção da conversão dos eventos de String para Array 
For nW := 1 To Len( aEvnAtesta )
	aEvnAtesta[ nW ] := Alltrim( StrTran( aEvnAtesta[ nW ], "'", "" ) )
Next


Begin Sequence

		If Pn090Open(@cHtml, @cAviso)

			IF Empty( dPerIni ) .or. Empty( dPerFim )
				Help(" ",1,"PONFORAPER" , , OemToAnsi( 'Periodo de Apontamento Invalido.' ) , 5 , 0  )
				Break
			Else
				/*----------------------------------------------------------------------------------------
				INICIO 
				------------------------------------------------------------------------------------------*/
				
				dBSelectArea( 'SRA' )

				For nX := 1 To 2
					
					If nX == 1
						cQuery := "	  SELECT COUNT( SRA.RA_MAT ) RA_TOTALR" + chr(13)
						cOrder := ""
					Else
						cQuery := "	  SELECT SRA.RA_FILIAL, SRA.RA_MAT, RA_NOME, SRA.RA_ADMISSA" + chr(13)
						cOrder := iif( nOrdem == 1,"	ORDER BY SRA.RA_FILIAL, SRA.RA_MAT" + chr(13), "	ORDER BY SRA.RA_FILIAL, SRA.RA_NOME" + chr(13) )
					Endif
					
					cQuery2 := "	    FROM " + RetSQLName( "SRA" ) + " SRA    											            " + chr(13)
					cQuery2 += "	   WHERE ( ( SRA.RA_FILIAL  >= '" + FilialDe  + "' ) AND ( SRA.RA_FILIAL  <= '" + FilialAte + "' ) )" + chr(13)
					cQuery2 += "	     AND ( ( SRA.RA_MAT     >= '" + MatDe + "' ) AND ( SRA.RA_MAT     <= '" + MatAte + "' ) )" + chr(13)
					cQuery2 += "	     AND ( ( SRA.RA_SINDICA >= '" + cSindicDe  + "' ) AND ( SRA.RA_SINDICA <= '" + cSindicAt + "' ) )" + chr(13)
					cQuery2 += "	     AND SRA.RA_MSBLQL      <> '1'" + chr(13)
					cQuery2 += "	     AND SRA.D_E_L_E_T_     <> '*'													                " + chr(13)
					
					If nX == 1
						Memowrite( "GPEREL04_1.SQL", cQuery + cQuery2  )
					Else
						Memowrite( "GPEREL04_2.SQL", cQuery + cQuery2 + cOrder  )
					Endif
					
					If Select( cAliasPrin ) > 0
						( cAliasPrin )->( dBclosearea() )
					Endif
					
					dBUseArea(.T.,"TOPCONN",TcGenQry(,,ChangeQuery( cQuery + cQuery2 + cOrder ) ),cAliasPrin, lShare, lReadOnly )
					
					If nX == 1
						nTotalRecs := ( cAliasPrin )->RA_TOTALR
						ProcRegua( nTotalRecs )
					Endif
					
				Next
				
				cFile     := Upper( cArquivo + ".CSV" )
				cFilToExp := ( cAliasPrin )->RA_FILIAL
				
				While !( cAliasPrin )->( EOF() )
					IncProc( "Analisando funcionário " + Transform( ++nRecAtu, "@E999" ) + "/" + Transform( nTotalRecs, "@E999" ) )
					SysRefresh()
				
					
					SRA->( dBSetOrder( 1 ) )
					SRA->( dBGoTop() )
					SRA->( dBSeek( ( cAliasPrin )->RA_FILIAL + ( cAliasPrin )->RA_MAT ) )
					

					dIniCale   := dPerIni   //-- Data Inicial a considerar para o Calendario
					dFimCale   := dPerFim   //-- Data Final a considerar para o calendario

					//-- #1 ADMISSÃO
					lAdmis  := .F.
					If ( SRA->RA_ADMISSA >= dDataD ) .And. ( SRA->RA_ADMISSA <= dDataA )
						lAdmis := .T.
					Endif
								
///-------------------------------------------------------------------
///-------------------------------------------------------------------
					If !( SRA->RA_FILIAL == cLastFil ) .And. !lAdmis
				
						lMvAbosEve	:= ( Upper(AllTrim(SuperGetMv("MV_ABOSEVE",NIL,"N",cLastFil))) == "S" )	//--Verifica se Deduz as horas abonadas das horas do evento Sem a necessidade de informa o Codigo do Evento no motivo de abono que abona horas
						lMvSubAbAp	:= ( Upper(AllTrim(SuperGetMv("MV_SUBABAP",NIL,"N",cLastFil))) == "S" )	//--Verifica se Quando Abono nao Abonar Horas e Possuir codigo de Evento, se devera Gera-lo em outro evento e abater suas horas das Horas Calculadas
						cLastFil := SRA->RA_FILIAL
						
					    
						/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Carrega periodo de Apontamento Aberto						  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						IF !CheckPonMes( @dPerIni , @dPerFim , .F. , .T. , .F. , cLastFil )
							Exit
						EndIF
				
				    	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Obtem datas do Periodo em Aberto							  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						GetPonMesDat( @dIniPonMes , @dFimPonMes , cLastFil )
						
				    	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Atualiza o Array de Informa‡”es sobre a Empresa.			  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						aInfo := {}
						fInfo( @aInfo , cLastFil )
					
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Carrega as Tabelas de Horario Padrao						  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						IF ( lSPJExclu .or. Empty( aTabPadrao ) )
							aTabPadrao := {}
							fTabTurno( @aTabPadrao , IF( lSPJExclu , cLastFil , NIL ) )
						EndIF
				
				    	/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Carrega TODOS os Eventos da Filial						  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						IF ( Empty( aId ) .or. ( lSP9Exclu ) )
							aId := {}
							CarId( fFilFunc("SP9") , @aId , "*" )
						EndIF
				
					EndIF
				
				   	/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Retorna Periodos de Apontamentos Selecionados				  ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					aPeriodos := Monta_per( dIniCale , dFimCale , cLastFil , SRA->RA_MAT , dPerIni , dPerFim )
				
				   	/*
					ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					³Corre Todos os Periodos 									  ³
					ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
					naPeriodos := Len( aPeriodos )
					For nX := 1 To naPeriodos
				
				   		/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Reinicializa as Datas Inicial e Final a cada Periodo Lido.	  ³
						³Os Valores de dPerIni e dPerFim foram preservados nas   varia³
						³veis: dCaleIni e dCaleFim.									  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				        dPerIni		:= aPeriodos[ nX , 1 ]
				        dPerFim		:= aPeriodos[ nX , 2 ] 
				
				   		/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Obtem as Datas para Recuperacao das Marcacoes				  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
				        dMarcIni	:= aPeriodos[ nX , 3 ]
				        dMarcFim	:= aPeriodos[ nX , 4 ]
				
				   		/*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Verifica se Impressao eh de Acumulado						  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						lImpAcum := ( dPerFim < dIniPonMes )
						   
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Retorna Turno/Sequencia das Marca‡”es Acumuladas			  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						IF ( lImpAcum )
							IF SPF->( dbSeek( SRA->( RA_FILIAL + RA_MAT ) + Dtos( dPerIni) ) ) .and. !Empty(SPF->PF_SEQUEPA)
								cTurno	:= SPF->PF_TURNOPA
								cSeq	:= SPF->PF_SEQUEPA
							Else
					    		/*
								ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								³ Tenta Achar a Sequencia Inicial utilizando RetSeq()³
								ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
								IF !RetSeq(cSeq,@cTurno,dPerIni,dPerFim,dDataBase,aTabPadrao,@cSeq) .or. Empty( cSeq )
					    			/*
									ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									³Tenta Achar a Sequencia Inicial utilizando fQualSeq()		  ³
									ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
									cSeq := fQualSeq( NIL , aTabPadrao , dPerIni , @cTurno )
								EndIF
							EndIF
							/*
							ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							³Obtem Codigo e Descricao da Funcao do Trabalhador na Epoca   ³
							ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/			
							fBuscaCC(dMarcFim, @aFuncFunc[1], @aFuncFunc[2], Nil, .F. , .T.  ) 
							aFuncFunc[2]:= Substr(aFuncFunc[2], 1, 25)
							fBuscaFunc(dMarcFim, @aFuncFunc[3], @aFuncFunc[4],20, @aFuncFunc[5], @aFuncFunc[6],25, .F. )
						Else
				   			/*
							ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							³Considera a Sequencia e Turno do Cadastro            		  ³
							ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
							cTurno	:= SRA->RA_TNOTRAB
							cSeq	:= SRA->RA_SEQTURN  
							/*
							ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							³Obtem Codigo e Descricao da Funcao do Trabalhador     		  ³
							ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/			
							aFuncFunc[1]:= SRA->RA_CC
							aFuncFunc[2]:= DescCc(aFuncFunc[1], SRA->RA_FILIAL, 25)
							aFuncFunc[3]:= SRA->RA_CODFUNC 
							aFuncFunc[4]:= DescFun(SRA->RA_CODFUNC , SRA->RA_FILIAL)
							aFuncFunc[6]:= DescCateg(SRA->RA_CATFUNC , 25)
						EndIF
					
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Carrega Arrays com as Marca‡”es do Periodo (aMarcacoes), com³
						³o Calendario de Marca‡”es do Periodo (aTabCalend) e com    as³	
						³Trocas de Turno do Funcionario (aTurnos)					  ³	
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						( aMarcacoes := {} , aTabCalend := {} , aTurnos := {} )   
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³ Importante: 												  ³
						³ O periodo fornecido abaixo para recuperar as marcacoes   cor³
						³ respondente ao periodo de apontamentoo Calendario de 	 Marca³	
						³ ‡”es do Periodo ( aTabCalend ) e com  as Trocas de Turno  do³	
						³ Funcionario ( aTurnos ) integral afim de criar o  calendario³	
						³ com as ordens correspondentes as gravadas nas marcacoes	  ³	
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						lMarcacoes := GetMarcacoes(	@aMarcacoes					,;	//Marcacoes dos Funcionarios
													@aTabCalend					,;	//Calendario de Marcacoes
													@aTabPadrao					,;	//Tabela Padrao
													@aTurnos					,;	//Turnos de Trabalho
													dPerIni 					,;	//Periodo Inicial
													dPerFim						,;	//Periodo Final
													SRA->RA_FILIAL				,;	//Filial
													SRA->RA_MAT					,;	//Matricula
													cTurno						,;	//Turno
													cSeq						,;	//Sequencia de Turno
													SRA->RA_CC					,;	//Centro de Custo
													IF(lImpAcum,"SPG","SP8")	,;	//Alias para Carga das Marcacoes
													NIL							,;	//Se carrega Recno em aMarcacoes
													.T.							,;	//Se considera Apenas Ordenadas
												    .T.    						,;	//Se Verifica as Folgas Automaticas
												  	.F.    			 			 ;	//Se Grava Evento de Folga Automatica Periodo Anterior
													 )
						IF !lMarcacoes
							Loop
						EndIF					 
					   
					    aPrtTurn:={}
					    Aeval(aTurnos, {|x| If( x[2] >= dPerIni .AND. x[2]<= dPerFim, Aadd(aPrtTurn, x),Nil )} ) 

					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Reinicializa Variaveis										  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						aImp      := {}
						aTotais   := {}
						aAbonados := {}
						lAfasta   := .F.
						cAfasta   := ""
				
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Carrega os Abonos Conforme Periodo       					  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						fAbonosPer( @aAbonosPer , dPerIni , dPerFim , cLastFil , SRA->RA_MAT )
				
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Carrega os Totais de Horas e Abonos.						  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						CarAboTot( @aTotais , @aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp )
					
					    /*
						ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						³Carrega o Array a ser utilizado na Impress„o.				  ³
						ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
						GetMovPto( aTabCalend, aMarcacoes, @aImp, dMarcIni, dMarcFim,  lTerminal, @lAfasta, @cAfasta )
						
					Next nX
					
					lFalta  := .F.
					lAtraso := .F.
					lFerias := .F.
					nFaltas := 0
					nAtesIn := 0
					nTotAtr := 0

					//-- #1 ADMISSÃO 
					//-- verificação das situaçãoes caso o funcionário não tenha sido admitido dentro do período analisado !
					If !lAdmis

					    //-- #2 FALTAS  => POR VERBA - aVrbFaltas  := StrTokArr( MV_PAR13 ,",")
					    For nX := 1 To Len( aTotais )
					    	nPosVrba := aScan( aVrbFaltas, Alltrim( aTotais[ nX ][ 1 ] ) )
                            If nPosVrba > 0
                            	If !lFalta
                            		lFalta := .T.
                            	Endif
                            	nFaltas += aTotais[ nX ][ 3 ]
                            Endif
                            	
					    Next
					
					    //-- #3 ATRASOS/SAÍDAS => POR VERBA - aVrbAtraso  := StrTokArr( MV_PAR14 ,",")
					    For nX := 1 To Len( aTotais )
					    	nPosVrba := aScan( aVrbAtraso, Alltrim( aTotais[ nX ][ 1 ] ) )
                            If nPosVrba > 0
                            	If !lAtraso
                            		lAtraso := .T.
                            	Endif
                            	nTotAtr += aTotais[ nX ][ 3 ]
                            Endif

					    Next
					    
					    //-- #4 FÉRIAS
						For nX := 1 To Len( aImp )
							If Alltrim( aImp[ nX ][ 3 ] ) == "FERIAS"
								If !lFerias
									lFerias := .T.
								Endif
							Endif
						Next				

					    //-- #5 ATESTADOS => POR EVENTO - aEvnAtesta  := StrTokArr( MV_PAR15 ,",")
					    For nX := 1 To Len( aAbonados )
					    	nPosEven := aScan( aEvnAtesta, Alltrim( aAbonados[ nX ][ 5 ] ) )
                            If nPosEven > 0
                            	nAtesIn++
                            Endif

					    Next
					    
					Endif

					cAux := ""	
					
					If Alltrim( cAfasta ) <> "T - TRANSFERIDO"
						aAdd( aDados, { "'" + SRA->RA_FILIAL                                                                                        ,;
										"'" + SRA->RA_MAT                                                                                           ,;
										SRA->RA_NOME                                                                                                ,;
										DTOC( SRA->RA_ADMISSA                                                                                       ),;
										/*#1 ADMISSÃO    */iif( lAdmis     , "Sim"    , "Não"                                                     ),;
										/*#2 FALTAS      */iif( nFaltas > 0, "Sim -> ", "Não -> " ) + Alltrim( Transform( nFaltas, "@E 999"     ) ),;
										/*#3 ATRASOS     */iif( lAtraso    , "Sim -> ", "Não -> " ) + Alltrim( Transform( nTotAtr, "@E 99.99"   ) ),;
										/*#4 FÉRIAS      */iif( lFerias    , "Sim"    , "Não"                                                     ),;
										/*#5 ATESTADOS   */iif( nAtesIn > 0, "Sim -> ", "Não -> " ) + Alltrim( Transform( nAtesIn, "@E 999"     ) ),;
										/*#6 AFASTAMENTO */iif( lAfasta    , "Sim"    , "Não"                                                     ),;
										/*#7 OBSERVAÇÕES*/ + cAfasta                                                                                } ) 
										
				  Endif
				  
					( cAliasPrin )->( dBSkip() )
				
///-------------------------------------------------------------------
///-------------------------------------------------------------------
					If cFilToExp <> ( cAliasPrin )->RA_FILIAL
						cFilToExp := ( cAliasPrin )->RA_FILIAL
						aAdd( aDados, { " " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " ,;
										" " } )
					Endif
					
				EndDo
				
			EndIf
	
		Else                        
		
			MsgStop( cHtml, cAviso )
			cHtml := ""
		EndIf
	
	
End Sequence

If Select( cAliasFeri ) > 0
	( cAliasFeri )->( dBclosearea() )
Endif

If Len( aDados ) == 0
	Alert( "Não foram encontrados movimentos para o Período/Filial informados !" )
	
Else
	
	ProcRegua( Len( aDados ) + 1 )
	
	nHdl := MsfCreate( cDirDocs + "\" + cFile , 0 )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Inicia cabeçalho do relatório                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cBuffer := ""
	cBuffer += ToXlsFormat( "FUNCIONARIOS X CESTAS BASICAS" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += CHR(13) + CHR(10)
	
	FWrite(nHdl, cBuffer)
	cBuffer := ""
	cBuffer += ToXlsFormat( Upper( Alltrim( SM0->M0_NOMECOM ) ) ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += CHR(13) + CHR(10)
	
	FWrite(nHdl, cBuffer)
	cBuffer := ""
	cBuffer += ToXlsFormat( "PERIODO: " +  DTOC( dPerIni ) + " A " + DTOC( dPerFim ) ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += CHR(13) + CHR(10)
	
	FWrite(nHdl, cBuffer)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Inicia montagem das regras para a realização da integração³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cBuffer := ""
	cBuffer += ToXlsFormat( "FILIAL"          ) + ";" /*01*/
	cBuffer += ToXlsFormat( "MATRICULA"       ) + ";" /*02*/
	cBuffer += ToXlsFormat( "NOME"            ) + ";" /*03*/
	cBuffer += ToXlsFormat( "ADMISSÃO"        ) + ";" /*04*/
	cBuffer += ToXlsFormat( "FORA DO PERÍODO" ) + ";" /*05 #1 ADMISSÃO    */
	cBuffer += ToXlsFormat( "FALTAS"          ) + ";" /*06 #2 FALTAS      */
	cBuffer += ToXlsFormat( "ATRASOS"         ) + ";" /*07 #3 ATRASOS     */
	cBuffer += ToXlsFormat( "FÉRIAS"          ) + ";" /*08 #4 FÉRIAS      */
	cBuffer += ToXlsFormat( "ATESTADOS"       ) + ";" /*09 #5 ATESTADOS   */
	cBuffer += ToXlsFormat( "AFASTAMENTOS"    ) + ";" /*10 #6 AFASTAMENTO */
	cBuffer += ToXlsFormat( "OBSERVAÇÕES"     ) + ";" /*10 #7 OBSERVAÇÕES */
	cBuffer += CHR(13) + CHR(10)
	
	FWrite(nHdl, cBuffer)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Efetua a carga das informações do array no buffer temporário para integração³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	For nI := 1 to Len( aDados )
		
		cBuffer := ""
		cBuffer += ToXlsFormat( aDados[ nI ][ 01 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 02 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 03 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 04 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 05 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 06 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 07 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 08 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 09 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 10 ] ) + ";"
		cBuffer += ToXlsFormat( aDados[ nI ][ 11 ] ) + ";"
		cBuffer += CHR(13) + CHR(10)
		
		FWrite(nHdl,cBuffer)
		
		IncProc( "Montando arquivo para exibição/edição..." )
		
	Next nI
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Parâmetros ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄ
	cBuffer := ""
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += ToXlsFormat( "" ) + ";"
	cBuffer += CHR(13) + CHR(10)                           
	FWrite(nHdl, cBuffer)
	
	cBuffer := ""
	cBuffer += ToXlsFormat( "Parâmetros"            ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += ToXlsFormat( ""                      ) + ";"
	cBuffer += CHR(13) + CHR(10)                           
	FWrite(nHdl, cBuffer)	                               
	
	For nX := 1 To Len( aRetSX1 ) 

		xValorPar := ""
		
		Do Case
			Case aRetSX1[ nX ][ 2 ] == "N"
				xValorPar := "'" + Alltrim( Str( &( aRetSX1[ nX ][ 3 ] ) ) )
				
			Case aRetSX1[ nX ][ 2 ] == "D"
				xValorPar := DTOC( &( aRetSX1[ nX ][ 3 ] ) )
				
			OtherWise
				xValorPar := "'" + &( aRetSX1[ nX ][ 3 ] )
		EndCase
		
		cBuffer := ""
		cBuffer += ToXlsFormat( aRetSX1[ nX ][ 1 ]      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( xValorPar               ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += ToXlsFormat( ""                      ) + ";"
		cBuffer += CHR(13) + CHR(10)                           
		FWrite(nHdl, cBuffer)	
		
	Next
	
	fClose(nHdl)
	
	lResult := .F.
	cPathTo := cGetFile( "","Selecione o local p/ gravar o arquivo...",0,"",.F.,GETF_RETDIRECTORY+GETF_LOCALHARD+GETF_OVERWRITEPROMPT)
	
	If !Empty( cPathTo )
		lResult  := CpyS2T( cDirDocs + "\" + cFile, cPathTo, .T. )
	Endif
	
	IncProc()
	
	If lResult
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Realiza a integração do arquivo temporário com a ferramenta³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If MsgYesNo( "Arquivo gerado com sucesso em: " + cPathTo + Chr( 13 ) +  "Deseja editá-lo com o Excel ?!", "Atenção" )
			
			If !ApOleClient( 'MsExcel' )
				MsgAlert( 'MsExcel não instalado, impossível prosseguir com a edição do arquivo !')
			Else
				oExcelApp := MsExcel():New()
				oExcelApp:WorkBooks:Open( ( cPathTo + cFile ) )
				oExcelApp:SetVisible(.T.)
			EndIf
			
		Endif
		
	Else                    
	
		If !Empty( cPathTo )
			MsgAlert( 'Falha na montagem do arquivo !' )
		Endif
		
	Endif
	
Endif

Return



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ GPER04V1 ºAutor  ³TOTVS CASCAVEL      º Data ³  23/04/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPER04V1()
************************
Local cDataSX1 := ""
Local nDataSX1 := 0
Local lRet     := .T.
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !Empty( &( Readvar() ) )
	
	cDataSX1 := Substr( &( Readvar() ), 1, 2 )
	nDataSX1 := Val( cDataSX1 )
	
	If !( ( nDataSX1 >= 1 ) .And. ( nDataSX1 <= 12 ) )
		lRet := .F.
	Else
		cDataSX1 := Substr( &( Readvar() ), 3, 4 )
		cDataSX1 := Alltrim( cDataSX1 )
		
		If Len( cDataSX1 ) < 4
			lRet := .F.
		Endif
		
	Endif
	
	If !lRet
		Aviso( "Atenção", "Período informado é inválido", { "OK " } )
	Endif
	
Endif

Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ GPER04V2 ºAutor  ³TOTVS CASCAVEL      º Data ³  23/04/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function GPER04V2( pcQual )
********************************
Local oOK            := LoadBitmap( GetResources(), 'LBTIK' )
Local oNO            := LoadBitmap( GetResources(), 'LBNO'   )
Local aObjects       := {}
Local aInfo          := {}
Local aPosObj        := {}
Local aLinDet        := {}
Local aCond          := {}
Local aCabTit        := { "", "Código", "Descrição" }
Local aLenTits       := { 12, 30      , 75         }
Local lFlag          := .F.
Local aSize          := MsAdvSize( , .F. , 430 )
Local nOption        := 2
Local cAux           := Space( 99 )
Local aAux           := StrTran( Alltrim( &( Readvar() ) ), "'", "" )
Local aSelects       := StrTokArr( aAux, "," )
Local cCampoCod      := ""
Local cCampoDes      := ""
Local cChave         := ""
Local oDlgConsP

Default pcQual       := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For nX := 1 To Len( aSelects )
	aSelects[ nX ] := Alltrim( aSelects[ nX ] )
Next

If !Empty( pcQual )
	
	Do Case
		Case pcQual == "SP6"
			cCampoCod := "P6_CODIGO"
			cCampoDes := "P6_DESC"
			cChave    := xFilial( "SP6" )
			aCond     := { || xFilial( "SP6" ) == SP6->P6_FILIAL }
			
			
		Case pcQual == "SP9"
			cCampoCod := "P9_CODIGO"
			cCampoDes := "P9_DESC"
			cChave    := xFilial( "SP9" )
			aCond     := { || xFilial( "SP9" ) == SP9->P9_FILIAL }
			
		Case pcQual == "SRV"
			cCampoCod := "RV_COD"
			cCampoDes := "RV_DESC"
			cChave    := xFilial( "SRV" )
			aCond     := { || xFilial( "SRV" ) == SRV->RV_FILIAL }
			
			
		Case pcQual == "SX5"
			cCampoCod := "X5_CHAVE"
			cCampoDes := "X5_DESCRI"
			cChave    := xFilial( "SX5" ) + "30"
			aCond     := { || xFilial( "SX5" ) == SX5->X5_FILIAL .And. SX5->X5_TABELA == "30" }
			
	EndCase
	
	dBSelectArea( pcQual )
	( pcQual )->( dBSetorder( 1 ) )
	( pcQual )->( dBGoTop() )
	( pcQual )->( MsSeek( cChave ) )
	
	While !( pcQual )->( Eof() ) .And. Eval( aCond )
		
		nPos  := aScan( aSelects, Alltrim( ( pcQual )->&( cCampoCod ) ) )
		lFlag := .F.
		
		If nPos > 0
			lFlag := .T.
		Endif
		
		aAdd( aLinDet, { lFlag                     ,;
						( pcQual )->&( cCampoCod ),;
						( pcQual )->&( cCampoDes ) } )
						
		( pcQual )->( dBSkip() )
	Enddo
	
	aSize[ 1 ] /= 1.9
	aSize[ 2 ] /= 1.9
	aSize[ 3 ] /= 1.9
	aSize[ 4 ] /= 1.6
	aSize[ 5 ] /= 1.9
	aSize[ 6 ] /= 1.6
	aSize[ 7 ] /= 1.9
	
	AAdd( aObjects, { 315,  75, .T., .T. } )
	AAdd( aObjects, { 100, 100, .T., .T. } )
	
	aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj  := MsObjSize( aInfo, aObjects,.T.)
	
	dBSelectArea( "SX2" )
	SX2->( dBSetOrder( 1 ) )
	SX2->( dBGoTop() )
	SX2->( dBSeek( pcQual ) )
	
	DEFINE DIALOG oDlgConsP TITLE Alltrim( SX2->X2_NOME ) FROM aSize[ 7 ],000 TO aSize[ 6 ],aSize[ 5 ] PIXEL
	
	oBrowse := TWBrowse():New( aPosObj[ 1 ][ 1 ] + 5, aPosObj[ 1 ][ 2 ], ( oDlgConsP:nWidth / 2 ) - 6, ( oDlgConsP:nHeight / 2 ) - 45,, aCabTit, aLenTits, oDlgConsP,,,,,,,,,,,,.F.,,.T.,,.T.,,.T.,.T. )
	
	oBrowse:SetArray( aLinDet )
	oBrowse:bLine      := {|| { If( aLinDet[ oBrowse:nAt ][ 01 ], oOK, oNO ), aLinDet[ oBrowse:nAt ][ 02 ], aLinDet[ oBrowse:nAt ][ 03 ]} }
	oBrowse:bLDblClick := {|| aLinDet[ oBrowse:nAt][ 1 ] := !aLinDet[ oBrowse:nAt ][ 1 ], oBrowse:DrawSelect( ) }
	
	ACTIVATE DIALOG oDlgConsP CENTERED ON INIT ( EnchoiceBar(oDlgConsP,{|| ( nOption := 1, oDlgConsP:End() ) },{|| ( nOption := 2, oDlgConsP:End() ) } ), ( CursorArrow(), SysRefresh() ) )
	
	If nOption == 1
		
		&( Readvar() ) := Space( 99 )
		
		For nX := 1 To Len( aLinDet )
			If aLinDet[ nX ][ 1 ]
				cAux += "'" + Alltrim( aLinDet[ nX ][ 2 ] ) + "',"
			Endif
		Next
		
		cAux := Alltrim( cAux )
		
		&( Readvar() ) :=  SubStr( cAux, 1, Len( cAux ) - 1 )
		
	Endif
	
Endif

Return( .T. )


Static Function CarId( cFil , aId , cAutoriza )
***********************************************
Local nPos	:= 0.00

//-- Preenche o Array aCodAut com os Eventos (Menos DSR Mes Ant.)
SP9->( dbSeek( cFil , .T. ) )
While SP9->( !Eof() .and. cFil == P9_FILIAL )
	IF ( ( Right(SP9->P9_IDPON,1) == cAutoriza ) .or. ( cAutoriza == "*" ) )
		aAdd( aId , Array( 04 ) )
		nPos := Len( aId )
		aId[ nPos , 01 ] := SP9->P9_CODIGO	//-- Codigo do Evento 
		aId[ nPos , 02 ] := SP9->P9_IDPON 	//-- Identificador do Ponto 
		aId[ nPos , 03 ] := SP9->P9_CODFOL	//-- Codigo do da Verba Folha
		aId[ nPos , 04 ] := SP9->P9_BHORAS	//-- Evento para B.Horas
	EndIF
	SP9->( dbSkip() )
EndDo

Return( NIL )

Static Function Monta_Per( dDataIni , dDataFim , cFil , cMat , dIniAtu , dFimAtu )
**********************************************************************************
Local aPeriodos := {}
Local cFilSPO	:= xFilial( "SPO" , cFil )
Local dAdmissa	:= SRA->RA_ADMISSA
Local dPerIni   := CTOD( "//" )
Local dPerFim   := CTOD( "//" )

SPO->( dbSetOrder( 1 ) )
SPO->( dbSeek( cFilSPO , .F. ) )
While SPO->( !Eof() .and. PO_FILIAL == cFilSPO )
                       
    dPerIni := SPO->PO_DATAINI
    dPerFim := SPO->PO_DATAFIM  

    //-- Filtra Periodos de Apontamento a Serem considerados em funcao do Periodo Solicitado
    IF dPerFim < dDataIni .OR. dPerIni > dDataFim                                                      
		SPO->( dbSkip() )  
		Loop  
    Endif

    //-- Somente Considera Periodos de Apontamentos com Data Final Superior a Data de Admissao
    IF ( dPerFim >= dAdmissa )
       aAdd( aPeriodos , { dPerIni , dPerFim , Max( dPerIni , dDataIni ) , Min( dPerFim , dDataFim ) } )
	Else
		Exit
	EndIF

	SPO->( dbSkip() )

End While

IF ( aScan( aPeriodos , { |x| x[1] == dIniAtu .and. x[2] == dFimAtu } ) == 0.00 )
	dPerIni := dIniAtu
	dPerFim	:= dFimAtu 
	IF !(dPerFim < dDataIni .OR. dPerIni > dDataFim)
		IF ( dPerFim >= dAdmissa )
			aAdd(aPeriodos, { dPerIni, dPerFim, Max(dPerIni,dDataIni), Min(dPerFim,dDataFim) } )
		EndIF
    Endif
EndIF

Return( aPeriodos )


Static Function LoadX3Box(cCampo)
*********************************
Local aRet:={},nCont,nIgual
Local cCbox,cString
Local aSvArea := SX3->(GetArea())

SX3->(DbSetOrder(2))
SX3->(DbSeek(cCampo))

cCbox := SX3->(X3Cbox())

While !Empty(cCbox) 
   nCont  := AT( ";", cCbox )
   nIgual := AT( "=", cCbox )

   cString:=AllTrim(SubStr(cCbox,1,nCont-1)) //Opcao
   If nCont == 0
       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
      Exit
   Else
       aAdd(aRet,{SubStr(cString,1,nigual-1),SubStr(cString,nigual+1)})
   Endif 
   cCbox:=SubStr(cCbox,nCont+1)
Enddo
   
RestArea(aSvArea)

Return( aRet )


Static Function CarAboTot( aTotais , aAbonados , aAbonosPer, lMvAbosEve, lMvSubAbAp ) 
*************************************************************************************
Local aTotSpc		:= {} //-- 1-SPC->PC_PD/2-SPC->PC_QUANTC/3-SPC->PC_QUANTI/4-SPC->PC_QTABONO
Local aCodAbono		:= {}
Local aJustifica	:= {} //-- Retorno fAbonos() c/Cod abono e horas abonadas.
Local cString   	:= ""
Local cFilSP9   	:= xFilial( "SP9" , SRA->RA_FILIAL )
Local cFilSRV		:= xFilial( "SRV" , SRA->RA_FILIAL )
Local cFilSPC   	:= xFilial( "SPC" , SRA->RA_FILIAL )
Local cFilSPH   	:= xFilial( "SPH" , SRA->RA_FILIAL )
Local cImpHoras 	:= If(nImpHrs==1,"C",If(nImpHrs==2,"I","*")) //-- Calc/Info/Ambas
Local cAutoriza 	:= If(nImpAut==1,"A",If(nImpAut==2,"N","*")) //-- Aut./N.Aut./Ambas
Local cAliasRes		:= IF( lImpAcum , "SPL" , "SPB" )
Local cAliasApo		:= IF( lImpAcum , "SPH" , "SPC" )
Local bAcessaSPC 	:= &("{ || " + ChkRH("PNRX010","SPC","2") + "}")
Local bAcessaSPH 	:= &("{ || " + ChkRH("PNRX010","SPH","2") + "}")
Local bAcessaSPB 	:= &("{ || " + ChkRH("PNRX010","SPB","2") + "}")
Local bAcessaSPL 	:= &("{ || " + ChkRH("PNRX010","SPL","2") + "}")
Local bAcessRes		:= IF( lImpAcum , bAcessaSPH , bAcessaSPC )
Local bAcessApo		:= IF( lImpAcum , bAcessaSPL , bAcessaSPB )
Local lCalcula	 	:= .F.
Local lExtra	 	:= .F.
Local nColSpc   	:= 0.00
Local nCtSpc    	:= 0.00
Local nQuaSpc		:= 0.00
Local nPass     	:= 0.00
Local nHorasCal 	:= 0.00
Local nHorasInf 	:= 0.00
Local nX        	:= 0.00

If ( lImpRes )
	//Totaliza Codigos a partir do Resultado	
	fTotalSPB(;
				@aTotSpc		,;
				SRA->RA_FILIAL	,;
				SRA->RA_Mat		,;
				dMarcIni		,;
				dMarcFim		,;
				bAcessRes		,;
				cAliasRes		,;
				cAutoriza		 ;
			  )
	//-- Converte as horas para sexagenal quando impressao for a partir do resultado
	If ( lSexagenal )	// Sexagenal
		For nCtSpc := 1 To Len(aTotSpc)
			For nColSpc := 2 To 4
				aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'H')
			Next nColSpc
		Next nCtSpc
	Endif
Endif

//Totaliza Codigos a partir do Movimento
fTotaliza(;
			@aTotSpc,;
			SRA->RA_FILIAL,;
			SRA->RA_MAT,;
			bAcessApo,;
			cAliasApo,;
			cAutoriza,;
			@aCodAbono,;
			aAbonosPer,;
			lMvAbosEve,;
			lMvSubAbAp;
	 	)
//-- Converte as horas para Centesimal quando impressao for a partir do apontamento
If !( lImpRes ) .and. !( lSexagenal ) // Centesimal
	For nCtSpc :=1 To Len(aTotSpc)
		For nColSpc :=2 To 4
			aTotSpc[nCtSpc,nColSpc]:=fConvHr(aTotSpc[nCtSpc,nColSpc],'D')
		Next nColSpc
	Next nCtSpc
Endif


//-- Monta Array com Totais de Horas
If nImpHrs # 4  //-- Se solicitado para Listar Totais de Horas
	For nPass := 1 To Len(aTotSpc)
		IF ( lImpRes ) //Impressao dos Resultados
			//-- Se encontrar o Codigo da Verba ou For um codigo de hora extra valido de acordo com o solicitado  
			If PosSrv( aTotSpc[nPass,1] , cFilSRV , NIL , 01 )
		   	   nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
			   nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
			   If nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
			  	  cString := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 99,999.99'),Space(9)) + Space(1)
				  cString += If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 99,999.99'),Space(9))
				  //aAdd(aTotais, aTotSpc[nPass,1] + Space(1) + SRV->RV_DESC + Space(1) + cString )
				  aAdd(aTotais, { aTotSpc[nPass,1], SRV->RV_DESC, nHorasCal, nHorasInf, cString }  )
		  	   EndIf	
	        Endif
		ElseIf PosSP9( aTotSpc[nPass,1] , cFilSP9 , NIL , 01 )
			//-- Impressao a Partir do Movimento
			nHorasCal 	:= aTotSpc[nPass,2] //-- Calculado - Abonado
			nHorasInf 	:= aTotSpc[nPass,3] //-- Informado
			If nHorasCal > 0 .and. cImpHoras $ 'Cú*' .or. nHorasInf > 0 .and. cImpHoras $ 'Iú*'
				cString := If(cImpHoras$'Cú*',Transform(nHorasCal, '@E 99,999.99'),Space(9)) + Space(1)
				cString += If(cImpHoras$'Iú*',Transform(nHorasInf, '@E 99,999.99'),Space(9))
				//aAdd(aTotais, aTotSpc[nPass,1] + Space(1) + DescPDPon(aTotSpc[nPass,1], cFilSP9 ) + Space(1) + cString )
				aAdd(aTotais, { aTotSpc[nPass,1], DescPDPon(aTotSpc[nPass,1], cFilSP9 ), nHorasCal, nHorasInf, cString }  )
			EndIf  
		EndIF
	Next nPass
	
	//-- Acrescenta as informacoes referentes aos eventos associados aos motivos de abono
	//-- Condicoes: Se nao For Impressao de Resultados 
	//-- 			e Se For para Imprimir Horas Calculadas ou Ambas
	If !( lImpRes ) .and. (nImpHrs == 1 .or. nImpHrs == 3) 
		For nX := 1 To Len(aCodAbono) 
			// Converte as horas para Centesimal
			If !( lSexagenal ) // Centesimal
				aCodAbono[nX,2]:=fConvHr(aCodAbono[nX,2],'D')
			Endif
			//aAdd(aTotais, aCodAbono[nX,1] + Space(1) + DescPDPon(aCodAbono[nX,1], cFilSP9) + '      0,00 '  + Transform(aCodAbono[nX,2],'@E 99,999.99') )
			aAdd(aTotais, { aCodAbono[nX,1], DescPDPon(aCodAbono[nX,1], cFilSP9), 0, aCodAbono[nX,2], Transform(aCodAbono[nX,2],'@E 99,999.99') }  )
		Next nX
	Endif
EndIf

Return( NIL )


Static Function fTotaliza(	aTotais, cFil, cMat, bAcessa, cAlias, cAutoriza, aCodAbono, aAbonosPer, lMvAbosEve, lMvSubAbAp )
****************************************************************************************************************************
Local aJustifica	:= {}
Local cCodigo		:= ""
Local cPrefix		:= SubStr(cAlias,-2)
Local cTno			:= ""
Local cCodExtras	:= ""
Local cEvento		:= ""
Local cPD			:= ""
Local cPDI			:= ""
Local cCC			:= ""
Local cTPMARCA		:= ""
Local dPD			:= CTOD( "//" )
Local lExtra		:= .T.
Local lAbHoras		:= .T.
Local nQuaSpc		:= 0.00
Local nX			:= 0.00 
Local nEfetAbono	:= 0.00
Local nQUANTC		:= 0.00
Local nQuanti		:= 0.00
Local nQTABONO		:= 0.00

If ( cAlias )->(dbSeek( cFil + cMat ) )
	While ( cAlias )->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )
        
        dData	:= ( cAlias )->(&(cPrefix+"_DATA"))  	//-- Data do Apontamento
        cPD		:= ( cAlias )->(&(cPrefix+"_PD"))    	//-- Codigo do Evento
        cPDI	:= ( cAlias )->(&(cPrefix+"_PDI"))     	//-- Codigo do Evento Informado
        nQUANTC	:= ( cAlias )->(&(cPrefix+"_QUANTC"))  	//-- Quantidade Calculada pelo Apontamento
        nQuanti	:= ( cAlias )->(&(cPrefix+"_QUANTI"))  	//-- Quantidade Informada
        nQTABONO:= ( cAlias )->(&(cPrefix+"_QTABONO")) 	//-- Quantidade Abonada
		cTPMARCA:= ( cAlias )->(&(cPrefix+"_TPMARCA")) 	//-- Tipo da Marcacao
		cCC		:= ( cAlias )->(&(cPrefix+"_CC")) 		//-- Centro de Custos
		
		If ( cAlias )->( !Eval(bAcessa) )
			( cAlias )->( dbSkip() )
			Loop
		EndIf
		
		If dData < dMarcIni .or. dDATA > dMarcFim 
			( cAlias )->( dbSkip() )
			Loop
		Endif
        
		 /*
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³ Obtem TODOS os ABONOS do Evento							   ³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
        //-- Trata a Qtde de Abonos
        aJustifica 	:= {} //-- Reinicializa aJustifica
        nEfetAbono	:=	0.00
		If nQuanti == 0 .and. fAbonos( dData , cPD , NIL , @aJustifica , cTPMARCA , cCC , aAbonosPer ) > 0
            
            //-- Corre Todos os Abonos
			For nX := 1 To Len(aJustifica)
			    
				//-- Obtem a Quantidade de Horas Abonadas
				nQuaSpc := aJustifica[nX,2] //_QtAbono
				
				//-- Converte as horas Abonadas para Centesimal
				If !( lSexagenal ) // Centesimal
					nQuaSpc:= fConvHr(nQuaSpc,'D')
				Endif
                
                //-- Cria Novo Elemento no array ANALITICO de Abonos 
				aAdd( aAbonados, {} )
				aAdd( aAbonados[Len(aAbonados)], dData )
				aAdd( aAbonados[Len(aAbonados)], DescAbono(aJustifica[nX,1],'C') )
				
				aAdd( aAbonados[Len(aAbonados)], StrTran(StrZero(nQuaSpc,5,2),'.',':') )
				aAdd( aAbonados[Len(aAbonados)], DescTpMarca(aBoxSPC,cTPMARCA))
				aAdd( aAbonados[Len(aAbonados)], aJustifica[ nX, 1 ] )
				
				If !( lImpres )
					//-- Trata das Informacoes sobre o Evento Associado ao Motivo corrente
					//-- Obtem Evento Associado
					cEvento := PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_EVENTO" , 01 )
					If ( lAbHoras := ( PosSP6( aJustifica[nX,1] , SRA->RA_FILIAL , "P6_ABHORAS" , 01 ) $ " S" ) )
					    //-- Se o motivo abona Horas
						If ( lAbHoras )
							If !Empty( cEvento )
								If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
									aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
								Else
									aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
								EndIf
							Else 
							    //-- Se o motivo  nao possui abono associado
							    //-- Calcula o total de horas a abonar efetivamente
							    nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
							EndIf
						Endif
					Else	

						IF ( ( lMvSubAbAp ) .and. !Empty( cEvento ) )
						   //-- Se o motivo  nao possui abono associado
						   //-- Calcula o total de horas a abonar efetivamente 
						   If ( nPos := aScan( aCodAbono, { |x| x[1] == cEvento } ) ) > 0
								aCodAbono[nPos,2] := __TimeSum(aCodAbono[nPos,2], aJustifica[nX,2] ) //_QtAbono
						   Else
								aAdd(aCodAbono, {cEvento,  aJustifica[nX,2] }) // Codigo do Evento e Qtde Abonada
						   EndIf
						   //-- O total de horas acumulado em nEfetAbono sera deduzido do 
						   //-- total de horas apontadas.
						   nEfetAbono:= __TimeSum(nEfetAbono, aJustifica[nX,2] ) //_QtAbono
						Endif
					
					EndIf
				
				Endif	
			
			Next nX 
		
		Endif
        
        If !( lImpres )
	        //-- Obtem o Codigo do Evento  (Informado ou Calculado)
	        cCodigo:= If(!Empty(cPDI), cPDI, cPD )
	         
	        //-- Obtem a posicao no Calendario para a Data
	        
	        If ( nPos 	:= aScan(aTabCalend, {|x| x[1] ==dDATA .and. x[4] == '1E' }) ) > 0 
			    //-- Obtem o Turno vigente na Data
			    cTno	:=	aTabCalend[nPos,14]  
			    //-- Carrega ou recupera os codigos correspondentes a horas extras na Data
			    cCodExtras	:= ''
			    CarExtAut( @cCodExtras , cTno , cAutoriza )
			    lExtra:=.F.
			    If cCodigo$cCodExtras 
			       lExtra:=.T.
			    Endif   
			Endif      
	                 
	        //-- Se o Evento for Alguma HE Solicitada (Autorizada ou Nao Autorizada) 
	        //-- Ou  Valido Qquer Evento (Autorizado e Nao Autorizado)
	        //-- OU  Evento possui um identificador correspondente a Evento Autorizado ou Nao Autorizado.
			//-- Ou  Evento e' referente a banco de horas 
	        If lExtra .or. cAutoriza == '*' .or. (aScan(aId,{|aEvento| ( aEvento[1] == cCodigo .and. Right(aEvento[2],1) == cAutoriza ) .Or. ( aEvento[1] == cCodigo .And. cAutoriza == 'A' .And. Empty(aEvento[2]) .And. aEvento[4] == "S" ) }  ) > 0.00)
	           
		        //-- Procura em aTotais pelo acumulado do Evento Lido
				If ( nPos := aScan(aTotais,{|x| x[1] = cCodigo  }) ) > 0    
				   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
			       aTotais[nPos,2] := __TimeSum(aTotais[nPos,2],If(nQuanti>0, 0, __TimeSub(nQUANTC,nEfetAbono)))
				   aTotais[nPos,3] := __TimeSum(aTotais[nPos,3],nQuanti)
				   aTotais[nPos,4] := __TimeSum(aTotais[nPos,4],nQTABONO)
			    
				Else 
				   //-- Adiciona Evento em Acumulados
				   //-- Subtrai do evento a qtde de horas que efetivamente abona horas conforme motivo de abono
	           	   aAdd(aTotais,{cCodigo,If(nQuanti > 0, 0, __TimeSub(nQUANTC,nEfetAbono)), nQuanti,nQTABONO,lExtra })
	            Endif
	            
	        Endif
	        
         Endif
         
		( cAlias )->( dbSkip() )
		
	End While
	
Endif

Return( NIL )


Static Function fTotalSPB(aTotais,cFil,cMat,dDataIni,dDataFim,bAcessa,cAlias)
*****************************************************************************
Local cPrefix := ""

cPrefix		:= SubStr(cAlias,-2)

If ( cAlias )->( dbSeek( cFil + cMat ) )
	While ( cAlias )->( !Eof() .and. cFil+cMat == &(cPrefix+"_FILIAL")+&(cPrefix+"_MAT") )

		If ( cAlias )->( &(cPrefix+"_DATA") < dDataIni .or. &(cPrefix+"_DATA") > dDataFim )
			( cAlias )->( dbSkip() )
			Loop
		Endif

		If ( cAlias )->( !Eval(bAcessa) )
			( cAlias )->( dbSkip() )
			Loop
		EndIf

		If ( nPos := aScan(aTotais,{|x| x[1] == ( cAlias )->( &(cPrefix+"_PD") ) }) ) > 0
			aTotais[nPos,2] := aTotais[nPos,2] + ( cAlias )->( &(cPrefix+"_HORAS") ) 
		Else
			aAdd(aTotais,{( cAlias )->( &(cPrefix+"_PD") ),( cAlias )->( &(cPrefix+"_HORAS") ),0,0 })
		Endif
		( cAlias )->( dbSkip() )
	End While
Endif

Return( NIL )


Static Function DescTpMarca(aBox,cTpMarca)
******************************************
Local aTpMarca:={},cRet:='',nTpMarca:=0

If Len(aBox)>0
   nTpmarca:=aScan(aBox,{|xtp| xTp[1] == cTpMarca})
   cRet:=If(nTpMarca>0,aBox[nTpmarca,2],"")
Endif

Return( cRet )

Static Function AjustaSX1( cPerg )
**********************************
Local aRet    := {}
Local aRegs   := {}
Local aSXBs   := { "GPER41", "GPER42", "GPER43", "GPER44" }
Local aTitles := { /*01*/"Filial De ?		           ",;
                   /*02*/"Filial Até ?		           ",;
                   /*03*/"Turno De ?		           ",;
                   /*04*/"Turno Até ?		           ",;
                   /*05*/"Matricula De ?		       ",;
                   /*06*/"Matricula Até ?		       ",;
                   /*07*/"Situações p/ Análise Ponto   ",;
                   /*08*/"Categorias p/ Análise Ponto  ",;
                   /*09*/"Data De ?		               ",;
                   /*10*/"Data Até ?		           ",;
                   /*11*/"Sindicato de		           ",;
                   /*12*/"Sindicato até		           ",;
                   /*13*/"Verbas p/ Faltas             ",;
                   /*14*/"Verbas p/ Atrasos/Saídas     ",;
                   /*15*/"Abono/Justifi. p/ Atestados  ",;
                   /*16*/"Ordenação		               "}
                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd( aRegs,{ cPerg, "01", aTitles[01], aTitles[01], aTitles[01], "MV_CH1", "C", TAMSX3( "RA_FILIAL"  )[ 1 ], 0, 0, "G",	""           	                                          , "MV_PAR01", ""         , ""         , ""         , "01"           , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"  , "S", "033", ".RHFILDE." } )
aAdd( aRegs,{ cPerg, "02", aTitles[02], aTitles[02], aTitles[02], "MV_CH2", "C", TAMSX3( "RA_FILIAL"  )[ 1 ], 0, 0, "G",	"NaoVazio()" 	                                          , "MV_PAR02", ""         , ""         , ""         , "01"           , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "XM0"  , "S", "033", ".RHFILAT." } )
aAdd( aRegs,{ cPerg, "03", aTitles[03], aTitles[03], aTitles[03], "MV_CH3", "C", 3	                        , 0, 0, "G",	""           	                                          , "MV_PAR03", ""         , ""         , ""         , "000"          , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SR6"  , "S", ""   , ".RHTURDE." } )
aAdd( aRegs,{ cPerg, "04", aTitles[04], aTitles[04], aTitles[04], "MV_CH4", "C", 3	                        , 0, 0, "G",	"NaoVazio()" 	                                          , "MV_PAR04", ""         , ""         , ""         , "099"          , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SR6"  , "S", ""   , ".RHTURAT." } )
aAdd( aRegs,{ cPerg, "05", aTitles[05], aTitles[05], aTitles[05], "MV_CH5", "C", TAMSX3( "RA_MAT"     )[ 1 ], 0, 0, "G",	""           	                                          , "MV_PAR05", ""         , ""         , ""         , "001111"       , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"  , "S", ""   , ".RHMATD."  } )
aAdd( aRegs,{ cPerg, "06", aTitles[06], aTitles[06], aTitles[06], "MV_CH6", "C", TAMSX3( "RA_MAT"     )[ 1 ], 0, 0, "G",	"NaoVazio()" 	                                          , "MV_PAR06", ""         , ""         , ""         , "001111"       , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SRA"  , "S", ""   , ".RHMATA."  } )
aAdd( aRegs,{ cPerg, "07", aTitles[07], aTitles[07], aTitles[07], "MV_CH7", "C", 5	                        , 0, 0, "G",	"fSituacao"	                                              , "MV_PAR07", ""         , ""         , ""         , "A*F*"         , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""     , "S", ""   , ".RHSITUA." } )
aAdd( aRegs,{ cPerg, "08", aTitles[08], aTitles[08], aTitles[08], "MV_CH8", "C", 15	                        , 0, 0, "G",	"fCategoria"                                              , "MV_PAR08", ""         , ""         , ""         , "ACDEGHIJMPST" , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""     , "S", ""   , ".RHCATEG." } )
aAdd( aRegs,{ cPerg, "09", aTitles[09], aTitles[09], aTitles[09], "MV_CH9", "D", 8	                        , 0, 0, "G",	'( PutPerMvPar("RJGR4RTPXB","09","10") .and. NaoVazio() )', "MV_PAR09", ""         , ""         , ""         , "20121221"     , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""     , "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "10", aTitles[10], aTitles[10], aTitles[10], "MV_CHA", "D", 8	                        , 0, 0, "G",	"NaoVazio()"                                              , "MV_PAR10", ""         , ""         ,""          , "20130120"     , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""     , "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "11", aTitles[11], aTitles[11], aTitles[11], "MV_CHB", "C", TAMSX3( "RA_SINDICA" )[ 1 ], 0, 0, "G",	""                                                        , "MV_PAR11", ""         , ""         , ""         , ""             , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "RCE"  , "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "12", aTitles[12], aTitles[12], aTitles[12], "MV_CHC", "C", TAMSX3( "RA_SINDICA" )[ 1 ], 0, 0, "G",	""	                                                      , "MV_PAR12", ""         , ""         , ""         , ""             , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "RCE"  , "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "13", aTitles[13], aTitles[13], aTitles[13], "MV_CHD", "C", 99                         , 0, 0, "G",	""                                                        , "MV_PAR13", ""         , ""         , ""         , ""	         , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "GPER41", "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "14", aTitles[14], aTitles[14], aTitles[14], "MV_CHE", "C", 99                         , 0, 0, "G",	""                 	                                      , "MV_PAR14", ""         , ""         , ""         , ""	         , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "GPER41", "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "15", aTitles[15], aTitles[15], aTitles[15], "MV_CHF", "C", 99                         , 0, 0, "G",	""                 	                                      , "MV_PAR15", ""         , ""         , ""         , ""	         , "", ""    , ""    , ""    , "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "GPER44", "S", ""   , ""          } )
aAdd( aRegs,{ cPerg, "16", aTitles[16], aTitles[16], aTitles[16], "MV_CHG", "N", 1	                        , 0, 0, "C",	""	                                                      , "MV_PAR16", "Matricula", "Matricula", "Matricula", ""	         , "", "Nome", "Nome", "Nome", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""      , "S", ""   , ""          } )
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
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

For i := 1 To Len( aRegs )
	aAdd( aRet, Array( 3 ) )
	aRet[ Len( aRet ) ][ 1 ]  := aRegs[ i ][ 03 ]
	aRet[ Len( aRet ) ][ 2 ]  := aRegs[ i ][ 07 ]
	aRet[ Len( aRet ) ][ 3 ]  := aRegs[ i ][ 13 ]
Next


aRegs := { }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens das consultas padrões da rotina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
aAdd( aRegs, { "GPER41", "1", "01", "RE", "GPER41", "GPER41", "GPER41", "SRV"                 } )
aAdd( aRegs, { "GPER41", "2", "01", "01", ""      , ""      , ""      , "U_GPER04V2( 'SRV' )" } )
aAdd( aRegs, { "GPER41", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )
aAdd( aRegs, { "GPER42", "1", "01", "RE", "GPER42", "GPER42", "GPER42", "SP9"                 } )
aAdd( aRegs, { "GPER42", "2", "01", "01", ""      , ""      , ""      , "U_GPER04V2( 'SP9' )" } )
aAdd( aRegs, { "GPER42", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )
aAdd( aRegs, { "GPER43", "1", "01", "RE", "GPER43", "GPER43", "GPER43", "SX5"                 } )
aAdd( aRegs, { "GPER43", "2", "01", "01", ""      , ""      , ""      , "U_GPER04V2( 'SX5' )" } )
aAdd( aRegs, { "GPER43", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )
aAdd( aRegs, { "GPER44", "1", "01", "RE", "GPER44", "GPER44", "GPER43", "SP6"                 } )
aAdd( aRegs, { "GPER44", "2", "01", "01", ""      , ""      , ""      , "U_GPER04V2( 'SP6' )" } )
aAdd( aRegs, { "GPER44", "5", "01", ""  , ""      , ""      , ""      , "___lRet"             } )

dBSelectArea( "SXB" )
SXB->( dBSetOrder( 1 ) )

For i := 1 To Len( aRegs )
	SXB->( dBGoTop() )
	If !SXB->( dBseek( aRegs[ i ][ 1 ] +  aRegs[ i ][ 2 ] + aRegs[ i ][ 3 ] + aRegs[ i ][ 4 ] ) )
		
		RecLock( "SXB", .T. )
		For j := 1 to SXB->( FCount() )
			If j <= Len( aRegs[ i ] )
				SXB->( FieldPut( j, aRegs[ i ][ j ] ) )
			Endif
		Next
		SXB->( MsUnlock() )
		
	Endif
Next

Return( aRet )

Static Function GetMovPto(aTabCalend, aMarcacoes, aImp,dInicio,dFim, lTerminal, lAfasta, cAfasta )
**************************************************************************************************
Local aDescAbono := {}
Local cTipAfas   := ""
Local cDescAfas  := ""
Local cOcorr     := ""
Local cOrdem     := ""
Local cTipDia    := ""
Local dData      := Ctod("//")
Local dDtBase    := dFim
Local lRet       := .T.
Local lFeriado   := .T.
Local lTrabaFer  := .F.
Local lAfasta    := .T.   
Local nX         := 0
Local nDia       := 0
Local nMarc      := 0
Local nLenMarc	 := Len( aMarcacoes )
Local nLenDescAb := Len( aDescAbono )
Local nTab       := 0
Local nContMarc  := 0
Local nDias		 := 0 

//-- Variaveis ja inicializadas.
aImp := {}

nDias := ( dDtBase - dInicio )
For nDia := 0 To nDias

	//-- Reinicializa Variaveis.
	dData      := dInicio + nDia
	aDescAbono := {}
	cOcorr     := ""
	cTipAfas   := ""
	cDescAfas  := ""
	cOcorr	   := ""
	//-- o Array aTabcalend ‚ setado para a 1a Entrada do dia em quest„o.
	IF ( nTab := aScan(aTabCalend, {|x| x[1] == dData .and. x[4] == '1E' }) ) == 0.00
		Loop
	EndIF

	//-- o Array aMarcacoes ‚ setado para a 1a Marca‡„o do dia em quest„o.
	nMarc := aScan(aMarcacoes, { |x| x[3] == aTabCalend[nTab, 2] })

	//-- Consiste Afastamentos, Demissoes ou Transferencias.
	IF ( ( lAfasta := aTabCalend[ nTab , 24 ] ) .or. SRA->( RA_SITFOLH $ 'DúT' .and. dData > RA_DEMISSA ) )
		lAfasta		:= .T.
		cTipAfas	:= IF(!Empty(aTabCalend[ nTab , 25 ]),aTabCalend[ nTab , 25 ] , fDemissao(SRA->RA_SITFOLH, SRA->RA_RESCRAI ) )
		cDescAfas	:= fDescAfast( cTipAfas, Nil, Nil, SRA->( RA_SITFOLH == 'D' .and. dData > RA_DEMISSA ) )
		
		If Empty( cAfasta )
			cAfasta     += cTipAfas + " - " + cDescAfas
		Else 
			cAux := cTipAfas + " - " + cDescAfas
			
			If !( cAux $ cAfasta  )
				cAfasta     += ", " + cTipAfas + " - " + cDescAfas
			Endif
			
		Endif
		
	EndIF

	//Verifica Regra de Apontamento ( Trabalha Feriado ? )
	lTrabaFer := ( PosSPA( aTabCalend[ nTab , 23 ] , cFilSPA , "PA_FERIADO" , 01 ) == "S" )

	//-- Consiste Feriados.
	IF ( lFeriado := aTabCalend[ nTab , 19 ] )  .AND. !lTrabaFer
		cOcorr := aTabCalend[ nTab , 22 ]
	EndIF

	//-- Carrega Array aDescAbono com os Abonos ocorridos no Dia
	nLenDescAb := Len(aAbonados)
	For nX := 1 To nLenDescAb
		If aAbonados[nX,1] == dData
			aAdd(aDescAbono, aAbonados[nX,2] + Space(1) + aAbonados[nX,3]+ Space(2) + aAbonados[nX,4])
		EndIf
	Next nX

	//-- Ordem e Tipo do dia em quest„o.
	cOrdem  := aTabCalend[nTab,2]
	cTipDia := aTabCalend[nTab,6]

    //-- Se a Data da marcacao for Posterior a Admissao
	IF dData >= SRA->RA_ADMISSA
		//-- Se Afastado
		If ( lAfasta  .AND. aTabCalend[nTab,10] <> 'E' ) .OR. ( lAfasta  .AND. aTabCalend[nTab,10] == 'E' .AND. ( !lImpExcecao .OR. !aTabCalend[nTab,32] ) )
			cOcorr := cDescAfas 
		//-- Se nao for Afastado
		Else                    

		    //-- Se tiver EXCECAO para o Dia  ------------------------------------------------
			If aTabCalend[nTab,10] == 'E'			
		       //-- Se excecao trabalhada
		       If cTipDia == 'S'  
		          //-- Se nao fez Marcacao
		          If Empty(nMarc)
					 cOcorr := '** Ausente **'  // 	
				  //-- Se fez marcacao	 
		          Else
		          	 //-- Motivo da Marcacao
	          		 If !Empty(aTabCalend[nTab,11])
					 	cOcorr := AllTrim(aTabCalend[nTab,11])
					 Else
					 	cOcorr := '** Excecao nao Trabalhada **'
					 EndIf
		          Endif	 
		       //-- Se excecao outros dias (DSR/Compensado/Nao Trabalhado)
		       Else
 					//-- Motivo da Marcacao
		       		If !Empty(aTabCalend[nTab,11])
						cOcorr := AllTrim(aTabCalend[nTab,11])
					Else
						cOcorr := '** Excecao nao Trabalhada **'
					EndIf
			   Endif	

		    //-- Se nao Tiver Excecao  no Dia ---------------------------------------------------
		    Else    
		        //-- Se feriado 
		       	If lFeriado 
		       	    //-- Se nao trabalha no Feriado
		       	    If !lTrabaFer 
						cOcorr := If(!Empty(cOcorr),cOcorr,'** Feriado **' ) //  
					//-- Se trabalha no Feriado
					Else                  
					    //-- Se Dia Trabalhado e Nao fez Marcacao
				    	If cTipDia == 'S' .and. Empty(nMarc)
							cOcorr := '** Ausente **'  // 
							
				    	ElseIf cTipDia == 'D'
							cOcorr := '** D.S.R. **'  //   
							
						ElseIf cTipDia == 'C'
							cOcorr := '** Compensado **'  // 
							
						ElseIf cTipDia == 'N'
							cOcorr := '** Nao Trabalhado **'  // 
							
						EndIf
					Endif
		    	Else                                    
		    	    //-- Se Dia Trabalhado e Nao fez Marcacao
			    	If cTipDia == 'S' .and. Empty(nMarc)
						cOcorr := '** Ausente **'  // 
						
			    	ElseIf cTipDia == 'D'
						cOcorr := '** D.S.R. **'  // 
						
					ElseIf cTipDia == 'C'
						cOcorr := '** Compensado **'  // 
						
					ElseIf cTipDia == 'N'
						cOcorr := '** Nao Trabalhado **'  // 
						
					EndIf
				
				Endif	
				
		    Endif
		    
		Endif
		
	Endif	    
	
	nLenDescAb := Len(aDescAbono) 
		
	//-- Adiciona Nova Data a ser impressa.
	aAdd(aImp,{})
	aAdd(aImp[Len(aImp)], aTabCalend[nTab,1])

	//-- Ocorrencia na Data.
	If (lTerminal) 
		aAdd( aImp[Len(aImp)], cOcorr) 
	Endif	
	
	//-- Abono na Data.
	If ( nLenDescAb  > 0 )
	    If !( lTerminal)
	    	If cOcorr == '** Ausente **'  // 
			  	aAdd( aImp[Len(aImp)], cOcorr ) // '** Ausente **'
			Else
				If !empty( cOcorr )
					aAdd( aImp[Len(aImp)],	Space(01)) 
				  	aAdd( aImp[Len(aImp)], cOcorr )
					aAdd( aImp,{})
					aAdd( aImp[Len(aImp)], aTabCalend[nTab,1])
					aAdd( aImp[Len(aImp)],	Space(01) )
				Else                                   
					aAdd( aImp[Len(aImp)],	Space(01)) 
				Endif	
			Endif
	    Endif
		For nX := 1 To nLenDescAb
			If nX == 1
				aAdd( aImp[Len(aImp)], aDescAbono[nX])
			Else
				aAdd(aImp, {})
				aAdd(aImp[Len(aImp)], aTabCalend[nTab,1]		)
				aAdd(aImp[Len(aImp)], Space(01)			 	)
				aAdd(aImp[Len(aImp)], aDescAbono[nX]			)
			Endif
		Next nX
	Else
		If ( lTerminal ) 
			aAdd( aImp[Len(aImp)], '' )
		Else
			If cOcorr == '** Ausente **'  // 
				aAdd( aImp[Len(aImp)], cOcorr) 
				aAdd( aImp[Len(aImp)], Space(01)) 
			Else
				aAdd( aImp[Len(aImp)], Space(01)) 
			  	aAdd( aImp[Len(aImp)], cOcorr )
			Endif	
		Endif		
	Endif

	//-- Marca‡oes ocorridas na data.
	If nMarc > 0
		While nMarc <= nLenMarc .and. cOrdem == aMarcacoes[nMarc,3]
			nContMarc ++
			aAdd( aImp[Len(aImp)], StrTran(StrZero(aMarcacoes[nMarc,2],5,2),'.',':'))
			nMarc ++
		End While
	EndIf

Next nDia

lRet := If(nContMarc>=1,.T.,.F.)

Return( lRet )