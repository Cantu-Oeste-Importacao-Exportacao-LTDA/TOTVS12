#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  28/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. WORKFLOW VENCIMENTO DE CONTRATO DE EXPERIENCIA chamado - 360     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFVENCONT()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName()) 

// chama função para enviar email
MailComp()
Return .T.

/**********************************************************************
Workflow Vencimento de contrato, avisar com antcendencia de uma semana
 *********************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()
Local cData    := DtoS(Date())
Local cDataAtual := Dtos(Date())
Local cVencExp
Local cVencExp2
Local	_cDataTmp  
Local	_cDataTmp2  
Local nDiaVenc
Local nDiaVenc2
Local nMesVenc
Local nMesVenc2
Local nAnoVenc
Local nAnoVenc2
Local oHtml := nil 
Local oProcess
Local cSegme

cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SRA.RA_X_SEGME, SRA.RA_VCTOEXP, SRA.RA_VCTEXP2"
cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND SRA.RA_DEMISSA = ' '"
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlVencCont.txt", cQuery)       
                                                          
TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
   
    //separar por setores
  	                           	
 while !TMP->(Eof())
    oProcess := TWFProcess():New( "WFVENCONT", "VENCIMENTO DE CONTRATO DE EXPERIÊNCIA")  
	  oProcess:NewTask( "WFVENCONT", "\WORKFLOW\wfvencont.htm" )
    oProcess:cSubject := "Funcionários com vencimento de contrato de experiência " + " - Empresa - " + SM0->M0_NOME
    oHTML := oProcess:oHTML 
       		 	     				 	 
	  if cSegme <> TMP->RA_CC
	     ZA1->(DbSelectArea("ZA1"))
	     ZA1->(DbSetOrder(1))
	     ZA1->(DbGotop())
     	if ZA1->(DbSeek(xFilial("ZA1")+TMP->RA_CC))
	       cEmail := AllTrim(ZA1->ZA1_EMAIL) 
	       cSegme := TMP->RA_CC
	       
	       cQuery := '' 
         cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
         cQuery += " SRA.RA_X_SEGME, SRA.RA_VCTOEXP, SRA.RA_VCTEXP2"
				 cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
         cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND SRA.RA_DEMISSA = ' '" 
         cQuery += " AND SRA.RA_CC = '"+TMP->RA_CC+"' 
        
                                                          
         TCQUERY cQuery NEW ALIAS "TMPSRA"	
         dbSelectArea("TMPSRA")    
	 
        While !TMPSRA->(Eof())
          nDia := ''
    			nMes := ''
  			  nAno := ''
    
          cVenExp := TMPSRA->RA_VCTOEXP  
    			cVenExp2 := TMPSRA->RA_VCTEXP2 
      
          nDia := (Val(SubSTR(cData,7,2))+7) //pegar o dia atual  
          nMes := Val(SubSTR(cData,5,2))  //pegar o mês atual
          nAno := Val(SubStr(cData,1,4))  //pegar o ano atual

           //Vencimento da primeira experiencia
          if nMes = 12 .and. nDia > 30 //se o mes for janeiro, diminuir o ano
	           nAno := (Val(SubStr(cData,1,4))+1)     
          endif	    
          if nDia > 30 
             nDia:= (Val(Str(nDia))-30)
             nMes:= (Val(Str(nMes))+1)    
	           cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes)) + '0' + Alltrim(Str(nDia))   
	        endif   
          if nMes > 12
      	     cData := AllTrim(Str(nAno)) + '01' + AllTrim(Str(nDia))        
          else    
	           cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes)) + AllTrim(Str(nDia))  
          endif

          if ((cData > cVenExp) .and. (cDataAtual < cVenExp) .and. (cVenExp <> ' ')); 
             .or. ((cData > cVenExp2) .and.(cDataAtual < cVenExp2) .and. (cVenExp2 <> ' '))  
                
          //tranformando em formato dd/mm/aaaa
       	     _cDataTmp := Substr(TMPSRA->RA_VCTOEXP,7,2) + "/" + ;
             Substr(TMPSRA->RA_VCTOEXP,5,2) + "/" + ;
             Substr(TMPSRA->RA_VCTOEXP,1,4) 
	 				 
           	 _cDataTmp2 := Substr(TMPSRA->RA_VCTEXP2,7,2) + "/" + ;
					   Substr(TMPSRA->RA_VCTEXP2,5,2) + "/" + ;
	 				   Substr(TMPSRA->RA_VCTEXP2,1,4) 	
	 			
	 			 
            //setor RH, esse setor recebe de todos os funcionarios.
        		AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSRA->RA_FILIAL)     
						AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMPSRA->RA_MAT)
		 	  		AAdd((oHtml:ValByName( "IT.NOME" )), TMPSRA->RA_NOME)	
			 			AAdd((oHtml:ValByName( "IT.VENEXP" )), _cDataTmp)				
		    		AAdd((oHtml:ValByName( "IT.VENEXP2" )),	_cDataTmp2) 

        
		     endif	
	        TMPSRA->(DbSkip())	
        end
	   if ((_cDataTmp2 <> '') .or. (_cDataTmp <> ''))	   
	      if cEmail = ''
           return nil
        else
           oProcess:cTo  := LOWER(cEmail) 
     			 oProcess:Start()  
           oProcess:Finish()                                                 
       		 conout("WF - WFQTDHRS - Fim do envio de e-mail para vencimento de contrato de experiência - "+dToS(DDATABASE))
		       lFlag := .T.
        endif
        
     endif
    TMPSRA->(dbclosearea())    
  endif
   
endif	
  TMP->(DbSkip())		  		
End
    
		TMP->(dbclosearea())  
	    	
EndIf	
Return Nil           

//Dioni 02/12/11
//cadastrar os gerentes dos setores com o e-mail(é chamado no menu GEPE)
User Function wfcadGer()                               
Local _cTab	:= "ZA1"
ZA1->(DbSelectArea("ZA1"))  //a lupa para consulta é criada no configurador no campo -> em opçao -> con.padrao
AxCadastro("ZA1", "Cadastrar e-mail dos Gerentes")  //Funçao microsiga que faz a gravaçao automatica

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return Nil   

