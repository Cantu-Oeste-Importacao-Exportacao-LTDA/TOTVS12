#include "rwmake.ch"
#include "topconn.ch"
/* Funcao criada para Alterar os dados de Origem, Grupo Tributário, Tes,
 Exporta para Palm, Filial de Venda, Peso Bruto, Peso Líquido,
 Unidade de Medida, Bloqueado, Segunda Unidade de Medida, Conversao,
 Tipo da Conversao, Preço de Venda e Desconto Máximo
  
 * Funçao modificada para para que seja possível alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function ManDescCli()
Local cCad := "Alterar desconto cliente"
// alterado para buscar os campos a alterar de um parametro
Local cCposAlt := "A1_DESCFIN/A1_DESCVEN"
U_MANUTCPOS("SA1", cB1CposAlt, cCad)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return Nil