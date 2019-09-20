#INCLUDE "Protheus.ch"
#INCLUDE "APWebSrv.ch"
#include "tbiconn.ch"
#include "topconn.ch"
#INCLUDE "APWEBEX.CH"

#IFNDEF CRLF
	#DEFINE CRLF Chr(13)+Chr(10)                                                 
#ENDIF




// WEB SERVICE SALES FORCE - BUSCA ESTOQUE

WSSERVICE WS_SALESFORCE DESCRIPTION "<Strong>Servicos de integracao para o Salesforce</Strong>"
	
	// dados de entrada
	WSDATA cEmpresa  as string
	WSDATA cFiliais  as string
	WSDATA cCodProd  as string
	WSDATA cLote     as string
	WSDATA cCodCli   as string
	WSDATA cLojaCli  as string
	WSDATA CodVend   as String
	WSDATA PESQLOTE  as String
	
	
	/*Variaveis de entrada */
	WSDATA EMPFIL		AS String //EMPRESA FILIAL
	WSDATA CEMP		AS String //Empresa
	WSDATA CFIL 		AS String //Filial
	WSDATA CCGC	 	AS String 	// CNPJ OU CPF DO CLIENTE
	WSDATA CLIINC		AS STSFCLIENTE // ESTRUTURA DE INCLUSAO DE CLIENTE 
	WSDATA CLIALT		AS STSFCLIALT   // ESTRUTURA DE ALTERACAO DE CLIENTE
	WSDATA PEDINC		AS SFSTPEDIDO // ESTRUTURA DE INCLUSAO DE CLIENTE
	WSDATA USUARIO	As STSFUSER	// OBJETO DE ESTRUTURA USUARIO
	WSDATA RESERVA	AS STSFRESERVA //OBJETO DE ESTRUTURA RESERVA
	WSDATA NUMOPORTUNIDADE AS String //NUMERO OPORTUNIDADE
	WSDATA NUMRESERVA AS String //NUMERO DA RESERVA
	
	// dados de resposta
	WSDATA _StruEst     AS Array of _StruEstoque
	WSDATA _StruCliLC   AS Array of _StruCliente
	WSDATA _StruDadCred AS Array of _StruDadCred
	
	/*Variaveis de Retorno*/
	WSDATA RSCLIRESULT	AS STSFRETCLI //Retorno da integracao de cliente
	WSDATA RSPEDRESULT	AS STSFRETPED //Retorno da integracao de pedido
	WSDATA RSRESRESULT	AS  Array of STSFRETRES //Retorno da integracao de reserva
	
	WSMethod BuscaEst      Description "Busca Estoque"
	WSMethod BuscaEstLote  Description "Busca Estoque Lote"
	WSMethod BuscaLC       Description "Busca Limite de Credito do Cliente"
	WSMethod BuscaDadCred  Description "Busca Dados de Credito do Cliente"
	
	WSMETHOD CLIENTEINCLUIR DESCRIPTION "Realiza a inclus&atilde;o de um Cliente no ERP"
	WSMETHOD CLIENTEALTERAR DESCRIPTION "Realiza a altera&ccedil;&atilde;o de um Cliente no ERP"
	WSMETHOD PEDIDOINCLUIR DESCRIPTION "Realiza a inclus&atilde;o de um Pedido no ERP"
	WSMETHOD PEDIDOEXISTE DESCRIPTION "Realiza verifica&ccedil&atilde;o se uma oportunidade j&aacute; no ERP"
	WSMETHOD RESERVAINCLUIR DESCRIPTION "Realiza a inclus&atilde;o de uma Reversa de estoque no ERP"
	WSMETHOD RESERVACANCELAR DESCRIPTION "Realiza cancelamento de uma Reversa de estoque no ERP"
	
ENDWSSERVICE

/** Método de busca do estoque **/
WSMETHOD BuscaEst WSRECEIVE USUARIO, EMPFIL, CodVend, cCodProd, cLote, PESQLOTE   WSSEND _StruEst WSSERVICE WS_SALESFORCE
	local lValida	:= .F.
	local aEmpFil	:= {}
	local aEmp		:= {}
	local nI, nK
	local cEmpFil	:=""
	local cOldEmp	:= "30"
	local cOldFil	:= "01"
	local nX 		:= 0
	local cEmp		:= ""
	local aEmpFil2	:={}
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil //RpcSetEnv(cOldEmp,cOldFil) 
	
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
	
	if lSFLogQry
		varinfo('M0_CODIGO',SM0->M0_CODIGO)
		varinfo('M0_CODFIL',SM0->M0_CODFIL)	
		Conout("METODO: " + PROCNAME())	   
		Conout("EMPFIL:" + EMPFIL)		
		Conout("CodVend:" + CodVend)				
	endif
	
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA)
	
	if lValida .and. !empty(::cCodProd)
		
		if !empty(::EMPFIL)
		
			nRecnoSM0 := SM0->(Recno())
			
			//remove aspas simples
			cEmpFil	:= strtran(alltrim(::EMPFIL),"'")    
			aEmpFil := StrToKArr(cEmpFil, ',') 
		
			
			aSort ( aEmpFil,,,{|x,y| x < y })		
			
			aEmpFil2 := {}
			
			for nK:=1 to Len(aEmpFil)
				
				aadd(aEmpFil2, {substr(aEmpFil[nK], 1, len(SM0->M0_CODIGO)), ;
					substr(aEmpFil[nK], len(SM0->M0_CODIGO)+1 , len(SM0->M0_CODFIL))})
				
			next nK
			            

		else				   		
			
			//se nao for passado EMPFIL, adiciona no array todas as filiais das empresas 30 e 31 (PNEUS)
			dbSelectArea("SM0")
			SM0->(dbGoTop())
			SM0->(dbSeek('30') )
			while SM0->(!eof()) .and. SM0->M0_CODIGO $ '30/31'

				aadd(aEmpFil2, {SM0->M0_CODIGO, SM0->M0_CODFIL})	

				SM0->(dbSkip())
			
			enddo    
		
		endif
		
		
		
		cCodProds	:= strtran(alltrim(::cCodProd),"'")
		cCodProds	:= Formatin(cCodProds,",")
		
		//transforma o EMPFIL em array, pois é composto de uma string concatenando empresa+filial
	
		dbSelectArea("SA3")
		
		_cCodVend := strtran(::CodVend,"'")
		
		cArmazens := ""
		if !empty(_cCodVend)
			if SA3->(dbSeek(xFilial("SA3")+ PADR(_cCodVend, Tamsx3("A3_COD")[1])))
				
				cArmazens	:= alltrim(SA3->A3_ARMAZEM)
				
				cArmazens	:= Formatin(cArmazens,"/")
				cArmazens 	:= strtran(cArmazens," ")
				
			else
				
				cArmazens	:= "('*')" //caso seja informado vendedor e nao tenha amarracao, nao traz nada
				
			endif
			
		endif
		
		nRecnoSM0 := SM0->(RECNO())
		
		
		for nI:=1 to len(aEmpFil2)
			
			cEmp	:= aEmpFil2[nI,1]
			
			dbSelectArea("SM0")
			SM0->(dbGoTop())
			if SM0->(!dbSeek(cEmp) )
				
				Loop
				
			endif					
			
			cEmp2	:= cEmp
			
			//procura as filiais da empresa posicionada e monta a string de filiais
			nJ := nI
			cFiliais :=""
			do while cEmp == cEmp2
				
				cFiliais += aEmpFil2[nJ,2]+"/"
				nJ++
				
				if nJ <= len(aEmpFil2)
					cEmp2 := aEmpFil2[nJ,1]
				else
					cEmp2 := ""
				endif
				
			enddo
			//para na posicao seguinte a ultima empresa analisada
			nI := nJ-1
			
			cFiliais	:= substr(cFiliais,1,len(cFiliais)-1)
			
			cFiliais	:= Formatin(cFiliais,"/")
			
			cLote		:= strtran(cLote,"'","")
			PESQLOTE	:= strtran(PESQLOTE,"'","")
			
			//varinfo("lAchou : ", lAchou)
			if UPPER(PESQLOTE)<>"S"
			
			
				cQuery := "SELECT B1_COD COD, B1_GRUPO GRUPO, B1_DESC DESCR, B2_FILIAL FILIAL, "
				cQuery += "       SUM(B2_QATU) QATU, SUM(B2_QEMP+B2_RESERVA+B2_QACLASS) EMPENHO, "
				cQuery += "		SUM(B2_QATU-B2_QEMP-B2_RESERVA-B2_QACLASS) ESTDISP "
				cQuery += "       FROM SB1CMP B1
				cQuery += "            LEFT JOIN SB2"+cEmp+"0 B2  ON B1_COD = B2_COD and B2.D_E_L_E_T_ <> '*'  "      
				cQuery += "         AND B2_FILIAL IN "+ cFiliais 
				if !empty(_cCodVend)					
					cQuery += "         AND B2_LOCAL  IN " +cArmazens					
				endif
				cQuery += "       WHERE B1.D_E_L_E_T_ <>'*' "                                           
				cQuery += "         AND B1_COD IN "+cCodProds				
				cQuery += "  GROUP BY B1_COD, B1_GRUPO, B1_DESC, B2_FILIAL"
				cQuery += "  ORDER BY B1_COD, B2_FILIAL"
				
			else
			
				cQuery := "SELECT B1_COD COD, B8_LOTECTL LOTECTL, B1_GRUPO GRUPO, B1_DESC DESCR, B8_FILIAL FILIAL, "
				cQuery += "       SUM(B8_SALDO) QATU, SUM(B8_EMPENHO) EMPENHO, "
				cQuery += "		SUM(B8_SALDO-B8_EMPENHO) ESTDISP "
				cQuery += "       FROM SB1CMP B1 "
				cQuery += "            LEFT JOIN  SB8"+cEmp+"0 B8 ON B1_COD = B8_PRODUTO and B8.D_E_L_E_T_ <> '*' "
				cQuery += "         AND B8_FILIAL IN "+ cFiliais
				if !empty(_cCodVend)					
					cQuery += "         AND B8_LOCAL  IN " +cArmazens					
				endif
											
				if !empty(cLote)
					cQuery += "         AND B8_LOTECTL ='"+ cLote + "'"
				endif				
				cQuery += "       WHERE B1.D_E_L_E_T_ <>'*' "
				cQuery += "         AND B1_COD IN "+cCodProds											
				cQuery += "  GROUP BY B1_COD,B8_LOTECTL, B1_GRUPO, B1_DESC, B8_FILIAL"
			   	cQuery += "  HAVING SUM(B8_SALDO)> 0 "
				cQuery += "  ORDER BY B1_COD,B8_LOTECTL, B8_FILIAL"				
				
			endif
			
			if select("TEMP")!=0
				TEMP->(dbCloseArea())
			endif
			
			TCQUERY cQuery NEW ALIAS "TEMP"
	
			if lSFLogQry
				varinfo("cQuery: " , cQuery)
			endif
			
			TEMP->(dbGotop())
			
			DO while TEMP->(!EOF())
				
				oObj := WSClassNew("_StruEstoque")
				aadd(::_StruEst,oObj)
				nX++
				
				::_StruEst[nX]:empresa  := cEmp
				::_StruEst[nX]:cfilial  := TEMP->FILIAL //iif(empty(TEMP->FILIAL)," ",TEMP->FILIAL)
				::_StruEst[nX]:ccod     := ALLTRIM(TEMP->COD)
				::_StruEst[nX]:cgrupo   := ALLTRIM(TEMP->GRUPO)
				::_StruEst[nX]:cdesc    := ALLTRIM(TEMP->DESCR)
				
				if UPPER(PESQLOTE)=="S"
					::_StruEst[nX]:cLote    := ALLTRIM(TEMP->LOTECTL)
				endif
				
				::_StruEst[nX]:nestatu  := TEMP->QATU
				::_StruEst[nX]:nempenho := TEMP->EMPENHO
				::_StruEst[nX]:nestdisp := TEMP->ESTDISP
				::_StruEst[nX]:ncusto   := 0 //TEMP->CM

				TEMP->(dbSkip())
				
			EndDo

			TEMP->(dbCloseArea())
			
			
		next nI
		
		SM0->(dbGoTo(nRecnoSM0))
		
	endif
	
	if len(::_StruEst)==0
				
		oObj := WSClassNew("_StruEstoque")
		aadd(::_StruEst,oObj)
		nX++
		
		::_StruEst[nX]:empresa  := cEmp
		::_StruEst[nX]:cfilial  := ''
		::_StruEst[nX]:ccod     := ''
		::_StruEst[nX]:cgrupo   := ''
		::_StruEst[nX]:cdesc    := ''
		::_StruEst[nX]:cLote    := ''
		::_StruEst[nX]:nestatu  := 0
		::_StruEst[nX]:nempenho := 0
		::_StruEst[nX]:nestdisp := 0
		::_StruEst[nX]:ncusto   := 0 //TEMP->CM
	
	endif
		
	//varinfo(PROCNAME(),_StruEst)	
	
   //	RpcClearEnv()	
	//RpcSetType(3)  
	//RpcSetEnv(cOldEmp,cOldFil)
	
Return .T. 

/** Método de busca do estoque **/
WSMETHOD BuscaEstLote WSRECEIVE USUARIO, EMPFIL, CodVend, cCodProd   WSSEND _StruEst WSSERVICE WS_SALESFORCE
	local lValida	:= .F.
	local aEmpFil	:= {}
	local aEmp		:= {}
	local nI, nK
	local cEmpFil	:=""
	local cOldEmp	:= '30'
	local cOldFil	:= '01'
	local nX 		:= 0
	local cEmp		:= ""
	
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil//RpcSetEnv(cOldEmp,cOldFil)
	
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
	
	if lSFLogQry
		Conout("METODO: " + PROCNAME())
	endif
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA)
	
	if lValida .and. !empty(::EMPFIL) .and. !empty(::cCodProd) 
		
		nRecnoSM0 := SM0->(Recno())
		
		//remove aspas simples
		cEmpFil	:= strtran(alltrim(::EMPFIL),"'")
		cCodProds	:= strtran(alltrim(::cCodProd),"'")
		cCodProds	:= Formatin(cCodProds,",")
		
		//transforma o EMPFIL em array, pois é composto de uma string concatenando empresa+filial
		
		aEmpFil := StrToKArr(cEmpFil, ',')
		aSort ( aEmpFil,,,{|x,y| x < y })
		
		aEmpFil2 := {}
		
		for nK:=1 to Len(aEmpFil)
			
			aadd(aEmpFil2, {substr(aEmpFil[nK], 1, len(SM0->M0_CODIGO)), ;
				substr(aEmpFil[nK], len(SM0->M0_CODIGO)+1 , len(SM0->M0_CODFIL))})
			
		next nK
		
		dbSelectArea("SA3")
		
		_cCodVend := strtran(::CodVend,"'")
		
		cArmazens := ""
		if !empty(_cCodVend)
			if SA3->(dbSeek(xFilial("SA3")+ PADR(_cCodVend, Tamsx3("A3_COD")[1])))
				
				cArmazens	:= alltrim(SA3->A3_ARMAZEM)
				
				cArmazens	:= Formatin(cArmazens,"/")
				
			else
				
				cArmazens	:= "('*')" //caso seja informado vendedor e nao tenha amarracao, nao traz nada
				
			endif
			
		endif
		
		nRecnoSM0 := SM0->(RECNO())
		
		
		for nI:=1 to len(aEmpFil2)
			
			cEmp	:= aEmpFil2[nI,1]
			
			dbSelectArea("SM0")
			SM0->(dbGoTop())
			if SM0->(!dbSeek(cEmp) )
				
				Loop
				
			endif
					
			cEmp2	:= cEmp
			
			//procura as filiais da empresa posicionada e monta a string de filiais
			nJ := nI
			cFiliais :=""
			do while cEmp == cEmp2
				
				cFiliais += aEmpFil2[nJ,2]+"/"
				nJ++
				
				if nJ <= len(aEmpFil2)
					cEmp2 := aEmpFil2[nJ,1]
				else
					cEmp2 := ""
				endif
				
			enddo
			//para na posicao seguinte a ultima empresa analisada
			nI := nJ-1
			
			cFiliais	:= substr(cFiliais,1,len(cFiliais)-1)
			
			cFiliais	:= Formatin(cFiliais,"/")
			
					
			// parametro vira assim
			//cTeste := "{{'produto1','lote1'}, {'produto2' , 'lote2'}}"
	
			aProdLote	:= {} 
			aProdLote	:= &cCodProd 
			cQryProd	:= ""
			
			for nJ:=1 to Len(aProdLote)
			
				cQryProd+= "(B8_PRODUTO ='" + alltrim(aProdLote[nJ,1])+"' AND B8_LOTECTL ='"+ alltrim(aProdLote[nJ,2]) +"')"
			                                                                                             
				if nJ < Len(aProdLote)
					
					cQryProd += " OR "
					
				endif
				
			next
			
			cQuery := "SELECT B1_COD COD, B8_LOTECTL LOTECTL, B1_GRUPO GRUPO, B1_DESC DESCR, B8_FILIAL FILIAL, "
			cQuery += "       SUM(B8_SALDO) QATU, SUM(B8_EMPENHO) EMPENHO, "
			cQuery += "		SUM(B8_SALDO-B8_EMPENHO) ESTDISP "
			cQuery += "       FROM SB1CMP B1 "
			cQuery += "            LEFT JOIN SB8"+cEmp+"0 B8  ON B1_COD = B8_PRODUTO and B8.D_E_L_E_T_ <> '*' "
			
			if len(cQryProd)>0
				cQuery += " AND (" + cQryProd +")"
			endif
						
			cQuery += "         AND B8_FILIAL IN "+ cFiliais
							
			if !empty(_cCodVend)
				
				cQuery += "         AND B8_LOCAL  IN " +cArmazens
				
			endif			                    
			
			cQuery += "       WHERE B1.D_E_L_E_T_ <>'*' "
			
			cQuery += "  GROUP BY B1_COD,B8_LOTECTL, B1_GRUPO, B1_DESC, B8_FILIAL"
			cQuery += "  HAVING SUM(B8_SALDO)> 0 "
			cQuery += "  ORDER BY B1_COD,B8_LOTECTL, B8_FILIAL"
			TCQUERY cQuery NEW ALIAS "TEMP"
				
			if select("TEMP")!=0
				TEMP->(dbCloseArea())
			endif
			
			TCQUERY cQuery NEW ALIAS "TEMP"

			if lSFLogQry
				varinfo("cQuery: " , cQuery)
			endif
			
			TEMP->(dbGotop())
			
			DO while TEMP->(!EOF())
				
				oObj := WSClassNew("_StruEstoque")
				aadd(::_StruEst,oObj)
				nX++
				
				::_StruEst[nX]:empresa  := cEmp
				::_StruEst[nX]:cfilial  := TEMP->FILIAL
				::_StruEst[nX]:ccod     := ALLTRIM(TEMP->COD)
				::_StruEst[nX]:cgrupo   := ALLTRIM(TEMP->GRUPO)
				::_StruEst[nX]:cdesc    := ALLTRIM(TEMP->DESCR)
				
				::_StruEst[nX]:cLote    := ALLTRIM(TEMP->LOTECTL)
								
				::_StruEst[nX]:nestatu  := TEMP->QATU
				::_StruEst[nX]:nempenho := TEMP->EMPENHO
				::_StruEst[nX]:nestdisp := TEMP->ESTDISP
				::_StruEst[nX]:ncusto   := 0 //TEMP->CM
				
				TEMP->(dbSkip())
				
			EndDo

			
			TEMP->(dbCloseArea())
			
			
		next nI
		
		SM0->(dbGoTo(nRecnoSM0))
	
	endif
	
	if len(::_StruEst)==0
	   
		oObj := WSClassNew("_StruEstoque")
		aadd(::_StruEst,oObj)
		nX++
		
		::_StruEst[nX]:empresa  := cEmp
		::_StruEst[nX]:cfilial  := ''
		::_StruEst[nX]:ccod     := ''
		::_StruEst[nX]:cgrupo   := ''
		::_StruEst[nX]:cdesc    := ''
		::_StruEst[nX]:cLote    := ''
		::_StruEst[nX]:nestatu  := 0
		::_StruEst[nX]:nempenho := 0
		::_StruEst[nX]:nestdisp := 0
		::_StruEst[nX]:ncusto   := 0
		
		
	endif
	
	//varinfo(PROCNAME(),_StruEst)	
		
   //	RpcClearEnv()	
	//RpcSetType(3)  
	//RpcSetEnv(cOldEmp,cOldFil)
	
Return .T.

/** Método de busca limite do cliente **/
WSMETHOD BuscaLC WSRECEIVE USUARIO, cCodCli, cLojaCli WSSEND _StruCliLC WSSERVICE WS_SALESFORCE
	local lValida	:= .F.
	local nX		:= 0
	
	Conout("METODO: " + PROCNAME())
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA)
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01' //RpcSetEnv('30','01')
	
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
	
	
	
	if lValida .and. !empty(::cCodCli) 
	
		cQuery := " SELECT A1_COD    ,"
		cQuery += "        A1_LOJA   ,"
		cQuery += "        A1_NOME   ,"
		cQuery += "        A1_LC     ,"
		cQuery += "        A1_VENCLC,"
		cQuery += "        A1_SALDUP, A1_SALPEDL,"
		cQuery += "        A1_MSBLQL,"
		cQuery += "        A1_RISCO,"
		cQuery += "        A1_OBSERV"
		cQuery += "  FROM " + RetSqlName("SA1")
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += "   AND A1_COD    = '"+cCodCli+"'"
		IF !empty(cLojaCli)
			cQuery += "   AND A1_LOJA   = '"+cLojaCli+"'"
		ENDIF
		
		if lSFLogQry
			varinfo('cQuery', cQuery)
		endif
		
		if select("TEMP")!=0
			TEMP->(dbCloseArea())
		endif
		
		TCQUERY cQuery NEW ALIAS "TEMP"
		
		
		DO while TEMP->(!EOF())
			
			oObj := WSClassNew("_StruCliente")
			aadd(::_StruCliLC,oObj)
			nX++
			
			::_StruCliLC[nX]:CodCli  := ALLTRIM(TEMP->A1_COD)
			::_StruCliLC[nX]:LojaCli := ALLTRIM(TEMP->A1_LOJA)
			::_StruCliLC[nX]:Razao   := ALLTRIM(TEMP->A1_NOME)
			::_StruCliLC[nX]:LimCred := TEMP->A1_LC
			::_StruCliLC[nX]:VencLim := alltrim(TEMP->A1_VENCLC)
			::_StruCliLC[nX]:Saldo   := TEMP->A1_LC - TEMP->(A1_SALDUP+A1_SALPEDL)  //DFT 04/03/2014
			::_StruCliLC[nX]:Bloq    := iif(TEMP->A1_MSBLQL == '1',.T.,.F.)
			::_StruCliLC[nX]:Hist    := ALLTRIM(TEMP->A1_OBSERV)
			::_StruCliLC[nX]:Risco    := ALLTRIM(TEMP->A1_RISCO)
			
			TEMP->(dbSkip())
			
		EndDo
		
		TEMP->(dbCloseArea())
	
	endif
	
	if len(::_StruCliLC)==0
	
		oObj := WSClassNew("_StruCliente")
		aadd(::_StruCliLC,oObj)
		nX++
		
		::_StruCliLC[nX]:CodCli  := ""
		::_StruCliLC[nX]:LojaCli := ""
		::_StruCliLC[nX]:Razao   := ""
		::_StruCliLC[nX]:LimCred := 0
		::_StruCliLC[nX]:VencLim := ""
		::_StruCliLC[nX]:Saldo   := 0
		::_StruCliLC[nX]:Bloq    := .F.
		::_StruCliLC[nX]:Hist    := ""
		::_StruCliLC[nX]:Risco   := ""
		
	endif
	
	//RpcClearEnv()
	
Return .T.

/** Método de busca de dados de credito do cliente **/
WSMETHOD BuscaDadCred WSRECEIVE USUARIO, cCodCli, cLojaCli WSSEND _StruDadCred WSSERVICE WS_SALESFORCE
	local lValida	:= .F.
	local nX		:= 0
	
	Conout("METODO: " + PROCNAME())
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA)
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA '30' FILIAL '01' //RpcSetEnv('30','01')
	
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
	
	if lValida .and. !empty(::cCodCli) .and. !empty(::cLojaCli)
	    
		cQuery := " SELECT A1_GRPTRIB,A1_FORMPAG,A1_VEND,A1_COND,A1_RISCO,A1_LC,A1_MCOMPRA,A1_METR,A1_ULTCOM, A1_SALPEDL , "
		cQuery += " A1_SALDUP,A1_NROPAG,A1_ATR,A1_VACUM,A1_MATR,A1_PAGATR,A1_CAPTSOC,A1_DTNASC,A1_DTCADAS,A1_MSBLQL, R_E_C_N_O_ "
		cQuery += "  FROM " +RetSqlName("SA1")
		cQuery += " WHERE D_E_L_E_T_ <> '*'"
		cQuery += "   AND A1_COD    = '"+cCodCli+"'"
		cQuery += "   AND A1_LOJA   = '"+cLojaCli+"'"
		
		if select("TEMP")!=0
			TEMP->(dbCloseArea())
		endif  
		
		if lSFLogQry
			varinfo('cQuery', cQuery)
		endif
		
		TCQUERY cQuery NEW ALIAS "TEMP"     
		  
		DO while TEMP->(!EOF())
			
			dbSelectArea("SA1")
			SA1->(dbgoto(TEMP->R_E_C_N_O_))
			
			oObj := WSClassNew("_StruDadCred")
			aadd(::_StruDadCred,oObj)
			nX++
			::_StruDadCred[nX]:GrpTrib      := alltrim(TEMP->A1_GRPTRIB)
			::_StruDadCred[nX]:FormaPag     := alltrim(TEMP->A1_FORMPAG)
			::_StruDadCred[nX]:Vendedor     := alltrim(TEMP->A1_VEND)
			::_StruDadCred[nX]:CondPag      := alltrim(TEMP->A1_COND)
			::_StruDadCred[nX]:Risco        := alltrim(TEMP->A1_RISCO)
			::_StruDadCred[nX]:LimCred      := TEMP->A1_LC
			::_StruDadCred[nX]:MaiorComp    := TEMP->A1_MCOMPRA
			::_StruDadCred[nX]:MedAtraso    := TEMP->A1_METR
			::_StruDadCred[nX]:UltCompra    := alltrim(TEMP->A1_ULTCOM)
			::_StruDadCred[nX]:SaldDuplic   := TEMP->A1_SALDUP
			::_StruDadCred[nX]:NroPagamen   := TEMP->A1_NROPAG
			::_StruDadCred[nX]:Atrasos      := TEMP->A1_ATR
			::_StruDadCred[nX]:VlrAcum      := TEMP->A1_VACUM
			::_StruDadCred[nX]:MaiorAtra    := TEMP->A1_MATR
			::_StruDadCred[nX]:PagAtras     := TEMP->A1_PAGATR
			::_StruDadCred[nX]:CapSocial    := TEMP->A1_CAPTSOC
			::_StruDadCred[nX]:DataAber     := alltrim(TEMP->A1_DTNASC)
			::_StruDadCred[nX]:DataCadas    := alltrim(TEMP->A1_DTCADAS)
			::_StruDadCred[nX]:ObsCobra     := ''//FWNOACCENT(SA1->A1_X_OBCOB)
			::_StruDadCred[nX]:ObsCadas     := ''//FWNOACCENT(SA1->A1_X_OBCAD)
			::_StruDadCred[nX]:Saldo   		:= TEMP->A1_LC - TEMP->(A1_SALDUP+A1_SALPEDL)  //DFT 04/03/2014
			::_StruDadCred[nX]:Bloq    		:= iif(TEMP->A1_MSBLQL == '1',.T.,.F.)
			
			TEMP->(dbSkip())
			
		EndDo
		
		TEMP->(dbCloseArea())
	
	endif
	
	if len(::_StruDadCred)==0
	
		oObj := WSClassNew("_StruDadCred")
		aadd(::_StruDadCred,oObj)
		nX++
		::_StruDadCred[nX]:GrpTrib      := ""
		::_StruDadCred[nX]:FormaPag     := ""
		::_StruDadCred[nX]:Vendedor     := ""
		::_StruDadCred[nX]:CondPag      := ""
		::_StruDadCred[nX]:Risco        := ""
		::_StruDadCred[nX]:LimCred      := 0
		::_StruDadCred[nX]:MaiorComp    := 0
		::_StruDadCred[nX]:MedAtraso    := 0
		::_StruDadCred[nX]:UltCompra    := ""
		::_StruDadCred[nX]:SaldDuplic   := 0
		::_StruDadCred[nX]:NroPagamen   := 0
		::_StruDadCred[nX]:Atrasos      := 0
		::_StruDadCred[nX]:VlrAcum      := 0
		::_StruDadCred[nX]:MaiorAtra    := 0
		::_StruDadCred[nX]:PagAtras     := 0
		::_StruDadCred[nX]:CapSocial    := 0
		::_StruDadCred[nX]:DataAber     := ""
		::_StruDadCred[nX]:DataCadas    := ""
		::_StruDadCred[nX]:ObsCobra     := ""
		::_StruDadCred[nX]:ObsCadas     := ""  
		::_StruDadCred[nX]:Saldo		:= 0
		::_StruDadCred[nX]:Bloq    		:= .F.
	endif
	
	//RpcClearEnv()
	
Return .T.



/* --------------------------------------------------------------------------------------
Metodo		CLIENTEINCLUIR
Autor		Devair
Descricao	Realiza a inclusao de um cliente no ERP via Webservice
Data		23/01/2015
-------------------------------------------------------------------------------------- */

WSMETHOD CLIENTEINCLUIR WSRECEIVE USUARIO, CLIINC WSSEND RSCLIRESULT WSSERVICE WS_SALESFORCE
	Local lValida		:= .F.
	
	Conout("METODO: " + PROCNAME())
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )
	
	if !lValida
				
		RSCLIRESULT:CODIGO	:= ""
		RSCLIRESULT:RETORNO	:= .F.
		RSCLIRESULT:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
		
	elseif  (lValida := VldObSA1(::CLIINC, @::RSCLIRESULT))
		
		ManutCli ("I", ::CLIINC, @::RSCLIRESULT)
		
	endif
	
Return .T.

/* --------------------------------------------------------------------------------------
Metodo		CLIENTEALTERAR
Autor		Devair
Descricao	Realiza alteracao de um cliente no ERP via Webservice
Data		23/01/2015
-------------------------------------------------------------------------------------- */

WSMETHOD CLIENTEALTERAR WSRECEIVE USUARIO, CLIALT WSSEND RSCLIRESULT WSSERVICE WS_SALESFORCE
	Local lValida		:= .F.
	
	Conout("METODO: " + PROCNAME())
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )

	if !lValida
		
		RSCLIRESULT:CODIGO	:= ""
		RSCLIRESULT:RETORNO	:= .F.
		RSCLIRESULT:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
	   
		varinfo("RSCLIRESULT", RSCLIRESULT)
		
	elseif (lValida := VldObSA1(::CLIALT, @::RSCLIRESULT))
		
		ManutCli ("A", ::CLIALT, @::RSCLIRESULT)
		
	endif
	
	
	
Return .T.

/* --------------------------------------------------------------------------------------
Metodo		PEDIDOEXISTE
Autor		Devair
Descricao	Realiza verificação se uma oportunidade existe no ERP via Webservice
Data		24/04/2015
-------------------------------------------------------------------------------------- */

WSMETHOD PEDIDOEXISTE WSRECEIVE USUARIO, CEMP, CFIL, NUMOPORTUNIDADE WSSEND RSPEDRESULT WSSERVICE WS_SALESFORCE
	Local cCpoObrig	:= "Campo obrigatorio."
	Local lValida	:= .F.
	Local cAlsSC5	:=""  
	local lLock 	:= .F.  	   
	local nCount 	:= 0
	local lSFLogQry	:= .F.
	
	Conout(time() + " METODO: " + PROCNAME())
			
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )
	
	if !lValida
				
		RSPEDRESULT:CODIGO	:= ""
		RSPEDRESULT:RETORNO	:= .F.
		RSPEDRESULT:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
		varinfo("RSPEDRESULT", RSPEDRESULT)
		
	elseif empty(::CEMP)
		
				
		RSPEDRESULT:CODIGO	:= ""
		RSPEDRESULT:RETORNO	:= .F.
		RSPEDRESULT:MENSERRO	:= "EMPRESA: "+ cCpoObrig
		varinfo("RSPEDRESULT", RSPEDRESULT)
		
	elseif empty(::CFIL)
		
		RSPEDRESULT:CODIGO	:= ""
		RSPEDRESULT:RETORNO	:= .F.
		RSPEDRESULT:MENSERRO	:= "FILIAL: "+ cCpoObrig
		varinfo("RSPEDRESULT", RSPEDRESULT)

	else
		
		RpcClearEnv()
		RpcSetType(3)
		PREPARE ENVIRONMENT EMPRESA ::cEmp FILIAL ::cFil //		RpcSetEnv(::cEmp, ::cFil)
		
		lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
			
		Conout(time() + " EMPRESA/FILIAL " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
				
		cSemaforo := "PEDIDO"+alltrim(::NUMOPORTUNIDADE)	   
	   
		lLock 	:= .F.  	   
		nCount 	:= 0
		while !lLock .and. nCount < 20
	    	lLock	:= LockByName(cSemaforo,.T.,.T.,.T.)  			
			sleep(1000)		
			nCount++		                                		
			if !lLock
				conout("ESPERANDO PROCESSAR OPORTUNIDADE " + ::NUMOPORTUNIDADE ) 
			endif
		enddo
			
		if !lLock 
		
			RSPEDRESULT:CODIGO 	:= ""
			RSPEDRESULT:RETORNO	:= .F.
			RSPEDRESULT:MENSERRO:= "A tentativa de integracao falhou. Tente enviar novamente para o ERP."					 
			return   .T.
		endif
		
		cAlsSC5 := GetNextAlias()
		BEGINSQL Alias cAlsSC5
			SELECT C5_NUM
			FROM %table:SC5%
			WHERE
			C5_FILIAL = %exp:SM0->M0_CODFIL%
			AND C5_X_NUMPD = %exp:padr(NUMOPORTUNIDADE, TAMSX3("C5_X_NUMPD")[1])%
			AND %NOTDEL%			
		ENDSQL
		
		if !empty((cAlsSC5)->C5_NUM)
			
			RSPEDRESULT:CODIGO 	:= (cAlsSC5)->C5_NUM
			RSPEDRESULT:RETORNO	:= .T.
			RSPEDRESULT:MENSERRO:= "Oportunidade ja existe no ERP para esta empresa/filial: " + ::NUMOPORTUNIDADE    
			
		else

			RSPEDRESULT:CODIGO 	:= ""
			RSPEDRESULT:RETORNO	:= .F.
			RSPEDRESULT:MENSERRO:= ""
			
		endif	
		
		(cAlsSC5)->(dbCloseArea())
		
		if lSFLogQry 
			varinfo("RSPEDRESULT", RSPEDRESULT)
		endif
		
		UnLockByName(cSemaforo,.T.,.T.)		
		
	endif
	
Return .T.

/* --------------------------------------------------------------------------------------
Metodo		PEDIDOINCLUIR
Autor		Devair
Descricao	Realiza inclusoa de um pedido no ERP via Webservice
Data		26/01/2015
-------------------------------------------------------------------------------------- */

WSMETHOD PEDIDOINCLUIR WSRECEIVE USUARIO, CEMP, CFIL, PEDINC WSSEND RSPEDRESULT WSSERVICE WS_SALESFORCE
	Local cCpoObrig	:= "Campo obrigatorio."
	Local lValida	:= .F.

	RSPEDRESULT:CODIGO	:= ""
	RSPEDRESULT:RETORNO	:= .F.
		
	Conout(time() + " METODO: " + PROCNAME())
			
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )
		
	if !lValida

		RSPEDRESULT:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
	
	elseif empty(::CEMP)
		
		RSPEDRESULT:MENSERRO	:= "EMPRESA: "+ cCpoObrig
			
	elseif empty(::CFIL)
		
		RSPEDRESULT:MENSERRO	:= "FILIAL: "+ cCpoObrig
		
	else
		
		GravaPedido (::CEMP, ::CFIL, ::PEDINC, @::RSPEDRESULT)
		
	endif
	
Return .T.


/* --------------------------------------------------------------------------------------
Metodo		RESERVAINCLUIR
Autor		Devair
Descricao	Realiza a inclusao de um reserva no ERP via Webservice
Data		10/02/2015
-------------------------------------------------------------------------------------- */

WSMETHOD RESERVAINCLUIR WSRECEIVE USUARIO, CEMP, CFIL, NUMOPORTUNIDADE,  RESERVA WSSEND RSRESRESULT WSSERVICE WS_SALESFORCE
	Local cCpoObrig	:= "Campo obrigatorio."
	Local lValida		:= .F.
	Local nX			:=0
	
	Conout("METODO: " + PROCNAME())

	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )  
	
	oObj := WSClassNew("STSFRETRES")
	aadd(::RSRESRESULT,oObj)
	nX++
	::RSRESRESULT[nX]:CODIGO	:= ""
	::RSRESRESULT[nX]:RETORNO	:= .F.
	::RSRESRESULT[nX]:MENSERRO	:= "Funcao nao homologada"    
	
	Return .T.
	
	if !lValida
		
		varinfo("RESERVA: ", RESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	elseif empty(::CEMP)
		
		varinfo("RESERVA: ", RESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "EMPRESA: "+ cCpoObrig
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	elseif empty(::CFIL)
		
		varinfo("RESERVA: ", RESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "FILIAL: "+ cCpoObrig  
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	else
		
		ManutRes  (::CEMP, ::CFIL, "I", ::NUMOPORTUNIDADE, ::RESERVA, @::RSRESRESULT)
		
	endif
	
Return .T.



/* --------------------------------------------------------------------------------------
Metodo		RESERVACANCELAR
Autor		Devair
Descricao	Realiza cancelamento de um reserva no ERP via Webservice
Data		12/02/2015
-------------------------------------------------------------------------------------- */

WSMETHOD RESERVACANCELAR WSRECEIVE USUARIO, CEMP, CFIL, NUMRESERVA WSSEND RSRESRESULT WSSERVICE WS_SALESFORCE
	Local cCpoObrig	:= "Campo obrigatorio."
	Local lValida		:= .F.
	Local nX			:=0
	
	Conout("METODO: " + PROCNAME())
		
	lValida := U_VLUSERWS(::USUARIO:USUARIO, ::USUARIO:SENHA )
	
	oObj := WSClassNew("STSFRETRES")
	aadd(::RSRESRESULT,oObj)
	nX++
	::RSRESRESULT[nX]:CODIGO	:= ""
	::RSRESRESULT[nX]:RETORNO	:= .F.
	::RSRESRESULT[nX]:MENSERRO	:= "Funcao nao homologada"    
	
	Return .T.
	
	if !lValida
		
		varinfo("NUMRESERVA: ", ::NUMRESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "USUARIO: usuario nao autorizado a utilizar este servico"
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	elseif empty(::CEMP)
		
		varinfo("NUMRESERVA: ", ::NUMRESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "EMPRESA: "+ cCpoObrig
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	elseif empty(::CFIL)
		
		varinfo("NUMRESERVA: ", ::NUMRESERVA)
		
		oObj := WSClassNew("STSFRETRES")
		aadd(::RSRESRESULT,oObj)
		nX++
		::RSRESRESULT[nX]:CODIGO	:= ""
		::RSRESRESULT[nX]:RETORNO	:= .F.
		::RSRESRESULT[nX]:MENSERRO	:= "FILIAL: "+ cCpoObrig 
		
		varinfo("RSRESRESULT", RSRESRESULT)
		
	else
		
		CancRes  (::CEMP, ::CFIL, ::NUMRESERVA, @::RSRESRESULT)
		
	endif
	
Return .T.


//#####################################################################################################################################
//
// SEPARACAO DOS METODOS DO WEBSERVICE DAS FUNCOES
//
//#####################################################################################################################################



/* --------------------------------------------------------------------------------------
Funcao		PadCEP
Autor		Devair
Descricao	Padroniza o CEP conforme o ERP
Data		23/01/2015
-------------------------------------------------------------------------------------- */

Static Function PadCEP(cCep)
	
	cCep := alltrim(cCep)
	cCep := strtran(cCep,"-","")
	cCep := padr(cCep, tamsx3("A1_CEP")[1])
	
Return cCep

/* --------------------------------------------------------------------------------------
Funcao		PadCGC
Autor		Devair
Descricao	Padroniza o CGC conforme o ERP
Data		23/01/2015
-------------------------------------------------------------------------------------- */

Static Function PadCGC(cCGC)

	cCGC := alltrim(cCGC)
	cCGC := strtran(cCGC,".","")
	cCGC := strtran(cCGC,"/","")
	cCGC := strtran(cCGC,"-","")
	cCGC := padr(cCGC, tamsx3("A1_CGC")[1])
	
Return cCGC

/* --------------------------------------------------------------------------------------
Funcao		PadCodCli
Autor		Devair
Descricao	Padroniza o codigo e loja do cliente conforme regra da empresa
Data		23/01/2015
-------------------------------------------------------------------------------------- */

Static Function PadCodCli(oObjCli, cCod, cLoja)
	
	Local cSA1CGC := PadCGC(oObjCli:CGC) 	//Remove pontos, barras e hifens

	if oObjCli:PESSOA =="F"
		
		cCod	:= substr(cSA1CGC,1,9)
		cLoja	:= "0001"
		
	else
		
		cCod	:= substr(cSA1CGC,1,8)
		
		cLoja	:= substr(cSA1CGC,9,4)
		
	endif
	
	cCod	:= padr(cCod	, tamsx3("A1_COD")[1])
	cLoja	:= padr(cLoja	, tamsx3("A1_LOJA")[1])
	
Return


/* --------------------------------------------------------------------------------------
Funcao		VldObSA1
Autor		Devair
Descricao	Valida alguns campos obrigratorios
Data		23/01/2015
-------------------------------------------------------------------------------------- */
Static Function VldObSA1(oObjCli, oObjRet)
	
	Local cCpoObrig	:= "Campo obrigatorio."
	Local lRet		:= .T.
	

	if !(alltrim(oObjCli:PESSOA) $ "F/J")
		
		varinfo("OCLIENTE: ", oObjCli)
		oObjRet:CODIGO	:= ""
		oObjRet:RETORNO	:= .F.
		oObjRet:MENSERRO	:= "PESSOA: Conteudo deve ser (F, J)"
		
		varinfo("oObjRet", oObjRet)
		
		lRet := .F.
		
	elseif empty(oObjCli:CGC)
		
		varinfo("oObjCli: ", oObjCli)
		oObjRet:CODIGO	:= ""
		oObjRet:RETORNO	:= .F.
		oObjRet:MENSERRO	:= "PESSOA: CGC nao informado"
		
		varinfo("oObjRet", oObjRet)
			
		lRet := .F.
		
	endif
	
Return lRet


/* --------------------------------------------------------------------------------------
Funcao		Funcao para incluir ou alterar um cliente
Autor		Devair
Descricao	Realiza manutencao do cadastro de cliente no ERP
Data		23/01/2015
-------------------------------------------------------------------------------------- */
Static Function ManutCli (cOpc, oObjCli, oObjRet)
	Local cSA1FILIAL	:= ""
	local cSA1CGC		:= ""
	local aDados		:= {}
	local cSA1COD		:= ""
	local cSA1LOJA	:= ""
	local cErro		:= ""
	Local aErro		:= {}
	Local lContinua	:= .T.
	Local cOldEmp		:= '30'
	Local cOldFil		:= '01'

	
	private lMsErroAuto 		:= .F.
	private lAutoErrNoFile 	:= .T.
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil //RpcSetEnv(cOldEmp,cOldFil) 
	
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)

	aArea := GetArea()
	
	//controi o codigo e loja conforme regra Cantu
	PadCodCli(oObjCli, @cSA1COD, @cSA1LOJA)
	
	
	//Padroniza o CNPJ e CPF conforme o ERP
	cSA1CGC 		:= PadCGC(oObjCli:CGC)
	
	//Verifica se o cliente existe pelo CGC
	dbSelectArea("SA1")
	SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_CGC") ) )
	lTemSA1:= SA1->( dbSeek( xFilial("SA1") + cSA1CGC  ) )
	
	if lSFLogQry
		varinfo("oObjCli: ", oObjCli)
	endif
	
	if cOpc=="I" //Se for inclusao
		
		if lTemSA1
						
			oObjRet:CODIGO	:= SA1->A1_COD + SA1->A1_LOJA
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO	:= "CLIENTE: Cliente ja cadastrado: " + oObjCli:CGC + " (" + SA1->A1_COD +" - "+ SA1->A1_LOJA +")"
			SA1->(dbCloseArea())
			
			if lSFLogQry
				varinfo("oObjCli: ", oObjCli)
			endif
				
			lContinua	:= .F.
			
		else
			
			SA1->(dbCloseArea())
			
			aadd(aDados,{"A1_COD"		, cSA1COD	,})
			aadd(aDados,{"A1_LOJA"		, cSA1LOJA	,})
			
		endif
		
	else
		
		if !lTemSA1
					
			oObjRet:CODIGO	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO	:= "CLIENTE: Cliente nao encontrado: " + oObjCli:CGC
								
			if lSFLogQry
				varinfo("oObjCli: ", oObjCli)
			endif
		
			lContinua	:= .F.
			
		else
			
			aadd(aDados,{"A1_COD"		, SA1->A1_COD	,})
			aadd(aDados,{"A1_LOJA"		, SA1->A1_LOJA	,})
			
		endif
		
	endif
	
	
	if !empty(oObjCli:CLPAI) .and. !empty(oObjCli:LJPAI)			
         
        SA1->(dbSetOrder(1))
        
		if SA1->(!dbSeek(xFilial('SA1')+oObjCli:CLPAI+oObjCli:LJPAI))
	       
	    	oObjRet:CODIGO	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO:= "CLIENTE: Cliente pai nao encontrado no ERP " + oObjCli:CLPAI+"/"+oObjCli:LJPAI
			
			if lSFLogQry
				varinfo("oObjCli: ", oObjCli)
			endif
			
			lContinua	:= .F.           	   
	    
		endif
	
	endif
	
	
	if lContinua
		
		BEGIN SEQUENCE
			
			aadd(aDados,{"A1_PESSOA"	, UPPER(oObjCli:PESSOA)		,})
			aadd(aDados,{"A1_NOME"		, FWNOACCENT(UPPER(oObjCli:NOME))	 	,})
			aadd(aDados,{"A1_NREDUZ"	, FWNOACCENT(UPPER(oObjCli:NREDUZ))		,})
			
			//if !EMPTY(oObjCli:NUMERO )
			//	aadd(aDados,{"A1_END" , FWNOACCENT(UPPER(oObjCli:ENDERECO)+ ", "+alltrim(oObjCli:NUMERO)) ,})
				
			//else
				aadd(aDados,{"A1_END" , FWNOACCENT(UPPER(oObjCli:ENDERECO))	,})
			//endif
			
			aadd(aDados,{"A1_TIPO"		, UPPER(oObjCli:TIPO)		,})
			aadd(aDados,{"A1_EST"		, UPPER(oObjCli:ESTADO)		,})
			aadd(aDados,{"A1_COD_MUN"	, oObjCli:CODMUN			,})
			
			//busca descricao do municipio
			dbSelectArea("CC2")
			CC2->(dbSetOrder(1))
			if CC2->(dbseek(xFilial('CC2')+ PADR(oObjCli:ESTADO,TAMSX3("CC2_EST")[1])+PADR(oObjCli:CODMUN,TAMSX3("CC2_CODMUN")[1])))
				
				aadd(aDados,{"A1_MUN"	, CC2->CC2_MUN		,})
				
			endif
			
			
			aadd(aDados,{"A1_BAIRRO"	, FWNOACCENT(UPPER(oObjCli:BAIRRO))		,})
			aadd(aDados,{"A1_COMPLEM"	, FWNOACCENT(UPPER(oObjCli:COMPLEM))	,})
			aadd(aDados,{"A1_CEP"		, PadCEP(oObjCli:CEP)		,})
			aadd(aDados,{"A1_DDD"		, oObjCli:DDD				,})
			aadd(aDados,{"A1_TEL"		, oObjCli:TELEFONE			,})
			aadd(aDados,{"A1_FAX"		, oObjCli:FAX				,})
			
			//busca codigo do pais
			dbSelectArea("SYA")
			SYA->(dbSetOrder(RetOrder("SYA", "YA_FILIAL+YA_DESCR")))
			if SYA->(dbSeek(xFilial("SYA")+padr(FWNOACCENT(UPPER(oObjCli:PAIS)),tamsx3("YA_DESCR")[1])))
				aadd(aDados,{"A1_PAIS", padr(SYA->YA_CODGI,tamsx3("A1_PAIS")[1])	,})
			endif
			SYA->(dbSetOrder(RetOrder("SYA", "YA_FILIAL+YA_CODGI")))
			
			if cOpc=="I"
				aadd(aDados,{"A1_EMAIL"		, oObjCli:EMAIL		,})
				aadd(aDados,{"A1_CGC"		, cSA1CGC			,}) 
				aadd(aDados,{"A1_X_ENVSF", 'S' 					,})     
				
			endif
			
			aadd(aDados,{"A1_X_MAILN"	, oObjCli:EMAILNFE	,})
			aadd(aDados,{"A1_INSCR"		, oObjCli:IESTADUAL	,})
			aadd(aDados,{"A1_COND"		, oObjCli:CONDPAG	,}) 
			aadd(aDados,{"A1_LC"		, oObjCli:LC	,})
			
				
			if !empty(oObjCli:VENCLC)		
				aadd(aDados,{"A1_VENCLC"	, STOD(oObjCli:VENCLC)	,}) 
			endif
			
			//aadd(aDados,{"A1_QTDVEIC"	, oObjCli:QTDVEILEV	,})
			//aadd(aDados,{"A1_QDTVEI1"	, oObjCli:QTDVEIPES	,})
			aadd(aDados,{"A1_GRPTRIB"	, oObjCli:GRTRIB    ,})
			aadd(aDados,{"A1_FORMPAG"	, oObjCli:FROMPAG   ,})
			aadd(aDados,{"A1_VEND"		, oObjCli:VEND      ,})
			aadd(aDados,{"A1_RISCO"		, oObjCli:RISCO     ,})
			aadd(aDados,{"A1_DTNASC" 	, STOD(oObjCli:DTNASC),})
			aadd(aDados,{"A1_CAPTSOC"	, oObjCli:CAPTSOC   ,})
			//aadd(aDados,{"A1_X_OBCOB"	, FWNOACCENT(oObjCli:OBCOB)    ,}) //SOLICITACAO ALEX ATE RESOLVER PROBLEMA INTEGRACAO ERP X SF
			aadd(aDados,{"A1_X_OBCAD"	, FWNOACCENT(oObjCli:OBCAD)    ,})
			aadd(aDados,{"A1_X_SERAS"   , oObjCli:ENVIASERASA,})
			aadd(aDados,{"A1_CONTRIB"   , oObjCli:CONTRIB,})
			aadd(aDados,{"A1_SIMPNAC"   , oObjCli:SIMPNAC,})
			 
			aadd(aDados,{"A1_X_COBEX"   , oObjCli:COBEXT,}) 
			aadd(aDados,{"A1_GRPVEN"  	, oObjCli:GRPVEN,})			
			aadd(aDados,{"A1_X_SCOBR"  	, oObjCli:SITCOB,})			
			aadd(aDados,{"A1_X_GRLEV"  	, oObjCli:GRLEV,}) 
			
			if !empty(oObjCli:CLPAI) .and. !empty(oObjCli:LJPAI)
		
				aadd(aDados,{"A1_X_CLPAI"  	, oObjCli:CLPAI,})			
				aadd(aDados,{"A1_X_LJPAI"  	, oObjCli:LJPAI,})
		
			endif
			   
			
			if !empty(oObjCli:DTCADAS)
				aadd(aDados,{"A1_DTCADAS"   , STOD(oObjCli:DTCADAS),})
			endif
			
			aadd(aDados,{"A1_MSBLQL"    , oObjCli:ATIVO  ,})
			
			//busca codigo do pais bacen
			dbSelectArea("CCH")
			CCH->(dbSetOrder( RetOrder("CCH", "CCH_FILIAL+CCH_PAIS" )))
			if CCH->(dbSeek(xFilial("CCH")+padr(oObjCli:PAIS,tamsx3("CCH_PAIS")[1])))
				aadd(aDados,{"A1_CODPAIS", CCH->CCH_CODIGO	,})
			endif
			CCH->(dbSetOrder( RetOrder("CCH", "CCH_FILIAL+CCH_CODIGO" )))
			
		
			
			aDados := WsAutoOpc(aDados) 
			
			if lSFLogQry
				varinfo("aDados", aDados)
			endif			
			
			if cOpc=="I"
				
				MSExecAuto({|x,y| MATA030(x,y)},aDados,3)  //inclusao
				
			else
				
				MSExecAuto({|x,y| MATA030(x,y)},aDados,4) //alteracao
				
			endif
			
			If lMsErroAuto
				
				aErro := GetAutoGRLog()
				cErro := ""
		
				cErro := TrErrAut(aErro, 1)
				cErro += TrErrAut(aErro, 2,  "<")+CRLF 
				
				if lSFLogQry
					varinfo("aErro: ", aErro)
					varinfo("cErro: ", cErro)
				endif
						
				if cOpc=="A"
					
					oObjRet:CODIGO	:= cSA1COD + cSA1LOJA
					
				endif
				
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO	:= ENCODEUTF8(ANSIToOEM (FwNoAccent(cErro)))
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)
				endif
				
				DisarmTransaction()
				
				
			Else
				
				oObjRet:CODIGO 	:= cSA1COD + cSA1LOJA
				oObjRet:RETORNO	:= .T.
			
				if lSFLogQry
					varinfo("oObjRet", oObjRet)
				endif
			EndIf
			
		END SEQUENCE
		
	EndIf
	
 //	RpcClearEnv()	
 //	RpcSetType(3)  
 //	RpcSetEnv(cOldEmp,cOldFil)
	
	
 //	RestArea(aArea)
Return .T.


/* --------------------------------------------------------------------------------------
Funcao		Funcao para incluir ou cancelar uma reserva
Autor		Devair
Descricao	Realiza manutencao do cadastro de reserva do ERP
Data		11/02/2015
-------------------------------------------------------------------------------------- */
Static Function ManutRes (cEmp, cFil, cOpc, cNumOpor, oObjRes, oObjRet)
	Local cOldEmp		:= cEmp
	Local cOldFil		:= cFil
	local aOperacao 	:= {}
	Local cProduto 		:= ""
	Local cLOCAL    	:= ""
	Local nQUANT    	:= 0
	Local aLOTE     	:= {} // {"","","",""}
	local cLote			:= ""
	local aHeader		:= {}
	local aCols			:= {}
	local nQuantElim	:= 0
	local ItemRes		:= {}
	local cErro			:= ""
	local nX			:= 0
	local cSolicit		:= ""
	local aArea			
	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil  //RpcSetEnv(cOldEmp,cOldFil)
	
	aArea			:= GetArea()
		
	CHKFILE("SC0")
	
	varinfo("oObjRes", oObjRes)
	
	if SC0->(FieldPos("C0_X_NUMPD"))!=0 
	
		cAlsSC0 := GetNextAlias()
		BEGINSQL Alias cAlsSC0
			SELECT C0_NUM
			FROM %table:SC0%
			WHERE
			C0_FILIAL = %exp:SM0->M0_CODFIL%
			AND C0_X_NUMPD = %exp:padr(cNumOpor, TAMSX3("C0_X_NUMPD")[1])%
			AND %NOTDEL%
			
		ENDSQL
		
		if !empty((cAlsSC0)->C0_NUM)
		
			oObj := WSClassNew("STSFRETRES")
			aadd(oObjRet,oObj)
			nX++
			oObjRet[nX]:CODIGO	:= (cAlsSC0)->C0_NUM
			oObjRet[nX]:RETORNO	:= .F.
			oObjRet[nX]:MENSERRO	:= "Ja existe reserva para este numero de oportunidade. [" + cNumOpor+"]" 
			
			varinfo("oObjRet", oObjRet)
			
			(cAlsSC0)->(dbCloseArea())
			
			return .T.
		
		endif
		
		(cAlsSC0)->(dbCloseArea())
		
	endif
	
	
	
	if cOpc=="I"
		
		//cNumero := GetSx8Num("SC0","C0_NUM")
		
		cDoc		:= oObjRes:CLIENTE
		cVend		:= padr(oObjRes:VENDEDOR, tamsx3("A3_COD")[1])
		
		dbSelectArea("SA3")
		
		if SA3->(dbSeek(xFilial("SA3")+cVend))
			
			cSolicit	:= SA3->A3_NOME
			
		endif
		
		if len(oObjRes:ITEMRESERVA)>0
			
			nI:=1
			lContinua:=.T.
			
			
			for nI:=1 to len(oObjRes:ITEMRESERVA)
				
				cProduto	:= PADR(oObjRes:ITEMRESERVA[nI]:PRODUTO		,TAMSX3("C0_PRODUTO")[1])
				cLote		:= PADR(oObjRes:ITEMRESERVA[nI]:LOTE	 		,TAMSX3("B8_LOTECTL")[1])
				dVencto	:= oObjRes:ITEMRESERVA[nI]:VENCIMENTO
				nQuant		:= oObjRes:ITEMRESERVA[nI]:QUANT
				
				if Rastro(cProduto) .and. empty(cLote)
					
					lContinua := .F.
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= ""
					oObjRet[nX]:RETORNO	:= .F.
					oObjRet[nX]:MENSERRO	:= "Produto possui controle de lote e nao foi informado [" + cProduto +"]"
					varinfo("oObjRet", oObjRet)
					
					loop
					
				endif
				
				//procura armazem padrao no cadastro de indicador de produto
				dbSelectArea("SBZ")
				SBZ->(dbSetOrder(1))
				if SBZ->(dbSeek(xFilial("SBZ") + cProduto))
					
					cLocal := SBZ->BZ_LOCPAD
					
				else
					
					//se nao utiliza indicador de produto, obtem o armazem padrao do cadastro do produto
					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					
					if SB1->(dbSeek(xFilial("SB1") + cProduto))
						
						cLocal := SB1->B1_LOCPAD
						
					else
						
						lContinua := .F.
						
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= ""
						oObjRet[nX]:RETORNO	:= .F.
						oObjRet[nX]:MENSERRO	:= "Produto sem armazem padrao [" + cProduto +"]"
					   
						varinfo("oObjRet", oObjRet)
						
						loop
						
					endif
				endif
				
				//verifica se existe o produto no armazem indicado
				dbSelectArea("SB2")
				SB2->(dbSetOrder(1))
				
				if SB2->(!dbSeek(xFilial("SB2") + cProduto + cLocal))
					
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= ""
					oObjRet[nX]:RETORNO	:= .F.
					oObjRet[nX]:MENSERRO	:= "Nao existe o produto no armazem informado [" + cProduto +"/" + cLocal+"]"
					
					varinfo("oObjRet", oObjRet)
					
					loop
					
				endif
				
				//verifica se o lote é valido
				if !empty(cLote)
					
					dbSelectArea("SB8")
					SB8->(dbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL
					
					if SB8->(!dbSeek(xFilial("SB8") + cProduto + cLocal + cLote))
						
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= ""
						oObjRet[nX]:RETORNO	:= .F.
						oObjRet[nX]:MENSERRO	:= "Nao existe lote para o produto informado [" + cProduto +"/" + cLote +"]"
						
						varinfo("oObjRet", oObjRet)
						
						loop
						
					endif
					
				endif
				
				lContinua 	:= .T.
				cNumero	:= ""
				aOperacao 	:= {1 , "CL",  cDoc  , cSolicit ,  SM0->M0_CODFIL, "RESERVA SALESFORCE"}
				
				/*
				aOPERACAO			vetor			[1] -> [Operacao : 1 Inclui,2 Altera,3 Exclui]
				[2] -> [Tipo da Reserva]
				[3] -> [Documento que originou a Reserva]
				[4] -> [Solicitante]
				[5] -> [Filial da Reserva]
				[6] -> [Observacao]
				
				aLOTE				vetor			[1] -> [Numero do Lote]
				[2] -> [Lote de Controle]
				[3] -> [Localizacao]
				[4] -> [Numero de Serie]
				
				*/
				
				
				//	A430Reserv(aOPERACAO, cNUMERO, cPRODUTO ,cLOCAL  ,nQUANT  , aLOTE           )
				lContinua := 	a430Reserv(aOperacao, cNumero, cProduto , cLocal , nQuant , {"",cLote,"",""})
				
				if lContinua
					
					if SC0->(FieldPos("C0_X_NUMPD"))!=0 
					
						SC0->C0_X_NUMPD := cNumOpor
						
					endif
					
					SC0->C0_VALIDA := dVencto
					SC0->(msUnlock())
					
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= SC0->C0_NUM
					oObjRet[nX]:RETORNO	:= .T.
					
				else
					
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= ""
					oObjRet[nX]:RETORNO	:= .F.
					oObjRet[nX]:MENSERRO	:= "Nao foi possivel realizar a reserva do produto/local [" + cProduto +"/" + cLocal+"]"
					
					varinfo("oObjRet", oObjRet)
					
				endif
				
				
			next nI
			
			/*
			do while nI <= len(oObjRes:ITEMRESERVA)
				
				cProduto	:= PADR(oObjRes:ITEMRESERVA[nI]:PRODUTO		,TAMSX3("C0_PRODUTO")[1])
				
				cLote	:= PADR(oObjRes:ITEMRESERVA[nI]:LOTE	 		,TAMSX3("B8_LOTECTL")[1])
				
				if Rastro(cProduto) .and. empty(cLote)
					
					lContinua := .F.
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= ""
					oObjRet[nX]:RETORNO	:= .F.
					oObjRet[nX]:MENSERRO	:= "Produto possui controle de lote e nao foi informado [" + cProduto +"]"
					
				endif
				
				dVencto	:= oObjRes:ITEMRESERVA[nI]:VENCIMENTO
				nQuant		:= oObjRes:ITEMRESERVA[nI]:QUANT
				
				//procura armazem padrao no cadastro de indicador de produto
				dbSelectArea("SBZ")
				SBZ->(dbSetOrder(1))
				if SBZ->(dbSeek(xFilial("SBZ") + cProduto))
					
					cLocal := SBZ->BZ_LOCPAD
					
				else
					
					//se nao utiliza indicador de produto, obtem o armazem padrao do cadastro do produto
					dbSelectArea("SB1")
					SB1->(dbSetOrder(1))
					
					if SB1->(dbSeek(xFilial("SB1") + cProduto))
						
						cLocal := SB1->B1_LOCPAD
						
					else
						
						lContinua := .F.
						
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= ""
						oObjRet[nX]:RETORNO	:= .F.
						oObjRet[nX]:MENSERRO	:= "Produto sem armazem padrao [" + cProduto +"]"
						
						
						Exit
						
					endif
				endif
				
				
				dbSelectArea("SB2")
				SB2->(dbSetOrder(1))
				
				if SB2->(!dbSeek(xFilial("SB2") + cProduto + cLocal))
					
					lContinua := .F.
					
					oObj := WSClassNew("STSFRETRES")
					aadd(oObjRet,oObj)
					nX++
					oObjRet[nX]:CODIGO	:= ""
					oObjRet[nX]:RETORNO	:= .F.
					oObjRet[nX]:MENSERRO	:= "Nao existe o produto no armazem informado [" + cProduto +"/" + cLocal+"]"
					
					Exit
					
				endif
				
				if !empty(cLote)
					
					dbSelectArea("SB8")
					SB8->(dbSetOrder(3)) //B8_FILIAL+B8_PRODUTO+B8_LOCAL+B8_LOTECTL
					
					if SB8->(!dbSeek(xFilial("SB8") + cProduto + cLocal + cLote))
						
						lContinua := .F.
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= ""
						oObjRet[nX]:RETORNO	:= .F.
						oObjRet[nX]:MENSERRO	:= "Nao existe lote para o produto informado [" + cProduto +"/" + cLote +"]"
						
						Exit
						
					endif
					
				endif
				
				aadd(ItemRes, {cProduto	,;
					cLocal	,;
					nQuant	,;
					cLote})
				
				nI++
				
			enddo
			
			if lContinua
				
				cNumero:=""
				aOperacao 	:= {1 , "CL", cNumero , cDoc  , SM0->M0_CODFIL, "RESERVA SALESFORCE " +cVend}
				
				nI:=1
				
				varinfo("ItemRes",ItemRes)
				
				do while nI <= Len(ItemRes)
					
					//	A430Reserv(aOPERACAO, cNUMERO, cPRODUTO      ,cLOCAL         ,nQUANT        , aLOTE                  )
					lContinua := 	a430Reserv(aOperacao, cNumero, ItemRes[nI,1] , ItemRes[nI,2] , ItemRes[nI,3], {"",ItemRes[nI,4],"",""})
					
					if lContinua
						
						SC0->C0_VALIDA := dVencto
						SC0->(msUnlock())
						
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= SC0->C0_NUM
						oObjRet[nX]:RETORNO	:= .T.
						
					else
						
						oObj := WSClassNew("STSFRETRES")
						aadd(oObjRet,oObj)
						nX++
						oObjRet[nX]:CODIGO	:= ""
						oObjRet[nX]:RETORNO	:= .F.
						oObjRet[nX]:MENSERRO	:= "Nao foi possivel realizar a reserva do produto/local " + ItemRes[nI,1] +"/" + ItemRes[nI,2]
						
					endif
					
					nI++
					
				enddo
				
				
			endif
			*/
			
		endif
		
	endif
	
//	RpcClearEnv()	
//	RpcSetType(3)  
 //	RpcSetEnv(cOldEmp,cOldFil)
	
  //	RestArea(aArea)
	
Return .T.


/* --------------------------------------------------------------------------------------
Funcao		Funcao para incluir ou cancelar uma reserva
Autor		Devair
Descricao	Realiza cancelamento de reserva do ERP
Data		12/02/2015
-------------------------------------------------------------------------------------- */
Static Function CancRes (cEmp, cFil, cNumReserv, oObjRet)
	Local cOldEmp		:= cEmp
	Local cOldFil		:= cFil
	Local aArea
	Local nX			:= 0
	Local lContinua	:= .T.
		
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil  //RpcSetEnv(cOldEmp,cOldFil)
   
	aArea			:= GetArea()
	
	dbSelectArea("SC0")
	SC0->(dbSetOrder(1))
	if SC0->(dbSeek(xFilial("SC0")+cNumReserv)) 
	
		if SC0->(FieldPos("C0_X_NUMPD"))!=0 .and. empty(SC0->C0_X_NUMPD)
		
			lContinua := .F.
			
		else
	
			Begin Transaction
			
				If SC0->C0_QUANT <> 0 .And. SC0->C0_QUANT<>SC0->C0_QTDORIG  //se ja foi usada parte
					lContinua:= a430Reserv({2,SC0->C0_TIPO,SC0->C0_DOCRES,SC0->C0_SOLICIT,SC0->C0_FILRES},;
									SC0->C0_NUM,;
									SC0->C0_PRODUTO,;
									SC0->C0_LOCAL,;
									0,;
									{	SC0->C0_NUMLOTE,;
									SC0->C0_LOTECTL,;
									SC0->C0_LOCALIZ,;
									SC0->C0_NUMSERI})
				
				elseif SC0->C0_TIPO == "LB" //se nao foi usada
					
					lContinua := .F.
					
				elseif SC0->C0_QUANT <> 0 .AND. SC0->C0_QTDPED == 0 .and. SC0->C0_QTDELIM == 0 
					lContinua:= a430Reserv({3,SC0->C0_TIPO,SC0->C0_DOCRES,SC0->C0_SOLICIT,SC0->C0_FILRES},;
										SC0->C0_NUM,;
										SC0->C0_PRODUTO,;
										SC0->C0_LOCAL,;
										SC0->C0_QUANT,;
										{	SC0->C0_NUMLOTE,;
										SC0->C0_LOTECTL,;
										SC0->C0_LOCALIZ,;
										SC0->C0_NUMSERI})
				endif
							
					
				if lContinua
				
					SC0->(MsUnLock())
				
				endif
					
			End Transaction
		endif
	else
		
		lContinua := .F.
	
	endif
	
	
	
	if lContinua
			
			oObj := WSClassNew("STSFRETRES")
			aadd(oObjRet,oObj)
			nX++
			oObjRet[nX]:CODIGO	:= cNumReserv
			oObjRet[nX]:RETORNO	:= .T.
			oObjRet[nX]:MENSERRO	:= ""
	else
			
			oObj := WSClassNew("STSFRETRES")
			aadd(oObjRet,oObj)
			nX++
			oObjRet[nX]:CODIGO	:= ""
			oObjRet[nX]:RETORNO	:= .F.
			oObjRet[nX]:MENSERRO	:= "Nao foi possivel cancelar a reserva [" + cNumReserv +"]"
			varinfo("oObjRet", oObjRet)
	endif
	
  //	RpcClearEnv()	
   //	RpcSetType(3)  
  //	RpcSetEnv(cOldEmp,cOldFil)
	
	//RestArea(aArea)
	
Return .T.

/* --------------------------------------------------------------------------------------
Metodo		GravaPedido
Autor		Devair
Descricao	Realiza inportacao de pedido para ERP
Data		26/01/2015
-------------------------------------------------------------------------------------- */

Static Function GravaPedido (cEmp, cFil, oObjPed, oObjRet)
	Local i			:= 0
	Local cItem		:= "00"
	Local aErro 	:= {}
	Local cErro 	:= ""
	Local cOldEmp	:= cEmp
	Local cOldFil	:= cFil
	Local aArea		:= GetArea()
	local cC5TRANSP := ""
	local lParcEsp 	:= .F.
	local nTotPed	:= 0
	local aParcEsp	:={}     
	local cSemaforo	:= ""
	local lSFCrdCli := .F.
	local lLock 	:= .F.  	   
	local nCount 	:= 0    
	local lXSFEDET	:= .F. 
	local lTrava	:= .F.
	
	private aTrSB1	:= {}
	private aTrSA1	:= {}
	private aTrSB2	:= {}
	
	
	
	Private aCabPed  	:= {}
	Private aItem	   	:= {}
	Private cOper		:= ""
	Private lMsErroAuto    := .F.	//Indica retorno da MsExecAuto()
	Private lAutoErrNoFile := .T.	//Usada dentro da MsExecAuto()
	Private cClVl		:= ""

	
	RpcClearEnv()
	RpcSetType(3)  
	PREPARE ENVIRONMENT EMPRESA cOldEmp FILIAL cOldFil  //RpcSetEnv(cOldEmp,cOldFil)
   
	lSFCrdCli := GetMv("MV_X_SFCRD",.F.,.T.)
	lSFLogQry := getmv("MV_X_SFLQY", .F., .F.)
	lXSFEDET  := getmv("MV_X_SFEDE", .F., .F.)
	
	Conout(time() + " EMPRESA/FILIAL " + SM0->M0_CODIGO+"/"+SM0->M0_CODFIL)
	
	
	cSemaforo := "PEDIDO"+alltrim(oObjPed:NUMOPORTUNIDADE)	   
	
	lLock 	:= .F.  	   
	nCount 	:= 0
	while !lLock .and. nCount < 30  	
	    
		lLock	:= LockByName(cSemaforo,.T.,.T.,.T.)  			
		sleep(1000)		
		nCount++		                                		
		if !lLock
			conout("ESPERANDO PROCESSAR OPORTUNIDADE " + oObjPed:NUMOPORTUNIDADE ) 
		endif		
	enddo
		
	if !lLock 	
		oObjRet:CODIGO 	:= ""
		oObjRet:RETORNO	:= .F.
		oObjRet:MENSERRO:= "A tentativa de integração falhou. Tente enviar novamente para o ERP."					 
		return   .T.
	endif
		
	
	aArea := GetArea()
	
	dbSelectArea("SC5")	
	dbSelectArea("SC6")
	
	cAlsSC5 := GetNextAlias()
	BEGINSQL Alias cAlsSC5
		SELECT C5_NUM
		FROM %table:SC5%
		WHERE
		C5_FILIAL = %exp:SM0->M0_CODFIL%
		AND C5_X_NUMPD = %exp:padr(oObjPed:NUMOPORTUNIDADE, TAMSX3("C5_X_NUMPD")[1])%
		AND %NOTDEL%
		
	ENDSQL
	
	if !empty((cAlsSC5)->C5_NUM)
		
		oObjRet:CODIGO 	:= (cAlsSC5)->C5_NUM
		oObjRet:RETORNO	:= .T.
		oObjRet:MENSERRO:= "Oportunidade ja existe no ERP para esta empresa/filial: " + oObjPed:NUMOPORTUNIDADE
		
		(cAlsSC5)->(dbCloseArea())
		
		if lSFLogQry
			varinfo("oObjRet", oObjRet)
		endif
		
		UnLockByName(cSemaforo,.T.,.T.)		
		return .T.
	endif	
	
	if lSFLogQry
   		varinfo("oObjPed", oObjPed)
	endif
	
	BEGIN SEQUENCE
		
		cSA1COD		:= PADR(oObjPed:C5CLIENTE, TAMSX3("C5_CLIENTE")[1])
		cSA1LOJA	:= PADR(oObjPed:C5LOJACLI, TAMSX3("C5_LOJACLI")[1])
		
		dbSelectArea("SA1")
		SA1->( dbSetOrder( RetOrder( "SA1" , "A1_FILIAL+A1_COD+A1_LOJA" ) ) )
		
		
		If SA1->(!dbSeek(xFilial("SA1")+cSA1COD+cSA1LOJA, .F.)) .OR. empty(cSA1COD) .OR. empty(cSA1LOJA)
			
			oObjRet:CODIGO 	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO	:= "Codigo de cliente nao localizado ou nao informado: " + cSA1COD + "/" +cSA1LOJA
			
			if lSFLogQry
				varinfo("oObjRet", oObjRet)    
			endif
			
			UnLockByName(cSemaforo,.T.,.T.)
			return .T.
			
		else
			
			if SA1->A1_MSBLQL == "1"
				
				oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO	:= "Cliente " +SA1->A1_COD +"/"+SA1->A1_LOJA +" esta bloqueado."
			   	
			   	if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif
				
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
				
			endif
			
		EndIf
		
		dbSelectArea("SE4")
		SE4->(dbSetOrder(1))

		If !SE4->(dbSeek(xFilial("SE4")+PADR(oObjPed:C5CODPAG, TAMSX3("C5_CONDPAG")[1]) )) .OR. empty(oObjPed:C5CODPAG)
			
			oObjRet:CODIGO 	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO	:= "Codigo de condicao de pagamento nao localizado ou nao informado: " + oObjPed:C5CODPAG
		    
		   	if lSFLogQry
				varinfo("oObjRet", oObjRet) 
			endif
			
			UnLockByName(cSemaforo,.T.,.T.)
			return .T.
			
		endif
		
		if SE4->E4_TIPO == '9'
			
			lParcEsp := .T.
			cSE4COD  := PADR(oObjPed:C5CODPAG, TAMSX3("C5_CONDPAG")[1])
			
		endif
		
		
		dbSelectArea("SA3")
		SA3->(dbSetOrder(1))
		If SA3->(!dbSeek(xFilial("SA3")+ PADR(oObjPed:C5VEND1,TAMSX3("C5_VEND1")[1]) )) .OR. empty(oObjPed:C5VEND1)
			
			oObjRet:CODIGO 		:= ""
			oObjRet:RETORNO		:= .F.
			oObjRet:MENSERRO	:= "Codigo de vendedor nao localizado ou nao informado: " + oObjPed:C5VEND1
			
			if lSFLogQry
				varinfo("oObjRet", oObjRet)
			endif
					
			UnLockByName(cSemaforo,.T.,.T.)
			return .T.
		EndIf
		
		if !empty(oObjPed:C5TRANSP)
			dbSelectArea("SA4")
			
			cSA4COD	:= padr(oObjPed:C5TRANSP, tamsx3("A4_CGC")[1])
			SA4->( dbSetOrder( RetOrder( "SA4" , "A4_FILIAL+A4_COD" ) ) )
			
			if SA4->(!dbSeek(xFilial("SA4")+ cSA4COD ))
				
				oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO	:= "Codigo de transportadora nao localizado: " + oObjPed:C5TRANSP
				
				if lSFLogQry	
					varinfo("oObjRet", oObjRet)  
				endif
							
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
			else
				
				cC5TRANSP := SA4->A4_COD
				
			endif
		endif
		
		
		if AllTrim(oObjPed:C5TPFRETE) == "S"
			cC5TRANSP := "000056" //'O MESMO' QUANDO SEM FRETE
		endif
		
		For i := 1 To Len(oObjPed:ITENSPEDIDO)
					
			dbSelectArea("SBZ")
			SBZ->(dbSetOrder(1))
			
			if SBZ->(!dbSeek(xFilial("SBZ") + PADR(oObjPed:ITENSPEDIDO[i]:C6PRODUTO,TAMSX3("BZ_COD")[1])))
						
			    oObjRet:CODIGO 		:= ""
				oObjRet:RETORNO		:= .F.
				oObjRet:MENSERRO	:= "Produto sem indicador: " + ALLTRIM(oObjPed:ITENSPEDIDO[i]:C6PRODUTO)
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif
							
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
				
			endif
			
			If SB1->(!dbSeek(xFilial("SB1")+PADR(oObjPed:ITENSPEDIDO[i]:C6PRODUTO, TAMSX3("C6_PRODUTO")[1])))
				
				oObjRet:CODIGO 		:= ""
				oObjRet:RETORNO		:= .F.
				oObjRet:MENSERRO	:= "Produto nao localizado: " + AllTrim(oObjPed:ITENSPEDIDO[i]:C6PRODUTO)
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif 
				 
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
				
			elseif SB1->B1_MSBLQL=='1'
				
				oObjRet:CODIGO 		:= ""
				oObjRet:RETORNO		:= .F.
				oObjRet:MENSERRO	:= "Produto bloqueado: " + ALLTRIM(SB1->B1_COD)
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif 
				 
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
			endIf
			
			nTotPed += oObjPed:ITENSPEDIDO[i]:C6PRCVEN * oObjPed:ITENSPEDIDO[i]:C6QTDVEN
			
		Next i
		
		cMsgNota := ""   
		
		if !empty(oObjPed:ORDEMCOMPRA)
			
			cMsgNota := "OC " + alltrim(oObjPed:ORDEMCOMPRA)+"."
		
		endif 
		
		if !empty(oObjPed:OBSNOTA)
			
			cMsgNota += alltrim(oObjPed:OBSNOTA)+". "
		
		endif 				
		
		cMsgNota := fwnoaccent(cMsgNota)
		
		//DESATIVADA POR ENQUANTO
		//REATIVADO EM 25/06/2015, SOLICITAÇÃO ALEX. CONSENTIDO COM FATURAMENTO E FISCAL
		//DESATIVADO EM 25/06/2015 SOLICITAÇÃO ALEX, POIS SÓ PODE APARECER SE O ENDEREÇO DE DENTREGA FOR DIFERENTE DO ENDEREÇO DO FATURAMENTO.
		//ESTA REGRA DEVER SER FEITA NO SALESFORCE, POIS NO ERP NAO É USADO ENDEREÇO DE ENTREGA.
				
		if !empty(oObjPed:ENDENTREGA:ENDENTREGA)  .and. lXSFEDET
			
			dbSelectArea("CC2")
			CC2->(dbSetOrder(1))
			Conout(Procname() + Str(ProcLine()))
			
			cChaveCC2 := xFilial('CC2')+PADR(oObjPed:ENDENTREGA:UFENTREGA,TAMSX3("CC2_EST")[1])+PADR(oObjPed:ENDENTREGA:CODMUNENTREGA,TAMSX3("CC2_CODMUN")[1])
			
			if CC2->(dbseek(cChaveCC2))
				
				cMsgNota += "ENTREGA: " + alltrim(upper(oObjPed:ENDENTREGA:ENDENTREGA))
				cMsgNota += ", " + alltrim(upper(oObjPed:ENDENTREGA:BAIRRROENTREGA))
				cMsgNota += " - " + alltrim(CC2->CC2_MUN)
				cMsgNota += " - " + alltrim(upper(oObjPed:ENDENTREGA:CEPENTREGA))
				cMsgNota += " - " + alltrim(upper(oObjPed:ENDENTREGA:UFENTREGA))
				cMsgNota += " - " + alltrim(upper(oObjPed:ENDENTREGA:PAISENTREGA)) 
				cMsgNota := FwNoAccent(cMsgNota)
			else
				
				oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO	:= "Municipio de entrega nao localizado: " + AllTrim(oObjPed:ENDENTREGA:CODMUNENTREGA)
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif  
				  
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
				
			endif
			
		endif
		
		//cOper := "01" //copiado do SIM3G, verificar como é o caso
		
		cOper := upper(PADR(oObjPed:DESTINACAO,TAMSX3("C6_OPER")[1]))
		
		/*
		Revenda = REV = 01
		Consumo = CON  = 03
		Insumo = INS =
		Amostra = AMO =
		Bonificação = BON = 04
		*/
		
		if upper(cOper) $ 'REV/INS'
			
			cOper := "01"
			
		elseif  upper(cOper) $ 'CON'
			
			cOper := "03"
			
		elseif  upper(cOper) $ 'BON'
			
			cOper := "04"
			
		endif
			
		if SX5->(!dbSeek(xFilial("SX5")+"DJ"+cOper))
			
			oObjRet:CODIGO 	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO	:= "Destinacao (Tipo operacao) não encontrada: " + cOper
						
			if lSFLogQry
				varinfo("oObjRet", oObjRet)  
			endif
			
			UnLockByName(cSemaforo,.T.,.T.)
			return .T.
			
		endif
		
		// VERIFICA SE EXISTE AMARRACAO CLIENTE X VENDEDOR X SEGMENTO E SE É SOMENTE 1 AMARRAÇÃO. 
		// PARA CONGELADOS A REGRA DO SEGMENTO ESTA NO ELSE
		
		if SM0->M0_CODIGO $ "30/31/60" 
		
			dbSelectArea("ZZ5")
			ZZ5->(dbSetOrder(3)) //ZZ5_FILIAL+ZZ5_VEND+ZZ5_CLIENT+ZZ5_LOJA
			
			if ZZ5->(!dbSeek(xFilial("ZZ5")+SA3->A3_COD+SA1->A1_COD+SA1->A1_LOJA )) 
				
				oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO:= "Nao foi encontrada amarracao Cliente X Vendedor X Segmento."
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif 
				
				UnLockByName(cSemaforo,.T.,.T.)
				return .T. 
			
			else 
			
				//SE EXISTIR MAIS DE UMA AMARRACAO, NÃO PERMITIR A INTEGRAÇÃO.
				cClVl	:= 	ZZ5->ZZ5_SEGMEN	   
				cTabela	:=  ZZ5->ZZ5_TABELA
				if empty(cClVl)
					
					oObjRet:CODIGO 	:= ""
					oObjRet:RETORNO	:= .F.
					oObjRet:MENSERRO:= "Segmento nao preenchido na amarracao Cliente x Vendedor x Segmento."
					
					if lSFLogQry
						varinfo("oObjRet", oObjRet)  
					endif  
					
					UnLockByName(cSemaforo,.T.,.T.)
					return .T.
				
				endif
				
				nQtdAmar := 0
				while ZZ5->(!EOF()) .AND. ;
					ZZ5->(ZZ5_FILIAL+ZZ5_VEND+ZZ5_CLIENT+ZZ5_LOJA+ZZ5_TABELA) == xFilial("ZZ5")+SA3->A3_COD+SA1->A1_COD+SA1->A1_LOJA+cTabela
			        nQtdAmar++     
			        
					ZZ5->(dbSkip())
				enddo
				
				if nQtdAmar > 1
					
					oObjRet:CODIGO 	:= ""
					oObjRet:RETORNO	:= .F.
					oObjRet:MENSERRO:= "Existe mais de uma amarracao Cliente x Vendedor x Segmento."
					
					if lSFLogQry
						varinfo("oObjRet", oObjRet)  
					endif
					
			   		UnLockByName(cSemaforo,.T.,.T.)
					return .T.
				
				endif
				
			endif
			
		else
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Avalia amarração de armazem x vendedor para buscar segmento que será atribuído no pedido.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cLocal := ""
			DbSelectArea("SBZ")
			SBZ->(dbSetOrder(1))
			if SBZ->(dbSeek(xFilial("SBZ") + PADR(oObjPed:ITENSPEDIDO[1]:C6PRODUTO,TAMSX3("BZ_COD")[1])))
				cLocal := SBZ->BZ_LOCPAD
			endif
	       
			cClVl := "002001001"
			
			/*
			dbSelectArea("Z22")
			Z22->(dbSetOrder(1))
			if Z22->(dbSeek(xFilial("Z22") + SA3->A3_COD))
				
				While Z22->(!Eof()) .and. xFilial("Z22")+SA3->A3_COD == Z22->Z22_FILIAL+Z22->Z22_CODVEN 
					if (Z22->Z22_ARMAZ == cLocal)
						cClVl := Z22->Z22_CODCVL
						Exit
					EndIf
					Z22->(dbSkip())
				EndDo
			endif 			
			Z22->(dbCloseArea())
			*/
			
			if empty(cClVl)
				
				oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO:= "Nao foi encontrada amarracao Vendedor x Armazem x Segmento."
				
				if lSFLogQry
					varinfo("oObjRet", oObjRet)  
				endif
								
				UnLockByName(cSemaforo,.T.,.T.)
				return .T.
			
			endif
			
		endif
		
		if lSFLogQry
			varinfo("Classe de valor: " + cClVl)
		endif
			
		aadd(aCabPed, {"C5_TIPO"   ,"N"    ,})
		aadd(aCabPed, {"C5_CLIENTE", SA1->A1_COD	  	,})
		aadd(aCabPed, {"C5_LOJACLI", SA1->A1_LOJA  	,})
		aadd(aCabPed, {"C5_EMISSAO", dDataBase       ,})
		aadd(aCabPed, {"C5_TIPOCLI", SA1->A1_TIPO,})
		
		if !empty(cC5TRANSP)
			aadd(aCabPed, {"C5_TRANSP" , cC5TRANSP	,})
		endif
		
		aadd(aCabPed, {"C5_TPFRETE", AllTrim(oObjPed:C5TPFRETE)	,})
		
		
		aadd(aCabPed, {"C5_CONDPAG", SE4->E4_CODIGO 	,})
		aadd(aCabPed, {"C5_TABELA" , SPACE(3)	,})
		
		aadd(aCabPed, {"C5_VEND1"  , SA3->A3_COD	 	,})
		aadd(aCabPed, {"C5_TIPLIB" , "1"         ,})
		aadd(aCabPed, {"C5_MOEDA"  , 1	,})
		
		if !empty(oObjPed:C5XTID)
			aadd(aCabPed, {"C5_XTID" , oObjPed:C5XTID	,})
		endif
		
		
		if !empty(cMsgNota)
			
			aadd(aCabPed, {"C5_MENNOTA", cMsgNota	,})    
			
		endif
		
		aadd(aCabPed	, {"C5_X_ORIPD" 	,"S",})
		aadd(aCabPed	, {"C5_X_NUMPD" 	,oObjPed:NUMOPORTUNIDADE,})
		
		
		//aadd(aCabPed, {"C5_COTACAO",SubStr(CABPED->NUMPED, 1, 9),Nil})
		//aadd(aCabPed, {"C5_PEDCLI" ,CABPED->NUMPEDCLI,Nil})
		
		aadd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),})
		
		if !empty(cClVl)
			aAdd(aCabPed, {"C5_X_CLVL",cClVl,})
		endif
		
		
		//ARRAY PARA TRAVA DE SC5
		aadd(aTrSA1, PADR( SA1->A1_COD, TAMSX3("A1_COD")[1]) + PADR(SA1->A1_LOJA,TAMSX3("A1_LOJA")[1]) )
		
		aItemPed := MontaItenPed(oObjPed:ITENSPEDIDO, oObjPed:ORDEMCOMPRA)
		
		
		if lParcEsp
			
			nQtdTp9 := SuperGetMv("MV_NUMPARC", .F., 4) 
			
			if len(oObjPed:PARCESPECIAIS)>nQtdTp9
			              
			    oObjRet:CODIGO 	:= ""
				oObjRet:RETORNO	:= .F.
				oObjRet:MENSERRO:= "Quantidade de parcelas especiais não deve ser superior a " + cValToChar(nQtdTp9)

				if lSFLogQry
					varinfo("oObjRet", oObjRet) 
				endif
				         
			    UnLockByName(cSemaforo,.T.,.T.)          
				return .T.
			endif
			
			
			if len(oObjPed:PARCESPECIAIS)>0
				
				nPerTot	:= 100.00
				
				For nY := 1 To Len(oObjPed:PARCESPECIAIS)
					
					aUmaParc := {}
					
					nPercAtu := ROUND(oObjPed:PARCESPECIAIS[nY]:C5PARC / nTotPed*100,2)   
					
					nPerTot -= nPercAtu
					
					if nY == Len(oObjPed:PARCESPECIAIS) 
					
						if nPerTot != 0
					     
							nPercAtu += nPerTot
						
						endif
									
					endif 
					
					aadd(aUmaParc, STOD(oObjPed:PARCESPECIAIS[nY]:C5DATA))
					aadd(aUmaParc, nPercAtu )
					
					aadd(aParcEsp, aUmaParc)
					
				Next nY
				
				
				//preenche o array com as parcelas especiais   
				cNParc := "0"
				for nZ:=1 to Len(aParcEsp)

					cNParc:=soma1(cNParc) //1-9A-C : 12 PARCELAS					
					AADD(aCabPed,{"C5_DATA" + cNParc   ,	aParcEsp[nZ,1]   ,Nil})
					AADD(aCabPed,{"C5_PARC" + cNParc   ,	aParcEsp[nZ,2]   ,Nil})
					
				next nZ  
				
			endif
		endif
					
		aCabPed 	:= WsAutoOpc(aCabPed)		
		aItemPed 	:= WsAutoOpc(aItemPed)
	   
		if lSFLogQry  	                             
			varinfo("aCabPed", aCabPed)
			varinfo("aItemPed", aItemPed)
		endif
		
		cAlsSC5 := GetNextAlias()
		BEGINSQL Alias cAlsSC5
			SELECT C5_NUM                           
			FROM %table:SC5%
			WHERE
			C5_FILIAL = %exp:SM0->M0_CODFIL%
			AND C5_X_NUMPD = %exp:padr(oObjPed:NUMOPORTUNIDADE, TAMSX3("C5_X_NUMPD")[1])%
			AND %NOTDEL%			
		ENDSQL
		
		if !empty((cAlsSC5)->C5_NUM)			
			oObjRet:CODIGO 	:= (cAlsSC5)->C5_NUM
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO:= "Oportunidade ja existe no ERP para esta empresa/filial: " + oObjPed:NUMOPORTUNIDADE						
			(cAlsSC5)->(dbCloseArea())			
			
			if lSFLogQry
				varinfo("oObjRet", oObjRet)
			endif
					
			UnLockByName(cSemaforo,.T.,.T.)						
			return .T.
		endif
		(cAlsSC5)->(dbCloseArea())
		
		lMsErroAuto := .F.     
				
		lTrava := U_PROLOCKS("SB2", aTrSB2,2) .and. U_PROLOCKS("SA1", aTrSA1,1) .and. U_PROLOCKS("SB1", aTrSB1,1)
							

		if !lTrava          
		
			oObjRet:CODIGO 	:= ""
			oObjRet:RETORNO	:= .F.
			oObjRet:MENSERRO:= "Nao foi possivel realizar integracao. Informações em uso por outro processamento. Tente novamente."
		
			if lSFLogQry
				varinfo("oObjRet", oObjRet)
			endif
					
			UnLockByName(cSemaforo,.T.,.T.)						
			return .T.
			
		else
						
			begin transaction
			
				MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPed,aItemPed,3)
				
				/*/
				ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				³ Verifica a ocorrencia de Erros na Inclusao do Pedido					 ³
				ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ/*/
						
				If lMsErroAuto
					
					aErro := GetAutoGRLog()			
					varinfo(time()+ " EMPRESA: ", SM0->M0_CODIGO)
					varinfo(time()+ " OPORTUNIDADE  : ", oObjPed:NUMOPORTUNIDADE)					
								
					cErro	:= ""
					cErro	:= TrErrAut(aErro, 1)  			
					cErro += TrErrAut(aErro, 2, "C6_PRODUTO")+CRLF
					cErro += TrErrAut(aErro, 2, "<") + CRLF  
				
		           	if lSFLogQry
						varinfo(time()+ " cErro", cErro)		
						varinfo(time()+ " aErro: ", aErro)
					endif
					
					oObjRet:CODIGO 	:= ""
					oObjRet:RETORNO	:= .F.
					oObjRet:MENSERRO:= ENCODEUTF8(ANSIToOEM (fwnoaccent(cErro)))
					
					RollBackSX8()
					DisarmTransaction()
					
					if lSFLogQry
						varinfo(time()+ " oObjRet", oObjRet) 
					endif
				Else
					
					oObjRet:CODIGO	:= SC5->C5_NUM
					oObjRet:RETORNO	:= .T.
					
					varinfo(time()+ " EMPRESA: ", SM0->M0_CODIGO)			
					varinfo(time()+ " PEDIDO GRAVADO: ", SC5->C5_FILIAL +"/"+SC5->C5_NUM)
					varinfo(time()+ " OPORTUNIDADE  : ", oObjPed:NUMOPORTUNIDADE) 
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Relibera o estoque do produto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DBSELECTAREA("SC9")
					SC9->(dbSetOrder(2)) //C9_FILIAL+C9_CLIENTE+C9_LOJA+C9_PEDIDO+C9_ITEM
					nVlrCred:=0
					
					SC6->(dbSeek(SC5->C5_FILIAL + SC5->C5_NUM))
					while SC6->(!EOF()) .AND. SC6->(C6_FILIAL+C6_NUM)==SC5->(C5_FILIAL+C5_NUM)
						
						If SC9->(dbSeek(xFilial("SC6")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NUM+SC6->C6_ITEM)) .AND. SC9->C9_BLCRED $"01/02/04/06"
							//SC9->(A460Estorna(/*lMata410*/,/*lAtuEmp*/,@nVlrCred))
							
							//  MaLibDoFat(nRegSC6       ,nQtdaLib,lCredito,lEstoque,lAvCred,lAvEst,lLibPar,lTrfLocal,aEmpenho,bBlock,aEmpPronto,lTrocaLot,lOkExpedicao,nVlrCred,nQtdalib2)
							//MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN   ,.T.     ,.T.    ,.F.   ,.T.    )  
							a450Grava(1,.T.,.F.)
						EndIf				         
						
						SC6->(dbSkip())
					enddo
					
					Reclock("SC5",.F.)
					SC5->C5_LIBEROK='S'
					SC5->(MsUnlock())
					
					DBCommit ( )	
				EndIf

			end transaction
		endif 

	END SEQUENCE
	
	//atualiza dados de credito do cliente, após integrado o pedido.
	if lSFCrdCli .and. !lMsErroAuto
		U_SFCLICRE({SA1->(RECNO())}, .F.)
	endif
	
	UnLockByName(cSemaforo,.T.,.T.)
	
	
	//RpcClearEnv()	
   //	RpcSetType(3)  
   //	RpcSetEnv(cOldEmp,cOldFil)
	
  //	RestArea(aArea)
Return


Static Function MontaItenPed(oObjItemPedido, cNumPedCom)
	
	Local aItemLinha 	:= {}
	Local aItem      	:= {}
	Local cItemNovo  	:= PadL("00", Len(SC6->C6_ITEM))
	Local i, cTpConv, nFatConv
	Local aArea      	:= GetArea()
	Local cLocal    	:= ""
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Parâmetro que aramazena se deve zerar o preço de tabela quando vêm do palm.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	
	Local lPrcTab    	:= SuperGetMV("MV_PRCTABP", ,.F.)
	Local cTesForaUF 	:= ""
	Local cTesST 		:= ""
	Local cSql   		:= ""
	Local cUFsST 		:= ""
	Local cTesCP 		:= ""
	Local cUFsCP 		:= ""
	Local cTpCli 		:= ""
	Local lUfDif 		:= .F.
	Local lLibPed 		:= SuperGetMV("MV_X_PSFAL", , .T.)
	Local lMudaTES 		:= .F.
	Local cTes 			:= ""
	Local cCfop 		:= ""
	Local cEol 			:= CHR(13)+CHR(10)
	local lSFLogQry		:= getmv("MV_X_SFLQY", .F., .F.)
	
	default cNumPedCom	:="" 

	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona no cliente para buscar o Estado e o Tipo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cUFCli := SA1->A1_EST // Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_EST")
	cTpCli := SA1->A1_TIPO //Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_TIPO")
	lUfDif := (cUFCli <> SM0->M0_ESTCOB)
	
	for nI:=1 to len(oObjItemPedido)
		
		lMudaTES := .F.
		cItemNovo := Soma1(cItemNovo)
		aAdd(aItemLinha, {"C6_ITEM"	,cItemNovo,Nil})
		
		aAdd(aItemLinha, {"C6_PRODUTO",AllTrim(oObjItemPedido[nI]:C6PRODUTO),Nil})
		
		SB1->(dbSetOrder(01))
		SB1->(dbSeek(xFilial("SB1") + PADR(oObjItemPedido[nI]:C6PRODUTO, TAMSX3("B1_COD")[1])))
		
		dbSelectArea("SBZ")
		SBZ->(dbSetOrder(1))
		
		if SBZ->(dbSeek(xFilial("SBZ") + PADR(oObjItemPedido[nI]:C6PRODUTO,TAMSX3("BZ_COD")[1])))
			cLocal := SBZ->BZ_LOCPAD    
		else
			cLocal := SB1->B1_LOCPAD
		endif
		
		cTesForaUF := ""
		cTesST := ""
		cUFsST := ""
		cTesCP := ""
		cUFsCP := ""
		/*
		BEGINSQL alias "ZZATMP"
			SELECT ZZA_PRODUT, ZZA_GRUPO, ZZA_TESUFD, ZZA_TESST, ZZA_UFSST, ZZA_TESCRP, ZZA_UFSCRP FROM %TABLE:ZZA% ZZA
			WHERE ZZA_FILIAL = %XFILIAL:ZZA%
			AND (ZZA_GRUPO = %EXP:SB1->B1_GRUPO% OR ZZA_PRODUT = %EXP:SB1->B1_COD%)
			AND %NOTDEL%
			ORDER BY ZZA_PRODUT, ZZA_GRUPO
		ENDSQL
		
		While ZZATMP->(!Eof())
			
			if !Empty(ZZATMP->ZZA_TESUFD)
				cTesForaUF := ZZATMP->ZZA_TESUFD
			EndIf
			
			if !Empty(ZZATMP->ZZA_TESST) .And. (cUFCli $ ZZATMP->ZZA_UFSST)
				cTesST := ZZATMP->ZZA_TESST
				cUFsST := ZZATMP->ZZA_UFSST
			EndIf
			
			if !Empty(ZZATMP->ZZA_TESCRP) .And. (cUFCli $ ZZATMP->ZZA_UFSCRP)
				cTesCP := ZZATMP->ZZA_TESCRP
				cUFsCP := ZZATMP->ZZA_UFSCRP
			EndIf
			
			ZZATMP->(dbSkip())
			
		EndDo
		
		dbCloseArea("ZZATMP")
		*/
		// obtém se a uf do cliente é diferente da empresa
		if !Empty(cTesForaUF)
			lUfDif := SA1->A1_EST != SM0->M0_ESTCOB
		EndIf
		
		
		// obtém o fator de conversão, a ser usado logo abaixo, na conversão para a segunda unidade.
		nFatConv := Iif(SB1->B1_TIPCONV == "M", 1 / SB1->B1_Conv, SB1->B1_Conv)
		
		aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})
		
		aAdd(aItemLinha, {"C6_QTDVEN",oObjItemPedido[nI]:C6QTDVEN	,Nil})
		// aAdd(aItemLinha, {"C6_PRUNIT",oObjItemPedido:C6PRUNIT,Nil})
		aAdd(aItemLinha, {"C6_PRCVEN",oObjItemPedido[nI]:C6PRCVEN,Nil})
		aAdd(aItemLinha, {"C6_PRCTAB",oObjItemPedido[nI]:C6PRUNIT,Nil})
		aAdd(aItemLinha, {"C6_VALOR",Round(oObjItemPedido[nI]:C6QTDVEN	 * oObjItemPedido[nI]:C6PRCVEN,2),Nil})
		aAdd(aItemLinha, {"C6_ENTREG",dDataBase,Nil})
		//aAdd(aItemLinha, {"C6_UM",SB1->B1_UM,Nil})
		
		aAdd(aItemLinha, {"C6_LOCAL", cLocal,Nil})
		
		/*
		DEVAIR 26/01/2015
		
		REMOVIDO TEMPORARIAMENTE. DEKKER
		
		// Valida se a tabela de preço é promocional
		// Flavio - 22/09/2011
		if !Empty(ITEPED->TABPRC)
			aAdd(aItemLinha, {"C6_X_TAPRO",ITEPED->TABPRC,Nil})
			aAdd(aItemLinha, {"C6_X_PROMO","S",Nil})
		else
			aAdd(aItemLinha, {"C6_X_PROMO","N",Nil})
		EndIf
		
		*/
		
		varinfo("",AllTrim(oObjItemPedido[nI]:C6PRODUTO))
		varinfo("",AllTrim(SB1->B1_DESC))
		varinfo("",AllTrim(Str(oObjItemPedido[nI]:C6QTDVEN	)))
		varinfo("",Str(oObjItemPedido[nI]:C6PRCVEN))
		
		cTes := ""
		
		SF4->(dbSetOrder(01))
		
		/* DEVAIR 26/01/2015
		DE ONDE VIRA O TIPO DE PEDIDO PARA DEFINIR A OPERAÇÃO?
		VIRA DO CAMPO DESTINACAO DO SALESFORCE
		if("PB" $ CABPED->IDTIPOPEDIDO)
			cOper := "04"
		else
			cOper := ""
		EndIf
		*/ 
		
		if lSFLogQry
			varinfo("cTpCli",cTpCli)    
		endif
		
		// apenas seta o tipo de operação caso não seja pneu ou bonificação
		if Substr(cClVl, 1, 3) == "005" .Or. cOper == "04"
						
			// Jean (18/10/2012) - Tratativa para que todos os pedidos do segmento de pneus entrem com a seguinte regra:
			// Quando o tipo de cliente for Consumidor Final, usa operação "03", caso contrário, usa operação "01"
			
			
			// DEVAIR 13/04/2015 - REVISAR ESTE TRECHO
			
			
			if Substr(cClVl, 1, 3) == "005"
				if cTpCli == "S"  .and. (SA1->A1_GRPTRIB $ '001/102/105' .OR. empty(SA1->A1_GRPTRIB))
					cOper := "01"
				Else
					cOper := "03"
				EndIf 
				
				if lSFLogQry
					varinfo("","Segmento de Pneu: "+trim(cClvl)+" Tipo de Operação: "+trim(cOper))
				endif
				
			EndIf
			
			
			aAdd(aItemLinha, {"C6_OPER",cOper,Nil})          
			
		elseif Substr(cClVl, 1, 3) == "008"
	   	
	   		if cTpCli == "S"  .and. (SA1->A1_GRPTRIB $ '001' .OR. empty(SA1->A1_GRPTRIB))
				cOper := "01"				
			
			Else
				cOper := "03"
			EndIf 
			
			if lSFLogQry
				varinfo("","Segmento de Level: "+trim(cClvl)+" Tipo de Operação: "+trim(cOper))
			endif
			
			aAdd(aItemLinha, {"C6_OPER",cOper,Nil})    
			
		else
		
			SF4->(dbSeek(xFilial("SF4") + SBZ->BZ_TS))
			cTes := SBZ->BZ_TS
			lMudaTES := .T.
			//aAdd(aItemLinha, {"C6_TES",SBZ->BZ_TS,Nil})
			//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
		EndIf
		
		// avaliacao da mudança de TES na RJU   
		if lSFLogQry
			varinfo("","Avalia mudança de TES " + cTesForaUF)
		endif
		
		if !lUfDif
			if lSFLogQry
				varinfo("","UF do cliente igual da empresa")
			endif
		EndIF
		
		// Busca a Tes do indicador de produto
		
		
		// Altera a tes caso a mesma tenha sido informada e a venda é para fora do estado.
		If lUfDif .And. !Empty(cTesForaUF) .And. (cOper != "04")
			cTes := cTesForaUF
			lMudaTES := .T.
			
			//AADD(aItemLinha,{"C6_TES",cTesForaUF,Nil})
			//SF4->(dbSeek(xFilial("SF4") + cTesForaUF))
			//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
			//varinfo("","Mudou a tes do produto " + AllTrim(oObjItemPedido:C6PRODUTO) + " para " + cTesForaUF)
		EndIf
		
		// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtos
		if (cUFCli $ cUFsST .And. !Empty(cTesST)) .And. (cOper != "04")
			cTes := cTesST
			lMudaTES := .T.
			
			//AADD(aItemLinha,{"C6_TES",cTesST,Nil})
			//SF4->(dbSeek(xFilial("SF4") + cTesST))
			//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
			
			// Muda o tipo do cliente para solidário
			aAdd(aCabPed, {"C5_TIPOCLI","S",Nil})
			
			//varinfo("","Mudou a tes do produto " + AllTrim(oObjItemPedido:C6PRODUTO) + " para " + cTesST)
		EndIf
		
		// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de Credito Presumido para alguns produtos
		if (cUFCli $ cUFsCP .And. !Empty(cTesCP)) .And. (cOper != "04")
			cTes := cTesCP
			lMudaTES := .T.
			//AADD(aItemLinha,{"C6_TES",cTesCP,Nil})
			
			//SF4->(dbSeek(xFilial("SF4") + cTesCP))
			//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
			
			//varinfo("","Mudou a tes do produto " + AllTrim(oObjItemPedido:C6PRODUTO) + " para " + cTesCP)
		EndIf
		
		if lMudaTES .And. !Empty(cTes) .And. (cOper != "04")
			AADD(aItemLinha,{"C6_TES",cTes,Nil})
			
			SF4->(dbSeek(xFilial("SF4") + cTes))
			cCfop := iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3)
			
			If Left(cCfop,4) == "6405"
				cCfop := "6404"+SubStr(cCfop,5,Len(cCfop)-4)
			Endif
			
			if lSFLogQry
				varinfo("","CFOP: " + cCfop)
			endif
			
			aAdd(aItemLinha, {"C6_CF", cCfop, Nil})
			
			if lSFLogQry
				varinfo("","Mudou a tes do produto " + AllTrim(oObjItemPedido[ni]:C6PRODUTO) + " para " + cTes)
			endif
			
		EndIf
		
		if lSFLogQry
			varinfo("","Tes: " + cTes)
		endif                         
		
		// Seta a segunda unidade
		if !Empty(oObjItemPedido[nI]:C6SEGUM)
			
			nVlrSUn :=  Round(Round(oObjItemPedido[nI]:C6QTDVEN	 * oObjItemPedido[nI]:C6PRCVEN,2) / oObjItemPedido[nI]:C6UNSVEN, 2)
			
			aAdd(aItemLinha, {"C6_PRCSU", nVlrSUn,Nil})
			
			// seta a primeria unidade, devido a alterar a segunda
			AADD(aItemLinha,{"C6_QTDVEN",oObjItemPedido[nI]:C6QTDVEN	,Nil})
			aAdd(aItemLinha, {"C6_UNSVEN", oObjItemPedido[nI]:C6UNSVEN,Nil})
			
			// seta a primeira unidade, devido a alterar a segunda
			// Tem que adicionar novamente o campo, independente de ele já existir,
			// pois se alterar o conteúdo do campo existente vai dar erro ao inserir o pedido no SC6
			AADD(aItemLinha,{"C6_PRCVEN",(oObjItemPedido[nI]:C6UNSVEN * nVlrSUn) / oObjItemPedido[nI]:C6QTDVEN	,Nil})
			
			aAdd(aItemLinha, {"C6_IMPUNI","2",Nil})
		endif
		
		// DEVAIR 27/03/2015
		// COMENTADO
		//aAdd(aItemLinha, {"C6_QTDEMP",0,Nil}) 

		//aAdd(aItemLinha, {"C6_QTDLIB",oObjItemPedido[nI]:C6QTDVEN	,Nil})
		
		if !Empty(oObjItemPedido[nI]:C6LOTECTL)
			aAdd(aItemLinha, {"C6_LOTECTL",oObjItemPedido[nI]:C6LOTECTL,Nil})
		EndIf
		
		if !Empty(oObjItemPedido[nI]:C6RESERVA)
			aAdd(aItemLinha, {"C6_RESERVA",oObjItemPedido[nI]:C6RESERVA,Nil})
		EndIf
		
		// Armazena o valor original do item para retornar para o SFA
		aAdd(aItemLinha, {"C6_X_VLORI",Round(oObjItemPedido[nI]:C6QTDVEN	 * oObjItemPedido[nI]:C6PRCVEN,2),Nil})
		
		
		if !empty(cNumPedCom) .and. SC6->(FieldPos("C6_NUMPCOM")) > 0 
		     
			aAdd(aItemLinha, {"C6_NUMPCOM", alltrim(cNumPedCom), nil}) 
			
			if SC6->(FieldPos("C6_ITEMPC")) > 0 			
			
				if SA1->A1_COD=='18238980' 
				
					if AllTrim(oObjItemPedido[ni]:C6PRODUTO) == '11030028'
				
						aAdd(aItemLinha, {"C6_ITEMPC", alltrim(Str(10)), nil}) 		  				
						
					endif
			   
				else

					aAdd(aItemLinha, {"C6_ITEMPC", alltrim(Str(nI)), nil}) 		  
					
			    endif
							
			endif
					
		endif
        
		if lSFLogQry
			varinfo("Tipo de operacao inserida no pedido", cOper)
			varinfo("TES inserida no produto", cTes)
		endif
		
		// adiciona no array de itens
		aAdd(aItem, aItemLinha)
		
		// limpa pra nao duplicar as informações
		aItemLinha := {}
		
		
		//ARRAY PARA TRAVA DE SB1
		AADD(aTrSB1, PADR(SB1->B1_COD     , TAMSX3("B1_COD")[1]) )                                      
		
		//ARRAY PARA TRAVA DE SB2
		AADD(aTrSB2, PADR(cLocal, TAMSX3("B2_LOCAL")[1]) + PADR( SB1->B1_COD , TAMSX3("B2_COD")[1]) )
		
	next nI
	
Return aItem

 
//funcao que trata o log de erro diminuindo o tamanho
Static Function TrErrAut(aErro, nTipo, cChave)   

	local cErro := ""
	default cChave := "" 
	                     
	
	
	if nTipo == 1 //titulo do erro  
		
		nPosErro:= ASCAN(aErro, {|x| 'Tabela' $ x })   
		
		if nPosErro == 0
			nPosErro := len(aErro)
		endif
		
		for nI:=1 to nPosErro
			
			cErro += aErro[nI]+CRLF	     
	    
	    next nI

	else //detalhes do erro

		nPosErro:= ASCAN(aErro, {|x| cChave $ x })

		if nPosErro>0
		
			cErro := aErro[nPosErro]
		
		else                     
		
		    for nI:=1 to len(aErro)
		    
				cErro += aErro[nI] 
			
			next nI
		
		endif
				
	endif
	
Return cErro
                      
