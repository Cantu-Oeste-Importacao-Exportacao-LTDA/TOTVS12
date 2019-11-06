// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : VTX46SC5
// ---------+-------------------+-----------------------------------------------------------
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
	Local cClvl			:= SuperGetMV ("VT_VVNCLVL", , "003001001")
	Local cCentroC		:= SuperGetMV ("VT_CENCUST", , "020202001")
	Local cVend1		:= cVendedor	// cVendedor = Variável Private gravada no pedido (C5_VEND1)
	local _cCodAdm		:= SuperGetMV ("VT_VVCODAD", ,"005")
	
	
	Do Case
		Case cAffiliateId == "BWW"
			cVend1 := "L00016"
		Case cAffiliateId == "CNV"
			cVend1 := "L00010"
		Case cAffiliateId == "MLB"
			cVend1 := "L00017"
		Case cAffiliateId == "MZL"
			cVend1 := "L00014"
		Case Empty(cAffiliateId)
			cVend1 := "000059"
		OtherWise
			cVend1 := "L00009"
	EndCase
	
	// cVendedor = Variável Private gravada no pedido (C5_VEND1)
	cVendedor 	:= cVend1
	
	AAdd(aCpos, {"C5_X_CLVL"	, cClvl		, Nil}) 
	AAdd(aCpos, {"C5_X_CC"		, cCentroC	, Nil})
	AAdd(aCpos, {"C5_XCODAUT"   , cAuthId  	, Nil})
	AAdd(aCpos, {"C5_XCODADQ"  	, _cCodAdm  , Nil})
		
	RestArea(aArea)
	
Return aCpos