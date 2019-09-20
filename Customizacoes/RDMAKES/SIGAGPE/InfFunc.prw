//Dioni 14/12/11
//cadastrar as informações adicionais dos funcionários (é chamado no menu GPE -> funcionarios -> inf adic) Chamado - 369

User Function InfFunc()                               
Local _cTab	:= "ZA2"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ZA2->(DbSelectArea("ZA2"))  //a lupa para consulta é criada no configurador no campo -> em opçao -> con.padrao
AxCadastro("ZA2", "Cadastrar Informações Adicionais dos Funcionários")  //Funçao microsiga que faz a gravaçao automatica
Return Nil 
         