User Function RETCAIXA()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01
Local _Retorno := " "
Local _Fil     := SE1->E1_FILIAL
//³Funcao    ³ LP520 ³       
//³Descricao ³ Retorna a conta contabil do caixa da filial em questao, a filial e utilizada da tabala SE1    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If _Fil = "01"
   _Retorno := "11100000001"
ElseIf _Fil = "04"
   _Retorno := "11100000004"
ElseIf _Fil = "05"
   _Retorno := "11100000005"
ElseIf _Fil = "06"
   _Retorno := "11100000006"
ElseIf _Fil = "07"
   _Retorno := "11100000007"
ElseIf _Fil = "08"
   _Retorno := "11100000008"
ElseIf _Fil = "09"
   _Retorno := "11100000009"
Endif

_Retorno :=  Posicione("SZ1", 1, xFilial("SZ1")+"0001"+_Fil, "Z1_CONTA")
RETURN(_Retorno)
