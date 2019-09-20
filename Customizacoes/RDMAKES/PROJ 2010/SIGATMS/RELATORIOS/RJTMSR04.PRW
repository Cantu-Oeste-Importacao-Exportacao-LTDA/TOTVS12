#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJTMSR04   ºAutor  ³Rafael Parma       º Data ³  17/02/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão do relatório de CTRC por cliente, veículo e moto- º±±
±±º          ³rista.                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------*
User Function RJTMSR04()
*-------------------------*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := ""
Local cPict         := ""
Local titulo        := "RELATÓRIO CTRC"
Local nLin          := 80
Local Cabec1 		:= ""
Local Cabec2 		:= ""
Local imprime       := .T.
Local aOrd          := {"Tomador Serviço","Motorista","Veículo"}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 220
Private tamanho     := "G"
Private nomeprog    := "RJTMSR04" 
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cbtxt       := Space(10)
Private cbcont      := 00
Private CONTFL      := 01
Private m_pag       := 01
Private wnrel       := "RJTMSR04"
Private cPerg       := "RJTMSR0004"
Private cString     := "DT6"
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
		titulo := ALLTRIM(titulo) + " - POR TOMADOR DE SERVIÇO"
		Cabec2 := "SERIE/CTRC    EMISSÃO   NATUREZA CARGA                  REMETENTE                       DESTINATÁRIO                    VEÍCULO     CARRETA     MOTORISTA                            VOLUME        VLR. FRETE   VLR. MERCAD."
	ElseIf nOrdem == 2        
		titulo := ALLTRIM(titulo) + " - POR MOTORISTA"
		Cabec2 := "SERIE/CTRC    EMISSÃO   NATUREZA CARGA                  REMETENTE                       DESTINATÁRIO                    VEÍCULO     CARRETA                                          VOLUME        VLR. FRETE   VLR. MERCAD."
	Else
		titulo := ALLTRIM(titulo) + " - POR VEÍCULO"
		Cabec2 := "SERIE/CTRC    EMISSÃO   NATUREZA CARGA                  REMETENTE                       DESTINATÁRIO                                            MOTORISTA                            VOLUME        VLR. FRETE   VLR. MERCAD."
	EndIf
	Cabec1 := "PERÍODO DE: " + DTOC(mv_par01) + " ATÉ: " + DTOC(mv_par02)

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ Rafael Parma       º Data ³  17/02/11   º±±
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
Local cAliasTMP := GetNextAlias()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Filtro de registros                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ      
	
	cQuery := "	SELECT	DISTINCT														" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_DOC,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_SERIE,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_DATEMI,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_FILDOC,													" + chr(13)+chr(10)		
	cQuery += "			DT6.DT6_CLIREM,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_LOJREM,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_CLIDES,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_LOJDES,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_CLIDEV,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_LOJDEV,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_QTDVOL,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_VALFRE,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_VALMER,													" + chr(13)+chr(10)
	cQuery += "			DUP.DUP_CODMOT,													" + chr(13)+chr(10)		
	cQuery += "			DTC.DTC_CODPRO,													" + chr(13)+chr(10)                                                                                
	cQuery += "			DTC.DTC_FILORI,													" + chr(13)+chr(10)
  	cQuery += "			DTC.DTC_LOTNFC,													" + chr(13)+chr(10)
	cQuery += "			DTC.DTC_SERNFC,													" + chr(13)+chr(10)    
	cQuery += "			DTC.DTC_NUMNFC,													" + chr(13)+chr(10)					
	cQuery += "			DTR.DTR_CODVEI,													" + chr(13)+chr(10)
	cQuery += "			DTR.DTR_CODRB1,													" + chr(13)+chr(10)
	cQuery += "			DUY.DUY_DESCRI,													" + chr(13)+chr(10) 
	cQuery += "			DA4.DA4_NOME,													" + chr(13)+chr(10) 
	cQuery += "			DUY.DUY_EST														" + chr(13)+chr(10)	
	cQuery += "	FROM " + RetSQLName("DT6") + " DT6		   								" + chr(13)+chr(10) 	
	cQuery += "	INNER JOIN " + RetSQLName("DTA") + " DTA								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DTA.DTA_FILIAL 	= DT6.DT6_FILIAL								" + chr(13)+chr(10)
	cQuery += "	AND		DTA.DTA_FILDOC	= DT6.DT6_FILDOC								" + chr(13)+chr(10)
	cQuery += "	AND		DTA.DTA_DOC 	= DT6.DT6_DOC									" + chr(13)+chr(10)
	cQuery += "	AND		DTA.DTA_SERIE	= DT6.DT6_SERIE									" + chr(13)+chr(10)
	cQuery += "	AND		DTA.DTA_FILORI	= DT6.DT6_FILORI								" + chr(13)+chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("DTR") + " DTR								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DTR.DTR_FILIAL 	= DTA.DTA_FILIAL								" + chr(13)+chr(10)
	cQuery += "	AND		DTR.DTR_FILORI	= DTA.DTA_FILDOC								" + chr(13)+chr(10)
	cQuery += "	AND		DTR.DTR_VIAGEM	= DTA.DTA_VIAGEM								" + chr(13)+chr(10)	
	cQuery += "	INNER JOIN " + RetSQLName("DUP") + " DUP								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DUP.DUP_FILIAL 	= DTA.DTA_FILIAL								" + chr(13)+chr(10)
	cQuery += "	AND		DUP.DUP_FILORI	= DTA.DTA_FILDOC								" + chr(13)+chr(10)
	cQuery += "	AND		DUP.DUP_VIAGEM	= DTA.DTA_VIAGEM								" + chr(13)+chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("DUY") + " DUY								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DUY.DUY_FILIAL 	= DT6.DT6_FILIAL								" + chr(13)+chr(10)
	cQuery += "	AND		DUY.DUY_GRPVEN	= DT6.DT6_CDRCAL								" + chr(13)+chr(10)
	cQuery += "	INNER JOIN " + RetSQLName("DTC") + " DTC								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DTC.DTC_FILIAL 	= DT6.DT6_FILIAL								" + chr(13)+chr(10)
	cQuery += "	AND		DTC.DTC_FILDOC	= DT6.DT6_FILDOC								" + chr(13)+chr(10)
	cQuery += "	AND		DTC.DTC_DOC		= DT6.DT6_DOC									" + chr(13)+chr(10)	
	cQuery += "	AND		DTC.DTC_SERIE	= DT6.DT6_SERIE									" + chr(13)+chr(10)				
	cQuery += "	INNER JOIN " + RetSQLName("DA4") + " DA4								" + chr(13)+chr(10)
	cQuery += "	ON    																	" + chr(13)+chr(10)
	cQuery += "			DA4.DA4_COD 	= DUP.DUP_CODMOT								" + chr(13)+chr(10)
	cQuery += "	WHERE 									   								" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_FILIAL = '" + xFilial("DT6") + "'						" + chr(13)+chr(10)
	cQuery += "	AND		DA4.DA4_FILIAL = '" + xFilial("DA4") + "'						" + chr(13)+chr(10)
	cQuery += "	AND		DT6.DT6_DATEMI BETWEEN											" + chr(13)+chr(10)
	cQuery += "			'" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'			" + chr(13)+chr(10)
	cQuery += "	AND		DT6.DT6_SERIE BETWEEN											" + chr(13)+chr(10)
	cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'						" + chr(13)+chr(10)
	cQuery += "	AND		DT6.DT6_CLIDEV BETWEEN											" + chr(13)+chr(10)
	cQuery += "			'" + mv_par03 + "' AND '" + mv_par04 + "'						" + chr(13)+chr(10)
	cQuery += "	AND		DTR.DTR_CODVEI BETWEEN											" + chr(13)+chr(10)
	cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'						" + chr(13)+chr(10)
	cQuery += "	AND		DUP.DUP_CODMOT BETWEEN											" + chr(13)+chr(10)
	cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'						" + chr(13)+chr(10)
	If mv_par12 == 1
		cQuery += " AND DT6_X_SEGM = '" + mv_par13 + "'						" + chr(13)+chr(10)  	// Guilherme adicionado o filtro por segmento					
	EndIf		
	cQuery += "	AND		DT6.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)
	cQuery += "	AND		DTA.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)
	cQuery += "	AND		DTR.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)
	cQuery += "	AND		DUP.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)
	cQuery += "	AND		DUY.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)		
	cQuery += "	AND		DTC.D_E_L_E_T_ != '*'											" + chr(13)+chr(10)  
	cQuery += "	AND		DA4.D_E_L_E_T_ != '*'											" + chr(13)+chr(10) //Guilherme Poyer Incluido filtro de deletados por estar duplicando os dados 29-01-13 
	cQuery += "	ORDER BY																" + chr(13)+chr(10)
	If nOrdem == 1
		cQuery += "		DT6.DT6_CLIDEV,													" + chr(13)+chr(10)
		cQuery += "		DT6.DT6_LOJDEV,													" + chr(13)+chr(10)
	ElseIf nOrdem == 2
		cQuery += "		DA4.DA4_NOME,													" + chr(13)+chr(10)	
	Else
		cQuery += "		DTR.DTR_CODVEI,													" + chr(13)+chr(10)
	EndIf
	cQuery += "			DT6.DT6_DATEMI,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_SERIE,													" + chr(13)+chr(10)
	cQuery += "			DT6.DT6_DOC														" + chr(13)+chr(10)	
	MemoWrite("c:\RJTMSR04.txt",cQuery)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Percorre itens selecionados para impressão                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	nTOTPES := 0	// Total peso
	nTOTFRT := 0	// Total frete
	nTOTMER := 0	// Total mercadoria
	nKEYPES := 0	// Total peso
	nKEYFRT := 0	// Total frete
	nKEYMER := 0	// Total mercadoria

	cCODKEY := STRING_NULL   
	cDt6Doc := ""

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
        
		//-- Produto
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek ( xFilial("SB1") + (cAliasTMP)->DTC_CODPRO ) 
				
		//-- Veiculo
		dbSelectArea("DA3")
		dbSetOrder(1)
		dbSeek ( xFilial("DA3") + (cAliasTMP)->DTR_CODVEI ) 		
		cDESVEI := DA3->DA3_DESC
		cPLCVEI := DA3->DA3_PLACA

		//-- Veiculo, carreta
		cDESCAR := Replicate(" ",TAMSX3("DA3_DESC")[1])
		cPLCCAR := Replicate(" ",TAMSX3("DA3_PLACA")[1])
		dbSelectArea("DA3")
		dbSetOrder(1)
		If dbSeek ( xFilial("DA3") + (cAliasTMP)->DTR_CODRB1 ) 		
			cDESCAR := DA3->DA3_DESC
			cPLCCAR := DA3->DA3_PLACA
		EndIf
		
		//-- Cliente devedor
		cNOMDEV := STRING_NULL
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek ( xFilial("SA1") + (cAliasTMP)->DT6_CLIDEV + (cAliasTMP)->DT6_LOJDEV )
			cNOMDEV := SubSTR(SA1->A1_NOME,1,30)
		EndIf
		 		
		//-- Cliente destinatário
		cNOMDES := STRING_NULL
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek ( xFilial("SA1") + (cAliasTMP)->DT6_CLIDES + (cAliasTMP)->DT6_LOJDES )
			cNOMDES := SubSTR(SA1->A1_NOME,1,30)
		EndIf

		//-- Cliente remessa
		cNOMREM := STRING_NULL
		dbSelectArea("SA1")
		dbSetOrder(1)
		If dbSeek ( xFilial("SA1") + (cAliasTMP)->DT6_CLIREM + (cAliasTMP)->DT6_LOJREM )
			cNOMREM := SubSTR(SA1->A1_NOME,1,30)
			cMUNREM := SA1->A1_MUN
			cESTREM := SA1->A1_EST
		EndIf		
                            
		
		// Lote de Entrada Notas Fiscais 
		dbSelectArea("DTP")	
		dbSetOrder(2)
		dbGoTop()			
		dbSeek ( xFilial("DTP") + (cAliasTMP)->DTC_FILORI + (cAliasTMP)->DTC_LOTNFC )
		

	  	If nOrdem == 1
    		If cCODKEY != ( (cAliasTMP)->DT6_CLIDEV + (cAliasTMP)->DT6_LOJDEV )
	       		If cCODKEY != STRING_NULL
	    			@nLin,000 PSAY "TOTAL "
					@PRow(),176 PSAY TRANSFORM(nKEYPES,"@E 99999999.99")
					@PRow(),192 PSAY TRANSFORM(nKEYFRT,"@E 99,999,999.99")
					@PRow(),206 PSAY TRANSFORM(nKEYMER,"@E 99,999,999.99")            		
			    	nLin += 2
	       		 
	        		If mv_par11 == 1		
	       	   			// Faz a quebra de página a cada tomador - chamado 334
	     		   		// Flavio - 24/10/2011
	        	 	 	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
		       	EndIf
     			@nLin,000 PSAY "TOMADOR DO SERVIÇO: " + (cAliasTMP)->DT6_CLIDEV +"/"+ (cAliasTMP)->DT6_LOJDEV +"-"+cNOMDEV 				
				nLin += 1                                                                                                  
				@nLin,000 PSAY Replicate("-",220)
				nLin += 1                                                                                                  				
				nKEYFRT := 0
				nKEYPES := 0
				nKEYMER := 0
			EndIf
			cCODKEY := ( (cAliasTMP)->DT6_CLIDEV + (cAliasTMP)->DT6_LOJDEV )
	    ElseIf nOrdem == 2
    		If cCODKEY != (cAliasTMP)->DUP_CODMOT
				nLin += 1                                                                                                  
				@nLin,000 PSAY Replicate("-",220)
				nLin += 1

				If cCODKEY != STRING_NULL
	        		@nLin,000 PSAY "TOTAL "
					@PRow(),176 PSAY TRANSFORM(nKEYPES,"@E 99999999.99")
					@PRow(),192 PSAY TRANSFORM(nKEYFRT,"@E 99,999,999.99")
					@PRow(),206 PSAY TRANSFORM(nKEYMER,"@E 99,999,999.99")            		
	     			nLin += 2
	     			
	     			If mv_par11 == 1
	     				// Faz a quebra de página a cada motorista - chamado 334
		     			// Flavio - 24/10/2011
			        	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					endif
        
    		    EndIf
        
		        @nLin,000 PSAY "MOTORISTA: " + (cAliasTMP)->DUP_CODMOT +"-"+(cAliasTMP)->DA4_NOME
				nLin += 1                                                                                                  
				@nLin,000 PSAY Replicate("-",220)
				nLin += 1                                                                                                  				
				nKEYFRT := 0
				nKEYPES := 0
				nKEYMER := 0
			EndIf
			cCODKEY := (cAliasTMP)->DUP_CODMOT			 
	    ElseIf nOrdem ==3
    		If cCODKEY != (cAliasTMP)->DTR_CODVEI
       			If cCODKEY != STRING_NULL
	       			@nLin,000 PSAY "TOTAL "
					@PRow(),176 PSAY TRANSFORM(nKEYPES,"@E 99999999.99")
					@PRow(),192 PSAY TRANSFORM(nKEYFRT,"@E 99,999,999.99")
					@PRow(),206 PSAY TRANSFORM(nKEYMER,"@E 99,999,999.99")            		
		       		nLin += 2
	       		
	    		    If mv_par11 == 1
		       			// Faz a quebra de página a cada placa - chamado 334
		     			// Flavio - 24/10/2011
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 9
					Endif
						  
		       	EndIf            	
		       	@nLin,000 PSAY "VEÍCULO: " + cPLCVEI +"-"+cDESVEI + " CARRETA: " + cPLCCAR +"-"+cDESCAR
				nLin += 1                                                                                                  
				@nLin,000 PSAY Replicate("-",220)
				nLin += 1                                                                                                  				
				nKEYFRT := 0
				nKEYPES := 0
				nKEYMER := 0
			EndIf
			cCODKEY := (cAliasTMP)->DTR_CODVEI
		EndIf

		// Regua             1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2
		// 		   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//		  "SERIE/CTRC    EMISSÃO   NATUREZA CARGA                  REMETENTE                       DESTINATÁRIO                    VEÍCULO     CARRETA     MOTORISTA                            VOLUME        VLR. FRETE   VLR. MERCAD."
						
		@nLin,000 PSAY (cAliasTMP)->DT6_SERIE + "/" + (cAliasTMP)->DT6_DOC
		@PRow(),014 PSAY dtoc((stod((cAliasTMP)->DT6_DATEMI)))
		@PRow(),024 PSAY SubSTR(SB1->B1_DESC,1,30)
		@PRow(),056 PSAY cNOMREM
		@PRow(),088 PSAY cNOMDES
		If nOrdem != 3
			@PRow(),120 PSAY cPLCVEI
			@PRow(),132 PSAY cPLCCAR
		EndIf
		If nOrdem != 2
			@PRow(),144 PSAY SubSTR((cAliasTMP)->DA4_NOME,1,30)		
		EndIf
		@PRow(),176 PSAY TRANSFORM((cAliasTMP)->DT6_QTDVOL,"@E 99999999.99")    
		
		//Gustavo 17/04/2015 - Alterado para imprimir apenas uma vez o valor do frete em caso de documentos iguais.
		If Empty(cDt6Doc) .or. (cDt6Doc != (cAliasTMP)->DT6_DOC)
			@PRow(),192 PSAY TRANSFORM((cAliasTMP)->DT6_VALFRE,"@E 99,999,999.99")
			nTOTFRT += (cAliasTMP)->DT6_VALFRE	// Total frete
			nKEYFRT += (cAliasTMP)->DT6_VALFRE	// Total frete  
			cDt6Doc := (cAliasTMP)->DT6_DOC
		End
		//Fim Gustavo 17/04/2015
		
		@PRow(),206 PSAY TRANSFORM((cAliasTMP)->DT6_VALMER,"@E 99,999,999.99")
		
		nLin += 1
		@nLin,000 PSAY "NÚMERO DA VIAGEM: " + DTP->DTP_VIAGEM
		@nLin,040 PSAY "DOCUMENTO TOMADOR: " + (cAliasTMP)->DTC_SERNFC + "/" + (cAliasTMP)->DTC_NUMNFC
		@nLin,100 PSAY "LOCAL ORIGEM: " + ALLTRIM(cMUNREM) + "/" + cESTREM
		@nLin,160 PSAY "LOCAL DESTINO: " + ALLTRIM((cAliasTMP)->DUY_DESCRI) + "/" + (cAliasTMP)->DUY_EST

		nTOTPES += (cAliasTMP)->DT6_QTDVOL	// Total peso
		nTOTMER += (cAliasTMP)->DT6_VALMER	// Total mercadoria
		nKEYPES += (cAliasTMP)->DT6_QTDVOL	// Total peso
		nKEYMER += (cAliasTMP)->DT6_VALMER	// Total mercadoria
		
		nLin += 1
		(cAliasTMP)->(dbSkip())
	Enddo                       
	
	(cAliasTMP)->(dbCloseArea())	

	If nTOTFRT > 0
		If cCODKEY != STRING_NULL
	 		@nLin,000 PSAY "TOTAL "
			@PRow(),176 PSAY TRANSFORM(nKEYPES,"@E 99999999.99")
			@PRow(),192 PSAY TRANSFORM(nKEYFRT,"@E 99,999,999.99")
			@PRow(),206 PSAY TRANSFORM(nKEYMER,"@E 99,999,999.99")            		
	  		nLin += 2
	 		@nLin,000 PSAY "TOTAL GERAL "
			@PRow(),176 PSAY TRANSFORM(nTOTPES,"@E 99999999.99")
			@PRow(),192 PSAY TRANSFORM(nTOTFRT,"@E 99,999,999.99")
			@PRow(),206 PSAY TRANSFORM(nTOTMER,"@E 99,999,999.99")            		
	  		nLin += 2

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

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  17/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para verificar/criar no ambiente o grupo   º±±
±±º          ³de perguntas.                                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------*
Static Function AjustaSX1()
*---------------------------*
aRegs  := {} 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Definição dos itens do grupo de perguntas a ser criado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	aAdd(aRegs,{cPerg,"01","Período De          ?","Período De          ?","Período De          ?","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"02","Período Até         ?","Período Até         ?","Período Até         ?","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPerg,"03","Tomador Serviço De  ?","Tomador Serviço De  ?","Tomador Serviço De  ?","mv_ch3","C",TAMSX3("DT6_CLIDEV")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","",""})
	aAdd(aRegs,{cPerg,"04","Tomador Serviço Até ?","Tomador Serviço Até ?","Tomador Serviço Até ?","mv_ch4","C",TAMSX3("DT6_CLIDEV")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","",""})
	aAdd(aRegs,{cPerg,"05","Veículo De          ?","Veículo De          ?","Veículo De          ?","mv_ch5","C",TAMSX3("DA3_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "DA3","","",""})
	aAdd(aRegs,{cPerg,"06","Veículo Até         ?","Veículo Até         ?","Veículo Até         ?","mv_ch6","C",TAMSX3("DA3_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "DA3","","",""})
	aAdd(aRegs,{cPerg,"07","Motorista De        ?","Motorista De        ?","Motorista De        ?","mv_ch7","C",TAMSX3("DA4_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "DA4","","",""})
	aAdd(aRegs,{cPerg,"08","Motorista Até       ?","Motorista Até       ?","Motorista Até       ?","mv_ch8","C",TAMSX3("DA4_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "DA4","","",""})
	aAdd(aRegs,{cPerg,"09","Serie CTRC De       ?","Serie CTRC De       ?","Serie CTRC De       ?","mv_ch9","C",TAMSX3("DT6_SERIE")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","Serie CTRC Até      ?","Serie CTRC Até      ?","Serie CTRC Até      ?","mv_cha","C",TAMSX3("DT6_SERIE")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"11","Quebra Página       ?","Quebra Página       ?","Quebra Página       ?","mv_chb","N",01,0,1,"C","","mv_par11","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"12","Considera Segmento  ?","Considera Segmento  ?","Considera Segmento  ?","mv_chc","N",01,0,2,"C","","mv_par12","Sim","Sim","Sim","","","Não","Não","Não","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"13","Segmento            ?","Segmento            ?","Segmento            ?","mv_chd","C",TAMSX3("DT6_X_SEGM")[1],0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "CTH","","",""})
	
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
