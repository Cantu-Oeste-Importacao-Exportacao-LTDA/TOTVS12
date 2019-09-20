#Include "PROTHEUS.CH"
#INCLUDE "GPER040.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPER040  ³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamento                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ GpeR040(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Mauro       ³11/12/01³011677³ Func. c/Retorno Afast. e Demissao no mes ³±±
±±³            ³        ³      ³ contava como afastado no mes.            ³±±
±±³Andreia     ³26/04/01³------³ Inclusao da funcao fCalcCompl para calcu-³±±
±±³            ³        ³      ³ lar os Valores cadastrados no parametro  ³±±
±±³            ³        ³      ³ 15.                                      ³±± 
±±³Andreia     ³12/08/02³014341³ Tratamento da quebra de pagina por funci-³±±
±±³            ³        ³      ³ onario atraves do parametro MV_QUEBFUN.  ³±±
±±³Andreia     ³12/08/02³014955³ Aumento da mascara de impressao do campo ³±±
±±³            ³        ³      ³ horas na impressao dos totais.           ³±±
±±³Emerson     ³15/08/02³Meta  ³ Se RC_QTDSEM maior que 0, sera impresso  ³±±
±±³            ³        ³      ³ como referencia, caso contrario RC_HORAS.³±±
±±³Andreia     ³17/10/02³------³ Tratamento do tipo de afastamento "1","W"³±±
±±³            ³        ³      ³ "8","2","3" e "4" na totalizacao da quan-³±±
±±³            ³        ³      ³ tidade de funcionarios.                  ³±±
±±³Emerson     ³27/12/02³------³ Passar a deduzir percentuais de terceiros³±±
±±³            ³        ³      ³ a partir das definicoes no parametro 15. ³±±
±±³Silvia      ³20/02/03³Locali³ Localizacao do relatorio para utilizacao ³±±
±±³            ³        ³zacao ³ no Uruguai e Argentina                   ³±±
±±³Marinaldo   ³15/04/03³062671³Alterada fCalcInss() para, na   composicao³±±
±±³            ³        ³------³da Base do Pis, Somar os Proventos e Bases³±±
±±³            ³        ³------³que Incidem PIS e subtrair os    Descontos³±±
±±³            ³        ³------³que Incicem PIS                           ³±±
±±³Natie       ³28/04/03³062585³Acerto Pict do vlr Referencia de Proventos³±±
±±³Emerson     ³09/05/03³------³Calc. Acid.Trabalho p/ Pro-Labore/Autonomo³±±
±±³Emerson     ³19/05/03³------³Ajuste em fCalcInss p/nao calcular o % do ³±±
±±³            ³        ³------³autonomo se o % da verba e da empresa == 0³±±
±±³Mauro       ³01/10/03³------³Troca da funcao de busca de salario meses ³±±
±±³            ³        ³------³anteriores e impressao do rodape no final.³±±
±±³Silvia      ³17/10/03³Locali³Localizacao Cuota Mutual -Uruguai         ³±±
±±³Natie       ³16/03/04³F01027³Acerto p/trazer Funcao do mes de Referec. ³±±
±±³Emerson     ³08/04/04³070857³Se semana = "99" imprimir mes por extenso ³±±
±±³            ³        ³------³no relatorio(imprimia apenas folha Pagto).³±±
±±³Pedro       ³18/06/04³068275³Tratar montagem dos niveis em MontaMasc().³±±
±±³Emerson     ³28/10/04³075658³Checar parametro MV_IREFSEM para imprimir ³±±
±±³            ³        ³------³referencias em Semanas ou Horas.		  ³±±
±±³Emerson     ³02/12/04³------³Selecionar area SRZ p/ checar cpo RZ_MAT. ³±±
±±³Ricardo D.  ³03/02/05³071931³Incluir tratamento para o tipo de contrato³±±
±±³            ³        ³------³na chamada da funcao fGpsVal().           ³±±
±±³Emerson     ³11/03/05³079619³Se folha 13o buscar mes 13 no paramtro 15.³±±
±±³Ricardo D.  ³18/05/05³------³Ajuste na estrutura do array gravado em   ³±±
±±³            ³        ³------³fSoma() p/utilizacao no ponto de entrada  ³±±
±±³            ³        ³------³GP040SRZ() p/alteracao de valores dos fun-³±±
±±³            ³        ³------³cionarios antes da contabilizacao.        ³±±
±±³Natie       ³05/07/05³081755³Ajuste na quebra (mv_quebfun="S")         ³±±
±±³Natie       ³11/07/05³078594³Considera vlr dif.dissidio na fImpGerFol  ³±±
±±³Natie       ³26/12/05³090622³ajuste na gravacao dos totais p/empresa   ³±±
±±³Silvia      ³05/05/06³095901³Ajuste no calculo BSE - Uruguai           ³±±
±±³Ricardo D.  ³17/10/06³093770³Retirada a totalizacao das transferencias ³±±
±±³            ³        ³------³do resumo de centro de custos e filiais.  ³±±
±±³Renata      ³10/07/07³128481³Inclusao Ponto de Entrada "GP040Det" em   ³±±
±±³            ³        ³------³fImprime.                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function GpeR040()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cDesc1 	:= STR0001		//"Folha de Pagamento"
Local cDesc2 	:= STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo usuario."
Local cDesc3 	:= STR0003		//"Obs. Dever  ser impressa uma Folha/Resumo para cada Tipo de Contrato."
Local cString	:= "SRA"        				// alias do arquivo principal (Base)
Local aOrd      := {STR0004,STR0005,STR0006,STR0007,STR0008,'Segmento+C.Custo'}		//"C.Custo do Cadastro"###"Matricula"###"Nome"###"C.Custo do Movto."###"C.Custo + Nome"###"C.Custo + Item + Classe"
Local cMesAnoRef

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := { STR0009, 1,STR0010, 2, 2, 1,"",1 }	//"Zebrado"###"Administra‡„o"
Private nomeprog:= "GPER040"
Private aLinha  := {},nLastKey := 0
Private cPerg   := "GPR040CUS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Titulo	:= STR0011		//"IMPRESSO DA FOLHA DE PAGAMENTO"
Private AT_PRG  := "GPER040"
Private wCabec0 := 1
Private wCabec1 := ""
Private CONTFL  := 1
Private LI      := 0
Private nTamanho:= "M"
Private cCabec
Private nOrdem
Private aInfo   := {}
Private cTipCC, cRefOco

Private lTemItemRA   := SRA->( FieldPos( "RA_X_ITEM" ) # 0 )
Private lTemClVlRA	 := SRA->( FieldPos( "RA_X_SEGME" ) # 0 )
Private lTemItemRI   := SRI->( FieldPos( "RI_X_ITEM" ) # 0 )
Private lTemClVlRI	 := SRI->( FieldPos( "RI_X_SEGME" ) # 0 )
Private lTemItemRC   := SRC->( FieldPos( "RC_X_ITEMC" ) # 0 )
Private lTemClVlRC	 := SRC->( FieldPos( "RC_X_CLVL" ) # 0 )   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If lTemItemRA .AND. lTemClVlRA .AND. lTemItemRI .AND. lTemClVlRI .AND. lTemItemRC .AND. lTemClVlRC
	aAdd( aOrd, STR0072 ) // "C.Custo + Item + Classe"
EndIf
ValidPerg()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="GPER040"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

If nLastKey = 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01        //  Data de Referencia para a impressao      ³
//³ mv_par02        //  Adto / Folha / 1¦ Parc. / 2¦ Parc.       ³
//³ mv_par03        //  Numero da Semana                         ³
//³ mv_par04        //  Filial  De                               ³
//³ mv_par05        //  Filial  Ate                              ³
//³ mv_par06        //  Centro de Custo De                       ³
//³ mv_par07        //  Centro de Custo Ate                      ³
//³ mv_par08        //  Matricula De                             ³
//³ mv_par09        //  Matricula Ate                            ³
//³ mv_par10        //  Nome De                                  ³
//³ mv_par11        //  Nome Ate                                 ³
//³ mv_par12        //  Situacao                                 ³
//³ mv_par13        //  Categoria                                ³
//³ mv_par14        //  Imprime C.C em outra Pagina              ³
//³ mv_par15        //  Folha Sintetica ou Analitica             ³
//³ mv_par16        //  Imprime Total Filial                     ³
//³ mv_par17        //  Imprime Total Empresa                    ³
//³ mv_par18        //  Imprime Niveis C.Custo                   ³
//³ mv_par19        //  Imprime Unico Nivel                      ³
//³ mv_par20        //  Imprime Apenas Totais Filial/Empresa     ³
//³ mv_par21        //  Imprime Codigo ou Descricao C.Custo      ³
//³ mv_par22        //  Imprime Referencia ou Ocorrencias        ³
//³ mv_par23        //  Tp Contrato                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem   := aReturn[8]
dDataRef := mv_par01
nRelat   := mv_par02
Semana   := mv_par03
cFilDe   := mv_par04
cFilAte  := mv_par05
cCcDe    := mv_par06
cCcAte   := mv_par07
cMatDe   := mv_par08
cMatAte  := mv_par09
cNomDe   := mv_par10
cNomAte  := mv_par11
cSit     := mv_par12
cCat     := mv_par13
lSalta   := If(mv_par14 == 1,.T.,.F.)
cSinAna  := If(mv_par15 == 1,"A","S")
lImpFil  := If(mv_par16 == 1,.T.,.F.)
lImpEmp  := If(mv_par17 == 1,.T.,.F.)
lImpNiv  := If(mv_par18 == 1.OR.mv_par18 == 3,.T.,.F.)
lUnicNV  := If(mv_par19 == 1,.T.,.F.)
lImpTot  := If(mv_par20 == 1,.T.,.F.)
cTipCC   := mv_par21
cRefOco  := mv_par22
nTpContr := mv_par23
cSegDe	 := mv_par24
cSegAte  := mv_par25

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³  Pega descricao da semana                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesOrdem:=If(nOrdem == 1,STR0012,If(nOrdem==2,STR0013,If(nOrdem==3,STR0014,If(nOrdem==4,STR0015,If(nOrdem==5,STR0016,STR0072)))))		//"  ORDEM: C.C. DO CADASTRO"###"  ORDEM: MATRICULA"###"  ORDEM: NOME"###"  C.C. DO MOVTO."###"  C.CUSTO + NOME"

If Semana # Space(2) .And. Semana # "99"
	cCabec := fRetPer( Semana,dDataRef )
Else
	cCabec := " / "+Upper(MesExtenso(Month(dDataRef)))+STR0017+STR(YEAR(dDataRef),4) + cDesOrdem	//" DE "
Endif

Titulo := STR0018+If(nRelat==1,STR0019,;				//"FOLHA "###"DO ADIANTAMENTO "
Iif(nRelat==2,STR0020,If(nRelat==3,STR0021,;	//"DE PAGAMENTO "###"DA 1a. PARCELA 13o SAL. "
STR0022))) + cCabec 							//"DA 2a. PARCELA 13o SAL."

NewHead    := Nil

cMesAnoRef := StrZero(Month(dDataRef),2) + StrZero(Year(dDataRef),4)

RptStatus({|lEnd| GR040Imp(@lEnd,wnRel,cString,cMesAnoRef,nTpContr,.F.)},Capital(Titulo))

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ GPR040Imp³ Autor ³ R.H. - Ze Maria       ³ Data ³ 03.03.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Folha de Pagamanto                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR040Imp(lEnd,wnRel,cString)                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd        - A‡ao do Codelock                             ³±±
±±³          ³ wnRel       - T¡tulo do relat¢rio                          ³±±
±±³          ³ cString     - Mensagem                                     ³±±
±±³          ³ lGeraLanc   - Indica se deve gerar o INSS (SRZ)            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Esta funcao tambem e utilizada a partir da impressao da GPS³±±
±±³          ³ e Contabilizacao(para gerar lancamentos), queira,ao altera-³±±
±±³          ³ la, testar ambas as rotinas.                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function GR040Imp(lEnd,WnRel,cString,cMesAnoRef,nTpContr,lGeraLanc)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Basicas)                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cMapa       := 0
Local nLaco       := 0
Local nByte := 0
Local aOrdBag     := {}
Local cArqMov     := ""
Local cMesArqRef  
Local dChkDtRef   := CTOD("01/"+Left(cMesAnoRef,2)+"/"+Right(cMesAnoRef,4),"DDMMYY")
Local nQ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private			                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cMascCus  := GetMv("MV_MASCCUS")
Private cCalcInf  := GetMv("MV_CALCINF")
Private cEncInss  := GetMv("MV_ENCINSS",,"N")
Private cQuebFun  := GetMv("MV_QUEBFUN",,"S") //quando for igual a nao, imprime funcionario sem quebrar pagina 
Private cIRefSem  := GetMv("MV_IREFSEM",,"S")
Private aNiveis   := {}
Private nDed      := 0.00   // Deducoes Inss
Private aCodFol   := {}
Private	cTpC      := ""
Private	cTpC1     := ""
Private aInssEmp[24][2]
Private aEmpP     := {}  // Empresa
Private aEmpD     := {}
Private aEmpB     := {}
Private aFilP     := {}  // Filial
Private aFilD     := {}
Private aFilB     := {}
Private aCcP      := {}  // Centro de Custo
Private aCcD      := {}
Private aCcB      := {}

Private cContribuicao := cContrProAuto := ""
Private cAnoMesRef    := Right(cMesAnoRef,4) + Left(cMesAnoRef,2)
Private cAliasMov     := ""                                      
Private	cItAnt        := ""
Private	cClAnt		  := ""
Private	cItCt         := ""
Private	cClVl		  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se deve gerar lancamentos ou imprimir folha.        |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lGeraSRZ := lGeraLanc
If cPaisLoc == "URU"
	Private cCCCuota
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica Paramentro Calculo INSS com Existencia campo SR->RZ_MAT |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRZ" )
If cEncInss == "S" .and. Type("SRZ->RZ_MAT") == "U"
	AVISO("Aviso","Quando o parametro MV_ENCINSS estiver com 'S' e necessario a criacao do campo RZ_MAT no arquivo SRZ",{"Enter"} ) 
   return
Endif   
If cPaisLoc $ "URU|ARG|PAR"
	If nRelat == 3
		cMesArqRef := "13" + Right(cMesAnoRef,4)	
	ElseIf nRelat == 4
		cMesArqRef := "23" + Right(cMesAnoRef,4)		
	Else
		cMesArqRef := cMesAnoRef
	Endif		
Else
	If nRelat == 4  
		cMesArqRef := "13" + Right(cMesAnoRef,4)
	Else
		cMesArqRef := cMesAnoRef
	Endif	              
Endif			

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Verifica se existe o arquivo de fechamento do mes informado  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !OpenSrc( cMesArqRef, @cAliasMov, @aOrdBag, @cArqMov, dChkDtRef, lGeraSRZ )
	Return .f.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ aNiveis -  Armazena as chaves de quebra.                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lImpNiv

	aNiveis:= MontaMasc(cMascCus)
	
	//--Criar os Arrays com os Niveis de Quebras
	For nQ = 1 to Len(aNiveis)
		cQ := STR(NQ,1)
		Private aCcP&cQ := {}    // Centro de Custo
		Private aCcD&cQ := {}
		Private aCcB&cQ := {}
		cCcAnt&cQ       := ""    //Variaveis c.custo dos niveis de quebra
		//--Totais dos Funcionarios dos Niveis de quebra
		nCnor&cQ := nCafa&cQ := nCdem&cQ := nCfer&cQ := 0
		nCexc&cQ := nCadm&cQ := nCtot&cQ := 0
	Next nQ
Endif

If cPaisLoc == "URU" .And.nTpContr == 3
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime folha ou gera SRZ para ambos tipos de contrato       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTpC  := " *12"
	cTpC1 := " *12"
	fImpGerFol(lEnd,cAnoMesRef)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime folha ou gera SRZ para tipo de contrato INDETERMINADO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTpContr == 1 .Or. nTpContr == 3
		cTpC  := "1"
		cTpC1 := " *1"
		fImpGerFol(lEnd,cAnoMesRef)
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime folha ou gera SRZ para tipo de contrato DETERMINADO  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nTpContr == 2 .Or. nTpContr == 3
		cTpC  := "2"
		cTpC1 := "2"
		fImpGerFol(lEnd,cAnoMesRef)
	EndIf
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona arq. defaut do Siga caso Imp. Mov. Anteriores      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Empty( cAliasMov )
	fFimArqMov( cAliasMov , aOrdBag , cArqMov )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna ordem 1 dos arquivos processados                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SRC")
dbSetOrder(1)
dbSelectArea("SRI")
dbSetOrder(1)
dbSelectArea("SRA")
DbClearFilter()
dbSetOrder(1)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lGeraSRZ
	//--Gerar Rodape no filnal da Impressão
	Li := 58
	Impr("","F")
	Set Device To Screen
	If aReturn[5] = 1
		Set Printer To
		Commit
		ourspool(wnrel)
	Endif
	MS_FLUSH()
EndIf

Return .T.

*---------------------------------------------*
Static Function fSoma(aMatriz,cArq,cCod,nValor)
*---------------------------------------------*
// 1- Matriz onde os dados estao sendo armazenados
// 2- Tipo de Arquivo "C" ou "I"
// 3- Prov/Desc/Base a ser gravado

Local nRet
Local nVal1 := nVal2 := nVal3 := 0

If	cCod == Nil                  // Caso o Codigo nao seja passado
	If	cArq == "C"               // o tratamento e feito de acordo
		cCod := SRC->RC_PD        // com o cArq (Arquivo usado).
	Elseif cArq == "I"
		cCod := SRI->RI_PD
	Endif
Endif

If nValor == Nil
	If	cArq == "C"               // o tratamento e feito de acordo
		nValor := SRC->RC_VALOR        // com o cArq (Arquivo usado).
	Elseif cArq == "I"
		nValor := SRI->RI_VALOR
	Endif
Endif

If	cArq == "C"
	nVal1 := If(SRC->RC_QTDSEM > 0 .And. cIRefSem == "S", SRC->RC_QTDSEM, SRC->RC_HORAS)
	nVal2 := nValor
	nVal3 := SRC->RC_PARCELA
Elseif cArq == "I"                   // Carregando nVars de acordo
	nVal1 := If(SRI->RI_QTDSEM > 0, SRI->RI_QTDSEM, SRI->RI_HORAS)
	nVal2 := nValor
	nVal3 := 0
Endif

nRet := Ascan( aMatriz,{|X| x[1] == cCod } )   // Testa se ja existe
If	nRet == 0
	Aadd (aMatriz,{cCod,nVal1,nVal2,nVal3,1,"",""})  // se nao cria elemento
Else
	aMatriz[nRet,2] += nVal1                   // se ja so adiciona
	aMatriz[nRet,3] += nVal2
	aMatriz[nRet,4] += nVal3
	aMatriz[nRet,5] ++
Endif
Return Nil

*---------------------------*
Static Function fTestaTotal()      // Executa Quebras
*---------------------------*
Local cCusto
Local cItem
Local cClasse
Local nQ

cFilAnterior := SRA->RA_FILIAL
If nOrdem == 4 
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.) 
		dbSelectArea("SRI")
	Else
		dbSelectArea("SRC")
	EndIf    

	cCcAnt := cCcto
	cItAnt := cItCt
	cClAnt := cClVl

ElseIf nOrdem == 6 

	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.) 
		dbSelectArea("SRI")
	Else
		dbSelectArea("SRC")
	EndIf    

	cCcAnt := cCcto
	cItAnt := cItCt
	cClAnt := cClVl

Else
	cCcAnt := SRA->RA_CC
	If lTemItemRA .AND. lTemClVlRA .AND. lTemItemRI .AND. lTemClVlRI .AND. lTemItemRC .AND. lTemClVlRC
		cItAnt := SRA->RA_X_ITEM
		cClAnt := SRA->RA_X_SEGME
	Else
		cItAnt := ""
		cClAnt := ""	
    EndIf
    dbSelectArea( "SRA" )
	dbSkip()	

Endif

If lImpNiv .And. Len(aNiveis) > 0
	For nQ = 1 TO Len(aNiveis)
		cQ        := Str(nQ,1)
		cCcAnt&cQ := Subs(cCcAnt,1,aNiveis[nQ])
	Next nQ
Endif

If Eof() .Or. &cInicio > cFim
//	cCusto := If (nOrdem # 4 ,SRA->RA_CC, If(nRelat==4, SRI->RI_CC,SRC->RC_CC))
	cCusto := Quebra( nOrdem, nRelat, 'CC' )
	cItem  := Quebra( nOrdem, nRelat, 'IT' )
	cClasse:= Quebra( nOrdem, nRelat, 'CL' )
	fImpCc()
	fImpNiv(cCcAnt,.T.,cItAnt,cClAnt)
	fImpFil()
	fImpEmp()
	
Elseif cFilAnterior # If (nOrdem == 4 .or. nOrdem == 6,if(nRelat==4 , SRI->RI_FILIAL, SRC->RC_FILIAL),SRA->RA_FILIAL) 
	fImpCc()
	fImpNiv(cCcAnt,.T.,cItAnt,cClAnt)
	fImpFil()

Elseif cCcAnt # Quebra( nOrdem, nRelat, 'CC' ) .And. !Eof()
	//cCusto := If (nOrdem # 4 ,SRA->RA_CC, If(nRelat==4, SRI->RI_CC,SRC->RC_CC))
	cCusto := Quebra( nOrdem, nRelat, 'CC' )  
	cItem  := Quebra( nOrdem, nRelat, 'IT' )
	cClasse:= Quebra( nOrdem, nRelat, 'CL' )
	fImpCc()
	fImpNiv(cCusto,.F.,cItem,cClasse)

Endif


If nOrdem # 4 .and. nOrdem # 6
	dbSelectArea("SRA")
Else
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
		dbselectArea("SRI")
	Else
		dbSelectArea("SRC")
	EndIf
endif

Return Nil

*---------------------------------*
Static Function fImpFun(aFunP,aFunD,aFunB)            // Imprime um Funcionario
*---------------------------------*

If	Len(aFunP) == 0 .And. Len(aFunD) == 0 .And. Len(aFunB) == 0
	Return Nil
Endif

//-- Calculo % Acid. Trab. por Funcionario

If cEncInss == "N" .And. cPaisLoc == "BRA"
   fCalcAci(aFunB,aFunP,SRA->RA_FILIAL)
End   

If !lGeraSRZ .And. !lImpTot
	If cSinAna == "A"
		fImprime(aFunP,aFunD,aFunB,1)
	Endif              
EndIf

If lGeraSRZ .and. cEncInss == "S"
	fGrava(aFunP,aFunD,aFunB,1,SRA->RA_MAT)           // Gera Arquivo SRZ
Endif

aFunP := {}
aFunD := {}
aFunB := {}
Return Nil

*------------------*
Static Function fImpCc()             // Imprime Centro de Custo
*------------------*
Local nValBas := 0.00
Local nValAut := 0.00
Local nValPro := 0.00
Local nQ

If (Len(aCcP) == 0 .And. Len(aCcD) == 0 .And. Len(aCcB) == 0)
	
	// Zera variaveis do c.c. anterior
	aCcP := {}
	aCcD := {}
	aCcB := {}
	nCnor := nCafa := nCdem := nCfer := nCexc := nCtot := nCinss := cCadm := 0
	
	Return Nil
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resgata os valores utilizados na GPS         ³
//³que foram informados no parametro 15.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"
	fCalcCompl("2",cCcAnt,.F.,nOrdem)
Endif

if cEncInss == "N" .And. cPaisLoc == "BRA"
	If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5 .OR. nOrdem == 6
     	fCalcInss("2",cFilAnterior,cCcAnt)
	Endif
Endif
//--SomaToria para os Niveis de Quebra
If lImpNiv .And. Len(aNiveis) > 0
	For nQ:=1 To Len(aNiveis)
		cQ := Str(nQ,1)
		aEval(aCcP , { |X| fSomaNiv(aCcP&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		aEval(aCcD , { |X| fSomaNiv(aCcD&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		aEval(aCcB , { |X| fSomaNiv(aCcB&cQ,x[1],x[2],x[3],x[4],x[5]) } )
		nCnor&cQ  += nCnor
		nCafa&cQ  += nCafa
		nCdem&cQ  += nCdem
		nCfer&cQ  += nCfer
		nCexc&cQ  += nCexc
		nCtot&cQ  += nCtot
		nCadm&cQ  += nCadm		
	Next nQ
Endif
If cPaisLoc == "URU"       
	//So calcular se teve lanzada verba de salario mensal ou horista (se trabalhou) 
	//ou se esteve de ferias
	If aScan(aCcP,{|x| x[1] $ aCodFol[31,1]+"*"+aCodFol[32,1]+"*"+aCodFol[72,1]+"*"+aCodFol[22,1]+"*"+aCodFol[24,1]}) > 0
		LocBSEUru(@aCcB)
	Endif
Endif

If lGeraSRZ
	fGrava(aCcP,aCcD,aCcB,2,"zzzzzz")           // Gera Arquivo SRZ
Else
	If !lUnicNV .And. !lImpTot
		If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 6
			fImprime(aCcP,aCcD,aCcB,2) // Imprime
		Endif
	Endif
EndIf
aCcP := {}
aCcD := {}
aCcB := {}
nCnor := nCafa := nCdem := nCfer := nCexc := nCtot := nCinss := nCadm := 0
Return Nil

*-----------------------------*
Static Function fImpNiv(cCusto,lGeral,cItem,cClasse)     // Imprime Centro de Custo
*-----------------------------*
Local nQ
//-- Verifica se houve quebra dos Niveis de C.Custo
If nOrdem == 1 .Or. nOrdem == 4 .Or. nOrdem == 5 .Or. nOrdem == 6
	If !lGeraSRZ .And. lImpNiv .And. Len(aNiveis) > 0
		For nQ := Len(aNiveis) to 1 Step -1
			cQ := Str(nQ,1)
			//-- Verifica se houve quebra dos Niveis de C.Custo
			If mv_par18 == 3 .and. nQ != Len(aNiveis)
				Exit
			EndIf
			If Subs(cCusto,1,aNiveis[nQ]) # cCcAnt&cQ .Or. lGeral
				If (Len(aCcP&cQ) # 0 .Or. Len(aCcD&cQ) # 0 .Or. Len(aCcB&cQ) # 0)
					fImprime(aCcP&cQ,aCcD&cQ,aCcB&cQ,5,cCcAnt&cQ,cQ,cItAnt,cClAnt)
					aCcP&cQ   := {}
					aCcD&cQ   := {}
					aCcB&cQ   := {}
					nCnor&cQ  := 0
					nCafa&cQ  := 0
					nCdem&cQ  := 0
					nCfer&cQ  := 0
					nCexc&cQ  := 0
					nCtot&cQ  := 0
					nCadm&cQ  := 0 
				Endif
			Endif
		Next nQ
	Endif
Endif

Return Nil

*-----------------------*
Static Function fImpFil()            // Imprime Filial
*-----------------------*
If	Len(aFilP) == 0 .And. Len(aFilD) == 0 .And. Len(aFilB) == 0
	Return Nil
Endif
               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Resgata os valores utilizados na GPS         ³
//³que foram informados no parametro 15.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If cPaisLoc == "BRA"
	fCalcCompl("1","",.T.,nOrdem)
Endif

if cEncInss == "N" .And. cPaisLoc == "BRA"

	If nOrdem # 1 .And. nOrdem # 4 .And. nOrdem # 5 .And. nOrdem # 6
		fCalcInss("1",cFilAnterior)
	Endif
Endif
If cPaisLoc == "URU"
	LocCMcUru("1")
Endif
If lGeraSRZ
	fGrava(aFilP,aFilD,aFilB,3,"zzzzzz")
Else
	If lImpFil
		fImprime(aFilP,aFilD,aFilB,3)
	Endif
EndIf
aFilP := {}
aFilD := {}
aFilB := {}
nFnor := nFafa := nFdem := nFfer := nFexc := nFtot := nFinss := nFAdm := 0
Return Nil

*------------------*
Static Function fImpEmp()            // Imprime Empresa
*------------------*
If Len(aEmpP) == 0 .And. Len(aEmpD) == 0 .And. Len(aEmpB) == 0
	Return Nil
Endif
If cPaisLoc == "URU"
	LocCMcUru("1")
Endif
If lGeraSRZ
	fGrava(aEmpP,aEmpD,aEmpB,4,"zzzzzz")
Else
	If lImpEmp
		fImprime(aEmpP,aEmpD,aEmpB,4)
	Endif
EndIf
aEmpP := {}
aEmpD := {}
aEmpB := {}
nEnor := nEafa := nEdem := nEfer := nEexc := nEtot := nEinss := 0
nFuncs := 0
Return Nil

*-----------------------------------------------*
Static Function fImprime(aProv,aDesc,aBase,nTipo,cCt,cN,cIt,cCl)
*-----------------------------------------------*
// nTipo: 1- Funcionario
//        2- Centro de Custo
//        3- Filial
//        4- Empresa

Local nMaximo
Local nConta,nCon
Local nTVP := nTVD := nLIQ := 0   // Totais dos Valores
Local nTHP := nTHD := 0 		    // Referencias
Local cFil,cCc,cPd,nHrs,nVal,nOco
Local cCodFunc	:= ""
Local cDescFunc	:= ""

Private cNv := cN

aProv := ASort (aProv,,,{|x,y| x[1] < y[1] }) // Sorteando Arrays
aDesc := ASort (aDesc,,,{|x,y| x[1] < y[1] })
aBase := ASort (aBase,,,{|x,y| x[1] < y[1] })

nMaximo:= MAX(MAX(Len(aProv),Len(aDesc)),Len(aBase))
If	nTipo == 1
	If cQuebFun == "S"
	    If Li + nMaximo + 6 >= 58  // Testa somente quando e funcionario
			Impr("","P")            // Salta Pagina caso nao caiba
		EndIf	
	Endif
Elseif nTipo == 2
	If lSalta
		Impr("","P")
	Endif
Else
	Impr("","P")
Endif

If cPaisLoc == "URU"
	WCabec1 := STR0023+aInfo[3]+" "+If(nTipo#4,STR0027+cFilAnterior+" - "+aInfo[1],Space(26))+Space(23)	//"Empresa: "
Else
	WCabec1 := STR0023+aInfo[3]+" "+If(nTipo#4,STR0027+cFilAnterior+" - "+aInfo[1],Space(26))+Space(23)+STR0024+If(cTpC$' *1',STR0025,STR0026)	//"Empresa: "###" Contrato do Tipo : "###"Indeterminado"###"Determinado"
Endif
If nTipo == 1 

	/*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  ³ Carrega Funcao do Funcion. de acordo com a Dt Referencia     ³
	  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
	fBuscaFunc(dDataRef,@cCodFunc, @cDescFunc ) 

	DET:= ALLTRIM(STR0028)		 //" C.CUSTO: "
	If cTipCC == 1              //-- Codigo
		Det:= Det + If (nOrdem # 4 .and. nOrdem # 6,Subs(SRA->RA_CC+Space(20),1,20),Subs(cCcto+Space(20),1,20))
	ElseIf cTipCC == 2          //-- Descricao
		Det:= Det + DescCc(If(nOrdem # 4 .and. nOrdem # 6,SRA->RA_CC,cCcto),cFilAnterior,18)
	ElseIf cTipCC == 3          //-- Ambos
		Det:= Det + AllTrim(Subs(If(nOrdem # 4 .and. nOrdem # 6,SRA->RA_CC,cCcto)+Space(20),1,20))+"-"+DescCc(If(nOrdem # 4 .and. nOrdem # 6,SRA->RA_CC,cCcto),cFilAnterior,20)
	Endif
	Det:= Det+STR0029+SRA->RA_MAT+STR0030+Subs(SRA->RA_NOME,1,30)+;									//" MAT.: "###" NOME: "
	      STR0031 + cCodFunc + " " + cDescFunc															 //" FUNCAO: "

	 If ExistBlock("GP040Det")
     cDetAux	:= ExecBlock( "GP040Det" , .F. , .F. , { "1", DET } , .F. )
     	If !empty(cDetAux) .and. valtype(cDetAux) == "C"
 			DET      := cDetAux
     	Endif
     EndIf     
Elseif nTipo == 2
	DET:= STR0032+cFilAnterior+STR0035+cCcAnt+DescCc(cCcAnt,cFilAnterior)+If(nOrdem==6," - "+cItAnt+cClAnt,'')//"Filial: "###" C.CUSTO: "
Elseif nTipo == 3
	DET:= STR0033+cFilAnterior+" - "+aInfo[1]		//"Filial: "
Elseif nTipo == 4
	DET:= STR0034+aInfo[3]		//"Empresa: "
Elseif nTipo == 5

	cDESCSEG := " - SEGMENTO: "+ALLTRIM(SRA->RA_X_SEGME)+"-"+ALLTRIM(POSICIONE("CTH",1,xFilial("CTH")+SRA->RA_X_SEGME,"CTH_DESC01"))
	DET:= STR0033+cFilAnterior+STR0035+cCt+" - "+DescCc(ALLTRIM(cCt),ALLTRIM(cFilAnterior))+If(nOrdem==6,cDESCSEG,'')//"Filial: "###" C.CUSTO: "

	/*
	If cCt # Nil
		DET:= STR0033+cFilAnterior+STR0035+cCt+" - "+DescCc(cCt,cFilAnterior)+If(nOrdem==6," - "+cIt+cCl,'')//"Filial: "###" C.CUSTO: "
	Else
		DET:= STR0033+cFilAnterior+STR0035+cCcAnt+"-"+DescCc(cCcAnt,cFilAnterior)+If(nOrdem==6," - "+cItAnt+cClAnt,'')	//"Filial: "###" C.CUSTO: "
	Endif
	*/
Endif
IMPR(DET,"C")

If	nTipo == 1
	//--vERIFICA SE EXISTEW O CAMPO PARA IMPRESSAO
	If Type("SRA->RA_NOMECOM") # "U" .And. ! Empty(SRA->RA_NOMECOM)
		Det := 	STR0067+" "+SRA->RA_NOMECOM
		IMPR(DET,"C")	
	Endif	
	DET:= STR0036+Dtoc(SRA->RA_ADMISSA)+STR0037+fDesc("SX5","28"+SRA->RA_CATFUNC,"X5DESCRI()",12,SRA->RA_FILIAL)+" "
	If !Empty( cAliasMov )
		nValSal := 0
		nValSal := fBuscaSal(dDataRef,,,.f.)
		If nValSal ==0
			nValSal := SRA->RA_SALARIO
		EndIf
	Else
		nValSal := SRA->RA_SALARIO
	EndIf
	DET+= STR0043+TRANSFORM(nValSal,"@E 999,999,999.99")+STR0044		//"SAL.: "###"  DEP.I.R.: "
	DET+= SRA->RA_DEPIR+STR0045+SRA->RA_DEPSF+Iif(nRelat<4,STR0046+StrZero(SRA->RA_PERCADT,3) + " %","")+" HR.MES: "	//"  DEP.SAL.FAM.: "###"  PERC.ADTO: "
	DET+= STR(SRA->RA_HRSMES,6,2)
	 If ExistBlock("GP040Det")
     cDetAux	:= ExecBlock( "GP040Det" , .F. , .F. , { "2", DET } , .F. )
     	If !empty(cDetAux) .and. valtype(cDetAux) == "C"
 			DET      := cDetAux
     	Endif
     EndIf     
Else
	Det:=" "
Endif
IMPR(DET,"C")
DET:= SPACE(15)+STR0047+SPACE(30)+STR0048+SPACE(30)+STR0049	//"P R O V E N T O S"###"D E S C O N T O S"###"B A S E S"
IMPR(DET,"C")

If cRefOco == 2 .And. cSinAna == "S"   //-- Ocorrencia
	Det := STR0050					//"COD DESCRICAO         OCOR.          VALOR PC|"
	Det += space(1)+STR0050		//"COD DESCRICAO         OCOR.          VALOR PC|"
	Det += space(1)+STR0051		//"COD DESCRICAO              VALOR OCOR."
Else
	Det := STR0052				//"COD DESCRICAO          REF.          VALOR PC|"
	Det += space(1)+STR0052		//"COD DESCRICAO          REF.          VALOR PC|"
	Det += space(1)+STR0053		//"COD DESCRICAO                VALOR"
Endif

IMPR(DET,"C")

If cRefOco == 2 .And. cSinAna == "S"   //-- Ocorrencia
	
	For nConta :=1 TO nMaximo
		Det:= If (nConta > Len(aProv),Space(45),aProv[nConta,1]+" "+Left(DescPd(aProv[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aProv[nConta,5],'99999999')+" "+Transform(aProv[nConta,3],'@E 999,999,999.99')+" "+StrZero(aProv[nConta,4],2))+"| "
		Det +=If (nConta > Len(aDesc),Space(45),aDesc[nConta,1]+" "+Left(DescPd(aDesc[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aDesc[nConta,5],'99999999')+" "+Transform(aDesc[nConta,3],'@E 999,999,999.99')+" "+StrZero(aDesc[nConta,4],2))+"| "
		Det +=If (nConta > Len(aBase),Space(36),aBase[nConta,1]+" "+Left(DescPd(aBase[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
		Transform(aBase[nConta,3],'@E 99,999,999.99')+" "+Transform(aBase[nConta,5],'@E 99999'))
		Impr(Det,"C")
	Next nConta
	
Else
	
	For nConta :=1 TO nMaximo
		Det:= If (nConta > Len(aProv),Space(46),aProv[nConta,1]+" "+Left(DescPd(aProv[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
				Transform(aProv[nConta,2],'999999.99')+" "+Transform(aProv[nConta,3],'@E 999,999,999.99')+" "+StrZero(aProv[nConta,4],2))+"| "
		Det +=If (nConta > Len(aDesc),Space(46),aDesc[nConta,1]+" "+Left(DescPd(aDesc[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+" "+;
				Transform(aDesc[nConta,2],'999999.99')+" "+Transform(aDesc[nConta,3],'@E 999,999,999.99')+" "+StrZero(aDesc[nConta,4],2))+"| "
		Det +=If (nConta > Len(aBase),Space(37),aBase[nConta,1]+" "+Left(DescPd(aBase[nConta,1],If(nTipo = 1,SRA->RA_FILIAL,cFilAnterior)),14)+"  "+;
				Transform(aBase[nConta,3],'@E 999,999,999.99'))
		Impr(Det,"C")
	Next nConta
	
Endif

AeVal(aProv,{ |X| nTHP += X[2]})	// Acumula Referencias
AeVal(aDesc,{ |X| nTHD += X[2]})
AeVal(aProv,{ |X| nTVP += X[3]})	// Acumula Valores
AeVal(aDesc,{ |X| nTVD += X[3]})

nLIQ := nTVP - nTVD
DET  := REPLICATE("-",132)
IMPR(DET,"C")

DET :=STR0054+If(cRefOco == 2 .and. cSinAna == "S",SPACE(5) ,SPACE(06))             +TRANSFORM(nTHP,"9999999999.99")+" "+TRANSFORM(nTVP,"@E 999,999,999.99")+;	//"TOTAIS ->"
      SPACE(20)                                                                       +TRANSFORM(nTHD,"9999999999.99")+" "+TRANSFORM(nTVD,"@E 999,999,999.99")+;
              If(cRefOco ==2 .and. cSinAna == "S" ,SPACE(09),SPACE(12) )+STR0062+" "+TRANSFORM(nLIQ,"@E 999,999,999.99")					//"SALARIO LIQ."
IMPR(DET,"C")

DET:=REPLICATE("-",132)
IMPR(DET,"C")

If nTipo # 1
	Det:=STR0055+Strzero(If(nTipo==2,nCnor,If(nTipo==3,nFnor,If (nTipo==4,nEnor,nCnor&cNv))),5)		//"Sit.Normal: "
	Det+=STR0068+Strzero(If(nTipo==2,nCadm,If(nTipo==3,nFadm,If (nTipo==4,nEadm,nCadm&cNv))),5)		//" Admitidos: "	
	Det+=STR0056+Strzero(If(nTipo==2,nCafa,If(nTipo==3,nFafa,If (nTipo==4,nEafa,nCafa&cNv))),5)		//" Afastados: "
	Det+=STR0057+Strzero(If(nTipo==2,nCdem,If(nTipo==3,nFdem,If (nTipo==4,nEdem,nCdem&cNv))),5)		//" Demitidos:"
	Det+=STR0058+Strzero(If(nTipo==2,nCfer,If(nTipo==3,nFfer,If (nTipo==4,nEfer,nCfer&cNv))),5)		//" Ferias:"
	Det+=STR0060+Strzero(If(nTipo==2,nCexc,If(nTipo==3,nFexc,If (nTipo==4,nEexc,nCexc&cNv))),5)		//" Outros C.Custo:"
	Det+=STR0061+Strzero(If(nTipo==2,nCtot,If(nTipo==3,nFtot,If (nTipo==4,nEtot,nCtot&cNv))),5)		//" Total:"
	
	Impr (Det,"C")
	IMPR(REPL("=",132),"C")   // Salta Pagina apos Quebra Cc/Filial/Empresa
	If nTipo # 2 .Or. (nTipo == 2 .And. lSalta)
		Impr("","P")
	Else
		Impr("","C")
	Endif
Endif

Return Nil

*------------------------------------*
Static Function fGrava(aProv,aDesc,aBase,nTipo,cMat) // Grava Guia de Inss
*------------------------------------*
Local  nMaximo
Local  nConta,nCon
Local lTemItem		:= SRZ->( FieldPos( "RZ_ITEM" ) # 0 )
Local lTemClVl		:= SRZ->( FieldPos( "RZ_CLVL" ) # 0 )
Private aArray		:={aProv,aDesc,aBase}  // Controlador de Arrays
Private nTpGravSRZ:= nTipo				  // Informa qual tipo de registro esta sendo gravado no SRZ
												  // 1=Funcionario  2=C.Custo   3=Filial   4=Empresa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Ponto de Entrada para alterar o conteudo do array aArray antes |
//| da gravacao das verbas do funcionario no SRZ.                  |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock("GP040SRZ")
	EXECBLOCK("GP040SRZ",.F.,.F.)
EndIf

nMaximo:= MAX(MAX(Len(aArray[1]),Len(aArray[2])),Len(aArray[3]))

FOR nConta :=1 TO nMaximo
	dbSelectArea( "SRZ" )
	
	If nTipo == 1                  
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := cCcto
		If lTemItem .AND.lTemClVl
			M->RZ_ITEM   := cItCt
			M->RZ_CLVL   := cClVl
		EndIf	
	Elseif nTipo == 2
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := cCcAnt
		If lTemItem .AND.lTemClVl
			M->RZ_ITEM   := cItAnt
			M->RZ_CLVL   := cClAnt
	    EndIf
	Elseif nTipo == 3
		M->RZ_FILIAL := cFilAnterior
		M->RZ_CC     := "zzzzzzzzz"
		If lTemItem .AND.lTemClVl
			M->RZ_ITEM   := "zzzzzzzzz"
			M->RZ_CLVL   := "zzzzzzzzz"
		EndIf
	Elseif nTipo == 4
		M->RZ_FILIAL := "zz"
		M->RZ_CC     := "zzzzzzzzz"
		If lTemItem .AND.lTemClVl
			M->RZ_ITEM   := "zzzzzzzzz"
			M->RZ_CLVL   := "zzzzzzzzz"
		EndIf	
	Endif
	
	For nCon := 1 To 3
		If nConta <= Len(aArray[nCon])
			If nTipo == 4             
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//| Testa chave para os casos onde SRV for compartilhado e existir |
				//| cod.de verba iguais para eventos diferentes.                   |
				//| Teste somente necessario no total por Empresa                  |
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If ! dbSeek(M->RZ_FILIAL + M->RZ_CC + aArray[nCon,nConta,1] + cTpC ) 
					RecLock("SRZ",.T.,.T.)
				Else
					RecLock("SRZ",.F.,.T.)
				Endif
			Else
				RecLock("SRZ",.T.)
			Endif 
			SRZ->RZ_FILIAL  := M->RZ_FILIAL
         	If cPaisLoc == "URU" .And. aArray[nCon,nConta,1]== aCodFol[312,1]
         		SRZ->RZ_CC		:= cCCCuota
         	Else
				SRZ->RZ_CC      := M->RZ_CC
        	Endif
			SRZ->RZ_PD      := aArray[nCon,nConta,1] // usa o Controlador
			SRZ->RZ_HRS     := aArray[nCon,nConta,2]
			SRZ->RZ_VAL     := aArray[nCon,nConta,3]
			SRZ->RZ_OCORREN := aArray[nCon,nConta,5]
			SRZ->RZ_TPC     := cTpC
			SRZ->RZ_TIPO    := If(nRelat==4,"13","FL")
			If Type("SRZ->RZ_MAT") # "U"
				SRZ->RZ_MAT     := cMat
			Endif		
			If cPaisLoc == "DOM"
				SRZ->RZ_SEMANA := cSemana
			Endif	
			If lTemItem
				SRZ->RZ_ITEM	:= aArray[nCon,nConta,6]
			Endif
			If lTemClVl
				SRZ->RZ_CLVL	:= aArray[nCon,nConta,7]
			Endif

			MsUnlock()
		Endif
	Next nCon
Next nConta

If nTipo <> 1
	RecLock("SRZ",.T.)
	If nTipo == 2
		SRZ->RZ_FILIAL  := cFilAnterior
		SRZ->RZ_CC      := cCcAnt
		SRZ->RZ_OCORREN := nCinss
		If lTemItem .AND.lTemClVl
			SRZ->RZ_ITEM   := cItAnt
			SRZ->RZ_CLVL   := cClAnt
	    EndIf
	Elseif nTipo == 3
		SRZ->RZ_FILIAL  := cFilAnterior
		SRZ->RZ_CC      := "zzzzzzzzz"
		SRZ->RZ_OCORREN := nFinss 
		If lTemItem .AND.lTemClVl
			SRZ->RZ_ITEM   := "zzzzzzzzz"
			SRZ->RZ_CLVL   := "zzzzzzzzz"
		EndIf	
	Elseif nTipo == 4
		SRZ->RZ_FILIAL  := "zz"
		SRZ->RZ_CC      := "zzzzzzzzz"
		SRZ->RZ_OCORREN := nEinss 
		If lTemItem .AND.lTemClVl
			SRZ->RZ_ITEM   := "zzzzzzzzz"
			SRZ->RZ_CLVL   := "zzzzzzzzz"
		EndIf	
	Endif
	SRZ->RZ_PD   := "zzz"
	SRZ->RZ_TPC  := cTpC					  // grava tipo de contrato
	SRZ->RZ_TIPO := If(nRelat==4,"13","FL") // grava tipo de lacto contabil
	If TYPE("SRZ->RZ_MAT") # "U"
		SRZ->RZ_MAT  := cMat
	Endif	
	If cPaisLoc == "DOM"	   
		SRZ->RZ_SEMANA := cSemana
	Endif	
	MsUnlock()
Endif	
dbSelectArea( "SRA" )
Return Nil

*------------------------------------------*
Static Function fCalcInss(cTipo,cFil,cCusto)
*------------------------------------------*
Local nValBas  := 0.00
Local nValAut  := 0.00
Local nValPro  := 0.00
Local nValCus  := 0.00
Local nPercPro := 0.00
Local nPercAut := 0.00
Local lCct     := If (cCusto # Nil,.T.,.F.)
Local nPercFPAS:=0
Local nBasePis := 0.00
Local nValPis  := 0.00
Local nPerc

// Verifica o % de Acidente do C.Custo
If lCct
	dbSelectArea("SI3")
	If ( cFil # Nil .And. cFilial == "  " ) .Or. cFil == Nil
		cFil := cFilial
	Endif
	nPercFPAS := 0
	If dbSeek( cFil + cCusto )
		nPercFPAS    := SI3->I3_PERFPAS / 100
	Endif
	
	If nPercFPAS > 0
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Deducao do percentual pago por convenios                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nDed := 0
		For nPerc = 9 TO 19
			nDed += aInssEmp[nPerc,Val(cTpc)]
		Next nPerc
		
		nDed += aInssEmp[22,Val(cTpc)]
		nDed += aInssEmp[23,Val(cTpc)]
		nDed += fP15Terc(cCusto,aGPSPer,"*") //Deduzir o % de terceiros do parametro 15
		
		nPercFPAS -= nDed
	Endif
	
Endif
//-- Montar a Base Total de Inss
If cTipo == "1"
	aEval(aFilB,{ |x| nValBas += If ( X[1]$ cContribuicao ,x[3],0.00) })
Else
	aEval(aCcB,{ |x| nValBas += If ( X[1]$ cContribuicao ,x[3],0.00) })
EndIf
//--Inss s/Prolabore e Autonomo
If aCodfol[221,1] # Space(3)
	If cTipo == "1"
		aEval(aFilB,{ |x| nValPro += If ( X[1]$ aCodFol[221,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nValPro += If ( X[1]$ aCodFol[221,1] ,x[3],0.00) })
	EndIf
	nPercPro := PosSrv( aCodFol[221,1],cFilAnterior,"RV_PERC") / 100
	If nPercPro = 1.00 .Or. (nPercPro = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercPro := 0.20
	Endif
	nValPro := Round(nValPro * nPercPro,2)
Endif
If aCodFol[225,1] # Space(3)
	If cTipo == "1"
		aEval(aFilB,{ |x| nValAut += If ( X[1]$ aCodfol[225,1] ,x[3],0.00) })
	else
		aEval(aCcB,{ |x| nValAut += If ( X[1]$ aCodfol[225,1] ,x[3],0.00) })
	EndIf	
	nPercAut	 := PosSrv( aCodFol[225,1],cFilAnterior,"RV_PERC") / 100
	If nPercAut = 1.00 .Or. (nPercAut = 0.00 .And. aInssemp[1,Val(cTpc)] > 0.00)
		nPercAut := 0.20
	Endif
	nValAut := Round(nValAut * nPercAut,2)
Endif
//--Gravar Inss Empresa Sobre Pro-Labore/Autonomo
If nValAut+nValPro > 0
	fSomaInss(cTipo,aCodFol[148,1],nValAut+nValPro )  // Inss Emp.
Endif

//-- Montar Base de Calculo do Pis Empresa
If aCodFol[229,1] # Space(3)
	aEval(aCcP,{ |x| nBasePis += If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S",x[3],0.00) })
	aEval(aCcB,{ |x| nBasePis += If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S" .and. PosSrv(X[1],cFilAnterior,"RV_TIPOCOD")=="3",x[3],0.00) } )
	aEval(aCcD,{ |x| nBasePis -= If ( PosSrv(X[1],cFilAnterior,"RV_PIS")=="S",x[3],0.00) })
	If nBasePis > 0
		nPercPis  := PosSrv( aCodFol[229,1],cFilAnterior,"RV_PERC") / 100
		nValPis   := nBasePis * nPercPis
	Endif
	//--Gerar Base e Valor Pis Empresa
	If nValPis > 0
		fSomaInss(cTipo,aCodFol[223,1],nBasePis)
		If aCodFol[229,1] # Space(3)
			fSomaInss(cTipo,aCodFol[229,1],nValPis)
		Endif
	Endif
Endif

//-- Calcular Inss Empresa
If nValBas > 0.00
	fSomaInss(cTipo,aCodFol[148,1],Round(nValBas * aInssemp[1,Val(cTpc)],2) )  // Inss Emp.
	fSomaInss(cTipo,aCodFol[149,1],Round(nValBas * If (nPercFPAS > 0, nPercFPAS ,aInssemp[2,Val(cTpc)]),2)  )  // Terceiros
	//	fSomaInss(cTipo,aCodFol[150,1],Round(nValBas * If (lCct,aInssEmp[21,Val(cTpc)],aInssEmp[3,Val(cTpc)]),2) )  // Ac.Trab.
	fSomaInss(cTipo,aCodFol[204,1],Round(nValBas * (aInssemp[09,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[204,1])),2)  ) // Sal.Educ.
	fSomaInss(cTipo,aCodFol[184,1],Round(nValBas * (aInssemp[10,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[184,1])),2) )  // Incra
	fSomaInss(cTipo,aCodFol[185,1],Round(nValBas * (aInssemp[11,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[185,1])),2) )  // Senai
	fSomaInss(cTipo,aCodFol[186,1],Round(nValBas * (aInssemp[12,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[186,1])),2) )  // Sesi
	fSomaInss(cTipo,aCodFol[187,1],Round(nValBas * (aInssemp[13,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[187,1])),2) )  // Senac
	fSomaInss(cTipo,aCodFol[188,1],Round(nValBas * (aInssemp[14,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[188,1])),2) )  // Sesc
	fSomaInss(cTipo,aCodFol[189,1],Round(nValBas * (aInssemp[15,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[189,1])),2) )  // Sebrae
	fSomaInss(cTipo,aCodFol[190,1],Round(nValBas * (aInssemp[16,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[190,1])),2) )  // Dpc
	fSomaInss(cTipo,aCodFol[191,1],Round(nValBas * (aInssemp[17,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[191,1])),2) )  // Faer
	fSomaInss(cTipo,aCodFol[192,1],Round(nValBas * (aInssemp[18,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[192,1])),2) )  // Senab
	fSomaInss(cTipo,aCodFol[193,1],Round(nValBas * (aInssemp[19,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[193,1])),2) )  // Seconc
	fSomaInss(cTipo,aCodFol[200,1],Round(nValBas * (aInssemp[22,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[200,1])),2) )  // Sest
	fSomaInss(cTipo,aCodFol[201,1],Round(nValBas * (aInssemp[23,Val(cTpc)]+fP15Terc(cCusto,aGPSPer,aCodFol[201,1])),2) )  // Senat
Endif

// Montar Base Para Provisao Simplificada Ferias /  13o / Rescisao
aEval(aCcP,{ |x| nValCus += If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })
aEval(aCcD,{ |x| nValCus -= If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })
aEval(aCcB,{ |x| nValCus += If ( PosSrv( x[1],cFilAnterior,"RV_CUSTO")='S',x[3],0.00) })

// Calcular Provisao Simplificada
If nValCus > 0.00
	fSomaInss(cTipo,aCodFol[194,1],nValCus * aInssemp[6,Val(cTpc)] )  // Prov. Ferias
	fSomaInss(cTipo,aCodFol[195,1],nValCus * aInssemp[5,Val(cTpc)] )  // Prov. 13o.
	fSomaInss(cTipo,aCodFol[196,1],nValCus * aInssemp[20,Val(cTpc)] )  // Prov. Rescisao
Endif
Return

*-----------------------------------------*
Static Function fSomaInss(cTipo,cCod,nVal2)
*-----------------------------------------*
If cCod # Space(3) .And. nVal2 # 0
	If cTipo = "2"
		// Array Centro de Custo
		nRet := aScan( aCcB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aCcB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aCcB[nRet,3] += nVal2
			aCcB[nRet,5] ++
		Endif
	Endif
	If cTipo = "2" .Or. cTipo = "1"
		//-- Array Filial
		nRet := aScan( aFilB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aFilB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aFilB[nRet,3] += nVal2
			aFilB[nRet,5] ++
		Endif
		//-- Array Empresa
		nRet := aScan( aEmpB,{|X| x[1] == cCod } )   // Testa se ja existe
		If nRet == 0
			Aadd(aEmpB,{cCod,0.00,nVal2,0.00,1})      // se nao cria elemento
		Else
			aEmpB[nRet,3] += nVal2
			aEmpB[nRet,5] ++
		Endif
	Endif
Endif
Return

*--------------------------------------*
Static Function fSomaNiv(aMatriz,cVerba,nHorCc,nValCc,nParCc,nQtdCc)
*--------------------------------------*
// 1- Matriz onde os dados estao sendo armazenados
// 2- elemrnto a ser somado

Local nRet
nRet := Ascan( aMatriz,{|X| x[1] == cVerba } )   // Testa se ja existe
If	nRet == 0
	Aadd (aMatriz,{cVerba,nHorCc,nValCc,nParCc,nQtdCc})  // se nao cria elemento
Else
	aMatriz[nRet,2] += nHorCc                   // se ja so adiciona
	aMatriz[nRet,3] += nValCc
	aMatriz[nRet,4] += nParCc
	aMatriz[nRet,5] += nQtdCc
Endif
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para Escolher o Arquivo Mensal                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*--------------------------------*
Static Function fArquivoRC()
*--------------------------------*
Local MvRet,ni
Local nOpcao := 0, nOk := 2
Local oDlg, oWnd, oListbox
Local cVarq
Local nPosLis := 1
nLin1   := .5
nCol1   := 2
cFiltro := "RC*" + GetDBExtension()          //Filtro na procura do arquivo no Windows
cPesq   := "SRC"              //Arquivo de pesquisa no SX2
cPath   := ""
#IFDEF TOP
	Private aTables := {}
	Private oOk   := LoadBitmap( GetResources(), "LBOK" )  //Botao OK
	Private oNo   := LoadBitmap( GetResources(), "LBNO" )  //Botao CANCEL
#ELSE
	cAlias := Alias()
	dbSelectArea( "SX2" )
	dbSeek(cPesq)
	cPath := TRIM(Sx2->X2_PATH)
#ENDIF

MvRet:=Alltrim(ReadVar())      // Carrega Nome da Variavel do Get em Questao

#IFDEF TOP
	USE TOP_FILES ALIAS "TOP" VIA "TOPCONN" SHARED NEW
	nTables := 0
	While !Eof()
		If SubS(FNAMF1,1,4) # "TOP_" .AND. SubS(FNAMF1,1,2) == "RC"
			nTables++
			If nTables < 4096
				AADD(aTables,FNAMF1)
			Else
				Alert("Too many tables.","Attention")
				Exit
			Endif
		Endif
		dbSkip()
	EndDo
	dbCloseArea()
	ASORT(aTables,,, { |x, y| x > y })
	If Len(aTables) # 0
		DEFINE MSDIALOG oDlg FROM 5, 5 TO 16, 39 TITLE STR0065
		@ nLin1,nCol1 LISTBOX oListBox VAR cVarQ Fields HEADER STR0064 SIZE 102,60 ;
		ON DBLCLICK (nOk := 1,oDlg:End()) ENABLE OF oDlg
		oListBox:SetArray(aTables)
		oListBox:bLine := { ||{aTables[oListBox:nAt]}}
		DEFINE SBUTTON FROM 068,62 TYPE 1 ACTION (nOk := 1,nPosLis:=oListBox:nAt,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 068,90 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED
		If nOk == 1
			&MvRet := aTables[nPosLis]
		Else
			&MvRet := SPACE(30)  // Devolve Resultados
		EndIf
		DeleteObject(oOk)
		DeleteObject(oNo)
	Else
		Help(" " , 1 , "GPSARQM" )
		&MvRet := SPACE(30)  // Devolve Resultado
		Return .T.
	EndIf
#ELSE
	If cFiltro == Nil
		oWnd := GetWndDefault()
	Endif
	cFile := cGetFile(cFiltro,OemToAnsi(STR0065) ) //"Selecione o Arquivo"
	If Empty(cFile)
		Return(.F.)
	Elseif Len(Alltrim(cFile)) > 30
		Help(" " , 1 , "GP140TAMAN" )
	Endif
	&MvRet := cFile+SPACE(30-LEN(cFile))
	If oWnd != Nil
		GetdRefresh()
	Endif
#ENDIF

Return .T.

**************************************
Static Function fCalcAci(aFunB,aFunP,cFil)
**************************************
Local nBasAci  := 0
Local nValAci  := 0
Local lPercSRA := .F.

//-- Calculo do % Acid. de Trabalho Por Funcionario / C.Custo ou Filial
nPercAci := aInssEmp[3,Val(cTpc)]  //-- Ac.Trab.
If Type("SRA->RA_PERCSAT") # "U" .And. SRA->RA_PERCSAT > 0
	nPercAci := SRA->RA_PERCSAT / 100
	lPercSRA := .T.
Else
	//-- Verifica o % de Acidente do C.Custo
	dbSelectArea("SI3")
	If ( cFil # Nil .And. cFilial == "  " ) .Or. cFil == Nil
		cFil := cFilial
	Endif
	If dbSeek( cFil + cCCto ) .And. SI3->I3_PercAci > 0
		nPercAci := SI3->I3_PercAci / 100
	Endif
Endif

//--Montar a Base Total de Inss
If SRA->RA_CATFUNC $ "P*A" .And. lPercSRA
	aEval(aFunP,{ |x| nBasAci += If ( X[1]$ cContrProAuto ,x[3],0.00) })
Else
	aEval(aFunB,{ |x| nBasAci += If ( X[1]$ cContribuicao ,x[3],0.00) })
EndIf
nValAci := Round(nBasAci * nPercAci,2)

If nValAci # 0
	fSoma(@aFunB,"C",aCodFol[150,1],nValAci)
	fSoma(@aCcB ,"C",aCodFol[150,1],nValAci)
	fSoma(@aFilB,"C",aCodFol[150,1],nValAci)
	fSoma(@aEmpB,"C",aCodFol[150,1],nValAci)
Endif
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fBuscaSlr ³ Autor ³ R.H. - Marina         ³ Data ³ 14.01.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica se houve aumento salarial em Movimentos Anteriores³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fBuscaSlr(Filial,Matricula,Data)                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fBuscaSlr(nValSal,cAnoMesRef)
Local cAlias := Alias()

dbSelectArea("SR3")
If dbSeek(SRA->RA_FILIAL + SRA->RA_MAT)
	While !Eof() .And. SR3->R3_FILIAL+SR3->R3_MAT == SRA->RA_FILIAL+SRA->RA_MAT .And.;
		MesAno(SR3->R3_DATA) <= cAnoMesRef
		nValSal := SR3->R3_VALOR
		dbSkip()
	Enddo
EndIf
dbSelectArea(cAlias)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fImpGerFol³ Autor ³ R.H.                  ³ Data ³ 14.01.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime a folha ou gera o arquivo SRZ.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ 	fImpGerFol(lEnd,cAnoMesRef)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fImpGerFol(lEnd,cAnoMesRef)
Local lInssFun    := .F.
Local aFunP       := {}
Local aFunD   	  := {}
Local aFunB   	  := {}
Local aCodBenef   := {}
Local cBuscaSRA   := ""
Local cBuscaSRI   := ""
Local cAcessaSRA  := &("{ || " + ChkRH("GPER040","SRA","2") + "}")
Local cAcessaSRC  := &("{ || " + ChkRH("GPER040","SRC","2") + "}")
Local cAcessaSRI  := &("{ || " + ChkRH("GPER040","SRI","2") + "}")
Local cTipAfas    := " "
Local dDtAfas
Local dDtRet
Local dDtPesqAf
Local lCotFun	  := .F.

Private aGPSVal := {}
Private aGPSPer := {} // Carrega os percentuais de terceiros do parametro 15

dbSelectArea( "SRA" )
dbGoTop()

If nOrdem == 1
	dbSetOrder( 2 )
	dbSeek(cFilDe + cCcDe + cMatDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim     := cFilAte + cCcAte + cMatAte
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
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
		dbSelectarea("SRI")
		dbSetOrder(2)
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio := "SRI->RI_FILIAL + SRI->RI_CC+ SRI->RI_MAT"
		cFim    := cFilAte + cCcAte + cMatAte
	Else
		dbSelectArea("SRC")
		dbSetOrder( 2 )
		dbSeek(cFilDe + cCcDe + cMatDe,.T.)
		cInicio  := "SRC->RC_FILIAL + SRC->RC_CC + SRC->RC_MAT"
		cFim     := cFilAte + cCcAte + cMatAte
	EndIf

ElseIf nOrdem == 5
	dbSetOrder( 8 )
	dbSeek(cFilDe + cCcDe + cNomDe,.T.)
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_NOME"
	cFim     := cFilAte + cCcAte + cNomAte

ElseIf nOrdem == 6
	If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)

		SRA->(dbOrderNickName("CLVLMAT"))
		dbSeek(cFilDe + cSegDe + cMatDe,.T.)		
		cInicio  := "SRA->RA_FILIAL + SRA->RA_X_SEGME + SRA->RA_MAT"
		cFim     := cFilAte + cSegAte + cMatAte

	Else
		
		dbSelectArea("SRC")
		dbOrderNickName("CLVLMAT") //--RC_FILIAL+RC_X_CLVL+RC_CC+RC_X_ITEMC+RC_MAT
		dbSeek(cFilDe + cSegDe + cCcDe + Space( TamSX3('RC_X_ITEMC')[1] ) + cMatDe, .T.)		
		cInicio  := "SRC->RC_FILIAL + SRC->RC_X_CLVL + SRC->RC_CC + SRC->RC_X_ITEMC + SRC->RC_MAT"
		cFim     := cFilAte + cSegAte + cCcAte + Replicate('Z', TamSX3('RC_X_ITEMC')[1] ) + cMatAte
		
	EndIf

Endif

dbSelectArea( "SRA" )
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega Regua de Processamento                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lGeraSRZ
	ProcRegua(SRA->(RecCount()))
Else
	SetRegua(SRA->(RecCount()))
EndIf

cFilAnterior := Space(02)
cCcAnt  	 := Space(09)

nEnor := nEafa := nEdem := nEfer := nEexc := nEtot := nEadm := 0  // Totalizadores Empresa
nFnor := nFafa := nFdem := nFfer := nFexc := nFtot := nFadm := 0  //               Filial
nCnor := nCafa := nCdem := nCfer := nCexc := nCtot := nCadm := 0			 //               Centro Custo
nCinss := nFinss := nEinss := 0      //-Totalizador dos func. con ret. Inss
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estas variaveis nao devem, se declaradas, pois devem ser     ³
//³ declaradas na funcao chamadora.(pode ser externa).           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nFuncs 		:= 0
aFuncsBSE	:=	{}
If nOrdem # 4 .AND. nOrdem # 6  
	dbSelectArea( "SRA" )
Else // Encargos por  C.Custo
	If nRelat ==4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
		dbselectArea("SRI")		// 2a parcela 13o Salario
	Else
		dbSelectArea( "SRC" )
	EndIf
Endif

While !EOF() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lGeraSRZ
		IncProc()
	Else
		IncRegua()
	EndIf
	
	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	If nOrdem == 4      // Encargos por C.Custo

		cItCt := " "
		cClVl := " "

		dbSelectArea( "SRA" )
		dbSetOrder(1)
		If nrelat ==4.or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
			dbSeek(SRI->RI_FILIAL + SRI->RI_MAT)
			cCcto :=  SRI->RI_CC
		else
			dbSeek( SRC->RC_FILIAL + SRC->RC_MAT )
			cCcto :=  SRC->RC_CC
		endif
		
		//-------------
		If Eof()
			cCcto := " "     
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
			
			fTestaTotal()
			Loop
		Endif
		//-------------

	ElseIf nOrdem == 6      // Encargos por C.Custo + Item + Classe

		dbSelectArea( "SRA" )
		dbSetOrder(1)
		If nrelat ==4.or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
			dbSeek(SRI->RI_FILIAL + SRI->RI_MAT)
			cCcto :=  SRI->RI_CC
			cItCt :=  SRI->RI_X_ITEM
			cClVl :=  SRI->RI_X_SEGME
		else
			dbSeek( SRC->RC_FILIAL + SRC->RC_MAT )
			cCcto :=  SRC->RC_CC
			cItCt :=  SRC->RC_X_ITEMC
			cClVl :=  SRC->RC_X_CLVL
		endif
		
		//-------------
		If Eof()
			cCcto := " "     
			cItCt := " "
			cClVl := " "
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
			
			fTestaTotal()
			Loop
		Endif
		//-------------

	Else
		cCcto :=  SRA->RA_CC
		cItCt :=  ' '
		cClVl :=  ' '

	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Quebra de Filial                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If SRA->RA_FILIAL # cFilAnterior
		If cPaisloc == "BRA"
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resgata Valores utilizados na GPS que estao armazenados no Parametro 15 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			fGPSVal(SRA->RA_FILIAL,If(nRelat == 4,Left(cAnoMesRef,4)+"13",cAnoMesRef),@aGPSVal,cTpC)
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Resgata os percentuais de terceiros armazenados no parametro 15			³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
			fGPSVal(SRA->RA_FILIAL,"999999",@aGPSPer,cTpC)
		Endif
		If cFilAnterior # "  " .And. ( nOrdem == 4 .or. nOrdem == 6 )
			fImpFil()    // Totaliza Filial
		Endif
		If !FP_CODFOL(@aCodFol,Sra->Ra_Filial) .Or. !fInfo(@aInfo,Sra->ra_Filial)
			Exit
		Endif
		If cFilAnterior # "  " .And. ( nOrdem # 4 .AND. nOrdem # 6 )
			fImpFil()    // Totaliza Filial
		Endif
		cFilAnterior := SRA->RA_FILIAL
		
		If cPaisLoc == "BRA" .And. !fInssEmp(SRA->RA_FILIAL,@aInssEmp)
			Exit
		Endif

		cContribuicao := aCodFol[013,1]+"x"+aCodFol[014,1]+"x"+aCodFol[19,1]+"x"+aCodFol[20,1]+"x"+aCodFol[338,1]+"x"+aCodFol[399,1]
		cContrProAuto := aCodFol[217,1]+"x"+aCodFol[218,1]+"x"+aCodFol[349,1]+"x"+aCodFol[352,1]

	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ( SRA->RA_NOME < cNomDe )  .Or. ( SRA->RA_NOME > cNomAte ) .Or. ;
		( SRA->RA_MAT < cMatDe )   .Or. ( SRA->RA_MAT > cMatAte )
		If nOrdem = 4 .or. nOrdem == 6  // Ordem do Arquivo Movimento "SRC".
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	Endif
	
	If (( nOrdem # 4 .AND. nOrdem # 6 ).And. ((SRA->RA_CC < cCcDe) .Or. (SRA->RA_CC > cCcAte))) .Or.;
		((nOrdem == 4 .OR. nOrdem == 6) .And. nRelat  # 4 .And. ((SRC->RC_CC < cCcDe) .Or. (SRC->RC_CC > cCcAte))).Or.;
		((nOrdem == 4 .OR. nOrdem == 6) .And. nRelat == 4 .And. ((SRI->RI_CC < cCcDe) .Or. (SRI->RI_CC > cCcAte)) .OR.;
		((SRA->RA_X_SEGME < cSegDe) .Or. (SRA->RA_X_SEGME > cSegAte)))
		If nOrdem == 4 .or. nOrdem == 6  // Ordem do Arquivo Movto.
			If nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea("SRC")
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de Afastamentono mes que esta sendo listado ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTipAfas := " "
	dDtAfas  := dDtRet := ctod("")
	dDtPesqAf:= CTOD("01/" + Right(cAnoMesRef,2) + "/" + Left(cAnoMesRef,4),"DDMMYY")
	fChkAfas(SRA->RA_FILIAL,SRA->RA_MAT,dDtPesqAf,@dDtAfas,@dDtRet,@cTipAfas)
	If cTipAfas $"HIJKLMNSU234" .Or.;
		(!Empty(SRA->RA_DEMISSA) .And. MesAno(SRA->RA_DEMISSA)<= MesAno(dDtPesqAf))
		cTipAfas := "D"
	Elseif cTipAfas $"OPQRXYV8W1"
		cTipAfas := "A"
	ElseIf cTipAfas == "F"
		cTipAfas := "F"
	Else
		cTipAfas := " "
	EndIf
	If MesAno(dDtAfas) > MesAno(dDtPesqAf)
		cTipAfas := " "
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica Situacao e Categoria do Funcionario                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Type("cTipAfas")==Type("cSit") .AND. Type("SRA->RA_CATFUNC")==Type("cCat") .AND. Type("SRA->RA_TPCONTR")==Type("cTpC1")

		If	!(cTipAfas $ cSit) .Or. !(SRA->RA_CATFUNC $ cCat) .Or. !(SRA->RA_TPCONTR$ cTpC1 )
			If nOrdem == 4 .OR. nOrdem == 6 // Ordem do Arquivo Movto.
				If nrelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
					dbSelectArea("SRI")
				Else
					dbSelectArea( "SRC" )
				EndIf
				dbSkip()
			Endif
			fTestaTotal()
			Loop
		Endif

	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste controle de acessos e filiais validas				 |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !(SRA->RA_FILIAL $ fValidFil()) .Or. !Eval(cAcessaSRA)
		If nOrdem == 4 .or. nOrdem == 6   // Ordem do Arquivo Movto.
			If nrelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
				dbSelectArea("SRI")
			Else
				dbSelectArea( "SRC" )
			EndIf
			dbSkip()
		Endif
		fTestaTotal()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se e Adiantamento e Folha                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If nRelat == 1 .Or. nRelat == 2 .Or. If(!(cPaisLoc $ "URU|ARG|PAR"),nRelat == 3,.F.)
		lInssFun := .F.
		lCotFun := .F.
		dbSelectArea( "SRC" )
		If cCalcInf == "S"   //Verifica se deve listar so os Informados
			If ! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + aCodFol[64,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[65,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[70,1] ) .And. ;
				! dbSeek(SRA->RA_FILIAL + SRA->RA_MAT + acodFol[125,1] )
				fTestaTotal()
				Loop
			Else
				dbSelectArea("SRC")
				dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			Endif
		ElseIf nOrdem # 4 .AND. nOrdem # 6
			dbSeek(SRA->RA_FILIAL + SRA->RA_MAT )
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Busca os codigos de pensao definidos no cadastro beneficiario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nRelat == 3
			fBusCadBenef(@aCodBenef, "131", {aCodfol[172,1]})
		EndIf

		While !Eof() .And. (nOrdem # 4 .and. nOrdem # 6 .And. SRC->RC_FILIAL+SRC->RC_MAT == SRA->RA_FILIAL+SRA->RA_MAT) .Or. ;
			((nOrdem = 4 .OR. nOrdem = 6) .And. SRC->RC_FILIAL+SRC->RC_CC+SRC->RC_MAT == SRA->RA_FILIAL+cCCto+SRA->RA_MAT)
			If	SRC->RC_SEMANA # Semana .And. Semana # "99"
				dbSkip()
				Loop
			Endif
			
			If !Eval(cAcessaSRC)
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Desconto de Adto Gera um provento                            ³
			//³ Arredondamento do Adto gera um Provento                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If	(nRelat == 1) .And. (SRC->RC_PD == aCodFol[7,1] .Or. SRC->RC_PD == aCodFol[8,1])
				cCodInv := If(SRC->RC_PD == aCodFol[7,1],aCodfol[6,1],aCodFol[8,1])
				fSoma(@aFunP,"C",cCodInv)
				fSoma(@aCcP ,"C",cCodInv)
				fSoma(@aFilP,"C",cCodInv)
				fSoma(@aEmpP,"C",cCodInv)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ I.R. do Adto. Codigo de Base gera IR do Adto.                ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ElseIf (nRelat == 1) .And. (SRC->RC_PD == aCodFol[12,1])
				cCodInv := aCodFol[9,1]
				fSoma(@aFunD,"C",cCodInv)
				fSoma(@aCcD ,"C",cCodInv)
				fSoma(@aFilD,"C",cCodInv)
				fSoma(@aEmpD,"C",cCodInv)
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "1"
				If nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunP,"C")
					fSoma(@aCcP ,"C")
					fSoma(@aFilP,"C")
					fSoma(@aEmpP,"C")
				Endif
				If (nRelat == 3) .And. (SRC->RC_PD == aCodFol[022,1])
					fSoma(@aFunP,"C")
					fSoma(@aCcP ,"C")
					fSoma(@aFilP,"C")
					fSoma(@aEmpP,"C")
				Endif
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "2"
				If	nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunD,"C")
					fSoma(@aCcD ,"C")
					fSoma(@aFilD,"C")
					fSoma(@aEmpD,"C")
					//--Verifica se Funcionario teve Retencao de Inss
					If SRC->RC_PD$ aCodFol[064,1]+'*'+aCodFol[065,1]+'*'+;
								   aCodFol[351,1]+'*'+aCodFol[354,1]
						lInssFun := .T.
					Endif
					If cPaisLoc == "URU" .And. SRC->RC_PD$ aCodFol[309,1]
						lCotFun := .T.
					Endif
				Endif
				If	nRelat == 3 .And. Ascan(aCodBenef, { |x| x[1] == SRC->RC_PD }) > 0
					fSoma(@aFunD,"C")
					fSoma(@aCcD ,"C")
					fSoma(@aFilD,"C")
					fSoma(@aEmpD,"C")
				Endif
			ElseIf PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_TIPOCOD") == "3"
				If	nRelat == 2 .Or. (nRelat == 1 .And. PosSrv(SRC->RC_PD,SRA->RA_FILIAL,"RV_ADIANTA") == "S")
					fSoma(@aFunB,"C")
					fSoma(@aCcB ,"C")
					fSoma(@aFilB,"C")
					fSoma(@aEmpB,"C")
				Endif
				If	nRelat == 3 .And. ( SRC->RC_PD == aCodFol[108,1] .Or. SRC->RC_PD == aCodFol[109,1] .Or. SRC->RC_PD == aCodFol[173,1] )
					fSoma(@aFunB,"C")
					fSoma(@aCcB ,"C")
					fSoma(@aFilB,"C")
					fSoma(@aEmpB,"C")
				Endif
			Endif
			dbSkip()
		Enddo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 2§ Parcela 13§ Salario                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Elseif nRelat == 4 .or. If(cPaisLoc $ "URU|ARG|PAR",nRelat==3,.F.)
		lInssFun := .F.
		dbSelectArea( "SRI" )
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Se ordem for por CC do Movimento, imprimir baseado na chave  ³
		//³ de busca do SRI, caso contrario na chave de busca do SRA.    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOrdem == 4 .or. nOrdem == 6
			cBuscaSRA := SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT
			cBuscaSRI := "SRI->RI_FILIAL + SRI->RI_CC + SRI->RI_MAT"
		Else
			cBuscaSRA := SRA->RA_FILIAL + SRA->RA_MAT
			cBuscaSRI := "SRI->RI_FILIAL + SRI->RI_MAT"
			dbSeek(cBuscaSRA)
		EndIf
		While !Eof() .And. (&cBuscaSRI == cBuscaSRA)
			If !Eval(cAcessaSRI)
				dbSkip()
				Loop
			EndIf
			If PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "1"
				fSoma(@aFunP,"I")
				fSoma(@aCcP ,"I")
				fSoma(@aFilP,"I")
				fSoma(@aEmpP,"I")
			ElseIf PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "2"
				fSoma(@aFunD,"I")
				fSoma(@aCcD ,"I")
				fSoma(@aFilD,"I")
				fSoma(@aEmpD,"I")
				//--Verifica se Funcionario teve Retencao de Inss
				If SRI->RI_PD$ aCodFol[070,1]
					lInssFun := .T.
				Endif
			ElseIf PosSrv(SRI->RI_PD,SRI->RI_FILIAL,"RV_TIPOCOD") == "3"
				fSoma(@aFunB,"I")
				fSoma(@aCcB ,"I")
				fSoma(@aFilB,"I")
				fSoma(@aEmpB,"I")
			Endif
			dbSkip()
		Enddo
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Nao considera funcionarios admitidos apos o periodo do movimento ³
	//³ e nem os demitidos anterior ao periodo.						     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If MesAno(SRA->RA_ADMISSA) <= MesAno(dDtPesqAf) .and.;
		(Empty(SRA->RA_DEMISSA) .or. MesAno(SRA->RA_DEMISSA) >= MesAno(dDtPesqAf))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Somatorias de Situacoes dos Funcionarios                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SRA->RA_CC = cCcto
			If lInssFun
				nEinss ++ ; nFinss++ ; nCinss ++  //-- Total de Func. Ret. Inss
			Endif
         If cPaisLoc == "URU" 
				If lCotFun
	         	nFuncs++
				Endif
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Conta funcionarios por centro de custo                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				//So calcular se teve lanzada verba de salario mensal ou horista 13salario (se trabalhou)
			 //If aScan(aFunP,{|x| x[1] $ aCodFol[31,1]+"*"+aCodFol[32,1]+"*"+aCodFol[72,1]+"*"+aCodFol[22,1]+"*"+aCodFol[24,1]}) > 0
				If nRelat <> 4 .or. nRelat <> 5
					If CTT->(FieldPos('CTT_POLIZA')) > 0				
						CTT->(DbSetOrder(1))
						If CTT->(MsSeek(xFilial()+SRA->RA_CC)) .And. !Empty(CTT->CTT_POLIZA)
							If (nPosBSE	:=	AScan(aFuncsBSE,{|x| x[1] == CTT->CTT_POLIZA})) == 0
								AAdd(aFuncsBSE,{CTT->CTT_POLIZA,1})
							Else
								aFuncsBSE[nPosBSE][2] ++ 
							Endif
						Endif
	   			Endif
	         Endif
			Endif
            If mesano(SRA->RA_ADMISSA) = MesAno(dDtPesqAf)
				nEadm ++ ; nFadm ++ ; nCadm ++  //-- Total Admitidos      
			//	nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
            Endif
 			If cTipAfas == " "
				nEnor ++ ; nFnor ++ ; nCnor ++  //-- Total Situacao Normal
				nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
 
			Elseif cTipAfas == "A"
				nEafa ++ ; nFafa ++ ; nCafa ++  //-- Total Afastados
				nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
				
			Elseif cTipAfas == "D"
				If Len(aFunP) > 0 .Or. Len(aFunD) > 0 .Or. Len(aFunB) > 0
					nEdem ++ ; nFdem ++ ; nCdem ++  // Demitidos
					nEtot ++ ; nFtot ++ ; nCtot ++  // Total de Funcionarios
				Endif
				
			Elseif cTipAfas == "F"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Procura No Arquivo de Ferias o Periodo a Ser Listado         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea( "SRH" )
				If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
					While !Eof() .And. SRA->RA_FILIAL + SRA->RA_MAT == SRH->RH_FILIAL + SRH->RH_MAT
						dbSkip()
					Enddo
					dbSkip(-1)
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica Se Esta Dentro Das Datas Selecionadas               ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If MesAno(SRH->RH_DATAINI) > cAnoMesRef
						nEnor ++ ; nFnor ++ ; nCnor ++  //-- Total Situacao Normal
					Else
						nEfer ++ ; nFfer ++ ; nCfer ++  //-- Ferias
					Endif
					nEtot ++ ; nFtot ++ ; nCtot ++  //-- Total de Funcionarios
				Endif
				dbSelectArea( "SRA" )
				
			Endif
		Else
			If lInssFun
				nCinss ++
			Endif
			nEexc ++ ; nFexc ++ ; nCexc ++  //-- Outro C.Custo
			nEtot ++ ; nFtot ++ ; nCtot ++  //-- Outro C.Custo
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa Verbas de Provento / Descontos / Base                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If	Len(aFunP) == 0 .And. Len(aFunD) == 0 .And. Len(aFunB) == 0
			fTestaTotal()
			Loop
		Endif
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime Funcionarios                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	fImpFun(@aFunP,@aFunD,@aFunB)
	fTestaTotal()
Enddo

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFuncao    ³fCalcComplºAutor  ³Andreia dos Santos  º Data ³  07/03/02   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calcula os Valores de Pro-Labore, Autonomo, Cooperativa e  º±±
±±º          ³ Vl. da Receita de acordo com as verbas cadastradas.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³ cExp1 => Tipo 1 - Filial                                   º±±
±±º          ³          Tipo 2 - Centro de Custo                          º±±
±±º          ³ cExp2 => Centro de Custo                                   º±±
±±º          ³ cExp3 => Se .T. nao foi informado o CC no cadastro de      º±±
±±º          ³          parametros e o valor so sera considerado na Filialº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ SIGAGPE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fCalcCompl(cTipo,cCCusto,lFilial,nOrdem)
Local nX := 1
Local nValor
Local lSoma := .F.

For nX := 1 to len(aGpsVal)
    if lFilial  
    	If ( StrZero(nOrdem,1) $ "1/4/5/6" .And. empty(alltrim(aGpsVal[nX,1])) ) .Or.;
    		StrZero(nOrdem,1) $ "2/3"
	       lSoma := .T.
	    Endif   
    ElseIF StrZero(nOrdem,1) $ "1/4/5/6" .And. alltrim(aGpsVal[nX,1]) ==alltrim(cCCusto)
    	lSoma := .T.
    Endif
    If lSoma	
		nValor := If(aGpsVal[nx,5] <> 0,aGpsVal[nx,5],round(aGpsVal[nx,3]*aGpsVal[nx,4]/100,2))
		if nValor <> 0
			fSomaInss(cTipo,aGpsVal[nx,2],nValor)  
		Endif
	EndIF	
    lSoma := .F.
Next
return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GPER040   ºAutor  ³Microsiga           º Data ³  11/30/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a quebra de c.custo + item + Classe                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Quebra( nOrdem, nRelat, cTipo )

Local cRet := ''

If     nOrdem == 4
	
	If cTipo = 'CC'
		
		If nRelat == 4
			cRet := SRI->RI_CC
		Else
			cRet := SRC->RC_CC
		EndIf
		
	Else
		
		cRet := ' '
		
	EndIf
	
ElseIf nOrdem == 6
	
	If nRelat == 4
		cRet := IIf( cTipo == 'CC', SRI->RI_CC, IIf( cTipo == 'IT', SRI->RI_X_ITEM, IIf( cTipo == 'CL', SRI->RI_X_SEGME, ' ') ) )
	Else
		cRet := IIf( cTipo == 'CC', SRC->RC_CC, IIf( cTipo == 'IT', SRC->RC_X_ITEMC, IIf( cTipo == 'CL', SRC->RC_X_CLVL, ' ') ) )
	EndIf
	
Else
	
	If cTipo = 'CC'
		cRet := SRA->RA_CC
	Else
		cRet := ' '
	EndIf
	
EndIf

Return cRet

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")//Perguntas (filtros) no relatorio
dbSetOrder(1)    

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Data de Referencia      ?","","","mv_ch1","D",08,0,0,"G","naovazio","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})  
aAdd(aRegs,{cPerg,"02","Imprimir Folha          ?","","","mv_ch2","N",01,0,1,"C","        ","mv_par02","Adto.","Adto.","Adto.","","","Folha","Folha","Folha","","","1ªParc. 13º","1ªParc. 13º","1ªParc. 13º","","","2ªParc. 13º","2ªParc. 13º","2ªParc. 13º","",""}) 
aAdd(aRegs,{cPerg,"03","Numero da Semena        ?","","","mv_ch3","C",02,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Filial De               ?","","","mv_ch4","C",02,0,0,"G","        ","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Filial Ate              ?","","","mv_ch5","C",02,0,0,"G","naovazio","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})      
aAdd(aRegs,{cPerg,"06","Centro de Custo De      ?","","","mv_ch6","C",09,0,0,"G","        ","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"07","Centro de Custo Ate     ?","","","mv_ch7","C",09,0,0,"G","naovazio","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","CTT",""})
aAdd(aRegs,{cPerg,"08","Matricula De            ?","","","mv_ch8","C",06,0,0,"G","        ","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""})
aAdd(aRegs,{cPerg,"09","Matricula Ate           ?","","","mv_ch9","C",06,0,0,"G","naovazio","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","SRA",""}) 
aAdd(aRegs,{cPerg,"10","Nome De                 ?","","","mv_ch10","C",30,0,0,"G","        ","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"11","Nome Ate                ?","","","mv_ch11","C",30,0,0,"G","naovazio","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Situacao Funcionario    ?","","","mv_ch12","C",05,0,1,"C","fSituacao","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"13","Categorias              ?","","","mv_ch13","C",15,0,1,"C","fCategoria","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})                                                                                          
aAdd(aRegs,{cPerg,"14","C.C. em Outra Pag.      ?","","","mv_ch14","N",01,0,1,"C","naovazio","mv_par14","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"15","Folha Sint./Analit.     ?","","","mv_ch15","N",01,0,1,"C","naovazio","mv_par15","Analitica","Analitica","Analitica","","","Sintetica","Sintetica","Sintetica","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"16","Impr. Total Filial      ?","","","mv_ch16","N",01,0,1,"C","naovazio","mv_par16","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"17","Impr. Total Empresa     ?","","","mv_ch17","N",01,0,1,"C","naovazio","mv_par17","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"18","Impr.Niveis C.Custo     ?","","","mv_ch18","N",01,0,1,"C","naovazio","mv_par18","Sim","Sim","Sim","","","Nao","Nao","Nao","","","Primeiro","Primeiro","Primeiro","","","","","","",""}) 
aAdd(aRegs,{cPerg,"19","Apenas Quebra Nivel     ?","","","mv_ch19","N",01,0,1,"C","naovazio","mv_par19","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"20","Impr Apenas Totais      ?","","","mv_ch20","N",01,0,1,"C","naovazio","mv_par20","Sim","Sim","Sim","","","Nao","Nao","Nao","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"21","Imprime C. Custo        ?","","","mv_ch21","N",01,0,1,"C","naovazio","mv_par21","Codigo","Codigo","Codigo","","","Descricao","Descricao","Descricao","","","Ambos","Ambos","Ambos","","","","","","",""}) 
aAdd(aRegs,{cPerg,"22","Imprime Referencia      ?","","","mv_ch22","N",01,0,1,"C","naovazio","mv_par22","Em Horas","Em Horas","Em Horas","","","Ocorencia","Ocorencia","Ocorencia","","","","","","","","","","","",""}) 
aAdd(aRegs,{cPerg,"23","Qual Tipo Contrato      ?","","","mv_ch23","N",01,0,1,"C","naovazio","mv_par23","Indeterminado","Indeterminado","Indeterminado","","","Determinado","Determinado","Determinado","","","Ambos","Ambos","Ambos","","","","","","",""}) 
aAdd(aRegs,{cPerg,"24","Segmento De             ?","","","mv_ch24","C",09,0,0,"G","        ","mv_par24","","","","","","","","","","","","","","","","","","","","","","","","","CTH",""})
aAdd(aRegs,{cPerg,"25","Segmento Ate            ?","","","mv_ch25","C",09,0,0,"G","naovazio","mv_par25","","","","","","","","","","","","","","","","","","","","","","","","","CTH",""})

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