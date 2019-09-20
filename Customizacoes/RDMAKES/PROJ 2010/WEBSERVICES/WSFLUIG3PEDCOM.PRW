#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://192.168.205.200:155/ws/WSFLUIG3.apw?WSDL
Gerado em        02/01/16 16:10:32
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function WSWSFLUIG3 ; Return  // "dummy" function - Internal Use 

/* -------------------------------------------------------------------------------
WSDL Service WSWSFLUIG3
------------------------------------------------------------------------------- */

WSCLIENT WSWSFLUIG3

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD SAVESA13
	WSMETHOD SAVESC7

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cCCODIGO                  AS string
	WSDATA   cCNOME                    AS string
	WSDATA   cCNREDUZ                  AS string
	WSDATA   cCLOJA                    AS string
	WSDATA   cCTIPO                    AS string
	WSDATA   cCEND                     AS string
	WSDATA   cCCIDADE                  AS string
	WSDATA   cCESTADO                  AS string
	WSDATA   cCFLUIG                   AS string
	WSDATA   cSAVESA13RESULT           AS string
	WSDATA   cCEMP                     AS string
	WSDATA   cCFIL                     AS string
	WSDATA   cCFORNECE                 AS string
	WSDATA   cCLOJAFOR                 AS string
	WSDATA   cCCONDPAG                 AS string
	WSDATA   cCFILENT                  AS string
	WSDATA   cCPRODUTO                 AS string
	WSDATA   cCQUANTID                 AS string
	WSDATA   cCPRECUNI                 AS string
	WSDATA   cCFORMPGT                 AS string
	WSDATA   cCCLVL                    AS string
	WSDATA   cCCC                      AS string
	WSDATA   cSAVESC7RESULT            AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSFLUIG3
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.131227A-20150409] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSFLUIG3
Return

WSMETHOD RESET WSCLIENT WSWSFLUIG3
	::cCCODIGO           := NIL 
	::cCNOME             := NIL 
	::cCNREDUZ           := NIL 
	::cCLOJA             := NIL 
	::cCTIPO             := NIL 
	::cCEND              := NIL 
	::cCCIDADE           := NIL 
	::cCESTADO           := NIL 
	::cCFLUIG            := NIL 
	::cSAVESA13RESULT    := NIL 
	::cCEMP              := NIL 
	::cCFIL              := NIL 
	::cCFORNECE          := NIL 
	::cCLOJAFOR          := NIL 
	::cCCONDPAG          := NIL 
	::cCFILENT           := NIL 
	::cCPRODUTO          := NIL 
	::cCQUANTID          := NIL 
	::cCPRECUNI          := NIL 
	::cCFORMPGT          := NIL 
	::cCCLVL             := NIL 
	::cCCC               := NIL 
	::cSAVESC7RESULT     := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSFLUIG3
Local oClone := WSWSFLUIG3():New()
	oClone:_URL          := ::_URL 
	oClone:cCCODIGO      := ::cCCODIGO
	oClone:cCNOME        := ::cCNOME
	oClone:cCNREDUZ      := ::cCNREDUZ
	oClone:cCLOJA        := ::cCLOJA
	oClone:cCTIPO        := ::cCTIPO
	oClone:cCEND         := ::cCEND
	oClone:cCCIDADE      := ::cCCIDADE
	oClone:cCESTADO      := ::cCESTADO
	oClone:cCFLUIG       := ::cCFLUIG
	oClone:cSAVESA13RESULT := ::cSAVESA13RESULT
	oClone:cCEMP         := ::cCEMP
	oClone:cCFIL         := ::cCFIL
	oClone:cCFORNECE     := ::cCFORNECE
	oClone:cCLOJAFOR     := ::cCLOJAFOR
	oClone:cCCONDPAG     := ::cCCONDPAG
	oClone:cCFILENT      := ::cCFILENT
	oClone:cCPRODUTO     := ::cCPRODUTO
	oClone:cCQUANTID     := ::cCQUANTID
	oClone:cCPRECUNI     := ::cCPRECUNI
	oClone:cCFORMPGT     := ::cCFORMPGT
	oClone:cCCLVL        := ::cCCLVL
	oClone:cCCC          := ::cCCC
	oClone:cSAVESC7RESULT := ::cSAVESC7RESULT
Return oClone

// WSDL Method SAVESA13 of Service WSWSFLUIG3

WSMETHOD SAVESA13 WSSEND cCCODIGO,cCNOME,cCNREDUZ,cCLOJA,cCTIPO,cCEND,cCCIDADE,cCESTADO,cCFLUIG WSRECEIVE cSAVESA13RESULT WSCLIENT WSWSFLUIG3
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAVESA13 xmlns="http://200.195.136.59:1155/">'
cSoap += WSSoapValue("CCODIGO", ::cCCODIGO, cCCODIGO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNOME", ::cCNOME, cCNOME , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CNREDUZ", ::cCNREDUZ, cCNREDUZ , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CLOJA", ::cCLOJA, cCLOJA , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CTIPO", ::cCTIPO, cCTIPO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CEND", ::cCEND, cCEND , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCIDADE", ::cCCIDADE, cCCIDADE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CESTADO", ::cCESTADO, cCESTADO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFLUIG", ::cCFLUIG, cCFLUIG , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SAVESA13>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.195.136.59:1155/SAVESA13",; 
	"DOCUMENT","http://200.195.136.59:1155/",,"1.031217",; 
	"http://200.195.136.59:1155/ws/WSFLUIG3.apw")

::Init()
::cSAVESA13RESULT    :=  WSAdvValue( oXmlRet,"_SAVESA13RESPONSE:_SAVESA13RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method SAVESC7 of Service WSWSFLUIG3

WSMETHOD SAVESC7 WSSEND cCEMP,cCFIL,cCFORNECE,cCLOJAFOR,cCCONDPAG,cCFILENT,cCPRODUTO,cCQUANTID,cCPRECUNI,cCFORMPGT,cCCLVL,cCCC WSRECEIVE cSAVESC7RESULT WSCLIENT WSWSFLUIG3
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<SAVESC7 xmlns="http://200.195.136.59:1155/">'
cSoap += WSSoapValue("CEMP", ::cCEMP, cCEMP , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFIL", ::cCFIL, cCFIL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFORNECE", ::cCFORNECE, cCFORNECE , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CLOJAFOR", ::cCLOJAFOR, cCLOJAFOR , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCONDPAG", ::cCCONDPAG, cCCONDPAG , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFILENT", ::cCFILENT, cCFILENT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CPRODUTO", ::cCPRODUTO, cCPRODUTO , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CQUANTID", ::cCQUANTID, cCQUANTID , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CPRECUNI", ::cCPRECUNI, cCPRECUNI , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CFORMPGT", ::cCFORMPGT, cCFORMPGT , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCLVL", ::cCCLVL, cCCLVL , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("CCC", ::cCCC, cCCC , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</SAVESC7>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://200.195.136.59:1155/SAVESC7",; 
	"DOCUMENT","http://200.195.136.59:1155/",,"1.031217",; 
	"http://200.195.136.59:1155/ws/WSFLUIG3.apw")

::Init()
::cSAVESC7RESULT     :=  WSAdvValue( oXmlRet,"_SAVESC7RESPONSE:_SAVESC7RESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.



