/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CTMAT01  ¦ Autor ¦ LINCOLN P. ROSSETTO   ¦ Data ¦ 16/04/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Rotina que dispara e-mail para os usuários alertando      ¦¦¦
¦¦¦          ¦ do desbloqueios.                                           ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦---ALTERAÇÕES-----------------------------------------------¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para CANTU.                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sol. Cust.¦ 04186080415-01                                             ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
#include "rwmake.ch"
#include "tbiconn.ch"
User Function CTMAT01()
LOCAL aSeg 	   := GetArea()
LOCAL cProcess := Space(6), cStatus := Space(6), cEmail := ""
LOCAL cNum     := "", cCond := ""
LOCAL lWF      := .T.
//
LOCAL cPedido
LOCAL cFornec
LOCAL cFornecM
LOCAL cLoja
LOCAL cAprovad
LOCAL cSolCmp
LOCAL cTipo     := 'PC'
Local cFilPed := SC7->C7_FILIAL
LOCAL nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=='C7_PRODUTO'})
LOCAL nPosQuant := aScan(aHeader,{|x| AllTrim(x[2])=='C7_QUANT'})
LOCAL nPosPrUnt := aScan(aHeader,{|x| AllTrim(x[2])=='C7_PRECO'})
LOCAL nPosVlTot := aScan(aHeader,{|x| AllTrim(x[2])=='C7_TOTAL'})
LOCAL nPosUnMed := aScan(aHeader,{|x| AllTrim(x[2])=='C7_UM'})
LOCAL nPosObs   := aScan(aHeader,{|x| AllTrim(x[2])=='C7_OBS'})
LOCAL aItens    := {}
LOCAL aLibera   := {}
LOCAL aRetSaldo := {}
LOCAL nSaldo
LOCAL CRoeda
LOCAL nTotal
LOCAL nSalDif
local cComprador
local cSolicitante
local cUserPed  := SC7->C7_USER
local Cabec := "", Item := "", Pedido, cID
//Local oWS    := WSWSAprovaPedido():New()
Local oItens := WSAprovaPedido_ArrayOfString():New()
Local cCondPag := SC7->C7_COND
Local cNatureza:= "NAO UTILIZADO"//SC7->C7_NATUREZ
Local cAssunto := ""
Local cPedAprov := ""
Local cLink := GetNewPar("CN_URLPEC", "http://192.168.205.200:88/portal_40/")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// busca a descricao da condicao de pagamento
cCondPag += " - " + AllTrim(Posicione("SE4", 01, xFilial("SE4") + cCondPag, "E4_DESCRI"))

cNatDesc := AllTrim(Posicione("SED", 01, xFilial("SED") + cNatureza, "ED_DESCRIC"))

//cMail := 'helpdesk.ti@grupocantu.com.br'             // Guilherme

if INCLUI .OR. ALTERA
	cPedido  := SC7->C7_NUM
	//Roberto - 06/04/2013 - Alterado para enviar workflow de liberação quando o tipo do pedido for Autorização de entrega também
	cTipo    := iif(SC7->C7_TIPO == 1, "PC", "AE")
	cLoja    := SC7->C7_LOJA
	cFornec  := SC7->C7_FORNECE
	cSolCmp  := SC7->C7_NUMSC	
	cFornecM := RTRIM(POSICIONE("SA2",1,xFilial("SA2")+cFornec+cLoja,"A2_NOME"))
	//
	conout("1/6). Verificando itens do pedido...")
	for _nX := 1 to len(aCols)
		If !aCols[_nX][Len(aCols[_nX])]
			aAdd(aItens, {aCols[_nX][nPosProd]                                           , ;
			              POSICIONE("SB1",1,xFilial("SB1")+aCols[_nX][nPosProd],"B1_DESC") , ;
			              aCols[_nX][nPosQuant]                                          , ;
			              aCols[_nX][nPosUnMed]                                          , ;
			              aCols[_nX][nPosPrUnt]                                          , ;
			              aCols[_nX][nPosVlTot]                                          , ;
			              AllTrim(aCols[_nX][nPosObs])                                   , ;
			              POSICIONE("SBZ",1,xFilial("SBZ")+aCols[_nX][nPosProd],"BZ_UPRC")} ) // Jean - ultimo preço de compra do Indicador de Produto.
		EndIf
	Next
	//
	dbSelectArea("SCR")
	dbgotop(1)
	dbSeek(xFilial("SCR")+cTipo+cPedido)
	conout("2/6). Verificando Controle de Alçadas...")
	while !eof().and.(xFilial("SCR") == SCR->CR_FILIAL) .And. (AllTrim(SCR->CR_NUM) == cPedido)  .And. (SCR->CR_TIPO == cTipo)// validas se é o mesmo pedido
		aRetSaldo   := MaSalAlc(SCR->CR_APROV,DDatabase)
		nSaldo 	    := aRetSaldo[1]
		CRoeda 	    := A097Moeda(aRetSaldo[2])
		nTotal      := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
		nSalDif     := nSaldo - nTotal
		//
		conout("3/6). Aprovador..: " + UPPER(RTRIM(POSICIONE("SAK",1,xFilial("SAK") + SCR->CR_APROV,"AK_NOME"))))
		aAdd(aLibera,{SCR->CR_EMISSAO, ;
		              SCR->CR_APROV, ;
		              getEmail(SCR->CR_USER), ;
		              DTOC(DDATABASE), ;
		              getLimits(SCR->CR_USER ), ;
		              nSaldo, ;
		              nTotal, ;
		              CRoeda, ;
		              nSalDif, ;
		              UPPER(RTRIM(POSICIONE("SAK",1,xFilial("SAK") + SCR->CR_APROV,"AK_NOME")))} )
		SCR->(DbSkip())
	EndDo  

	//getEmail(SCR->CR_USER), ; colocar no lugar do cMail
	
	//
	for _nY := 1 to Len(aLibera)
		//Inicia processo de envio do e-mail
		cProcess := OemToAnsi("002020") // Numero do Processo
		cStatus  := OemToAnsi("002021")
		conout("4/6). Solicitacao Liberação -  Pedido de Compra No " + cPedido + " - (CTMA01)")
	    oProcess := TWFProcess():New(cProcess,OemToAnsi("Solicitação de Liberação  -  Pedido de Compra No " + cPedido + " - (CTMA01)"))
		oProcess:NewTask(cStatus,"\workflow\wfaprovac.htm")
		//Roberto - 06/04/2013 - altera o assunto conforme o tipo do pedido
		cAssunto := iif(cTipo == "AE", "Solicitação de Liberação de Autorização de Entrega", "Solicitação de Liberação de Pedido de Compra")
		oProcess:cSubject := OemToAnsi(cAssunto)
		oProcess:bReturn  := "U_CTMAT02(1)"
//		oProcess:bTimeOut := {{"U_CTMAT02(2)",2,0,0}}
		
		oProcess:cTo := aLibera[_nY][3] 
		
		//Roberto - 06/04/2013 - Verifica se é Pedido ou Autorização de entrega para informar no corpo do e-mail
		cPedAprov := iif( cTipo == "AE", "da autorização de entrega", "do pedido de compra")
		
		// Preenchimento do cabeçalho da solicitação
		oHTML:= oProcess:oHTML
		oHtml:ValByName("EMP"        ,ALLTRIM(SM0->M0_NOMECOM))
		oHtml:ValByName("PEDAPROV"   ,cPedAprov)
		oHtml:ValByName("NPED"       ,cPedido)
		oHtml:ValByName("DATA"       ,aLibera[_nY][1])
		oHtml:ValByName("CODFOR"     ,cFornec)
		oHtml:ValByName("LOJAFOR"    ,cLoja)
		oHtml:ValByName("NOMFOR"     ,cFornecM)
		oHtml:ValByName("CDAPRV"     ,aLibera[_nY][2])
		oHtml:ValByName("NMAPRV"     ,aLibera[_nY][10])
		oHtml:ValByName("DTREF"      ,DDATABASE)
		oHtml:ValByName("MOEDA"      ,aLibera[_nY][8])
		oHtml:ValByName("LIMMIN"     ,Transform(aLibera[_nY][5][1],"@E 999,999,999.99"))
		oHtml:ValByName("LIMMAX"     ,Transform(aLibera[_nY][5][2],"@E 999,999,999.99"))
		oHtml:ValByName("LIMITE"     ,Transform(aLibera[_nY][5][3],"@E 999,999,999.99"))
		oHtml:ValByName("TIPOLIM"    ,aLibera[_nY][5][4])
		oHtml:ValByName("SLDDT"      ,Transform(aLibera[_nY][6],"@E 999,999,999.99"))
		oHtml:ValByName("TOTDOC"     ,Transform(aLibera[_nY][7],"@E 999,999,999.99"))
		oHtml:ValByName("SLDAPLIB"   ,Transform(aLibera[_nY][9],"@E 999,999,999.99"))
		oHtml:ValByName("USER"       ,__cUserId)
		oHtml:ValByName("Cond"       ,cCondPag)
		oHtml:ValByName("NomeEmp"    ,SM0->M0_NOME)	
		oHtml:ValByName("NomeFil"    ,SM0->M0_FILIAL)

		oHtml:ValByName("SEGMENTO"   ,SC7->C7_CLVL + " - " + POSICIONE("CTH",1,xFilial("CTH")+SC7->C7_CLVL,"CTH_DESC01"))
		oHtml:ValByName("CCUSTO"     ,SC7->C7_CC + " - " + POSICIONE("CTT",1,xFilial("CTT")+SC7->C7_CC,"CTT_DESC01"))		

		// seta o comprador (código e nome)		
		oHtml:ValByName("COMPRADOR"       ,__cUserId + " - " + Upper(cUserName))
		
		// informa quem solicitou a compra
		if !empty(cSolCmp)
			cSolicitante := AllTrim(POSICIONE("SC1",1,xFilial("SC1")+cSolCmp,"C1_SOLICIT"))
			oHtml:ValByName("SOLICITANTE"     ,cSolicitante) 
		EndIf
		
		if empty(cSolCmp)
			oHtml:ValByName("SOLCMP"     ,"S/ SOL. COMPRA ")
		else
			oHtml:ValByName("SOLCMP"     ,"SOL. COMPRA No: " + cSolCmp)
		endif

		
		/*Cabec := ""
		oItens:cString := {}
		//if (_nY == 1)
			// Adiciona os campos do cabeçalho
			Cabec += "EMP=" + ALLTRIM(SM0->M0_NOMECOM)
			Cabec += "&NPED=" + ALLTRIM(cPedido)
			Cabec += "&DATA=" + DToC(aLibera[_nY][1])
			Cabec += "&CODFOR=" + cFornec
			Cabec += "&LOJAFOR=" + cLoja
			Cabec += "&NOMFOR=" + cFornecM
			Cabec += "&CDAPRV=" + aLibera[_nY][2]
			Cabec += "&NMAPRV=" + aLibera[_nY][10]	
			Cabec += "&COMPRADOR=" + __cUserId + " - " + Upper(cUserName)
			Cabec += "&SOLICITANTE="	+ AllTrim(cSolicitante)	
			Cabec += "&WFEMPRESA="	+ SM0->M0_CODIGO
			Cabec += "&WFFILIAL=" + SM0->M0_CODFIL
			Cabec += "&OBS=digite aqui a sua observação" 
			Cabec += "&TOTAL=" + AllTrim(Transform(aLibera[_nY][7],"@E 999,999,999.99"))
		//EndIf */
		//
		for _nZ := 1 to len(aItens)
			conout("5/6). Produto..: " + rtrim(aItens[_nZ][1]) + " - " + rtrim(aItens[_nZ][2]))
			AAdd(oHtml:ValByName("IT.CODIGO")  ,aItens[_nZ][1])
			AAdd(oHtml:ValByName("IT.Descricao") ,aItens[_nZ][2])
			AAdd(oHtml:ValByName("IT.Quantidade")     ,Transform(aItens[_nZ][3],PesqPict("SC7","C7_QUANT",12)))
			AAdd(oHtml:ValByName("IT.UM")      ,aItens[_nZ][4])
			AAdd(oHtml:ValByName("IT.UPRC")   ,Transform(aItens[_nZ][8],PesqPict("SC7","C7_QUANT",14))) // Adriano Ultimo preço de compra
			AAdd(oHtml:ValByName("IT.PRECO")   ,Transform(aItens[_nZ][5],PesqPict("SC7","C7_QUANT",14)))
			AAdd(oHtml:ValByName("IT.TOTAL")   ,Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
			AAdd(oHtml:ValByName("IT.OBS")   ,aItens[_nZ][7])
			conout("TOTAL DO ITEM " + Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
			
			/*Item := ""
			
			//if (_nY == 1)
				// Adiciona os campos de itens					
				Item += "IT.Codigo." + AllTrim(Str(_nZ)) + "=" + AllTrim(aItens[_nZ][1])
				Item += "&IT.Descricao." + AllTrim(Str(_nZ)) + "=" + ALLTRIM(aItens[_nZ][2])
				Item += "&IT.Quantidade." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][3],PesqPict("SC7","C7_QUANT",12)))
				Item += "&IT.UM." + AllTrim(Str(_nZ)) + "=" + aItens[_nZ][4]
				Item += "&IT.PRECO." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][5],PesqPict("SC7","C7_QUANT",14)))
				Item += "&IT.TOTAL." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
				Item += "&IT.ITEM." + AllTrim(Str(_nZ)) + "=" + AllTrim(Str(_nZ))
		
				AADD(oItens:cString, Item)
			//EndIf */
		Next
		         
		/*oWS:Reset()
		//if (_nY == 1)
			// chama o webservice e recebe o retorno
			If oWS:GravaPedido(Cabec, oItens)
			   Pedido := oWS:cGravaPedidoResult
			Else
			   Pedido := ""
			EndIf
		//EndIf*/
		
		// seta o link de acesso ao site
		
		//oHtml:ValByName("LINKSITE", "http://www.cantu.tecnologia.ws/wscotacao/AprovacaoPedido.aspx?ID=" + Pedido)
		oHtml:ValByName("LINKSITE", cLink + "U_PAPROVPC.apw?Emp=" + Trim(cEmpAnt) + "&Aprovador=" + aLibera[_nY][2] + ;
									"&xPedido=" + cPedido + "&xFilial=" + cFilPed )
		
		oProcess:Start()
		oProcess:Finish()
		// chama o webservice de atualização do arquivo
		// if (_nY == 1)
		//	oWS:SetIdWF(Pedido, "WF" + cID)		
		// EndIf
	Next
endif
RestArea(aSeg)
Return
//////////
static function getLimits(pcUser)
local cArea := getArea()
local aRet  := {NIL,NIL,NIL,NIL}
//
dbSelectArea("SAK")
dbSetOrder(2)
dbgotop()
if dbSeek(xFilial()+pcUser)
	aRet[1] := SAK->AK_LIMMIN
	aRet[2] := SAK->AK_LIMMAX
	aRet[3] := SAK->AK_LIMITE
	aRet[4] := SAK->AK_TIPO
	//
	do case
		case aRet[4] = 'D'
			aRet[4] += ' - DIARIA'
			
		case aRet[4] = 'S'
			aRet[4] += ' - SEMANAL'
			
		case aRet[4] = 'M'
			aRet[4] += ' - MENSAL'
	endcase
endif
restarea(cArea)
return(aRet)
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