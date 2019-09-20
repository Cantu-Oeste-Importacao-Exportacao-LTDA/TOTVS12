#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutForn  | Autor | Dayane Filakoski | Data | 29.06.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informações do Fornecedor.                        |
//+--------------------------------------------------------------------+
//| Uso    |Todos.                                                     |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de Banco, Codigo Agencia, Conta
 Corrente e Tipo de Conta no cadastro de Fornecedores
  
 * Funçao modificada para para que seja possível alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTFORN()
Local cCad := "Manutenção de Fornecedores para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "A2_BANCO/A2_AGENCIA/A2_DIGAGEN/A2_NUMCON/A2_DIGCON/A2_TIPCTA/A2_TPCONTA/A2_X_INFPG/A2_X_CPF"
U_MANUTCPOS("SA2", cB1CposAlt, cCad)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return