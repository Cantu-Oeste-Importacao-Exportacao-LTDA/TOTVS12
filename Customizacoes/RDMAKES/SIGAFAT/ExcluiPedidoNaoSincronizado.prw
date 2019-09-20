#include "rwmake.ch"
#include "topconn.ch"
/************************************************************
 Exclui os pedidos do palm que não foram sincronizados do hc5 e hc6, configurando os mesmos por filial
 Parametros:
 MV_EXPEFI - tipo lógico (.T., .F.) que determina se será efetuado a exclusão para a 	
 ************************************************************/
User Function ExcPedNS(cEmp)
Local cFiliais := SUPERGETMV('MV_EXPEFI', ,.F.)
Local cSqlHC5 := ""
Local cSqlHC6 := ''    
        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !Empty(cFiliais)  
  cSqlHC5 := "update " + RetSqlName('HC5') + " set d_e_l_e_t_ = '*' where (position(hc5_filial, '" + cFiliais + ;
  					"', CODEUNITS32) > 0 ) and hc5_status = 'N  ' and d_e_l_e_t_ <> '*'"
  					
	cSqlHC6 := "update " + RetSqlName('HC6') + " set d_e_l_e_t_ = '*' where (position(hc6_filial, '" + cFiliais + ;
  					"', CODEUNITS32) > 0 ) and hc6_status = 'N  ' and d_e_l_e_t_ <> '*'"
  
  // executa o sql
	TcExecSql(cSql)
EndIf
Return Nil