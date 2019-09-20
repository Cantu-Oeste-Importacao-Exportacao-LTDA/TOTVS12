#Include 'totvs.ch'
#include "topconn.ch"      
#include "tbiconn.ch"

/*/{Protheus.doc} SFPRO001
Rotina para enviar dados de produtos para o SalesForce

	
@author devair.tonon
@since 26/02/2015
@version 1.0
		
@param cTipoProd, character, (Descrição do parâmetro)


/*/
User Function SFPRO001 ( cCod,  lIsJob, cEmp, cFil , cTipoProd )
	
	local aDados	:= {}
	local cDescP	:= ""
	local cPathXML 	:= "\salesforce\xml\produto\"  
	local cNomArqXML:= ""
	local lSFGrvXml	:= .F.
	
	default cTipoProd := ""	
	default lIsJob	:= .F.
	
	if lIsJob                           
	   rpcsettype(3)
	   PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil //rpcsetenv(cEmp, cFil)	
	   CONOUT("SALESFORCE | " + TIME() +" | PREPARANDO AMBIENTE "+  cEmpAnt +"/" +cFilAnt  )	
	endif
	
	lSFGrvXml 	:= GetMv("MV_X_SFXML",.F.,.T.)
	           
	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	
	if SB1->(dbSeek(xFilial('SB1') + PADR(cCod, TAMSX3('B1_COD')[1])))		
				
		if !ExistDir ( cPathXML )
			
			FWMakeDir ( cPathXML, .f.)
			
		endif 
		
		cDescP := MSMM(SB1->B1_DESC_P,,,,3)
		
		aadd(aDados,{"Grupo_Principal__c"				,SUBSTR(SB1->B1_GRUPO,1,2)})
		aadd(aDados,{"Grupo__c"							,alltrim(SB1->B1_GRUPO)})
		aadd(aDados,{"Name"								,alltrim(u_RetTgHtm(SB1->B1_DESC))})
		aadd(aDados,{"Description"						,alltrim(u_RetTgHtm(cDescP))		})
		aadd(aDados,{"IsActive"							,iif (SB1->B1_MSBLQL=='1','0','1')})
		aadd(aDados,{"Peso_Liquido__c"					,SB1->B1_PESO})
		aadd(aDados,{"Peso_Bruto__c"					,SB1->B1_PESBRU})
		aadd(aDados,{"Unidade_Medida_Padrao__c"		,alltrim(SB1->B1_UM)})
		if !empty(SB1->B1_SEGUM)
			aadd(aDados,{"Unidade_Medida_Embalagem__c"	,alltrim(SB1->B1_SEGUM)})
			aadd(aDados,{"Fator_Conversao_Embalagem__c"	,SB1->B1_CONV})
		endif
		aadd(aDados,{"Controla_Lote__c"					, iif (SB1->B1_RASTRO $ "L/S",'1','0')})
		
		aadd(aDados,{"Codigo__c"							,alltrim(SB1->B1_COD)})  
		
		if !empty(cTipoProd)
		     
			aadd(aDados,{"RecordTypeId" ,cTipoProd})
				
		endif
		 
		if !isInCallStack('U_SFSB1')  
		
		
			cXML 	:= u_SFMonXML("Product2", "upsert",  aDados, "Codigo__c")  
			
			//grava XML do produto 
			if lSFGrvXml
				cNomArqXML:= ALLTRIM(SB1->B1_COD)+"_"+alltrim(CUSERNAME)+"_"+dtos(date())+time()
				cNomArqXML := strtran(cNomArqXML,":","")
			  	MemoWrite(cPathXML + cNomArqXML+"_PRO.xml", cXML  )
		   	endif			

			aRet	:= {.F.,"",""}
			
			if !empty(cXML)
				aRet	:= U_SFEnvXml(cXML )  
								
				if !lIsJob .and. aRet[1,1]
					Aviso("Integracao SalesForce","Ocorreu o seguinte erro:" + CRLF + "Erro: "+ aRet[1,3], {"Fechar"},3)				
				endif				
				
			endif
			
		endif
	
	endif
	
return aDados                                
       
       
user function SFSB1()

	local aCarga	:={}
  	local aGrupos	:={}
	local nBloco	:= 200
	  	
   //	aadd(aGrupos, {'0408', '012o0000000GkYA'})
   //	aadd(aGrupos, {'0416', '012o0000000GkYA'})
   /*	aadd(aGrupos, {'0901', '012o0000000GkY0'})
	aadd(aGrupos, {'0902', '012o0000000GkY0'})
	aadd(aGrupos, {'0903', '012o0000000GkY0'})
	aadd(aGrupos, {'0904', '012o0000000GkY0'})
	aadd(aGrupos, {'1001', '012o0000000GkY0'})
	aadd(aGrupos, {'1002', '012o0000000GkY0'})
	aadd(aGrupos, {'1003', '012o0000000GkY0'})
	aadd(aGrupos, {'1004', '012o0000000GkY0'})
	aadd(aGrupos, {'1005', '012o0000000GkY0'})
	aadd(aGrupos, {'1006', '012o0000000GkY0'})
	*/
	//aadd(aGrupos, {'1007', '012o0000000GkY0'})
	/*
	aadd(aGrupos, {'1008', '012o0000000GkY0'})
	aadd(aGrupos, {'1009', '012o0000000GkY0'})
	aadd(aGrupos, {'1010', '012o0000000GkY0'})
	aadd(aGrupos, {'1011', '012o0000000GkY0'})
	aadd(aGrupos, {'1012', '012o0000000GkY0'})
	
	aadd(aGrupos, {'1013', '012o0000000GkY0'})
	
	aadd(aGrupos, {'1014', '012o0000000GkY0'})
	aadd(aGrupos, {'1015', '012o0000000GkY0'})
	aadd(aGrupos, {'1016', '012o0000000GkY0'})
	aadd(aGrupos, {'1017', '012o0000000GkY0'})
	aadd(aGrupos, {'1018', '012o0000000GkY0'})
	aadd(aGrupos, {'1019', '012o0000000GkY0'})
	aadd(aGrupos, {'1020', '012o0000000GkY0'})
	aadd(aGrupos, {'1021', '012o0000000GkY0'})
	aadd(aGrupos, {'1101', '012o0000000GkY0'})
	aadd(aGrupos, {'1102', '012o0000000GkY0'})
	aadd(aGrupos, {'1103', '012o0000000GkY0'})
	aadd(aGrupos, {'1104', '012o0000000GkY0'})
	aadd(aGrupos, {'1105', '012o0000000GkY0'})
	aadd(aGrupos, {'1201', '012o0000000GkY0'})
	aadd(aGrupos, {'1202', '012o0000000GkY0'})
	aadd(aGrupos, {'1203', '012o0000000GkY0'})
	aadd(aGrupos, {'1301', '012o0000000GkY0'})
	aadd(aGrupos, {'1302', '012o0000000GkY0'})
	*/
	aadd(aGrupos, {'1303', '012o0000000GkY0'})
	/*aadd(aGrupos, {'1304', '012o0000000GkY0'})
	aadd(aGrupos, {'1305', '012o0000000GkY0'})
	aadd(aGrupos, {'1306', '012o0000000GkY0'})
	aadd(aGrupos, {'2001', '012o0000000GkY5'})
	aadd(aGrupos, {'2002', '012o0000000GkY5'})
	*/

  	rpcsettype(3)                   
  	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'
	
	cPathXML 		:= "\salesforce\xml\carga\"  
	cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
	
	cNomArqXML := strtran(cNomArqXML,":","")
    
	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif
	
	for nK:= 1 to len (aGrupos)
	    
	    dbSelectArea("SBM")
	    if SBM->(dbSeek(xFilial('SBM')+aGrupos[nK, 1 ])) 
	    
	        if SBM->(fieldpos("BM_X_ENVSF"))!=0 
	           reclock('SBM',.F.)
	           
	           SBM->BM_X_ENVSF :="S" 
	           
	           SBM->(msUnlock())
	        endif 
	    	
	    endif  
	                      
		cAlsSB1 := getnextalias()      
		beginsql alias cAlsSB1
		select R_E_C_N_O_ REC from sb1cmp 
		where 
		b1_grupo = %exp:aGrupos[nK,1]% 
		and %notdel%
		endsql  
		
		nI := 0
		dbselectArea("SB1")          
		do while (cAlsSB1)->(!EOF())
		    
		    SB1->(DBGOTO((cAlsSB1)->REC))
		    
	   		aadd(aCarga, U_SFPRO001(SB1->B1_COD, , , , aGrupos[nK, 2 ]))
	   		nI++
	   		
	   		if mod(nI, nBloco)==0
	   		
				cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
				
				cNomArqXML := strtran(cNomArqXML,":","")
			 
				 
				//monta XML do item da nota
				cXML 	:= u_SFMonXML("Product2", "upsert",  , "Codigo__c", aCarga)
				  	
			  	//grava XML da nota
		   		MemoWrite(cPathXML + cNomArqXML+"_PROD.xml", cXML  )
				
				aRet := {}
				
				aRet := U_SFEnvXml(cXML )  
				
				aCarga := {}
	   		
	   		endif
	   		
	   		    
	   		(cAlsSB1)->(!DBSKIP())
	   		
		enddo       
		(cAlsSB1)->(dbCloseArea())         
		
		if len(aCarga)>0   
		
			cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			
			cNomArqXML := strtran(cNomArqXML,":","")
		   
			 
			//monta XML do item da nota
			cXML 	:= u_SFMonXML("Product2", "upsert",  , "Codigo__c", aCarga)
			  	
		  	//grava XML da nota
	   		MemoWrite(cPathXML + cNomArqXML+"_PROD.xml", cXML  )
			
			aRet := {}
			
			aRet := U_SFEnvXml(cXML )    
			aCarga :={}    
			
		endif
    next nK
return

