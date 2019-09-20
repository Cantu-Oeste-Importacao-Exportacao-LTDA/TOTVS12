#include "rwmake.ch"
#INCLUDE "TopConn.ch"

/*
+----------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Carlos Eduardo                                          !
+------------------+---------------------------------------------------------+
!Descricao         ! Rotina para correção da tabela SE5 com base na SE1 e SE2!
!				           ! na compensação dos titulos a receber.                   !
+------------------+---------------------------------------------------------+
!Nome              ! AcertaSE5                                               !
+------------------+---------------------------------------------------------+
!Data de Criacao   ! 19/04/2012                                              !
+------------------+---------------------------------------------------------+
*/


User Function AcertaSE5 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

                       
If MsgYesNo("Deseja executar o acerto de Segmento e Centro de Custo na tabela SE5?")
	
	// Chama a rotina ProcCons para executar o processamento da regua.
	Processa( {|| ProcCons() }, "Aguarde...", "Carregando registros para correção...",.F.)
	
Endif

Return

Static Function ProcCons
Local nQuant := 0

// Consulta de registros na SE5 que não tenham os dados de segmento, conta contabil e itens preenchidos conforme SE1 e SE2

cQuery := " SELECT SE5.R_E_C_N_O_ SE5REC, SE1.R_E_C_N_O_ SE1REC, SE2.R_E_C_N_O_ SE2REC, "
cQuery += " SE1.E1_CLVLDB, SE1.E1_CLVLCR, SE1.E1_CCD, SE1.E1_CCC, SE1.E1_ITEMD, SE1.E1_ITEMC, "
cQuery += " SE2.E2_CLVLDB, SE2.E2_CLVLCR, SE2.E2_CCD, SE2.E2_CCC, SE2.E2_ITEMD, SE2.E2_ITEMC "
cQuery += " From "
cQuery += RetSqlName("SE5")+ " SE5 "

// Seleciona titulos de contas a receber
cQuery += " LEFT JOIN "+RetSqlName("SE1")+ " SE1 ON SE1.E1_FILIAL = SE5.E5_FILIAL AND SE1.E1_PREFIXO = SE5.E5_PREFIXO  "
cQuery += " AND SE1.E1_NUM = SE5.E5_NUMERO AND SE1.E1_PARCELA = SE5.E5_PARCELA AND SE1.E1_TIPO = SE5.E5_TIPO "
cQuery += " AND SE1.E1_CLIENTE = SE5.E5_CLIFOR AND SE1.E1_LOJA = SE5.E5_LOJA  AND SE1.E1_NATUREZ = SE5.E5_NATUREZ AND SE1.D_E_L_E_T_ <> '*' "
// Seleciona titulos de contas a pagar
cQuery += " LEFT JOIN "+RetSqlName("SE2")+ " SE2 ON SE2.E2_FILIAL = SE5.E5_FILIAL AND SE2.E2_PREFIXO = SE5.E5_PREFIXO "
cQuery += " AND SE2.E2_NUM = SE5.E5_NUMERO AND SE2.E2_PARCELA = SE5.E5_PARCELA AND SE2.E2_TIPO = SE5.E5_TIPO "
cQuery += " AND SE2.E2_FORNECE = SE5.E5_FORNECE AND SE2.E2_LOJA = SE5.E5_LOJA AND SE2.E2_NATUREZ = SE5.E5_NATUREZ AND SE2.D_E_L_E_T_ <> '*' "
//Seleciona registros no movimento bancario
cQuery += " Where  SE5.D_E_L_E_T_  <> '*'
// Caso qualquer campo a seguir esteja vazio o resultado entra na pesquisa
cQuery += " AND ( SE5.E5_CLVLDB = ' 'OR SE5.E5_CLVLCR = ' ' OR SE5.E5_CCD = ' '  OR SE5.E5_CCC = ' ' OR SE5.E5_ITEMD = ' ' OR SE5.E5_ITEMC = ' ')
// Caso o registro no contas a receber ou a pagar seja diferente do registro da SE5 entra na consulta
cQuery += " AND ( SE5.E5_CLVLDB <> SE1.E1_CLVLDB OR SE5.E5_CLVLCR <> SE1.E1_CLVLCR
cQuery += "          OR SE5.E5_CCD <> SE1.E1_CCD  OR SE5.E5_CCC <> SE1.E1_CCC OR SE5.E5_ITEMD <> SE1.E1_ITEMD  OR SE5.E5_ITEMC <> SE1.E1_ITEMC
cQuery += "          OR  SE5.E5_CLVLDB <> SE2.E2_CLVLDB OR SE5.E5_CLVLCR <> SE2.E2_CLVLCR
cQuery += "          OR SE5.E5_CCD <> SE2.E2_CCD  OR SE5.E5_CCC <> SE2.E2_CCC OR SE5.E5_ITEMD <> SE2.E2_ITEMD  OR SE5.E5_ITEMC <> SE2.E2_ITEMC)
// Retira os titulos de multi natureza
cQuery += " AND SE5.E5_MULTNAT <> '1'
// Cria temporaria
TcQuery cQuery New Alias "QRYE5"

// Conta a quantidade de registros que a consulta retornou
Count To nRecCount

// Valida se existem registros para atualizar
If nRecCount > 0
	// Posiciona no primeiro registro da temporaria, pois o "Cout to" deixa a temporaria posicionado no ultimo registro
	QRYE5->(DbGoTop())	
	// Define o final da regua
	ProcRegua(nRecCount)
	
	// laço para efetuar as alteração dos registros da SE5
	While !QRYE5->(EOF())
		
		// Atualiza registros da SE5 com base na SE1
		if !Empty(QRYE5->SE1REC)
			SE5->(DbGoTo(QRYE5->SE5REC))

			RecLock("SE5",.F.)
				if Empty(SE5->E5_CLVLDB) 
					SE5->E5_CLVLDB	= QRYE5->E1_CLVLDB
				Endif
				If Empty(SE5->E5_CLVLCR)
					SE5->E5_CLVLCR	= QRYE5->E1_CLVLCR
				Endif
				If Empty(SE5->E5_CCD)
					SE5->E5_CCD			= QRYE5->E1_CCD
				Endif
				If Empty(SE5->E5_CCC)
					SE5->E5_CCC			= QRYE5->E1_CCC
				Endif
				If Empty(SE5->E5_ITEMD)
					SE5->E5_ITEMD		= QRYE5->E1_ITEMD
				Endif
				If Empty(SE5->E5_ITEMC)
					SE5->E5_ITEMC		= QRYE5->E1_ITEMC
				Endif
			MsUnLock()  
			
		Else
		// Atualiza registros da SE5 com base na SE2
			SE5->(DbGoTo(QRYE5->SE5REC)) 
			
			RecLock("SE5",.F.)
				If Empty(SE5->E5_CLVLDB)
					SE5->E5_CLVLDB	= QRYE5->E2_CLVLDB
				Endif
				If Empty(SE5->E5_CLVLCR)
					SE5->E5_CLVLCR	= QRYE5->E2_CLVLCR
				Endif
				If Empty(SE5->E5_CCD)
					SE5->E5_CCD	= QRYE5->E2_CCD
				Endif
				If Empty(SE5->E5_CCC)
					SE5->E5_CCC			= QRYE5->E2_CCC
				Endif
				If Empty(SE5->E5_ITEMD)
					SE5->E5_ITEMD		= QRYE5->E2_ITEMD
				Endif
				If Empty(SE5->E5_ITEMC)
					SE5->E5_ITEMC		= QRYE5->E2_ITEMC
				Endif
			MsUnLock()  
		Endif		
		
		// Contador da posição atual da regua
		nQuant++
		IncProc("Atualizando registro "+cValToChar(nQuant)+" de "+cValToChar(nRecCount)+ " na SE5."  )
		QRYE5->(DbSkip())
		
		
	EndDo
	// Mensagem de finalização da rotina caso tenha executado atualizações
	MsgInfo("A rotina atualizou os registros.")
Else
	// Mensagem de finalização da rotina caso Não tenha executado atualizações
	MsgInfo("Não foram encontrados registros para atualização.")	

Endif


Return