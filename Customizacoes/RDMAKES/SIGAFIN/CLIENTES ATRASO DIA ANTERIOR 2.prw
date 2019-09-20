#include "rwmake.ch"
#include "topconn.ch"
/*/
// definir                                                                                                   	
+----------+----------+-------+-----------------------+------+----------+
Dioni Reginatto - 29/12/2011
WF - Chamado 447
+----------+------------------------------------------------------------+
/**************************************
 workflow que envia email informando do atraso na entrega do pedido de compras
 *************************************/
User Function WFCliDvDA2()
Local oProcess          
Local cQuery  := ""
Local cEmail  := ""
Local aArea   := GetArea()  
Local aAreaSM0 := SM0->(GETAREA())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
//RPCSetEnv("50","01","","","","",{"SC5","SA3"})

Conout("Empresa atual: " + cEmpAnt)                           	
ConOut("Inicializando o processo")
conout("WF - WCliDvDA - INICIO DO ENVIO DE EMAIL .... - ")
                                                                       
auxData := DDATABASE - 1            

cQuery := "SELECT SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI, SUM(SE1.E1_VALOR) AS E1_VALOR "
cQuery += " FROM " + RetSqlName("SE1") + " SE1, " + RetSqlName("SA1") + " SA1 "
cQuery += " WHERE  SA1.A1_LC < 500000 AND SE1.E1_VENCTO = '" + DtoS(auxData)  + "' AND SE1.E1_SALDO > 0 AND SE1.d_e_l_e_t_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SE1.E1_FILIAL <> '01'"
cQuery += " GROUP BY SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_NOMCLI
cQuery += " ORDER BY SE1.E1_FILIAL, E1_VALOR DESC "           

//MemoWrite("c:\CliAtra.txt",cQuery)

TCQUERY cQuery NEW ALIAS "TMPSE1"

// Busca o email da configuracao
cEmail  := Posicione("ZWF", 01, xFilial("ZWF") + "WFCLIDVD", "ZWF_EMAIL") 
//cEmail := 'dioni@grupocantu.com.br'   
// trabalha com o arquivo de pedidos em aberto
dbSelectArea("TMPSE1")
oProcess := TWFProcess():New( "WCliDvDA", "Clientes que não pagaram títulos no dia anterior")
oProcess:NewTask( "WCliDvDA", "\workflow\wclidvda2.html") // "\WORKFLOW\WPedComp.html" )

oProcess:cSubject :=  "Clientes que não pagaram títulos no dia anterior" 
						
oHTML := oProcess:oHTML
                                             
oHtml:ValByName("EMPRESA", SM0->M0_NOME)
cFilDesc := ''
While TMPSE1->(!EOF())	
		dbSelectArea("SM0")
		dbSetOrder(1)
		if dbseek(cEmpAnt + TMPSE1->E1_FILIAL)
		   cFilDesc := upper(SM0->M0_FILIAL) + ' - '+ upper(SM0->M0_NOMECOM) 
		endif                 
  	AAdd((oHtml:ValByName("IT.FILIAL" )), TMPSE1->E1_FILIAL) 
  	AAdd((oHtml:ValByName("IT.FILDES" )), cFilDesc)                            
  	AAdd((oHtml:ValByName("IT.CODCLI" )), TMPSE1->E1_CLIENTE)    
  	AAdd((oHtml:ValByName("IT.LOJA" )),   TMPSE1->E1_LOJA)      
  	AAdd((oHtml:ValByName("IT.NOME" )),   TMPSE1->E1_NOMCLI)        	    	 
  	AAdd((oHtml:ValByName("IT.VALOR" )),  Transform(TMPSE1->E1_VALOR, "@E 9,999,999,999.99"))   			
	TMPSE1->(dbSkip())

EndDo

// Para enviar sempre para um 
oProcess:cTo  := AllTrim(SuperGetMV("MV_MAILCLI", ,''))
ConOut("Email enviado para para " + oProcess:cTo)
oProcess:cCC  := LOWER(cEmail)
// inicia o processo de envio de workflow
oProcess:Start()	

// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
oProcess:Finish()


TMPSE1->(dbCloseArea())
ConOut("Email enviado para " + AllTrim(cEmail))

RestArea(aArea)
RestArea(aAreaSM0)


Return