//#INCLUDE "MATR285.CH"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATR285R3³ Autor ³ Eveli Morasco         ³ Data ³ 05/02/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Listagem dos itens inventariados                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Gen‚rico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³04/12/97³07906A³Definir a moeda a ser utilizada(mv_par10) ³±±
±±³Marcelo Pim.³09/12/97³07618A³Ajuste no posicionamento inicial do B7 p/ ³±±
±±³            ³        ³      ³nao utilizar o Local padrao.              ³±±
±±³Fernando J. ³23/09/98³06744A³Incluir informa‡”oes de LOTE, SUB-LOTE e  ³±±
±±³            ³        ³      ³NUMERO DE SERIE.                          ³±±
±±³Rodrigo Sar.³17/11/98³18459A³Acerto na impressao qdo almoxarifado CQ   ³±±
±±³Cesar       ³30/03/99³20706A³Imprimir Numero do Lote                   ³±±
±±³Cesar       ³30/03/99³XXXXXX³Manutencao na SetPrint()                  ³±±
±±³Fernando Jol³20/09/99³19581A³Incluir pergunta "Imprime Lote/Sub-Lote?" ³±±
±±³Patricia Sal³30/12/99³XXXXXX³Acerto LayOut (Doc. 12 digitos);Troca da  ³±±
±±³            ³        ³      ³PesqPictQt() pela PesqPict().             ³±±
±±³Marcos Hirak³12/12/03³XXXXXX³Imprimir B1_CODITO quando for gestão de   ³±±
±±³            ³        ³      ³Concessionárias ( MV_VEICULO = "S")       ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATR285R3()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local Tamanho 
Local Titulo  := "Listagem dos Itens Inventariados" // 'Listagem dos Itens Inventariados'
Local cDesc1  := "Emite uma relacao que mostra o saldo em estoque e todas as" // 'Emite uma relacao que mostra o saldo em estoque e todas as'
Local cDesc2  := "contagens efetuadas no inventario. Baseado nestas duas in-" // 'contagens efetuadas no inventario. Baseado nestas duas in-'
Local cDesc3  := "formacoes ele calcula a diferenca encontrada." // 'formacoes ele calcula a diferenca encontrada.'
Local cString := 'SB1'
Local nTipo   := 0
Local aOrd    := {OemToAnsi(" Por Codigo    "),OemToAnsi(" Por Tipo      "),OemToAnsi(" Por Grupo   "),OemToAnsi(" Por Descricao "),OemToAnsi(" Por Armazem  ")}		//' Por Codigo    '###' Por Tipo      '###' Por Grupo   '###' Por Descricao '###' Por Local    '
Local wnRel   := 'MATR285'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea1	:= Getarea() 
Local nTamSX1   := Len(SX1->X1_GRUPO)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private para SIGAVEI, SIGAPEC e SIGAOFI       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private lVEIC   := UPPER(GETMV("MV_VEICULO"))=="S"
Private aSB1Cod := {}
Private aSB1Ite := {}
Private nCOL1	 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn  := {OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, '',1 }   //'Zebrado'###'Administracao'
Private nLastKey := 0
Private cPerg    := 'MTR285'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajustar o SX2 para SIGAVEI, SIGAPEC e SIGAOFI                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If lVEIC
	aSB1Cod	:= TAMSX3("B1_COD")
	aSB1Ite	:= TAMSX3("B1_CODITE")
	nCOL1		:= ABS(aSB1Cod[1] - aSB1Ite[1])
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(PADR(cPerg,nTamSX1))
	Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> 27 .Or. Upper(SX1->X1_F3) <> "VR4")
			Reclock("SX1",.F.)
			SX1->X1_TAMANHO := 27
			SX1->X1_F3 := "VR4"
			dbCommit()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
   dbCommitAll()
   RestArea(aArea1)
Else
	dbSelectArea("SX1")
	dbSetOrder(1)
	dbSeek(PADR(cPerg,nTamSX1))
	Do While SX1->X1_GRUPO == PADR(cPerg,nTamSX1) .And. !SX1->(Eof())
		If "PRODU" $ Upper(SX1->X1_PERGUNT) .And. Upper(SX1->X1_TIPO) == "C" .And. (SX1->X1_TAMANHO <> 15 .Or. UPPER(SX1->X1_F3) <> "SB1")
			Reclock("SX1",.F.)
			SX1->X1_TAMANHO := 15
			SX1->X1_F3 := "SB1"
			dbCommit()
			MsUnlock()
		EndIf
		dbSkip()
	EndDo
	dbCommitAll()
	RestArea(aArea1)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o Grupo de Perguntas MATR285                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Produto de                           ³
//³ mv_par02             // Produto ate                          ³
//³ mv_par03             // Data de Selecao                      ³
//³ mv_par04             // De  Tipo                             ³
//³ mv_par05             // Ate Tipo                             ³
//³ mv_par06             // De  Local                            ³
//³ mv_par07             // Ate Local                            ³
//³ mv_par08             // De  Grupo                            ³
//³ mv_par09             // Ate Grupo                            ³
//³ mv_par10             // Qual Moeda (1 a 5)                   ³
//³ mv_par11             // Imprime Lote/Sub-Lote                ³
//³ mv_par12             // Custo Medio Atual/Ultimo Fechamento  ³
//³ mv_par13             // Imprime Localizacao ?                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Pergunte(cPerg,.F.)

// Utiliza‡„o do aReturn[4] e do nTamanho
// aReturn[4] := 1=Comprimido 2=Normal
// nTamanho   := If(aReturn[4]==1,'G','P')

Tamanho := 'G'
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

SetDefault(aReturn,cString)
           
If nLastKey == 27
	dbClearFilter()
	Return Nil
Endif

RptStatus({|lEnd| C285Imp(aOrd,@lEnd,wnRel,cString,titulo,Tamanho)},titulo)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C285IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR285                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function C285Imp(aOrd,lEnd,WnRel,cString,titulo,Tamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local nSB7Cnt  := 0
Local i		   := 0
Local nTotal   := 0
Local nTotVal  := 0
Local nSubVal  := 0
Local nTValIn  := 0
Local nSValIn  := 0
Local nTValDt  := 0
Local nSValDt  := 0
Local nCntImpr := 0
Local cAnt     := '',cSeek:='',cCompara :='',cLocaliz:='',cNumSeri:='',cLoteCtl:='',cNumLote:=''
Local cRodaTxt := "PRODUTO(S)" // 'PRODUTO(S)'
Local aSaldo   := {}
Local aSalQtd  := {}
Local aCM      := {}
Local lQuery   := .F.
Local cQuery   := ""
Local cQueryB1 := ""
Local aStruSB1 := {}
Local aStruSB2 := {}
Local aStruSB7 := {}
Local aRegInv  := {}
Local cAliasSB1:= "SB1"
Local cAliasSB2:= "SB2"
Local cAliasSB7:= "SB7"
Local cProduto := ""
Local cLocal   := ""
Local lFirst   := .T.
Local nX       := 0
Local lImprime := .T.
Local lContagem:=(SB7->(FieldPos("B7_CONTAGE")) > 0) .And. (SB7->(FieldPos("B7_ESCOLHA")) > 0) .And. (SB7->(FieldPos("B7_OK")) > 0) .And. SuperGetMv('MV_CONTINV',.F.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Local para SIGAVEI, SIGAPEC e SIGAOFI         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cNomArq	:= ""
Local cKey		:= ""
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas qdo almoxarifado do CQ                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local	cLocCQ	:= GetMV("MV_CQ")
Private	lLocCQ	:=.T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis privadas exclusivas deste programa                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private cCondicao := '!Eof()'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private Li    := 80
Private m_Pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona a ordem escolhida ao titulo do relatorio          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type('NewHead') # 'U'
	NewHead += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
Else
	Titulo += ' (' + AllTrim(aOrd[aReturn[8]]) + ')'
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If mv_par11 == 1
	If mv_par13 == 1
        Cabec1 := "CODIGO          DESCRICAO                      LOTE       SUB    ENDERECO        NUMERO DE SERIE      TP GRP UM AMZ DOCUMENTO         QUANTIDADE         QTD NA DATA       _____________DIFERENCA______________" // 'CODIGO          DESCRICAO                LOTE       SUB    LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE               VALOR        QTD NA DATA               VALOR  _____________DIFERENCA______________'
        Cabec2 := "                                                          LOTE                                                                      INVENTARIADA        DO INVENTARIO         QUANTIDADE              VALOR" // '                                                    LOTE                                                                         INVENTARIADA                           DO INVENTARIO                      QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20
        //--                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
	Else
        Cabec1 := "CODIGO          DESCRICAO                      LOTE       SUB    TP GRP UM AMZ DOCUMENTO         QUANTIDADE         QTD NA DATA       _____________DIFERENCA______________" // 'CODIGO          DESCRICAO                LOTE       SUB    TP GRP  UM AL DOCUMENTO            QUANTIDADE               VALOR        QTD NA DATA               VALOR  _____________DIFERENCA______________'
        Cabec2 := "                                                          LOTE                                  INVENTARIADA       DO INVENTARIO         QUANTIDADE              VALOR" // '                                                    LOTE                                    INVENTARIADA                           DO INVENTARIO                      QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 1234567890 123456 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16   
        //--                  0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
	EndIf	
Else
	If mv_par13 == 1
        Cabec1 := "CODIGO          DESCRICAO                      ENDERECO        NUMERO DE SERIE      TP GRP UM AMZ DOCUMENTO         QUANTIDADE         QTD NA DATA       _______________DIFERENCA_____________" // 'CODIGO          DESCRICAO                LOCALIZACAO     NUMERO DE SERIE      TP GRP  UM AL DOCUMENTO            QUANTIDADE               VALOR        QTD NA DATA               VALOR  _______________DIFERENCA_____________'
        Cabec2 := "                                                                                                                   INVENTARIADA       DO INVENTARIO          QUANTIDADE              VALOR" // '                                                                                                               INVENTARIADA                          DO INVENTARIO 	                          QUANTIDADE              VALOR'
        //--                  123456789012345 123456789012345678901234 123456789012345 12345678901234567890 12 1234 12 12 123456789012 999.999.999.999,99  999.999.999.999,99 999.999.999.999,99  999.999.999.999,99  999.999.999.999,99 999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14       15        16        17        18
        //--                  012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567801234567890123456789012345678901234567890123456789012345678901234567890123456789012
	Else
        Cabec1 :=            'CODIGO   DESCRICAO                            TP GRP  UM AL DOCUMENTO        QUANTIDADE                   VALOR           QTD NA DATA             VALOR   _______________DIFERENCA_____________'
        Cabec2 :=            '                                                                            INVENTARIADA                                 DO INVENTARIO                           QUANTIDADE               VALOR'
        //--                  123456789012345 123456789012345678901234 12 1234 12 12 123456789012      999.999.999.999,99   999.999.999.999,99     999.999.999.999,99 999.999.999.999,99 999.999.999.999,99   999.999.999.999,99
        //--                  0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
        //--                  01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456780123456789012345678901234567890123456789012345
	EndIf
EndIf
If lVEIC
   Cabec1 := substr(Cabec1,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(Cabec1,aSB1Cod[1]+1)
   Cabec2 := substr(Cabec2,1,aSB1Cod[1]) + SPACE(nCOL1) + substr(Cabec2,aSB1Cod[1]+1)
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os Arquivos e Ordens a serem utilizados           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea('SB2')
dbSetOrder(1)

dbSelectArea('SB7')
dbSetOrder(1)

dbSelectArea('SB1')
SetRegua(LastRec())

#IFDEF TOP
	If aReturn[8] == 2
		dbSetOrder(2) //-- Tipo
	ElseIf aReturn[8] == 3
		If lVEIC
			dbSetOrder(7) //--  B1_FILIAL+B1_GRUPO+B1_CODITE
		Else
			dbSetOrder(4) //-- Grupo
		EndIf	
	ElseIf aReturn[8] == 4
		dbSetOrder(3) //-- Descricao
	ElseIf aReturn[8] == 5
		If lVEIC
			cKey    := ' B1_FILIAL, B1_LOCPAD, B1_CODITE'
		Else
			cKey    := ' B1_FILIAL, B1_LOCPAD, B1_COD'
		EndIf	
		cKey    := Upper(cKey)
	Else
		If lVEIC
			cKey    := ' B1_FILIAL, B1_CODITE'
			cKey    := Upper(cKey)
		Else                                                                                                                                                           	
		dbSetOrder(1) //-- Codigo
		EndIf	
	EndIf

	lQuery 	  := .T.
	aStruSB1  := SB1->(dbStruct())
	aStruSB2  := SB2->(dbStruct())
	aStruSB7  := SB7->(dbStruct())

	cAliasSB1 := "R285IMP"
	cAliasSB2 := "R285IMP"
	cAliasSB7 := "R285IMP"

    If Empty(aReturn[7])
		cQuery    := "SELECT "
		cQuery    += "SB1.R_E_C_N_O_ SB1REC, "
		cQuery    += "SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM , "
		If lVEIC
			cQuery    += "SB1.B1_CODITE , "
		EndIf
    Else
		cQueryB1    += "SB1.B1_FILIAL, SB1.B1_COD, SB1.B1_LOCPAD, SB1.B1_TIPO, SB1.B1_GRUPO, SB1.B1_DESC, SB1.B1_UM , "
		If lVEIC
			cQueryB1+= "SB1.B1_CODITE , "
		EndIf
    	cQuery	  := "SELECT "
		cQuery    += "SB1.R_E_C_N_O_ SB1REC, "
        //Adiciona os campos do filtro na Query
    	cQuery    += cQueryB1 + A285QryFil("SB1",cQueryB1,aReturn[7])
    EndIf	
	cQuery    += "SB2.R_E_C_N_O_ SB2REC, "
	cQuery    += "SB2.B2_FILIAL, SB2.B2_COD, SB2.B2_LOCAL, SB2.B2_DINVENT, "
	cQuery    += "SB7.R_E_C_N_O_ SB7REC, "
	cQuery    += "SB7.B7_FILIAL, SB7.B7_COD, SB7.B7_LOCAL, SB7.B7_DATA, SB7.B7_LOCALIZ, SB7.B7_NUMSERI, SB7.B7_LOTECTL, SB7.B7_NUMLOTE, SB7.B7_DOC, SB7.B7_QUANT "
	If lContagem
		cQuery += " ,SB7.B7_ESCOLHA ,SB7.B7_CONTAGE " 				
	EndIf
	cQuery    += "FROM "
	cQuery    += RetSqlName("SB1")+" SB1, "
	cQuery    += RetSqlName("SB2")+" SB2, "
	cQuery    += RetSqlName("SB7")+" SB7  "

	cQuery    += "WHERE "
	cQuery    += "SB1.B1_FILIAL = '"+xFilial("SB1")+"' And "

	cQuery += "SB1.B1_TIPO  >= '"+mv_par04+"' And SB1.B1_TIPO  <= '"+mv_par05+"' And "
	cQuery += "SB1.B1_GRUPO >= '"+mv_par08+"' And SB1.B1_GRUPO <= '"+mv_par09+"' And "

	If aReturn[8] == 5
		cQuery += "SB1.B1_LOCPAD>= '"+mv_par06+"' And SB1.B1_LOCPAD<= '"+mv_par07+"' And "
	EndIf

	If lVEIC
		cQuery += "SB1.B1_CODITE >= '"+mv_par01+"' And SB1.B1_CODITE <= '"+mv_par02+"' And "
	Else
		cQuery += "SB1.B1_COD    >= '"+mv_par01+"' And SB1.B1_COD   <= '"+mv_par02+"' And "
	EndIf			
	cQuery    += "SB1.D_E_L_E_T_ = ' ' And "

	cQuery    += "SB2.B2_FILIAL = '"+xFilial("SB2")+"' And "
	cQuery    += "SB2.B2_COD = SB1.B1_COD And "
	cQuery    += "SB2.B2_LOCAL = SB7.B7_LOCAL And "
	cQuery    += "SB2.D_E_L_E_T_ = ' ' And "
	cQuery    += "SB7.B7_FILIAL = '"+xFilial("SB7")+"' And "
	cQuery    += "SB7.B7_COD = SB1.B1_COD And "
	cQuery    += "SB7.B7_LOCAL >= '"+mv_par06+"' And SB7.B7_LOCAL <= '"+mv_par07+"' And "
	cQuery    += "SB7.B7_DATA   = '"+DtoS(mv_par03)+"' And "
	cQuery    += "SB7.D_E_L_E_T_ = ' ' "
	If lContagem
		cQuery += " AND SB7.B7_ESCOLHA = 'S' " 				
	EndIf

	If lVEIC
		If aReturn[8] == 1 // codite
			cQuery    += "ORDER BY " +	cKey // B1_FILIAL , B1_CODITE
		ElseIf aReturn[8] == 5 // local
			cQuery    += "ORDER BY " + cKey // B1_FILIAL, B1_LOCPAD, B1_CODITE
		Else
			cQuery    += "ORDER BY "+SqlOrder(SB1->(IndexKey()))
		EndIf	
	Else
		If aReturn[8] == 5 // local
			cQuery    += "ORDER BY " + cKey // B1_FILIAL, B1_LOCPAD, B1_COD
		Else	
			cQuery    += "ORDER BY "+SqlOrder(SB1->(IndexKey()))
		EndIf	
	EndIf			

	cQuery    := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSB1,.T.,.T.)

	For nX := 1 To Len(aStruSB1)
		If ( aStruSB1[nX][2] <> "C" ) .And. FieldPos(aStruSB1[nX][1]) > 0
			TcSetField(cAliasSB1,aStruSB1[nX][1],aStruSB1[nX][2],aStruSB1[nX][3],aStruSB1[nX][4])
		EndIf
	Next nX

	For nX := 1 To Len(aStruSB2)
		If ( aStruSB2[nX][2] <> "C" ) .And. FieldPos(aStruSB2[nX][1]) > 0
			TcSetField(cAliasSB2,aStruSB2[nX][1],aStruSB2[nX][2],aStruSB2[nX][3],aStruSB2[nX][4])
		EndIf
	Next nX

	For nX := 1 To Len(aStruSB7)
		If ( aStruSB7[nX][2] <> "C" ) .And. FieldPos(aStruSB7[nX][1]) > 0
			TcSetField(cAliasSB7,aStruSB7[nX][1],aStruSB7[nX][2],aStruSB7[nX][3],aStruSB7[nX][4])
		EndIf
	Next nX
	cAnt:= ""
	If aReturn[8] == 2
		cAnt	:= (cAliasSB1)->B1_TIPO
	ElseIf aReturn[8] == 3
		cAnt	:= (cAliasSB1)->B1_GRUPO
	EndIf
#ELSE	
	cCondicao += " .And. B1_FILIAL == '" + xFilial('SB1') + "'"
	If aReturn[8] == 2
  	   If lVEIC
			cNomArq := CriaTrab('', .F.) //-- Local
			cKey    := "B1_FILIAL + B1_TIPO + B1_CODITE"
			IndRegua('SB1',cNomArq,cKey,,,"Selecionando Registros...") // 'Selecionando Registros...'
		Else	
			dbSetOrder(2) //-- Tipo
		EndIf	
		dbSeek(cFilial + mv_par04 + mv_par01 , .T.)
		cCondicao += " .And. B1_TIPO <= mv_par05"
		cAnt      := B1_TIPO
	ElseIf aReturn[8] == 3
		If lVEIC
			dbSetOrder(7) //--  B1_FILIAL+B1_GRUPO+B1_CODITE
		Else
			dbSetOrder(4) //-- Grupo
		EndIf
		dbSeek(cFilial + mv_par08 + mv_par01 , .T.)
		cCondicao += " .And. B1_GRUPO <= mv_par09"
		cAnt      := B1_GRUPO
	ElseIf aReturn[8] == 4
		dbSetOrder(3) //-- Descricao                                                                            	
		dbSeek(cFilial)
	ElseIf aReturn[8] == 5
		cNomArq := CriaTrab('', .F.) //-- Local
		If lVEIC
			cKey    := "B1_FILIAL + B1_LOCPAD + B1_CODITE"
		Else
			cKey    := "B1_FILIAL + B1_LOCPAD + B1_COD"
		EndIf
		IndRegua('SB1',cNomArq,cKey,,,"Selecionando Registros...") // 'Selecionando Registros...'
		dbSeek(cFilial + mv_par06 +  mv_par01, .T.)
		cCondicao += " .And. B1_LOCPAD <= mv_par07"
	Else
		If lVEIC
			cNomArq := CriaTrab('', .F.) //-- CODITE
			cKey    := "B1_FILIAL + B1_CODITE"
			IndRegua('SB1',cNomArq,cKey,,,"Selecionando Registros...") // 'Selecionando Registros...'
			cCondicao += " .And. (B1_CODITE <= mv_par02)"
		Else
			dbSetOrder(1) //-- Codigo
			cCondicao += " .And. B1_COD <= mv_par02"
		EndIf
		dbSeek(cFilial + mv_par01, .T.)
	EndIf
#ENDIF

nTotVal := 0
nSubVal := 0
nTValIn := 0
nSValIn := 0
nTValDt := 0
nSValDt := 0





Do While &cCondicao

	#IFNDEF TOP
	   If lVEIC
			If ((cAliasSB1)->B1_CODITE > mv_par02 .And. aReturn[8] == 1)  
				Exit
			ElseIf ((cAliasSB1)->B1_GRUPO < mv_par08) .Or. ((cAliasSB1)->B1_GRUPO  > mv_par09) .Or. ;
				   ((cAliasSB1)->B1_TIPO   < mv_par04) .Or. ((cAliasSB1)->B1_TIPO   > mv_par05) .Or. ;
				   ((cAliasSB1)->B1_CODITE < mv_par01) .Or. ((cAliasSB1)->B1_CODITE > mv_par02)
 				    (cAliasSB1)->(dbSkip())
			        Loop
			EndIf
	   Else
			If ((cAliasSB1)->B1_COD > mv_par02 .And. aReturn[8] == 1)
				Exit
			ElseIf ((cAliasSB1)->B1_GRUPO < mv_par08) .Or. ((cAliasSB1)->B1_GRUPO > mv_par09) .Or. ;
				   ((cAliasSB1)->B1_TIPO  < mv_par04) .Or. ((cAliasSB1)->B1_TIPO  > mv_par05) .Or. ;
				   ((cAliasSB1)->B1_COD   < mv_par01) .Or. ((cAliasSB1)->B1_COD   > mv_par02)
					(cAliasSB1)->(dbSkip())
					Loop
			EndIf
		EndIf
	#ENDIF

    If !Empty(aReturn[7]) .And. !&(aReturn[7])
       (cAliasSB1)->(dbSkip())
		Loop
	EndIf

	If lFirst  
		If aReturn[8] == 2 .and. cAnt <> (cAliasSB1)->B1_TIPO
			cAnt := (cAliasSB1)->B1_TIPO
			lFirst := .F.
		ElseIf aReturn[8] == 3 .and. cAnt <> (cAliasSB1)->B1_GRUPO
			cAnt := (cAliasSB1)->B1_GRUPO
			lFirst := .F.
		EndIf
	EndIf	
	If lEnd
		@ pRow()+1, 000 PSAY "CANCELADO PELO OPERADOR" // 'CANCELADO PELO OPERADOR'
		Exit
	EndIF
	
	IncRegua()

	#IFNDEF TOP
		(cAliasSB2)->(dbSeek(xFilial('SB2') + (cAliasSB1)->B1_COD, .T.))

		Do While !(cAliasSB2)->(Eof()) .And. (cAliasSB2)->B2_FILIAL+(cAliasSB2)->B2_COD == xFilial('SB2')+(cAliasSB1)->B1_COD

			(cAliasSB7)->(dbSeek(xFilial('SB7') + DtoS(mv_par03) + (cAliasSB2)->B2_COD + (cAliasSB2)->B2_LOCAL, .T.))
	#ENDIF

		cProduto := (cAliasSB2)->B2_COD
		cLocal   := (cAliasSB2)->B2_LOCAL

		Do While !(cAliasSB7)->(Eof()) .And. (cAliasSB7)->(B7_FILIAL+DtoS(B7_DATA)+B7_COD+B7_LOCAL) == xFilial('SB7')+DtoS(mv_par03)+cProduto+cLocal
			
			#IFNDEF TOP
				If ((cAliasSB7)->B7_LOCAL < mv_par06) .Or. ((cAliasSB7)->B7_LOCAL > mv_par07)
					(cAliasSB7)->(dbSkip())
					Loop
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Caso utilize contagem so considera a contagem escolhida      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lContagem .And. (cAliasSB7)->B7_ESCOLHA <> 'S'
					(cAliasSB7)->(dbSkip())
					Loop
				EndIf
			#ENDIF
			
			nTotal   := 0
			nSB7Cnt  := 0
			aRegInv  := {}
			cSeek    := xFilial('SB7')+DtoS(mv_par03)+(cAliasSB7)->B7_COD+(cAliasSB7)->B7_LOCAL+(cAliasSB7)->B7_LOCALIZ+(cAliasSB7)->B7_NUMSERI+(cAliasSB7)->B7_LOTECTL+(cAliasSB7)->B7_NUMLOTE
			cCompara := "B7_FILIAL+DTOS(B7_DATA)+B7_COD+B7_LOCAL+B7_LOCALIZ+B7_NUMSERI+B7_LOTECTL+B7_NUMLOTE"
			cLocaliz := (cAliasSB7)->B7_LOCALIZ
			cNumSeri := (cAliasSB7)->B7_NUMSERI
			cLoteCtl := (cAliasSB7)->B7_LOTECTL
			cNumLote := (cAliasSB7)->B7_NUMLOTE
			lImprime := .T.
			
			Do While !(cAliasSB7)->(Eof()) .And. cSeek == (cAliasSB7)->&(cCompara)
				
				#IFNDEF TOP
					If ((cAliasSB7)->B7_LOCAL < mv_par06) .Or. ((cAliasSB7)->B7_LOCAL > mv_par07)
						(cAliasSB7)->(dbSkip())
						Loop
					EndIf
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso utilize contagem so considera a contagem escolhida      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If lContagem .And. (cAliasSB7)->B7_ESCOLHA <> 'S'
						(cAliasSB7)->(dbSkip())
						Loop
					EndIf
				#ENDIF

				nSB7Cnt++
				
				aAdd(aRegInv,{	Left(cProduto,15)					,; //B2_COD
								Left((cAliasSB1)->B1_DESC,37)		,; //B1_DESC
								Left((cAliasSB7)->B7_LOTECTL,10)	,; //B7_LOTECTL
								Left((cAliasSB7)->B7_NUMLOTE,06)	,; //B7_NUMLOTE
								Left((cAliasSB7)->B7_LOCALIZ,15)	,; //B7_LOCALIZ
								Left((cAliasSB7)->B7_NUMSERI,20)	,; //B7_NUMSERI
								Left((cAliasSB1)->B1_TIPO ,02)		,; //B1_TIPO
								Left((cAliasSB1)->B1_GRUPO,04)		,; //B1_GRUPO
								Left((cAliasSB1)->B1_UM   ,02)		,; //B1_UM
								Left((cAliasSB2)->B2_LOCAL,02)		,; //B2_LOCAL
								(cAliasSB7)->B7_DOC					,; //B7_DOC
								Transform((cAliasSB7)->B7_QUANT,(cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)) ) } ) //B7_QUANT

				nTotal += (cAliasSB7)->B7_QUANT
				
				(cAliasSB7)->(dbSkip())
			EndDo
			
			#IFNDEF TOP
				If nSB7Cnt == 0
					(cAliasSB2)->(dbSkip())
					Loop
				EndIf
			#ENDIF	
		
			If (Localiza(cProduto) .And. !Empty(cLocaliz+cNumSeri)) .Or. (Rastro(cProduto) .And. !Empty(cLotectl+cNumLote))
				aSalQtd   := CalcEstL(cProduto,cLocal,mv_par03+1,cLoteCtl,cNumLote,cLocaliz,cNumSeri)
				aSaldo    := CalcEst(cProduto,cLocal,mv_par03+1)
				aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
				aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
				aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
				aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
				aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
				aSaldo[7] := aSalQtd[7]
				aSaldo[1] := aSalQtd[1]
			Else
				If cLocCQ == cLocal
					aSalQtd	  := A340QtdCQ(cProduto,cLocal,mv_par03+1,"")
					aSaldo	  := CalcEst(cProduto,cLocal,mv_par03+1)
					aSaldo[2] := (aSaldo[2] / aSaldo[1]) * aSalQtd[1]
					aSaldo[3] := (aSaldo[3] / aSaldo[1]) * aSalQtd[1]
					aSaldo[4] := (aSaldo[4] / aSaldo[1]) * aSalQtd[1]
					aSaldo[5] := (aSaldo[5] / aSaldo[1]) * aSalQtd[1]
					aSaldo[6] := (aSaldo[6] / aSaldo[1]) * aSalQtd[1]
					aSaldo[7] := aSalQtd[7]
					aSaldo[1] := aSalQtd[1]
				Else
					aSaldo := CalcEst(cProduto,cLocal,mv_par03+1)
				EndIf
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Validacao do Total da Diferenca X Saldo Disponivel           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nTotal-aSaldo[1] == 0
				If mv_par14 == 1
					lImprime := .F.
				EndIf	
			Else 
			    If mv_par14 == 2
				   lImprime := .F.
				EndIf 
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do Inventario                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lImprime .Or. mv_par14 == 3
						
				For nX:=1 to Len(aRegInv)
					
					If Li > 55
						Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
					EndIf
					
					If nX == 1
						@ Li, 000 PSAY aRegInv[nX,01] //B1_CODITE
						@ Li, 009 + nCOL1 PSAY aRegInv[nX,02] //B1_DESC
					EndIf
	
					If mv_par11 == 1  
						@ Li, 047 + nCOL1 PSAY aRegInv[nX,03] //B7_LOTECTL
						@ Li, 058 + nCOL1 PSAY aRegInv[nX,04] //B7_NUMLOTE
						If mv_par13 == 1                            
							@ Li, 065 + nCOL1 PSAY aRegInv[nX,05] //B7_LOCALIZ
							@ Li, 081 + nCOL1 PSAY aRegInv[nX,06] //B7_NUMSERI
						EndIf
						If nX == 1
							@ Li,If(mv_par13==1,102,065) + nCOL1 PSAY aRegInv[nX,07] //B1_TIPO
							@ Li,If(mv_par13==1,105,068) + nCOL1 PSAY aRegInv[nX,08] //B1_GRUPO
							@ Li,If(mv_par13==1,109,073) + nCOL1 PSAY aRegInv[nX,09] //B1_UM
							@ Li,If(mv_par13==1,113,076) + nCOL1 PSAY aRegInv[nX,10] //B2_LOCAL 
						EndIf
						@ Li,If(mv_par13==1,116,079) + nCOL1 PSAY aRegInv[nX,11] //B7_DOC
						@ Li,If(mv_par13==1,129,092) + nCOL1 PSAY aRegInv[nX,12] //B7_QUANT
					Else
						If mv_par13 == 1
							@ Li, 047 + nCOL1 PSAY aRegInv[nX,05] //B7_LOCALIZ
							@ Li, 063 + nCOL1 PSAY aRegInv[nX,06] //B7_NUMSERI
						EndIf
						If nX == 1							
							@ Li,If(mv_par13==1,084,047) + nCOL1 PSAY aRegInv[nX,07] //B1_TIPO
							@ Li,If(mv_par13==1,087,050) + nCOL1 PSAY aRegInv[nX,08] //B1_GRUPO
							@ Li,If(mv_par13==1,092,054) + nCOL1 PSAY aRegInv[nX,09] //B1_UM
							@ Li,If(mv_par13==1,095,057) + nCOL1 PSAY aRegInv[nX,10] //B2_LOCAL 							
						EndIf
						@ Li,If(mv_par13==1,098,061) + nCOL1 PSAY aRegInv[nX,11] //B7_DOC
						@ Li,If(mv_par13==1,111,074) + nCOL1 PSAY aRegInv[nX,12] //B7_QUANT						
					EndIf
	
					Li++
			
				Next nX
					
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Adiciona 1 ao contador de registros impressos         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nCntImpr++

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Movido aqui devido a necessidade de obter o custo     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				If nSB7Cnt > 0
					If mv_par12 == 1
						aCM:={}
						If QtdComp(aSaldo[1]) > QtdComp(0)
							For i:=2 to Len(aSaldo)
								AADD(aCM,aSaldo[i]/aSaldo[1])
							Next i
        	    		Else
							aCm := PegaCmAtu(cProduto,cLocal)
	            		EndIf
                	Else
            	    	aCM := PegaCMFim(cProduto,cLocal)
					EndIf  
				EndIf
			
				If nSB7Cnt == 1
					Li--
				ElseIf nSB7Cnt > 1
					If mv_par11 == 1
						@ Li,If(mv_par13==1,	106,069) + nCOL1 PSAY "TOTAL ................." // 'TOTAL .................'
						@ Li,If(mv_par13==1,129,092) + nCOL1 PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					Else
						@ Li,If(mv_par13==1,088,050) + nCOL1 PSAY "TOTAL ................." // 'TOTAL .................'
						@ Li,If(mv_par13==1,111,074) + nCOL1 PSAY Transform(nTotal, (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
					EndIf
				EndIf

				If mv_par11 == 1
					@ Li,If(mv_par13==1,149,112) + nCOL1 PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
				Else
					@ Li,If(mv_par13==1,131,094) + nCOL1 PSAY Transform(nTotal*aCM[mv_par10],"@E 999,999,999,999.99")
					@ Li,If(mv_par13==1,160,120) + nCOL1 PSAY Transform(aSaldo[1], (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
				EndIf
				
				If nSB7Cnt > 0
/*			If mv_par12 == 1
						aCM:={}
						If QtdComp(aSaldo[1]) > QtdComp(0)
							For i:=2 to Len(aSaldo)
								AADD(aCM,aSaldo[i]/aSaldo[1])
							Next i
        	    		Else
							aCm := PegaCmAtu(cProduto,cLocal)
	            		EndIf
                	Else
            	    	aCM := PegaCMFim(cProduto,cLocal)
					EndIf                  */
		            dbSelectArea(cAliasSB7)

					If mv_par11 == 1 
						@ Li,If(mv_par13==1,169,132) + nCOL1 PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))
						@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
					Else                
						@ Li,If(mv_par13==1,172,135) + nCOL1 PSAY Transform(aSaldo[1]*aCM[mv_par10], "@E 999,999,999,999.99")												
						@ Li,If(mv_par13==1,195,158) + nCOL1 PSAY Transform(nTotal-aSaldo[1], (cAliasSB7)->(PesqPict("SB7",'B7_QUANT', 15)))  						
						@ Li,If(mv_par13==1,215,178) + nCOL1 PSAY Transform((nTotal-aSaldo[1])*aCM[mv_par10], (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))	
					EndIf
					nTotVal += (nTotal-aSaldo[1])*aCM[mv_par10]
					nSubVal += (nTotal-aSaldo[1])*aCM[mv_par10]
					nTValIn += nTotal*aCM[mv_par10]
					nSValIn += nTotal*aCM[mv_par10]
					nTValDt += aSaldo[1]*aCM[mv_par10]
					nSValDt += aSaldo[1]*aCM[mv_par10]
					
				EndIf
				Li++
			Else
				#IFNDEF TOP
					(cAliasSB2)->(dbSkip())
					Loop
				#ENDIF	
			EndIf
		EndDo
		
	#IFNDEF TOP
		(cAliasSB2)->(dbSkip())
		
	EndDo

	dbSelectArea(cAliasSB1)
	dbSkip()
	#ENDIF
	
	If aReturn[8] == 2
		If cAnt # B1_TIPO .And. nSB7Cnt >= 1
			If mv_par11 == 1
				@ Li,If(mv_par13==1,158,120) + nCOL1 PSAY "TOTAL DO TIPO " + Left(cAnt,2) + ' .............' // 'TOTAL DO TIPO '
				@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			Else     
				@ Li,If(mv_par13==1,102,058) + nCOL1 PSAY "TOTAL DO TIPO " + Left(cAnt,2) + ' ............' // 'TOTAL DO TIPO '
    			@ Li,If(mv_par13==1,131,094) + nCOL1 PSAY Transform(nSValIn, "@E 999,999,999,999.99")	
				@ Li,If(mv_par13==1,172,135) + nCOL1 PSAY Transform(nSValDt, "@E 999,999,999,999.99")	
				@ Li,If(mv_par13==1,215,178) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			EndIf
			cAnt    := B1_TIPO
			nSubVal := 0   
			nSValIn := 0
			nSValDt := 0
			Li += 2
			nSB7Cnt := 0
		EndIf
	ElseIf aReturn[8] == 3
		If cAnt # B1_GRUPO  .And. nSB7Cnt >= 1
			If mv_par11 == 1 
				@ Li,If(mv_par13==1,155,117) + nCOL1 PSAY "TOTAL DO GRUPO " + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			Else
				@ Li,If(mv_par13==1,095,056) + nCOL1 PSAY "TOTAL DO GRUPO " + Left(cAnt,4) + ' .............' // 'TOTAL DO GRUPO '
				@ Li,If(mv_par13==1,131,094) + nCOL1 PSAY Transform(nSValIn, "@E 999,999,999,999.99")	
				@ Li,If(mv_par13==1,172,135) + nCOL1 PSAY Transform(nSValDt, "@E 999,999,999,999.99")	
				@ Li,If(mv_par13==1,215,178) + nCOL1 PSAY Transform(nSubVal, (cAliasSB2)->(PesqPict("SB2",'B2_QFIM', 15)))
			EndIf
			cAnt    := B1_GRUPO
			nSubVal := 0
			nSValIn := 0
			nSValDt := 0
			Li += 2
			nSB7Cnt := 0
		EndIf
	EndIf
	
EndDo

If nTotVal # 0
	Li++
	If mv_par11 == 1
		@ Li,If(mv_par13==1,145,107) + nCOL1 PSAY "TOTAL DAS DIFERENCAS EM VALOR ............." // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,188,151) + nCOL1 PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
	Else
		@ Li,If(mv_par13==1,120,046) + nCOL1 PSAY "TOTAL DAS DIFERENCAS EM VALOR ............." // 'TOTAL DAS DIFERENCAS EM VALOR .............'
		@ Li,If(mv_par13==1,131,094) + nCOL1 PSAY Transform(nTValIn, "@E 999,999,999,999.99")	
		@ Li,If(mv_par13==1,172,135) + nCOL1 PSAY Transform(nTValDt, "@E 999,999,999,999.99")	
		@ Li,If(mv_par13==1,215,178) + nCOL1 PSAY Transform(nTotVal, (cAliasSB2)->(PesqPict("SB2",'B2_VFIM1', 15)))
	EndIf
EndIf

If Li # 80
	Roda(nCntImpr, cRodaTxt, Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
RetIndex(cString)
dbSetOrder(1)
dbClearFilter()

#IFNDEF TOP
	(cAliasSB2)->(dbSetOrder(1))
	(cAliasSB7)->(dbSetOrder(1))
	(cAliasSB1)->(dbSetOrder(1))
#ELSE	
	dbSelectArea(cAliasSB1)
	dbCloseArea()
#ENDIF
If !empty(cNomArq)
	If aReturn[8] == 5 .or. (lVEIC .And. (aReturn[8] == 1 .or. aReturn[8] == 2))
		If File(cNomArq + OrdBagExt())
			fErase(cNomArq + OrdBagExt())
		EndIf
	EndIf
EndIf

If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
EndIf

MS_FLUSH()

Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³AjustaSX1 ³ Autor ³ Marcos V. Ferreira    ³ Data ³ 21.06.06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Ajusta o grupo de perguntas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR285                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()
Local aHelpP := {'Utilizado para listar somente produtos:'	,'- Com diferenças'		,'- Sem diferenças'		,'- Todos os produtos'	}
Local aHelpE := {'Used for show products only:'				,'- With Differences'	,'- Without Differences','- All products'		}
Local aHelpS := {'Utilizado para muestra solo productos:'	,'- Com Diferencias'	,'- Sin Diferencias'	,'- Todos los productos'}

PutSx1(	'MTR285', '14' ,'Listar Produtos ', 'Muestra Productos ', 'Show Products ',	'mv_che', 'N', 1, 0, 3, 'C', '', '', '', '', 'mv_par14','Com Diferenças',;
		'Com Diferencias','With Differences', '','Sem Diferenças','Sin Diferencias','Without Differences','Todos','Todos','All','','','','','','')
		
PutSX1Help("P.MTR28514.",aHelpP,aHelpE,aHelpS)

Return
