#include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F100TOK   �Autor  �                    � Data �  30/12/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para Valida��o ao Confirmar a inclus�o do ���
���          � Movimento Banc�rio.                                        ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F100TOK() 

Local aArea := GetArea()
Local lRet  	:= .T.
Local cConta    := ""
Local cCCusto   := ""
Local cItemCta  := ""
Local cClasVlr  := ""
Local cNatureza := M->E5_NATUREZ 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

IF cRecPag == "P"
	cCCusto  := M->E5_CCD
	cItemCta := M->E5_ITEMD
	cClasVlr := M->E5_CLVLDB 
ELSE
	cCCusto  := M->E5_CCC
	cItemCta := M->E5_ITEMC
	cClasVlr := M->E5_CLVLCR
ENDIF

If SuperGetMV("MV_X_VALEN",,.T.)

	dbSelectArea("SED")
	dbSetOrder(1) // FILIAL + CODIGO
	If dbSeek( xFilial() + cNatureza ) 
		
		If cRecPag == "P" // Se for Movimento a Pagar
			cConta   := ED_DEBITO
		Else			 // Se for Movimento a Receber
			cConta   := ED_CREDIT
		Endif
		
		If Empty(cConta)
			Return(lRet)
		End	
		
		dbSelectArea("CT1")
		dbSetOrder(1) // FILIAL + CONTA
		If dbSeek(xFilial() + cConta)
		
			//--Centro de Custo � obrigat�rio!
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
				Aviso( "Centro de Custo Obrigat�rio !", "Favor informar o Centro de Custo, conforme obrigatoriedade da Conta Cont�bil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer d�vida entre em contato com o Departamento Cont�bil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 )
				lRet := .F.
		
			//--Item Cont�bil � obrigat�rio!
			ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItemCta)
				Aviso( "Centro de Trabalho Obrigat�rio !", "Favor informar o Centro de Trabalho,  conforme obrigatoriedade da Conta Cont�bil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer d�vida entre em contato com o Departamento Cont�bil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 ) 
				lRet := .F.
		
			//--Classe de Valor � obrigat�rio!
			ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasVlr)
				Aviso( "Segmento Obrigat�rio!", "Favor informar Segmento,  conforme obrigatoriedade da Conta Cont�bil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer d�vida entre em contato com o Departamento Cont�bil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_F100TOK ", { "Ok" }, 3 )
				lRet := .F.
			Endif
			
		Endif
	Endif
Endif
RestArea(aArea)

Return(lRet)