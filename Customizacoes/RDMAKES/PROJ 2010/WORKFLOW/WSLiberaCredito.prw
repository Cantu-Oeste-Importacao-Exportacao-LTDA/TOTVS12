#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
             

//----------------------------------------------------------------------------//
// Faz a aprovacao ou rejeicao de um pedido de venda quanto ao crédito
//----------------------------------------------------------------------------//
WsService WsAprovPedVda Description "Faz a aprovacao ou rejeicao do crédito de um pedido de venda"
   WsData cPedido      As String
   WsData cFil         As String
   WsData cEmpresa     as String
   Wsdata Obs          As String
   WsData cAprova      as String
   WsData lAprovado    as Boolean
   WsData cTexto       as String  // mensagem do processamento do workflow que será exibida na página
   WsData Itens        as array of PedVdaI
   WsData DadosPed2     as PedVda
   WsMethod Aprova  Description "Aprovacao do pedido de Venda"
   WsMethod ItensPedVda  Description "Obtém os itens do pedido de Venda a ser liberado"
   wsMethod DadosPedido  Description "Obtém dos dados da Venda"
EndWsService



WsMethod Aprova WsReceive cEmpresa, cFil, cAprova, cPedido, Obs WsSend cTexto WsService WsAprovPedVda
// Fazer a liberacao do pedido de compra, verificando a empresa, filial e o numero do pedido passado por parametro
// Seta a empresa e a filial a ser usada
Local cEmpresa := ::cEmpresa
Local cFil := ::cFil
Local cAprova := ::cAprova
Local cPedido := ::cPedido
Local cObs := ::Obs

Local cTexto := ""
Local lRetorno := .T.
Local nOpc := iif(cAprova == 'S', 1, 2)
	//                   
RpcClearEnv()
RPCSetEnv(cEmpresa,cFil,"","","","",{"SC9","SC6","SC5","SA1"})

If nOpc = 1 // Se Financeiro aprovar o pedido efetuo a liberação do mesmo.
	SC9->(DbSelectArea("SC9"))
	cSql := "SELECT * "
	cSql += "FROM "+RetSqlName("SC9")+" "
	cSql += "WHERE D_E_L_E_T_ <> '*' "
	cSql += "AND C9_FILIAL = '"+cFil+"' "
	cSql += "AND C9_BLCRED <> '"+Space(Len(SC9->C9_BLCRED))+"' "
	cSql += "AND C9_BLCRED <> '10' "	
	cSql += "AND C9_PEDIDO = '"+cPedido+"' "
	TCQUERY cSql NEW ALIAS "QRYSC9"
	QRYSC9->(DbSelectArea("QRYSC9"))
	QRYSC9->(DbGotop())
	While !QRYSC9->(Eof())
		SC9->(DbSelectArea("SC9"))
		SC9->(DbSetOrder(1))
		SC9->(DbGotop())
		If SC9->(DbSeek(QRYSC9->C9_FILIAL+QRYSC9->C9_PEDIDO+QRYSC9->C9_ITEM))
			/*
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
			±±³          ³       2 - Rejeicao                                          ³±±
			±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
			±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
			±±³          ³venda com base na tabela SC9.                                ³±±
			±±³          ³                                                             ³±±
			±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
			/*/
			
			ConOut("Liberado produto " + SC9->C9_PRODUTO)
			cTexto += "Liberado produto " + SC9->C9_PRODUTO + char(13) + char(10) + ".<br/>"
			
			A450grava(nOpc,.T.,.F.)
		Endif
		QRYSC9->(DbSelectArea("QRYSC9"))
		QRYSC9->(DbSkip())
	End
	QRYSC9->(DbSelectArea("QRYSC9"))
	QRYSC9->(DbCloseArea())
	
	cTexto += "Liberação realizada com sucesso!"
Else // Se financeiro rejeitar o pedido, efetuo a eliminação de residuo dos itens bloqueados.
	// Flavio verificar aquela questão dos pedidos que podem ter parte dos itens liberados e parte bloqueados.
  ConOut("Início do bloqueio")
	SC5->(DbSelectArea("SC5"))
	SC5->(DbSetOrder(1))
	SC5->(DbGotop())
	SC5->(DbSeek(xFilial("SC5")+cPedido))
	
	SC6->(DbSelectArea("SC6"))
	SC6->(DbSetOrder(1))
	SC6->(DbGotop())
	If SC6->(DbSeek(xFilial("SC6")+cPedido))
		While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC6->C6_FILIAL+cPedido
			/*
			±±³Parametros³ExpN1: Numero do Registro do SC6                            ³±±
			±±³          ³ExpL2: Estorna Itens Bloqueados                             ³±±
			±±³          ³ExpL3: Avalia o Cabecalho do Pedido                         ³±±
			*/
			
			MaResDoFat(SC6->(Recno()),.T.,.t.)			
			ConOut("Bloqueado produto " + SC6->C6_PRODUTO)
			cTexto += "Bloqueado produto " + SC6->C6_PRODUTO + char(13) + char(10) + ". <br/>"
			SC6->(DbSkip())
		End
	Endif
	cTexto += "Bloqueio realizado com sucesso!"
	ConOut("Final do Bloqueio")
Endif

conout("Finalizado o processo de liberação do pedido de venda.")
::cTexto := cTexto

Return .T.


WsMethod ItensPedVda WsReceive cEmpresa, cFil, cPedido WsSend Itens WsService WsAprovPedVda
aItens := {} 
RpcClearEnv()

RPCSetEnv(cEmpresa,cFil,"","","","",{"SC9","SC6","SC5","SA1"})

ConOut("Empresa / Filial: " + cEmpresa + " / " + cFil)

dbSelectArea("SC6")
dbSetOrder(01)

nCont := 1
if dbSeek(cFil + cPedido)
	while (SC6->C6_FILIAL+SC6->C6_NUM == cFil + cPedido)
		Aadd(aItens, WSClassNew("PedVdaI"))
		aItens[nCont]:cItem := SC6->C6_ITEM
		aItens[nCont]:cCodProd := SC6->C6_PRODUTO
		aItens[nCont]:cProduto := SC6->C6_DESCRI
		aItens[nCont]:nQuant := SC6->C6_QTDVEN
		aItens[nCont]:nUnitario := SC6->C6_PRCVEN
		aItens[nCont]:nTotal := SC6->C6_VALOR
		aItens[nCont]:nTotalMImp := iif(SC6->C6_X_VLORI> 0, SC6->C6_X_VLORI, SC6->C6_VALOR)
//		aItens[nCont]:cObs := ""
		aItens[nCont]:cUM := SC6->C6_UM	
		nCont++
		SC6->(dbSkip())
	EndDo	
EndIf
::Itens := aItens
Return .T. 


WsMethod DadosPedido WsReceive cEmpresa, cFil, cPedido WsSend DadosPed2 WsService WsAprovPedVda
// Inicializa o objeto
ConOut("Início em " + Time())
RpcClearEnv()
RPCSetEnv(cEmpresa,cFil,"","","","",{"SC9","SC6","SC5","SA1"})

::DadosPed2 := WSClassNew("PedVda")

ConOut("Empresa / Filial: " + cEmpresa + " / " + cFil)

dbSelectArea("SC5")
dbSetOrder(01)
if dbSeek(cFil + cPedido)
  ConOut("Localizou Pedido")
	::DadosPed2:Pedido := SC5->C5_NUM
	::DadosPed2:cData := DtoC(SC5->C5_EMISSAO)
	
	// Localiza o cliente
	SA1->(dbSetOrder(01))
	SA1->(dbSeek(xFilial("SA1") + SC5->C5_CLIENTE +SC5->C5_LOJACLI))
	
	cNomeCli := SA1->A1_NOME
	
	::DadosPed2:cCliente := SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + " - " + cNomeCli
	::DadosPed2:cEmpresa := SM0->M0_NOME
	::DadosPed2:nLimCred := SA1->A1_LC
	::DadosPed2:nLimUtil := SA1->A1_SALPEDL + SA1->A1_SALDUP	
	// Busca o vendedor
	::DadosPed2:cVendedor := SC5->C5_VEND1 + " - " + Posicione("SA3", 01, xFilial("SA3")+SC5->C5_VEND1, "A3_NOME")
	
	// calcula o total           
	nTotal := 0	
	SC6->(dbSetOrder(01))
	SC6->(dbSeek(cFil + cPedido))
	while (SC6->C6_FILIAL+SC6->C6_NUM == cFil + cPedido)
		nTotal += SC6->C6_VALOR
		SC6->(dbSkip())
	EndDo
	::DadosPed2:Total := nTotal
	// Obtém os dados do cliente
	ConOut("Cliente: " + ::DadosPed2:cCliente)
Else
	ConOut("Não localizou pedido")
	ConOut("Chave: " + cFil + cPedido)
	::DadosPed2:Pedido := ""
	::DadosPed2:cData := ""
	::DadosPed2:cCliente := ""
	::DadosPed2:Total := 0
	::DadosPed2:cEmpresa := ""
	::DadosPed2:cVendedor := ""
	::DadosPed2:nLimCred := 0
	::DadosPed2:nLimUtil := 0
EndIf

ConOut("Final em " + Time())

Return .T.

WSSTRUCT PedVdaI
	WSDATA cItem       as string
	WSDATA cCodProd		 as string
	WSDATA cProduto    as string
	WSDATA nQuant      as float
	WSDATA nUnitario   as float
	WSDATA nTotal      as float
	WSDATA nTotalMImp  as float
	WSDATA cUM	       as string
ENDWSSTRUCT

WSSTRUCT PedVda
	WSDATA Pedido as string
	WSDATA cData  as string
	WSDATA cCliente as string
	WSDATA Total as float
	WSDATA cEmpresa as string
	WSDATA cVendedor as string
	WSDATA nLimCred as float
	WSDATA nLimUtil as float
ENDWSSTRUCT