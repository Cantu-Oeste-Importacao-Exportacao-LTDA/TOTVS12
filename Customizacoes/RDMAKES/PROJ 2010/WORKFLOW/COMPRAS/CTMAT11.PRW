/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ CTMAT11  ¦ Autor ¦ LINCOLN P. ROSSETTO   ¦ Data ¦ 16/04/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Rotina que dispara e-mail para os usuários alertando      ¦¦¦
¦¦¦          ¦ do bloqueio no momento da gravação da cotação e geração    ¦¦¦
¦¦¦          ¦ do pedido.                                                 ¦¦¦
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
User Function CTMAT11()
local aSeg 	   := GetArea()
local cProcess := Space(6), cStatus := Space(6), cEmail := ""
local cNum     := "", cCond := ""
local lWF      := .T.
//
local cPedido  := SC7->C7_NUM
local cLoja    := SC7->C7_LOJA
local cFornec  := SC7->C7_FORNECE
local cSolCmp  := SC7->C7_NUMSC
local cProdut  := SC7->C7_PRODUTO
local cFornecM := RTRIM(POSICIONE("SA2",1,xFilial("SA2")+cFornec+cLoja,"A2_NOME"))

local cAprovad
local cSolCmp
local cTipo     := 'PC'
local aItens    := {}
local aLibera   := {}
local aRetSaldo := {}
local nSaldo
local CRoeda
local nTotal
local nSalDif
local cComprador
local cSolicitante
local cUserPed  := SC7->C7_USER
local Cabec := "", Item := "", Pedido, cID
Local oWS    := WSWSAprovaPedido():New()
Local oItens := WSAprovaPedido_ArrayOfString():New()
Local cCondPag := SC7->C7_COND
Local cNatureza := ""
Local cFormPag := ""
Local aDadPed := {}
Local lGravaNat := SC7->(FieldPos("C7_NATUREZ")) > 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// busca a descricao da condicao de pagamento
cCondPag += " - " + AllTrim(Posicione("SE4", 01, xFilial("SE4") + cCondPag, "E4_DESCRI"))

dbselectarea("SC7")
dbsetorder(1)
dbgotop()

if lGravaNat
	// Pede a Natureza do Pedido	
	aDadPed := GetNatPed()
	cNatureza := aDadPed[1]
	cFormPag := aDadPed[2]
	While (AllTrim(cNatureza) == "")
	  Alert("Favor selecionar a Natureza para o Pedido!")
	  aDadPed := GetNatPed()
	  cNatureza := aDadPed[1]
	  cFormPag := aDadPed[2]
	EndDo
EndIf

cNatDesc := AllTrim(Posicione("SED", 01, xFilial("SED") + cNatureza, "ED_DESCRIC"))

dbseek(xFilial("SC7") + cPedido)   

// Solicitante admin	
cSolCmp  := SC7->C7_NUMSC

ConOut("1/6). Verificando itens do pedido...")
while !SC7->(eof()) .AND. (SC7->C7_NUM == cPedido) .And. (SC7->C7_FILIAL = xFilial("SC7"))	
	aAdd(aItens, {SC7->C7_PRODUTO, ;
	              POSICIONE("SB1",1,xFilial("SB1")+SC7->C7_PRODUTO,"B1_DESC"), ;
	              SC7->C7_QUANT, ;
	              SC7->C7_UM, ; 	              
	              SC7->C7_PRECO, ;
	              SC7->C7_TOTAL,;
	              AllTrim(SC7->C7_OBS),;
	              POSICIONE("SBZ",1,xFilial("SBZ")+SC7->C7_PRODUTO,"BZ_UPRC")} ) // Jean - Ultimo preço de compra no Indicador de Produto.
	              
	if (lGravaNat)
		// grava a natureza do pedido de compra em todos os itens			
		RecLock("SC7", .F.)
		SC7->C7_NATUREZ := cNatureza
		SC7->C7_FORMPAG := cFormPag
		MsUnlock()
	EndIf
	
	SC7->(dbskip())
EndDo

dbSelectArea("SCR")
dbgotop(1)
dbSeek(xFilial("SCR")+'PC'+cPedido)
conout("2/6). Verificando Controle de Alçadas...")
while !eof().and.(xFilial("SCR") == SCR->CR_FILIAL) .And. (AllTrim(SCR->CR_NUM) == cPedido) .And. (SCR->CR_TIPO == "PC")
	aRetSaldo   := MaSalAlc(SCR->CR_APROV,DDatabase)
	nSaldo 	 := aRetSaldo[1]
	CRoeda 	 := A097Moeda(aRetSaldo[2])
	nTotal      := xMoeda(SCR->CR_TOTAL,SCR->CR_MOEDA,aRetSaldo[2],SCR->CR_EMISSAO,,SCR->CR_TXMOEDA)
	nSalDif     := nSaldo - nTotal
	//
	conout("3/6). Aprovador..: " + UPPER(RTRIM(POSICIONE("SAK",1,xFilial("SAK") + SCR->CR_APROV,"AK_NOME"))))
	aAdd(aLibera,{SCR->CR_EMISSAO, ;
	              SCR->CR_APROV, ;  // Obtém o email do usuário aprovador, para casos de transferencia para superior
	              getEmail(AllTrim(POSICIONE("SAK",1,xFilial("SAK") + SCR->CR_APROV,"AK_USER"))), ;
	              DTOC(DDATABASE), ;
	              getLimits(SCR->CR_USER), ;
	              nSaldo, ;
	              nTotal, ;
	              CRoeda, ;
	              nSalDif, ;
	              UPPER(RTRIM(POSICIONE("SAK",1,xFilial("SAK") + SCR->CR_APROV,"AK_NOME"))), ;
	              SCR->CR_USER} )
	dbSelectArea("SCR")
	dbSkip()
enddo

for _nY := 1 to Len(aLibera)
	//Inicia processo de envio do e-mail
	cProcess := OemToAnsi("002020") // Numero do Processo
	cStatus  := OemToAnsi("002021")
	conout("4/6). Solicitacao Liberação -  Pedido de Compra No " + cPedido + " - (CTMA01)")
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Solicitação de Liberação  -  Pedido de Compra No " + cPedido + " - (CTMA11)"))
	oProcess:NewTask(cStatus,"\workflow\wfaprovac.htm")
	oProcess:cSubject := OemToAnsi("Solicitação de Liberação de Pedido de Compra")
	oProcess:bReturn  := "U_CTMAT02(1)"
//	oProcess:bTimeOut := {{"U_CTMAT02(2)",2,0,0}}
	
	oProcess:cTo := aLibera[_nY][3]
	
	// Preenchimento do cabeçalho da solicitação
	oHTML:= oProcess:oHTML
	oHtml:ValByName("EMP"        ,ALLTRIM(SM0->M0_NOMECOM))
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
	oHtml:ValByName("USER"       ,aLibera[_nY][11])
	oHtml:ValByName("Cond"       ,cCondPag)
	oHtml:ValByName("NomeEmp"    ,SM0->M0_NOME)	
	oHtml:ValByName("NomeFil"    ,SM0->M0_FILIAL)
  // Flavio - Comentei devido a nao ter sido adicionado no html o campo
//	oHtml:ValByName("Natureza"   ,cNatureza + " - " + cNatDesc)
	
	
//	oHtml:ValByName("OBS"        ,)
	
	// seta o comprador (código e nome)
	// verificar qual deve ser o comprador, que no caso está referenciando ao aprovador, e nao ao comprador
	cComprador := POSICIONE("SY1",3,xFilial("SY1") + cUserPed, "Y1_NOME")
	oHtml:ValByName("COMPRADOR", aLibera[_nY][11] + " - " + cComprador)
	
	// informa quem solicitou a compra
	if !empty(cSolCmp)
		cSolicitante := POSICIONE("SC1",1,xFilial("SC1") + cSolCmp,"C1_SOLICIT")
		oHtml:ValByName("SOLICITANTE", cSolicitante)
	EndIf
	  
	/*Cabec := ""
	oItens:cString := {}
	// Adiciona os campos do cabeçalho
	Cabec += "EMP=" + ALLTRIM(SM0->M0_NOMECOM)
	Cabec += "&NPED=" + ALLTRIM(cPedido)
	Cabec += "&DATA=" + DToC(aLibera[_nY][1])
	Cabec += "&CODFOR=" + cFornec
	Cabec += "&LOJAFOR=" + cLoja
	Cabec += "&NOMFOR=" + cFornecM
	Cabec += "&CDAPRV=" + aLibera[_nY][2]
	Cabec += "&NMAPRV=" + aLibera[_nY][10]	
	Cabec += "&COMPRADOR=" + aLibera[_nY][11] + " - " + cComprador
	Cabec += "&SOLICITANTE="	+ AllTrim(cSolicitante)	
	Cabec += "&WFEMPRESA="	+ SM0->M0_CODIGO
	Cabec += "&WFFILIAL=" + SM0->M0_CODFIL
	Cabec += "&OBS=digite aqui a sua observação" 
	Cabec += "&TOTAL=" + AllTrim(Transform(aLibera[_nY][7],"@E 999,999,999.99"))*/

	//
	if empty(cSolCmp)
		oHtml:ValByName("SOLCMP"     ,"S/ SOL. COMPRA ")
	else
		oHtml:ValByName("SOLCMP"     ,"SOL. COMPRA No: " + cSolCmp)
	endif
	//
	oHtml:ValByName("OBS"        ,"digite aqui a sua observação")
	
	// obtém os fornecedores da cotação gerada

	for _nZ := 1 to len(aItens)
		conout("5/6). Produto..: " + rtrim(aItens[_nZ][1]) + " - " + rtrim(aItens[_nZ][2]))
		AAdd(oHtml:ValByName("IT.Codigo")  ,aItens[_nZ][1])
		AAdd(oHtml:ValByName("IT.Descricao") ,aItens[_nZ][2])
		AAdd(oHtml:ValByName("IT.Quantidade")     ,Transform(aItens[_nZ][3],PesqPict("SC7","C7_QUANT",12)))
		AAdd(oHtml:ValByName("IT.UM")      ,aItens[_nZ][4])
		AAdd(oHtml:ValByName("IT.UPRC")   ,Transform(aItens[_nZ][8],PesqPict("SC7","C7_QUANT",14))) // Adriano Ultimo preço de compra
		AAdd(oHtml:ValByName("IT.PRECO")   ,Transform(aItens[_nZ][5],PesqPict("SC7","C7_QUANT",14)))
		AAdd(oHtml:ValByName("IT.TOTAL")   ,Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
		AAdd(oHtml:ValByName("IT.OBS")     ,aItens[_nZ][7])
		conout("TOTAL DO ITEM " + Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
		      
		/*Item := ""

		// Adiciona os campos de itens
		Item += "IT.Codigo." + AllTrim(Str(_nZ)) + "=" + AllTrim(aItens[_nZ][1])
		Item += "&IT.Descricao." + AllTrim(Str(_nZ)) + "=" + ALLTRIM(aItens[_nZ][2])
		Item += "&IT.Quantidade." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][3],PesqPict("SC7","C7_QUANT",12)))
		Item += "&IT.UM." + AllTrim(Str(_nZ)) + "=" + aItens[_nZ][4]
		Item += "&IT.PRECO." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][5],PesqPict("SC7","C7_QUANT",14)))
		Item += "&IT.TOTAL." + AllTrim(Str(_nZ)) + "=" + AllTrim(Transform(aItens[_nZ][6],PesqPict("SC7","C7_TOTAL",14)))
		Item += "&IT.ITEM." + AllTrim(Str(_nZ)) + "=" + AllTrim(Str(_nZ))

		AADD(oItens:cString, Item)		*/
	Next     
	
	/*oWS:Reset()
	// chama o webservice e recebe o retorno
	If oWS:GravaPedido(Cabec, oItens)
	   Pedido := oWS:cGravaPedidoResult
	Else
	   Pedido := ""
	EndIf*/

	// seta o link de acesso ao site	
	//oHtml:ValByName("LINKSITE", "http://www.cantu.tecnologia.ws/wscotacao/AprovacaoPedido.aspx?ID=" + Pedido)
	oHtml:ValByName("LINKSITE", "http://www.cantu.tecnologia.ws/wscotacao/AprovPedComp.aspx?Pedido=" + cPedido + ;
			"&Emp=" + cEmpAnt + "&Filial="+ cFilAnt + "&Aprovador=" + aLibera[_nY][2])                                                                                                           
	
	cID := oProcess:Start()
	// chama o webservice de atualização do arquivo
	oWS:SetIdWF(Pedido, "WF" + cID)
Next
RestArea(aSeg)
Return
//////////
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
	if PswSeek(pcUser,.t.)
		cRet := PswRet(1)[1,14]
	endif
	restarea(cArea)
return(cRet)

/*********************************************************
  Obém a natureza e a forma de pagamento do pedido
 ********************************************************/
Static Function GetNatPed()
Local oDlg
Local cNat := Space(20)
Local cFormPag := Space(2)
@ 100, 100 To 215, 310 Dialog oDlg Title "Natureza do Pedido de Compra"
@  10,  10 Say "Natureza ?"   
@  10,  45 Get cNat Picture "@S20" F3 "SED" Valid ExistCpo("SED", cNat, 01)
@  25,  10 Say "Forma Pagto ?"   
@  25,  45 Get cFormPag Picture "@S5" F3 "24" Valid FormValid(cFormPag)

@  40,  35 BmpButton Type 01 Action ValidDados(cNat, cFormPag, oDlg)
Activate Dialog oDlg Center
Return {cNat, cFormPag}

/*******************************************************
  Função de apoio ao item acima para deixar obrigatório o preenchimento dos dados
 ******************************************************/
Static Function ValidDados(cNat, cFormPag, oDlg)
Local lOk := ExistCpo("SED",cNat,01)
lOk := lOk .And. FormValid(cFormPag)
if lOk 
  Close(oDlg)
EndIf
Return lOk

Static Function FormValid(cFormPag)
Local lOk
lOk := !Empty(cFormPag)
lOk := lOK .And. !Empty(Posicione("SX5", 01, xFilial("SX5") + "24" + cFormPag, "X5_DESCRI"))
Return lOk