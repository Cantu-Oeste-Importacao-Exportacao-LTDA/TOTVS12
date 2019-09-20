#INCLUDE "TOTVS.CH"
#INCLUDE "xmlxfun.CH"      
#INCLUDE "tbiconn.ch"
//#INCLUDE "XMLCSVCS.CH"

//#INCLUDE "APWEBSRV.CH

#define nPosFldName 	1
#define nPosFldValue 2

/*/{Protheus.doc} SFMonXML

Monta um XML para enviar para o Salesforce

@author devair.tonon
@since 31/01/2015
@version 1.0

@param cEntidade, character, Nome da entidade que representa a tabela do salesforce
@param cMetodo, character, Metodo que sera aplicado na tabela
@param aCampos, array, Array no formato {Campo, Valor} para cabecalho
@param cExFldNam, character, Descricao do campo identificador unico da tabela
@param aCmp3Dim, array, Array para itens (exclusivo em relacao ao cabecalho)

/*/
user function SFMonXML(cEntidade, cMetodo,  aCampos, cExFldNam, aCmp3Dim)
	local oError 		:= ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
	Local cXML			:= ""
	Local cCampos		:= ""
	Local nI			:= 1
	local cObj			:= ""
	local cSessionId	:= ""
	local nCount		:= 0
	
	default cExFldNam	:= ""
	default aCampos		:= {}
	default aCmp3Dim  	:= {}
	
	while empty(cSessionId) .and. nCount < 10
		cSessionId	  	:= SFGetID()
		nCount++
		sleep(1000)
	enddo
	
	if !empty(cSessionId)                                              
	 	cXML:= '<?xml version="1.0" encoding="UTF-8"?>'
		cXML+= '<soapenv:Envelope '
		cXML+= 'xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" '
		cXML+= 'xmlns:urn="urn:enterprise.soap.sforce.com" '
		cXML+= 'xmlns:urn1="urn:sobject.enterprise.soap.sforce.com" '
		cXML+= 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'		
		cXML+= '<soapenv:Header>'
		cXML+= '<urn:SessionHeader>'
		cXML+= '<urn:sessionId>' + cSessionId + '</urn:sessionId>'
		cXML+= '</urn:SessionHeader>'
		cXML+= '</soapenv:Header>'
		cXML+= '<soapenv:Body>'
			
		cXML+= '<urn:'+ cMetodo +'>'
		
		if !empty(cExFldNam)
			cXML+= '<urn:externalIDFieldName>'+cExFldNam+ '</urn:externalIDFieldName>'
		endif
		
		//monta 1 objeto ou varios objetos de acordo com o conteudo de cada array
		
		cXML+=	 MontObj(cMetodo, cEntidade, aCampos, aCmp3Dim )
		
		cXML+= '</urn:' + cMetodo + '>'
		cXML+= '</soapenv:Body>'
		cXML+= '</soapenv:Envelope>'
		
	   	cXML := FwNoAccent (cXML) 
	    //cXML := ANSIToOEM(cXML)
	   	cXML := EncodeUTF8(cXML)
   	
	endif
	ErrorBlock(oError)
	
return cXML


//Monta o objeto do XML
static function MontObj(cMetodo, cEntidade, aCampos, aCmp3Dim )
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
	local cObj		:= ""
	local cValor	:= ""
	local cCampos   := ""   
	local nI:= 1
	local nJ:= 1
	
	default aCampos  :={}
	default aCmp3Dim := {}
	
	
	//monta registro cabeçalho (somente 1)
	if len(aCampos) > 0 .and. len(aCmp3Dim)==0
		
		for nI:= 1 to len(aCampos)
			
			if valtype(aCampos[nI, nPosFldValue])=="N"
				
				cValor := cValToChar(aCampos[nI, nPosFldValue])
				
			elseif valtype(aCampos[nI, nPosFldValue])=="D"
				
				cValor := DTOS(aCampos[nI, nPosFldValue])
				cValor	:= SUBSTR(cValor,1,4) +"-" + SUBSTR(cValor,5,2)+"-"+ SUBSTR(cValor,7,2)
			else
				
				cValor := alltrim(aCampos[nI, nPosFldValue])
				
			endif
			
			cCampos += '<'+aCampos[nI, nPosFldName]+'>' + cValor+'</'+aCampos[nI, nPosFldName]+'>'
			
		next
		
		if cMetodo $ "upsert/update"
			
			cObj:= '<urn:sObjects xsi:type="urn1:'+ cEntidade + '">'
			
		endif
		
		cObj+=	 cCampos
		
		
		if cMetodo $ "upsert/update"
			
			cObj+= '</urn:sObjects>'
			
		endif
		
	elseif len(aCmp3Dim) >0 .and.  len(aCampos) == 0
		
		for nI:= 1 to len(aCmp3Dim)
			
			aCmp3:= aCmp3Dim[nI]
			cCampos :=""
			
			if cMetodo=="upsert"
				cObj+= '<urn:sObjects xsi:type="urn1:'+ cEntidade + '">'
			endif
			
			for nJ:= 1 to Len (aCmp3)
				
				if valtype(aCmp3[nJ, nPosFldValue])=="N"
					
					cValor := cValToChar(aCmp3[nJ, nPosFldValue])
					
				elseif valtype(aCmp3[nJ, nPosFldValue])=="D"
					
					cValor  := DTOS(aCmp3[nJ, nPosFldValue])
					cValor	:= SUBSTR(cValor,1,4) +"-" + SUBSTR(cValor,5,2)+"-"+ SUBSTR(cValor,7,2)
				else
					
					cValor := alltrim(aCmp3[nJ, nPosFldValue])
					
				endif
				
				cCampos += '<'+aCmp3[nJ, nPosFldName]+'>' + cValor+'</'+aCmp3[nJ, nPosFldName]+'>'
				
			next nJ
			
			cObj+=	 cCampos
			
			if cMetodo=="upsert"
				cObj+= '</urn:sObjects>'
			endif
			
		next nI
	endif
	ErrorBlock(oError)
return cObj

/*/{Protheus.doc} SFEnvXml

Realizar o envio do XML para o Salesforce

@author devair.tonon
@since 31/01/2015
@version 1.0

@param cXML, character, XML a enviar para o Salesforce

/*/
user function SFEnvXml(cXML )
	local oError 		:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local cSFUrl		:= alltrim(getmv("MV_XSFURL" ,.F.,"https://cs22.salesforce.com/services/Soap/c/32.0"))
	Local cSFPost		:= alltrim(getmv("MV_XSFPOST",.F.,"/services/Soap/c/32.0/0DFo0000000L31n HTTP/1.1"))
	Local cSFHost		:= alltrim(getmv("MV_XSFHOST",.F.,"cs22.salesforce.com"))
	Local cPostPar		:= ""
	Local nTimeOut		:= 120 //Segundos
	Local aHeaderStr	:= {}
	Local cHeaderRet	:= ""
	Local cResponse		:= ""
	Local cErroHTTP		:= ""
	Local nCodErrHTTP	:= 0
	Local cErroXML		:= ""
	Local cAlertaXML	:= ""
	Local aRet			:= {}
	local lTemErro 		:= .F.
	local cErro			:= ""
	local cIdObjeto		:= ""
	local lSucesso		:= .T.  
	local nCount   		:= 0           
	local cSessionId	:= ""   
	local cReplace		:= "_"
	local cError		:= ""
	local cWarning 		:= ""  
	local nCount2		:= 0
	
	aAdd(aHeaderStr,'POST ' + cSFPost) 

	aAdd(aHeaderStr,'Content-Type: text/xml;charset=UTF-8')
	aAdd(aHeaderStr,'SOAPAction: ""')
	aAdd(aHeaderStr,'Content-Length: ' + Alltrim(Str(Len(cXML))) )
	aAdd(aHeaderStr,'Host: '+ cSFHost)
	
	//cResponse 		:= HttpPost( cSFUrl , ,cXML , nTimeOut , aHeaderStr , @cHeaderRet )           
	cResponse 		:= HttpsPost( cSFUrl ,'' ,'' ,'' , ,cXML , nTimeOut , aHeaderStr , @cHeaderRet )  
   

//	cResponse 		:= u_HttpPst( cSFUrl, 80, cSFPost, cXML, nTimeOut , aHeaderStr , @cHeaderRet, @nCodErrHTTP )	

    if !empty(cResponse) .or. cResponse == Nil 
    	nCount2 := 0
	    while (cResponse == Nil .or. "INVALID_SESSION_ID" $ cResponse ) .and. nCount2 < 10
	        
	    	nCount := 0           
	    	cSessionId := ""
	    	while empty(cSessionId) .and. nCount < 10
				cSessionId	  	:= SFGetID()
				nCount++
				sleep(1000)
			enddo
		   
			oXML := Nil			
	        oXML := XmlParserFile ( cXML, cReplace, @cError, @cWarning )   
	        if oXML!=Nil	    	
		    	oXML:_SOAPENV_ENVELOPE:_SOAPENV_HEADER:_URN_SESSIONHEADER:_URN_SESSIONID:TEXT := cSessionId           
				SAVE oXml XMLSTRING cXML 
				
				cResponse 		:= HttpsPost( cSFUrl ,'' ,'' ,'' , ,cXML , nTimeOut , aHeaderStr , @cHeaderRet ) 
		    endif
		    sleep(1000)
		    nCount2++
	    enddo
    endif       
    
    CONOUT("SALESFORCE | " + TIME() +" | POST DO XML "+  cEmpAnt +"/" +cFilAnt  )				                                 

	nCodErrHTTP	:= HTTPGetStatus(cErroHTTP)		                                                                                             	
	cCaminhoLog	:= "\salesforce\erro\"
	cCaminhoXml	:= "\salesforce\xml\"
	
	if !ExistDir ( cCaminhoLog )
		
		FWMakeDir ( cCaminhoLog, .f.)
		
	endif
	
	if !ExistDir ( cCaminhoXml )
		
		FWMakeDir ( cCaminhoXml, .f.)
		
	endif	
	
	if nCodErrHTTP==200
		
		CREATE oXML XMLSTRING cResponse
		
		oXml 		:= XmlParser( cResponse, "_", @cErroXML , @cAlertaXML )

		if oXml!=Nil
			oXmlResult	:= XmlGetChild( oXml:_SOAPENV_ENVELOPE:_SOAPENV_BODY,1)
			
			if 'upsert' $ oXmlResult:REALNAME .OR. 'delete' $ oXmlResult:REALNAME
				if type("oXmlResult:_RESULT")!="A"								
					//SE RETORNOU ERRO					
					if type("oXmlResult:_RESULT:_ERRORS")!="U"						
						lTemErro	:= .T.
						cErro		:= oXmlResult:_RESULT:_ERRORS:_MESSAGE:TEXT
						lSucesso	:= .F.						
					endif 
										
					if type("oXmlResult:_RESULT:_ID:TEXT")!="U"
						cIdObjeto	:= oXmlResult:_RESULT:_ID:TEXT
					endif					
					aadd( aRet, {lTemErro, cIdObjeto, cErro } )
				else
					
					for nI:=1 to Len(oXmlResult:_RESULT)					
						lTemErro 	:= .F.
						cErro		:= ""
						cIdObjeto	:= ""
						
						//SE RETORNOU ERRO
						if type("oXmlResult:_RESULT[nI]:_ERRORS")!="U"						
							lTemErro	:= .T.
							cErro		:= oXmlResult:_RESULT[nI]:_ERRORS:_MESSAGE:TEXT
							lSucesso	:= .F.						
						endif
						
						if type("oXmlResult:_RESULT[nI]:_ID:TEXT")!="U"
							cIdObjeto	:= oXmlResult:_RESULT[nI]:_ID:TEXT
						endif
						
						aadd( aRet, {lTemErro, cIdObjeto, cErro } )					
					next nI
					
				endif
				
			elseif 'query' $ oXmlResult:REALNAME   
					
				if val(oXmlResult:_RESULT:_SIZE:TEXT) > 0 				
					oObjeto := Nil				
					for nI:=1 to val(oXmlResult:_RESULT:_SIZE:TEXT)					
						if type("oXmlResult:_RESULT:_RECORDS")=="A"					 
							oObjeto := oXmlResult:_RESULT:_RECORDS[nI]					
						else					                                         
							oObjeto := oXmlResult:_RESULT:_RECORDS					
						endif					
						aadd( aRet, {.F., oObjeto, "" } )					
					next
				
				else			
					aadd( aRet, {.T., Nil, "" } )			
				endif			
			endif
		endif
	else
		
		if !empty(cResponse)		
			CONOUT("SALESFORCE | " + TIME() +" | ERRO DO POST "+  cEmpAnt +"/" +cFilAnt +" | " +cResponse   )				                                 
			cErro		:= cResponse
		else
			cErro		:= "ERRO NAO REPORTADO PELO HTTP"			
		endif
		
		lTemErro	:= .T.
		lSucesso	:= .F.
		
		aadd(aRet, {lTemErro, cIdObjeto, cErro} )
		
	endif
	
	//Grava log de erro
	if !lSucesso
		
		cFileName :=  "XML_ERRO_VALID_"+alltrim(CUSERNAME)+"_"+Alltrim(STR(ThreadID()))+dtos(date())+time()
		cFileName :=  strtran(cFileName,":")
		
		memowrite(cCaminhoLog + cFileName +".xml",cXML  ) 
		 
		if !empty(cResponse)
			memowrite(cCaminhoLog + cFileName +".log",cResponse )						
		endif
		
	endif
	
	ErrorBlock(oError)
return aRet



/*

Obtem a session ID

*/
/*/{Protheus.doc} SFGetID
Obtem a sessionId atual para enviar a salesforce

@author devair.tonon
@since 31/01/2015
@version 1.0


/*/
static function SFGetID()
	local oError 		:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	Local cSFUrlLog		:= ""
	local cSFResorc 	:= ""
	Local cSFCliId		:= ""
	Local cSFCliSec		:= ""
	Local cSFRefTk 		:= ""
		 
	Local nTimeOut		:= 120 //Segundos
	Local aHeaderStr	:= {}
	Local cHeaderRet	:= ""
	Local cResponse		:= ""
	Local cErroHTTP		:= ""
	Local nCodErrHTTP	:= 0
	Local cErroXML		:= ""
	Local cAlertaXML	:= ""
	Local cToken		:= ""
	Local cGetParam		:= ""
	local nPosTk   		:= 0
	local cMVXSFSID		:= ""	   	//ULTIMA SESSION ID
    local nMVXSFTS  	:= ""  	//ULTIMO TIME STAMP DE REQUISICAO DO SESSION ID 
    local nMVXSFTDF 	:= ""	   	//INTERVALO DE REQUISICAO DO SESSION ID     
	local nCount		:= 0
	local nTSAtual  	:= 0
	
	AjustaSX6()	
	
	cMVXSFSID := alltrim(getmv("MV_X_SFSID", .F., "" ))	   	//ULTIMA SESSION ID
    nMVXSFTS  := getmv("MV_X_SFTS" , .F., 0 )	   	//ULTIMO TIME STAMP DE REQUISICAO DO SESSION ID 
    nMVXSFTDF := getmv("MV_X_SFTDF" , .F., 0 )*10000	   	//INTERVALO DE TEMPO ENTRE REQUISIÇÕES DE SESSION ID
                                                        
    //retorna o ultimo session id obtido caso ainda esteja dentro do prazo determinado no parametro
    // SF atualiza a cada 2 horas
	nTSAtual := Val(FWTimeStamp(4, Date(), Time()))*1000	
	if nTSAtual - nMVXSFTS < nMVXSFTDF .and. nMVXSFTS > 0		
		return cMVXSFSID		
	endif
	
	CONOUT("SALESFORCE | " + TIME() +" | GET "+  cEmpAnt +"/" +cFilAnt  )					
	
	//parametros da requisicao
	cSFUrlLog	:= alltrim(getmv("MV_XSFLOGI",.F.,"https://test.salesforce.com"))
	cSFResorc	:= alltrim(getmv("MV_XSFLGRC",.F.,"/services/oauth2/token") )	
	cSFCliId	:= alltrim(getmv("MV_XSFCLID",.F.,"3MVG9OI03ecbG2Vr287d3FI_pNybihyKcp0JDUrymTxtpTf5dClMN5hkSfP6y7feVrcb2JY_PLsMIS8H2wVHe"))	
	cSFCliSec	:= alltrim(getmv("MV_XSFCLSC",.F.,"8118792922669153642"))            
	cSFRefTk	:= alltrim(getmv("MV_XSFRFTK",.F.,"5Aep861AW95fpOig3grGTr7FUqFTV0atqrdsA6OEMKu.rX1q3ENncysUczALNfqUllZmI0ezCfe.98.3bXQ5GEz"))

	//parametros do get	
	cGetParam := 'grant_type=refresh_token&client_id='+cSFCliId
	cGetParam += '&client_secret='+cSFCliSec
	cGetParam += '&refresh_token='+cSFRefTk
    
   	//parametros de cabeçalho da requisicao
	aadd(aHeaderStr, 'Accept: application/xml')
	aadd(aHeaderStr, 'Content-Type: text/xml;charset=UTF-8')
	
	//realiza a requisicao
	cResponse 	:= HttpsGet(cSFUrlLog + cSFResorc,'','','', cGetParam, nTimeOut , aHeaderStr , @cHeaderRet ) 	
	//cResponse 	:= HttpGet(cSFUrlLog  + cSFResorc, cGetParam, nTimeOut , aHeaderStr , @cHeaderRet ) 	
	
	nCodErrHTTP	:= HTTPGetStatus(cErroHTTP)                                                                         		
	
	cCaminhoLog	:= "\salesforce\erro\"
	
	if cErroHTTP!="OK"
		CONOUT("SALESFORCE | " + TIME() +" | GET "+  cEmpAnt +"/" +cFilAnt +" | "+ cErroHTTP  )
	endif
	
	if !ExistDir ( cCaminhoLog )
		FWMakeDir ( cCaminhoLog, .f.)		
	endif
	
	if nCodErrHTTP==200		
	   	oXml 		:= XmlParser( cResponse, "_", @cErroXML , @cAlertaXML )
		oXmlResult	:= XmlGetChild( oXml,1)		
		cToken		:= alltrim(oXmlResult:_ACCESS_TOKEN:TEXT)
		nTSAtual	:= val(oXmlResult:_ISSUED_AT:TEXT)
	
		//cria semaforo para nao sobrebor a atualizacao  
		lLock := .F.
		do while !lLock .and. nCount < 20
		   
		   sleep(1000)
		   nCount++ 
		   lLock := LockByName(cEmpAnt+'SFSESSIONID', .T., .T.) 
		enddo
        
		//atualiza o ultimo session ID obtido
	    if lLock
			Putmv('MV_X_SFSID', cToken)   
			Putmv('MV_X_SFTS', nTSAtual)
			UnLockByName(cEmpAnt+'SFSESSIONID', .T., .T.)
		endif
	else 
		cFileName :=  "XML_ERRO_GETSESSION_"+alltrim(CUSERNAME)+"_"+Alltrim(STR(ThreadID()))		
		if !empty(cResponse)
			memowrite(cCaminhoLog + cFileName +".log",cResponse ) 
			CONOUT("SALESFORCE | " + TIME() +" | ERRO AO OBTER SESSION ID  "+  cEmpAnt +"/" +cFilAnt +" | " + cResponse   )
		endif		
	endif
	
	ErrorBlock(oError)
	
return cToken



user function SFSql(cSQL)
	local cSOAPReq	:= ""
	local cSOAPRes	:= ""
	
	
	/**********************
	   Gera xml sql
	**********************/
	
	cSOAPReq:='<?xml version=1.0 encoding=UTF-8?>'
	cSOAPReq+='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com" xmlns:urn1="urn:sobject.enterprise.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'
	cSOAPReq+='<soapenv:Header>'
	cSOAPReq+='<urn:SessionHeader>'
	cSOAPReq+='<urn:sessionId></urn:sessionId>'
	cSOAPReq+='</urn:SessionHeader>'
	cSOAPReq+='</soapenv:Header>'
	cSOAPReq+='<soapenv:Body>'
	cSOAPReq+='<urn:query>'
	cSOAPReq+='<urn:queryString></urn:queryString>'
	cSOAPReq+='</urn:query>'
	cSOAPReq+='</soapenv:Body>'
	cSOAPReq+='</soapenv:Envelope>'
	
	
	CREATE oXML XMLSTRING cSOAPReq
	
	// Ao fim do processo , gera a string XML correspondente ao Objeto
	
	oXML:_SOAPENV_ENVELOPE:_SOAPENV_HEADER:_URN_SESSIONHEADER:_URN_SESSIONID:TEXT := SFGetID()
	
	oXML:_SOAPENV_ENVELOPE:_SOAPENV_BODY:_URN_QUERY:_URN_QUERYSTRING:TEXT := cSQL
	
	SAVE oXml XMLSTRING cXml
	
	cXml := strtran(cXml,'&quot;','')
	
	aRet := {}
		
	aRet := U_SFEnvXml(cXML )
	
return aRet


user function SFDelete(aDelete)

	local cSOAPRes	:= ""
	
	local cPathXML	:= "\salesforce\delete\"
	
	local cNomArqXML:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
	
	cNomArqXML := strtran(cNomArqXML,":","")
	
	if !ExistDir ( cPathXML )
		
		FWMakeDir ( cPathXML, .f.)
		
	endif
	
	/**********************
	   Gera xml sql
	**********************/
	
	cSOAPReq:='<?xml version=1.0 encoding=UTF-8?>'
	cSOAPReq+='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:enterprise.soap.sforce.com">'
	cSOAPReq+='<soapenv:Header>'
	cSOAPReq+='<urn:SessionHeader>'
	cSOAPReq+='<urn:sessionId></urn:sessionId>'
	cSOAPReq+='</urn:SessionHeader>'
	cSOAPReq+='</soapenv:Header>'
	cSOAPReq+='<soapenv:Body>'
	cSOAPReq+='<urn:delete>'
	cSOAPReq+='<urn:id></urn:id>'
	cSOAPReq+='</urn:delete>'
	cSOAPReq+='</soapenv:Body>'
	cSOAPReq+='</soapenv:Envelope>
	
	
	CREATE oXML XMLSTRING cSOAPReq SETASARRAY _SOAPENV_ENVELOPE:_SOAPENV_BODY:_URN_DELETE:_URN_ID
	
	
	// Ao fim do processo , gera a string XML correspondente ao Objeto
	
	oXML:_SOAPENV_ENVELOPE:_SOAPENV_HEADER:_URN_SESSIONHEADER:_URN_SESSIONID:TEXT := SFGetID()
	
	//popula o XML com os ID que serao apagados
	For nJ:=1 To Len(aDelete)
		
		oXml:_SOAPENV_ENVELOPE:_SOAPENV_BODY:_URN_DELETE:_URN_ID[nJ]:TEXT = aDelete[nJ]	
		
		if nJ < Len(aDelete)
		
			ADDNODE oXml:_SOAPENV_ENVELOPE:_SOAPENV_BODY:_URN_DELETE:_URN_ID NODE '_URN_ID' ON oXML
		
		endif	 
		
	Next
	
	
	SAVE oXml XMLSTRING cXml
	
	cXml := strtran(cXml,'&quot;','')
	
	//grava XML de exclusao
	MemoWrite(cPathXML + cNomArqXML+"_DELETE.xml", cXML  )
	
	aRet := {}
		
	aRet := U_SFEnvXml(cXML )

return aRet
                
                
             

user function SFGRVLOG(_cAls, _nIndice, _cChave, _cStatus, _cErro)

	if CHKFILE('ZSF')
	   dbSelectArea('ZSF')
	   ZSF->(dbAppend())
	   ZSF->ZSF_FILIAL	:= xFilial('ZSF')	   
	   ZSF->ZSF_ALIAS	:= _cAls
	   ZSF->ZSF_INDICE  := _nIndice
	   ZSF->ZSF_CHAVE	:= _cChave 
	   ZSF->ZSF_STATUS  := _cStatus    
	   ZSF->ZSF_ERRO	:= _cErro
	   ZSF->ZSF_DATA	:= Date()
	   ZSF->ZSF_HORA	:= Time()
	endif

return                


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX6 ºAutor  ³ Alberto Deviciente º Data ³ 21/Mai/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ajuste do dicionario de Parametros.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Integracao Protheus x RM Classis Net (RM Sistemas)         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºOBS:	  	 ³Funcao antiga chamava-se AjustaSX6 						  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX6()
Local aSx6      := {}						//Array que armazenara os indices
Local aEstrut   := {}				        //Array com a estrutura da tabela SX6
Local i         := 0 						//Contador para laco
Local j         := 0 						//Contador para laco
Local lInclui 	:= .F.
Local cFil 		:= SM0->M0_FILIAL
Local aArea     := GetArea()

/*********************************************************************************************
Define estrutura do array
*********************************************************************************************/
aEstrut:= { "X6_FILIAL","X6_VAR","X6_TIPO","X6_DESCRIC","X6_DSCSPA","X6_DSCENG","X6_DESC1","X6_DSCSPA1",;
			"X6_DSCENG1","X6_DESC2","X6_DSCSPA2","X6_DSCENG2", "X6_CONTEUD","X6_CONTSPA", "X6_CONTENG",;
			"X6_PROPRI", "X6_PYME"}

/*********************************************************************************************
Define os dados do parametro
*********************************************************************************************/
aadd(aSx6,{"  ",;											//Filial
		"MV_X_SFSID",;										//Var
		"C",;                 								//Tipo
		"Ultima SessionId obtida para realizar Post no ",;//Descric
		"Ultima SessionId obtida para realizar Post no ",;//DscSpa
		"Ultima SessionId obtida para realizar Post no ",;			//DscEng
		"no Salesforce",;	//Desc1
		"no Salesforce",;   			//DscSpa1
		"no Salesforce",;					//DscEng1
		"",;						//Desc2
		"",;						//DscSpa2
		"",;						//DscEng2
		"",;												//Conteud
		"",;												//ContSpa
		"",;												//ContEng
		"U",;												//Propri		
		"N"})												//Pyme

aadd(aSx6,{"  ",;											//Filial
		"MV_X_SFTS",;										//Var
		"N",;                 								//Tipo
		"Ultimo Timestamp para obtencao da sessionid  ",;//Descric
		"Ultimo Timestamp para obtencao da sessionid  ",;//DscSpa
		"Ultimo Timestamp para obtencao da sessionid  ",;			//DscEng
		"do Salesforce",;	//Desc1
		"do Salesforce",;   			//DscSpa1
		"do Salesforce",;					//DscEng1
		"",;						//Desc2
		"",;						//DscSpa2
		"",;						//DscEng2
		"0",;												//Conteud
		"0",;												//ContSpa
		"0",;												//ContEng
		"U",;												//Propri		
		"N"})												//Pyme 

aadd(aSx6,{"  ",;											//Filial
		"MV_X_SFTDF",;										//Var
		"N",;                 								//Tipo
		"Intervalo para obtencao da sessionid  ",;//Descric
		"Intervalo para obtencao da sessionid  ",;//DscSpa
		"Intervalo para obtencao da sessionid  ",;			//DscEng
		"do Salesforce",;	//Desc1
		"do Salesforce",;   			//DscSpa1
		"do Salesforce",;					//DscEng1
		"",;						//Desc2
		"",;						//DscSpa2
		"",;						//DscEng2
		"1800",;												//Conteud
		"1800",;												//ContSpa
		"1800",;												//ContEng
		"U",;												//Propri		
		"N"})												//Pyme	 
		
aadd(aSx6,{"  ",;											//Filial
		"MV_XSFLGRC",;										//Var
		"C",;                 								//Tipo
		"Recurso da URL de login no Salesforce",;//Descric
		"Recurso da URL de login no Salesforce",;//DscSpa
		"Recurso da URL de login no Salesforce",;			//DscEng
		"",;	//Desc1
		"",;   			//DscSpa1
		"",;					//DscEng1
		"",;						//Desc2
		"",;						//DscSpa2
		"",;						//DscEng2
		"/services/oauth2/token",;												//Conteud
		"/services/oauth2/token",;												//ContSpa
		"/services/oauth2/token",;												//ContEng
		"U",;												//Propri		
		"N"})												//Pyme		
			
				
/*********************************************************************************************
Grava as informacoes do array na tabela SX6
*********************************************************************************************/
dbSelectArea("SX6")
SX6->(DbSetOrder(1))

For i:= 1 To Len(aSx6)
	If DbSeek("  "+aSx6[i,2]) .or. DbSeek(cFil+aSx6[i,2])
		RecLock("SX6",.F.)
		lInclui := .F.
	Else
		RecLock("SX6",.T.)
		lInclui := .T.
	EndIf
	
	For j:=1 To Len(aSx6[i])
		if lInclui .or. !(aEstrut[j] $ "X6_FILIAL|X6_CONTEUD|X6_CONTSPA|X6_CONTENG") //Nao altera os campos jah configurados pelo usuario
			If FieldPos(aEstrut[j])>0
				FieldPut(FieldPos(aEstrut[j]),aSx6[i,j])
			EndIf
		endif
	Next j
	SX6->(MsUnLock())
Next i

RestArea(aArea)

Return



user function HttpGt( cSFUrlLog, nPorta, cRecurso, cGetParam, nTimeOut , aHeaderStr , cHeaderRet, nStatus )

Local oSock := tSocketClient():New()
   
local cReceiv		:= ""  
local nRes			:= 0
local aResponse		:= {}
local cResponse		:= ""
local oSock		
local cURL			:= ""
local nI			:= 0

default nTimeOut	:= 120   
default nPorta		:= 80
default aHeaderStr 	:= {}
default cHeaderRet	:= ""
                      
//remove o protocolo
cURL	:= cSFUrlLog  
if "http://" $ cURL
	cURL 	:= Strtran(cURL, "http://","")	
elseif "https://" $ cURL
	cURL 	:= Strtran(cURL, "https://","")   
	nPorta	:= 443
endif


oSock:Connect( nPorta, cURL, nTimeOut)

if oSock:isConnected()
	cStr:= 'GET /'
		
	if !empty(cRecurso)
		cStr+= cRecurso 
	endif     


	if !empty(cGetParam) 	
		cStr+= '?'+ cGetParam 
	endif 
	
	cStr+=' HTTP/1.1' +CRLF  
	
	
	for nI:=1 to len(aHeaderStr)
		
		cStr+= aHeaderStr[nI]
		if nI<len(aHeaderStr)
	    	cStr+= CRLF                     
		endif
	next nI            			
	
	cStr+= CRLF 
	cStr+= CRLF 	
	nRes := oSock:Send(cStr)
	nReceiv := 0 
	
	if nRes == len(cStr)
		nReceiv := 	oSock:Receive(@cReceiv, 120)	
		
		if nReceiv >=0
			            
			aResponse 	:= StrTokArr(cReceiv, CRLF)			
						
			if len(aResponse)>1
				nPosSts := at(" ", aResponse[1])
				nStatus := Val(substr(aResponse[1], nPosSts+1,3))
								
				if (nPosRp := aScan(aResponse, {|x| x=="1EF"}))>0				
				   cResponse:= aResponse[nPosRp+1]				   				   
				endif
			else
				cResponse:= cReceiv				
			endif 
		endif		        		
	endif	
endif

return cResponse



user function HttpPst( cSFUrlLog, nPorta, cRecurso, cPostParam, nTimeOut , aHeaderStr , cHeaderRet, nStatus )

Local oSock := tSocketClient():New()
   
local cReceiv		:= ""  
local nRes			:= 0
local aResponse		:= {}
local cResponse		:= ""
local oSock		
local cURL			:= ""
local nI			:= 0

default nTimeOut	:= 120   
default nPorta		:= 80
default aHeaderStr 	:= {}
default cHeaderRet	:= ""
                      
//remove o protocolo
cURL	:= cSFUrlLog  
if "http://" $ cURL
	cURL 	:= Strtran(cURL, "http://","")	
elseif "https://" $ cURL
	cURL 	:= Strtran(cURL, "https://","")   
	nPorta	:= 443
endif


oSock:Connect( nPorta, cURL, nTimeOut)

if oSock:isConnected()
	cStr:= 'POST /'
		
	if !empty(cRecurso)
		cStr+= cRecurso 
	endif     
	
	cStr+=' HTTP/1.1' +CRLF  
	
	
	for nI:=1 to len(aHeaderStr)
		
		cStr+= aHeaderStr[nI]
		if nI<len(aHeaderStr)
	    	cStr+= CRLF                     
		endif
	next nI            			
	
	cStr+= CRLF 
	cStr+= CRLF  
	
	cStr+= cPostParam
		
	nRes := oSock:Send(cStr)
	nReceiv := 0 
	
	if nRes == len(cStr)
		nReceiv := 	oSock:Receive(@cReceiv, 120)	
		
		if nReceiv >=0
			            
			aResponse 	:= StrTokArr(cReceiv, CRLF)			
						
			if len(aResponse)>1
				nPosSts := at(" ", aResponse[1])
				nStatus := Val(substr(aResponse[1], nPosSts+1,3))
								
				if (nPosRp := aScan(aResponse, {|x| x=="1EF"}))>0				
				   cResponse:= aResponse[nPosRp+1]				   				   
				endif
			else
				cResponse:= cReceiv				
			endif 
		endif		        		
	endif	
endif

return cResponse





user function testso33()

Local oSock := tSocketClient():New()
   
local cReceiv	:= ""  
local nRes		:= 0
local aResponse	:= {}
local cResponse	:= ""
local oSock		


oSock:Connect( 80, 'login.salesforce.com',120)

if oSock:isConnected()
	
	cStr:= 'GET /services/oauth2/token?grant_type=refresh_token&client_id=3MVG9xOCXq4ID1uGUMXJMwPY8HMOSRZ8yIpOeKngsP6pf9jZfYwhj1KrmrixBXsRmuHP82iJmLb4wZvEKye5L&client_secret=4663625251797908827&refresh_token=5Aep861LNDQReieQSJtRdQEcTsD3Byg6VAwJSgtd9O306Zc2bUnfQS00IUiUxNadnn_TIQgeLwAuVia_qCCx_0B HTTP/1.1' +CRLF  
	cStr+= 'Host: login.salesforce.com' +CRLF
	cStr+= 'Accept: application/xml'+CRLF
	cStr+= 'Content-Type: text/xml;charset=UTF-8' +CRLF
	cStr+= CRLF
		
	nRes := oSock:Send(cStr)
	nReceiv := 0 
	
	
	if nRes == len(cStr)
		nReceiv := 	oSock:Receive(@cReceiv, 120)	
		
		if nReceiv >=0
			            
			aResponse 	:= StrTokArr(cReceiv, CRLF)			
						
			if len(aResponse)>1
				nPosSts := at(" ", aResponse[1])
				nStatus := Val(substr(aResponse[1], nPosSts+1,3))
								
				if (nPosRp := aScan(aResponse, {|x| x=="1EF"}))>0				
				   cResponse:= aResponse[nPosRp+1]				   				   
				endif
			else
				cResponse:= cReceiv				
			endif 
		endif		        		
	endif	
endif

return cResponse



user function tstso22()

Local oSock := tSocketClient():New()
   
local cReceiv	:= ""  
local nRes		:= 0
local aResponse	:= {}
local cResponse	:= ""
local oSock		     
local cStr		:= ""


oSock:Connect( 80, 'cs21.salesforce.com',120)

if oSock:isConnected()

	/*
	cXML:='<?xml version="1.0" encoding="UTF-8"?><soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:urn="urn:partner.soap.sforce.com" xmlns:urn1="urn:sobject.enterprise.soap.sforce.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soapenv:Header><urn:SessionHeader><urn:sessionId>00Dq0000000B9DV!ARYAQLV.4aNXwqOZK6dw5AfKXXr545VGTiUKXfHpe1tZT24A5IxPs2g5nnHv.SRkpUV8KnSDxYnqBhEimOo7lDTMFnQlf7Km</urn:sessionId></urn:SessionHeader></soapenv:Header><soapenv:Body><urn:upsert><urn:externalIDFieldName>Codigo_ERP__c</urn:externalIDFieldName><urn:sObjects xsi:type="urn1:Account"><Codigo_ERP__c>0161926690001</Codigo_ERP__c><Bairro_Cobranca__c>CENTRO</Bairro_Cobranca__c><CEP_Cobranca__c>85980-000</CEP_Cobranca__c><RecordTypeId>012o0000000Gkiy</RecordTypeId><CPF__pc>016.192.669-03</CPF__pc><FirstName>JOAO</FirstName><LastName>MARCELO MAGNANI</LastName><Codigo_Municipio_Cobranca__c>4108809</Codigo_Municipio_Cobranca__c><Phone>+55 44 3642 1365</Phone><Complemento_Cobranca__c></Complemento_Cobranca__c><Rua_Cobranca__c>RUA FRANCISCO MURTINHO 876</Rua_Cobranca__c><Numero_Cobranca__c>0</Numero_Cobranca__c><Estado_Cobranca__c>PR</Estado_Cobranca__c><Cidade_Cobranca__c>GUAIRA</Cidade_Cobranca__c><Inscricao_Estadual__c>ISENTO</Inscricao_Estadual__c><Limite_Credito__c>0</Limite_Credito__c><Nome_Fantasia__c>JOAO MARCELO MAGNANI</Nome_Fantasia__c><Pais_Cobranca__c>BRASIL</Pais_Cobranca__c><urn:fieldsToNull>Data_Limite_Credito__c</urn:fieldsToNull><Data_Cadastro_Empresa__c>2013-08-28</Data_Cadastro_Empresa__c><E_mail_NFe__c>djoaodebarro@hotmail.com</E_mail_NFe__c><urn:fieldsToNull>Data_Abertura_Empresa__c</urn:fieldsToNull><Condicao_Pagamento__r><Codigo_ERP__c>001</Codigo_ERP__c></Condicao_Pagamento__r><Forma_Pagamento__c>R$</Forma_Pagamento__c><Risco__c>E</Risco__c><Limite_Sugerido__c>0</Limite_Sugerido__c><Capital_Social__c>0</Capital_Social__c><Observacao_Cobranca__c></Observacao_Cobranca__c><Observacao_Cadastro__c>FIANCA</Observacao_Cadastro__c><Grupo_Tributario__c></Grupo_Tributario__c><Contribuinte__c>0</Contribuinte__c><Optante_pelo_Simples__c>0</Optante_pelo_Simples__c><Enviar_Para_Serasa__c>0</Enviar_Para_Serasa__c><Bloqueado__c>true</Bloqueado__c><Maior_Compra__c>0</Maior_Compra__c><urn:fieldsToNull>Ultima_Compra__c</urn:fieldsToNull><Saldo_Aberto_em_Titulos__c>0</Saldo_Aberto_em_Titulos__c><Pagamentos_Atrasados__c>0</Pagamentos_Atrasados__c><Titulos_Atrasados__c>0</Titulos_Atrasados__c><Maior_Atraso__c>0</Maior_Atraso__c><Media_Atraso__c>0</Media_Atraso__c><Valor_Acumulado__c>0</Valor_Acumulado__c><Numero_Pagamentos__c>0</Numero_Pagamentos__c><Limite_Disponivel__c>0</Limite_Disponivel__c><Type>Consumo</Type><Rating>Standard</Rating><Cobranca_Externa__c>0</Cobranca_Externa__c><urn:fieldsToNull>Grupo_Clientes__c</urn:fieldsToNull><urn:fieldsToNull>Situacao_Cobranca__c</urn:fieldsToNull><urn:fieldsToNull>Fax</urn:fieldsToNull></urn:sObjects></urn:upsert></soapenv:Body></soapenv:Envelope>'         
	
 	cStr:='POST https://96.43.151.160/services/Soap/u/32.0/00Dq0000000B9DV/0DFo0000000L31n HTTP/1.1'+chr(13)+chr(10)
	cStr+='Host: 96.43.151.160'+chr(13)+chr(10)
  	cStr+='Accept: application/xml'+chr(13)+chr(10)
  	cStr+='Content-Type: text/xml;charset=UTF-8'+chr(13)+chr(10)
  	cStr+="SOAPAction: ''"+chr(13)+chr(10)
  	cStr+='Content-Length: '+cValToChar(len(cXML))+chr(13)+chr(10)
	
	cStr+=chr(13)+chr(10)
	cStr+=cXml                 
	*/
	  
	cXML:='<?xml version="1.0" encoding="UTF-8"?><Account><Bairro_Cobranca__c>CENTRO</Bairro_Cobranca__c><CEP_Cobranca__c>85980-000</CEP_Cobranca__c><RecordTypeId>012o0000000Gkiy</RecordTypeId><CPF__pc>016.192.669-03</CPF__pc><FirstName>JOAO</FirstName><LastName>MARCELO MAGNANI</LastName><Codigo_Municipio_Cobranca__c>4108809</Codigo_Municipio_Cobranca__c><Phone>+55 44 3642 1365</Phone><Complemento_Cobranca__c></Complemento_Cobranca__c><Rua_Cobranca__c>RUA FRANCISCO MURTINHO 876</Rua_Cobranca__c><Numero_Cobranca__c>876</Numero_Cobranca__c><Estado_Cobranca__c>PR</Estado_Cobranca__c><Cidade_Cobranca__c>GUAIRA</Cidade_Cobranca__c><Inscricao_Estadual__c>ISENTO</Inscricao_Estadual__c><Limite_Credito__c>0</Limite_Credito__c><Nome_Fantasia__c>JOAO MARCELO MAGNANI</Nome_Fantasia__c><Pais_Cobranca__c>BRASIL</Pais_Cobranca__c><fieldsToNull>Data_Limite_Credito__c</fieldsToNull><Data_Cadastro_Empresa__c>2013-08-28</Data_Cadastro_Empresa__c><E_mail_NFe__c>djoaodebarro@hotmail.com</E_mail_NFe__c><fieldsToNull>Data_Abertura_Empresa__c</fieldsToNull><Condicao_Pagamento__r><Codigo_ERP__c>001</Codigo_ERP__c></Condicao_Pagamento__r><Forma_Pagamento__c>R$</Forma_Pagamento__c><Risco__c>E</Risco__c><Limite_Sugerido__c>0</Limite_Sugerido__c><Capital_Social__c>0</Capital_Social__c><Observacao_Cobranca__c></Observacao_Cobranca__c><Observacao_Cadastro__c>FIANCA</Observacao_Cadastro__c><Grupo_Tributario__c></Grupo_Tributario__c><Contribuinte__c>0</Contribuinte__c><Optante_pelo_Simples__c>0</Optante_pelo_Simples__c><Enviar_Para_Serasa__c>0</Enviar_Para_Serasa__c><Bloqueado__c>true</Bloqueado__c><Maior_Compra__c>0</Maior_Compra__c><fieldsToNull>Ultima_Compra__c</fieldsToNull><Saldo_Aberto_em_Titulos__c>0</Saldo_Aberto_em_Titulos__c><Pagamentos_Atrasados__c>0</Pagamentos_Atrasados__c><Titulos_Atrasados__c>0</Titulos_Atrasados__c><Maior_Atraso__c>0</Maior_Atraso__c><Media_Atraso__c>0</Media_Atraso__c><Valor_Acumulado__c>0</Valor_Acumulado__c><Numero_Pagamentos__c>0</Numero_Pagamentos__c><Limite_Disponivel__c>1000</Limite_Disponivel__c><Type>Consumo</Type><Rating>Standard</Rating><Cobranca_Externa__c>0</Cobranca_Externa__c><fieldsToNull>Grupo_Clientes__c</fieldsToNull><fieldsToNull>Situacao_Cobranca__c</fieldsToNull><fieldsToNull>Fax</fieldsToNull></Account>' 
	
	cStr:='POST https://cs21.salesforce.com/services/data/v32.0/sobjects/Account/Codigo_ERP__c/0161926690001'+chr(13)+chr(10) 
	//cStr+='Authorization: Basic 00Dq0000000B9DV!ARYAQLV.4aNXwqOZK6dw5AfKXXr545VGTiUKXfHpe1tZT24A5IxPs2g5nnHv.SRkpUV8KnSDxYnqBhEimOo7lDTMFnQlf7Km'+chr(13)+chr(10)
  	//cStr+='Accept: application/xml'+chr(13)+chr(10)
	//cStr+='Content-Type: text/xml;charset=UTF-8' +chr(13)+chr(10)
  	//cStr+='Connection: Keep-Alive' +chr(13)+chr(10)  
	cStr+='Content-Length:'+cValToChar(len(cXML))+chr(13)+chr(10)  
  	
	cStr+=chr(13)+chr(10)
	cStr+=cXml     
		
	nRes := oSock:Send(cStr)
	nReceiv := 0 
	
	if nRes == len(cStr)
		nReceiv := 	oSock:Receive(@cReceiv, 120)	
		
		if nReceiv >=0
			            
			aResponse 	:= StrTokArr(cReceiv, CRLF)			
						
			if len(aResponse)>1
				nPosSts := at(" ", aResponse[1])
				nStatus := Val(substr(aResponse[1], nPosSts+1,3))
								
				if (nPosRp := aScan(aResponse, {|x| x=="12F"}))>0				
				   cResponse:= aResponse[nPosRp+1]				   				   
				endif
			else
				cResponse:= cReceiv				
			endif 
		endif		        		
	endif	
endif

return cResponse



user function SFRest2()

	Local cUrl := "https://cs21.salesforce.com"
	local cGETParms:= ""
	local cPOSTParms := ""
	Local nTimeOut := 120 
	Local aHeadStr := {}
	Local cHeadRet := ""
	
		
	cPOSTParms:='<?xml version="1.0" encoding="UTF-8"?><Account><Bairro_Cobranca__c>CENTRO</Bairro_Cobranca__c><CEP_Cobranca__c>85980-000</CEP_Cobranca__c><RecordTypeId>012o0000000Gkiy</RecordTypeId><CPF__pc>016.192.669-03</CPF__pc><FirstName>JOAO</FirstName><LastName>MARCELO MAGNANI</LastName><Codigo_Municipio_Cobranca__c>4108809</Codigo_Municipio_Cobranca__c><Phone>+55 44 3642 1365</Phone><Complemento_Cobranca__c></Complemento_Cobranca__c><Rua_Cobranca__c>RUA FRANCISCO MURTINHO 876</Rua_Cobranca__c><Numero_Cobranca__c>876</Numero_Cobranca__c><Estado_Cobranca__c>PR</Estado_Cobranca__c><Cidade_Cobranca__c>GUAIRA</Cidade_Cobranca__c><Inscricao_Estadual__c>ISENTO</Inscricao_Estadual__c><Limite_Credito__c>0</Limite_Credito__c><Nome_Fantasia__c>JOAO MARCELO MAGNANI</Nome_Fantasia__c><Pais_Cobranca__c>BRASIL</Pais_Cobranca__c><fieldsToNull>Data_Limite_Credito__c</fieldsToNull><Data_Cadastro_Empresa__c>2013-08-28</Data_Cadastro_Empresa__c><E_mail_NFe__c>djoaodebarro@hotmail.com</E_mail_NFe__c><fieldsToNull>Data_Abertura_Empresa__c</fieldsToNull><Condicao_Pagamento__r><Codigo_ERP__c>001</Codigo_ERP__c></Condicao_Pagamento__r><Forma_Pagamento__c>R$</Forma_Pagamento__c><Risco__c>E</Risco__c><Limite_Sugerido__c>0</Limite_Sugerido__c><Capital_Social__c>0</Capital_Social__c><Observacao_Cobranca__c></Observacao_Cobranca__c><Observacao_Cadastro__c>FIANCA</Observacao_Cadastro__c><Grupo_Tributario__c></Grupo_Tributario__c><Contribuinte__c>0</Contribuinte__c><Optante_pelo_Simples__c>0</Optante_pelo_Simples__c><Enviar_Para_Serasa__c>0</Enviar_Para_Serasa__c><Bloqueado__c>true</Bloqueado__c><Maior_Compra__c>0</Maior_Compra__c><fieldsToNull>Ultima_Compra__c</fieldsToNull><Saldo_Aberto_em_Titulos__c>0</Saldo_Aberto_em_Titulos__c><Pagamentos_Atrasados__c>0</Pagamentos_Atrasados__c><Titulos_Atrasados__c>0</Titulos_Atrasados__c><Maior_Atraso__c>0</Maior_Atraso__c><Media_Atraso__c>0</Media_Atraso__c><Valor_Acumulado__c>0</Valor_Acumulado__c><Numero_Pagamentos__c>0</Numero_Pagamentos__c><Limite_Disponivel__c>1000</Limite_Disponivel__c><Type>Consumo</Type><Rating>Standard</Rating><Cobranca_Externa__c>0</Cobranca_Externa__c><fieldsToNull>Grupo_Clientes__c</fieldsToNull><fieldsToNull>Situacao_Cobranca__c</fieldsToNull><fieldsToNull>Fax</fieldsToNull></Account>' 
	  	
	aadd(aHeadStr, 'POST /services/data/v34.0/sobjects/Account/Codigo_ERP__c/0161926690001 HTTP/1.1')
	aadd(aHeadStr, 'Authorization: Bearer 00Dq0000000B9DV!ARYAQLV.4aNXwqOZK6dw5AfKXXr545VGTiUKXfHpe1tZT24A5IxPs2g5nnHv.SRkpUV8KnSDxYnqBhEimOo7lDTMFnQlf7Km')
	aadd(aHeadStr, 'Content-Type: application/xml')	
  	aadd(aHeadStr, 'Content-Length:'+cValToChar(len(cPOSTParms)))
  	aadd(aHeadStr, 'Host: cs21.salesforce.com')
  	aadd(aHeadStr, 'Connection: Keep-Alive')
	

//	aadd(aHeadStr, 'X-PrettyPrint:1')          
	                                 

	cResponse:= HTTPSPost ( cUrl   ,'' ,'' ,'' , ,cPOSTParms, nTimeOut, aHeadStr, @cHeadRet) 
		
return



user function fHttpGet()

	Local cSFUrlLog		:= ""
	Local cSFCliId		:= ""
	Local cSFCliSec		:= ""
	Local cSFRefTk		:= ""
	
	Local nTimeOut		:= 120 //Segundos
	Local aHeaderStr	:= {}
	Local cHeaderRet	:= ""
	Local cResponse		:= ""
	Local cErroHTTP		:= ""
	Local nCodErrHTTP	:= 0	
	
	RPCSETTYPE(3)
	PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'
	
		//parametros da requisicao
	cSFUrlLog	:= alltrim(getmv("MV_XSFLOGI",.F.,"https://test.salesforce.com"))
	cSFResorc	:= alltrim(getmv("MV_XSFLGRC",.F.,"/services/oauth2/token") )	
	cSFCliId	:= alltrim(getmv("MV_XSFCLID",.F.,"3MVG9zZht._ZaMulEnuBSIKCavJEGPn6sHv3CjHleG2_1HaHLiQkcuz3smnd0zyzyX5xms8eAYQs7Qxm7S8pR"))	
	cSFCliSec	:= alltrim(getmv("MV_XSFCLSC",.F.,"4317265318539723652"))            
	cSFRefTk	:= alltrim(getmv("MV_XSFRFTK",.F.,"5Aep861OpTpDdf1AySSY0wE94WreycF4PYvlOpz8BVNSE_LbLmZ0Pm6NRZ8TDfoaWSuhfwhZiV0T1tQn.comaWy"))

	
	cGetParam := 'grant_type=refresh_token&client_id='+cSFCliId
	cGetParam += '&client_secret='+cSFCliSec
	cGetParam += '&refresh_token='+cSFRefTk
   
	aadd(aHeaderStr, 'Accept: application/xml')
	aadd(aHeaderStr, 'Content-Type: text/xml;charset=UTF-8')
	
	cResponse 	:= HttpsGet(cSFUrlLog + cSFResorc,'','','', cGetParam, nTimeOut , aHeaderStr , @cHeaderRet ) 
	
	nCodErrHTTP	:= HTTPGetStatus(cErroHTTP)
	
return