#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MA140BUT   ºAutor  ³Rafael Parma       º Data ³  03/10/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada para declaração de variáveis públicas no   º±±
±±º          ³documento de entrada, processo de importação.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function XMA140BUT()    
*--------------------------*
Local aBUT := {}
Public __lValidPED := .F.
Public __cUserLibP := ""                
Public __aTIPOFRT  := {"Pago","A Pagar"}
Public __aTIPOTHC  := {"Sim","Não"}
Public __aMOEDAS   := {"Reais (R$)","Dollars (US)","Euro (€)","Iene (¥)","Pesos Argentino ($)","Pesos Chileno ($)"}
Public __aTIPTRAN  := {"Maritimo","Terrestre","Aereo"," "}
Public __aTIPCNTR  := {"Dry","Reefer"}
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
                 
	aAdd(aBUT, { "NOTE" , {|| U_RJ140JI() }, "Importação" , "Importação" } )    
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
                        
Return (aBUT)              
 

*--------------------------------*
User Function RJ140JI()
*--------------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//-- Se classificação de documento e estado do fornecedor = EX, popula variáveis da janela de importação.
	If SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_DOC+F1_SERIE) == xFilial("SF1")+CA100FOR+CLOJA+cNFiscal+cSerie
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
	
	U_RJ103IMP()

Return
