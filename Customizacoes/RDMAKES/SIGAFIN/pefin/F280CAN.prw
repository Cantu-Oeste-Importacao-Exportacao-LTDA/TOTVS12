#INCLUDE "rwmake.ch"
#include "topconn.ch"  

//O ponto de entrada F280CAN sera executado na gravacao dos dados complementares no cancelamento da fatura a receber.
//Guilherme 25/06/13 ponto de entrada utilizado para tratar o motivo da baixa do PEFIN nos títulos agrupados na fatura.
User Function F280CAN() 
Local aArea		:= GetArea()
Local _Numero := SE1->E1_NUM 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//verificar campos E1_FATURA para selecionar os títulos...
cSql := "SELECT E1.E1_NUM,E1.E1_PREFIXO,E1.E1_PARCELA,E1.E1_TIPO,E1.E1_FATURA,E1.E1_PEFININ,E1.E1_PEFINMB,E1.E1_PEFINEX,E1.E1_SALDO "
cSql += "  FROM " + RetSqlName("SE1")+ " E1  "
cSql += " WHERE E1.D_E_L_E_T_ <> '*' "
cSql += "   AND E1.E1_FILIAL = '"+xFilial("SE2")+"' "
cSql += "   AND E1.E1_FATURA = '"+_Numero+"' "
cSql += "ORDER BY E1.E1_FILIAL,E1.E1_NUM,E1.E1_PARCELA "

TCQUERY cSql NEW ALIAS "TMP2"

While TMP2->(!Eof()) 
	cNum := TMP2->E1_NUM
	cPar := TMP2->E1_PARCELA
	cPfx := TMP2->E1_PREFIXO
	cTpo := TMP2->E1_TIPO

	If !Empty(AllTrim(TMP2->E1_PEFININ)) .AND. !Empty(AllTrim(TMP2->E1_PEFINMB)) .AND. Empty(AllTrim(TMP2->E1_PEFINEX))
		DbselectArea("SE1")
 		DbSetOrder(1)
 		If Dbseek(xFilial("SE1")+cPfx+cNum+cPar+cTpo)
			RecLock("SE1",.F.)
			SE1->E1_PEFINMB := Space(6)
			MsUnlock()   
		EndIf	 	
	Endif  	    
	
	TMP2->(Dbskip())
End Do

DBCLOSEAREA("TMP2")

//--Exclusão rateio multi-naturezas da fatura.
MsAguarde( {|| fMultiNAT() }, "Rateio de multi-naturezas... Aguarde!")	

 
                          
RestArea(aArea)     

Return()

//--Exclusão rateio multi-naturezas da fatura.
Static Function fMultiNAT()
Local aAreaTMP := GetArea()

	If SE1->E1_MULTNAT == "1" .and. ALLTRIM(SE1->E1_FATURA)=="NOTFAT"
		dbSelectArea("SEV")
		dbSetOrder(1)
		If dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
			While SEV->(!EOF()) .AND. 	SEV->(EV_FILIAL+EV_PREFIXO+EV_NUM+EV_PARCELA+EV_TIPO+EV_CLIFOR+EV_LOJA) == ;
										SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)
				If SEV->EV_RATEICC == "1"	//--Rateio de CC/CLVL
					dbSelectArea("SEZ")
					dbSetOrder(1)	//EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ+EZ_CCUSTO
					If dbSeek(SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+SEV->EV_NATUREZ)
						While SEZ->(!EOF()) .AND. 	SEZ->(EZ_FILIAL+EZ_PREFIXO+EZ_NUM+EZ_PARCELA+EZ_TIPO+EZ_CLIFOR+EZ_LOJA+EZ_NATUREZ) == ;
													SE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+SEV->EV_NATUREZ
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