#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT100LOK  ºAutor  ³                    º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Validação na Linha do Item do        º±±
±±º          ³ Documento de Entrada.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT100LOK() 

Local aArea := GetArea()
Local lRet := .T.

Local nPosConta  := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CONTA"})
Local nPosIT     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_ITEMCTA"})
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CC"}) 
Local nPosCL     := aScan(aHeader,{|x| AllTrim(x[2])=="D1_CLVL"}) 
Local nPosRat    := aScan(aHeader,{|x| AllTrim(x[2])=="D1_RATEIO"} )
Local nPosNori   := aScan(aHeader,{|x| AllTrim(x[2])=="D1_NFORI"} )



cConta  := aCols[n, nPosConta]
cItem   := aCols[n, nPosIT ]
cCCusto := aCols[n, nPosCC]
cClasse := aCols[n, nPosCL]
cRateio := aCols[n, nPosRat]
cNfori  := aCols[n, nPosNori]
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                           

If Empty(cConta)
	Return(lRet)
End


If SuperGetMV("MV_X_VALEN",,.T.)

        dbSelectArea("SA2")
		dbSetOrder(1) // filial + Fornecedor + loja
		If dbSeek(xFilial() + CA100FOR + CLOJA)
		
			If SA2->A2_TIPORUR == "F" .and. Empty(cNfori) .and. cTipo != "C"
				Aviso( "Lançamento de nota de produtor rural!", "Favor informar o numero da nota do produtor no campo Docto. Orig.")
				lRet := .F.
			Endif
		
		Endif


	If cRateio != "1"	//Rateio!=1-SIM

		dbSelectArea("CT1")
		dbSetOrder(1) // FILIAL + CONTA
		If dbSeek(xFilial() + cConta)
		
			//--Centro de Custo é obrigatório!
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
				Aviso( "Centro de Custo Obrigatório !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
				lRet := .F.
		
			//--Item Contábil é obrigatório!
			ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItem)
				Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 ) 
				lRet := .F.
		
			//--Classe de Valor é obrigatório!
			ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasse)
				Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MT100LOK ", { "Ok" }, 3 )
				lRet := .F.
			Endif
			
		Endif
	
	EndIf
	
	
		
Endif
RestArea(aArea)

Return(lRet)