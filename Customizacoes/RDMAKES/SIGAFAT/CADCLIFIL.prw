#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CADCLIFIL  �Autor  �Jean Carlos Saggin � Data �  28/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de clientes espec�fico para Filiais               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICOS CANTU ALIMENTOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------*
User Function CADCLIFIL()
*------------------------*

Private cTabela   := "SA1"
Private cCadastro := "Cadastro de Clientes para Filiais"
Private aRotina   := {}
                              
//�Chama fun��o para monitor uso de fontes customizados�
U_USORWMAKE(ProcName(),FunName())

aAdd(aRotina, {"&Pesquisar",  "AxPesqui", 0, 1})
aAdd(aRotina, {"&Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"&Incluir",    "U_SA1Inc", 0, 3})
aAdd(aRotina, {"&Alterar",    "U_SA1Alt", 0, 4})

DbSelectArea(cTabela)
(cTabela)->(DbSetOrder(1))
mBrowse(6, 1, 22, 75, cTabela)

Return                           

*-------------------------*
User Function SA1ALT()
*-------------------------*

Local nReg  := SA1->(Recno())
Local aCpos := {"A1_COD","A1_PESSOA","A1_CGC","A1_LOJA","A1_TIPO","A1_NOME","A1_NREDUZ","A1_END","A1_COMPLEM","A1_EST",;
								"A1_COD_MUN","A1_MUN","A1_NATUREZ","A1_DDD","A1_BAIRRO","A1_CEP","A1_TEL","A1_FORMPAG","A1_CONTATO","A1_INSCR",;
								"A1_CONTA","A1_COND","A1_RISCO","A1_EMAIL","A1_CODPAIS","A1_DTCADAS","A1_X_SERAS","A1_RISCO", "A1_MSBLQL"}

AxAltera(cTabela,nReg,4,,aCpos,,,"U_SA1TOK()",,,) 

Return

*-----------------------*
User Function SA1TOK()
*-----------------------*

Local lRet := .T.

//���������������������������������������������������������������������������������Ŀ
//�Valida para que no bloqueio de clientes, o sistema n�o deixe diferente de � vista�
//�����������������������������������������������������������������������������������

If SA1->A1_MSBLQL == '1' .and. M->A1_MSBLQL != '1' .and. M->A1_FORMPAG != 'R$'
	lRet := .F.
	Alert("O desbloqueio de cliente s� pode ser feito para pagamento � vista!")
EndIf                                                                        

//�����������������������������������������������������������������Ŀ
//�Valida mudan�a na forma de pagamento do cliente quando for boleto�
//�������������������������������������������������������������������

If SA1->A1_FORMPAG == 'R$' .and. M->A1_FORMPAG != 'R$'
	lRet := .F.
	Alert("A forma de pagamento do cliente � em dinheiro, somente a equipe de cr�dito poder� alter�-lo!")
EndIf

If lRet
	fSendAprov()	
EndIf

Return lRet

*------------------------*
User Function SA1INC()	
*------------------------*

Local nReg  := SA1->(Recno())
Local aCpos := {"A1_COD","A1_PESSOA","A1_CGC","A1_LOJA","A1_TIPO","A1_NOME","A1_NREDUZ","A1_END","A1_COMPLEM","A1_EST",;
								"A1_COD_MUN","A1_MUN","A1_NATUREZ","A1_DDD","A1_BAIRRO","A1_CEP","A1_TEL","A1_FORMPAG","A1_CONTATO","A1_INSCR",;
								"A1_CONTA","A1_COND","A1_RISCO","A1_EMAIL","A1_CODPAIS","A1_DTCADAS","A1_X_SERAS","A1_RISCO"}

AxInclui(cTabela,nReg,3,,,aCpos,"U_SA1TOK()",,,,,,,)

Return 

*---------------------------*
Static Function fSendAprov()
*---------------------------*

Local cTo := ""
Local cCC := ""
Local oProcess
Local oHtml                  

DbSelectArea("SA1")
DbGoTo(SA1->(Recno()))

cTo := "credito@cantu.com.br" //ajustar
cCC := "" //ajustar

Conout("CADCLIFIL - INICIANDO ENVIO DE E-MAIL PARA "+ AllTrim(Upper(cTo)) +;
			 iif(!Empty(Trim(cCC)), " E PARA " + AllTrim(Upper(cCC)), "") ) 

oProcess := TWFProcess():New("CADCLIFIL",OemToAnsi("Analisar cr�dito"))
oProcess:NewTask("CADCLIFIL","\workflow\wfcadclifil.htm")
oProcess:cSubject := OemToAnsi("CLIENTE "+ IIF(IsInCallStack("U_SA1INC"),"INCLUIDO",IIF(IsInCallStack("U_SA1ALT"),"ALTERADO",IIF(IsInCallStack("U_SA1DEL"),"APAGADO","MODIFICADO"))) +" PELO OPERADOR "+ AllTrim(cUserName))
oProcess:cTo := cTo
oProcess:cCC := cCC

oHTML := oProcess:oHTML

AAdd( (oHtml:ValByName( "IT.CLIENTE" )), "COD. "+ Trim(SA1->A1_COD) +" LOJA "+ SA1->A1_LOJA +" RAZAO SOC. "+ SubStr(SA1->A1_NOME,01,30) )

oProcess:Start()
oProcess:Finish()

Return 