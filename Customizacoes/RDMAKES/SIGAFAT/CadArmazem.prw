/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadArmazem �Autor  �Flavio Dias        � Data �  10/08/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro de armaz�m com o codigo, descri��o e se exige senha���
���          �por grupo de produto.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, cadastro do armaz�m                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//User Function CadArmazem()
User Function Armazem()
Local cAlias := "SZA"       
Private cCadastro := "Cadastro de Armaz�m"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar"	, "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar"	, "AxVisual", 0, 2})
aAdd(aRotina, {"Incluir"	, "AxInclui", 0, 3})
aAdd(aRotina, {"Alterar"	, "AxAltera", 0, 4})
aAdd(aRotina, {"Excluir"	, "AxDeleta", 0, 5})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)

Return 