#INCLUDE "rwmake.ch"      
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RelatNf   º Autor ³GUILHERME POYER     º Data ³  28/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ LISTAR NF PARA CONFERENCIA DE CANHOTOS      								º±±
±±º          ³ 						                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CANTU                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RelatNfs()
Private cPerg				:= "RELATNFS"
AjustaSX1()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If FindFunction("TRepInUse") .And. TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	impRelNfs()
EndIf

return 

static function impRelNfs()
Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de notas fiscais para conferencia de canhotos"
Local cDesc3        := "TITULO"
Local cPict         := ""
Local titulo       	:= "RELACAO DE NOTAS FISCAIS"
Local nLin         	:= 80
Local Cabec1       	:= "_"
Local Cabec2       	:= "_"
Local imprime      	:= .T.
Local aOrd 					:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "RelatNfs" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "RelatNfs" 
Private cString 		:= ""

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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

/**************************************************************************************************/
Static Function ReportDef()

local cTitle  := "RELACAO DE NOTAS FISCAIS"
local cHelp   := "Este programa tem como objetivo imprimir relatorio de notas fiscais para conferencia de canhotos""
Local aOrdem  := {}

local oReport
local oSection1
local oSection2
local oBreak1

Local cAlias := GetNextAlias()

local oReport
Private nPed := 0
Private nBlo := 0
Private nFat := 0
Private nQAtu := 0

oReport	:= TReport():New("RelatNfs",cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oReport:cFontBody:="Arial"
oReport:nfontbody:=7

//oReport:SetPortrait()

//Primeira seção
oSection1 := TRSection():New(oReport,"Cargas",{"SF8"},aOrdem)						
TRCell():New(oSection1,"F2_CARGA", "SF2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

//Segunda seção
oSection2:= TRSection():New(oSection1,"Notas Fiscais",{"SF8","SF1","SD1", "SE2"})
        
oSection2:SetLeftMargin(4)

TRCell():New(oSection2,"F2_DOC", "SF2")
TRCell():New(oSection2,"F2_SERIE", "SF2")


//Totalizador por nota fiscal original
oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(F2_CARGA) },"Total:",.F.)
//TRFunction():New(oSection2:Cell("E2_VALOR"), "TOT1", "SUM", oBreak1,/*cTitle*/,/*cPicture*/,/*uFormula*/, .F., .F.,/*lEndPage*/,/*oParent*/,{||atuaVal((cAlias)->(E2_NUM), (cAlias)->(E2_PREFIXO), (cAlias)->(E2_FORNECE),(cAlias)->(E2_LOJA))},/*lDisable*/,/*bCanPrint*/)
//TRFunction():New(oSection2:Cell("D1_TOTAL"), "TOT2", "SUM", oBreak1,/*cTitle*/,/*cPicture*/,/*uFormula*/, .F., .F.,/*lEndPage*/,/*oParent*/,/*bCondition*/,/*lDisable*/,/*bCanPrint*/)

Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)  
local cOrdem
             
cFiIni := mv_par01
cFiFim := mv_par02
cNfIni := mv_par03
cNfFim := mv_par04
cSeIni := mv_par05
cSeFim := mv_par06
cCaIni := mv_par07
cCafim := mv_par08
dDtIni := DtoS(mv_par09)
dDtFim := DtoS(mv_par10)
cHoIni := mv_par11
cHoFim := mv_par12

oReport:Section(1):BeginQuery()

BeginSQL Alias cAlias

	SELECT F2_DOC, F2_SERIE, F2_CARGA
	
	FROM %Table:SF2% SF2
	WHERE SF2.%notdel% AND
	F2_DOC BETWEEN %Exp:cNfIni% AND %Exp:cNfFim% AND
	F2_SERIE BETWEEN %Exp:cSeIni% AND %Exp:cSeFim% AND
	F2_EMISSAO BETWEEN %Exp:dDtIni% AND %Exp:dDtFim% AND
	F2_CARGA BETWEEN %Exp:cCaIni% AND %Exp:cCaFim% AND
	F2_FILIAL BETWEEN %Exp:cFiIni% AND %Exp:cFiFim% AND
	F2_HORA BETWEEN %Exp:cHoIni% AND %Exp:cHoFim%
	
	ORDER BY F2_CARGA, F2_EMISSAO,F2_DOC,F2_SERIE

EndSQL

oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->F2_CARGA == cParam}, {|| (cAlias)->F2_CARGA})

oSection1b:Print()

return

static function atuaVal(cNum, cPrefix, cFornec, cLoja)
lAtualiza := .F.

if (cOldNum != cNum) .Or. (cOldPrefixo != cPrefix)
	lAtualiza := .T.
endIf

if cOldFornec != cFornec .Or. cOldLoja != cLoja
	lAtualiza := .T.
endIf

cOldNum     := cNum
cOldPrefixo := cPrefix
cOldFornec  := cFornec
cOldLoja    := cLoja

return lAtualiza

/**************************************************************************************************/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem      
Local cEol     := CHR(13)+CHR(10)
Local cOldCarg := ""
cFiIni := mv_par01
cFiFim := mv_par02
cNfIni := mv_par03
cNfFim := mv_par04
cSeIni := mv_par05
cSeFim := mv_par06
cCaIni := mv_par07
cCafim := mv_par08
dDtIni := DtoS(mv_par09)
dDtFim := DtoS(mv_par10)
cHoIni := mv_par11
cHoFim := mv_par12

cSql := "SELECT F2_DOC, F2_SERIE, F2_CARGA " + cEol
cSql += "FROM "+RetSqlName("SF2")+" " + cEol
cSql += "WHERE D_E_L_E_T_ <> '*' AND " + cEol
cSql += "F2_DOC BETWEEN '"+cNfIni+"' AND '"+cNfFim+"' AND " + cEol
cSql += "F2_SERIE BETWEEN '"+cSeIni+"' AND '"+cSeFim+"' AND " + cEol
cSql += "F2_EMISSAO BETWEEN '"+dDtIni+"' AND '"+dDtFim+"' AND " + cEol
cSql += "F2_CARGA BETWEEN '"+cCaIni+"' AND '" + cCaFim +"' AND " + cEol
cSql += "F2_FILIAL BETWEEN '"+cFiIni+"' AND '" + cFiFim +"' AND " + cEol
cSql += "F2_HORA BETWEEN '"+cHoIni+"' AND '"+cHoFim+"'" + cEol
cSql += "ORDER BY F2_CARGA, F2_EMISSAO,F2_DOC,F2_SERIE " + cEol
cSql := ChangeQuery(cSql)

TcQuery cSql NEW ALIAS "TMPF2"
TMPF2->(DbSelectArea("TMPF2"))   
TMPF2->(DbGotop())
SetRegua(RecCount())
TMPF2->(dbGoTop())

While !TMPF2->(EOF())
   If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
   
   if cOldCarg != TMPF2->F2_CARGA
   		@nLin, 000 Psay Replicate("-", 80)
   		nLin := nLin + 1
   		@nLin, 000 Psay "|"
   		@nLin, 080 Psay "|"
   		/*nLin := nLin + 1
   		@nLin, 000 Psay "|"
		  @nLin, 080 Psay "|"*/
			nLin := nLin + 1
		  @nLin, 000 Psay "|"
		  @nLin, 053 Psay "CARGA:"
		  @nLin, 060 Psay TMPF2->F2_CARGA
		  @nLin, 080 Psay "|"
		  nLin := nLin + 1   
		  @nLin, 000 Psay Replicate("-", 80)
		  nLin := nLin + 1 
   		cOldCarg := TMPF2->F2_CARGA
   endIf
   
   If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
   Endif
                
   @nLin, 000 Psay Replicate("-", 80)
   nLin := nLin + 1
   /*@nLin, 000 Psay "|"
   @nLin, 080 Psay "|"
   nLin := nLin + 1
   @nLin, 000 Psay "|"
   @nLin, 080 Psay "|"
	 nLin := nLin + 1
   @nLin, 000 Psay "|"*/
   @nLin, 053 Psay "NF:"
   @nLin, 058 Psay TMPF2->F2_DOC
   @nLin, 068 Psay "SERIE:"
   @nLin, 076 Psay TMPF2->F2_SERIE
   /*@nLin, 080 Psay "|"
   nLin := nLin + 1   
   @nLin, 000 Psay Replicate("-", 80)*/
   nLin := nLin + 1 
           
   dbSkip()
EndDo

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()
dbCloseArea()

Return      

Static Function AjustaSX1()
xAlias := Alias()                                     		

dbSelectArea("SX1")
dbSetOrder(1)
aRegs :={}
cPerg := PADR(cPerg,10)
aAdd(aRegs,{cPerg,"01","Filial De:    		 ?","","","mv_ch1","C",02,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate:     	 ?","","","mv_ch2","C",02,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Nota De:    			 ?","","","mv_ch3","C",09,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Nota Ate:      		 ?","","","mv_ch4","C",09,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Serie De:    			 ?","","","mv_ch5","C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Serie Ate:    		 ?","","","mv_ch6","C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Carga De:    			 ?","","","mv_ch7","C",06,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Carga Ate:     		 ?","","","mv_ch8","C",06,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Data Inicial:    	 ?","","","mv_ch9","D",10,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"10","Data Final:      	?","","","mv_ch10","D",10,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Hora De:     	    ?","","","mv_ch11","C",05,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Hora Ate:     	  ?","","","mv_ch12","C",05,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})




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
