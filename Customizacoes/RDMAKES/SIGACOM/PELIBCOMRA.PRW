#include "rwmake.ch"
#include "protheus.ch"
// Ponto de entrada no momento de confirmar transferencia para o superior transferir 
User Function MTA097S()
Local lContinua := .T. 
Local aArea := GetArea()

Local cAprovSup := AllTrim(Posicione("SAK", 01, xFilial("SAK") + SCR->CR_APROV, "AK_APROSUP"))
// Necessário fazer isso para que seja enviado email para o supervisor, que será trocado somente após a confirmacão da rotina.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (cAprovSup != "")
  SCR->(RecLock("SCR", .F.))
  SCR->CR_APROV := cAprovSup
  SCR->(MsUnlock())
  
  // envio de email para o superior
  // U_CTMAT11() -- Comentado para não enviar mais workflow de liberação
EndIf
RestArea(aArea)
Return(lContinua)