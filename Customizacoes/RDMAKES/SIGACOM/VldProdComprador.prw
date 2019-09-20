#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT120OK    �Autor  �Flavio             � Data �  01/16/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o dos produtos digitados para verificar se o       ���
���          � usu�rio tem autorizacao para fazer o pedido.               ���
���            Chamado 2633�																							���
�������������������������������������������������������������������������͹��
���Uso       � Gen�rio                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ValPdComp()
Local nPosPrd   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C7_PRODUTO'})
Local lValido   := .T.
Local cGrupProd := ""
Local cGrupUser := ""
Local cCodUser  := __CUSERID
Local nX        := 0
cGrupUser := Posicione("SY1",3, xFilial("SY1") + cCodUser, "Y1_GRUPCOM")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

For nX :=1 To Len( aCols )
	cGrupProd := Posicione("SB1",1, xFilial("SB1") + aCols[nX][nPosPrd], "B1_GRUPCOM")
	
	// se estiver vazio o grupo do produto todos podem efetuar compra
	If (cGrupProd != cGrupUser) .And. !Empty(cGrupProd)
		lValido := .F.		
		Alert("Somente o grupo " + cGrupProd + " pode efetuar pedido de compra para o produto " + AllTrim(aCols[nX][nPosPrd]))
	EndIf
Next nX 

Return(lValido)