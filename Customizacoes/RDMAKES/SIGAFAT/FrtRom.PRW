#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

User Function FRTROM()


Local cDesc1        := "Este programa tem como objetivo imprimir  "
Local cDesc2        := "relatorio de Romaneio de Carga."
Local cDesc3        := ""
Local cPict         := ""
Local titulo       	:= "ROMANEIO DE CARREGAMENTO"
Local nLin         	:= 80
Local Cabec1       	:= "cCabec1"
                      //01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
Local Cabec2       	:= "cCabec2"
Local imprime      	:= .T.
Local aOrd 			:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "M"
Private nomeprog    := "FRTROM" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "FRTROM"
Private cString 	:= ""                                 
Private cPerg		:= "FRTROM000"
Private lAuto		:= .F.    


ValidPerg()
Pergunte(cPerg,.F.)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F., , ,lAuto, .T. )	


If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString,,lAuto)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem 
Local aMunicipio := {}

nTotBon		:= 0
nTotBol		:= 0
nTotVis     := 0	 
nTotGBon	:= 0
nTotGBol	:= 0
nTotGVis    := 0	

cOrdIni		:= mv_par01
cOrdFin		:= mv_par01
nTipoR		:= 1
aResProd	:= {}
aResVist	:= {}


If nTipoR 	= 1
	Cabec2 := "PEDIDO    CODIGO          NOME CLIENTE                                 MUNICIPIO       QUANTIDADE                PESO       VALOR ITEM"
Endif

cSql := "SELECT ZZS.* "
cSql += "FROM "+RetSqlName("ZZS")+" ZZS "
cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
cSql += "AND ZZS.ZZS_NUMROM = '"+mv_par01+"' "
cSql += "ORDER BY ZZS.ZZS_NUMROM"
TCQUERY cSql NEW ALIAS "TMPZZS"

TMPZZS->(dbSelectArea("TMPZZS"))
TMPZZS->(dbGoTop())

Cabec1 := "ROMANEIO DE CARGA NUMERO: "+TMPZZS->ZZS_NUMROM+" EMISSÃO: "+DtoC(Stod(TMPZZS->ZZS_EMIROM))
nTQuant	:= 0
nTPeso	:= 0
nTValor	:= 0
_cNome  := ""
_cMun	:= ""
_cDescPag := ""

While !TMPZZS->(EOF())

	DbSelectArea("SA1")
	DbSetOrder(1)
	SA1->(DbGoTop())
	If DbSeek(xFilial("SA1")+TMPZZS->ZZS_CLIENT+TMPZZS->ZZS_LOJACL)
		_cNome	:= SA1->A1_NOME
		_cMun	:= SA1->A1_MUN
	Endif

    If nLin > 60 
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 9
    Endif
    If nTipoR = 1
		@nLin, 00 Psay TMPZZS->ZZS_PEDIDO
		@nLin, 10 Psay TMPZZS->ZZS_CLIENT+"-"+TMPZZS->ZZS_LOJACL
		@nLin, 26 Psay _cNome
		@nlin, 68 Psay "-"
		@nLin, 75 Psay SubStr(_cMun,1,40)
		@nLin, 116 Psay TMPZZS->ZZS_NOMEMP+" - "+TMPZZS->ZZS_NOMFIL
		nLin += 1
	Endif

	cSql := "SELECT C6.C6_PRODUTO, C6.C6_QTDVEN,C6.C6_VALOR, 0 D2_PESO,B1.B1_DESC, B1.B1_GRUPO,B1.B1_UM, B1.B1_PESBRU "
	cSql += "FROM SC6"+TMPZZS->ZZS_EMPRES+"0"+" C6, "+RetSqlName("SB1")+" B1 "
	cSql += "WHERE C6.C6_FILIAL = '"+xFilial("SC6")+"' AND B1.B1_FILIAL = '"+xFilial("SB1")+"' "
	cSql += "AND C6.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' "
	cSql += "AND B1.B1_COD = C6.C6_PRODUTO "
	cSql += "AND C6.C6_NUM = '"+TMPZZS->ZZS_PEDIDO+"' "
//	cSql += "AND D2.D2_SERIE = '"+TMPZM->ZM_SERIE+"' " 
	cSql += "AND C6.C6_CLI = '"+TMPZZS->ZZS_CLIENT+"' "
	cSql += "AND C6.C6_LOJA = '"+TMPZZS->ZZS_LOJACL+"' "
	cSql := ChangeQuery(cSql)
	TCQUERY cSql NEW ALIAS "TMPC6"
	DbSelectArea("TMPC6")
	
	TMPC6->(DbGotop())
	nSQuant	:= 0
	nSPeso	:= 0
	nSValor	:= 0
	
	While !TMPC6->(Eof())
		If nTipoR = 1
		    If nLin > 60 
		       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		       nLin := 9
		    Endif	
			@nLin, 000 Psay "Prd."
			@nLin, 004 Psay TMPC6->C6_PRODUTO
			@nLin, 019 Psay TMPC6->B1_DESC+TMPC6->B1_UM
			@nLin, 082 Psay TMPC6->C6_QTDVEN Picture "@E 9,999,999,999.99"
			@nLin, 102 Psay Round((TMPC6->C6_QTDVEN * TMPC6->B1_PESBRU),2)  Picture "@E 9,999,999,999.99"
			@nLin, 119 Psay TMPC6->C6_VALOR Picture "@E 9,999,999,999.99"
			
			nSQuant 	+= TMPC6->C6_QTDVEN 
			nSPeso		+= Round((TMPC6->C6_QTDVEN * TMPC6->B1_PESBRU),2) 
			nTQuant 	+= TMPC6->C6_QTDVEN 
			nTPeso		+= Round((TMPC6->C6_QTDVEN * TMPC6->B1_PESBRU),2)
			nTValor		+= TMPC6->C6_VALOR
			nSValor		+= TMPC6->C6_VALOR
			nLin += 1
		Endif
		TMPC6->(DbSkip())			
	End
	
	If nTipoR = 1
	    If nLin > 60 
	       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	       nLin := 9
	    Endif	
		@nLin, 064 Psay "TOTAIS --->"
		@nLin, 081 Psay nSQuant Picture "@E 9,999,999,999.99"
		@nLin, 101 Psay nSPeso Picture "@E 9,999,999,999.99"
		@nLin, 118 Psay nSValor Picture "@E 9,999,999,999.99"		
		nLin += 1
		@ nLin, 00  PSAY __PrtThinLine()
		nLin += 1
	
	Endif

	TMPC6->(DbCloseArea())
	
	DbSelectArea("TMPZZS")
    TMPZZS->(dbSkip())
EndDo


If nLin > 60 
  Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
  nLin := 9
Endif				
@nLin, 065 Psay "TOTAL GERAL "
@nLin, 081 Psay nTQuant Picture "@E 9,999,999,999.99"
@nLin, 101 Psay nTPeso Picture "@E 9,999,999,999.99"
@nLin, 118 Psay nTValor Picture "@E 9,999,999,999.99"    

If nLin > 60 
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
Endif	
	
DbSelectArea("TMPZZS")
TMPZZS->(DbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return()

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Codigo da Carga   ","","","mv_ch1","C",09,0,0,"G","       ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","ZZSROM","",""})
//aAdd(aRegs,{cPerg,"02","Tipo Relatorio    ?","","","mv_ch2","N",01,0,0,"C","       ","mv_par02","Analitico","Analitico","Analitico","","","Sintetico","Sintetico","Sintetico","","","","","","","","","","","","","","","","","",""})

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