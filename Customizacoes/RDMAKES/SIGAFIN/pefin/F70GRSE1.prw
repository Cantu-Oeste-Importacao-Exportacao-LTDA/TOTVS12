#Include 'Protheus.ch'

/*/{Protheus.doc} F70GRSE1

Envia dados de baixa de titulo para para Salesforce

@author devair.tonon
@since 13/02/2015
@version 1.0

/*/
 

User Function F70GRSE1()
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
	local lMVXINTSF	:= .F.
	local lMVXSFJOB	:= .F. 
	local cIndexKey	:= ""
	/*
	
	Envia dados de baixa de titulo para para Salesforce
	
	@author devair.tonon
	@since 13/02/2015
	@version 1.0
	
	*/
	lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
		
	if FindFunction('U_SFIBATCH') .AND. lMVXINTSF
		
		cIndexKey := SE1->(INDEXKEY())
		cIndexKey := "SE1->("+cIndexKey+")"		
		U_SFIBATCH(cEmpAnt, cFilAnt, "SE1", &(cIndexKey) , SE1->(INDEXORD()), "A")		
 	 		
    endif 
    
    ErrorBlock(oError)
Return

