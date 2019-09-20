#INCLUDE 'PROTHEUS.CH'
#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )
#DEFINE X3_USADO_EMUSO "€€€€€€€€€€€€€€ "
#DEFINE X3_USADO_NAOUSADO "€€€€€€€€€€€€€€€"
#DEFINE X3_OBRIGAT "ม€"
#DEFINE X3_NAOOBRIGAT "ภ"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ UPDPRO   บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de update dos dicionแrios para compatibiliza็ใo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ UPDPRO   - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function UPDPRO01()
	
	Local   aSay     := {}
	Local   aButton  := {}
	Local   aMarcadas:= {}
	Local   cTitulo  := 'ATUALIZAวรO DE DICIONมRIOS E TABELAS'
	Local   cDesc1   := 'Esta rotina tem como fun็ใo fazer  a atualiza็ใo  dos dicionแrios do Sistema ( SX?/SIX )'
	Local   cDesc2   := 'Este processo deve ser executado em modo EXCLUSIVO, ou seja nใo podem haver outros'
	Local   cDesc3   := 'usuแrios  ou  jobs utilizando  o sistema.  ษ extremamente recomendav้l  que  se  fa็a um'
	Local   cDesc4   := 'BACKUP  dos DICIONมRIOS  e da  BASE DE DADOS antes desta atualiza็ใo, para que caso '
	Local   cDesc5   := 'ocorra eventuais falhas, esse backup seja ser restaurado.'
	Local   cDesc6   := ''
	Local   cDesc7   := ''
	Local   lOk      := .F.
	
	Private oMainWnd  := NIL
	Private oProcess  := NIL
	
	#IFDEF TOP
		TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
	#ENDIF
	
	__cInterNet := NIL
	__lPYME     := .F.
	
	Set Dele On
	
	// Mensagens de Tela Inicial
	aAdd( aSay, cDesc1 )
	aAdd( aSay, cDesc2 )
	aAdd( aSay, cDesc3 )
	aAdd( aSay, cDesc4 )
	aAdd( aSay, cDesc5 )
	//aAdd( aSay, cDesc6 )
	//aAdd( aSay, cDesc7 )
	
	// Botoes Tela Inicial
	aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
	aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )
	
	FormBatch(  cTitulo,  aSay,  aButton )
	
	If lOk
		aMarcadas := EscEmpresa()
		
		If !Empty( aMarcadas )
			If  ApMsgNoYes( 'Confirma a atualiza็ใo dos dicionแrios ?', cTitulo )
				oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. )
				oProcess:Activate()
				
				If lOk
					Final( 'Atualiza็ใo Concluํda.' )
				Else
					Final( 'Atualiza็ใo nใo Realizada.' )
				EndIf
				
			Else
				Final( 'Atualiza็ใo nใo Realizada.' )
				
			EndIf
			
		Else
			Final( 'Atualiza็ใo nใo Realizada.' )
			
		EndIf
		
	EndIf
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSTProc  บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da grava็ใo dos arquivos           ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSTProc  - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSTProc( lEnd, aMarcadas )
	Local   cTexto    := ''
	Local   cFile     := ''
	Local   cFileLog  := ''
	Local   cAux      := ''
	Local   cMask     := 'Arquivos Texto (*.TXT)|*.txt|'
	Local   nRecno    := 0
	Local   nI        := 0
	Local   nX        := 0
	Local   nPos      := 0
	Local   aRecnoSM0 := {}
	Local   aInfo     := {}
	Local   lOpen     := .F.
	Local   lRet      := .T.
	Local   oDlg      := NIL
	Local   oMemo     := NIL
	Local   oFont     := NIL
	
	Local   cPathSIX:=Space(254)
	Local   cPathSX1:=Space(254)
	Local   cPathSX2:=Space(254)
	Local   cPathSX3:=Space(254)
	Local   cPathSX5:=Space(254)
	Local   cPathSX6:=Space(254)
	Local   cPathSX7:=Space(254)
	Local   cPathSX9:=Space(254)
	Local   cPathSXA:=Space(254)
	Local   cPathSXB:=Space(254)
	Local   cPathHLP:=Space(254)
	
	
	Local   aSIX:={}
	Local   aSX1:={}
	Local   aSX2:={}
	Local   aSX3:={}
	Local   aSX5:={}
	Local   aSX6:={}
	Local   aSX7:={}
	Local   aSX9:={}
	Local   aSXA:={}
	Local   aSXB:={}
	Local   aHLP:={}
	
	Local   aStruSIX:={}
	Local   aStruSX1:={}
	Local   aStruSX2:={}
	Local   aStruSX3:={}
	Local   aStruSX5:={}
	Local   aStruSX6:={}
	Local   aStruSX7:={}
	Local   aStruSX9:={}
	Local   aStruSXA:={}
	Local   aStruSXB:={}
	
	Local oFont1 := TFont():New("MS Sans Serif",,020,,.F.,,,,,.F.,.F.)
	Local oGet1
	Local oGet10
	Local oGet2
	Local oGet3
	Local oGet4
	Local oGet5
	Local oGet6
	Local oGet7
	Local oGet8
	Local oGet9
	
	Local oSay1
	Local oSay10
	Local oSay11
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oSay9
	Local oSButton1
	Local oSButton2
	Local nOpc:=0
	
	Private aArqUpd   := {}
	
	
	If ( lOpen := MyOpenSm0Ex() )
		
		dbSelectArea( 'SM0' )
		dbGoTop()
		
		While !SM0->( EOF() )
			// So adiciona no aRecnoSM0 se a empresa for diferente
			If aScan( aRecnoSM0, { |x| x[2] == SM0->M0_CODIGO } ) == 0 ;
					.AND. aScan( aMarcadas, { |x| x[1] == SM0->M0_CODIGO } ) > 0
				aAdd( aRecnoSM0, { Recno(), SM0->M0_CODIGO } )
			EndIf
			SM0->( dbSkip() )
		End
		
		If lOpen
			
			For nI := 1 To Len( aRecnoSM0 )
				
				SM0->( dbGoTo( aRecnoSM0[nI][1] ) )
				
				RpcSetType( 2 )
				RpcSetEnv( SM0->M0_CODIGO, SM0->M0_CODFIL )
				
				lMsFinalAuto := .F.
				
				cTexto += Replicate( '-', 128 ) + CRLF
				cTexto += 'Empresa : ' + SM0->M0_CODIGO + '/' + SM0->M0_NOME + CRLF + CRLF
				
				oProcess:SetRegua1( 8 )
				
				
				// aStruSX?[n,1]  n sao os campos e a posi็ao 1 ้ o nome do campo
				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX1         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				/*
				oProcess:IncRegua1( 'Dicionแrio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
				SAtuSX1()
				*/
				
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX2         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSX2)>0
					oProcess:IncRegua1( 'Dicionแrio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
					cTexto += FSAtuSX2(aSX2,aStruSX2)
				endif
				*/
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX3         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				oProcess:IncRegua1( 'Dicionแrio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
				cTexto +=  FSAtuSX3()
				
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SIX         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSIX)>0
					oProcess:IncRegua1( 'Dicionแrio de ํndices - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
					cTexto += FSAtuSIX(aSIX,aStruSIX)
				endif
				
				oProcess:IncRegua1( 'Dicionแrio de dados - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
				oProcess:IncRegua2( 'Atualizando campos/ํndices')
				*/
				
				// Alteracao fisica dos arquivos
				__SetX31Mode( .F. )
				
				For nX := 1 To Len( aArqUpd )
					
					If Select( aArqUpd[nx] ) > 0
						dbSelectArea( aArqUpd[nx] )
						dbCloseArea()
					EndIf
					
					X31UpdTable( aArqUpd[nx] )
					
					If __GetX31Error()
						Alert( __GetX31Trace() )
						ApMsgStop( 'Ocorreu um erro desconhecido durante a atualiza็ใo da tabela : ' + aArqUpd[nx] + '. Verifique a integridade do dicionแrio e da tabela.', 'ATENวรO' )
						cTexto += 'Ocorreu um erro desconhecido durante a atualiza็ใo da estrutura da tabela : ' + aArqUpd[nx] + CRLF
					EndIf
					
				Next nX
				
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX6         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSX6)>0
					oProcess:IncRegua1( 'Dicionแrio de parโmetros - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
					cTexto += FSAtuSX6(aSX6, aStruSX6)
				endif
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX7         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSX7)>0
					oProcess:IncRegua1( 'Dicionแrio de gatilhos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
					cTexto += FSAtuSX7(aSX7, aStruSX7)
				endif
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SXA         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSXA)>0
					oProcess:IncRegua1( 'Dicionแrio de pastas - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
					cTexto += FSAtuSXA(aSXA, aStruSXA)
				endif
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SXB         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				if Len(aSXB)>0
					oProcess:IncRegua1( 'Dicionแrio de consultas padrใo - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
					cTexto += FSAtuSXB(aSXB,aStruSXB)
				endif
				
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX5         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				oProcess:IncRegua1( 'Dicionแrio de tabelas sistema - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
				FSAtuSX5()
				
				
				/*
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o dicionแrio SX9         ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				if Len(aSX9)>0
					oProcess:IncRegua1( 'Dicionแrio de relacionamentos - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
					cTexto += FSAtuSX9(aSX9,aStruSX9)
				endif
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza os helps                 ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				
				if Len(aHLP) >0
					
					oProcess:IncRegua1( 'Helps de Campo - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
					cTexto += FSAtuHlp(@aHLP)
					
				endif
				*/
				
				oProcess:IncRegua1( 'Helps de Campo - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
				cTexto += FSAtuHlp()
				
				RpcClearEnv()
				
				If !( lOpen := MyOpenSm0Ex() )
					Exit
				EndIf
				
			Next nI
			
			If lOpen
				
				cAux += Replicate( '-', 128 ) + CRLF
				cAux += Replicate( ' ', 128 ) + CRLF
				cAux += 'LOG DA ATUALIZACAO DOS DICIONมRIOS' + CRLF
				cAux += Replicate( ' ', 128 ) + CRLF
				cAux += Replicate( '-', 128 ) + CRLF
				cAux += CRLF
				cAux += ' Dados Ambiente'        + CRLF
				cAux += ' --------------------'  + CRLF
				cAux += ' Empresa / Filial...: ' + cEmpAnt + '/' + cFilAnt  + CRLF
				cAux += ' Nome Empresa.......: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_NOMECOM', cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
				cAux += ' Nome Filial........: ' + Capital( AllTrim( GetAdvFVal( 'SM0', 'M0_FILIAL' , cEmpAnt + cFilAnt, 1, '' ) ) ) + CRLF
				cAux += ' DataBase...........: ' + DtoC( dDataBase )  + CRLF
				cAux += ' Data / Hora........: ' + DtoC( Date() ) + ' / ' + Time()  + CRLF
				cAux += ' Environment........: ' + GetEnvServer()  + CRLF
				cAux += ' StartPath..........: ' + GetSrvProfString( 'StartPath', '' )  + CRLF
				cAux += ' RootPath...........: ' + GetSrvProfString( 'RootPath', '' )  + CRLF
				cAux += ' Versao.............: ' + GetVersao(.T.)  + CRLF
				cAux += ' Usuario Microsiga..: ' + __cUserId + ' ' +  cUserName + CRLF
				cAux += ' Computer Name......: ' + GetComputerName()  + CRLF
				
				aInfo   := GetUserInfo()
				If ( nPos    := aScan( aInfo,{ |x,y| x[3] == ThreadId() } ) ) > 0
					cAux += ' '  + CRLF
					cAux += ' Dados Thread' + CRLF
					cAux += ' --------------------'  + CRLF
					cAux += ' Usuario da Rede....: ' + aInfo[nPos][1] + CRLF
					cAux += ' Estacao............: ' + aInfo[nPos][2] + CRLF
					cAux += ' Programa Inicial...: ' + aInfo[nPos][5] + CRLF
					cAux += ' Environment........: ' + aInfo[nPos][6] + CRLF
					cAux += ' Conexao............: ' + AllTrim( StrTran( StrTran( aInfo[nPos][7], Chr( 13 ), '' ), Chr( 10 ), '' ) )  + CRLF
				EndIf
				cAux += Replicate( '-', 128 ) + CRLF
				cAux += CRLF
				
				cTexto := cAux + cTexto
				
				cFileLog := MemoWrite( CriaTrab( , .F. ) + '.log', cTexto )
				
				Define Font oFont Name 'Mono AS' Size 5, 12
				
				Define MsDialog oDlg Title 'Atualizacao concluida.' From 3, 0 to 340, 417 Pixel
				
				@ 5, 5 Get oMemo Var cTexto Memo Size 200, 145 Of oDlg Pixel
				oMemo:bRClicked := { || AllwaysTrue() }
				oMemo:oFont     := oFont
				
				Define SButton From 153, 175 Type  1 Action oDlg:End() Enable Of oDlg Pixel // Apaga
				Define SButton From 153, 145 Type 13 Action ( cFile := cGetFile( cMask, '' ), If( cFile == '', .T., ;
					MemoWrite( cFile, cTexto ) ) ) Enable Of oDlg Pixel // Salva e Apaga //'Salvar Como...'
				
				Activate MsDialog oDlg Center
				
			EndIf
			
		EndIf
		
	Else
		
		lRet := .F.
		
	EndIf
	
Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX1 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX1 - Perguntas     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX1 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX1()
	Local aEstrut   := {}
	Local aSX1      := {}
	Local aStruDic  := SX1->( dbStruct() )
	Local cAlias    := "SA1"
	Local nI        := 0
	Local nJ        := 0
	Local nTam1     := Len( SX1->X1_GRUPO )
	Local nTam2     := Len( SX1->X1_ORDEM )
	
	cTexto  := "Inicio Atualizacao " + cAlias + CRLF + CRLF //
	
	aEstrut := { "X1_GRUPO",;
		"X1_ORDEM",;
		"X1_PERGUNT",;
		"X1_PERSPA",;
		"X1_PERENG",;
		"X1_VARIAVL",;
		"X1_TIPO",;
		"X1_TAMANHO",;
		"X1_DECIMAL",;
		"X1_PRESEL",;
		"X1_GSC",;
		"X1_VALID",;
		"X1_F3",;
		"X1_GRPSXG",;
		"X1_PYME",;
		"X1_VAR01",;
		"X1_DEF01",;
		"X1_DEFSPA1",;
		"X1_DEFENG1",;
		"X1_CNT01",;
		"X1_DEF02",;
		"X1_DEFSPA2",;
		"X1_DEFENG2",;
		"X1_DEF03",;
		"X1_DEFSPA3",;
		"X1_DEFENG3",;
		"X1_DEF04",;
		"X1_DEFSPA4",;
		"X1_DEFENG4",;
		"X1_DEF05",;
		"X1_DEFSPA5",;
		"X1_DEFENG5",;
		"X1_HELP" }
	
	
	AADD(aSX1,{'PRSTSPED',;
		'17',;
		'Diretoria?',;
		'',;
		'',;
		'mv_chh',;
		'C',;
		2,;
		0,;
		0,;
		'G',;
		'',;
		'U2',;
		'',;
		'',;
		'mv_par17',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'',;
		'.PRSTSPED17.'})
	
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX1 ) )
	
	dbSelectArea( "SX1" )
	SX1->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSX1 )
		
		oProcess:IncRegua2( "Atualizando perguntas..." ) //
		
		If !SX1->( dbSeek( PadR( aSX1[nI][1], nTam1 ) + PadR( aSX1[nI][2], nTam2 ) ) )
			cTexto +=  "Pergunta Criada. Grupo/Ordem "  + aSX1[nI][1] + "/" + aSX1[nI][2] + CRLF //
			RecLock( "SX1", .T. )
		Else
			cTexto +=  "Pergunta Alterada. Grupo/Ordem " + aSX1[nI][1] + "/" + aSX1[nI][2] + CRLF //
			RecLock( "SX1", .F. )
		EndIf
		
		For nJ := 1 To Len( aSX1[nI] )
			If aScan( aStruDic, { |aX| PadR( aX[1], 10 ) == PadR( aEstrut[nJ], 10 ) } ) > 0
				SX1->( FieldPut( FieldPos( aEstrut[nJ] ), aSX1[nI][nJ] ) )
			EndIf
		Next nJ
		
		MsUnLock()
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX1" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //
	
	PutHelp('PRSTSPED17',{'Diretoria ramo do cliente'},{''},{''},.T.)
	
Return aClone( aSX1 )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX2 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX2 - Arquivos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX2 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FSAtuSX2(aSX2, aEstrut)
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX2' + CRLF + CRLF
	Local cPath     := ''
	Local cEmpr     := ''
	
	dbSelectArea( 'SX2' )
	SX2->( dbSetOrder( 1 ) )
	SX2->( dbGoTop() )
	cPath := SX2->X2_PATH
	cEmpr := Substr( SX2->X2_ARQUIVO, 4 )
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX2 ) )
	
	dbSelectArea( 'SX2' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX2 )
		
		If !SX2->( dbSeek( aSX2[nI][1] ) )
			
			If !( aSX2[nI][1] $ cAlias )
				cAlias += aSX2[nI][1] + '/'
				cTexto += 'Foi incluํda a tabela ' + aSX2[nI][1] + CRLF
			EndIf
			
			RecLock( 'SX2', .T. )
			For nJ := 1 To Len( aSX2[nI] )
				If FieldPos( aEstrut[nJ,1] ) > 0
					If AllTrim( aEstrut[nJ,1] ) == 'X2_ARQUIVO'
						FieldPut( FieldPos( aEstrut[nJ,1] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
					Else
						FieldPut( FieldPos( aEstrut[nJ,1] ), aSX2[nI][nJ] )
					EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()
			
			oProcess:IncRegua2( 'Atualizando Arquivos (SX2)...')
			
		EndIf
		
	Next nI
	
	cTexto += CRLF + 'Final da Atualizacao do SX2' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX3 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX3 - Campos        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX3 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX3()
	
	Local aSX3           := {}
	Local aEstrut        := {}
	Local i              := 0
	Local j              := 0
	Local lSX3	         := .F.
	Local cTexto         := ''
	Local cAlias         := ''
	Local cOrdem         := ''
	Local nTamSeek  := Len( SX3->X3_CAMPO )
	
	aEstrut:= { "X3_ARQUIVO","X3_ORDEM"  ,"X3_CAMPO"  ,"X3_TIPO"   ,"X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA" ,"X3_TITENG" ,;
		"X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID"  ,"X3_USADO"  ,"X3_RELACAO","X3_F3"     ,"X3_NIVEL"  ,;
		"X3_RESERV" ,"X3_CHECK"  ,"X3_TRIGGER","X3_PROPRI" ,"X3_BROWSE" ,"X3_VISUAL" ,"X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER",;
		"X3_CBOX"   ,"X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN"   ,"X3_INIBRW" ,"X3_GRPSXG" ,"X3_FOLDER", "X3_PYME"}
	
	Aadd(aSX3,{"SBM",;		//Arquivo
	"26",;						//Ordem
	"BM_X_ENVSF",;			//Campo
	"C",;						//Tipo
	1 ,;						//Tamanho
	0,;							//Decimal
	"Envia SalesF",;				//Titulo
	"Envia SalesF",;				//Titulo SPA
	"Envia SalesF",;				//Titulo ENG
	"Envia SalesForce ?",;	//Descricao
	"Envia SalesForce ?",;	//Descricao SPA
	"Envia SalesForce ?",;	//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"A",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"PERTENCE('SN').OR.VAZIO()",;						//VLDUSER
	"S=Sim;N=Nao",;			//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})						//PYME
	
	
	Aadd(aSX3,{"SC5",;		//Arquivo
	"D4",;						//Ordem
	"C5_X_ORIPD",;			//Campo
	"C",;						//Tipo
	1 ,;						//Tamanho
	0,;							//Decimal
	"Origem Ped  ",;			//Titulo
	"Origem Ped  ",;			//Titulo SPA
	"Origem Ped  ",;			//Titulo ENG
	"Origem Pedido            ",;	//Descricao
	"Origem Pedido            ",;	//Descricao SPA
	"Origem Pedido            ",;	//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"V",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"Pertence('SHA')",;						//VLDUSER
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX SPA
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})
	
	Aadd(aSX3,{"SC5",;		//Arquivo
	"D5",;						//Ordem
	"C5_X_NUMPD",;			//Campo
	"C",;						//Tipo
	25 ,;						//Tamanho
	0,;							//Decimal
	"Nro Ped Exte",;			//Titulo
	"Nro Ped Exte",;			//Titulo SPA
	"Nro Ped Exte",;			//Titulo ENG
	"Nro Ped Externo          ",;	//Descricao
	"Nro Ped Externo          ",;	//Descricao SPA
	"Nro Ped Externo          ",;	//Descricao ENG
	"",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"V",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;			//CBOX
	"",;			//CBOX SPA
	"",;			//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})          
	
	Aadd(aSX3,{"SA1",;		//Arquivo
	"z9",;						//Ordem
	"A1_X_ENVSF",;			//Campo
	"C",;						//Tipo
	1 ,;						//Tamanho
	0,;							//Decimal
	"Envia SalesF",;				//Titulo
	"Envia SalesF",;				//Titulo SPA
	"Envia SalesF",;				//Titulo ENG
	"Envia SalesForce ?",;	//Descricao
	"Envia SalesForce ?",;	//Descricao SPA
	"Envia SalesForce ?",;	//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"A",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"PERTENCE('SN').OR.VAZIO()",;						//VLDUSER
	"S=Sim;N=Nao",;			//CBOX
	"",;						//CBOX SPA
	"",;						//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})						//PYME
	
	Aadd(aSX3,{"SF2",;		//Arquivo
	"D5",;						//Ordem
	"F2_X_SFID",;			//Campo
	"C",;						//Tipo
	25 ,;						//Tamanho
	0,;							//Decimal
	"Nro Id SF",;			//Titulo
	"Nro Id SF",;			//Titulo SPA
	"Nro Id SF",;			//Titulo ENG
	"Nro Id Salesforce        ",;	//Descricao
	"Nro Id Salesforce        ",;	//Descricao SPA
	"Nro Id Salesforce        ",;	//Descricao ENG
	"",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"V",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;			//CBOX
	"",;			//CBOX SPA
	"",;			//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"}) 
	
	
	Aadd(aSX3,{"SC0",;		//Arquivo
	"D4",;						//Ordem
	"C0_X_ORIPD",;			//Campo
	"C",;						//Tipo
	1 ,;						//Tamanho
	0,;							//Decimal
	"Origem Ped  ",;			//Titulo
	"Origem Ped  ",;			//Titulo SPA
	"Origem Ped  ",;			//Titulo ENG
	"Origem Pedido            ",;	//Descricao
	"Origem Pedido            ",;	//Descricao SPA
	"Origem Pedido            ",;	//Descricao ENG
	"@!",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"V",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"Pertence('SHA')",;						//VLDUSER
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX SPA
	"S=SalesForce;H=Hybris;A=Armazenagem",;			//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})
	
	Aadd(aSX3,{"SC0",;		//Arquivo
	"D5",;						//Ordem
	"C0_X_NUMPD",;			//Campo
	"C",;						//Tipo
	25 ,;						//Tamanho
	0,;							//Decimal
	"Nro Ped Exte",;			//Titulo
	"Nro Ped Exte",;			//Titulo SPA
	"Nro Ped Exte",;			//Titulo ENG
	"Nro Ped Externo          ",;	//Descricao
	"Nro Ped Externo          ",;	//Descricao SPA
	"Nro Ped Externo          ",;	//Descricao ENG
	"",;						//Picture
	"",;						//VALID
	X3_USADO_EMUSO ,;			//USADO
	"",;						//RELACAO
	"",;						//F3
	1,;							//NIVEL
	X3_NAOOBRIGAT,;			//RESERV
	"",;						//CHECK
	"",;						//TRIGGER
	"U",;						//PROPRI
	"N",;						//BROWSE
	"V",;						//VISUAL
	"R",;						//CONTEXT
	"",;						//OBRIGAT
	"",;						//VLDUSER
	"",;			//CBOX
	"",;			//CBOX SPA
	"",;			//CBOX ENG
	"",;						//PICTVAR
	"",;						//WHEN
	"",;						//INIBRW
	"",;						//SXG
	"",;						//FOLDER
	"N"})         
	
	ProcRegua(Len(aSX3))
	SX3->(DbSetOrder(2))
	cAliasAtu := ''
	For nI := 1 To Len( aSX3 )
		
		SX3->( dbSetOrder( 2 ) )
		
		If !SX3->( dbSeek( PadR( aSX3[nI][3], nTamSeek ) ) )
			
			If !( aSX3[nI][1] $ cAlias )
				cAlias += aSX3[nI][1] + '/'
				aAdd( aArqUpd, aSX3[nI][1] )
			EndIf
			
			//
			// Busca ultima ocorrencia do alias
			//
			If ( aSX3[nI][1] <> cAliasAtu )
				cSeqAtu   := '00'
				cAliasAtu := aSX3[nI][1]
				
				dbSetOrder( 1 )
				SX3->( dbSeek( cAliasAtu + 'ZZ', .T. ) )
				dbSkip( -1 )
				
				If ( SX3->X3_ARQUIVO == cAliasAtu )
					cSeqAtu := SX3->X3_ORDEM
				EndIf
				
				nSeqAtu := Val( RetAsc( cSeqAtu, 3, .F. ) )
			EndIf
			
			nSeqAtu++
			cSeqAtu := RetAsc( Str( nSeqAtu ), 2, .T. )
			lSX3	:= .T.
			RecLock( 'SX3', .T. )
			For nJ := 1 To Len( aSX3[nI] )
				If     nJ == 2    // Ordem
					FieldPut( FieldPos( aEstrut[nJ] ), cSeqAtu )
					
				ElseIf FieldPos( aEstrut[nJ] ) > 0
					FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
					
				EndIf
			Next nJ
			
			dbCommit()
			MsUnLock()
			
			cTexto += 'Criado o campo ' + aSX3[nI][3] + CRLF
			
		Else
			
			//
			// Verifica todos os campos
			//
			For nJ := 1 To Len( aSX3[nI] )
				
				//
				// Se o campo estiver diferente da estrutura
				//
				If aEstrut[nJ] == SX3->( FieldName( nJ ) ) .AND. ;
						PadR( StrTran( AllToChar( SX3->( FieldGet( nJ ) ) ), ' ', '' ), 250 ) <> ;
						PadR( StrTran( AllToChar( aSX3[nI][nJ] )           , ' ', '' ), 250 ) .AND. ;
						AllTrim( SX3->( FieldName( nJ ) ) ) <> 'X3_ORDEM'
					
					If ApMsgNoYes( 'O campo ' + aSX3[nI][3] + ' estแ com o ' + SX3->( FieldName( nJ ) ) + ;
							' com o conte๚do' + CRLF + ;
							'[' + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
							'que serแ substituido pelo NOVO conte๚do' + CRLF + ;
							'[' + RTrim( AllToChar( aSX3[nI][nJ] ) ) + ']' + CRLF + ;
							'Deseja substituir ? ', 'Confirmar substitui็ใo de conte๚do' )
						
						cTexto += 'Alterado o campo ' + aSX3[nI][3] + CRLF
						cTexto += '   ' + PadR( SX3->( FieldName( nJ ) ), 10 ) + ' de [' + AllToChar( SX3->( FieldGet( nJ ) ) ) + ']' + CRLF
						cTexto += '            para [' + AllToChar( aSX3[nI][nJ] )          + ']' + CRLF + CRLF
						lSX3	:= .T.
						RecLock( 'SX3', .F. )
						FieldPut( FieldPos( aEstrut[nJ] ), aSX3[nI][nJ] )
						dbCommit()
						MsUnLock()
						
						If !( aSX3[nI][1] $ cAlias )
							cAlias += aSX3[nI][1] + '/'
							aAdd( aArqUpd, aSX3[nI][1] )
						EndIf
						
					EndIf
					
				EndIf
				
			Next
			
		EndIf
		
		oProcess:IncRegua2( 'Atualizando Campos de Tabelas (SX3)...' )
		
	Next nI
	
	If lSX3
		cTexto := 'Foram alteradas as estruturas das seguintes tabelas : '+cAlias+CHR(13)+CHR(10)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ HELPS -> CAMPOS  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//PutHelp('PA1_YDIRAMO',{'Diretoria ramo do cliente'},{''},{''},.T.)
		
		
		
		cTexto := cTexto + CHR(13) + CHR(10) + "Helps Atualizados Com Sucesso!" + CHR(13) + CHR(10)
	EndIf
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSIX บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SIX - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSIX - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSIX(aSIX, aEstrut)
	Local cTexto    := 'Inicio da Atualizacao do SIX' + CRLF + CRLF
	Local cAlias    := ''
	Local lDelInd   := .F.
	Local nI        := 0
	Local nJ        := 0
	Local lAlt      := .F.
	Local cSeq      := ''
	
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSIX ) )
	
	dbSelectArea( 'SIX' )
	SIX->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSIX )
		lAlt := .F.
		
		If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
			RecLock( 'SIX', .T. )
			lDelInd := .F.
			cTexto += 'อndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
		Else
			lDelInd := .F.
			If Upper(AllTrim(SIX->CHAVE)) <> Upper(AllTrim(aSIX[nI][3]))
				If Empty(aSIX[nI][9]) //Nickname em branco
					If ApMsgYesNo('O indice da tabela ' + aSIX[nI][1] + ' definido como ordem ' + aSIX[nI][2] + ' no UPDATE jแ existe no dicionario da empresa: ' + SM0->M0_CODIGO + ' com uma CHAVE diferente da do UPDATE. Voc๊ confirma essa alteracao ? OBS: NAO FOI ESPECIFICADO UM NICKNAME PARA ESSE INDICE. PODEM OCORRER ERROS NA EXECUCAO DAS ROTINAS ENVOLVIDAS SE FOR CONFIRMADA ESSA OPCAO.')
						lDelInd := .T.
						RecLock( 'SIX', .F. )
					Else
						cTexto += 'ATENCAO, o indice da tabela ' + aSIX[nI][1] + ' ordem ' + aSIX[nI][2] + ' com a expressao ' + aSIX[nI][3] + ' nao foi atualizado pelo UPDATE.' + CRLF
						Loop
					EndIf
				Else
					If ApMsgYesNo('O indice da tabela ' + aSIX[nI][1] + ' definido como ordem ' + aSIX[nI][2] + ' no UPDATE jแ existe no dicionario da empresa: ' + SM0->M0_CODIGO + ' com uma CHAVE diferente da do UPDATE. Voc๊ confirma a numeracao automatica desse indice ? OBS: FOI ESPECIFICADO UM NICKNAME PARA ESSE INDICE.')
						//Pega a proxima sequencia de indice
						SIX->(dbGoTop())
						SIX->( dbSeek( aSIX[nI][1] ) )
						While SIX->(!Eof()) .And. SIX->INDICE == aSIX[nI][1]
							cSeq := SIX->ORDEM
							SIX->(dbSkip())
						EndDo
						cSeq := Soma1(cSeq)
						lDelInd := .F.
						
						aSIX[nI][2] := cSeq
						
						RecLock( 'SIX', .T. )
						lDelInd := .F.
						cTexto += 'อndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
					Else
						cTexto += 'ATENCAO, o indice da tabela ' + aSIX[nI][1] + ' ordem ' + aSIX[nI][2] + ' com a expressao ' + aSIX[nI][3] + ' nao foi atualizado pelo UPDATE.' + CRLF
						Loop
					EndIf
				EndIf
			Else
				lDelInd := .T.
				cTexto += 'อndice alterado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
				lAlt := .T.
			EndIf
		EndIf
		
		If StrTran( Upper( AllTrim( CHAVE )       ), ' ', '') <> ;
				StrTran( Upper( AllTrim( aSIX[nI][3] ) ), ' ', '' )
			aAdd( aArqUpd, aSIX[nI][1] )
			
			If !( aSIX[nI][1] $ cAlias )
				cAlias += aSIX[nI][1] + '/'
			EndIf
			
			For nJ := 1 To Len( aSIX[nI] )
				If FieldPos( aEstrut[nJ,1] ) > 0
					FieldPut( FieldPos( aEstrut[nJ,1] ), aSIX[nI][nJ] )
				EndIf
			Next nJ
			
			dbCommit()
			MsUnLock()
			
			If lDelInd
				TcInternal( 60, RetSqlName( aSIX[nI][1] ) + '|' + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
			EndIf
			
		EndIf
		
		oProcess:IncRegua2( 'Atualizando ํndices...' )
		
	Next nI
	
	cTexto += CRLF + CRLF + 'Final da Atualizacao do SIX' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX6 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX6 - Parโmetros    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX6 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX6(aSX6,aEstrut )
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX6' + CRLF + CRLF
	Local lReclock  := .T.
	Local lContinua := .T.
	
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX6 ) )
	
	dbSelectArea( 'SX6' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX6 )
		
		If !SX6->( dbSeek('  '+aSX6[nI][1] ) )
			
			If !( aSX6[nI][1] $ cAlias )
				cAlias += aSX6[nI][2] + '/'
				cTexto += 'Foi incluํda o parametro: ' + aSX6[nI][2] + CRLF
			EndIf
			
			RecLock( 'SX6', .T. )
			For nJ := 1 To Len( aSX6[nI] )
				If FieldPos( aEstrut[nJ,1] ) > 0
					//If AllTrim( aEstrut[nJ,1] ) == 'X2_ARQUIVO'
					//		FieldPut( FieldPos( aEstrut[nJ,1] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
					//Else
					FieldPut( FieldPos( aEstrut[nJ,1] ), aSX6[nI][nJ] )
					//EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()
			
			oProcess:IncRegua2( 'Atualizando Arquivos (SX6)...')
			
		EndIf
		
	Next nI
	
	
	cTexto += CRLF + 'Final da Atualizacao do SX6' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX7 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX7 - Gatilhos      ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX7 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX7(aSX7, aEstrut)
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX7->X7_CAMPO )
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX7' + CRLF + CRLF
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX7 ) )
	
	dbSelectArea( 'SX7' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX7 )
		
		If !SX7->( dbSeek( PadR( aSX7[nI][1], nTamSeek ) + aSX7[nI][2] ) )
			
			If !( aSX7[nI][1] $ cAlias )
				cAlias += aSX7[nI][1] + '/'
				cTexto += 'Foi incluํdo o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
			EndIf
			
			RecLock( 'SX7', .T. )
		Else
			
			If !( aSX7[nI][1] $ cAlias )
				cAlias += aSX7[nI][1] + '/'
				cTexto += 'Foi alterado o gatilho ' + aSX7[nI][1] + '/' + aSX7[nI][2] + CRLF
			EndIf
			
			RecLock( 'SX7', .F. )
		EndIf
		
		For nJ := 1 To Len( aSX7[nI] )
			If FieldPos( aEstrut[nJ,1] ) > 0
				FieldPut( FieldPos( aEstrut[nJ,1] ), aSX7[nI][nJ] )
			EndIf
		Next nJ
		
		dbCommit()
		MsUnLock()
		
		
		//Atualiza o X3_TRIGGER
		dbSelectArea('SX3')
		SX3->(dbSetOrder(2))
		If SX3->(dbSeek(aSX7[nI][1]))
			SX3->(RecLock('SX3',.F.))
			SX3->X3_TRIGGER := 'S'
			SX3->(MsUnlock())
		EndIf
		
		oProcess:IncRegua2( 'Atualizando Arquivos (SX7)...')
		
	Next nI
	
	cTexto += CRLF + 'Final da Atualizacao do SX7' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXA บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXA - Pastas        ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXA - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXA(aSXA, aEstrut )
	
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SXA' + CRLF + CRLF
	
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSXA ) )
	
	dbSelectArea( 'SXA' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSXA )
		
		If !SXA->( dbSeek(aSXA[nI][1]+aSXA[nI][2] ) )
			
			If !( aSXA[nI][1] $ cAlias )
				cAlias += aSXA[nI][2] + '/'
				cTexto += 'Foi incluํda o folder: ' + aSXA[nI][3] + CRLF
			EndIf
			
			RecLock( 'SXA', .T. )
			For nJ := 1 To Len( aSXA[nI] )
				If FieldPos( aEstrut[nJ,1] ) > 0
					//If AllTrim( aEstrut[nJ,1] ) == 'X2_ARQUIVO'
					//		FieldPut( FieldPos( aEstrut[nJ,1] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
					//Else
					FieldPut( FieldPos( aEstrut[nJ,1] ), aSXA[nI][nJ] )
					//EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()
			
			oProcess:IncRegua2( 'Atualizando Arquivos (SXA)...')
			
		EndIf
		
	Next nI
	
	
	cTexto += CRLF + 'Final da Atualizacao do SXA' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSXB บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SXB - Consultas Pad ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSXB - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSXB(aSXB, aEstrut )
	Local nI        := 0
	Local nJ        := 0
	Local cAlias    := 'Inicio da Atualizacao do SXB' + CRLF + CRLF
	Local cTexto    := ''
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSXB ) )
	
	dbSelectArea( 'SXB' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSXB )
		
		If !Empty( aSXB[nI][1] )
			
			If !SXB->( dbSeek( PadR( aSXB[nI][1], Len( SXB->XB_ALIAS ) ) + aSXB[nI][2] + aSXB[nI][3] + aSXB[nI][4] ) )
				
				If !( aSXB[nI][1] $ cAlias )
					cAlias += aSXB[nI][1] + '/'
					cTexto += 'Foi incluํda a consulta padrใo ' + aSXB[nI][1] + CRLF
				EndIf
				
				RecLock( 'SXB', .T. )
				
				For nJ := 1 To Len( aSXB[nI] )
					If !Empty( FieldName( FieldPos( aEstrut[nJ,1] ) ) )
						FieldPut( FieldPos( aEstrut[nJ,1] ), aSXB[nI][nJ] )
					EndIf
				Next nJ
				
				dbCommit()
				MsUnLock()
				
			Else
				
				//
				// Verifica todos os campos
				//
				For nJ := 1 To Len( aSXB[nI] )
					
					//
					// Se o campo estiver diferente da estrutura
					//
					If aEstrut[nJ,1] == SXB->( FieldName( nJ ) ) .AND. ;
							StrTran( AllToChar( SXB->( FieldGet( nJ ) )  ), ' ', '' ) <> ;
							StrTran( AllToChar( aSXB[nI][nJ]             ), ' ', '' )
						
						If ApMsgNoyes( 'A consulta padrao ' + aSXB[nI][1] + ' estแ com o ' + SXB->( FieldName( nJ ) ) + ;
								' com o conte๚do' + CRLF + ;
								'[' + RTrim( AllToChar( SXB->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
								', e este ้ diferente do conte๚do' + CRLF + ;
								'[' + RTrim( AllToChar( aSXB[nI][nJ] ) ) + ']' + CRLF +;
								'Deseja substituir ? ', 'Confirma substitui็ใo de conte๚do' )
							
							RecLock( 'SXB', .F. )
							FieldPut( FieldPos( aEstrut[nJ,1] ), aSXB[nI][nJ] )
							dbCommit()
							MsUnLock()
							
							If !( aSXB[nI][1] $ cAlias )
								cAlias += aSXB[nI][1] + '/'
								cTexto += 'Foi Alterada a consulta padrao ' + aSXB[nI][1] + CRLF
							EndIf
							
						EndIf
						
					EndIf
					
				Next
				
			EndIf
			
		EndIf
		
		oProcess:IncRegua2( 'Atualizando Consultas Padroes (SXB)...' )
		
	Next nI
	
	cTexto += CRLF + 'Final da Atualizacao do SXB' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX5 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX5 - Indices       ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX5 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX5()
	Local aEstrut   := {}
	Local aSX5      := {}
	Local cAlias    := ""
	Local nI        := 0
	Local nJ        := 0
	
	cTexto  := "Inicio Atualizacao SX5" + CRLF + CRLF
	
	aEstrut := { "X5_FILIAL", "X5_TABELA", "X5_CHAVE", "X5_DESCRI", "X5_DESCSPA", "X5_DESCENG" }
	
	AADD(aSX5, {SM0->M0_CODFIL,"00","U2","DIRETORIA RAMO CLIENTE","DIRETORIA RAMO CLIENTE","DIRETORIA RAMO CLIENTE"})
	AADD(aSX5, {SM0->M0_CODFIL,"U2","01","CONSTRUCAO","CONSTRUCAO","CONSTRUCAO"})
	AADD(aSX5, {SM0->M0_CODFIL,"U2","02","HOME CENTER","HOME CENTER","HOME CENTER"})
	AADD(aSX5, {SM0->M0_CODFIL,"U2","03","BAZAR","BAZAR","BAZAR"})
	AADD(aSX5, {SM0->M0_CODFIL,"U2","04","B2B","B2B","B2B"})
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX5 ) )
	
	dbSelectArea( "SX5" )
	SX5->( dbSetOrder( 1 ) )
	
	For nI := 1 To Len( aSX5 )
		
		oProcess:IncRegua2( "Atualizando tabelas..." ) //
		
		If !SX5->( dbSeek( aSX5[nI][1] + aSX5[nI][2] + aSX5[nI][3]) )
			cTexto += "Item da tabela criado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF //
			RecLock( "SX5", .T. )
		Else
			cTexto += "Item da tabela alterado. Tabela " + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + "/" + aSX5[nI][3] + CRLF //
			RecLock( "SX5", .F. )
		EndIf
		
		For nJ := 1 To Len( aSX5[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
			EndIf
		Next nJ
		
		MsUnLock()
		
		aAdd( aArqUpd, aSX5[nI][1] )
		
		If !( aSX5[nI][1] $ cAlias )
			cAlias += aSX5[nI][1] + "/"
		EndIf
		
	Next nI
	
	cTexto += CRLF + "Final da Atualizacao" + " SX5" + CRLF + Replicate( "-", 128 ) + CRLF + CRLF //
	
Return aClone( aSX5 )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuSX9 บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao do SX9 - Relacionament ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuSX9 - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuSX9(aSX9, aEstrut)
	Local nI        := 0
	Local nJ        := 0
	Local nTamSeek  := Len( SX9->X9_DOM )
	Local cAlias    := ''
	Local cTexto    := 'Inicio da Atualizacao do SX9' + CRLF + CRLF
	
	
	//
	// Atualizando dicionแrio
	//
	oProcess:SetRegua2( Len( aSX9 ) )
	
	dbSelectArea( 'SX9' )
	dbSetOrder( 1 )
	
	For nI := 1 To Len( aSX9 )
		
		If !SX9->( dbSeek(aSX9[nI][1]+aSX9[nI][2] ) )
			
			If !( aSX9[nI][1] $ cAlias )
				cAlias += aSX9[nI][2] + '/'
				cTexto += 'Foi incluํda o dominio / contradominio: ' + aSX9[nI][1] +'-' +aSX9[nI][3]+ CRLF
			EndIf
			
			RecLock( 'SX9', .T. )
			For nJ := 1 To Len( aSX9[nI] )
				If FieldPos( aEstrut[nJ,1] ) > 0
					//If AllTrim( aEstrut[nJ,1] ) == 'X2_ARQUIVO'
					//		FieldPut( FieldPos( aEstrut[nJ,1] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
					//Else
					FieldPut( FieldPos( aEstrut[nJ,1] ), aSX9[nI][nJ] )
					//EndIf
				EndIf
			Next nJ
			dbCommit()
			MsUnLock()
			
			oProcess:IncRegua2( 'Atualizando Arquivos (SX9)...')
			
		EndIf
		
	Next nI
	
	
	cTexto += CRLF + 'Final da Atualizacao do SX9' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ FSAtuHlp บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento da gravacao dos Helps de Campos    ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ FSAtuHlp - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FSAtuHlp(aHLP)
	Local cCampo	  :=""
	Local aHlpPor   := {}
	Local aHlpEng   := {}
	Local aHlpSpa   := {}
	Local nI		  :=0
	Local cTexto    := 'Inicio da Atualizacao ds Helps de Campos' + CRLF + CRLF
	
	//
	// Helps Tabela
	//
	aHlpPor := {}
	aHlpEng := {}
	aHlpSpa := {}
	
	
		
	cCampo:="PBM_X_ENVSF"
	aHlpPor:={{"Indica se envia produto"},{" para Salesforce"}}
	aHlpEng:={{"Indica se envia produto"},{" para Salesforce"}}
	aHlpSpa:={{"Indica se envia produto"},{" para Salesforce"}}
	
	PutHelp( cCampo, aHlpPor, aHlpEng, aHlpSpa, .T. )
	cTexto+='Atualizado help do campo ' + cCampo + CRLF
	
	cCampo:="PC5_X_ORIPD"
	aHlpPor:={{"Indica origem do pedido"}}
	aHlpEng:={{"Indica origem do pedido"}}
	aHlpSpa:={{"Indica origem do pedido"}}
	
	PutHelp( cCampo, aHlpPor, aHlpEng, aHlpSpa, .T. )
	cTexto+='Atualizado help do campo ' + cCampo + CRLF
	
	cCampo:="PC5_X_NUMPD"
	aHlpPor:={{"Numero Pedido externo"}}
	aHlpEng:={{"Numero Pedido externo"}}
	aHlpSpa:={{"Numero Pedido externo"}}
	
	PutHelp( cCampo, aHlpPor, aHlpEng, aHlpSpa, .T. )
	cTexto+='Atualizado help do campo ' + cCampo + CRLF
	
	cTexto += CRLF + 'Final da Atualizacao dos Helps de Campos' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF
	
Return cTexto


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณESCEMPRESAบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Generica para escolha de Empresa, montado pelo SM0_ บฑฑ
ฑฑบ          ณ Retorna vetor contendo as selecoes feitas.                 บฑฑ
ฑฑบ          ณ Se nao For marcada nenhuma o vetor volta vazio.            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EscEmpresa()
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Parametro  nTipo                           ณ
	//ณ 1  - Monta com Todas Empresas/Filiais      ณ
	//ณ 2  - Monta so com Empresas                 ณ
	//ณ 3  - Monta so com Filiais de uma Empresa   ณ
	//ณ                                            ณ
	//ณ Parametro  aMarcadas                       ณ
	//ณ Vetor com Empresas/Filiais pre marcadas    ณ
	//ณ                                            ณ
	//ณ Parametro  cEmpSel                         ณ
	//ณ Empresa que sera usada para montar selecao ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local   aSalvAmb := GetArea()
	Local   aSalvSM0 := {}
	Local   aRet     := {}
	Local   aVetor   := {}
	Local   oDlg     := NIL
	Local   oChkMar  := NIL
	Local   oLbx     := NIL
	Local   oMascEmp := NIL
	Local   oMascFil := NIL
	Local   oButMarc := NIL
	Local   oButDMar := NIL
	Local   oButInv  := NIL
	Local   oSay     := NIL
	Local   oOk      := LoadBitmap( GetResources(), 'LBOK' )
	Local   oNo      := LoadBitmap( GetResources(), 'LBNO' )
	Local   lChk     := .F.
	Local   lOk      := .F.
	Local   lTeveMarc:= .F.
	Local   cVar     := ''
	Local   cNomEmp  := ''
	Local   cMascEmp := '??'
	Local   cMascFil := '??'
	
	Local   aMarcadas  := {}
	
	
	If !MyOpenSm0Ex()
		ApMsgStop( 'Nใo foi possํvel abrir SM0 exclusivo.' )
		Return aRet
	EndIf
	
	
	dbSelectArea( 'SM0' )
	aSalvSM0 := SM0->( GetArea() )
	dbSetOrder( 1 )
	dbGoTop()
	
	While !SM0->( EOF() )
		
		If aScan( aVetor, {|x| x[2] == SM0->M0_CODIGO} ) == 0
			aAdd(  aVetor, { aScan( aMarcadas, {|x| x[1] == SM0->M0_CODIGO .and. x[2] == SM0->M0_CODFIL} ) > 0, SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_NOME, SM0->M0_FILIAL } )
		EndIf
		
		dbSkip()
	End
	
	RestArea( aSalvSM0 )
	
	Define MSDialog  oDlg Title '' From 0, 0 To 270, 396 Pixel
	
	oDlg:cToolTip := 'Tela para M๚ltiplas Sele็๕es de Empresas/Filiais'
	
	oDlg:cTitle := 'Selecione a(s) Empresa(s) para Atualiza็ใo'
	
	@ 10, 10 Listbox  oLbx Var  cVar Fields Header ' ', ' ', 'Empresa' Size 178, 095 Of oDlg Pixel
	oLbx:SetArray(  aVetor )
	oLbx:bLine := {|| {IIf( aVetor[oLbx:nAt, 1], oOk, oNo ), ;
		aVetor[oLbx:nAt, 2], ;
		aVetor[oLbx:nAt, 4]}}
	oLbx:BlDblClick := { || aVetor[oLbx:nAt, 1] := !aVetor[oLbx:nAt, 1], VerTodos( aVetor, @lChk, oChkMar ), oChkMar:Refresh(), oLbx:Refresh()}
	oLbx:cToolTip   :=  oDlg:cTitle
	oLbx:lHScroll   := .F. // NoScroll
	
	@ 112, 10 CheckBox oChkMar Var  lChk Prompt 'Todos'   Message 'Marca / Desmarca Todos' Size 40, 007 Pixel Of oDlg;
		on Click MarcaTodos( lChk, @aVetor, oLbx )
	
	@ 123, 10 Button oButInv Prompt '&Inverter'  Size 32, 12 Pixel Action ( InvSelecao( @aVetor, oLbx, @lChk, oChkMar ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message 'Inverter Sele็ใo' Of oDlg
	
	// Marca/Desmarca por mascara
	@ 113, 51 Say  oSay Prompt 'Empresa' Size  40, 08 Of oDlg Pixel
	@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
		Message 'Mแscara Empresa ( ?? )'  Of oDlg
	@ 123, 50 Button oButMarc Prompt '&Marcar'    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message 'Marcar usando mแscara ( ?? )'    Of oDlg
	@ 123, 80 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
		Message 'Desmarcar usando mแscara ( ?? )' Of oDlg
	
	Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a Sele็ใo'  Enable Of oDlg
	Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop 'Abandona a Sele็ใo' Enable Of oDlg
	Activate MSDialog  oDlg Center
	
	RestArea( aSalvAmb )
	dbSelectArea( 'SM0' )
	dbCloseArea()
	
Return  aRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMARCATODOSบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para marcar/desmarcar todos os itens do    บฑฑ
ฑฑบ          ณ ListBox ativo                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
	Local  nI := 0
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := lMarca
	Next nI
	
	oLbx:Refresh()
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณINVSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar para inverter selecao do ListBox Ativo     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function InvSelecao( aVetor, oLbx )
	Local  nI := 0
	
	For nI := 1 To Len( aVetor )
		aVetor[nI][1] := !aVetor[nI][1]
	Next nI
	
	oLbx:Refresh()
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณRETSELECAOบAutor  ณ Ernani Forastieri  บ Data ณ  27/09/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao Auxiliar que monta o retorno com as selecoes        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RetSelecao( aRet, aVetor )
	Local  nI    := 0
	
	aRet := {}
	For nI := 1 To Len( aVetor )
		If aVetor[nI][1]
			aAdd( aRet, { aVetor[nI][2] , aVetor[nI][3], aVetor[nI][2] +  aVetor[nI][3] } )
		EndIf
	Next nI
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ MARCAMAS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao para marcar/desmarcar usando mascaras               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MarcaMas( oLbx, aVetor, cMascEmp, lMarDes )
	Local cPos1 := SubStr( cMascEmp, 1, 1 )
	Local cPos2 := SubStr( cMascEmp, 2, 1 )
	Local nPos  := oLbx:nAt
	Local nZ    := 0
	
	For nZ := 1 To Len( aVetor )
		If cPos1 == '?' .or. SubStr( aVetor[nZ][2], 1, 1 ) == cPos1
			If cPos2 == '?' .or. SubStr( aVetor[nZ][2], 2, 1 ) == cPos2
				aVetor[nZ][1] :=  lMarDes
			EndIf
		EndIf
	Next
	
	oLbx:nAt := nPos
	oLbx:Refresh()
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ VERTODOS บAutor  ณ Ernani Forastieri  บ Data ณ  20/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao auxiliar para verificar se estao todos marcardos    บฑฑ
ฑฑบ          ณ ou nao                                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerTodos( aVetor, lChk, oChkMar )
	Local lTTrue := .T.
	Local nI     := 0
	
	For nI := 1 To Len( aVetor )
		lTTrue := IIf( !aVetor[nI][1], .F., lTTrue )
	Next nI
	
	lChk := IIf( lTTrue, .T., .F. )
	oChkMar:Refresh()
	
Return NIL


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM บ Autor ณ Microsiga          บ Data ณ  03/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑณ Uso      ณ MyOpenSM - V.3.5                                           ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MyOpenSM0Ex()
	
	Local lOpen := .F.
	Local nLoop := 0
	
	For nLoop := 1 To 20
		dbUseArea( .T., , 'SIGAMAT.EMP', 'SM0', .F., .F. )
		
		If !Empty( Select( 'SM0' ) )
			lOpen := .T.
			dbSetIndex( 'SIGAMAT.IND' )
			Exit
		EndIf
		
		Sleep( 500 )
		
	Next nLoop
	
	If !lOpen
		ApMsgStop( 'Nใo foi possํvel a abertura da tabela ' + ;
			'de empresas de forma exclusiva.', 'ATENวรO' )
	EndIf
	
Return lOpen

/////////////////////////////////////////////////////////////////////////////


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ AdCampo  บAutor  ณ Devair F Tonon     บ Data ณ  30/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que adiciona o conteudo do arquivo no array do SX   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AdCampo(_aSX, _cAlias, _aStrut)
	Local nI:=1
	Local nJ:=1
	Local aItSX:={}
	
	dbSelectArea(_cAlias)
	(_cAlias)->(dbGotop())
	
	
	while (_cAlias)->(!eof())
		
		for nI:=1 to Len(_aStrut)
			
			AADD(aItSX,(_cAlias)->(FieldGet(nI)))
			
		next
		AADD(_aSX, aItSX)
		aItSX:={}
		
		(_cAlias)->(dbSkip())
	enddo
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ AdCampo  บAutor  ณ Devair F Tonon     บ Data ณ  30/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao que adiciona o conteudo do arquivo no array do SX   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LerSX(cFileSX, cAls)
	
	USE &cFileSX ALIAS &cAls NEW
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ LerHLP   บAutor  ณ Devair F Tonon     บ Data ณ  30/06/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Funcao ler o conteudo de um arquivo CSV que contem a descriบฑฑ
ฑฑบ          ณ cao do help de cada campo                                  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบEstrutura ณ VAR; PORTUGUES; INGLES; ESPANHOL                           บฑฑ
ฑฑบ          ณ 	VAR = Nome do campo da SX3                              บฑฑ
ฑฑบ          ณ 	PORTUGUES = Texto do help em portugues                  บฑฑ
ฑฑบ          ณ 	INGLES = Texto do help em ingles                        บฑฑ
ฑฑบ          ณ 	ESPANHOL = Texto do help em espanhol                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Generico                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LerHLP(cFileHLP, aHLP)
	Local nHDL  :=-1
	Local lRet  :=.T.
	Local aLine :={}
	Local aUmHlp:={}
	Local nTam  :=40 //tamanho da linha do help
	
	nHDL:=FT_FUse(cFileHLP)
	
	if nHDL ==-1
		
		lRet:=.F.
		
	else
		
		while !FT_FEOF()
			cLine:=FT_FReadLn()
			
			if empty(cLine)
				FT_FSkip()
				loop
			EndIf
			
			aLine:=StrTokArr ( cLine, ";" )
			
			if aLine[1]=='VAR'
				FT_FSKIP()
				loop
			endif
			
			
			
			//lendo o texto de cada idioma
			for nJ:=2 to len(aLine)
				
				aUmHpl:={}
				
				//quebrando o texto de cada idioma ate o tamanho nTam
				for nX:=1 to len(aline[nj]) step nTam
					
					ctexto:=substr(aLine[nJ],nX,nTam)
					
					AADD(aUmHpl,cTexto)
					
				next
				
				aLine[nJ]:=aUmHpl
				
			next
			
			AADD(aHLP,aLine)
			
			FT_FSKIP()
		enddo
		FT_FUSE(cFileHLP)
	endif
	
Return lRet


