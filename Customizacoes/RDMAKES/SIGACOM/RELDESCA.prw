#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณHDREL01     บAutor  ณGustavo          บ Data ณ 06/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de chamados do sistema helpdesk                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELDESCA()
Private oReport
Private cFile		:= "RELDESCAR"
Private cPerg		:= "RELDESCAR"
Private cTitle		:= "Relat๓rio Descarregamento"
Private cHelp		:= "Este relat๓rio ter por objetivo detalhar as principais informa็๕es em torno das movimenta็๕es de chamados."
Private cAliasTMP	:= GetNextAlias()
Private cAliasTMP2	:= GetNextAlias()

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa fun็๕es de verifica็ใo do grupo de perguntas utilizadoณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
AJUSTASX1(cPerg)
PERGUNTE(cPerg,.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o objeto pertinente ao processamento do relat๓rioณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {} 
Local oBreak 
Local oBreak2

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o componente de processamento do relat๓rioณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Confer๊ncia Entrada")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessใo principal de CHAMADOS do relat๓rio	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1 := TRSection():New(oReport,"Carga",{"Z01"})
TRCell():New(oSection1, "Z01_DOC"			, "Z01", "Nota")
TRCell():New(oSection1, "Z01_SERIE"			, "Z01", "S้rie")    
TRCell():New(oSection1, "Z00_DTCON"			, "Z00", "Data")
TRCell():New(oSection1, "TIPODESC"	  		, "Z01", "Descarregamento")
TRCell():New(oSection1, "TIPOCARG"	  		, "Z01", "Tipo Carga")
//TRCell():New(oSection1, "SOMA"		  		, "Z01", "Peso Nota")
//TRCell():New(oSection1, "Z01_PESOBA"		, "Z01", "Peso")

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessใo de ITENS DO CHAMADO dentro da sessใo CHAMADOS	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection2 := TRSection():New(oSection1, "Produtos", {"Z02"})
oSection2:lHeaderVisible := .T.
oSection2:SetLeftMargin(10)
TRCell():New(oSection2, "Z02_COD"		, "Z02", "C๓digo")
TRCell():New(oSection2, "Z02_PRODUT"	, "Z02", "Produto")
TRCell():New(oSection2, "Z02_DESC"		, "Z02", "Descri็ใo")
TRCell():New(oSection2, "Z02_QUANT"		, "Z02", "Quantidade")   
TRCell():New(oSection2, "PESO"	   		, "Z02", "Peso", "@E 99,999.99",13)
//TRCell():New(oSection2, "Z5_MOTIVO"		, "SZ5", "Motivo")


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ         
oBreak := TRBreak():New(oSection2,{|| (cAliasTMP)->(Z01_DOC) },"Total:",.F.)
TRFunction():New(oSection2:Cell("PESO"), "TOT1", "SUM", oBreak,,"@E 999,999.99",,.F.,.T.)


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL01PRINT     บAutor  ณGustavo       บ Data ณ 06/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function REL01PRINT(oReport)

Local cVazio		:= ""
Local cQuerySec1	:= "%%"
Local oSection1		:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Prepara variaveis de complemento da Query de busca dos chamados	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
cQuerySec1 := "%AND Z01.Z01_FILIAL 	>= '" + MV_PAR01		+ "' AND Z01.Z01_FILIAL 	<= '" + MV_PAR02 	   + "' " + CHR(13)
cQuerySec1 += " AND Z01.Z01_DOC >= '" + MV_PAR03 	+ "' AND Z01.Z01_DOC <= '" + MV_PAR04 + "'" + CHR(13)
cQuerySec1 += " AND Z01.Z01_SERIE >= '" + MV_PAR05 	+ "' AND Z01.Z01_SERIE <= '" + MV_PAR06 + "'" + CHR(13)
cQuerySec1 += " AND Z00.Z00_DTCON >= '" + DTOS(MV_PAR07) + "' AND Z00.Z00_DTCON <= '" + DTOS(MV_PAR08) + "'"
cQuerySec1 += " AND Z01.Z01_TPDESC  = '" + IIf(MV_PAR09 == 1,"P",IIf(MV_PAR09 == 2, "TD","TN")) +"'%"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Efetua montagem da Query da SESSรO DE CHAMADOS ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
BEGIN REPORT QUERY oSection1
	
		BEGINSQL Alias cAliasTMP
						
			SELECT Z01.Z01_FILIAL,
			  	   Z01.Z01_COD,	
			       Z01.Z01_DOC,
			       Z01.Z01_SERIE,
			       Z00.Z00_DTCON, 
			       
			       
			(CASE 
    			WHEN Z01.Z01_TPDESC = %Exp:'P'% 
					THEN "Pr๓prio" 															
 				WHEN Z01.Z01_TPDESC = %Exp:'TD'% 
 					THEN "Terceiro Dia" 															 	 
				WHEN Z01.Z01_TPDESC = %Exp:'TN'% 
					THEN "Terceiro Noite"
		    END) AS TIPODESC,		
			
			(CASE 
    			WHEN Z01.Z01_TPCARG = %Exp:'P'% 
					THEN "Palet" 															
 				WHEN Z01.Z01_TPCARG = %Exp:'G'% 
 					THEN "Granel" 															 	 
			ELSE
				"Caixas"
		    END) AS TIPOCARG
		        

			FROM
				%Table:Z01% Z01   
				
			INNER JOIN %Table:Z00% Z00   
			ON Z00.Z00_FILIAL = Z01.Z01_FILIAL
			AND Z00.Z00_COD = Z01.Z01_COD 
			AND Z00.%NotDel% 
			
			WHERE Z01.%NotDel%
				%Exp:cQuerySec1%
				
      		ORDER BY Z01.Z01_FILIAL, Z01.Z01_DOC, Z01.Z01_SERIE, Z00.Z00_DTCON
		
		ENDSQL
		
END REPORT QUERY oSection1

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Efetua montagem da Query dos ITENS DO CHAMADOS ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
BEGIN REPORT QUERY oSection2
	
		BEGINSQL Alias cAliasTMP2
			
			SELECT 	Z02.Z02_PRODUT,
					Z02.Z02_DESC,
					Z02.Z02_QUANT,
				    B1.B1_PESO * Z02.Z02_QUANT AS PESO								
			FROM
				%Table:Z02% Z02 
			LEFT JOIN %Table:SB1% B1 	
			ON B1.B1_COD = Z02.Z02_PRODUT
			AND B1.%NotDel%
			
			WHERE Z02.Z02_FILIAL = %report_param: (cAliasTMP)->Z01_FILIAL%
			AND Z02.Z02_COD = %report_param: (cAliasTMP)->Z01_COD%
			AND Z02.%NotDel%
				
		ENDSQL
		
END REPORT QUERY oSection2

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Seta regra de contador do processamento	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa a impressใo das sess๕es do relat๓rio	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1:Print() 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณMarcelo           บ Data ณ 06/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela cria็ใo do grupo de perguntas utili-บฑฑ
ฑฑบ          ณzado como parโmetros do relat๓rio.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Treinamento                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AJUSTASX1(cPerg)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ      
PutSX1(cPerg, "01", "Filial De       ?", "Filial De        ?", "Filial De       ?", "mv_ch1"  ,"C",TAMSX3("Z01_FILIAL")[1]	,0,0,"G","","","","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_FILIAL"))
PutSX1(cPerg, "02", "Filial At้      ?", "Filial At้       ?", "Filial At้      ?", "mv_ch2"  ,"C",TAMSX3("Z01_FILIAL")[1]	,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_FILIAL"))
PutSX1(cPerg, "03", "Nota De         ?", "Nota De          ?", "Nota De         ?", "mv_ch3"  ,"C",TAMSX3("Z01_DOC")[1]    	,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_DOC"))
PutSX1(cPerg, "04", "Nota At้   	 ?", "Nota At้         ?", "Nota At้        ?", "mv_ch4"  ,"C",TAMSX3("Z01_DOC")[1]   	,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_DOC"))
PutSX1(cPerg, "05", "S้rie De        ?", "S้rie De         ?", "S้rie De        ?", "mv_ch5"  ,"C",TAMSX3("Z01_SERIE")[1]  	,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_SERIE"))
PutSX1(cPerg, "06", "S้rie At้   	 ?", "S้rie At้        ?", "S้rie At้       ?", "mv_ch6"  ,"C",TAMSX3("Z01_SERIE")[1]  	,0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("Z01", "Z01_SERIE"))
PutSX1(cPerg, "07", "Data De         ?", "Data De          ?", "Data De         ?", "mv_ch7"  ,"D",08					    ,0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "08", "Data At้        ?", "Data At้         ?", "Data At้        ?", "mv_ch8"  ,"D",08						,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg, "09", "Tipo Descarreg  ?", "Tipo Descarreg   ?", "Tipo Descarreg  ?", "mv_ch9"  ,"C",08						,0,0,"C","","","","","mv_par09","Pr๓prio","Pr๓prio","Pr๓prio","","Terceiro(Dia)","Terceiro(Dia)","Terceiro(Dia)","Terceiro(Noite)","Terceiro(Dia)","Terceiro(Noite)")

Return
