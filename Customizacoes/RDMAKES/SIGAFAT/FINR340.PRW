#Include "FINR340.CH"
#Include "PROTHEUS.CH"
#Define I_CORRECAO_MONETARIA         1
#Define I_DESCONTO                   2
#Define I_JUROS                      3
#Define I_MULTA                      4
#Define I_VALOR_RECEBIDO             5                                        
#Define I_VALOR_PAGO                 6
#Define I_RECEB_ANT                  7
#Define I_PAGAM_ANT                  8
#Define I_MOTBX                      9

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR340  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Clientes                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR340(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAFIN													  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauricio   ³21/11/97³13526 ³ Nao imprimir subtotal com valores zerados³±±
±±³ Mauricio   ³08/12/97³xxxxx ³ Corrigir array de situacao de titulos    ³±±
±±³ Mauricio   ³28/06/98³xxxxx ³ Considerar numero titulos c/12 posicoes  ³±±
±±³ Mauricio   ³02/07/98³xxxxx ³ Alinhar relatorio                        ³±±
±±³ Andreia    ³05/10/98³xxxxx ³ Ajustar lay-out para ativar Set Century  ³±±
±±³ Wagner     ³27/11/98³xxxxx ³ Acerto cabecalho                         ³±±
±±³ Andreia    ³11/01/99³xxxxx ³ Ordenacao por ordem alfabetica.          ³±±
±±³ Julio      ³24.06.99³22201A³ Valores significativos impressos entre   ³±±
±±³            ³        ³      ³ parˆnteses caso Valor < 0                ³±±
±±³ Julio      ³29.07.99³META  ³ Interpretar MV_CRNEG                     ³±±
±±³ Mauricio   ³10/08/99³23192A³ Considerar Cliente/Loja na verificacao   ³±±
±±³            ³        ³      ³ de baixas do titulo.                     ³±±
±±³ Pilar	   ³04/10/99³      ³ Melhoria de Performance                  ³±±
±±³ Julio W	   ³30.11.99³META  ³ Interpretar filtro do usuario            ³±±
±±³ MAURICIO   ³09.12.99³xxxxxx³Corrigir filtro usuario                   ³±±
±±³ Bruno      ³10.02.00³xxxxx ³Corrigir o saldo en moeda > 1 (usar nSaldo³±±
±±³            ³        ³      ³ que ‚ o certo r n„o SE1->E1_SALDO).      ³±±
±±³            ³        ³      ³Substarir nos Subtotais o valor pago, usar³±±
±±³            ³        ³      ³ o ABS na chamada da ImpSubTot().         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinR340A()

Local oReport
Local aArea := GetArea()
Local cFilAtu := cFilAnt
AjustaSX1(PadR("FIN340", Len(SX1->X1_GRUPO)))  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If FindFunction("TRepInUse") .And. TRepInUse()
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	U_FinR340R3() // Executa versão anterior do fonte
Endif

cFilAnt := cFilAtu
RestArea(aArea)  
                             
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ ReportDef º Autor ³ Marcio Menon		   º Data ³  16/08/06  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Definicao do objeto do relatorio personalizavel e das      º±±
±±º          ³ secoes que serao utilizadas.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ EXPC1 - Grupo de perguntas do relatorio                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 												                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3
Local cReport 	:= "FINR340"	// Nome do relatorio
Local cDescri 	:= OemToAnsi(STR0001)+ OemToAnsi(STR0002)	//"Este programa ir  emitir a posi‡„o de clientes " "referente a data base do sistema."
Local cTitulo 	:= OemToAnsi(STR0005)	//"Posicao dos Clientes "
Local cPerg		:= PadR("FIN340",len(SX1->X1_GRUPO))	// Nome do grupo de perguntas
Local aOrdem	:= {OemToAnsi(STR0020),OemToAnsi(STR0021)}	//"Por Codigo"###"Por Nome"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN340",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // do Cliente                            ³
//³ mv_par02            // Ate o Cliente                         ³
//³ mv_par03            // Da Loja                               ³
//³ mv_par04            // Ate a Loja                            ³
//³ mv_par05            // Da Emissao                            ³
//³ mv_par06            // Ate a Emissao                         ³
//³ mv_par07            // Do Vencimento                         ³
//³ mv_par08            // Ate o Vencimento                      ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios        ³
//³ mv_par10            // Qual a moeda                          ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto      ³
//³ mv_par12            // Considera Faturados                   ³
//³ mv_par13            // Imprime Outras Moedas                 ³
//³ mv_par14            // Considera Data Base                   ³
//³ mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)³
//³ mv_par16            // Natureza De ?                         ³
//³ mv_par17            // Natureza Ate?                         ³
//³ mv_par18            // Considera Liquidados?                 ³
//³ mv_par19            // Cons. Baixas por Recibo?              ³
//³ mv_par20		 	// Consid Filiais  ?  					³
//³ mv_par21		 	// da filial							³
//³ mv_par22		 	// a flial 								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oReport := TReport():New(cReport, cTitulo + " - " + GetMv("MV_MOEDA"+Str(mv_par10,1)), cPerg, {|oReport| ReportPrint(oReport, cTitulo)}, cDescri) 

oReport:SetLandscape() 		//Imprime o relatorio no formato paisagem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³                                                                        ³
//³                      Definicao das Secoes                              ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 01                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport, STR0034,"SA1", aOrdem) //"Dados do Cliente"

TRCell():New(oSection1,"TXTCLI"  ,     , STR0035	,									,10						,/*lPixel*/,{|| STR0015 })	//"Cliente ## CLIENTE : "
TRCell():New(oSection1,"A1_COD"  ,"SA1",  			,PesqPict("SA1","A1_COD" ),TamSX3("A1_COD" )[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_LOJA" ,"SA1",			,PesqPict("SA1","A1_LOJA"),TamSX3("A1_LOJA")[1],/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection1,"A1_NOME" ,"SA1",			,PesqPict("SA1","A1_NOME"),TamSX3("A1_NOME")[1],/*lPixel*/,{|| IIF(mv_par15 == 1, SA1->A1_NOME, SA1->A1_NREDUZ) } )

oSection1:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 02                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2 := TRSection():New(oSection1, STR0036,, aOrdem) //"Titulos"

TRCell():New(oSection2,"E1_PREFIXO"	, "SE1" , STR0037	, PesqPict("SE1","E1_PREFIXO") 	, TamSX3("E1_PREFIXO")[1] ,/*lPixel*/,{ || SE1->E1_PREFIXO })//"Prf"
TRCell():New(oSection2,"E1_NUM"	  	, "SE1" , STR0038 	, PesqPict("SE1","E1_NUM") 	 	, TamSX3("E1_NUM")[1]     ,/*lPixel*/,{ || SE1->E1_NUM 		})//"Numero"
TRCell():New(oSection2,"E1_PARCELA"	, "SE1" , STR0039	, PesqPict("SE1","E1_PARCELA")	, TamSX3("E1_PARCELA")[1] ,/*lPixel*/,{ || SE1->E1_PARCELA })//"PC"
TRCell():New(oSection2,"E1_TIPO"  	, "SE1" ,			, PesqPict("SE1","E1_TIPO")    	, TamSX3("E1_TIPO")[1]    ,/*lPixel*/,{ || SE1->E1_TIPO		})
TRCell():New(oSection2,"VALOR"	   	,       , STR0040 	, 									, 14 ,/*lPixel*/,/*CodeBlock*/) //"Valor Original"
TRCell():New(oSection2,"E1_EMISSAO", "SE1" , STR0041 	, PesqPict("SE1","E1_EMISSAO") 	, TamSX3("E1_EMISSAO")[1] ,/*lPixel*/,{ || SE1->E1_EMISSAO })//"Emissao"
TRCell():New(oSection2,"E1_VENCREA", "SE1" , STR0042 	, PesqPict("SE1","E1_VENCREA") 	, TamSX3("E1_VENCREA")[1] ,/*lPixel*/,{ || SE1->E1_VENCREA })//"Vencto"
TRCell():New(oSection2,"BAIXA" 		,  	 	, STR0043	, PesqPict("SE1","E1_BAIXA")   	, TamSX3("E1_BAIXA")[1]   ,/*lPixel*/,/*CodeBlock*/)	//"Baixa"
TRCell():New(oSection2,"DESCON" 	,       , STR0044	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Descontos"
TRCell():New(oSection2,"ABATIM" 	,       , STR0045	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Abatimentos"
TRCell():New(oSection2,"JUROS" 		,       , STR0046	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Juros"
TRCell():New(oSection2,"MULTA" 		,       , STR0047	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Multa"
//TRCell():New(oSection2,"CMONE" 		,       , STR0048	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Corr. Monet."
TRCell():New(oSection2,"ATPAG" 		,       , "Atr Pg"	, Tm(0,6) 						, 6 ,/*lPixel*/,/*CodeBlock*/) //"Atr pg"
TRCell():New(oSection2,"ATTIT" 		,       , "Atr Tit"	, Tm(0,7) 						, 7 ,/*lPixel*/,/*CodeBlock*/) //"Atr Tit"
TRCell():New(oSection2,"VLRBAIXA"	,       , STR0049	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Valor Baixado"
TRCell():New(oSection2,"RECANTEC" 	,       , STR0050	, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Rec. Antecip."
TRCell():New(oSection2,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/)
TRCell():New(oSection2,"SALDO" 		,       , STR0051	, 								, 15 ,/*lPixel*/,/*CodeBlock*/) //"Saldo Atual"
TRCell():New(oSection2,"MOTIVO" 	,       , STR0052	, 								, 15 ,/*lPixel*/,/*CodeBlock*/) //"Motivo"
TRCell():New(oSection2,"SITUACAO"	,       , STR0053	, 								, 10 ,/*lPixel*/,/*CodeBlock*/) //"Situacao"
TRCell():New(oSection2,"E1_PORTADO", "SE1" , STR0054	, 								, 03 ,/*lPixel*/,{ || SE1->E1_PORTADO })	//"Port."

//Faz o alinhamento do cabecalho das celulas
oSection2:Cell("DESCON"	 ):SetHeaderAlign("CENTER")
oSection2:Cell("ABATIM"	 ):SetHeaderAlign("CENTER")
oSection2:Cell("JUROS"	 ):SetHeaderAlign("CENTER")
oSection2:Cell("MULTA"	 ):SetHeaderAlign("CENTER")
//oSection2:Cell("CMONE"	 ):SetHeaderAlign("CENTER")
oSection2:Cell("ATPAG"	 ):SetHeaderAlign("CENTER")
oSection2:Cell("ATTIT"	 ):SetHeaderAlign("CENTER")

oSection2:Cell("VLRBAIXA"):SetHeaderAlign("CENTER")
oSection2:Cell("RECANTEC"):SetHeaderAlign("CENTER")
oSection2:Cell("SALDO"	 ):SetHeaderAlign("CENTER")

oSection2:SetLineBreak(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 03                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3 := TRSection():New(oSection2, STR0055) //"Totais"

TRCell():New(oSection3,"TXTTOTAL"	,       , STR0055	,								     , 15 ,/*lPixel*/,/*CodeBlock*/) //"Totais"	
TRCell():New(oSection3,"VALOR"	 	,		, STR0040 , PesqPict("SE1","E1_VALOR") 	, 17 ,/*lPixel*/,/*CodeBlock*/)//"Valor Original"
TRCell():New(oSection3,"E1_EMISSAO", "SE1" , STR0041	, 							, 08 ,/*lPixel*/,/*CodeBlock*/) //"Emissao"
TRCell():New(oSection3,"E1_VENCREA", "SE1" , STR0042 	,							, 08 ,/*lPixel*/,/*CodeBlock*/) //"Vencto"
TRCell():New(oSection3,"E1_BAIXA"  , "SE1" , STR0043 	, 							, 08 ,/*lPixel*/,/*CodeBlock*/) //"Baixa"
TRCell():New(oSection3,"DESCON"		,       , STR0044 	, Tm(0,13)           	   	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Descontos"
TRCell():New(oSection3,"ABATIM"		, 	    , STR0045	, Tm(0,13)              	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Abatimentos"
TRCell():New(oSection3,"JUROS" 		,       , STR0046	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Juros"
TRCell():New(oSection3,"MULTA" 		,       , STR0047	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Multa"
//TRCell():New(oSection3,"CMONE" 		,       , STR0048	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Corr. Monet."
TRCell():New(oSection3,"ATPAG" 		,       , "Atr Pg"	, Tm(0,6)                  	, 6 ,/*lPixel*/,/*CodeBlock*/) 
TRCell():New(oSection3,"ATTIT" 		,       , "Atr Tit"	, Tm(0,7)                  	, 7 ,/*lPixel*/,/*CodeBlock*/) 
TRCell():New(oSection3,"VLRBAIXA"	,    	, STR0049	, Tm(0,13)                 	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Valor Baixado"
TRCell():New(oSection3,"RECANTEC" 	,  	  	, STR0050	, Tm(0,13)					, 13 ,/*lPixel*/,/*CodeBlock*/)	 //"Rec. Antecip."
TRCell():New(oSection3,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 					, 13 ,/*lPixel*/,/*CodeBlock*/)	 //"Acrescimo"
TRCell():New(oSection3,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 					, 13 ,/*lPixel*/,/*CodeBlock*/) //"Decrescimo"
TRCell():New(oSection3,"SALDO" 		, 	    , STR0051	, Tm(0,15) 					, 15 ,/*lPixel*/,/*CodeBlock*/)	 //"Saldo Atual"

//Oculta as celulas
oSection3:Cell("E1_EMISSAO"):Hide()
oSection3:Cell("E1_VENCREA"):Hide()
oSection3:Cell("E1_BAIXA"  ):Hide()

oSection3:SetLinesBefore(0.5)
oSection3:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Secao 04                                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4 := TRSection():New(oSection3, STR0057) //"Totais/Filial"

TRCell():New(oSection4,"TXTTOTAL"	,       , STR0055	,								, 42 ,/*lPixel*/,/*CodeBlock*/) //"Totais"	
TRCell():New(oSection4,"VALOR"	   	,		, STR0040 	, PesqPict("SE1","E1_VALOR") 	, 17 ,/*lPixel*/,/*CodeBlock*/)//"Valor Original"
TRCell():New(oSection4,"DESCON" 	,       , STR0044 	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Descontos"
TRCell():New(oSection4,"ABATIM" 	, 	   	, STR0045	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Abatimentos"
TRCell():New(oSection4,"JUROS" 		,       , STR0046	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Juros"
TRCell():New(oSection4,"MULTA" 		,       , STR0047	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Multa"
//TRCell():New(oSection4,"CMONE" 		,       , STR0048	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Corr. Monet."
TRCell():New(oSection4,"ATPAG" 		,       , "Atr Pg"	, Tm(0,6)                  	, 6 ,/*lPixel*/,/*CodeBlock*/) 
TRCell():New(oSection4,"ATTIT" 		,       , "Atr Tit"	, Tm(0,7)                  	, 7 ,/*lPixel*/,/*CodeBlock*/) 

TRCell():New(oSection4,"VLRBAIXA"	,    	, STR0049	, Tm(0,13)                  	, 13 ,/*lPixel*/,/*CodeBlock*/) //"Valor Baixado"
TRCell():New(oSection4,"RECANTEC" 	,  	  	, STR0050	, Tm(0,13)						, 13 ,/*lPixel*/,/*CodeBlock*/)	 //"Rec. Antecip."
TRCell():New(oSection4,"E1_ACRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/)	 //"Acrescimo"
TRCell():New(oSection4,"E1_DECRESC"	, "SE1" , 			, Tm(0,13) 						, 13 ,/*lPixel*/,/*CodeBlock*/) //"Decrescimo"
TRCell():New(oSection4,"SALDO" 		, 	   	, STR0051	, Tm(0,15) 						, 15 ,/*lPixel*/,/*CodeBlock*/)	 //"Saldo Atual"

oSection4:SetHeaderSection(.F.)	//Nao imprime o cabeçalho da secao

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ReportPrint ºAutor³ Marcio Menon       º Data ³  16/08/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Imprime o objeto oReport definido na funcao ReportDef.     º±±                                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ oReport - Objeto TReport do relatorio                      º±±
±±º          ³ cTitulo - Titulo do relatorio										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint(oReport,cTitulo)

Local oSection1 := oReport:Section(1) 
Local oSection2 := oReport:Section(1):Section(1)
Local oSection3 := oReport:Section(1):Section(1):Section(1)
Local oSection4 := oReport:Section(1):Section(1):Section(1):Section(1)
Local nOrdem	 := oReport:Section(1):GetOrder()
Local lTotGer   := .F.

Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0,nTit10:=0,nTit11:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=0,nTot10:=0,nTot11:=0,nTot12:=0
Local nTotAbat	 := 0
Local nTotAtPag  := 0
Local nTotAtTit  := 0
Local cForAnt	 := Space(6)
Local lContinua := .T.
Local aValor	 := {0,0,0,0,0,0,0,0,""}
Local nSaldo	 := 0
Local nMoeda	 := mv_par10
Local dDataMoeda:= dDataBase
Local aSituacao := {STR0007,STR0008,STR0009,STR0010,;	//"Carteira"###"Simples"###"Descontada"###"Caucionada"
							STR0011,STR0012,STR0013,STR0018,;	//"Vinculada"###"Advogado"###"Judicial###Caucao Desc."
							STR0031,STR0032,STR0033 } 				//"Protesto"###"Acordo"###"Cartorio"
Local ndecs 	 := Msdecimais(mv_par10)
Local cMotivo	 := " "
Local aMotBx 	 := {}
Local nValor	 := 0
Local nPos 		 := 0
Local cAliasSA1 := "SA1"
Local cSitCobr  := " "
Local cCond1,cCond2,cChave,cIndex,cChaveE1, cChaveE5
Local cTipoant	 := ""
Local ntotaltipo:= 0
Local i     
Local nTotFil1 :=0
Local nTotFil2 :=0
Local nTotFil3 :=0
Local nTotFil4 :=0
Local nTotFil5 :=0
Local nTotFil6 :=0
Local nTotFil7 :=0
Local nTotFil8 :=0
Local nTotFil9 :=0
Local nTotFil10:=0
Local nTotFil11:=0
Local nTotFil12:=0

#IFDEF TOP
	Local aStru  := SE1->(dbStruct()), ni
	Local cOrder
	Local cFiltSA1 := oReport:Section(1):GetSqlExp("SA1")
	Local cFiltSE1 := oReport:Section(1):GetSqlExp("SE1")
#ENDIF	

Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE cFilDe,cFilAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 2. (Titulos)		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection2:Cell("VALOR"	 	):SetBlock( { || SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),14,;
								 									alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs) } )
oSection2:Cell("BAIXA"	 	):SetBlock( { || If(dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA)), IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," "), ) } )
oSection2:Cell("DESCON"	 	):SetBlock( { || aValor[I_DESCONTO] 			} )
oSection2:Cell("ABATIM"	 	):SetBlock( { || nTotAbat 						} )
oSection2:Cell("JUROS"	 	):SetBlock( { || aValor[I_JUROS] 				} )		
oSection2:Cell("MULTA"	 	):SetBlock( { || aValor[I_MULTA] 				} )

//oSection2:Cell("CMONE"	 	):SetBlock( { || aValor[I_CORRECAO_MONETARIA]	} )
oSection2:Cell("ATPAG"	 	):SetBlock( { || nTotAtPag	} )
oSection2:Cell("ATTIT"	 	):SetBlock( { || nTotAtTit	} )


oSection2:Cell("VLRBAIXA"	):SetBlock( { || aValor[I_VALOR_RECEBIDO] 		} )				
oSection2:Cell("RECANTEC"	):SetBlock( { || aValor[I_RECEB_ANT] 			} )
oSection2:Cell("E1_ACRESC"  ):SetBlock( { || SE1->E1_SDACRES 				} )
oSection2:Cell("E1_DECRESC" ):SetBlock( { || SE1->E1_SDDECRE 				} )
oSection2:Cell("SALDO"	 	):SetBlock( { || SayValor(nSaldo,15,alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)	} )
oSection2:Cell("MOTIVO"	 	):SetBlock( { || Pad(aValor[I_MOTBX],15)		} )
oSection2:Cell("SITUACAO"	):SetBlock( { || cSitCobr 						} )

oSection2:Cell("DESCON"	 	):Picture( TM(aValor[I_DESCONTO],13,nDecs				))
oSection2:Cell("ABATIM"	 	):Picture( TM(nTotAbat,13,nDecs							))
oSection2:Cell("JUROS"	 	):Picture( TM(aValor[I_JUROS],13,nDecs					))
oSection2:Cell("MULTA"	 	):Picture( TM(aValor[I_MULTA],13,nDecs					))

//oSection2:Cell("CMONE"	 	):Picture( TM(aValor[I_CORRECAO_MONETARIA],13,nDecs	))
oSection2:Cell("ATPAG"	 	):Picture( TM(nTotAtPag,6,0	))
oSection2:Cell("ATTIT"	 	):Picture( TM(nTotAtTit,7,0	))

oSection2:Cell("VLRBAIXA"	):Picture( TM(aValor[I_VALOR_RECEBIDO],15,nDecs		))
oSection2:Cell("RECANTEC"	):Picture( TM(aValor[I_RECEB_ANT],13,nDecs				))
oSection2:Cell("E1_ACRESC"	):Picture( TM(SE1->E1_SDACRES,13,nDecs					))
oSection2:Cell("E1_DECRESC"	):Picture( TM(SE1->E1_SDDECRE,13,nDecs					))

oSection2:SetHeaderPage()	//Define o cabecalho da secao como padrao

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 3.	(Totais)	   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection3:Cell("TXTTOTAL"	):SetBlock( { || If (!lTotGer, OemToAnsi(STR0016), OemToAnsi(STR0017)) } )	//"Totais : " ### "TOTAL GERAL : "
oSection3:Cell("VALOR"	 	):SetBlock( { || If (!lTotGer, nTit1, nTot1  ) } )
oSection3:Cell("DESCON"	 	):SetBlock( { || If (!lTotGer, nTit2, nTot2  ) } )
oSection3:Cell("ABATIM"	 	):SetBlock( { || If (!lTotGer, nTit3, nTot3  ) } )				
oSection3:Cell("JUROS"	 	):SetBlock( { || If (!lTotGer, nTit4, nTot4  ) } )
oSection3:Cell("MULTA"	 	):SetBlock( { || If (!lTotGer, nTit5, nTot5  ) } )
//oSection3:Cell("CMONE"	 	):SetBlock( { || If (!lTotGer, nTit6, nTot6  ) } )
oSection3:Cell("ATPAG"	 	):SetBlock( { || If (!lTotGer, nTit6, nTot6  ) } )
oSection3:Cell("ATTIT"	 	):SetBlock( { || If (!lTotGer, nTit12, nTot12) } )
oSection3:Cell("VLRBAIXA"	):SetBlock( { || If (!lTotGer, nTit7, nTot7  ) } )
oSection3:Cell("RECANTEC"	):SetBlock( { || If (!lTotGer, nTit8, nTot8  ) } )
oSection3:Cell("SALDO"	 	):SetBlock( { || If (!lTotGer, nTit9, nTot9  ) } )
oSection3:Cell("E1_ACRESC"	):SetBlock( { || If (!lTotGer, nTit10, nTot10) } )
oSection3:Cell("E1_DECRESC"	):SetBlock( { || If (!lTotGer, nTit11, nTot11) } )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicoes da secao 4.	(Totais/Filial)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection4:Cell("TXTTOTAL"	):SetBlock( { || STR0058 +" "+Iif(mv_par20==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")})  //"T O T A L   F I L I A L ----> " 
oSection4:Cell("VALOR"	 	):SetBlock( { || nTotFil1  } )
oSection4:Cell("DESCON"	 	):SetBlock( { || nTotFil2  } )
oSection4:Cell("ABATIM"	 	):SetBlock( { || nTotFil3  } )				
oSection4:Cell("JUROS"	 	):SetBlock( { || nTotFil4  } )
oSection4:Cell("MULTA"	 	):SetBlock( { || nTotFil5  } )
//oSection4:Cell("CMONE"	 	):SetBlock( { || nTotFil6  } )
oSection4:Cell("ATPAG"	 	):SetBlock( { || nTotFil6  } )
oSection4:Cell("ATTIT"	 	):SetBlock( { || nTotFil12  } )
oSection4:Cell("VLRBAIXA"	):SetBlock( { || nTotFil7  } )
oSection4:Cell("RECANTEC"	):SetBlock( { || nTotFil8  } )
oSection4:Cell("SALDO"	 	):SetBlock( { || nTotFil9  } )
oSection4:Cell("E1_ACRESC"  ):SetBlock( { || nTotFil10 } )
oSection4:Cell("E1_DECRESC"	):SetBlock( { || nTotFil11 } )


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par20 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par21	// Todas as filiais
	cFilAte:= mv_par22
Endif
	
dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

oReport:NoUserFilter()

While SM0->(!Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL <= cFilAte

	cFilAnt := SM0->M0_CODFIL
   
	dbSelectArea("SE1")
	IF nOrdem == 1
		dbSetOrder(2)
		cChave := IndexKey()
		dbSeek(xFilial("SE1")+mv_par01+mv_par03,.T.)
		cCond1 := "SE1->E1_CLIENTE+SE1->E1_LOJA <= '"+mv_par02+mv_par04+"' .and. SE1->E1_FILIAL == '"+xFilial("SE1")+"'"
		cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
		#IFDEF TOP
			cOrder := SqlOrder(cChave)
		#ENDIF
	Else
		cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			If TCSrvType() == "AS/400"
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")
				dbSetOrder(nIndex+1)
			Else
				cOrder := SqlOrder(cChave)
			EndIf
		#ELSE
			cIndex	:= CriaTrab(nil,.f.)
			dbSelectArea("SE1")
			IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
			nIndex	:= RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
		#ENDIF
		cCond1 := ".T."
		cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
		SE1->(dbGoTop())
	EndIf

	oReport:SetMeter(SE1->(LastRec()))

	#IFDEF TOP
		If TcSrvType() != "AS/400"

			If Select("NEWSE1") > 0
				dbSelectArea("NEWSE1")
				dbCloseArea()
			Endif
			ChkFile("SE1",.F.,"NEWSE1")

			dbSelectArea("SE1")
			aStru := dbStruct()

			// Montagem do SELECT apenas com os campos necessarios ao relatorio
			cQuery := "SELECT "
	
			if nOrdem == 1
				cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
			else
				cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "		
			endif

			cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "		
			cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ," 		
			cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
			cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ "
			cQuery += " FROM " + RetSqlName("SE1") +" SE1, " + RetSqlName("SA1") + " SA1 "
			cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
			cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'" 
			cQuery += " AND SA1.A1_COD = SE1.E1_CLIENTE "
			cQuery += " AND SA1.A1_LOJA = SE1.E1_LOJA "
			cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
			cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
			cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
			cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
			cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
			cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
			cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
			If cPaisLoc<>"BRA"
				cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
			EndIf
			If mv_par09 == 2
				cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
			EndIf
			If mv_par12 == 2
				cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT')"
			Endif
			// Nao considera Ti. Liquidados.
			If mv_par18 == 2
				cQuery += "AND E1_FILIAL||E1_PREFIXO||E1_NUM||E1_PARCELA||E1_TIPO NOT IN "
				cQuery += "(SELECT E5_FILIAL||E5_PREFIXO||E5_NUMERO||E5_PARCELA||E5_TIPO AS TITULOS"
				cQuery += "FROM "+ RetSqlName("SE5") +" WHERE E5_MOTBX = 'LIQ' AND D_E_L_E_T_ = '')"
			Endif
		
			If mv_par19 == 2
				cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
				cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
			Endif
		
			cQuery += " AND SE1.D_E_L_E_T_ <> '*' "
			cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
		
			//Adiciono filtro do usuario na Query
			If !Empty(cFiltSA1)
				cQuery += " AND " + cFiltSA1
			EndIf
		
			//Adiciono filtro do usuario na Query
			If !Empty(cFiltSE1)
				cQuery += " AND " + cFiltSE1 
			EndIf

			cQuery += " ORDER BY " + cOrder
			
			cQuery := ChangeQuery(cQuery)
		
			dbSelectArea("SE1")
			dbCloseArea()
		
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)
			
			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		
			//Desabilita o filtro no tratamento da Printline()
			oReport:NoUserFilter()

			cAliasSA1 := "SE1"
		EndIf
	#ENDIF

	While SE1->(!Eof()) .And. lContinua .And. &cCond1 .And. !oReport:Cancel()
	
		If oReport:Cancel()
			lContinua := .F.
			Exit
		EndIf	

		#IFNDEF TOP
		
		// Nao considera Ti. Liquidados.
		If mv_par18 == 2
			dbSelectArea("SE5")
			dbSetorder(5)
			
			cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
			cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
			
			While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
				If SE5->E5_MOTBX == "LIQ"
					SE1->(dbSkip())
					Loop
				EndIf
			End
		Endif		
		dbSelectArea("SE1")
		
		#ENDIF
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea("NEWSE1")
				dbGoto(SE1->RECNO)
			Endif
		#Endif
	
		dbSelectArea("SE1")	
	
		nCont := 1
		nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=nTit10:=nTit11:=nTit12:=0
		cForAnt:= &cCond2
	
		While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()
		
			#IFNDEF TOP
   				If mv_par19 == 2
					If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
					SE1->( dbSkip() )
					Loop
					Endif
				Endif  
			#ENDIF
		
			If oReport:Cancel()
				lContinua := .F.
				Exit
			EndIf	
			
			oReport:IncMeter()
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif

			If !Fr340Skip("SE1")
				dbSelectArea("SE1")
				dbSkip()
				Loop
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os dados dos clientes.                               ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SA1")
			dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
		  	If nCont = 1
				oSection1:Init()
				oSection1:PrintLine()
				oSection1:Finish()
				nCont++
			Endif

			dbSelectArea("SE1")
		
			IF mv_par11 == 1
				dDataMoeda	:=	dDataBase
			Else
				dDataMoeda	:=	SE1->E1_VENCREA
			Endif
		
			aValor := Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1)

			If mv_par14 == 1
				nSaldo := SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Else
				nSaldo := xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Endif

			If SE1->E1_VALOR <> SE1->E1_VALLIQ
				nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
            Else
				nTotAbat := 0
            EndIf
            
			If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
			   ! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
				nSaldo -= nTotAbat
			EndIf
			
			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				aValor[I_DESCONTO] += SE1->E1_DECRESC	
				nSaldo -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				aValor[I_JUROS] += SE1->E1_ACRESC
				nSaldo += SE1->E1_ACRESC
			Endif
			
			If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
				aValor[I_JUROS] += SE1->E1_ACRESC
				aValor[I_DESCONTO] += SE1->E1_DECRESC	
			Else
				aValor[I_JUROS] += SE1->E1_SDACRES
				aValor[I_DESCONTO] += SE1->E1_SDDECRE
			EndIf
		    
			Do Case
				Case SE1->E1_SITUACA $ "01234567"
					cSitCobr := aSituacao[Val(SE1->E1_SITUACA)+1]
				Case SE1->E1_SITUACA == "F"	//Carteira Protesto
					cSitCobr := aSituacao[9]
				Case SE1->E1_SITUACA == "G"	//Carteira Acordo
					cSitCobr := aSituacao[10]
				Case SE1->E1_SITUACA == "H"	//Cartorio
					cSitCobr := aSituacao[11]
				OtherWise               
					cSitCobr := " "
			EndCase

			If !(SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG)
				nTit1 += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nTit7 += aValor[I_VALOR_RECEBIDO]
				nTit9 += nSaldo
			Else
				nTit1 -= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nTit7 -= aValor[I_VALOR_RECEBIDO]
				nTit9 -= nSaldo
			Endif
		
			nTit2 += aValor[I_DESCONTO]
			nTit3 += nTotAbat
			nTit4 += aValor[I_JUROS]
			nTit5 += aValor[I_MULTA]
			//nTit6 += aValor[I_CORRECAO_MONETARIA]
			// Atraso Pagamento
			nTit6 += SE1->E1_VALOR * Iif(Empty(SE1->E1_BAIXA), 0, SE1->E1_Baixa - SE1->E1_VencRea)
			// Atraso do título
			nTit12 += SE1->E1_VALOR * Iif(Empty(SE1->E1_BAIXA), Date() - SE1->E1_VencRea, SE1->E1_Baixa - SE1->E1_VencRea)
			nTit8 += aValor[I_RECEB_ANT]
			nTit10 += SE1->E1_SDACRES    
		    nTit11 += SE1->E1_SDDECREC    
			
			If cPaisLoc <> "BRA"
				cMotivo := SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
    	  		nvalor  := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nPos    := aScan(aMotBx,{|X| x[1]== cMotivo})
		
				If nPos > 0
		   		 	aMotBx[nPos][2] += nvalor
				else
	   				Aadd(aMotBx,{cMotivo,nvalor})
				Endif	
			Endif

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime os titulos dos clientes.                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			oSection2:Init()
			oSection2:PrintLine()

			dbSelectArea("SE1")
			dbSkip()
		Enddo
	
		oSection2:Finish()
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime os totais.						                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oSection3:Init()

		If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+;
		     ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9)+ABS(nTit10)+ABS(nTit11) > 0 )
        	
			nTot1  += nTit1
			nTot2  += nTit2
			nTot3  += nTit3
			nTot4  += nTit4
			nTot5  += nTit5
			nTot6  += nTit6
			nTot7  += nTit7
			nTot8  += nTit8
			nTot9  += nTit9
			nTot10 += nTit10
			nTot11 += nTit11
			nTot12 += nTit12
			
			nTotFil1  += nTit1
			nTotFil2  += nTit2
			nTotFil3  += nTit3
			nTotFil4  += nTit4
			nTotFil5  += nTit5
			nTotFil6  += nTit6
			nTotFil7  += nTit7
			nTotFil8  += nTit8			
			nTotFil9  += nTit9
			nTotFil10 += nTit10
			nTotFil11 += nTit11
			nTotFil12 += nTit12

			oSection3:PrintLine()
		EndIf		
		oSection3:Finish()
		oReport:ThinLine()
	Enddo

	SE1->(DbCloseArea())			
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par20 == 1 .and. SM0->(Reccount()) > 1
		oSection4:Init()  
		oSection4:PrintLine()
		oSection4:Finish()
		oReport:ThinLine()

	Endif
	Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nTotFil11,nTotFil12
	SM0->(DbSkip())
EndDo

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime o Total Geral.					                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTotGer := .T.	

oSection3:Init()
oSection3:PrintLine()
oSection3:Finish()

If cPaisLoc <> "BRA"
	oSection3:Cell("DESCON"	 ):Disable()
	oSection3:Cell("ABATIM"	 ):Disable()
	oSection3:Cell("JUROS"	 ):Disable()
	oSection3:Cell("MULTA"	 ):Disable()
	oSection3:Cell("ATPAG"	 ):Disable()
	oSection3:Cell("ATTIT"	 ):Disable()
	oSection3:Cell("VLRBAIXA"):Disable()
	oSection3:Cell("RECANTEC"):Disable()
	oSection3:Cell("SALDO"	 ):Disable()
	oSection3:Init()
	oReport:PrintText(OemToAnsi(STR0027))		//"TOTAL POR MOTIVO : "

	For i:=1 to Len(aMotBx)
		If cTipoant==" "
	   	cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2] 
			ctipoant	  := subs(aMotBX[i][1],1,3)
		else 
			oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			ntotaltipo := 0
			oSection3:PrintLine()
			oReport:PrintText("")
			oSection3:Cell("TXTTOTAL"):SetBlock( { || aMotBX[i] [1] } )
			oSection3:Cell("VALOR"	 ):SetBlock( { || aMotBX[i] [2] } )
			oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
			oSection3:PrintLine()
			ntotaltipo += aMotBX[i] [2] 
			ctipoant   := subs(aMotBX[i][1],1,3)
		Endif				
	Next i
	oSection3:Cell("TXTTOTAL"):SetBlock( { || OemToAnsi(STR0016) + ctipoant } )
	oSection3:Cell("VALOR"	 ):SetBlock( { || ntotaltipo } )
	oSection3:Cell("VALOR"	 ):Picture(PesqPict("SE1","E1_VALOR",14,MV_PAR10))
	oSection3:PrintLine()
	oSection3:Finish()
EndIf

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	If TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()		
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

Return

/*
---------------------------------------------- Release 3 ---------------------------------------------------------
*/
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINR340  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Clientes                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR340(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGAFIN																	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauricio   ³21/11/97³13526 ³ Nao imprimir subtotal com valores zerados³±±
±±³ Mauricio   ³08/12/97³xxxxx ³ Corrigir array de situacao de titulos    ³±±
±±³ Mauricio   ³28/06/98³xxxxx ³ Considerar numero titulos c/12 posicoes  ³±±
±±³ Mauricio   ³02/07/98³xxxxx ³ Alinhar relatorio                        ³±±
±±³ Andreia    ³05/10/98³xxxxx ³ Ajustar lay-out para ativar Set Century  ³±±
±±³ Wagner     ³27/11/98³xxxxx ³ Acerto cabecalho                         ³±±
±±³ Andreia    ³11/01/99³xxxxx ³ Ordenacao por ordem alfabetica.          ³±±
±±³ Julio      ³24.06.99³22201A³ Valores significativos impressos entre   ³±±
±±³            ³        ³      ³ parˆnteses caso Valor < 0                ³±±
±±³ Julio      ³29.07.99³META  ³ Interpretar MV_CRNEG                     ³±±
±±³ Mauricio   ³10/08/99³23192A³ Considerar Cliente/Loja na verificacao   ³±±
±±³            ³        ³      ³ de baixas do titulo.                     ³±±
±±³ Pilar	   ³04/10/99³      ³ Melhoria de Performance                  ³±±
±±³ Julio W	   ³30.11.99³META  ³ Interpretar filtro do usuario            ³±±
±±³ MAURICIO   ³09.12.99³xxxxxx³Corrigir filtro usuario                   ³±±
±±³ Bruno      ³10.02.00³xxxxx ³Corrigir o saldo en moeda > 1 (usar nSaldo³±±
±±³            ³        ³      ³ que ‚ o certo r n„o SE1->E1_SALDO).      ³±±
±±³            ³        ³      ³Substarir nos Subtotais o valor pago, usar³±±
±±³            ³        ³      ³ o ABS na chamada da ImpSubTot().         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function FinR340R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 :=OemToAnsi(STR0001)  //"Este programa ir  emitir a posi‡„o de clientes "
Local cDesc2 :=OemToAnsi(STR0002)  //"referente a data base do sistema."
Local cDesc3 :=""
Local cString:="SE1"

Private aLinha:={}
Private aReturn:={ OemToAnsi(STR0003), 1,OemToAnsi(STR0004), 1, 2, 1, "",1 }  //"Zebrado"###"Administracao"
Private cPerg:=PadR("FIN340",len(SX1->X1_GRUPO))
Private cabec1,cabec2,titulo,wnrel,tamanho:="G",nomeprog:="FINR340"
Private nLastKey := 0
Private aOrd :={OemToAnsi(STR0020),OemToAnsi(STR0021) }  //"Por Codigo"###"Por Nome" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo:= OemToAnsi(STR0005)  //"Posicao dos Clientes "
cabec1:= OemToAnsi(STR0006)  //"Prf Numero      PC  Tip Valor Original Emissao   Vencto   Baixa                               R  E  C  E  B  I  M  E  N  T  O  S                                                                       "
cabec2:= OemToAnsi("                                                                   Descontos    Abatimentos          Juros         Multa   Atr Pag   Atr Tit  Valor Baixado   Rec.Antecipado    Saldo Atual  Motivo          Situacao     Port.")


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN340",.F.)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // do Cliente                            ³
//³ mv_par02            // Ate o Cliente                         ³
//³ mv_par03            // Da Loja                               ³
//³ mv_par04            // Ate a Loja                            ³
//³ mv_par05            // Da Emissao                            ³
//³ mv_par06            // Ate a Emissao                         ³
//³ mv_par07            // Do Vencimento                         ³
//³ mv_par08            // Ate o Vencimento                      ³
//³ mv_par09            // Imprime os t¡tulos provis¢rios        ³
//³ mv_par10            // Qual a moeda                          ³
//³ mv_par11            // Reajusta pela DataBase ou Vencto      ³
//³ mv_par12            // Considera Faturados                   ³
//³ mv_par13            // Imprime Outras Moedas                 ³
//³ mv_par14            // Considera Data Base                   ³
//³ mv_par15            // Imprime Nome? (Razao Social/N.Reduzid)³
//³ mv_par16            // Natureza De ?                         ³
//³ mv_par17            // Natureza Ate?                         ³
//³ mv_par18            // Considera Liquidados?                 ³
//³ mv_par20			// Consid Filiais  ?  					³
//³ mv_par21			// da filial							³
//³ mv_par22			// a flial 								³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="FINR340"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| Fa340Imp(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA340Imp ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Posicao dos Clientes                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA340Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do Codeblock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³          ³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FA340Imp(lEnd,wnRel,cString)

Local CbTxt,cbCont
Local nTotAbat:=0,nOrdem
Local nTit1:=0,nTit2:=0,nTit3:=0,nTit4:=0,nTit5:=0,nTit6:=0,nTit7:=0,nTit8:=0,nTit9:=0,nTit10:=0
Local nTot1:=0,nTot2:=0,nTot3:=0,nTot4:=0,nTot5:=0,nTot6:=0,nTot7:=0,nTot8:=0,nTot9:=nTot10:=0
Local cForAnt:=Space(6)
Local lContinua := .T.
Local aValor:={0,0,0,0,0,0,0,0,""}
Local nSaldo:=0
Local nMoeda:=0
Local dDataMoeda:=dDataBase
Local aSituacao :={STR0007,STR0008,STR0009,STR0010,;		//"Carteira"###"Simples"###"Descontada"###"Caucionada"
							STR0011,STR0012,STR0013,STR0018,;	//"Vinculada"###"Advogado"###"Judicial###Caucao Desc."
							STR0031,STR0032,STR0033 } //"Protesto"###"Acordo"###"Cartorio"

LOCAL cCond1,cCond2,cChave,cIndex

#IFDEF TOP
	Local aStru 	:= SE1->(dbStruct()), ni
	Local cOrder
#ENDIF	
Local cFilterUser := aReturn[7]
Local ndecs :=Msdecimais(mv_par10)
Local cMotivo:= " "
Local aMotBx := {}
Local nValor:= 0
Local nPos := 0
Local cAliasSA1 := "SA1"
Local cSitCobr := " "   
Local nTotFil1:=0
Local nTotFil2:=0
Local nTotFil3:=0
Local nTotFil4:=0
Local nTotFil5:=0
Local nTotFil6:=0
Local nTotFil7:=0
Local nTotFil8:=0
Local nTotFil9:=0
Local nTotFil10:=0
Private nRegSM0 := SM0->(Recno())
Private nAtuSM0 := SM0->(Recno())
PRIVATE cFilDe,cFilAte

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atribui valores as variaveis ref a filiais                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par20 == 2
	cFilDe  := cFilAnt
	cFilAte := cFilAnt
ELSE
	cFilDe := mv_par21	// Todas as filiais
	cFilAte:= mv_par22
Endif

dbSelectArea("SM0")
dbSeek(cEmpAnt+cFilDe,.T.)

nRegSM0 := SM0->(Recno())
nAtuSM0 := SM0->(Recno())

While !SM0->(Eof()) .and. SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL <= cFilAte
	
	cFilAnt := SM0->M0_CODFIL

	nMoeda := mv_par10
	Titulo += " - " + GetMv("MV_MOEDA"+Str(nMoeda,1))
	nOrdem := aReturn[8]

	dbSelectArea("SE1")
	IF nOrdem = 1
		dbSetOrder(2)
		cChave := IndexKey()
		dbSeek(xFilial("SE1")+mv_par01+mv_par03,.t.)
		cCond1 := 'SE1->E1_CLIENTE+SE1->E1_LOJA <= mv_par02+mv_par04 .and. SE1->E1_FILIAL == xFilial("SE1")'
		cCond2 := "SE1->E1_CLIENTE+SE1->E1_LOJA"
		#IFDEF TOP
			cOrder := SqlOrder(cChave)
		#ENDIF
	Else
		cChave  := "E1_FILIAL+E1_NOMCLI+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO"
		#IFDEF TOP
			If TCSrvType() == "AS/400"
				cIndex	:= CriaTrab(nil,.f.)
				dbSelectArea("SE1")
				IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
				nIndex	:= RetIndex("SE1")
				dbSetOrder(nIndex+1)
			Else
				cOrder := SqlOrder(cChave)
			EndIf
		#ELSE
			cIndex	:= CriaTrab(nil,.f.)
			dbSelectArea("SE1")
			IndRegua("SE1",cIndex,cChave,,FR340FIL(),OemToAnsi(STR0022))  //"Selecionando Registros..."
			nIndex	:= RetIndex("SE1")
			dbSetIndex(cIndex+OrdBagExt())
			dbSetOrder(nIndex+1)
		#ENDIF
		cCond1 := ".T."
		cCond2 := "SE1->E1_NOMCLI+SE1->E1_CLIENTE+SE1->E1_LOJA"
		SE1->( dbGoTop() )
	EndIf
	SetRegua(RecCount())

	#IFDEF TOP
		If TcSrvType() != "AS/400"

			If Select("NEWSE1") > 0
				dbSelectArea("NEWSE1")
				dbCloseArea()
			Endif
			ChkFile("SE1",.F.,"NEWSE1")

			dbSelectArea("SE1")
			aStru := dbStruct()

			// Montagem do SELECT apenas com os campos necessarios ao relatorio
			cQuery := "SELECT "
	
			if nOrdem == 1
				cQuery += " SE1.E1_FILIAL, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, SE1.E1_NOMCLI, "
			else
				cQuery += " SE1.E1_FILIAL, SE1.E1_NOMCLI, SE1.E1_CLIENTE, SE1.E1_LOJA, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA, SE1.E1_TIPO, "		
			endif

 			cQuery += " SE1.E1_NATUREZ, SE1.E1_SITUACA, SE1.E1_PORTADO, SE1.E1_SALDO, SE1.E1_MOEDA, SE1.E1_RECIBO, SE1.E1_ORIGEM, "		
			cQuery += " SE1.E1_EMISSAO, SE1.E1_VENCREA, SE1.E1_BAIXA, SE1.E1_FATURA, SE1.E1_DTFATUR, SE1.E1_VALLIQ," 		
			cQuery += " SE1.E1_VALOR,SE1.E1_SDACRES,SE1.E1_SDDECRE,SE1.E1_TXMOEDA,SE1.E1_ACRESC,SE1.E1_DECRESC,SE1.R_E_C_N_O_ RECNO, "
			cQuery += " SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ "
			cQuery += " FROM " + RetSqlName("SE1") +" SE1, " + RetSqlName("SA1") + " SA1 "
			cQuery += " WHERE SE1.E1_FILIAL = '" + xFilial("SE1") + "'"
			cQuery += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'" 
			cQuery += " AND SA1.A1_COD = SE1.E1_CLIENTE "
			cQuery += " AND SA1.A1_LOJA = SE1.E1_LOJA "
			cQuery += " AND SE1.E1_CLIENTE between '" + mv_par01        + "' AND '" + mv_par02       + "'"
			cQuery += " AND SE1.E1_LOJA    between '" + mv_par03        + "' AND '" + mv_par04       + "'"
			cQuery += " AND SE1.E1_EMISSAO between '" + DTOS(mv_par05)  + "' AND '" + DTOS(mv_par06) + "'"
			cQuery += " AND SE1.E1_VENCREA between '" + DTOS(mv_par07)  + "' AND '" + DTOS(mv_par08) + "'"
			cQuery += " AND SE1.E1_TIPO NOT LIKE '%-' "
			cQuery += " AND SE1.E1_EMISSAO <=  '"     + DTOS(dDataBase) + "'"
			cQuery += " AND SE1.E1_NATUREZ between '" + mv_par16        + "' AND '" + mv_par17       + "'"
			If cPaisLoc<>"BRA"
				cQuery += "AND SE1.E1_TIPO<>'CH' AND SE1.E1_TIPO<>'TF'"
			EndIf
			If mv_par09 == 2
				cQuery += " AND SE1.E1_TIPO <> '"+MVPROVIS+"'"
			EndIf
			If mv_par12 == 2
				cQuery += " AND SE1.E1_FATURA IN('"+Space(Len(E1_FATURA))+"','NOTFAT')"
			Endif
			// Nao considera Ti. Liquidados.
			If mv_par18 == 2
				cQuery += "AND E1_FILIAL||E1_PREFIXO||E1_NUM||E1_PARCELA||E1_TIPO NOT IN "
				cQuery += "(SELECT E5_FILIAL||E5_PREFIXO||E5_NUMERO||E5_PARCELA||E5_TIPO AS TITULOS"
				cQuery += "FROM "+ RetSqlName("SE5") +" WHERE E5_MOTBX = 'LIQ' AND D_E_L_E_T_ = '')"
			Endif
		
			If mv_par19 == 2
				cQuery += "AND (( SE1.E1_RECIBO <> '"+Space(Len(SE1->E1_RECIBO))+"'"
				cQuery += "AND SE1.E1_ORIGEM = 'FINA087A') OR (SE1.E1_RECIBO = '"+Space(Len(SE1->E1_RECIBO))+"') )"
			Endif
			
			cQuery += " AND SE1.D_E_L_E_T_ <> '*' "
			cQuery += " AND SA1.D_E_L_E_T_ <> '*' "
		
			cQuery += " ORDER BY " + cOrder
		
			cQuery := ChangeQuery(cQuery)
		
			dbSelectArea("SE1")
			dbCloseArea()
		
			dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SE1', .T., .T.)

			For ni := 1 to Len(aStru)
				If aStru[ni,2] != 'C' .and. FieldPos(aStru[ni,1]) > 0
					TCSetField('SE1', aStru[ni,1], aStru[ni,2],aStru[ni,3],aStru[ni,4])
				Endif
			Next
		
			cAliasSA1 := "SE1"
		EndIf
	#ENDIF

	While !Eof() .And. lContinua .And. &cCond1			
	
		#IFNDEF TOP
		// Nao considera Ti. Liquidados.
		If mv_par18 == 2
			dbSelectArea("SE5")
			dbSetorder(5)
			
			cChaveE1 := "xFilial('SE1')+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO"
			cChaveE5 := "xFilial('SE5')+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO"
			
			While !EOF() .And. (&(cChaveE1) == &(cChaveE5))
				If SE5->E5_MOTBX == "LIQ"
					SE1->(dbSkip())
					Loop
				EndIf
			End
		Endif
		
		dbSelectArea("SE1")
		
		#ENDIF
		
		If lEnd
			@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
			Exit
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Considera filtro do usuario                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		#IFDEF TOP
			If TcSrvType() != "AS/400"
				dbSelectArea("NEWSE1")
				dbGoto(SE1->RECNO)
			Endif
		#Endif
	
		If !Empty(cFilterUser).and.!(&cFilterUser)
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif

		dbSelectArea("SE1")	
	
		nCont:=1
		nTit1:=nTit2:=nTit3:=nTit4:=nTit5:=nTit6:=nTit7:=nTit8:=nTit9:=0
		cForAnt	 := &cCond2
	
		While &cCond2 == cForAnt .And. lContinua .And. &cCond1 .And. !Eof()

			#IFNDEF TOP

	   			If mv_par19 == 2
					If (!Empty(SE1->E1_RECIBO) .And. SE1->E1_ORIGEM <> "FINA087A")
					SE1->( dbSkip() )
					Loop
					Endif
				Endif  
	
			#ENDIF
		
		
			If lEnd
				@PROW()+1,001 PSAY OemToAnsi(STR0014)  //"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			Endif
		
			IncRegua()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Considera filtro do usuario                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			#IFDEF TOP
				If TcSrvType() != "AS/400"
					dbSelectArea("NEWSE1")
					dbGoto(SE1->RECNO)
				Endif
			#Endif

			If !Empty(cFilterUser).and.!(&cFilterUser)
				dbSelectArea("SE1")
				dbSkip()
				Loop
			Endif

			dbSelectArea("SE1")		
			
			If !Fr340Skip("SE1")
				dbSelectArea("SE1")
				dbSkip()
				Loop
			EndIf
			
			#IFDEF TOP
				If TcSrvType() == "AS/400"
					dbSelectArea(cAliasSA1)
					dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
				Endif
			#ELSE
				dbSelectArea(cAliasSA1)
				dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)
			#ENDIF
		
			IF li > 58     
				nAtuSM0 := SM0->(Recno())
				SM0->(dbGoto(nRegSM0))
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM")))
				SM0->(dbGoTo(nAtuSM0))
			EndIF
		
		  	If nCont = 1
				@li,0 PSAY OemToAnsi(STR0015)+(cAliasSA1)->A1_COD+"-"+(cAliasSA1)->A1_LOJA+" "+IIF(mv_par15 == 1, (cAliasSA1)->A1_NOME,(cAliasSA1)->A1_NREDUZ)  //"CLIENTE : "
				Li+= 2
				nCont++
			Endif
		
			dbSelectArea("SE1")
		
			IF mv_par11 == 1
				dDataMoeda	:=	dDataBase
			Else
				dDataMoeda	:=	SE1->E1_VENCREA
			Endif
		
			aValor:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,nMoeda,"R",SE1->E1_CLIENTE,dDataBase,SE1->E1_LOJA,,,,mv_par14 == 1)

			If mv_par14 == 1
				nSaldo:=SaldoTit(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_NATUREZ,"R",SE1->E1_CLIENTE,nMoeda,dDataMoeda,,SE1->E1_LOJA,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Else
				nSaldo:=xMoeda((SE1->E1_SALDO+SE1->E1_SDACRES-SE1->E1_SDDECRE),SE1->E1_MOEDA,mv_par10,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
			Endif

			If SE1->E1_VALOR <> SE1->E1_VALLIQ
				nTotAbat := SomaAbat ( SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, "R", nMoeda )
			Else
				nTotAbat := 0
			EndIf            
			
			// Subtrai decrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_DECRESC > 0 .And. SE1->E1_SDDECRE == 0
				aValor[I_DESCONTO] += SE1->E1_DECRESC	
				nSaldo -= SE1->E1_DECRESC
			Endif
			// Soma Acrescimo para recompor o saldo na data escolhida.
			If Str(SE1->E1_VALOR,17,2) == Str(nSaldo,17,2) .And. SE1->E1_ACRESC > 0 .And. SE1->E1_SDACRES == 0
				aValor[I_JUROS] += SE1->E1_ACRESC
				nSaldo += SE1->E1_ACRESC
			Endif
			
			If SE1->E1_SALDO > 0 .And. Empty(SE1->E1_BAIXA)
				aValor[I_JUROS] += SE1->E1_ACRESC
				aValor[I_DESCONTO] += SE1->E1_DECRESC	
			Else
				aValor[I_JUROS] += SE1->E1_SDACRES
				aValor[I_DESCONTO] += SE1->E1_SDDECRE
			EndIf

			If ! (SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG) .And. ;
			   ! ( MV_PAR14 == 2 .And. nSaldo == 0 ) // nao deve olhar abatimento pois e zerado o saldo na liquidacao final do titulo
				nSaldo -= nTotAbat
			EndIf
		
			Do Case
				Case SE1->E1_SITUACA $ "01234567"
					cSitCobr := aSituacao[Val(SE1->E1_SITUACA)+1]
				Case SE1->E1_SITUACA == "F"	//Carteira Protesto
					cSitCobr := aSituacao[9]
				Case SE1->E1_SITUACA == "G"	//Carteira Acordo
					cSitCobr := aSituacao[10]
				Case SE1->E1_SITUACA == "H"	//Cartorio
					cSitCobr := aSituacao[11]
				OtherWise               
					cSitCobr := " "
			EndCase
			
			@li,  0 PSAY SE1->E1_PREFIXO+"-"+SE1->E1_NUM
			@li, 16 PSAY SE1->E1_PARCELA
			@li, 20 PSAY SE1->E1_TIPO
		
			@li, 24 PSAY SayValor(xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),14,;
			alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)
	
			@li, 39 PSAY SE1->E1_EMISSAO
			@li, 50 PSAY SE1->E1_VENCREA
			IF dDataBase >= SE1->E1_BAIXA .Or. (mv_par14 == 2 .And. !Empty(SE1->E1_BAIXA))
				@li, 61 PSAY IIF(!Empty(SE1->E1_BAIXA),SE1->E1_BAIXA," ")
			Endif
			@li, 72 PSAY aValor[I_DESCONTO]               Picture TM(aValor[I_DESCONTO]			 ,13,nDecs)
			@li, 85 PSAY nTotAbat                         Picture TM(nTotAbat					 ,13,nDecs)
			@li, 98 PSAY aValor[I_JUROS]                  Picture TM(aValor[I_JUROS]			 ,13,nDecs)
			@li,111 PSAY aValor[I_MULTA]                  Picture TM(aValor[I_MULTA]			 ,13,nDecs)
			//@li,124 PSAY aValor[I_CORRECAO_MONETARIA]     Picture TM(aValor[I_CORRECAO_MONETARIA],13,nDecs)
			@li,124 PSAY Iif(Empty(SE1->E1_BAIXA), 0, SE1->E1_Baixa - SE1->E1_VencRea) Picture TM(99999,6,0)
			@li,131 PSAY Iif(Empty(SE1->E1_BAIXA), Date() - SE1->E1_VencRea, SE1->E1_Baixa - SE1->E1_VencRea) Picture TM(99999,6,0)
			@li,138 PSAY aValor[I_VALOR_RECEBIDO]         Picture TM(aValor[I_VALOR_RECEBIDO]	  ,15,nDecs)
			@li,155 PSAY aValor[I_RECEB_ANT]              Picture TM(aValor[I_RECEB_ANT]		  ,13,nDecs)   	
		
			@li,169 PSAY SayValor(nSaldo,15,alltrim(SE1->E1_TIPO)$MVRECANT+","+MV_CRNEG,nDecs)
			@li,185 PSAY Pad(aValor[I_MOTBX],15)
			@li,203 PSAY cSitCobr
			@li,218 PSAY SE1->E1_PORTADO
		
			If ! ( SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG )
				nTit1+= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,nDecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nTit7+=aValor[I_VALOR_RECEBIDO]
				nTit9+=nSaldo
			Else
				nTit1-= xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,ndecs+1,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nTit7-=aValor[I_VALOR_RECEBIDO]
				nTit9-=nSaldo
			Endif
		
			nTit2+=aValor[I_DESCONTO]
			nTit3+=nTotAbat
			nTit4+=aValor[I_JUROS]
			nTit5+=aValor[I_MULTA]
			//nTit6+=aValor[I_CORRECAO_MONETARIA]
			// Atraso Pagamento
			nTit6 += SE1->E1_VALOR * Iif(Empty(SE1->E1_BAIXA), 0, SE1->E1_Baixa - SE1->E1_VencRea)
			// Atraso do título
			nTit10 += SE1->E1_VALOR * Iif(Empty(SE1->E1_BAIXA), Date() - SE1->E1_VencRea, SE1->E1_Baixa - SE1->E1_VencRea)
			
			nTit8+=aValor[I_RECEB_ANT]
		
			If cPaisLoc<>"BRA"
				cMotivo:= SE1->E1_TIPO+"   "+ Substr(aValor[I_MOTBX],1,10)
		        nvalor:=xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,SE1->E1_EMISSAO,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
				nPos := aScan(aMotBx,{|X| x[1]== cMotivo})
		
				If nPos > 0
			   	 	aMotBx[nPos][2]+= nvalor
				else
   					Aadd(aMotBx,{cMotivo,nvalor})
				Endif	
			Endif
			dbSelectArea("SE1")
			dbSkip()
			li++
		Enddo
	
		If ( ABS(nTit1)+ABS(nTit2)+ABS(nTit3)+ABS(nTit4)+ABS(nTit5)+ABS(nTit6)+ABS(nTit7)+ABS(nTit8)+ABS(nTit9) > 0 )
			ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nTit10,nDecs)
			li++
			nTot1 += nTit1
			nTot2 += nTit2
			nTot3 += nTit3
			nTot4 += nTit4
			nTot5 += nTit5
			nTot6 += nTit6
			nTot7 += nTit7
			nTot8 += nTit8
			nTot9 += nTit9    
			nTot10 += nTit10    
			
			nTotFil1 += nTit1
			nTotFil2 += nTit2
			nTotFil3 += nTit3
			nTotFil4 += nTit4
			nTotFil5 += nTit5
			nTotFil6 += nTit6
			nTotFil7 += nTit7
			nTotFil8 += nTit8			
			nTotFil9 += nTit9			
			nTotFil10 := nTit10
		Endif
	Enddo        

	SE1->(DbCloseArea())			
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir TOTAL por filial somente quan-³
	//³ do houver mais do que 1 filial.        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if mv_par20 == 1 .and. SM0->(Reccount()) > 1
		ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nDecs)	
	Endif
	Store 0 To nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10
	If Empty(xFilial("SE1"))
		Exit
	Endif	

	SM0->(DbSkip())
EndDo

SM0->(dbGoTo(nRegSM0))
cFilAnt := SM0->M0_CODFIL

IF li > 55 .and. li != 80
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
End

IF li != 80
	If cPaisLoc<>"BRA"
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,nTot10,aMotBx,nDecs)
	else	
		ImpTotG(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,nTot10,,nDecs)
	Endif
	roda(cbcont,cbtxt,tamanho)
EndIF

Set Device TO Screen

#IFNDEF TOP
	dbSelectArea("SE1")
	dbClearFil()
	RetIndex( "SE1" )
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
	dbSetOrder(1)
#ELSE
	if TcSrvType() != "AS/400"
		If Select("NEWSE1") > 0
			dbSelectArea("NEWSE1")
			dbCloseArea()		
		Endif
		dbSelectArea("SE1")
		dbCloseArea()
		ChkFile("SE1")
		dbSelectArea("SE1")
		dbSetOrder(1)
	else
		dbSelectArea("SE1")
		dbClearFil()
		RetIndex( "SE1" )
		If !Empty(cIndex)
			FErase (cIndex+OrdBagExt())
		Endif
		dbSetOrder(1)
	endif
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ImpSubTot ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao da Linha de SubTotal do Relatorio                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpSubTot()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpSubTot(nTit1,nTit2,nTit3,nTit4,nTit5,nTit6,nTit7,nTit8,nTit9,nTit10,nDecs)

li++
@li,  0 PSAY OemToAnsi(STR0016)  //"Totais : "
@li,021 PSAY nTit1   Picture TM(nTit1,17,nDecs)
@li,072 PSAY nTit2   Picture TM(nTit2,13,nDecs)
@li,085 PSAY nTit3   Picture TM(nTit3,13,nDecs)
@li,098 PSAY nTit4   Picture TM(nTit4,13,nDecs)
@li,111 PSAY nTit5   Picture TM(nTit5,13,nDecs)
//@li,124 PSAY nTit6   Picture TM(nTit6,13,nDecs)
// calcula a média de dias de pagamento em atraso
@li,124 PSAY Round(nTit6/nTit1, 0) Picture TM(99999,6,0)
// calcula a média de dias de atraso de títulos
@li,131 PSAY Round(nTit10/nTit1, 0) Picture TM(99999,6,0)
@li,138 PSAY nTit7   Picture TM(nTit7,15,nDecs)
@li,155 PSAY nTit8   Picture TM(nTit8,13,nDecs)
@li,169 PSAY nTit9   Picture TM(nTit9,15,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li++
Return(.T.)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ImpTotg  ³ Autor ³ Paulo Boschetti       ³ Data ³ 01.06.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao da linha de Total                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpTotG()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ImpTotg(nTot1,nTot2,nTot3,nTot4,nTot5,nTot6,nTot7,nTot8,nTot9,nTot10,aMotBx,nDecs)
Local ntotaltipo:=0
Local cTipoant:=" "
Local i
li++
@li,0 PSAY OemToAnsi(STR0017)  //"TOTAL GERAL : "
@li,021 PSAY nTot1   Picture TM(nTot1,17,nDecs)
@li,072 PSAY nTot2   Picture TM(nTot2,13,nDecs)
@li,085 PSAY nTot3   Picture TM(nTot3,13,nDecs)
@li,098 PSAY nTot4   Picture TM(nTot4,13,nDecs)
@li,111 PSAY nTot5   Picture TM(nTot5,13,nDecs)
//@li,124 PSAY nTot6   Picture TM(nTot6,13,nDecs)
@li,124 PSAY Round(nTot6/nTot1, 0)   Picture TM(99999,6,0)
@li,131 PSAY Round(nTot10/nTot1, 0)   Picture TM(99999,6,0)

@li,138 PSAY nTot7   Picture TM(nTot7,15,nDecs)
@li,155 PSAY nTot8   Picture TM(nTot8,13,nDecs)
@li,169 PSAY nTot9   Picture TM(nTot9,15,nDecs)
li++

If cPaisLoc<>"BRA"
	@li,0 PSAY OemToAnsi(STR0027)     //"TOTAL POR MOTIVO : "
	li:=li+2

	aMotBX:=asort(aMotBX,,,{|x,y| x[1] < y[1]})
	For i:=1 to Len(aMotBx)
		If cTipoant==" "
	   	cTipoant:=subs(aMotBX[i][1],1,3)
		Endif
		If  ctipoant	== subs(aMotBX[i][1],1,3)
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2] 
			ctipoant:=subs(aMotBX[i][1],1,3)
		else 
			@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
			@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)	
			ntotaltipo:=0
			li:=li+2
			@ Li,001 PSAY aMotBX[i] [1]
			@ Li,025 PSAY aMotBX[i] [2] Picture PesqPict("SE1","E1_VALOR",17,MV_PAR10)
			ntotaltipo += aMotBX[i] [2] 
			ctipoant:=subs(aMotBX[i][1],1,3)
		Endif	
		IF li > 55 
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
		End
		Li++
	Next i
	@ Li,001 PSAY OemToAnsi(STR0016) + ctipoant
	@ Li,025 PSAY ntotaltipo PicTure PesqPict("SE1","E1_VALOR",17,MV_PAR10)
Endif
Return(.T.)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³FR340FIL  ³ Autor ³ Andreia           	³ Data ³ 11.01.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Monta Indregua para impressao do relat¢rio				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FR340FIL()
Local cString

cString := 'E1_FILIAL="'+xFilial()+'".And.'
cString += 'dtos(E1_EMISSAO)>="'+dtos(mv_par05)+'".and.dtos(E1_EMISSAO)<="'+dtos(mv_par06)+'".And.'
cString += 'dtos(E1_VENCREA)>="'+dtos(mv_par07)+'".and.dtos(E1_VENCREA)<="'+dtos(mv_par08)+'".And.'
cString += 'E1_CLIENTE>="'+mv_par01+'".and.E1_CLIENTE<="'+mv_par02+'".And.'
cString += 'E1_LOJA>="'+mv_par03+'".and.E1_LOJA<="'+mv_par04+'".and.'
cString += 'E1_NATUREZ>="'+mv_par16+'".and.E1_NATUREZ<="'+mv_par17+'"'
If cPaisLoc<>"BRA"
	cString +='.and. !(E1_TIPO$"TF~CH")'
EndIf

Return cString

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³SayValor  ³ Autor ³ J£lio Wittwer    	    ³ Data ³ 24.06.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna String de valor entre () caso Valor < 0			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR340.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SayValor(nNum,nTam,lInvert,nDecs)
Local cPicture,cRetorno
cPicture := tm(nNum,nTam,nDecs)
cRetorno := Transform(nNum,cPicture)
IF nNum<0 .or. lInvert
	cPicture := tm(nNum,nTam-2,nDecs)
	cRetorno := Transform(nNum,cPicture)
   cRetorno := Right(Space(10)+"("+Alltrim(StrTran(cRetorno,"-",""))+")",nTam+1)
Endif
Return cRetorno

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fr340Skip ³ Autor ³ Pilar S. Albaladejo	³ Data ³ 13.10.99 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Pula registros de acordo com as condicoes (AS 400/CDX/ADS)  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINR340.PRX												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fr340Skip()

Local lRet := .T.
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se esta dentro dos parametros                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF SE1->E1_CLIENTE < mv_par01 .OR. SE1->E1_CLIENTE > mv_par02 .OR. ;
	SE1->E1_LOJA    < mv_par03 .OR. SE1->E1_LOJA    > mv_par04 .OR. ;
	SE1->E1_EMISSAO < mv_par05 .OR. SE1->E1_EMISSAO > mv_par06 .OR. ;
	SE1->E1_VENCREA < mv_par07 .OR. SE1->E1_VENCREA > mv_par08 .OR. ;
	SE1->E1_NATUREZ < mv_par16 .OR. SE1->E1_NATUREZ > mv_par17 .OR. ;
	SE1->E1_TIPO $ MVABATIM
	lRet := .F.
	
ElseIF SE1->E1_EMISSAO > dDataBase
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo ‚ provis¢rio                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf (SE1->E1_TIPO $ MVPROVIS .and. mv_par09==2)
	lRet := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o t¡tulo foi aglutinado em uma fatura            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ElseIf !Empty(SE1->E1_FATURA) .and. Substr(SE1->E1_FATURA,1,6) != "NOTFAT"
	lRet := IIF(mv_par12 == 1, .T., .F.)	// Considera Faturados = mv_par12
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve imprimir outras moedas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Elseif mv_par13 == 2 // nao imprime
	If SE1->E1_MOEDA != mv_par10 //verifica moeda do campo=moeda parametro
		lRet	:= .F.
	Endif
Endif

Return lRet


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Mauricio Pequim Jr.	³ Data ³ 03/06/04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Siga                                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local aPergs	:= {}
Local nJ			:= 0



Aadd(aPergs,{"Da Natureza ?","¿De Modalidad?","From Nature ?","mv_chg","C",10,0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","SED","S","",".FIN13011."})
Aadd(aPergs,{"Ate a Natureza ?","¿A Modalidad?","To Nature ?","mv_chh","C",10,0,0,"G","","mv_par17","","","","ZZZZZZZZZZ","","","","","","","","","","","","","","","","","","","","","SED","S","",".FIN13012."})
Aadd(aPergs,{"Considera Liquidados ?","¿Considera Liquidados ?","Consider Settled ?","mv_chi","N",1,0,1,"C","","mv_par18","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",".FIC01009."})
Aadd(aPergs,{"Cons. Baixas por Recibo?","¿Cons. Bajas por Recibo?","Cons. Baixas por Recibo?","mv_chj","N",1,0,1,"C","","mv_par19","Sim","Si","Yes","","","Nao","No","No","","","","","","","","","","","","","","","","","","S","",""})
aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
	"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
	"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
	"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
	"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
	"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
	"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
	"X1_F3","X1_PYME","X1_GRPSXG","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)

If MsSeek(cPerg+Right(aPergs[1][11], 2)) .AND. Upper(Alltrim((aPergs[1][1]))) <> Upper(Alltrim(SX1->(X1_PERGUNT)))
	RecLock("SX1",.F.)
	Replace X1_PERGUNT with aPergs[1][1]
	MsUnlock()
EndIf

For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
				Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
					FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."
		
		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif
		
		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next  
aHelpPor	:= {}
aHelpEng	:= {}
aHelpSpa	:= {}

Aadd( aHelpPor, "Indica se os titulos que foram baixados " )
Aadd( aHelpPor, "pelo recibo devem ser listados.          " )

Aadd( aHelpSpa, "Indica si deben listarse los titulos dados " )
Aadd( aHelpSpa, "de baja por el recibo.                     " )

Aadd( aHelpEng, "Indicates if bills posted by the receipt " )
Aadd( aHelpEng, "must be listed.                          " )

cKey := "P."+cPerg+"19."
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

PutSx1( "FIN340", "20","Cons.Filiais abaixo ?"	,"+Considera Siguientes Suc ?"	,"Cons.Branches Below ?","mv_chi","N",1		,0		  ,2	  ,"C",""   ,""	 ,""	  ,""	,"mv_par20"	,"Sim"	,"Si"	,"Yes"	 ,""	,"Nao"	,"No"	,"No"	,""	  ,""     ,""	  ,""	,""		 ,"" 	 ,"" 	,""		,""		 ,/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,".FIN13021.")

PutSx1( "FIN340", "21","Da Filial ?"		,"De Sucursal ?"	,"From Branch ?"	,"mv_chj","C",2,0,0,"G","",""	 ,""	,"","mv_par21",""		,""			,""			 ,""		,"Nao"		,""			,""			,""			 ,""	 	,""			,""			 ,""		,""			,""			 ,""		,""			,/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,".FIN13022.")

PutSx1( "FIN340", "22","Ate a Filial ?"		,"A Sucursal ?"		,"To Branch ?"		,"mv_chk","C",2,0,0,"G","",""	 ,""	,"","mv_par22",""		,""			,""			 ,"ZZ"		,""			,""			,""			 ,""	 	,""			,""			 ,""		,""			,""			 ,""		,""			,""			 ,/*aHelpPor*/,/*aHelpEng*/,/*aHelpSpa*/,".FIN13023.")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³ ImpFil340³ Autor ³ Adrianne Furtado 	  	³ Data ³ 27.10.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprimir total do relatorio										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ ImpFil340()																  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³																				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	    ³ Generico																	  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
STATIC Function ImpFil340(nTotFil1,nTotFil2,nTotFil3,nTotFil4,nTotFil5,nTotFil6,nTotFil7,nTotFil8,nTotFil9,nTotFil10,nDecs)

DEFAULT nDecs := Msdecimais(mv_par15)

li--
IF li > 58
	nAtuSM0 := SM0->(Recno())
	SM0->(dbGoto(nRegSM0))
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	SM0->(dbGoTo(nAtuSM0))
EndIF

@li,000 PSAY OemToAnsi(STR0056)+" "+Iif(mv_par20==1,cFilAnt+" - " + AllTrim(SM0->M0_FILIAL),"")  //"T O T A L   F I L I A L ----> "
@li,050 PSAY nTotFil1 Picture TM(nTotFil1,14,nDecs)
@li,075 PSAY nTotFil2 Picture TM(nTotFil2,10,nDecs)
@li,088 PSAY nTotFil3 Picture TM(nTotFil3,10,nDecs)
@li,101 PSAY nTotFil4 Picture TM(nTotFil4,10,nDecs)
@li,114 PSAY nTotFil5 Picture TM(nTotFil5,10,nDecs)
//@li,127 PSAY nTotFil6 Picture TM(nTotFil6,10,nDecs)
@li,127 PSAY Round(nTotFil6/nTotFil1, 0) Picture TM(99999,6,0)
@li,135 PSAY Round(nTotFil10/nTotFil1, 0) Picture TM(99999,6,0)
@li,143 PSAY nTotFil7 Picture TM(nTotFil7,10,nDecs)
@li,158 PSAY nTotFil8 Picture TM(nTotFil8,10,nDecs)
@li,174 PSAY nTotFil9 Picture TM(nTotFil9,10,nDecs)
li++
@li,000 PSAY Replicate("-",220)
li+=2
Return .T.
