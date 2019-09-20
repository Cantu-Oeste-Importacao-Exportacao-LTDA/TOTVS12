#include "PROTHEUS.CH"
#include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � A140EXC  �Autor  � Adriano            � Data �  27/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. utilizado para validar a exclus�o de uma pre nota de  ���
���          � entrada.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A140EXC()
Local lRet	:= .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())


cSql := "SELECT R_E_C_N_O_ "
cSql += "FROM "+RetSqlName("ZZS")+" "
cSql += "WHERE D_E_L_E_T_ <> '*' "
cSql += "AND ZZS_FILORI = '"+xFilial("SF1")+"' "
cSql += "AND ZZS_NUMCTR = '"+SF1->F1_DOC+"' AND ZZS_SERCTR = '"+SF1->F1_SERIE+"' "
cSql += "AND ZZS_NUMFAT = '"+SF1->F1_X_FATTR+"' "
cSql += "AND ZZS_DTCTRC = '"+DtoS(SF1->F1_EMISSAO)+"' "
TCQUERY cSql NEW ALIAS "TMPZZS"

TMPZZS->(DbSelectArea("TMPZZS"))
TMPZZS->(DbGotop())

if !TMPZZS->(EOF())
	ZZS->(DbSelectArea("ZZS"))
	ZZS->(DbGoTo(TMPZZS->R_E_C_N_O_))
	RecLock("ZZS", .F.) 
		ZZS->ZZS_NUMCTR := ""
		ZZS->ZZS_SERCTR := ""
		ZZS->ZZS_DTCTRC := Stod("  /  /    ")
		ZZS->ZZS_NUMFAT := ""
		ZZS->ZZS_VENTIT := Stod("  /  /    ")
		ZZS->ZZS_VLRCTR := 0
		ZZS->ZZS_FORMPG := ""
	ZZS->(MsUnlock())
	TMPZZS->(DbSelectArea("TMPZZS"))
	TMPZZS->(DbCloseArea())
EndIf           

// Inicio Afill Valida��o da exclus�o da NF de Entrada
If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF n�o pode ser excluida pois foi gerada pelo Controle Geral (Importa��o). Exclua a NF pela Op��o de Importa��o \ Controle Geral...","Sem acesso")
	lRet := .F.
EndIf                                                 
// Fim Afill valida��o


Return lRet