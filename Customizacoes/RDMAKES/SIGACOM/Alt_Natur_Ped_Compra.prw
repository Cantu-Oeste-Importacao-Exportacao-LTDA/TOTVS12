#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor  ³Flavio Dias         º Data ³  10/14/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada após copiar os itens de um pedido de compraº±±
±±º          ³para alterar a natureza a ser gravada no financeiro         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()

Local nItens     := ParamIxb[1]
Local nPosPed    := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local nPosSeq    := aScan(aHeader, { |x| x[2] = "D1_ITEMPC"})
Local nPosRateio := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"} ) // Alterado pelo Flavio - Guilherme
Local nPosProd	 := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"} )    // Alterado pelo Flavio - Guilherme
Local nPosDesc   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_DESCRI"})
Local i
Local cPedido
Local cItemPC
Local cNatureza  := ""
Local cDesc      := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

// Tratativa Natureza
If (SC7->(FieldPos("C7_NATUREZ")) > 0)
	if (nItens >= 1)  
	  cPedido := aCols[Len(aCols), nPosPed]
	  cItemPC := aCols[Len(aCols), nPosSeq]
	  cNatureza := Posicione("SC7", 01, xFilial("SC7") + cPedido + cItemPC, "C7_NATUREZ")
		if !Empty(cNatureza)	  
	  	MaFisAlt("NF_NATUREZA",cNatureza,)                
	  	Alert("Natureza das duplicatas alterada para " + cNatureza)
	 	EndIf
	EndIf                         
EndIf            

// Tratativa Descrição do Item na importação do pedido de compra.
if Empty(aCols[Len(aCols), nPosDesc])
	cPedido := aCols[Len(aCols), nPosPed]
  cItemPC := aCols[Len(aCols), nPosSeq]
	cDesc   := Posicione("SC7", 01, xFilial("SC7") + cPedido + cItemPC, "C7_DESCRI")
	aCols[Len(aCols), nPosDesc] := cDesc	
EndIf

// Alterado pelo Flavio - Guilherme
/*for i := 1 to Len (aCols)
	if !Empty(aCols[I, nPosProd]) .and. Empty(aCols[I, nPosRateio])
		aCols[i, nPosRateio] := "2"
	EndIf
Next i */
// Alterado pelo Flavio - Guilherme

	/*
		ACERTO DO PESO DO ITEM DO DOCUMENTO
	*/    

	nItem 	  := nItens								  // Posição do item do documento no ato da execução do ponto de entrada      
	nItemSave := n												  // Salva o conteúdo atual de N   
	nPosPeso  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_PESO"   })
	nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_COD" })
	
	N := nItem
	NT	:= POSICIONE("SB1", 1, xFilial("SB1") + SC7->C7_PRODUTO, "B1_PESBRU") * SC7->C7_QUANT 
	aCols[n, nPosPeso] := NT
	M->D1_PESO 				:= aCols[n, nPosPeso]
	MaFisRef("IT_PESO","MT100",aCols[n, nPosPeso])
	n := nItemSave     
	
	
	
Return nil

/*********************************************************************
  Ponto de entrada executado após a gravação das duplicatas no SE2 
  para buscar a forma de pagamento inserida no pedido
 ********************************************************************/
*--------------------------* 
User Function MT100GE2()
*--------------------------*

Local aArea := GetArea()
Local nPosPed := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local cPedido, cFormPag, cDescForma

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³02/06/15 - VALIDA SE FOI CHAMADO PELA FUNÇÃO DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ISINCALLSTACK("U_SCHCLACTE")
    
    /* GUSTAVO 31/08/2016
	// Chama função para inserir o código de barras nas duplicatas, usada em vitorino através do cnab a pagar do BB.
	if SF1->F1_TIPO == "N"
		U_CDBARSE2()
	EndIf
	*/   
	
	//Gustavo 31/08/2016 - Chamar rotina para inclusão de forma de pagamento
	If SF1->F1_TIPO $ "N/C"
		U_PGTOSE2()
	EndIf
	
	/*
	if (SE2->(FieldPos("E2_FORMPAG") > 0))
		cPedido := aCols[Len(aCols), nPosPed]
		// só seta a forma de pagamento quando existir este campo no banco
		if (SE2->(FieldPos("E2_FORMPAG")) > 0)
			cFormPag := Posicione("SC7", 01, xFilial("SC7") + cPedido, "C7_FORMPAG")
		  	// busca do pedido a forma de pagamento informada
		  	SX5->(DbSetOrder(1))
		  	SX5->(DbSeek(cFilial + "24" + cFormPag))
		  	cDescForma := AllTrim(X5Descri())  
		  	if cDescForma <> ""
		    	DbSelectArea("SE2")
		    	RecLock("SE2")
		    	SE2->E2_FORMPAG := cDescForma  
		    	MsUnlock()
		  	EndIf
		  RestArea(aArea)
		EndIf
	EndIf
    */
EndIf
	
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALT_NATUR_PED_COMPRAºAutor  ³Microsiga º Data ³  02/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Faz a gravação do peso do produto após a inclusão da NF    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICOS CANTU                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------*
User Function SD1100I()
*-------------------------*

Local aArea := GetArea()	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

If !ISINCALLSTACK("U_SCHCLACTE")
	
	If (Inclui .or. Altera)
		cProd := SD1->D1_COD
		nQtde := SD1->D1_QUANT
		nPeso := Posicione("SB1", 01, xFilial("SB1") + AllTrim(cProd), 'B1_PESBRU')
		// altera o peso
		RecLock("SD1")
		SD1->D1_PESO := Round(nPeso * nQtde, 2)
		SD1->(MsUnlock())
		
		
		//-- Rafael: 10/02/2011
		//-- Caso seja documento de devolução, irá gravar o segmento, centro de custo e item contábil do documento de origem.
		If SD1->D1_TIPO == "D"
			dbSelectArea("SD2")
			dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM 
			dbGoTop()
			If dbSeek( xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI )				
				If RecLock("SD1",.F.)
					SD1->D1_CLVL    := SD2->D2_CLVL    
					SD1->D1_CC      := SD2->D2_CCUSTO 
					SD1->D1_ITEMCTA := SD2->D2_ITEMCC 
					SD1->(MsUnLock())
				EndIf
			EndIf
		EndIf
		
	EndIf

EndIf
	      
RestArea(aArea)

Return Nil