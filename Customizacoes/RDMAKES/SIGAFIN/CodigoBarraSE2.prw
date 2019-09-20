#include "rwmake.ch"
/**************************************************************
 Função chamada após a gravação de cada duplicatas durante a inclusão do documento de entrada.
 A utilidade da mesma é para que o pagar possa gerar o cnab a pagar automático
 Só é chamada se o parametro MV_CBARSE2 estiver como .T., caso contrário a mesma nao é usada.
 *************************************************************/
User Function CDBARSE2()
Local aArea := GetArea()
Local lCodBar := SuperGetMV("MV_CBARSE2", ,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// se não tiver habilitado, nao pede para inserir o código de barras
if !lCodBar
	Return
EndIf

if SE2->(FieldPos("E2_CODBAR")) > 0
	DlgInclui()
elseif (inclui)
	Alert("Para informar o código de barras nas duplicatas a pagar é necessário criar o campo E2_CODBAR. Favor verificar!")
EndIf
RestArea(aArea)
Return

/*************************************************
 Função que exibe o diálogo para a entrada dos dados
 ************************************************/
Static Function DlgInclui()
Local oDlg
Local cCodBar := Space(48)

@ 100, 100 To 240, 670 Dialog oDlg Title "Código de barras do título"
@ 10, 10 SAY "Duplicata:" 
@ 10, 60 SAY SE2->E2_PREFIXO + " / " + SE2->E2_NUM +  " - " + SE2->E2_PARCELA + ;
			"    Vencto: " + DToC(SE2->E2_VENCTO) + "      Valor: " + AllTrim(Transform(SE2->E2_VALOR, "@E 999,999,999.99"))
@ 25, 10 SAY "Fornecedor:" 
@ 25, 60 SAY SE2->E2_FORNECE + "/" + SE2->E2_LOJA + " - " + ;
							AllTrim(Posicione("SA2", 01, xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NOME"))
@ 40, 10 SAY "Cód. Barra:"
@ 40, 60 GET cCodBar Size 200, 40 PICTURE "@!"

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| GravaE2(cCodBar), ODlg:End(), Nil }, {|| oDlg:End() })

Return

/*************************************************
 Função que grava o código de barras
 ************************************************/
Static Function GravaE2(cCodBar)
DbSelectArea("SE2")
RecLock("SE2")
	SE2->E2_CODBAR := cCodBar
MsUnlock()	
Return .T.