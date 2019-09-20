#Include "PROTHEUS.CH"
#Include "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ RELISTCOB  ³ Autor ³ Flavio Dias         ³ Data ³13/06/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emissão da relatório de listas de cobrança de acordo com   ³±±
±±³a lista gerada                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RELISTCOB(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Cantu                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function RELISTCOB()

Local oReport   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If FindFunction("TRepInUse")
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Interface de impressao                                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport := ReportDef()
	oReport:PrintDialog()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³Autor  ³Alexandre Inacio Lemes ³Data  ³19.05.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da rela‡„o de amarracao Produto X Fornecedor       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport 
Local oSection 
Local oCell
Local bPend := ({|| iif(ZZJ->ZZJ_STATUS == "01", 1, 0)})
Local bEfet := ({|| iif(ZZJ->ZZJ_STATUS == "02", 1, 0)})
Local bProrog := ({|| iif(ZZJ->ZZJ_STATUS == "03", 1, 0)})
Local bCanc := ({|| iif(ZZJ->ZZJ_STATUS == "04", 1, 0)})
Local bReag := ({|| iif(ZZJ->ZZJ_STATUS == "05", 1, 0)})
Local bNAtend := ({|| iif(ZZJ->ZZJ_STATUS == "06", 1, 0)})

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
oReport := TReport():New("RELISTCOB","Lista de cobrança","RELISTCOB", {|oReport| ReportPrint(oReport)},;
			"Relação de listas de cobrança"+" "+"Será impresso o relatório de listas de cobrança de modo sintético ou analítico") //"Relacao de Amarracao Produtos x Fornecedor"##"Este programa tem como objetivo , relacionar os produtos e seus"##"respectivos Fornecedores."
AjustPerg("RELISTCOB")
Pergunte("RELISTCOB",.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection := TRSection():New(oReport,"Cabeçalho da Cobrança",{"ZZI"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/) //"Carga"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oSection:SetHeaderPage()

TRCell():New(oSection,"ZZI_CODIGO","ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_NOMELI"   ,"ZZI",/*Titulo*/,/*Picture*/,,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_STATUS"   ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_USUARI"  ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oSection,"ZZI_DATAAT"   ,"ZZI",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

//oSection:SetNoFilter("ZZI")

oClientes := TRSection():New(oSection,"Clientes da Cobrança",{"ZZJ"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oClientes,"ZZJ_SEQUEN","ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_CODCLI"   ,"ZZJ",/*Titulo*/,/*Picture*/, ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_LOJCLI"   ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_NOMECL"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_SALDO"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_STATUS"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_DATAAT"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_DATAPR"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oClientes,"ZZJ_USUARI"  ,"ZZJ",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

// Faz os totalizadores
TRFunction():New(oClientes:Cell("ZZJ_SALDO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)

// Faz o cálculo dos atendimentos
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Pendentes",/*cPicture*/,bPend,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Efetuados",/*cPicture*/,bEfet,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Prorogados",/*cPicture*/,bProrog,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Cancelados",/*cPicture*/,bCanc,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Reagendados",/*cPicture*/,bReag,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"SUM",/*oBreak*/,"Não Atendidos",/*cPicture*/,bNAtend,.T./*lEndSection*/,.T./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oClientes:Cell("ZZJ_STATUS"),/* cID */,"COUNT",/*oBreak*/,"Total Atendimentos",/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)

oCliObs  := TRSection():New(oClientes,"Observação da Cobrança",{"SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
// Não imprime o cabeçalho
oCliObs:SetHeaderBreak(.F.)

TRCell():New(oCliObs,"A1_X_OBCOB"  ,"SA1",/*Titulo*/,/*Picture*/,200,.F.,/*{|| code-block de impressao }*/)


oTitulos := TRSection():New(oClientes,"Títulos do cliente",{""},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)
TRCell():New(oTitulos,"E1_MSEMP","SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_FILIAL"   ,"SE1TMP",/*Titulo*/,/*Picture*/, ,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_TIPO"   ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_PREFIXO"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_NUM"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_PARCELA"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"DEMISSAO"  ,"    ","Emissao",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dEmissao })
TRCell():New(oTitulos,"DVENCTO"   ,"    ","Vencimento",/*Picture*/,/*Tamanho*/,/*lPixel*/,{|| dVencto })
TRCell():New(oTitulos,"E1_SITUACA"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_X_SCOBR"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)
TRCell():New(oTitulos,"E1_SALDO"  ,"SE1TMP",/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*{|| code-block de impressao }*/)

oTitulos:Cell("E1_SITUACA"):SetCBox("0=Carteira;1=Cob.Simples;2=Descontada;3=Caucionada;4=Vinculada;5=Advogado;6=Judicial;7=Cob Caucao Descont")

// Cálculo do valor total dos títulos
TRFunction():New(oTitulos:Cell("E1_SALDO"),/* cID */,"SUM",/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.T./*lEndReport*/,.F.)
// E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_VENCTO, E1_SITUACA, E1_X_SCOBR, E1_SALDO


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³Autor  ³Alexandre Inacio Lemes ³Data  ³19/05/2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o Relatorio definido pela funcao ReportDef MATR190. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport)

Local oSection  := oReport:Section(1)
Local oCliente  := oSection:Section(1)
Local oCliObs   := oCliente:Section(1)
Local oTitulo   := oCliente:Section(2)
Local cCodLista  := ""


#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

Private dEmissao := dDataBase
Private dVencto := dDataBase

// Faz o cálculo dos valores dos títulos em aberto


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("ZZI")
dbSetOrder(2)
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Transforma parametros Range em expressao SQL                            ³	
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MakeSqlExpr(oReport:uParam)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):BeginQuery()	
	
	cAliasZZI := GetNextAlias()
	
	BeginSql Alias cAliasZZI
	SELECT ZZI_CODIGO, ZZI_NOMELI, ZZI_STATUS, ZZI_USUARI, ZZI_DATAAT
	FROM %table:ZZI% ZZI
	WHERE 	ZZI_CODIGO >= %Exp:mv_par01% AND 
			ZZI_CODIGO <= %Exp:mv_par02% AND 
			LOWER(ZZI_USUARI) >= %Exp:Lower(mv_par03)% AND 
			LOWER(ZZI_USUARI) <= %Exp:Lower(mv_par04)% AND
			ZZI.%notDel%
		
	ORDER BY %Order:ZZI% 
			
	EndSql 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Metodo EndQuery ( Classe TRSection )                                    ³
	//³                                                                        ³
	//³Prepara o relatório para executar o Embedded SQL.                       ³
	//³                                                                        ³
	//³ExpA1 : Array com os parametros do tipo Range                           ³
	//³                                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
#ENDIF		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Metodo TrPosition()                                                     ³
//³                                                                        ³
//³Posiciona em um registro de uma outra tabela. O posicionamento será     ³
//³realizado antes da impressao de cada linha do relatório.                ³
//³                                                                        ³
//³                                                                        ³
//³ExpO1 : Objeto Report da Secao                                          ³
//³ExpC2 : Alias da Tabela                                                 ³
//³ExpX3 : Ordem ou NickName de pesquisa                                   ³
//³ExpX4 : String ou Bloco de código para pesquisa. A string será macroexe-³
//³        cutada.                                                         ³
//³                                                                        ³				
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRPosition():New(oSection,"ZZI",2,{|| xFilial("ZZI") + (cAliasZZI)->ZZI_CODIGO})
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SE1->(dbSetOrder(01))
SA1->(dbSetOrder(01))

oReport:SetMeter(ZZI->(LastRec()))

oSection:Init()

dbSelectArea(cAliasZZI)
While !oReport:Cancel() .And. !(cAliasZZI)->(Eof())

	If oReport:Cancel()
		Exit
	EndIf
    
	oSection:PrintLine()
	ZZJ->(dbSetOrder(01))
	ZZJ->(dbSeek(xFilial("ZZJ") + (cAliasZZI)->ZZI_CODIGO))	
	
	oCliente:Init()
	While ZZJ->ZZJ_FILIAL + ZZJ->ZZJ_CODLIS == xFilial("ZZJ") + (cAliasZZI)->ZZI_CODIGO	
		
		If !( ZZJ->ZZJ_DATAAT >= mv_par08 .and. ZZJ->ZZJ_DATAAT <= mv_par09 .and. ZZJ->ZZJ_CODCLI >= mv_par10 .and.  ZZJ->ZZJ_CODCLI <= mv_par11 )
			ZZJ->(dbSkip())
			Loop
		EndIf
		
		oCliente:PrintLine()
		
		// Faz a impressão dos dados de cobrança
		If (MV_PAR06 == 1)
			oCliObs:Init()
			
			SA1->(dbSeek(xFilial("SA1") + ZZJ->ZZJ_CODCLI+ZZJ->ZZJ_LOJCLI))
			oCliObs:PrintLine()
			
			oCliObs:Finish()
		EndIf
		
		// Avalia se deve imprimir os títulos
		if mv_par05 == 1

			// Impressão dos títulos
			oTitulo:Init()
			TitCliente(ZZJ->ZZJ_CODCLI, ZZJ->ZZJ_LOJCLI)
			
			// Faz o controle de impressão do dos títulos
			While SE1TMP->(!Eof())
				dEmissao := StoD(SE1TMP->E1_EMISSAO)
				dVencto  := StoD(SE1TMP->E1_VENCTO)
				oTitulo:PrintLine()	
				
				SE1TMP->(dbSkip())
			EndDo
			
			oTitulo:Finish()
			
			SE1TMP->(dbCloseArea())
			
		EndIf
		
		If (mv_par06 == 1)
			oReport:ThinLine() 
			oReport:SkipLine()
			// oReport:FatLine()
		EndIf
		
		ZZJ->(dbSkip())
		
	EndDo
	oCliente:Finish()
    
	oReport:IncMeter()
	
	// Imprime uma linha para dividir antes de vir a próxima lista de cobrança
	oReport:FatLine()
	
	DbSelectArea(cAliasZZI)
	DbSkip()
EndDo

(cAliasZZI)->(DbCloseArea())

oSection:Finish()

Return NIL

// Faz o ajuste das perguntas
Static Function AjustPerg(cPerg)
PutSx1(cPerg,"01","Lista de ?","Lista de ?","Lista de  ?", "mv_lde", "C", 6, 0, ,"G", "", "ZZI", "", "","MV_PAR01")
PutSx1(cPerg,"02","Lista ate ?","Lista ate ?","Lista ate  ?", "mv_lat", "C", 6, 0, ,"G", "", "ZZI", "", "","MV_PAR02")
PutSx1(cPerg,"03","Usuario de ?","Usuario de ?","Usuario de  ?", "mv_ude", "C", 15, 0, ,"G", "", "US3", "", "","MV_PAR03")
PutSx1(cPerg,"04","Usuario ate ?","Usuario ate ?","Usuario ate  ?", "mv_uat", "C", 15, 0, ,"G", "", "US3", "", "","MV_PAR04")
PutSx1(cPerg,"05","Imprimir Titulos ?","Imprimir Titulos ?","Imprimir Titulos  ?", "mv_iti", "N", 1, 0, ,"C", "", "", "", "","MV_PAR05","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"06","Imprimir Observação ?","Imprimir Observação ?","Imprimir Observação ?", "mv_iob", "N", 1, 0, ,"C", "", "", "", "","MV_PAR06","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"07","Baixas retroativas ?","Baixas retroativas ?","Baixas retroativas ?", "mv_pre", "N", 1, 0, ,"C", "", "", "", "","MV_PAR07","Sim","Sim","Sim", "","Nao","Nao","Nao")
PutSx1(cPerg,"08","Atendimento de ?","Atendimento de ?","Atendimento de  ?", "mv_lde", "D", 6, 0, ,"G", "", "", "", "","MV_PAR08")
PutSx1(cPerg,"09","Atendimento ate ?","Atendimento ate ?","Atendimento ate  ?", "mv_lat", "D", 6, 0, ,"G", "", "", "", "","MV_PAR09")
PutSx1(cPerg,"10","Cliente de ?","Cliente de ?","Cliente de  ?", "mv_lde", "C", 6, 0, ,"G", "", "SA1", "", "","MV_PAR10")
PutSx1(cPerg,"11","Cliente ate ?","Cliente ate ?","Cliente ate  ?", "mv_lat", "C", 6, 0, ,"G", "", "SA1", "", "","MV_PAR11")

Return

// Títulos do Cliente
// Busca com posição retroativa na data do atendimento da lista ou data atual
Static Function TitCliente(cCod, cLoja)
Local aEmps := {"30", "31", "50", "60", "70"}
Local nX
Local cSql:= ""
//For nX := 1 to len(aEmps)

	//cSql += iif(Empty(cSql), "", " UNION ")
  cSql += "SELECT '" + SubStr(retSqlName("SE1"),4,2) + "' AS E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, 
  cSql += " E1_VENCTO, E1_SITUACA, E1_X_SCOBR, E1_SALDO FROM " + retSqlName("SE1") + " WHERE "
  if (MV_PAR07 == 1)
	  cSql += "(E1_SALDO > 0 OR E1_BAIXA > '" + dToS(Iif(Empty(ZZI->ZZI_DATAAT), date() - 1, ZZI->ZZI_DATAAT - 1)) + "') "
	Else
		cSql += " E1_SALDO > 0 "
	EndIf
  cSql += " AND D_E_L_E_T_ <> '*' AND E1_CLIENTE = '" +cCod + "' AND E1_LOJA = '" + cLoja + "' "
  cSql += " AND E1_VENCREA <= '" + dToS(Iif(Empty(ZZI->ZZI_DATAAT), date() - 1, ZZI->ZZI_DATAAT - 1)) + "' "
  
//Next

TcQuery cSql New Alias "SE1TMP"

Return