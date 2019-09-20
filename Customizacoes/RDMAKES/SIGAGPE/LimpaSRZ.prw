#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/**********************************************************************
 Função para ecluir a tabela SRZ quando dá erro ao processar contabilizações.
 Deve ser executada em modo exclusivo
 **********************************************************************/
 
User Function LimpaSRZ()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFile := RetSqlName("SRZ")
If  TcDelFile(cFile)
	MSGINFO("Tabela SRZ excluída com sucesso.")
Else
	MSGINFO("Não foi possível excluir a tabela SRZ.")
Endif
Return
