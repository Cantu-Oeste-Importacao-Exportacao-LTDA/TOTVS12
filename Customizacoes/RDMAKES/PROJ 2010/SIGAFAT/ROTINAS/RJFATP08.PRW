#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFATP08   ºAutor  ³Rafael Parma       º Data ³  21/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Preenche automaticamente campo LOJA com próximo valor dispo-º±±
±±º          ³nível.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAtualizado³Flavio - 19/01/2010º																				 ±±
±±						Corrigido a validacao para buscar do codigo e nao do cpf do º±±
±±						cliente e fornecedor                                        º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------------*
User Function RJFATP08(cALIAS)
*-----------------------------* 
Local aArea := GetArea()
Local cRET := STRZero(1,TAMSX3("A1_LOJA")[1]) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	
	If cALIAS == "SA1"
		If !Empty(M->A1_CGC) .AND. M->A1_PESSOA == "F"
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("SA1") + M->A1_COD )
				While !SA1->(EOF()) .and. SA1->A1_FILIAL + SA1->A1_COD == xFilial("SA1") + M->A1_COD
					cRET := SA1->A1_LOJA
					SA1->(dbSkip())
				Enddo  
				cRET := STRZero(Val(cRET)+1,TAMSX3("A1_LOJA")[1])
			EndIf      
		EndIf
	Else
		If !Empty(M->A2_CGC) .AND. M->A2_TIPO == "F"
			dbSelectArea("SA2")
			dbSetOrder(3)
			dbGoTop()
			If dbSeek ( xFilial("SA3") + M->A2_COD )
				While !SA2->(EOF()) .and. SA2->A2_FILIAL + SA2->A2_COD == xFilial("SA2") + M->A2_COD
					cRET := SA2->A2_LOJA
					SA2->(dbSkip())
				Enddo  
				cRET := STRZero(Val(cRET)+1,TAMSX3("A2_LOJA")[1])
			EndIf      
		EndIf
	EndIf
		
	RestArea(aArea)

Return (cRET)