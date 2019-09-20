#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ          บ Autor ณ Adriano Novachaelley Data ณ  18/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Limpa FLAG dos titulos enviados a cobran็a externa.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Limpa FLAG dos titulos enviados a cobran็a externa.        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
              
User Function CobElib()
	
Private oLeRem
Private cPerg := "CobElib"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

ValidPerg()
Pergunte(cPerg,.F.)

@ 200,001 TO 380,380 DIALOG oLeRem TITLE OemToAnsi("")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa libera os titulos para re-envio เ COBRANวA EXTERNA."

@ 60,090 BMPBUTTON TYPE 01 ACTION OkProc()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oLeRem)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeRem Centered

Return
Static Function OkProc

If Len(AllTrim(mv_par01)) <> 6
   MsgAlert("Parametro de sequencia invแlido.","Atencao!")
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
Local nReg	:= 0
cSql := "SELECT E1.E1_FILIAL, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_PREFIXO, E1.E1_NUM, "
cSql += "E1.E1_PARCELA, E1.E1_TIPO " 
cSql += "FROM "+RetSqlName("SE1")+" E1 "
cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND E1.D_E_L_E_T_ <> '*' "
cSql += "AND E1.E1_SQCOBEX = '"+mv_par01+"' "
cSql += "AND E1.E1_SALDO > 0 "
TcQuery cSql NEW ALIAS "TMPE1"
TMPE1->(dbSelectArea("TMPE1"))
TMPE1->(dbGoTop())		
While !TMPE1->(Eof())
	nReg += 1
    cChaveTMPE1 := TMPE1->E1_FILIAL+TMPE1->E1_CLIENTE+TMPE1->E1_LOJA+TMPE1->E1_PREFIXO+TMPE1->E1_NUM+;
                   TMPE1->E1_PARCELA+TMPE1->E1_TIPO
    DbSelectArea("SE1")
    SE1->(DbSetOrder(2))
    SE1->(DbGotop())
    If DbSeek(cChaveTMPE1)
	 	RecLock("SE1",.F.)
	 		SE1->E1_SQCOBEX := " "  
	 		
	 		If SubStr(SE1->E1_HIST,1,6) == "GLOBAL"
 			 		SE1->E1_HIST := SubStr(AllTrim(SE1->E1_HIST),7,25)	 
    		Elseif  SubStr(SE1->E1_HIST,1,3) == "CVV"
                    SE1->E1_HIST := SubStr(AllTrim(SE1->E1_HIST),4,25)     	 			 		 
            Elseif  SubStr(SE1->E1_HIST,1,2) == "BS"
                    SE1->E1_HIST := SubStr(AllTrim(SE1->E1_HIST),3,25)     	 			 		 
            Elseif  SubStr(SE1->E1_HIST,1,3) == "VITTI"
                    SE1->E1_HIST := SubStr(AllTrim(SE1->E1_HIST),6,25)     	 			 		                
	 		Endif    
	 		//Guilherme, solicitado pelo Joใo para que quando for limpados os registros, o mesmo seja voltado pra situa็ใo de carteira. 19/08/2013
	 		SE1->E1_SITUACA := '0'
	 		
	  	MsUnlock("SE1")  		    		
    	DbSelectArea("SE1")
    	SE1->(DbSkip())
    Endif
    DbSelectArea("TMPE1")
	TMPE1->(DbSkip())
End


DbSelectArea("TMPE1")
TMPE1->(DbCloseArea())

If 	nReg > 0
	MsgAlert("Total de registros liberados: "+Str(nReg))
Else
	MsgAlert("Nenhum registro encontrato.")
Endif
Close(oLeRem)

Return
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Codigo da Remessa   ","","","mv_ch1","C",6,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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