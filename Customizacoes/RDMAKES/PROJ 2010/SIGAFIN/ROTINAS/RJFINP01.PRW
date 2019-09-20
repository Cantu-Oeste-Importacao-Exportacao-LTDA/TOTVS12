#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFINP01   ºAutor  ³Rafael Parma       º Data ³  26/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de processamento de comissões e geração de pedidos deº±±
±±º          ³compras sobre os títulos de pagamento de comissões.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßjeanßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------*
User Function RJFINP01()
*-------------------------*
Public __cUSRSUP  := "" // Utilizado para inclusão do pedido de compras. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamada da função padrão de calculo de comissões.      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MATA530()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamada da função de inclusão de pedido de compras.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	MsAguarde( {|| U_RJFP01CM() }, "Processando comissões... Aguarde!")
	  
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFP01CM   ºAutor  ³Rafael Parma       º Data ³  26/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de processamento de comissões e geração de pedidos deº±±
±±º          ³compras sobre os títulos de pagamento de comissões.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*---------------------------*
User Function RJFP01CM()      
*---------------------------*
Local cQuery     := ""
Local cAliasTMP  := GetNextAlias() 
Local cAliasTXS  := GetNextAlias() 
Private aDADOS   := {}
Private nINDFOR  := 0
Private cNUMPED  := ""
Private cCODVEN  := ""
Private lEstorno := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de títulos gerados pela rotina de comissões.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cQuery := "	SELECT															" + chr(13)
	cQuery += "		SE2.E2_FILIAL, 												" + chr(13)	
	cQuery += "		SE2.E2_PREFIXO,												" + chr(13)	
	cQuery += "		SE2.E2_NUM,    												" + chr(13)	
	cQuery += "		SE2.E2_PARCELA,												" + chr(13)	
	cQuery += "		SE2.E2_TIPO,   												" + chr(13)	
	cQuery += "		SE2.E2_FORNECE,												" + chr(13)	
	cQuery += "		SE2.E2_LOJA,   												" + chr(13)	
	cQuery += "		SE2.E2_VENCREA,												" + chr(13)	
	cQuery += "		SE2.E2_SALDO,  												" + chr(13)	
	cQuery += "		SE2.E2_HIST  												" + chr(13)		
	cQuery += " FROM " + RetSQLName("SE2") + " SE2								" + chr(13)	
	cQuery += "	WHERE 															" + chr(13)	
	cQuery += "		SE2.E2_FILIAL   = '" + xFilial("SE2") + "'					" + chr(13)	
	cQuery += "	AND	SE2.E2_X_TCVND  = 'S'										" + chr(13)	
	cQuery += "	AND	SE2.D_E_L_E_T_ != '*'										" + chr(13)	
	cQuery += "	ORDER BY														" + chr(13)
	cQuery += "		SE2.E2_FILIAL, 												" + chr(13)	
	cQuery += "		SE2.E2_PREFIXO,												" + chr(13)	
	cQuery += "		SE2.E2_NUM,    												" + chr(13)	
	cQuery += "		SE2.E2_PARCELA,												" + chr(13)	
	cQuery += "		SE2.E2_TIPO    												" + chr(13)	

	memowrite("RJFINP01_1.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
                                                

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento de registros e chamada da função de inclusão de pedido de compras.  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If ! (cAliasTMP)->(EOF())	
		Begin Transaction
			While (cAliasTMP)->(!EOF())
				
				//-- Definição dos segmentos e valores para geração de pedidos de compras.
				aDADOS   := {}                                                                          
				cNUMPED  := ""
				cCODVEN  := ""
				lEstorno := .F.
                
                cTITPAI := (cAliasTMP)->E2_PREFIXO+(cAliasTMP)->E2_NUM+(cAliasTMP)->E2_PARCELA+(cAliasTMP)->E2_TIPO+(cAliasTMP)->E2_FORNECE+(cAliasTMP)->E2_LOJA
				cQuery := "	SELECT	SUM(SE2.E2_VALOR) TAXAS									" + chr(13)
				cQuery += " FROM " + RetSQLName("SE2") + " SE2								" + chr(13)	
				cQuery += "	WHERE 															" + chr(13)	
				cQuery += "		SE2.E2_FILIAL   = '" + xFilial("SE2") 			+ "'		" + chr(13)	
				cQuery += " AND	SE2.E2_PREFIXO  = '" + (cAliasTMP)->E2_PREFIXO	+ "'		" + chr(13)	
				cQuery += " AND	SE2.E2_NUM      = '" + (cAliasTMP)->E2_NUM		+ "'		" + chr(13)	
				cQuery += " AND	SE2.E2_TITPAI   = '" + cTITPAI + "'							" + chr(13)	
				cQuery += " AND	SE2.E2_TIPO     = 'TX '										" + chr(13)												
				cQuery += "	AND	SE2.D_E_L_E_T_ != '*'										" + chr(13)	
			
				memowrite("RJFINP01_TXS.SQL",cQuery)
				
				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTXS)
				
				dbSelectArea(cAliasTXS)
				(cAliasTXS)->(dbGoTop())
								
				nSALDO := (cAliasTMP)->E2_SALDO
				If !(cAliasTXS)->(EOF())
					nSALDO += (cAliasTXS)->TAXAS
				EndIf
				(cAliasTXS)->(dbCloseArea())
	
				//-----------------------------------------------------------------------------------------------------------------------------
				fSelSEG( SubSTR((cAliasTMP)->E2_HIST,1,6), (cAliasTMP)->E2_FORNECE, (cAliasTMP)->E2_LOJA, nSALDO, @aDADOS, @cCODVEN, @lEstorno)
				
				//-- Realiza o procedimento de inclusão dos pedidos de compras e exclusão do título de comissão.
				If ! lEstorno 
					
					If Len(aDADOS) > 0
						//-- Inclusão dos pedidos de compras.
						For nINDFOR := 1 to Len(aDADOS)
			
							If ! fIncPedC( (cAliasTMP)->E2_FORNECE, (cAliasTMP)->E2_LOJA, aDADOS[nINDFOR,03], aDADOS[nINDFOR,01], aDADOS[nINDFOR,02], @cNUMPED )	
								
								MsgAlert("Impossível incluir o pedido de compras de comissões do vendedor."  + chr(13) + ;
										"Fornecedor/Loja: "+(cAliasTMP)->E2_FORNECE+"/"+(cAliasTMP)->E2_LOJA + chr(13) + ;
										"Prefixo: "+(cAliasTMP)->E2_PREFIXO+" Título: "+(cAliasTMP)->E2_NUM  )
								DisarmTransaction()
								Exit
							Else
								
								//-- Atualiza registros de comissões com os dados do título de origem e pedido de compras.
								fUpdSE3( (cAliasTMP)->E2_PREFIXO, (cAliasTMP)->E2_NUM, (cAliasTMP)->E2_PARCELA, (cAliasTMP)->E2_TIPO, ;
								(cAliasTMP)->E2_FORNECE, (cAliasTMP)->E2_LOJA, cCODVEN, aDADOS[nINDFOR,01], aDADOS[nINDFOR,02], cNUMPED )
								
							EndIf
			
						Next nINDFOR
						
						//-- Exclusão do título de origem de comissão
						If ! fExcTit( (cAliasTMP)->E2_FILIAL, (cAliasTMP)->E2_PREFIXO, (cAliasTMP)->E2_NUM, (cAliasTMP)->E2_PARCELA, ;
								(cAliasTMP)->E2_TIPO, (cAliasTMP)->E2_FORNECE, (cAliasTMP)->E2_LOJA, lEstorno )
						
							MsgAlert("Impossível localizar ou excluir o título de comissão do vendedor." + chr(13) + ;
									"Fornecedor/Loja: "+(cAliasTMP)->E2_FORNECE+"/"+(cAliasTMP)->E2_LOJA + chr(13) + ;
									"Prefixo: "+(cAliasTMP)->E2_PREFIXO+" Título: "+(cAliasTMP)->E2_NUM  )
							DisarmTransaction()
							Exit
						EndIf
					
					EndIf 
				
				Else

					//-- Exclusão do título de origem de comissão

					If ! fExcTit( (cAliasTMP)->E2_FILIAL, (cAliasTMP)->E2_PREFIXO, (cAliasTMP)->E2_NUM, (cAliasTMP)->E2_PARCELA, ;
							(cAliasTMP)->E2_TIPO, (cAliasTMP)->E2_FORNECE, (cAliasTMP)->E2_LOJA, lEstorno )

					
						MsgAlert("Impossível localizar ou excluir o título de comissão do vendedor." + chr(13) + ;
								"Fornecedor/Loja: "+(cAliasTMP)->E2_FORNECE+"/"+(cAliasTMP)->E2_LOJA + chr(13) + ;
								"Prefixo: "+(cAliasTMP)->E2_PREFIXO+" Título: "+(cAliasTMP)->E2_NUM  )
						DisarmTransaction()
						Exit
					EndIf					
		
				EndIf
				
				(cAliasTMP)->(dbSkip())
			Enddo
		End Transaction			
	EndIf
	
	(cAliasTMP)->(dbCloseArea())

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fIncPedC   ºAutor  ³Rafael Parma       º Data ³  26/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de inclusão do pedido de compras.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*--------------------------------------------------------------------------*
Static Function fIncPedC( cFORNECE, cLOJFOR, nVALOR, cCLVL, cCC, cNumero )
*--------------------------------------------------------------------------* 
Local lRet     := .T.      
Local aCab     := {}
Local aItens   := {}                           
Local cItem    := "00"
Local aArea    := GetArea()
Local cFORPGT  := ALLTRIM(GETMV("MV_X_CFPCV"))	// Condição de pagamento
Local cPRDCOM  := ALLTRIM(GETMV("MV_X_CPPCV"))	// Produto comissão
Local cPRDUDA  := ALLTRIM(GETMV("MV_X_CPPCA"))	// Produto 1/12 comissão
Private lMsErroAuto := .F.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Posiciona sobre o cadastro do fornecedor.              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek ( xFilial("SA2") + cFORNECE + cLOJFOR )
	
	If LEN(ALLTRIM(SA2->A2_CGC)) > 11
		cPRDCOM := SubSTR(cPRDCOM, At("/",cPRDCOM)+1, Len(cPRDCOM))
		cPRDUDA := SubSTR(cPRDUDA, At("/",cPRDUDA)+1, Len(cPRDUDA))
	Else
		cPRDCOM := SubSTR(cPRDCOM, 1, At("/",cPRDCOM)-1)
		cPRDUDA := SubSTR(cPRDUDA, 1, At("/",cPRDUDA)-1)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia do produto no cadastro.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek ( xFilial("SB1") + cPRDCOM )
		MsgAlert("Código do produto referente a comissão definido no parâmetro MV_X_CPPCV não existe! ("+cPRDCOM+")")
		lRet := .F.
	ElseIf !dbSeek ( xFilial("SB1") + cPRDUDA )
		MsgAlert("Código do produto referente a 1/12 de comissão definido no parâmetro MV_X_CPPCA não existe! ("+cPRDUDA+")")
		lRet := .F.
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica a existencia da forma de pagamento no cadastro.   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SX5")
	dbSetOrder(1)
	dbGoTop()
	If !dbSeek ( xFilial("SX5") + "24" + cFORPGT )
		MsgAlert("Código da forma de pagamento definido no parâmetro MV_X_CFPCV não existe ("+cFORPGT+")!")
		lRet := .F.
	EndIf

	If lRet

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define variáveis do cabeçalho do pedido.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		cNumero := CriaVar("C7_NUM",.T.) 
				   	
		aCab := { 	{"C7_NUM"     , cNumero			, NIL},;		// Numero do Pedido
					{"C7_EMISSAO" , dDatabase		, NIL},;		// Data de Emissao
					{"C7_FORNECE" , cFORNECE		, NIL},;		// Fornecedor
					{"C7_LOJA"	  , cLOJFOR			, NIL},;     	// Loja do Fornecedor
					{"C7_COND"	  , SA2->A2_COND	, NIL},;     	// Condicao de Pagamento
					{"C7_CONTATO" , ""				, NIL},; 		// Contato
					{"C7_FILENT"  , xFilial("SC7")	, NIL}}			// Filial de Entrega
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Define variáveis de itens do pedido.                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek ( xFilial("SB1") + cPRDCOM )
		
		cItem := Soma1(cItem,TAMSX3("C7_ITEM")[1])
		
		aAdd( aItens,{	{"C7_ITEM"    ,	cItem			, NIL},; 		// Numero do Item
				      	{"C7_PRODUTO" ,	SB1->B1_COD 	, NIL},; 		// Codigo do Produto
				      	{"C7_UM"      ,	SB1->B1_UM      , NIL},; 		// Unidade de Medida
				      	{"C7_QUANT"   ,	1			    , NIL},;  		// Quantidade
				      	{"C7_PRECO"   ,	nVALOR		   	, NIL},; 		// Preco
				      	{"C7_DATPRF"  ,	dDatabase		, NIL},; 		// Data De Entrega
				      	{"C7_FORMPAG" ,	cFORPGT    		, NIL},; 		// Forma de pagamento
				      	{"C7_FLUXO"   ,	"S"			 	, NIL},; 		// Fluxo de Caixa (S/N)
				      	{"C7_CLVL"    ,	cCLVL		 	, NIL},; 		// Classe Valor
				      	{"C7_CC"   	  ,	cCC			 	, NIL},; 		// Centro de custo
				      	{"C7_LOCAL"   ,	SB1->B1_LOCPAD	, NIL}}) 		// Localizacao			


		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek ( xFilial("SB1") + cPRDUDA )
		
		cItem := Soma1(cItem,TAMSX3("C7_ITEM")[1])
		
		aAdd( aItens,{	{"C7_ITEM"    ,	cItem			, NIL},; 		// Numero do Item
				      	{"C7_PRODUTO" ,	SB1->B1_COD 	, NIL},; 		// Codigo do Produto
				      	{"C7_UM"      ,	SB1->B1_UM      , NIL},; 		// Unidade de Medida
				      	{"C7_QUANT"   ,	1			    , NIL},;  		// Quantidade
				      	{"C7_PRECO"   ,	(nVALOR/12)	   	, NIL},; 		// Preco
				      	{"C7_DATPRF"  ,	dDatabase		, NIL},; 		// Data De Entrega
				      	{"C7_FORMPAG" ,	cFORPGT    		, NIL},; 		// Forma de pagamento
				      	{"C7_FLUXO"   ,	"S"			 	, NIL},; 		// Fluxo de Caixa (S/N)
				      	{"C7_CLVL"    ,	cCLVL		 	, NIL},; 		// Classe Valor
				      	{"C7_CC"   	  ,	cCC			 	, NIL},; 		// Centro de custo				      	
				      	{"C7_LOCAL"   ,	SB1->B1_LOCPAD	, NIL}}) 		// Localizacao			

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Função de inclusão do pedido de compras.               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		MSExecAuto({|v,x,y,z| MATA120(v,x,y,z)}, 1, aCab, aItens, 3)
		
		If lMsErroAuto
			MostraErro()
			lRet := .F.
		EndIf

	EndIf
	
	RestArea(aArea)

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fExcTit    ºAutor  ³Rafael Parma       º Data ³  26/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para exclusão do título de comissão.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*---------------------------------------------------------------------------------------------------*
Static Function fExcTit( cCODFIL, cPREFIXO, cNUMTIT, cPARCELA, cTIPO, cFORNECE, cLOJFOR, lEstorno )      
*---------------------------------------------------------------------------------------------------*
Local lRet  := .T. 
Local aArea := GetArea()    
Private lMsErroAuto	:= .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Localiza e elimina o título de comissão.               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                     

	dbSelectArea("SE2")	// CONTAS A PAGAR
	dbSetOrder(1)	//E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	dbGoTop()
    
    If lEstorno
		//-- Exclusão do título por execauto, recupera os registros de comissões para serem processados outra vez.
		aFINA050 := {}
		AADD( aFINA050, { "E2_FILIAL"  , cCODFIL	,Nil } )
		AADD( aFINA050, { "E2_PREFIXO" , cPREFIXO	,Nil } )
		AADD( aFINA050, { "E2_NUM"	   , cNUMTIT	,Nil } )
		AADD( aFINA050, { "E2_PARCELA" , cPARCELA	,Nil } )
		AADD( aFINA050, { "E2_TIPO"	   , cTIPO		,Nil } )
		AADD( aFINA050, { "E2_FORNECE" , cFORNECE	,Nil } )
		AADD( aFINA050, { "E2_LOJA"	   , cLOJFOR	,Nil } )
		
		MSExecAuto ( {|x, y, z| Fina050(x, y, z) }, aFINA050,5) 
	
	
		If lMsErroAuto
			Mostraerro()
			lRet := .F.
		EndIf
	/*
	Else
		//-- Exclusão do título direta na base, para não recuperar os registros de comissões para não serem processados outra vez.
		If dbSeek(cCODFIL+cPREFIXO+cNUMTIT+cPARCELA+cTIPO+cFORNECE+cLOJFOR)
			If RecLock("SE2",.F.)
				SE2->(dbDelete())
				SE2->(MsUnLock())
			EndIf
		Else
			lRet := .F.
		EndIf
	*/
		
	EndIf
	
	RestArea(aArea)
	
Return (lRet)    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSelSEG    ºAutor  ³Rafael Parma       º Data ³  08/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para seleção dos registros de comissão para separaçãoº±±
±±º          ³dos segmentos para geração dos pedidos de compras.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*---------------------------------------------------------------------------------------*
Static Function fSelSEG( cVENDED, cFORNECE, cLOJFOR, nSALDO, aDADOS, cCODVEN, lEstorno )      
*---------------------------------------------------------------------------------------*
Local nTOTSEG := 0                     
Local cAliasTMP := GetNextAlias()

	Pergunte("MTA530",.F.)

	//-- Seleção o vendedor relacionado ao fornecedor.
	cQuery := "	SELECT															" + chr(13)
	cQuery += "		SA3.A3_COD	 												" + chr(13)	
	cQuery += " FROM " + RetSQLName("SA3") + " SA3								" + chr(13)	
	cQuery += "	WHERE 															" + chr(13)	
	cQuery += "		SA3.A3_FILIAL   = '" + xFilial("SA3") + "'					" + chr(13)	
	cQuery += "	AND	SA3.A3_FORNECE  = '" + cFORNECE + "'						" + chr(13)	 
	cQuery += "	AND	SA3.A3_LOJA     = '" + cLOJFOR  + "'						" + chr(13)
	cQuery += "	AND	SA3.A3_COD      = '" + cVENDED  + "'						" + chr(13)			
	cQuery += "	AND	SA3.D_E_L_E_T_ != '*'										" + chr(13)	

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !Empty((cAliasTMP)->A3_COD)
		cCODVEN := (cAliasTMP)->A3_COD
	EndIf         
	(cAliasTMP)->(dbCloseArea())
                                                
	//-- Atualização das entidades contabeis
	fUpdCLVL(cCODVEN) 
	

	//-- Seleção dos registros de comissões
	If cCODVEN != ""

		cQuery := "	SELECT															" + chr(13)
		cQuery += "		SUM(SE3.E3_COMIS) E3_COMIS,									" + chr(13)	
		cQuery += "		SE3.E3_CLVLDB,												" + chr(13)		
		cQuery += "		SE3.E3_CCD													" + chr(13)				
		cQuery += " FROM " + RetSQLName("SE3") + " SE3								" + chr(13)	
		cQuery += "	WHERE 															" + chr(13)	
		cQuery += "		SE3.E3_FILIAL   = '" + xFilial("SE3") + "'					" + chr(13)	
		cQuery += "	AND	SE3.E3_VEND     = '" + cCODVEN + "'							" + chr(13)	 
		cQuery += "	AND	SE3.E3_EMISSAO BETWEEN 	'" + dtos(mv_par02) + "'			" + chr(13)
		cQuery += "	AND							'" + dtos(mv_par03) + "'			" + chr(13)
		If mv_par01 == 1
			cQuery += "	AND	SE3.E3_BAIEMI = 'E'										" + chr(13)	 		
		ElseIf mv_par01 == 2
			cQuery += " AND ( SE3.E3_BAIEMI = 'B'									" + chr(13)	 		
			cQuery += " OR ( SE3.E3_TIPO = 'NCC' AND SE3.E3_BAIEMI = 'E' ) )		" + chr(13)	 				
		EndIf
		cQuery += "	AND	SE3.E3_VENCTO BETWEEN   '" + dtos(mv_par10) + "'			" + chr(13)
		cQuery += "	AND							'" + dtos(mv_par11) + "'			" + chr(13)
		cQuery += "	AND	SE3.D_E_L_E_T_ != '*'										" + chr(13)	
		cQuery += "	GROUP BY														" + chr(13)
		cQuery += "		SE3.E3_CLVLDB,												" + chr(13)
		cQuery += "		SE3.E3_CCD													" + chr(13)								
		cQuery += "	ORDER BY														" + chr(13)
		cQuery += "		SE3.E3_CLVLDB,												" + chr(13)		
		cQuery += "		SE3.E3_CCD													" + chr(13)								
	    
	    MemoWrite("RJFINP01SEG.TXT",cQuery)
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While (cAliasTMP)->(!EOF())
			aAdd ( aDADOS, { (cAliasTMP)->E3_CLVLDB, (cAliasTMP)->E3_CCD, (cAliasTMP)->E3_COMIS } )
			If ALLTRIM((cAliasTMP)->E3_CLVLDB) == "" .or. ALLTRIM((cAliasTMP)->E3_CCD) == ""
				lEstorno := .T.
				Exit
			EndIf
			nTOTSEG += (cAliasTMP)->E3_COMIS
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		If lEstorno
			cTEXTO := "Existem registros de comissões sem dados de segmento ou centro de custo para o vendedor: " + cCODVEN + ". " + chr(10) + chr(13)
			cTEXTO += "O pedido de compras não será gerado para este vendedor, favor revisar os registros de comissões."				
			Aviso( "Atenção", cTEXTO, {"OK"} )
		Else 
			If nTOTSEG != nSALDO .and. nTOTSEG > 0
				cTEXTO := "Existe divergência entre o valor total das comissões e o valor total de comissões por segmento: "+ chr(10)+chr(13)
				cTEXTO += "TOTAL DAS COMISSÕES: "+TRANSFORM(nSALDO,"@E 999,999.99")+ chr(10)+chr(13)
				cTEXTO += "COMISSÕES POR SEGMENTO: "+chr(10)+chr(13)
				For nT := 1 to Len(aDADOS)
					cTEXTO += "SEGMENTO: "+aDADOS[nT,01]+" CENTRO DE CUSTO: "+aDADOS[nT,02]+" VALOR: "+TRANSFORM(aDADOS[nT,03],"@E 999,999.99")+ chr(10)+chr(13)
				Next nT
				cTEXTO += "TOTAL DOS SEGMENTOS: "+TRANSFORM(nTOTSEG,"@E 999,999.99")
				MsgAlert(cTEXTO)
				//Aviso( "Atenção", cTEXTO, {"OK"} )
				lEstorno := .T.
			EndIf
		EndIf
			
	EndIf
		
Return  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdSE3    ºAutor  ³Rafael Parma       º Data ³  08/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para atualização dos registros de comissões com os da-±±
±±º          ³dos do título de origem e pedido de compras.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*----------------------------------------------------------------------------------------------------------------*
Static Function fUpdSE3( cPREFIXO, cNUMTIT, cPARCELA, cTIPO, cFORNECE, cLOJFOR, cCODVEN, cCLVL, cCC, cNUMPED )      
*----------------------------------------------------------------------------------------------------------------*
Local cTITORI := cPREFIXO + cNUMTIT + cPARCELA + cTIPO + cFORNECE + cLOJFOR
     
	Pergunte("MTA530",.F.)

	cQuery := " UPDATE " + RetSQLName("SE3") + " SE3							" + chr(13)	
	cQuery += "	SET   															" + chr(13)
	cQuery += "		SE3.E3_X_PC 	= '" + cNUMPED + "',						" + chr(13)	
	cQuery += "		SE3.E3_X_TITOR 	= '" + cTITORI + "'							" + chr(13)		
	cQuery += "	WHERE 															" + chr(13)	
	cQuery += "		SE3.E3_FILIAL   = '" + xFilial("SE3") + "'					" + chr(13)	
	cQuery += "	AND	SE3.E3_VEND     = '" + cCODVEN + "'							" + chr(13)	 
	cQuery += "	AND	SE3.E3_CLVLDB   = '" + cCLVL   + "'							" + chr(13)	 
	cQuery += "	AND	SE3.E3_CCD      = '" + cCC     + "'							" + chr(13)	 
	cQuery += "	AND	SE3.E3_EMISSAO BETWEEN 	'" + dtos(mv_par02) + "'			" + chr(13)
	cQuery += "	AND							'" + dtos(mv_par03) + "'			" + chr(13)
	If mv_par01 == 1
		cQuery += "	AND	SE3.E3_BAIEMI = 'E'										" + chr(13)	 		
	ElseIf mv_par01 == 2
		cQuery += " AND ( SE3.E3_BAIEMI = 'B'									" + chr(13)	 		
		cQuery += " OR ( SE3.E3_TIPO = 'NCC' AND SE3.E3_BAIEMI = 'E' ) )		" + chr(13)	 				
	EndIf
	cQuery += "	AND	SE3.E3_VENCTO BETWEEN   '" + dtos(mv_par10) + "'			" + chr(13)
	cQuery += "	AND							'" + dtos(mv_par11) + "'			" + chr(13)
	cQuery += "	AND	SE3.D_E_L_E_T_ != '*'										" + chr(13)
	
	TCSQLExec(cQuery)	

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdCLVL   ºAutor  ³Rafael Parma       º Data ³  08/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para atualização dos registros de comissões com os da-±±
±±º          ³dos de segmento e centro de custo.                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
 
*------------------------------------*
Static Function fUpdCLVL(cVEND)            
*------------------------------------*
Local aArea := GetArea()

	dbSelectArea("SE3")
	dbSetOrder(2)
	dbGoTop()
	dbSeek ( xFilial("SE3") + cVEND )
	While !SE3->(EOF()) .and. SE3->E3_FILIAL == xFilial("SE3") .and. SE3->E3_VEND == cVEND
		If Empty(SE3->E3_CLVLDB) .OR. Empty(SE3->E3_CCD)
			If ALLTRIM(SE3->E3_TIPO) == "NF"	
				dbSelectArea("SD2")
				dbSetOrder(3)
				dbGoTop()
				If dbSeek(xFilial("SD2")+SE3->E3_NUM+SE3->E3_PREFIXO)			
					If !Empty(SD2->D2_CLVL) .or. !Empty(SD2->D2_CCUSTO)
						If RecLock("SE3",.F.)
							SE3->E3_CLVLDB := SD2->D2_CLVL
							SE3->E3_CCD    := SD2->D2_CCUSTO
							SE3->(MsUnLock())
						EndIf
					EndIf
				EndIf
			ElseIf ALLTRIM(SE3->E3_TIPO) == "NCC"
				dbSelectArea("SD1")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek(xFilial("SD1")+SE3->E3_NUM+SE3->E3_PREFIXO+SE3->E3_CODCLI+SE3->E3_LOJA)				
					dbSelectArea("SD2")
					dbSetOrder(3)
					dbGoTop()
					If dbSeek(xFilial("SD1")+SD1->D1_NFORI+SD1->D1_SERIORI)					
						If !Empty(SD2->D2_CLVL) .or. !Empty(SD2->D2_CCUSTO)
							If RecLock("SE3",.F.)
								SE3->E3_CLVLDB := SD2->D2_CLVL
								SE3->E3_CCD    := SD2->D2_CCUSTO
								SE3->(MsUnLock())
							EndIf
						EndIf
					EndIf
				EndIf
			ElseIf ALLTRIM(SE3->E3_TIPO) == "FT" .or. ALLTRIM(SE3->E3_TIPO) == "CH"
				dbSelectArea("SE1")
				dbSetOrder(2)
				dbGoTop()
				If dbSeek(xFilial("SE1")+SE3->E3_CODCLI+SE3->E3_LOJA+SE3->E3_PREFIXO+SE3->E3_NUM)				
					If !Empty(SE1->E1_CLVLCR) .or. !Empty(SE1->E1_CCC)
						If RecLock("SE3",.F.)
							SE3->E3_CLVLDB := SE1->E1_CLVLCR
							SE3->E3_CCD    := SE1->E1_CCC
							SE3->(MsUnLock())
						EndIf
					EndIf
				EndIf
			EndIf  
		
		EndIf
		SE3->(dbSkip())
	Enddo
	
	RestArea(aArea)

Return