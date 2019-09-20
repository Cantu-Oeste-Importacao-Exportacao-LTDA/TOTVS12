#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#define PAD_LEFT	0
#define PAD_RIGHT	1
#define PAD_CENTER	2                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJTMSR05   บAutor  ณRafael Parma       บ Data ณ  22/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de dados veํculo/carreta/motorista (SIGATMS).     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJTMSR05()
*-------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPergSX1 := "RJTMSR0005"
Private STRING_NULL := ""  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	AjustaSX1()
	If Pergunte(cPergSX1,.T.)
		RunReport()
	EndIf	
	
Return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ Rafael Parma       บ Data ณ  22/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*----------------------------*
Static Function RunReport()
*----------------------------*
Local cCONTATO   := ALLTRIM(SuperGetMV("MV_X_CNWFC",,"N"))
Local lBold	     := .T.
Local lUnderLine := .T.

Private oFont07B := TFont():New( "Arial",,07,,lBold,,,,,!lUnderLine )
Private oFont08B := TFont():New( "Arial",,08,,lBold,,,,,!lUnderLine )
Private oFont09B := TFont():New( "Arial",,09,,lBold,,,,,!lUnderLine )
Private oFont10B := TFont():New( "Arial",,10,,lBold,,,,,!lUnderLine )
Private oFont11B := TFont():New( "Arial",,11,,lBold,,,,,!lUnderLine )
Private oFont13B := TFont():New( "Arial",,13,,lBold,,,,,!lUnderLine )
Private oFont12B := TFont():New( "Arial",,12,,lBold,,,,,!lUnderLine )
Private oFont14B := TFont():New( "Arial",,14,,lBold,,,,,!lUnderLine )

Private oFont07N := TFont():New( "Arial",,07,,!lBold,,,,,!lUnderLine )
Private oFont08N := TFont():New( "Arial",,08,,!lBold,,,,,!lUnderLine )
Private oFont09N := TFont():New( "Arial",,09,,!lBold,,,,,!lUnderLine )
Private oFont10N := TFont():New( "Arial",,10,,!lBold,,,,,!lUnderLine )
Private oFont11N := TFont():New( "Arial",,11,,!lBold,,,,,!lUnderLine )
Private oFont13N := TFont():New( "Arial",,13,,!lBold,,,,,!lUnderLine )
Private oFont12N := TFont():New( "Arial",,12,,!lBold,,,,,!lUnderLine )
Private oFont14N := TFont():New( "Arial",,14,,!lBold,,,,,!lUnderLine )

Private nLin := 50
Private nCol := 50

	oPrn  := TMSPrinter():New()
	oPen  := TPen():New(,7,CLR_BLACK,oPrn)
 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro dos dados de acordo com os parโmetros.                       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("DTQ")
	dbSetOrder(2)	//DTQ_FILIAL+DTQ_FILORI+DTQ_VIAGEM+DTQ_ROTA
	dbGoTop()
	If dbSeek( xFilial("DTQ") + mv_par01 + mv_par02 )
		
		oPrn:SetPortrait()
		oPrn:Setup()

		While !DTQ->(EOF()) .and. DTQ->DTQ_FILIAL == xFilial("DTQ") .and. DTQ->DTQ_FILORI <= mv_par03 .and. DTQ->DTQ_VIAGEM <= mv_par04
	
			dbSelectArea("DTR") // Veiculos da viagem
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("DTR") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
				
				dbSelectArea("DA3")	// Veiculos
				dbSetOrder(1)
				dbGoTop()
				dbSeek ( xFilial("DA3") + DTR->DTR_CODVEI )
		  
		
				dbSelectArea("DUP")	// Motoristas da Viagem          
				dbSetOrder(1)
				dbGoTop()			
				If dbSeek ( xFilial("DUP") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
						
					dbSelectArea("DA4")
					dbSetOrder(1)
					dbSeek( xFilial("DA4") + DUP->DUP_CODMOT )
					
				
				EndIf
				
				dbSelectArea("DTP")	// Lote de Entrada Notas Fiscais 
				dbSetOrder(3)
				dbGoTop()			
				If dbSeek ( xFilial("DTP") + DTQ->DTQ_FILORI + DTQ->DTQ_VIAGEM )
					
					dbSelectArea("DT6")	// Documentos de Transporte      
					dbSetOrder(2)
					dbGoTop()
					If dbSeek ( xFilial("DT6") + DTP->DTP_FILORI + DTP->DTP_LOTNFC )
					
						dbSelectArea("SA1")	// Cliente Remetente
						dbSetOrder(1)
						dbGoTop()
						dbSeek ( xFilial("SA1") + DT6->DT6_CLIREM + DT6->DT6_LOJREM )
						
						dbSelectArea("DTC")	//Doc Cliente para Transporte   
						dbSetOrder(1)	//DTC_FILIAL+DTC_FILORI+DTC_LOTNFC+DTC_CLIREM+DTC_LOJREM+DTC_CLIDES+DTC_LOJDES+DTC_SERVIC+DTC_CODPRO+DTC_NUMNFC+DTC_SERNFC+DTC_NUMSOL
						dbGoTop()
						dbSeek( xFilial("DTC") + DTP->DTP_FILORI + DTP->DTP_LOTNFC )
										
					EndIf             
				EndIf
			EndIf
					          
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Inicializa nova pagina                                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			oPrn:StartPage()
			nLin := 50
			nCol := 50
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao das bordas                                                ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
			//SUPERIOR
			oPrn:Line( 0030, 0030, 0030, 2300 )
			//SUPERIOR TITULO	
			oPrn:Line( 0150, 0030, 0150, 2300 )
			//ESQUERDO
			oPrn:Line( 0030, 0030, 3200, 0030 )
			//DIREITO
			oPrn:Line( 0030, 2300, 3200, 2300 )
			//INFERIOR
			oPrn:Line( 3200, 0030, 3200, 2300 )
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do nome da empresa                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		    // TITULO
		    oPrn:SayBitmap( nLin, 100, "logo"+cEmpAnt+".bmp", 200, 080 )                    
			oPrn:Say( nLin, 0860, "DADOS VEอCULO / CARRETA / MOTORISTA", oFont11B, 100 )

			nLin += 200
			nCol := 100
			oPrn:Say( nLin, nCol, "DADOS DA EMPRESA", oFont10B, 100 )
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ DADOS DA EMPRESA		                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			dbSelectArea("SM0")
			nLin += 060
			oPrn:Say( nLin, nCol, "Nome/Razใo Social: "+UPPER(ALLTRIM(SM0->M0_NOMECOM)) , oFont09N, 100 )
			
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "CPF/CNPJ: "+TRANSFORM( SM0->M0_CGC, "@R 99.999.999/9999-99" ) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "RG/IE: "+SM0->M0_INSC , oFont09N, 100 )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Municํpio: "+UPPER(ALLTRIM(SM0->M0_CIDCOB)) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "Bairro: "+UPPER(ALLTRIM(SM0->M0_BAIRCOB)) , oFont09N, 100 )
						
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Endere็o: "+UPPER(ALLTRIM(SM0->M0_ENDCOB)) , oFont09N, 100 )
			
			nLin += 060 
			oPrn:Say( nLin, nCol, "CEP: "+ALLTRIM(SM0->M0_CEPCOB) , oFont09N, 100 )			
			
			nLin += 060 			                                                           
			oPrn:Say( nLin, nCol, "Telefone: "+SubSTR(ALLTRIM(SM0->M0_TEL),2,Len(ALLTRIM(SM0->M0_TEL))) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "Fax: "+SubSTR(ALLTRIM(SM0->M0_FAX),2,Len(ALLTRIM(SM0->M0_FAX))) , oFont09N, 100 )

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Contato: "+cCONTATO , oFont09N, 100 )

		
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ DADOS DO VEอCULO		                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
			nLin += 100
			nCol := 100
			oPrn:Say( nLin, nCol, "DADOS DO VEอCULO", oFont10B, 100 )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Placa: "+DA3->DA3_PLACA , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Chassi: "+DA3->DA3_CHASSI , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Renavam: "+DA3->DA3_RENAVA , oFont09N, 100 )
                                                            
		
			dbSelectArea("SX5")	// Marca Veiculo
			dbSetOrder(1)
			dbSeek( xFilial("SX5") + "M6" + DA3->DA3_MARVEI )

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Marca: "+UPPER(ALLTRIM(SX5->X5_DESCRI)) , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Modelo: "+UPPER(ALLTRIM(DA3->DA3_X_MOD)) , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Ano: "+DA3->DA3_ANOMOD +"/"+DA3->DA3_ANOFAB , oFont09N, 100 )

			cCATEGORIA := IIF(DA3->DA3_FROVEI=='1',"PROPRIO",IIF(DA3->DA3_FROVEI=='2',"ALUGUEL","AGREGADO"))

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Cap/Pot/Cil: "+IIF(DA3->DA3_CAPACN!=0,cValToChar(DA3->DA3_CAPACN)+"CV"," ") , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Categoria: "+cCATEGORIA , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Esp้cie: "+UPPER(ALLTRIM(DA3->DA3_X_ESP)) , oFont09N, 100 )

			cCOMBUSTIVEL := IIF(DA3->DA3_X_COM=='1',"DIESEL",IIF(DA3->DA3_X_COM=='2',"GASOLINA",IIF(DA3->DA3_X_COM=='3',"ETANOL","FLEX")))
			dbSelectArea("SX5")	// Cor Veiculo
			dbSetOrder(1)
			dbSeek( xFilial("SX5") + "M7" + DA3->DA3_CORVEI )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Municํpio: "+UPPER(ALLTRIM(DA3->DA3_MUNPLA))+"-"+DA3->DA3_ESTPLA , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Combustํvel: "+cCOMBUSTIVEL , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Cor: "+UPPER(ALLTRIM(SX5->X5_DESCRI)) , oFont09N, 100 )
		
                                                         
			CSIMRT := " "	// Veiculo Rastreado = SIM
			CNAORT := " "	// Veiculo Rastreado = NAO
			
			// Veiculo Rastreado
			If DA3->DA3_VEIRAS == "1"
				CSIMRT := "X"
			Else
				CNAORT := "X"
			EndIf	
			             
		   
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ DADOS DA CARRETA		                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

			nLin += 100
			nCol := 100
			oPrn:Say( nLin, nCol, "DADOS DA CARRETA", oFont10B, 100 )

			dbSelectArea("DA3")	// Localiza carreta da estrutura do bem
			dbSetOrder(5) 	//DA3_FILIAL+DA3_CODBEM+DA3_COD
			dbGoTop()
			dbSeek( xFilial("DA3") + DTR->DTR_CODRB1 )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Placa: "+DA3->DA3_PLACA , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Chassi: "+DA3->DA3_CHASSI , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Renavam: "+DA3->DA3_RENAVA , oFont09N, 100 )
                                                            
		
			dbSelectArea("SX5")	// Marca Veiculo
			dbSetOrder(1)
			dbSeek( xFilial("SX5") + "M6" + DA3->DA3_MARVEI )

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Marca: "+UPPER(ALLTRIM(SX5->X5_DESCRI)) , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Modelo: "+UPPER(ALLTRIM(DA3->DA3_X_MOD)) , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Ano: "+DA3->DA3_ANOMOD +"/"+DA3->DA3_ANOFAB , oFont09N, 100 )

			cCATEGORIA := IIF(DA3->DA3_FROVEI=='1',"PROPRIO",IIF(DA3->DA3_FROVEI=='2',"ALUGUEL","AGREGADO"))
			dbSelectArea("SX5")	// Cor Veiculo
			dbSetOrder(1)
			dbSeek( xFilial("SX5") + "M7" + DA3->DA3_CORVEI )			

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Cap/Pot/Cil: "+IIF(DA3->DA3_CAPACN!=0,cValToChar(DA3->DA3_CAPACN)," ") , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Categoria: "+cCATEGORIA , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Cor: "+UPPER(ALLTRIM(SX5->X5_DESCRI)) , oFont09N, 100 )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Municํpio: "+UPPER(ALLTRIM(DA3->DA3_MUNPLA))+"-"+DA3->DA3_ESTPLA , oFont09N, 100 )
			nCol := 800                                                  
			oPrn:Say( nLin, nCol, "Esp้cie: "+UPPER(ALLTRIM(DA3->DA3_X_ESP)) , oFont09N, 100 )


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ DADOS DO MOTORISTA		                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			nLin += 100
			nCol := 100
			oPrn:Say( nLin, nCol, "DADOS DO MOTORISTA", oFont10B, 100 )
			
			nCol := 100                                                  
			nLin += 060  
			oPrn:Say( nLin, nCol, "Nome: "+UPPER(ALLTRIM(DA4->DA4_NOME)) , oFont09N, 100 )

			nLin += 060  
			oPrn:Say( nLin, nCol, "CPF: "+TRANSFORM( DA4->DA4_CGC, "@R 999.999.999-99" ) , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Data Emissใo: "+DTOC(DA4->DA4_X_DCPF) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "RG: "+ALLTRIM(DA4->DA4_RG) , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Data Emissใo: "+DTOC(DA4->DA4_RGDT) , oFont09N, 100 )
			
			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Data Nascimento: "+DTOC(DA4->DA4_DATNAS) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "CNH: "+ALLTRIM(DA4->DA4_NUMCNH) , oFont09N, 100 )
			nCol := 600                                                  
			oPrn:Say( nLin, nCol, "N.Registro: "+ALLTRIM(DA4->DA4_REGCNH) , oFont09N, 100 )
			nCol := 1100                                                  
			oPrn:Say( nLin, nCol, "Vencto: "+DTOC(DA4->DA4_DTVCNH) , oFont09N, 100 )
			nCol := 1600                                                  
			oPrn:Say( nLin, nCol, "Categoria: "+ALLTRIM(DA4->DA4_CATCNH) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Pancary: "+ALLTRIM(DA4->DA4_X_PANC) , oFont09N, 100 )
			nCol := 700                                                  
			oPrn:Say( nLin, nCol, "Vencto: "+DTOC(DA4->DA4_X_VPAN) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Nome Pai: "+UPPER(ALLTRIM(DA4->DA4_PAI)) , oFont09N, 100 )

			nLin += 060  
			oPrn:Say( nLin, nCol, "Nome Mใe: "+UPPER(ALLTRIM(DA4->DA4_MAE)) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Municํpio: "+UPPER(ALLTRIM(DA4->DA4_MUN)) , oFont09N, 100 )
			nCol := 700                                                  
			oPrn:Say( nLin, nCol, "Bairro: "+UPPER(ALLTRIM(DA4->DA4_BAIRRO)) , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Endere็o: "+UPPER(ALLTRIM(DA4->DA4_END)) , oFont09N, 100 )

			nLin += 060  
			oPrn:Say( nLin, nCol, "CEP: "+DA4->DA4_CEP , oFont09N, 100 )

			nLin += 060  
			oPrn:Say( nLin, nCol, "Telefone: "+DA4->DA4_TEL , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Contato 1: "+ALLTRIM(DA4->DA4_X_CON1) , oFont09N, 100 )
			nCol := 700                                                  
			oPrn:Say( nLin, nCol, "Telefone: "+DA4->DA4_X_TEL1 , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Contato 2: "+ALLTRIM(DA4->DA4_X_CON2) , oFont09N, 100 )
			nCol := 700                                                  
			oPrn:Say( nLin, nCol, "Telefone: "+DA4->DA4_X_TEL2 , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Contato 3: "+ALLTRIM(DA4->DA4_X_CON3) , oFont09N, 100 )
			nCol := 700                                                  
			oPrn:Say( nLin, nCol, "Telefone: "+DA4->DA4_X_TEL3 , oFont09N, 100 )

			CSIMVR := " "	// Vitima de roubo = SIM
			CNAOVR := " " 	// Vitima de roubo = NAO
			CQTDVR := " " 	// Vitima de roubo = N VEZES
			CSIMAC := " " 	// Envolvido em acidente = SIM
			CNAOAC := " " 	// Envolvido em acidente = NAO
			CQTDAC := " " 	// Envolvido em acidente = N VEZES
			
			// Vitima de roubo
			If DA4->DA4_X_VROU == "S"
				CSIMVR := "X"
			Else
				CNAOVR := "X"
			EndIf
			If DA4->DA4_X_NROU != 0
				CQTDVR := cValToChar(DA4->DA4_X_NROU)
			EndIf
			
			// Envolvido em acidente
			If DA4->DA4_X_ACID == "S"
				CSIMAC := "X"
			Else
				CNAOAC := "X"
			EndIf
			If DA4->DA4_X_NACI != 0
				CQTDAC := cValToChar(DA4->DA4_X_NACI)
			EndIf	
			         
			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Jแ foi vํtima de roubo:  Sim ("+CSIMVR+") / Nใo ("+CNAOVR+")" , oFont09N, 100 )
			nCol := 900                                                  
			oPrn:Say( nLin, nCol, "Quantas Vezes: "+CQTDVR , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Jแ se envolveu em acidentes:  Sim ("+CSIMAC+") / Nใo ("+CNAOAC+")" , oFont09N, 100 )
			nCol := 900                                                  
			oPrn:Say( nLin, nCol, "Quantas Vezes: "+CNAOAC , oFont09N, 100 )

			nCol := 100
			nLin += 060  
			oPrn:Say( nLin, nCol, "Veํculo possuํ rastreador:  Sim ("+CSIMRT+") / Nใo ("+CNAORT+")" , oFont09N, 100 )
			
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ DADOS DO PROPRIETมRIO 	                                     ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 
			
			nLin += 100
			nCol := 100
			oPrn:Say( nLin, nCol, "DADOS DO PROPRIETมRIO", oFont10B, 100 )
			
			dbSelectArea("SM0")
			dbSetOrder(1)
			dbSeek("5001")	// C๓digo Empresa/Filial Matriz
			
			nLin += 060
			oPrn:Say( nLin, nCol, "Nome/Razใo Social: "+UPPER(ALLTRIM(SM0->M0_NOMECOM)) , oFont09N, 100 )
			
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "CPF/CNPJ: "+TRANSFORM( SM0->M0_CGC, "@R 99.999.999/9999-99" ) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "RG/IE: "+SM0->M0_INSC , oFont09N, 100 )
			
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Municํpio: "+UPPER(ALLTRIM(SM0->M0_CIDCOB)) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "Bairro: "+UPPER(ALLTRIM(SM0->M0_BAIRCOB)) , oFont09N, 100 )
						
			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Endere็o: "+UPPER(ALLTRIM(SM0->M0_ENDCOB)) , oFont09N, 100 )
			
			nLin += 060 
			oPrn:Say( nLin, nCol, "CEP: "+ALLTRIM(SM0->M0_CEPCOB) , oFont09N, 100 )			
			
			nLin += 060 			                                                           
			oPrn:Say( nLin, nCol, "Telefone: "+SubSTR(ALLTRIM(SM0->M0_TEL),2,Len(ALLTRIM(SM0->M0_TEL))) , oFont09N, 100 )
			nCol := 1000                                                                                          
			oPrn:Say( nLin, nCol, "Fax: "+SubSTR(ALLTRIM(SM0->M0_FAX),2,Len(ALLTRIM(SM0->M0_FAX))) , oFont09N, 100 )

			nCol := 100                                                  
			nLin += 060                                                                                                                                                                                                         
			oPrn:Say( nLin, nCol, "Contato: "+cCONTATO , oFont09N, 100 )

			
			oPrn:EndPage() 
		
			DTQ->(dbSkip())
		Enddo
		
		oPrn:Preview()
	
	Else		
		MsgInfo("Nใo existem dados para impressใo do relat๓rio com os parโmetros informados, verifique!")				
	EndIf

		

	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  22/03/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	aAdd(aRegs,{cPergSX1,"01","Fil.Origem De       ?","Fil.Origem De       ?","Fil.Origem De       ?","mv_ch1","C",TAMSX3("DTQ_FILORI")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "DL5","","",""})
	aAdd(aRegs,{cPergSX1,"02","Viagem De           ?","Viagem De           ?","Viagem De           ?","mv_ch2","C",TAMSX3("DTQ_VIAGEM")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"03","Fil.Origem At้      ?","Fil.Origem At้      ?","Fil.Origem At้      ?","mv_ch3","C",TAMSX3("DTQ_FILORI")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "DL5","","",""})
	aAdd(aRegs,{cPergSX1,"04","Viagem At้          ?","Viagem At้          ?","Viagem At้          ?","mv_ch4","C",TAMSX3("DTQ_VIAGEM")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPergSX1 + aRegs[i,2])
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
