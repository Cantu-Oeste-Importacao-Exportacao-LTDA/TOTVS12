#INCLUDE "rwmake.ch"
#include "topconn.ch" 

User Function RJU026()
Local oDlg
Local aCA:={OemToAnsi("Confirma"),OemToAnsi("Abandona")}
Local cCadastro := OemToAnsi("Saldo por Vendedor")
Local aSays:={}, aButtons:={}
Local nOpca := 0
Private aReturn  := {OemToAnsi('Zebrado'), 1,OemToAnsi('Administracao'), 2, 2, 1, '',1 }
Private nLastKey := 0
Private cPerg    := "RJU026"
Private cCodEmp  := ""
Private cNumBco  := ""

SetPrvt("aCA,CCADASTRO,ASAYS,ABUTTONS,NOPCA,ARETURN")
SetPrvt("NLASTKEY,CPERG")
SetPrvt("OFONT1,OFONT2,OFONT3,OFONT4,OFONT5,OFONT11,OFONT12,OFONT13,OFONT14,OFONT15")
SetPrvt("OPRN,NTPAG")

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.
SetPrvt("nLinha,nColuna")

SetPrvt("NTIPO,ADBF,CARQ,CARQIND,CENTREGA")
SetPrvt("cAux,TOT,TOTSLD,VendAnt") 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())
                                  
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
Local xCodEmp := "50"  // Empresa 
Local xCodFil := "01"  // Filial 

Public oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0

	oPrn:=TMSPrinter():New()
	oPrn:SetPortrait() // ou SetLandscape()
	oPrn:SetPage(9)	//Folha A4
	oPrn:Setup()
	CabcPar()
	nLinha:=9
    
	cQuery := "SELECT C5_NUM AS PEDIDO, C5_VEND1 AS VENDEDOR, SA3.A3_NOME AS VENDNAME, C5_SLDSFA AS SALDO FROM SC5500 AS SC5 INNER JOIN SA3500 AS SA3 ON SC5.C5_VEND1=SA3.A3_COD WHERE SC5.C5_EMISSAO BETWEEN '"
	cQuery += DtOs(MV_PAR01)+"' AND '"+DtOs(MV_PAR02)+"' AND SC5.C5_VEND1 BETWEEN '"
	cQuery += MV_PAR03+"' AND '"+MV_PAR04+"' AND SC5.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' ORDER BY A3_NOME, PEDIDO"
	TCQUERY cQuery NEW ALIAS "TMPSLD"
	MEMOWRITE("SLDVNDA.SQL",CQUERY)			
	dbSelectArea("TMPSLD")
	
	ProcRegua(TMPSLD->(LastRec()))
	dbGoTop()
	TOT    := 0
	TOTSLD := 0	
	If TMPSLD->(!Eof())
		VendAnt:="00.000"
	EndIf
	While TMPSLD->(!Eof())
		//conout(TMPSLD->VENDEDOR+" - "+TMPSLD->VENDNAME)
        If VendAnt!=TMPSLD->VENDEDOR 
        	VendAnt:=TMPSLD->VENDEDOR 
			cQuery := "SELECT SUM(C6_VALOR) AS VENDIDO FROM SC6500 AS SC6 WHERE SC6.C6_NUM='"
			cQuery += TMPSLD->PEDIDO+"' AND SC6.D_E_L_E_T_ <> '*'
			TCQUERY cQuery NEW ALIAS "TMPVND"
			MEMOWRITE("SLDVNDB.SQL",CQUERY)
			dbSelectArea("TMPVND")	
			
			Processa({||PrintS(nLinha ,1 ,TMPSLD->VENDEDOR,3 )})
			Processa({||PrintS(nLinha ,8 ,TMPSLD->VENDNAME,3 )})
			Processa({||PrintS(nLinha ,62,TRANSFORM(TMPVND->VENDIDO,'@E 999,999.99'),3 )}) 
			Processa({||PrintS(nLinha ,74,TRANSFORM(TMPSLD->SALDO,'@E 999,999.99'),3 )})
			Processa({||DrawH(nLinha,1 ,84,2)})
			Processa({||DrawV(nLinha-1,8 ,nLinha,2)})
			Processa({||DrawV(nLinha-1,59,nLinha,2)})
			Processa({||DrawV(nLinha-1,72,nLinha,2)})
			TOTSLD += TMPSLD->SALDO
			TOT    += TMPVND->VENDIDO
			nLinha += 1
			TMPVND->(dbCloseArea())
		EndIf
		TMPSLD->(DbSkip())
		IncProc()
	End
	
	Processa({||DrawV(nLinha-1,8 ,nLinha,2)})
    Processa({||PrintS(nLinha ,1 ,"TOTAL",13 )})
	Processa({||PrintS(nLinha ,62,TRANSFORM(TOT,'@E 999,999.99'),3 )}) 
	Processa({||PrintS(nLinha ,74,TRANSFORM(TOTSLD,'@E 999,999.99'),3 )})
   	Processa({||DrawV(nLinha-1,59,nLinha,2)})
   	Processa({||DrawV(nLinha-1,72,nLinha,2)})	
   	Processa({||DrawH(nLinha,1 ,84,2)})
	
	TMPSLD->(dbCloseArea())
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
	Processa({||PrintS(2 ,30,"Rel. de Saldo por Vendedor",15)})			//Titulo
	Processa({||DrawH(3,1,84,3)})						//Div abaixo do logo
	Processa({||DrawV(0,10,3,3)})						//div ao lado do logo
	
	Processa({||DrawH(3,65,5,2)})	
	Processa({||PrintS(4 ,1 ,"Filial:",3)})
	Processa({||PrintS(5 ,1 ,"Vendedor:",3)})
	Processa({||PrintS(6 ,1 ,"Periodo:",3)})
	Processa({||PrintS(4 ,10,SM0->M0_Filial,3)})
	Processa({||PrintS(5 ,10,"de "+MV_Par03+" ate "+MV_Par04,3)})
	Processa({||PrintS(6 ,10,"de "+DTOC(MV_Par01)+" ate "+DTOC(MV_Par02),3)})
	
	Processa({||PrintS(4 ,59,"Folha:"  ,3)})
	Processa({||PrintS(5 ,59,"Emissao:",3)})
	Processa({||PrintS(6 ,59,"Hora:"   ,3)})
	Processa({||PrintS(4 ,81,TRANSFORM(nPag,'@E 999'),3)})
	Processa({||PrintS(5 ,76,Dtoc(dDatabase),3)})
	Processa({||PrintS(6 ,76,Time(),3)})
    Processa({||DrawV (3 ,72,6 ,2)})
    Processa({||DrawH (6 ,1 ,84,3)})

	Processa({||DrawH (7 ,1 ,84,3)})
	Processa({||DrawH (8 ,1 ,84,3)})
	Processa({||PrintS(8 ,1 ,"CODIGO",13)})
	Processa({||DrawV (7 ,8 ,8 ,2)})
    Processa({||PrintS(8 ,8 ,"VENDEDOR",13)})
	Processa({||DrawV (7 ,59,8 ,2)})
    Processa({||PrintS(8 ,59,"VENDIDO",13)})
	Processa({||DrawV (7 ,72,8 ,2)})
    Processa({||PrintS(8 ,79,"SALDO",13)})
	
    Processa({||DrawH (60,1 ,84,3)})
    
	nPag += 1
Return    

Static Function PrintS(pfRow,pfCol,pfText,pfFont)
	oFont1 := TFont():New( "Verdana",,08,,.F.,,,,,.F. )
	oFont2 := TFont():New( "Verdana",,10,,.F.,,,,,.F. )
	oFont3 := TFont():New( "Verdana",,12,,.F.,,,,,.F. )
	oFont4 := TFont():New( "Verdana",,14,,.F.,,,,,.F. )
	oFont5 := TFont():New( "Verdana",,16,,.F.,,,,,.F. )
	oFont11:= TFont():New( "Verdana",,08,,.T.,,,,,.F. )
	oFont12:= TFont():New( "Verdana",,10,,.T.,,,,,.F. )
	oFont13:= TFont():New( "Verdana",,12,,.T.,,,,,.F. )
	oFont14:= TFont():New( "Verdana",,14,,.T.,,,,,.F. ) 
	oFont15:= TFont():New( "Verdana",,16,,.T.,,,,,.F. )
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