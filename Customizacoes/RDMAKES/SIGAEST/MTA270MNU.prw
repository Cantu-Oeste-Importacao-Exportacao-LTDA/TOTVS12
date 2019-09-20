#Include 'Protheus.ch'

/*/{Protheus.doc} MTA270MNU
Ponto de entrada para gerar opções no menu na rotina de inclusão de inventário. 
@author Tiago.leao
@since 21/08/2015
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/User Function MTA270MNU()
	
	If FindFunction("u_vImpB7")
		aAdd(aRotina,{'Importar Excel','U_VIMPB7',0,3,0 ,NIL})
	EndIf

Return 

