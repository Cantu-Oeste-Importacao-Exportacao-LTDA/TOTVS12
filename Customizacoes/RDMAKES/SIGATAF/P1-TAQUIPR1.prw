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
Local cPeriodo := CMR->CMR_PERAPU //201808
   

   
dbselectarea("CMU")
dbsetorder(1) 
dbselectarea("CMV")
dbsetorder(1)
dbselectarea("CMT")
dbsetorder(1)

_Query := "SELECT SD1.D1_EMISSAO , SD1.D1_DOC, SD1.D1_SERIE, SUM(SD1.D1_TOTAL) AS D1_TOTAL, SA2.A2_CGC, SA2.A2_TIPO "
_Query += "FROM " +RetSqlName("SD1")+ " SD1, "+RetSqlName("SA2")+ " SA2 "                            
_Query += "WHERE SD1.D_E_L_E_T_ <> '*' AND SA2.D_E_L_E_T_ <> '*'  "      
_Query += "AND SA2.A2_COD = SD1.D1_FORNECE "   
_Query += "AND SA2.A2_LOJA = SD1.D1_LOJA "    
_Query += "AND SD1.D1_ALIQFUN = 1.5 AND SD1.D1_TES = '084'  "   
_Query += "AND SA2.A2_TIPO = 'F'  " 
_Query += "AND SD1.D1_FILIAL = '"+CMR->CMR_FILIAL+"' "
_Query += "AND SD1.D1_EMISSAO BETWEEN '"+cPeriodo + '01' + "' AND '"+cPeriodo +'31' +"' "
_Query += "GROUP BY SD1.D1_EMISSAO , SD1.D1_DOC, SD1.D1_SERIE, SA2.A2_CGC, SA2.A2_TIPO  "
_Query += "ORDER BY SA2.A2_CGC, SD1.D1_DOC "
TCQUERY _Query NEW ALIAS "QRY"

oSecResu:Init() 

dbselectarea("QRY")  

WHILE (!QRY->(EOF())) 
  
  
  //SD1.D1_FILIAL , SD1.D1_EMISSAO , SD1.D1_DOC, SD1.D1_SERIE, SUM(SD1.D1_TOTAL) AS D1_TOTAL, A2.A2_CGC, A2.A2_TIPO
 	oSecResu:Cell("FILIAL"):SetValue(CMR->CMR_FILIAL)
	oSecResu:Cell("DOC"):SetValue(QRY->D1_DOC)
	oSecResu:Cell("CLIENTE"):SetValue(QRY->A2_CGC)
 	oSecResu:Cell("EMISSAO"):SetValue(STOD(QRY->D1_EMISSAO))  
 	oSecResu:Cell("BASE"):SetValue(QRY->D1_TOTAL) 
 	oSecResu:Cell("VALOR"):SetValue(QRY->D1_TOTAL * 0.015) 
 
 	oSecResu:PrintLine() 
 	
 	cClient := QRY->A2_CGC
 	//DETALHA AS NOTAS 
 	dbselectarea("CMV")
 	IF !CMV->(dbSeek(CMR->CMR_FILIAL+ CMR->CMR_ID + CMR->CMR_VERSAO + "1" + QRY->A2_CGC + QRY->D1_SERIE +"  " + QRY->D1_DOC  ))  
 		RecLock("CMV",.T.)
		 CMV->CMV_FILIAL := CMR->CMR_FILIAL
		 CMV->CMV_ID		 := CMR->CMR_ID
		 CMV->CMV_VERSAO := CMR->CMR_VERSAO
		 CMV->CMV_INDAQU := "1" 
		 CMV->CMV_INSCPR := QRY->A2_CGC
		 CMV->CMV_SERIE  := QRY->D1_SERIE
		 CMV->CMV_NUMDOC := QRY->D1_DOC
		 CMV->CMV_DTEMIS := STOD(QRY->D1_EMISSAO)	 
		 CMV->CMV_VLBRUT := QRY->D1_TOTAL	
		 CMV->CMV_VLCONT := QRY->D1_TOTAL * 0.012
		 CMV->CMV_VLGILR := QRY->D1_TOTAL * 0.001 
		 CMV->CMV_VLSENA := QRY->D1_TOTAL * 0.002 	 	
 		MsUnlock("CMV")  
 	ELSE
 	
 		RecLock("CMV",.F.)
		 CMV->CMV_VLCONT := QRY->D1_TOTAL * 0.012
		 CMV->CMV_VLGILR := QRY->D1_TOTAL * 0.001 
		 CMV->CMV_VLSENA := QRY->D1_TOTAL * 0.002 	 	
 		MsUnlock("CMV") 
 		
 	ENDIF
	
	nTotalGer  += QRY->D1_TOTAL 
	nTotal += QRY->D1_TOTAL
	nContri += CMV->CMV_VLCONT
	nGilr += CMV->CMV_VLGILR 
	nSenar += CMV->CMV_VLSENA
	cTipo := QRY->A2_TIPO 
	
	DBSELECTAREA("QRY") 
	QRY->(dbSkip()) 
	
	IF cClient <> QRY->A2_CGC 
			
		//TOTAL POR FORNECEDOR OU POR CPF 
		dbselectarea("CMU")
 		IF !CMU->(dbSeek(CMR->CMR_FILIAL+ CMR->CMR_ID + CMR->CMR_VERSAO  + "1" + cClient ))  
			RecLock("CMU",.T.)
		   CMU->CMU_FILIAL := CMR->CMR_FILIAL
			 CMU->CMU_ID		 := CMR->CMR_ID
			 CMU->CMU_VERSAO := CMR->CMR_VERSAO
			 CMU->CMU_INDAQU := "1"  
			 CMU->CMU_TPINSC := "1"  
			 CMU->CMU_INSCPR := cClient
			 CMU->CMU_VLBRUT   := nTotal
			 CMU->CMU_VLCONT := nContri 
			 CMU->CMU_VLGILR := nGilr
			 CMU->CMU_VLSENA := nSenar	 	
			MsUnlock("CMU")   
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

