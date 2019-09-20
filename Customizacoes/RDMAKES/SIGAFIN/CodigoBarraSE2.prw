#include "rwmake.ch"
/**************************************************************
 Fun��o chamada ap�s a grava��o de cada duplicatas durante a inclus�o do documento de entrada.
 A utilidade da mesma � para que o pagar possa gerar o cnab a pagar autom�tico
 S� � chamada se o parametro MV_CBARSE2 estiver como .T., caso contr�rio a mesma nao � usada.
 *************************************************************/
User Function CDBARSE2()
Local aArea := GetArea()
Local lCodBar := SuperGetMV("MV_CBARSE2", ,.F.)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// se n�o tiver habilitado, nao pede para inserir o c�digo de barras
if !lCodBar
	Return
EndIf

if SE2->(FieldPos("E2_CODBAR")) > 0
	DlgInclui()
elseif (inclui)
	Alert("Para informar o c�digo de barras nas duplicatas a pagar � necess�rio criar o campo E2_CODBAR. Favor verificar!")
EndIf
RestArea(aArea)
Return

/*************************************************
 Fun��o que exibe o di�logo para a entrada dos dados
 ************************************************/
Static Function DlgInclui()
Local oDlg
Local cCodBar := Space(48)

@ 100, 100 To 240, 670 Dialog oDlg Title "C�digo de barras do t�tulo"
@ 10, 10 SAY "Duplicata:" 
@ 10, 60 SAY SE2->E2_PREFIXO + " / " + SE2->E2_NUM +  " - " + SE2->E2_PARCELA + ;
			"    Vencto: " + DToC(SE2->E2_VENCTO) + "      Valor: " + AllTrim(Transform(SE2->E2_VALOR, "@E 999,999,999.99"))
@ 25, 10 SAY "Fornecedor:" 
@ 25, 60 SAY SE2->E2_FORNECE + "/" + SE2->E2_LOJA + " - " + ;
							AllTrim(Posicione("SA2", 01, xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NOME"))
@ 40, 10 SAY "C�d. Barra:"
@ 40, 60 GET cCodBar Size 200, 40 PICTURE "@!"

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaE2(cCodBar), ODlg:End(), Nil }, {|| oDlg:End() })

Return

/*************************************************
 Fun��o que grava o c�digo de barras
 ************************************************/
Static Function GravaE2(cCodBar)
DbSelectArea("SE2")
RecLock("SE2")
	SE2->E2_CODBAR := cCodBar
MsUnlock()	
Return .T.