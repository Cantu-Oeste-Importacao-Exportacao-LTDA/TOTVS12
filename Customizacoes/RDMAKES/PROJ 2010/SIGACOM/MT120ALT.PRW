#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA103BUT   บAutor  ณRafael Parma       บ Data ณ  30/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para declarar variแvel p๚blica no documentoบฑฑ
ฑฑบ          ณde entrada para valida็ใo dos vencimentos/parcelas do pedidoบฑฑ
ฑฑบ          ณrelacionado ao documento.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User FuncTion XMA103BUT()    
*--------------------------*
Local aBUT := {}

Public __lValidPED := .F.
Public __cUserLibP := ""                
Public __aTIPOFRT  := {"Pago","A Pagar"}
Public __aTIPOTHC  := {"Sim","Nใo"}
Public __aMOEDAS   := {"Reais (R$)","Dollars (US)","Euro (€)","Iene (ฅ)","Pesos Argentino ($)","Pesos Chileno ($)"}
//Public __aTIPTRAN  := {"Maritimo","Terrestre","Aereo"," "} //Gustavo 26/03/15 - Alterado o conte๚do para atender a obrigatoriedade da NF-e 3.10
Public __aTIPTRAN  := {"1=Marํtima","2=Fluvial","3=Lacustre","4=A้rea","5=Postal","6=Ferroviแria","7=Rodoviแria","8=Conduto / Rede Transmissใo","9=Meios Pr๓prios","10=Entrada / Saํda ficta"}
Public __aTIPCNTR  := {"Dry","Reefer"}
Public __aTIPINT   := {"1=Importa็ใo por conta pr๓pria","2=Importa็ใo por conta e ordem","3=Importa็ใo por encomenda"} //@aqui
Public __cFORMME   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJMME   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMMME   := Space(TamSX3("A2_NOME")[1])
Public __cFORFRT   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJFRT   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMFRT   := Space(TamSX3("A2_NOME")[1])
Public __cFORSEG   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJSEG   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMSEG   := Space(TamSX3("A2_NOME")[1])
Public __nTXMOEDA  := 0
Public __vVFRTHC   := 0
Public __cMOEDA    := Space(20)
Public __cTIPOFRT  := Space(01)
Public __cTIPOTHC  := Space(01)
Public __cNUMDI    := Space(20)
Public __cNUMFT    := Space(20)
Public __cNUMBL    := Space(20)
Public __cAIRIM    := Space(20)
Public __cMICRT    := Space(20)
Public __cLOCDES   := Space(60)
Public __cUFDES    := Space(02)
Public __cTIPINT   := Space(01) //@aqui
Public __dDATDI    := ctod("")
Public __dDATDES   := ctod("")
Public __nVLRII    := 0
Public __nVLRTHC   := 0
Public __nVLRMAME  := 0
Public __nTXSISCO  := 0
Public __nDIRANTI  := 0 

Public __cTIPTRAN  := Space(01)
Public __cTIPCNTR  := Space(01)
Public __cORIGEM   := Space(40)
Public __cTIPMERC  := Space(40)
Public __cDESNAVIO := Space(40)
Public __cDTEMBARQ := ctod("")   
Public __cADQUI    := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJADQ   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMADQ   := Space(TamSX3("A2_NOME")[1])
Public __cUFADQ	   := Space(02)		
Public __nQTDECNTR := 0       


Public __cInfoAdic := ""    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

U_USORWMAKE(ProcName(),FunName())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ02/06/15 - VALIDA SE ษ CLASSIFICAวรO AUTOMATICA DE CTEณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If !ISINCALLSTACK("U_SCHCLACTE")

	// Visualiza็ใo dos valores/vencimentos do fluxo de caixa do pedido de compras
	If ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S"
		aAdd(aBUT, { "POSCLI"   , {|| U_RJ103VPD() }, "Fluxo Caixa"            , "Fluxo CX"   } ) 
	EndIf	
	aAdd(aBUT, { "POSCLI"   , {|| U_InfoAdic() }, "Informa็๕es Adicionais" , "Info Adic"   } )
    

	//-- Se classifica็ใo de documento e estado do fornecedor = EX, popula variแveis da janela de importa็ใo.
	If l103Class
		If SF1->F1_EST == "EX" 
			If !Empty(SF1->F1_X_NUMDI)
				__cNUMDI := SF1->F1_X_NUMDI
			EndIf
			If !Empty(SF1->F1_X_NUMFT)
				__cNUMFT := SF1->F1_X_NUMFT
			EndIf
			If !Empty(SF1->F1_X_NUMBL)
				__cNUMBL := SF1->F1_X_NUMBL
			EndIf
			If !Empty(SF1->F1_X_AIRIM)			
				__cAIRIM := SF1->F1_X_AIRIM
			EndIf
			If !Empty(SF1->F1_X_MICRT)			
				__cMICRT := SF1->F1_X_MICRT
			EndIf
			If !Empty(SF1->F1_X_TPFRT)			
				__cTIPOFRT := SF1->F1_X_TPFRT
			EndIf
			If !Empty(SF1->F1_X_MARME)			
				__nVLRMAME := SF1->F1_X_MARME
			EndIf
			If !Empty(SF1->F1_X_TXSIS)			
				__nTXSISCO := SF1->F1_X_TXSIS
			EndIf
			If !Empty(SF1->F1_X_ANTID)			
				__nDIRANTI := SF1->F1_X_ANTID
			EndIf
			If !Empty(SF1->F1_X_TXTHC)			
				__nVLRTHC  := SF1->F1_X_TXTHC
			EndIf
			If !Empty(SF1->F1_X_VLRII)			
				__nVLRII   := SF1->F1_X_VLRII
			EndIf
			If !Empty(SF1->F1_X_DATDI)			
				__dDATDI   := SF1->F1_X_DATDI
			EndIf
			If !Empty(SF1->F1_X_LOCDI)			
				__cLOCDES  := SF1->F1_X_LOCDI
			EndIf
			If !Empty(SF1->F1_X_UFDI)			
				__cUFDES   := SF1->F1_X_UFDI
			EndIf
			If !Empty(SF1->F1_X_DATDE)			
				__dDATDES  := SF1->F1_X_DATDE
			EndIf
		EndIf
	EndIf

EndIf

Return (aBUT)               



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJ103VPD   บAutor  ณRafael Parma       บ Data ณ  02/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza็ใo das parcelas/vencimentos do pedido de compras  บฑฑ
ฑฑบ          ณrelacionado ao documento.                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User Function RJ103VPD()    
*--------------------------*
Local aArea := GetArea()
Local nPosPed := aScan(aHeader, { |x| x[2] = "D1_PEDIDO"})
Local cPARCELA := ""
Local nPARCELA := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If !Empty(aCols[n,nPosPed])
		dbSelectArea("SC7")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SC7") + aCols[n,nPosPed] )
			dbSelectArea("Z11")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("Z11") + aCols[n,nPosPed] )
				While !Z11->(EOF()) .and. Z11->Z11_FILIAL + Z11->Z11_PEDIDO == xFilial("Z11") + aCols[n,nPosPed]
					nPARCELA += 1
					cPARCELA += "Parcela: " +STRZERO(nPARCELA,2) + " - Data Vencimento: " +dtoc(Z11->Z11_VENCTO)+ " - Valor: "+ALLTRIM(STR(Z11->Z11_VALOR)) + CHR(13)+CHR(10)
					Z11->(dbSkip())
				Enddo
			EndIf
		EndIf
		If cPARCELA != ""
			Aviso("PARCELAS/VENCIMENTOS DO PEDIDO",cPARCELA,{"OK"},3)
		Else
			MsgInfo("Pedido de compras sem parcelas/vencimentos!")
		EndIf
	Else
		MsgInfo("Pedido de compras nใo informado no documento!")
	EndIf               
	
	RestArea(aArea)
	
Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJ103IMP   บAutor  ณRafael Parma       บ Data ณ  11/01/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela para preenchimento de dados referentes a inclusใo de บฑฑ
ฑฑบ          ณdocumento de importa็ใo.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*----------------------------*
User Function RJ103IMP()
*----------------------------*
Local aArea := GetArea()
Local lRet := .T.
Private oDlgIMP                  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	// avalia se ้ nota de inclusao normal
	If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S" .and. Type("cTipo") == "C"
	
		If cTipo == "N"

			dbSelectArea("SA2")
			dbSetOrder(1)
			dbSeek( xFilial("SA2")+CA100FOR+CLOJA)
			                                                        		
			If ( SubSTR(CA100FOR,1,2) == "EX" .or. SA2->A2_EST == "EX" ) .AND. ALLTRIM(FUNNAME()) $ "MATA103/MATA140"
			
				DEFINE MSDIALOG oDlgIMP FROM 010,010 TO 570,790 TITLE "Documento de Importa็ใo" PIXEL
				@ 005, 005 TO 250, 385 OF oDlgIMP  PIXEL
				
				__cFORMME := POSICIONE("SA2",1,XFILIAL("SA2")+"MARINHA","A2_COD")
				__cLOJMME := POSICIONE("SA2",1,XFILIAL("SA2")+"MARINHA","A2_LOJA")
				__cNOMMME := POSICIONE("SA2",1,XFILIAL("SA2")+"MARINHA","A2_NOME")
				 
				@ 010,010 SAY "N๚mero DI:" 			SIZE 200,10 OF oDlgIMP PIXEL 
				@ 010,065 GET __cNUMDI 				SIZE 050,10 OF oDlgIMP PIXEL
				@ 010,140 SAY "Data Registro DI:" 	SIZE 200,10 OF oDlgIMP PIXEL
				@ 010,200 GET __dDATDI				SIZE 050,10 OF oDlgIMP PIXEL							
				@ 010,275 SAY "Local Desembara็o DI:" 	SIZE 200,10 OF oDlgIMP PIXEL
				@ 010,330 GET __cLOCDES				SIZE 050,10 OF oDlgIMP PIXEL	
				
				@ 030,010 SAY "UF Desembara็o DI:"	SIZE 200,10 OF oDlgIMP PIXEL 
				@ 030,065 MSGET oCLAS VAR __cUFDES F3 "12" SIZE 020,10 VALID (!VAZIO().AND.EXISTCPO("SX5"))  OF oDlgIMP PIXEL			
				@ 030,140 SAY "Data Desembara็o DI:" 	SIZE 200,10 OF oDlgIMP PIXEL
				@ 030,200 GET __dDATDES				SIZE 050,10 OF oDlgIMP PIXEL				
				@ 030,275 SAY "N๚mero Fatura:"  	SIZE 200,10 OF oDlgIMP PIXEL
				@ 030,330 GET __cNUMFT				SIZE 050,10 OF oDlgIMP PIXEL
				
				@ 050,010 SAY "N๚mero BL:"  		SIZE 200,10 OF oDlgIMP PIXEL
				@ 050,065 GET __cNUMBL				SIZE 050,10 OF oDlgIMP PIXEL
				@ 050,140 SAY "Nr. AIR/Import:" 	SIZE 200,10 OF oDlgIMP PIXEL
				@ 050,200 GET __cAIRIM				SIZE 050,10 OF oDlgIMP PIXEL
				@ 050,275 SAY "Nr. MIC/CRT:"    	SIZE 200,10 OF oDlgIMP PIXEL
				@ 050,330 GET __cMICRT				SIZE 050,10 OF oDlgIMP PIXEL
				
				@ 070,010 SAY "Marinha Mercante:" 	SIZE 200,10 OF oDlgIMP PIXEL
				@ 070,065 GET __nVLRMAME			SIZE 050,10 PICTURE "@E 999,999.99" OF oDlgIMP PIXEL
				@ 070,140 SAY "Fornecedor Marinha:" SIZE 200,10 OF oDlgIMP PIXEL            		                                                                          
				@ 070,200 MSGET oCLAS VAR __cFORMME SIZE 040,10 F3 "SA2001" WHEN ( __nVLRMAME > 0 ) VALID (!VAZIO().AND.EXISTCPO("SA2")) OF oDlgIMP PIXEL
				@ 070,250 GET __cLOJMME				SIZE 015,10 WHEN ( __nVLRMAME > 0 ) OF oDlgIMP PIXEL
				@ 070,280 GET __cNOMMME				SIZE 100,10 WHEN .F. OF oDlgIMP PIXEL 
		
				@ 090,010 SAY "Taxa Siscomex:"    	SIZE 200,10 OF oDlgIMP PIXEL
				@ 090,065 GET __nTXSISCO			SIZE 050,10 PICTURE "@E 999,999.99" OF oDlgIMP PIXEL
				@ 090,140 SAY "Dir. Antidumping:"   SIZE 200,10 OF oDlgIMP PIXEL
				@ 090,200 GET __nDIRANTI			SIZE 050,10 PICTURE "@E 999,999.99" OF oDlgIMP PIXEL
				@ 090,275 SAY "Taxa THC:"   		SIZE 200,10 OF oDlgIMP PIXEL
				@ 090,330 GET __nVLRTHC				SIZE 050,10 PICTURE "@E 999,999.99" OF oDlgIMP PIXEL
				
				@ 110,010 SAY "Imposto Importa็ใo"  SIZE 200,10 OF oDlgIMP PIXEL
				@ 110,065 GET __nVLRII				SIZE 050,10 PICTURE "@E 999,999.99" OF oDlgIMP PIXEL					
				@ 110,140 SAY "Frete:"			   	SIZE 200,10 OF oDlgIMP PIXEL
				@ 110,200 COMBOBOX __cTIPOFRT ITEMS __aTIPOFRT SIZE 050,10 OF oDlgIMP PIXEL			
				@ 110,275 SAY "Moeda Frete:"      	SIZE 200,10 OF oDlgIMP PIXEL
				@ 110,330 COMBOBOX __cMOEDA ITEMS __aMOEDAS SIZE 050,10 OF oDlgIMP PIXEL
	
				@ 130,010 SAY "Fornecedor Frete:"   SIZE 200,10 OF oDlgIMP PIXEL
				@ 130,065 MSGET oCLAS VAR __cFORFRT	SIZE 040,10 F3 "SA2001" WHEN ( SUBSTR(__cTIPOFRT,1,1) == "A" ) VALID (!VAZIO().AND.EXISTCPO("SA2")) OF oDlgIMP PIXEL			
				@ 130,115 GET __cLOJFRT				SIZE 015,10 WHEN ( SUBSTR(__cTIPOFRT,1,1) == "A" ) OF oDlgIMP PIXEL
				@ 130,145 GET __cNOMFRT				SIZE 100,10 WHEN .F. OF oDlgIMP PIXEL					
				@ 130,275 SAY "Taxa Moeda:"         SIZE 200,10 OF oDlgIMP PIXEL
				@ 130,330 GET __nTXMOEDA			SIZE 050,10 PICTURE "@E 999.9999" WHEN ( __cMOEDA != "Reais (R$)" ) OF oDlgIMP PIXEL
		
				@ 150,010 SAY "Valor Frete Mda Est.:"   SIZE 200,10 OF oDlgIMP PIXEL
				@ 150,065 GET __vVFRTHC				SIZE 050,10 PICTURE "@E 999,999.99" WHEN ( __cMOEDA != "Reais (R$)" ) OF oDlgIMP PIXEL   			
				@ 150,140 SAY "Fornecedor Seguro:"  SIZE 200,10 OF oDlgIMP PIXEL
				@ 150,200 MSGET oCLAS VAR __cFORSEG	SIZE 040,10 F3 "SA2001" WHEN ( SUBSTR(__cTIPOFRT,1,1) == "A" ) VALID (!VAZIO().AND.EXISTCPO("SA2")) OF oDlgIMP PIXEL
				@ 150,250 GET __cLOJSEG				SIZE 015,10 WHEN ( SUBSTR(__cTIPOFRT,1,1) == "A" ) OF oDlgIMP PIXEL
				@ 150,280 GET __cNOMSEG				SIZE 100,10 WHEN .F. OF oDlgIMP PIXEL 
	
				@ 170,010 SAY "Tipo Transporte:"   	SIZE 200,10 OF oDlgIMP PIXEL
				@ 170,065 COMBOBOX __cTIPTRAN ITEMS __aTIPTRAN SIZE 050,10 OF oDlgIMP PIXEL			
				@ 170,140 SAY "Origem:"      	    SIZE 200,10 OF oDlgIMP PIXEL
				@ 170,200 GET __cORIGEM			    SIZE 050,10 OF oDlgIMP PIXEL	
				@ 170,275 SAY "Tipo Mercadoria:"   	SIZE 200,10 OF oDlgIMP PIXEL
				@ 170,330 GET __cTIPMERC			SIZE 050,10 OF oDlgIMP PIXEL
							
				@ 190,010 SAY "Navio:"      	    SIZE 200,10 OF oDlgIMP PIXEL
				@ 190,065 GET __cDESNAVIO		    SIZE 050,10 OF oDlgIMP PIXEL
				@ 190,140 SAY "Data Embarque:"   	SIZE 200,10 OF oDlgIMP PIXEL
				@ 190,200 GET __cDTEMBARQ			SIZE 050,10 OF oDlgIMP PIXEL			
				@ 190,275 SAY "Tipo CNTR:"      	SIZE 200,10 OF oDlgIMP PIXEL
				@ 190,330 COMBOBOX __cTIPCNTR ITEMS __aTIPCNTR SIZE 050,10 OF oDlgIMP PIXEL	
	
				@ 210,010 SAY "Quantidade:" 	  	SIZE 200,10 OF oDlgIMP PIXEL
				@ 210,065 GET __nQTDECNTR PICTURE "@E 999,999.99" SIZE 050,10 OF oDlgIMP PIXEL	//@aqui		
				
				//Gustavo 01/04/2015 - Criados novos campos obrigat๓rios para a NF-e.
				@ 210,140 SAY "Tipo Interm้dio:"   	SIZE 200,10 OF oDlgIMP PIXEL
				@ 210,200 COMBOBOX __cTIPINT ITEMS __aTIPINT SIZE 100,10 OF oDlgIMP PIXEL
				
				@ 230,010 SAY "Adquirente:"   SIZE 200,10 OF oDlgIMP PIXEL
				@ 230,065 MSGET oCLAS VAR __cADQUI	SIZE 040,10 F3 "SA1001" WHEN ( SUBSTR(__cTIPINT,1,1) != "1" ) VALID (!VAZIO().AND.EXISTCPO("SA1")) OF oDlgIMP PIXEL			
				@ 230,115 GET __cLOJADQ				SIZE 015,10 WHEN ( SUBSTR(__cTIPINT,1,1) != "1" ) OF oDlgIMP PIXEL
				@ 230,145 GET __cNOMADQ				SIZE 100,10 WHEN .F. OF oDlgIMP PIXEL
				@ 230,275 SAY "UF Adquirente:" 		SIZE 200,10 OF oDlgIMP PIXEL 
				@ 230,330 MSGET oCLAS VAR __cUFADQ F3 "12" SIZE 020,10 VALID (!VAZIO().AND.EXISTCPO("SX5").AND. __cUFADQ != "EX")  OF oDlgIMP PIXEL
					
				DEFINE SBUTTON FROM 255, 300 TYPE 1 ACTION (nOpcao:=1,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
				DEFINE SBUTTON FROM 255, 330 TYPE 2 ACTION (nOpcao:=2,oDlgIMP:End()) ENABLE OF oDlgIMP PIXEL
				
				ACTIVATE MSDIALOG oDlgIMP CENTERED
			
			EndIf
		
		EndIf
		RestArea(aArea)
	
	EndIf
	
Return (lRet)         

user function InfoAdic()
Static oDlg
Local oMultiGet1
Local cInfo := ""
Static oSay1

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	if INCLUI
		cInfo := __cInfoAdic
	else
		cInfo := SF1->F1_X_ADIC
	endIf
	
  DEFINE MSDIALOG oDlg TITLE "Informa็๕es Adicionais" FROM 000, 000  TO 350, 500 COLORS 0, 16777215 PIXEL

    @ 017, 004 SAY oSay1 PROMPT "Informa็๕es Adicionais" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
    aButtons := {}
    EnchoiceBar(oDlg, {||u_btnOkAct(cInfo)}, {||oDlg:End()},,aButtons)
    @ 027, 004 GET oMultiGet1 VAR cInfo OF oDlg MULTILINE SIZE 242, 130 COLORS 0, 16777215 HSCROLL PIXEL
  ACTIVATE MSDIALOG oDlg
  
return .T.

user function btnOkAct(cInfo)    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	__cInfoAdic := cInfo
	oDlg:End()
return .T.
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJM140VAR  บAutor  ณRafael Parma       บ Data ณ  03/10/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada para declara็ใo de variแveis p๚blicas no   บฑฑ
ฑฑบ          ณdocumento de entrada, processo de importa็ใo.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User Function RJM140VAR()    
*--------------------------*
Local aBUT := {}
Public __lValidPED := .F.
Public __cUserLibP := ""                
Public __aTIPOFRT  := {"Pago","A Pagar"}
Public __aTIPOTHC  := {"Sim","Nใo"}
Public __aMOEDAS   := {"Reais (R$)","Dollars (US)","Euro (€)","Iene (ฅ)","Pesos Argentino ($)","Pesos Chileno ($)"}
//Public __aTIPTRAN  := {"Maritimo","Terrestre","Aereo"," "} //Gustavo 26/03/15 - Alterado o conte๚do para atender a obrigatoriedade da NF-e 3.10
Public __aTIPTRAN  := {"1=Marํtima","2=Fluvial","3=Lacustre","4=A้rea","5=Postal","6=Ferroviแria","7=Rodoviแria","8=Rede Transmissใo","9=Meios Pr๓prios","10=Entrada ficta"}
Public __aTIPCNTR  := {"Dry","Reefer"} 
Public __aTIPINT   := {"1=Importa็ใo por conta pr๓pria","2=Importa็ใo por conta e ordem","3=Importa็ใo por encomenda"} //@aqui
Public __cFORMME   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJMME   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMMME   := Space(TamSX3("A2_NOME")[1])
Public __cFORFRT   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJFRT   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMFRT   := Space(TamSX3("A2_NOME")[1])
Public __cFORSEG   := Space(TamSX3("D1_FORNECE")[1])
Public __cLOJSEG   := Space(TamSX3("D1_LOJA")[1])
Public __cNOMSEG   := Space(TamSX3("A2_NOME")[1])
Public __nTXMOEDA  := 0
Public __vVFRTHC   := 0
Public __cMOEDA    := Space(20)
Public __cTIPOFRT  := Space(01)
Public __cTIPOTHC  := Space(01)
Public __cNUMDI    := Space(20)
Public __cNUMFT    := Space(20)
Public __cNUMBL    := Space(20)
Public __cAIRIM    := Space(20)
Public __cMICRT    := Space(20)
Public __cLOCDES   := Space(60)
Public __cUFDES    := Space(02) 
Public __cTIPINT   := Space(01) //@aqui
Public __dDATDI    := ctod("")
Public __dDATDES   := ctod("")
Public __nVLRII    := 0
Public __nVLRTHC   := 0
Public __nVLRMAME  := 0
Public __nTXSISCO  := 0
Public __nDIRANTI  := 0 

Public __cTIPTRAN  := Space(01)
Public __cTIPCNTR  := Space(01)
Public __cORIGEM   := Space(40)
Public __cTIPMERC  := Space(40)
Public __cDESNAVIO := Space(40)
Public __cDTEMBARQ := ctod("")
Public __nQTDECNTR := 0

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
                        
Return


