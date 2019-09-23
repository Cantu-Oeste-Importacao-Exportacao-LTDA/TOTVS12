#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELDESC บAutor  ณEdison Greski Barbieri บ Data ณ 08/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio contendo informa็๕es de descontos เ               บฑฑ
ฑฑบ          ณclientes.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELDESC()
Private oReport
Private cFile		:= "RELDESC"
Private cPerg		:= "RELDESC01"
Private cTitle		:= "Descontos a Clientes"
Private cHelp		:= "Este relat๓rio ter por objetivo detalhar informa็๕es de descontos financeiros."
Private cAliasTMP	:= GetNextAlias()


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa fun็๕es de verifica็ใo do grupo de perguntas utilizadoณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

PutSX1(cPerg)
PERGUNTE(cPerg,.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o objeto pertinente ao processamento do relat๓rioณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {}

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o componente de processamento do relat๓rioณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos os tํtulos")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessใo principal de CHAMADOS do relat๓rio	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1 := TRSection():New(oReport,"Notas x Transportador",{"SF2"})
TRCell():New(oSection1, "E1_FILIAL"		, "SE1", "Filial")
TRCell():New(oSection1, "DATA_BAIXA" 	, "SE5", "Baixa")
TRCell():New(oSection1, "E1_VENCREA"    , "SE1", "Vencto")
TRCell():New(oSection1, "E1_NOMCLI"		, "SE1", "Cliente")
TRCell():New(oSection1, "E1_CLIENTE"	, "SE1", "Cod. Cliente") 
TRCell():New(oSection1, "E1_LOJA"		, "SE1", "Loja")
TRCell():New(oSection1, "E1_PREFIXO"	, "SE1", "Prefixo")
TRCell():New(oSection1, "E1_NUM"		, "SE1", "Tํtulo")
TRCell():New(oSection1, "E1_PARCELA"	, "SE1", "Parcela")
TRCell():New(oSection1, "E1_TIPO"		, "SE1", "Tipo")
TRCell():New(oSection1, "E1_VALOR"		, "SE1", "Valor")
TRCell():New(oSection1, "E1_DESCFIN"	, "SE1", "% Descfin")
TRCell():New(oSection1, "E1_DECRESC"	, "SE1", "R$ Decrescimo")
TRCell():New(oSection1, "VLR_DESC_BAIXADO"	, "SE5", "R$ Desc baixado")
TRCell():New(oSection1, "VLR_DESC_CORRETO"	, "SE5", "R$ Desc correto")
TRCell():New(oSection1, "DIFERENCA"	    , "SE5", "R$ Diferen็a")                                        

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL01PRINT     บAutor  ณEdison       บ Data ณ 06/06/2014   บฑฑ
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
			Column DATA_BAIXA as Date  
			Column E1_VENCREA as Date  
			
	 SELECT  DISTINCT
         
          (SELECT
           SUM(E51.E5_VLDESCO)
           FROM %Table:SE5% E51
           WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           AND E51.E5_LOJA      =   E5.E5_LOJA
           AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           AND E51.E5_PARCELA   =   E5.E5_PARCELA
           AND E51.E5_TIPO      =   E5.E5_TIPO
           AND E51.E5_SITUACA <> 'C' 
           AND E5.E5_SITUACA <> 'C' 
           AND E51.%Notdel%                 
           AND E5.%Notdel%
           ) AS VLR_DESC_BAIXADO,
		   
		   (SELECT
           MAX(E51.E5_DATA)
           FROM %Table:SE5% E51
           WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           AND E51.E5_LOJA      =   E5.E5_LOJA
           AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           AND E51.E5_PARCELA   =   E5.E5_PARCELA
           AND E51.E5_TIPO      =   E5.E5_TIPO  
           AND E51.E5_SITUACA <> 'C'
           AND E5.E5_SITUACA <> 'C'
           AND E51.%Notdel%
           AND E5.%Notdel%
           ) AS DATA_BAIXA,
           
           E1.E1_FILIAL,
           E1.E1_VENCREA,
		   E1.E1_NOMCLI, 
		   E1.E1_CLIENTE,
		   E1.E1_LOJA,
		   E1.E1_PREFIXO,
		   E1.E1_NUM,
		   E1.E1_PARCELA,
		   E1.E1_TIPO,
		   E1.E1_VALOR,
		   E1.E1_DESCFIN,
		   E1.E1_DECRESC,
		   round((E1.E1_VALOR * E1.E1_DESCFIN / 100) + E1.E1_DECRESC,2)  AS VLR_DESC_CORRETO,
		   CASE 
		    	WHEN E1.E1_DESCFIN <> 0
			  		THEN 
           round((SELECT
           SUM(E51.E5_VLDESCO)
           FROM %Table:SE5% E51
           WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           AND E51.E5_LOJA      =   E5.E5_LOJA
           AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           AND E51.E5_PARCELA   =   E5.E5_PARCELA
           AND E51.E5_TIPO      =   E5.E5_TIPO 
           AND E51.E5_SITUACA <> 'C'
           AND E5.E5_SITUACA <> 'C'
           AND E51.%Notdel%
           AND E5.%Notdel%
           ),2)  - round((E1.E1_VALOR * E1.E1_DESCFIN / 100),2)
			   	ELSE 
           round((SELECT
           SUM(E51.E5_VLDESCO)
           FROM %Table:SE5% E51
           WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           AND E51.E5_LOJA      =   E5.E5_LOJA
           AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           AND E51.E5_PARCELA   =   E5.E5_PARCELA
           AND E51.E5_TIPO      =   E5.E5_TIPO 
           AND E51.E5_SITUACA <> 'C'
           AND E5.E5_SITUACA <> 'C'
           AND E51.%Notdel%
           AND E5.%Notdel%
           ),2)  - round(E1.E1_DECRESC,2)
           END AS DIFERENCA
                
    FROM %Table:SE5% E5
		      LEFT JOIN %Table:SE1% E1 
				   ON  E5.E5_FILIAL = E1.E1_FILIAL
				   AND E5.E5_CLIENTE = E1.E1_CLIENTE
				   AND E5.E5_LOJA = E1.E1_LOJA 
				   AND E5.E5_PREFIXO = E1.E1_PREFIXO 
				   AND E5.E5_NUMERO = E1.E1_NUM 
				   AND E5.E5_PARCELA = E1.E1_PARCELA 
				   AND E5.E5_TIPO = E1.E1_TIPO   
				   AND E5.E5_SITUACA <> 'C'

				   	
		 	WHERE  E5.%Notdel%      
				   AND E1.%Notdel%
           		   AND E5.E5_SITUACA <> 'C'
		 		   AND E5.E5_FILIAL >= %Exp:MV_PAR01% AND E5.E5_FILIAL	<= %Exp:MV_PAR02% 
		 		   AND E5.E5_DATA >= %Exp:DTOS(MV_PAR03)% AND E5.E5_DATA <= %Exp:DTOS(MV_PAR04)%
		 		   //AND (E1.E1_DESCFIN <> %Exp:0% OR E1.E1_DECRESC <> %Exp:0%)      
		 		   AND E1.E1_SALDO = %Exp:0%
				   AND E1.E1_TIPO IN (%Exp:'NF'%, %Exp:'FT'%)	
				   AND (SELECT
        		        SUM(E51.E5_VLDESCO)
           		        FROM %Table:SE5% E51
           				WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           				AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           				AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           				AND E51.E5_LOJA      =   E5.E5_LOJA
           				AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           				AND E51.E5_PARCELA   =   E5.E5_PARCELA
           				AND E51.E5_TIPO      =   E5.E5_TIPO 
           				AND E51.E5_SITUACA <> 'C'
           				AND E5.E5_SITUACA <> 'C'
           				AND E51.%Notdel%
                        AND E5.%Notdel%
          			    ) - round(E1.E1_DECRESC,2) > 1
				   AND round((SELECT
                        SUM(E51.E5_VLDESCO)
                        FROM %Table:SE5% E51
                        WHERE  E51.E5_FILIAL =   E5.E5_FILIAL
           				AND E51.E5_NUMERO    =   E5.E5_NUMERO 
           				AND E51.E5_CLIFOR    =   E5.E5_CLIFOR
           				AND E51.E5_LOJA      =   E5.E5_LOJA
           				AND E51.E5_PREFIXO   =   E5.E5_PREFIXO
           				AND E51.E5_PARCELA   =   E5.E5_PARCELA
           				AND E51.E5_TIPO      =   E5.E5_TIPO 
           				AND E51.E5_SITUACA <> 'C'
           				AND E5.E5_SITUACA <> 'C'
           				AND E51.%Notdel%
                        AND E5.%Notdel%
                        ),2)  - round((E1.E1_VALOR * E1.E1_DESCFIN / 100),2) > 1                       


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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPutSX1  บAutor  ณMarcelo           บ Data ณ 06/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela cria็ใo do grupo de perguntas utili-บฑฑ
ฑฑบ          ณzado como parโmetros do relat๓rio.                          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico Treinamento                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldPerg(cPerg)
PutSx1(cPerg,"01","Filial  De        ?"      ,"Filial De         ?"         ,"Filial De           ?"      ,"MV_CH1"  ,"C",02,0,0 ,"G","","   ", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial At้        ?"      ,"Filial At้        ?"         ,"Filial At้          ?"      ,"MV_CH2"  ,"C",02,0,0 ,"G","","   ","",""  ,"MV_PAR02")
PutSX1(cPerg,"03","Data baixa de 	 ?"	     ,"Data baixa de 	 ?"         ,"Data baixa de       ?"      ,"MV_CH3"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Data baixa At้  	 ?"	     ,"Data baixa At้  	 ?"         ,"Data baixa At้      ?"      ,"MV_CH4"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR04","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")



Return