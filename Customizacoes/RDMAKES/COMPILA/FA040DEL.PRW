#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.ch"


/*/{Protheus.doc} FA040DEL
APÓS EXCLUSAO DO TITULO NO CR
@author Augusto Ribeiro | www.compila.com.br
@since 24/04/2019
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function FA040DEL ()
Local aE1Area 	:= GetArea("SE1")
Local aArea 	:= GetArea()


/*--------------------------------------
 \/ CP11 - Baixa Cartao de Credito
-----------------------------------------*/
U_CP11ESTF("SE1", SE1->(RECNO()),, SE1->E1_VALOR)
/*--------------------------------------
 /\ CP11 - Baixa Cartao de Credito
-----------------------------------------*/


restArea(aE1Area)
restArea(aArea)
Return 


