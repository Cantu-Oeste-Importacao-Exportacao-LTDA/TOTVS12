#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AltDtCT2 �Autor  �Flavio Dias        � Data �  20/12/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera a data de um lan�amento cont�bil, sem precisar abrir ���
���          �todos os lancamentos                                        ���
�������������������������������������������������������������������������͹��
���Uso       � Todas as empresas, alteracao da data de um lancto cont�bil ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AltLtCT2()
Local cAlias := "CT2"
Private cCadastro := "Altera Lote/Data do lan�amento cont�bil"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar", "U_ALTLTLAN", 0, 4})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return nil

User Function ALTLTLAN(cAlias, nOpc)
Local oDlg
Local oGet
Private cData := CT2->CT2_Data
Private cLote := "TS9901" //CT2->CT2_Lote
Private cDoc  := "000001" //CT2->CT2_Doc
Private cLinha:= CT2->CT2_Linha

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 250, 470 Dialog oDlg Title "Alterar Lote/Data/Doc do lan�amento"
@ 20, 10 SAY "Data:"
@ 20, 60 GET cData SIZE 40, 10
@ 35, 10 SAY "Lote:"
@ 35, 60 GET cLote SIZE 40, 10 Valid AjustLote()
@ 50, 10 SAY "Doc:"
@ 50, 60 GET cDoc SIZE 40, 10
@ 65, 10 SAY "Linha:"
@ 65, 60 GET cLinha SIZE 40, 10

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaLtCT2(), ODlg:End(), Nil }, {|| oDlg:End() })
Return Nil

// Faz a grava��o da Data no CT2
Static Function GravaLTCT2()
dbSelectArea("CT2")
RecLock("CT2", .F.)
CT2->CT2_Lote := cLote
CT2->CT2_Data := cData
CT2->CT2_Doc := cDoc
CT2->CT2_Linha := cLinha
MsUnlock()
Return Nil

// fun��o que faz o acerto dos dados baseando-se no lote, acertando o doc e a linha do lan�amento para aquela data

Static Function AjustLote()
Local cAliasCT2 := GetNextAlias()
BeginSql alias cAliasCT2
	select max(ct2_linha) as Linha from %table:ct2% ct2 
	where CT2.ct2_filial = %xFilial:CT2% and CT2.ct2_data = %Exp:cData%
		and CT2.ct2_lote = %Exp:cLote%
		and CT2.ct2_Doc = %Exp:cDoc%
		and CT2.d_e_l_e_t_ = ' '
EndSql
cLinha := PadL(AllTrim((cAliasCT2)->Linha), 3, "0")
cLinha := Soma1((cAliasCT2)->Linha)

(cAliasCT2)->(DbCloseArea())
Return .T.