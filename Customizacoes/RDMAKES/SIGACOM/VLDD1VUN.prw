#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VLDD1VUN  ºAutor  ³Gustavo Lattmann    º Data ³  17/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Validação no campo do valor unitário para notas de devoluçãoº±±
±±º          ³não permitindo que valor unitário seja alterado.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado 12121                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VLDD1VUN()

Local lRet := .T.
Private nPosNfOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_NFORI"})    
Private nPosSeOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_SERIORI"})
Private nPosVlUni	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_VUNIT"})  
Private nPosItOri	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_ITEMORI"})
Private nPosCodPr	:= aScan(aHeader,{|x| AllTrim(x[2])== "D1_COD"}) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Verifica se é devolução, formulário próprio e a nota de origem está preenchida

If cTipo == "D" .And. cFormul == "S" .And. !Empty(aCols[n][nPosNfOri])
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3)) //FILIAL + DOC + SERIE + CLIENTE + LOJA + COD + ITEM
	SD2->(dbGoTop())
	If SD2->(MsSeek(xFilial("SD2") + aCols[n][nPosNfOri] + aCols[n][nPosSeOri] + CA100FOR + cLoja + aCols[n][nPosCodPr] + aCols[n][nPosItOri]))
		//Verifica se o valor unitário do item posicionado no acols é igual ao da nota de origem
		If aCols[n][nPosVlUni] != SD2->D2_PRCVEN 
    		ShowHelpDlg("Atenção - VLDD1VUN",{"Valor da nota de devolução difere do valor da nota de origem."},5,{"O valor unitário da nota origem é "+;
    							   AllTrim(Transform(SD2->D2_PRCVEN,"@E 999,999,999.99")) +"."},5) 
    		lRet := .F.				
		EndIf
    Else
    	ShowHelpDlg("Atenção - VLDD1VUN",{"A nota de origem informada não foi encontrada."},5,{"Verifique a nota de origem e série informada."},5)
    EndIf
EndIf 


Return lRet


