//#INCLUDE "MATR780.CH" 
#INCLUDE "FIVEWIN.CH"  


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR780  ³ Autor ³ Marco Bianchi         ³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Vendas por Cliente, quantidade de cada Produto, ³±±
±±³          ³ Release 4.                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MATR780()

Local oReport
	U_MATR780A()
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR780R3³ Autor ³ Gilson do Nascimento  ³ Data ³ 01.09.93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de Vendas por Cliente, quantidade de cada Produto  ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR780(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Bruno        ³05.04.00³Melhor³Acertar as colunas para 12 posicoes.    ³±±
±±³ Marcello     ³29/08/00³oooooo³Impressao de casas decimais de acordo   ³±±
±±³              ³        ³      ³com a moeda selecionada e conversao     ³±±
±±³              ³        ³      ³(xmoeda)baseada na moeda gravada na nota³±±
±±³ Rubens Pante ³04/07/01³Melhor³Utilizacao de SELECT nas versoes TOP    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
	


User Function Matr780A()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL tamanho:=IIF(cPaisLoc=="MEX","G","M")
LOCAL titulo := OemToAnsi("Estatisticas de Vendas (Cliente x Produto)")	//"Estatisticas de Vendas (Cliente x Produto)"
LOCAL cDesc1 := OemToAnsi("Este programa ira emitir a relacao das compras efetuadas pelo Cliente,")	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi("totalizando por produto e escolhendo a moeda forte para os Valores.")	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cString:= "SD2"

PRIVATE aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR780"
PRIVATE nLastKey := 0
PRIVATE cPerg   :="MR780A"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Ajusta os SXs
PutSx1(cPerg,"18","Grupo Inicial ?","Grupo Inicial ?","Grupo Inicial ?", "mv_gin", "C", 4, 0, ,"G", "", "SBM", "", "","MV_PAR18")
PutSx1(cPerg,"19","Grupo Final ?","Grupo Final ?","Grupo Final ?", "mv_gfi", "C", 4, 0, ,"G", "", "SBM", "", "","MV_PAR19")
PutSx1(cPerg,"20","Armazem Inicial ?","Armazem Inicial ?","Armazem Inicial ?", "mv_ain", "C", 2, 0, ,"G", "", "SZA", "", "","MV_PAR20")
PutSx1(cPerg,"21","Armazem Final ?","Armazem Final ?","Armazem Final ?", "mv_afi", "C", 2, 0, ,"G", "", "SZA", "", "","MV_PAR21")
PutSx1(cPerg,"22","Valor Venda Minimo?","Valor Venda Minimo?","Valor Venda Minimo?", "mv_vvm", "N", 14, 2, ,"G", "", "", "", "","MV_PAR22")
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // De Cliente                           ³
//³ mv_par02             // Ate Cliente                          ³
//³ mv_par03             // De Data                              ³
//³ mv_par04             // Ate a Data                           ³
//³ mv_par05             // De Produto                           ³
//³ mv_par06             // Ate o Produto                        ³
//³ mv_par07             // Do Vendedor                          ³
//³ mv_par08             // Ate Vendedor                         ³
//³ mv_par09             // Moeda                                ³
//³ mv_par10             // Inclui Devolu‡„o                     ³
//³ mv_par11             // Mascara do Produto                   ³
//³ mv_par12             // Aglutina Grade                       ³
//³ mv_par13	// Quanto a Estoque Movimenta/Nao Movta/Ambos    ³
//³ mv_par14	// Quanto a Duplicata Gera/Nao Gera/Ambos        ³
//³ mv_par15   // Quanto a Devolucao NF Original/NF Devolucao    ³
//³ mv_par16   // Quanto a Descricao  Produto  Prod x Cli.       ³
//³ mv_par17   // converte moeda da devolucao                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "ESTATISTICAS DE VENDAS (Cliente X Produto)"	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
Cabec1 := "CLIENTE   RAZAO SOCIAL"	//"CLIENTE   RAZAO SOCIAL"
Cabec2 := "PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE    PRECO UNITARIO            TOTAL  VENDEDOR" //"PRODUTO         DESCRICAO                  NOTA FISCAL        EMISSAO   UN   QUANTIDADE    PRECO UNITARIO            TOTAL  VENDEDOR"
// 123456789012345 123456789012345678901234567890 123456/123 12/12/1234 123456789012 1234567890123456 1234567890123456 123456/123456/123456/123456/123456

wnrel:="MATR780"

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho,,.T.)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C780Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C780IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR780                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C780Imp(lEnd,WnRel,cString)

LOCAL CbTxt
LOCAL CbCont,cabec1,cabec2,cabec3
LOCAL nTotCli1:= 0,nTotCli2:=0,nTotGer1 := 0,nTotGer2 := 0
LOCAL nOrdem
LOCAL tamanho:= "P"
LOCAL limite := IIF(cPaisLoc=="MEX",80,80)
LOCAL titulo := OemToAnsi("ESTATISTICAS DE VENDAS (Cliente X Produto)")	//"ESTATISTICAS DE VENDAS (Cliente X Produto)"
LOCAL cDesc1 := OemToAnsi("Este programa ira emitir a relacao das compras efetuadas pelo Cliente,")	//"Este programa ira emitir a relacao das compras efetuadas pelo Cliente,"
LOCAL cDesc2 := OemToAnsi("totalizando por produto e escolhendo a moeda forte para os Valores.")	//"totalizando por produto e escolhendo a moeda forte para os Valores."
LOCAL cDesc3 := ""
LOCAL cMoeda
LOCAL nAcN1  := 0, nAcN2 := 0, nV := 0
LOCAL cClieAnt := "", cProdAnt := "", cLojaAnt := "", cNF := "", cSerie := ""
LOCAL lContinua := .T. , lProcessou := .F. , lNewProd := .T.
LOCAL cMascara :=GetMv("MV_MASCGRD")
LOCAL nTamRef  :=Val(Substr(cMascara,1,2))
LOCAL nTamLin  :=Val(Substr(cMascara,4,2))
LOCAL nTamCol  :=Val(Substr(cMascara,7,2))
LOCAL cProdRef :=""
Local cUM      :=""
LOCAL nTotQuant:=0
LOCAL nReg     :=0
LOCAL cFiltro  := ""
Local cEstoq := If( (mv_par13 == 1),"S",If( (mv_par13 == 2),"N","SN" ))
Local cDupli := If( (mv_par14 == 1),"S",If( (mv_par14 == 2),"N","SN" ))
Local cArqTrab1, cArqTrab2, cCondicao1
Local aDevImpr := {}
Local cVends   := ""
Local nVend    := FA440CntVend()
Local nDevQtd 	:=0
Local nDevVal 	:=0
Local aDev		:={}
Local nIndD2    :=0
Local cQuery, aStru
Local lNfD2Ori   := .F. 
// variaveis criadas para realinhamento das colunas para o Mexico (factura com 20 digitos)
Local aColuna   := IIf(cPaisLoc=="MEX",{46,71,82,86,99,116,135},{10,30,46,76,89,106,125})
#IFDEF TOP
	Local nj := 0
	Local cAliasSA1 := "SA1"
#ENDIF

Private cSD1, cSD2
Private nIndD1  :=0
Private nDecs:=msdecimais(mv_par09)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Seleciona ordem dos arquivos consultados no processamento    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SF1->(dbsetorder(1))
SF2->(dbsetorder(1))
SB1->(dbSetOrder(1))
SA7->(dbSetOrder(2))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta o Cabecalho de acordo com o tipo de emissao            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo := "ESTATISTICAS DE VENDAS (Cliente X Venda)"
Cabec1 := "CLIENTE  RAZAO SOCIAL"

Cabec2 := "          NOTA FISCAL        EMISSAO                   TOTAL"
If cPaisLoc=="MEX"
   Cabec2 := Substr(Cabec2,1,54)+space(10)+Substr(Cabec2,55)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

cMoeda := "Valores em "+GetMV("MV_SIMB"+Str(mv_par09,1))		//"Valores em "
titulo := titulo+" "+cMoeda

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria filtro para impressao das devolucoes                    ³
//³ *** este filtro possui 208 posicoes  ***                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
cArqTrab1  := CriaTrab( "" , .F. )
#IFDEF TOP
    If (TcSrvType()#'AS/400')
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Query para SQL                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    cSD1   := "SD1TMP"
	    aStru  := dbStruct()
	    cQuery := "SELECT * FROM " + RetSqlName("SD1") + " SD1 "
	    cQuery += "WHERE SD1.D1_FILIAL = '"+xFilial("SD1")+"' AND "
	    cQuery += "SD1.D1_FORNECE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD1.D1_DTDIGIT BETWEEN '"+DtoS(mv_par03)+"' AND '"+DtoS(mv_par04)+ "' AND "
	    cQuery += "SD1.D1_COD BETWEEN '"+mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD1.D1_TIPO = 'D' AND "
    	 cQuery += " NOT ("+IsRemito(3,'SD1.D1_TIPODOC')+ ") AND "
	    cQuery += "SD1.D_E_L_E_T_ <> '*' "
	    cQuery += " AND SD1.D1_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
	    cQuery += " AND SD1.D1_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' "
	    cQuery += " ORDER BY SD1.D1_FILIAL,SD1.D1_FORNECE,SD1.D1_LOJA,SD1.D1_COD"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD1TRB', .F., .T.)},OemToAnsi("Selecionando Registros...")) //"Seleccionado registros"
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			   TCSetField('SD1TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj
	    A780CriaTmp(cArqTrab1, aStru, cSD1, "SD1TRB")
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,".T.","Selecionando Registros...")		//"Selecionando Registros..."
	Else    
#ENDIF
	    cSD1	   := "SD1"
	    cCondicao1 := 'D1_FILIAL=="' + xFilial("SD1") + '".And.'
	    cCondicao1 += 'D1_FORNECE>="' + mv_par01 + '".And.'
	    cCondicao1 += 'D1_FORNECE<="' + mv_par02 + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)>="' + DtoS(mv_par03) + '".And.'
	    cCondicao1 += 'DtoS(D1_DTDIGIT)<="' + DtoS(mv_par04) + '".And.'
	    cCondicao1 += 'D1_COD>="' + mv_par05 + '".And.'
	    cCondicao1 += 'D1_COD<="' + mv_par06 + '".And.'
	    cCondicao1 += 'D1_TIPO=="D" .And. !('+IsRemito(2,'SD1->D1_TIPODOC')+')'	    		

	    cArqTrab1  := CriaTrab("",.F.)
	    IndRegua(cSD1,cArqTrab1,"D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD",,cCondicao1,"Selecionando Registros...")		//"Selecionando Registros..."
	    nIndD1 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab1+ordBagExt())
        #ENDIF

	    dbSetOrder(nIndD1+1)
#IFDEF TOP
    Endif  	    
#ENDIF   

dbSeek(xFilial("SD1"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta filtro para processar as vendas por cliente            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SD2")
cFiltro := SD2->(dbFilter())
If Empty(cFiltro)
	bFiltro := { || .T. }
Else
	cFiltro := "{ || " + cFiltro + " }"
	bFiltro := &(cFiltro)
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta filtro para processar as vendas por cliente            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqTrab2  := CriaTrab( "" , .F. )
#IFDEF TOP            
    If (TcSrvType()#'AS/400')
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³ Query para SQL                 ³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    cSD2   := "SD2TMP"
	    aStru  := dbStruct() // D2_FILIAL, D2_DOC, D2_SERIE, D2_EMISSAO, D2_CLIENTE, D2_LOJA, D2_TOTAL, D2_ITEM, D2_COD, D2_GRADE, D2_PEDIDO, D2_QUANT, D2_PRCVEN
	    cQuery := "SELECT * FROM " + RetSqlName("SD2") + " SD2 "
	    cQuery += "WHERE SD2.D2_FILIAL = '"+xFilial("SD2")+"' AND "
	    cQuery += "SD2.D2_CLIENTE BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' AND "
	    cQuery += "SD2.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
	    cQuery += "SD2.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
	    cQuery += "SD2.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
    	cQuery += " NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
	    cQuery += "SD2.D_E_L_E_T_ <> '*' "
	    // Específico Cantu
	    // filtro quanto a limite de venda dos clientes e filtros de armazém e local
	    cQuery += " AND SD2.D2_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
	    cQuery += " AND SD2.D2_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' "
	    if (mv_par22 > 0)
	      cQuery += " AND ((SELECT sum(d.d2_total) from " + RetSqlName("SD2") + " d " 
        cQuery += "     where d.d_e_l_e_t_ <> '*' AND "
        cQuery += "       D.D2_CLIENTE = SD2.D2_CLIENTE AND D.D2_FILIAL = SD2.D2_FILIAL AND "
	      cQuery += "       D.D2_EMISSAO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' AND "
	      cQuery += "       D.D2_COD     BETWEEN '"+ mv_par05+"' AND '"+mv_par06+"' AND "
	      cQuery += "       D.D2_TIPO <> 'B' AND SD2.D2_TIPO <> 'D' AND "
    	  cQuery += "       NOT ("+IsRemito(3,'SD2.D2_TIPODOC')+ ") AND "
	      cQuery += "       D.D_E_L_E_T_ <> '*' "
        cQuery += "       AND D.D2_GRUPO between '" + MV_PAR18 + "' AND '" + MV_PAR19 + "' "
        cQuery += "       AND D.D2_LOCAL BETWEEN '" + MV_PAR20 + "' AND '" + MV_PAR21 + "' ) > " + Replace(Transform(MV_PAR22, "@E 9999999999.99"), ",", ".") + ")"	      
	    EndIf
	    // fim do específico Cantu
	    cQuery += "ORDER BY SD2.D2_FILIAL,SD2.D2_CLIENTE,SD2.D2_LOJA,SD2.D2_SERIE, SD2.D2_DOC,SD2.D2_ITEM"
	    cQuery := ChangeQuery(cQuery)
	    MsAguarde({|| dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),'SD2TRB', .F., .T.)},OemToAnsi("Selecionando Registros...")) //"Seleccionado registros"
	    // monta a mesma estrutra da query
	    ///aStru := SD2TRB->(dbStruct())
	    
	    For nj := 1 to Len(aStru)
		    If aStru[nj,2] != 'C'
			    TCSetField('SD2TRB', aStru[nj,1], aStru[nj,2],aStru[nj,3],aStru[nj,4])
		    EndIf	
	    Next nj

	    CriaTmpSD2(cArqTrab2, aStru, cSD2, "SD2TRB")
	    IndRegua(cSD2,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC+D2_COD+D2_ITEM",,".T.","Selecionando Registros...")		//"Selecionando Registros..."
    Else
#ENDIF                   
	    cSD2	  := "SD2"
	    cCondicao := 'D2_FILIAL == "' + xFilial("SD2") + '" .And. '
	    cCondicao += 'D2_CLIENTE >= "' + mv_par01 + '" .And. '
	    cCondicao += 'D2_CLIENTE <= "' + mv_par02 + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) >= "' + DTOS(mv_par03) + '" .And. '
	    cCondicao += 'DTOS(D2_EMISSAO) <= "' + DTOS(mv_par04) + '" .And. '
	    cCondicao += 'D2_COD >= "' + mv_par05 + '" .And. '
	    cCondicao += 'D2_COD <= "' + mv_par06 + '" .And. '
	    cCondicao += '!(D2_TIPO $ "BD")'
	    cCondicao += '.And. !('+IsRemito(2,'SD2->D2_TIPODOC')+')'		
 
	    IndRegua(cString,cArqTrab2,"D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_COD+D2_SERIE+D2_DOC+D2_ITEM",,cCondicao,"Selecionando Registros...")		//"Selecionando Registros..."
	    nIndD2 := RetIndex()

        #IFNDEF TOP	    
	       dbSetIndex(cArqTrab2+ordBagExt())
        #ENDIF
        
	    dbSetOrder(nIndD2+1)
#IFDEF TOP	    
	Endif    
#ENDIF


dbSelectArea("SA1")
dbSetOrder(1)
#IFDEF TOP
    cAliasSA1 := GetNextAlias()
    aStru  := dbStruct()
    cQuery := "SELECT A1_FILIAL,A1_COD,A1_LOJA,A1_NOME,A1_OBSERV "    
    cQuery += "FROM " + RetSqlName("SA1") + " SA1 "
    cQuery += "WHERE SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
    cQuery += "SA1.A1_COD >= '"        +MV_PAR01+"' AND "
	  cQuery += "SA1.A1_COD <= '"        +MV_PAR02+"' AND "
	  // filtro de grupo e armazém
	  
    cQuery += "SA1.D_E_L_E_T_ = ' ' "
    cQuery += " ORDER BY "+SqlOrder(SA1->(IndexKey()))
    cQuery := ChangeQuery(cQuery)
    dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery),cAliasSA1, .F., .T.)
#ELSE
	cAliasSA1 := "SA1"
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se aglutinara produtos de Grade                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SetRegua(RecCount())		// Total de Elementos da regua

If ( (cSD2)->D2_GRADE=="S" .And. MV_PAR12 == 1)
	lGrade := .T.
	bGrade := { || Substr((cSD2)->D2_COD, 1, nTamref) }
Else
	lGrade := .F.
	bGrade := { || (cSD2)->D2_COD }
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Procura pelo 1o. cliente valido                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFNDEF TOP
	dbSeek(xFilial()+mv_par01, .t.)
#ENDIF

While (cAliasSA1)->( ! EOF() .AND. A1_COD <= MV_PAR02 ) .And. lContinua .And. (cAliasSA1)->A1_FILIAL == xFilial("SA1")
	
	If lEnd
		@Prow()+1,001 Psay "CANCELADO PELO OPERADOR"	//"CANCELADO PELO OPERADOR"
		lContinua := .F.
		Exit
	EndIf
	
	lNewCli := .T.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura pelas saidas daquele cliente                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	DbSelectArea(cSD2)
	If DbSeek(xFilial("SD2")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Montagem da quebra do relatorio por  Cliente             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cClieAnt := (cAliasSA1)->A1_COD
		cLojaAnt := (cAliasSA1)->A1_LOJA		
		lNewNF := .F.
		lNewCli  := .T.
		nTotCli1 := 0
		nTotCli2 := 0
		While !Eof() .and. ;
			((cSD2)->(D2_FILIAL+D2_CLIENTE+D2_LOJA)) == (xFilial("SD2")+cClieAnt+cLojaAnt)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica Se eh uma tipo de nota valida                   ³
			//³ Verifica intervalo de Codigos de Vendedor                ³
			//³ Valida o produto conforme a mascara                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
			If	! Eval(bFiltro) .Or. !A780Vend(@cVends,nVend) .Or. !lRet //.or. SD2->D2_TIPO$"BD" ja esta no filtro
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao do Cabecalho.                                  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Li > 55
				cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
				lProcessou := .T.
			EndIf
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Impressao da quebra por NF                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProdAnt := Eval(bGrade)
			lNewProd := .T.
			
			While ! Eof() .And. ;
				(cSD2)->(D2_FILIAL + D2_CLIENTE + D2_LOJA) == ;
				( xFilial("SD2") + cClieAnt   + cLojaAnt)
				IncRegua()
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Avalia TES                                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				lRet:=ValidMasc((cSD2)->D2_COD,MV_PAR11)
				If !AvalTes((cSD2)->D2_TES,cEstoq,cDupli) .Or. !Eval(bFiltro) .Or. !lRet
					dbSkip()
					Loop
				Endif
				
				If !A780Vend(@cVends,nVend)
					dbskip()
					Loop
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao  dos dados do Cliente                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If lNewCli
					
					If Li > 51
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						lProcessou := .T.
					EndIf
					
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li++
					lNewCli := .F.
				Endif
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Impressao do Cabecalho.                                  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If li > 55
					cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					@ Li,000 Psay Repli('-',limite)
					Li++
					@ Li,000 Psay (cSD2)->D2_CLIENTE+"   "+(cAliasSA1)->A1_NOME
					If !Empty((cAliasSA1)->A1_OBSERV)
						Li++
						@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
					EndIf
					Li+=2
				EndIf
				
				cNF := (cSD2)->D2_Doc
				cSerie := (cSD2)->D2_Serie
				
				nTotNF := 0
				
				While(cNF + cSerie == (cSD2)->D2_Doc + (cSD2)->D2_Serie)// na mesma NF
				
					nDevQtd :=0
					nDevVal :=0					
					If mv_par10 == 1 //inclui Devolucoes
						SomaDev(@nDevQtd, @nDevVal , @aDev, cEstoq, cDupli)
					EndIf
					
					nTotQuant := (cSD2)->D2_QUANT
						
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime os dados da NF                                   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					SF2->(dbSeek(xFilial("SF2")+(cSD2)->(D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA)))
					cUM := (cSD2)->D2_UM
					
					nAcN1 += nTotQuant
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Faz Verificacao da Moeda Escolhida e Imprime os Valores  ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nVlrUnit := xMoeda((cSD2)->D2_PRCVEN,SF2->F2_MOEDA,MV_PAR09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
					
					If (cSD2)->D2_TIPO $ "CIP"
						nTotNF += nVlrUnit
						
					Else
						If (cSD2)->D2_GRADE == "S" .And. MV_PAR12 == 1 // Aglutina Grade
							nVlrTot:= nVlrUnit * nTotQuant				
						Else						
							nVlrTot:=xmoeda((cSD2)->D2_TOTAL,SF2->F2_MOEDA,mv_par09,(cSD2)->D2_EMISSAO,nDecs+1,SF2->F2_TXMOEDA)
						EndIf
						nTotNF += nVlrTot
					EndIf
					
					A780Vend(@cVends,nVend)				
					//For nV := 8 to Len(cVends)
						//li ++				
						//nV += 6
					//Next
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Imprime as devolucoes do produto selecionado             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If nDevQtd!=0
						//Li++
						//@Li,023 Psay "DEV" // "DEV"
						nVlrTot:= nDevVal
						//@Li,aColuna[3] Psay cUM
						//@Li,aColuna[4] Psay nDevQtd          PICTURE "@)"+PesqPictqt("D2_QUANT",14)
						//@Li,aColuna[6] Psay nVlrTot          PICTURE "@)"+PesqPict("SD2","D2_TOTAL",16,mv_par09)
						nAcN1+= nDevQtd
						nTotNF+= nVlrTot
					EndIf
					//Li++
				  dbSkip()
				  
				EndDo// mudou a NF
				@Li, aColuna[1] Psay (cSD2)->(D2_DOC+'/'+D2_SERIE)
				@Li, aColuna[2] Psay (cSD2)->D2_EMISSAO
				@Li, aColuna[3] Psay nTotNF  PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				
				Li++
				
				nAcN2 += nTotNF
				
				nTotQuant := 0
			EndDo
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula o total geral do relatorio                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotGer1 += nAcN1
			nTotGer2 += nAcN2
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Acumula o total por cliente                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nTotCli1 += nAcN1
			nTotCli2 += nAcN2
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Imprime o total do produto selecionado                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If nAcN1#0 .Or. nAcN2#0	.Or. nDevQtd#0
				//Li++
				//@Li ,  07 Psay "TOTAL DO PRODUTO - "+cProdAnt	//"TOTAL DO PRODUTO - "
				//@Li ,  52 Psay "---->"
				//@Li , aColuna[3] Psay cUM
				//@Li , aColuna[4] Psay nAcN1 PICTURE PesqPictqt("D2_QUANT",14)
				//@Li , aColuna[6] Psay nAcN2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				nAcN1 := 0
				nAcN2 := 0
				cProdAnt := (cSD2)->D2_COD
			EndIf
			
		EndDo
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Ocorreu quebra por cliente                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !(lNewCli)
			LI+=2
			@Li , 07 Psay "TOTAL DO CLIENTE - "+cClieAnt+'/'+cLojaAnt	//"TOTAL DO CLIENTE - "
			@Li , 42 Psay "---->"
			//@Li ,aColuna[4] Psay nTotCli1 PICTURE PesqPictqt("D2_QUANT",16)
			@Li ,aColuna[3] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
			LI++
		EndIf
		cClieAnt := ""
		cLojaAnt := ""
		nTotCli1 := 0
		nTotCli2 := 0
		
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Procura pelas devolucoes dos clientes que nao tem NF SAIDA  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotCli1 := 0
	nTotCli2 := 0
	DbSelectArea(cSD1)
	If DbSeek(xFilial("SD1")+(cAliasSA1)->A1_COD+(cAliasSA1)->A1_LOJA)
		lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Procura as devolucoes do periodo, mas que nao pertencem  ³
		//³ as NFS ja impressas do cliente selecionado               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If mv_par10 == 1  // Inclui Devolucao
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Soma Devolucoes          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			While (cSD1)->(D1_FILIAL + D1_FORNECE + D1_LOJA) == ;
				( xFilial("SD1") + (cAliasSA1)->A1_COD+ (cAliasSA1)->A1_LOJA)  .AND. ! Eof()
				lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica Vendedores da N.F.Original ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				CtrlVndDev := .F.
				lNfD2Ori   := .F.
				If AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
					dbSelectArea("SD2")
					nSavOrd := IndexOrd()
					dbSetOrder(3)

					dbSeek(xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD))
					While !Eof() .And. (xFilial("SD2")+(cSD1)->(D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD)) == ;
						D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD
					
						lRet:=ValidMasc((cSD1)->D1_COD,MV_PAR11)
					
						If !Empty((cSD1)->D1_ITEMORI) .AND. AllTrim((cSD1)->D1_ITEMORI) != D2_ITEM .Or. !lRet .Or. !Eval(bFiltro)
							dbSkip()
							Loop
						Else
							CtrlVndDev := A780Vend(@cVends,nVend)
							If Ascan(aDev,D2_CLIENTE + D2_LOJA + D2_COD + D2_DOC + D2_SERIE + D2_ITEM) > 0
								lNfD2Ori := .T.
							EndIf
						Endif
						dbSkip()
					End
				
					dbSelectArea("SD2")
					dbSetOrder(nSavOrd)
					dbSelectArea(cSD1)
				
					If !(CtrlVndDev) .Or. lNfD2Ori
						dbSkip()
						Loop
					EndIf
				
					lProcessou := .t.
				
					If li > 55
						cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
					EndIf
				
					If lNewCli
					
						If li > 51
							cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
						EndIf
					
						@ Li,000 Psay Repli('-',limite)
					
						Li++
						@ Li,000 Psay (cAliasSA1)->A1_COD
						@ Li,009 Psay (cAliasSA1)->A1_NOME
						If !Empty((cAliasSA1)->A1_OBSERV)
							Li++
							@ Li,000 Psay "Obs.: "+(cAliasSA1)->A1_OBSERV		//"Obs.: "
						EndIf
					
						Li+=2
					
						lNewCli := .F.
					
					EndIf
				
					LI++
					SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))
					cUM := (cSD1)->D1_UM
				
					//@Li ,  0 Psay (cSD1)->D1_COD
					@li , 5 Psay "DEV" //"DEV"
					@Li , aColuna[1] Psay (cSD1)->(D1_DOC+'/'+D1_SERIE) // 
					nVlrTot:=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,(cSD1)->D1_DTDIGIT,nDecs,SF1->F1_TXMOEDA)
					//@Li,aColuna[3] Psay cUM
					//@Li,aColuna[4] Psay -(cSD1)->D1_QUANT PICTURE "@)"+PesqPictqt("D1_QUANT",14)
					@Li,aColuna[3] Psay -nVlrTot           PICTURE PesqPict("SD1","D1_TOTAL",16,mv_par09)
					nTotCli1 -= (cSD1)->D1_QUANT
					nTotCli2 -= nVlrTot
					nTotGer1 -= (cSD1)->D1_QUANT
					nTotGer2 -= nVlrTot
				Endif
				dbSkip()
			EndDo
			
			If (nTotCli1 != 0) .or. (nTotCli2 != 0)
				LI+=2
				@Li , 07 Psay "TOTAL DO CLIENTE - "+(cAliasSA1)->A1_COD	//"TOTAL DO CLIENTE - "
				@Li , 40 Psay "---->"
				//@Li ,aColuna[4] Psay nTotCli1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
				@Li ,aColuna[3] Psay nTotCli2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
				LI+=1
			EndIf
			
		EndIf
		
	Endif
	
	DbSelectArea(cAliasSA1)
	DbSkip()
EndDo

If lProcessou
	If li > 55
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,15)
	EndIf
	Li+=2
	@Li , 07 PSay "T O T A L   G E R A L       ---->"
  //@Li ,aColuna[4] Psay nTotGer1 PICTURE "@)"+PesqPictqt("D2_QUANT",16)
  @Li ,aColuna[3] Psay nTotGer2 PICTURE PesqPict("SD2","D2_TOTAL",16,mv_par09)
	roda(cbcont,cbtxt,tamanho)
Endif

dbSelectArea("SD1")
dbClearFilter()
RetIndex("SD1")

dbSelectArea("SD2")
dbClearFilter()
RetIndex("SD2")

(cSD1)->(DbCloseArea())
(cSD2)->(DbCloseArea())
fErase(cArqTrab1+OrdBagExt())
fErase(cArqTrab2+OrdBagExt())
#IFDEF TOP
    fErase(cArqTrab1+GetDbExtension())
    fErase(cArqTrab2+GetDbExtension())
#ENDIF

If aReturn[5] = 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
EndIf

MS_FLUSH()

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ A780Vend ³ Autor ³ Rogerio F. Guimaraes  ³ Data ³ 28.10.97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica Intervalo de Vendedores                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR780			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function A780Vend(cVends,nVend)
Local cAlias:=Alias(),sVend,sCampo
Local lVend, cVend, cBusca
Local nx
lVend  := .F.
cVends := ""
// Nao tem Alias na frente dos campos do SD2 para poder trabalhar em DBF e TOP
cBusca := xFilial("SF2")+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA
dbSelectArea("SF2")
If dbSeek(cBusca)
	cVend := "1"
	For nx := 1 to nVend
		sCampo := "F2_VEND" + cVend
		sVend := FieldGet(FieldPos(sCampo))
		If !Empty(sVend)
			cVends += If(Len(cVends)>0,"/","") + sVend
		EndIf
		If (sVend >= mv_par07 .And. sVend <= mv_par08) .And. (nX == 1 .Or. !Empty(sVend))
			lVend := .T.
		EndIf
		cVend := Soma1(cVend, 1)
	Next
EndIf
dbSelectArea(cAlias)
Return(lVend)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ SomaDev  ³ Autor ³ Claudecino C Leao     ³ Data ³ 28.09.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Soma devolucoes de Vendas                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR780			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function SomaDev(nDevQtd, nDevVal, aDev, cEstoq, cDupli )

Local DtMoedaDev  := (cSD2)->D2_EMISSAO

If (cSD1)->(dbSeek(xFilial("SD1")+(cSD2)->(D2_CLIENTE + D2_LOJA + D2_COD )))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Soma Devolucoes          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While (cSD1)->(D1_FILIAL+D1_FORNECE+D1_LOJA+D1_COD) == (cSD2)->( xFilial("SD2")+D2_CLIENTE+D2_LOJA+D2_COD).AND.!(cSD1)->(Eof())                   
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Avalia TES                                               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !AvalTes((cSD1)->D1_TES,cEstoq,cDupli)
	        (cSD1)->(dbSkip())
			Loop
		Endif
	
        DtMoedaDev  := IIF(MV_PAR17 == 1,(cSD1)->D1_DTDIGIT,(cSD2)->D2_EMISSAO)

		SF1->(dbSeek(xFilial("SF1")+(cSD1)->(D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)))

		If (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) == (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM )

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		ElseIf mv_par15 == 2 .And. (cSD1)->D1_DTDIGIT < (cSD2)->D2_EMISSAO .And.;
			   (cSD1)->(D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)) < ;
			   (cSD2)->(D2_DOC   + D2_SERIE   + D2_ITEM ) .And.;
			   Ascan(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI))) == 0

			Aadd(aDev, (cSD1)->(D1_FORNECE + D1_LOJA + D1_COD + D1_NFORI + D1_SERIORI + AllTrim(D1_ITEMORI)))
			nDevQtd -= (cSD1)->D1_QUANT
			nDevVal -=xMoeda((cSD1)->(D1_TOTAL-D1_VALDESC),SF1->F1_MOEDA,mv_par09,DtMoedaDev,nDecs+1,SF1->F1_TXMOEDA)

		EndIf

        (cSD1)->(dbSkip())

	EndDo

EndIf
Return .t.
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A780CriaTmp³ Autor ³ Rubens Joao Pante     ³ Data ³ 04/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria temporario a partir da consulta corrente (TOP)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR780 (TOPCONNECT)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function A780CriaTmp(cArqTmp, aStruTmp, cAliasTmp, cAlias)
	Local nI, nF, nPos
	Local cFieldName := ""
	nF := (cAlias)->(Fcount())
    dbCreate(cArqTmp,aStruTmp)
    DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
	(cAlias)->(DbGoTop())
	While ! (cAlias)->(Eof())
        (cAliasTmp)->(DbAppend())
		For nI := 1 To nF 
			cFieldName := (cAlias)->( FieldName( ni ))
		    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
		   		    (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
            EndIf   		
		Next
		(cAlias)->(DbSkip())
	End
	(cAlias)->(dbCloseArea())
    DbSelectArea(cAliasTmp)
Return Nil


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³A780CriaTmp³ Autor ³ Rubens Joao Pante     ³ Data ³ 04/07/01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Cria temporario a partir da consulta corrente (TOP)          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATR780 (TOPCONNECT)                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaTmpSD2(cArqTmp, aStruTmp, cAliasTmp, cAlias)
Local nI, nF, nPos
Local cFieldName := ""
Local cCliente := ""
Local cLoja := ""
Local cNF := ""
Local cSerie := ""
nF := (cAlias)->(Fcount())
dbCreate(cArqTmp,aStruTmp)
DbUseArea(.T.,,cArqTmp,cAliasTmp,.T.,.F.)
(cAlias)->(DbGoTop())
While ! (cAlias)->(Eof())
  (cAliasTmp)->(DbAppend())
  For nI := 1 To nF 
  	cFieldName := (cAlias)->( FieldName( ni ))
    If (nPos := (cAliasTmp)->(FieldPos(cFieldName))) > 0
   	  (cAliasTmp)->(FieldPut(nPos,(cAlias)->(FieldGet((cAlias)->(FieldPos(cFieldName))))))
		EndIf   		
	Next
	cNF := (cAlias)->D2_DOC
	cSerie := (cAlias)->D2_Serie
	(cAlias)->(DbSkip())	
EndDo
(cAlias)->(dbCloseArea())
DbSelectArea(cAliasTmp)
Return Nil