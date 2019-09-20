#include "rwmake.ch"
#include "colors.ch"
#include "topconn.ch"
#INCLUDE "DBINFO.CH"
//#INCLUDE "PRCONST.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ RJFINR10  ³Autor ³ Luiz Gamero Prado     ³Data ³01/09/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relatorio saldos em aberto motoristas adiantamento interno ³±±
±±³          ³ adiantamento externo                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GRUPO CANTU                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------*
User Function RJFINR10()
*-------------------------*
LOCAL cDesc1 :="Saldos em aberto adiantamentos motoristas"
LOCAL cDesc2 :=""
LOCAL cDesc3 :=""
PRIVATE limite    := 132
PRIVATE tamanho   := "M"
PRIVATE nTipo     := 18
PRIVATE titulo    := "Saldos em aberto adiantamentos motoristas"
PRIVATE aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1, "",0 }
PRIVATE nomeprog  := "RJFINR10"
PRIVATE nLastKey  := 0
PRIVATE cString   := "SEU"
PRIVATE cBitMap   := "ptiagua1_1.bmp"
PRIVATE cPerg	  := "RJFIR00010"
PRIVATE wnrel  	  := "RJFINR10"
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

Processa( {|| RJFINR10(wnrel,cString) },Titulo,"Aguarde....." )

Return

*----------------------------------------*
Static Function RJFINR10(wnrel,cString)
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

oPrn:= TMSPrinter():New()
oPrn:SetPortrait()
oPen:= TPen():New(,7,CLR_BLACK,oPrn)

cQuery := " SELECT																									 " + chr(13)
cQuery += " 	da4_filial, eu_codmot, da4_nome, eu_coddes, dt7_descri,  sum(eu_sldadia ) saldo						 " + chr(13)
cQuery += " 		FROM " + RetSQLName("SEU") + " SEU, " + RetSQLName("DA4") + " DA4, " + RetSQLName("DT7") + " DT7 " + chr(13)
cQuery += " 		WHERE														" + chr(13)
cQuery += " 			eu_coddes in ('2010001        ', '2010002        ')		" + chr(13)
cQuery += " 		    and seu.d_e_l_e_t_ <> '*'								" + chr(13)
cQuery += " 	        and dt7.d_e_l_e_t_ <> '*'								" + chr(13)
cQuery += " 	        and da4.d_e_l_e_t_ <> '*'								" + chr(13)
cQuery += " 	        and eu_sldadia > 0							 			" + chr(13)
cQuery += " 	        and seu.eu_filial = da4.da4_filial		   				" + chr(13)
cQuery += " 	        and seu.eu_codmot = da4.da4_cod							" + chr(13)
cQuery += " 	        and seu.eu_coddes = dt7.dt7_coddes						" + chr(13)
cQuery += "             and seu.eu_codmot   between '"+mv_par01+"' and '"+mv_par02+"' " + chr(13)
cQuery += "             and seu.eu_emissao  between '"+dtoc(mv_par03)+"' and '"+dtoc(mv_par04)+"' " + chr(13)
cQuery += " group by eu_codmot, eu_coddes, da4_filial, da4_nome, dt7_descri		" + chr(13)
cQuery += " order by da4_nome, eu_coddes										" + chr(13)

MemoWrite("RJFINR10.TXT",cQuery)

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
		
		oPrn:Say( Li+nIncr, nCol+0550, "Relacao adiantamentos Motoristas com Saldos em aberto", oFont6, 100 )
		nIncr += 060
		oPrn:Say( Li+nIncr, nCol+0750, "Data Emissao:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1000, DTOC(DDATABASE), oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1250, "Data De:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1450, DTOC(MV_PAR03), oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1700, "Data Até:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1900, DTOC(MV_PAR04), oFont8, 100 )
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
		oPrn:Say( Li+nIncr, nCol+0000, "Tipo Despesa", oFont5, 100 )
		oPrn:Say( Li+nIncr, nCol+1500, "Valor", oFont5, 100 )
		
	ElseIf (cAliasTMP)->eu_codmot != cCODMOT
  		If nTOTDOC != 0
			oPrn:Say( Li+nIncr, nCol+1900, TRANSFORM(nTOTDOC,"@E 99,999,999.99"), oFont2, 100,,,1 )
			nTOTDOC := 0
		EndIf
	EndIf

	nIncr += 80
	
	CCODMOT := (cAliasTMP)->eu_codmot
	nTOTDOC  := 0
	nCOT += 1
	
	oPrn:Say( Li+nIncr, nCol+050, (cAliasTMP)->EU_CODMOT + " - " + (cAliasTMP)->DA4_NOME, oFont5, 100 )
	nIncr += 50
	
	While !(cAliasTMP)->(EOF()) .and. (cAliasTMP)->EU_CODMOT == cCODMOT
		
		
		oPrn:Say( Li+nIncr, nCol+0050, "Desp. Interna:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+0750, "Desp. Externa:", oFont8, 100 )
		oPrn:Say( Li+nIncr, nCol+1350, "Total Motorista:", oFont8, 100 )
		
		
		if ALLTRIM((cAliasTMP)->EU_CODDES) == "2010001"
			oPrn:Say( Li+nIncr, nCol+0600, TRANSFORM((cAliasTMP)->SALDO,"@E 99,999,999.99"), oFont8, 100,,,1 )
		else
			oPrn:Say( Li+nIncr, nCol+1250, TRANSFORM((cAliasTMP)->SALDO,"@E 99,999,999.99"), oFont8, 100,,,1 )
		endif
		
		nTOTDOC += (cAliasTMP)->SALDO
		nTOTGER += (cAliasTMP)->SALDO
		
		If nIncr > 2700
			
			nIncr := 0
			nCol  := 50
			nPag  += 1
			nIncr += 030
			Li := 50
			
			oPrn:EndPage()
			oPrn:StartPage()
			oPrn:SayBitmap( Li+000, nCol+000, cBitMap, 365, 152 )
			
			oPrn:Say( Li+nIncr, nCol+0550, "Relacao adiantamentos Motoristas com Saldos em aberto", oFont6, 100 )
			nIncr += 060
			oPrn:Say( Li+nIncr, nCol+0750, "Data Emissao:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1000, DTOC(DDATABASE), oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1250, "Data De:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1450, DTOC(MV_PAR03), oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1700, "Data Até:", oFont8, 100 )
			oPrn:Say( Li+nIncr, nCol+1900, DTOC(MV_PAR04), oFont8, 100 )
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
	oPrn:Say( Li+nIncr, nCol+1900, TRANSFORM(nTOTDOC,"@E 99,999,999.99"), oFont2, 100,,,1 )
	nTOTDOC := 0
EndIf

If nCOT != 0
	nIncr += 050
	
	If nTOTGER != 0
		oPrn:Say( Li+nIncr, nCol+0000, "Total Adiantamentos em aberto: ", oFont2, 100 )
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

aAdd(aRegs,{cPerg,"01","Motorista Inicial ?  ","Motorisa Inicial ?   ","Motorista Inicial ?  ","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DA4","",""})
aAdd(aRegs,{cPerg,"02","Motorista Final ?  ","Motorista Final ?    ","Motorista Final ?    ","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DA4","",""})
aAdd(aRegs,{cPerg,"03","Emissão Inicial ? ","Emissão Inicial    ? ","Emissão inicial    ? ","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Emissão Final ?","Emissão Final       ?","Emissão Final       ?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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
