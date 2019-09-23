#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH" 
#INCLUDE "RWMAKE.CH"  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF240FIL   บAutor  ณMicrosiga           บ Data ณ  15/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Filtro dos tํtulos na rotina de border๔ a pagar.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Cantu                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function F240FIL
    
Local cFiltro :=  "!(E2_FORNECE $ '00163222/03588984/22149730/22149803/524867969')" 


Do Case

	//CRษDITO EM CONTA CORRENTE BANCO ITAU PARA PAGAMENTO DE FORNECEDORES.
	    Case cPort240 == "341" .and. cModPgto == "01" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' " 
	   	 cFiltro += ".and. !(GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) $ '2/3') " 
	
	//CRษDITO EM CONTA CORRENTE BANCO BRASIL PARA PAGAMENTO DE FORNECEDORES.
	Case cPort240 == "001" .and. cModPgto == "01" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '001' " 
	     cFiltro += ".and. !(GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) $ '2/3') "  
	   	
    
	//CRษDITO EM CONTA CORRENTE BANCO SAFRA PARA PAGAMENTO DE FORNECEDORES.
	Case cPort240 == "422" .and. cModPgto == "01" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '422' " 
	     cFiltro += ".and. !(GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) $ '2/3') "  
	   	
    
    //CRษDITO EM CONTA CORRENTE BANCO ITAU PARA PAGAMENTO DE SALARIOS.
    Case cPort240 == "341" .and. cModPgto == "01" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' " 
	   	 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' " 
	   	
	   	
    //CRษDITO EM CONTA CORRENTE BANCO BRASIL PARA PAGAMENTO DE SALARIOS.
    Case cPort240 == "001" .and. cModPgto == "01" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '001' " 
	   	 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "    	

	   	
    //CRษDITO EM CONTA CORRENTE BANCO SAFRA PARA PAGAMENTO DE SALARIOS.
    Case cPort240 == "422" .and. cModPgto == "01" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '422' " 
	   	 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "    	

	
	//CRษDITO EM CONTA POUPANวA ITAU PARA PAGAMENTO DE FORNECEDORES	
	Case cPort240 == "341" .and. cModPgto == "05" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' " 
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' "      
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '2' "
	
	
	//CRษDITO EM CONTA POUPANวA BRASIL PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "001" .and. cModPgto == "05" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' " 
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '001' "      
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '2' "

	
	//CRษDITO EM CONTA POUPANวA SAFRA PARA PAGAMENTO DE FORNECEDORES	
	Case cPort240 == "422" .and. cModPgto == "05" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' " 
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '422' "      
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '2' "
	
	
	//PAGAMENTO CONCESSIONARIAS ITAU PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "341" .and. cModPgto == "13" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "
		 cFiltro += ".and. ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043' "	
	 
	
	//LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU PARA PAGAMENTO DE FORNECEDORES (BOLETOS)
	Case cPort240 == "341" .and. cModPgto == "30" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "	
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) == '341' "	
		
	
	//LIQUIDACAO DE TITULOS EM COBRANCA NO BRAISL PARA PAGAMENTO DIVERSOS (BOLETOS)
	Case cPort240 == "001" .and. cModPgto == "30" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "	
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) == '001' "	
	
		
	
	//LIQUIDACAO DE TITULOS EM COBRANCA NO SAFRA PARA PAGAMENTO DIVERSOS (BOLETOS)
	Case cPort240 == "422" .and. cModPgto == "30" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "	
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) == '422' "	
	
		
	//LIQUIDACAO DE TITULOS EM OUTRO BANCO ITAU PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "341" .and. cModPgto == "31" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "         
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) <> '341' "	
		 cFiltro += ".and. !(ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043') "		
		
	
	//LIQUIDACAO DE TITULOS EM OUTRO BANCO BRASIL PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "001" .and. cModPgto == "31" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "         
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) <> '001' "	
		 cFiltro += ".and. !(ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043') "		
	
	
	//LIQUIDACAO DE TITULOS EM OUTRO BANCO SAFRA PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "422" .and. cModPgto == "31" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "         
		 cFiltro += ".and. Substr(E2_CODBAR,1,3) <> '422' "	
		 cFiltro += ".and. !(ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043') "		
	
	
	//TED OUTRO TITULAR ITAU PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "341" .and. cModPgto == "41" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '341' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '3' "	
		
	
	//TED OUTRO TITULAR BRASIL PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "001" .and. cModPgto == "41" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '001' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '3' "	

	
	
	//TED OUTRO TITULAR SAFRA PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "422" .and. cModPgto == "41" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '422' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '3' "	

	
	//TED OUTRO TITULAR ITAU PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "341" .and. cModPgto == "41" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '341' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "	

	
	//TED OUTRO TITULAR PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "001" .and. cModPgto == "41" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '001' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "	
		 

	
	//TED OUTRO TITULAR PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "422" .and. cModPgto == "41" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '422' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "	
		 
		 
	//TED MESMO TITULAR ITAU PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "341" .and. cModPgto == "43" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '1' "	
		 
	
	//TED MESMO TITULAR BRASIL PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "001" .and. cModPgto == "43" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '001' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '1' "	
		 
	
	
	//TED MESMO TITULAR SAFRA PARA PAGAMENTO DE FORNECEDORES
	Case cPort240 == "422" .and. cModPgto == "43" .and. cTipoPag == "20" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '422' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '1' "	
		 
	
	//TED MESMO TITULAR ITAU PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "341" .and. cModPgto == "43" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "		
		 
	//TED MESMO TITULAR BRASIL PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "001" .and. cModPgto == "43" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '001' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "		  	 	 
		 
	//TED MESMO TITULAR SAFRA PARA PAGAMENTO DE SALARIOS
	Case cPort240 == "422" .and. cModPgto == "43" .and. cTipoPag == "30" 
		 cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		 cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '422' "   
		 cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "		  	 	 
		
EndCase
 

Return cFiltro