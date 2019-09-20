#INCLUDE "FIVEWIN.CH"
#INCLUDE "GPER400.CH"
#INCLUDE "report.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER400  ³ Autor ³ R.H. - Marcos Stiefano      ³ Data ³ 25.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Programacao de Ferias                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GPER400(void)                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data     ³ BOPS/FNC ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Natie       ³10/05/2001³----------³ Consid.Faltas Cad.Provisao no Per.Aquisit³±±
±±³Emerson     ³30/05/2001³----------³ Ajustes p/impr.do relatorio de acordo com³±± 
±±³            ³          ³----------³ as novas datas de ferias programadas.    ³±± 
±±³Emerson     ³07/06/2001³----------³ Estava impr. func. com fer.prog. enquanto³±± 
±±³            ³          ³----------³ que na selecao definia para nao imprimir.³±± 
±±³Emerson     ³13/06/2001³----------³ Tratar cpos de dias de Ferias Programadas³±±
±±³Natie       ³04/10/2001³009578    ³ Abono Pecuniario- Proporc.Dias de Faltas ³±± 
±±³Andreia     ³04/01/2002³011341    ³ Alteracao do layout.                     ³±± 
±±³Natie       ³25/02/2002³F0C336    ³ Acerto Imprs.dt limite qdo usa-se 4 dig. ³±± 
±±³Natie       ³17/04/2002³----------³ Traducao pergunta                        ³±± 
±±³Natie       ³17/04/2002³----------³ Acerto Impr.Abono Pec. e dt fim ferias   ³±± 
±±³Emerson     ³11/06/2002³----------³ Incl. funcao fTab_Fer p/ calculo Ferias. ³±±
±±³Mauro       ³24/07/2002³----------³ Abater dias Antec. da ferias Prop. quando³±±
±±³            ³          ³----------³ nao houver ferias venciadas.             ³±±
±±³Emerson     ³02/09/2002³----------³ Exclusao da funcao ValidPerg().          ³±±
±±³Emerson     ³05/05/2004³----------³ Inicializar aCodFol p/ nao ser carregada ³±±
±±³            ³          ³----------³ em Calc_Fer() a cada funcionario.        ³±±
±±³Pedro Eloy  ³31/08/2005³----------³ Tratado quando o campo de provisao estiver±±
±±³            ³          ³----------³ preenchido data 1 prov.                  ³±±
±±³Natie       ³10/11/2005³086440    ³ Ajuste na proporcional.dias abono c/falta³±±
±±³Ricardo D.  ³12/01/2006³090657    ³ Ajuste na impressao dos dias de ferias do³±±
±±³            ³          ³----------³ 1o periodo, abatendo os dias de abono qdo³±±
±±³            ³          ³----------³ as ferias forem gozadas de uma so vez.   ³±±
±±³Natie       ³17/07/2006³100161    ³ Relatorio personalizavel                 ³±±
±±³Natie       ³12/10/2006³100161    ³ Ajuste Relatorio personalizavel          ³±±
±±³Natie       ³08/02/2007³117577    ³ Ajuste na descricao do C.custo p/filial  ³±±
±±³Luiz Gustavo³24/01/2007³          ³Retiradas funcoes de ajuste de dicionario ³±±
±±³Silvia      ³19/04/2007³          ³Acerto no Alias utilizado                 ³±±
±±³Renata E.   ³30/03/2009³01378/2009³ Ajuste na paginacao do periodo aquisitivo³±±
±±³            ³          ³          ³ para considerar perda/novo periodo por   ³±±
±±³            ³          ³          ³ afastamento.							    ³±±
±±³Renata E.   ³06/08/2009³19604/2009³ Incluido no calc_fer o retorno do fim do ³±±
±±³            ³          ³          ³ periodo aquisitivo.					    ³±±
±±³Alex        ³06/08/2009³----------³Ajuste no Grupo de Campos filial          ³±±
±±³            ³          ³          ³tratamento para não considerar 2 posições ³±±
±±³            ³          ³          ³fixas.                                    ³±±
±±³Marcelo     ³26/01/2010³01312/2010³Ajuste em fAdicFiltro para considerar o   ³±±
±±³            ³          ³          ³filtro personalizado do usuario.          ³±±
±±³Allyson M.  ³15/03/2010³02179/2010³Ajuste p/ que a rotina verifique se ha    ³±±
±±³            ³          ³          ³ferias vencidas e ajustar Dt Lim. Max. p/ ³±±
±±³            ³          ³          ³o periodo vigente se houver dias vencidos.³±±
±±³Marcelo     ³26/07/2010³15492/2010³Correcao na impressao da data Lim. Maxima.³±± 
±±³Luciana     ³14/09/2010³19354/2010³Criacao do Relatorio de Programacao de    ³±±
±±³            ³          ³          ³Recesso utilizado apenas para Estagiarios.³±±
±±³Luis Ricardo³26/10/2010³23394/2010³Ajuste no grupo de perguntas GP400R do R4 ³±±
±±³Cinalli     ³		  ³			 ³devido a criacao indevida do parametro	³±±
±±³			   ³		  ³			 ³IMPRIME PERIODO AQUISITIVO.				³±±
±±³Mauricio MR ³10/03/2011³05361/2011³Ajuste no grupo de perguntas GP400R do R4 ³±±
±±³            ³		  ³			 ³para criar a pergunta '12' na ausencia da ³±±
±±³			   ³		  ³			 ³pergunta '13' tratada na alteracao ante-  ³±±
±±³			   ³		  ³			 ³rior.										³±±
±±³Mauricio MR ³30/06/2011³14332/2011³Ajuste para nao descontar as ferias ante- ³±±
±±³            ³		  ³			 ³cipadas das ferias vencidas para 2/3 pe-  ³±±
±±³			   ³		  ³			 ³riodos.									³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RGPE400() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cString 	:= "SRA"        // alias do arquivo principal (Base)
Local aOrd    	:= {STR0001,STR0002,STR0016,STR0017,STR0018,STR0019,'Segmento+CentroCusto'}//"Centro de Custo"###"Matricula"###"Nome"###"C.Custo + Nome"###"Filial + Dt.Base"###"Filial + Dt.Inicio"
Local cDesc1  	:= STR0003	//"Rela‡„o de Programa‡„o de F‚rias."
Local cDesc2  	:= STR0004	//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3  	:= STR0005	//"usuario."
Local aGetArea	:= getArea()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {STR0006,1,STR0007,2,2,1,"",1 }	//"Zebrado"###"Administra‡„o"
Private NomeProg := "GPER400"
Private aLinha   := { }
Private nLastKey := 0
Private cPerg    := "GPR400"
Private cIndCond

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private Titulo   := STR0008	//"RELA€O DE PROGRAMA€O DE FRIAS"
Private AT_PRG   := "GPER400"
Private Wcabec0  := 2
Private Wcabec1  := STR0009	//"                                                                       DATA       DTA.BASE           P E R I O D O         DT.LIMITE    DT.LIMITE     FERIAS    FALTAS     FERIAS     FALTAS     TOTAL    1a PARCELA 13o"
Private Wcabec2  := STR0010	//"FIL   CENTRO DE CUSTO   MATRICULA   NOME FUNCIONARIO                 ADMISSAO      FERIAS         A Q U I S I T I V O        IDEAL        MAXIMA     VENCIDAS   VENCIDAS   PROPORC.   PROPROC.   FERIAS        %%"
Private CONTFL   := 1
Private LI       := 0
Private nTamanho := "G"
Private	cString		:= "SRA"				// alias do arquivo principal (Base)
Private cTitulo		:= OemToAnsi(STR0003)
Private cAliasSRA	:= "SRA"
Private cAliasSRF	:= "SRF"   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


AjustaSX1(cPerg)
/*
                                                                 DATA       DTA.BASE       P E R I O D O       DT.LIMITE   DT.LIMITE     FERIAS    FALTAS    FERIAS    FALTAS   TOTAL   13o SAL.
 FIL   CENTRO CUSTO   MAT.     NOME DO FUNCIONARIO              ADMISSAO     FERIAS     A Q U I S I T I V O      IDEAL       MAXIMA     VENCIDAS  VENCIDAS  PROPORC.  PROPROC.  FERIAS   PERC.    ASSINATURA DO FUNCIONARIO
 --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*
          
 ***************************************************************************************************************************************************************************************************************************
 01    123456789      123456   123456789012345678901234567890  99/99/9999  99/99/9999  99/99/9999  99/99/9999  99/99/9999  99/99/9999    999.9     999.9     999.9     999.9     999.9    99.99
 ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                                                       1a -  P R O G R A M A C A O  D E  F E R I A S ______/______/______  A  ______/______/______  D.FER.|______|D.AB.|______|  ___________________________
                                                                       2a -  P R O G R A M A C A O  D E  F E R I A S ______/______/______  A  ______/______/______  D.FER.|______|D.AB.|______|  ___________________________
                                                                       3a -  P R O G R A M A C A O  D E  F E R I A S ______/______/______  A  ______/______/______  D.FER.|______|D.AB.|______|  ___________________________
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
*/

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte("GPR400",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER400"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,"G")

If nLastKey = 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| GP400Imp(@lEnd,wnRel,cString)},Titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fim do Relatorio                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RestArea( aGetArea )
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GP400IMP ³ Autor ³ R.H.                  ³ Data ³ 25.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ImpressÆo da Relacao de Programacao de Ferias              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GP400IMP(lEnd,WnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GP400IMP(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local FimPAqui    	:= ""
Local DFimPAqui   	:= ""
Local DPRPAqui    	:= ""
Local cAcessaSRA  	:= &("{ || " + ChkRH("GPER400","SRA","2") + "}")
Local cDescCC	  	:= ""
Local lTemCpoProg   
Local lUnicoPer		:= .F. 
Local dDtIProg1
Local dDtIProg2
Local dDtIProg3
Local nDiasFer1 	:= 0
Local nDiasFer2		:= 0
Local nDiasFer3		:= 0
Local nDiasAbo1		:= 0
Local nDiasAbo2		:= 0
Local nDiasAbo3		:= 0
Local nCnt1			:= 0  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Normal    	:= 0
Private Descanso  	:= 0
Private cPerFeAc  	:= If(cPaisLoc=="URU","S",GetMv("MV_FERPAC",,"N")) // Ferias por ano civil
Private aTabFer   	:= {}    			         						 // Tabela para calculo dos dias de ferias
Private aCodFol   	:= If(cPaisLoc=="BRA",ARRAY(1),{})		         // Incializada para nao ser carregada em Calc_Fer
Private cTafaFer  	:= GetMv("MV_TAFAFER" )      						 // Trata Perda de Periodo Para Afastados
Private dDtBasFim 	:= Ctod("")   
Private cXSEGME     := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica a existencia dos campos de programacao ferias no SRF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
lTemCpoProg 		:= fTCpoProg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem     := aReturn[8]
cFilDe     := mv_par01                          //  Filial De
cFilAte    := mv_par02                          //  Filial Ate
cCcDe      := mv_par03                          //  Centro de Custo De
cCcAte     := mv_par04                          //  Centro de Custo Ate
cMatDe     := mv_par05                          //  Matricula De
cMatAte    := mv_par06                          //  Matricula Ate
nTipo      := mv_par16
cSituacao  := mv_par07                       //  Situacao Funcionario
If nTipo == 1 
	cCategoria := mv_par08					//  Categoria Funcionario
Else
	cCategoria := "EG"						//  Categoria estagiario Horista e Mensalista
Endif
lSalta     := If( mv_par09 == 1 , .T. , .F. )   //  Salta Pagina Quebra C.Custo
cNomDe     := mv_par10                          //  Nome De
cNomAte    := mv_par11                          //  Nome Ate
nTipFerias := mv_par12                          //  1-Nao programadas, 2-Programadas e 3-Ambas
dProgDe    := mv_par13                          //  Data inicial para ferias programdas
dProgAte   := mv_par14                          //  Data Final   para ferias programdas
nPeriodo   := mv_par15							 // Imprimir 1 periodo, 2 periodos ou os 3 periodos	
cCLVLDe    := mv_par17
cCLVLAte   := mv_par18

If nTipo == 2
	nPeriodo   := 1		
	Titulo   := STR0051	//"RELA€O DE PROGRAMA€O DE RECESSO"
	Wcabec1  := STR0053	//"                                                                       DATA       DTA.BASE           P E R I O D O         DT.LIMITE    DT.LIMITE     FERIAS    FERIAS     TOTAL    1a PARCELA "
	Wcabec2  := STR0054	//"FIL   CENTRO DE CUSTO   MATRICULA   NOME FUNCIONARIO                 ADMISSAO      FERIAS         A Q U I S I T I V O        IDEAL        MAXIMA     VENCIDAS   PROPORC.   FERIAS        "
Endif

If nTipo ==1
	Titulo := STR0011+If(nOrdem==1,STR0012,If(nOrdem==2,STR0013,If(nOrdem==3,STR0020,If(nOrdem==4,STR0021,If(nOrdem==5,STR0022,STR0023))))) //"RELACAO DE PROGRAMACAO DE FERIAS "###"( C.CUSTO )"###"( MATRICULA )"###"( NOME )"###"( C.CUSTO + NOME )"###"( DATA BASE )"###"( DATA INICIO )"
Else
	Titulo := STR0051+If(nOrdem==1,STR0012,If(nOrdem==2,STR0013,If(nOrdem==3,STR0020,If(nOrdem==4,STR0021,If(nOrdem==5,STR0022,STR0023))))) //"RELACAO DE PROGRAMACAO DE FERIAS "###"( C.CUSTO )"###"( MATRICULA )"###"( NOME )"###"( C.CUSTO + NOME )"###"( DATA BASE )"###"( DATA INICIO )"
Endif

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 2 )
	dbSeek( cFilDe + cCcDe + cMatDe , .T. )
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder( 1 )
	dbSeek(cFilDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim     := cFilAte + cMatAte
ElseIf nOrdem == 3
	dbSetOrder( 3 )
	dbSeek(cFilDe + cNomDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim     := cFilAte + cNomAte + cMatAte
ElseIf nOrdem == 4
    dbSetOrder( 8 )
    dbSeek(cFilDe + cCcDe + cNomDe,.T.)
    cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
    cFim     := cFilAte + cCcAte + cNomAte
ElseIf nOrdem == 5
	dbSelectArea("SRF")
	cIndCond:= "SRF->RF_FILIAL + DTOS(SRF->RF_DATABAS)"
	cFor:= '(SRF->RF_FILIAL+SRF->RF_MAT >= "'+cFilDe+cMatDe+'")'
	cFor+= '.And. (SRF->RF_FILIAL+SRF->RF_MAT <= "'+cFilAte+cMatAte+'")'
	cInicio := "SRF->RF_FILIAL"
	cFim    := cFilAte
ElseIf nOrdem == 6
	dbSelectArea("SRF")
	cIndCond:= "SRF->RF_FILIAL + DTOS(SRF->RF_DATAINI)"
	cFor:= '(SRF->RF_FILIAL+SRF->RF_MAT >= "'+cFilDe+cMatDe+'")'
	cFor+= '.And. (SRF->RF_FILIAL+SRF->RF_MAT <= "'+cFilAte+cMatAte+'")'
	cInicio := "SRF->RF_FILIAL"
	cFim    := cFilAte
ElseIf nOrdem == 7
	DBOrderNickName("SEGCC")
	dbSeek(cFilDe + cCLVLDe + cCcDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_X_SEGME + SRA->RA_CC"
	cFim     := cFilAte + cCLVLAte + cCcAte
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice caso Impressao por Programa‡Æo de F‚rias ("SRF") ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡Æo de F‚rias
	dbSelectArea("SRF")
	cArqNtx  := CriaTrab(NIL,.f.)
	IndRegua("SRF",cArqNtx,cIndCond,,cFor,STR0024)	//"Selecionando Registros..."
	dbGoTop()
EndIf

If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡Æo de F‚rias
	dbSelectArea( "SRF" )
Else
	dbSelectArea( "SRA" )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua Processamento                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())

cFiAnt := Space(FWGETTAMFILIAL)
cCcAnt := space(20)

While !Eof() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua Processamento                                ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif

	If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡Æo de F‚rias
		dbSelectArea( "SRA" )
		dbSetOrder(1)
		dbSeek( SRF->RF_FILIAL + SRF->RF_MAT )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Testa Situacao do Funcionario na Folha                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
		If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡Æo de F‚rias
			dbSelectArea( "SRF" )
		EndIf
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametriza‡Æo do Intervalo de ImpressÆo            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	(SRA->RA_FILIAL < cFilDe) .Or. (SRA->RA_FILIAL > cFilAte) .Or. ;
		(SRA->RA_MAT    < cMatDe) .Or. (SRA->RA_MAT    > cMatAte) .Or. ;
		(SRA->RA_CC     < cCcDe)  .Or. (SRA->RA_CC     > cCcAte)  .Or. ;
        (SRA->RA_NOME   < cNomDe) .Or. (SRA->RA_NOME   > cNomAte) .Or. ;
        (SRA->RA_X_SEGME < cCLVLDe) .Or. (SRA->RA_X_SEGME > cCLVLAte)
        
		If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡ao de F‚rias
			dbSelectArea( "SRF")
		EndIf
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡ao de F‚rias
			dbSelectArea( "SRF")
		EndIf
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Carrega tabela para apuracao dos dias de ferias - aTabFer    |
	//| 1-Meses Periodo    2-Nro Periodos   3-Dias do Mes    4-Fator |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fTab_Fer(@aTabFer)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Nao Achou Registro no SRF Gera Automatico                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea( "SRF" )
	If nOrdem # 5 .And. nOrdem # 6
		If !dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			RecLock("SRF",.T.)
			SRF->RF_FILIAL := SRA->RA_FILIAL
			SRF->RF_MAT    := SRA->RA_MAT
			SRF->RF_DATABAS:= SRA->RA_ADMISSA
			MsUnlock()
		EndIf
	EndIf

	If nOrdem == 5 .Or. nOrdem == 6
		dbSelectArea( "SRF" )
	Else
		dbSelectArea( "SRA" )
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo dos Dias de Ferias Vencidas e a Vencer               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDiasVenc := nDiasProp := nDiasAbono := 0
	dDtBaseFer:=(cAliasSRF)->RF_DATABAS

	Calc_Fer(@dDtBaseFer,dDataBase,@nDiasVenc,@nDiasProp,,,@dDtBasFim,.F.,cTafaFer)

	If nDiasVenc > 0 .And. SRF->RF_DFERANT > 0
		nDiasVenc	:= Max(nDiasVenc - SRF->RF_DFERANT, 0)
	Elseif nDiasVenc == 0 .And. nDiasProp > 0 .And. SRF->RF_DFERANT > 0
		nDiasProp   :=  Max(nDiasProp - SRF->RF_DFERANT, 0)
	Endif
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo dias de ferias pela data de inicio das ferias progrmadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDiaVen	:= 0 												//Dias de Ferias qdo efetua programacao
	nDiaPro	:= 0    
	If ! Empty(SRF->RF_DATAINI)
		Calc_Fer(@dDtBaseFer,SRF->RF_DATAINI,@nDiaVen,@nDiaPro,,,@dDtBasFim,.F.,cTafaFer)
		nDiaVen := If (nDiaVen > aTabFer[3], aTabFer[3], nDiaVen)
	Endif	
    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo dias de  faltas                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nDFaltaV:= SRF->RF_DFALVAT
	nDFaltaP:= SRF->RF_DFALAAT
	TabFaltas(@nDFaltaV)
	TabFaltas(@nDFaltaP)
	nDFaltaP := ((nDFaltaP / 30) * nDiasProp )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da data do inicio da programacao das ferias         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dDtIProg1 	:= SRF->RF_DATAINI
	dDtIProg2 	:= dDtIProg3 := CTOD("")
	nDiasFer1 	:= nDiasFer2 := nDiasFer3 := 0 
	nDiasAbo1	:= nDiasAbo2 := nDiasAbo3 := 0	
	lUnicoPer	:= .F. 
	
	//-- Prioriza as informacoes digitadas no novos cpos de program.
	If lTemCpoProg
		dDtIProg2 := SRF->RF_DATINI2
		dDtIProg3 := SRF->RF_DATINI3
		nDiasFer1 := SRF->RF_DFEPRO1
		nDiasFer2 := SRF->RF_DFEPRO2
		nDiasFer3 := SRF->RF_DFEPRO3
		nDiasAbo1 := SRF->RF_DABPRO1
		nDiasAbo2 := SRF->RF_DABPRO2
		nDiasAbo3 := SRF->RF_DABPRO3
		lUnicoPer := If(  (nDiasFer1+nDiasAbo1) == nDiaVen , .T., lUnicoPer)
	EndIf

	//-- Calcula dias de abono
	If SRF->RF_TEMABPE == "S" .And.  ! Empty(SRF->RF_DATAINI) .And. nDiasAbo1 = 0 .And. nDiasFer1 = 0
		nDiasAbo1	:=  (Min(nDiaVen-SRF->RF_DFERANT,aTabFer[3]) - nDFaltaV ) /3 
		nDiasAbo1	:= Int(nDiasAbo1)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se Ferias forem  gozadas em  um  unico periodo, proporcionaliza³
	//³ o abono pecuniario, se nao, utiliza o que for informado nos cam³
	//³ pos de dias de ferias e abono de cada  periodo                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ElseIf SRF->RF_TEMABPE == "S" .And. lUnicoPer
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Garantir que os dias de gozo e abono pecuniario estejam iguais ³
		//³ ao total de dias de ferias vencidas antes de fazer a proporcio-³
		//³ nalizacao dos dias de abono pecuniario em funcao das faltas no ³
		//³ periodo aquisitivo.                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDiasAbo1	:= int( ( nDiaVen - nDFaltaV ) / 3 )
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Data Inicio                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (!Empty(dDtIProg1) .Or. !Empty(dDtIProg2) .Or. !Empty(dDtIProg3)) .And. nTipFerias == 1
		dbSkip()
		Loop
	ElseIf Empty(dDtIProg1) .And. Empty(dDtIProg2) .And. Empty(dDtIProg3) .And. nTipFerias == 2
		dbSkip()
		Loop
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Ferias Programdas no Intervalo Definido			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTipFerias == 2 .And. (dDtIProg1 < dProgDe .Or. dDtIProg1 > dProgAte) .And.;
	   (dDtIProg2 < dProgDe .Or. dDtIProg2 > dProgAte) .And.;
	   (dDtIProg3 < dProgDe .Or. dDtIProg3 > dProgAte)
		dbSkip()
		Loop
	EndIf

	If !(cFiAnt == SRA->RA_FILIAL)
		If !(cFiAnt == Space(FWGETTAMFILIAL))
			Impr("","P")
		EndIf
		cFiAnt := SRA->RA_FILIAL
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica Quebra de Centro de Custo e Filial                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nOrdem == 1 .Or. nOrdem == 4
		If !(cCcAnt == SRA->RA_CC)
			If !(cCcAnt == Space(20))
			
				Impr(Replicate("=",220),"C")			
				If lSalta
					Impr("","P")
				EndIf
            EndIf
			cCcAnt := SRA->RA_CC

			// Imprime a descricao do Centro de Custo
			cDescCC		:= fDesc("SI3", (cAliasSRA)->RA_CC, "I3_DESC",,(cAliasSRA)->RA_FILIAL)
			Impr( cDescCC ,"C") 
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Periodo Aquisitivo                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DFIMPAQUI := If (Empty(dDtBasFim), fCalcFimAq(dDtBaseFer), dDtBasFim)
	DPRPAQUI  := fCalcFimAq(DFIMPAQUI+1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir as duas linhas do funcionario na mesma pagina       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	If LI > 56
  		LI  := 70 ; DET := ""
	    IMPR(DET,"C")
  	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Detalhe Para o Funcionario                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRF->RF_DVENPEN > 0 .And. !Empty(SRF->RF_IVENPEN)
		DET := Space(1)+SRF->RF_FILIAL+Space(4)+substr(SRA->RA_CC+space(2)+SRA->RA_X_SEGME+Space(20),1,20)+Space(6)+SRA->RA_MAT+Space(3)+left(SRA->RA_NOME,30)+Space(2)
	    DET += PadR(DtoC(SRA->RA_ADMISSA),10)+Space(2)+PadR(DtoC(SRF->RF_IVENPEN),10)+Space(2)
	    DET += PadR(DtoC(SRF->RF_IVENPEN),10)+Space(2)+PadR(DtoC(SRF->RF_FVENPEN),10)+Space(2)
	  	DET += PadR(DtoC(SRF->RF_FVENPEN + 30),10)+Space(2)+PadR(DtoC(DFIMPAQUI - 45) ,10)+Space(6)
		DET += Transform(SRF->RF_DVENPEN,"999.9")+Space(5)+Transform(0,"999.9")+Space(5)
		DET += Transform(0,"999.9")+Space(5)+Transform(0,"999.9")+Space(5)
		DET += Transform(SRF->RF_DVENPEN,"999.9")+Space(1)
	    DET += "|______|"
	    IMPR(DET,"C")
	    DET := ""
	    IMPR(DET,"C")        
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprimir as duas linhas do funcionario na mesma pagina       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	If LI > 56
  		LI  := 70 ; DET := ""
	    IMPR(DET,"C")
  	EndIf
  	
  	If SRA->RA_X_SEGME != cXSEGME .AND. cXSEGME != "" .AND. nOrdem == 7
  		LI  := 70 ; DET := ""
	    IMPR(DET,"C")
  	EndIf
  	cXSEGME := SRA->RA_X_SEGME

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Detalhe Para o Funcionario                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DET := Space(1)+SRF->RF_FILIAL+Space(4)+substr(SRA->RA_CC+space(2)+SRA->RA_X_SEGME+Space(20),1,20)+Space(6)+SRA->RA_MAT+Space(3)+left(SRA->RA_NOME,30)+Space(2)
    DET += PadR(DtoC(SRA->RA_ADMISSA),10)+Space(2)+PadR(DtoC(SRF->RF_DATABAS),10)+Space(2)
    DET += PadR(DtoC(dDtBaseFer),10)+Space(2)+PadR(DtoC(DFIMPAQUI),10)+Space(2)
  	DET += PadR(DtoC(DFIMPAQUI + 30),10)+Space(2)+PadR(DtoC(DPRPAQUI - 45) ,10)+Space(6)
	If nTipo ==1
		DET += Transform(nDiasVenc,"999.9")+Space(5)+Transform(nDFaltaV,"999.9")+Space(5)
		DET += Transform(nDiasProp,"999.9")+Space(5)+Transform(nDFaltaP,"999.9")+Space(5)
		DET += Transform(nDiasVenc + nDiasProp - nDFaltaV - nDFaltaP,"999.9")+Space(1)
	Else
		DET += Transform(nDiasVenc + nDiasProp ,"999.9")+Space(1)
	Endif
	
    If nTipo ==1
	    If SRF->RF_PERC13S > 0
	       DET += TransForm(SRF->RF_PERC13S,"999.99")
	    Else
	       DET += "|______|"
	    Endif
	Endif
    IMPR(DET,"C")
	DET := " "   
    IMPR(DET,"C")
	//-- Programacao ferias    
    For nCnt1 := 1 To nPeriodo
    	dDtIniProg := If(nCnt1 == 1, dDtIProg1, If(nCnt1 == 2, dDtIProg2, dDtIProg3))
    	nDiasFePro := If(nCnt1 == 1, If (nDiasFer1 = 0 , nDiaVen,If( lUnicoPer	,  (nDiaVen-nDFaltaV-nDiasAbo1),nDiasFer1)), If(nCnt1 == 2, nDiasFer2, nDiasFer3))
    	nDiasAbono := If(nCnt1 == 1, nDiasAbo1, If(nCnt1 == 2, nDiasAbo2, nDiasAbo3))

		//-- Abater Dias de Abono quando  nao houver os campos de programacao com dias ou quando
		//-- existir os campos e estiver zerado.
		If ( nCnt1 == 1 .And. ! Empty(SRF->RF_DATAINI) ) .And. ;
		 ( (! lTemCpoProg ) .Or. ( lTemCpoProg .And. SRF->RF_DFEPRO1 = 0  .And. SRF->RF_DABPRO1 = 0 ))
			nDiasFePro -= ( SRF->RF_DFERANT + nDFaltaV + nDiasAbono)
		Endif
		nDiasFePro := Max(nDiasFePro, 0)
		nDiasFePro := Min(nDiasFePro,aTabFer[3])
		If nTipo == 1
   			DET		   := Space(70)+ if(nCnt1 == 1,STR0025,if(nCnt1 == 2,STR0026,STR0027))//"1a -  P R O G R A M A C A O  D E  F E R I A S"#"2a -  P R O G R A M A C A O  D E  F E R I A S"#"3a -  P R O G R A M A C A O  D E  F E R I A S" 
   		Else
   			DET		   := Space(70)+ STR0057 //"P R O G R A M A C A O   D E   R E C E S S O"
   		Endif
		//-- Periodo de gozo de ferias 
	    If !Empty(dDtIniProg) 
	    	If nDiasFePro  > 0 
		  		dDataAte	:= DtoC(dDtIniProg+(nDiasFePro-1))
    	 	ElseIf nDiaVen > 0  
    	 		dDataAte	:= DtoC(dDtIniProg+nDiaVen  -1)
    	 	Else
    	 		dDataAte	:= "______/______/______"
    	    Endif
	        DET	+= PadC(DtoC(dDtIniProg),20)+STR0014+PadC(dDataAte,20)   //"  A  "
	    Else
			DET        += STR0015	//"______/______/______  A  ______/______/______"
	    EndIf
	    If nTipo == 1
		    If nDiasFePro > 0
		       DET += Space(1)+STR0028+Space(2)+ TransForm(nDiasFePro,"999.9") + space(3)
		    Else
		       DET += Space(1)+STR0028+space(2)+ "|______|" //"D.Ferias
			EndIf 
		Else
		   If nDiasFePro > 0
		       DET += Space(1)+STR0059+Space(2)+ TransForm(nDiasFePro,"999.9") + space(3)
		    Else
		       DET += Space(1)+STR0059+space(2)+ "|______|" //"D.Recesso
			EndIf
		Endif
		If nTipo == 1
		    If nDiasAbono > 0  
		       DET += space(02)+STR0029+ space(1)+ TransForm(nDiasAbono,"999.9") + Space(3)//"D.AB."
		    Elseif nDiasAbono = 0 .And. SRF->RF_TEMABPE == "S" .And. nDiasFePro = 0 
		       DET += space(02)+STR0029+ space(3)+ STR0030+SPACE(3)//"D.AB."
		    Else
		       DET += space(02)+STR0029+ space(1)+ "|______|" //"D.AB."
		    Endif
		Endif
	    DET += Space(2)
		DET += Replicate("_", 27)
    	IMPR(DET,"C")
	    DET := ""
    	IMPR(DET,"C")
	Next nCnt1

   	cFiAnt   := SRA->RA_FILIAL
	cCcAnt   := SRA->RA_CC
	If nOrdem == 5 .Or. nOrdem == 6
		dbSelectArea( "SRF" )
	Else
		dbSelectArea( "SRA" )
	EndIf
	dbSkip()
Enddo
IMPR("","F")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRF" )
Set Filter to
RetIndex("SRF")
dbSetOrder(1)

If nOrdem == 5 .Or. nOrdem == 6 // Ordem por Programa‡Æo de F‚rias
	fErase(cArqNtx  + OrdBagExt() )
EndIf

dbSelectArea( "SRA" )
Set Filter to
dbSetOrder(1)

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1 ºAutor  ³Luciana Silveira    º Data ³  24/08/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Para ajustes no dicionario de dados SX1                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GPER400                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AjustaSX1(cPerg)
Local aAreaSX1	:= SX1->(GetArea())
Local aArea		:= GetArea()
Local aRegs		:= {}
Local aHelpPor	:= {}
Local aHelpSpa	:= {} 
Local aHelpEng	:= {}
Local cHelp		:= ""
Local cPergPesq	:= Left( cPerg + Space	(Len(SX1->X1_GRUPO)),Len(SX1->X1_GRUPO))

aHelpPor := {	"Informe o relatório a ser impresso:"		,;
		   		"   1- Relação de Programação de Férias"	,;
	   	 		"   2- Relação de Programação de Recesso"	}  
	
aHelpSpa := ""
aHelpEng := ""

If cPerg == "GP400R"
    
	// Se existir a pergunta 13 (Tipo de Relatorio) deve excluir todo o grupo de pergunta GP400R
	DbSelectArea( "SX1" )
	DbSetOrder( 1 )
	IF dbSeek( cPergPesq + "13" ) .and. "Tipo de Relatório" $ SX1->X1_PERGUNT
               
		FDelSX1( cPergPesq, "", "", "", .T. )

	   	cHelp := ".GP400R12." 
		PutSX1Help( "P" + cHelp, aHelpPor, aHelpEng, aHelpSpa, .T. )

		/* Ajusta Perguntas
		ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		³				Grupo	Ordem Pergunta Portugues		Pergunta Espanhol			Pergunta Ingles				Variavel	Tipo	Tamanho Decimal Presel	GSC		Valid			Var01		Def01       		DefSPA1          	DefEng1			Cnt01			Var02	Def02   	         DefSpa2			DefEng2				Cnt02	Var03	Def03    		DefSpa3   		DefEng3  		Cnt03  	Var04  	Def04	DefSpa4	DefEng4	Cnt04  	Var05  	Def05	DefSpa5	DefEng5	Cnt05	XF3		GrgSxg	cPyme	aHelpPor	aHelpEng	aHelpSpa	cHelp			³
		ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
		aAdd( aRegs	,{	cPerg	,"01" ,"Filial ?"				,"¿Sucursal ?"				,"Branch ?"					,"MV_CH1"	,"C"	,99		,0		,0		,"R"	,""			  	,"mv_par01"	,""					,""					,""				,"RA_FILIAL"	,""		,""					,""					,""		   			,""		,""		,""	   			,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,"XM0"	,""		,"S"	,""			,""			,""			,".RHFILIAL."	})
		aAdd( aRegs	,{	cPerg	,"02" ,"Centro de Custo ?"		,"¿Centro de Costo ?"	   	,"Cost center ?"			,"MV_CH2"	,"C"	,09		,0		,0		,"R"	,""			  	,"mv_par02"	,""					,""					,""				,"RA_CC"		,""		,""					,""					,""		   			,""		,""		,""	   			,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,"CTT"	,"004"	,"S"	,""			,""			,""			,".RHCCUSTO."	})
		aAdd( aRegs	,{	cPerg	,"03" ,"Matricula ?"			,"¿Matricula ?"			  	,"Registration ?"			,"MV_CH3"	,"C"	,99		,0		,0		,"R"	,""			  	,"mv_par03"	,""					,""					,""				,"RA_MAT"		,""		,""					,""					,""		   			,""		,""		,""	   	   		,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,"SRA"	,""		,""		,""			,""			,""			,".RHMATRIC."	})
		aAdd( aRegs	,{	cPerg	,"04" ,"Nome ?"					,"¿Nombre ?"			  	,"Name ?"					,"MV_CH4"	,"C"	,99		,0		,0		,"R"	,""			  	,"mv_par04"	,""					,""					,""				,"RA_NOME"		,""		,""					,""					,""		   			,""		,""		,""	   	   		,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""			,""			,".RHNOME."		})
		aAdd( aRegs	,{	cPerg	,"05" ,"Situações ?"			,"¿Situaciones ?"		  	,"Status ?"					,"MV_CH5"	,"C"	,05		,0		,0		,"G"	,"fSituacao"  	,"mv_par05"	,""					,""					,""				,""				,""		,""					,""					,""		   			,""		,""		,""	   			,""		   		,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""			,""			,".RHSITUA."	})
		aAdd( aRegs	,{	cPerg	,"06" ,"Categorias ?"			,"¿Categorias ?"		  	,"Categories ?"				,"MV_CH6"	,"C"	,15		,0		,0		,"G"	,"fCategoria" 	,"mv_par06"	,""					,""					,""				,""				,""		,""					,""					,""		  			,""		,""		,""	   			,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""			,""			,".RHCATEG."	})
		aAdd( aRegs	,{	cPerg	,"07" ,"C.C. em outra Página ?"	,"¿C.C. en otra Pagina ?" 	,"C.C. in another page ?"	,"MV_CH7"	,"C"	,01		,0		,2		,"C"	,""			  	,"mv_par07"	,"Sim"				,"Si"				,"Yes"			,""				,""		,"Nao"		   		,"No"				,"No"				,""		,""		,""	   			,""				,""		  		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,"S"	,""			,""			,""			,""				})
		aAdd( aRegs	,{	cPerg	,"08" ,"Tipo de Ferias ?"		,"¿Tipo de Vacaciones ?"  	,"Type of vacations ?"		,"MV_CH8"	,"N"	,01		,0		,3		,"C"	,""	  			,"mv_par08"	,"Nao Programada"	,"No Programada"	,"Unscheduled"	,""				,""		,"Programada"		,"Programada"		,"Scheduled"		,""		,""		,"Ambas"  		,"Ambas"		,"Both"	  		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""	   		,""			,""				})
		aAdd( aRegs	,{	cPerg	,"09" ,"Programadas de ?"		,"¿De Programadas ?"	  	,"Scheduled from ?"			,"MV_CH9"	,"D"	,08		,0		,0		,"G"	,""	  			,"mv_par09"	,""					,""					,""				,""				,""		,""					,""					,""					,""		,""		,""	   			,""				,""		  		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""	   		,""			,""				})
		aAdd( aRegs	,{	cPerg	,"10" ,"Programadas ate ?"		,"¿A Programadas ?"	   		,"Scheduled to ?"			,"MV_CHA"	,"D"	,08		,0		,0		,"G"	,""	  			,"mv_par10"	,""					,""					,""				,""				,""		,""					,""					,""					,""		,""		,""				,""				,""				,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""	   		,""			,""				})
		aAdd( aRegs	,{	cPerg	,"11" ,"Imprime ?"				,"¿Imprime ?"			  	,"Print ?"					,"MV_CHB"	,"N"	,01		,0		,1		,"C"	,""	   			,"mv_par11"	,"1 Periodo"		,"1 Periodo"		,"1st Period"	,""				,""		,"2 Periodo"		,"2 Periodo"		,"2nd Period"		,""		,""		,"3 Periodo"	,"3 Periodo"	,"3nd Period"	,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,""		,""			,""	  		,""			,""				})
		aAdd( aRegs	,{	cPerg	,"12" ,"Tipo de Relatório ?"	,"¿Tipo de Relatório ?"	 	,"Tipo de Relatório ?"		,"MV_CHC"	,"N"	,01		,0		,1		,"C"	,""	  			,"mv_par12"	,"Progr Férias"		,"Progr Férias"		,"Progr Férias"	,""				,""		,"Progr Recesso"	,"Progr Recesso"	,"Progr Recesso"	,""		,""		,""	  			,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,"S"	,aHelpPor	,aHelpSpa	,aHelpEng	,cHelp			})
    Else
	   	cHelp := ".GP400R12." 
		PutSX1Help( "P" + cHelp, aHelpPor, aHelpEng, aHelpSpa, .T. )
	    aAdd( aRegs	,{	cPerg	,"12" ,"Tipo de Relatório ?"	,"¿Tipo de Relatório ?"	 	,"Tipo de Relatório ?"		,"MV_CHC"	,"N"	,01		,0		,1		,"C"	,""	  			,"mv_par12"	,"Progr Férias"		,"Progr Férias"		,"Progr Férias"	,""				,""		,"Progr Recesso"	,"Progr Recesso"	,"Progr Recesso"	,""		,""		,""	  			,""				,""		   		,""		,""		,""		,""		,""		," "	,""		,""		,""		,""		,""		,""		,""		,"S"	,aHelpPor	,aHelpSpa	,aHelpEng	,cHelp			})
  	EndIf
	
	ValidPerg( aRegs, cPerg, .F. )  
	
Else 
	cHelp := ".GPR40016." 
	PutSX1Help("P"+cHelp,aHelpPor,aHelpEng,aHelpSpa,.T.)                                                                                                                                                                          				                               
     //          "X1_GRUPO"	,"X1_ORDEM"	,"X1_PERGUNT"			   			,"X1_PERSPA"				   		,"X1_PERENG"						,"X1_VARIAVL"	,"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"	,"X1_VALID"			,"X1_VAR01"	,"X1_DEF01"			,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"	,"X1_VAR02"	,"X1_DEF02"			,"X1_DEFSPA2"		,"X1_DEFENG2"   ,"X1_CNT02"	,"X1_VAR03"	,"X1_DEF03"			,"X1_DEFSPA3"		,"X1_DEFENG3"		,"X1_CNT03"	,"X1_VAR04"	,"X1_DEF04"	,"X1_DEFSPA4"	,"X1_DEFENG4"	,"X1_CNT04"	,"X1_VAR05"	,"X1_DEF05"	,"X1_DEFSPA5"	,"X1_DEFENG5"	,"X1_CNT05"	,"X1_F3"	,"X1_GRPSXG","X1_PYME"	AHELPPOR	,AHELPENG	,AHELPSPA	,"X1_HELP" }
	aAdd(aRegs,{cPerg	,"16"		,"Tipo de Relatório  ?"	   			,"¨Tipo de Relatório?"		   		,"Tipo de Relatório ?"		  		,"mv_chq"		,"N"		,01				,0				,2				,"C"		,""		   			,"mv_par16"	,"Progr Férias","Progr Férias"		,"Progr Férias"		,""    		,""      	,"Progr Recesso","Progr Recesso","Progr Recessoo"	,""			,""			,""					,""			   		,""			   		,""			,""			,""			,""				,""				,""			,""			,""			,""				,""				,""			,""			,""			,"S"		,""			,aHelpPor			,aHelpSpa			,aHelpEng,""			  })
	Aadd(aRegs,{cPerg	,"17" 		,"Segmento De ?"					,"Segmento De ?"					,"Segmento De ?"					,"MV_CHG" 		,"C"  ,TAMSX3("CTH_CLVL")[1]      ,TAMSX3("CTH_CLVL")[2]     ,      ,"G"  ,""     ,"MV_PAR17","",""    ,""   ,""    ,""    ,"",""    ,""    ,""   ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTH"  ,""    ,"S"  ,""     ,""      ,""      ,""  })
	Aadd(aRegs,{cPerg	,"18" 		,"Segmento Até?"					,"Segmento Até?"					,"Segmento Até?"					,"MV_CHH" 		,"C"  ,TAMSX3("CTH_CLVL")[1]      ,TAMSX3("CTH_CLVL")[2]     ,      ,"G"  ,""     ,"MV_PAR18","",""    ,""   ,""    ,""    ,"",""    ,""    ,""   ,""   ,""    ,""      ,""      ,""   ,""   ,""   ,""     ,""     ,""   ,""    ,""    ,""     ,""     ,""   ,"CTH"  ,""    ,"S"  ,""     ,""      ,""      ,""  })
	
	ValidPerg( aRegs, cPerg, .F. )
Endif

RestArea( aAreaSX1 )
RestArea( aArea )
Return
