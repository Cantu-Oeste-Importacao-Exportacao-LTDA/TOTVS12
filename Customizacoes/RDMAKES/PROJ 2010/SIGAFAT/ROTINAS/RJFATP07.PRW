#INCLUDE "RWMAKE.CH"                          
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFATP07   ºAutor  ³Rafael Parma       º Data ³  15/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada sobre gatilho campo C6_PRODUTO p/ definir º±±
±±º          ³ classificação fiscal.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------*
User Function RJFATP07()
*---------------------------*
Local aArea := GetArea()
Local nPOSTES := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPOSPRD := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local cTRIB := ""
Local cORIG := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If nPOSPRD != 0
		If ValType(aCols[n,nPOSPRD]) == "C"
			dbSelectArea("SBZ")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( xFilial("SBZ") + aCols[n,nPOSPRD] )
				cORIG := SUBSTR(SBZ->BZ_ORIGEM,1,1)
			Else
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbGoTop()
				dbSeek ( xFilial("SB1") + aCols[n,nPOSPRD] )
				cORIG := SUBSTR(SB1->B1_ORIGEM,1,1)
			EndIf
		EndIf			
	EndIf
		
	If nPOSTES != 0
		If ValType(aCols[n,nPOSTES]) == "C"
			dbSelectArea("SF4")
			dbSetOrder(1)
			If dbSeek( xFilial("SF4") + aCols[n,nPOSTES] )
				cTRIB := SF4->F4_SITTRIB
			EndIf		
		EndIf
	EndIf
		           
	cRET := cORIG+cTRIB
	
	RestArea(aArea)
		
Return (cRET)