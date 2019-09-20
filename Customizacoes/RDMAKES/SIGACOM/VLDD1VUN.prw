#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VLDD1VUN  �Autor  �Gustavo Lattmann    � Data �  17/06/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o no campo do valor unit�rio para notas de devolu��o���
���          �n�o permitindo que valor unit�rio seja alterado.            ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 12121                                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function VLDD1VUN()

Local lRet := .T.
Private nPosNfOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_NFORI"})    
Private nPosSeOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_SERIORI"})
Private nPosVlUni	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_VUNIT"})  
Private nPosItOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_ITEMORI"})
Private nPosCodPr	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_COD"}) 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//Verifica se � devolu��o, formul�rio pr�prio e a nota de origem est� preenchida

If cTipo == "D" .And. cFormul == "S" .And. !Empty(aCols[n][nPosNfOri])
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3)) //FILIAL + DOC + SERIE + CLIENTE + LOJA + COD + ITEM
	SD2->(dbGoTop())
	If SD2->(MsSeek(xFilial("SD2") + aCols[n][nPosNfOri] + aCols[n][nPosSeOri] + CA100FOR + cLoja + aCols[n][nPosCodPr] + aCols[n][nPosItOri]))
		//Verifica se o valor unit�rio do item posicionado no acols � igual ao da nota de origem
		If aCols[n][nPosVlUni] != SD2->D2_PRCVEN 
    		ShowHelpDlg("Aten��o - VLDD1VUN",{"Valor da nota de devolu��o difere do valor da nota de origem."},5,{"O valor unit�rio da nota origem � "+;
    							   AllTrim(Transform(SD2->D2_PRCVEN,"@E 999,999,999.99")) +"."},5) 
    		lRet := .F.				
		EndIf
    Else
    	ShowHelpDlg("Aten��o - VLDD1VUN",{"A nota de origem informada n�o foi encontrada."},5,{"Verifique a nota de origem e s�rie informada."},5)
    EndIf
EndIf 


Return lRet


