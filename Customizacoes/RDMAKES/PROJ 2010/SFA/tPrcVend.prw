#include "rwmake.ch"
       
*-----------------------
User Function tPrcVend(cProd)
*-----------------------

Local nPercProd  := 0            
Local cCodProd   := cProd
Local nNovoPreco := M->DA1_PRCVEN
                     
DbSelectArea("SB1")
SB1->(DbSetOrder(1))

if SB1->(DbSeek(xFilial("SB1") + cCodProd))
	nPercProd := SB1->B1_DESCMAX
EndIf

nNovoPreco := nNovoPreco - (( nNovoPreco * nPercProd ) / 100 )

Return nNovoPreco