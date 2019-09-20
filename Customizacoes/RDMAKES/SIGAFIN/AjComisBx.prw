#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

User Function AjComisBx()
Local aArea := GetArea()
Local oDlg1
Local lCont := .F.
Local cEmisIni := (dDataBase - 40)
Local cEmisFim := (dDataBase - 10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 250,450 DIALOG oDlg1 TITLE "Informe o intervalo de datas"
// @ 005,005 TO 060,160
@ 015,010 Say "Data Inicial:" PIXEL
@ 015,070 Get cEmisIni Size 60, 10 PIXEL
@ 030,010 Say "Data Final:" PIXEL
@ 030,070 Get cEmisFim Size 60, 10 PIXEL
ACTIVATE DIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| lCont := .T., ODlg1:End(), Nil }, {|| oDlg1:End() })
		
if !lCont
	Return
EndIf

BeginSql Alias "SC5TMP"
	SELECT DISTINCT C5_FILIAL, C5_NUM, C5_EMISSAO, C5_VEND1
	FROM %TABLE:SC5% SC5
	INNER JOIN %TABLE:SC6% SC6 ON C5_NUM = C6_NUM AND C5_FILIAL = C6_FILIAL
	INNER JOIN %TABLE:ZZL% ZZL ON ZZL_SEGMEN = C5_X_CLVL
	INNER JOIN %TABLE:Z12% Z12 ON Z12_VENDED = C5_VEND1
	WHERE SC6.D_E_L_E_T_ <> '*' AND SC5.D_E_L_E_T_ <> '*' AND Z12.D_E_L_E_T_ <> '*' AND ZZL.D_E_L_E_T_ <> '*'
	AND C5_EMISSAO >= ZZL_DATACO
	AND Z12.Z12_DATINI <= C5_EMISSAO
	AND Z12.Z12_DATFIN >= C5_EMISSAO
	AND SC5.C5_EMISSAO BETWEEN %EXP:cEmisIni% AND %EXP:cEmisFim% 
	AND C5_FILIAL = %XFILIAL:SC5%
	ORDER BY C5_FILIAL, C5_NUM
EndSql
SC5->(dbSetOrder(01))
SD2->(dbSetOrder(08))
SC6->(dbSetOrder(01))

Processa({||RunProc()}, "Processando pedidos")

SC5TMP->(dbCloseArea("SC5TMP"))
          
RestArea(aArea)
Return

Static Function RunProc()
dbSelectArea("SC5TMP")
nRegs := 0
Count To nRegs

SC5TMP->(dbGoTop())

ProcRegua(nRegs, "Processando Registros")

While SC5TMP->(!Eof())
	
	IncProc()
	
	SC5->(dbSeek(xFilial("SC5") + SC5TMP->C5_NUM))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve calcular comissão com base em contratos. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
	If ALLTRIM(SuperGetMV("MV_X_ATCCV",,"N")) == "S"
	 RJF410CC()
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se deve calcular comissão com base em regras desconto.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    	
	If ALLTRIM(SuperGetMV("MV_X_ATCDC",,"N")) == "S"
		RJF410CD()
	EndIf
	
	// Monta o SD2 com base no SC6
	SC6->(dbSeek(xFilial("SC6") + SC5TMP->C5_NUM))
	While SC6->C6_NUM+SC6->C6_FILIAL == SC5TMP->C5_NUM+ xFilial("SC5")
	 	SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM))
	 	While SD2->D2_FILIAL+SD2->D2_PEDIDO+SD2->D2_ITEM == SC6->C6_FILIAL+SC6->C6_NUM+SC6->C6_ITEM
	 		if SD2->D2_COMIS1 != SC6->C6_COMIS1
	 			RecLock("SD2", .F.)
	 			SD2->D2_COMIS1 := SC6->C6_COMIS1
	 			SD2->(MsUnlock())
	 			ConOut("Alterado Item SD2 " + SD2->D2_FILIAL + " " + SD2->D2_DOC + " " + SD2->D2_COD)
	 		EndIf
	 		SD2->(dbSkip())
	 	EndDo
	 	SC6->(dbSkip())	 		 	
	EndDo
	
	SC5TMP->(dbSkip())
EndDo

MsgInfo("Processados " + cValToChar(nRegs) + " registros.")

Return


// Faz a correção dos títulos somente, depois de processado a função acima
User function AjComisE1()
Local aArea := GetArea()
Local cEmisIni := dDataBase
Local cEmisFim := dDataBase
Local oDlg1
Local lCont := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 250,450 DIALOG oDlg1 TITLE "Informe o intervalo de datas"
// @ 005,005 TO 060,160
@ 015,010 Say "Data Inicial:" PIXEL
@ 015,070 Get cEmisIni Size 60, 10 PIXEL
@ 030,010 Say "Data Final:" PIXEL
@ 030,070 Get cEmisFim Size 60, 10 PIXEL
ACTIVATE DIALOG oDlg1 CENTER ON INIT ;
	EnchoiceBar(oDlg1,{|| lCont := .T., ODlg1:End(), Nil }, {|| oDlg1:End() })
		
if !lCont
	Return
EndIf

BeginSql Alias "SD2TMP"
	SELECT F2_FILIAL, F2_SERIE, F2_DOC, 
  SUM((D2_TOTAL + D2_VALIPI + D2_ICMSRET) * D2_COMIS1) / SUM(D2_TOTAL + D2_VALIPI + D2_ICMSRET) AS PERCOMIS
	FROM %TABLE:SF2% SF2 INNER JOIN %TABLE:SD2% SD2 ON (F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = F2_SERIE)	
	INNER JOIN %TABLE:ZZL% ZZL ON ZZL_SEGMEN = D2_CLVL
	INNER JOIN %TABLE:Z12% Z12 ON Z12_VENDED = F2_VEND1
	WHERE SD2.D_E_L_E_T_ <> '*' AND SF2.D_E_L_E_T_ <> '*' AND Z12.D_E_L_E_T_ <> '*' AND ZZL.D_E_L_E_T_ <> '*'
	AND D2_EMISSAO >= ZZL_DATACO
	AND Z12.Z12_DATINI <= F2_EMISSAO
	AND Z12.Z12_DATFIN >= F2_EMISSAO
	AND F2_EMISSAO >= %EXP:cEmisIni%
	AND F2_EMISSAO <= %EXP:cEmisFim%
	AND F2_FILIAL = %XFILIAL:SF2%
	GROUP BY F2_FILIAL, F2_SERIE, F2_DOC
	ORDER BY F2_FILIAL, F2_SERIE, F2_DOC
EndSql
  
SE1->(dbSetOrder(01))

Processa({||ProcSE1()}, "Processando títulos")

SD2TMP->(dbCloseArea())

Return


// Processa acertos no SE1
Static Function ProcSE1()
Local nRegs := 0

dbSelectArea("SD2TMP")

Count To nRegs

SD2TMP->(dbGoTop())

ProcRegua(nRegs, "Processando registros")

While SD2TMP->(!Eof())

	IncProc()
	
	SE1->(dbSeek(SD2TMP->F2_FILIAL+SD2TMP->F2_SERIE+SD2TMP->F2_DOC))
	While SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM == SD2TMP->F2_FILIAL+SD2TMP->F2_SERIE+SD2TMP->F2_DOC	
		if trim(SE1->E1_TIPO) == "NF"
			if (SE1->E1_BASCOM1 != SE1->E1_VALOR .OR. SE1->E1_COMIS1 != SD2TMP->PERCOMIS)
//				MsgInfo("Corrigido título " + SE1->E1_NUM + " valor " + STR(SE1->E1_VALOR) + " comissao de " + Str(SE1->E1_COMIS1) + " para " + Str(SD2TMP->PERCOMIS))
				RecLock("SE1", .F.)
				SE1->E1_BASCOM1 := SE1->E1_VALOR
				SE1->E1_COMIS1 := SD2TMP->PERCOMIS
				SE1->(MsUnlock())
			EndIf
		EndIf
		SE1->(dbSkip())
	EndDo
	SD2TMP->(dbSkip())
EndDo

MsgInfo("Processados " + cValToChar(nRegs) + " registros.")

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJF410CC  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de calculo de comissões com base nos contratos de co-º±±
±±º          ³missões do vendedor 1.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*---------------------------*
Static Function RJF410CC() 
*---------------------------*
Local aArea := GetArea()
Local lFOUNDC := .F.
Local cCODCON := "" 
Local cNUMPED := SC5->C5_NUM
Local cCODVEN := SC5->C5_VEND1
Local cCODCLI := SC5->C5_CLIENTE
Local cLOJCLI := SC5->C5_LOJACLI

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + cliente    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
	dbSetOrder(3)	//Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
	dbGoTop()
    If dbSeek ( xFilial("Z12") + cCODVEN + cCODCLI )
    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN .and. Z12->Z12_CODCLI == cCODCLI 
    	    
    	    If !Empty(Z12->Z12_LOJCLI) .and. Z12->Z12_LOJCLI != cLOJCLI
    	    	Z12->(dbSkip())
    	    	Loop
    	    EndIf
    		
    		If SC5->C5_EMISSAO >= Z12->Z12_DATINI .AND. SC5->C5_EMISSAO <= Z12->Z12_DATFIN  //Z12->Z12_ATIVO == "S"
    			cCODCON := Z12->Z12_CONTRA
    			lFOUNDC := .T.
    			Exit
    		EndIf
    			
    		Z12->(dbSkip())
    	Enddo
    EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato para o vendedor + grupo de clientes    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    
    If ! lFOUNDC 	    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Posiciona sobre cliente do pedido                         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	        
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek( xFilial("SA1") + cCODCLI + cLOJCLI )       

    	If !Empty(SA1->A1_GRPVEN)		                    
			dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
			dbSetOrder(2)	//Z12_FILIAL+Z12_VENDED+Z12_GRPCLI 
			dbGoTop()
		    If dbSeek ( xFilial("Z12") + cCODVEN + SA1->A1_GRPVEN )	    	
		    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN .and. Z12->Z12_GRPCLI == SA1->A1_GRPVEN 
		    	    
		    		If SC5->C5_EMISSAO >= Z12->DATINI .AND. SC5->C5_EMISSAO <= Z12_DATFIN//Z12->Z12_ATIVO == "S"
		    			cCODCON := Z12->Z12_CONTRA
		    			lFOUNDC := .T.
		    			Exit
		    		EndIf
		    			
		    		Z12->(dbSkip())
		    	Enddo
		    EndIf		
	    EndIf	    
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contrato apenas para o vendedor       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
    If ! lFOUNDC                                     
		dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
		dbSetOrder(3)	//Z12_FILIAL+Z12_VENDED+Z12_CODCLI+Z12_LOJCLI
		dbGoTop()
	    If dbSeek ( xFilial("Z12") + cCODVEN )
	    	While !Z12->(EOF()) .and. Z12->Z12_FILIAL == xFilial("Z12") .and. Z12->Z12_VENDED == cCODVEN 
	    	    
	    	    If !Empty(Z12->Z12_CODCLI)
	    	    	Z12->(dbSkip())
	    	    	Loop
	    	    EndIf

	    	    If !Empty(Z12->Z12_GRPCLI)
	    	    	Z12->(dbSkip())
	    	    	Loop
	    	    EndIf
	    		
	    		If SC5->C5_EMISSAO >= Z12->Z12_DATINI .AND. SC5->C5_EMISSAO <= Z12->Z12_DATFIN //Z12->Z12_ATIVO == "S"
	    			cCODCON := Z12->Z12_CONTRA
	    			lFOUNDC := .T.
	    			Exit
	    		EndIf
	    			
	    		Z12->(dbSkip())
	    	Enddo
	    EndIf 	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se contrato existe                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lFOUNDC    
		dbSelectArea("Z12")	//CABECALHO CONTRATOS VENDEDORES
		dbSetOrder(1)	//Z12_FILIAL+Z12_CONTRA+Z12_VENDED    
		dbGoTop()
	    dbSeek ( xFilial("Z12") + cCODCON )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se contrato ativo e dentro do intervalo de datas ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
    	If SC5->C5_EMISSAO >= Z12->Z12_DATINI .AND. SC5->C5_EMISSAO <= Z12->Z12_DATFIN  // Z12->Z12_ATIVO == "S" .and. 
    		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Percorre itens do pedido de venda                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    		dbSelectArea("SC6")
    		dbSetOrder(1)
    		If dbSeek ( xFilial("SC6") + cNUMPED )
    		    While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cNUMPED

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro de produto.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    		    	dbSelectArea("SB1")
    		    	dbSetOrder(1)
    		    	dbSeek ( xFilial("SB1") + SC6->C6_PRODUTO )

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se o contrato possui o produto do pedido         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		    	
    		    	dbSelectArea("Z13")	//ITENS CONTRATOS VENDEDORES 
    		    	dbSetOrder(3)	//Z13_FILIAL+Z13_CONTRA+Z13_CODPRD 
    		    	dbGoTop()
    		    	If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SC6->C6_PRODUTO )

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Altera comissão do item conforme percentual do contrato.       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    		    		If RecLock("SC6", .F.)
    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
    		    			SC6->(MsUnLock())
    		    		EndIf
    		    		
    		    	Else 

						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Verifica se o contrato possui o grupo de produto do pedido     ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	    		    	dbSelectArea("Z13")	//ITENS CONTRATOS VENDEDORES 
	    		    	dbSetOrder(2)	//Z13_FILIAL+Z13_CONTRA+Z13_CODGRP
	    		    	dbGoTop()
	    		    	If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SB1->B1_GRUPO )

							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Altera comissão do item conforme percentual do contrato.       ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		    		If RecLock("SC6", .F.)
	    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
	    		    			SC6->(MsUnLock())
	    		    		EndIf
	
						Else
                            nTAMGRP := TAMSX3("B1_GRUPO")[1] - 2
	    		    		If dbSeek ( xFilial("Z13") + Z12->Z12_CONTRA + SUBSTR(SB1->B1_GRUPO,1,2) + Space(nTAMGRP) , .T. )

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Altera comissão do item conforme percentual do contrato.       ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		    		    		If RecLock("SC6", .F.)
		    		    		    SC6->C6_COMIS1 := Z13->Z13_PERCOM
		    		    			SC6->(MsUnLock())
		    		    		EndIf
		    				
		    				EndIf
						
						EndIf	    		    	
    		    	
    		    	EndIf
    		    	
    		    	SC6->(dbSkip())    		    	
    		    Enddo
    		EndIf
    		
    	EndIf    
	EndIf

	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJF410CD  ºAutor  ³Rafael Parma        º Data ³  20/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função para calculo de desconto de comissões com base sobre º±±
±±º          ³as regras de desconto de comissões.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*---------------------------*
Static Function RJF410CD() 
*---------------------------*
Local aArea := GetArea()
Local lFOUNDR := .F.
Local cCODREG := ""
Local cNUMPED := SC5->C5_NUM
Local cCODVEN := SC5->C5_VEND1
Local cCODCLI := SC5->C5_CLIENTE
Local cLOJCLI := SC5->C5_LOJACLI
Local nPerDesc := 0


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens do pedido de venda                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC6")
	dbSetOrder(1)
	If dbSeek ( xFilial("SC6") + cNUMPED )
		
		While !SC6->(EOF()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == cNUMPED
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se o item possui desconto                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ			
			// C6_PRCTAB - C6_PRCVEN
			//If SC6->C6_DESCONT != 0
			// Flavio - alterado para buscar o desconto de acordo com o campo C6_PRCTAB
			if (SC6->C6_PRCTAB - SC6->C6_PRCVEN) > 0
			  nPerDesc := ((SC6->C6_PRCTAB - (SC6->C6_X_VLORI / SC6->C6_QTDVEN)) / SC6->C6_PRCTAB) * 100

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Posiciona sobre o cadastro de produto.                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
				dbSelectArea("SB1")
			  dbSetOrder(1)
			  dbSeek ( xFilial("SB1") + SC6->C6_PRODUTO )
			
				lFOUNDR := .F.


				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o vendedor      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
				dbSetOrder(2)	//Z14_FILIAL+Z14_CODVEN
				dbGoTop()
				If dbSeek ( xFilial("Z14") + cCODVEN )
					While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODVEN == cCODVEN						
						If SC5->C5_EMISSAO >= Z14->Z14_DATINI .AND. SC5->C5_EMISSAO <= Z14->Z14_DATFIN // Z14->Z14_ATIVO == "S"
							cCODREG := Z14->Z14_CODIGO
							lFOUNDR := .T.	
							Exit
						EndIf						
						Z14->(dbSkip())
					Enddo				
				EndIf 

				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o supervidor do vendedor       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
				If ! lFOUNDR
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro do vendedor                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3") + cCODVEN )
					
					If !Empty(SA3->A3_SUPER)  
					
						dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
						dbSetOrder(3)	//Z14_FILIAL+Z14_CODSUP
						dbGoTop()
						If dbSeek ( xFilial("Z14") + SA3->A3_SUPER )
							While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODSUP == SA3->A3_SUPER						
								If SC5->C5_EMISSAO >= Z14->Z14_DATINI .AND. SC5->C5_EMISSAO <= Z14->Z14_DATFIN // Z14->Z14_ATIVO == "S"
									cCODREG := Z14->Z14_CODIGO
									lFOUNDR := .T.	
									Exit
								EndIf						
								Z14->(dbSkip())
							Enddo				
						EndIf 
					EndIf
				
				EndIf
			
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe regra de desconto para o gerente do vendedor          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								
				If ! lFOUNDR
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Posiciona sobre o cadastro do vendedor                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					dbSelectArea("SA3")
					dbSetOrder(1)
					dbSeek( xFilial("SA3") + cCODVEN )
					
					If !Empty(SA3->A3_GEREN)  
					
						dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
						dbSetOrder(4)	//Z14_FILIAL+Z14_CODGER
						dbGoTop()
						If dbSeek ( xFilial("Z14") + SA3->A3_GEREN )
							While !Z14->(EOF()) .and. Z14->Z14_FILIAL == xFilial("Z14") .and. Z14->Z14_CODGER == SA3->A3_GEREN						
								If SC5->C5_EMISSAO >= Z14->Z14_DATINI .AND. SC5->C5_EMISSAO <= Z14->Z14_DATFIN // Z14->Z14_ATIVO == "S"
									cCODREG := Z14->Z14_CODIGO
									lFOUNDR := .T.	
									Exit
								EndIf						
								Z14->(dbSkip())
							Enddo				
						EndIf 
					EndIf
				
				EndIf
			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se encontrou a regra e realiza demais validações ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ							
		
		    If lFOUNDR    
		        
					dbSelectArea("Z14")	//CABECALHO DESCONTOS COMISSOES
					dbSetOrder(1)	//Z14_FILIAL+Z14_CODIGO                                                                                                                                           
					dbSeek ( xFilial("Z14") + cCODREG )		                                                 
		        
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se regra ativa e dentro do intervalo de datas    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
			    	If SC5->C5_EMISSAO >= Z14->Z14_DATINI .and. SC5->C5_EMISSAO <= Z14->Z14_DATFIN // Z14->Z14_ATIVO == "S" .and. 
			    	
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Percorre itens da regra para determinar o percentual de desconto com base no desconto do item.   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			    		dbSelectArea("Z15")	// ITENS DESCONTOS COMISSOES
			    		dbSetOrder(1)	// Z15_FILIAL+Z15_CODIGO+Z15_ITEM
			    		dbGoTop()
			    		If dbSeek ( xFilial("Z15") + Z14->Z14_CODIGO )
			    		    While !Z15->(EOF()) .and. Z15->Z15_FILIAL == xFilial("Z15") .and. Z15->Z15_CODIGO == Z14->Z14_CODIGO
			    		      
			    		      // Flavio - implementado o controle do grupo de produto e do produto, permitindo também que se deixado
			    		      // em branco seja considerado para todos
			    		      // Pode-se também usar somente os dois primeiros dígitos do grupo			    		      
	                  if (Empty(Z15->Z15_CODGRP) .AND. Empty(Z15->Z15_CODPRD)) ;
	                  		.OR. (Z15->Z15_CODPRD == SB1->B1_COD);
	                  		.OR. (Z15->Z15_CODGRP == SB1->B1_GRUPO);
	                  		.OR. (TRIM(Z15->Z15_CODGRP) == SUBSTR(SB1->B1_GRUPO, 1, 2))
	                  // Flavio - alterado para buscar o desconto de acordo com o campo C6_PRCTAB
	                             // SC6->C6_DESCONT                // SC6->C6_DESCONT  	                  	
		                  If nPerDesc >= Z15->Z15_PRCINI .and. nPerDesc <= Z15->Z15_PRCFIN
				    		    		If RecLock("SC6", .F.)
				    		    		  SC6->C6_COMIS1 := SC6->C6_COMIS1 - ( (SC6->C6_COMIS1 * Z15->Z15_PRCDES) / 100 )
				    		    			SC6->(MsUnLock())
				    		    		EndIf
				    		    		// flavio - 06/05/2011 
				    		    		// se encontra um registro com o desconto cadastrado, pula e nao faz novamente o desconto
				    		    		Exit

		                  EndIf
	                  EndIf
	                        	
								Z15->(dbSkip())
							Enddo
						EndIf
					
					EndIf
					
				EndIf
				
      EndIf
            
		SC6->(dbSkip())    		    	
		
  	Enddo
	
	EndIf

Return


/********************************************************
 Função que recalcula o valor original com base no total da NF, 
 para os casos que não foi possível obter o total da NF
 deve ser executada por empresa.
 ********************************************************/
User Function CalcC6VOri()
Local oDlg
Private dDtIni := (dDataBase - 30)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 300,430 DIALOG oDlg TITLE "Correção do valor original do pedido"
// @ 005,005 TO 060,160
@ 010,010 Say "Data de início:" PIXEL
@ 010,070 Get dDtIni Size 60, 10 PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION (Processa({|| ProcSC6() }), Close(oDlg))
@ 065,130 BMPBUTTON TYPE 2 ACTION Close(oDlg)
ACTIVATE DIALOG oDlg CENTER
Return Nil

// função que faz o processamento da correção
Static Function ProcSC6()
Local cSql := ""
Local nProc := 0

cSql += "SELECT C6_FILIAL, C6_NUM, C6_PRODUTO, C6.R_E_C_N_O_ AS C6_RNO, "
cSql += "((D2.D2_TOTAL+D2.D2_VALIPI + D2.D2_ICMSRET) / D2.D2_QUANT) * C6.C6_QTDVEN AS C6_X_VLORI "
cSql += "FROM "+RetSqlName("SC6")+" C6 INNER JOIN "+RetSqlName("SD2")+" D2 "
cSql += " ON C6.C6_FILIAL = D2.D2_FILIAL AND C6_NUM = D2_PEDIDO AND C6_ITEM = D2_ITEMPV "
cSql += "WHERE d2.D_E_L_E_T_ <> '*' "
cSql += " and c6.D_E_L_E_T_ <> '*' "
cSql += " and D2.D2_EMISSAO >= '" + DtoS(dDtIni) + "' "
cSql += " and C6.C6_FILIAL = '"+xFilial("SC6")+"' AND C6.C6_QTDVEN > 0 "
cSql += " and C6.c6_x_vlori <> (((D2.D2_TOTAL+D2.D2_VALIPI + D2.D2_ICMSRET) / D2.D2_QUANT) * C6.C6_QTDVEN)"

TcQuery cSql New Alias "C6TMP"
         
nRegs := 0

dbSelectArea("C6TMP")

COUNT TO nRegs
          
ProcRegua(nRegs, "Processando Registros")

C6TMP->(dbGoTop())
nCount := 0
While C6TMP->(!Eof())
	IncProc()	
	nCount++
	// Posiciona no registro a alterar
	SC6->(dbGoto(C6TMP->C6_RNO))	
	
	if Round(C6TMP->C6_X_VLORI, 2) != SC6->C6_X_VLORI
		RecLock("SC6", .F.)
		SC6->C6_X_VLORI := C6TMP->C6_X_VLORI
		SC6->(MsUnlock())
	EndIf
	
	C6TMP->(dbSkip())
EndDo

MsgInfo("Processados " + cValToChar(nCount) + " registros.")

C6TMP->(dbCloseArea())

Return