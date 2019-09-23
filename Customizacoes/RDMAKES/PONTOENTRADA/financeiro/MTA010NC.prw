// #########################################################################################
// Projeto: VTEX
// Modulo : Integração E-Commerce
// Fonte  : MTA010NC
// Cliente: Vivavinho
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 12/12/18 | Adriano R Ribeiro | 
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} MTA010NC


@author    Adriano Ramos Ribeiro
@version   1.xx
@since     23/07/2018
/*/
//------------------------------------------------------------------------------------------
User Function MTA010NC()
	
			// Integração Protheus x VTEX - Atos Data Consultoria
	If ExistBlock("ADMTA010NC")
		ExecBlock("ADMTA010NC", .F., .F.)
	EndIf
	
Return 