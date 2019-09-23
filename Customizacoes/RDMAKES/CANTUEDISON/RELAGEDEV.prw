#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELAGEDEV บAutor ณEdison Greski Barbieri บ Data ณ 26/04/2019บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio contendo informa็๕es de titulos com agendamento   บฑฑ
ฑฑบ          ณde devolucao.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function RELAGEDEV()
	Private oReport
	Private cFile		:= "RELPAGAG"
	Private cPerg		:= "RELPAGAG01"
	Private cTitle		:= "Pagamentos Agendados NDF"
	Private cHelp		:= "Este relat๓rio ter por objetivo detalhar pagamento agendados fornecedores com devolucao."
	Private cAliasTMP	:= GetNextAlias()

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Cria o objeto pertinente ao processamento do relat๓rioณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oReport := REL01()
	oReport:PRINTDIALOG()

Return

Static Function REL01()

	Local aOrder := {}
	Local oBreak

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Cria o componente de processamento do relat๓rioณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os tํtulos")
	oReport:SetLandscape()
	oReport:EndReport(.F.)
	oReport:SetTotalInLine(.T.)

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Cria a sessใo principal de CHAMADOS do relat๓rio	ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oSection1 := TRSection():New(oReport,"Titulos Agendamentos",{"SE2"})
	TRCell():New(oSection1, "PT2_NOME"      , "PT2", "Comprador"          ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_FILIAL"   	, "SE2", "Filial"             ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_FORNECE"	, "SE2", "Fornecedor"         ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_LOJA"	    , "SE2", "Loja"               ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_NOMFOR"	    , "SE2", "Nome Fornec"        ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_EMISSAO"   	, "SE2", "Emissao"            ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_NUM"        , "SE2", "Titulo"             ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E2_PARCELA"	, "SE2", "Parcela"            ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "E5_DOCUMEN"    , "SE5", "Documento"          ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
	TRCell():New(oSection1, "VALOR"	        , "SE2", "Valor"              ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//	ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

	//O break quebra a linha pelo campo que deseja por fornecedor
	oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(E2_FORNECE) },"Total por Fornecedor:")
	//faz a soma do conteudo desejado e2_valor
	TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)

	//TRFunction():New(oSection1:Cell("E2_VALOR"),NIL,"SUM",,,,,.F.,.T.)

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL01PRINT     บAutor  ณEdison        บ Data ณ 18/03/2018   บฑฑ
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
	Local oSection1		:= oReport:Section(1)
	Local oSection2		:= oReport:Section(1):Section(1)

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Efetua montagem da Query da SESSรO DE CHAMADOS ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	BEGIN REPORT QUERY oSection1

		BEGINSQL Alias cAliasTMP
			Column E2_EMISSAO as Date

			SELECT
			PT2.PT2_NOME,
			E2.E2_FILIAL,
			E2.E2_FORNECE,
			E2.E2_LOJA,
			E2.E2_NOMFOR,
			E2.E2_EMISSAO,
			E2.E2_NUM,
			E2.E2_PARCELA,
			E5.E5_DOCUMEN,
			E2.E2_VALOR - E2.E2_DECRESC AS VALOR,
			CASE WHEN E2.E2_X_AVCTO <> ' '  THEN '1'
			WHEN E2.E2_X_AVCTO = ' '  THEN '2'

		END

		FROM %Table:SE2% E2
		LEFT JOIN %Table:PT2% PT2
		ON  PT2.PT2_FORNEC = E2.E2_FORNECE
		AND PT2.PT2_LOJA = E2.E2_LOJA
		LEFT JOIN %Table:SE5% E5
		ON E5.E5_FILIAL = E2.E2_FILIAL
		AND E5.E5_NUMERO = E2.E2_NUM
		AND E5.E5_PARCELA = E2.E2_PARCELA
		AND E5.E5_CLIFOR = E2.E2_FORNECE
		AND E5.E5_LOJA = E2.E2_LOJA
		AND E5.E5_TIPO = E2.E2_TIPO

		WHERE   E2.%Notdel%
		AND PT2.%Notdel%
		AND E5.%Notdel%
		AND E2.E2_TIPO = 'NDF' 
		AND E2.E2_FILIAL   >= %Exp:MV_PAR01%       AND E2.E2_FILIAL    <= %Exp:MV_PAR02%
		AND PT2.PT2_CODIGO =  %Exp:mv_par03%
		AND E2.E2_FORNECE  >= %Exp:mv_par04%       AND E2.E2_FORNECE   <=  %Exp:mv_par05%
		AND E2.E2_LOJA     >= %Exp:mv_par06%       AND E2.E2_LOJA      <=  %Exp:mv_par07%
		AND E2.E2_EMISSAO  >= %Exp:DtoS(mv_par08)% AND E2.E2_EMISSAO   <=  %Exp:DtoS(mv_par09)%
		AND E2.E2_VENCTO   >= %Exp:DtoS(mv_par10)% AND E2.E2_VENCTO    <=  %Exp:DtoS(mv_par11)%

		GROUP BY PT2.PT2_NOME, E2.E2_FILIAL, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E5.E5_DOCUMEN, E2.E2_VALOR, E2_X_AVCTO, E2.E2_DECRESC
		HAVING CASE WHEN E2.E2_X_AVCTO <> ' '  THEN '1'
		WHEN E2.E2_X_AVCTO = ' '  THEN '2'
	END = %Exp:MV_PAR12%

	ORDER BY PT2.PT2_NOME, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_VALOR
	ENDSQL

	END REPORT QUERY oSection1

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Seta regra de contador do processamento	ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ

	oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Executa a impressใo das sess๕es do relat๓rio	ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oSection1:Print()

Return

