#include "Protheus.ch"
/*
  Dioni 09/02 para atender o chamado 368
  Aviso de Pis Duplicado -> disparado na trigger	
*/
User Function ValidaPis()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SRA->(DbSelectArea("SRA"))
SRA->(DbSetOrder(6))

If SRA->(DbSeek(xFilial("SRA")+M->RA_PIS))
     MsgInfo("Pis já existente")
Endif 

DbCloseArea()

Return