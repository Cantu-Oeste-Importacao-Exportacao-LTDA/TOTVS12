#include "rwmake.ch"
#include "topconn.ch" 

/***********************************************
 Exclui dados do palm para a filial selecionada
***********************************************/
User Function ExPl5001  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

RpcSetEnv("20", "01")
ExcDaPlm(.T.)
Return


/***********************************************
 Exclui dados do palm
 Fun豫o a ser chamada no menu para excluir os dados da filial selecionada.
***********************************************/
User Function ExcBaPlm()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

ExcDaPlm(.F.)
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿐xcDaPlm     튍utor  쿑lavio Dias      � Data �  01/23/09   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     �  Fun豫o para excluir dados antigos das tabelas do palm     볍�
굇�          �  que nao sao exclu�dos automaticamente.                    볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       �  Todas as filiais que utilizam o SFA                       볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
// Emite aviso em rela豫o ao que ser� feito
If lMsg .or. MsgBox("Esta rotina exclui todas as informa寤es a serem sincronizadas pelo palm." + chr(13) + chr(10) +;
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