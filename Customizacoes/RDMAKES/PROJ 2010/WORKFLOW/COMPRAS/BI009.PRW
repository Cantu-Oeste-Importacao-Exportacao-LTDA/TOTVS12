/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ BI009    ¦ Autor ¦ ANTONIO C. SERRA JR   ¦ Data ¦ 16/04/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Rotina que dispara e-mail para os fornecedores com as     ¦¦¦
¦¦¦          ¦ cotacoes geradas.                                          ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦---ALTERAÇÕES-----------------------------------------------¦¦¦
¦¦¦          ¦ 16/04/2008 - ALTERADO O E-MAIL DE DESTINO WORKFLOW         ¦¦¦
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
User Function BI009()
LOCAL aSeg 	   := GetArea()
LOCAL aSegSB1  := SB1->(GetArea())
LOCAL aSegSA2  := SA2->(GetArea())
LOCAL aSegSE4  := SE4->(GetArea())
LOCAL aSegSC8  := SC8->(GetArea())
LOCAL cProcess := Space(6), cStatus := Space(6), cEmail := ""
LOCAL cNum     := "", cCond := ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SE4")
dbSeek(xFilial("SE4"),.T.)
While !Eof().and.(xFilial("SE4") == SE4->E4_filial)
	If Empty(cCond)
		cCond := SE4->E4_codigo+" - "+SE4->E4_descri 	
	Else
		cCond += "<option>"+SE4->E4_codigo+" - "+SE4->E4_descri
	Endif
	dbSelectArea("SE4")
	dbSkip()
Enddo

For _x := 1 to Len(ParamIxb)
	dbSelectArea("SC8")
	dbSetOrder(1)
	dbSeek(xFilial("SC8")+ParamIxb[_x],.T.)
	While !Eof().and.(SC8->C8_FILIAL == xFilial("SC8")).and.(SC8->C8_NUM == ParamIxb[_x])

		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+SC8->C8_fornece+SC8->C8_loja)		
			If Empty(SA2->A2_email)                           
				RestArea(aSegSA2)
				RestArea(aSegSB1)
				RestArea(aSegSE4)
				RestArea(aSegSC8)
				Return
			Endif		
		Else
			dbSelectArea("SC8")
			dbSkip()
			loop
		Endif    
		
		//Inicia processo de envio do e-mail
		cProcess := OemToAnsi("001010") // Numero do Processo
		cStatus  := OemToAnsi("001011")
	
		oProcess := TWFProcess():New(cProcess,OemToAnsi("Envio de cotação de compra para fornecedor"))
		oProcess:NewTask(cStatus,"\workflow\wfcotacao.htm")
		oProcess:cSubject := OemToAnsi("Compras CANTÚ - Cotacao de Compra no " + SC8->C8_NUM)
		oProcess:bReturn  := "U_BI010(1)"
//		oProcess:bTimeOut := {{"U_BI010(2)",2,0,0}}
		
		oProcess:cTo := ALLTRIM(SA2->A2_email)
	                                    
		// Preenchimento do cabeçalho da solicitação
		oHTML:= oProcess:oHTML		
		oHtml:ValByName("EMP"    ,ALLTRIM(SM0->M0_NOMECOM))		
		oHtml:ValByName("DATA"   ,DTOC(dDataBase))
		oHtml:ValByName("NCOT"   ,SC8->C8_num)
		oHtml:ValByName("CONDIC" ,cCond)
		oHtml:ValByName("CODFOR"  ,SA2->A2_COD)
		oHtml:ValByName("LOJAFOR" ,SA2->A2_LOJA)
		oHtml:ValByName("NOMFOR"  ,SA2->A2_NOME)
		oHtml:ValByName("CONTATO" ,ALLTRIM(SC8->C8_CONTATO))
		
		dbSelectArea("SC8")
		cNum     := SC8->C8_num
		cFornece := SC8->C8_fornece+SC8->C8_loja
		
		While !Eof().and.(SC8->C8_filial == xFilial("SC8")).and.(cNum == SC8->C8_num).and.;
								 (cFornece == SC8->C8_fornece+SC8->C8_loja)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC8->C8_produto,.T.)
			
			AAdd(oHtml:ValByName("IT.ITEM")    ,SC8->C8_ITEM)
			AAdd(oHtml:ValByName("IT.CODPRO")  ,SC8->C8_PRODUTO)
			AAdd(oHtml:ValByName("IT.DESCPRO") ,ALLTRIM(SB1->B1_DESC))
			AAdd(oHtml:ValByName("IT.QTD")     ,SC8->C8_QUANT)
			AAdd(oHtml:ValByName("IT.UM")      ,SC8->C8_UM)
			AAdd(oHtml:ValByName("IT.PRECO")   ,0.00)
			AAdd(oHtml:ValByName("IT.IPI")     ,0.00)
			AAdd(oHtml:ValByName("IT.ICMS")    ,0.00)
			AAdd(oHtml:ValByName("IT.DESCONTO"),0.00)
			AAdd(oHtml:ValByName("IT.OBS")     ,SC8->C8_OBS)

			dbSelectArea("SC8")
			dbSkip()
		Enddo
		
		oHtml:ValByName("TPFRETE","")
		oHtml:ValByName("VALFRETE",0.00)
		
		oProcess:Start()
	Enddo
Next

RestArea(aSegSA2)
RestArea(aSegSB1)
RestArea(aSegSE4)
RestArea(aSegSC8)

Return

/* Funcao para comunicar com o webservice de gerar cotacao por email e salvar os dados no banco*/

User Function SndCotacao()
LOCAL aSeg 	   := GetArea()
LOCAL aSegSB1  := SB1->(GetArea())
LOCAL aSegSA2  := SA2->(GetArea())
LOCAL aSegSE4  := SE4->(GetArea())
LOCAL aSegSC8  := SC8->(GetArea())
LOCAL cProcess := Space(6), cStatus := Space(6), cEmail := ""
LOCAL cNum     := "", cCond := ""     
Local Cabec := ""
Local cont := 1
Local oWS    := WSGravaWF():New()
Local oItens := GravaWF_ArrayOfString():New()
Local cResult:= ""
Local Item 
Local Cotacao
Local cID

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SE4")
dbSeek(xFilial("SE4"),.T.)                                                    
While !Eof().and.(xFilial("SE4") == SE4->E4_filial)
	If Empty(cCond)
		cCond := SE4->E4_codigo+" - "+SE4->E4_descri 	

	Else
		cCond += "<option>"+SE4->E4_codigo+" - "+SE4->E4_descri
	Endif
	dbSelectArea("SE4")
	dbSkip()
Enddo

For _x := 1 to Len(ParamIxb)
	dbSelectArea("SC8")
	dbSetOrder(1)           
 	if Empty(ALLTRIM(ParamIxb[_x])) // colocado ALLTRIM para nao ocasionar erro no PGM - Guilherme 
		Loop
	EndIf 
	dbSeek(xFilial("SC8")+ParamIxb[_x],.T.)
	While !Eof().and.(SC8->C8_FILIAL == xFilial("SC8")).and.(SC8->C8_NUM == ParamIxb[_x])

		dbSelectArea("SA2")
		dbSetOrder(1)
		If dbSeek(xFilial("SA2")+SC8->C8_fornece+SC8->C8_loja)		
			If Empty(SA2->A2_email)                           
				RestArea(aSegSA2)
				RestArea(aSegSB1)
				RestArea(aSegSE4)
				RestArea(aSegSC8)
				Return
			Endif		
		Else
			dbSelectArea("SC8")
			dbSkip()
			loop
		Endif    
		
		//Inicia processo de envio do e-mail
		cProcess := OemToAnsi("001010") // Numero do Processo
		cStatus  := OemToAnsi("001011")
	
		oProcess := TWFProcess():New(cProcess,OemToAnsi("Solicitacao Liberação de Pedido de Compra"))
		oProcess:NewTask(cStatus,"\workflow\wfcotacao.htm")
		oProcess:cSubject := OemToAnsi("Compras CANTÚ - Cotacao de Compra no " + SC8->C8_NUM)
		oProcess:bReturn  := "U_BI010(1)"
//		oProcess:bTimeOut := {{"U_BI010(2)",2,0,0}}		
				
		oProcess:cTo := ALLTRIM(SA2->A2_email) //"// Guilherme TESTE helpdesk.ti@grupocantu.com.br"
	                                    
		// Preenchimento do cabeçalho da solicitação
		Cabec += "EMP=" + ALLTRIM(SM0->M0_NOMECOM)
		Cabec += "&DATA=" + DTOC(dDataBase) 
		Cabec += "&NCOT=" + ALLTRIM(SC8->C8_num)
		Cabec += "&CONDIC="
		Cabec += "&CODFOR=" + ALLTRIM(SA2->A2_COD)
		Cabec += "&LOJAFOR=" + ALLTRIM(SA2->A2_LOJA)
		Cabec += "&NOMFOR=" + ALLTRIM(SA2->A2_NOME)
		Cabec += "&CONTATO=" + ALLTRIM(SC8->C8_CONTATO)
		Cabec += "&TPFRETE=CIF"
		Cabec += "&VALFRETE=0"
		Cabec += "&WFEMPRESA=" + SM0->M0_CODIGO
		Cabec += "&WFFILIAL=" + SM0->M0_CODFIL
		Cabec += "&WFMAILID=" + oProcess:fProcessID
		
		dbSelectArea("SC8")
		cNum     := SC8->C8_num
		cFornece := SC8->C8_fornece+SC8->C8_loja
		
		oHTML:= oProcess:oHTML
		
		// Preenchimento do cabeçalho da solicitação				
		oHtml:ValByName("EMP"    ,ALLTRIM(SM0->M0_NOMECOM))		
		oHtml:ValByName("DATA"   ,DTOC(dDataBase))
		oHtml:ValByName("NCOT"   ,cNum)
		oHtml:ValByName("CODFOR"  ,SA2->A2_COD)
		oHtml:ValByName("LOJAFOR" ,SA2->A2_LOJA)
		oHtml:ValByName("NOMFOR"  ,SA2->A2_NOME)
		oHtml:ValByName("CONTATO" ,ALLTRIM(SC8->C8_CONTATO))
		oHtml:ValByName("TPFRETE" ,"")
		oHtml:ValByName("VALFRETE",0.00)
		
		While !Eof().and.(SC8->C8_filial == xFilial("SC8")).and.(cNum == SC8->C8_num).and.;
								 (cFornece == SC8->C8_fornece+SC8->C8_loja)
			
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SC8->C8_produto,.T.)
			
			Item = "IT.ITEM." + AllTrim(Str(cont)) + "=" + AllTrim(SC8->C8_ITEM)
			Item += "&IT.CODPRO." + AllTrim(Str(cont)) + "=" + AllTrim(SC8->C8_PRODUTO)
			Item += "&IT.DESCPRO." + AllTrim(Str(cont)) + "=" + ALLTRIM(SB1->B1_DESC)
			Item += "&IT.QTD." + AllTrim(Str(cont)) + "=" + AllTrim(STR(SC8->C8_QUANT))
			Item += "&IT.UM." + AllTrim(Str(cont)) + "=" + AllTrim(SC8->C8_UM)
			Item += "&IT.PRECO." + AllTrim(Str(cont)) + "=0"
			Item += "&IT.IPI." + AllTrim(Str(cont)) + "=0"
			Item += "&IT.ICMS." + AllTrim(Str(cont)) + "=0"
			Item += "&IT.DESCONTO." + AllTrim(Str(cont)) + "=0"
			Item += "&IT.OBS." + AllTrim(Str(cont)) + "=" + AllTrim(SC8->C8_OBS)
			
			AAdd(oHtml:ValByName("IT.ITEM")    ,SC8->C8_ITEM)
			AAdd(oHtml:ValByName("IT.CODPRO")  ,SC8->C8_PRODUTO)
			AAdd(oHtml:ValByName("IT.DESCPRO") ,ALLTRIM(SB1->B1_DESC))
			AAdd(oHtml:ValByName("IT.QTD")     ,SC8->C8_QUANT)
			AAdd(oHtml:ValByName("IT.UM")      ,SC8->C8_UM)
			AAdd(oHtml:ValByName("IT.PRECO")   ,0.00)
			AAdd(oHtml:ValByName("IT.IPI")     ,0.00)
			AAdd(oHtml:ValByName("IT.ICMS")    ,0.00)
			AAdd(oHtml:ValByName("IT.DESCONTO"),0.00)
			AAdd(oHtml:ValByName("IT.OBS")     ,SC8->C8_OBS)
			
			dbSelectArea("SC8")
			dbSkip()
			AADD(oItens:cString, Item)
			cont++
		Enddo
		// chama o webservice e recebe o retorno
		If oWS:GravaWorkFlow(Cabec, oItens)
		   Cotacao := oWS:cGravaWorkFlowResult
		Else
		   Cotacao := "Erro ao acessar WebService"
		EndIf

		// seta o link de acesso no email
		oHtml:ValByName("linksite", "http://200.250.240.130:8050/portal")      //Dayane F. - alterado a pedido do Yuri
		//oHtml:ValByName("cotacaoid", Cotacao) //Cotacao      - Dayane F.
		
		// obtém o ID do processo pq ele é o nome do arquivo gerado no diretório de envio, para identificar o retorno
		cID := oProcess:Start()
		
		// chama o webservice de atualização do arquivo
		oWS:SetIdWF(Cotacao, "WF" + cID)
		Cont := 1
	Enddo
Next _x  //Guilherme colocado _x para incrementar o _x 

RestArea(aSegSA2)
RestArea(aSegSB1)
RestArea(aSegSE4)
RestArea(aSegSC8)

Return

Static Function GravaWsDados(cDados)

Local oWS    := WSServWF():New()
Local cResult := ""

If oWS:GravaWorkFlow(cDados)
   cResult := oWS:cGravaWorkFlowResult
 Else
   MsgStop("WSGravaSaldo: Web Service nao acessivel!")
EndIf

Return cResult == "OK"