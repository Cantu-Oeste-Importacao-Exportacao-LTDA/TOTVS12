#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONSULTAPESOPRODUTO_PEDIDO�Autor  �M   � Data �  07/27/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE executado no pedido de venda, para criar mais op��es     ���
���          �na enchoicebar                                              ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function A410CONS()


Local cTpOp		:= IIF(INCLUI .OR. ALTERA, "1", "2")

Local alarea	:= GetArea()
Local alareaSC5	:= SC5->(GetArea())
aBotoes := {}
AAdd(aBotoes,{ "NOTE", {|| Visual_Peso() }, "Calc. Peso" } )
AAdd(aBotoes,{ "Rateio Cartao", {|| U_CP09RAT(cTpOp) }, "Rateio Cartao" } )

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

RestArea(alarea)
RestArea(alareaSC5)

Return(aBotoes)


Static Function Visual_Peso()
local NPed := N
lOCAL nPesLiq := 0
Local nPesBru := 0
Local aProdutos := {}
/*������������������������������������������������������������������������ٱ�
�� Declara��o de Variaveis Private dos Objetos                             ��
ٱ�������������������������������������������������������������������������*/
SetPrvt("oDlg1","oLBox1","oSBtn1")

for j := 1 to Len(aCols)
	If posicione("SB1",1,xFilial("SB1")+aCols[j,2],"B1_PESO") > 0
		AADD(aProdutos,aCols[j,2]+"-"+aCols[j,3] + Space(10) + Alltrim(Str(aCols[j,4]*posicione("SB1",1,xFilial("SB1")+aCols[j,2],"B1_PESO"),10,4)))
//		nPesLiq += (posicione("SB1",1,xFilial("SB1")+aCols[j,2],"B1_PESO") * aCols[j,7])
//		nPesBru += (posicione("SB1",1,xFilial("SB1")+aCols[j,2],"B1_PESBRU") * aCols[j,7])
	Endif
Next



/*������������������������������������������������������������������������ٱ�
�� Definicao do Dialog e todos os seus componentes.                        ��
ٱ�������������������������������������������������������������������������*/
oDlg1      := MSDialog():New( 088,232,406,819,"Consulta Peso",,,.F.,,,,,,.T.,,,.T. )
oLBox1     := TListBox():New( 008,008,,aProdutos,272,128,,oDlg1,,CLR_BLACK,CLR_WHITE,.T.,,,,"",,,,,,, )
//oSBtn1     := SButton():New( 140,256,1,,oDlg1,,"" )
//oSBtn1     := SButton():New( 140,256,1,Return,oDlg1,,"", )
//@ 140,10 BUTTON oBtn2 PROMPT "Stop" OF oDlg1 PIXEL ACTION lStop:=.T.


oDlg1:Activate(,,,.T.)

return

/*/{Protheus.doc} CP09RAT
Fun��o para chamada do Rateio de Cart�o
@author Jonatas Oliveira | www.compila.com.br
@since 03/01/2019
@version 1.0
/*/
User Function CP09RAT(cTpOp) 	
	
	IF cTpOp == "1"
		DBSELECTAREA("ZE1")
		ZE1->(DBSETORDER(1))

		IF ZE1->(DBSEEK(M->C5_FILIAL + M->C5_NUM ))
			FWExecView("Rateio Cartao",  "CP09005",  4,  /*oDlg*/, {|| .T. } /*bCloseOnOk*/,  {|| lFIN072 := .T. } /*bOk*/, /* nPercReducao*/, /*aEnableButtons*/, {|| lFIN072 := .F.,.T. } /*bCancel*/ )
		ELSE
			FWExecView("Rateio Cartao",  "CP09005",  4,  /*oDlg*/, {|| .T. } /*bCloseOnOk*/,  {|| lFIN072 := .T. } /*bOk*/, /* nPercReducao*/, /*aEnableButtons*/, {|| lFIN072 := .F.,.T. } /*bCancel*/ )
		ENDIF 

	ELSE
		FWExecView("Rateio Cartao",  "CP09005",  1,  /*oDlg*/, {|| .T. } /*bCloseOnOk*/,  {|| lFIN072 := .T. } /*bOk*/, /* nPercReducao*/, /*aEnableButtons*/, {|| lFIN072 := .F.,.T. } /*bCancel*/ )
	ENDIF  
	
Return()