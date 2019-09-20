#INCLUDE "PROTHEUS.CH"

User Function F200FIM() 
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
	local cEntidade := "Titulo__c"
    local cExtId	:= "Codigo_ERP__c"     
    local aCarga	:= {} 
    local nBloco 	:= 200
	local cPathXML	:= "\salesforce\xml\titulo\bxcnab\" 
  	local cNomArqXML:=""
  	local aRet		:= {}
  	local lSFGrvXml := GetMv("MV_X_SFXML",.F.,.T.)
  	local aAreaSE1	:= SE1->(getArea())
  	local aAreaSA1	:= SA1->(getArea())
  	local aCliPJ	:={}
 	local aCliPF	:={}
  	local lSFCrdCli := GetMv("MV_X_SFCRD",.F.,.T.)
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif	       
	
 
    
    //ESTE ALIAS TEMPORARIO FOI CRIADO NO PE F200TIT    
    if SuperGetMv('MV_X_INTSF', .F. ,.F.)
		if select ("SFBXTIT")!=0 
		    
			dbSelectArea("SE1")
			SE1->(dbSetOrder(1))
		
			dbSelectArea("SFBXTIT")    
			SFBXTIT->(dbGoTop())
			
			dbSelectArea("SA1")
			SA1->(dbSetOrder(1))
			    		
			do while SFBXTIT->(!eof())
				
				if SE1->(dbseek(SFBXTIT->(FILIAL+PREFIXO+NUM+PARCELA+TIPO)))    
			       
			    	aUmTit := {}
			    	aUmTit :=  U_SFTIT001()
			    	
			    	if len(aUmTit)>0
			    	
						AADD(aCarga, aUmTit)														                    
						
						if lSFCrdCli
											
					    	SA1->(dbSeek(xFilial("SA1")+SE1->(E1_CLIENTE+E1_LOJA)))			    	
					    	
					    	if SA1->A1_PESSOA=="J" .and. ascan(aCliPJ, {|x| x==SA1->(RECNO()) })==0
						    	
						    	aadd(aCliPJ, SA1->(RECNO()))    
						    
						    elseif SA1->A1_PESSOA=="F" .and. ascan(aCliPF, {|x| x==SA1->(RECNO()) })==0
						    	
						    	aadd(aCliPF, SA1->(RECNO()))    
						    	
						    endif
					    
					    endif
					    			    	
				    endif
				    
				    if mod(len(aCarga), nBloco) == 0
			   		
			 	   		cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
					
						cNomArqXML := strtran(cNomArqXML,":","")
					    	 
						//monta XML
						cXML 	:= u_SFMonXML(cEntidade, "upsert",  , cExtId, aCarga) 
						  	
					  	//grava XML 
					  	if lSFGrvXml
				   			MemoWrite(cPathXML + cNomArqXML+"_"+cEmpAnt+"_"+cEntidade+".xml", cXML  )
						endif
						
						aRet := {}
						
						aRet := U_SFEnvXml(cXML )      
					   	
					   	aCarga := {}    
					   	
			   		endif
			        		    	
			    endif
			     
				SFBXTIT->(dbSkip())
			
			enddo 
			
			if len(aCarga)> 0
	   		
		 	    cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			
				cNomArqXML := strtran(cNomArqXML,":","")
			    	 
				//monta XML
				cXML 	:= u_SFMonXML(cEntidade, "upsert",  , cExtId, aCarga) 
				  	
		  		//grava XML 
			  	if lSFGrvXml
		   			MemoWrite(cPathXML + cNomArqXML+"_"+cEmpAnt+"_"+cEntidade+".xml", cXML  )
				endif
				
				aRet := {}
				
				aRet := U_SFEnvXml(cXML )      
			   	
			   	aCarga := {}           
			   	
		  	endif 
		  	
		  	SFBXTIT->(dbCloseArea())
	        
			if len(aCliPJ)>0
			     
				U_SFCLICRE(aCliPJ, lSFGrvXml)
				
			endif
			
			if len(aCliPF)>0
			     
				U_SFCLICRE(aCliPF, lSFGrvXml)
				
			endif
	
		endif
	endif
	RestArea(aAreaSE1)
	RestArea(aAreaSA1)
	
	ErrorBlock(oError) 
	
Return 

