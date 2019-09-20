#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BlqGrupoC  �Autor  �Flavio Dias        � Data �  04/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de Empresas x metas de deterioracao e despesas     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, cadastro de metas x empresas            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CADEMPBI()
Local cAlias := "SZN"
Private cCadastro := "Cadastro de metas por Empresas."
Private aRotina := {}
aAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Incluir"   , "AxInclui", 0, 3})
aAdd(aRotina, {"Alterar"   , "AxAltera", 0, 4})
aAdd(aRotina, {"Excluir"   , "AxDeleta", 0, 5})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil