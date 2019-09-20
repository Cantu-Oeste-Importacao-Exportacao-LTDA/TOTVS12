#include "protheus.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCARGDATºAutor  ³Roberto Rosin       º Data ³  28/09/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório que imprime as cargas totalizando o peso por dataº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function RELCARGDAT()

local oReport
local cPerg  := "RELCARGDAT"
local cAlias := getNextAlias()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

criaSx1(cPerg)
Pergunte(cPerg, .F.)

oReport := reportDef(cAlias, cPerg)

oReport:printDialog()

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação da estrutura do relatório.                                                !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportDef(cAlias,cPerg)

local cTitle  := "Relatório de Cargas por data"
local cHelp   := "Permite gerar relatório de cargas."
//Local aOrdem  := "Data"

local oSection1
local oBreak1

oReport	:= TReport():New('RELCARGDAT',cTitle,cPerg,{|oReport|ReportPrint(oReport,cAlias)},cHelp)
oReport:SetPortrait()
oReport:cFontBody:="Arial"
oReport:nfontbody:=8

//Primeira seção
oSection1 := TRSection():New(oReport,"Cargas",{"DAK"})    

TRCell():New(oSection1,"DAK_COD",    "SA1",)   
TRCell():New(oSection1,"DAK_DATA",   "SA1",)   
TRCell():New(oSection1,"DAK_HORA",   "SA1",)   
TRCell():New(oSection1,"DAK_PESO",   "SA1",)
TRCell():New(oSection1,"DAK_CAMINH", "SA1",)

//Totalizador por data
oBreak1 := TRBreak():New(oSection1,{|| (cAlias)->(DAK_DATA) },"Total:",.F.)
TRFunction():New(oSection1:Cell("DAK_PESO" ), "TOT1", "SUM", oBreak1,,,,.F.,.T.)
//TRFunction():New(oSection1:Cell("DAK_PESO" ), "TOT2", "SUM", oBreak1,,,,.F.,.T.,.F.)
Return(oReport)

//+-----------------------------------------------------------------------------------------------+
//! Rotina para montagem dos dados do relatório.                                  !
//+-----------------------------------------------------------------------------------------------+
Static Function ReportPrint(oReport,cAlias)

local oSection1b := oReport:Section(1)
             
oSection1b:BeginQuery()

BeginSQL Alias cAlias
	
	Column DAK_DATA as Date
	
	
	SELECT DAK.DAK_COD, DAK.DAK_DATA, DAK.DAK_HORA, DAK.DAK_PESO, DAK.DAK_CAMINH
	  FROM %Table:DAK% DAK
	 WHERE DAK.DAK_FILIAL BETWEEN %Exp:MV_PAR01% AND %Exp:MV_PAR02%
		 AND DAK.DAK_DATA BETWEEN %Exp:MV_PAR03% AND %Exp:MV_PAR04%
		 AND DAK.DAK_HORA BETWEEN %Exp:MV_PAR05% AND %Exp:MV_PAR06%
		 AND DAK.%notdel%
	 ORDER BY DAK.DAK_DATA, DAK.DAK_HORA, DAK.DAK_CAMINH
EndSQL 

oSection1b:EndQuery()    

oReport:SetMeter((cAlias)->(RecCount()))

oSection1b:Print()	   

return

//+-----------------------------------------------------------------------------------------------+
//! Função para criação das perguntas (se não existirem)                                          !
//+-----------------------------------------------------------------------------------------------+
static function criaSX1(cPerg)

putSx1(cPerg, '01', 'Filial de?'          , '', '', 'mv_ch1', 'C', TAMSX3("DAK_FILIAL")[1], 0, 0, 'G', '', 'XM0', '', '', 'mv_par01')
putSx1(cPerg, '02', 'Filial até?'         , '', '', 'mv_ch2', 'C', TAMSX3("DAK_FILIAL")[1], 0, 0, 'G', '', 'XM0', '', '', 'mv_par02')
putSx1(cPerg, '03', 'Data de?'            , '', '', 'mv_ch3', 'D', TAMSX3("DAK_DATA")[1]  , 0, 0, 'G', '', ''   , '', '', 'mv_par03')
putSx1(cPerg, '04', 'Data até?'           , '', '', 'mv_ch4', 'D', TAMSX3("DAK_DATA")[1]  , 0, 0, 'G', '', ''   , '', '', 'mv_par04')
putSx1(cPerg, '05', 'Hora de'             , '', '', 'mv_ch5', 'C', TAMSX3("DAK_HORA")[1]  , 0, 0, 'G', '', '   ', '', '', 'mv_par05')
putSx1(cPerg, '06', 'Hora até?'           , '', '', 'mv_ch6', 'C', TAMSX3("DAK_HORA")[1]  , 0, 0, 'G', '', '   ', '', '', 'mv_par06')

return