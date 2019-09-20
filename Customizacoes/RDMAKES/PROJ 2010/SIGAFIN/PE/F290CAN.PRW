#INCLUDE "rwmake.ch"
#include "topconn.ch"  

//O ponto de entrada F290CAN é executado no cancelamento da fatura a pagar.
User Function F290CAN() 

Local aAreaTMP	:= GetArea()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//--Exclusão rateio multi-naturezas da fatura.
	MsAguarde( {|| fMultiNAT() }, "Rateio de multi-naturezas... Aguarde!")	
	
	RestArea(aAreaTMP)     

Return()

//--Exclusão rateio multi-naturezas da fatura.
Static Function fMultiNAT()

Local aAreaTMP := GetArea()

	If SE2->E2_MULTNAT == "1" .and. ALLTRIM(SE2->E2_FATURA)=="NOTFAT"
		dbSelectArea("SEV")
		dbSetOrder(1)
		If dbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA))
			While SEV->(!EOF()) .AND. 	SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == ;
										SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)
				If SEV->EV_RATEICC == "1"	//--Rateio de CC/CLVL
					dbSelectArea("SEZ")
					dbSetOrder(1)	//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
					If dbSeek(SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+SEV->EV_NATUREZ)
						While SEZ->(!EOF()) .AND. 	SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == ;
													SE2->(E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA)+SEV->EV_NATUREZ
							RecLock("SEZ",.F.)
							SEZ->(dbDelete())
							SEZ->(MsUnLock())
							SEZ->(dbSkip())
						Enddo
					EndIf
				EndIf
				RecLock("SEV",.F.)
				SEV->(dbDelete())
				SEV->(MsUnLock())
				SEV->(dbSkip())
			Enddo
		EndIf				 
	EndIf
	
	RestArea(aAreaTMP)
	
Return