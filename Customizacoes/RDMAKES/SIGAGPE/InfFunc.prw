//Dioni 14/12/11
//cadastrar as informa��es adicionais dos funcion�rios (� chamado no menu GPE -> funcionarios -> inf adic) Chamado - 369

User Function InfFunc()                               
Local _cTab	:= "ZA2"     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

ZA2->(DbSelectArea("ZA2"))  //a lupa para consulta � criada no configurador no campo -> em op�ao -> con.padrao
AxCadastro("ZA2", "Cadastrar Informa��es Adicionais dos Funcion�rios")  //Fun�ao microsiga que faz a grava�ao automatica
Return Nil 
         