#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDF1CON  �Autor  �Edison G. Barbieri    � Data �  23/10/18 ���
�������������������������������������������������������������������������͹��
���Desc.  �Valida��o de condicao de pagamento documento de entrada. Caso  ���
���       �a cond de pagamento do cadastro de forncedor esteja em branco  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VLDF1CON()
Local lRet := .T. 
Local aArea   := GetArea()
Local cFormpg := ALLTRIM(SA2->A2_FORMPAG) 
Local cCondpg := ALLTRIM(SA2->A2_COND) 


DbSelectArea("SA2")
DbSetOrder(1)
dbGoTop()

if   !Alltrim(M->cTipo) $ "D/I/P/B/C" .and. ((Empty(cFormpg) .or. Empty(cCondpg)))
		MsgBox("Divergencia na forma de pagamento para este fornecedor, favor entrar em contato com o cadastro, tel: (46) 2101-4084, ap�s ajuste refa�a o lan�amento!","Alerta","ERRO")		
        lRet := .F.	
	EndIf 
	
SA2->(MsUnlock())
RestArea(aArea)

Return lRet
