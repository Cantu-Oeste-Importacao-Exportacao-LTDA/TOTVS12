#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"
#include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para manutenção da carga            						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function MCARGAOMS()
Local aArea := GetArea()
Local cFiltro := "DAK_FEZNF == '2'"
Private cCadastro := "Manutenção da Carga"
Private aCores := {}

Private aRotina := { {"Pesquisar"  		,"AxPesqui" 	,0 ,1},;
                     {"Visualizar" 		,"U_MntCRGSC9" 	,0 ,2},;
                     {"Alterar Carga" 	,"U_MntCRGSC9" 	,0 ,4}}

                     
dbSelectArea("DAK")

Set Filter To &cFiltro

mBrowse( 6,1,22,75,"DAK")

dbSelectArea("DAK")
Set Filter To

RestArea(aArea)

Return


User Function MntCRGSC9(cAlias, nReg, nOpc)
Local 	aArea := GetArea()
//Local 	aButtons  := { { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2
Local   cCpos := 	"C9_PEDIDO/C9_CLIENTE/C9_LOJA/A1_NOME/C9_ITEM/C9_PRODUTO/B1_DESC/C9_QTDLIB/C9_QTDNOVA/C9_PRCVEN/C9_LOCAL/C9_CARGA/C9_SEQCAR/C9_SEQENT"
Local   aCpos := StrToKArr(cCpos, "/")
Private aHeader := {}
Private aCOLS := {}
Private oDlg1
Private oGet
Private cAlias	:= "SC9" 
Private cCont := Space(10)
Private oCont
aEmps	:= {}

// Monta o aHeader
dbSelectArea("SX3")
dbSetOrder(2) // Campo
for nX := 1 to len(aCpos)
	If (aCpos[nX] == "C9_QTDNOVA")
		dbSeek("C9_QTDLIB")
		aAdd( aHeader, { Trim( "Qtde Entregar" ),"C9_QTDNOVA",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
	else	
		dbSeek(aCpos[nX])
		aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
	EndIf
//	Endif
Next
//aAdd(aHeader,{"Filial"		,"X6_FIL","@!",2,0,"AllwaysTrue()", "","C","","R"})
aAdd( aHeader, { "Registro","RNO","@E 999999999999",12,0,"","","N","","R"})

SetKey(VK_F7,{||U_OrdemCRG()})
SetKey(VK_F8,{||U_FILCPCRG(1)})
SetKey(VK_F9,{||U_ContaICRG()}) 
SetKey(VK_F10,{||U_MCarCtRat()}) // Conta itens rateados
SetKey(VK_F11,{||U_MCarRAuto()}) // Rateio automático

cSql := "SELECT C9_PEDIDO, C9_CLIENTE, C9_LOJA, A1_NOME, C9_ITEM, C9_PRODUTO, B1_DESC, C9_QTDLIB, C9_QTDLIB AS C9_QTDNOVA,  "
cSql += "C9_PRCVEN, C9_LOCAL, C9_CARGA, C9_SEQCAR, C9_SEQENT, C9.R_E_C_N_O_ AS RNO "
cSql += "FROM "+RetSqlName("SC9")+" C9 LEFT JOIN " + RetSqlName("SA1")+" A1 ON C9.C9_CLIENTE = A1.A1_COD AND C9.C9_LOJA = A1.A1_LOJA "
cSql += "LEFT JOIN " + RetSqlName("SB1") + " B1 ON B1_COD = C9_PRODUTO AND C9.D_E_L_E_T_ = ' ' "
cSql += "WHERE C9.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
cSql += "AND C9.C9_CARGA = '"+DAK->DAK_COD+"' "
cSql += "AND C9.C9_FILIAL = '" + xFilial("SC9")+ "' "
//MemoWrite("d:\sqltemp.txt", cSql)
TCQUERY cSql NEW ALIAS "TMPSC9"
TMPSC9->(dbSelectArea("TMPSC9"))
TMPSC9->(dbGoTop())

// Monta o ACols conforme os dados
While !TMPSC9->(EOF() )
	aLinha := {}
	for nX := 1 to len(aCpos)
		cCpo := aCpos[nX]
		aAdd(aLinha, TMPSC9->(FieldGet(nX)))
	Next
	aAdd(aLinha, TMPSC9->RNO)
	aAdd(aLinha, .F.)
	
	aAdd(aCOLS, aLinha )
		
	TMPSC9->(dbSkip())
End	

DEFINE MSDIALOG oDlg1 TITLE cCadastro From 0,0 To 500, 800 PIXEL OF oMainWnd

@ 010,170 Say OemToAnsi("F7-Ordenar  F8-Filtrar  F9-Contar Todos  F10-Contar Rateados  F11-Rateio Automático")  of oDlg1 PIXEL

oGet := MSGetDados():New(030,1,250,400,nOpc, , .F., "", .T.,{"C9_QTDNOVA"}, , .F., 256,,,, )
oGet:oBrowse:nColPos

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT EnchoiceBar(oDlg1,{|| GrvDados(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() })

If Select("TMPSC9") <> 0
	TMPSC9->(DbCloseArea("TMPSC9"))
Endif
Return

/*Funçao que faz a contagem de quantos itens estão liberados*/
User Function ContaICRG()
Local nx
Local nQuant := 0
Local nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDLIB"})
For nX := 1 to len(aCols)
	if!(aCols[nX, Len(aCols[nX])])
		nQuant += aCols[nX, nPosQtd]
	EndIf
Next nX
MsgInfo("Quantidade de itens: " + AllTrim(Str(nQuant)))
Return 

/*Funçao que faz a contagem da quantidade rateada*/
User Function MCarCtRat()
Local nx
Local nQuant := 0
Local nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDNOVA"})
For nX := 1 to len(aCols)
	if!(aCols[nX, Len(aCols[nX])])
		nQuant += aCols[nX, nPosQtd]
	EndIf
Next nX
MsgInfo("Quantidade rateada de itens: " + AllTrim(Str(nQuant)))
Return

/* Funçao que faz o rateio geral entre os pedidos, solicitando a quantidade a ser liberada e mostrando o que tem solicitado */
User Function MCarRAuto()
Local nx
Local nQuant := 0
Local nQtRat := 0
Local nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDNOVA"})
Local nPosLib := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDLIB"})
Local oDlg1
Local lCont := .F.

For nX := 1 to len(aCols)
	if!(aCols[nX, Len(aCols[nX])])
		nQtRat += aCols[nX, nPosQtd]
		nQuant += aCols[nX, nPosLib]
	EndIf
Next nX

@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importação de Clientes"
// @ 005,005 TO 060,160
@ 010,010 Say "Qtde Liberada: " + Transform(nQuant, "@# 999,999,999.99") PIXEL
@ 022,010 Say "Qtde a Entregar: " PIXEL
@ 020,080 Get nQtRat Size 60, 10 Picture "@# 999,999,999.99" PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION (lCont := .T., Close(oDlg1)) 
@ 065,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER

if (!lCont)
	Return
EndIf

If (nQtRat < nQuant)
	// faz o rateio
	nFator := (nQtRat / nQuant)
	nLib := 0
	// faz o primeiro laço informando um rateio
	For nX := 1 to len(aCols)
		if!(aCols[nX, Len(aCols[nX])])
			aCols[nX, nPosQtd] = Round(nFator * aCols[nX, nPosLib], 0)
			nLib += aCols[nX, nPosQtd]
		EndIf
	Next nX
	                  
	// adiciona o que sobrou do rateio no primeiro item
	if (nLib < nQtRat)
		For nX := 1 to len(aCols)
		  if (nLib == nQtRat)  
		  	Exit
		  EndIf
			if!(aCols[nX, Len(aCols[nX])])
				
				// obtém quantidade atual
				nQtdOld = aCols[nX, nPosQtd]
				
				// adiciona a nova quantidade, respeitando o limite da quantidade liberada			
				aCols[nX, nPosQtd] = Min(aCols[nX, nPosLib], aCols[nX, nPosQtd] + nQtRat - nLib)
				
				// atualiza a diferença
				nLib +=  aCols[nX, nPosQtd] - nQtdOld
			EndIf
		Next nX
	EndIf
EndIf

Return


User Function FILCPCRG(_nOpc)
Local _aCols  := aCols
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos

If nPosis > 0
	cComp	  := aCols[N,nPosis]
	aCols := {}
Endif
If nPosis > 0
	For nR := 1 To Len(_aCols)             
		If _aCols[nR,nPosis] == cComp
			aLinha := _aCols[nR]
			aAdd(aCols,aLinha)
		Endif
	Next nR
Endif
N:= 1
Return nil

// Faz a ordenação das colunas
USER Function OrdemCRG()
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos 

if (nPosis > 0)
	ASort(aCols,,,{ |x,y| x[nPosis] < y[nPosis]})
EndIf     

Return Nil

// Efetua a gravação do pedido
Static Function GrvDados(nOpc)
Local nX 			:= 1
Local nRecDAK 		:= DAK->(RecNo())
Local lTemItem := .F.
Local cPedido := ""
Local nPosPed := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_PEDIDO"})
Local nPosCar := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_CARGA"})
Local nPosSeq := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_SEQCAR"})
Local nPosRat := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDNOVA"})
Local nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "C9_QTDLIB"})
Local nPosRno := len(aHeader)

If nOpc = 3
	DAI->(dbSetOrder(4))
	dbSelectArea("SC9") 
	dbSetOrder(02) // filial + empresa + romaneio + pedido
	aSort(aCols,,,{|x,y| x[nPosPed] < y[nPosPed]})
	cPedido := aCols[1,nPosPed]
	
	// Valida se todos estão ok
	For nX := 1 to len(aCols)
		if (aCols[nX, nPosQtd] < aCols[nX, nPosRat])
			Alert("Quantidade a entregar para o item " + Str(nX) + " é maior que a quantidade liberada.", "Atenção")
			Return
		EndIf       
		If (aCols[nX, nPosRat] <= 0)
			Alert("Quantidade informada inválida. Exclua a linha do item " + Alltrim(Str(nX)))
			Return
		EndIf
	Next nX

	nX := 1
	While nX <= len(aCols)
	  cPedido := aCols[nX, nPosPed]
	  lTemPed := .F.	 
		While nX <= len(aCols) .And. cPedido == aCols[nX, nPosPed]
			if (aCols[nX, len(aCols[nX])]) // se estiver deletado 
				SC9->(dbGoTo(aCols[nX, nPosRno]))
				RecLock("SC9", .F.)
				SC9->C9_CARGA  := Space(Len(SC9->C9_CARGA))
				SC9->C9_SEQCAR := Space(Len(SC9->C9_SEQCAR))
				SC9->C9_SEQENT := Space(Len(SC9->C9_SEQENT))
				SC9->(MsUnlock()) 
				
			Elseif (aCols[nX, nPosRat] < aCols[nX, nPosQtd]) // item foi rateado
				// altera o item atual e inclu uma nova linha
				SC9->(dbGoTo(aCols[nX, nPosRno]))
								
				RecLock("SC9", .F.)
				SC9->C9_QTDLIB  := aCols[nX, nPosRat]
				SC9->C9_QTDLIB2 := convum(SC9->C9_PRODUTO,SC9->C9_QTDLIB,0,2)
				SC9->(MsUnlock())
				
				SC9->(dbGoTo(aCols[nX, nPosRno]))				
				RegToMemory(("SC9"),.F.)
				                   
				// Grava novo registro que informa a quantidade liberada sem amarrar com a carga
				RecLock("SC9", .T.)
				For nF:= 1 to M->(fCount())
					_cCampo := M->(FieldName(nF))
					nPosicao  := SC9->(FieldPos(_cCampo))
					if (nPosicao > 0)
						SC9->(FieldPut(nPosicao, M->&_cCampo)) 
					EndIf
				Next nF                                                            
				                         
				// Aumenta a sequência para não dar duplicidade
				SC9->C9_SEQUEN  := Soma1(SC9->C9_SEQUEN)
				// seta a quantidade nova
				SC9->C9_QTDLIB  := aCols[nX, nPosQtd] - aCols[nX, nPosRat]     
				SC9->C9_QTDLIB2 := convum(SC9->C9_PRODUTO,SC9->C9_QTDLIB,0,2)      
				
				// sobrescreve campos para remover da carga a quantidade que restou
				SC9->C9_CARGA  := Space(Len(SC9->C9_CARGA))
				SC9->C9_SEQCAR := Space(Len(SC9->C9_SEQCAR))
				SC9->C9_SEQENT := Space(Len(SC9->C9_SEQENT))
				SC9->(MsUnlock())
			EndIf			
			
			/* @aqui
			nX++
			DAI->(dbSeek(xFilial("DAI")+aCols[nX-1, nPosPed]+DAK->DAK_COD))
			if (nX > Len(aCols) .OR. !(cPedido == aCols[nX, nPosPed])) .And. !lTemPed
				// Pedido foi excluído totalmente				
			*/ 				
			nX++
		EndDo
	EndDo
	
	// Faz o recálculo da carga e também de cada pedido (DAI)
	nPesoCrg := 0
	nValCrg := 0
	SB1->(dbSetOrder(01))
	SC9->(dbSetOrder(01))
	DAI->(dbSetOrder(01))
	DAI->(dbSeek(xFilial("DAI")+DAK->DAK_COD))
	
	While DAI->DAI_FILIAL+DAI->DAI_COD == DAK->DAK_FILIAL+DAK->DAK_COD
		cPedido := DAI->DAI_PEDIDO
		nPesoPed := 0
		SC9->(dbSeek(xFilial("SC9")+DAI->DAI_PEDIDO))
			While DAI->DAI_FILIAL+DAI->DAI_PEDIDO==SC9->C9_FILIAL+SC9->C9_PEDIDO
				if SC9->C9_CARGA == DAI->DAI_COD						
					SB1->(dbSeek(xFilial("SB1")+SC9->C9_PRODUTO))
									
					nPesoPed += SC9->C9_QTDLIB * SB1->B1_PESBRU
					nPesoCrg += SC9->C9_QTDLIB * SB1->B1_PESBRU
					nValCrg += SC9->C9_QTDLIB * SC9->C9_PRCVEN
				EndIf
				SC9->(dbSkip())
			EndDo		
		
		RecLock("DAI", .F.)
		DAI->DAI_PESO = nPesoPed // atribui o peso que restou do pedido
		DAI->(MsUnlock())
		
		DAI->(dbSkip())
	EndDo
	
	if nPesoCrg > 0
		RecLock("DAK", .F.)
		DAK->DAK_PESO = nPesoCrg	
		DAK->DAK_VALOR = nValCrg
		DAK->(MsUnlock())
	EndIf   
	
	
	
EndIf

ODlg1:End()

Return .F.

// Função que apenas adiciona uma tecla de atalho para contar quais pedidos estão ok.
User Function DL200BRW()
Local aRet := PARAMIXB
SetKey(VK_F9,{||U_OMSQtdPed()})
Return aRet

/*********************************************
 Função que faz a contagem dos diferentes pedidos da carga
 *********************************************/
User Function OMSQtdPed()
Local nPosRec := TRBPED->(RecNo())
Local aArea := GetArea()
Local nCont := 0
Local aPed := {}

TRBPED->(dbGoTop())
dbSelectArea("TRBPED")
While TRBPED->(!Eof())
	
	if (IsMark("PED_MARCA", ThisMark(), ThisInv()))
		if aScan(aPed, {|x| x=TRBPED->PED_PEDIDO}) = 0
			nCont++
			aAdd(aPed, TRBPED->PED_PEDIDO)
		EndIf
		
	EndIf
	
	TRBPED->(dbSkip())	
EndDo
MsgInfo("Pedidos Selecionados: " + Trim(Str(nCont)))
TRBPED->(dbGoTo(nPosRec))
RestArea(aArea)
Return

