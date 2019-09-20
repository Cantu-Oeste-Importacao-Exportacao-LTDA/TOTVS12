#include 'protheus.ch'
#include 'rwmake.ch'
#include "topconn.ch"
/**************************************************
 Ponto de entrada após a liberação do pedido 
 na análise de crédito do mesmo
 *************************************************/
Static Function SendMail(nLib)
Local aArea 	:= GetArea()
Local cCliente  := SC5->C5_CLIENTE
Local cLoja     := SC5->C5_LOJACLI
Local lFlag 	:= .F.
Local cMotivo   := ""   
Local _PedidoSC5:= SC5->C5_NUM

if (nLib == 3)
	Return .F.
EndIf

cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'MTA456I' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
MEMOWRITE("TESTE.SQL",CQUERY)	
dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"
		conout("WF - LIB. CRED/ESTOQUE - INICIO DO ENVIO DE EMAIL CLIENTE : "+ cCliente + cLoja)
		oProcess := TWFProcess():New( "MTA456I", "LIBERACAO DE CREDITO E ESTOQUE")
		oProcess:NewTask( "MTA456I", "\workflow\MTA456I.HTML" )
		oProcess:cSubject := "Liberacao de credito de cliente, no faturamento. - "+DTOC(DDATABASE)
		oHTML := oProcess:oHTML	
    
    dbSelectArea("SA1")
    dbSetOrder(1)
    dbSeek(xFilial("SA1")+cCliente+cLoja)

		oHtml:ValByName( "DATA1", dDataBase)
		oHtml:ValByName( "COD_CLI", cCliente)
		oHtml:ValByName( "LOJA_CLI", cLoja)
		oHtml:ValByName( "NOME_CLI", SA1->A1_NOME)										
		oHtml:ValByName( "PEDIDO", _PedidoSC5)				
		
		cMotivo :="Cliente bloqueado por " + cBloqCred

		oHtml:ValByName( "Motivo",  cMotivo)
		oHtml:ValByName( "Usuario", subStr(cUsuario,7,15))				
		
		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO 
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()         
		conout("WF - LIB. CRED/ESTOQUE - FIM DO ENVIO DE EMAIL CLIENTE : "+ cCliente + cLoja)
		lFlag := .T.
	EndIf
EndIf
If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'SLDVND' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif
TMP->(dbCloseArea())
RestArea(aArea)
Return .T.

// na abertura da tela de liberacao manual, para buscar o tipo de liberacao dos itens
User Function MT450MAN()
Local cBlq := SC9->C9_BLCRED 
Static cBloqCred := ""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If ( cBlq == "01" )
	cBloqCred := "Crédito"
	//	ElseIf cBlq == "04"
	//		cBloqCred := "Limite de Crédito Vencido"
	//	ElseIf cBlq == "09"
	//		cBloqCred := "Rejeitado"	
	//	Else
	//		cBloqCred := "Outro Motivo"	
EndIf
Return .T.

// Funçao executada no final da liberacao de limite de credito para o pedido
User Function MT450FIM()
Local aArea := GetArea()
Local cPedido := PARAMIXB[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se pedido esta liberado e seta flag.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lRet := .F.
	MsAguarde( {|| lRet := U_RJCHKSC9(cPedido) }, "Verificando liberação do pedido... Aguarde!")		
	If lRet
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "N"
			SC5->(MsUnLock())				
		EndIf
	Else
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "S"
			SC5->(MsUnLock())				
		EndIf	
	EndIf

	SendMail(1)    
          
	RestArea(aArea)

Return Nil

// acelerar a liberacao de credito, buscar apenas o ultimo mes.
User Function M450FIL()
  Local cFiltro:= ' (dTos(C9_DATALIB) >="' + DTOS(dDataBase - 02) + '")'  
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
Return cFiltro