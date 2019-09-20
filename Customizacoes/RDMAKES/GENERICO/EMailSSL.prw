#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


User Function MailSSL(cSubject, cBody, aAttach, cTo, cCC, lHtml)
Local oServer  := Nil
Local oMessage := Nil
Local nErr     := 0
Local cPopAddr  := "pop.gmail.com"      // Endereco do servidor POP3
Local cSMTPAddr := "smtp.gmail.com"     // Endereco do servidor SMTP
Local cPOPPort  := 995                    // Porta do servidor POP
Local cSMTPPort := 465                    // Porta do servidor SMTP
Local cUser     := "emailautomatico@cantu.com.br"     // Usuario que ira realizar a autenticacao
Local cPass     := "swordfish4077"             // Senha do usuario
Local nSMTPTime := 60                     // Timeout SMTP 
// Valores padrões caso não preenchido
Default cSubject := " "
Default cBody := " "
Default aAttach := {}
Default cTo := " "
Default cCC := " "     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Instancia um novo TMailManager
oServer := tMailManager():New()    
      
// Usa SSL na conexao
oServer:setUseSSL(.T.)
      
// Inicializa
oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)
      
// Define o Timeout SMTP
if oServer:SetSMTPTimeout(nSMTPTime) != 0
	Alert("[ERROR]Falha ao definir timeout")
  return .F.
endif
      
// Conecta ao servidor
nErr := oServer:smtpConnect()
if nErr <> 0
	Alert("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif
      
// Realiza autenticacao no servidor
nErr := oServer:smtpAuth(cUser, cPass)
if nErr <> 0
	Alert("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif
      
// Cria uma nova mensagem (TMailMessage)
oMessage := tMailMessage():new()
oMessage:clear()
oMessage:cFrom    := cUser
oMessage:cTo      := cTo
oMessage:cCC      := cCC
oMessage:cBCC     := ""
oMessage:cSubject := cSubject
oMessage:cBody := cBody
oMessage:cReplyTo := "helpdesk.ti@grupocantu.com.br"

if lHtml
	oMessage:MsgBodyType("text/html" )
EndIf

// Para solicitar confimação de envio
//oMessage:SetConfirmRead( .T. )
      
// Adiciona um anexo, nesse caso a imagem esta no root
For nX := 1 to len(aAttach)
	oMessage:AttachFile(aAttach[nX])
Next nX
      
      
// Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
// oMessage:AddAttHTag( 'Content-ID: <ID_siga.jpg>' )
      
// Envia a mensagem
nErr := oMessage:send(oServer)
if nErr <> 0
	Alert("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
	oServer:smtpDisconnect()
	return .F.
endif
      
// Disconecta do Servidor
oServer:smtpDisconnect()
Return .T.