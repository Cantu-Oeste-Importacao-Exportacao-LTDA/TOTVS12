User Function FA080PE()
Local _aArea	:= GetArea()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !Empty(AllTrim(SE2->E2_X_MULTA))
	TRX->(DbSelectArea("TRX"))
	TRX->(DbSetOrder(1))
	TRX->(DbGotop())
	If TRX->(DbSeek(xFilial("TRX")+SE2->E2_X_MULTA))
	   	TSG->(Reclock("TSG",.T.))
		TSG->TSG_FILIAL := xFilial("TRX")
		TSG->TSG_MULTA	:= SE2->E2_X_MULTA
		TSG->TSG_NUMAIT := TRX->TRX_NUMAIT
		TSG->TSG_TIPOMO	:= '1'
		TSG->TSG_DTPAG	:= dDataBase
		TSG->TSG_VALORI	:= SE2->E2_VALOR
		TSG->TSG_VALPGO	:=  (SE2->E2_VALOR-SE2->E2_SALDO)
		TSG->TSG_DTDIG	:= Date()
		TSG->TSG_HRDIG	:= Time()
		TSG->TSG_USUDIG	:= Upper(SubStr(cUsuario, 07, 15))
		TSG->(MsUnlock("TSG")) 
	   	// Atualizar status da multa para paga.
	   	TRX->(Reclock("TRX",.F.))		
	   		TRX->TRX_PAGTO	:= '1'
	   		TRX->TRX_DTPGTO	:= dDataBase
	   		TRX->TRX_VALPAG	:= (SE2->E2_VALOR-SE2->E2_SALDO)
		TRX->(MsUnlock("TRX")) 	   	
		
	Else
		Alert("Multa não encontrada !")
	Endif
	
Endif

// Gravação dos campos na SE5 conforme SE2 - 20/04/2012 - Carlos Eduardo 
If ( !SE5->(EOF()) .and. !SE5->(BOF()) )
	If RecLock("SE5",.F.)	
		SE5->E5_CLVLDB 	:= SE2->E2_CLVLDB
		SE5->E5_CLVLCR	:= SE2->E2_CLVLCR
		SE5->E5_CCD		:= SE2->E2_CCD
		SE5->E5_CCC		:= SE2->E2_CCC
		SE5->E5_ITEMD	:= SE2->E2_ITEMD
		SE5->E5_ITEMC	:= SE2->E2_ITEMC	
		SE5->(MsUnLock())
	EndIf
EndIf

//--Grava dados CC/Segmento no registro do cheque 
If !Empty(SE2->E2_NUMBCO) .and. ( !SE5->(EOF()) .and. !SE5->(BOF()) )
	nRECSE5 := SE5->(RECNO())
	cBCO := SE5->E5_BANCO
	cAGE := SE5->E5_AGENCIA
	cCTA := SE5->E5_CONTA
	dbSelectArea("SE5")
	dbSetOrder(11) //--E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ
	If dbSeek(SE2->E2_FILIAL + cBCO + cAGE + cCTA + SE2->E2_NUMBCO)
		While !SE5->(EOF()) .and. SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ) == SE2->E2_FILIAL + cBCO + cAGE + cCTA + SE2->E2_NUMBCO
			If RecLock("SE5",.F.)	
				SE5->E5_CLVLDB 	:= SE2->E2_CLVLDB
				SE5->E5_CLVLCR	:= SE2->E2_CLVLCR
				SE5->E5_CCD		:= SE2->E2_CCD
				SE5->E5_CCC		:= SE2->E2_CCC
				SE5->E5_ITEMD	:= SE2->E2_ITEMD
				SE5->E5_ITEMC	:= SE2->E2_ITEMC	
				SE5->(MsUnLock())
			EndIf						
			SE5->(dbSkip())
		Enddo
	EndIf
	SE5->(dbGoTo(nRECSE5))
EndIf

RestArea(_aArea)

Return Nil