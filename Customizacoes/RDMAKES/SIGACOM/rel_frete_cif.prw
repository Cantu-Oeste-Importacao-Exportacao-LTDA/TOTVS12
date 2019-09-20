#INCLUDE "rwmake.ch"
#Include "Topconn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelFrete  บ Autor ณ AP6 IDE            บ Data ณ  11/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Listagem de notas fiscais de entrada com frete CIF.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelFrete()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de notas fiscais com frete CIF."
Local cDesc3         	:= ""
Local cPict          	:= ""
Local titulo       		:= "NOTAS FISCAIS C/ FRETE CIF"
Local nLin        	 	:= 80

Local Cabec1       		:= "cCabec1"
Local Cabec2       		:=  "NF/SERIE  CODIGO    LOJA NOME FORNECEDOR                               TOTAL NF   TOTAL FRETE"
//    						"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
                          //           1         2         3         4         5         6         7         8         9        10        11        12       14
Local imprime      		:= .T.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 132
Private tamanho         := "M"
Private nomeprog        := "RELFRETE" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELFRETE" 
Private cString 		:= ""
Private cPerg			:= "RELFRETE"   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1() 
Pergunte(cPerg,.f.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)


RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

Cabec1	:= "EMISSรO INICIAL: "+DtoC(mv_par03)+" EMISSรO FINAL: "+DtoC(mv_par04)+" DIGITAวรO INICIAL: "+DtoC(mv_par05)+" DIGITAวรO FINAL: "+;
           DtoC(mv_par06)

cSql := "SELECT D1.D1_FILIAL, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_DOC, D1.D1_SERIE, D1.D1_EMISSAO, D1.D1_DTDIGIT, D1.D1_PEDIDO, D1.D1_ITEMPC, D1_TOTAL "
cSql += "FROM "+RetSqlName("SD1")+" D1 "
cSql += "WHERE D1.D_E_L_E_T_ <> '*' "
cSql += "AND D1.D1_FILIAL = '"+xFilial("SD1")+"' AND D1.D1_TIPO = 'N' "
cSql += "AND D1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cSql += "AND D1.D1_EMISSAO BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
cSql += "AND D1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par05)+"' AND '"+DtoS(mv_par06)+"' "
cSql += "AND D1.D1_PEDIDO <> ' ' "
cSql += "ORDER BY D1.D1_FILIAL, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_DOC, D1.D1_SERIE "
TCQUERY cSql NEW ALIAS "TMPSD1"

TMPSD1->(DbSelectArea("TMPSD1"))
SetRegua(RecCount())
TMPSD1->(DbGoTop())

While !TMPSD1->(Eof())
	
	_cFilial	:= TMPSD1->D1_FILIAL
	_cFornec	:= TMPSD1->D1_FORNECE
	_cLoja		:= TMPSD1->D1_LOJA
	_cNf		:= TMPSD1->D1_DOC
	_cSerie		:= TMPSD1->D1_SERIE 
	_nValFr		:= 0	
	_nValNf     := 0 
	
	lCif	:= .F.
	// Verifica็ใo se o frete ้ CIF.
	While !TMPSD1->(Eof()) .AND. TMPSD1->D1_FILIAL+TMPSD1->D1_FORNECE+TMPSD1->D1_LOJA+TMPSD1->D1_DOC+TMPSD1->D1_SERIE == ;
								_cFilial+_cFornec+_cLoja+_cNf+_cSerie
		SC7->(DbSelectArea("SC7"))
		SC7->(DbSetOrder(3))
		If SC7->(DbSeek(xFilial("SC7")+TMPSD1->D1_FORNECE+TMPSD1->D1_LOJA+TMPSD1->D1_PEDIDO))
			If SC7->C7_TPFRETE == 'C' .AND. !lCif
				lCif := .T.
			Endif
		Endif
		_nValNf += TMPSD1->D1_TOTAL
		TMPSD1->(DbSelectArea("TMPSD1"))
    	TMPSD1->(dbSkip())
	End
	// Se o frete for CIF verificar os conhecimentos de fretes amarrados as notas fiscais.
	If lCif
		SF8->(DbSelectArea("SF8"))
		SF8->(DbSetOrder(2))
		If SF8->(DbSeek(_cFilial+_cNf+_cSerie+_cFornec+_cLoja))
			While !SF8->(Eof()) .And. _cFilial+_cNf+_cSerie+_cFornec+_cLoja == SF8->F8_FILIAL+SF8->F8_NFORIG+SF8->F8_SERORIG+SF8->F8_FORNECE+SF8->F8_LOJA
				cSql := "SELECT SUM(D1.D1_TOTAL) TOTAL "
				cSql += "FROM "+RetSqlName("SD1")+" D1 "
				cSql += "WHERE D1.D_E_L_E_T_ <> '*' "
				cSql += "AND D1.D1_FILIAL = '"+_cFilial+"' AND D1.D1_TIPO = 'C' "
				cSql += "AND D1.D1_DOC = '"+SF8->F8_NFDIFRE+"' AND D1.D1_SERIE = '"+SF8->F8_SEDIFRE+"' "
				cSql += "AND D1.D1_FORNECE = '"+SF8->F8_TRANSP+"'  AND D1.D1_LOJA = '"+SF8->F8_LOJTRAN+"' "
				TCQUERY cSql NEW ALIAS "TMPFRETE"
				TMPFRETE->(DbSelectArea("TMPFRETE"))
					_nValFr += TMPFRETE->TOTAL	
				TMPFRETE->(DbCloseArea())
		
				SF8->(DbSelectArea("SF8"))				
				SF8->(DbSkip())
			End
		Endif
	
		If lAbortPrint
	      	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	    	Exit
	   	Endif
	
	    If nLin > 60
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 9
	    Endif
		@nLin, 000 PSay _cNf
		@nLin, 007 Psay _cSerie
		@nLin, 010 Psay _cFornec
		@nLin, 020 Psay _cLoja
		@nLin, 025 Psay SubStr(POSICIONE("SA2",1,xFilial("SA2")+_cFornec+_cLoja,"A2_NOME"),1,40)
		@nLin, 067 Psay _nValNf Picture "@E 9,999,999.99"
		@nLin, 081 Psay _nValFr Picture "@E 9,999,999.99"
		nLin += 1

	Endif
	Loop
EndDo
TMPSD1->(DbSelectArea("TMPSD1"))
TMPSD1->(DbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function AjustaSX1()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cperg,"01","Fornecedor De      ?","","","mv_ch1","C",09,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"02","Fornecedor Ate     ?","","","mv_ch2","C",09,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"03","Emissao De         ?","","","mv_ch3","D",08,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"04","Emissao Ate        ?","","","mv_ch4","D",08,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"05","Digitacao De       ?","","","mv_ch5","D",08,0,0,"G",""        ,"mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"06","Digitacao Ate      ?","","","mv_ch6","D",08,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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