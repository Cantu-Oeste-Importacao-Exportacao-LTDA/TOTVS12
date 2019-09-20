#INCLUDE "rwmake.ch"
#include "topconn.ch" 

User Function RJU029()
Local oDlg
Local aCA:={OemToAnsi("Confirma"),OemToAnsi("Abandona")}
Local cCadastro := OemToAnsi("Saldo por Vendedor")
Local aSays:={}, aButtons:={}
Local nOpca := 0
Private aReturn  := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 }
Private nLastKey := 0
Private cPerg    := "RJU029"
Private cCodEmp  := ""
Private cNumBco  := ""    

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

SetPrvt("aCA,CCADASTRO,ASAYS,ABUTTONS,NOPCA,ARETURN")
SetPrvt("NLASTKEY,CPERG,xCODEMP,xCODFIL")
SetPrvt("OFONT1,OFONT2,OFONT3,OFONT4,OFONT5,OFONT6,OFONT11,OFONT12,OFONT13,OFONT14,OFONT15,OFONT16")
SetPrvt("OPRN,NTPAG")

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.
SetPrvt("nLinha,nColuna")

SetPrvt("NTIPO,ADBF,CARQ,CARQIND,CENTREGA")
SetPrvt("cAux,TOT")
                                  
	nLM  :=  100	//Left Margin
	nRM  := 2261	//Right Margin
	nTM  :=  100	//Top Margin
	nBM  := 3300	//Botton Margin
	nRH  :=   50	//Line Height   original:50
	nCW  :=   26	//Character Width
	nRow :=    1	//Linha atual
	nCol :=    1	//Coluna Atual
	nRP  := nTM+3	//Posicao da Primeira Linha Atual
	nCP  := nLM+3	//Posicao da Primeira Coluna Atual
	nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
	nCD  := nLM+0	//Posicao da Primeira Coluna (divisao) Atual
	nLinha  := 1
	nColuna := 1
	
	If nLastKey == 27 .Or. nLastKey == 27
	   Return
	Endif
	Pergunte(cPerg,.T.)
	If nLastKey == 27 .Or. nLastKey == 27
	   Return
	Endif	
	Processa( {|| ImpRom() }, "Gerando Relatorio...")	
Return
 
Static Function ImpRom()
Public oFont1 := TFont():New( "Verdana"    ,,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Verdana"    ,,10,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Verdana"    ,,12,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Verdana"    ,,14,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Verdana"    ,,16,,.F.,,,,,.F. )
Public oFont6 := TFont():New( "Courier New",,12,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Verdana"    ,,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Verdana"    ,,10,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Verdana"    ,,12,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Verdana"    ,,14,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Verdana"    ,,16,,.T.,,,,,.F. )
Public oFont16:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0

	oPrn:=TMSPrinter():New()
	oPrn:SetPortrait() // ou SetLandscape()
	oPrn:SetPage(9)	//Folha A4
	oPrn:Setup()
	CabcPar()
	nLinha:=9
    
	SM0->(DbSetOrder(1))
	dbSelectArea("SM0")				// * Sigamat.emp
	xCODEMP   := SM0->M0_CODIGO 	// Empresa 
	xCODFIL   := SM0->M0_CODFIL		// Filial 
	xNOME_EMP := SM0->M0_NOMECOM
	xEND_EMP  := SM0->M0_ENDCOB  
	xCOMP_EMP := SM0->M0_COMPCOB
	xBAIR_EMP := SM0->M0_BAIRCOB
	xTEL_EMP  := SM0->M0_TEL
	xFAX_EMP  := SM0->M0_FAX
	xCEP_EMP  := SM0->M0_CEPCOB
	xCID_EMP  := SM0->M0_CIDCOB
	xEST_EMP  := SM0->M0_ESTCOB 
	xCGC_EMP  := SM0->M0_CGC 
	xINSC_EMP := SM0->M0_INSC
		

	cQuery := "SELECT SUM(D2_TOTAL) AS VALOR,D2_DOC AS DOC,A1_NOME AS CLIENTE,D2_LOJA AS LOJA,E4_DESCRI AS CONDICAO,F2_VEND1 AS VENDEDOR "
	cQuery += "FROM SD2"+xCODEMP+"0 AS SD2 INNER JOIN SA1"+xCODEMP+"0 AS SA1 ON SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA "
	cQuery += "INNER JOIN SF2"+xCODEMP+"0 AS SF2 ON SF2.F2_FILIAL=SD2.D2_FILIAL AND SF2.F2_DOC=SD2.D2_DOC "
	cQuery += "INNER JOIN SE4"+xCODEMP+"0 AS SE4 ON SE4.E4_CODIGO=SF2.F2_COND WHERE "
	cQuery += "SD2.D2_FILIAL = '"+xCODFIL+"' AND SF2.F2_VEND1 >= '"+MV_PAR04+"' AND SF2.F2_VEND1 <= '"+MV_PAR05+"' AND "
	cQuery += "SD2.D2_GRUPO = '"+MV_PAR03+"' AND SD2.D2_EMISSAO >= '"+DtOs(MV_PAR01)+"' AND SD2.D2_EMISSAO <= '"+DtOs(MV_PAR02)+"' AND "
	cQuery += "SD2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND SE4.D_E_L_E_T_ <> '*' "
	cQuery += "GROUP BY D2_DOC,A1_NOME,D2_CLIENTE,D2_LOJA,E4_DESCRI,F2_VEND1 ORDER BY A1_NOME"
	TCQUERY cQuery NEW ALIAS "TMPVND"
	MEMOWRITE("VNDXCLI.SQL",CQUERY)
	dbSelectArea("TMPVND")
	
	ProcRegua(TMPVND->(LastRec()))
	dbGoTop()
	TOT    := 0
	While TMPVND->(!Eof())
		PrintS(nLinha ,1 ,TMPVND->DOC     ,2 )
	    PrintS(nLinha ,7 ,TMPVND->CLIENTE ,2 )
	    PrintS(nLinha ,45,TMPVND->LOJA    ,2 )
	    PrintS(nLinha ,50,TMPVND->VENDEDOR,2 )
	    PrintS(nLinha ,56,TMPVND->CONDICAO,2 )
	    PrintS(nLinha ,74,TRANSFORM(TMPVND->VALOR,'@E 999,999.99'),6 )
	    DrawH(nLinha,1,84,2)
	    DrawV(nLinha-1,7 ,nLinha,2)
	    DrawV(nLinha-1,45,nLinha,2)
	    DrawV(nLinha-1,50,nLinha,2)
	    DrawV(nLinha-1,56,nLinha,2)
	    DrawV(nLinha-1,71,nLinha,2)
	    
		TOT    += TMPVND->VALOR
		nLinha += 1
		If nLinha==65
			oPrn:EndPage()
			oPrn:StartPage()
	        CabcPar()
		End If
		TMPVND->(DbSkip())
		IncProc()
	End
	
    DrawV(nLinha-1,56,nLinha,2)
    PrintS(nLinha ,56,"TOTAL",12 )
    PrintS(nLinha ,74,TRANSFORM(TOT,'@E 999,999.99'),16)
    DrawV(nLinha-1,71,nLinha,2)	
    DrawH(nLinha,1 ,84,2)
	
	TMPVND->(dbCloseArea())
	oPrn:EndPage()
	Set Device To Screen
	If aReturn[5] == 1
   		Set Printer To
   		OurSpool(WnRel)
	Endif
	FT_PFlush()	
	oPrn:Preview()
	//oPrn:Print() // descomentar esta linha para imprimir direto
	MS_FLUSH()
Return 

/*
+-----------+------------------------------------------+------+----------+
| Funcao    | CabCPar                                  | Data | 26.06.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Cabecalho Padrao Cantu. Especifico p/ Romaneio             |
+-----------+----------+-------------------------------------------------+
+-----------+----------+-------------------------------------------------+
| Alterado  | Nome     | Motivo                                          |
+-----------+----------+-------------------------------------------------+
|           |          |                                                 |
+-----------+----------+-------------------------------------------------+
*/
Static Function CabCPar() 
	oPrn:Say(0,0," ",oFont1)							//Inicio
	oPrn:Box(nTM,nLM,nBM,nRM)							//Box q ocupa todo espaco da folha
	oPrn:Box(nTM+1,nLM+1,nBM-1,nRM-1)					//Box adicional p/ aumentar a largura do box acima
 	oPrn:Box(nTM+2,nLM+2,nBM-2,nRM-2)					//Idem
	oPrn:SayBitmap(nRP+15,nCP+15,"lgrl50.bmp",196,94)	//Logo Cantu
    PrintS(2 ,30,"Rel. Venda x Cliente",15)			//Titulo
    DrawH(3,1,84,3)						//Div abaixo do logo
	
    DrawH(3,65,5,2)	
    PrintS(4 ,1 ,"Filial:",2)
    PrintS(5 ,1 ,"Grupo:",2)
    PrintS(6 ,1 ,"Periodo:",2)
    PrintS(4 ,7 ,SM0->M0_Filial,2)
    PrintS(5 ,7 ,MV_Par03,2)
    PrintS(6 ,7 ,"de "+DTOC(MV_Par01)+" ate "+DTOC(MV_Par02),2)
	
    PrintS(4 ,70,"Folha:"  ,2)
    PrintS(5 ,70,"Emissao:",2)
    PrintS(6 ,70,"Hora:"   ,2)
    PrintS(4 ,82,TRANSFORM(nPag,'@E 99'),2)
    PrintS(5 ,77,Dtoc(dDatabase),2)
    PrintS(6 ,77,Time(),2)
    DrawH (6 ,1 ,84,3)

    DrawH (7 ,1 ,84,3)
    DrawH (8 ,1 ,84,3)
    PrintS(8 ,1 ,"NF",12)
    DrawV (7 ,7 ,8 ,2)
    PrintS(8 ,7 ,"CLIENTE",12)
    DrawV (7 ,45,8 ,2)
    PrintS(8 ,45,"LOJA",12)
    DrawV (7 ,50,8 ,2)
    PrintS(8 ,50,"VEND",12)
    DrawV (7 ,56,8 ,2)
    PrintS(8 ,56,"CONDICAO",12)
    DrawV (7 ,71,8 ,2)
    PrintS(8 ,78,"SALDO",12)
    
	nPag   += 1
    nLinha := 9	
Return    

Static Function PrintS(pfRow,pfCol,pfText,pfFont)
	oFont1 := TFont():New( "Verdana"    ,,08,,.F.,,,,,.F. )
	oFont2 := TFont():New( "Verdana"    ,,10,,.F.,,,,,.F. )
	oFont3 := TFont():New( "Verdana"    ,,12,,.F.,,,,,.F. )
	oFont4 := TFont():New( "Verdana"    ,,14,,.F.,,,,,.F. )
	oFont5 := TFont():New( "Verdana"    ,,16,,.F.,,,,,.F. )
	oFont6 := TFont():New( "Courier New",,12,,.F.,,,,,.F. )
	oFont11:= TFont():New( "Verdana"    ,,08,,.T.,,,,,.F. )
	oFont12:= TFont():New( "Verdana"    ,,10,,.T.,,,,,.F. )
	oFont13:= TFont():New( "Verdana"    ,,12,,.T.,,,,,.F. )
	oFont14:= TFont():New( "Verdana"    ,,14,,.T.,,,,,.F. ) 
	oFont15:= TFont():New( "Verdana"    ,,16,,.T.,,,,,.F. )
	oFont16:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )
	Do Case 
		Case pfFont == 1
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont1)
		Case pfFont == 2
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont2)
		Case pfFont == 3				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont3)
		Case pfFont == 4
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont4)
		Case pfFont == 5
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont5)
		Case pfFont == 6
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText, oFont6)
		Case pfFont == 11
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont11)
		Case pfFont == 12
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont12)
		Case pfFont == 13				
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont13)
		Case pfFont == 14		
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont14)
		Case pfFont == 15
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont15)
		Case pfFont == 16
			oPrn:Say(nRP+(nRH*(pfRow-1)),nCP+(nCW*(pfCol-1)),pfText,oFont16)
	EndCase	
Return

Static Function DrawH(dhRow,dhCol,dhWidth,dhPen)
	While dhPen >= 1
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
		dhPen:=dhPen-1
	EndDo
Return

Static Function DrawV(dvRow,dvCol,dvHeight,dvPen) 
	If dvRow==0 	//Ajuste para quando a linha comecar na posicao zero.
		nLineZero:=10
	Else
		nLineZero:=0
	EndIf
	While dvPen >= 1
		oPrn:Line (nRD+(nRH*(dvRow-1))+nLineZero,nCD+(nCW*(dvCol-1))+(dvPen-1),nRD+(nRH*(dvHeight-1)),nCD+(nCW*(dvCol-1))+(dvPen-1) )
		dvPen:=dvPen-1
	EndDo
Return