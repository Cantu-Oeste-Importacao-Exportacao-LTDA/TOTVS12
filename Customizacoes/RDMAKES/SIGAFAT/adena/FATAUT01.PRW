#include "protheus.ch"
#include "rwmake.ch"

User function FATAUT01()

Local cAliasTmp := "ZX5"
Local cPrograma := OemToAnsi("Cadastro de Parâmetros Fat. Automatico")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

AxCadastro(cAliasTmp, cPrograma)

Return
