//#include "FINA410.CH"
#Include "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FINA410    ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 02.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Refaz acumulados de Clientes/Fornecedores                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FINA410()                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function RJFINP02()

Local nOpca       := 0 
Local aSays       := {} 
Local aButtons    := {}
Local cMODIMP 	  := "FIN"
//Local nDias       := dDataBase -180

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Fixado como Verdadeiro para utilizar execução via schedule³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private lDireto   := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Título do Processo: "Refaz Dados Clientes/Fornecedores"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cCadastro := OemToAnsi("Refaz Dados Clientes/fornecedores")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seta o tipo 'Processo' ou 'Relatório', Grupo de Pergunta e Título do Processamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//SchedDef("P", "FINA410", "AFI410", {"","",""}, "S", {"Calculos de analise de credito","",""}, {"Calculos de analise de credito","",""}, "")

If lDireto 
    
	RPCSetType(3)
    PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO cMODIMP
     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Criação de arquivo temporário sobre a execução da rotina, devido a execução N vezes pelo schedule decorrente das threads³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nLock := 0
	While !LockByName("RJFINP02",.T.,.F.,.T.)
		nLock += 1
		Sleep(1000)                                    	
		If nLock > 10                                 
			ConOut("CONTROLE DE SEMÁFORO - RJFINP02 JÁ SE ENCONTRA EM EXECUÇÃO!") 
			conout("RJFINP02 - FIM DA EXECUCAO: "+DTOS(Date())+TIME())
			Return
		EndIf		
	EndDo
	
	conout("RJFINP02 - INICIO EXECUCAO SEM INTERFACE: "+DTOS(Date())+TIME())
	Pergunte("AFI410",.F. )	
	Fa410ProcRJ(.T.)
	
	conout("RJFINP02 - FIM EXECUCAO SEM INTERFACE: "+DTOS(Date())+TIME())

Else

	Pergunte("AFI410",.f.)
	AADD(aSays, OemToAnsi("  este programa tem como objectivo recalcular os saldos acumulados de    "))  //"  Este programa tem como objetivo recalcular os saldos acumulados de    "
	AADD(aSays, OemToAnsi("Clientes e/ou fornecedores.                                             "))  //"clientes e/ou fornecedores.                                             "
	AADD(aButtons, { 1,.T.,{|o| nOpca:= 1,o:oWnd:End()}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI410",.T. ) } } )
	FormBatch( cCadastro, aSays, aButtons )
	
	
	//--Execução sem interface (schedule)
	If  nOpcA == 1 
		conout("RJFINP02 - EXECUCAO COM INTERFACE: "+DTOS(Date())+TIME())
		Processa({|lEnd| Fa410ProcRJ()})  // Chamada da funcao de recalculos
		MsgInfo("Finalizado processamento")
	Endif
	
EndIf
       
conout("RJFINP02 - FIM DA EXECUCAO: "+DTOS(Date())+TIME())
RpcClearEnv()

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fa410Process³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 02.05.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Reprocessamento arquivos de cliente/fornecedor                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fa410Processa()                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nao ha'                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGAFIN                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³	MOTIVO DA ALTERACAO	  					³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Geronimo     ³16/02/06³093518³correção consiste em que nas vendas efe   ³±±
±±³              ³        ³      ³tuadas pelo Sigaloja, nas formas de pgto  ³±±
±±³ 	         ³        ³      ³CC ou CD” atualizo os dados do cliente e  ³±±
±±³          	 ³        ³      ³não da administradora como anteriormente 	³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function Fa410ProcRJ(lBat)

Local nValForte := 0
Local nSaldoTit := 0
Local nMoeda  	:= Int(Val(GetMv("MV_MCUSTO")))
Local nMoedaF 	:= 0
Local cFilBusca := "  "
Local nTaxaM	:= 0
Local lRet      := .T.
Local aBaixas
Local lLojaCartao := .F.	// Indica se eh rotina chamada pelo modulo sigaloja e se forma de pagamento eh cartao.
Local nMCusto	:= Val(GetMV("MV_MCUSTO"))
Local lE1MsFil  := SE1->(FieldPos("E1_MSFIL") > 0)	
Local cFilSF2   := xFilial("SF2")

Local aDADOSEMP	:= {}
Local aDADOSCLI := {}
Local aEMPMEDAT := {}
Local cEMPATU 	:= cEmpAnt
Local cFILATU 	:= cFilAnt
Local cMODIMP 	:= "FIN"   

Local cMVPAR01  := mv_par01
Local cMVPAR02  := mv_par02
Local cMVPAR03  := mv_par03
Local cMVPAR04  := mv_par04
Local cMVPAR05  := mv_par05
Local cMVPAR06  := mv_par06

// Fim das variaveis utilizadas na chamada da stored procedure
DEFAULT lBat	:= .F.


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica parametros informados                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If lDireto
		cMVPAR01  := 2				//--Refaz Dados de ?  1-Ambos, 2-Cliente, 3-Fornecedor            
		cMVPAR02  := 1				//--Recalcular Dados Historicos ? 1-Sim, 2-Nao
		cMVPAR03  := "000000001"	//--Do Cliente ?                  
		cMVPAR04  := "999999999"	//--Ate Cliente ?                 
		cMVPAR05  := "000000001"	//--Do Fornecedor ?               
		cMVPAR06  := "999999999"	//--Ate Fornecedor ?              		
		conout("RJFINP02 - PARAMETROS SETADOS.")
	EndIf
		
		
	If !lBat
		If cMVPAR01 == 1
			ProcRegua(SA1->(RecCount())+SA2->(RecCount())+SE1->(RecCount())+SE2->(RecCount()))
		/*Elseif cMVPAR01 == 2
			ProcRegua(SA1->(RecCount())+SE1->(RecCount()))*/
		ElseIf cMVPAR01 == 3
			ProcRegua(SA2->(RecCount())+SE2->(RecCount()))
		EndIf
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cadastro de Clientes                                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cMVPAR01 != 3
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Flavio - Faz por sql para diminuir o tempo de execuçao³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cSql := "UPDATE " + RetSqlName("SA1") + " SET A1_MSALDO = 0, A1_SALDUPM = 0, A1_SALDUP = 0, A1_SALFIN = 0, A1_SALFINM = 0, A1_VACUM = 0 "
		If cMVPAR02 == 1
			cSql += ", A1_METR = 0, A1_MATR = 0, A1_MAIDUPL = 0, A1_ATR = 0, A1_PAGATR = 0, A1_NROPAG = 0, A1_MCOMPRA = 0, A1_NROCOM = 0 "
    EndIf
		cSql +=	"WHERE A1_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' "		
		TcSqlExec(cSql)

	EndIf
	
	If cMVPAR01 != 2
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Cadastro de Fornecedores                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea( "SA2" )
		If Empty(cMVPAR05)		
			dbGotop()
		Else                 
			dbSetOrder(1)				
			DBGoTop()
			//DbSeek(xFilial("SA2")+cMVPAR05, .F.)		
		EndIf		
		While !Eof()
			If !lBat		
				IncProc()
			EndIf
			If SA2->A2_COD >= cMVPAR05 .And. SA2->A2_COD <= cMVPAR06
		     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Ponto de entrada para filtro dos registros                      ³
		    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			   If ExistBlock("FIN410FT")
					lRet := ExecBlock("FIN410FT",.F.,.F.,{cMVPAR01,"2"})
					If !lRet 
						dbSkip()
						Loop
		     	   EndIf	
				Endif				
				Reclock( "SA2" )
				SA2->A2_SALDUP  := 0
				SA2->A2_SALDUPM := 0
				SA2->A2_MCOMPRA := 0 				
				If FieldPos("A2_MNOTA") <> 0
					SA2->A2_MNOTA   := 0
				EndIf
				MsUnlock()
			Endif	
			dbSkip( )
		Enddo
	EndIf	
	
	dbSelectArea("SM0")
	cEMPMEDAT := ""
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If ! SM0->M0_CODFIL == "99" 
			aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL } )
		EndIf
		If cEMPMEDAT != SM0->M0_CODIGO
			aAdd ( aEMPMEDAT, SM0->M0_CODIGO )
		EndIf
		cEMPMEDAT := SM0->M0_CODIGO
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)	
	              
	aArea := GetArea()
	         
	__cEMPTOT := ""
	
	if !lBat
		ProcRegua(Len(aDADOSEMP))
	EndIf
	
	For nEMP := 1 To Len(aDADOSEMP)
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Prepara ambiente/módulo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SM0")
		dbSetOrder(1)
		If !dbSeek ( aDADOSEMP[nEMP][01] )
			conout("RJFINP02 - Empresa "+aDADOSEMP[nEMP][01]+" não existente no SIGAMAT.")
			Loop   
		EndIf
		
		If __cEMPTOT == aDADOSEMP[nEMP][01]
			Loop
		EndIf		
		__cEMPTOT := aDADOSEMP[nEMP][01]
		
		
		RpcClearEnv()
		RPCSetType(3)
		                                              
		PREPARE ENVIRONMENT EMPRESA (aDADOSEMP[nEMP][01]) FILIAL (aDADOSEMP[nEMP][02]) MODULO cMODIMP 
		
		
		conout("RJFINP02 - INICIO DO PROCESSAMENTO DE REGISTROS DA EMPRESA: "+aDADOSEMP[nEMP][01]+" - "+DTOS(Date())+TIME())
		
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Titulos a Receber - Atualiza saldos clientes                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If cMVPAR01 != 3
		
			conout("RJFINP02 - PROCESSANDO TITULOS A RECEBER DA EMPRESA: "+aDADOSEMP[nEMP][01]+" - "+DTOS(Date())+TIME())
			
			
			/*************************************************************************************************
			 Flavio - 28/02/2012 - Faz o processamento no banco usando recursos do mesmo para acelerar os cálculos 
			  e somente faz pelo microsiga para moedas diferentes da 1			
			Parte customizada do cálculo
			**************************************************************************************************/
			SA1->(dbSetOrder(01))
			
			cAbat := MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
			
			// totais gerais, desconsiderando as NCC
			cSql = "select e1_cliente, e1_loja, "
			cSql += "MAX(E1_EMISSAO) AS ULT_COMPRA, "
			cSql += "MIN(E1_EMISSAO) AS PRI_COMPRA, "
			cSql += "MAX(E1_VALOR) AS MAIOR_COMPRA, "
			cSql += "SUM(E1_VALOR) AS VALORTOT, "			
			cSql += "COUNT(*) AS NROCOMRAS "
			cSql += "from " + RetSqlName("SE1") + " "
			cSql += "WHERE E1_CLIENTE BETWEEN '"+ cMVPAR03 +"' AND '"+ cMVPAR04 +"' "
			cSql += "AND NOT INSTR('" + cAbat + "', e1_tipo) > 0   "
			cSql += "AND E1_MOEDA = 1 AND D_E_L_E_T_ <> '*' "
			cSql += "group by e1_cliente, e1_loja "
			cSql += "order by e1_cliente, e1_loja "
			
			TcQuery cSql new Alias "TMPSE1"			
			While TMPSE1->(!Eof())
				if SA1->(dbSeek(xFilial("SA1") + TMPSE1->E1_CLIENTE + TMPSE1->E1_LOJA))
					ConOut("Atualizando cliente " + TMPSE1->E1_CLIENTE + " / " + TMPSE1->E1_LOJA + SA1->A1_NREDUZ)
					RecLock("SA1", .F.)
					//if (SToD(TMPSE1->ULT_COMPRA) > SA1->A1_ULTCOM)
					//	SA1->A1_ULTCOM := StoD(TMPSE1->ULT_COMPRA)
					//EndIf
					
					if (TMPSE1->MAIOR_COMPRA > SA1->A1_MCOMPRA)
						SA1->A1_MCOMPRA := TMPSE1->MAIOR_COMPRA
					EndIf
					
					SA1->A1_NROCOM += TMPSE1->NROCOMRAS
					
					SA1->A1_VACUM += TMPSE1->VALORTOT
					
					if (TMPSE1->MAIOR_COMPRA > SA1->A1_MAIDUPL)
						SA1->A1_MAIDUPL := TMPSE1->MAIOR_COMPRA
					EndIf
	
					SA1->(MsUnlock())
				EndIf
				TMPSE1->(dbSkip())
			EndDo
			TMPSE1->(dbCloseArea())
			
			// Cálculo de atrasos
			cSql := "select e1_cliente, e1_loja, "
			cSql += "max(to_date(E1_BAIXA,'yyyymmdd') -  to_date(E1_VENCREA,'yyyymmdd')) as MATRASO, "
			cSql += "sum(case when to_date(E1_BAIXA,'yyyymmdd') -  to_date(E1_VENCREA,'yyyymmdd') > 0 then e1_valor else 0 end) as PGATRASO, "
//			cSql += "(sum(case when to_date(E1_BAIXA,'yyyymmdd') -  to_date(E1_VENCREA,'yyyymmdd') > 0 then " 
//			cSql += " to_date(E1_BAIXA,'yyyymmdd') -  to_date(E1_VENCREA,'yyyymmdd') else 0 end * E1_VALOR) / "
//			cSql += "sum(case when to_date(E1_BAIXA,'yyyymmdd') -  to_date(E1_VENCREA,'yyyymmdd') > 0 then e1_valor else 0.01 end)) as MDATRASOS, "
			cSql += "sum(case when e1_baixa <> ' ' then 1 else 0 end) as PAGAMENTOS "
			cSql += "from " + RetSqlName("SE1") + "  "
			cSql += "where E1_VENCREA <> ' '  "
			cSql += "AND E1_CLIENTE BETWEEN '"+ cMVPAR03 +"' AND '"+ cMVPAR04 +"' "
			cSql += "and E1_BAIXA <> ' ' "
			cSql += "and E1_MOEDA = 1 AND D_E_L_E_T_ <> '*' "
			cSql += "and not INSTR('" + cAbat + "', e1_tipo) > 0 "
			cSql += "group by e1_cliente, e1_loja "
			cSql += "order by e1_cliente, e1_loja "
			
			TcQuery cSql new Alias "TMPSE1"			
			While TMPSE1->(!Eof())
				if SA1->(dbSeek(xFilial("SA1") + TMPSE1->E1_CLIENTE + TMPSE1->E1_LOJA))
					RecLock("SA1", .F.)
					// calcula a média de atraso considerando os dados já gravados
					//SA1->A1_METR := Min(((SA1->A1_METR * SA1->A1_PAGATR) + (TMPSE1->MDATRASOS * TMPSE1->PGATRASO)) / (SA1->A1_PAGATR + TMPSE1->PGATRASO), 999)
					
					// Soma os pagamentos
					SA1->A1_NROPAG += TMPSE1->PAGAMENTOS
					if (TMPSE1->MATRASO > SA1->A1_MATR)
						SA1->A1_MATR := TMPSE1->MATRASO
					EndIf
					
					// Pagamento em atraso
					SA1->A1_PAGATR += TMPSE1->PGATRASO
					
					SA1->(MsUnlock())
				EndIf
				TMPSE1->(dbSkip())
			EndDo
			TMPSE1->(dbCloseArea())
			
			// Saldo das duplicatas, considerando NCC
			cSql = "select e1_cliente, e1_loja, "
			cSql += "SUM(CASE WHEN INSTR('" + cAbat + "', e1_tipo) > 0 THEN E1_SALDO * (-1) ELSE E1_SALDO END) AS SOMADUP "
			cSql += "from " + RetSqlName("SE1") + "  "
			cSql += "where E1_SALDO > 0 "
			cSql += "AND E1_CLIENTE BETWEEN '"+ cMVPAR03 +"' AND '"+ cMVPAR04 +"' "
			cSql += "AND E1_MOEDA = 1 AND D_E_L_E_T_ <> '*' "
			cSql += "group by e1_cliente, e1_loja "
			cSql += "order by e1_cliente, e1_loja "
			
			TcQuery cSql new Alias "TMPSE1"			
			While TMPSE1->(!Eof())
				If SA1->(dbSeek(xFilial("SA1") + TMPSE1->E1_CLIENTE + TMPSE1->E1_LOJA))
					RecLock("SA1", .F.)
					SA1->A1_MSALDO += TMPSE1->SOMADUP
					SA1->A1_SALDUP := SA1->A1_MSALDO
					SA1->A1_SALDUPM:= SA1->A1_MSALDO
					SA1->(MsUnlock()) 
				EndIf
				TMPSE1->(dbSkip())
			EndDo
			TMPSE1->(dbCloseArea())
			
			// saldo das duplicatas em atraso, considerando as NCC, diferente do acima que considera saldo de todos os títulos
			cSql = "select e1_cliente, e1_loja, "
			cSql += "SUM(CASE WHEN INSTR('" + cAbat + "', e1_tipo) > 0 THEN E1_SALDO * (-1) ELSE E1_SALDO END) AS SOMADUP "
			cSql += "from " + RetSqlName("SE1") + "  "
			cSql += "where E1_SALDO > 0 "                                           
			cSql += "AND E1_CLIENTE BETWEEN '"+ cMVPAR03 +"' AND '"+ cMVPAR04 +"' "
			cSql += "AND (e1_vencrea < '" + DToS(Date()) + "' OR e1_vencrea = ' ') "
			cSql += "AND E1_MOEDA = 1 AND D_E_L_E_T_ <> '*' "
			cSql += "group by e1_cliente, e1_loja "
			cSql += "order by e1_cliente, e1_loja "
			
			TcQuery cSql new Alias "TMPSE1"			
			While TMPSE1->(!Eof())
				If SA1->(dbSeek(xFilial("SA1") + TMPSE1->E1_CLIENTE + TMPSE1->E1_LOJA))
				
					RecLock("SA1", .F.)
					SA1->A1_ATR += TMPSE1->SOMADUP
					SA1->(MsUnlock())
					
				EndIf
				
				TMPSE1->(dbSkip())
			EndDo
			TMPSE1->(dbCloseArea())
			if !lBat
				IncProc("Processado moeda 1 para empresa " + __cEMPTOT)
			EndIf

			/*************************************************************************************************
			Fim da parte customizada
			**************************************************************************************************/
			
			dbSelectArea( "SE1" )   
			dbSetOrder(2)		
			
			cFiltro := "E1_MOEDA > 1"
			
			// Insere filtro pra calcular apenas para moeda diferente da moeda 1
			SET FILTER TO @cFiltro
			If Empty(cMVPAR03)		
				dbGotop()
			Else
				dbSetOrder(2)		
				DbGoTop()
				//DbSeek(xFilial("SE1")+cMVPAR03, .F.)		
			EndIf
		
			While !EOF()
				
				If !lBat		
					IncProc()
				EndIf
				
				If SE1->E1_CLIENTE >= cMVPAR03 .And. SE1->E1_CLIENTE <= cMVPAR04
				
					//-- consumidor final
					If ALLTRIM(SE1->E1_CLIENTE) == "000000001" .OR. ALLTRIM(SE1->E1_CLIENTE) == "00000101"
						dbSkip()
						Loop
				  EndIf
			     	
			     	//-- clientes já processados para alguma filial da empresa diferente da atual
			     	If Len(aDADOSCLI) > 0
				     	nPOSCLI := aScan ( aDADOSCLI, {|x| 		x[1] == SE1->E1_CLIENTE + SE1->E1_LOJA ;
				     									.and.	x[2] == aDADOSEMP[nEMP][01] ;
				     									.and. 	x[3] != aDADOSEMP[nEMP][02] } )
				     	If nPOSCLI != 0
							dbSkip()
							Loop
				     	EndIf
				   	EndIf
			     	
			     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Ponto de entrada para filtro dos registros                      ³
			    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("FIN410FT")
						lRet := ExecBlock("FIN410FT",.F.,.F.,{cMVPAR01,"3"})
						If !lRet 
							dbSkip()
							Loop
						EndIf	
					Endif				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Saldo do Cliente                                             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
					
					dbSelectArea( "SA1" )
					If !Empty(xFilial("SA1")) .and. !Empty(xFilial("SE1"))
						cFilBusca := SE1->E1_FILIAL		// Ambos exclusivos, neste caso
																	// a filial serah 1 para 1
					Else
						cFilBusca := xFilial("SA1")		// filial do cliente (SA1)
					Endif
	
					lLojaCartao := .F.	// Indica se eh rotina chamada pelo modulo sigaloja e se forma de pagamento eh cartao.
					If Upper(subs(SE1->E1_ORIGEM,1,3)) == "LOJ"
						If ALLTRIM( SE1->E1_TIPO)  $ "CC;VA;CO;CD;FI"		// Cartao Credito, Vales, Convenio, Cartao de Debito, Financiamento Proprio
							lLojaCartao := .T.
						Endif
					Endif
					
					If lLojaCartao
						dbSelectArea( "SF2" )
						SF2->(dbSetOrder(1)) 
						cFilSF2 := If (lE1Msfil .and. !Empty(xFilial("SF2")),SE1->E1_MSFIL,xFilial("SF2"))
						DbSeek(cFilSF2+SE1->E1_NUM +SE1->E1_PREFIXO)
						cChaveSe1 := cFilBusca + SF2->F2_CLIENTE+ SF2->F2_LOJA
					Else
						cChaveSe1 := cFilBusca + SE1->E1_CLIENTE+ SE1->E1_LOJA
					Endif
	
					dbSelectArea( "SA1" )
					If (dbSeek( cChaveSe1 ) )
	  					nMoedaF		:= If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMoeda)
						nTaxaM:=Round(SE1->E1_VLCRUZ/SE1->E1_VALOR,3)
						If SE1->E1_TIPO $ MVRECANT+"/"+MV_CRNEG+"/"+MVABATIM+"/"+MVIRABT+"/"+MVFUABT+"/"+MVINABT+"/"+MVISABT+"/"+MVPIABT+"/"+MVCFABT
							AtuSalDup("-",SE1->E1_SALDO,SE1->E1_MOEDA,SE1->E1_TIPO,,SE1->E1_EMISSAO) 
							//conout("RJFINP02 ---> EMPRESA: "+cEmpAnt+" FILIAL"+cFilAnt+" TITULO: " + SE1->E1_NUM + " SALDUP: "+STR(SA1->A1_SALDUP))
						Else
							nSaldoTit := SE1->E1_SALDO
							nSaldoTit := Iif(nSaldoTit < 0, 0, nSaldoTit)
							IF !(SE1->E1_TIPO $ MVPROVIS)
								AtuSalDup("+",nSaldoTit,SE1->E1_MOEDA,SE1->E1_TIPO,nTaxaM,SE1->E1_EMISSAO)      
								//conout("RJFINP02 ---> EMPRESA: "+cEmpAnt+" FILIAL"+cFilAnt+" TITULO: " + SE1->E1_NUM + " SALDUP: "+STR(SA1->A1_SALDUP))
							Endif
			    		
			    		Reclock( "SA1" )
							SA1->A1_PRICOM  := Iif(SE1->E1_EMISSAO < A1_PRICOM .or. Empty(A1_PRICOM), SE1->E1_EMISSAO, A1_PRICOM)
							//If cMVPAR02 == 1  //Refaz dados Historicos
							//	SA1->A1_ULTCOM  := Iif(A1_ULTCOM<SE1->E1_EMISSAO,SE1->E1_EMISSAO,A1_ULTCOM)
							//Endif
							IF Year(SE1->E1_EMISSAO) == Year(Date())
								SA1->A1_VACUM += xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
							Endif
		
							IF !(SE1->E1_TIPO $ MVPROVIS)					
								If AllTrim(Upper(SE1->E1_ORIGEM)) == "MATA460"
									SF2->(dbSetOrder(2)) 
									nValForte := 0
									cFilSF2 := If (lE1Msfil .and. !Empty(xFilial("SF2")),SE1->E1_MSFIL,xFilial("SF2"))
									If SF2->(dbSeek(cFilSF2+SE1->(E1_CLIENTE+E1_LOJA+E1_NUM+E1_PREFIXO)))
										nValForte := xMoeda(SF2->F2_VALFAT,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)							
									Endif
								Else
									nValForte := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoedaF,SE1->E1_EMISSAO)
								Endif
								If nValForte > SA1->A1_MAIDUPL .and. cMVPAR02 == 1 //refaz dados historicos
									SA1->A1_MAIDUPL := nValForte
								EndIF
							
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Atrasos/Pagamentos em Atraso do Cliente  - 07/12/95     ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								aBaixas:=Baixas(SE1->E1_NATUREZ,SE1->E1_PREFIXO,SE1->E1_NUM,;
									SE1->E1_PARCELA,SE1->E1_TIPO,SE1->E1_MOEDA,"R",SE1->E1_CLIENTE,;
									Date(),SE1->E1_LOJA,SE1->E1_FILIAL)
		
								If cMVPAR02 == 1 .and. (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT") .And.;
									STR(SE1->E1_SALDO,17,2) != STR(SE1->E1_VALOR,17,2)
									// Nao faz sentido atualizar quando eh o cliente padrao
									// Essa consistencia serve apenas para modulo Sigaloja(12), pois outros modulos nao utilizam cliente padrao							
									If nModulo <> 12 .or. !(GetMv( "MV_CLIPAD" )+ GetMv( "MV_LOJAPAD" ) == SE1->E1_Cliente+SE1->E1_Loja) 
										SA1->A1_NROPAG += aBaixas[11]
									EndIf
								Endif
								If SE1->E1_SALDO == 0
									If (Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT")
										If (SE1->E1_BAIXA - SE1->E1_VENCREA) > 0 .and. cMVPAR02 == 1
											SA1->A1_PAGATR += SE1->E1_VALLIQ
										Endif
									Endif
								Else
									If SE1->E1_VENCREA < Date() .and. cMVPAR02 == 1
										SA1->A1_ATR += SE1->E1_SALDO
									Endif
								Endif
								
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Atualiza Dados Historicos                                        ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					        	If cMVPAR02 == 1
					
									//A1_MSALDO - Maior saldo de duplicatas do Cliente
									//A1_METR - Media de atrasos do Cliente
									//A1_MATR - Maior atraso do Cliente
		  							
		  							aAdd ( aDADOSCLI, { SA1->A1_COD + SA1->A1_LOJA, aDADOSEMP[nEMP][01], aDADOSEMP[nEMP][02] } )
		  							
		  							
		  							SA1->A1_MCOMPRA := Max(SA1->A1_MCOMPRA,Round(NoRound(xMoeda(SE1->E1_VALOR,1,nMCusto,SE1->E1_EMISSAO,3),3),2) )																					
		  						 	SA1->A1_NROCOM  += 1
						        	SA1->A1_MSALDO  := Iif(SA1->A1_SALDUPM > SA1->A1_MSALDO,SA1->A1_SALDUPM,SA1->A1_MSALDO)				         
						         	//conout("RJFINP02 ---> EMPRESA: "+cEmpAnt+" FILIAL"+cFilAnt+" TITULO: " + SE1->E1_NUM + " SALDUP: "+STR(SA1->A1_SALDUP))
									IF Empty(SE1->E1_FATURA) .Or. Substr(SE1->E1_FATURA,1,6) = "NOTFAT" 
										If (SE1->E1_BAIXA - SE1->E1_VENCREA) > SA1->A1_MATR
											SA1->A1_MATR := SE1->E1_BAIXA - SE1->E1_VENCREA
										EndIf
										If !Empty(SE1->E1_BAIXA)
											//SA1->A1_METR := (SA1->A1_METR * (SA1->A1_NROPAG-1) + (SE1->E1_BAIXA - SE1->E1_VENCREA))/ SA1->A1_NROPAG
										Endif
									Endif	
								Endif
								MsUnlock( )
							Endif
						Endif
					Endif
				Endif	
				dbSelectArea( "SE1" )
				dbSkip()
			Enddo
			dbSelectArea("SE1")
			// remove o filtro efetuado acima
			SET FILTER TO 
			
		EndIf

		If cMVPAR01 != 2   
		
			conout("RJFINP02 - PROCESSANDO TITULOS A PAGAR DA EMPRESA: "+aDADOSEMP[nEMP][01]+" - "+DTOS(Date())+TIME())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Titulos a Pagar - atualiza saldos fornecedores                            ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea( "SE2" )
			If Empty(cMVPAR05)		
				dbGotop()
			Else
				dbSetOrder(6)		
				DbGoTop()
				//DbSeek(xFilial("SE2")+cMVPAR05, .F.)		
			EndIf
			While !Eof()
				If !lBat		
					IncProc()
				EndIf
				If SE2->E2_FORNECE >= cMVPAR05 .And. SE2->E2_FORNECE<= cMVPAR06
			     	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			      //³Ponto de entrada para filtro dos registros                      ³
			    	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If ExistBlock("FIN410FT")
				   	lRet := ExecBlock("FIN410FT",.F.,.F.,{cMVPAR01,"4"})
						If !lRet 
							dbSkip()
							Loop
						EndIf	
					Endif				
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza Saldo do Fornecedor                                          ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					dbSelectArea( "SA2" )
					If !Empty(xFilial("SA2")) .and. !Empty(xFilial("SE2"))
						cFilBusca := SE2->E2_FILIAL		// Ambos exclusivos, neste caso
																	// a filial serah 1 para 1
					Else
						cFilBusca := xFilial("SA2")		// filial do fornecedor (SA2)
					Endif
			
					If (dbSeek( cFilBusca+SE2->E2_FORNECE+SE2->E2_LOJA ) )
						Reclock( "SA2" )
						If  SE2->E2_TIPO $ MVPAGANT+"/"+MV_CPNEG+"/"+MVABATIM
							SA2->A2_SALDUP  -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
							SA2->A2_SALDUPM -= xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
							SA2->A2_MCOMPRA := Max(SA2->A2_MCOMPRA,Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )							
						Else
							SA2->A2_SALDUP  += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,1,SE2->E2_EMISSAO)
							SA2->A2_SALDUPM += xMoeda(SE2->E2_SALDO,SE2->E2_MOEDA,nMoeda,SE2->E2_EMISSAO)
							SA2->A2_PRICOM  := Iif(SE2->E2_EMISSAO<A2_PRICOM .or. empty(A2_PRICOM),SE2->E2_EMISSAO,A2_PRICOM)
							SA2->A2_ULTCOM  := Iif(A2_ULTCOM<SE2->E2_EMISSAO,SE2->E2_EMISSAO,A2_ULTCOM)
							SA2->A2_MCOMPRA := Max(SA2->A2_MCOMPRA,Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )							
						EndIf                                                      
						If FieldPos("A2_MNOTA") <> 0
							If SubStr(SE2->E2_ORIGEM,1,3) == "FIN"
								SA2->A2_MNOTA   := Max(SA2->A2_MNOTA,Round(NoRound(xMoeda(SE2->E2_VALOR,1,nMCusto,SE2->E2_EMISSAO,3),3),2) )													
							Else        
								DbSelectArea("SF1")
								DbSetOrder(1)
								DBSeek(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
								SA2->A2_MNOTA   := Max(SA2->A2_MNOTA,Round(NoRound(xMoeda(SF1->F1_VALBRUT,1,nMCusto,SF1->F1_EMISSAO,3),3),2) )																				
							EndIf
						EndIf
						MsUnlock()
					EndIf
				Endif	
				dbSelectArea("SE2")
				SE2->( dbSkip())
			Enddo
		EndIf
		dbSelectArea( "SE1" )
		dbSetOrder(1)         
		MsUnlockAll()		
        
        
		RpcClearEnv()
		RPCSetType(3)
		                                              
		PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO cMODIMP 
		
		RestArea(aArea)
		
		
	Next nEMP
	     
    
	RpcClearEnv()
	RPCSetType(3)
	                                              
	PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO cMODIMP 
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Calculo da média de atraso de clientes                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If cMVPAR01 != 3 .and. Len(aEMPMEDAT) > 0
		cSql := " select e1_cliente, e1_loja, sum(MATR) as MATR, sum(NPAGT) as NPAGT from ( "
		For nI := 1 to Len(aEMPMEDAT)
			cSql += "( select e1_cliente, e1_loja, 
			cSql += " sum(to_date(E1_BAIXA,'yyyymmdd') - to_date(E1_VENCREA,'yyyymmdd')) as MATR,"
			cSql += " sum(case when e1_baixa <> ' ' then 1 else 0 end) as NPAGT "
			//cSql += " sum(case when e1_baixa <> ' ' then 1 else 0 end) as PAGAMENTOS "
			cSql += " from SE1"+aEMPMEDAT[nI]+"0
			cSql += " where E1_VENCREA <> ' '  "
			cSql += " and E1_CLIENTE between '"+ cMVPAR03 +"' and '"+ cMVPAR04 +"' "
			cSql += " and E1_BAIXA <> ' ' "
			cSql += " and E1_TIPO <> 'NCC' "
			//cSql += " and E1_BAIXA >= nDias "
			cSql += " and E1_MOEDA = 1 AND D_E_L_E_T_ <> '*' "
			cSql += " and not INSTR('" + cAbat + "', e1_tipo) > 0 "
			cSql += " group by e1_cliente, e1_loja )"
			If nI != Len(aEMPMEDAT)
				cSql += " union all "
			EndIf
		Next nI
		cSql += ") group by e1_cliente, e1_loja "
		cSql += "  order by e1_cliente, e1_loja "			
		MemoWrite( "RJFINP02-ATRASOS.SQL", cSql )
		TcQuery cSql new Alias "TMPMAT"			
		While TMPMAT->(!EOF())
			dbSelectArea("SA1")
			dbSetOrder(1)
			If SA1->(dbSeek(xFilial("SA1") + TMPMAT->E1_CLIENTE + TMPMAT->E1_LOJA))
				RecLock("SA1", .F.)
				
				SA1->A1_METR := Min(TMPMAT->MATR/TMPMAT->NPAGT, 999)
				
				SA1->(MsUnlock())
			EndIf
			TMPMAT->(dbSkip())
		EndDo
		TMPMAT->(dbCloseArea())	
	EndIf
			
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Scheddef ºAutor  ³Jean Carlos Saggin  º Data ³  27/11/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função que substitui a antiga AjustaSXD                     º±±
±±º          |  						                                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP7.10 ; MP10                                              º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Scheddef(cTipo, cFuncao, cPergunta, aOrdem, cPropri, aTitulo, aDescricao, cPergSPE)

Local aParam
Local aOrd     := aOrdem

aParam := { cTipo,;                      
						cPergunta,;
						"SA1",;  
						aOrd,;   
						"Bloqueio/Desbloqueio de Clientes"}    
Return aParam