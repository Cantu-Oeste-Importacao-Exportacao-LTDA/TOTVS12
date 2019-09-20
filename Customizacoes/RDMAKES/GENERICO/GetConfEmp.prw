User Function GetConfEmp(cCampo, cValPad) 
Local cRet := cValPad
dbSelectArea("SZU")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if SZU->(FieldPos(cCampo)) = 0
	Alert("Configuracao de " + cCampo + " não efetuada.")
	Return cRet
EndIf
dbSetOrder(01)
if dbSeek(xFilial("SZU") + cFilAnt)
  cRet := SZU->&cCampo
elseif dbSeek(xFilial("SZU") + "  ")
	cRet := SZU->&cCampo
EndIf
Return cRet