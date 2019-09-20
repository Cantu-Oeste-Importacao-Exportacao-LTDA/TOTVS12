#Include 'Protheus.ch'

/*/{Protheus.doc} RetTgHtm
Modifica caracteres especiais HTML
	
@author devair.tonon
@since 16/02/2015
@version 1.0
		
/*/

user function RetTgHtm(cXML)
	/*
	for nI:=1 to len (cXML)   
		
		if substr(cXML,nI,1)== '&'  
	   		cXML := strtran(cXML, '&' ,"&amp;")
		endif     	 
	next nI*/
	
	cXML := strtran(cXML, '&' ,"&amp;")
	cXML := StrTran(cXML,'<',"")                         
	cXML := StrTran(cXML,'>',"") 
	cXML := strtran(cXML, char(26) ,"")
	
return cXML
