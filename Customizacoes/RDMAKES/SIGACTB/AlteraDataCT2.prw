#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AltDtCT2 �Autor  �Flavio Dias        � Data �  20/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera a data de um lan�amento cont�bil, sem precisar abrir ���
���          �todos os lancamentos                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, alteracao da data de um lancto cont�bil ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AltDtCT2()
Local cAlias := "CT2"
Private cCadastro := "Altera data do lan�amento cont�bil"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar", "U_ALTDTLAN", 0, 4})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil

User Function ALTDTLAN(cAlias, nOpc)
Local oDlg
Local oGet
Private cDataCT2 := CT2->CT2_DATA

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 200, 470 Dialog oDlg Title "Alterar data do lan�amento"
@ 20, 10 SAY "Data:" 
@ 20, 60 GET cDataCT2 SIZE 40, 10

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaDtCT2(), ODlg:End(), Nil }, {|| oDlg:End() })
Return Nil

// Faz a grava��o da Data no CT2
Static Function GravaDTCT2()
dbSelectArea("CT2")
RecLock("CT2", .F.)
CT2->CT2_DATA := cDataCT2
MsUnlock()
Return Nil