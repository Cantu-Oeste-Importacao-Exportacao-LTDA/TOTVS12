#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUXNEO     ºAutor  ³Microsiga         º Data ³  06/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela distribuição schedulada dos        º±±
±±º          ³ arquivos em seus respectivos diretórios.                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function RJUXNEO()     
*--------------------------*
Local aAreaSM0  := {}
Local aArea			:= GetArea()
Local cEmpAtu		:= "01"
Local cFilAtu		:= "01"	
Local cEmp  		:= ""
Local cSql    	:= ""
Local i       	:= 0
Local cEol 			:= CHR(13)+CHR(10)
Local aArqNeo   := {}
Local cFiltro   := ""

Private aEmp 			:= {}
Private cCgc 			:= ""
Private cArquivo 	:= ""
Private aFiles		:= {} 
Private cDIRINI   := "/cnabs/receber/inbox/"                      // Local onde o sistema vai buscar os arquivos da Neogrid
Private cDIRFIM   := "/neogrid/cobrancainteligente/"             // Local onde o sistema entrega os arquivos da Neogrid

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ConOut("RJUXNEO - INICIO ROTINA DE DISTRIBUIÇÃO DE ARQUIVOS")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Utilizo fixo empresa e filial só pra entrar buscar alguns dados do cadastro de empresas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FIN" TABLES "SEE"

U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina, devido a execução N vezes pelo schedule decorrente das threads³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLock := 0
While !LockByName("RJUXNEO",.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)                                    	
	If nLock > 10                                 
		ConOut("CONTROLE DE SEMAFORO - RJUXNEO JA SE ENCONTRA EM EXECUCAO!")
		RpcClearEnv()
		Return
	EndIf		
EndDo                          

aAreaSM0 := SM0->(GetArea())

DbSelectArea("SM0")
SM0->(DbGoTop())

ConOut("RJUXNEO - BUSCANDO EMPRESAS(SM0) ")
While !SM0->(EOF())
	if cEmp != SM0->M0_CODIGO 
		aAdd(aEmp, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC})
	EndIf
	cEmp := SM0->M0_CODIGO
	SM0->(DbSkip())
EndDo

RestArea(aAreaSM0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Lógica para buscar arquivos referente a cobrança inteligente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

ConOut("RJUXNEO - BUSCANDO ARQUIVOS COBRANCA INTELIGENTE")

cFiltro := "intret*.txt"
aArqNeo := Directory(cDIRINI + cFiltro, "D")

If Len(aArqNeo) > 0
	AEVAL(aArqNeo, {|x| fSendFile(AlLTrim(x[01])) })
Else
	ConOut("RJUXNEO - NENHUM ARQUIVO DE COBRANCA INTELIGENTE ENCONTRADO")
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorre os parâmetros de bancos das empresas para identificar as contas com retorno automático habilitado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For i := 1 to len(aEmp)
	ConOut("RJUXNEO - PROCESSANDO EMPRESA "+ aEmp[i, 01] +" FILIAL "+ aEmp[i, 02])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetuado o posicionamento na empresa em que vai ser feito o processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA aEmp[i, 01] FILIAL aEmp[i, 02] MODULO "FIN" TABLES "SEE"
	
	DbSelectArea("SEE")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Início da busca dos bancos aptos a utilizarem a rotina de importação automática³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cSql := "SELECT EE_CODIGO, EE_AGENCIA, EE.EE_SUBCTA, EE.EE_CONTA, EE.EE_DVCTA, EE.EE_DIRREC, EE.EE_BKPREC FROM "+RetSqlName("SEE")+" EE "  +cEol
	cSql += "WHERE EE.D_E_L_E_T_ <> '*' "                                                                                        +cEol
	cSql += "  AND EE.EE_RETAUT IN ('1','2') "                                                                      			 +cEol
	cSql += "  AND EE.EE_SUBCTA IN ('002','004') "                                                                     			 +cEol
	cSql += "  AND EE.EE_X_NOM <> ' ' "
	
	TCQUERY cSql NEW ALIAS "SEETMP"
	
	DbSelectArea("SEETMP")
	SEETMP->(DbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o resultado da busca não foi uma tabela vazia³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !SEETMP->(EOF())
		While !SEETMP->(EOF())
			ConOut("RJUXNEO - BUSCANDO NOMENCLATURA DO BANCO "+ AllTrim(SEETMP->EE_CODIGO) +;
						 " AGENCIA "+ AllTrim(SEETMP->EE_AGENCIA) +" CONTA "+ AllTrim(SEETMP->EE_CONTA) +" DVCONTA "+ AllTrim(SEETMP->EE_DVCTA))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Faz a chamada da função que retorna a nomenclatura que o arquivo deve aparecer pra ser importado³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cArquivo := Lower(U_GETARQFIN(SEETMP->EE_CODIGO, SEETMP->EE_AGENCIA, SEETMP->EE_CONTA, SEETMP->EE_SUBCTA))
      
			aFiles := Directory(AllTrim(cArquivo))
			
			if !Empty(aFiles)

				aBco := {}
				Aadd(aBco, SEETMP->EE_CODIGO)
				Aadd(aBco, SEETMP->EE_AGENCIA)
				Aadd(aBco, SEETMP->EE_CONTA) 
				Aadd(aBco, SEETMP->EE_SUBCTA) 
				
				If SEETMP->EE_SUBCTA == "002"   
					cArqTmp := "\cnabs\receber\inbox\"
				Else
					cArqTmp := "\cnabs\pagar\inbox\      
				EndIf

				AEVAL(aFiles, { |x| U_ENVARQSRV(.T., aBco, Alltrim(cArqTmp)+ AllTrim(x[01]))})
				
				aBco := {}
				
			EndIf
			
			SEETMP->(DbSkip())		
		EndDo
	EndIf
	
	SEETMP->(DbCloseArea())
	
	RpcClearEnv()
					
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema na empresa que iniciou a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO "FIN"

RestArea(aAreaSM0)
RestArea(aArea)

ConOut("RJUXNEO - FIM DA EXECUCAO.")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSendFile ºAutor  ³Jean Carlos Saggin  º Data ³  02/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para mover os arquivos de cobrança inteligente      º±±
±±º          ³ para o diretório de importação.                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJUXNEO                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fSendFile(cFile)

If fRename(cDIRINI + cFile, cDIRFIM + cFile) == 0
	ConOut("RJUXNEO - ARQUIVO "+ cDIRINI + cFile +" MOVIDO PARA "+ cDIRFIM + cFile +" COM SUCESSO.")
Else
	ConOut("RJUXNEO - ARQUIVO "+ cDIRINI + cFile +" NAO PODE SER MOVIDO PARA "+ cDIRFIM + cFile)
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MOVARQNEO  ºAutor  ³Microsiga          º Data ³  18/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela limpeza dos diretórios utilizados  º±±
±±º          ³ no processamento automático dos arquivos.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function MOVARQNEO()   
*--------------------------*
Local aAreaSM0  := {}
Local aArea			:= GetArea()
Local cEmpAtu		:= "01"
Local cFilAtu		:= "01"	
Local cEmp  		:= ""
Local cSql    	:= ""
Local i       	:= 0
Local cEol 			:= CHR(13)+CHR(10)

Private aEmp 		:= {}
Private aFiles  := {}

ConOut("MOVARQNEO - INICIO ROTINA DE DISTRIBUIÇÃO DE ARQUIVOS")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Utilizo fixo empresa e filial só pra entrar buscar alguns dados do cadastro de empresas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FIN" TABLES "SEE"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aAreaSM0 := SM0->(GetArea())

DbSelectArea("SM0")
SM0->(DbGoTop())

ConOut("MOVARQNEO - BUSCANDO EMPRESAS(SM0) ")
While !SM0->(EOF())
	if cEmp != SM0->M0_CODIGO
		aAdd(aEmp, {SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC})
	EndIf
	cEmp := SM0->M0_CODIGO
	SM0->(DbSkip())
EndDo

RestArea(aAreaSM0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Percorre os parâmetros de bancos das empresas para identificar as contas com retorno automático habilitado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For i := 1 to len(aEmp)
	ConOut("MOVARQNEO - PROCESSANDO EMPRESA "+ aEmp[i, 01] +" FILIAL "+ aEmp[i, 02])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Efetuado o posicionamento na empresa em que vai ser feito o processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA aEmp[i, 01] FILIAL aEmp[i, 02] MODULO "FIN" TABLES "SEE"
	
	DbSelectArea("SEE")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Início da busca dos bancos aptos a utilizarem a rotina de importação automática³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cSql := "SELECT EE_CODIGO, EE_AGENCIA, EE.EE_SUBCTA, EE.EE_CONTA, EE.EE_DVCTA, EE.EE_DIRREC, EE.EE_DIRPAG, EE.EE_BKPREC, EE.EE_BKPPAG, EE.EE_EXTEN FROM "+RetSqlName("SEE")+" EE "  +cEol
	cSql += "WHERE EE.D_E_L_E_T_ <> '*' "                                                                                                                                               +cEol
	cSql += "  AND EE.EE_RETAUT IN ('1','2') "                                                                      			                                                        +cEol
	cSql += "  AND EE.EE_SUBCTA IN ('002','004') "                                                                     			                                                        +cEol
	cSql += "  AND EE.EE_X_NOM <> ' ' "
	
	TCQUERY cSql NEW ALIAS "SEETMP"
	
	DbSelectArea("SEETMP")
	SEETMP->(DbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o resultado da busca não foi uma tabela vazia³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !SEETMP->(EOF())
		While !SEETMP->(EOF())
			                   
		      If SEETMP->EE_SUBCTA == "002"   
					cDirArq := SEETMP->EE_DIRREC
					cBkpArq := SEETMP->EE_BKPREC
			  Else
					cDirArq := SEETMP->EE_DIRPAG 
					cBkpArq := SEETMP->EE_BKPPAG   
			  EndIf  
			
			
			ConOut("MOVARQNEO - BUSCANDO ARQUIVOS NO DIRETÓRIO "+AllTrim(cDirArq))
			aFiles := Directory(AllTrim(cDirArq)+"*."+ SEETMP->EE_EXTEN)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄä¿
			//³Utiliza funções padrões para mover arquivos entre diretórios.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄäÙ
			
			if !Empty(aFiles)
				ConOut("MOVARQNEO - MOVENDO ARQUIVOS...")
				AEVAL(aFiles, { |x| FRename(AllTrim(cDirArq)+x[01],AllTrim(cBkpArq)+x[01])})
				
				for nX := 1 to Len(aFiles)
					ConOut(AllTrim(cDirArq)+ aFiles[nX,01] +" ==> "+ AllTrim(cBkpArq)+aFiles[nX,01])
				Next nX
				
			EndIf
			
			SEETMP->(DbSkip())		
		EndDo
	EndIf
	
	SEETMP->(DbCloseArea())
	
	RpcClearEnv()
					
Next i

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema na empresa que iniciou a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO "FIN"

RestArea(aAreaSM0)
RestArea(aArea)

ConOut("MOVARQNEO - FIM DA EXECUCAO.")

Return
