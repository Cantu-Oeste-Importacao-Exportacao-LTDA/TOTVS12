#Include 'Protheus.ch'


/*/{Protheus.doc} XMLCTE07
(Ponto de entrada Central XML para adicionar mais botões em Ações Relacionadas)
@type function
@author marce
@since 14/06/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function XMLCTE07()
	
	Local	aUsrBtn	:= ParamIxb[1]
	
	Aadd(aUsrBtn,{"PRETO"	,{|| U_RJCOMP1A() }, "Inc. Mapa Cego"})
	Aadd(aUsrBtn,{"PRETO"	,{|| U_RJCOMP1B() }, "Lanc. Mapa Cego"})
		
Return aUsrBtn 
