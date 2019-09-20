#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutForn  | Autor | Dayane Filakoski | Data | 29.06.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informa��es do Fornecedor.                        |
//+--------------------------------------------------------------------+
//| Uso    |Todos.                                                     |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de Banco, Codigo Agencia, Conta
 Corrente e Tipo de Conta no cadastro de Fornecedores
  
 * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTFORN()
Local cCad := "Manuten��o de Fornecedores para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "A2_BANCO/A2_AGENCIA/A2_DIGAGEN/A2_NUMCON/A2_DIGCON/A2_TIPCTA/A2_TPCONTA/A2_X_INFPG/A2_X_CPF"
U_MANUTCPOS("SA2", cB1CposAlt, cCad)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return