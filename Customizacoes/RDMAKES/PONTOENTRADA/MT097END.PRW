#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT097END   บAutor  ณRafael Parma       บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvio de workflow do pedido de compras ap๓s libera็ใo.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------*
User Function MT097END()
*----------------------------*
Local cNumPC := SubSTR(PARAMIXB[1],1,TAMSX3("C7_NUM")[1])   // Numero do Pedido de Compras
Local aArea    := GetArea()
Local aPARCELA := {}
Local aDADOSWF := {}
Local nVALDESP := 0
Local nVALSEGU := 0
Local nVALFRET := 0
Local nVALTPED := 0
Local nVALTOLD := 0
Local cCONDPGT := ""
Local cCODFORN := ""
Local cLOJFORN := ""
Local cEMLFORN := ""
Local cNOMFORN := ""
Local cCOMPRAD := ""
Local dPDATPRF := ddatabase  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
    
    If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
    
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SC7") + cNumPC )
		
			cCOMPRAD := SC7->C7_USER
		    
		    While !SC7->(EOF()) .and. SC7->C7_FILIAL + SC7->C7_NUM == xFilial("SC7") + cNumPC

				nVALDESP += SC7->C7_DESPESA
				nVALSEGU += SC7->C7_SEGURO
				nVALFRET += SC7->C7_VALFRE
				nVALTPED += SC7->C7_TOTAL + SC7->C7_VALIPI + SC7->C7_SEGURO + SC7->C7_DESPESA + SC7->C7_VALFRE
				dPDATPRF := SC7->C7_DATPRF
				cCONDPGT := SC7->C7_COND
				cCODFORN := SC7->C7_FORNECE
				cLOJFORN := SC7->C7_LOJA
				aAdd ( aDADOSWF, {cNumPC, SC7->C7_EMISSAO, SC7->C7_COND, SC7->C7_ITEM, ALLTRIM(SC7->C7_PRODUTO)+"/"+SC7->C7_DESCRI, SC7->C7_QUANT, SC7->C7_PRECO, SC7->C7_TOTAL, SC7->C7_VALIPI, SC7->C7_DATPRF } )
				
				SC7->(dbSkip())	    
		    Enddo
		    nVALTPED += nVALDESP
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณRecupera vencimentos/valores da condi็ใo de pagamento                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  			
			//aPARCELA := Condicao(nVALTPED,cCONDPGT,,dPDATPRF)                           
			
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek( xFilial("Z11") + cNumPC )
				aPARCELA := {}
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + cNumPC					
					aAdd (aPARCELA, { Z11->Z11_VENCTO, Z11->Z11_VALOR } )
					Z11->(dbSkip())		
				Enddo
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณFuncao de workflow ao fornecedor                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  

			If Len(aDADOSWF) > 0 .and. Len(aPARCELA) > 0
				dbSelectArea("SA2")
				dbSetOrder(1)
				If dbSeek( xFilial("SA2") + cCODFORN + cLOJFORN )
					If !Empty(SA2->A2_EMAIL)
						cEMLFORN := SA2->A2_EMAIL
						cNOMFORN := SA2->A2_NOME
					EndIf
				EndIf 
			EndIf
				        
			If ALLTRIM(cEMLFORN) == ""	
				Aviso("Aviso", "Nใo serแ enviada c๓pia do pedido ao fornecedor pois o e-mail nใo estแ informado no cadastro!", {"OK"}, 2)
			EndIf


			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณEnvia workflow                                  						   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู  								
			//@aqui
			//U_RJ120WFPC( cNOMFORN, cEMLFORN, aDADOSWF, aPARCELA, nVALTPED, nVALDESP, nVALSEGU, nVALFRET, cCOMPRAD )
				  			
		EndIf	            

	EndIf
		
	RestArea(aArea)

	
Return