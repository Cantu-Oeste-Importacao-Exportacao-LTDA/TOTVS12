#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �E2CODBAR  �Autor  �Gustavo Lattmann    � Data �  22/02/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para valida��o da validade e valor do t�tulo a      ���
���          � partir do c�digo de barras.                                ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function E2CODBAR()

Local lRet := .T.                                                                                           
Local lNext := .T. //No calculo do vencimento real Posterga a data recebida para o pr�ximo dia �til.
Local dDate := CTOD("07/10/97") //Data base considerada pelo Febrabam para calculo do vencimento dos boletos
Local cTexto := ""

If Empty(M->E2_CODBAR)
	Return
EndIf

cBanco	:= Substr(M->E2_CODBAR,1,3)
cVcto   := Substr(M->E2_CODBAR,34,4)
cValor	:= Substr(M->E2_CODBAR,38,8) + "." +Substr(M->E2_CODBAR,46,2)

dVcto := DaySum(dDate, Val(cVcto))    
dVctoReal := DataValida(dVcto,lNext) //E2_VENCTO � sempre igual ao Vencimento Real
 
If dVctoReal != M->E2_VENCREA
	cTexto += "Vencimento real informado n�o confere com vencimento do c�digo de barras. " +CHR(13)+CHR(10)
EndIf    

If Val(cValor) != M->E2_VALOR
	cTexto += "Valor total informado n�o confere com valor total do c�digo de barras. "
EndIf

If !Empty(cTexto)
	Alert(cTexto,"Aten��o!")
EndIf

Return lRet