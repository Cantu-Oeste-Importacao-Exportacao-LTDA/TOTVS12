#INCLUDE 'PROTHEUS.CH'
#DEFINE SIMPLES Char( 39 )
#DEFINE DUPLAS  Char( 34 )

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � UPDCANTU � 												  ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de update dos dicion�rios para compatibiliza��o     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
*/
User Function UPDCNT3()

Local   aSay     := {'CRIA��O DE CAMPOS E TABELAS'}
Local   aButton  := {}
Local   aMarcadas:= {}
Local   cTitulo  := 'UPDCNT3'
Local   lOk      := .F.

Private oMainWnd  := NIL
Private oProcess  := NIL  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

#IFDEF TOP
    TCInternal( 5, '*OFF' ) // Desliga Refresh no Lock do Top
#ENDIF

__cInterNet := NIL
__lPYME     := .F.

Set Dele On

// Botoes Tela Inicial
aAdd(  aButton, {  1, .T., { || lOk := .T., FechaBatch() } } )
aAdd(  aButton, {  2, .T., { || lOk := .F., FechaBatch() } } )

FormBatch(  cTitulo,  aSay,  aButton )

If lOk
	aMarcadas := EscEmpresa()

	If !Empty( aMarcadas )
		If  ApMsgNoYes( 'Confirma a atualiza��o dos dicion�rios ?', cTitulo )
			oProcess := MsNewProcess():New( { | lEnd | lOk := FSTProc( @lEnd, aMarcadas ) }, 'Atualizando', 'Aguarde, atualizando ...', .F. )
			oProcess:Activate()
	
			If lOk
				Final( 'Atualiza��o Conclu�da.' )
			Else
				Final( 'Atualiza��o n�o Realizada.' )
			EndIf

		Else
			Final( 'Atualiza��o n�o Realizada.' )

		EndIf

	Else
		Final( 'Atualiza��o n�o Realizada.' )

	EndIf

EndIf

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSTProc  � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da grava��o dos arquivos           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSTProc  - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX2         �
			//������������������������������������
			//oProcess:IncRegua1( 'Dicion�rio de arquivos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
			;;cTexto += FSAtuSX2()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX3         �
			//������������������������������������
			cTexto += FSAtuSX3()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SIX         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de �ndices - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			cTexto += FSAtuSIX()

			oProcess:IncRegua1( 'Dicion�rio de dados - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			oProcess:IncRegua2( 'Atualizando campos/�ndices')


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
					ApMsgStop( 'Ocorreu um erro desconhecido durante a atualiza��o da tabela : ' + aArqUpd[nx] + '. Verifique a integridade do dicion�rio e da tabela.', 'ATEN��O' )
					cTexto += 'Ocorreu um erro desconhecido durante a atualiza��o da estrutura da tabela : ' + aArqUpd[nx] + CRLF
				EndIf

			Next nX

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX6         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de par�metros - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
			cTexto += FSAtuSX6()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX7         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de gatilhos - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
			cTexto += FSAtuSX7()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SXA         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de pastas - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
			cTexto += FSAtuSXA()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SXB         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de consultas padr�o - ' + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...'  )
			cTexto += FSAtuSXB()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX5         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de tabelas sistema - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			cTexto += FSAtuSX5()

			//����������������������������������Ŀ
			//�Atualiza o dicion�rio SX9         �
			//������������������������������������
			oProcess:IncRegua1( 'Dicion�rio de relacionamentos - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			cTexto += FSAtuSX9()

			//����������������������������������Ŀ
			//�Atualiza os helps                 �
			//������������������������������������
			oProcess:IncRegua1( 'Helps de Campo - '  + SM0->M0_CODIGO + ' ' + SM0->M0_NOME + ' ...' )
			cTexto += FSAtuHlp()
                               
    		IF !CHKFILE("ZBB")  
	    		Final( 'Erro ao criar tabela ZBB' )
	    		lRet := .F.
	    	ENDIF
	    	
			RpcClearEnv()

			If !( lOpen := MyOpenSm0Ex() )
				Exit
			EndIf

		Next nI

		If lOpen

			cAux += Replicate( '-', 128 ) + CRLF
			cAux += Replicate( ' ', 128 ) + CRLF
			cAux += 'LOG DA ATUALIZACAO DOS DICION�RIOS' + CRLF
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX2 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX2 - Arquivos      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX2 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX2()
Local aSX2      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local cAlias    := ''
Local cTexto    := 'Inicio da Atualizacao do SX2' + CRLF + CRLF
Local cPath     := ''
Local cEmpr     := ''

aEstrut := { 'X2_CHAVE', 'X2_PATH', 'X2_ARQUIVO', 'X2_NOME', 'X2_NOMESPA', 'X2_NOMEENG', 'X2_DELET', ;
             'X2_MODO' , 'X2_TTS' , 'X2_ROTINA' , 'X2_PYME', 'X2_UNICO'  , 'X2_MODULO' }

dbSelectArea( 'SX2' )
SX2->( dbSetOrder( 1 ) )
SX2->( dbGoTop() )
cPath := SX2->X2_PATH
cEmpr := Substr( SX2->X2_ARQUIVO, 4 )

//
// Tabela ZBB
//
aAdd( aSX2, { ;
	'ZBB'																	, ; //X2_CHAVE
	cPath																	, ; //X2_PATH
	'ZBB'+cEmpr																, ; //X2_ARQUIVO
	'ESTABELECIMENTO X EMP X FILIAL'												, ; //X2_NOME
	'ESTABELECIMENTO X EMP X FILIAL'												, ; //X2_NOMESPA
	'ESTABELECIMENTO X EMP X FILIAL'												, ; //X2_NOMEENG
	0																		, ; //X2_DELET
	'C'																		, ; //X2_MODO
	''																		, ; //X2_TTS
	''																		, ; //X2_ROTINA
	''																		, ; //X2_PYME
	''																		, ; //X2_UNICO
	0																		} ) //X2_MODULO

// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX2 ) )

dbSelectArea( 'SX2' )
dbSetOrder( 1 )

For nI := 1 To Len( aSX2 )

	If !SX2->( dbSeek( aSX2[nI][1] ) )

		If !( aSX2[nI][1] $ cAlias )
			cAlias += aSX2[nI][1] + '/'
			cTexto += 'Foi inclu�da a tabela ' + aSX2[nI][1] + CRLF
		EndIf

		RecLock( 'SX2', .T. )
		For nJ := 1 To Len( aSX2[nI] )
			If FieldPos( aEstrut[nJ] ) > 0
				If AllTrim( aEstrut[nJ] ) == 'X2_ARQUIVO'
					FieldPut( FieldPos( aEstrut[nJ] ), SubStr( aSX2[nI][nJ], 1, 3 ) + cEmpAnt +  '0' )
				Else
					FieldPut( FieldPos( aEstrut[nJ] ), aSX2[nI][nJ] )
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX3 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX3 - Campos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX3 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX3()
Local aSX3      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX3->X3_CAMPO )
Local cAlias    := ''
Local cAliasAtu := ''
Local cSeqAtu   := ''
Local nSeqAtu   := 0
Local cTexto    := 'Inicio da Atualizacao do SX3' + CRLF + CRLF

aEstrut := { 'X3_ARQUIVO', 'X3_ORDEM'  , 'X3_CAMPO'  , 'X3_TIPO'   , 'X3_TAMANHO', 'X3_DECIMAL', ;
             'X3_TITULO' , 'X3_TITSPA' , 'X3_TITENG' , 'X3_DESCRIC', 'X3_DESCSPA', 'X3_DESCENG', ;
             'X3_PICTURE', 'X3_VALID'  , 'X3_USADO'  , 'X3_RELACAO', 'X3_F3'     , 'X3_NIVEL'  , ;
             'X3_RESERV' , 'X3_CHECK'  , 'X3_TRIGGER', 'X3_PROPRI' , 'X3_BROWSE' , 'X3_VISUAL' , ;
             'X3_CONTEXT', 'X3_OBRIGAT', 'X3_VLDUSER', 'X3_CBOX'   , 'X3_CBOXSPA', 'X3_CBOXENG', ;
             'X3_PICTVAR', 'X3_WHEN'   , 'X3_INIBRW' , 'X3_GRPSXG' , 'X3_FOLDER' , 'X3_PYME'   }

//
// Tabela ZX3
//
aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'130'																	, ; //X3_ORDEM
	'C5_XTID'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
		20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TID'																, ; //X3_TITULO
	'TID'																, ; //X3_TITSPA
	'TID'																, ; //X3_TITENG
	'TID'														, ; //X3_DESCRIC
	'TID'																, ; //X3_DESCSPA
	'TID'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME      
	
aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'131'																	, ; //X3_ORDEM
	'C5_XAUTO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'AUTO'															  		, ; //X3_TITULO
	'AUTO'															  		, ; //X3_TITSPA
	'AUTO'															  		, ; //X3_TITENG
	'AUTO'																	, ; //X3_DESCRIC
	'AUTO'															   		, ; //X3_DESCSPA
	'AUTO'												   					, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	

aAdd( aSX3, { ;
	'SC5'																	, ; //X3_ARQUIVO
	'132'																	, ; //X3_ORDEM
	'C5_XINST'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Instituicao'																, ; //X3_TITULO
	'Instituicao'																, ; //X3_TITSPA
	'Instituicao'																, ; //X3_TITENG
	'Instituicao'						  										, ; //X3_DESCRIC
	'Instituicao'																, ; //X3_DESCSPA
	'Instituicao'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	       
	
aAdd( aSX3, { ;
	'SE1'																	, ; //X3_ARQUIVO
	'265'																	, ; //X3_ORDEM
	'E1_XTID'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TID'																, ; //X3_TITULO
	'TID'																, ; //X3_TITSPA
	'TID'																, ; //X3_TITENG
	'TID'														, ; //X3_DESCRIC
	'TID'																, ; //X3_DESCSPA
	'TID'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME      
	
aAdd( aSX3, { ;
	'SE1'																	, ; //X3_ARQUIVO
	'266'																	, ; //X3_ORDEM
	'E1_XAUTO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'AUTO'															  		, ; //X3_TITULO
	'AUTO'															  		, ; //X3_TITSPA
	'AUTO'															  		, ; //X3_TITENG
	'AUTO'																	, ; //X3_DESCRIC
	'AUTO'															   		, ; //X3_DESCSPA
	'AUTO'												   					, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	

aAdd( aSX3, { ;
	'SE1'																	, ; //X3_ARQUIVO
	'267'																	, ; //X3_ORDEM
	'E1_XINST'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Instituicao'																, ; //X3_TITULO
	'Instituicao'																, ; //X3_TITSPA
	'Instituicao'																, ; //X3_TITENG
	'Instituicao'						  										, ; //X3_DESCRIC
	'Instituicao'																, ; //X3_DESCSPA
	'Instituicao'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	       
  
aAdd( aSX3, { ;
	'ZB9'																	, ; //X3_ARQUIVO
	'09'																	, ; //X3_ORDEM
	'ZB9_XTID'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	20																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'TID'																, ; //X3_TITULO
	'TID'																, ; //X3_TITSPA
	'TID'																, ; //X3_TITENG
	'TID'														, ; //X3_DESCRIC
	'TID'																, ; //X3_DESCSPA
	'TID'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME      
	
aAdd( aSX3, { ;
	'ZB9'																	, ; //X3_ARQUIVO
	'10'																	, ; //X3_ORDEM
	'ZB9_XAUTO'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'AUTO'															  		, ; //X3_TITULO
	'AUTO'															  		, ; //X3_TITSPA
	'AUTO'															  		, ; //X3_TITENG
	'AUTO'																	, ; //X3_DESCRIC
	'AUTO'															   		, ; //X3_DESCSPA
	'AUTO'												   					, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	

aAdd( aSX3, { ;
	'ZB9'																	, ; //X3_ARQUIVO
	'11'																	, ; //X3_ORDEM
	'ZB9_XINST'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Instituicao'																, ; //X3_TITULO
	'Instituicao'																, ; //X3_TITSPA
	'Instituicao'																, ; //X3_TITENG
	'Instituicao'						  										, ; //X3_DESCRIC
	'Instituicao'																, ; //X3_DESCSPA
	'Instituicao'																, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																		, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME 
	
	//
// Tabela ZX4
//
aAdd( aSX3, { ;
	'ZBB'																	, ; //X3_ARQUIVO
	'01'																	, ; //X3_ORDEM
	'ZBB_FILIAL'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Sucursal'																, ; //X3_TITSPA
	'Branch'																, ; //X3_TITENG
	'Filial do Sistema'														, ; //X3_DESCRIC
	'Sucursal'																, ; //X3_DESCSPA
	'Branch of the System'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'N'																		, ; //X3_BROWSE
	''																		, ; //X3_VISUAL
	''																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	'033'																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME    
	

aAdd( aSX3, { ;
	'ZBB'																	, ; //X3_ARQUIVO
	'02'																	, ; //X3_ORDEM
	'ZBB_EMPEST'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Empresa'																, ; //X3_TITULO
	'Empresa'																, ; //X3_TITSPA
	'Empresa'																, ; //X3_TITENG
	'Empresa'														, ; //X3_DESCRIC
	'Empresa'																, ; //X3_DESCSPA
	'Empresa'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME

aAdd( aSX3, { ;
	'ZBB'																	, ; //X3_ARQUIVO
	'03'																	, ; //X3_ORDEM
	'ZBB_FILEST'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	2																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Filial'																, ; //X3_TITULO
	'Filial'																, ; //X3_TITSPA
	'Filial'																, ; //X3_TITENG
	'Filial'														, ; //X3_DESCRIC
	'Filial'																, ; //X3_DESCSPA
	'Filial'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME
	
aAdd( aSX3, { ;
	'ZBB'																	, ; //X3_ARQUIVO
	'04'																	, ; //X3_ORDEM
	'ZBB_ESTAB'															, ; //X3_CAMPO
	'C'																		, ; //X3_TIPO
	10																		, ; //X3_TAMANHO
	0																		, ; //X3_DECIMAL
	'Estabelecimento'																, ; //X3_TITULO
	'Estabelecimento'																, ; //X3_TITSPA
	'Estabelecimento'																, ; //X3_TITENG
	'Estabelecimento'														, ; //X3_DESCRIC
	'Estabelecimento'																, ; //X3_DESCSPA
	'Estabelecimento'													, ; //X3_DESCENG
	'@!'																	, ; //X3_PICTURE
	''																		, ; //X3_VALID
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(128) + ;
	Chr(128) + Chr(128) + Chr(128) + Chr(128) + Chr(160)					, ; //X3_USADO
	''																		, ; //X3_RELACAO
	''																		, ; //X3_F3
	1																		, ; //X3_NIVEL
	Chr(254) + Chr(192)														, ; //X3_RESERV
	''																		, ; //X3_CHECK
	''																		, ; //X3_TRIGGER
	'U'																		, ; //X3_PROPRI
	'S'																		, ; //X3_BROWSE
	'A'																		, ; //X3_VISUAL
	'R'																		, ; //X3_CONTEXT
	''																		, ; //X3_OBRIGAT
	''																		, ; //X3_VLDUSER
	''																		, ; //X3_CBOX
	''																		, ; //X3_CBOXSPA
	''																		, ; //X3_CBOXENG
	''																		, ; //X3_PICTVAR
	''																		, ; //X3_WHEN
	''																		, ; //X3_INIBRW
	''																	, ; //X3_GRPSXG
	''																		, ; //X3_FOLDER
	''																		} ) //X3_PYME	 	  
//
// Atualizando dicion�rio
//
aSort( aSX3,,, { |x,y| x[1]+x[2]+x[3] < y[1]+y[2]+y[3] } )

oProcess:SetRegua2( Len( aSX3 ) )

dbSelectArea( 'SX3' )
dbSetOrder( 2 )
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

				If ApMsgNoYes( 'O campo ' + aSX3[nI][3] + ' est� com o ' + SX3->( FieldName( nJ ) ) + ;
					' com o conte�do' + CRLF + ;
					'[' + RTrim( AllToChar( SX3->( FieldGet( nJ ) ) ) ) + ']' + CRLF + ;
					'que ser� substituido pelo NOVO conte�do' + CRLF + ;
					'[' + RTrim( AllToChar( aSX3[nI][nJ] ) ) + ']' + CRLF + ;
					'Deseja substituir ? ', 'Confirmar substitui��o de conte�do' )

					cTexto += 'Alterado o campo ' + aSX3[nI][3] + CRLF
					cTexto += '   ' + PadR( SX3->( FieldName( nJ ) ), 10 ) + ' de [' + AllToChar( SX3->( FieldGet( nJ ) ) ) + ']' + CRLF
					cTexto += '            para [' + AllToChar( aSX3[nI][nJ] )          + ']' + CRLF + CRLF

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

cTexto += CRLF + 'Final da Atualizacao do SX3' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSIX � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SIX - Indices       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSIX - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSIX()
Local cTexto    := 'Inicio da Atualizacao do SIX' + CRLF + CRLF
Local cAlias    := ''
Local lDelInd   := .F.
Local aSIX      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local lAlt      := .F.
Local cSeq      := ''

aEstrut := { 'INDICE' , 'ORDEM' , 'CHAVE', 'DESCRICAO', 'DESCSPA'  , ;
             'DESCENG', 'PROPRI', 'F3'   , 'NICKNAME' , 'SHOWPESQ' }

//
// Tabela ZBB
//
aAdd( aSIX, { ;
	'ZBB'																	, ; //INDICE
	'1'																		, ; //ORDEM
	'ZBB_FILIAL+ZBB_ESTAB'													, ; //CHAVE
	'ZBB_FILIAL+ZBB_ESTAB'															, ; //DESCRICAO
	'ZBB_FILIAL+ZBB_ESTAB'															, ; //DESCSPA
	'ZBB_FILIAL+ZBB_ESTAB'															, ; //DESCENG
	'U'																		, ; //PROPRI
	''																		, ; //F3
	''																		, ; //NICKNAME
	'S'																		} ) //SHOWPESQ
          
//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSIX ) )

dbSelectArea( 'SIX' )
SIX->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSIX )
	lAlt := .F.

	If !SIX->( dbSeek( aSIX[nI][1] + aSIX[nI][2] ) )
		RecLock( 'SIX', .T. )
		lDelInd := .F.
		cTexto += '�ndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
	Else
		lDelInd := .F.
		If Upper(AllTrim(SIX->CHAVE)) <> Upper(AllTrim(aSIX[nI][3]))
			If Empty(aSIX[nI][9]) //Nickname em branco
				If ApMsgYesNo('O indice da tabela ' + aSIX[nI][1] + ' definido como ordem ' + aSIX[nI][2] + ' no UPDATE j� existe no dicionario da empresa: ' + SM0->M0_CODIGO + ' com uma CHAVE diferente da do UPDATE. Voc� confirma essa alteracao ? OBS: NAO FOI ESPECIFICADO UM NICKNAME PARA ESSE INDICE. PODEM OCORRER ERROS NA EXECUCAO DAS ROTINAS ENVOLVIDAS SE FOR CONFIRMADA ESSA OPCAO.')
					lDelInd := .T.
					RecLock( 'SIX', .F. )
				Else
					cTexto += 'ATENCAO, o indice da tabela ' + aSIX[nI][1] + ' ordem ' + aSIX[nI][2] + ' com a expressao ' + aSIX[nI][3] + ' nao foi atualizado pelo UPDATE.' + CRLF	
					Loop
				EndIf
			Else
				If ApMsgYesNo('O indice da tabela ' + aSIX[nI][1] + ' definido como ordem ' + aSIX[nI][2] + ' no UPDATE j� existe no dicionario da empresa: ' + SM0->M0_CODIGO + ' com uma CHAVE diferente da do UPDATE. Voc� confirma a numeracao automatica desse indice ? OBS: FOI ESPECIFICADO UM NICKNAME PARA ESSE INDICE.')
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
					cTexto += '�ndice criado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
				Else
					cTexto += 'ATENCAO, o indice da tabela ' + aSIX[nI][1] + ' ordem ' + aSIX[nI][2] + ' com a expressao ' + aSIX[nI][3] + ' nao foi atualizado pelo UPDATE.' + CRLF	
					Loop
				EndIf
			EndIf
		Else
			lDelInd := .T.
			cTexto += '�ndice alterado ' + aSIX[nI][1] + '/' + aSIX[nI][2] + ' - ' + aSIX[nI][3] + CRLF
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
			If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSIX[nI][nJ] )
			EndIf
		Next nJ

		dbCommit()
		MsUnLock()

		If lDelInd
			TcInternal( 60, RetSqlName( aSIX[nI][1] ) + '|' + RetSqlName( aSIX[nI][1] ) + aSIX[nI][2] ) // Exclui sem precisar baixar o TOP
		EndIf

	EndIf

	oProcess:IncRegua2( 'Atualizando �ndices...' )

Next nI

cTexto += CRLF + CRLF + 'Final da Atualizacao do SIX' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX6 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX6 - Par�metros    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX6 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX6()
Local aSX6      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local cAlias    := ''
Local cTexto    := 'Inicio da Atualizacao do SX6' + CRLF + CRLF
Local lReclock  := .T.
Local lContinua := .T.

aEstrut := { 'X6_FIL'    , 'X6_VAR'  , 'X6_TIPO'   , 'X6_DESCRIC', 'X6_DSCSPA' , 'X6_DSCENG' , 'X6_DESC1'  , 'X6_DSCSPA1',;
             'X6_DSCENG1', 'X6_DESC2', 'X6_DSCSPA2', 'X6_DSCENG2', 'X6_CONTEUD', 'X6_CONTSPA', 'X6_CONTENG', 'X6_PROPRI' }

cTexto += CRLF + 'Final da Atualizacao do SX6' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX7 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX7 - Gatilhos      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX7 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX7()
Local aSX7      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX7->X7_CAMPO )
Local cAlias    := ''
Local cTexto    := 'Inicio da Atualizacao do SX7' + CRLF + CRLF

aEstrut := { 'X7_CAMPO', 'X7_SEQUENC', 'X7_REGRA', 'X7_CDOMIN', 'X7_TIPO', 'X7_SEEK', ;
             'X7_ALIAS', 'X7_ORDEM'  , 'X7_CHAVE', 'X7_PROPRI', 'X7_CONDIC' }

cTexto += CRLF + 'Final da Atualizacao do SX7' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSXA � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SXA - Pastas        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSXA - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSXA()
Local aSXA      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local cAlias    := ''
Local cTexto    := 'Inicio da Atualizacao do SXA' + CRLF + CRLF

aEstrut := { 'XA_ALIAS', 'XA_ORDEM', 'XA_DESCRIC', 'XA_DESCSPA', 'XA_DESCENG', 'XA_PROPRI' }

cTexto += CRLF + 'Final da Atualizacao do SXA' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSXB � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SXB - Consultas Pad ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSXB - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSXB()
Local aSXB      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local cAlias    := 'Inicio da Atualizacao do SXB' + CRLF + CRLF
Local cTexto    := ''

aEstrut := { 'XB_ALIAS',  'XB_TIPO'   , 'XB_SEQ'    , 'XB_COLUNA' , ;
             'XB_DESCRI', 'XB_DESCSPA', 'XB_DESCENG', 'XB_CONTEM' }

cTexto += CRLF + 'Final da Atualizacao do SXB' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX5 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX5 - Indices       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX5 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX5()
Local cTexto    := 'Inicio Atualizacao SX5' + CRLF + CRLF
Local cAlias    := ''
Local aSX5      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0

aEstrut := { 'X5_FILIAL', 'X5_TABELA', 'X5_CHAVE', 'X5_DESCRI', 'X5_DESCSPA', 'X5_DESCENG' }

//
// Atualizando dicion�rio
//
oProcess:SetRegua2( Len( aSX5 ) )

dbSelectArea( 'SX5' )
SX5->( dbSetOrder( 1 ) )

For nI := 1 To Len( aSX5 )

	oProcess:IncRegua2( 'Atualizando tabelas...' )

	If !SX5->( dbSeek( aSX5[nI][1] + aSX5[nI][2] + aSX5[nI][3]) )
		cTexto += 'Item da tabela criado. Tabela '   + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
		RecLock( 'SX5', .T. )
	Else
		cTexto += 'Item da tabela alterado. Tabela ' + AllTrim( aSX5[nI][1] ) + aSX5[nI][2] + '/' + aSX5[nI][3] + CRLF
		RecLock( 'SX5', .F. )
	EndIf

	For nJ := 1 To Len( aSX5[nI] )
		If FieldPos( aEstrut[nJ] ) > 0
			FieldPut( FieldPos( aEstrut[nJ] ), aSX5[nI][nJ] )
		EndIf
	Next nJ

	MsUnLock()

	aAdd( aArqUpd, aSX5[nI][1] )

	If !( aSX5[nI][1] $ cAlias )
		cAlias += aSX5[nI][1] + '/'
	EndIf

Next nI

cTexto += CRLF + 'Final da Atualizacao do SX5' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuSX9 � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao do SX9 - Relacionament ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuSX9 - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuSX9()
Local aSX9      := {}
Local aEstrut   := {}
Local nI        := 0
Local nJ        := 0
Local nTamSeek  := Len( SX9->X9_DOM )
Local cAlias    := ''
Local cTexto    := 'Inicio da Atualizacao do SX9' + CRLF + CRLF

aEstrut := { 'X9_DOM'   , 'X9_IDENT'  , 'X9_CDOM'   , 'X9_EXPDOM', 'X9_EXPCDOM' ,'X9_PROPRI', ;
             'X9_LIGDOM', 'X9_LIGCDOM', 'X9_CONDSQL', 'X9_USEFIL', 'X9_ENABLE' }

cTexto += CRLF + 'Final da Atualizacao do SX9' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � FSAtuHlp � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento da gravacao dos Helps de Campos    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � FSAtuHlp - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function FSAtuHlp()
Local aHlpPor   := {}
Local aHlpEng   := {}
Local aHlpSpa   := {}
Local cTexto    := 'Inicio da Atualizacao ds Helps de Campos' + CRLF + CRLF

oProcess:IncRegua2(  'Atualizando Helps de Campos ...' )

cTexto += CRLF + 'Final da Atualizacao dos Helps de Campos' + CRLF + Replicate( '-', 128 ) + CRLF + CRLF

Return cTexto


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �ESCEMPRESA�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Generica para escolha de Empresa, montado pelo SM0_ ���
���          � Retorna vetor contendo as selecoes feitas.                 ���
���          � Se nao For marcada nenhuma o vetor volta vazio.            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function EscEmpresa()
//��������������������������������������������Ŀ
//� Parametro  nTipo                           �
//� 1  - Monta com Todas Empresas/Filiais      �
//� 2  - Monta so com Empresas                 �
//� 3  - Monta so com Filiais de uma Empresa   �
//�                                            �
//� Parametro  aMarcadas                       �
//� Vetor com Empresas/Filiais pre marcadas    �
//�                                            �
//� Parametro  cEmpSel                         �
//� Empresa que sera usada para montar selecao �
//����������������������������������������������
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
	ApMsgStop( 'N�o foi poss�vel abrir SM0 exclusivo.' )
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

oDlg:cToolTip := 'Tela para M�ltiplas Sele��es de Empresas/Filiais'

oDlg:cTitle := 'Selecione a(s) Empresa(s) para Atualiza��o'

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
Message 'Inverter Sele��o' Of oDlg

// Marca/Desmarca por mascara
@ 113, 51 Say  oSay Prompt 'Empresa' Size  40, 08 Of oDlg Pixel
@ 112, 80 MSGet  oMascEmp Var  cMascEmp Size  05, 05 Pixel Picture '@!'  Valid (  cMascEmp := StrTran( cMascEmp, ' ', '?' ), cMascFil := StrTran( cMascFil, ' ', '?' ), oMascEmp:Refresh(), .T. ) ;
Message 'M�scara Empresa ( ?? )'  Of oDlg
@ 123, 50 Button oButMarc Prompt '&Marcar'    Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .T. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Marcar usando m�scara ( ?? )'    Of oDlg
@ 123, 80 Button oButDMar Prompt '&Desmarcar' Size 32, 12 Pixel Action ( MarcaMas( oLbx, aVetor, cMascEmp, .F. ), VerTodos( aVetor, @lChk, oChkMar ) ) ;
Message 'Desmarcar usando m�scara ( ?? )' Of oDlg

Define SButton From 111, 125 Type 1 Action ( RetSelecao( @aRet, aVetor ), oDlg:End() ) OnStop 'Confirma a Sele��o'  Enable Of oDlg
Define SButton From 111, 158 Type 2 Action ( IIf( lTeveMarc, aRet :=  aMarcadas, .T. ), oDlg:End() ) OnStop 'Abandona a Sele��o' Enable Of oDlg
Activate MSDialog  oDlg Center

RestArea( aSalvAmb )
dbSelectArea( 'SM0' )
dbCloseArea()

Return  aRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �MARCATODOS�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para marcar/desmarcar todos os itens do    ���
���          � ListBox ativo                                              ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MarcaTodos( lMarca, aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := lMarca
Next nI

oLbx:Refresh()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �INVSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar para inverter selecao do ListBox Ativo     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function InvSelecao( aVetor, oLbx )
Local  nI := 0

For nI := 1 To Len( aVetor )
	aVetor[nI][1] := !aVetor[nI][1]
Next nI

oLbx:Refresh()

Return NIL


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �RETSELECAO�Autor  � Ernani Forastieri  � Data �  27/09/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao Auxiliar que monta o retorno com as selecoes        ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � MARCAMAS �Autor  � Ernani Forastieri  � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao para marcar/desmarcar usando mascaras               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    � VERTODOS �Autor  � Ernani Forastieri  � Data �  20/11/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Funcao auxiliar para verificar se estao todos marcardos    ���
���          � ou nao                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Generico                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � MyOpenSM � Autor � Microsiga          � Data �  03/10/11   ���
�������������������������������������������������������������������������͹��
��� Descricao� Funcao de processamento abertura do SM0 modo exclusivo     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
��� Uso      � MyOpenSM - V.3.5                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
	ApMsgStop( 'N�o foi poss�vel a abertura da tabela ' + ;
		'de empresas de forma exclusiva.', 'ATEN��O' )
EndIf

Return lOpen


/////////////////////////////////////////////////////////////////////////////
	