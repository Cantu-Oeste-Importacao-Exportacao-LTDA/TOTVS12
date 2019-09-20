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
	/*
	
	Envia dados de baixa de titulo para para Salesforce
	
	@author devair.tonon
	@since 13/02/2015
	@version 1.0
	
	*/
	lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	

	if FindFunction('U_SFTIT001') .AND. lMVXINTSF
	
		if !isInCallStack("FINA200") .AND. !isInCallStack("FINA205")
					
	   		conout("SALESFORCE | " + cEmpAnt + " | " + TIME() +" | PROCESSAMENTO INDIVIDUAL")  
	   		conout("SALESFORCE | " + cEmpAnt + " | " +  TIME() +" | ENVIANDO TITULO "+ cEmpAnt+SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) ) 

			if lMVXSFJOB                                                                       
				StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
			else
				U_SFTIT001()
			endif				   		
			
	 	else                                                     
	 	
	    	//CRIA ARQUIVO TEMPORARIO PARA GRAVAR OS TITULOS BAIXADOS     
			if select ("SFBXTIT")==0
				conout("SALESFORCE | " + cEmpAnt + " | " +  TIME() +" | CRIANDO ARQUIVO TEMPORARIO DE BAIXA DOS TITULOS")
				
				SFBXTIT()  
			
			endif 

		    //FAZ SOMENTE SE O ARQUIVO JA ESTIVER ABERTO
		    if select ("SFBXTIT")!=0
		        //SE O REGISTRO DA SE1 POSICIONADO É O PROCURADO ANTERIORMENTE
		    	if  SFBXTIT->(!dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))) 
			    	SFBXTIT->(dbAppend())
			    	SFBXTIT->FILIAL := SE1->E1_FILIAL
			    	SFBXTIT->PREFIXO:= SE1->E1_PREFIXO
			    	SFBXTIT->NUM 	:= SE1->E1_NUM
			    	SFBXTIT->PARCELA:= SE1->E1_PARCELA
			    	SFBXTIT->TIPO 	:= SE1->E1_TIPO			    	
		
			    	conout("SALESFORCE | " + cEmpAnt + " | " +  TIME() +" | ADICIONANDO TITULO "+ cEmpAnt+SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) )   
		    	endif   	
		    endif
		    
		    
	 	endif	
    endif 
    
    
    ErrorBlock(oError)
Return

/*********************************************************************************

Função de criação de arquivo temporário para gravar o titulos baixados via cnab e 
enviá-los ao SF em lote

**********************************************************************************/
static function SFBXTIT()  

	local aStru := {}
	
	AADD(aStru,{ "FILIAL"  	, "C", TAMSX3("E1_FILIAL")[1] 	, TAMSX3("E1_FILIAL")[2]})
	AADD(aStru,{ "PREFIXO"  , "C", TAMSX3("E1_PREFIXO")[1]	, TAMSX3("E1_PREFIXO")[2]})
	AADD(aStru,{ "NUM"  	, "C", TAMSX3("E1_NUM")[1]		, TAMSX3("E1_NUM")[2]})
	AADD(aStru,{ "PARCELA"  , "C", TAMSX3("E1_PARCELA")[1]	, TAMSX3("E1_PARCELA")[2]})
	AADD(aStru,{ "TIPO"  	, "C", TAMSX3("E1_TIPO")[1] 	, TAMSX3("E1_TIPO")[2]}) 
	
	cArqTrab := CriaTrab(aStru, .T.)
	USE &cArqTrab ALIAS SFBXTIT NEW
	
	cIndice := "FILIAL+PREFIXO+NUM+PARCELA+TIPO"      
	Index on &cIndice To &cArqTrab 

return

