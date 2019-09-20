#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120LOK  ºAutor  ³                    º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Validação na Linha do Item do        º±±
±±º          ³ Pedido de Compra.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT120LOK() 

Local aArea := GetArea()
Local lRet := .T.

Local nPosConta := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CONTA"})
Local nPosIT    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_ITEMCTA"})
Local nPosCC    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CC"})
Local nPosCL    := aScan(aHeader,{|x| AllTrim(x[2])=="C7_CLVL"})  
Local nPosTES   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_TES"})  
Local nPosProd  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local nPQUANT   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_QUANT"})
Local nPPRECO   := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRECO"})
Local nPNUMSC   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})  
Local nPITESC   := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_ITEMSC"}) 
Local lCheckTES := POSICIONE("SA2",1,xFilial("SA2")+cA120Forn+cA120Loj,"A2_EST") == "EX"
Local nMVLMPQAE := SuperGetMV("MV_X_LPQAE",,0)	//--PERCENTUAL DE LIMITE MAXIMO ACEITAVEL PARA QUANTIDADE/VALOR SUPERIOR AO CONTRATO DE COMPRAS.

cConta  := aCols[n, nPosConta]
cItem   := aCols[n, nPosIT ]
cCCusto := aCols[n, nPosCC]
cClasse := aCols[n, nPosCL]  
cProduto:= aCols[n, nPosProd] 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())	

//--Validação sobre Quantidade/Valor Unitário do pedido de Autorizaçào de Entrega
If nTipoPed == 2 .and. nPosProd > 0 .and. nPNUMSC > 0 .and. nPITESC > 0
	//--Contrato de compras
	dbSelectArea("SC3")
	dbSetOrder(3)	//--C3_FILIAL+C3_PRODUTO+C3_NUM+C3_ITEM
	If dbSeek(xFilial("SC3")+aCols[n,nPosProd]+aCols[n,nPNUMSC]+aCols[n,nPITESC])
		
		//--Validação sobre a quantidade
		nQTDEDISP := (SC3->C3_QUANT-SC3->C3_QUJE)
		If aCols[n,nPQUANT] > nQTDEDISP
			nQTDESUP := aCols[n,nPQUANT] - nQTDEDISP
			nPERCPED := Round( (nQTDESUP*100)/SC3->C3_QUANT , 2)
			If nPERCPED > nMVLMPQAE
				cTEXTO := "A quantidade informada ultrapassa a quantidade disponível do contrato e também o limite máximo aceitável."+chr(13)+chr(10)
				cTEXTO += "Percentual límite (MV_X_LPQAE) = "+cValToChar(nMVLMPQAE)
				Aviso("Aviso",cTEXTO,{"OK"})
				Return (.F.)
			EndIf
		EndIf
		
		//--Validação sobre o preço unitário
		If aCols[n,nPPRECO] > SC3->C3_PRECO
			nPERCPED := Round( ((aCols[n,nPPRECO]/SC3->C3_PRECO)-1)*100 , 2)
			If nPERCPED > nMVLMPQAE                                                
				cTEXTO := "O preço informado ultrapassa o preço do contrato e também o limite máximo aceitável."+chr(13)+chr(10)
				cTEXTO += "Percentual límite (MV_X_LPQAE) = "+cValToChar(nMVLMPQAE)
				Aviso("Aviso",cTEXTO,{"OK"})
				Return (.F.)
			EndIf
		EndIf
		
	EndIf
EndIf



//-- Validação do preenchimento do TES quando pedido de importação:
If lCheckTES .and. !ALLTRIM(FUNNAME()) $ "CNTA120/CNTA260/RPC"
	If Empty(aCols[n, nPosTES])
		Aviso( "TES Obrigatório!", "Favor informar o código TES para pedido de importação! ", {"OK"}, 3 )
		Return(.F.)
	EndIf
	
	//valida se o produto selecionado tem codigo de NCM preenchido.
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial()+cProduto)
	If Empty(SB1->B1_POSIPI)
		Aviso ("NCM Obrigatório!", "Favor verificar o código NCM no cadastro do produto: "+SB1->B1_COD , {"OK"}, 3)
		Return(.F.)            	
	EndIf                    
		
EndIf

//--Validação sobre relacionamento de compradores x famílias de produtos.
If !FVALFAM()
	Return(.F.)
EndIf

If Empty(cConta)
	Return(lRet)
End      

//--Validação sobre campos contábeis
If !ALLTRIM(FUNNAME()) $ "CNTA120/CNTA260/RPC"
	dbSelectArea("CT1")
	dbSetOrder(1) // FILIAL + CONTA
	If dbSeek(xFilial() + cConta)
	
		//--Centro de Custo é obrigatório!
		If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
			Aviso( "Centro de Custo Obrigatório !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT120LOK ", { "Ok" }, 3 )
			lRet := .F.
	
		//--Item Contábil é obrigatório!
		ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItem)
			Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT120LOK ", { "Ok" }, 3 ) 
			lRet := .F.
	
		//--Classe de Valor é obrigatório!
		ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasse)
			Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT120LOK ", { "Ok" }, 3 )
			lRet := .F.
		Endif
	EndIf	
Endif         


RestArea(aArea)

Return(lRet)

                         
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FVALFAM   ºAutor  ³Rafael Parma        º Data ³  15/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Validação sobre relacionamento de compradores x famílias deº±±
±±º          ³ produtos.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PROTHEUS                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------*
Static Function FVALFAM()
*---------------------------*
Local lRet  := .T.
Local lFlag := .F.
Local nPosPRD := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_PRODUTO"})
Local nPosNSC := aScan(aHeader,{|x| AllTrim(x[2]) == "C7_NUMSC"})
Local cCODCOM := ""
                                         

	//--Caso possua solicitação de compras não realiza bloqueio.
	If !Empty(aCols[n][nPosNSC]) 
		Return(lRet)
	EndIf

	//--Recupera código do comprador
	dbSelectArea("SY1")
	dbSetOrder(3)	//--Y1_FILIAL+Y1_USER
	dbGoTop()
	If dbSeek ( xFilial("SY1") + __CUSERID )
		
		cCODCOM := SY1->Y1_COD
	                                
		//--Recupera relacionamento comprador x família de produto
		dbSelectArea("Z44")
		dbSetOrder(2)	//--Z44_FILIAL+Z44_CODCOM+Z44_CODFAM
		dbGoTop()
		If dbSeek ( xFilial("Z44") + cCODCOM )                       
			
			While !Z44->(EOF()) .and. Z44->(Z44_FILIAL+Z44_CODCOM) == xFilial("Z44")+cCODCOM 
			
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek( xFilial("SB1") + aCols[n][nPosPRD] )
				
				dbSelectArea("Z27")
				dbSetOrder(1)	//Z27_FILIAL+Z27_CODIGO+Z27_CODGRP
				dbGoTop()
				If dbSeek ( xFilial("Z27") + Z44->Z44_CODFAM + SubSTR(SB1->B1_GRUPO,1,2) )
					If Len(ALLTRIM(Z27_CODGRP)) == 2
						lFlag := .T.
						Exit
					EndIf
				EndIf
				
				If !lFlag
					dbSelectArea("Z27")
					dbSetOrder(1)	//Z27_FILIAL+Z27_CODIGO+Z27_CODGRP
					dbGoTop()
					If dbSeek ( xFilial("Z27") + Z44->Z44_CODFAM + SB1->B1_GRUPO )
						lFlag := .T.
						Exit				
					EndIf
				EndIf
				
				If !lFlag
					dbSelectArea("Z27")
					dbSetOrder(5)	//Z27_FILIAL+Z27_CODIGO+Z27_PRODUT
					dbGoTop()
					If dbSeek ( xFilial("Z27") + Z44->Z44_CODFAM + SB1->B1_COD )
						lFlag := .T.
						Exit				
					EndIf
				EndIf
						
				Z44->(dbSkip())
			Enddo
			
			If ! lFlag
				MsgAlert("Este produto pertence a uma família de produtos não relacionada a este usuário!")
				lRet := .F.
			EndIf
			
		EndIf 
	EndIf              
	
Return (lRet)