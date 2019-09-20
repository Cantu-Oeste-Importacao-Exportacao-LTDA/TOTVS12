#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "report.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA070MDB  �Autor  �Gustavo Lattmann    � Data �  06/11/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado no momento da baixa de t�tulo   ���
���          � a receber.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Cantu                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FA070MDB()

Local cAliasTMP := GetNextAlias()
Local cWhere := "%%"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
If FindFunction("U_USORWMAKE")
	U_USORWMAKE(ProcName(),FunName())
EndIf


//�������������������������������������������������������������������������Ŀ
//�Se o cliente possuir duplicatas em atraso n�o ser� poss�vel baixar a NCC.�
//���������������������������������������������������������������������������
If ALLTRIM(SE1->E1_TIPO) = "NCC"

	cWhere := "%AND E1.E1_CLIENTE ='" + SE1->E1_CLIENTE + "' AND E1.E1_SALDO > 0 AND E1.E1_VENCREA < '" + DTOS(Date()) + "'"  
	cWhere += "AND E1.E1_TIPO NOT IN ('NCC','RA') %"
	
	BEGINSQL Alias cAliasTMP
		SELECT COUNT(E1.E1_NUM) AS TIT 
		FROM %Table:SE1% E1;
		WHERE E1.%NotDel%
			%Exp:cWhere%
	
	ENDSQL
	
	If (cAliasTMP)->TIT > 0
		MsgAlert("Existem duplicatas em atraso para esse cliente. Considere compensar essa NCC por esse(s) t�tulo(s).","Aten��o!")
	EndIf 
	
EndIf


Return .T.