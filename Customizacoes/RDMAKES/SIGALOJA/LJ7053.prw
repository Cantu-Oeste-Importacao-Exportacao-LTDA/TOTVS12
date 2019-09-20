#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ LJ7053    ³ Autor ³ Guilherme Poyer        ³ Data ³ 14/02/17³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime outra via do cupom fiscal                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³  LJ7053()                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGALOJA                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function LJ7053()
Local aArray
aArray	:= { { "Imp.Cupom"	, "U_ImpCupom(SL1->L1_NUM)" , 0 , 1 , , .F. }}
Return aArray


User Function ImpCupom(cNum)
Titulo      := "Copia de Cupom"
cDesc1      := "Este programa tem como objetivo emitir copia do Cupom fiscal"
cDesc2      := ""
cDesc3      := ""
cString     := "SL2"
aOrd        := {}
wnrel       := "LJ7053"
lBloqueado  := .F.
cPedidos    := ""
cPerg       := ""
Tamanho     := "P"
aReturn     := { "Normal", 1,"Administracao", 1, 2, 1, "", 1}
nLastKey    := 0     

If nLastKey == 27 .Or. nLastKey == 27
  Return
Endif

nTipo     := 0
nPag      := 1
RptStatus({|| RunReport() }, "Copia do Cupom Fiscal")
Return

/*Local tamanho   := "P"    // P(80c), M(132c),G(220c)
Local nTamanho  := 80
Local nLastKey  := 0
Local cString   := "SL2"  // nome do arquivo a ser impresso
Local titulo    := "CUPOM " + SL1->L1_NUM     
Local m_pag     := 01         // Variavel que acumula numero da pagina       
Local nTipo	  	:= 18
Local cDesc1    := "Este programa irá imprimir um espelho do Cupom Fiscal"  
Private aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1,"",1 }
Private wnrel     := "LJ7053"  // nome do arquivo que sera gerado em disco   
Private nomeprog  := "LJ7053"  

//    wnrel := SetPrint(cString,nomeprog,"",@titulo,cDesc1,"","",.F.,.F.,.F.,tamanho,,.F.)
	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,"","",.T.,"",.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]              

	RptStatus({|| RunReport("","",Titulo,nTamanho,nOrdem) },Titulo)   */
	
Return

*---------------------------------------------------------------------*
Static Function RunReport()
*---------------------------------------------------------------------* 
Private cEol    := CHR(13)+CHR(10)
Private nOrient := 1

Public oFont1 := TFont():New( "Courier New",,08,,.F.,,,,,.F. )
Public oFont2 := TFont():New( "Courier New",,11,,.F.,,,,,.F. )
Public oFont3 := TFont():New( "Courier New",,13,,.F.,,,,,.F. )
Public oFont4 := TFont():New( "Courier New",,16,,.F.,,,,,.F. )
Public oFont5 := TFont():New( "Courier New",,18,,.F.,,,,,.F. )
Public oFont11:= TFont():New( "Courier New",,08,,.T.,,,,,.F. )
Public oFont12:= TFont():New( "Courier New",,12,,.T.,,,,,.F. )
Public oFont13:= TFont():New( "Courier New",,14,,.T.,,,,,.F. )
Public oFont14:= TFont():New( "Courier New",,16,,.T.,,,,,.F. )
Public oFont15:= TFont():New( "Courier New",,18,,.T.,,,,,.F. )

Public oPrn
Public nPag := 1
Public nLin := 0
Public cDescZona := ""

SetPrvt("nLM,nRM,nTM,nBM,nLH,nCW,nLine,nCol,nRP,nCP,nRD,nCD,nLineZero") //nLineZero -> Ajuste para quando a linha comecar na posicao zero.

SETPRC(0,0)
nLM  :=  100	  //Left Margin
nRM  := 2261	  //Right Margin
nTM  :=  100	  //Top Margin
nBM  := 3300	  //Botton Margin
nRH  :=   50	  //Line Height   original:50
nCW  :=   26	  //Character Width
nRow :=    1	  //Linha atual
nCol :=    1	  //Coluna Atual
nRP  := nTM+3	  //Posicao da Primeira Linha Atual
nCP  := nLM+3	  //Posicao da Primeira Coluna Atual
nRD  := nTM+45	//Posicao da Primeira Linha (divisao) Atual
nCD  := nLM+0	  //Posicao da Primeira Coluna (divisao) Atual
nLinha  := 1
nColuna := 1

oPrn:=TMSPrinter():New()
oPrn:setPaperSize( 9 )
if !(oPrn:Setup())
	Return
EndIf
   
nOrient := 1
oPrn:SetPortrait()
oPrn:Say(0,0," ",oFont1)					//Inicio
  
SL2->(DbSeek(xFilial("SL2") + SL1->L1_NUM))    
SA1->(DbSeek(xFilial("SA1") + SL1->L1_CLIENTE + SL1->L1_LOJA))    
SA3->(DbSeek(xFilial("SA3") + SL1->L1_VEND ))   

PrintS(IncLin(2), 00, UPPER(Alltrim(SM0->M0_FILIAL)) + " - " + DtoC(SL1->L1_DTLIM), 3)
//PrintS(IncLin(0), 67, DtoC(SL1->L1_DTLIM), 3)
PrintS(IncLin(1))
     
PrintS(IncLin(1), 00, "Cupom        : " + SL1->L1_NUM, 3)
PrintS(IncLin(1), 00, "Cliente      : " + SL1->L1_CLIENTE + "/" + SL1->L1_LOJA + " - " + AllTrim(SA1->A1_Nome) , 3)
PrintS(IncLin(1), 00, "Nota/Serie   : " + SL1->L1_DOC + " / " + SL1->L1_SERIE, 3)  
PrintS(IncLin(1))
PrintS(IncLin(0), 00, "Vendedor     : " + Alltrim(SL1->L1_VEND), 3)   
PrintS(IncLin(2))
PrintS(IncLin(0), 02, "PRODUTO", 3)  
PrintS(IncLin(0), 24, "DESCRICAO", 3)
PrintS(IncLin(0), 52, "UM", 3)	
PrintS(IncLin(0), 58, "QUANT", 3)
PrintS(IncLin(0), 67, "UNITARIO", 3)
PrintS(IncLin(0), 82, "TOTAL", 3)
   	
SL2->(DbSeek(xFilial("SL2") + SL1->L1_NUM))
nSomaNota := 0
nPesoTotal := 0
nItens    := 1
While SL2->(!Eof()) .And. SL2->L2_FILIAL == xFilial("SL2") .And. SL2->L2_NUM == SL1->L1_NUM  
		PrintS(IncLin(1))
		PrintS(IncLin(0) , 00, PadR(nItens, 02), 2)
		PrintS(IncLin(0) , 02, PadL(SL2->L2_PRODUTO, 10), 2)
		PrintS(IncLin(0) , 14, PadL(SL2->L2_DESCRI, 35), 2)    	   
	   	PrintS(IncLin(0) , 52, PadL(SL2->L2_UM, 02), 2)  
	   	PrintS(IncLin(0) , 54, PadR(Transform(SL2->L2_QUANT,  "@E 999,999.99"), 10), 2) 
    	PrintS(IncLin(0) , 65, PadR(Transform(SL2->L2_VRUNIT, "@E 999,999.99"), 10), 2)
    	PrintS(IncLin(0) , 78, PadR(Transform(SL2->L2_VLRITEM, "@E 999,999.99"), 10), 2)
    	DrawH(IncLin(0), 0, 90, 2)    
		
		nItens := nItens + 1
		nSomaNota 	+= SL2->L2_VLRITEM
		SL2->(DbSkip())
	EndDo
	
	If PRow() >= 53
		oPrn:EndPage()    
   		CabCPar()
	EndIf
	
	IncLin(1) // aumenta duas linhas para o pr?ximo
	PrintS(IncLin(0) , 71, "TOTAL: "+ Transform(nSomaNota, "@E 999,999.99", 10), 2)

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + SL1->L1_VEND))
	IncLin(2) 
	PrintS(IncLin(0) , 00, "Entregador: _____________________________________________________________", 3) 
	IncLin(5)
	PrintS(IncLin(0) , 00, "   Veículo: _____________________________________________________________", 3)     
	
	Set Device To Screen

	FT_PFlush()	
	oPrn:Preview()
	MS_FLUSH()	

Return           

Static Function PrintS(pfRow,pfCol,pfText,pfFont)
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
		oPrn:Line (nRD+(nRH*(dhRow-1))+(dhPen-1) + 2,nCD+(nCW*(dhCol-1)),nRD+(nRH*(dhRow-1))+(dhPen-1),nCD+(nCW*(dhWidth-1)) )
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

Static Function IncLin(n)
	nLinha := nLinha + n
Return nLinha