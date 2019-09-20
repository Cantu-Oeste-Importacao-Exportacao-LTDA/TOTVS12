#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ CN120VMP³ Autor ³ Rafael Parma          ³Data ³ 13/12/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Bloqueio das medições gestão de contratos.                  ±±
±±³          ³                                                             ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ CANTU                             	    				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-----------------------*
User Function CN120VMP()
*-----------------------*
Local aAliasTMP:= GetArea()    
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("CNE")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek( xFilial("CNE")+CND->(CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED) )
		While !CNE->(EOF()) .and. CNE->(CNE_FILIAL+CNE_CONTRA+CNE_REVISA+CNE_NUMERO+CNE_NUMMED) == xFilial("CNE")+CND->(CND_CONTRA+CND_REVISA+CND_NUMERO+CND_NUMMED)
			dbSelectArea("CNZ")
			dbSetOrder(2)
			dbGoTop()
			If dbSeek( xFilial("CNZ")+CND->(CND_CONTRA+CND_REVISA+CND_NUMMED)+CNE->CNE_ITEM )
				While !CNZ->(EOF()) .and. CNZ->(CNZ_FILIAL+CNZ_CONTRA+CNZ_REVISA+CNZ_NUMMED+CNZ_ITCONT) == xFilial("CNZ")+CND->(CND_CONTRA+CND_REVISA+CND_NUMMED)+CNE->CNE_ITEM
					lRet := PcoVldLan("999013","01","CN120VMP")
					If !lRet
						Exit
					EndIf
					CNZ->(dbSkip())
				Enddo
			Else
				Aviso("Aviso","Contrato/medição sem rateio. Não é possível continuar..",{"OK"})
				lRet := .F.
				Exit
			EndIf
			CNE->(dbSkip())
		Enddo
	EndIf

	RestArea(aAliasTMP)
	
RETURN (lRet)