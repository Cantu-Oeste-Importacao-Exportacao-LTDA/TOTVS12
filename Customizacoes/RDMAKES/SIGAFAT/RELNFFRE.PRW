#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELNFFRE    ºAutor  ³Gustavo Lattmann º Data ³ 26/08/2015   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório contendo informações de notas por fretes e        º±±
±±º          ³transportadores.                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RELNFFRE()
Private oReport
Private cFile		:= "RELNFFRE"
Private cPerg		:= "RELNFFRE01"
Private cTitle		:= "Notas por Transportadores"
Private cHelp		:= "Este relatório ter por objetivo detalhar informações de notas e fretes."
Private cAliasTMP	:= GetNextAlias()
//Private cAliasTMP2	:= GetNextAlias()

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa funções de verificação do grupo de perguntas utilizado³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
AJUSTASX1()
PERGUNTE(cPerg,.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o objeto pertinente ao processamento do relatório³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := REL01()
oReport:PRINTDIALOG()

Return


Static Function REL01()

Local aOrder := {}

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria o componente de processamento do relatório³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport := TReport():New(cFile, cTitle, cPerg, {|oReport| REL01PRINT(oReport)}, cHelp,,"Total Notas")
oReport:SetLandscape()
oReport:EndReport(.F.)
oReport:SetTotalInLine(.F.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessão principal de CHAMADOS do relatório	³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1 := TRSection():New(oReport,"Notas x Transportador",{"SF2"})
TRCell():New(oSection1, "F2_FILIAL"		, "SF2", "Filial")
TRCell():New(oSection1, "F2_DOC"		, "SF2", "Nota")
TRCell():New(oSection1, "F2_SERIE"		, "SF2", "Série")
TRCell():New(oSection1, "D2_PEDIDO"		, "SD2", "Pedido")
TRCell():New(oSection1, "F2_EMISSAO"	, "SF2", "Emissão") 
TRCell():New(oSection1, "F2_HORA"		, "SF2", "Hora")
TRCell():New(oSection1, "F2_VALBRUT"	, "SF2", "Valor")
TRCell():New(oSection1, "A1_NOME"		, "SA1", "Cliente")
TRCell():New(oSection1, "A1_MUN"		, "SA1", "Cidade")
TRCell():New(oSection1, "A1_EST"		, "SA1", "Estado")
TRCell():New(oSection1, "A4_NOME"		, "SA4", "Transp.")
TRCell():New(oSection1, "A3_NOME"		, "SA4", "Vendedor")
//TRCell():New(oSection1, "Z4_MOTIVO"		, "SZ4", "Motivo")


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Cria a sessão de ITENS DO CHAMADO dentro da sessão CHAMADOS	³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*
oSection2 := TRSection():New(oSection1, "Itens", {"SZ5"})
oSection2:lHeaderVisible := .T.
oSection2:SetLeftMargin(10)
TRCell():New(oSection2, "Z5_ITEM"		, "SZ5", "Item")
TRCell():New(oSection2, "Z5_DATA"		, "SZ5", "Data")
TRCell():New(oSection2, "Z5_HORA"		, "SZ5", "Hora")
TRCell():New(oSection2, "Z5_COMPL"		, "SZ5", "Complemento")
//TRCell():New(oSection2, "Z5_MOTIVO"		, "SZ5", "Motivo")
*/


Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³REL01PRINT     ºAutor  ³Gustavo       º Data ³ 06/06/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function REL01PRINT(oReport)

Local cVazio		:= ""
Local cQuerySec1	:= "%%"
Local oSection1		:= oReport:Section(1)
Local oSection2		:= oReport:Section(1):Section(1)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Prepara variaveis de complemento da Query de busca dos chamados	³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
cQuerySec1 := "%AND F2.F2_FILIAL 	>= '" + MV_PAR01		+ "' AND F2.F2_FILIAL 	<= '" + MV_PAR02 	  	 + "' " + CHR(13)
cQuerySec1 += "AND F2.F2_DOC 	>= '" 	+ MV_PAR03		+ "' AND F2.F2_DOC 	<= '" + MV_PAR04 	  		 + "' " + CHR(13)
cQuerySec1 += "AND F2.F2_SERIE 	>= '" + MV_PAR05		+ "' AND F2.F2_SERIE 	<= '" + MV_PAR06 	 	 + "' " + CHR(13)
cQuerySec1 += "AND ZL.ZL_TRANSP 	>= '" + MV_PAR07		+ "' AND ZL.ZL_TRANSP 	<= '" + MV_PAR08 	 	 + "' " + CHR(13)
cQuerySec1 += " AND F2.F2_EMISSAO >= '" + DTOS(MV_PAR09) 	+ "' AND F2.F2_EMISSAO <= '" + DTOS(MV_PAR10)	 + "'%"

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Efetua montagem da Query da SESSÃO DE CHAMADOS ³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
BEGIN REPORT QUERY oSection1
	
		BEGINSQL Alias cAliasTMP
			Column F2_EMISSAO as Date
			
				SELECT F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE, D2.D2_PEDIDO, F2.F2_EMISSAO,F2.F2_HORA , F2.F2_VALBRUT, A1.A1_NOME, 
						A1.A1_MUN, A1.A1_EST, A4.A4_NOME, A3.A3_NOME
				  FROM %Table:SF2% F2
				  LEFT JOIN %Table:SD2% D2
				    ON F2.F2_FILIAL = D2.D2_FILIAL
				   AND F2.F2_DOC = D2.D2_DOC
				   AND F2.F2_SERIE = D2.D2_SERIE
				   AND D2.%NotDel%
				   AND D2.D2_ITEM = %Exp:'01'%
				  LEFT JOIN %Table:SA1% A1
				    ON F2.F2_CLIENT = A1.A1_COD
				   AND F2.F2_LOJENT = A1.A1_LOJA
				   AND A1.%NotDel%
				  LEFT JOIN %Table:SZL% ZL
				    ON F2.F2_FILIAL = ZL.ZL_FILIAL
				   AND F2.F2_DOC = ZL.ZL_DOC 
				   AND F2.F2_SERIE = ZL.ZL_SERIE
				   AND ZL.%NotDel%
				  LEFT JOIN %Table:SA4% A4
				    ON ZL.ZL_TRANSP = A4.A4_COD
			  	   AND A4.%NotDel%  
				  LEFT JOIN %Table:SA3% A3
				    ON F2.F2_VEND1 = A3.A3_COD
			  	   AND A3.%NotDel%			  	   
			
			WHERE F2.%NotDel%
				%Exp:cQuerySec1%
				
			ORDER BY F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE
		ENDSQL
		
END REPORT QUERY oSection1

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Efetua montagem da Query dos ITENS DO CHAMADOS ³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
/*
BEGIN REPORT QUERY oSection2
	
		BEGINSQL Alias cAliasTMP2
			Column Z5_DATA as Date
			
			SELECT DISTINCT SZ5.Z5_FILIAL, SZ5.Z5_CHAMADO, SZ5.Z5_ITEM, SZ5.Z5_DATA, 
						    SZ5.Z5_HORA, SZ5.Z5_COMPL
					
			
			FROM
				%Table:SZ5% SZ5
			
			WHERE SZ5.Z5_FILIAL = %xFilial:SZ5%
				AND SZ5.Z5_CHAMADO = %report_param: (cAliasTMP)->Z4_COD%
				AND SZ5.%NotDel%
				
			ORDER BY SZ5.Z5_FILIAL, SZ5.Z5_CHAMADO, SZ5.Z5_ITEM
		ENDSQL
		
END REPORT QUERY oSection2
*/
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Seta regra de contador do processamento	³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oReport:SetMeter((cAliasTMP)->(RECCOUNT()))

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa a impressão das sessões do relatório	³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oSection1:Print() 

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Marcelo           º Data ³ 06/06/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável pela criação do grupo de perguntas utili-º±±
±±º          ³zado como parâmetros do relatório.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico Treinamento                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AJUSTASX1()

Local aRegs			:= {}  
Local aHelp1		:= {}
Local aHelp2		:= {}
Local aHelp3		:= {}                                         
Local aHelp4		:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ      
AADD(aRegs, {cPerg, "01", "Filial de      	?", "Filial De        ?", "Filial De	    ?", "mv_ch1"  ,"C",TAMSX3("F2_FILIAL")[1]	,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SF2", "F2_FILIAL")})
AADD(aRegs, {cPerg, "02", "Filial Até	    ?", "Filial Até       ?", "Filial Até	    ?", "mv_ch2"  ,"C",TAMSX3("F2_FILIAL")[1]	,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",PESQPICT("SF2", "F2_FILIAL")})
AADD(aRegs, {cPerg, "03", "Nota De          ?", "Nota De          ?", "Nota De          ?", "mv_ch3"  ,"C",TAMSX3("F2_DOC")[1]		,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "04", "Nota Até         ?", "Nota Até         ?", "Nota Até         ?", "mv_ch4"  ,"C",TAMSX3("F2_DOC")[1] 		,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "05", "Serie De         ?", "Serie De         ?", "Serie De         ?", "mv_ch5"  ,"C",TAMSX3("F2_SERIE")[1]	,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "06", "Serie Até        ?", "Serie Até        ?", "Serie Até        ?", "mv_ch6"  ,"C",TAMSX3("F2_SERIE")[1]	,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "07", "Transportador De ?", "Transportador De ?", "Transportador De ?", "mv_ch7"  ,"C",TAMSX3("F2_TRANSP")[1]	,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "08", "Transportador Até?", "Transportador Até?", "Transportador Até?", "mv_ch8"  ,"C",TAMSX3("F2_TRANSP")[1]	,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "09", "Emissão De      	?", "Emissão De 	  ?", "Emissão De 		?", "mv_ch9"  ,"D",TAMSX3("F2_EMISSAO")[1]	,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs, {cPerg, "10", "Emissão Até		?", "Emissão Até	  ?", "Emissão Até		?", "mv_ch10" ,"D",TAMSX3("F2_EMISSAO")[1]	,0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aHelp1 , "Informa o código inicial de filtro dos     ")       
AADD(aHelp1 , "chamados do relatório.                     ")
AADD(aHelp2 , "Informa o código final de filtro dos       ")       
AADD(aHelp2 , "chamados do relatório.                     ")
AADD(aHelp3 , "Data de inicio para filtro dos chamados    ")
AADD(aHelp3 , "do helpdesk.                               ") 
AADD(aHelp4 , "Data de término para filtro dos chamados   ")
AADD(aHelp4 , "do helpdesk.                               ") 

For nI := 1 To Len(aRegs)
	dbSelectArea("SX1")
	SX1->(dbSetOrder(1))                                                    
	SX1->(dbGoTop())
	If !SX1->(dbSeek(cPerg + aRegs[nI,2]))
		RECLOCK("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[nI])
					FieldPut(j, aRegs[nI,j])
				Endif
			Next
		MSUNLOCK()
	EndIf
Next  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza o Help dos campos no arquivo de Help³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PutSX1Help("P." + cPerg + "01.", aHelp1, aHelp1, aHelp1)
PutSX1Help("P." + cPerg + "02.", aHelp2, aHelp2, aHelp2)
PutSX1Help("P." + cPerg + "03.", aHelp3, aHelp3, aHelp3)
PutSX1Help("P." + cPerg + "04.", aHelp4, aHelp4, aHelp4)

Return