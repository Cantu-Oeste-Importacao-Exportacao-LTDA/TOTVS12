#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³WFNotaDenegada ºAutor  ³Ricardo Catelli º Data ³  10/06/2014 ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Workflow de Notas Denegadas (edição do fonte WFNotaNaoTans º±±
±±º          ³ mitida;                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Workflow									                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function wfnts1001() 
Local cEmpAtu		:= "10"
Local cFilAtu		:= "01"	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName()) 

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 10 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()
Return()

User function wfnts201()            //empresa 20 01
Local cEmpAtu		:= "20"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 20 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()

User function wfnts202() 
Local cEmpAtu		:= "20"
Local cFilAtu		:= "02"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 20 Filial 02")
	U_WfNotaDN()		
RpcClearEnv()

Return()

User function wfnts3001() 
Local cEmpAtu		:= "30"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2" 
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 30 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()

User function wfnts3101()                         
Local cEmpAtu		:= "31"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2" 
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 31 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()    

User function wfnts3201()                         
Local cEmpAtu		:= "32"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 32 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()  

User function wfnts3401()                         
Local cEmpAtu		:= "34"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 34 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()

User function wfnts4001() 
Local cEmpAtu		:= "40"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 40 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()

User function wfnts5001() 
Local cEmpAtu		:= "50"
Local cFilAtu		:= "01"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())	 

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"  
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 50 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()     

User function wfnts6001() 
Local cEmpAtu		:= "60"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"  
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 60 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return() 

User function wfnts7001() 
Local cEmpAtu		:= "70"
Local cFilAtu		:= "01"	 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FAT" TABLES "SF1,SF2"    
	conout ("Iniciando envio de Workflow de Notas Denegadas da Empresa 70 Filial 01")
	U_WfNotaDN()		
RpcClearEnv()

Return()
/********************************************************
 Workflow de notas Denegadas.
 
/********************************************************/
User Function WfNotaDN()
Local cDataInic := transform(DTOS(DATE(dDataBase)), "@! 999999") + '01'
Local cDataFina := transform(DTOS(DATE(dDataBase)), "@! 99999999")
Local cSql := ""
cSql := "select SF2.F2_FILIAL AS FILIAL, SF2.F2_SERIE AS SERIE , SF2.F2_DOC AS NUMERO, F2_EMISSAO AS EMISSAO, SF2.F2_FIMP AS STATUS from " + RetSqlName("SF2") + " SF2 "
cSql += "where SF2.F2_ESPECIE =   'SPED' AND SF2.F2_FIMP = 'D' AND SF2.D_E_L_E_T_ <> '*' AND SF2.F2_EMISSAO BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"
cSql += " union "
cSql += "select SF1.F1_FILIAL, SF1.F1_SERIE, SF1.F1_DOC, F1_EMISSAO, SF1.F1_FIMP from " + RetSqlName("SF1") + " SF1 "
cSql += "where SF1.F1_ESPECIE =   'SPED' AND SF1.F1_FIMP = 'D' AND SF1.D_E_L_E_T_ <> '*' and SF1.F1_FORMUL = 'S' AND SF1.F1_EMISSAO BETWEEN '" + cDataInic + "' AND '" + cDataFina + "'"


TcQuery cSql New Alias "TMPSF1"
// Envia o workflow

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If TMPSF1->(!Eof())
	oProcess := TWFProcess():New( "wfnotas_nt", "Bloqueio de Clientes")
	oProcess:NewTask( "wfnotas_nt", "\workflow\wfnotas_nt.html" )
	oProcess:cSubject := "Workflow de Notas Denegadas em  " + DTOC(DDATABASE) + " - Empresa - " + SM0->M0_NOME
	oHTML := oProcess:oHTML
	
	While TMPSF1->(!Eof())
		AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSF1->FILIAL)
		AAdd((oHtml:ValByName( "IT.SERIE" )), TMPSF1->SERIE)
		AAdd((oHtml:ValByName( "IT.NUMERO" )), TMPSF1->NUMERO)
		AAdd((oHtml:ValByName( "IT.EMISSAO" )), DToC(StoD(TMPSF1->EMISSAO)))
		
		cStatus := TMPSF1->STATUS
		if (cStatus == "D")
			cStDesc := "D - Uso Denegado"				//Foi retirado os elseif para manter apenas a opção de denegadas
		EndIf
		
		AAdd((oHtml:ValByName( "IT.STATUS" )), cStDesc)
		TMPSF1->(dbSkip())
	EndDo
	
	// envia o email com a lista de clientes bloqueados
 	oProcess:cTo  := AllTrim(SuperGetMV("MV_X_NFDN", , 'suporte.ti@grupocantu.com.br'))
	//oProcess:cTo  := 'suporte.ti@grupocantu.com.br;suporte.microsiga@grupocantu.com.br'
  	oProcess:Start()
  	oProcess:Finish() 
  	oProcess:Free() 
  	conout ("Workflow de Notas Denegadas enviado com sucesso!")
	
EndIf
TMPSF1->(dbCloseArea()) 

Return()