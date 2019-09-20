#include "rwmake.ch" 
//+--------------------------------------------------------------------+
//| Rotina | CadGerente | Autor| Gustavo Lattmann  | Data | 23.12.2013 |
//+--------------------------------------------------------------------+
//| Descr. | Amarração de gerente com o segmento                       |
//+--------------------------------------------------------------------+
//| Uso    |Cantu Geral - BI - Apurração Contábil                      |
//+--------------------------------------------------------------------+
User Function CadGerente()
Local cCadastro := "Cadastro de Gerentes"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AxCadastro("Z63",cCadastro)
Return Nil