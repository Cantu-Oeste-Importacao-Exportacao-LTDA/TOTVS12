// #########################################################################################
// Projeto: VTEX
// Modulo : Integra��o E-Commerce
// Fonte  : VTX47SA1
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 21/11/18 | Adriano R. Ribeiro| Ponto de entrada para adicionar campos espec�ficos no 
//          |                   | cadastro do cliente
// ---------+-------------------+-----------------------------------------------------------

#INCLUDE "PROTHEUS.CH"


//------------------------------------------------------------------------------------------
/*/{Protheus.doc} VTX47SA1
Ponto de entrada para adicionar campos espec�ficos no cadastro do cliente.

@author    Adriano Ramos Ribeiro
@version   1.xx
@since     21/11/2018
/*/
//------------------------------------------------------------------------------------------
User Function VTX47SA1()
	
	//------------------------------------------------------------------------
	// Vari�veis de escopo Private declaradas na integra��o que n�o devem ser alteradas
	//------------------------------------------------------------------------
	// _cNomCli, _cTel, _cEmail, _cEst, _cIE, cNaturez, cTpFrete
	//------------------------------------------------------------------------
	Local 	aCpos 		:= {}
    Local	cPais		:= "105"	// Brasil
    Local 	cCodPais	:= "01058"	// Brasil
    Local	cNaturez	:= SuperGetMV("VT_VVNNAT", ,"1012001") // Natureza Ecommerce
    
    //-------------------------------------------------------------------
    // Campos que ser�o inclu�dos no array para a rotina MATA030
    //------------------------------------------------------------------- 	
	
	AAdd(aCpos, {"A1_PAIS"		, cPais		,	Nil} )
	AAdd(aCpos, {"A1_CODPAIS"	, cCodPais	,	Nil} )
	AAdd(aCpos, {"A1_X_SERAS"	, "N"		,	Nil} )
	AAdd(aCpos, {"A1_NATUREZ"	, cNaturez	,	Nil} )
	
Return aCpos