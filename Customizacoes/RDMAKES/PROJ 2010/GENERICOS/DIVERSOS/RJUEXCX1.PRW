#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"


/* Programa para exclusão das perguntas de relatórios personalizados (SX1) */
*-------------------------*
User Function RJUEXCX1()
*-------------------------*      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If MsgBox("Executar limpeza do SX1 para perguntas personalizadas?","Atenção","YESNO")
		Processa( {|| fDelSX1() })
	EndIf
	
Return

*------------------------------*
Static Function fDelSX1()     
*------------------------------*
Local aArea := GetArea()
Local aTMP := {}

	aAdd ( aTMP, "BLASER" )
	aAdd ( aTMP, "IMPINV0000" )
	aAdd ( aTMP, "VLRSUM" )
	aAdd ( aTMP, "EST001" )
	aAdd ( aTMP, "TBOL01" )
	aAdd ( aTMP, "PTOVND" )
	aAdd ( aTMP, "BOLFBR" )
	aAdd ( aTMP, "BOLCEF" )
	aAdd ( aTMP, "BOLSBR" )
	aAdd ( aTMP, "BOLCAX" )
	aAdd ( aTMP, "REFSLD" )
	aAdd ( aTMP, "PLCrCl" )
	
	For nI := 1 to Len(aTMP)						
		dbSelectArea("SX1")
		dbSetOrder(1)
		dbSeek(aTMP[nI])
		While !SX1->(EOF()) .and. ALLTRIM(SX1->X1_GRUPO) == aTMP[nI]
			RecLock("SX1",.F.)
			SX1->(dbDelete())
			SX1->(MsUnLock())
			SX1->(dbSkip())
		Enddo
	Next nI

	RestArea(aArea)

Return