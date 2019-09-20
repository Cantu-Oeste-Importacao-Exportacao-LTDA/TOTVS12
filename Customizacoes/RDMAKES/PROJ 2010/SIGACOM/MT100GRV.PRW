#include "FIVEWIN.CH"
#include "RWMAKE.CH"
#include "TBICONN.CH"
#INCLUDE "PROTHEUS.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100GRV   ºAutor  ³Rafael Parma       º Data ³  17/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a confirmação documento de º±±
±±º          ³entrada, utilizado na exclusão do documento para restaurar  º±±
±±º          ³títulos provisórios dos pedidos relacionados.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function XMT100GRV()
*----------------------------*
Local aArea 	:= GetArea()
Local lDeleta	:= PARAMIXB[1]
Local nPosPed := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local nPosSeq := aScan(aHeader, { |x| x[2] = "D1_ITEMPC"})
Local cPedido
Local cItemPC
Local cNatureza := ""
Local cNatAtu := MaFisRet(,"NF_NATUREZA")   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³02/06/15 - VALIDA SE É CHAMADA DA ROTINA DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ISINCALLSTACK("U_SCHCLACTE")

	If lDeleta .and. ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
		MsAguarde( {|| fRestPROV() }, "Restaurando provisórios... Aguarde!")					
	EndIf                                  
	
	If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S"
		If lDeleta .and. SF1->F1_EST == "EX"
			MsAguarde( {|| fDropImp() }, "Eliminando títulos de importação... Aguarde!")					
		EndIf
	EndIf
		                                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Exclusao de Lancamentos PCO para debito de Pedidos de Compra com rateio/sem rateio     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If  lDeleta
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA ) 
	 		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
				If !EMPTY(SD1->D1_PEDIDO)
					dbSelectArea("SC7")
					dbSetOrder(1)
					dbGoTop()
					If dbSeek ( xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC )
						PCOINILAN("999001")															
						While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM + SC7->C7_ITEM == xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC
							If SC7->C7_RATEIO = '1' //POSSUI RATEIO
								dbSelectArea("SCH")
								dbSetOrder(2)
								dbGoTop()
								If dbSeek ( xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM)
									While !SCH->(EOF()) .and. SCH->CH_FILIAL + SCH->CH_PEDIDO + SCH->CH_ITEMPD == xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM									
										Begin Transaction											
											PCODETLAN("999001","02","MT103FIM",.T.)										
										End Transaction  
										
										Begin Transaction											
											PCODETLAN("999001","03","MT103FIM",.T.)										
										End Transaction  
										
										SCH->(dbSkip())		   	
								   	EndDo
								EndIf
							ElseIf SC7->C7_RATEIO = '2' //NAO POSSUI RATEIO
								Begin Transaction											
									PCODETLAN("999001","01","MT103FIM",.T.)										
								End Transaction  							 
							EndIf
							SC7->(dbSkip())		   	
						EndDo		
						PCOFINLAN("999001")										
					EndIf
				EndIf				
				SD1->(dbSkip()) 
	 		Enddo	
		EndIf
    EndIf

	RestArea(aArea)
	
	/*--------------------------------------------------------------*/
	// Funcão de validação no pedido usada para alterar a natureza a ser gravada nas duplicatas pela natureza do pedido
	// Executada antes da gravação do SF1, sendo que após a gravação do mesmo é executado a gravação das duplicatas, 
	// obtendo o conteúdo da função MaFisRet(,"NF_NATUREZA")
	/*--------------------------------------------------------------*/
	
	if (SC7->(FieldPos("C7_NATUREZ")) > 0)
		cPedido := aCols[Len(aCols), nPosPed]	
		if (cPedido != "" .And. (Inclui .Or. Altera))
		  cItemPC := aCols[Len(aCols), nPosSeq]
		  cNatureza := Posicione("SC7", 01, xFilial("SC7") + cPedido + cItemPC, "C7_NATUREZ")
		  if (AllTrim(cNatAtu) != AllTrim(cNatureza)) .And. !Empty(cNatureza)
		    If MSGBOX("Alterar a natureza das duplicatas de " + cNatAtu +  " para " + cNatureza +;
		    	        " conforme existente no Pedido de Compra?", "Customização de NF - PE MT100GRV", "YESNO")
		      MaFisAlt("NF_NATUREZA",cNatureza,)
		    EndIf
		  EndIf
		EndIf
	EndIf

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRestPROV  ºAutor  ³Rafael Parma       º Data ³  01/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Restaura os títulos provisórios relacionados aos pedidos    º±±
±±º          ³utilizados no documento de entrada.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fRestPROV()
*----------------------------*
Local aArea := GetArea()
Local aPEDIDOS := {}
Local cCODNATP := ALLTRIM(GETMV("MV_X_NTTPR")) 
Private lMsErroAuto := .F.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Recupera pedidos relacionados ao documento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	dbSelectArea("SD1")
	dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM	
	dbGoTop()
	If dbSeek( xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
 		While !SD1->(EOF()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
 			If !Empty(SD1->D1_PEDIDO)
				If Len(aPEDIDOS) == 0
					nPOS := 0
				Else         
					nPOS := aScan ( aPEDIDOS, {|x| x[1] == SD1->D1_PEDIDO } )
				EndIf                           
				If nPOS == 0
					aAdd ( aPEDIDOS, { SD1->D1_PEDIDO } ) 
				EndIf
 			EndIf
 			SD1->(dbSkip())
 		Enddo	
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restauta os títulos provisórios relacionados ao pedido       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	If Len(aPEDIDOS) > 0
		For nI := 1 to Len(aPEDIDOS)
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("Z11") + aPEDIDOS[nI][01] )
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + aPEDIDOS[nI][01]

					dbSelectArea("SC7")
					dbSetOrder(1)
					dbSeek( xFilial("SC7") + aPEDIDOS[nI][01] )
					
					lMsErroAuto := .F.
					aTitulo := {	{"E2_FILIAL"	, Z11->Z11_FILIAL		 				,	Nil},;      
									{"E2_PREFIXO"	, Z11->Z11_PREFIX 						,	Nil},;      
					  			{"E2_NUM"			, Z11->Z11_PEDIDO	 					,	Nil},;      
									{"E2_PARCELA"	, Z11->Z11_PARCEL						,	Nil},;      
									{"E2_TIPO"		, Z11->Z11_TIPO			 				,	Nil},;      
									{"E2_NATUREZ"	, cCODNATP								,	Nil},;  					
									{"E2_FORNECE"	, Z11->Z11_FORNEC        				,	Nil},;      
									{"E2_LOJA"		, Z11->Z11_LOJA		  					,	Nil},;          
									{"E2_EMISSAO"	, SC7->C7_EMISSAO	 					,  	Nil},;
									{"E2_VENCTO"	, Z11->Z11_VENCTO						,	Nil},;
									{"E2_VENCREA"	, DataValida(Z11->Z11_VENCTO)			,	Nil},;
									{"E2_VALOR"		, Z11->Z11_VALOR	  					,	Nil} }
				
					MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
						Exit
					EndIf 

					dbSelectArea("Z11")
					Z11->(dbSkip())
					
				Enddo		    	
		    EndIf
		Next nI
	EndIf

	RestArea(aArea)

Return 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDropImp   ºAutor  ³Rafael Parma       º Data ³  12/01/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Elimina os títulos relacionados ao documento de entrada de  º±±
±±º          ³importação.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function fDropImp()
*----------------------------*
Local aArea := GetArea()
Local cMV_X_PRFTI := ALLTRIM(GETMV("MV_X_PRFTI"))
Private lMsErroAuto := .F.
    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Elimina os títulos gerados a partir do documento de importação  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	
	dbSelectArea("Z32")
    dbSetOrder(1)
    dbGoTop()
    If dbSeek ( xFilial("Z32") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA )
		
    	While !EOF() .and. 	Z32->Z32_FILIAL + Z32->Z32_DOC + Z32->Z32_SERIE + Z32->Z32_FORDOC + Z32->Z32_LOJDOC == ;
    						xFilial("Z32") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA

			
			lMsErroAuto := .F.
			
			dbSelectArea("SE2")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( Z32->Z32_FILIAL + cMV_X_PRFTI + Z32->Z32_DOC + Z32->Z32_PARCEL + Z32->Z32_TIPO + Z32->Z32_FORTIT + Z32->Z32_LOJTIT )
				
				aFINA050 := {}
				AADD( aFINA050, { "E2_FILIAL"  , Z32->Z32_FILIAL	,Nil } )
				AADD( aFINA050, { "E2_PREFIXO" , cMV_X_PRFTI		,Nil } )
				AADD( aFINA050, { "E2_NUM"	   , Z32->Z32_DOC		,Nil } )
				AADD( aFINA050, { "E2_PARCELA" , Z32->Z32_PARCEL	,Nil } )
				AADD( aFINA050, { "E2_TIPO"	   , Z32->Z32_TIPO		,Nil } )
				AADD( aFINA050, { "E2_FORNECE" , Z32->Z32_FORTIT	,Nil } )
				AADD( aFINA050, { "E2_LOJA"	   , Z32->Z32_LOJTIT	,Nil } )
				
				MSExecAuto( {|x, y, z| Fina050(x, y, z) }, aFINA050,, 5) 
				
				If lMsErroAuto
					DisarmTransaction()
					Mostraerro()
					Exit
				EndIf                 
			
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Elimina os registros da tabela de títulos de doc de importação  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
					
			If RecLock("Z32",.F.)
				Z32->(dbDelete())
				Z32->(MsUnLock())
			EndIf
			
			dbSelectArea("Z32")
			Z32->(dbSkip())
				
		Enddo	
			    	
	EndIf		
	
	RestArea(aArea)
Return