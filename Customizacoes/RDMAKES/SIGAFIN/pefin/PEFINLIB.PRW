#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บ Autor ณ Adriano Novachaelley Data ณ  29/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Gera็ใo de arquivo conforme layout do PEFIN-SERASA.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Inclusใo e Exclusใo de cadastros no SERASA.                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function PEFINLIB()

Private oLeTxt
Private cPerg := "PEFINLB"
Private cFile := Space(70)
//ValidPerg()
//Pergunte(cPerg,.F.)   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa liberar os titulos para re-envio ao PEFIN-SERASA." 
@ 040,018 Get cFile
@ 040,155 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "*.*" , "Selecione o arquivo de retorno'", 0,"",.T.))
@ 60,090 BMPBUTTON TYPE 01 ACTION Processa({|| OkLeTxt() })
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return
Static Function OkLeTxt

cSeqLin	:= StrZero(1,6)            

Private nHdl    := FT_FUSE(cFile)
If nHdl == -1
   MsgAlert("O arquivo " + cFile + " nao pode ser aberto! Verifique se o arquivo existe.","Atencao!")
   Return
Endif

Processa({|| RunCont() },"Processando...")
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณ RUNCONT  บ Autor ณ AP5 IDE            บ Data ณ  08/03/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunCont

FT_FGOTOP()
If !FT_FEOF()
	_cCodRem := SubStr(Ft_Freadln(),120,6)
	PutMv("MV_PEFINSQ",StrZero(Val(GetMV("MV_PEFINSQ"))-1,6))  
	// Libera tituloas enviados como inclusใo do SERASA
	cSql := "SELECT E1.E1_FILIAL, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_PREFIXO, E1.E1_NUM, "
	cSql += "E1.E1_PARCELA, E1.E1_TIPO " 
	cSql += "FROM "+RetSqlName("SE1")+" E1 "
	cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND E1.D_E_L_E_T_ <> '*' "
	cSql += "AND E1.E1_PEFININ = '"+_cCodRem+"' "
	cSql += "AND E1.E1_PEFINEX = ' ' "
	TcQuery cSql NEW ALIAS "TMPE1"
	TMPE1->(dbSelectArea("TMPE1"))
	TMPE1->(dbGoTop())		
	While !TMPE1->(Eof())
	    TMPcChave := TMPE1->E1_FILIAL+TMPE1->E1_CLIENTE+TMPE1->E1_LOJA+TMPE1->E1_PREFIXO+TMPE1->E1_NUM+;
	                   TMPE1->E1_PARCELA+TMPE1->E1_TIPO
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(2))
	    SE1->(DbGotop())    	
	    If DbSeek(TMPcChave)
		    While !SE1->(Eof()) .AND. TMPcChave == SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
		    	If SE1->E1_PEFININ == _cCodRem				 	
				 	RecLock("SE1",.F.)
				 		SE1->E1_PEFININ := " "
				 		If SubStr(SE1->E1_HIST,1,5) == "PEFIN"
				 			 		SE1->E1_HIST := SubStr(AllTrim(SE1->E1_HIST),6,25)	
				 		Endif 
				  	MsUnlock("SE1")  		    		
		    	Endif
		    	DbSelectArea("SE1")
		    	SE1->(DbSkip())
		    End
	    Endif
	    DbSelectArea("SE1")
		TMPE1->(DbSkip())
	End
	DbSelectArea("TMPE1")
	TMPE1->(DbCloseArea())
	// Libera titulos enviados como exclusใo do SERASA	
	cSql := "SELECT E1.E1_FILIAL, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_PREFIXO, E1.E1_NUM, "
	cSql += "E1.E1_PARCELA, E1.E1_TIPO " 
	cSql += "FROM "+RetSqlName("SE1")+" E1 "
	cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND E1.D_E_L_E_T_ <> '*' "
	cSql += "AND E1.E1_PEFINEX = '"+_cCodRem+"' "
	TcQuery cSql NEW ALIAS "TMPSE1"
	TMPSE1->(dbSelectArea("TMPSE1"))
	TMPSE1->(dbGoTop())		
	While !TMPSE1->(Eof())
	    TMPcChave := TMPSE1->E1_FILIAL+TMPSE1->E1_CLIENTE+TMPSE1->E1_LOJA+TMPSE1->E1_PREFIXO+TMPSE1->E1_NUM+;
	                   TMPSE1->E1_PARCELA+TMPSE1->E1_TIPO
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(2))
	    SE1->(DbGotop())
	    If DbSeek(TMPcChave)
		    While !SE1->(Eof()) .AND. TMPcChave == SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO
		    	If SE1->E1_PEFINEX == _cCodRem
				 	RecLock("SE1",.F.)
				 		SE1->E1_PEFINEX := " "
				  	MsUnlock("SE1")  		    		
		    	Endif
		    	DbSelectArea("SE1")
		    	SE1->(DbSkip())
		    End
	    Endif
	    DbSelectArea("SE1")
		TMPSE1->(DbSkip())
	End
	DbSelectArea("TMPSE1")
	TMPSE1->(DbCloseArea())
Endif

FT_FUSE()
fClose(nHdl)
Close(oLeTxt)    

// U_geraRel()

Return
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)                                      
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Local do arquivo    ","","","mv_ch1","C",30,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Lista		        ","","","mv_ch4","N",01,0,1,"C","naovazio","mv_par04","TODOS","TODOS","TODOS","","","RPA","RPA","RPA","","","","","","","","",""})

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

User Function geraRel()
      
Local cStatus 	:= SPACE(6)

oProcess := TWFProcess():New("WFRELAR","Registro de limpeza do arquivo do PEFIN")
oProcess:NewTask(cStatus,"\workflow\wfpefinlib.htm")
oProcess:cSubject := ("Limpeza do Arquivo do PEFIN")      
oProcess:cTo  		:= UsrRetMail(__cUserID) //"gpoyer@gmail.com"  
oProcess:cCC			:= AllTrim(SuperGetMV("MV_X_USRPE", ,'gpoyer@gmail.com'))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณMonta o workflow            ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oHtml:= oProcess:oHTML
oHtml:ValByName("DATA"  , DtoC(DDATABASE))
oHtml:ValByName("ARQUI" , cFile)
	
oProcess:Start()	
	

Return                                                             