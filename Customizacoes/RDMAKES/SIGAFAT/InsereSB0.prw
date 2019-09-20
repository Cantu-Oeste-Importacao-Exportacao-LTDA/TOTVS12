#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
/*********************************************************
 Utilizado para implantação do sigaloja para inserir a tabela de preço 
 dos produtos que ainda nao foram inseridos.
 Utilizar somente na implantacao, devido a inserir os produtos 
 com preços zerados
 *********************************************************/

User Function InsereSB0()
Local cAliasDB := GetNextAlias() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

BeginSql Alias cAliasDB
	Select B1_FILIAL, B1_COD
	from %Table:SB1% SB1
	WHERE NOT EXISTS(SELECT B0_COD FROM  %Table:SB0% SB0 
		where b0_cod = b1_cod and b0_filial = b1_filial 
		and sb0.d_e_l_e_t_ = ' ' and sb1.d_e_l_e_t_ = ' ')
		and (SUBSTR(B1_COD, 1, 2) = '01' or SUBSTR(B1_COD, 1, 2) = '03' or SUBSTR(B1_COD, 1, 2) = '02')
		and d_e_l_e_t_ = ' '
		and b1_filial = %xFilial:SB1%
		order by 1, 2
EndSql

dbSelectArea(cAliasDB)
While (cAliasDB)->(!Eof())
  RecLock("SB0", .T.)
  SB0->B0_FILIAL = (cAliasdB)->B1_FILIAL
  SB0->B0_COD = (cAliasdB)->B1_COD
  SB0->(MsUnlock())
  (cAliasDB)->(dbSkip())
EndDo

Return Nil