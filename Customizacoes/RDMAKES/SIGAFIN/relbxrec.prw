#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELBXREC บAutor ณEdison Greski Barbieri บ Data ณ 13/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio contendo informa็๕es de baixas por                บฑฑ
ฑฑบ          ณrecibos.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELBXREC()
Private oReport
Private cFile		:= "RELBXREC"
Private cPerg		:= "RELBXREC01"
Private cTitle		:= "Baixas por recibos"
Private cHelp		:= "Este relat๓rio ter por objetivo detalhar informa็๕es de baixas por recibos."
Private cAliasTMP	:= GetNextAlias()


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa fun็๕es de verifica็ใo do grupo de perguntas utilizadoณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

//AjusteSX1(cPerg)
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
oSection1 := TRSection():New(oReport,"Baixa por recibos",{"SE5"})
TRCell():New(oSection1, "EL_FILIAL"		, "SEL", "Filial")
TRCell():New(oSection1, "EL_RECIBO"    	, "SEL", "Recibo")
TRCell():New(oSection1, "EL_NUMERO"     , "SEL", "Titulo")
TRCell():New(oSection1, "EL_PARCELA"	, "SEL", "Parcela")
TRCell():New(oSection1, "E1_VALOR"      , "SE1", "Valor titulo") 
TRCell():New(oSection1, "E1_SALDO"  	, "SE1", "Saldo P/ Baixar")
TRCell():New(oSection1, "E5_VALOR"		, "SE5", "Vlr Baixado")
TRCell():New(oSection1, "E5_VLMULTA"    , "SE5", "Vlr Mt")
TRCell():New(oSection1, "E5_VLJUROS"	, "SE5", "Vlr Jr")
TRCell():New(oSection1, "E5_VLDESCO"	, "SE5", "Vlr Desc")
TRCell():New(oSection1, "EL_EMISSAO"    , "SEL", "Emissao Rec")
TRCell():New(oSection1, "E1_EMISSAO"    , "SE1", "Emissao Tit")
TRCell():New(oSection1, "E1_VENCREA"    , "SE1", "Vencimento")
TRCell():New(oSection1, "E5_DATA"	    , "SE5", "Baixa")
TRCell():New(oSection1, "E1_PORTADO"    , "SE1", "Banco")
TRCell():New(oSection1, "E1_TIPO"       , "SE1", "Tipo")
TRCell():New(oSection1, "E1_CLIENTE"    , "SE1", "Cliente")
TRCell():New(oSection1, "E1_LOJA"       , "SE1", "Loja")
TRCell():New(oSection1, "E1_NOMCLI"     , "SE1", "N. Cliente")
TRCell():New(oSection1, "E5_TIPODOC"    , "SE5", "Tp Doc")
TRCell():New(oSection1, "E5_HISTOR"     , "SE5", "Hist๓rico")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL01PRINT     บAutor  ณEdison        บ Data ณ 17/07/2016   บฑฑ
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
			Column EL_EMISSAO as Date  
			Column E1_EMISSAO as Date  
			Column E1_VENCREA as Date
			Column E5_DATA    as Date  
			
	 SELECT 
         
           EL.EL_FILIAL,
           EL.EL_RECIBO,
           EL.EL_NUMERO,
           EL.EL_PARCELA,
           E1.E1_VALOR,
           E1.E1_SALDO,
           E5.E5_VALOR,
           E5.E5_VLMULTA,
           E5.E5_VLJUROS,
           E5.E5_VLDESCO,
           EL.EL_EMISSAO,
           E1.E1_EMISSAO,
           E1.E1_VENCREA,
           E5.E5_DATA,
           E1.E1_PORTADO,
           E1.E1_TIPO,
           E1.E1_CLIENTE,
           E1.E1_LOJA,
           E1.E1_NOMCLI,
           E5.E5_TIPODOC,
           E5.E5_HISTOR       
           FROM %Table:SEL% EL
		      INNER JOIN %Table:SE1% E1 
				   ON EL.EL_FILIAL = E1.E1_FILIAL 
				   AND EL.EL_NUMERO = E1.E1_NUM
				   AND EL.EL_PARCELA = E1.E1_PARCELA
				   AND EL.EL_CLIORIG = E1.E1_CLIENTE
				   AND EL.EL_LOJORIG = E1.E1_LOJA
				   AND EL.EL_TIPO = E1.E1_TIPO
				   
				   LEFT JOIN %Table:SE5% E5
				   ON  E5.E5_FILIAL = EL.EL_FILIAL 
				   AND E5.E5_NUMERO = EL.EL_NUMERO
				   AND E5.E5_PARCELA = EL.EL_PARCELA
				   AND E5.E5_CLIFOR = EL.EL_CLIORIG
				   AND E5.E5_LOJA = EL.EL_LOJORIG
				   AND E5.E5_TIPO = EL.EL_TIPO
				   
			
			WHERE  E1.E1_FILIAL >= %Exp:MV_PAR01% AND E1.E1_FILIAL	<= %Exp:MV_PAR02%
		           AND El.EL_RECIBO >= %Exp:MV_PAR03% AND El.EL_RECIBO  <= %Exp:MV_PAR04%	
                   AND EL.%Notdel%
                   AND E1.%Notdel%
                   //AND E5.%Notdel%
                   AND (E5.E5_TIPODOC NOT IN ('DB','JR', 'MT','DC')
                   OR   E1.E1_SALDO >0)     			
			
				   	
		    order by EL.EL_FILIAL, El.EL_RECIBO, EL.EL_NUMERO, EL.EL_PARCELA
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
Static Function VldPerg(cPerg)
PutSx1(cPerg,"01","Filial  De        ?"      ,"Filial De         ?"         ,"Filial De           ?"      ,"MV_CH1"  ,"C",02,0,0 ,"G","","   ", "", "","MV_PAR01")
PutSx1(cPerg,"02","Filial At้        ?"      ,"Filial At้        ?"         ,"Filial At้          ?"      ,"MV_CH2"  ,"C",02,0,0 ,"G","","   ","",""  ,"MV_PAR02")
PutSx1(cPerg,"03","Recibo  De        ?"      ,"Recibo De         ?"         ,"Recibo De           ?"      ,"MV_CH3"  ,"C",06,0,0 ,"G","","   ", "", "","MV_PAR03")
PutSx1(cPerg,"04","Recibo  At้       ?"      ,"Recibo At้        ?"         ,"Recibo At้          ?"      ,"MV_CH4"  ,"C",06,0,0 ,"G","","   ", "", "","MV_PAR04")



Return