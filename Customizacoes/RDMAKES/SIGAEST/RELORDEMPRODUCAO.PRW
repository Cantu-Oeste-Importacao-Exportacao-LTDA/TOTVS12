#include "rwmake.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณRELORDPROD บAutor  ณ Roberto Rosin      บ Data ณ 05/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImprime um relat๓rio para ordens de produ็ใo para que a     บฑฑ
ฑฑบ          ณpessoa responsแvel pelo estoque saiba quais serใo as mate-  บฑฑ
ฑฑบ          ณrias primas nescessแrias para a produ็ใo  da ordem          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELORDPROD()
local oReport
local cPerg  := "RELORDPROD"
local cAlias := getNextAlias()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

criaSX1(cPerg)
Pergunte(cPerg, .F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama a fun็ใo para a defini็ใo da estruturaณ 
//ณdo relat๓rio informando no ๚ltimo parโmetro ณ
//ณse o relat๓rio foi chamado atrav้s de rotinaณ
//ณdo menu ou atrav้s do P.E. na Ordem de Pro- ณ
//ณdu็ใo                                       ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oReport := reportDef(cAlias, cPerg)

oReport:printDialog()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Chama o construtor das perguntas padrใo da rotina ณ
//ณ Nescessแrio para nใo dar ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
pergunte("MTA650", .F.)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Roberto Rosin       บ Data ณ 05/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cria็ใo da estrutura do relat๓rio               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relat๓rio de Mat้rias Primas da Ordem de Produ็ใo"
local cHelp   := "Permite gerar um relat๓rio com as mat้rias primas para uma ordem de produ็ใo"
Local aOrdem  := {}

local oReport
local oSection1
local oSection2
local oBreak1

oReport	:= TReport():New("RELORDPROD",cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)

oReport:cFontBody:="Arial"
oReport:nfontbody:=7

oReport:SetPortrait()

//Primeira se็ใo
oSection1 := TRSection():New(oReport,"Ordem",{"SC2", "SA1", "SB1"})						
TRCell():New(oSection1,"C2_X_CLIEN", "SC2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"C2_X_LOJA",  "SC2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"A1_NOME",    "SA1",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"C2_PRODUTO", "SC2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"B1_DESC",    "SB1",/*cTitle*/,/*cPicture*/,       50,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"C2_QUANT",   "SC2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"C2_PEDIDO",  "SC2",/*cTitle*/,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1,"C2_NUM",     "SC2","Nบ Ordem",/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

//Segunda se็ใo
oSection2:= TRSection():New(oSection1,"Estrutura",{"SB1","SG1"})
        
//oSection2:SetLeftMargin(4)

TRCell():New(oSection2,"G1_COMP",    "SG1",/*cTitle*/ ,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"DESC_COMP",  "   ","Descri็ใo",        "@!",       50,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)
TRCell():New(oSection2,"G1_QUANT",   "SG1",/*cTitle*/ ,/*cPicture*/,/*nSize*/,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,/*lBold*/)

//Totalizador por nota fiscal original
oBreak1 := TRBreak():New(oSection2,{|| (cAlias)->(C2_PRODUTO) },"Total:",.T.)

Return(oReport)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณReportPrintบAutor  ณRoberto Rosin       บ Data ณ 05/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para montagem dos dados do relat๓rio.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport,cAlias)
local oSection1b := oReport:Section(1)
local oSection2b := oReport:Section(1):Section(1)

cFilIni  := mv_par01
cFilFim  := mv_par02
cOrdeIni := mv_par03
cOrdeFim := mv_par04
cClieIni := mv_par05
cClieFim := mv_par06
cLojaIni := mv_par07
cLojaFim := mv_par08
cPediIni := mv_par09
cPediFim := mv_par10
cProdIni := mv_par11
cProdFim := mv_par12

oSection1b:BeginQuery()

BeginSQL Alias cAlias
	
	SELECT SC2.C2_X_CLIEN,SC2.C2_X_LOJA,SA1.A1_NOME,SC2.C2_PRODUTO,SB1.B1_DESC,COMP.B1_DESC AS DESC_COMP,SC2.C2_PEDIDO,SC2.C2_NUM, SC2.C2_QUANT, SG1.G1_COD, SG1.G1_COMP, (SG1.G1_QUANT * SC2.C2_QUANT) AS G1_QUANT
	  FROM %Table:SC2% SC2
	 INNER JOIN %Table:SB1% SB1 ON SB1.B1_COD = SC2.C2_PRODUTO AND SB1.%NotDel%
	 INNER JOIN %Table:SA1% SA1 ON SA1.A1_COD = SC2.C2_X_CLIEN AND SA1.A1_LOJA = SC2.C2_X_LOJA  AND SA1.%NotDel%
	 INNER JOIN %Table:SG1% SG1 ON SG1.G1_FILIAL = SC2.C2_FILIAL AND SG1.G1_COD = SC2.C2_PRODUTO AND SG1.%NotDel%
	 INNER JOIN %Table:SB1% COMP ON COMP.B1_COD = SG1.G1_COMP AND COMP.%NotDel%
	 WHERE SC2.%NotDel%
	   AND SC2.C2_FILIAL  BETWEEN %Exp:cFilIni%  AND %Exp:cFilFim%
	   AND SC2.C2_NUM     BETWEEN %Exp:cOrdeIni% AND %Exp:cOrdeFim%
	   AND SC2.C2_X_CLIEN BETWEEN %Exp:cClieIni% AND %Exp:cClieFim%
	   AND SC2.C2_X_LOJA  BETWEEN %Exp:cLojaIni% AND %Exp:cLojaFim%
	   AND SC2.C2_PEDIDO  BETWEEN %Exp:cPediIni% AND %Exp:cPediFim%
	   AND SC2.C2_PRODUTO BETWEEN %Exp:cProdIni% AND %Exp:cProdFim%
	 ORDER BY SC2.C2_NUM,SC2.C2_X_CLIEN,SC2.C2_X_LOJA
	 
EndSQL 

oSection1b:EndQuery()    
oSection2b:SetParentQuery()

oReport:SetMeter((cAlias)->(RecCount()))  

oSection2b:SetParentFilter({|cParam| (cAlias)->G1_COD == cParam}, {|| (cAlias)->G1_COD})

oSection1b:Print()	   

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณcriaSX1   บAutor  ณRoberto Rosin        บ Data ณ 05/03/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria็ใo do Grupo de Perguntas                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function criaSX1(cPerg)

	PutSx1(cPerg,"01","Filial De ?",   "Filial De ?",   "Filial De ?",   "mv_ch01", "C",02,0,0,"G","","   ","","","MV_PAR01")
	PutSx1(cPerg,"02","Filial At้ ?",  "Filial At้ ?",  "Filial At้ ?",  "mv_ch02" ,"C",02,0,0,"G","","   ","","","MV_PAR02")
	PutSx1(cPerg,"03","Ordem De ?",    "Ordem De ?",    "Ordem De ?",    "mv_ch03" ,"C",06,0,0,"G","","SC2","","","MV_PAR03")
	PutSx1(cPerg,"04","Ordem At้ ?",   "Ordem At้ ?",   "Ordem At้ ?",   "mv_ch04" ,"C",06,0,0,"G","","SC2","","","MV_PAR04")
	PutSx1(cPerg,"05","Cliente De ?",  "Cliente De ?",  "Cliente De ?",  "mv_ch05" ,"C",09,0,0,"G","","SA1","","","MV_PAR05")
	PutSx1(cPerg,"06","Cliente At้ ?", "Cliente At้ ?", "Cliente At้ ?", "mv_ch06", "C",09,0,0,"G","","SA1","","","MV_PAR06")
	PutSx1(cPerg,"07","Loja De ?",     "Loja De ?",     "Loja De ?",     "mv_ch07" ,"C",04,0,0,"G","","   ","","","MV_PAR07")
	PutSx1(cPerg,"08","Loja At้ ?",    "Loja At้ ?",    "Loja At้ ?",    "mv_ch08" ,"C",04,0,0,"G","","   ","","","MV_PAR08")
	PutSx1(cPerg,"09","Pedido De ?",   "Pedido De ?",   "Pedido De ?",   "mv_ch09" ,"C",06,0,0,"G","","SC5","","","MV_PAR09")
	PutSx1(cPerg,"10","Pedido At้ ?",  "Pedido At้ ?",  "Pedido At้ ?",  "mv_ch10" ,"C",06,0,0,"G","","SC5","","","MV_PAR10")
	PutSx1(cPerg,"11","Produto De ?",  "Produto De ?",  "Produto De ?",  "mv_ch11", "C",15,0,0,"G","","SB1","","","MV_PAR11")
	PutSx1(cPerg,"12","Produto De ?",  "Produto De ?",  "Produto De ?",  "mv_ch12" ,"C",15,0,0,"G","","SB1","","","MV_PAR12")

return