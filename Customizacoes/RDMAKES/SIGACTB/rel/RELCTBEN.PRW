#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRELCTBEN บAutor ณEdison Greski Barbieri บ Data ณ 13/07/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio contendo informa็๕es de notas do compras nใo      บฑฑ
ฑฑบ          ณcontabilizadas.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Contabilidade                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELCTBEN()
Private oReport
Private cFile		:= "RELCTBEN"
Private cPerg		:= "RELCTBEN01"
Private cTitle		:= "Nใo Contabilizadas Compras"
Private cHelp		:= "Este relat๓rio ter por objetivo detalhar as nใo contabilizadas do compras."
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
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Todos as notas")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessใo principal de CHAMADOS do relat๓rio	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1 := TRSection():New(oReport,"Nใo contabilizadas",{"SF1"})
TRCell():New(oSection1, "F1_FILIAL"		       , "SF1", "Filial")
TRCell():New(oSection1, "F1_DTDIGIT"           , "SF1", "Dt Digita็ใo")
TRCell():New(oSection1, "F1_EMISSAO"           , "SF1", "Emissao")
TRCell():New(oSection1, "F1_DOC"		       , "SF1", "Nota")
TRCell():New(oSection1, "F1_SERIE"	           , "SF1", "S้rie") 
TRCell():New(oSection1, "F1_FORNECE"	       , "SF1", "Fornecedor")
TRCell():New(oSection1, "F1_LOJA"	           , "SF1", "Loja")
TRCell():New(oSection1, "D1_VUNIT"	           , "SD1", "Valor")
TRCell():New(oSection1, "D1_TES"     	       , "SD1", "Tes")

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREL01PRINT     บAutor  ณEdison        บ Data ณ 18/07/2017   บฑฑ
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
			Column F1_DTDIGIT as Date 
			Column F1_EMISSAO as Date 	 
			
	 SELECT 
         
           F1.F1_FILIAL,
           F1.F1_DTDIGIT,
		   F1.F1_EMISSAO, 
		   F1.F1_DOC,
		   F1.F1_SERIE,
		   F1.F1_FORNECE,
		   F1.F1_LOJA,
		   D1.D1_VUNIT,
		   D1.D1_TES
           FROM %Table:SF1% F1
		      LEFT JOIN %Table:SD1% D1 
				   ON  F1.F1_FILIAL = D1.D1_FILIAL 
				   AND F1.F1_SERIE = D1.D1_SERIE
				   AND F1.F1_DOC = D1.D1_DOC
				   AND F1.F1_FORNECE = D1.D1_FORNECE
				   AND F1.F1_LOJA = D1.D1_LOJA

		      WHERE  F1.%Notdel%      
				   AND D1.%Notdel%
		 		   AND F1.F1_FILIAL >= %Exp:MV_PAR01%       AND F1.F1_FILIAL	<= %Exp:MV_PAR02% 
		 		   AND F1.F1_DTDIGIT   >= %Exp:DTOS(MV_PAR03)% AND F1.F1_DTDIGIT      <= %Exp:DTOS(MV_PAR04)%     
		 		   AND F1_DTLANC = ' '
                   AND NOT EXISTS ( SELECT * FROM  %Table:CV3%
    			                  WHERE D_E_L_E_T_ =  ' ' 	
    					          AND CV3_RECORI = F1.R_E_C_N_O_
    		 				      AND CV3_TABORI='SF1' )     
    		 				      
    		  //GROUP BY F1.F1_FILIAL, F1.F1_DTDIGIT, F1.F1_EMISSAO, F1.F1_DOC, F1.F1_SERIE, F1.F1_FORNECE, F1.F1_LOJA, F1.F1_VALBRUT				      
              ORDER BY F1.F1_FILIAL,F1.F1_DTDIGIT,F1.F1_DOC,F1.F1_SERIE,F1.F1_FORNECE,F1.F1_LOJA
		


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
PutSX1(cPerg,"03","Data de       	 ?"	     ,"Data Dtg de     	 ?"         ,"Data Dtg de         ?"      ,"MV_CH3"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR03","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"04","Data At้     	 ?"	     ,"Data Dgt At้    	 ?"         ,"Data Dgt At้        ?"      ,"MV_CH4"  ,"D",008,0,0,"G","","","",""     ,"MV_PAR04","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")



Return