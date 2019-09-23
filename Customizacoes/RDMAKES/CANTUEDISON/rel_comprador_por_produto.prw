#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥RELPAGCP ∫Autor ≥Edison Greski Barbieri ∫ Data ≥ 09/07/2019 ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥RelatÛrio contendo informaÁıes de titulos por comprador     ∫±±
±±∫          ≥produtos.                                                   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ Financeiro                                                 ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/                                                                     

User Function RELPAGCP()
Private oReport
Private cFile		:= "RELPAGCP"
Private cPerg		:= "RELPAGCP01"
Private cTitle		:= "TÌtulos por comprador por produtos"
Private cHelp		:= "Este relatÛrio ter por objetivo detalhar pagamento por comprador por produtos."
Private cAliasTMP	:= GetNextAlias()



//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o objeto pertinente ao processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {}
Local oBreak

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria o componente de processamento do relatÛrio≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os tÌtulos")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.T.)


//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Cria a sess„o principal de CHAMADOS do relatÛrio	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oSection1 := TRSection():New(oReport,"Titulos",{"SE2"})
TRCell():New(oSection1, "E2_FILIAL"   	, "SE2", "Filial"             ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "F1_EST"     	, "SF1", "Estado"             ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_EMISSAO"   	, "SE2", "Emissao"            ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_VENCREA"   	, "SE2", "Vencimento"         ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_PREFIXO"	, "SE2", "Prefixo"            ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_TIPO"    	, "SE2", "Tipo"               ,/*cPicture*/,2,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_NUM"        , "SE2", "Titulo"             ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_PARCELA"	, "SE2", "Parcela"            ,/*cPicture*/,3,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_VALOR"	    , "SE2", "Valor"              ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_SALDO"	    , "SE2", "Saldo"              ,/*cPicture*/,13,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_FORNECE"	, "SE2", "Fornecedor"         ,/*cPicture*/,9,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_LOJA"	    , "SE2", "Loja"               ,/*cPicture*/,4,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "E2_NOMFOR"	    , "SE2", "Nome Fornec"        ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "B1_X_SUBGR"    , "SB1", "Sub Grupo"          ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "D1_COD"	    , "SD1", "Cod Produto"        ,/*cPicture*/,10,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "B1_DESC"	    , "SB1", "Nome Produto"       ,/*cPicture*/,40,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)
TRCell():New(oSection1, "situacao"	    , "SB1", "Situacao"           ,/*cPicture*/,8,/*lPixel*/,/*bBlock*/,/*cAlign*/,/*lLineBreak*/,/*cHeaderAlign*/,/*lCellBreak*/,/*nColSpace*/,/*lAutoSize*/,/*nClrBack*/,/*nClrFore*/,.T.)



//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
         
//O break quebra a linha pelo campo que deseja por fornecedor         
oBreak := TRBreak():New(oSection1,{|| (cAliasTMP)->(E2_FORNECE) },"Total por Fornecedor:")
//faz a soma do conteudo desejado e2_valor
//TRFunction():New(oSection1:Cell("VALOR"),NIL,"SUM" , oBreak, ,"@E 999,999.99",,.F.,.T.)

TRFunction():New(oSection1:Cell("E2_NUM"),NIL,"COUNT",,,,,.F.,.T.)
 


Return oReport


/*
‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±…ÕÕÕÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÀÕÕÕÕÕÕ—ÕÕÕÕÕÕÕÕÕÕÕÕÕª±±
±±∫Programa  ≥REL01PRINT     ∫Autor  ≥Edison        ∫ Data ≥ 18/03/2018   ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ ÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Desc.     ≥                                                            ∫±±
±±∫          ≥                                                            ∫±±
±±ÃÕÕÕÕÕÕÕÕÕÕÿÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕπ±±
±±∫Uso       ≥ AP                                                        ∫±±
±±»ÕÕÕÕÕÕÕÕÕÕœÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕº±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂﬂ
*/
Static Function REL01PRINT(oReport)
Local oSection1		:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)          



//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Efetua montagem da Query da SESS√O DE CHAMADOS ≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
BEGIN REPORT QUERY oSection1
	
	BEGINSQL Alias cAliasTMP
			Column E2_EMISSAO as Date 
			Column E2_VENCREA  as Date  
			
	 SELECT 
           E2.E2_FILIAL,
           F1.F1_EST, 
           E2.E2_EMISSAO, 
           E2.E2_VENCREA, 
           E2.E2_PREFIXO, 
           E2.E2_TIPO, 
           E2.E2_NUM, 
           E2.E2_PARCELA, 
           E2.E2_VALOR,
           E2.E2_SALDO,
           E2.E2_FORNECE, 
           E2.E2_LOJA, 
           E2.E2_NOMFOR, 
           B1.B1_X_SUBGR,
           D1.D1_COD, 
           B1.B1_DESC,
           CASE WHEN E2.E2_SALDO = 0  THEN 'Baixado'
           		WHEN E2.E2_SALDO > 0  THEN 'Aberto' 
           END as situacao
           
           FROM %Table:SE2% E2
                   INNER JOIN %Table:SF1% F1
		           ON  F1.F1_FILIAL = E2.E2_FILIAL
		           AND F1.F1_DOC = E2.E2_NUM
		           AND F1.F1_SERIE = E2.E2_PREFIXO
		           AND F1.F1_FORNECE = E2.E2_FORNECE
		           AND F1.F1_LOJA = E2.E2_LOJA
		           
		           INNER JOIN %Table:SD1% D1
		           ON  D1.D1_FILIAL = F1.F1_FILIAL
		           AND D1.D1_DOC = F1.F1_DOC
		           AND D1.D1_SERIE = F1.F1_PREFIXO
		           AND D1.D1_FORNECE = F1.F1_FORNECE
		           AND D1.D1_LOJA = F1.F1_LOJA
		           
		           INNER JOIN %Table:SB1% B1
		           ON B1.B1_COD = D1.D1_COD
		           
				   	
		   WHERE   E2.%Notdel% 
		   		   AND E2.%Notdel%
		   		   AND D1.%Notdel%
		   		   AND F1.%Notdel%
		   		   AND B1.%Notdel%   
		   		   AND F1.F1_TIPO = 'N'
		           AND E2.E2_FILIAL   >= %Exp:MV_PAR01%       AND E2.E2_FILIAL    <=  %Exp:MV_PAR02%  
		           AND E2.E2_FORNECE  >= %Exp:mv_par03%       AND E2.E2_FORNECE   <=  %Exp:mv_par04%  
		           AND E2.E2_LOJA     >= %Exp:mv_par05%       AND E2.E2_LOJA      <=  %Exp:mv_par06%  
		           AND E2.E2_EMISSAO  >= %Exp:DtoS(mv_par07)% AND E2.E2_EMISSAO   <=  %Exp:DtoS(mv_par08)%  
		           AND E2.E2_VENCREA  >= %Exp:DtoS(mv_par09)% AND E2.E2_VENCREA   <=  %Exp:DtoS(mv_par10)% 
		           AND D1.D1_COD      >= %Exp:mv_par11%       AND D1.D1_COD       <=  %Exp:mv_par12%
		           AND B1.B1_X_SUBGR  >= %Exp:mv_par13%       AND B1.B1_X_SUBGR   <=  %Exp:mv_par14% 
		           
		           
		           GROUP BY E2.E2_FILIAL, F1.F1_EST, E2.E2_EMISSAO, E2.E2_VENCREA, E2.E2_PREFIXO, E2.E2_TIPO, 
                            E2.E2_NUM, E2.E2_PARCELA, E2.E2_VALOR, E2.E2_SALDO, E2.E2_FORNECE,
                            E2.E2_LOJA, E2.E2_NOMFOR, B1.B1_X_SUBGR, D1.D1_COD, B1.B1_DESC
		   		   
		   ORDER BY E2.E2_FILIAL, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_FORNECE, E2.E2_LOJA
    ENDSQL
		
END REPORT QUERY oSection1

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Seta regra de contador do processamento	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹

oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
//Executa a impress„o das sessıes do relatÛrio	≥
//‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹‹
oSection1:Print() 

Return

