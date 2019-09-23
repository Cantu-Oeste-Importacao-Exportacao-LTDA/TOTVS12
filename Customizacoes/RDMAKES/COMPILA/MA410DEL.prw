#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MA410DEL
Executado na exclusão do pedido de venda.
@author Fabio Sales | www.compila.com.br
@since 06/01/2019
@version 1.0
/*/
user function MA410DEL()

	Local alAreaZE1	:= ZE1->(GetArea())
	
	DBSELECTAREA("ZE1")
	ZE1->(DBSETORDER(1))

	IF ZE1->(DBSEEK(xfilial("ZE1") + SC5->C5_NUM ))
	
		WHILE ZE1->(!EOF()) .AND. ZE1->(ZE1_FILIAL + ZE1_PEDIDO) ==  xfilial("SC5") + SC5->C5_NUM 
						
			RecLock("ZE1", .F.)

			ZE1->(dbDelete())
			
			ZE1->(MsUnLock())
	
			ZE1->(DBSKIP())
			
		ENDDO
	
	ENDIF
	
	RestArea(alAreaZE1)
			
return