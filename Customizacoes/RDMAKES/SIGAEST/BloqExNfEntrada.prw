User Function A100DEL()
Local lExclui := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (AllTrim(SF1->F1_ESPECIE) == "SPED") .And. (SF1->F1_FORMUL == "S")
	if (SF1->F1_EMISSAO < (Date() - 6))
		MsgInfo("Nota fiscal n�o pode ser exclu�da pois passou o prazo para cancelamento da Nota Fiscal Eletr�nica", "Aten��o")
		lExclui := .F.
	EndIf
	If FindFunction("U_ValidExNF")
		lExclui :=	U_ValidExNF(SF1->F1_ESPECIE, SF1->F1_SERIE+SF1->F1_DOC, .T.)
	EndIf
EndIf
// Afill Inicio
If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF n�o pode ser excluida pois foi gerada pelo Controle Geral (Importa��o). Exclua a NF pela Op��o de Importa��o \ Controle Geral...","Sem acesso")
	lExclui := .F.
EndIf
// Afill fim

Return lExclui