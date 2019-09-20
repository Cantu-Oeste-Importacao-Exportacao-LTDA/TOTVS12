#include "rwmake.ch"  
#include "topconn.ch"
#include "protheus.ch"
#include "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJOMSR01    ºAutor  ³Rafael Parma      º Data ³  22/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório de produtos faturados x eliminados por resíduo.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       
*--------------------------*
User Function RJOMSR01()         
*--------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "PRODUTOS FATURADOS X ELIMINADOS POR RESIDUO"
Local nLin          := 80
Local Cabec1 		:= "PRODUTO                                                             QUANTIDADE              QUANTIDADE              QUANTIDADE"
Local Cabec2 		:= "                                                                    EM PEDIDO               FATURADA                EL.RESIDUO"
Local imprime       := .T.
Local aOrd          := {"Produto","Cliente","Pedido"}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "RJOMSR01" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RJOMSR01"
Private cPerg       := "RJOMSR0001"
Private cString     := "SC5"
Private STRING_NULL := ""   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea(cString)
	dbSetOrder(1)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	AjustaSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]
	 
	If nOrdem == 1
		titulo += " - POR PRODUTO"
	ElseIf nOrdem == 2        
		titulo += " - POR CLIENTE"
	Else
		titulo += " - POR PEDIDO"
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Rafael Parma       º Data ³  22/09/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*---------------------------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*

Local cQuery    := STRING_NULL
Local cCODCLI   := STRING_NULL
Local cNUMPED   := STRING_NULL
Local cAliasTMP := GetNextAlias()
Local nQDTRESID := 0
Local nTOTPEDID := 0
Local nTOTFATUR := 0
Local nTOTRESID := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	
	cQuery := "	SELECT																	" + chr(13)
	cQuery += "			SC6.C6_PRODUTO,													" + chr(13)
	If nOrdem == 2
		cQuery += "		SC5.C5_CLIENTE,													" + chr(13)
		cQuery += "		SC5.C5_LOJACLI,													" + chr(13)
	ElseIf nOrdem == 3
		cQuery += "		SC6.C6_NUM,														" + chr(13)	
	EndIf
	cQuery += "			SUM(SC6.C6_QTDVEN) C6_QTDVEN,   								" + chr(13)
	cQuery += "			SUM(SC6.C6_QTDLIB) C6_QTDLIB	   								" + chr(13)
	cQuery += "	FROM " + RetSQLName("SC6") + " SC6		   								" + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("SC5") + " SC5								" + chr(13)
	cQuery += "	ON    																	" + chr(13)
	cQuery += "			SC6.C6_FILIAL  	= SC5.C5_FILIAL									" + chr(13)
	cQuery += "	AND		SC6.C6_NUM  	= SC5.C5_NUM									" + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("SB1") + " SB1								" + chr(13)
	cQuery += "	ON    																	" + chr(13)
	cQuery += "			SB1.B1_COD  	= SC6.C6_PRODUTO								" + chr(13)
	cQuery += "	WHERE 									   								" + chr(13)
	cQuery += "			SC6.C6_FILIAL BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par15 + "' AND '" + mv_par16 + "'						" + chr(13)
	cQuery += "	AND		SC6.C6_NUM BETWEEN												" + chr(13)
	cQuery += "			'" + mv_par01 + "' AND '" + mv_par02 + "'						" + chr(13)
	cQuery += "	AND		SC5.C5_CLIENTE BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'						" + chr(13)
	cQuery += "	AND		SC5.C5_LOJACLI BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'						" + chr(13)
	cQuery += "	AND		SB1.B1_GRUPO BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par11 + "' AND '" + mv_par12 + "'						" + chr(13)
	cQuery += "	AND		SC6.C6_PRODUTO BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par13 + "' AND '" + mv_par14 + "'						" + chr(13)
	cQuery += "	AND		SC5.C5_VEND1 BETWEEN											" + chr(13)
	cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'						" + chr(13)
	cQuery += "	AND		SC5.C5_EMISSAO BETWEEN											" + chr(13)
	cQuery += "			'" + dtos(mv_par03) + "' AND '" + dtos(mv_par04) + "'			" + chr(13)
	cQuery += " AND		SC6.C6_BLQ      = 'R'											" + chr(13)
	cQuery += "	AND		SC6.D_E_L_E_T_ != '*'											" + chr(13)
	cQuery += "	AND		SC5.D_E_L_E_T_ != '*'											" + chr(13)
	cQuery += "	AND		SB1.D_E_L_E_T_ != '*'											" + chr(13)
	cQuery += "	GROUP BY																" + chr(13)
	If nOrdem == 1
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)
	ElseIf nOrdem == 2
		cQuery += "		SC5.C5_CLIENTE,													" + chr(13)
		cQuery += "		SC5.C5_LOJACLI,													" + chr(13)
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)
	Else
		cQuery += "		SC6.C6_NUM,														" + chr(13)
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)		
	EndIf
	cQuery += "	ORDER BY																" + chr(13)
	If nOrdem == 1
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)
	ElseIf nOrdem == 2
		cQuery += "		SC5.C5_CLIENTE,													" + chr(13)
		cQuery += "		SC5.C5_LOJACLI,													" + chr(13)
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)
	Else
		cQuery += "		SC6.C6_NUM,														" + chr(13)
		cQuery += "		SC6.C6_PRODUTO 													" + chr(13)
	EndIf
	
	memowrite("RJOMSR01.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens selecionados para impressão                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While (cAliasTMP)->(!EOF())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica o cancelamento pelo usuario...                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressao do cabecalho do relatorio. . .                            ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		If nLin > 55 
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Impressão dos dados                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek ( xFilial("SB1") + (cAliasTMP)->C6_PRODUTO )
		
		nQDTRESID := (cAliasTMP)->C6_QTDVEN - (cAliasTMP)->C6_QTDLIB
		nTOTPEDID += (cAliasTMP)->C6_QTDVEN
		nTOTFATUR += (cAliasTMP)->C6_QTDLIB
		nTOTRESID += nQDTRESID

		//cabec1 := "PRODUTO                                                             QUANTIDADE              QUANTIDADE              QUANTIDADE"
		//cabec2 := "                                                                    EM PEDIDO               FATURADA                EL.RESIDUO"
		//           012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//           0         1         2         3         4         5         6         7         8         9        10         11		

	
		If nOrdem == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Produto                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

			cPRODUTO := ALLTRIM((cAliasTMP)->C6_PRODUTO) + "-"+ ALLTRIM(SB1->B1_DESC)
			@nLin,000 PSAY SubSTR(cPRODUTO,1,58)
			@nLin,060 PSAY (cAliasTMP)->C6_QTDVEN 	PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY (cAliasTMP)->C6_QTDLIB 	PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nQDTRESID				PICTURE "@E 999,999,999,999.99"
					
		ElseIf nOrdem == 2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Cliente                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
			If cCODCLI != (cAliasTMP)->C5_CLIENTE + (cAliasTMP)->C5_LOJACLI
				
				If cCODCLI != STRING_NULL

					@nLin,000 PSAY "TOTAL CLIENTE ---> "
					@nLin,060 PSAY nTCLIPEDID PICTURE "@E 999,999,999,999.99"
					@nLin,082 PSAY nTCLIFATUR PICTURE "@E 999,999,999,999.99"
					@nLin,106 PSAY nTCLIRESID PICTURE "@E 999,999,999,999.99"
					nLin += 2
		
				EndIf
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek ( xFilial("SA1") + (cAliasTMP)->C5_CLIENTE + (cAliasTMP)->C5_LOJACLI )
				
				@nLin,000 PSAY "CLIENTE:  " + (cAliasTMP)->C5_CLIENTE + "/" + (cAliasTMP)->C5_LOJACLI + "-" + SA1->A1_NOME
				nLin += 1
				@nLin,000 PSAY "ENDERECO: " + SA1->A1_END + " MUNICIPIO: " + SA1->A1_MUN + " UF: " + SA1->A1_EST				
				nLin += 1
				
				nTCLIPEDID := 0
				nTCLIFATUR := 0
				nTCLIRESID := 0
			
			EndIf
			cCODCLI := (cAliasTMP)->C5_CLIENTE + (cAliasTMP)->C5_LOJACLI
			
			cPRODUTO := ALLTRIM((cAliasTMP)->C6_PRODUTO) + "-"+ ALLTRIM(SB1->B1_DESC)
			@nLin,002 PSAY SubSTR(cPRODUTO,1,56)
			@nLin,060 PSAY (cAliasTMP)->C6_QTDVEN	PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY (cAliasTMP)->C6_QTDLIB	PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nQDTRESID 				PICTURE "@E 999,999,999,999.99"		
				
			nTCLIPEDID += (cAliasTMP)->C6_QTDVEN
			nTCLIFATUR += (cAliasTMP)->C6_QTDLIB
			nTCLIRESID += nQDTRESID
			
		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Pedido                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
			If cNUMPED != (cAliasTMP)->C6_NUM
				
				If cNUMPED != STRING_NULL

					@nLin,000 PSAY "TOTAL PEDIDO ---> "
					@nLin,060 PSAY nTPEDPEDID PICTURE "@E 999,999,999,999.99"
					@nLin,082 PSAY nTPEDFATUR PICTURE "@E 999,999,999,999.99"
					@nLin,106 PSAY nTPEDRESID PICTURE "@E 999,999,999,999.99"
					nLin += 2
		
				EndIf
				
				dbSelectArea("SC5")
				dbSetOrder(1)
				dbSeek ( xFilial("SC5") + (cAliasTMP)->C6_NUM )
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek ( xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI )
				
				@nLin,000 PSAY "PEDIDO:  " + (cAliasTMP)->C6_NUM
				@nLin,030 PSAY "EMISSÃO: " + dtoc(SC5->C5_EMISSAO)
				@nLin,060 PSAY "VENDEDOR: " + SC5->C5_VEND1 + "-" + Posicione("SA3",1,xFilial("SA3")+SC5->C5_VEND1,"A3_NOME")
				nLin += 1
				@nLin,000 PSAY "CLIENTE: " + SC5->C5_CLIENTE + "/" + SC5->C5_LOJACLI + "-" + SA1->A1_NOME				
				nLin += 1
								
				nTPEDPEDID := 0
				nTPEDFATUR := 0
				nTPEDRESID := 0
			
			EndIf
			cNUMPED := (cAliasTMP)->C6_NUM			
			
			cPRODUTO := ALLTRIM((cAliasTMP)->C6_PRODUTO) + "-"+ ALLTRIM(SB1->B1_DESC)
			@nLin,002 PSAY SubSTR(cPRODUTO,1,56)
			@nLin,060 PSAY (cAliasTMP)->C6_QTDVEN	PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY (cAliasTMP)->C6_QTDLIB	PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nQDTRESID 				PICTURE "@E 999,999,999,999.99"
						
			nTPEDPEDID += (cAliasTMP)->C6_QTDVEN
			nTPEDFATUR += (cAliasTMP)->C6_QTDLIB
			nTPEDRESID += nQDTRESID		
		
		EndIf
	
		nLin := nLin + 1 
	    
		IncRegua()
		(cAliasTMP)->(dbSkip())
	   
	EndDo
	
	(cAliasTMP)->(dbCloseArea())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão dos totalizadores                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	If nTOTPEDID > 0

		If nOrdem == 1

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Produto                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			nLin += 1
			@nLin,000 PSAY "TOTAL GERAL ---> "
			@nLin,060 PSAY nTOTPEDID PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY nTOTFATUR PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nTOTRESID PICTURE "@E 999,999,999,999.99"
		
		ElseIf nOrdem == 2

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Cliente                                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
			If cCODCLI != STRING_NULL

				@nLin,000 PSAY "TOTAL CLIENTE ---> "
				@nLin,060 PSAY nTCLIPEDID PICTURE "@E 999,999,999,999.99"
				@nLin,082 PSAY nTCLIFATUR PICTURE "@E 999,999,999,999.99"
				@nLin,106 PSAY nTCLIRESID PICTURE "@E 999,999,999,999.99"
				nLin += 2
	
			EndIf

			@nLin,000 PSAY "TOTAL GERAL ---> "
			@nLin,060 PSAY nTOTPEDID PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY nTOTFATUR PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nTOTRESID PICTURE "@E 999,999,999,999.99"			
			
		Else

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ordem: Pedido                                                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
			If cNUMPED != STRING_NULL

				@nLin,000 PSAY "TOTAL PEDIDO ---> "
				@nLin,060 PSAY nTPEDPEDID PICTURE "@E 999,999,999,999.99"
				@nLin,082 PSAY nTPEDFATUR PICTURE "@E 999,999,999,999.99"
				@nLin,106 PSAY nTPEDRESID PICTURE "@E 999,999,999,999.99"
				nLin += 2
	
			EndIf

			@nLin,000 PSAY "TOTAL GERAL ---> "
			@nLin,060 PSAY nTOTPEDID PICTURE "@E 999,999,999,999.99"
			@nLin,082 PSAY nTOTFATUR PICTURE "@E 999,999,999,999.99"
			@nLin,106 PSAY nTOTRESID PICTURE "@E 999,999,999,999.99"
		
		EndIf
	
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RJOR01SC  º Autor ³ Rafael Parma       º Data ³  19/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Workflow de produtos faturados x eliminados por resíduo.   º±±
±±º          ³ Deve ser incluída função no schedule.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*----------------------------------------*
User Function RJOR01SC(cCODEMP,cCODFIL)
*----------------------------------------*
Local STRING_NULL := ""
Local cQuery    := STRING_NULL
Local cCODCLI   := STRING_NULL
Local cNUMPED   := STRING_NULL
Local cAliasTMP := STRING_NULL
Local nQDTRESID := 0
Local nTOTPEDID := 0
Local nTOTFATUR := 0
Local nTOTRESID := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	/*
	RpcClearEnv()
	RPCSetType(3)
	                                              
	PREPARE ENVIRONMENT EMPRESA (cCODEMP) FILIAL (cCODFIL) MODULO "FAT" 
	*/
    
	conout("WF - RJOR01SC - INICIO EXECUCAO ")
	cEmailCC := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "RJOR01SC", "ZWF_EMAIL"))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define variaveis                                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	cPEDDE := Space(TAMSX3("C5_NUM")[1])
	cPEDAT := Replicate("Z",TAMSX3("C5_NUM")[1])
	dDATDE := ddatabase-1
	dDATAT := ddatabase-1
	cCLIDE := Space(TAMSX3("A1_COD")[1])
	cCLIAT := Replicate("Z",TAMSX3("A1_COD")[1])
	cLOJDE := Space(TAMSX3("A1_LOJA")[1])
	cLOJAT := Replicate("Z",TAMSX3("A1_LOJA")[1])
	cVENDE := Space(TAMSX3("A3_COD")[1]) 
	cVENAT := Replicate("Z",TAMSX3("A3_COD")[1])
	cGRPDE := Space(TAMSX3("BM_GRUPO")[1])
	cGRPAT := Replicate("Z",TAMSX3("BM_GRUPO")[1]) 
	cPRDDE := Space(TAMSX3("B1_COD")[1]) 
	cPRDAT := Replicate("Z",TAMSX3("B1_COD")[1])
	cFILDE := Space(TAMSX3("B1_FILIAL")[1])
	cFILAT := Replicate("Z",TAMSX3("B1_FILIAL")[1])
	
	cAliasTMP := GetNextAlias()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cQuery := "	SELECT																	" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_VEND1,													" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_FILIAL,													" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_CLIENTE,													" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_LOJACLI,													" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_NUM,														" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_PRODUTO,													" + chr(13)+ chr(10)
	cQuery += "			SA3.A3_EMAIL,   												" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_QTDVEN,   												" + chr(13)+ chr(10)	
	cQuery += "			SC6.C6_QTDLIB					   								" + chr(13)+ chr(10)
	cQuery += "	FROM " + RetSQLName("SC6") + " SC6		   								" + chr(13)+ chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("SC5") + " SC5								" + chr(13)+ chr(10)
	cQuery += "	ON    																	" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_FILIAL  	= SC5.C5_FILIAL									" + chr(13)+ chr(10)
	cQuery += "	AND		SC6.C6_NUM  	= SC5.C5_NUM									" + chr(13)+ chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("SB1") + " SB1								" + chr(13)+ chr(10)
	cQuery += "	ON    																	" + chr(13)+ chr(10)
	cQuery += "			SB1.B1_COD  	= SC6.C6_PRODUTO								" + chr(13)+ chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("SA3") + " SA3								" + chr(13)+ chr(10)
	cQuery += "	ON    																	" + chr(13)+ chr(10)
	cQuery += "			SA3.A3_COD  	= SC5.C5_VEND1									" + chr(13)+ chr(10)
	cQuery += "	WHERE 									   								" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_FILIAL BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cFILDE + "' AND '" + cFILAT + "'					 		" + chr(13)+ chr(10)
	cQuery += "	AND		SC6.C6_NUM BETWEEN												" + chr(13)+ chr(10)
	cQuery += "			'" + cPEDDE + "' AND '" + cPEDAT + "'							" + chr(13)+ chr(10)
	cQuery += "	AND		SC5.C5_CLIENTE BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cCLIDE + "' AND '" + cCLIAT + "'					 		" + chr(13)+ chr(10)
	cQuery += "	AND		SC5.C5_LOJACLI BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cLOJDE + "' AND '" + cLOJAT + "'					  		" + chr(13)+ chr(10)
	cQuery += "	AND		SB1.B1_GRUPO BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cGRPDE + "' AND '" + cGRPAT + "'							" + chr(13)+ chr(10)
	cQuery += "	AND		SC6.C6_PRODUTO BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cPRDDE + "' AND '" + cPRDAT + "'					  		" + chr(13)+ chr(10)
	cQuery += "	AND		SC5.C5_VEND1 BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + cVENDE + "' AND '" + cVENAT + "'					  		" + chr(13)+ chr(10)
	cQuery += "	AND		SC5.C5_EMISSAO BETWEEN											" + chr(13)+ chr(10)
	cQuery += "			'" + dtos(dDATDE) + "' AND '" + dtos(dDATAT) + "'		   		" + chr(13)+ chr(10)
	cQuery += " AND		SC6.C6_BLQ      = 'R'											" + chr(13)+ chr(10)
	cQuery += " AND		SA3.A3_EMAIL   != '" + Space(TAMSX3("A3_EMAIL")[1]) + "'		" + chr(13)+ chr(10)	
	cQuery += "	AND		SC6.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	cQuery += "	AND		SC5.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	cQuery += "	AND		SB1.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	cQuery += "	AND		SA3.D_E_L_E_T_ != '*'											" + chr(13)+ chr(10)
	cQuery += "	ORDER BY																" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_VEND1,													" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_FILIAL,													" + chr(13)+ chr(10)			
	cQuery += "			SC6.C6_NUM,														" + chr(13)+ chr(10)	
	cQuery += "			SC5.C5_CLIENTE,													" + chr(13)+ chr(10)
	cQuery += "			SC5.C5_LOJACLI,													" + chr(13)+ chr(10)
	cQuery += "			SC6.C6_PRODUTO													" + chr(13)+ chr(10)
	
	memowrite("RJOR01SC.SQL",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens selecionados                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	While (cAliasTMP)->(!EOF())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa objetos do workflow                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		dbSelectArea("SA3")
		dbSetOrder(1)
		dbSeek ( xFilial("SA3") + (cAliasTMP)->C5_VEND1 )

	    cKEYVEN := (cAliasTMP)->C5_VEND1
	    cEMAILS := (cAliasTMP)->A3_EMAIL

		conout("WF - RJOR01SC - INICIO - PRODUTOS FATURADOS X ELIMINADOS POR RESIDUO ")
		
		oProcess := TWFProcess():New( "RJOR01SC", "PRODUTOS FATURADOS X ELIMINADOS POR RESIDUO")
		oProcess:NewTask( "RJOR01SC", "\workflow\rjomsr01.html")
		
		oProcess:cSubject :=  "WF - PRODUTOS FATURADOS X ELIMINADOS POR RESÍDUO" 
	
		oHTML := oProcess:oHTML
	
		oHtml:ValByName("VENDEDOR", (cAliasTMP)->C5_VEND1 + "-" + SA3->A3_NOME	)
		oHtml:ValByName("DATEMISS", dtoc(dDATDE)	)

	    
		While (cAliasTMP)->(!EOF()) .and. (cAliasTMP)->C5_VEND1 == cKEYVEN
	    
			dbSelectArea("SA1")
			dbSetOrder(1)
			dbSeek ( xFilial("SA1") + (cAliasTMP)->C5_CLIENTE + (cAliasTMP)->C5_LOJACLI )
	
		 	AAdd((oHtml:ValByName("IT1.PEDIDO" ))	, (cAliasTMP)->C6_NUM   		) 
		  	AAdd((oHtml:ValByName("IT1.CLIENT" ))	, (cAliasTMP)->C5_CLIENTE+"/"+(cAliasTMP)->C5_LOJACLI +"-"+ SA1->A1_NOME	)         
		 	AAdd((oHtml:ValByName("IT1.FILIAL" ))	, (cAliasTMP)->C5_FILIAL   		)     
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Processa itens do pedido                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
			nQDTRESID := 0
			nTOTPEDID := 0
			nTOTFATUR := 0
			nTOTRESID := 0
			cKEYPED := (cAliasTMP)->C5_VEND1 + (cAliasTMP)->C5_FILIAL + (cAliasTMP)->C6_NUM
				
			While (cAliasTMP)->(!EOF()) .and. (cAliasTMP)->C5_VEND1 + (cAliasTMP)->C5_FILIAL + (cAliasTMP)->C6_NUM == cKEYPED
	
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek ( xFilial("SB1") + (cAliasTMP)->C6_PRODUTO )
	
				nQDTRESID := (cAliasTMP)->C6_QTDVEN - (cAliasTMP)->C6_QTDLIB
				cPRODUTO  := ALLTRIM((cAliasTMP)->C6_PRODUTO) + "-"+ ALLTRIM(SB1->B1_DESC)
	
			  	AAdd((oHtml:ValByName("IT2.PEDIDO" ))	, (cAliasTMP)->C6_NUM		 	)
			  	AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, cPRODUTO 						)     
			 	AAdd((oHtml:ValByName("IT2.QTDPED" ))	, (cAliasTMP)->C6_QTDVEN   		)     
			 	AAdd((oHtml:ValByName("IT2.QTDFAT" ))	, (cAliasTMP)->C6_QTDLIB   		)  
			 	AAdd((oHtml:ValByName("IT2.QTDRES" ))	, nQDTRESID				   		)  
	
				nTOTPEDID += (cAliasTMP)->C6_QTDVEN
				nTOTFATUR += (cAliasTMP)->C6_QTDLIB
				nTOTRESID += nQDTRESID
				
				(cAliasTMP)->(dbSkip())
			Enddo
			
			AAdd((oHtml:ValByName("IT2.PEDIDO" ))	, "TOTAL PEDIDO"	)
		  	AAdd((oHtml:ValByName("IT2.PRODUTO" ))	, " -----> " 		)     
		 	AAdd((oHtml:ValByName("IT2.QTDPED" ))	, nTOTPEDID   		)     
		 	AAdd((oHtml:ValByName("IT2.QTDFAT" ))	, nTOTFATUR   		)  
		 	AAdd((oHtml:ValByName("IT2.QTDRES" ))	, nTOTRESID	   		) 			
            
		Enddo
				 
		If ALLTRIM(cEmailCC) != STRING_NULL
			cEMAILS += ";"+cEmailCC
		EndIf                 
		
		oProcess:cTo := cEMAILS
		ConOut("WF - RJOR01SC - E-MAIL ENVIADO PARA: " + oProcess:cTo)
	
		// inicia o processo de envio de workflow
		oProcess:Start()	
		
		// finaliza o processo
		oProcess:Finish()
		
		conout("WF - RJOR01SC - FIM - PRODUTOS FATURADOS X ELIMINADOS POR RESIDUO ")

	EndDo
	
	(cAliasTMP)->(dbCloseArea())

	conout("WF - RJOR01SC - FIM EXECUCAO ")
	
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do processo...                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  22/09/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Pedido De           ?","Pedido De           ?","Pedido De           ?","mv_ch1","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
	aAdd(aRegs,{cPerg,"02","Pedido Até          ?","Pedido Até          ?","Pedido Até          ?","mv_ch2","C",TAMSX3("C5_NUM")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SC5","","",""})
 	aAdd(aRegs,{cPerg,"03","Emissão De          ?","Emissão De          ?","Emissão De          ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Emissão Até         ?","Emissão Até         ?","Emissão Até         ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Cliente De          ?","Cliente De          ?","Cliente De          ?","mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"06","Cliente Até         ?","Cliente Até         ?","Cliente Até         ?","mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","001",""})
	aAdd(aRegs,{cPerg,"07","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch7","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Loja Até            ?","Loja Até            ?","Loja Até            ?","mv_ch8","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","Vendedor De         ?","Vendedor De         ?","Vendedor De         ?","mv_ch9","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"10","Vendedor Até        ?","Vendedor Até        ?","Vendedor Até        ?","mv_cha","C",TAMSX3("A3_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA3","","",""})
	aAdd(aRegs,{cPerg,"11","Grupo De            ?","Grupo De            ?","Grupo De            ?","mv_chb","C",TAMSX3("BM_GRUPO")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})
	aAdd(aRegs,{cPerg,"12","Grupo Até           ?","Grupo Até           ?","Grupo Até           ?","mv_chc","C",TAMSX3("BM_GRUPO")[1],0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "SBM","","",""})
	aAdd(aRegs,{cPerg,"13","Produto De          ?","Produto De          ?","Produto De          ?","mv_chd","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","030",""})
	aAdd(aRegs,{cPerg,"14","Produto Até         ?","Produto Até         ?","Produto Até         ?","mv_che","C",TAMSX3("B1_COD")[1],0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "SB1","","030",""})
	aAdd(aRegs,{cPerg,"15","Filial De           ?","Filial De           ?","Filial De           ?","mv_chf","C",TAMSX3("B1_FILIAL")[1],0,0,"G","","mv_par15","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"16","Filial Até          ?","Filial Até          ?","Filial Até          ?","mv_chg","C",TAMSX3("B1_FILIAL")[1],0,0,"G","","mv_par16","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil