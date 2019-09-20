#include "rwmake.ch" 
//+--------------------------------------------------------------------+
//| Rotina | CadGerente | Autor| Gustavo Lattmann  | Data | 23.12.2013 |
//+--------------------------------------------------------------------+
//| Descr. | Amarra��o de gerente com o segmento                       |
//+--------------------------------------------------------------------+
//| Uso    |Cantu Geral - BI - Apurra��o Cont�bil                      |
//+--------------------------------------------------------------------+
User Function CadGerente()
Local cCadastro := "Cadastro de Gerentes"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

AxCadastro("Z63",cCadastro)
Return Nil