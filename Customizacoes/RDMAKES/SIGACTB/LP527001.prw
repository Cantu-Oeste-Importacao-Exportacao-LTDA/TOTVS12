#include "protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LP527001	  �Autor  �Ricardo Catelli   � Data �  18/08/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte do LP FIN - CANC BAIXAS RECEBER - CARTEIRA           ���
���          � Tratativa para a conta contabil credito                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Lan�amento Padr�o - Financeiro / Cantu                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP527001(cPrefixo,cContaF,cTipo)     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

cDebit := IIF(cPrefixo&("TCD"),"1120201006", IIF(cPrefixo&("EMP"),cConta, IIF(cPrefixo&("FIN"),SED->ED_CONTA,FORMULA("LA2"))))
cDebit := IIF(cTipo$"CH","1120201002",IIF (cTipo$"NCC", SA1->A1_CONTA, 0))                                                                                                                                                                                                                   

Return (cDebit)