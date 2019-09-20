#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVALCFOP   บAutor  ณFlavio Dias         บ Data ณ  02/17/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida็ใo de CFOP nas notas de entrada para impedir        บฑฑ
ฑฑบ          ณ que um cfop com inicial 1 seja usado para uma  	    			บฑฑ
ฑฑบ          ณ compra interestadual        																บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ValCFOP()
Local aArea := GetArea()
Local lOk := ParamIXB[1]
Local lCfopOk := .T.
Local i
Local cCod := CA100FOR
//Local cTipo := C100Tipo
Local nPosCfo := aScan(aHeader, { |x| x[2] = "D1_CF"})
Local cUF := MAFISRET(, "NF_UFORIGEM")
Local cCfo
Local cUFEmp := SM0->M0_ESTENT
							// verifica se o arquivo existe  
							
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())							
							
if (lOk)
	for i:= 1 to len(aCols)
  	cCfo := SubStr(aCols[i, nPosCfo], 1, 1)
  	lCfopOK := lCfopOk .And. ((cCfo == "1" .And. cUF == cUFEmp);
  								    .Or. (cCfo == "2" .And. cUf != cUFEmp);
  								    .Or. (cUF == "EX"))
  Next
EndIf

if (!lCfopOK)
  lOk := .F.
  Alert("Verifique o CFOP informado pois estแ incompatํvel com a UF de destino.", "Valida็ใo de CFOP(U_ValCFOP)")
EndIf
RestArea(aArea)
Return lOk