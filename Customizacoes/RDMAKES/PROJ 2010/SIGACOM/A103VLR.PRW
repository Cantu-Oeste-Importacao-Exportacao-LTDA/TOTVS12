#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A103VLR   ºAutor  ³Rafael Parma        º Data ³  11/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para manipular o valor total das º±±
±±º          ³duplicatas do financeiro ao confirmar o documento de entrada.±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function A103VLR() 
*--------------------------*
Local aArea    := GetArea()
Local nPosTes  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nPosTSu  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_X_TES"})
Local nVALBASE := 0 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	U_USORWMAKE(ProcName(),FunName())
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³02/06/15 - VALIDA SE É CLASSIFICAÇÃO AUTOMATICA DE CTE³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	  
  If !ISINCALLSTACK("U_SCHCLACTE")

		If nPosTes > 0
			For nX := 1 to Len(aCols)
				If ! aCols[nX][Len(aCols[nX])] .and. ! Empty(aCols[nX,nPosTes])
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek( xFilial("SF4") + MaFisRet(nX,"IT_TES") )
					If SF4->F4_DUPLIC == "S"
					  // Flavio - removido o valor do IPI do título - 29/03/2011
						nVALBASE += MaFisRet(nX, "IT_VALMERC" ) + MaFisRet(nX, "IT_VALSOL" ) // + MaFisRet(nX, "IT_VALIPI" ) 
					EndIf
				EndIf
			Next nX
		    
			If MaFisRet(1, "NF_BASEDUP" ) > 0
				
				If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S"
				
					If !ISINCALLSTACK("MATA119") .and. CTIPO == "N"
						
						If POSICIONE("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST") == "EX"
							
							nValDUP := MaFisRet(1, "NF_BASEDUP" )
							nValFRT := MaFisRet(1, "NF_FRETE" 	)
							nValMER := MaFisRet(1, "NF_VALMERC" )
							
							If SubSTR(__cTIPOFRT,1,1) == "A"	//-- FRETE = A PAGAR
								MaFisAlt("NF_BASEDUP", nVALBASE, 1)
							Else	//-- FRETE = PAGO
								MaFisAlt("NF_BASEDUP", (nVALBASE+nValFRT)-__nVLRTHC, 1)
							EndIf
						EndIf      
					
					EndIf
				EndIf	
			EndIf  
		
			RestArea(aArea)
	  EndIf
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Setar com a TES sugerida o campo da TES no momento da classificação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nPosTes > 0 .and. nPosTSu > 0
			For nX := Len(aCols) to 1 step -1
				aCols[nX,nPosTes] := aCols[nX, nPosTSu]
			Next nX
		EndIf
		
	EndIf
	
Return 