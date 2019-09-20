#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

//----------------------------------------------------------------------------//
// Faz a aprovacao ou rejeicao de um pedido de venda
//----------------------------------------------------------------------------//
WsService WsAprovPedComp Description "Faz a aprovacao ou rejeicao de um pedido de venda"
   WsData cPedido      As String
   WsData cFil         As String
   WsData cEmpresa     as String
   Wsdata Obs          As String
   WsData cAprova      as String
   WsData cAprovador   as String
   WsData lAprovado    as Boolean
   WsData cTexto       as String  // mensagem do processamento do workflow que será exibida na página
   WsData Itens        as array of PedCompI
   WsData DadosPed     as PedComp
   WsMethod Aprova  Description "Aprovacao do pedido de compra"
   WsMethod ItensPedComp  Description "Obtém os itens do pedido de compra"
   wsMethod DadosPedido   Description "Obtém dos dados do pedido"
EndWsService

WsMethod Aprova WsReceive cEmpresa, cFil, cAprova, cAprovador, cPedido, Obs WsSend cTexto WsService WsAprovPedComp
// Fazer a liberacao do pedido de compra, verificando a empresa, filial e o numero do pedido passado por parametro
// Seta a empresa e a filial a ser usada
Local cEmpresa := ::cEmpresa
Local cFil := ::cFil
Local cAprova := ::cAprova
Local cAprovador := ::cAprovador
Local cPedido := ::cPedido
Local cObs := ::Obs


//LOCAL nC
LOCAL nTotal //,cTipoLim, nSaldo, , nSalDif, aProd, aDesc, aQtd, aUm, aPreco, aTotal, , cUsuario, cMoeda
LOCAL nRec, lRetorno, cChave
	
LOCAL cAuxTp
LOCAL cProcess
LOCAL cStatus  
LOCAL lLiberou
Local lRetorno := .T.
	//
local lSAK := .T.
local lSC7 := .T.
local lSA2 := .T.
local lSAL := .T.
local lSCS := .T.
local lSCR := .T.
                   
RpcClearEnv()
RPCSetEnv(cEmpresa,cFil,"","","","",{"SAK","SC7","SA2","SAL","SCR"})
	
if cAprova == 'S'
	// Verifica o cadastro de aprovadores
	dbSelectArea("SAK")
	dbSetOrder(1)
	SAK->(dbgotop())
	if dbSeek(xFilial()+cAprovador)
		conout("1/6)---------------> Ok! Cadastro de Aprovadores.")
	else
		conout("1/6)---------------> Nao Ok! Cadastro de Aprovadores.")
		lSAK := .F.
	endif

	// Verifica o pedido de compra
	dbSelectArea("SC7")
	dbSetOrder(1)   
	SC7->(dbgotop())
	if dbSeek(xFilial()+cPedido)
		conout("2/6)---------------> Ok! Pedido de Compra." )`
	else
		conout("2/6)---------------> Nao Ok! Pedido de compra.")
		lSC7 := .F.
	endif            
	
	
	// verifica o fornecedor
	dbSelectArea("SA2")
	dbSetOrder(1)
	SA2->(dbgotop())
	if dbSeek(xFilial()+SC7->C7_FORNECE+SC7->C7_LOJA)
	   conout("3/6)---------------> Ok! Fornecedor.")
	else
	   conout("3/6)---------------> Nao Ok! Fornecedor.")
	   lSA2 := .F.
	endif
	                        
	// Verifica o grupo de aprovacao
	dbSelectArea("SAL")
	dbSetorder(3)
	SAL->(dbgotop()) 
	// Flavio - 21/06/08 - Alterado para buscar por filial + grupo + cod. aprovador ao invés de filial + grupo + cod. Superior
	if dbSeek(xFilial()+SC7->C7_APROV+SAK->AK_COD) //SAK->AK_APROSUP
	   conout("4/6)---------------> Ok! Aprovacao.")
	else
	   conout("4/6)---------------> Nao Ok! Aprovacao.")                                                                      
	   lSAL := .F.
	endif
	
	// Verifica o Pedido de Compra a ser liberado
	dbSelectArea("SCR")
	dbSetOrder(2)                                  
	SCR->(dbgotop())               
	if dbSeek(xFilial()+'PC'+SC7->C7_NUM+space(TamSX3( "CR_NUM" )[1]-len(SC7->C7_NUM))+SAK->AK_USER)
	   conout("5/6)---------------> Ok! Iniciado Processo de Liberacao")
	   nRec := RecNo()
	else                     	
	   conout("5/6)---------------> Nao Ok! Falha no inicio do Processo de Liberacao") 
	   
	   lSCR := .F.
	endif                                     

	//calcula o total do pedido
	dbSelectArea("SC7") 
	dbSetOrder(1)   
	dbseek(xFilial("SC7")+cPedido)
	                                                            
	nTotal := 0	
	cChave := xFilial("SC7")+cPedido
		
	while ( cChave == SC7->C7_FILIAL+SC7->C7_NUM)
		nTotal := nTotal + SC7->C7_TOTAL
		dbskip()
	enddo
	
	if lSAK .AND. lSC7 .AND. lSA2 .AND. lSAL .AND. lSCR 
	  lLiberou := MaAlcDoc({SCR->CR_NUM,SCR->CR_TIPO,nTotal,cAprovador,,SAL->AL_COD,,,,,cObs},dDataBase,4)
	  if lLiberou
	    dbSelectArea("SC7")
	    dbSetOrder(1)   
	    SC7->(dbgotop())
	      
	    dbSeek(xFilial()+cPedido)
	    while SC7->C7_FILIAL == xFilial() .AND. SC7->C7_NUM == cPedido
        RecLock("SC7",.F.)
        SC7->C7_CONAPRO := 'L'
        SC7->( MsUnLock ( ) )
				SC7->(DBSkip())
	    Enddo                                                            
	      
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    conout("¦¦           LIBERAÇÃO REALIZADA COM SUCESSO!                 ¦¦")
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    
	    /* Rafael - 04/01/2011
	    SndMAprov(xFilial("SC7"), cPedido)
	    */
	    
	    cTexto := "Liberação realizada com sucesso!"
	  else
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    conout("¦¦           FALHA NA LIBERAÇÃO - PASSO 2 !                   ¦¦")
	    conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	    cTexto := "Falha na liberação - Passo 2!"
	  endif
	else
	  conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	  conout("¦¦           FALHA NA LIBERAÇÃO - PASSO 1 !                   ¦¦")
	  conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
	  cTexto := "Falha na liberação - Passo 1!"
	endif
else
   conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
   conout("¦¦                LIBERAÇÃO NÃO AUTORIZADA!                   ¦¦")
   conout("¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦")
   conout("Libera = " + cAprova)             
   cTexto := "Liberação não autorizada"
endif                               

conout("Finalizado o processo de liberação do pedido de compra.")
// teste de funcionamento
::cTexto := cTexto
Return .T.

/*********************************************************/
// Função responsável por enviar email informando da aprovação do pedido para o usuario que o fez
/*********************************************************/
static function SndMAprov(cFil, cPed)
Local aArea := GetArea()
Local cUsuario, cEmail
Local oProcess, oHtml, cProcess, cStatus

SC7->(DBSetOrder(1))
SC7->(DBSeek(cFil + cPed))
cUsuario := SC7->C7_USER
cEmail := getEmail(cUsuario)

if (AllTrim(cEmail) <> "")
	//Inicia processo de envio do e-mail
	cProcess := OemToAnsi("001010") // Numero do Processo
	cStatus  := OemToAnsi("001011")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Retorno de aprovação de Pedido"))
	oProcess:NewTask(cStatus,"\workflow\wfretaprovped.html")
	oProcess:cSubject := OemToAnsi("Aprovação do Pedido " + cPed)

	oProcess:cTo := ALLTRIM(cEmail)
		
	oProcess:oHTML:ValByName("NUMPED", cPed)
	
	oProcess:Start()
EndIf	

RestArea(aArea)

Return Nil

WsMethod ItensPedComp WsReceive cEmpresa, cFil, cPedido WsSend Itens WsService WsAprovPedComp
aItens := {} 
RpcClearEnv()
RPCSetEnv(cEmpresa,cFil,"","","","",{"SAK","SC7","SA2","SAL","SCR"})

ConOut("Empresa / Filial: " + cEmpresa + " / " + cFil)

dbSelectArea("SC7")
dbSetOrder(01)

nCont := 1
if dbSeek(cFil + cPedido)
	while (SC7->C7_FILIAL+SC7->C7_NUM == cFil + cPedido)
		Aadd(aItens, WSClassNew("PedCompI"))
		aItens[nCont]:cItem := SC7->C7_ITEM
		aItens[nCont]:cCodProd := SC7->C7_PRODUTO
		aItens[nCont]:cProduto := SC7->C7_DESCRI
		aItens[nCont]:nQuant := SC7->C7_QUANT
		aItens[nCont]:nUnitario := SC7->C7_PRECO
		aItens[nCont]:nTotal := SC7->C7_TOTAL
		aItens[nCont]:cObs := SC7->C7_OBS
		aItens[nCont]:cUM := SC7->C7_UM	
		nCont++
		SC7->(dbSkip())
	EndDo	
EndIf
::Itens := aItens
Return .T. 


WsMethod DadosPedido WsReceive cEmpresa, cFil, cPedido WsSend DadosPed WsService WsAprovPedComp
// Inicializa o objeto
::DadosPed := WSClassNew("PedComp")
RpcClearEnv()
RPCSetEnv(cEmpresa,cFil,"","","","",{"SAK","SC7","SA2","SAL","SCR"})

ConOut("Empresa / Filial: " + cEmpresa + " / " + cFil)

dbSelectArea("SC7")
dbSetOrder(01)
if dbSeek(cFil + cPedido)
	::DadosPed:Pedido := SC7->C7_NUM
	::DadosPed:cData := DtoC(SC7->C7_EMISSAO)
	
	// Localiza o fornecedor
	cNomeForn := Posicione("SA2", 01, xFilial("SA2") + SC7->C7_FORNECE +SC7->C7_LOJA, "A2_NOME")
	::DadosPed:Fornecedor := SC7->C7_FORNECE + "/" + SC7->C7_LOJA + " - " + cNomeForn
	::DadosPed:cEmpresa := SM0->M0_NOME
	
	// Busca o comprador
	SY1->(dbSetOrder(03))
	SY1->(dbSeek(xFilial("SY1")+SC7->C7_USER))
	::DadosPed:cComprador := SY1->Y1_COD + " - " + SY1->Y1_NOME
	
	// calcula o total
	nTotal := 0
	while (SC7->C7_FILIAL+SC7->C7_NUM == cFil + cPedido)
		nTotal += SC7->C7_TOTAL
		SC7->(dbSkip())
	EndDo
	::DadosPed:Total := nTotal	
Else
	::DadosPed:Pedido := ""
	::DadosPed:cData := ""
	::DadosPed:Fornecedor := ""
	::DadosPed:Total := 0
	::DadosPed:cEmpresa := ""
	::DadosPed:cComprador := ""
EndIf

Return .T.

//////////
static function getEmail(pcUser)
	local cArea := getArea()
	local cRet  := ''
	PswOrder(1)
	//
	if PswSeek(pcUser,.t.)
		cRet := PswRet(1)[1,14]
	endif
	restarea(cArea)
return(cRet)

WSSTRUCT PedCompI
	WSDATA cItem       as string
	WSDATA cCodProd		 as string
	WSDATA cProduto    as string
	WSDATA nQuant      as float
	WSDATA nUnitario   as float
	WSDATA nTotal      as float
	WSDATA cObs        as string
	WSDATA cUM	       as string
ENDWSSTRUCT

WSSTRUCT PedComp
	WSDATA Pedido as string
	WSDATA cData  as string
	WSDATA Fornecedor as string
	WSDATA Total as float
	WSDATA cEmpresa as string
	WSDATA cComprador as string
ENDWSSTRUCT