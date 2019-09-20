#INCLUDE "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MT150END º Autor ³ Rafael Parma       º Data ³ 26/11/2010  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada executado após a atualização de cotação,   º±±
±±º          ³responsável por atualizar registros referentes as parcelas  º±±
±±º          ³de vencimento para uso no fluxo de caixa do compras.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*------------------------*
User Function MT150END()  
*------------------------*
Local aArea := GetArea()
Local nOPCCOT := PARAMIXB[1]    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Elimina registros tabela Z11                                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("Z11")
		dbSetOrder(2)	//Z11_FILIAL+Z11_COTACA+Z11_FORNEC+Z11_LOJA+DTOS(Z11_VENCTO) 
		dbGoTop()
		If dbSeek( xFilial("Z11")+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA )
			While !Z11->(EOF()) .and. Z11->Z11_FILIAL+Z11->Z11_COTACA+Z11->Z11_FORNEC+Z11->Z11_LOJA == xFilial("Z11")+SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA
				If RecLock("Z11",.F.)
					Z11->(dbDelete())
					Z11->(MsUnLock())
				EndIf
				Z11->(dbSkip())		
			Enddo
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Insere registros tabela Z11                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If nOPCCOT == 3 .OR. nOPCCOT == 4 //"Novo Particip." ou "Atualizar"
			If Len(__aPARCCOT) > 0
				For nI := 1 to Len(__aPARCCOT)
					If !__aPARCCOT[nI][Len(__aPARCCOT[nI])]
						If RecLock("Z11",.T.)
							Z11->Z11_FILIAL := xFilial("Z11")
							Z11->Z11_COTACA := SC8->C8_NUM
							Z11->Z11_FORNEC := SC8->C8_FORNECE
							Z11->Z11_LOJA   := SC8->C8_LOJA
							Z11->Z11_VALOR  := __aPARCCOT[nI][02]
							Z11->Z11_VENCTO := __aPARCCOT[nI][01]
							Z11->Z11_DATPRC := ddatabase
							Z11->(MsUnLock())
						EndIf
					EndIf
				Next nI
			EndIf
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Limpeza das variáveis publicas.                                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		 __aPARCCOT := {}	   							// Array de parcelas (vencimento + valor)
		 __cNUMCOTC := Space(06)						// Número da cotação
		 __cCPGCOTC := Space(03)						// Código condição de pagamento
		 __cFILCOTC := Space(02)						// Código filial
		 __cFORCOTC := Space(TAMSX3("A2_COD")[1])		// Código Fornecedor
		 __cLOJCOTC := Space(TAMSX3("A2_LOJA")[1])		// Loja Fornecedor
		 __nVALCOTC := 0								// Valor total cotação
	 		
	EndIf
	
	RestArea(aArea)	                                        
	
Return 