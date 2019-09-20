#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"
#DEFINE CDIRSRV "/pefin/"

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ?          ? Autor ? Adriano Novachaelley Data ?  29/03/10   ???
????????????????????????????????????????????????????????????????????????????
???Descricao ? Geracao de arquivo conforme layout do PEFIN-SERASA.        ???
???          ?                                                            ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Inclusao e Exclusao de cadastros no SERASA.                ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/
                          
User Function PEFIN()  

Private oGeraTxt
Private cPerg := "PEFIN00"
ValidPerg()
Pergunte(cPerg,.F.)

@ 200,001 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa ira gerar um arquivo texto, conforme layout do  "
@ 018,018 Say " PEFIN-SERASA."
@ 60,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return


Static Function OkGeraTxt

cSeqLin	:= StrZero(1,6)            
Private nSeqRem	:= StrZero(Val(GetMV("MV_PEFINSQ")),6)
Private nHdl    := fCreate(AllTrim(mv_par03)+"SER"+cEmpAnt+cFilAnt+nSeqRem+".txt")

//Guilherme 24/04/15
cNumArq					:= "SER"+cEmpAnt+cFilAnt+nSeqRem

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par03+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

Processa({|| RunCont() },"Processando...")
Return

/*/
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Fun??o    ? RUNCONT  ? Autor ? AP5 IDE            ? Data ?  08/03/10   ???
????????????????????????????????????????????????????????????????????????????
???Descri??o ? Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  ???
???          ? monta a janela com a regua de processamento.               ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Programa principal                                         ???
????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
?????????????????????????????????????????????????????????????????????????????
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo
nTamLin := 600
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao 
nSeqReg	:= 1
nDias	:= GetMv("MV_PEFINDT")
cBanco	:= GetMv("MV_X_BCOPF")
dLimit	:= DtoS((dDataBase-1770)) // Data limite para a inclusão no SERASA. 4 ANOS E 11 MESES
aInc		:= {} //Guilherme 24-04-15  

cLin := ""
cLin += "0"                                         // 1 HEADER
cLin += StrZero(Val(SubStr(SM0->M0_CGC,1,8)),9)     // 2 HEADER
cLin += DtoS(dDataBase)                             // 3 HEADER
cLin += StrZero(Val(SubStr(SM0->M0_TEL,1,3)),4)     // 4 HEADER
cLin += StrZero(Val(SubStr(SM0->M0_TEL,4,8)),8)     // 5 HEADER
cLin += Space(4) 							    	// 6 HEADER Ver com Eder como ramais.
cLin += Space(70) 							    	// 7 HEADER Ver com Eder como configurar contato.         
cLin += "SERASA-CONVEM04"					     	// 8 HEADER
cLin += nSeqRem 							     	// 9 HEADER
cLin += "E"									      	// 10 HEADER
if Alltrim(SuperGetMV("MV_AREAPE",,"N",)) == "S"
	cLin += StrZero(Val(SubStr(SM0->M0_CGC,9,4)),4) // 11 HEADER
Else 
	cLin += Space(4)                                // 12 HEADER    
Endif	                                                            
cLin += Space(3)                                    //    HEADER
clin += SubStr((SuperGetMV("MV_LOGON",,space(8),)),1,8) // LOGON 
cLin += Space(392)                                  // 13 HEADER
clin += Space(60)                                   // 14 HEADER
cLin += StrZero(nSeqReg,7)                          // 15 HEADER
cLin += cEOL  

fWrite(nHdl,cLin,Len(cLin))
nSeqReg += 1 // Sequencial de registros

// Guilherme 28/07/14 - Verificado se o arquivo será criado com inclusao apenas ou ambas
If mv_par09 == 1 .OR. mv_par09 == 3
	// INICIO DE TITULOS PARA INCLUSAO
	cSql := "SELECT E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_SALDO, E1.E1_VENCREA, E1.E1_EMISSAO,E1.E1_VALOR, "
	cSql += "E1.E1_PARCELA, E1.E1_TIPO, E1.E1_CLIENTE, E1.E1_LOJA,E1.E1_PEFININ,E1.E1_PEFINEX, E1_PEFINMB, "
	cSql += "A1.A1_COD, A1.A1_LOJA, A1.A1_NOME ,A1.A1_PESSOA, A1.A1_CGC, A1.A1_END, " 
	cSql += "A1.A1_BAIRRO, A1.A1_MUN, A1.A1_EST, A1.A1_CEP, A1.A1_DDD, A1.A1_TEL "
	cSql += "FROM "+RetSqlName("SE1")+" E1,"+RetSqlName("SA1")+" A1 " 
	cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cSql += "AND E1.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "        
	// Nao envia cliente para o Serasa.
	cSql += "AND A1.A1_X_SERAS <> 'N' "  
	cSql += "AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA "
	cSql += "AND E1.E1_VENCREA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	cSql += "AND E1.E1_PREFIXO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
	cSql += "AND E1.E1_CLVLCR BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
	cSql += "AND E1.E1_VENCREA < '"+DtoS(dDataBase-nDias)+"' "
	cSql += "AND E1.E1_VENCREA > '"+dLimit+"' "
	cSql += "AND E1.E1_SALDO > 0 "   
	cSql += "AND E1.E1_SALDO >= E1.E1_VALOR  "
	cSql += "AND E1.E1_TIPO = 'NF ' "
	cSql += "AND E1.E1_PEFININ = ' ' "
	//Guilherme 28-07-14 - Solicitado filtro de banco pela sra. Vandreia.
	If !Empty(mv_par08) 
		cSql += "AND E1.E1_PORTADO  = '"+mv_par08+"'
	Else  //Nesse ponto vrerifica se foi preenchido o banco, caso sim, considera apenas ele, caso não, deve ser ignorado o banco panamericando 28-07-14
		cSql += "AND E1.E1_PORTADO <> '"+Alltrim(cBanco)+"'
	EndIf	 
	                              
	TcQuery cSql NEW ALIAS "TMPE1" 
	MemoWrite("c:\pefin.txt",cSql)
	TMPE1->(dbSelectArea("TMPE1"))
	TMPE1->(dbGoTop())
	// X2_Unico SE1
	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	// Indice orden 2
	// E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 
	
	ProcRegua(RecCount()) 
	While !TMPE1->(EOF())
	
	    IncProc()
	   	cCodOp	:= "I" 				 // Codigo da Operacao I-Inclusao E-Exclusao
	   	cCampo  := "SE1->E1_PEFININ" // Campo a atualizar E1_PEFININ inclusao E1_PEFINE exclusao
	   	cMotBx	:= Space(2)			 // Motivo da baixa
	
		cLin    := ""  
	    cLin	+= "1"														// 1 Detalhes 
	    cLin 	+= cCodOp													// 2 Detalhes 
	    cLin 	+= SubStr(SM0->M0_CGC,9,6) 									// 3 Detalhes 
	    cLin	+= TMPE1->E1_VENCREA										// 4 Detalhes 
		cLin 	+= TMPE1->E1_VENCREA	   									// 5 Detalhes 
		cLin 	+= TMPE1->E1_TIPO											// 6 Detalhes
		cLin 	+= Space(4)   												// 7 Detalhes  // Tabela Pracas embratel.
		cLin 	+= TMPE1->A1_PESSOA											// 8 Detalhes 
		cLin 	+= IIF(Len(AllTrim(TMPE1->A1_CGC))>11,"1","2") 				// 9 Detalhes 
		cLin	+= StrZero(Val(TMPE1->A1_CGC),15)//                         // 10 Detalhes 
		cLin	+= cMotBx 													// 11 Detalhes 
		cLin	+= Space(1)				   									// 12 Detalhes 
		cLin	+= Space(15)												// 13 Detalhes 
		cLin	+= Space(2)				    								// 14 Detalhes 
	// Para os campos abaixo , de Seq. 15 a 21, referentes ao coobrigado, se o registro for do principal, deixar em branco.	
		cLin	+= Space(1)													// 15 Detalhes 
		cLin	+= Space(1)													// 16 Detalhes 
		cLin	+= Space(15)                								// 17 Detalhes 
		cLin	+= Space(2)													// 18 Detalhes Espacos   
		cLin	+= Space(1)				   									// 19 Detalhes 
		cLin	+= Space(15)			   									// 20 Detalhes 
		cLin	+= Space(2)													// 21 Detalhes 
	
		cLin	+= SubStr(TMPE1->A1_NOME+SPACE(70),1,70)					// 22 Detalhes 
		cLin	+= "00000000"											// 23 Detalhes 
																			
		cLin	+= Space(70)												// 24 Detalhes 
		cLin 	+= Space(70)												// 25 Detalhes 
		cLin	+= SubStr(TMPE1->A1_END+Space(45),1,45) 					// 26 Detalhes 
		cLin 	+= SubStr(TMPE1->A1_BAIRRO+Space(20),1,20) 					// 27 Detalhes 
		cLin 	+= SubStr(TMPE1->A1_MUN+Space(25),1,25) 					// 28 Detalhes 
		cLin	+= TMPE1->A1_EST		   									// 29 Detalhes 
		cLin    += StrZero(Val(TMPE1->A1_CEP),8)                            // 30 Detalhes 
		cValor	:= ""
		For nR  := 1 To Len(Strzero(TMPE1->E1_VALOR,16,2))
			If SubStr(Strzero(TMPE1->E1_VALOR,16,2),nR,1) $ "0123456789" 
				cValor	+= SubStr(Strzero(TMPE1->E1_VALOR,16,2),nR,1)
			Endif
		Next Nr	
		cLin	+= cValor													// 31 Detalhes 
	//	cLin	+= StrZero(Val(TMPE1->E1_NUM+TMPE1->E1_PARCELA),16)			// 32 Detalhes Numero do contrato (que identifique o titulo)
		cLin	+= Space(04)+TMPE1->E1_NUM+TMPE1->E1_PARCELA				// 32 Detalhes 
		cLin	+= TMPE1->E1_CLIENTE										// 33 Detalhes // Cliente+Loja
		cLin 	+= Space(25)												// 34 Detalhes 
		cLin	+= StrZero(Val(TMPE1->A1_DDD),4) 							// 35 Detalhes 
		cLin	+= StrZero(Val(TMPE1->A1_TEL),9) 							// 36 Detalhes 
		cLin 	+= TMPE1->E1_EMISSAO										// 37 Detalhes 
		cValor	:= ""
		For nR  := 1 To Len(Strzero(TMPE1->E1_VALOR,16,2))
			If SubStr(Strzero(TMPE1->E1_VALOR,16,2),nR,1) $ "0123456789" 
				cValor	+= SubStr(Strzero(TMPE1->E1_VALOR,16,2),nR,1)
			Endif
		Next Nr
		cLin	+= cValor					 								// 38 Detalhes 
																			// 39 Detalhes 
		cLin	+= Space(9)					 								// 40 Detalhes 
		cLin	+= Space(60)				 								// 41 Detalhes 
	    cLin 	+= StrZero(nSeqReg,7)
	    clin 	+= cEOL
	
	    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
	            Exit
	        Endif
	    Endif
	    cChaveE1 := TMPE1->E1_FILIAL+TMPE1->E1_CLIENTE+TMPE1->E1_LOJA+TMPE1->E1_PREFIXO+TMPE1->E1_NUM+;
	    			TMPE1->E1_PARCELA+TMPE1->E1_TIPO
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(2))
	    SE1->(DbGotop())
	    If DbSeek(cChaveE1)
		 		RecLock("SE1",.F.)
		 			&cCampo := nSeqRem
		 			SE1->E1_HIST := "PEFIN "+AllTrim(SE1->E1_HIST)	
		  	MsUnlock("SE1")  
		  	
		  	aAdd(aInc,{"I",TMPE1->E1_FILIAL,TMPE1->E1_CLIENTE,TMPE1->E1_LOJA,TMPE1->E1_PREFIXO,TMPE1->E1_NUM,TMPE1->E1_PARCELA,TMPE1->E1_TIPO})
		  	   
	    Else 
	    	//Guilherme 24-04-15 - Trativa de exceção quando nao encontrar o registro
	    	Aviso("Atenção!","Inclusão do Reg. Filial: "+TMPE1->E1_FILIAL+"Cliente: "+TMPE1->E1_CLIENTE+"Loja: "+TMPE1->E1_LOJA+"Prefixo: ";
	    																							+TMPE1->E1_PREFIXO+"Numero: "+TMPE1->E1_NUM+"Parcela: "+TMPE1->E1_PARCELA+"Tipo: ";
	    																							+TMPE1->E1_TIPO+" Com problema, informe a equipe de TI",{"OK"},2)  
	    Endif
	    nSeqReg += 1 					// Sequencial de registros
	    
			TMPE1->(DbSelectArea("TMPE1"))
	    TMPE1->(dbSkip())
	EndDo
	TMPE1->(DbSelectArea("TMPE1"))
	TMPE1->(DbCloseArea())
	// FINAL INCLUSAO DE CADASTROS NO PEFIN-SERASA.
EndIf // Guilherme 28-07-14 FIM                                                

//Guilherme 28-07-14 filtra que tipo de operação será gerada no aqruivo.
If mv_par09 == 2 .OR. mv_par09 == 3
	
	aExc	:= {} //Guilherme 24-04-15
	
	// INICIO EXCLUS?O DE CADASTROS NO PEFIN-SERASA.
	cSql := "SELECT E1.E1_FILIAL, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_SALDO, E1.E1_VENCREA, E1.E1_EMISSAO,E1.E1_VALOR, "
	cSql += "E1.E1_PARCELA, E1.E1_TIPO, E1.E1_CLIENTE, E1.E1_LOJA,E1.E1_PEFININ,E1.E1_PEFINEX, E1_PEFINMB, "
	cSql += "A1.A1_COD, A1.A1_LOJA, A1.A1_NOME ,A1.A1_PESSOA, A1.A1_CGC, A1.A1_END, " 
	cSql += "A1.A1_BAIRRO, A1.A1_MUN, A1.A1_EST, A1.A1_CEP, A1.A1_DDD, A1.A1_TEL "
	cSql += "FROM "+RetSqlName("SE1")+" E1,"+RetSqlName("SA1")+" A1 " 
	cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
	cSql += "AND E1.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "        
	// Nao envia cliente para o Serasa.
	cSql += "AND A1.A1_X_SERAS <> 'N' "  
	cSql += "AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA "
	cSql += "AND E1.E1_TIPO = 'NF ' "
	cSql += "AND E1.E1_PEFINEX = ' ' "
	//cSql += "AND E1.E1_PEFINMB <> ' ' "
	//GUILHERME 20/08/13 - alterado para NAO excluir motivo de baixa igual a 12 que é perda.
	cSql += "AND E1.E1_PEFINMB NOT IN (' ','12') "  
	//Guilherme 08/12/14 - Adicionado o filtro de segmento também na exclusão de registros
	cSql += "AND E1.E1_CLVLCR BETWEEN '"+mv_par06+"' AND '"+mv_par07+"' "
	//Guilherme 08/12/14 - Fim
	If !Empty(mv_par08)
		cSql += "AND E1.E1_PORTADO = '"+Alltrim(mv_par08)+"'
	EndIf
	
	TcQuery cSql NEW ALIAS "TMPSE1" 
	TMPSE1->(dbSelectArea("TMPSE1"))
	TMPSE1->(dbGoTop())
	// X2_Unico SE1
	// E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
	// Indice orden 2
	// E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 
	
	ProcRegua(RecCount()) 
	While !TMPSE1->(EOF())
	
    IncProc()
   	cCodOp	:= "E" 				 // Codigo da Opera??o I-Inclusao E-Exclusao
   	cCampo  := "SE1->E1_PEFINEX" // Campo a atualizar E1_PEFININ inclusao E1_PEFINE exclusao    	
   	cMotBx	:= TMPSE1->E1_PEFINMB // Motivo da baixa

             
		cLin  := ""  
    cLin	+= "1"														// 1 Detalhes 
    cLin 	+= cCodOp													// 2 Detalhes 
    cLin 	+= SubStr(SM0->M0_CGC,9,6) 									// 3 Detalhes 
    cLin	+= TMPSE1->E1_VENCREA										// 4 Detalhes 
		cLin 	+= TMPSE1->E1_VENCREA	   									// 5 Detalhes 
		cLin 	+= TMPSE1->E1_TIPO											// 6 Detalhes
		cLin 	+= Space(4)   												// 7 Detalhes  // Tabela Pracas embratel.
		cLin 	+= TMPSE1->A1_PESSOA											// 8 Detalhes 
		cLin 	+= IIF(Len(AllTrim(TMPSE1->A1_CGC))>11,"1","2") 				// 9 Detalhes 
		cLin	+= StrZero(Val(TMPSE1->A1_CGC),15)//                         // 10 Detalhes 
		cLin	+= cMotBx 													// 11 Detalhes 
		cLin	+= Space(1)				   									// 12 Detalhes 
		cLin	+= Space(15)												// 13 Detalhes 
		cLin	+= Space(2)				    								// 14 Detalhes 
	// Para os campos abaixo , de Seq. 15 a 21, referentes ao coobrigado, se o registro for do principal, deixar em branco.	
		cLin	+= Space(1)													// 15 Detalhes 
		cLin	+= Space(1)													// 16 Detalhes 
		cLin	+= Space(15)                								// 17 Detalhes 
		cLin	+= Space(2)													// 18 Detalhes Espacos   
		cLin	+= Space(1)				   									// 19 Detalhes 
		cLin	+= Space(15)			   									// 20 Detalhes 
		cLin	+= Space(2)													// 21 Detalhes 
	
		cLin	+= SubStr(TMPSE1->A1_NOME+SPACE(70),1,70)					// 22 Detalhes 
		cLin	+= "00000000"    											// 23 Detalhes 
																			
		cLin	+= Space(70)												// 24 Detalhes 
		cLin 	+= Space(70)												// 25 Detalhes 
		cLin	+= SubStr(TMPSE1->A1_END+Space(45),1,45) 					// 26 Detalhes 
		cLin 	+= SubStr(TMPSE1->A1_BAIRRO+Space(20),1,20) 					// 27 Detalhes 
		cLin 	+= SubStr(TMPSE1->A1_MUN+Space(25),1,25) 					// 28 Detalhes 
		cLin	+= TMPSE1->A1_EST		   									// 29 Detalhes 
		cLin    += StrZero(Val(TMPSE1->A1_CEP),8)                            // 30 Detalhes 
		cValor	:= ""
		For nR  := 1 To Len(Strzero(TMPSE1->E1_VALOR,16,2))
			If SubStr(Strzero(TMPSE1->E1_VALOR,16,2),nR,1) $ "0123456789" 
				cValor	+= SubStr(Strzero(TMPSE1->E1_VALOR,16,2),nR,1)
			Endif
		Next Nr	
		cLin	+= cValor													// 31 Detalhes      Pos Tam
	//	cLin	+= StrZero(Val(TMPSE1->E1_NUM+TMPSE1->E1_PARCELA),16)			// 32 Detalhes  439 016 
		// E1_CLIENTE Caracter de 9, E1_LOJA Caracter de 4, E1_PARCELA Caracter de 3, E1_Num caracter de 9 
		cLin	+= Space(04)+TMPSE1->E1_NUM+TMPSE1->E1_PARCELA				// 32 Detalhes 
		cLin	+= TMPSE1->E1_CLIENTE										// 33 Detalhes // Cliente+Loja
		cLin 	+= Space(25)												// 34 Detalhes 
		cLin	+= StrZero(Val(TMPSE1->A1_DDD),4) 							// 35 Detalhes 
		cLin	+= StrZero(Val(TMPSE1->A1_TEL),9) 							// 36 Detalhes 
		cLin 	+= TMPSE1->E1_EMISSAO										// 37 Detalhes 
		cValor	:= ""
		For nR  := 1 To Len(Strzero(TMPSE1->E1_VALOR,16,2))
			If SubStr(Strzero(TMPSE1->E1_VALOR,16,2),nR,1) $ "0123456789" 
				cValor	+= SubStr(Strzero(TMPSE1->E1_VALOR,16,2),nR,1)
			Endif
		Next Nr
		cLin	+= cValor					 								// 38 Detalhes 
																			// 39 Detalhes 
		cLin	+= Space(9)					 								// 40 Detalhes 
		cLin	+= Space(60)				 								// 41 Detalhes 
    cLin 	+= StrZero(nSeqReg,7)
    clin 	+= cEOL

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
    	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
    		Exit
     	Endif
    Endif
    cChaveE1 := TMPSE1->E1_FILIAL+TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA+TMPSE1->E1_PREFIXO+TMPSE1->E1_NUM+;
    						TMPSE1->E1_PARCELA+TMPSE1->E1_TIPO
    DbSelectArea("SE1")
    SE1->(DbSetOrder(2))
    SE1->(DbGotop())
    If DbSeek(cChaveE1)
	 		RecLock("SE1",.F.)
	 			&cCampo := nSeqRem 	
	  	MsUnlock("SE1")     
	  	
  		aAdd(aExc,{"E",TMPSE1->E1_FILIAL,TMPSE1->E1_CLIENTE,TMPSE1->E1_LOJA,TMPSE1->E1_PREFIXO,TMPSE1->E1_NUM,TMPSE1->E1_PARCELA,TMPSE1->E1_TIPO})
    Else
    	//Guilherme 24-04-15 - Trativa de exceção quando nao encontrar o registro
	    Aviso("Atenção!","Exclusão do Reg. Filial: "+TMPE1->E1_FILIAL+"Cliente: "+TMPE1->E1_CLIENTE+"Loja: "+TMPE1->E1_LOJA+"Prefixo: ";
	    																						+TMPE1->E1_PREFIXO+"Numero: "+TMPE1->E1_NUM+"Parcela: "+TMPE1->E1_PARCELA+"Tipo: ";
	    																						+TMPE1->E1_TIPO+" Com problema, informe a equipe de TI",{"OK"},2)  
    
    Endif
    nSeqReg += 1 					// Sequencial de registros
    
		TMPSE1->(DbSelectArea("TMPSE1"))
	 	TMPSE1->(dbSkip())
	EndDo
	TMPSE1->(DbSelectArea("TMPSE1"))
	TMPSE1->(DbCloseArea())
	// FINAL EXCLUSAO DE CADASTROS NO PEFIN-SERASA.
EndIf  //Guilherme 28-08-14 FIm

If nSeqREg > 2
	PutMv("MV_PEFINSQ",StrZero(Val(GetMV("MV_PEFINSQ"))+1,6))  
	
	cLin	:= ""
	cLin	+= "9" 			   		// C?digo de registro - 9 ? trailler (1) (2)
	cLin	+= Space(532) 			// Deixar em Branco
	cLin	+= Space(60)  			// C?digos de erros ? 3 posi??es ocorrendo 20 vezes. Aus?ncia
	                      			// de c?digos indica que o arquivo foi aceito no movimento de Retorno. 
	                      			// Na entrada, preencher com brancos   
	cLin 	+= StrZero(nSeqReg,7) 	// Sequ?ncia do registro no arquivo (1) (2)
	clin 	+= cEOL
	fWrite(nHdl,cLin,Len(cLin))
	
Else
	Alert("Nenhum registro encontrato.")
	fClose(nHdl)
	ferase(mv_par03)
Endif

fClose(nHdl)
Close(oGeraTxt)  

//Guilherme 24-04-15 Função para enviar workflow da geração do arquivo.
 If Len(aInc) > 0 .OR. Len(aExc) > 0
   //	U_relArq()
EndIf

Return
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Vencimento inicial  ","","","mv_ch1","D",08,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"02","Vencimento final    ","","","mv_ch2","D",08,0,0,"G","NaoVazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Local do arquivo    ","","","mv_ch3","C",30,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Prefixo Inicial     ","","","mv_ch4","C",03,0,1,"C","        ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Prefixo Final       ","","","mv_ch5","C",03,0,1,"C","NaoVazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"06","Segmento Inicial    ","","","mv_ch6","C",09,0,0,"G",""        ,"mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"07","Segmento Final      ","","","mv_ch7","C",09,0,0,"G","naovazio","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"08","Filtra Banco        ","","","mv_ch8","C",03,0,0,"G","        ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA6",""})
aAdd(aRegs,{cPerg,"09","Considera?          ","","","mv_ch9","N",01,0,0,"C","        ","mv_par09","Inclusao","Inclusao","Inclusao","","","Exclusao","Exclusao","Exclusao","","","Ambos","Ambos","Ambos","","","","","","","","","","","","",""})
//Guilherme - Adicionados os filtros 08 e 09 solicitados pela Sra. Vandreia devido a problemas com um abanco. 28-07-14

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return    

User Function RelArq()
Local cStatus 	:= SPACE(6)

oProcess := TWFProcess():New("WFRELAR","Resumo do arquivo do PEFIN")
oProcess:NewTask(cStatus,"\workflow\wfrelarq.htm")
oProcess:cSubject := ("Resumo do Arquivo do PEFIN")      
oProcess:cTo  		:= UsrRetMail(__cUserID) //"gpoyer@gmail.com"  
oProcess:cCC			:= AllTrim(SuperGetMV("MV_X_USRPE", ,'gpoyer@gmail.com'))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta o workflow            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
if len(aInc) > 0 .OR. len(aExc) > 0
	oHtml:= oProcess:oHTML
	oHtml:ValByName("DATA" , DtoC(DDATABASE))	
  
	oHtml:ValByName("ARQUI", cNumArq)
  oHtml:ValByName("PARM1", MV_PAR01)//Venc. Inicial
  oHtml:ValByName("PARM2", MV_PAR02)//Venc. Final
  oHtml:ValByName("PARM4", MV_PAR04)//Prefixo Inicial
  oHtml:ValByName("PARM5", MV_PAR05)//Prefixo Final 
  oHtml:ValByName("PARM6", MV_PAR06)//Segm. Inicial
  oHtml:ValByName("PARM7", MV_PAR07)//Segm. Final
  oHtml:ValByName("PARM8", MV_PAR08)//Filtra banco
  
  If MV_PAR09 == 1
  	oHtml:ValByName("PARM9", "Inclusão") //Considera qual arquivo
  ElseIf MV_PAR09 == 2
  	oHtml:ValByName("PARM9", "Exclusão") //Considera qual arquivo
  Else	
  	oHtml:ValByName("PARM9", "Ambos") //Considera qual arquivo  
  EndIf
  
  If len(aInc) > 0   
		FOR I := 1 TO len(aInc)
	    
	    cNome := Posicione("SA1",1,xFilial("SA1")+aInc[I][3],"A1_NOME")
	    
	    AAdd( (oHtml:ValByName( "IT.FILIAL"   )),aInc[I][2])
	    AAdd( (oHtml:ValByName( "IT.CLIENTE"  )),aInc[I][3])
			AAdd( (oHtml:ValByName( "IT.LOJA"     )),aInc[I][4])
			AAdd( (oHtml:ValByName( "IT.NOME"     )),Substr(cNome,1,20))
			AAdd( (oHtml:ValByName( "IT.PREFIXO"  )),aInc[I][5])
			AAdd( (oHtml:ValByName( "IT.NUMERO"   )),aInc[I][6])
			AAdd( (oHtml:ValByName( "IT.PARCELA"  )),aInc[I][7])
			AAdd( (oHtml:ValByName( "IT.TIPO"     )),aInc[I][8])
		                                                          			
		NEXT I 
	Else
		
    AAdd( (oHtml:ValByName( "IT.FILIAL"   ))," ")
    AAdd( (oHtml:ValByName( "IT.CLIENTE"  ))," ")
		AAdd( (oHtml:ValByName( "IT.LOJA"     ))," ")
		AAdd( (oHtml:ValByName( "IT.NOME"     )),"NÃO HÁ REGISTROS DE INCLUSAO!	")
		AAdd( (oHtml:ValByName( "IT.PREFIXO"  ))," ")
		AAdd( (oHtml:ValByName( "IT.NUMERO"   ))," ")
		AAdd( (oHtml:ValByName( "IT.PARCELA"  ))," ")
		AAdd( (oHtml:ValByName( "IT.TIPO"     ))," ")	
		
	EndIf
	
	If len(aExc) > 0   
		FOR I := 1 TO len(aExc)
	    
	    cNome := Posicione("SA1",1,xFilial("SA1")+aExc[I][3],"A1_NOME")
	    
	    AAdd( (oHtml:ValByName( "IT2.FILIAL"   )),aExc[I][2])
	    AAdd( (oHtml:ValByName( "IT2.CLIENTE"  )),aExc[I][3])
			AAdd( (oHtml:ValByName( "IT2.LOJA"     )),aExc[I][4])
			AAdd( (oHtml:ValByName( "IT2.NOME"     )),Substr(cNome,1,20))
			AAdd( (oHtml:ValByName( "IT2.PREFIXO"  )),aExc[I][5])
			AAdd( (oHtml:ValByName( "IT2.NUMERO"   )),aExc[I][6])
			AAdd( (oHtml:ValByName( "IT2.PARCELA"  )),aExc[I][7])
			AAdd( (oHtml:ValByName( "IT2.TIPO"     )),aExc[I][8])
		                                                          			
		NEXT I 
	
	Else
	
    AAdd( (oHtml:ValByName( "IT2.FILIAL"   ))," ")
    AAdd( (oHtml:ValByName( "IT2.CLIENTE"  ))," ")
		AAdd( (oHtml:ValByName( "IT2.LOJA"     ))," ")
		AAdd( (oHtml:ValByName( "IT2.NOME"     )),"NÃO HÁ REGISTROS DE EXCLUSÃO!")
		AAdd( (oHtml:ValByName( "IT2.PREFIXO"  ))," ")
		AAdd( (oHtml:ValByName( "IT2.NUMERO"   ))," ")
		AAdd( (oHtml:ValByName( "IT2.PARCELA"  ))," ")
		AAdd( (oHtml:ValByName( "IT2.TIPO"     ))," ")	
	
	EndIf
	
 	if File(AllTrim(mv_par03)+"SER"+cEmpAnt+cFilAnt+nSeqRem+".txt")
		if CpyT2S(AllTrim(mv_par03)+"SER"+cEmpAnt+cFilAnt+nSeqRem+".txt", CDIRSRV, .F.)
  		oProcess:AttachFile(CDIRSRV+"SER"+cEmpAnt+cFilAnt+nSeqRem+".txt") 	
		EndIf
	Else
		Alert("Atenção!, Problema ao anexar o arquivo para envio do WorkFlow")	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Envia o workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oProcess:Start()
endif 



Return()