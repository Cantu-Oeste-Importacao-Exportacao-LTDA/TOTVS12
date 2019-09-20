#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
����������������������������������c�������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � GatSB1   � Autor � Adriano Novachaelley Data �  29/11/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilhos para atualiza��o e dados do cadastro de produtos  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � CADASTRO DE PRODUTOS                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GatSB1()
Local _cRet	:= ""
Local _aArea := GetArea()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName()) 


If ALLTRIM(FUNNAME()) != "RJCOMP06"
	Do Case
		Case AllTrim(ReadVar()) == "M->B1_GRUPO"
			cSql := "SELECT MAX(SB1.B1_COD) B1_COD 	"
			cSql += "FROM " + RetSqlName("SB1")+" SB1	"
			cSql += "WHERE SB1.D_E_L_E_T_ <> '*' 		"
			cSql += "AND SB1.B1_FILIAL = '" + xFilial('SB1') + "'	"
			cSql += "AND SubStr(SB1.B1_COD,1,4) = '"+SubStr(M->B1_GRUPO,1,4)+"' "
			TCQUERY cSql NEW ALIAS "QRYSB1"
			   
			_cRet := M->B1_GRUPO+StrZero(Val(SubStr(QRYSB1->B1_COD,5,4))+1,4)
			DbSelectArea("QRYSB1")
			QRYSB1->(DbCloseArea())
	End Case
Else
	_cRet := M->B1_COD
EndIf

RestArea(_aArea)

Return(_cRet)