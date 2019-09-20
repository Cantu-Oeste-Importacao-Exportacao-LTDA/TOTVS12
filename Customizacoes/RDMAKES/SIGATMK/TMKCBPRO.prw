#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "TopConn.ch"      

/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  TMKCBPRO   � Autor � Lucilene Mendes     � Data �08.11.12 ���
��+----------+------------------------------------------------------------���
���Descri��o � Ponto de entrada para adi��o de bot�es no menu superior    ���
���          � da rotina de telecobran�a.                                 ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/          
/*
u_tmkout - na saida da tela
u_tk271bok -  bot�o ok
*/

User Function TMKCBPRO()

Public dDtBloq := ''
Public lDblqCli := .F.     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

aBtnSup := {}
// nFolder // Numero referente a pasta do atendimento 1- Telemarketing; 2 - Televendas; 3 - Telecobran�a

aAdd(aBtnSup,{"CADEADO"  , {|| U_DblqCli()} ,"Dsb.Cliente"})
//aAdd(aBtnSup,{"COMPTITL"  , {|| U_CANC001()} ,"Titulos"})

Return(aBtnSup)


/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  DBLQCLI    � Autor � Lucilene Mendes     � Data �08.11.12 ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o para desbloqueio do cliente chamado pelo bot�o do   ���
���          � menu superior da rotina de telecobran�a.                   ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function DblqCli()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//Verifica se o campo ACF_CLIENTE est� preenchido
If Empty(M->ACF_CLIENT)
	MsgAlert("� necess�rio selecionar um cliente antes de realizar o desbloqueio!","Aten��o")
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
			//identifica que o desbloqueio foi realizado atrav�s da rotina e ser� necess�rio bloquear novamente
			lDblqCli := .T. 
			MsgInfo("Cliente desbloqueado!")
		Endif
	Else
		MsgInfo("O cliente "+Upper(Alltrim(A1_NOME))+" n�o est� bloqueado!")
		Return .F.
	Endif
Else
	MsgStop("C�digo de cliente n�o localizado!","N�o localizado")
	Return .F.
Endif	

Return .T.     


/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  TK271BOK   � Autor � Lucilene Mendes     � Data �08.11.12 ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o para bloquear novamente o cliente acionada atrav�s  ���
���          � do bot�o OK da rotina de telecobran�a.                     ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

User Function TK271BOK()
lRet:= .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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
		MsgAlert("N�o foi poss�vel bloquear novamente o cliente "+Upper(Alltrim(A1_NOME))+". Verifique!")
	Endif
Endif

Return lRet


/*__________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Fun��o    �  TMKOUT     � Autor � Lucilene Mendes     � Data �08.11.12 ���
��+----------+------------------------------------------------------------���
���Descri��o � Fun��o para bloquear novamente o cliente acionada atrav�s  ���
���          � do bot�o CANCELAR da rotina de telecobran�a.               ���
��+----------+------------------------------------------------------------���
��� Uso      � Cantu - Call Center                                        ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
            
User Function TMKOUT()
lRet:= .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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
		MsgAlert("N�o foi poss�vel bloquear novamente o cliente "+Upper(Alltrim(A1_NOME))+". Verifique!")
	Endif
Endif

Return lRet

