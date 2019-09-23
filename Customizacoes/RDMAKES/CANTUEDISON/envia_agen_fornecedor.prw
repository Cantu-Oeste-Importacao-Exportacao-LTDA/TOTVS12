#include "rwmake.ch"
#include "topconn.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³envia_agen_fornecedorºAutor ³Edison G. barbieri³  25/02/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função que faz envio títulos agendados p pagamentos pelo  º±±
±± workflow, rodando conforme a necessidade do usuário.	        		  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro Oeste                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function WFAGPAG()
	Private oEnvwork
	Private cPerg     := "PAGFOR"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama abertura de perguntas SX1                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	Pergunte(cPerg,.F.)

	@ 200,001 TO 380,380 DIALOG oEnvwork TITLE OemToAnsi("Envia Workflow fornecedores")
	@ 002,010 TO 080,190
	@ 010,018 Say " Este programa faz a alteração dos vencimentos e envia workflow de "
	@ 018,018 Say " títulos agendados para pagamento de FORNECEDORES."
	@ 60,090 BMPBUTTON TYPE 01 ACTION U_ATUVCTO()
	@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oEnvwork)
	@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	//Variavel que recebe o conteudo do código de agendamento
	cCodagen	  := MV_PAR03

	Activate Dialog oEnvwork Centered

return

User Function ATUVCTO()

	Conout("Empresa atual: " + cEmpAnt)
	ConOut("Inicializando o processo")
	ConOut("BUSCANDO TÍTULOS PARA AGENDAMENTO...")

	cQuery := "SELECT PT2.PT2_NOME, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_X_DCRUR, E2.E2_VENCTO, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR - E2.E2_DECRESC AS VALOR, E2.R_E_C_N_O_ AS RNO"
	cQuery += " FROM " + RetSqlName("SE2")+ " E2"
	cQuery += " INNER JOIN " + RetSqlName("PT2")+ " PT2 ON PT2.PT2_FORNEC = E2.E2_FORNECE AND PT2.PT2_LOJA = E2.E2_LOJA "
	cQuery += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "' AND PT2.PT2_CODIGO = '" + %Exp:mv_par03%  + "'"
	cQuery += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par04%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par05%  + "'"
	cQuery += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par06%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par07%  + "'"
	cQuery += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par08)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par09)%  + "'"
	cQuery += " AND E2.E2_VENCTO 	>= '" + %Exp:DtoS(mv_par10)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par11)%  + "'"
	cQuery += " AND E2.E2_TIPO = 'NF' AND E2.E2_SALDO > 0  AND E2.d_e_l_e_t_ = ' ' AND PT2.d_e_l_e_t_ = ' '"

	TCQUERY cQuery NEW ALIAS "TEMPE2"
	DbSelectArea("TEMPE2")
	TEMPE2->(DbGoTop())

	nTotal := TEMPE2->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (TEMPE2->(Eof()))
		MsgAlert('Não existe relação para os parâmetros informados de envio de pagamento agendado!')
		Processa({|| U_WORKDEV() },"Processando...","Localizando notas de devolução... ")
		return
	endif

	While TEMPE2->(!Eof())
		nCount++
		SE2->(dbGoTo(TEMPE2->RNO))

		RecLock("SE2", .F.)

		SE2->E2_X_CDAGP := cCodagen

		SE2->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		TEMPE2->(dbSkip())
	EndDo

	//MsgInfo("Atualizado codigo de agendamento : "+ Str(nCount, 3, 0) + " registros com sucesso no contas a pagar.")

	TEMPE2->(dbCloseArea())

	Processa({|| U_ENVWORK() },"Processando...","Enviando workflow de notas agendadas... ")

Return

User Function ENVWORK()
	Local oProcess
	Local TMPSE2
	Local cQuery    := ""
	Local cEmail    := ""
	Local cEmails	:= ""
	Local aArea     := GetArea()
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= "PROGRAMAÇÃO DE PAGAMENTOS: DATA DE EMISSÃO "+ DTOC(DDATABASE)
	Local nCount 	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\titulo_agendado_fin.html")
	oProcess:cSubject := cAssunto

	PT2->(dbSetOrder(01))
	PT2->(dbSeek(xFilial("PT2") + cCodagen))
	cEmails := PT2->PT2_EMAIL

	oProcess:cTo  := cEmails
	oProcess:cCC  := LOWER(cEmail)

	oHTML := oProcess:oHTML

	cQuery := "SELECT PT2.PT2_NOME, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_X_DCRUR, E2.E2_VENCTO, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR - E2.E2_DECRESC AS VALOR, E2.R_E_C_N_O_ AS RNO"
	cQuery += " FROM " + RetSqlName("SE2")+ " E2"
	cQuery += " INNER JOIN " + RetSqlName("PT2")+ " PT2 ON PT2.PT2_FORNEC = E2.E2_FORNECE AND PT2.PT2_LOJA = E2.E2_LOJA "
	cQuery += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "' AND PT2.PT2_CODIGO = '" + %Exp:mv_par03%  + "'"
	cQuery += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par04%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par05%  + "'"
	cQuery += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par06%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par07%  + "'"
	cQuery += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par08)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par09)%  + "'"
	cQuery += " AND E2.E2_VENCTO 	>= '" + %Exp:DtoS(mv_par10)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par11)%  + "'"
	cQuery += " AND E2.E2_TIPO = 'NF' AND E2.E2_SALDO > 0  AND E2.d_e_l_e_t_ = ' ' AND PT2.d_e_l_e_t_ = ' '"

	TCQUERY cQuery NEW ALIAS "TMPSE2"
	DbSelectArea("TMPSE2")
	TMPSE2->(DbGoTop())

	if (TMPSE2->(Eof()))
		MsgAlert('Não existe relação para os parâmetros informados!')
		return
	endif

	While TMPSE2->(!EOF())

		AAdd((oHtml:ValByName("IT.COMPRADOR" )) , TMPSE2->PT2_NOME)
		AAdd((oHtml:ValByName("IT.EMISSAO"   )) , StoD(TMPSE2->E2_EMISSAO))
		AAdd((oHtml:ValByName("IT.TITULO"    )) , TMPSE2->E2_NUM + iif(!Empty(TMPSE2->E2_PARCELA), "/" + TMPSE2->E2_PARCELA, ""))
		AAdd((oHtml:ValByName("IT.NOTAPRO"    )), TMPSE2->E2_X_DCRUR)
		AAdd((oHtml:ValByName("IT.VENCIMENTO" )), StoD(TMPSE2->E2_VENCTO))
		AAdd((oHtml:ValByName("IT.FORNECEDOR" )), TMPSE2->E2_FORNECE + "/" + TMPSE2->E2_LOJA)
		AAdd((oHtml:ValByName("IT.NOMEFOR"    )), TMPSE2->E2_NOMFOR)
		AAdd((oHtml:ValByName("IT.VALOR" ))     , TMPSE2->VALOR)
		TMPSE2->(dbSkip())

	EndDo

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado para " + AllTrim(cEmails))
	MsgInfo("Enviado e-mail com sucesso para: " + AllTrim(cEmails))
	TMPSE2->(dbCloseArea())

	Processa({|| U_ATUFLOBS() },"Processando...","Atualizando campos Fleg e Obs... ")

return

User Function ATUFLOBS()

	cQuery := "SELECT PT2.PT2_NOME, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E2.E2_X_DCRUR, E2.E2_VENCTO, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR - E2.E2_DECRESC AS VALOR, E2.R_E_C_N_O_ AS RNO"
	cQuery += " FROM " + RetSqlName("SE2")+ " E2"
	cQuery += " INNER JOIN " + RetSqlName("PT2")+ " PT2 ON PT2.PT2_FORNEC = E2.E2_FORNECE AND PT2.PT2_LOJA = E2.E2_LOJA "
	cQuery += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "' AND PT2.PT2_CODIGO = '" + %Exp:mv_par03%  + "'"
	cQuery += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par04%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par05%  + "'"
	cQuery += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par06%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par07%  + "'"
	cQuery += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par08)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par09)%  + "'"
	cQuery += " AND E2.E2_VENCTO 	>= '" + %Exp:DtoS(mv_par10)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par11)%  + "'"
	cQuery += " AND E2.E2_TIPO = 'NF' AND E2.E2_SALDO > 0  AND E2.d_e_l_e_t_ = ' ' AND PT2.d_e_l_e_t_ = ' '"

	TCQUERY cQuery NEW ALIAS "SE2TMP"
	DbSelectArea("SE2TMP")
	SE2TMP->(DbGoTop())

	nTotal := SE2TMP->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (SE2TMP->(Eof()))
		MsgAlert('Não existe relação para os parâmetros informados para atualizaçao do campo flag!')
		return
	endif

	While SE2TMP->(!Eof())
		nCount++
		SE2->(dbGoTo(SE2TMP->RNO))

		RecLock("SE2", .F.)
		SE2->E2_X_AVCTO := "S"
		SE2->E2_HIST := "NAO TIRAR"

		SE2->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		SE2TMP->(dbSkip())
	EndDo

	SE2TMP->(dbCloseArea())

	Processa({|| U_WORKDEV() },"Processando...","Enviando notas de devolução... ")

Return

User Function WORKDEV()
	Local oProcess
	Local TMPSE2
	Local cQuery    := ""
	Local cEmail    := ""
	Local cEmails	:= ""
	Local aArea     := GetArea()
	Local cStatus 	:= SPACE(6)
	Local cAssunto	:= "DEVOLUÇÕES FORNECEDOR DATA DE EMISSÃO "+ DTOC(DDATABASE)
	Local nCount 	:= 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Monta o objeto de envio do workflow³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\titulo_devolucao_fin.html")
	oProcess:cSubject := cAssunto

	PT2->(dbSetOrder(01))
	PT2->(dbSeek(xFilial("PT2") + cCodagen))
	cEmails := PT2->PT2_EMAIL

	oProcess:cTo  := cEmails
	oProcess:cCC  := LOWER(cEmail)

	oHTML := oProcess:oHTML

	cQuery := "SELECT PT2.PT2_NOME, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, E5.E5_DOCUMEN, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR - E2.E2_DECRESC AS VALOR, E2.R_E_C_N_O_ AS RNO"
	cQuery += " FROM " + RetSqlName("SE2")+ " E2"
	cQuery += " INNER JOIN " + RetSqlName("PT2")+ " PT2 ON PT2.PT2_FORNEC = E2.E2_FORNECE AND PT2.PT2_LOJA = E2.E2_LOJA "
	cQuery += " INNER JOIN " + RetSqlName("SE5")+ " E5 ON E5.E5_FILIAL = E2.E2_FILIAL AND E5.E5_NUMERO = E2.E2_NUM AND E5.E5_PARCELA = E2.E2_PARCELA "
	cQuery += " AND E5.E5_CLIFOR = E2.E2_FORNECE AND E5.E5_LOJA = E2.E2_LOJA AND E5.E5_TIPO = E2.E2_TIPO "
	cQuery += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "' AND PT2.PT2_CODIGO = '" + %Exp:mv_par03%  + "'"
	cQuery += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par04%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par05%  + "'"
	cQuery += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par06%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par07%  + "'"
	cQuery += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par08)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par09)%  + "'"
	cQuery += " AND E2.E2_VENCTO 	>= '" + %Exp:DtoS(mv_par10)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par11)%  + "'"
	cQuery += " AND E2.E2_TIPO = 'NDF' AND E2.d_e_l_e_t_ = ' ' AND PT2.d_e_l_e_t_ = ' ' AND E5.d_e_l_e_t_ = ' '"

	TCQUERY cQuery NEW ALIAS "DEVSE2"
	DbSelectArea("DEVSE2")
	DEVSE2->(DbGoTop())

	if (DEVSE2->(Eof()))
		MsgAlert('Não existe relação para os parâmetros informados para envio de notas de devolucao!')
		return
	endif

	While DEVSE2->(!EOF())

		AAdd((oHtml:ValByName("IT.COMPRADOR" )) , DEVSE2->PT2_NOME)
		AAdd((oHtml:ValByName("IT.EMISSAO"   )) , StoD(DEVSE2->E2_EMISSAO))
		AAdd((oHtml:ValByName("IT.TITULO"    )) , DEVSE2->E2_NUM + iif(!Empty(DEVSE2->E2_PARCELA), "/" + DEVSE2->E2_PARCELA, ""))
		AAdd((oHtml:ValByName("IT.NOTADEV"    )), DEVSE2->E5_DOCUMEN)
		AAdd((oHtml:ValByName("IT.FORNECEDOR" )), DEVSE2->E2_FORNECE + "/" + DEVSE2->E2_LOJA)
		AAdd((oHtml:ValByName("IT.NOMEFOR"    )), DEVSE2->E2_NOMFOR)
		AAdd((oHtml:ValByName("IT.VALOR" ))     , DEVSE2->VALOR)
		DEVSE2->(dbSkip())

	EndDo

	// inicia o processo de envio de workflow
	oProcess:Start()

	// finaliza o processo iniciado com a sentenca TWFProcess():New( "<nome desta funcao>", "<descricao resumida do que faz>")
	oProcess:Finish()

	ConOut("Email enviado para DEVOLUCAO " + AllTrim(cEmails))
	MsgInfo("Enviado e-mail com sucesso para: " + AllTrim(cEmails))
	DEVSE2->(dbCloseArea())

	Processa({|| U_ATUFLDV() },"Processando...","Atualizando flag de notas de devolução... ")

return

User Function ATUFLDV()

	cQuery := "SELECT PT2.PT2_NOME, E2.E2_EMISSAO, E2.E2_NUM, E2.E2_PARCELA, SUBSTR(E5.E5_DOCUMEN,4,9), E2.E2_FORNECE, E2.E2_LOJA, E2.E2_NOMFOR, E2.E2_VALOR - E2.E2_DECRESC AS VALOR, E2.R_E_C_N_O_ AS RNO"
	cQuery += " FROM " + RetSqlName("SE2")+ " E2"
	cQuery += " INNER JOIN " + RetSqlName("PT2")+ " PT2 ON PT2.PT2_FORNEC = E2.E2_FORNECE AND PT2.PT2_LOJA = E2.E2_LOJA "
	cQuery += " INNER JOIN " + RetSqlName("SE5")+ " E5 ON E5.E5_FILIAL = E2.E2_FILIAL AND E5.E5_NUMERO = E2.E2_NUM AND E5.E5_PARCELA = E2.E2_PARCELA "
	cQuery += " AND E5.E5_CLIFOR = E2.E2_FORNECE AND E5.E5_LOJA = E2.E2_LOJA AND E5.E5_TIPO = E2.E2_TIPO "
	cQuery += " WHERE  E2.E2_FILIAL >= '" + %Exp:mv_par01% 		  + "' AND E2.E2_FILIAL	 <= '" + %Exp:mv_par02%  + "' AND PT2.PT2_CODIGO = '" + %Exp:mv_par03%  + "'"
	cQuery += " AND E2.E2_FORNECE 	>= '" + %Exp:mv_par04%  	  + "' AND E2.E2_FORNECE <= '" + %Exp:mv_par05%  + "'"
	cQuery += " AND E2.E2_LOJA 		>= '" + %Exp:mv_par06%  	  + "' AND E2.E2_LOJA 	 <= '" + %Exp:mv_par07%  + "'"
	cQuery += " AND E2.E2_EMISSAO 	>= '" + %Exp:DtoS(mv_par08)%  + "' AND E2.E2_EMISSAO <= '" + %Exp:DtoS(mv_par09)%  + "'"
	cQuery += " AND E2.E2_VENCTO 	>= '" + %Exp:DtoS(mv_par10)%  + "' AND E2.E2_VENCTO  <= '" + %Exp:DtoS(mv_par11)%  + "'"
	cQuery += " AND E2.E2_TIPO = 'NDF'  AND E2.d_e_l_e_t_ = ' ' AND PT2.d_e_l_e_t_ = ' ' AND E5.d_e_l_e_t_ = ' '"

	TCQUERY cQuery NEW ALIAS "SE2DEV"
	DbSelectArea("SE2DEV")
	SE2DEV->(DbGoTop())

	nTotal := SE2DEV->(RecCount())

	ProcRegua(nTotal)
	nCount := 0

	if (SE2DEV->(Eof()))
		MsgAlert('Não existe relação para os parâmetros informados para atualizaçao do campo flag devolucao!')
		return
	endif

	While SE2DEV->(!Eof())
		nCount++
		SE2->(dbGoTo(SE2DEV->RNO))

		RecLock("SE2", .F.)
		SE2->E2_X_AVCTO := "S"
		SE2->E2_X_CDAGP := cCodagen

		SE2->(MsUnlock())

		IncProc("Processados " + Str(nCount, 3, 0) + " registros")

		SE2DEV->(dbSkip())
	EndDo

	SE2DEV->(dbCloseArea())

	Close(oEnvwork)
Return
