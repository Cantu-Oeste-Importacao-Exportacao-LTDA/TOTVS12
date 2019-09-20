// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : VTX46FIM
// ---------+---;----------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 07/01/18 | Adriano R. Ribeiro| Ponto de entrada para adicionar campos específicos no 
//          |                   | cabeçalho do pedido de venda.
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX46SC5
Ponto de entrada para adicionar campos específicos no cabeçalho do pedido de venda.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     07/01/2018
/*/
//------------------------------------------------------------------------------------------
User Function VTX46FIM()
	
	Local cVend			:= ""
	
	Do Case
	
		Case cAffiliateId == "BWW"
			cVend := "L00009"
		
		Case cAffiliateId == "CNV"
			cVend := "L00010"
			
		Case Empty (cAffiliateId)
			cVend := "000059"	
			
	EndCase
		
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_VEND1 	:= cVend
	MsUnlock("SC5")
	
		
Return 