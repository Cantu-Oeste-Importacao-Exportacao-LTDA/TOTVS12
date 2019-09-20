#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://localhost/WSCantu/GravaWF.asmx?wsdl
Gerado em        06/05/08 09:50:44
Observa��es      C�digo-Fonte gerado por ADVPL WSDL Client 1.060117
                 Altera��es neste arquivo podem causar funcionamento incorreto
                 e ser�o perdidas caso o c�digo-fonte seja gerado novamente.
=============================================================================== */

User Function _KQPMTKU ; Return  // "dummy" function - Internal Use 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

/* -------------------------------------------------------------------------------
WSDL Service WSGravaWF
------------------------------------------------------------------------------- */

WSCLIENT WSGravaWF

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD GravaWorkFlow
	WSMETHOD SetIdWF
	WSMETHOD GravaWorkFlow_1
	WSMETHOD SetIdWF_1

	WSDATA   _URL                      AS String
	WSDATA   ccabec                    AS string
	WSDATA   oWSItens                  AS GravaWF_ArrayOfString
	WSDATA   cGravaWorkFlowResult      AS string
	WSDATA   cchave                    AS string
	WSDATA   cidWF                     AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSGravaWF
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O C�digo-Fonte Client atual requer os execut�veis do Protheus Build [7.00.080307A-20080327] ou superior. Atualize o Protheus ou gere o C�digo-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSGravaWF
	::oWSItens           := GravaWF_ARRAYOFSTRING():New()
Return

WSMETHOD RESET WSCLIENT WSGravaWF
	::ccabec             := NIL 
	::oWSItens           := NIL 
	::cGravaWorkFlowResult := NIL 
	::cchave             := NIL 
	::cidWF              := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSGravaWF
Local oClone := WSGravaWF():New()
	oClone:_URL          := ::_URL 
	oClone:ccabec        := ::ccabec
	oClone:oWSItens      :=  IIF(::oWSItens = NIL , NIL ,::oWSItens:Clone() )
	oClone:cGravaWorkFlowResult := ::cGravaWorkFlowResult
	oClone:cchave        := ::cchave
	oClone:cidWF         := ::cidWF
Return oClone

/* -------------------------------------------------------------------------------
WSDL Method GravaWorkFlow of Service WSGravaWF
------------------------------------------------------------------------------- */

WSMETHOD GravaWorkFlow WSSEND ccabec,oWSItens WSRECEIVE cGravaWorkFlowResult WSCLIENT WSGravaWF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GravaWorkFlow xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cabec", ::ccabec, ccabec , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("Itens", ::oWSItens, oWSItens , "ArrayOfString", .F. , .F., 0 ) 
cSoap += "</GravaWorkFlow>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GravaWorkFlow",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/GravaWF.asmx")

::Init()
::cGravaWorkFlowResult :=  WSAdvValue( oXmlRet,"_GRAVAWORKFLOWRESPONSE:_GRAVAWORKFLOWRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method SetIdWF of Service WSGravaWF
------------------------------------------------------------------------------- */

WSMETHOD SetIdWF WSSEND cchave,cidWF WSRECEIVE NULLPARAM WSCLIENT WSGravaWF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetIdWF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("chave", ::cchave, cchave , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("idWF", ::cidWF, cidWF , "string", .F. , .F., 0 ) 
cSoap += "</SetIdWF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/SetIdWF",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/GravaWF.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method GravaWorkFlow_1 of Service WSGravaWF
------------------------------------------------------------------------------- */

WSMETHOD GravaWorkFlow_1 WSSEND ccabec,oWSItens WSRECEIVE cGravaWorkFlowResult WSCLIENT WSGravaWF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GravaWorkFlow xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("cabec", ::ccabec, ccabec , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("Itens", ::oWSItens, oWSItens , "ArrayOfString", .F. , .F., 0 ) 
cSoap += "</GravaWorkFlow>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GravaWorkFlow",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/GravaWF.asmx")

::Init()
::cGravaWorkFlowResult :=  WSAdvValue( oXmlRet,"_GRAVAWORKFLOWRESPONSE:_GRAVAWORKFLOWRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

/* -------------------------------------------------------------------------------
WSDL Method SetIdWF_1 of Service WSGravaWF
------------------------------------------------------------------------------- */

WSMETHOD SetIdWF_1 WSSEND cchave,cidWF WSRECEIVE NULLPARAM WSCLIENT WSGravaWF
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SetIdWF xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("chave", ::cchave, cchave , "string", .F. , .F., 0 ) 
cSoap += WSSoapValue("idWF", ::cidWF, cidWF , "string", .F. , .F., 0 ) 
cSoap += "</SetIdWF>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/SetIdWF",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://www.cantu.tecnologia.ws/wscotacao/GravaWF.asmx")

::Init()

END WSMETHOD

oXmlRet := NIL
Return .T.


/* -------------------------------------------------------------------------------
WSDL Data Structure ArrayOfString
------------------------------------------------------------------------------- */

WSSTRUCT GravaWF_ArrayOfString
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT GravaWF_ArrayOfString
	::Init()
Return Self

WSMETHOD INIT WSCLIENT GravaWF_ArrayOfString
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT GravaWF_ArrayOfString
	Local oClone := GravaWF_ArrayOfString():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPSEND WSCLIENT GravaWF_ArrayOfString
	Local cSoap := ""
	aEval( ::cstring , {|x| cSoap := cSoap  +  WSSoapValue("string", x , x , "string", .F. , .F., 0 )  } ) 
Return cSoap