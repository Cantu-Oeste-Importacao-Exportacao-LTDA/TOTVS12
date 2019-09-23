#Include "Protheus.ch"
#include "rwmake.ch"
//+--------------------------------------------------------------------+
//| Rotina | ManutClie  | Autor | Dayane Filakoski | Data | 29.06.2010 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informa��es do cliente.                           |
//+--------------------------------------------------------------------+
//| Uso    |Todos.                                                     |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de Banco Cliente, Agencia Cliente,
 Numero Conta e Tipo conta no cadastro de Clientes.
  
 * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos 
  do cadastro do produto.
 *******************************************************************/
User Function MANUTCLIE()
Local cCad := "Manuten��o de Clientes para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "A1_BANCO/A1_AGENCIA/A1_NUMCONT/A1_TPCONTA/A1_VEND/A1_X_ENVSF/A1_TRANSP/"
U_MANUTCPOS("SA1", cB1CposAlt, cCad)  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return         


//+--------------------------------------------------------------------+
//| Rotina | CadRapCli  | Autor Edison G. Barbieri | Data | 21.03.2016 |
//+--------------------------------------------------------------------+
//| Descr. | Alterar informa��es do cliente.                           |
//+--------------------------------------------------------------------+
//| Uso    |Todos.                                                     |
//+--------------------------------------------------------------------+

/*******************************************************************
 Funcao criada para Alterar os dados de clientes para agilizar o processo,
 inten��o de ser um cadastro r�pido .
  
 * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos 
  do cadastro do cliente.                                                   
 *******************************************************************/
User Function CADRAPCLI()
Local cCad := "Manuten��o de Clientes para filiais"
// alterado para buscar os campos a alterar de um parametro
Local cB1CposAlt := "A1_ESTADO/A1_COD/A1_PESSOA/A1_CGC/A1_LOJA/A1_TIPO/A1_NOME/A1_NREDUZ/A1_END/A1_COMPLEM/A1_EST/A1_COD_MUN/A1_MUN/A1_DDD/A1_TEL/A1_BAIRRO/A1_CEP/A1_PAIS/A1_DDI/A1_FAX/A1_ENDENT/A1_ENDREC/A1_ENDCOB/A1_CONTATO/A1_INSCR/A1_INSCRM/A1_PFISICA/A1_BAIRROC/A1_CEPC/A1_MUNC/A1_ESTC/A1_EMAIL/A1_X_MAILN/A1_HPAGE/A1_MSBLQL/A1_INSCRUR/A1_CODPAIS/A1_CBO/A1_CNAE/A1_NATUREZ/A1_CONTA/A1_BANCO/A1_AGENCIA/A1_TPCONTA/A1_NUMCONT/A1_USADDA/A1_TPFRETE/A1_RECISS/A1_SUPRAMA/A1_INCISS/A1_ALIQIR/A1_CALCSUF/A1_GRPTRIB/A1_MUNE/A1_ESTE/A1_RECINSS/A1_RECCOFI/A1_RECCSLL/A1_RECPIS/A1_TPESSOA/A1_SIMPNAC/A1_RECFET/A1_VINCULO/A1_CONTRIB/A1_DTINIV/A1_DTFIMV/A1_FOMEZER/A1_SIMPLES/A1_FRETISS/A1_ABATIMP/A1_RECIRRF/A1_ENTID/A1_MINIRF/A1_INDRET/A1_IRBAX/A1_RECFMD/A1_INCLTMG/A1_TRANSP"
U_MANUTCPOS("SA1", cB1CposAlt, cCad)  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return
