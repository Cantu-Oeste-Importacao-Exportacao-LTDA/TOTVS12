#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelSegimp  º Autor ³Adriano Novachaelleyº Data ³  07/07/11  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Controle de entrada de seguros das importações.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especipecifico Cantu                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelSegimp()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         	:= "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         	:= "de acordo com os parametros informados pelo usuario."
Local cDesc3         	:= "Acompanhamento de Fretes"
Local cPict          	:= ""
Local titulo       		:= "Acompanhamento de Fretes"
Local nLin         		:= 80

Local Cabec1      	 	:= "_"
Local Cabec2       		:= "CODIGO         DESCRIÇÃO PRODUTO                QUANTIDADE       UNITARIO            IPI           ICMS       DESPESAS          TOTAL"
Local imprime      		:= .T.
Local aOrd 				:= { "Emissão + Fornecedor"}//{}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite          := 220
Private tamanho         := "G"
Private nomeprog        := "RELSEG" 
Private nTipo           := 18
Private aReturn         := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1} 
Private nLastKey        := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel      		:= "RELSEG"
Private cPerg			:= "RELSEG"
Private cString 		:= "SF1" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


ValidPerg()
Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)
nOrdem := aReturn[8]

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

_cDtIni		:= DtoS(mv_par01) // Data inicial
_cDtFin		:= DtoS(mv_par02) // Data final
_cForIni	:= mv_par03 	  // Fornecedor inicial
_cForFin	:= mv_par04 	  // Fornecedor final
_nValItem	:= 0			  // Valor total dos itens	
Cabec1	:= "Data Inisial: "+DtoC(mv_par01)+" Data Final: "+DtoC(mv_par02)
Do Case
	Case nOrdem = 1
		_cOrder := "ORDER BY F1.F1_EMISSAO,F1.F1_FORNECE"
		_cChave	:= "TMPF1->F1_EMISSAO+TMPF1->F1_FORNECE"
	Case nOrdem = 2
		_cOrder := 	"ORDER BY F1.F1_FORNECE,F1.F1_EMISSAO"
		_cChave	:= "TMPF1->F1_FORNECE+TMPF1->F1_EMISSAO"
End Case
	
	

cSql := "SELECT F1.F1_FILIAL, F1.F1_DOC,F1.F1_FORNECE, F1.F1_LOJA,A2.A2_NOME, F1.F1_EMISSAO, F1.F1_DTDIGIT,B1.B1_DESC, "
cSql += "F1.F1_X_ORIGE,F1.F1_X_TIPTR,F1.F1_X_TIPME,F1.F1_X_NAVIO, F1.F1_X_DTEMB,F1.F1_X_TCNTR,F1_X_QCNTR,F1.F1_PREFIXO, "
cSql += "F1.F1_DUPL,F1.F1_SERIE, "
cSql += "D1.D1_COD, D1.D1_QUANT,D1.D1_VUNIT,D1.D1_TOTAL, D1.D1_VALIPI, D1.D1_VALICM, D1.D1_DESC, D1.D1_IPI, "
cSql += "D1.D1_VALIMP1, D1.D1_VALIMP2, D1.D1_VALIMP3, D1.D1_VALIMP4, D1.D1_VALIMP5, D1.D1_VALIMP6, "
cSql += "D1.D1_SEGURO, D1.D1_DESPESA, D1.D1_VALIRR, D1.D1_VALISS "
cSql += "FROM "+RetSqlName("SF1")+" F1,"+RetSqlName("SA2")+" A2,"+RetSqlName("SD1")+" D1,"+RetSqlName("SB1")+" B1 "
cSql += "WHERE F1.D_E_L_E_T_ <> '*' AND A2.D_E_L_E_T_ <> '*' AND D1.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*' "
cSql += "AND F1.F1_FILIAL = '"+xFilial("SF1")+"' "
cSql += "AND A2.A2_COD = F1.F1_FORNECE AND A2.A2_LOJA = F1.F1_LOJA "
cSql += "AND D1.D1_FILIAL = F1.F1_FILIAL AND D1.D1_DOC = F1.F1_DOC AND D1.D1_SERIE = F1.F1_SERIE "
cSql += "AND D1.D1_FORNECE = F1.F1_FORNECE AND D1.D1_LOJA = F1.F1_LOJA "
cSql += "AND B1.B1_COD = D1.D1_COD "
cSql += "AND (F1.F1_X_ORIGE  <> ' ' OR F1.F1_X_TIPTR  <> ' ' OR F1.F1_X_TIPME  <> ' ' OR F1.F1_X_NAVIO  <> ' ' OR F1.F1_X_DTEMB  <> ' ' "
cSql += "OR F1.F1_X_QCNTR  > 0 OR F1.F1_X_TCNTR <> ' ')  "
cSql += "AND F1.F1_EMISSAO BETWEEN '"+_cDtIni+"' AND '"+_cDtFin+"' "
cSql += "AND F1.F1_FORNECE BETWEEN '"+_cForIni+"' AND '"+_cForFin+"' "
cSql +=	_cOrder

cSql := ChangeQuery(cSql)
TCQUERY cSql NEW ALIAS "TMPF1"
TMPF1->(DbSelectArea("TMPF1"))
TMPF1->(DbGoTop()) 
_cVer	:= &_cChave
_nValE2	:= 0
_nValD1	:= 0
While !TMPF1->(EOF())
                   
	//	ORIGEM IMPORTACAO, C, 40, ORIGEM IMPORTACAO
	//	F1_X_TIPTR, C, 1, TIPO TRANSPORTE IMPORTACAO
	//	F1_X_TIPME, C, 40, TIPO MERCADORIA IMPORTACAO
	//	F1_X_NAVIO, C, 40, DESCRICAO NAVIO IMPORTACAO
	//	F1_X_DTEMB, D, 8, DATA EMBARQUE IMPORTACAO
	//	F1_X_QCNTR, N, 12/2, QUANTIDADE CNTR	
	//	F1_X_TCNTR, C, 1, TIPO CNTR
	//	(E2.E2_X_NUMDI <> ''  OR E2_X_NUMFT<> '' OR E2_X_NUMBL<> '' OR E2_X_AIRIM<> '' OR E2_X_MICRT <> '')
	//	@nLin, 089 Psay TMPE2->E2_X_NUMDI // Numero Documento de Importação
	//	@nLin, 111 Psay TMPE2->E2_X_NUMFT // Numero da Fatura
	//	@nLin, 133 Psay TMPE2->E2_X_NUMBL // Numero BL
	//	@nLin, 155 Psay TMPE2->E2_X_AIRIM // Numero AIR / Import
	//	@nLin, 177 Psay TMPE2->E2_X_MICRT
	If lAbortPrint
	   @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	   Exit
	Endif
	

	If nLin > 60
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 9
	Endif
	_nValItem := 0

	@nLin, 000 Psay "ORIGEM IMP.:"
	@nLin, 012 Psay TMPF1->F1_X_ORIGE
	@nLin, 053 Psay "TIPO TRANSP.:"
	@nLIn, 066 Psay TMPF1->F1_X_TIPTR
	@nLin, 076 Psay "TIPO MERC.:"
	@nLin, 088 Psay TMPF1->F1_X_TIPME
	@nLin, 129 Psay "DESC. NAVIO: "
	@nLin, 143 Psay TMPF1->F1_X_NAVIO
	@nLin, 185 Psay "DATA EMBARQUE: "
	@nLin, 201 Psay StoD(TMPF1->F1_X_DTEMB)
	nLin += 1
	If nLin > 60
	   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	   nLin := 9
	Endif
	@nLin, 000 Psay "QUANT.CNTR :"
	@nLin, 014 Psay TMPF1->F1_X_QCNTR Picture "@E 9,999,999,999.99"
	@nLin, 053 Psay "TIPO CNTR :"
	@nLin, 066 Psay TMPF1->F1_X_TCNTR
	SE2->(DbSelectArea("SE2"))
	SE2->(DbSetOrder(6))
	SE2->(DbGotop())
	If SE2->(DbSeek(xFilial("SE2")+TMPF1->F1_FORNECE+TMPF1->F1_LOJA+TMPF1->F1_PREFIXO+TMPF1->F1_DUPL))
		@nLin, 076 Psay "NUM. DI.: "+SE2->E2_X_NUMDI
		@nLin, 129 Psay "NUM. FAT.:"+SE2->E2_X_NUMFT
		nLin += 1
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
		@nLin, 000 Psay "NUM. BL :"+SE2->E2_X_NUMBL
		@nLin, 053 Psay "NUM. AIR :"+SE2->E2_X_AIRIM
		@nLIn, 129 Psay "NUM. MICTR.:"+SE2->E2_X_MICRT
	Endif	
	nQtd	:= 0
	nVIcm	:= 0
	nVIpi	:= 0
	nVDesp	:= 0
	nVTotal := 0
	nLin += 2
	While !TMPF1->(Eof()) .AND. _cVer == &_cChave
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif
		@nLin, 000 Psay TMPF1->D1_COD
		@nLin, 016 Psay TMPF1->B1_DESC
		@nLin, 047 Psay TMPF1->D1_QUANT PICTURE "@E 999,999,999"
		@nLin, 059 Psay TMPF1->D1_VUNIT PICTURE "@E 999,999,999.99"
		@nlin, 074 Psay TMPF1->D1_VALICM PICTURE "@E 999,999,999.99"
		@nLin, 089 Psay TMPF1->D1_VALIPI PICTURE "@E 999,999,999.99"
		@nLin, 104 Psay TMPF1->D1_DESPESA PICTURE "@E 999,999,999.99"				
		@nLin, 119 Psay TMPF1->D1_TOTAL PICTURE "@E 999,999,999.99"				
		nQtd	+= TMPF1->D1_QUANT
		nVIcm	+= TMPF1->D1_VALICM
		nVIpi	+= TMPF1->D1_VALIPI
		nVDesp	+= TMPF1->D1_DESPESA
		nVTotal += TMPF1->D1_TOTAL
		_cNf	:= TMPF1->F1_DOC
		nLin += 1
		TMPF1->(dbSkip())
	End
	If _cVer <> &_cChave
		If nLin > 60
		   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   nLin := 9
		Endif 
		@nLin, 016 Psay "TOTAL NOTA FISCAL "+_cNf
		@nLin, 047 Psay nQtd PICTURE "@E 999,999,999"

		@nlin, 074 Psay nVIcm PICTURE "@E 999,999,999.99"
		@nLin, 089 Psay nVIpi PICTURE "@E 999,999,999.99"
		@nLin, 104 Psay nVDesp PICTURE "@E 999,999,999.99"				
		@nLin, 119 Psay nVTotal PICTURE "@E 999,999,999.99"			
		
		nLin += 1
		@ nLin, 00  PSAY __PrtThinLine()		
		nLin += 1		
	Endif
	_cVer	:= &_cChave
EndDo


TMPF1->(DbSelectArea("TMPF1"))
TMPF1->(DbCloseArea())

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

Static Function ValidPerg
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Emissao inicial     ","","","mv_ch1","D",08,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"02","Emissao final       ","","","mv_ch2","D",08,0,0,"G","NaoVazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Fornecedor inicial  ","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
aAdd(aRegs,{cPerg,"04","Fornecedor Final    ","","","mv_ch4","C",09,0,0,"G","NaoVazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SA2",""})
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