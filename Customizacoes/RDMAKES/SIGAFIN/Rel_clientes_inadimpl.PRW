#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRelCliIn  บ Autor ณ Adriano            บ Data ณ  15/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Relatorio de clientes inadimplentes por periodo.           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu  s                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function RelCliIn()


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de clientes inadimplentes por periodo."
Local cDesc3         := ""
Local cPict          := ""
Local titulo       	:= "Clientes Inadimplentes"
Local nLin         := 80

Local Cabec1       := "Cabec1"
Local Cabec2       := "Codigo     Loja Nome Cliente                               Dt. Cad.       Saldo Devedor"    
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 132
Private tamanho          := "M"
Private nomeprog         := "RelCliIn"
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RelCliIn" 
Private cPerg		:= "RELCLIIN"
Private cString := ""   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1()
Pergunte(cPerg,.F.)

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  15/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

cSql := "SELECT A1.A1_COD, A1.A1_LOJA, A1.A1_NOME, A1.A1_NREDUZ, A1.A1_DTCADAS, "
cSql += "(SELECT SUM(E1.E1_SALDO) FROM "+RetSqlName("SE1")+" E1 "
cSql += "WHERE  E1.D_E_L_E_T_ <> '*' "
If mv_par05 <> 1
	cSql += "AND E1.E1_FILIAL = '"+xFilial("SE1")+"'  "
Endif
cSql += "AND E1.E1_CLIENTE = A1.A1_COD AND E1.E1_LOJA = A1.A1_LOJA "
cSql += "AND E1.E1_VENCREA <= '"+DtoS(Date()-1)+"' ) E1_SALDO "
cSql += "FROM "+RetSqlName("SA1")+" A1 "
cSql += "WHERE A1.D_E_L_E_T_ <> '*' "
cSql += "AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
cSql += "AND A1.A1_COD BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cSql += "AND A1.A1_DTCADAS BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+"' "
cSql += "ORDER BY A1.A1_DTCADAS, A1.A1_COD, A1.A1_LOJA "
cSql := ChangeQuery(cSql)
TcQuery cSql NEW ALIAS "TMPA1"
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbGotop())


SetRegua(RecCount())
TMPA1->(dbGoTop())
cMes	:= SubStr(TMPA1->A1_DTCADAS,1,6)
nTotMes	:= 0
While !TMPA1->(EOF())

    If TMPA1->E1_SALDO <= 0
    	TMPA1->(DbSkip())
    	Loop
    Endif
    If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
       Exit
    Endif

    If nLin > 60
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 9
    Endif
	If 	cMes <> SubStr(TMPA1->A1_DTCADAS,1,6)
		@nLin, 046 Psay "Total Cadastrados M๊s"
		@nLin, 071 Psay nTotMes Picture PesqPict("SE1","E1_SALDO",16)
		nLin += 2
		nTotMes	:= 0
	Endif
	
    @nLin, 000 Psay TMPA1->A1_COD
    @nLin, 011 Psay TMPA1->A1_LOJA
    @nLin, 016 Psay TMPA1->A1_NOME
    @nLin, 059 Psay StoD(TMPA1->A1_DTCADAS)
    @nLin, 071 Psay TMPA1->E1_SALDO Picture PesqPict("SE1","E1_SALDO",16)
	nTotMes	+= TMPA1->E1_SALDO
	nLin += 1
	cMes	:= SubStr(TMPA1->A1_DTCADAS,1,6)
	TMPA1->(dbSkip())
EndDo
If 	nTotMes > 0 
	@nLin, 046 Psay "Total Cadastrados M๊s"
	@nLin, 071 Psay nTotMes Picture PesqPict("SE1","E1_SALDO",16)
	nLin += 2
	nTotMes	:= 0
Endif
TMPA1->(DbSelectArea("TMPA1"))
TMPA1->(DbCloseArea())


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function AjustaSX1()
xAlias := Alias()                                     		

dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Cliente Inicial    ?","","","mv_ch1","C",09,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"02","Cliente Final      ?","","","mv_ch2","C",09,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1","",""})
aAdd(aRegs,{cPerg,"03","Dt Cad. Inicial    ?","","","mv_ch3","D",10,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Dt Cad. Final      ?","","","mv_ch4","D",10,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Filial             ?","","","mv_ch5","N",01,0,1,"C","","mv_par05","Atual","Atual","Atual","","","Todas","Todas","Todas","","","","","","","","","","","","","","",""," ","","","","","","","","",""})

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