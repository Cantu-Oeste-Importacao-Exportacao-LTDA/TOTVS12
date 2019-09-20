#Include "Protheus.ch"

//-----------------------------------------------------------------------
/*/{Protheus.doc} OM040TOK
Efetua Validação de Campos necessários para Integração Target.

@author Davis Magalhães
@since  30/01/2013
@version 1.0

@param  N/H

@return Logico (.T. ou .F.)
/*/


User Function OM040TOK()

Local lRet        := .T.
//Local aArealOK    := GetArea()

Local cTipoTrp    := Posicione("SA2",1,xFilial("SA2")+M->DA4_FORNEC+M->DA4_LOJA,"A2_TIPOTRP")

If M->DA4_TIPMOT <> "1"
	If Empty(M->DA4_FORNEC)       
	   HelpInDark(.T.)
		Help( '',1,'DVM_00001'  ) 
		HelpInDark(.F.) 
	
	   //Help(
		//Aviso("TOTVS - TARGET","Por se Tratar de um motorista "+Iif(M->DA4_TIPMOT =="2","TERCEIRO","AGREGADO")+", favor preencher os Campos Cod e Loja Fornecedor.",{"Voltar"},2,"Integração Protheus X Target")
		lRet := .F.
	EndIf
EndIf



//RestArea(aArealOk)

Return(lRet)
         
