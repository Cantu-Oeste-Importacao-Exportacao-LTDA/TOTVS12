#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJTMSR03  º Autor ³ Rafael Parma       º Data ³  27/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Impressão do conhecimento de transporte rodoviário cargas. º±±
±±º          ³ CTRC                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU-Transporte                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-------------------------*
User Function RJTMSR03()
*-------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := ""
Local cPict          := ""
Local titulo         := "Impressão CTRC"
Local nLin           := 80
Local Cabec1         := ""
Local Cabec2         := ""
Local imprime        := .T.
Local aOrd           := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "RJTMSR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 18
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01                                                                        
Private cPerg        := "RJTMSR0003" 
Private wnrel        := "RJTMSR03" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString      := "DT6" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea(cString)
	dbSetOrder(1)

	AjustaSX1()
	Pergunte(cPerg,.F.)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJTMSR03  º Autor ³ Rafael Parma       º Data ³  27/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-----------------------------------------------------*
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
*-----------------------------------------------------*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local cSelFis       := SuperGetMv('MV_SELFIS')
Local cSeloFis      := ""
Local cSerSelo      := ""

Local lFirstSelo    := .T.
Local  cLotNfc      := ""
Local  nLin         := 80
Local  cStatus      := "3/4"
Local  aPicICM      := {}
Local  aEnder       := {}
Local  nTotal       := 0
Local  lAgrega 	    := .F. 
Local  aCompFrete   := Array(12,2)      
Local  cNumNotas    := ""
Local  cNumCot      := ""
Local  bCondDTC     := {|| }
Local  aObservacoes := Array(6)
Local  aDoctos      := {}
Local  bWhile       := {|| }
Local  nOrdDT6      := 0
Local  nCnt         := 0
Local  nOrdem       := aReturn[8]
Local nX            := 0
Private nPAGINA     := 1

Private cNomRem     := cEndRem    := cCEPRem    := cMunRem    := cEstRem    := cCGCRem    := cInscRem    := ""
Private cNomDev     := cEndDev    := cCEPDev    := cMunDev    := cEstDev    := cCGCDev    := cInscDev    := ""
Private cNomDes     := cEndDes    := cCEPDes    := cMunDes    := cEstDes    := cCGCDes    := cInscDes    := cEndEnt := ""
Private cNomCONDPC  := cEndCONDPC := cCEPCONDPC := cMunCONDPC := cEstCONDPC := cCGCCONDPC := cInscCONDPC := ""
Private cDevFrete   := cTipFrete  := cDestCalc  := ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Alimenta Arquivo de Trabalho                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("DTP")
	dbSetOrder(2)
	dbSeek( xFilial("DTP") + cFilAnt + mv_par01 )
	SetRegua(LastRec())
	
	Do While !EOF() .And. ( DTP_FILIAL+DTP_FILORI==xFilial("DTP")+cFilAnt ) .And. ( DTP_LOTNFC <= mv_par02 )
		
		IncRegua()
		
	   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	   	//³ Verifica o cancelamento pelo usuario...                             ³
	   	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	   	If lAbortPrint
	      	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	      	Exit
	   	Endif		
	
		If !(DTP->DTP_STATUS $ cStatus)
			DTP->(dbSkip())
			Loop
		EndIf
		                   
		//-- Nota Fiscal	--//

		aDoctos := {}
		cLotNfc := DTP_LOTNFC
		cFilOri := DTP_FILORI
		
		bWhile  := { || DT6->(!Eof()) .And. DT6->DT6_FILIAL + DT6->DT6_FILDOC + DT6->DT6_DOC + DT6->DT6_SERIE == xFilial("DT6")+aDoctos[nCnt] }
		nOrdDT6 := 1
		cIndex  := CriaTrab(NIL,.F.)
		cFiltro := " DTC->DTC_FILIAL == '" + xFilial("DTC")  + "' "
		cFiltro += " .And. DTC->DTC_FILORI == '" + cFilOri + "' "
		cFiltro += " .And. DTC->DTC_LOTNFC == '" + cLotNfc + "' "
		IndRegua('DTC',cIndex,'DTC_FILIAL+DTC_FILORI+DTC_NUMNFC',,cFiltro,"Selecionando Registros...",.F.)
			
		While DTC->(!Eof())
			If Ascan( aDoctos, { |x| x == DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE } ) == 0
				Aadd( aDoctos, DTC->DTC_FILDOC + DTC->DTC_DOC + DTC->DTC_SERIE )
			EndIf
			DTC->(DbSkip())
		EndDo
	
		RetIndex("DTC")
		If	File(cIndex+OrdBagExt())
			Ferase(cIndex+OrdBagExt())
		EndIf
             

		For nCnt := 1 To Len(aDoctos)
	
			dbSelectArea("DT6")
			dbSetOrder(nOrdDT6)
			MsSeek(xFilial("DT6")+aDoctos[nCnt])
		
			Do While Eval(bWhile)
				
				If !(DT6->DT6_DOCTMS $ '26789AE')			
					dbSkip()
					Loop
				EndIf
				
				If ((DT6_DOC < mv_par03) .Or. (DT6_DOC > mv_par04)) .Or. ((DT6_SERIE < mv_par05) .Or. (DT6_SERIE > mv_par06)) .Or.;			
					(DT6_SERIE == "PED")
					dbSkip()
					Loop
				EndIf
	
				//-- Obtem o nr. do selo fiscal, se a filial estiver contida no parametro	
				If	cFilAnt $ cSelFis
					// Nao soma um item no primeiro selo
					If	!lFirstSelo
						cSeloFis := Soma1(cSeloFis)					
					EndIf
					If lFirstSelo
						lFirstSelo:=.F.
					EndIf
				EndIf
				
				// Busca as notas do cliente para o 1o percurso.
				If DT6->DT6_PRIPER == StrZero(1, Len(DT6->DT6_PRIPER))
					bCondDTC := {|| !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOCPER+DTC_SERIE) ==;
					DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)}
					
					RTmsr01NFCli(4, bCondDTC, @cNumNotas, @cNumCot, @aEnder)
					
					// Busca as notas do cliente para o 2o percurso.
				Else
					bCondDTC := {|| !DTC->(Eof()) .And. DTC->(DTC_FILIAL+DTC_FILDOC+DTC_DOC+DTC_SERIE) ==;
					DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)}
					
					RTmsr01NFCli(3, bCondDTC, @cNumNotas, @cNumCot, @aEnder)
				EndIf
				
				//-- Itens da Nota Fiscal de Saida
				SD2->(dbSetOrder(3))
				SD2->(MsSeek(xFilial("SD2")+DT6->(DT6_DOC + DT6_SERIE)))
				cCodPro := SD2->D2_COD
				
				aAreaSD2 := SD2->(GetArea())
				SD2->( DbEval( { || IIF(!SD2->(Eof()) .And. D2_PICM <> 0,AADD(aPicICM, Transform(SD2->D2_PICM,PesqPict('SD2','D2_PICM'))) ,.T.) },, ;
				{ || D2_FILIAL+D2_DOC + D2_SERIE == ;
				xFilial("SD2")+DT6->DT6_DOC + DT6->DT6_SERIE } ) )
				RestArea(aAreaSD2)

				aEval(aCompFrete, {|x| x[1]:= ""})
				aEval(aCompFrete, {|x| x[2]:=  0})
				nX := 1
				DT8->(dbSetOrder(2))
				DT8->(MsSeek(xFilial("DT8")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
				Do While !DT8->(Eof()) .And. DT8->(DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE) == DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)
					If nX > 10
						Exit
					EndIf
					If DT8->DT8_CODPAS <> "TF"
						aCompFrete[nx][1] := DT8->DT8_CODPAS
					EndIf
					nX++
					DT8->(dbSkip())
				EndDo
				
				nX     := 1
				nTotal := 0
				DT8->(MsSeek(xFilial("DT8")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))
				Do While !DT8->(Eof()) .And. DT8->(DT8_FILIAL+DT8_FILDOC+DT8_DOC+DT8_SERIE) == DT6->(DT6_FILIAL+DT6_FILDOC+DT6_DOC+DT6_SERIE)
					nZ := nX
					If DT9->(MsSeek(xFilial("DT9")+DT6->DT6_NCONTR+DT8->DT8_CODPAS))
						nX := Ascan(aCompFrete, {|x| x[1] == DT9->DT9_AGRPAS })
						If nX > 0
							lAgrega := .T.
							nX      := Val(DT9->DT9_AGRPAS)
						Else
							lAgrega := .F.
							nX      := nZ
						EndIf
					EndIf
					If DT8->DT8_CODPAS <> "TF"
						If nX <= 10
							aCompFrete[nx][1] := IIf(!lAgrega,DT8->DT8_CODPAS,aCompFrete[nx][1])
							aCompFrete[nx][2] += DT8->DT8_VALTOT
						Else
							aCompFrete[11][1] := "XX"
							aCompFrete[11][2] += DT8->DT8_VALTOT
							nTotal += DT8->DT8_VALTOT
						EndIf
						nTotal += DT8->DT8_VALTOT
					Else
						aCompFrete[12][1] := "TF"
						aCompFrete[12][2] :=  nTotal
					EndIf
					nX := nZ
					nX++
					DT8->(dbSkip())
				EndDo
				

				//-- Nota Fiscal de Saida
				SF2->(dbSetOrder(1))                                             
				SF2->(MsSeek(xFilial("SF2")+DT6->(DT6_DOC + DT6_SERIE)))
				
				//-- Livros Fiscais
				SF3->(dbSetOrder(5))
				SF3->(MsSeek(xFilial("SF3")+DT6->(DT6_SERIE + DT6_DOC)+SF2->(F2_CLIENTE + F2_LOJA)))
				
				// Carregamento
				DTA->(dbSetOrder(1))
				If ! DTA->(MsSeek(xFilial("DTA")+DT6->(DT6_FILDOC + DT6_DOC + DT6_SERIE + DT6_FILORI )))				
					Aviso("CARREGAMENTO","Favor efetuar o carragamento da viagem relacionada ao documento: "+DT6->DT6_DOC+"/"+DT6->DT6_SERIE,{"OK"},2)
					Return
				EndIf
				
				// Veiculos da viagem
				DTR->(dbSetOrder(1))
				DTR->(MsSeek(xFilial("DTR")+DTA->(DTA_FILORI + DTA_VIAGEM )))				

				// Motoristas da viagem
				DUP->(dbSetOrder(1))
				DUP->(MsSeek(xFilial("DUP")+DTA->(DTA_FILORI + DTA_VIAGEM )))				
				
				//-- Verifica os dados dos Clientes
				RTMSR01DT6()
	
				//-- Imprime cabecalho com dados do Emitente
				RTMSR03Cab(@nLin)
		
	
				//-- Imprime dados do Remetente / Devedor do Frete
				@ nLin,030 PSay cNomRem  //-- Nome Rem
				@ nLin,135 PSay cNomDes  //--Nome Destinatario   Guilherme 114  
				nLin+=1
				@ nLin,025 PSay cEndRem    //-- Endereco Remetente
				@ nLin,135 PSay cEndDes     //--Endereco Destinatario Guilherme 114  
				nLin+=1
				@ nLin,025 PSay AllTrim(cMunRem)   //-- Municipio
				@ nLin,112 PSay cEstRem   //-- Est. Remetente  Guilherme 92		
				@ nLin,135 PSay AllTrim(cMunDes) //--Municipio/Est. Guilherme 114  
				@ nLin,218 PSay cEstDes	//Guilherme 183  			
				nLin+=1
				@ nLin,025 PSay cCGCRem	Picture Iif(LEN(ALLTRIM(cCGCRem))==9, "@R 999.999.999-99", "@R 99.999.999/9999-99")	//-- CGC
				@ nLin,080 PSay cInscRem  //--Inscricao Remetente	 Guilherme 66			
				@ nLin,135 PSay cCGCDes Picture Iif(LEN(ALLTRIM(cCGCDes))==9, "@R 999.999.999-99", "@R 99.999.999/9999-99")	//-- CGC   //Guilherme 114
				@ nLin,180 PSay cInscDes	//--Inscricao Destinatario Guilherme 150  
				
				nLin+=2
				
				//-- Redespacho / Consignatario
				If EMPTY(DT6->DT6_CLICON)
			
					@ nLin,032 PSay cNomDev  //-- Nome Consignatario ou Despachante
					nLin+=1
					@ nLin,025 PSay  cEndDev //-- End. Consignatario ou Despachante
					nLin+=1
					@ nLin,035 PSay AllTrim(cMunDev) //--Municipio
					@ nLin,112 PSay cEstDev //--Est. Consig. ou Despach. Guilherme 92
					nLin+=1
					@ nLin,025 PSay cCGCDev  Picture Iif(LEN(ALLTRIM(cCGCDev))==9, "@R 999.999.999-99", "@R 99.999.999/9999-99")	//-- CGC
					@ nLin,080 PSay cInscDev	//--Inscricao do Consig. ou Despach. Guilherme 66					
				
				Else
				
					@ nLin,025 PSay cNomCONDPC  //-- Nome Consignatario ou Despachante
					nLin+=1
					@ nLin,025 PSay  cEndCONDPC //-- End. Consignatario ou Despachante
					nLin+=1
					@ nLin,025 PSay AllTrim(cMunCONDPC)//--Municipio
					@ nLin,110 PSay cEstCONDPC //--Est. Consig. ou Despach. Guilherme 92
					nLin+=1
					@ nLin,025 PSay cCGCCONDPC	Picture Iif(LEN(ALLTRIM(cCGCCONDPC))==9, "@R 999.999.999-99", "@R 99.999.999/9999-99")	//-- CGC
					@ nLin,080 PSay cInscCONDPC  //--Inscricao do Consig. ou Despach.   Guilherme 66

				EndIf
				
				//-- Destino de Calculo
				nLin += 3 
				@ nLin,033 PSay cDestCalc	//Guilherme
				
				//-- CIF / FOB
				//nLin += 1
				If cTipFrete == "1"
					@ nLin,093 PSay "XX" //Guilherme 76
				Else                    
					@ nLin,100 PSay "XX" // Guilherme 86
				EndIf               
				
				//-- Produto
				SB1->(dbSetOrder(1))
				SB1->(dbSeek(xFilial("SB1")+DTC->DTC_CODPRO))
			
				
				nLin+= 3 
				@ nLin,040 PSAY SubSTR(SB1->B1_DESC,1,28)    //Guilherme 20
				@ nLin,072 PSAY DTC->DTC_QTDVOL 	PICTURE PesqPict("DTC","DTC_QTDVOL")    //Guilherme 56
				@ nLin,086 PSAY DTC->DTC_CODEMB //Guilherme 72
				@ nLin,100 PSAY DTC->DTC_PESO 		PICTURE PesqPict("DTC","DTC_PESO") //Guilherme 82
				@ nLin,124 PSAY DT6->DT6_PESLIQ		PICTURE PesqPict("DT6","DT6_PESLIQ") //Guilherme 100
				@ nLin,135 PSAY DTC->DTC_PESOM3 	PICTURE PesqPict("DTC","DTC_PESOM3") //Guilherme 112
				@ nLin,152 PSAY DTC->DTC_NUMNFC     //Guilherme   128
				@ nLin,180 PSAY DT6->DT6_VALMER 	PICTURE PesqPict("DT6","DT6_VALMER") //Guilherme 150
				@ nLin,213 PSAY TRANSFORM( 0 , "@E 9.99" )   //Guilherme 178
				
				nLin += 3 
				@ nLin,020 PSAY DT6->DT6_QTDVOL 	PICTURE PesqPict("DT6","DT6_QTDVOL") //Guilherme 16
				@ nLin,038 PSAY DT6->DT6_VALFRE 	PICTURE PesqPict("DT6","DT6_VALFRE")				
				@ nLin,075 PSAY TRANSFORM( 0 , "@E 9.99" )  //Guilherme 60
				@ nLin,085 PSAY TRANSFORM( 0 , "@E 9.99" )  //Guilherme 70
				@ nLin,095 PSAY TRANSFORM( 0 , "@E 9.99" ) // VERIFICAR Guilherme 80
				@ nLin,105 PSAY TRANSFORM( 0 , "@E 9.99" ) // VERIFICAR Guilherme 90
				@ nLin,130 PSAY DT6->DT6_VALTOT 	PICTURE PesqPict("DT6","DT6_VALFRE")  //Guilherme 106								
				@ nLin,160 PSAY SF3->F3_BASEICM 	PICTURE PesqPict("SF3","F3_BASEICM")  //Guilherme 134								
				@ nLin,188 PSAY SF3->F3_ALIQICM 	PICTURE PesqPict("SF3","F3_ALIQICM") //Guilherme 158								
				@ nLin,205 PSAY SF3->F3_VALICM 		PICTURE PesqPict("SF3","F3_VALICM") //Guilherme 168								
				
				nLin += 2       
				@ nLin,082 PSAY TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99")    //Guilherme 66
				@ nLin,130 PSAY SM0->M0_CIDCOB   //Guilherme 104
				@ nLin,182 PSAY SM0->M0_ESTCOB	//Guilherme 158			
				cPLACAVEI := POSICIONE("DA3",1,xFilial("DA3")+DTR->DTR_CODVEI,"DA3_PLACA")
				If !EMPTY(DTR->DTR_CODRB1)
					cPLACAVEI += " / " + POSICIONE("DA3",1,xFilial("DA3")+DTR->DTR_CODRB1,"DA3_PLACA")	
				EndIf
				@ nLin,200 PSAY cPLACAVEI //Guilherme 162
				
				nLin += 2              
				@ nLin,035 PSAY POSICIONE("DA4",1,xFilial("DA4")+DUP->DUP_CODMOT,"DA4_NOME") //Guilherme 26
				@ nLin,085 PSAY ALLTRIM(cMunRem)+"/"+cEstRem  //Guilherme 72
				@ nLin,150 PSAY cDestCalc  //Guilherme 				

				//-- Observacoes --//
				RTMSR01Obs(@aObservacoes)
				
				nLin += 3              
				@ nLin,028 PSAY aObservacoes[1] + " " + aObservacoes[2]  //Guilherme 14
				nLin += 1              
				@ nLin,028 PSAY aObservacoes[3] + " " + aObservacoes[4] //Guilherme 14
				nLin += 1              
				@ nLin,028 PSAY aObservacoes[5] + " " + aObservacoes[6] //Guilherme 14								
							
				nLin+= 1 
				@ nLin,010 PSAY chr(17)+chr(18)				
				
				nPAGINA += 1
				
				DT6->(dbSkip())
			EndDo
		Next nCnt
		
		dbSelectArea("DTP")
		dbSkip()
		
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se em disco, desvia para Spool                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If aReturn[5] == 1
		Set Printer To
		dbCommitAll()
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return				

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTmsr01NfC³ Autor ³Robson Alves           ³ Data ³09.10.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Busca as Nf's do Cliente.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ExpA1:=TmsPesoVge(ExpC1,ExpC2)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpN1 = Indice do DTC.                                     ³±±
±±³          ³ ExpB1 = Bloco com a condicao do While.                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±*/
Static Function RTmsr01NFCli(nOrdem, bBloco, cNumNotas, cNumCot, aEnder)

Local aAreaDTC := {}
Local aAreaDUH := {}

//-- Notas Fiscais do Cliente
DTC->(dbSetOrder(nOrdem))
DTC->(MsSeek(xFilial("DTC")+DT6->(DT6_FILDOC+DT6_DOC+DT6_SERIE)))

aAreaDTC  := DTC->(GetArea())
cNumNotas := ""

While Eval(bBloco)
	//-- Enderecamento de Notas Fiscais
	DUH->(dbSetOrder(1))
	DUH->(MsSeek(xFilial("DUH")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM)))
	
	aAreaDUH := DUH->(GetArea())
	DUH->( DbEval( { || IIf(Ascan(aEnder, {|x| x == AllTrim(DUH->DUH_LOCALI)+"/" })== 0,AADD(aEnder,AllTrim(DUH_LOCALI)+"/" ),.T.) },, ;
	{ || DUH_FILIAL+DUH_FILORI+DUH_NUMNFC+DUH_SERNFC+DUH_CLIREM+DUH_LOJREM == ;
	xFilial("DTC")+DTC->(DTC_FILORI+DTC_NUMNFC+DTC_SERNFC+DTC_CLIREM+DTC_LOJREM) } ) )
	RestArea(aAreaDUH)
	
	cNumNotas += "/"+DTC->DTC_NUMNFC
	cNumCot   := DTC->DTC_NUMCOT // Numero da cotacao.
	
	DTC->(dbSkip())
EndDo
RestArea(aAreaDTC)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01DT6³ Autor ³Patricia A. Salomao    ³ Data ³14.02.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica todos os clientes                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR01DT6()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametro ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RTMSR01			                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR01DT6()

Local aAreaDT6  := DT6->(GetArea())		
Local aCliCalc  := {}
Local cImpDev   := ""

//-- Dados do Consignatario                         
cNomCONDPC  := cEndCONDPC := cCEPCONDPC := cMunCONDPC := cEstCONDPC := cCGCCONDPC := cInscCONDPC := ""

cDevFrete := DT6->DT6_DEVFRE
cTipFrete := DT6->DT6_TIPFRE

//-- Dados do Remetente
SA1->(dbSetOrder(1))
SA1->(MsSeek(xFilial()+DT6->DT6_CLIREM+DT6->DT6_LOJREM))
cNomRem  := SA1->A1_NOME
cEndRem  := SA1->A1_END       
cCEPRem  := SA1->A1_CEP
cMunRem  := SA1->A1_MUN
cEstRem  := SA1->A1_EST
cCGCRem  := SA1->A1_CGC
DV3->(dbSetOrder(1))
If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIREM + DTC->DTC_LOJREM + If(DTC->(FieldPos("DTC_SQIREM"))>0,DTC->DTC_SQIREM,'')))
	cInscRem := DV3->DV3_INSCR
Else
	cInscRem := SA1->A1_INSCR
EndIf		
If cDevFrete == "1"
	cInscDev := cInscRem
EndIf

//-- Dados do Destinatario
SA1->(MsSeek(xFilial()+DT6->DT6_CLIDES+DT6->DT6_LOJDES))
cNomDes  := SA1->A1_NOME
cEndDes  := SA1->A1_END
cCEPDes  := SA1->A1_CEP
cMunDes  := SA1->A1_MUN
cEstDes  := SA1->A1_EST
cCGCDes  := SA1->A1_CGC
DV3->(dbSetOrder(1))
If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIDES + DTC->DTC_LOJDES + If(DTC->(FieldPos("DTC_SQIDES"))>0,DTC->DTC_SQIDES,'')))
	cInscDes := DV3->DV3_INSCR
Else
	cInscDes := SA1->A1_INSCR
EndIf		
cEndEnt  := SA1->A1_ENDENT
If cDevFrete == "2"
	cInscDev := cInscDes
EndIf

//-- Dados do Devedor
SA1->(MsSeek(xFilial()+DT6->DT6_CLIDEV+DT6->DT6_LOJDEV))
cNomDev  := SA1->A1_NOME
cEndDev  := SA1->A1_END
cCEPDev  := SA1->A1_CEP
cMunDev  := SA1->A1_MUN
cEstDev  := SA1->A1_EST
cCGCDev  := SA1->A1_CGC

aCliCalc := TmsCliCalc(DT6->DT6_CLIREM,DT6->DT6_LOJREM,DT6->DT6_CLIDES,DT6->DT6_LOJDES)

If Empty( aCliCalc )
	aCliCalc := {DT6->DT6_CLIDEV,DT6->DT6_LOJDEV,"1"}
EndIf

cImpDev := aCliCalc[3]  // Imprime Devedor do Frete ?
                         
//-- Se o Devedor do Frete for o Consignatario ou o Despachante
If cImpDev == StrZero(1, Len(DTI->DTI_IMPDEV)) .And. (cDevFrete  == "3" .Or. cDevFrete  == "4")
    //-- Dados do Consignatario ou Despachante
	If cDevFrete=="4"
		SA1->(MsSeek(xFilial()+DT6->DT6_CLIDPC+DT6->DT6_LOJDPC))
		DV3->(dbSetOrder(1))
		If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLIDPC + DTC->DTC_LOJDPC + If(DTC->(FieldPos("DTC_SQIDPC"))>0,DTC->DTC_SQIDPC,'')))
			cInscCONDPC := DV3->DV3_INSCR
		Else
			cInscCONDPC := SA1->A1_INSCR
		EndIf		
	ElseIf cDevFrete=="3"
		SA1->(MsSeek(xFilial()+DT6->DT6_CLICON+DT6->DT6_LOJCON))
		DV3->(dbSetOrder(1))
		If DV3->(MsSeek(xFilial("DV3") + DTC->DTC_CLICON + DTC->DTC_LOJCON + If(DTC->(FieldPos("DTC_SQICON"))>0,DTC->DTC_SQICON,'')))
			cInscCONDPC := DV3->DV3_INSCR
		Else
			cInscCONDPC := SA1->A1_INSCR
		EndIf		
	EndIf
	cNomCONDPC  := SA1->A1_NOME
	cEndCONDPC  := SA1->A1_END
	cCEPCONDPC  := SA1->A1_CEP
	cMunCONDPC  := SA1->A1_MUN
	cEstCONDPC  := SA1->A1_EST
	cCGCCONDPC  := SA1->A1_CGC
	cInscDev    := cInscCONDPC
EndIf

//-- Destino de Calculo
DUY->(dbSetOrder(1))
If DUY->(MsSeek(xFilial("DUY")+ DT6->DT6_CDRCAL ))
	cDestCalc := ALLTRIM(DUY->DUY_DESCRI)+"/"+DUY->DUY_EST
EndIf	          

RestArea(aAreaDT6)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR03Cab³ Autor ³Rafael Parma           ³ Data ³28.12.2010³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Imprime Cabecalho                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RTMSR01Cabec(ExpN1)                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ RJU      		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RTMSR03Cab(nLin) 

	nLin := 0

    @ nLin, 00 PSay Chr(27) + Chr(15) 
    @ nLin, 00 PSay Chr(27) + Chr(48)
    @ nLin, 00 PSay Chr(27) + Chr(67) + Chr(23)
    If nPAGINA == 1
		nLin+= 1  //Guilherme 2 
	Else
		nLin+= 4  // Guilherme 5
	EndIf
	
	@nLin,148 PSay SF3->F3_CFO //Guilherme 128

	nLin+= 1
	@nLin,115 PSay ALLTRIM(SubSTR(SM0->M0_CIDCOB,1,20))+"-"+SM0->M0_ESTCOB   //Guilherme 98
	@nLin,150 PSay dtoc(DT6->DT6_DATEMI) // Guilherme 128
	
	nLin += 3 // Guilherme 3 	
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RTMSR01Obs³ Autor ³ Robson Alves          ³ Data ³19.11.02  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Obtem as observacoes.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³RTMSR01Obs(ExpA1)                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpA1 = Array para devolver as observacoes.                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³      ³                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function RTMSR01Obs(aObservacoes)

Local cObs     := ""
Local cObs1    := ""
Local cObs2    := ""
Local nI       := 1
Local cSeekSD2 := ""
Local nPercDif := 0

AFill(aObservacoes, Space(40))

/* Obtem a observacao fiscal. */
cObs  := StrTran(MsMM(DT6->DT6_CODMSG,80),Chr(13),"")
cObs  := StrTran(cObs, Chr(10),"")
cObs1 := SubStr(cObs,  1, 40)
cObs2 := SubStr(cObs, 41, 40)
If !Empty(cObs1)
	aObservacoes[nI] := cObs1
	nI += 1
	If !Empty(cObs2)
		aObservacoes[nI] := cObs2
		nI += 1
	EndIf	
	If SF2->(FieldPos("F2_ICMSDIF")) > 0
		SF2->(dbSetOrder(1))
		If SF2->(MsSeek(xFilial("SF2")+DT6->(DT6_DOC+DT6_SERIE+DT6_CLIDEV+DT6_LOJDEV))) .And. SF2->F2_ICMSDIF > 0
			SD2->(dbSetOrder(3))
			SD2->(MsSeek(cSeekSD2 := xFilial("SD2")+DT6->(DT6_DOC+DT6_SERIE+DT6_CLIDEV+DT6_LOJDEV)))
			While SD2->(!Eof()) .And. SD2->(D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA) == cSeekSD2
				SF4->(dbSetOrder(1))
				If SF4->(MsSeek(xFilial("SF4")+SD2->D2_TES)) .And. SF4->F4_PICMDIF > 0
					nPercDif := SF4->F4_PICMDIF
					Exit
				EndIf
				SD2->(dbSkip())
			EndDo
			If nPercDif > 0
				aObservacoes[nI] := "Substituto  " + Transform(nPercDif,"@E 999.99") + "%: " + Transform(SF2->F2_ICMSDIF,"@E 999,999.99")
				nI += 1
				aObservacoes[nI] := "Substituido " + Transform((100 - nPercDif),"@E 999.99") + "%: " + Transform(SF2->(F2_VALICM - F2_ICMSDIF),"@E 999,999.99")
				nI += 1
			EndIf
		EndIf
	EndIf
EndIf

/* Obtem a observacao do conhecimento. */
DUO->(dbSetOrder(1))
If DUO->(MsSeek(xFilial("DUO") + DTC->DTC_CLIREM + DTC->DTC_LOJREM))
	cObs  := StrTran(MsMM(DUO->DUO_CDOCTR,80),Chr(13),"")
	cObs  := StrTran(cObs, Chr(10),"")
	cObs1 := SubStr(cObs,  1, 40)
	cObs2 := SubStr(cObs, 41, 40)
	If !Empty(cObs1)
		aObservacoes[nI] := cObs1
		nI += 1
		If !Empty(cObs2)
			aObservacoes[nI] := cObs2
			nI += 1
		EndIf	
	EndIf
EndIf	

/* Obtem a observacao do cliente. */
cObs  := StrTran(MsMM(DTC->DTC_CODOBS,80),Chr(13),"")
cObs  := StrTran(cObs, Chr(10),"")
cObs1 := SubStr(cObs,  1, 40)
cObs2 := SubStr(cObs, 41, 40)
If !Empty(cObs1)
	aObservacoes[nI] := cObs1
	nI += 1
	If !Empty(cObs2)
		aObservacoes[nI] := cObs2
		nI += 1
	EndIf	
EndIf

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1  ºAutor  ³Rafael Parma       º Data ³  27/12/10   º±±
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


	aAdd(aRegs,{cPerg,"01","Lote Inicial    ?","Lote Inicial    ?","Lote Inicial    ?","mv_ch1","C",TAMSX3("DT6_LOTNFC")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "DTP","","",""})
	aAdd(aRegs,{cPerg,"02","Lote Final      ?","Lote Final      ?","Lote Final      ?","mv_ch2","C",TAMSX3("DT6_LOTNFC")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "DTP","","",""})
	aAdd(aRegs,{cPerg,"03","Documento De    ?","Documento De    ?","Documento De    ?","mv_ch3","C",TAMSX3("DT6_DOC")[1]	  ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Documento Ate   ?","Documento Ate   ?","Documento Ate   ?","mv_ch4","C",TAMSX3("DT6_DOC")[1]	  ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Serie De        ?","Serie De        ?","Serie De        ?","mv_ch5","C",TAMSX3("DT6_SERIE")[1] ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"06","Serie Ate       ?","Serie Ate       ?","Serie Ate       ?","mv_ch6","C",TAMSX3("DT6_SERIE")[1] ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	
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