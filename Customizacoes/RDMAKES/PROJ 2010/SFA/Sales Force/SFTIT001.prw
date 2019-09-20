#Include 'totvs.ch'
#include "topconn.ch"  
#include "tbiconn.ch" 
#INCLUDE "FILEIO.CH"                       

/*/{Protheus.doc} SFTIT001

Responsavel por enviar XML dos titulos para o Salesforce

@author devair.tonon
@since 23/03/2015
@version 1.0

@param aUmTit, array, Array para envio de varios titulos. Uso em rotina de envio em massa

/*/      

User Function SFTIT001(cPrefixo, cNum, cParcela, lIsJob, cEmp, cFil)  

	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	local aUmTit	:= {}
	local aRet		:= {.f.,"",""}
	local cXML		:= ""
	local cPathXML 	:= "\salesforce\xml\titulo\"  
	local cNomArqXML:= ""
	local lSFGrvXml := .F.
	local lSFCrdCli := .F.
	local aAreaSA1	:= {}
		                                        
		
		
	default cEmlProp    := ""
	default	lIsJob		:= .F. 
	
	if lIsJob
	   rpcsettype(3)
	   PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil //rpcsetenv(cEmp, cFil)	
	   CONOUT("SALESFORCE | " + TIME() +" | PREPARANDO AMBIENTE "+  cEmpAnt +"/" +cFilAnt  )
	   
	   //posiciona no titulo
	   dbSelectArea("SE1") 
	   SE1->(dbSetOrder(1))					
	   if SE1->(!dbSeek(cFilAnt + cPrefixo + cNum + cParcela ))
			return 	   
	   endif
	   
	   
	endif	                                                                                 
	
	dbSelectArea("SA1")
	
	aAreaSA1	:= SA1->(getArea())
	
	lSFGrvXml 	:= GetMv("MV_X_SFXML",.F.,.T.)
	cNomArqXML	:= ALLTRIM(SE1->E1_PREFIXO)+"_"+ALLTRIM(SE1->E1_NUM)+"_"+ALLTRIM(SE1->E1_PARCELA)+"_"+alltrim(CUSERNAME)+"_"+dtos(date())+time()
	lSFGrvXml 	:= GetMv("MV_X_SFXML",.F.,.T.)
	lSFCrdCli 	:= GetMv("MV_X_SFCRD",.F.,.T.)	
		
		
	cNomArqXML := strtran(cNomArqXML,":","")
	
	if !ExistDir ( cPathXML )
		
		FWMakeDir ( cPathXML, .f.)
		
	endif 
	
	if ALLTRIM(SE1->E1_TIPO) == "NF"
			
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		if SC5->(dbSeek( SE1->E1_FILIAL + SE1->E1_PEDIDO ))
			
			if SC5->(fieldpos("C5_X_ORIPD"))!=0 .and.  SC5->C5_X_ORIPD=='S'
				
				cChvNF := cEmpAnt + SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM + SE1->E1_PARCELA
				
				aadd(aUmTit, {"Codigo_ERP__c"		, cChvNF})
				aadd(aUmTit, {"Saldo__c" 			, SE1->E1_SALDO})
				aadd(aUmTit, {"Vencimento__c" 		, SE1->E1_VENCREA}) 
				
				if SE1->E1_SALDO == 0   
				
//					aadd(aUmTit, {"Inadimplente__c" 		, "false"}) 
					
				endif
				
				//SÓ EXECUTA SE A BAIXA FOR MANUAL FINA070
				if !isInCallStack("FINA205") .and. !isInCallStack("FINA200")
				
					cXML 	:= u_SFMonXML("Titulo__c", "upsert",aUmTit , "Codigo_ERP__c")
					
					//grava XML da nota    
					if lSFGrvXml
	   					MemoWrite(cPathXML + cNomArqXML+"_TIT.xml", cXML  )
		            endif
		            
					aRet := U_SFEnvXml(cXML )
					
					if aRet[1,1] 
						
						//Aviso("Integracao SalesForce","Ocorreu o seguinte erro:" + CRLF + "Erro: "+ aRet[1,3], {"Fechar"},3)
						
					endif
					
					//MONTA DADOS DE CREDITO DO CLIENTE	  
					if lSFCrdCli		
						dbSelectArea("SA1")   
						SA1->(dbSetOrder(1))
						SA1->(dbSeek(xFilial('SA1')+SE1->(E1_CLIENTE+E1_LOJA)))
						
						//atualiza dados de credito do cliente, após integrado o pedido.
						U_SFCLICRE({SA1->(RECNO())}, lSFGrvXml)
						 
					endif
				endif
			endif
		endif
	endif
	
	
	RestArea(aAreaSA1)
	
	ErrorBlock(oError)
	
Return aUmTit
             


user function SFSE1( dDtIni, dDtFim, cConsidera, lSFGrvXml)
    local cEntidade := "Titulo__c"
    local cExtId	:= "Codigo_ERP__c"            
    
	cPathXML 		:= "\salesforce\xml\carga\tit\" 
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif	       
	
  	private nBloco := 200	           
   	
   	aCarga	:= {}
 	aUmTit	:= {} 
          
	
   	default lSFGrvXml := GetMv("MV_X_SFXML",.F.,.T.)
	
	cQuery:=" SELECT E1_FILIAL, E1_PREFIXO, E1_NUM , E1_PARCELA, E1_SALDO, E1_VALOR, E1_VENCTO, E1_CLIENTE, E1_LOJA, E1_PEDIDO,E1_VENCREA FROM "+ RETSQLNAME("SE1")
	cQuery+=" WHERE E1_TIPO='NF'    "   
	cQuery+=" AND D_E_L_E_T_<>'*'      "  
	if cConsidera == "B"
	         
		cQuery+=" AND E1_BAIXA BETWEEN '"+DTOS(CTOD(dDtIni,'dd/mm/yyyy'))+"' AND '"+DTOS(CTOD(dDtFim,'dd/mm/yyyy'))+"'" 
	
	elseif cConsidera == "V"
		
		cQuery+=" AND E1_VENCTO BETWEEN '"+DTOS(CTOD(dDtIni,'dd/mm/yyyy'))+"' AND '"+DTOS(CTOD(dDtFim,'dd/mm/yyyy'))+"'" 	

	elseif cConsidera == "E"
		
		cQuery+=" AND E1_EMISSAO BETWEEN '"+DTOS(CTOD(dDtIni,'dd/mm/yyyy'))+"' AND '"+DTOS(CTOD(dDtFim,'dd/mm/yyyy'))+"'" 			                                                                                                                    

	elseif cConsidera == "C"
		
		cQuery+=" AND E1_EMIS1 BETWEEN '"+DTOS(CTOD(dDtIni,'dd/mm/yyyy'))+"' AND '"+DTOS(CTOD(dDtFim,'dd/mm/yyyy'))+"'" 			                                                                                                                    
		
	endif
	
	cQuery+=" ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM , E1_PARCELA "
                                                            

	if select("TEMP")!=0
		TEMP->(dbCloseArea())
	endif
	
	TCQUERY cQuery NEW ALIAS "TEMP" 
    
    CONOUT(PROCNAME() + "|" + TIME() + "|INICIO DE ROTINA DE ATUALIZACAO DE TITULOS PARA SALESFORCE" ) 

                   
	TEMP->(dbGoTop())
	
    while TEMP->(!EOF())
			
    	aUmTit	:= {}
    		
    	cChvNF := cEmpAnt + TEMP->E1_FILIAL + TEMP->E1_PREFIXO + TEMP->E1_NUM + TEMP->E1_PARCELA
				
		aadd(aUmTit, {"Codigo_ERP__c"		, cChvNF})
		aadd(aUmTit, {"Saldo__c" 			, TEMP->E1_SALDO})
		aadd(aUmTit, {"Vencimento__c" 		, STOD(TEMP->E1_VENCREA)})
       
    	if TEMP->E1_SALDO == 0   
				
	 //		aadd(aUmTit, {"Inadimplente__c" 		, "false"}) 
			
		endif
		
    	aadd(aCarga, aUmTit) 
    	          
   		if mod(len(aCarga), nBloco) == 0  .and. len(aCarga)>0
   		    
   			CONOUT(PROCNAME() + "|" + TIME() + "|ENVIANDO DADOS DE TITULOS PARA SALESFORCE ")
   		
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
		   	sleep(10000)
   		endif
	    
	    TEMP->(dbSkip())
	     
	enddo      
	
	if len(aCarga)> 0
   		
   		CONOUT(PROCNAME() + "|" + TIME() + "|ENVIANDO DADOS DE TITULOS PARA SALESFORCE ")
   		
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
  	
  	TEMP->(dbCloseArea())
  	CONOUT(PROCNAME() + "|" + TIME() + "|TERMINO DE ROTINA DE ATUALIZACAO DE TITULOS PARA SALESFORCE" ) 
return
          


/*************************************************************************************************
 TELA DE INTEGRAÇÃO MANUAL DE BAIXA DE TITULO CHAMADA SMARTCLIENT                
 
 aParam[1] = Empresa
 aParam[2] = Filial
 aParam[3] = Considera data {B = Baixa, V = Vencimento, E = Emissao, C = Contabilizacao }
 aParam[4] = Grava XML na pasta \salesforce\ {.T. = Grava, .F. = Nao grava}
 
*************************************************************************************************/
User Function SFINTSE1(aParam)                       
	Local oGetData1
	Local cGetData1:= space(8)
	Local oGetData2
	Local cGetData2:= space(8)
	Local oGetEmp
	Local cGetEmp := Space(2)
	Local oGetFil
	Local cGetFil := Space(2)
	Local oSay1
	Local oSButton1
	Local oSButton2    
	Local nOpc := 0 
	Local aItems:= {'B=Baixa','V=Vencimento','E=Emissao','C=Contabilizacao'}  
	local cComboBo1:="B"
	local oComboBo1 
	private lGrvXml :=.f.
	
	Static oDlg 
	
	if Valtype(aParam) == "A"  
	
		rpcsettype(3)
		PREPARE ENVIRONMENT EMPRESA  aParam[1] FILIAL aParam[2]  
		
		cGetData1 := DTOC(dDataBase)
		cGetData2 := DTOC(dDataBase)
		
		U_SFSE1( cGetData1, cGetData2, aParam[3], aParam[4] )	

	else
	
	    DEFINE MSDIALOG oDlg TITLE "Baixa de Titulo" FROM 000, 000  TO 300, 300 COLORS 0, 16777215 PIXEL
	
	    @ 026, 076 MSGET oGetEmp VAR cGetEmp SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 041, 076 MSGET oGetFil VAR cGetFil SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 057, 076 MSGET oGetData1 VAR cGetData1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 picture "99/99/99" PIXEL
		@ 072, 076 MSGET oGetData2 VAR cGetData2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 picture "99/99/99" PIXEL  
		@ 087, 076 MSCOMBOBOX oComboBo1 VAR cComboBo1 ITEMS aItems SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  
		
		oCheck1 := TCheckBox():New(102,076, 'Gravar XML',{|u| If(PCount()>0,lGrvXml:=u,lGrvXml)},oDlg,100,210,,,,,,,,.T.,,,) 

	    DEFINE SBUTTON oSButton1 FROM 117, 070 TYPE 01 OF oDlg ACTION (nOpc:=1,oDlg:End())  ENABLE 
	    DEFINE SBUTTON oSButton2 FROM 117, 109 TYPE 02 OF oDlg ACTION oDlg:End() ENABLE
	    @ 026, 024 SAY oSay1 PROMPT "Empresa" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
   		@ 041, 024 SAY oSay2 PROMPT "Filial " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 057, 024 SAY oSay3 PROMPT "Data De?" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 072, 024 SAY oSay4 PROMPT "Data Ate?" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 087, 024 SAY oSay4 PROMPT "Cons. Data" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		
		
	  ACTIVATE MSDIALOG oDlg CENTERED
	
		if nOpc == 1
			RESET ENVIRONMENT
			rpcsettype(3)
			PREPARE ENVIRONMENT EMPRESA  cGetEmp FILIAL cGetFil 
		 
			U_SFSE1(cGetData1, cGetData2, cComboBo1, lGrvXml )	
		    RESET ENVIRONMENT
		endif
    
    endif
    
Return     
                    