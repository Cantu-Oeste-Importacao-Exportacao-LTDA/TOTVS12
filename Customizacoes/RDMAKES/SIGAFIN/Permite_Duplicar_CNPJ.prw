#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AAFAT17  � Autor � Antonio CArlos     � Data � 01/10/2002  ���
�������������������������������������������������������������������������͹��
���Descricao � EXECBLOCK ACIONADO NO SX3 DO CGC PARA PERMITIR A DUPLICACAO���
���          � DE CPF EM CASOS ESPECIFICOS (AVIARIOS)                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico ANHAMBI                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ValidCPF()

Local _Retorno := .t.    

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If Len(AllTrim(M->A1_CGC)) <= 11
   _Cod    := M->A1_COD
   _CodLoc := M->A1_COD
   dbSelectArea("SA1")
   dbSetOrder(3)
   If dbSeek(xFilial("SA1") + M->A1_CGC)
      _CodLoc := SA1->A1_COD   
      MsgBox("CPF ja existente!!!")
   EndIf
   If _Cod <> _CodLoc
      _Retorno := .f.
      MsgBox("Voce esta lancando um CPF duplicado para Clientes DIFERENTES !!! Processo nao permitido.") 
   Endif 
Endif   

Return _Retorno



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ValidCPF2 � Autor � Cleber Pereira    � Data � 17/12/2002  ���
�������������������������������������������������������������������������͹��
���Descricao � EXECBLOCK ACIONADO NO SX3 DO CGC PARA PERMITIR A DUPLICACAO���
���          � DE CPF EM CASOS ESPECIFICOS DE FORNECEDORES (FAZENDAS)     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico ANHAMBI                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ValCPF2()

Local _Retorno := .t.  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If Len(AllTrim(M->A2_CGC)) <= 11
   _Cod    := M->A2_COD
   _CodLoc := M->A2_COD
   dbSelectArea("SA2")
   dbSetOrder(3)
   If dbSeek(xFilial("SA2") + M->A2_CGC)
      _CodLoc := SA2->A2_COD   
      MsgBox("CPF j� existente!!!")
   EndIf
   If _Cod <> _CodLoc
      _Retorno := .f.
      MsgBox("Voc� est� lan�ando um CPF duplicado para Fornecedores DIFERENTES !!! Processo n�o permitido.") 
   Endif 
Endif   

Return _Retorno