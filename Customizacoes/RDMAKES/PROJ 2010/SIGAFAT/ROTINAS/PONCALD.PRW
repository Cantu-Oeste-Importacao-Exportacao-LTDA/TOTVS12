/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Keslen de Andrade Deléo                                 !
+------------------+---------------------------------------------------------+
!Descricao         ! 			                                             !
+------------------+---------------------------------------------------------+
!Nome              ! PONCALD                                               !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 20/11/2013                                              !
+------------------+--------------------------------------------------------*/
//Caso o funcionário tenha direito ao premio de assiduidade (campo RA_X_PREMI), verifica se funcionário não possui nenhuma falta ou atestado e dá direito ao prêmio

#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"
    
   
User function PONCALD()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                                                                                                                         
		 
		 //Verifica se funcionário tem direito ao prêmio                              
		cQuery := " SELECT RA_MAT "
	  	cQuery += " FROM " + RetSqlName("SRA") + " SRA "
	  	cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' "  	
	  	cQuery += " AND RA_X_PREMI = '1' "
	  	cQuery += " AND RA_FILIAL = '" + SRA->RA_FILIAL + "' "
	  	cQuery += " AND RA_MAT = '" + SRA->RA_MAT + "' "

   		TCQUERY cQuery NEW ALIAS "QRY"
   		
   		QRY->(dbGoTop()) 
   		
   		if QRY->(Eof())
   			QRY->(DBCloseArea()) 
   			return
   		endif         
   		
        QRY->(DBCloseArea()) 
                   
		cDataIni := Substr(GETMV('MV_PONMES'),1,8)
		cDataFim := Substr(GETMV('MV_PONMES'),10,8)
		
	 	cQuery := " SELECT PC_DATA DATA "
	  	cQuery += " FROM " + RetSqlName("SPC") + " SPC "
	  	cQuery += " INNER JOIN " + RetSqlName("SP9") + " SP9 ON PC_PD = P9_CODIGO "
	  	cQuery += " WHERE SPC.D_E_L_E_T_ <> '*' "  	
	  	cQuery += " AND P9_CLASEV = '02' "
	  	cQuery += " AND PC_FILIAL = '" + SRA->RA_FILIAL + "' "
	  	cQuery += " AND PC_MAT = '" + SRA->RA_MAT + "' "  
	  	cQuery += " AND PC_DATA >= '" + cDataIni + "' "
	  	cQuery += " AND PC_DATA <= '" + cDataFim + "' "
	  	cQuery += " AND PC_ABONO = ' ' " 	  	
	  	cQuery += " UNION "
	  	cQuery += " SELECT R8_DATA DATA "
	  	cQuery += " FROM " + RetSqlName("SR8") + " SR8 "
	  	cQuery += " WHERE SR8.D_E_L_E_T_ <> '*' "  	
	  	cQuery += " AND R8_TIPO <> 'F' "
	  	cQuery += " AND R8_FILIAL = '" + SRA->RA_FILIAL + "' "
	  	cQuery += " AND R8_MAT = '" + SRA->RA_MAT + "' " 
	  	cQuery += " AND ((R8_DATAINI >= '" + cDataIni  + "' AND R8_DATAFIM <= '" + cDataFim + "') " 
	  	cQuery += "   OR (R8_DATAINI <  '" + cDataIni  + "' AND (R8_DATAFIM <= '" + cDataFim + "' AND R8_DATAFIM >= '" + cDataIni +"')) " 
	  	cQuery += "   OR ((R8_DATAINI >= '" + cDataIni  + "' AND R8_DATAINI <= '" + cDataFim + "') AND R8_DATAFIM >  '" + cDataFim + "') " 	  	
	  	cQuery += "   OR (R8_DATAINI <  '" + cDataIni  + "' AND R8_DATAFIM >  '" + cDataFim + "'))" 

   		TCQUERY cQuery NEW ALIAS "QRY"
   		QRY->(dbGoTop()) 
   		
   		if !QRY->(Eof())
   			QRY->(DBCloseArea()) 
   			return
   		endif     
   		
   		dbSelectArea("SPB")	
   		if RecLock("SPB",.T.)					
			SPB->PB_FILIAL := SRA->RA_FILIAL
			SPB->PB_MAT    :=  SRA->RA_MAT				
			SPB->PB_PD 	   := '104'
			SPB->PB_TIPO1  := 'V'
			SPB->PB_VALOR  := 100
			SPB->PB_DATA   := STOD(cDataFim)
			SPB->PB_CC     := SRA->RA_CC
			SPB->PB_TIPO2  := 'G'
			SPB->( MsUnlock() )	   
		endif 
		QRY->(DBCloseArea())   

return  
    	 
    	
    	
