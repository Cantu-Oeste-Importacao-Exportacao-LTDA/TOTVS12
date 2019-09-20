#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTA105LIN  ºAutor  ³                   º Data ³  30/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Validação na Linha do Item da        º±±
±±º          ³ Solicitação ao Armazem.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA105LIN() 

Local aArea := GetArea()
Local lRet := .T.

Local nPosConta := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CONTA"})
Local nPosIT    := aScan(aHeader,{|x| AllTrim(x[2])=="CP_ITEMCTA"})
Local nPosCC    := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CC"})
Local nPosCL    := aScan(aHeader,{|x| AllTrim(x[2])=="CP_CLVL"})  

cConta  := aCols[n, nPosConta]
cItem   := aCols[n, nPosIT ]
cCCusto := aCols[n, nPosCC]
cClasse := aCols[n, nPosCL]    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


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
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MTA105LIN ", { "Ok" }, 3 )
			lRet := .F.
	
		//--Item Contábil é obrigatório!
		ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItem)
			Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MTA105LIN ", { "Ok" }, 3 ) 
			lRet := .F.
	
		//--Classe de Valor é obrigatório!
		ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasse)
			Aviso( "Segmento Obrigatório!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
			"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_MTA105LIN ", { "Ok" }, 3 )
			lRet := .F.
		Endif
		
	Endif

Endif
RestArea(aArea)

Return(lRet)