#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJUXNEO     �Autor  �Microsiga         � Data �  06/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pela distribui��o schedulada dos        ���
���          � arquivos em seus respectivos diret�rios.                   ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

ConOut("RJUXNEO - INICIO ROTINA DE DISTRIBUI��O DE ARQUIVOS")

//����������������������������������������������������������������������������������������
//�Utilizo fixo empresa e filial s� pra entrar buscar alguns dados do cadastro de empresas�
//����������������������������������������������������������������������������������������

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FIN" TABLES "SEE"

U_USORWMAKE(ProcName(),FunName())

//������������������������������������������������������������������������������������������������������������������������Ŀ
//�Cria��o de arquivo tempor�rio sobre a execu��o da rotina, devido a execu��o N vezes pelo schedule decorrente das threads�
//��������������������������������������������������������������������������������������������������������������������������

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

//�������������������������������������������������������������
//�L�gica para buscar arquivos referente a cobran�a inteligente�
//�������������������������������������������������������������

ConOut("RJUXNEO - BUSCANDO ARQUIVOS COBRANCA INTELIGENTE")

cFiltro := "intret*.txt"
aArqNeo := Directory(cDIRINI + cFiltro, "D")

If Len(aArqNeo) > 0
	AEVAL(aArqNeo, {|x| fSendFile(AlLTrim(x[01])) })
Else
	ConOut("RJUXNEO - NENHUM ARQUIVO DE COBRANCA INTELIGENTE ENCONTRADO")
EndIf

//����������������������������������������������������������������������������������������������������������Ŀ
//�Percorre os par�metros de bancos das empresas para identificar as contas com retorno autom�tico habilitado�
//������������������������������������������������������������������������������������������������������������

For i := 1 to len(aEmp)
	ConOut("RJUXNEO - PROCESSANDO EMPRESA "+ aEmp[i, 01] +" FILIAL "+ aEmp[i, 02])
	
	//�������������������������������������������������������������������������Ŀ
	//�Efetuado o posicionamento na empresa em que vai ser feito o processamento�
	//���������������������������������������������������������������������������
	
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA aEmp[i, 01] FILIAL aEmp[i, 02] MODULO "FIN" TABLES "SEE"
	
	DbSelectArea("SEE")
	
	//�������������������������������������������������������������������������������Ŀ
	//�In�cio da busca dos bancos aptos a utilizarem a rotina de importa��o autom�tica�
	//���������������������������������������������������������������������������������
	
	cSql := "SELECT EE_CODIGO, EE_AGENCIA, EE.EE_SUBCTA, EE.EE_CONTA, EE.EE_DVCTA, EE.EE_DIRREC, EE.EE_BKPREC FROM "+RetSqlName("SEE")+" EE "  +cEol
	cSql += "WHERE EE.D_E_L_E_T_ <> '*' "                                                                                        +cEol
	cSql += "  AND EE.EE_RETAUT IN ('1','2') "                                                                      			 +cEol
	cSql += "  AND EE.EE_SUBCTA IN ('002','004') "                                                                     			 +cEol
	cSql += "  AND EE.EE_X_NOM <> ' ' "
	
	TCQUERY cSql NEW ALIAS "SEETMP"
	
	DbSelectArea("SEETMP")
	SEETMP->(DbGoTop())
	
	//���������������������������������������������������������Ŀ
	//�Verifica se o resultado da busca n�o foi uma tabela vazia�
	//�����������������������������������������������������������
	
	if !SEETMP->(EOF())
		While !SEETMP->(EOF())
			ConOut("RJUXNEO - BUSCANDO NOMENCLATURA DO BANCO "+ AllTrim(SEETMP->EE_CODIGO) +;
						 " AGENCIA "+ AllTrim(SEETMP->EE_AGENCIA) +" CONTA "+ AllTrim(SEETMP->EE_CONTA) +" DVCONTA "+ AllTrim(SEETMP->EE_DVCTA))
			
			//������������������������������������������������������������������������������������������������Ŀ
			//�Faz a chamada da fun��o que retorna a nomenclatura que o arquivo deve aparecer pra ser importado�
			//��������������������������������������������������������������������������������������������������
			
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

//���������������������������������������������������������������Ŀ
//�Posiciona o sistema na empresa que iniciou a execu��o da rotina�
//�����������������������������������������������������������������

PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO "FIN"

RestArea(aAreaSM0)
RestArea(aArea)

ConOut("RJUXNEO - FIM DA EXECUCAO.")

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fSendFile �Autor  �Jean Carlos Saggin  � Data �  02/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para mover os arquivos de cobran�a inteligente      ���
���          � para o diret�rio de importa��o.                            ���
�������������������������������������������������������������������������͹��
���Uso       � RJUXNEO                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fSendFile(cFile)

If fRename(cDIRINI + cFile, cDIRFIM + cFile) == 0
	ConOut("RJUXNEO - ARQUIVO "+ cDIRINI + cFile +" MOVIDO PARA "+ cDIRFIM + cFile +" COM SUCESSO.")
Else
	ConOut("RJUXNEO - ARQUIVO "+ cDIRINI + cFile +" NAO PODE SER MOVIDO PARA "+ cDIRFIM + cFile)
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MOVARQNEO  �Autor  �Microsiga          � Data �  18/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pela limpeza dos diret�rios utilizados  ���
���          � no processamento autom�tico dos arquivos.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

ConOut("MOVARQNEO - INICIO ROTINA DE DISTRIBUI��O DE ARQUIVOS")

//����������������������������������������������������������������������������������������
//�Utilizo fixo empresa e filial s� pra entrar buscar alguns dados do cadastro de empresas�
//����������������������������������������������������������������������������������������

RpcClearEnv()
RPCSetType(3)

PREPARE ENVIRONMENT EMPRESA cEmpAtu FILIAL cFilAtu MODULO "FIN" TABLES "SEE"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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

//����������������������������������������������������������������������������������������������������������Ŀ
//�Percorre os par�metros de bancos das empresas para identificar as contas com retorno autom�tico habilitado�
//������������������������������������������������������������������������������������������������������������

For i := 1 to len(aEmp)
	ConOut("MOVARQNEO - PROCESSANDO EMPRESA "+ aEmp[i, 01] +" FILIAL "+ aEmp[i, 02])
	
	//�������������������������������������������������������������������������Ŀ
	//�Efetuado o posicionamento na empresa em que vai ser feito o processamento�
	//���������������������������������������������������������������������������
	
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA aEmp[i, 01] FILIAL aEmp[i, 02] MODULO "FIN" TABLES "SEE"
	
	DbSelectArea("SEE")
	
	//�������������������������������������������������������������������������������Ŀ
	//�In�cio da busca dos bancos aptos a utilizarem a rotina de importa��o autom�tica�
	//���������������������������������������������������������������������������������
	
	cSql := "SELECT EE_CODIGO, EE_AGENCIA, EE.EE_SUBCTA, EE.EE_CONTA, EE.EE_DVCTA, EE.EE_DIRREC, EE.EE_DIRPAG, EE.EE_BKPREC, EE.EE_BKPPAG, EE.EE_EXTEN FROM "+RetSqlName("SEE")+" EE "  +cEol
	cSql += "WHERE EE.D_E_L_E_T_ <> '*' "                                                                                                                                               +cEol
	cSql += "  AND EE.EE_RETAUT IN ('1','2') "                                                                      			                                                        +cEol
	cSql += "  AND EE.EE_SUBCTA IN ('002','004') "                                                                     			                                                        +cEol
	cSql += "  AND EE.EE_X_NOM <> ' ' "
	
	TCQUERY cSql NEW ALIAS "SEETMP"
	
	DbSelectArea("SEETMP")
	SEETMP->(DbGoTop())
	
	//���������������������������������������������������������Ŀ
	//�Verifica se o resultado da busca n�o foi uma tabela vazia�
	//�����������������������������������������������������������
	
	if !SEETMP->(EOF())
		While !SEETMP->(EOF())
			                   
		      If SEETMP->EE_SUBCTA == "002"   
					cDirArq := SEETMP->EE_DIRREC
					cBkpArq := SEETMP->EE_BKPREC
			  Else
					cDirArq := SEETMP->EE_DIRPAG 
					cBkpArq := SEETMP->EE_BKPPAG   
			  EndIf  
			
			
			ConOut("MOVARQNEO - BUSCANDO ARQUIVOS NO DIRET�RIO "+AllTrim(cDirArq))
			aFiles := Directory(AllTrim(cDirArq)+"*."+ SEETMP->EE_EXTEN)
			
			//���������������������������������������������������������������
			//�Utiliza fun��es padr�es para mover arquivos entre diret�rios.�
			//����������������������������������������������������������������
			
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

//���������������������������������������������������������������Ŀ
//�Posiciona o sistema na empresa que iniciou a execu��o da rotina�
//�����������������������������������������������������������������

PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO "FIN"

RestArea(aAreaSM0)
RestArea(aArea)

ConOut("MOVARQNEO - FIM DA EXECUCAO.")

Return
