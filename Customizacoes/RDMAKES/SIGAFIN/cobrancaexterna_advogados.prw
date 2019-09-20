#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
???Programa  ? CobrExt   ? Autor ? Adriano Novachaelley Data ?  29/03/10  ???
????????????????????????????????????????????????????????????????????????????
???Descricao ? Geracao de arquivo conforme layout da GLOBAL COBRANÇAS.   ???
???          ?                                                           ???
????????????????????????????????????????????????????????????????????????????
???Uso       ? Bordero de envio Global Cobranças.                        ???
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
????????????????????????????????????????????????????????????????????????????
/*/
// --------------------------------------------------------------------------------------
// Campos especificos:
// SA1->A1_X_COBEX -> INDICA SE A COBRANÇA DO CLIENTE SERÁ FEITA POR UMA EMPRESA EXTERNA.
// TIPO:C TAMANHO:1 OPÇÕES:S=SIM;N=NAO INI.PADRAO:'N'
// --------------------------------------------------------------------------------------
// SE1->E1_SQCOBEX -> GRAVA SEQUENCIA DO BORDERO DAS COBRANÇAS EXTERNAS.
// TIPO:C TAMANHO:6 
// --------------------------------------------------------------------------------------
// Parametros especificos:
// MV_COBEXSQ -> SEQUENCIAL DO BORDERO PARA COBRANÇAS EXTERNAS.  
// TIPO:C EX.:000001
// --------------------------------------------------------------------------------------
// MV_COBEXDT -> Envia titulos para cobranca externa vencidos a mais de.
// TIPO:N EX.:30
// --------------------------------------------------------------------------------------

User Function CobrExt()

Private oGeraTxt  
Private cPerg := "CobrExt"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ValidPerg()
Pergunte(cPerg,.F.)

@ 200,001 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa ira gerar um arquivo texto, conforme layout para  "
@ 018,018 Say " COBRANÇAS EXTERNAS."
@ 60,090 BMPBUTTON TYPE 01 ACTION OkGeraTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

Static Function OkGeraTxt
  
Private nSeqRem	:= StrZero(Val(GetMV("MV_COBEXSQ")),6)
Private nHdl    := fCreate(AllTrim(mv_par01)+"CE"+nSeqRem+".txt")

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+mv_par01+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

Processa({|| RunCont() },"Processando...")
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RUNCONT ºAutor  ³  Microsiga           º Data ³  08/03/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função auxiliar chamada pela PROCESSA. A função PROCESSA 	º±±
±±º          ³ monta a janela com a régua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RunCont

Local nTamLin, cLin, cCpo
Local nDias		:= 0
Local nSeqReg	:= 0 
Local nValTit	:= 0
Local cCampo	:= "SE1->E1_SQCOBEX"
Local cSitua 	:= Alltrim(mv_par07)
Local cTipos	:= Alltrim(mv_par08)
Local cRisco 	:= Alltrim(mv_par09)

nDias	:= GetMv("MV_COBEXDT")      

// Monta string com as situações do filtro
If !Empty(Alltrim(cSitua))
	lInvalido := .F.
	cSituaAux := "('"
	For i:=1 to Len(cSitua) 
		If !lInvalido
			If (Substr(cSitua,i,1) != ',' .AND. Substr(cSitua,i,1) != ';')
				cSituaAux += Substr(cSitua,i,1)
			ElseIf (Substr(cSitua,i,1) == ',' .OR. Substr(cSitua,i,1) == ';')
						cSituaAux +=	"','"	     	 
			    Else
			    	lInvalido := .T.  			 		
					EndIf 								
		EndIf			
	Next i  
	
	If lInvalido
		cSituaAux := ' '			
	Else	               
		cSituaAux += "')"
	EndIf
Else
	cSituaAux := " "		                 
EndIf 

// Monta string com os tipos do filtro
If !Empty(Alltrim(cTipos))
	lInvalido := .F.
	cTipoAux := "('"
	For i:=1 to Len(cTipos)
		If !lInvalido
			If (Substr(cTipos,i,1) != ',' .AND. Substr(cTipos,i,1) != ';')  .AND. !(Substr(cTipos,i,1) $ "1,2,3,4,5,6,7,8,9,0")
				cTipoAux += Substr(cTipos,i,1)
			ElseIf (Substr(cTipos,i,1) == ',' .OR. Substr(cTipos,i,1) == ';')
			    	cTipoAux +=	"','"	     	 
					Else
			    	lInvalido := .T.  			 		
					EndiF 				 				
		EndIF					
	Next i  
	
	If lInvalido
		cTipoAux := ' '			
	Else	               
		cTipoAux += "')"
	EndIf
Else
	cTipoAux := " "			                 
EndIf 

// Monta string com os Riscos do filtro
If !Empty(Alltrim(cRisco))
	lInvalido := .F.
	cRiscoAux := "('"
	For i:=1 to Len(cRisco)
		If !lInvalido
			If (Substr(cRisco,i,1) != ',' .AND. Substr(cRisco,i,1) != ';')  .AND. !(Substr(cRisco,i,1) $ "1,2,3,4,5,6,7,8,9,0")
				cRiscoAux += Substr(cRisco,i,1)
			ElseIf (Substr(cRisco,i,1) == ',' .OR. Substr(cRisco,i,1) == ';')
						cRiscoAux +=	"','"	     	 
			   	Else
			    	lInvalido := .T.  			 		
					EndiF 										
		EndIf					
	Next i  
	
	If lInvalido
		cRiscoAux := ' '			
	Else	               
		cRiscoAux += "')"
	EndIf	                 
Else
	cRiscoAux := " "	
EndIf

cSql := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_CGC, SA1.A1_NOME, SA1.A1_END, SA1.A1_BAIRRO, "
cSql += "SA1.A1_MUN, SA1.A1_EST, SA1.A1_CEP, SA1.A1_DDD, SA1.A1_TEL, "
cSQl += "SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_TIPO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_EMISSAO, "
cSql += "SE1.E1_VENCREA, SE1.E1_VALOR, SE1.E1_SALDO, SE1.E1_VEND1, SE1.E1_ACRESC "
cSql += "FROM "+RetSqlName("SA1")+" SA1, "+RetSqlName("SE1")+" SE1 "
cSql += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SE1.E1_FILIAL = '"+xFilial("SE1")+"' "
cSql += "AND SA1.D_E_L_E_T_ <> '*' AND SE1.D_E_L_E_T_ <> '*' "
cSql += "AND SA1.A1_COD = SE1.E1_CLIENTE AND SA1.A1_LOJA = SE1.E1_LOJA "
cSql += "AND SA1.A1_X_COBEX <> 'N' "  // Nao envia cliente para o Global Cobranças.

//Verifica se foi filtrado alguns Riscos específicos ou nao Chamado do Joao Nº 8020
If !Empty(Alltrim(cRiscoAux)) 
	cSql += "AND SA1.A1_RISCO IN "+cRiscoAux+" "	
EndIf

cSql += "AND SE1.E1_VENCREA BETWEEN '"+DtoS(mv_par02)+"' AND '"+DtoS(mv_par03)+"' "
cSql += "AND SE1.E1_PREFIXO BETWEEN '"+mv_par04+"' AND '"+mv_par05+"' "
cSql += "AND SE1.E1_CLVLCR BETWEEN '"+mv_par10+"' AND '"+mv_par11+"' "
cSql += "AND SE1.E1_SALDO > 0 " 
cSql += "AND SE1.E1_VENCREA < '"+DtoS(dDataBase-nDias)+"' "
cSql += "AND SE1.E1_SQCOBEX = ' ' "

//Verifica se foi filtrado alguns tipos específicos ou é o padrão Chamado do Joao Nº 8020
If Empty(Alltrim(cTipoAux)) 
	cSql += "AND SE1.E1_TIPO IN ('NF ','DP','FT', 'CH')  " //Guilherme 08/07/11 - Incluir DP, FT, CH 
Else
 	cSql += "AND SE1.E1_TIPO IN "+cTipoAux+" " 
EndIf	

//Verifica se foi filtrado algumas situações específicas ou é o padrão Chamado do Joao Nº 8020	
If Empty(Alltrim(cSituaAux))
	cSql += "AND SE1.E1_SITUACA <> '5' "
Else
	cSql += "AND SE1.E1_SITUACA IN "+cSituaAux+" "
EndIf	

cSql += "ORDER BY SA1.A1_CGC
 
TcQuery cSql NEW ALIAS "TMPE1"  
Memowrite("C:\global.txt",cSql)

TMPE1->(dbSelectArea("TMPE1"))
TMPE1->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ_
//³X2_Unico SE1                                                      ³
//³E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO                    ³
//³Indice orden 2                                                    ³
//³E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ_

ProcRegua(RecCount()) 
While !TMPE1->(EOF())

    IncProc()
	cLin 	:= ""
	cLin 	+= StrZero(Val(SM0->M0_CGC),14)  				// CGC EMPRESA
	cLin 	+= SubStr(SM0->M0_NOMECOM+Space(50),1,50) 	  	// NOME EMPRESA
	cLin 	+= StrZero(Val(TMPE1->A1_CGC),14)  				// CGC DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_NOME+Space(50),1,50)		// NOME DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_END+Space(50),1,50)			// ENDERECO DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_BAIRRO+Space(20),1,20)		// BAIRRO DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_MUN+Space(20),1,20)			// CIDADE DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_EST+Space(2),1,2)			// ESTADO DEVEDOR
	cLin 	+= StrZero(Val(TMPE1->A1_CEP),8)	        	// CEP DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_DDD+Space(3),1,3)			// DDD DEVEDOR
	cLin 	+= SubStr(TMPE1->A1_TEL+Space(8),1,8) 			// TELEFONE DEVEDOR
	cLin 	+= SubStr(TMPE1->E1_TIPO+Space(2),1,2)			// ESPECIE DO TITULO
	cLin 	+= SubStr(TMPE1->E1_NUM+Space(12),1,12)			// NUMERO DO TITULO
	Do Case
		Case Len(AllTrim(TMPE1->E1_PARCELA)) = 0
			cLin 	+= '00'										// PARCELA DO TITULO		
		Case Len(AllTrim(TMPE1->E1_PARCELA)) = 1
			cLin 	+= "0"+AllTrim(TMPE1->E1_PARCELA)			// PARCELA DO TITULO						
		Case Len(AllTrim(TMPE1->E1_PARCELA)) = 2
			cLin 	+= AllTrim(TMPE1->E1_PARCELA)				// PARCELA DO TITULO						
		Case Len(AllTrim(TMPE1->E1_PARCELA)) = 3
			cLin 	+= SubStr(TMPE1->E1_PARCELA,2,2)			// PARCELA DO TITULO				
	End Case
	cLin 	+= Substr(TMPE1->E1_EMISSAO,7,2)+"/"+Substr(TMPE1->E1_EMISSAO,5,2)+"/"+Substr(TMPE1->E1_EMISSAO,1,4)
	cLin 	+= Substr(TMPE1->E1_VENCREA,7,2)+"/"+Substr(TMPE1->E1_VENCREA,5,2)+"/"+Substr(TMPE1->E1_VENCREA,1,4)	
	
	 
	Do Case 
	    Case (AllTrim(TMPE1->E1_TIPO)) == 'DP' 
        	cLin	+= Strzero(TMPE1->E1_SALDO + TMPE1->E1_ACRESC ,15,2)				// VALOR DO TITULO 
        Case (AllTrim(TMPE1->E1_TIPO)) != 'DP' 
        	cLin	+= Strzero(TMPE1->E1_SALDO,15,2)				// VALOR DO TITULO 		    
	End Case
	
	

	cLin	+= StrZero(0,15,2)								// VALOR DO PROTESTO DO TITULO (CUSTAS CARTORARIAS, ETC.)
	cLin	+= Space(255)									// COMENTARIO/OBSERVAÇÃO PARA O TITULO
	SA3->(DbSelectArea("SA3"))
	SA3->(DbSetOrder(1))
	If SA3->(DbSeek(xFilial("SA3")+TMPE1->E1_VEND1))
		cLin += SubStr(SA3->A3_NOME+Space(40),1,40) 		// NOME DO VENDEDOR	
		cLin += StrZero(Val(SA3->A3_DDDTEL),3)				// DDD VENDEDOR 
		cLin += StrZero(Val(SA3->A3_TEL),1,9)				// TELEFONE DO VENDEDOR
	Else
		cLin += Space(40)									// NOME DO VENDEDOR
		cLin += Space(12)									// TELEVONE DO VENDEDOR
	Endif
	
	clin 	+= cEOL

    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
            Exit
        Endif
    Endif
	cChaveE1 := TMPE1->E1_FILIAL+TMPE1->A1_COD+TMPE1->A1_LOJA+TMPE1->E1_PREFIXO+TMPE1->E1_NUM+;
    			TMPE1->E1_PARCELA+TMPE1->E1_TIPO
    DbSelectArea("SE1")
    SE1->(DbSetOrder(2))
    SE1->(DbGotop())
    If DbSeek(cChaveE1)
	 	RecLock("SE1",.F.)
	 		&cCampo := nSeqRem             
	 		
	 		If     MV_PAR06 == 1
	 		    SE1->E1_HIST := Iif("GLOBAL" $ SE1->E1_HIST,SE1->E1_HIST,"GLOBAL"+AllTrim(SE1->E1_HIST))
	 		ElseIf MV_PAR06 == 2
	 			SE1->E1_HIST := Iif("CVV" $ SE1->E1_HIST,SE1->E1_HIST,"CVV"+AllTrim(SE1->E1_HIST))	 
	 		ElseIf MV_PAR06 == 3
	 			SE1->E1_HIST := Iif("BS" $ SE1->E1_HIST,SE1->E1_HIST,"BS"+AllTrim(SE1->E1_HIST))	 
	 		ElseIf MV_PAR06 == 4
	 			SE1->E1_HIST := Iif("VITTI" $ SE1->E1_HIST,SE1->E1_HIST,"VITTI"+AllTrim(SE1->E1_HIST))	 		
	 		EndIf                                                           
	 		
	 		SE1->E1_SITUACA := 'A'
	 		
	  	MsUnlock("SE1")    
    Endif
    nSeqReg += 1 					// Sequencial de registros
    nValTit += TMPE1->E1_SALDO
    
	TMPE1->(DbSelectArea("TMPE1"))
    TMPE1->(dbSkip())
EndDo
TMPE1->(DbSelectArea("TMPE1"))
TMPE1->(DbCloseArea())

If nSeqReg > 0
	MsgAlert("Total de registros exportados: "+Str(nSeqReg)+". Valor Total de R$ "+Transform(nValTit, "@E 99,999,999.99"))
	PutMv("MV_COBEXSQ",StrZero(Val(GetMV("MV_COBEXSQ"))+1,6))  	
Else
	MsgAlert("Nenhum registro encontrado.")
Endif

fClose(nHdl)
Close(oGeraTxt)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função de validação do grupo de perguntas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Local do Arquivo      ?","","","mv_ch1","C",50,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Vencimento inicial     ","","","mv_ch2","D",08,0,0,"G","        ","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"03","Vencimento final       ","","","mv_ch3","D",08,0,0,"G","NaoVazio","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Prefixo Inicial        ","","","mv_ch4","C",03,0,0,"C","        ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Prefixo Final          ","","","mv_ch5","C",03,0,0,"C","NaoVazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"06","Agente Cobrança        ","","","mv_ch6","N",01,0,1,"C","        ","mv_par06","Global","Global","Blobal","CVV","CVV","CVV","BS","BS","BS","VITTI","VITTI","VITTI"})
aAdd(aRegs,{cPerg,"06","Agente Cobranca        ","","","mv_ch6","N",01,0,1,"C","        ","mv_par06","Global","Global","Global","","","CVV","CVV","CVV","","","BS","BS","BS","","","VITTI","VITTI","VITTI","",""})
aAdd(aRegs,{cPerg,"07","Situações Tit          ","","","mv_ch7","C",35,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Tipos Titulos          ","","","mv_ch8","C",35,0,0,"G","        ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Riscos Client          ","","","mv_ch9","C",25,0,0,"G","        ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Segmento De            ","","","mv_chA","C",09,0,0,"C","        ","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","CTH"})
aAdd(aRegs,{cPerg,"11","Segmento Até           ","","","mv_chB","C",09,0,0,"C","NaoVazio","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","CTH"})

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