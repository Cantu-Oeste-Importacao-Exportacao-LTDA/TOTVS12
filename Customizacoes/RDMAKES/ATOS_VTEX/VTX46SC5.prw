// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : VTX46SC5
// ---------+---;----------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/11/18 | Adriano R. Ribeiro| Ponto de entrada para adicionar campos específicos no 
//          |                   | cabeçalho do pedido de venda.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX46SC5
Ponto de entrada para adicionar campos específicos no cabeçalho do pedido de venda.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     21/11/2018
/*/
//------------------------------------------------------------------------------------------
User Function VTX46SC5()
	
	Local aArea			:= GetArea()
	Local aCpos 		:= {}
	Local cClvl			:= SuperGetMV ("VT_VVNCLVL", ,"003001001")
	Local cVend			:= ""
	local cCentroC		:= SuperGetMV ("VT_CENCUST", ,"020202001")
	local _cCodAdm		:= SuperGetMV ("VT_VVCODAD", ,"005")
	
	If Empty(cMktPlcId)
		cVend := "000059"
	Else
		cVend := "L00009"
	EndIf
	
	AAdd(aCpos, {"C5_X_CLVL"	, cClvl		, Nil}) 
	AAdd(aCpos, {"C5_VEND1"		, cVend		, Nil})
	AAdd(aCpos, {"C5_X_CC"		, cCentroC	, Nil})
	AADD(aCpos, {"C5_XCODAUT"   , cAuthId  	, Nil})
	AADD(aCpos, {"C5_XCODADQ"  	, _cCodAdm  	, Nil})
	
	
	RestArea(aArea)
	
Return aCpos