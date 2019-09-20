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
ฑฑบPrograma  ณRJFINR01   บAutor  ณRafael Parma       บ Data ณ  17/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo do documento de autoriza็ใo de pagamento ao banco.บฑฑ
ฑฑบ          ณReferente ao pagamento de importa็๕es.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*-------------------------*
User Function RJFINR01()
*-------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Private cPergSX1 := "RJFINR0001"
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
ฑฑบFuno    ณRUNREPORT บ Autor ณ Rafael Parma       บ Data ณ  17/11/2010 บฑฑ
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
Local aDADOSIMP := {}	// Dados impressใo
Local nVALTOT := 0                 
Local cLogo   := "logo" + cEmpAnt + ".bmp"
Local lBold	     := .T.
Local lUnderLine := .T.

Private oFont07B := TFont():New( "Arial",,07,,lBold,,,,,!lUnderLine )
Private oFont08B := TFont():New( "Arial",,08,,lBold,,,,,!lUnderLine )
Private oFont09B := TFont():New( "Arial",,09,,lBold,,,,,!lUnderLine )
Private oFont10B := TFont():New( "Arial",,10,,lBold,,,,,!lUnderLine )
Private oFont11B := TFont():New( "Arial",,11,,lBold,,,,,!lUnderLine )
Private oFont12B := TFont():New( "Arial",,12,,lBold,,,,,!lUnderLine )
Private oFont13B := TFont():New( "Arial",,13,,lBold,,,,,!lUnderLine )
Private oFont14B := TFont():New( "Arial",,14,,lBold,,,,,!lUnderLine )
Private oFont15B := TFont():New( "Arial",,15,,lBold,,,,,!lUnderLine )
Private oFont16B := TFont():New( "Arial",,16,,lBold,,,,,!lUnderLine )
Private oFont17B := TFont():New( "Arial",,17,,lBold,,,,,!lUnderLine )
Private oFont18B := TFont():New( "Arial",,18,,lBold,,,,,!lUnderLine )
Private oFont19B := TFont():New( "Arial",,19,,lBold,,,,,!lUnderLine )
Private oFont20B := TFont():New( "Arial",,20,,lBold,,,,,!lUnderLine )

Private oFont07N := TFont():New( "Arial",,07,,!lBold,,,,,!lUnderLine )
Private oFont08N := TFont():New( "Arial",,08,,!lBold,,,,,!lUnderLine )
Private oFont09N := TFont():New( "Arial",,09,,!lBold,,,,,!lUnderLine )
Private oFont10N := TFont():New( "Arial",,10,,!lBold,,,,,!lUnderLine )
Private oFont11N := TFont():New( "Arial",,11,,!lBold,,,,,!lUnderLine )
Private oFont12N := TFont():New( "Arial",,12,,!lBold,,,,,!lUnderLine )
Private oFont13N := TFont():New( "Arial",,13,,!lBold,,,,,!lUnderLine )
Private oFont14N := TFont():New( "Arial",,14,,!lBold,,,,,!lUnderLine )
Private oFont15N := TFont():New( "Arial",,15,,!lBold,,,,,!lUnderLine )
Private oFont16N := TFont():New( "Arial",,16,,!lBold,,,,,!lUnderLine )
Private oFont17N := TFont():New( "Arial",,17,,!lBold,,,,,!lUnderLine )
Private oFont18N := TFont():New( "Arial",,18,,!lBold,,,,,!lUnderLine )
Private oFont19N := TFont():New( "Arial",,19,,!lBold,,,,,!lUnderLine )
Private oFont20N := TFont():New( "Arial",,20,,!lBold,,,,,!lUnderLine )

Private nLin := 9999
Private nCol := 0

	cMODANT := IIF(mv_par08==1,"X"," ")
	cMODAVI := IIF(mv_par08==2,"X"," ")
	cMODAPR := IIF(mv_par08==3,"X"," ")
	cMODCOB := IIF(mv_par08==4,"X"," ")
	
	cCOMSIM := IIF(mv_par09==1,"X"," ")
	cCOMNAO := IIF(mv_par09==2,"X"," ")
			
	fSelSE2(@aDADOSIMP,@nVALTOT)

	oPrn  := TMSPrinter():New()
   //oPen  := TPen():New(,7,CLR_BLACK,oPrn)
	
   //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
   //ณ Impressao do relatorio. . .                                         ณ
   //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If Len(aDADOSIMP) > 0

		oPrn:SetPortrait()
		oPrn:Setup()
		nPAGINA := 1

		ProcRegua(Len(aDADOSIMP))


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Inicializa nova pagina                                              ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If nLin > 3000
			oPrn:StartPage()
			nLin := 50
			nCol := 50
		EndIf
		
		dbSelectArea("SA2")
		dbSetOrder(1)
		dbSeek ( xFilial("SA2") + aDADOSIMP[01][06] + aDADOSIMP[01][07] )
		If Empty(SA2->A2_X_BENEF)
			MsgAlert("Nome do beneficiแrio nใo preenchido no cadastro do fornecedor!")
		EndIf
		If Empty(SA2->A2_X_INFPG)
			MsgAlert("Informa็๕es para pagamento nใo preenchidas no cadastro do fornecedor!")
		EndIf
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao das bordas                                                ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
		//SUPERIOR
		oPrn:Line( 0030, 0030, 0030, 2300 )
		//INFERIOR TITULO	
		oPrn:Line( 0200, 0030, 0200, 2300 )		
		//ESQUERDO
		oPrn:Line( 0030, 0030, 3100, 0030 )
		//DIREITO
		oPrn:Line( 0030, 2300, 3100, 2300 )
		//INFERIOR
		oPrn:Line( 3100, 0030, 3100, 2300 )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao do nome da empresa/cnpj                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		nLin := 070		
		nCol := 080
		oPrn:Say( nLin, nCol, UPPER(SM0->M0_NOMECOM), oFont15B, 100 )                                  
		oPrn:SayBitmap( nLin,1900, cLogo, 200, 117)
		nLin += 060
		oPrn:Say( nLin, nCol, "CNPJ: " + TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont15B, 100 )                                  
		nLin += 150
	
		
		oPrn:Say( nLin, nCol, "Moeda: "+ALLTRIM(GETMV("MV_MOEDA"+AllTrim(mv_par07))),	oFont13B, 100 )                                  
		nCol += 500
		oPrn:Say( nLin, nCol, "Valor: " + TRANSFORM(nVALTOT, "@E 999,999,999.99"),	oFont13B, 100 )                                  
		
		nCol := 80
		nLin += 80
		oPrn:Say( nLin, nCol, "Modalidade da opera็ใo: ("+cMODANT+")Antecipado  ("+cMODAVI+")ภ Vista  ("+cMODAPR+")A Prazo  ("+cMODCOB+")Cobran็a",	oFont12B, 100 )                                  
		nCol := 80
		nLin += 110
		
		oPrn:Say( nLin, nCol, "Documentos: ",	oFont14B, 100 )

		nCol := 80		
		nLin += 110
		nLIQRD := nLin
		oPrn:Line( nLin, nCol, nLin, 2220 )
		nLin += 050
		nCol := 100
		
		oPrn:Say( nLin, nCol, "NR. DI",		oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "FATURA",		oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "NR. BL",		oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "AIR/IMPORT",	oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "MIC/CRT",	oFont12B, 100 )
		nCol += 360                                    
		oPrn:Say( nLin, nCol, "VALOR",		oFont12B, 100 )
		nLin += 050
		nCol := 80
		oPrn:Line( nLin, nCol, nLin, 2220 )

		For nI := 1 to Len(aDADOSIMP)

			nLin += 050
			nCol := 100			
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][11]),aDADOSIMP[nI][11],SPACE(04)+"---"),	oFont11N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][12]),aDADOSIMP[nI][12],SPACE(04)+"---"),	oFont11N, 100 )
			nCol += 360                                   
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][13]),aDADOSIMP[nI][13],SPACE(04)+"---"),	oFont11N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][14]),aDADOSIMP[nI][14],SPACE(04)+"---"),	oFont11N, 100 )
			nCol += 360                                    
			oPrn:Say( nLin, nCol, IIF(!EMPTY(aDADOSIMP[nI][15]),aDADOSIMP[nI][15],SPACE(04)+"---"),	oFont11N, 100 )
			nCol += 630                                    
			oPrn:Say( nLin, nCol, TRANSFORM(aDADOSIMP[nI][01] + aDADOSIMP[nI][18] - aDADOSIMP[nI][17],"@E 999,999,999.99"), oFont11N, 100,,, PAD_RIGHT )	
			nLin += 050
			nCol := 80
			oPrn:Line( nLin, nCol, nLin, 2220 )
			
		Next nI
		
		nCol := 080
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 365
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		nCol += 355
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
								
		oPrn:Line( nLIQRD, 2220, nLin, 2220 )

		nCol := 80
		nLin += 110
		
		oPrn:Say( nLin, nCol, "Dados para pagamento: ",	oFont14B, 100 )

		nCol := 80		
		nLin += 110
		nLIQRD := nLin
		oPrn:Line( nLin, nCol, nLin, 2220 )
		nLin += 050
		nCol := 100                                                    
		oPrn:Say( nLin, nCol, "Beneficiแrio: "+ALLTRIM(SA2->A2_X_BENEF), oFont15B, 100 )
		nCol := 100                                                    
		nLin += 050
		
		cMemo := SA2->A2_X_INFPG
		nMemCount := MlCount( cMemo, 180 ) 
		If nMemCount > 0		
			For nLoop := 1 To nMemCount                
				nLin += 050
				cLinha := MemoLine( cMemo, 180, nLoop ) 			
				oPrn:Say( nLin, nCol, cLinha, oFont12B, 100 )
			Next nLoop 
		EndIf
		
		nCol := 80
		nLin += 100
		oPrn:Line( nLin, nCol, nLin, 2220 )
		oPrn:Line( nLIQRD, nCol, nLin, nCol )
		oPrn:Line( nLIQRD, 2220, nLin, 2220 )
		
		nCol := 80
		nLin += 70
		oPrn:Say( nLin, nCol, "Comissใo de agente: ("+cCOMSIM+")Sim  ("+cCOMNAO+")Nใo",	oFont12B, 100 )                                  
		
		nCol := 80
		nLin += 70
		cDATAPAG := IIF(Empty(mv_par14),"___/___/______",dtoc(mv_par14))
		oPrn:Say( nLin, nCol, "Autorizamos o d้bito da ag๊ncia "+ iif(Empty(mv_par11), Space(15), AllTrim(mv_par11)) +" conta "+;
							IIf(Empty(mv_par12), Space(30), AllTrim(mv_par12))+", "+cDATAPAG+" referente a importa็ใo acima.",	oFont12B, 100 )


		nCol := 1400
		nLin += 200
		oPrn:Say( nLin, nCol, "______________________________",	oFont12B, 100 )		
		nLin += 070                                                                         
		nCol := 1440
		oPrn:Say( nLin, nCol, ALLTRIM(mv_par13),	oFont12B, 100 )		
		nLin += 050                                                                         
		oPrn:Say( nLin, nCol, "Gerente Financeiro(a)",	oFont12B, 100 )		

		//oPrn:Preview()
		oPrn:Print()
		
	EndIf

	
Return  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSelSE2     บAutor  ณRafael Parma      บ Data ณ  17/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para sele็ใo de registros.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------------------------*
Static Function fSelSE2(aDADOSIMP,nVALTOT)
*--------------------------------------------*
Local cAliasTMP   := GetNextAlias()

PRIVATE aHeader   := {}    
PRIVATE aCols     := {} 
PRIVATE cDlgTitle := "Sele็ใo de Tํtulos"
PRIVATE aCampos   := {}
PRIVATE cMarca    := GetMark()
PRIVATE lInverte  := .f.
PRIVATE oDlgMULTI     
PRIVATE oDlgSEL
PRIVATE oGETVAL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Filtro sobre titulos                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cQuery := " SELECT								 											   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_OK,																   						" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_EMISSAO,															 			  		" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_VENCTO,																		   		" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PREFIXO,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NUM,																   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PARCELA,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_TIPO,															   	   				 	" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FORNECE,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_LOJA,															   						" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NOMFOR,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_VALOR,															   						" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_SALDO,															   						" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_ACRESC,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_DECRESC,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMDI,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMFT,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_NUMBL,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_AIRIM,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_X_MICRT															   					" + CHR(13)+CHR(10)	
	cQuery += " FROM " + RetSQLName("SE2") + " SE2												   				" + CHR(13)+CHR(10)	
	cQuery += " WHERE 														   					   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FILIAL  = '" + xFilial("SE2") + "'								   					" + CHR(13)+CHR(10)
	cQuery += " AND		SE2.E2_FORNECE = '" +  mv_par01 + "' 									   				" + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_LOJA    = '" +  mv_par02 + "' 									   				" + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_EMISSAO BETWEEN '" +  dtos(mv_par03) + "' AND '"+ dtos(mv_par04) +"'		" + CHR(13)+CHR(10)	
	cQuery += " AND		SE2.E2_VENCTO  BETWEEN '" +  dtos(mv_par05) + "' AND '"+ dtos(mv_par06) +"'		" + CHR(13)+CHR(10)	
	cQuery += " AND 	SE2.E2_SALDO   > 0  														   					" + CHR(13)+CHR(10)	
	cQuery += " AND  	SUBSTR(SE2.E2_TIPO,3,1) != '-'  										   					" + CHR(13)+CHR(10)	
	cQuery += " AND 	SE2.D_E_L_E_T_ != '*' 													   					" + CHR(13)+CHR(10)	
	cQuery += " ORDER BY 													   					   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_EMISSAO,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PREFIXO,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_NUM,																   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_PARCELA,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_TIPO,															   						" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_FORNECE,															   					" + CHR(13)+CHR(10)
	cQuery += " 		SE2.E2_LOJA																   					" + CHR(13)+CHR(10)
	
	TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)

	dbSelectArea("SE2")
	aStruct := dbStruct()

	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,"TMPSE2", .F.,.F. )
	dbSelectArea("TMPSE2")
	Index on E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA to &cArqTrab

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza temporarios                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู


	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While !(cAliasTMP)->(EOF())
	    dbSelectArea("TMPSE2")
	    RecLock("TMPSE2",.T.)
	    For xI := 1 To Len(aStruct)
	       If ALLTRIM(aStruct[xI,1]) $ "E2_OK|E2_EMISSAO|E2_VENCTO|E2_PREFIXO|E2_NUM|E2_PARCELA|E2_TIPO|E2_FORNECE|E2_LOJA|E2_NOMFOR|E2_VALOR|E2_SALDO|E2_DECRESC|E2_ACRESC|E2_X_NUMDI|E2_X_NUMFT|E2_X_NUMBL|E2_X_AIRIM|E2_X_MICRT"
		       _nPosic := FieldPos(aStruct[xI,1])
		       _cCampo := cAliasTMP+"->"+aStruct[xI,1]
		       _cDados := &_cCampo
	    	   If aStruct[xI,2] == "D"               
		    	   TMPSE2->(FieldPut(_nPosic,stod(_cDados)))
		       Else
			       TMPSE2->(FieldPut(_nPosic,_cDados))
			   Endif
			EndIf
	    Next xI
	    TMPSE2->E2_OK := "  "
	    
	    TMPSE2->(MsUnLock())
		(cAliasTMP)->(dbSkip())
	Enddo             
	(cAliasTMP)->(dbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos para mostrar no BROWSE padrao                      ณ
	//ณ Necessario quando usando um arquivo qualquer (sem o SX3)  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aCampos := {}
	AADD(aCampos,{"E2_OK"     ,"" ," "            ," " })
	AADD(aCampos,{"E2_PREFIXO","" ,"Prefixo"      ," " })
	AADD(aCampos,{"E2_NUM"    ,"" ,"Numero"       ," " })
	AADD(aCampos,{"E2_PARCELA","" ,"Parcela"      ," " })
	AADD(aCampos,{"E2_TIPO"   ,"" ,"Tipo"         ," " })
	AADD(aCampos,{"E2_VALOR"  ,"" ,"Valor"        ,"@E 999,999,999.99" })
	AADD(aCampos,{"E2_SALDO"  ,"" ,"Saldo"        ,"@E 999,999,999.99" })
	AADD(aCampos,{"E2_FORNECE","" ,"Fornecedor"   ," " })
	AADD(aCampos,{"E2_LOJA"   ,"" ,"Loja"         ," " })
	AADD(aCampos,{"E2_NOMFOR" ,"" ,"Nome"		  ," " })
	AADD(aCampos,{"E2_EMISSAO","" ,"Emissใo"      ," " })
	AADD(aCampos,{"E2_VENCTO" ,"" ,"Vencimento"   ," " })
	AADD(aCampos,{"E2_ACRESC" ,"" ,"Acrecimo"     ," " })
	AADD(aCampos,{"E2_DECRESC","" ,"Decrecimo"    ," " })
	AADD(aCampos,{"E2_X_NUMDI","" ,"Nr. DI"  	  ," " })
	AADD(aCampos,{"E2_X_NUMFT","" ,"Fatura"		  ," " })
	AADD(aCampos,{"E2_X_NUMBL","" ,"Nr. BL"		  ," " })
	AADD(aCampos,{"E2_X_AIRIM","" ,"Nr.AIR/Import"," " })
	AADD(aCampos,{"E2_X_MICRT","" ,"Nr. MIC/CRT"  ," " })


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria dialogo para usuario selecionar os titulos filtrados no arquivo ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("TMPSE2")
	dbGoTop()

	DEFINE MSDIALOG oDlgSEL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL

	oMark := MsSelect():New("TMPSE2","E2_OK",,aCampos,@lInverte,@cMarca,{1,1,170,350})

	@ 180,310 BMPBUTTON TYPE 1 ACTION Close(oDlgSEL) 

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(cMarca,oDlgSEL)}

	ACTIVATE MSDIALOG oDlgSEL CENTERED

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Adiciona ao array os titulos selecionados                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

    dbSelectArea("TMPSE2")
    dbGoTop()
    While !TMPSE2->(EOF())
    	If !Empty(TMPSE2->E2_OK)
			aAdd ( aCols, {	TMPSE2->E2_SALDO	,;
							TMPSE2->E2_NUM		,;
							TMPSE2->E2_PREFIXO	,;
							TMPSE2->E2_PARCELA	,;
							TMPSE2->E2_TIPO		,;
							TMPSE2->E2_FORNECE	,;
							TMPSE2->E2_LOJA		,;
							TMPSE2->E2_NOMFOR	,;
							TMPSE2->E2_EMISSAO	,;
							TMPSE2->E2_VENCTO	,;
							TMPSE2->E2_X_NUMDI	,;
							TMPSE2->E2_X_NUMFT	,;
							TMPSE2->E2_X_NUMBL	,;
							TMPSE2->E2_X_AIRIM	,;
							TMPSE2->E2_X_MICRT	,;
							.F.,;
							TMPSE2->E2_DECRESC   ,;
							TMPSE2->E2_ACRESC} )
			nVALTOT += TMPSE2->E2_SALDO - TMPSE2->E2_DECRESC + TMPSE2->E2_ACRESC
    	EndIf
    	TMPSE2->(dbSkip())
    Enddo

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha alias temporarios                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("TMPSE2")
	dbCloseArea("TMPSE2")
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*") 
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta janela com titulos selecionados para edicao de valores  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
    // propriedades das colunas
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("E2_NOMFOR")
	cUSADO := SX3->X3_USADO
	dbSeek("E2_SALDO")
	AADD(aHeader,{ TRIM("Valor")		, x3_campo, x3_picture, x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	dbSeek("E2_NOMFOR")                                                                                         
	AADD(aHeader,{ TRIM("N๚mero")		, x3_campo, x3_picture, TAMSX3("E2_NUM")[1]		, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Prefixo")		, x3_campo, x3_picture, TAMSX3("E2_PREFIXO")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Parcela")		, x3_campo, x3_picture, TAMSX3("E2_PARCELA")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Tipo")			, x3_campo, x3_picture, TAMSX3("E2_TIPO")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Fornecedor")	, x3_campo, x3_picture, TAMSX3("E2_FORNECE")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Loja")			, x3_campo, x3_picture, TAMSX3("E2_LOJA")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Nome")			, x3_campo, x3_picture, TAMSX3("E2_NOMFOR")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("Emissใo")		, x3_campo, x3_picture, TAMSX3("E2_EMISSAO")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("Vencimento")	, x3_campo, x3_picture, TAMSX3("E2_VENCTO")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("Nr. DI")		, x3_campo, x3_picture, TAMSX3("E2_X_NUMDI")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("Nr. Fatura")	, x3_campo, x3_picture, TAMSX3("E2_X_NUMFT")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("Nr. BL")		, x3_campo, x3_picture, TAMSX3("E2_X_NUMBL")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("AIR/Import")	, x3_campo, x3_picture, TAMSX3("E2_X_AIRIM")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )
	AADD(aHeader,{ TRIM("MIC/CRT")		, x3_campo, x3_picture, TAMSX3("E2_X_MICRT")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )


	If Len(aCols) > 0

		@ 001,001 TO 400,700 DIALOG oDlgMULTI TITLE cDlgTitle 
		@ 005,005 TO 170,345 MULTILINE MODIFY VALID fSUMLINE(@nVALTOT,oGETVAL,aCols) 
		@ 181,005 SAY "Valor Total: " SIZE 040,010 OF oDlgMULTI PIXEL 
		@ 180,050 GET oGETVAL VAR nVALTOT SIZE 050,010 PICTURE "@E 999,999,999.99" OF oDlgMULTI PIXEL WHEN .F.		
		@ 180,310 BMPBUTTON TYPE 1 ACTION Close(oDlgMULTI) 
		ACTIVATE DIALOG oDlgMULTI CENTERED

	Else
		MsgAlert("Nใo foram selecionados tํtulos para impressใo!")
		Return
	EndIf
	
	aDADOSIMP := aCols

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkAll    บAutor  ณRafael Parma      บ Data ณ  17/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo auxiliar para marca็ใo de registros.                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------------*
Static Function fMarkAll(cMarca,oDlg)
*-------------------------------------*
Local nRecno:= RecNO()

	dbGotop()
	Do While !EOF()
		RecLock("TMPSE2",.F.)
		If Empty(TMPSE2->E2_OK)
			Replace TMPSE2->E2_OK With cMarca
		Else
			Replace TMPSE2->E2_OK With "  "
		Endif
		MsUnlock()
		dbSkip()
	EndDo
	dbGoto(nRecno)
	oDlg:Refresh()

Return .T.  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSUMLINE    บAutor  ณRafael Parma      บ Data ณ  17/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza็ใo do totalizador sobre valor dos tํtulos.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------------------*
Static Function fSUMLINE(nVALTOT,oGETVAL,aCols)
*------------------------------------------------*
	
	nVALTOT := 0
	For nI := 1 to Len(aCols)
		nVALTOT += aCols[nI][01] - aCols[nI][18] + aCols[nI][17] 
	Next nI 
	oGETVAL:Refresh()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  17/11/10   บฑฑ
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

	aAdd(aRegs,{cPergSX1,"01","C๓digo Fornecedor   ?","C๓digo Fornecedor   ?","C๓digo Fornecedor   ?","mv_ch1","C",TamSX3("A2_COD")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","001",""})
	aAdd(aRegs,{cPergSX1,"02","Loja Fornecedor     ?","Loja Fornecedor     ?","Loja Fornecedor     ?","mv_ch2","C",TamSX3("A2_LOJA")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"03","Data Emissใo De     ?","Data Emissใo De     ?","Data Emissใo De     ?","mv_ch3","D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"04","Data Emissใo At้    ?","Data Emissใo At้    ?","Data Emissใo At้    ?","mv_ch4","D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"05","Data Vencimento De  ?","Data Vencimento De  ?","Data Vencimento De  ?","mv_ch5","D",08,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"06","Data Vencimento At้ ?","Data Vencimento At้ ?","Data Vencimento At้ ?","mv_ch6","D",08,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"07","Imprimir Na Moeda   ?","Imprimir Na Moeda   ?","Imprimir Na Moeda   ?","mv_ch7","C",02,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})	
	aAdd(aRegs,{cPergSX1,"08","Modalidade Opera็ใo ?","Modalidade Opera็ใo ?","Modalidade Opera็ใo ?","mv_ch8","N",01,0,1,"C","","mv_par08","Antecipado","Antecipado","Antecipado","","","A Vista","A Vista","A Vista","","","A Prazo","A Prazo","A Prazo","","","Cobran็a","Cobran็a","Cobran็a","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"09","Comissใo De Agente  ?","Comissใo De Agente  ?","Comissใo De Agente  ?","mv_ch9","N",01,0,1,"C","","mv_par09","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"10","Banco Pagamento     ?","Banco Pagamento     ?","Banco Pagamento     ?","mv_cha","C",TAMSX3("A6_COD")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","007",""})
	aAdd(aRegs,{cPergSX1,"11","Ag๊ncia Pagamento   ?","Ag๊ncia Pagamento   ?","Ag๊ncia Pagamento   ?","mv_chb","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","","008",""})
	aAdd(aRegs,{cPergSX1,"12","Conta Pagamento     ?","Conta Pagamento     ?","Conta Pagamento     ?","mv_chc","C",TAMSX3("A6_NUMCON")[1],0,0,"G","", "mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","","009",""})
	aAdd(aRegs,{cPergSX1,"13","Nome p/Assinatura   ?","Nome p/Assinatura   ?","Nome p/Assinatura   ?","mv_chd","C",40,0,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPergSX1,"14","Data Pagamento      ?","Data Pagamento      ?","Data Pagamento      ?","mv_che","D",08,0,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

	
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
