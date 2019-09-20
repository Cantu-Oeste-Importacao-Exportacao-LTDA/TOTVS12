#Include "Protheus.ch"
#include "topconn.ch"
#Include "rwmake.ch"

User Function FATCONFBI()
Local Cabec1 := "Filial Nota-Série  Tipo    Cliente                                  Segmento"
Local Cabec2 := "Cod.Prod.   Descricao                                                     " + ;
					"Quantidade     Prc Tabela      Val Merc.          Custo       Val Icms        Val Ipi        Val Pis     Val Cofins    Icms Retido"

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio conferencia BI"
Local cPict          := ""
Local Titulo       := "Relatório de faturamento para conferência com o BI"
Local nLin         := 80
Local imprime      := .T.
Local aOrd := {}

Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "FATCBI" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cPerg        := PadR("FATCONFBI", LEN(SX1->X1_GRUPO))
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "FATCBI" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "SD2"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis padrao de todos os relatorios                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
AjustaPerg(cPerg)

if !Pergunte(cPerg)
	Return
EndIf

cMovIni := PadL(AllTrim(Str(MV_PAR05)), 2,"0")
cMovFin := PadL(AllTrim(Str(MV_PAR06)), 2,"0")

//SetPrint(cString, WnRel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27 .Or. nLastKey == 27
   Return
Endif

SetDefault(aReturn,cString)
If nLastKey == 27 .Or. nLastkey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return


Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem

if (mv_par13 == 2) // Sintético
	Cabec2 := ""
	Cabec1 := Space(Len(Cabec1)) + "       Quantidade     Prc Tabela      Val Merc.          Custo       Val Icms        Val Ipi        Val Pis     Val Cofins   Icms Retido"
elseif (mv_par13 == 3)
	Cabec2 := ""
	Cabec1 += "       Quantidade     Prc Tabela      Val Merc.          Custo       Val Icms        Val Ipi        Val Pis     Val Cofins   Icms Retido"
EndIf


BeginSql Alias "TMP" 	
 	SELECT F2_FILIAL, F2_TIPO, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA,
	        D2_CF, D2_COD, D2_CUSTO1, D2_EMISSAO, D2_FILIAL, D2_GRUPO, D2_ITEM,  D2_LOCAL, D2_PRUNIT, D2_QUANT, 
	        D2_TOTAL, D2_UM, D2_VALIPI, D2_VALICM - D2_VALISS AS D2_VALICM, D2_ICMSRET, D2_VALIMP6 AS D2_VALPIS, D2_VALIMP5 AS D2_VALCOFINS,
	        D2_CCUSTO AS D2_CENTROCUSTO, 
					D2_CLVL,
					L1_X_CLVL,
	        C6_PRCTAB,
	        F4_CATMOV,
	        A1_NREDUZ, A1_GRPVEN,
	        B1_DESC
	        
	FROM %TABLE:SF2% SF2
		INNER JOIN %table:SD2% SD2 ON (D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND D2_FILIAL = F2_FILIAL) 
		INNER JOIN %table:SF4% SF4 ON (D2_TES = F4_CODIGO)
		INNER JOIN %table:SA1% SA1 ON (SA1.A1_COD = SF2.F2_CLIENTE AND SA1.A1_LOJA = SF2.F2_LOJA)
		INNER JOIN %table:SB1% SB1 ON (SB1.B1_COD = SD2.D2_COD)
		
	  LEFT JOIN %table:SC6% SC6 ON C6_FILIAL = D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV 
	                  AND SC6.D_E_L_E_T_ <> '*'
	  LEFT JOIN %table:SL1% SL1  ON L1_FILIAL = D2_FILIAL AND L1_DOC = D2_DOC AND L1_SERIE = D2_SERIE 
	                  AND SL1.D_E_L_E_T_ <> '*'
	WHERE SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*'
	AND SF2.F2_EMISSAO >= %Exp:MV_PAR01% AND SF2.F2_EMISSAO <= %Exp:MV_PAR02%
	AND SF2.F2_FILIAL >= %Exp:MV_PAR03% AND SF2.F2_FILIAL <= %Exp:MV_PAR04%
	AND SF4.F4_CATMOV >= %Exp:cMovIni% AND SF4.F4_CATMOV <= %Exp:cMovFin%
	AND SF2.F2_VEND1 >= %Exp:MV_PAR07% AND SF2.F2_VEND1 <= %Exp:MV_PAR08%
	AND SF2.F2_CLIENTE >= %Exp:MV_PAR09% AND SF2.F2_CLIENTE <= %Exp:MV_PAR10%
	AND SF2.F2_LOJA >= %Exp:MV_PAR11% AND SF2.F2_LOJA <= %Exp:MV_PAR12%
	AND SD2.D2_CLVL >= %Exp:MV_PAR14% AND SD2.D2_CLVL <= %Exp:MV_PAR15%
	AND SF2.F2_TIPO NOT IN ('D', 'B')
	ORDER BY F4_CATMOV, F2_FILIAL, F2_SERIE, F2_DOC, D2_COD
EndSql

// Obtém das devoluções
BeginSql Alias "TMPDEV"
 	SELECT F1_FILIAL, F1_TIPO, F1_DOC, F1_SERIE, F1_FORNECE AS F1_CLIENTE, F1_LOJA,
	        D1_CF, D1_COD, D1_CUSTO, D1_EMISSAO, D1_GRUPO, D1_ITEM,  D1_LOCAL, D1_QUANT, 
	        D1_TOTAL, D1_VALIPI, D1_VALICM, D1_ICMSRET, D1_VALIMP6 AS D1_VALPIS, D1_VALIMP5 AS D1_VALCOFINS,
	        D1_CC AS D1_CENTROCUSTO, 
					D1_CLVL,
	        F4_CATMOV,
	        A1_NREDUZ, A1_GRPVEN,
	        B1_DESC
	        
	FROM %TABLE:SF1% SF1
		INNER JOIN %table:SD1% SD1 ON (D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FILIAL = F1_FILIAL AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA) 
		INNER JOIN %table:SF4% SF4 ON (D1_TES = F4_CODIGO)
		INNER JOIN %table:SA1% SA1 ON (SA1.A1_COD = SF1.F1_FORNECE AND SA1.A1_LOJA = SF1.F1_LOJA)
		INNER JOIN %table:SB1% SB1 ON (SB1.B1_COD = SD1.D1_COD)
	  
	WHERE SF1.D_E_L_E_T_ <> '*' AND SD1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*'
	AND SF1.F1_DTDIGIT >= %Exp:MV_PAR01% AND SF1.F1_DTDIGIT <= %Exp:MV_PAR02%
	AND SF1.F1_FILIAL >= %Exp:MV_PAR03% AND SF1.F1_FILIAL <= %Exp:MV_PAR04%
	AND SF1.F1_FORNECE >= %Exp:MV_PAR09% AND SF1.F1_FORNECE <= %Exp:MV_PAR10%
	AND SF1.F1_LOJA >= %Exp:MV_PAR11% AND SF1.F1_LOJA <= %Exp:MV_PAR12%
	AND SD1.D1_CLVL >= %Exp:MV_PAR14% AND SD1.D1_CLVL <= %Exp:MV_PAR15% // VERIFICAR QUANTO AOS RATEIOS
	AND SF1.F1_TIPO =  'D'
	ORDER BY F1_FILIAL, F1_SERIE, F1_DOC, D1_COD
EndSql


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(TMP->(RecCount()))

// Fazer a parte do relatório, agrupando primeiramente por F4_CATMOV (buscar as descrições) e após por nota fiscal, 
// fazendo um totalizador geral e um por f4_catmov para os campos d2_quant, d2_total, d2_valipi, d2_valicm, d2_icmsret, d2_valpis, d2_valcofins

cChaveCatMov := TMP->F4_CATMOV
cChaveDoc    := TMP->F2_FILIAL + TMP->F2_SERIE + TMP->F2_DOC

nTotNF := 0
nQtdNF := 0
nCustoNF := 0
nIcmNF := 0
nIpiNF := 0
nPisNF := 0
nCofNF := 0
nSolNF := 0

nTotGrp := 0
nQtdGrp := 0
nCustoGrp := 0
nIcmGrp := 0
nIpiGrp := 0
nPisGrp := 0
nCofGrp := 0
nSolGrp := 0

nTotTot := 0
nQtdTot := 0
nCustoTot := 0
nIcmTot := 0
nIpiTot := 0
nPisTot := 0
nCofTot := 0
nSolTot := 0             

nTotDev := 0
nQtdDev := 0
nCustoDev := 0
nIcmDev := 0
nIpiDev := 0
nPisDev := 0
nCofDev := 0
nSolDev := 0 

While TMP->(!Eof())
  
	// Zera totalizadores do grupo
	nTotGrp := 0
	nQtdGrp := 0
	nCustoGrp := 0
	nIcmGrp := 0
	nIpiGrp := 0
	nPisGrp := 0
	nCofGrp := 0
	nSolGrp := 0
	
	If lAbortPrint
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif
	
	if TMP->(!Bof())
		Eject
	EndIf
//	SetPrc(0,0)
//	Cabec("Relatório de faturamento para conferência com o BI", cCabec1, cCabec2, "FATCONFBI", "G", 18)
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	@ 8, 00 PSay ""
	
	IncProc()
	
	/*If nLin > 80 // Salto de Página. Neste caso o formulario tem 55 linhas...
    Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
    nLin := 8
  Endif*/
	
	                                         
	@ PRow() + 1, 00 PSay Replicate("=", iif(mv_par13 == 1, 205, 215))
	@ PRow() + 1, 00 PSay " Operação " + GetDescri(TMP->F4_CATMOV)
	@ PRow() + 1, 00 PSay Replicate("-", iif(mv_par13 == 1, 205, 215))
	
	While cChaveCatMov == TMP->F4_CATMOV
		                                                   
		// Cabeçalho da NF
		if (mv_par13 <> 3)
			@ Prow() + 1, 01 PSay TMP->F2_FILIAL + "  "  +  TMP->F2_DOC + " - " + TMP->F2_SERIE + "   " + TMP->F2_TIPO + "  " +TMP->F2_CLIENTE + ;
						" (" + TMP->F2_LOJA + ") - " + TMP->A1_NREDUZ + "  " + iif(Empty(TMP->D2_CLVL), TMP->L1_X_CLVL, TMP->D2_CLVL)
		EndIf
					
		// Zera totalizadores da NF
		nTotNF := 0
		nQtdNF := 0
		nCustoNF := 0
		nIcmNF := 0
		nIpiNF := 0
		nPisNF := 0
		nCofNF := 0
		nSolNF := 0
		
		While cChaveDoc == TMP->F2_FILIAL + TMP->F2_SERIE + TMP->F2_DOC
		
			// "Produto    Quantidade  Preço Tabela   Total  Custo    Icms    IPI     Pis   Cofins Icms Retido"
			if (mv_par13 == 1)
				@ PRow() + 1, 02 PSay AllTrim(TMP->D2_COD)
				@ PRow() , 12 PSay Substr(TMP->B1_DESC, 1, 60)
				@ PRow() , 73 PSay TMP->D2_QUANT Picture "@E 999,9999.99"
				@ PRow() , 85 PSay TMP->C6_PRCTAB Picture "@E 99,999,9999.99"
				@ PRow() , 100 PSay TMP->D2_TOTAL Picture "@E 99,999,9999.99"
				@ PRow() , 115 PSay TMP->D2_CUSTO1 Picture "@E 99,999,9999.99"
				@ PRow() , 130 PSay TMP->D2_VALICM Picture "@E 99,999,9999.99"
				@ PRow() , 145 PSay TMP->D2_VALIPI Picture "@E 99,999,9999.99"
				@ PRow() , 160 PSay TMP->D2_VALPIS Picture "@E 99,999,9999.99"
				@ PRow() , 175 PSay TMP->D2_VALCOFINS Picture "@E 99,999,9999.99"
				@ PRow() , 190 PSay TMP->D2_ICMSRET Picture "@E 99,999,9999.99"
			EndIf
			
			nTotNF += TMP->D2_TOTAL
			nQtdNF += TMP->D2_QUANT
			nCustoNF += TMP->D2_CUSTO1
			nIcmNF += TMP->D2_VALICM
			nIpiNF += TMP->D2_VALIPI
			nPisNF += TMP->D2_VALPIS
			nCofNF += TMP->D2_VALCOFINS
			nSolNF += TMP->D2_ICMSRET
			
			if PRow() > 68
//				Eject
//				SetPrc(0,0)
				// Cabec("Relatório de faturamento para conferência com o BI", cCabec1, cCabec2, "FATCONFBI", "G", 18)
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				@ 8, 00 PSay ""
			EndIf

			TMP->(dbSkip())
		
		EndDo
		
		// Soma os totalizadores do grupo
    nTotGrp += nTotNF
		nQtdGrp += nQtdNF
		nCustoGrp += nCustoNF
		nIcmGrp += nIcmNF
		nIpiGrp += nIpiNF
		nPisGrp += nPisNF
		nCofGrp += nCofNF
		nSolGrp += nSolNF
    

		// Imprime totalizadores da NF
		if (mv_par13 == 1)
			@ Prow()+1, 00 PSay Replicate("-", 205)
			@ PRow()+1 , 01 PSay "Totais NF ->>"
		EndIf
		
		if (mv_par13 == 1)
			@ PRow() , 73 PSay nQtdNF Picture "@E 999,999.99"
			@ PRow() , 100 PSay nTotNF Picture "@E 99,999,999.99"
			@ PRow() , 115 PSay nCustoNF Picture "@E 99,999,999.99"
			@ PRow() , 130 PSay nIcmNF Picture "@E 99,999,999.99"
			@ PRow() , 145 PSay nIpiNF Picture "@E 9,999,999.99"
			@ PRow() , 160 PSay nPisNF Picture "@E 9,999,999.99"
			@ PRow() , 175 PSay nCofNF Picture "@E 9,999,999.99"
			@ PRow() , 190 PSay nSolNF Picture "@E 9,999,999.99"
		elseif (mv_par13 == 2)
			@ PRow() , 83 PSay nQtdNF Picture "@E 999,999.99"
			@ PRow() , 110 PSay nTotNF Picture "@E 99,999,999.99"
			@ PRow() , 125 PSay nCustoNF Picture "@E 99,999,999.99"
			@ PRow() , 140 PSay nIcmNF Picture "@E 99,999,999.99"
			@ PRow() , 155 PSay nIpiNF Picture "@E 9,999,999.99"
			@ PRow() , 170 PSay nPisNF Picture "@E 9,999,999.99"
			@ PRow() , 185 PSay nCofNF Picture "@E 9,999,999.99"
			@ PRow() , 200 PSay nSolNF Picture "@E 9,999,999.99"
		EndIf
		
		cChaveDoc := TMP->F2_FILIAL + TMP->F2_SERIE + TMP->F2_DOC
	EndDo
	
	
	// soma os totalizadores geral do relatório
	nTotTot += nTotGrp
	nQtdTot += nQtdGrp
	nCustoTot += nCustoGrp
	nIcmTot += nIcmGrp
	nIpiTot += nIpiGrp
	nPisTot += nPisGrp
	nCofTot += nCofGrp
	nSolTot += nSolGrp
	
	// Imprime totalizadores do Grupo
	if (mv_par13 == 1)
		@ Prow()+1, 00 PSay Replicate("-", 205)
		@ PRow()+1 , 01 PSay "Totais Operação " + GetDescri(cChaveCatMov) + "  ->>"
		@ PRow() , 73 PSay nQtdGrp Picture "@E 999,999.99"
		@ PRow() , 100 PSay nTotGrp Picture "@E 99,999,999.99"
		@ PRow() , 115 PSay nCustoGrp Picture "@E 99,999,999.99"
		@ PRow() , 130 PSay nIcmGrp Picture "@E 99,999,999.99"
		@ PRow() , 145 PSay nIpiGrp Picture "@E 9,999,999.99"
		@ PRow() , 160 PSay nPisGrp Picture "@E 9,999,999.99"
		@ PRow() , 175 PSay nCofGrp Picture "@E 9,999,999.99"
		@ PRow() , 190 PSay nSolGrp Picture "@E 9,999,999.99"
	else
		@ Prow()+1, 00 PSay Replicate("-", 215)
		@ PRow()+1, 01 PSay "Totais Operação " + GetDescri(cChaveCatMov) + "  ->>"
		@ PRow() , 83 PSay nQtdGrp Picture "@E 999,999.99"
		@ PRow() , 110 PSay nTotGrp Picture "@E 99,999,999.99"
		@ PRow() , 125 PSay nCustoGrp Picture "@E 99,999,999.99"
		@ PRow() , 140 PSay nIcmGrp Picture "@E 99,999,999.99"
		@ PRow() , 155 PSay nIpiGrp Picture "@E 9,999,999.99"
		@ PRow() , 170 PSay nPisGrp Picture "@E 9,999,999.99"
		@ PRow() , 185 PSay nCofGrp Picture "@E 9,999,999.99"
		@ PRow() , 200 PSay nSolGrp Picture "@E 9,999,999.99"
	EndIf
		
	cChaveCatMov := TMP->F4_CATMOV
	
EndDo

// Imprime totalizadores do Relatório
if (mv_par13 == 1)
	@ Prow()+1, 00 PSay Replicate("=", 205)
	@ PRow()+1 , 00 PSay "Total Faturado ->>"
	@ PRow() , 73 PSay nQtdTot Picture "@E 999,999.99"
	@ PRow() , 100 PSay nTotTot Picture "@E 99,999,999.99"
	@ PRow() , 115 PSay nCustoTot Picture "@E 99,999,999.99"
	@ PRow() , 130 PSay nIcmTot Picture "@E 99,999,999.99"
	@ PRow() , 145 PSay nIpiTot Picture "@E 9,999,999.99"
	@ PRow() , 160 PSay nPisTot Picture "@E 9,999,999.99"
	@ PRow() , 175 PSay nCofTot Picture "@E 9,999,999.99"
	@ PRow() , 190 PSay nSolTot Picture "@E 9,999,999.99"
else
	@ Prow()+1, 00 PSay Replicate("=", 215)
	@ PRow()+1 , 00 PSay "Total Faturado ->>"
	@ PRow() , 83 PSay nQtdTot Picture "@E 999,999.99"
	@ PRow() , 110 PSay nTotTot Picture "@E 99,999,999.99"
	@ PRow() , 125 PSay nCustoTot Picture "@E 99,999,999.99"
	@ PRow() , 140 PSay nIcmTot Picture "@E 99,999,999.99"
	@ PRow() , 155 PSay nIpiTot Picture "@E 9,999,999.99"
	@ PRow() , 170 PSay nPisTot Picture "@E 9,999,999.99"
	@ PRow() , 185 PSay nCofTot Picture "@E 9,999,999.99"
	@ PRow() , 200 PSay nSolTot Picture "@E 9,999,999.99"
EndIf

DbSelectArea("TMP")
TMP->(DbCloseArea("TMP"))

// Imprime a parte das devoluções
cChaveDoc == TMPDEV->F1_FILIAL + TMPDEV->F1_SERIE + TMPDEV->F1_DOC + TMPDEV->F1_CLIENTE + TMPDEV->F1_LOJA
  
if TMPDEV->(!Eof())
//	Eject
//	SetPrc(0,0)
	//Cabec("Relatório de faturamento para conferência com o BI", cCabec1, cCabec2, "FATCONFBI", "G", 18)
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	@ 8, 00 Psay ""
EndIf

cChaveDoc := TMPDEV->F1_FILIAL + TMPDEV->F1_SERIE + TMPDEV->F1_DOC + TMPDEV->F1_CLIENTE + TMPDEV->F1_LOJA

if TMPDEV->(!Eof())
	@ PRow() + 1, 00 PSay Replicate("=", iif(mv_par13 == 1, 205, 215))
	@ PRow() + 1, 00 PSay " Operação " + "Devolucao"
	@ PRow() + 1, 00 PSay Replicate("-", iif(mv_par13 == 1, 205, 215))
EndIf

While TMPDEV->(!Eof())
  
	cChaveDoc := TMPDEV->F1_FILIAL + TMPDEV->F1_SERIE + TMPDEV->F1_DOC + TMPDEV->F1_CLIENTE + TMPDEV->F1_LOJA
	
	// Cabeçalho da NF
	if (mv_par13 <> 3)
		@ Prow() + 1, 01 PSay TMPDEV->F1_FILIAL + "  "  +  TMPDEV->F1_DOC + " - " + TMPDEV->F1_SERIE + "   " + TMPDEV->F1_TIPO + "  " +TMPDEV->F1_CLIENTE + ;
					" (" + TMPDEV->F1_LOJA + ") - " + TMPDEV->A1_NREDUZ + "  " + TMPDEV->D1_CLVL
	EndIf
	
	IncProc()
				
	// Zera totalizadores da NF
	nTotNF := 0
	nQtdNF := 0
	nCustoNF := 0
	nIcmNF := 0
	nIpiNF := 0
	nPisNF := 0
	nCofNF := 0
	nSolNF := 0
	
	While cChaveDoc == TMPDEV->F1_FILIAL + TMPDEV->F1_SERIE + TMPDEV->F1_DOC + TMPDEV->F1_CLIENTE + TMPDEV->F1_LOJA
	
		// "Produto    Quantidade  Preço Tabela   Total  Custo    Icms    IPI     Pis   Cofins Icms Retido"
		if (mv_par13 == 1)
			@ PRow() + 1, 02 PSay AllTrim(TMPDEV->D1_COD)
			@ PRow() , 12 PSay Substr(TMPDEV->B1_DESC, 1, 60)
			@ PRow() , 73 PSay TMPDEV->D1_QUANT Picture "@E 999,9999.99"
			@ PRow() , 100 PSay TMPDEV->D1_TOTAL Picture "@E 99,999,9999.99"
			@ PRow() , 115 PSay TMPDEV->D1_CUSTO Picture "@E 99,999,9999.99"
			@ PRow() , 130 PSay TMPDEV->D1_VALICM Picture "@E 99,999,9999.99"
			@ PRow() , 145 PSay TMPDEV->D1_VALIPI Picture "@E 99,999,9999.99"
			@ PRow() , 160 PSay TMPDEV->D1_VALPIS Picture "@E 99,999,9999.99"
			@ PRow() , 175 PSay TMPDEV->D1_VALCOFINS Picture "@E 99,999,9999.99"
			@ PRow() , 190 PSay TMPDEV->D1_ICMSRET Picture "@E 99,999,9999.99"
		EndIf
		
		nTotNF += TMPDEV->D1_TOTAL
		nQtdNF += TMPDEV->D1_QUANT
		nCustoNF += TMPDEV->D1_CUSTO
		nIcmNF += TMPDEV->D1_VALICM
		nIpiNF += TMPDEV->D1_VALIPI
		nPisNF += TMPDEV->D1_VALPIS
		nCofNF += TMPDEV->D1_VALCOFINS
		nSolNF += TMPDEV->D1_ICMSRET
		
		if PRow() > 68
			//Eject
			//SetPrc(0,0)
			//Cabec("Relatório de faturamento para conferência com o BI", cCabec1, cCabec2, "FATCONFBI", "G", 18)
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			@ 8, 00 PSay ""
		EndIf

		TMPDEV->(dbSkip())
	
	EndDo    

	// Imprime totalizadores da NF
	if (mv_par13 == 1)
		@ Prow()+1, 00 PSay Replicate("-", 205)
		@ PRow()+1 , 01 PSay "Totais NF ->>"
	EndIf
	
	if (mv_par13 == 1)
		@ PRow() , 73 PSay nQtdNF Picture "@E 999,999.99"
		@ PRow() , 100 PSay nTotNF Picture "@E 99,999,999.99"
		@ PRow() , 115 PSay nCustoNF Picture "@E 99,999,999.99"
		@ PRow() , 130 PSay nIcmNF Picture "@E 99,999,999.99"
		@ PRow() , 145 PSay nIpiNF Picture "@E 9,999,999.99"
		@ PRow() , 160 PSay nPisNF Picture "@E 9,999,999.99"
		@ PRow() , 175 PSay nCofNF Picture "@E 9,999,999.99"
		@ PRow() , 190 PSay nSolNF Picture "@E 9,999,999.99"
	elseif (mv_par13 == 2)
		@ PRow() , 83 PSay nQtdNF Picture "@E 999,999.99"
		@ PRow() , 110 PSay nTotNF Picture "@E 99,999,999.99"
		@ PRow() , 125 PSay nCustoNF Picture "@E 99,999,999.99"
		@ PRow() , 140 PSay nIcmNF Picture "@E 99,999,999.99"
		@ PRow() , 155 PSay nIpiNF Picture "@E 9,999,999.99"
		@ PRow() , 170 PSay nPisNF Picture "@E 9,999,999.99"
		@ PRow() , 185 PSay nCofNF Picture "@E 9,999,999.99"
		@ PRow() , 200 PSay nSolNF Picture "@E 9,999,999.99"
	EndIf
		
	cChaveDoc := TMPDEV->F1_FILIAL + TMPDEV->F1_SERIE + TMPDEV->F1_DOC + TMPDEV->F1_CLIENTE + TMPDEV->F1_LOJA
	
	
		// soma os totalizadores geral do relatório
	nTotDev += nTotNF
	nQtdDev += nQtdNF
	nCustoDev += nCustoNF
	nIcmDev += nIcmNF
	nIpiDev += nIpiNF
	nPisDev += nPisNF
	nCofDev += nCofNF
	nSolDev += nSolNF
	
EndDo

// Imprime totalizadores do Relatório
if (mv_par13 == 1)
	@ Prow()+1, 00 PSay Replicate("-", 205)
	@ PRow()+1 , 00 PSay "Total Devolucao ->>"
	@ PRow() , 73 PSay nQtdDev Picture "@E 999,999.99"
	@ PRow() , 100 PSay nTotDev Picture "@E 99,999,999.99"
	@ PRow() , 115 PSay nCustoDev Picture "@E 99,999,999.99"
	@ PRow() , 130 PSay nIcmDev Picture "@E 99,999,999.99"
	@ PRow() , 145 PSay nIpiDev Picture "@E 9,999,999.99"
	@ PRow() , 160 PSay nPisDev Picture "@E 9,999,999.99"
	@ PRow() , 175 PSay nCofDev Picture "@E 9,999,999.99"
	@ PRow() , 190 PSay nSolDev Picture "@E 9,999,999.99"
else
	@ Prow()+1, 00 PSay Replicate("-", 215)
	@ PRow()+1 , 00 PSay "Total Devolucao ->>"
	@ PRow() , 83 PSay nQtdDev Picture "@E 999,999.99"
	@ PRow() , 110 PSay nTotDev Picture "@E 99,999,999.99"
	@ PRow() , 125 PSay nCustoDev Picture "@E 99,999,999.99"
	@ PRow() , 140 PSay nIcmDev Picture "@E 99,999,999.99"
	@ PRow() , 155 PSay nIpiDev Picture "@E 9,999,999.99"
	@ PRow() , 170 PSay nPisDev Picture "@E 9,999,999.99"
	@ PRow() , 185 PSay nCofDev Picture "@E 9,999,999.99"
	@ PRow() , 200 PSay nSolDev Picture "@E 9,999,999.99"
EndIf

if (mv_par13 == 1)
	@ Prow()+1, 00 PSay Replicate("=", 205)
	@ PRow()+1 , 00 PSay "Total Geral ->>"
	@ PRow() , 73 PSay nQtdTot - nQtdDev Picture "@E 999,999.99"
	@ PRow() , 100 PSay nTotTot - nTotDev Picture "@E 99,999,999.99"
	@ PRow() , 115 PSay nCustoTot - nCustoDev Picture "@E 99,999,999.99"
	@ PRow() , 130 PSay nIcmTot - nIcmDev Picture "@E 99,999,999.99"
	@ PRow() , 145 PSay nIpiTot - nIpiDev Picture "@E 9,999,999.99"
	@ PRow() , 160 PSay nPisTot - nPisDev Picture "@E 9,999,999.99"
	@ PRow() , 175 PSay nCofTot - nCofDev Picture "@E 9,999,999.99"
	@ PRow() , 190 PSay nSolTot - nSolDev Picture "@E 9,999,999.99"
else
	@ Prow()+1, 00 PSay Replicate("=", 215)
	@ PRow()+1 , 00 PSay "Total Geral ->>"
	@ PRow() , 83 PSay nQtdTot - nQtdDev Picture "@E 999,999.99"
	@ PRow() , 110 PSay nTotTot - nTotDev Picture "@E 99,999,999.99"
	@ PRow() , 125 PSay nCustoTot - nCustoDev Picture "@E 99,999,999.99"
	@ PRow() , 140 PSay nIcmTot - nIcmDev Picture "@E 99,999,999.99"
	@ PRow() , 155 PSay nIpiTot - nIpiDev Picture "@E 9,999,999.99"
	@ PRow() , 170 PSay nPisTot - nPisDev Picture "@E 9,999,999.99"
	@ PRow() , 185 PSay nCofTot - nCofDev Picture "@E 9,999,999.99"
	@ PRow() , 200 PSay nSolTot - nSolDev Picture "@E 9,999,999.99"
EndIf

DbSelectArea("TMPDEV")
TMPDEV->(DbCloseArea("TMPDEV"))

// Inserido devido a última página não estar sendo impressa
Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
@ 8, 00 PSay ""

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif
MS_FLUSH()
Return Nil

Static Function AjustaPerg()
PutSx1(cPerg,"01","Data Emissao De ?","Data Emissao De ?","Data Emissao De ?", "mv_dti", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Data Emissao Ate ?","Data Emissao Ate ?","Data Emissao Ate ?", "mv_dtf", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Filial De ?","Filial De ?","Filial De ?", "mv_gpi", "C", 02, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Filial Ate ?","Filial Ate ?","Filial Ate ?", "mv_gpf", "C", 02, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05", "Operacao De", "Operacao De", "Operacao De", "mv_opi", "N", 01, 0, ,"C", "", "", "", "", "MV_PAR05", ;
	"Bonificacao","","", "", "Deterioracao", "", "","Venda", "", "", "Transferencia")
PutSx1(cPerg,"06","Operacao Ate ?","Operacao Ate ?","Operacao Ate ?", "mv_gpf", "N", 01, 0, ,"C", "", "", "", "", "MV_PAR06", ;
	"Bonificacao","","", "", "Deterioracao", "", "","Venda", "", "", "Transferencia")
PutSx1(cPerg,"07","Vendedor De ?","Vendedor De ?","Vendedor De ?", "mv_gp7", "C", 06, 0, ,"G", "", "SA3", "", "","MV_PAR07")
PutSx1(cPerg,"08","Vendedor Ate ?","Vendedor Ate ?","Vendedor Ate ?", "mv_gp8", "C", 06, 0, ,"G", "", "SA3", "", "","MV_PAR08")
PutSx1(cPerg,"09","Cliente De ?","Cliente De ?","Cliente De ?", "mv_gp9", "C", 09, 0, ,"G", "", "SA1", "", "","MV_PAR09")
PutSx1(cPerg,"10","Cliente Ate ?","Cliente Ate ?","Cliente Ate ?", "mv_gpa", "C", 09, 0, ,"G", "", "SA1", "", "","MV_PAR10")
PutSx1(cPerg,"11","Loja De ?","Loja De ?","Loja De ?", "mv_gpb", "C", 04, 0, ,"G", "", "", "", "","MV_PAR11")
PutSx1(cPerg,"12","Loja Ate ?","Loja Ate ?","Loja Ate ?", "mv_gpc", "C", 04, 0, ,"G", "", "", "", "","MV_PAR12")
PutSx1(cPerg,"13","Tipo Relatorio ?","Tipo Relatorio ?","Tipo Relatorio ?", "mv_gpe", "N", 01, 0, ,"C", "", "", "", "","MV_PAR13", ;
		"Analitico","","", "","Sintetico","", "", "Resumo")
		
PutSx1(cPerg,"14","Segmento de ?","Segmento de ?","Segmento de ?", "mv_gpf", "C", 09, 0, ,"G", "", "CTH", "", "","MV_PAR14")
PutSx1(cPerg,"15","Segmento ate ?","Segmento ate ?","Segmento ate ?", "mv_gpg", "C", 09, 0, ,"G", "", "CTH", "", "","MV_PAR15")
Return

Static Function GetDescri(cOper)
Local cDescOper := ""
cOper := Trim(cOper)
if (cOper == "01")
	cDescOper := "Bonificacao"
elseif (cOper == "02")
	cDescOper := "Deterioracao"
elseif (cOper == "03")
	cDescOper := "Venda"
elseif (cOper == "04")
	cDescOper := "Transferencia"
EndIf
Return cDescOper