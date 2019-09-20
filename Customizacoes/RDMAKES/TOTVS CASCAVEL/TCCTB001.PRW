#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณTCCTB001  บAutor  ณMarcelo Joner        บ Data ณ 04/04/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRdmake o qual disponibiliza interface utilizada para deter- บฑฑ
ฑฑบ          ณminar configura็ใo dos parโmetros MV_ATUSAL e MV_SLDCOMP.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especifico Totvs Cascavel                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function TCCTB001()

Local nOpcao		:= 2
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aArea			:= GetArea()
Local cOpcao		:= ""
Local cMV_ATUSAL	:= GETMV("MV_ATUSAL",, "S")
Local cMV_CTBSER	:= GETMV("MV_CTBSER",, "1")
Local cMV_SLDCOMP	:= GETMV("MV_SLDCOMP",, "S")

Private cCadastro	:= "Saldos Contแbeis"

cOpcao := IIF(ALLTRIM(cMV_CTBSER) == "1", "Sim", "Nใo")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณ Montagem dos parโmetros para cria็ใo da tela de exibi็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
aSize := MsAdvSize()
AADD(aObjects, {100, 100, .T., .F.})
aInfo := {aSize[1], aSize[2], aSize[3] / 2, aSize[4] / 2, 5, 5}
aPosObj := MsObjSize(aInfo, aObjects, .T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo do dialog e demais componentesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
oDlgSld := MSDialog():New( 088,232,220,800,cCadastro,,,.F.,,,,,,.T.,,,.T. )
oDlgSld:bInit := {|| ENCHOICEBAR(oDlgSld,{|| (nOpcao := 1, oDlgSld:End())},{|| oDlgSld:End()},.F.,{})}
	oSay1 := TSay():New(043,aPosObj[1,2]+005,{|| "Habilita Atualiza็ใo Automแtica dos Saldos Contแbeis ?"},oDlgSld,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,200,008)
	oCBox1:= TComboBox():New(042, aPosObj[1,2] + 150,{|u| if(PCount()>0, cOpcao:=u, cOpcao)},{"Sim", "Nใo"},040,010,oDlgSld,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,  ,,,,, )
oDlgSld:Activate(,,,.T.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAtualiza os parโmetros caso confirmou เ interfaceณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If nOpcao == 1
	PUTMV("MV_ATUSAL", IIF(ALLTRIM(cOpcao) == "Sim", "S", "N"))
	PUTMV("MV_CTBSER", IIF(ALLTRIM(cOpcao) == "Sim", "1", "2"))
	PUTMV("MV_SLDCOMP", IIF(ALLTRIM(cOpcao) == "Sim", "S", "N"))
EndIf

RestArea(aArea)

Return