#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
                           
//-- ATUALIZA SITUACAO DO TITULO A RECEBER DE 2 P/ 1
*----------------------------*
User Function RJATUST()
*----------------------------*
Private cPRFDE := Space(TAMSX3("E1_PREFIXO")[1])
Private cNUMDE := Space(TAMSX3("E1_NUM")[1])
Private cPARDE := Space(TAMSX3("E1_PARCELA")[1])
Private cTIPDE := Space(TAMSX3("E1_TIPO")[1])
Private oDlgTIT  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Janela de autorização                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DEFINE MSDIALOG oDlgTIT FROM 000,000 TO 150,600 TITLE "Atualização situação título (SE1)"  OF oDlgTIT PIXEL
	@ 005, 005 TO 040, 290 OF oDlgTIT  PIXEL 
	
	@ 013,010 SAY "Prefixo:" OF oDlgTIT PIXEL
	@ 012,040 GET cPRFDE  SIZE 010,10 WHEN .T. VALID (!Vazio()) OF oDlgTIT PIXEL

	@ 013,060 SAY "Número:" OF oDlgTIT PIXEL
	@ 012,100 GET cNUMDE  SIZE 030,10 WHEN .T. VALID (!Vazio()) OF oDlgTIT PIXEL

	@ 013,140 SAY "Parcela:" OF oDlgTIT PIXEL
	@ 012,180 GET cPARDE  SIZE 010,10 WHEN .T.  OF oDlgTIT PIXEL

	@ 013,200 SAY "Tipo:" OF oDlgTIT PIXEL
	@ 012,240 GET cTIPDE  SIZE 010,10 WHEN .T. VALID (!Vazio()) OF oDlgTIT PIXEL

				
	DEFINE SBUTTON FROM 040, 040 TYPE 1 ACTION ( fUpdSIT() )  ENABLE OF oDlgTIT PIXEL
	DEFINE SBUTTON FROM 040, 070 TYPE 2 ACTION (oDlgTIT:End()) ENABLE OF oDlgTIT PIXEL
	
	ACTIVATE MSDIALOG oDlgTIT CENTERED
	

Return


*-------------------------------------------------*
Static Function fUpdSIT()
*-------------------------------------------------*
Local nREGUPD := 0

    dbSelectArea("SE1")
    dbSetOrder(1)
    dbGoTop()

    If dbSeek(xFilial("SE1")+cPRFDE+cNUMDE+cPARDE+cTIPDE)
    	If SE1->E1_SITUACA == "2"
    		If RecLock("SE1",.F.)
    			SE1->E1_SITUACA := "1"
    			SE1->(MsUnLock())
    			nREGUPD += 1    				
    		EndIf
    	EndIf
    EndIf

	If nREGUPD == 0
		Alert("Título não encontrado!")
	Else
		MsgInfo("Situação atualizada!")
	EndIf
	
Return