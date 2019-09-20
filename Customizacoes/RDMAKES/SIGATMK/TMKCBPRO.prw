#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"      

/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  TMKCBPRO   ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦08.11.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Ponto de entrada para adição de botões no menu superior    ¦¦¦
¦¦¦          ¦ da rotina de telecobrança.                                 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/          
/*
u_tmkout - na saida da tela
u_tk271bok -  botão ok
*/

User Function TMKCBPRO()

Public dDtBloq := ''
Public lDblqCli := .F.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aBtnSup := {}
// nFolder // Numero referente a pasta do atendimento 1- Telemarketing; 2 - Televendas; 3 - Telecobrança

aAdd(aBtnSup,{"CADEADO"  , {|| U_DblqCli()} ,"Dsb.Cliente"})
//aAdd(aBtnSup,{"COMPTITL"  , {|| U_CANC001()} ,"Titulos"})

Return(aBtnSup)


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  DBLQCLI    ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦08.11.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função para desbloqueio do cliente chamado pelo botão do   ¦¦¦
¦¦¦          ¦ menu superior da rotina de telecobrança.                   ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/ 

User Function DblqCli()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Verifica se o campo ACF_CLIENTE está preenchido
If Empty(M->ACF_CLIENT)
	MsgAlert("É necessário selecionar um cliente antes de realizar o desbloqueio!","Atenção")
    Return .F.
Endif    

//Localiza o cliente a ser desbloqueado
dbSelectArea("SA1")
If dbSeek(xFilial("SA1")+M->ACF_CLIENT)
	If !Empty(SA1->A1_MSBLQL)
		If MsgYesNo("Confirma o desbloqueio do cliente "+Upper(Alltrim(A1_NOME))+"?")
			dDtBloq   := SA1->A1_MSBLQL
			RecLock("SA1",.F.)
			SA1->A1_MSBLQL := ''
			MsUnlock()
			//identifica que o desbloqueio foi realizado através da rotina e será necessário bloquear novamente
			lDblqCli := .T. 
			MsgInfo("Cliente desbloqueado!")
		Endif
	Else
		MsgInfo("O cliente "+Upper(Alltrim(A1_NOME))+" não está bloqueado!")
		Return .F.
	Endif
Else
	MsgStop("Código de cliente não localizado!","Não localizado")
	Return .F.
Endif	

Return .T.     


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  TK271BOK   ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦08.11.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função para bloquear novamente o cliente acionada através  ¦¦¦
¦¦¦          ¦ do botão OK da rotina de telecobrança.                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

User Function TK271BOK()
lRet:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Se cliente foi desbloqueado pela rotina de desbloqueio
If 	lDblqCli .and. !Empty(dDtBloq)
	//Localiza o cliente a ser bloqueado
	dbSelectArea("SA1")
	If dbSeek(xFilial("SA1")+M->ACF_CLIENT)
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := dDtBloq
		MsUnlock()
		lDblqCli := .F.
	Else
		MsgAlert("Não foi possível bloquear novamente o cliente "+Upper(Alltrim(A1_NOME))+". Verifique!")
	Endif
Endif

Return lRet


/*__________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Funçäo    ¦  TMKOUT     ¦ Autor ¦ Lucilene Mendes     ¦ Data ¦08.11.12 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçäo ¦ Função para bloquear novamente o cliente acionada através  ¦¦¦
¦¦¦          ¦ do botão CANCELAR da rotina de telecobrança.               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦ Uso      ¦ Cantu - Call Center                                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/
            
User Function TMKOUT()
lRet:= .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Se cliente foi desbloqueado pela rotina de desbloqueio
If 	lDblqCli .and. !Empty(dDtBloq)
	//Localiza o cliente a ser bloqueado
	dbSelectArea("SA1")
	If dbSeek(xFilial("SA1")+M->ACF_CLIENT)
		RecLock("SA1",.F.)
		SA1->A1_MSBLQL := dDtBloq
		MsUnlock()
		lDblqCli := .F.
	Else
		MsgAlert("Não foi possível bloquear novamente o cliente "+Upper(Alltrim(A1_NOME))+". Verifique!")
	Endif
Endif

Return lRet

