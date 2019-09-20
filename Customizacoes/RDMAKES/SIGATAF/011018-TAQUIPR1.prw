#include "protheus.ch"
#Include "Topconn.ch"  
///////////////////////////////////////////////////////
//AQUISÇAO DE PRODUTOR RURAL REINF/ESOCIAL           //
//VOLMIR 13-09-18  									                 //
/////////////////////////////////////////////////////// 

User Function TAQUIPR1() 

Local aArea := GetArea()
Local cTitulo := "Aquisicao Produtor Rural"
 
              
                
  cCadastro := "Aquisicao Produtor Rural"

  aRotina := {{"Pesquisar" 	,"AxPesqui"						,0,1},;
              {"Visualizar"	,"AxVisual"						,0,2},;             
              {"Alterar"    ,'ExecBlock("TAQUIPR2",.f.,.f.)',0,4}}
             
            
 
  
  DbSelectArea("CMR")
  MBrowse(6, 1, 22, 75, "CMR",,,,,,)

 
  RestArea(aArea)

Return



User Function TAQUIPR2()
Local oReport
oReport := ReportDef()
oReport:PrintDialog()  

Return

Static Function ReportDef()
Local oReport
Local oSecResu 
Local oSecTot
                                                             

oReport := TReport():New("TAQUIPR2","AQUISIÇÃO PRODUTOR RURAL" ,"TAQUIPR2",{|oReport| PrintReport(oReport)},"TAQUIPR2")
oReport:nFontBody := 9  
oReport:SetLandScape(.T.)  
oReport:nColSpace := 0 

oSecResu := TRSection():New(oReport,"Notas") 


TRCell():New(oSecResu,"FILIAL","","FILIAL",,6)  
TRCell():New(oSecResu,"DOC","","NOTA FISCAL",,8)  
TRCell():New(oSecResu,"CLIENTE","","CLIENTE",,10) 
TRCell():New(oSecResu,"EMISSAO","","EMISSAO",,11)
TRCell():New(oSecResu,"BASE","","BASE CALCULO","@E 999,999,999.99",12)  
TRCell():New(oSecResu,"VALOR","","CONTRIBUICAO","@E 999,999,999.99",12)  


oSecResu:lTotalInline := .F.
TRFunction():New(oSecResu:Cell("BASE"),,"SUM",,,"@E 999,999,999.99",,.T.,.F.) 
TRFunction():New(oSecResu:Cell("VALOR"),,"SUM",,,"@E 999,999,999.99",,.T.,.F.)    


Return oReport
 
// funcão que imprime o relatório
Static Function PrintReport(oReport) 
 
Local oSecResu   := oReport:Section(1)
Local _Query   := ""
Local nTotal  := 0
Local nGilr := 0
Local nSenar := 0 
Local nContri := 0 
Local nTotalGer := 0
Local nTotalJu := 0  
Local cClient := "" 
Local cTipo := "" 
Local cCGC := ""
Local nTotaNF := 0   
Local cPeriodo := CMR->CMR_PERAPU //201808
   

   
dbselectarea("CMU")
dbsetorder(1) 
dbselectarea("CMV")
dbsetorder(1)
dbselectarea("CMT")
dbsetorder(1)

_Query := "SELECT SD1.D1_EMISSAO , SD1.D1_DOC, SD1.D1_SERIE,SA2.A2_CGC, SA2.A2_TIPO, SD1.D1_FORNECE, SD1.D1_LOJA,SA2.A2_X_CPF,  SUM(SD1.D1_TOTAL) AS D1_TOTAL  "
_Query += "FROM " +RetSqlName("SD1")+ " SD1, "+RetSqlName("SA2")+ " SA2 "                            
_Query += "WHERE SD1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*'  "      
_Query += "AND SA2.A2_COD = SD1.D1_FORNECE "   
_Query += "AND SA2.A2_LOJA = SD1.D1_LOJA "    
_Query += "AND SD1.D1_ALIQFUN = 1.5  " //AND SD1.D1_TES = '084'  "   
//_Query += "AND SA2.A2_TIPO = 'F'  " 
_Query += "AND SD1.D1_FILIAL = '"+CMR->CMR_FILIAL+"' "
_Query += "AND SD1.D1_EMISSAO BETWEEN '"+cPeriodo + '01' + "' AND '"+cPeriodo +'31' +"' "
_Query += "GROUP BY SD1.D1_EMISSAO , SD1.D1_DOC, SD1.D1_SERIE, SA2.A2_CGC, SA2.A2_TIPO,SD1.D1_FORNECE, SD1.D1_LOJA, SA2.A2_X_CPF  "
_Query += "ORDER BY SA2.A2_CGC, SD1.D1_DOC "
TCQUERY _Query NEW ALIAS "QRY"

oSecResu:Init() 

dbselectarea("QRY")  

WHILE (!QRY->(EOF())) 

	nTotaNF :=  QRY->D1_TOTAL 
	
	//SE FOR PJ
	IF  QRY->A2_TIPO <> "F" 
		cCGC :=  QRY->A2_X_CPF + SPACE(3)
	ELSE
		cCGC := 	QRY->A2_CGC
	ENDIF
 	//BUSCA AS DEVOLUÇOES		
	_Query := "SELECT D2_DOC, D2_EMISSAO,SUM(D2_TOTAL) AS D2_TOTAL "
	_Query += "FROM "+ RetSqlName("SD2") + " SD2 "
	_Query += "WHERE D2_FILIAL='" + CMR->CMR_FILIAL + "' AND "
	_Query += "SD2.D_E_L_E_T_<>'*' AND " 
	_Query += "D2_LOJA = '"+QRY->D1_LOJA+"' AND "
	_Query += "D2_CLIENTE = '"+QRY->D1_FORNECE+"' AND "
	_Query += "D2_NFORI = '"+QRY->D2_DOC+"'  AND "	
	_Query += "D2_SERIORI = '"+QRY->D1_SERIE+"'  AND "
	_Query += "D2_EMISSAO >= '"+QRY->D1_EMISSAO+"'  AND "	 
	_Query += "D2_TIPO = 'D' "  
	_Query += "GROUP BY D2_DOC, D2_EMISSAO "
	TCQUERY _Query NEW ALIAS "DSD2" 		
	While !DSD2->(eof())
	 
		  //DESCONTA O VALOR DEVOLVIDO
			nTotaNF -= DSD2->D2_TOTAL 
				
			oSecResu:Cell("FILIAL"):SetValue(CMR->CMR_FILIAL)
			oSecResu:Cell("DOC"):SetValue(DSD2->D2_DOC)
			oSecResu:Cell("CLIENTE"):SetValue(cCGC)
		 	oSecResu:Cell("EMISSAO"):SetValue(STOD(DSD2->D2_EMISSAO))  
		 	oSecResu:Cell("BASE"):SetValue(0 - DSD2->D2_TOTAL ) 
		 	oSecResu:Cell("VALOR"):SetValue(0 - DSD2->D2_TOTAL * 0.015) 
 			oSecResu:PrintLine() 
 			
			DSD2->(dbSkip()) 
	EndDo  
	DSD2->(DbCloseArea()) 
  
 	oSecResu:Cell("FILIAL"):SetValue(CMR->CMR_FILIAL)
	oSecResu:Cell("DOC"):SetValue(QRY->D1_DOC)
	oSecResu:Cell("CLIENTE"):SetValue(cCGC)
 	oSecResu:Cell("EMISSAO"):SetValue(STOD(QRY->D1_EMISSAO))  
 	oSecResu:Cell("BASE"):SetValue(nTotaNF) 
 	oSecResu:Cell("VALOR"):SetValue(nTotaNF * 0.015) 
 
 	oSecResu:PrintLine() 
 	
 	cClient := QRY->A2_CGC  
 	
 	//DETALHA AS NOTAS 
 	dbselectarea("CMV")
 	IF !CMV->(dbSeek(CMR->CMR_FILIAL+ CMR->CMR_ID + CMR->CMR_VERSAO + "1" + cCGC + QRY->D1_SERIE +"  " + QRY->D1_DOC  ))   
 	
 		IF nTotaNF > 0 //SE FOR MAIOR Q ZERRO E AINDA NAO FOI CADASTRADO  
	 		RecLock("CMV",.T.)
			 CMV->CMV_FILIAL := CMR->CMR_FILIAL
			 CMV->CMV_ID		 := CMR->CMR_ID
			 CMV->CMV_VERSAO := CMR->CMR_VERSAO
			 CMV->CMV_INDAQU := "1" 
			 CMV->CMV_INSCPR := cCGC
			 CMV->CMV_SERIE  := QRY->D1_SERIE
			 CMV->CMV_NUMDOC := QRY->D1_DOC
			 CMV->CMV_DTEMIS := STOD(QRY->D1_EMISSAO)	 
			 CMV->CMV_VLBRUT := nTotaNF
			 CMV->CMV_VLCONT := nTotaNF * 0.012
			 CMV->CMV_VLGILR := nTotaNF * 0.001 
			 CMV->CMV_VLSENA := nTotaNF * 0.002 	 	
	 		MsUnlock("CMV")  
	 	ENDIF  
	 	
	ELSE
	 	
		RecLock("CMV",.F.)
		 CMV->CMV_VLCONT := nTotaNF * 0.012
		 CMV->CMV_VLGILR := nTotaNF * 0.001 
		 CMV->CMV_VLSENA := nTotaNF * 0.002 	 	
		MsUnlock("CMV") 
	 		
	ENDIF
		
	nTotalGer  += nTotaNF 
	nTotal += nTotaNF
	nContri += CMV->CMV_VLCONT
	nGilr += CMV->CMV_VLGILR 
	nSenar += CMV->CMV_VLSENA
	
		 
			
	DBSELECTAREA("QRY") 
	QRY->(dbSkip()) 
	
	IF cClient <> QRY->A2_CGC 
			
		//TOTAL POR FORNECEDOR OU POR CPF 
		dbselectarea("CMU")
 		IF !CMU->(dbSeek(CMR->CMR_FILIAL+ CMR->CMR_ID + CMR->CMR_VERSAO  + "1" + cCGC ))     
 		
 			IF nTotal > 0 //SE O VALOR TOTAL NAO FOI DEVOLVIDO   
 			
				RecLock("CMU",.T.)
			   CMU->CMU_FILIAL := CMR->CMR_FILIAL
				 CMU->CMU_ID		 := CMR->CMR_ID
				 CMU->CMU_VERSAO := CMR->CMR_VERSAO
				 CMU->CMU_INDAQU := "1"  
				 CMU->CMU_TPINSC := "1"  
				 CMU->CMU_INSCPR := cCGC
				 CMU->CMU_VLBRUT := nTotal
				 CMU->CMU_VLCONT := nContri 
				 CMU->CMU_VLGILR := nGilr
				 CMU->CMU_VLSENA := nSenar	 	
				MsUnlock("CMU")
				
			ENDIF   
			
		ELSE
		
			RecLock("CMU",.F.)		  
			 CMU->CMU_VLBRUT   := nTotal
			 CMU->CMU_VLCONT := nContri 
			 CMU->CMU_VLGILR := nGilr
			 CMU->CMU_VLSENA := nSenar	 	
			MsUnlock("CMU")  
			
		ENDIF 
			
		nGilr := 0
		nSenar := 0  
		nTotal := 0 
		nContri := 0
			
	ENDIF
	
	 
EndDo  
QRY->(DbCloseArea())  

//GRAVA O TOTAL GERAL
dbselectarea("CMT")
IF !CMT->(dbSeek(CMR->CMR_FILIAL+ CMR->CMR_ID + CMR->CMR_VERSAO  )) 
 
	RecLock("CMT",.T.)
	 CMT->CMT_FILIAL := CMR->CMR_FILIAL
	 CMT->CMT_ID	 := CMR->CMR_ID
	 CMT->CMT_INDAQU := "1"
	 CMT->CMT_VLAQUI := nTotalGer	
	 CMT->CMT_VERSAO := CMR->CMR_VERSAO	 	
	MsUnlock("CMT") 
	
ELSE   

	RecLock("CMT",.F.)
	 CMT->CMT_VLAQUI := nTotalGer		 	
	MsUnlock("CMT")  
	
ENDIF

oSecResu:Finish()

Return 

