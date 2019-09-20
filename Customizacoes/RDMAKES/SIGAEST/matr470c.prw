#INCLUDE "MATR470.CH"
#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR470  � Autor � Nereu Humberto Junior � Data � 04.08.06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex fisico - financeiro                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user Function  MATR470C()
Local oReport
Local nTamLOC      := TamSX3("B2_LOCAL")[1]
PRIVATE cALL_LOC   := Replicate('*', nTamLOC)
PRIVATE cALL_Empty := Replicate(' ', nTamLOC)
PRIVATE cALL_ZZ    := Replicate('Z', nTamLOC)

If TRepInUse()
	//������������������������������������������������������������������������Ŀ
	//�Interface de impressao                                                  �
	//��������������������������������������������������������������������������
	oReport:= ReportDef()
	oReport:PrintDialog()
Else
	MATR470R3()
EndIf

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor �Nereu Humberto Junior  � Data �04.08.2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relatorio                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportDef()

Local oReport 
Local oCell
Local aOrdem := {}
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por empresa              �
//����������������������������������������������������������������
Local lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport:= TReport():New("MATR470",STR0001,"MTR470", {|oReport| ReportPrint(oReport)},STR0002+" "+STR0003+" "+STR0004) //"Registro de Controle de Producao e Estoque"##"Este programa emitira' o Registro de Controle de Producao"##"e Estoque dos produtos Selecionados,Ordenados por Dia."##"Este relatorio nao lista a Mao de Obra. NOTA: Os Valores Totais serao impressos conforme o Modelo Legal."
oReport:SetTotalInLine(.F.)
oReport:SetLandscape()    
oReport:HideParamPage() 
oReport:HideHeader() 
oReport:HideFooter()
oReport:SetUseGC(.F.)   //DESABILITA OPCAO GESTAO CORPORATIVA 
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//� mv_par01        // Do produto                                           �
//� mv_par02        // Ate o produto                                        �
//� mv_par03        // Do tipo                                              �
//� mv_par04        // Ate o tipo                                           �
//� mv_par05        // Da data                                              �
//� mv_par06        // Ate a data                                           �
//� mv_par07        // Lista produtos s/movim                               �
//� mv_par08        // Do Armazem                                           �
//� mv_par09        // Ate o Armazem                                        �
//� mv_par10        // (D)ocumento/(S)equencia                              �
//� mv_par11        // Moeda                                                �
//� mv_par12        // Pagina Inicial                                       �
//� mv_par13        // Qtd de Paginas                                       �
//� mv_par14        // Nr do Livro                                          �
//� mv_par15        // Livro / Livro+Termos / Termos                        �
//� mv_par16        // Totaliza por Dia   Sim / Nao                         �
//� mv_par17        // "Prod. sem mov. c/ Saldo ?" Lista / Nao Lista        �
//� mv_par18        // Outras moedas                                        �
//� mv_par19        // Quebrar Paginas Por Feixe/Por Mes/Feixe              �
//� mv_par20        // Despesa nas NFs sem IPI    Nao Soma / Soma           �
//� mv_par21        // Reiniciar paginas                                    �
//� mv_par22        // Seleciona Filiais ? (Sim/Nao)   				    	  �
//���������������������������������������������������������������������������
Pergunte("MTR470",.F.)

Aadd( aOrdem, STR0005 ) //" Por Codigo "
Aadd( aOrdem, STR0006 ) //" Por Tipo   "
Aadd( aOrdem, STR0007 ) //" Por Descricao "
Aadd( aOrdem, STR0008 ) //" Por Grupo     "

//��������������������������������������������������������������Ŀ
//� Definicao da Sessao 1                                        �
//����������������������������������������������������������������
oSection1 := TRSection():New(oReport,STR0037,{"SB1","SB2"},aOrdem) //"Produtos"
oSection1 :SetNoFilter("SB2")
oSection1 :SetTotalInLine(.F.)
oSection1 :SetReadOnly()  // Desabilita a edicao das celulas permitindo filtro

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint �Autor  �Nereu Humberto Junior � Data �04/08/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relatorio                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function ReportPrint(oReport)

Local nOrdem    := oReport:Section(1):GetOrder() 

//��������������������������������������������������������������Ŀ
//� MatFilCalc - Funcao utilizada para selecao de filiais        �
//����������������������������������������������������������������
Local aFilsCalc := MatFilCalc( mv_par22 == 1,,,mv_par23==1 .And. mv_par22==1)

//��������������������������������������������������������������Ŀ
//� Impressao do relatorio - Release 4                           �
//����������������������������������������������������������������
If !Empty(aFilsCalc)   
	If oReport:nDevice != 5
		MT470Imp(,,,,.T.,nOrdem,oReport,aFilsCalc)  
	Else
		Aviso(STR0030,STR0046,{STR0033})
	EndIf
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MATR470R3 � Autor � Gilson do Nascimento  � Data � 11.11.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Kardex fisico - financeiro (Antigo)                        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
���Rodrigo Sart�27/03/98�14593A�Acerto na quebra de linhas/paginas        ���
���Rodrigo     �24/06/98�XXXXXX�Acerto no tamanho do documento para 12    ���
���            �        �      �posicoes                                  ���
���Rodrigo     �10/09/98�17543A�Impressao das colunas de especie de Doc.  ���
���Rodrigo Sart�05/11/98�XXXXXX� Acerto p/ Bug Ano 2000                   ���
���Rodrigo     �02/03/99�xxxxxx�Correcao na impressao do custo do SD3     ���
���CesarValadao�30/03/99�XXXXXX�Manutencao na SetPrint()                  ���
���Andreia     �18/06/99�Proth.�Impressao Termo Abert. e Encerr.          ���
���CesarValadao�15/07/99�22274A�Correcao Impressao dos Ultimos Registros  ���
���Rodrigo Sart�29/07/99�xxxxxx�Correcao impressao prod. sem movimento    ���
���Patricia Sal�17/01/00�xxxxxx�Inclusao do mv_par16 para imprimir ou nao ���
���            �        �      �produtos sem movimentacao com saldo.      ���
���Marcello    �25/08/00�oooooo�Impressao da relacao em outras moedas     ���
�������������������������������������������������������������������������Ĵ��
���Marcos Hirak�11/03/04�XXXXXX�Imprimir B1_CODITE quando for gestao de   ���
���            �        �      �Concessionarias ( MV_VEICULO = "S").      ���
���            �        �      �                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Descri�ao � PLANO DE MELHORIA CONTINUA        �Programa :  MATR470.PRX ���
�������������������������������������������������������������������������Ĵ��
���ITEM PMC  � Responsavel              � Data                            ���
�������������������������������������������������������������������������Ĵ��
���      01  �                          �                                 ���
���      02  � Flavio Luiz Vicco        � 09/02/2006                      ���
���      03  �                          �                                 ���
���      04  �                          �                                 ���
���      05  � Nereu Humberto Junior    � 11/05/2006 - BOPS 00000098480   ���
���      06  � Nereu Humberto Junior    � 11/05/2006 - BOPS 00000098480   ���
���      07  � Flavio Luiz Vicco        � 24/02/2006 - BOPS 00000093979   ���
���      08  �                          �                                 ���
���      09  � Flavio Luiz Vicco        � 24/02/2006 - BOPS 00000093979   ���
���      10  � Flavio Luiz Vicco        � 09/02/2006                      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function MATR470R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Variaveis utilizada na selecao de filiais                    �
//����������������������������������������������������������������
Local aFilsCalc:={}

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
PRIVATE lVEIC  := Upper(GetMV("MV_VEICULO"))=="S"

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas no relatorio                            �
//����������������������������������������������������������������
PRIVATE aReturn  := { STR0009, 1,STR0010, 2, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE aLinha   := { }
PRIVATE nLastKey := 0
PRIVATE nPaginas := 0
PRIVATE cPerg    := "MTR470"
PRIVATE bBloco   := { |nV,nX| Trim(nV)+IIf(Valtype(nX)='C',"",Str(nX,1)) }
PRIVATE aDriver  := ReadDriver()

//�����������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por empresa                 �
//�������������������������������������������������������������������
PRIVATE lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa


//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//�������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                              �
//� mv_par01        // Do produto                                     �
//� mv_par02        // Ate o produto                                  �
//� mv_par03        // Do tipo                                        �
//� mv_par04        // Ate o tipo                                     �
//� mv_par05        // Da data                                        �
//� mv_par06        // Ate a data                                     �
//� mv_par07        // Lista produtos s/movim                         �
//� mv_par08        // Do Armazem                                     �
//� mv_par09        // Ate o Armazem                                  �
//� mv_par10        // (D)ocumento/(S)equencia                        �
//� mv_par11        // Moeda                                          �
//� mv_par12        // Pagina Inicial                                 �
//� mv_par13        // Qtd de Paginas                                 �
//� mv_par14        // Nr do Livro                                    �
//� mv_par15        // Livro / Livro+Termos / Termos                  �
//� mv_par16        // Totaliza por Dia   Sim / Nao                   �
//� mv_par17        // "Prod. sem mov. c/ Saldo ?" Lista / Nao Lista  �
//� mv_par18        // Outras moedas                                  �
//� mv_par19        // Quebrar Paginas Por Feixe/Por Mes/Feixe        �
//� mv_par20        // Despesa nas NFs sem IPI    Nao Soma / Soma     �
//� mv_par21        // Reiniciar paginas                              �
//� mv_par22        // Seleciona Filiais ? (Sim/Nao)   				  �
//���������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel :="MATR470"
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
EndIf

//��������������������������������������������������������������Ŀ
//� MatFilCalc - Funcao utilizada para selecao de filiais        �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MT470Imp  � Autor � Gilson do Nascimento � Data � 16.09.93 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR470                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         �
//����������������������������������������������������������������
Local cPerg    := "MTR470"
Local cArq1    := ''
Local cInd1    := ''
Local cAliasSB2:= ''
Local cAliasTOP:= ''
Local cTempo   := ''
Local cPicD1Qt2:= ''
Local lfirst   := .T.
Local cCarPic

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Tratamento da impressao por Filiais�
//����������������������������������������������������������������
Local nForFilial := 0
Local cFilBack   := cFilAnt
Local lImp  	 := GetNewPar("MV_IMPCABE",.F.)
//��������������������������������������������������������������Ŀ
//� Carrega Filtro de Usuario                                    �
//����������������������������������������������������������������
Local cFilUser   := IIf(lGraph,oReport:Section(1):GetAdvplExp(),aReturn[7])
//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por empresa              �
//����������������������������������������������������������������
PRIVATE lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

//��������������������������������������������������������������Ŀ
//� Variaveis tipo PRIVATE para SIGAVEI, SIGAPEC e SIGAOFI       �
//����������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Verifica se utiliza custo unificado por empresa              �
//����������������������������������������������������������������
lCusUnif := lCusUnif .And. AllTrim(mv_par08) == cALL_LOC
mv_par09 := If(lCusUnif,cALL_LOC,mv_par09)
//��������������������������������������������������������������Ŀ
//� Nao aglutinar por CNPJ+IE quando a pergunta de selecao de    �
//| filiais estiver desabilitada.                                |
//����������������������������������������������������������������
If mv_par22==2
	mv_par23 := 2
EndIf

//��������������������������������������������������������������Ŀ
//� Lay-Out de Impressao do Relatorio                            �
//����������������������������������������������������������������
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
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
li       := 80
dDataIni := mv_par05
dDataFim := mv_par06
nPaginas := IIf(mv_par12<=1,2,mv_par12)
nQuebra	 := IIf(mv_par13<=2,500,mv_par13)

//������������������������������������������������������Ŀ
//� Inicializa o codigo de caracter Normal da impressora �
//��������������������������������������������������������
nTipo  := 18

//������������������������������������������������������Ŀ
//� Cria array para gerar arquivo de trabalho            �
//��������������������������������������������������������
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
	

//�������������������������������������Ŀ	
//� Inicializa o log de processamento   �
//���������������������������������������
ProcLogIni( {},"MATR470" )

//�����������������������������������Ŀ
//� Atualiza o log de processamento   �
//�������������������������������������
ProcLogAtu("INICIO")

//���������������������������������������������Ŀ
//� Atualiza o log de processamento			    �
//�����������������������������������������������
ProcLogAtu("MENSAGEM",STR0040 ,STR0040 ) //"Iniciando impress�o do Registro de Inventario Modelo 7 "

For nForFilial := 1 To Len(aFilsCalc)
	
	If aFilsCalc[nForFilial,1]
		
		// Altera filial corrente
		cFilAnt := aFilsCalc[nForFilial,2]

		//���������������������������������������������Ŀ
		//� Atualiza o log de processamento			    �
		//�����������������������������������������������
		ProcLogAtu("MENSAGEM",STR0041 + cFilAnt ,STR0041 + cFilAnt) //"Iniciando montagem do relatorio - Filial : ## "
		
		// Posiciona na tabela SM0 para impressao dos dados do cabecalho		
		SM0->(DbGoTop())
		SM0->(DbSeek(cEmpAnt+cFilAnt))
		//���������������������������������������������Ŀ
		//� Parametro MV_M470IPI                        �
		//�����������������������������������������������
		lAgregIPI := SuperGetMv("MV_M470IPI",.F.,.T.)
		
		If lGraph
			nOrd := nOrdem
		Else
			nOrd := aReturn[8]
		EndIf

		//�����������������������������������������������������������������Ŀ
		//� Cria arquivo de trabalho                                        �
		//� O indice devera ser sempre pela DTDIGIT conforme IOB - 25/02/02 �
		//�������������������������������������������������������������������
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
		
		//��������������������������������������������������������������Ŀ
		//� Impressao de Termo / Livro                                   �
		//����������������������������������������������������������������
		Do Case
			Case mv_par15==1 ; lImpLivro:=.T. ; lImpTermos:=.F.
			Case mv_par15==2 ; lImpLivro:=.T. ; lImpTermos:=.T.
			Case mv_par15==3 ; lImpLivro:=.F. ; lImpTermos:=.T.
		EndCase

		If !lCusUnif
			//����������������������������������������������������������Ŀ
			//� Define a string da query a ser processada                �
			//������������������������������������������������������������
			cQuery := "SELECT DISTINCT B2_FILIAL,B2_LOCAL FROM " 
			cQuery += RetSqlName("SB2")  + " SB2 " 
			cQuery += "WHERE "
			cQuery += "SB2.B2_FILIAL  = '" + xFilial("SB2")	+ "' "
			cQuery += "AND SB2.B2_LOCAL  >= '" + mv_par08	+ "' "
			cQuery += "AND SB2.B2_LOCAL  <= '" + mv_par09	+ "' "
			cQuery += "AND D_E_L_E_T_ = ' ' "
			cQuery += "GROUP BY B2_FILIAL,B2_LOCAL "
			cQuery += "ORDER BY B2_FILIAL,B2_LOCAL "
			//�������������������������������������������������������������Ŀ
			//� Define o alias para a query                                 �
			//���������������������������������������������������������������
			cAliasSB2  := GetNextAlias()
			//�������������������������������������������������������������Ŀ
			//� Verifica se o alias esta em uso                             �
			//���������������������������������������������������������������
			If Select( cAliasSB2 ) > 0
				dbSelectArea( cAliasSB2 )
				dbCloseArea()
			EndIf
			//�������������������������������������������������������������Ŀ
			//� Compatibiliza a query com o banco de dados                  �
			//���������������������������������������������������������������
			cQuery := ChangeQuery(cQuery)
			//�������������������������������������������������������������Ŀ
			//� Cria o alias executando a query                             �
			//���������������������������������������������������������������
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSB2 , .F., .T.)
			//��������������������������������������������������������������Ŀ
			//� Processa por Armazem 										 �
			//����������������������������������������������������������������
			dbSelectArea(cAliasSB2)
		EndIf
			
		//��������������������������������������������������������������Ŀ
		//� Calcula Periodos a serem processados                         �
		//����������������������������������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� PROCESSA RELATORIO                                           �
		//����������������������������������������������������������������
		Do While IIf(lCusUnif,.T.,(cAliasSB2)->( !Eof() ) ) .And. lImpLivro
		
			If !lGraph
				If lEnd
					@PROW()+1,001 PSAY STR0023	//"CANCELADO PELO OPERADOR"
					Exit
				EndIf
			EndIf
		
			//����������������������������������������������������������Ŀ
			//� Query dos Armazens a serem processados                   �
			//������������������������������������������������������������
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
			//�������������������������������������������������������������Ŀ
			//� Define o alias para a query                                 �
			//���������������������������������������������������������������
			cAliasTOP  := GetNextAlias()
			//�������������������������������������������������������������Ŀ
			//� Verifica se o alias esta em uso                             �
			//���������������������������������������������������������������
			If Select( cAliasTop ) > 0
				dbSelectArea( cAliasTop )
				dbCloseArea()
			EndIf
			//�������������������������������������������������������������Ŀ
			//� Compatibiliza a query com o banco de dados                  �
			//���������������������������������������������������������������
			cQuery := ChangeQuery(cQuery)
			//�������������������������������������������������������������Ŀ
			//� Cria o alias executando a query                             �
			//���������������������������������������������������������������
			dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasTop , .F., .T.)
			//�������������������������������������������������������������Ŀ
			//� Contar os registros a serem processados na rotina           �
			//���������������������������������������������������������������
			dbSelectArea( cAliasTop )	
			dbGoTop()
			(cAliasTop)->( dbEval( { || nTamReg++ },,{ || !Eof() } ) )	
			dbGoTop()
			
			If !lGraph
				SetRegua( nTamReg )
			EndIf	

			//��������������������������������������������������������������Ŀ
			//� Processa por Produto 										 �
			//����������������������������������������������������������������
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
				//������������������������������������������������Ŀ
				//� Filtra produto Mao de Obra                     �
				//��������������������������������������������������
				dbSelectArea(cAliasTop)
				If IsProdMod((cAliasTop)->B1_COD)
					dbSkip()
					Loop
				EndIf

				//������������������������������������������������Ŀ
				//� Tratamento para filtro de usuario              �
				//��������������������������������������������������
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
				//������������������������������������������������Ŀ
				//� Inicializa Variaveis                           �
				//��������������������������������������������������
				cProdAnt  := (cAliasTop)->B1_COD
				cProdVeic := IIf(lVeic,(cAliasTop)->B1_CODITE,"") 
				cLocalAnt := IIf(lCusUnif,"",(cAliasTop)->B2_LOCAL)
				cDesc     := (cAliasTop)->B1_DESC
				cTipo     := (cAliasTop)->B1_TIPO
				cGrupo    := (cAliasTop)->B1_GRUPO
				cUm       := (cAliasTop)->B1_UM
				cPosIPI   := (cAliasTop)->B1_POSIPI
				aSalAtu   := {0,0,0,0,0,0,0}
				//������������������������������������������������Ŀ
				//� Saldo em Processo                              �
				//��������������������������������������������������
				If !lCusUnif .And. (cAliasTop)->B1_APROPRI == "I"
					aSalProc := CalcEst(cProdAnt,cLocProc,mv_par05,Nil)
				EndIf
				//������������������������������������������������Ŀ
				//� Inicializa Variavel cTRBSeek                   �
				//��������������������������������������������������
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
				//������������������������������������������������Ŀ
				//� Calcula saldo inicial                          �
				//��������������������������������������������������
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
					//�������������������������������������������������Ŀ
					//� Analisa se o Produto/Armazem possui saldo, caso �
					//| nao possua nao chama novamente a CalcEst.       |
					//���������������������������������������������������
					aSalAtu := CalcEst(cProdAnt,cLocalAnt,mv_par05,Nil)
				EndIf
				aSalAtu[1] 	:= aSalAtu[1]
				nInicial    := aSalAtu[1]
				dCntData  	:= dDataIni
				nRec1		:= 0
			
				//��������������������������������������������������������������Ŀ
				//� Processa periodos selecionados                               �
				//����������������������������������������������������������������
				For nPeriodo := 1 to Len(aPeriodos)
					// Acumula o Saldo inicial do periodo para a correta gravacao do TRB
					nInicial    := aSalAtu[1] 
					//����������������������������������������������������������Ŀ
					//� Query SD1 - Documentos de Entrada                        �
					//������������������������������������������������������������
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
					//�������������������������������������������������������������Ŀ
					//� Define o alias para a query                                 �
					//���������������������������������������������������������������
					cAliasSD1  := GetNextAlias()
					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD1 ) > 0
						dbSelectArea( cAliasSD1 )
						dbCloseArea()
					EndIf
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza a query com o banco de dados                  �
					//���������������������������������������������������������������
					cQuery := ChangeQuery(cQuery)
					//�������������������������������������������������������������Ŀ
					//� Cria o alias executando a query                             �
					//���������������������������������������������������������������
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD1 , .F., .T.)
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza os campos de acordo com a TopField            �
					//���������������������������������������������������������������
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

						//��������������������������������������������������������������Ŀ
						//� Verifica Moeda                                               �
						//����������������������������������������������������������������
						If mv_par18==2  //nao imprimir notas com moeda diferente da escolhida
							If If((cAliasSD1)->F1_MOEDA==0,1,(cAliasSD1)->F1_MOEDA)!=mv_par11
								dbskip()
								Loop
							EndIf
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Verifica Data Limite                                         �
						//����������������������������������������������������������������
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

					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD1 ) > 0
						dbSelectArea( cAliasSD1 )
						dbCloseArea()
					EndIf
		
					//����������������������������������������������������������Ŀ
					//� Query SD3 - Movimentos Internos                          �
					//������������������������������������������������������������
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
					//�������������������������������������������������������������Ŀ
					//� Define o alias para a query                                 �
					//���������������������������������������������������������������
					cAliasSD3  := GetNextAlias()
					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD3 ) > 0
						dbSelectArea( cAliasSD3 )
						dbCloseArea()
					EndIf
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza a query com o banco de dados                  �
					//���������������������������������������������������������������
					cQuery := ChangeQuery(cQuery)
					//�������������������������������������������������������������Ŀ
					//� Cria o alias executando a query                             �
					//���������������������������������������������������������������
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD3 , .F., .T.)
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza os campos de acordo com a TopField            �
					//���������������������������������������������������������������
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
						//��������������������������������������������������������������Ŀ
						//� Verifica Data Limite                                         �
						//����������������������������������������������������������������
						If (cAliasSD3)->D3_EMISSAO < mv_par05 .Or.;
						   (cAliasSD3)->D3_EMISSAO > mv_par06
							dbSelectArea(cAliasSD3)
							dbSkip()
							Loop
						EndIf
						//����������������������������������������������������������������Ŀ
						//� Quando movimento ref apropr. indireta, so considera os         �
						//� movimentos com destino ao almoxarifado de apropriacao indireta.�
						//������������������������������������������������������������������
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

					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD3 ) > 0
						dbSelectArea( cAliasSD3 )
						dbCloseArea()
					EndIf

					//����������������������������������������������������������Ŀ
					//� Query SD2 - Documentos de Saida                          �
					//������������������������������������������������������������
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
					//�������������������������������������������������������������Ŀ
					//� Define o alias para a query                                 �
					//���������������������������������������������������������������
					cAliasSD2  := GetNextAlias()
					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD2 ) > 0
						dbSelectArea( cAliasSD2 )
						dbCloseArea()
					EndIf
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza a query com o banco de dados                  �
					//���������������������������������������������������������������
					cQuery := ChangeQuery(cQuery)
					//�������������������������������������������������������������Ŀ
					//� Cria o alias executando a query                             �
					//���������������������������������������������������������������
					dbUseArea( .T., 'TOPCONN', TCGENQRY(,,cQuery), cAliasSD2 , .F., .T.)
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza os campos de acordo com a TopField            �
					//���������������������������������������������������������������
					//�������������������������������������������������������������Ŀ
					//� Compatibiliza os campos de acordo com a TopField            �
					//���������������������������������������������������������������
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

						//��������������������������������������������������������������Ŀ
						//� Verifica Moeda                                               �
						//����������������������������������������������������������������
						If mv_par18==2  //nao imprimir notas com moeda diferente da escolhida
							If If((cAliasSD2)->F2_MOEDA==0,1,(cAliasSD2)->F2_MOEDA)!=mv_par11
								dbSkip()
								Loop
							EndIf
						EndIf
						//��������������������������������������������������������������Ŀ
						//� Verifica Data Limite                                         �
						//����������������������������������������������������������������
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

					//�������������������������������������������������������������Ŀ
					//� Verifica se o alias esta em uso                             �
					//���������������������������������������������������������������
					If Select( cAliasSD2 ) > 0
						dbSelectArea( cAliasSD2 )
						dbCloseArea()
					EndIf

					If nRec1 == 0
						//��������������������������������������������������������Ŀ
						//� Verifica se deve ou nao listar os produtos s/movimento �
						//� Caso liste o produto, grava produto com TRB->FLAG = S  �
						//����������������������������������������������������������
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
	
		//���������������������������������������������Ŀ
		//� Atualiza o log de processamento			    �
		//�����������������������������������������������
		ProcLogAtu("MENSAGEM",STR0042 + cFilAnt , STR0042 + cFilAnt) //"Temino da montagem do relatorio - Filial : ## "



		//���������������������������������������������Ŀ
		//� Chave para aglutinacao CNPJ+IE              �
		//�����������������������������������������������
		cChave := IIf(mv_par23==1,aFilsCalc[nForFilial,4]+aFilsCalc[nForFilial,5],'')

		//���������������������������������������������Ŀ
		//� Impressao do relatorio                      �
		//�����������������������������������������������
        If mv_par23==2 .Or.;
          (mv_par23==1 .And. IIf(Len(aFilsCalc)==nForFilial,.T.,cChave<>aFilsCalc[nForFilial+1,4]+aFilsCalc[nForFilial+1,5]))

			If mv_par23==1
				aSalEst := {}
			EndIf
			
			//���������������������������������������������Ŀ
			//� Atualiza o log de processamento			    �
			//�����������������������������������������������
			ProcLogAtu("MENSAGEM",STR0043 + cFilAnt ,STR0043 + cFilAnt) //"Iniciando Impressao do relatorio - Filial : ## "
	
			//��������������������������������������������������������Ŀ
			//� PROCESSANDO ARQUIVO DE TRABALHO                        �
			//����������������������������������������������������������
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
					//��������������������������������������������������������Ŀ
					//� Verifica se ha produtos sem movimentos				   �
					//����������������������������������������������������������
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
					//����������������������������������Ŀ
					//� Imprime Saldo Inicial do Produto �
					//������������������������������������
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

		//��������������������������������������������������������������Ŀ
		//� Impressao de Termos Abertura e Encerramento                  �
		//����������������������������������������������������������������
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

		//�������������������������������������������������������������Ŀ
		//� Fecha alias em uso                                          �
		//���������������������������������������������������������������
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
	
		//���������������������������������������������Ŀ
		//� Atualiza o log de processamento			    �
		//�����������������������������������������������
		ProcLogAtu("MENSAGEM",STR0044 + cFilAnt ,STR0044 + cFilAnt) //"Termino da Impressao do relatorio - Filial : ## "
	
	EndIf

Next nForFilial

// Restaura filial original apos processamento
cFilAnt := cFilBack 

//���������������������������������������������Ŀ
//� Atualiza o log de processamento			    �
//�����������������������������������������������
ProcLogAtu("MENSAGEM",STR0045,STR0045) //"Processamento Encerrado"

//�����������������������������������Ŀ
//� Atualiza o log de processamento   �
//�������������������������������������
ProcLogAtu("FIM")

//��������������������������������������������������������������Ŀ
//� Restaura Ambiente                                            �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R470Cabec� Autor � Gilson do Nascimento  � Data � 16.09.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cabecalho do Relatorio do Kardex,     Registro Modelo 3    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR470                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//��������������������������������������������������������������Ŀ
//� Reinicia a Numeracao das Paginas por feixe                   �
//����������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �MTR470VAlm � Autor �Rodrigo de A. Sartorio � Data �26/06/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Valida Almoxarifado do KARDEX com relacao a custo unificado ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR470                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function MTR470VAlm
Local lRet:=.T.
Local cConteudo:=&(ReadVar())
Local nOpc:=2
Local lCusUnif := A330CusFil() // Identifica qdo utiliza custo por empresa

If lCusUnif .And. AllTrim(cConteudo) != cALL_LOC
	nOpc := Aviso(STR0030,STR0031,{STR0032,STR0033})	//"Aten��o"###"Ao alterar o almoxarifado o custo medio unificado sera desconsiderado."###"Confirma"###"Abandona"
	If nOpc == 2
		lRet:=.F.
	EndIf
EndIf
Return lRet


/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �M470NoCFOP � Autor �Robson Sales           � Data �27/11/13 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Tratamento para string contendo CFOP's a desconsiderar      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR470                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
����������������������������������������������������������������������������*/
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
