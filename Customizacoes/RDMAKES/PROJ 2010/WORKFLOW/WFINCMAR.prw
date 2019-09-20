#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³          ºAutor  ³Dioni               º Data ³  17/11/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     WORKFLOW INCONSISTENCIA DE MARCAÇAO - TOLERAVEL ATE 15 MIN   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±                               
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function WFINCMAR() //inconsistencia de marcaçao  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// chama função para enviar email
MailComp()
Return .T.

/*******************************************************************************
Workflow inconsistencia de marcaçao, Toleravel ate 15 min, avisar de 5 em 5 dias
 *******************************************************************************/
Static Function MailComp()
Local cQuery   := ""
Local cEmail   := ""                 
Local lFlag    := .F.                     
Local nDesc    := 0
Local aArea    := GetArea()  
Local cData    := DtoS(Date()-2)
//Local nDia   	 := Val(SubSTR(cData,7,2))  //colocar dia 21 e fazer um if se for entre >=21 and <=31 pegar do mesmo mes
//Local nMes  	 := Val(SubSTR(cData,5,2))  //se for Val(SubSTR(cData,5,2)-1) diminui um mes 
//Local nAno     := Val(SubStr(cData,1,4))  //pegar o ano 
//Local nDatPont := 21
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
Local RegOk := nil

/* if nMes = 01 .and. nDia < 21 //se o mes for janeiro, diminuir o ano
	  nAno := (Val(SubStr(cData,1,4))-1)
 endif	    
 if nDia < 21 
	   cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes-1)) + AllTrim(Str(nDatPont))  ///pegando o dia 21 do mes anterior.
 else    //se for maior que o dia 21 que é o fechamento do ponto
	   cData := AllTrim(Str(nAno)) + AllTrim(Str(nMes)) + AllTrim(Str(nDatPont))   //SubStr(cData,7,2) + SubStr(cData,5,2) + SubStr(cData,3,2)
 endif  
*/
cQuery := " SELECT SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_" 
cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
cQuery += " LEFT JOIN "+RetSqlName("SPC")+" SPC ON SPC.PC_FILIAL = '" + xFilial("SRA") + "'"
cQuery += " LEFT JOIN "+RetSqlName("SP8")+" SP8 ON SP8.P8_MAT = SRA.RA_MAT" 
cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON SP9.P9_CODIGO = SPC.PC_PD"
cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SP8.D_E_L_E_T_ <> '*' AND "  
cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND" 
cQuery += " SP8.P8_DATA >= '"+cData+"' AND"  
cQuery += " (SPC.PC_PD = '106' OR SPC.PC_PD = '437')
cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_" 
cQuery += " ORDER BY SRA.RA_CC " 

//MemoWrite("c:\sqlIncMarc.txt", cQuery)       

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")

If !TMP->(EOF())   
    	
  While !TMP->(Eof())   
     RegOk := nil
		 IF TMP->RA_X_DTURN <> 'SEM CONTROLE DE HORARIO' 
		   
		    //separar por setores
				oProcess := TWFProcess():New( "WFINCMAR", "Inconsistência de Marcação no Ponto Eletrônico")  
				oProcess:NewTask( "WFINCMAR", "\WORKFLOW\wfinconsmarc.htm" )
		   	oProcess:cSubject := "Funcionários com insconsistência de Marcação " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
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
						cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
						cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_" 
						cQuery += " FROM "+RetSqlName("SRA")+" SRA" 
						cQuery += " LEFT JOIN "+RetSqlName("SPC")+" SPC ON SPC.PC_FILIAL = '" + xFilial("SRA") + "'"
						cQuery += " LEFT JOIN "+RetSqlName("SP8")+" SP8 ON SP8.P8_MAT = SRA.RA_MAT" 
						cQuery += " LEFT JOIN "+RetSqlName("SP9")+" SP9 ON SP9.P9_CODIGO = SPC.PC_PD"
						cQuery += " WHERE SRA.D_E_L_E_T_ <> '*' AND SP8.D_E_L_E_T_ <> '*' AND "  
						cQuery += " SP9.D_E_L_E_T_ <> '*' AND SRA.RA_FILIAL = '" +xFilial("SRA")+ "' AND" 
					 	cQuery += " SP8.P8_DATA >= '"+cData+"' AND"   
					 	cQuery += " SRA.RA_CC = '"+TMP->RA_CC+"' AND"
						cQuery += " (SPC.PC_PD = '106' OR SPC.PC_PD = '437')"
						cQuery += " GROUP BY SRA.RA_FILIAL,SRA.RA_NOME,SRA.RA_CC,SRA.RA_EMAIL,SRA.RA_MAT,"
						cQuery += " SPC.PC_FILIAL,SPC.PC_PD,SP8.P8_DATA,SP9.P9_CODIGO,SP9.P9_DESC,SP8.P8_HORA,"
						cQuery += " SP8.P8_FLAG, SP8.P8_TPMARCA, SRA.RA_X_SEGME,SRA.RA_X_DTURN, SP8.R_E_C_N_O_" 
						cQuery += " ORDER BY SP8.R_E_C_N_O_"
						 
				 	 //MemoWrite("c:\sqlIncMarc2.txt", cQuery)       
						
						TCQUERY cQuery NEW ALIAS "TMPSRA"
						
						dbSelectArea("TMPSRA")        
						
			 While !TMPSRA->(Eof())			
				 //VERIFICA qual tipo de entrada ou saída
			    ENT1 := TMPSRA->R_E_C_N_O_ 
			    SAI1 := TMPSRA->R_E_C_N_O_ + 1
			    ENT2 := TMPSRA->R_E_C_N_O_ + 2 
			    SAI2 := TMPSRA->R_E_C_N_O_ + 3
			    DATMARC := TMPSRA->P8_DATA
			    	       
	         While (TMPSRA->P8_DATA =	DATMARC)       
						  IF TMPSRA->RA_X_DTURN <> 'SEM CONTROLE DE HORARIO'
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,4,2)) > 44)
						        nHoraEnt1:= (Val(SubStr(TMPSRA->RA_X_DTURN,4,2))+15)
						        if nHoraEnt1 > 59                                  //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraEnt1 := (nHoraEnt1 - 60)                          
						        endif  
						        nHoraEnt1:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,1,2))+1)+'.'+cValToChar(nHoraEnt1)    
						     else 
						        nHoraEnt1:= (Val(SubStr(TMPSRA->RA_X_DTURN,4,2))+15)
						        nHoraEnt1:= (SubStr(TMPSRA->RA_X_DTURN,1,2))+'.'+cValToChar(nHoraEnt1)   //entrada do primeiro turno   com tolerancia de +15 min  
						     endif   
						     ////////////
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,10,2)) > 44)    //se min for minutos for maior q "44"   
						        nHoraSai1:= (Val(SubStr(TMPSRA->RA_X_DTURN,10,2))+15) 
						        if nHoraSai1 > 59                                          //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraSai1 := (nHoraSai1 - 60)                          
						        endif 
						        nHoraSai1:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,7,2))+1)+'.'+cValToChar(nHoraSai1)  
						     else 
						        nHoraSai1:= (Val(SubStr(TMPSRA->RA_X_DTURN,10,2))+15)           //saida do primeiro turno        com tolerancia de +15 min 
						        nHoraSai1:= (SubStr(TMPSRA->RA_X_DTURN,7,2))+'.'+cValToChar(nHoraSai1)  
						     endif   
						     /////
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,18,2)) > 44)    //se min for minutos for maior q "44"
						        nHoraEnt2:= (Val(SubStr(TMPSRA->RA_X_DTURN,18,2))+15)
						        if nHoraEnt2 > 59                                          //se min for maior q "59" diminuir a partir de "60Minutos"
						           nHoraEnt2 := (nHoraEnt2 - 60)                          
						        endif   
						        nHoraEnt2:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,15,2))+1)+'.'+cValToChar(nHoraEnt2)  
						     else
						        nHoraEnt2:= (Val(SubStr(TMPSRA->RA_X_DTURN,18,2))+15)    //entrada do segundo turno      com tolerancia de +15 min 
						        nHoraEnt2:= (SubStr(TMPSRA->RA_X_DTURN,15,2))+'.'+cValToChar(nHoraEnt2)
						     endif
						     ////////////// 
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,24,2)) > 44)
						        nHoraSai2:= (Val(SubStr(TMPSRA->RA_X_DTURN,24,2))+15)
						        if nHoraSai2 > 59                                          //se min for maior q "60" diminuir a partir de "60Minutos"
						           nHoraSai2 := (nHoraSai2 - 60)                          
						        endif 
						        nHoraSai2:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,21,2))+1)+'.'+cValToChar(nHoraSai2)   
						     else  
						        nHoraSai2:= (Val(SubStr(TMPSRA->RA_X_DTURN,24,2))+15)   //saida do segundo turno       com tolerancia de +15 min   
						        nHoraSai2:= (SubStr(TMPSRA->RA_X_DTURN,21,2))+'.'+cValToChar(nHoraSai2)                                                                                                                                                  
						     endif                 
						     
						     ///////////////////                  
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,4,2)) < 15)                           //se min for "menor" q 15, entao tm q diminuir a hora tbm  
						        nHoraEnt1M:= (Val(SubStr(TMPSRA->RA_X_DTURN,4,2))-15)
						        if nHoraEnt1M < 0                                                  //se min for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraEnt1M := (60 - (-nHoraEnt1M))                              // 60Minutos - variavel negativa 
						        endif
						        nHoraEnt1M:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,1,2))-1)+'.'+cValToChar(nHoraEnt1M)    
						     else
						        nHoraEnt1M:= (Val(SubStr(TMPSRA->RA_X_DTURN,4,2))-15)  //entrada do primeiro turno   com tolerancia de -15 min   
						        nHoraEnt1M:= (SubStr(TMPSRA->RA_X_DTURN,1,2))+'.'+cValToChar(nHoraEnt1M)  
						     endif
						     
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,10,2)) < 15)//se min for "menor" q 15, entao tm q diminuir a hora tbm 
						        nHoraSai1M:= (Val(SubStr(TMPSRA->RA_X_DTURN,10,2))-15)
						        if nHoraSai1M < 0      //se minutos for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraSai1M := (60 - (-nHoraSai1M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraSai1M:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,7,2))-1)+'.'+cValToChar(nHoraSai1M)
						     else   
						        nHoraSai1M:= (Val(SubStr(TMPSRA->RA_X_DTURN,10,2))-15)    //saida do primeiro turno        com tolerancia de -15 min  
						        nHoraSai1M:= (SubStr(TMPSRA->RA_X_DTURN,7,2))+'.'+cValToChar(nHoraSai1M)
						     endif 
						      ///////////
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,18,2)) < 15)//se min for "menor" q 15, entao tm q diminuir a hora tbm
						        nHoraEnt2M:= (Val(SubStr(TMPSRA->RA_X_DTURN,18,2))-15)
						        if nHoraEnt2M < 0      //se minutos for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraEnt2M := (60 - (-nHoraEnt2M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraEnt2M:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,15,2))-1)+'.'+cValToChar(nHoraEnt2M)
						     else  
						        nHoraEnt2M:= (Val(SubStr(TMPSRA->RA_X_DTURN,18,2))-15)   //entrada do segundo turno      com tolerancia de -15 min 
						        nHoraEnt2M:= (SubStr(TMPSRA->RA_X_DTURN,15,2))+'.'+cValToChar(nHoraEnt2M)
						     endif   
						    /////////////////////////////    
						     if (Val(SubStr(TMPSRA->RA_X_DTURN,24,2)) < 15) //se min for "menor" q 15, entao tm q diminuir a hora tbm
						        nHoraSai2M:= (Val(SubStr(TMPSRA->RA_X_DTURN,24,2))-15)  //saida do segundo turno       com tolerancia de -15 min   
						        if nHoraSai2M < 0      //se min for menor q "zero" diminuir a partir de "60Minutos"
						           nHoraSai2M := (60 - (-nHoraSai2M))  // 60Minutos - variavel negativa   
						        endif
						        nHoraSai2M:= cValToChar(Val(SubStr(TMPSRA->RA_X_DTURN,21,2))-1)+'.'+cValToChar(nHoraSai2M) //diminui uma hora
						     else
					        nHoraSai2M:= (Val(SubStr(TMPSRA->RA_X_DTURN,24,2))-15)  //saida do segundo turno       com tolerancia de -15 min   
					        nHoraSai2M:= (SubStr(TMPSRA->RA_X_DTURN,21,2))+'.'+cValToChar(nHoraSai2M)                                                                                                                                             
					       endif    
					          
					     //Substituido porque "P8_TPMarca" não tem todos os registros gravados
		         	/*  IF ((TMPSRA->P8_TPMARCA = '1E') .AND. ((TMPSRA->P8_HORA < (Val(nHoraEnt1M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraEnt1)))));
					          .OR.((TMPSRA->P8_TPMARCA = '2E') .AND. ((TMPSRA->P8_HORA < (Val(nHoraEnt2M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraEnt2)))));
					          .OR.((TMPSRA->P8_TPMARCA = '1S') .AND. ((TMPSRA->P8_HORA < (Val(nHoraSai1M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraSai1))))); 
					          .OR.((TMPSRA->P8_TPMARCA = '2S') .AND. ((TMPSRA->P8_HORA < (Val(nHoraSai2M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraSai2)))));  
		                 
			        */	

			           IF ((TMPSRA->R_E_C_N_O_ = ENT1) .AND. ((TMPSRA->P8_HORA < (Val(nHoraEnt1M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraEnt1)))));
					          .OR.((TMPSRA->R_E_C_N_O_ = ENT2) .AND. ((TMPSRA->P8_HORA < (Val(nHoraEnt2M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraEnt2)))));
					          .OR.((TMPSRA->R_E_C_N_O_ = SAI1) .AND. ((TMPSRA->P8_HORA < (Val(nHoraSai1M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraSai1))))); 
					          .OR.((TMPSRA->R_E_C_N_O_ = SAI2) .AND. ((TMPSRA->P8_HORA < (Val(nHoraSai2M))) .OR. (TMPSRA->P8_HORA > (Val(nHoraSai2)))));  	
		                //separando os setores, pq o envio de email tm que ser para o gerente de cada setor
					    					            
					    			   AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSRA->RA_FILIAL)     
											 AAdd((oHtml:ValByName( "IT.MATRICULA" )), TMPSRA->RA_MAT)
									 	   AAdd((oHtml:ValByName( "IT.NOME" )), TMPSRA->RA_NOME)		 		
										 	 AAdd((oHtml:ValByName( "IT.EVENTO" )), TMPSRA->P9_CODIGO)				
									     AAdd((oHtml:ValByName( "IT.DESC" )), TMPSRA->P9_DESC)
									     AAdd((oHtml:ValByName( "IT.CC" )), TMPSRA->RA_CC)        //Centro de custo
									     AAdd((oHtml:ValByName( "IT.HORARIO" )), TMPSRA->RA_X_DTURN) //Horario que o func. deve cumprir
							         AAdd((oHtml:ValByName( "IT.IT.HORA" )), TMPSRA->P8_HORA) //hora q o func bateu o ponto 
							         AAdd((oHtml:ValByName( "IT.DATAMARC" )), StoD(TMPSRA->P8_DATA)) //Data da marcação
							        
							         //variavel para confirmar que existe algum registro -> assim evita-se t enviar e-mail sem registro
							         RegOk := 1  
							   endif
						  ENDIF      
						  TMPSRA->(DbSkip())					         	
	         end
	       TMPSRA->(DbSkip())			         	
       end 
            //se o email for vazio ou não ter nenhum registro com inconsistencia de marcação -> não enviar e-mail 
           if ((cEmail = '') .or. (RegOk <> 1)) 
             	 TMP->(DbSkip()) 
           else
              oProcess:cTo  := LOWER(cEmail) 
			        oProcess:Start()  
			        oProcess:Finish()                                                 
		  		  	conout("WF - WFINCMAR - Fim do Envio de e-mail de Inconsistência de Marcação no Ponto Eletrônico - "+dToS(DDATABASE))
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