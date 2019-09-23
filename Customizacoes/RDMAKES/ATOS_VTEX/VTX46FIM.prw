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
		
	If Empty(cMktPlcId)
		cVend := "000059"
	Else
		cVend := "L00009"
	EndIf
	
	DbSelectArea("SC5")
	RecLock("SC5",.F.)
	SC5->C5_VEND1 	:= cVend
	MsUnlock("SC5")
	
		
Return 