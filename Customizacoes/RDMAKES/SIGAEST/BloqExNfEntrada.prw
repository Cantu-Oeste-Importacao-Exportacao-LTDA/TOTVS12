User Function A100DEL()
Local lExclui := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (AllTrim(SF1->F1_ESPECIE) == "SPED") .And. (SF1->F1_FORMUL == "S")
	if (SF1->F1_EMISSAO < (Date() - 6))
		MsgInfo("Nota fiscal não pode ser excluída pois passou o prazo para cancelamento da Nota Fiscal Eletrônica", "Atenção")
		lExclui := .F.
	EndIf
	If FindFunction("U_ValidExNF")
		lExclui :=	U_ValidExNF(SF1->F1_ESPECIE, SF1->F1_SERIE+SF1->F1_DOC, .T.)
	EndIf
EndIf
// Afill Inicio
If !Empty(SF1->F1_HAWB) .AND. Alltrim(FunName()) <> "DSBBROW"
	MsgStop("NF não pode ser excluida pois foi gerada pelo Controle Geral (Importação). Exclua a NF pela Opção de Importação \ Controle Geral...","Sem acesso")
	lExclui := .F.
EndIf
// Afill fim

Return lExclui