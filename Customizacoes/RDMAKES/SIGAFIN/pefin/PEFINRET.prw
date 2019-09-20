#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"


User Function PEFINRET()

Private oLeTxt
Private cPerg := "PEFINRT" 
Private cFile := Space(70)
//ValidPerg()
//Pergunte(cPerg,.F.)  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Geracao de Arquivo Texto")
@ 002,010 TO 080,190
@ 010,018 Say " Este programa valida o retorno dos arquivos enviados ao SERASA."
@ 030,018 Say " Selecione o arquivo: " 
@ 040,018 Get cFile
@ 040,155 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "*.*" , "Selecione o arquivo de retorno'", 0,"",.T.))
@ 60,090 BMPBUTTON TYPE 01 ACTION Processa({|| OkLeTxt() })
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
//@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)


Activate Dialog oLeTxt Centered

Return    

/*
//@ 040,155 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "*.*" , "Selecione o arquivo de retorno'", 0,"",.T.,nOR( GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_RETDIRECTORY )))
Local aCli := {}
Private cFile := Space(100)
 
    
@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importa็ใo de Fornecedores"
// @ 005,005 TO 060,160
@ 010,010 Say "O arquivo DTC:" PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION Processa({|| ProcArq() }) 
@ 065,130 BMPBUTTON TYPE 2 ACTION Finaliza()
ACTIVATE DIALOG oDlg1 CENTER
    
Return()
*/

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
_aErros	:= {} // Dados dos titulos regeitados.

FT_FGOTOP()
If SubStr(Ft_Freadln(),126,1) <> 'R'
	MsgAlert("O arquivo "+Upper(AllTrim(cFile))+" ้ um arquivo de retorno invแlido! Verifique.","Atencao!")
	FT_FUSE()
	fClose(nHdl)
	Close(oLeTxt)	
    Return
Else
	FT_FSKIP()
Endif

While !FT_FEOF() .AND. SubStr(Ft_Freadln(),1,1) <> '9' 
	_cTitulo	:= SubStr(Ft_Freadln(),443,09) // Titulo
	_cParc		:= SubStr(Ft_Freadln(),452,03) // Parcela
	_cCli		:= SubStr(Ft_Freadln(),455,09) // Cliente
//	_cLoja		:= SubStr(Ft_Freadln(),461,02) // Loja
	_cLoja		:= "" 
	_cErros		:= SubStr(Ft_Freadln(),534,60) // Erros arquivo retorno
	_TpMov		:= SubStr(Ft_Freadln(),002,01) // I=Inclusao E=Exclusao

	cSql := "SELECT E1.E1_FILIAL, E1.E1_CLIENTE, E1.E1_LOJA, E1.E1_PREFIXO, E1.E1_NUM, "
	cSql += "E1.E1_PARCELA, E1.E1_TIPO " 
	cSql += "FROM "+RetSqlName("SE1")+" E1 "
	cSql += "WHERE E1.E1_FILIAL = '"+xFilial("SE1")+"' AND E1.D_E_L_E_T_ <> '*' "
	cSql += "AND E1.E1_NUM = '"+_cTitulo+"' AND E1.E1_PARCELA = '"+_cParc+"' "
//	cSql += "AND E1.E1_CLIENTE = '"+_cCli+"' AND E1.E1_LOJA = '"+_cLoja+"' "
	cSql += "AND E1.E1_CLIENTE = '"+_cCli+"' "
	cSql += "AND E1.E1_PEFINEX = ' ' "
	TcQuery cSql NEW ALIAS "TMPE1"
	TMPE1->(dbSelectArea("TMPE1"))
	TMPE1->(dbGoTop())		
	While !TMPE1->(Eof())
	    cChaveTMPE1 := TMPE1->E1_FILIAL+TMPE1->E1_CLIENTE+TMPE1->E1_LOJA+TMPE1->E1_PREFIXO+TMPE1->E1_NUM+;
	                   TMPE1->E1_PARCELA+TMPE1->E1_TIPO
	    cChaveSE1 := "SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(2))
	    SE1->(DbGotop())
	    If DbSeek(cChaveTMPE1)
		    While !SE1->(Eof()) .AND. cChaveTMPE1 == &cChaveSE1	    		
		    	If _TpMov == 'I'
				 	RecLock("SE1",.F.)
				 		If !Empty(_cErros)
					 		SE1->E1_PEFERRI := _cErros
				 		Else
				 			SE1->E1_PEFERRI := "INCLUSAO OK"
				 		Endif
				  	MsUnlock("SE1")
			   		aAdd(_aErros,{_cTitulo,_cParc,_cCli,_cLoja,SE1->E1_PEFERRI,_TpMov})				  	  		    		
				Else
				 	RecLock("SE1",.F.)
				 		If !Empty(_cErros)
					 		SE1->E1_PEFERRE := _cErros
				 		Else
				 			SE1->E1_PEFERRE := "EXCLUSAO OK"
				 		Endif
				  	MsUnlock("SE1")
			   		aAdd(_aErros,{_cTitulo,_cParc,_cCli,_cLoja,SE1->E1_PEFERRI,_TpMov})				  	 					
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
	FT_FSKIP()
End

FT_FUSE()
fClose(nHdl)
Close(oLeTxt)
U_PEFINREL(_aErros)

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