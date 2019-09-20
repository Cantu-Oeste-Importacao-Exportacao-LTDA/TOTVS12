#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://200.219.151.50:10190/WSColetor
Gerado em        11/01/11 17:02:54
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.110315
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _PLKLLLS ; Return  // "dummy" function - Internal Use  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* -------------------------------------------------------------------------------
WSDL Service WSWSColetor
------------------------------------------------------------------------------- */

WSCLIENT WSWSColetor

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD EnviarDados
	WSMETHOD AtualizarDados
	WSMETHOD ExcluirRegistro
	WSMETHOD BuscarLoteVigencia
	WSMETHOD BuscarLoteControle
	WSMETHOD buscaValoresCampoTabela

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   oWSLote                   AS WSColetor_ipControle
	WSDATA   oWSResult                 AS WSColetor_ListaErros
	WSDATA   nIdentificadorLote        AS int
	WSDATA   cIdentificadorTabela      AS string
	WSDATA   cDescricaoCampo           AS string
	WSDATA   cValor                    AS string
	WSDATA   cVigenciaDe               AS dateTime
	WSDATA   cVigenciaAte              AS dateTime
	WSDATA   nidentificador_tabela     AS int
	WSDATA   cdescricao_campo          AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSWSColetor
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.100812P-20101125] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSWSColetor
	::oWSLote            := WSColetor_IPCONTROLE():New()
	::oWSResult          := WSColetor_LISTAERROS():New()
Return

WSMETHOD RESET WSCLIENT WSWSColetor
	::oWSLote            := NIL 
	::oWSResult          := NIL 
	::nIdentificadorLote := NIL 
	::cIdentificadorTabela := NIL 
	::cDescricaoCampo    := NIL 
	::cValor             := NIL 
	::cVigenciaDe        := NIL 
	::cVigenciaAte       := NIL 
	::nidentificador_tabela := NIL 
	::cdescricao_campo   := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSWSColetor
Local oClone := WSWSColetor():New()
	oClone:_URL          := ::_URL 
	oClone:oWSLote       :=  IIF(::oWSLote = NIL , NIL ,::oWSLote:Clone() )
	oClone:oWSResult     :=  IIF(::oWSResult = NIL , NIL ,::oWSResult:Clone() )
	oClone:nIdentificadorLote := ::nIdentificadorLote
	oClone:cIdentificadorTabela := ::cIdentificadorTabela
	oClone:cDescricaoCampo := ::cDescricaoCampo
	oClone:cValor        := ::cValor
	oClone:cVigenciaDe   := ::cVigenciaDe
	oClone:cVigenciaAte  := ::cVigenciaAte
	oClone:nidentificador_tabela := ::nidentificador_tabela
	oClone:cdescricao_campo := ::cdescricao_campo
Return oClone

// WSDL Method EnviarDados of Service WSWSColetor

WSMETHOD EnviarDados WSSEND oWSLote WSRECEIVE oWSResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___EnviarDados xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Lote", ::oWSLote, oWSLote , "ipControle", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___EnviarDados>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#EnviarDados",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::oWSResult:SoapRecv( WSAdvValue( oXmlRet,"_WSCOLETOR___ENVIARDADOSRESPONSE:_RESULT","ListaErros",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method AtualizarDados of Service WSWSColetor

WSMETHOD AtualizarDados WSSEND nIdentificadorLote,cIdentificadorTabela,cDescricaoCampo,cValor,oWSLote WSRECEIVE oWSResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___AtualizarDados xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("IdentificadorLote", ::nIdentificadorLote, nIdentificadorLote , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IdentificadorTabela", ::cIdentificadorTabela, cIdentificadorTabela , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DescricaoCampo", ::cDescricaoCampo, cDescricaoCampo , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Valor", ::cValor, cValor , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Lote", ::oWSLote, oWSLote , "ipControle", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___AtualizarDados>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#AtualizarDados",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::oWSResult:SoapRecv( WSAdvValue( oXmlRet,"_WSCOLETOR___ATUALIZARDADOSRESPONSE:_RESULT","ListaErros",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExcluirRegistro of Service WSWSColetor

WSMETHOD ExcluirRegistro WSSEND nIdentificadorLote,cIdentificadorTabela,cDescricaoCampo,cValor WSRECEIVE lResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___ExcluirRegistro xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("IdentificadorLote", ::nIdentificadorLote, nIdentificadorLote , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("IdentificadorTabela", ::cIdentificadorTabela, cIdentificadorTabela , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("DescricaoCampo", ::cDescricaoCampo, cDescricaoCampo , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("Valor", ::cValor, cValor , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___ExcluirRegistro>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#ExcluirRegistro",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::lResult            :=  WSAdvValue( oXmlRet,"_WSCOLETOR___EXCLUIRREGISTRORESPONSE:_RESULT:TEXT","boolean",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarLoteVigencia of Service WSWSColetor

WSMETHOD BuscarLoteVigencia WSSEND cVigenciaDe,cVigenciaAte WSRECEIVE oWSResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___BuscarLoteVigencia xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("VigenciaDe", ::cVigenciaDe, cVigenciaDe , "dateTime", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("VigenciaAte", ::cVigenciaAte, cVigenciaAte , "dateTime", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___BuscarLoteVigencia>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#BuscarLoteVigencia",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::oWSResult:SoapRecv( WSAdvValue( oXmlRet,"_WSCOLETOR___BUSCARLOTEVIGENCIARESPONSE:_RESULT","ListaControleResult",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method BuscarLoteControle of Service WSWSColetor

WSMETHOD BuscarLoteControle WSSEND nLote WSRECEIVE oWSResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___BuscarLoteControle xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("Lote", ::nLote, nLote , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___BuscarLoteControle>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#BuscarLoteControle",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::oWSResult:SoapRecv( WSAdvValue( oXmlRet,"_WSCOLETOR___BUSCARLOTECONTROLERESPONSE:_RESULT","controleResult",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method buscaValoresCampoTabela of Service WSWSColetor

WSMETHOD buscaValoresCampoTabela WSSEND nlote,nidentificador_tabela,cdescricao_campo,cvalor WSRECEIVE oWSResult WSCLIENT WSWSColetor
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<WSColetor___buscaValoresCampoTabela xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("lote", ::nlote, nlote , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("identificador_tabela", ::nidentificador_tabela, nidentificador_tabela , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("descricao_campo", ::cdescricao_campo, cdescricao_campo , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("valor", ::cvalor, cvalor , "string", .T. , .F., 0 , NIL, .F.) 
cSoap += "</WSColetor___buscaValoresCampoTabela>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"urn:WebServiceColetor-WSColetor#buscaValoresCampoTabela",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"http://200.219.151.50:10190/WSColetor?service=WSColetor")

::Init()
::oWSResult:SoapRecv( WSAdvValue( oXmlRet,"_WSCOLETOR___BUSCAVALORESCAMPOTABELARESPONSE:_RESULT","ListaIntegracaoValoresCampoTabela",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ipControle

WSSTRUCT WSColetor_ipControle
	WSDATA   cvigenciaDe               AS dateTime OPTIONAL
	WSDATA   cvigenciaAte              AS dateTime OPTIONAL
	WSDATA   nlote                     AS int OPTIONAL
	WSDATA   cstatus                   AS string OPTIONAL
	WSDATA   oWSTabelas                AS WSColetor_ListaTabelas OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ipControle
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ipControle
Return

WSMETHOD CLONE WSCLIENT WSColetor_ipControle
	Local oClone := WSColetor_ipControle():NEW()
	oClone:cvigenciaDe          := ::cvigenciaDe
	oClone:cvigenciaAte         := ::cvigenciaAte
	oClone:nlote                := ::nlote
	oClone:cstatus              := ::cstatus
	oClone:oWSTabelas           := IIF(::oWSTabelas = NIL , NIL , ::oWSTabelas:Clone() )
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSColetor_ipControle
	Local cSoap := ""
	cSoap += WSSoapValue("vigenciaDe", ::cvigenciaDe, ::cvigenciaDe , "dateTime", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("vigenciaAte", ::cvigenciaAte, ::cvigenciaAte , "dateTime", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("lote", ::nlote, ::nlote , "int", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("status", ::cstatus, ::cstatus , "string", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("Tabelas", ::oWSTabelas, ::oWSTabelas , "ListaTabelas", .F. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ListaErros

WSSTRUCT WSColetor_ListaErros
	WSDATA   cstring                   AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ListaErros
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ListaErros
	::cstring              := {} // Array Of  ""
Return

WSMETHOD CLONE WSCLIENT WSColetor_ListaErros
	Local oClone := WSColetor_ListaErros():NEW()
	oClone:cstring              := IIf(::cstring <> NIL , aClone(::cstring) , NIL )
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT WSColetor_ListaErros
	Local oNodes1 :=  WSAdvValue( oResponse,"_STRING","string",{},NIL,.T.,"S",NIL,"a") 
	::Init()
	If oResponse = NIL ; Return ; Endif 
	aEval(oNodes1 , { |x| aadd(::cstring ,  x:TEXT  ) } )
Return

// WSDL Data Structure ListaTabelas

WSSTRUCT WSColetor_ListaTabelas
	WSDATA   oWSipTabela               AS WSColetor_ipTabela OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ListaTabelas
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ListaTabelas
	::oWSipTabela          := {} // Array Of  WSColetor_IPTABELA():New()
Return

WSMETHOD CLONE WSCLIENT WSColetor_ListaTabelas
	Local oClone := WSColetor_ListaTabelas():NEW()
	oClone:oWSipTabela := NIL
	If ::oWSipTabela <> NIL 
		oClone:oWSipTabela := {}
		aEval( ::oWSipTabela , { |x| aadd( oClone:oWSipTabela , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSColetor_ListaTabelas
	Local cSoap := ""
	aEval( ::oWSipTabela , {|x| cSoap := cSoap  +  WSSoapValue("ipTabela", x , x , "ipTabela", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure ipTabela

WSSTRUCT WSColetor_ipTabela
	WSDATA   nidentificador            AS int OPTIONAL
	WSDATA   oWScampos                 AS WSColetor_ListaCampos OPTIONAL
	WSDATA   nidentificadorOperacao    AS int OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ipTabela
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ipTabela
Return

WSMETHOD CLONE WSCLIENT WSColetor_ipTabela
	Local oClone := WSColetor_ipTabela():NEW()
	oClone:nidentificador       := ::nidentificador
	oClone:oWScampos            := IIF(::oWScampos = NIL , NIL , ::oWScampos:Clone() )
	oClone:nidentificadorOperacao := ::nidentificadorOperacao
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSColetor_ipTabela
	Local cSoap := ""
	cSoap += WSSoapValue("identificador", ::nidentificador, ::nidentificador , "int", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("campos", ::oWScampos, ::oWScampos , "ListaCampos", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("identificadorOperacao", ::nidentificadorOperacao, ::nidentificadorOperacao , "int", .F. , .F., 0 , NIL, .F.) 
Return cSoap

// WSDL Data Structure ListaCampos

WSSTRUCT WSColetor_ListaCampos
	WSDATA   oWSipCampo                AS WSColetor_ipCampo OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ListaCampos
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ListaCampos
	::oWSipCampo           := {} // Array Of  WSColetor_IPCAMPO():New()
Return

WSMETHOD CLONE WSCLIENT WSColetor_ListaCampos
	
	Local oClone := WSColetor_ListaCampos():NEW()
	oClone:oWSipCampo := NIL
	If ::oWSipCampo <> NIL 
		oClone:oWSipCampo := {}
		aEval( ::oWSipCampo , { |x| aadd( oClone:oWSipCampo , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSColetor_ListaCampos
	Local cSoap := ""
	aEval( ::oWSipCampo , {|x| cSoap := cSoap  +  WSSoapValue("ipCampo", x , x , "ipCampo", .F. , .F., 0 , NIL, .F.)  } ) 
Return cSoap

// WSDL Data Structure ipCampo

WSSTRUCT WSColetor_ipCampo
	WSDATA   nsequencia                AS int OPTIONAL
	WSDATA   cvalor                    AS string OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPSEND
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT WSColetor_ipCampo
	::Init()
Return Self

WSMETHOD INIT WSCLIENT WSColetor_ipCampo
Return

WSMETHOD CLONE WSCLIENT WSColetor_ipCampo
	Local oClone := WSColetor_ipCampo():NEW()
	oClone:nsequencia           := ::nsequencia
	oClone:cvalor               := ::cvalor
Return oClone

WSMETHOD SOAPSEND WSCLIENT WSColetor_ipCampo
	Local cSoap := ""
	cSoap += WSSoapValue("sequencia", ::nsequencia, ::nsequencia , "int", .F. , .F., 0 , NIL, .F.) 
	cSoap += WSSoapValue("valor", ::cvalor, ::cvalor , "string", .F. , .F., 0 , NIL, .F.) 
Return cSoap


