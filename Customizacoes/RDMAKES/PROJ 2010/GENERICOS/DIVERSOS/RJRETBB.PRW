#include "rwmake.ch"
#include "fileio.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RJRETBB  ºAutor  ³ Cleber D.P.        º Data ³  04/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para buscar o Nosso Número dos títulos constantes º±±
±±º          ³ no arquivo de retorno do CNAB a Receber da Caixa Econômica º±±
±±º          ³ Federal, localizá-lo na SE1, e gravar o índice do título   º±±
±±º          ³ na posição correta do arquivo de retorno.                  º±±
±±º          ³ EXCLUSIVO BANCO DO BRASIL                                  º±±
±±º          ³ Deverá ser executado antes de realizar a recepção do arqui-º±±
±±º          ³ vo (Rotina FINR650 e/ou FINA200);                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-----------------------*
User Function RJRETBB()
*-----------------------*
Local	cTitulo := "Ajusta arquivo de retorno BB"	// Título da janela de parametros

Private cPerg   := "RJRETCNAB "
Private lRetFun := .T.
Private cArq    := "" 
Private cWrtBuf := ""
AjustaSX1()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !Pergunte(cPerg, .T., cTitulo)
	Return .F.
Endif

cArq := alltrim(mv_par01)
Processa({|| PrepRet()}," Ajustando arquivo de retorno BB... ")
If lRetFun != .F.
	EncParam(cArq)	
	//FINR650()
Endif

Return NIL


*------------------------------*
Static Function PrepRet()
*------------------------------*

//VARIAVEIS LOCAIS
Local	aArea	:= SE1->(GetArea())				// Carrega o ambiente ativo da tabela SE1
Local	nTamLin := 240							// Tamanho da linha no arquivo texto -> Arquivo Retorno 240
Local	nContReg:= 0							// Contador de registros lidos
Local	nContAlt:= 0							// Contador de registros alterados
Local	nHdl    := NIL							// Handle para abertura do arquivo
Local	cBuffer := Space(nTamLin+2)				// Variavel para leitura dos registros do arquivo
Local	nBytes  := 0							// Variavel para verificacao do fim de arquivo
Local	cSgmto	:= ""							// Segmento do registro lido - "T" - Posicao 14 Modelo 2
Local	cDadosT	:= ""							// Dados do título a receber - SE1
Local	cNosNum	:= ""							// Nosso Número gravado na geração do boleto
Local	nTamArq := 0
Local   cLOG    := cArq + Chr(13)+Chr(10)
/*
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O comando segundo parametro do comando fOpen indica o modo de abertura³
//³ do arquivo escolhido:                                                 ³
//³ 0 - Leitura;                                                          ³
//³ 1 - Gravacao;                                                         ³
//³ 2 - Leitura e Gravacao;                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/
nHdl := fOpen(cArq,2)						// Abre o arquivo
If nHdl == -1
    Alert("Erro ao abrir arquivo!")
    lRetFun := .F.
    Return .F.
Endif

nTamArq := fSeek(nHdl,0,FS_END)
ProcRegua(nTamArq/(nTamLin+2))
fseek(nHdl,0,FS_SET)
nBytes := fRead(nHdl,@cBuffer,nTamLin+2)   // Le a primeira linha
cBanco := Substr(cBuffer,1,3)              // COD.BANCO - 001 a 003

If !(cBanco $ "/001/")
	Alert("Banco inválido!"+ Chr(13) + cBanco)
	fClose(nHdl) 									// Fecha o arquivo
	dbClearFilter()									// Limpa o filtro aplicado
	RestArea(aArea)									// Retorna o ambiente ativo da tabela SE1
	Return
Endif

While nBytes == nTamLin+2
	IncProc()
    nBytes := fRead(nHdl,@cBuffer,nTamLin+2) 	 // Le mais uma linha
	cIDCNAB := Alltrim(Substr(cBuffer,106,25))   // IDCNAB - 106 a 130
	cNumTit := cIDCNAB
	cAgen   := ""
	cConta  := ""
	cNNum   := ""
	
	If Substr(cBuffer,14,1) = "T" //.and. cIDCNAB < "0000500000"
		// Pega dados do titulo na linha atual para compor chave de busca
		cAgen  := Alltrim(substr(cBuffer,019, 5))  // AGENCIA - 018 a 022
		cConta := Alltrim(substr(cBuffer,031, 6))  // CONTA - 024 a 035
		cNNum  := Alltrim(substr(cBuffer,038,20))  // NNUM - 038 a 057
		
		// 429201 -> 42920-1
		// 58106  -> 5810-6
		cConta := Substr(cConta,1,Len(cConta)-1) +"-"+ Substr(cConta,Len(cConta),1)
		
		//Alert(cBanco +" / "+ cAgen +" / "+ cConta +" / "+ cNNum)
		dbSelectArea("SA6")
		dbSetOrder(1)
		Set Filter To A6_COD = cBanco .AND. A6_AGENCIA = cAgen .AND. A6_NUMCON = cConta
		dbGoTop()
		lAchou := !EOF()
		
		cQuery := ""
		cQuery += " SELECT * FROM " + RetSqlName("SE1") +" SE1 "
		cQuery += " WHERE E1_NUMBCO = '"+ cNNum  +"'           "
		cQuery += " AND   SE1.D_E_L_E_T_ <> '*'                "
		If lAchou
			cQuery += " AND   E1_PORTADO = '"+ SA6->A6_COD     +"' "
//			cQuery += " AND   E1_AGEDEP  = '"+ SA6->A6_AGENCIA +"' "
//			cQuery += " AND   E1_CONTA   = '"+ SA6->A6_NUMCON  +"' "
		Endif
		
		dbSelectArea("SA6")
		Set Filter To 
		
		TCQUERY cQuery NEW ALIAS "SE1FIL"
		dbSelectArea("SE1FIL")
		SE1FIL->(DbGotop())
		
		// Conta registros para verificar se ha repeticao
		nCount := 0
		While !EOF()
			nCount++
			dbSkip()
		Enddo
		SE1FIL->(DbGotop())
		
		// Pega o IDCNAB somente se nao tiver NUMBCO repetido
		If nCount = 0
			// Titulo nao encontrado
			cLOG += "Nosso Numero: "+ cNNum +" -> NAO ENCONTRADO "+ RetSqlName("SE1") +Chr(13)+Chr(10)
		ElseIF nCount = 1
			cNumTit := AllTrim(SE1FIL->E1_IDCNAB)
		Else
			// Titulo com Nosso Numero DUPLICADO
			cLOG += "Nosso Numero: "+ cNNum +" -> DUPLICADO      "+ RetSqlName("SE1") +Chr(13)+Chr(10)
		EndIF
		SE1FIL->(dbCloseArea())
		
		// Monta linha do buffer para alterar o arquivo com a nova informação IDCNAB
		If cNumTit <> cIDCNAB
			//Alert(PADR(cNumTit,10))
			// IDCNAB - 106 a 130 (25)
			cWrtBuf := Substr(cBuffer,1,105) + PADR(cNumTit,25) + Substr(cBuffer,131,110) + Chr(13) + Chr(10)
			//MemoWrite("d:\rjretbb.txt", cBuffer + cWrtBuf)
			fSeek(nHdl,-1 * (nTamLin+2),1)		// Posiciona no início do registro que será alterado
			fWrite(nHdl,cWrtBuf)				// Efetua a gravação no arquivo
			nContAlt++
		Endif
		nContReg++
	Endif	
EndDo
IncProc()   

cArqLog := "d:\ret"+ cBanco +".txt"
MemoWrite(cArqLog, cLOG)

fClose(nHdl) 									// Fecha o arquivo
dbClearFilter()									// Limpa o filtro aplicado
RestArea(aArea)									// Retorna o ambiente ativo da tabela SE1

MsgInfo("Numero de registros lidos: " + cvaltochar(nContReg) + chr(13) + ;
        "Numero de registros alterados: " + cvaltochar(nContAlt) + chr(13) + ;
        chr(13) + "--> LOG gerado: "+ cArqLog)

Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajuste de parametros                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*--------------------------*
Static Function ajustaSX1()
*--------------------------*

aAlias := Alias()
aRegs  := {}
dbSelectArea("SX1")
dbSetOrder(1)

aAdd(aRegs,{cPerg,"01","Arquivo de entrada ?","","","mv_ch1","C",75,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DIR","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(aAlias)

Return NIL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Replica o parametro arquivo para a rotina FINA200()       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*----------------------------*
Static Function EncParam(cArq)
*----------------------------*
                          
Private		aAlias 		:= Alias()
Private		cX1Grupo	:= "FIN650    "
Private		cX1Ordem	:= "01"

dbSelectArea("SX1")
dbSetOrder(1)
dbSeek(cX1Grupo+cX1Ordem)
RecLock("SX1",.F.)
X1_CNT01 := cArq
MsUnlock()
dbSelectArea(aAlias)

Return NIL
