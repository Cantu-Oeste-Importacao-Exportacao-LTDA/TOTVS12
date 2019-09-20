#include "rwmake.ch"
#include "topconn.ch"
/*/
// definir
+----------+----------+-------+-----------------------+------+----------+
|Programa  |WBLQCLDT  | Autor | DAYANE FILAKOSKI      | Data | 15/06/10 |
+----------+----------+-------+-----------------------+------+----------+
|EMPRESA   | CANTU RJU                                                  |
|Descricao | Relatorio Diário/Mensal enviado por email, com lista  de   |
|          | clientes que foram bloqueados por ultima data de compra.   |
|          | Esse relatorio é enviado por email, para os emails         |
|          | cadastrados na tabela ZWF.                                 |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu                                 |
+----------+------------------------------------------------------------+
/**************************************
 workflow que envia email informando do atraso na entrega do pedido de compras
 *************************************/
User Function WBlqClDt()
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local aArea   := GetArea()
Local nDiasBlq := SuperGetMV("MV_DIASBLQ", , 180)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
//RPCSetEnv("50","01","","","","",{"SC5","SA3"})

Conout("Empresa atual: " + cEmpAnt)                           	
ConOut("Inicializando o processo")
conout("WF - WBlqClDt - INICIO DO ENVIO DE EMAIL .... - ")
                                                                       
auxData := DDATABASE - nDiasBlq

// limitado a 500 registros apenas devido a dar erro quando existem muitas linhas.      

cQuery := "SELECT A1_COD, A1_LOJA, A1_NOME, A1_ULTCOM  "
cQuery += " FROM " + RetSqlName("SA1")
cQuery += " WHERE  A1_MSBLQL <> '1' AND A1_RISCO <> 'A' AND A1_ULTCOM < '" + DtoS(auxData)  + "' AND A1_ULTCOM <> ' ' AND d_e_l_e_t_ <> '*' "
cQuery += " ORDER BY A1_NOME "

TCQUERY cQuery NEW ALIAS "TMPSA1"

// Busca o email da configuracao
cEmail  := Posicione("ZWF", 01, xFilial("ZWF") + "WBLQCLDT", "ZWF_EMAIL")
// trabalha com o arquivo de pedidos em aberto
dbSelectArea("TMPSA1")
oProcess := TWFProcess():New( "WBlqClDt", "Clientes Bloqueados por Data")
oProcess:NewTask( "WBlqClDt", "\WORKFLOW\WBlqCliDt.html") // "\WORKFLOW\WPedComp.html" )

oProcess:cSubject :=  "Clientes Bloqueados por Data" //"Pedidos de compra em atraso em " + DTOC(DDATABASE-5) + " - Empresa " + SM0->M0_NOME
						
oHTML := oProcess:oHTML

oHtml:ValByName("EMPRESA", SM0->M0_NOME)

While TMPSA1->(!EOF())	
	
	// setar um campo do html,
//    Html:ValByName("<nome da variavel do html, aquela que esta entre %, ex %DATA%, use a variavel sempre em maiusculo", <valor que deseja setar, de qualter tipo, inteiro, string, data>)
	
	// laco para percorrer alguma coisa e adicionar as informacoes no html
	// necessariamente, itens que podem conter mais de um valor, como itens de pedido, devem
	// estar no html dentro de uma table ex abaixo:
	/*
	<table width="96%" border="0">
      <tr> 
        <td>%IT.VARIAVEL%</td>
        <td>%IT.VARIAVEL2%</td>
      </tr>
  </table>
	*/
  	AAdd((oHtml:ValByName("IT.COD" )), TMPSA1->A1_COD)     
  	AAdd((oHtml:ValByName("IT.LOJA" )), TMPSA1->A1_LOJA)      
 	AAdd((oHtml:ValByName("IT.NOME" )), TMPSA1->A1_NOME)        	 
  	AAdd((oHtml:ValByName("IT.ULTCOM" )), StoD(TMPSA1->A1_ULTCOM))   			
	TMPSA1->(dbSkip())

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

cSql := "update " + RetSqlName("SA1") + " set a1_msblql = '1', a1_risco = 'E', a1_observ = 'Bloqueado por data de compra' "
cSql += " where d_e_l_e_t_ <> '*' and a1_risco <> 'E' and a1_risco <> 'A' "
cSql += " A1_MSBLQL <> '1' AND A1_RISCO <> 'A' AND A1_ULTCOM < '" + DtoS(auxData)  + "' AND RTRIM(A1_ULTCOM) <> '' AND d_e_l_e_t_ <> '*' "
	
//TCSQLEXEC(cSql)






Return