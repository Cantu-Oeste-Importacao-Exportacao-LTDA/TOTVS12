#include "rwmake.ch"
#include "colors.ch"
#include "topconn.ch"
#INCLUDE "DBINFO.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RJGPER10  ³Autor ³ Luiz Gamero Prado     ³Data ³21/09/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio adiantamento de viagens gerados pelo caixinha    ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GRUPO CANTU                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function RJGPER10()
*-------------------------*
LOCAL cDesc1 :="Relatorio conferencia adto caixinha x folha pagamento"
LOCAL cDesc2 :=""
LOCAL cDesc3 :=""
PRIVATE limite    := 132
PRIVATE tamanho   := "M"
PRIVATE nTipo     := 18
PRIVATE titulo    := "Relatorio conferencia adto caixinha x folha pagamento"
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog  := "RJGPER10"
PRIVATE nLastKey  := 0
PRIVATE cString   := "SEU"
PRIVATE cBitMap   := "ptiagua1_1.bmp"
PRIVATE cPerg	  := "RJGPER0010"
PRIVATE wnrel  	  := "RJGPER10"
PRIVATE aCoords1  := {611,041,699,2290}
PRIVATE aCoords2  := {2321,041,2419,2290}
PRIVATE oBrush    := TBrush():New( , CLR_GRAY ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1()
If ! Pergunte(cPerg,.t.)
	Return
EndIf

nHeight10  := 10
nHeight12  := 12
nHeight11  := 11
nHeight15  := 15
nheight13  := 13
lBold	   := .T.
lUnderLine := .T.

Processa( {|| RJGPER10(wnrel,cString) },Titulo,"Aguarde....." )

Return

*----------------------------------------*
Static Function RJGPER10(wnrel,cString)
*----------------------------------------*
Private cAliasTMP := GetNextAlias()
Private aEMISOLC  := {}
Private CCODMOT  := ""
Private nTOTDOC   := 0
Private nTOTGER   := 0
Private nCol  := 50
Private nIncr := 50
Private nPag  := 0
Private nFol  := 0
Private nCOT  := 0
Private nPRD  := 0


oFont1	:= TFont():New( "Mono AS",,nHeight10,,!lBold,,,,,!lUnderLine )
oFont2  := TFont():New( "Arial",,nheight11,,lBold,,,,,!lUnderLine )
oFont3  := TFont():New( "Mono AS",,nHeight10,,lBold,,,,,!lUnderLine )
oFont4  := TFont():New( "Times New Roman",,nheight15   ,,!lBold,,,,,lUnderLine )
oFont5  := TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
oFont6  := TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
oFont7  := TFont():New( "Times New Roman",,nheight10-2 ,,!lBold,,,,,lUnderLine )
oFont8  := TFont():New( "Arial",,nheight11,,!lBold,,,,,!lUnderLine )
lFirst  := .T.
_dtini := dtos(mv_par05)
_dtfim := dtos(mv_par06)

oPrn:= TMSPrinter():New()
oPrn:SetPortrait()
oPen:= TPen():New(,7,CLR_BLACK,oPrn)
cQuery := " SELECT EU_FILIAL, EU_CODMOT, EU_NUM, SUM(TOTAL) SALDO, NOME    				" + chr(13)
cQuery += "  	FROM (								                    				" + chr(13)
cQuery += " 	SELECT SEU.EU_FILIAL,SEU.EU_NUM, EU_NROADIA, SEU.EU_CODMOT, ( 			" + chr(13)
cQuery += "		SELECT SUM(SEU1.EU_VALOR) 												" + chr(13)
cQuery += "   FROM " + RetSQLName("SEU") + " SEU1                     					" + chr(13)
cQuery += "  WHERE SEU1.EU_NROADIA = SEU.EU_NUM 										" + chr(13)
cQuery += "    AND SEU1.EU_CODDES = '9010001'							   				" + chr(13)
cQuery += "    AND (SEU1.EU_X_DTFPG BETWEEN '"+_dtini+"' and '"+_dtfim+"' )             " + chr(13)
cQuery += "    AND SEU1.D_E_L_E_T_ <> '*')  AS TOTAL,  				 					" + chr(13)
cQuery += "   (SELECT DA4_NOME						  	   								" + chr(13)
cQuery += "		 FROM " + RetSQLName("DA4") + " DA4    	   								" + chr(13)
cQuery += "   	WHERE DA4.DA4_COD = SEU.EU_CODMOT AND DA4.D_E_L_E_T_ <> '*')   NOME		" + chr(13)
cQuery += "   FROM 	" + RetSQLName("SEU") + " SEU    	   								" + chr(13)
cQuery += "  WHERE SEU.EU_FILIAL BETWEEN '"+(mv_par01)+"' and '"+(mv_par02)+"' 			" + chr(13)
cQuery += "    AND SEU.D_E_L_E_T_ <> '*'					   							" + chr(13)
cQuery += "    GROUP BY SEU.EU_FILIAL, SEU.EU_NUM, EU_NROADIA, SEU.EU_CODMOT ))	 		" + chr(13)
cQuery += "  WHERE EU_CODMOT BETWEEN '"+mv_par03+"' and '"+mv_par04 +"' 				" + chr(13)
cQuery += "    AND TOTAL <> 0	   														" + chr(13)
cQuery += "    GROUP BY EU_FILIAL, EU_CODMOT, EU_NUM, NOME								" + chr(13)
cQuery += "    ORDER BY EU_FILIAL, NOME, EU_NUM											" + chr(13)
MemoWrite("RJGPER10.TXT",cQuery)

TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)

dbSelectArea(cAliasTMP)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impressão do relatório..                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

(cAliasTMP)->(dbGoTop())

While !(cAliasTMP)->(EOF())
	
	If nFol == 0 .or. nIncr > 2700
		nIncr := 0
		nCol  := 50
		nPag  += 1
		nIncr += 030
		Li := 50
		
		If nIncr > 2700
			oPrn:EndPage()
		EndIf
		
		oPrn:StartPage()
		oPrn:SayBitmap( Li+000, nCol+000, cBitMap, 365, 152 )
		
		oPrn:Say( Li+nIncr, nCol+0550, "Relatorio conferencia adto caixinha x folha pagamento", oFont6, 100 )
		nIncr += 060
		oPrn:Say( Li+nIncr, nCol+0750, "Data Emissao:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1000, DTOC(DDATABASE), oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1250, "Data De:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1450, DTOC(MV_PAR05), oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1700, "Data Até:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1900, DTOC(MV_PAR06), oFont8, 100 )
		nIncr += 080
		
		//SUPERIOR
		oPrn:Line( 0020, 0030,0020, 2300 )
		//SUPERIOR-1
		oPrn:Line( 0210, 0030,0210, 2300 )
		//SUPERIOR-2
		oPrn:Line( 0290, 0030,0290, 2300 )
		//ESQUERDO
		oPrn:Line( 0020, 0030,3100, 0030 )
		//DIREITO
		oPrn:Line( 0020, 2300,3100, 2300 )
		//INFERIOR
		oPrn:Line( 3100, 0030,3100, 2300 )
		oPrn:Say( Li+nIncr, nCol+0000, "Numero Adto. Caixinha  ", oFont5, 100 )
		oPrn:Say( Li+nIncr, nCol+1700, "Valor", oFont5, 100 )
		
	ElseIf (cAliasTMP)->eu_codmot != cCODMOT
		If nTOTDOC != 0
			oPrn:Say( Li+nIncr, nCol+1400, "Total Motorista: ", oFont2, 100 )
			oPrn:Say( Li+nIncr, nCol+1900, TRANSFORM(nTOTDOC,"@E 99,999,999.99"), oFont2, 100,,,1 )
			nTOTDOC := 0
		EndIf
	EndIf
	
	nIncr += 80
	
	CCODMOT := (cAliasTMP)->eu_codmot
	nTOTDOC  := 0
	nCOT += 1
	
	oPrn:Say( Li+nIncr, nCol+050, (cAliasTMP)->EU_CODMOT + " - " + (cAliasTMP)->NOME, oFont5, 100 )
	nIncr += 50
	
	While !(cAliasTMP)->(EOF()) .and. (cAliasTMP)->EU_CODMOT == cCODMOT
		
		
		oPrn:Say( Li+nIncr, nCol+0050, (cAliasTMP)->EU_NUM, oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1700, TRANSFORM((cAliasTMP)->SALDO,"@E 99,999,999.99"), oFont8, 100,,,1 )
		
		nTOTDOC += (cAliasTMP)->SALDO
		nTOTGER += (cAliasTMP)->SALDO
		nIncr += 50
		
		If nIncr > 2700
			
			nIncr := 0
			nCol  := 50
			nPag  += 1
			nIncr += 030
			Li := 50
			
			oPrn:EndPage()
			oPrn:StartPage()
			oPrn:SayBitmap( Li+000, nCol+000, cBitMap, 365, 152 )
			
			oPrn:Say( Li+nIncr, nCol+0550, "Relatorio conferencia Adto caixinha x folha pagamento", oFont6, 100 )
			nIncr += 060
			oPrn:Say( Li+nIncr, nCol+0750, "Data Emissao:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1000, DTOC(DDATABASE), oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1250, "Data De:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1450, DTOC(MV_PAR05), oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1700, "Data Até:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1900, DTOC(MV_PAR06), oFont8, 100 )
			nIncr += 080
			
			nIncr += 100
			
			//SUPERIOR
			oPrn:Line( 0020, 0030,0020, 2300 )
			//SUPERIOR-1
			oPrn:Line( 0210, 0030,0210, 2300 )
			//SUPERIOR-2
			oPrn:Line( 0290, 0030,0290, 2300 )
			//ESQUERDO
			oPrn:Line( 0020, 0030,3100, 0030 )
			//DIREITO
			oPrn:Line( 0020, 2300,3100, 2300 )
			//INFERIOR
			oPrn:Line( 3100, 0030,3100, 2300 )
			
		EndIf
		
		nPRD += 1
		(cAliasTMP)->(dbSkip())
	Enddo
	
	nFol += 1
	
Enddo

If nTOTDOC != 0
	oPrn:Say( Li+nIncr, nCol+1400, "Total Motorista: ", oFont2, 100 )
	oPrn:Say( Li+nIncr, nCol+1900, TRANSFORM(nTOTDOC,"@E 99,999,999.99"), oFont2, 100,,,1 )
	nTOTDOC := 0
EndIf

If nCOT != 0
	nIncr += 050
	
	If nTOTGER != 0
		oPrn:Say( Li+nIncr, nCol+0000, "Total Geral: ", oFont2, 100 )
		oPrn:Say( Li+nIncr, nCol+2200, TRANSFORM(nTOTGER,"@E 99,999,999.99"), oFont2, 100,,,1 )
	EndIf
	
EndIf

If Select(cAliasTMP) > 0
	DbSelectArea( cAliasTMP )
	cArq := DbInfo(DBI_FULLPATH)
	cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
	DbCloseArea()
	FErase(cArq)
EndIf

oPrn:Preview()

Return

*----------------------------*
Static Function AjustaSX1()
*----------------------------*

aRegs :={}

dbSelectArea("SX1")
dbSetOrder(1)


aAdd(aRegs,{cPerg,"01","Filial Inicial ?  ","Filial Inicial ?   ","Filial Inicial ?  ","mv_ch1","C",2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Filial Final ?  ","Filial Final ?    ","Filial Final ?    ","mv_ch2","C",2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Motorista Inicial ?  ","Motorisa Inicial ?   ","Motorista Inicial ?  ","mv_ch3","C",6,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","DA4","",""})
aAdd(aRegs,{cPerg,"04","Motorista Final ?  ","Motorista Final ?    ","Motorista Final ?    ","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","DA4","",""})
aAdd(aRegs,{cPerg,"05","Emissão Inicial ? ","Emissão Inicial    ? ","Emissão inicial    ? ","mv_ch5","D",8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Emissão Final ?","Emissão Final       ?","Emissão Final       ?","mv_ch6","D",8,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

Return .T.
