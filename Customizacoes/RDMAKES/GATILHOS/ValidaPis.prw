#include "Protheus.ch"
/*
  Dioni 09/02 para atender o chamado 368
  Aviso de Pis Duplicado -> disparado na trigger	
*/
User Function ValidaPis()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

SRA->(DbSelectArea("SRA"))
SRA->(DbSetOrder(6))

If SRA->(DbSeek(xFilial("SRA")+M->RA_PIS))
     MsgInfo("Pis j� existente")
Endif 

DbCloseArea()

Return