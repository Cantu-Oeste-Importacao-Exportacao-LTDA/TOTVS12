#include "rwmake.ch" 
#INCLUDE "TOPCONN.CH"  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณExcSB9    บAutor  ณMicrosiga           บ Data ณ  07/21/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExclui o ๚ltimo fechamento e altera tamb้m o parametro      บฑฑ
ฑฑบ          ณmv_ulmes para a data do fechamento que ficarแ               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ExcSB9()
Local cData
Local oDlg
Local cIndexName := ''
Local cIndexKey := ''
Local cFilter := ''    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

cData := GetDtFecha()

dbSelectArea('SB9')
cIndexName := Criatrab(Nil,.F.)
cIndexKey  := "B9_FILIAL+B9_COD+B9_LOCAL"
cFilter    := "B9_DATA = STOD('" + cData + "') .And. B9_FILIAL = '" + xFilial('SB9') + "'"
IndRegua("SB9", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
dbSelectArea("SB9")

@ 001,001 TO 400,700 DIALOG oDlg TITLE "Dados do Fechamento. Excluir?"
@ 001,001 TO 170,350 BROWSE "SB9"
@ 180,020 SAY 'Data do Fechamento: ' + DToC(SToD(cData))
@ 180,310 BMPBUTTON TYPE 01 ACTION (ExcFechB9(),Close(oDlg))
@ 180,280 BMPBUTTON TYPE 02 ACTION (Close(oDlg))
ACTIVATE DIALOG oDlg CENTERED
//ACTIVATE DIALOG oDlg CENTER ON INIT ;      
//EnchoiceBar(oDlg,{|| ExcFechB9(), ODlg:End(), Nil }, {|| oDlg:End() })

dbSelectArea('SB9')
RetIndex("SB9")
fErase(cIndexName+OrdBagExt())
Return Nil


/************************************************************
 Busca a ๚ltima data de fechamento para a filial informada
/***********************************************************/
Static Function GetDtFecha()
Local cAlias := GetNextAlias()
Local cData := ''
// busca a ๚ltima data de fechamento
BeginSql Alias cAlias
  select MAX(B9_DATA) AS B9_DATA FROM %Table:SB9% 
  WHERE (D_E_L_E_T_ <> '*')
  AND (B9_FILIAL = %xFilial:SB9%)
EndSql

cData := (cAlias)->B9_DATA
dbCloseArea(cAlias)
Return cData

// Fun็ใo que exclui o fechamento do sb9, para todos os registros filtrados
Static Function ExcFechB9()
// vai para o topo para garantir que esteja no primeiro registro
// estแ filtrado e nao tem problema quanto a isso
SB9->(DbGoTop())
While SB9->(!Eof())
	RecLock('SB9', .F.)
	dbDelete()
	MsUnlock()
	SB9->(DbSkip())
EndDo

// obt้m a ๚ltima data de fechamento vแlida
cData := GetDtFecha()

MsgInfo('Data do Fechamento alerada para: ' + DToC(SToD(cData)))
// altera a data de fechamento no parametro mv_ulmes
SetMV('MV_ULMES', cData)
Return Nil