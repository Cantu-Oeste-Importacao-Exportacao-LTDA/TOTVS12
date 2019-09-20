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
	    
	Case cModPgto == "01" .and. cTipoPag == "20" //CRษDITO EM CONTA CORRENTE PARA PAGAMENTO DE FORNECEDORES.
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' " 
	   	cFiltro += ".and. !(GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) $ '2/3') " 
	   	

	Case cModPgto == "01" .and. cTipoPag == "30" //CRษDITO EM CONTA CORRENTE PARA PAGAMENTO DE SALARIOS.
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "
		cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' " 
	   	cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' " 

		
	Case cModPgto == "05" .and. cTipoPag == "20" //CRษDITO EM CONTA POUPANวA PARA PAGAMENTO DE FORNECEDORES
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' " 
		cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '341' "      
		cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '2' "
	
	
	Case cModPgto == "13" .and. cTipoPag == "20" //PAGAMENTO CONCESSIONARIAS PARA PAGAMENTO DE FORNECEDORES
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "
		cFiltro += ".and. ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043' "	
	 
	
	Case cModPgto == "30" .and. cTipoPag == "20" //LIQUIDACAO DE TITULOS EM COBRANCA NO ITAU PARA PAGAMENTO DE FORNECEDORES
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "	
		cFiltro += ".and. Substr(E2_CODBAR,1,3) == '341' "	
	
		
	Case cModPgto == "31" .and. cTipoPag == "20" //LIQUIDACAO DE TITULOS EM OUTRO BANCO PARA PAGAMENTO DE FORNECEDORES
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) $ 'BO/DDA' "         
		cFiltro += ".and. Substr(E2_CODBAR,1,3) <> '341' "	
		cFiltro += ".and. !(ALLTRIM(E2_NATUREZ) $ '2015028/2015070/2015012/IG20007/2015001/2015043') "		
	
	
	Case cModPgto == "41" .and. cTipoPag == "20" //TED OUTRO TITULAR PARA PAGAMENTO DE FORNECEDORES
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '341' "   
		cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '3' "	


	Case cModPgto == "41" .and. cTipoPag == "30" //TED OUTRO TITULAR PARA PAGAMENTO DE SALARIOS
		cFiltro += ".and. ALLTRIM(E2_FORMPAG) == 'DE' "    
		cFiltro += ".and. GetAdvFval('SA2','A2_BANCO' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) <> '341' "   
		cFiltro += ".and. GetAdvFval('SA2','A2_TPCONTA' ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1) == '3' "	
		
EndCase
 

Return cFiltro