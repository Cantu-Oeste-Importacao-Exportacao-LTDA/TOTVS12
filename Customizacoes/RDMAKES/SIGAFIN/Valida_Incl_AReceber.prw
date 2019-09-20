#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA040INC º Autor ³ Adriano Novachaelley Data ³  27/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ O ponto de entrada FA040INC sera utilizado na validacao da º±±
±±º          ³ inclusao de titulos no contas a receber.                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ FINA040 -> Contas a receber/FINA740 -> Func. Ctas Receber  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Validar a quantidade de digitos do campo SE1->E1_NUM. 
// Deve ser igual ao tamanho padrao do campo.
                                                    
User Function FA040INC()
Local lRet	:= .T.
Local _aArea	:= GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If AllTrim(FunName()) $ "FINA740/FINA040" .And. Inclui
	If Len(AllTrim(M->E1_NUM)) <> TamSX3("E1_NUM")[1] 
		MsgAlert("O campo No. Titulo deve ser preenchido com "+AllTrim(Str((TamSX3("E1_NUM")[1])))+" caracteres.")
	    lRet	:= .F.
	Endif
Endif

//-- Rafael: 30/05/2011 - Validação para preenchimento dos campos Segmento/Centro de custo, inclusão manual.
If lRet
	If ! lF040Auto .and. AllTrim(FunName()) $ "FINA740/FINA040" .And. Inclui
		If M->E1_MULTNAT != "1"
			If Empty(M->E1_CCC) .or. Empty(M->E1_CLVLCR)
				Aviso("Atenção","Os campos de segmento e centro de custo devem ser preenchidos.",{"OK"},2)
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf


If lRet
	lRet := FVALDIV()
EndIf

RestArea(_aArea)

Return(lRet)
     

*--------------------------*
Static Function FVALDIV()
*--------------------------*
Local aArea := GetArea()
Local lRet  	:= .T.
Local cConta    := ""
Local cCCusto   := ""
Local cItemCta  := ""
Local cClasVlr  := ""
Local cNatureza := M->E1_NATUREZ

/*	cCCusto  := M->E1_CCC
	cItemCta := M->E1_ITEMC
	cClasVlr := M->E1_CLVLCR*/
//Guilherme 05/11/2013 - Alterado para puxar a área da SE1 ao invés da Memoria
   	cCCusto  := SE1->E1_CCC
	cItemCta := SE1->E1_ITEMC
	cClasVlr := SE1->E1_CLVLCR

If SuperGetMV("MV_X_VALEN",,.T.)

	dbSelectArea("SED")
	dbSetOrder(1) // FILIAL + CODIGO
	If dbSeek( xFilial() + cNatureza ) 
		
		cConta   := ED_DEBITO
		
		If Empty(cConta)
			Return(lRet)
		End	
		
		dbSelectArea("CT1")
		dbSetOrder(1) // FILIAL + CONTA
		If dbSeek(xFilial() + cConta)
		
			//--Centro de Custo é obrigatório!
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
				Aviso( "Centro de Custo Obrigatório !", "Favor informar o C. Custo Cred., conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA040INC ", { "Ok" }, 3 )
				lRet := .F.
		
			//--Item Contábil é obrigatório!
			ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItemCta)
				Aviso( "Centro de Trabalho Obrigatório !", "Favor informar o Item Ctb. Cred.,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA040INC ", { "Ok" }, 3 ) 
				lRet := .F.
		
			//--Classe de Valor é obrigatório!
			ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasVlr)
				Aviso( "Segmento Deb. Obrigatório!", "Favor informar Segmento Cred.,  conforme obrigatoriedade da Conta Contábil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
				"Qualquer dúvida entre em contato com o Departamento Contábil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA040INC ", { "Ok" }, 3 )
				lRet := .F.
			Endif
			
		Endif
	Endif
Endif
RestArea(aArea)

Return(lRet)