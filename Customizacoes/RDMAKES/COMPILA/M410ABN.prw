#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} MT461VCT
Executado no cancelamento da inclusão do pedido de venda.
@author Fabio Sales | www.compila.com.br
@since 06/01/2019
@version 1.0
/*/
user function M410ABN()

	Local alArea	:= GetArea()
	
	/*-----------------------------------------------------------------------------\
	| Caso seja o cancelamento de uma inclusão verifica se existe rateio de cartão |
	| para então efetuar a exclusão.                                               |
	\-----------------------------------------------------------------------------*/
	

	DBSELECTAREA("SC5")
	SC5->(DBSETORDER(1))
	
	IF !SC5->(DBSEEK(XFILIAL("SC5") + M->C5_NUM ))
		
		DBSELECTAREA("ZE1")
		ZE1->(DBSETORDER(1))
	
		IF ZE1->(DBSEEK(xfilial("ZE1") + M->C5_NUM ))
		
			WHILE ZE1->(!EOF()) .AND. ZE1->(ZE1_FILIAL + ZE1_PEDIDO) ==  xfilial("SC5") + M->C5_NUM 
							
				RecLock("ZE1", .F.)
	
				ZE1->(dbDelete())
				
				ZE1->(MsUnLock())
		
				ZE1->(DBSKIP())
				
			ENDDO
		
		ENDIF
		
	ENDIF
	
	RestArea(alArea)
return