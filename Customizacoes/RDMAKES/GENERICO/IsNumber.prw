#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IsNumber     �Autor  �Flavio Dias      � Data �  02/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar se o conte�do digitado � num�rico.     ���
���          � Chamado nro 1711                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/**************************************************************
 Server para validar se um conte�do � num�rico
 O primeiro par�metro � o conte�do a ser validado
 O segundo par�metro � um flag que indica se ignora espa�os em branco ou n�o
 *************************************************************/
User Function IsNumber(cStr, lEspaco)
Local lNumero := .T.
Local i
Local cMsg := ""      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// Espa�o
if lEspaco
	cStr := AllTrim(cStr)
EndIf

For i := 1 to len(cStr)
  if !(SubStr(cStr, i, 1) $ "1234567890") // se n�o estiver contido neste intervalo � inv�lido
    lNumero := .F.
    Exit
  EndIf
Next i

if !lNumero
  if (lEspaco)
    cMsg := "O conte�do do campo n�o pode conter letras!"
  else
    cMsg := "O conte�do do campo n�o pode conter letras ou espa�os em branco!"
  EndIf
  MsgInfo(cMsg)
EndIf

Return lNumero