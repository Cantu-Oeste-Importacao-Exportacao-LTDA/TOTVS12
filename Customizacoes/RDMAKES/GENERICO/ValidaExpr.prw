#include "rwmake.ch"
/*************************************************
 Função genérica usada para validação de campo, no qual é passado 
 a condição na forma de string e a mensagem caso a condição retornar 
 falso

 *************************************************/
User Function VldExpr(lOk, cMsg)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (!lOk)
  MsgAlert(cMsg, "Erro de validação")
EndIf
Return  lOk