#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPER340.CH"
#INCLUDE "report.ch"


/*

ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER340  ³ Autor ³ R.H. - Marcos Stiefano    ³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Cargos e Salarios                                   ³±±                  -
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER340(void)                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauro      ³ 12/01/01 ³------³ Nao estava Filtrando categoria na Impress  ³±±
±±³ Silvia     ³ 04/03/02 ³------³ Ajustes na Picture para Localizacoes    .  ³±±
±±³ Natie      ³ 05/09/02 ³------³ Acerto devido mudanca C.custo c/tam 20     ³±±
±±³ Emerson    ³ 16/10/02 ³------³ Somente quebrar C.C. se nao quebrou Fil.   ³±±
±±³ Mauro      ³ 13/11/02 ³060517³ Saltar Pagina a cada Quebra de Filial      ³±±
±±³ Silvia     ³ 11/09/03 ³065152³ Inclusao de Query                          ³±±
±±³ Emerson    ³ 23/03/04 ³------³ Inclusao de 2 casas decimais na criacao    ³±±
±±³            ³          ³      ³ dos campos SALMES e SALHORA.	 	          ³±±
±±³ Mauro      ³ 01/06/04 ³071194³ Nao estava aceitando o filtro da setprint  ³±±
±±³            ³          ³      ³ quando executava atraves da query.         ³±±
±±³ Pedro Eloy ³ 30/08/04 ³073001³ Fiz o  tratamento para obedecer o filtro   ³±±
±±³            ³          ³      ³ da SetPrint e continuar tratar paramtros.  ³±±
±±³ Natie      ³ 21/02/05 ³077851³ Tratamento do filtro da Setprint(TOPCONN)  ³±±
±±³ Natie      ³ 06/07/05 ³080497³ Ajuste nos mv_par das perg.15,16 e 17      ³±±
±±³ Andreia    ³ 11/07/06 ³100892³ Acerto para quando for TOP	e existir fil-³±±
±±³            ³          ³      ³ tro, passar o conteudo do filtro em letra  ³±±
±±³            ³          ³      ³ maiuscula para a funcao GPEParSQL(), para  ³±±
±±³            ³          ³      ³ que ela converta a expressao para SQL.     ³±±
±±³Tania 	   ³14/07/2006³100169³ Conversao em Relatorio personalizavel para ³±±
±±³        	   ³          ³      ³ atender ao Release 4.                      ³±±
±±³Luiz Gustavo|24/01/2007³      ³Retiradas funcoes de ajuste de dicionario   ³±±
±±³Pedro Eloy  ³10/09/2007³132217³ Habilitado a impressao para retrato.       ³±±
±±³Renata E    ³26/09/2007³133191³ Ajuste no relatorio Release 4, na quebra   ³±±
±±³            ³          ³      ³ por centro de custo						  ³±±
±±³ Pedro Eloy ³15/10/2007³130834³ Ajuste no SRA com a funcao TRPosition.     ³±±
±±³ Pedro Eloy ³16/10/2007³134528³ Tratamento quando for contido no filtro.   ³±±
±±³ Alexandre  ³21/11/2007³104793³ Implemntado Querys para trazer a quanti-   ³±±
±±³ Conselvan  ³          ³      ³ dade de registros que serão processados    ³±±
±±³            ³          ³      ³ assim a regua progriderá corretamente      ³±±
±±³            ³          ³      ³ ate o final                                ³±±
±±|Bruno       ³20/02/2008³139689³Realizado tratamento nos filtros "esta      ³±±
±±|            ³          ³      ³contido em" e "nao esta contido"            ³±±
±±|Luciana     ³07/04/2008³141696³ Ajuste para exibir a descrição do cen-     ³±±
±±|            ³          ³      ³ tro de custo ao lado do código.            ³±±
±±|            ³          ³      ³                                            ³±±
±±|Bruno       ³28/04/2008³144433³ Ajustes na rotina para que sem             ³±±
±±|   		   ³		  ³		 ³ filtro seja mostrada corretamente.	      ³±±
±±³Marcelo     ³07/05/2008³147113³ Acerto na funcao GP340R para quebrar ou nao³±±
±±³            ³          ³      ³ por Centro de Custo conforme os parametros.³±±
±±³Marcelo     ³11/07/2008³148274³ Comentado o metodo NoUserFilter para que o ³±±
±±³            ³          ³      ³ filtro personalizado (R4) seja considerado.³±±
±±³            ³          ³      ³ Adaptacao da query para relacionar correta-³±±
±±³            ³          ³      ³ mente quando a tabela SRJ for exclusiva.   ³±±
±±³Marcelo     ³16/02/2009³002421³ Acerto para imprimir Centros de Custos com ³±±
±±³            ³          ³ /2009³ mais de 9 casas decimais.                  ³±±
±±³Leandro Dr. ³16/03/2009³005317³ Ajuste no pergunte GPR340 do R3.           ³±±
±±³Reginaldo   ³19/08/2009³020741³ Ajuste no grupo de campos filial.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ FNC  ³  Motivo da Alteracao                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Alceu P.    ³13/01/2011³00000028395/2010³Corrigido para que saia no cabeçalho o nome do³±± 
±±³            ³          ³                ³relatório mais a ordem em que o mesmo estiver ³±±
±±³            ³          ³                ³sendo impressa.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/    
User Function GPER340()
Local	oReport   
Local	aArea 	:= GetArea()
Private	cString	:= "SRA"				// alias do arquivo principal (Base)
Private cPosit	:= "SRJ"
Private cPerg	:= "GPR340"
//"GP340R_SX1T"  
Private aOrd    := {OemToAnsi(STR0001),OemToAnsi(STR0002),OemToAnsi(STR0003),OemToAnsi(STR0029),	;
					OemToAnsi(STR0030),OemToAnsi(STR0031),"Segmento"}	
					//"C.Custo + Matricula "###"C.Custo + Nome"###"C.Custo + Fun‡„o"###"Nome"###"Matricula"###"Fun‡„o"
Private cTitulo	:= OemToAnsi(STR0009)	//"RELA€O DE CARGOS E SALARIOS"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

GPER340R3()

RestArea( aArea )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER340  ³ Autor ³ R.H. - Marcos Stiefano³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Cargos e Salarios                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER340(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                     ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Mauro      ³12/01/01³------³ Nao estava Filtrando categoria na Impress³±±
±±³ Silvia     ³04/03/02³------³ Ajustes na Picture para Localizacoes    .³±±
±±³ Natie      ³05/09/02³------³ Acerto devido mudanca C.custo c/tam 20   ³±±
±±³ Emerson    ³16/10/02³------³ Somente quebrar C.C. se nao quebrou Fil. ³±±
±±³ Mauro      ³13/11/02³060517³ Saltar Pagina a cada Quebra de Filial    ³±±
±±³ Silvia     ³11/09/03³065152³ Inclusao de Query                        ³±±
±±³ Emerson    ³23/03/04³------³ Inclusao de 2 casas decimais na criacao  ³±±
±±³            ³        ³      ³ dos campos SALMES e SALHORA. 		      ³±±
±±³ Mauro      ³01/06/04³071194³ Nao estava aceitando o filtro da setprint³±±
±±³            ³        ³      ³ quando executava atraves da query.       ³±±
±±³ Pedro Eloy ³30/08/04³073001³ Fiz o  tratamento para obedecer o filtro ³±±
±±³            ³        ³      ³ da SetPrint e continuar tratar paramtros.³±±
±±³ Natie      ³21/02/05³077851³ Tratamento do filtro da Setprint(TOPCONN)³±±
±±³ Natie      ³06/07/05³080497³ Ajuste nos mv_par das perg.15,16 e 17    ³±±
±±³ Andreia    ³11/07/06³100892³ Acerto para quando for TOP	e existir fil-³±±
±±³            ³        ³      ³ tro, passar o conteudo do filtro em letra³±±
±±³            ³        ³      ³ maiuscula para a funcao GPEParSQL(), para³±±
±±³            ³        ³      ³ que ela converta a expressao para SQL.   ³±±
±±³ Pedro Eloy ³08/02/07³116053³ Ajuste quando  nao  for  para  mostrar a ³±±
±±³            ³        ³      ³ totalização fil/empr.= "Nao" ordem Funcao³±±
±±³ Alexandre  ³21/11/07³104793³ Implemntado Querys para trazer a quanti- ³±±
±±³ Conselvan  ³        ³      ³ dade de registros que serão processados  ³±±
±±³            ³        ³      ³ assim a regua progriderá corretamente    ³±±
±±³            ³        ³      ³ ate o final							  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GPER340R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString := "SRA"        // alias do arquivo principal (Base)
Local aOrd    := {STR0001,STR0002,OemtoAnsi(STR0003),STR0029,STR0030,OemtoAnsi(STR0031),"Segmento"}    //"C.Custo + Matricula "###"C.Custo + Nome"###"C.Custo + Fun‡„o"###"Nome"###"Matricula"###"Fun‡„o"
Local cDesc1  := STR0004		//"Rela‡„o de Cargos e Salario."
Local cDesc2  := STR0005		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  := STR0006		//"usuario."
Local aRegs	  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0007,1,STR0008,2,2,1,"",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg := "GPER340"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    := "GPR340"  


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo   := STR0009		//"RELA€O DE CARGOS E SALARIOS"
Private AT_PRG   := "GPER340"
Private Wcabec0  := 2
Private Wcabec1  := STR0010		//"FI  MATRIC NOME                           ADMISSAO   FUNCAO                  MAO DE       SALARIO   PERC.   PERC.   PERC."
Private Wcabec2  := STR0011		//"                                                                                      OBRA         NOMINAL  C.CUSTO  FILIAL  EMPRESA"
Private CONTFL   := 1
Private LI		  := 0
Private nTamanho := "M"
Private cPict1	:=	If (MsDecimais(1)==2,"@E 999,999,999,999.99",TM(999999999999,18,MsDecimais(1)))  // "@E 999,999,999,999.99
Private cPict2	:=	If (MsDecimais(1)==2,"@E 999,999,999.99",TM(999999999,14,MsDecimais(1)))  // "@E 999,999,999.99


//FI C.CUSTO	MATRIC NOME             				  ADMISSAO FUNCAO 						 MAO DE		  SALARIO	PERC.   PERC.	 PERC."
// 																												 OBRA 		  NOMINAL  C.CUSTO  FILIAL  EMPRESA"
//01 123456789 123456 123456789012345678901234567890 01/01/01 1234 12345678901234567890  IND   99.999.999,99	999,99  999,99   999,99
ValidPerg()
Pergunte("GPR340CUSX",.F.)  //Totvs Unidade Cascavel

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER340"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
EndIf

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
EndIf

RptStatus({|lEnd| GP340Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GP340IMP ³ Autor ³ R.H.                  ³ Data ³ 15.04.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ImpressÆo da Relacao de Cargos e Salarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GP340IMP(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GP340IMP(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSalario   := nSalMes := nSalDia := nSalHora := 0
Local aTFIL 	 := {}
Local aTCC       := {}
Local aTSC       := {}
Local aTFILF	 := {}
Local aTCCF 	 := {}
Local TOTCC      := 0 //Alterado o Tipo de Array para Numerico
Local TOTCCF     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFIL     := 0 //Alterado o Tipo de Array para Numerico
Local TOTFILF    := 0 //Alterado o Tipo de Array para Numerico
Local cAcessaSRA := &("{ || " + ChkRH("GPER340","SRA","2") + "}")
Local aStruSRA                                          
Local cArqNtx   := cIndCond := ""
Local cAliasSRA := "SRA" 	//Alias da Query
Local nS
Local nX
Local X
Local W
Local cFilter	:= aReturn[7]
Local nTamCC	:= TamSX3("CTT_CUSTO")[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aInfo     := {}
Private aCodFol   := {}
Private aRoteiro  := {}
Private lQuery

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem	    := aReturn[8]
cFilDe	    := mv_par01									//  Filial De
cFilAte	    := mv_par02									//  Filial Ate
cCcDe 	    := mv_par03									//  Centro de Custo De
cCcAte	    := mv_par04									//  Centro de Custo Ate
cMatDe	    := mv_par05									//  Matricula De
cMatAte	    := mv_par06									//  Matricula Ate
cNomeDe	    := mv_par07									//  Nome De
cNomeAte    := mv_par08									//  Nome Ate
cFuncDe	    := mv_par09									//  Funcao De
cFuncAte    := mv_par10									//  Funcao Ate
cSituacao   := mv_par11									//  Situacao Funcionario
cCategoria  := mv_par12									//  Categoria Funcionario
lSalta	    := If( mv_par13 == 1 , .T. , .F. )	  	    //  Salta Pagina Quebra C.Custo
nQualSal    := mv_par14									//  Sobre Salario Mes ou Hora
nBase       := mv_par15                                 //  Sobre Salario Composto Base
nTipoRel    := mv_par16                                 //  Imprime             Analitico               Sintetico
lImpTFilEmp := If( mv_par17 == 1 , .T. , .F. )		    //  Imprime Total Filial/Empresa      


//-- Modifica variaveis para a Query
cSitQuery := " "
For nS:=1 to Len(cSituacao)
	cSitQuery += "'"+Subs(cSituacao,nS,1)+"'"
	If ( nS+1) <= Len(cSituacao)
		cSitQuery += "," 
	Endif
Next nS
 
cCatQuery := ""           
For nS:=1 to Len(cCategoria)
	cCatQuery += "'"+Subs(cCategoria,nS,1)+"'"
	If ( nS+1) <= Len(cCategoria)
		cCatQuery += "," 
	Endif
Next nS                 
 

Titulo := STR0012			//"RELACAO DE CARGOS E SALARIOS "
If nOrdem==1
	Titulo += STR0013		//"(C.CUSTO + MATRICULA)"
ElseIf nOrdem==2
	Titulo +=STR0014		//"(C.CUSTO + NOME)"
ElseIf nOrdem==3 
	Titulo +=STR0015		//"(C.CUSTO + FUNCAO)"
ElseIf nOrdem == 4		
	Titulo +=STR0034		//"(NOME)"
ElseIf nOrdem == 5		
	Titulo +=STR0035		//"(MATRICULA)"
ElseIf nOrdem == 6		
	Titulo +=STR0036		//"(FUNCAO)"
ElseIf nOrdem == 7
	Titulo +=("SEGMENTO")
EndIf		

aCampos := {}
AADD(aCampos,{"FILIAL"   ,"C",FWGETTAMFILIAL,0})
AADD(aCampos,{"MAT"      ,"C",06,0})
AADD(aCampos,{"CC"       ,"C",nTamCC,0})
AADD(aCampos,{"SALMES"   ,"N",TamSX3("RA_SALARIO")[1],2})
AADD(aCampos,{"SALHORA"  ,"N",TamSX3("RA_SALARIO")[1],2})
AADD(aCampos,{"CODFUNC"  ,"C",05,0})
AADD(aCampos,{"NOME"     ,"C",30,0})
AADD(aCampos,{"ADMISSA"  ,"D",08,0})
AADD(aCampos,{"CLVL"  	,"C",09,0})

cNomArqA:=CriaTrab(aCampos)
dbUseArea( .T., __cRDDNTTS, cNomArqA, "TRA", if(.F. .Or. .F., !.F., NIL), .F. )
// Sempre na ordem de Centro de Custo + Matricula para totalizar
dbSelectArea( "SRA" )
lQuery	:=	.F.

#IFDEF TOP  	
	If TcSrvType() != "AS/400"
		lQuery	:=.T.
	Endif
#ENDIF	

If lQuery
	cQuery := "SELECT * "		
	cQuery += " FROM "+	RetSqlName("SRA")
	cQuery += " WHERE "
	If !lImpTFilEmp
		cQuery += " RA_FILIAL  between '" + cFilDe  + "' AND '" + cFilAte + "' AND"
		cQuery += " RA_MAT     between '" + cMatDe  + "' AND '" + cMatAte + "' AND"
		cQuery += " RA_NOME    between '" + cNomeDe + "' AND '" + cNomeAte+ "' AND"
		cQuery += " RA_CC      between '" + cCcDe   + "' AND '" + cCcate  + "' AND"
		cQuery+=  " RA_CODFUNC between '" + cFuncDe + "' AND '" + cFuncAte+ "' AND"
	Endif
	cQuery += " RA_CATFUNC IN (" + Upper(cCatQuery) + ") AND" 
	cQuery += " RA_SITFOLH IN (" + Upper(cSitQuery) + ") AND" 
	If TcSrvType() != "AS/400"
		cQuery += "  D_E_L_E_T_ <> '*' "
	Else
		cQuery += "  @DELETED@  <> '*' "	
	Endif 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver filtro executa parse para converter expressoes adv para SQL    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   
	If nOrdem <> 7
		cQuery += " ORDER BY RA_FILIAL, RA_CC, RA_MAT"
	Else
		cQuery += " ORDER BY RA_FILIAL, RA_X_SEGME, RA_CODFUNC "	
	Endif
	
	cQuery := ChangeQuery(cQuery)	
	aStruSRA := SRA->(dbStruct())
	SRA->( dbCloseArea() )
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'SRA', .F., .T.)
	For nX := 1 To Len(aStruSRA)
		If ( aStruSRA[nX][2] <> "C" )
			TcSetField(cAliasSRA,aStruSRA[nX][1],aStruSRA[nX][2],aStruSRA[nX][3],aStruSRA[nX][4])
		EndIf
	Next nX
Else
	dbSetOrder(2)					
	dbGoTop()
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento											  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lQuery
	cQuery := "SELECT COUNT(*) AS NTOREG "		
	cQuery += " FROM "+	RetSqlName("SRA")
	cQuery += " WHERE "
	If !lImpTFilEmp
		cQuery += " RA_FILIAL  between '" + cFilDe  + "' AND '" + cFilAte + "' AND"
		cQuery += " RA_MAT     between '" + cMatDe  + "' AND '" + cMatAte + "' AND"
		cQuery += " RA_NOME    between '" + cNomeDe + "' AND '" + cNomeAte+ "' AND"
		cQuery += " RA_CC      between '" + cCcDe   + "' AND '" + cCcate  + "' AND"
		cQuery+=  " RA_CODFUNC between '" + cFuncDe + "' AND '" + cFuncAte+ "' AND"
	Endif
	cQuery += " RA_CATFUNC IN (" + Upper(cCatQuery) + ") AND" 
	cQuery += " RA_SITFOLH IN (" + Upper(cSitQuery) + ") AND" 
	If TcSrvType() != "AS/400"
		cQuery += "  D_E_L_E_T_ <> '*' "
	Else
		cQuery += "  @DELETED@  <> '*' "	
	Endif 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver filtro executa parse para converter expressoes adv para SQL    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cQuery := ChangeQuery(cQuery)	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'NREG', .F., .T.)
	nRegProc := NREG->NTOREG
	SetRegua(nRegProc)
	( "NREG" )->( dbCloseArea() )	
	dbSelectArea("SRA")
Else
	SetRegua(RecCount())
Endif     

cFilialAnt := replicate("!", FWGETTAMFILIAL)
cFANT 	  := replicate("!", FWGETTAMFILIAL)
cCANT 	  := Space(20)
cSANT 	  := Space(20)

TPAGINA	 := TEMPRESA := TFILIAL := TCCTO := FL1 := 0
TEMPRESAF := TFILIALF := TCCTOF	:= 0

While !Eof()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento										  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	EndIf
	If !Empty(cFilter) .and. !&(cFilter)
		dbSkip()
		Loop
	Endif 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Quebra de Filial 											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_FILIAL # cFilialAnt
		If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL) 			 .Or.;
			!fInfo(@aInfo,SRA->RA_FILIAL)
			dbSelectArea("SRA")
			dbSkip()
			If Eof()
				Exit
			Endif	
			Loop
		Endif
		dbSelectArea( "SRA" )
		cFilialAnt := SRA->RA_FILIAL
	EndIf

	If !lQuery
		IF !lImpTFilEmp // -- Se nao imprimir %ais Filial/Empresa Filtra os Parametros Selecionados
			If ( SRA->RA_FILIAL < cFilDe )	.Or. ( SRA->RA_FILIAL > cFilAte )	.Or.;
			   ( SRA->RA_NOME < cNomeDe )	.Or. ( SRA->RA_NOME > cNomeAte )	.Or.;
				( SRA->RA_MAT < cMatDe )	.Or. ( SRA->RA_MAT > cMatAte )		.Or.;
				(SRA->RA_CC < cCcDe) 		.Or. (SRA->RA_CC > cCcAte)			.Or.;
				(SRA->RA_CODFUNC < cFuncDe).Or. (SRA->RA_CODFUNC > cFuncAte)
				dbSkip()
				Loop			
			EndIf
	    EndIF
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa Situacao do Funcionario na Folha						 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
			dbSkip()
			Loop
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Consiste Filtro da setprint						             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If ! Empty(cFilter) .And. ! &(cFilter)
			dbSkip()
			Loop
		EndIf
   Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		dbSkip()
		Loop
	EndIf
	nSalario   := 0
	nSalMes	  := 0
	nSalDia	  := 0
	nSalHora   := 0

	If nBase = 1		                                        // 1 composto
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula Salario Incorporado Mes , Dia , Hora do Funcionario  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)
	Else
		fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,"A")      // 2 Base
		If nQualSal == 1		// 1-Mes
			nSalMes := nSalario			
		Else						// 2-Hora
			nSalHora := Round(nSalario / SRA->RA_HRSMES,MsDecimais(1))
		EndIf			
	Endif
	
	dbSelectArea( "SRA" )
   RecLock("TRA",.T.)
  	Replace FILIAL    With SRA->RA_FILIAL
	Replace MAT       With SRA->RA_MAT  
   Replace CC        With SRA->RA_CC 
   Replace CODFUNC   With SRA->RA_CODFUNC
   Replace ADMISSA   With SRA->RA_ADMISSA
   Replace NOME      With SRA->RA_NOME
   Replace CLVL      With SRA->RA_X_SEGME
	If nQualSal == 1
		Replace SALMES    With nSalMes         
	Else
		Replace SALHORA   With nSalHora                                                                     
	Endif	
	MsUnLock()
	
 	If nOrdem <> 7
		If cFANT == replicate("!", FWGETTAMFILIAL)
			cFANT := SRA->RA_FILIAL
			cCANT := substr(SRA->RA_CC+space(20),1,20)
		EndIf
	Else
		If cFANT == replicate("!", FWGETTAMFILIAL)
			cFANT := SRA->RA_FILIAL
			cCANT := substr(SRA->RA_X_SEGME+space(20),1,20)
		EndIf
	Endif
	
	TEMPRESA  += If( nQualSal == 1 , nSalMes , nSalHora )
	TEMPRESAF ++
	
    If nOrdem <> 7
		If SRA->RA_FILIAL = cFANT
			TFILIAL	+= If( nQualSal == 1 , nSalMes , nSalHora )
			TFILIALF ++
		Else
			AADD(aTFIL ,{cFANT ,TFILIAL})
			AADD(aTFILF,{cFANT ,TFILIALF})
			TFILIAL	:= If( nQualSal == 1 , nSalMes , nSalHora )
			TFILIALF := 1
		EndIf
	Else 
		If SRA->RA_FILIAL = cFANT
			TFILIAL	+= If( nQualSal == 1 , nSalMes , nSalHora )
			TFILIALF ++
		Else
			AADD(aTFIL ,{cFANT ,TFILIAL})
			AADD(aTFILF,{cFANT ,TFILIALF})
			TFILIAL	:= If( nQualSal == 1 , nSalMes , nSalHora )
			TFILIALF := 1
		EndIf	
	Endif 
	
	If nOrdem <> 7			
		If SRA->RA_FILIAL + substr(SRA->RA_CC+space(20),1,20) = cFANT + cCANT
			TCCTO  += If( nQualSal == 1 , nSalMes , nSalHora )
			TCCTOF ++
		Else 
			AADD(aTCC ,{cFANT+cCANT,TCCTO })
			AADD(aTCCF,{cFANT+cCANT,TCCTOF })
			TCCTO  := If( nQualSal == 1 , nSalMes , nSalHora )
			TCCTOF := 1
		EndIf
	Else
		If SRA->RA_FILIAL + substr(SRA->RA_X_SEGME+space(20),1,20) = cFANT + cCANT
			TCCTO  += If( nQualSal == 1 , nSalMes , nSalHora )
			TCCTOF ++
		Else 
			AADD(aTCC ,{cFANT+cCANT,TCCTO })
			AADD(aTCCF,{cFANT+cCANT,TCCTOF })
			TCCTO  := If( nQualSal == 1 , nSalMes , nSalHora )
			TCCTOF := 1
		EndIf
	Endif
	If nOrdem <> 7	
		cCANT := substr(SRA->RA_CC+space(20),1,20)
	Else
		cCANT := substr(SRA->RA_X_SEGME+space(20),1,20)
	Endif
	cFANT := SRA->RA_FILIAL
	dbSelectArea( "SRA" )
	dbSkip()
EndDo

If Eof() .And. TFILIAL > 0
	AADD(aTFIL , {cFANT ,TFILIAL})
	AADD(aTFILF, {cFANT ,TFILIALF})
	AADD(aTCC  , {cFANT + cCANT ,TCCTO})
	AADD(aTCCF , {cFANT + cCANT ,TCCTOF})
EndIf

If lQuery
	dbSelectArea("SRA")
	dbCloseArea()
Endif	
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ EMISSAO DO RELATORIO   								 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If TFILIALF > 0
	dbSelectArea("TRA")
	dbGotop()

	If nOrdem == 1
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->MAT"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	ElseIf nOrdem == 2
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->NOME"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe + cNomeDe,.T.)
   ElseIf nOrdem == 3
		cIndCond := "TRA->FILIAL + TRA->CC + TRA->CODFUNC"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cCcDe,.T.)
	ElseIf nOrdem == 4
		cIndCond := "TRA->FILIAL + TRA->NOME"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cNomeDe,.T.)
	ElseIf nOrdem == 5
		cIndCond := "TRA->FILIAL + TRA->MAT"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cMatDe,.T.)
	ElseIf nOrdem == 6
		cIndCond := "TRA->FILIAL +TRA->CODFUNC"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + cFuncDe,.T.)			
	ElseIf nOrdem == 7
		cIndCond := "TRA->FILIAL + TRA->CLVL"
		cArqNtx := CriaTrab(Nil,.F.)
		IndRegua("TRA",cArqNtx,cIndCond)
		dbSeek(cFilDe + "         ",.T.)			
   EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Carrega Regua Processamento											  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SetRegua(RecCount())

	cFANT := TRA->FILIAL
	If nOrdem <> 7
		cCANT := substr(TRA->CC+space(20),1,20)
	Else
		cCANT := substr(TRA->CLVL+space(20),1,20)	
	Endif
		
	While !Eof()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Movimenta Regua Processamento										  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		IncRegua()
	
		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		EndIf
		If ( TRA->FILIAL < cFilDe ) .Or. ( TRA->FILIAL > cFilAte ) .Or.;
		   ( TRA->NOME < cNomeDe )	.Or. ( TRA->NOME > cNomeAte )	 .Or.;
			( TRA->MAT < cMatDe ) .Or. ( TRA->MAT > cMatAte )	.Or.;
			(TRA->CC < cCcDe) 	.Or. (TRA->CC > cCcAte)	 .Or.;
			(TRA->CODFUNC < cFuncDe).Or. (TRA->CODFUNC > cFuncAte)
			dbSkip()
			Loop			
		EndIf
		// Apenas por ordem de Centro de Custo
		If nOrdem==1 .Or. nOrdem ==2 .Or. nOrdem ==3
			IF substr(TRA->CC+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
				If !Empty(TOTCC) .or. !Empty(TOTCCF	)	
					IMPR(Repli("-",132),"C")
					For x=1 To Len(aTCC)
						If aTCC[X,1] = cFANT + cCANT 
							DET := STR0017+Substr(cCANT+Space(20),1,20)+"-"+Subs(DescCc(cCAnt,cFAnt),1,20)+" "+STR0018+Transform(aTCCF[X,2],"@E 999,999")+" "+Transform(aTCC[X,2],cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
							IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
								For w=1 To Len(aTFIL)
									If aTFIL[W,1] = cFANT
										DET +=Space(10)+Transform((aTCC[X,2]/aTFIL[W,2])*100,"@E 999.999")
										DET +=Space(02)+Transform((aTCC[X,2]/TEMPRESA)*100,"@E 999.999")
										Exit
									EndIf
								Next w
						    EndIF
						EndIf
					Next x
					IMPR(DET,"C")
					IMPR(Repli("-",132),"C")
					If lSalta .And. (TRA->FILIAL == cFANT)
						IMPR(" ","P")
					EndIf
				EndIf
				dbSelectArea( "TRA" )
			EndIf
		EndIf
		// Apenas segmento
		If nOrdem = 7
			IF substr(TRA->CLVL+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
				If !Empty(TOTCC) .or. !Empty(TOTCCF	)	
					IMPR(Repli("-",132),"C")
					For x=1 To Len(aTCC)
						If aTCC[X,1] = cFANT + cCANT 
							DET := "Segmento "+Substr(cCANT+Space(20),1,20)+"-"+Subs(FBuscaCTH(cCAnt,cFAnt),1,20)+" "+STR0018+Transform(aTCCF[X,2],"@E 999,999")+" "+Transform(aTCC[X,2],cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
							IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
								For w=1 To Len(aTFIL)
									If aTFIL[W,1] = cFANT
										DET +=Space(10)+Transform((aTCC[X,2]/aTFIL[W,2])*100,"@E 999.999")
										DET +=Space(02)+Transform((aTCC[X,2]/TEMPRESA)*100,"@E 999.999")
										Exit
									EndIf
								Next w
						    EndIF
						EndIf
					Next x
					IMPR(DET,"C")
					IMPR(Repli("-",132),"C")
					If lSalta .And. (TRA->FILIAL == cFANT)
						IMPR(" ","P")
					EndIf
				EndIf
				dbSelectArea( "TRA" )
			EndIf
		EndIf			
		If Eof() .Or. TRA->FILIAL # cFANT
		   If !Empty(TOTCCF) .And. !Empty(TOTFIL) 		
				DET := ""
				IMPR(Repli("-",132),"C")
				IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
					For x=1 To Len(aTFIL)
						IF aTFIL[X,1] = cFANT
							cNomeFilial:=Space(15)
							If fInfo(@aInfo,cFANT)
								cNomeFilial:=aInfo[1]
							Endif
							DET := STR0019+cFANT+" - " + cNomeFilial+"  "+STR0020+Transform(TOTFILF,"@E 999,999")+"        "+Transform(TOTFIL,cPict1)	//"TOTAL DA FILIAL "###"                        QTDE......:"
							For w=1 To Len(aTFIL)
								If aTFIL[W,1] = cFANT
									DET +=Space(19)+Transform((aTFIL[W,2] / TEMPRESA)*100,"@E 999.999")
									Exit
								Endif
							Next w
						Endif
					Next x
				EndIF
				IMPR(DET,"C")
				IMPR(Repli("-",132),"C")
				IMPR(" ","P")
			EndIf
			dbSelectArea( "TRA" )
		EndIf

		If nTipoRel == 1				// Analitico
			DescMO := "   "   
			FBuscaSRJ(TRA->FILIAL,TRA->CODFUNC,@DescMO)
			DET :=""	
			DET := TRA->FILIAL+"  "+TRA->MAT + " "
			DET += SubStr(TRA->NOME,1,30)+" "+PadR(DTOC(TRA->ADMISSA),10)
			DET += " "+TRA->CODFUNC+"-"+DESCFUN(TRA->CODFUNC,TRA->FILIAL)+" "
			DET += DescMO +" "+Transform( If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA ) ,cPict2)+"  "
			For x:=1 To Len(aTCC)
				If nOrdem <> 7
					If aTCC[X,1] = TRA->FILIAL+substr(TRA->CC+space(20),1,20)
						DET += Transform( (If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  ) / aTCC[X,2] )*100,"@E 999.999")+" "
						TOTCC := aTCC[X,2] // ADRIANO
						TOTCCF:= aTCCF[X,2]
					EndIf
				Else
					If aTCC[X,1] = TRA->FILIAL+substr(TRA->CLVL+space(20),1,20)
						DET += Transform( (If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  ) / aTCC[X,2] )*100,"@E 999.999")+" "
						TOTCC := aTCC[X,2] // ADRIANO
						TOTCCF:= aTCCF[X,2]
					EndIf				
				Endif
			Next x
			IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
				For x=1 To Len(aTFIL)
					If aTFIL[X,1] = TRA->FILIAL
						DET += Transform( (If( nQualSal==1 , TRA->SALMES, TRA->SALHORA  ) / aTFIL[x,2] )*100,"@E 999.999")+"  "
						DET += Transform( (If( nQualSal==1 , TRA->SALMES, TRA->SALHORA  ) / TEMPRESA )* 100,"@E 999.999")
					EndIf
				Next x
			EndIF
			TPAGINA += If( nQualSal == 1 , TRA->SALMES, TRA->SALHORA  )
			IMPR(DET,"C")
		EndIf	
		
		cFANT := TRA->FILIAL
		If nOrdem <> 7
			cCANT := substr(TRA->CC+space(20),1,20) 
			
			For x:=1 To Len(aTCC)
				If aTCC[X,1] = TRA->FILIAL+substr(TRA->CC+space(20),1,20)
					TOTCC := aTCC[X,2]
					TOTCCF:= aTCCF[X,2]
				EndIf
			Next x
		Else
			cCANT := substr(TRA->CLVL+space(20),1,20) 
			
			For x:=1 To Len(aTCC)
				If aTCC[X,1] = TRA->FILIAL+substr(TRA->CC+space(20),1,20)
					TOTCC := aTCC[X,2]
					TOTCCF:= aTCCF[X,2]
				EndIf
			Next x
		Endif
		
		For x=1 To Len(aTFIL)
			If aTFIL[X,1] = TRA->FILIAL
				TOTFIL := aTFIL[X,2]
				TOTFILF:= aTFILF[X,2]
			EndIf
		Next x
				
		dbSelectArea( "TRA" )
		dbSkip()
	EndDo

	If nOrdem ==1 .Or. nOrdem==2 .Or. nOrdem==3
		If !Empty(TOTCC) .And. !Empty(TOTCCF) .And. !Empty(TOTFIL) .And. !Empty(TOTFILF) .Or. ( Eof()  .And. !Empty(TOTCC) )
			IMPR(Repli("-",132),"C")
			DET := STR0017 + cCANT + ;					//"TOTAL DO CENTRO DE CUSTO "
					"-" + DescCc(cCAnt,cFAnt)+" "+STR0018+Transform(TOTCCF,"@E 999,999")+;		//" QTDE.:"
					Space(01)+Transform(TOTCC,cPict1)
			IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
  				DET +=Space(10)+Transform((TOTCC/TOTFIL)*100,"@E 999.999")
				DET +=Space(02)+Transform((TOTCC/TEMPRESA)*100,"@E 999.999")  
		    EndIF
			IMPR(DET,"C")
		EndIf
	EndIf
	// Apenas segmento
	If nOrdem = 7
		IF substr(TRA->CLVL+space(20),1,20) # cCANT .Or. TRA->FILIAL # cFANT
			If !Empty(TOTCC) .or. !Empty(TOTCCF	)	
				IMPR(Repli("-",132),"C")
				For x=1 To Len(aTCC)
					If aTCC[X,1] = cFANT + cCANT 
						DET := "Segmento "+Substr(cCANT+Space(20),1,20)+"-"+Subs(FBuscaCTH(cCAnt,cFAnt),1,20)+" "+STR0018+Transform(aTCCF[X,2],"@E 999,999")+" "+Transform(aTCC[X,2],cPict1)	//"TOTAL CENTRO DE CUSTO  "###"  QTDE......:"
						IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
							For w=1 To Len(aTFIL)
								If aTFIL[W,1] = cFANT
									DET +=Space(10)+Transform((aTCC[X,2]/aTFIL[W,2])*100,"@E 999.999")
									DET +=Space(02)+Transform((aTCC[X,2]/TEMPRESA)*100,"@E 999.999")
									Exit
								EndIf
							Next w
					    EndIF
					EndIf
				Next x
				IMPR(DET,"C")
				IMPR(Repli("-",132),"C")
				If lSalta .And. (TRA->FILIAL == cFANT)
					IMPR(" ","P")
				EndIf
			EndIf
			dbSelectArea( "TRA" )
		EndIf
	EndIf
	IMPR(Repli("-",132),"C")			
	cNomeFilial:=Space(15)
	If fInfo(@aInfo,cFANT)
		cNomeFilial:=ainfo[1]
	EndIf
	IF lImpTFilEmp // Se Imprimir %ais Filial/Empresa
		DET := STR0019+ cFANT + " - " + cNomeFilial+Space(29)+STR0020+Transform(TOTFILF,"@E 999,999")+" "+Transform(TOTFIL,cPict1)	//"TOTAL DA FILIAL "###"QTDE.:"
		DET +=Space(19)+Transform((TOTFIL / TEMPRESA)*100,"@E 999.999")
		IMPR(DET,"C")
		IMPR(Repli("-",132),"C")
		IMPR(Repli("-",132),"C")
		DET := STR0025+" - " + Left(SM0->M0_NOMECOM,39) +Space(5)+ STR0026+Transform(TEMPRESAF , "@E 999,999")+" "+;	//"TOTAL DA EMPRESA  "###"QTDE.:"
		Transform(TEMPRESA ,cPict1)
		IMPR(DET,"C")
		IMPR(Repli("-",132),"C")
    EndIF
    IMPR(" ","F")	
	aTCC	:={}
	aTFIL	:={}
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio													  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SRA")
dbSetOrder(1)
Set Filter To

dbSelectArea("TRA")
dbCloseArea()
fErase( cArqNtx + OrdBagExt() )

If TFILIALF > 0
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
Endif	

*--------------------------------------------------*
Static Function fBuscaSRJ( cFil , cCodigo , DescMO )
*--------------------------------------------------*
Local cAlias := Alias()

dbSelectArea( "SRJ" )            
If ( cFil # Nil .And. cFilial == Space(FWGETTAMFILIAL)) .Or. cFil == Nil
	cFil := cFilial
Endif
If dbSeek( cFil + cCodigo )
	If Left(RJ_MAOBRA ,1 ) == "D"
		DescMO := STR0027		//"DIR"
	Elseif Left(RJ_MAOBRA ,1 ) == "I"
		DescMO := STR0028		//"IND"
	Else
		DescMO := "   "
	Endif
Else
	DescMO := "***"
Endif
	
dbSelectArea(cAlias)
Return(.T.)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER340  ³ Autor ³ R.H. - Luciana Silveira   ³ Data ³ 07/04/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Função Busca CDC                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FBuscaCDC(cCodCC)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FBuscaCDC(cCodCC)

Local cDescCc	:= ""
Local cCodFil	:= Left(cCodcc,2)
cCodCC			:= Substr(cCodcc,3)

dbSelectArea("CTT")
dbSetOrder(1)

IF CTT->(dbSeek(xFilial("CTT",cCodFil) + cCodCC))
    cDescCc := OemToAnsi(STR0017)+allTrim(cCodCC)+" - "+CTT->CTT_DESC01
EndIf  

Return(cDescCc)              

// Busca descrição Classe de valor
Static Function FBuscaCTH(cCodCC)

Local cDescCc	:= ""
//cCodCC			:= Substr(cCodcc,3)

dbSelectArea("CTH")
dbSetOrder(1)

IF CTH->(dbSeek(xFilial("CTH") + cCodCC))
    cDescCc := "Total do Segmento "+allTrim(cCodCC)+" - "+CTH->CTH_DESC01
EndIf  

Return(cDescCc)             


Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")//Perguntas (filtros) no relatorio
dbSetOrder(1)    

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Filial De              ?","","","mv_ch1","C",02,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Ate             ?","","","mv_ch2","C",02,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})      
aAdd(aRegs,{cPerg,"03","Centro de Custo De     ?","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"04","Centro de Custo Ate    ?","","","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"05","Matricula De           ?","","","mv_ch5","C",06,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"06","Matricula Ate          ?","","","mv_ch6","C",06,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""}) 
aAdd(aRegs,{cPerg,"07","Nome De                ?","","","mv_ch7","C",30,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Nome Ate               ?","","","mv_ch8","C",30,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Funcao De              ?","","","mv_ch9","C",05,0,0,"G","        ","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})
aAdd(aRegs,{cPerg,"10","Funcao Ate             ?","","","mv_ch10","C",05,0,0,"G","naovazio","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","SRJ",""})                                                                                          
aAdd(aRegs,{cPerg,"11","Situacao Funcionario   ?","","","mv_ch11","C",05,0,1,"C","fSituacao","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"12","Categorias             ?","","","mv_ch12","C",15,0,1,"C","fCategoria","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"13","C.C. em Outra Pag.     ?","","","mv_ch13","N",01,0,1,"C","naovazio","mv_par13","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"14","Sobre Qual Salario     ?","","","mv_ch14","N",01,0,1,"C","naovazio","mv_par14","Mes","Mes","Mes","","","Hora","Hora","Hora","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"15","Sobre Salario          ?","","","mv_ch15","N",01,0,1,"C","naovazio","mv_par15","Composto","Composto","Composto","","","Base","Base","Base","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"16","Imprimir               ?","","","mv_ch16","N",01,0,1,"C","naovazio","mv_par16","Analitico","Analitico","Analitico","","","Sintetico","Sintetico","Sintetico","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"17","Impr.Totais Fil/Emp    ?","","","mv_ch17","N",01,0,1,"C","naovazio","mv_par17","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])                      
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return