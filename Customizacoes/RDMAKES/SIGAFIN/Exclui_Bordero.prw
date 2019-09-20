#include "rwmake.ch"
#include "topconn.ch"

User Function ExcBordero()
Local cPerg := PadR("BORDER", len(SX1->X1_GRUPO))
Local aArea := GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSx1(cPerg)
if (Pergunte(cPerg, .T.))
	SEA->(DbSetOrder(01))
	SEA->(DbSeek(xFilial("SEA") + MV_PAR01))
	// Exclui os registros do SEA
	While (SEA->EA_NUMBOR == MV_PAR01)
		// carteira zero
		// sai portador, agencia, conta deposito e fica nosso numero
		RecLock("SEA", .F.)
		SEA->(dbDelete())
		SEA->(MsUnlock())
		SEA->(DbSeek(xFilial("SEA") + MV_PAR01))
	EndDo
	// Busca os registros do SE1
	dbselectarea("SE1")
	dbSetOrder(12)
	// Localiza o título pelo bordero
	SE1->(DbSeek(xFilial("SE1") + MV_PAR01))
	// limpa os dados do bordero
	While SE1->E1_FILIAL + SE1->E1_NUMBOR == xFilial("SE1") + MV_PAR01
		RecLock("SE1", .F.)
		E1_PORTADO := ""
		E1_AGEDEP := ""
		E1_DATABOR := StoD("")
		E1_MOVIMEN := StoD("")
		E1_SITUACA := "0"
		E1_CONTA := ""
		E1_NUMBOR := ""
		MsUnlock()
		// localiza novamente
		SE1->(DbSeek(xFilial("SE1") + MV_PAR01))
	EndDo
	dbSelectArea("SE1")	
	MsgInfo("Bordero excluído com sucesso!")
EndIf
RestArea(aArea)
Return .T.

Static Function AjustaSx1(cPerg)
Local cPerg2 := PadR(cPerg, Len(SX1->X1_GRUPO))
PutSx1(cPerg,"01","Nro do Bordero","Nro do Bordero","Nro do Bordero", "mv_nrobor", "C", 6, 0, 0,"G", "", "", "", "","MV_PAR01")
return nil