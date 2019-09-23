#Include "Protheus.Ch"
#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"      
#INCLUDE 'TBICONN.CH'


/*/{Protheus.doc} AFIN003
Interface para seleção de titulos de NCC para
geração de titulos contas a Pagar
@author Jonatas Oliveira | www.compila.com.br
@since 16/01/2019
@version 1.0
/*/
User Function AFIN003()

	Local lProcessa	:= .F.
	Private cPerg		:= "AFIN003"
	Private cFilAux	:= ""
	
	Private cCadastro 	:= "Selecao de NCC"
	Private cTitulo		:= cCadastro
	Private aBotoes		:= {}
	Private cPathArq	:= ""
	Private oMark
	
	Private cFilDe 		:= ""
	Private cFilAte     := ""
	Private cCliDe      := ""
	Private cCliAte     := ""
	Private cLojaDe     := ""
	Private cLojaAte    := ""
	Private dDtEmisD    := dDataBase
	Private dDtEmisA    := dDataBase
	Private dDtVencD    := dDataBase
	Private dDtVencA    := dDataBase 
	
	Private _cFiltro	:= ""
		
	
	aSay	:= {cCadastro,;
				"  ",;
				" Esta rotina tem como objetivo selecionar titulos do tipo NCC,  ",;
				" Baixa-los do contas à receber e ",;
				" Criar titulos no contas à Pagar. ",;
				"   ",;
				"                                                                  v1.0"}
	
	
	cPathArq	:= ""
	
	ProcLogIni( aBotoes )
	
	aAdd(aBotoes, { 1,.T.,{|| lProcessa := .T., FechaBatch() }} )
	aAdd(aBotoes, { 2,.T.,{|| lProcessa := .F., FechaBatch()  }} )
	
	FormBatch( cCadastro, aSay, aBotoes ,,240,510)
	
	
	IF lProcessa
		AjustSX1(cPerg)		
		IF PERGUNTE(cPerg ,.T.)		
			cFilAux := "E1_TIPO=='NCC' .AND. E1_SALDO > 0 .AND."
			cFilAux += " E1_FILIAL >=  '"+MV_PAR01+"' .AND. E1_FILIAL <='"+MV_PAR02+"' .AND."
			cFilAux += " E1_CLIENTE >=  '"+MV_PAR03+"' .AND. E1_CLIENTE <='"+MV_PAR04+"' .AND."
			cFilAux += " E1_LOJA >=  '"+MV_PAR05+"' .AND. E1_LOJA <='"+MV_PAR06+"' .AND."
			cFilAux += " DTOS(E1_EMISSAO) >=  '" + DTOS(MV_PAR07) + "' .AND. DTOS(E1_EMISSAO) <='"+  DTOS(MV_PAR08)  +"'  .AND."
			cFilAux += " DTOS(E1_VENCREA) >=  '" + DTOS(MV_PAR09) + "' .AND. DTOS(E1_VENCREA) <='"+  DTOS(MV_PAR10)  +"' "
			
			
			cFilDe 		:= MV_PAR01
			cFilAte     := MV_PAR02
			cCliDe      := MV_PAR03
			cCliAte     := MV_PAR04
			cLojaDe     := MV_PAR05
			cLojaAte    := MV_PAR06
			dDtEmisD    := MV_PAR07
			dDtEmisA    := MV_PAR08
			dDtVencD    := MV_PAR09
			dDtVencA    := MV_PAR10
						
		ENDIF 
	ENDIF 
	
	
	IF !EMPTY(cFilAux)
		_cFiltro := cFilAux
	ELSE
		_cFiltro := "EMPTY(E1_NUM)"
	ENDIF 
	
	oMark := FWMarkBrowse():New()

	oMark:SetAlias('SE1')
	oMark:SetDescription('Seleção NCC')
	oMark:SetFieldMark( 'E1_OK' )

	oMark:bAllMark := { || .T. }

	oMark:SetFilterDefault( _cFiltro )
//	oMark:SetDoubleClick( .F. )
	

	oMark:Activate()
Return NIL

//-------------------------------------------------------------------
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'             OPERATION 1 ACCESS 0
	//ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.AFIN090_MVC' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Gerar CP'  ACTION 'U_AFIN03CP()'      OPERATION 2 ACCESS 0
//	ADD OPTION aRotina TITLE 'Parametros'  ACTION 'U_AFIN03R(oModel)'      OPERATION 2 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStruSE1 := FWFormStruct( 1, 'SE1', /*bAvalCampo*/,/*lViewUsado*/ )
	Local oModel

	// Cria o objeto do Modelo de Dados
	oModel := MPFormModel():New('COMP011MODEL', /*bPreValidacao*/, /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SE1MASTER', /*cOwner*/, oStruSE1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( 'Modelo de Dados de Autor/Interprete' )

	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SE1MASTER' ):SetDescription( 'Dados de Dados de Autor/Interprete' )


Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
	// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
	Local oModel   := FWLoadModel( 'COMP011_MVC' )
	// Cria a estrutura a ser usada na View
	Local oStruSE1 := FWFormStruct( 2, 'SE1' )
	//Local oStruSE1 := FWFormStruct( 2, 'SE1', { |cCampo| COMP11STRU(cCampo) } )
	Local oView

	// Cria o objeto de View
	oView := FWFormView():New()

	// Define qual o Modelo de dados será utilizado
	oView:SetModel( oModel )

	//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
	oView:AddField( 'VIEW_SE1', oStruSE1, 'SE1MASTER' )

	// Criar um "box" horizontal para receber algum elemento da view
	oView:CreateHorizontalBox( 'TELA' , 100 )

	// Relaciona o ID da View com o "box" para exibicao
	oView:SetOwnerView( 'VIEW_SE1', 'TELA' )

Return oView


/*/{Protheus.doc} AFIN03CP
interface para seleção dos titulos
@author Jonatas Oliveira | www.compila.com.br
@since 16/01/2019
@version 1.0
/*/
User Function AFIN03CP()
	Local aArea 	:= GetArea()
	Local cMarca 	:= oMark:Mark()

	Local nCt 		:= 0
	Local nConfirm	:= 0
	Local nI		:= 0
	Local lContinua	:= .T.

	Local aRecTit	:= {}
	Local aRecSE1	:= {}	
	Local cRetAc	:= ""
	Local aRecSa1	:= {}
	Local cMsgAux	:= ""
	Local cQuery
	

	Private _cFileLog
	Private _cLogPath
	Private _Handle

	fGrvLog(1,"Iniciando gravação de Log. "+TIME()+". "+ DToC(ddatabase)  )	//||Opcao:  1= Cria Arquivo de Log, 2= Grava Log, 3 = Apresenta Log

	SE1->( dbGoTop() )

	DBSELECTAREA("SA1")
	SA1->(DBSETORDER(1))

	DBSELECTAREA("SA2")
	
	DBSELECTAREA("SF1")
	SF1->(DBSETORDER(1))//|F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO|
/*
	While !SE1->( EOF() )

		If oMark:IsMark(cMarca)
			nCt++
			AADD(aRecSE1, SE1->(RECNO()))			
		EndIf

		SE1->( dbSkip() )
	EndDO
	*/	
	
//	TcSqlExec( "update " + RetSqlName("SE1") + " SE1" + " SET SE1.E1_OK = '' WHERE  SE1.D_E_L_E_T_ <> '*' AND E1_TIPO = 'NCC' AND E1_SALDO = 0 AND E1_OK = '"+cMarca+"' ")
	
	cQuery := " SELECT SE1.R_E_C_N_O_ SE1_RECNO "+CRLF
	cQuery += " FROM "+RetSqlName("SE1")+" SE1 "+CRLF
	cQuery += " WHERE E1_FILIAL BETWEEN '"+cFilDe+"' AND '"+cFilAte+"' "+CRLF
	cQuery += " 	AND E1_EMISSAO BETWEEN '"+DTOS(dDtEmisD)+"' AND '"+DTOS(dDtEmisA)+"' "+CRLF
	cQuery += " 	AND E1_TIPO = 'NCC' "+CRLF
	cQuery += " 	AND SE1.E1_OK = '"+cMarca+"' "+CRLF
	cQuery += " 	AND SE1.D_E_L_E_T_ <> '*' "+CRLF	
	cQuery += "	 	AND E1_SALDO > 0 "+CRLF	
	
	If Select("TSQL") > 0
		TSQL->(DbCloseArea())
	EndIf
	
	
	cQuery	:= ChangeQuery(cQuery)
	DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSQL",.F., .T.)						
	
	
	WHILE TSQL->(!EOF())
		nCt++
		AADD(aRecSE1, TSQL->SE1_RECNO )	
		 
		TSQL->(DBSKIP()) 
	ENDDO	
	
	TSQL->(DbCloseArea())
	
	

	nConfirm := AVISO("NCC para Contas a Pagar", "Foram marcados " + AllTrim( Str( nCt ) ) + " registros para geração de Contas a Pagar  . Confirma a Geração?", {"Sim", "Não"},2)
	
	
	IF nConfirm == 1

		For nI := 1 To Len(aRecSE1)
			
			lContinua := .T. 
			
			SE1->(DBGOTO(aRecSE1[nI]))

			SA1->(DBSEEK(XFILIAL("SA1") + SE1->(E1_CLIENTE + E1_LOJA) ))
			
			SA2->(DBSETORDER(3))//|A2_FILIAL, A2_CGC|
			
			IF lContinua
				IF SA2->(DBSEEK( XFILIAL("SA2") + SA1->A1_CGC ))
					/*----------------------------------------
						07/02/2019 - Jonatas Oliveira - Compila
						Remove as nota com Formulario Sim
					------------------------------------------*/
					IF SF1->(DBSEEK(SE1->(E1_FILIAL + E1_NUM + E1_PREFIXO ) + SA2->(A2_COD + A2_LOJA)  )) .AND. ALLTRIM(SE1->E1_ORIGEM) = "MATA100"
						IF ALLTRIM(SF1->F1_FORMUL) == "S"
						
							SE1->(RecLock("SE1",.F.))
								SE1->E1_OK	:= ""				
							SE1->(MsUnLock())
							
							fGrvLog(2," FALHA - TITULO COM ORIGEM DOCUMENTO DE ENTRADA FORMULARIO PROPRIO. TITULO - " + SE1->E1_FILIAL + "|" + SE1->E1_PREFIXO + "|" + SE1->E1_NUM + "|" + SE1->E1_PARCELA  + " " )
							lContinua := .F.
						ENDIF 
						
					ENDIF
					
					IF lContinua
						
						/*----------------------------------------
						16/01/2019 - Jonatas Oliveira - Compila
						- Realiza baixa no NCC sem movimentar banco
						- Realiza a inclusão de título no CP
						------------------------------------------*/
						Processa({|| cMsgAux := U_AFIN03BX(SE1->(RECNO()), GetMv("CT_MOTBX",.F.,"NCC"), SA1->A1_CGC)}, "Processando ")								
						
						fGrvLog(2," TITULO - " + SE1->E1_FILIAL + "|" + SE1->E1_PREFIXO + "|" + SE1->E1_NUM + "|" + SE1->E1_PARCELA  + " " + cMsgAux )
					ENDIF 
				ELSE
					fGrvLog(2," CNPJ/CPF - " + Transform(SA1->A1_CGC, PesqPict("SA1","A1_CGC") ) + " não localizado no cadastro de Fornecedores" )
				ENDIF 	
			ENDIF 	
			
		Next nI

	ENDIF 

	RestArea( aArea )

	oMark:Refresh()

	fGrvLog(3,"Fim da Gravação . "+TIME()+". "+ DToC(ddatabase))
Return NIL

/*/{Protheus.doc} AFIN03BX
Realiza baixa no NCC sem movimentar banco
Realiza a inclusão de título no CP
@author Jonatas Oliveira | www.compila.com.br
@since 16/01/2019
@version 1.0
/*/
User Function AFIN03BX(nRecSe1, cMotBx, cCnpj)
	Local aBxAuto 	:= {}
	Local aTitulo	:= {}
	Local lBaixou	:= .F.
	Local nVlrBx	:= 0 
	Local aRecCP	:= {}
	Local cRet		:= ""
	Local cAutoLog, cMemo
	Local cTipo		:= GetMv("CT_TIPOCP",.F.,"NCP")
	Local cNaturez	:= GetMv("CT_NATCP" ,.F.,"0000000000")
	Local cPrefCP	:= GetMv("CT_PREFCP" ,.F.,"REB")
	Local nDiasVc	:= GetMv("CT_DIACP" ,.F.,15)
	
	 
	DBSELECTAREA("SE1")
	SE1->(DBGOTO(nRecSe1))
	
	nVlrBx := SE1->E1_SALDO
	
	BEGIN TRANSACTION
	
	aBxAuto := {{"E1_FILIAL"	 , SE1->E1_FILIAL    	,nil},;
				{"E1_PREFIXO"	 , SE1->E1_PREFIXO   	,nil},;
				{"E1_NUM"		 , SE1->E1_NUM       	,nil},;
				{"E1_PARCELA"	 , SE1->E1_PARCELA   	,nil},;
				{"E1_TIPO"	     , SE1->E1_TIPO      	,nil},;
				{"AUTMOTBX"	     , cMotBx            	,nil},;				
				{"AUTDTBAIXA"	 , ddatabase	  	    ,nil},;
				{"AUTDTCREDITO"  , ddatabase	        ,nil},;
				{"AUTHIST"	     ,'BAIXA NCC'			,nil},;				
				{"AUTVALREC"	 , nVlrBx				,nil}}

	lMsErroAuto := .F.
	MSExecAuto({|x,y| Fina070(x,y)},aBxAuto,3)
	
	IF lMsErroAuto
		cAutoLog	:= alltrim(NOMEAUTOLOG())
	
		cMemo := STRTRAN(MemoRead(cAutoLog),'"',"")
		cMemo := STRTRAN(cMemo,"'","")

		//| Apaga arquivo de Log
		Ferase(cAutoLog)
		cRet	:= "FALHA NA BAIXA DO TITULO. "
		
		/*----------------------------------------
			16/01/2019 - Jonatas Oliveira - Compila
			Le Log da Execauto e retorna mensagem amigavel
		------------------------------------------*/
		cRet += U_CPXERRO(cMemo)		
		
		DISARMTRANSACTION()		
	ELSE
		SE1->(DBGOTO(nRecSe1))
		
		DBSELECTAREA("SA2")
		SA2->(DBSETORDER(3))//|A2_FILIAL, A2_CGC|
		SA2->(DBSEEK( XFILIAL("SA2") + cCnpj ))
		
		DBSELECTAREA("SE2")
		SE2->(DBSETORDER(1))		
		
		AADD(aTitulo,{"E2_FILIAL" 		,	SE1->E1_FILIAL		, Nil})
		AADD(aTitulo,{"E2_PREFIXO" 		,	cPrefCP				, Nil})
		AADD(aTitulo,{"E2_NUM" 			,	SE1->E1_NUM			, Nil})
		AADD(aTitulo,{"E2_TIPO"    		,	cTipo				, Nil})
		AADD(aTitulo,{"E2_PARCELA" 		,	SE1->E1_PARCELA		, Nil})
		AADD(aTitulo,{"E2_NATUREZ"    	,	SE1->E1_NATUREZ		, Nil})
		AADD(aTitulo,{"E2_FORNECE"		,	SA2->A2_COD			, Nil})
		AADD(aTitulo,{"E2_LOJA"    		,	SA2->A2_LOJA		, Nil})
		AADD(aTitulo,{"E2_EMISSAO"    	,	dDataBase			, Nil})
		AADD(aTitulo,{"E2_VENCTO"    	,	SE1->E1_VENCREA		, Nil})	
		AADD(aTitulo,{"E2_VALOR"    	, 	nVlrBx				, Nil})
		AADD(aTitulo,{"E2_CLVLDB"    	, 	SE1->E1_CLVLCR		, Nil})
		
//		AADD(aTitulo,{"E2_CCUSTO"    	,	oJson:E2_CCUSTO		, Nil})	
		AADD(aTitulo,{"E2_HIST"    		,	"ORIGEM NCC: " + SE1->(E1_FILIAL  + E1_PREFIXO  + E1_NUM  + E1_PARCELA )		, Nil})	
		
				
		lMsErroAuto	:= .F.
		MSExecAuto({|x,y,z| Fina050(x,y,z)},aTitulo,3,3)  
		
		IF lMsErroAuto
			DISARMTRANSACTION()
			cAutoLog	:= alltrim(NOMEAUTOLOG())
		
			cMemo := STRTRAN(MemoRead(cAutoLog),'"',"")
			cMemo := STRTRAN(cMemo,"'","")
	
			//| Apaga arquivo de Log
			Ferase(cAutoLog)
			cRet	:= "FALHA NA CRIACAO DO TITULO A PAGAR. "
			
			/*----------------------------------------
				16/01/2019 - Jonatas Oliveira - Compila
				Le Log da Execauto e retorna mensagem amigavel
			------------------------------------------*/
			
			cRet += U_CPXERRO(cMemo)	
		ELSE
			IF SE2->(DBSEEK( SE1->E1_FILIAL + cPrefCP + SE1->E1_NUM + SE2->E2_PARCELA + cTipo ))
			//E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
				cRet	:= "SUCESSO. TITULO GERADO. " + SE2->E2_FILIAL + "|" + SE2->E2_PREFIXO + "|"  + SE2->E2_NUM
				
				SE1->(RecLock("SE1",.F.))
					SE1->E1_HIST := " TIT CP - " + SE2->E2_FILIAL + "|" + SE2->E2_PREFIXO + "|"  + SE2->E2_NUM					
				SE1->(MsUnLock())
			
			ELSE
				DISARMTRANSACTION()
				cRet	:= "FALHA NA CRIACAO DO TITULO A PAGAR.. "
			ENDIF 
		ENDIF
	
	ENDIF 
	
	END TRANSACTION
Return(cRet)

User Function AFIN03R(oModSe1)

	AjustSX1(cPerg)		
	
	IF PERGUNTE(cPerg ,.T.)		
		cFilAux := "E1_TIPO=='NCC' .AND. E1_SALDO > 0 .AND."
		cFilAux += " E1_FILIAL >=  '"+MV_PAR01+"' .AND. E1_FILIAL <='"+MV_PAR02+"' .AND."
		cFilAux += " E1_CLIENTE >=  '"+MV_PAR03+"' .AND. E1_CLIENTE <='"+MV_PAR04+"' .AND."
		cFilAux += " E1_LOJA >=  '"+MV_PAR05+"' .AND. E1_LOJA <='"+MV_PAR06+"' .AND."
		cFilAux += " DTOS(E1_EMISSAO) >=  '" + DTOS(MV_PAR07) + "' .AND. DTOS(E1_EMISSAO) <='"+  DTOS(MV_PAR08)  +"'  .AND."
		cFilAux += " DTOS(E1_VENCREA) >=  '" + DTOS(MV_PAR09) + "' .AND. DTOS(E1_VENCREA) <='"+  DTOS(MV_PAR10)  +"' "
		
		cFilDe 		:= MV_PAR01
		cFilAte     := MV_PAR02
		cCliDe      := MV_PAR03
		cCliAte     := MV_PAR04
		cLojaDe     := MV_PAR05
		cLojaAte    := MV_PAR06
		dDtEmisD    := MV_PAR07
		dDtEmisA    := MV_PAR08
		dDtVencD    := MV_PAR09
		dDtVencA    := MV_PAR10
					
	ENDIF 
		
	IF !EMPTY(cFilAux)
		_cFiltro := cFilAux
	ELSE
		_cFiltro := "EMPTY(E1_NUM)"
	ENDIF 



	oModSe1:SetFilterDefault( _cFiltro )
	
	oModSe1:Refresh()
	
Return()


/*/{Protheus.doc} fGrvLog
Realiza a Criação, Gravacao, Apresentacao do Log de acordo com o Pametro passado
@author www.compila.com.br
@param _nOpc, N, 1= Cria Arquivo de Log, 2= Grava Log, 3 = Apresenta Log
@param _cTxtLog, C, Log a ser gravado 
/*/
Static Function fGrvLog(_nOpc, _cTxtLog)
	Local _lRet	:= Nil
	Local _nOpc, _cTxtLog
	Local _EOL	:= chr(13)+chr(10)

	Default _nOpc		:= 0
	Default _cTxtLog 	:= ""
	_cTxtLog += _EOL
	Do Case
		Case _nOpc == 1
		_cFileLog	 	:= Criatrab(,.F.)
		_cLogPath		:= AllTrim(GetTempPath())+_cFileLog+".txt"
		_Handle			:= FCREATE(_cLogPath,0)	//| Arquivo de Log
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF

		Case _nOpc == 2
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF

		Case _nOpc == 3
		IF !EMPTY(_cTxtLog)
			FWRITE (_Handle, _cTxtLog)
		ENDIF
		FCLOSE(_Handle)
		WINEXEC("NOTEPAD "+_cLogPath)
	EndCase

Return(_lRet)



/*/{Protheus.doc} AjustSX1
Cria perguntas no SX1
@author Augusto Ribeiro | www.compila.com.br
@since 26/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function AjustSX1(cPerg)

	Local aArea := GetArea()
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}
	
	aAdd( aHelpEng, "  ")
	aAdd( aHelpSpa, "  ")

	aHelpPor := {} ; Aadd( aHelpPor, "Filial De")
	xPutSx1( cPerg, "01","Filial De"	,"","","mv_ch1","C",TAMSX3("E2_FILIAL")[1],0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Filial Ate")
	xPutSx1( cPerg, "02","Filial Ate"	,"","","mv_ch2","C",TAMSX3("E2_FILIAL")[1],0,0,"G","NaoVazio()","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Cliente De")
	xPutSx1( cPerg, "03","Cliente De"	,"","","mv_ch3","C",TAMSX3("A1_COD")[1],0,0,"G","","SA1","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Cliente Ate")
	xPutSx1( cPerg, "04","Cliente Ate"	,"","","mv_ch4","C",TAMSX3("A1_COD")[1],0,0,"G","NaoVazio()","SA1","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Loja De")
	xPutSx1( cPerg, "05","Loja De"	,"","","mv_ch5","C",TAMSX3("A1_LOJA")[1],0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Loja Ate")
	xPutSx1( cPerg, "06","Loja Ate"	,"","","mv_ch6","C",TAMSX3("A1_LOJA")[1],0,0,"G","NaoVazio()","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Dt. Emissao De")
	xPutSx1( cPerg, "07","Dt. Emissao De"	,"","","mv_ch7","D",8,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Dt. Emissao Ate")
	xPutSx1( cPerg, "08","Dt. Emissao Ate"	,"","","mv_ch8","D",8,0,0,"G","NaoVazio()","","","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Dt. Vencto De")
	xPutSx1( cPerg, "09","Dt. Vencto De"	,"","","mv_ch9","D",8,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Dt. Vencto Ate")
	xPutSx1( cPerg, "10","Dt. Vencto Ate"	,"","","mv_cha","D",8,0,0,"G","NaoVazio()","","","","mv_par10","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )


Return()



/*/{Protheus.doc} xPutSx1
PutSX1 
@author Augusto Ribeiro | www.compila.com.br
@since 18/04/2018
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,; 
     cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,; 
     cF3, cGrpSxg,cPyme,; 
     cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,; 
     cDef02,cDefSpa2,cDefEng2,; 
     cDef03,cDefSpa3,cDefEng3,; 
     cDef04,cDefSpa4,cDefEng4,; 
     cDef05,cDefSpa5,cDefEng5,; 
     aHelpPor,aHelpEng,aHelpSpa,cHelp) 

	LOCAL aArea := GetArea() 
	Local cKey 
	Local lPort := .f. 
	Local lSpa := .f. 
	Local lIngl := .f. 
	
	cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "." 
	
	cPyme    := Iif( cPyme           == Nil, " ", cPyme          ) 
	cF3      := Iif( cF3           == NIl, " ", cF3          ) 
	cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     ) 
	cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      ) 
	cHelp      := Iif( cHelp          == Nil, "" , cHelp          ) 
	
	dbSelectArea( "SX1" ) 
	dbSetOrder( 1 ) 
	
	// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes. 
	// RFC - 15/03/2007 
	cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " ) 
	
	If !( DbSeek( cGrupo + cOrdem )) 
	
	    cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt) 
	     cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa) 
	     cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng) 
	
	     Reclock( "SX1" , .T. ) 
	
	     Replace X1_GRUPO   With cGrupo 
	     Replace X1_ORDEM   With cOrdem 
	     Replace X1_PERGUNT With cPergunt 
	     Replace X1_PERSPA With cPerSpa 
	     Replace X1_PERENG With cPerEng 
	     Replace X1_VARIAVL With cVar 
	     Replace X1_TIPO    With cTipo 
	     Replace X1_TAMANHO With nTamanho 
	     Replace X1_DECIMAL With nDecimal 
	     Replace X1_PRESEL With nPresel 
	     Replace X1_GSC     With cGSC 
	     Replace X1_VALID   With cValid 
	
	     Replace X1_VAR01   With cVar01 
	
	     Replace X1_F3      With cF3 
	     Replace X1_GRPSXG With cGrpSxg 
	
	     If Fieldpos("X1_PYME") > 0 
	          If cPyme != Nil 
	               Replace X1_PYME With cPyme 
	          Endif 
	     Endif 
	
	     Replace X1_CNT01   With cCnt01 
	     If cGSC == "C"               // Mult Escolha 
	          Replace X1_DEF01   With cDef01 
	          Replace X1_DEFSPA1 With cDefSpa1 
	          Replace X1_DEFENG1 With cDefEng1 
	
	          Replace X1_DEF02   With cDef02 
	          Replace X1_DEFSPA2 With cDefSpa2 
	          Replace X1_DEFENG2 With cDefEng2 
	
	          Replace X1_DEF03   With cDef03 
	          Replace X1_DEFSPA3 With cDefSpa3 
	          Replace X1_DEFENG3 With cDefEng3 
	
	          Replace X1_DEF04   With cDef04 
	          Replace X1_DEFSPA4 With cDefSpa4 
	          Replace X1_DEFENG4 With cDefEng4 
	
	          Replace X1_DEF05   With cDef05 
	          Replace X1_DEFSPA5 With cDefSpa5 
	          Replace X1_DEFENG5 With cDefEng5 
	     Endif 
	
	     Replace X1_HELP With cHelp 
	
	     PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 
	
	     MsUnlock() 
	Else 
	
	   lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT) 
	   lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA) 
	   lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG) 
	
	   If lPort .Or. lSpa .Or. lIngl 
	          RecLock("SX1",.F.) 
	          If lPort 
	        SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?" 
	          EndIf 
	          If lSpa 
	               SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?" 
	          EndIf 
	          If lIngl 
	               SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?" 
	          EndIf 
	          SX1->(MsUnLock()) 
	     EndIf 
	Endif 
	
	RestArea( aArea ) 

Return