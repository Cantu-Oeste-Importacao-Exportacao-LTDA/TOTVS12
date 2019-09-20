/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ BI010    ¦ Autor ¦ ANTONIO C. SERRA JR   ¦ Data ¦ 21/07/03 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Retorno da cotacao enviada para os fornecedores.          ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦---ALTERAÇÕES-----------------------------------------------¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para CANTU.                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sol. Cust.¦ 04186080415-01                                             ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
#include "rwmake.ch"
#include "tbiconn.ch"
User Function BI010(nOpcao,oProcess)
LOCAL nC
LOCAL aPreco, cFornece, aItem,aProd, aIPI, aICMS, aDescon, nFrete
LOCAL cNumSol, i1,cProd, cProcess, cStatus, cCond, cNumSC
LOCAL cEmp := Space(2), cFil := Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cEmp := oProcess:oHtml:RetByName("WFEMPRESA")
cFil := oProcess:oHtml:RetByName("WFFILIAL")

// Abre as tabelas que vao ser utilizadas
RPCSetEnv(cEmp,cFil,"","","","",{"SC8"})          

cNumSol  := oProcess:oHtml:RetByName("NCOT")
cProcess := OemToAnsi("001010") // Numero do Processo
cStatus  := OemToAnsi("001012")

If (nOpcao == 1)

	dbSelectArea("SC8")
	dbSetOrder(1)
	
	cFornece := oProcess:oHtml:RetByName("CODFOR")
	cLoj     := oProcess:oHtml:RetByName("LOJAFOR")	
	cCond    := oProcess:oHtml:RetByName("CONDIC")
	aProd    := oProcess:oHtml:RetByName("IT.CODPRO")
	aItem    := oProcess:oHtml:RetByName("IT.ITEM")
	aPreco   := oProcess:oHtml:RetByName("IT.PRECO")
	aIPI     := oProcess:oHtml:RetByName("IT.IPI")
	aICMS    := oProcess:oHtml:RetByName("IT.ICMS")
	aDescon  := oProcess:oHtml:RetByName("IT.DESCONTO")
	nFrete   := oProcess:oHtml:RetByName("VALFRETE")
	cTipoFre := oProcess:oHtml:RetByName("TPFRETE")
	aObs     := oProcess:oHtml:RetByName("IT.OBS")
	
	For i1 := 1 to Len(aProd)
		Conout("Produto ==> "+aProd[i1])
	Next
	
	/*
	For i1 := 1 to Len(aIPI)
		Conout("IPI ==> "+aIPI[i1])
	Next
	For i1 := 1 to Len(aPreco)
		Conout("aPreco ==> "+aPreco[i1])
	Next
	For i1 := 1 to Len(aICMS)
		Conout("Icms ==> "+aICMS[i1])
	Next*/
	
	Conout("Fornecedor ==> "+cFornece)
	
	For nC := 1 to Len(aProd)
		dbSelectArea("SC8")
		dbSetOrder(1)
		cFornece := cFornece + Space(6-Len(cFornece))
		cLoj     := cLoj + Space(2-Len(cLoj))
		If dbSeek(xFilial("SC8")+cNumSol+cFornece+cLoj+aItem[nC],.T.)
			If SC8->C8_PRECO == 0
				Conout("Gravando SC8....")
				RecLock("SC8",.F.)
				SC8->C8_PRECO  := Val(aPreco[nC])
				SC8->C8_TOTAL  := Round(SC8->C8_QUANT * VAL(aPreco[nC]),2)
				SC8->C8_ALIIPI := Val(aIPI[nC])
				SC8->C8_PICM   := Val(aICMS[nC])
				If (aItem[nC] == "0001")
					SC8->C8_VALFRE := Val(nFrete)
				Endif
				SC8->C8_VLDESC  := Val(aDescon[nC])
				SC8->C8_VALICM  := SC8->C8_TOTAL * (SC8->C8_PICM/100)
				SC8->C8_VALIPI  := SC8->C8_TOTAL * (SC8->C8_ALIIPI/100)
				SC8->C8_BASEICM := SC8->C8_TOTAL
				SC8->C8_BASEIPI := SC8->C8_TOTAL
				SC8->C8_TPFRETE := iif(cTipoFre=="CIF","C","F")
				SC8->C8_OBS     := aObs[nC]
				SC8->C8_COND    := Substr(cCond,1,3)
				cNumSC := AllTrim(SC8->C8_NUMSC)
				MsUnlock("SC8")
			EndIf
		Else
			Conout("Nao gravou SC8")
		Endif
	Next
	Conout("Atualização de dados do processo da Cotacao: "+cNumSol)
//	MailRetCotacao(cNumSC, cFornece, cLoj)
Else
	Conout("TIMEOUT do processo da solicitacao.")
Endif

Conout("Finalizacao do processo de cotacao.")

oProcess:Finish()

Return(.T.)


/********************************************************************/
// Envio de email quando retornado uma cotação do fornecedor
/********************************************************************/
Static Function MailRetCotacao(cFil,cNumSol, cFornec, cLoja)
Local aArea := GetArea()
Local cComprador, cEmail, cNomeFor
Local oProcess, oHtml, cProcess, cStatus

cNomeFor := Posicione("SA2", 1, xFilial("SA2") + cFornec + cLoja, "A2_NOME")
SC1->(DBSetOrder(1))
SC1->(DBSeek(cFil + cNumSol))
cComprador := SC1->C1_USER
cEmail := Posicione("SY1", 1, xFilial("SC1") + cNumSol, "Y1_EMAIL")
if (AllTrim(cEmail) <> "")
	//Inicia processo de envio do e-mail
	cProcess := OemToAnsi("001010") // Numero do Processo
	cStatus  := OemToAnsi("001011")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi("Retorno de Cotação da Solicitação número " + cNumSol + " do fornecedor " + cFornec + " - " + cNomeFor))
	oProcess:NewTask(cStatus,"\workflow\wfRetCotFornec.html")
	oProcess:cSubject := OemToAnsi("Retorno de Cotação da Solicitação número " + cNumSol + " do fornecedor " + cFornec + " - " + cNomeFor)

	oProcess:cTo := ALLTRIM(cEmail)
		
	oHTML:= oProcess:oHTML	
	oHtml:ValByName("NSOLICIT", cNumSol)
	oHtml:ValByName("FORNEC", cFornec + " - " + cNomeFor)	
	
	oProcess:Start()
EndIf	

RestArea(aArea)
	
Return Nil