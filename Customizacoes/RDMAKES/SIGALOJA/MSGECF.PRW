#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSGECF    ºAutor  ³Joel Lipnharski     º Data ³  08/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para imprimir Dados do Cliente no Cupom Fiscal    º±±
±±º          ³ O programa é chamado no parametro MV_LJFISMS com "&"       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Controle de Lojas, FrontLoja                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSGECF()

Local cMsg    
Local cQuebra  := CHR(10)+CHR(13)
Local cCGCCPF  := SPACE(18)	     
Local cCliente := GETMV("MV_CLIPAD")
Local cLoja    := GETMV("MV_LOJAPADD")

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - MSGECF - " + "INICIO")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If SA1->A1_COD+SA1->A1_LOJA <> cCliente+cLoja
	If SA1->A1_PESSOA = "J"
		cCGCCPF := "CNPJ: " + TRANSFORM(SA1->A1_CGC,"@R 99.999.999/9999-99")
	ElseIf SA1->A1_PESSOA = "F"
		cCGCCPF := "CPF:  " + TRANSFORM(SA1->A1_CGC,"@R 999.999.999-99")
	EndIf 
 	cMsg := cQuebra + "NOME: " + SUBSTR(SA1->A1_NOME,1,45) + cQuebra + cCGCCPF
Else
 	cMsg := cQuebra + "NOME: CONSUMIDOR"
EndIf

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - MSGECF - " + "FIM")

Return(cMsg)       