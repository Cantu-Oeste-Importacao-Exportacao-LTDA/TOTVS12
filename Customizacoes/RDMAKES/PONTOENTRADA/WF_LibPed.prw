#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
//-----------------------
// Ponto de entrada para enviar email, informando da liberação do pedido, que estava bloquedo por crédito ou por atraso
// Data Criacao: 27/08/05
// Eder e Rafael Parma
//-----------------------

User Function MTA456P()

Local aArea 	:= GetArea()
Local cCliente  := SC5->C5_CLIENTE
Local cLoja     := SC5->C5_LOJACLI
Local lBloq01   := .F.
Local lBloq04 	:= .F.
Local lFlag 	:= .F.
Local cMotivo   := ""   
Local _PedidoSC5:= SC5->C5_NUM 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                                

   	dbSelectArea("SC9")
   	dbSetOrder(1)                        
   	dbGotop()
	If dbSeek(xFilial("SC9") + AllTrim(_PedidoSC5))
		While !SC9->(eof()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + _PedidoSC5
       		if SC9->C9_BLCRED == "01"
           		lBloq01 := .T.
        	elseIf SC9->C9_BLCRED == "04"
           		lBloq04 := .T.
        	endIf
       		DbSkip()
   	  	endDo	
	endIf
	if lBloq01 .or. lBloq04
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
				oProcess:NewTask( "MTA456I", "\WORKFLOW\MTA456I.HTML" )
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
				if lBloq01 .and. lBloq04
                	cMotivo :="Cliente bloqueado por LIMITE de crédito e ATRASO"
				elseIf lBloq01
                	cMotivo :="Cliente bloqueado por LIMITE de crédito"
				elseIf lBloq04
                	cMotivo :="Cliente bloqueado por ATRASO"
				endIf

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
	endIf
RestArea(aArea)
Return .T.