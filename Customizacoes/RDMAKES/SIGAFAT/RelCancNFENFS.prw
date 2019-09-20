#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO4     บ Autor ณ AP6 IDE            บ Data ณ  10/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelCan()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         	:= "Relatorio de motivos de cancelamento."
Local cDesc2         	:= ""
Local cDesc3         	:= ""
Local cPict             := ""
Local titulo       		:= "CANCELAMENTOS"
Local nLin        		:= 80

Local Cabec1       		:= "cCabec1"
Local Cabec2       		:=  "DATA        NOTA/SER.   CLI/FOR   NOME CLIENTE/FORNECEDOR                 VALOR USUARIO              MOTIVO EXCLUSรO"
//    						"0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
                          //           1         2         3         4         5         6         7         8         9        10        11        12       14
Local imprime      		:= .T.
Local aOrd 				:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 132
Private tamanho         := "M"
Private nomeprog        := "RELCAN" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELCAN" 
Private cPerg			:= "RELCAN0000"
Private cString			:= " "        

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
/*
As informa็๕es a apresentar sใo:
- Data
- Numero da Nota
- Serie
- Cliente/Fornecedor
- Loja
- Valor
- Usuแrio

Os parametros devem ser:
- Data de
- Data At้
- Usuแrio
*/

Cabec1	:= "DATA INICIAL: "+DtoC(mv_par01)+" DATA FINAL: "+DtoC(mv_par02)

cSql := "SELECT ZT.* "
cSql += "FROM "+RetSqlName("SZT")+" ZT "
cSql += "WHERE ZT.D_E_L_E_T_ <> '*' "
cSql += "AND ZT_FILIAL = '"+xFilial("SZT")+"' "
cSql += "AND ZT.ZT_DTSOL BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
cSql += "AND ZT.ZT_USUARIO BETWEEN '  ' AND 'ZZZZZZ' "
cSql += "ORDER BY ZT.ZT_DTSOL, ZT.ZT_USUARIO "
TCQUERY cSql NEW ALIAS "TMPSZT"

DbSelectArea("TMPSZT")
SetRegua(RecCount())


TMPSZT->(DbGoTop())
While !TMPSZT->(EOF())
	Incproc()
    If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
       Exit
    Endif

	If nLin > 60
   	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 8
    Endif

    @nLin, 000 Psay StoD(TMPSZT->ZT_DTSOL)
    @nLIn, 012 Psay TMPSZT->ZT_NF
    @nLin, 020 Psay TMPSZT->ZT_SERIE
    @nLin, 024 Psay TMPSZT->ZT_FORNEC
    @nLin, 031 Psay TMPSZT->ZT_LOJA
    If AllTrim(Upper(TMPSZT->ZT_TPNF)) == "SAIDA"
		@nLin, 034 Psay SubStr(POSICIONE("SA1",1,xFilial("SA1")+TMPSZT->ZT_FORNEC+TMPSZT->ZT_LOJA,"A1_NOME"),1,30)
		@nLin, 066 Psay POSICIONE("SF2",1,xFilial("SF2")+TMPSZT->ZT_NF+TMPSZT->ZT_SERIE+TMPSZT->ZT_FORNEC+TMPSZT->ZT_LOJA,"F2_VALBRUT") Picture "@E 99,999,999.99"
    Else
		@nLin, 034 Psay SubStr(POSICIONE("SA2",1,xFilial("SA2")+TMPSZT->ZT_FORNEC+TMPSZT->ZT_LOJA,"A2_NOME"),1,30)
		@nLin, 066 Psay POSICIONE("SF1",1,xFilial("SF1")+TMPSZT->ZT_NF+TMPSZT->ZT_SERIE+TMPSZT->ZT_FORNEC+TMPSZT->ZT_LOJA,"F1_VALBRUT") Picture "@E 99,999,999.99"
    Endif
    @nLin, 080 Psay TMPSZT->ZT_USUARIO
    @nLin, 101 Psay Upper(TMPSZT->ZT_MOTEXCL)
    nLin += 1

    TMPSZT->(dbSkip())
EndDo
TMPSZT->(DbSelectArea("TMPSZT"))
TMPSZT->(DbCloseArea())

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
aAdd(aRegs,{cperg,"01","Data De            ?","","","mv_ch1","D",08,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cperg,"02","Data Ate           ?","","","mv_ch2","D",08,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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