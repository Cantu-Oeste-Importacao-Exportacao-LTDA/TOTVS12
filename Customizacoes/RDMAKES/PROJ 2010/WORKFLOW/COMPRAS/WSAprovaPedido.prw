#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost/WSCantu/AprovaPedido.asmx?WSDL
Gerado em        06/16/08 15:48:51
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.060117
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _NZKKTOL ; Return  // "dummy" function - Internal Use    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* -------------------------------------------------------------------------------
WSDL Service WSWSAprovaPedido
------------------------------------------------------------------------------- */

WSCLIENT WSWSAprovaPedido

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GravaPedido
	WSMETHOD SetIdWF
	WSMETHOD GravaPedido_1
	WSMETHOD SetIdWF_1

	WSDATA   _URL                      AS String
	WSDATA   ccabec                    AS string
	WSDATA   oWSItens                  AS WSAprovaPedido_ArrayOfString
	WSDATA   cGravaPedidoResult        AS string
	WSDATA   cchave                    AS string
	WSDATA   cidWF                     AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSAprovaPedido
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.080307A-20080327] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSAprovaPedido
	::oWSItens           := WSAprovaPedido_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSWSAprovaPedido
	::ccabec             := NIL 
	::oWSItens           := NIL 
	::cGravaPedidoResult := NIL 
	::cchave             := NIL 
	::cidWF              := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSAprovaPedido
Local oClone := WSWSAprovaPedido():New()
	oClone:_URL          := ::_URL 
	oClone:ccabec        := ::ccabec
	oClone:oWSItens      :=  IIF(::oWSItens = NIL , NIL ,::oWSItens:Clone() )
	oClone:cGravaPedidoResult := ::cGravaPedidoResult
	oClone:cchave        := ::cchave
	oClone:cidWF         := ::cidWF
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method GravaPedido of Service WSWSAprovaPedido
------------------------------------------------------------------------------- */

WSMETHOD GravaPedido WSSEND ccabec,oWSItens WSRECEIVE cGravaPedidoResult WSCLIENT WSWSAprovaPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GravaPedido xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cabec", ::ccabec, ccabec , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("Itens", ::oWSItens, oWSItens , "ArrayOfString", .F. , .F., 0 ) 
cSoap += "</GravaPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GravaPedido",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/AprovaPedido.asmx")

::Init()
::cGravaPedidoResult :=  WSAdvValue( oXmlRet,"_GRAVAPEDIDORESPONSE:_GRAVAPEDIDORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method SetIdWF of Service WSWSAprovaPedido
------------------------------------------------------------------------------- */

WSMETHOD SetIdWF WSSEND cchave,cidWF WSRECEIVE NULLPARAM WSCLIENT WSWSAprovaPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetIdWF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("chave", ::cchave, cchave , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("idWF", ::cidWF, cidWF , "string", .F. , .F., 0 ) 
cSoap += "</SetIdWF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/SetIdWF",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/AprovaPedido.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GravaPedido_1 of Service WSWSAprovaPedido
------------------------------------------------------------------------------- */

WSMETHOD GravaPedido_1 WSSEND ccabec,oWSItens WSRECEIVE cGravaPedidoResult WSCLIENT WSWSAprovaPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GravaPedido xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cabec", ::ccabec, ccabec , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("Itens", ::oWSItens, oWSItens , "ArrayOfString", .F. , .F., 0 ) 
cSoap += "</GravaPedido>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GravaPedido",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/AprovaPedido.asmx")

::Init()
::cGravaPedidoResult :=  WSAdvValue( oXmlRet,"_GRAVAPEDIDORESPONSE:_GRAVAPEDIDORESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method SetIdWF_1 of Service WSWSAprovaPedido
------------------------------------------------------------------------------- */

WSMETHOD SetIdWF_1 WSSEND cchave,cidWF WSRECEIVE NULLPARAM WSCLIENT WSWSAprovaPedido
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetIdWF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("chave", ::cchave, cchave , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("idWF", ::cidWF, cidWF , "string", .F. , .F., 0 ) 
cSoap += "</SetIdWF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/SetIdWF",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/AprovaPedido.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ArrayOfString
------------------------------------------------------------------------------- */

WSSTRUCT WSAprovaPedido_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSAprovaPedido_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSAprovaPedido_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT WSAprovaPedido_ArrayOfString
	Local oClone := WSAprovaPedido_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSAprovaPedido_ArrayOfString
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 )  } ) 
Return cSoap