#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"
#include "Protheus.ch"

User Function RJUUPE2()
Local nREG := 0       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFile := "\tabse2\se2"+cEmpAnt+"0.dtc"

If !File(cFile)
	Alert("Arquivo não existe!")
	Return
EndIf 

MsOpEndbf(.T.,__LOCALDRIVER,cFile,"TMPSE2",.F.,.F.,.F.,.F.)
      
dbSelectArea("TMPSE2")
dbGoTop()
ProcRegua(LastRec())
While TMPSE2->(!EOF())
	IncProc()
	If !Empty(TMPSE2->E2_CGC) .AND. ALLTRIM(TMPSE2->E2_CGC) != "NAOIMP" .and. Len(AllTrim(TMPSE2->E2_CGC)) == 14
		
		dbSelectArea("SE2")
		dbSetOrder(1) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
		dbGoTop()
		cPAR := TMPSE2->E2_PARCELA + SPACE(3-LEN(TMPSE2->E2_PARCELA))
		cTIT := TMPSE2->E2_NUM + SPACE(9-LEN(TMPSE2->E2_NUM))

		If dbSeek( TMPSE2->E2_FILIAL + TMPSE2->E2_PREFIXO + cTIT + cPAR + TMPSE2->E2_TIPO )

			If SE2->E2_SALDO != SE2->E2_VALOR
			
				dbSelectArea("SE5")
				dbSetOrder(7)	//E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA+E5_SEQ+E5_RECPAG
				dbGoTop()
				If dbSeek ( TMPSE2->E2_FILIAL + TMPSE2->E2_PREFIXO + cTIT + cPAR + TMPSE2->E2_TIPO )
					While !SE5->(EOF()) .and. SE5->E5_FILIAL+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO == TMPSE2->E2_FILIAL+TMPSE2->E2_PREFIXO+cTIT+cPAR+TMPSE2->E2_TIPO
					    If ALLTRIM(SE5->E5_FORNECE) == SubSTR(TMPSE2->E2_CGC,1,8) .and. SE5->E5_LOJA != SubSTR(TMPSE2->E2_CGC,9,4)
                            
							dbSelectArea("SA2")
							dbSetOrder(1)
							If dbSeek ( xFilial("SA2") + SE5->E5_FORNECE + SubSTR(TMPSE2->E2_CGC,9,4) )
								If RecLock("SE5",.F.) 
									SE5->E5_LOJA := SubSTR(TMPSE2->E2_CGC,9,4)
									SE5->(MsUnLock()) 
									nREG += 1
								EndIf
							EndIf
								    
						EndIf
						SE5->(dbSkip())
					Enddo
				EndIf
			EndIf
		EndIf
		/*
			If Len(AllTrim(TMPSE2->E2_CGC)) == 14 .and. SE2->E2_LOJA != SubSTR(TMPSE2->E2_CGC,9,4) .and. ALLTRIM(SE2->E2_FORNECE) ==SubSTR(TMPSE2->E2_CGC,1,8)
				If RecLock("SE2",.F.) 
					SE2->E2_LOJA := SubSTR(TMPSE2->E2_CGC,9,4)
					SE2->(MsUnLock()) 
					nREG += 1
				EndIf
			EndIf    
		*/		
	EndIf

	TMPSE2->(dbskip())
EndDo

TMPSE2->(dbCloseArea())

MsgInfo("Processo concluído! registros processados: "+STR(nREG))

Return