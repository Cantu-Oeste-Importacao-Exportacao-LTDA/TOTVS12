#include "rwmake.ch"
/*************************************************
 Fun��o gen�rica usada para valida��o de campo, no qual � passado 
 a condi��o na forma de string e a mensagem caso a condi��o retornar 
 falso

 *************************************************/
User Function VldExpr(lOk, cMsg)  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (!lOk)
  MsgAlert(cMsg, "Erro de valida��o")
EndIf
Return  lOk