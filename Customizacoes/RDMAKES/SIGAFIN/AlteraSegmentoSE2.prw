#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AltDtCT2 �Autor  �Dioni                � Data �  03/10/08   ���
�������������������������������������������������������������������������͹��
���Desc.    �Altera           um lan�amento de Contas, sem precisar abrir ���
���          �todos os lancamentos                                        ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ManSE2()
Local cAlias := "SE2"
Private cCadastro := "Manuten��o de Segmento do Lan�amento de Contas a Pagar"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar", "U_ALTSEGMSE2", 0, 4})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil

User Function ALTSEGMSE2(cAlias, nOpc)
Local oDlg
Local oGet
Private cSE2_CCD    := SE2->E2_CCD
Private cSE2_CLVLDB := SE2->E2_CLVLDB
Private cSE2_CCC    := SE2->E2_CCC
Private cSE2_CLVLCR := SE2->E2_CLVLCR
Private cSE2_NATUREZ:= SE2->E2_NATUREZ

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 300, 470 Dialog oDlg Title "Alterar Segmento do Lan�amento de Contas a Pagar"
@ 34, 10 SAY "C.Custo Deb:"  
@ 31, 50 GET cSE2_CCD f3 "CTT" valid (empty(cSE2_CCD) .or. existCpo("CTT",cSE2_CCD)) SIZE 40, 10 

@ 49, 10 SAY "Segmento Deb:"
@ 45, 50 GET cSE2_CLVLDB F3 "CTH" valid (empty(cSE2_CLVLDB) .or. existCpo("CTH",cSE2_CLVLDB)) SIZE 40, 20

@ 64, 10 SAY "C.Custo Crd:"
@ 60, 50 GET cSE2_CCC F3 "CTT" valid (empty(cSE2_CCC) .or. existCpo("CTT",cSE2_CCC)) SIZE 40, 30

@ 79, 10 SAY "Segmento Crd:" 
@ 75, 50 GET cSE2_CLVLCR F3 "CTH" valid (empty(cSE2_CLVLCR) .or. existCpo("CTH",cSE2_CLVLCR)) SIZE 40, 40

@ 92, 10 SAY "Natureza:" 
@ 89, 50 GET cSE2_NATUREZ F3 "SED" valid (empty(cSE2_NATUREZ) .or. existCpo("SED",cSE2_NATUREZ)) SIZE 44, 50

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaSGSE2(), ODlg:End(), Nil }, {|| oDlg:End() })
Return Nil

// Faz a grava��o no SE2
Static Function GravaSGSE2()
dbSelectArea("SE2")
RecLock("SE2", .F.)
SE2->E2_CCD     := cSE2_CCD
SE2->E2_CLVLDB  := cSE2_CLVLDB
SE2->E2_CCC     := cSE2_CCC	
SE2->E2_CLVLCR  := cSE2_CLVLCR
SE2->E2_NATUREZ := cSE2_NATUREZ
MsUnlock()
Return Nil