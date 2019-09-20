#include "rwmake.ch"
#include "topconn.ch" 

/***********************************************
 Exclui dados do palm para a filial selecionada
***********************************************/
User Function ExPl5001  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

RpcSetType(3)
RpcSetEnv("50", "01")
ExcDaPlm(.T.)
RpcClearEnv()
Return

/***********************************************
 Exclui dados do palm para a filial selecionada
***********************************************/
User Function ExPl2001

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

RpcSetEnv("20", "01")
ExcDaPlm(.T.)
Return


/***********************************************
 Exclui dados do palm
 Fun��o a ser chamada no menu para excluir os dados da filial selecionada.
***********************************************/
User Function ExcBaPlm()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

ExcDaPlm(.F.)
Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ExcDaPlm     �Autor  �Flavio Dias      � Data �  01/23/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �  Fun��o para excluir dados antigos das tabelas do palm     ���
���          �  que nao sao exclu�dos automaticamente.                    ���
�������������������������������������������������������������������������͹��
���Uso       �  Todas as filiais que utilizam o SFA                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

/********************************************************************
 Programa que faz a exclus�o de todos os dados do palm para a filial selecionada.
 Deve ser usada quando existem dados antigos no palm que n�o existem mais no sistema.
 *******************************************************************/
Static Function ExcDaPlm(lMsg)
Local cQuery := ""
if Empty(lMsg)
	lMsg := .T.
EndIf
// Emite aviso em rela��o ao que ser� feito
If lMsg .or. MsgBox("Esta rotina exclui todas as informa��es a serem sincronizadas pelo palm." + chr(13) + chr(10) +;
					 "Ser� necess�rio recriar a base para todos os vendedores da filial selecionada." + chr(13) + chr(10) +; 
					 "Deseja continuar?","Exclus�o de dados do Palm","YESNO")

	// Exclui clientes
	cQuery := "Delete from " + RetSqlName("HA1") + iif(lMsg, " where ha1_filial = '" + xFilial("HA1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do clientes")
	
	// Exclui Transportadores
	cQuery := "Delete from " + RetSqlName("HA4") + iif(lMsg, " where ha4_filial = '" + xFilial("HA4") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Transportadores")
	
	// Exclui Produtos
	cQuery := "Delete from " + RetSqlName("HB1") + iif(lMsg, " where hb1_filial = '" + xFilial("HB1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Produtos")
	
	// Exclui Estoques
	cQuery := "Delete from " + RetSqlName("HB2") + iif(lMsg, " where hb2_filial = '" + xFilial("HB2") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Estoques")
	
	// Exclui Grupos
	cQuery := "Delete from " + RetSqlName("HBM") + iif(lMsg, " where hbm_filial = '" + xFilial("HBM") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Grupos")
	
	// Exclui Cabe�alho de Regras de neg�cio
	cQuery := "Delete from " + RetSqlName("HCS") + iif(lMsg, " where hcs_filial = '" + xFilial("HCS") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Cabe�alho de Regras de neg�cio")
	
	// Exclui Itens de Regras de neg�cio
	cQuery := "Delete from " + RetSqlName("HCT") + iif(lMsg, " where hct_filial = '" + xFilial("HCT") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Itens de Regras de neg�cio")
	
	// Exclui Duplicatas
	cQuery := "Delete from " + RetSqlName("HE1") + iif(lMsg, " where he1_filial = '" + xFilial("HE1") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Transportadores")
	
	// Exclui Cond. Pagto
	cQuery := "Delete from " + RetSqlName("HE4") + iif(lMsg, " where he4_filial = '" + xFilial("HE4") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Duplicatas")
	
	// Exclui Itens de Tabelas de Pre�o
	cQuery := "Delete from " + RetSqlName("HPR") + iif(lMsg, " where hpr_filial = '" + xFilial("HPR") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Itens de Tabelas de Pre�o")

	// Exclui Cabe�alho de Tabelas de Pre�o
	cQuery := "Delete from " + RetSqlName("HTC") + iif(lMsg, " where htc_filial = '" + xFilial("HTC") + "'", "")
	TCSQLEXEC(cQuery)
	ConOut("Exclu�do Cabe�alho de Tabelas de Pre�o")

	if (!lMsg)
		MsgInfo("Dados das tabelas do palm exclu�das com sucesso para a filial selecionada.")
		MsgInfo("Recrie a base de todos os vendedores da filial selecionada.")
	EndIf
EndIf
Return Nil