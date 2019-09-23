#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"    
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"    
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH" 
#INCLUDE "PARMTYPE.CH"   
#DEFINE PAD_LEFT            0
#DEFINE PAD_RIGHT           1
#DEFINE PAD_CENTER          2                             

#DEFINE CDIRSRV "/fatauto/"
#DEFINE CLOCPDF "c:\tmp\"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BOLASER_NEW     ºAutor  ³J&@N          º Data ³  30/05/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Essa rotina tem como finalidade a emissão de boletos       º±±
±±º          ³ de Todos os Bancos.                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro/Faturamento                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Boletos(_cCli,_cLoja,_cDoc,_cPref,_cBco,_cAge,_cCta,_cSubCta,_lAuto)

Local nOpc         := 0
Local aMarked      := {}
Local aDesc        := {"Esta rotina imprime os boletos de","cobranca bancaria de acordo com","os parâmetros informados."}
Private Exec       := .F.
Private cIndexName := ''
Private cIndexKey  := ''
Private cFilter    := ''
Private cPerg      := Padr("BOLETOS",len(sx1->x1_grupo))
Private aMsg       := {}
                                                
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("AAC,ACRA,CNOMEREL,CFILE,CSAVSCR1,CSAVCUR1")
SetPrvt("CSAVROW1,CSAVCOL1,CSAVCOR1,ANOTA,CALIAS,CSAVSCR3")
SetPrvt("CCOLOR")
SetPrvt("CTELA,AFILE,CSAVSCR,I,CSAVCOR,NOPCFILE")
SetPrvt("NOPCA,NTREGS,NMULT,NANT,NATU,NCNT")
SetPrvt("NTOTPORCEN,CSAV20,CSAV7,NDIA,CBARRA,CLINHA,cBarraImp,cBarraFim")
SetPrvt("NDIGITO,CCAMPO,NCONT,NVAL,instr1,instr2,cBarraImp4,X,NOSSONUM,cCondicao")

Private _auto	:= .F.

Tamanho  := "M"
titulo   := "Impressão de Boletos"
cDesc1   := "Este programa destina-se a impressão de boletos de todos os bancos."
cDesc2   := ""
cDesc3   := ""
cString  := "SE1"
wnrel    := "BOLETOS"
lEnd     := .F.
aReturn  := {"Zebrado", 1,"Administracao", 2, 2, 1, "",1 }
nLastKey := 0

dbSelectArea("SE1")

If ValType(_lAuto) == "U"
	ValidPerg(cPerg)
	
	if !Pergunte(cPerg, .T.)
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³Valida se o campo A6_EMITBOL está como verdadeiro para a emissão de boletos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	if (MV_PAR15 == 2) .And. !U_ValidBco(MV_PAR16, MV_PAR17, MV_PAR18)
		aAdd(aMsg, "A OPÇÃO 'EMITE BOLETO' NO CADASTRO DO BANCO "+ Trim(MV_PAR16) +" AGENCIA "+ Trim(MV_PAR17) +" E CONTA "+ Trim(MV_PAR18)+" ESTÁ DESABILITADA.")
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o banco selecionado pode ser utilizado para emissão de boletos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !MV_PAR16 $ "001/004/033/104/224/237/246/320/341/399/422/623/655/707/745/748/756"
		aAdd(aMsg, "O BANCO " + AllTrim(MV_PAR16) + " NÃO ESTÁ PREPARADO PARA EMITIR BOLETOS.")
		Return
	EndIf
	
	If nLastKey == 27
		Set Filter to
		Return
	EndIf
	
	nOpc := 1
	
Else
	nOpc  := 2
	_auto := .T.
Endif

if nOpc == 1
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := 	"E1_PREFIXO+E1_NUM+E1_PARCELA+E1_PORTADO+E1_CLIENTE+E1_TIPO+DTOS(E1_EMISSAO)"
	
	cFilter    := 	"E1_PREFIXO >= '" + MV_PAR01 + "' .And. E1_PREFIXO <= '" + MV_PAR02 + "' .And. " + ;
	"E1_NUM     >= '" + MV_PAR03 + "' .And. E1_NUM     <= '" + MV_PAR04 + "' .And. " + ;
	"E1_PARCELA >= '" + MV_PAR05 + "' .And. E1_PARCELA <= '" + MV_PAR06 + "' .And. " + ;
	"E1_CLIENTE >= '" + MV_PAR07 + "' .And. E1_CLIENTE <= '" + MV_PAR08 + "' .And. " + ;
	"E1_EMISSAO >= CTOD('" + DTOC(MV_PAR13) + "') .And. E1_EMISSAO <= CTOD('" + DTOC(MV_PAR14) + "') .And. " + ;
	"E1_VENCREA  >= CTOD('" + DTOC(MV_PAR11) + "') .And. E1_VENCREA  <= CTOD('" + DTOC(MV_PAR12) + "') .And. " + ;
	"E1_LOJA    >= '" + MV_PAR09 + "' .And. E1_LOJA    <= '" + MV_PAR10 + "' .And. " + ;
	"E1_FILIAL   = '" + xFilial("SE1") + "' .And. E1_SALDO > 0 .And. E1_XCODAUT = ' ' .And." + ;
	"(Alltrim(E1_TIPO) = 'NF' .Or. Alltrim(E1_TIPO) = 'FT' .Or. Alltrim(E1_TIPO) = 'DP')"
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Reimpressão³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if mv_Par15 == 1
		cFilter +=" .And. !Empty(E1_NUMBCO)"
	else
		cFilter +=" .And. Empty(E1_NUMBCO)"
	endif
	
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
	
	#IFNDEF TOP
		dbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	
	dbGoTop()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se usuário deseja visualizar e selecionar os títulos pra gerar os boletos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if MV_PAR20 == 1
		
		@ 001,001 TO 400,700 DIALOG oDlg TITLE "Títulos Selecionados para Impressão"
		@ 001,001 TO 170,350 BROWSE "SE1" MARK "E1_OK"
		@ 180,310 BMPBUTTON TYPE 01 ACTION (Exec := .T.,Close(oDlg))
		@ 180,280 BMPBUTTON TYPE 02 ACTION (Exec := .F.,Close(oDlg))
		
		ACTIVATE DIALOG oDlg CENTERED
		
		dbGoTop()
		Do While !Eof()
			If Marked("E1_OK")
				DbSelectArea("SE1")
				AADD(aMarked,.T.)
			Else
				AADD(aMarked,.F.)
			EndIf
			dbSkip()
		EndDo
		
	Else
		DbSelectArea("SE1")
		DbGoTop()
		Do While !Eof()
			DbSelectArea("SE1")
			AADD(aMarked,.T.)
			Exec := .T.
			dbSkip()
		EndDo
	EndIf
	
	DbGoTop()
	
	nLock := 0
	nSeg  := 0
    

	If Exec 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Controle de semáfoto para que um usuário não consiga gerar boletos no mesmo momento em que outro usuário estiver gerando para a mesma empresa³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	   	/* 20/06/16 - GUSTAVO LATTMANN 
	  	If MV_PAR15 != 1
			While !LockByName("BOLETOS"+cEmpAnt,.T.,.F.,.T.)
	      	Processa({|| fAguarda(10) }, "Aguarde...", "Já existe outro usuário emitindo boleto, a rotina vai aguardar 10 segundos e tentar novamente!", .F.)
			EndDo	
		EndIf
		20/06/2016 - FIM GUSTAVO */    
	
		RptStatus({|lEnd| MontaRel(@lEnd, aMarked)}, "Aguarde...", "Gerando Boletos...", .T.)
		
		If MV_PAR15 != 1
			UnLockByName("BOLETOS"+cEmpAnt, .T., .F., .T.)  
		EndIf
	
	EndIf
	
	
	RetIndex("SE1")
	
	fErase(cIndexName+OrdBagExt())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Cai nessa excessão, caso a esteja fazendo a emissão automática³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
Else
	
	MV_PAR15	:= 2
	MV_PAR16	:= _cBco
	MV_PAR17	:= _cAge
	MV_PAR18	:= _cCta
	MV_PAR19  := _cSubCta
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
	//³Valida se o campo A6_EMITBOL está como verdadeiro para a emissão de boletos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ
	
	if (MV_PAR15 == 2) .And. !U_ValidBco(MV_PAR16, MV_PAR17, MV_PAR18)
		aAdd(aMsg, "A OPÇÃO 'EMITE BOLETO' NO CADASTRO DO BANCO "+ Trim(MV_PAR16) +" AGENCIA "+ Trim(MV_PAR17) +" E CONTA "+ Trim(MV_PAR18)+" ESTÁ DESABILITADA.")
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o banco selecionado pode ser utilizado para emissão de boletos.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !MV_PAR16 $ "001/004/033/104/224/237/246/320/341/422/623/655/707/745/748/756"
		aAdd(aMsg, "O BANCO " + AllTrim(MV_PAR16) + " NÃO ESTÁ PREPARADO PARA EMITIR BOLETOS.")
		Return
	EndIf
	
	DbSelectArea("SE1")
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := "E1_PREFIXO+E1_NUM+E1_PARCELA+E1_PORTADO+E1_CLIENTE+E1_TIPO+DTOS(E1_EMISSAO)"
	cFilter    := "E1_PREFIXO >= '" + _cPref + "' .And. E1_PREFIXO <= '" + _cPref + "' .And. " + ;
	"E1_NUM     >= '" + _cDoc  + "' .And. E1_NUM     <= '" + _cDoc  + "' .And. " + ;
	"E1_CLIENTE >= '" + _cCli  + "' .And. E1_CLIENTE <= '" + _cCli  + "' .And. " + ;
	"E1_LOJA    >= '" + _cLoja + "' .And. E1_LOJA    <= '" + _cLoja + "' .And. " + ;
	"E1_FILIAL   = '" + xFilial("SE1") + "' .And. E1_SALDO > 0 .And. E1_XCODAUT = ' ' .And." + ;
	"(Alltrim(E1_TIPO)='NF' .Or. Alltrim(E1_TIPO)='FT' .Or. Alltrim(E1_TIPO)='DP')"
	
	cFilter    += " .And. Empty(E1_NUMBCO)"
	
	IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Buscando Títulos para Emissão dos Boletos....")
	dbSelectArea("SE1")
	
	#IFNDEF TOP
		dbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	
	dbGoTop()
	Do While !Eof()
		AADD(aMarked,.T.)
		Exec := .T.
		dbSkip()
	EndDo
	dbGoTop()
	
	nLock := 0
	nSeg  := 0
	If Exec .and. !_auto
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle de semáfoto para que um usuário não consiga gerar boletos no mesmo momento em que outro usuário estiver gerando para a mesma empresa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	 	/* 20/06/16 - GUSTAVO LATTMANN 
    	If MV_PAR15 != 1
			While !LockByName("BOLETOS"+cEmpAnt,.T.,.F.,.T.)
      			Processa({|| fAguarda(10) }, "Aguarde...", "Já existe outro usuário emitindo boleto, a rotina vai aguardar 10 segundos e tentar novamente!", .F.)
			EndDo	
		EndIf                          
		20/06/16 - FIM GUSTAVO LATTMANN */
	
		RptStatus({|lEnd| MontaRel(@lEnd, aMarked)}, "Aguarde...", "Gerando Boletos...", .T.)
		
		If MV_PAR15 != 1
			UnLockByName("BOLETOS"+cEmpAnt, .T., .F., .T.)  
		EndIf
	
	ElseIf Exec .and. _auto
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Controle de semáfoto para que um usuário não consiga gerar boletos no mesmo momento em que outro usuário estiver gerando para a mesma empresa³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   	 	/* 20/06/16 - GUSTAVO LATTMANN 
		if MV_PAR15 != 1
			While !LockByName("BOLETOS"+cEmpAnt,.T.,.F.,.T.)
				nLock += 1
				Sleep(1000)
				If nLock == 10
					nSeg += nLock
					ConOut("BOLETOS - Rotina aguardando o controle de semáforo ("+ AllTrim(cValtoChar(nSeg)) +"s)")
					nLock := 0
				EndIf
			EndDo
		EndIf
		20/06/16 - FIM GUSTAVO LATTMANN */
		
		MontaRel(@lEnd, aMarked)
  	
  	If MV_PAR15 != 1
			UnLockByName("BOLETOS"+cEmpAnt, .T., .F., .T.)  
		EndIf
		
	Endif
	
	RetIndex("SE1")
	fErase(cIndexName+OrdBagExt())
	
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Mostra mensagens de processamento ao final da rotina.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cTmp := ""
if Len(aMsg) > 0 .and. !_auto
	for i := 1 to Len(aMsg)
		cTmp += aMsg[i] + CHR(13)+CHR(10)
	Next i
	
	Aviso("ENTRE EM CONTATO COM A AREA DE CREDITO", cTmp, {"Ok"}, 3)

ElseIf  Len(aMsg) > 0 .and. _auto
	for i := 1 to Len(aMsg)
		ConOut( aMsg[i] )
	Next i	
EndIf

Return aMsg

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAREL ºAutor  ³Jean C. P. Saggin    º Data ³  27/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela montagem do boleto gráfico.        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento/Financeiro                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------------------*
Static Function MontaRel(lEnd, aMarked)
*-----------------------------------------*

Local nHeight   := 15
Local lBold     := .F.
Local lUnderLine:= .F.
Local lPixel    := .T.
Local lPrint    := .F.
Local nPag
Local nTPag     := 1
Local nLin      := 0
Local cPeriodo
Local lVisual   := .T.
Local lSend := .F.
Private M->FatorVcto := ""
Private M->FatVtoSic := ""
Private M->NumBoleta := ""
Private M->CodBarras := ""
Private M->LinhaDig  := ""
Private dvBol        := "  "
Private lContinua    := .T.
Private _BarPubl
Private _bLivre
Private nValLiq      := 0
Private aMensagem    := {}
Private aDadosBanco  := {}
Private aEmail       := {}
Private cNomePDF     := "default.rel"
Private oPrn
Private oPrnPDF
Private lAdjustToLegacy := .T.
Private lDisableSetup   := .T.
Private cFilePrint      := ""
Private aFiles           := {}

If !_auto
	Pergunte(cPerg,.F.)
Endif

cBanco   := MV_PAR16
cAgencia := MV_PAR17
cConta   := MV_PAR18
cSubCta  := MV_PAR19
cLinha   := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida Banco, Agência e Conta³  
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SA6")
dbSetOrder(1)
dbGotop()
If !dbSeek(xFilial("SA6")+cBanco+cAgencia+cConta)
	aAdd(aMsg, "BANCO "+ Trim(cBanco) + " AGÊNCIA "+ Trim(cAgencia) + " OU CONTA "+ Trim(cConta) +;
	" NAO ENCONTRADOS.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Posiciona na tabela de parâmetros de Bancos (SEE)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

dbSelectArea("SEE")
dbSetOrder(1)
if !dbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubCta)
	aAdd(aMsg, "OS PARÂMETROS DO BANCO "+Trim(cBanco)+", AGÊNCIA "+Trim(cAgencia)+", CONTA "+Trim(cConta)+" E SUBCONTA "+Trim(cSubCta)+;
	" PRECISAM ESTAR CADASTRADOS PARA QUE OS BOLETOS POSSAM SER EMITIDOS.")
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca quantidade de dias de protesto do cadastro de Parâmetros de Bancos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nDiasProtesto := SEE->EE_DIASPRO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Pega dados do Banco (SA6)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

dbSelectArea("SA6")
aDadosBanco := {SA6->A6_COD,;                  // 01 Código do Banco
Trim(SA6->A6_NOME),;                           // 02 Nome do Banco
Trim(SEE->EE_AGENCIA),;                        // 03 Agência
Trim(SEE->EE_DVAGE),;                          // 04 Dígito Verificador Agência
Trim(SEE->EE_CONTA),;                          // 05 Conta Corrente
Trim(SEE->EE_DVCTA),;                          // 06 Dígito Verificador Conta
"N",;                                          // 07 Aceite S/N
Trim(SEE->EE_CARTVAR),;                        // 08 Carteira de Cobranca
Trim(SEE->EE_CODEMP),;                         // 09 Código da Empresa
Trim(SEE->EE_X_COSMO),;                        // 10 Conta Cosmo (Santander)
Trim(SEE->EE_X_AGCOR),;                        // 11 Agência Bco Corresp
Trim(SEE->EE_X_CTACO),;                        // 12 Conta Bco Corresp
Trim(SEE->EE_FORMEN1)}                         // 13 Mensagem beneficiario fidcs
dbSelectArea("SE1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cálculo do dígito verificador do código da empresa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aDadosBanco[09] := fDadosBanco(aDadosBanco)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³ Inicializa Objetos de Impressao
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

If !_auto
	oPrn := TMSPrinter():New()
	oPrn:SetPortrait()
	
	oPrn:Setup()
	
	SetRegua(Len(aMarked))   
	
Endif

WHILE SE1->(!EOF())
	If !_auto
		IncRegua()
		If !Marked("E1_OK")
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
	Endif
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, .T. )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação para desconsiderar clientes cuja forma de pagamento for diferente de boleto.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Trim(SA1->A1_FORMPAG) != "BO"
		aAdd(aMsg, "TITULO: "+Trim(SE1->E1_NUM)+ iif(!Empty(SE1->E1_PARCELA)," "+SE1->E1_PARCELA+" "," ") +;
		" => FORM. DE PGTO CLIENTE "+ Trim(SE1->E1_CLIENTE) + " LOJA " + SE1->E1_LOJA +" É DIFERENTE DE BOLETO.")
		
		if _auto
			lFim := .T.
		EndIf
		
		dbSelectArea("SE1")
		dbSkip()
		Loop
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida CEP do Cliente³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lBcoValCep := .F.
	//lBcoValCep := cBanco $ "224/246/320/422/623/745" tirado validação de validação de cep do banco safra 422
	lBcoValCep := cBanco $ "224/246/320/623/745"
	
	if lBcoValCep .and. MV_PAR15 != 1
		//if cBanco $ "224/246/422/320/623" tirado validação de validação de cep do banco safra 422
		if cBanco $ "224/246/320/623"
			
			if !U_ValCepBrd("237", SA1->A1_CEP)
				aAdd(aMsg, "TITULO: "+Trim(SE1->E1_NUM)+ iif(!Empty(SE1->E1_PARCELA)," "+SE1->E1_PARCELA+" "," ") +;
				" => NÃO HÁ AGÊNCIA BRADESCO PARA O CEP "+Transform(SA1->A1_CEP,"@R 99999-999")+" DO CLIENTE "+ Trim(SE1->E1_CLIENTE) + " LOJA " + SE1->E1_LOJA +".")
				dbSelectArea("SE1")
				dbSkip()
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Validação do CEP na emissão do boleto Citibank³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
		ElseIf cBanco == "745"
			if !U_ValCepFaixa("745", SA1->A1_EST, SA1->A1_CEP)
				aAdd(aMsg, "TITULO: "+Trim(SE1->E1_NUM)+ iif(!Empty(SE1->E1_PARCELA)," "+SE1->E1_PARCELA+" "," ") +;
				" => NÃO HÁ PRAÇA CITIBANK PARA O CEP "+Transform(SA1->A1_CEP,"@R 99999-999")+" DO CLIENTE "+ Trim(SE1->E1_CLIENTE) + " LOJA " + SE1->E1_LOJA +".")				
				dbSelectArea("SE1")
				dbSkip()				
				Loop
			EndIf
			
		EndIf
	EndIf
	
	DbSelectArea("SE1")
	nValLiq := Round(SE1->E1_SALDO, 2)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³1ª Impressão³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Empty(SE1->E1_NUMBCO)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Forma sequencial do nosso número.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cNumBco := fSeqNNro(SEE->EE_FAXATU)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se o número sequencial está entre a faixa numérica estipulada pelo banco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if (Val(cNumBco) < Val(SEE->EE_FAXINI) .or. Val(cNumBco) > Val(SEE->EE_FAXFIM))
			aAdd(aMsg, "SEQUÊNCIA NUMERO "+AllTrim(cNumBco)+" FORA DA FAIXA PERMITIDA NO CADASTRO DE PARÂMETROS DE BANCOS, ENTRE EM CONTATO COM O FINANCEIRO (FAVOR NÃO EMITIR MAIS BOLETOS NESSA CONTA.).")
			Return
		endIf
		
		cSequencia   := AllTrim(cNumBco)
		M->NumBoleta := fGerNNro(cSequencia)
		dvBol 		   := fCalcDvNN(M->NumBoleta)
		_lGravaNNum  := .T.
		
	Else
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Bloqueio para fins de compatibilidade com a carteira vigente da Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  	If SE1->E1_EMISSAO <= StoD("20150519") .and. SE1->E1_PORTADO == '104' .and. Len(aDadosBanco[09]) != 12  //Caixa Econômica Federal
     	aAdd(aMsg, "TITULO: "+Trim(SE1->E1_NUM)+ iif(!Empty(SE1->E1_PARCELA)," "+SE1->E1_PARCELA+" "," ") +;
  	 	" => O TÍTULO FOI IMPRESSO EM OUTRA MODALIDADE DE COBRANCA, POR ISSO NAO PODERA SER REIMPRESSO!")
  		dbSkip()
  		Loop
  	EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Valida se o boleto foi impresso em outro banco para evitar erro de recálculo de nosso número e código de barras³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	    
 		If AllTrim(SE1->E1_PORTADO) != aDadosBanco[01] .or. AllTrim(SE1->E1_AGEDEP) != aDadosBanco[03] .or. AllTrim(SE1->E1_CONTA) != aDadosBanco[05]
			aAdd(aMsg, "TITULO: "+Trim(SE1->E1_NUM)+ iif(!Empty(SE1->E1_PARCELA)," "+SE1->E1_PARCELA+" "," ") +;
			" => O TÍTULO JÁ FOI REGISTRADO NO BANCO "+SE1->E1_PORTADO+" AGENCIA: "+SE1->E1_AGEDEP+" CONTA "+SE1->E1_CONTA+".")
			dbSelectArea("SE1")
			dbSkip()
			Loop
		Endif
				
		

		M->NumBoleta := fMontaSeq(SE1->E1_NUMBCO)
		dvBol 		   := fCalcDvNN(M->NumBoleta)
		_lGravaNNum := .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o nosso número já existe antes de gravá-lo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	lNNOk := U_ValidNNum(aDadosBanco[01], AllTrim(M->NumBoleta)+AllTrim(dvBol))
	While (!lNNOk .And. Empty(SE1->E1_NUMBCO))
		cSequencia   := fSeqNNro(SEE->EE_FAXATU)
		M->NumBoleta := fGerNNro(cSequencia)
		dvBol		     := fCalcDvNN(M->NumBoleta)
		lNNOk := U_ValidNNum(aDadosBanco[01], AllTrim(M->NumBoleta)+AllTrim(dvBol))
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³ Grava dados no SE1 (Titulos Receber)
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	dbSelectArea("SE1")
	
	If _lGravaNNum .And. (mv_Par15 != 1)
		RecLock("SE1",.F.)
		SE1->E1_NUMBCO := AllTrim(M->NumBoleta) + AllTrim(dvBol)
		If !SEE->(EOF())
			SE1->E1_PORTADO := SEE->EE_CODIGO
            SE1->E1_AGEDEP  := SEE->EE_AGENCIA 
			SE1->E1_CONTA   := SEE->EE_CONTA
			
						
		EndIf
		DbCommit()
		MsUnlock("SE1")
	Endif
	
	dbSelectArea("SE1")
	
	_dDataVencto := SubStr(DtoS(SE1->E1_VENCREA),7,2)+"/"+SubStr(DtoS(SE1->E1_VENCREA),5,2)+"/"+SubStr(DtoS(SE1->E1_VENCREA),1,4)
	
	aMensagem := {}
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Particularidade do banco ABC³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	if aDadosBanco[01] == "246"
		Aadd(aMensagem, "Título transferido ao Banco ABC Brasil S/A.")
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade do Banco do Brasil³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if aDadosBanco[01] == "001"
		Aadd(aMensagem, "Não dispensar juros de mora.")
	EndIf      
	                           
	                          
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³Particularidade do Bic Banco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	                                                              

	if aDadosBanco[01] == "320"
		Aadd(aMensagem, "Tit. cedido fiduciariamente, não pagar diretamente à "+Upper(Trim(SubStr(SM0->M0_NOMECOM, 01, 30)))+".")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ$
	//³Banco Votorantim³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ$
	
	ElseIf aDadosBanco[01] == "655"
		Aadd(aMensagem, "Titulo caucionado em favor do BANCO VOTORANTIM S/A.")
	
	
	
	Aadd(aMensagem, "Pagamento através de DOC, TED, Transferência ou Depósito Bancário não quitam o boleto.")    
	
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe percentual de multa cadastrado para o bancoÄ¿
	//particularidade fidic creditise                                .³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if SA6->A6_X_JUROS > 0 .and. aDadosBanco[05] == "0002364"
        Aadd(aMensagem, "Cobrar mora de "+AllTrim(Transform((SA6->A6_X_JUROS)," @E 99,999.99")) + "% a.m. de atraso")
	EndIf
	
	
	if SA6->A6_X_MULTA > 0 .and. aDadosBanco[05] == "0002364"
			Aadd(aMensagem, "Após o vencimento cobrar multa de "+AllTrim(Transform((SA6->A6_X_MULTA)," @E 99,999.99")) + "%" )
	EndIf 
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe percentual de multa cadastrado para o banco.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if SA6->A6_X_MULTA > 0  .and. aDadosBanco[05] != "0002364"
        Aadd(aMensagem, "Após "+ _dDataVencto +" cobrar multa de R$ "+AllTrim(Transform((nValLiq*(SA6->A6_X_MULTA/100)),"@E 99,999.99")))
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe percentual de juros cadastrado para o banco.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	if SA6->A6_X_JUROS > 0  .and. aDadosBanco[05] != "0002364"
			Aadd(aMensagem, "Após "+ _dDataVencto +" cobrar juros/mora diária de R$ " +AllTrim(Transform(((nValLiq*(SA6->A6_X_JUROS/100))/30)," @E 99,999.99")))
	EndIf   

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se existe acrescimo para o titulo                    .³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    if SE1->E1_ACRESC > 0  
			Aadd(aMensagem, "Cobrar Acréscimo de R$ " +AllTrim(Transform(se1->e1_acresc," @E 99,999.99")))
	EndIf   

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se está habilitado o parâmetro "Protestar"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ        
	
	
	if SEE->EE_PROTEST .or. SuperGetMv("MV_MSGPROT",,.F.)
		If !Empty(nDiasProtesto) .and. aDadosBanco[05] != "0002364"
			Aadd(aMensagem, "Sujeito a protesto após "+ nDiasProtesto+" dias do vencimento.") 
		EndIf
		//particularidade para banco creditise
		If !Empty(nDiasProtesto) .and. aDadosBanco[05] == "0002364"
			Aadd(aMensagem, "Protestar após "+ nDiasProtesto+" dias de vencido.") 
		EndIf
	EndIf 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³JEAN - 08/05 - FINAL 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica se o título tem desconto incondicional.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	If (SE1->E1_DECRESC > 0)
		Aadd(aMensagem, "Conceder abatimento no valor de R$ " +AllTrim(Transform(SE1->E1_DECRESC,PesqPict("SE1","E1_VALOR"))))
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Verifica se o título tem desconto condicional.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	If (SE1->E1_DESCONT > 0)
		Aadd(aMensagem, "Para pagamento até "+ Transform(SE1->E1_VENCREA,"@E") + " conceder desconto de R$ " +;
		AllTrim(Transform(SE1->E1_DESCONT,PesqPict("SE1","E1_VALOR"))))
	endIf    
	         
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade do BIC para impressão de dados da Empresa³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if aDadosBanco[01] == "320"
		Aadd(aMensagem, Upper(Trim(SM0->M0_NOMECOM)) + " CNPJ: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))
		Aadd(aMensagem, Upper(Trim(SM0->M0_ENDENT)))
		Aadd(aMensagem, SubStr(SM0->M0_CEPENT,01,02) +"."+ SubStr(SM0->M0_CEPENT,03,03) +"-"+ SubStr(SM0->M0_CEPENT,06,03) +;
		" "+ Upper(Trim(SM0->M0_CIDENT)) + " " + SM0->M0_ESTENT)
	EndIf
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Imprime o Boleto referente ao Titulo atual (objeto oPrn)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//aEmail := {}

	aAdd(aEmail, {Upper(AllTrim(SubStr(Posicione("SA1",1, xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_NOME"),01,30))),;
								Posicione("SA1",1, xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_CGC"),;
								SE1->E1_NUM,;
								SE1->E1_PREFIXO})
								
	
	fImpPagina(oPrn)
	
	dbSkip()
	
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime direto na impressora ou Visualiza antes de imprimir ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !_auto
	
	if Len(aFiles) > 0
		cMsgInt := U_RJENVCDR(aFiles, .T.,,,aEmail)
		if !Empty(cMsgInt)
			Alert("Erros na integração: " + cMsgInt)
		endIf
	endIf

	oPrn:Preview()
/* GUSTAVO 06/03/2017
Else
	
	lSend := Len(aFiles) > 0
		                                                                                                
	If lSend .and. (Len(aEmail) > 0)
   		U_MailCPX(aFiles,aEmail[01,01],aEmail[01,03],aEmail[01,04],aEmail[01,02])
	Endif
*/	
Endif

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡¿
//³Controle de impressão das vias do boleto.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡Ù

Static Function fImpPagina(oPrn)

Local _nLinBase := 0 
Local lGeraPDF := GetNewPar("CN_CDRENT", .F.)
Local cFilePDF, cPathLoc, cTempPath
Local _nLinBAt
Private cDvCod  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`
//³Fonte utilizadas para impressão dos boletos.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`

if !_auto

	oFont1 :=     TFont():New("Arial"      		,09,08,,.F.,,,,,.F.)            //** Título das Grades
	oFont2 :=     TFont():New("Arial"      		,09,09,,.F.,,,,,.F.)            //** Conteúdo Campos
	oFont3Bold := TFont():New("Arial"			    ,09,15,,.T.,,,,,.F.)            //** Dados do Recibo de Entrega
	oFont4 := 	  TFont():New("Arial"      		,09,12,,.T.,,,,,.F.)            //** Codigo de Compensação do Banco
	oFont5 := 	  TFont():New("Arial"      		,09,18,,.T.,,,,,.F.)            //** Codigo de Compensação do Banco
	oFont6 := 	  TFont():New("Arial"      	  ,09,14,,.T.,,,,,.F.)            //** Conteudo dos Campos em Negrito
	oFont7 := 	  TFont():New("Arial"         ,09,10,,.T.,,,,,.F.)            //** Dados do Cliente
	oFont8 := 	  TFont():New("Arial"         ,09,09,,.F.,,,,,.F.)	          //** Conteudo Campos
	oFont9 := 	  TFont():New("Arial"         ,09,12,,.F.,,,,,.F.)            //** Linha Digitavel
	oFont18n   := TFont():New("Arial"         ,09,18,.T.,.T.,5,.T.,5,.T.,.F.) //** Para Código do banco

Else
  
	cNomePDF := cEmpAnt + cFilAnt + Trim(SE1->E1_NUM) + Trim(SE1->E1_PREFIXO) + Trim(SE1->E1_PARCELA) + ".rel"
	
	lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
	lDisableSetup   := .T.
	oPrn := FWMSPrinter():New(cNomePDF, IMP_PDF, lAdjustToLegacy, , lDisableSetup, , , , .F., , .F.)
	
	oPrn:SetResolution(78)
	oPrn:SetPortrait()
	oPrn:SetPaperSize(DMPAPER_A4) 
	oPrn:SetMargin(00,00,00,00)
	oPrn:linjob   :=.F.
	
	Private PixelX := oPrn:nLogPixelX()
	Private PixelY := oPrn:nLogPixelY()
	Private nConsNeg := 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
	Private nConsTex := 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.
	
	oPrn:cPathPDF := CLOCPDF
	oPrn:SetDevice(IMP_PDF)
	oPrn:SetViewPDF(.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Deixado diferenciada a criação das fontes pra tratar impressão automática, mas para geração de pdf o sistema não respeita as fontes setadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	/*
	oFont1 :=     TFontEx():New(oPrn,"Times New Roman",20,20,.T.,.T.,.F.)
	oFont2 :=     TFont():New( "Times New Roman", , 5, .T.)
	oFont3Bold := TFont():New( "Times New Roman", , 5, .T.)
	oFont4 := 	  TFont():New( "Times New Roman", , 5, .T.)
	oFont5 := 	  TFont():New( "Times New Roman", , 5, .T.)
	oFont6 := 	  TFont():New( "Times New Roman", , 5, .T.)
	oFont7 := 	  TFont():New( "Times New Roman", , 5, .T.)
	oFont8 := 	  TFont():New( "Times New Roman", , 50, .T.)
	oFont9 := 	  TFont():New( "Times New Roman", , 50, .T.)
	oFont18n :=   TFontEx():New(oPrn,"Times New Roman",20,20,.T.,.T.,.F.)   
	*/
	
	oFont1 :=     TFont():New("Arial"      		,09,08,,.F.,,,,,.F.)            //** Título das Grades
	oFont2 :=     TFont():New("Arial"      		,09,09,,.F.,,,,,.F.)            //** Conteúdo Campos
	oFont3Bold := TFont():New("Arial"			    ,09,15,,.T.,,,,,.F.)            //** Dados do Recibo de Entrega
	oFont4 := 	  TFont():New("Arial"      		,09,12,,.T.,,,,,.F.)            //** Codigo de Compensação do Banco
	oFont5 := 	  TFont():New("Arial"      		,09,18,,.T.,,,,,.F.)            //** Codigo de Compensação do Banco
	oFont6 := 	  TFont():New("Arial"      	  ,09,14,,.T.,,,,,.F.)            //** Conteudo dos Campos em Negrito
	oFont7 := 	  TFont():New("Arial"         ,09,10,,.T.,,,,,.F.)            //** Dados do Cliente
	oFont8 := 	  TFont():New("Arial"         ,09,09,,.F.,,,,,.F.)	          //** Conteudo Campos
	oFont9 := 	  TFont():New("Arial"         ,09,12,,.F.,,,,,.F.)            //** Linha Digitavel
	oFont18n   := TFont():New("Arial"         ,09,18,.T.,.T.,5,.T.,5,.T.,.F.) //** Para Código do banco
	
EndIf


// Faz o controle de geração de PDF dos boletos
if lGeraPDF
	cTempPath := "\nfe\"
	cPathLoc := GetTempPath(.T.)                       
	
	cFilePDF := "bol_" + Trim(cEmpAnt) + Trim(SE1->E1_FILIAL) + Trim(SE1->E1_NUM) + Trim(SE1->E1_PARCELA) + ".rel"

	oPrnPDF := FWMSPrinter():New(cFilePDF, IMP_PDF, .F., , .T.)
	
	
	oPrnPDF:SetResolution(78)
	oPrnPDF:SetPortrait()
	oPrnPDF:SetPaperSize(DMPAPER_A4) 
	oPrnPDF:SetMargin(00,00,00,00)
	oPrnPDF:linjob   :=.F.
	
	oPrnPDF:cPathPDF := cPathLoc
	oPrnPDF:SetDevice(IMP_PDF)
	oPrnPDF:SetViewPDF(.F.)
	//oDanfePDF:lServer := .F.
endIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0
//³Atribui o Dígito do Codigo do Banco a uma Variável³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0

cDvCod := fDvBco(aDadosBanco[01])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calcula o Código de Barras³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

M->CodBarras := fCodigoBarras(aDadosBanco[01])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montar a Linha Digitavel da Boleta³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

M->LinhaDig := fLinhaDigitavel(aDadosBanco[01])

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³RECIBO DE ENTREGA (Terceira Via)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

_nLinBase := 0 
if !_auto
	fImprimeVia( 3, _nLinBase, oPrn )
	// faz o controle para voltar a linha anterior
	if lGeraPDF
		//_nLinBAt := _nLinBase
		//_nLinBase := 0
		fImpPDF( 3, _nLinBase, oPrnPDF )
		//_nLinBase := _nLinBAt
	endIf
Else
	fImpPDF(3, _nLinBase, oPrn )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÏ
//³RECIBO DO PAGADOR (Segunda Via)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÏ

if !_auto
	_nLinBase := 1100
	fImprimeVia( 2, _nLinBase, oPrn )
	// faz o controle para voltar a linha anterior
	if lGeraPDF
		//_nLinBAt := _nLinBase
		//_nLinBase := 1100
		_nLinBase := (1100/4)
		fImpPDF( 2, _nLinBase, oPrnPDF )
		//_nLinBase := _nLinBAt
	endIf
Else 
	_nLinBase := (1100/4)
	fImpPDF(2, _nLinBase, oPrn )	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FICHA DE COMPENSAÇÃO (Primeira Via)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !_auto
	_nLinBase := 2200
	fImprimeVia( 1, _nLinBase, oPrn )
	// faz o controle para voltar a linha anterior
	if lGeraPDF
		//_nLinBAt := _nLinBase
		//_nLinBase := 2200
		_nLinBase := (2200/4)
		fImpPDF( 1, _nLinBase, oPrnPDF )
		//_nLinBase := _nLinBAt
	endIf
Else                                 
	_nLinBase := (2200/4)
	fImpPDF(1, _nLinBase, oPrn )
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a Pagina  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !_auto
	oPrn:EndPage()
	
	// Continuar
	if lGeraPDF
		oPrnPDF:Print()
		FreeObj(oPrnPDF)
	  
	  // copia o pdf gerado para o servidor
		cFilePDF := SubStr(cFilePDF, 1, Len(cFilePDF) - 4) + ".pdf"
		CpyT2S(cPathLoc + cFilePDF, cTempPath, .F.)
	
		aAdd(aFiles, {cTempPath + cFilePDF, ;
		             Trim(cEmpAnt) + Trim(SE1->E1_FILIAL) + Trim(SE1->E1_NUM) + Trim(SE1->E1_PARCELA),;
								 SE1->E1_NUM, SE1->E1_SERIE, SE1->E1_PARCELA, SE1->E1_PREFIXO, DToS(SF2->F2_EMISSAO), SE1->E1_FILIAL})		
	endIf
	
Else
	oPrn:Print()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 10/09/14 - VALIDA SE ARQUIVO EXISTE ANTES DE ADICIONAR À VARIÁVEL AFILES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ValType(cFileXML) == "C"
		if File(cFileXML)
			aAdd(aFiles, {cFileXML})
		EndIf
	EndIf 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 10/09/14 - VALIDA SE ARQUIVO EXISTE ANTES DE ADICIONAR À VARIÁVEL AFILES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	if ValType(aFileDnf) == "A"
		If File(aFileDnf[01] + aFileDnf[02])
			if CpyT2S(aFileDnf[01] + aFileDnf[02], CDIRSRV, .F.)
				aAdd(aFiles, {CDIRSRV + aFileDnf[02]})
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 10/09/14 - VALIDA SE ARQUIVO EXISTE ANTES DE ADICIONAR À VARIÁVEL AFILES³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
	if File(oPrn:cPathPDF + cEmpAnt + cFilAnt + Trim(SE1->E1_NUM) + Trim(SE1->E1_PREFIXO) + Trim(SE1->E1_PARCELA) + ".pdf")
		If CpyT2S(oPrn:cPathPDF + cEmpAnt + cFilAnt + Trim(SE1->E1_NUM) + Trim(SE1->E1_PREFIXO) + Trim(SE1->E1_PARCELA) + ".pdf", CDIRSRV, .F.)
			aAdd(aFiles, {CDIRSRV + cEmpAnt + cFilAnt + Trim(SE1->E1_NUM) + Trim(SE1->E1_PREFIXO) + Trim(SE1->E1_PARCELA) + ".pdf"})
		EndIf
	EndIf                                                                                                                            
	
	FreeObj(oPrn)
	
EndIf

Return Nil


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime via do boleto de acordo com o parâmetro informado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fImprimeVia( _nVia, _nL, oPrn )
Local _nPapel  := 1
Local _nLBarra := 0
Local _nCol    := -70
Local _nVaria  := 190

//** TODOS **
Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Laser A4³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case _nPapel = 1
		_nL -= 85
		_nLBarra := 23.7
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para Laser Oficio 2 (216 x 330)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case _nPapel = 2
		_nL += 50
		_nLBarra := 29.6
EndCase

oPrn:Line(_nL+80,690,_nL+150,690)  //** Linhas Verticais do Codigo
oPrn:Line(_nL+80,900,_nL+150,900)  //** Ex:  | 001-9 |

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³Valida se existe imagem de logo pra por no boleto, senão imprime o nome do banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù

if fValImage(aDadosBanco[01])
	oPrn:sayBitmap(_nL+080,30,"/system/"+aDadosBanco[01]+".bmp",350,78)
Else
	oPrn:Say(_nL+090,0100,aDadosBanco[02],oFont3Bold,100)
EndIf

oprn:say(_nL+080,0710,fRetCodBco(aDadosBanco[01])+cDvCod,oFont18n)   			//** Codigo "001-9"

oPrn:Box(_nL+160,_nCol+0100,_nL+240,_nCol+1500+_nVaria)         			//** Local de Pagamento
oPrn:Box(_nL+160,_nCol+1500+_nVaria,_nL+240,_nCol+2200+_nVaria) 			//** Vencimento
oprn:box(_nL+240,_nCol+0100,_nL+320,_nCol+1500+_nVaria)         			//** Beneficiário
oprn:box(_nL+240,_nCol+1500+_nVaria,_nL+320,_nCol+2200+_nVaria) 			//** Agencia / Codigo Beneficiário
oprn:box(_nL+320,_nCol+0100,_nL+400,_nCol+0380) 											//** Data Documento
oprn:box(_nL+320,_nCol+0380,_nL+400,_nCol+0700) 											//** Nr Documento
oprn:box(_nL+320,_nCol+0700,_nL+400,_nCol+0890) 											//** Especie Doc
oprn:box(_nL+320,_nCol+0890,_nL+400,_nCol+1060)
oprn:box(_nL+320,_nCol+1060,_nL+400,_nCol+1500+_nVaria)
oprn:box(_nL+320,_nCol+1500+_nVaria,_nL+400,_nCol+2200+_nVaria)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Tratativa para o campo CIP (particularidade de alguns bancos)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Do Case
	
	//ÚÄÄÄÄÄÄÄÄ¿
	//³BicBanco³
	//ÀÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "320"
		oprn:box(_nL+400,_nCol+0100,_nL+480,_nCol+0350)         					//** Uso do Banco
		oprn:say(_nL+400,_nCol+0120,"Uso do Banco",oFont1,100)
		oprn:say(_nL+430,_nCol+0120,cCpoUsoBco(aDadosBanco[01]),oFont2,100)
		
		oprn:box(_nL+400,_nCol+0350,_nL+480,_nCol+0450) 									//** CIP
		oprn:say(_nL+400,_nCol+0370,"CIP",oFont1,100)
		oprn:say(_nL+430,_nCol+0370,"521",oFont2,100)
		
		oprn:box(_nL+400,_nCol+0450,_nL+480,_nCol+0650) 									//** Carteira
		oprn:say(_nL+400,_nCol+0470,"Carteira",oFont1,100)
		oprn:say(_nL+430,_nCol+0470,fCpoCart(aDadosBanco),oFont2,100)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		oprn:box(_nL+400,_nCol+0100,_nL+480,_nCol+0350)         					//** Uso do Banco
		oprn:say(_nL+400,_nCol+0120,"Uso do Banco",oFont1,100)
		oprn:say(_nL+430,_nCol+0120,cCpoUsoBco(aDadosBanco[01]),oFont2,100)
		
		oprn:box(_nL+400,_nCol+0350,_nL+480,_nCol+0450) 									//** CIP
		oprn:say(_nL+400,_nCol+0370,"CIP",oFont1,100)
		oprn:say(_nL+430,_nCol+0370,"000",oFont2,100)
		
		oprn:box(_nL+400,_nCol+0450,_nL+480,_nCol+0650) 									//** Carteira
		oprn:say(_nL+400,_nCol+0470,"Carteira",oFont1,100)
		oprn:say(_nL+430,_nCol+0470,fCpoCart(aDadosBanco),oFont2,100)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		oprn:box(_nL+400,_nCol+0100,_nL+480,_nCol+0350)         					//** Uso do Banco
		oprn:say(_nL+400,_nCol+0120,"Uso do Banco",oFont1,100)
		oprn:say(_nL+430,_nCol+0120,cCpoUsoBco(aDadosBanco[01]),oFont2,100)
		
		oprn:box(_nL+400,_nCol+0350,_nL+480,_nCol+0450) 									//** CIP
		oprn:say(_nL+400,_nCol+0370,"CIP",oFont1,100)
		oprn:say(_nL+430,_nCol+0370,"504",oFont2,100)
		
		oprn:box(_nL+400,_nCol+0450,_nL+480,_nCol+0650) 									//** Carteira
		oprn:say(_nL+400,_nCol+0470,"Carteira",oFont1,100)
		oprn:say(_nL+430,_nCol+0470,fCpoCart(aDadosBanco),oFont2,100)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		oprn:box(_nL+400,_nCol+0100,_nL+480,_nCol+0650) 									//** Carteira
		oprn:say(_nL+400,_nCol+0320,"Carteira",oFont1,100)
		oprn:say(_nL+430,_nCol+0120,fCpoCart(aDadosBanco),oFont2,100)
		
	OtherWise
		oprn:box(_nL+400,_nCol+0100,_nL+480,_nCol+0350)         					//** Uso do Banco
		oprn:say(_nL+400,_nCol+0120,"Uso do Banco",oFont1,100)
		oprn:say(_nL+430,_nCol+0120,cCpoUsoBco(aDadosBanco[01]),oFont2,100)
		
		oprn:box(_nL+400,_nCol+0350,_nL+480,_nCol+0650)      							//** Carteira
		oprn:say(_nL+400,_nCol+0400,"Carteira",oFont1,100)
		oprn:say(_nL+430,_nCol+0450,fCpoCart(aDadosBanco),oFont2,100)
		
EndCase

oprn:box(_nL+400,_nCol+0650,_nL+480,_nCol+0800)         							//** Espécie
oprn:box(_nL+400,_nCol+0800,_nL+480,_nCol+1210)         							//** Quantidade
oprn:box(_nL+400,_nCol+1210,_nL+480,_nCol+1500+_nVaria) 							//** Valor
oprn:box(_nL+400,_nCol+1500+_nVaria,_nL+480,_nCol+2200+_nVaria)
oprn:box(_nL+480,_nCol+0100,_nL+0880,_nCol+2200+_nVaria)
oprn:box(_nL+880,_nCol+0100,_nL+1020,_nCol+2200+_nVaria)
oprn:box(_nL+1020,_nCol+0100,_nL+1055,_nCol+2200+_nVaria)

If _nVia == 1 .or. _nVia == 2
	oprn:box(_nL+480,_nCol+1500+_nVaria,_nL+560,_nCol+2200+_nVaria)
	oprn:box(_nL+560,_nCol+1500+_nVaria,_nL+640,_nCol+2200+_nVaria)
	oprn:box(_nL+640,_nCol+1500+_nVaria,_nL+720,_nCol+2200+_nVaria)
	oprn:box(_nL+720,_nCol+1500+_nVaria,_nL+800,_nCol+2200+_nVaria)
	oprn:box(_nL+800,_nCol+1500+_nVaria,_nL+880,_nCol+2200+_nVaria)
Endif

oprn:say(_nL+160,_nCol+0120,"Local de Pagamento",oFont1,100)
oprn:say(_nL+190,_nCol+0120,fRetLocPag(aDadosBanco[01]),oFont2,100)
oprn:say(_nL+160,_nCol+1520+_nVaria,"Vencimento",oFont1,100)

_cDataTmp := Substr(DtoS(SE1->E1_VENCREA),7,2) + "/" + ;
Substr(DtoS(SE1->E1_VENCREA),5,2) + "/" + ;
Substr(DtoS(SE1->E1_VENCREA),1,4)

oprn:say(_nL+190,_nCol+2150+_nVaria,_cDataTmp,oFont7,,,,PAD_RIGHT)

oprn:say(_nL+240,_nCol+0120,"Beneficiário",oFont1,100)
oprn:say(_nL+270,_nCol+0120,fRetCed(aDadosBanco[01]), oFont2,100)
oprn:say(_nL+240,_nCol+1520+_nVaria,"Agência / Código Beneficiário",oFont1,100)
oprn:say(_nL+270,_nCol+2150+_nVaria,fAgeCodCed(aDadosBanco), oFont7,,,, PAD_RIGHT)

oprn:say(_nL+320,_nCol+0120,"Data do Documento",oFont1)

_cDataTmp := Substr(DtoS(SE1->E1_EMISSAO),7,2) + "/" + ;
Substr(DtoS(SE1->E1_EMISSAO),5,2) + "/" + ;
Substr(DtoS(SE1->E1_EMISSAO),1,4)

oprn:say(_nL+350,_nCol+0120,_cDataTmp,oFont2,100)
oprn:say(_nL+320,_nCol+0390,"Número do Documento",oFont1,100)
oprn:say(_nL+350,_nCol+0400,fNroDoc(aDadosBanco[01]),oFont2,100)
oprn:say(_nL+320,_nCol+0720,"Espécie Doc",oFont1,100)
oprn:say(_nL+350,_nCol+0720,fEspDoc(aDadosBanco[01]),oFont2,100)
oprn:say(_nL+320,_nCol+0900,"Aceite",oFont1,100)
oprn:say(_nL+350,_nCol+0910,fRetAce(aDadosBanco),oFont2,100)
oprn:say(_nL+320,_nCol+1080,"Data Processamento",oFont1,100)

_cDataTmp := Substr(DtoS(dDataBase),7,2) + "/" + ;
Substr(DtoS(dDataBase),5,2) + "/" + ;
Substr(DtoS(dDataBase),1,4)

oprn:say(_nL+350,_nCol+1180,_cDataTmp,oFont2,100)

oprn:say(_nL+320,_nCol+1520+_nVaria, fLbCpoNNro(aDadosBanco[01]),oFont1,PAD_RIGHT)
oprn:say(_nL+350,_nCol+2150+_nVaria, fCpoNNro(M->NumBoleta, dvBol, aDadosBanco),oFont7,,,,PAD_RIGHT)

oprn:say(_nL+400,_nCol+0670,fLbEsp(aDadosBanco[01]),oFont1,100)
oprn:say(_nL+430,_nCol+0670,fEspecie(aDadosBanco[01]),oFont2,100)
oprn:say(_nL+400,_nCol+0820,"Quantidade",oFont1,100)
oprn:say(_nL+400,_nCol+1240,"Valor",oFont1,100)
oprn:say(_nL+400,_nCol+1520+_nVaria,"(=) Valor do Documento",oFont1,100)
oprn:say(_nL+430,_nCol+2143+_nVaria,Transform(nValLiq,"@E 999,999,999.99"),oFont7,,,,PAD_RIGHT)

If _nVia == 1
	
	oprn:say(_nL+480,_nCol+0120,"Instruções (Todas as instruções desse bloqueto são de exclusiva responsabilidade do cedente)",oFont1,100)
	oprn:say(_nL+480,_nCol+1520+_nVaria,"(-) Desconto",oFont1,100)
	oprn:say(_nL+560,_nCol+1520+_nVaria,"(-) Outras Deduções (abatimento)",oFont1,100)
	oprn:say(_nL+640,_nCol+1520+_nVaria,"(+) Mora / Multa (Juros)",oFont1,100)
	oprn:say(_nL+720,_nCol+1520+_nVaria,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(_nL+800,_nCol+1520+_nVaria,"(=) Valor Cobrado",oFont1,100)       
	

	_nQtdLin := 0
	_nCtr    := 1
	_nQtdIni := 510
	for _nCtr := 1 to len(aMensagem)
		oprn:say(_nL+(_nQtdIni+_nQtdLin),0120, aMensagem[_nCtr], oFont2,100)
		_nQtdLin += 40
	Next _nCtr
	
	cTelCob := ""
	cTelCob := SuperGetMv("MV_TELCOB",,"("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8))
	if Empty(cTelCob)
		cTelCob := "("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8)
	EndIf  
	                   
	
	
	
	If  cBanco == "237" .and. (AllTrim(cConta)) == '0014046'
        oprn:say(_nL+845,0120," Central de Cobrança: 41-3083-6999/cobranca@adnfomento.com.br ",oFont1,100) 
        
    elseif  cBanco == "237" .and. (AllTrim(cConta)) == '0003098'
        oprn:say(_nL+800,0120,"TITULO CEDIDO A SIFRA S/A",oFont1,100) 
        oprn:say(_nL+845,0120,"DUVIDAS SOBRE COBRANÇA, LIGUE "+cTelCob,oFont1,100)    
	
	elseif cBanco == "237" .and. (AllTrim(cConta)) == '0838500'
        oprn:say(_nL+845,0120," PROTESTAR EM 5 DIAS. DÚVIDAS TEL. (47)3355-9981 E-MAIL comercial@rnxfidc.com.br ",oFont1,100) 
     
    elseif cBanco == "237" .and. (AllTrim(cConta)) == '0002364'
        oprn:say(_nL+845,0120,"Título cedido ao Creditise FIDC NP",oFont1,100)    
	
	else
    	oprn:say(_nL+845,0120,"DUVIDAS SOBRE COBRANÇA, LIGUE "+cTelCob,oFont1,100)
	endif

	
	
	
ElseIf _nVia == 2
	oprn:say(_nL+480,_nCol+1520+_nVaria,"(-) Desconto",oFont1,100)
	oprn:say(_nL+560,_nCol+1520+_nVaria,"(-) Outras Deduções (abatimento)",oFont1,100)
	oprn:say(_nL+640,_nCol+1520+_nVaria,"(+) Mora / Multa (Juros)",oFont1,100)
	oprn:say(_nL+720,_nCol+1520+_nVaria,"(+) Outros Acréscimos",oFont1,100)
	oprn:say(_nL+800,_nCol+1520+_nVaria,"(=) Valor Cobrado",oFont1,100)
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade Caixa    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		if aDadosBanco[01] == "104"
		oprn:say(_nL+1057,0050,"SAC CAIXA 0800 726 0101 (informações, reclamações, sugestões e elogios)",oFont1,100) 
		oprn:say(_nL+1083,0050,"Para pessoas com deficiência auditiva ou de fala: 08007262492",oFont1,100) 
		oprn:say(_nL+1113,0050,"Ouvidoria: 0800 725 7474 ",oFont1,100) 
    EndIf
                                    
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade BIC Banco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if aDadosBanco[01] == "320"
		oprn:say(_nL+480,_nCol+0120,"Instruções (Todas as instruções desse bloqueto são de exclusiva responsabilidade do cedente)",oFont1,100)
	Else
		oprn:say(_nL+480,_nCol+0120,"Dados do Beneficiário",oFont1,100)
	EndIf
	     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4¿
	//³Particularidade de Mensagem do BIC Banco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4Ù
	
	if aDadosBanco[01] == "320"
		_nQtdLin := 0
		_nCtr    := 1
		_nQtdIni := 510
		for _nCtr := 1 to len(aMensagem)
			oprn:say(_nL+(_nQtdIni+_nQtdLin),0120, aMensagem[_nCtr], oFont2,100)
			_nQtdLin += 40
		Next _nCtr       
		

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4¿
	//³Particularidade de Mensagem dos FIDC Banco 237³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4Ù
	
	elseif aDadosBanco[01] == "237" .and. (AllTrim(cConta)) == '0014046'
     		
        oprn:say(_nL+590,0120,"  ", oFont2,100)
        
    elseif aDadosBanco[01] == "237" .and. (AllTrim(cConta)) == '0195660'
     		
        oprn:say(_nL+590,0120,"  ", oFont2,100)
            
    elseif aDadosBanco[01] == "237" .and. (AllTrim(cConta)) == '0838500'
     		
        oprn:say(_nL+590,0120,"  ", oFont2,100)	  
        
        
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³Particularidade do Bic Safra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
    ElseIf aDadosBanco[01] == "422"
        oprn:say(_nL+510,0120,"Este boleto representa duplicata cedida fiduciariamente ao banco Safra S/A,  ", oFont2,100)  
        oprn:say(_nL+545,0120,"ficando vedado o pagamento de qualquer outra forma que não através do presente boleto.", oFont2,100)     
        oprn:say(_nL+590,0120, Upper(Trim(SM0->M0_NOMECOM)) + " CNPJ: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont2,100)
		oprn:say(_nL+630,0120, Upper(Trim(SM0->M0_ENDENT)), oFont2, 100)
		oprn:say(_nL+670,0120, SubStr(SM0->M0_CEPENT,01,02) +"."+ SubStr(SM0->M0_CEPENT,03,03) +"-"+ SubStr(SM0->M0_CEPENT,06,03) +;
		" "+ Upper(Trim(SM0->M0_CIDENT)) + " " + SM0->M0_ESTENT, oFont2, 100)		       	
		
	Else
		oprn:say(_nL+590,0120, Upper(Trim(SM0->M0_NOMECOM)) + " CNPJ: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont2,100)
		oprn:say(_nL+630,0120, Upper(Trim(SM0->M0_ENDENT)), oFont2, 100)
		oprn:say(_nL+670,0120, SubStr(SM0->M0_CEPENT,01,02) +"."+ SubStr(SM0->M0_CEPENT,03,03) +"-"+ SubStr(SM0->M0_CEPENT,06,03) +;
		" "+ Upper(Trim(SM0->M0_CIDENT)) + " " + SM0->M0_ESTENT, oFont2, 100)
	EndIf
	
	cTelCob := ""
	cTelCob := SuperGetMv("MV_TELCOB",,"("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8))
	if Empty(cTelCob)
		cTelCob := "("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8)
	EndIf 
	

	
	If  cBanco == "237" .and. (AllTrim(cConta)) == '0014046'
        oprn:say(_nL+590,0120," Central de Cobrança: 41-3083-6999/cobranca@adnfomento.com.br ",oFont1,100) 
	
	elseif cBanco == "237" .and. (AllTrim(cConta)) == '0838500'
        oprn:say(_nL+590,0120," PROTESTAR EM 5 DIAS. DÚVIDAS TEL. (47)3355-9981 E-MAIL comercial@rnxfidc.com.br ",oFont1,100)
	
	else
	    oprn:say(_nL+710,0120,"DUVIDAS SOBRE COBRANÇA, LIGUE "+cTelCob,oFont1,100)
	endif    
	
Else
	oPrn:Say(_nL+790,0150," ASS.: " + Replicate(". ",90) + Space(04) + "DATA: " + Replicate(". ",05) + "/" +;
	Replicate(". ", 05,) + "/" + Replicate(". ", 10),oFont1,100)
Endif

oprn:say(_nL+880,_nCol+0120,"Pagador:",oFont1,100)	
oprn:say(_nL+900,_nCol+0250,SA1->A1_NOME,oFont8,100)

If !Empty(SA1->A1_CEPC)
	oprn:say(_nL+940,_nCol+0250,SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,100)
	oprn:say(_nL+980,_nCol+0250,"CEP " + SA1->A1_CEPC +" "+ SA1->A1_MUNC +" "+ SA1->A1_ESTC, oFont8,100)
Else
	oprn:say(_nL+940,_nCol+0250,SA1->A1_END+" "+SA1->A1_BAIRRO,oFont8,100)
	oprn:say(_nL+980,_nCol+0250,"CEP " + SA1->A1_CEP +" "+ SA1->A1_MUN+" "+SA1->A1_EST,oFont8,100)
Endif

If SA1->A1_PESSOA == "J"
	oprn:say(_nL+900,_nCol+1500,Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,100)
ElseIf SA1->A1_PESSOA == "F"
	oprn:say(_nL+900,_nCol+1500,Transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,100)
Endif
                                                                           
oprn:say(_nL+1020,_nCol+0120,"Sacador / Avalista",oFont1,100)
oprn:say(_nL+1020,_nCol+0390,fSacAva(aDadosBanco[01]),oFont1,100)
oprn:say(_nL+1020,_nCol+1520+_nVaria,"Código de Baixa:",oFont1,100)
oprn:say(_nL+1060,_nCol+1400+_nVaria,"Autenticação Mecânica",oFont1,100)

Do Case
	Case _nVia == 1
		oprn:say(_nL+50,_nCol+0010,Replicate("- ",900),oFont1,100)
		oprn:say(_nL+1060,_nCol+2200+_nVaria,"Ficha de Compensação",oFont4,,,, 1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a Linha Digitavel  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Say(_nL+100,_nCol+2200+_nVaria, M->LinhaDig ,oFont9,,,, 1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o Codigo de Barras ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		MSBAR3("INT25", _nLBarra + 3.5, 0.5 ,M->CodBarras ,oPrn,.F.,NIL,NIL,0.025,1.5,NIL,NIL,"A",.F.)
		
	Case _nVia == 2
		oprn:say(_nL+50,0010,replicate("- ",900),oFont1,100)
		oPrn:Say(_nL+100,_nCol+2200+_nVaria,"Recibo do Pagador",oFont4,,,,PAD_RIGHT)
		
	Case _nVia == 3
		oprn:say(_nL+1060,_nCol+2200+_nVaria,"Controle do Beneficiário",oFont4,,,,PAD_RIGHT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a Linha Digitavel  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oPrn:Say(_nL+100,_nCol+2200+_nVaria, M->LinhaDig ,oFont9,,,, 1)
EndCase
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo de Barras - Calculo do Codigo de Barras do Boleto             ³
//³ - Retorno: Caracter, 44                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fCodigoBarras(cBanco)
Local _cBarra   := ""
Local _cResult  := ""
Local cNroBanco := "" 
Local cBarDV    := ""   
Private cBco    := cBanco

M->FatorVcto := StrZero( SE1->E1_VENCREA - Ctod("07/10/1997"), 04)
M->FatVtoSic := StrZero( SE1->E1_VENCREA - Ctod("03/07/2000") + 1000, 04)

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "004"
		_cBarra := "004"  + "9" + M->FatorVcto
		_cBarra += StrZero(nValLiq*100,10)
		_cBarra += aDadosBanco[03] + AllTrim(StrZero(Val(aDadosBanco[09]),8)) + Trim(M->NumBoleta) + Trim(dvBol) + aDadosBanco[8] + "000"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBanco == "001"
		lConv7 := .F.
		lConv7 := Len(aDadosBanco[09]) == 7
		If lConv7
			_cBarra := "001"  + "9" + M->FatorVcto
			_cBarra += StrZero(nValLiq*100,10)
			_cBarra += "000000" + Trim(M->NumBoleta) + SubStr(aDadosBanco[08],01,02)
		Else
			_cBarra := "001"  + "9" + M->FatorVcto
			_cBarra += StrZero(nValLiq*100,10)
			_cBarra += Trim(M->NumBoleta) + aDadosBanco[03] + aDadosBanco[05] + SubStr(aDadosBanco[08],01,02)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "033"
		cTpMod := "101"
		_cBarra := "033"  + "9" + M->FatorVcto
		_cBarra += StrZero(nValLiq*100,10) + "9"
		_cBarra += aDadosBanco[09] + Trim(M->NumBoleta) + Trim(dvBol) + "0" + cTpMod
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "104"
		lSIGCB := Len(aDadosBanco[09]) == 7 
		
		if lSIGCB   
		  
		    cBarDV += aDadosBanco[09] + SuBStr(M->NumBoleta, 03, 03) + SuBStr(M->NumBoleta, 01, 01) + SuBStr(M->NumBoleta, 06, 03)
			cBarDV += SuBStr(M->NumBoleta, 02, 01) + SuBStr(M->NumBoleta, 09, 09) 
		
		
			_cBarra := "104"  + "9" + M->FatorVcto
			_cBarra += StrZero(nValLiq*100,10)
			_cBarra += aDadosBanco[09] + SuBStr(M->NumBoleta, 03, 03) + SuBStr(M->NumBoleta, 01, 01) + SuBStr(M->NumBoleta, 06, 03)
			_cBarra += SuBStr(M->NumBoleta, 02, 01) + SuBStr(M->NumBoleta, 09, 09) 
			_cBarra += fDvCpoLv(cBarDV)
							
		Else
			_cBarra := "104"  + "9" + M->FatorVcto
			_cBarra += StrZero(nValLiq*100,10)
			_cBarra += Trim(M->NumBoleta) + aDadosBanco[03] + SubStr(aDadosBanco[09],01,11)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "224"
		cAgeCor := ""
		cAgeCor := SubStr(aDadosBanco[11], 01, 04)
		cCtaCor := ""
		cCtaCor := SubStr(aDadosBanco[12], 01, 05) + SubStr(aDadosBanco[12], 07, 01)
		
		_cBarra := "341"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += aDadosBanco[08] + Trim(M->Numboleta) + Trim(dvBol) + cAgeCor + cCtaCor + "000"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "237"
		_cBarra := "237"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += aDadosBanco[03] + StrZero(Val(aDadosBanco[08]),2) + M->Numboleta + aDadosBanco[05] + "0"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "246"
		cAgeCor := ""
		cAgeCor := SubStr(aDadosBanco[11], 01, 04)
		cCtaCor := ""
		cCtaCor := StrZero(Val(SubStr(aDadosBanco[12], 01, At("-",aDadosbanco[12])-1)),07)
		
		_cBarra := "237"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += cAgeCor + aDadosBanco[08] + Trim(M->Numboleta) + cCtaCor + "0"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cAgeCor := ""
		cAgeCor := SubStr(aDadosBanco[11], 01, 04)
		cCtaCor := ""
		cCtaCor := StrZero(Val(SubStr(aDadosBanco[12], 01, At("-",aDadosbanco[12])-1)),07)
		
		_cBarra := "237"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += cAgeCor + aDadosBanco[08] + Trim(aDadosBanco[09]) + Trim(M->Numboleta) + cCtaCor + "0"
		
		//ÚÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Itaú³
		//ÀÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "341"
		_cBarra := "341"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += aDadosBanco[08] + Trim(M->Numboleta) + Trim(dvBol) + aDadosBanco[03] + aDadosBanco[05] +;
		Mod10Itau(aDadosBanco[03] + aDadosBanco[05]) + "000"
		                          
	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case cBanco == "399"
		_cBarra := "399"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += Trim(M->Numboleta) + Trim(dvBol) + aDadosBanco[03] + aDadosBanco[05] + "00" + "1"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "422" 
		_cBarra := "422"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += "7" + aDadosBanco[03] + aDadosBanco[04] + aDadosBanco[05] + aDadosBanco[06] +;
		Trim(M->Numboleta) + "2"
		                                         
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "623"
		cAgeCor := ""
		cAgeCor := SubStr(aDadosBanco[11], 01, 04)
		cCtaCor := ""
		cCtaCor := StrZero(Val(SubStr(aDadosBanco[12], 01, At("-",aDadosbanco[12])-1)),07)
		
		_cBarra := "237"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += cAgeCor + aDadosBanco[08] + Trim(M->Numboleta) + cCtaCor + "0"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄè
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄè
		
	Case cBanco == "655"
		_cBarra := "001"  + "9" + M->FatorVcto
		_cBarra += StrZero(nValLiq*100,10)
		_cBarra += "000000" + Trim(M->NumBoleta) + SubStr(aDadosBanco[08],01,02)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"      
		cAgeCor := ""
		cAgeCor := SubStr(aDadosBanco[11], 01, 04)
		cCtaCor := ""
		cCtaCor := SubStr(aDadosBanco[12], 01, 05) + SubStr(aDadosBanco[12], 07, 01)
		
		
		_cBarra := "341"  + "9" + M->FatorVcto
		_cBarra += StrZero(SE1->E1_SALDO*100,10)
		_cBarra += aDadosBanco[08] + Trim(M->Numboleta) + Trim(dvBol) + cAgeCor + cCtaCor + "000"
		
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "745"
		_cBarra := "745" + "9" + M->FatorVcto
		_cBarra += StrZero(nValLiq*100,10)
		_cBarra += "3" + aDadosBanco[08] + SubStr(aDadosBanco[10],2,9) + M->Numboleta + dvBol
		
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "748"
		    
		    cBarDV += "3" + aDadosBanco[08] + SuBStr(M->NumBoleta, 01, 08) + dvBol + AllTrim(ADadosBanco[03]) + left(ADadosBanco[09],2)
			cBarDV += right(ADadosBanco[09],5) + "1" + "0"
		
		
			_cBarra := "748"  + "9" + M->FatorVcto
			_cBarra += StrZero(nValLiq*100,10)
			_cBarra += "3" + aDadosBanco[08] + SuBStr(M->NumBoleta, 01, 08) + dvBol + AllTrim(ADadosBanco[03]) + left(ADadosBanco[09],2)
			_cBarra += right(ADadosBanco[09],5) + "1" + "0" 
			_cBarra += fDvCpoLv(cBarDV)
			
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicoob³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "756"
		    
		    			    	
		    	_cBarra := "756"  + "9" + M->FatVtoSic
			    _cBarra += StrZero(nValLiq*100,10)
		    	_cBarra += aDadosBanco[08] + AllTrim(ADadosBanco[03]) + "01" + "0" + aDadosBanco[09] + SuBStr(M->NumBoleta, 01, 07) + dvBol
		    	
		    if  Empty (SE1->E1_PARCELA) 
		       _cBarra += "001"
		    
		    else
		    	_cBarra += SE1->E1_PARCELA
		    endif
		    	
		    	
		    	
		     			 			
		 
EndCase

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Insere Dígito Verificador no Código de Barras
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

_cResult := Substr(_cBarra,1,4)+;
BarraDV(_cBarra)+;
Substr(_cBarra,5,100)

Return(_cResult)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cálculo do dígito verificador do campo livre                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fDvCpoLv(cBarDV)

Local cRet  	:= ""   
Local Resto 	:= ""
Local nCont 	:= 0
Local nPeso 	:= 2
local i     	:= 0   
local nCalc1    := 0
local nCalc2    := 0
local nCalc3    := 0
    
Do case    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caixa Economica federal³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	Case cBanco == "104"
	
		For i := len(cBarDV) to 1 step -1
		nCont += Val(SubStr(cBarDV, i, 01)) * nPeso
		nPeso++
		if nPeso > 9
			nPeso := 2
		EndIf
	Next i
 
	if nCont < 11
		cRet   := AllTrim(Str(11 - nCont))
	Else
		Resto  := nCont % 11
		cRet   := AllTrim(Str(11 - Resto))

	  if (11 - Resto) > 9
			cRet := "0"
		EndIf
	Endif                    
	
	                   
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Sicredi          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	
	Case cBanco == "748"	
	    For i := len(cBarDV) to 1 step -1
		nCont += Val(SubStr(cBarDV, i, 01)) * nPeso
		nPeso++
		if nPeso > 9
			nPeso := 2
		EndIf
	Next i         
	
	nCalc1  := nCont/11
    nCalc2  := int(nCalc1) * 11
    nCalc3  := nCont - nCalc2
    nCalc4  := 11 - nCalc3

    Iif(nCalc3 <= 1, cRet := "0", cRet := alltrim(Str(nCalc4)))
	

	
EndCase 	

Return cRet
                          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Codigo de Barras - Calculo do Digito Verificador geral               ³
//³ - Retorno: Caracter,1 -> Digito Verificador calculado                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function BarraDV(_cBarCampo)

Local i     := 0
Local nCont := 0
Local cPeso := 0
Local Resto := 0
Local Result := 0
Local DV_BAR := Space(1)
Local lConv7 := .F.  

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBco == "004"
		nCont := 0
		cPeso := 2
		For i := 43 To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Resto == 10 .or. Resto == 0 .or. Resto == 1
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "001"
		cFator := "4329876543298765432987654329876543298765432"
		nVal1  := 0
		nResult:= 0
		For I:=1 to Len(_cBarCampo)
			nResult := Val(Substr(_cBarCampo,I,1)) * Val(Substr(cFator,I,1))
			nVal1   += nResult
		Next
		
		nResto := nVal1 % 11
		nResto := 11 - nResto
		If nResto == 10
			nDig := 1
		ElseIf nResto == 11
			nDig := 1
		Else
			nDig := nResto
		EndIf
		DV_BAR := AllTrim(Str(nDig))
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "033"
		
		nCont := 0
		cPeso := 2
		
		For i := 43 To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		
		nCont := nCont * 10
		Resto  := nCont % 11
		Result := Resto
		
		if (Resto == 0 .or. Resto == 1 .or. Resto == 10)
			DV_BAR := "1"
		Else
			DV_BAR := AlLTrim(Str(Result))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "104"
		nCont := 0
		nPeso := 2
		
		For i := len(_cBarCampo) to 1 step -1
			nCont += Val(SubStr(_cBarCampo, i, 01)) * nPeso
			nPeso++
			if nPeso > 9
				nPeso := 2
			EndIf
		Next i
		
		Resto  := nCont % 11
		DV_BAR := AllTrim(Str(11 - Resto))
		
		if (11 - Resto) == 0 .or. (11 - Resto) > 9
			DV_BAR := "1"
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "224"
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := len(_cBarCampo) To 1 Step -1
			nCont += Val( SubStr( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "237"
		i      := 0
		nCont  := 0
		Resto  := 0
		Result := 0
		cPeso  := 2
		For i := Len(_cBarCampo) To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "246"
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := len(_cBarCampo) To 1 Step -1
			nCont += Val(SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "320"
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := len(_cBarCampo) To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1)) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next i
		
		Resto  := nCont % 11
		Result := 11 - Resto
		
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case cBco == "341"
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := len(_cBarCampo) To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		                    
	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ

	Case cBco == "399"
		i      := 0
		nResto := 0
		nCont  := 0
		nPeso  := 2
		
		for i := Len(_cBarCampo) to 1 Step -1
			nCont += Val(SubStr(_cBarCampo, i, 1)) * nPeso
			nPeso++
			If nPeso == 10
				nPeso := 2
			EndIf
		Next i
		
		nResto := nCont % 11
		
		Do Case
			Case nResto == 0 .or. nResto == 1 .or. nResto == 10
				DV_BAR := "1"
			OtherWise
				DV_BAR := AllTrim(Str(11 - nResto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "422"
		i      := 0
		nResto := 0
		nCont  := 0
		nPeso  := 2
		
		for i := Len(_cBarCampo) to 1 Step -1
			nCont += Val(SubStr(_cBarCampo, i, 1)) * nPeso
			nPeso++
			If nPeso == 10
				nPeso := 2
			EndIf
		Next i
		
		nResto := nCont % 11
		
		Do Case
			Case nResto == 0 .or. nResto == 1 .or. nResto == 10
				DV_BAR := "1"
			OtherWise
				DV_BAR := AllTrim(Str(11 - nResto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "623"
		i      := 0
		nCont  := 0
		Resto  := 0
		Result := 0
		cPeso  := 2
		For i := Len(_cBarCampo) To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD
		
	Case cBco == "655"
		cFator := "4329876543298765432987654329876543298765432"
		nVal1  := 0
		nResult:= 0
		For I:=1 to Len(_cBarCampo)
			nResult := Val(Substr(_cBarCampo,I,1)) * Val(Substr(cFator,I,1))
			nVal1   += nResult
		Next
		
		nResto := nVal1 % 11
		nResto := 11 - nResto
		
		If nResto == 0
			nDig := 1
		ElseIf nResto == 10
			nDig := 1
		ElseIf nResto == 11
			nDig := 1
		Else
			nDig := nResto
		EndIf
		DV_BAR := AllTrim(Str(nDig))
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "707"   
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := len(_cBarCampo) To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Result == 10 .or. Result == 11
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "745"
		i      := 0
		Resto  := 0
		Result := 0
		nCont  := 0
		cPeso  := 2
		
		For i := 43 To 1 Step -1
			nCont += Val( SUBSTR( _cBarCampo,i,1 )) * cPeso
			cPeso++
			If cPeso >  9
				cPeso := 2
			Endif
		Next i
		
		Resto  := nCont % 11
		Result := 11 - Resto
		Do Case
			Case Resto == 0 .or. Resto == 1
				DV_BAR := "1"
			OtherWise
				DV_BAR := Str(Result,1)
		EndCase
		
	    
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Sicredi          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	 
	Case cBco == "748"
		nCont := 0
		nPeso := 2  
		nCalc1 := 0
		nCalc2 := 0
		
		
		For i := len(_cBarCampo) to 1 step -1
			nCont += Val(SubStr(_cBarCampo, i, 01)) * nPeso
			nPeso++
			if nPeso > 9
				nPeso := 2
			EndIf
		Next i
		       
		
		nCalc1 := mod(nCont,11)
        nCalc2 := 11 - nCalc1
                         
    	Iif(((nCalc2 < 2) .OR. (nCalc2 > 9)),DV_BAR := "1", DV_BAR := alltrim(str(nCalc2)))
    	
    	
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³       Sicoob          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
	 
	Case cBco == "756"
		nCont := 0
		nPeso := 2  
		nCalc1 := 0
		nCalc2 := 0
		
		
		For i := len(_cBarCampo) to 1 step -1
			nCont += Val(SubStr(_cBarCampo, i, 01)) * nPeso
			nPeso++
			if nPeso > 9
				nPeso := 2
			EndIf
		Next i
		       
		
		nCalc1 := mod(nCont,11)
        nCalc2 := 11 - nCalc1
                         
    	Iif(((nCalc2 < 2) .OR. (nCalc2 > 9)),DV_BAR := "1", DV_BAR := alltrim(str(nCalc2)))
	
	
EndCase

Return(DV_BAR)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Linha Digitavel - Calculo do Codigo da Linha Digitavel               ³
//³ - Basea-se no campo Codigo de Barras, que ja deve estar calculdo     ³
//³ - Retorno: Caracter, ??                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fLinhaDigitavel(cBanco)
Local nDigito  := ""
Local Pedaco   := ""
Local _cResult := ""
Private cBco   := cBanco

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Primeiro Campo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pedaco := Substr(M->CodBarras,01,03) + Substr(M->CodBarras,04,01) + Substr(M->CodBarras,20,3) + Substr(M->CodBarras,23,2)
nDigito := LinhaDV(Pedaco)
M->LineDig := Substr(M->CodBarras,1,3)+Substr(M->CodBarras,4,1)+Substr(M->CodBarras,20,1)+"."+;
Substr(M->CodBarras,21,2) + Substr(M->CodBarras,23,2) + nDigito + Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Segundo Campo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pedaco  := Substr(M->CodBarras,25,10)
nDigito:=LinhaDV(Pedaco)
M->LineDig := M->LineDig+Substr(Pedaco,1,5)+"."+Substr(Pedaco,6,5)+;
nDigito+Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Terceiro Campo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pedaco  := Substr(M->CodBarras,35,10)
nDigito := LinhaDV(Pedaco)
M->LineDig := M->LineDig + Substr(Pedaco,1,5)+"."+Substr(Pedaco,6,5)+;
nDigito+Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quarto Campo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

M->LineDig := M->LineDig + Substr(M->CodBarras,5,1) + Space(2)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quinto Campo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÙ

M->LineDig  := M->LineDig + M->FatorVcto + StrZero(nValLiq*100,10)

_cResult := M->LineDig

Return(_cResult)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄf¿
//³Calculo do Digito da Linha Digitavel³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄfÙ

Static Function LinhaDV(_cCampo)
Local _cResult := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBco == "004"
		nCont  := 0
		nVal   := 0
		Resto  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso > 9
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += nVal - 9
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Resto  := nCont % 10
		
		If Resto  == 0
			_cResult := "0"
		Else
			_cResult := AllTrim(Str(10 - Resto))
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBco == "001"
		cLinha  := _cCampo
		nAux    := Len(cLinha) % 2
		nFator  := 0
		nDig    := 0
		nGeral  := 0
		nResult := 0
		
		If nAux == 0
			nFator  := 1
		Else
			nFator  := 2
		EndIf
		
		For I := 1 to Len(cLinha)
			nResult := nFator * Val(Substr(cLinha,I,1))
			If nResult > 09
				nResult := Val(Substr(Alltrim(Str(Int(nResult))),1,1))+Val(Substr(Alltrim(Str(Int(nResult))),2,1))
			EndIf
			nGeral += nResult
			If nFator == 1
				nFator := 2
			Else
				nFator := 1
			EndIf
		Next
		
		If nGeral < 11
			nDig := 10 - nGeral
		ElseIf nGeral > 90
			nDig := 100 - nGeral
		Else
			nAux := Val(Substr(Alltrim(Str(nGeral)),1,1)) + 1
			nDig := Val(Alltrim(Str(nAux)+"0")) - nGeral
		EndIf
		nDig     := If(nDig == 10 , 0 , nDig)
		_cResult := AllTrim(Str(nDig))
		
		//ÚÄÄÄÄÄÄÄÄ
		//³Satander
		//ÀÄÄÄÄÄÄÄÄ
		
	Case cBco == "033"
		nCont   := 0
		nVal    := 0
		Peso    := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso > 9
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * Peso
			Endif
			
			Peso++
		Next
		
		if (nCont % 10) == 0
			_cResult := "0"
		else
			_cResult := AllTrim(Str(10 - (nCont % 10)))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "104"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "224"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "237"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "246"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "320"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next i
		
		Dezena := Substr(Str(nCont,2),1,1)
		Resto  := ((Val(Dezena)+1) * 10) - nCont
		
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case cBco == "341"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next i
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		                    
	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case cBco == "399"
	  i      := 0
	  nCont  := 0
	  nPeso  := 2
	  nTmp   := 0
	  nResto := 0
	  
	  For i := Len(_cCampo) to 1 step -1
	  	nTmp  := Val(SubStr(_cCampo, i, 1)) * nPeso
	  	nCont += iif(nTmp > 9, Val(SubStr(AllTrim(Str(nTmp)),1,1)) + Val(SubStr(AllTrim(Str(nTmp)),2,1)),nTmp)
	  	
      nPeso--
      
      If nPeso == 0
      	nPeso := 2
      EndIf
	  	
	  Next i
		
		nResto := nCont % 10
		
		Do Case
			Case nCont < 10
				_cResult := AllTrim(Str(10 - nCont))
			Case nResto == 0
				_cResult := "0"
			OtherWise
				_cResult := AllTrim(Str(10 - nResto))
		EndCase
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "422"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := AllTrim(Str(Resto))
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "623"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBco == "655"
		cLinha  := _cCampo
		nAux    := Len(cLinha) % 2
		nFator  := 0
		nDig    := 0
		nGeral  := 0
		nResult := 0
		nResto  := 0
		
		If nAux == 0
			nFator  := 1
		Else
			nFator  := 2
		EndIf
		
		For I := 1 to Len(cLinha)
			nResult := nFator * Val(Substr(cLinha,I,1))
			If nResult > 09
				nResult := Val(Substr(Alltrim(Str(Int(nResult))),1,1))+Val(Substr(Alltrim(Str(Int(nResult))),2,1))
			EndIf
			nGeral += nResult
			If nFator == 1
				nFator := 2
			Else
				nFator := 1
			EndIf
		Next
		
		nResto := nGeral % 10
		
		if nResto != 0
			nAux := Val(Substr(Alltrim(StrZero(nGeral,2)),1,1)) + 1
			nDig := Val(Alltrim(Str(nAux)+"0")) - nGeral
		Else
			nDig := nResto
		EndIf
		_cResult := AllTrim(Str(nDig))
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "707"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next i
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBco == "745"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
				Peso := 1
			Endif
			
			If Val(SubStr(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SubStr(_cCampo,i,1)) * Peso
				nCont += Val(SubStr(Str(nVal,2),1,1)) + Val(SubStr(Str(nVal,2),2,1))
			Else
				nCont += Val(SubStr(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next
		
		Dezena  := Substr(Str(nCont,2),1,1)
		Resto   := ((Val(Dezena)+1) * 10) - nCont
		If Resto  == 10
			_cResult := "0"
		Else
			_cResult := Str(Resto,1)
		Endif     
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      Sicredi          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
	Case cBco == "748"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2 
		multi  := 0    
		nResult := 0
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
			   Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next

		Dezena   := Substr(Str(nCont,2),1,1)
		cmulti   := ((Val(Dezena)+1) * 10)
		nResult  := cmulti - nCont
		If  nResult >= 10
			_cResult := "0"
		Else
		  	_cResult := Str(nResult,1)
		Endif
		
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      Sicoob          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
	Case cBco == "756"
		nVal   := 0
		Dezena := 0
		Resto  := 0
		nCont  := 0
		Peso   := 2 
		multi  := 0    
		nResult := 0
		
		For i := Len(_cCampo) to 1 Step -1
			
			If Peso == 3
			   Peso := 1
			Endif
			
			If Val(SUBSTR(_cCampo,i,1)) * Peso >= 10
				nVal  := Val(SUBSTR(_cCampo,i,1)) * Peso
				nCont += Val(SUBSTR(Str(nVal,2),1,1)) + Val(SUBSTR(Str(nVal,2),2,1))
			Else
				nCont += Val(SUBSTR(_cCampo,i,1)) * M->Peso
			Endif
			
			Peso++
		Next

		Dezena   := Substr(Str(nCont,2),1,1)
		cmulti   := ((Val(Dezena)+1) * 10)
		nResult  := cmulti - nCont
		If  nResult >= 10
			_cResult := "0"
		Else
		  	_cResult := Str(nResult,1)
		Endif
		
EndCase

Return(_cResult)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cadastra as Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function ValidPerg(cPerg)

Private _sAlias := Alias()
Private aRegs   := {}
Private i,j

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05

aAdd(aRegs,{cPerg,"01","Do Prefixo           ","","","mv_ch1","C",TAMSX3("E1_PREFIXO")[1],00,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Ate Prefixo          ","","","mv_ch2","C",TAMSX3("E1_PREFIXO")[1],00,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Do Titulo            ","","","mv_ch3","C",TAMSX3("E1_NUM")[1],00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","018"})
aAdd(aRegs,{cPerg,"04","Ate Titulo           ","","","mv_ch4","C",TAMSX3("E1_NUM")[1],00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","018"})
aAdd(aRegs,{cPerg,"05","Da Parcela           ","","","mv_ch5","C",TAMSX3("E1_PARCELA")[1],00,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","","011"})
aAdd(aRegs,{cPerg,"06","Ate Parcela          ","","","mv_ch6","C",TAMSX3("E1_PARCELA")[1],00,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","","","011"})
aAdd(aRegs,{cPerg,"07","Do Cliente           ","","","mv_ch9","C",TAMSX3("E1_CLIENTE")[1],00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","","001"})
aAdd(aRegs,{cPerg,"08","Ate Cliente          ","","","mv_cha","C",TAMSX3("E1_CLIENTE")[1],00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","","","001"})
aAdd(aRegs,{cPerg,"09","Da Loja              ","","","mv_chb","C",TAMSX3("E1_LOJA")[1],00,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","","","","002"})
aAdd(aRegs,{cPerg,"10","Ate Loja             ","","","mv_chc","C",TAMSX3("E1_LOJA")[1],00,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","","","","002"})
aAdd(aRegs,{cPerg,"11","Do Vencimento        ","","","mv_chd","D",08,00,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"12","Ate Vencimento       ","","","mv_che","D",08,00,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"13","Da Emissao           ","","","mv_chf","D",08,00,0,"G","","mv_par13","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"14","Ate Emissao          ","","","mv_chg","D",08,00,0,"G","","mv_par14","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"15","Reimpressao ?        ","","","mv_chh","N",01,00,0,"C","","mv_par15","Sim","","","","","Nao","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"16","Banco                ","","","mv_chi","C",TAMSX3("A6_COD")[1],00,0,"G","",    "mv_par16","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","007"})
aAdd(aRegs,{cPerg,"17","Agencia              ","","","mv_chj","C",TAMSX3("A6_AGENCIA")[1],00,0,"G","","mv_par17","","","","","","","","","","","","","","","","","","","","","","","","","","","008"})
aAdd(aRegs,{cPerg,"18","Conta                ","","","mv_chl","C",TAMSX3("A6_NUMCON")[1],00,0,"G","", "mv_par18","","","","","","","","","","","","","","","","","","","","","","","","","","","009"})
aAdd(aRegs,{cPerg,"19","Sub Conta            ","","","mv_chm","C",TAMSX3("EE_SUBCTA")[1],00,0,"G","", "mv_par19","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"20","Seleciona titulos ?  ","","","mv_chq","N",01,00,0,"C","","mv_par20","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","",""})


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
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará o cálculo do Seq. do N.Nro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fSeqNNro(cSeqBco)
Local cSeqNNro := ""
Local lConv7   := .F.

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	Case aDadosBanco[01] == "004"
		cSeqNNro := StrZero(Val(cSeqBco)+1,7,0)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄd
		
	Case aDadosBanco[01] == "001"
		lConv7 := Len(aDadosBanco[09]) == 7
		if lConv7
			cSeqNNro := StrZero(Val(cSeqBco)+1,10)
		Else
			cSeqNNro := StrZero(Val(cSeqBco)+1,5)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		cSeqNNro := StrZero(Val(cSeqBco)+1,12)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104"
		cSeqNNro := StrZero(Val(cSeqBco)+1,12)
		//cSeqNNro := StrZero(Val(cSeqBco)+1,09)   até 30/04/2015
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		cSeqNNro := StrZero(Val(cSeqBco)+1,08)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		cSeqNNro := StrZero(Val(cSeqBco)+1,11)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		cSeqNNro := StrZero(Val(cSeqBco)+1,11)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		cSeqNNro := StrZero(Val(cSeqBco)+1, 06)
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cSeqNNro := StrZero(Val(cSeqBco)+1,8)
		                     
		
	Case aDadosBanco[01] == "399"
		cSeqNNro := StrZero(Val(cSeqBco)+1,10)
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422"
		cSeqNNro := StrZero(Val(cSeqBco)+1,9)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		cSeqNNro := StrZero(Val(cSeqBco)+1,11)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		
	Case aDadosBanco[01] == "655"
		cSeqNNro := StrZero(Val(cSeqBco)+1,10)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		cSeqNNro := StrZero(Val(cSeqBco)+1,8)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		cSeqNNro := StrZero(Val(cSeqBco)+1,11)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      Sicredi          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "748"
		cSeqNNro := StrZero(Val(cSeqBco)+1,05)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³      Sicoob          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "756"
		cSeqNNro :=  StrZero(Val(cSeqBco)+1,07)
		
		
EndCase

DbSelectArea("SEE")
RecLock("SEE", .F.)
SEE->EE_FAXATU := cSeqNNro
SEE->(MsUnlock())

Return cSeqNNro

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará o cálculo do Dígito Verificador do Nosso Nùmero³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fCalcDvNN(cNumBco)
Local cDv       := Space(1)
Local i         := 0
Local nCont     := 0
Local cPeso     := 0
Local Resto     := 0   
local nCalc1    := 0
local nCalc2    := 0
local nCalc3    := 0
Local lConv7    := .F.

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Banco do Nordeste
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	Case aDadosBanco[01] == "004"
		
		nCont   := 0
		cPeso   := 2
		nBoleta := cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SUBSTR(nBoleta,i,1)) * cPeso)
			cPeso := cPeso + 1
			If cPeso > 8
				cPeso := 2
			Endif
		Next
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1 .or. Resto == 0
				cDv   := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv   := AllTrim(Str(Resto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case aDadosBanco[01] == "001"
		cFator  := ""
		nResto  := 0
		nResult := 0
		nVal1   := 0
		
		lConv7 := Len(aDadosBanco[09]) == 7
		
		if lConv7
			cDv := ""
		Else
			cFator := "78923456789"
			nVal1  := 0
			For i := 1 to Len(cNumBco)
				nResult := Val(Substr(cNumBco,I,1)) * Val(Substr(cFator,I,1))
				nVal1   += nResult
			Next
			
			nResto := nVal1 % 11
			If nResto < 10
				cDv := Alltrim(Str(nResto))
			ElseIf nResto == 10
				cDv := "X"
			ElseIf nResto == 0
				cDv := "0"
			EndIf
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		i       := 0
		Resto   := 0
		nCont   := 0
		nPeso   := 2
		nBoleta := AllTrim(cNumBco)
		
		For i := len(nBoleta) To 1 step -1
			if nPeso > 9
				nPeso := 2
			EndIf
			nCont := nCont + Val(SUBSTR(nBoleta,i,1)) * nPeso
			nPeso++
		Next
		
		Resto := (nCont % 11)
		
		if (nCont % 11 == 10)
			cDv := "1"
		elseif (nCont % 11 == 0) .or. (nCont % 11 == 1)
			cDv := "0"
		else
			cDv := AllTrim(Str(11 - Resto))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104"
		nCont   := 0
		i       := 0
		nFator  := 2
		Resto   := 0
		nBoleta := Trim(cNumBco)
		
		For i := len(nBoleta) to 1 step -1
			nCont += Val(SubStr(nBoleta,i,01)) * nFator
			nFator++
			if nFator > 9
				nFator := 2
			EndIf
		Next i
		
		Resto := nCont % 11
		Resto := 11 - Resto
		
		if Resto > 9
			Resto := 0
			cDv := "0"
		Else
			cDv := AllTrim(Str(Resto))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		nCont   := 0
		cPeso   := 2
		nTmp    := 0
		nBoleta := aDadosBanco[11] + SubStr(aDadosBanco[12],01,05) +;
		aDadosBanco[08] + cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nTmp := (Val(SubStr(nBoleta,i,1))) * cPeso
			nCont += iif(nTmp <= 9, nTmp, Val(SubStr(AllTrim(Str(nTmp)),1,1)) + Val(SubStr(AllTrim(Str(nTmp)),2,1)))
			cPeso--
			
			If cPeso == 0
				cPeso := 2
			Endif
		Next
		
		Resto := nCont % 10
		
		if Resto == 0
			cDv := "0"
		Else
			cDv := AllTrim(Str(10 - Resto))
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		nCont   := 0
		cPeso   := 2
		nBoleta := aDadosBanco[08] + cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 8
				cPeso := 2
			Endif
			
		Next i
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1
				cDv := "P"
			Case Resto == 0
				cDv := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv := AllTrim(Str(Resto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		nCont   := 0
		cPeso   := 2
		nBoleta := ADadosBanco[08] + cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 8
				cPeso := 2
			Endif
		Next
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1
				cDv := "P"
			Case Resto == 0
				cDv := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv   := AllTrim(Str(Resto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		nCont   := 0
		cPeso   := 2
		nBoleta := aDadosBanco[03] + cNumBco
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 10
				cPeso := 0
			Endif
		Next
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 0
				cDv := "1"
			Case Resto == 1
				cDv := "0"
			Case Resto == 10
				cDv := "1"
			OtherWise
				Resto   := ( 11 - Resto )
				cDv := AllTrim(Str(Resto))
		EndCase
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cData := aDadosBanco[03] + aDadosBanco[05] + aDadosBanco[08] + cNumBco
		cDv   := Mod10Itau(cData)

		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "399"
		i       := 0
		nResto  := 0
		nCont   := 0
		nPeso   := 2
		cBoleta := cNumBco
		
		for i := Len(cBoleta) to 1 Step -1
			nCont := nCont + Val(SubStr(cBoleta,i,1)) * nPeso
			nPeso++
			if nPeso == 8
				nPeso := 2
			EndIf
		Next i
		
		nResto := nCont % 11
		
		If nResto == 0 .or. nResto == 1
			cDv := "0"
		Else
			cDv := AllTrim(Str(11 - nResto))
		EndIf
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³  banco adotou numeração livre do nosso numero, com isso não necessita calculo DV
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ       
		
	/*Case aDadosBanco[01] == "422"
		i       := 0
		Resto   := 0
		nCont   := 0
		cPeso   := 2
		nBoleta := AllTrim(ADadosBanco[08]) + Right(Str(Year(SE1->E1_EMISSAO)),2) + cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 8
				cPeso := 2
			Endif
		Next
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1
				cDv := "P"
			Case Resto == 0
				cDv := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv   := AllTrim(Str(Resto))
		EndCase
		*/
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		nCont   := 0
		cPeso   := 2
		nBoleta := aDadosBanco[08] + cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 8
				cPeso := 2
			Endif
			
		Next i
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1
				cDv := "P"
			Case Resto == 0
				cDv := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv := AllTrim(Str(Resto))
		EndCase
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case aDadosBanco[01] == "655"
		cDv := ""
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"                  
	
		cData := SubStr(aDadosBanco[11] ,01, 04) + SubStr(aDadosBanco[12], 02, 04) + SubStr(aDadosBanco[12], 07, 01) + aDadosBanco[08] + cNumBco
		cDv   := Mod10Itau(cData)
		                                                                       
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		nCont   := 0
		cPeso   := 2
		nBoleta := cNumBco
		
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SUBSTR(nBoleta,i,1))) * cPeso
			cPeso += 1
			If cPeso == 10
				cPeso := 2
			Endif
		Next i
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 1
				cDv := "0"
			Case Resto == 0
				cDv := "0"
			OtherWise
				Resto := ( 11 - Resto )
				cDv   := AllTrim(Str(Resto))
		EndCase                            
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³        Sicredi         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "748"
		nCont   := 0
		i       := 0
		nFator  := 2
		Resto   := 0
		nBoleta := AllTrim(ADadosBanco[03]) + left(ADadosBanco[09],2) + right(ADadosBanco[09],5) + right(alltrim(str(year(dDatabase))),2) + "2" + right((cNumBco),5)
		
		For i := len(nBoleta) to 1 step -1
			nCont += Val(SubStr(nBoleta,i,01)) * nFator
			nFator++
			if nFator > 9
				nFator := 2
			EndIf
		Next i
		    	
    	nCalc1 := int(nCont / 11)     // 1o calculo
	    nCalc2 := nCalc1 * 11         // 3o calculo
   		nCalc3 := nCont - nCalc2      // 4o calculo

    	iif((11 - nCalc3) >= 10, cDv := "0", cDv := alltrim(Str((11 - nCalc3))))
    	
    	
    		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³        Sicoob         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "756"
		cFator  := ""
		nResto  := 0
		nResult := 0
		nVal1   := 0
		nBoleta :=  "0756" + "0000" + SubStr(aDadosBanco[09] ,01, 06) + AllTrim(cNumBco)
		
		
		
			cFator := "319731973197319731973"
			For i := 1 to Len(nBoleta)
				nResult := Val(Substr(nBoleta,I,1)) * Val(Substr(cFator,I,1))
				nVal1   += nResult
			Next
			
			nResto := nVal1 % 11
			If nResto < 10
				cDv := Alltrim(Str(nResto))
			ElseIf nResto == 0 .or. nResto == 1
				cDv := "0"
			EndIf
	

EndCase

Return cDv

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que pega o sequencial do Nosso Número que está gravado no título.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fMontaSeq(cNNro)
Local cSeq   := ""
Local lConv7 := .F.

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "004"
		cSeq := StrZero(Val(SubStr(AllTrim(cNNro),1,7)),7)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case aDadosBanco[01] == "001"
		lConv7 := Len(aDadosBanco[09]) == 7
		If lConv7
			cSeq := SubStr(Alltrim(cNNro),1,17)
		Else
			cSeq := SubStr(Alltrim(cNNro),1,11)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		cSeq := SubStr(AllTrim(cNNro),1,12)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104"
		cSeq := SubStr(AllTrim(cNNro),1,17)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		cSeq := StrZero(Val(SubStr(cNNro,01,08)),08)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		cSeq := StrZero(Val(SubStr(cNNro,01,11)),11)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		cSeq := StrZero(Val(SubStr(cNNro,01,11)),11)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		if SE1->E1_EMISSAO <= STOD("20121021")
			cSeq := StrZero(Val(SubStr(cNNro,06,06)),06)
		Else
			cSeq := StrZero(Val(SubStr(cNNro,01,06)),06)
		EndIf
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cSeq := StrZero(Val(SubStr(cNNro,01,08)),08)
		
		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
	
	Case aDadosBanco[01] == "399"
		cSeq := StrZero(Val(SubStr(cNNro, 01, 10)),10)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422"
		cSeq := StrZero(Val(SubStr(cNNro,01,09)),09) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		cSeq := StrZero(Val(SubStr(cNNro,01,11)),11)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4
		
	Case aDadosBanco[01] == "655"
		cSeq := SubStr(Alltrim(cNNro),1,17)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		cSeq := StrZero(Val(SubStr(cNNro,01,08)),08)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		cSeq := StrZero(Val(SubStr(cNNro,01,11)),11)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³       Sicredi         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "748"
		cSeq := StrZero(Val(SubStr(cNNro,01,09)),09)
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³       Sicoob         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "756"
		cSeq := StrZero(Val(SubStr(cNNro,01,07)),07)
EndCase

Return cSeq 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que valida se existe logo para o banco escolhido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fValImage(cBanco)
Local cImage := "/system/"+cBanco+".bmp"
Local lRet   := .F.

if File(cImage)
	lRet := .T.
EndIf

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna string com o local de pagamento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fRetLocPag(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "004"
		cRet := "APÓS O VENCIMENTO PAGUE SOMENTE NO BANCO DO NORDESTE."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "001"
		cRet := "Pagável em qualquer banco até o vencimento, após atualize o boleto no site bb.com.br."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "033"
		cRet := "PAGAR PREFERENCIALMENTE NO GRUPO SANTANDER - GC."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Caixa Econômica Federal
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBanco == "104"
		cRet := "PREFERENCIALMENTE NAS CASAS LOTÉRICAS ATÉ O VALOR LIMITE."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "224"
		cRet := "PAGÁVEL EM QUALQUER BANCO ATÉ A DATA DO VENCIMENTO."
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "237"
		cRet := "PAGÁVEL PREFERENCIALMENTE NA REDE BRADESCO OU NO BRADESCO EXPRESSO"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "246"
		cRet := "PAGAVEL PREFERENCIALMENTE NAS AGÊNCIAS BRADESCO."
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cRet := "ATÉ O VENCIMENTO, PAGÁVEL EM QUALQUER AGÊNCIA BANCÁRIA."
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "341"
		cRet := "ATÉ O VENCIMENTO, PREF. NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ." 
	
		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "399"
		cRet := "PAGAR PREFERENCIALMENTE EM AGÊNCIA DO HSBC."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "422"
		cRet := "PAGÁVEM EM QUALQUER BANCO ATÉ A DATA DE VENCIMENTO."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBanco == "623"
		cRet := "PAGÁVEL PREFERENCIALMENTE EM QUALQUER AGÊNCIA BRADESCO."
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		
	Case cBanco == "655"
		cRet := "PAGÁVEL EM QUALQUER BANCO ATÉ O VENCIMENTO."
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := "ATÉ O VENCIMENTO, PREF. NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ." 
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "745"
		cRet := "PAGÁVEL NA REDE BANCÁRIA ATÉ O VENCIMENTO."
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "748"
		cRet := "PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DE CRÉDITO DO SICREDI"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÄÄÄÄÙ
		
		Case cBanco == "756"
		cRet := "PAGÁVEL PREFERENCIALMENTE NAS COOPERATIVAS DA REDE OU QUALQUER OUTRO BANCO ATÉ O VENCIMENTO"
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o código do Beneficiário de acordo com o banco.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fRetCed(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Banco do Nordeste
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	Case cBanco == "004"
		cRet := Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99") +;
		"  " + Upper(AllTrim(SM0->M0_NOMECOM))
	
	  //ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ   
	 
	  Case  cBanco == "001" 
	  	if  (AllTrim(cAgencia)) == "3394" .AND. (AllTrim(cConta)) == '00454447'
	        cRet := 'BANCO INTERMEDIUM S/A'     
	   
	  	else  
	  		cRet := Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99") +;
		"  " + Upper(AllTrim(SM0->M0_NOMECOM))
	  	endif
    

		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ    
		
	Case cBanco == "033"
	   
	   cRet := AllTrim(SEE->EE_FORMEN1)  	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "104"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " " +;
		"CNPJ/CPF: " + Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "224"
		cRet := "BANCO FIBRA S/A"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
	 
	  Case  cBanco == "237"
		if (AllTrim(cConta)) == '0006237'
	        cRet := 'RED S.A – CNPJ 67.915.785/0001-01 – Av. Cidade Jardim 400 -14º and. São Paulo/SP'     
	   
	  	elseif (AllTrim(cConta)) == '0014046'
	        cRet := 'FIDC ARM - NP: 12.764.295/0001-51 Av Cândido de abreu, 660 centro cívico 80530-000 Curitiba - PR'   
	        
	    elseif (AllTrim(cConta)) == '0195660'
	        cRet := 'ATLANTA FIDC MULTISSETORIAL CNPJ: 11.468.186/0001-24'    

	    elseif (AllTrim(cConta)) == '0838500'
	        cRet := 'RNX FIDC MULTISSETORIAL LP  CNPJ: 12.813.212/0001-77'       
	    
	    //elseif (AllTrim(cConta)) $ '0003098/0006773/0000112'
		  //  cRet := AllTrim(SEE->EE_FORMEN1) 
		  
	    elseif (AllTrim(cConta)) $ '0000645/0000643/0000356'
		    cRet := AllTrim(SEE->EE_FORMEN1)
		   
		elseif (AllTrim(cConta)) == '0002364'
		  cRet := 'CREDITISE FIDC NP CNPJ: 28.702.814/0001-97' 
		                           
	    else  
	  		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) 
	  	endif
	  	    
		
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "246"
		cRet := "BANCO ABC BRASIL S/A"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cRet := "BCO INDL E COML S.A. (BIC BANCO) " +;
		"CNPJ: 07.450.604/0001-89"
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "341"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " " +;
		"CNPJ/CPF: " + Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")

		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "399"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " " +;
		"CNPJ: " + Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")	
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "422"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + "   " + Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		
	Case cBanco == "623"
		cRet := "BANCO PAN S/A"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD
		
	Case cBanco == "655"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM))
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " " +;
		"CNPJ: " + Transform(AllTrim(SM0->M0_CGC),"@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "745"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM))
		
		//ÚÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "748"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM))
		
	    //ÚÄÄÄÄ¿
		//ÀÄÄÄÄÙ
		
	Case cBanco == "756"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM))
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄA¿
//³Função que retorna informação para o campo Agência/Cod.Beneficiário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄAÙ

Static Function fAgeCodCed(aDadosBanco)
Local cRet := ""
Local cCodAge := ""
Local cCodCed := "" 
Local fCalDvBf := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Banco do Nordeste
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	Case aDadosBanco[01] == "004"
		cCodAge := aDadosBanco[03]
		cCodCed := aDadosBanco[05]+"-"+aDadosBanco[6]
		cRet := cCodAge + "  " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "001"
		cCodAge := aDadosBanco[03] + "-" + aDadosBanco[04]
		cCodCed := aDadosBanco[05] + "-" + aDadosBanco[06]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		cCodAge := aDadosBanco[03]
		cCodCed := aDadosBanco[09]
		cRet := cCodAge + "/" + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
	
  Case  aDadosBanco[01] == "104" 
      cCodAge := aDadosBanco[03]
      cCodCed := aDadosBanco[09] 
        
       If aDadosBanco[01] == "104" .and. Len(cCodCed) != 12  
          cRet := cCodAge + " / " + SubStr(cCodCed, 01, 06) + "-" + SubStr(cCodCed, 07, 01) 
       
       Else
          cRet := cCodAge + "." + SubStr(cCodCed, 01, 03) + "." + SubStr(cCodCed, 04, 08) + "-" +  SubStr(cCodCed, 12, 01)   
       Endif
               
      
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		cCodAge := aDadosBanco[11]
		cCodCed := aDadosBanco[12]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		cCodAge := aDadosBanco[03] + "-" +	aDadosBanco[04]
		cCodCed := aDadosBanco[05] + "-" +	aDadosBanco[06]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		cCodAge := SubStr(aDadosBanco[11], 01, 04) + "-" + SubStr(aDadosBanco[11], 05, 01)
		cCodCed := aDadosBanco[12]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		cCodAge := SubStr(aDadosBanco[11], 01, 04) + "-" + SubStr(aDadosBanco[11], 05, 01)
		cCodCed := aDadosBanco[12]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cCodAge := aDadosBanco[03]
		cCodCed := aDadosBanco[05] + "-" + aDadosBanco[06]
		cRet := cCodAge + " / " + cCodCed  
	
		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "399"
		cRet := aDadosBanco[03] + " " + aDadosBanco[05] 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422" //aqui
		cCodAge := aDadosBanco[03] + aDadosBanco[04]
		cCodCed := aDadosBanco[05] + aDadosBanco[06]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		cCodAge := SubStr(aDadosBanco[11], 01, 04) + "-" + SubStr(aDadosBanco[11], 05, 01)
		cCodCed := aDadosBanco[12]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\
		
	Case aDadosBanco[01] == "655"
		cCodAge := aDadosBanco[03] + "-" + aDadosBanco[04]
		cCodCed := aDadosBanco[05] + "-" + aDadosBanco[06]
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"     
		cCodAge := SubStr(aDadosBanco[11], 01, 04)
		cCodCed := aDadosBanco[12]            
		cRet := cCodAge + " / " + cCodCed
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		cCodAge := aDadosBanco[03]
		cCodCed := SubStr(aDadosBanco[10],01,01) + "." + SubStr(aDadosBanco[10],02,06) + "." +;
		SubStr(aDadosBanco[10],08,02) + "." + SubStr(aDadosBanco[10],10,01)
		cRet := cCodAge + " / " + cCodCed          
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÄÄÄÄÙ 
		
	Case aDadosBanco[01] == "748" 
         cCodAge := aDadosBanco[03]
         cCodCed := aDadosBanco[09]  
         cRet := cCodAge + "." + SubStr(cCodCed, 01, 02) + "." + SubStr(cCodCed, 03, 07)        
         
         //ÚÄÄÄÄÄÄÄÄ¿
		//³Sicoob³
		//ÀÄÄÄÄÄÄÄÄÙ 
		
	Case aDadosBanco[01] == "756" 
         cCodAge := aDadosBanco[03]
         cCodCed := aDadosBanco[09]  
         cRet := cCodAge + " / " + cCodCed
			
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna Label do campo "Nosso Número"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fLbCpoNNro(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "004"
		cRet := "Nosso Número / Carteira"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "623"
		cRet := "Carteira / Nosso Número"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := "Carteira / Nosso Número"
		
	OtherWise
		cRet := "Nosso Número"
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Retorna o conteúdo do campo Nosso Número³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fCpoNNro(cBoleto, cDv, aDadosBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "004"
		cRet := Trim(cBoleto) + "-" + Trim(cDv) + "  " + Trim(AdadosBanco[8])
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case aDadosBanco[01] == "001"
		lConv7 := .F.
		lConv7 := Len(aDadosBanco[09]) == 7
		if lConv7
			cRet := Trim(cBoleto) + Trim(cDv)
		Else
			cRet := Trim(cBoleto) + "-" + Trim(cDv)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		cRet := Trim(cBoleto) + " " + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104"
		cRet := Trim(cBoleto) + "-" + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		cRet := aDadosBanco[08] + " / "	+ Trim(cBoleto) + "-" + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		cRet := aDadosBanco[08] + " / " + Trim(cBoleto) + "-" +	Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		cRet := aDadosBanco[08] + " / " + Trim(cBoleto) + "-" + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		nCont   := 0
		cPeso   := 2
		cDig    := ""
		nBoleta := aDadosBanco[08] + aDadosBanco[09] + SubStr(cBoleto,01,06)
		For i := len(nBoleta) To 1 Step -1
			nCont := nCont + (Val(SubStr(nBoleta,i,1))) * cPeso
			cPeso := cPeso + 1
			If cPeso == 8
				cPeso := 2
			Endif
		Next
		
		Resto := ( nCont % 11 )
		
		Do Case
			Case Resto == 0
				cDig := "0"
			Case Resto == 1
				cDig := "P"
			OtherWise
				Resto   := ( 11 - Resto )
				cDig := AllTrim(Str(Resto))
		EndCase
		
		cRet := aDadosBanco[08] + " / " + aDadosBanco[09] +	Trim(cBoleto) + "-" +	Trim(cDig)
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cRet := aDadosBanco[08] + " / " + Trim(cBoleto) + "-" +	Trim(cDv) 
	
		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "399"
		cRet := SubStr(Trim(cBoleto), 01, 02) + " " +; 
						SubStr(Trim(cBoleto), 03, 03) + " " +;
						SubStr(Trim(cBoleto), 06, 03) + " " +;
						SubStr(Trim(cBoleto), 09, 02) + " " + cDv
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422"  
		cRet :=  Trim(cBoleto)
		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
		
	Case aDadosBanco[01] == "623"
		cRet := aDadosBanco[08] + " / " + Trim(cBoleto) + "-" +	Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄà
		
	Case aDadosBanco[01] == "655"
		cRet := Trim(cBoleto) + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		cRet := aDadosBanco[08] + " / " +	Trim(cBoleto) + "-" + Trim(cDv)   
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		cRet := Trim(cBoleto) + "-" + Trim(cDv) 
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³       Sicredi         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "748"
		cRet := SubStr(Trim(cBoleto), 01, 02)  + "/" + SubStr(Trim(cBoleto), 03, 01)  + SubStr(Trim(cBoleto), 04, 05)  + "-" + Trim(cDv)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicoob³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "756"
		cRet := Trim(cBoleto) + "-" + Trim(cDv) 
		
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8¿
//³Função que vai gerar a base do nosso número.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ8Ù

Static Function fGerNNro(cSequencia)
Local cRet   := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Brasil³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "001"
		cRet := aDadosBanco[09] + cSequencia
		
		//ÚÄÄÄÄÄ¿
		//³Caixa³
		//ÀÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104" 
	
		If aDadosBanco[01] == "104" .and. Len(aDadosBanco[09]) != 12 
		   cRet := "1" + "4" + "000" + cSequencia 
	   	Else 
	   		cRet := "9" + SubStr(cSequencia, 04,10)   
	   	EndIf	
 		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³BIC Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		cRet := cSequencia
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422"
		cRet := cSequencia
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		
	Case aDadosBanco[01] == "655"
		cRet := aDadosBanco[09] + cSequencia
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		//³     Sicredi    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄt
		
	Case aDadosBanco[01] == "748"
		cRet := right(alltrim(str(year(dDatabase))),2) + "2" + cSequencia
		
	OtherWise
		cRet := cSequencia
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄå¿
//³Função que retorna o dígito do código do banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄåÙ

Static Function fDvBco(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "004"
		cRet := "-3"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBanco == "001"
		cRet := "-9"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "033"
		cRet := "-7"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "104"
		cRet := "-0"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "224"
		cRet := "-7"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "237"
		cRet := "-2"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "246"
		cRet := "-2"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cRet := "-2"
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "341"
		cRet := "-7"
		
		//ÚÄÄÄÄ¿
		//³HSBC³
		//ÀÄÄÄÄÙ
		
	Case cBanco == "399"
		cRet := "-9"
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "422"
		cRet := "-7"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "623"
		cRet := "-2"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
	Case cBanco == "655"
		cRet := "-9"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := "-7"
		                                                                   
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "745"
		cRet := "-5"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "748"
		cRet := "-X"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicoob³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "756"
		cRet := "-0"
		
EndCase

Return cRet   


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o código da carteira³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fCpoCart(aDadosBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco do Nordeste³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "004"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "001"
		cRet := SubStr(aDadosBanco[08],01,02)
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		cRet := aDadosBanco[08] + " - " + "COBRANCA SIMPLES RCR"
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caixa Econômica Federal³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "104"
		cRet := "CR"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Fibra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "224"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Bradesco³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "237"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "246"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "320"
		cRet := aDadosBanco[08] 
	
	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case aDadosBanco[01] == "399"
	 cRet := "CSB"
		
		//ÚÄÄÄÄ¿
		//³Itaú³
		//ÀÄÄÄÄÙ
		
	Case aDadosBanco[01] == "341"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "422"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÔ
		
	Case aDadosBanco[01] == "655"
		cRet := SubStr(aDadosBanco[08],01,02)
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "745"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicredi³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "748"
		cRet := aDadosBanco[08]
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Sicoob³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "756"
		cRet := aDadosBanco[08]
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o uso do banco.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function cCpoUsoBco(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄ¿
	//³Bic Banco³
	//ÀÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "320"
		cRet := "EXPRESSA"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	//Case cBanco == "422"
		//cRet := "CIP 130"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := " "
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Citibank³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "745"
		cRet := "CLIENTE"
		
	OtherWise
		cRet := " "
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o código do banco (tratativa de banco correspondente)³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fRetCodBco(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Banco Fibra³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "224"
		cRet := "341"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Banco ABC³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "246"
		cRet := "237"
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cRet := "237"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Safra³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÙ
		
	//Case cBanco == "422"
		//cRet := "237"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "623"
		cRet := "237"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\
		//³Banco Votorantim³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\
		
	Case cBanco == "655"
		cRet := "001"
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "707"
		cRet := "341"
		
	OtherWise
		cRet := cBanco
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz o cálculo do módulo 10 do Itaú³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Mod10Itau(cParam)
Local cRet  := ""
Local cData := cParam
Local L,D,P := 0
Local B     := .F.

L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End

cRet := AllTrim(Str(D))

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o Sacador/Avalista³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fSacAva(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	//³Banco Daycoval³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	
	Case cBanco == "707"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄœ5Ôœ5Ô¿
		//³Banco do Brasil³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "001"
		cRet := " "  
		
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	//³Banco fidc arm³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	                      
	
	Case cBanco == "237".and. (AllTrim(cConta)) == '0014046'
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " ,CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")	
		
		
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	//³Banco fidc rnx³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	                      
	
	Case cBanco == "237".and. (AllTrim(cConta)) == '0838500'
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " ,CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")	
		
	 //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	//³Banco Gavea Sul³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄå
	                      
	
	Case cBanco == "237".and. (AllTrim(cConta)) $ "0000112/0006773"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " ,CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")			
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Bic Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case cBanco == "320"
		cRet := Upper(AllTrim(SM0->M0_NOMECOM)) + " CNPJ: " + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³HSBC Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
    
    Case cBanco == "399"
		cRet := " "
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³HSBC Banco³
		//ÀÄÄÄÄÄÄÄÄÄÙ
    
    Case cBanco == "422"
		cRet := " "
		     		
		
	OtherWise
		cRet := Upper(AllTrim(SM0->M0_NOMECOM))
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna a espécie de documento de acordo com o banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fEspDoc(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄ¿
	//³Citibank³
	//ÀÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "745"
		cRet := "DMI"       

	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case cBanco == "399"
		cRet := "PD"
		
	OtherWise
		cRet := "DM"
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna o número do documento a ser impresso no boleto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fNroDoc(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄ¿
	//³Citibank³
	//ÀÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "745"
		cRet := SubStr(SE1->E1_NUM, 04, 06) + SE1->E1_PARCELA
		
	OtherWise
		cRet := SE1->E1_NUM + SE1->E1_PARCELA
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que retorna a espécie da Moeda³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fEspecie(cBanco)
Local cRet := ""

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄ¿
	//³Santander³
	//ÀÄÄÄÄÄÄÄÄÄÙ
	
	Case cBanco == "033"
		cRet := "REAL" 

	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case cBanco == "399"
		cRet := "REAL"
		
	OtherWise
		cRet := "R$"
		
EndCase

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€ìòƒìòƒˆ¿
//³Função que retorna o Label da Espécie de acordo com o banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ€ìòƒìòƒˆÙ

Static Function fLbEsp(cBanco)
Local cRet := ""

Do Case
	Case cBanco == "104"
		cRet := "Moeda "
	Case cbanco == "623"
		cRet := "Moeda "
	OtherWise
		cRet := "Espécie"
EndCase

Return cRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fImpPDF ºAutor  ³Jean Carlos Saggin    º Data ³  28/05/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada para geração do boleto no formato PDF     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLASER_NEW (Impressão no formato PDF)                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fImpPDF( _nVia, _nL, oPrnPDF )
Local _nPapel  := 1
Local _nLBarra := 0
Local nPrp     := 4
Local _nCol    := (-70 / nPrp)
Local _nVaria  := (190 / nPrp)
Local _nLPDF   := _nL - 13

Do Case
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Para Laser A4³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case _nPapel = 1
		_nL -= (85 / nPrp)
		_nLBarra := 62
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Para Laser Oficio 2 (216 x 330)³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case _nPapel = 2
		_nL += 50
		_nLBarra := 29.6
EndCase

oPrnPDF:Line(_nL+(80/nPrp),(690/nPrp),_nL+(150/nPrp),(690/nPrp))  //** Linhas Verticais do Codigo
oPrnPDF:Line(_nL+(80/nPrp),(900/nPrp),_nL+(150/nPrp),(900/nPrp))  //** Ex:  | 001-9 |

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\¿
//³Valida se existe imagem de logo pra por no boleto, senão imprime o nome do banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ\Ù

if fValImage(aDadosBanco[01])
	oPrnPDF:sayBitmap(_nL+(080/nPrp),(30/nPrp),"/system/"+aDadosBanco[01]+".bmp",(350/nPrp),(78/nPrp))
Else
	oPrnPDF:Say(_nLPDF+(090/nPrp),(0100/nPrp),aDadosBanco[02],oFont3Bold,(100/nPrp))
EndIf

oPrnPDF:say(_nLPDF+(090/nPrp),(0710/nPrp),fRetCodBco(aDadosBanco[01])+cDvCod,oFont18n)   			//** Codigo "001-9"

oPrnPDF:Box(_nL+(160/nPrp),_nCol+(0100/nPrp)        ,_nL+(240/nPrp),_nCol+(1500/nPrp)+_nVaria)         			//** Local de Pagamento
oPrnPDF:Box(_nL+(160/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(240/nPrp),_nCol+(2200/nPrp)+_nVaria) 			//** Vencimento
oPrnPDF:box(_nL+(240/nPrp),_nCol+(0100/nPrp)        ,_nL+(320/nPrp),_nCol+(1500/nPrp)+_nVaria)         			//** Beneficiário
oPrnPDF:box(_nL+(240/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(320/nPrp),_nCol+(2200/nPrp)+_nVaria) 			//** Agencia / Codigo Beneficiário
oPrnPDF:box(_nL+(320/nPrp),_nCol+(0100/nPrp)        ,_nL+(400/nPrp),_nCol+(0380/nPrp)) 											//** Data Documento
oPrnPDF:box(_nL+(320/nPrp),_nCol+(0380/nPrp)        ,_nL+(400/nPrp),_nCol+(0700/nPrp)) 											//** Nr Documento
oPrnPDF:box(_nL+(320/nPrp),_nCol+(0700/nPrp)        ,_nL+(400/nPrp),_nCol+(0890/nPrp)) 											//** Especie Doc
oPrnPDF:box(_nL+(320/nPrp),_nCol+(0890/nPrp)        ,_nL+(400/nPrp),_nCol+(1060/nPrp))
oPrnPDF:box(_nL+(320/nPrp),_nCol+(1060/nPrp)        ,_nL+(400/nPrp),_nCol+(1500/nPrp)+_nVaria)
oPrnPDF:box(_nL+(320/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(400/nPrp),_nCol+(2200/nPrp)+_nVaria)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Tratativa para o campo CIP (particularidade de alguns bancos)
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Do Case
	
	//ÚÄÄÄÄÄÄÄÄ¿
	//³BicBanco³
	//ÀÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == "320"
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0100/nPrp),_nL+(480/nPrp),_nCol+(0350/nPrp))         					//** Uso do Banco
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0120/nPrp),"Uso do Banco",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0120/nPrp),cCpoUsoBco(aDadosBanco[01]),oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0350/nPrp),_nL+(480/nPrp),_nCol+(0450/nPrp)) 									//** CIP
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0370/nPrp),"CIP",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0370/nPrp),"521",oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0450/nPrp),_nL+(480/nPrp),_nCol+(0650/nPrp)) 									//** Carteira
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0470/nPrp),"Carteira",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0470/nPrp),fCpoCart(aDadosBanco),oFont2,(100/nPrp))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Banco Panamericano³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "623"
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0100/nPrp),_nL+(480/nPrp),_nCol+(0350/nPrp))         					//** Uso do Banco
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0120/nPrp),"Uso do Banco",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0120/nPrp),cCpoUsoBco(aDadosBanco[01]),oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0350/nPrp),_nL+(480/nPrp),_nCol+(0450/nPrp)) 									//** CIP
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0370/nPrp),"CIP",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0370/nPrp),"000",oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0450/nPrp),_nL+(480/nPrp),_nCol+(0650/nPrp)) 									//** Carteira
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0470/nPrp),"Carteira",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0470/nPrp),fCpoCart(aDadosBanco),oFont2,(100/nPrp))
		
		//ÚÄÄÄÄÄÄÄÄ¿
		//³Daycoval³
		//ÀÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "707"
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0100/nPrp),_nL+(480/nPrp),_nCol+(0350/nPrp))         					//** Uso do Banco
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0120/nPrp),"Uso do Banco",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0120/nPrp),cCpoUsoBco(aDadosBanco[01]),oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0350/nPrp),_nL+(480/nPrp),_nCol+(0450/nPrp)) 									//** CIP
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0370/nPrp),"CIP",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0370/nPrp),"504",oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0450/nPrp),_nL+(480/nPrp),_nCol+(0650/nPrp)) 									//** Carteira
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0470/nPrp),"Carteira",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0470/nPrp),fCpoCart(aDadosBanco),oFont2,(100/nPrp))
		
		//ÚÄÄÄÄÄÄÄÄÄ¿
		//³Santander³
		//ÀÄÄÄÄÄÄÄÄÄÙ
		
	Case aDadosBanco[01] == "033"
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0100/nPrp),_nL+(480/nPrp),_nCol+(0650/nPrp)) 									//** Carteira
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0320/nPrp),"Carteira",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0120/nPrp),fCpoCart(aDadosBanco),oFont2,(100/nPrp))
		
	OtherWise
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0100/nPrp),_nL+(480/nPrp),_nCol+(0350/nPrp))         					//** Uso do Banco
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0120/nPrp),"Uso do Banco",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0120/nPrp),cCpoUsoBco(aDadosBanco[01]),oFont2,(100/nPrp))
		
		oPrnPDF:box(_nL+(400/nPrp),_nCol+(0350/nPrp),_nL+(480/nPrp),_nCol+(0650/nPrp))      							//** Carteira
		oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0400/nPrp),"Carteira",oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0450/nPrp),fCpoCart(aDadosBanco),oFont2,(100/nPrp))
		
EndCase

oPrnPDF:box(_nL+(400/nPrp) ,_nCol+(0650/nPrp)        ,_nL+(480/nPrp) ,_nCol+(0800/nPrp))         							//** Espécie
oPrnPDF:box(_nL+(400/nPrp) ,_nCol+(0800/nPrp)        ,_nL+(480/nPrp) ,_nCol+(1210/nPrp))         							//** Quantidade
oPrnPDF:box(_nL+(400/nPrp) ,_nCol+(1210/nPrp)        ,_nL+(480/nPrp) ,_nCol+(1500/nPrp)+_nVaria) 							//** Valor
oPrnPDF:box(_nL+(400/nPrp) ,_nCol+(1500/nPrp)+_nVaria,_nL+(480/nPrp) ,_nCol+(2200/nPrp)+_nVaria)
oPrnPDF:box(_nL+(480/nPrp) ,_nCol+(0100/nPrp)        ,_nL+(880/nPrp) ,_nCol+(2200/nPrp)+_nVaria-1)
oPrnPDF:box(_nL+(880/nPrp) ,_nCol+(0100/nPrp)        ,_nL+(1020/nPrp) ,_nCol+(2200/nPrp)+_nVaria-1)
oPrnPDF:box(_nL+(1020/nPrp),_nCol+(0100/nPrp)        ,_nL+(1055/nPrp) ,_nCol+(2200/nPrp)+_nVaria-1)

If _nVia == 1 .or. _nVia == 2
	oPrnPDF:box(_nL+(480/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(560/nPrp),_nCol+(2200/nPrp)+_nVaria)
	oPrnPDF:box(_nL+(560/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(640/nPrp),_nCol+(2200/nPrp)+_nVaria)
	oPrnPDF:box(_nL+(640/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(720/nPrp),_nCol+(2200/nPrp)+_nVaria)
	oPrnPDF:box(_nL+(720/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(800/nPrp),_nCol+(2200/nPrp)+_nVaria)
	oPrnPDF:box(_nL+(800/nPrp),_nCol+(1500/nPrp)+_nVaria,_nL+(880/nPrp),_nCol+(2200/nPrp)+_nVaria)
Endif

oPrnPDF:say(_nLPDF+(160/nPrp),_nCol+(0120/nPrp),"Local de Pagamento",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(190/nPrp),_nCol+(0120/nPrp),fRetLocPag(aDadosBanco[01]),oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(160/nPrp),_nCol+(1520/nPrp)+_nVaria,"Vencimento",oFont1,(100/nPrp))

_cDataTmp := Substr(DtoS(SE1->E1_VENCREA),7,2) + "/" + ;
Substr(DtoS(SE1->E1_VENCREA),5,2) + "/" + ;
Substr(DtoS(SE1->E1_VENCREA),1,4)

oPrnPDF:say(_nLPDF+(190/nPrp),_nCol+(1800/nPrp)+_nVaria,PadL(_cDataTmp,30," "),oFont7,30,,,PAD_LEFT)

oPrnPDF:say(_nLPDF+(240/nPrp),_nCol+(0120/nPrp),"Beneficiário",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(270/nPrp),_nCol+(0120/nPrp),fRetCed(aDadosBanco[01]), oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(240/nPrp),_nCol+(1520/nPrp)+_nVaria,"Agência / Código Beneficiário",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(270/nPrp),_nCol+(1800/nPrp)+_nVaria,PadL(fAgeCodCed(aDadosBanco),27," "), oFont7,27,,,PAD_LEFT)

oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(0120/nPrp),"Data Doc.",oFont1)                            // Data do documento

_cDataTmp := Substr(DtoS(SE1->E1_EMISSAO),7,2) + "/" + ;
Substr(DtoS(SE1->E1_EMISSAO),5,2) + "/" + ;
Substr(DtoS(SE1->E1_EMISSAO),1,4)

oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(0120/nPrp),_cDataTmp,oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(0390/nPrp),"Número Doc.",oFont1,(100/nPrp))              // Número do documento
oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(0400/nPrp),fNroDoc(aDadosBanco[01]),oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(0720/nPrp),"Esp. Doc",oFont1,(100/nPrp))                 // Espécie Doc
oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(0720/nPrp),fEspDoc(aDadosBanco[01]),oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(0900/nPrp),"Aceite",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(0910/nPrp),fRetAce(aDadosBanco),oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(1080/nPrp),"Data Processamento",oFont1,(100/nPrp))

_cDataTmp := Substr(DtoS(dDataBase),7,2) + "/" + ;
Substr(DtoS(dDataBase),5,2) + "/" + ;
Substr(DtoS(dDataBase),1,4)

oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(1180/nPrp),_cDataTmp,oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(320/nPrp),_nCol+(1520/nPrp)+_nVaria, fLbCpoNNro(aDadosBanco[01]),oFont1,,,,PAD_RIGHT)
oPrnPDF:say(_nLPDF+(350/nPrp),_nCol+(1800/nPrp)+_nVaria, PadL(fCpoNNro(M->NumBoleta, dvBol, aDadosBanco),25," "),oFont7,25,,,PAD_LEFT)

oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0670/nPrp),fLbEsp(aDadosBanco[01]),oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(0670/nPrp),fEspecie(aDadosBanco[01]),oFont2,(100/nPrp))
oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(0820/nPrp),"Quantidade",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(1240/nPrp),"Valor",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(400/nPrp),_nCol+(1520/nPrp)+_nVaria,"(=) Valor do Documento",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(430/nPrp),_nCol+(1800/nPrp)+_nVaria,PadL(Transform(nValLiq,"@E 999,999,999.99"),33," "),oFont7,33,,,PAD_LEFT)

If _nVia == 1
	
	oPrnPDF:say(_nLPDF+(480/nPrp),_nCol+(0120/nPrp),"Instruções (Todas as instruções desse bloqueto são de exclusiva respons. do Beneficiário)",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(480/nPrp),_nCol+(1520/nPrp)+_nVaria,"(-) Desconto",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(560/nPrp),_nCol+(1520/nPrp)+_nVaria,"(-) Outras Deduções (abatimento)",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(640/nPrp),_nCol+(1520/nPrp)+_nVaria,"(+) Mora / Multa (Juros)",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(720/nPrp),_nCol+(1520/nPrp)+_nVaria,"(+) Outros Acréscimos",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(800/nPrp),_nCol+(1520/nPrp)+_nVaria,"(=) Valor Cobrado",oFont1,(100/nPrp))
	
	_nQtdLin := 0
	_nCtr    := 1
	_nQtdIni := 550
	for _nCtr := 1 to len(aMensagem)
		oPrnPDF:say(_nLPDF+((_nQtdIni+_nQtdLin)/nPrp),_nCol+(0120/nPrp), aMensagem[_nCtr], oFont2,(100/nPrp))
		_nQtdLin += 40
	Next _nCtr
	
	cTelCob := ""
	cTelCob := SuperGetMv("MV_TELCOB",,"("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8))
	if Empty(cTelCob)
		cTelCob := "("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8)
	EndIf
	oPrnPDF:say(_nLPDF+(845/nPrp),(0120/nPrp),"DUVIDAS SOBRE COBRANÇA, LIGUE "+cTelCob,oFont1,(100/nPrp))
	
ElseIf _nVia == 2
	oPrnPDF:say(_nLPDF+(480/nPrp),_nCol+(1520/nPrp)+_nVaria,"(-) Desconto",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(560/nPrp),_nCol+(1520/nPrp)+_nVaria,"(-) Outras Deduções (abatimento)",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(640/nPrp),_nCol+(1520/nPrp)+_nVaria,"(+) Mora / Multa (Juros)",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(720/nPrp),_nCol+(1520/nPrp)+_nVaria,"(+) Outros Acréscimos",oFont1,(100/nPrp))
	oPrnPDF:say(_nLPDF+(800/nPrp),_nCol+(1520/nPrp)+_nVaria,"(=) Valor Cobrado",oFont1,(100/nPrp))   
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade Caixa    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		if aDadosBanco[01] == "104"
		oPrnPDF:say(_nL+845,0120,"SAC CAIXA 0800 726 0101, OUVIDORIA CAIXA 0800 725 7474 ",oFont1,100) 
    EndIf  
                                                             
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Particularidade BIC Banco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if aDadosBanco[01] == "320"
		oPrnPDF:say(_nLPDF+(480/nPrp),_nCol+(0120/nPrp),"Instruções (Todas as instruções desse bloqueto são de exclusiva responsabilidade do cedente)",oFont1,(100/nPrp))
	Else
		oPrnPDF:say(_nLPDF+(480/nPrp),_nCol+(0120/nPrp),"Dados do Beneficiário",oFont1,(100/nPrp))
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4¿
	//³Particularidade de Mensagem do BIC Banco³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ4Ù
	
	if aDadosBanco[01] == "320"
		_nQtdLin := 0
		_nCtr    := 1
		_nQtdIni := 550
		for _nCtr := 1 to len(aMensagem)
			oPrnPDF:say(_nLPDF+((_nQtdIni+_nQtdLin)/nPrp),_nCol+(0120/nPrp), aMensagem[_nCtr], oFont2 ,(100/nPrp))
			_nQtdLin += 40
		Next _nCtr
	Else
		oPrnPDF:say(_nLPDF+(590/nPrp),(0120/nPrp), Upper(Trim(SM0->M0_NOMECOM)) + " CNPJ: "+ Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont2,(100/nPrp))
		oPrnPDF:say(_nLPDF+(630/nPrp),(0120/nPrp), Upper(Trim(SM0->M0_ENDENT)), oFont2, (100/nPrp))
		oPrnPDF:say(_nLPDF+(670/nPrp),(0120/nPrp), SubStr(SM0->M0_CEPENT,01,02) +"."+ SubStr(SM0->M0_CEPENT,03,03) +"-"+ SubStr(SM0->M0_CEPENT,06,03) +;
		" "+ Upper(Trim(SM0->M0_CIDENT)) + " " + SM0->M0_ESTENT, oFont2, (100/nPrp))
	EndIf
	
	cTelCob := ""
	cTelCob := SuperGetMv("MV_TELCOB",,"("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8))
	if Empty(cTelCob)
		cTelCob := "("+SubStr(SM0->M0_TEL,4,2)+") "+SubStr(SM0->M0_TEL,7,8)
	EndIf
	oPrnPDF:say(_nLPDF+(710/nPrp),(0120/nPrp),"DUVIDAS SOBRE COBRANÇA, LIGUE "+cTelCob,oFont1,(100/nPrp))
	
Else
	oPrnPDF:Say(_nLPDF+(790/nPrp),(0150/nPrp)," ASS.: " + Replicate(". ",60) + Space(04) + "DATA: " + Replicate(". ",05) + "/" +;
	Replicate(". ", 05,) + "/" + Replicate(". ", 10),oFont1,(100/nPrp))
Endif

oPrnPDF:say(_nLPDF+(880/nPrp),_nCol+(0120/nPrp),"Pagador:",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(900/nPrp),_nCol+(0250/nPrp),SA1->A1_NOME,oFont8,(100/nPrp))

If !Empty(SA1->A1_CEPC)
	oPrnPDF:say(_nLPDF+(940/nPrp),_nCol+(0250/nPrp),SA1->A1_ENDCOB+" "+SA1->A1_BAIRROC,oFont8,(100/nPrp))
	oPrnPDF:say(_nLPDF+(980/nPrp),_nCol+(0250/nPrp),"CEP " + SA1->A1_CEPC +" "+ SA1->A1_MUNC +" "+ SA1->A1_ESTC, oFont8,(100/nPrp))
Else
	oPrnPDF:say(_nLPDF+(940/nPrp),_nCol+(0250/nPrp),SA1->A1_END+" "+SA1->A1_BAIRRO,oFont8,(100/nPrp))
	oPrnPDF:say(_nLPDF+(980/nPrp),_nCol+(0250/nPrp),"CEP " + SA1->A1_CEP +" "+ SA1->A1_MUN+" "+SA1->A1_EST,oFont8,(100/nPrp))
Endif

If SA1->A1_PESSOA == "J"
	oPrnPDF:say(_nLPDF+(900/nPrp),_nCol+(1500/nPrp),Transform(SA1->A1_CGC,"@R 99.999.999/9999-99"),oFont8,(100/nPrp))
ElseIf SA1->A1_PESSOA == "F"
	oPrnPDF:say(_nLPDF+(900/nPrp),_nCol+(1500/nPrp),Transform(SA1->A1_CGC,"@R 999.999.999-99"),oFont8,(100/nPrp))
Endif

oPrnPDF:say(_nLPDF+(1020/nPrp),_nCol+(0120/nPrp),"Sac./Aval.",oFont1,(100/nPrp))              // Sacador / Avalista
oPrnPDF:say(_nLPDF+(1020/nPrp),_nCol+(0390/nPrp),fSacAva(aDadosBanco[01]),oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(1020/nPrp),_nCol+(1520/nPrp)+_nVaria,"Código de Baixa:",oFont1,(100/nPrp))
oPrnPDF:say(_nLPDF+(1060/nPrp),_nCol+(1300/nPrp)+_nVaria,"Autenticação Mecânica",oFont1,(100/nPrp))

Do Case
	Case _nVia == 1
		oPrnPDF:say(_nLPDF+(50/nPrp),_nCol+(0010/nPrp),Replicate("- ",900),oFont1,(100/nPrp))
		oPrnPDF:say(_nLPDF+(1060/nPrp),_nCol+(1800/nPrp)+_nVaria,"Ficha de Compensação",oFont4,,,, 1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a Linha Digitavel  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
		oPrnPDF:Say(_nLPDF+(100/nPrp),_nCol+(1100/nPrp)+_nVaria, M->LinhaDig ,oFont9,,,, 1)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime o Codigo de Barras ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		oPrnPDF:FwMsBar("INT25", _nLBarra + 6, 0.6 ,M->CodBarras ,oPrnPDF,.F.,NIL,NIL,0.025,1.5,NIL,NIL,"A",.F.,,)
		
	Case _nVia == 2
		oPrnPDF:say(_nLPDF+(50/nPrp),(0010/nPrp),replicate("- ",900),oFont1,(100/nPrp))
		oPrnPDF:Say(_nLPDF+(100/nPrp),_nCol+(1900/nPrp)+_nVaria,"Recibo do Pagador",oFont4,,,,PAD_RIGHT)
		
	Case _nVia == 3
		oPrnPDF:say(_nLPDF+(1060/nPrp),_nCol+(1850/nPrp)+_nVaria,"Controle do Beneficiário",oFont4,,,,PAD_RIGHT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime a Linha Digitavel  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
		
		oPrnPDF:Say(_nLPDF+(100/nPrp),_nCol+(1100/nPrp)+_nVaria, M->LinhaDig ,oFont9,,,, 1)
EndCase 

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável por retornar o código do Aceite ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fRetAce(aDadosBanco)

Local cRet := ""

Do Case

	//ÚÄÄÄÄ¿
	//³HSBC³
	//ÀÄÄÄÄÙ
	
	Case aDadosBanco[01] == "399"
		cRet := "NÃO"   
		
	OtherWise
		cRet := aDadosBanco[7]
		
EndCase

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fDadosBanco ºAutor  Jean Carlos Saggin º Data ³  29/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para retornar código da empresa com dígito          º±±
±±º          ³ verificador já calculado.                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ BOLASER_NEW                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fDadosBanco(aDadosBanco)

Local cRet := ""
Local nX   := 0

Do Case

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caixa, quando cobrança for layout SIGCB³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Case aDadosBanco[01] == '104' .and. Len(aDadosBanco[09]) != 12
	    nPeso   := 2
	    nSoma   := 0
	    nResult := 0
	    nResto  := 0
	    
	    For nX := Len(aDadosBanco[09]) to 1 step -1
	    	nSoma += Val(SubStr(aDadosBanco[09], nX, 1)) * nPeso
	    	nPeso++
	    Next nX
	    
	    if nSoma < 11
	    	nResult := 11 - nSoma
	    Else
	    	nResto  := nSoma % 11
	    	nResult := 11 - nResto
	    EndIf
	    
	    if nResult > 9
	    	nResult := 0
	    EndIf
	    
		cRet := aDadosBanco[09] + AllTrim(Str(nResult))
	
	OtherWise
		cRet := aDadosBanco[09]
		
EndCase

Return cRet


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fAguarda ºAutor  ³Jean Carlos P. Sagginº Data ³  23/10/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função criada para mostrar régua de processamento          º±±
±±º          ³ pedindo para usuário aguardar 10 segundos                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ESPECIFICOS CANTU ALIMENTOS                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fAguarda(nVezes)

Local nX := 0

ProcRegua(nVezes)

For nX := 1 to nVezes
	IncProc()
	Sleep(1000)	
Next nX

Return