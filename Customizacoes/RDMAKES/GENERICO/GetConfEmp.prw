User Function GetConfEmp(cCampo, cValPad) 
Local cRet := cValPad
dbSelectArea("SZU")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

if SZU->(FieldPos(cCampo)) = 0
	Alert("Configuracao de " + cCampo + " n�o efetuada.")
	Return cRet
EndIf
dbSetOrder(01)
if dbSeek(xFilial("SZU") + cFilAnt)
  cRet := SZU->&cCampo
elseif dbSeek(xFilial("SZU") + "  ")
	cRet := SZU->&cCampo
EndIf
Return cRet