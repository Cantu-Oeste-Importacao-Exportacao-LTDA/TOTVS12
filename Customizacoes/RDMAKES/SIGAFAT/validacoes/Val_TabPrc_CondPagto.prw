#INCLUDE "rwmake.ch"

/******************************************************************* 
 Valida a tabela de preço de acordo com a condiçao de pagamento, 
 sendo que ao trocar a condiçao de pagamento a tabela também é trocada automaticamente
 Flavio - 10/03/2009
 *******************************************************************/
/* GUSTAVO 05/04/2017 - FUNÇÕES EXCLUSIVAS DA EMPRESA 50 
User Function ValTabPr()
Local lRet := .T.
Local cCond := M->C5_CONDPAG
Local cTabela := M->C5_TABELA
Local cTabReg := ""
cTabReg := Posicione("ACT", 03, xFilial("ACT") + cCond, "ACT_CODTAB")
lRet := Empty(cTabReg) .Or. (cTabReg == cTabela) .Or. (PedOkF11() .And. (cEmpAnt == "50")) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !lRet
	MsgInfo("Deve ser usada a tabela " + cTabReg + " para as vendas com a condição de pagamento " + cCond + "!", "Atenção!")
	M->C5_TABELA := cTabReg
EndIf
Return lRet
*/

/*********************************************************
 Função que retorna se a filial é 11
 ********************************************************/
/* GUSTAVO 05/04/2017 - FUNÇÕES EXCLUSIVAS DA EMPRESA 50
Static Function PedOkF11()
Local lOk := .T.
// Retorna falso se for filial 11 e venda de pneu, senao retorna verdadeiro
if (cFilAnt == "11") .And. (SC5->(FieldPos("C5_TPVENDA")) > 0)
	lOk := (M->C5_TPVENDA != "P") //P = Venda de Pneu
EndIf
Return lOk
*/

/*********************************************************
 Seta o preço de tabela para o produto de acordo com a tabela selecionada
 ********************************************************/
User Function SetPrTab()
nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
nPosPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"}) // para obter qual a posição do campo no acols do preco de venda.
nPosPrUnit := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"}) // para obter qual a posição do campo no acols do preco de tabela.
nPosQtde   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"}) // para obter qual a posição do campo no acols da quantidade vendida.
nPosPrcTab := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCTAB"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
nPosTot    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
nPrUnit	   := 0  // Adriano 31-12-2010 devido a erro quando não encontra tabela de preço.
// Se for Sim3g nao dispara o gatilho, ou se nao for venda de pneus
//if (M->C5_SIM3G) .or. !(SubStr(M->C5_X_CLVL, 1, 3) == "005")
//	Return
//EndIf    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If Type("M->C5_CONDPAG") != "U" .and. M->C5_TIPO == "N" //-- Gustavo 05/04/2017 Validar apenas nas vendas

	cProduto := aCols[N, nPosProduto] // codigo do produto
	
	SE4->(dbSetOrder(01))
	SE4->(dbSeek(xFilial("SE4") + M->C5_CONDPAG))
	nReaj := SE4->E4_REAJUST
	
	DA1->(DbSetOrder(1)) // FILIAL, CODIGO DA TABELA E CODIGO DO PRODUTO
	
	if DA1->(DbSeek(xFilial("DA1") + M->C5_TABELA + cProduto)) //posiciona na tabela de precos	
	
	  if (SubStr(M->C5_X_CLVL, 1, 3) == "005") // Venda de Pneus
			// calcula o valor unitario do item de acordo com o percentual de rajuste aplicado na condicao de pagamento para o pneu
	  	nPrUnit := DA1->DA1_PRCVEN * ( 1 + (nReaj / 100))
	  else
	  	nPrUnit := DA1->DA1_PRCVEN // obtém o valor sem o reajuste
	  EndIf
	                     
	  // Seta o preço unitário
	  aCols[N, nPosPrcVen] := nPrUnit
	  aCols[N, nPosPrUnit] := nPrUnit
	  aCols[N, nPosPrcTab] := nPrUnit
	  aCols[N, nPosTot] := Round(nPrUnit * aCols[N, nPosQtde], 2)
	  
	EndIf

EndIf
	
Return nPrUnit