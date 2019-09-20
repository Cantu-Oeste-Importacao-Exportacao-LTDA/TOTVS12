#include "Protheus.ch"
#include "topconn.ch"
#INCLUDE "XmlXFun.Ch"
#include "spednfe.ch"


/*/{Protheus.doc} myEMail
(Efetua leitura dos arquivos XML a partir de Email/pasta)

@author MarceloLauschner
@since 07/04/2012
@version 1.0

@param lConSefMan, logico, (Descrição do parâmetro)
@param lExecAuto, logico, (Descrição do parâmetro)
@param xCodEmp, variavel, (Descrição do parâmetro)
@param xCodFil, variavel, (Descrição do parâmetro)

@return Sem retorno

@example
(examples)

@see (links_or_references)
/*/
User Function myEMail(aParam) //lConSefMan,lExecAuto)
	//User Function myEMail(lConSefMan,lExecAuto,xCodEmp,xCodFil)
	
	Private	lRetGrv 		:= .F.
	Private	lSave			:= .F.
	Private	cFileSave		:= ""
	Private	cXmlSave		:= ""
	Private cArqAttAch		:= ""
	Private	cAttachName		:= ""
	Private	cAttXmlName		:= ""
	Private	aAttInfo		:= {}
	Private	cReadWf			:= ""
	Private	cText			:= ""
	Private	cMsgRetMail		:= ""
	Private	aSize 			:= MsAdvSize( .T., .F., 400 )		// Size da Dialog
	Private nAltura 		:= aSize[6]/2.2
	Private	nNumMsg 		:= 0
	Private	nTam    		:= 0
	Private	cChave 			:= ""
	Private lAutoExec		:= .F.
	Private	lSefMan			:= .F.
	Private	lIsDebug		:= .F.
	Private	lMadeira		:= .F.//SM0->M0_CGC $ "10490181000135#10490181000216"
	Default aParam			:= {.F./*lConSefMan*/,;
		.F./*lExecAuto*/,;
		cEmpAnt,;
		cFilAnt,;
		__cUserId} //  array com os parâmetros passados no agendamento + Código Grupo Empresa + Código Filial + Código Usuário + Id da tarefa.
	
	
	
	// Atribui variavel para uso na rotina
	// Melhoria em 27/04/2013 para permitir a baixa de emails via Job.
	lSefMan			:= aParam[1]
	lAutoExec		:= aParam[2]
	
	If IsBlind()
		lAutoExec	:= .T.
	Endif
	
	Private	cLeftNil		:= GetNewPar("XM_LEFTNIL","0")
	Private	cBarLinx		:= IIf(IsSrvUnix(),"/","\")
	Private	cDirNfe    		:= IIf(IsSrvUnix(),StrTran( GetNewPar("XM_DIRXML",cBarLinx+"nf-e"+cBarLinx),"\","/"),GetNewPar("XM_DIRXML",cBarLinx+"nf-e"+cBarLinx))	//	IIf(IsSrvUnix(),"/nf-e/", "\Nf-e\"))
	Private	cDirMailNfe 	:= cDirNfe + "mail" + cBarLinx	//	IIf(IsSrvUnix(),cDirNfe+"mail/", cDirNfe+"Mail\")
	Private cDirXmlOld		:= cDirNfe + "importados" + cBarLinx + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+cBarLinx	//	Iif(isSrvUnix(),cDirNfe+"importados/",cDirNfe+"Importados\")+DTOS(Date())+IIf(IsSrvUnix(),"/","\")
	Private	cDirSchema 		:= IIf(IsSrvUnix(),"/schemas/", "\schemas\")
	Private	cTipoDoc		:= "N"	// Variavel para identificar o tipo de Nota fiscal N=Normal;B=Beneficiamento;D=Devolução
	Private cRootPath		:= GetSrvProfString ("RootPath","\indefinido")
	// Atribui valor somente depois de existir a abertura de tabelas
	lMadeira		:= "10490181" == Substr(SM0->M0_CGC,1,8)
	
	MsgAlert("Entrei  ")
	If GetMv("XM_DIRPOP")
		sfRecMail()
		If GetNewPar("XM_DIRPOP1",.F.)
			sfRecDir()
		Endif
	ElseIf GetNewPar("XM_DIRPOP1",.F.)
		sfRecMail()
		sfRecDir()
	Else
		sfRecDir()
		If GetNewPar("XM_DIRPOP1",.F.)
			sfRecMail()
		Endif
	Endif
	
Return




/*
Static Function sfZipDir()
	
	cTipo    := "*.xml"
	
	
	If IsSrvUnix()
		aFiles   := Directory(cDirNfe+DTOS(Date()-7)+"/" + cTipo)
		MakeDir(cDirNfe+DTOS(Date())+"/")
	Else
		aFiles   := Directory(cDirNfe + cTipo)
	Endif
	
	nret := FZip(cDirNfe"\imagens.zip",aFiles)
	
	if nret!=0
		ConOut("Não foi possível criar o arquivo zip")
	Else
		ConOut("Arquivo zip criado com sucesso")
	Endif
	
	
Return
*/

/*/{Protheus.doc} sfRecMail
(long_description)
@author MarceloLauschner
@since 21/04/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfRecMail()
	
	Local	y
	Local	nI
	Local	a
	Local	cSubjectAux		:= ""
	Local	cBodyAux		:= ""
	Local	cToAux			:= ""
	Local	cAttInfo		:= ""
	
	Local	nRet1			:= MakeDir(cDirNfe)
	Local	nRet2 			:= MakeDir(cDirMailNfe)
	Local	nRet3,nRet4,nRet5
	Local	cCorpoM
	
	Private oServer
	Private	oMessage
	
	//Crio uma nova conexão, agora de POP
	oServer 	:= TMailManager():New()
	oMessage 	:= TMailMessage():New()
	// Usa SSL na conexao
	If GetMv("XM_POPSSL")
		oServer:setUseSSL(.T.)
	Endif
	
	
	oServer:Init( Alltrim(GetMv("XM_POP")),"", Alltrim(GetMv("XM_POPUSR"))	,Alltrim(GetMv("XM_PSWPOP")), GetMv("XM_POPPORT") ,0)
	
	If  Alltrim(GetNewPar("XM_TCPMAIL","POP3")) == "POP3"
		If oServer:SetPopTimeOut( 60 ) != 0
			Conout( "Falha ao setar o time out" )
			Return .F.
		EndIf
		
		If oServer:PopConnect() != 0
			Conout( "Falha ao conectar" )
			Return .F.
		EndIf
	Else
		
		If oServer:IMAPConnect() != 0
			Conout( "Falha ao conectar" )
			Alert("Falha ao conectar Imap")
			Return .F.
		Else
			//Alert("Conexão IMAP OK!")
		EndIf
	Endif
	
	//Recebo o número de mensagens do servidor
	oServer:GetNumMsgs( @nNumMsg )
	nTam := nNumMsg
	
	If nTam == 0
		If !lAutoExec
			MsgAlert("Não há e-mails a receber!")
		Endif
	Endif
	nContOk	:= 0
	// 14/03/2017 - Verifica se a quantidade e-mails é maior que o limite do parâmetro e seta limite
	If GetNewPar("XM_NRMAIL",nTam) < nTam
		nTam	:= GetNewPar("XM_NRMAIL",nTam) // Apesar de poder existir mais emails na caixa de Entrada, limito pelo parametro os emails para evitar sobre carga da rotina
	Endif
	
	MsgAlert("Entrei a ")
	
	// Só faço o controle de Semaforo
	If !stControle(.F.)
		Return
	Endif
	MsgAlert("Entrei b ")
	
	nRet5 := 0
	// Cria o Diretorio se precisar
	If !(ExistDir(cDirNfe + StrZero(Year(Date()),4)))
		nRet3	:= MakeDir(cDirNfe + StrZero(Year(Date()),4))
	Endif
	MsgAlert("Entrei e ")
	If !(ExistDir(cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) ))
		nRet4	:= MakeDir(cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) )
	Endif
	MsgAlert("Entrei f ")
	If !(ExistDir(cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)))
		nRet5	:= MakeDir(cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2))
		//cRootPath + cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+ cBarLinx + cAttXmlName
	Endif
	MsgAlert("Entrei g  ")
	If nRet5 <> 0
		If lAutoExec
			ConOut( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
		Else
			Aviso( "Não possível criar o diretório. "+ProcName(0)+"."+ Alltrim(Str(ProcLine(0))), + cValToChar( FError() ) + Chr(13)+;
				cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2), { "Ok" }, 2 )
		Endif
	Else
		//Aviso( "Diretório. "+ProcName(0)+"."+ Alltrim(Str(ProcLine(0))), + cValToChar( FError() ) + Chr(13)+;
			//	cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2), { "Ok" }, 2 )
	Endif
	
	ProcRegua(nTam)
	
	For nI := 1 To nTam
		MsgAlert("Entrei h1  ")
		IncProc("Recebendo email "+Alltrim(Str(nI)) + " / " + Alltrim(Str(nTam))+ ". Aguarde!" )
		//Limpo o objeto da mensagem
		oMessage:Clear()
		MsgAlert("Entrei h2  ")
		//Recebo a mensagem do servidor
		xRet := oMessage:Receive( oServer, nI )
		MsgAlert(xRet)
		cChave	:= " "
		
		MsgAlert("Entrei h3  ")
		
		
		// Declaro variavel para enviar retorno ou não
		cMsgRetMail	:= ""
		//Escrevo no server os dados do e-mail recebido
		
		
		nContOk++
		
		lRetGrv 	:= .T.
		lSave		:= .T.
		cFileSave	:= ""
		cXmlSave	:= ""
		cAttachName	:= ""
		cAttXmlName	:= ""
		
		For y := 1 to oMessage:getAttachCount()
			MsgAlert("Entrei i  ")
	
			aAttInfo:= oMessage:getAttachInfo(y)
			// Analisa se há informaçaõ de anexo e se o arquivo anexo é um XML
			//Estrutura de retorno:
			//  Nome				Descrição
			//1 ShortName			O nome do attachment.
			//2 Type				O tipo do anexo, por exemplo, text/plain ou image/x-png.
			//3 Disposition			Tipo do arquivo.
			//4 DispositionName		Nome do tipo de arquivo.
			//5 ID					Identificação do anexo.
			//6 Location			Local físico do anexo.
			//7 *Size Tamanho do anexo.* Parâmetro Size só estará disponível em versão superior a 7.00.131227A.
			
			cAttInfo	:= 	aAttInfo[1]
			//For iH := 1 To Len(aAttInfo)
			//	MsgAlert(aAttInfo[iH],cValToChar(iH))
			//Next
			// Se o ShortName estiver em branco procura pelo DispositionName
			If Empty(cAttInfo)
				cAttInfo	:= aAttInfo[4]
			Endif
			// Se o ShortName e DispositionName estiverem em branco procura pelo Type
			If Empty(cAttInfo)
				cAttInfo	:= SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			Endif
			
			If  At("XML",UPPER(cAttInfo)) > 0
				cAttXmlName	:= cAttInfo
				cAttXmlName	:= Lower(cAttXmlName)
				// Removendo letras invalidas para o nome do arquivo
				cAttXmlName	:= StrTran(cAttXmlName,"<","")
				cAttXmlName	:= StrTran(cAttXmlName,">","")
				cAttXmlName	:= StrTran(cAttXmlName,"-","")
				cAttXmlName	:= StrTran(cAttXmlName,"/","")
				cAttXmlName	:= StrTran(cAttXmlName,"\","")
				cAttXmlName	:= StrTran(cAttXmlName,"(","")
				cAttXmlName	:= StrTran(cAttXmlName,")","")
				cAttXmlName := StrTran(cAttXmlName,'"','')
				cAttXmlName := StrTran(cAttXmlName,"'","")
				cAttXmlName := StrTran(cAttXmlName,"=","")
				cAttXmlName := StrTran(cAttXmlName,"name=","")
				cAttXmlName := NoAcento(cAttXmlName)
				cAttachName	:= cAttXmlName
				MsgAlert("Entrei j ")
				//cXmlSave		:= cRootPath+cDirNfe+DTOS(Date())+IIf(IsSrvUnix(),"/","\")+cAttXmlName
				cXmlSave		:= cRootPath + cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+ cBarLinx + cAttXmlName
				cArqAttAch		:= cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+ cBarLinx + cAttXmlName
				MsgAlert("Entrei k " + cArqAttAch )
				
				lSave 			:= oMessage:SaveAttach(y,cXmlSave)
				//Alert(cRootPath+cDirNfe+cAttInfo)
				
				cText 		:= oMessage:getAttach(y)
				
				cTextAux	:= cText
				
				// Se o anexo contiver tag de arquivo xml
				//              Autorizado o uso da NF-e
				//				     <cStat>100</cStat><xMotivo>Autorizado
				//				<xMotivo>Autorizado o uso de NF-e
				//<cStat>100</cStat><xMotivo>Autorizado o uso de NF-e</
				//<cStat>100</cStat><xMotivo>Autorizado o uso de NF-e
				If lSave
					//Aviso("Leitura do XML - Emailmar!",cText,{"Ok"},3)
					lRetGrv	:= .F.
					cTextAux	:= Upper(cTextAux)
					cTextAux	:= StrTran(cTextAux, Chr(13)+ Chr(10),"")
					cTextAux	:= StrTran(cTextAux, Chr(10),"")
					
					// Verifica se é nota fiscal eletronica
					// Validação simplificada
					If At("<NFEPROC",cTextAux) > 0 .And. ((At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or. At("<CSTAT>100</CSTAT>",cTextAux) > 0) .Or. (At('<UF>EX</UF>',cTextAux) > 0) .And. At('<CNPJ>'+ SM0->M0_CGC+ '</CNPJ>',cTextAux) > 0)
						//Aviso("Entrou para Gravar Xml NFe!",cTextAux,{"Ok"},3)
						Begin Transaction
							lRetGrv := sfGrvXmlNfe(cText,.T.,oMessage,oServer)
						End Transaction
					Endif
					// Efetua tentativa de verificar se é CTE
					If !lRetGrv
						If At("<CTE",cTextAux) > 0 .And.;
								((At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or. At("<CSTAT>100</CSTAT>",cTextAux) > 0))
							//MsgAlert("Entrou para gravar sfgrvxmlcte "+cText,"154")
							Begin Transaction
								lRetGrv := sfGrvXmlCte(cText,.T.,oMessage,oServer)
							End Transaction
						Endif
					Endif
					// Efetua tentativa de verificar se é CCe
					If !lRetGrv
						If At("<TPEVENTO>110110</TPEVENTO>",Upper(cTextAux)) > 0
							//MsgAlert("Entrou para gravar sfgrvxmlcce "+cText,"161")
							Begin Transaction
								lRetGrv := sfGrvCCe(cText,.T.,oMessage,oServer)
							End Transaction
							If !lRetGrv
								cMsgRetMail	+= "Não validou CCe '" + cText +"'"
							Endif
						Endif
					Endif
					
					// Efetua tentativa de verificar se é um evento de cancelamento de NFe/Cte
					If !lRetGrv
						If (	At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or.;
								At("<DESCEVENTO>CANCELAMENTO</DESCEVENTO>",cTextAux) > 0)
							//MsgAlert("Entrou para gravar sfgrvxmlcce "+cText,"161")
							Begin Transaction
								lRetGrv := sfGrvCanc(cText,.T.,oMessage,oServer)
							End Transaction
							If !lRetGrv
								cMsgRetMail	+= "Não validou evento de cancelamento '" + cText +"'"
							Endif
						Endif
					Endif
				ElseIf !Empty(cText)
					StaticCall(	XMLDCONDOR,;
						stSendMail,;
						GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Erro ao gravar o arquivo'"+cXmlSave+"'" ,'"'+cText+'"')
				Endif
				
				// 07/10/2016 - Melhoria que apaga os XMLs gravados e importados com sucesso para o Banco de Dados.
				If !GetNewPar("XM_CPYXMLD",.T.) .And. lRetGrv .And. Empty(cMsgRetMail)
					// Apago o arquivo
					Ferase(cArqAttAch)
				Endif
				// Adicionado em 21/10/2012 para permitir a opção de salvar o pdf também no rootpath
			ElseIf GetNewPar("XM_SAVEPDF",.F.) .And. At(".PDF",UPPER(cAttInfo)) > 0
				If Len(aAttInfo) >= 7
					// http://tdn.totvs.com/pages/viewpage.action?pageId=161349793
					// Somente arquivos PDF com tamanho inferior ao limite de string serão lidos
					If aAttInfo[7] < 1048576
						cAttachName	:= cAttInfo
						//cFileSave		:= cRootPath+cDirNfe+DTOS(Date())+IIf(IsSrvUnix(),"/","\")+cAttachName
						cFileSave		:= cRootPath + cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+ cBarLinx + cAttXmlName
						oMessage:SaveAttach(y,cFileSave)
					Endif
				Else
					cAttachName	:= cAttInfo
					//cFileSave		:= cRootPath+cDirNfe+DTOS(Date())+IIf(IsSrvUnix(),"/","\")+cAttachName
					cFileSave		:= cRootPath + cDirNfe + StrZero(Year(Date()),4) + cBarLinx + StrZero(Month(Date()),2) + cBarLinx + StrZero(Day(Date()),2)+ cBarLinx + cAttXmlName
					oMessage:SaveAttach(y,cFileSave)
				Endif
			Endif
		Next y
		
		cBodyAux		:= oMessage:cBody
		cSubjectAux		:= oMessage:cSubject
		cToAux			:= oMessage:cTo
		
		oServer:DeleteMsg( nI )
		
		
		If !lRetGrv .And. !Empty(cMsgRetMail)
			
			
			//Crio a conexão com o server SMTP ( Envio de e-mail )
			oServer2 := TMailManager():New()
			
			// Usa SSL na conexao
			If GetMv("XM_SMTPSSL")
				oServer2:setUseSSL(.T.)
			Endif
			
			// Usa TLS na conexao
			If GetNewPar("XM_SMTPTLS",.F.)
				oServer2:SetUseTLS(.T.)
			Endif
			
			oServer2:Init( ""		,Alltrim(GetMv("XM_SMTP")), Alltrim(GetMv("XM_SMTPUSR"))	,Alltrim(GetMv("XM_PSWSMTP")),	0			, GetMv("XM_SMTPPOR") )
			
			//seto um tempo de time out com servidor de 1min
			If oServer2:SetSmtpTimeOut( GetMv("XM_SMTPTMT") ) != 0
				Conout( "Falha ao setar o time out" )
			EndIf
			
			//realizo a conexão SMTP
			If oServer2:SmtpConnect() != 0
				Conout( "Falha ao conectar" )
			EndIf
			
			// Realiza autenticacao no servidor
			If GetMv("XM_SMTPAUT")
				nErr := oServer2:smtpAuth(Alltrim(GetMv("XM_SMTPUSR")), Alltrim(GetMv("XM_PSWSMTP")))
				If nErr <> 0
					ConOut("[ERROR]Falha ao autenticar: " + oServer2:getErrorString(nErr))
					Alert("[ERROR]Falha ao autenticar: " + oServer2:getErrorString(nErr))
					oServer2:smtpDisconnect()
				Endif
			Endif
			//Apos a conexão, crio o objeto da mensagem
			oMessage2 := TMailMessage():New()
			//Limpo o objeto
			//Populo com os dados de envio
			oMessage2:cFrom 		:= GetMv("XM_SMTPDES")
			oMessage2:cTo 			:= GetNewPar("XM_MAILADM","marcelolauschner@gmail.com")
			// Efetua tratativa para avisar outros destinatários do email de que o email foi rejeitado
			//cCcEmail	:= StrTran(StrTran(cToAux,Alltrim(GetMv("XM_POPUSR")),""),";;",";")
			
			//If !Empty(Alltrim(cCcEmail))
			//	oMessage2:cCc 			:= cCcEmail
			//Endif
			If Type("lMadeira") == "L" .And. !lMadeira
				oMessage2:cBcc 		:= "contato@centralxml.com.br"
			Endif
			oMessage2:cSubject 		:= OemToAnsi("Resposta automática de rejeição do Email-> "+ cSubjectAux )
			
			cCorpoM	:= ""
			cCorpoM += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'> "
			cCorpoM += "<html xmlns='www.w3.org/1999/xhtml'> "
			cCorpoM += "<head> "
			cCorpoM += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /> "
			cCorpoM += "<style type='text/css'> "
			cCorpoM += "<!-- "
			cCorpoM += "body,td,th { "
			cCorpoM += "	font-family: Arial, Helvetica, sans-serif; "
			cCorpoM += "	font-size: 12pt; "
			cCorpoM += "} "
			cCorpoM += "--> "
			cCorpoM += "</style></head> "
			cCorpoM += "<body> "
			cCorpoM += "<br><br>"
			cCorpoM += AllTrim(OemToAnsi(cMsgRetMail)+ "<br><br>" + OemToAnsi(cBodyAux))
			cCorpoM += "<br>"
			cCorpoM += "<br>"
			cCorpoM += "Este email é disparado automaticamente pela rotina Central XML - Favor não Responder."
			cCorpoM += "<br>"
			cCorpoM += "________________________________________________________________________"
			cCorpoM += "<br>"
			
			
			cCorpoM += "Powered by Central XML. - " +"Versão : " + GetNewPar("XM_CTRLVRS","Central XML - 4.2017D-10A")
			cCorpoM += "</body> "
			cCorpoM += "</html>"
			
			oMessage2:MsgBodyType( "text/html" )
			oMessage2:cBody 		:= cCorpoM //OemToAnsi("Email de resposta automática. Não foi possível ler o XML de seu e-mail enviado." + Chr(13)+Chr(10)+cMsgRetMail+ Chr(13)+Chr(10)+cBodyAux + Chr(13)+Chr(10)+"'"+cText+"'")
			
			//Adiciono um attach
			If oMessage2:AttachFile( cArqAttAch) < 0
				Conout( "Erro ao atachar o arquivo " + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))) )
				//	MsgAlert("Não foi possível anexar o arquivo.","Erro" )
			Else
				//adiciono uma tag informando que é um attach e o nome do arq
				oMessage2:AddAtthTag( 'Content-Disposition: attachment; filename='+Alltrim(cAttachName))
			EndIf
			
			//Envio o e-mail
			If oMessage2:Send( oServer2 ) != 0
				Conout( "Erro ao enviar o e-mail " + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))) )
			EndIf
			
			//Disconecto do servidor
			If oServer2:SmtpDisconnect() != 0
				Conout( "Erro ao disconectar do servidor SMTP " + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))) )
			EndIf
			
			FreeObj(oServer2)
			fErase(cArqAttAch)
			
			
		Endif
		
		
		
	Next nI
	
	// Libera o controle
	stControle(.T.)
	
	
	If  Alltrim(GetNewPar("XM_TCPMAIL","POP3")) == "POP3"
		//Diconecto do servidor POP
		oServer:POPDisconnect()
	Else
		//Diconecto do servidor IMAP
		oServer:IMAPDisconnect()
	Endif
	
Return

/*/{Protheus.doc} sfRecDir
(long_description)
@author MarceloLauschner
@since 01/11/2014
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfRecDir()
	
	Local	cDirImpXml	:= Alltrim(GetNewPar("XM_DIRMAPD",cDirNfe))
	Local	aFiles
	Local	nForA
	Local	cCorpoM
	
	If Empty(cDirImpXml)
		cDirImpXml	:= Alltrim(cDirNfe)
	Endif
	
	// Só faço o controle
	If !stControle(.F.)
		Return
	Endif
	cTipo    := "*.xml"
	aFiles   := Directory( cDirImpXml + cTipo)
	
	If Len(aFiles) <= 0
		If !lAutoExec
			MsgAlert("Não há arquivos no diretório '" + cDirImpXml + cTipo + "' ",ProcName(0)+"."+ Alltrim(Str(ProcLine(0))) )
		Endif
		// 08/03/2017
		// Se não encontrou arquivos no diretório mapeado - procura na pasta padrão \protheus_data\nf-e\
		cDirImpXml	:= Alltrim(cDirNfe)
		aFiles   := Directory( cDirImpXml + cTipo)
	Endif
	
	//Incluindo criação de diretório - Old -> MakeDir(cDirXmlOld)
	If !(ExistDir(cDirNfe + "importados"))
		MakeDir(cDirNfe + "importados")
	Endif
	
	If !(ExistDir(cDirNfe + "importados" + cBarLinx +StrZero(Year(Date()),4)))
		MakeDir(cDirNfe + "importados" + cBarLinx + StrZero(Year(Date()),4))
	Endif
	
	If !(ExistDir(cDirNfe + "importados" + cBarLinx + StrZero(Year(Date()),4)+ cBarLinx + StrZero(Month(Date()),2) ))
		MakeDir(cDirNfe + "importados" + cBarLinx + StrZero(Year(Date()),4)+ cBarLinx + StrZero(Month(Date()),2) )
	Endif
	
	If Len(aFiles) > 0 //Verifica/Cria apenas se for importar arquivo
		If !(ExistDir(cDirXmlOld)) .And. GetNewPar("XM_CPYXMLD",.T.)
			MakeDir(cDirXmlOld)
		Endif
	Endif
	
	ProcRegua(Len(aFiles))
	
	For nForA := 1 To Len(aFiles)
		IncProc("Processando XML "+Alltrim(Str(nForA)) + " / " + Alltrim(Str(Len(aFiles)))+ ". Aguarde!" )
		
		cFile	:= Alltrim( cDirImpXml + aFiles[nForA][1])
		If !File(cFile)
			If !lAutoExec
				MsgAlert("Arquivo xml inexistente!!"+ cFile,"Atenção")
			Endif
		Else
			cAttachName		:= ""
			cArqAttAch		:= ""
			
			
			cMsgRetMail	:= ""
			// Abro o Arquivo
			nHdl    := fOpen(cFile)
			// Se foi possível abrir
			If nHdl <> -1
				// Leitura do Arquivo atribuindo o texto do xml a variavel cbuffer
				nTamFile := fSeek(nHdl,0,2)
				If nTamFile > 65535*8
					If !lAutoExec
						MsgAlert("Tamanho do arquivo '" + cFile + "' estourou limite de 524.280 caracteres. Número de Bytes " + cValToChar(nTamFile),ProcName(0)+"."+ Alltrim(Str(ProcLine(0))) )
					Endif
					cMsgRetMail	+= "Tamanho do arquivo '" + cFile + "' estourou limite de 524.280 caracteres"
				Else
					fSeek(nHdl,0,0)
					cBuffer  := Space(nTamFile)
					nBtLidos := fRead(nHdl,@cBuffer,nTamFile)
					fClose(nHdl)
					// Gravo o Xml nas tabelas
					//If !sfGrvXmlNfe(cBuffer,.F.)
					//	lRetGrv := sfGrvXmlCte(cBuffer,.F.)
					//Endif
					cTextAux	:= cBuffer
					cTextAux	:= Upper(cTextAux)
					cTextAux	:= StrTran(cTextAux, Chr(13)+ Chr(10),"")
					cTextAux	:= StrTran(cTextAux, Chr(10),"")
					
					If (At("<NFEPROC",cTextAux) > 0 .And. (At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or. At("<CSTAT>100</CSTAT>",cTextAux) > 0 )) .Or. (At('<UF>EX</UF>',cTextAux) > 0 .And. At('<CNPJ>'+ SM0->M0_CGC+ '</CNPJ>',cTextAux) > 0)
						//Aviso("Entrou para Gravar Xml NFe!",cTextAux,{"Ok"},3)
						Begin Transaction
							lRetGrv := sfGrvXmlNfe(cBuffer,.F.)
						End Transaction
					Endif
					
					// Efetua tentativa de verificar se é CTE
					If At("<CTE",cTextAux) > 0 .And.(At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or. At("<CSTAT>100</CSTAT>",cTextAux) > 0)
						//MsgAlert("Entrou para gravar sfgrvxmlcte "+cText,"154")
						Begin Transaction
							lRetGrv := sfGrvXmlCte(cBuffer,.F.)
						End Transaction
					Endif
					
					
					// Efetua tentativa de verificar se é CCe
					If At("<DESCEVENTO>CARTA DE CORRECAO</DESCEVENTO>",Upper(cTextAux)) > 0
						//MsgAlert("Entrou para gravar sfgrvxmlcce "+cText,"161")
						Begin Transaction
							lRetGrv := sfGrvCCe(cBuffer,.F.)
						End Transaction
						If !lRetGrv
							cMsgRetMail	+= "Não validou CCe '" + cBuffer +"'"
						Endif
					Endif
					
					
					// Efetua tentativa de verificar se é um evento de cancelamento de NFe/Cte
					If !lRetGrv
						If (	At("<CSTAT>101</CSTAT>",cTextAux) > 0 .Or.;
								At("<DESCEVENTO>CANCELAMENTO</DESCEVENTO>",cTextAux) > 0)
							//MsgAlert("Entrou para gravar sfgrvxmlcce "+cText,"161")
							Begin Transaction
								lRetGrv := sfGrvCanc(cBuffer,.F.)
							End Transaction
							If !lRetGrv
								cMsgRetMail	+= "Não validou evento de cancelamento '" + cBuffer +"'"
							Endif
						Endif
					Endif
				Endif
				If !Empty(cMsgRetMail)
					//Crio a conexão com o server STMP ( Envio de e-mail )
					oServer2 := TMailManager():New()
					
					
					// Usa SSL na conexao
					If GetMv("XM_SMTPSSL")
						oServer2:setUseSSL(.T.)
					Endif
					
					// Usa TLS na conexao
					If GetNewPar("XM_SMTPTLS",.F.)
						oServer2:SetUseTLS(.T.)
					Endif
					
					oServer2:Init( ""		,Alltrim(GetMv("XM_SMTP")), Alltrim(GetMv("XM_SMTPUSR"))	,Alltrim(GetMv("XM_PSWSMTP")),	0			, GetMv("XM_SMTPPOR") )
					
					//seto um tempo de time out com servidor de 1min
					If oServer2:SetSmtpTimeOut( GetMv("XM_SMTPTMT") ) != 0
						Conout( "Falha ao setar o time out" )
					EndIf
					
					//realizo a conexão SMTP
					If oServer2:SmtpConnect() != 0
						Conout( "Falha ao conectar" )
					EndIf
					
					// Realiza autenticacao no servidor
					If GetMv("XM_SMTPAUT")
						nErr := oServer2:smtpAuth(Alltrim(GetMv("XM_SMTPUSR")), Alltrim(GetMv("XM_PSWSMTP")))
						If nErr <> 0
							ConOut("[ERROR]Falha ao autenticar: " + oServer2:getErrorString(nErr))
							Alert("[ERROR]Falha ao autenticar: " + oServer2:getErrorString(nErr))
							oServer2:smtpDisconnect()
						Endif
					Endif
					//Apos a conexão, crio o objeto da mensagem
					oMessage2 := TMailMessage():New()
					//Limpo o objeto
					//Populo com os dados de envio
					oMessage2:cFrom 		:= GetMv("XM_SMTPDES")
					oMessage2:cTo 			:= GetNewPar("XM_MAILADM","marcelolauschner@gmail.com")//oMessage:cFrom
					
					oMessage2:cSubject 		:= OemToAnsi("Resposta automática de rejeição do Email")
					//						oMessage2:MsgBodyType( "text" )
					// Efetua tratativa para avisar outros destinatários do email de que o email foi rejeitado
					//cCcEmail	:= StrTran(StrTran(cToAux,Alltrim(GetMv("XM_POPUSR")),""),";;",";")
					
					//If !Empty(Alltrim(cCcEmail))
					//	oMessage2:cCc 			:= cCcEmail
					//Endif
					If Type("lMadeira") == "L" .And. !lMadeira
						oMessage2:cBcc 		:= "contato@centralxml.com.br"
					Endif
					oMessage2:cSubject 		:= OemToAnsi("Resposta automática de rejeição do Email"  )
					
					cCorpoM	:= ""
					cCorpoM += "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'> "
					cCorpoM += "<html xmlns='www.w3.org/1999/xhtml'> "
					cCorpoM += "<head> "
					cCorpoM += "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /> "
					cCorpoM += "<style type='text/css'> "
					cCorpoM += "<!-- "
					cCorpoM += "body,td,th { "
					cCorpoM += "	font-family: Arial, Helvetica, sans-serif; "
					cCorpoM += "	font-size: 12pt; "
					cCorpoM += "} "
					cCorpoM += "--> "
					cCorpoM += "</style></head> "
					cCorpoM += "<body> "
					cCorpoM += "<br><br>"
					cCorpoM += AllTrim(OemToAnsi(cMsgRetMail))
					cCorpoM += "<br>"
					cCorpoM += "<br>"
					cCorpoM += "Este email é disparado automaticamente pela rotina Central XML - Favor não Responder."
					cCorpoM += "<br>"
					cCorpoM += "________________________________________________________________________"
					cCorpoM += "<br>"
					
					
					cCorpoM += "Powered by Central XML. - " +"Versão : " + GetNewPar("XM_CTRLVRS","Central XML - 4.2017D-10A")
					cCorpoM += "</body> "
					cCorpoM += "</html>"
					
					oMessage2:MsgBodyType( "text/html" )
					oMessage2:cBody 		:= cCorpoM //OemToAnsi("Email de resposta automática. Não foi possível ler o XML de seu e-mail enviado." + Chr(13)+Chr(10)+cMsgRetMail+ Chr(13)+Chr(10)+cBodyAux + Chr(13)+Chr(10)+"'"+cText+"'")
					
					
					//Adiciono um attach
					If oMessage2:AttachFile( cFile) < 0
						Conout( "Erro ao atachar o arquivo" )
						MsgAlert("Não foi possível anexar o arquivo '" + cFile + "'",ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" Erro ao anexar arquivo.")
					Else
						//adiciono uma tag informando que é um attach e o nome do arq
						oMessage2:AddAtthTag( 'Content-Disposition: attachment; filename='+Alltrim(aFiles[nForA][1])+"'")
					EndIf
					
					//Envio o e-mail
					If oMessage2:Send( oServer2 ) != 0
						Conout( "Erro ao enviar o e-mail" )
					EndIf
					
					//Disconecto do servidor
					If oServer2:SmtpDisconnect() != 0
						Conout( "Erro ao disconectar do servidor SMTP" )
					EndIf
				Endif
				If GetNewPar("XM_CPYXMLD",.T.)
					__CopyFile(cFile,cDirXmlOld + aFiles[nForA][1])
				Endif
				// Apago o arquivo
				Ferase(cFile)
			Endif
		Endif
	Next nForA
	
	stControle(.T.)
	
Return




/*/{Protheus.doc} sfGrvXmlNfe
(Trata o XML para efetuar a gravação de NFE(Mod.55) )

@author MarceloLauschner
@since 07/04/2012
@version 1.0

@param cText, character, (Descrição do parâmetro)
@param lMail, logico, (Descrição do parâmetro)
@param oMessage, objeto, (Descrição do parâmetro)
@param oServer, objeto, (Descrição do parâmetro)

@return logico, se gravou o Xml da NFe

@example
(examples)

@see (links_or_references)
/*/
Static Function sfGrvXmlNfe(cText,lMail,oMessage,oServer)
	
	Local	cTxtGrv		:= cText
	Local	cVldSch		:= cText
	Local	lRej101		:= .F.
	Local	cAviso		:= ""
	Local	cErro		:= ""
	Local	cFileGr		:= ""
	Local	lAcept  	:= .F.
	Local 	cNumProt	:= ""
	Local	cParcela	:= " "
	Local   nForA,nForB,nForC,nForD
	Private oIdent   ,oEmitente,oDestino 
	//Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cText,{"Ok"},3)
	
	ConOut("+"+Replicate("-",58)+"+")
	ConOut(Padr("| Recebimento de XML - NFe - Função MYEMAIL ",59)+"|")
	ConOut(Padr("| Inicio: "+Time(),59)+"|")
	
	If lIsDebug
		Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cText,{"Ok"},3)
	Endif
	// <nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe Id=
	//<nfeProc versao="2.00" xmlns="http://www.portalfiscal.inf.br/nfe"><NFe><infNFe Id=
	// Se encontrada apenas a tag <NFe> adiciona Atributo
	// Solução adicionada em 21/03/12 para resolver problema de validação de Schema do Microsiga
	If ( nPosIni := At("<NFe>",cVldSch)) > 0
		//<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe
		cVldSch := '<NFe xmlns="http://www.portalfiscal.inf.br/nfe">'+Substr(cVldSch,nPosINi+5)
		
		// Faz o ajuste do XML também para evitar erro de xml parser
		cTxtGrv := Substr(cTxtGrv,1,nPosIni-1)+cVldSch
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"Schema ajustado - sfGrvXmlNfe 002!",cVldSch,{"Ok"},3)
		Endif
	Endif
	
	If ( nPosIni := At("<NFe",cVldSch)) > 0
		//<NFe xmlns="http://www.portalfiscal.inf.br/nfe"><infNFe
		cVldSch := Substr(cVldSch,nPosINi)
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cVldSch,{"Ok"},3)
		Endif
	Endif
	If ( nPosIni := At("</infNFe>",cVldSch)) > 0
		cVldSch := Substr(cVldSch,1,nPosINi+8)
		cVldSch += "</NFe>"
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cVldSch,{"Ok"},3)
		Endif
	Endif
	
	// Avalia necessita de retirar caracteres
	cVldSch 	:= sfRemoveCrlf(cVldSch)
	cText		:= sfRemoveCrlf(cText)
	
	cAviso	:= ""
	cErro	:= ""
	oNfe 	:= XmlParser(cText,"_",@cAviso,@cErro)
	
	If !Empty(cErro)
		cMsgRetMail	+= "Erro de XmlParser - '"+cErro+"' "
		ConOut(Padr("| Erro de XmlParser - '"+cErro+"'",59)+"|")
		ConOut("+"+Replicate("-",58)+"+")
		Return .F.
	Endif
	
	
	If !Empty(cAviso) .Or.;
			(Type("oNFe:_NfeProc:_nfeProc:_NFe") == "U" .And. Type("oNFe:_InfNfe")== "U" .And. Type("oNFe:_NfeProc:_NFe")== "U" .And. Type("oNFe:_NFe")== "U") //.Or. At("UTF-8",Upper(cTxtGrv)) == 0
		//( cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName )
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml " + IIf(!Empty(cAviso)," aviso="+cAviso,"forçou ajuste UTF-8") ,;
			cText,;//'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		
		cErro		:= ""
		cAviso		:= ""
		cTxtGrv		:= sfDecodeUtf(cTxtGrv)
		cTxtGrv		:= sfRemoveCrlf(cTxtGrv)
		
		If At("UTF-8",Upper(cTxtGrv)) > 0
			//cTxtGrv := sfHTMLEnc(cTxtGrv)
		Endif
		cTxtGrv 	:= NoAcento(cTxtGrv)
		cTxtAux   	:= EnCodeUtf8(cTxtGrv)
		If Type("cTxtAux") <> "U"
			cTxtGrv	:= EnCodeUtf8(cTxtGrv)
		Endif
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"EncodeUtf8",cTxtGrv,{"Ok"},3)
		Endif
		
		oNfe := XmlParser(cTxtGrv,"_",@cAviso,@cErro)
		
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"XmlParser - sfGrvXmlNfe 005!",cTxtGrv,{"Ok"},3)
		Endif
		
		If !Empty(cErro)
			MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml")
			cMsgRetMail	+= "Erro XmlParser '"+cErro+"' "
			//StaticCall(XMLDCONDOR,stSendMail,GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - "+cErro ,'"'+cTxtGrv+'"')
			ConOut(Padr("| Erro de XmlParser - '"+cErro+"'",59)+"|")
			ConOut("+"+Replicate("-",58)+"+")
			Return .F.
		Endif
		
		If !Empty(cAviso)
			
			//Static Function stSendMail( cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName )
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml Aviso: "+ cAviso,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
		Endif
		
		cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(sfDecodeUtf(cVldSch),.T.)))
		
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"Schema ajustado - sfGrvXmlNfe 006!",cVldSch,{"Ok"},3)
		Endif
	Endif
	
	If File(cDirSchema+"nfe_v"+NfeIdSPED(cVldSch,"versao")+".xsd")
		//Aviso("Xml",Alltrim(EnCodeUtf8(NoAcento(sfDecodeUtf(cVldSch)))),{"Xml"},3           )
		//cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(sfDecodeUtf(cVldSch),.T.)))
		cVldSch		:= sfDecodeUtf(cVldSch)
		cVldSch 	:= NoAcento(cVldSch,.T.)
		cTxtAux   	:= EnCodeUtf8(cVldSch)
		If Type("cTxtAux") <> "U"
			cVldSch	:= EnCodeUtf8(cVldSch)
		Endif
		
		If lIsDebug
			Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cVldSch,{"Ok"},3)
		Endif
		cErro		:= ""
		cAviso		:= ""
		
		If 	At('<UF>EX</UF>',Upper(cText)) == 0 .And. !XmlSVldSchema( cVldSch, cDirSchema+"nfe_v"+NfeIdSPED(cVldSch,"versao")+".xsd", @cErro, @cAviso )
			
			//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml")
			
			// Adicionada exceção que permite importar XML´s de Sistema de Importação que Gera XML no Layout da NF-e porém sem ser autorizada e nem ter CHAVE
			If At('<UF>EX</UF>',Upper(cText)) == 0
				cNavegado	:= "http://www.sefaz.rs.gov.br/NFE/NFE-VAL.aspx"
				
				If !lAutoExec
					Aviso("XML com Schema Inválido! Copie o Texto abaixo e cole na próxima tela!",cText,{"Ok"},3)
					//Aviso("XML com Schema Inválido! Copie o Texto abaixo e cole na próxima tela!",cVldSch,{"Ok"},3)
					
					Define MsDialog oDlgWb1 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser"
					@ 005,010 Say "Xml" of oDlgWb1 Pixel
					@ 015,010 MsGet oNavegado Var cNavegado Size 300,05 Of oDlgWb1 Pixel
					oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb1 )
					
					// parametro que permite o aceite de xml fora do schema xsd
					If GetNewPar("XM_VLSCHFC",.T.)
						@ 010, 440 Button oBtnSair PROMPT "Aceitar" Size 40,10 Action(lAcept  := .T.,oDlgWb1:End()) Of oDlgWb1 Pixel
					Endif
					
					@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb1:End()) Of oDlgWb1 Pixel
					
					Activate MsDialog oDlgWb1 Centered
					
					oDlgWb1 := Nil
				Else
					lAcept	:= GetNewPar("XM_VLSCHFC",.T.)
				Endif
				
				cMsgRetMail	+= "Schema inválido do XML Aviso:'"+cAviso+"' - Erro :'"+cErro+"' "
				
				If !lAcept
					ConOut(Padr("| Schema inválido - '"+cAviso+"-"+cErro+"'",59)+"|")
					ConOut("+"+Replicate("-",58)+"+")
					Return .F.
				Endif
				
			Else
				If !lAutoExec
					If At('<UF>EX</UF>',Upper(cText)) > 0
						Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"Nota com UF=Exterior",cText,{"Ok"},3)
					Else
						Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"XML sem ID da Chave !",cText,{"Ok"},3)
					Endif
				Endif
			Endif
		Else
			//Aviso("XML com Schema Validado!",cText,{"Ok"},3)
		Endif
	Endif
	
	
	If Type("oNFe:_NfeProc:_NFe") <> "U"
		oNF := oNFe:_NFeProc:_NFe
	ElseIf Type("oNFe:_nfeProc:_NFe") <> "U"
		oNF := oNFe:_nFeProc:_NFe
	ElseIf Type("oNFe:_NFe")<> "U"
		oNF := oNFe:_NFe
	ElseIf Type("oNFe:_InfNfe")<> "U"
		oNF := oNFe
	ElseIf Type("oNFe:_NfeProc:_nfeProc:_NFe") <> "U"
		oNF := oNFe:_nfeProc:_NFeProc:_NFe
	ElseIf Type("oNFe")<> "U"
		oNF := oNFe
	Else
		//MsgAlert("Não foi possível importar email do texto: "+cTxtGrv)
		//StaticCall(XMLDCONDOR,stSendMail,GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de oNFe " ,'"'+cTxtGrv+'"')
		cMsgRetMail	+= "Importação XML - Erro de oNFe "
		//Aviso("Erro de oNFe cText",cText,{"Ok"},3)
		//	Aviso("Erro de oNFe cTxtGrv",cTxtGrv,{"Ok"},3)
		
		ConOut(Padr("| Erro de oNfe - '"+cErro+"'",59)+"|")
		ConOut("+"+Replicate("-",58)+"+")
		Return .F.
	Endif
	
	
	oIdent     	:= oNF:_InfNfe:_IDE
	oEmitente  	:= oNF:_InfNfe:_Emit
	oDestino   	:= oNF:_InfNfe:_Dest
	
	// Procura a chave conforme o escopo da formatação do xml
	If Type("oNFe:_NfeProc:_protNFe") <> "U"
		cChave := oNFe:_NFeProc:_protNFe:_infProt:_chNFe:TEXT
	ElseIf Type("oNFe:_protNFe")<> "U"
		cChave := oNFe:_protNFe:_infProt:_chNFe:TEXT
	ElseIf Type("oNFe:_NfeProc:_nfeProc:_protNFe") <> "U"
		cChave := oNFe:_nfeProc:_NFeProc:_protNFe:_infProt:_chNFe:TEXT
	Else
		cChave	:= oEmitente:_CNPJ:TEXT+Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nNF:TEXT)) )+oIdent:_nNF:TEXT,TamSX3("F1_DOC")[1])
	Endif
	
	ConOut(Padr("| "+cChave,59)+"|")
	
	cTipoDoc	:= "N"	// Atribuo Default N=Normal
	
	U_DbSelArea("CONDORXML",.F.,1)
	Set Filter to
	
	lExistChv := !DbSeek(cChave)
	
	// Verificou que a chave já existe na base
	If !lExistChv
		// Identificou que a nota fiscal já esta lançada
		
		U_DbSelArea("CONDORXMLITENS",.F.,1)
		lAuxExistChv := DbSeek(Padr(cChave,Len(CONDORXMLITENS->XIT_CHAVE)) )
		
		If !Empty(CONDORXML->XML_KEYF1) .And. lAuxExistChv
			cMsgRetMail += "Chave eletrônica '"+cChave+"' já lançada como nota fiscal '"+CONDORXML->XML_KEYF1+"'. Não houve o recebimento do XML"
			ConOut(Padr("Já lançada como nota fiscal '"+CONDORXML->XML_KEYF1+"'. Não houve o recebimento do XML",59)+"|")
			ConOut("+"+Replicate("-",58)+"+")
			Return .F.
		Endif
		If !Empty(CONDORXML->XML_CONFCO) .And. lAuxExistChv
			cMsgRetMail += "Chave eletrônica '"+cChave+"' já conferida pelo Compras. Não houve o recebimento do XML"
			ConOut(Padr("Já conferida pelo compras. Não houve o recebimento do XML",59)+"|")
			ConOut("+"+Replicate("-",58)+"+")
			Return .F.
		Endif
	Endif
	
	RecLock("CONDORXML",lExistChv)
	If lMail
		CONDORXML->XML_CFROM 	:= oMessage:cFrom
		CONDORXML->XML_CTO		:= oMessage:cTo
		CONDORXML->XML_SUBJECT 	:= oMessage:cSubject
		CONDORXML->XML_BODY		:= oMessage:cBody
		CONDORXML->XML_NROATT	:= oMessage:GetAttachCount()
	Else
		CONDORXML->XML_CFROM 	:= " "
		CONDORXML->XML_CTO		:= " "
		CONDORXML->XML_SUBJECT 	:= "Xml via diretório"
		CONDORXML->XML_BODY		:= "Xml carregado através de Pasta/Diretório"
		CONDORXML->XML_NROATT	:= 1
	Endif
	
	CONDORXML->XML_ARQ		:= cText
	CONDORXML->XML_ATT3		:= cTxtGrv
	
	If Type("oIdent:_tpNf") <> "U"
		CONDORXML->XML_TPNF		:= oIdent:_tpNf:Text // Tipo do Documento Fiscal (0 - entrada; 1 - saída)
	Endif
	
	// Melhoria em 21/05/2014 para contemplar a leitura do Protocolo de autorização
	// Fornecedores enviam PDF e XML com numero do Protocolo e não da Chave ou Numero da Nota
	cNumProt	:= ""
	If Type("oNFe:_NfeProc:_protNFe:_infProt:_nProt")<> "U"
		cNumProt	:= oNFe:_NfeProc:_protNFe:_infProt:_nProt:TEXT
	Endif
	
	nPxIniVlrTot	:= AT("</vOutro><vNF>",cText)
	nPxIniVlrTot	+= 14
	nPxFimVlrTot	:= AT("</vNF>",cText)
	
	If nPxIniVlrTot > 0 .And. nPxFimVlrTot > 0
		nXmlValNf 	:= Val(Substr(cText,nPxIniVlrTot,(nPxFimVlrTot-nPxIniVlrTot)))
		CONDORXML->XML_VLRDOC	:= nXmlValNf
	Endif
	
	// Se vier a partir de e-mail, permite que o arquivo PDF seja salvo na base também.
	If lMail
		For nForA := 1 To oMessage:getAttachCount()
			aAttInfo:= oMessage:getAttachInfo(nForA)
			
			// Analisa se há informaçaõd e anexo e se o arquivo anexo é um XML
			// 1 ShortName 		O nome do attachment.
			// 2 Type 				O tipo do anexo, por exemplo, text/plain ou image/x-png.
			// 3 Disposition		Tipo do arquivo.
			// 4 DispositionName	Nome do tipo de arquivo.
			// 5 ID				Identificação do anexo.
			// 6 Location			Local físico do anexo.
			// 7 * Size 			Tamanho do anexo.
			// *Parâmetro Size só estará disponível em versão superior a 7.00.131227A
			cAttInfo	:= aAttInfo[1]
			// Se o ShortName estiver em branco procura pelo DispositionName
			If Empty(cAttInfo)
				cAttInfo	:= aAttInfo[4]
			Endif
			// Se o ShortName e DispositionName estiverem em branco procura pelo Type
			If Empty(cAttInfo)
				cAttInfo	:= SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			Endif
			If At(".PDF",UPPER(cAttInfo)) > 0 .And. ( At(cChave,UPPER(cAttInfo)) > 0 .Or. At(Trim(oIdent:_nNF:TEXT),UPPER(cAttInfo)) > 0 .Or.(!Empty(cNumProt) .And. At(cNumProt,cAttInfo) > 0 ))
				If Len(aAttInfo) >= 7
					// http://tdn.totvs.com/pages/viewpage.action?pageId=161349793
					// Somente arquivos PDF com tamanho inferior ao limite de string serão lidos
					If aAttInfo[7] < 1048576
						CONDORXML->XML_ATT2		:= oMessage:getAttach(nForA)
					Endif
				Else
					CONDORXML->XML_ATT2		:= oMessage:getAttach(nForA)
				Endif
			Endif
		Next nForA
	Endif
	
	CONDORXML->XML_CHAVE		:= cChave
	
	If Type("oDestino:_enderDest:_UF") <> "U" .And. Upper(oDestino:_enderDest:_UF:TEXT) == "EX"// At('<UF>EX</UF>',Upper(cText)) > 0
		CONDORXML->XML_EMIT			:= IIf(Type("oDestino:_CNPJ") <> "U",oDestino:_CNPJ:TEXT,IIf(Type("oDestino:_CPF") <> "U",oDestino:_CPF,""))
		CONDORXML->XML_INSCRI		:= IIf(Type("oDestino:_IE") <> "U",oDestino:_IE:TEXT,"ISENTO")
		CONDORXML->XML_NOMEMT		:= oDestino:_xNome:TEXT   // Nome emitente
		CONDORXML->XML_MUNMT		:= Upper(oDestino:_enderDest:_xMun:TEXT) + "/"+Upper(oDestino:_enderDest:_UF:TEXT) // Municipio Emitente
		CONDORXML->XML_DEST			:= oEmitente:_CNPJ:TEXT
		CONDORXML->XML_NOMEDT		:= oEmitente:_xNome:TEXT  // Nome Destinatario
		CONDORXML->XML_MUNDT		:= oEmitente:_enderEmit:_xMun:TEXT+"/"+oEmitente:_enderEmit:_UF:TEXT  // Municipio Destinatario
		CONDORXML->XML_TPNF 		:= "1"
	Else
		
		If Type("oEmitente:_CNPJ") <> "U"
			CONDORXML->XML_EMIT			:= oEmitente:_CNPJ:TEXT
		ElseIf Type("oEmitente:_CPF") <> "U"
			CONDORXML->XML_EMIT			:= oEmitente:_CPF:TEXT
		Endif
		CONDORXML->XML_INSCRI		:= IIf(Type("oEmitente:_IE") <> "U",oEmitente:_IE:TEXT,"ISENTO")
		CONDORXML->XML_NOMEMT		:= IIf(Type("oEmitente:_xNome") <> "U",oEmitente:_xNome:TEXT,"SEM IDENT") // Nome emitente
		CONDORXML->XML_MUNMT		:= IIf(Type("oEmitente:_enderEmit") <> "U",oEmitente:_enderEmit:_xMun:TEXT+"/"+oEmitente:_enderEmit:_UF:TEXT,"SEM CIDADE/UF") // Municipio Emitente
		If Type("oDestino:_CNPJ") <> "U"
			CONDORXML->XML_DEST			:= oDestino:_CNPJ:TEXT
		ElseIf Type("oDestino:_CPF") <> "U"
			CONDORXML->XML_DEST			:= oDestino:_CPF:TEXT
		Endif
		CONDORXML->XML_NOMEDT		:= oDestino:_xNome:TEXT  // Nome Destinatario
		CONDORXML->XML_MUNDT		:= oDestino:_enderDest:_xMun:TEXT + "/"+oDestino:_enderDest:_UF:TEXT // Municipio Destinatario
	Endif
	
	If cLeftNil $ " #0" 		// 0=Padrão(Soh Num c/zeros)
		CONDORXML->XML_NUMNF		:= Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nNF:TEXT)) )+oIdent:_nNF:TEXT,TamSX3("F1_DOC")[1])
	ElseIf cLeftNil == "1" 	// 1=Num e Serie
		CONDORXML->XML_NUMNF		:= Right(StrZero(0,(TamSX3("F1_SERIE")[1])-Len(Trim(oIdent:_serie:TEXT)))+oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nNF:TEXT)) )+oIdent:_nNF:TEXT,TamSX3("F1_DOC")[1])
	ElseIf cLeftNil == "2"	// 2=Sem preencher zeros
		CONDORXML->XML_NUMNF		:= Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Padr(oIdent:_nNF:TEXT,TamSX3("F1_DOC")[1])
	Endif
	
	If Type("oIdent:_dhEmi") <> "U"
		// <dhEmi>2014-04-15T12:02:46-03:00
		cData 	:=	Alltrim(Substr(oIdent:_dhEmi:TEXT,1,10))
	Else
		//<dEmi>2014-04-10
		cData	:=	Alltrim(oIdent:_dEmi:TEXT)
	Endif
	cData	:= StrTran(cData,"-","")
	dData	:=	STOD(cData) //CTOD(Right(cData,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
	CONDORXML->XML_EMISSA		:= dData
	
	nPosCompra	:= At("<compra><xPed>",cTxtGrv)
	If nPosCompra > 0
		CONDORXML->XML_PCOMPR	:= Substr(cTxtGrv,nPosCompra+14,6)
	Endif
	
	CONDORXML->XML_RECEB		:= Date()
	CONDORXML->XML_HORREC		:= Time()
	CONDORXML->XML_USRREC		:= Padr(cUserName,30)
	
	
	
	If !Empty(cChave) .And. lSefMan .And. !lAutoExec
		
		cNavegado	:= Alltrim(GetMv("XM_URLCSFZ"))+cChave
		
		Define MsDialog oDlgWb2 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser"
		@ 005,010 Say "Chave da NF-e / Use CTRL+C para copiar, e depois colar na página abaixo" of oDlgWb2 Pixel
		@ 015,010 MsGet oNavegado var cChave Size 300,05 Of oDlgWb2 Pixel
		oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb2 )
		
		@ 010, 350 Button oBtnPrint PROMPT "Confirmar Consulta" Size 70,10 Action (CONDORXML->XML_CONFER := Date(),CONDORXML->XML_HORCON := Time(),CONDORXML->XML_USRCON := Padr(cUserName,30),oDlgWb2:End()) Of oDlgWb2 Pixel
		@ 010, 440 Button oBtnPrint PROMPT "Imprimir" Size 40,10 Action oTIBrowser:Print() Of oDlgWb2 Pixel
		@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb2:End()) Of oDlgWb2 Pixel
		Activate MsDialog oDlgWb2 Centered
	Else
		cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
		// Verifico se a empresa em cursor tem TSS configurado
		cIdentSPED	:= Iif(GetNewPar("XM_TSSEXIS",.T.),StaticCall(SPEDNFE,GetIdEnt)," ")
		
		If !Empty(cIdentSPED)
			
			// Trecho para validar autorização da NF
			cMensagem:= ""
			oWs:= WsNFeSBra():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cID_ENT    	 := cIdentSPED
			ows:cCHVNFE		 := cChave
			oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"
			
			If oWs:ConsultaChaveNFE()
				cMensagem := ""
				If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
					cMensagem += STR0129+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
				EndIf
				cMensagem += STR0035+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,STR0056,STR0057)+CRLF //"Produção"###"Homologação"
				cMensagem += "Cod.Ret.NFe : "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
				cMensagem += "Msg.Ret.NFe : "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
				If oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1 .And. !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
					cMensagem += STR0050+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
				EndIf
				// Nota fiscal Autorizada
				If Alltrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) == "100"
					CONDORXML->XML_CONFER := Date()
					CONDORXML->XML_HORCON := Time()
					CONDORXML->XML_USRCON := Padr("TSS-Central Xml-"+cUserName,30)
					// Nota fiscal Cancelada - Cancelamento autorizado
				ElseIf Alltrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) == "101"
					CONDORXML->XML_CONFER 	:= Date()
					CONDORXML->XML_HORCON 	:= Time()
					CONDORXML->XML_USRCON 	:= Padr("TSS-Central Xml-"+cUserName,30)
					CONDORXML->XML_REJEIT	:= Date()
					CONDORXML->XML_USRREJ	:= Padr("TSS-Central Xml-"+cUserName,30)
					lRej101	:= .T.
				Else
					//Aviso(STR0107,cMensagem,{"Nota fiscal não Autorizada na SEFAZ"},3)
					If !lAutoExec
						Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+ "Consulta NF",cMensagem+Chr(13)+Chr(10)+"Nota fiscal '"+CONDORXML->XML_NUMNF+"' do Fornecedor/Cliente '"+Alltrim(CONDORXML->XML_NOMEMT)+"'!",{"Ok"},3)
					Endif
				Endif
				//	Aviso(STR0107,cMensagem,{STR0114},3)
			Else
				// Adicionada melhoria em 13/09/2016
				// Permite que rejeição 526 - XML emitido há mais de 6 meses seja recebido
				If  "526 Rejeicao:" $ IIf(Empty(GetWscError(3)),"",GetWscError(3))
					CONDORXML->XML_DTRVLD := Date()
					If Empty(CONDORXML->XML_CONFER)
						CONDORXML->XML_CONFER := Date()
						CONDORXML->XML_HORCON := Time()
						CONDORXML->XML_USRCON := Padr("TSS-Central Xml-"+cUserName,30)
					Endif
				Else
					If !lAutoExec
						Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
					Endif
				Endif
			EndIf
		Else
			If !lAutoExec
				Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
			Endif
		Endif
	Endif
	
	MsUnlock()
	
	// 21/05/2016 - Melhoria para gravar vencimentos por XML
	If Type("oNF:_InfNfe:_Cobr") <> "U"
		oCobr		:= oNF:_InfNfe:_Cobr
	Endif
	
	If Type("oCobr:_dup") <> "U"
		// Neste trecho carrego um array contendo os vencimentos e valores das parcelas contidos no XML e permito levar para o Documento de entrada
		oDup  		:= oCobr:_dup
		oDup 		:= IIf(ValType(oDup)=="O",{oDup},oDup)
		lOnlyDup	:= Len(oDup) == 1
		cParcela	:= " "
		For nForB := 1 To Len(oDup)
			nP := nForB
			If Type("oDup[nP]:_vDup") <> "U" .And. Type("oDup[nP]:_dVenc") <> "U"
				U_DbSelArea("CONDORXMLDUPL",.F.,1)
				
				If lOnlyDup
					cParcela := " "
				Else
					cParcela := IF(nP>1,MaParcela(cParcela),IIF(Empty(cParcela),"A",cParcela))
				Endif
				// Verificou que a chave j[a existe na base
				
				lExistParc := !DbSeek(cChave + cParcela)
				RecLock("CONDORXMLDUPL",lExistParc)
				CONDORXMLDUPL->XDP_CHAVE	:= cChave
				CONDORXMLDUPL->XDP_PARCEL	:= cParcela
				CONDORXMLDUPL->XDP_VENCTO	:= STOD(StrTran(Alltrim(oDup[nP]:_dVenc:TEXT),"-",""))
				CONDORXMLDUPL->XDP_VALOR	:= Val(oDup[nP]:_vDup:TEXT)
				MsUnlock()
				
			Endif
		Next nForB
	Endif
	
	// Se a NF-e foi rejeitada abra a tela de cancelamento para envio de email
	If lRej101
		If !lAutoExec
			If Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"Consulta NF",cMensagem+Chr(13)+Chr(10)+"Chave Eletrônica: "+CONDORXML->XML_CHAVE+Chr(13)+Chr(10)+"Nota fiscal '"+CONDORXML->XML_NUMNF+"' do Fornecedor/Cliente '"+Alltrim(CONDORXML->XML_NOMEMT)+"' não está mais Autorizada na SEFAZ!",{"Enviar EMail","Ok"},3) == 1
				StaticCall(XMLDCONDOR,stRejeita,cChave,cMensagem)
			Endif
		Else
			StaticCall(XMLDCONDOR,stRejeita,cChave,cMensagem,lAutoExec,lRej101,"101-Nota fiscal Cancelada - Cancelamento autorizado")
		Endif
	Endif
	
	oDet       	:= oNF:_InfNfe:_Det
	
	oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
	
	
	IIf(Type("oNFe:_InfNfe:_compra:_xPed")=="U",Nil,cPedCompra := oNF:_InfNfe:_compra:_xPed:TEXT)
	
	U_DbSelArea("CONDORXMLITENS",.F.,1)
	Set Filter To
	// Inicio loop nos itens da nota
	For nForC := 1 To Len(oDet)
		nX := nForC
		
		// Verifico se os 3 digitos finais do CFOP estão na lista de CFOPs que identificam a nota como nota de Beneficiamento
		If Substr(oDet[nX]:_Prod:_CFOP:TEXT,2,3) $ GetMv("XM_CFOPRET")
			cTipoDoc	:= "B"
			// Verifico se os 3 digitos finais do CFOP da nota estão na lista de CFOPs que identifica a nota como de Devolução
		ElseIf Substr(oDet[nX]:_Prod:_CFOP:TEXT,2,3) $ GetMv("XM_CFOPDEV")
			cTipoDoc	:= "D"
		Endif
		
		U_DbSelArea("CONDORXMLITENS",.F.,1)
		lExistChv := !DbSeek(Padr(cChave,Len(CONDORXMLITENS->XIT_CHAVE)) + Padr(oDet[nX]:_Prod:_cProd:TEXT,Len(CONDORXMLITENS->XIT_CODNFE)) + StrZero(nX,4))
		RecLock("CONDORXMLITENS",lExistChv)
		
		CONDORXMLITENS->XIT_CHAVE		:= cChave
		CONDORXMLITENS->XIT_ITEM		:= StrZero(nX,4)
		CONDORXMLITENS->XIT_CODNFE		:= oDet[nX]:_Prod:_cProd:TEXT
		CONDORXMLITENS->XIT_DESCRI		:= oDet[nX]:_Prod:_xProd:TEXT
		If Type("oDet[nX]:_Prod:_NCM") <> "U"
			CONDORXMLITENS->XIT_NCM			:= oDet[nX]:_Prod:_NCM:TEXT
		Endif
		CONDORXMLITENS->XIT_CFNFE		:= oDet[nX]:_Prod:_CFOP:TEXT
		CONDORXMLITENS->XIT_QTENFE		:= Val(oDet[nX]:_Prod:_qCom:TEXT)
		CONDORXMLITENS->XIT_PRCNFE		:= Val(oDet[nX]:_Prod:_vUnCom:TEXT)
		CONDORXMLITENS->XIT_UMNFE		:= oDet[nX]:_Prod:_uCom:TEXT
		CONDORXMLITENS->XIT_TOTNFE		:= Val(oDet[nX]:_Prod:_vProd:TEXT)
		
		
		If Type("oDet[nX]:_Prod:_vDesc")<> "U"
			CONDORXMLITENS->XIT_VALDES  := Val(oDet[nX]:_Prod:_vDesc:TEXT)
		Endif
		
		If Type("oDet[nX]:_Prod:_vFrete")<> "U"
			CONDORXMLITENS->XIT_VALFRE  := Val(oDet[nX]:_Prod:_vFrete:TEXT)
		Endif
		
		If Type("oDet[nX]:_Prod:_vOutro")<> "U"
			CONDORXMLITENS->XIT_DESPES  := Val(oDet[nX]:_Prod:_vOutro:TEXT)
		Endif
		
		If Type("oDet[nX]:_Prod:_vSeg")<> "U"
			CONDORXMLITENS->XIT_SEGURO  := Val(oDet[nX]:_Prod:_vSeg:TEXT)
		Endif
		
		If Type("oDet[nX]:_Prod:_DI:_nDI")<> "U"
			CONDORXMLITENS->XIT_NDI  	:= oDet[nX]:_Prod:_DI:_nDI:TEXT
			
			CONDORXMLITENS->XIT_DIDATA	 	:= STOD(StrTran(oDet[nX]:_Prod:_DI:_dDI:TEXT,"-",""))  // Data da DI
			//<dDI>2012-01-23</dDI>
			
			CONDORXMLITENS->XIT_DILOCD		:= oDet[nX]:_Prod:_DI:_xLocDesemb:TEXT	 // Local do Desembaraçõ
			//<xLocDesemb>INST. PORT. FLUVIAL DE USO PRIV. POLY TERMINAIS PORTUARIO</xLocDesemb>
			
			CONDORXMLITENS->XIT_DIUFDS		:= oDet[nX]:_Prod:_DI:_UFDesemb:TEXT // UF do Desembaraço
			//<UFDesemb>SC</UFDesemb>
			
			CONDORXMLITENS->XIT_DIDTDS		:= STOD(StrTran(oDet[nX]:_Prod:_DI:_dDesemb:TEXT,"-",""))// Data do Desembaraço
			//<dDesemb>2012-01-27</dDesemb>
			//<adi><nAdicao>33</nAdicao><nSeqAdic>20</nSeqAdic><cFabricante>Q247700</cFabricante><nDraw/></adi>
			//<DI><nDI>1708881931</nDI><dDI>2017-06-01</dDI><xLocDesemb>PORTO DE SANTOS</xLocDesemb><UFDesemb>SP</UFDesemb><dDesemb>2017-06-01</dDesemb>
			//<tpViaTransp>1</tpViaTransp><vAFRMM>0.00</vAFRMM><tpIntermedio>1</tpIntermedio><cExportador>Q247700</cExportador>
			//<adi><nAdicao>33</nAdicao><nSeqAdic>20</nSeqAdic><cFabricante>Q247700</cFabricante><nDraw/></adi><adi><nAdicao>33</nAdicao><nSeqAdic>21</nSeqAdic><cFabricante>Q247700</cFabricante><nDraw/></adi><adi><nAdicao>33</nAdicao><nSeqAdic>22</nSeqAdic><cFabricante>Q247700</cFabricante><nDraw/></adi>
			oaDI := Iif(Type("oDet[nX]:_Prod:_DI:_adi")<> "U",oDet[nX]:_Prod:_DI:_adi,{})
			oaDI := IIf(ValType(oDet)=="O",{oaDI},oaDI)
			
			//CONDORXMLITENS->XIT_DINADI		:= oDet[nX]:_Prod:_DI:_adi[1]:_nAdicao:TEXT //  Adicao
			CONDORXMLITENS->XIT_DINADI		:= oaDI[1]:_nAdicao:TEXT //  Adicao
			//<adi><nAdicao>2</nAdicao>
			
			CONDORXMLITENS->XIT_DISQAD		:= oDet[nX]:_Prod:_DI:_adi[1]:_nSeqAdic:TEXT  // Sequencia da Adiçao
			//<nSeqAdic>1</nSeqAdic>
			CONDORXMLITENS->XIT_DISQAD		:= oaDI[1]:_nSeqAdic:TEXT  // Sequencia da Adiçao
		Endif
		
		// Já carrega os dados do XML - Melhoria em 11/02/2014
		If Type("oDet[nX]:_Prod:_xPed") <> "U" .And. GetNewPar("XM_XSC7TAG",.T.)
			CONDORXMLITENS->XIT_PEDIDO			:= oDet[nX]:_Prod:_xPed:TEXT
		Endif
		If Type("oDet[nX]:_Prod:_nItemPed") <> "U" .And. GetNewPar("XM_XSC7TAG",.T.)
			CONDORXMLITENS->XIT_ITEMPC			:= oDet[nX]:_Prod:_nItemPed:TEXT
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("D1_FCICOD")
			If Type("oDet[nX]:_Prod:_nFCI") <> "U"
				CONDORXMLITENS->XIT_FCICOD			:= oDet[nX]:_Prod:_nFCI:TEXT
			Endif
		Endif
		
		//# ID Campo Descrição Ele Pai Tipo Ocor. Tam. Observação
		// 152 K01  med Detalhamento de Medicamentos e de matérias-primas farmacêuticas     CG I90  1-500 Informar apenas quando se tratar de medicamentos ou de matérias-primas farmacêuticas, permite ocorrências.
		// 153 K02  nLote Número do Lote de medicamentos ou de matérias-primas farmacêuticas E K01 C 1-1 1-20
		// 154 K03 qLote Quantidade de produto no Lote de medicamentos ou de matérias-primas farmacêuticas E K01 N 1-1 8v3
		// 155 K04 dFab Data de fabricação E K01 D 1-1 Formato “AAAA-MM-DD”
		// 156 K05 dVal Data de validade E K01 D 1-1 Formato “AAAA-MM-DD”
		// 157 K06 vPMC Preço máximo consumidor E K01 N 1-1 13v2
		
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("D1_LOTECTL")
			If Type("oDet[nX]:_Prod:_med:_nLote") <> "U"
				CONDORXMLITENS->XIT_LOTCTL			:= Padr(oDet[nX]:_Prod:_med:_nLote:TEXT,SX3->X3_TAMANHO)
			Endif
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("D1_NUMLOTE")
			If Type("oDet[nX]:_Prod:_med:_dFab") <> "U"
				CONDORXMLITENS->XIT_NUMLOT			:= StrTran(oDet[nX]:_Prod:_med:_dFab:TEXT,"-","")
			Endif
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("D1_LOTEFOR")
			If Type("oDet[nX]:_Prod:_med:_nLote") <> "U"
				CONDORXMLITENS->XIT_LOTFOR			:= oDet[nX]:_Prod:_med:_nLote:TEXT
			Endif
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("D1_DTVALID")
			If Type("oDet[nX]:_Prod:_med:_dVal") <> "U"
				CONDORXMLITENS->XIT_DTVALD			:= STOD(StrTran(oDet[nX]:_Prod:_med:_dVal:TEXT,"-",""))
			Endif
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("A5_CODBAR")
			If Type("oDet[nX]:_Prod:_cEAN") <> "U"
				CONDORXMLITENS->XIT_CODBAR			:= oDet[nX]:_Prod:_cEAN:TEXT
			Endif
		Endif
		
		Do Case
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS00")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS00
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS10")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS10
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS20")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS20
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS30")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS30
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS40")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS40
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS51")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS51
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS60")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS60
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS70")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS70
		Case Type("oDet[nX]:_Imposto:_ICMS:_ICMS90")<> "U"
			oICM:=oDet[nX]:_Imposto:_ICMS:_ICMS90
		EndCase
		
		//	Efetua verificação pelas Tags do Simples Nacional
		If Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN101") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN101
		ElseIf Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN102") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN102
		ElseIf Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN201") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN201
		ElseIf Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN202") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN202
		ElseIf Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN500") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN500
		ElseIf Type("oDet[nX]:_Imposto:_ICMS:_ICMSSN900") <> "U"
			oICM	:= oDet[nX]:_Imposto:_ICMS:_ICMSSN900
		Endif
		
		If Type("oICM")<> "U"
			If Type("oICM:_vBC") <> "U"
				CONDORXMLITENS->XIT_BASICM		:= Val(oICM:_vBC:TEXT)
			Endif
			If Type("oICM:_pICMS") <> "U" .And. Val(oICM:_pICMS:TEXT) < 100
				CONDORXMLITENS->XIT_PICM		:= Val(oICM:_pICMS:TEXT)
			Endif
			If Type("oICM:_vICMS") <> "U"
				CONDORXMLITENS->XIT_VALICM		:= Val(oICM:_vICMS:TEXT)
			Endif
			If Type("oICM:_vBCST") <> "U"
				CONDORXMLITENS->XIT_BASRET		:= Val(oICM:_vBCST:TEXT)
			Endif
			If Type("oICM:_vBCSTRet") <> "U"
				CONDORXMLITENS->XIT_BRETAN		:= Val(oICM:_vBCSTRet:TEXT)
			Endif
			
			If Type("oICM:_pMVAST") <> "U"
				CONDORXMLITENS->XIT_PMVA		:= Val(oICM:_pMVAST:TEXT)
			Endif
			If Type("oICM:_pICMSST") <> "U"
				CONDORXMLITENS->XIT_PICMST		:= Val(oICM:_pICMSST:TEXT)
			Endif
			If Type("oICM:_vICMSST") <> "U"
				CONDORXMLITENS->XIT_VALRET		:= Val(oICM:_vICMSST:TEXT)
			Endif
			
			If Type("oICM:_vICMSSTRet") <> "U"
				CONDORXMLITENS->XIT_VRETAN		:= Val(oICM:_vICMSSTRet:TEXT)
			Endif
			
			If Type("oICM:_orig") <> "U" .And. Type("oICM:_CST") <> "U"
				CONDORXMLITENS->XIT_CLASFI		:= Padr(Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT),TamSX3("D1_CLASFIS")[1])
				CONDORXMLITENS->XIT_CSTORI		:= Padr(Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CST:TEXT),TamSX3("D1_CLASFIS")[1])
			Endif
			If Type("oICM:_orig") <> "U" .And. Type("oICM:_CSOSN") <> "U"
				//CONDORXMLITENS->XIT_CLASFI		:= Padr(Alltrim(oICM:_orig:TEXT)+Alltrim(oICM:_CSOSN:TEXT),TamSX3("D1_CLASFIS")[1])
				CONDORXMLITENS->XIT_CSTORI		:= Alltrim(oICM:_orig:TEXT) + Alltrim(oICM:_CSOSN:TEXT)
			Endif
			
			
			If Type("oICM:_pCredSN") <> "U"
				CONDORXMLITENS->XIT_PICMSN		:= Val(oICM:_pCredSN:TEXT)
			Endif
			If Type("oICM:_vCredICMSSN") <> "U"
				CONDORXMLITENS->XIT_CICMSN		:= Val(oICM:_vCredICMSSN:TEXT)
			Endif
		Endif
		
		// Efetua a gravação dos dados referente ao IPI
		If Type("oDet[nX]:_Imposto:_IPI:_IPITRIB")<> "U"
			oIPI := oDet[nx]:_Imposto:_IPI:_IPITRIB
			CONDORXMLITENS->XIT_BASIPI		:= Iif(Type("oIPI:_vBC")<>"U",Val(oIPI:_vBC:TEXT),0)
			nPerIPI		:= Iif(Type("oIPI:_pIPI")<>"U",Val(oIPI:_pIPI:TEXT),0)
			If nPerIPI > 99.99
				//MsgAlert("IPI inválido encontrado e valor zerado!")
				nPerIPI 	:= 0
			Endif
			CONDORXMLITENS->XIT_PIPI		:= nPerIPI
			CONDORXMLITENS->XIT_VALIPI		:= Iif(Type("oIPI:_vIPI")<>"U",Val(oIPI:_vIPI:TEXT),0)
		Endif
		
		// Efetua a gravação dos dados referente ao PIS
		If Type("oDet[nX]:_Imposto:_PIS:_PISAliq")<> "U" .And. Val(oDet[nX]:_Imposto:_PIS:_PISAliq:_pPIS:TEXT) < 100
			oPIS:=oDet[nX]:_Imposto:_PIS:_PISAliq
			CONDORXMLITENS->XIT_BASPIS		:= Val(oPIS:_vBC:TEXT)
			CONDORXMLITENS->XIT_PPIS		:= Val(oPIS:_pPIS:TEXT)
			CONDORXMLITENS->XIT_VALPIS		:= Val(oPIS:_vPIS:TEXT)
		Endif
		
		// Efetua a gravação dos dados referente ao COFINS
		If Type("oDet[nX]:_Imposto:_COFINS:_COFINSAliq")<> "U" .And. Val(oDet[nX]:_Imposto:_COFINS:_COFINSAliq:_pCOFINS:TEXT) < 100
			oPIS:=oDet[nX]:_Imposto:_COFINS:_COFINSAliq
			CONDORXMLITENS->XIT_BASCOF		:= Val(oPIS:_vBC:TEXT)
			CONDORXMLITENS->XIT_PCOF		:= Val(oPIS:_pCOFINS:TEXT)
			CONDORXMLITENS->XIT_VALCOF		:= Val(oPIS:_vCOFINS:TEXT)
		Endif
		
		If Type("oDet[nX]:_Imposto:_PIS:_PISOutr")<> "U" .And. Type("oDet[nX]:_Imposto:_PIS:_PISOutr:_pPIS") <> "U" .And. Val(oDet[nX]:_Imposto:_PIS:_PISOutr:_pPIS:TEXT) < 100
			oPIS:=oDet[nX]:_Imposto:_PIS:_PISOutr
			CONDORXMLITENS->XIT_BASPIS		:= Val(oPIS:_vBC:TEXT)
			CONDORXMLITENS->XIT_PPIS		:= Val(oPIS:_pPIS:TEXT)
			CONDORXMLITENS->XIT_VALPIS		:= Val(oPIS:_vPIS:TEXT)
		Endif
		
		// Efetua a gravação dos dados referente ao COFINS
		If Type("oDet[nX]:_Imposto:_COFINS:_COFINSOutr")<> "U" .And. Type("oDet[nX]:_Imposto:_COFINS:_COFINSOutr:_pCOFINS") <> "U" .And. Val(oDet[nX]:_Imposto:_COFINS:_COFINSOutr:_pCOFINS:TEXT) < 100
			oPIS:=oDet[nX]:_Imposto:_COFINS:_COFINSOutr
			CONDORXMLITENS->XIT_BASCOF		:= Val(oPIS:_vBC:TEXT)
			CONDORXMLITENS->XIT_PCOF		:= Val(oPIS:_pCOFINS:TEXT)
			CONDORXMLITENS->XIT_VALCOF		:= Val(oPIS:_vCOFINS:TEXT)
		Endif
		
		// Efetua a gravação dos dados referente ao II
		If Type("oDet[nX]:_Imposto:_II")<> "U"
			oII	:=oDet[nX]:_Imposto:_II
			CONDORXMLITENS->XIT_DIBCIM		:= Val(oII:_vBC:TEXT)
			CONDORXMLITENS->XIT_DIBSPD		:= Val(oII:_vDespAdu:TEXT)
			CONDORXMLITENS->XIT_DIVLII		:= Val(oII:_vII:TEXT)
			CONDORXMLITENS->XIT_DIVLOF		:= Val(oII:_vIOF:TEXT)
		Endif
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If DbSeek("B1_CEST")
			If Type("oDet[nX]:_Prod:_CEST") <> "U"
				CONDORXMLITENS->XIT_CEST			:= oDet[nX]:_Prod:_CEST:TEXT
			Endif
		Endif
		
		MsUnlock()
	Next nForC
	
	// Gravo o tipo de Nota
	U_DbSelArea("CONDORXML",.F.,1)
	RecLock("CONDORXML",.F.)
	CONDORXML->XML_TIPODC	:= Iif(CONDORXML->XML_TPNF	== "0" , "N" ,cTipoDoc)
	MsUnlock()
	
	If !(cTipoDoc $ "T#F")
		U_DbSelArea("CONDORXMLITENS",.F.,1)
		lAuxExistChv := DbSeek(Padr(cChave,Len(CONDORXMLITENS->XIT_CHAVE)) )
		If !lAuxExistChv
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Erro ao gravar itens de Nota",cChave)
		Endif
	Endif
	ConOut(Padr("| Fim: "+Time(),59)+"|")
	ConOut("+"+Replicate("-",58)+"+")
	
	
Return .T.


/*/{Protheus.doc} stControle
(Efetua o bloqueio/desbloqueio do parametro que controla o recebimento de emails para ser rotina mono-usuária )

@author Marcelo Lauschner
@since 07/04/2012
@version 1.0

@param lLibera, logico, Se libera ou bloqueia processo de recebimento de xmls

@return logico, Se conseguiu bloquear acesso

@example
(examples)

@see (links_or_references)
/*/
Static Function stControle(lLibera)
	
	Local	nTentativas	:= 0
	//	Local	cXmlBlqpop	:= GetMv("XM_BLQPOP")
	//	Local	aXmlBlqPop	:= StrTokArr(cXmlBlqPop,";")
	Default lLibera 	:= .F.
	/*
	If !Empty(cXmlBlqpop) .And. !lLibera
		If Len(aXmlBlqPop) < 3
			aXmlBlqPop	:= {"","",""}
		Endif
		cXmlBlqPop := "Rotina bloqueada pelo usuário(a) "+ aXmlBlqPop[1] + " desde " + aXmlBlqPop[2] + " " + aXmlBlqPop[3] +". Caso haja algum erro solicite que o CPD limpe o paramêtro XM_BLQPOP"
		
		If !lAutoExec
			// 07/02/2016 - Verifica se o bloqueio de parametro aconteceu há 1 dia ou mais e permite se deixa fazer o recebimento de XMLs
			If CTOD(aXmlBlqPop[2]) < Date()
				Return .T.
			Endif
			MsgAlert(cXmlBlqPop)
			Return .F.
		Else
			// 07/02/2016 - Verifica se o bloqueio de parametro aconteceu há 1 dia ou mais e permite se deixa fazer o recebimento de XMLs
			If CTOD(aXmlBlqPop[2]) < Date()
				Return .T.
			Endif
			StaticCall(XMLDCONDOR,stSendMail,GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Rotina bloqueada XM_BLQPOP  "+ cEmpAnt + "/" + SM0->M0_NOME,cXmlBlqPop)
			Return .F.
		Endif
		
	ElseIf lLibera
		PutMv("XM_BLQPOP"," ")
	Else
		PutMv("XM_BLQPOP",Alltrim(cUserName)+";" + DTOC(Date())+ ";" +Time()+";")
	Endif
	*/
	MsgAlert("Entrei  c")
	
	If !lLibera
		While !LockByName("MYEMAIL",.F.,.F.,.T.)
			If lAutoExec
				Sleep(2000)
			Else
				MsAguarde({|| Sleep(1000) }, "Semaforo de processamento... tentativa "+ALLTRIM(STR(nTentativas)), "Aguarde, rotina sendo executada por outro usuário.")//"Semaforo de processamento... tentativa "##"Aguarde, arquivo sendo alterado por outro usuário."
			Endif
			nTentativas++
			
			If nTentativas > 5
				If lAutoExec
					Return (.F.)
				Else
					If MsgYesNo("Não foi possível acesso exclusivo para o recebimento de e-mails.Deseja tentar novamente ?") //"Não foi possível acesso exclusivo para edição do Pré-Projeto da proposta. Deseja tentar novamente ?"
						nTentativas := 0
						Loop
					Else
						Return(.F.)
					EndIf
				Endif
			EndIf
		EndDo
	Else
		UnLockByName("MYEMAIL",.F.,.F.,.T.)
	Endif
	MsgAlert("Entrei  d")
Return .T.


Return .T.


/*/{Protheus.doc} sfRemoveCrlf
(long_description)

@author MarceloLauschner
@since 04/03/2014
@version 1.0

@param cInXml, character, XML a ser reconstruido

@return character , Xml refeito sem as quebras de linha

@example
(examples)

@see (links_or_references)
/*/
Static Function sfRemoveCrlf(cInXml)
	
	Local		cRet	:= ""
	Local		aXml	:= {}
	Local		ix
	Local		nCnt77	:= 0
	Local		nCnt75 	:= 0
	Local		nCnt74	:= 0
	Local		cVArAux	:= ""
	Local		nTamXml	:= 0
	//Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cInXml,{"Ok"},3)
	
	aXml	:=	StrTokArr(cInXml,Chr(13))
	
	// Verifico primeiro para ver se o texto está formato com quebras de linhas forçadas
	For iX := 1 To Len(aXml)
		If Len(aXml[iX]) == 77
			nCnt77++
		Endif
		If Len(aXml[iX]) == 75
			nCnt75++
		Endif
		If Len(aXml[iX]) == 74
			nCnt74++
		Endif
	Next
	
	For iX := 1 To Len(aXml)
		cRet += StrTran(aXml[iX],Chr(10),'')
		// Se a quebra de linha for com menos de 77 colunas, adiciona um espaço no texto
		If (Len(aXml[iX]) < 77) .And. nCnt77 > 15
			cRet += ' '
			// Se a quebra de linhas for com menos de 75 de colunas adiciona um espaço no texto
		ElseIf (Len(aXml[iX]) < 75) .And. nCnt75 > 15 .And. nCnt77 == 0
			cRet += ' '
		ElseIf (Len(aXml[iX]) < 74) .And. nCnt74 > 15 .And. nCnt77 == 0 .And. nCnt75 == 0
			cRet += ' '
		Endif
		
	Next
	// 19/03/2017 - Se não houve o ajuste forçado por quebra de linha com 77 caracteres, verifica se há outras quebras de linha
	If nCnt77 == 0 .And. nCnt75 == 0 .And. nCnt74 == 0
		cRet	:= ""
		aXml	:=	StrTokArr(cInXml,Chr(13))
		
		For iX := 1 To Len(aXml)
			cVarAux	:= aXml[iX] //!
			cVarAux := StrTran(cVarAux,"!",'') // Substitui sinal exclamação inserido no arquivo
			cVarAux := StrTran(cVarAux,Chr(13)+" ",'')		// Remove CRLF e espaço
			cVarAux := StrTran(cVarAux,Chr(10)+" ",'')		// Remove CRLF e espaço
			
			If Substr(cVArAux,1,1) == " "					// Se a linha tiver um espaço no começo, remove pois resultou de uma formatação errada.
				cRet += Substr(cVarAux,2)
			Else
				cRet += cVarAux
			Endif
		Next
	Endif
	
	// Caso não tenha havido nenhuma quebra de linha, retorna informação original.
	If Empty(cRet)
		cRet := cInXml
	Endif
	// 17/12/2014 - Melhoria a pedido da Concretomix para corrigir falha de xmls com espaço nas tags
	cRet	:= StrTran(cRet,"</ ","</")
	cRet	:= StrTran(cRet,"</Re ference>","</Reference>")
	cRet	:= StrTran(cRet,">< veicTransp","><veicTransp")
	cRet	:= StrTran(cRet,"<Dige stValue>","<DigestValue>")
	cRet	:= StrTran(cRet,">5 3<",">53<")
	cRet   	:= StrTran(cRet," & "," &amp; ")
	cRet  	:= StrTran(cRet,"T&A","T&amp;A")
	cRet	:= StrTran(cRet, Chr(195) + Chr(152),"0")
	cRet	:= StrTran(cRet, Chr(216) , "0" )
	cRet	:= StrTran(cRet, "?<?xml","<?xml")
	cRet	:= StrTran(cRet,"infModalversaoModal","infModal versaoModal")
	// Adiciona uma tag de fechamento
	If At("</nfeProc",cRet) > 0 .And. At("</nfeProc>",cRet) == 0
		cRet += ">"
	Endif
	
	
	//Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cRet,{"Ok"},3)
	
Return cRet


/*/{Protheus.doc} NoAcento
(Remove vogais acentuadas Função copiada do NfeSefaz )
@author MarceloLauschner
@since 01/12/2011
@version 1.0
@param cString, character, (Descrição do parâmetro)
@param lVldSch, ${param_type}, (Descrição do parâmetro)
@return cBuffer, Texto formatado
@example
(examples)
@see (links_or_references)
/*/
Static Function NoAcento(cString,lVldSch)
	Local 		cChar  		:= ""
	Local 		nX     		:= 0
	Local 		nY     		:= 0
	Local 		cVogal 		:= "aeiouAEIOU"
	Local 		cAgudo 		:= "áéíóú"+"ÁÉÍÓÚ"
	Local 		cCircu 		:= "âêîôû"+"ÂÊÎÔÛ"
	Local 		cTrema 		:= "äëïöü"+"ÄËÏÖÜ"
	Local 		cCrase 		:= "àèìòù"+"ÀÈÌÒÙ"
	Local 		cTio   		:= "ãõÃÕ"
	Local 		cCecid 		:= "çÇ"
	Local 		cCrlf	 	:= Chr(13)
	Local 		cRet		:= Chr(10)
	Local 		cBuffer		:= cString
	Default		lVldSch		:= .F.
	
	For nX:= 1 To Len(cString)
		cChar := SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase+cCrlf +cRet
			nY:= At(cChar,cAgudo)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTio)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr("aoAO",nY,1))
			EndIf
			nY:= At(cChar,cCecid)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,SubStr("cC",nY,1))
			EndIf
			nY:= At(cChar,cCrlf)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,"")
			EndIf
			nY:= At(cChar,cRet)
			If nY > 0
				cBuffer := StrTran(cBuffer,cChar,"")
			EndIf
		Endif
		
	Next
	/*If lVldSch
	For nX:=1 To Len(cBuffer)
		cChar := SubStr(cString, nX, 1)
		If Asc(cChar) < 32 .Or. Asc(cChar) > 123
			cString:=StrTran(cString,cChar,"")
		Endif
	Next nX
Endif*/
//If lIsDebug
//	Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cBuffer,{"Ok"},3)
//Endif

Return cBuffer


/*/{Protheus.doc} sfHTMLEnc
(Converte UTF8 para ASCII)
@type function
@author marce
@since 07/07/2012
@version 1.0
@param xString, variável, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfHTMLEnc(xString)
	
	Local cBuffer := xString
	
	Do Case
	Case ValType(xString)=="C"
		
		cBuffer := Strtran(cBuffer, "&amp;","&" )
		cBuffer := Strtran(cBuffer, "&quot;",'"')
		cBuffer := Strtran(cBuffer, "&lt;","<")
		cBuffer := Strtran(cBuffer, "&gt;",">")
		
		//A maiúsculo com acento agudo	Á	&Aacute;
			//E maiúsculo com acento agudo	É	&Eacute;
			//I maiúsculo com acento agudo	Í	&Iacute;
			//O maiúsculo com acento agudo	Ó	&Oacute;
			//U maiúsculo com acento agudo	Ú	&Uacute;
			//A minúsculo com acento agudo	á	&aacute;
			//E minúsculo com acento agudo	é	&eacute;
			//I minúsculo com acento agudo	í	&iacute;
			//O minúsculo com acento agudo	ó	&oacute;
			//U minúsculo com acento agudo	ú	&uacute;
			//A maiúsculo com acento circunflexo	Â	&Acirc;
			//E maiúsculo com acento circunflexo	Ê	&Ecirc;
			//O maiúsculo com acento circunflexo	Ô	&Ocirc;
			//A minúsculo com acento circunflexo	â	&acirc;
			//E minúsculo com acento circunflexo	ê	&ecirc;
			//O minúsculo com acento circunflexo	ô	&ocirc;
			//A maiúsculo com crase	À	&Agrave;
			//A minúsculo com crase	à	&agrave;
			//U maiúsculo com trema	Ü	&Uuml;
			//U minúsculo com trema	ü	&uuml;
			//C cedilha maiúsculo	Ç	&Ccedil;
			//C cedilha minúsculo	ç	&ccedil;
			//A com til maiúsculo	Ã	&Atilde;
			//O com til maiúsculo	Õ	&Otilde;
			//A com til minúsculo	ã	&atilde;
			//O com til minúsculo	õ	&otilde;
			//N com til maiúsculo	Ñ	&Ntilde;
			//N com til minúsculo	ñ	&ntilde;
			//E comercial	&	&amp;
			//Aspa dupla	"	&quot;
			//Aspa simples	'	&#039;
			//Menor que	<	&lt;
			//Maior que	>	&gt;
			
	Case ValType(xString)=="N"
		cBuffer := Str(xString)
	EndCase
	
	If lIsDebug
		Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" sfHTMLEnc",cBuffer,{"Ok"},3)
	Endif
	
Return cBuffer


/*/{Protheus.doc} sfDecodeUtf
(Remover acentuação UTF-8 e manter formatação como o Windows interpreta o visual do XML)
@author MarceloLauschner
@since 26/04/2014
@version 1.0
@param xString, variável, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfDecodeUtf(xString)
	
	Local	cBuffer		:= ""  //Ã‰ Ã€ Ãü Ãë Ãç
	Local	aAcento		:= {"á" , "à", "â", "ã", "ä", "é", "è", "ê", "ë", "í", "ì", "î", "ï", "ó", "ò", "ô", "õ", "ö", "ú", "ù", "û", "ü", "ç","Á", "À", "Â", "Ã", "Ä", "É", "È", "Ê", "Ë" , "Í" ,"Í"			, "Ì" , "Î","Ï" ,"Ó", "Ò" , "Ô", "Õ", "Ö","Ú" ,"Ù" ,"Û", "Ü" ,"Ç"          , "Ç" ,"Á" ,"É" ,"Ç"	 ,"Á"				,"Ã"  ,"Õ" ,"Á"  ," "	}
	Local	aUtf8 		:= {"Ã¡","Ã ","Ã¢","Ã£","Ã¤","Ã©","Ã¨","Ãª","Ã«","Ã­","Ã¬","Ã®","Ã¯","Ã³","Ã²","Ã´","Ãµ","Ã¶","Ãº","Ã¹","Ã»","Ã¼","Ã§","Ã?","Ã€","Ã‚","Ãƒ","Ã„","Ã‰","Ãˆ","ÃŠ","Ã‹","Ã?" ,"Ã"+chr(141), "ÃŒ","ÃŽ","Ã?","Ã“","Ã’","Ã”","Ã•","Ã–","Ãš","Ã™","Ã›","Ãœ","Ç"+Chr(135) , "Ã‡","Ãü","Ãë","Ãç" ,"Ã"+chr(129)+"S"  ,"Ãâ", "Ãò","Ãü",""	}
	Local	iC,iU
	Local	lExistUtf8	:= .F.
	
	Aadd(aAcento,"É" )
	Aadd(aUtf8  ,"Ã‰")
	
	Aadd(aAcento,"Á")
	Aadd(aUtf8  ,"Ã" + Chr(129))
	
	//0xA0 0x20 0x4b 0x4D
	
	Do Case
	Case ValType(xString) == "C"
		For iC := 1 To Len(xString)
			lExistUtf8		:= .F.
			For iU := 1 To Len(aAcento)
				If Substr(xString,iC,2) == aUtf8[iU]
					cBuffer	+= aAcento[iU]
					lExistUtf8		:= .T.
					iC++ // Acrescenta 1 ao contador por que são 2 caracteres substituidos
				Endif
			Next
			If !lExistUtf8
				cBuffer	+= Substr(xString,iC,1)
			Endif
		Next
	Case ValType(xString) == "N"
		cBuffer	:= Str(xString)
	EndCase
	If lIsDebug
		Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0))),cBuffer,{"Ok"},3)
	Endif
	
Return cBuffer

/*/{Protheus.doc} sfGrvXmlCte
(Efetua a gravação dos dados do XML para CTE-Mod.57 )
@author MarceloLauschner
@since 07/04/2012
@version 1.0
@param cText, character, (Descrição do parâmetro)
@param lMail, ${param_type}, (Descrição do parâmetro)
@param oMessage, objeto, (Descrição do parâmetro)
@param oServer, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfGrvXmlCte(cText,lMail,oMessage,oServer)
	
	Local	cTxtGrv			:= cText
	Local	cVldSch			:= cText
	Local	lRej101			:= .F.
	Local	cErro			:= ""
	Local	cAviso			:= ""
	Local	lAcept  		:= .F.
	Local	uY
	Local	nForA,nForB,nForC
	Local	lExistMalote
	Local	lExistParc		:= .F.
	Local	cParcela		:= " "
	Local	lOnlyDup		:= .F.
	
	// Se encontrada apenas a tag <CTe> adiciona Atributo
	// Solução adicionada em 22/11/2012 para resolver problema de validação de Schema do Microsiga
	If ( nPosIni := At("<CTe>",cVldSch)) > 0
		cVldSch := '<CTe xmlns="http://www.portalfiscal.inf.br/cte">'+Substr(cVldSch,nPosINi+5)
	Endif
	
	
	If ( nPosIni := At("<CTe",cVldSch)) > 0
		cVldSch := Substr(cVldSch,nPosINi)
	Endif
	If ( nPosIni := At("</infCte>",cVldSch)) > 0
		cVldSch := Substr(cVldSch,1,nPosINi+8)
		cVldSch += "</CTe>"
	Endif
	// Marcelo Lauschner - 25/05/2012 para permitir que XML com a tag Isento para IE passem na validação
	If (nPosIni := At("<IE>ISENTO</IE>",cVldSch)) > 0
		cVldSch := StrTran(cVldSch,"<IE>ISENTO</IE>","<IE></IE>")
	Endif
	
	// Avalia necessita de retirar caracteres
	cVldSch 	:= sfRemoveCrlf(cVldSch)
	cText		:= sfRemoveCrlf(cText)
	//Aviso("Schema ajustado - sfGrvXmlNfe !",cVldSch,{"Ok"},3)
	
	cAviso	:= ""
	cErro	:= ""
	
	//StaticCall(XMLDCONDOR,stSendMail,GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml" ,'"'+cTxtGrv+'"')
	
	oNfe := XmlParser(cText,"_",@cAviso,@cErro)
	
	If !Empty(cErro)
		//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml")
		cMsgRetMail	+= "Erro de XmlParser '"+cErro+"' "
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml - Erro: " + cErro ,;
			cTextGrv,;
			.F.,;
			cArqAttAch,;
			cAttachName)
		//stSendMail( cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName )
		Return .F.
	Endif
	
	
	If !Empty(cAviso) //.Or. At("UTF-8",Upper(cTxtGrv)) == 0
		//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml")
		
		//sfSendMail(GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml "+IIf(!Empty(cAviso)," aviso="+cAviso,"forçou ajuste UTF-8") ,'"'+cTxtGrv+'"')
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml " + IIf(!Empty(cAviso)," aviso="+cAviso,"forçou ajuste UTF-8") ,;
			'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		
		cErro	:= ""
		cAviso	:= ""
		cTxtGrv	:= sfDecodeUtf(cTxtGrv)
		If At("UTF-8",Upper(cTxtGrv)) > 0
			//cTxtGrv := sfHTMLEnc(cTxtGrv)
		Endif
		cTxtGrv 	:= NoAcento(cTxtGrv)
		cTxtAux   	:= EnCodeUtf8(cTxtGrv)
		If Type("cTxtAux") <> "U"
			cTxtGrv	:= EnCodeUtf8(cTxtGrv)
		Endif
		//cTxtGrv	:= StrTran(cTxtGrv,"&"," ")
		//Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+ " Avisos e erros de validação de Schema!", cTxtGrv,{"Ok"},3)
		oNfe := XmlParser(cTxtGrv,"_",@cAviso,@cErro)
		//Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+ " Avisos e erros de validação de Schema!", cTxtGrv,{"Ok"},3)
		
		If !Empty(cErro)
			//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml")
			//sfSendMail(GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - "+cErro ,'"'+cTxtGrv+'"')
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml erro: " + cErro,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			Return .F.
		Endif
		
		If !Empty(cAviso)
			//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml")
			//sfSendMail(GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml "+ cAviso ,'"'+cTxtGrv+'"')
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml " + IIf(!Empty(cAviso)," aviso="+cAviso,"forçou ajuste UTF-8") ,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			//	Return .F.
		Endif
		cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(sfDecodeUtf(cVldSch),.T.)))
	Endif
	
	If File(cDirSchema+"cte_v"+NfeIdSPED(cVldSch,"versao")+".xsd")
		//Aviso("Xml",cVldSch,{"Xml"},3           )
		cVldSch		:= sfDecodeUtf(cVldSch)
		cVldSch 	:= NoAcento(cVldSch,.T.)
		cTxtAux   	:= EnCodeUtf8(cVldSch)
		If Type("cTxtAux") <> "U"
			cVldSch	:= EnCodeUtf8(cVldSch)
		Endif
		
		cAviso	:= ""
		cErro	:= ""
		If !XmlSVldSchema( cVldSch, cDirSchema+"cte_v"+NfeIdSPED(cVldSch,"versao")+".xsd", @cErro, @cAviso )
			
			//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml")
			
			cNavegado	:= "http://www.sefaz.rs.gov.br/cte/cte-VAL.aspx"
			If !lAutoExec
				If !Empty(cAviso) .Or. !Empty(cErro)
					Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+ " Avisos e erros de validação de Schema!", "Aviso:'"+cAviso+"' - Erro:'"+cErro+"'",{"Ok"},3)
				Endif
				Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" XML com Schema Inválido! Copie o Texto abaixo e cole na próxima tela!",cText,{"Ok"},3)
				
				Define MsDialog oDlgWb3 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser"
				@ 005,010 Say "Xml" of oDlgWb3 Pixel
				@ 015,010 MsGet oNavegado Var cNavegado Size 300,05 Of oDlgWb3 Pixel
				oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb3 )
				
				If GetNewPar("XM_VLSCHFC",.T.)
					@ 010, 440 Button oBtnSair PROMPT "Aceitar" Size 40,10 Action(lAcept  := .T.,oDlgWb3:End()) Of oDlgWb3 Pixel
				Endif
				
				@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb3:End()) Of oDlgWb3 Pixel
				
				Activate MsDialog oDlgWb3 Centered
				
				oDlgWb3 := Nil
			Else
				If GetNewPar("XM_VLSCHFC",.T.)
					lAcept := .T.
				Endif
			Endif
			
			cMsgRetMail	+= "Schema inválido do XML Aviso:'"+cAviso+"' - Erro :'"+cErro+"' "
			
			If !lAcept
				Return .F.
			Endif
		Else
			//Aviso("XML com Schema Validado!",cText,{"Ok"},3)
		Endif
	Endif
	
	
	If Type("oNFe:_CTeProc")<> "U"
		oNF := oNFe:_CTeProc:_CTe
	ElseIf Type("oNFe:_CTe")<> "U"
		oNF := oNFe:_CTe
	ElseIf Type("oNFe:_enviCTe:_CTe")<> "U"
		oNF := oNFe:_enviCTe:_CTe
	ElseIf Type("oNFe:_cteProc")<> "U"
		oNF := oNFe:_cteProc:_CTe
	ElseIf Type("oNFe:_procCTe:_CTe") <> "U"
		oNF	:= oNFe:_procCTe:_CTe
	Else
		//MsgAlert("Não foi possível importar email do texto: "+cTxtGrv)
		cMsgRetMail	+= "XML não possui Tag CTe "
		//sfSendMail(GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de oCTe " ,'"'+cTxtGrv+'"')
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml - Erro de oCTe ",;
			'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		Return .F.
	Endif
	
	
	oIdent     	:= oNF:_InfCTe:_ide
	//oComple	:= oNF:_InfCTe:_compl // Não tem uso durante o recebimento
	oEmitente  	:= oNF:_InfCTe:_emit
	oRemetente	:= Iif(Type("oNF:_InfCTe:_rem") <> "U",oNF:_InfCTe:_rem,Nil)
	oExpedidor  := Iif(Type("oNF:_InfCTe:_exped") <> "U",oNF:_InfCTe:_exped,Nil)
	oDestino   	:= Iif(Type("oNF:_InfCTe:_Dest") <> "U",oNF:_InfCTe:_Dest,Nil)
	oValorPrest := oNF:_InfCTe:_vPrest
	oImposto	:= oNF:_InfCTe:_imp
	oInfCte		:= Iif(Type("oNF:_InfCTe:_infCTeNorm") <> "U",oNF:_InfCTe:_infCTeNorm,Nil)
	
	If Type("oNFe:_CTeProc:_protCTe:_infProt:_chCTe")<> "U"
		cChave	:= oNFe:_CTeProc:_protCTe:_infProt:_chCTe:TEXT
	ElseIf Type("oNFe:_enviCTe:_protCTe:_infProt:_chCTe")<> "U"
		cChave	:= oNFe:_enviCTe:_protCTe:_infProt:_chCTe:TEXT
	ElseIf Type("oNFe:_procCTe:_protCTe:_infProt:_chCTE") <> "U"
		cChave := oNFe:_procCTe:_protCTe:_infProt:_chCTE:TEXT
	Else
		cChave	:= oEmitente:_CNPJ:TEXT+Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nCT:TEXT)) )+oIdent:_nCT:TEXT,TamSX3("F1_DOC")[1])
	Endif
	
	cTipoDoc	:= "T"	// Atribuo T=CT-e
	// Localizo Objetos das notas referenciadas
	oDetNfs 		:= Iif(Type("oRemetente:_infNf")<> "U",oRemetente:_infNf,IIf(Type("oRemetente:_infNfe") <> "U",oRemetente:_infNfe,{}))
	oDetNfs 		:= IIf(ValType(oDetNfs)=="O",{oDetNfs},oDetNfs)
	// Melhoria feita em 25/05/2014 para atender CTe 2.00
	If Empty(oDetNfs) .And. Type("oInfCte:_infDoc:_infNFe") <> "U"
		oDetNfs	:= oInfCte:_infDoc:_infNFe
		oDetNfs	:= IIf(ValType(oDetNfs)=="O",{oDetNfs},oDetNfs)
	Endif
	
	lExistMalote	:= .F.
	For nForB := 1 To Len(oDetNfs)
		xU := nForB
		// Procuro a referencia com as notas de saida do Sistema
		If Type("oDetNfs[xU]:_nCFOP") <> "U"
			If oDetNfs[xU]:_nCFOP:TEXT=="6359"
				lExistMalote := .T.
			Endif
		Endif
		
		If Type("oDetNfs[xU]:_chave") <> "U"
			//SF2->F2_CHVNFE == oDet[xU]:_chave:TEXT
		Endif
	Next
	
	// Tratativa especifica para ler CTe que informa Produto predominante como DOCUMENTOS
	// e outras categorias como ENVELOPE
	// Atende necessidade especifica da Athletic Way - 20/06/2014
	If Type("oInfCte:_infCarga:_proPred") <> "U" .And. Type("oInfCte:_infCarga:_xOutCat") <> "U"
		If "DOCUMENTO" $ Upper(oInfCte:_infCarga:_proPred:TEXT) .And. ;
				Upper(oInfCte:_infCarga:_xOutCat:TEXT) $ "ENVELOPE#MALOTE"
			lExistMalote	:= .T.
		Endif
	Endif
	
	U_DbSelArea("CONDORXML",.F.,1)
	Set Filter to
	
	lExistChv := !DbSeek(cChave)
	// Verificou que a chave j[a existe na base
	If !lExistChv
		// Identificou que a nota fiscal já esta lancada
		If !Empty(CONDORXML->XML_KEYF1)
			cMsgRetMail += "Chave eletrönica '"+cChave+"' jã lançada como nota fiscal '"+CONDORXML->XML_KEYF1+"'. Não houve o recebimento do XML"
			Return .F.
		Endif
	Endif
	
	RecLock("CONDORXML",lExistChv)
	If lMail
		CONDORXML->XML_CFROM 	:= oMessage:cFrom
		CONDORXML->XML_CTO		:= oMessage:cTo
		CONDORXML->XML_SUBJECT 	:= oMessage:cSubject
		CONDORXML->XML_BODY		:= oMessage:cBody
		CONDORXML->XML_NROATT	:= oMessage:GetAttachCount()
	Else
		CONDORXML->XML_CFROM 	:= " "
		CONDORXML->XML_CTO		:= " "
		CONDORXML->XML_SUBJECT 	:= "Xml via diretório"
		CONDORXML->XML_BODY		:= "Xml carregado através de Pasta/Diretório"
		CONDORXML->XML_NROATT	:= 1
	Endif
	
	CONDORXML->XML_ARQ		:= cText
	CONDORXML->XML_ATT3		:= cTxtGrv
	
	If Type("oIdent:_tpCTe") <> "U"
		CONDORXML->XML_TPNF		:= oIdent:_tpCTe:Text // 0 - CT-e Normal;  1 - CT-e de Complemento de Valores;	2 - CT-e de Anulação;  3 - CT-e Substituto
	Endif
	
	// Melhoria em 21/05/2014 para contemplar a leitura do Protocolo de autorização
	// Fornecedores enviam PDF e XML com numero do Protocolo e não da Chave ou Numero da Nota
	nPxIniVlrTot	:= At("<vPrest><vTPrest>",CONDORXML->XML_ARQ)
	nPxIniVlrTot	+= 17
	nPxFimVlrTot	:= At("</vTPrest>",CONDORXML->XML_ARQ)
	
	If nPxIniVlrTot > 0 .And. nPxFimVlrTot > 0
		nXmlValNf 	:= Val(Substr(cText,nPxIniVlrTot,(nPxFimVlrTot-nPxIniVlrTot)))
		CONDORXML->XML_VLRDOC	:= nXmlValNf
	Endif
	
	
	// Se vier a partir de e-mail, permite que o arquivo PDF seja salvo na base também.
	
	If lMail
		For nForA := 1 To oMessage:getAttachCount()
			aAttInfo:= oMessage:getAttachInfo(nForA)
			// Analisa se há informaçaõd e anexo e se o arquivo anexo é um XML
			// 1 ShortName 			O nome do attachment.
			// 2 Type 				O tipo do anexo, por exemplo, text/plain ou image/x-png.
			// 3 Disposition		Tipo do arquivo.
			// 4 DispositionName	Nome do tipo de arquivo.
			// 5 ID					Identificação do anexo.
			// 6 Location			Local físico do anexo.
			// 7 * Size 			Tamanho do anexo.
			// *Parâmetro Size só estará disponível em versão superior a 7.00.131227A
			cAttInfo	:= aAttInfo[1]
			If Empty(cAttInfo)
				cAttInfo	:= SubStr( aAttInfo[2], At( "/", aAttInfo[2] ) + 1, Len( aAttInfo[2] ) )
			Endif
			If At("PDF",UPPER(cAttInfo)) > 0
				If Len(aAttInfo) >= 7
					// http://tdn.totvs.com/pages/viewpage.action?pageId=161349793
					// Somente arquivos PDF com tamanho inferior ao limite de string serão lidos
					If aAttInfo[7] < 1048576
						CONDORXML->XML_ATT2		:= oMessage:getAttach(nForA)
					Endif
				Else
					CONDORXML->XML_ATT2		:= oMessage:getAttach(nForA)
				Endif
			Endif
			
		Next
	Endif
	
	CONDORXML->XML_CHAVE		:= cChave
	
	If Type("oEmitente:_CNPJ") <> "U"
		CONDORXML->XML_EMIT			:= oEmitente:_CNPJ:TEXT
	ElseIf Type("oEmitente:_CPF") <> "U"
		CONDORXML->XML_EMIT			:= oEmitente:_CPF:TEXT
	Endif
	CONDORXML->XML_INSCRI		:= IIf(Type("oEmitente:_IE") <> "U",oEmitente:_IE:TEXT,"ISENTO")
	
	CONDORXML->XML_NOMEMT		:= oEmitente:_xNome:TEXT // Nome emitente
	CONDORXML->XML_MUNMT		:= oEmitente:_enderEmit:_xMun:TEXT+"/"+oEmitente:_enderEmit:_UF:TEXT // Municipio Emitente
	
	// Avalia quem é o tomador do Servico
	If (Type("oIdent:_toma03:_toma") <> "U" .And. oIdent:_toma03:_toma:TEXT $ "0") .Or. ;
			(Type("oIdent:_toma3:_toma") <> "U" .And. oIdent:_toma3:_toma:TEXT $ "0")
		
		If Type("oRemetente:_CNPJ") <> "U"
			CONDORXML->XML_DEST			:= oRemetente:_CNPJ:TEXT
		ElseIf Type("oRemetente:_CPF") <> "U"
			CONDORXML->XML_DEST			:= oRemetente:_CPF:TEXT
		Endif
		If Type("oRemetente:_xNome") <> "U"
			CONDORXML->XML_NOMEDT		:= oRemetente:_xNome:TEXT  // Nome Remetente
			CONDORXML->XML_MUNDT		:= oRemetente:_enderReme:_xMun:TEXT + "/"+oRemetente:_enderReme:_UF:TEXT // Municipio Remetente
		Endif
		
	ElseIf (Type("oIdent:_toma03:_toma") <> "U" .And. oIdent:_toma03:_toma:TEXT $ "1") .Or.;
			(Type("oIdent:_toma3:_toma") <> "U" .And. oIdent:_toma3:_toma:TEXT $ "1")
		If Type("oExpedidor:_CNPJ") <> "U"
			CONDORXML->XML_DEST			:= oExpedidor:_CNPJ:TEXT
		ElseIf Type("oExpedidor:_CPF") <> "U"
			CONDORXML->XML_DEST			:= oExpedidor:_CPF:TEXT
		Endif
		CONDORXML->XML_NOMEDT			:= oExpedidor:_xNome:TEXT  // Nome Remetente
		CONDORXML->XML_MUNDT				:= oExpedidor:_enderExped:_xMun:TEXT + "/"+oExpedidor:_enderExped:_UF:TEXT // Municipio Remetente
	ElseIf (Type("oIdent:_toma03:_toma") <> "U".And. oIdent:_toma03:_toma:TEXT $ "2#3") .Or.;
			(Type("oIdent:_toma3:_toma") <> "U".And. oIdent:_toma3:_toma:TEXT $ "2#3")
		If Type("oDestino:_CNPJ") <> "U"
			CONDORXML->XML_DEST			:= oDestino:_CNPJ:TEXT
		ElseIf Type("oDestino:_CPF") <> "U"
			CONDORXML->XML_DEST			:= oDestino:_CPF:TEXT
		Endif
		If Type("oDestino:_xNome") <> "U"
			CONDORXML->XML_NOMEDT		:= oDestino:_xNome:TEXT  // Nome Destinatário
			CONDORXML->XML_MUNDT		:= oDestino:_enderDest:_xMun:TEXT + "/"+oDestino:_enderDest:_UF:TEXT // Municipio Destino
		Endif
		// Entendo que o Frete é por conta do destinatário FOB -
		cTipoDoc	:= "F"	// Atribuo T=CT-e
		
		// Melhoria em 06/03/2013 - Avalia se o Remetente é o Emitente sendo que o devedor é destinatário
		If Type("oEmitente:_CNPJ") <> "U" .And. Type("oRemetente:_CNPJ") <> "U"
			If oEmitente:_CNPJ:TEXT == oRemetente:_CNPJ:TEXT
				cTipoDoc := "T"
			Endif
		Endif
		// Se houver a incidência de CFOP que se caracteriza como Malote ou Envelope irá atribuir o CTE como CIF forçado
		// 06/09/2015 - Se for Madeiramadeira, irá atribuir todo CTE como CTEFOB = S
		If lExistMalote .Or. lMadeira
			cTipoDoc 				:= "T"
			CONDORXML->XML_CTEFOB 	:= "S"
		Endif
	ElseIf Type ("oIdent:_toma4:_toma") <> "U"
		
		If Type("oIdent:_toma4:_CNPJ") <> "U"
			CONDORXML->XML_DEST			:= oIdent:_toma4:_CNPJ:TEXT
		ElseIf Type("oIdent:_toma4:_CPF") <> "U"
			CONDORXML->XML_DEST			:= oIdent:_toma4:_CPF:TEXT
		Endif
		CONDORXML->XML_NOMEDT		:= oIdent:_toma4:_xNome:TEXT  // Nome Remetente
		CONDORXML->XML_MUNDT		:= oIdent:_toma4:_enderToma:_xMun:TEXT + "/"+ oIdent:_toma4:_enderToma:_UF:TEXT // oDestino:_enderDest:_UF:TEXT // Municipio Destino
		
		If Type("oDestino:_CNPJ") <> "U"
			If Alltrim(CONDORXML->XML_DEST) == Alltrim(oDestino:_CNPJ:TEXT)
				// Prevendo a descontinuidade da Tag forPag
				// Forma de pagamento do serviço *** TAG OBSOLETA - Será retirada em versão futura
				If Type("oIdent:_forPag") <> "U"
					If oIdent:_forPag:TEXT == "0"
						cTipoDoc	:= "T"	// Frete pago - por conta do remetente
					ElseIf oIdent:_forPag:TEXT == "1"
						cTipoDoc	:= "F"	// Frete FOB - por conta do destinatário
					Endif
				Else
					cTipoDoc	:= "T"	// Frete pago - por conta do remetente
				Endif
			Endif
			
		ElseIf Type("oDestino:_CPF") <> "U"
			If Alltrim(	CONDORXML->XML_DEST) == Alltrim(oDestino:_CPF:TEXT)
				// Prevendo a descontinuidade da Tag forPag
				// Forma de pagamento do serviço *** TAG OBSOLETA - Será retirada em versão futura
				If Type("oIdent:_forPag") <> "U"
					If oIdent:_forPag:TEXT == "0"
						cTipoDoc	:= "T"	// Frete pago - por conta do remetente
					ElseIf oIdent:_forPag:TEXT == "1"
						cTipoDoc	:= "F"	// Frete FOB - por conta do destinatário
					Endif
				Else
					cTipoDoc	:= "T"	// Frete pago - por conta do remetente
				Endif
			Endif
		Endif
	Endif
	
	If cLeftNil $ " #0" 	// 0=Padrão(Soh Num c/zeros)
		CONDORXML->XML_NUMNF		:= Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nCT:TEXT)) )+oIdent:_nCT:TEXT,TamSX3("F1_DOC")[1])
	ElseIf cLeftNil == "1" 	// 1=Num e Serie
		CONDORXML->XML_NUMNF		:= Right(StrZero(0,(TamSX3("F1_SERIE")[1])-Len(Trim(oIdent:_serie:TEXT)))+oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Right(StrZero(0,(TamSX3("F1_DOC")[1]) -Len(Trim(oIdent:_nCT:TEXT)) )+oIdent:_nCT:TEXT,TamSX3("F1_DOC")[1])
	ElseIf cLeftNil == "2"	// 2=Sem preencher zeros
		CONDORXML->XML_NUMNF		:= Padr(oIdent:_serie:TEXT,TamSX3("F1_SERIE")[1]) + Padr(oIdent:_nCT:TEXT,TamSX3("F1_DOC")[1])
	Endif
	
	cData:=Alltrim(oIdent:_dhEmi:TEXT)
	dData:=CTOD(Substr(cData,9,2)+'/'+Substr(cData,6,2)+'/'+Left(cData,4))
	CONDORXML->XML_EMISSA		:= dData
	
	CONDORXML->XML_RECEB		:= Date()
	CONDORXML->XML_HORREC		:= Time()
	CONDORXML->XML_USRREC		:= Padr(cUserName,30)
	
	ConOut("+"+Replicate("-",58)+"+")
	ConOut(Padr("| Recebimento de XML - CTe - Função MYEMAIL ",59)+"|")
	ConOut(Padr("| "+cChave,59)+"|")
	ConOut(Padr("| Variável lSefMan   = "+IIf(lSefMan,".T.",".F."),59)+"|")
	ConOut(Padr("| Variável lAutoExec = "+IIf(lAutoExec,".T.",".F."),59)+"|")
	ConOut("+"+Replicate("-",58)+"+")
	
	If !Empty(cChave) .And. lSefMan .And. !lAutoExec
		cNavegado	:= Alltrim(GetMv("XM_URLSFZ2"))+cChave
		
		Define MsDialog oDlgWb4 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser"
		@ 005,010 Say "Página de validação do CT-e" of oDlgWb4 Pixel
		@ 015,010 MsGet oNavegado var cChave Size 300,05 Of oDlgWb4 Pixel
		oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb4 )
		
		@ 010, 350 Button oBtnPrint PROMPT "Confirmar Consulta" Size 70,10 Action (CONDORXML->XML_CONFER := Date(),CONDORXML->XML_HORCON := Time(),CONDORXML->XML_USRCON := Padr(cUserName,30),oDlgWb4:End()) Of oDlgWb4 Pixel
		@ 010, 440 Button oBtnPrint PROMPT "Imprimir" Size 40,10 Action oTIBrowser:Print() Of oDlgWb4 Pixel
		@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb4:End()) Of oDlgWb4 Pixel
		Activate MsDialog oDlgWb4 Centered
	Else
		cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
		// Verifico se a empresa em cursor tem TSS configurado
		cIdentSPED	:= Iif(GetNewPar("XM_TSSEXIS",.T.),StaticCall(SPEDNFE,GetIdEnt)," ")
		If !Empty(cIdentSPED)
			// Trecho para validar autorização da NF
			cMensagem:= ""
			oWs:= WsNFeSBra():New()
			oWs:cUserToken   := "TOTVS"
			oWs:cID_ENT    := StaticCall(SPEDNFE,GetIdEnt)
			ows:cCHVNFE		 := cChave
			oWs:_URL         := AllTrim(cURL)+"/NFeSBRA.apw"
			
			If oWs:ConsultaChaveNFE()
				cMensagem := ""
				If !Empty(oWs:oWSCONSULTACHAVENFERESULT:cVERSAO)
					cMensagem += STR0129+": "+oWs:oWSCONSULTACHAVENFERESULT:cVERSAO+CRLF
				EndIf
				cMensagem += STR0035+": "+IIf(oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1,STR0056,STR0057)+CRLF //"Produção"###"Homologação"
				cMensagem += "Cod.Ret.NFe : "+oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE+CRLF
				cMensagem += "Msg.Ret.NFe : "+oWs:oWSCONSULTACHAVENFERESULT:cMSGRETNFE+CRLF
				If oWs:oWSCONSULTACHAVENFERESULT:nAMBIENTE==1 .And. !Empty(oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO)
					cMensagem += STR0050+": "+oWs:oWSCONSULTACHAVENFERESULT:cPROTOCOLO+CRLF
				EndIf
				// Nota fiscal Autorizada
				If Alltrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) == "100"
					CONDORXML->XML_CONFER 	:= Date()
					CONDORXML->XML_HORCON 	:= Time()
					CONDORXML->XML_USRCON 	:= Padr("TSS-Central Xml-"+cUserName,30)
					// Nota fiscal Cancelada - Cancelamento autorizado
				ElseIf Alltrim(oWs:oWSCONSULTACHAVENFERESULT:cCODRETNFE) == "101"
					CONDORXML->XML_CONFER 	:= Date()
					CONDORXML->XML_HORCON 	:= Time()
					CONDORXML->XML_USRCON 	:= Padr("TSS-Central Xml-"+cUserName,30)
					CONDORXML->XML_REJEIT	:= Date()
					CONDORXML->XML_USRREJ	:= Padr("TSS-Central Xml-"+cUserName,30)
					lRej101	:= .T.
				Else
					//Aviso(STR0107,cMensagem,{"Nota fiscal não Autorizada na SEFAZ"},3)
					If !lAutoExec
						Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+"Consulta NF",cMensagem+Chr(13)+Chr(10)+"Conhecimento Eletrônico '"+CONDORXML->XML_NUMNF+"' do Fornecedor/Cliente '"+Alltrim(CONDORXML->XML_NOMEMT)+"'!",{"Ok"},3)
					Endif
				Endif
				//	Aviso(STR0107,cMensagem,{STR0114},3)
			Else
				If !lAutoExec
					Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{STR0114},3)
				Endif
			EndIf
		Endif
	Endif
	CONDORXML->XML_TIPODC	:= cTipoDoc
	
	MsUnlock()
	
	// 21/05/2016 - Melhoria para gravar vencimentos por XML
	If Type("oInfCte:_cobr") <> "U"
		oCobr		:= oInfCte:_cobr
	Endif
	
	If Type("oCobr:_dup") <> "U"
		// Neste trecho carrego um array contendo os vencimentos e valores das parcelas contidos no XML e permito levar para o Documento de entrada
		oDup  		:= oCobr:_dup
		oDup 		:= IIf(ValType(oDup)=="O",{oDup},oDup)
		lOnlyDup	:= Len(oDup) == 1
		cParcela	:= " "
		For nForC := 1 To Len(oDup)
			nP := nForC
			If Type("oDup[nP]:_vDup") <> "U" .And. Type("oDup[nP]:_dVenc") <> "U"
				U_DbSelArea("CONDORXMLDUPL",.F.,1)
				
				If lOnlyDup
					cParcela := " "
				Else
					cParcela := IF(iZ>1,MaParcela(cParcela),IIF(Empty(cParcela),"A",cParcela))
				Endif
				// Verificou que a chave j[a existe na base
				
				lExistParc := !DbSeek(cChave + cParcela)
				RecLock("CONDORXMLDUPL",lExistParc)
				CONDORXMLDUPL->XDP_CHAVE	:= cChave
				CONDORXMLDUPL->XDP_PARCEL	:= cParcela
				CONDORXMLDUPL->XDP_VENCTO	:= STOD(StrTran(Alltrim(oDup[nP]:_dVenc:TEXT),"-",""))
				CONDORXMLDUPL->XDP_VALOR	:= Val(oDup[nP]:_vDup:TEXT)
				MsUnlock()
				
			Endif
		Next nForC
	Endif
	
	// Se a NF-e foi rejeitada abra a tela de cancelamento para envio de email
	If lRej101
		If !lAutoExec
			If Aviso(ProcName(1)+ "." + ProcName(0)+"."+ Alltrim(Str(ProcLine(0)))+" Consulta NF",cMensagem+Chr(13)+Chr(10)+"Chave Eletrônica: "+CONDORXML->XML_CHAVE+Chr(13)+Chr(10)+"Conhecimento Eletrônico '"+CONDORXML->XML_NUMNF+"' do Fornecedor/Cliente '"+Alltrim(CONDORXML->XML_NOMEMT)+"' não está mais Autorizada na SEFAZ!",{"Enviar EMail","Ok"},3) == 1
				StaticCall(XMLDCONDOR,stRejeita,cChave,cMensagem)
			Endif
		Else
			StaticCall(XMLDCONDOR,stRejeita,cChave,cMensagem,lAutoExec,lRej101,"101-Conhecimento Eletronico Cancelado - Cancelamento autorizado")
		Endif
	Endif
	
	
Return .T.


/*/{Protheus.doc} sfGrvCCe
(Efetua a gravação dos dados do XML para CCe )
@author MarceloLauschner
@since 29/08/2012
@version 1.0
@param cText, character, (Descrição do parâmetro)
@param lMail, ${param_type}, (Descrição do parâmetro)
@param oMessage, objeto, (Descrição do parâmetro)
@param oServer, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfGrvCCe(cText,lMail,oMessage,oServer)
	
	Local	cTxtGrv	:= cText
	Local	cVldSch	:= cText
	Local	lRej101	:= .F.
	Local	cErro	:= ""
	Local	cAviso	:= ""
	Local	lCCeNFe	:= .F.
	Local	lCCeCTe	:= .F.
	Local	cMensagem	:= ""
	
	
	// Avalia necessita de retirar caracteres
	cVldSch 	:= sfRemoveCrlf(cVldSch)
	cText		:= sfRemoveCrlf(cText)
	//Aviso("Schema ajustado - sfGrvXmlNfe !",cVldSch,{"Ok"},3)
	
	
	cAviso	:= ""
	cErro	:= ""
	
	oCCe := XmlParser(cText,"_",@cAviso,@cErro)
	
	If !Empty(cErro)
		//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml 1329")
		cMsgRetMail	+= "Erro de XmlParser '"+cErro+"' "
		//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml CCe Erro: "+ cErro,;
			'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		Return .F.
	Endif
	
	
	If !Empty(cAviso)
		//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml 1342")
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml CCe Aviso="+ cAviso ,'"'+cTxtGrv+'"')
		
		cErro	:= ""
		cAviso	:= ""
		cTxtGrv	:= sfDecodeUtf(cTxtGrv)
		If At("UTF-8",Upper(cTxtGrv)) > 0
			//cTxtGrv := sfHTMLEnc(cTxtGrv)
		Endif
		cTxtGrv := NoAcento(cTxtGrv)
		cTxtGrv	:= EnCodeUtf8(cTxtGrv)
		
		oCCe := XmlParser(cTxtGrv,"_",@cAviso,@cErro)
		
		If !Empty(cErro)
			//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml 1351")
			//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml CCe Erro: "+ cErro,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			Return .F.
		Endif
		
		If !Empty(cAviso)
			//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml 1357")
			//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml CCe Aviso: "+ cAviso,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			//	Return .F.
		Endif
		cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(cVldSch,.T.)))
		
	Endif
	// Não será feita a validação do Schema XML da CCe por que o padrão Totvs não atende até o momento - 12/02/2013
	/*If File(cDirSchema+"leiautecce_v"+NfeIdSPED(cVldSch,"versao")+".xsd")
	
	//cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(cVldSch)))
	//Aviso("XML  Copie o Texto abaixo e cole na próxima tela!",cDirSchema+"envCCe_v"+NfeIdSPED(cVldSch,"versao")+".xsd" + "|"+cVldSch,{"Ok"},3)
	cErro	:= ""
	cAviso	:= ""
	If !XmlSVldSchema( cVldSch, cDirSchema+"leiautecce_v"+NfeIdSPED(cVldSch,"versao")+".xsd", @cErro, @cAviso )
		//TSSValidSchema(cXmlSig,cDirSchema+"envCCe_v"+SpedGetMv("MV_VEREVEN",cIdEnt,"1.00")+".xsd",@cErro,@cAviso)
		
		//TSSValidSchema(cXmlSig,cDirSchema+"envCCe_v"+SpedGetMv("MV_VEREVEN",cIdEnt,"1.00")+".xsd",@cErro,@cAviso)
		Aviso("XML com Schema Inválido! Copie o Texto abaixo e cole na próxima tela!",cVldSch,{"Ok"},3)
		
		cMsgRetMail	+= "Schema inválido do XML Aviso:'"+cAviso+"' - Erro :'"+cErro+"' "
		StaticCall(XMLDCONDOR,stSendMail,GetNewPar("XM_MAILADM","contato@centralxmlcom.br"),"Importação xml -Schema Cce Erro="+cErro+" Aviso="+cAviso  ,'"'+cTxtGrv+'"')
		
		If !GetNewPar("XM_VLSCHFC",.T.)
			Return .F.
		Endif
		
	Else
		Aviso("XML com Schema Validado!",cText,{"Ok"},3)
	Endif
Endif*/


If Type("oCCe:_procEventoNFe:_evento:_envEvento:_evento:_infEvento") <> "U"
	oEvento := oCCe:_procEventoNFe:_evento:_envEvento:_evento:_infEvento
ElseIf Type("oCCe:_procEventoNFe:_envEvento:_evento:_infEvento") <> "U"
	oEvento := oCCe:_procEventoNFe:_envEvento:_evento:_infEvento
ElseIf Type("oCCe:_procEventoNFe:_evento:_infEvento") <> "U"
	oEvento := oCCe:_procEventoNFe:_evento:_infEvento
ElseIf Type("oCCe:_evento:_infEvento") <> "U"
	oEvento := oCCe:_evento:_infEvento
ElseIf Type("oCCe:_procEventoCTe:_evento:_envEvento:_evento:_infEvento") <> "U"
	oEvento := oCCe:_procEventoCTe:_evento:_envEvento:_evento:_infEvento
ElseIf Type("oCCe:_procEventoCTe:_eventoCTe:_infEvento") <> "U"
	oEvento := oCCe:_procEventoCTe:_eventoCTe:_infEvento
ElseIf Type("oCCe:_envEvento:_evento:_infEvento") <> "U"
	oEvento := oCCe:_envEvento:_evento:_infEvento
Else
	//MsgAlert("Não foi possível importar email do texto: "+cTxtGrv)
	cMsgRetMail	+= "XML não possui Tag CCe _procEventoNFe:_evento:_infEvento"
	StaticCall(	XMLDCONDOR,;
		stSendMail,;
		GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de oCCe " ,'"'+cTxtGrv+'"')
Return .F.
Endif

If Type("oEvento:_chNFe") <> "U"
	cChave	:= oEvento:_chNFe:TEXT
	lCCeNFe	:= .T.
ElseIf Type("oEvento:_chCTe") <> "U"
	cChave	:= oEvento:_chCTe:TEXT
	lCCeCTe	:= .T.
Else
	cMsgRetMail	+= "XML não possui Tag CCe _infEvento:_chCTe ou _infEvento:_chNFe"
	StaticCall(	XMLDCONDOR,;
		stSendMail,;
		GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de oCCe " ,'"'+cTxtGrv+'"')
Return .F.
Endif

U_DbSelArea("CONDORXML",.F.,1)
Set Filter to

lExistChv := !DbSeek(cChave)

RecLock("CONDORXML",lExistChv)
// Somente uma carta de correção eletronica é permitida até o momento por nota fiscal
// A nova CCe sempre irá substituir a anterior.
// O número de Eventos da CCe é limitado a 20
//If Empty(CONDORXML->XML_ATT4)
CONDORXML->XML_ATT4		:= cText
//Endif
If lExistChv
	CONDORXML->XML_CHAVE		:= cChave
	If lMail
		CONDORXML->XML_CFROM 	:= oMessage:cFrom
		CONDORXML->XML_CTO		:= oMessage:cTo
		CONDORXML->XML_SUBJECT 	:= oMessage:cSubject
		CONDORXML->XML_BODY		+= Alltrim(CONDORXML->XML_BODY)+oMessage:cBody
	Else
		CONDORXML->XML_CFROM 	:= " "
		CONDORXML->XML_CTO		:= " "
		CONDORXML->XML_SUBJECT 	:= "Xml via diretório"
		CONDORXML->XML_BODY		:= "Xml carregado através de Pasta/Diretório"
	Endif
Else
	CONDORXML->XML_CHAVE		:= cChave
Endif

If !Empty(cChave) .And. !lAutoExec
	If lCCeNFe
		cNavegado	:= Alltrim(GetMv("XM_URLCSFZ"))+cChave
	ElseIf lCCeCTe
		cNavegado	:= Alltrim(GetMv("XM_URLSFZ2"))+cChave
	Endif
	
	Define MsDialog oDlgWb5 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser - Consulta NF-e para conferir existência do Evento da CC-e."
	@ 005,010 Say "Link de validação da NF-e " of oDlgWb5 Pixel
	@ 015,010 MsGet oNavegado var cChave Size 300,05 Of oDlgWb5 Pixel
	oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb5 )
	
	@ 010, 440 Button oBtnPrint PROMPT "Imprimir" Size 40,10 Action oTIBrowser:Print() Of oDlgWb5 Pixel
	@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb5:End()) Of oDlgWb5 Pixel
	Activate MsDialog oDlgWb5 Centered
EndIf
MsUnlock()
If Type("oEvento:_detEvento:_xCorrecao") <> "U"
	cMensagem := "Texto da Carta de Correção: " + oEvento:_detEvento:_xCorrecao:TEXT
Endif
// Grava divergencia, forçando o lançamento semi-automático
StaticCall(XMLDCONDOR,sfAtuXmlOk,"CC"/*cOkMot*/,/*lAtuItens*/,/*cItem*/,cMensagem/*cMsgAux*/,/*nLinXml*/,cChave/*cInChave*/)
//sfAtuXmlOk("NC",.T.,oMulti:aCols[nInLinAtu,nPxItem],cMensagem,,,,cAssunto,cRecebe)

Return .T.


/*/{Protheus.doc} sfGrvCanc
(Efetua a gravação dos dados do XML para evento Cancelamento)
@author MarceloLauschner
@since 04/07/2013
@version 1.0
@param cText, character, (Descrição do parâmetro)
@param lMail, ${param_type}, (Descrição do parâmetro)
@param oMessage, objeto, (Descrição do parâmetro)
@param oServer, objeto, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function sfGrvCanc(cText,lMail,oMessage,oServer)
	
	Local	cTxtGrv	:= cText
	Local	cVldSch	:= cText
	Local	lRej101	:= .F.
	Local	cErro	:= ""
	Local	cAviso	:= ""
	
	// Avalia necessita de retirar caracteres
	cVldSch 	:= sfRemoveCrlf(cVldSch)
	cText		:= sfRemoveCrlf(cText)
	//Aviso("Schema ajustado - sfGrvXmlNfe !",cVldSch,{"Ok"},3)
	
	cAviso	:= ""
	cErro	:= ""
	
	oNfe := XmlParser(cText,"_",@cAviso,@cErro)
	
	If !Empty(cErro)
		//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml 1329")
		cMsgRetMail	+= "Erro de XmlParser '"+cErro+"' "
		//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml Prot.Cancelamento Erro: "+ cErro,;
			'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		Return .F.
	Endif
	
	
	If !Empty(cAviso)
		//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml 1342")
		//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
		stfendMail(GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
			"Importação xml Prot.Cancelamento Aviso: "+ cAviso,;
			'"'+cTxtGrv+'"',;
			.F.,;
			cArqAttAch,;
			cAttachName)
		
		cErro	:= ""
		cAviso	:= ""
		cTxtGrv	:= sfDecodeUtf(cTxtGrv)
		If At("UTF-8",Upper(cTxtGrv)) > 0
			//cTxtGrv := sfHTMLEnc(cTxtGrv)
		Endif
		cTxtGrv := NoAcento(cTxtGrv)
		cTxtGrv	:= EnCodeUtf8(cTxtGrv)
		
		oNfe := XmlParser(cTxtGrv,"_",@cAviso,@cErro)
		
		If !Empty(cErro)
			//MsgAlert(cErro+chr(13)+cAviso,"Erro ao validar schema do Xml 1351")
			//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml Prot.Cancelamento Erro: "+ cErro,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			Return .F.
		Endif
		
		If !Empty(cAviso)
			//MsgAlert(cErro+chr(13)+cAviso,"Aviso ao validar schema do Xml 1357")
			//cRecebe, cAssunto, cMensagem, lExibSend, cArqAttAch, cAttachName
			StaticCall(	XMLDCONDOR,;
				stSendMail,;
				GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),;
				"Importação xml Prot.Cancelamento Aviso: "+ cAviso,;
				'"'+cTxtGrv+'"',;
				.F.,;
				cArqAttAch,;
				cAttachName)
			//	Return .F.
		Endif
		cVldSch	:= Alltrim(EnCodeUtf8(NoAcento(cVldSch,.T.)))
		
	Endif
	
	If Type("oNFe:_procEventoNFe:_evento:_envEvento:_evento:_infEvento") <> "U"
		oNF := oNFe:_procEventoNFe:_evento:_envEvento:_evento:_infEvento
	ElseIf Type("oNFe:_procCancCte:_cancCTe:_infCanc") <> "U"
		oNF := oNFe:_procCancCte:_cancCTe:_infCanc
	ElseIf Type("oNFe:_procEventoNFe:_evento:_infEvento") <> "U"
		oNF := oNFe:_procEventoNFe:_evento:_infEvento
	ElseIf Type("oNFe:_procEventoCTe:_eventoCTe:_infEvento") <> "U"
		oNF := oNFe:_procEventoCTe:_eventoCTe:_infEvento
	ElseIf Type("oNFe:_envEvento:_evento:_infEvento") <> "U"
		oNF := oNFe:_envEvento:_evento:_infEvento
	ElseIf Type("oNFe:_eventoCTe:_infEvento") <> "U"
		oNF := oNFe:_eventoCTe:_infEvento
	Else
		//MsgAlert("Não foi possível importar email do texto: "+cTxtGrv)
		cMsgRetMail	+= "XML não possui Tag CCe oNFe:_evento:_envEvento:_evento:_infEvento "
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de procEventoNfe " ,'"'+cTxtGrv+'"')
		Return .F.
	Endif
	
	cChave	:= IIf(Type("oNF:_chNFe") <> "U",oNF:_chNFe:TEXT,IIf(Type("oNF:_chCTe")<>"U",oNF:_chCTe:TEXT,""))
	
	If Empty(cChave)
		cMsgRetMail	+= "XML não possui chave eletrônica de CTe ou NFe "
		StaticCall(	XMLDCONDOR,;
			stSendMail,;
			GetNewPar("XM_MAILADM","marcelolauschner@gmail.com"),"Importação xml - Erro de Cancelamento " ,'"'+cTxtGrv+'"')
	Endif
	
	U_DbSelArea("CONDORXML",.F.,1)
	Set Filter to
	
	lExistChv := !DbSeek(cChave)
	
	RecLock("CONDORXML",lExistChv)
	
	CONDORXML->XML_RECEB	:= Date()
	CONDORXML->XML_HORREC	:= Time()
	CONDORXML->XML_USRREC	:= Padr(cUserName,30)
	CONDORXML->XML_ATT5		:= cText
	
	If lExistChv
		CONDORXML->XML_CHAVE		:= cChave
		If lMail
			CONDORXML->XML_CFROM 	:= oMessage:cFrom
			CONDORXML->XML_CTO		:= oMessage:cTo
			CONDORXML->XML_SUBJECT 	:= oMessage:cSubject
			CONDORXML->XML_BODY		+= Alltrim(CONDORXML->XML_BODY)+oMessage:cBody
		Else
			CONDORXML->XML_CFROM 	:= " "
			CONDORXML->XML_CTO		:= " "
			CONDORXML->XML_SUBJECT 	:= "Xml via diretório"
			CONDORXML->XML_BODY		:= "Xml carregado através de Pasta/Diretório"
		Endif
	Endif
	
	If !Empty(cChave) .And. !lAutoExec
		cNavegado	:= Iif(Type("oNF:_chNFe") <> "U",Alltrim(GetMv("XM_URLCSFZ"))+cChave,Alltrim(GetMv("XM_URLSFZ2"))+cChave)
		
		Define MsDialog oDlgWb6 From 0,0 TO aSize[6] , aSize[5]  Pixel Title "Web Browser - Consulta NF-e/CT-e para conferir existência do Evento da CC-e ou Protocolo de Cancelamento."
		@ 005,010 Say "Link de validação da NF-e " of oDlgWb6 Pixel
		@ 015,010 MsGet oNavegado var cChave Size 300,05 Of oDlgWb6 Pixel
		oTIBrowser:= TIBrowser():New(025,010, aSize[5]/2.04,nAltura, cNavegado, oDlgWb6 )
		
		@ 010, 440 Button oBtnPrint PROMPT "Imprimir" Size 40,10 Action oTIBrowser:Print() Of oDlgWb6 Pixel
		@ 010, 490 Button oBtnSair PROMPT "Sair" Size 40,10 Action(oDlgWb6:End()) Of oDlgWb6 Pixel
		Activate MsDialog oDlgWb6 Centered
	EndIf
	
	MsUnlock()
	
	StaticCall(XMLDCONDOR,stRejeita,cChave,"Evento de Cancelamento de Documento Eletrônico Autorizado recebido.",lAutoExec)
	
	
Return .T.



/*
Static Function SchedDef()
	Local	aOrd	:= {}
	Local	aParam	:= {}
	
	aParam	:= {"P",;
		"PARAMDEF",;
		"",;
		aOrd,;
		}
Return aParam */
