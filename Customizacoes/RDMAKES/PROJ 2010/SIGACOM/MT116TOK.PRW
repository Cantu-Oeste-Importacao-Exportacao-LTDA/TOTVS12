#INCLUDE "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT116TOK   ºAutor  ³TOTVS CASCAVEL     º Data ³  20/08/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada localizado após a confirmação de inclusão  º±±
±±º          ³do documento de conhecimento de frete.                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
User Function MT116TOK()
*---------------------------------------------------------------------------*                                                                             

Local aAreaTMP := GetArea()
Local lRet := .T.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())


	MsAguarde( {|| lRet := fCheckCTB() }, "Validações contábeis... Aguarde!")
	
	RestArea(aAreaTMP)

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckCTB  ºAutor  ³TOTVS CASCAVEL     º Data ³  20/08/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função responsável por validar o segmento, centro de custo eº±±
±±º          ³conta contábil na inclusão do documento de entrada.         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------------------------------*
Static Function fCheckCTB()   
*---------------------------------------------------------------------------*
Local lRet := .T.
Local cTEXTO    := ""
Local nPosDEL   := Len(aHeader) + 1
Local nPosCC	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"		} )
Local nPosCTA	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"	} )
Local nPosRAT 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"	} )
Local nPosPRD 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"		} )
Local nPosITEM	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"	} )
Local nPosCLVL	:= aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CLVL"	} )
	
	For nI := 1 to Len(aCols)
		If ! aCols[nI][nPosDEL]		
			If nPosRAT > 0 .and. aCols[nI][nPosRAT] != '1' .and. ( Empty(aCols[nI][nPosCC]) .or. Empty(aCols[nI][nPosCTA]) .or. Empty(aCols[nI][nPosCLVL]) )
		   		cTEXTO += "ITEM: "+aCols[nI][nPosITEM]+" - PRODUTO: "+aCols[nI][nPosPRD]+chr(13)+chr(10)
		   		lRet := .F.
			EndIf
		EndIf
	Next nI
                    
	If !lRet
		Aviso("Atenção","Alguns campos obrigatórios (SEGMENTO, CENTRO DE CUSTO OU CONTA CONTÁBIL) não foram preenchidos para os seguintes itens: "+chr(13)+chr(10)+cTEXTO, {"OK"}, 3)
	EndIf
	

Return (lRet)
