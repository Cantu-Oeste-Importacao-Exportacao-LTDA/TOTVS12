#include "Protheus.ch"
/*
  Dioni 09/02 para atender o chamado 368
  Aviso de Pis Duplicado -> disparado na trigger	
*/
User Function ValidaPis()  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

SRA->(DbSelectArea("SRA"))
SRA->(DbSetOrder(6))

If SRA->(DbSeek(xFilial("SRA")+M->RA_PIS))
     MsgInfo("Pis j� existente")
Endif 

DbCloseArea()

Return