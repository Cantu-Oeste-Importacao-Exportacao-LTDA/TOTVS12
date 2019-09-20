#include "rwmake.ch"        
//#include "protheus.ch" 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PGTOSE2   �Autor  �Gustavo             � Data �  02/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel por setar forma de pagamento no titulo   ���
���          �a pagar. Executa apos Documento Entrada                     ���
�������������������������������������������������������������������������͹��
���Uso       � Cantu                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function PgtoSE2()
Local aArea := GetArea()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If SE2->(FieldPos("E2_FORMPAG")) > 0
	DlgInclui()
Else
	Alert("Para informar o c�digo de barras nas duplicatas a pagar � necess�rio criar o campo E2_FORMPAG. Favor verificar!")
EndIf

RestArea(aArea)

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DlgInclui   �Autor  �Gustavo Lattmann  � Data �  02/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria a interface para informar a forma de pagamento        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function DlgInclui()
Local oDlg
Local cFormPg := Space(3)   
Local bCancel := {|| Iif(!Empty(cFormPg),MsgInfo("Clique em confirmar!"),MsgInfo("Informe a forma de pagamento!")) }            
Local bOk	  := {|| GravaE2(cFormPg), ODlg:End(), Nil }

//DEFINE MSDIALOG oDlg TITLE "Financeiro" STYLE DS_MODALFRAME From 8,0 To 28,80 
@ 100, 100 To 400, 750 Dialog oDlg Title "Financeiro" 
@ 35, 35 SAY "Duplicata:" 
@ 35, 80 SAY SE2->E2_NUM + "/" + AllTrim(SE2->E2_PREFIXO) +   " - " + SE2->E2_PARCELA + ;
			"    Vencto: " + DToC(SE2->E2_VENCTO) + "      Valor: " + AllTrim(Transform(SE2->E2_VALOR, "@E 999,999,999.99"))
@ 50, 35 SAY "Fornecedor:" 
@ 50, 80 SAY AllTrim(SE2->E2_FORNECE) + "/" + SE2->E2_LOJA + " - " + ;
							AllTrim(Posicione("SA2", 01, xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NOME"))
@ 65, 35 SAY "Forma Pagamento:"
@ 65, 80 GET cFormPg Size 40, 40 PICTURE "@!" F3 "24" VALID ExistCpo("SX5","24"+cFormPg)

ACTIVATE DIALOG oDlg CENTER ON INIT  ;      
EnchoiceBar(oDlg, bOk, bCancel)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GravaE2   �Autor  �Gustavo Lattmann  � Data �  02/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Realiza a grava��o na SE2 da forma de pagamento             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GravaE2(cFormPg)
DbSelectArea("SE2")
RecLock("SE2")
	SE2->E2_FORMPAG := cFormPg
MsUnlock()	
Return 