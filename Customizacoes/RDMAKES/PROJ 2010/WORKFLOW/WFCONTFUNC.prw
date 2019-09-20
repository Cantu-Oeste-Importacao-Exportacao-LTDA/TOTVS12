#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  23/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     WORKFLOW HORAS EXTRAS - MODELO 2 -> ENVIADO APENAS PARA      º±±
TATIANA DP E RH -> CHAMADO 442     ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFQUANHRS()  

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
cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND SRA.RA_DEMISSA = ' ' AND " 
cQuery += " SPC.PC_DATA >= '"+cData+"' AND" 
cQuery += " SPC.PC_PD = '106'
cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SPC.PC_DATA,SP9.P9_CODIGO,SP9.P9_DESC,"
cQuery += " SPC.PC_QUANTC,SRA.RA_X_SEGME "
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlhoras.sql", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
   oProcess := TWFProcess():New( "WFQTDHRS", "QUANTIDADE SUPERIOR A 20 HORAS EXTRAS")  
	 oProcess:NewTask( "WFQTDHRS", "\WORKFLOW\wfhorasextras.htm" )
   oProcess:cSubject := "Funcionários com quantidade superior a 20 horas extras " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
   oHTML := oProcess:oHTML 
      	
  While !TMP->(Eof())
    IF TMP->TOTHRS > 20  
               
        AAdd((oHtml:ValByName( "IT.FILIAL" )), TMP->RA_FILIAL)     
        AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMP->RA_MAT)
		 	  AAdd((oHtml:ValByName( "IT.NOME" )), TMP->RA_NOME)		 		
			 	AAdd((oHtml:ValByName( "IT.EVENTO" )), TMP->P9_CODIGO)				
		    AAdd((oHtml:ValByName( "IT.DESC" )), TMP->P9_DESC)
		    AAdd((oHtml:ValByName( "IT.CC" )), TMP->RA_CC)        //Centro de custo
		    AAdd((oHtml:ValByName( "IT.QTDHRS" )), TMP->TOTHRS) //Quantidade de horas extras
                            
        
    endif	
    TMP->(DbSkip())		  		
  End
  TMP->(dbclosearea())    
   
  cEmail := 'tatiana@grupocantu.com.br, rh@grupocantu.com.br'
  Process:cTo  := LOWER(cEmail) 
  oProcess:Start()  
  oProcess:Finish()                                                 
  conout("WF - WFQTDHRS - FIM DO ENVIO DE EMAIL DE HORAS EXTRAS - "+dToS(DDATABASE))
	lFlag := .T.     
        	    	
EndIf
  TMP->(dbclosearea())  	
Return Nil   
 
 
     
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  23/12/11   º±±
MODELO - 02 -> ENVIADO APENAS PARA TATI DO DP, E PARA O RH -> CHAMADO 442 ¹±±
±±ºDesc.     WORKFLOW INCONSISTENCIA DE MARCAÇAO - TOLERAVEL ATE 15 MIN   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFINCOMARC() //inconsistencia de marcaçao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp2()
Return .T.

/*******************************************************************************
Workflow inconsistencia de marcaçao, Toleravel ate 15 min, avisar de 5 em 5 dias
 *******************************************************************************/
Static Function MailComp2()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()  
Local cData    := DtoS(Date()-2)
Local oHtml    := nil 
Local oProcess
Local oProcess1
Local nHoraEnt1 
Local nHoraSai1
Local nHoraEnt2
Local nHoraSai2 
Local nHoraEnt1M 
Local nHoraSai1M
Local nHoraEnt2M
Local nHoraSai2M
Local cSegme  

cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_" 
cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
cQuery += " LEFT JOIN "+RetSqlName("SPC")+" SPC ON SPC.PC_FILIAL = '" + xFilial("SRA") + "'"
cQuery += " LEFT JOIN "+RetSqlName("SP8")+" SP8 ON SP8.P8_MAT = SRA.RA_MAT" 
cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON SP9.P9_CODIGO = SPC.PC_PD"
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SP8.D_E_L_E_T_ <> '*' AND"  
cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND SRA.RA_DEMISSA = ' ' AND" 
cQuery += " SP8.P8_DATA >= '"+cData+"' AND"  
cQuery += " (SPC.PC_PD = '106' OR SPC.PC_PD = '437')"
cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_"
cQuery += " ORDER BY SP8.R_E_C_N_O_ " 

//MemoWrite("c:\sqlIncMarc.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())  
		oProcess := TWFProcess():New( "WFINCMAR", "Inconsistência de Marcação no Ponto Eletrônico")  
		oProcess:NewTask( "WFINCMAR", "\WORKFLOW\wfinconsmarc.htm" )
	 	oProcess:cSubject := "Funcionários com insconsistência de Marcação " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
	 	oHTML := oProcess:oHTML 	
    
  While !TMP->(Eof())    
	  		
		 //VERIFICA qual tipo de entrada ou saída
		  ENT1 := TMP->R_E_C_N_O_ 
		  SAI1 := TMP->R_E_C_N_O_ + 1
		  ENT2 := TMP->R_E_C_N_O_ + 2 
		  SAI2 := TMP->R_E_C_N_O_ + 3
		  DATMARC := TMP->P8_DATA
			    	       
	    While (TMP->P8_DATA =	DATMARC)           
		     IF TMP->RA_X_DTURN <> 'SEM CONTROLE DE HORARIO' 				
				       
						     if (Val(SubStr(TMP->RA_X_DTURN,4,2)) > 44)
						        nHoraEnt1:= (Val(SubStr(TMP->RA_X_DTURN,4,2))+15)
						        if nHoraEnt1 > 59                                  //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraEnt1 := (nHoraEnt1 - 60)                          
						        endif  
						        nHoraEnt1:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,1,2))+1)+'.'+cValToChar(nHoraEnt1)    
						     else 
						        nHoraEnt1:= (Val(SubStr(TMP->RA_X_DTURN,4,2))+15)
						        nHoraEnt1:= (SubStr(TMP->RA_X_DTURN,1,2))+'.'+cValToChar(nHoraEnt1)   //entrada do primeiro turno   com tolerancia de +15 min  
						     endif   
						     ////////////
						     if (Val(SubStr(TMP->RA_X_DTURN,10,2)) > 44)    //se min for minutos for maior q "44"   
						        nHoraSai1:= (Val(SubStr(TMP->RA_X_DTURN,10,2))+15) 
						        if nHoraSai1 > 59                                          //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraSai1 := (nHoraSai1 - 60)                          
						        endif 
						        nHoraSai1:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,7,2))+1)+'.'+cValToChar(nHoraSai1)  
						     else 
						        nHoraSai1:= (Val(SubStr(TMP->RA_X_DTURN,10,2))+15)           //saida do primeiro turno        com tolerancia de +15 min 
						        nHoraSai1:= (SubStr(TMP->RA_X_DTURN,7,2))+'.'+cValToChar(nHoraSai1)  
						     endif   
						     /////
						     if (Val(SubStr(TMP->RA_X_DTURN,18,2)) > 44)    //se min for minutos for maior q "44"
						        nHoraEnt2:= (Val(SubStr(TMP->RA_X_DTURN,18,2))+15)
						        if nHoraEnt2 > 59                                          //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraEnt2 := (nHoraEnt2 - 60)                          
						        endif   
						        nHoraEnt2:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,15,2))+1)+'.'+cValToChar(nHoraEnt2)  
						     else
						        nHoraEnt2:= (Val(SubStr(TMP->RA_X_DTURN,18,2))+15)    //entrada do segundo turno      com tolerancia de +15 min 
						        nHoraEnt2:= (SubStr(TMP->RA_X_DTURN,15,2))+'.'+cValToChar(nHoraEnt2)
						     endif
						     ////////////// 
						     if (Val(SubStr(TMP->RA_X_DTURN,24,2)) > 44)
						        nHoraSai2:= (Val(SubStr(TMP->RA_X_DTURN,24,2))+15)
						        if nHoraSai2 > 59                                          //se min for maior q "60" diminuir a partir de "60Minutos"
						           nHoraSai2 := (nHoraSai2 - 60)                          
						        endif 
						        nHoraSai2:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,21,2))+1)+'.'+cValToChar(nHoraSai2)   
						     else  
						        nHoraSai2:= (Val(SubStr(TMP->RA_X_DTURN,24,2))+15)   //saida do segundo turno       com tolerancia de +15 min   
						        nHoraSai2:= (SubStr(TMP->RA_X_DTURN,21,2))+'.'+cValToChar(nHoraSai2)                                                                                                                                                  
						     endif                 
						     
						     ///////////////////                  
						     if (Val(SubStr(TMP->RA_X_DTURN,4,2)) < 15)                           //se min for "menor" q 15, entao tm q diminuir a hora tbm  
						        nHoraEnt1M:= (Val(SubStr(TMP->RA_X_DTURN,4,2))-15)
						        if nHoraEnt1M < 0                                                  //se min for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraEnt1M := (60 - (-nHoraEnt1M))                              // 60Minutos - variavel negativa 
						        endif
						        nHoraEnt1M:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,1,2))-1)+'.'+cValToChar(nHoraEnt1M)    
						     else
						        nHoraEnt1M:= (Val(SubStr(TMP->RA_X_DTURN,4,2))-15)  //entrada do primeiro turno   com tolerancia de -15 min   
						        nHoraEnt1M:= (SubStr(TMP->RA_X_DTURN,1,2))+'.'+cValToChar(nHoraEnt1M)  
						     endif
						     
						     if (Val(SubStr(TMP->RA_X_DTURN,10,2)) < 15)//se min for "menor" q 15, entao tm q diminuir a hora tbm 
						        nHoraSai1M:= (Val(SubStr(TMP->RA_X_DTURN,10,2))-15)
						        if nHoraSai1M < 0      //se minutos for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraSai1M := (60 - (-nHoraSai1M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraSai1M:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,7,2))-1)+'.'+cValToChar(nHoraSai1M)
						     else   
						        nHoraSai1M:= (Val(SubStr(TMP->RA_X_DTURN,10,2))-15)    //saida do primeiro turno        com tolerancia de -15 min  
						        nHoraSai1M:= (SubStr(TMP->RA_X_DTURN,7,2))+'.'+cValToChar(nHoraSai1M)
						     endif 
						      ///////////
						     if (Val(SubStr(TMP->RA_X_DTURN,18,2)) < 15)//se min for "menor" q 15, entao tm q diminuir a hora tbm
						        nHoraEnt2M:= (Val(SubStr(TMP->RA_X_DTURN,18,2))-15)
						        if nHoraEnt2M < 0      //se minutos for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraEnt2M := (60 - (-nHoraEnt2M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraEnt2M:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,15,2))-1)+'.'+cValToChar(nHoraEnt2M)
						     else  
						        nHoraEnt2M:= (Val(SubStr(TMP->RA_X_DTURN,18,2))-15)   //entrada do segundo turno      com tolerancia de -15 min 
						        nHoraEnt2M:= (SubStr(TMP->RA_X_DTURN,15,2))+'.'+cValToChar(nHoraEnt2M)
						     endif   
						    /////////////////////////////    
						     if (Val(SubStr(TMP->RA_X_DTURN,24,2)) < 15) //se min for "menor" q 15, entao tm q diminuir a hora tbm
						        nHoraSai2M:= (Val(SubStr(TMP->RA_X_DTURN,24,2))-15)  //saida do segundo turno       com tolerancia de -15 min   
						        if nHoraSai2M < 0      //se min for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraSai2M := (60 - (-nHoraSai2M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraSai2M:= cValToChar(Val(SubStr(TMP->RA_X_DTURN,21,2))-1)+'.'+cValToChar(nHoraSai2M) //diminui uma hora
						     else
					        nHoraSai2M:= (Val(SubStr(TMP->RA_X_DTURN,24,2))-15)  //saida do segundo turno       com tolerancia de -15 min   
					        nHoraSai2M:= (SubStr(TMP->RA_X_DTURN,21,2))+'.'+cValToChar(nHoraSai2M)                                                                                                                                             
					       endif    
					        
					          
					  
					       IF ((TMP->R_E_C_N_O_ = ENT1) .AND. ((TMP->P8_HORA < (Val(nHoraEnt1M))) .OR. (TMP->P8_HORA > (Val(nHoraEnt1)))));
					          .OR.((TMP->R_E_C_N_O_ = ENT2) .AND. ((TMP->P8_HORA < (Val(nHoraEnt2M))) .OR. (TMP->P8_HORA > (Val(nHoraEnt2)))));
					          .OR.((TMP->R_E_C_N_O_ = SAI1) .AND. ((TMP->P8_HORA < (Val(nHoraSai1M))) .OR. (TMP->P8_HORA > (Val(nHoraSai1))))); 
					          .OR.((TMP->R_E_C_N_O_ = SAI2) .AND. ((TMP->P8_HORA < (Val(nHoraSai2M))) .OR. (TMP->P8_HORA > (Val(nHoraSai2)))));
					
		                //separando os setores, pq o envio de email tm que ser para o gerente de cada setor
					    					    
							         AAdd((oHtml:ValByName( "IT.FILIAL" )), TMP->RA_FILIAL)     
											 AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMP->RA_MAT)
									 	   AAdd((oHtml:ValByName( "IT.NOME" )), TMP->RA_NOME)		 		
										 	 AAdd((oHtml:ValByName( "IT.EVENTO" )), TMP->P9_CODIGO)				
									     AAdd((oHtml:ValByName( "IT.DESC" )), TMP->P9_DESC)
									     AAdd((oHtml:ValByName( "IT.CC" )), TMP->RA_CC)        //Centro de custo
									     AAdd((oHtml:ValByName( "IT.HORARIO" )), TMP->RA_X_DTURN) //Horario que o func. deve cumprir
							         AAdd((oHtml:ValByName( "IT.IT.HORA" )), TMP->P8_HORA) //hora q o func bateu o ponto 
							         AAdd((oHtml:ValByName( "IT.DATAMARC" )), StoD(TMP->P8_DATA)) //Data da marcação 
							  
							   endif      
							       
		     endif
		    TMP->(DbSkip())					         	
	    end   		
    TMP->(DbSkip())	
	End
	TMP->(dbclosearea()) 
	cEmail := 'dioni@grupocantu.com.br' //'tatiana@grupocantu.com.br, rh@grupocantu.com.br'
	oProcess:cTo  := LOWER(cEmail) 
	oProcess:Start()  
  oProcess:Finish()                                                 
 	conout("WF - WFINCMAR - Fim do Envio de e-mail de Inconsistência de Marcação no Ponto Eletrônico - "+dToS(DDATABASE))
  lFlag := .T.
           	
EndIf
//TMP->(dbclosearea())   	
Return Nil
   

                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  23/12/11   º±±
±± MODELO 02 -> ENVIADO PARA TATI DP E RH -> chamado 00442  ÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. WORKFLOW VENCIMENTO DE CONTRATO DE EXPERIENCIA chamado - 360     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFVENCCONTR()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp3()
Return .T.

/**********************************************************************
Workflow Vencimento de contrato, avisar com antcendencia de uma semana
 *********************************************************************/
Static Function MailComp3()
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
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND SRA.RA_DEMISSA = ' ' "
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlVencContr.txt", cQuery)       
                                                          
TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
    oProcess := TWFProcess():New( "WFVENCONT", "VENCIMENTO DE CONTRATO DE EXPERIÊNCIA")  
	  oProcess:NewTask( "WFVENCONT", "\WORKFLOW\wfvencont.htm" )
    oProcess:cSubject := "Funcionários com vencimento de contrato de experiência " + " - Empresa - " + SM0->M0_NOME
    oHTML := oProcess:oHTML 
  	                           	
 while !TMP->(Eof())       		 	     				 	 
	  
	        nDia := ''
    			nMes := ''
  			  nAno := ''
    
          cVenExp :=  TMP->RA_VCTOEXP  
    			cVenExp2 := TMP->RA_VCTEXP2 
      
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
       	     _cDataTmp := Substr(TMP->RA_VCTOEXP,7,2) + "/" + ;
             Substr(TMP->RA_VCTOEXP,5,2) + "/" + ;
             Substr(TMP->RA_VCTOEXP,1,4) 
	 				 
           	 _cDataTmp2 := Substr(TMP->RA_VCTEXP2,7,2) + "/" + ;
					   Substr(TMP->RA_VCTEXP2,5,2) + "/" + ;
	 				   Substr(TMP->RA_VCTEXP2,1,4) 	
	 			
	 			 
            //setor RH, esse setor recebe de todos os funcionarios.
        		AAdd((oHtml:ValByName( "IT.FILIAL" )), TMP->RA_FILIAL)     
						AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMP->RA_MAT)
		 	  		AAdd((oHtml:ValByName( "IT.NOME" )), TMP->RA_NOME)	
			 			AAdd((oHtml:ValByName( "IT.VENEXP" )), _cDataTmp)				
		    		AAdd((oHtml:ValByName( "IT.VENEXP2" )),	_cDataTmp2) 

        
		      endif
   	
  TMP->(DbSkip())		  		
End
 
	TMP->(dbclosearea())  

	   if ((_cDataTmp2 <> '') .or. (_cDataTmp <> ''))
	       cEmail := 'tatiana@grupocantu.com.br, rh@grupocantu.com.br'
         oProcess:cTo  := LOWER(cEmail) 
   		   oProcess:Start()  
         oProcess:Finish()                                                 
     		 conout("WF - WFVENCCONTR - Fim do envio de e-mail para vencimento de contrato de experiência - "+dToS(DDATABASE))
         lFlag := .T.                 
     endif	    	
EndIf	
Return Nil           


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  26/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍ MODELO 02 ÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± FÉRIAS VENCIDAS 2, enviará apenas para Tati DP e p/ RH   - CHAMADO 442 º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFFERIVENCI()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp4()
Return .T.

/******************************************************************
Workflow Férias Vencidas, avisar de 3 em 3 dias -> chamado 442
*****************************************************************/
Static Function MailComp4()
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

//MemoWrite("c:\sqlFeriasVenci.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
	  oProcess := TWFProcess():New( "WFFERVENC", "VENCIMENTO DE FÉRIAS")  
		oProcess:NewTask( "WFFERVENC", "\WORKFLOW\wfferiasvenc.htm" )
   	oProcess:cSubject := "Funcionários com  férias vencidas " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
  	oHTML := oProcess:oHTML 
   	
  While !TMP->(Eof())
		    
      AAdd((oHtml:ValByName( "IT.FILIAL" )), TMP->RA_FILIAL)     
      AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMP->RA_MAT)
			AAdd((oHtml:ValByName( "IT.NOME" )), TMP->RA_NOME)		 		
		  AAdd((oHtml:ValByName( "IT.CC" )), TMP->RA_CC)        //Centro de custo
		  AAdd((oHtml:ValByName( "IT.FERVENC" )), TMP->RF_DFERVAT)	//Dias ferias vencidas			
		  AAdd((oHtml:ValByName( "IT.FERPROP" )), TMP->RF_DFERAAT) //Dias de ferias proporcional	      
 			       								         	
     TMP->(DbSkip())
 	End
  TMP->(dbclosearea())
	
	cEmail := 'tatiana@grupocantu.com.br, rh@grupocantu.com.br'	             
  oProcess:cTo  := LOWER(cEmail)  
  oProcess:Start()
  oProcess:Finish()
  conout("WF - WFFERVENC - FIM DO ENVIO DE EMAIL DE VENCIMENTO DE FÉRIAS - "+dToS(DDATABASE))
  lFlag := .T.
                                  	
EndIf
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  26/12/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍ MODELO 02 ÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±± WORKFLOW PROGRAMAÇÃO DE FÉRIAS 2´- ENVIAR APENAS P/ TATI DP e RH       º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFPROFERI()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp5()
Return .T.

/*********************************************************************
Workflow Programação de Férias, avisar 1 vez por mês -> chamado 442
 ********************************************************************/
Static Function MailComp5()
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
cQuery += " WHERE SRF.RF_DFERVAT = '30' AND"  
cQuery += " SRA.D_E_L_E_T_ <> '*' AND SRF.D_E_L_E_T_ <> '*' AND SRA.RA_DEMISSA = ' '" 
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlPrFerias.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   	  	
    oProcess := TWFProcess():New( "WFFERVENC", "PROGRAMAÇÃO DE FÉRIAS")  
		oProcess:NewTask( "WFFERVENC", "\WORKFLOW\wfprogferias.htm" )
   	oProcess:cSubject := "Funcionários com  férias a vencer " + " - Empresa - " + SM0->M0_NOME
  	oHTML := oProcess:oHTML  	
 
  While !TMP->(Eof())
        AAdd((oHtml:ValByName( "IT.FILIAL" )), TMP->RA_FILIAL)     
	  		AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMP->RA_MAT)
		 	  AAdd((oHtml:ValByName( "IT.NOME" )), TMP->RA_NOME)		 		
		    AAdd((oHtml:ValByName( "IT.CC" )), TMP->RA_CC)        //Centro de custo
			 	AAdd((oHtml:ValByName( "IT.FERVENC" )), TMP->RF_DFERVAT)	//Dias ferias vencidas			
		    AAdd((oHtml:ValByName( "IT.FERPROP" )), TMP->RF_DFERAAT) //Dias de ferias proporcional      
			    
	    TMP->(DbSkip())
  End 
  cEmail := 'tatiana@grupocantu.com.br, rh@grupocantu.com.br'
  oProcess:cTo  := LOWER(cEmail)  
  oProcess:Start()
  oProcess:Finish()
  conout("WF - WFFERVENC - FIM DO ENVIO DE EMAIL DE PROGRAMAÇÃO DE FÉRIAS - "+dToS(DDATABASE))
  lFlag := .T.  
		                                 	
EndIf	
Return Nil