#INCLUDE "Protheus.ch"
#include "tbiconn.ch"
#include "topconn.ch"


/*/{Protheus.doc} SFNF001
Rotina para enviar dados de nota fiscal e titulos para o SalesForce

@author devair.tonon
@since 06/02/2015
@version 1.0

@param cFILDOC, character, (Descrição do parâmetro)
@param cNUMDOC, character, (Descrição do parâmetro)
@param cSERDOC, character, (Descrição do parâmetro)
@param cCLIDOC, character, (Descrição do parâmetro)
@param cLOJDOC, character, (Descrição do parâmetro)            
@param lIsJob , logical  , (Descrição do parâmetro)  
@param cEmp   , character, (Descrição do parâmetro)  
@param cFil   , character, (Descrição do parâmetro)  
/*/

User Function SFNF001(cFILDOC, cNUMDOC, cSERDOC, cCLIDOC, cLOJDOC, lIsJob, cEmp, cFil )
	local oError 	:=ErrorBlock({|e| CONOUT(PROCNAME()+ CRLF +e:Description + e:ErrorStack)})
	local aCabNf 	:= {}
	local aIteNF 	:= {}
	local aTitNF 	:= {}
	local aLotNF	:= {}
	local aUmCli	:= {} 
	local aAreaSF2	 
	local aAreaSD2	 
	local aAreaSC5	 
	local aAreaSE1	 
	local aAreaSA4	 
	local aAreaSA1	 
	local lSFGrvXml := .F.
	local lSFCrdCli := .F.
	
	local cContaR	:= ""
	local cChvNF 	:= ""
	local cNotaR	:= ""
	
	local aRetNF	:= {{.T.,"",""}}
	local aRetIteNF	:= {{.F.,"",""}}
	local aRetTitNF	:= {{.F.,"",""}}
	local aRetLotNF	:= {{.F.,"",""}}
	
	local cPathXML 	:= "\salesforce\xml\nota\"
	local cNomArqXML:= ""
	local nCont		:= 0
	
	default lIsJob	:= .F.
	
	if lIsJob                           
	   	RpcSetType(3)  
   		PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil	//	   rpcsetenv(cEmp, cFil) 
   		CONOUT("SALESFORCE | " + TIME() +" | PREPARANDO AMBIENTE "+  cEmpAnt +"/" +cFilAnt  )					
	endif
	
	aAreaSF2	:= SF2->(getArea())
	aAreaSD2	:= SD2->(getArea())
	aAreaSC5	:= SC5->(getArea())
	aAreaSE1	:= SE1->(getArea())
	aAreaSA4	:= SA4->(getArea())
	aAreaSA1	:= SA1->(getArea())
	lSFGrvXml := GetMv("MV_X_SFXML",.F.,.T.)
	lSFCrdCli := GetMv("MV_X_SFCRD",.F.,.T.)
	
	
	
	if !ExistDir ( cPathXML )
		
		FWMakeDir ( cPathXML, .f.)
		
	endif
	
	//FILTRA SF2
	cFilSF2 := "F2_FILIAL='"  + cFILDOC +"' .AND. "
	cFilSF2 += "F2_DOC='"     + cNUMDOC +"' .AND. "
	cFilSF2 += "F2_SERIE='"   + cSERDOC +"' .AND. "
	cFilSF2 += "F2_CLIENTE='" + cCLIDOC +"' .AND. "
	cFilSF2 += "F2_LOJA='"    + cLOJDOC +"'"
	dbSelectArea("SF2") 
	SF2->(DBSetFilter ( {||&cFilSF2}, cFilSF2 ))
	SF2->(DBGOTOP())
	
	//FILTRA SD2                                             
	cFilSD2 := "D2_FILIAL='"  + cFILDOC +"' .AND. "
	cFilSD2 += "D2_DOC='"     + cNUMDOC +"' .AND. "
	cFilSD2 += "D2_SERIE='"   + cSERDOC +"' .AND. "
	cFilSD2 += "D2_CLIENTE='" + cCLIDOC +"' .AND. "
	cFilSD2 += "D2_LOJA='"    + cLOJDOC +"'"
	dbSelectArea("SD2") 
	SD2->(DBSetFilter ( {||&cFilSD2}, cFilSD2 ))
	SD2->(DBGOTOP())   
	
	
	//FILTRA SE1
	cFilSE1 := "E1_FILIAL='"  + cFILDOC +"' .AND. "
	cFilSE1 += "E1_NUM='"     + cNUMDOC +"' .AND. "
	cFilSE1 += "E1_PREFIXO='" + cSERDOC +"' .AND. "
	cFilSE1 += "E1_CLIENTE='" + cCLIDOC +"' .AND. "
	cFilSE1 += "E1_LOJA='"    + cLOJDOC +"'"
	dbSelectArea("SE1") 
	SE1->(DBSetFilter ( {||&cFilSE1}, cFilSE1 ))
	SE1->(DBGOTOP())
    
 	
 	cNomArqXML:= ALLTRIM(SF2->F2_SERIE)+"_"+ALLTRIM(SF2->F2_DOC)+"_"+alltrim(CUSERNAME)+"_"+dtos(date())+time()
 	cNomArqXML:= strtran(cNomArqXML,":","")
 
	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	if SC5->(dbSeek( SD2->D2_FILIAL + SD2->D2_PEDIDO )) .and. SC5->(fieldpos("C5_X_ORIPD"))!=0
		
		if SC5->C5_X_ORIPD=='S'				
			
			CONOUT("SALESFORCE | " + TIME() +" | MONTAGEM XML NOTA FISCAL "+  cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC  )			
			
			//Nota_FIscal__c
			cChvNF := cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC
			
			cNotaR	:= "<Codigo_ERP__c>"+cChvNF+"</Codigo_ERP__c>"
			
			dbSelectArea("SA1")
			SA1->(dbSeek(xFilial("SA1") + cCLIDOC + cLOJDOC ))
			
			cContaR := "<Codigo_ERP__c>"+cCLIDOC + cLOJDOC+"</Codigo_ERP__c>"
			
			//Item_Nota_Fiscal__c
			do while SD2->(!eof()) 
				
				aUmItem := {}
				
				aadd(aUmItem, {"Codigo_ERP__c"	, cChvNF+SD2->D2_ITEM})
				aadd(aUmItem, {"Nota_Fiscal__r"	, cNotaR })
				aadd(aUmItem, {"Item_Nota__c" 	,SD2->D2_ITEM})
				aadd(aUmItem, {"Preco_Unitario__c" ,SD2->D2_PRCVEN })
				aadd(aUmItem, {"Produto__r" 	,"<Codigo__c>"+alltrim(SD2->D2_COD)+"</Codigo__c>"})
				aadd(aUmItem, {"Quantidade__c" ,SD2->D2_QUANT })
				aadd(aUmItem, {"Valor_Total__c"	,SD2->D2_TOTAL })
				aadd(aUmItem, {"Valor_ICMS__c" ,SD2->D2_VALICM})
				aadd(aUmItem, {"Valor_ICMS_ST__c" ,SD2->D2_ICMSRET })
				aadd(aUmItem, {"Valor_IPI__c" ,SD2->D2_VALIPI })
				aadd(aUmItem, {"Valor_Bruto__c" ,SD2->D2_VALBRUT })
				aadd(aUmItem, {"CFOP__c" ,SD2->D2_CF })
				aadd(aUmItem, {"Lote__c" ,SD2->D2_LOTECTL })
				
				aadd(aIteNF, aUmItem)
				
				
				if !empty(SD2->D2_LOTECTL)
					aUmLote := {}
					
					aadd(aUmLote, {"Account","<Codigo_ERP__c>"+SD2->(D2_CLIENTE+D2_LOJA)+"</Codigo_ERP__c>"})
					aadd(aUmLote, {"Nota_Fiscal__r", cNotaR })
					aadd(aUmLote, {"Product2" 	,"<Codigo__c>"+alltrim(SD2->D2_COD)+"</Codigo__c>"})
					aadd(aUmLote, {"Name", alltrim(SD2->D2_LOTECTL) })
					
					aadd(aLotNF, aUmLote)
					
				endif
				
				
				SD2->(dbSkip())
			enddo

			do while SE1->(!eof()) 
			
				aUmTit := {}
				
				aadd(aUmTit, {"Codigo_ERP__c"		, cChvNF+SE1->E1_PARCELA})
				aadd(aUmTit, {"Nota_Fiscal__r"		, cNotaR})
				aadd(aUmTit, {"Name" 				, SE1->E1_NUM})
				aadd(aUmTit, {"Conta__r" 			, cContaR })
				aadd(aUmTit, {"Data_Emissao__c" 	, SE1->E1_EMISSAO})
				aadd(aUmTit, {"Parcela__c" 			, SE1->E1_PARCELA})
				aadd(aUmTit, {"Prefixo__c" 			, SE1->E1_PREFIXO})
				aadd(aUmTit, {"Saldo__c" 			, SE1->E1_SALDO})
				aadd(aUmTit, {"Valor__c" 			, SE1->E1_VALOR})
				aadd(aUmTit, {"Vencimento__c" 		, SE1->E1_VENCREA})
				aadd(aUmTit, {"Oportunidade__c"		, alltrim(SC5->C5_X_NUMPD)})
				aadd(aTitNF, aUmTit)
				SE1->(dbSkip())
			enddo
			
			
			//Nota_FIscal__c
			
			aadd(aCabNf, {"Codigo_ERP__c"		, cChvNF})
			aadd(aCabNf, {"Conta__r"			, cContaR})
			aadd(aCabNf, {"Codigo_Empresa_ERP__c", cEmpAnt})
			aadd(aCabNf, {"Codigo_Filial_ERP__c", SF2->F2_FILIAL})
			aadd(aCabNf, {"Data_Emissao__c"		, SF2->F2_EMISSAO})
			aadd(aCabNf, {"Nota_Fiscal__c"		, SF2->F2_DOC})
			//aadd(aCabNf, {"Name"	  			, SF2->F2_DOC})
			aadd(aCabNf, {"Numero_Serie__c"		, SF2->F2_SERIE})
			aadd(aCabNf, {"Numero_Pedido__c"	, SC5->C5_NUM})
			aadd(aCabNf, {"Oportunidade__c"		, alltrim(SC5->C5_X_NUMPD)})
			if !empty(SC5->C5_XTID)
				aadd(aCabNf, {"TID_Autenticacao_Cartao__c", SC5->C5_XTID})
			endif
			
			if !empty(SF2->F2_TRANSP)
				dbSelectArea('SA4')
				aAreaSA4 := SA4->(getArea())
				SA4->(dbSetOrder(1))
				
				if SA4->(dbseek(xFilial('SA4')+SF2->F2_TRANSP))
					
					aAreaSA1 := SA1->(getArea())
					
					SA1->(dbSetOrder(3))
					
					if SA1->(dbSeek(xFilial('SA1')+SA4->A4_CGC)) .AND. !empty(SA4->A4_CGC)
						
						aadd(aCabNf, {"Transportadora__r"	, "<Codigo_ERP__c>"+SA1->(A1_COD+A1_LOJA)+"</Codigo_ERP__c>"})
						
					endif
					
					RestArea(aAreaSA1)
					
				endif			
				
				RestArea(aAreaSA4)
			endif
			
			
			// monta XML do cabecalho da nota  
			// tenta enviar 10 vezes antes de reportar falha
			nCont:=0 
			while nCont < 10 .and. aRetNF[1, 1]
			
				cXML 	:= u_SFMonXML("Nota_FIscal__c", "upsert",  aCabNf, "Codigo_ERP__c")
				
				//grava XML da nota
				if lSFGrvXml
					MemoWrite(cPathXML + cNomArqXML+"_CAB.xml", cXML  )
				endif
				
				CONOUT("SALESFORCE | " + TIME() +" | ENVIANDO XML CABECALHO NOTA FISCAL "+  cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC  )
				if !empty(cXML)
					aRetNF := U_SFEnvXml(cXML ) 
				endif							
				
				nErro 	:= 0
				cErro	:= ""
				sleep(1000)
				
				nCont++
				 
			enddo
				
			if SF2->(FIELDPOS("F2_X_SFID"))!=0        
			
				RECLOCK("SF2",.F.)
				SF2->F2_X_SFID := alltrim(aRetNF[1,2])
				SF2->(msUnlock())
				
			endif
			
			//monta XML do item da nota
			cXML 	:= u_SFMonXML("Item_Nota_Fiscal__c", "upsert",  , "Codigo_ERP__c", aIteNF)
			
			//grava XML da nota
			if lSFGrvXml
				MemoWrite(cPathXML + cNomArqXML+"_ITE.xml", cXML  )
			endif
			
			CONOUT("SALESFORCE | " + TIME() +" | ENVIANDO XML ITENS NOTA FISCAL "+  cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC  )
			
			if !empty(cXML)
				aRetIteNF := U_SFEnvXml(cXML )
			endif
			
			//AEVAL(aRetIteNF, {|x| iif(x[1], (nErro++, cErro+=x[2]+CRLF),Nil)})
			
			if len(aLotNF) > 0
				
				//monta XML dos lotes
				cXML 	:= u_SFMonXML("Asset", "upsert",  , "Id", aLotNF)
				
				//grava XML dos lotes
				if lSFGrvXml
					MemoWrite(cPathXML + cNomArqXML+"_LOT.xml", cXML  )
				endif
			   
				CONOUT("SALESFORCE | " + TIME() +" | ENVIANDO XML LOTES NOTA FISCAL "+  cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC  )
		  	    
		  	    if !empty(cXML)                                                                
					aRetLotNF := U_SFEnvXml(cXML )
				endif
				
				//AEVAL(aRetLotNF, {|x| iif(x[1], (nErro++, cErro+=x[2]+CRLF),Nil)})
				
			endif
			
			if len(aTitNF) >0
				
				cXML 	:= u_SFMonXML("Titulo__c", "upsert",  , "Codigo_ERP__c", aTitNF)
				
				//grava XML dos titulos
				if lSFGrvXml
					MemoWrite(cPathXML + cNomArqXML+"_TIT.xml", cXML  )
				endif
				
				CONOUT("SALESFORCE | " + TIME() +" | ENVIANDO XML TITULOS NOTA FISCAL "+  cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC  )
		       
				if !empty(cXML)
					aRetTitNF := U_SFEnvXml(cXML )
				endif
							
			endif
				
		endif
	endif
	
	SF2->(dbClearFilter())
	SD2->(dbClearFilter())
	SE1->(dbClearFilter())
	
	RestArea(aAreaSF2)
	RestArea(aAreaSD2)
	RestArea(aAreaSC5)
	RestArea(aAreaSE1)
	RestArea(aAreaSA4)
	RestArea(aAreaSA1)

	ErrorBlock(oError)
Return

/*************************************************************************************************
 TELA DE INTEGRAÇÃO MANUAL DE NF. CHAMADA SMARTCLIENT
*************************************************************************************************/
User Function SFINTSF2()                       
	Local oGetDoc
	Local cGetDoc := Space(9)
	Local oGetEmp
	Local cGetEmp := Space(2)
	Local oGetFil
	Local cGetFil := Space(2)  
	Local oGetData1
	Local cGetData1:= space(8)
	Local oGetData2
	Local cGetData2:= space(8)
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSButton1
	Local oSButton2    
	Local nOpc := 0
	
	Static oDlg
	
	  DEFINE MSDIALOG oDlg TITLE "Nota" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL
	
	    @ 026, 076 MSGET oGetEmp VAR cGetEmp SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 041, 076 MSGET oGetFil VAR cGetFil SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 055, 076 MSGET oGetDoc VAR cGetDoc SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 069, 076 MSGET oGetData1 VAR cGetData1 SIZE 060, 010 OF oDlg COLORS 0, 16777215 picture "99/99/99" PIXEL
		@ 083, 076 MSGET oGetData2 VAR cGetData2 SIZE 060, 010 OF oDlg COLORS 0, 16777215 picture "99/99/99" PIXEL
		
	    DEFINE SBUTTON oSButton1 FROM 098, 070 TYPE 01 OF oDlg ACTION (nOpc:=1,oDlg:End())  ENABLE 
	    DEFINE SBUTTON oSButton2 FROM 098, 109 TYPE 02 OF oDlg ACTION oDlg:End() ENABLE
	    @ 026, 024 SAY oSay1 PROMPT "Empresa" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
   		@ 041, 024 SAY oSay1 PROMPT "Filial " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 055, 024 SAY oSay2 PROMPT "Pedido " SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL 
		@ 069, 024 SAY oSay3 PROMPT "Emissao De" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 083, 024 SAY oSay4 PROMPT "Emissao Ate" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	
	  ACTIVATE MSDIALOG oDlg CENTERED
	
	if nOpc == 1
	
		U_SFSF2(cGetEmp, cGetFil, cGetDoc, cGetData1, cGetData2  )	
	
	endif

Return

USER FUNCTION SFSF2(_cEmp, _cFil, _cDoc, _cEmisDe, _cEmisAte )
	local cContaR:= ""
	local cChvNF := ""
	local cNotaR	:= ""
 	
 	default _cEmp := ""
 	default _cFil := ""
	default _cDoc := ""
	default _cEmisDe := "" 
	default _cEmisAte := ""
     
       	
       	rpcclearenv()
  	rpcsettype(3)
  	rpcsetenv(_cEmp, _cFil)
            
    /*   		
    cQuery:=" SELECT DISTINCT E1_FILIAL FILIAL, E1_PREFIXO SERIE, E1_NUM DOC, E1_CLIENTE CLIENTE, E1_LOJA LOJA FROM "+ RETSQLNAME("SE1")
	cQuery+=" WHERE E1_SALDO >0 AND E1_TIPO='NF'    "   
	cQuery+=" AND D_E_L_E_T_<>'*'      "
	cQuery+=" ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM  "
    */
    
    
	cQuery:= " SELECT F2_FILIAL FILIAL , F2_SERIE SERIE ,F2_DOC DOC, F2_CLIENTE CLIENTE, F2_LOJA LOJA"
	cQuery+= " FROM "+RETSQLNAME("SF2")+" SF2 "
	cQuery+= " WHERE "
	cQuery+= " SF2.D_E_L_E_T_<>'*' "      
	
	cQuery+= " AND "
	cQuery+= " (F2_FILIAL, F2_SERIE,F2_DOC, F2_CLIENTE, F2_LOJA) IN "
	cQuery+= " (SELECT D2_FILIAL, D2_SERIE, D2_DOC, D2_CLIENTE, D2_LOJA "
	cQuery+= " FROM "+RETSQLNAME("SD2")+" SD2 "
	cQuery+= " INNER JOIN "+RETSQLNAME("SC5")+" SC5 "
	cQuery+= " ON D2_FILIAL = C5_FILIAL "
	cQuery+= " AND D2_PEDIDO = C5_NUM " 
	cQuery+= " AND SC5.D_E_L_E_T_<>'*' "
	//cQuery+= " AND C5_X_ORIPD='S' " 
	//cQuery+= " AND C5_X_NUMPD<>' ' " 
	
	if !empty(_cDoc) 
		
		cQuery+= " AND C5_FILIAL='" +_cFil+"'"
		cQuery+= " AND C5_NUM='" +_cDoc+"'"
		
	endif
	
	cQuery+= " WHERE SD2.D_E_L_E_T_<>'*') "  
	cQuery+= " AND F2_TIPO='N'"
	
	if !empty(_cEmisDe)
		cQuery+= " AND F2_EMISSAO>='" + DTOS(CTOD(_cEmisDe,'dd/mm/yyyy'))+"'
    endif 
    
    if !empty(_cEmisAte)
		cQuery+= " AND F2_EMISSAO<='" + DTOS(CTOD(_cEmisAte,'dd/mm/yyyy'))+"'
    endif
    
    
	if select("TEMP")!=0
		TEMP->(dbCloseArea())
	endif
	
	TCQUERY cQuery NEW ALIAS "TEMP"    
	
	aCabNf	:= {}
	aIteNF	:= {}
	aTitNF	:= {}
	aLotNF	:= {}
                       
	if !empty(_cDoc).and. TEMP->(!EOF())		
		StartJob('U_SFNF001',GetEnvServer(),.F., TEMP->FILIAL, TEMP->DOC, TEMP->SERIE, TEMP->CLIENTE ,  TEMP->LOJA, .T., cEmpAnt, cFilAnt )				    
		TEMP->(dbCloseArea())			
		return	
	endif                    
	
	
	do while TEMP->(!EOF())
    
   		dbSelectArea("SF2")
   		if SF2->(dbSeek(TEMP->FILIAL + TEMP->DOC + TEMP->SERIE + TEMP->CLIENTE + TEMP->LOJA)) 
		
			//Nota_FIscal__c
			cChvNF := cEmpAnt + SF2->F2_FILIAL + SF2->F2_SERIE + SF2->F2_DOC
			
			cNotaR	:= "<Codigo_ERP__c>"+cChvNF+"</Codigo_ERP__c>"
			
			dbSelectArea("SA1")
			SA1->(dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA ))
		
			
			cContaR := "<Codigo_ERP__c>" + SF2->F2_CLIENTE + SF2->F2_LOJA + "</Codigo_ERP__c>"
			
			dbSelectArea("SD2")
			SD2->(dbsetorder(3))
			if SD2->(dbSeek( SF2->F2_FILIAL  + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA))
				
				//Item_Nota_Fiscal__c
				do while SD2->(!eof()) .and. ;
						SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)== SF2->F2_FILIAL  + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA
					
					aUmItem := {}
					
					cNumPed	:= SD2->D2_PEDIDO
					dbSelectArea("SC5")
					if SC5->(dbSeek(SF2->F2_FILIAL + cNumPed)) 
						RECLOCK("SC5",.F.)
						SC5->C5_X_ORIPD :='S'
						SC5->(MSUNLOCK())
					endif
					
					aadd(aUmItem, {"Codigo_ERP__c"	, cChvNF+SD2->D2_ITEM})
					aadd(aUmItem, {"Nota_Fiscal__r"	, cNotaR })
					aadd(aUmItem, {"Item_Nota__c" 	,SD2->D2_ITEM})
					aadd(aUmItem, {"Preco_Unitario__c" ,SD2->D2_PRCVEN })
					aadd(aUmItem, {"Produto__r" 	,"<Codigo__c>"+alltrim(SD2->D2_COD)+"</Codigo__c>"})
					aadd(aUmItem, {"Quantidade__c" ,SD2->D2_QUANT })
					aadd(aUmItem, {"Valor_Total__c"	,SD2->D2_TOTAL })
					aadd(aUmItem, {"Valor_ICMS__c" ,SD2->D2_VALICM})
					aadd(aUmItem, {"Valor_ICMS_ST__c" ,SD2->D2_ICMSRET })
					aadd(aUmItem, {"Valor_IPI__c" ,SD2->D2_VALIPI })
					aadd(aUmItem, {"Valor_Bruto__c" ,SD2->D2_VALBRUT })
					aadd(aUmItem, {"CFOP__c" ,SD2->D2_CF })
					aadd(aUmItem, {"Lote__c" ,SD2->D2_LOTECTL })
					
					aadd(aIteNF, aUmItem)
					
					
					if !empty(SD2->D2_LOTECTL)
						aUmLote := {}
						
						aadd(aUmLote, {"Account","<Codigo_ERP__c>"+SD2->(D2_CLIENTE+D2_LOJA)+"</Codigo_ERP__c>"})
						aadd(aUmLote, {"Nota_Fiscal__r", cNotaR })
						aadd(aUmLote, {"Product2" 	,"<Codigo__c>"+alltrim(SD2->D2_COD)+"</Codigo__c>"})
						aadd(aUmLote, {"Name", alltrim(SD2->D2_LOTECTL) })
						
						aadd(aLotNF, aUmLote)
						
					endif
					
					
					SD2->(dbSkip())
				enddo
			endif
			
			
			// OBJETO Titulo__c
			dbSelectArea("SE1")
			SE1->(dbSetOrder(2)) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM
			if SE1->(dbSeek( SF2->F2_FILIAL + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ))
				
				do while SE1->(!eof()) .and. ;
						SE1->(E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM)==SF2->F2_FILIAL + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC
					
					aUmTit := {}
					
					
					aadd(aUmTit, {"Codigo_ERP__c"		, cChvNF+SE1->E1_PARCELA})
					aadd(aUmTit, {"Nota_Fiscal__r"		, cNotaR})
					aadd(aUmTit, {"Name" 				, SE1->E1_NUM})
					aadd(aUmTit, {"Conta__r" 			, cContaR })
					aadd(aUmTit, {"Data_Emissao__c" 	, SE1->E1_EMISSAO})
					aadd(aUmTit, {"Parcela__c" 			, SE1->E1_PARCELA})
					aadd(aUmTit, {"Prefixo__c" 			, SE1->E1_PREFIXO})
					aadd(aUmTit, {"Saldo__c" 			, SE1->E1_SALDO})
					aadd(aUmTit, {"Valor__c" 			, SE1->E1_VALOR})
					aadd(aUmTit, {"Vencimento__c" 		, SE1->E1_VENCREA})
					
					if !empty(SC5->C5_X_NUMPD)
	   			   		aadd(aUmTit, {"Oportunidade__c"		, alltrim(SC5->C5_X_NUMPD)})
	   				endif
	   				
					aadd(aTitNF, aUmTit)
					SE1->(dbSkip())
				enddo	
			endif
			
		
			
			//Nota_FIscal__c
			aUmaNota := {}
			aadd(aUmaNota, {"Codigo_ERP__c"			, cChvNF})
			aadd(aUmaNota, {"Conta__r"				, cContaR})
			aadd(aUmaNota, {"Codigo_Empresa_ERP__c"	, cEmpAnt})
			aadd(aUmaNota, {"Codigo_Filial_ERP__c"	, SF2->F2_FILIAL})
			aadd(aUmaNota, {"Data_Emissao__c"		, SF2->F2_EMISSAO})
			aadd(aUmaNota , {"Nota_Fiscal__c"		, SF2->F2_DOC})
			//aadd(aUmaNota, {"Name"		     		, SF2->F2_DOC})
			aadd(aUmaNota, {"Numero_Serie__c"		, SF2->F2_SERIE})
			aadd(aUmaNota, {"Numero_Pedido__c"		, cNumPed})  
			 
			if !empty(SC5->C5_X_NUMPD)
				aadd(aUmaNota, {"Oportunidade__c"		, alltrim(SC5->C5_X_NUMPD)})
			endif
			
			if !empty(SF2->F2_TRANSP)
				dbSelectArea('SA4')
				aAreaSA4 := SA4->(getArea())
				SA4->(dbSetOrder(1))
				
				if SA4->(dbseek(xFilial('SA4')+SF2->F2_TRANSP))
					
					aAreaSA1 := SA1->(getArea())
					
					SA1->(dbSetOrder(3))
					
					if SA1->(dbSeek(xFilial('SA1')+SA4->A4_CGC)) .AND. !empty(SA4->A4_CGC)
						
						aadd(aUmaNota, {"Transportadora__r"	, "<Codigo_ERP__c>"+SA1->(A1_COD+A1_LOJA)+"</Codigo_ERP__c>"})
						
					endif
					
					RestArea(aAreaSA1)
					
				endif
	
				RestArea(aAreaSA4)
			endif
	        
			
			aadd(aCabNf, aUmaNota)
			               
		endif
	                    
	     
		TEMP->(dbskip())
	enddo
            
 	TEMP->(dbCloseArea())
        	
    if len(aCabNf) > 0    
  		CargSF2(aCabNf, "Nota_FIscal__c", "Codigo_ERP__c")
  	endif
  	
  	if len(aIteNF) > 0    
  		CargSF2(aIteNF, "Item_Nota_Fiscal__c", "Codigo_ERP__c")
  	endif  
  	
  	if len(aTitNF) > 0    
  		CargSF2(aTitNF, "Titulo__c", "Codigo_ERP__c")
  	endif
  	
  	if len(aLotNF) > 0    
  		CargSF2(aLotNF, "Asset", "Id")
  	endif

Return


static function CargSF2(aReg, cEntidade, cExtId)

  	cPathXML 		:= "\salesforce\xml\carga\" 
  	
  	if !ExistDir ( cPathXML )
	
		FWMakeDir ( cPathXML, .f.)
		
	endif	       
	
  	private nBloco := 200	           
   	
   	aCarga := {}
   
    for nk:=1 to len(aReg)
    
    	aadd(aCarga, aReg[nK]) 
    	          
   		if mod(len(aCarga), nBloco) == 0 .and. len(aCarga)>0
   		
 	   		cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
		
			cNomArqXML := strtran(cNomArqXML,":","")
		    	 
			//monta XML
			cXML 	:= u_SFMonXML(cEntidade, "upsert",  , cExtId, aCarga) 
			  	
		  	//grava XML
	   		MemoWrite(cPathXML + cNomArqXML+"_"+cEmpAnt+"_"+cEntidade+".xml", cXML  )
			
			aRet := {}
			
			aRet := U_SFEnvXml(cXML )      
		   	
		   	sleep(10000)
		   	
		   	aCarga := {}
   		endif
	     
	next nK        
	
	if len(aCarga)> 0
   		
 	    cNomArqXML	:= alltrim(CUSERNAME)+"_"+dtos(date())+time()
	
		cNomArqXML := strtran(cNomArqXML,":","")
	    	 
		//monta XML
		cXML 	:= u_SFMonXML(cEntidade, "upsert",  , cExtId, aCarga) 
		  	
	  	//grava XML
   		MemoWrite(cPathXML + cNomArqXML+"_"+cEmpAnt+"_"+cEntidade+".xml", cXML  )
		
		aRet := {}
		
		aRet := U_SFEnvXml(cXML )      
	   	
	   	aCarga := {}           
	   	
  	endif
return