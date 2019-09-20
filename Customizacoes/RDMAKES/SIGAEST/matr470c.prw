#INCLUDE "MATR470.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR470  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 04.08.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex fisico - financeiro                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user Function  MATR470C()
Local oReport
Local nTamLOC      := TamSX3("B2_LOCAL")[1]
PRIVATE cALL_LOC   := Replicate('*', nTamLOC)
PRIVATE cALL_Empty := Replicate(' ', nTamLOC)
PRIVATE cALL_ZZ    := Replicate('Z', nTamLOC)

If TRepInUse()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR470R3()
EndIf

Return
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³Nereu Humberto Junior  ³ Data ³04.08.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatorio                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oCell
Local aOrdem := {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por empresa              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

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
oReport:= TReport():New("MATR470",STR0001,"MTR470", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003+" "+STR0004) //"Registro de Controle de Producao e Estoque"##"Este programa emitira' o Registro de Controle de Producao"##"e Estoque dos produtos Selecionados,Ordenados por Dia."##"Este relatorio nao lista a Mao de Obra. NOTA: Os Valores Totais serao impressos conforme o Modelo Legal."
oReport:SetTotalInLine(.F.)
oReport:SetLandscape()    
oReport:HideParamPage() 
oReport:HideHeader() 
oReport:HideFooter()
oReport:SetUseGC(.F.)   //DESABILITA OPCAO GESTAO CORPORATIVA 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                    ³
//³ mv_par01        // Do produto                                           ³
//³ mv_par02        // Ate o produto                                        ³
//³ mv_par03        // Do tipo                                              ³
//³ mv_par04        // Ate o tipo                                           ³
//³ mv_par05        // Da data                                              ³
//³ mv_par06        // Ate a data                                           ³
//³ mv_par07        // Lista produtos s/movim                               ³
//³ mv_par08        // Do Armazem                                           ³
//³ mv_par09        // Ate o Armazem                                        ³
//³ mv_par10        // (D)ocumento/(S)equencia                              ³
//³ mv_par11        // Moeda                                                ³
//³ mv_par12        // Pagina Inicial                                       ³
//³ mv_par13        // Qtd de Paginas                                       ³
//³ mv_par14        // Nr do Livro                                          ³
//³ mv_par15        // Livro / Livro+Termos / Termos                        ³
//³ mv_par16        // Totaliza por Dia   Sim / Nao                         ³
//³ mv_par17        // "Prod. sem mov. c/ Saldo ?" Lista / Nao Lista        ³
//³ mv_par18        // Outras moedas                                        ³
//³ mv_par19        // Quebrar Paginas Por Feixe/Por Mes/Feixe              ³
//³ mv_par20        // Despesa nas NFs sem IPI    Nao Soma / Soma           ³
//³ mv_par21        // Reiniciar paginas                                    ³
//³ mv_par22        // Seleciona Filiais ? (Sim/Nao)   				    	  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("MTR470",.F.)

Aadd( aOrdem, STR0005 ) //" Por Codigo "
Aadd( aOrdem, STR0006 ) //" Por Tipo   "
Aadd( aOrdem, STR0007 ) //" Por Descricao "
Aadd( aOrdem, STR0008 ) //" Por Grupo     "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Sessao 1                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection1 := TRSection():New(oReport,STR0037,{"SB1","SB2"},aOrdem) //"Produtos"
oSection1 :SetNoFilter("SB2")
oSection1 :SetTotalInLine(.F.)
oSection1 :SetReadOnly()  // Desabilita a edicao das celulas permitindo filtro

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint ³Autor  ³Nereu Humberto Junior ³ Data ³04/08/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatorio                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local nOrdem    := oReport:Section(1):GetOrder() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MatFilCalc - Funcao utilizada para selecao de filiais        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFilsCalc := MatFilCalc( mv_par22 == 1,,,mv_par23==1 .And. mv_par22==1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressao do relatorio - Release 4                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty(aFilsCalc)   
	If oReport:nDevice != 5
		MT470Imp(,,,,.T.,nOrdem,oReport,aFilsCalc)  
	Else
		Aviso(STR0030,STR0046,{STR0033})
	EndIf
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR470R3 ³ Autor ³ Gilson do Nascimento  ³ Data ³ 11.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Kardex fisico - financeiro (Antigo)                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Rodrigo Sart³27/03/98³14593A³Acerto na quebra de linhas/paginas        ³±±
±±³Rodrigo     ³24/06/98³XXXXXX³Acerto no tamanho do documento para 12    ³±±
±±³            ³        ³      ³posicoes                                  ³±±
±±³Rodrigo     ³10/09/98³17543A³Impressao das colunas de especie de Doc.  ³±±
±±³Rodrigo Sart³05/11/98³XXXXXX³ Acerto p/ Bug Ano 2000                   ³±±
±±³Rodrigo     ³02/03/99³xxxxxx³Correcao na impressao do custo do SD3     ³±±
±±³CesarValadao³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³Andreia     ³18/06/99³Proth.³Impressao Termo Abert. e Encerr.          ³±±
±±³CesarValadao³15/07/99³22274A³Correcao Impressao dos Ultimos Registros  ³±±
±±³Rodrigo Sart³29/07/99³xxxxxx³Correcao impressao prod. sem movimento    ³±±
±±³Patricia Sal³17/01/00³xxxxxx³Inclusao do mv_par16 para imprimir ou nao ³±±
±±³            ³        ³      ³produtos sem movimentacao com saldo.      ³±±
±±³Marcello    ³25/08/00³oooooo³Impressao da relacao em outras moedas     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcos Hirak³11/03/04³XXXXXX³Imprimir B1_CODITE quando for gestao de   ³±±
±±³            ³        ³      ³Concessionarias ( MV_VEICULO = "S").      ³±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Descri‡ao ³ PLANO DE MELHORIA CONTINUA        ³Programa :  MATR470.PRX ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ITEM PMC  ³ Responsavel              ³ Data                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      01  ³                          ³                                 ³±±
±±³      02  ³ Flavio Luiz Vicco        ³ 09/02/2006                      ³±±
±±³      03  ³                          ³                                 ³±±
±±³      04  ³                          ³                                 ³±±
±±³      05  ³ Nereu Humberto Junior    ³ 11/05/2006 - BOPS 00000098480   ³±±
±±³      06  ³ Nereu Humberto Junior    ³ 11/05/2006 - BOPS 00000098480   ³±±
±±³      07  ³ Flavio Luiz Vicco        ³ 24/02/2006 - BOPS 00000093979   ³±±
±±³      08  ³                          ³                                 ³±±
±±³      09  ³ Flavio Luiz Vicco        ³ 24/02/2006 - BOPS 00000093979   ³±±
±±³      10  ³ Flavio Luiz Vicco        ³ 09/02/2006                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MATR470R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local WnRel
Local Tamanho  := "G"
Local titulo   := STR0001	//"Registro de Controle de Producao e Estoque"
Local cDesc1   := STR0002	//"Este programa emitira' o Registro de Controle de Producao"
Local cDesc2   := STR0003	//"e Estoque dos produtos Selecionados,Ordenados por Dia."
Local cDesc3   := STR0004	//"Este relatorio nao lista a Mao de Obra. NOTA: Os Valores Totais serao impressos conforme o Modelo Legal."

Local aOrd     := {STR0005,STR0006,STR0007,STR0008}			//" Por Codigo         "###" Por Tipo           "###" Por Descricao     "###" Por Grupo        "
Local nomeprog := "MATR470"
Local cString  := "SB1"
Local nTipo    := 0
Local lEnd	   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizada na selecao de filiais                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aFilsCalc:={}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lVEIC  := Upper(GetMV("MV_VEICULO"))=="S"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas no relatorio                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn  := { STR0009, 1,STR0010, 2, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE aLinha   := { }
PRIVATE nLastKey := 0
PRIVATE nPaginas := 0
PRIVATE cPerg    := "MTR470"
PRIVATE bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
PRIVATE aDriver  := ReadDriver()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por empresa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                              ³
//³ mv_par01        // Do produto                                     ³
//³ mv_par02        // Ate o produto                                  ³
//³ mv_par03        // Do tipo                                        ³
//³ mv_par04        // Ate o tipo                                     ³
//³ mv_par05        // Da data                                        ³
//³ mv_par06        // Ate a data                                     ³
//³ mv_par07        // Lista produtos s/movim                         ³
//³ mv_par08        // Do Armazem                                     ³
//³ mv_par09        // Ate o Armazem                                  ³
//³ mv_par10        // (D)ocumento/(S)equencia                        ³
//³ mv_par11        // Moeda                                          ³
//³ mv_par12        // Pagina Inicial                                 ³
//³ mv_par13        // Qtd de Paginas                                 ³
//³ mv_par14        // Nr do Livro                                    ³
//³ mv_par15        // Livro / Livro+Termos / Termos                  ³
//³ mv_par16        // Totaliza por Dia   Sim / Nao                   ³
//³ mv_par17        // "Prod. sem mov. c/ Saldo ?" Lista / Nao Lista  ³
//³ mv_par18        // Outras moedas                                  ³
//³ mv_par19        // Quebrar Paginas Por Feixe/Por Mes/Feixe        ³
//³ mv_par20        // Despesa nas NFs sem IPI    Nao Soma / Soma     ³
//³ mv_par21        // Reiniciar paginas                              ³
//³ mv_par22        // Seleciona Filiais ? (Sim/Nao)   				  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

dbSelectArea("SB1")
dbSetOrder(1)

dbSelectArea("SB2")
dbSetOrder(1)

dbSelectArea("SD1")
dbSetOrder(1)

dbSelectArea("SD2")
dbSetOrder(1)

dbSelectArea("SD3")
dbSetOrder(1)

dbSelectArea("SF4")
dbSetOrder(1)

dbSelectArea("SF1")
dbSetOrder(1)

dbSelectArea("SF2")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel :="MATR470"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ MatFilCalc - Funcao utilizada para selecao de filiais        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFilsCalc:= MatFilCalc( mv_par22==1,,,mv_par23==1 .And. mv_par22==1)

If Empty(aFilsCalc)
	dbClearFilter()
	Return
EndIf

SetDefault(aReturn,cString)
If nLastKey = 27
	dbClearFilter()
	Return
EndIf

RptStatus( { |lEnd| MT470Imp( @lEnd, wnRel, cString, Titulo, .F., Nil, Nil, aFilsCalc ) }, titulo )  // Chamada do Relatorio

Return .T.
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MT470Imp  ³ Autor ³ Gilson do Nascimento ³ Data ³ 16.09.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MT470Imp( lEnd, WnRel, cString, Titulo, lGraph, nOrdem, oReport, aFilsCalc )

Local cProdAnt  := ''
Local cLocalAnt := ''
Local cProdVeic := ''
Local cDesc     := ''
Local cTipo     := ''
Local cGrupo    := ''
Local cUm       := ''
Local cPosIPI   := ''
Local cDia      := ''
Local cPer      := ''
Local cProd     := ''
Local cRetPE    := ''
Local cTRBSeek  := ''
Local cNewLocal := ''
Local cAliasSD1 := ''
Local cAliasSD2 := ''
Local cAliasSD3 := ''
Local cChave    := ''
Local cNoCfop   := ''

Local nRec1     := 0
Local nSavRec   := 0
Local nD1Qt     := 0
Local nD2Qt     := 0
Local nD3Qt     := 0
Local i         := 0
Local nImpInc   := 0
Local nSalEst   := 0
Local nPos      := 0
Local nY	    := 0
Local nInd1     := 0
Local nOrd      := 0
Local nTamReg   := 0
Local nPeriodo  := 0
Local nX        := 0
Local nInicial  := 0

Local aImpostos := {}
Local aSalEst   := {}
Local aCampos   := {}
Local aSalAlmo  := {}
Local aInfocabec:= {}
Local aPeriodos := {}
Local aSalProc  := {}
Local aSalAtu   := {0,0,0,0,0,0,0}

Local cPicD1Qt  := PesqPictQt("D1_QUANT" ,18)
Local cPicB9SL  := PesqPictQt("B9_QINI" ,18)
Local lEntrSai  := ExistBlock("MTR470ES")
Local lA470OBS  := ExistBlock("MA470OBS")
Local cTRBSD1   := CriaTrab(,.F.)
Local cTRBSD2   := Subs(cTrbSD1,1,7)+"A"
Local cTRBSD3   := Subs(cTrbSD1,1,7)+"B"
Local cLocProc	:= SuperGetMv("MV_LOCPROC")
Local nTamSX1   := Len(SX1->X1_GRUPO)
Local aStruSD1  := SD1->(dbStruct())
Local aStruSF1  := SF1->(dbStruct())
Local aStruSD2  := SD2->(dbStruct())
Local aStruSF2  := SF2->(dbStruct())
Local aStruSF4  := SF4->(dbStruct())
Local aStruSD3  := SD3->(dbStruct())

Local lInverteMov := .F.
Local lT	      := .F.
Local lProcesso   := .F.
Local lFirst1     := .T.
Local lPriApropri := .T.
Local lMudaIni    := .T.
Local lAgregIPI   := .F.

Local dDataIni,dDataFim
Local dCntData,uObsNew

// Indica se esta listando relatorio TAMBEM do almox. de processo
Local lLocProc :=  cLocProc >= mv_par08 .And. cLocProc <= mv_par09

// Indica se armazem e' armazem de terceiros
Local cLocTerc := SuperGetMv("MV_ALMTERC",.F.,"")

// Indica quais as TES serao utilizadas para o tipo de documento 3
Local cTipoDoc := SuperGetMv("MV_TIPODOC",.F.,"")

// Indica se existe integracao com Distribuicao e Logistica
Local lIntDL   := SuperGetMv("MV_INTDL",.F.,"N") == "S"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cPerg    := "MTR470"
Local cArq1    := ''
Local cInd1    := ''
Local cAliasSB2:= ''
Local cAliasTOP:= ''
Local cTempo   := ''
Local cPicD1Qt2:= ''
Local lfirst   := .T.
Local cCarPic

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Tratamento da impressao por Filiais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nForFilial := 0
Local cFilBack   := cFilAnt
Local lImp  	 := GetNewPar("MV_IMPCABE",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Filtro de Usuario                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cFilUser   := IIf(lGraph,oReport:Section(1):GetAdvplExp(),aReturn[7])
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por empresa              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo PRIVATE para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE lVEIC    := Upper(GeTMV("MV_VEICULO"))=="S"
PRIVATE cCODITE  := ''
PRIVATE bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
PRIVATE aDriver  := ReadDriver()

DEFAULT lGraph   := .F.

for cCarPic = 1 to len(cPicD1Qt)
	if substr (cPicD1Qt,cCarPic,1) == '9' .AND. lfirst
		lfirst := .F.
		cPicD1Qt2 += '9'
	EndIf
 	cPicD1Qt2 += substr (cPicD1Qt,cCarPic,1)  
Next cCarPic
cPicD1Qt := cPicD1Qt2

cPicD1Qt2 := '' 
lFirst	  := .T.
for cCarPic = 1 to len(cPicB9SL)
	if substr (cPicB9SL,cCarPic,1) == '9' .AND. lfirst
		lfirst := .F.
		cPicD1Qt2 += '9'
	EndIf
 	cPicD1Qt2 += substr (cPicB9SL,cCarPic,1)  
Next cCarPic
cPicB9SL := cPicD1Qt2

mv_par08 := Upper(mv_par08)
mv_par09 := Upper(mv_par09)
mv_par08 := If(Trim(mv_par08)=="",cALL_Empty,mv_par08)

// Desconsiderar CFOP's informadas
If mv_par24 <> ""
	cNoCfop := M470NoCFOP(Alltrim(mv_par24))
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se utiliza custo unificado por empresa              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lCusUnif := lCusUnif .And. AllTrim(mv_par08) == cALL_LOC
mv_par09 := If(lCusUnif,cALL_LOC,mv_par09)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Nao aglutinar por CNPJ+IE quando a pergunta de selecao de    ³
//| filiais estiver desabilitada.                                |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par22==2
	mv_par23 := 2
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lay-Out de Impressao do Relatorio                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aL    :=Array(19)
PRIVATE aDados:=Array(14)
PRIVATE cCampImp

aL[01]:=		  "+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+"
If lImp
	aL[02]:=STR0038 //"|                                                  REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE  - P3                                               |     (*)  CODIGO DE ENTRADAS E SAIDAS              |"
	Else
	aL[02]:=STR0011	//"|                                                  REGISTRO DE CONTROLE DA PRODUCAO E DO ESTOQUE                                                     |          CODIGO DE ENTRADAS E SAIDAS              |"
EndIf
aL[03]:=		  "|                                                                                                                                                    |---------------------------------------------------|"
aL[04]:=STR0034	//"| FIRMA: #############################################     FILIAL: ###############                                                                   |                                                   |"
aL[05]:=STR0013	//"|                                                                                                                                                    | 1 - NO PROPRIO ESTABELECIMENTO                    |"
aL[06]:=STR0014	//"| INSCR.ESTADUAL: ################           C.G.C.(M.F.): ############                                                                              |                                                   |"
aL[07]:=STR0015	//"|                                                                                                                                                    | 2 - EM OUTRO ESTABELECIMENTO                      |"
aL[08]:=STR0016	//"| FOLHA: ####              MES OU PERIODO/ANO: ########                                                                                              |                                                   |"
aL[09]:=STR0017	//"|                                                                                                                                                    | 3 - DIVERSAS                                      |"
If lCusUnif
	aL[10]:=STR0039	//"| PRODUTO: ###############################################                      UM: ## CLASSIFICACAO FISCAL: ###############                         |                                                   |"
Else
	aL[10]:=STR0018	//"| PRODUTO: ###############################################                      UM: ## CLASSIFICACAO FISCAL: ############### ALMOXARIFADO: ##        |                                                   |"
EndIf	
aL[11]:=		  "|                                                                                                                                                    |                                                   |"
aL[12]:=		  "|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
aL[13]:=STR0019	//"|               DOCUMENTO               |            LANCAMENTO             |                         ENTRADAS E SAIDAS                              |                      |                            |"
aL[14]:=		  "|---------------------------------------|-----------------------------------|------------------------------------------------------------------------|                      |                            |"
aL[15]:=STR0020	//"|ESPECIE|SERIE|              |          |     |         CODIFICACAO         |   |   |                      |                    |                    |        ESTOQUE       |         OBSERVACOES        |"
aL[16]:=STR0021	//"|       |SUB- |              |          |     |-----------------------------|E/S|COD|                      |                    |                    |                      |                            |"
If ( cPaisLoc=="BRA" )
	aL[17]:=STR0022//"|       |SERIE|    NUMERO    |   DATA   | DIA |       PRODUTO             |FISCAL|   |(*)|      QUANTIDADE      |       VALOR        |        IPI         |                      |                            |"
	aL[18]:=			  "|=======+=====+==============+==========|=====+======================+======|===+===+======================+====================+====================|======================|============================|"
	aL[19]:=			  "| ##### | ### | ############ |##########|  ## | ###############      | #### |###| # |   ################   | ################## | ################## |   ################   | ########################## |"
Else
	aL[17]:=STR0028//"|       |SERIE|    NUMERO    |   DATA   | DIA |       PRODUTO             |   |(*)|      QUANTIDADE      |       VALOR        |      IMPUESTOS     |                      |                            |"
	aL[18]:=			  "|=======+=====+==============+==========|=====+=============================|===+===+======================+====================+====================|======================|============================|"
	aL[19]:=			  "| ##### | ### | ############ |##########|  ## | ###############        #### |###| # |   ################   | ################## | ################## |   ################   | ########################## |"
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
li       := 80
dDataIni := mv_par05
dDataFim := mv_par06
nPaginas := IIf(mv_par12<=1,2,mv_par12)
nQuebra	 := IIf(mv_par13<=2,500,mv_par13)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa o codigo de caracter Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := 18

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{ "PERIODO"	,"C",06,0 } )
AADD(aCampos,{ "PRODUTO"	,"C",TamSX3("B1_COD")[1],0 } )
AADD(aCampos,{ "ESPECIE"	,"C",05,0 } )
AADD(aCampos,{ "SERIE"		,"C",03,0 } )
AADD(aCampos,{ "NUMERO"		,"C",12,0 } )
AADD(aCampos,{ "EMISSAO"	,"D",08,0 } )
AADD(aCampos,{ "DTDIGIT"	,"D",08,0 } )
AADD(aCampos,{ "DIA"		,"C",02,0 } )
AADD(aCampos,{ "CC"			,"C",TamSX3("B1_CONTA")[1],0 } )
AADD(aCampos,{ "CF"			,"C",04,0 } )
AADD(aCampos,{ "ES"			,"C",03,0 } )
AADD(aCampos,{ "COD"		,"C",01,0 } )
AADD(aCampos,{ "QTDE"		,"N",18,TamSX3("D1_QUANT")[2] } )
AADD(aCampos,{ "VALOR"		,"N",18,2 } )
AADD(aCampos,{ "IPI"		,"N",18,2 } )
AADD(aCampos,{ "ESTOQUE"	,"N",18,TamSX3("D1_QUANT")[2] } )
AADD(aCampos,{ "DESCRICAO"	,"C",30,0 } )
AADD(aCampos,{ "UM"			,"C",02,0 } )
AADD(aCampos,{ "POSIPI"		,"C",10,0 } )
AADD(aCampos,{ "FLAG"		,"C",01,0 } )
AADD(aCampos,{ "TIPO"		,"C",02,0 } )
AADD(aCampos,{ "GRUPO"		,"C",04,0 } )
AADD(aCampos,{ "LOCAL"		,"C",TamSX3("B2_LOCAL")[1],0 } )
AADD(aCampos,{ "NUMSEQ"		,"C",06,0 } )
AADD(aCampos,{ "OBS"		,"C",25,0 } )
AADD(aCampos,{ "INICIAL"	,"N",18,TamSX3("D1_QUANT")[2] } )  
If lVEIC     
	AADD(aCampos,{ "CODITE"	,"C",TamSX3("B1_CODITE")[1],0 } )
EndIf
	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿	
//³ Inicializa o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogIni( {},"MATR470" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("INICIO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM",STR0040 ,STR0040 ) //"Iniciando impressão do Registro de Inventario Modelo 7 "

For nForFilial := 1 To Len(aFilsCalc)
	
	If aFilsCalc[nForFilial,1]
		
		// Altera filial corrente
		cFilAnt := aFilsCalc[nForFilial,2]

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM",STR0041 + cFilAnt ,STR0041 + cFilAnt) //"Iniciando montagem do relatorio - Filial : ## "
		
		// Posiciona na tabela SM0 para impressao dos dados do cabecalho		
		SM0->(DbGoTop())
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Parametro MV_M470IPI                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		lAgregIPI := SuperGetMv("MV_M470IPI",.F.,.T.)
		
		If lGraph
			nOrd := nOrdem
		Else
			nOrd := aReturn[8]
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cria arquivo de trabalho                                        ³
		//³ O indice devera ser sempre pela DTDIGIT conforme IOB - 25/02/02 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lVEIC
			If nOrd == 1
				//Por Codigo
				cIndice1  := "PERIODO+PRODUTO+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_COD"
			ElseIf nOrd == 2
				//Por Tipo
				cIndice1  := "PERIODO+TIPO+PRODUTO+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_TIPO"
			ElseIf nOrd == 3
				//Por Descricao
				cIndice1  := "PERIODO+DESCRICAO+PRODUTO+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_DESC"
			ElseIf nOrd == 4	
				//Por Grupo
				cIndice1  := "PERIODO+GRUPO+PRODUTO+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_GRUPO"
			EndIf
		Else
			If nOrd == 1
				//Por Codigo
				cIndice1  := "PERIODO+CODITE+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_CODITE"
			ElseIf nOrd == 2
				//Por Tipo
				cIndice1  := "PERIODO+TIPO+CODITE+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_TIPO"
			ElseIf nOrd == 3
				//Por Descricao
				cIndice1  := "PERIODO+DESCRICAO+CODITE+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_DESC"
			ElseIf nOrd == 4
				//Por Grupo
				cIndice1  := "PERIODO+GRUPO+CODITE+FLAG+DTOS(DTDIGIT)"
				cTRBSeek  := "SB1->B1_GRUPO"
			EndIf
		EndIf

		If !lCusUnif
			cIndice1 := "LOCAL+"+cIndice1
		EndIf
		
		If ExistBlock("MR470IND")
			cRetPE := ExecBlock("MR470IND",.F.,.F.,{cIndice1})
			If ValType(cRetPE)=="C"
				cIndice1 := cRetPE
			EndIf
		EndIf

        // Criacao do arquivo de trabalho temporario
        If mv_par23==2 .Or. (mv_par23==1 .And. cChave<>aFilsCalc[nForFilial,4]+aFilsCalc[nForFilial,5])
			cArqTrab1 := FWOPENTEMP("TRB", aCampos)
			IndRegua("TRB",Left(cArqTrab1,7)+"I",cIndice1,,,STR0012)	//"Selecionando Registros..."
	    EndIf

		//--> TRB : Processar sempre com ordem 1 (Por Produto)
		dbSelectArea("TRB")
		dbSetOrder(1)
		dbGoTop()
		//------------------------- Pega a data inicial ideal no SD1
		dbSelectArea("SD1")
		nSavRec  := recno()
		dbSetOrder(6)
		dbSeek( xFilial("SD1") + DTOS(mv_par05))
		If !EOF() .And. Day(D1_DTDIGIT) > 0 .and. !(month(D1_DTDIGIT) > month(mv_par05)) .and. !(year(D1_DTDIGIT) > year(mv_par05))
			dDataIni := D1_DTDIGIT
		EndIf
		//------------------------- Pega a data final ideal no SD1
		dbSeek( xFilial("SD1") + DTOS(mv_par06) + "zzzz", .T. )
		If !BOF()
			dbSkip(-1)
		EndIf
		If Day(D1_DTDIGIT) > 0 .and. D1_DTDIGIT <= mv_par06 .And. D1_FILIAL == xFilial("SD1")
			dDataFim := D1_DTDIGIT
		EndIf
		GoTo nSavRec
		//------------------------- Pega a data inicial ideal no SD2
		dbSelectArea("SD2")
		nSavRec := recno()
		dbSetOrder(5)
		dbSeek( xFilial("SD2") + DTOS(mv_par05))
		If !EOF() .And. D2_EMISSAO < dDataIni
			If Day(D2_EMISSAO) > 0
				dDataIni := D2_EMISSAO
			EndIf
		EndIf
		//------------------------- Pega a data final ideal no SD2
		dbSeek( xFilial("SD2") + DTOS(mv_par06)+"zzzz", .T. )
		If !BOF()
			dbSkip(-1)
		EndIf
		If D2_EMISSAO > dDataFim .And. D2_EMISSAO <= mv_par06 .And. D2_FILIAL == xFilial("SD2")
			dDataFim := D2_EMISSAO
		EndIf
		GoTo nSavRec
		//------------------------- Pega a data inicial ideal no SD3
		dbSelectArea("SD3")
		nSavRec := recno()
		dbSetOrder(6)
		dbSeek( xFilial("SD3") + DTOS(mv_par05))
		If !EOF() .And. D3_EMISSAO < dDataIni
			If Day(D3_EMISSAO) > 0
				dDataIni := D3_EMISSAO
			EndIf
		EndIf
		//------------------------- Pega a data final ideal no SD3
		dbSeek( xFilial("SD3") + DTOS(mv_par06)+"zzzz", .T. )
		If !BOF()
			dbSkip(-1)
		EndIf
		If D3_EMISSAO > dDataFim .And. D3_EMISSAO <= mv_par06 .And. D3_FILIAL == xFilial("SD3")
			dDataFim := D3_EMISSAO
		EndIf
		GoTo nSavRec
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao de Termo / Livro                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do Case
			Case mv_par15==1 ; lImpLivro:=.T. ; lImpTermos:=.F.
			Case mv_par15==2 ; lImpLivro:=.T. ; lImpTermos:=.T.
			Case mv_par15==3 ; lImpLivro:=.F. ; lImpTermos:=.T.
		EndCase

		If !lCusUnif
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define a string da query a ser processada                ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT DISTINCT B2_FILIAL,B2_LOCAL FROM " 
			cQuery += RetSqlName("SB2")  + " SB2 " 
			cQuery += "WHERE "
			cQuery += "SB2.B2_FILIAL  = '" + xFilial("SB2")	+ "' "
			cQuery += "AND SB2.B2_LOCAL  >= '" + mv_par08	+ "' "
			cQuery += "AND SB2.B2_LOCAL  <= '" + mv_par09	+ "' "
			cQuery += "AND D_E_L_E_T_ = ' ' "
			cQuery += "GROUP BY B2_FILIAL,B2_LOCAL "
			cQuery += "ORDER BY B2_FILIAL,B2_LOCAL "
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define o alias para a query                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAliasSB2  := GetNextAlias()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o alias esta em uso                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Select( cAliasSB2 ) > 0
				dbSelectArea( cAliasSB2 )
				dbCloseArea()
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Compatibiliza a query com o banco de dados                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := ChangeQuery(cQuery)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria o alias executando a query                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSB2 , .F., .T.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa por Armazem 										 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasSB2)
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Calcula Periodos a serem processados                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dCntData  := dDataIni
		cPer      := STR(Year(dCntData),4)+STRZERO(Month(dCntData),2)
		aPeriodos := {cPer}
		While dCntData < dDataFim
			dCntData++
			If cPer <> (STR(Year(dCntData),4)+STRZERO(Month(dCntData),2))
				cPer := STR(Year(dCntData),4)+STRZERO(Month(dCntData),2)
				aAdd(aPeriodos,cPer)
			EndIf
		EndDo

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ PROCESSA RELATORIO                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		Do While IIf(lCusUnif,.T.,(cAliasSB2)->( !Eof() ) ) .And. lImpLivro
		
			If !lGraph
				If lEnd
					@PROW()+1,001 PSAY STR0023	//"CANCELADO PELO OPERADOR"
					Exit
				EndIf
			EndIf
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Query dos Armazens a serem processados                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := "SELECT "
			cQuery += "B1_FILIAL,B1_COD,B2_FILIAL,B2_COD,B2_LOCAL,B1_TIPO,B1_DESC,B1_POSIPI,B1_GRUPO,B1_UM, B1_APROPRI "
			cQuery += IIf(lVeic,",B1_CODITE ","")
			cQuery += "FROM " 
			cQuery += RetSqlName("SB1")  + " SB1 ," 
			cQuery += RetSqlName("SB2")  + " SB2 " 
			cQuery += "WHERE "
			cQuery += "SB1.B1_FILIAL      = '" + xFilial("SB1")	+ "' "
			cQuery += "AND SB2.B2_FILIAL  = '" + xFilial("SB2")	+ "' "
			cQuery += "AND SB1.B1_COD     = SB2.B2_COD "
			If !lCusUnif
				cQuery += "AND SB2.B2_LOCAL = '" + (cAliasSB2)->B2_LOCAL + "' "
			EndIf
			If lVeic
				cQuery += "AND SB1.B1_CODITE  >= '" + mv_par01 + "' "
				cQuery += "AND SB1.B1_CODITE  <= '" + mv_par02 + "' "
			Else
				cQuery += "AND SB1.B1_COD  >= '" + mv_par01 + "' "
				cQuery += "AND SB1.B1_COD  <= '" + mv_par02 + "' "
			EndIf
			cQuery += "AND SB1.B1_TIPO >= '" + mv_par03 + "' "
			cQuery += "AND SB1.B1_TIPO <= '" + mv_par04 + "' "
			cQuery += "AND SB1.D_E_L_E_T_ = ' ' "
			cQuery += "AND SB2.D_E_L_E_T_ = ' ' "
			cQuery += "ORDER BY B1_FILIAL,B1_COD "
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define o alias para a query                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cAliasTOP  := GetNextAlias()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o alias esta em uso                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Select( cAliasTop ) > 0
				dbSelectArea( cAliasTop )
				dbCloseArea()
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Compatibiliza a query com o banco de dados                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cQuery := ChangeQuery(cQuery)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Cria o alias executando a query                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasTop , .F., .T.)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Contar os registros a serem processados na rotina           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( cAliasTop )	
			dbGoTop()
			(cAliasTop)->( dbEval( { || nTamReg++ },,{ || !Eof() } ) )	
			dbGoTop()
			
			If !lGraph
				SetRegua( nTamReg )
			EndIf	

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa por Produto 										 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea(cAliasTop)
			While (cAliasTop)->(!Eof())
				If !lGraph
					IncRegua()
				EndIf
				SysRefresh()
				If !lGraph
					If lEnd
						@PROW()+1,001 PSAY STR0023	//"CANCELADO PELO OPERADOR"
						Exit
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra produto Mao de Obra                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasTop)
				If IsProdMod((cAliasTop)->B1_COD)
					dbSkip()
					Loop
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tratamento para filtro de usuario              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !Empty(cFilUser)
					dbSelectArea("SB1")
					dbSetOrder(1)
					If dbSeek( xFilial("SB1") + (cAliasTop)->B1_COD )
						If !&(cFilUser)
							dbSelectArea(cAliasTop)
							dbSkip()
							Loop
						EndIf
					Else
						dbSelectArea(cAliasTop)
						dbSkip()
						Loop
					EndIf
				EndIf
				dbSelectArea(cAliasTop)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa Variaveis                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cProdAnt  := (cAliasTop)->B1_COD
				cProdVeic := IIf(lVeic,(cAliasTop)->B1_CODITE,"") 
				cLocalAnt := IIf(lCusUnif,"",(cAliasTop)->B2_LOCAL)
				cDesc     := (cAliasTop)->B1_DESC
				cTipo     := (cAliasTop)->B1_TIPO
				cGrupo    := (cAliasTop)->B1_GRUPO
				cUm       := (cAliasTop)->B1_UM
				cPosIPI   := (cAliasTop)->B1_POSIPI
				aSalAtu   := {0,0,0,0,0,0,0}
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Saldo em Processo                              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lCusUnif .And. (cAliasTop)->B1_APROPRI == "I"
					aSalProc := CalcEst(cProdAnt,cLocProc,mv_par05,Nil)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inicializa Variavel cTRBSeek                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If nOrd == 1
					//Por Codigo
					If lVeic
						cTRBSeek  := (cAliasTop)->B1_CODITE
					Else	
						cTRBSeek  := (cAliasTop)->B1_COD
					EndIf	
				ElseIf nOrd == 2
					//Por Tipo
					cTRBSeek  := (cAliasTop)->B1_TIPO
				ElseIf nOrd == 3
					//Por Descricao
					cTRBSeek  := (cAliasTop)->B1_DESC
				ElseIf nOrd == 4	
					//Por Grupo
					cTRBSeek  := (cAliasTop)->B1_GRUPO
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Calcula saldo inicial                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lCusUnif
					dbSelectArea(cAliasTop)
					While (cAliasTop)->(!Eof()) .And. ( (cAliasTop)->B2_FILIAL+(cAliasTop)->B2_COD == xFilial("SB2")+cProdAnt)
						aSalAlmo:= CalcEst((cAliasTop)->B1_COD,(cAliasTop)->B2_LOCAL,mv_par05,Nil)
						If Len(aSalAtu) == 0
							aSalAtu:=ACLONE(aSalAlmo)
						Else
							For nY:=1 to Len(aSalAtu)
								aSalAtu[ny] += aSalAlmo[nY]
							Next nY
						EndIf
						dbSkip()
					End
				Else
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Analisa se o Produto/Armazem possui saldo, caso ³
					//| nao possua nao chama novamente a CalcEst.       |
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aSalAtu := CalcEst(cProdAnt,cLocalAnt,mv_par05,Nil)
				EndIf
				aSalAtu[1] 	:= aSalAtu[1]
				nInicial    := aSalAtu[1]
				dCntData  	:= dDataIni
				nRec1		:= 0
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Processa periodos selecionados                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				For nPeriodo := 1 to Len(aPeriodos)
					// Acumula o Saldo inicial do periodo para a correta gravacao do TRB
					nInicial    := aSalAtu[1] 
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Query SD1 - Documentos de Entrada                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := "SELECT "
					cQuery += "D1_FILIAL, D1_COD, D1_LOCAL, D1_QUANT, D1_DTDIGIT, D1_EMISSAO,"
					cQuery += IIf(SerieNfId("SD1",3,"D1_SERIE")<>"D1_SERIE",SerieNfId("SD1",3,"D1_SERIE")+",","")
					cQuery += "D1_SERIE, D1_DOC, D1_NUMSEQ, D1_CONTA, D1_CF, D1_TES, D1_BASEIPI,"
					cQuery += "D1_TOTAL, D1_DESPESA, D1_QTSEGUM, D1_CUSTO, D1_CUSTO2, D1_CUSTO3,"
					cQuery += "D1_CUSTO4, D1_CUSTO5, D1_VALIMP1, D1_VALIMP2, D1_VALIMP3, D1_VALIMP4,"
					cQuery += "D1_VALIMP5, D1_VALIMP6, D1_VALIPI, F1_MOEDA, F1_ESPECIE, F1_TXMOEDA,"
					cQuery += "F4_CREDIPI "
					If lEntrSai .Or. lA470OBS
						cQuery +=",SD1.R_E_C_N_O_ SD1RECNO,SF1.R_E_C_N_O_ SF1RECNO,SF4.R_E_C_N_O_ SF4RECNO "
					EndIf	
					cQuery += "FROM "
					cQuery += RetSqlName("SD1")  + " SD1 ,"
					cQuery += RetSqlName("SF1")  + " SF1 ,"
					cQuery += RetSqlName("SF4")  + " SF4 "
					cQuery += "WHERE "
					cQuery += "SD1.D1_FILIAL     = '" + xFilial("SD1")	+ "' "
					cQuery += "AND SD1.D1_COD    = '" + cProdAnt	   	+ "' "
					If !lCusUnif
						cQuery += "AND SD1.D1_LOCAL = '" + cLocalAnt	+ "' "
					EndIf
					cQuery += "AND SF1.F1_FILIAL = '" + xFilial("SF1") 	+ "' "
					cQuery += "AND SF4.F4_FILIAL = '" + xFilial("SF4")	+ "' "
					// Amarracao SD1 x SF1 x SF4
					cQuery += "AND SD1.D1_DOC     = SF1.F1_DOC "
					cQuery += "AND SD1.D1_SERIE   = SF1.F1_SERIE "
					cQuery += "AND SD1.D1_FORNECE = SF1.F1_FORNECE "
					cQuery += "AND SD1.D1_LOJA    = SF1.F1_LOJA "
					cQuery += "AND SD1.D1_TES     = SF4.F4_CODIGO "
					// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal e de complemento de ICMS
					//cQuery += "AND SD1.D1_ORIGLAN <> 'LF' " //paulo
					//cQuery += "AND SD1.D1_TIPO    <> 'I' "  //paulp
					// Filtra o periodo/ano selecionado
					//cQuery += "AND SD1.D1_DTDIGIT >= '" + AllTrim(aPeriodos[nPeriodo]) + "01' " //paulo
					//cQuery += "AND SD1.D1_DTDIGIT <= '" + AllTrim(aPeriodos[nPeriodo]) + "31' " //paulo
					// Desconsidera CFOP's informadas no MV_PAR24
					If len(cNoCfop) > 0
						cQuery += "AND SD1.D1_CF NOT IN ("+cNoCfop+") "
					EndIf
					// Verifica se o TES atualiza estoque
					cQuery += "AND SF4.F4_ESTOQUE = 'S' "
					cQuery += "AND SD1.D_E_L_E_T_  = ' ' "
					cQuery += "AND SF1.D_E_L_E_T_  = ' ' " 
					cQuery += "AND SF4.D_E_L_E_T_  = ' ' "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o alias para a query                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasSD1  := GetNextAlias()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD1 ) > 0
						dbSelectArea( cAliasSD1 )
						dbCloseArea()
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza a query com o banco de dados                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := ChangeQuery(cQuery)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria o alias executando a query                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD1 , .F., .T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza os campos de acordo com a TopField            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 To Len(aStruSD1)
						If aStruSD1[nX][2] <> "C" .And. AllTrim(aStruSD1[nX][1]) $ 'D1_QUANT|D1_DTDIGIT|D1_EMISSAO|D1_BASEIPI|D1_TOTAL|D1_DESPESA|D1_QTSEGUM|D1_CUSTO|D1_CUSTO2|D1_CUSTO3|D1_CUSTO4|D1_CUSTO5|D1_VALIMP1|D1_VALIMP2|D1_VALIMP3|D1_VALIMP4|D1_VALIMP5|D1_VALIMP6|D1_VALIPI'
							TcSetField(cAliasSD1,aStruSD1[nX][1],aStruSD1[nX][2],aStruSD1[nX][3],aStruSD1[nX][4])
						EndIf
					Next nX 

					For nX := 1 To Len(aStruSF1)
						If aStruSF1[nX][2] <> "C" .And. AllTrim(aStruSF1[nX][1]) $ 'F1_MOEDA|F1_TXMOEDA'
							TcSetField(cAliasSD1,aStruSF1[nX][1],aStruSF1[nX][2],aStruSF1[nX][3],aStruSF1[nX][4])
						EndIf
					Next nX 

					dbSelectArea(cAliasSD1)
					While (cAliasSD1)->(!Eof())

						nD1Qt := (cAliasSD1)->D1_QUANT

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Moeda                                               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par18==2  //nao imprimir notas com moeda diferente da escolhida
							If If((cAliasSD1)->F1_MOEDA==0,1,(cAliasSD1)->F1_MOEDA)!=mv_par11
								dbskip()
								Loop
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Data Limite                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cAliasSD1)->D1_DTDIGIT < mv_par05 .Or.;
						   (cAliasSD1)->D1_DTDIGIT > mv_par06
							dbSkip()
							Loop
						EndIf
						lT := .F.
						If lVEIC
							If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdVeic, "") + 'S'))
								lT := .T.
							EndIf
						Else
							If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdAnt, "") + 'S'))
								lT := .T.
							EndIf
						EndIf
						If lT
							RecLock("TRB",.F.)
							TRB->FLAG := " "
						Else	
							RecLock("TRB",.T.)
						EndIf
		
						If lVEIC
							TRB->CODITE	:= cProdVeic
						EndIf

						TRB->PERIODO  := aPeriodos[nPeriodo]
						TRB->PRODUTO  := cProdAnt
						TRB->DESCRICAO:= cDesc
						TRB->TIPO     := cTipo
						TRB->GRUPO    := cGrupo
						TRB->UM       := cUm
						TRB->POSIPI   := cPosIPI
						TRB->ESPECIE  := (cAliasSD1)->F1_ESPECIE
						TRB->SERIE    := (cAliasSD1)->&(SerieNfId("SD1",3,"D1_SERIE"))
						TRB->NUMERO   := (cAliasSD1)->D1_DOC
						TRB->NUMSEQ   := (cAliasSD1)->D1_NUMSEQ
						TRB->EMISSAO  := (cAliasSD1)->D1_EMISSAO
						TRB->DTDIGIT  := (cAliasSD1)->D1_DTDIGIT
						TRB->CC       := (cAliasSD1)->D1_CONTA
						TRB->CF       := IIf(cPaisLoc=="BRA",(cAliasSD1)->D1_CF," ")
						TRB->ES       := " E "    
						TRB->INICIAL  := nInicial
						If lCusUnif
							TRB->COD  := If((cAliasSD1)->D1_LOCAL $ cLocTerc,"2",IIf((cAliasSD1)->D1_TES $ cTipoDoc,"3","1"))
						Else
							TRB->COD  := If(cLocalAnt $ cLocTerc,"2",IIf((cAliasSD1)->D1_TES $ cTipoDoc,"3","1"))
						EndIf						
						TRB->LOCAL  := IIf(lCusUnif,"",(cAliasSD1)->D1_LOCAL)
						// Executa P.E. para carregar a coluna 'Observacao'
						If lA470OBS
							// Posiciona
							SF1->(dbGoto((cAliasSD1)->SF1RECNO))
							SF4->(dbGoto((cAliasSD1)->SF4RECNO))
							SD1->(dbGoto((cAliasSD1)->SD1RECNO))
							uObsNew := ExecBlock("MA470OBS",.F.,.F.,"SD1")
							If Valtype(uObsNew) == "C"
							   TRB->OBS := uObsNew
							EndIf   
						EndIf
						// Executa P.E. para avaliar codigo a ser impresso no codigo de entrada e saida
						If lEntrSai
							// Posiciona
							SF1->(dbGoto((cAliasSD1)->SF1RECNO))
							SF4->(dbGoto((cAliasSD1)->SF4RECNO))
							SD1->(dbGoto((cAliasSD1)->SD1RECNO))
							cRetPE := ExecBlock("MTR470ES",.F.,.F.,"SD1")
							If ValType(cRetPE)=="C" .And. cRetPE $ "1/2/3"
								TRB->COD:=cRetPE
							EndIf
						EndIf
						TRB->QTDE   := nD1QT
						If cPaisLoc <> "BRA"
							TRB->VALOR := xMoeda(If((cAliasSD1)->D1_BASEIPI>0,(cAliasSD1)->D1_BASEIPI,(cAliasSD1)->D1_TOTAL+If(mv_par20==1,0,(cAliasSD1)->D1_DESPESA)),1,mv_par11,(cAliasSD1)->D1_EMISSAO,(cAliasSD1)->F1_TXMOEDA)
						Else
							If lAgregIPI
								TRB->VALOR := If((cAliasSD1)->D1_BASEIPI>0,(cAliasSD1)->D1_BASEIPI+IIf((cAliasSD1)->F4_CREDIPI<>'S',(cAliasSD1)->D1_VALIPI,0),(cAliasSD1)->D1_TOTAL+If(mv_par20==1,0,(cAliasSD1)->D1_DESPESA))
							Else
								TRB->VALOR := If((cAliasSD1)->D1_BASEIPI>0,(cAliasSD1)->D1_BASEIPI,(cAliasSD1)->D1_TOTAL+If(mv_par20==1,0,(cAliasSD1)->D1_DESPESA))
							EndIf	
						EndIf
						If ( cPaisLoc=="BRA" )
							TRB->IPI := If((cAliasSD1)->F4_CREDIPI=='S',(cAliasSD1)->D1_VALIPI,0)
						Else
							nImpInc :=0
							aImpostos:=TesImpInf((cAliasSD1)->D1_TES)
							For nY:=1 to Len(aImpostos)
								cCampImp:=cAliasSD1+"->"+(aImpostos[nY][2])
								If ( aImpostos[nY][3]=="1" )
									nImpInc += xMoeda(&cCampImp,1,mv_par11,(cAliasSD1)->D1_EMISSAO,,(cAliasSD1)->F1_TXMOEDA)
								EndIf
							Next
							TRB->IPI := nImpInc
						EndIf
						aSalAtu[2] += &(Eval(bBloco,cAliasSD1+"->D1_CUSTO",IIf(mv_par11==1," ",mv_par11)))
						aSalAtu[1] += nD1QT
						aSalAtu[7] += (cAliasSD1)->D1_QTSEGUM
						TRB->ESTOQUE := aSalAtu[1]
						MsUnlock()
						nRec1++
						dbSelectArea(cAliasSD1)
						dbSkip()
					EndDo

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD1 ) > 0
						dbSelectArea( cAliasSD1 )
						dbCloseArea()
					EndIf
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Query SD3 - Movimentos Internos                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := "SELECT "
					cQuery += "D3_FILIAL, D3_COD, D3_LOCAL, D3_QUANT, D3_EMISSAO, D3_DOC, D3_NUMSEQ,"
					cQuery += "D3_CC, D3_CF, D3_TM, D3_CUSTO1, D3_CUSTO2, D3_CUSTO3, D3_CUSTO4, D3_CUSTO5,"
					cQuery += "D3_QTSEGUM, D3_ESTORNO, D3_SERVIC "
					If lEntrSai .Or. lA470OBS
						cQuery +=",SD3.R_E_C_N_O_ SD3RECNO "
					EndIf	
					cQuery += "FROM "
					cQuery += RetSqlName("SD3")  + " SD3 "
					cQuery += "WHERE "
					cQuery += "SD3.D3_FILIAL     = '" + xFilial("SD3")	+ "' "
					cQuery += "AND SD3.D3_COD    = '" + cProdAnt	   	+ "' "
					If !lCusUnif .And. !(lLocProc .And. cLocProc==cLocalAnt)
						cQuery += "AND SD3.D3_LOCAL = '" + cLocalAnt	+ "' "
					EndIf
					// Filtra o periodo/ano selecionado
					cQuery += "AND SD3.D3_EMISSAO >= '" + AllTrim(aPeriodos[nPeriodo]) + "01' "
					cQuery += "AND SD3.D3_EMISSAO <= '" + AllTrim(aPeriodos[nPeriodo]) + "31' "
					cQuery += "AND SD3.D3_ESTORNO  = ' ' "
					cQuery += "AND SD3.D_E_L_E_T_  = ' ' "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o alias para a query                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasSD3  := GetNextAlias()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD3 ) > 0
						dbSelectArea( cAliasSD3 )
						dbCloseArea()
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza a query com o banco de dados                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := ChangeQuery(cQuery)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria o alias executando a query                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD3 , .F., .T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza os campos de acordo com a TopField            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 To Len(aStruSD3)
						If aStruSD3[nX][2] <> "C" .And. AllTrim(aStruSD3[nX][1]) $ 'D3_QUANT|D3_EMISSAO|D3_CUSTO1|D3_CUSTO2|D3_CUSTO3|D3_CUSTO4|D3_CUSTO5|D3_QTSEGUM'
							TcSetField(cAliasSD3,aStruSD3[nX][1],aStruSD3[nX][2],aStruSD3[nX][3],aStruSD3[nX][4])
						EndIf
					Next nX 

					dbSelectArea(cAliasSD3)
					While (cAliasSD3)->(!Eof())

						nD3Qt := (cAliasSD3)->D3_QUANT

						//-- Somente processar D3Valido quanto utilizar WMS
						If lIntDL .And. !D3Valido(cAliasSD3)
							dbSelectArea(cAliasSD3)
							dbSkip()
							Loop
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Data Limite                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cAliasSD3)->D3_EMISSAO < mv_par05 .Or.;
						   (cAliasSD3)->D3_EMISSAO > mv_par06
							dbSelectArea(cAliasSD3)
							dbSkip()
							Loop
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Quando movimento ref apropr. indireta, so considera os         ³
						//³ movimentos com destino ao almoxarifado de apropriacao indireta.³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						lInverteMov:=.F.
						lProcesso  :=.F.
						If (cAliasSD3)->D3_LOCAL != cLocalAnt .Or. lCusUnif
							If !(Substr((cAliasSD3)->D3_CF,3,1) $ "3")
								If !lCusUnif
									dbSelectArea(cAliasSD3)
									dbSkip()
									Loop
								EndIf
							ElseIf lPriApropri
								lInverteMov:=.T.
								lProcesso  :=.T.
								If len(aSalProc) == 0 .and. !lCusUnif 
									aSalProc := CalcEst(cProdAnt,cLocProc,mv_par05,Nil)
								EndIf
							EndIf
						EndIf

						lT := .F.
						If lVEIC
							If TRB->(dbSeek(If(lCusUnif,"",IIf(lProcesso,cLocProc,cLocalAnt)) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdVeic, "") + 'S'))
								lT := .T.
							EndIf
						Else
							If TRB->(dbSeek(If(lCusUnif,"",IIf(lProcesso,cLocProc,cLocalAnt)) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdAnt, "") + 'S'))
								lT := .T.
							EndIf
						EndIf
		
						If lT
							RecLock("TRB",.F.)
							TRB->FLAG := " "
						Else	
							RecLock("TRB",.T.)
						EndIf
		
						If lVEIC
							TRB->CODITE	:= cProdVeic
						EndIf

						TRB->PERIODO  := aPeriodos[nPeriodo]
						TRB->PRODUTO  := cProdAnt
						TRB->DESCRICAO:= cDesc
						TRB->TIPO     := cTipo
						TRB->GRUPO    := cGrupo
						TRB->UM       := cUM
						TRB->POSIPI   := cPosIPI
						TRB->NUMERO   := (cAliasSD3)->D3_DOC
						TRB->NUMSEQ   := (cAliasSD3)->D3_NUMSEQ
						TRB->EMISSAO  := (cAliasSD3)->D3_EMISSAO
						TRB->DTDIGIT  := (cAliasSD3)->D3_EMISSAO
						TRB->CC       := (cAliasSD3)->D3_CC
						TRB->INICIAL  := nInicial
						If lInverteMov
							TRB->CF   := IIf(cPaisLoc=="BRA",allTrim((cAliasSD3)->D3_CF)+"*"," ")
						Else
							TRB->CF   := IIf(cPaisLoc=="BRA",(cAliasSD3)->D3_CF," ")
						EndIf
						TRB->ES       := IIf(IIf(lInverteMov,(Val((cAliasSD3)->D3_TM) > 500),Val((cAliasSD3)->D3_TM) <= 500) ," E "," S ")
						If lCusUnif						
							TRB->COD  := IIf(IIf(lProcesso,cLocProc,(cAliasSD3)->D3_LOCAL) $ cLocTerc,"2","1")
						Else
							TRB->COD  := IIf(IIf(lProcesso,cLocProc,cLocalAnt) $ cLocTerc,"2","1")
						EndIf									
						TRB->LOCAL    := IIf(lCusUnif,"",IIf(lProcesso,cLocProc,cLocalAnt))
						// Executa P.E. para carregar a coluna 'Observacao'
						If lA470OBS
							// Posiciona
							SD3->(dbGoto((cAliasSD3)->SD3RECNO))
							uObsNew := ExecBlock("MA470OBS",.F.,.F.,"SD3")
							If Valtype(uObsNew) == "C"
							   TRB->OBS := uObsNew
							EndIf   
						EndIf
						// Executa P.E. para avaliar codigo a ser impresso no codigo de entrada e saida
						If lEntrSai
							// Posiciona
							SD3->(dbGoto((cAliasSD3)->SD3RECNO))
							cRetPE := ExecBlock("MTR470ES",.F.,.F.,"SD3")
							If ValType(cRetPE)=="C" .And. cRetPE $ "1/2/3"
								TRB->COD:=cRetPE
							EndIf
						EndIf	
						TRB->QTDE    := nD3QT
						TRB->VALOR   := &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
						If lInverteMov
							If (cAliasSD3)->D3_TM > "500"
								If lProcesso .And. !lCusUnif
									aSalProc[1]	+= nD3QT
									aSalProc[2]	+= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalProc[7]	+= (cAliasSD3)->D3_QTSEGUM
								Else
									aSalAtu[1]	+= nD3QT
									aSalAtu[2]	+= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalAtu[7]	+= (cAliasSD3)->D3_QTSEGUM
								EndIf	
							Else
								If lProcesso .And. !lCusUnif
									aSalProc[1]	-= nD3QT
									aSalProc[2]	-= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalProc[7]	-= (cAliasSD3)->D3_QTSEGUM
								Else
									aSalAtu[1]	-= nD3QT
									aSalAtu[2]	-= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalAtu[7]	-= (cAliasSD3)->D3_QTSEGUM
								EndIf	
							EndIf
							If lCusUnif
								lPriApropri:=.F.
							EndIf	
						Else
							If (cAliasSD3)->D3_TM <= "500"
								If lProcesso .And. !lCusUnif
									aSalProc[1]	+= nD3QT
									aSalProc[2]	+= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalProc[7]	+= (cAliasSD3)->D3_QTSEGUM
								Else
									aSalAtu[1]	+= nD3QT
									aSalAtu[2]	+= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalAtu[7]	+= (cAliasSD3)->D3_QTSEGUM
								EndIf	
							Else
								If lProcesso .And. !lCusUnif
									aSalProc[1]	-= nD3QT
									aSalProc[2]	-= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalProc[7]	-= (cAliasSD3)->D3_QTSEGUM
								Else
									aSalAtu[1]	-= nD3QT
									aSalAtu[2]	-= &(Eval(bBloco,cAliasSD3+"->D3_CUSTO",mv_par11))
									aSalAtu[7]	-= (cAliasSD3)->D3_QTSEGUM
								EndIf	
							EndIf
							If lCusUnif
								lPriApropri:=.T.
							EndIf	
						EndIf
						TRB->ESTOQUE := IIf(lProcesso .And. !lCusUnif,aSalProc[1],aSalAtu[1])
						MsUnlock()
						nRec1++
						dbSelectArea(cAliasSD3)
						If !lInverteMov .Or. (lInverteMov .And. lPriApropri)
							dbSkip()
						EndIf
					EndDo

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD3 ) > 0
						dbSelectArea( cAliasSD3 )
						dbCloseArea()
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Query SD2 - Documentos de Saida                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := "SELECT "
					cQuery += "D2_FILIAL, D2_COD, D2_LOCAL, D2_QUANT, D2_EMISSAO, D2_SERIE, D2_DOC, D2_NUMSEQ,"
					cQuery += IIf(SerieNfId("SD2",3,"D2_SERIE")<>"D2_SERIE",SerieNfId("SD2",3,"D2_SERIE")+",","")
					cQuery += "D2_CF, D2_TES, D2_BASEIPI, D2_TOTAL, D2_VALIPI, D2_CUSTO1, D2_CUSTO2, D2_CUSTO3,"
					cQuery += "D2_CUSTO4, D2_CUSTO5, D2_VALIMP1, D2_VALIMP2, D2_VALIMP3, D2_VALIMP4, D2_VALIMP5,"
					cQuery += "D2_QTSEGUM, F2_MOEDA, F2_TXMOEDA, F2_ESPECIE "
					If lEntrSai .Or. lA470OBS
						cQuery +=",SD2.R_E_C_N_O_ SD2RECNO,SF2.R_E_C_N_O_ SF2RECNO,SF4.R_E_C_N_O_ SF4RECNO "
					EndIf	
					cQuery += "FROM "
					cQuery += RetSqlName("SD2")  + " SD2 ,"
					cQuery += RetSqlName("SF2")  + " SF2 ,"
					cQuery += RetSqlName("SF4")  + " SF4 "
					cQuery += "WHERE "
					cQuery += "SD2.D2_FILIAL     = '" + xFilial("SD2")	+ "' "
					cQuery += "AND SD2.D2_COD    = '" + cProdAnt	   	+ "' "
					If !lCusUnif
						cQuery += "AND SD2.D2_LOCAL = '" + cLocalAnt	+ "' "
					EndIf
					cQuery += "AND SF2.F2_FILIAL = '" + xFilial("SF2") 	+ "' "
					cQuery += "AND SF4.F4_FILIAL = '" + xFilial("SF4")	+ "' "
					// Amarracao SD2 x SF2 x SF4
					cQuery += "AND SD2.D2_DOC     = SF2.F2_DOC "
					cQuery += "AND SD2.D2_SERIE   = SF2.F2_SERIE "
					cQuery += "AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
					cQuery += "AND SD2.D2_LOJA    = SF2.F2_LOJA "
					cQuery += "AND SD2.D2_TES     = SF4.F4_CODIGO "
					// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal e de complementos de preco e impostos.
					cQuery += "AND SD2.D2_ORIGLAN <> 'LF' "
					cQuery += "AND SD2.D2_TIPO    <> 'C' "
					cQuery += "AND SD2.D2_TIPO    <> 'P' "
					cQuery += "AND SD2.D2_TIPO    <> 'I' "
					// Filtra o periodo/ano selecionado
					cQuery += "AND SD2.D2_EMISSAO >= '" + AllTrim(aPeriodos[nPeriodo]) + "01' "
					cQuery += "AND SD2.D2_EMISSAO <= '" + AllTrim(aPeriodos[nPeriodo]) + "31' "
					// Verifica se o TES atualiza estoque
					cQuery += "AND SF4.F4_ESTOQUE = 'S' "
					cQuery += "AND SD2.D_E_L_E_T_  = ' ' "
					cQuery += "AND SF2.D_E_L_E_T_  = ' ' " 
					cQuery += "AND SF4.D_E_L_E_T_  = ' ' "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Define o alias para a query                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cAliasSD2  := GetNextAlias()
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD2 ) > 0
						dbSelectArea( cAliasSD2 )
						dbCloseArea()
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza a query com o banco de dados                  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery := ChangeQuery(cQuery)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Cria o alias executando a query                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD2 , .F., .T.)
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza os campos de acordo com a TopField            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Compatibiliza os campos de acordo com a TopField            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					For nX := 1 To Len(aStruSD2)
						If aStruSD2[nX][2] <> "C" .And. Alltrim(aStruSD2[nX][1]) $ 'D2_QUANT|D2_EMISSAO|D2_BASEIPI|D2_TOTAL|D2_VALIPI|D2_CUSTO1|D2_CUSTO2|D2_CUSTO3|D2_CUSTO4|D2_CUSTO5|D2_VALIMP1|D2_VALIMP2|D2_VALIMP3|D2_VALIMP4|D2_VALIMP5|D2_QTSEGUM'
							TcSetField(cAliasSD2,aStruSD2[nX][1],aStruSD2[nX][2],aStruSD2[nX][3],aStruSD2[nX][4])
						EndIf
					Next nX 
					For nX := 1 To Len(aStruSF2)
						If aStruSF2[nX][2] <> "C" .And. AllTrim(aStruSF2[nX][1]) $ 'F2_MOEDA|F2_TXMOEDA'
							TcSetField(cAliasSD2,aStruSF2[nX][1],aStruSF2[nX][2],aStruSF2[nX][3],aStruSF2[nX][4])
						EndIf
					Next nX 

					dbSelectArea(cAliasSD2)
					
					While (cAliasSD2)->(!Eof())

						nD2Qt := (cAliasSD2)->D2_QUANT

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Moeda                                               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par18==2  //nao imprimir notas com moeda diferente da escolhida
							If If((cAliasSD2)->F2_MOEDA==0,1,(cAliasSD2)->F2_MOEDA)!=mv_par11
								dbSkip()
								Loop
							EndIf
						EndIf
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica Data Limite                                         ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If (cAliasSD2)->D2_EMISSAO < mv_par05 .Or.;
						   (cAliasSD2)->D2_EMISSAO > mv_par06
							dbSkip()
							Loop
						EndIf
						lT := .F.
						If lVEIC
							If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdVeic, "") + 'S'))
								lT := .T.
							EndIf
						Else
							If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdAnt, "") + 'S'))
								lT := .T.
							EndIf
						EndIf
		
						If lT
							RecLock("TRB",.F.)
							TRB->FLAG := " "
						Else	
							RecLock("TRB",.T.)
						EndIf

						If lVEIC
							TRB->CODITE	:= cProdVeic
						EndIf
		
						TRB->PERIODO  := aPeriodos[nPeriodo]
						TRB->PRODUTO  := cProdAnt
						TRB->DESCRICAO:= cDesc
						TRB->TIPO     := cTipo
						TRB->GRUPO    := cGrupo
						TRB->UM       := cUM
						TRB->POSIPI   := cPosIPI
						TRB->ESPECIE  := (cAliasSD2)->F2_ESPECIE
						TRB->SERIE    := (cAliasSD2)->&(SerieNfId("SD2",3,"D2_SERIE"))
						TRB->NUMERO   := (cAliasSD2)->D2_DOC
						TRB->NUMSEQ   := (cAliasSD2)->D2_NUMSEQ
						TRB->EMISSAO  := (cAliasSD2)->D2_EMISSAO
						TRB->DTDIGIT  := (cAliasSD2)->D2_EMISSAO
						TRB->CF       := IIf(cPaisLoc=="BRA",(cAliasSD2)->D2_CF," ")
						TRB->ES       := " S "
						TRB->INICIAL  := nInicial
						If lCusUnif						
							TRB->COD  := If((cAliasSD2)->D2_LOCAL $ cLocTerc,"2",IIf((cAliasSD2)->D2_TES $ cTipoDoc,"3","1"))
						Else
							TRB->COD  := If(cLocalAnt $ cLocTerc,"2",IIf((cAliasSD2)->D2_TES $ cTipoDoc,"3","1"))
						EndIf						
						TRB->LOCAL    := IIf(lCusUnif,"",(cAliasSD2)->D2_LOCAL)
						// Executa P.E. para carregar a coluna 'Observacao'
						If lA470OBS
							// Posiciona
							SF2->(dbGoto((cAliasSD2)->SF2RECNO))
							SF4->(dbGoto((cAliasSD2)->SF4RECNO))
							SD2->(dbGoto((cAliasSD2)->SD2RECNO))
							uObsNew := ExecBlock("MA470OBS",.F.,.F.,"SD2")
							If Valtype(uObsNew) == "C"
							   TRB->OBS := uObsNew
							EndIf   
						EndIf
						// Executa P.E. para avaliar codigo a ser impresso no codigo de entrada e saida
						If lEntrSai
							// Posiciona
							SF2->(dbGoto((cAliasSD2)->SF2RECNO))
							SF4->(dbGoto((cAliasSD2)->SF4RECNO))
							SD2->(dbGoto((cAliasSD2)->SD2RECNO))
							cRetPE := ExecBlock("MTR470ES",.F.,.F.,"SD2")
							If ValType(cRetPE)=="C" .And. cRetPE $ "1/2/3"
								TRB->COD:=cRetPE
							EndIf
						EndIf
						TRB->QTDE    := nD2QT
						If cPaisLoc == "BRA"
							TRB->VALOR := If((cAliasSD2)->D2_BASEIPI>0,(cAliasSD2)->D2_BASEIPI,(cAliasSD2)->D2_TOTAL)
						Else
							TRB->VALOR := xMoeda((cAliasSD2)->D2_TOTAL,1,mv_par11,(cAliasSD2)->D2_EMISSAO,,(cAliasSD2)->F2_TXMOEDA)
						EndIf
						If ( cPaisLoc=="BRA" )
							TRB->IPI := (cAliasSD2)->D2_VALIPI
						Else
							nImpInc  :=0
							aImpostos:=TesImpInf((cAliasSD2)->D2_TES)
							For nY:=1 to Len(aImpostos)
								cCampImp:=cAliasSD2+"->"+(aImpostos[nY][2])
								If ( aImpostos[nY][3]=="1" )
									nImpInc += xMoeda(&cCampImp,1,mv_par11,(cAliasSD2)->D2_EMISSAO,,(cAliasSD2)->F2_TXMOEDA)
								EndIf
							Next
							TRB->IPI := nImpInc
						EndIf
						aSalAtu[2]	-= &(Eval(bBloco,cAliasSD2+"->D2_CUSTO",mv_par11))
						aSalAtu[1]	-= nD2QT
						aSalAtu[7]	-= (cAliasSD2)->D2_QTSEGUM
						TRB->ESTOQUE := aSalAtu[1]
						MsUnlock()
						nRec1++
						dbSelectArea(cAliasSD2)
						dbSkip()
					EndDo

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o alias esta em uso                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Select( cAliasSD2 ) > 0
						dbSelectArea( cAliasSD2 )
						dbCloseArea()
					EndIf

					If nRec1 == 0
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se deve ou nao listar os produtos s/movimento ³
						//³ Caso liste o produto, grava produto com TRB->FLAG = S  ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If mv_par07 == 1 .Or. (aSalAtu[1] > 0 .And. mv_par17 ==1)
							lT	:= .F.
							If lVEIC
								If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdAnt, "") + 'S'))
									lT := .T.
								EndIf
							Else
								If TRB->(dbSeek(If(lCusUnif,"",cLocalAnt) + aPeriodos[nPeriodo] + cTRBSeek + If(nOrd <> 1,cProdVeic, "") + 'S'))
									lT := .T.
								EndIf
							EndIf
							If lT
								RecLock("TRB",.F.)
							Else
								RecLock("TRB",.T.)
								If lVEIC
									TRB->CODITE	:= cProdVeic
								EndIf
								TRB->PERIODO  := aPeriodos[nPeriodo]
								TRB->PRODUTO  := cProdAnt
								TRB->FLAG     := 'S'
								TRB->DESCRICAO:= cDesc
								TRB->TIPO     := cTipo
								TRB->GRUPO    := cGrupo
								TRB->UM       := cUM
								TRB->POSIPI   := cPosIPI
								TRB->LOCAL	  := cLocalAnt
								TRB->INICIAL  := nInicial
							EndIf
							If mv_par17 == 1
								TRB->ESTOQUE  := aSalAtu[1]
							EndIf
							MsUnlock()
						EndIf
					EndIf
					nRec1 := 0        
		        Next nPeriodo
		        
				dbSelectArea(cAliasTop)
				If !lCusUnif
					dbSkip()
				EndIf	
			EndDo

			If Select( cAliasTOP ) > 0
				dbSelectArea( cAliasTOP )
				dbCloseArea()
			EndIf

			// Proximo armazem. Se custo unif. encerre laco.
			If lCusUnif
				Exit
			Else
				dbSelectArea(cAliasSB2)
				dbSkip()
			EndIf
		EndDo
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM",STR0042 + cFilAnt , STR0042 + cFilAnt) //"Temino da montagem do relatorio - Filial : ## "



		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Chave para aglutinacao CNPJ+IE              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cChave := IIf(mv_par23==1,aFilsCalc[nForFilial,4]+aFilsCalc[nForFilial,5],'')

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do relatorio                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        If mv_par23==2 .Or.;
          (mv_par23==1 .And. IIf(Len(aFilsCalc)==nForFilial,.T.,cChave<>aFilsCalc[nForFilial+1,4]+aFilsCalc[nForFilial+1,5]))

			If mv_par23==1
				aSalEst := {}
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Atualiza o log de processamento			    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ProcLogAtu("MENSAGEM",STR0043 + cFilAnt ,STR0043 + cFilAnt) //"Iniciando Impressao do relatorio - Filial : ## "
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ PROCESSANDO ARQUIVO DE TRABALHO                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "TRB" )
			If !lVEIC
				If nOrd > 1
					If nOrd == 2	
						cIndice2 := "PERIODO+TIPO+PRODUTO+FLAG+DTOS(DTDIGIT)"
					ElseIf nOrd == 3	
						cIndice2 := "PERIODO+DESCRICAO+PRODUTO+FLAG+DTOS(DTDIGIT)"
					ElseIf nOrd == 4	
						cIndice2 := "PERIODO+GRUPO+PRODUTO+FLAG+DTOS(DTDIGIT)"
					EndIf
					If !lCusUnif
						cIndice2 := "LOCAL+"+cIndice2
					EndIf           
					
					If ExistBlock("MR470IND")
						cRetPE := ExecBlock("MR470IND",.F.,.F.,{cIndice2})
						If ValType(cRetPE)=="C"
							cIndice2 := cRetPE
						EndIf
					EndIf
									
					cArqTrab2 := CriaTrab(Nil,.F.)
					IndRegua("TRB",cArqTrab2,cIndice2,,,STR0012)				//"Selecionando Registros..."
				EndIf
			Else
				If nOrd > 1
					If nOrd == 2
						cIndice2 := "PERIODO+TIPO+CODITE+FLAG+DTOS(DTDIGIT)"
					ElseIf nOrd == 3
						cIndice2  := "PERIODO+DESCRICAO+CODITE+FLAG+DTOS(DTDIGIT)"
					ElseIf nOrd == 4
						cIndice2 := "PERIODO+GRUPO+CODITE+FLAG+DTOS(DTDIGIT)"
					EndIf
					If !lCusUnif
						cIndice2 := "LOCAL+"+cIndice2
					EndIf          
	
					If ExistBlock("MR470IND")
						cRetPE := ExecBlock("MR470IND",.F.,.F.,{cIndice2})
						If ValType(cRetPE)=="C"
							cIndice2 := cRetPE
						EndIf
					EndIf
					
					cArqTrab2 := CriaTrab(Nil,.F.)
					IndRegua("TRB",cArqTrab2,cIndice2,,,STR0012)				//"Selecionando Registros..."
				EndIf
			EndIf
	
			dbGoTop()
			If !lGraph
				SetRegua(LastRec())
			Else
				oReport:SetMeter(LastRec())
			EndIf	
	
			nEntDay :=nSaiDay:=nValEntDay:=nValSaiDay:=nIpiEntDay:=nIpiSaiDay:=0
			nEntPer :=nSaiPer:=nValEntPer:=nValSaiPer:=nIpiEntPer:=nIpiSaiPer:=0
			nSalEst :=0
			aSalAtu :={}
			lMudaIni:=.T.
	
			While TRB->( !EOF() )
				dbSelectArea( "TRB" )
				If !lGraph
					IncRegua()
				Else
					oReport:IncMeter()
				EndIf
				SysRefresh()
				
				If !lGraph
					If lEnd
						@PROW()+1,001 PSAY STR0023	//"CANCELADO PELO OPERADOR"
						Exit
					EndIf
			    EndIf
				If li > 59
					R470Cabec( @Li, @nPaginas, , lGraph, oReport, aFilsCalc[ nForFilial, 3 ] )
				EndIf
	
				lImpr	  := .T.
				cDia 	  := StrZero(Day(TRB->DTDIGIT),2)
				cProd	  := TRB->PRODUTO
				cLocalAnt := TRB->LOCAL
				If lVEIC
					cCODITE	:=TRB->CODITE
				EndIf	
				cPer 		:=TRB->PERIODO
				If !lVEIC
					aInfoCabec:=	{	TRB->PRODUTO+" - "+SUBS(TRB->DESCRICAO,1,30),;
									 	TRB->UM,;
										TRB->POSIPI,;
										IIf(lCusUnif,"",TRB->LOCAL),;
										TRB->PERIODO;
									}
			
				Else
					aInfoCabec:=	{	TRB->CODITE + " -" + SUBS(TRB->DESCRICAO,1,30) + "-" + TRB->PRODUTO ,;
										TRB->UM,;
										TRB->POSIPI,;
										IIf(lCusUnif,"",TRB->LOCAL),;
										TRB->PERIODO;
									}
				EndIf
	
				// Recupera o saldo inicial do produto
				dbSelectArea( "TRB" )
				If nSalEst == 0 .And. lFirst1 .And. lMudaIni
					nSalEst := TRB->INICIAL
				EndIf
			
				If TRB->FLAG == 'S'
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se ha produtos sem movimentos				   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDados:=Array(14)
					If mv_par17 == 1
						aDados[06]:=STR0024	//"Saldo Inicial:"
						aDados[13]:=Transform(nSalEst,cPicB9SL)
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf	
					EndIf
					aDados[01]:=STR0027		//"Nao houve movimentacao para este produto."
					If mv_par17 == 1
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf	
						aDados[06]:=STR0026	//"Total do Periodo:"
						aDados[08]:=IIf(cPaisLoc=="BRA","EST","STK")
						aDados[13]:=Transform(nSalEst,cPicB9SL)
					EndIf
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					EndIf	
					While Li<60
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf	
					End
					If !lGraph
						FmtLin(,aL[01],,,@Li)
					Else
						FmtLinR4(oReport,,aL[01],,,@Li)
					EndIf
					Li:=80
					lImpr  := .F.
					lFirst1:= .F.
				EndIf
	
				If lFirst1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime Saldo Inicial do Produto ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					aDados    :=Array(14)
					aDados[06]:=STR0024		//"Saldo Inicial:"
					aDados[13]:=Transform(nSalEst,cPicB9SL)
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					Endif	
					lFirst1 := .F.
				EndIf
	
				If lImpr
					aDados		:= Array(14)
					aDados[01] 	:= TRB->ESPECIE
					aDados[02] 	:= Alltrim(TRB->SERIE)
					aDados[03] 	:= IF(MV_PAR10==1,TRB->NUMERO,TRB->NUMSEQ)
					aDados[04] 	:= TRB->EMISSAO
					aDados[05] 	:= StrZero(Day(TRB->DTDIGIT),2)
					aDados[06] 	:= TRB->PRODUTO
					aDados[07] 	:= TRB->CF
					aDados[08] 	:= TRB->ES
					aDados[09] 	:= TRB->COD
					aDados[10] 	:= Transform(TRB->QTDE,cPicD1Qt)
					aDados[11] 	:= Transform(TRB->VALOR,"@E 999,999,999,999.99")
					aDados[12] 	:= Transform(TRB->IPI,"@E 999,999,999,999.99")
					If TRB->ES == " E "	
						nSalEst += TRB->QTDE
					Elseif TRB->ES == " S "
						nSalEst -= TRB->QTDE
					EndIf
					aDados[13] 	:= Transform(nSalEst,cPicB9SL)
					aDados[14] 	:= TRB->OBS
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					EndIf	
	
					If TRB->ES == " S "
						// Total da Qtde de Saida
						nSaiDay    += TRB->QTDE
						nSaiPer    += TRB->QTDE
						// Total do IPI de Saida
						nIpiSaiDay += TRB->IPI
						nIpiSaiPer += TRB->IPI
						// Total do Valor de Saida
						nValSaiDay += TRB->VALOR
						nValSaiPer += TRB->VALOR
					ElseIf TRB->ES == " E "	
						// Total da Qtde de Entrada
						nEntDay    += TRB->QTDE
						nEntPer    += TRB->QTDE
						// Total do IPI de Entrada
						nIpiEntDay += TRB->IPI
						nIpiEntPer += TRB->IPI
						// Total do Valor de Entrada
						nValEntDay += TRB->VALOR
						nValEntPer += TRB->VALOR
					EndIf
				EndIf
			
				dbSelectArea( "TRB" )
				dbSkip()
	
				// Total do Dia
				If (nEntDay+nSaiDay) > 0 .And. mv_par16 == 1 .And. cDia <> StrZero(Day(TRB->DTDIGIT),2)
					If li > 56
						aDados:=Array(14)
						R470Cabec( @Li, @nPaginas, aInfoCabec, lGraph, oReport, aFilsCalc[ nForFilial, 3 ] )
					EndIf
					aDados:=Array(14)
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					Endif	
					aDados[06]:=STR0025+cDIA+":"		//"Sub-Total do Dia "
					aDados[08]:=" E "
					aDados[10]:=Transform(nEntDay,cPicD1Qt)
					aDados[11]:=Transform(nValEntDay,"@E 999,999,999,999.99")
					aDados[12]:=Transform(nIPIEntDay,"@E 999,999,999,999.99")
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					Endif	
					aDados[08]:=" S "
					aDados[10]:=Transform(nSaiDay,cPicD1Qt)
					aDados[11]:=Transform(nValSaiDay,"@E 999,999,999,999.99")
					aDados[12]:=Transform(nIPISaiDay,"@E 999,999,999,999.99")
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					EndIf	
					aDados:=Array(14)
					aDados[08]:=IIf(cPaisLoc=="BRA","EST","STK")
					aDados[13]:=Transform(nSalEst,cPicB9SL)
					If !lGraph
						FmtLin(@aDados,aL[19],,,@Li)
					Else
						FmtLinR4(oReport,@aDados,aL[19],,,@Li)
					Endif	
					nEntDay:=nSaiDay:=nValEntDay:=nValSaiDay:=nIpiEntDay:=nIpiSaiDay:=0
					If Li > 56
						If !lGraph
							While Li < 60
								FmtLin(@aDados,aL[19],,,@Li)
								If Li == 60
									FmtLin(,aL[01],,,@Li)
								EndIf
							EndDo
						Else
							While Li < 60
								FmtLinR4(oReport,@aDados,aL[19],,,@Li)
								If Li == 60
									FmtLinR4(oReport,,aL[01],,,@Li)
								EndIf
							EndDo			
							oReport:EndPage()
						EndIf
					Else	
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf
					EndIf
				EndIf
	
				// Total do Periodo
				If ((!lVEIC) .And. cProd <> TRB->PRODUTO) .Or. (lVEIC .And. cCODITE <> TRB->CODITE) ;
					.Or. cPer <> TRB->PERIODO .Or. If(lCusUnif,.F.,TRB->LOCAL <> cLocalAnt)
			
					If lImpr
						If li > 56
							aDados:=Array(14)
							R470Cabec( @Li, @nPaginas, aInfoCabec, lGraph, oReport, aFilsCalc[ nForFilial, 3 ] )
						EndIf
						aDados:=Array(14)
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf
						aDados[06]:=STR0026	//"Total do Periodo:"
						aDados[08]:=" E "
						aDados[10]:=Transform(nEntPer,cPicD1Qt)
						aDados[11]:=Transform(nValEntPer,"@E 999,999,999,999.99")
						aDados[12]:=Transform(nIPIEntPer,"@E 999,999,999,999.99")
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf
						aDados[08]:=" S "
						aDados[10]:=Transform(nSaiPer,cPicD1Qt)
						aDados[11]:=Transform(nValSaiPer,"@E 999,999,999,999.99")
						aDados[12]:=Transform(nIPISaiPer,"@E 999,999,999,999.99")
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
						EndIf
						aDados:=Array(14)
						aDados[08]:=IIf(cPaisLoc=="BRA","EST","STK")
						aDados[13]:=Transform(nSalEst,cPicB9SL)
						If !lGraph
							FmtLin(@aDados,aL[19],,,@Li)
							While Li < 60
								FmtLin(@aDados,aL[19],,,@Li)
								If Li == 60
									FmtLin(,aL[01],,,@Li)
								EndIf
							End
						Else
							FmtLinR4(oReport,@aDados,aL[19],,,@Li)
							While Li < 60
								FmtLinR4(oReport,@aDados,aL[19],,,@Li)
								If Li == 60
									FmtLinR4(oReport,,aL[01],,,@Li)
								EndIf
							End			
							oReport:EndPage()
						EndIf
					EndIf
	
					If cProd <> TRB->PRODUTO .Or. If(lCusUnif,.F.,TRB->LOCAL <> cLocalAnt)
						lMudaIni := .T.					
					Else
						lMudaIni := .F.
					EndIf
	
					lFirst1 := .T.
					
					// Procurar Totais do Produto no aSalEst
					nPos := aScan(aSalEst,{|x| x[1] == If(lCusUnif,cProd,cProd+cLocalAnt)})
					If nPos == 0
						AADD(aSalEst,{If(lCusUnif,cProd,cProd+cLocalAnt),nSalEst})
					Else
						// Grava Saldos do Produto Totalizado no Periodo no aSalEst
						aSalEst[nPos,2]:=nSalEst
					EndIf
			
					nEntDay:=nSaiDay:=nValEntDay:=nValSaiDay:=nIpiEntDay:=nIpiSaiDay:=0
					nEntPer:=nSaiPer:=nValEntPer:=nValSaiPer:=nIpiEntPer:=nIpiSaiPer:=nSalEst:=0
			
					// Procura Saldos Iniciais do Proximo Produto no aSalEst
					nPos := aScan(aSalEst,{|x| x[1] == If(lCusUnif,TRB->PRODUTO,TRB->PRODUTO+TRB->LOCAL)})
					If nPos > 0
						If mv_par19 == 2 .And. 	cPer <> TRB->PERIODO
							nPaginas:= IIf(mv_par12<=1,2,mv_par12)
						EndIf
						nSalEst := aSalEst[nPos,2]
					EndIf
				EndIf
			EndDo

		EndIf
			
		dbSelectArea("SB1")
		dbClearFilter()
		If !Empty(cArq1) .And. File(cArq1 + OrdBagExt())
			RetIndex('SB1')
			FERASE(cArq1 + OrdBagExt())
		EndIf
		dbSetOrder(1)
		dbSelectArea("SB2")
		dbSetOrder(1)
		
		dbSelectArea("SD1")
		If lCusUnif
			RetIndex("SD1")
			Ferase(cTrbSD1+OrdBagExt())
		EndIf
		dbSetOrder(1)

		dbSelectArea("SD2")
		If lCusUnif
			RetIndex("SD2")
			Ferase(cTrbSD1+OrdBagExt())
		EndIf
		dbSetOrder(1)

		dbSelectArea("SD3")
		If lCusUnif
			RetIndex("SD3")
			Ferase(cTrbSD1+OrdBagExt())
		EndIf
		dbSetOrder(1)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao de Termos Abertura e Encerramento                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If lImpTermos // Impressao dos Termos
			cArqAbert:=GetMv("MV_LMOD3AB")
			cArqEncer:=GetMv("MV_LMOD3EN")
			
			If !lGraph
				XFIS_IMPTERM(cArqAbert,cArqEncer,cPerg,aDriver[4])
		    Else
				dbSelectArea("SM0")
				aVariaveis:={}
			
				For i:=1 to FCount()
					If FieldName(i)=="M0_CGC"
						AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
					Else
						If FieldName(i)=="M0_NOME"
							Loop
						EndIf
						AADD(aVariaveis,{FieldName(i),FieldGet(i)})
					EndIf
				Next
			
				dbSelectArea("SX1")
				dbSeek(PADR("MTR470",nTamSX1)+"01")
			
				While SX1->X1_GRUPO==PADR("MTR470",nTamSX1)
					AADD(aVariaveis,{Rtrim(Upper(X1_VAR01)),&(X1_VAR01)})
					dbSkip()
				EndDo
				
				dbSelectArea( "CVB" )
				CVB->(dbSeek( xFilial( "CVB" ) ))
				For i:=1 to FCount()
					If FieldName(i)=="CVB_CGC"
						AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 99.999.999/9999-99")})
					ElseIf FieldName(i)=="CVB_CPF"
						AADD(aVariaveis,{FieldName(i),Transform(FieldGet(i),"@R 999.999.999-99")})
					Else
						AADD(aVariaveis,{FieldName(i),FieldGet(i)})
					Endif
				Next
			
				AADD(aVariaveis,{"M_DIA",StrZero(Day(dDataBase),2)})
				AADD(aVariaveis,{"M_MES",MesExtenso()})
				AADD(aVariaveis,{"M_ANO",StrZero(Year(dDataBase),4)})
			
				cDriver:=aDriver[4]
			    oReport:HideHeader()
				If cArqAbert#NIL
					oReport:EndPage()
					ImpTerm(cArqAbert,aVariaveis,&cDriver,,,.T.,oReport)
				EndIf
			
				If cArqEncer#NIL
					oReport:EndPage()
					ImpTerm(cArqEncer,aVariaveis,&cDriver,,,.T.,oReport)
				EndIf
		    EndIf
		EndIf
		If lGraph
			oReport:EndPage()
		EndIf

		//-- Apaga o arquivo de trabalho temporario
        If mv_par23==2 .Or.;
          (mv_par23==1 .And. IIf(Len(aFilsCalc)==nForFilial,.T.,cChave<>aFilsCalc[nForFilial+1,4]+aFilsCalc[nForFilial+1,5]))
			FWCLOSETEMP(cArqTrab1)
			
			If Select("TRB") > 0	
				dbSelectArea("TRB")
				dbCloseArea()
			EndIf

			Ferase(Left(cArqTrab1,7)+"I"+OrdBagExt())
			If nOrd > 1
				Ferase(cArqTrab2+OrdBagExt())
			EndIf
	    EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Fecha alias em uso                                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !lCusUnif .And. Select( cAliasSB2 ) > 0
			dbSelectArea( cAliasSB2 )
			dbCloseArea()
		EndIf
		If Select( cAliasTop ) > 0
			dbSelectArea( cAliasTop )
			dbCloseArea()
		EndIf
		If Select( cAliasSD1 ) > 0
			dbSelectArea( cAliasSD1 )
			dbCloseArea()
		EndIf
		If Select( cAliasSD2 ) > 0
			dbSelectArea( cAliasSD2 )
			dbCloseArea()
		EndIf
		If Select( cAliasSD3 ) > 0
			dbSelectArea( cAliasSD3 )
			dbCloseArea()
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Atualiza o log de processamento			    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ProcLogAtu("MENSAGEM",STR0044 + cFilAnt ,STR0044 + cFilAnt) //"Termino da Impressao do relatorio - Filial : ## "
	
	EndIf

Next nForFilial

// Restaura filial original apos processamento
cFilAnt := cFilBack 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento			    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("MENSAGEM",STR0045,STR0045) //"Processamento Encerrado"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza o log de processamento   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcLogAtu("FIM")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura Ambiente                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lGraph
	If aReturn[5] = 1
		Set Printer TO
		dbCommitAll()
		ourspool(wnrel)
	EndIf

	MS_FLUSH()
EndIf	

RETURN
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ R470Cabec³ Autor ³ Gilson do Nascimento  ³ Data ³ 16.09.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Cabecalho do Relatorio do Kardex,     Registro Modelo 3    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function R470Cabec( Li, nPaginas, aInfoCabec, lGraph, oReport, cFilNome )
Local cPeriodo
Local cPicCgc

DEFAULT aInfoCabec:={}
DEFAULT lGraph := .F.

If (cPaisLoc=="BRA")
	cPicCgc:="@R 99.999.999/9999-99"
Else
	cPicCgc:=PesqPict("SA1","A1_CGC")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Reinicia a Numeracao das Paginas por feixe                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPaginas >= nQuebra .And. mv_par21 == 1 .And. mv_par19 == 1
	nPaginas := IIf(mv_par12<=1,2,mv_par12)
Endif

If Li <= 60
	If !lGraph
		While Li<60
			FmtLin(@aDados,aL[19],,,@Li)
		End
		FmtLin(,aL[01],,,@Li)
	Else
		While Li<60
			FmtLinR4(oReport,@aDados,aL[19],,,@Li)
		End
		FmtLinR4(oReport,,aL[01],,,@Li)		
	EndIf
EndIf
Li:=00
If Len(aInfocabec) = 0
	cPeriodo:=Right(TRB->PERIODO,2)+"/"+Left(TRB->PERIODO,4)
Else
	cPeriodo:=Right(aInfoCabec[5],2)+"/"+Left(aInfoCabec[5],4)
EndIf
If !lGraph
	@ Li++,000 PSAY AvalImp(220)
	FmtLin(,{aL[01],aL[02],aL[03]},,,@Li)
	FmtLin({SM0->M0_NOMECOM,IIf(mv_par23==1,'',cFilNome)},aL[04],,,@Li)
	FmtLin(,aL[05],,,@Li)
	FmtLin({InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@Li)
	FmtLin(,aL[07],,,@Li)
	FmtLin({Transform(StrZero(nPaginas,6),"@R 999.999"),cPeriodo},aL[08],,,@Li)
	FmtLin(,aL[09],,,@Li)
Else
	oReport:EndPage()
	FmtLinR4(oReport,,'',,,@Li)
	FmtLinR4(oReport,,{aL[01],aL[02],aL[03]},,,@Li)
	FmtLinR4(oReport,{SM0->M0_NOMECOM,IIf(mv_par23==1,'',cFilNome)},aL[04],,,@Li)
	FmtLinR4(oReport,,aL[05],,,@Li)
	FmtLinR4(oReport,{InscrEst(),Transform(SM0->M0_CGC,cPicCgc)},aL[06],,,@Li)
	FmtLinR4(oReport,,aL[07],,,@Li)
	FmtLinR4(oReport,{Transform(StrZero(nPaginas,6),"@R 999.999"),cPeriodo},aL[08],,,@Li)
	FmtLinR4(oReport,,aL[09],,,@Li)
EndIf
If Len(aInfocabec) = 0
	If ! lVEIC
		If !lGraph
			FmtLin(;
			{ TRB->PRODUTO+" - "+SUBS(TRB->DESCRICAO,1,30),;
			  TRB->UM,;
			  TRB->POSIPI,;
			  If(lCusUnif,"",TRB->LOCAL);
			};
			,aL[10],;
			,;
			,@Li;
			)
		Else
			FmtLinR4(oReport,;
			{ TRB->PRODUTO+" - "+SUBS(TRB->DESCRICAO,1,30),;
			  TRB->UM,;
			  TRB->POSIPI,;
			  If(lCusUnif,"",TRB->LOCAL);
			};
			,aL[10],;
			,;
			,@Li;
			)
		EndIf	
	Else
		If !lGraph
			FmtLin(;
			{ TRB->CODITE+ " -" +TRB->PRODUTO+"-"+SUBS(TRB->DESCRICAO,1,30),;
			  TRB->UM,;
			  TRB->POSIPI,;
			  If(lCusUnif,"",TRB->LOCAL);
			};
			,aL[10],;
			,;
			,@Li;
			)
		Else
			FmtLinR4(oReport,;
			{ TRB->CODITE+ " -" +TRB->PRODUTO+"-"+SUBS(TRB->DESCRICAO,1,30),;
			  TRB->UM,;
			  TRB->POSIPI,;
			  If(lCusUnif,"",TRB->LOCAL);
			};
			,aL[10],;
			,;
			,@Li;
			)
		EndIf	
	EndIf
Else
	If !lGraph
		FmtLin(aInfoCabec,aL[10],,,@Li)
	Else
		FmtLinR4(oReport,aInfoCabec,aL[10],,,@Li)
	EndIf	
EndIf
If !lGraph
	FmtLin(,{aL[11],aL[12],aL[13],aL[14],aL[15],aL[16],aL[17],aL[18]},,,@Li)
Else
	FmtLinR4(oReport,,{aL[11],aL[12],aL[13],aL[14],aL[15],aL[16],aL[17],aL[18]},,,@Li)
EndIf	

NovaPg(@nPaginas,nQuebra)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MTR470VAlm ³ Autor ³Rodrigo de A. Sartorio ³ Data ³26/06/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Valida Almoxarifado do KARDEX com relacao a custo unificado ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
USER Function MTR470VAlm
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
Local lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

If lCusUnif .And. AllTrim(cConteudo) != cALL_LOC
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten‡„o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³M470NoCFOP ³ Autor ³Robson Sales           ³ Data ³27/11/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Tratamento para string contendo CFOP's a desconsiderar      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function M470NoCFOP(cContent)
Local cRet	:=	""
Local nX	:=	0

If Len( cContent ) > 0 
	
	//Inserindo aspas e virgulas para a query
	cRet := "'"	

	For nX := 1 To Len( cContent )
		If SubStr( cContent , nX , 1 ) $ ";,-_|./" 				 
  	   		cRet += "','"
		Else                                                               
  	   		cRet += SubStr( cContent , nX , 1 )        
		Endif
  	Next	
	
	cRet += "'"	
Endif

Return cRet
