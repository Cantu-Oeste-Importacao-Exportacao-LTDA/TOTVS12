#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://www.cantu.tecnologia.ws/wscotacao/wsonixsat.asmx?WSDL
Gerado em        02/10/11 11:04:11
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.090116
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _ODNCYSG ; Return  // "dummy" function - Internal Use  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* -------------------------------------------------------------------------------
WSDL Service WSwsonixsat
------------------------------------------------------------------------------- */

WSCLIENT WSwsonixsat

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD ComunicaSrv

	WSDATA   _URL                      AS String
	WSDATA   ccXml                     AS string
	WSDATA   cComunicaSrvResult        AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSwsonixsat
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.100601A-20100727] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSwsonixsat
Return

WSMETHOD RESET WSCLIENT WSwsonixsat
	::ccXml              := NIL 
	::cComunicaSrvResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSwsonixsat
Local oClone := WSwsonixsat():New()
	oClone:_URL          := ::_URL 
	oClone:ccXml         := ::ccXml
	oClone:cComunicaSrvResult := ::cComunicaSrvResult
Return oClone

// WSDL Method ComunicaSrv of Service WSwsonixsat

WSMETHOD ComunicaSrv WSSEND ccXml WSRECEIVE cComunicaSrvResult WSCLIENT WSwsonixsat
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ComunicaSrv xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cXml", ::ccXml, ccXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ComunicaSrv>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ComunicaSrv",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/wsonixsat.asmx")

::Init()
::cComunicaSrvResult :=  WSAdvValue( oXmlRet,"_COMUNICASRVRESPONSE:_COMUNICASRVRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.