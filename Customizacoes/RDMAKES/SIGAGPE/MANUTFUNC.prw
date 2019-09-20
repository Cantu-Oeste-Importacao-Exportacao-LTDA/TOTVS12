#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutFunc  | Autor | Dayane Filakoski | Data | 15.07.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informa��es do funcion�rio                        |
//+--------------------------------------------------------------------+
//| Uso    |Departamento Pessoal                                       |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de senha do cadastro de funcionario
  
 * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTFUNC()
Local cCad := "Manuten��o de Funcionarios para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "RA_SENHA"
U_MANUTCPOS("SRA", cB1CposAlt, cCad)  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return