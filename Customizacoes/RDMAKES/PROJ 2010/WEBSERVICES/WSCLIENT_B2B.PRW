#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"

/* ===============================================================================
WSDL Location    http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx?WSDL
Gerado em        02/25/14 09:08:54
Observações      Código-Fonte gerado por ADVPL WSDL Client 1.120703
                 Alterações neste arquivo podem causar funcionamento incorreto
                 e serão perdidas caso o código-fonte seja gerado novamente.
=============================================================================== */

User Function _KDRSBFB ; Return  // "dummy" function - Internal Use    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* -------------------------------------------------------------------------------
WSDL Service WSVCommString
------------------------------------------------------------------------------- */

WSCLIENT WSVCommString

	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD RESET
	WSMETHOD CLONE
	WSMETHOD Authenticate
	WSMETHOD GetMethods
	WSMETHOD ImportOrderDuplicate
	WSMETHOD ImportProductNoSku
	WSMETHOD ImportProductSku
	WSMETHOD ImportProduct
	WSMETHOD ImportProductSkuPrice
	WSMETHOD ImportProductXProductVariantGroup
	WSMETHOD ImportProductXProductBox
	WSMETHOD ImportProductSkuAddImages
	WSMETHOD ImportProductBrand
	WSMETHOD ImportProductType
	WSMETHOD ImportProductLine
	WSMETHOD ImportProductSupplier
	WSMETHOD ImportProfile
	WSMETHOD ImportProfileXCompany
	WSMETHOD ImportPriceTable
	WSMETHOD ImportCatalog
	WSMETHOD ImportCatalogXDept
	WSMETHOD ImportCatalogXProduct
	WSMETHOD ImportDept
	WSMETHOD ImportDeptXProduct
	WSMETHOD DeleteDeptXProduct
	WSMETHOD ImportCompany
	WSMETHOD ImportCompanyAddress
	WSMETHOD ImportShippingMethod
	WSMETHOD ExportCompany
	WSMETHOD ExportCompanyAddress
	WSMETHOD ExportCompanyActivity
	WSMETHOD ExportCompanyReference
	WSMETHOD ExportOrder
	WSMETHOD ExportOrderItem
	WSMETHOD ExportOrderXBilletCheckPayTime
	WSMETHOD ExportOrderPaymentAuthorization
	WSMETHOD UpdateCompanyStatus
	WSMETHOD UpdateCompanySalesSector
	WSMETHOD UpdateCompanyLimit
	WSMETHOD UpdateCompanySync
	WSMETHOD UpdateCompanyActiveStatus
	WSMETHOD UpdateCustomerSync
	WSMETHOD UpdateProductSkuInventory
	WSMETHOD UpdateProductDeptMain
	WSMETHOD UpdateOrderStatus
	WSMETHOD UpdateOrderSync
	WSMETHOD UpdateShippingMethodSync
	WSMETHOD ImportUser
	WSMETHOD ImportCompanyXUser
	WSMETHOD ExportCustomer
	WSMETHOD ExportCustomerAddress
	WSMETHOD ExportShippingMethod
	WSMETHOD GetCompanyDocumentsWebPath
	WSMETHOD ImportTSProductGroup
	WSMETHOD ImportTSProductNCM
	WSMETHOD ImportTSGroupXProduct
	WSMETHOD ImportTSCompanyGroup
	WSMETHOD ImportTSCompanyGroupICMS
	WSMETHOD ImportTSGroupXCompany
	WSMETHOD ImportTSCompanyDiscount
	WSMETHOD ImportDistributionCenter
	WSMETHOD ImportDistributionCenterXCompany
	WSMETHOD DeleteDistributionCenterXCompany
	WSMETHOD ImportDistributionCenterXShippingMethod
	WSMETHOD DeleteDistributionCenterXShippingMethod

	WSDATA   _URL                      AS String
	WSDATA   _HEADOUT                  AS Array of String
	WSDATA   _COOKIES                  AS Array of String
	WSDATA   cuserName                 AS string
	WSDATA   cpassword                 AS string
	WSDATA   cAuthenticateResult       AS string
	WSDATA   oWSGetMethodsResult       AS VCommString_ArrayOfAnyType
	WSDATA   csessionId                AS string
	WSDATA   ctypeXml                  AS string
	WSDATA   cImportOrderDuplicateResult AS string
	WSDATA   cImportProductNoSkuResult AS string
	WSDATA   cImportProductSkuResult   AS string
	WSDATA   cImportProductResult      AS string
	WSDATA   cImportProductSkuPriceResult AS string
	WSDATA   cImportProductXProductVariantGroupResult AS string
	WSDATA   cImportProductXProductBoxResult AS string
	WSDATA   cImportProductSkuAddImagesResult AS string
	WSDATA   cImportProductBrandResult AS string
	WSDATA   cImportProductTypeResult  AS string
	WSDATA   cImportProductLineResult  AS string
	WSDATA   cImportProductSupplierResult AS string
	WSDATA   cImportProfileResult      AS string
	WSDATA   cImportProfileXCompanyResult AS string
	WSDATA   cImportPriceTableResult   AS string
	WSDATA   cImportCatalogResult      AS string
	WSDATA   cImportCatalogXDeptResult AS string
	WSDATA   cImportCatalogXProductResult AS string
	WSDATA   cImportDeptResult         AS string
	WSDATA   cImportDeptXProductResult AS string
	WSDATA   cDeleteDeptXProductResult AS string
	WSDATA   cImportCompanyResult      AS string
	WSDATA   cImportCompanyAddressResult AS string
	WSDATA   cImportShippingMethodResult AS string
	WSDATA   cExportCompanyResult      AS string
	WSDATA   nidCompanySite            AS int
	WSDATA   cExportCompanyAddressResult AS string
	WSDATA   cExportCompanyActivityResult AS string
	WSDATA   cExportCompanyReferenceResult AS string
	WSDATA   cExportOrderResult        AS string
	WSDATA   nidOrder                  AS int
	WSDATA   cExportOrderItemResult    AS string
	WSDATA   cExportOrderXBilletCheckPayTimeResult AS string
	WSDATA   cExportOrderPaymentAuthorizationResult AS string
	WSDATA   cUpdateCompanyStatusResult AS string
	WSDATA   cUpdateCompanySalesSectorResult AS string
	WSDATA   cUpdateCompanyLimitResult AS string
	WSDATA   cUpdateCompanySyncResult  AS string
	WSDATA   cUpdateCompanyActiveStatusResult AS string
	WSDATA   cUpdateCustomerSyncResult AS string
	WSDATA   cUpdateProductSkuInventoryResult AS string
	WSDATA   cUpdateProductDeptMainResult AS string
	WSDATA   cUpdateOrderStatusResult  AS string
	WSDATA   cUpdateOrderSyncResult    AS string
	WSDATA   cUpdateShippingMethodSyncResult AS string
	WSDATA   cImportUserResult         AS string
	WSDATA   cImportCompanyXUserResult AS string
	WSDATA   cExportCustomerResult     AS string
	WSDATA   cExportCustomerAddressResult AS string
	WSDATA   cExportShippingMethodResult AS string
	WSDATA   cGetCompanyDocumentsWebPathResult AS string
	WSDATA   cImportTSProductGroupResult AS string
	WSDATA   cImportTSProductNCMResult AS string
	WSDATA   cImportTSGroupXProductResult AS string
	WSDATA   cImportTSCompanyGroupResult AS string
	WSDATA   cImportTSCompanyGroupICMSResult AS string
	WSDATA   cImportTSGroupXCompanyResult AS string
	WSDATA   cImportTSCompanyDiscountResult AS string
	WSDATA   cImportDistributionCenterResult AS string
	WSDATA   cImportDistributionCenterXCompanyResult AS string
	WSDATA   cDeleteDistributionCenterXCompanyResult AS string
	WSDATA   cImportDistributionCenterXShippingMethodResult AS string
	WSDATA   cDeleteDistributionCenterXShippingMethodResult AS string

ENDWSCLIENT

WSMETHOD NEW WSCLIENT WSVCommString
::Init()
If !FindFunction("XMLCHILDEX")
	UserException("O Código-Fonte Client atual requer os executáveis do Protheus Build [7.00.121227P-20130604] ou superior. Atualize o Protheus ou gere o Código-Fonte novamente utilizando o Build atual.")
EndIf
Return Self

WSMETHOD INIT WSCLIENT WSVCommString
	::oWSGetMethodsResult := VCommString_ARRAYOFANYTYPE():New()
Return

WSMETHOD RESET WSCLIENT WSVCommString
	::cuserName          := NIL 
	::cpassword          := NIL 
	::cAuthenticateResult := NIL 
	::oWSGetMethodsResult := NIL 
	::csessionId         := NIL 
	::ctypeXml           := NIL 
	::cImportOrderDuplicateResult := NIL 
	::cImportProductNoSkuResult := NIL 
	::cImportProductSkuResult := NIL 
	::cImportProductResult := NIL 
	::cImportProductSkuPriceResult := NIL 
	::cImportProductXProductVariantGroupResult := NIL 
	::cImportProductXProductBoxResult := NIL 
	::cImportProductSkuAddImagesResult := NIL 
	::cImportProductBrandResult := NIL 
	::cImportProductTypeResult := NIL 
	::cImportProductLineResult := NIL 
	::cImportProductSupplierResult := NIL 
	::cImportProfileResult := NIL 
	::cImportProfileXCompanyResult := NIL 
	::cImportPriceTableResult := NIL 
	::cImportCatalogResult := NIL 
	::cImportCatalogXDeptResult := NIL 
	::cImportCatalogXProductResult := NIL 
	::cImportDeptResult  := NIL 
	::cImportDeptXProductResult := NIL 
	::cDeleteDeptXProductResult := NIL 
	::cImportCompanyResult := NIL 
	::cImportCompanyAddressResult := NIL 
	::cImportShippingMethodResult := NIL 
	::cExportCompanyResult := NIL 
	::nidCompanySite     := NIL 
	::cExportCompanyAddressResult := NIL 
	::cExportCompanyActivityResult := NIL 
	::cExportCompanyReferenceResult := NIL 
	::cExportOrderResult := NIL 
	::nidOrder           := NIL 
	::cExportOrderItemResult := NIL 
	::cExportOrderXBilletCheckPayTimeResult := NIL 
	::cExportOrderPaymentAuthorizationResult := NIL 
	::cUpdateCompanyStatusResult := NIL 
	::cUpdateCompanySalesSectorResult := NIL 
	::cUpdateCompanyLimitResult := NIL 
	::cUpdateCompanySyncResult := NIL 
	::cUpdateCompanyActiveStatusResult := NIL 
	::cUpdateCustomerSyncResult := NIL 
	::cUpdateProductSkuInventoryResult := NIL 
	::cUpdateProductDeptMainResult := NIL 
	::cUpdateOrderStatusResult := NIL 
	::cUpdateOrderSyncResult := NIL 
	::cUpdateShippingMethodSyncResult := NIL 
	::cImportUserResult  := NIL 
	::cImportCompanyXUserResult := NIL 
	::cExportCustomerResult := NIL 
	::cExportCustomerAddressResult := NIL 
	::cExportShippingMethodResult := NIL 
	::cGetCompanyDocumentsWebPathResult := NIL 
	::cImportTSProductGroupResult := NIL 
	::cImportTSProductNCMResult := NIL 
	::cImportTSGroupXProductResult := NIL 
	::cImportTSCompanyGroupResult := NIL 
	::cImportTSCompanyGroupICMSResult := NIL 
	::cImportTSGroupXCompanyResult := NIL 
	::cImportTSCompanyDiscountResult := NIL 
	::cImportDistributionCenterResult := NIL 
	::cImportDistributionCenterXCompanyResult := NIL 
	::cDeleteDistributionCenterXCompanyResult := NIL 
	::cImportDistributionCenterXShippingMethodResult := NIL 
	::cDeleteDistributionCenterXShippingMethodResult := NIL 
	::Init()
Return

WSMETHOD CLONE WSCLIENT WSVCommString
Local oClone := WSVCommString():New()
	oClone:_URL          := ::_URL 
	oClone:cuserName     := ::cuserName
	oClone:cpassword     := ::cpassword
	oClone:cAuthenticateResult := ::cAuthenticateResult
	oClone:oWSGetMethodsResult :=  IIF(::oWSGetMethodsResult = NIL , NIL ,::oWSGetMethodsResult:Clone() )
	oClone:csessionId    := ::csessionId
	oClone:ctypeXml      := ::ctypeXml
	oClone:cImportOrderDuplicateResult := ::cImportOrderDuplicateResult
	oClone:cImportProductNoSkuResult := ::cImportProductNoSkuResult
	oClone:cImportProductSkuResult := ::cImportProductSkuResult
	oClone:cImportProductResult := ::cImportProductResult
	oClone:cImportProductSkuPriceResult := ::cImportProductSkuPriceResult
	oClone:cImportProductXProductVariantGroupResult := ::cImportProductXProductVariantGroupResult
	oClone:cImportProductXProductBoxResult := ::cImportProductXProductBoxResult
	oClone:cImportProductSkuAddImagesResult := ::cImportProductSkuAddImagesResult
	oClone:cImportProductBrandResult := ::cImportProductBrandResult
	oClone:cImportProductTypeResult := ::cImportProductTypeResult
	oClone:cImportProductLineResult := ::cImportProductLineResult
	oClone:cImportProductSupplierResult := ::cImportProductSupplierResult
	oClone:cImportProfileResult := ::cImportProfileResult
	oClone:cImportProfileXCompanyResult := ::cImportProfileXCompanyResult
	oClone:cImportPriceTableResult := ::cImportPriceTableResult
	oClone:cImportCatalogResult := ::cImportCatalogResult
	oClone:cImportCatalogXDeptResult := ::cImportCatalogXDeptResult
	oClone:cImportCatalogXProductResult := ::cImportCatalogXProductResult
	oClone:cImportDeptResult := ::cImportDeptResult
	oClone:cImportDeptXProductResult := ::cImportDeptXProductResult
	oClone:cDeleteDeptXProductResult := ::cDeleteDeptXProductResult
	oClone:cImportCompanyResult := ::cImportCompanyResult
	oClone:cImportCompanyAddressResult := ::cImportCompanyAddressResult
	oClone:cImportShippingMethodResult := ::cImportShippingMethodResult
	oClone:cExportCompanyResult := ::cExportCompanyResult
	oClone:nidCompanySite := ::nidCompanySite
	oClone:cExportCompanyAddressResult := ::cExportCompanyAddressResult
	oClone:cExportCompanyActivityResult := ::cExportCompanyActivityResult
	oClone:cExportCompanyReferenceResult := ::cExportCompanyReferenceResult
	oClone:cExportOrderResult := ::cExportOrderResult
	oClone:nidOrder      := ::nidOrder
	oClone:cExportOrderItemResult := ::cExportOrderItemResult
	oClone:cExportOrderXBilletCheckPayTimeResult := ::cExportOrderXBilletCheckPayTimeResult
	oClone:cExportOrderPaymentAuthorizationResult := ::cExportOrderPaymentAuthorizationResult
	oClone:cUpdateCompanyStatusResult := ::cUpdateCompanyStatusResult
	oClone:cUpdateCompanySalesSectorResult := ::cUpdateCompanySalesSectorResult
	oClone:cUpdateCompanyLimitResult := ::cUpdateCompanyLimitResult
	oClone:cUpdateCompanySyncResult := ::cUpdateCompanySyncResult
	oClone:cUpdateCompanyActiveStatusResult := ::cUpdateCompanyActiveStatusResult
	oClone:cUpdateCustomerSyncResult := ::cUpdateCustomerSyncResult
	oClone:cUpdateProductSkuInventoryResult := ::cUpdateProductSkuInventoryResult
	oClone:cUpdateProductDeptMainResult := ::cUpdateProductDeptMainResult
	oClone:cUpdateOrderStatusResult := ::cUpdateOrderStatusResult
	oClone:cUpdateOrderSyncResult := ::cUpdateOrderSyncResult
	oClone:cUpdateShippingMethodSyncResult := ::cUpdateShippingMethodSyncResult
	oClone:cImportUserResult := ::cImportUserResult
	oClone:cImportCompanyXUserResult := ::cImportCompanyXUserResult
	oClone:cExportCustomerResult := ::cExportCustomerResult
	oClone:cExportCustomerAddressResult := ::cExportCustomerAddressResult
	oClone:cExportShippingMethodResult := ::cExportShippingMethodResult
	oClone:cGetCompanyDocumentsWebPathResult := ::cGetCompanyDocumentsWebPathResult
	oClone:cImportTSProductGroupResult := ::cImportTSProductGroupResult
	oClone:cImportTSProductNCMResult := ::cImportTSProductNCMResult
	oClone:cImportTSGroupXProductResult := ::cImportTSGroupXProductResult
	oClone:cImportTSCompanyGroupResult := ::cImportTSCompanyGroupResult
	oClone:cImportTSCompanyGroupICMSResult := ::cImportTSCompanyGroupICMSResult
	oClone:cImportTSGroupXCompanyResult := ::cImportTSGroupXCompanyResult
	oClone:cImportTSCompanyDiscountResult := ::cImportTSCompanyDiscountResult
	oClone:cImportDistributionCenterResult := ::cImportDistributionCenterResult
	oClone:cImportDistributionCenterXCompanyResult := ::cImportDistributionCenterXCompanyResult
	oClone:cDeleteDistributionCenterXCompanyResult := ::cDeleteDistributionCenterXCompanyResult
	oClone:cImportDistributionCenterXShippingMethodResult := ::cImportDistributionCenterXShippingMethodResult
	oClone:cDeleteDistributionCenterXShippingMethodResult := ::cDeleteDistributionCenterXShippingMethodResult
Return oClone

// WSDL Method Authenticate of Service WSVCommString

WSMETHOD Authenticate WSSEND cuserName,cpassword WSRECEIVE cAuthenticateResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<Authenticate xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("userName", ::cuserName, cuserName , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("password", ::cpassword, cpassword , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</Authenticate>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/Authenticate",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */
::Init()
::cAuthenticateResult :=  WSAdvValue( oXmlRet,"_AUTHENTICATERESPONSE:_AUTHENTICATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetMethods of Service WSVCommString

WSMETHOD GetMethods WSSEND NULLPARAM WSRECEIVE oWSGetMethodsResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetMethods xmlns="http://tempuri.org/">'
cSoap += "</GetMethods>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GetMethods",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::oWSGetMethodsResult:SoapRecv( WSAdvValue( oXmlRet,"_GETMETHODSRESPONSE:_GETMETHODSRESULT","ArrayOfAnyType",NIL,NIL,NIL,NIL,NIL,NIL) )

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportOrderDuplicate of Service WSVCommString

WSMETHOD ImportOrderDuplicate WSSEND csessionId,ctypeXml WSRECEIVE cImportOrderDuplicateResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportOrderDuplicate xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportOrderDuplicate>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportOrderDuplicate",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportOrderDuplicateResult :=  WSAdvValue( oXmlRet,"_IMPORTORDERDUPLICATERESPONSE:_IMPORTORDERDUPLICATERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductNoSku of Service WSVCommString

WSMETHOD ImportProductNoSku WSSEND csessionId,ctypeXml WSRECEIVE cImportProductNoSkuResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductNoSku xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductNoSku>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductNoSku",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductNoSkuResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTNOSKURESPONSE:_IMPORTPRODUCTNOSKURESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductSku of Service WSVCommString

WSMETHOD ImportProductSku WSSEND csessionId,ctypeXml WSRECEIVE cImportProductSkuResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductSku xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductSku>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductSku",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductSkuResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTSKURESPONSE:_IMPORTPRODUCTSKURESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProduct of Service WSVCommString

WSMETHOD ImportProduct WSSEND csessionId,ctypeXml WSRECEIVE cImportProductResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProduct xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProduct>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProduct",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTRESPONSE:_IMPORTPRODUCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductSkuPrice of Service WSVCommString

WSMETHOD ImportProductSkuPrice WSSEND csessionId,ctypeXml WSRECEIVE cImportProductSkuPriceResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductSkuPrice xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductSkuPrice>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductSkuPrice",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductSkuPriceResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTSKUPRICERESPONSE:_IMPORTPRODUCTSKUPRICERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductXProductVariantGroup of Service WSVCommString

WSMETHOD ImportProductXProductVariantGroup WSSEND csessionId,ctypeXml WSRECEIVE cImportProductXProductVariantGroupResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductXProductVariantGroup xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductXProductVariantGroup>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductXProductVariantGroup",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductXProductVariantGroupResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTXPRODUCTVARIANTGROUPRESPONSE:_IMPORTPRODUCTXPRODUCTVARIANTGROUPRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductXProductBox of Service WSVCommString

WSMETHOD ImportProductXProductBox WSSEND csessionId,ctypeXml WSRECEIVE cImportProductXProductBoxResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductXProductBox xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductXProductBox>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductXProductBox",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductXProductBoxResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTXPRODUCTBOXRESPONSE:_IMPORTPRODUCTXPRODUCTBOXRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductSkuAddImages of Service WSVCommString

WSMETHOD ImportProductSkuAddImages WSSEND csessionId,ctypeXml WSRECEIVE cImportProductSkuAddImagesResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductSkuAddImages xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductSkuAddImages>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductSkuAddImages",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductSkuAddImagesResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTSKUADDIMAGESRESPONSE:_IMPORTPRODUCTSKUADDIMAGESRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductBrand of Service WSVCommString

WSMETHOD ImportProductBrand WSSEND csessionId,ctypeXml WSRECEIVE cImportProductBrandResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductBrand xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductBrand>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductBrand",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductBrandResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTBRANDRESPONSE:_IMPORTPRODUCTBRANDRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductType of Service WSVCommString

WSMETHOD ImportProductType WSSEND csessionId,ctypeXml WSRECEIVE cImportProductTypeResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductType xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductType>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductType",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductTypeResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTTYPERESPONSE:_IMPORTPRODUCTTYPERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductLine of Service WSVCommString

WSMETHOD ImportProductLine WSSEND csessionId,ctypeXml WSRECEIVE cImportProductLineResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductLine xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductLine>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductLine",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductLineResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTLINERESPONSE:_IMPORTPRODUCTLINERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProductSupplier of Service WSVCommString

WSMETHOD ImportProductSupplier WSSEND csessionId,ctypeXml WSRECEIVE cImportProductSupplierResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProductSupplier xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProductSupplier>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProductSupplier",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProductSupplierResult :=  WSAdvValue( oXmlRet,"_IMPORTPRODUCTSUPPLIERRESPONSE:_IMPORTPRODUCTSUPPLIERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProfile of Service WSVCommString

WSMETHOD ImportProfile WSSEND csessionId,ctypeXml WSRECEIVE cImportProfileResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProfile xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProfile>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProfile",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProfileResult :=  WSAdvValue( oXmlRet,"_IMPORTPROFILERESPONSE:_IMPORTPROFILERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportProfileXCompany of Service WSVCommString

WSMETHOD ImportProfileXCompany WSSEND csessionId,ctypeXml WSRECEIVE cImportProfileXCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportProfileXCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportProfileXCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportProfileXCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportProfileXCompanyResult :=  WSAdvValue( oXmlRet,"_IMPORTPROFILEXCOMPANYRESPONSE:_IMPORTPROFILEXCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportPriceTable of Service WSVCommString

WSMETHOD ImportPriceTable WSSEND csessionId,ctypeXml WSRECEIVE cImportPriceTableResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportPriceTable xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportPriceTable>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportPriceTable",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportPriceTableResult :=  WSAdvValue( oXmlRet,"_IMPORTPRICETABLERESPONSE:_IMPORTPRICETABLERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCatalog of Service WSVCommString

WSMETHOD ImportCatalog WSSEND csessionId,ctypeXml WSRECEIVE cImportCatalogResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCatalog xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCatalog>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCatalog",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCatalogResult :=  WSAdvValue( oXmlRet,"_IMPORTCATALOGRESPONSE:_IMPORTCATALOGRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCatalogXDept of Service WSVCommString

WSMETHOD ImportCatalogXDept WSSEND csessionId,ctypeXml WSRECEIVE cImportCatalogXDeptResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCatalogXDept xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCatalogXDept>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCatalogXDept",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCatalogXDeptResult :=  WSAdvValue( oXmlRet,"_IMPORTCATALOGXDEPTRESPONSE:_IMPORTCATALOGXDEPTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCatalogXProduct of Service WSVCommString

WSMETHOD ImportCatalogXProduct WSSEND csessionId,ctypeXml WSRECEIVE cImportCatalogXProductResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCatalogXProduct xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCatalogXProduct>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCatalogXProduct",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCatalogXProductResult :=  WSAdvValue( oXmlRet,"_IMPORTCATALOGXPRODUCTRESPONSE:_IMPORTCATALOGXPRODUCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportDept of Service WSVCommString

WSMETHOD ImportDept WSSEND csessionId,ctypeXml WSRECEIVE cImportDeptResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportDept xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportDept>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportDept",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportDeptResult  :=  WSAdvValue( oXmlRet,"_IMPORTDEPTRESPONSE:_IMPORTDEPTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportDeptXProduct of Service WSVCommString

WSMETHOD ImportDeptXProduct WSSEND csessionId,ctypeXml WSRECEIVE cImportDeptXProductResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportDeptXProduct xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportDeptXProduct>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportDeptXProduct",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportDeptXProductResult :=  WSAdvValue( oXmlRet,"_IMPORTDEPTXPRODUCTRESPONSE:_IMPORTDEPTXPRODUCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeleteDeptXProduct of Service WSVCommString

WSMETHOD DeleteDeptXProduct WSSEND csessionId,ctypeXml WSRECEIVE cDeleteDeptXProductResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeleteDeptXProduct xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</DeleteDeptXProduct>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/DeleteDeptXProduct",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cDeleteDeptXProductResult :=  WSAdvValue( oXmlRet,"_DELETEDEPTXPRODUCTRESPONSE:_DELETEDEPTXPRODUCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCompany of Service WSVCommString

WSMETHOD ImportCompany WSSEND csessionId,ctypeXml WSRECEIVE cImportCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCompanyResult :=  WSAdvValue( oXmlRet,"_IMPORTCOMPANYRESPONSE:_IMPORTCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCompanyAddress of Service WSVCommString

WSMETHOD ImportCompanyAddress WSSEND csessionId,ctypeXml WSRECEIVE cImportCompanyAddressResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCompanyAddress xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCompanyAddress>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCompanyAddress",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCompanyAddressResult :=  WSAdvValue( oXmlRet,"_IMPORTCOMPANYADDRESSRESPONSE:_IMPORTCOMPANYADDRESSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportShippingMethod of Service WSVCommString

WSMETHOD ImportShippingMethod WSSEND csessionId,ctypeXml WSRECEIVE cImportShippingMethodResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportShippingMethod xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportShippingMethod>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportShippingMethod",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportShippingMethodResult :=  WSAdvValue( oXmlRet,"_IMPORTSHIPPINGMETHODRESPONSE:_IMPORTSHIPPINGMETHODRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCompany of Service WSVCommString

WSMETHOD ExportCompany WSSEND csessionId WSRECEIVE cExportCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCompanyResult :=  WSAdvValue( oXmlRet,"_EXPORTCOMPANYRESPONSE:_EXPORTCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCompanyAddress of Service WSVCommString

WSMETHOD ExportCompanyAddress WSSEND csessionId,nidCompanySite WSRECEIVE cExportCompanyAddressResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCompanyAddress xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("idCompanySite", ::nidCompanySite, nidCompanySite , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCompanyAddress>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCompanyAddress",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCompanyAddressResult :=  WSAdvValue( oXmlRet,"_EXPORTCOMPANYADDRESSRESPONSE:_EXPORTCOMPANYADDRESSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCompanyActivity of Service WSVCommString

WSMETHOD ExportCompanyActivity WSSEND csessionId WSRECEIVE cExportCompanyActivityResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCompanyActivity xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCompanyActivity>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCompanyActivity",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCompanyActivityResult :=  WSAdvValue( oXmlRet,"_EXPORTCOMPANYACTIVITYRESPONSE:_EXPORTCOMPANYACTIVITYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCompanyReference of Service WSVCommString

WSMETHOD ExportCompanyReference WSSEND csessionId WSRECEIVE cExportCompanyReferenceResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCompanyReference xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCompanyReference>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCompanyReference",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCompanyReferenceResult :=  WSAdvValue( oXmlRet,"_EXPORTCOMPANYREFERENCERESPONSE:_EXPORTCOMPANYREFERENCERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportOrder of Service WSVCommString

WSMETHOD ExportOrder WSSEND csessionId WSRECEIVE cExportOrderResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportOrder xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportOrder>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportOrder",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportOrderResult :=  WSAdvValue( oXmlRet,"_EXPORTORDERRESPONSE:_EXPORTORDERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportOrderItem of Service WSVCommString

WSMETHOD ExportOrderItem WSSEND csessionId,nidOrder WSRECEIVE cExportOrderItemResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportOrderItem xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("idOrder", ::nidOrder, nidOrder , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ExportOrderItem>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportOrderItem",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportOrderItemResult :=  WSAdvValue( oXmlRet,"_EXPORTORDERITEMRESPONSE:_EXPORTORDERITEMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportOrderXBilletCheckPayTime of Service WSVCommString

WSMETHOD ExportOrderXBilletCheckPayTime WSSEND csessionId,nidOrder WSRECEIVE cExportOrderXBilletCheckPayTimeResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportOrderXBilletCheckPayTime xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("idOrder", ::nidOrder, nidOrder , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ExportOrderXBilletCheckPayTime>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportOrderXBilletCheckPayTime",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportOrderXBilletCheckPayTimeResult :=  WSAdvValue( oXmlRet,"_EXPORTORDERXBILLETCHECKPAYTIMERESPONSE:_EXPORTORDERXBILLETCHECKPAYTIMERESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportOrderPaymentAuthorization of Service WSVCommString

WSMETHOD ExportOrderPaymentAuthorization WSSEND csessionId,nidOrder WSRECEIVE cExportOrderPaymentAuthorizationResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportOrderPaymentAuthorization xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("idOrder", ::nidOrder, nidOrder , "int", .T. , .F., 0 , NIL, .F.) 
cSoap += "</ExportOrderPaymentAuthorization>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportOrderPaymentAuthorization",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportOrderPaymentAuthorizationResult :=  WSAdvValue( oXmlRet,"_EXPORTORDERPAYMENTAUTHORIZATIONRESPONSE:_EXPORTORDERPAYMENTAUTHORIZATIONRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCompanyStatus of Service WSVCommString

WSMETHOD UpdateCompanyStatus WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCompanyStatusResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCompanyStatus xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCompanyStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCompanyStatus",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCompanyStatusResult :=  WSAdvValue( oXmlRet,"_UPDATECOMPANYSTATUSRESPONSE:_UPDATECOMPANYSTATUSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCompanySalesSector of Service WSVCommString

WSMETHOD UpdateCompanySalesSector WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCompanySalesSectorResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCompanySalesSector xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCompanySalesSector>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCompanySalesSector",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCompanySalesSectorResult :=  WSAdvValue( oXmlRet,"_UPDATECOMPANYSALESSECTORRESPONSE:_UPDATECOMPANYSALESSECTORRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCompanyLimit of Service WSVCommString

WSMETHOD UpdateCompanyLimit WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCompanyLimitResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCompanyLimit xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCompanyLimit>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCompanyLimit",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCompanyLimitResult :=  WSAdvValue( oXmlRet,"_UPDATECOMPANYLIMITRESPONSE:_UPDATECOMPANYLIMITRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCompanySync of Service WSVCommString

WSMETHOD UpdateCompanySync WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCompanySyncResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCompanySync xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCompanySync>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCompanySync",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCompanySyncResult :=  WSAdvValue( oXmlRet,"_UPDATECOMPANYSYNCRESPONSE:_UPDATECOMPANYSYNCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCompanyActiveStatus of Service WSVCommString

WSMETHOD UpdateCompanyActiveStatus WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCompanyActiveStatusResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCompanyActiveStatus xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCompanyActiveStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCompanyActiveStatus",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCompanyActiveStatusResult :=  WSAdvValue( oXmlRet,"_UPDATECOMPANYACTIVESTATUSRESPONSE:_UPDATECOMPANYACTIVESTATUSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateCustomerSync of Service WSVCommString

WSMETHOD UpdateCustomerSync WSSEND csessionId,ctypeXml WSRECEIVE cUpdateCustomerSyncResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateCustomerSync xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateCustomerSync>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateCustomerSync",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateCustomerSyncResult :=  WSAdvValue( oXmlRet,"_UPDATECUSTOMERSYNCRESPONSE:_UPDATECUSTOMERSYNCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateProductSkuInventory of Service WSVCommString

WSMETHOD UpdateProductSkuInventory WSSEND csessionId,ctypeXml WSRECEIVE cUpdateProductSkuInventoryResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateProductSkuInventory xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateProductSkuInventory>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateProductSkuInventory",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateProductSkuInventoryResult :=  WSAdvValue( oXmlRet,"_UPDATEPRODUCTSKUINVENTORYRESPONSE:_UPDATEPRODUCTSKUINVENTORYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateProductDeptMain of Service WSVCommString

WSMETHOD UpdateProductDeptMain WSSEND csessionId,ctypeXml WSRECEIVE cUpdateProductDeptMainResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateProductDeptMain xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateProductDeptMain>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateProductDeptMain",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateProductDeptMainResult :=  WSAdvValue( oXmlRet,"_UPDATEPRODUCTDEPTMAINRESPONSE:_UPDATEPRODUCTDEPTMAINRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateOrderStatus of Service WSVCommString

WSMETHOD UpdateOrderStatus WSSEND csessionId,ctypeXml WSRECEIVE cUpdateOrderStatusResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateOrderStatus xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateOrderStatus>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateOrderStatus",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateOrderStatusResult :=  WSAdvValue( oXmlRet,"_UPDATEORDERSTATUSRESPONSE:_UPDATEORDERSTATUSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateOrderSync of Service WSVCommString

WSMETHOD UpdateOrderSync WSSEND csessionId,ctypeXml WSRECEIVE cUpdateOrderSyncResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateOrderSync xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateOrderSync>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateOrderSync",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateOrderSyncResult :=  WSAdvValue( oXmlRet,"_UPDATEORDERSYNCRESPONSE:_UPDATEORDERSYNCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method UpdateShippingMethodSync of Service WSVCommString

WSMETHOD UpdateShippingMethodSync WSSEND csessionId,ctypeXml WSRECEIVE cUpdateShippingMethodSyncResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<UpdateShippingMethodSync xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</UpdateShippingMethodSync>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/UpdateShippingMethodSync",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cUpdateShippingMethodSyncResult :=  WSAdvValue( oXmlRet,"_UPDATESHIPPINGMETHODSYNCRESPONSE:_UPDATESHIPPINGMETHODSYNCRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportUser of Service WSVCommString

WSMETHOD ImportUser WSSEND csessionId,ctypeXml WSRECEIVE cImportUserResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportUser xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportUser>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportUser",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportUserResult  :=  WSAdvValue( oXmlRet,"_IMPORTUSERRESPONSE:_IMPORTUSERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportCompanyXUser of Service WSVCommString

WSMETHOD ImportCompanyXUser WSSEND csessionId,ctypeXml WSRECEIVE cImportCompanyXUserResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportCompanyXUser xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportCompanyXUser>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportCompanyXUser",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportCompanyXUserResult :=  WSAdvValue( oXmlRet,"_IMPORTCOMPANYXUSERRESPONSE:_IMPORTCOMPANYXUSERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCustomer of Service WSVCommString

WSMETHOD ExportCustomer WSSEND csessionId WSRECEIVE cExportCustomerResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCustomer xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCustomer>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCustomer",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCustomerResult :=  WSAdvValue( oXmlRet,"_EXPORTCUSTOMERRESPONSE:_EXPORTCUSTOMERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportCustomerAddress of Service WSVCommString

WSMETHOD ExportCustomerAddress WSSEND csessionId WSRECEIVE cExportCustomerAddressResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportCustomerAddress xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportCustomerAddress>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportCustomerAddress",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportCustomerAddressResult :=  WSAdvValue( oXmlRet,"_EXPORTCUSTOMERADDRESSRESPONSE:_EXPORTCUSTOMERADDRESSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ExportShippingMethod of Service WSVCommString

WSMETHOD ExportShippingMethod WSSEND csessionId WSRECEIVE cExportShippingMethodResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ExportShippingMethod xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ExportShippingMethod>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ExportShippingMethod",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cExportShippingMethodResult :=  WSAdvValue( oXmlRet,"_EXPORTSHIPPINGMETHODRESPONSE:_EXPORTSHIPPINGMETHODRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method GetCompanyDocumentsWebPath of Service WSVCommString

WSMETHOD GetCompanyDocumentsWebPath WSSEND csessionId WSRECEIVE cGetCompanyDocumentsWebPathResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<GetCompanyDocumentsWebPath xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</GetCompanyDocumentsWebPath>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/GetCompanyDocumentsWebPath",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cGetCompanyDocumentsWebPathResult :=  WSAdvValue( oXmlRet,"_GETCOMPANYDOCUMENTSWEBPATHRESPONSE:_GETCOMPANYDOCUMENTSWEBPATHRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSProductGroup of Service WSVCommString

WSMETHOD ImportTSProductGroup WSSEND csessionId,ctypeXml WSRECEIVE cImportTSProductGroupResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSProductGroup xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSProductGroup>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSProductGroup",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSProductGroupResult :=  WSAdvValue( oXmlRet,"_IMPORTTSPRODUCTGROUPRESPONSE:_IMPORTTSPRODUCTGROUPRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSProductNCM of Service WSVCommString

WSMETHOD ImportTSProductNCM WSSEND csessionId,ctypeXml WSRECEIVE cImportTSProductNCMResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSProductNCM xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSProductNCM>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSProductNCM",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSProductNCMResult :=  WSAdvValue( oXmlRet,"_IMPORTTSPRODUCTNCMRESPONSE:_IMPORTTSPRODUCTNCMRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSGroupXProduct of Service WSVCommString

WSMETHOD ImportTSGroupXProduct WSSEND csessionId,ctypeXml WSRECEIVE cImportTSGroupXProductResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSGroupXProduct xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSGroupXProduct>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSGroupXProduct",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSGroupXProductResult :=  WSAdvValue( oXmlRet,"_IMPORTTSGROUPXPRODUCTRESPONSE:_IMPORTTSGROUPXPRODUCTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSCompanyGroup of Service WSVCommString

WSMETHOD ImportTSCompanyGroup WSSEND csessionId,ctypeXml WSRECEIVE cImportTSCompanyGroupResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSCompanyGroup xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSCompanyGroup>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSCompanyGroup",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSCompanyGroupResult :=  WSAdvValue( oXmlRet,"_IMPORTTSCOMPANYGROUPRESPONSE:_IMPORTTSCOMPANYGROUPRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSCompanyGroupICMS of Service WSVCommString

WSMETHOD ImportTSCompanyGroupICMS WSSEND csessionId,ctypeXml WSRECEIVE cImportTSCompanyGroupICMSResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSCompanyGroupICMS xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSCompanyGroupICMS>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSCompanyGroupICMS",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSCompanyGroupICMSResult :=  WSAdvValue( oXmlRet,"_IMPORTTSCOMPANYGROUPICMSRESPONSE:_IMPORTTSCOMPANYGROUPICMSRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSGroupXCompany of Service WSVCommString

WSMETHOD ImportTSGroupXCompany WSSEND csessionId,ctypeXml WSRECEIVE cImportTSGroupXCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSGroupXCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSGroupXCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSGroupXCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSGroupXCompanyResult :=  WSAdvValue( oXmlRet,"_IMPORTTSGROUPXCOMPANYRESPONSE:_IMPORTTSGROUPXCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportTSCompanyDiscount of Service WSVCommString

WSMETHOD ImportTSCompanyDiscount WSSEND csessionId,ctypeXml WSRECEIVE cImportTSCompanyDiscountResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportTSCompanyDiscount xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportTSCompanyDiscount>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportTSCompanyDiscount",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportTSCompanyDiscountResult :=  WSAdvValue( oXmlRet,"_IMPORTTSCOMPANYDISCOUNTRESPONSE:_IMPORTTSCOMPANYDISCOUNTRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportDistributionCenter of Service WSVCommString

WSMETHOD ImportDistributionCenter WSSEND csessionId,ctypeXml WSRECEIVE cImportDistributionCenterResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportDistributionCenter xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportDistributionCenter>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportDistributionCenter",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportDistributionCenterResult :=  WSAdvValue( oXmlRet,"_IMPORTDISTRIBUTIONCENTERRESPONSE:_IMPORTDISTRIBUTIONCENTERRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportDistributionCenterXCompany of Service WSVCommString

WSMETHOD ImportDistributionCenterXCompany WSSEND csessionId,ctypeXml WSRECEIVE cImportDistributionCenterXCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportDistributionCenterXCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportDistributionCenterXCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportDistributionCenterXCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportDistributionCenterXCompanyResult :=  WSAdvValue( oXmlRet,"_IMPORTDISTRIBUTIONCENTERXCOMPANYRESPONSE:_IMPORTDISTRIBUTIONCENTERXCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeleteDistributionCenterXCompany of Service WSVCommString

WSMETHOD DeleteDistributionCenterXCompany WSSEND csessionId,ctypeXml WSRECEIVE cDeleteDistributionCenterXCompanyResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeleteDistributionCenterXCompany xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</DeleteDistributionCenterXCompany>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/DeleteDistributionCenterXCompany",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cDeleteDistributionCenterXCompanyResult :=  WSAdvValue( oXmlRet,"_DELETEDISTRIBUTIONCENTERXCOMPANYRESPONSE:_DELETEDISTRIBUTIONCENTERXCOMPANYRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method ImportDistributionCenterXShippingMethod of Service WSVCommString

WSMETHOD ImportDistributionCenterXShippingMethod WSSEND csessionId,ctypeXml WSRECEIVE cImportDistributionCenterXShippingMethodResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<ImportDistributionCenterXShippingMethod xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</ImportDistributionCenterXShippingMethod>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/ImportDistributionCenterXShippingMethod",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cImportDistributionCenterXShippingMethodResult :=  WSAdvValue( oXmlRet,"_IMPORTDISTRIBUTIONCENTERXSHIPPINGMETHODRESPONSE:_IMPORTDISTRIBUTIONCENTERXSHIPPINGMETHODRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.

// WSDL Method DeleteDistributionCenterXShippingMethod of Service WSVCommString

WSMETHOD DeleteDistributionCenterXShippingMethod WSSEND csessionId,ctypeXml WSRECEIVE cDeleteDistributionCenterXShippingMethodResult WSCLIENT WSVCommString
Local cSoap := "" , oXmlRet

BEGIN WSMETHOD

cSoap += '<DeleteDistributionCenterXShippingMethod xmlns="http://tempuri.org/">'
cSoap += WSSoapValue("sessionId", ::csessionId, csessionId , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += WSSoapValue("typeXml", ::ctypeXml, ctypeXml , "string", .F. , .F., 0 , NIL, .F.) 
cSoap += "</DeleteDistributionCenterXShippingMethod>"

oXmlRet := SvcSoapCall(	Self,cSoap,; 
	"http://tempuri.org/DeleteDistributionCenterXShippingMethod",; 
	"DOCUMENT","http://tempuri.org/",,,; 
	"https://192.168.205.169/services/vcommstring.asmx")	
	/* Gustavo 26/03/2015 - Alterado o servidor do B2b para estrutura interna.
	"http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx")
    */

::Init()
::cDeleteDistributionCenterXShippingMethodResult :=  WSAdvValue( oXmlRet,"_DELETEDISTRIBUTIONCENTERXSHIPPINGMETHODRESPONSE:_DELETEDISTRIBUTIONCENTERXSHIPPINGMETHODRESULT:TEXT","string",NIL,NIL,NIL,NIL,NIL,NIL) 

END WSMETHOD

oXmlRet := NIL
Return .T.


// WSDL Data Structure ArrayOfAnyType

WSSTRUCT VCommString_ArrayOfAnyType
	WSDATA   oWSanyType                AS SCHEMA OPTIONAL
	WSMETHOD NEW
	WSMETHOD INIT
	WSMETHOD CLONE
	WSMETHOD SOAPRECV
ENDWSSTRUCT

WSMETHOD NEW WSCLIENT VCommString_ArrayOfAnyType
	::Init()
Return Self

WSMETHOD INIT WSCLIENT VCommString_ArrayOfAnyType
	::oWSanyType           := {} // Array Of  SCHEMA():New()
Return

WSMETHOD CLONE WSCLIENT VCommString_ArrayOfAnyType
	Local oClone := VCommString_ArrayOfAnyType():NEW()
	oClone:oWSanyType := NIL
	If ::oWSanyType <> NIL 
		oClone:oWSanyType := {}
		aEval( ::oWSanyType , { |x| aadd( oClone:oWSanyType , x:Clone() ) } )
	Endif 
Return oClone

WSMETHOD SOAPRECV WSSEND oResponse WSCLIENT VCommString_ArrayOfAnyType
	Local nRElem1, oNodes1, nTElem1
	::Init()
	If oResponse = NIL ; Return ; Endif 
	oNodes1 :=  WSAdvValue( oResponse,"_ANYTYPE","SCHEMA",{},NIL,.T.,"O",NIL,NIL) 
	nTElem1 := len(oNodes1)
	For nRElem1 := 1 to nTElem1 
		If !WSIsNilNode( oNodes1[nRElem1] )
			aadd(::oWSanyType , oNodes1[nRElem1] )
		Endif
	Next
Return


