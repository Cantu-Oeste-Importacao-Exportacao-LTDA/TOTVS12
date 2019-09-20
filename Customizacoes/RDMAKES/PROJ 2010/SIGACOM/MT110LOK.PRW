#INCLUDE "PROTHEUS.CH"        
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT110LOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada utilizado para validação da linha na inclu-º±±
±±º          ³são da solicitação de compras. Validação sobre solicitante xº±±
±±º          ³família de produtos.										  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*--------------------------*
User Function  MT110LOK()
*--------------------------*
Local lRet := .T.
Local lFlag := .F.
Local aArea := GetArea()
Local nPosPRD := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_PRODUTO'})     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Controle de alçadas por família de produtos do compras.                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 	
	If ALLTRIM(SuperGetMV("MV_X_CTRAC",,"N")) == "S"

		dbSelectArea("Z28")
		dbSetOrder(1)	//Z28_FILIAL+Z28_USRSOL+Z28_CODFAM 
		dbGoTop()
		If dbSeek ( xFilial("Z28") + __CUSERID )                       
			
			While !Z28->(EOF()) .and. Z28->Z28_FILIAL+Z28->Z28_USRSOL == xFilial("Z28")+__CUSERID
			
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek( xFilial("SB1") + aCols[n][nPosPRD] )
				
				dbSelectArea("Z27")
				dbSetOrder(1)	//Z27_FILIAL+Z27_CODIGO+Z27_CODGRP
				dbGoTop()
				If dbSeek ( xFilial("Z27") + Z28->Z28_CODFAM + SubSTR(SB1->B1_GRUPO,1,2) )
					If Len(ALLTRIM(Z27_CODGRP)) == 2
						lFlag := .T.
						Exit
					EndIf
				EndIf
				
				If !lFlag
					dbSelectArea("Z27")
					dbSetOrder(1)	//Z27_FILIAL+Z27_CODIGO+Z27_CODGRP
					dbGoTop()
					If dbSeek ( xFilial("Z27") + Z28->Z28_CODFAM + SB1->B1_GRUPO )
						lFlag := .T.
						Exit				
					EndIf
				EndIf
				
				If !lFlag
					dbSelectArea("Z27")
					dbSetOrder(5)	//Z27_FILIAL+Z27_CODIGO+Z27_PRODUT
					dbGoTop()
					If dbSeek ( xFilial("Z27") + Z28->Z28_CODFAM + SB1->B1_COD )
						lFlag := .T.
						Exit				
					EndIf
				EndIf
						
				Z28->(dbSkip())
			Enddo
			
			If ! lFlag
				MsgAlert("Este produto pertence a uma família de produtos não relacionada a este usuário!")
				lRet := .F.
			EndIf
					
		Else
		
			MsgAlert("Usuário não cadastrado na tabela de Solicitantes x Famílias de produtos")
			lRet := .F.
		
		EndIf 
	
	EndIf
	
	If lRet
		lRet := fVal110()
	EndIf

	
Return(lRet)             


*--------------------------*
Static Function fVal110()
*--------------------------*


Local aArea := GetArea()
Local lRet := .T.

Local nPosConta := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CONTA"})
Local nPosIT    := aScan(aHeader,{|x| AllTrim(x[2])=="C1_ITEMCTA"})
Local nPosCC    := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CC"})
Local nPosCL    := aScan(aHeader,{|x| AllTrim(x[2])=="C1_CLVL"})  

cConta  := aCols[n, nPosConta]
cItem   := aCols[n, nPosIT ]
cCCusto := aCols[n, nPosCC]
cClasse := aCols[n, nPosCL]


If Empty(cConta)
	Return(lRet)
End

If SuperGetMV("MV_X_VALEN",,.T.)

	dbSelectArea("CT1")
	dbSetOrder(1) // FILIAL + CONTA
	If dbSeek(xFilial() + cConta)
	
		//--Centro de Custo é obrigatório!
		If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
			Aviso( "Centro de Custo Obrigatório !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT110LOK ", { "Ok" }, 3 )
			lRet := .F.
	
		//--Item Contábil é obrigatório!
		ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItem)
			Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT110LOK ", { "Ok" }, 3 ) 
			lRet := .F.
	
		//--Classe de Valor é obrigatório!
		ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasse)
			Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT110LOK ", { "Ok" }, 3 )
			lRet := .F.
		Endif
		
	Endif

Endif
RestArea(aArea)

Return(lRet)