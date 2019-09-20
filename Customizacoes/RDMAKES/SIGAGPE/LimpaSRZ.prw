#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
/**********************************************************************
 Fun��o para ecluir a tabela SRZ quando d� erro ao processar contabiliza��es.
 Deve ser executada em modo exclusivo
 **********************************************************************/
 
User Function LimpaSRZ()         

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

cFile := RetSqlName("SRZ")
If  TcDelFile(cFile)
	MSGINFO("Tabela SRZ exclu�da com sucesso.")
Else
	MSGINFO("N�o foi poss�vel excluir a tabela SRZ.")
Endif
Return
