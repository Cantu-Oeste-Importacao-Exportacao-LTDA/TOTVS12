#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

User Function gatPrcVen()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If M->C6_PrcVen < DA1->DA1_PrcVen
   If MsgBox("ATEN��O!!! O valor digitado esta abaixo do valor de tabela!!! Deseja corrigir o Campo?", "Valor Unitario", "YESNO")
	  Return(DA1->DA1_PRCVEN)
   Else                                    	
	  Return(M->C6_PrcVen)  
   EndIf
Else
   Return(M->C6_PrcVen) 
EndIf