#include "rwmake.ch"
#include "protheus.ch"
/******************************************************************
 Função para limpar as strings erradas de um campo de determinada tabela,
 devido a dar erro no processamento de dados do sped.
 *****************************************************************/
User Function LimpaCmp()
Local cPerg := PadR("LIMCMP", Len(SX1->X1_GRUPO))
Local aArea := GetArea()
Local cAlias := "", cCampo := ""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1(cPerg)

If Pergunte(cPerg)

	cAlias := AllTrim(MV_PAR01)
	cCampo := AllTrim(MV_PAR02)
	Processa({|lEnd| RunProc(@lEnd, cAlias, cCampo)}, "Aguarde...", "Ajustando campos.", .T.)
	
EndIf
RestArea(aArea)
Return Nil                                             


/******************************************************
 Função que faz o processamento dos dados
 ****************************************************/
Static Function RunProc(lEnd, cAlias, cCampo)
Local nReg
Local cNewStr := "", cOldStr := ""

dbSelectArea(cAlias)
dbGoTop()
nReg := (cAlias)->(RecCount())
ProcRegua(nReg)

While !(cAlias)->(Eof()) .And. (!lEnd)
	cOldStr := (cAlias)->&cCampo
	cNewStr := RetStrOk(cOldStr)
	if cOldStr != cNewStr
		RecLock(cAlias, .F.)
		(cAlias)->&cCampo := cNewStr
		MsUnlock()
	EndIf
	dbSkip()
	IncProc("Atualizado registro " + AllTrim(Str((cAlias)->(RecNo()))) + " de " + AllTrim(Str(nReg)))
EndDo

nRegs := (cAlias)->(RecCount())
Return Nil


/************************************************
 Função que limpa a string em relação a caracteres inválidos
 ***********************************************/ 
Static Function RetStrOk(cStr)
Local cStrOk := ""
Local cChar
Local i
cStr := cStr
For i:= 1 to len(cStr)
	if (Upper(Substr(cStr, i, 1)) $	" ABCDEFGHIJKLMNOPQRSTUVXZWKY01234567890-=*+.,;:(){}[]")
		cStrOk += Substr(cStr, i, 1)
	elseif Substr(cStr, i, 1) == "&"
	  cStrOk += "E"
	else
	  cStrOk += " "
	EndIf
Next i
Return cStrOk

Static function AjustaSX1(cPerg)
PutSx1(cPerg,"01","Tabela ?","Tabela ?","Tabela ?", "mv_tab", "C", 3, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Campo ?","Campo ?","Campo ?", "mv_cmp", "C", 10, 0, ,"G", "", "", "", "","MV_PAR02")
Return Nil