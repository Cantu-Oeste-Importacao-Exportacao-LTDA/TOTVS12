#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutFunc  | Autor | Dayane Filakoski | Data | 15.07.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informações do funcionário                        |
//+--------------------------------------------------------------------+
//| Uso    |Departamento Pessoal                                       |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de senha do cadastro de funcionario
  
 * Funçao modificada para para que seja possível alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTFUNC()
Local cCad := "Manutenção de Funcionarios para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "RA_SENHA"
U_MANUTCPOS("SRA", cB1CposAlt, cCad)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return