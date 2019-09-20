#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.195.136.59:8040/TMSEVENTS.apw?WSDL
Gerado em        04/04/13 14:37:32
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NZMYQLQ ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSTMSEVENTS
------------------------------------------------------------------------------- */


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
WSCLIENT WSTMSEVENTS

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD RECEIVEEVENT

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cRETURNTYPE               AS string
	WSDATA   cXMLIN                    AS string
	WSDATA   lRECEIVEEVENTRESULT       AS boolean

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSTMSEVENTS
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.120420A-20120726] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSTMSEVENTS
Return

WSMETHOD RESET WSCLIENT WSTMSEVENTS
	::cRETURNTYPE        := NIL 
	::cXMLIN             := NIL 
	::lRECEIVEEVENTRESULT := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSTMSEVENTS
Local oClone := WSTMSEVENTS():New()
	oClone:_URL          := ::_URL 
	oClone:cRETURNTYPE   := ::cRETURNTYPE
	oClone:cXMLIN        := ::cXMLIN
	oClone:lRECEIVEEVENTRESULT := ::lRECEIVEEVENTRESULT
Return oClone

// WSDL Method RECEIVEEVENT of Service WSTMSEVENTS

WSMETHOD RECEIVEEVENT WSSEND cRETURNTYPE,cXMLIN WSRECEIVE lRECEIVEEVENTRESULT WSCLIENT WSTMSEVENTS
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<RECEIVEEVENT xmlns="http://webservices.totvs.com.br/tmsevents.apw">'
cSoap += WSSoapValue("RETURNTYPE", ::cRETURNTYPE, cRETURNTYPE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("XMLIN", ::cXMLIN, cXMLIN , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</RECEIVEEVENT>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://webservices.totvs.com.br/tmsevents.apw/RECEIVEEVENT",; 
	"DOCUMENT","http://webservices.totvs.com.br/tmsevents.apw",,"1.031217",; 
	"http://200.195.136.59:8040/TMSEVENTS.apw")

::Init()
::lRECEIVEEVENTRESULT :=  WSAdvValue( oXmlRet,"_RECEIVEEVENTRESPONSE:_RECEIVEEVENTRESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



