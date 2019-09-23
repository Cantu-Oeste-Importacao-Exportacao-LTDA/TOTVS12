#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"


User Function F460SE1() 


// Integração Protheus x VTEX - Atos Data Consultoria
	If ExistBlock("ADF460VAL")
		ExecBlock("ADF460VAL", .F., .F.)
	EndIf
	


Return