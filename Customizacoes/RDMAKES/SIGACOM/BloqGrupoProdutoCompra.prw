#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BlqGrupoC  �Autor  �Flavio Dias        � Data �  04/02/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de usuarios x Grupo que estao liberados para fazer ���
���          �compras ou classificar documentos.                          ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, cadastro de usuario x grupo de produto  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BlqGrupoC()
Local cAlias := "SZH"
Private cCadastro := "Permissao de Doc. Entrada por usuario X grupo de produto."
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