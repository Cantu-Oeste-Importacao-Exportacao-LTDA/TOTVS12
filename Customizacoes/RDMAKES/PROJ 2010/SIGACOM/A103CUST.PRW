#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A103CUST  ºAutor  ³Rafael Parma        º Data ³  11/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para manipular o custo dos produ-º±±
±±º          ³tos na inclusão do documento de entrada de importação.      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±                       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function A103CUST()
*--------------------------*
Local aRet := PARAMIXB[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³02/06/15 - VALIDA SE CHAMADA É DA ROTINA DE CLASSIFICAÇÃO AUTOMATICA DE CTE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !ISINCALLSTACK("U_SCHCLACTE")

	// Conteudo do aRet
	// aRet[1,1] -> Custo de entrada na Moeda 1
	// aRet[1,2] -> Custo de entrada na Moeda 2
	// aRet[1,3] -> Custo de entrada na Moeda 3
	// aRet[1,4] -> Custo de entrada na Moeda 4
	// aRet[1,5] -> Custo de entrada na Moeda 5


	If ALLTRIM(SuperGetMV("MV_X_ACIMP",,"N")) == "S" .AND. ALLTRIM(SuperGetMV("MV_XCUSIMP",.F.,"S")) == "S"
	
		If !ISINCALLSTACK("MATA119") .and. CTIPO == "N"
			
			nPII  := aScan(aHeader, { |x| x[2] = "D1_II"})     
			nPTOT := aScan(aHeader, { |x| x[2] = "D1_TOTAL"})
			nPCOF := aScan(aHeader, { |x| x[2] = "D1_VALIMP5"})
			nPPIS := aScan(aHeader, { |x| x[2] = "D1_VALIMP6"})		
			nPDES := aScan(aHeader, { |x| x[2] = "D1_DESPESA"})
			
			If ValType(__cTIPOFRT) == "C" .and. POSICIONE("SA2",1,xFilial("SA2")+CA100FOR+CLOJA,"A2_EST") == "EX"
	            
				nTOTII  := 0
				nTOTGER := 0
				nTOTPIS := 0
				nTOTCOF := 0
				nTOTDES := 0
	
				For nI := 1 to Len(aCols)
					If !aCols[nI][Len(aHeader)+1]
						
						nTOTII  += aCols[nI][nPII]
						nTOTGER += aCols[nI][nPTOT]
						nTOTPIS += aCols[nI][nPPIS]
						nTOTCOF += aCols[nI][nPCOF]
						nTOTDES += aCols[nI][nPDES]
						
					EndIf
				Next nI
				
				//-- RECUPERA ITEM DO ACOLS
				nITEM := VAL(SD1->D1_ITEM)
				While .T.		
					If Len(aCols) >= nITEM 
						If !aCols[nITEM][Len(aHeader)+1]                                         
							Exit
						Else
							nITEM += 1
						EndIf
					Else
						nITEM := 0
						Exit
					EndIf
				Enddo
				
	
				If nITEM > 0 .and. nTOTGER > 0 
					nPERCDESP := ( aCols[nITEM][nPTOT] / nTOTGER ) * 100
					nVALPIS   := ( nTOTPIS * nPERCDESP ) / 100
					nVALCOF   := ( nTOTCOF * nPERCDESP ) / 100
					nVALII    := ( nTOTII * nPERCDESP ) / 100
					//nDESPREL  := aCols[nITEM][nPDES] - ( nVALPIS + nVALCOF + nVALII )
					nDESPREL  := aCols[nITEM][nPDES] - nVALII
				EndIf
	
				
				
				//-- QUANDO FRETE DE IMPORTACAO = A PAGAR E EMPRESAS/FILIAIS DIFERENTES DAS INFORMADAS NA CONDICAO.			
				nARETINI := aRet[1,1]
				
				if nITEM > 0
					nFRETE := MaFisRet(nITEM,'IT_FRETE')
				EndIf
				
				If SubSTR(__cTIPOFRT,1,1) == "A" .AND. ! ( cEmpAnt $ "30/60/70" .OR. ( cEmpAnt == "50" .and. cFilAnt == "11" ) )
				
				    //-- DESCONSIDERA O VALOR DO FRETE DO CUSTO DO PRODUTO.			    
				    If nITEM > 0                                           
				    	aRet[1,1] := aRet[1,1] - MaFisRet(nITEM,'IT_FRETE')
				    EndIf  
	
				
				EndIf
				nARETMED := aRet[1,1]
				
				
				//-- CONSIDERA O VALOR IMPOSTO DE IMPORTACAO SOBRE O CUSTO DE TODOS OS PRODUTOS IMPORTADOS.			
		        If nPII > 0 .AND. nITEM > 0
		        	If aCols[nITEM][nPII] > 0
		        		/*
		        		ncusto := ( aRet[1,1] + aCols[nITEM][nPII] + aCols[nITEM][nPCOF] + aCols[nITEM][nPPIS] + nDESPREL ) - aCols[nITEM][nPDES]
		        		aRet[1,1] := ( aRet[1,1] + aCols[nITEM][nPII] + aCols[nITEM][nPCOF] + aCols[nITEM][nPPIS] + nDESPREL ) - aCols[nITEM][nPDES]
		        		*/
		        		ncusto := ( aRet[1,1] - aCols[nITEM][nPDES] )
		        		ncusto := ( ncusto + nDESPREL + aCols[nITEM][nPII] )
		        		aRet[1,1] := ncusto

		        	EndIf
		        EndIf
		        nARETFIM := aRet[1,1]   
		        
			EndIf
			
		EndIf
	
	EndIf
	
	// Flavio - 04/11/2011
	// Zerado os custos nas moedas 2, 3 4, 5 e 6 (se for criado)
	if Len(aRet[1]) >= 2
		aRet[1,2] := 0
	EndIf
	
	if Len(aRet[1]) >= 3
		aRet[1,3] := 0
	EndIf
	
	if Len(aRet[1]) >= 4
		aRet[1,4] := 0
	EndIf
	
	if Len(aRet[1]) >= 5
		aRet[1,5] := 0
	EndIf           
	
	if Len(aRet[1]) >= 6
		aRet[1,6] := 0
	EndIf

EndIf
	
Return (aRet)