#include "rwmake.ch"
#include "topconn.ch"
/*/
+----------+----------+-------+-----------------------+------+----------+
|Programa  |SLDVNDM   | Autor | Flavio Dias           | Data | 20/08/08 |
+----------+----------+-------+-----------------------+------+----------+
|EMPRESA   | CANTU - CHAPECO                                            |
|Descricao | Relatorio Diário/Mensal enviado por email, com o credito   |
|          | devedor ou credor de cada vendedor. Os filtros de vendedor |
|					 | e email estão no array aConf, devido a ser usado o mesmo   |
|					 | fonte para várias empresas. 																|
|          | Esse relatorio é enviado por email, para os emails         |
|          | cadastrados na tabela ZWF. Isso e separado por empresa     |
|          | pelo fato de que os codigos de vendedores diferem de empre-|
|          | sa para empresa.                                           |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu                                 |
+----------+------------------------------------------------------------+
/**************************************
 workflow que envia email informando do atraso na entrega do pedido de compras
 *************************************/
User Function WPedComp()
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local aArea   := GetArea() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//RPCSetEnv("50","01","","","","",{"SC5","SA3"})

Conout("Empresa atual: " + cEmpAnt)
ConOut("Inicializando o processo")
Conout("WF - PedComp - INICIO DO ENVIO DE EMAIL Pedidos de compra em atraso - "+DTOC(DDATABASE-1))

// limitado a 500 registros apenas devido a dar erro quando existem muitas linhas.
cQuery := "SELECT C7_FILIAL, C7_NUM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_QUJE, C7_EMISSAO, C7_DATPRF, C7_USER "
cQuery += " FROM " + RetSqlName("SC7")
cQuery += " WHERE C7_QUJE < C7_QUANT AND d_e_l_e_t_ <> '*' AND C7_DATPRF <= '" + DtoS(DDATABASE-1)  + "'"
cQuery += " AND C7_DATPRF >= '" + DtoS(DDATABASE-15)  + "' AND C7_CONAPRO <> 'B' AND C7_RESIDUO <> 'S'" // Flavio - filtrado pedidos eliminados por resíduo
cQuery += " ORDER BY C7_FILIAL, C7_USER, C7_NUM, C7_ITEM"

TCQUERY cQuery NEW ALIAS "TMPSC7"

// Busca o email da configuracao
cEmail  := Posicione("ZWF", 01, xFilial("ZWF") + "WPEDCOMP", "ZWF_EMAIL")
// cEmail  := 'helpdesk.ti@grupocantu.com.br'

// trabalha com o arquivo de pedidos em aberto
dbSelectArea("TMPSC7")
cUserComp := TMPSC7->C7_FILIAL+TMPSC7->C7_USER
While TMPSC7->(!EOF())	
	oProcess := TWFProcess():New( "WPedComp", "Pedidos de Compra em atraso")
	oProcess:NewTask( "WPedComp", "\workflow\wpedcomp.html" )
	
	oProcess:cSubject := "Pedidos de compra em atraso em " + DTOC(DDATABASE-1) + " - Empresa " + SM0->M0_NOME
						
	oHTML := oProcess:oHTML
	
	oHtml:ValByName("DATA", dDataBase - 1)
	oHtml:ValByName("EMPRESA", SM0->M0_NOME)
	
	// Busca o comprador
	SY1->(dbSetOrder(03))
	SY1->(dbSeek(TMPSC7->C7_FILIAL+TMPSC7->C7_USER))
	oHtml:ValByName("COMPRADOR", SY1->Y1_COD + " - " + SY1->Y1_NOME)

	While (cUserComp == TMPSC7->C7_FILIAL+TMPSC7->C7_USER)	
  	AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSC7->C7_FILIAL)      
		AAdd((oHtml:ValByName( "IT.NUM" )), TMPSC7->C7_NUM)
		AAdd((oHtml:ValByName( "IT.PRODUTO" )), AllTrim(TMPSC7->C7_PRODUTO) + " - " + AllTrim(TMPSC7->C7_DESCRI))	
		AAdd((oHtml:ValByName( "IT.QUANT"  )), TRANSFORM( TMPSC7->C7_QUANT ,'@E 999,999.99' ) )
		AAdd((oHtml:ValByName( "IT.QENT"  )), TRANSFORM( TMPSC7->C7_QUJE ,'@E 999,999.99' ) )  
		AAdd((oHtml:ValByName( "IT.EMISSAO" )), DtoC(StoD(TMPSC7->C7_EMISSAO)))
		AAdd((oHtml:ValByName( "IT.PREVISAO" )), DtoC(StoD(TMPSC7->C7_DATPRF)))
		TMPSC7->(dbSkip())
	EndDo

	if !Empty(cEmail )                             // TMPSC7->C7_USER
		oProcess:cTo  := getEmail(SubStr(cUserComp, 3)) // Posicione("SY1", 03, xFilial("SY1") + SubStr(cUserComp, 3), "Y1_EMAIL") // Adriano 01-10-2010
																							 // Usuario que incluia o pedido de compra não estava recebendo e-mail.						
		ConOut("Email enviado para para " + oProcess:cTo)
		oProcess:cCC  := LOWER(cEmail)
		oProcess:Start()	
	EndIf
	oProcess:Finish()
	cUserComp := TMPSC7->C7_FILIAL+TMPSC7->C7_USER
EndDo

TMPSC7->(dbCloseArea())
ConOut("Email enviado para " + AllTrim(cEmail))

RestArea(aArea)
Return

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