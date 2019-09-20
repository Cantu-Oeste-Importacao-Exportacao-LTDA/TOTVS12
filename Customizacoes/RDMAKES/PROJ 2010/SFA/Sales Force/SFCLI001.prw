#Include 'Protheus.ch'
#include "topconn.ch" 
#include "tbiconn.ch"
#INCLUDE "FILEIO.CH"      
#INCLUDE "xmlxfun.CH"

/*/{Protheus.doc} SFCLI001

Envida dados do cliente para Salesforce

@author devair.tonon
@since 03/02/2015
@version 1.0

/*/

user function SFCLI001(cCod, cLoja, lIsJob, cEmp, cFil, cEmlProp) 
	local oError 		:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})

	local aDados		:= {}
	local aRetSF 		:= {}
	local cExFldNam 	:= "" 
	local cPathXML 		:= "\salesforce\xml\cliente\"  
	local cNomArqXML	:= ""
	local lSFGrvXml 	:= .F.	
	local aUF			:= {} 
	
	default cEmlProp    := ""
	default	lIsJob		:= .F. 
	
	if lIsJob
	   rpcsettype(3)
	   PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil //rpcsetenv(cEmp, cFil)	
	   CONOUT("SALESFORCE | " + TIME() +" | PREPARANDO AMBIENTE "+  cEmpAnt +"/" +cFilAnt  )					
	endif	                                                                                 
	
	lSFGrvXml 	:= GetMv("MV_X_SFXML",.F.,.T.)
		
	dbSelectArea('SA1')
	SA1->(dbSetOrder(1))
	if SA1->(dbSeek(xFilial('SA1') + PADR(cCod,TAMSX3('A1_COD')[1]) + PADR(cLoja,TAMSX3('A1_LOJA')[1])))
		
	
		cNomArqXML:= ALLTRIM(SA1->A1_COD)+"_"+ALLTRIM(SA1->A1_LOJA)+"_"+alltrim(CUSERNAME)+"_"+dtos(date())+time()
		cNomArqXML := strtran(cNomArqXML,":","")		
		
		if !ExistDir ( cPathXML )
			
			FWMakeDir ( cPathXML, .f.)
			
		endif  
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//?reenchimento do Array de UF                                            ?
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		aadd(aUF,{"RO","11"})
		aadd(aUF,{"AC","12"})
		aadd(aUF,{"AM","13"})
		aadd(aUF,{"RR","14"})
		aadd(aUF,{"PA","15"})
		aadd(aUF,{"AP","16"})
		aadd(aUF,{"TO","17"})
		aadd(aUF,{"MA","21"})
		aadd(aUF,{"PI","22"})
		aadd(aUF,{"CE","23"})
		aadd(aUF,{"RN","24"})
		aadd(aUF,{"PB","25"})
		aadd(aUF,{"PE","26"})
		aadd(aUF,{"AL","27"})
		aadd(aUF,{"MG","31"})
		aadd(aUF,{"ES","32"})
		aadd(aUF,{"RJ","33"})
		aadd(aUF,{"SP","35"})
		aadd(aUF,{"PR","41"})
		aadd(aUF,{"SC","42"})
		aadd(aUF,{"RS","43"})
		aadd(aUF,{"MS","50"})
		aadd(aUF,{"MT","51"})
		aadd(aUF,{"GO","52"})
		aadd(aUF,{"DF","53"})
		aadd(aUF,{"SE","28"})
		aadd(aUF,{"BA","29"})
		aadd(aUF,{"EX","99"})				
		
		aadd(aDados, {'Codigo_ERP__c'			 , SA1->A1_COD + SA1->A1_LOJA})
			
		aadd(aDados, {'Bairro_Cobranca__c'		 , _NoTags(upper(SA1->A1_BAIRRO))})
	    
		if LEN(ALLTRIM(SA1->A1_CEP))==8
			aadd(aDados, {'CEP_Cobranca__c'			 ,  Transform(SA1->A1_CEP,"@R 99999-999")})
		endif
		
		if SA1->A1_PESSOA=="F"
			
			aadd(aDados, {'RecordTypeId', '012o0000000Gkiy'})
			cExFldNam := "Codigo_ERP__c"
			aadd(aDados, {'CPF__pc'						 , Transform(Alltrim(SA1->A1_CGC),"@R 999.999.999-99")})
			
			//if !empty(SA1->A1_EMAIL)
			//  	aadd(aDados, {'PersonEmail'					 , SA1->A1_EMAIL})
			//endif
			  
			nPosSpace := AT(' ', SA1->A1_NOME)
			 	
			
			aadd(aDados, {'FirstName'						 , _NoTags(substr(SA1->A1_NOME, 1 ,nPosSpace))})
			
			aadd(aDados, {'LastName'						 , _NoTags(substr(SA1->A1_NOME, nPosSpace+1))})
			
		else
			
			cExFldNam	:= 'Codigo_ERP__c'     
			if !empty(SA1->A1_CGC)
				aadd(aDados, {'CNPJ__c'  , Transform(Alltrim(SA1->A1_CGC),"@R 99.999.999/9999-99")})
			endif
			
			aadd(aDados, {'Name'		 , _NoTags(SA1->A1_NOME)})
			
			
			dbSelectArea("SA4")
			SA4->(dbSetOrder(3))
			
			if SA4->(dbSeek(xFilial("SA4")+SA1->A1_CGC))
				
				if SA4->A4_EST!="EX"
					aadd(aDados, {'Codigo_Transportadora_ERP__c' , SA4->A4_COD})
					aadd(aDados, {'Transportadora__c'	     	 , 'true'})
			    endif
			endif
			
			SA4->(dbCloseArea())
			
		endif
		
		
		
		nCodUF	:= ascan(aUF, {|x| x[1]==SA1->A1_EST })
		
		if nCodUF>0
			aadd(aDados, {'Codigo_Municipio_Cobranca__c', aUF[nCodUF,2]+SA1->A1_COD_MUN})
		endif
		
		if empty(SA1->A1_DDI)
			
			cTelefone := "+55"
		else
			cTelefone := "+"+ cValToChar(val(SA1->A1_DDI))
			
		endif
		
		cTelefone += " " + ALLTRIM(str(val(SA1->A1_DDD)))
		
		cTelefone += " " + ALLTRIM(strtran(SA1->A1_TEL,"-"," "))
		
		aadd(aDados, {'Phone'		 , cTelefone })
		
		
		aadd(aDados, {'Complemento_Cobranca__c'	 , _NoTags(UPPER(SA1->A1_COMPLEM))})
		
		
		aadd(aDados, {'Rua_Cobranca__c'				 , _NoTags(UPPER(SA1->A1_END))})
		    
		cNumCob	:= "0" 
	   
		 
		if (nPosVirg:= AT(',', ALLTRIM(SA1->A1_END))) != 0 
		 	
		 	cNumCob := ""
		 	 	 	 
			for nI:=nPosVirg+1 to len(alltrim(SA1->A1_END))
			            
	            if isDigit(alltrim(substr(SA1->A1_END, nI, 1 )))
	     		
		    		cNumCob	+= substr(SA1->A1_END, nI,1 )
		    	
			    	if len(cNumCob)>5
			    	    
			    	    cNumCob := "0"
			    	    
			    		exit
			    		
			    	endif
			    	 
		    	endif
		    	
		    next nI	
		
		endif
		
		if empty(cNumCob)
		
			cNumCob :="0"
		
		endif
			
		aadd(aDados, {'Numero_Cobranca__c'		 , cNumCob })	
		
		aadd(aDados, {'Estado_Cobranca__c' 		 , SA1->A1_EST})
		
		aadd(aDados, {'Cidade_Cobranca__c' 		 , UPPER(SA1->A1_MUN)})
		
		aadd(aDados, {'Inscricao_Estadual__c' 		 , SA1->A1_INSCR})
		
		aadd(aDados, {'Limite_Credito__c'			 , SA1->A1_LC})
		
		aadd(aDados, {'Nome_Fantasia__c'			 , _NoTags(SA1->A1_NREDUZ)})
		
		
		if !empty(SA1->A1_PAIS)
			dbSelectArea("SYA")
			if SYA->(dbSeek(xFilial("SYA")+SA1->A1_PAIS))
				aadd(aDados, {'Pais_Cobranca__c'				 , 	SYA->YA_DESCR })//descricao do pais
			endif
		endif
		
		
		//aadd(aDados, {'Quantidade_Veiculos_Pesados__c', 	SA1->A1_QTDVEI1})
		
		
	   	//aadd(aDados, {'Quantidade_veiculos_Leves_comprovada__c'	, 	SA1->A1_QTDVEIC})
			
		
		
		if empty(SA1->A1_VENCLC)
		
			aadd(aDados, {'urn:fieldsToNull'		 , 'Data_Limite_Credito__c'})
		
		else
		
			aadd(aDados, {'Data_Limite_Credito__c'		 , SA1->A1_VENCLC})
			
		endif  
		
		if empty(SA1->A1_DTCADAS)
		
			aadd(aDados, {'urn:fieldsToNull'		 , 'Data_Cadastro_Empresa__c'})
		
		else
		
			aadd(aDados, {'Data_Cadastro_Empresa__c' , SA1->A1_DTCADAS})
			
		endif
		
		
		aadd(aDados, {'E_mail_NFe__c'				 , lower(_NoTags(SA1->A1_X_MAILN))})
		
		
		if empty(SA1->A1_DTNASC)
		
			aadd(aDados, {'urn:fieldsToNull'		 , 'Data_Abertura_Empresa__c'})
		
		else
			
			aadd(aDados, {'Data_Abertura_Empresa__c', SA1->A1_DTNASC})
			
		endif
			
		if empty(SA1->A1_COND)
		
			aadd(aDados, {'urn:fieldsToNull'		 , 'Condicao_Pagamento__c'})
		
		else
			
			aadd(aDados, {'Condicao_Pagamento__r','<Codigo_ERP__c>'+SA1->A1_COND+'</Codigo_ERP__c>'})
			
		endif
		
		aadd(aDados,{'Forma_Pagamento__c'    ,	SA1->A1_FORMPAG})
		
		aadd(aDados,{'Risco__c'			  ,	SA1->A1_RISCO})
		
		aadd(aDados,{'Limite_Sugerido__c'    ,	SA1->A1_LC})
		
		aadd(aDados,{'Capital_Social__c'     ,	SA1->A1_CAPTSOC})
		
		aadd(aDados,{'Observacao_Cobranca__c',	_NoTags(SA1->A1_X_OBCOB)})
		
		aadd(aDados,{'Observacao_Cadastro__c',	_NoTags(SA1->A1_X_OBCAD)})
		
		aadd(aDados,{'Grupo_Tributario__c'   ,	SA1->A1_GRPTRIB})
		
		aadd(aDados,{'Contribuinte__c',	iif(SA1->A1_CONTRIB=='1','1','0')})
		
		aadd(aDados,{'Optante_pelo_Simples__c',	iif(SA1->A1_SIMPNAC=='1','1','0')})
		
		aadd(aDados,{'Enviar_Para_Serasa__c',	iif(SA1->A1_X_SERAS=='S','1','0')})
		
		//aadd(aDados,{'Status__c',	iif(SA1->A1_MSBLQL=='1','Inativo','Ativo') }) 
		
		aadd(aDados,{'Bloqueado__c',	iif(SA1->A1_MSBLQL=='1','true','false') })
		
		aadd(aDados,{"Maior_Compra__c"		, SA1->A1_MCOMPRA})  
			
		if empty(SA1->A1_ULTCOM)
			aadd(aDados, {'urn:fieldsToNull'		 , 'Ultima_Compra__c'})
		else
			aadd(aDados,{"Ultima_Compra__c"		, SA1->A1_ULTCOM  })	
		endif
	
		aadd(aDados,{"Saldo_Aberto_em_Titulos__c", SA1->A1_SALDUP})
		aadd(aDados,{"Pagamentos_Atrasados__c", SA1->A1_PAGATR})
		aadd(aDados,{"Titulos_Atrasados__c" , SA1->A1_ATR})
		aadd(aDados,{"Maior_Atraso__c"	 	, SA1->A1_MATR})
		aadd(aDados,{"Media_Atraso__c"		, SA1->A1_METR})
		aadd(aDados,{"Valor_Acumulado__c"	, SA1->A1_VACUM})
		aadd(aDados,{"Numero_Pagamentos__c"	, SA1->A1_NROPAG})
		aadd(aDados,{"Limite_Disponivel__c"	, SA1->A1_LC - SA1->(A1_SALDUP+A1_SALPEDL)      }) 
		
		
		if !empty(SA1->A1_TIPO)
			
			cTipo	:= ""
			
			if SA1->A1_TIPO=='F'
				cTipo := 'Consumo'
			elseif SA1->A1_TIPO=='R'
				cTipo := 'Revenda' 
			elseif SA1->A1_TIPO=='S'
				cTipo := 'Solidario'
			elseif SA1->A1_TIPO=='X'
				cTipo := 'Exportacao'
			elseif SA1->A1_TIPO=='L'
				cTipo := 'Prod Rural'
		    endif
		    				
			aadd(aDados,{'Type'   	,	cTipo})       
			
		endif
		
		
		aadd(aDados,{"Rating"	, "Standard"})
		
		if isInCallStack("U_M030INC") .OR. isInCallStack("U_SFSA1") 
			
			if temNota('70')            
				aadd(aDados,{'Cliente_Congelados__c', 'true'})
			endif
			
			if temNota('60')
				aadd(aDados,{'Cliente_Level__c', 'true'})
			endif
			
			if temNota('30') .OR. temNota('31') 
				aadd(aDados,{'Cliente_Pneus__c', 'true'})    
			endif  
			
			
			if empty(cEmlProp)
				dbSelectArea("SA3")
				if SA3->(dbSeek(xFilial('SA3')+ SA1->A1_VEND  ))
					    
					if !empty(SA3->A3_EMAIL)
					
						nPosVirg:= AT(';', ALLTRIM(SA3->A3_EMAIL))
					    
						if nPosVirg>0
						
							cEmlProp := alltrim(SUBSTR(SA3->A3_EMAIL, 1 , nPosVirg-1))  
						
						else
						
							cEmlProp := ALLTRIM(SA3->A3_EMAIL)
							
						endif
						
						
					endif   		
				endif       
			endif
			
			if !empty(cEmlProp)
				aadd(aDados,{'Owner'		, '<Email>'+ cEmlProp + '</Email>'})
			endif
			
		endif
			
		//ALEX CAMPOS PARA CARGA
		aadd(aDados,{'Cobranca_Externa__c',	iif(SA1->A1_X_COBEX=='S','1','0')})      
		
		if !empty(SA1->A1_GRPVEN)	    
			dbSelectArea('ACY')		
			if ACY->(dbSeek(xFilial('ACY')+SA1->A1_GRPVEN))		
				aadd(aDados,{'Grupo_Clientes__c',	ALLTRIM(ACY->ACY_DESCRI)+" ("+ACY->ACY_GRPVEN+")"}) 
			endif				   
		else
			aadd(aDados, {'urn:fieldsToNull'	, 'Grupo_Clientes__c'})	
		endif
		
		if !empty(SA1->A1_X_SCOBR)  	
			aadd(aDados, {'Situacao_Cobranca__c'	, DesX3Cbo('A1_X_SCOBR', SA1->A1_X_SCOBR)+" ("+SA1->A1_X_SCOBR+")"})		    
		else
	   		aadd(aDados, {'urn:fieldsToNull'	, 'Situacao_Cobranca__c'})	
		endif 
		
		if !empty(SA1->A1_FAX) 	          	                                                    
			aadd(aDados, {'Fax'	 ,  ALLTRIM(strtran(SA1->A1_FAX,"-"," "))})
		else
			aadd(aDados, {'urn:fieldsToNull'		 , 'Fax'})		
		endif
		
		/*
		if !empty(SA1->A1_X_GRLEV)				
			aadd(aDados,{'Tipo_Loja__c',  DesX3Cbo('A1_X_GRLEV', SA1->A1_X_GRLEV+" ("+SA1->A1_X_GRLEV+")")}) 		   
		else
			aadd(aDados, {'urn:fieldsToNull'		 , 'Tipo_Loja__c'})	
		endif
		
		if !empty(SA1->A1_X_CLPAI) .and. !empty(SA1->A1_X_LJPAI)			
			aadd(aDados,{'Parent','<Codigo_ERP__c>'+SA1->A1_X_CLPAI+SA1->A1_X_LJPAI+'</Codigo_ERP__c>'})		
		else		
			aadd(aDados, {'urn:fieldsToNull'		 , 'Parent'})		
		endif	
		*/          	                                                    
	
		
		
	    //para carga de clientes
	    
		if isInCallStack("U_SFSA1")   
			 
			if SA1->A1_TIPO == 'F'
		
				aadd(aDados,{'Destinacao_Padrao__c', 'Consumo' })
				
			elseif SA1->A1_TIPO =='S' 
				
				//CLIENTE CONSUMO PNEUS
				if ALLTRIM(SA1->A1_GRPTRIB) $ '102/105/107'	
		
					aadd(aDados,{'Destinacao_Padrao__c', 'Consumo' })
				
				//CLIENTE REVENDA PNEUS E LEVEL
				elseif  empty(SA1->A1_GRPTRIB) .OR. ALLTRIM(SA1->A1_GRPTRIB) $ '001'
				 			
					aadd(aDados,{'Destinacao_Padrao__c', 'Revenda' })
		 
				endif
				
			elseif SA1->A1_TIPO =='R'
				
				//CLIENTE INSUMO PNEUS
				if  ALLTRIM(SA1->A1_GRPTRIB) $ '108'
				   
					aadd(aDados,{'Destinacao_Padrao__c', 'Insumo' })
					
				//CLIENTE REVENDA LEVEL                                       
				elseif  empty(SA1->A1_GRPTRIB) .OR. ALLTRIM(SA1->A1_GRPTRIB) $ '001'
					
					aadd(aDados,{'Destinacao_Padrao__c', 'Consumo' })
					
				else
				
					aadd(aDados,{'Destinacao_Padrao__c', 'Revenda' })
					
				endif
					
			endif 
			
		endif         		            
		
	 	//para carga de clientes		
		if !isInCallStack('U_SFSA1')
			cXML 	:= u_SFMonXML("Account", "upsert",  aDados, cExFldNam)
			
			//grava XML			
			if lSFGrvXml
				MemoWrite(cPathXML + cNomArqXML+"_CLI.xml", cXML  )
			endif
	
			if !empty(cXML)          

				CONOUT("SALESFORCE | " + TIME() +" | ENVIANDO XML DE INTEGRACAO  "+ SA1->A1_COD+"-"+SA1->A1_LOJA  )					
				aRet	:= U_SFEnvXml(cXML )  
				
				if !lIsJob .and. aRet[1,1]
					Aviso("Integracao SalesForce","Ocorreu o seguinte erro:" + CRLF + "Erro: "+ aRet[1,3], {"Fechar"},3)				
				endif			
												
			endif
			
		endif
	
	endif
	
	ErrorBlock(oError)
return aDados 
              

//CHAMADA PARA ATUALIZAR CLIENTE NO SALESFORCE PESSOA FISICA

user function SFBLQCLI(aParam)  
	local oGetData1
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
	private aItems:= {'J','F'}  
	private lGrvXml := .F.    // Usando New 
	private cPessoa	:= aItems[1] 
	Private cCadastro  := "Atualizacao de clientes no Salesforce"	 
	
	Static oDlg 
	
	if Valtype(aParam) == "A"  
	
		rpcsettype(3)
		PREPARE ENVIRONMENT EMPRESA aParam[1] FILIAL aParam[2]
		BatchProcess(cCadastro, cCadastro , "SFSA1BLQ" , { || SFSA1BLQ( aParam[3], aParam[4]) } , { || .F. } )
		RESET ENVIRONMENT
	else

	  	DEFINE MSDIALOG oDlg TITLE "Clientes - Bloqueios" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL
	
	    @ 026, 024 SAY oSay1 PROMPT "Pessoa" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
			   
	  	oCombo1 := TComboBox():New(026,024,{|u|if(PCount()>0,cPessoa:=u,cPessoa)},; 
	    aItems,100,20,oDlg,,{||},,,,.T.,,,,,,,,,'cPessoa')
	        
		oCheck1 := TCheckBox():New(041,076, 'Gravar XML',{|u| If(PCount()>0,lGrvXml:=u,lGrvXml)},oDlg,100,210,,,,,,,,.T.,,,) 
	
	    DEFINE SBUTTON oSButton1 FROM 098, 070 TYPE 01 OF oDlg ACTION (nOpc:=1,oDlg:End())  ENABLE 
	    DEFINE SBUTTON oSButton2 FROM 098, 109 TYPE 02 OF oDlg ACTION oDlg:End() ENABLE
	
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		if nOpc == 1
		    rpcsettype(3)
		    PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'
			SFSA1BLQ(cPessoa, lGrvXml)
		    RESET ENVIRONMENT
		endif
    endif
    
return

//USADO NA CHAMADA MANUAL
static function SFSA1BLQ(cPessoa, lGrvXml)  
  	local aCli	:= {}
  	local nBloco 	:= 200	             		
	local _nJ:=1
	local _nTotal :=0
  	
 	if !LockByName(procname()+cPessoa,.T.,.F.)  	
	    conout(procname()+cPessoa+ " SEMAFORO JA EM EXECUCAO") 
		return
	endif    
  	
  				
	cAlsSA1	:= getNextAlias()
   	beginsql alias cAlsSA1    
	select r_e_c_n_o_ REC from sa1cmp where a1_x_envsf='S' and d_e_l_e_t_<>'*' and a1_pessoa=%exp:cPessoa%                                                                                      
    endsql     	
 
    (cAlsSA1)->(dbgotop())                         
    (cAlsSA1)->(DBEVal ({||_nTotal++},,{||(cAlsSA1)->(!eof())}))
    (cAlsSA1)->(dbgotop())  
    
    CONOUT(PROCNAME() + "|" + TIME() + "|INICIO DE ROTINA DE ATUALIZACAO DE CLIENTES PARA SALESFORCE" ) 
    CONOUT(PROCNAME() + "|" + TIME() + "|TOTAL DE REGISTROS " + CVALTOCHAR(_nTotal)) 
    	
	do while (cAlsSA1)->(!EOF())

		aadd(aCli, (cAlsSA1)->REC) 				

		if mod(_nJ, nBloco)==0  .or. _nJ==_nTotal		
			U_SFCLICRE(aCli, lGrvXml)		
			aCli := {}          			
		    CONOUT(PROCNAME() + "|" + TIME() + "|QUANTIDADE ATUAL " + CVALTOCHAR(_nJ)+"/"+CVALTOCHAR(_nTotal)) 
			sleep(10000)
		endif
		
   	  	(cAlsSA1)->(DBSKIP())
   	  	
   	  	_nJ++   		
	enddo       
	(cAlsSA1)->(dbCloseArea())
	
	UnLockByName(procname()+cPessoa,.T.,.F.)  		
	CONOUT(PROCNAME() + "|" + TIME() + "|TERMINO DE ROTINA DE ATUALIZACAO DE CLIENTES PARA SALESFORCE" ) 
		 			
return   

//ENVIA DADOS ATUALIZADOS DE CREDITO DE CLIENTE
user function SFCLICRE(aCli, lGrvXml)

    local aCarga	:={}  	
  	local nBloco 	:= 200	             		
	local _nI:=1
	  	
  	default lGrvXml	:= GetMv("MV_X_SFXML",.F.,.T.)
   	
  	cPathXML 		:= "\salesforce\xml\cliente\atucrd\" 
  	
  	if !ExistDir ( cPathXML )	
		FWMakeDir ( cPathXML, .f.)		
	endif  
	
	dbSelectArea('SA1')	
	while _nI <= len(aCLi)  .AND. len(aCli) >0
	
	    SA1->(DBGOTO(aCli[_nI]))
			
		aUmCli :={}
		
		aadd(aUmCli, {'Codigo_ERP__c', SA1->A1_COD + SA1->A1_LOJA})
		aadd(aUmCli, {'Bloqueado__c' ,	iif(SA1->A1_MSBLQL=='1','true','false') })    					
		aadd(aUmCli, {"Risco__c"				, SA1->A1_RISCO})   
		aadd(aUmCli, {"Limite_Credito__c"	, SA1->A1_LC})
		aadd(aUmCli, {"Maior_Compra__c"		, SA1->A1_MCOMPRA})		
		if empty(SA1->A1_ULTCOM)	
			aadd(aUmCli, {'urn:fieldsToNull'		 , 'Ultima_Compra__c'})		
		else		
			aadd(aUmCli,{"Ultima_Compra__c"		, SA1->A1_ULTCOM  })			
		endif
		
		aadd(aUmCli, {"Saldo_Aberto_em_Titulos__c", SA1->A1_SALDUP})
		aadd(aUmCli, {"Pagamentos_Atrasados__c", SA1->A1_PAGATR})
		aadd(aUmCli, {"Titulos_Atrasados__c" , SA1->A1_ATR})
		aadd(aUmCli, {"Maior_Atraso__c"	 	, SA1->A1_MATR})
		aadd(aUmCli, {"Media_Atraso__c"		, SA1->A1_METR})
		aadd(aUmCli, {"Valor_Acumulado__c"	, SA1->A1_VACUM})
		aadd(aUmCli, {"Numero_Pagamentos__c"	, SA1->A1_NROPAG})
		aadd(aUmCli, {"Limite_Disponivel__c"	, SA1->A1_LC - SA1->(A1_SALDUP+A1_SALPEDL)      }) 
		
		if empty(SA1->A1_VENCLC)	
			aadd(aUmCli, {'urn:fieldsToNull'		 , 'Data_Limite_Credito__c'})		
		else		
			aadd(aUmCli, {'Data_Limite_Credito__c'		 , SA1->A1_VENCLC})			
		endif                   
		
	   	if SA1->A1_PESSOA=="F"	   	
			aadd(aUmCli, {'RecordTypeId', '012o0000000Gkiy'})   			
	    endif
	    
	    //ALEX CAMPOS PARA CARGA 
	    /*
		aadd(aUmCli,{'Cobranca_Externa__c',	iif(SA1->A1_X_COBEX=='S','1','0')})      
		
		if !empty(SA1->A1_GRPVEN)	    
			dbSelectArea('ACY')		
			if ACY->(dbSeek(xFilial('ACY')+SA1->A1_GRPVEN))		
				aadd(aUmCli,{'Grupo_Clientes__c',	ALLTRIM(ACY->ACY_DESCRI)+" ("+ACY->ACY_GRPVEN+")"}) 
			endif				   
		else
			aadd(aUmCli, {'urn:fieldsToNull'	, 'Grupo_Clientes__c'})	
		endif
		
		if !empty(SA1->A1_X_SCOBR)  	
			aadd(aUmCli, {'Situacao_Cobranca__c'	, DesX3Cbo('A1_X_SCOBR', SA1->A1_X_SCOBR)+" ("+SA1->A1_X_SCOBR+")"})		    
		else
	   		aadd(aUmCli, {'urn:fieldsToNull'	, 'Situacao_Cobranca__c'})	
		endif 
		
		if !empty(SA1->A1_FAX) 	          	                                                    
			aadd(aUmCli, {'Fax'	 ,  ALLTRIM(strtran(SA1->A1_FAX,"-"," "))})
		else
			aadd(aUmCli, {'urn:fieldsToNull'		 , 'Fax'})		
		endif
		*/
	    
	    
   		aadd(aCarga ,aUmCli )
		
		_nI++
			         		
	enddo           
	
	if len(aCarga)>0
		//monta XML
		cXML 	:= u_SFMonXML("Account", "upsert",  , 'Codigo_ERP__c', aCarga) 
		  	
	  	//grava XML
	  	if lGrvXml 
		  	cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			cNomArqXML := strtran(cNomArqXML,":","")
	   		MemoWrite(cPathXML + cNomArqXML+"_CLI_CRD.xml", cXML  )
		endif
		
		aRet := {}   			
		aRet := U_SFEnvXml(cXML )      	        	
		aCarga := {}   
	endif
return


/************************************************************************************************
Carga de clientes
*************************************************************************************************/
user function SFSA1()
  	local aCarga	:={}
  	local aUF		:={}
  	local aDados	:={}
  	
  	
  	rpcsettype(3)                   
  	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'      
  		
  	cPathXML 		:= "\salesforce\xml\carga\" 
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif	       
	
  	private nBloco := 200	           
  	    		       
  		
   /*		
	cAlsSA1	:= getnextAlias()
   	beginsql alias cAlsSA1
    
	select r_e_c_n_o_ REC from sa1cmp where a1_x_envsf='S' and d_e_l_e_t_<>'*' and a1_pessoa='J' // AND A1_COD='01684866'
    
                                                                                           
    endsql
    
    
		and (a1_cod,a1_loja)
	in
	(select f2_cliente, f2_loja from sf2300 
	where 
	f2_emissao between '20141201' 
	and '20141231' and d_e_l_e_t_<>'*')             
	
	//and a1_cgc in (select a4_cgc from sa4cmp)
	and a1_est<>'EX'   
	//and a1_cgc in ('08707061000952','02037822000253','78815958000128','17676693000563','13838931000377','71997274000145','44914992003315','89317697000566','03060874000122','12472131000150','86048063000133','07770042000231','11157927000156','65293383000340','02846195000110','08974479000179','00629711000120')
    and a1_cgc in ('78815958000128')
	endsql      
    */
    
    aDados:= {}
    
    aDados	:= u_carArq("tmp/vendedorp00272.csv") 
    
    aCond	:= u_carArq("tmp/condicao.txt")
    
    nI := 0
    dbselectArea("SA1")
    dbSelectArea("SA3")
    
    for nk:=1 to len(aDados)
              
	//do while (cAlsSA1)->(!EOF())
	    
	    //SA1->(DBGOTO((cAlsSA1)->REC))
	    cCod	:= padr(aDados[nK,1], tamsx3("A1_COD")[1])
	    cLoja	:= padr(aDados[nK,2], tamsx3("A1_LOJA")[1])
	    cEmlProp:= alltrim(aDados[nK,4])       
	    
		if SA1->(dbSeek(xFilial('SA1')+ cCod + cLoja))
		    
		    if SA1->A1_PESSOA == 'J' .or. SA1->A1_EST=='EX' //.OR. LEN(ALLTRIM(SA1->A1_CEP)) == 8
		         loop
		    endif
		    	    
		    cVend := padr(aDados[nK,3],  tamsx3("A3_COD")[1]) 
		    
		
		    nPosCond := ASCAN(aCond, {|x| x[1] == SA1->A1_COND })
		   
		    
			if SA3->(dbSeek(xFilial('SA3')+ cVend ))
			    /*
				if !empty(SA3->A3_EMAIL)
				
					nPosVirg:= AT(';', ALLTRIM(SA3->A3_EMAIL))
				    
					if nPosVirg>0
					
						cEmlProp := alltrim(SUBSTR(SA3->A3_EMAIL, 1 , nPosVirg-1))  
					
					else
					
						cEmlProp := ALLTRIM(SA3->A3_EMAIL)
						
					endif
					
					
				endif
			    */    
			    
			   	RECLOCK("SA1",.F.) 
				SA1->A1_VEND := SA3->A3_COD
				SA1->A1_X_ENVSF :='S'
		    	SA1->(msUnlock())    
		    	
		   //	else
				
			//	cEmlProp := "alex.brito@cantupneus.com.br" 
				
			endif
			
			
			if nPosCond==0
		                             
		        RECLOCK("SA1",.F.) 
		    	
		    	SA1->A1_COND := '010'
		    	                   	
		    	SA1->(msUnlock())
		    	
		    endif
			
		   
	   		aadd(aCarga , U_SFCLI001(SA1->A1_COD, SA1->A1_LOJA, .F. ,"" ,"" ,lower(cEmlProp)))
	   		
	   		nI++
	   		
	   		if mod(len(aCarga), nBloco) == 0  .and. len(aCarga)>0
	   		
 	   			cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			
				cNomArqXML := strtran(cNomArqXML,":","")
			    	 
				//monta XML
				cXML 	:= u_SFMonXML("Account", "upsert",  , 'Codigo_ERP__c', aCarga) 
				  	
			  	//grava XML
		   		MemoWrite(cPathXML + cNomArqXML+"_CLI.xml", cXML  )
				
				aRet := {}
				
			   	aRet := U_SFEnvXml(cXML )      
		
				aCarga := {}
				
	   		endif
   		endif
   		    
   	  //	(cAlsSA1)->(DBSKIP())
   		
	//enddo  
	     
	next nK        
	
	if len(aCarga)>0   
	
	 
		cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
		
		cNomArqXML := strtran(cNomArqXML,":","")
	    
		if !ExistDir ( cPathXML )
		
			FWMakeDir ( cPathXML, .f.)
			
		endif
		 
		//monta XML
	   	cXML 	:= u_SFMonXML("Account", "upsert",  , 'Codigo_ERP__c', aCarga) 
		  	
	  	//grava XML
   	   	MemoWrite(cPathXML + cNomArqXML+"_CLI.xml", cXML  )
		
		aRet := {}
		
	  	aRet := U_SFEnvXml(cXML )    
		aCarga := {}     
	endif
	
return 




/************************************************************************************************
Carga de endere? de entrega clientes
*************************************************************************************************/
//static function SFSA1ENT(cAlsSA1, aUF)  	
user function SFSA1ENT()
	local aCarga	:={}
  	local aUF		:={}
  	local aDados	:={}
  	local aArq		:={}
  	
  	return
  	
  	rpcsettype(3)                   
  	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'      
  		
  	cPathXML 		:= "\salesforce\xml\carga\" 
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif	       
	
  	private nBloco := 200	           
  	
  	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//?reenchimento do Array de UF                                            ?
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	aadd(aUF,{"RO","11"})
	aadd(aUF,{"AC","12"})
	aadd(aUF,{"AM","13"})
	aadd(aUF,{"RR","14"})
	aadd(aUF,{"PA","15"})
	aadd(aUF,{"AP","16"})
	aadd(aUF,{"TO","17"})
	aadd(aUF,{"MA","21"})
	aadd(aUF,{"PI","22"})
	aadd(aUF,{"CE","23"})
	aadd(aUF,{"RN","24"})
	aadd(aUF,{"PB","25"})
	aadd(aUF,{"PE","26"})
	aadd(aUF,{"AL","27"})
	aadd(aUF,{"MG","31"})
	aadd(aUF,{"ES","32"})
	aadd(aUF,{"RJ","33"})
	aadd(aUF,{"SP","35"})
	aadd(aUF,{"PR","41"})
	aadd(aUF,{"SC","42"})
	aadd(aUF,{"RS","43"})
	aadd(aUF,{"MS","50"})
	aadd(aUF,{"MT","51"})
	aadd(aUF,{"GO","52"})
	aadd(aUF,{"DF","53"})
	aadd(aUF,{"SE","28"})
	aadd(aUF,{"BA","29"})
	aadd(aUF,{"EX","99"})	
  		       
    aArq:= {}
    
    aArq	:= u_carArq("tmp/cliente_vendedor_pr.csv") 
    
    
    
    nI := 0   
    
    dbselectArea("SA1")
   
    
    for nk:=1 to len(aArq)

	    cCod	:= padr(aArq[nK,1], tamsx3("A1_COD")[1])
	    cLoja	:= padr(aArq[nK,2], tamsx3("A1_LOJA")[1])
	    
		if SA1->(dbSeek(xFilial('SA1')+ cCod + cLoja))
            nPos := 0
			if SA1->A1_PESSOA == 'J' .or. SA1->A1_EST=='EX'  
		         loop
		    endif

			if nPos == 0  
	
			    cNumCob	:= "0" 
		   
				if (nPosVirg:= AT(',', ALLTRIM(SA1->A1_END))) != 0 
				 	
				 	cNumCob := ""
				 	 	 	 
					for nI:=nPosVirg+1 to len(alltrim(SA1->A1_END))
					            
			            if isDigit(alltrim(substr(SA1->A1_END, nI, 1 )))
			     		
				    		cNumCob	+= substr(SA1->A1_END, nI,1 )
				    	
					    	if len(cNumCob)>5
					    	    
					    	    cNumCob := "0"
					    	    
					    		exit
					    		
					    	endif
					    	 
				    	endif
				    	
				    next nI	
				
				endif
				
				if empty(cNumCob)
				
					cNumCob :="0"
				
				endif
			    
			    
			    aDados := {}
			    
			    aadd(aDados, {'Bairro__c'		 , u_RetTgHtm(upper(SA1->A1_BAIRRO))})
			    
			   	if LEN(ALLTRIM(SA1->A1_CEP))==8
			   	
			   		aadd(aDados, {'CEP__c'			 ,  Transform(SA1->A1_CEP,"@R 99999-999")})
			    
			    endif
			    
				aadd(aDados, {'Cidade__c' 		 , UPPER(SA1->A1_MUN)})
			    
				
			    nCodUF	:= ascan(aUF, {|x| x[1]==SA1->A1_EST })
			   
				if nCodUF>0
					aadd(aDados, {'Codigo_Municipio__c', aUF[nCodUF,2]+SA1->A1_COD_MUN})
				endif
							
				aadd(aDados, {'Complemento__c'	 , u_RetTgHtm(UPPER(SA1->A1_COMPLEM))})
			
				aadd(aDados, {'Conta__r'	 		,"<Codigo_ERP__c>"+SA1->A1_COD + SA1->A1_LOJA+"</Codigo_ERP__c>"})
			
				aadd(aDados, {'Estado__c' 		 , SA1->A1_EST})
				
				aadd(aDados, {'Numero__c'		 , cNumCob })
				
				aadd(aDados, {'Rua__c'	 		 , u_RetTgHtm(UPPER(SA1->A1_END))})
				
			
				if !empty(SA1->A1_PAIS)
					dbSelectArea("SYA")
					if SYA->(dbSeek(xFilial("SYA")+SA1->A1_PAIS))
						aadd(aDados, {'Pais__c'		, 	SYA->YA_DESCR })//descricao do pais
					endif
				endif  
			    
			    
		   		aadd(aCarga , aDados)
		   		
		   		if mod(len(aCarga), nBloco) == 0 .and. len(aCarga)>0
		   		
		   			cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
				
					cNomArqXML := strtran(cNomArqXML,":","")
				    	 
					//monta XML
					cXML 	:= u_SFMonXML("Endereco_Entrega__c", "upsert",  , 'Id', aCarga) 
					  	
				  	//grava XML
			   		MemoWrite(cPathXML + cNomArqXML+"_CLI_END_ENT.xml", cXML  )
					
					aRet := {}
					
					aRet := U_SFEnvXml(cXML )      
			
					aCarga := {}
					
		   		endif
			endif
		endif		   
   		
   	next nK
   		
	if len(aCarga)>0   

		cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
		
		cNomArqXML := strtran(cNomArqXML,":","")
	    
		if !ExistDir ( cPathXML )
		
			FWMakeDir ( cPathXML, .f.)
			
		endif
		 
		//monta XML
		cXML 	:= u_SFMonXML("Endereco_Entrega__c", "upsert",  , 'Id', aCarga)  
		  	
	  	//grava XML
   		MemoWrite(cPathXML + cNomArqXML+"_CLI_END_ENT.xml", cXML  )
		
		aRet := {}
		
		aRet := U_SFEnvXml(cXML )    
		
		aCarga := {}
		     
	endif           
	
return 
                

user function SA1CTO()

	local aCarga	:={}
  	local aDados	:={}
  	local aArq		:={}  
	local nBloco	:= 200        
	
	return      
	
	rpcsettype(3)
  	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'      

	aArq:= {}
    
    aArq	:= u_carArq("tmp/cliente_vendedor_pr.csv") 
    
    cPathXML 		:= "\salesforce\xml\carga\" 
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif
    
    nI := 0   
    
    dbselectArea("SA1")
   
    
    for nk:=1 to len(aArq)

	    cCod	:= padr(aArq[nK,1], tamsx3("A1_COD")[1])
	    cLoja	:= padr(aArq[nK,2], tamsx3("A1_LOJA")[1])
	    
		if SA1->(dbSeek(xFilial('SA1')+ cCod + cLoja))
           
			if SA1->A1_PESSOA == 'J' .or. SA1->A1_EST=='EX'  
		         loop
		    endif

		    aDados := {}
		    
		    if !empty(SA1->A1_EMAIL) 
		        
		        if (nPosVirg:= AT(';', SA1->A1_EMAIL))>0
		             
		        	cEmail := SUBSTR(SA1->A1_EMAIL,1, nPosVirg-1)
		        
		        else 
		           	
		           	cEmail := SA1->A1_EMAIL
		        	
		        endif
		        
		        
		        cEmail := lower(alltrim(cEmail))
		                                             
		    	if SA1->A1_PESSOA=="F"
		
					aadd(aDados, {'RecordTypeId', '012o0000000Gkiy'})
					
		        endif
		        
		        aadd(aDados, {'FirstName','CONTATO'}) 
			    aadd(aDados, {'LastName', 'PADRAO'}) 
			    
	            aadd(aDados, {'Email', cEmail})
	
	            aadd(aDados, {'Account', '<Codigo_ERP__c>'+ SA1->A1_COD+SA1->A1_LOJA+'</Codigo_ERP__c>'})
	            aadd(aDados, {'Cargo__c', 'Financeiro'})            
			    
			    if empty(SA1->A1_DDI)
		
					cTelefone := "+55"
				else
					cTelefone := "+"+ cValToChar(val(SA1->A1_DDI))
					
				endif
				
				cTelefone += " " + ALLTRIM(str(val(SA1->A1_DDD)))
				
				cTelefone += " " + ALLTRIM(strtran(SA1->A1_TEL,"-"," "))
				
				aadd(aDados, {'Phone'		 , cTelefone })
			   	    
		   		aadd(aCarga , aDados)
	   		
	   		endif
	   		
	   		if mod(len(aCarga), nBloco) == 0 .and. len(aCarga)>0
	   		
	   			cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			
				cNomArqXML := strtran(cNomArqXML,":","")
			    	 
				//monta XML
				cXML 	:= u_SFMonXML("Contact", "upsert",  , 'Id', aCarga) 
				  	
			  	//grava XML
		   		MemoWrite(cPathXML + cNomArqXML+"_CLI_CONTATO.xml", cXML  )
				
				aRet := {}
				
				aRet := U_SFEnvXml(cXML )      
		
				aCarga := {}
				
	   		endif
			
		endif		   
   		
   	next nK
   		
	if len(aCarga)>0   

		cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
			
		cNomArqXML := strtran(cNomArqXML,":","")
	    	 
		//monta XML
		cXML 	:= u_SFMonXML("Contact", "upsert",  , 'Id', aCarga) 
		  	
	  	//grava XML
   		MemoWrite(cPathXML + cNomArqXML+"_CLI_CONTATO.xml", cXML  )
		
		aRet := {}
		
		aRet := U_SFEnvXml(cXML )      

		aCarga := {}
		     
	endif

return

user function TesSqlSF()
	
	rpcsettype(3)
  	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01'      
	
	
	cSQL := "Select Codigo_ERP__c from Titulo__c " 

			
	aRetSQL:= {}
	aRetSQL:= U_SFSql(cSQL)

	//remove os registros que nao tem o campo do select
	nK:= 1
	nTam:= len(aRetSQL)
	do while nK <= nTam
		if type("aRetSQL[nK,2]:_SF_CODIGO_ERP__C")=="U"
		     aDel(aRetSQL, nK)
		     aSize(aRetSQL, len(aRetSQL)-1) 
		     nK--
		     nTam := len(aRetSQL)
		endif
		nK++
	enddo
    
    ASort(aRetSQL, , , {|x,y| x[2]:_SF_CODIGO_ERP__C <  y[2]:_SF_CODIGO_ERP__C}) 
   
    
return

/****************************************************************************************************
 Obtem os vendedores das ultimas vendas
****************************************************************************************************/  
user function ultvend()
    
    local aEmp:= {'30','31','60','70'}
    local aDados := {}
    Local cWorkSheet := "DADOS"
    Local cTable := ""
    
    oFwMsEx := FWMsExcel():New()
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable( cWorkSheet, cTable )
  
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Cod Cliente" , 1, 1 )
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Loja Cliente" , 1, 1 )
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome Cliente" , 1, 1 ) 
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Estado" , 1, 1 ) 
    
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Vend Nota" , 1, 1 )
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Nome vendedor" , 1, 1 )
    oFwMsEx:AddColumn( cWorkSheet, cTable , "Grupo produto" , 1, 1 ) 
      
    for ni:=1 to len(aEmp)
    
	    rpcsettype(3)
      	PREPARE ENVIRONMENT EMPRESA aEmp[ni]FILIAL '01'      
	    
		cAls := GetNextAlias()
	    
		/*
		beginsql Alias cAls
			SELECT  F2_CLIENTE, F2_LOJA, A1_NOME,A1_EST, F2_VEND1, A3_NOME , A3_GRUPO 
			FROM %table:SF2% SF2 INNER JOIN %table:SA1% SA1 ON F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA AND SA1.D_E_L_E_T_<>'*'  
			INNER JOIN %table:SA3% SA3 on F2_VEND1 = A3_COD AND SA3.D_E_L_E_T_<>'*' 
			WHERE SF2.D_E_L_E_T_<>'*'
			AND F2_ESPECIE = 'SPED'
		    AND (F2_FILIAL, F2_CLIENTE, F2_LOJA, F2_VEND1, F2_EMISSAO)
		    IN	
			(SELECT F2_FILIAL, F2_CLIENTE, F2_LOJA,F2_VEND1, MAX(F2_EMISSAO) FROM %table:SF2%  TMP WHERE
			         TMP.D_E_L_E_T_<>'*'
			AND TMP.F2_ESPECIE = 'SPED'
			
			GROUP BY F2_FILIAL, F2_CLIENTE, F2_LOJA,F2_VEND1
			)
			ORDER BY F2_CLIENTE,F2_LOJA
	
		endsql
	    */
	   
	   beginsql Alias cAls
			SELECT DISTINCT ZZ5_CLIENT, ZZ5_LOJA, A1_NOME,A1_EST, ZZ5_VEND, A3_NOME , A3_GRUPO 
			FROM %table:ZZ5% ZZ5 INNER JOIN %table:SA1% SA1 ON ZZ5_CLIENT = A1_COD AND ZZ5_LOJA = A1_LOJA AND SA1.D_E_L_E_T_<>'*'  
			INNER JOIN %table:SA3% SA3 on ZZ5_VEND = A3_COD AND SA3.D_E_L_E_T_<>'*' 
			WHERE ZZ5.D_E_L_E_T_<>'*'
		   
			ORDER BY ZZ5_CLIENT, ZZ5_LOJA
	
		endsql
			 
	    do while (cAls)->(!EOF())
	        
	       	oFwMsEx:AddRow( cWorkSheet, cTable, {(cAls)->ZZ5_CLIENT,;
	       											 (cAls)->ZZ5_LOJA, ;
	       											 alltrim((cAls)->A1_NOME),;
	       											 (cAls)->A1_EST,;
	       											 (cAls)->ZZ5_VEND,;
	       											 alltrim((cAls)->A3_NOME),;
	       											 alltrim((cAls)->A3_GRUPO)})
	       		
	       
	    	(cAls)->(dbSkip())  
	    	
	    enddo
		(cAls)->(dbCloseArea())
		
		RpcClearEnv()
     next nI   
  
    oFwMsEx:Activate()	
	cArq := CriaTrab( NIL, .F. ) + ".xml"
	oFwMsEx:GetXMLFile( cArq )
	oFwMsEx:DeActivate()
	
	__CopyFile( cArq, "c:\temp\" + cArq )
	
	FErase(cArq)
	
	
return
         

static function temNota(cEmp) 
	local aArea := getArea()
	
	lRet := .F.
	
	cSql := "SELECT F2_DOC FROM SF2"+cEmp+"0 WHERE D_E_L_E_T_<>'*' AND F2_CLIENTE='" + SA1->A1_COD +"'"
	cSql += " AND F2_LOJA='" + SA1->A1_LOJA +"'"
	
	TCQUERY cSql NEW ALIAS "SF2TMP"
	                                                                          
	lRet := !EMPTY(SF2TMP->F2_DOC)
    
    SF2TMP->(dbCloseArea()) 
	
	RestArea(aArea)
	
return lRet


user function carArq(cArq)

   	local aDados	:= {}

	nHdl := FT_FUse (cArq)
	
	if nHdl== -1
	
		return  aDados
		
	else
	
	     do while !FT_FEOF ( )
	        
	        aLinha 	:= {}
	        cLinha	:= FT_FReadLn ()
	        aLinha 	:= strtokArr(cLinha,";")
	     	
	        AADD(aDados, aLinha)
	        
	     	FT_FSkip()
	     enddo
	     FClose(nHdl)
	endif	

return aDados  
                   

/*
  Retorna a descri豫o do valor de um campo Combo (X3_COMBO)
*/

static function DesX3Cbo(cCampo, cValor)
    
	local cX3SCOBR :=""
	local aX3SCOBR :={}
	local aAreaSX3 :=SX3->(getArea())
	local cScobr   :=""
    
	dbselectArea("SX3")
	SX3->(DBSETORDER(2))
	if SX3->(dbseek(cCampo))		     
		cX3SCOBR := X3Cbox()		
		aX3SCOBR := StrTokArr(cX3SCOBR,';')
		
		if (nPos := aScan(aX3SCOBR, {|x| substr(x,1,tamsx3(cCampo)[1])==cValor}))>0	 		    					          			
			cScobr := UPPER(alltrim(substr(aX3SCOBR[nPos], tamsx3(cCampo)[1]+2)))
		endif				
	endif                   		
            
	RestArea(aAreaSX3)

return cScobr


user function SFINTCLI()  

	Local oGetDoc
	Local cGetDoc := Space(9)
	Local oGetEmp
	Local cGetEmp := Space(2)
	Local oGetFil
	Local cGetFil := Space(2)  
	Local oGetCli
	Local cGetCli:= space(9)
	Local oGetLoj
	Local cGetLoj:= space(4)
	Local oSay1
	Local oSay2
	Local oSay3

	Local oSButton1
	Local oSButton2    
	Local nOpc := 0
	
	Static oDlg     

	rpcsettype(3)
	prepare environment empresa '30' filial '01'
	
	  DEFINE MSDIALOG oDlg TITLE "Nota" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL
	
	    @ 026, 076 MSGET oGetEmp VAR cGetEmp SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 041, 076 MSGET oGetFil VAR cGetFil SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 055, 076 MSGET oGetCli VAR cGetCli SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL  F3 "SA1"
		@ 069, 076 MSGET oGetLoj VAR cGetLoj SIZE 060, 010 OF oDlg COLORS 0, 16777215  PIXEL

		
	    DEFINE SBUTTON oSButton1 FROM 098, 070 TYPE 01 OF oDlg ACTION (nOpc:=1,oDlg:End())  ENABLE 
	    DEFINE SBUTTON oSButton2 FROM 098, 109 TYPE 02 OF oDlg ACTION oDlg:End() ENABLE
	    @ 026, 024 SAY oSay1 PROMPT "Empresa" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
   		@ 041, 024 SAY oSay1 PROMPT "Filial " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 055, 024 SAY oSay2 PROMPT "Cliente " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 069, 024 SAY oSay3 PROMPT "Loja" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

	
	  ACTIVATE MSDIALOG oDlg CENTERED
	
	if nOpc == 1
	
		U_SFCLI001(cGetCli, cGetLoj, .f., cGetEmp, cGetFil)  
		dbSelectArea("SA1")
		if SA1->(FOUND())
			RecLock("SA1",.F.)
			SA1->A1_X_ENVSF	:='S'
			SA1->(MSUNLOCK())
		endif
	endif      


return