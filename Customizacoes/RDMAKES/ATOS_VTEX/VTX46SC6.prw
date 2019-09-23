#INCLUDE "PROTHEUS.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX46SC6
Ponto de entrada para adicionar campos especÌficos nos itens do pedido de venda.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     21/11/2018
------------- R E V I S Ã O ---------
@author    Douglas F Martins
@version   1.01
@since     27/08/2019
Ajuste para Utilizar TES INTELIGENTE em vez de usar TES Fixa por Estado.
/*/
//------------------------------------------------------------------------------------------
User Function VTX46SC6()

	Local 	aCpos 			:= {}
	//Local	cTES			:= "502"
	Local cTesInt			:= ""
	Local cOperVend			:= SuperGetMV("VV_TINTVND",,"01")
	Local cOperBrnd			:= SuperGetMV("VV_TINTBRD",,"04")

	IF lBrinde
		cTesInt := MaTesInt( 2, cOperBrnd,SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD,NIL)
	Else
		cTesInt := MaTesInt( 2, cOperVend,SA1->A1_COD,SA1->A1_LOJA,"C",SB1->B1_COD,NIL)
	EndIF
	// Se Não achar a TES inteligente, utiliza a antiga REgra por TES Fixa
	IF Empty(cTesInt)
		If SA1->A1_EST <> "SP"
			cTesInt := "511"
		Else
			cTesInt := "502"
		EndIF
	EndIF

	AAdd(aCpos, {"C6_TES"		, cTesInt			, Nil})

Return aCpos