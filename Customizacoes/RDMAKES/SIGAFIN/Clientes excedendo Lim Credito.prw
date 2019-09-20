#include "rwmake.ch"
#include "topconn.ch"
/*/
// definir                                                                                                   	
+----------+----------+-------+-----------------------+------+----------+
|Programa  |WCLIEXLC  | Autor | DAYANE FILAKOSKI      | Data | 06/07/10 |
+----------+----------+-------+-----------------------+------+----------+
|EMPRESA   | CANTU RJU                                                  |
|Descricao | Relatorio Diário/mensal enviado por email com lista de     |
|          | clientes que estao excedendo limite de credito.            |
|          | O relatorio é enviado por email para o e-mail do interes-  |
|          | sado.                                                      |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu                                 |
+----------+------------------------------------------------------------+
/**************************************
 workflow que envia email informando do atraso na entrega do pedido de compras
 *************************************/
User Function WCliExLC()
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local aArea   := GetArea()
Local PLimCrt := U_GetConfEmp("ZU_PLIMCRE", 80)
Local nCount  := 0 

PLimCrt := PLimCrt/100       
CLimCrt := StrTran(Str(PLimCrt),',', '.')                                  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
Conout("Empresa atual: " + cEmpAnt)                           	
ConOut("Inicializando o processo")
conout("WF - WCliExLC - INICIO DO ENVIO DE EMAIL .... - ")
                                                                       
cQuery := "SELECT A1_COD, A1_LOJA, A1_NOME, A1_LC, A1_SALDUP, A1_SALPEDL "
cQuery += " FROM " + RetSqlName("SA1")
cQuery += " WHERE (A1_LC * " + CLimCrt + ") <= (A1_SALDUP + A1_SALPEDL) AND A1_LC < 500000 AND (A1_SALDUP + A1_SALPEDL) <> 0 and d_e_l_e_t_ <> '*' "
cQuery += " ORDER BY A1_NOME "

TCQUERY cQuery NEW ALIAS "TMPSA1"

// Busca o email da configuracao
cEmail  := Posicione("ZWF", 01, xFilial("ZWF") + "WCLIEXLC", "ZWF_EMAIL")
// trabalha com o arquivo de pedidos em aberto
dbSelectArea("TMPSA1")
oProcess := TWFProcess():New( "WCliExLC", "Clientes que estão excedendo limite de crédito")
oProcess:NewTask( "WCliDvDA", "\workflow\wcliexlc.html") // "\WORKFLOW\WPedComp.html" )

oProcess:cSubject :=  "Clientes que estão excedendo limite de crédito" 
						
oHTML := oProcess:oHTML
                                             
oHtml:ValByName("EMPRESA", SM0->M0_NOME)

While TMPSA1->(!EOF())	
	
  	AAdd((oHtml:ValByName("IT.COD" )), TMPSA1->A1_COD)     
  	AAdd((oHtml:ValByName("IT.LOJA" )), TMPSA1->A1_LOJA)      
 		AAdd((oHtml:ValByName("IT.NOME" )), TMPSA1->A1_NOME)        	 
  	AAdd((oHtml:ValByName("IT.LIMCRE" )), Transform(TMPSA1->A1_LC, '@E 9,999,999.99'))   			
  	AAdd((oHtml:ValByName("IT.SALTIT" )), Transform(TMPSA1->A1_SALDUP, '@E 9,999,999.99'))   			
  	AAdd((oHtml:ValByName("IT.SALPEL" )), Transform(TMPSA1->A1_SALPEDL, '@E 9,999,999.99'))   			
		TMPSA1->(dbSkip())
		nCount++
		            
		// Se passou de mil envia novo email
		if (nCount > 1000)
			oProcess:cTo  := AllTrim(SuperGetMV("MV_MAILCLI", ,''))
			ConOut("Email enviado para para " + oProcess:cTo)
			oProcess:cCC  := LOWER(cEmail)
			// inicia o processo de envio de workflow
			oProcess:Start()	
			
			// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
			oProcess:Finish()		
			
			oProcess := TWFProcess():New( "WCliExLC", "Clientes que estão excedendo limite de crédito")
			oProcess:NewTask( "WCliDvDA", "\workflow\wcliexlc.html") // "\WORKFLOW\WPedComp.html" )
			
			oProcess:cSubject :=  "Clientes que estão excedendo limite de crédito" 
									
			oHTML := oProcess:oHTML
			                                             
			oHtml:ValByName("EMPRESA", SM0->M0_NOME)
			nCount := 0
		EndIf

EndDo

// Para enviar sempre para um 
oProcess:cTo  := AllTrim(SuperGetMV("MV_MAILCLI", ,''))
ConOut("Email enviado para para " + oProcess:cTo)
oProcess:cCC  := LOWER(cEmail)
// inicia o processo de envio de workflow
oProcess:Start()	

// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
oProcess:Finish()


TMPSA1->(dbCloseArea())
ConOut("Email enviado para " + AllTrim(cEmail))

RestArea(aArea)


Return