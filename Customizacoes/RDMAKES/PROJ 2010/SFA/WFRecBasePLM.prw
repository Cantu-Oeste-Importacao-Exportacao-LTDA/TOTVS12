#INCLUDE "rwmake.ch"
/**********************************************************************/
// Função chamada pelo workflow para recriar a base do palm em determinado horário
/**********************************************************************/
User Function RecPlm01() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetType(3)
RPCSetEnv("20","01")
U_RecPlm("000001")
RpcClearEnv()
Return


/**********************************************************************/
// Função chamada pelo workflow para recriar a base do palm em determinado horário
/**********************************************************************/
User Function RecPlm02()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetType(3)
RPCSetEnv("50","01")
U_RecPlm("000002")
RpcClearEnv()
Return


/**********************************************************************/
// Função chamada pelo workflow para recriar a base do palm em determinado horário
/**********************************************************************/
User Function RecPlm05()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetType(3)
RPCSetEnv("10","01")
U_RecPlm("000005")
RpcClearEnv()
Return


/**********************************************************************/
// Funcão genérica que cria a  base do palm
/**********************************************************************/
User Function RecPlm(cGrupo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// abre o arquivo de controle de criação de base para os vendedores
DbUseArea(.T.,,"\hhtrg\hhtime.dtc","HHT",.T.)
HHT->(DbSetOrder(1))

cFiltro := "HH_GRUPO = '" + cGrupo + "' " 	
dbSelectArea("HHT")
Set Filter To &cFiltro
	
// filtra apenas o grupo atual
HHT->(DbSetFilter({||HH_GRUPO = cGrupo}, "1=1"))
HHT->(DbGoTop())
While HHT->(!Eof())
  // limpa o campo HH_TIME, pois isso faz com que o processo InitJob recrie a base para aqueles que estão com o campo em branco
  RecLock("HHT", .F.)
  HHT->HH_TIME := Space(16)
  MsUnlock()
  HHT->(DbSkip())
EndDo

dbSelectArea("HHT")
Set Filter To

HHT->(DbCloseArea())

EnviaEmail()

Return Nil

/*********************************************************************************
 Faz o processo de enviar o email para o vendedor confirmando da sincronização
 *********************************************************************************/
Static Function EnviaEmail()
Local cEmail := "eder@grupocantu.com.br;microsiga@grupocantu.com.br"
Local cCli := ""
Local cLojaCli := ""
Local oProcess
Local oHtml
Local cProcess := OemToAnsi("008080") // Numero do Processo
cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido"))
oProcess:NewTask(cStatus,"\workflow\wfrecriabase.html")
oProcess:cSubject := OemToAnsi("Inciado processo de criar base do palm para " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

oProcess:cTo := ALLTRIM(cEmail)
oProcess:cCC := "sim3g@grupocantu.com.br"
                                    
// Preenchimento do cabeçalho do pedido
oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"   ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("EMP", SM0->M0_NOME + " / " + SM0->M0_FILIAL)

oProcess:Start()
oProcess:Finish()
Return Nil