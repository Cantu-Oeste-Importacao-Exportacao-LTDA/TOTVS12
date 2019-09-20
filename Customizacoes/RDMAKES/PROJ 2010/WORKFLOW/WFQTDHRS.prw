#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  08/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     WORKFLOW HORAS EXTRAS                                        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFQTDHRS()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp()
Return .T.

/******************************************************************
Workflow horas extras, acima de 20 horas, avisar de 5 em 5 dias
 *****************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()  
Local cData    := DtoS(Date())
Local nDia   	 := Val(SubSTR(cData,7,2))  //colocar dia 21 e fazer um if se for entre >=21 and <=31 pegar do mesmo mes
Local nMes  	 := Val(SubSTR(cData,5,2))  //se for Val(SubSTR(cData,5,2)-1) diminui um mes 
Local nAno     := Val(SubStr(cData,1,4))  //pegar o ano 
Local nDatPont := 21
Local oHtml    := nil 
Local oProcess 
Local cSegme


 if nMes = 01 .and. nDia < 21 //se o mes for janeiro, diminuir o ano
	  nAno := (Val(SubStr(cData,1,4))-1)
 endif	    
 if nDia < 21 
	   cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes-1)) + AllTrim(Str(nDatPont))  ///pegando o dia 21 do mes anterior.
 else    //se for maior que o dia 21 que é o fechamento do ponto
	   cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes)) + AllTrim(Str(nDatPont))   //SubStr(cData,7,2) + SubStr(cData,5,2) + SubStr(cData,3,2)
 endif  

cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SPC.PC_DATA,SP9.P9_CODIGO,SP9.P9_DESC,"
cQuery += " SPC.PC_QUANTC,SRA.RA_X_SEGME," 
cQuery += " (SELECT SUM(SPC.PC_QUANTC) FROM "+RetSqlName("SPC")+" SPC"  
cQuery += " WHERE SPC.PC_FILIAL = '" +xFilial("SPC")+ "' AND SPC.D_E_L_E_T_ <> '*' AND SPC.PC_MAT = SRA.RA_MAT"
cQuery += " AND SPC.PC_FILIAL = SRA.RA_FILIAL AND SP9.P9_CODIGO = SPC.PC_PD"
cQuery += " AND SPC.PC_PD = '106') AS TOTHRS"
cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
cQuery += " LEFT JOIN "+RetSqlName("SPC")+" SPC ON SPC.PC_FILIAL = '" + xFilial("SRA") + "'" 
cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON SP9.P9_CODIGO = SPC.PC_PD"
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SPC.D_E_L_E_T_ <> '*' AND SPC.PC_MAT = SRA.RA_MAT AND"  
cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND" 
cQuery += " SPC.PC_DATA >= '"+cData+"' AND" 
cQuery += " SPC.PC_PD = '106'
cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SPC.PC_DATA,SP9.P9_CODIGO,SP9.P9_DESC,"
cQuery += " SPC.PC_QUANTC,SRA.RA_X_SEGME "
cQuery += " ORDER BY SRA.RA_CC " 

MemoWrite("c:\sqlhoras.sql", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
      	
  While !TMP->(Eof())
    IF TMP->TOTHRS > 20  
  
    		//separar por setores
				oProcess := TWFProcess():New( "WFQTDHRS", "QUANTIDADE SUPERIOR A 20 HORAS EXTRAS")  
				oProcess:NewTask( "WFQTDHRS", "\WORKFLOW\wfhorasextras.htm" )
   			oProcess:cSubject := "Funcionários com quantidade superior a 20 horas extras " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
  			oHTML := oProcess:oHTML 
        
       if cSegme <> TMP->RA_CC
	        ZA1->(DbSelectArea("ZA1"))
	        ZA1->(DbSetOrder(1))
	        ZA1->(DbGotop())    
     	   if ZA1->(DbSeek(xFilial("ZA1")+TMP->RA_CC))
	          cEmail := AllTrim(ZA1->ZA1_EMAIL) 
	          cSegme := TMP->RA_CC
	        
           if nMes = 01 .and. nDia < 21 //se o mes for janeiro, diminuir o ano
          	  nAno := (Val(SubStr(cData,1,4))-1)
           endif	    
           if nDia < 21 
	            cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes-1)) + AllTrim(Str(nDatPont))  ///pegando o dia 21 do mes anterior.
           else    //se for maior que o dia 21 que é o fechamento do ponto
	            cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes)) + AllTrim(Str(nDatPont))   //SubStr(cData,7,2) + SubStr(cData,5,2) + SubStr(cData,3,2)
           endif        
          
            cQuery := ''	
					  cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
					  cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SPC.PC_DATA,SP9.P9_CODIGO,SP9.P9_DESC,"
					  cQuery += " SPC.PC_QUANTC,SRA.RA_X_SEGME," 
					  cQuery += " (SELECT SUM(SPC.PC_QUANTC) FROM "+RetSqlName("SPC")+" SPC"  
					  cQuery += " WHERE SPC.PC_FILIAL = '" +xFilial("SPC")+ "' AND SPC.D_E_L_E_T_ <> '*' AND SPC.PC_MAT = SRA.RA_MAT"
					  cQuery += " AND SPC.PC_FILIAL = SRA.RA_FILIAL AND SP9.P9_CODIGO = SPC.PC_PD"
					  cQuery += " AND SPC.PC_PD = '106' AND SRA.RA_CC = '"+TMP->RA_CC+"') AS TOTHRS"
					  cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
					  cQuery += " LEFT JOIN "+RetSqlName("SPC")+" SPC ON SPC.PC_FILIAL = '" + xFilial("SRA") + "'" 
					  cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON SP9.P9_CODIGO = SPC.PC_PD"
					  cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SPC.D_E_L_E_T_ <> '*' AND SPC.PC_MAT = SRA.RA_MAT AND"  
					  cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND" 
   				  cQuery += " SPC.PC_DATA >= '"+cData+"' AND"   
					  cQuery += " SPC.PC_PD = '106' 
					  cQuery += " AND SRA.RA_CC = '"+TMP->RA_CC+"' 
					  cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
					  cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SPC.PC_DATA,SP9.P9_CODIGO,SP9.P9_DESC,"
					  cQuery += " SPC.PC_QUANTC,SRA.RA_X_SEGME "

           // MemoWrite("c:\sqlhoras2.sql", cQuery)    
          
            TCQUERY cQuery NEW ALIAS "TMPSRA"	
            dbSelectArea("TMPSRA")
            
            While !TMPSRA->(Eof())
              //separando os setores, pq o envio de email tm que ser para o gerente de cada setor
              AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSRA->RA_FILIAL)     
              AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMPSRA->RA_MAT)
		 	        AAdd((oHtml:ValByName( "IT.NOME" )), TMPSRA->RA_NOME)		 		
			 	      AAdd((oHtml:ValByName( "IT.EVENTO" )), TMPSRA->P9_CODIGO)				
		          AAdd((oHtml:ValByName( "IT.DESC" )), TMPSRA->P9_DESC)
		          AAdd((oHtml:ValByName( "IT.CC" )), TMPSRA->RA_CC)        //Centro de custo
		          AAdd((oHtml:ValByName( "IT.QTDHRS" )), TMPSRA->TOTHRS) //Quantidade de horas extras
              
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
              conout("WF - WFQTDHRS - FIM DO ENVIO DE EMAIL DE HORAS EXTRAS - "+dToS(DDATABASE))
		          lFlag := .T.  
            endif
       
           TMPSRA->(dbclosearea())    
         endif
       endif
   
    endif	
  TMP->(DbSkip())		  		
  End
    	    	
EndIf
  TMP->(dbclosearea())  	
Return Nil 
    
