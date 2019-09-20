#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  06/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     WORKFLOW FÉRIAS VENCIDAS   - CHAMADO 361                     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFFERVENC()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp()
Return .T.

/******************************************************************
Workflow Férias Vencidas, avisar de 3 em 3 dias -> chamado 361
 *****************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()  
Local oHtml    := nil 
Local oProcess
Local cSegme


cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SRA.RA_X_SEGME, SRF.RF_DFERVAT, SRF.RF_DFERAAT"
cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
cQuery += " LEFT JOIN "+RetSqlName("SRF")+" SRF ON SRA.RA_MAT = SRF.RF_MAT AND SRF.RF_FILIAL = '" + xFilial("SRF") + "'" 
cQuery += " WHERE SRF.RF_DFERVAT = '30' AND SRF.RF_DFERAAT >= '25'AND"  
cQuery += " SRA.D_E_L_E_T_ <> '*' AND SRF.D_E_L_E_T_ <> '*' AND SRA.RA_DEMISSA = ' '" 
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlFerias.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
   	
  While !TMP->(Eof())
            
		  oProcess := TWFProcess():New( "WFFERVENC", "VENCIMENTO DE FÉRIAS")  
			oProcess:NewTask( "WFFERVENC", "\WORKFLOW\wfferiasvenc.htm" )
	   	oProcess:cSubject := "Funcionários com  férias vencidas " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
	  	oHTML := oProcess:oHTML 

     if cSegme <> TMP->RA_CC
			  ZA1->(DbSelectArea("ZA1"))
			  ZA1->(DbSetOrder(1))
		  	ZA1->(DbGotop())    
        
       if ZA1->(DbSeek(xFilial("ZA1")+TMP->RA_CC))  
			    cEmail := AllTrim(ZA1->ZA1_EMAIL) 
			    cSegme := TMP->RA_CC
				
	
			    cQuery := ""  	  	 
			    cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
			    cQuery += " SRA.RA_X_SEGME, SRF.RF_DFERVAT, SRF.RF_DFERAAT"
			    cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
			    cQuery += " LEFT JOIN "+RetSqlName("SRF")+" SRF ON SRA.RA_MAT = SRF.RF_MAT AND SRF.RF_FILIAL = '" + xFilial("SRF") + "'" 
			    cQuery += " WHERE SRF.RF_DFERVAT = '30' AND SRF.RF_DFERAAT >= '25'AND"  
			    cQuery += " SRA.D_E_L_E_T_ <> '*' AND SRF.D_E_L_E_T_ <> '*' AND SRA.RA_DEMISSA = ' ' AND" 
			    cQuery += " SRA.RA_CC = '"+TMP->RA_CC+"'"
			
			   // MemoWrite("c:\sqlFerias2.txt", cQuery)       
			
			    TCQUERY cQuery NEW ALIAS "TMPSRA"
			
			    dbSelectArea("TMPSRA")
			    
			    While !TMPSRA->(Eof())
			    
			       AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSRA->RA_FILIAL)     
						 AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMPSRA->RA_MAT)
					 	 AAdd((oHtml:ValByName( "IT.NOME" )), TMPSRA->RA_NOME)		 		
					   AAdd((oHtml:ValByName( "IT.CC" )), TMPSRA->RA_CC)        //Centro de custo
						 AAdd((oHtml:ValByName( "IT.FERVENC" )), TMPSRA->RF_DFERVAT)	//Dias ferias vencidas			
					   AAdd((oHtml:ValByName( "IT.FERPROP" )), TMPSRA->RF_DFERAAT) //Dias de ferias proporcional
			    
			      
			       TMPSRA->(DbSkip())
								         	
			    end 
		      if cEmail = ''
		         TMPSRA->(dbclosearea())
		         TMP->(dbclosearea())
		         return nil
		      else        
		        oProcess:cTo  := LOWER(cEmail)  
					  oProcess:Start()
					  oProcess:Finish()
		        conout("WF - WFFERVENC - FIM DO ENVIO DE EMAIL DE VENCIMENTO DE FÉRIAS - "+dToS(DDATABASE))
				    lFlag := .T.
			    endif 
			     TMPSRA->(dbclosearea())      
		   endif
		 endif            
   TMP->(DbSkip())
 	End                                  	
EndIf
TMP->(dbclosearea())  	
Return Nil