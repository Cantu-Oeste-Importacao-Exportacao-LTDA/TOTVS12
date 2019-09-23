#include "rwmake.ch"
#include "totvs.ch"  
#include "topconn.ch"
#include "protheus.ch"

#DEFINE LSHOWMSG .F.            // Define se deve mostrar mensagens com os comandos sqls que serão executados no banco

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M460FIM     ºAutor  ³Rafael Parma      º Data ³  20/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³PE acionado após a gravação da nota fiscal de saida.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/        

*---------------------------*
User Function M460FIM() 
*---------------------------*
Local aArea := GetArea()

// Integração Protheus x VTEX - Atos Data Consultoria
	If ExistBlock("ADM460FIM")
		ExecBlock("ADM460FIM", .F., .F.)
	EndIf


//Douglas Martins -Atos Data - 08/04/2019 
// Tratamento para Gravar CPF no C—digo de Rastreio da NF

	If SC5->(FieldPos("C5_XSTATUS")) <> 0 .And. SC5->(FieldPos("C5_XPEDLV")) <> 0 .And.  SF2->(FieldPos("F2_XTRACKI")) <> 0 
		If !Empty(Alltrim(SF2->F2_XTRACKI)) .And. !Empty(Alltrim(SC5->C5_XPEDLV))
			RecLock("SF2", .F.)
				SF2->F2_XTRACKI := SA1->A1_CGC
			SF2->(MSUnLock())
		EndIf
	EndIf


	/*------------------------------------------------------ Augusto Ribeiro | 17/10/2018 - 11:59:18 AM
		Carrega campos de cartao de credito para o SE1
	------------------------------------------------------------------------------------------*/
	cpoCard()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza campo classe de valor e centro de custo sobre os registros relacionados.       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
 	if !IsBlind()
		RptStatus({|lEnd| fUpdCLVL(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, @lEnd)}, "Aguarde...","Atualizando informação de segmento...", .T.)
	Else
		fUpdCLVL(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processamento da rotina de calculo de bonificacao financeira   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ALLTRIM(SuperGetMV("MV_X_APRBN",,"N")) == "S"
		if !IsBlind()
			RptStatus({|lEnd| fCalBonFIN( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_EMISSAO, @lEnd )}, "Aguarde...","Calculando bonificações financeiras...", .T.)	
		Else
			fCalBonFIN( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, SF2->F2_EMISSAO )
		EndIf
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processamento da rotina de eliminacao de residuos              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ALLTRIM(SuperGetMV("MV_X_ATRTP",,"N")) == "S"
		if !IsBlind()
			RptStatus({|lEnd| fDelResiduo( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, @lEnd )}, "Aguarde...","Eliminando resíduos do pedido...", .T.)	
		Else
			fDelResiduo( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA )
		EndIf
	EndIf	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Processamento da rotina de compensação automatica devolução de compras. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ALLTRIM(SuperGetMV("MV_X_ACPAD",,"N")) == "S" .AND. SF2->F2_TIPO == "D"
		fCompDEV( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA )
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualização do status do pedido B2B Vertis.                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ALLTRIM(SuperGetMV("MV_X_AB2B",,"N")) == "S" .AND. !SF2->F2_TIPO $ "BD"
		fUpStatusB2B( SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA )
	EndIf	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualização do RECNO do item do pedido de venda no Item da nota de saída³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !IsBlind()
		RptStatus({|lEnd| fGrvRnoC6(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA, @lEnd)}, "Aguarde...","Gravando rastro entre Item da Nota x Item do Pedido...", .T.)
	Else
		fGrvRnoC6(SF2->F2_FILIAL, SF2->F2_DOC, SF2->F2_SERIE, SF2->F2_CLIENTE, SF2->F2_LOJA)
	EndIf                             
	
	RestArea(aArea)
	
 	MailVend()
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fGrvRnoC6  ºAutor  ³Jean Carlos Saggin º Data ³  20/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para gravação do rastro R_E_C_N_O_ do SC6 na tabela º±±
±±º          ³ SD2.                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento (Cálculo de Saldo Flex)                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fGrvRnoC6(cFil, cDoc, cSerie, cCliente, cLoja, lEnd)

Local aDados := {}
Local nX     := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca RECNO do SC6 e armazena em variável temporária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DbSelectArea("SC6")
SC6->(DbSetOrder(4))
if SC6->(DbSeek(cFil + cDoc + cSerie))
	While !SC6->(EOF()) .and. (SC6->C6_FILIAL + SC6->C6_NOTA + SC6->C6_SERIE == cFil + cDoc + cSerie)
		aAdd(aDados, {SC6->C6_FILIAL, SC6->C6_NOTA, SC6->C6_SERIE, SC6->C6_CLI, SC6->C6_LOJA, SC6->C6_PRODUTO, SC6->(Recno()),; 
					  SC6->C6_X_SFLEX, SC6->C6_PRCTAB, SC6->C6_X_PROMO, SC6->C6_X_KIT, SC6->C6_ITEM})
		SC6->(DbSkip())
	EndDo
EndIf    

if Len(aDados) > 0
	//SetRegua(Len(aDados))
	DbSelectArea("SD2")
	SD2->(DbSetOrder(3))
	
	for nX := 1 to Len(aDados)
		//IncRegua()
		if SD2->(DbSeek(aDados[nX, 01] + aDados[nX, 02] + aDados[nX, 03] + aDados[nX, 04] + aDados[nX, 05] + aDados[nX, 06] + aDados[nX, 12]))
			RecLock("SD2", .F.)
			SD2->D2_X_RNOC6 := aDados[nX, 07]
			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³JEAN - 21/07/14 - Gravação de informações adicionais do pedido no    
			//³                  documento de saída para agilizar cálculo do flex³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

			if FieldPos("D2_X_SFLEX") > 0 .and.;
			   FieldPos("D2_X_PTAB ") > 0 .and.;
			   FieldPos("D2_X_PROMO") > 0 .and.;
			   FieldPos("D2_X_KIT  ") > 0
				SD2->D2_X_SFLEX := aDados[nX, 08]
				SD2->D2_X_PTAB  := aDados[nX, 09]
				SD2->D2_X_PROMO := aDados[nX, 10]
				SD2->D2_X_KIT   := aDados[nX, 11]
			EndIf	
			
			SD2->(MsUnlock())
		EndIf	
	Next nX	
EndIf

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDelResiduo ºAutor  ³Rafael Parma      º Data ³  20/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o item foi liberado pela rotina customizada de  º±±
±±º          ³quantidade, caso seja realiza eliminacao por residuo.       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*---------------------------------------------------------------------------*
Static Function fDelResiduo(cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj)
*---------------------------------------------------------------------------*
Local aArea := GetArea()
Local aPEDIDOS := {}
                                                       
	dbSelectArea("SD2")
	dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
		While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj
			dbSelectArea("SC6")
			dbSetOrder(1)	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			dbGoTop()
			If dbSeek ( xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV )				
				If SC6->C6_X_QTDRT == "S" .AND. SC6->C6_QTDVEN > SC6->C6_QTDLIB
				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Processamento da rotina padrao de eliminacao de residuos       ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					MaResDoFat(SC6->(RecNo()), .F.,.T.)                                
					
				EndIf				
			EndIf                             

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciono os pedidos do documento ao array                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
			If Len(aPEDIDOS) == 0
				nPOS := 0
			Else
				nPOS := aScan ( aPEDIDOS , { |x| x[1] == SD2->D2_PEDIDO } )
			EndIf
			
			If nPOS == 0
				aAdd ( aPEDIDOS, { SD2->D2_PEDIDO } )
			EndIf
			
			SD2->(dbSkip())
		Enddo		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Elimino por resíduo os itens não faturados                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Len(aPEDIDOS) > 0
		For nI := 1 to Len(aPEDIDOS)
			dbSelectArea("SC6")
			dbSetOrder(1)	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
			dbGoTop()
			If dbSeek ( xFilial("SC6") + aPEDIDOS[nI,01] )				
				While !SC6->(EOF()) .and. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6") + aPEDIDOS[nI,01]
					If SC6->C6_X_QTDRT == "S" .AND. SC6->C6_QTDVEN > SC6->C6_QTDLIB .AND. Empty(SC6->C6_NOTA)
					
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Processamento da rotina padrao de eliminacao de residuos       ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						MaResDoFat(SC6->(RecNo()), .F., .T.)                                
						
					EndIf
					SC6->(dbSkip())
				Enddo
			EndIf       
		Next nI
	EndIf
	
	// Flavio - 01/03/2011 
	// adicionado a data e hora de alteracao do pedido
	
	If Len(aPEDIDOS) > 0
		SC5->(dbSetOrder(01))		
		For nI := 1 to Len(aPEDIDOS)
			if SC5->(dbseek(xFilial("01") + aPedidos[nI, 01]))
				RecLock("SC5", .F.)
  			SC5->C5_DTHRALT := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
  			SC5->(MsUnlock())
			endIf
		Next nI	
  EndIf
	RestArea(aArea)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalBonFIN  ºAutor  ³Rafael Parma      º Data ³  25/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Verifica se o cliente/grupo do cliente possui regra de boni-º±±
±±º          ³ficacao para gravar sobre o titulo da nota fiscal.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*--------------------------------------------------------------------------*
Static Function fCalBonFIN( cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao )
*--------------------------------------------------------------------------*
Local aArea := GetArea()
Local cCODBON := ""
Local nTOTBON := 0 
Local nNUMTIT := 0
Local nVALTOT := 0
Local nVALBRT := 0
Local lFOUND  := .F.
Local cTIPDEC := ""
Local cQuery  := ""


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Caso seja documento de Devolução/Utiliza fornecedor                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If SF2->F2_TIPO $ "D/B"	
		Return
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existência de contratos de redes para o cliente ...       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	
	aRet := U_RJCHKCRC("S", cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao)
	If !Empty(aRet[2])
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Percorre itens da nota fiscal e calcula valor da bonificação      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
			                                                       
		dbSelectArea("SD2")
		dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		dbGoTop()
		If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
			While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj
					//--Percentual de desconto
					nTOTBON += Round( ( SD2->D2_TOTAL * aRet[1] ) / 100, 2 )
					If RecLock("SD2", .F.)
						SD2->D2_X_DECRE := Round( ( SD2->D2_TOTAL * aRet[1] ) / 100, 2 )
						SD2->D2_X_PDECR := aRet[1]
						SD2->D2_X_TPDEC := "I"
						SD2->(MsUnLock())
					EndIf
				
				SD2->(dbSkip())
			Enddo		
		EndIf
		
		If nTOTBON != 0

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				    
			nNUMTIT := 0
			nVALTOT := 0
			dbSelectArea("SE1")
			dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
			dbGoTop()
			If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
				While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
					nNUMTIT += 1
					nVALTOT += SE1->E1_SALDO
					SE1->(dbSkip())
				Enddo
			EndIf
			
			Begin Transaction			
				dbSelectArea("SE1")
				dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
				dbGoTop()
				If dbSeek ( xFilial("SE1") + cCodCli + cCodLoj + cCodSer + cCodDoc )
					While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == xFilial("SE1")+cCodCli+cCodLoj+cCodSer+cCodDoc
						If RecLock("SE1", .F.)
							
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza bonificação sobre os titulos com valor correspondente               ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						SE1->E1_DECRESC := Round ( ( nTOTBON * SE1->E1_SALDO ) / nVALTOT, 2 ) 
						SE1->E1_SDDECRE := SE1->E1_DECRESC
						SE1->E1_X_NSCRC := aRet[2]
						SE1->(MsUnLock())
						
						EndIf
						SE1->(dbSkip())
					Enddo
				EndIf			
			End Transaction	
		EndIf	
  
	Else
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de regra de bonificação por cliente + loja     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		dbSelectArea("Z16")	//CABECALHO BONIFICACOES PEDIDOS
		
		cQuery := "select z16_codigo, z16_regra from "+ RetSqlName("Z16") +" "
		cQuery += "where z16_filial = '"+ xFilial("Z16") +"' "
		cQuery += "  and z16_codcli = '"+ cCodCli +"' "
		cQuery += "  and z16_lojcli = '"+ cCodLoj +"' "
		cQuery += "  and z16_ativo  = 'S' "
		cQuery += "  and '"+ DtoS(Date()) +"' between z16_datini and z16_datfin "
		cQuery += "  and d_e_l_e_t_ = ' ' "
		
		TcQuery cQuery New Alias "bontmp"
		
		If LSHOWMSG
			Aviso("Codigo Cabecalho Bonificacoes", cQuery, {"Ok"}, 3)
		EndIf
		
		DbSelectArea("bontmp")
		bontmp->(DbGoTop())
		
		If !bontmp->(EOF())
			cCODBON := bontmp->z16_codigo
			cTIPDEC := bontmp->z16_regra
			lFOUND  := .T.
		Else
			bontmp->(DbCloseArea())
			
			cQuery := "select z16_codigo, z16_regra from "+ RetSqlName("Z16") +" "
			cQuery += "where z16_filial = '"+ xFilial("Z16") +"' "
			cQuery += "  and z16_codcli = '"+ cCodCli +"' "
			cQuery += "  and z16_lojcli = ' ' "
			cQuery += "  and z16_ativo  = 'S' "
			cQuery += "  and '"+ DtoS(Date()) +"' between z16_datini and z16_datfin "
			cQuery += "  and d_e_l_e_t_ = ' ' "	 
			
			TcQuery cQuery New Alias "bontmp"		

			If LSHOWMSG
				Aviso("Cabecalho Bonificacoes Sem Filial", cQuery, {"Ok"}, 3)
			EndIf			

			DbSelectArea("bontmp")
			bontmp->(DbGoTop())
			
			If !bontmp->(EOF())
				cCODBON := bontmp->z16_codigo
				cTIPDEC := bontmp->z16_regra
				lFOUND  := .T.
			Else
				bontmp->(DbCloseArea())
				Return	
			EndIf
			
		EndIf
		
		bontmp->(DbCloseArea())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se encontrou a regra de bonificação              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
	    
	    If lFOUND
	    	
	    	cQuery := "select d2.r_e_c_n_o_ recd2, Trim(d2.d2_cod) codigo, "
	    	cQuery += "       z17.z17_prcbon percentual, Round(( d2.d2_total * z17.z17_prcbon ) / 100,2) calc "
	    	cQuery += "from "+ RetSqlName("SD2") +" d2 "
			
			cQuery += "inner join "+ RetSqlName("Z17") +" z17 "
			cQuery += " on z17.z17_filial = '"+ xFilial("Z17") +"' "
			cQuery += "and z17.z17_codigo = '"+ cCODBON +"' "
			cQuery += "and (z17.z17_codprd = d2.d2_cod or z17.z17_codgrp = d2.d2_grupo) "
			cQuery += "and z17.d_e_l_e_t_ = ' ' "
			
			cQuery += "where d2.d2_filial  = '"+ xFilial("SD2") +"' "
			cQuery += "  and d2.d2_doc     = '"+ cCodDoc +"' "
			cQuery += "  and d2.d2_serie   = '"+ cCodSer +"' "
			cQuery += "  and d2.d2_cliente = '"+ cCodCli +"' "
			cQuery += "  and d2.d2_loja    = '"+ cCodLoj +"' "
			cQuery += "  and d2.d_e_l_e_t_ = ' '"
            
            TcQuery cQuery New Alias "d2calc"
            
            If LSHOWMSG
				Aviso("Codigo Cabecalho Bonificacoes", cQuery, {"Ok"}, 3)
			EndIf
    
            DbSelectArea("d2calc")
            d2calc->(DbGoTop())
            
            If !d2calc->(EOF())
            	While !d2calc->(EOF())
            		nResult := 0
            		nResult := TcSqlExec("update "+ RetSqlName("SD2") +" set d2_x_decre = "+ AllTrim(Str(d2calc->calc)) +;
            						     ", d2_x_pdecr = "+ AllTrim(Str(d2calc->percentual)) +;
            						     ", d2_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ AllTrim(Str(recd2)))

       				If LSHOWMSG
						Aviso("Update SD2", "update "+ RetSqlName("SD2") +" set d2_x_decre = "+ AllTrim(Str(d2calc->calc)) +;
            						     ", d2_x_pdecr = "+ AllTrim(Str(d2calc->percentual)) +;
            						     ", d2_x_tpdec = '"+ cTIPDEC +"' where r_e_c_n_o_ = "+ AllTrim(Str(recd2)), {"Ok"}, 3)
					EndIf

            		if nResult < 0
            			cMsgTmp := "Cliente:  "+ cCodCli + CHR(13)+CHR(10)
            			cMsgTmp += "Loja:     "+ cCodLoj + CHR(13)+CHR(10)
            			cMsgTmp += "Produto:  "+ d2calc->codigo + CHR(13)+CHR(10)
            			cMsgTmp += "Desconto: "+ Transform(d2calc->calc, "@E 99,999.99")
            			Aviso("Desconto","Erro na gravação do desconto do cliente: "+ CHR(13)+CHR(10) + cMsgTmp,{"Ok"},3)
            		Else
            			nTOTBON += d2calc->calc	
            		EndIf
            		d2calc->(DbSkip())
            	EndDo
            Else
            	d2calc->(DbCloseArea())
            	Return	
            EndIf
            
            d2calc->(DbCloseArea())
			
			If nTOTBON != 0
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica quantidade/valor dos titulos e grava o valor da bonificação para cada titulo.  ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					    
				nVALTOT := 0
                
                DbSelectArea("SE1")
                
				cQuery := "select sum(e1.e1_saldo) saldo from "+ RetSqlName("SE1") +" e1 "
				cQuery += "where e1.e1_filial  = '"+ xFilial("SE1") +"' "
				cQuery += "  and e1.e1_cliente = '"+ cCodCli +"' "
				cQuery += "  and e1.e1_loja    = '"+ cCodLoj +"' "
				cQuery += "  and e1.e1_prefixo = '"+ cCodSer +"' "
				cQuery += "  and e1.e1_num     = '"+ cCodDoc +"' "
				cQuery += "  and e1.d_e_l_e_t_ = ' ' "
				
				TcQuery cQuery New Alias "e1temp"
				
				If LSHOWMSG
					Aviso("Total Títulos SE1", cQuery, {"Ok"}, 3)
				EndIf
				
				DbSelectArea("e1temp")
				e1temp->(DbGoTop())
				
				If e1temp->saldo > 0
					nVALTOT := e1temp->saldo	
				EndIf                       
				
				e1temp->(DbCLoseArea())
				
				if nVALTOT > 0
					
					cQuery := "select e1.r_e_c_n_o_ rece1, e1.e1_num, e1.e1_parcela, Round( ( "+ AllTrim(Str(nTOTBON)) +" * e1.e1_saldo) / "+ ALlTrim(Str(nValTot)) +",2) desconto, "
					cQuery += "       Round ( ( Round( ("+ AllTrim(Str(nTOTBON)) +" * e1.e1_saldo) / "+ ALlTrim(Str(nValTot)) +",2) * 100 ) / e1.e1_saldo, 2) percentual "
					cQuery += "from "+ RetSqlName("SE1") +" e1 "
					cQuery += "where e1.e1_filial  = '"+ xFilial("SE1") +"' "
					cQuery += "  and e1.e1_cliente = '"+ cCodCli +"' "
					cQuery += "  and e1.e1_loja    = '"+ cCodLoj +"' "
					cQuery += "  and e1.e1_prefixo = '"+ cCodSer +"' "
					cQuery += "  and e1.e1_num     = '"+ cCodDoc +"' "
					cQuery += "  and e1.d_e_l_e_t_ = ' ' "
					
					TcQuery cQuery New Alias "e1temp"

					If LSHOWMSG
						Aviso("Calculo Descontos x Titulo", cQuery, {"Ok"}, 3)
					EndIf					

					DbSelectArea("e1temp")
					e1temp->(DbGoTop())
					
					If !e1temp->(EOF())
						While !e1temp->(EOF())
							nResult := 0

		            		If cTIPDEC == "C"
		            			nResult := TcSqlExec("update "+ RetSqlName("SE1") +" set e1_descfin = "+ AllTrim(Str(e1temp->percentual)) +;
		            						     ", e1_descont = "+ AllTrim(Str(e1temp->desconto)) +;
		            						     " where r_e_c_n_o_ = "+ AllTrim(Str(rece1)))
		            						     
								If LSHOWMSG
									Aviso("Query Desconto Condicional", "update "+ RetSqlName("SE1") +" set e1_descfin = "+ AllTrim(Str(e1temp->percentual)) +;
			            						     ", e1_descont = "+ AllTrim(Str(e1temp->desconto)) +;
			            						     " where r_e_c_n_o_ = "+ AllTrim(Str(rece1)), {"Ok"}, 3)
								EndIf

		            		Else
		            			nResult := TcSqlExec("update "+ RetSqlName("SE1") +" set e1_decresc = "+ AllTrim(Str(e1temp->desconto)) +;
		            						     	 ", e1_sddecre = "+ AllTrim(Str(e1temp->desconto)) +;
		            						     	 " where r_e_c_n_o_ = "+ AllTrim(Str(rece1)))
		            			
		            			If LSHOWMSG
									Aviso("Query Desconto Incondicional", "update "+ RetSqlName("SE1") +" set e1_descfin = "+ AllTrim(Str(e1temp->percentual)) +;
			            						     ", e1_descont = "+ AllTrim(Str(e1temp->desconto)) +;
			            						     " where r_e_c_n_o_ = "+ AllTrim(Str(rece1)), {"Ok"}, 3)
								EndIf
		            		
		            		EndIf

		            		if nResult < 0
		            			cMsgTmp := "Cliente:  "+ cCodCli + CHR(13)+CHR(10)
		            			cMsgTmp += "Loja:     "+ cCodLoj + CHR(13)+CHR(10)
		            			cMsgTmp += "Titulo:   "+ e1temp->e1_num + iif(!Empty(e1temp->e1_parcela)," - " + e1temp->e1_parcela,"") + CHR(13)+CHR(10)
		            			cMsgTmp += "Desconto: "+ Transform(e1temp->desconto, "@E 99,999.99")
		            			Aviso("Desconto","Erro na gravação do desconto do cliente: "+ CHR(13)+CHR(10) + cMsgTmp,{"Ok"},3)	
		            		EndIf                                                                                               
		            		
							e1temp->(DbSkip())
						EndDo
					EndIf
					
					e1temp->(DbCloseArea())
						
				EndIf
				
			EndIf
		    
		EndIf
	
	EndIf	

	RestArea(aArea)

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCompDEV    ºAutor  ³Rafael Parma      º Data ³  27/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por realizar a compensação automática en-º±±
±±º          ³tre os títulos do documento de compras e devolução.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*--------------------------------------------------------------------------*
Static Function fCompDEV( cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj )
*--------------------------------------------------------------------------*
Local aArea := GetArea()
Local aTITPAG := {}
Local aTITNDF := {}         
Local nTOTPAG := 0
Local nTOTNDF := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Carrega o pergunte da rotina de compensação financeira³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PERGUNTE("AFI340",.F.)
	lContabiliza:= MV_PAR11 == 1
	lAglutina	:= MV_PAR08 == 1
	lDigita		:= MV_PAR09 == 1

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza número e serie do documento de origem                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
                                                       
	dbSelectArea("SD2")
	dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
	
		If !Empty(SD2->D2_NFORI) .and. !Empty(SD2->D2_SERIORI)
			
			dbSelectArea("SF1")
			dbSetOrder(1)	//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			dbGoTop()
			If dbSeek ( xFilial("SF1") + SD2->D2_NFORI + SD2->D2_SERIORI + cCodCli + cCodLoj )

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Armazena títulos do documento de origem com saldo                 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    
			
				dbSelectArea("SE2")
				dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
				dbGoTop()
				If dbSeek ( xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC )
					While !SE2->(EOF()) .and. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == ;
										xFilial("SE2") + SF1->F1_FORNECE + SF1->F1_LOJA + SF1->F1_SERIE + SF1->F1_DOC						
						If SE2->E2_SALDO > 0
							aAdd ( aTITPAG, SE2->(RECNO()) )
							nTOTPAG += SE2->E2_SALDO
						EndIf
						SE2->(dbSkip())
					Enddo				
				EndIf
			
			EndIf
		
		EndIf


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Armazena títulos do documento de devolução com saldo              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    

		dbSelectArea("SE2")
		dbSetOrder(6)	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
		dbGoTop()
		If dbSeek ( cCodFil + cCodCli + cCodLoj + cCodSer + cCodDoc )
			While !SE2->(EOF()) .and. SE2->E2_FILIAL + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM == ;
								 cCodFil + cCodCli + cCodLoj + cCodSer + cCodDoc 
				If SE2->E2_SALDO > 0 .and. SE2->E2_TIPO == "NDF"
					aAdd ( aTITNDF, SE2->(RECNO()) )            
					nTOTNDF += SE2->E2_SALDO
				EndIf
				SE2->(dbSkip())
			Enddo				
		EndIf

	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Realiza a compensação entre os títulos contas a pagar.            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    

	If Len(aTITPAG) > 0 .and. Len(aTITNDF) > 0
	    

		If ! MaIntBxCP(2,aTITPAG,,aTITNDF,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,ddatabase)
			Help("XAFCMPAD",1,"HELP","XAFCMPAD","Não foi possível a compensação"+CRLF+" do titulo do adiantamento",1,0)	
		Else
			If nTOTPAG < nTOTNDF
			
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Envio de workflow - diferença de valores                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							
				cMOTIVO := "SALDO TOTAL DOS TÍTULOS DE COMPRAS MENOR QUE O VALOR DO TÍTULO NDF - DEVOLUÇÃO."
				fWFCMPDVC(cMOTIVO, nTOTNDF, nTOTPAG, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_SERIE, SF1->F1_DOC, cCodSer, cCodDoc)
			EndIf
			
		EndIf
	
	ElseIf Len(aTITNDF) > 0 .and. Len(aTITPAG) == 0


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Envio de workflow - saldo título de compras zerado                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

		cMOTIVO := "TÍTULOS DE COMPRAS SEM SALDO PARA COMPENSAR COM TÍTULO NDF - DEVOLUÇÃO."
		fWFCMPDVC(cMOTIVO, nTOTNDF, nTOTPAG, SF1->F1_FORNECE, SF1->F1_LOJA, SF1->F1_SERIE, SF1->F1_DOC, cCodSer, cCodDoc)
	                             	
	EndIf                        
	
	
	RestArea(aArea)

Return      
      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdCLVL   ºAutor  ³Rafael Parma       º Data ³  06/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para atualizar campo classe de valor sobre títulos   º±±
±±º          ³do documento.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------------------------------------*
Static Function fUpdCLVL(cFILDOC, cNUMDOC, cSERDOC, cCLIDOC, cLOJDOC, lEnd)
*------------------------------------------------------------------------*
Local aArea := GetArea()
Local cXCCDEF := ALLTRIM(GETMV("MV_X_CCDEF"))	// Centro custo default vendas
Local cXCLVLF := ""	// Classe valor
Local lUpdCC  := .T.
	
	dbSelectArea("SC5")
	dbSetOrder(5)	//C5_FILIAL+C5_NOTA+C5_SERIE 
	dbGoTop()
	If dbSeek( cFILDOC + cNUMDOC + cSERDOC )
		If !Empty(SC5->C5_X_CLVL) .AND. SF2->F2_TIPO != "D"
			
			cXCLVLF := SC5->C5_X_CLVL  
			
			If !Empty(SC5->C5_X_CC)
				cXCCDEF := SC5->C5_X_CC
			EndIf
			
			Begin Transaction
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza título campo classe de valor                             ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				dbSelectArea("SE1")
				dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
				dbGoTop()
				If dbSeek (cFILDOC + cCLIDOC + cLOJDOC + cSERDOC + cNUMDOC )
					While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == cFILDOC+cCLIDOC+cLOJDOC+cSERDOC+cNUMDOC
						If RecLock("SE1", .F.)
							If lUpdCC
								SE1->E1_CCC := cXCCDEF
							EndIf
							SE1->E1_CLVLCR := SC5->C5_X_CLVL
							SE1->(MsUnLock())					
						EndIf
						SE1->(dbSkip())
					Enddo
				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualiza itens documento campo classe de valor                    ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
				dbSelectArea("SD2")
				dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
				dbGoTop()
				If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )
					While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC
						If RecLock("SD2",.F.)
							If lUpdCC
								SD2->D2_CCUSTO := cXCCDEF
							EndIf
							SD2->D2_CLVL := SC5->C5_X_CLVL
							SD2->(MsUnLock())
						EndIf
						SD2->(dbSkip())
					Enddo
				EndIf			
			
			End Transaction
		
		Else
	
			If SF2->F2_TIPO == "D"  //Tratativa PCO se nota for Devolução
				
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbGoTop()
				If DbSeek(xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_COD+SD2->D2_ITEMORI)
					If SD1->D1_RATEIO == '1'
						DbSelectArea("SDE")
						DbSetOrder(1)
						DbGoTop()
						If Dbseek(xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_ITEM)
							PCOINILAN("999002")
							While !EOF() .AND. SDE->DE_FILIAL+SDE->DE_DOC+SDE->DE_SERIE+SDE->DE_FORNECE+SDE->DE_LOJA+SDE->DE_ITEMNF==xFilial("SD1")+SD2->D2_NFORI+SD2->D2_SERIORI+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_ITEMORI																																
								Begin Transaction
									PCODETLAN("999002","01","M460FIM")
								End Transaction
								SDE->( dbSkip() )
							EndDo
							PCOFINLAN("999002")	
						EndIf
					EndIf
				EndIf	
		
				If !Empty(SC5->C5_X_CLVL)
					
					cXCLVLF := SC5->C5_X_CLVL  
					If !Empty(SC5->C5_X_CC)
						cXCCDEF := SC5->C5_X_CC
					EndIf
					
					Begin Transaction
				
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza título campo classe de valor                             ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						dbSelectArea("SE2")
						dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
						dbGoTop()
						If dbSeek (cFILDOC + cCLIDOC + cLOJDOC + cSERDOC + cNUMDOC )
							While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == cFILDOC+cCLIDOC+cLOJDOC+cSERDOC+cNUMDOC
								If RecLock("SE2", .F.)
									If lUpdCC
										SE2->E2_CCD := cXCCDEF
									EndIf
									SE2->E2_CLVLDB := SC5->C5_X_CLVL
									SE2->(MsUnLock())					
								EndIf
								SE2->(dbSkip())
							Enddo
						EndIf
		
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Atualiza itens documento campo classe de valor                    ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
						dbSelectArea("SD2")
						dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
						dbGoTop()
						If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )
							While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC
								If RecLock("SD2",.F.)
									If lUpdCC
										SD2->D2_CCUSTO := cXCCDEF
									EndIf
									SD2->D2_CLVL := SC5->C5_X_CLVL
									SD2->(MsUnLock())
								EndIf
								SD2->(dbSkip())
							Enddo
						EndIf			
					
					End Transaction
				EndIf
				
			EndIf	
		EndIf
			
	Else
		
		dbSelectArea("SD2")
		dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		dbGoTop()
		If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )        	
        	cNUMPED := SD2->D2_PEDIDO
			dbSelectArea("SC5")
			dbSetOrder(1)	//C5_FILIAL+C5_NUM
			dbGoTop()
			If dbSeek( cFILDOC + cNUMPED )
				If !Empty(SC5->C5_X_CLVL) 
					
					cXCLVLF := SC5->C5_X_CLVL

					If SF2->F2_TIPO != "D"
					
						Begin Transaction
					
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza título campo classe de valor                             ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							dbSelectArea("SE1")
							dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
							dbGoTop()
							If dbSeek (cFILDOC + cCLIDOC + cLOJDOC + cSERDOC + cNUMDOC )
								While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == cFILDOC+cCLIDOC+cLOJDOC+cSERDOC+cNUMDOC
									If RecLock("SE1", .F.)
										If lUpdCC
											SE1->E1_CCC := cXCCDEF
										EndIf								
										SE1->E1_CLVLCR := SC5->C5_X_CLVL
										SE1->(MsUnLock())					
									EndIf
									SE1->(dbSkip())
								Enddo
							EndIf
			
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza itens documento campo classe de valor                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							dbSelectArea("SD2")
							dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
							dbGoTop()
							If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )
								While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC
									If RecLock("SD2",.F.) 
										If lUpdCC
											SD2->D2_CCUSTO := cXCCDEF
										EndIf								
										SD2->D2_CLVL := SC5->C5_X_CLVL
										SD2->(MsUnLock())
									EndIf
									SD2->(dbSkip())
								Enddo
							EndIf			
						
						End Transaction
					
					Else 
					
						Begin Transaction
					
	
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza título campo classe de valor                             ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							dbSelectArea("SE2")
							dbSetOrder(6) 	//E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO
							dbGoTop()
							If dbSeek (cFILDOC + cCLIDOC + cLOJDOC + cSERDOC + cNUMDOC )
								While !SE2->(EOF()) .and. SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == cFILDOC+cCLIDOC+cLOJDOC+cSERDOC+cNUMDOC
									If RecLock("SE2", .F.)
										If lUpdCC
											SE2->E2_CCD := cXCCDEF
										EndIf
										SE2->E2_CLVLDB := SC5->C5_X_CLVL
										SE2->(MsUnLock())					
									EndIf
									SE2->(dbSkip())
								Enddo
							EndIf
	
			
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Atualiza itens documento campo classe de valor                    ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
							dbSelectArea("SD2")
							dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
							dbGoTop()
							If dbSeek ( cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC )
								While !SD2->(EOF()) .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == cFILDOC + cNUMDOC + cSERDOC + cCLIDOC + cLOJDOC
									If RecLock("SD2",.F.) 
										If lUpdCC
											SD2->D2_CCUSTO := cXCCDEF
										EndIf								
										SD2->D2_CLVL := SC5->C5_X_CLVL
										SD2->(MsUnLock())
									EndIf
									SD2->(dbSkip())
								Enddo
							EndIf			
						
						End Transaction

					EndIf
				EndIf
		
			EndIf
		EndIf        			
	EndIf		
    
    //-- Atualiza registros de comissões.
	If ( cXCLVLF != ""  .or. cXCCDEF != "" )
		dbSelectArea("SE3")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SE3") + cSERDOC + cNUMDOC )
			While !SE3->(EOF()) .and. SE3->E3_FILIAL + SE3->E3_PREFIXO + SE3->E3_NUM == xFilial("SE3") + cSERDOC + cNUMDOC
				If RecLock("SE3",.F.)
					SE3->E3_CCD    := cXCCDEF
					SE3->E3_CLVLDB := cXCLVLF
					SE3->(MsUnLock())
				EndIf
				SE3->(dbSkip())
			Enddo
		EndIf
	EndIf

	RestArea(aArea)
	
Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fWFCMPDVC  ºAutor  ³Rafael Parma       º Data ³  08/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para enviar workflow informativo sobre compensação   º±±
±±º          ³devolução de compras.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function fWFCMPDVC( cMOTIVO, nTOTNDF, nTOTPAG, cFORNECE, cLOJFOR, cSERORI, cDOCORI, cSERDEV, cDOCDEV )
Local aArea  := GetArea()
Local cEmail := ""
Local oProcess
    
	conout("WF - WFCMPDVC - INICIO DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO COMPRAS ")
	
	// Busca o email da configuracao
	cEmail  := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "WFCMPDVC", "ZWF_EMAIL"))
	
	If cEmail == "" 
		conout("WF - WFCMPDVC - E-MAIL NAO LOCALIZADO - PROCESSO: WFCMPDVC ")
		Return
	EndIf


	oProcess := TWFProcess():New( "WFCMPDVC", "DEVOLUCAO DE COMPRAS")
	oProcess:NewTask( "WFCMPDVC", "\workflow\WFCMPDVC.html")
	
	oProcess:cSubject :=  "WF - COMPENSAÇÃO FINANCEIRA - DEVOLUÇÃO DE COMPRAS" 
							
	oHTML := oProcess:oHTML
	                                             
	oHtml:ValByName("DDATABASE"	, DTOC(ddatabase)	)
	oHtml:ValByName("CUSUARIO"	, ALLTRIM(UPPER(CUSERNAME)))
	oHtml:ValByName("CMOTIVO"	, ALLTRIM(UPPER(cMOTIVO)))
	oHtml:ValByName("CFORNECE"	, cFORNECE+"/"+cLOJFOR+"-"+ALLTRIM(Posicione("SA2",1,xFilial("SA2")+cFORNECE+cLOJFOR,"A2_NOME")))
	oHtml:ValByName("CEMPRESA"	, ALLTRIM(UPPER(SM0->M0_NOME)) + " - " + ALLTRIM(UPPER(SM0->M0_FILIAL))	)

	oHtml:ValByName("NVALDEV"	, Transform(nTOTNDF, "@E 999,999,999.99"))
	oHtml:ValByName("NVALCOM"	, Transform(nTOTPAG, "@E 999,999,999.99"))
	oHtml:ValByName("CDOCORI"	, cDOCORI+"/"+cSERORI	)
	oHtml:ValByName("CDOCDEV"	, cDOCDEV+"/"+cSERDEV	)
	
	If nTOTPAG > 0
		cVBAIXA := "Valor compensado: "+Transform(nTOTPAG, "@E 999,999,999.99")
	Else
		cVBAIXA := " "
	EndIf
	
	oHtml:ValByName("CVBAIXA"	, cVBAIXA	)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa itens do array                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	oProcess:cTo  := LOWER(cEmail) 
	
	ConOut("WF - WFCMPDVC - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - WFCMPDVC - FIM DO ENVIO DE EMAIL - COMPENSACAO DEVOLUCAO COMPRAS")

	RestArea(aArea)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpStatusB2BºAutor  ³Rafael Parma      º Data ³  03/04/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Atualização do status do pedido de venda para B2B Vertis.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  

*---------------------------------------------------------------------------*
Static Function fUpStatusB2B(cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj)
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Local aPEDIDOS	:= {}    
Local cB2BNN	:= ""
                                                       
	dbSelectArea("SD2")
	dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
		dbSelectArea("SC5")
		dbSetOrder(1)	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
		dbGoTop()
		If dbSeek ( xFilial("SC5") + SD2->D2_PEDIDO)				
			If SC5->C5_X_IB2B == "S"
				If RecLock("SC5",.F.)
					SC5->C5_X_SB2B	:= "105"	//--105=Nota fiscal emitida
					SC5->C5_X_ESB2B	:= "S"
					SC5->(MsUnLock())
				EndIf
					
				If !Empty(SC5->C5_X_PB2B) .and. Z51->(FieldPos("Z51_SB2B")) > 0
					dbSelectArea("Z51")
					dbSetOrder(1)
					If dbSeek( SC5->(C5_FILIAL+C5_X_PB2B) )
						If RecLock("Z51",.F.)				
							Z51->Z51_SB2B := "105" 	//--105=Nota fiscal emitida
							Z51->(MsUnLock())
						EndIf
						If Z51->(FieldPos("Z51_NOSNUM")) > 0
							cB2BNN := Z51->Z51_NOSNUM
						EndIf
					EndIf
				EndIf
				
				If ALLTRIM(cB2BNN) != ""
					dbSelectArea("SE1")
					dbSetOrder(2) 	//E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO 	
					dbGoTop()
					If dbSeek (SD2->(D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC))
						While !SE1->(EOF()) .and. SE1->E1_FILIAL+SE1->E1_CLIENTE+SE1->E1_LOJA+SE1->E1_PREFIXO+SE1->E1_NUM == SD2->(D2_FILIAL+D2_CLIENTE+D2_LOJA+D2_SERIE+D2_DOC)
							If RecLock("SE1", .F.)
								SE1->E1_NUMBCO  := cB2BNN
								SE1->E1_PORTADO := "001"
								SE1->E1_AGEDEP  := "3402"
								SE1->E1_CONTA   := "00060888"
								SE1->(MsUnLock())					
							EndIf
							SE1->(dbSkip())
						Enddo
					EndIf				
				EndIf      
				
				//--Envia novo status do pedido para B2B
				U_RJUSPB2B(.T.,SC5->C5_FILIAL, SC5->C5_NUM)

			EndIf
		EndIf
	EndIf

	RestArea(aAreaTMP)
	
Return


/*********************************************************************************
 Faz o processo de enviar o email para o vendedor confirmando o faturamento do pedido
*********************************************************************************/
Static Function MailVend()
Local cEmail := ""
Local aArea := GetArea()
Local cVend := SF2->F2_VEND1
Local cEmailVend := ""
Local cCli := ""
Local cLojaCli := ""
Local oProcess
Local oHtml 
Local cEol := CHR(13)+CHR(10)
Local cSQl := ""
Local nTotal := 0  
Local nCusto := 0 
Local cProcess := OemToAnsi("008080") // Numero do Processo

cStatus := OemToAnsi("001011")
cCli := SF2->F2_CLIENTE
cLojaCli := SF2->F2_LOJA 
nDocument := SF2->F2_DOC
nSerie := SF2->F2_SERIE

// Somente envia email para pedidos de venda normal
if SF2->F2_TIPO != "N"
	Return
EndIf

SD2->(dbSetOrder(03))
SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE))

SC5->(dbSetOrder(01))
SC5->(dbSeek(xFilial("SC5")+SD2->D2_PEDIDO))


cPedSim := SC5->C5_COTACAO

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Faturado"))
oProcess:NewTask(cStatus,"\workflow\wfpedfaturado.html")
oProcess:cSubject := OemToAnsi("Pedido " + SD2->D2_PEDIDO + " faturado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))


cEmail := SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

oProcess:cTo := ALLTRIM(cEmail)
oProcess:cCC := SuperGetMV("MV_X_PDFAT", ,"sfa@cantu.com.br") //Cadastro de e-mail que o WF será enviado

cTipoFrete := ""

Do Case
	Case SF2->F2_TPFRETE == "C"
		cTipoFrete := "CIF"
	Case SF2->F2_TPFRETE == "F"
		cTipoFrete := "FOB"
	Case SF2->F2_TPFRETE == "T"
		cTipoFrete := "POR CONTA DE TERCEIRO"
	Case SF2->F2_TPFRETE == "S"
		cTipoFrete := "SEM FRETE"	
EndCase                                         

cSql := "SELECT D2_FILIAL, D2_DOC, D2_PEDIDO, D2_SERIE, D2_COD, B1_DESC, D2_ITEM ,D2_PRUNIT, D2_QUANT," +cEol
cSql += "ROUND(D2_QUANT * D2_PRUNIT, 2) AS TOTAL, F2_TRANSP, A4_COD, A4_NOME, A4_END, C5_TPFRETE, A4_VIA, A1_NOME, A1_END, D2.D2_VALIPI, D2.D2_ICMSRET FROM " +retSqlName("SD2")+ " D2"	  +cEol
cSql += "LEFT JOIN " +retSqlName("SB1CMP")+ " B1 ON B1.B1_COD = D2.D2_COD" +cEol 
cSql += "AND B1.D_E_L_E_T_ <> '*'" +cEol
cSql += "LEFT JOIN " +retSqlName("SF2")+ " F2 ON F2.F2_DOC = D2.D2_DOC "     +cEol
cSql += "AND F2.F2_SERIE = D2.D2_SERIE" +cEol
cSql += "AND F2.F2_FILIAL = D2.D2_FILIAL" +cEol
cSql += "AND F2.D_E_L_E_T_ <> '*'" +cEol
cSql += "LEFT JOIN " +retSqlName("SC5")+ " C5 ON C5.C5_NUM = D2.D2_PEDIDO" +cEol
cSql += "AND C5.C5_FILIAL = D2.D2_FILIAL" +cEol
cSql += "AND C5.C5_CLIENT = D2.D2_CLIENTE" +cEol
cSql += "AND C5.C5_LOJACLI = D2.D2_LOJA" +cEol
cSql += "AND C5.D_E_L_E_T_ <> '*'" +cEol
cSql += "LEFT JOIN " +retSqlName("SA1CMP")+ " A1 ON D2.D2_CLIENTE = A1.A1_COD" +cEol
cSql += "AND D2.D2_LOJA = A1.A1_LOJA" +cEol
cSql += "AND A1.D_E_L_E_T_ <> '*'" +cEol
cSql += "LEFT JOIN  " +retSqlName("SA4CMP")+ " A4 ON C5.C5_TRANSP = A4.A4_COD" +cEol
cSql += "AND A4.D_E_L_E_T_ <> '*'" +cEol
cSql += "WHERE D2.D_E_L_E_T_ <> '*'" +cEol 
cSql += "AND D2.D2_DOC = '"+nDocument+"' " +cEol
cSql += "AND D2.D2_SERIE = '"+nSerie+"' "	  +cEol
cSql += "AND D2.D2_FILIAL = '"+xFilial("SD2")+"' " +cEol
cSql += "ORDER BY D2_FILIAL, D2_DOC, D2_SERIE, D2_ITEM" +cEol

TCQUERY cSql NEW ALIAS "D2TMP"

DbSelectArea("D2TMP")
D2TMP->(DbGoTop())    

oHtml:= oProcess:oHtml	

                                  
// Preenchimento do cabeçalho do pedido	
oHtml:ValByName("DATA"   ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE", cCli + " - " + cLojaCli + " - " + Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"))
oHtml:ValByName("VENDEDOR", cNomeVend)
oHtml:ValByName("PEDSIM" ,cPedSim)
oHtml:ValByName("PEDSIGA",SD2->D2_PEDIDO)
oHtml:ValByName("SERIE" ,SF2->F2_SERIE)
oHtml:ValByName("NOTAFISCAL" ,SF2->F2_DOC)
oHtml:ValByName("TRANSP" ,D2TMP->A4_NOME)
oHtml:ValByName("MODALIDADE" , D2TMP->A4_VIA)
oHtml:ValByName("LENTREGA" ,D2TMP->A1_END)
oHtml:ValByName("TPFRETE" ,cTipoFrete) 
oHtml:ValByName("CONDPAG" ,SC5->C5_CONDPAG) 


  
While D2TMP->(!EOF())
	nTotal     += D2TMP->TOTAL
	nIcmsItem  := D2TMP->D2_ICMSRET / D2TMP->D2_QUANT
	nIPIItem   := D2TMP->D2_VALIPI / D2TMP->D2_QUANT
	nTotalItem := D2TMP->D2_PRUNIT + nIcmsItem + nIPIItem
	nTotalImpo := D2TMP->TOTAL + D2TMP->D2_VALIPI + D2_ICMSRET
	
	AAdd((oHtml:ValByName("IT.CODPRODUT" )),  D2TMP->D2_COD)
	AAdd((oHtml:ValByName("IT.PRODUT"    )),  D2TMP->B1_DESC)
	AAdd((oHtml:ValByName("IT.QTDE"      )),  Transform(D2TMP->D2_QUANT  ,"@E 9,999,999,999.99")) 
	AAdd((oHtml:ValByName("IT.PREUNIT"   )),  Transform(D2TMP->D2_PRUNIT ,"@E 9,999,999,999.99")) 
	//AAdd((oHtml:ValByName("IT.PRETOT"    )),  Transform(D2TMP->TOTAL     ,"@E 9,999,999,999.99"))
	AAdd((oHtml:ValByName("IT.STITE"     )),  Transform(nIcmsItem        ,"@E 9,999,999,999.99"))//ST
	AAdd((oHtml:ValByName("IT.IPIITE"    )),  Transform(nIPIItem         ,"@E 9,999,999,999.99"))//IPI
	AAdd((oHtml:ValByName("IT.TOTUNIT"   )),  Transform(nTotalItem       ,"@E 9,999,999,999.99"))//UNIT+IMPO      
	//AAdd((oHtml:ValByName("IT.STTOT"     )),  Transform(D2TMP->D2_ICMSRET,"@E 9,999,999,999.99"))//ST
	//AAdd((oHtml:ValByName("IT.IPITOT"    )),  Transform(D2TMP->D2_VALIPI ,"@E 9,999,999,999.99"))//IPI
	AAdd((oHtml:ValByName("IT.PRETOTIMP" )),  Transform(nTotalImpo       ,"@E 9,999,999,999.99"))
       	    	 		
	
	D2TMP->(dbSkip())

EndDo
                                    
// Preenchimento do cabeçalho do pedido
oHtml:= oProcess:oHtml		
oHtml:ValByName("DATA"   ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE", cCli + " - " + cLojaCli + Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"))
oHtml:ValByName("VENDEDOR", cNomeVend)
oHtml:ValByName("PEDSIM" ,cPedSim)
oHtml:ValByName("PEDSIGA",SD2->D2_PEDIDO)
oHtml:ValByName("VALORTOTAL",Transform(SF2->F2_VALBRUT, '@E 999,999,999.99'))
oHtml:ValByName("SERIE" ,SF2->F2_SERIE)
oHtml:ValByName("NOTAFISCAL" ,SF2->F2_DOC)  
oHtml:ValByName("CONDPAG" ,SC5->C5_CONDPAG)

oProcess:Start()
oProcess:Finish()

D2TMP->(dbCloseArea())

RestArea(aArea)
Return


/********************************************************************************
	Faz a gravação do Segmetno no título.
	Ponto de entrada é chamado para cada título incluído no financeiro.
	Os alias SC5 e SE1 já estão posicionados corretamente.
	Flavio - 13/01/2011
*********************************************************************************/
User Function M040SE1()
conout(funname())
if (FUNNAME() $ "MATA410/MATA460A/MATA461") .And. !(SF2->F2_TIPO $ "BD")
	if Empty(SE1->E1_CLVLCR)
		RecLock("SE1", .F.)
		SE1->E1_CLVLCR := SC5->C5_X_CLVL
		SE1->(MsUnlock())
	endIf                               
endIf

//GRAVA A TID QUANDO EXISTIR NO PEDIDO DE VENDAS  
//DEVAIR 27/04/2015
if SE1->(FieldPos("E1_XTID"))!=0 .and. SC5->(fieldpos("C5_XTID"))!=0 .and. !empty(SC5->C5_XTID) .And. !(SC5->C5_TIPO $ "BD")
		                            
	RecLock("SE1", .F.)
	SE1->E1_XTID := SC5->C5_XTID 
	SE1->E1_XAUTO:= SC5->C5_XAUTO
	SE1->E1_XINST:= SC5->C5_XINST
	SE1->(MsUnlock())                                                                        
	
endif


Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAILVEND   ºAutor  ³Gustavo Lattmann   º Data ³  10/30/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Nova função para envio de workflow de pedido faturado.     º±±
±±º          ³ Chama um .jar no server e faz o envio via iReport          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus / iReport                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
/*
Static Function MailVend()

//Local cFileName 	:= "java -jar /totvs11_frutas/microsiga/protheus_data/ireport/workflow/CantuMail.jar "
//Local cPath 		:= "/totvs11_frutas/microsiga/protheus_data/ireport/workflow"
Local cFileName 	:= "java -jar /ireport/workflow/CantuMail.jar "
Local cPath 		:= "/ireport/workflow"
Local nRet 			:= 999 
Local lWaitrun 		:= .F. //Não espera o final da execução da tarefa
Local cWhere 		:= "" 
Local cCodRel 		:= "irec000040" //Nome do relatório do iReport
Local cTitMail 		:= "" //Título do Relatório
Local cGrupoMail 	:= ""

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + SF2->F2_VEND1))
cGrupoMail	:= ALLTRIM(SA3->A3_EMAIL) + ",sfa@cantu.com.br"

SD2->(dbSetOrder(03))
SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE))


SA1->(dbSetOrder(01))
SA1->(dbSeek(xFilial("SA1") + SF2->F2_CLIENTE + SF2->F2_LOJA))

cTitMail := "Pedido " + SD2->D2_PEDIDO + " Faturado - " + SA1->A1_NOME 

cWhere		:= "ITEMNOTA.D_E_L_E_T_ = ' ' AND CABNOTA.F2_FILIAL ='" + SF2->F2_FILIAL + "'  AND F2_SERIE = '" + ALLTRIM(SF2->F2_SERIE) + "' " 
cWhere		+= "AND CABNOTA.F2_DOC ='" +  SF2->F2_DOC   + "'"


cCommandLine := cFileName + '"' + cPath + '" "' + cWhere + '" '
cCommandLine += '"' + cCodRel + '" "' + cGrupoMail + '" "' + cTitMail + '" "' + cEmpAnt + '"'
 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Executa script no server.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nRet := WaitRunSrv( cCommandLine , lWaitRun , "" )
	If nRet != 0
	 
		Conout("Relatorio do iReport nao encontrado.")
 
	EndIf

Return
*/



/*/{Protheus.doc} cpoCard
Carrega campos de cartão de credito para o módulo Financeiro
@author Augusto Ribeiro | www.compila.com.br
@since 17/10/2018
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function cpoCard()

	Local aAreaSE1	:= SE1->(GetArea())
	Local cChvPed 	:= ""
	Local nlNumParc := 0
	Local aRetParc	:= {}
				
	DBSELECTAREA("ZE1")
	ZE1->(DBSETORDER(1)) //| 
	cChvPed	:= SC5->C5_FILIAL+SC5->C5_NUM 
	
	IF ZE1->(DBSEEK(cChvPed )) 
			
		WHILE ZE1->(!EOF()) .and. cChvPed == ZE1->ZE1_FILIAL+ZE1->ZE1_PEDIDO 
			
			nParcela := 0
			
			FOR nI := 1 TO ZE1->ZE1_QTDE
				
				nlNumParc := nlNumParc + 1
				nParcela := nParcela + 1
				aadd(aRetParc, {nlNumParc ,ZE1->ZE1_FORMPG,ZE1->ZE1_AUTORI,StrZero(nParcela,3)})
				
			NEXT nI

			ZE1->(DBSKIP()) 
			
		ENDDO
		
		DbSelectArea("SE1")	
		
		SE1->(DbSetOrder(1))
		SE1->(DbGotop())
		
		If SE1->(DBSEEK(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
						
			//| Verifica todas as parecalelas geradas.	
			nlNumParc := 0	
			While SE1->(!EOF()) .AND. SE1->E1_FILIAL == SF2->F2_FILIAL .AND. SE1->E1_PREFIXO == SF2->F2_SERIE .AND. SE1->E1_NUM == SF2->F2_DOC
					
				IF ALLTRIM(SE1->E1_TIPO) <> "NF"	
					SE1->(DbSkip())		
					Loop
				ENDIF
				
				nlNumParc := nlNumParc + 1
						
				nPosParc := aScan(aRetParc,{|x| x[1] == nlNumParc})
				
				IF  nPosParc > 0
					
					//| verifica se forma de pagamento é cartão de crédito ou débito.
					
					IF ALLTRIM(aRetParc[nPosParc][2]) $ "CC|CD"
				
						SE1->(RecLock("SE1",.F.))
								 					 			
							SE1->E1_XCODAUT := aRetParc[nPosParc][3]
							SE1->E1_XPARCAR := aRetParc[nPosParc][4]
							
		 				SE1->(MsUnLock())
		 				
		 			ENDIF
						
				ENDIF					 	
				
				SE1->(DbSkip())
				
			Enddo	
			
		ENDIF
	ELSE

	
		IF !empty(SC5->C5_XCODAUT) 
		
			DbSelectArea("SE1")				
			SE1->(DbSetOrder(1))
			SE1->(DbGotop())
						
			If SE1->(DBSEEK(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC))
							
				//| Verifica todas as parecalelas geradas.	
				nlNumParc := 0	
				While SE1->(!EOF()) .AND. SE1->E1_FILIAL == SF2->F2_FILIAL .AND. SE1->E1_PREFIXO == SF2->F2_SERIE .AND. SE1->E1_NUM == SF2->F2_DOC
						
					IF ALLTRIM(SE1->E1_TIPO) <> "NF" .OR. !EMPTY(SE1->E1_XCODAUT)	
						SE1->(DbSkip())		
						Loop
					ENDIF
					
					nlNumParc := nlNumParc + 1

					SE1->(RecLock("SE1",.F.))
					
						SE1->E1_XCODAUT := SC5->C5_XCODAUT
						SE1->E1_XPARCAR := STRZERO(nlNumParc,3)
						
	 				SE1->(MsUnLock())
						 	

					SE1->(DbSkip())
				Enddo	
				
			ENDIF	
		ENDIF
	ENDIF

	RestArea(aAreaSE1)

RETURN()