#Include "Protheus.Ch"
//#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE "FWMBROWSE.CH"      
#INCLUDE 'TBICONN.CH'
#INCLUDE "fileio.ch"

/* - FWMVCDEF
MODEL_OPERATION_INSERT para inclus„o;
MODEL_OPERATION_UPDATE para alteraÁ„o;
MODEL_OPERATION_DELETE para exclus„o.
MODEL_OPERATION_VIEW para visualizacao.
*/


#DEFINE D_PICTURE_VLR "@E 99,999,999.99"
#DEFINE D_PICTURE_VLRT "@E 99,999,999,999.99"


#DEFINE NOME_SEMAFORO "CP09002"


#DEFINE D_TITULO 'ConciliaÁ„o Banc·ria'
#DEFINE D_ROTINA 'CP09002' 

#DEFINE D_PERG "CP09002"
#DEFINE D_PERG2 "CP09002A"


/*--------------------------
	LISTBOX Extrato
---------------------------*/
#DEFINE D_NAOSELECIONADO 0
#DEFINE D_SELECIONADO 1
#DEFINE D_CONCILIADO 2
#DEFINE D_TAXA 3
#DEFINE D_CONCILIADO_AUTO 4



/*--------------------------
	OPCOES RADIO
---------------------------*/
#DEFINE OPCAO_CONCILIACAO 1
#DEFINE OPCAO_TAXA 2



/*------------------------------------------------------ Augusto Ribeiro | 29/12/2016 - 10:26:08 AM
	PAMETROS DE USUABILIDADE
------------------------------------------------------------------------------------------*/
Static lISelec		:= .F.
Static lExecConc	:= .F.
Static cSEDMVPAR	:= ""
Static cCTTMVPAR	:= ""
Static cCTHMVPAR	:= ""



/*----------------------------------------------------
	COMPATIBILIDADE COM BANCO DE DADOS
-----------------------------------------------------*/
STATIC cSGBD_MODEL	:= "" //| TCGetDB() -  ORACLE | 	MSSQL
 

/*--------------------------
	TOTAIS RODAPE
---------------------------*/
//Static nTotEx	:= 0



/*/{Protheus.doc} CP09002
Conciliador banc·rio
@author Augusto Ribeiro | www.compila.com.br
@since 31/03/2016
@version 6
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User function CP09002()
Private lSelConc	:= .T.
Private	lSelTaxa	:= .F.

Private oFList		:= TFont():New("Courier New",, 15, , .F., , , , .F., .F.) // Regular
Private nZD2VALOR, nZD2DATA, nZD2RECNO, nZD2DESC, nEXCONCI, nZD2SE5
Private nE5VALOR, nE5DTDISPO, nE5HISTOR, nE5FILIAL, nE5NATUREZ, nE5CCUSTO, nE5CCC, nE5CCD, nSE5RECNO, nSE5ZD2, nMVCONCI, nE5CLVLCR, nCLCREDITO, nE5CLVLDB, nCLDEBITO, nE5MOTBX


Private oTotEx, oTotCon, oTotTaxa, oTotMv, cTotalMv, oGetTeste
Private oSelEx, cSelEx, oSelMv, cSelMv, cGetTeste
Private oPaneRod	:= nil
Private aDim		:= {}

Private	nSaldoEx	:= 0 //| Saldo do movimento|
Private	nSaldoMv	:= 0 //| Saldo do movimento|

/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 3:48:38 PM
Variaveis utilizadas no controle de multipla selecoes .
Relacionamento N para N

------------------------------------------------------------------------------------------*/
Private nMarkConc	:= 1 
Private nTotExCon	:= 0
Private nTotMvCon	:= 0


/*--------------------------
	PARAMETROS 
---------------------------*/
Private cpFilDe, cpFilAte, cpBanco, cpAg, cpConta, dpDtMvDe, dpDtMvAte, npTpMov		

/*--------------------------
	LISTBOX EXTRATO
---------------------------*/
Private oLbxEx		:= Nil
Private aCpoEX		:= {}
Private aDadosEx	:= {}
Private aHeadEx		:= {}
Private lVazioEx	:= .T.
//| Variaveis para Ordenacao da coluna|
Private lAllExt		:= .F.
Private nAntExt		:= 0
Private	nDadosEx	:= 0

/*---------------------------------
	LISTBOX MOVIMENTO BANCARIO
----------------------------------*/
Private oLbxMv		:= Nil
Private aCpoMv		:= {}
Private aDadosMv	:= {}
Private aHeadMv		:= {}
Private lVazioMv	:= .T.
//| Variaveis para Ordenacao da coluna|
Private lAllMv		:= .F.
Private nAntMv		:= 0
Private	nDadosMv	:= 0

/*------------------------------------------------------ Augusto Ribeiro | 26/12/2016 - 5:55:21 PM
	Variaveis para controle da seleÁ„o da conciliaÁ„o
------------------------------------------------------------------------------------------*/
Private aSelEx	:= {}
Private aSelMv	:= {} 

Private nTolera	:= 0 //| para consiliaÁao|

Private nConcTaxa := OPCAO_CONCILIACAO //| 1=Concilia, 2=Taxa Selecao de movimento para consiliaÁ„o ou TAXA|

Private nTotEx	:= 0
Private lVazio	:= .F.


AjustSX1(D_PERG)
AjusSX1A(D_PERG2)


/*-------------------------------
	PARAMETROS DE USUABILIDADE
--------------------------------*/
PERGUNTE(D_PERG2,.F.)
lISelec		:= (MV_PAR01==1)
lExecConc	:= (MV_PAR02==1)
cFILMVPAR	:= MV_PAR03
cSEDMVPAR	:= MV_PAR04
cCTTMVPAR	:= MV_PAR05
cCTHMVPAR	:= MV_PAR06

IF PERGUNTE(D_PERG ,.T.)

	cpFilDe		:= MV_PAR01
	cpFilAte	:= MV_PAR02
	cpBanco		:= MV_PAR03
	cpAg		:= MV_PAR04
	cpConta		:= MV_PAR05
	dpDtMvDe	:= MV_PAR06
	dpDtMvAte	:= MV_PAR07
	npTpMov		:= MV_PAR08


	nSaldoMv	:= SaldoMv(cpBanco, cpAg, cpConta, dpDtMvAte)
	nSaldoEx	:= SaldoEx(cpBanco, cpAg, cpConta, dpDtMvAte)
	
	FWExecView("ConciliaÁ„o Bancaria",  D_ROTINA,  3,  /*oDlg*/,  /*bCloseOnOk*/,  /*bOk*/, /* nPercReducao*/, /*aEnableButtons*/,  /*bCancel*/ )// == 0
	/*
	IF lExecConc
		ConcAuto()
	ENDIF
	IIF(lExecConc, ConcAuto(), .F.)
	*/
ENDIF


Return NIL

        
/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ CP09002  ∫Autor  ≥Augusto Ribeiro     ∫ Data ≥ 07/01/2011  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ 	Botoes do MBrowser                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/  
Static Function MenuDef()
Local aRotina := {}


ADD OPTION aRotina TITLE 'Pesquisar'  ACTION 'PesqBrw'             OPERATION 1 ACCESS 0
ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.'+D_ROTINA OPERATION 2 ACCESS 0                         
ADD OPTION aRotina TITLE 'Incluir'  ACTION 'VIEWDEF.'+D_ROTINA OPERATION 3 ACCESS 0  	
//ADD OPTION aRotina TITLE 'Conciliar Banco'  ACTION 'U_CP902MNU("CONCILIAR")' OPERATION 3 ACCESS 0
//ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 4 ACCESS 0
//ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.'+D_ROTINA OPERATION 5 ACCESS 0
ADD OPTION aRotina TITLE 'Imprimir'   ACTION 'VIEWDEF.'+D_ROTINA OPERATION 8 ACCESS 0
//ADD OPTION aRotina TITLE 'Copiar'     ACTION 'VIEWDEF.'+D_ROTINA OPERATION 9 ACCESS 0
//ADD OPTION aRotina TITLE 'TESTE'     ACTION 'U_FAT01TST()' OPERATION 9 ACCESS 0

Return aRotina







/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ CP09002  ∫Autor  ≥Augusto Ribeiro     ∫ Data ≥ 19/11/2013  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ 	Definicoes do Model                                       ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/  
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZD1 := FWFormStruct( 1, 'ZD1', /*bAvalCampo*/,/*lViewUsado*/ )
Local oStruZD2 := FWFormStruct( 1, 'ZD2', /*bAvalCampo*/,/*lViewUsado*/ )

Local oModel   


// Cria o objeto do Mod elo de Dados
oModel := MPFormModel():New(D_ROTINA+'MODEL', /*bPreValidacao*/,   /*bPosValidacao*/,  /*bCommit*/, /*bCancel*/ )
//oModel := MPFormModel():New('ATEC204MODEL', /*bPreValidacao*/, { |oMdl| COMP011POS( oMdl ) }, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formul·rio de ediÁ„o por campo
oModel:AddFields( 'ZD1ARQUIVO', /*cOwner*/, oStruZD1, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
oModel:AddGrid( 'ZD2EXTRATO', 'ZD1ARQUIVO', oStruZD2,  /*LINPRE*/, /*LINPOS*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )


// Faz relaciomaneto entre os compomentes do model                                                                           
oModel:SetRelation( 'ZD2EXTRATO',		{{ 'ZD2_FILIAL', 'XFILIAL("ZD2")' }, { 'ZD2_CODARQ', 'ZD1_CODIGO' } }, ZD2->(IndexKey(3)) ) //| ZD2_FILIAL+ZD2_CODARQ+ZD2_CODIGO 
 


// Indica que È opcional ter dados informados na Grid
 //oModel:GetModel( 'ZD1ARQUIVO' ):SetOptional(.T.) //| Removido ServiÁos Executados - Sol. Adriano
 //oModel:GetModel( 'ZD2EXTRATO' ):SetOptional(.T.) //| Removido ServiÁos Executados - Sol. Adriano
  

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription(D_TITULO)

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZD1ARQUIVO' ):SetDescription( 'Arquivo' )
oModel:GetModel( 'ZD2EXTRATO' ):SetDescription( 'Extrato' )      


/// oModel:GetModel( 'ZA6SERV' ):SetDescription( 'ServiÁos' ) //| Removido ServiÁos Executados - Sol. Adriano
      
// Liga a validaÁ„o da ativacao do Modelo de Dados
//oModel:SetVldActivate( { |oModel,cAcao| U_FAT01VLD('MODEL_ACTIVE', oModel) } )

oModel:SetActivate( {|oModel| SetKey ( VK_F5, {||  U_CP901BTN('EFETIVA') } ),;
								SetKey ( VK_F10, {||  U_CP901BTN('PERG_CONC') } ),;
								SetKey ( VK_F11, {|| U_CP901BTN('TRANSF')} ) }) //,U_CP701ZA3(oModel)} )

Return oModel


/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ CP09002  ∫Autor  ≥Augusto Ribeiro     ∫ Data ≥ 07/01/2011  ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ 	Definicoes da View                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/  
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oModel   := FWLoadModel( D_ROTINA )
// Cria a estrutura a ser usada na View
Local oStruZD1 := FWFormStruct( 2, 'ZD1' )
Local oStruZD2 := FWFormStruct( 2, 'ZD2' )
Local oView   

//Local oStruCSW := FWFormStruct( 1, 'CSW', /*bAvalCampo*/, /*lViewUsado*/ ) 
//Local oModel
                                   

//oStruCSW:RemoveField( 'CSW_ENT' )
                        
// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados ser· utilizado
oView:SetModel( oModel )

//oView:AddField( 'VIEW_ZD1', oStruZD1, 'ZD1ARQUIVO' )
//oView:AddGrid( 'VIEW_ZD2', oStruZD2, 'ZD2EXTRATO' )
				

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR'	, 85 )
oView:CreateHorizontalBox( 'INFERIOR'	, 15) 	  

oView:CreateVerticalBox( 'LEFT_SUP'		, 50,'SUPERIOR')
oView:CreateVerticalBox( 'RIGHT_SUP'	, 50,'SUPERIOR')


oView:AddOtherObject("EXTRATO"		, {|oPanel| U_CP902LEX("C",@oLbxEx,@aCpoEx,@aHeadEx, @aDadosEx, oPanel)  })
oView:AddOtherObject("MOVIMENTO"	, {|oPanel| U_CP902LMV("C",@oLbxMv,@aCpoMv,@aHeadMv, @aDadosMv, oPanel)  })


// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'EXTRATO', 'LEFT_SUP')
oView:SetOwnerView( 'MOVIMENTO', 'RIGHT_SUP')

//CP902LEX
//CP902LMV

// Define campos que terao Auto Incremento
//oView:AddIncrementField( 'VIEW_ZEH', 'ZEH_CODITE' )

oView:AddOtherObject("RODAPE", {|oPanel| ListTot(oPanel)})
oView:SetOwnerView("RODAPE",'INFERIOR')



// Criar novo botao na barra de botoes no antigo Enchoice Bar            
oView:AddUserButton( 'Parametros de Filtro.', 'Parametros Filtro', { |oView| U_CP901BTN('PERG_FILTRO', oView) } )
oView:AddUserButton( 'Parametros do Conciliador. F10', 'Parametros Conciliador (F12) ', { |oView| U_CP901BTN('PERG_CONC', oView) } )
oView:AddUserButton( 'Conc. Autom·tica', 'Conc. Autom·tica', { |oView| U_CP901BTN('CONC_AUTO', oView) } )
oView:AddUserButton( 'Conc. Semi-Autom·tica', 'Conc. Semi-Autom·tica', { |oView| U_CP901BTN('CONC_SEMI', oView) } )
oView:AddUserButton( 'Transferencia Mov. Bancario. F11', 'Transferencia', { |oView| U_CP901BTN('TRANSF', oView) } )
oView:AddUserButton( 'Efetivar ConciliaÁ„o. F5', 'Efetivar ConciliaÁ„o', { |oView| U_CP901BTN('EFETIVA', oView) } )

oView:AddUserButton( 'FunÁıes Contas a Pagar', 'FunÁıes Contas a Pagar', { |oView| U_CP901BTN('FCP', oView) } )
oView:AddUserButton( 'FunÁıes Contas a Receber', 'FunÁıes Contas a Receber', { |oView| U_CP901BTN('FCR', oView) } )
oView:AddUserButton( 'Conc. Banc·ria Padr„o', 'Conc. Banc·ria Padr„o', { |oView| U_CP901BTN('CONC_PADRAO', oView) } )



//oView:AddUserButton( 'Parametros do Conciliador', 'Parametros', { |oView| U_CP901BTN('PARAMETROS', oView) } )

//oView:AddUserButton( 'Gera calendario', 'CALENDARIO', { |oView| ALTER("TESTE") } )

// Liga a identificacao do componente
//oView:EnableTitleView('VIEW_ZEG','Lote de Faturamento')
//oView:EnableTitleView('VIEW_ZEH','Itens do Lote')
//oView:EnableTitleView('LEFT_SUP', "Extrato Banc·rio")
//oView:EnableTitleView('RIGHT_SUP', "Movimento Banc·rio")
//oView:EnableTitleView('VIEW_ZD2')
	
	
	// Liga a EdiÁ„o de Campos na FormGrid
	//oView:SetViewProperty( 'VIEW_ZA5'		, "ENABLEDGRIDDETAIL", { 60 } )   


//oView:SetFieldAction(  'ZEG_DTINI',  {  |oView,  cIDView,  cField,  xValue| FAction(  oView,  cIDView, cField, xValue ) } )

//oView:SetCloseOnOk({||.T.})
  
  //oView:SetViewAction( 'REFRESH', {|| IIF(lExecConc, ConcAuto(), .F.), lExecConc := .F., .T.})
 // oView:Refresh()
 
 	//oView:SetViewAction( 'REFRESH' ,{ |oView| alert("teste") } )
Return oView












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
xPutSx1( cPerg, "01","Filial De"	,"","","mv_ch1","C",len(xfilial()),0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Filial Ate")
xPutSx1( cPerg, "02","Filial Ate","","","mv_ch2","C",len(xfilial()),0,0,"G","","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Banco")
xPutSx1( cPerg, "03","Banco"	,"","","mv_ch3","C",TAMSX3("A6_COD")[1],0,0,"G","","SA6CP9","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Agencia")
xPutSx1( cPerg, "04","Agencia"	,"","","mv_ch4","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Conta")
xPutSx1( cPerg, "05","Conta"	,"","","mv_ch5","C",TAMSX3("A6_NUMCON")[1],0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. De")
xPutSx1( cPerg, "06","Data Mov. De","","","mv_ch6","D",08,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. Ate")
xPutSx1( cPerg, "07","Data Mov. Ate","","","mv_ch7","D",08,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Tipos de Movimento")
xPutSx1( cPerg, "08","Tipo de Movimento","","","mv_ch8","N",01,0,0,"C","","","","","mv_par08","CrÈdito","","","","DÈbito","","","Ambos","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

Return()







/*/{Protheus.doc} AjusSX1A
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
Static Function AjusSX1A(cPerg)

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aAdd( aHelpEng, "  ")
aAdd( aHelpSpa, "  ")

aHelpPor :=	{}; Aadd (aHelpPor, "SeleÁ„o inteligente")
xPutSx1(	cPerg, "01","SeleÁ„o inteligente","","SeleÁ„o inteligente","mv_ch1","N",01,0,0,"C","","","","","MV_PAR01","Sim","Sim","Sim","","N„o","N„o","N„o","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor :=	{}; Aadd (aHelpPor, "Executar conciliaÁ„o Autom·tica"); Aadd (aHelpPor, "ao abrir conciliador")
xPutSx1(	cPerg, "02","Conc. Automatica","","Conc. Automatica","mv_ch2","N",01,0,0,"C","","","","","MV_PAR02","Sim","Sim","Sim","","N„o","N„o","N„o","","","","","","","","","",aHelpPor,aHelpPor,aHelpPor)

aHelpPor := {} ; Aadd( aHelpPor, "Filial gera Movimento")
xPutSx1( cPerg, "03","Filial gera Movimento"	,"","","mv_ch3","C",TAMSX3("ED_FILIAL")[1],0,0,"G","","SM0","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Natureza gera Movimento")
xPutSx1( cPerg, "04","Natureza"	,"","","mv_ch4","C",TAMSX3("ED_CODIGO")[1],0,0,"G","EXISTCPO('SED')","SED","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Centro de Custo"); Aadd( aHelpPor, "gera Movimento")
xPutSx1( cPerg, "05","Centro de Custo","","","mv_ch5","C",TAMSX3("CTT_CUSTO")[1],0,0,"G","EXISTCPO('CTT')","CTT","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Seguimento"); Aadd( aHelpPor, "gera Movimento")
xPutSx1( cPerg, "06","Seguimento","","","mv_ch6","C",TAMSX3("CTH_CLVL")[1],0,0,"G","EXISTCPO('CTH')","CTH","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )



Return()



/*/{Protheus.doc} CP902LEX
Montas Listbox com dados do EXTRATO
@author Augusto Ribeiro | www.compila.com.br
@since 26/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP902LEX(cOpcList, oLbxEx, aCpoHeader, aHeader, aDados, oPanel )
Local lRet			:= .T.
Local aVlrCor		:= {} 


Private aCpoHeader

Default	cOpcList	:= "C"

Default aCpoHeader	:= {} 
Default aHeader		:= {} 
Default aDados		:= {}

Default	oLbxEx		:= NIL
Default	oPanel		:= NIL

//IF cOpcList	== "A"
	aRetAux	:= qExtrato() 
	aDadosEx	:= {}
	//IF aRetAux[1]
		aCpoEX		:= aRetAux[2]
		aHeadEx	:= aRetAux[3]
		aDadosEx	:= aRetAux[4]
		//nDadosEx	:= len(aDadosEx[1])


			
		lRet	:= .T.
	
	//ELSE
		//Help(" ",1,"VAZIO",,"N„o existem registros no periodo selecionado.",4,5)
		//lVazio := .t.
	//	ENDIF




aCpoHeader		:= aCpoEX
aHeader			:= aHeadEx
aDados			:= aDadosEx
//aDadosLbx		:= aClone(aDadoTit)	

	lVazioEx := empty(aDadosEx)

	MontLis(cOpcList, @oLbxEx, @aCpoHeader, @aHeader, @aDados, @oPanel)

Return()


/*/{Protheus.doc} MontLis
Monta Interface de seleÁ„o
@author Jonatas Oliveira | www.compila.com.br
@since 14/04/2016
@version 1.0
/*/
Static Function MontLis(cOpcList, oLbxEx, aCpoHeader, aHeader, aDados, oPanel)

	Local cBCodLin		:= ""   
	Local oOk 	     	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo   	   	:= LoadBitmap( GetResources(), "LBNO" )
	Local oVerde   	   	:= LoadBitmap( GetResources(), "BR_VERDE" )
	Local oAmarelo   	:= LoadBitmap( GetResources(), "BR_AMARELO" )
	Local oAzul   		:= LoadBitmap( GetResources(), "BR_AZUL" )
	Local oCinza   	   	:= LoadBitmap( GetResources(), "BR_CINZA" )
	Local oBranco   	:= LoadBitmap( GetResources(), "BR_BRANCO" )
	Local oFLabels 		:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)
	Local oFGrpCpo 		:= TFont():New("Verdana",,016,,.F.,,,,,.F.,.F.)

	Private oDlgMain	:= NIL

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ cOpcList | C = Cria, A = Atualiza ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	IF cOpcList == "C"
	
		

		@ 3, 5 SAY oLblSolicita PROMPT "Extrato" SIZE 50, 012 OF oPanel FONT oFLabels COLORS RGB(56,141,191), 16777215 PIXEL
		@ 12,0 LISTBOX oLbxEx FIELDS HEADER ;
		FONT oFList;   
		" ", "Campos" ;                                                                                                    
		SIZE (oPanel:nClientWidth/2)-5,(oPanel:nClientHeight/2)-12 OF oPanel PIXEL ON  dblClick(SelEx(@oLbxEx), ListTot(), oLbxEx:Refresh())

		oLbxEx:aheaders := aHeader			   
		oLbxEx:BHEADERCLICK	:= { |oObj,nCol| OrdExt( oObj,nCol, .T.) }		
	ENDIF
	
	/*
	@  250, 40 		SAY oLblSolicita PROMPT "Total " 		SIZE 50, 014 OF oDlgMain FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotalP := TGet():Create( oDlgMain,{|| CalcTot("TP", @aDadoMain)},250, 40	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalP,,,, )
	*/
	IF EMPTY(aDados)
		aDados	:= {{}}
		aadd(aDados[1], .F.)
		aadd(aDados[1], 0)
		
		FOR nI := 3 to len(aHeader)
			aadd(aDados[1], '')
		NEXT nI
	ENDIF   
	
		oLbxEx:nAt	:= 1
	
		oLbxEx:SetArray( aDados )  
		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Cria string com Bloco de Codigo ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		//	cBCodLin	:= "LoadBitmap( GetResources(), aDados[oLbxEx:nAt,"+alltrim(str(nP04STATUS))+"] ) "
		
		/*
		#DEFINE D_NAOSELECIONADO 0
		#DEFINE D_SELECIONADO 1
		#DEFINE D_CONCILIADO 2
		#DEFINE D_TAXA 3
		#DEFINE D_CONCILIADO_AUTO 4
		*/
		//oAzul
		
	
		cBCodLin	:= "Iif(aDados[oLbxEx:nAt,1],oOk,oNo), Iif(aDados[oLbxEx:nAt,2]==2,oVerde,Iif(aDados[oLbxEx:nAt,2]==3,oAzul, Iif(aDados[oLbxEx:nAt,2]==1,oAmarelo , Iif(aDados[oLbxEx:nAt,2]==4, oBranco, oCinza))))"
		//cBCodLin	:= "IIF(ALLTRIM(aDados[oLbxEx:nAt,nP04STATUS]) == alltrim(X3COMBO('P04_STATUS','4')), oNo, Iif(aDados[oLbxEx:nAt,1],oOk,oNo))"
	
	
		For nI := 3 To LEN(aHeader)
			IF nI > 1
				cBCodLin	+=", "
			endif
			cI	:= alltrim(str(nI))
			
			IF ALLTRIM(aCpoHeader[nI]) $ "ZD2_VALOR"
				cBCodLin	+= "Transform(aDados[oLbxEx:nAt,"+cI+"], '"+D_PICTURE_VLR+"')"
			ELSE
				cBCodLin	+= "aDados[oLbxEx:nAt,"+cI+"]"		
			ENDIF
			
		Next nI	
	
		cBCodLin	:= "oLbxEx:bLine := {|| {"+cBCodLin+"}}"
		&(cBCodLin)
		//oLbxEx:bLine	:= {|| {Iif(aDados[oLbxEx:nAt,1],oOk,oNo), Iif(aDados[oLbxEx:nAt,2]==2,oVerde,Iif(aDados[oLbxEx:nAt,2]==3,oAzul, Iif(aDados[oLbxEx:nAt,2]==1,oAmarelo , Iif(aDados[oLbxEx:nAt,2]==4, oBranco, oCinza)))), aDados[oLbxEx:nAt,3], Transform(aDados[oLbxEx:nAt,4], '@E 99,999,999.99'), aDados[oLbxEx:nAt,5]}}    
	     


	oLbxEx:Refresh()

Return    






/*/{Protheus.doc} qExtrato
Busca registros do extrato que ainda n„o foram conciliados
@author Augusto Ribeiro | www.compila.com.br
@since 16/04/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function qExtrato()
Local aCpoHeader	:= {} 
Local aHeader		:= {} 
Local aDados		:= {}
Local aRet			:= {.F., aCpoHeader, aHeader, aDados}
//Local cAbatim		:= alltrim(MVABATIM) + "|" + alltrim(MVRECANT) + "|" + alltrim(MV_CRNEG)
Local nCpoQry		:= 0
Local nY, nI
Local cQuery		:= ""
Local cDigConta		:= ""


cQuery	:= " SELECT ZD2_DATA, ZD2_VALOR, ZD2_DESC, ZD2.R_E_C_N_O_ AS  ZD2_RECNO "+CRLF
cQuery	+= " FROM "+RetSqlName("ZD2")+" ZD2 "+CRLF
cQuery	+= " WHERE ZD2_DATA BETWEEN '"+DTOS(dpDtMvDe)+"' AND '"+DTOS(dpDtMvAte)+"' "+CRLF
cQuery	+= " AND ZD2_BANCO = '"+cpBanco+"' "+CRLF

cQuery	+= " AND ZD2_AGENC = '"+cpAg+"' "+CRLF
cQuery	+= " AND ZD2_CONTA =  '"+cpConta+"' "+CRLF

//cQuery	+= " AND ZD2_AGENC = '"+PADL(MV_PAR02,"0",TAMSX3("ZD2_AGENC")[1])+"' "+CRLF
//cQuery	+= " AND ZD2_CONTA =  '"+PADL(MV_PAR03,"0",TAMSX3("ZD3_AGENC")[1])+"' "+CRLF
cQuery	+= " AND ZD2_DTCONC = ' ' "+CRLF

IF MV_PAR08 == 1	
	cQuery += " AND ZD2_VALOR > 0 "+CRLF
ELSEIF MV_PAR08 == 2
	cQuery += " AND ZD2_VALOR < 0"+CRLF	
ENDIF

cQuery	+= " AND ZD2.D_E_L_E_T_ = ' ' "+CRLF

MemoWrite(GetTempPath(.T.) + "CP09002_qExtrato.SQL", cQuery)

If Select("TQRY") > 0
	TQRY->(DbCloseArea())
EndIf

//dbUseArea(.T.,"TOPCONN",TCGenQRY(,,cQuery),'TQRY')
MsgRun( "Verificando Extrato Banc·rio", "ZD2", {|| dbUseArea(.T.,"TOPCONN",TCGenQRY(,,cQuery),'TQRY') } )


TCSetField("TQRY","ZD2_DATA","D",08,00)

nCpoQry	:= TQRY->(FCOUNT()) 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aHeader ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ 
aadd(aHeader,"")
aadd(aHeader,"")                      
aadd(aCpoHeader,"MARK")
aadd(aCpoHeader,"LEGENDA")
For nY := 1 To nCpoQry-1   
/*
	IF QRY->(FieldName(nY)) == "VLRCORR"	     
		aadd(aHeader,"Valor Corrigido")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "VLRMUL"
		aadd(aHeader,"Valor Multa")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "VLRJUR"
		aadd(aHeader,"Valor Juros")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "CNPJZTX"
		aadd(aHeader,"CNPJ Zatix")	
		aadd(aCpoHeader,FieldName(nY))				
	ELSEIF QRY->(FieldName(nY)) == "BANCO"
		aadd(aHeader,"Banco")	
		aadd(aCpoHeader,FieldName(nY))
	ELSE
	*/
	
		aadd(aHeader,ALLTRIM(RetTitle(FieldName(nY))))	
		aadd(aCpoHeader,FieldName(nY))
	//ENDIF 
Next nY	
aadd(aCpoHeader, "ZD2_RECNO")
aadd(aCpoHeader, "EXCONCI")


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis de posionamento dos campos ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nZD2VALOR		:=  Ascan(aCpoHeader,"ZD2_VALOR")
nZD2DATA		:=  Ascan(aCpoHeader,"ZD2_DATA")
nZD2DESC		:=  Ascan(aCpoHeader,"ZD2_DESC")
nZD2RECNO		:=  Ascan(aCpoHeader,"ZD2_RECNO")
nEXCONCI		:=  Ascan(aCpoHeader,"EXCONCI")


/*
nP04STATUS	:=  Ascan(aCpoHeader,"P04_STATUS")    
nP04ARQUIV	:=  Ascan(aCpoHeader,"P04_ARQUIV")
nP04RECNO	:=  Ascan(aCpoHeader,"P04_RECNO") 
*/

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aDados ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ 
IF TQRY->(!EOF())

	
	
	
	WHILE TQRY->(!EOF())
	
		aLinha	:= {}
		aadd(aLinha, .F.) //|MARK|
		aadd(aLinha, 0) //| LEGENDA|
		For nY := 1 To nCpoQry      
			aadd(aLinha, TQRY->(FIELDGET(nY)))
		Next nY	 
		aadd(aLinha, 0) //| EXCONCI |
		
		
		AADD(aDados, aLinha)
	

		TQRY->(DBSKIP())
	ENDDO   
	
	//nZD2RECNO	:= LEN(aDados[1])

	
	aRet[1]	:= .T.
	aRet[2]	:= aCpoHeader
	aRet[3]	:= aHeader
	aRet[4]	:= aDados

ELSE
 	aRet[1]	:= .F.
ENDIF                  

TQRY->(DbCloseArea())

Return (aRet)






/*‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥ OrdExt   ∫Autor  ≥ Augusto Ribeiro	 ∫ Data ≥  12/03/11   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥  Orderna Coluna que o usuario realizar o click ou          ∫±±
±±∫          ≥Marca/Desmarca todos os registros selecionados              ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ*/
Static Function OrdExt(oLbxAux, nCol, lMark)
Local nI 
	Default lMark	:= .F.

	//lMarkAll	:= .F. 
	
	If	nCol > 0

		//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
		//≥ Marca/Desmarca Registrios ≥
		//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
		If nCol == 1
			IF  nConcTaxa == OPCAO_TAXA //| tAXA|
				lAllExt	:= !(lAllExt)
				
				FOR nI :=  1 TO LEN(oLbxAux:aArray)
					IF lAllExt <> oLbxAux:aArray[nI,1]
						oLbxAux:nAt	:= nI
						SelEx(@oLbxAux)
					ENDIF
				Next nY
	
				//aEval(oLbxAux:aArray, {|x| x[1] := lAllExt} )
				nAntExt := nCol
			endif

			//oTotal:Refresh()
			//oTotSel:Refresh()
			//oTotalP:Refresh()
			//oTotSelP:Refresh()
		ELSEIF nCol == nAntExt
			aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] < y[nCol] })
			nAntExt := 0
		Else
			aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] > y[nCol] })
			nAntExt := nCol
		EndIf

		oLbxAux:Refresh()

	EndIf

Return()



/*/{Protheus.doc} CP902LMV
Montas Listbox com dados do Movimento Bancario
@author Augusto Ribeiro | www.compila.com.br
@since 26/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP902LMV(cOpcList, oLbxMv, aCpoHeader, aHeader, aDados, oPanel )
Local lRet			:= .T.
Local aVlrCor		:= {} 


Private aCpoHeader

Default	cOpcList	:= "C"

Default aCpoHeader	:= {} 
Default aHeader		:= {} 
Default aDados		:= {}

Default	oLbxMv		:= NIL
Default	oPanel		:= NIL


//IF cOpcList	== "A"
	aRetAux		:= qMovimen() 
	aDadosMv	:= {}
	//IF aRetAux[1]
		aCpoMv		:= aRetAux[2]
		aHeadMv		:= aRetAux[3]
		aDadosMv	:= aRetAux[4]
		nDadosMv	:= 0
		IF !EMPTY(aDadosMv)
			nDadosMv	:= len(aDadosMv[1])
		ENDIF

			
		lRet	:= .T.
	
	//ELSE
		//Help(" ",1,"VAZIO",,"N„o existem registros no periodo selecionado.",4,5)
		//lVazio	:= .T.
	//ENDIF




aCpoHeader		:= aCpoMV
aHeader			:= aHeadMV
aDados			:= aDadosMV
//aDadosLbx		:= aClone(aDadoTit)	
lVazioMv := empty(aDadosMv)

ListMov(cOpcList, @oLbxMv, @aCpoHeader, @aHeader, @aDados, @oPanel)
IF !(lVazioMv) .AND. !(lVazioEx) 
	
	/*
	IF VALTYPE(oLbxEx) == "O"
		oLbxEx:lVisibleControl := .T.
	ENDIF	
	IF VALTYPE(oLbxMv) == "O"
		oLbxMv:lVisibleControl := .T.
	ENDIF	
	*/
ELSE
/*
	IF VALTYPE(oLbxEx) == "O"
		oLbxEx:lVisibleControl := .F.
	ENDIF	
	IF VALTYPE(oLbxMv) == "O"
		oLbxMv:lVisibleControl := .F.
	ENDIF
*/
ENDIF 

Return()


/*/{Protheus.doc} MontLis
Monta Interface de seleÁ„o
@author Jonatas Oliveira | www.compila.com.br
@since 14/04/2016
@version 1.0
/*/
Static Function ListMov(cOpcList, oLbxMv, aCpoHeader, aHeader, aDados, oPanel)

	Local cBCodLin		:= ""   
	Local oOk 	     	:= LoadBitmap( GetResources(), "LBOK" )
	Local oNo   	   	:= LoadBitmap( GetResources(), "LBNO" )
	Local oVerde   	   	:= LoadBitmap( GetResources(), "BR_VERDE" )
	Local oAmarelo   	:= LoadBitmap( GetResources(), "BR_AMARELO" )
	Local oAzul   		:= LoadBitmap( GetResources(), "BR_AZUL" )
	Local oCinza   	   	:= LoadBitmap( GetResources(), "BR_CINZA" )
	Local oBranco   	:= LoadBitmap( GetResources(), "BR_BRANCO" )
	Local oFLabels 		:= TFont():New("Verdana",,018,,.T.,,,,,.F.,.F.)
	Local oFGrpCpo 		:= TFont():New("Verdana",,016,,.F.,,,,,.F.,.F.)

	Private oDlgMain	:= NIL
	

	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ cOpcList | C = Cria, A = Atualiza ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	IF cOpcList == "C"
	
		

		@ 3, 5 SAY oLblSolicita PROMPT "Sistema" SIZE 50, 012 OF oPanel FONT oFLabels COLORS RGB(56,141,191), 16777215 PIXEL
		@ 12,0 LISTBOX oLbxMv FIELDS HEADER ;
		" ", "Campos" ;   
		FONT oFList;                                                                                                 
		SIZE (oPanel:nClientWidth/2)-5,(oPanel:nClientHeight/2)-12 OF oPanel PIXEL ON  dblClick()

		oLbxMv:aheaders := aHeader			   
		oLbxMv:BHEADERCLICK	:= { |oObj,nCol|  OrdMv( oObj,nCol, .T.) }	
		
		//oLbxMv:bLDblClick := { |nRow,nCol,nFlags| EditLBoxCBox(@oLbxMv) }	
		oLbxMv:bLDblClick := { |nRow,nCol,nFlags| dbClickMv(@nRow,@nCol,@nFlags) }
		
				
	ENDIF
	
	IF EMPTY(aDados)
		aDados	:= {{}}
		aadd(aDados[1], .F.)
		aadd(aDados[1], 0)
		
		FOR nI := 3 to len(aCpoMv)
		
			IF EMPTY(RetTitle(aCpoMv[nI]))
				xVlrAux	:= 0
			ELSE
				xVlrAux	:= CRIAVAR(aCpoMv[nI],.F.)
			ENDIF
			aadd(aDados[1], xVlrAux)
		NEXT nI
	ENDIF   
	
		
	oLbxMv:nAt	:= 1
	
	

	/*
	@  250, 40 		SAY oLblSolicita PROMPT "Total " 		SIZE 50, 014 OF oDlgMain FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotalP := TGet():Create( oDlgMain,{|| CalcTot("TP", @aDadoMain)},250, 40	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalP,,,, )
	*/
	oLbxMv:SetArray( aDados )  
	//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
	//≥ Cria string com Bloco de Codigo ≥
	//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
	//cBCodLin	:= "Iif(aDados[oLbxMv:nAt,1],oOk,oNo)" //", Iif(aDados[oLbxMv:nAt,2]==2,oVerde,Iif(aDados[oLbxMv:nAt,2]==1,oAmarelo ,oCinza))"
	cBCodLin	:= "Iif(aDados[oLbxMv:nAt,1],oOk,oNo), Iif(aDados[oLbxMv:nAt,2]==2,oVerde,Iif(aDados[oLbxMv:nAt,2]==3,oAzul, Iif(aDados[oLbxMv:nAt,2]==1,oAmarelo , Iif(aDados[oLbxMv:nAt,2]==4, oBranco, oCinza))))"		
	

	For nI := 3 To LEN(aHeader)
		IF nI > 1
			cBCodLin	+=", "
		endif
		cI	:= alltrim(str(nI))
		
		IF ALLTRIM(aCpoHeader[nI]) $ "E5_VALOR"
			cBCodLin	+= "Transform(aDados[oLbxMv:nAt,"+cI+"], '"+D_PICTURE_VLR+"')"
		ELSE
			cBCodLin	+= "aDados[oLbxMv:nAt,"+cI+"]"		
		ENDIF
		
	Next nI	

	cBCodLin	:= "oLbxMv:bLine := {|| {"+cBCodLin+"}}"
	&(cBCodLin)            
	
	oLbxMv:Refresh()

Return    






/*/{Protheus.doc} qMovimen
Busca registros da movimentaÁ„o Banc·ria
@author Augusto Ribeiro | www.compila.com.br
@since 16/04/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function qMovimen()
Local aCpoHeader	:= {} 
Local aHeader		:= {} 
Local aDados		:= {}
Local aRet			:= {.F., aCpoHeader, aHeader, aDados}
//Local cAbatim		:= alltrim(MVABATIM) + "|" + alltrim(MVRECANT) + "|" + alltrim(MV_CRNEG)
Local nCpoQry		:= 0
Local nY, nI
Local cQuery		:= "" 


cQuery := " SELECT  E5_DTDISPO,  "+CRLF
cQuery += " 	CASE WHEN E5_RECPAG = 'R' THEN E5_VALOR ELSE E5_VALOR*-1 END AS E5_VALOR,  "+CRLF
cQuery += " 	E5_HISTOR, E5_FILIAL, E5_NATUREZ, E5_CCUSTO, E5_CCC, E5_CCD, E5_CLVLCR, CTHC.CTH_DESC01 AS CL_CREDITO, E5_CLVLDB, CTHD.CTH_DESC01 AS CL_DEBITO,  E5_MOTBX, SE5.R_E_C_N_O_ as SE5_RECNO "+CRLF
cQuery += " FROM "+RetSqlName("SE5")+" SE5 "+CRLF
cQuery += " LEFT JOIN "+RetSqlName("CTH")+" CTHC  "+CRLF
cQuery += " ON CTHC.CTH_FILIAL = '"+XFILIAL("CTH")+"'  "+CRLF
cQuery += " AND CTHC.CTH_CLVL = E5_CLVLCR  "+CRLF
cQuery += " AND CTHC.D_E_L_E_T_ = ' '  "+CRLF
cQuery += " LEFT JOIN "+RetSqlName("CTH")+" CTHD  "+CRLF
cQuery += " ON CTHD.CTH_FILIAL = '"+XFILIAL("CTH")+"'  "+CRLF
cQuery += " AND CTHD.CTH_CLVL = E5_CLVLDB  "+CRLF
cQuery += " AND CTHD.D_E_L_E_T_ = ' '  "+CRLF
cQuery += " WHERE E5_FILIAL BETWEEN '"+cpFilDe+"' AND '"+cpFilAte+"' "
cQuery += " AND E5_BANCO = '"+cpBanco+"' "+CRLF
cQuery += " AND E5_AGENCIA = '"+cpAg+"' "+CRLF
cQuery += " AND E5_CONTA = '"+cpConta+"' "+CRLF
cQuery += " AND E5_DTDISPO BETWEEN '"+DTOS(dpDtMvDe)+"' AND '"+DTOS(dpDtMvAte)+"' "+CRLF
//cQuery += " AND E5_TIPODOC NOT IN ('JR','DC') "+CRLF
cQuery += " AND (E5_TIPODOC NOT IN ('JR','DC','MT',' ')  OR  ( (E5_TIPODOC = ' ' AND E5_LOTE = ' '))) "+CRLF
cQuery += " AND E5_RECONC = ' ' "+CRLF
cQuery += " AND E5_SITUACA <> 'C' "+CRLF
//cQuery += " AND UPPER(E5_HISTOR) NOT LIKE 'BX RET CNAB LOTE:%' "+CRLF
IF MV_PAR08 == 1
	cQuery += " AND E5_RECPAG = 'R' "+CRLF
ELSEIF MV_PAR08 == 2
	cQuery += " AND E5_RECPAG = 'P' "+CRLF	
ENDIF
cQuery += " AND SE5.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " ORDER BY E5_DTDISPO, SE5.R_E_C_N_O_ "+CRLF

//cQuery	:= changeQuery(cQuery)
MemoWrite(GetTempPath(.T.) + "CP09002_qMovimen.SQL", cQuery)	

If Select("TQRY") > 0
	TQRY->(DbCloseArea())
EndIf

//dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TQRY')
MsgRun ( "Verificando MovimentaÁ„o Banc·ria", "SE5", {|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),'TQRY') } )

TCSetField("TQRY","E5_DTDISPO","D",08,00)

nCpoQry	:= TQRY->(FCOUNT()) 

//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aHeader ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ 
aadd(aHeader,"")
aadd(aHeader,"")                      
aadd(aCpoHeader,"MARK")
aadd(aCpoHeader,"LEGENDA")
//aadd(aCpoHeader,"")
For nY := 1 To nCpoQry-1   
/*
	IF QRY->(FieldName(nY)) == "VLRCORR"	     
		aadd(aHeader,"Valor Corrigido")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "VLRMUL"
		aadd(aHeader,"Valor Multa")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "VLRJUR"
		aadd(aHeader,"Valor Juros")	
		aadd(aCpoHeader,FieldName(nY))
	ELSEIF QRY->(FieldName(nY)) == "CNPJZTX"
		aadd(aHeader,"CNPJ Zatix")	
		aadd(aCpoHeader,FieldName(nY))				
	ELSEIF QRY->(FieldName(nY)) == "BANCO"
		aadd(aHeader,"Banco")	
		aadd(aCpoHeader,FieldName(nY))
	ELSE
	*/
	
		aadd(aHeader,ALLTRIM(RetTitle(FieldName(nY))))	
		aadd(aCpoHeader,FieldName(nY))
	//ENDIF 
Next nY	
aadd(aCpoHeader,"SE5_RECNO")
aadd(aCpoHeader,"SE5ZD2")
aadd(aCpoHeader,"MVCONCI")


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Variaveis de posionamento dos campos ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ
nE5DTDISPO		:=  Ascan(aCpoHeader,"E5_DTDISPO")
nE5VALOR		:=  Ascan(aCpoHeader,"E5_VALOR")
nE5HISTOR		:=  Ascan(aCpoHeader,"E5_HISTOR")
nE5FILIAL		:=  Ascan(aCpoHeader,"E5_FILIAL")
nE5NATUREZ		:=  Ascan(aCpoHeader,"E5_NATUREZ")
nE5CCUSTO		:=  Ascan(aCpoHeader,"E5_CCUSTO")
nE5CCC			:=  Ascan(aCpoHeader,"E5_CCC")
nE5CCD			:=  Ascan(aCpoHeader,"E5_CCD")
nE5CLVLCR		:=  Ascan(aCpoHeader,"E5_CLVLCR")
nCLCREDITO		:=  Ascan(aCpoHeader,"CL_CREDITO")
nE5CLVLDB		:=  Ascan(aCpoHeader,"E5_CLVLDB")
nCLDEBITO		:=  Ascan(aCpoHeader,"CL_DEBITO")
nE5MOTBX		:=  Ascan(aCpoHeader,"E5_MOTBX")

nSE5RECNO		:=  Ascan(aCpoHeader,"SE5_RECNO")
nSE5ZD2			:=  Ascan(aCpoHeader,"SE5ZD2")

nMVCONCI		:=  Ascan(aCpoHeader,"MVCONCI")


//⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
//≥ Monta aDados ≥
//¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ 
IF TQRY->(!EOF())

	
	
	
	WHILE TQRY->(!EOF())
	
		aLinha	:= {}
		aadd(aLinha, .F.)
		aadd(aLinha, 0) //| LEGENDA|
		For nY := 1 To nCpoQry      
			aadd(aLinha, TQRY->(FIELDGET(nY)))
		Next nY	 
		
		/*------------------------------------------------------ Augusto Ribeiro | 27/12/2016 - 11:19:35 AM
			Ultimo registro indica o RECNO do extrato 
			no qual esta vinculado
		------------------------------------------------------------------------------------------*/
		aadd(aLinha, 0) // SE5ZD2
		aadd(aLinha, 0) //| MVCONCI |
		
		AADD(aDados, aLinha)
	

		TQRY->(DBSKIP())
	ENDDO   

	//nSE5ZD2 	:= len(aDados[1])
	//nSE5RECNO	:= nSE5ZD2-1

		
	
	aRet[1]	:= .T.
	aRet[2]	:= aCpoHeader
	aRet[3]	:= aHeader
	aRet[4]	:= aDados

ELSE
 	aRet[1]	:= .F.
ENDIF                  


Return (aRet)




/*/{Protheus.doc} OrdMv
Orderna Coluna que o usuario realizar o click ou  Marca/Desmarca todos os registros selecionados  
@author aribeiro
@since 12/03/2011
@version 6
@example
(examples)
@see (links_or_references)
/*/
Static Function OrdMv(oLbxAux, nCol, lMark)
Local nI	:= 0
Default lMark	:= .F.


	Processa({ || OrdMvP( oLbxAux,nCol, lMark)}, "Selecionando Registros..." )
	
Return()

/*/{Protheus.doc} OrdMvP
(long_description)
@author Augusto Ribeiro | www.compila.com.br
@since 12/01/2018
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/	
Static Function OrdMvP(oLbxAux, nCol, lMark)
Local nI	:= 0
Default lMark	:= .F.

	
	//lMarkAll	:= .F. 
	
	If	nCol > 0

		//-------------------------------
		//  Marca/Desmarca Registrios 
		//-------------------------------
		If nCol == 1
		
			ProcRegua(LEN(oLbxAux:aArray))  
			
		
			IF  nConcTaxa == OPCAO_CONCILIACAO 
				lAllMv	:= !(lAllMv)
				
				FOR nI :=  1 TO LEN(oLbxAux:aArray)
				
					IncProc("Selecionando.. ")
				
					IF lAllMv <> oLbxAux:aArray[nI,1]
						oLbxAux:nAt	:= nI
						//SelEx(@oLbxAux)
						dbClickMv(nI,1)
					ENDIF
				Next nY
	
				//aEval(oLbxAux:aArray, {|x| x[1] := lAllExt} )
				nAntExt := nCol
			endif		
		
		
		ELSEIF nCol == nAntMv
			aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] < y[nCol] })
			nAntMv := 0
		Else
			aSort(oLbxAux:aArray,,,{ |x,y| x[nCol] > y[nCol] })
			nAntMv := nCol
		EndIf

		oLbxAux:Refresh()


	EndIf

Return()


/*/{Protheus.doc} SelEx
Double Click Extrato
@author Augusto Ribeiro | www.compila.com.br
@since 26/12/2016
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function SelEx(oLbxAux)
Local nPosAux, nI
Local nMarkAnt	:= 0

IF !(lVazioEx)
	/*-----------------------------
		CONCILIACAO DE MOVIMENTOS
	------------------------------*/
	IF nConcTaxa == OPCAO_CONCILIACAO .AND. aDadosEx[oLbxAux:nAt,2] <> D_TAXA
		
		
		/*--------------------------
			REMOVENDO SELECAO
		---------------------------*/
		IF aDadosEx[oLbxAux:nAt,1]
			IF aDadosEx[oLbxAux:nAt,2] == D_CONCILIADO .OR.  aDadosEx[oLbxAux:nAt,2] == D_CONCILIADO_AUTO
				nMarkAnt	:= aDadosEx[oLbxAux:nAt,nEXCONCI]
			ENDIF
		 	aDadosEx[oLbxAux:nAt,1] 		:= .F.
		 	aDadosEx[oLbxAux:nAt,2] 		:= D_NAOSELECIONADO
		 	aDadosEx[oLbxAux:nAt,nEXCONCI] 	:= 0
		 	nTotExCon 						:= nTotExCon - aDadosEx[oLbxAux:nAt,nZD2VALOR]
		 	
		 	
		 	IF !EMPTY(nMarkAnt)
		 		DesmConc(nMarkAnt)
		 	ENDIF
		 	
		ELSE
			/*
			IF ((nTotExCon > 0 .OR. nTotMvCon > 0) .and. aDadosEx[oLbxAux:nAt,nZD2VALOR] > 0 ) .OR.;
				((nTotExCon < 0 .OR. nTotMvCon < 0) .and. aDadosEx[oLbxAux:nAt,nZD2VALOR] < 0 ) .OR.;
				nTotExCon == 0 .and. nTotMvCon == 0
			*/
				/*--------------------------
					SELECIONANDO
				---------------------------*/		
				aDadosEx[oLbxAux:nAt,1] 		:= .T.
				aDadosEx[oLbxAux:nAt,2] 		:= D_SELECIONADO
				aDadosEx[oLbxAux:nAt,nEXCONCI] 	:= nMarkConc
				nTotExCon 						:= nTotExCon + aDadosEx[oLbxAux:nAt,nZD2VALOR]
				
			//endif
		ENDIF
		
		/*--------------------------
			Conferencia dos valores selecionados
			e alteracao do status
		---------------------------*/
		ConfVlr()
	
	/*-----------------------------
		IDENTIFICA«√O DE TAXAS
	------------------------------*/	
	ELSEIF nConcTaxa == OPCAO_TAXA .AND. (aDadosEx[oLbxAux:nAt,2] == D_TAXA .OR. aDadosEx[oLbxAux:nAt,2] == D_NAOSELECIONADO)
	
		IF aDadosEx[oLbxAux:nAt,1]
		 	aDadosEx[oLbxAux:nAt,1] 	:= .F.
		 	aDadosEx[oLbxAux:nAt,2] 	:= D_NAOSELECIONADO
		 	
		 	
		 	nPosAux	:=  aScan(aDadosMv, { |x| x[nSE5ZD2] ==  aDadosEx[oLbxAux:nAt, nZD2RECNO]})
		 	IF nPosAux > 0
		 		aDel(aDadosMv, nPosAux)
		 		aSize(aDadosMv, LEN(aDadosMv)-1)
		 		oLbxMv:nAt	:= 1
		 	ENDIF
		 	
		 
		 ELSEIF !(aDadosEx[oLbxAux:nAt,1])
	 	 	aDadosEx[oLbxAux:nAt,1] 	:= .T.
	 	 	aDadosEx[oLbxAux:nAt,2] 	:= D_TAXA
	 	 
	 	 	/*------------------------------------------------------ Augusto Ribeiro | 30/12/2016 - 10:51:14 AM
	 	 		CRIA REGISTRO NA TABELA DE MOVIMENTOS.
	 	 	------------------------------------------------------------------------------------------*/
	 	 	aLinha	:= {}
	 	 	FOR nI := 1 TO LEN(aCpoMv)
	 	 		xValor	:= NIL
	 	 		IF aCpoMv[nI] == "MARK"
	 	 			xValor	:= .F.
	 	 		ELSEIF aCpoMv[nI] == "LEGENDA"
	 	 			xValor	:= aDadosEx[oLbxAux:nAt,2] 	 			
	 	 		ELSEIF aCpoMv[nI] == "E5_DTDISPO"
	 	 			xValor	:= aDadosEx[oLbxAux:nAt,nZD2DATA]
	 	 		ELSEIF aCpoMv[nI] == "E5_VALOR"
	 	 			xValor	:= aDadosEx[oLbxAux:nAt,nZD2VALOR]
	 	 		ELSEIF aCpoMv[nI] == "E5_HISTOR"
	 	 			xValor	:= aDadosEx[oLbxAux:nAt,nZD2DESC]
	 	 		ELSEIF aCpoMv[nI] == "E5_FILIAL"
	 	 			xValor	:= CRIAVAR("E5_FILIAL",.F.) 	 			
	 	 			xValor	:= PADR(cFILMVPAR, LEN(xValor))
	 	 		ELSEIF aCpoMv[nI] == "E5_CCUSTO"
	 	 			xValor	:= CRIAVAR("E5_CCUSTO",.F.)
	 	 			xValor	:= PADR(cCTTMVPAR , LEN(xValor))
	 	 		
	 	 		ELSEIF aCpoMv[nI] == "E5_CCC" .AND. aDadosEx[oLbxAux:nAt,nZD2VALOR] >= 0
	 	 			xValor	:= CRIAVAR("E5_CCC",.F.)
	 	 			xValor	:= PADR(cCTTMVPAR , LEN(xValor))
	 	 			
	 	 		ELSEIF aCpoMv[nI] == "E5_CCD" .AND. aDadosEx[oLbxAux:nAt,nZD2VALOR] < 0
	 	 			xValor	:= CRIAVAR("E5_CCD",.F.)
	 	 			xValor	:= PADR(cCTTMVPAR , LEN(xValor))	 	 		
	 	 			
	 	 		ELSEIF aCpoMv[nI] == "E5_CLVLCR" .AND. aDadosEx[oLbxAux:nAt,nZD2VALOR] >= 0
	 	 			xValor	:= CRIAVAR("E5_CLVLCR",.F.)
	 	 			xValor	:= PADR(cCTHMVPAR , LEN(xValor))
	 	 			
	 	 		ELSEIF aCpoMv[nI] == "E5_CLVLDB" .AND. aDadosEx[oLbxAux:nAt,nZD2VALOR] < 0
	 	 			xValor	:= CRIAVAR("E5_CLVLDB",.F.)
	 	 			xValor	:= PADR(cCTHMVPAR , LEN(xValor))	 	 				 		
	 	 				 	 			
	 	 			
	 	 		ELSEIF aCpoMv[nI] == "E5_NATUREZ"
	 	 			xValor	:= CRIAVAR("E5_NATUREZ",.F.)
	 	 			xValor	:= PADR(cSEDMVPAR, LEN(xValor))
	 	 		ELSEIF aCpoMv[nI] == "SE5_RECNO"
	 	 			xValor	:= 0
	 	 		ELSEIF aCpoMv[nI] == "SE5ZD2"
	 	 			xValor	:= aDadosEx[oLbxAux:nAt,nZD2RECNO]
	 	 		ELSEIF aCpoMv[nI] == "MVCONCI"
	 	 			xValor	:= 0
	 	 		ENDIF
	 	 		
	 	 		aadd(aLinha, xValor)
	 	 	NEXT nI
	 	 	
	 	 	aadd(aDadosMv, aLinha)
	 	 	oLbxMv:nAt	:= len(aDadosMv)//| Posiciona no registro adicionado. | 
	 	 	SelMov(@oLbxMv, .T. )
	 	 	
		ENDIF
	ENDIF
ENDIF


oLbxMv:Refresh()

Return()

/*/{Protheus.doc} SelMov
Double Click Extrato
@author Augusto Ribeiro | www.compila.com.br
@since 26/12/2016
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function SelMov(oLbxAux, lForceMark)
Local nI, nVlrMov, nDif, nPosAux
Local nPosAux, nPosEx	
Local nMarkAnt	:= 0

Default lForceMark	:= .f.


nPosEx := aScan(aDadosEx, { |x| x[2] ==  D_SELECIONADO})



/*-----------------------------
	CONCILIACAO DE MOVIMENTOS
------------------------------*/
IF nConcTaxa == OPCAO_CONCILIACAO
	
	
	/*--------------------------
		REMOVENDO SELECAO
	---------------------------*/	
	IF aDadosMv[oLbxAux:nAt,1]
		
		IF aDadosMv[oLbxAux:nAt,2] == D_CONCILIADO .OR.  aDadosMv[oLbxAux:nAt,2] == D_CONCILIADO_AUTO
			nMarkAnt	:= aDadosMv[oLbxAux:nAt,nMVCONCI]
		ENDIF		
		aDadosMv[oLbxAux:nAt,1] 		:= .F.
		aDadosMv[oLbxAux:nAt,2] 		:= D_NAOSELECIONADO
		aDadosMv[oLbxAux:nAt,nMVCONCI] 	:= 0
		nTotMvCon 						:= nTotMvCon - aDadosMv[oLbxAux:nAt,nE5VALOR]
		
	 	IF !EMPTY(nMarkAnt)
	 		DesmConc(nMarkAnt)
	 	ENDIF	 	
	ELSE
		/*
		IF ((nTotExCon > 0 .OR. nTotMvCon > 0) .and. aDadosMv[oLbxAux:nAt,nE5VALOR] > 0 ) .OR.;
			((nTotExCon < 0 .OR. nTotMvCon < 0) .and. aDadosMv[oLbxAux:nAt,nE5VALOR] < 0 ) .OR.;
			nTotExCon == 0 .and. nTotMvCon == 0
			*/
			/*--------------------------
				SELECIONANDO
			---------------------------*/		
			aDadosMv[oLbxAux:nAt,1] 		:= .T.
			aDadosMv[oLbxAux:nAt,2] 		:= D_SELECIONADO
			aDadosMv[oLbxAux:nAt,nMVCONCI] 	:= nMarkConc
			nTotMvCon 						:= nTotMvCon + aDadosMv[oLbxAux:nAt,nE5VALOR]
		//ENDIF
			
	ENDIF
		
	/*--------------------------
		Conferencia dos valores selecionados
		e alteracao do status
	---------------------------*/
	ConfVlr()

/*-----------------------------
	IDENTIFICA«√O DE TAXAS
------------------------------*/	
ELSEIF nConcTaxa == OPCAO_TAXA

	IF aDadosMv[oLbxAux:nAt,1]
		nPosAux	:=  aScan(aDadosEx, { |x| x[nZD2RECNO] ==  aDadosMv[oLbxAux:nAt, nSE5ZD2]})
		
		
		IF nPosAux > 0
		 	Help(" ",1,"SELECAO",,"Este registro n„o pode ser desmarcad pois esta vinculado a um registro de taxa do extrato. Desmarque o item do extrato antes de continuar",4,5)
		 	oLbxEx:nAt	:= nPosEx
		ENDIF
	ELSE
		nPosEx := aScan(aDadosEx, { |x| x[2] ==  D_SELECIONADO})
		IF !EMPTY(nPosEx) .or. lForceMark
			aDadosMv[oLbxAux:nAt,1] 		:= .T.
			aDadosMv[oLbxAux:nAt,nSE5ZD2]	:=  aDadosEx[oLbxEx:nAt,nZD2RECNO]	
		ELSE
		 	Help(" ",1,"SELECAO",,"Este registro n„o pode ser desmarcad pois esta vinculado a um registro de taxa do extrato. Desmarque o item do extrato antes de continuar",4,5)
		 	IF nPosEx > 0
		 		oLbxEx:nAt	:= nPosEx
		 	ENDIF		
		ENDIF	
	ENDIF

ENDIF

oLbxEx:Refresh()

oView	:= FWViewActive()

oView:Refresh()

Return()





/*/{Protheus.doc} CP901BTN
Chamada de botoes da enchoice bar
@author Augusto Ribeiro | www.compila.com.br
@since 29/12/2016
@version 1.0
@param cBtn, C, Botao pressionado
@param oView, O, Objeto da View [Default: FWViewActive()]
@return ${return}, ${return_description}
/*/
User Function CP901BTN(cBtn, oView)
Local oView, nTotLen
Local oModFull
Local cPathDest, cPathArq


IF VALTYPE(oView) <> "O"
	oView	:= FWViewActive()
ENDIF

//| Visualizacao do arquivo onde o cursor esta posicionado
IF cBtn == "PERG_CONC"
	
	PERGUNTE(D_PERG2,.T.)
	lISelec		:= (MV_PAR01==1)
	lExecConc	:= (MV_PAR02==1)
	cFILMVPAR	:= MV_PAR03
	cSEDMVPAR	:= MV_PAR04
	cCTTMVPAR	:= MV_PAR05

ELSEIF cBtn == "PERG_FILTRO"

	IF PERGUNTE(D_PERG,.T.)	
	
		cpFilDe		:= MV_PAR01
		cpFilAte	:= MV_PAR02
		cpBanco		:= MV_PAR03
		cpAg		:= MV_PAR04
		cpConta		:= MV_PAR05
		dpDtMvDe	:= MV_PAR06
		dpDtMvAte	:= MV_PAR07
		npTpMov		:= MV_PAR08
	
	
		fAtualiza()
	ENDIF
	
ELSEIF cBtn== "CONC_AUTO"

	/*------------------------------------------------------ Augusto Ribeiro | 29/12/2016 - 3:52:43 PM
		Realiza a conciliaÁ„o autom·tica dos itens listados
	------------------------------------------------------------------------------------------*/
	Processa({|| ConcAuto() }, "ConciliaÁ„o Autom·tica... ")
	
ELSEIF cBtn== "CONC_SEMI"

	/*------------------------------------------------------ Augusto Ribeiro | 29/12/2016 - 3:52:43 PM
		Realiza a conciliaÁ„o autom·tica dos itens listados
	------------------------------------------------------------------------------------------*/
	Processa({|| ConcSemi() }, "ConciliaÁ„o Semi-Automatica... ")
		
	
ELSEIF cBtn== "EFETIVA"

	IF AVISO("Efetiva ConciliaÁ„o", "Ser· efetivado a conciliaÁ„o de todos os movimentos selecionado."+CRLF+;
									"Deseja continuar ?", {"Sim", "N„o"},2) == 1
	
		Processa({|| fEfetiva() }, "Efetivando ConciliaÁ„o... ")
	ENDIF
	
ELSEIF cBtn== "TRANSF"	
	fTransf()
	
ELSEIF cBtn== "FCP"	

	FINA750()
	//bWindowInit := { || __Execute( "FINA750()" , "xxxxxxxxxxxxxxxxxxxx" , "FINA750" , "SIGAFIN" , "SIGAFIN", 1 , .T. ) }
	//EVAL(bWindowInit)
	
	fAtualiza()

ELSEIF cBtn== "FCR"

	FINA740()
	//bWindowInit := { || __Execute( "FINA740()" , "xxxxxxxxxxxxxxxxxxxx" , "FINA740" , "SIGAFIN" , "SIGAFIN", 1 , .T. ) }
	//EVAL(bWindowInit)	
	
	fAtualiza()
		
ELSEIF cBtn== "CONC_PADRAO"

	FINA380()

	fAtualiza()
				
ENDIF 

Return()







/*/{Protheus.doc} ListTot
Atualiza Totalizadores da Interface
@author Jonatas Oliveira | www.compila.com.br
@since 31/03/2016
@version 1.0
/*/
Static Function ListTot(oPanelr)
Local cBCodLin		:= ""   
Local oOk 	     	:= LoadBitmap( GetResources(), "LBOK" )
Local oNo   	   	:= LoadBitmap( GetResources(), "LBNO" )
Local oFLabels 		:= TFont():New("MS Sans Serif",,022,,.F.,,,,,.F.,.F.)
Local aVlrCor		:= {} 
Local oFGrpCpo := TFont():New("Verdana",,016,,.F.,,,,,.F.,.F.)
Local nI		:= 1

Private oDlgMTot	:= NIL

Private cTotalS	:= ""
Private cTotalA	:= ""
Private cTotalB	:= ""
Private cTotalC	:= ""
Private cTotalD	:= ""
Private cTotalE	:= ""
Private nTotalA	:= 0

IF !EMPTY(oPanelr)

	oPaneRod	:= @oPanelr
	nPosCentro	:= (oPanelr:nClientWidth/4)
	nPosFim		:= (oPanelr:nClientWidth/2)
	
	//@  200, 200		SAY oLblSolicita PROMPT "Acrescimo: "				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL	
	
	//@  230, 120 		SAY oLblSolicita PROMPT "" 					SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	//oTotAcres := TGet():Create( oPanelr,{|| 1},230, 200	, 050,009,D_PICTURE_VLR,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalS,,,, )
	
	@  7, 5 		SAY oLblSolicita PROMPT "Extrato"				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotEx := TGet():Create( oPanelr,{|| CalcTot("EXTRATO") },5, 050	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalA,,,, )

	@  20, 5		SAY oLblSolicita PROMPT "Selecionado"				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oSelEx := TGet():Create( oPanelr,{|| CalcTot("SELECIONADO_EX") },19, 050	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cSelEx,,,, )
		
		
	//@  7, 100 		SAY oLblSolicita PROMPT "Vencidos" 				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	//oTotVenc := TGet():Create( oPanelr,{|| 3},5, 130	, 050,009,D_PICTURE_VLR,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalS,,,, )
	
	@  7, nPosCentro-50 		SAY oLblSolicita PROMPT "Conciliado" 				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotCon:= TGet():Create( oPanelr,{|| CalcTot("CONCILIADO")},5, nPosCentro-10	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalC,,,, )

	@  20, nPosCentro-50 		SAY oLblSolicita PROMPT "LanÁamento" 				SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotTaxa:= TGet():Create( oPanelr,{|| CalcTot("TAXA")},17, nPosCentro-10	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalD,,,, )	
		
		
	//oCheck1 := TCheckBox():New(07,nPosCentro+50,'CheckBox 001',{|| SelChek("CONCILIA")},oPanelr,100,210,,,,,,,,.T.,,,)
   	//oCheck2 := TCheckBox():New(18,nPosCentro+50,'CheckBox 002',{|| SelChek("TAXA")},oPanelr,100,210,,,,,,,,.T.,,,)		
		
   	//oCheck1 := TCheckBox():New(07,nPosCentro+50,'CheckBox 001',{|| lSelConc},oPanelr,100,210,,,,,,,,.T.,,,)
   	//oCheck2 := TCheckBox():New(18,nPosCentro+50,'CheckBox 002',{|| lSelTaxa},oPanelr,100,210,,,,,,,,.T.,,,)
   	
   	
   	aRadio := {'Concilia','LanÁamento'}
  // 	oRadio := TRadMenu():Create (oPanelr,,07,nPosCentro+50,aItens,,,,,,,,100,12,,,,.T.)
  //	oRadio := TRadMenu():New (07,nPosCentro+50,aItens,,oPanelr,,,,,,,,100,12,,,,.T.)
  	oRadio:= tRadMenu():New(7,nPosCentro+50,aRadio,{|u|if(PCount()>0,nConcTaxa:=u,nConcTaxa)},oPanelr,,,,,,,,140,8,,,,.T.)  
   	//oRadio:bSetGet := {|u|Iif(PCount()==0,nRadio,nRadio:=u)}
				
		
	//@ 7,010 Radio _oResp Var _xResp 3D Size _nLrg,_nAlt Prompt "Sim","N„o" Of _oDlgResp Pixel		
		
		
	@  7, nPosFim-100  		SAY oLblSolicita PROMPT "Sistema"		SIZE 50, 190 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oTotMv := TGet():Create( oPanelr,{|| CalcTot("MOVIMENTO")},5, nPosFim-60	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalMv,,,, )

	@  20, nPosFim-107  		SAY oLblSolicita PROMPT "Selecionado"		SIZE 50, 190 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL
	oSelMv := TGet():Create( oPanelr,{|| CalcTot("SELECIONADO_MV")},19, nPosFim-60	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cSelMv,,,, )
	
	
	/*
	@  20, 120		SAY oLblSolicita PROMPT "Acrescimo: "			SIZE 50, 024 OF oPanelr FONT oFGrpCpo COLORS 128, 16777215 PIXEL		
	oTotalP := TGet():Create( oPanelr,{|| CalcTot("ACRESS", @aDadoTit)},20, 120	, 050,009,D_PICTURE_VLRT,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,cTotalS,,,, )
	*/
	//oPanelr:nClientWidth -5  //(oPanelr:nClientHeight/2)-12	
	
ELSE

	cTotalA		:= CalcTot("EXTRATO")
	cSelEx		:= CalcTot("SELECIONADO_EX")
	cTotalC		:= CalcTot("CONCILIADO")
	cTotalD		:= CalcTot("TAXA")
	cTotalMv	:= CalcTot("MOVIMENTO")
	cSelMv		:= CalcTot("SELECIONADO_MV")


	/*--------------------------
		Atualiza total conciliado
	
	nTotConc	:= 0
	FOR nI := 1 to LEN(aDadosEx)
		IF aDadosEx[nI,2] == D_CONCILIADO
			nTotConc += aDadosEx[nI, nZD2VALOR]
		ENDIF
	NEXT nI
	IF !EMPTY(oTotCon)
		oTotCon:cText := nTotConc
		oTotCon:Refresh()
		oPaneRod:Refresh()
		
		oView	:= FWViewActive()
		oView	:= oView
	ENDIF
	---------------------------*/


	//oTotalP:cText	:= '10'
	
ENDIF
		
oTotEx:CtrlRefresh()
oTotCon:CtrlRefresh()
oTotTaxa:CtrlRefresh()
oTotMv:CtrlRefresh()
oSelEx:CtrlRefresh()
oSelMv:CtrlRefresh()
Return




/*/{Protheus.doc} CalcTot
(long_description)
@author Augusto Ribeiro | www.compila.com.br
@since 29/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function CalcTot(cOpc)
Local nRet	:= 0
Local nI	:= 0

Default cOpc	:= "CONCILIADO"

/*--------------------------
	Atualiza total conciliado
---------------------------*/
IF cOpc == "CONCILIADO"
	
	
	
	FOR nI := 1 to LEN(aDadosEx)
		IF aDadosEx[nI,2] == D_CONCILIADO
			nRet += aDadosEx[nI, nZD2VALOR]
		ENDIF
	NEXT nI
	
ELSEIF cOpc == "EXTRATO"
	
	nRet	:= nSaldoEx//| Saldo do EXTRATO|7
	/*
	FOR nI := 1 to LEN(aDadosEx)
		IF aDadosEx[nI,2] == D_CONCILIADO .OR. aDadosEx[nI,2] == D_TAXA
			nRet += aDadosEx[nI, nZD2VALOR]
		ENDIF
	NEXT nI	
	*/
	
ELSEIF cOpc == "MOVIMENTO"

	nRet	:= nSaldoMv //| Saldo do movimento|
	
	FOR nI := 1 to LEN(aDadosMv)
		IF aDadosMv[nI, 1]
			nRet += aDadosMv[nI, nE5VALOR]
		ENDIF
	NEXT nI	
	
ELSEIF cOpc == "TAXA"
	FOR nI := 1 to LEN(aDadosEx)
		IF aDadosEx[nI,2] == D_TAXA
			nRet += aDadosEx[nI, nZD2VALOR]
		ENDIF
	NEXT nI
	
ELSEIF cOpc == "SELECIONADO_EX"
	FOR nI := 1 to LEN(aDadosEx)
		IF aDadosEx[nI,1]
			nRet += aDadosEx[nI, nZD2VALOR]
		ENDIF
	NEXT nI	
	
ELSEIF cOpc == "SELECIONADO_MV"
	FOR nI := 1 to LEN(aDadosMv)
		IF aDadosMv[nI,1]
			nRet += aDadosMv[nI, nE5VALOR]
		ENDIF
	NEXT nI	
			
		
ENDIF

Return(nRet)







/*/{Protheus.doc} ConcAuto
Realiiza a ConciliaÁ„o autom·tica dos itens passados.
@author Augusto Ribeiro | www.compila.com.br
@since 29/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ConcAuto()
Local nRet		:= 0
Local nI		:= 0
Local nMv		:= 0
Local lAuxSel	:= lISelec //| Backup do parametro| 
Local nQtdEx	:= 0
Local nQtdMv	:= 0

nConcTaxa	:= 1 
lISelec		:= .F.

IF !EMPTY(aDadosEx) .AND. !EMPTY(aDadosMv)

	nQtdEx	:= LEN(aDadosEx)
	nQtdMv	:= LEN(aDadosMv)

	ProcRegua(nQtdEx)
	
	aSort(aDadosEx,,,{ |x,y| x[nZD2DATA] < y[nZD2DATA]})
	aSort(aDadosMv,,,{ |x,y| x[nE5DTDISPO] < y[nE5DTDISPO]})
	
	nAuxMv	:= 1
	FOR nI := 1 to nQtdEx
		IncProc("Conciliando automaticamente..")
		
		IF empty(aDadosEx[nI, nZD2DATA])
			LOOP
		ENDIF
	
		nAuxMv	:= aScan(aDadosMv, { |x| x[nE5DTDISPO] ==  aDadosEx[nI,nZD2DATA]})
		IF nAuxMv > 0
			FOR nMv := nAuxMv TO nQtdMv
				
				IF !(aDadosMv[nMv, 1])			
					IF  aDadosMv[nMv, nE5DTDISPO] == aDadosEx[nI, nZD2DATA]
					
						nDif	:=  aDadosEx[nI, nZD2VALOR] - aDadosMv[nMv, nE5VALOR] //nVlrExtr - nVlrMov
						IF nTolera >= nDif .and. (nTolera*-1) <=  nDif
						
							oLbxEx:nAt	:= nI							
							SelEx(@oLbxEx) //| Seleciona Item|
							ListTot()
							oLbxEx:Refresh()
							
							oLbxMv:nAt	:= nMv
							dbClickMv(nMv, 1)
							//SelMov(@oLbxMv) //| Seleciona Item|
							
							EXIT
						endif	
					ELSEIF aDadosMv[nMv, nE5DTDISPO] > aDadosEx[nI, nZD2DATA]
						EXIT			
					ENDIF
				ENDIF
				
			NEXT nMv
		ENDIF
		
	
	NEXT nI
ENDIF
	

oLbxEx:nAt	:= 1
oLbxMv:nAt	:= 1

//| Restore do parametro |
lISelec	:= lAuxSel

oLbxEx:Refresh()
oLbxMv:Refresh()

Return(nRet)



/*/{Protheus.doc} ConcSemi
Realiiza a ConciliaÁ„o Semmi-autom·tica.
Seleciona todos os movimentos com baixa tipo normal atÈ chegar prÛximo ou igual
ao valor do extrato
@author Augusto Ribeiro | www.compila.com.br
@since 29/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ConcSemi()
Local nRet			:= 0
Local nI			:= 0
Local nMv			:= 0
Local lAuxSel		:= lISelec //| Backup do parametro| 
Local nQtdEx		:= 0
Local nQtdMv		:= 0
Local nVlrExtrato	:= 0
Local nSaldoSel		:= 0
Local lPositivo		:= .f.

nConcTaxa	:= 1 
lISelec		:= .F.

IF !EMPTY(aDadosEx) .AND. !EMPTY(aDadosMv)

	IF nConcTaxa == OPCAO_CONCILIACAO
	
	
		nQtdEx	:= LEN(aDadosEx)
		nQtdMv	:= LEN(aDadosMv)
	
	
		nPosEx := aScan(aDadosEx, { |x| x[2] ==  D_SELECIONADO})	
		nPosMv := aScan(aDadosMv, { |x| x[2] ==  D_SELECIONADO}) 
		
		IF nPosEx > 0 
			
			nSaldoSel	:= aDadosEx[nPosEx,nZD2VALOR]	
			
			IF nSaldoSel > 0
				lPositivo	:= .T.
			ELSE
				lPositivo	:= .F.
			ENDIF
			
			
			
			FOR nMv := 1 TO nQtdMv
			
				IF !(aDadosMv[nMv, 1])
					// CONCILIA«√O DE RECEBIMENTOS
					IF lPositivo .AND. aDadosMv[nMv, nE5VALOR] > 0
						IF nSaldoSel >= aDadosMv[nMv, nE5VALOR] .AND. aDadosMv[nMv, nE5MOTBX] == "NOR"
							oLbxMv:nAt	:= nMv
							dbClickMv(nMv, 1)
							
							nSaldoSel	:= nSaldoSel-aDadosMv[nMv, nE5VALOR]					
						ENDIF	
					ELSEIF !(lPositivo) .AND. aDadosMv[nMv, nE5VALOR] < 0
						// CONCILIA«√O DE PAGAMENTOS
						IF nSaldoSel <= aDadosMv[nMv, nE5VALOR]
							oLbxMv:nAt	:= nMv
							dbClickMv(nMv, 1)
							
							nSaldoSel	:= nSaldoSel-aDadosMv[nMv, nE5VALOR]					
						ENDIF					
					ENDIF	
				ENDIF	
			NEXT nMv
				
		ELSE
			Help(" ",1,"SEL.EXTRATO",,"Para utilizar este recuros, primeiramente selecione o movimento desejado no Extrato",4,5)
		ENDIF
	ELSE
		Help(" ",1,"CONCILIA",,"OpÁ„o 'Concilia' deve estar selecionado para execute comando.",4,5)		
	ENDIF
ENDIF
	

oLbxEx:nAt	:= 1
oLbxMv:nAt	:= 1

//| Restore do parametro |
lISelec	:= lAuxSel

oLbxEx:Refresh()
oLbxMv:Refresh()

Return(nRet)




/*/{Protheus.doc} SelModo
(long_description)
@author Augusto Ribeiro | www.compila.com.br
@since 29/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function SelChek(cOpc)
Local lRet := .F.
IF cOpc == "CONCILIA"

	IF !(lSelConc)
		lSelConc	:= .t.
		lSelTaxa	:= .f.
	
		lRet	:= lSelConc
	endif
ELSEIF cOpc == "TAXA"

	IF !(lSelTaxa)
		lSelConc	:= .f.
		lSelTaxa	:= .t.
	
		lRet	:= lSelTaxa
	endif

ENDIF

Return(lRet)




/*/{Protheus.doc} dbClickMv
Realiza aÁ„o no double click do ListBox MOVIMENTOS
@author Augusto Ribeiro | www.compila.com.br
@since 03/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function dbClickMv(nRow,nCol,nFlags)

Default nRow := 0
Default nCol := 0
Default nFlags := 0

//IF !(lVazioMv)
IF !(EMPTY(aDadosMv[oLbxMv:nAt, nE5DTDISPO])) //| N„o realiza acao sobre registro vazio|

	IF EMPTY(aDadosMv[oLbxMv:nAt, nSE5RECNO]) .and. (nCol == nE5HISTOR) //.OR. nCol == nE5NATUREZ .OR. nCol == nE5CCUSTO) 
		//IF EMPTY(aDadosMv[oLbxMv:nAt, nSE5RECNO])
			EditHist(@oLbxMv, nCol)
	//	ENDIF
	else
		SelMov(@oLbxMv)
		ListTot()
		oLbxMv:Refresh()
	ENDIF
ENDIF
Return()




/*/
	Funcao:		EditLBoxCBox
	Autor:		Marinaldo de Jesus
	Data:		02/10/2011
	Descricao:	Permite Adicionar um ComboBox Editavel em uma ListBox
	Sintaxe:	EditLBoxCBox( oListBox , aCTTBloqBox , nColPos )
/*/
//Static Function EditLBoxCBox( oListBox ,  nColPos )
Static Function EditHist( oListBox ,  nColPos )
Local aDim
Local oDlg
Local oComboBox
//Local bSetGet	:= {  |u| oListBox:aArray[oListBox:nAT][nColPos] := u }
Local bSetGet	:=  { |u| IF( oListBox:nAT > 0,														;
										IF( PCount() == 0,													;
											oListBox:aArray[oListBox:nAT][nColPos],							;
											oListBox:aArray[oListBox:nAT][nColPos] := u 	;
										),																	;
									NIL																		;
								 )																			;
							}

GetCellRect( @oListBox , @aDim )	//Obtenho as Coordenadas da Celula
DEFINE MSDIALOG oDlg FROM 0,0 TO 0,0 STYLE nOR( WS_VISIBLE , WS_POPUP ) PIXEL WINDOW oListBox:oWnd


	oGetTeste := TGet():Create( oDlg,bSetGet   ,5,060, 050,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,oListBox:aArray[oListBox:nAT][nColPos],,,, )
	//oTGet2    := TGet():Create( oDlg,{||cTGet2},14,01,096,009,"@!"           ,,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )
	
	oGetTeste:move(aDim[1], aDim[2], aDim[4]-aDim[2], aDim[3]-aDim[1])


	oGetTeste:Move( -2 , -2 , ( ( aDim[ 4 ] - aDim[ 2 ] ) + 4 ) , ( ( aDim[ 3 ] - aDim[ 1 ] ) + 4 ) )
	
	oDlg:Move( aDim[1] , aDim[2] , ( aDim[4]-aDim[2] ) , ( aDim[3]-aDim[1] ) )
	@ 0, 0 BUTTON oBtn PROMPT "" SIZE 0,0 OF oDlg
	oBtn:bGotFocus	:= { || oDlg:nLastKey := VK_RETURN , oDlg:End(0) }
ACTIVATE MSDIALOG oDlg

Return( NIL )




/*/{Protheus.doc} fEfetiva
Efetiva ConciliaÁ„o
@author Augusto Ribeiro | www.compila.com.br
@since 04/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function fEfetiva()
Local aRet	:= {.f., ""}
Local nPosMv, aRetAux
Local nI, nY, dDataAnt
Local nDadosMv	:= len(aDadosMv)
Local aRecSE5	:= {}
Local lRetConc	:= .f.
Local nQtdeTaxa	:= 0
Local nMaxTaxa	:= GETMV("CP9_GELANC",.F., 20) //| Quantidade Maxima de lanÁamentos |

Local nLoopEx, nTotEx
Local nLoopMv, nTotMv
Local nLastnY	:= 1	
Local nIdConc	:= 1
Local aRegEx	:= {}
Local aRegMv	:= {}
	
ProcRegua(len(aDadosEx))


/*------------------------------------------------------ Augusto Ribeiro | 13/01/2017 - 10:14:33 AM
	Trava de seguranÁa para evitar que usuario gere numero excessivo de lanÁamentos incorretamente
------------------------------------------------------------------------------------------*/
For nI := 1 to Len(aDadosEx)
	IF aDadosEx[nI, 1] .AND. aDadosEx[nI, 2] == D_TAXA
		nQtdeTaxa++
	ENDIF	
Next nI

IF nQtdeTaxa <= nMaxTaxa
	
	
	/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:11:28 PM
	
		CONCILIA«√O
		Realiza conciliaÁ„o no SE5 e ZD2 (EXTRATO BANCARIO)
	
	------------------------------------------------------------------------------------------*/	
	DBSELECTAREA("ZD2")
	DBSELECTAREA("SE5")
	
	aSort(aDadosEx,,,{ |x,y| x[nEXCONCI] > y[nEXCONCI] })
	aSort(aDadosMv,,,{ |x,y| x[nMVCONCI] > y[nMVCONCI] })
	
	nLoopEx	:= 1
	nLoopMv	:= 1
	nTotEx	:= len(aDadosEx)
	nTotMv	:= len(aDadosMv)
	WHILE  IIF(nLoopEx <= nTotEx, aDadosEx[nLoopEx, nEXCONCI] > 0, .F.) 
		IncProc("Conciliando..")
		aRegEx	:= {}
		aRegMv	:= {}
		
		IF aDadosEx[nLoopEx, 2] == D_CONCILIADO
			
			nIdConc	:= aDadosEx[nLoopEx, nEXCONCI]
			WHILE  IIF(nLoopEx <= nTotEx, aDadosEx[nLoopEx, nEXCONCI] == nIdConc,.F.) 
				AADD(aRegEx, aDadosEx[nLoopEx, nZD2RECNO])
				nLoopEx++
			ENDDO
			
			
			//WHILE IIF(nLoopMv <= nTotMv, aDadosMv[nLoopMv, nMVCONCI] == nIdConc, .F.) 
			WHILE nLoopMv <= nTotMv 
				IF aDadosMv[nLoopMv, nMVCONCI] == nIdConc
					AADD(aRegMv, aDadosMv[nLoopMv, nSE5RECNO])
				ENDIF
				nLoopMv++
				IF nLoopMv <= nTotMv 
					IF aDadosMv[nLoopMv, nMVCONCI] < nIdConc
						EXIT
					ENDIF
				ENDIF
			ENDDO		
			
			/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:08:14 PM
				Grava conciliaÁ„o
			------------------------------------------------------------------------------------------*/
			IF !EMPTY(aRegEx) .AND. !EMPTY(aRegMv)
				aRetAux	:= U_CP09CONC(aRegMv, aRegEx) // Rotina j· possui Begin Transaction
				IF !(aRetAux[1])
					aRet[2] := aRetAux[2]
					EXIT
				ENDIF
			ENDIF
		ELSE
			nLoopEx++
		ENDIF
	ENDDO
	
	
	/*------------------------------------------------------ Augusto Ribeiro | 15/02/2017 - 5:47:47 PM
		Auto ConciliaÁ„o
	------------------------------------------------------------------------------------------*/
	nLoopEx	:= 1
	nLoopMv	:= 1
	WHILE  IIF(nLoopEx <= nTotEx, aDadosEx[nLoopEx, nEXCONCI] > 0, .F.) 
		aRegEx	:= {}
		aRegMv	:= {}
		
		IF aDadosEx[nLoopEx, 2] == D_CONCILIADO_AUTO

			nIdConc	:= aDadosEx[nLoopEx, nEXCONCI]
			WHILE  IIF(nLoopEx <= nTotEx, aDadosEx[nLoopEx, nEXCONCI] == nIdConc,.F.) 
				AADD(aRegEx, aDadosEx[nLoopEx, nZD2RECNO])
				nLoopEx++
			ENDDO		
		
		
			/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:08:14 PM
				Grava conciliaÁ„o
			------------------------------------------------------------------------------------------*/
			IF !EMPTY(aRegEx)
				aRetAux	:= U_CP09CONC(aRegMv, aRegEx) // Rotina j· possui Begin Transaction
				IF !(aRetAux[1])
					aRet[2] := aRetAux[2]
					EXIT
				ENDIF
			ENDIF	
		ELSE
			nLoopEx++
		ENDIF
		
	ENDDO
	
	
	WHILE  IIF(nLoopMv <= nTotMv, aDadosMv[nLoopMv, nMVCONCI] > 0, .F.)
	 	aRegEx	:= {}
		aRegMv	:= {}
		
		IF aDadosMv[nLoopMv, 2] == D_CONCILIADO_AUTO

			nIdConc	:= aDadosMv[nLoopMv, nMVCONCI]
			WHILE IIF(nLoopMv <= nTotMv, aDadosMv[nLoopMv, nMVCONCI] == nIdConc, .F.) 
				AADD(aRegMv, aDadosMv[nLoopMv, nSE5RECNO])
				nLoopMv++
			ENDDO			
		
		
			/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:08:14 PM
				Grava conciliaÁ„o
			------------------------------------------------------------------------------------------*/
			IF !EMPTY(aRegMv)
				aRetAux	:= U_CP09CONC(aRegMv, aRegEx) // Rotina j· possui Begin Transaction
				IF !(aRetAux[1])
					aRet[2] := aRetAux[2]
					EXIT
				ENDIF
			ENDIF	
		ELSE
			nLoopMv++
		ENDIF
		
	ENDDO
		
	
	
	
	
	
	/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:11:28 PM
	
		LANCAMENTOS 
		Gera LanÁamentos
	
	------------------------------------------------------------------------------------------*/	
	IF EMPTY(aRet[2])
		ProcRegua(len(aDadosEx))
	
	
		DBSELECTAREA("ZD2")
		aSort(aDadosMv,,,{ |x,y| x[nSE5ZD2] < y[nSE5ZD2] })
		
		DBSELECTAREA("SE5")
		for nI := 1 to Len(aDadosEx)
			IncProc("Conciliando..")
			
			IF aDadosEx[nI, 1]	.and. aDadosEx[nI, 2] == D_TAXA
					
				nPosMv	:= aScan(aDadosMv, { |x| x[nSE5ZD2] ==  aDadosEx[nI,nZD2RECNO]})
		 	
		 		/*---------------------------------------
					Realiza a TROCA DA FILIAL CORRENTE 
				-----------------------------------------*/
				_cCodEmp 	:= SM0->M0_CODIGO
				_cCodFil	:= SM0->M0_CODFIL
				_cFilNew	:= aDadosMv[nPosMv, nE5FILIAL] //| CODIGO DA FILIAL DE DESTINO 
				
				IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
					CFILANT := _cFilNew
					opensm0(_cCodEmp+CFILANT)
				ENDIF
				
				//| Altera data para gerar movimentacao|
				dDataAnt	:= DDATABASE
				DDATABASE	:= aDadosMv[nPosMv, nE5DTDISPO]
		 	
				BEGIN TRANSACTION
				
		 		/*--------------------------
		 			Gera movimento bancario
		 		---------------------------*/
		 		//aRetAux	:= U_CP09INC5(aDadosMv[nPosMv, nE5VALOR], aDadosMv[nPosMv, nE5HISTOR], cpBanco, cpAg, cpConta, aDadosMv[nPosMv, nE5NATUREZ], aDadosMv[nPosMv, nE5CCUSTO])
		 		
		 		aRetAux	:= U_CP09INC5(aDadosMv[nPosMv, nE5VALOR], aDadosMv[nPosMv, nE5HISTOR], cpBanco, cpAg, cpConta, aDadosMv[nPosMv, nE5NATUREZ], aDadosMv[nPosMv, nE5CCUSTO], aDadosMv[nPosMv, nE5CCC],aDadosMv[nPosMv, nE5CCD],aDadosMv[nPosMv, nE5CLVLCR],aDadosMv[nPosMv, nE5CLVLDB])
	 				 		
	 		
		 		IF aRetAux[1]
		 			aRegMv	:= {SE5->(recno())}
		 			aRegEx	:= {aDadosEx[nI,nZD2RECNO]}
		 			
					/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 6:08:14 PM
						Grava conciliaÁ„o
					------------------------------------------------------------------------------------------*/
					IF !EMPTY(aRegEx) .AND. !EMPTY(aRegMv)
						aRetAux	:= U_CP09CONC(aRegMv, aRegEx) // Rotina j· possui Begin Transaction
						IF !(aRetAux[1])
							DISARMTRANSACTION()
							aRet[2] := aRetAux[2]
							//EXIT
						ENDIF
					ENDIF		 			

		 		ELSE
		 			aRet[2] += aRetAux[2]+CRLF
		 		Endif
		 		
		 		END TRANSACTION
		 	
		 		//| Restaura a Data|
		 		DDATABASE	:= dDataAnt
						 	
				
				/*---------------------------------------
					Restaura FILIAL  
				-----------------------------------------*/
				IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
					CFILANT := _cCodFil
					opensm0(_cCodEmp+CFILANT)			 			
				ENDIF   			
				
				
				IF !EMPTY(aRet[2])
					EXIT
				ENDIF
			
			endif
		next nY
	ENDIF

	//| Atualiza toda a interface|
	fAtualiza()
else
	aRet[2]	:= "Limite de lanÁamentos a serem criados na movimentaÁ„o banc·ria excedido. Somente È permitido efetivar ["+alltrim(str(nMaxTaxa))+"][SX6 AL_CP9LANC]"
endif


IF !EMPTY(aRet[2])
	Help(" ",1,"EFETIVA",,aRet[2],4,5)
else
	aRet[1]	:= .T.
ENDIF

Return(aRet)




/*/{Protheus.doc} fAtualiza
Atualiza TODA a interface
@author Augusto Ribeiro | www.compila.com.br
@since 04/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function fAtualiza()

	nSaldoMv	:= SaldoMv(cpBanco, cpAg, cpConta, dpDtMvAte)
	nSaldoEx	:= SaldoEx(cpBanco, cpAg, cpConta, dpDtMvAte)

	U_CP902LEX("A",@oLbxEx,@aCpoEx,@aHeadEx, @aDadosEx)
	//oLbxEx:nAt	:= 1
	U_CP902LMV("A",@oLbxMv,@aCpoMv,@aHeadMv, @aDadosMv)
	//oLbxMv:nAt	:= 1
	
/*	
	CalcTot("EXTRATO")	
	oTotEx:CtrlRefresh()
	
	CalcTot("MOVIMENTO")
	oTotCon:CtrlRefresh()
	*/
	ListTot()	
	
	nMarkConc	:= 1 
	nTotExCon	:= 0
	nTotMvCon	:= 0

	
	//oView	:= FWViewActive()
	//oView:Refresh()

Return()




/*/{Protheus.doc} fTransf
Atalho para rotina de transferencia
@author Augusto Ribeiro | www.compila.com.br
@since 04/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function fTransf()
Local dDtAnt	:= dDataBase


//Parametros para Filtrar Cliente
Private aParams:={}
Private aRetPar:={}


//Parametros da ficha de opcional
AADD(aParams,{1,"Data Transf.",cToD(SPACE(08)),,"","","",90,.F.,})

If ParamBox(aParams,"Parametros",@aRetPar)

	dDataBase	:= aRetPar[1]

	/*------------------------------------------------------ Augusto Ribeiro | 04/01/2017 - 7:08:10 AM
		Rotina padr„o de transferencia
	------------------------------------------------------------------------------------------*/
	FINA100()
	//fa100tran()
	//bWindowInit := { || __Execute( "fa100tran()" , "xxxxxxxxxxxxxxxxxxxx" , "FINA100" , "SIGAFIN" , "SIGAFIN", 1 , .T. ) }
	//EVAL(bWindowInit)	
	
	//| Atualiza interface|
	fAtualiza()

	dDataBase	:= dDtAnt
Endif       


Return()




/*/{Protheus.doc} SaldoMv
Retorna saldo do banco
@author Augusto Ribeiro | www.compila.com.br
@since 04/01/2017
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function SaldoMv(cBanco, cAgencia, cConta, dDataMV)
Local nRet		:= 0
Local cQuery	:= "" 
Local nSaldoAtu	:= 0
Local nSaldoIni	:= 0


CalcSldIni( @nSaldoAtu, @nSaldoIni, cBanco, cAgencia, cConta, dDataMV)

nRet	:= nSaldoAtu


/*
dDataMV	:= dDataMV-1

cQuery := " SELECT SUM(E8_SALRECO) AS E8_SALRECO "+CRLF
cQuery += " FROM "+RetSqlName("SE8")+" SE8 "+CRLF
cQuery += " INNER JOIN  "+RetSqlName("SA6")+" SA6 "+CRLF
cQuery += " 	ON A6_COD =   '"+cBanco+"' "+CRLF
cQuery += " 	AND A6_AGENCIA = '"+cAg+"' "+CRLF
cQuery += " 	AND A6_NUMCON = '"+cConta+"' "+CRLF
cQuery += " 	AND E8_FILIAL LIKE RTRIM(A6_FILIAL)+'%' "+CRLF
cQuery += " 	AND A6_COD = E8_BANCO "+CRLF
cQuery += " 	AND A6_AGENCIA = E8_AGENCIA "+CRLF
cQuery += " 	AND A6_NUMCON = E8_CONTA "+CRLF
cQuery += " 	AND A6_BLOCKED <> '1' "+CRLF
cQuery += " 	AND SA6.D_E_L_E_T_ = '' "+CRLF
cQuery += " WHERE E8_DTSALAT = (SELECT TOP 1 SE8B.E8_DTSALAT	 "+CRLF
cQuery += " 					FROM "+RetSqlName("SE8")+" SE8B "+CRLF
cQuery += " 					INNER JOIN  "+RetSqlName("SA6")+" SA6B "+CRLF
cQuery += " 						ON SA6B.A6_COD =  '"+cBanco+"' "+CRLF
cQuery += " 						AND SA6B.A6_AGENCIA = '"+cAg+"' "+CRLF
cQuery += " 						AND SA6B.A6_NUMCON = '"+cConta+"' "+CRLF
cQuery += " 						AND SE8B.E8_FILIAL LIKE RTRIM(SA6B.A6_FILIAL)+'%' "+CRLF
cQuery += " 						AND SA6B.A6_COD = SE8B.E8_BANCO "+CRLF
cQuery += " 						AND SA6B.A6_AGENCIA = SE8B.E8_AGENCIA "+CRLF
cQuery += " 						AND SA6B.A6_NUMCON = SE8B.E8_CONTA "+CRLF
cQuery += " 						AND SA6B.A6_BLOCKED <> '1' "+CRLF
cQuery += " 						AND SE8B.E8_DTSALAT <= '"+DTOS(dDataMV)+"' "+CRLF
cQuery += "							AND SE8B.E8_SALRECO > 0 "+CRLF
cQuery += " 						AND SA6B.D_E_L_E_T_ = '' "+CRLF
cQuery += " 				ORDER BY SE8B.E8_DTSALAT DESC) "+CRLF
cQuery += " AND SE8.D_E_L_E_T_ = '' "+CRLF

MemoWrite(GetTempPath(.T.) + "CP09002_SaldoMov.SQL", cQuery)

If Select("TSALDO") > 0
	TSALDO->(DbCloseArea())
EndIf

DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSALDO",.F., .T.)						

IF TSALDO->(!EOF())
	 nRet	:= TSALDO->E8_SALRECO
ENDIF	


TSALDO->(DbCloseArea())

*/


Return(nRet)






/*/{Protheus.doc} SaldoEx
Retorna saldo do extrato bancario
@author Augusto Ribeiro | www.compila.com.br
@since 04/01/2017
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function SaldoEx(cBanco, cAg, cConta, dDataMV)
Local nRet		:= 0
Local cQuery	:= "" 
Local nSaldoZD2	:= 0
Local nSaldoIni	:= 0
Local dSaldoIni	:= ctod('  /  /  ')

Local cDigConta	:= ""



cQuery := " SELECT ZD4_DATA, ZD4_SALDO  "+CRLF
cQuery += " FROM "+RetSqlName("ZD4")+" ZD4  "+CRLF
cQuery += " WHERE ZD4_BANCO = '"+cBanco+"' "+CRLF
cQuery += " AND ZD4_AGENC = '"+cAg+"' "+CRLF
cQuery += " AND ZD4_CONTA  = '"+cConta+"' "+CRLF
cQuery += " AND ZD4_DATA <= '"+DTOS(dDataMV)+"' "+CRLF
cQuery += " AND ZD4.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " ORDER BY ZD4_DATA DESC "+CRLF


//MemoWrite(GetTempPath(.T.) + "CP09002_SaldoExB.SQL", cQuery)

If Select("TSALDOEX") > 0
	TSALDOEX->(DbCloseArea())
EndIf

DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSALDOEX",.F., .T.)						

IF TSALDOEX->(!EOF())
	 nSaldoIni	:= TSALDOEX->ZD4_SALDO
	 dSaldoIni	:= stod(TSALDOEX->ZD4_DATA)
ENDIF	


TSALDOEX->(DbCloseArea())


cQuery := " SELECT ISNULL(SUM(ZD2_VALOR),0) AS SALDO "+CRLF
cQuery += " FROM "+RetSqlName("ZD2")+" ZD2  "+CRLF
//cQuery += "  WHERE ZD2_BANCO = '"+PADL(cBanco,TAMSX3("ZD2_BANCO")[1],"0")+"' "+CRLF
cQuery += " WHERE ZD2_BANCO = '"+cBanco+"' "+CRLF
cQuery	+= " AND ZD2_AGENC = '"+cAg+"' "+CRLF
cQuery	+= " AND ZD2_CONTA = '"+cConta+"' "+CRLF
IF !EMPTY(dSaldoIni)
	cQuery	+= " AND ZD2_DATA > '"+DTOS(dSaldoIni)+"' "+CRLF
ENDIF
cQuery	+= " AND ZD2_DATA <= '"+DTOS(dDataMV)+"' "+CRLF
//cQuery += " AND ZD2_DTCONC <> '' "+CRLF
cQuery += " AND ZD2.D_E_L_E_T_ = ' ' "+CRLF

cQuery	:= CHANGEQUERY(cQuery)

MemoWrite(GetTempPath(.T.) + "CP09002_SaldoExc.SQL", cQuery)



If Select("TSALDOEX") > 0
	TSALDOEX->(DbCloseArea())
EndIf

DBUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "TSALDOEX",.F., .T.)						

IF TSALDOEX->(!EOF())
	 nSaldoZD2	:= TSALDOEX->SALDO
ENDIF	


TSALDOEX->(DbCloseArea())


nRet	:= nSaldoZD2+nSaldoIni

Return(nRet)




/*/{Protheus.doc} CP09002MODEL
 Pontos de entrada padroes do MVC
@author Augusto Ribeiro | www.compila.com.br
@since 14/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
USER FUNCTION CP09002MODEL()
Local aParam     := PARAMIXB
Local xRet       := .T.
Local oObj       := ''
Local cIdPonto   := ''
Local cIdModel   := ''
Local lIsGrid    := .F.
 
Local nLinha     := 0
Local nQtdLinhas := 0
Local cMsg       := ''
Local lAux
 
 
If aParam <> NIL
      
	oObj       := aParam[1]
	cIdPonto   := aParam[2]
	cIdModel   := aParam[3]
	  
	IF cIdPonto == "BUTTONBAR"
	
		/*--------------------------
			Executa conciliaÁ„o automatica na aberturaw
		---------------------------*/
		IF lExecConc
			lAux	:= lISelec
			lISelec	:= .f.
			
			Processa({|| ConcAuto()}, "ConciliaÁ„o Autom·tica... ")
			
			lISelec	:= lAux
		ENDIF
	ENDIF    	
ENDIF
       
      


Return(xRet)




/*/{Protheus.doc} ConfVlr
Confere valores selecionados no extrato e movimento.
Caso ambos sejam iguais, altera legenda do extrato e 
avanÁa nMarkConc
@author Augusto Ribeiro | www.compila.com.br
@since 25/01/2017
@version 6
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ConfVlr()
LOCAL nI
Local nSelEx	:= 0
Local nSelMv	:= 0

IF nTotExCon == nTotMvCon
	for nI:= 1 to Len(aDadosEx)
		IF aDadosEx[nI, nEXCONCI] == nMarkConc
			aDadosEx[nI, 2]	:= D_CONCILIADO	
			nSelEx++		
		ENDIF		
	next nI
	
	for nI:= 1 to Len(aDadosMv)
		IF aDadosMv[nI, nMVCONCI] == nMarkConc

			/*------------------------------------------------------ Augusto Ribeiro | 15/02/2017 - 4:34:27 PM
				Recurso de Auto Conciliacao - Registros da mesma origem
			------------------------------------------------------------------------------------------*/
			IF nSelEx == 0
				aDadosMv[nI, 2]	:= D_CONCILIADO_AUTO
			ELSE
				aDadosMv[nI, 2]	:= D_CONCILIADO	
			ENDIF
		
			
			nSelMv++
		ENDIF		
	next nI	

	/*------------------------------------------------------ Augusto Ribeiro | 15/02/2017 - 4:34:27 PM
		Recurso de Auto Conciliacao - Registros da mesma origem
	------------------------------------------------------------------------------------------*/	
	IF nSelMv == 0 .AND. nSelEx >= 2
		for nI:= 1 to Len(aDadosEx)
			IF aDadosEx[nI, nEXCONCI] == nMarkConc
				aDadosEx[nI, 2]	:= D_CONCILIADO_AUTO		
			ENDIF		
		next nI
	ENDIF
	
	
	nMarkConc++
	
	oLbxEx:Refresh()
	oLbxMv:Refresh()

ENDIF

Return()





/*/{Protheus.doc} DesmConc
Desmarcar Registros marcados como conciliado
@author Augusto Ribeiro | www.compila.com.br
@since 25/01/2017
@version 6
@param nMarkAnt, IDMark do conciliado desmarcado
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function DesmConc(nMarkAnt)
LOCAL nI
Local nTotAux

nTotAux	:= 0
for nI:= 1 to Len(aDadosEx)
	IF aDadosEx[nI, nEXCONCI] == nMarkAnt
		
		IF aDadosEx[nI, 2]	== D_CONCILIADO .OR. aDadosEx[nI, 2] == D_CONCILIADO_AUTO
			aDadosEx[nI, 2]			:= D_SELECIONADO
			aDadosEx[nI, nEXCONCI]	:= nMarkConc
		ENDIF		
	ENDIF	
	
	/*--------------------------
		Recalcula valor selecionado
	---------------------------*/
	IF aDadosEx[nI, nEXCONCI] == nMarkConc
		nTotAux	+= aDadosEx[nI, nZD2VALOR]
	ENDIF
		
next nI
nTotExCon	:= nTotAux


nTotAux	:= 0
for nI:= 1 to Len(aDadosMv)
	IF aDadosMv[nI, nMVCONCI] == nMarkAnt
		
		IF aDadosMv[nI, 2]	== D_CONCILIADO .OR. aDadosMv[nI, 2] == D_CONCILIADO_AUTO 
			aDadosMv[nI, 2]			:= D_SELECIONADO
			aDadosMv[nI, nMVCONCI]	:= nMarkConc
		ENDIF		
	ENDIF	
	
	/*--------------------------
		Recalcula valor selecionado
	---------------------------*/
	IF aDadosMv[nI, nMVCONCI] == nMarkConc
		nTotAux	+= aDadosMv[nI, nE5VALOR]
	ENDIF
		
next nI
nTotMvCon	:= nTotAux




oLbxEx:Refresh()
oLbxMv:Refresh()


Return()






/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥FINR470   ∫Autor  ≥ Rodrigo Oliveira   ∫ Data ≥  09/11/15   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥ FunÁ„o para c·lculo do saldo inicial de banco compart.     ∫±±
±±∫          ≥ e saldo exclusivo                                          ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/

Static Function CalcSldIni(nSaldoAtu, nSaldoIni, cBanco, cAgencia, cConta, dDataSaldo) 

Local cSaldo 	:= GetNextAlias()
Local cQry		:= ""
Local nMoeda	:= 1
Local cFl 		:= ""
Local nSld		:= 0
Local nSlRec	:= 0
///dDataSaldo	:= dDataSaldo+1
cQry := " SELECT E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_DTSALAT, E8_SALATUA, E8_SALRECO "
cQry += " FROM " + RetSqlName("SE8") + " SE8 " 
cQry += " WHERE E8_BANCO 	= '" + cBanco + "' "
cQry += " AND E8_AGENCIA 	= '" + cAgencia + "' "
cQry += " AND E8_CONTA 		= '" + cConta + "' "
cQry += " AND E8_DTSALAT	< '" + DTOS(dDataSaldo) + "' "
cQry += " AND D_E_L_E_T_ = ' ' "
cQry += " ORDER BY E8_FILIAL, E8_DTSALAT DESC "

dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), cSaldo, .T., .T.)

(cSaldo)->(DbGoTop())

cFl 	:= (cSaldo)->E8_FILIAL
nSld	:= (cSaldo)->E8_SALATUA
nSlRec	:= (cSaldo)->E8_SALRECO

While !Eof()
	
	If (cSaldo)->E8_FILIAL != cFl
		nSld	+= (cSaldo)->E8_SALATUA
		nSlRec	+= (cSaldo)->E8_SALRECO
		cFl 	:= (cSaldo)->E8_FILIAL
	EndIf
	DbSkip()	
EndDo
 
(cSaldo)->(DbCloseArea())


	nSaldoAtu:=Round(xMoeda(nSlRec,1,1,SE8->E8_SALATUA),2)
	nSaldoIni:=Round(xMoeda(nSlRec,1,1,SE8->E8_DTSALAT),2)

Return()




/*/{Protheus.doc} xPutSx1
(long_description)
@author DESCONHECIDO
@since 11/09/2018
@version version
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

// Ajusta o tamanho do grupo. Ajuste emergencial para validaÁ„o dos fontes.
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