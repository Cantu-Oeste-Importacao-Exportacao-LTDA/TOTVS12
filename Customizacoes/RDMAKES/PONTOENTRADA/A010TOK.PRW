/*
#include "protheus.ch"
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A010TOK   ºAutor  ³Roberto Rosin       º Data ³  27/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada que envia e-mail informando inclusão ou   º±±
±±º          ³ alteração em algum produto                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Envio de e-mail de inclusão ou alteração do produto        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
User Function A010TOK()             
/*
	/****WorkFlow de inclusão/alteração de produto****/
	//Roberto Rosin
	//24/08/2012
	//chamado 1196   
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
/*	U_USORWMAKE(ProcName(),FunName())
	
	//se estiver alterando, cahama a função que retorna o código HTML com as alterações.
	If altera
		cAlteracao := u_TbAlteraWF("SB1")
	EndIf
	
	enviaEmail()
Return .T.

Static function enviaEmail()
	cProcID    := iif(altera, "Alteração de Produto ", "Inclusão de novo Produto ")
	cAssunto   := iif(altera, "Aviso: Produto alterado ", "Aviso: novo Produto ")
	cInclualte := iif(altera, "ALTERACAO DE PRODUTO ", "INCLUSAO NOVO PRODUTO")
	cProcess   := OemToAnsi("000001") // Numero do Processo
	cStatus    := OemToAnsi("001000")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi(cProcID))
	oProcess:NewTask(cStatus,"\workflow\wfcadprod.htm")
	oProcess:cSubject := OemToAnsi(cAssunto + M->B1_DESC )
	
 	oProcess:cTo := GetMv('MV_X_PROD') //parametro criado no cfg -> atualizaçao-> cadastro ->paramentros
	oHtml:= oProcess:oHtml
    
	oHtml:ValByName( "INCLUALTE", cInclualte )
	oHtml:ValByName( "USUARIO",   cUsername )
	oHtml:ValByName( "CODDESC", M->B1_COD + ' - ' + M->B1_DESC)
	
*/	

	/*	
	if altera
		oHtml:ValByName( "ALTERACOES","Alterações: " + cAlteracao)
	endIf
	*/
/*
	oProcess:Start()
return

*/