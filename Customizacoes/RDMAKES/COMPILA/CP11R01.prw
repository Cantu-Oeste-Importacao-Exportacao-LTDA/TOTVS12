#include "protheus.ch"
#include "TopConn.ch"
#include "report.ch"
#INCLUDE "COLORS.CH"


/*/{Protheus.doc} CP11R01
Relatório de consolidação e movimentações financeiras de cartão de crédito.	
@author Fabio Sales - www.compila.com.br
@since 03/11/2017
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

USER FUNCTION CP11R01()

	Local oReport
	Private cpCodAdq
	Private cpStatus
	Private cpModalid		
	Private cpBanco
	Private cpAg
	Private cpConta		
	
	oReport:= ReportDef()
	oReport:PrintDialog()
	
RETURN


/*/{Protheus.doc} ReportDef
Função principal de impressão.	
@author Fabio Sales - www.compila.com.br
@since 03/11/2017
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function ReportDef()

	Local oReport
	Local oSection
	Private cPerg    := "CP11R01"	
	
	AjustSX1(cPerg)
	
	Pergunte(cPerg,.T.) 
	
	cpCodAdq	:= STRTRAN(MV_PAR10,"*","")
	cpStatus	:= STRTRAN(MV_PAR11,"*","")
	cpModalid	:= MV_PAR12	
	cpBanco		:= MV_PAR05
	cpAg		:= MV_PAR06
	cpConta		:= MV_PAR07		
	
	oReport := TReport():New("CP11R01","Extrato Cartão de credito",cPerg,{|oReport| PrintReport(oReport)},"Relatório de análide de movimentações e extrato de pagamento de cartão de crédito")
	
	oSection1 := TRSection():New(oReport,OemToAnsi("Extrato de Cartão"),{"ZCA"})
	
	/*----------------------------------------------------------------------------------|
	|                       campo        alias  título       	 pic           tamanho  |
	|----------------------------------------------------------------------------------*/ 						
		//| Sintético
		
		TRCell():New(oSection1,"ZCA_FILIAL"	,"TREL","FILIAL	"			,"@!"				,20)			
		TRCell():New(oSection1,"ZCA_CODIGO"	,"TREL","CODIGO	"			,"@!"				,12)
		TRCell():New(oSection1,"ZCA_STATUS" ,"TREL","STATUS"			,"@!"				,35)	
		TRCell():New(oSection1,"ZCA_TPMOV"	,"TREL","TP. MOV"			,"@!"				,10)//,.F., {|| TREL->ZCA_TPMOV}) 	
		TRCell():New(oSection1,"ZCA_CODADQ"	,"TREL","COD. ADQ"			,"@!"				,03)	
		TRCell():New(oSection1,"ZC1_DESC"	,"TREL","ADQUIRENT"		    ,"@!"				,20)	
		TRCell():New(oSection1,"ZCA_CODBAN"	,"TREL","COD. BAND"			,"@!"				,03)	
		TRCell():New(oSection1,"ZC2_DESC"	,"TREL","BANDEIRA"		    ,"@!"				,20)	
		TRCell():New(oSection1,"ZCA_DTVEND" ,"TREL","DAT VENDA" 		,,10,.F.)
		TRCell():New(oSection1,"ZCA_DTPAG"  ,"TREL","DAT PGTO" 		    ,,10,.F.)		
		TRCell():New(oSection1,"ZCA_CODAUT"	,"TREL","CODIGO AUT. "		,"@!"				,06)
		TRCell():New(oSection1,"ZCA_CARMAS","TREL","CARTAO MASC."		,"@!"				,19)			
		TRCell():New(oSection1,"ZCA_FORMA","TREL","FORMA PGTO"			,"@!"				,2)	
		TRCell():New(oSection1,"ZCA_QTDPAR"	,"TREL","QTDE PARC."		,"@E 99",2)
		TRCell():New(oSection1,"ZCA_NUMPAC"	,"TREL","PARCELA"			,"@E 99",2)	
		TRCell():New(oSection1,"ZCA_VBRUTO"	,"TREL","VAL. BRUTO"		,"@E 999,999.99",16)
		TRCell():New(oSection1,"ZCA_VTAXA"	,"TREL","VAL. TAXA"			,"@E 999,999.99",16)
		TRCell():New(oSection1,"ZCA_PTAXA"	,"TREL","PERCENTUAL TAXA"	,"@E 999,999.999999",16)
		TRCell():New(oSection1,"ZCA_VLIQ"	,"TREL","VAL. lIQ"			,"@E 999,999.99",16)
		TRCell():New(oSection1,"ZCA_SALDO"	,"TREL","SALDO"				,"@E 999,999.99",16)	
		TRCell():New(oSection1,"ZCA_BANCO"	,"TREL","BANCO "			,"@!"				,03)
		TRCell():New(oSection1,"ZCA_AGENC","TREL","AGENCIA"				,"@!"				,9)	
		TRCell():New(oSection1,"ZCA_CONTA","TREL","CONTA"				,"@!"				,11)	
		TRCell():New(oSection1,"ZCA_CODEST"	,"TREL","NUM. EST. "		,"@!"				,15)
		TRCell():New(oSection1,"ZCA_LOG","TREL","LOG."					,"@!"				,40)
		TRCell():New(oSection1,"ZCA_CODRAZ","TREL","COD RAZAO"			,"@!"				,40)
		TRCell():New(oSection1,"ZCD_DESC","TREL","RAZAO STATUS"					,"@!"				,40)
		TRCell():New(oSection1,"ZCA_OBS","TREL","OBSERVACOES"			,"@!"				,250)			
	
		TRPosition():New(oSection1,"ZCA",1,{|| xFilial("ZCA")+TREL->ZCA_CODIGO })
	
	//| Caso a opção de impressão for o analítico, imprime a seção 2
	
	IF MV_PAR13==2
			
		oSection2 := TRSection():New(oSection1,"ZCA_CODIGO",{"TREL"})  
		
		TRCell():New(oSection2,"ZCB_ALIAS"	,"TREL","ENTIDADE"			,"@!"				,10)		
		TRCell():New(oSection2,"ZCB_TPOPER"	,"TREL","OPERACAO"			,"@!"				,12)
		TRCell():New(oSection2,"ZCB_DTMOV" ,"TREL","DAT MOVIMENMTO"		,,10,.F.)		
		TRCell():New(oSection2,"FILIAL" ,"TREL","FILIAL"				,"@!"				,35)
		TRCell():New(oSection2,"PREFIXO" ,"TREL","PREFIXO"				,"@!"				,4)
		TRCell():New(oSection2,"TITULO" ,"TREL","TITULO"				,"@!"				,10)
		TRCell():New(oSection2,"PARCELA" ,"TREL","PARCELA"				,"@!"				,2)
		TRCell():New(oSection2,"TIPO" ,"TREL","TIPO"					,"@!"				,3)
		TRCell():New(oSection2,"ZCB_MOTBX" ,"TREL","MOT. BAIXA"			,"@!"				,10)
		TRCell():New(oSection2,"ZCB_VLRMOV"	,"TREL","VAL. MOV"			,"@E 999,999.99",16)
		TRCell():New(oSection2,"ZCB_DTEST" ,"TREL","DAT ESTORNO"		,,10,.F.)
		TRCell():New(oSection2,"ZCB_HREST" ,"TREL","HOR. ESTE"			,"@!"				,10)			
				
	ENDIF
	
Return oReport


/*/{Protheus.doc} QFilSint
Filtra os dados para impressão do relatório sintético.
@author Fabio Sales - www.compila.com.br
@since 03/11/2017
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

Static Function QFilSint()

	Local cQuery := ""	
	Local cSGBD		:= ALLTRIM(UPPER(TCGetDB()))
	
	cQuery := " SELECT  * FROM (SELECT "
				
		cQuery += " 	ZCA_FILIAL  " +CRLF
		cQuery += " 	,ZCA_CODIGO " +CRLF
		cQuery += " 	,ZCA_STATUS " +CRLF
		cQuery += " 	,ZCA_TPMOV  " +CRLF
		cQuery += " 	,ZCA_CODADQ " +CRLF
		cQuery += " 	,ZC1_DESC   " +CRLF
		cQuery += " 	,ZCA_CODBAN " +CRLF
		cQuery += " 	,ZC2_DESC   " +CRLF
		cQuery += " 	,ZCA_DTVEND " +CRLF
		cQuery += " 	,ZCA_DTPAG  " +CRLF
		cQuery += " 	,ZCA_CODAUT " +CRLF
		cQuery += " 	,ZCA_CARMAS " +CRLF
		cQuery += " 	,ZCA_FORMA  " +CRLF
		cQuery += " 	,ZCA_QTDPAR " +CRLF
		cQuery += " 	,ZCA_NUMPAC " +CRLF
		cQuery += " 	,ZCA_VBRUTO " +CRLF
		cQuery += " 	,ZCA_VTAXA  " +CRLF
		cQuery += " 	,ZCA_PTAXA  " +CRLF
		cQuery += " 	,ZCA_VLIQ   " +CRLF
		cQuery += " 	,ZCA_SALDO  " +CRLF
		cQuery += " 	,ZCA_BANCO  " +CRLF
		cQuery += " 	,ZCA_AGENC  " +CRLF
		cQuery += " 	,ZCA_CONTA  " +CRLF
		cQuery += " 	,ZCA_CODEST " +CRLF
		cQuery += " 	,ZCA_OBS " +CRLF
		
		IF cSGBD == "ORACLE"
			cQuery += " 	,utl_raw.cast_to_varchar2(dbms_lob.substr(ZCA_LOG, 2000, 1)) AS ZCA_LOG " +CRLF
		ELSE
		 	cQuery += " 	,CONVERT(VARCHAR(8000),CONVERT(VARBINARY(8000),ZCA_LOG)) AS ZCA_LOG " +CRLF
		ENDIF	 		
		
		//cQuery += " 	,ISNULL(ZCA_LOG,'') ZCA_LOG   " +CRLF
		cQuery += " 	,ZCA_CODRAZ   " +CRLF
		cQuery += " 	,ISNULL(ZCD_DESC,'') ZCD_DESC   " +CRLF
			
	IF MV_PAR13 == 2 //| Anlítico
		
		cQuery += " 	,ISNULL(ZCB_CODIGO,'') ZCB_CODIGO " +CRLF
		cQuery += " 	,ISNULL(ZCB_CODMOV,'') ZCB_CODMOV " +CRLF
		cQuery += " 	,ZCB_ALIAS " +CRLF
		cQuery += " 	,ZCB_TPOPER " +CRLF
		cQuery += " 	,ZCB_DTMOV " +CRLF
		cQuery += " 	,ISNULL(E1_FILIAL,ISNULL(E5_FILIAL,'')) FILIAL " +CRLF
		cQuery += " 	,ISNULL(E1_PREFIXO,ISNULL(E5_FILIAL,'')) PREFIXO " +CRLF
		cQuery += " 	,ISNULL(E1_NUM,ISNULL(E5_NUMERO,'')) TITULO " +CRLF
		cQuery += " 	,ISNULL(E1_PARCELA,ISNULL(E5_PARCELA,'')) PARCELA " +CRLF
		cQuery += " 	,ISNULL(E1_TIPO,ISNULL(E5_TIPO,'')) TIPO " +CRLF
		cQuery += " 	,ZCB_MOTBX  " +CRLF
		cQuery += " 	,ZCB_VLRMOV " +CRLF
		cQuery += " 	,ZCB_DTEST  " +CRLF
		cQuery += " 	,ZCB_HREST  " +CRLF
		
	ENDIF
	
	cQuery += " FROM "+RetSqlName("ZCA")+" ZCA   " +CRLF
	cQuery += " LEFT JOIN "+RetSqlName("ZC2")+" ZC2   " +CRLF
	cQuery += " 	ON  ZCA_FILIAL=ZC2_FILIAL " +CRLF
	cQuery += " 	AND ZCA_CODBAN=ZC2_CODIGO " +CRLF
	cQuery += " 	AND ZC2.D_E_L_E_T_ <> '*' " +CRLF
	
	IF EMPTY(cpBanco) .AND. EMPTY(cpAg)	.AND. EMPTY(cpConta) 		
		cQuery += " LEFT JOIN "+RetSqlName("SA6")+" SA6  " +CRLF
	ELSE
		cQuery += " INNER JOIN "+RetSqlName("SA6")+" SA6  " +CRLF
	ENDIF
	 
	cQuery += " 	ON ZCA_BANCO = A6_COD" +CRLF
	cQuery += " 	AND ZCA_AGENC=A6_AGENCIA" +CRLF	
	cQuery += " 	AND ZCA_CONTA=A6_XCONCAR" +CRLF
	cQuery += " 	AND SA6.D_E_L_E_T_ <> '*'" +CRLF
	
	IF !EMPTY(cpBanco)
		cpBanco:= Alltrim(cpBanco)
		cQuery += " 	AND A6_COD = '"+cpBanco+"' " +CRLF
	ENDIF
	
	IF !EMPTY(cpAg)	
		cpAg:= Alltrim(cpAg) 
		cQuery += " 	AND A6_AGENCIA = '"+cpAg+"' " +CRLF
	ENDIF	
		
	IF !EMPTY(cpConta)	
		cpConta		:= ALLTRIM(cpConta)			
		cQuery += "  	AND A6_NUMCON = '"+cpConta+"' "+CRLF
	ENDIF	
	
	cQuery += " LEFT JOIN "+RetSqlName("ZCD")+" ZCD  " +CRLF
	cQuery += " 	ON ZCA_FILIAL = ZCD_FILIAL" +CRLF
	cQuery += " 	AND ZCA_CODRAZ= ZCD_CODIGO" +CRLF		
	cQuery += " 	AND ZCD.D_E_L_E_T_ <> '*'" +CRLF
	
	cQuery += " INNER JOIN " + RetSqlName("ZC1") + " ZC1   " +CRLF
	cQuery += " 	ON  ZCA_FILIAL=ZC1_FILIAL " +CRLF
	cQuery += " 	AND ZCA_CODADQ=ZC1_CODIGO " +CRLF
	cQuery += " 	AND ZC1.D_E_L_E_T_ <> '*'     " +CRLF
	
	IF MV_PAR13 == 2 //| Analítico
	
		cQuery += " LEFT JOIN "+RetSqlName("ZCB")+" ZCB   " +CRLF
		cQuery += " 	ON ZCA_FILIAL=ZCB_FILIAL " +CRLF
		cQuery += " 	AND ZCA_CODIGO=ZCB_CODMOV " +CRLF
		cQuery += " 	AND ZCB.D_E_L_E_T_ <> '*' " +CRLF
		cQuery += " LEFT JOIN "+RetSqlName("SE1")+" SE1  " +CRLF
		cQuery += " 	ON ZCB_ALIAS='SE1' " +CRLF
		cQuery += " 	AND SE1.R_E_C_N_O_= ZCB_RECALI " +CRLF
		cQuery += " 	AND SE1.D_E_L_E_T_ <> '*' " +CRLF
		cQuery += " LEFT JOIN "+RetSqlName("SE5")+" SE5   " +CRLF
		cQuery += " 	ON ZCB_ALIAS='SE5' " +CRLF
		cQuery += " 	AND SE1.R_E_C_N_O_= ZCB_RECALI " +CRLF
		cQuery += " 	AND SE1.D_E_L_E_T_ <> '*' " +CRLF
		
	ENDIF
	
	cQuery += " WHERE ZCA.D_E_L_E_T_ <> '*'       " +CRLF
	
	//| Filtra Adquirente.
	
	IF !EMPTY(cpCodAdq)
		cpCodAdq := Alltrim(cpCodAdq)		
		cQuery += " 	AND ZCA_CODADQ IN "+INQuery(cpCodAdq, ,3)
	ENDIF
	
	//| Filtra a modalidade.
	
	IF ALLTRIM(cpModalid) <> "****"
		cpModalid	:= ALLTRIM(cpModalid)	
		cForma		:= ""
		
		IF RIGHT(cpModalid,1) == "T"
			cForma	+= " "
		ENDIF
		
		IF SUBSTR(cpModalid,1,1) == "1"
			cForma	+= "D"
		ENDIF		
		
		IF SUBSTR(cpModalid,2,1) == "2" .OR. SUBSTR(cpModalid,3,1) == "3"
			cForma	+= "C"
			
			IF SUBSTR(cpModalid,2,2) == "2*"
				cQuery += " AND ZCA_QTDPAR <= 1 "+CRLF
			ELSEIF SUBSTR(cpModalid,2,2) == "*3"
				cQuery += " AND ZCA_QTDPAR > 1 "+CRLF
			ENDIF
		ENDIF	
		
		IF !EMPTY(cForma)
			cQuery += " AND ZCA_FORMA IN "+INQuery(cForma, ,1)
		ENDIF
		
	ENDIF
	
	//| Filtra Status.
	
	IF !EMPTY(cpStatus)
		cpStatus := Alltrim(cpStatus)		
		cQuery += " 	AND ZCA_STATUS IN "+INQuery(cpStatus, ,1)
	ENDIF		
	
	cQuery += " 	AND CASE WHEN ZCA_DTVEND <> '' THEN ZCA_DTVEND ELSE ZCA_DTPAG END BETWEEN '" + DTOS(MV_PAR01) + "' AND '"+DTOS(MV_PAR02)+"'  " +CRLF	
	cQuery += " 	AND ZCA_DTPAG  BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' ) "
	IF cSGBD <> "ORACLE"
		cQuery += " AS  TRB "+CRLF
	ENDIF
	
	IF MV_PAR13==2 //| Analítico
			
		cQuery += " 	WHERE FILIAL BETWEEN  '"+ALLTRIM(MV_PAR08)+"' AND '"+ALLTRIM(MV_PAR09)+"' "
		
		IF MV_PAR14==2
			cQuery += " 	AND  ZCB_DTEST = '' "		
		ENDIF	
		cQuery += " 	ORDER BY ZCB_CODMOV DESC,ZCA_CODIGO,ZCB_CODIGO "	
	ENDIF
	
	IF SELECT("TREL") > 0                                                                                    
		dbSelectArea("TREL")
		TREL->(DbCloseArea())
	ENDIF
	cQuery	:= changeQuery(cQuery)
	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TREL", .F., .T.)
	IF !(ISBLIND())
		MemoWrite(GetTempPath(.T.) + "CP11R01.SQL", cQuery)
	ENDIF 

	
	TCSetField("TREL","ZCA_DTVEND","D",08,00)	
	TCSetField("TREL","ZCA_DTPAG","D",08,00)
	
	IF MV_PAR13==2 //| Analítico
		TCSetField("TREL","ZCB_DTMOV","D",08,00)	
		TCSetField("TREL","ZCB_DTEST","D",08,00)
	ENDIF

Return()

/*/{Protheus.doc} PrintReport
Função responsável pela filtragem dos dados e impressão dos registros.	
@author Fabio Sales - www.compila.com.br
@since 03/11/2017
@version version
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/                                                                                                                        

Static Function PrintReport(oReport)

	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(1):Section(1)  
	Local nCount	:= 0  
	Local clCodZCA	:= ""
	
	//| Cria tabela temporária com os dados filtrados de acordo com os parâmetros selecionados.
	
	MsAguarde({|| QFilSint()},"Selecionando Dados")
	
	DBSelectArea("TREL")
	TREL->(DBGoTop())	
	TREL->( dbEval( {|| nCount++ } ) )	
	TREL->(DBGoTop())
	
	oReport:SetMeter(nCount)
	oReport:StartPage()	
	
	//|Quando for sintético imprime somente um cabeçalho.

	IF MV_PAR13==1 //| Sintético
		oSection1:Init()	
	ENDIF
	llSecZCA := .F.
	While  !Eof()
	
		If oReport:Cancel()
			Exit
		EndIf
				
		IF MV_PAR13==2 	//| Analítico
						
			//| Controle para Iniciar a Seção1 somente uma vez quando 
			//| não existir mais dados de movimentações financeira.		
										
			IF EMPTY(TREL->ZCB_CODIGO) .AND. !llSecZCA			
				llSecZCA := .T. 
				oSection1:Init()
		    ENDIF
		    
		    IF !llSecZCA
		    	oSection1:Init()
		    ENDIF
		    
		    oSection1:PrintLine() 
		                    							
			clCodZCA :=  TREL->ZCA_CODIGO
			llImp:= .T.
			While TREL->(!Eof()) .AND. clCodZCA == TREL->ZCA_CODIGO
				
				//Inicia a seção2 somente uma vez dentro da condição.
								
				IF llImp
					oSection2:Init()
					llImp := .F.
				ENDIF
				
				//| Só imprime a linha da Seção dois se existi movimentação financeira.
				
				IF !EMPTY(TREL->ZCB_CODIGO)
					oSection2:PrintLine() 
				ENDIF
				
				DbSelectArea("TREL")
				oReport:IncMeter()		
				TREL->(DbSkip())
			
			ENDDO
			
		ELSE
		
			oSection1:PrintLine()
								
		ENDIF
		
		IF MV_PAR13==2 //| Analítico
		
			IF !llImp
				oSection2:Finish()
			ENDIF
			
			IF !llSecZCA		
				oSection1:Finish()
			ENDIF
		ELSE
			oReport:IncMeter()
			TREL->(DbSkip())
		ENDIF
										
	EndDo
		
	IF MV_PAR13==1 .OR. llSecZCA
		oSection1:Finish()
	ENDIF
		
	If Sele("TREL") <> 0
		TREL->(DbCloseArea())
	Endif

Return

/*/{Protheus.doc} AjustSX1
Cria perguntas no SX1
@author Fabio Sales | www.compila.com.br
@since 03/11/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function AjustSX1(cPerg)

	Local aArea := GetArea()
	Local aHelpPor	:= {}
	Local aHelpEng	:= {}
	Local aHelpSpa	:= {}
	
	aAdd( aHelpEng, "  ")
	aAdd( aHelpSpa, "  ")
	
	
	
	aHelpPor := {} ; Aadd( aHelpPor, "Data Transacao De")
	XPUTSX1( cPerg, "01","Data Transacao De","","","mv_ch1","D",08,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Data Transacao Ate")
	XPUTSX1( cPerg, "02","Data Transacao Ate","","","mv_ch2","D",08,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Data Credito De")
	XPUTSX1( cPerg, "03","Data Credito De","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Data Credito Ate")
	XPUTSX1( cPerg, "04","Data Credito Ate","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Banco")
	XPUTSX1( cPerg, "05","Banco"	,"","","mv_ch5","C",TAMSX3("A6_COD")[1],0,0,"G","","SA6CP9","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Agencia")
	XPUTSX1( cPerg, "06","Agencia"	,"","","mv_ch6","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Conta")
	XPUTSX1( cPerg, "07","Conta"	,"","","mv_ch7","C",TAMSX3("A6_NUMCON")[1],0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
		
	aHelpPor := {} ; Aadd( aHelpPor, "Filial de.")
	XPUTSX1( cPerg, "08","Filial de:"		,"","","mv_ch8","C",TAMSX3("E1_FILIAL")[1],0,0,"G","","SM0"	,"","","mv_par08","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpPor := {} ; Aadd( aHelpPor, "Filial Ate.")
	XPUTSX1( cPerg, "09","Filial ate:"		,"","","mv_ch9","C",TAMSX3("E1_FILIAL")[1],0,0,"G","","SM0"	,"","","mv_par09","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	aHelpX1 := {" Selecione as Adquirentes."," Selecione as Adquirentes para ",	"o processamento"}
	XPUTSX1( cPerg, "10","Adquirentes "		,"","","mv_cha","C",60,0,0,"G","U_CP1111X1('1')"	,"   ","","","mv_par10","","","","","","","","","","","","","","","","",aHelpX1,aHelpX1,aHelpX1 )
	
	aHelpX1 := {" Selecione os  status."," Selecione os status ",	"o processamento"}
	XPUTSX1( cPerg, "11","Status "		,"","","mv_chb","C",60,0,0,"G","U_CP1111X1('4')"	,"   ","","","mv_par11","","","","","","","","","","","","","","","","",aHelpX1,aHelpX1,aHelpX1 )
	
	aHelpX1 := {" Selecione a modalidade."," Selecione a modalidade ",	"o processamento"}
	XPUTSX1( cPerg, "12","Modalidade"		,"","","mv_chc","C",60,0,0,"G","U_CP1111X1('2')"	,"   ","","","mv_par12","","","","","","","","","","","","","","","","",aHelpX1,aHelpX1,aHelpX1 )		
	
	aHelpPor := {} ; Aadd( aHelpPor, "Tipo de relatório")
	XPUTSX1( cPerg, "13","Tipo de relatorio","","","mv_chd","N",01,0,0,"C","","","","","mv_par13","Sintético","","","","Analitico","Analitico","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )	

	aHelpPor := {} ; Aadd( aHelpPor, "Tipo de relatório")
	XPUTSX1( cPerg, "14","Imprime Estorno","","","mv_che","N",01,0,0,"C","","","","","mv_par14","Sim","","","","Nao","Nao","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )
	
	RestArea(aArea)
	
Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ AUGUSTO RIBEIRO                                  ³   
//³                                                  ³
//³ Recebe String separa por caracter "X"            ³
//³ ou Numero de Caractres para "quebra" _nCaracX)   ³
//³ Retorna String pronta para IN em selects         ³
//³ Ex.: Retorn: ('A','C','F')                       ³
//³                                                  ³
//³ PARAMETROS:  _cString, _cCaracX                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function INQuery(_cString, _cCaracX, _nCaracX)
Local _cRet	:= ""                  
Local _cString, _cCaracX, _nCaracX, nY
Local _aString	:= {}                            
Default	_nCaracX := 0                   
                                                                  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida Informacoes Basicas ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    IF !EMPTY(_cString) .AND. (!EMPTY(_cCaracX) .OR. _nCaracX > 0)
                                
    	nString	:= LEN(_cString)    		

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza Separacao por Numero de Caracteres ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IF _nCaracX > 0
			FOR nY := 1 TO nString STEP _nCaracX
			
				AADD(_aString, SUBSTR(_cString,nY, _nCaracX) )
			
			Next nY
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Utiliza Separacao por caracter especifico ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ELSE
			_aString	:= WFTokenChar(_cString, _cCaracX)		
		ENDIF
	                
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Monta String para utilizar com IN em querys³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		_cRet	+=  "('"		
		FOR _nI := 1 TO Len(_aString)
			IF _nI > 1
				_cRet	+= ",'"
			ENDIF
			_cRet += ALLTRIM(_aString[_nI])+"'"	
		Next _nI
		_cRet += ") "  
		
	ENDIF

Return(_cRet) 




/*/{Protheus.doc} xPutSx1
(long_description)
@author DESCONHECIDO
@since 11/09/2018
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
cF3, cGrpSxg,cPyme,;
cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa := .f.
Local lIngl := .f.

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
cF3      := Iif( cF3           == NIl, " ", cF3          )
cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

dbSelectArea( "SX1" )
dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !( DbSeek( cGrupo + cOrdem ))
	
	cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
	cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
	cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	
	Reclock( "SX1" , .T. )
	
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA With cPerSpa
	Replace X1_PERENG With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid
	
	Replace X1_VAR01   With cVar01
	
	Replace X1_F3      With cF3
	Replace X1_GRPSXG With cGrpSxg
	
	If Fieldpos("X1_PYME") > 0
		If cPyme != Nil
			Replace X1_PYME With cPyme
		Endif
	Endif
	
	Replace X1_CNT01   With cCnt01
	If cGSC == "C"               // Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1
		
		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2
		
		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3
		
		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4
		
		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif
	
	Replace X1_HELP With cHelp
	
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	MsUnlock()
Else
	
	lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
	lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
	
	If lPort .Or. lSpa .Or. lIngl
		RecLock("SX1",.F.)
		If lPort
			SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
		EndIf
		If lSpa
			SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
		EndIf
		If lIngl
			SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
		EndIf
		SX1->(MsUnLock())
	EndIf
Endif

RestArea( aArea )

Return



