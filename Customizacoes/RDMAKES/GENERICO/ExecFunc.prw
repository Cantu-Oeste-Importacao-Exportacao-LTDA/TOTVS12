#Include "Protheus.ch"
#include "rwmake.ch"
User Function ExecFunc()
Local cFiltro := ""
Local cFuncao := Space(15)
Local oDlg1        

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

// faz a tela para pedir a selecao de um cliente
@ 200, 1 To 300, 410 Dialog oDlg1 Title "Informe a fun豫o abaixo para ser executada"
@ 20,  10 Say "Fun豫o:"
@ 20,  50 Get cFuncao  
@ 80, 60 BmpButton TYPE 01 Action Close(oDlg1)
Activate Dialog oDlg1 Centered

if !Empty(cFuncao)
 &cFuncao  // executa a fun豫o
EndIf
Return Nil