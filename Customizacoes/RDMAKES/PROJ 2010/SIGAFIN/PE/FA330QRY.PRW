#include "PROTHEUS.CH"
#include "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFA330QRY   บAutor  ณRafael Parma       บ Data ณ  20/01/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ P.E. utilizado para compor o filtro SQL durante o processo บฑฑ
ฑฑบ          ณ de sele็ใo de tํtulos para montagem da janela de compensa็ใoฑฑ
ฑฑบ          ณ a receber. Adiciona filtro sobre campo data de emissใo.    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------*
User Function FA330QRY()
*-------------------------*
Private cQUERY := PARAMIXB[1]
Private cBACKP := PARAMIXB[1]
Private dDATDE := ddatabase
Private dDATAT := ddatabase 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	/*ฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
	ฑฑ Definicao do Dialog e todos os seus componentes.                        ฑฑ
	ูฑฑภฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ*/
	
	If MsgBox("Deseja realizar filtro pela data de emissใo dos tํtulos?","Filtro","YESNO")
		
		DEFINE MSDIALOG oDlg FROM 010,100 TO 130,350 TITLE "Filtro por data de emissใo"  OF oMainWnd PIXEL
		@ 005, 005 TO 040, 122 OF oDlg  PIXEL
		
		@ 011,010 SAY "Emissใo De:"  SIZE 050,10 OF oDlg PIXEL 
		@ 010,060 MSGET oCLAS VAR dDATDE VALID(!VAZIO()) SIZE 050,09 OF oDlg PIXEL 
		@ 022,010 SAY "Emissใo At้:" SIZE 050,10 OF oDlg PIXEL 	
		@ 022,060 MSGET oCLAS VAR dDATAT VALID(!VAZIO()) SIZE 050,09 OF oDlg PIXEL 
		
		DEFINE SBUTTON FROM 046, 090 TYPE 1 ACTION (oDlg:End()) ENABLE OF oDlg PIXEL
		
		ACTIVATE MSDIALOG oDlg CENTERED
		
		cQUERY := SUBSTR(cBACKP,0,AT("ORDER",cBACKP)-1)
		cQUERY += " AND E1_EMISSAO BETWEEN '" + dtos(dDATDE) + "' AND '" + dtos(dDATAT) + "' "   
		cQUERY += SUBSTR(cBACKP,AT("ORDER",cBACKP)-1,LEN(cBACKP))
	
	EndIf
		
Return (cQUERY) 
