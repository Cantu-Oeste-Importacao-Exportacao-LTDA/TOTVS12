#include "rwmake.ch"
#include "topconn.ch"
/* Funcao criada para Alterar os dados de Origem, Grupo Tribut�rio, Tes,
 Exporta para Palm, Filial de Venda, Peso Bruto, Peso L�quido,
 Unidade de Medida, Bloqueado, Segunda Unidade de Medida, Conversao,
 Tipo da Conversao, Pre�o de Venda e Desconto M�ximo
  
 * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function ManDescCli()
Local cCad := "Alterar desconto cliente"
// alterado para buscar os campos a alterar de um parametro
Local cCposAlt := "A1_DESCFIN/A1_DESCVEN"
U_MANUTCPOS("SA1", cB1CposAlt, cCad)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return Nil