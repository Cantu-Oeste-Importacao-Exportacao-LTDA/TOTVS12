#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �BlqUserCmp �Autor  �Flavio Dias        � Data �  20/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de usuarios que estao bloqueados para fazer compra ���
���          �sem pedido.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, cadastro de usuario bloqueado           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function BlqUserCmp()
Local cAlias := "SZK"
Private cCadastro := "Usuarios que n�o podem Incluir Doc. Entrada sem Pedido"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Incluir", "AxInclui", 0, 3})
aAdd(aRotina, {"Alterar", "AxAltera", 0, 4})
aAdd(aRotina, {"Excluir", "AxDeleta", 0, 5})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil