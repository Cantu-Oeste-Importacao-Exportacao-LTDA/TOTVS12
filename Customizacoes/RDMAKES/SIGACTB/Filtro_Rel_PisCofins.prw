#INCLUDE "RWMAKE.CH"
User Function MT996QRY()

Local cSql := ParamIXB[1]
Local cTipo := ParamIXB[2]
Local lOk := .F.
Local oDlg
Private cSegIni := SD2->D2_CLVL
Private cSegFim := SD2->D2_CLVL  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//Diálogo
@ 100, 100 To 300, 470 Dialog oDlg Title "Filtrar por Segmento"
@ 20, 10 SAY "Segmento de:"
@ 20, 60 GET cSegIni SIZE 40, 10 
@ 35, 10 SAY "Segmento até:"
@ 35, 60 GET cSegFim SIZE 40, 10 
@ 70, 50 BMPBUTTON TYPE 01 ACTION (lOk := .T.,Close(oDlg))
@ 70, 85 BMPBUTTON TYPE 02 ACTION (lOk := .F.,Close(oDlg))
 
 ACTIVATE DIALOG oDlg CENTERED
//ACTIVATE DIALOG oDlg CENTER ON INIT EnchoiceBar(oDlg,{|| 0, ODlg:End(), Nil }, {|| oDlg:End() })


//se retornou ok, e variaveis <> ' ' muda o sql
if (lOk) 
	if cTipo == 1  //Saída
	 	cQuery += " AND D2_CLVL BETWEEN '"+cSegIni+"' AND '"+cSegFim+"' "
	else 
	  cQuery += " AND D1_CLVL BETWEEN '"+cSegIni+"' AND '"+cSegFim+"' "
	EndIf
EndIf

Return cQuery

