#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCHKCRC  ºAutor  ³TOTVS PARANA CENTRALº Data ³  05/07/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina que verifica a existência de contratos de redes para º±±
±±º          ³o cliente/loja e retorno o percentual de desconto de acordo º±±
±±º          ³com o total de verbas do contrato.                          º±±
±±ºRetorno   ³Percentual de desconto / Número e sequência do contrato.    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
User Function RJCHKCRC(cTipoDoc, cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao)
*---------------------------------------------------------------------------*
Local aAreaTMP 	:= GetArea()
Local cAliasTMP := GetNextAlias()
Local cCLVL			:= ""
Local cNUMCONT 	:= ""			
Local nPRCDESC	:= 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o segmento do documento...                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If cTipoDoc == "S"	//--Documento de saída
		dbSelectArea("SD2")
		dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
		dbGoTop()
		If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
			dbSelectArea("SC5")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
				cCLVL := SC5->C5_X_CLVL
			EndIf
		EndIf		
	Else	//--Documento de entrada
		dbSelectArea("SD1")
		dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_CLIENTE+D1_LOJA+D1_COD+D1_ITEM
		dbGoTop()
		If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
			dbSelectArea("SD2")
			dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			dbGoTop()
			If dbSeek ( SD1->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA) )
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)
					cCLVL := SC5->C5_X_CLVL
				EndIf
			EndIf		
		EndIf
	EndIf   
	

	If !Empty(cCLVL)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica a existência de contratos de redes para o cliente ...       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cQuery := " SELECT 		Z54.Z54_FILIAL, Z54.Z54_NUMERO, Z54.Z54_SEQUEN,										"
		cQuery += "         	Z54.Z54_TIPOCT, Z54.Z54_CLIENT, Z54.Z54_LOJACL                 		"
		cQuery += " FROM 			"+RetSQLName("Z54")+" Z54																					"
		cQuery += " WHERE			Z54.Z54_TIPOCT	= 'C'		 																					"
		cQuery += " AND				Z54.Z54_ATIVO		= 'S'		 																					"
		cQuery += " AND				(( 	Z54.Z54_CLIENT	= '"+cCodCli+"'  	 														"
		cQuery += " AND						Z54.Z54_LOJACL	= '"+Space(TAMSX3("Z54_LOJACL")[1])+"' )			"	
		cQuery += " OR				( 	Z54.Z54_CLIENT	= '"+cCodCli+"' 															"
		cQuery += " AND						Z54.Z54_LOJACL	= '"+cCodLoj+"' ))														"	
		cQuery += " AND				'"+DTOS(dEmissao)+"' BETWEEN Z54.Z54_DATADE AND Z54.Z54_DATATE		"
		cQuery += " AND				Z54.D_E_L_E_T_ != '*'							 																"
		cQuery += " ORDER BY 	Z54.Z54_LOJACL, Z54.Z54_CLIENT DESC																"

		TCQUERY cQuery NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())   	
	  While !(cAliasTMP)->(EOF())
			dbSelectArea("Z55")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( (cAliasTMP)->(Z54_FILIAL+Z54_NUMERO+Z54_SEQUEN+Z54_TIPOCT+Z54_CLIENT+Z54_LOJACL) )
				While !Z55->(EOF()) .and. Z55->(Z55_FILIAL+Z55_NUMERO+Z55_SEQUEN+Z55_TIPOCT+Z55_CLIENT+Z55_LOJACL) == (cAliasTMP)->(Z54_FILIAL+Z54_NUMERO+Z54_SEQUEN+Z54_TIPOCT+Z54_CLIENT+Z54_LOJACL)
					//--Comparação sobre o segmento
					If ALLTRIM(Z55->Z55_CCLVL) == ALLTRIM(cCLVL)
						nPRCDESC += Z55->Z55_PRCDES 
						cNUMCONT := Z55->(Z55_NUMERO+Z55_SEQUEN)
					EndIf
					Z55->(dbSkip())
				Enddo				
				If !Empty(cNUMCONT)
					Exit
				EndIf
			EndIf              
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
	
	EndIf
	
	RestArea(aAreaTMP)
		
Return ({nPRCDESC,cNUMCONT})