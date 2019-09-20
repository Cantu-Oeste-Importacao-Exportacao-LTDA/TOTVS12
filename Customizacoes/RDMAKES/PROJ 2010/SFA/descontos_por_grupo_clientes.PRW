#Include "rwmake.CH"
#Include "TopConn.CH"

User Function RelZZ5()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "Cliente x Tabela de Preço x Vendedor"
Local cPict         := ""
Local titulo       	:= "Cliente x Tabela de Preço x Vendedor"
Local nLin         	:= 80

Local Cabec1       	:= "Codigo    Loja  Nome Cliente                              Valor Minimo   Desc."
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RELZZ5" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RELZZ5" 
Private cString 	:= ""
Private cPerg		:= "RELZZ5"   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

_cCliIni	:= mv_par01
_cCliFin	:= mv_par02
_cVenIni	:= mv_par03
_cVenFin	:= mv_par04

cSql := "SELECT ZZ5.ZZ5_CLIENT,ZZ5.ZZ5_LOJA, SA1.A1_NOME,ZZ5.ZZ5_VEND, SA3.A3_NOME,ZZ5.ZZ5_TABELA, SA1.A1_GRPVEN "
cSql += "FROM "+RetSqlName("ZZ5")+" ZZ5, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3 "
cSql += "WHERE SA1.D_E_L_E_T_ <> '*' AND ZZ5.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' "
cSql += "AND SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND SA3.A3_FILIAL = '"+xFilial("SA3")+"' "
cSql += "AND ZZ5.ZZ5_FILIAL = '"+xFilial("ZZ5")+"' "
cSql += "AND ZZ5.ZZ5_CLIENT BETWEEN '"+_cCliIni+"' AND '"+_cCliFin+"' " 
cSql += "AND ZZ5.ZZ5_VEND BETWEEN '"+_cVenIni+"' AND '"+_cVenFin+"' "
cSql += "AND SA1.A1_COD = ZZ5.ZZ5_CLIENT AND SA1.A1_LOJA = ZZ5.ZZ5_LOJA "
cSql += "AND SA3.A3_COD = ZZ5.ZZ5_VEND " 
cSql += "ORDER BY ZZ5.ZZ5_VEND, ZZ5.ZZ5_CLIENT, ZZ5.ZZ5_LOJA"
_cOrd	:= "TMPZZ5->ZZ5_VEND"
cSql := ChangeQuery(cSql)
TcQuery cSql NEW ALIAS "TMPZZ5"
DbSelectArea("TMPZZ5")            
SetRegua(RecCount())

TMPZZ5->(DbGotop())
_cChave	:= &_cOrd
If !TMPZZ5->(EOF())
    If nLin > 60
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 9
    Endif
	@nLin, 000 Psay "Vendedor: "
    @nLin,012 Psay TMPZZ5->ZZ5_VEND
    @nLin,023 Psay TMPZZ5->A3_NOME
	nLin += 2
End
While !TMPZZ5->(EOF())

    If lAbortPrint
       @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
       Exit
    Endif


    If nLin > 60
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 9
    Endif
	If _cChave	<> &_cOrd
		@nLin,  0 Psay __PrtThinLine()
		nLin += 1
	    If nLin > 60
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 9
	    Endif		
		@nLin, 000 Psay "Vendedor: "
   		@nLin,012 Psay TMPZZ5->ZZ5_VEND
	 	@nLin,023 Psay TMPZZ5->A3_NOME
		nLin += 2
	    If nLin > 60
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 9
	    Endif
	Endif

    @nLin,000 Psay TMPZZ5->ZZ5_CLIENT
    @nLin,010 Psay TMPZZ5->ZZ5_LOJA
    @nLin,016 Psay SubStr(TMPZZ5->A1_NOME,1,41)
    If Empty(AllTrim(TMPZZ5->A1_GRPVEN))
    Else
    	_aRegras	:= {}
    	cSql := "SELECT * "
    	cSql += "FROM "+RetSqlName("SZI")+" "
    	cSql += "WHERE D_E_L_E_T_ <> '*' AND ZI_FILIAL =  '"+xFilial("SZI")+"' "
    	cSql += "AND ZI_GRPCLI = '"+TMPZZ5->A1_GRPVEN+"' "
		cSql := ChangeQuery(cSql)
		TcQuery cSql NEW ALIAS "TMPSZI"
		DbSelectArea("TMPSZI")            
		TMPSZI->(DbGotop())    	
        While !TMPSZI->(Eof())
        	aAdd(_aRegras,{TMPSZI->ZI_VALMIN,TMPSZI->ZI_DESCMAX})
        	TMPSZI->(DbSkip())
        End
		DbSelectArea("TMPSZI")            
		TMPSZI->(DbCloseArea())
		_nColVal	:= 060
		_nColDes	:= 072
		For nR := 1 To Len(_aRegras)
			@nLin,_nColVal Psay _aRegras[nR,1] Picture "@E 999,999.99"
			@nLin,_nColDes Psay _aRegras[nR,2] Picture "@E 999.99"			
			_nColVal	:= _nColDes+11
			_nColDes	:= _nColVal+10 


		Next nR
    Endif
	nLin += 1
    _cChave	:= &_cOrd
   	TMPZZ5->(dbSkip())
EndDo
DbSelectArea("TMPZZ5")            
TMPZZ5->(DbCloseArea())

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
aAdd(aRegs,{cperg,"01","Cliente Inicial    ?","","","mv_ch1","C",09,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"02","Cliente Final      ?","","","mv_ch2","C",09,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA1",""})
aAdd(aRegs,{cperg,"03","Vendedor Inicial   ?","","","mv_ch3","C",06,0,0,"G",""        ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
aAdd(aRegs,{cperg,"04","Vendedor Final     ?","","","mv_ch4","C",06,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA3",""})
//aAdd(aRegs,{cPerg,"05","Agrupar por        ?","","","mv_ch5","N",01,0,1,"C",""        ,"mv_par05","Cliente","Cliente","Cliente","","","Vendedor","Vendedor","Vendedor","","","","","","","","","","","","","","",""," ","","","","","","","","",""})

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