#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


User Function CADREGANTU()   
 Local aRotAdic :={} 
 aadd(aRotAdic,{ "Adicional","U_Adic", 0 , 6 })
 AxCadastro("SZ2", "Regiao", "U_DelOk()", "U_COK()", aRotAdic, , , , , , , , , )  
Return(.T.)                        

User Function DelOk()  
 MsgAlert("Registro excluido com sucesso.") 
Return .t.

User Function COK()    
/*MsgAlert("Clicou botao OK")*/ 
Return .t.      
User Function Adic()   
MsgAlert("Rotina adicional") 
Return