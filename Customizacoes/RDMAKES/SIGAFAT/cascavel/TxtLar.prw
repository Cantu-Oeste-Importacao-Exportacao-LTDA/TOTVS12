#INCLUDE "rwmake.ch"
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TXTLAR ¦ Autor ¦  Regis Strucker	    ¦ Data ¦ 	26/10/07  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Arquivo resumo de NFS emitidas diariamente para Coop. Lar  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico cliente CANTU - Empresa 40/01                   ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function TXTLAR


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg       := "LAR"
Private oGeraTxt

Private cString := "SF2"

AjustSX1()
Pergunte(cPerg,.F.)

dbSelectArea("SF2")
dbSetOrder(1)     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,480 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,230 
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " Notas Fiscais (SF2)                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,188 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ Regis Stucker      º Data ³  20/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cArqTxt := "C:\Lar\lar.TXT"// + Dtoc(dDataBase)
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  17/10/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

//mv_par01 = Data Emissao ?

Static Function RunCont

Local nTamLin, cLin, cCpo , dDtEmi , cDescProd , cValTotNF:=0 , cCgcCliente
Local cCodCliLar:= "77752293" //"000069" //01/00006902/00006903/00006904/00006905/00006906" //STRING com codigos
//cCodCliLar:= cCodCliLar + "/00006907/00006908/00006909/00006910/00006911"  // de Cliente = LAR
//cCodCliLar:= cCodCliLar + "/00006912/00006913/00006914/00006915/00006916/00006917/" 



	  		 nTamLin := 134
		     cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Header                                                           o  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		    cCpo := PADR("H",01)
		    cLin := Stuff(cLin,01,01,cCpo)    

			dDtEmi := Substr(Dtos(mv_par01),07,02)
			dDtEmi := dDtEmi + Substr(Dtos(mv_par01),05,02)
			dDtEmi := dDtEmi + Substr(Dtos(mv_par01),03,02)			
							
		    cCpo := PADR(dDtEmi,06)            				// Data Emissao
		    cLin := Stuff(cLin,02,06,cCpo)                  
		    cCpo := Space(06)                       // Data Vencimento     
		    cLin := Stuff(cLin,08,06,cCpo)    
		    cCpo := PADR(SM0->M0_NOME,40)          // Cantu....
		    cLin := Stuff(cLin,14,40,cCpo)    
   		    cCpo := Space(79)                               // Espacos em branco 
		    cLin := Stuff(cLin,54,79,cCpo)    
		    
			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
					
		        Endif
		    Endif
		    
		    
dbSelectArea("SF2")
dbSetOrder(4)  
DbGotop()
//If dbSeek(xFilial("SF2") + "2  " + DTOS(mv_par01),.t.) // Adriano Removido pois no projeto a serie utilizada é diferente. 27/12/2010
If dbSeek(xFilial("SF2") + "4  " + DTOS(mv_par01),.t.)
	While !Eof() .And. xFilial("SF2") == SF2->F2_FILIAL .And. mv_par01 == SF2->F2_EMISSAO 

//	If !((SF2->F2_CLIENTE+SF2->F2_LOJA)$(cCodCliLar))
	If !(AllTrim((SF2->F2_CLIENTE))$(cCodCliLar))
		 DbSelectarea("SF2")
		 dbSkip()
		 loop
	Endif 
	
		dbSelectArea("SD2")
		dbSetOrder(3)
		If dbSeek(xFilial("SD2")+ SF2->F2_Doc + SF2->F2_Serie,.t.)		
            cValTotNF := cValTotNF + SF2->F2_VALFAT
		    Do While !Eof().And. SD2->D2_Filial == xFilial("SD2");
	            .And. SD2->D2_Doc    == SF2->F2_Doc;
	            .And. SD2->D2_Serie  == SF2->F2_Serie 

	    
		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ Detalhe                                                          o  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	        SC6->(DBGOTOP())	  	
		    nTamLin := 134
		    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
	   
			    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			    //³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
			    //³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
			    //³ string dentro de outra string.                                      ³
			    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			    cCpo := PADR("N",01)                    // Identificador N
			    cLin := Stuff(cLin,01,01,cCpo)			
			    cCpo := PADR(SD2->D2_COD,07)			// Cod. Produto na Cantu
			    cLin := Stuff(cLin,02,07,cCpo)                         
	
				dbSelectArea("SA1")
				dbSetOrder(1)		
				dbSeek(xfilial("SA1")+ SF2->F2_CLIENTE + SF2->F2_LOJA)
				cCgcCliente:= Substr(SA1->A1_CGC,10,03)

			    cCpo := PADR(cCgcCliente,03)                     //  Local de entrega LAR  ??regis
			    cLin := Stuff(cLin,09,03,cCpo)         

				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+ SD2->D2_COD,.t.)		

			    cCpo := PADR(SB1->B1_DESC,28)		 		// Desc. Produto na Cantu
			    cLin := Stuff(cLin,12,28,cCpo)                         
	                                
	   		    cCpo := PADR(SubSTR(SD2->D2_DOC,4,6),06)			// Numero da Nota
			    cLin := Stuff(cLin,40,06,cCpo)                         
	
			    cCpo := PADR(SD2->D2_SERIE,03)			// Serie da Nota
			    cLin := Stuff(cLin,46,03,cCpo)                         
	
			    cCpo := PADR(SB1->B1_CODLAR,06)			// Cod Prod. Lar
			    cLin := Stuff(cLin,49,06,cCpo)                         		    
			    
				SC6->(DbSetOrder(1))                    // filial+ped+item      It. De PV   
			    SC6->(DbSeek(xFilial("SC6")+SD2->D2_Pedido + SD2->D2_ItemPV))				

				If SC6->C6_IMPUNI == "1"	//Impressao na primeira unidade de medida
				    cCpo := STR(SD2->D2_QUANT*100,10)		// Quantidade Prod.
				    cLin := Stuff(cLin,55,10,cCpo)                         		    

				    cCpo := STR(SD2->D2_PRCVEN*100,10)			// Valor Unitario
				    cLin := Stuff(cLin,65,10,cCpo)                         		    
				    
				    cCpo := STR(SD2->D2_TOTAL*100,10)			// Valor Total da Mercadoria
				    cLin := Stuff(cLin,75,10,cCpo)                         		    
	            else //Impressao na segunda unidade de medida
				    cCpo := STR(SC6->C6_UNSVEN*100,10)		// Quantidade Prod.
				    cLin := Stuff(cLin,55,10,cCpo)                         		    
	
				    cCpo := STR(SC6->C6_PRCSU*100,10)		// Valor Unitario
				    cLin := Stuff(cLin,65,10,cCpo)                         		    
	
				    cCpo := STR(SC6->C6_VALOR*100,10)			// Valor Total da Mercadoria
				    cLin := Stuff(cLin,75,10,cCpo)                         		    
	            end 
	            
			    cCpo := STR(SD2->D2_VALIPI*100,10)			// Valor IPI
			    cLin := Stuff(cLin,85,10,cCpo)                         		    		    		    		    		                                                                    
	
			    cCpo := STR(SD2->D2_VALICM*100,10)			// Valor ICM
			    cLin := Stuff(cLin,95,10,cCpo)                         	
			    
			    cCpo := STR(SD2->D2_VALISS*100,10)			// Valor ISS
			    cLin := Stuff(cLin,105,10,cCpo)                         	
			    
			    cCpo := STR(SD2->D2_DESPESA*100,10)			// Valor DESPESA
			    cLin := Stuff(cLin,115,10,cCpo)                         			    		    
	                                                                        
			    cCpo := STR(SF2->F2_VALFAT*100,10)			// Valor Total
			    cLin := Stuff(cLin,125,10,cCpo)                         	


	    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
			    //³ linha montada.                                                      ³
			    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        		If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
						Exit
			        Endif
			    Endif
		 DbSelectarea("SD2")
		 dbSkip()
		 enddo    
	 
	 	Else
		 msgbox("NF nao encontrada !")
		Endif
	    DbSelectarea("SF2")
	    dbSkip()
	Enddo
Else
	 msgbox("Nao existe NF com esta Data de Emissao !")
Endif

		    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		    //³ TRAILLER                                                         o  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

 
		    nTamLin := 134
		    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

		    cCpo := PADR("T",01)							//Identificador
		    cLin := Stuff(cLin,01,01,cCpo)    
		    cCpo := Strzero(cValTotNF*100,10)          // Cantu....
		    cLin := Stuff(cLin,02,10,cCpo)    
   		    cCpo := Space(121)                               // Espacos em branco 
		    cLin := Stuff(cLin,54,79,cCpo)    

			If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
	        	If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
			
			    Endif
			Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
Close(oGeraTxt)

Return 

Static Function AjustSX1()
xAlias := Alias()                                     		

dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}

cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Data Emissão       ?","","","mv_ch01","D",10,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
dbSelectArea(xAlias)
            
Return .T.
