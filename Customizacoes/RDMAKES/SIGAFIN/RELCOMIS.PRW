#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCOMIS บAutor ณEdison Greski Barbieri บ Data ณ 13/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio contendo informa็๕es de comiss๕es por             บฑฑ
ฑฑบ          ณvendedor.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Financeiro                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELCOMIS()
Private oReport
Private cFile		:= "RELCOMIS"
Private cPerg		:= "RELCOMIS01"
Private cTitle		:= "Comissใo vendedor"
Private cHelp		:= "Este relat๓rio ter por objetivo detalhar as comiss๕es dos vendedores."
Private cAliasTMP	:= GetNextAlias()


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa fun็๕es de verifica็ใo do grupo de perguntas utilizadoณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
VldPerg(cPerg)  // Chama funcao VldPerg para Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
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
oSection1 := TRSection():New(oReport,"Comissใo vendedor",{"SE5"})
TRCell():New(oSection1, "E5_FILIAL"		       , "SE5", "Filial")
TRCell():New(oSection1, "E1_VEND1"             , "SE1", "Vendedor")
TRCell():New(oSection1, "E1_EMISSAO"           , "SE1", "Emissao")
TRCell():New(oSection1, "E5_DATA"		       , "SE1", "Baixa")
TRCell():New(oSection1, "E5_NUMERO"	           , "SE5", "Titulo") 
TRCell():New(oSection1, "E5_PARCELA"	       , "SE5", "Parcela")
TRCell():New(oSection1, "E5_PREFIXO"	       , "SE5", "Prefixo")
TRCell():New(oSection1, "E5_TIPO"	           , "SE5", "Tipo")
TRCell():New(oSection1, "VLR_TITULO"	       , "SE5", "Vlr Titulo")
TRCell():New(oSection1, "E1_COMIS1" 	       , "SE1", "% Comissao")
TRCell():New(oSection1, "VL_COMISSAO_MANUAL"   , "SE5", "Vlr Comissao")
TRCell():New(oSection1, "E5_TIPODOC"	       , "SE5", "Tipo mov")

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
			Column E1_EMISSAO as Date 
			Column E5_DATA    as Date 	 
			
	 SELECT 
         
           E1.E1_VEND1,
           E5.E5_FILIAL,
		   E1.E1_EMISSAO, 
		   E5.E5_DATA,
		   E5.E5_NUMERO,
		   E5.E5_PARCELA,
		   E5.E5_PREFIXO,
		   E5.E5_TIPO,
		   E5.E5_VALOR - E5.E5_VLJUROS - E5.E5_VLMULTA AS VLR_TITULO,
		   E1.E1_COMIS1,
		   ROUND(E5.E5_VALOR * E1.E1_COMIS1 / 100,2) AS VL_COMISSAO_MANUAL,
		   E5.E5_TIPODOC      
           FROM %Table:SE5% E5
		      LEFT JOIN %Table:SE1% E1 
				   ON  E5.E5_FILIAL = E1.E1_FILIAL 
				   AND E5.E5_TIPO = E1.E1_TIPO 
				   AND E5.E5_PREFIXO = E1.E1_PREFIXO 
				   AND E5.E5_NUMERO = E1.E1_NUM 
				   AND E5.E5_PARCELA = E1.E1_PARCELA
				   AND E5.E5_CLIFOR = E1.E1_CLIENTE
				   AND E5.E5_LOJA = E1.E1_LOJA 

		      WHERE  E5.%Notdel%      
				   AND E1.%Notdel%
		 		   AND E5.E5_FILIAL >= %Exp:MV_PAR01%       AND E5.E5_FILIAL	<= %Exp:MV_PAR02% 
		 		   AND E1.E1_VEND1  >= %Exp:MV_PAR03%       AND E1.E1_VEND1 	<= %Exp:MV_PAR04%  
		 		   AND E5.E5_DATA   >= %Exp:DTOS(MV_PAR05)% AND E5.E5_DATA      <= %Exp:DTOS(MV_PAR06)%     		 		  
				   AND E5.E5_TIPODOC NOT IN ('DC', 'JR','MT','DB')
		
		    order by E5.E5_DATA    

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
PutSX1(cPerg,"03","Vendedor de   	 ?"	     ,"Vendedor de    	 ?"         ,"Vendedor de         ?"      ,"MV_CH3"  ,"C",006,0,0,"G","","","",""     ,"MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Vendedor At้  	 ?"	     ,"Vendedor At้  	 ?"         ,"Vendedor At้        ?"      ,"MV_CH4"  ,"C",006,0,0,"G","","","",""     ,"MV_PAR04","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"05","Data de       	 ?"	     ,"Data de      	 ?"         ,"Data de             ?"      ,"MV_CH5"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR05","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"06","Data At้     	 ?"	     ,"Data At้     	 ?"         ,"Data At้            ?"      ,"MV_CH6"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR06","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")



Return