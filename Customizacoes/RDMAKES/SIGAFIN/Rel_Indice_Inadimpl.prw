#INCLUDE "MATR580.CH"
#Include "FIVEWIN.Ch"
#define VP_0015 1
#define VP_1630 2
#define VP_3145 3
#define VP_4660 4
#define VP_6175 5
#define VP_7690 6
#define VP_91120 7
#define VP_MA120 8
#define VA_0015 9
#define VA_1630 10        
#define VA_3145 11
#define VA_4660 12
#define VA_6175 13
#define VA_7690 14
#define VA_91120 15
#define VA_MA120 16
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR580  ³ Autor ³ Wagner Xavier         ³ Data ³ 05.09.91 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Estatistica de Venda por Ordem de Vendedor                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MATR580(void)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Verificar Indexacao com vendedor                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/

User Function RelIndInad()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt  := ""
Local cDesc1 := OemToAnsi("Este relatorio emite a relacao de indices")
Local cDesc2 := OemToAnsi("")
Local CbCont,cabec1,cabec2,wnrel
Local tamanho:="G"
Local limite :=132
Local cString:="SE1"
Local lContinua := .T.
Local cMoeda,nMoeda
Local cNFiscal

Private titulo := OemToAnsi("Relatório de índices de Inadimplencia")
PRIVATE aReturn := { STR0005, 1,STR0006, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="FATVENLIQ"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="INDINA"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// cria as perguntas
CriaPerg(cPerg)

// Efetua a pergunta
Pergunte(cPerg)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel  := "INDINAD"            //Nome Default do relatorio em Disco
wnrel  := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,"",.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C580Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C580IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR580			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C580Imp(lEnd,WnRel,cString)

Local CbCont,cabec1,cabec2
Local tamanho:="G"

Local aCampos := {}
Local aCmpVenc := {} // campos dos dados de vencidas e a vencer
Local cVend
Local nTotVTab := 0, nTotVVend := 0
Local nMoeda, cMoeda:="" 
Local cArqVV, cArqVV1
Local cDescGrp := ""

Private nDecs := 2
Private aVenc := {}
Private nTotArm := 0
Private nTotTArm := 0
Private nTotRArm := 0

nTipo := Iif(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 132
m_pag    := 1
nMoeda := 0
cMoeda := GetMv("MV_MOEDA1")

cabec1 := OemToAnsi("Cliente  Nome Reduz               Titulo           Natureza  Emissao    Vencto     Baixa       Valor       Baixado  Vendedor")
cabec2 := OemToAnsi("")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria array para gerar arquivo de trabalho                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AADD(aCampos,{"TB_VEND"  , "C",  6, 0})
AADD(aCampos,{"TB_DESCME", "N",  6, 2})
AADD(aCampos,{"TB_PRAZO ", "N",  8, 2})
AADD(aCampos,{"TB_DOC"   , "C",  6, 0})
AADD(aCampos,{"TB_VALDUP", "N", 14, 2})
AADD(aCampos,{"TB_VALLIQ", "N", 14, 2})
AADD(aCampos,{"TB_VALREC", "N", 14, 2})
AADD(aCampos,{"TB_CODCLI", "C",  9, 0})
AADD(aCampos,{"TB_GRPPRO", "C",  4, 0})
AADD(aCampos,{"TB_SEGMENT", "C",  9, 0})
AADD(aCampos,{"TB_CODARM", "C",  2, 0})
AADD(aCampos,{"TB_PREFIX", "C",  3, 0})
AADD(aCampos,{"TB_PARCEL", "C",  2, 0})
AADD(aCampos,{"TB_EMISSA", "D",  8, 0})
AADD(aCampos,{"TB_VENCTO", "D",  8, 0})
AADD(aCampos,{"TB_BAIXA" , "D",  8, 0})
AADD(aCampos,{"TB_NATURE", "C", 20, 0})
AADD(aCampos,{"TB_BXCFAT", "L", 1, 0})

// Descrições dos vencimentos            
AADD(aVenc, "0 a 15 dias")
AADD(aVenc, "16 a 30 dias")
AADD(aVenc, "31 a 45 dias")
AADD(aVenc, "46 a 60 dias")
AADD(aVenc, "61 a 75 dias")
AADD(aVenc, "76 a 90 dias")
AADD(aVenc, "91 a 120 dias")
AADD(aVenc, " > 120 dias")

AADD(aCmpVenc, {"VV_SEGMENT", "C", 9, 0})
AADD(aCmpVenc, {"VV_CODVENC", "C", 2, 0})
AADD(aCmpVenc, {"VV_VALTOT", "N", 14, 2})

// cria arquivo de trabalho das Vencidas e a vencer
cArqVV 	:= CriaTrab(aCmpVenc,.T.)
dbUseArea( .T.,, cArqVV,"TRBVV", .T. , .F. )
cArqVV1 := Subs(cArqVV,1,7)+"A"
IndRegua("TRBVV",cArqVV1,"VV_SEGMENT+VV_CODVENC",,,STR0011) //"Selecionando Registros..."
dbClearIndex()
dbSetIndex(cArqVV1+OrdBagExt())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho das duplicatas                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cNomArq 	:= CriaTrab(aCampos,.T.)
dbUseArea( .T.,, cNomArq,"TRB", .T. , .F. )
cNomArq1 := Subs(cNomArq,1,7)+"A"
IndRegua("TRB",cNomArq1,"TB_SEGMENT+TB_CODCLI+TB_PREFIX+TB_DOC",,,STR0011) //"Selecionando Registros..."
dbClearIndex()
dbSetIndex(cNomArq1+OrdBagExt())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chamada da Funcao para gerar arquivo de Trabalho             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
GeraTrab()

dbSelectArea("TRB")
SetRegua(LastRec())
dbGoTop()
cArmazem := ""//TRB->TB_CODARM
cGrupo := ""//TRB->TB_GRPPRO
cCliente := ""//TRB->TB_CODCLI
cSegment	:= TRB->TB_SEGMENT//""  // Adriano 09/02/2011
nTot := 0
nTotGrp := 0
nTotArm := 0
nTotR := 0
nTotRGrp := 0
nTotRArm := 0
nTotT := 0
nTotTGrp := 0
nTotTArm := 0
SA1->(DbSetOrder(01))
SA1->(DbSeek(xFilial("SA1") + SubStr(cCliente,1,6) + SubStr(cCliente, 8, 2)))
SA3->(DbSetOrder(01))
cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
While .T.	
	
	If lEnd
		@Prow()+1,001 PSAY STR0012		//"CANCELADO PELO OPERADOR"
		Exit
	Endif
	
	if (cSegment != TRB->TB_SEGMENT)
	  If PRow() > 48
		  cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	  EndIf
	  
//	  if !Empty(cArmazem) // Adriano 09/02/2011
	  	ImpVencV(cSegment, nTotGrp, nTotRGrp, nTotTGrp, cSegment != TRB->TB_SEGMENT)
	  	nTotGrp := 0
	  	nTotRGrp := 0
	  	nTotTGrp := 0
	  	if (cSegment != TRB->TB_SEGMENT)
	  		nTotArm := 0
	  		nTotRArm := 0
	  		nTotTArm := 0
	  	EndIf
//	  EndIf // Adriano 09/02/2011
		
		cSegment := TRB->TB_SEGMENT
//		cGrupo := TRB->TB_GRPPRO
	  
	  if TRB->(Eof())
	  	Exit
		EndIf             
		
//	  if (MV_PAR01 == 2)	  
//	  	SBM->(DbSetOrder(01))
//			SBM->(DbSeek(xFilial("SBM") + cGrupo))       /// ADICIONAR DESCRIÇÃO SEGMENTO
//			cDescGrp := SBM->BM_DESC
		CTH->(DbSelectArea("CTH"))
		CTH->(DbSetOrder(01))
		CTH->(DbSeek(xFilial("CTH") + cSegment))
		// Imprime o totalizador por primeiro
	  	@ PRow() + 1, 00 PSay "Segmento: " + CTH->CTH_DESC01 // + "      Grupo: " + TRB->TB_GRPPRO + " - " + cDescGrp
	  	@ PRow() + 1, 00 PSay Replicate ("-", 30)
	  EndIf
//	EndIf
	
	IncRegua()
	
	If PRow() > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIf
	
	DbSelectArea("TRB")
	// só imprime duplicatas caso for analítico
	if (MV_PAR01 == 2)
		// localiza o cliente caso mudou
		if (cCliente != TRB->TB_CodCli)
			cCliente := TRB->TB_CodCli
			SA1->(DbSeek(xFilial("SA1") + SubStr(cCliente,1,6) + SubStr(cCliente, 8, 2)))
		EndIf
		
		SA3->(DbSeek(xFilial("SA3") + TRB->TB_VEND))
		// Impressao Detalhes
		@ PRow() + 1, 00 PSay ""
		@ PRow(), 01 PSay TRB->TB_CodCli
		@ PRow(), 12 PSay SA1->A1_NREDUZ
		@ PRow(), 35 Psay AllTrim(TRB->TB_PREFIX) + "-" + TRB->TB_DOC + iif(Empty(TRB->TB_PARCEL), "", "/" + TRB->TB_PARCEL)
		@ PRow(), 52 PSay TRB->TB_NATURE
		@ PRow(), 62 PSay TRB->TB_EMISSA
		@ PRow(), 72 PSay TRB->TB_VENCTO
		@ PRow(), 82 PSay TRB->TB_BAIXA
		@ PRow(), 90 PSay TRB->TB_VALLIQ Picture "@E 99,999,999.99"
		@ Prow(), 103 PSay TRB->TB_VALREC Picture "@E 99,999,999.99"
//		@ PRow(), 104 PSay TRB->TB_PRAZO Picture "@E 9999"
		@ PRow(), 117 PSay TRB->TB_VEND + "    " + SA3->A3_NREDUZ
	EndIf
	
	if (mv_par08 == 2) // Não considera baixa com fats
		// Totalizador geral
		nTot += TRB->TB_VALLIQ
		nTotR += TRB->TB_VALREC	
		// Totalizardor de Grupo
		nTotGrp += TRB->TB_VALLIQ
		nTotRGrp += TRB->TB_VALREC
		// Totalizador do Armazém
		nTotArm += TRB->TB_VALLIQ
		nTotRArm += TRB->TB_VALREC
	Else
		// Totalizador geral
		if (TRB->TB_BXCFAT)
			nTotT += TRB->TB_VALLIQ
			nTotTGrp += TRB->TB_VALLIQ
			nTotTArm += TRB->TB_VALLIQ
		else
			nTot += TRB->TB_VALLIQ
			nTotR += TRB->TB_VALREC	
			// Totalizardor de Grupo
			nTotGrp += TRB->TB_VALLIQ
			nTotRGrp += TRB->TB_VALREC
			// Totalizador do Armazém
			nTotArm += TRB->TB_VALLIQ
			nTotRArm += TRB->TB_VALREC
		EndIf
	EndIf

	TRB->(dbSkip())	
EndDo

if (PRow() > 48)
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
EndIf

ImpVencV("", nTot, nTotR,nTotT, .F.)

dbSelectArea( "TRB" )
dbCloseArea()
fErase(cNomArq+GetDBExtension())
fErase(cNomArq1+OrdBagExt())

dbSelectArea("TRBVV")
dbCloseArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1    // Se Saida para disco, ativa SPOOL
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return


Static Function ImpVencV(cSegment, nTot, nTotR, nTotT, lArmNovo)
Local cDescGrp := ""
CTH->(DbSelectArea("CTH"))
CTH->(DbSetOrder(01))
CTH->(DbSeek(xFilial("CTH") + cSegment))
cDescGrp := CTH->CTH_DESC01
// Imprime o totalizador por primeiro
@ PRow() + 1, 00 PSAY Replicate("_",166)
@ PRow() + 1, 00 PSAY "<--- Resumo Vencidas e a Vencer  <-->  Segmento: " //+ cDescGrp
//			iif(Empty(cArm), "(Todos)", cArm) + "   Grupo: " + iif(Empty(cArm), "(Todos)", cGrupo + " - " + cDescGrp) + " --->"
@ PRow() + 1, 00 PSAY Replicate("-",166)
@ PRow() + 1, 02 PSay "TOTAIS"
if (mv_par08 == 1) // separa as baixas com fats
	@ PRow()    , 20 PSay "Bruto: " + AllTrim(Transform(nTot + nTotT, "@E 99,999,999.99"))
	@ PRow()    , 45 PSay "Bx. C/ Fat.:" + AllTrim(Transform(nTotT, "@E 99,999,999.99"))
	@ PRow()    , 69 PSay "Inad. Bruto.: " + AllTrim(Transform((1 - ((nTotR + nTotT) / (nTot + nTotT))) * 100, "@E 999.99"))
EndIf
@ PRow()    , 89 PSay nTot Picture "@E 99,999,999.99"
@ PRow()    , 103 PSay nTotR Picture "@E 99,999,999.99"
@ PRow()    , 118 PSay "Inad. Liq.: " +AllTrim(Transform((1 - (nTotR / nTot)) * 100, "@E 999.99"))
@ PRow() + 1, 00 PSAY Replicate("-",166)
/*            	
if (lArmNovo .And. (nTot != nTotArm))
	@ PRow() + 1, 02  PSay "TOTAIS ARM." + cArm	
	if (mv_par08 == 1) // separa as baixas com fats
		@ PRow()    , 14 PSay "Bruto: " + AllTrim(Transform(nTotArm + nTotTArm, "@E 99,999,999.99"))
		@ PRow()    , 39 PSay "Bx. C/ Fat.:" + AllTrim(Transform(nTotTArm, "@E 99,999,999.99"))
		@ PRow()    , 64 PSay "Inad. Bruto.: " + AllTrim(Transform((1 - ((nTotRArm + nTotTArm) / (nTotArm + nTotTArm))) * 100, "@E 999.99"))
	EndIf
	@ PRow()    , 83  PSay nTotArm Picture "@E 99,999,999.99"
	@ PRow()    , 96  PSay nTotRArm Picture "@E 99,999,999.99"
	@ PRow()    , 111 PSay "Inad. Liq.: " + AllTrim(Transform((1 - (nTotRArm / nTotArm)) * 100, "@E 999.99"))
	@ PRow() + 1, 00  PSay Replicate("-",132)
EndIf
*/
@ PRow() + 1, 00 PSay "Liquidadas"
@ PRow()    , 66 PSay "Vencidas"
@ PRow() + 1, 00 PSay Replicate("-", 63)
@ PRow()    , 66 Psay Replicate("-", 100)

// Valores de vencidas e a vencer
@ PRow() + 1, 00 PSay aVenc[1]
@ Prow()    , 15 PSay GetVenc(cSegment, VP_0015) Picture "@E 99,999,999.99"
@ PRow()    , 33 PSay aVenc[2]
@ Prow()    , 47 PSay GetVenc(cSegment, VP_1630) Picture "@E 99,999,999.99"
@ PRow()    , 66 PSay aVenc[1]
@ PRow()    , 80 PSay GetVenc(cSegment, VA_0015) Picture "@E 99,999,999.99"
@ PRow()    , 98 PSay aVenc[2]
@ PRow()    ,112 PSay GetVenc(cSegment, VA_1630) Picture "@E 99,999,999.99"

@ PRow() + 1, 00 PSay aVenc[3]
@ Prow()    , 15 PSay GetVenc(cSegment, VP_3145) Picture "@E 99,999,999.99"
@ PRow()    , 33 PSay aVenc[4]
@ Prow()    , 47 PSay GetVenc(cSegment, VP_4660) Picture "@E 99,999,999.99"
@ PRow()    , 66 PSay aVenc[3]
@ PRow()    , 80 PSay GetVenc(cSegment, VA_3145) Picture "@E 99,999,999.99"
@ PRow()    , 98 PSay aVenc[4]
@ PRow()    ,112 PSay GetVenc(cSegment, VA_4660) Picture "@E 99,999,999.99"

@ PRow() + 1, 00 PSay aVenc[5]
@ Prow()    , 15 PSay GetVenc(cSegment, VP_6175) Picture "@E 99,999,999.99"
@ PRow()    , 33 PSay aVenc[6]
@ Prow()    , 47 PSay GetVenc(cSegment, VP_7690) Picture "@E 99,999,999.99"
@ PRow()    , 66 PSay aVenc[5]
@ PRow()    , 80 PSay GetVenc(cSegment, VA_6175) Picture "@E 99,999,999.99"
@ PRow()    , 98 PSay aVenc[6]
@ PRow()    ,112 PSay GetVenc(cSegment, VA_7690) Picture "@E 99,999,999.99"

@ PRow() + 1, 00 PSay aVenc[7]
@ Prow()    , 15 PSay GetVenc(cSegment, VP_91120) Picture "@E 99,999,999.99"
@ PRow()    , 33 PSay aVenc[8]
@ Prow()    , 47 PSay GetVenc(cSegment, VP_MA120) Picture "@E 99,999,999.99"
@ PRow()    , 66 PSay aVenc[7]
@ PRow()    , 80 PSay GetVenc(cSegment, VA_91120) Picture "@E 99,999,999.99"
@ PRow()    , 98 PSay aVenc[8]
@ PRow()    ,112 PSay GetVenc(cSegment, VA_MA120) Picture "@E 99,999,999.99"
@ PRow() + 1, 00 PSay Replicate("-",166)	
Return Nil


/*****************************************************************************
 Obtém o valor das vencidas e a vencer para determinado determinado tipo,
 conforme o grupo passado por parametro
 ****************************************************************************/
Static Function GetVenc(cSegment, nTp)
Local nVal := 0
Local nTipo := nTp
if !Empty(cSegment)
	if TRBVV->(DbSeek(cSegment + StrZero(nTipo,2)))
		nVal := TRBVV->VV_VALTOT
	EndIf
else // pesquisa todo o arquivo somando os valores para o tipo selecionado
  TRBVV->(DbGoTop())
  While TRBVV->(!Eof())
    if (TRBVV->VV_CODVENC == StrZero(nTipo, 2))
    	nVal += TRBVV->VV_VALTOT
    EndIf
    TRBVV->(DbSkip())
  EndDo	
EndIf
Return nVal

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³GeraTrab  ³ Autor ³ Wagner Xavier         ³ Data ³ 10.01.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gera arquivo de Trabalho para emissao de Estat.de Fatur.    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GeraTrab()                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraTrab()
Local lContinua:= .F.
Local cNameSD2  :=	""
Local cNameSF2  :=	""
Local cNameSF4  :=	""
Local cFilterQry:=	""
Local cAddField	:=	""
Local cQuery	:=	""
Local cQryAd    :=  ""
Local cName     :=  ""
Local aCampos	:=	{}
Local nCampo	:=	0
Local cCampo	:=	""
Local cAliasSE1	:=	""
Local aStru		:=	{}
Local nStru		:=	0
Local nPos		:=	0
Local nValor	:=	0
Local nY        := 	0
Local lFiltro   := .T.
Local nX := 0
Local cNFSer    := ""
Local aGrupArm := {} // array que armazena os grupos de produtos da venda e os armazéns dos mesmos

Private cCampImp
Private aGrpVen

dbSelectArea("SD2")
dbSetOrder(3)

cAliasSE1:=	GetNextAlias()

cNameSD2 := RetSqlName("SD2")
cNameSF2 := RetSqlName("SF2")
cNameSF4 := RetSqlName("SF4")
cNameSE1 := RetSqlName("SE1")
cNameSE5 := RetSqlName("SE5")
                   
cAddField	:=	""

If SF2->(FieldPos("F2_TXMOEDA")) > 0
	cAddField += ", F2_TXMOEDA"
EndIf

If SF2->(FieldPos("F2_MOEDA")) > 0
	cAddField += ", F2_MOEDA"
EndIf

cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_FILIAL, E1_PARCELA, E1_CLIENTE, E1_LOJA, "
cQuery += " E1_NATUREZ, E1_EMISSAO, E1_VENCTO, E1_VENCREA, E1_TIPO, "
cQuery += " E1_VALOR, E1_VEND1, E1_FATURA, E1_BAIXA, E1_SALDO, E1_CLVLCR  SEGMENTO "
// cQuery += " (select sum(E5_VALOR) FROM " + cNameSE5 + " "
// cQuery += " Where e5_filial = '" + MV_PAR01 + "' and e5_prefixo = e1_prefixo and e5_num = e1_num)"  
// adriano cQuery += " (select F2_ValMerc from " + cNameSF2 + " "
// adriano cQuery += " where f2_filial = se1.e1_filial "
// adriano cQuery += " and f2_doc = se1.e1_num "
// adriano cQuery += " and f2_serie = se1.e1_prefixo "
// adriano cQuery += " and d_e_l_e_t_ = ' ' "
// adriano cQuery += " fetch first 1 rows only) as ValMerc "
	    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Esta Rotina adiciona a cQuery os campos selecionados pelo usuario  |
//³no filtro do usuario.                                              |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	   	
aStru := SE1->(dbStruct())	
If !Empty(aReturn[7])
	For nX := 1 To SE1->(FCount())
		cName := SE1->(FieldName(nX))
	  If AllTrim( cName ) $ aReturn[7]
	  	If aStru[nX,2] <> "M"  
	    	If !cName $ cQuery .And. !cName $ cQryAd
	      	cQryAd += ","+cName
	      Endif 	
	    EndIf
	  EndIf 			       	
	Next nX
Endif
cQuery += cQryAd
cExcCli := STRTRAN(AllTrim(MV_PAR06), ',', "','")
if !Empty(MV_PAR07)
	cExcCli += ',' + STRTRAN(AllTrim(MV_PAR07), ',', "','")
EndIf
cExcCli := "'" + cExcCli + "'"
cQuery += "from " + RetSqlName("SE1") + " se1 "
cQuery += "where E1_FILIAL = '" + xFilial("SE1") + "'"
cQuery += " And E1_VENCTO BETWEEN '" + DToS(MV_PAR02) + "' and '" + DToS(MV_PAR03) + "'"
cQuery += " AND (E1_TIPO IN ('" + STRTRAN(AllTrim(MV_PAR05), ',', "','") + "')) "
cQuery += " AND (E1_CLIENTE NOT IN (" + cExcCli + ")) "
cQuery += " AND (D_E_L_E_T_ = ' ') "
cQuery += "ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

cQuery := ChangeQuery(cQuery)

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSE1,.T.,.T.)
    
SetRegua((cAliasSE1)->(LastRec()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Processa as duplicatas buscando para cada uma a venda relacionada       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SD2->(DbSetOrder(03))
While (cAliasSE1)->(!Eof())
	
  IncRegua()
  
  // Verifica os títulos que foram agrupados em fatura
  lBxCFat := .F.
	if (!Empty((cAliasSE1)->E1_FATURA) .And. ((cAliasSE1)->E1_FATURA != 'NOTFAT'))
		lBxCFat := .T.
		if MV_PAR08 == 2 // desconsidera as baixas com Fat
			(cAliasSE1)->(dbSkip())
			Loop
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  //³Processa Filtro do Usuario para Query                                   ³
  //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  
  // seleciona a área devido a ser utilizada mais abaixo
  dbSelectArea(cAliasSE1)
	If !Empty(aReturn[7]).And.!&(aReturn[7]) 
    (cAliasSE1)->(dbSkip())
    Loop
	Endif
  	
	// localiza a venda e calcula parcial para os grupos e armazéns diferentes
	aGrupArm := {}
	
	// Alimenta a variável de total geral.
// adriano 	nTotGer := iif((cAliasSE1)->VALMERC > 0,(cAliasSE1)->VALMERC, (cAliasSE1)->E1_VALOR)
	nTotGer :=  (cAliasSE1)->E1_VALOR	
	// Todas as fatura possuem NOTFAT no campo fatura
/* adriano	if ((cAliasSE1)->E1_FATURA == 'NOTFAT')
		// faz a consulta para totalizar os valores por grupo, 
		// considerado o cálculo de valor da duplicata e o parcial referente a grupo
	  nTotGer := GetDuplFat((cAliasSE1)->E1_NUM, (cAliasSE1)->E1_PREFIXO)
	  
	  // o comando acima cria o arquivo usado aqui
	  For i := 1 to Len(aGrpVen)
	  // QrDup->(DbGotop())
	  // While !QrDup->(Eof())
	    nPos := aScan(aGrupArm, {|x| x[1] == aGrpVen[i, 1]})		  	
	  	if (nPos == 0)
	  	  aAdd(aGrupArm, aGrpVen[i])  //  * ((cAliasSE1)->E1_Valor / nTotGer)
	  	Else
	  	  aGrupArm[nPos,2] += aGrpVen[i, 2]
	  	EndIf
	  	// QrDup->(DbSkip())
	  // EndDo
	  Next
	
	else */
// aDRIANO	if SD2->(DbSeek(xFilial("SD2") + (cAliasSE1)->E1_NUM + (cAliasSE1)->E1_PREFIXO))
	  nTotGer := (cAliasSE1)->E1_VALOR
/*	  While (cAliasSE1)->E1_PREFIXO + (cAliasSE1)->E1_NUM == SD2->D2_SERIE + SD2->D2_DOC
	    
	    nPos := aScan(aGrupArm, {|x| x[1] == SD2->D2_LOCAL + GetGrupo(SD2->D2_LOCAL, SD2->D2_GRUPO)})
	  	if (nPos == 0)
	  	  aAdd(aGrupArm, {SD2->D2_Local + GetGrupo(SD2->D2_LOCAL, SD2->D2_GRUPO), SD2->D2_Total})
	  	Else
	  	  aGrupArm[nPos,2] += SD2->D2_Total
	  	EndIf 
	  	
	  	SD2->(DbSkip())
		EndDo */
// aDRIANO	EndIf
	// caso nao tenha itens, adiciona um para mesclar junto
//	Aadd(aGrupArm, {(cAliasSE1)->SEGMENTO, (cAliasSE1)->E1_VALOR})
/*	if len(aGrupArm) == 0
	  Aadd(aGrupArm, {"      ", (cAliasSE1)->ValMerc})
	EndIf */
	
//	For i:= 1 to len(aGrupArm)
	  RecLock("TRB", .T.)
	  // Particiona o valor da duplicata nos diferentes grupos de produtos e armazéns
	  TRB->TB_VALLIQ :=  (cAliasSE1)->E1_VALOR
	  TRB->TB_VEND := (cAliasSE1)->E1_VEND1
		
		TRB->TB_DOC := (cAliasSE1)->E1_NUM
		TRB->TB_VALDUP := (cAliasSE1)->E1_VALOR			
		TRB->TB_CODCLI := (cAliasSE1)->E1_CLIENTE + "/" + (cAliasSE1)->E1_Loja
//		TRB->TB_GRPPRO := SubStr((cAliasSE1)->SEGMENTO, 3, 4)
//		TRB->TB_CODARM := SubStr((cAliasSE1)->SEGMENTO, 1, 2)
		TRB->TB_SEGMENT := (cAliasSE1)->SEGMENTO
		TRB->TB_PREFIX := (cAliasSE1)->E1_PREFIXO
		TRB->TB_PARCEL := (cAliasSE1)->E1_PARCELA
		TRB->TB_EMISSA := SToD((cAliasSE1)->E1_EMISSAO)
		TRB->TB_VENCTO := SToD((cAliasSE1)->E1_VENCREA)
		
		if (SToD((cAliasSE1)->E1_BAIXA) <= MV_PAR04) .And. !Empty((cAliasSE1)->E1_BAIXA)
			TRB->TB_BAIXA := SToD((cAliasSE1)->E1_BAIXA)
			// considera parcial para somente o que está em aberto
			TRB->TB_VALREC :=  (cAliasSE1)->E1_VALOR - (cAliasSE1)->E1_SALDO
		EndIf
		
		TRB->TB_NATURE := (cAliasSE1)->E1_NATUREZ
		
		// Calcula o prazo de acordo com a data de baixa de referencia
		if Empty(TRB->TB_BAIXA)
			TRB->TB_PRAZO := MV_PAR04 - SToD((cAliasSE1)->E1_VENCREA)
		else
			TRB->TB_PRAZO := SToD((cAliasSE1)->E1_BAIXA) - SToD((cAliasSE1)->E1_VENCREA)
		EndIf
		
		// seta se foi baixado com Fat
		TRB->TB_BXCFAT := lBxcFat
		
	  TRB->(MsUnlock())	
//	Next i
	
	(cAliasSE1)->(dbSkip())
EndDo

// Faz o cálculo de Vencidas e a vencer
CriaResVenc()

(cAliasSE1)->(dbCloseArea())
	
Return .T.

/********************************************************************************
 Funçao responsavel por obter as duplicatas que originaram a fatura,
 devido a ser necessário buscar a origem das mesmas e ratear entre todos os grupos das vendas
********************************************************************************/
Static Function GetDuplFat(cFatura, cPref)
Local nTotal := 0
Local nPos := 0
aGrpVen := {}
// Busca referente a que valores foi feito a fatura, 
// para descobrir os grupos de produtos
BeginSql Alias "QRDUP"
	select distinct d2_cod, d2_doc, d2_local, d2_grupo, d2_total, d2_item // sum(d2_total) as Total
	from %table:SE1% SE1
		inner join %table:sd2% sd2 on (e1_num = d2_doc) and (e1_prefixo = d2_serie)
	where e1_fatura = %Exp:cFatura%
		and e1_filial = %xFilial:SE1%
		and d2_filial = %xFilial:SD2%
		and se1.d_e_l_e_t_ = ' '
		and sd2.d_e_l_e_t_ = ' '
	ORDER BY d2_local, d2_grupo
EndSql

// busca o total da fatura, para ratear os valores
// faz a soma do total, pois será utilizado acima
While !QrDup->(Eof())
  nPos := aScan(aGrpVen, {|x| x[1] == QrDup->D2_LOCAL + GetGrupo(QrDup->D2_LOCAL, QrDup->D2_GRUPO)})
  if (nPos > 0)
    aGrpVen[nPos, 2] += QrDup->d2_total
  else
    aAdd(aGrpVen, {SD2->D2_Local + GetGrupo(SD2->D2_LOCAL, SD2->D2_GRUPO), QrDup->D2_Total})
  EndIf
  nTotal += QrDup->D2_Total
  QrDup->(DbSkip())
EndDo

QrDup->(DbCloseArea())	

Return nTotal 
             
/********************************************************************************
 Funçao responsavel por adicionar as aspas simples no início e no final da string,
********************************************************************************/

Static Function StrToSql(cStr)
Local cResult := "'" + cStr + "'"
Return cResult


/********************************************************************************
 Funçao responsavel por fazer o cálculo de Vencidas e a Vencer por armazém e grupo de produto existente no relatório
********************************************************************************/
Static Function CriaResVenc()
Local nPrazo
Local nItem := 0
Local nValor := 0
Local nValFat := 0
TRB->(DbGoTop())
While !TRB->(Eof())
  // MV_PAR04 = Data para posicao retroativa  
  nPrazo := TRB->TB_PRAZO
  if Empty(TRB->TB_BAIXA)  // títulos em aberto
	  Do Case
			Case nPrazo < 16
				nItem :=  VA_0015
			Case nPrazo < 31
			  nItem := VA_1630
			Case nPrazo < 46
			  nItem := VA_3145
			Case nPrazo < 61
			  nItem := VA_4660
			Case nPrazo < 76
			  nItem := VA_6175
			Case nPrazo < 91
			  nItem := VA_7690
			Case nPrazo < 121
			  nitem := VA_91120
			OtherWise
			  nItem := VA_MA120
		EndCase  
	Else // titulos baixados
	  Do Case
			Case nPrazo < 16
				nItem := VP_0015
			Case nPrazo < 31
			  nItem := VP_1630
			Case nPrazo < 46
			  nItem := VP_3145
			Case nPrazo < 61
			  nItem := VP_4660
			Case nPrazo < 76
			  nItem := VP_6175
			Case nPrazo < 91
			  nItem := VP_7690
			Case nPrazo < 121
			  nitem := VP_91120
			OtherWise
			  nItem := VP_MA120
		EndCase
	EndIf
	
	// se for baixado, considera apenas o valor recebido
	nValor := iif(nItem < 9, TRB->TB_VALREC, TRB->TB_VALLIQ)
  
	if !TRBVV->(DbSeek(TRB->TB_SEGMENT + StrZero(nItem, 2)))
		RecLock("TRBVV", .T.)
		TRBVV->VV_SEGMENT := TRB->TB_SEGMENT
		TRBVV->VV_CODVENC := StrZero(nItem, 2)
		TRBVV->VV_VALTOT := nValor
	Else
		RecLock("TRBVV", .F.)
		TRBVV->VV_VALTOT += nValor
	EndIf
	TRBVV->(MsUnlock())
	TRB->(DbSkip())
EndDo
Return nil

Static Function CriaPerg(cPerg)
PutSx1(cPerg,"01","Exibir Dados ?","Exibir Dados ?","Exibir Dados ?", "mv_tpr", "N", 1, 0, 0,"C", "", "", "", "",;
						"MV_PAR01","Sintetico","Sintetico","Sintetico", "","Analitico","Analitico","Analitico")
PutSx1(cPerg,"02","Vencto Incial ?","Vencto Incial ?","Vencto Incial ?", "mv_vin", "D", 8, 0, 0,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Vencto Final ?","Vencto Final ?","Vencto Final ?", "mv_vfi", "D", 8, 0, 0,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Baixas até ?","Baixas até ?","Baixas até ?", "mv_bx", "D", 8, 0, 0,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Tipo de Docto ?","Tipo de Docto ?","Tipo de Docto ?", "mv_tpd", "C", 99, 0, 0,"G", "", "", "", "","MV_PAR05")
PutSx1(cPerg,"06","Exceto Clientes ?","Exceto Clientes ?","Exceto Clientes ?", "mv_ecl", "C", 99, 0, 0,"G", "", "", "", "","MV_PAR06")
PutSx1(cPerg,"07","Exceto Clientes(2) ?","Exceto Clientes(2) ?","Exceto Clientes(2) ?", "mv_ec2", "C", 99, 0, 0,"G", "", "", "", "","MV_PAR07")
PutSx1(cPerg,"08","Considera Baixa com Fat. ?","Considera Baixa com Fat. ?","Considera Baixa com Fat. ?", "mv_tra", "N", 1, 0, 0,"C", "", "", "", "",;
						"MV_PAR08","Sim","Sim","Sim", "","Não","Não","Não")
Return

/*************************************************
 Função que valida se deve ou não separar os grupos
 ************************************************/
Static Function GetGrupo(cArm, cGrupo)
// só separa por grupo se for o armazém 05
if cArm != "05"
  cGrupo := "    "
EndIf
Return cGrupo