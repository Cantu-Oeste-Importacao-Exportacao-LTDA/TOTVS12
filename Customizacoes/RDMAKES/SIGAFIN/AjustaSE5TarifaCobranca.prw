#include "rwmake.ch"
#include "TopConn.ch"

User Function AjustaSE5()
Local aIndexSE5 := {}
Local cFiltroInt := "E5_MOEDA = '  ' .AND.  E5_TIPODOC = 'DB' .AND. E5_CLVLDB = '         ' .AND. E5_CLVLCR = '         '"
Local aArea := GetArea()

//здддддддддддддддддддддддддддддддддддддддддддддддддддд
//ЁChama funГЦo para monitor uso de fontes customizadosЁ
//юдддддддддддддддддддддддддддддддддддддддддддддддддддд
U_USORWMAKE(ProcName(),FunName())

// dbSelectArea("SE5")
Return // nao faz nada

BEGINSQL ALIAS "TMPSE5"
	SELECT SE5.R_E_C_N_O_ AS RNO, E1_CLVLCR, E1_CCC, E5_NUMERO FROM %TABLE:SE5% SE5
	INNER JOIN %TABLE:SE1% SE1 ON (E1_TIPO = E5_TIPO AND E1_PREFIXO = E5_PREFIXO AND E1_PARCELA = E5_PARCELA AND E1_NUM = E5_NUMERO AND E1_FILIAL = E5_FILIAL)
	WHERE SE5.%NOTDEL% AND SE1.%NOTDEL% AND E5_MOEDA = ' ' AND E5_TIPODOC = 'DB' AND E5_CLVLDB = ' ' AND E5_CLVLCR = ' '
		AND E1_CLVLCR <> ' '
	AND E1_FILIAL = %XFILIAL:SE1%
	ORDER BY RNO
ENDSQL

dbGoTop()

Processa({|| CorrigeSE5()}, "Atualizando registros")

Return

// faz a atualizacao do segmento e centro de custo no SE5
Static Function CorrigeSE5()

nTotal := TMPSE5->(RecCount())

ProcRegua(nTotal)
nCount := 0
While TMPSE5->(!Eof())
	nCount++
	SE5->(dbGoTo(TMPSE5->RNO))
	
	RecLock("SE5", .F.)
	SE5->E5_CLVLDB := TMPSE5->E1_CLVLCR
	SE5->E5_CCD := TMPSE5->E1_CCC
	SE5->(MsUnlock())
	
	IncProc("Processados " + Str(nCount, 8, 0) + " registros")
	
	TMPSE5->(dbSkip())
EndDo

MsgInfo("Atualizados " + Str(nCount, 8, 0) + " registros de tarifa de cobranГa.", "Ajusta Tarifa BancАria")

TMPSE5->(dbCloseArea())

Return