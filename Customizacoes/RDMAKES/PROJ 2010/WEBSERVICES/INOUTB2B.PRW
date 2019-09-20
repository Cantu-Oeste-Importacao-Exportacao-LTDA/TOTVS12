#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBEX.CH" 
#INCLUDE "TOPCONN.CH" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณINOUTB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo IN/OUT para webservices de integra็ใo do B2B Vertis. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/* 
### WSDL ###
http://vinhos.cantuimportadora.com.br/services/vcommstring.asmx?WSDL

#### CONFIGURAวีES DO APPSERVER.INI ####
[B2BVERTIS]
MAIN=U_RJJEDB2B()
ENVIRONMENT=PROTHEUS11
PREPAREIN=50,11

[ONSTART]
JOBS=B2BVERTIS
REFRESHRATE=1200      
#### CONFIGURAวีES DO APPSERVER.INI #### 
*/

#DEFINE CENDMAILWF		"juliano@cantu.com.br;b2b@cantuimportadora.com.br;e-commerce@cantuimportadora.com.br"		//--E-mail para envio do workflow
#DEFINE CPATHFILES		"/b2bvertis/"					//--Path de arquivos de log servidor protheus.
#DEFINE CEXTIMAGEM		".jpg"							//--Extensใo de arquivos de imagens.
#DEFINE CSESSIONID		""								//--ID da sessใo dos webservices.
#DEFINE STRINGNULL		""								//--String Null.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJECTB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de catแlogos.                           บฑฑ
ฑฑบTabela    ณDA0-Tabelas de precos.                                      บฑฑ
ฑฑบMetodo    ณImportCatalog                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJECTB2B(lEXPORTALL,lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJECTB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL     

	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% DA0.DA0_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf              
	

	//--Centros de distribui็ใo	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())

      	 If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		 Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
		    cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		 EndIf
	    cCODCD  := "% '"+(cAliasZ60)->Z60_CODCD+"' %"

		BeginSql Alias cAliasTMP
			SELECT		(DA0.DA0_CODTAB||%Exp:cCODCD%) DA0_CODTAB, DA0.DA0_DESCRI
			FROM 		%Exp:cTABDA0% DA0
			WHERE		DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND			%Exp:cWHERESQL%
						DA0.%NotDel%
			ORDER BY	DA0.DA0_CODTAB
		EndSql
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
		
			cXML := '<?xml version="1.0" encoding="utf-8"?>'
			cXML += '<CatalogType>'
			cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->DA0_CODTAB)+'</IdERP>'
			cXML += '<DsName>'+ALLTRIM((cAliasTMP)->DA0_DESCRI)+'</DsName>'
			cXML += '</CatalogType>'
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cXML)
	
			oObj := WSVCommString():New()
			oObj:csessionId	:= CSESSIONID
			oObj:ctypeXml	:= cXML	
			cRETWEBS1 := STRINGNULL
	
			If oObj:ImportCatalog()
				cRetXML := oObj:cImportCatalogResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			Else
				//--Escreve no arquivo de log.                         
				cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
				cRETWEBS1 := GetWscError(1)
				cRETWEBS3 := GetWscError(3)
				If cRETWEBS1 != nil
					cERRO += cRETWEBS1
				EndIf
				If cRETWEBS3 != nil
					cERRO += cRETWEBS3
				EndIf
				U_RJB2BWFL(hFILELOG,cERRO)		
			EndIf
			
			//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
			If ! "WSCERR044" $ cRETWEBS1
				(cAliasTMP)->(dbSkip())
			EndIf
			
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		(cAliasZ60)->(dbSkip())	
	Enddo
	(cAliasZ60)->(dbCloseArea())    

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJECLB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de clientes.                            บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณImportCompany                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJECLB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJECLB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL

	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% SA1.A1_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_CONTATO, SA1.A1_EMAIL, SA1.A1_CGC, 
					SA1.A1_INSCR, SA1.A1_DDD, SA1.A1_TEL, SA1.A1_X_SB2B, SA1.A1_MSBLQL, SA1.A1_LC, SA1.A1_SIMPNAC, 
					SA1.A1_TIPO, SA1.A1_X_DIB2B, SA1.A1_X_DSB2B, SA1.A1_X_VMB2B, SA1.A1_SUFRAMA, SA1.A1_GRPTRIB
		FROM 		%Table:SA1% SA1
		WHERE 		SA1.A1_X_EB2B	= %Exp:'S'%
		AND			SA1.A1_MSBLQL	!= %Exp:'1'%
		AND			%Exp:cWHERESQL%
			 		SA1.%NotDel%
		ORDER BY	SA1.A1_COD, SA1.A1_LOJA
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		/* Defini็ใo de valores sobre campos */
		//--Campo: NuExtensionPhone = Ramal
		cCODRAM := '0'
		//--Campo: FgOwner = Indica se ้ uma matriz
		cFOWNER := IIF(SUBSTR((cAliasTMP)->A1_CGC,12,1)=="1",'true','false')
		//--Campo: FgActive = Indica se esta ativa
		cACTIVE := IIF((cAliasTMP)->A1_MSBLQL!="1",'true','false')
		//--Campo: DsResponsibleName  = Nome do responsแvel
		cCONTAT := IIF(ALLTRIM((cAliasTMP)->A1_CONTATO)==STRINGNULL,ALLTRIM((cAliasTMP)->A1_NOME),ALLTRIM((cAliasTMP)->A1_CONTATO))
		cCONTAT := STRTRAN(cCONTAT,"&","")
		//--Campo: IdCompanyStatus = Status da empresa
		cSTATUS := IIF(ALLTRIM((cAliasTMP)->A1_X_SB2B)==STRINGNULL,"4",ALLTRIM((cAliasTMP)->A1_X_SB2B))
		//--Campo: IdERP = Cliente no ERP
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A1_COD))==8,ALLTRIM((cAliasTMP)->A1_COD)+"."+(cAliasTMP)->A1_LOJA,ALLTRIM((cAliasTMP)->(A1_COD+A1_LOJA))) 
		cCLIERP := ALLTRIM((cAliasTMP)->A1_CGC)
		//--Campo: FgTaxationType = Simples Nacional
		cSIMPNC :=IIF(ALLTRIM((cAliasTMP)->A1_SIMPNAC)=="1",'true','false')
		//--Campo: FgIPIDiscount = Desconto de IPI
		cDESIPI :=IIF(ALLTRIM((cAliasTMP)->A1_X_DIB2B)=="S",'true','false')
		//--Campo: FgTSDiscount = Desconto de ST
		cDESCST :=IIF(ALLTRIM((cAliasTMP)->A1_X_DSB2B)=="S",'true','false')
		//--NuPhoneDDD = DDD
	   	cDDDTEL := ALLTRIM((cAliasTMP)->A1_DDD)
	   	cDDDTEL := IIF(LEN(cDDDTEL)>2,SubSTR(cDDDTEL,2,2),cDDDTEL)
	   	//--NuPhone = Numero Telefone
	   	cNUMTEL := ALLTRIM((cAliasTMP)->A1_TEL)
	   	cNUMTEL := IIF(LEN(cNUMTEL)>9,SubSTR(cNUMTEL,1,9),cNUMTEL)
		//--IdOperationType = Tipo de opera็ใo fiscal
		cTPOFIS	:= IIF((cAliasTMP)->A1_TIPO=="R","2","1")	//--1=Venda;2=Revenda
		//--VlMinOrder = Valor mํnimo de compra	
		cVLRMIN := cValToChar((cAliasTMP)->A1_X_VMB2B*100)
                                   
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<CompanyType>'
		cXML += '<IdERP>'+cCLIERP+'</IdERP>'
		cXML += '<DsLegalName><![CDATA['+ALLTRIM((cAliasTMP)->A1_NOME)+']]></DsLegalName>'
		cXML += '<DsDbaName><![CDATA['+ALLTRIM((cAliasTMP)->A1_NREDUZ)+']]></DsDbaName>'
		cXML += '<DsResponsibleEmail>'+ALLTRIM((cAliasTMP)->A1_EMAIL)+'</DsResponsibleEmail>'
		cXML += '<DsResponsibleName><![CDATA['+cCONTAT+']]></DsResponsibleName>'
		cXML += '<DsCNPJ>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</DsCNPJ>'
		cXML += '<DsIE>'+ALLTRIM((cAliasTMP)->A1_INSCR)+'</DsIE>'
		cXML += '<NuPhoneDDD>'+cDDDTEL+'</NuPhoneDDD>'
		cXML += '<NuPhone>'+cNUMTEL+'</NuPhone>'
		cXML += '<NuExtensionPhone>'+cCODRAM+'</NuExtensionPhone>'		
		cXML += '<FgOwner>'+cFOWNER+'</FgOwner>'
		cXML += '<IdParentERP>'+cCLIERP+'</IdParentERP>'
		cXML += '<IdCompanyStatus>'+cSTATUS+'</IdCompanyStatus>'
		cXML += '<FgActive>'+cACTIVE+'</FgActive>'
		cXML += '<VlAccountLimit>'+cValToChar((cAliasTMP)->A1_LC)+'</VlAccountLimit>'                
		cXML += '<DsResponsibleShopName></DsResponsibleShopName>'
		cXML += '<DsResponsibleShopEmail>'+ALLTRIM((cAliasTMP)->A1_EMAIL)+'</DsResponsibleShopEmail>'
		cXML += '<DsResponsibleShopPhoneDDD></DsResponsibleShopPhoneDDD>'
		cXML += '<DsResponsibleShopPhone></DsResponsibleShopPhone>'				
		cXML += '<DsPassword>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</DsPassword>'
		cXML += '<NuSuframa>'+ALLTRIM((cAliasTMP)->A1_SUFRAMA)+'</NuSuframa>'
		cXML += '<FgTaxationType>'+cSIMPNC+'</FgTaxationType>'
		cXML += '<VlMinOrder>'+cVLRMIN+'</VlMinOrder>'
		cXML += '<FgInvoiceAddressAsDelivery>true</FgInvoiceAddressAsDelivery>'
		cXML += '<IdSalesUserERP></IdSalesUserERP>'
		cXML += '<IdCompanyType>6</IdCompanyType>'
		cXML += '<FgIPIDiscount>'+cDESIPI+'</FgIPIDiscount>'
		cXML += '<FgTSDiscount>'+cDESCST+'</FgTSDiscount>'
		cXML += '<DtTSDiscount></DtTSDiscount>'
		cXML += '<FgTSDiscount2>'+cDESCST+'</FgTSDiscount2>'
		cXML += '<DtTSDiscount2></DtTSDiscount2>'
		cXML += '<IdOperationType>'+cTPOFIS+'</IdOperationType>'
		cXML += '<VlPriceTableDiscount>0</VlPriceTableDiscount>'
		cXML += '<IdTaxGroup>'+ALLTRIM((cAliasTMP)->A1_GRPTRIB)+'</IdTaxGroup>'
		cXML += '</CompanyType>'      
		
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportCompany()
			cRetXML := oObj:cImportCompanyResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
			
			//--Chamada da fun็ใo de exporta็ใo de endere็os de clientes.
			U_RJEECB2B(lEXPORTALL, (cAliasTMP)->A1_COD, (cAliasTMP)->A1_LOJA, cCLIERP)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf                    
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEECB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de endere็os de clientes.                        บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณImportCompanyAddress                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJEECB2B(lEXPORTALL, cCODCLI, cLOJCLI, cCLIERP)

Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJEECB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cWHERESQL	:= STRINGNULL
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL

Default cCODCLI	:= STRINGNULL
Default cLOJCLI	:= STRINGNULL      

	//--Controle sobre exporta็ใo dos registros.
	cWHERESQL	:= "%"
	If ! lEXPORTALL
		cWHERESQL	+= " SA1.A1_X_AB2B = 'S' AND "
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	//--Controle sobre cliente especifico.
	If cCODCLI	!= STRINGNULL .AND. cLOJCLI	!= STRINGNULL
		cWHERESQL	+= " SA1.A1_COD = '"+cCODCLI+"' AND SA1.A1_LOJA = '"+cLOJCLI+"' AND "
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)	
	EndIf  
	cWHERESQL	+= "%"
	
	BeginSql Alias cAliasTMP
		SELECT		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_END, SA1.A1_BAIRRO, 
					SA1.A1_COMPLEM, SA1.A1_CEP, SA1.A1_MUN, SA1.A1_EST,
					SA1.A1_CGC, SA1.A1_NOME, SA1.A1_DDD, SA1.A1_TEL,
					SA1.A1_COD_MUN
		FROM 		%Table:SA1% SA1
		WHERE 		SA1.A1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		SA1.%NotDel%
		ORDER BY	SA1.A1_COD, SA1.A1_LOJA
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		/* Defini็ใo de valores sobre campos */
		//--Campo: IdERP = ID de endere็o - 1=Endere็o principal.
		cCODEND := ALLTRIM((cAliasTMP)->A1_CGC)+"1"
		//--Campo: Fun็ใo de tratamento sobre campo endere็o do cliente. 
		aENDCLI := U_RJB2BEND(ALLTRIM((cAliasTMP)->A1_END))
		//--NuPhoneDDD = DDD
	   	cDDDTEL := ALLTRIM((cAliasTMP)->A1_DDD)
	   	cDDDTEL := IIF(LEN(cDDDTEL)>2,SubSTR(cDDDTEL,2,2),cDDDTEL)
	   	//--NuPhone = Numero Telefone
	   	cNUMTEL := ALLTRIM((cAliasTMP)->A1_TEL)
	   	cNUMTEL := IIF(LEN(cNUMTEL)>9,SubSTR(cNUMTEL,1,9),cNUMTEL)
                                   
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<CompanyAddressType>'
		cXML += '<IdERP>'+cCODEND+'</IdERP>'
		cXML += '<IdCompanyERP>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</IdCompanyERP>'
		cXML += '<IdAddressType>'+aENDCLI[1]+'</IdAddressType>'
		cXML += '<DsAddress>'+aENDCLI[2]+'</DsAddress>'
		cXML += '<DsNumber>'+aENDCLI[3]+'</DsNumber>'
		cXML += '<DsComplement>'+ALLTRIM((cAliasTMP)->A1_COMPLEM)+'</DsComplement>'
		cXML += '<NuZip>'+ALLTRIM((cAliasTMP)->A1_CEP)+'</NuZip>'
		cXML += '<DsCity>'+ALLTRIM((cAliasTMP)->A1_MUN)+'</DsCity>'
		cXML += '<DsDistrict>'+ALLTRIM((cAliasTMP)->A1_BAIRRO)+'</DsDistrict>'
		cXML += '<IdState>'+ALLTRIM((cAliasTMP)->A1_EST)+'</IdState>'
		cXML += '<DsReference></DsReference>'
		cXML += '<IdCompanyAddressType>'+RIGHT(cCODEND,1)+'</IdCompanyAddressType>'
		cXML += '<IdCity>'+RJIDUF((cAliasTMP)->A1_EST)+(cAliasTMP)->A1_COD_MUN+'</IdCity>'
		cXML += '<DsAddressName><![CDATA['+ALLTRIM((cAliasTMP)->A1_NOME)+']]></DsAddressName>'
		cXML += '<DsCNPJ>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</DsCNPJ>'
		cXML += '<DsIE></DsIE>'
		cXML += '<NuPhoneDDD>'+cDDDTEL+'</NuPhoneDDD>'
		cXML += '<NuPhone>'+cNUMTEL+'</NuPhone>'
		cXML += '<NuExtensionPhone></NuExtensionPhone>'
		cXML += '</CompanyAddressType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportCompanyAddress()
			cRetXML := oObj:cImportCompanyAddressResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf                    
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.                           
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEDEB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de departamentos.                       บฑฑ
ฑฑบTabela    ณZ64-Departamentos.                                          บฑฑ
ฑฑบMetodo    ณImportDept                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEDEB2B(lEXPORTALL, lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEDEB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL

	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% Z64.Z64_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		Z64.Z64_CODIGO, Z64.Z64_NOME, Z64.Z64_DESC, 
					Z64.Z64_CODPAI, Z64.Z64_ATIVO, Z64.Z64_ORDEM,
					Z64.Z64_NUMCOL, Z64.Z64_DIRLIN
		FROM 		%Table:Z64% Z64
		WHERE 		Z64.Z64_ATIVO = %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		Z64.%NotDel%
		ORDER BY	Z64.Z64_CODIGO, Z64.Z64_NOME
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	
		/* Defini็ใo de valores sobre campos */
		//--Campo: FgActive = Ativo
		cACTIVE := IIF((cAliasTMP)->Z64_ATIVO!="N",'true','false')
		
		//--Campo: IdParentERP = Dep Pai
		cDEPPAI :=IIF(Empty((cAliasTMP)->Z64_CODPAI),'0',ALLTRIM((cAliasTMP)->Z64_CODPAI))
		
		//--Campo: FgExternalLink = Link Externo
		cLINKEX := IIF((cAliasTMP)->Z64_DIRLIN!="N",'true','false')

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DeptType>'
		cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->Z64_CODIGO)+'</IdERP>'
		cXML += '<DsName><![CDATA['+ALLTRIM((cAliasTMP)->Z64_NOME)+']]></DsName>'
		cXML += '<DsDescription><![CDATA['+ALLTRIM((cAliasTMP)->Z64_DESC)+']]></DsDescription>'
		cXML += '<IdParentERP>'+cDEPPAI+'</IdParentERP>'
		cXML += '<DsImage></DsImage>'
		cXML += '<FgActive>'+cACTIVE+'</FgActive>'
		cXML += '<NuOrder>'+cValToChar((cAliasTMP)->Z64_ORDEM)+'</NuOrder>'
		cXML += '<DsMenuImage></DsMenuImage>'
		cXML += '<DsHtml></DsHtml>'
		cXML += '<NuListColumns>'+cValToChar((cAliasTMP)->Z64_ORDEM)+'</NuListColumns>'
		cXML += '<FgExternalLink>'+cLINKEX+'</FgExternalLink>'
		cXML += '<DsExternalLink></DsExternalLink>'
		cXML += '<DsMetaDescription></DsMetaDescription>'
		cXML += '<DsMetaKeywords></DsMetaKeywords>'
		cXML += '<DsPageTitle></DsPageTitle>'
		cXML += '</DeptType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportDept()
			cRetXML := oObj:cImportDeptResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEDPB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de departamentos e produtos.            บฑฑ
ฑฑบTabela    ณZ65-Produtos x detalhes de produtos.                        บฑฑ
ฑฑบMetodo    ณImportDeptXProduct                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEDPB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEDPB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL

	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% Z65.Z65_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	                 
	                                            
	//--Envio do m้todo de exclusใo dos relacionamentos de departamentos x produtos.
	BeginSql Alias cAliasTMP
		SELECT		Z65.Z65_CODPRD, Z65.Z65_CODDEP
		FROM 		%Table:Z65% Z65, %Table:SB1% SB1		
		WHERE		Z65.Z65_CODPRD	= SB1.B1_COD
		AND 		SB1.B1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
					Z65.D_E_L_E_T_	= %Exp:'*'%
		GROUP BY 	Z65.Z65_CODPRD, Z65.Z65_CODDEP
		ORDER BY	Z65.Z65_CODPRD, Z65.Z65_CODDEP
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DeptXProductType>'
		cXML += '<IdProduct>'+ALLTRIM((cAliasTMP)->Z65_CODPRD)+'</IdProduct>'
		cXML += '</DeptXProductType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:DeleteDeptXProduct()
			cRetXML := oObj:cDeleteDeptXProductResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
	
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())

	
	
	//--Envio do m้todo de inclusใo dos relacionamentos de departamentos x produtos.
	
	BeginSql Alias cAliasTMP
		SELECT		Z65.Z65_CODPRD, Z65.Z65_CODDEP
		FROM 		%Table:Z65% Z65, %Table:SB1% SB1		
		WHERE		Z65.Z65_CODPRD	= SB1.B1_COD
		AND 		SB1.B1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
					Z65.%NotDel%
		AND 		SB1.%NotDel%
		GROUP BY 	Z65.Z65_CODPRD, Z65.Z65_CODDEP
		ORDER BY	Z65.Z65_CODPRD, Z65.Z65_CODDEP
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DeptXProductType>'
		cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->Z65_CODDEP)+'</IdERP>'
		cXML += '<IdProduct>'+ALLTRIM((cAliasTMP)->Z65_CODPRD)+'</IdProduct>'
		cXML += '</DeptXProductType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportDeptXProduct()
			cRetXML := oObj:cImportDeptXProductResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
	
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())


	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "Z65CMP"
		cFIELDUPD := "Z65_AB2B = 'N'"
		cWHEREUPD := "Z65_AB2B = 'S'"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEPDB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de produtos.                            บฑฑ
ฑฑบTabela    ณSB1-Cadastro de produtos.                                   บฑฑ
ฑฑบMetodo    ณImportProduct                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEPDB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias() 
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEPDB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
Local cDescProd	:= "" 
Local cEol 		:= "<![CDATA[<br><br>]]>"  //Utilizado para quebrar linha em XML
Local cBold		:= "<![CDATA[<b>]]>" //Deixa texto em negrito - tab <b>
Local cBoldF	:= "<![CDATA[</b>]]>" //Fecha a tag <b>
    
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% SB1.B1_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
			SELECT		SB1.B1_COD, SB1.B1_DESC, SB1.B1_MSBLQL, SB1.B1_POSIPI, SB1.B1_IPI, 
					TRIM(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(SB1.B1_X_DEGUS))) AS DEGUS,
					TRIM(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(SB1.B1_X_NOTAS))) AS ESTAGIA,
					(CASE 
						WHEN TRIM(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(SB1.B1_X_PREMI))) IS NULL THEN SB1.B1_DESC
					 ELSE 
						TRIM(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(SB1.B1_X_PREMI)))
					END 
					) AS DESCRICAO
						                      									
		FROM 		%Table:SB1% SB1
		WHERE 		SB1.B1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		SB1.%NotDel%
		ORDER BY	SB1.B1_COD
	EndSql  
	
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	
	    cRETWEBS1 := STRINGNULL
	    
	    //--Verifica se existe departamento relacionado ao produto                                      
	    cIDEPTMAIN := STRINGNULL
		If U_RJCHKDEP((cAliasTMP)->B1_COD, @cIDEPTMAIN)
		
			/* Defini็ใo de valores sobre campos */
			//--Campo: FgActive = Ativo
			cACTIVE := IIF((cAliasTMP)->B1_MSBLQL!="1",'true','false')
			
			//--Campo: FgHasSku = Indica se cont้m SKU 
			cPRDSKU := 'false'      
			
			//--Campo: IdProductBrandERP - Fabricante
			cFABRIC := FRECFAB((cAliasTMP)->B1_COD)
			If cFABRIC == STRINGNULL
				cFABRIC := '1'
			EndIf                                
			
			//--Campo: VlIPI - Aliquota de IPI
			cIPI := '0'
			If (cAliasTMP)->B1_IPI > 0
				cIPI := cValToChar((cAliasTMP)->B1_IPI*100)
			EndIf
			
			//@aqui
			//--Cria string com a descri็ใo completa do produto
			cDescProd := cBold + "Descri็ใo: "  			+ cBoldF + ALLTRIM((cAliasTMP)->DESCRICAO) 		+cEol
//			cDescProd += cBold + "Uva(s): "   			 	+ cBoldF + LOWER(ALLTRIM((cAliasTMP)->UVAS)) 	+cEol			
			cDescProd += cBold + "Comentแrio Sommelier: " 	+ cBoldF + LOWER(ALLTRIM((cAliasTMP)->DEGUS)) 	+cEol
			cDescProd += cBold + "Envelhecimento: "    		+ cBoldF + LOWER(ALLTRIM((cAliasTMP)->ESTAGIA)) +cEol			
			
			//--Campos de imagens
			cIMGPEQ := ALLTRIM((cAliasTMP)->B1_COD)+ "_pq"+CEXTIMAGEM
			cIMGPRD := ALLTRIM((cAliasTMP)->B1_COD)+ "_pd"+CEXTIMAGEM
			cIMGGRD := ALLTRIM((cAliasTMP)->B1_COD)+ "_gd"+CEXTIMAGEM
			cIMGMIN := ALLTRIM((cAliasTMP)->B1_COD)+ "_mn"+CEXTIMAGEM
			cIMGZOO := ALLTRIM((cAliasTMP)->B1_COD)+ "_zm"+CEXTIMAGEM
	
			cXML := '<?xml version="1.0" encoding="utf-8"?>'
			cXML += '<ProductType>'
			cXML += '<IdProduct>'+ALLTRIM((cAliasTMP)->B1_COD)+'</IdProduct>'
			//cXML += '<DsName>'+ALLTRIM((cAliasTMP)->B1_DESC)+'</DsName>' 
			cXML += '<DsName>'+ALLTRIM((cAliasTMP)->DESCRICAO)+'</DsName>'
			cXML += '<FgHasSku>'+cPRDSKU+'</FgHasSku>'
			cXML += '<DsImgSmall>'+cIMGPEQ+'</DsImgSmall>'
			cXML += '<DsImgNormal>'+cIMGPRD+'</DsImgNormal>'
			cXML += '<DsImgLarge>'+cIMGGRD+'</DsImgLarge>'
			cXML += '<DsImgMini>'+cIMGMIN+'</DsImgMini>'
			cXML += '<DsImgZoom>'+cIMGZOO+'</DsImgZoom>'
			cXML += '<DsKeywords></DsKeywords>'
			cXML += '<DsShortDescription></DsShortDescription>'
			//cXML += '<DsDescription>'+ALLTRIM((cAliasTMP)->B1_DESC)+'</DsDescription>'
			//@aqui
			cXML += '<DsDescription>'+cDescProd+'</DsDescription>'
			cXML += '<DsMarketingAdv></DsMarketingAdv>'
			cXML += '<FgActive>'+cACTIVE+'</FgActive>'
			cXML += '<IdProductTypeERP>1</IdProductTypeERP>'
			cXML += '<IdProductLineERP>1</IdProductLineERP>'
			cXML += '<IdProductBrandERP>'+cFABRIC+'</IdProductBrandERP>'
			cXML += '<IdProductSupplier>1</IdProductSupplier>'
			cXML += '<FgKit>false</FgKit>'
			cXML += '<IdDeptMainERP>'+cIDEPTMAIN+'</IdDeptMainERP>'
			cXML += '<NuOrder>0</NuOrder>'
			cXML += '<DsMetaDescription></DsMetaDescription>'
			cXML += '<DsMetaKeywords></DsMetaKeywords>'
			cXML += '<DsPageTitle></DsPageTitle>'
			cXML += '<DsVideoLink></DsVideoLink>'
			cXML += '<VlIPI>'+cIPI+'</VlIPI>'
			cXML += '<DsMediaFile></DsMediaFile>'
			cXML += '<DsNCM>'+ALLTRIM((cAliasTMP)->B1_POSIPI)+'</DsNCM>'
			cXML += '</ProductType>'
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cXML)
	
			oObj := WSVCommString():New()
			oObj:csessionId	:= CSESSIONID
			oObj:ctypeXml	:= cXML	
	
			If oObj:ImportProduct()
				cRetXML := oObj:cImportProductResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			Else
				//--Escreve no arquivo de log.                         
				cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
				cRETWEBS1 := GetWscError(1)
				cRETWEBS3 := GetWscError(3)
				If cRETWEBS1 != nil
					cERRO += cRETWEBS1
				EndIf
				If cRETWEBS3 != nil
					cERRO += cRETWEBS3
				EndIf
				U_RJB2BWFL(hFILELOG,cERRO)		
			EndIf  
			 
		
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,ALLTRIM((cAliasTMP)->B1_COD)+" - PRODUTO SEM DEPARTAMENTO.")
		EndIf
		
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		//If ! "WSCERR044" $ cRETWEBS1					
		If ! "WSCERR044" $ cRETWEBS1					
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())
	


	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEFBB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de fabricantes.                         บฑฑ
ฑฑบTabela    ณSA5-Amarra็ใo de Fornecedores x Produtos.                   บฑฑ
ฑฑบMetodo    ณImportProductBrand                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEFBB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEFBB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL	
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% (SB1.B1_X_AB2B = 'S') AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_NOME, SA2.A2_CGC
		FROM 		%Table:SB1% SB1, %Table:SA2% SA2, %Table:SA5% SA5
		WHERE 		SA5.A5_FORNECE	= SA2.A2_COD
		AND			SA5.A5_LOJA		= SA2.A2_LOJA
		AND			SA5.A5_PRODUTO	= SB1.B1_COD
		AND			SA2.A2_X_EB2B	= %Exp:'S'%
		AND			SB1.B1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		SA2.%NotDel%
		AND 		SA5.%NotDel%
		AND 		SB1.%NotDel%
		GROUP BY	SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_NOME, SA2.A2_CGC
		ORDER BY	SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_NOME, SA2.A2_CGC		
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	aCNPJ := U_RJGETCGC()
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	
		//--Nใo realiza a exporta็ใo das empresas do grupo.
		If aScan ( aCNPJ, {|x| ALLTRIM(x[1]) == ALLTRIM((cAliasTMP)->A2_CGC) } ) != 0 
			(cAliasTMP)->(dbSkip())
			Loop
		EndIf
		//--Campo: IdERP - C๓digo cliente
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A5_FORNECE))==8,ALLTRIM((cAliasTMP)->A5_FORNECE)+"."+(cAliasTMP)->A5_LOJA,ALLTRIM((cAliasTMP)->(A5_FORNECE+A5_LOJA)))
		cCLIERP := ALLTRIM((cAliasTMP)->A2_CGC)
		
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<ProductBrandType>'
		cXML += '<IdERP>'+cCLIERP+'</IdERP>'
		cXML += '<DsName>'+ALLTRIM((cAliasTMP)->A2_NOME)+'</DsName>'
		cXML += '<DsImage></DsImage>'
		cXML += '<FgCustomStore>true</FgCustomStore>'
		cXML += '<DsHtml></DsHtml>'
		cXML += '</ProductBrandType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportProductBrand()
			cRetXML := oObj:cImportProductBrandResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf          
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณFRECFAB     บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRecupera fabricante do produto.                             บฑฑ
ฑฑบTabela    ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FRECFAB(cCODPRD)

Local cAliasTMP	:= GetNextAlias()
Local cRet := STRINGNULL	
	
	BeginSql Alias cAliasTMP
		SELECT		SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_CGC
		FROM 		%Table:SB1% SB1, %Table:SA2% SA2, %Table:SA5% SA5
		WHERE 		SA5.A5_FORNECE	= SA2.A2_COD
		AND			SA5.A5_LOJA		= SA2.A2_LOJA
		AND			SA5.A5_PRODUTO	= SB1.B1_COD
		AND			SA2.A2_X_EB2B	= %Exp:'S'%
		AND			SB1.B1_COD		= %Exp:cCODPRD%
		AND			SB1.B1_X_EB2B	= %Exp:'S'%
		AND			SA2.%NotDel%
		AND 		SA5.%NotDel%
		AND 		SB1.%NotDel%
		GROUP BY	SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_NOME, SA2.A2_CGC
		ORDER BY	SA5.A5_FORNECE, SA5.A5_LOJA, SA2.A2_NOME, SA2.A2_CGC		
	EndSql
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		//--Campo: IdERP - C๓digo fornecedor
		cRet := IIF(LEN(ALLTRIM((cAliasTMP)->A5_FORNECE))==8,ALLTRIM((cAliasTMP)->A5_FORNECE)+"."+(cAliasTMP)->A5_LOJA,ALLTRIM((cAliasTMP)->(A5_FORNECE+A5_LOJA)))
	EndIf
	(cAliasTMP)->(dbCloseArea())
	
Return (cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEPSB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de produtos com SKU.                    บฑฑ
ฑฑบTabela    ณSB1/SB2-Produtos/Saldos em estoque.                         บฑฑ
ฑฑบMetodo    ณImportProductSku                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEPSB2B(lEXPORTALL,lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60 := GetNextAlias()
Local cAliasSB2 := GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEPSB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% SB1.B1_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SB1.B1_COD, SB1.B1_DESC, SB1.B1_PESO, SB1.B1_POSIPI,
					SB1.B1_ESTSEG, SB1.B1_X_PEB2B, SB1.B1_PE  
		FROM 		%Table:SB1% SB1
		WHERE 		SB1.B1_X_EB2B	= %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		SB1.%NotDel%
		ORDER BY	SB1.B1_COD
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

	    //--Verifica se existe departamento relacionado ao produto                                      
	    cIDEPTMAIN := STRINGNULL
		If U_RJCHKDEP((cAliasTMP)->B1_COD, @cIDEPTMAIN)
		
			/* Defini็ใo de valores sobre campos */
					
			//--Campo: NuMinimumInventory = Estoque mํnimo
			cESTSEG := cValToChar(IIF((cAliasTMP)->B1_ESTSEG==0,1,(cAliasTMP)->B1_ESTSEG))
			
			//--Campo: VlWeight = Peso em gramas
			cPESPRD := cValToChar(IIF((cAliasTMP)->B1_PESO==0,1,(cAliasTMP)->B1_PESO*1000))
			
			//--Campo: NuDeliveryTime	= Tempo de entrega
			cTMPENT := cValToChar(IIF((cAliasTMP)->B1_X_PEB2B==0,10,(cAliasTMP)->B1_X_PEB2B))
			 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณGustavo 18/12/2014 - Alterado para que os produtos sem estoque fiquem indisponiveisณ
			//ณMandando sempre 0 na tag NuDeliveryTime                                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

			//--Campo: NuSupplierDeliveryTime	= Tempo de entrega do fornecedor
			//cTMPFOR := cValToChar(IIF((cAliasTMP)->B1_PE==0,30,(cAliasTMP)->B1_PE))

			cTMPFOR := cValToChar((cAliasTMP)->B1_PE)
			
			//--Campos de imagens
			cIMGPEQ := ALLTRIM((cAliasTMP)->B1_COD)+ "_pq"+CEXTIMAGEM
			cIMGPRD := ALLTRIM((cAliasTMP)->B1_COD)+ "_pd"+CEXTIMAGEM
			cIMGGRD := ALLTRIM((cAliasTMP)->B1_COD)+ "_gd"+CEXTIMAGEM
			cIMGMIN := ALLTRIM((cAliasTMP)->B1_COD)+ "_mn"+CEXTIMAGEM
			cIMGZOO := ALLTRIM((cAliasTMP)->B1_COD)+ "_zm"+CEXTIMAGEM
	
			//--Centros de distribui็ใo	
			BeginSql Alias cAliasZ60
				SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
				FROM 		%Table:Z60% Z60
				WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
				AND			Z60.%NotDel%
				ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
			EndSql
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
			
			dbSelectArea(cAliasZ60)
			(cAliasZ60)->(dbGoTop())
			While !(cAliasZ60)->(EOF())
		      	
		      	cTABSB2 := "% SB2"+(cAliasZ60)->Z60_CODEM+"0 %"
		      	cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		      	cCODPRD := "% '"+(cAliasTMP)->B1_COD+"' %"
		      	
				//--Saldos em estoque
				BeginSql Alias cAliasSB2
					SELECT		COUNT(*) NUMREG
					FROM 		%Exp:cTABSB2% SB2
					WHERE 		SB2.B2_FILIAL	= %Exp:cCODFIL%
					AND			SB2.B2_COD		= %Exp:cCODPRD%
					AND			SB2.B2_LOCAL	= %Exp:'VINHOS'%
					AND			SB2.%NotDel%
				EndSql
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
				
				cRETWEBS1 := STRINGNULL			
				
				dbSelectArea(cAliasSB2)
				(cAliasSB2)->(dbGoTop())
				If !(cAliasSB2)->(EOF()) .AND. (cAliasSB2)->NUMREG > 0
	
					//--Campo: NuLocalInventory	= Estoque local
					nQTDVEN := U_RJESTB2B(cCODPRD, cCODFIL, cTABSB2)

					//--Adiciona a qtde em estoque do CD 1001 para todos os demais CDs menos nordeste.
					If (cAliasZ60)->Z60_CODCD != "1001" .and. (cAliasZ60)->Z60_CODCD != "0203"       
				      	cTAB1001 := "% SB2100 %"
				      	cFIL1001 := "% '01' %"
						nQTD1001 := U_RJESTB2B(cCODPRD, cFIL1001, cTAB1001)
						nQTDVEN += nQTD1001	
					EndIf

					If nQTDVEN == 0
						nQTDVEN := 1
					EndIf
					cQTDVEN := cValToChar(nQTDVEN)
							
					//--Campo: IdProductSaleStatus = Status de disponibilidade de venda (1=Disponํvel, 2=Indisponํvel)
					cDISVEN := IIF(nQTDVEN>0,'1','2') 
	
	
					cXML := '<?xml version="1.0" encoding="utf-8"?>'
					cXML += '<ProductSkuType>	
					cXML += '<IdProductSku>'+ALLTRIM((cAliasTMP)->B1_COD)+'</IdProductSku>	
					cXML += '<IdProduct>'+ALLTRIM((cAliasTMP)->B1_COD)+'</IdProduct>	
					cXML += '<NuLocalInventory>'+cQTDVEN+'</NuLocalInventory>	
					cXML += '<NuMinimumInventory>'+cESTSEG+'</NuMinimumInventory>	
					cXML += '<VlWeight>'+cPESPRD+'</VlWeight>	
					cXML += '<NuDeliveryTime>'+cTMPENT+'</NuDeliveryTime>	
					cXML += '<NuSupplierDeliveryTime>'+cTMPFOR+'</NuSupplierDeliveryTime>	
					cXML += '<DsImgSmall>'+cIMGPEQ+'</DsImgSmall>'
					cXML += '<DsImgNormal>'+cIMGPRD+'</DsImgNormal>'
					cXML += '<DsImgMini>'+cIMGMIN+'</DsImgMini>'
					cXML += '<DsImgZoom>'+cIMGZOO+'</DsImgZoom>'
					cXML += '<IdProductSaleStatus>'+cDISVEN+'</IdProductSaleStatus>	
					cXML += '<DsImgLarge>'+cIMGGRD+'</DsImgLarge>	
					cXML += '<FgSupplierOrder>false</FgSupplierOrder>	
					cXML += '<IdDistributionCenterERP>'+ALLTRIM((cAliasZ60)->Z60_CODCD)+'</IdDistributionCenterERP>	
					cXML += '<DsNCM>'+ALLTRIM((cAliasTMP)->B1_POSIPI)+'</DsNCM>	
					cXML += '</ProductSkuType>	
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cXML)
			
					oObj := WSVCommString():New()
					oObj:csessionId	:= CSESSIONID
					oObj:ctypeXml	:= cXML	
					
					If oObj:ImportProductSku()
						cRetXML := oObj:cImportProductSkuResult
						//--Escreve no arquivo de log.
						U_RJB2BWFL(hFILELOG,cRetXML)
					Else
						//--Escreve no arquivo de log.                         
						cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
						cRETWEBS1 := GetWscError(1)
						cRETWEBS3 := GetWscError(3)
						If cRETWEBS1 != nil
							cERRO += cRETWEBS1
						EndIf
						If cRETWEBS3 != nil
							cERRO += cRETWEBS3
						EndIf
						U_RJB2BWFL(hFILELOG,cERRO)		
					EndIf  
					 
					
				EndIf                  
				(cAliasSB2)->(dbCloseArea())
					
				//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
				If ! "WSCERR044" $ cRETWEBS1
					(cAliasZ60)->(dbSkip())
				EndIf
			Enddo             
			(cAliasZ60)->(dbCloseArea())
	   	
	   	Else

			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,ALLTRIM((cAliasTMP)->B1_COD)+" - PRODUTO SEM DEPARTAMENTO.")

	   	EndIf
	   				
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	                  
	
	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "SB1CMP"
		cFIELDUPD := "B1_X_AB2B = 'N'"
		cWHEREUPD := "B1_X_EB2B = 'S' AND B1_X_AB2B = 'S'"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJETPB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de tabelas de pre็os.                   บฑฑ
ฑฑบTabela    ณDA1-Itens de tabela de pre็o.                               บฑฑ
ฑฑบMetodo    ณImportProductSkuPrice                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJETPB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60 := GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJETPB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% ( DA0.DA0_X_AB2B = 'S' AND DA1.DA1_X_AB2B = 'S' ) AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf                        
	
	//--Centros de distribui็ใo	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())

      	If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
			cTABDA1 := "% DA1300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		 Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
			cTABDA1 := "% DA1"+(cAliasZ60)->Z60_CODEM+"0 %"
	    	cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
	  	EndIf
	    cCODCD  := "% '"+(cAliasZ60)->Z60_CODCD+"' %"
	
	
		BeginSql Alias cAliasTMP
			SELECT		(DA1.DA1_CODTAB||%Exp:cCODCD%) DA1_CODTAB, DA1.DA1_CODPRO, DA1.DA1_PRCVEN
			FROM 		%Exp:cTABDA0% DA0, %Exp:cTABDA1% DA1, %Table:SB1% SB1 
			WHERE		DA0.DA0_FILIAL	= DA1.DA1_FILIAL
			AND			DA0.DA0_CODTAB	= DA1.DA1_CODTAB
			AND			DA1.DA1_CODPRO	= SB1.B1_COD
			AND			DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND 		DA0.DA0_ATIVO	= %Exp:'1'%  
			AND 		SB1.B1_X_EB2B	= %Exp:'S'%
			AND			%Exp:cWHERESQL%
				 		DA0.%NotDel%
			AND 		DA1.%NotDel%
			AND 		SB1.%NotDel%
			ORDER BY	DA1.DA1_CODPRO
		EndSql
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
		
		    //--Verifica se existe departamento relacionado ao produto                                      
			cIDEPTMAIN := STRINGNULL
			If U_RJCHKDEP((cAliasTMP)->DA1_CODPRO, @cIDEPTMAIN)
	
				/* Defini็ใo de valores sobre campos */
	
				//--Campo: VlListPrice = Pre็o (multiplicado por 100: R$ 1,00 = 100)
				cPRCVEN := cValToChar((cAliasTMP)->DA1_PRCVEN*100)
				
				//--Campo: VlSalePrice = Pre็o de venda promocional (multiplicado por 100: R$ 1,00 = 100)
				cPRCPRM := cPRCVEN
			
				cXML := '<?xml version="1.0" encoding="utf-8"?>'
				cXML += '<ProductSkuPriceType>'
				cXML += '<IdProductSku>'+ALLTRIM((cAliasTMP)->DA1_CODPRO)+'</IdProductSku>'
				cXML += '<IdPriceTableERP>'+ALLTRIM((cAliasTMP)->DA1_CODTAB)+'</IdPriceTableERP>'
				cXML += '<VlListPrice>'+cPRCVEN+'</VlListPrice>'
				cXML += '<VlSalePrice>0</VlSalePrice>'
				cXML += '<IdPayGroup>1</IdPayGroup>'
				cXML += '<IdDistributionCenterERP>'+ALLTRIM((cAliasZ60)->Z60_CODCD)+'</IdDistributionCenterERP>'
				cXML += '</ProductSkuPriceType>'
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cXML)
		
				oObj := WSVCommString():New()
				oObj:csessionId	:= CSESSIONID
				oObj:ctypeXml	:= cXML
				cRETWEBS1 := STRINGNULL	
		
				If oObj:ImportProductSkuPrice()
					cRetXML := oObj:cImportProductSkuPriceResult
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cRetXML)
				Else
					//--Escreve no arquivo de log.                         
					cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
					cRETWEBS1 := GetWscError(1)
					cRETWEBS3 := GetWscError(3)
					If cRETWEBS1 != nil
						cERRO += cRETWEBS1
					EndIf
					If cRETWEBS3 != nil
						cERRO += cRETWEBS3
					EndIf
					U_RJB2BWFL(hFILELOG,cERRO)		
				EndIf
			
			Else 

				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,ALLTRIM((cAliasTMP)->DA1_CODPRO)+" - PRODUTO SEM DEPARTAMENTO.")
				
			EndIf				 
			
			//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
			If ! "WSCERR044" $ cRETWEBS1
				(cAliasTMP)->(dbSkip())
			EndIf
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		(cAliasZ60)->(dbSkip())
	Enddo
	(cAliasZ60)->(dbCloseArea())

	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJECDB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de catแlogos x departamentos.           บฑฑ
ฑฑบTabela    ณDA0-Tabelas de pre็os/Z64-Departamentos.                    บฑฑ
ฑฑบMetodo    ณImportCatalogXDept                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJECDB2B(lEXPORTALL,lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJECDB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% ( DA0.DA0_X_AB2B = 'S' OR Z64.Z64_AB2B = 'S' ) AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf              
	

	//--Centros de distribui็ใo	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())

      	 If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		 Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
		    cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		 EndIf
	    cCODCD  := "% '"+(cAliasZ60)->Z60_CODCD+"' %"

		BeginSql Alias cAliasTMP
			SELECT		(DA0.DA0_CODTAB||%Exp:cCODCD%) DA0_CODTAB, Z64.Z64_CODIGO
			FROM 		%Exp:cTABDA0% DA0, %Table:Z64% Z64
			WHERE		DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND			Z64.Z64_ATIVO 	= %Exp:'S'%
			AND			%Exp:cWHERESQL%
						DA0.%NotDel%
			AND			Z64.%NotDel%
			ORDER BY	DA0.DA0_CODTAB, Z64.Z64_CODIGO
		EndSql
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
		
			cXML := '<?xml version="1.0" encoding="utf-8"?>'
			cXML += '<CatalogXDeptType xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">'
			cXML += '<IdCatalogERP>'+ALLTRIM((cAliasTMP)->DA0_CODTAB)+'</IdCatalogERP>'
			cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->Z64_CODIGO)+'</IdERP>'
			cXML += '</CatalogXDeptType>'
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cXML)
	
			oObj := WSVCommString():New()
			oObj:csessionId	:= CSESSIONID
			oObj:ctypeXml	:= cXML	
			cRETWEBS1 := STRINGNULL
	
			If oObj:ImportCatalogXDept()
				cRetXML := oObj:cImportCatalogXDeptResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			Else
				//--Escreve no arquivo de log.                         
				cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
				cRETWEBS1 := GetWscError(1)
				cRETWEBS3 := GetWscError(3)
				If cRETWEBS1 != nil
					cERRO += cRETWEBS1
				EndIf
				If cRETWEBS3 != nil
					cERRO += cRETWEBS3
				EndIf
				U_RJB2BWFL(hFILELOG,cERRO)		
			EndIf
			
			//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
			If ! "WSCERR044" $ cRETWEBS1
				(cAliasTMP)->(dbSkip())
			EndIf
			
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		(cAliasZ60)->(dbSkip())	
	Enddo
	(cAliasZ60)->(dbCloseArea())    


	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "Z64CMP"
		cFIELDUPD := "Z64_AB2B = 'N'"
		cWHEREUPD := "Z64_AB2B = 'S'"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf


	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJECPB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados catแlogos x produtos.                   บฑฑ
ฑฑบTabela    ณDA1-Itens de tabela de pre็o.                               บฑฑ
ฑฑบMetodo    ณImportCatalogXProduct                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJECPB2B(lEXPORTALL, lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60 := GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJECPB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% ( DA0.DA0_X_AB2B = 'S' OR DA1.DA1_X_AB2B = 'S' ) AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf                        
	
	//--Centros de distribui็ใo	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())

      	If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
			cTABDA1 := "% DA1300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
			cTABDA1 := "% DA1"+(cAliasZ60)->Z60_CODEM+"0 %"
	    	cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
	  	EndIf
	    cCODCD  := "% '"+(cAliasZ60)->Z60_CODCD+"' %"
	
	
		BeginSql Alias cAliasTMP
			SELECT		(DA1.DA1_CODTAB||%Exp:cCODCD%) DA1_CODTAB, DA1.DA1_CODPRO, DA1.DA1_PRCVEN
			FROM 		%Exp:cTABDA0% DA0, %Exp:cTABDA1% DA1, %Table:SB1% SB1 
			WHERE		DA0.DA0_FILIAL	= DA1.DA1_FILIAL
			AND			DA0.DA0_CODTAB	= DA1.DA1_CODTAB
			AND			DA1.DA1_CODPRO	= SB1.B1_COD
			AND			DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND 		DA0.DA0_ATIVO	= %Exp:'1'%
			AND 		SB1.B1_X_EB2B	= %Exp:'S'%
			AND			%Exp:cWHERESQL%
				 		DA0.%NotDel%
			AND 		DA1.%NotDel%
			AND 		SB1.%NotDel%
			ORDER BY	DA1.DA1_CODPRO
		EndSql
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
		
		    //--Verifica se existe departamento relacionado ao produto                                      
			cIDEPTMAIN := STRINGNULL
			If U_RJCHKDEP((cAliasTMP)->DA1_CODPRO, @cIDEPTMAIN)
	
			
				cXML := '<?xml version="1.0" encoding="utf-8"?>'
				cXML += '<CatalogXProductType>'
				cXML += '<IdCatalogERP>'+ALLTRIM((cAliasTMP)->DA1_CODTAB)+'</IdCatalogERP>'
				cXML += '<IdProduct>'+ALLTRIM((cAliasTMP)->DA1_CODPRO)+'</IdProduct>'
				cXML += '</CatalogXProductType>'
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cXML)
		
				oObj := WSVCommString():New()
				oObj:csessionId	:= CSESSIONID
				oObj:ctypeXml	:= cXML
				cRETWEBS1 := STRINGNULL	
		
				If oObj:ImportCatalogXProduct()
					cRetXML := oObj:cImportCatalogXProductResult
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cRetXML)
				Else
					//--Escreve no arquivo de log.                         
					cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
					cRETWEBS1 := GetWscError(1)
					cRETWEBS3 := GetWscError(3)
					If cRETWEBS1 != nil
						cERRO += cRETWEBS1
					EndIf
					If cRETWEBS3 != nil
						cERRO += cRETWEBS3
					EndIf
					U_RJB2BWFL(hFILELOG,cERRO)		
				EndIf
			
			Else 

				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,ALLTRIM((cAliasTMP)->DA1_CODPRO)+" - PRODUTO SEM DEPARTAMENTO.")
				
			EndIf				 
			
			//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
			If ! "WSCERR044" $ cRETWEBS1
				(cAliasTMP)->(dbSkip())
			EndIf
		Enddo
		(cAliasTMP)->(dbCloseArea())

		
		//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
		If lUPDATEREC

			//DA0-Cabe็alho Tabela Pre็o
			If (cAliasZ60)->Z60_CODEM == "31"
				cTABLEUPD := "DA0300"
				cWHEREUPD := "DA0_FILIAL = '"+Space(TAMSX3("DA0_FILIAL")[1])+"' AND DA0_X_EB2B = 'S' AND DA0_X_AB2B = 'S'"
			Else
				cTABLEUPD := "DA0"+(cAliasZ60)->Z60_CODEM+"0"                                                     
				cWHEREUPD := "DA0_FILIAL = '"+(cAliasZ60)->Z60_CODFL+"' AND DA0_X_EB2B = 'S' AND DA0_X_AB2B = 'S'"
			EndIf
			cFIELDUPD := "DA0_X_AB2B = 'N'"  
			cINNERUPD := STRINGNULL
			cERRORUPD := STRINGNULL
			If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cERRORUPD)
			Else
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cTABLEUPD+"-UPDATE REALIZADO COM SUCESSO.")
			EndIf

			//DA1-Itens Tabela Pre็o
			If (cAliasZ60)->Z60_CODEM == "31"
				cTABLEUPD := "DA1300"
				cWHEREUPD := "DA1_FILIAL = '"+Space(TAMSX3("DA1_FILIAL")[1])+"' AND DA1_X_AB2B = 'S'"
			Else
				cTABLEUPD := "DA1"+(cAliasZ60)->Z60_CODEM+"0"                                                     
				cWHEREUPD := "DA1_FILIAL = '"+(cAliasZ60)->Z60_CODFL+"' AND DA1_X_AB2B = 'S'"
			EndIf
			cFIELDUPD := "DA1_X_AB2B = 'N'"  
			cINNERUPD := STRINGNULL
			cERRORUPD := STRINGNULL
			If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cERRORUPD)
			Else
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cTABLEUPD+"-UPDATE REALIZADO COM SUCESSO.")
			EndIf

		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
		EndIf                              

		
		(cAliasZ60)->(dbSkip())
	Enddo
	(cAliasZ60)->(dbCloseArea())

	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return





/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEPFB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de perfil.                              บฑฑ
ฑฑบTabela    ณZ50-Perfil E-commerce.                                      บฑฑ
ฑฑบMetodo    ณImportProfile                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEPFB2B(lEXPORTALL, lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEPFB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	

	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% Z50.Z50_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf

	BeginSql Alias cAliasTMP
		SELECT		Z50.Z50_CODIGO, Z50.Z50_DESC, Z50.Z50_CODCD, Z50.Z50_TABPRC, Z50.Z50_PERC
		FROM 		%Table:Z50% Z50
		WHERE 		Z50.Z50_ATIVO	= %Exp:'S'%		
		AND			%Exp:cWHERESQL%
			 		Z50.%NotDel%
		ORDER BY	Z50.Z50_CODIGO
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		
		/* Defini็ใo de valores sobre campos */		
		//--Campo: VlPriceDiscount = Desconto no pre็o (porcentagem multiplicado por 100: 5% = 500)
		cPRCDES := cValToChar((cAliasTMP)->Z50_PERC*100)

		
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<ProfileType>'
		cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->Z50_CODIGO)+'</IdERP>'
		cXML += '<IdCatalogERP>'+ALLTRIM((cAliasTMP)->(Z50_TABPRC+Z50_CODCD))+'</IdCatalogERP>'
		cXML += '<IdPriceTableERP>'+ALLTRIM((cAliasTMP)->(Z50_TABPRC+Z50_CODCD))+'</IdPriceTableERP>'
		cXML += '<DsName>'+ALLTRIM((cAliasTMP)->Z50_DESC)+'</DsName>'
		cXML += '<VlPriceDiscount>'+cPRCDES+'</VlPriceDiscount>'
		cXML += '</ProfileType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:ImportProfile()
			cRetXML := oObj:cImportProfileResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf          
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())


	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "Z50CMP"
		cFIELDUPD := "Z50_AB2B = 'N'"
		cWHEREUPD := "Z50_ATIVO = 'S' AND Z50_AB2B = 'S'"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEPTB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo das tabelas de pre็os.                           บฑฑ
ฑฑบTabela    ณDA0-Cabecalho tabela de pre็os.                             บฑฑ
ฑฑบMetodo    ณImportPriceTable                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEPTB2B(lEXPORTALL, lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60 := GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEPTB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% DA0.DA0_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf              
	

	//--Centros de distribui็ใo	
	BeginSql Alias cAliasZ60
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
		AND			Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasZ60)
	(cAliasZ60)->(dbGoTop())
	While !(cAliasZ60)->(EOF())
      	
      	If (cAliasZ60)->Z60_CODEM == "31"
			cTABDA0 := "% DA0300 %"
		    cCODFIL := "% '"+Space(TAMSX3("DA0_FILIAL")[1])+"' %"
		 Else 
			cTABDA0 := "% DA0"+(cAliasZ60)->Z60_CODEM+"0 %"
		    cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		 EndIf
	
	    cCODCD  := "% '"+(cAliasZ60)->Z60_CODCD+"' %"

		BeginSql Alias cAliasTMP
			SELECT		(DA0.DA0_CODTAB||%Exp:cCODCD%) DA0_CODTAB, DA0.DA0_DESCRI
			FROM 		%Exp:cTABDA0% DA0
			WHERE		DA0.DA0_FILIAL	= %Exp:cCODFIL%
			AND 		DA0.DA0_X_EB2B	= %Exp:'S'%
			AND			%Exp:cWHERESQL%
						DA0.%NotDel%
			ORDER BY	DA0.DA0_CODTAB
		EndSql
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
	
			cXML := '<?xml version="1.0" encoding="utf-8"?>
			cXML += '<PriceTableType>
			cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->DA0_CODTAB)+'</IdERP>
			cXML += '<DsName>'+ALLTRIM((cAliasTMP)->DA0_DESCRI)+'</DsName>
			cXML += '</PriceTableType>
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cXML)
	
			oObj := WSVCommString():New()
			oObj:csessionId	:= CSESSIONID
			oObj:ctypeXml	:= cXML	   
			cRETWEBS1 := STRINGNULL
	
			If oObj:ImportPriceTable()
				cRetXML := oObj:cImportPriceTableResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			Else
				//--Escreve no arquivo de log.                         
				cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
				cRETWEBS1 := GetWscError(1)
				cRETWEBS3 := GetWscError(3)
				If cRETWEBS1 != nil
					cERRO += cRETWEBS1
				EndIf
				If cRETWEBS3 != nil
					cERRO += cRETWEBS3
				EndIf
				U_RJB2BWFL(hFILELOG,cERRO)		
			EndIf  
			 
			//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
			If ! "WSCERR044" $ cRETWEBS1
				(cAliasTMP)->(dbSkip())
			EndIf
			
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		(cAliasZ60)->(dbSkip())	
	Enddo
	(cAliasZ60)->(dbCloseArea())    

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJEPCB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de perfil e clientes.                   บฑฑ
ฑฑบTabela    ณZ50-Perfil E-commerce/SA1-Cadastro de clientes.             บฑฑ
ฑฑบMetodo    ณImportProfileXCompany                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJEPCB2B(lEXPORTALL)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJEPCB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	

	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% (Z50.Z50_AB2B = 'S' OR SA1.A1_X_AB2B = 'S') AND %"
		U_RJB2BWFL(hFILELOG,cWHERESQL)
		//--Escreve no arquivo de log.
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		Z50.Z50_CODIGO, SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC
		FROM 		%Table:Z50% Z50, %Table:SA1% SA1  
		WHERE 		SA1.A1_X_CPB2B	= Z50.Z50_CODIGO 
		AND			SA1.A1_X_EB2B		= %Exp:'S'%
		AND			Z50.Z50_ATIVO		= %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		Z50.%NotDel%
		AND 		SA1.%NotDel%
		ORDER BY	SA1.A1_COD, SA1.A1_LOJA
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])

	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	
		//--Campo: IdERP - C๓digo cliente
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A1_COD))==8,ALLTRIM((cAliasTMP)->A1_COD)+"."+(cAliasTMP)->A1_LOJA,ALLTRIM((cAliasTMP)->(A1_COD+A1_LOJA)))
		cCLIERP := ALLTRIM((cAliasTMP)->A1_CGC)

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<ProfileXCompanyType>'
		cXML += '<IdProfileERP>'+ALLTRIM((cAliasTMP)->Z50_CODIGO)+'</IdProfileERP>'
		//@aqui
	   	//	cXML += '<IdCompanyERP>'+cCLIERP+'</IdCompanyERP>'  
	   	cXML += '<IdCompanyERP>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</IdCompanyERP>'
	   
		cXML += '</ProfileXCompanyType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:ImportProfileXCompany()
			cRetXML := oObj:cImportProfileXCompanyResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf          
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)
                                                       
Return                                                 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJIDTB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de centros de distribui็ใo.             บฑฑ
ฑฑบTabela    ณZ60-Centro Distribui็ใo                                     บฑฑ
ฑฑบMetodo    ณImportDistributionCenter                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJIDTB2B(lEXPORTALL)
Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJIDTB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	

	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL := "% Z60.Z60_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf

	BeginSql Alias cAliasTMP
		SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
		FROM 		%Table:Z60% Z60
		WHERE 		Z60.Z60_ATIVO = %Exp:'S'% 
		AND			%Exp:cWHERESQL%
					Z60.%NotDel%
		ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	nSM0REC := SM0->(RECNO())
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		dbSelectArea("SM0")
		dbSetOrder(1)      
		dbSeek((cAliasTMP)->Z60_CODCD)
	    aENDCLI := U_RJB2BEND(ALLTRIM(SM0->M0_ENDCOB))
	                      
	    cCDDEFAULT := 'false'
	    If ALLTRIM((cAliasTMP)->Z60_CODCD) == "1001"
	    	cCDDEFAULT := 'true'
	    EndIf
	    
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DistributionCenterType>'
		cXML += '<IdERP>'+ALLTRIM((cAliasTMP)->Z60_CODCD)+'</IdERP>'
		cXML += '<DsName><![CDATA['+ALLTRIM(SM0->M0_FILIAL)+']]></DsName>'
		cXML += '<FgActive>true</FgActive>'	
		cXML += '<FgDefault>'+cCDDEFAULT+'</FgDefault>'	
		cXML += '<DsAddress><![CDATA['+aENDCLI[2]+']]></DsAddress>'	
		cXML += '<DsNumber><![CDATA['+aENDCLI[3]+']]></DsNumber>'	
		cXML += '<DsComplement><![CDATA['+ALLTRIM(SM0->M0_COMPENT)+']]></DsComplement>'
		cXML += '<DsDistrict><![CDATA['+ALLTRIM(SM0->M0_BAIRCOB)+']]></DsDistrict>'
		cXML += '<NuZip>'+ALLTRIM(SM0->M0_CEPCOB)+'</NuZip>'
		cXML += '<IdCity>'+SM0->M0_CODMUN+'</IdCity>'
		cXML += '<DsCity><![CDATA['+ALLTRIM(SM0->M0_CIDCOB)+']]></DsCity>'
		cXML += '<IdState>'+ALLTRIM(SM0->M0_ESTCOB)+'</IdState>'
		cXML += '<NuPhoneDDD>'+SUBSTR(SM0->M0_TEL,4,2)+'</NuPhoneDDD>'
		cXML += '<NuPhone>'+SUBSTR(SM0->M0_TEL,7,8)+'</NuPhone>'
		cXML += '<NuBranchLine></NuBranchLine>'
		cXML += '</DistributionCenterType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)
		
    	
		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml := cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:ImportDistributionCenter()
			cRetXML := oObj:cImportDistributionCenterResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.                           
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	
	dbSelectArea("SM0")
	SM0->(dbGoTo(nSM0REC))
	
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)
                                                       
Return             

                   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJIDCB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de centros de distribui็ใo x clientes   บฑฑ
ฑฑบTabela    ณZ60-Centro Distribui็ใo-Z61-UF CDs-SA1-Clientes             บฑฑ
ฑฑบMetodo    ณImportDistributionCenterXCompany                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJIDCB2B(lEXPORTALL, cCNPJ)
Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJIDCB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	                         
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% (Z60.Z60_AB2B = 'S' OR SA1.A1_X_AB2B = 'S') AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	If cCNPJ != STRINGNULL
		cWHERESQL	:= "% SA1.A1_CGC = '"+cCNPJ+"' AND %"
	EndIf

	BeginSql Alias cAliasTMP
		SELECT		Z60.Z60_CODCD, SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC
		FROM 		%Table:Z60% Z60, %Table:Z61% Z61, %Table:SA1% SA1
		WHERE 		Z60.Z60_CODCD = Z61.Z61_CODCD
		AND			SA1.A1_EST	  = Z61.Z61_CODUF
		AND			Z60.Z60_ATIVO = %Exp:'S'% 
		AND			SA1.A1_X_EB2B = %Exp:'S'%
		AND			SA1.A1_MSBLQL != %Exp:'1'%	
		AND			%Exp:cWHERESQL%
					Z60.%NotDel%
		AND			Z61.%NotDel%
		AND			SA1.%NotDel%
		ORDER BY	Z60.Z60_CODCD, SA1.A1_COD
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	    
		//--Campo: IdERP = Cliente no ERP
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A1_COD))==8,ALLTRIM((cAliasTMP)->A1_COD)+"."+(cAliasTMP)->A1_LOJA,ALLTRIM((cAliasTMP)->(A1_COD+A1_LOJA))) 
		cCLIERP := ALLTRIM((cAliasTMP)->A1_CGC)
	

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DistributionCenterXCompanyType>'
		cXML += '<IdDistributionCenterERP>'+ALLTRIM((cAliasTMP)->Z60_CODCD)+'</IdDistributionCenterERP>'
		cXML += '<IdCompanyERP>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</IdCompanyERP>'
		cXML += '</DistributionCenterXCompanyType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:ImportDistributionCenterXCompany()
			cRetXML := oObj:cImportDistributionCenterXCompanyResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)
                                                       
Return                                                 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJIDSB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExporta็ใo de dados de centros de distribui็ใo x clientes   บฑฑ
ฑฑบTabela    ณZ60-Centro Distribui็ใo-Z62-Transportadores                 บฑฑ
ฑฑบMetodo    ณImportDistributionCenterXShippingMethod                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJIDSB2B(lEXPORTALL)
Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJIDSB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% Z60.Z60_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf

	BeginSql Alias cAliasTMP
		SELECT		Z60.Z60_CODCD, SA2.A2_CGC
		FROM 		%Table:Z60% Z60, %Table:Z62% Z62, %Table:SA2% SA2
		WHERE 		Z60.Z60_CODCD = Z62.Z62_CODCD
		AND			Z62.Z62_CODFR = SA2.A2_COD
		AND			Z62.Z62_LOJFR = SA2.A2_LOJA
		AND			Z60.Z60_ATIVO = %Exp:'S'% 
		AND			SA2.A2_MSBLQL != %Exp:'1'%	
		AND			%Exp:cWHERESQL%
					Z60.%NotDel%
		AND			Z62.%NotDel%
		AND			SA2.%NotDel%
		ORDER BY	Z60.Z60_CODCD, SA2.A2_CGC
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	    
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<DistributionCenterXShippingMethodType>'
		cXML += '<IdDistributionCenterERP>'+ALLTRIM((cAliasTMP)->Z60_CODCD)+'</IdDistributionCenterERP>'
		cXML += '<NuShippingMethodCNPJ>'+ALLTRIM((cAliasTMP)->A2_CGC)+'</NuShippingMethodCNPJ>'
		cXML += '</DistributionCenterXShippingMethodType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:ImportDistributionCenterXShippingMethod()
			cRetXML := oObj:cImportDistributionCenterXShippingMethodResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)
                                                       
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJULCB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do limite de cr้dito de clientes.               บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณUpdateCompanyLimit                                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJULCB2B(lEXPORTALL, lUPDATEREC, cCNPJ)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJULCB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
                                         	
	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% SA1.A1_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	                         
	If cCNPJ != STRINGNULL
		cWHERESQL	:= "% SA1.A1_CGC = '"+cCNPJ+"' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_LC, SA1.A1_CGC
		FROM 		%Table:SA1% SA1  
		WHERE		SA1.A1_X_EB2B	= %Exp:'S'%
		AND			( SA1.A1_LC		!= SA1.A1_X_ULB2B 	OR 	SA1.A1_X_ULB2B = 0 )
		AND			%Exp:cWHERESQL%
			 		SA1.%NotDel%
		ORDER BY	SA1.A1_COD, SA1.A1_LOJA
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
		
		//--Campo: IdERP - C๓digo cliente
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A1_COD))==8,ALLTRIM((cAliasTMP)->A1_COD)+"."+(cAliasTMP)->A1_LOJA,ALLTRIM((cAliasTMP)->(A1_COD+A1_LOJA)))
		cCLIERP := ALLTRIM((cAliasTMP)->A1_CGC)
		nLIMITE := (cAliasTMP)->A1_LC * 100
		
		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<CompanyLimitType>'
		cXML += '<IdERP>'+cCLIERP+'</IdERP>'
		cXML += '<VlAccountLimit>'+cValToChar(nLIMITE)+'</VlAccountLimit>'
		cXML += '</CompanyLimitType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:UpdateCompanyLimit()
			cRetXML := oObj:cUpdateCompanyLimitResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())


	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "SA1CMP"
		cFIELDUPD := "A1_X_ULB2B = A1_LC"
		cWHEREUPD := "A1_X_EB2B = 'S' AND A1_X_ULB2B != A1_LC"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf

	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJUSCB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do status de clientes.                          บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณUpdateCompanyStatus                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJUSCB2B(lEXPORTALL, lUPDATEREC)

Local cAliasTMP	:= GetNextAlias()
Local cWHERESQL	:= "%%"
Local cFILELOG	:= "RJUSCB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	

	//--Controle sobre exporta็ใo dos registros.
	If ! lEXPORTALL
		cWHERESQL	:= "% SA1.A1_X_AB2B = 'S' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, SA1.A1_X_SB2B
		FROM 		%Table:SA1% SA1  
		WHERE		SA1.A1_X_EB2B  = %Exp:'S'%
		AND			%Exp:cWHERESQL%
			 		SA1.%NotDel%
		ORDER BY	SA1.A1_COD, SA1.A1_LOJA
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	

	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		//--Campo: IdERP - C๓digo cliente
		//cCLIERP := IIF(LEN(ALLTRIM((cAliasTMP)->A1_COD))==8,ALLTRIM((cAliasTMP)->A1_COD)+"."+(cAliasTMP)->A1_LOJA,ALLTRIM((cAliasTMP)->(A1_COD+A1_LOJA)))
		cCLIERP := ALLTRIM((cAliasTMP)->A1_CGC)
		
		//--Campo: IdCompanyStatus = Status da empresa
		cSTATUS := IIF(ALLTRIM((cAliasTMP)->A1_X_SB2B)==STRINGNULL,"4",ALLTRIM((cAliasTMP)->A1_X_SB2B))

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<CompanyStatusType>' 
		cXML += '<DsCNPJ>'+ALLTRIM((cAliasTMP)->A1_CGC)+'</DsCNPJ>'
		cXML += '<IdERP>'+cCLIERP+'</IdERP>'
		cXML += '<IdCompanyStatus>'+cSTATUS+'</IdCompanyStatus>'
		cXML += '<DsMailText></DsMailText>'
		cXML += '</CompanyStatusType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml 	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:UpdateCompanyStatus()
			cRetXML := oObj:cUpdateCompanyStatusResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      

		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1

			//--Envio do metodo UpdateCompanyLimit para este cliente.
			U_RJULCB2B(lEXPORTALL, lUPDATEREC, (cAliasTMP)->A1_CGC)
	
			//--Envio do metodo ImportDistributionCenterXCompany para este cliente.
			U_RJIDCB2B(lEXPORTALL, (cAliasTMP)->A1_CGC)
	
			(cAliasTMP)->(dbSkip())    
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	

	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "SA1CMP"
		cFIELDUPD := "A1_X_AB2B = 'N', A1_X_PEB2B='S'"                   
		cWHEREUPD := "A1_X_EB2B = 'S' AND A1_X_AB2B = 'S'" 
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf


	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJUCSB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do status de sincronismo de clientes.           บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณUpdateCompanySync                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJUCSB2B(cCNPJCLI)

Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJUCSB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	
	BeginSql Alias cAliasTMP
		SELECT		COUNT(*) NUMREC
		FROM 		%Table:SA1% SA1  
		WHERE		SA1.A1_CGC	= %Exp:cCNPJCLI%
		AND 		SA1.%NotDel%
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<CompanySyncType>'
		cXML += '<DsCNPJ>'+cCNPJCLI+'</DsCNPJ>'
		If (cAliasTMP)->NUMREC > 0            
			cXML += '<FgSync>false</FgSync>'
		Else
			cXML += '<FgSync>true</FgSync>'
		EndIf
		cXML += '</CompanySyncType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml 	:= cXML	
		cRETWEBS1 := STRINGNULL

		If oObj:UpdateCompanySync()
			cRetXML := oObj:cUpdateCompanySyncResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJUSPB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do status do pedido de venda.                   บฑฑ
ฑฑบTabela    ณSC5-Cabe็alho do pedido de venda.                           บฑฑ
ฑฑบMetodo    ณUpdateOrderStatus                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJUSPB2B(lUPDATEREC,cFILPED,cNUMPED)

Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJUSPB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cWHERESQL	:= "%%"
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL
	
	If !Empty(cFILPED) .and. !Empty(cNUMPED)
		cWHERESQL	:= "% SC5.C5_FILIAL = '"+cFILPED+"' AND SC5.C5_NUM = '"+cNUMPED+"' AND %"
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cWHERESQL)
	EndIf
	
	BeginSql Alias cAliasTMP
		SELECT		SC5.C5_NUM, SC5.C5_X_PB2B, SC5.C5_X_SB2B 
		FROM 		%Table:SC5% SC5  
		WHERE		SC5.C5_X_IB2B		= %Exp:'S'%
		AND			SC5.C5_X_SB2B		!= SC5.C5_X_USB2B
		AND			%Exp:cWHERESQL%
			 		SC5.%NotDel%
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<OrderStatusType>'
		cXML += '<IdOrder>'+ALLTRIM((cAliasTMP)->C5_X_PB2B)+'</IdOrder>'
		cXML += '<IdOrderStatus>'+ALLTRIM((cAliasTMP)->C5_X_SB2B)+'</IdOrderStatus>'
		cXML += '<DsMailText>'+ALLTRIM((cAliasTMP)->C5_NUM)+'</DsMailText>'
		cXML += '<NuCodeCrawling>'+ALLTRIM((cAliasTMP)->C5_NUM)+'</NuCodeCrawling>'
		cXML += '</OrderStatusType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:UpdateOrderStatus()
			cRetXML := oObj:cUpdateOrderStatusResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	

	//--Chamada da fun็ใo para atualiza็ใo de flag de exporta็ใo de registros.
	If lUPDATEREC
		cTABLEUPD := "SC5020"	//--Verificar questใo do CD
		cFIELDUPD := "C5_X_USB2B = C5_X_SB2B"
		cWHEREUPD := "C5_X_IB2B = 'S' AND C5_X_USB2B != C5_X_SB2B"
		cINNERUPD := STRINGNULL
		cERRORUPD := STRINGNULL
		If !fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,@cERRORUPD)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERRORUPD)
		Else
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"UPDATE REALIZADO COM SUCESSO.")
		EndIf
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"UPDATE NAO EXECUTADO.")
	EndIf


	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJUOSB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do status de sincronismo de pedido de venda.    บฑฑ
ฑฑบTabela    ณSC5-Cabe็alho de pedido de venda.                           บฑฑ
ฑฑบMetodo    ณUpdateOrderSync                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJUOSB2B(cNUMPED)

Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJUOSB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL    

	/*
	BeginSql Alias cAliasTMP
		SELECT		COUNT(*) NUMREC
		FROM 		%Table:SC5% SC5  
		WHERE		SC5.C5_X_IB2B	= %Exp:'S'%
		AND			SC5.C5_X_PB2B	= %Exp:cNUMPED%
		AND 		SC5.%NotDel%
	EndSql
	*/

	BeginSql Alias cAliasTMP
		SELECT		COUNT(*) NUMREC
		FROM 		%Table:Z51% Z51
		WHERE		Z51.Z51_FILIAL	= %xFilial:Z51%
		AND			Z51.Z51_NUMB2B	= %Exp:cNUMPED%
		AND 		Z51.%NotDel%
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())

		cXML := '<?xml version="1.0" encoding="utf-8"?>'
		cXML += '<OrderSyncType>'
		cXML += '<IdOrder>'+cNUMPED+'</IdOrder>'
		If (cAliasTMP)->NUMREC > 0
			cXML += '<FgSync>false</FgSync>'
		Else
			cXML += '<FgSync>true</FgSync>'
		EndIf
		cXML += '</OrderSyncType>'
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cXML)

		oObj := WSVCommString():New()
		oObj:csessionId	:= CSESSIONID
		oObj:ctypeXml	:= cXML	   
		cRETWEBS1 := STRINGNULL

		If oObj:UpdateOrderSync()
			cRetXML := oObj:cUpdateOrderSyncResult
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cRetXML)
		Else
			//--Escreve no arquivo de log.                         
			cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
			cRETWEBS1 := GetWscError(1)
			cRETWEBS3 := GetWscError(3)
			If cRETWEBS1 != nil
				cERRO += cRETWEBS1
			EndIf
			If cRETWEBS3 != nil
				cERRO += cRETWEBS3
			EndIf
			U_RJB2BWFL(hFILELOG,cERRO)		
		EndIf      
		 
		//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.
		If ! "WSCERR044" $ cRETWEBS1
			(cAliasTMP)->(dbSkip())
		EndIf
		
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJUSEB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo do estoque de produtos.                         บฑฑ
ฑฑบTabela    ณSB2-Saldo em estoque.                                       บฑฑ
ฑฑบMetodo    ณUpdateProductSkuInventory                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJUSEB2B()

Local cAliasTMP	:= GetNextAlias()
Local cAliasZ60	:= GetNextAlias()
Local cFILELOG	:= "RJUSEB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.
Local cRETWEBS1 := STRINGNULL
Local cRETWEBS3 := STRINGNULL    

	BeginSql Alias cAliasTMP
		SELECT		SB1.B1_COD  
		FROM 		%Table:SB1% SB1
		WHERE 		SB1.B1_X_EB2B = %Exp:'S'%
		AND 		SB1.%NotDel%
		ORDER BY	SB1.B1_COD
	EndSql
	//--Escreve no arquivo de log.
	U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
                                             
	    //--Verifica se existe departamento relacionado ao produto                                      
		cIDEPTMAIN := STRINGNULL
		If U_RJCHKDEP((cAliasTMP)->B1_COD, @cIDEPTMAIN)

			//--Centros de distribui็ใo	
			BeginSql Alias cAliasZ60
				SELECT		Z60.Z60_CODEM, Z60.Z60_CODFL, Z60.Z60_CODCD
				FROM 		%Table:Z60% Z60
				WHERE 		Z60.Z60_ATIVO = %Exp:'S'%
				AND			Z60.%NotDel%
				ORDER BY	Z60.Z60_CODEM, Z60.Z60_CODFL
			EndSql
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,GetLastQuery()[2])
			
			dbSelectArea(cAliasZ60)
			(cAliasZ60)->(dbGoTop())
			While !(cAliasZ60)->(EOF())
	
		      	cTABSB2 := "% SB2"+(cAliasZ60)->Z60_CODEM+"0 %"
		      	cCODFIL := "% '"+(cAliasZ60)->Z60_CODFL+"' %"
		      	cCODPRD := "% '"+(cAliasTMP)->B1_COD+"' %"
		
				//--Campo: NuLocalInventory = Saldo em estoque
				nQTDVEN := U_RJESTB2B(cCODPRD, cCODFIL, cTABSB2)
				
				//--Adiciona a qtde em estoque do CD 1001 para todos os demais CDs menos nordeste.
				If (cAliasZ60)->Z60_CODCD != "1001" .and. (cAliasZ60)->Z60_CODCD != "0203"        
			      	cTAB1001 := "% SB2100 %"
			      	cFIL1001 := "% '01' %"
					nQTD1001 := U_RJESTB2B(cCODPRD, cFIL1001, cTAB1001)
					nQTDVEN += nQTD1001	
				EndIf
			               
				nQTDVEN := cValToChar(nQTDVEN)
				
				cXML := '<?xml version="1.0" encoding="utf-8"?>'
				cXML += '<ProductSkuInventoryType>'
				cXML += '<IdProductSku>'+ALLTRIM((cAliasTMP)->B1_COD)+'</IdProductSku>'
				cXML += '<NuLocalInventory>'+nQTDVEN+'</NuLocalInventory>'
				cXML += '<IdDistributionCenterERP>'+ALLTRIM((cAliasZ60)->Z60_CODCD)+'</IdDistributionCenterERP>'
				cXML += '</ProductSkuInventoryType>'
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cXML)
		
				oObj := WSVCommString():New()
				oObj:csessionId	:= CSESSIONID
				oObj:ctypeXml	:= cXML	   
				cRETWEBS1 := STRINGNULL
		
				If oObj:UpdateProductSkuInventory()
					cRetXML := oObj:cUpdateProductSkuInventoryResult
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cRetXML)
				Else
					//--Escreve no arquivo de log.                         
					cERRO := "ERRO NO PROCESSAMENTO DO MษTODO."
					cRETWEBS1 := GetWscError(1)
					cRETWEBS3 := GetWscError(3)
					If cRETWEBS1 != nil
						cERRO += cRETWEBS1
					EndIf
					If cRETWEBS3 != nil
						cERRO += cRETWEBS3
					EndIf
					U_RJB2BWFL(hFILELOG,cERRO)		
				EndIf  
				 
				//--Controle sobre erro de comunica็ใo com webservices, caso ocorrer erro realiza o envio do mesmo registro novamente.          
				If ! "WSCERR044" $ cRETWEBS1
					(cAliasZ60)->(dbSkip())			
				EndIf
				
			Enddo
			(cAliasZ60)->(dbCloseArea())
	   
		Else 
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,ALLTRIM((cAliasTMP)->B1_COD)+" - PRODUTO SEM DEPARTAMENTO.")
		EndIf		
		
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJCHKDEP    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณVerifica se existe departamento pai para o produto.         บฑฑ
ฑฑบTabela    ณZ65-Departamentos x Produtos.                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJCHKDEP(cCODPRD,cIDEPTO)

Local cAliasDEP	:= GetNextAlias()
Local lRet	:= .T.

	cIDEPTO	:= STRINGNULL
    //--Departamento relacionado ao produto
	BeginSql Alias cAliasDEP
		SELECT		Z65.Z65_CODDEP
		FROM 		%Table:Z65% Z65, %Table:SB1% SB1		
		WHERE		Z65.Z65_CODPRD	= SB1.B1_COD
		AND 		Z65.Z65_DEPPAI	= %Exp:'S'%
		AND 		SB1.B1_X_EB2B	= %Exp:'S'%		
		AND 		SB1.B1_COD		= %Exp:cCODPRD%
		AND			Z65.%NotDel%
		AND 		SB1.%NotDel%
		ORDER BY	Z65.Z65_CODDEP
	EndSql
	                                     
	conout(GetLastQuery()[2])
	
	dbSelectArea(cAliasDEP)
	(cAliasDEP)->(dbGoTop())
	If !(cAliasDEP)->(EOF())
		cIDEPTO := ALLTRIM((cAliasDEP)->Z65_CODDEP)
	EndIf         
	(cAliasDEP)->(dbCloseArea())
    
	If cIDEPTO == STRINGNULL
		lRet := .F.
	EndIf

Return (lRet)
		



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJICLB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณImporta็ใo de clientes atrav้s do B2B Vertis.               บฑฑ
ฑฑบTabela    ณSA1-Cadastro de clientes.                                   บฑฑ
ฑฑบMetodo    ณExportCompany                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJICLB2B()

Local cRetXML	:= STRINGNULL	
Local aDADOSTMP	:= {}
Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJICLB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.

Private lMsErroAuto := .F.           

/** VARIAVEIS DE GATILHOS DO A1_CGC **/
Private CTPMT	:= ""
Private LINTFIN	:= .F.                 
/** VARIAVEIS DE GATILHOS DO A1_CGC **/

	
	//--Chamada do m้todo de exporta็ใo de clientes.
	oObj := WSVCommString():New()
	oObj:csessionId	:= CSESSIONID

	If oObj:ExportCompany()
		cRetXML := oObj:cExportCompanyResult
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cRetXML)
	Else
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,"MษTODO SEM NENHUM RETORNO.")
	EndIf

	//--Processamento dos registros de clientes.
	If cRetXML != STRINGNULL		
		cERROR		:= STRINGNULL
		cWARNING	:= STRINGNULL
		
		oXML := XmlParser( EncodeUtf8(cRetXML), "_", @cERROR, @cWARNING )
		If ! Empty(cERROR)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERROR)
			//--Encerra arquivo de log.
			U_RJB2BEFL(hFILELOG)
			Return .F.
		EndIf
		If ! Empty(cWARNING)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cWARNING)
			//--Encerra arquivo de log.
			U_RJB2BEFL(hFILELOG)
			Return .F.
		EndIf
		If ValType(oXML) != "O" 
			cTEXTO := "Arquivo cabecalho invแlido."
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cTEXTO)
			//--Encerra arquivo de log.
			U_RJB2BEFL(hFILELOG)
			Return .F.
		EndIf
				
		//--Verifica estrutura do texto XML
		aObj_Xml := ClassDataArr(oXML)
		If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_COMPANYTYPERESPONSE" }) > 0
			aObj_Xml := ClassDataArr(oXML:_COMPANYTYPERESPONSE)
			If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_RESULTCOLLECTION" }) > 0
				aObj_Xml := ClassDataArr(oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION)
				If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ANYTYPE" }) > 0    
				
				    //--Verifica n๚mero de registros
				    If ValType(oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)!="O"
						nMAXSA1 := Len(oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)
						lMAXSA1 := .T.
					Else
						nMAXSA1 := 1
						lMAXSA1 := .F.
					EndIf
					
					For nINDSA1 := 1 to nMAXSA1
						
						//--CNPJ								
						cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSCNPJ:TEXT"
						If type(cCPOXML)!="U"
							cCNPJCLI := &(cCPOXML)
							aAdd ( aDADOSTMP, { cCNPJCLI, STRINGNULL, {} } )
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_CGC", 			cCNPJCLI, 						NIL } )
							
							//--C๓digo da empresa no site                                                                                           
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_IDCOMPANYSITE:TEXT"
							If type(cCPOXML)!="U"
								aDADOSTMP[Len(aDADOSTMP)][02] := &(cCPOXML)
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_CCB2B", 	ALLTRIM(&(cCPOXML)), 			NIL } )
							EndIf
							
							//--Razใo social
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSLEGALNAME:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_NOME", 		UPPER(ALLTRIM(&(cCPOXML))), 	NIL } )
							EndIf

							//--Nome fantasia                                                                                                         
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSDBANAME:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_NREDUZ", 	UPPER(ALLTRIM(&(cCPOXML))), 	NIL } )
							EndIf
							
							//--E-mail do responsแvel                                                                                               
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSRESPONSIBLEEMAIL:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_EMAIL", 	UPPER(ALLTRIM(&(cCPOXML))), 	NIL } )
							EndIf

							//--Nome do responsแvel                                                                                                          
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSRESPONSIBLENAME:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_CONTATO", 	UPPER(ALLTRIM(&(cCPOXML))), 	NIL } )
							EndIf

							//--Inscri็ใo estadual                                                                                                          
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_DSIE:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_INSCR", 	UPPER(ALLTRIM(&(cCPOXML))), 	NIL } )
							EndIf

							//--DDD
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_NUPHONEDDD:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_DDD", 		ALLTRIM(&(cCPOXML)), 			NIL } )
							EndIf

							//--Telefone                                                                                                       
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_NUPHONE:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_TEL", 		ALLTRIM(&(cCPOXML)), 			NIL } )
							EndIf

							//--Limite de cr้dito                                                                                              
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_VLACCOUNTLIMIT:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_LC", 		VAL(&(cCPOXML)), 				NIL } )
							EndIf

							//--Tipo Revendedor                                                                                            
							cCPOXML := "oXML:_COMPANYTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nINDSA1]",STRINGNULL)+":_IDOPERATIONTYPE:TEXT"
							If type(cCPOXML)!="U"
								cTIPOCLI := ALLTRIM(&(cCPOXML))
								If cTIPOCLI == "1"
									cTIPOCLI := "F"	//--Consumidor Final
								Else
									cTIPOCLI := "R"	//--Revendedor
								EndIf
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_TIPO", 	cTIPOCLI	, NIL } )
							Else
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_TIPO", 	"R"			, NIL } )
							EndIf

		
							//--Inclusใo do cliente como bloqueado.
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_MSBLQL", 	"1"		, NIL } )

							//--Pessoa Juridica
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_PESSOA", 	"J"		, NIL } )
						
						
							//--Envia Serasa = Nใo
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_SERAS", 	"N"		, NIL } )

							//--Pais Cliente
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_PAIS", 		"105"	, NIL } )

							//--Pais Bacen 
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_CODPAIS", 	"01058"	, NIL } )

							//--Envia Serasa
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_SERAS", 	"S"		, NIL } )

							//--Exporta B2B
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_EB2B", 	"S"		, NIL } )

							//--Status B2B
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_SB2B", 	"1"		, NIL } )

							//--Controle Envio B2B
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_X_PEB2B", 	"S"		, NIL } )

							//--C๓digo Cliente
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_COD", 		SUBSTR(cCNPJCLI,1,8), 	NIL } )

							//--Loja Cliente
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "A1_LOJA", 		SUBSTR(cCNPJCLI,9,4), 	NIL } )

						EndIf
					Next nINDSA1
				EndIf						
			EndIf	
		EndIf
	Else
		cTEXTO := "Nใo foi retornado resultado do m้todo ExportCompany."
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cTEXTO)
	EndIf

	
	//--Processamento dos registros de endere็os de clientes.
	If Len(aDADOSTMP) > 0

		For nINDSA1 := 1 to Len(aDADOSTMP)

			nPOSIDC := aScan ( aDADOSTMP[nINDSA1,03], { |x| x[1] == "A1_X_CCB2B" } )
			If nPOSIDC == 0
				cTEXTO := "Nใo foi encontrato conte๚do IDCompanySite, registro: "+cValToChar(nINDSA1)
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cTEXTO)
				Exit
			EndIf 
		
			//--Leitura dos registros de endere็os de clientes.
			cRetXML := STRINGNULL
			oObj := WSVCommString():New()
			oObj:csessionId	:= CSESSIONID
			oObj:nidCompanySite	:= Val(aDADOSTMP[nINDSA1,03][nPOSIDC,02])
		
			If oObj:ExportCompanyAddress()
				cRetXML := oObj:cExportCompanyAddressResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			EndIf
					
		
			If cRetXML != STRINGNULL 
		
				cERROR		:= STRINGNULL
				cWARNING	:= STRINGNULL
				
				oXML := XmlParser( EncodeUtf8(cRetXML), "_", @cERROR, @cWARNING )
				If ! Empty(cERROR)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cERROR)
					//--Encerra arquivo de log.
					U_RJB2BEFL(hFILELOG)
					Exit
				EndIf
				If ! Empty(cWARNING)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cWARNING)
					//--Encerra arquivo de log.
					U_RJB2BEFL(hFILELOG)
					Exit
				EndIf
				If ValType(oXML) != "O" 
					cTEXTO := "Arquivo de endere็os invแlido."
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cTEXTO)
					//--Encerra arquivo de log.
					U_RJB2BEFL(hFILELOG)			
					Exit
				EndIf
					
				//--Verifica estrutura do texto XML
				aObj_Xml := ClassDataArr(oXML)
				If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_COMPANYADDRESSTYPERESPONSE" }) > 0
					aObj_Xml := ClassDataArr(oXML:_COMPANYADDRESSTYPERESPONSE)
					If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_RESULTCOLLECTION" }) > 0
						aObj_Xml := ClassDataArr(oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ANYTYPE" }) > 0    

						    //--Verifica n๚mero de registros
						    If ValType(oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)!="O"
								nMAXSA1 := Len(oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)
								lMAXSA1 := .T.
							Else
								nMAXSA1 := 1
								lMAXSA1 := .F.
							EndIf
							
							For nENDSA1 := 1 to nMAXSA1
								
								//--Tipo de endere็o
								cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_IDCOMPANYADDRESSTYPE:TEXT"
								If type(cCPOXML)!="U"
									cTIPOEND := ALLTRIM(&(cCPOXML))
									//--1=Endere็o Principal
									If cTIPOEND == "1"	

										//--Endere็o                                                                                                                      
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSADDRESS:TEXT"
										If type(cCPOXML)!="U"
											cEND := UPPER(ALLTRIM(&(cCPOXML)))

											//--N๚mero                                                                                                                            
											cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSNUMBER:TEXT"
											If type(cCPOXML)!="U"
												cEND += ", " + ALLTRIM(&(cCPOXML))
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_END", cEND, NIL } )
											Else
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_END", cEND, NIL } )
											EndIf
										EndIf

										//--Complemento                                                                                                                               
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSCOMPLEMENT:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_COMPLEM", 			UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
										EndIf			

										//--CEP                                                                                                                                   
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_NUZIP:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_CEP", 				UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
										EndIf			

										//--Cidade                                                                                                                                
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSCITY:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_MUN", 				UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_MUNCAD", 			UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
										EndIf			

										//--Bairro                                                                                                                                
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSDISTRICT:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_BAIRRO", 			UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
										EndIf			

										//--Estado                                                                                                                                
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_IDSTATE:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_EST", 				UPPER(ALLTRIM(&(cCPOXML))), 			NIL } )
										EndIf			

										//--C๓digo IBGE                                                                                                                           
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_IDCITY:TEXT"
										If type(cCPOXML)!="U"
											aAdd ( aDADOSTMP[nINDSA1][03], { "A1_COD_MUN", 			SubSTR(ALLTRIM(&(cCPOXML)),3,5), 		NIL } )
										EndIf			

									
									//--2=Endere็o de cobran็a
									ElseIf  cTIPOEND == "2"

										//--Endere็o                                                                                                                              
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSADDRESS:TEXT"
										If type(cCPOXML)!="U"
											cEND := UPPER(ALLTRIM(&(cCPOXML)))

											//--N๚mero                                                                                                                            
											cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSNUMBER:TEXT"
											If type(cCPOXML)!="U"
												cEND += ", " + ALLTRIM(&(cCPOXML))
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_ENDCOB", cEND, NIL } )
											Else
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_ENDCOB", cEND, NIL } )
											EndIf
										EndIf
									
									//--3=Endere็o de entrega
									Else

										//--Endere็o                                                                                                                                  
										cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSADDRESS:TEXT"
										If type(cCPOXML)!="U"
											cEND := UPPER(ALLTRIM(&(cCPOXML)))

											//--N๚mero                                                                                                                            
											cCPOXML := "oXML:_COMPANYADDRESSTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSA1,"[nENDSA1]",STRINGNULL)+":_DSNUMBER:TEXT"
											If type(cCPOXML)!="U"
												cEND += "," + ALLTRIM(&(cCPOXML))
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_ENDENT", cEND, NIL } )
											Else
												aAdd ( aDADOSTMP[nINDSA1][03], { "A1_ENDENT", cEND, NIL } )
											EndIf
										EndIf
									
									EndIf
								EndIf
							Next nENDSA1
						EndIf						
					EndIf	
				EndIf
			EndIf	
		Next nINDSA1
	Else
		cTEXTO := "Nใo foi retornado resultado do m้todo ExportCompanyAddress."
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cTEXTO)		
	EndIf
	
	//--Execauto de inclusใo de clientes
	If cRetXML != STRINGNULL .and. Len(aDADOSTMP) > 0
		For nINCSA1 := 1 to Len(aDADOSTMP)
			cCODCLI := SUBSTR(aDADOSTMP[nINCSA1][01],1,8)+Space(1)+SUBSTR(aDADOSTMP[nINCSA1][01],9,4)
			aTmpSA1	:= aClone( aDADOSTMP[nINCSA1][03] )
			aTmpSA1 := FWVetByDic(aTmpSA1,"SA1")
			cCNPJCLI := aTmpSA1[aScan(aTmpSA1,{|x| x[1]=="A1_CGC"}), 2]
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,"MATA030-INCLUSรO DE CLIENTE: "+cCODCLI)
			lMsErroAuto := .F.
			dbSelectArea("SA1")
			dbSetOrder(1)			
			If !dbSeek(xFilial("SA1")+cCODCLI)				
				aAreaTMP := GetArea()   
				nModulo := 5 //--Faturamento
				MsExecAuto({|x,y| MATA030(x,y)}, aTmpSA1, 3)
				//--Resultado execauto
				If lMsErroAuto
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,MOSTRAERRO())
				Else					
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,"CLIENTE INCLUอDO COM SUCESSO-"+cCODCLI)
					//--Atualiza status de sincronismo
					U_RJUCSB2B(cCNPJCLI)
				EndIf				
				RestArea(aAreaTMP)
			Else
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,"CLIENTE Jม EXISTENTE-"+cCODCLI)
				If RecLock("SA1",.F.)
					SA1->A1_X_SB2B := "1"
					SA1->(MsUnLock())
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,"ALTERADO CONTEUDO DO CAMPO STATUS B2B (A1_X_SB2B) PARA 1=AGUARDANDO APROVACAO.")
				EndIf
				//--Atualiza status de sincronismo
				U_RJUCSB2B(cCNPJCLI)
			EndIf
		Next nINCSA1
	EndIf
	
	
	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJIPVB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณImporta็ใo de pedidos de venda atrav้s do B2B Vertis.       บฑฑ
ฑฑบTabela    ณSC5/SC6-Pedidos de venda.                                   บฑฑ
ฑฑบMetodo    ณExportOrder                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJIPVB2B()

Local aDADOSTMP	:= {}
Local cAliasTMP	:= GetNextAlias()
Local cFILELOG	:= "RJIPVB2B_"+DTOS(ddatabase)+"_"+STRTRAN(TIME(),":","")
Local hFILELOG	:= U_RJB2BCFL(cFILELOG)	//--Inicializa arquivo de log.

Private lMsErroAuto := .F. 
	
	
	//--Chamada do m้todo de exporta็ใo de pedidos.
	oObj := WSVCommString():New()
	oObj:csessionId	:= CSESSIONID


	If oObj:ExportOrder()
		cRetXML := oObj:cExportOrderResult
		//--Escreve no arquivo de log.
		U_RJB2BWFL(hFILELOG,cRetXML)
	EndIf
	
	
	//--Processamento dos registros de pedidos.
	If cRetXML != STRINGNULL		
		cERROR		:= STRINGNULL
		cWARNING	:= STRINGNULL
		
		oXML := XmlParser( EncodeUtf8(cRetXML), "_", @cERROR, @cWARNING )
		If ! Empty(cERROR)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cERROR)
			Return .F.
		EndIf
		If ! Empty(cWARNING)
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cWARNING)
			Return .F.
		EndIf
		If ValType(oXML) != "O" 
			cTEXTO := "Arquivo cabecalho invแlido."
			//--Escreve no arquivo de log.
			U_RJB2BWFL(hFILELOG,cTEXTO)
			//--Encerra arquivo de log.
			U_RJB2BEFL(hFILELOG)
			Return .F.
		EndIf

		
		//--Verifica estrutura do texto XML
		aObj_Xml := ClassDataArr(oXML)
		If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ORDERTYPERESPONSE" }) > 0
			aObj_Xml := ClassDataArr(oXML:_ORDERTYPERESPONSE)
			If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_RESULTCOLLECTION" }) > 0
				aObj_Xml := ClassDataArr(oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION)
				If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ANYTYPE" }) > 0    

				    //--Verifica n๚mero de registros
				    If ValType(oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)!="O"
						nMAXSC5 := Len(oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)
						lMAXSC5 := .T.
					Else
						nMAXSC5 := 1
						lMAXSC5 := .F.
					EndIf

					For nINDSC5 := 1 to nMAXSC5
						
						//--C๓digo do pedido no site											
						cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDORDER:TEXT"
						If type(cCPOXML)!="U"
							
							cPEDB2B := &(cCPOXML)
							aAdd ( aDADOSTMP, { cPEDB2B, STRINGNULL, {}, {}, 0 } )
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_X_PB2B", 		cPEDB2B					, NIL } )
							
							//--Codigo CD - Empresa / Filial ERP                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDDISTRIBUTIONCENTERERP:TEXT"
							cEMPSC5 := STRINGNULL
							cFILSC5 := STRINGNULL
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "XX_CODCD",	ALLTRIM(&(cCPOXML))			, NIL } )
								cEMPSC5 := LEFT(ALLTRIM(&(cCPOXML)), 2 )
								cFILSC5 := RIGHT(ALLTRIM(&(cCPOXML)), 2 )
								aDADOSTMP[Len(aDADOSTMP)][02] := RIGHT(ALLTRIM(&(cCPOXML)), 2 )
							EndIf

							//--Tipo do Pedido                                                                                                    
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDORDERTYPE:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "XX_TIPO",	ALLTRIM(&(cCPOXML))			, NIL } )								
							EndIf
							

							//--Nome Transportador                                                                                                   
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_DSSHIPPINGMETHOD:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "XX_NOMTRP",	ALLTRIM(&(cCPOXML))			, NIL } )
							EndIf


							//--Data de realiza็ใo do pedido
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_DTORDER:TEXT"
							If type(cCPOXML)!="U"
								dEMISSAO := STOD(STRTRAN(SubSTR(&(cCPOXML),1,10),"-",""))
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_EMISSAO", 	dEMISSAO				, NIL } )
							EndIf
							
							//--Status do pedido                                                                                                
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDORDERSTATUS:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_X_SB2B", 	ALLTRIM(&(cCPOXML))		, NIL } )
							EndIf

							//--Condi็ใo de pagamento                                                                                           
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDBILLETCHECKPAYTIME:TEXT"
							If type(cCPOXML)!="U"
								cCODPAGTO := "001"
								If aScan ( aDADOSTMP[Len(aDADOSTMP)][03], {|x| x[1] == "C5_CONDPAG" } ) == 0
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_CONDPAG",	cCODPAGTO			, NIL } )
								EndIf
							EndIf

							//--Data Entrega                                                                                                    
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_DTDELIVERYDAY:TEXT"
							If type(cCPOXML)!="U"
								cOBSPED := STRTRAN(SubSTR(&(cCPOXML),1,10),"-","")
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_OBSPED", 	cOBSPED					, NIL } )
							EndIf

							//--Valor Frete                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_VLTOTALSHIPPINGCOST:TEXT"
							nVLRFRT := 0
							nDESFRT := 0
							If type(cCPOXML)!="U"                                       
								nVALCPO := 0
								If VAL(&(cCPOXML)) > 0
									nVALCPO := VAL(&(cCPOXML))/100
									nVLRFRT := nVALCPO
								EndIf
							EndIf
							
							//--Valor Desconto Frete                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_VLSHIPCOSTDISCOUNT:TEXT"
							If type(cCPOXML)!="U"                                       
								nVALCPO := 0
								If VAL(&(cCPOXML)) > 0
									nVALCPO := VAL(&(cCPOXML))/100
									nDESFRT := nVALCPO
								EndIf
							EndIf
							
							If nVLRFRT > 0
								nVLRFRT := Round(nVLRFRT-nDESFRT, 2)
								If nVLRFRT > 0
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_FRETE", 	nVLRFRT					, NIL } )
								EndIf
							EndIf



							//--Tipo Frete                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_FGSHIPPINGTYPE:TEXT"
							If type(cCPOXML)!="U"
								If "CF" $ ALLTRIM(cCPOXML)
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_TPFRETE", 	ALLTRIM(cCPOXML)		, NIL } )
								EndIf
							EndIf


							//--Valor Pedido                                                                                                    
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_VLTOTALORDER:TEXT"
							If type(cCPOXML)!="U"                      
								nVALCPO := 0
								If VAL(&(cCPOXML)) > 0
									nVALCPO := VAL(&(cCPOXML))/100
								EndIf
								aDADOSTMP[Len(aDADOSTMP),05] := nVALCPO
							EndIf

							//--Observa็๕es                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_DSREMINDER:TEXT"
							If type(cCPOXML)!="U"
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_MENNOTA", 	ALLTRIM(&(cCPOXML))		, NIL } )
							EndIf

							//--Cliente ERP                                                                                                     
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDCOMPANYERP:TEXT"
							If type(cCPOXML)!="U"
								cCODCLI := SUBSTR(&(cCPOXML),01,08)+Space(01)
								cLOJCLI := SUBSTR(&(cCPOXML),09,04)
								dbSelectArea("SA1")
								dbSetOrder(1)
								If dbSeek(xFilial("SA1")+cCODCLI+cLOJCLI)
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_CLIENTE", cCODCLI, 		NIL } )
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_LOJACLI", cLOJCLI, 		NIL } )
									If !Empty(SA1->A1_COND)
										nPOSCPG := aScan ( aDADOSTMP[Len(aDADOSTMP)][03], {|x| x[1] == "C5_CONDPAG" } ) 
										If nPOSCPG != 0
											aDADOSTMP[Len(aDADOSTMP)][03][nPOSCPG][02] := SA1->A1_COND	
										Else
											aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_CONDPAG", SA1->A1_COND, NIL } )
										EndIf
									EndIf
									
								Else 
									cTEXTO := "Cliente do pedido nใo localizado. C๓digo: "+cCODCLI+" Loja: "+cLOJCLI
									//--Escreve no arquivo de log.
									U_RJB2BWFL(hFILELOG,cTEXTO)
								EndIf
							EndIf

							//--Vendedor                                                                                                        
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDSALESUSER:TEXT"
							If type(cCPOXML)!="U"
								cCODVEND := FGETZZ5(cCODCLI,cLOJCLI,cEMPSC5,cFILSC5)
								If cCODVEND == STRINGNULL 
									cCODVEND := "V00052"
								EndIf
								aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_VEND1", 	cCODVEND				, NIL } )
							EndIf
                                              

							//--Forma de pagamento = A vista                                                                                                       
							cCPOXML := "oXML:_ORDERTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC5,"[nINDSC5]",STRINGNULL)+":_IDPAYMENTMETHOD:TEXT"
							If type(cCPOXML)!="U"
								If ALLTRIM(cCPOXML) == "14"
									aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_X_STATU", 	"1"					, NIL } )
								EndIf
							EndIf


							//--Importado B2B Vertis
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_X_IB2B", 	"S", 				NIL } )
							
							//--Tipo Pedido
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_TIPO", 		"N", 				NIL } )

							//--Tipo Venda
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "C5_TPVENDA", 	"N", 				NIL } )

							//--Dados de pagamento em cartใo
							aAdd ( aDADOSTMP[Len(aDADOSTMP)][03], { "XX_CONDPC", 	{}, 				NIL } )


						EndIf
					
					Next nINDSC5
				EndIf						
			EndIf	
		EndIf
	EndIf

	
	//--Processamento dos pagamentos em cartใo por pedido.
	If Len(aDADOSTMP) > 0
		For nINDSC5 := 1 to Len(aDADOSTMP)

			cRetXML := STRINGNULL
			oObj:csessionId	:= CSESSIONID
			oObj:nidOrder := Val(aDADOSTMP[nINDSC5][01])
	
			If oObj:ExportOrderPaymentAuthorization()
				cRetXML := oObj:cExportOrderPaymentAuthorizationResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			EndIf
		
			If cRetXML != STRINGNULL
				
				cERROR		:= STRINGNULL
				cWARNING	:= STRINGNULL
				
				oXML := XmlParser( EncodeUtf8(cRetXML), "_", @cERROR, @cWARNING )
				If ! Empty(cERROR)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cERROR)
					Exit
				EndIf
				If ! Empty(cWARNING)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cWARNING)
					Exit
				EndIf
				If ValType(oXML) != "O" 
					cTEXTO := "Arquivo de pagamentos invแlido."
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cTEXTO)
					//--Encerra arquivo de log.
					U_RJB2BEFL(hFILELOG)
					Exit
				EndIf					                                  

				//--Verifica estrutura do texto XML
				aObj_Xml := ClassDataArr(oXML)
				If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE" }) > 0
					aObj_Xml := ClassDataArr(oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE)
					If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_RESULTCOLLECTION" }) > 0
						aObj_Xml := ClassDataArr(oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ANYTYPE" }) > 0    

						    //--Verifica n๚mero de registros
						    If ValType(oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)!="O"
								nMAXPAR := Len(oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)
								lMAXPAR := .T.
							Else
								nMAXPAR := 1
								lMAXPAR := .F.
							EndIf

							nPOSPAR := aScan ( aDADOSTMP[nINDSC5][03], { |x| ALLTRIM(x[1]) == "XX_CONDPC" } )	
						
							For nINDPAR := 1 to nMAXPAR
							
								cCODNSU := STRINGNULL
								cAUTORI := STRINGNULL
								cMENSAG := STRINGNULL
								cREFTRANS := STRINGNULL
							
								//--C๓digo do NSU 
								cCPOXML := "oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXPAR,"[nINDPAR]",STRINGNULL)+":_DSNSU:TEXT"
								If type(cCPOXML)!="U"
									cCODNSU := ALLTRIM(&(cCPOXML))
								EndIf		
								
								//--Autoriza็ใo
								cCPOXML := "oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXPAR,"[nINDPAR]",STRINGNULL)+":_DSAUTHORIZATION:TEXT"
								If type(cCPOXML)!="U"
									cAUTORI := ALLTRIM(&(cCPOXML))  
								EndIf		

								//--Mensagem
								cCPOXML := "oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXPAR,"[nINDPAR]",STRINGNULL)+":_DSMESSAGE:TEXT"
								If type(cCPOXML)!="U"
									cMENSAG := ALLTRIM(&(cCPOXML)) 
								EndIf		   
								

								//--RefTrans - Nosso n๚mero boleto
								cCPOXML := "oXML:_ORDERPAYMENTAUTHORIZATIONTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXPAR,"[nINDPAR]",STRINGNULL)+":_REFTRANS:TEXT"
								If type(cCPOXML)!="U"
									cREFTRANS := ALLTRIM(&(cCPOXML)) 
								EndIf		   

								If nPOSPAR > 0
									aAdd ( aDADOSTMP[nINDSC5][03][nPOSPAR][2], { cCODNSU, cAUTORI, cMENSAG, cREFTRANS } )
								EndIf
							
							Next nINDPAR
							
						EndIf
					EndIf
				EndIf						
			EndIf	
		Next nINDSC5		
	EndIf


	//--Processamento dos itens de pedidos.
	If Len(aDADOSTMP) > 0
	
		For nINDSC5 := 1 to Len(aDADOSTMP)

			cRetXML := STRINGNULL
			oObj:csessionId	:= CSESSIONID
			oObj:nidOrder := Val(aDADOSTMP[nINDSC5][01])
	
			If oObj:ExportOrderItem()
				cRetXML := oObj:cExportOrderItemResult
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cRetXML)
			EndIf
		
			If cRetXML != STRINGNULL
				
				cERROR		:= STRINGNULL
				cWARNING	:= STRINGNULL
				
				oXML := XmlParser( EncodeUtf8(cRetXML), "_", @cERROR, @cWARNING )
				If ! Empty(cERROR)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cERROR)
					Exit
				EndIf
				If ! Empty(cWARNING)
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cWARNING)
					Exit
				EndIf
				If ValType(oXML) != "O" 
					cTEXTO := "Arquivo de itens invแlido."
					//--Escreve no arquivo de log.
					U_RJB2BWFL(hFILELOG,cTEXTO)
					//--Encerra arquivo de log.
					U_RJB2BEFL(hFILELOG)
					Exit
				EndIf					                                  
					
				//--Verifica estrutura do texto XML
				aObj_Xml := ClassDataArr(oXML)
				If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ORDERITEMTYPERESPONSE" }) > 0
					aObj_Xml := ClassDataArr(oXML:_ORDERITEMTYPERESPONSE)
					If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_RESULTCOLLECTION" }) > 0
						aObj_Xml := ClassDataArr(oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION)
						If Ascan(aObj_Xml,{|x| Upper(x[1]) == "_ANYTYPE" }) > 0    
							
						    //--Verifica n๚mero de registros
						    If ValType(oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)!="O"
								nMAXSC6 := Len(oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE)
								lMAXSC6 := .T.
							Else
								nMAXSC6 := 1
								lMAXSC6 := .F.
							EndIf  							
							cTABPRC := STRINGNULL
														
							For nINDSC6 := 1 to nMAXSC6
								aITENSC6 := {}
								
								//--Produto
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_IDPRODUCTSKU:TEXT"
								If type(cCPOXML)!="U"
									cCODPRD := ALLTRIM(&(cCPOXML))
									aAdd ( aITENSC6, { "C6_PRODUTO", 		cCODPRD	 					, NIL } )
									
									dbSelectArea("SB1")
									dbSetOrder(1)
									If !dbSeek(xFilial("SB1")+cCODPRD)
										cTEXTO := "Produto nใo localizado. C๓digo: "+cCODPRD
										//--Escreve no arquivo de log.
										U_RJB2BWFL(hFILELOG,cTEXTO)										
									EndIf
									
								EndIf		
								
								//--Descri็ใo                                                                                                                
								/*INICIO GUSTAVO 06/04/2015 - Utilizar a descri็ใo cadastrada no produto
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_DSPRODUCTNAME:TEXT"
								If type(cCPOXML)!="U"
									aAdd ( aITENSC6, { "C6_DESCRI", 		ALLTRIM(&(cCPOXML))			, NIL } )
								EndIf
								*/
								dbSelectArea("SB1")
								dbSetOrder(1)
								If dbSeek(xFilial("SB1")+cCODPRD)
									aAdd ( aITENSC6, { "C6_DESCRI", 		SB1->B1_DESC			, NIL } )	
								EndIf
								//FIM GUSTAVO 06/04/2015		
								
								//--Quantidade                                                                                                               
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_NUQTY:TEXT"
								If type(cCPOXML)!="U"
									nQTDVEN := VAL(&(cCPOXML))
									aAdd ( aITENSC6, { "C6_QTDVEN", 		nQTDVEN						, NIL } )
								EndIf		

								//--Pre็o de tabela                                                                                                          
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_VLORIGINALPRICE:TEXT"
								If type(cCPOXML)!="U"
									If ALLTRIM(&(cCPOXML)) == STRINGNULL
										nPRUNIT := 0
									Else
										nPRUNIT := VAL(ALLTRIM(&(cCPOXML)))/100
									EndIf
									aAdd ( aITENSC6, { "C6_PRUNIT", 		nPRUNIT						, NIL } )
								EndIf		

								//--Pre็o de venda                                                                                                           
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_VLSALEPRICE:TEXT"
								If type(cCPOXML)!="U"
									nPRCVEN := VAL(&(cCPOXML))/100

									//--Desconto Unitario
									nVLRDES := 0
									cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_VLORDERDISCOUNTUNITY:TEXT"
	        						If type(cCPOXML)!="U"
	        							nVLRDES := VAL(&(cCPOXML))/100	
                                    EndIf                         
                                    If nVLRDES > 0
                                    	nPRCVEN -= nVLRDES
                                    EndIf
									
									aAdd ( aITENSC6, { "C6_PRCVEN", 		nPRCVEN						, NIL} )
								EndIf		

								//--Tabela de preco
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_IDPRICETABLE:TEXT"
								If type(cCPOXML)!="U"
									cTABPRC := ALLTRIM(&(cCPOXML))	
								EndIf		

								//--ICMS Retido                                                                                                              
								cCPOXML := "oXML:_ORDERITEMTYPERESPONSE:_RESULTCOLLECTION:_ANYTYPE"+IIF(lMAXSC6,"[nINDSC6]",STRINGNULL)+":_VLTRIBUTARYSUBSTITUTION:TEXT"
								If type(cCPOXML)!="U"
									nICMRET := VAL(&(cCPOXML))/100
									aAdd ( aITENSC6, { "C6_ICMSRET", 		nICMRET						, NIL} )
								EndIf		

								//--Total do item                                                                                                            								
								aAdd ( aITENSC6, { "C6_VALOR", 			nPRCVEN*nQTDVEN			   		, NIL } )
								
								//--N๚mero do item
								cITEMSC6 := STRZero(nINDSC6,TamSX3("C6_ITEM")[1])
								aAdd ( aITENSC6, { "C6_ITEM", 			cITEMSC6				  		, NIL } )
								
								//--Data de entrega                                                                          
								nPOSENT := aScan(aDADOSTMP[nINDSC5][03],{ |x| ALLTRIM(x[1]) == "C5_OBSPED" })
								If nPOSENT != 0
									dENTREGA := STOD(aDADOSTMP[nINDSC5][03][nPOSENT,2])

									aDel(aDADOSTMP[nINDSC5][03],nPOSENT)
									aSize(aDADOSTMP[nINDSC5][03],Len(aDADOSTMP[nINDSC5][03])-1)		
							
								Else
									dENTREGA := ddatabase
								EndIf	
								aAdd ( aITENSC6, { "C6_ENTREG", 			dENTREGA					, NIL } )
								
								
								//--Controle sobre linha
								aAdd ( aITENSC6, { "AUTDELETA", 			"N"							, NIL } )
								
								aAdd ( aDADOSTMP[nINDSC5][04], aITENSC6 )

							Next nINDSC6
							
							//--Tabela de pre็o
							If cTABPRC != STRINGNULL
								aAdd ( aDADOSTMP[nINDSC5][03], { "C5_TABELA", 	LEFT(cTABPRC,3)			, NIL } )
							EndIf

							//--Elimina o campo C5_OBSPED (utilizado somente para tratamento da data de entrega)
							nPOSENT := aScan(aDADOSTMP[nINDSC5][03],{ |x| ALLTRIM(x[1]) == "C5_OBSPED" })
							If nPOSENT != 0
								aDel(aDADOSTMP[nINDSC5][03],nPOSENT)
								aSize(aDADOSTMP[nINDSC5][03],Len(aDADOSTMP[nINDSC5][03])-1)		
							EndIf
															
						EndIf
					EndIf
				EndIf						
			EndIf	
		Next nINDSC5		
	EndIf
	
	
	//--Execauto de inclusใo de pedidos
	If Len(aDADOSTMP) > 0
		For nINCSC5 := 1 to Len(aDADOSTMP)			
			
			lMsErroAuto := .F.
			cPEDB2B := aDADOSTMP[nINCSC5][01]
			aDATPAR := {}

			nPOSEMP := aScan ( aDADOSTMP[nINCSC5][03], { |x| ALLTRIM(x[1]) == "XX_CODCD" } )	
			If nPOSEMP != 0
				cCODEMP := LEFT(aDADOSTMP[nINCSC5][03][nPOSEMP][2],2)
				cCODFIL := RIGHT(aDADOSTMP[nINCSC5][03][nPOSEMP][2],2)
			EndIf

			nPOSPAR := aScan ( aDADOSTMP[nINCSC5][03], { |x| ALLTRIM(x[1]) == "XX_CONDPC" } )	
			If nPOSPAR != 0
				aDATPAR := aClone(aDADOSTMP[nINCSC5][03][nPOSPAR][2])
			EndIf
			
			//--Verifica se o pedido jแ foi incluํdo.
			If fChkPEDB2B(cCODEMP,cCODFIL,cPEDB2B)
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,"PEDIDO B2B Jม EXISTENTE - NฺMERO: "+cPEDB2B)
			ElseIf Len(aDADOSTMP[nINCSC5][03]) > 0 .and. Len(aDADOSTMP[nINCSC5][04]) > 0
				aAreaTMP := GetArea()
				cMESSAGE := STRINGNULL
				aDATSC5 := aClone(aDADOSTMP[nINCSC5][03])
				aDATSC6 := aClone(aDADOSTMP[nINCSC5][04])
				nVLRPED := aDADOSTMP[nINCSC5][05]
				
				//--Chamada da fun็ใo para inclusใo do pedido de venda.
				U_RJISC5B2B(cPEDB2B,aDATSC5,aDATSC6,aDATPAR,nVLRPED,@cMESSAGE)
				
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,cMESSAGE)
				RestArea(aAreaTMP)
			Else          
				//--Escreve no arquivo de log.
				U_RJB2BWFL(hFILELOG,"PEDIDO SEM CABECALHO OU ITENS - NฺMERO: "+cPEDB2B)
			EndIf
		Next nINCSC5
	EndIf                    

	//--Encerra arquivo de log.
	U_RJB2BEFL(hFILELOG)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJISC5B2B   บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo de inclusใo do pedido de venda.                      บฑฑ
ฑฑบTabela    ณSC5/SC6-Pedidos de venda.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJISC5B2B(cPEDB2B,aDATSC5,aDATSC6,aDATPAR,nVLRPED,cMESSAGE)

Local aAreaTMP := GetArea()
Local lRet := .T.          
                                 
	//--Recupera Empresa/Filial do Pedido
	nPOSEMP := aScan ( aDATSC5, { |x| ALLTRIM(x[1]) == "XX_CODCD" } )	
	If nPOSEMP != 0
		cCODEMP := LEFT(aDATSC5[nPOSEMP][2],2)
		cCODFIL := RIGHT(aDATSC5[nPOSEMP][2],2)
		
		//Elimina do array "XX_CODCD"	
		aDel(aDATSC5,nPOSEMP)
		aSize(aDATSC5,Len(aDATSC5)-1)		
	Else              
		cMESSAGE := "NรO LOCALIZADO CENTRO DISTRIBUIวรO DO PEDIDO."
	    Return (.F.)
	EndIf

	//--Elimina registro de recebimento em cartใo
	nPOSPAR := aScan ( aDATSC5, { |x| ALLTRIM(x[1]) == "XX_CONDPC" } )	
	If nPOSPAR != 0
		//Elimina do array "XX_CONDPC"	
		aDel(aDATSC5,nPOSPAR)
		aSize(aDATSC5,Len(aDATSC5)-1)		
	EndIf

	
	//--Tratamento de Empresa/Filial
	If cEmpAnt != cCODEMP 
		//-- Prepara o ambiente NO ERP, jแ abrindo as tabelas
		RpcClearEnv()
		RPCSetType(3)
		RpcSetEnv ( cCODEMP, cCODFIL,,,,, {"SA1","SA2","SB1","SB2","DA0","DA1","SC5","SC6"} )
	ElseIf cFilAnt != cCODFIL
		cFilAnt := cCODFIL
	EndIf
                      
	//--Chamada da fun็ใo para incluir pedidos Z51/Z52
	fIncPEDB2B(@aDATSC5,@aDATSC6,aDATPAR,nVLRPED)

	//--Tipo do Pedido
	nPOSTIP := aScan ( aDATSC5, { |x| ALLTRIM(x[1]) == "XX_TIPO" } )	
	If nPOSTIP != 0
		cTIPOPED := aDATSC5[nPOSTIP][2]		
		//Elimina do array "XX_TIPO"
		aDel(aDATSC5,nPOSTIP)
		aSize(aDATSC5,Len(aDATSC5)-1)		
	Else              
		cMESSAGE := "NรO LOCALIZADO TIPO DO PEDIDO."
	    Return (.F.)
	EndIf

	nPOSTRP := aScan ( aDATSC5, { |x| ALLTRIM(x[1]) == "XX_NOMTRP" } )	
	If nPOSTRP != 0
		//Elimina do array "XX_NOMTRP"
		aDel(aDATSC5,nPOSTRP)
		aSize(aDATSC5,Len(aDATSC5)-1)		
	EndIf

	//--Adiciona campos referente as regras de neg๓cios. 
	If fAddCpoRJU(@aDATSC5,@aDATSC6,cTIPOPED,@cMESSAGE)

		//--Recupera o n๚mero do pedido
	  	cSC5NUM := GetSxeNum("SC5","C5_NUM")
		aAdd ( aDATSC5, { "C5_NUM", cSC5NUM, NIL } )  	
		RollBackSX8()
	
		//--Ordena registros conforme dicionแrio.. 	
		aDATSC5 := FWVetByDic(aDATSC5,"SC5")
		aTMPSC6 := aClone(aDATSC6)
		For nI := 1 to Len(aTMPSC6)
			aTMPSC6[nI] := FWVetByDic(aTMPSC6[nI],"SC6")
		Next nI
	 	aDATSC6 := aClone(aTMPSC6)
	        
		lINCSC5B2B	:= .F.
		cMOSTRAERRO := STRINGNULL
		aRETORNO	:= StartJob("U_RJB2BPED", GetEnvServer(), .T., cCODEMP, cCODFIL, cSC5NUM, aClone(aDATSC5), aClone(aDATSC6) )
		
		lINCSC5B2B	:= aRETORNO[1]
		cMOSTRAERRO := aRETORNO[2]
		
	    If ! lINCSC5B2B
			lRet := .F.
			cMESSAGE := "ERRO NA INCLUSรO DO PEDIDO - "+cMOSTRAERRO
	
			//Atualiza campo observacoes do pedido Z51
			dbSelectArea("Z51")
			dbSetOrder(1)
			If dbSeek(xFilial("Z51")+cPEDB2B)
				If RecLock("Z51",.F.)
					Z51->Z51_PRBIMP := cMESSAGE
					Z51->(MsUnLock())
				EndIf
			EndIf
		Else 
			cMESSAGE := "PEDIDO B2B INCLUอDO COM SUCESSO! NฺMERO PEDIDO B2B: "+cPEDB2B+" NฺMERO PEDIDO NO PROTHEUS: "+cSC5NUM+" EMPRESA: "+cEmpAnt+" FILIAL: "+cFilAnt
			
			//Atualiza n๚mero do pedido Z51
			dbSelectArea("Z51")
			dbSetOrder(1)
			If dbSeek(xFilial("Z51")+cPEDB2B)
				If RecLock("Z51",.F.)
					Z51->Z51_NUMSC5	:= cSC5NUM
					Z51->Z51_PRBIMP	:= cMESSAGE
					Z51->(MsUnLock())
				EndIf
			EndIf
		Endif

		//Atualiza status pedido B2B como importado.
		U_RJUOSB2B(cPEDB2B)

		//--Avalia threads em execu็ใo e aguarda at้ a conclusใo para finalizar a rotina.
		While !FreeAllThreads()
			Sleep(10000)
		End Do	
	                                             
		//--Envio do workflow
		U_RJWFPB2B(Z51->Z51_FILIAL, cPEDB2B, DTOC(Z51->Z51_EMISSA), cMESSAGE)
	
	EndIf
	
	RestArea(aAreaTMP)


Return (lRet)
    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJB2BPED    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณExecuta MsExecAuto de inclusใo do pedido                    บฑฑ
ฑฑบTabela    ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJB2BPED( cCODEMP, cCODFIL, cSC5NUM, aDATSC5, aDATSC6 )

Local aRETORNO		:= {}
Local cIPSERVER		:= "192.168.205.30"
Local lINCSC5B2B	:= .F.
Local cAPPSERVER	:= GetAdv97()          
Local cPORTSERVER	:= GetPvProfString( "TCP", "port", "12010", cAPPSERVER)
Local cMOSTRAERRO	:= STRINGNULL

Private lMsErroAuto := .F.       

	oCONNSRV := rpcconnect(cIPSERVER, Val(cPORTSERVER), GetEnvServer(), cCODEMP, cCODFIL)
	/*
	If !(ValType(oCONNSRV) == "O")
		conout("ERRO DE COMUNICACAO COM PROTHEUS SERVER!")
		conout("IP/PORTA: " + cIPSERVER +"/"+ cPORTSERVER)
		Return
	EndIf
	*/
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv(cCODEMP, cCODFIL,,,,GetEnvServer(),{ "SC5" })	
	
 	nModulo := 5	//--Faturamento
	MSExecAuto({|x,y,z| MATA410(x,y,z)}, aDATSC5, aDATSC6, 3 )
	Sleep(1000)

	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	lINCSC5B2B := SC5->(dbSeek(xFilial("SC5") + cSC5NUM))
	
	If ! lINCSC5B2B             
		cMOSTRAERRO := MOSTRAERRO("\b2bvertis")
		RollBackSX8()		
		conout("RJB2BPED-ERRO NA INCLUSAO DO PEDIDO: "+cSC5NUM+" "+cMOSTRAERRO)
	Else                    
		ConfirmSX8()
		conout("RJB2BPED-PEDIDO INCLUIDO COM SUCESSO: "+cSC5NUM)
	EndIf  
	
	aAdd ( aRETORNO, lINCSC5B2B )
	aAdd ( aRETORNO, cMOSTRAERRO )

	rpcdisconnect(oCONNSRV)
	RpcClearEnv()
		
Return (aRETORNO)
                               

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณFreeAllThreadsบAutor ณTOTVS PARANA CENTRALบ Data ณ13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo utilizada para avaliar Threads em execu็ใo.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FreeAllThreads()

Local aUserInfoArray := GetUserInfoArray()
Local cEnvServer		 := GetEnvServer()
Local cComputerName	 := GetComputerName()
Local nThreads			 := 0
Local lFreeThreads   := .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_RJB2BPED" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfIncPEDB2B  บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณImporta็ใo de pedidos de venda atrav้s do B2B Vertis.       บฑฑ
ฑฑบTabela    ณSC5/SC6-Pedidos de venda.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fIncPEDB2B(aTmpSC5,aTmpSC6,aTmpPAR,nVLRPED)

Local nZ51NUMB2B := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_X_PB2B" 	})
Local nZ51CLIENT := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_CLIENTE"	})
Local nZ51LOJA   := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_LOJACLI"	})
Local nZ51VEND   := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_VEND1" 	})
Local nZ51CONDPG := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_CONDPAG"	})
Local nZ51TABPRC := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_TABELA" 	})
Local nZ51EMISSA := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_EMISSAO" 	})
Local nZ51VLRFRT := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_FRETE" 	})
Local nZ51TPFRET := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_TPFRETE" 	})
Local nZ51OBS    := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "C5_MENNOTA"	})
Local nZ51TIPO	 := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "XX_TIPO" 	})
Local nZ51NOMTRP := aScan (aTmpSC5, {|x| ALLTRIM(x[1]) == "XX_NOMTRP" 	})

	If nZ51NUMB2B > 0     
		Begin Transaction   
			dbSelectArea("Z51")
			dbSetOrder(1)
			If !dbSeek(xFilial("Z51")+aTmpSC5[nZ51NUMB2B][2])
				If RecLock("Z51",.T.)
					Z51->Z51_FILIAL	:= xFilial("Z51")
					Z51->Z51_NUMB2B	:= aTmpSC5[nZ51NUMB2B][2]
					Z51->Z51_NUMSC5	:= Space(TAMSX3("Z51_NUMSC5")[1])
					Z51->Z51_CLIENT	:= IIF(nZ51CLIENT>0,aTmpSC5[nZ51CLIENT][2],Space(TAMSX3("Z51_CLIENT")[1]))
					Z51->Z51_LOJA	:= IIF(nZ51LOJA>0,aTmpSC5[nZ51LOJA][2],Space(TAMSX3("Z51_LOJA")[1]))
					Z51->Z51_VEND	:= IIF(nZ51VEND>0,aTmpSC5[nZ51VEND][2],Space(TAMSX3("Z51_VEND")[1]))
					Z51->Z51_CONDPG	:= IIF(nZ51CONDPG>0,aTmpSC5[nZ51CONDPG][2],Space(TAMSX3("Z51_CONDPG")[1]))
					Z51->Z51_TABPRC	:= IIF(nZ51TABPRC>0,aTmpSC5[nZ51TABPRC][2],Space(TAMSX3("Z51_TABPRC")[1]))
					Z51->Z51_EMISSA	:= IIF(nZ51EMISSA>0,aTmpSC5[nZ51EMISSA][2],ctod(STRINGNULL))
					Z51->Z51_ENTREG	:= IIF(nZ51EMISSA>0,aTmpSC5[nZ51EMISSA][2],ctod(STRINGNULL))
					Z51->Z51_VLRFRT	:= IIF(nZ51VLRFRT>0,aTmpSC5[nZ51VLRFRT][2],0)
					Z51->Z51_VLRPED	:= nVLRPED
					Z51->Z51_OBS	:= IIF(nZ51OBS>0,aTmpSC5[nZ51OBS][2],Space(TAMSX3("Z51_OBS")[1]))
					Z51->Z51_TIPO	:= IIF(nZ51TIPO>0,aTmpSC5[nZ51TIPO][2],Space(TAMSX3("Z51_TIPO")[1]))
					If (Z51->(FieldPos("Z51_SB2B")) > 0)
						Z51->Z51_SB2B	:= "103"
					EndIf
					Z51->Z51_NOMTRP := IIF(nZ51NOMTRP>0,aTmpSC5[nZ51NOMTRP][2],Space(TAMSX3("Z51_NOMTRP")[1]))
					Z51->Z51_TIPFRT := IIF(nZ51TPFRET>0,aTmpSC5[nZ51TPFRET][2],Space(TAMSX3("Z51_TIPFRT")[1]))
					Z51->Z51_PRBIMP	:= ""
					//--Dados do pagamento em cartใo.
					If Len(aTmpPAR) > 0
						Z51->Z51_PGCNSU := aTmpPAR[Len(aTmpPAR)][01]
						Z51->Z51_PGCAUT := aTmpPAR[Len(aTmpPAR)][02]
						Z51->Z51_PGCMSG := aTmpPAR[Len(aTmpPAR)][03]
						Z51->Z51_NOSNUM := aTmpPAR[Len(aTmpPAR)][04]
					EndIf
					Z51->(MsUnLock())			

					For nINDSC6 := 1 to Len(aTmpSC6)

						nZ52PRODUT := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_PRODUTO"	})
						nZ52DESCRI := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_DESCRI"	})
						nZ52QUANT  := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_QTDVEN"	})
						nZ52VLRTAB := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_PRUNIT"	})
						nZ52VLRVEN := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_PRCVEN"	})
						nZ52VLRTOT := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_VALOR"		})
						nZ52VLRST  := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_ICMSRET"	})
						nZ52VLRDES := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_DESCONT"	})
						nZ52ENTREG := aScan (aTmpSC6[nINDSC6], {|x| ALLTRIM(x[1]) == "C6_ENTREG"	})
					
						If RecLock("Z52",.T.)
							Z52->Z52_FILIAL	:= xFilial("Z52")
							Z52->Z52_NUMB2B	:= aTmpSC5[nZ51NUMB2B][2]
							Z52->Z52_NUMSC5	:= Space(TAMSX3("Z52_NUMSC5")[1])
							Z52->Z52_ITEMPD := STRZero(nINDSC6,TAMSX3("Z52_ITEMPD")[1])
							Z52->Z52_PRODUT	:= IIF(nZ52PRODUT>0	,aTmpSC6[nINDSC6][nZ52PRODUT][2],Space(TAMSX3("Z52_PRODUT")[1]))
							Z52->Z52_DESCRI	:= IIF(nZ52DESCRI>0	,aTmpSC6[nINDSC6][nZ52DESCRI][2],Space(TAMSX3("Z52_DESCRI")[1]))
							Z52->Z52_QUANT	:= IIF(nZ52QUANT>0	,aTmpSC6[nINDSC6][nZ52QUANT][2]	,0)
							Z52->Z52_VLRTAB	:= IIF(nZ52VLRTAB>0	,aTmpSC6[nINDSC6][nZ52VLRTAB][2],0)
							Z52->Z52_VLRVEN	:= IIF(nZ52VLRVEN>0	,aTmpSC6[nINDSC6][nZ52VLRVEN][2],0)
							Z52->Z52_VLRTOT	:= IIF(nZ52VLRTOT>0	,aTmpSC6[nINDSC6][nZ52VLRTOT][2],0)
							Z52->Z52_VLRDES	:= IIF(nZ52VLRDES>0	,aTmpSC6[nINDSC6][nZ52VLRDES][2],0)
							Z52->Z52_VLRST	:= IIF(nZ52VLRST>0	,aTmpSC6[nINDSC6][nZ52VLRST][2]	,0) 
							Z52->Z52_ENTREG	:= IIF(nZ52ENTREG>0	,aTmpSC6[nINDSC6][nZ52ENTREG][2],ctod(STRINGNULL))
							Z52->Z52_PRBIMP	:= ""
							Z52->(MsUnLock())
						EndIf
					Next nINDSC6
				EndIf			
			EndIf
		End Transaction                         		
	EndIf                                       

	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfChkPEDB2B  บAutor ณTOTVS PARANA CENTRALบ Data ณ  05/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณVerifica existencia do pedido B2B Vertis no Protheus.       บฑฑ
ฑฑบTabela    ณSC5-Pedido de venda.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChkPEDB2B(cCODEMP,cCODFIL,cPEDB2B)

Local cAliasTMP	:= GetNextAlias()
Local cTABSC5	:= "% SC5"+cCODEMP+"0 %"
Local lRet		:= .F.

	BeginSql Alias cAliasTMP
		SELECT COUNT(*) NUMPED
		FROM	%Exp:cTABSC5%
		WHERE	C5_FILIAL = %Exp:cCODFIL%
		AND		C5_X_PB2B = %Exp:cPEDB2B%
		AND		%NotDel%
	EndSql
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		If (cAliasTMP)->NUMPED > 0
			lRet := .T.
		EndIf
	EndIf
	(cAliasTMP)->(dbCloseArea())

Return (lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJESTB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRetorna o saldo em estoque do produto.                      บฑฑ
ฑฑบTabela    ณSB2-Saldo em estoque.                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJESTB2B(cCODPRD, cCODFIL, cTABSB2)

Local cAliasTMP	:= GetNextAlias()
Local nSALDOEST	:= 0
	
	BeginSql Alias cAliasTMP
		SELECT SUM(SB2.B2_QATU-SB2.B2_RESERVA) B2_QATU
		FROM	%Exp:cTABSB2% SB2
		WHERE	SB2.B2_FILIAL	= %Exp:cCODFIL%
		AND		SB2.B2_COD		= %Exp:cCODPRD%
		AND		SB2.B2_LOCAL	= %Exp:'VINHOS'%
		AND		SB2.%NotDel%
	EndSql
	conout(GetLastQuery()[2])
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())
		nSALDOEST := Round( (cAliasTMP)->B2_QATU, 0)
	EndIf
	(cAliasTMP)->(dbCloseArea())
	

Return (nSALDOEST)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJB2BEND    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณTratamento sobre campo endere็o do cliente.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJB2BEND(cENDERECO)
Local cTIP := "14"			//--14=OUTRO
Local cEND := STRINGNULL		//--ENDEREวO
Local cNUM := STRINGNULL		//--NฺMERO

	Do case
		Case "RUA" $ cENDERECO
			cTIP := "1"
			cENDERECO := STRTRAN(cENDERECO,"RUA","")
		Case "AV." $ cENDERECO
			cTIP := "2"
			cENDERECO := STRTRAN(cENDERECO,"AV.","")
		Case "AVENIDA" $ cENDERECO
			cTIP := "2"
			cENDERECO := STRTRAN(cENDERECO,"AVENIDA","")
		Case "ALAMEDA" $ cENDERECO
			cTIP := "3"
			cENDERECO := STRTRAN(cENDERECO,"ALAMEDA","")
		Case "PRACA" $ cENDERECO
			cTIP := "4"
			cENDERECO := STRTRAN(cENDERECO,"PRACA","")
		Case "TRAVESSA" $ cENDERECO
			cTIP := "5"
			cENDERECO := STRTRAN(cENDERECO,"TRAVESSA","")
		Case "LARGO" $ cENDERECO
			cTIP := "6"
			cENDERECO := STRTRAN(cENDERECO,"LARGO","")
		Case "PRAIA" $ cENDERECO
			cTIP := "7"
			cENDERECO := STRTRAN(cENDERECO,"PRAIA","")
		Case "ATERRO" $ cENDERECO
			cTIP := "8"
			cENDERECO := STRTRAN(cENDERECO,"ATERRO","")
		Case "QUADRA" $ cENDERECO
			cTIP := "9"
			cENDERECO := STRTRAN(cENDERECO,"QUADRA","")
		Case "ESTRADA" $ cENDERECO
			cTIP := "10"
			cENDERECO := STRTRAN(cENDERECO,"ESTRADA","")
		Case "RODOVIA" $ cENDERECO
			cTIP := "11"
			cENDERECO := STRTRAN(cENDERECO,"RODOVIA","")
		Case "VIA" $ cENDERECO
			cTIP := "12"
			cENDERECO := STRTRAN(cENDERECO,"VIA","")
		Case "VIELA" $ cENDERECO
			cTIP := "13"
			cENDERECO := STRTRAN(cENDERECO,"VIELA","")
	Endcase
	
	//--Recupera o n๚mero
	For nI := 1 to LEN(cENDERECO)
		If SubSTR(cENDERECO, nI, 1) $ "0123456789"
	  		cNUM += SubSTR(cENDERECO, nI, 1)
		EndIf
	Next nI
	
	If cNUM != STRINGNULL 
		If Len(cNUM) > 10
			cNUM := SubSTR(cNUM,1,10)
		EndIf
		If cNUM $ cENDERECO
			cENDERECO := STRTRAN(cENDERECO,cNUM,"")
		EndIf		 	
	Else
		cNUM := "SN"
	EndIf
		
	cENDERECO := STRTRAN(cENDERECO,",","")
	cEND := ALLTRIM(cENDERECO)
		
	aRet := {cTIP,cEND,cNUM}

Return (aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJB2BCFL    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณCria็ใo de arquivo de log.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJB2BCFL(cFILELOG)
Local cFILELOG := CPATHFILES+cFILELOG+".LOG"
Local hFILELOG := 0              

	If !ExistDir(CPATHFILES)
		MakeDir(CPATHFILES)
	EndIf          
	
	hFILELOG := fCreate(cFILELOG)
	    	
	If hFILELOG == -1   				
		conout( "ERRO NA CRIACรO DO ARQUIVO: " + cFILELOG )				
	EndIf
	
Return (hFILELOG)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJB2BEFL    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFechamento do arquivo de log.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJB2BEFL(hFILELOG)
    
	//--Escreve no arquivo de log.
	cTEXTO := "FIM DO ARQUIVO."
	U_RJB2BWFL(hFILELOG,cTEXTO)
			
	fClose(hFILELOG)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJB2BWFL    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณEscreve no arquivo de log.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJB2BWFL(hFILELOG,cSTRING)
	
	cSTRING := DTOC(ddatabase) + "-" + TIME() + "-" + cSTRING + CHR(10)+CHR(13)
	fWrite(hFILELOG,cSTRING,Len(cSTRING))
	conout(cSTRING)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJFATB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina de manuten็ใo de pedidos B2B Vertis.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJFATB2B(lFiltro)

Private aRotina := { 	{ OemToAnsi("Pesquisar")  	,"AxPesqui"   , 0 , 1} ,;
						{ OemToAnsi("Visualizar") 	,"U_RJZ51WIN" , 0 , 2} ,;
					 	{ OemToAnsi("Inc. Pedido")  ,"U_RJZ51PED" , 0 , 3} ,;
					 	{ OemToAnsi("Alt. Status")  ,"U_RJZ51STS" , 0 , 4}  }
					 
Private aColors		:= {}
Private cCadastro	:= OemToAnsi("Pedidos B2B Vertis")   
Private cAliasTMP	:= "Z51"
PUBLIC STRING_NULL	:= "" 

Default	lFiltro		:= .F.

	aADD(aColors, { 'Empty(Z51_NUMSC5)'								, 'BR_VERDE'     })
	aADD(aColors, { '!Empty(Z51_NUMSC5).AND.Z51_NUMSC5!="XXXXXX"'	, 'BR_VERMELHO'  })
	aADD(aColors, { '!Empty(Z51_NUMSC5).AND.Z51_NUMSC5=="XXXXXX"'	, 'BR_PRETO'     })
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea(cAliasTMP)
	If lFiltro
		SET FILTER TO Z51->Z51_FILIAL == SC5->C5_FILIAL .AND. Z51->Z51_NUMSC5 == SC5->C5_NUM
	EndIf
	
	mBrowse(,,,,cAliasTMP,,,,,,aColors)

	If lFiltro
		SET FILTER TO 
	EndIf
	
Return(.T.)

Return
                                                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJZ51STS    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAltera็ใo de status de pedidos B2B Vertis.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJZ51STS()

Local 	aAreaTMP := GetArea()
Local 	cStatus	 := ""
Private nRadio	 := 1
Private cSTR103	 := "103=Pedido recebido, aguardando confirma็ใo de estoque do(s) produto(s)." 
Private cSTR104	 := "104=Pagamento confirmado"
Private cSTR105	 := "105=Nota fiscal emitida, em despacho."
Private cSTR106	 := "106=Pedido entregue para a transportadora."
Private cSTR107	 := "107=Pedido cancelado por pagamento."
Private cSTR108	 := "108=Pedido cancelado pelo cliente."
Private cSTR112	 := "112=Problemas de pagamento."
Private cSTR123	 := "123=Pedido cancelado por falta de produto."

Private oDlgSTATUS               
	    
	If (Z51->(FieldPos("Z51_SB2B")) > 0)

		If Z51->Z51_SB2B == SubSTR(cSTR103,1,3)
			cStatus := cSTR103 
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR104,1,3)
			cStatus := cSTR104			
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR105,1,3)
			cStatus := cSTR105
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR106,1,3)
			cStatus := cSTR106
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR107,1,3)
			cStatus := cSTR107
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR108,1,3)
			cStatus := cSTR108
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR112,1,3)
			cStatus := cSTR112
		ElseIf Z51->Z51_SB2B == SubSTR(cSTR123,1,3)
			cStatus := cSTR123
		EndIf

    ElseIf !Empty(Z51->Z51_NUMSC5)
    
		If Z51->Z51_NUMSC5 == "XXXXXX"
			Aviso("B2B","Pedido cancelado! Nใo poderแ ser mais utilizado.",{"OK"})
			Return
		EndIf

		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		If SC5->(dbSeek(Z51->Z51_FILIAL + Z51->Z51_NUMSC5))    
			If SC5->C5_X_SB2B == SubSTR(cSTR103,1,3)
				cStatus := cSTR103
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR104,1,3)
				cStatus := cSTR104				
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR105,1,3)
				cStatus := cSTR105
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR106,1,3)
				cStatus := cSTR106
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR107,1,3)
				cStatus := cSTR107
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR108,1,3)
				cStatus := cSTR108
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR112,1,3)
				cStatus := cSTR112
			ElseIf SC5->C5_X_SB2B == SubSTR(cSTR123,1,3)
				cStatus := cSTR123
			EndIf
		EndIf
	Else
		Alert("Nใo foi localizado o campo de controle de status = Z51_SB2B")
		Return
    EndIf
	
	DEFINE MSDIALOG oDlgSTATUS TITLE OemToAnsi("Status de pedidos - B2B") FROM 001,001 TO 240,420 OF oMainWnd PIXEL
	@ 010,020 SAY "Status Atual: "+cStatus 																	SIZE 250,009 OF oDlgSTATUS PIXEL 
	@ 020,020 SAY " Escolha o novo status:"																	SIZE 250,009 OF oDlgSTATUS PIXEL 
	@ 030,020 RADIO oRadio VAR nRadio ITEMS cSTR104,cSTR105,cSTR106,cSTR107,cSTR108,cSTR112,cSTR123 On Change (RJZ51AST())	SIZE 250,009 OF oDlgSTATUS PIXEL 
	@ 098,115 BUTTON oButton PROMPT "Confirmar" Action( RJZ51UST() )										SIZE 030,012 OF oDlgSTATUS PIXEL 
	@ 098,150 BUTTON oButton PROMPT "Cancelar" 	Action( oDlgSTATUS:End() )									SIZE 030,012 OF oDlgSTATUS PIXEL 
	
	ACTIVATE DIALOG oDlgSTATUS CENTERED  
	
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJZ51AST    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณVerifica altera็ใo de status de pedidos B2B Vertis.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RJZ51AST()

	If nRadio == 2 .or. nRadio == 3 .or. nRadio == 5
		Aviso("Aviso","O pedido de venda serแ excluํdo caso seja confirmado o status selecionado.",{"OK"})
	EndIf

Return (.T.)


                                                        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJZ51UST    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณAtualiza็ใo de status de pedidos B2B Vertis.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function RJZ51UST()

Local cStatus  := ""
Local aAreaTMP := GetArea()
Private lMsErroAuto := .F.

	If nRadio == 1   
		cStatus	 := SubSTR(cSTR104,1,3)
	ElseIf nRadio == 2
		cStatus	 := SubSTR(cSTR105,1,3)
	ElseIf nRadio == 3		
		cStatus	 := SubSTR(cSTR106,1,3)
	ElseIf nRadio == 4
		cStatus	 := SubSTR(cSTR107,1,3)
	ElseIf nRadio == 5
		cStatus	 := SubSTR(cSTR108,1,3)
	ElseIf nRadio == 6
		cStatus	 := SubSTR(cSTR112,1,3)
	ElseIf nRadio == 6
		cStatus	 := SubSTR(cSTR123,1,3)
	EndIf


	If Z51->(FieldPos("Z51_SB2B")) > 0
		If RecLock("Z51",.F.)
			Z51->Z51_SB2B := cStatus
			Z51->(MsUnLock())
		EndIf
    EndIf
    
    If !Empty(Z51->Z51_NUMSC5)
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		SC5->(dbGoTop())
		If SC5->(dbSeek(Z51->Z51_FILIAL + Z51->Z51_NUMSC5))    
			If RecLock("SC5",.F.)
				SC5->C5_X_SB2B  := cStatus
				SC5->C5_X_ESB2B	:= "S"
				SC5->(MsUnLock())
			EndIf
		EndIf              
		
		//--Envia novo status do pedido para B2B
		U_RJUSPB2B(.T.,Z51->Z51_FILIAL,Z51->Z51_NUMSC5)
		
		//--Exclusใo do pedido de venda
		If nRadio == 2 .or. nRadio == 3 .or. nRadio == 5

			aPedCab := {}
			aPedIts := {}
			aPedIte := {}
			
			aAdd(aPedCab,{'C5_NUM', 	SC5->C5_NUM, 	Nil})
			
			dbSelectArea("SC6")
			dbSetOrder(1)    
			If MsSeek(xFilial("SC6")+SC5->C5_NUM)
				While !SC6->(EOF()) .and. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)
					aAdd(aPedIte,{'C6_ITEM'   , SC6->C6_ITEM , Nil})
					aAdd(aPedIte,{'C6_NUM'    , SC6->C6_NUM  , Nil})
					aAdd(aPedIts, aPedIte)
					
					If SC6->C6_QTDEMP > 0
						dbSelectArea("SC9")
						dbSetOrder(1)
						If MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)
							SC9->(a460Estorna())
						Endif
					Endif
					SC6->(dbSkip())
				EndDo
			Endif
			
			MSExecAuto({|x,y,z|Mata410(x,y,z)}, aPedCab, aPedIts, 5)
			If lMsErroAuto
				Mostraerro()
			Else
				If RecLock("Z51",.F.)
					Z51->Z51_NUMSC5 := "XXXXXX"
					Z51->(MsUnLock())
				EndIf
			EndIf
			
		EndIf
	EndIf             
	
	oDlgSTATUS:End()
	RestArea(aAreaTMP)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJZ51WIN    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina de manuten็ใo de pedidos B2B Vertis.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJZ51WIN(cAlias, nReg, nOpc, xVar, nOper)

Local aArea      := GetArea()
Local aPosObj    := {}
Local aObjects   := {}
Local aSize      := MsAdvSize( .F. )
Local aGet       := {}
Local aTravas    := {}  
Local aRecZ52    := {}
Local aFldsNwTMP := {}                      
Local aFldsNwZ52 := {}
Local aAlterEnch := {}
Local aCpoEnch   := {}
Local nRegE      := 0
Local nModelo    := 3
Local lColumn    := .F. 
Local lF3        := .F. 
Local lMemoria   := .T.
Local lNoFolder  := .F. 
Local lProperty  := .F. 
Local lDelete    :=  IIf ( nOpc == 5 , .T., .F.)
Local bCampo     := {|nCPO| Field(nCPO)}
Local aPages     := {}
Local nOpcNewGd  := IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cCHAVE     := Z51->Z51_NUMB2B
Local cAliasZ51  := "Z51"
Local cSeekZ52   := STRING_NULL
Local cEntidZ52  := "Z52"
Local lGravou    := .F.
Local lTravas    := .T.
Local nCntFor    := 0
Local nUsado     := 0
Local nOpcA      := 0
Local nOpcVisul  := 0
Local nSx8Len    := GetSx8Len()
Local oDlgEmp    

PRIVATE aColsZ52  := {}
PRIVATE aHeadZ52  := {}
    
DEFAULT nOper    := 1  


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela Z51 no SX3 para montagem do Enchoiceณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ51)
	RegToMemory(cAliasZ51, .T., .T., .T.)                                          
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
		For i := 1 TO FCount()
			M->&(Eval(bCampo, i)) := FieldGet(i)
		Next i                  
	EndIf
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ51)
	While !Eof().and.(x3_arquivo==cAliasZ51)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
		Endif
		dbSkip()
	End                     
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ52 - TABELA Z52                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ52)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ52 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z52_FILIAL/Z52_NUMB2B/Z52_NUMSC5" )
			nUsado++
			
			aAdd(aHeadZ52,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
				
			
			aAdd(aFldsNwTMP, SX3->X3_CAMPO)
			
		EndIf

		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z52                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
	
		dbSelectArea(cEntidZ52)
		dbSetOrder(1)
	 	(cEntidZ52)->(dbGoTop())
		cSeekZ52 := xFilial( cEntidZ52 ) + cCHAVE
	
		If (cEntidZ52)->( MsSeek( cSeekZ52 ) )
			While ( !Eof() .And. cSeekZ52 == Z52->Z52_FILIAL + Z52->Z52_NUMB2B )
	
				If ( SoftLock(cEntidZ52 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ52,Array(nUsado+1))
					AAdd(aRecZ52, (cEntidZ52)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ52[nCntFor][10] != "V" )
							aColsZ52[Len(aColsZ52)][nCntFor] := Z52->(FieldGet(FieldPos(aHeadZ52[nCntFor][2])))
						Else
							aColsZ52[Len(aColsZ52)][nCntFor] := CriaVar(aHeadZ52[nCntFor,2])
						EndIf
					Next
					aColsZ52[Len(aColsZ52)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ52)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ52 )
		AAdd(aColsZ52,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ52[1,nCntFor] := CriaVar(aHeadZ52[nCntFor,2], .F. )
		Next nCntFor
		aColsZ52[1][nUsado+1] := .F.
	EndIf
	
	aFldsNwZ52 := aFldsNwTMP

	If ( lTravas )

	
		AAdd( aObjects, { 040, 100, .T., .F. } )
		AAdd( aObjects, { 060, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ51,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Itens"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ52 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "AllwaysTrue()", "AllwaysTrue()", , , 0, 99,, STRING_NULL, .T., oFolder:aDialogs[1], aHeadZ52 ,aColsZ52 )
			
		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ52:TudoOk(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()})

	
		For nCntFor := 1 To Len(aTravas)
			dbSelectArea(aTravas[nCntFor][1])
			dbGoto(aTravas[nCntFor][2])
			MsUnLock()
		Next nCntFor
	
	EndIf
	
	RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJZ51PED    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina de inclusใo de pedidos B2B Vertis.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJZ51PED()
Local aAreaTMP	:= GetArea()
Local aDATSC5	:= {}
Local aDATSC6	:= {}   
Local aDATPAR	:= {}


	dbSelectArea("Z51")
	
	If !Empty(Z51->Z51_NUMSC5) .and. Z51->Z51_NUMSC5 != "XXXXXX"
		Aviso("B2B","Pedido jแ incluํdo no ERP, n๚mero do pedido: "+Z51->Z51_NUMSC5,{"OK"})
	ElseIf Z51->Z51_NUMSC5 == "XXXXXX"
		Aviso("B2B","Pedido cancelado! Nใo poderแ ser mais utilizado.",{"OK"})
	Else
	
		cPEDB2B := Z51->Z51_NUMB2B
		
		//--Verifica se o pedido jแ foi incluํdo.
		If fChkPEDB2B(cEmpAnt,Z51->Z51_FILIAL,cPEDB2B)
			Aviso("Aviso","Pedido B2B n๚mero "+cPEDB2B+" jแ existente no Protheus.",{"OK"})	
			Return
		EndIf
		
		aAdd ( aDATSC5, { "C5_X_PB2B",	Z51->Z51_NUMB2B,	NIL } )
		aAdd ( aDATSC5, { "C5_FILIAL",	Z51->Z51_FILIAL,	NIL } )
		aAdd ( aDATSC5, { "C5_CLIENTE",	Z51->Z51_CLIENT,	NIL } )
		aAdd ( aDATSC5, { "C5_LOJACLI",	Z51->Z51_LOJA, 		NIL } )
		aAdd ( aDATSC5, { "C5_VEND1", 	Z51->Z51_VEND,		NIL } )
		aAdd ( aDATSC5, { "C5_CONDPAG",	Z51->Z51_CONDPG,	NIL } )
		aAdd ( aDATSC5, { "C5_TABELA",	Z51->Z51_TABPRC,	NIL } )
		aAdd ( aDATSC5, { "C5_EMISSAO",	Z51->Z51_EMISSA,	NIL } )
		aAdd ( aDATSC5, { "C5_MENNOTA",	Z51->Z51_OBS,		NIL } )
		aAdd ( aDATSC5, { "C5_FRETE",	Z51->Z51_VLRFRT,	NIL } )
		aAdd ( aDATSC5, { "C5_X_SB2B",	"103",				NIL } )
		aAdd ( aDATSC5, { "C5_X_IB2B",	"S",				NIL } )
		aAdd ( aDATSC5, { "C5_TIPO",	"N",				NIL } )
		aAdd ( aDATSC5, { "C5_TPVENDA",	"N",				NIL } )
		aAdd ( aDATSC5, { "XX_TIPO",	Z51->Z51_TIPO,		NIL } )
		aAdd ( aDATSC5, { "XX_NOMTRP",	Z51->Z51_NOMTRP,	NIL } )
		aAdd ( aDATSC5, { "XX_CODCD",	cEmpAnt+cFilAnt,	NIL } )

		dbSelectArea("Z52")
		dbSetOrder(1)
		dbSeek(xFilial("Z52")+Z51->Z51_NUMB2B)
		While Z52->(!EOF()) .AND. Z52->(Z52_FILIAL+Z52_NUMB2B) == Z51->(Z51_FILIAL+Z51_NUMB2B) 
			aDATEMP := {}
			aAdd ( aDATEMP, { "C6_ITEM",	Z52->Z52_ITEMPD,	NIL } )
			aAdd ( aDATEMP, { "C6_PRODUTO",	Z52->Z52_PRODUT,	NIL } )
			aAdd ( aDATEMP, { "C6_DESCRI",	Z52->Z52_DESCRI,	NIL } )
			aAdd ( aDATEMP, { "C6_QTDVEN",	Z52->Z52_QUANT,		NIL } )
			aAdd ( aDATEMP, { "C6_PRUNIT",	Z52->Z52_VLRTAB,	NIL } )
			aAdd ( aDATEMP, { "C6_PRCVEN",	Z52->Z52_VLRVEN,	NIL } )
			//aAdd ( aDATEMP, { "C6_ICMSRET",	Z52->Z52_VLRST,		NIL } ) -- Nใo deve adicionar o valor do ST ao pedido
			aAdd ( aDATEMP, { "C6_VALOR",	Z52->Z52_VLRTOT,	NIL } )
			aAdd ( aDATEMP, { "C6_ENTREG",	Z52->Z52_ENTREG,	NIL } )
			aAdd ( aDATEMP, { "AUTDELETA",	"N",				NIL } )
			aAdd(aDATSC6, aClone(aDATEMP))
			Z52->(dbSkip())
		Enddo
		
		//--Inclusใo do pedido.
		cMESSAGE := STRINGNULL
		U_RJISC5B2B(cPEDB2B,aDATSC5,aDATSC6,aDATPAR,Z51->Z51_VLRPED,@cMESSAGE)
		
	
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJWFPB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณRotina para envio de workflow de pedidos B2B Vertis.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RJWFPB2B(cFILPED, cNUMPED, cDATPED, cMESSAGE)
Local cProcess	:= OemToAnsi("000001")
Local cStatus	:= OemToAnsi("000001")
Local cEMAIL	:= CENDMAILWF
Local oProcess
Local oHtml

	oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedidos B2B Vertis"))
	oProcess:NewTask(cStatus,"\workflow\wfpedb2b.html")
	oProcess:cSubject := OemToAnsi("PEDIDO B2B VERTICO - "+cNUMPED)
	  
	oProcess:cTo := AllTrim(cEMAIL)
	oHTML:= oProcess:oHTML		
	oHtml:ValByName("cFILPED"	, cFILPED	)
	oHtml:ValByName("cNUMPED"	, cNUMPED	)
	oHtml:ValByName("cDATPED"	, cDATPED	)
	oHtml:ValByName("cMESSAGE"	, cMESSAGE	)

	oProcess:Start()
	
	oProcess:Finish()
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfUpdFLAGB2B บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo para atualiza็ใo de flag de exporta็ใo de registros. บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fUpdFLAGB2B(cTABLEUPD,cFIELDUPD,cWHEREUPD,cERRORUPD)
Local lRet	:= .T.

	cQueryUPD :=  " UPDATE "+cTABLEUPD+" SET "+cFIELDUPD+" WHERE "+cWHEREUPD
	If TCSqlExec(cQueryUPD) < 0
		cERRORUPD := TCSQLError()
		lRet := .F.	
	EndIf

Return(lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfAddCpoRJU  บAutor ณTOTVS PARANA CENTRALบ Data ณ  13/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo para tratamento sobre campos especificos sobre regrasบฑฑ
ฑฑบ          ณde neg๓cios para inclusใo de pedidos.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAddCpoRJU(aDATSC5,aDATSC6,cTIPOPED,cMESSAGE)
Local cAliasZZA		:= GetNextAlias()
Local nC5TIPO		:= aScan ( aDATSC5	 , { |x| ALLTRIM(x[1]) == "C5_TIPO"	   } )
Local nC5CLIENTE	:= aScan ( aDATSC5	 , { |x| ALLTRIM(x[1]) == "C5_CLIENTE" } )
Local nC5LOJA		:= aScan ( aDATSC5	 , { |x| ALLTRIM(x[1]) == "C5_LOJACLI" } )
Local nC5VEND1		:= aScan ( aDATSC5	 , { |x| ALLTRIM(x[1]) == "C5_VEND1"   } )
Local nC6PRODUTO 	:= aScan ( aDATSC6[1], { |x| ALLTRIM(x[1]) == "C6_PRODUTO" } )
Local cLVlPedido	:= STRINGNULL
Local cCCPedido		:= STRINGNULL

	If nC5TIPO == 0
		cMESSAGE := "CAMPO DO TIPO DO PEDIDO NรO LOCALIZADO NO ARRAY DO CABEวALHO."
		Return (.F.)
	EndIf
	
	If nC5CLIENTE == 0 .or. nC5LOJA == 0
		cMESSAGE := "CAMPO DO CLIENTE/LOJA DO PEDIDO NรO LOCALIZADO NO ARRAY DO CABEวALHO."
		Return (.F.)
	EndIf
	
	If nC5VEND1 == 0
		cMESSAGE := "CAMPO DO VENDEDOR DO PEDIDO NรO LOCALIZADO NO ARRAY DO CABEวALHO."
		Return (.F.)
	EndIf
	
	If nC6PRODUTO == 0
		cMESSAGE := "CAMPO DO PRODUTO DO PEDIDO NรO LOCALIZADO NO ARRAY DE ITENS."
		Return (.F.)
	EndIf

	//--Cadastro de produtos
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	SB1->(dbSeek(xFilial("SB1")+aDATSC6[1][nC6PRODUTO][02]))
	                        
	//--Armazem x Vendedor x Classe de valor
	/* ALTERADO CODIGO DE SEGMENTO FIXO = "003001001"
	dbSelectArea("Z22")
	dbSetOrder(01)
	dbSeek(xFilial("Z22")+aDATSC5[nC5VEND1][02])
	While !Z22->(EOF()) .and. Z22->Z22_FILIAL+Z22->Z22_CODVEN == xFilial("Z22")+aDATSC5[nC5VEND1][02]
		If Z22->Z22_ARMAZ == SB1->B1_LOCPAD
			cLVlPedido := Z22->Z22_CODCVL
			Exit
		EndIf
		Z22->(dbSkip())
	EndDo
	*/
                               
	If cLVlPedido == STRINGNULL
		cLVlPedido := "003001002"
	EndIf

	If cCCPedido == STRINGNULL
		cCCPedido := "020202001"
	EndIf

	If cLVlPedido != STRINGNULL
		AADD(aDATSC5, { "C5_X_CLVL"	, cLVlPedido, 	NIL } )
	EndIf
	
	If cCCPedido != STRINGNULL
		AADD(aDATSC5, { "C5_X_CC"	, cCCPedido, 	NIL } )
	EndIf
	

	//--Cadastro de clientes
	dbSelectArea("SA1")
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+aDATSC5[nC5CLIENTE][02]+aDATSC5[nC5LOJA][02]))
		lUFCLIDif := (SA1->A1_EST <> SM0->M0_ESTCOB)
	
		//--Percorre itens do pedido.
		For nI := 1 to Len(aDATSC6)
		
			//--Define variแveis para o item
			lAlteraTES := .F.
			cTesForaUF := ""	//--TES fora do estado
			cTesSubsTb := ""	//--TES substitui็ใo tributแria 
			cUFsSubsTb := ""	//--UF substitui็ใo tributแria 
			cTesCredPr := ""	//--TES cr้dito presumido
			cUFsCredPr := ""	//--UF cr้dito presumido
			cTesPedido := ""	//--TES do item do pedido
			cCofPedido := ""	//--CFOP item do pedido
			cOprPedido := IIF(cTIPOPED=="1","01","04")	//--Opera็ใo do item do pedido
			
			//--Cadastro de produto
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+aDATSC6[nI][nC6PRODUTO][2]))
	                             
			//--Indicador de produto
			dbSelectArea("SBZ")
			SBZ->(dbSetOrder(1))
			SBZ->(dbSeek(xFilial("SBZ")+SB1->B1_COD))
			
			//--Cadastro de TES
			dbSelectArea("SF4")
			SF4->(dbSetOrder(1))
			SF4->(dbSeek(xFilial("SF4") + SBZ->BZ_TS))
	
			//--Configura็๕es TES x Produtos
			BeginSQL alias cAliasZZA
				SELECT ZZA.ZZA_PRODUT, ZZA.ZZA_GRUPO, ZZA.ZZA_TESUFD, ZZA.ZZA_TESST, 
				ZZA.ZZA_UFSST, ZZA.ZZA_TESCRP, ZZA.ZZA_UFSCRP 
				FROM %TABLE:ZZA% ZZA
				WHERE ZZA.ZZA_FILIAL = %XFILIAL:ZZA%
				AND (ZZA.ZZA_GRUPO = %EXP:SB1->B1_GRUPO% OR ZZA.ZZA_PRODUT = %EXP:SB1->B1_COD%)
				AND %NOTDEL%
				ORDER BY ZZA.ZZA_PRODUT, ZZA.ZZA_GRUPO
			EndSQL
			
			While !(cAliasZZA)->(EOF())
				If !Empty((cAliasZZA)->ZZA_TESUFD)
					cTesForaUF := (cAliasZZA)->ZZA_TESUFD
				EndIf
				
				If !Empty((cAliasZZA)->ZZA_TESST) .and. SA1->A1_EST $ (cAliasZZA)->ZZA_UFSST
					cTesSubsTb := (cAliasZZA)->ZZA_TESST
					cUFsSubsTb := (cAliasZZA)->ZZA_UFSST
				EndIf
				
				If !Empty((cAliasZZA)->ZZA_TESCRP) .and. SA1->A1_EST $ (cAliasZZA)->ZZA_UFSCRP
					cTesCredPr := (cAliasZZA)->ZZA_TESCRP
					cUFsCredPr := (cAliasZZA)->ZZA_UFSCRP
				EndIf
				(cAliasZZA)->(dbSkip())
			EndDo		                   
			(cAliasZZA)->(dbCloseArea())
			
			aAdd( aDATSC6[nI] , {"C6_LOCAL"		, SBZ->BZ_LOCPAD	, NIL } )
			aAdd( aDATSC6[nI] , {"C6_X_PROMO"	, "N"				, NIL } )			
		
			//--Apenas seta o tipo de opera็ใo caso nใo seja pneu ou bonifica็ใo
			If SubSTR(cLVlPedido,1,3) == "005" .or. cOprPedido == "04"
				//--Seta apenas a opera็ใo que estแ sendo analisada, pois a conversใo jแ fica automแtica
				cOprPedido := "01"
				
				If SubSTR(cLVlPedido,1,3) == "005"
					If SA1->A1_TIPO == "S"
						cOprPedido := "01"
					Else
						cOprPedido := "03"
					EndIf
				EndIf			
			Else
				//--TES do indicador de produtos
				cTesPedido := SBZ->BZ_TS
				lAlteraTES := .T.
		 	EndIf    	 	
		 	aadd( aDATSC6[nI] ,{"C6_OPER"	, cOprPedido		, NIL } )			
		 	conout("C6_OPER-"+cOprPedido)
		 	
	                                             
			//--Altera a TES caso a mesma tenha sido informada e a venda ้ para fora do estado.
			If lUFCLIDif .And. !Empty(cTesForaUF) .And. (cOprPedido != "04")
				cTesPedido := cTesForaUF
				lAlteraTES := .T.
			EndIf
	
			//--Avalia se deve mudar o tipo do cliente e a TES do produto quanto ao tratamento de ST para alguns produtos
			If (SA1->A1_EST $ cUFsSubsTb .And. !Empty(cTesSubsTb)) .And. (cOprPedido != "04")
				cTesPedido := cTesSubsTb
				lAlteraTES := .T.
				
				//--Altera o tipo do cliente para solidแrio
				nPOS := aScan ( aDATSC5, {|x| ALLTRIM(x[1]) == "C5_TIPOCLI" } )
				If nPOS != 0
					// @aqui
					//aCabec[nPOS,02] := "S"
					aDATSC5[nPOS,02] := "S"
				Else					
					AADD(aDATSC5 , { "C5_TIPOCLI" , "S"			, NIL } )
				EndIf
			EndIf
	
			//--Avalia se deve mudar o tipo do cliente e a TES do produto quanto ao tratamento de Credito Presumido para alguns produtos
			If (SA1->A1_EST $ cUFsCredPr .And. !Empty(cTesCredPr)) .And. (cOprPedido != "04")
				cTesPedido := cTesCredPr
				lAlteraTES := .T.
			EndIf 
			
			If lAlteraTES .And. !Empty(cTesPedido) .And. (cOprPedido != "04")
				aadd( aDATSC6[nI] ,{ "C6_TES"	, cTesPedido		, NIL } )
				
				SF4->(dbSeek(xFilial("SF4") + cTesPedido))
				cCofPedido := IIF(lUFCLIDif, "6", "5") + SubSTR(SF4->F4_CF, 2, 3)
				
				If Left(cCofPedido,4) == "6405"
					cCofPedido := "6404"+SubSTR(cCofPedido,5,Len(cCofPedido)-4)
				Endif
			 	aadd( aDATSC6[nI] ,{ "C6_CF"	, cCofPedido		, NIL } )
	 		EndIf                  
	 		aAdd( aDATSC6[nI], { "C6_QTDEMP"	,	0				, NIL } )
	 		aAdd( aDATSC6[nI], { "C6_QTDLIB"	,	0				, NIL } )
	 		
		Next nI
	Else
		cMESSAGE := "CLIENTE/LOJA NAO LOCALIZADO NO CADASTRO."
		Return (.F.)
	EndIf

Return (.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJGETCGC    บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo com retorno de CNPJ das empresas do grupo CANTU.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJGETCGC()
Local aCNPJ := {}
Local aAreaTMP := GetArea()

	dbSelectArea("SM0")
	nRECSM0 := SM0->(RECNO())
	dbGoTop()
	While !SM0->(EOF())
		aAdd ( aCNPJ, { SM0->M0_CGC } )
		SM0->(dbSkip())
	Enddo
	SM0->(dbGoTo(nRECSM0))
	RestArea(aAreaTMP)
	
Return (aCNPJ)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณFGETZZ5     บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo com retorno do vendedor relacionado ao cliente.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGETZZ5(cCODCLI,cLOJCLI,cCODEMP,cCODFIL)
Local aAreaTMP 	:= GetArea()
Local aAliasTMP := GetNextAlias()
Local cCLVL		:= "003001001"
Local cRet		:= STRINGNULL
Local cTABZZ5	:= "% ZZ5"+cCODEMP+"0 %"                 
Local cFILZZ5	:= "% '"+cCODFIL+"' %"

	BeginSQL alias aAliasTMP
		SELECT	ZZ5.ZZ5_VEND
		FROM 	%EXP:cTABZZ5% ZZ5
		WHERE	ZZ5.ZZ5_FILIAL	= %EXP:cFILZZ5%
		AND		ZZ5.ZZ5_CLIENT	= %EXP:cCODCLI%
		AND		ZZ5.ZZ5_LOJA	= %EXP:cLOJCLI%
		AND		ZZ5.ZZ5_SEGMEN	= %EXP:cCLVL%
		AND 	%NOTDEL%
		ORDER BY ZZ5.ZZ5_VEND
	EndSQL
	
	If !(aAliasTMP)->(EOF())
		dbSelectArea("SA3")
		dbSetOrder(1)
		If dbSeek(xFilial("SA3")+(aAliasTMP)->ZZ5_VEND)
			If SA3->A3_MSBLQL != "1"
				cRet := (aAliasTMP)->ZZ5_VEND
			EndIf
		EndIf
	EndIf
	(aAliasTMP)->(dbCloseArea())

	RestArea(aAreaTMP)  
	
	
Return (cRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJIDUF      บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFun็ใo responsแvel por enviar o ID da UF conforme tabela de บฑฑ
ฑฑบ          ณmunicipios VERTICO.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RJIDUF(cUF)         
Local cRet := ""

Do Case
	Case cUF == 'RO'
		cRet := "11"
	Case cUF == 'AC'
		cRet := "12"
	Case cUF == 'AM'
		cRet := "13"
	Case cUF == 'RR'
		cRet := "14"
	Case cUF == 'PA'
		cRet := "15"
	Case cUF == 'AP'
		cRet := "16"
	Case cUF == 'TO'
		cRet := "17"
	Case cUF == 'MA'
		cRet := "21"
	Case cUF == 'PI'
		cRet := "22"
	Case cUF == 'CE'
		cRet := "23"
	Case cUF == 'RN'
		cRet := "24"
	Case cUF == 'PB'
		cRet := "25"
	Case cUF == 'PE'
		cRet := "26"
	Case cUF == 'AL'
		cRet := "27"
	Case cUF == 'SE'
		cRet := "28"
	Case cUF == 'BA'
		cRet := "29"
	Case cUF == 'MG'
		cRet := "31"
	Case cUF == 'ES'
		cRet := "32"
	Case cUF == 'RJ'
		cRet := "33"
	Case cUF == 'SP'
		cRet := "35"
	Case cUF == 'PR'
		cRet := "41"
	Case cUF == 'SC'
		cRet := "42"
	Case cUF == 'RS'
		cRet := "43"
	Case cUF == 'MS'
		cRet := "50"
	Case cUF == 'MT'
		cRet := "51"
	Case cUF == 'GO'
		cRet := "52"
	Case cUF == 'DF'
		cRet := "53"
EndCase
	                

Return (cRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJJEDB2B    บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณInterface de importa็ใo e exporta็ใo de dados B2B Vertis.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RJJEDB2B()

Private lPROCESSA  := .F.
Private lEXPORTALL := .F.
Private lEXPORTUPD := .T.
Private lUPDATEREC := .T.                    

//--Catแlogos (ImportCatalog)
Private lRJECTB2B := .T.
//--Tabelas de pre็os (ImportPriceTable)
Private lRJEPTB2B := .T.
//--Perfil e-commerce (ImportProfile)
Private lRJEPFB2B := .T.
//--Centro de distribui็ใo (ImportDistributionCenter)
Private lRJIDTB2B := .T.
//--Departamentos (ImportDept)                              
Private lRJEDEB2B := .T.
//--Fabricantes (ImportProductBrand)
Private lRJEFBB2B := .T.
//--Produtos (ImportProduct)
Private lRJEPDB2B := .T.
//--Produtos SKU (ImportProductSku)
Private lRJEPSB2B := .T.
//--Tabela de pre็o x produtos (ImportProductSkuPrice)
Private lRJETPB2B := .T.
//--Atualiza็ใo do estoque (UpdateProductSkuInventory)
Private lRJUSEB2B := .T.
//--Catแlogos x departamentos (ImportCatalogXDept)
Private lRJECDB2B := .T.
//--Catแlogos x produtos (ImportCatalogXProduct)
Private lRJECPB2B := .T.
//--Departamentos x produtos (ImportDeptXProduct)
Private lRJEDPB2B := .T.
//--Clientes (ImportCompany/ImportCompanyAddress)
Private lRJECLB2B := .T.
//--Perfil x clientes (ImportProfileXCompany)
Private lRJEPCB2B := .T.
//--Atualizacao do limite de credito (UpdateCompanyLimit)
Private lRJULCB2B := .T.
//--Centro de distribui็ใo x Clientes (ImportDistributionCenterXCompany)
Private lRJIDCB2B := .T.
//--Centro de distribui็ใo x Transportadores (ImportDistributionCenterXShippingMethod)
Private lRJIDSB2B := .T.
//--Importa็ใo de clientes atrav้s do B2B Vertis (ExportCompany/ExportCompanyAddress/UpdateCompanySync)
Private lRJICLB2B := .T.
//--Atualiza็ใo do status de clientes (UpdateCompanyStatus)
Private lRJUSCB2B := .T.
//--Importa็ใo de Pedidos B2B (ExportOrder/ExportOrderItem/UpdateOrderSync)
Private lRJIPVB2B := .T.
//--Atualiza็ใo status do pedido (UpdateOrderStatus)
Private lRJUSPB2B := .T.

Private cSRVINI 	:= GetAdv97()
Private cEMPFIL		:= ""
Private cCODEMP		:= ""
Private cCODFIL		:= ""
                           
Private oChkEXP1
Private oChkEXP2
Private oChkWIN
Private oDlgWIN

	conout(TIME()+" - RJJEDB2B - INICIO DA EXECUวรO.")    
	
	If type("cFilAnt") == "U"

		// Recupera empresa/filial do APPSERVER.INI
		cEMPFIL := GetPvProfString( "B2BVERTIS", "PREPAREIN", "", cSRVINI )
		cCODEMP := SubSTR(cEMPFIL,1,2)
		cCODFIL := SubSTR(cEMPFIL,4,2)
		
		// Prepara o ambiente NO ERP, jแ abrindo as tabelas
		RpcClearEnv()
		RPCSetType(3)
		RpcSetEnv ( cCODEMP, cCODFIL,,,,, {"SA1","SA2","SB1","SB2","DA0","DA1","SC5","SC6"} )
		
		conout(TIME()+" - RJJEDB2B - EXECUวรO VIA JOB. EMPRESA: "+cCODEMP+" - FILIAL: "+cCODFIL)    

		FPROCINT()
		
	Else
	
		If ALLTRIM(cEmpAnt) != "02"
			Alert("Esta fun็ใo deverแ ser executada na empresa 02.")
			Return
		EndIf                                               
		             

		DEFINE MSDIALOG oDlgWIN TITLE OemToAnsi("Integra็ใo B2B Vertis") FROM 001,001 TO 590,560 OF oMainWnd PIXEL
		
		@ 005,002 TO 024,280	OF oDlgWIN PIXEL 
		@ 010,015 Say " Integra็ใo B2B Vertis - Interface de importa็ใo e exporta็ใo de registros." 	OF oDlgWIN PIXEL 	
                                                                                                                            
		@ 025,002 TO 044,280	OF oDlgWIN PIXEL 
		@ 030,015 CHECKBOX oChkEXP1 VAR lEXPORTALL PROMPT "Exportar registros (todos)"									ON CHANGE fChkExpReg(1)	SIZE 100,9	OF oDlgWIN PIXEL 	
		@ 030,145 CHECKBOX oChkEXP2 VAR lEXPORTUPD PROMPT "Exportar registros (novos/alterados)"						ON CHANGE fChkExpReg(2)	SIZE 100,9	OF oDlgWIN PIXEL 	

		@ 045,002 TO 275,280	OF oDlgWIN PIXEL 
		@ 050,015 CHECKBOX oChkWIN VAR lRJECTB2B PROMPT "Catแlogos (ImportCatalog)"																SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 060,015 CHECKBOX oChkWIN VAR lRJEPTB2B PROMPT "Tabelas de pre็o (ImportPriceTable)" 													SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 070,015 CHECKBOX oChkWIN VAR lRJEPFB2B PROMPT "Perfil B2B (ImportProfile)"      														SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 080,015 CHECKBOX oChkWIN VAR lRJIDTB2B PROMPT "Centros de distribui็ใo (ImportDistributionCenter)" 									SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 090,015 CHECKBOX oChkWIN VAR lRJEDEB2B PROMPT "Departamentos (ImportDept)" 															SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 100,015 CHECKBOX oChkWIN VAR lRJEFBB2B PROMPT "Fabricantes (ImportProductBrand)" 						   								SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 110,015 CHECKBOX oChkWIN VAR lRJEPDB2B PROMPT "Produtos (ImportProduct)" 						   										SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 120,015 CHECKBOX oChkWIN VAR lRJEPSB2B PROMPT "Produtos SKU (ImportProductSku)" 						   								SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 130,015 CHECKBOX oChkWIN VAR lRJETPB2B PROMPT "Tabelas de pre็o x produtos (ImportProductSkuPrice)" 						   			SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 140,015 CHECKBOX oChkWIN VAR lRJECDB2B PROMPT "Catแlogos x departamentos (ImportCatalogXDept)"										SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 150,015 CHECKBOX oChkWIN VAR lRJECPB2B PROMPT "Catแlogos x produtos (ImportCatalogXProduct)"											SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 160,015 CHECKBOX oChkWIN VAR lRJEDPB2B PROMPT "Departamentos x produtos (DeleteDeptXProduct/ImportDeptXProduct)"						SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 170,015 CHECKBOX oChkWIN VAR lRJUSEB2B PROMPT "Atualiza็ใo de estoques (UpdateProductSkuInventory)" 									SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 180,015 CHECKBOX oChkWIN VAR lRJECLB2B PROMPT "Clientes (ImportCompany/ImportCompanyAddress)" 										SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 190,015 CHECKBOX oChkWIN VAR lRJEPCB2B PROMPT "Perfil x clientes (ImportProfileXCompany)" 											SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 200,015 CHECKBOX oChkWIN VAR lRJULCB2B PROMPT "Atualiza็ใo do limites de cr้dito (UpdateCompanyLimit)" 								SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 210,015 CHECKBOX oChkWIN VAR lRJIDCB2B PROMPT "Centros de distribui็ใo x clientes (ImportDistributionCenterXCompany)" 				SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 220,015 CHECKBOX oChkWIN VAR lRJIDSB2B PROMPT "Centros de distribui็ใo x transportadores (ImportDistributionCenterXShippingMethod)" 	SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 230,015 CHECKBOX oChkWIN VAR lRJICLB2B PROMPT "Importa็ใo de clientes B2B (ExportCompany/ExportCompanyAddress/UpdateCompanySync)" 	SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 240,015 CHECKBOX oChkWIN VAR lRJUSCB2B PROMPT "Atualiza็ใo do status de clientes B2B (UpdateCompanyStatus)" 							SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 250,015 CHECKBOX oChkWIN VAR lRJIPVB2B PROMPT "Importa็ใo de pedidos B2B (ExportOrder/ExportOrderItem/UpdateOrderSync)" 				SIZE 280,9	OF oDlgWIN PIXEL 	
		@ 260,015 CHECKBOX oChkWIN VAR lRJUSPB2B PROMPT "Atualiza็ใo do status de pedidos B2B (UpdateOrderStatus)" 								SIZE 280,9	OF oDlgWIN PIXEL 	

		@ 280,080 BUTTON oButton1 PROMPT "Marcar/Desmarcar" 	Action (fMarkAllReg()					) SIZE 060, 012 OF oDlgWIN PIXEL		
		@ 280,150 BUTTON oButton1 PROMPT "Confirmar" 			Action (oDlgWIN:End(), lPROCESSA := .T.	) SIZE 060, 012 OF oDlgWIN PIXEL		
		@ 280,220 BUTTON oButton1 PROMPT "Cancelar"  			Action (oDlgWIN:End(), lPROCESSA := .F.	) SIZE 060, 012 OF oDlgWIN PIXEL		

		Activate Dialog oDlgWIN Centered  		
		
		conout(TIME()+" - RJJEDB2B - EXECUวรO MANUAL.")    
		
		If lPROCESSA     
			MsAguarde( {|| FPROCINT() }, "Processando... Aguarde!")	
			Aviso("Aviso","Processo concluido.",{"OK"})
		EndIf
	
	EndIf      
	

	conout(TIME()+" - RJJEDB2B - FIM DA EXECUวรO.")    
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfMarkAllReg บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณFuncao de marcacao de flags para exportacao e importacao.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                    
Static Function fMarkAllReg()   

	lEXPORTALL := .F.
	lEXPORTUPD := .T.
	     
	If lRJECTB2B
		lRJECTB2B := .F.
		lRJEPTB2B := .F.
		lRJEPFB2B := .F.
		lRJIDTB2B := .F.
		lRJEDEB2B := .F.
		lRJEFBB2B := .F.
		lRJEPDB2B := .F.
		lRJEPSB2B := .F.
		lRJETPB2B := .F.
		lRJUSEB2B := .F.
		lRJECPB2B := .F.
		lRJECDB2B := .F.
		lRJEDPB2B := .F.
		lRJECLB2B := .F.
		lRJEPCB2B := .F.
		lRJULCB2B := .F.
		lRJIDCB2B := .F.
		lRJIDSB2B := .F.
		lRJICLB2B := .F.
		lRJUSCB2B := .F.
		lRJIPVB2B := .F.
		lRJUSPB2B := .F.
	Else
		lRJECTB2B := .T.
		lRJEPTB2B := .T.
		lRJEPFB2B := .T.
		lRJIDTB2B := .T.
		lRJEDEB2B := .T.
		lRJEFBB2B := .T.
		lRJEPDB2B := .T.
		lRJEPSB2B := .T.
		lRJETPB2B := .T.
		lRJUSEB2B := .T.
		lRJECPB2B := .T.
		lRJECDB2B := .T.
		lRJEDPB2B := .T.
		lRJECLB2B := .T.
		lRJEPCB2B := .T.
		lRJULCB2B := .T.
		lRJIDCB2B := .T.
		lRJIDSB2B := .T.
		lRJICLB2B := .T.
		lRJUSCB2B := .T.
		lRJIPVB2B := .T.
		lRJUSPB2B := .T.
	EndIf              

	oChkEXP1:Refresh()      
	oChkEXP2:Refresh()      
	oChkWIN:Refresh()      
	oDlgWIN:Refresh()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfChkExpReg  บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณControle de exportacao de registros.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fChkExpReg(nOpcao)

	If nOpcao == 1
		lEXPORTUPD := .F.
		lEXPORTALL := .T.           
		Aviso("Aviso","A exporta็ใo de todos os registros somente deverแ ser executada para carga inicial no site ou modifica็๕es de cadastros atrav้s da base de dados.",{"OK"})
	Else
		lEXPORTALL := .F.
		lEXPORTUPD := .T.
	EndIf
	
	oChkEXP1:Refresh()      
	oChkEXP2:Refresh()      
	oChkWIN:Refresh()
	oDlgWIN:Refresh()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณFPROCINT    บAutor ณTOTVS PARANA CENTRALบ Data ณ  15/04/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณChamada das funcoes de exporta็ใo e importa็ใo.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FPROCINT()                                                  

	//--Catแlogos - (DA0) Tabelas de pre็os (ImportCatalog)
	If lRJECTB2B
		U_RJECTB2B(lEXPORTALL,lUPDATEREC) 
		//--Executa sempre os dois metodos pois ambos exportam os registros da DA0.
		//--Tabelas de pre็os (ImportPriceTable)
		If !lRJEPTB2B
			U_RJEPTB2B(lEXPORTALL, lUPDATEREC)
		EndIf
	EndIf

	//--Tabelas de pre็os (ImportPriceTable)
	If lRJEPTB2B                                                        
		//--Executa sempre os dois metodos pois ambos exportam os registros da DA0.
		//--Catแlogos - (DA0) Tabelas de pre็os (ImportCatalog)
		If !lRJECTB2B
			U_RJECTB2B(lEXPORTALL,lUPDATEREC) 
		EndIf
		U_RJEPTB2B(lEXPORTALL, lUPDATEREC)
	EndIf

	//--Perfil e-commerce (ImportProfile)
	//--RJFATP09 - Perfil B2B
	If lRJEPFB2B
		U_RJEPFB2B(lEXPORTALL, lUPDATEREC)
	EndIf
	
	//--Centro de distribui็ใo (ImportDistributionCenter)
	If lRJIDTB2B
		U_RJIDTB2B(lEXPORTALL) 
	EndIf

	//--Departamentos (ImportDept)                              
	//--RJFATP12 - Departamentos B2B
	If lRJEDEB2B
		U_RJEDEB2B(lEXPORTALL, lUPDATEREC) 
	EndIf

	//--Fabricantes (ImportProductBrand)
	//-- Depende do fornecedor e produto contem o campo Exporta B2B = SIM e os mesmos estiverem relacionados na rotina Produtos x Fornecedores.
	If lRJEFBB2B
		U_RJEFBB2B(lEXPORTALL) 
	EndIf

	//--Produtos (ImportProduct)
	If lRJEPDB2B
		U_RJEPDB2B(lEXPORTALL) 
	EndIf

	//--Produtos SKU (ImportProductSku)
	If lRJEPSB2B
		U_RJEPSB2B(lEXPORTALL,lUPDATEREC)
	EndIf

	//--Tabela de pre็o x produtos (ImportProductSkuPrice)
	If lRJETPB2B
		U_RJETPB2B(lEXPORTALL) 
	EndIf

	//--Catแlogos x departamentos (ImportCatalogXDept)
	If lRJECDB2B
		U_RJECDB2B(lEXPORTALL, lUPDATEREC)
	EndIf

	//--Catแlogos x produtos (ImportCatalogXProduct)
	If lRJECPB2B
		U_RJECPB2B(lEXPORTALL, lUPDATEREC)
	EndIf
	
	//--Departamentos x produtos (ImportDeptXProduct)
	//-- RJFATP13 - Departamentos x produtos
	If lRJEDPB2B
		U_RJEDPB2B(lEXPORTALL) 
	EndIf
	
	//--Atualiza็ใo do estoque (UpdateProductSkuInventory)
	If lRJUSEB2B
		U_RJUSEB2B() 
	EndIf

	//--Clientes (ImportCompany/ImportCompanyAddress)
	If lRJECLB2B
		U_RJECLB2B(lEXPORTALL) 
	EndIf
	
	//--Perfil x clientes (ImportProfileXCompany)
	If lRJEPCB2B
		U_RJEPCB2B(lEXPORTALL)
	EndIf
	
	//--Atualiza็ใo do limite de credito (UpdateCompanyLimit)
	If lRJULCB2B
		U_RJULCB2B(lEXPORTALL, lUPDATEREC, STRINGNULL) 
	EndIf

	//--Centro de distribui็ใo x Clientes (ImportDistributionCenterXCompany)
	If lRJIDCB2B
		U_RJIDCB2B(lEXPORTALL, STRINGNULL) 
	EndIf

	//--Centro de distribui็ใo x Transportadores (ImportDistributionCenterXShippingMethod)
	If lRJIDSB2B
		U_RJIDSB2B(lEXPORTALL)
	EndIf
	
	//--Importa็ใo de clientes B2B (ExportCompany/ExportCompanyAddress/UpdateCompanySync)
	If lRJICLB2B
		U_RJICLB2B()  	
	EndIf

	//--Atualiza็ใo do status de clientes (UpdateCompanyStatus)
	If lRJUSCB2B
		U_RJUSCB2B(lEXPORTALL, lUPDATEREC) 
	EndIf

	//--Importa็ใo de Pedidos B2B (ExportOrder/ExportOrderItem/UpdateOrderSync)
	If lRJIPVB2B
		U_RJIPVB2B()
	EndIf

	//--Atualiza็ใo status do pedido (UpdateOrderStatus)
	If lRJUSPB2B
		U_RJUSPB2B(lUPDATEREC,STRINGNULL,STRINGNULL)
	EndIf

Return