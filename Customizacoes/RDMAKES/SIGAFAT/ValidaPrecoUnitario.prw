#include "rwmake.ch" 
/*******************************************************/
// Fun��o para valida��o do pre�o unit�rio do pedido, impendindo que o mesmo fique abaixo do pre�o de desconto m�ximo
// Criado por Flavio Dias em 28/08/2008
/*******************************************************/
User Function VldPrUni(lZera)
Local nValor := 0
Local nPosPrcVen := 0
Local nPosPrUnit := 0
Local nPosProd := 0
Local nPosTot := 0
Local nPosQtde := 0
Local nPosPrcSu := 0
Local nPrecoProd, nPrecoTab, nDesMax
nPosPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"}) // para obter qual a posi��o do campo no acols do preco de venda.
nPosProd := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"}) // para obter qual a posi��o do campo no acols do c�digo do produto.
nPosTot := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"}) // para obter qual a posi��o do campo no acols do valor do produto.
nPosQtde := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"}) // para obter qual a posi��o do campo no acols da quantidade do produto.
nPosPrcSu := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCSU"}) // para obter qual a posi��o do campo no acols do preco da segunda unidade.
nValor := aCols[n, nPosPrcVen]
nPrecoProd := nValor
nDesMax := Posicione('SB1', 01, xFilial('SB1') + AllTrim(aCols[n, nPosProd]), 'B1_DESCMAX')
DbSelectArea("DA1") 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if DbSeek(xFilial("DA1") + M->C5_TABELA + AllTrim(aCols[n, nPosProd])) //posiciona na tabela de precos
	nPrecoTab := DA1->DA1_PRCVEN // para obter o valor de tabela
Else
	nPrecoTab := 0
EndIf
if (nPrecoTab > 0) .And. (((1- (nPrecoProd / nPrecoTab)) * 100) > nDesMax)
	nValor := iif(lZera, 0, nPrecoTab)
	if (lZera)
	  aCols[n, nPosPrcSu] := 0
	EndIf
	aCols[n, nPosTot] := nValor * aCols[n, nPosQtde]
	Alert("Pre�o para o produto " + AllTrim(nPrecoTab) + " est� abaixo do m�nimo permitido!")
Endif
Return nValor