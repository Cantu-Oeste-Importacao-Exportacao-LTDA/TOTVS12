#include "protheus.ch"
#include "topconn.ch"
#include "rwmake.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³E2CODBAR  ºAutor  ³Gustavo Lattmann    º Data ³  22/02/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para validação da validade e valor do título a      º±±
±±º          ³ partir do código de barras.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 11                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function E2CODBAR()

Local lRet := .T.                                                                                           
Local lNext := .T. //No calculo do vencimento real Posterga a data recebida para o próximo dia útil.
Local dDate := CTOD("07/10/97") //Data base considerada pelo Febrabam para calculo do vencimento dos boletos
Local cTexto := ""

If Empty(M->E2_CODBAR)
	Return
EndIf

cBanco	:= Substr(M->E2_CODBAR,1,3)
cVcto   := Substr(M->E2_CODBAR,34,4)
cValor	:= Substr(M->E2_CODBAR,38,8) + "." +Substr(M->E2_CODBAR,46,2)

dVcto := DaySum(dDate, Val(cVcto))    
dVctoReal := DataValida(dVcto,lNext) //E2_VENCTO é sempre igual ao Vencimento Real
 
If dVctoReal != M->E2_VENCREA
	cTexto += "Vencimento real informado não confere com vencimento do código de barras. " +CHR(13)+CHR(10)
EndIf    

If Val(cValor) != M->E2_VALOR
	cTexto += "Valor total informado não confere com valor total do código de barras. "
EndIf

If !Empty(cTexto)
	Alert(cTexto,"Atenção!")
EndIf

Return lRet