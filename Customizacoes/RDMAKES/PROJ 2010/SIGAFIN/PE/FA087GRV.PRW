#include "PROTHEUS.CH"
#include "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA087GRV   ºAutor  ³Rafael Parma       º Data ³  10/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. utilizado para gravar dados de segmento, centro de cus-±±
±±º          ³ to e item contabil no final do processo de recebimentos    º±±
±±º          ³ diversos.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                                                           

*---------------------------*
User Function FA087GRV()
*---------------------------*                       
Local aArea   := GetArea()

Local nPELPRF := AScan(aHeader,{|x|Alltrim(x[2])=="EL_PREFIXO"})
Local nPELNUM := AScan(aHeader,{|x|Alltrim(x[2])=="EL_NUMERO"})
Local nPELPAR := AScan(aHeader,{|x|Alltrim(x[2])=="EL_PARCELA"})

Local nPE1PRF := AScan(aCposSE1,"E1_PREFIXO")
Local nPE1NUM := AScan(aCposSE1,"E1_NUM")
Local nPE1PAR := AScan(aCposSE1,"E1_PARCELA")
Local nPE1TIP := AScan(aCposSE1,"E1_TIPO")

Local cCLVLF  := ""
Local cCCDEF  := ""
Local cITDEF  := ""   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//-- Recupera dados necessários para gravar sobre títulos destino e registros de comissões.
	If Len(aLinSE1) > 0
		For nY := 1 to Len(aLinSE1)
			If aLinSE1[nY][1] == 1
				dbSelectArea("SE1")
			    dbSetOrder(1)
			    dbGoTop()
			    If dbSeek( 	xFilial("SE1") + aLinSE1[nY][nPE1PRF] + aLinSE1[nY][nPE1NUM] + aLinSE1[nY][nPE1PAR] + aLinSE1[nY][nPE1TIP] ) 
			    	If !Empty(SE1->E1_ITEMC) .or. !Empty(SE1->E1_CLVLCR)
			    		
			    		//-- Recupera dados título de origem.
			    		cCCDEF := SE1->E1_CCC 
			    		cITDEF := SE1->E1_ITEMC
			    		cCLVLF := SE1->E1_CLVLCR
			    		cVEND1 := SE1->E1_VEND1

			    		//-- Grava dados sobre registros de comissões do título.
						dbSelectArea("SE3")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek( xFilial("SE3") + SE1->E1_PREFIXO + SE1->E1_NUM )
							While !SE3->(EOF()) .and. SE3->E3_FILIAL + SE3->E3_PREFIXO + SE3->E3_NUM == xFilial("SE3") + SE1->E1_PREFIXO + SE1->E1_NUM
								If RecLock("SE3",.F.)
									SE3->E3_CCD    := cCCDEF
									SE3->E3_ITEMD  := cITDEF
									SE3->E3_CLVLDB := cCLVLF
									SE3->(MsUnLock())          									
								EndIf
								SE3->(dbSkip())
							Enddo
						EndIf			    		

			    	EndIf
			    EndIf
			EndIf
		Next nY
	EndIf
	

	If ( cCCDEF != "" .or. cCLVLF != "" .or. cITDEF != "" )
		
		//-- Atualiza registros gerados a partir do recebimento.
		If Len(aCols) > 0
			For nY := 1 to Len(aCols)
				dbSelectArea("SE1")
			    dbSetOrder(1)
			    dbGoTop()
			    If dbSeek( 	xFilial("SE1") + aCols[nY][nPELPRF] + aCols[nY][nPELNUM] + aCols[nY][nPELPAR] ) 
			    	If RecLock("SE1",.F.)
			    		SE1->E1_CCC    := cCCDEF
			    		SE1->E1_ITEMC  := cITDEF
			    		SE1->E1_CLVLCR := cCLVLF
			    		SE1->E1_VEND1  := cVEND1  
			    		SE1->(MsUnLock())
			    	EndIf
			    EndIf			
			Next nY
		EndIf
		
		//--Atualiza registros de adiantamentos (RA).
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek( xFilial("SE1")+"REC"+cRecibo )
			While !SE1->(EOF()) .and. SE1->(E1_FILIAL+E1_PREFIXO+SUBSTR(E1_NUM,1,TAMSX3("E1_RECIBO")[1])) == xFilial("SE1")+"REC"+cRecibo
				If Empty(SE1->E1_CCC) .and. !Empty(cCCDEF)
					RecLock("SE1",.F.)
					SE1->E1_CCC		:= cCCDEF
					SE1->(MsUnLock())	
				EndIf
				If Empty(SE1->E1_ITEMC) .and. !Empty(cITDEF)
					RecLock("SE1",.F.)
					SE1->E1_ITEMC	:= cITDEF
					SE1->(MsUnLock())	
				EndIf
				If Empty(SE1->E1_CLVLCR) .and. !Empty(cCLVLF)
					RecLock("SE1",.F.)
					SE1->E1_CLVLCR	:= cCLVLF
					SE1->(MsUnLock())	            
				EndIf
				SE1->(dbSkip())
			Enddo
		EndIf

		//--Atualiza registros no movimento bancario.
		dbSelectArea("SE5")
		dbSetOrder(8)	//E5_FILIAL+E5_ORDREC+E5_SERREC
		dbGoTop()
		If dbSeek( xFilial("SE5")+cRecibo )
			While !SE5->(EOF()) .and. SE5->(E5_FILIAL+E5_ORDREC) == xFilial("SE5")+cRecibo
				If Empty(SE5->E5_CCC) .and. cCCDEF != ""
					RecLock("SE5",.F.)
					SE5->E5_CCC		:= cCCDEF
					SE5->(MsUnLock())
				EndIf
				If Empty(SE5->E5_ITEMC) .and. cITDEF != ""
					RecLock("SE5",.F.)
					SE5->E5_ITEMC	:= cITDEF
					SE5->(MsUnLock())
				EndIf
				If Empty(SE5->E5_CLVLCR) .and. cCLVLF != ""
					RecLock("SE5",.F.)
					SE5->E5_CLVLCR	:= cCLVLF
					SE5->(MsUnLock())
				EndIf
				SE5->(dbSkip())
			Enddo
		EndIf

	EndIf
	
	RestArea(aArea)
		
Return