#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "rwmake.ch"
#INCLUDE "TOTVS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RJPEDEDI  �Autor  �FV SISTEMAS - FLAVIO  Data �  27/01/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Importa��o de pedidos do EDI Neogrid para o sistema        ���
���          � As pastas devem ser configuradas atrav�s de par�metros     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RJPEDEDI(cAlias, nReg, nOpc)
Local cPathPed := ""
Local aFiles := {}
Local nX
Private cFileImp := ""
Private cFileMov := ""
if Select("SX6") <= 0
	RpcSetType(03)
	RpcSetEnv("02", "01", "SIGAFAT")
endIf

cPathPed := GetNewPar("RJ_NEOPAT", "d:\neogrid\")
cPathPed := cGetFile( "*", "Diret�rio de Importa��o Neogrid", 1, cPathPed, .T., GETF_RETDIRECTORY  + GETF_LOCALHARD, .T.)
MakeDir(cPathPed + "old\")

aFiles := Directory(cPathPed +"*.txt")
For nFileImp := 1 to Len(aFiles)
	cFileImp := cPathPed + aFiles[nFileImp,1]
	cFileMov := cPathPed + "old\" + aFiles[nFileImp,1]
	
	// valida a primeira linha para importa��o e troca da filial
	FT_FUSE(cFileImp)
	FT_FGOTOP()	
	cLinha := FT_FREADLN()	
	cStr := SubStr(cLinha, 167, 14) // busca o cnpj do fornecedor do produto, no caso a filial de faturamento
	FT_FUSE()
	aEmp := PesqCGC(cStr)
	if (Len(aEmp) > 0) .And. (aEmp[1,1] == cEmpAnt)
		cFilAnt := aEmp[1,2]
		cFilAux := aEmp[1,2]
		A410Inclui(cAlias, nReg, nOpc)
		__CopyFile(cFileImp,cFileMov)
		FErase(cFileImp)
	elseif Len(aEmp) == 0
		MsgAlert("N�o h� filial cadastrada com o cnpj " + cStr + ". Pedido n�o ser� importado." + chr(13) + chr(10) + "Arquivo: " + cFileImp)
	else
		MsgInfo("Arquivo " + cFileImp + " refere-se a empresa " + aEmp[1] + ". Dever� efetuada a importa��o na empresa correta.")
	endIf
Next nX

Return

// usa o ponto de entrada para alimentar as vari�veis na tela, se chamado pela rotina de inclus�o
User Function M410INIC()
if IsIncallStack("U_RJPEDEDI")
	ImpPed(cFileImp)	
endIf
Return

/*User Function MT410INC()
// Grava a amarra��o de produtos
if IsIncallStack("U_RJPEDEDI")
	
endIf
Return*/

// Faz a importa��o do pedido da Neogrid no Protheus
Static Function ImpPed(cArquivo)
Local cMsgPed := ""
Local _nNrLin := 0
Local cLinha := ""
Local nlUsado       := 0
Local alDTVirt      := {}
Local alDTVisu      := {}
Local alRecDT       := {}
Local alSF1         := {}
Local alSD1         := {}
Local alSize        := MsAdvSize(.T.)
Local clKey         := ""
Local clTab1	    := "SC5"
Local clTab2	    := "SC6"
Local clAwysT       := "AllwaysTrue()"
Local alCpoEnch     := {}
Local alHeaderDT    := {}
Local lImpPed       := .F.
Local lProd 				:= .F.
Local nX
Local nPosProd
Local nPosDesc
Local nPosPFor
Local nPosItem
Local cProd
Local cProdEmp
Local cStr
Local cPedComp
Local cCLRF := chr(13) + chr(10)

// Faz a importa��o conforme o layout
FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	if empty(cLinha)
		exit
	endIf
	if (SubStr(cLinha, 1, 2) == "01")
		// Cabe�alho
		cMsgPed := ""
		/*
		Registro 01 - CABE�ALHO (uma �nica ocorr�ncia)	Obrig	Tipo	Tam	Dec	In�cio	Fim
		Tipo de Registro	S	AN	2		0	1
		Fun��o Mensagem	S	AN	3		2	4
		Tipo de Pedido	S	AN	3		5	7
		N�mero do Pedido do Comprador	S	AN	20		8	27
		N�mero do Pedido do Sistema de Emiss�o	N	AN	20		28	47
		Data - Hora de Emiss�o do Pedido	S	N	12		48	59
		Data - Hora Inicial do Per�odo de Entrega	S	N	12		60	71
		Data - Hora Final do Per�odo de Entrega	S	N	12		72	83
		N�mero do Contrato	N	AN	15		84	98
		Lista de Pre�os	N	AN	15		99	113
		EAN de Localiza��o do Fornecedor	S	N	13		114	126
		EAN de Localiza��o do Comprador	S	N	13		127	139
		EAN de Localiza��o de Cobran�a da Fatura	S	N	13		140	152
		EAN de Localiza��o do Local de Entrega	S	N	13		153	165
		CNPJ do Fornecedor	S	N	14		166	179
		CNPJ do Comprador	S	N	14		180	193
		CNPJ do Local da Cobran�a da Fatura	S	N	14		194	207
		CNPJ do Local de Entrega	S	N	14		208	221
		Tipo de C�digo da Transportadora	N	AN	3		222	224
		C�digo da Transportadora	N	N	14		225	238
		Nome da Transportadora	N	AN	30		239	268
		Condi��o de Entrega (tipo de frete)	S	AN	3		269	271
		Se��o do Pedido	S	N	3		272	274
		Observa��o do Pedido	S	AN	40		275	314
			*/
		
		/*C�digo	Descri��o do C�digo
		9	Original (Transmiss�o Inicial)
		16	Proposta
		31	C�pia (Mensagem � c�pia de original j� enviado)
		42	Confirma��o (pedido enviado por outros meios)
		46	Provis�ria
		*/
		cFuncMsg := Trim(SubStr(cLinha, 3, 3))
		/*C�digo	Descri��o
		000	Pedido com condi��es especiais
		001	Pedido Normal
		002	Pedido de Mercadorias Bonificadas
		003	Pedido de Consigna��o
		004	Pedido Vendor
		005	Pedido Compror
		006	Pedido de Demonstra��o
		*/
		aTpPed := {{"000",	"Pedido com condi��es especiais"},;
				{"001", "Pedido Normal"},;
				{"002",	"Pedido de Mercadorias Bonificadas"},;
				{"003",	"Pedido de Consigna��o"},;
				{"004",	"Pedido Vendor"},;
				{"005",	"Pedido Compror"},;
				{"006",	"Pedido de Demonstra��o"}}
		cStr := Trim(SubStr(cLinha, 6, 3))
		if (cStr != "001")
			cMsgPed += "Tipo Pedido : " + aTpPed[aScan(aTpPed, {|x|x[1] == cStr}), 2] + cCLRF			
		endIf
		
		M->C5_TIPO := "N"
		
		// N�mero de pedido do comprador
		cPedComp := Trim(SubStr(cLinha, 9, 20)) // grava para a linha de itens
		M->C5_MENNOTA := PadR("Pedido do Cliente: " + cPedComp, Len(SC5->C5_MENNOTA))
		
		// N�mero de pedido no sistema de emiss�o
		// cPedEmis := Trim(SubStr(cLinha, 29, 20))
		// Data Emiss�o
		cStr := SubStr(cLinha, 49, 12)
		M->C5_EMISSAO := StoD(SubStr(cStr, 1, 8))
		
		// Entrega De
		cEntDe := SubStr(cLinha, 61, 12)
		
		// Entrega at�
		cEntAte := SubStr(cLinha, 73, 12) 
		
		if !Empty(cEntAte)
			cMsgPed += "Entrega de : " + dToC(StoD(SubStr(cEntDe, 1, 8))) + " at� " + dToC(StoD(SubStr(cEntAte, 1, 8))) + cCLRF
		endIf
		
		// Nro Contrato
		cStr := AllTrim(SubStr(cLinha, 85, 15))
		
		if !Empty(cStr)
			cMsgPed += "Contrato : " + cStr + cCLRF
		endIf
		
		// Lista de Pre�os
		//cLstPrc := AllTrim(SubStr(cLinha, 100, 15))
		
		// Cnpj Fornecedor
		// J� validado na entrada do arquivo
		//cStr := SubStr(cLinha, 167, 14)
		
		// Cnpj Comprador
		// verificar gatilhos
		cStr := SubStr(cLinha, 181, 14)
		SA1->(dbSetOrder(03))
		if SA1->(dbSeek(xFilial("SA1") + cStr))
			M->C5_CLIENTE := SA1->A1_COD
			cStr := SA1->A1_LOJA
			
			// Chama fun��o de atualiza��o dos dados do cliente
			A410Cli("M->C5_CLIENTE",M->C5_CLIENTE)
			RUNTRIGGER(1,,, "C5_CLIENTE")		
			
			M->C5_LOJACLI := cStr
			A410Loja("M->C5_LOJACLI", M->C5_LOJACLI)
		endIf
		
		
		// Cnpj Cobran�a
		cStr := SubStr(cLinha, 195, 14)
		cMsgPed += "Cnpj Cobran�a : " + cStr + cCLRF
		
		// Cnpj Entrega
		cStr := SubStr(cLinha, 208, 14)
		if SA1->(dbSeek(xFilial("SA1") + cStr))
			M->C5_CLIENT := SA1->A1_COD
			M->C5_LOJAENT := SA1->A1_LOJA
		endIf
		
		// Cnpj Transportadora
		// cCnpjTra := SubStr(cLinha, 226, 14)
		
	elseif (SubStr(cLinha, 1, 2) == "02")
		// Pagamentos
		
		/*C�digo	Descri��o
			1	B�sico
			3	Data Fixa (Pagamento realizado na data ou per�odo estipulado no pedido)
			20	Multa
			21	Pagamento Parcelado
			22	Desconto por Antecipa��o de Pagamento
			B01	Pagamento com Dias de Concentra��o
			JRM	Juros de Mora			
		*/
		// Tipo Vencimento
		cTpVenc := Trim(SubStr(cLinha, 3, 3))
		
		/*C�digo	Descri��o
		1	Data do Pedido
		3	Data do Contrato
		5	Data da Fatura
		9	Data de Recebimento da Fatura
		21	Data de Recebimento das Mercadorias pelo Comprador
		66	Data Especificada (no campo Data de Vencimento)
		81	Data do Embarque (conforme documentos de transporte)
		*/		
		// Refer�ncia da Data
		cRefDT := AllTrim(SubStr(cLinha, 6, 3))
		
		/*C�digo	Descri��o
		1	Na data de refer�ncia
		3	Ap�s data de refer�ncia
		4	Final do per�odo de dez dias contendo a data de refer�ncia (fora a dezena)
		5	Final do per�odo de duas semanas contendo a data de refer�ncia (fora duas semanas)
		6	Final do m�s contendo a data de refer�ncia (fora o m�s)
		10	Final da semana contendo a data de refer�ncia (fora a semana)
		10E	Final da quinzena contendo a data de refer�ncia (fora quinzena)
		*/
		// Referencia de Tempo da Data
		cRefTp := AllTrim(SubStr(cLinha, 9, 3))
		
		/*
		C�digo	Descri��o
		3M	Trimestre
		6M	Semestre
		CD	Dias do Calend�rio (incluindo fins-de-semana e feriados)
		D	Dia
		H	Hora
		M	M�s
		W	Semana
		WD	Dias �teis (excluindo fins-de-semana e feriados)
		Y	Ano
		*/
		// Tipo de Per�odo
		cRefPer := AllTrim(SubStr(cLinha, 12, 3))
		
		// Quantidade Per�odo
		cQtPer := AllTrim(SubStr(cLinha, 15, 3))
		
		// Data Vencimento (Quando Fixa)
		cDtVenc := SubStr(cLinha, 18, 8)
		
		if (cRefDT == "1")
			cMsgPed += "Vencimento com base na data do pedido. "
		elseif (cRefDT == "66")
			cMsgPed += "Vencimento em " + SubStr(cDtVenc, 7) + "/" + SubStr(cDtVenc, 5, 2) + "/" + SubStr(cDtVenc, 1, 4)
		endIf
		
		// Valor a Pagar
		cValPag := AllTrim(SubStr(cLinha, 26, 15))
		
		// Percentual a Pagar do Valor Faturado
		cPercPag := AllTrim(SubStr(cLinha, 41, 5))
		if Val(cPercPag) == 0
			cPercPag := ""
		endIf
		
	elseif (SubStr(cLinha, 1, 2) == "03")
		// Descontos
		// N�o efetuado, verificar caso seja necess�rio
		cMsgPed += chr(13) + chr(10) + "Verificar descontos do pedido"
	elseif (SubStr(cLinha, 1, 2) == "04")
		
		// Produtos
		if !(Len(aCols) == 1 .And. Empty(aCols[1,2]))
			AADD(aCols,Array(Len(aHeader)+1))
		endIf		
		nACols := Len(aCols)
		/*For nI := 2 To Len(aHeader)
			aCols[nACols][nI] := CriaVar(aHeader[nI][2])
		Next*/
		aCols[nACols][Len(aHeader)+1] := .F.
		
		// Seta o campo de item
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEM"})
		aCols[nACols, nPos] := StrZero(nACols, Len(SC6->C6_ITEM))
		
		// N�mero Seq�encial da Linha de Item
		cItem := SubStr(cLinha, 3, 4)
		
		// N�mero do Item no Pedido
		cStr := SubStr(cLinha, 7, 5)
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEMPC"})
		
		if (nPos > 0) .And. cStr != "00000"
			aCols[nACols, nPos] := cStr
		EndIf
		
		// Seta o pedido de compra na parte de itens
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_NUMPCOM"})
		aCols[nACols, nPos] := cPedComp
		
		// Qualificador de Altera��o
		cAltItem := SubStr(cLinha, 12, 3)
		
		// Tipo de C�digo do Produto
		cTpCod := SubStr(cLinha, 15, 3)
		lProd := .F.
		// C�digo do Produto
		cStr := SubStr(cLinha, 18, 14)
		SA7->(dbSetOrder(03))
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"})
		if SA7->(dbSeek(xFilial("SA7") + M->C5_CLIENTE + M->C5_LOJACLI + cStr))			
			aCols[nACols, nPos] := SA7->A7_PRODUTO
			SB1->(dbSetOrder(01))
			SB1->(dbSeek(xFilial("SB1") + SA7->A7_PRODUTO))
			lProd := .T.
		else
		  cProduto2 := Space(Len(SB1->B1_COD))
			If MsgYesNo('Atencao, produto '+cStr+' n�o encontrado na amarra��o prod. x Cliente. Deseja incluir?' )
				@ 65,153 To 229,600 Dialog oDlgPrd Title OemToAnsi("Inclus�o Amarra��o")
				@ 7,9 Say OemToAnsi("Prod: " + cStr)
				@ 19,9 Say OemToAnsi("Selecione o Produto")
				@ 28,9 Get cProduto2 Picture "@!" F3 "SB1" VALID Existcpo("SB1",cProduto2) Size 59,10
				@ 62,39 BMPBUTTON TYPE 1 ACTION Close(oDlgPrd)
				
				Activate Dialog oDlgPrd Centered
			endIf					
			If !Empty(cProduto2)
				SA7->(dbSetOrder(01))
				RecLock("SA7",!SA7->(dbSeek(xFilial("SA7") + M->C5_CLIENTE + M->C5_LOJACLI + cProduto2)))
				SA7->A7_FILIAL 	:= xFilial("SA7")
				SA7->A7_CLIENTE 	:= M->C5_CLIENTE
				SA7->A7_LOJA 	:= M->C5_LOJACLI
				SA7->A7_CODCLI   := cStr
				SA7->A7_PRODUTO  := cProduto2
				SA7->(MsUnlock())
				aCols[nACols, nPos] := cProduto2
			else
				aCols[nACols, nPos] := cStr			
			Endif
			N := len(aCols)
		endIf 
		
		// Chama gatilhos de preenchimento
		RUNTRIGGER(2,N,, "C6_PRODUTO")
		
		SB1->(dbSetOrder(01))
		SB1->(dbSeek(xFilial("SB1") + aCols[nACols, nPos]))
		
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_DESCRI"})
		aCols[nACols, nPos] := SB1->B1_DESC
		
		A410Produto(SB1->B1_COD,.T.)
		
		// Refer�ncia do Produto
		//cRefProd := SubStr(cLinha, 72, 20)
		
		// Unidade de Medida
		cUnMed := SubStr(cLinha, 92, 3)
		
		// N�mero Unidades Consumo na Embalagem Pedida
		cNumUnMed := SubStr(cLinha, 95, 5)
		
		// Quantidade Pedida
		cQtdPed := SubStr(cLinha, 100, 15)
		
		nPosQt := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_QTDVEN"})
		if Val(cNumUnMed) > 0
			aCols[nAcols, nPosQt] := (Val(cQtdPed) / 100) * Val(cNumUnMed)
		else
			aCols[nAcols, nPosQt] := (Val(cQtdPed) / 100)
		endIf
		
		// Quantidade Bonificada
		cQtdBon := SubStr(cLinha, 115, 15)
		
		// Quantidade Troca
		//cQtdTr := SubStr(cLinha, 130, 15)
		
		// Tipo de Embalagem
		//cTpEmb := SubStr(cLinha, 145, 3)
		
		// N�mero de Embalagens
		cNumEmb := SubStr(cLinha, 148, 5)
		
		// Valor Bruto Linha Item
		cStr := SubStr(cLinha, 153, 5)
		
		// Valor L�quido Linha Item
		//cStr := SubStr(cLinha, 168, 5)
		
		// Pre�o Bruto Unit�rio
		cStr := SubStr(cLinha, 183, 15)
		
		nPosTot := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_VALOR"})
		aCols[nAcols, nPosTot] := Val(cStr) / 100 * (Val(cQtdPed) / 100)
		
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRCVEN"})
		
		// Prc Uni = Total / Quantidade
		aCols[nACols, nPos] := aCols[nAcols, nPosTot] / aCols[nAcols, nPosQt]
		
		// Pre�o L�quido Unit�rio
		cPrcLiq := SubStr(cLinha, 198, 15)
		
		// Base do Pre�o Unit�rio
		cBsPrcUn := SubStr(cLinha, 213, 5)
		
		// Unidade de Medida da Base do Pre�o Unit�rio
		cUMPrcUn := SubStr(cLinha, 218, 3)
		
		// Valor Unit�rio do Desconto Comercial
		cDesUnCo := SubStr(cLinha, 221, 15)
		
		// Percentual do Desconto Comercial
		cPerDes := SubStr(cLinha, 236, 5)
		
		// Valor Unit�rio do IPI
		cValIPI := SubStr(cLinha, 241, 15)
		
		// Al�quota de IPI
		//cStr := SubStr(cLinha, 256, 5)
		
		//if Val(cStr) > 0
		//	nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_NUMPCOM"})
		//	aCols[nACols, nPos] := cPedComp		
		//endIf
		
		// Valor Unit�rio da Despesa Acess�ria Tributada
		//cVlDeAT := SubStr(cLinha, 261, 15)
		
		// Valor Unit�rio da Despesa Acess�ria N�o Tributada
		//cVlDeAN := SubStr(cLinha, 276, 15)
		
		// Valor de Encargo de Frete
		//cVlEnFrt := SubStr(cLinha, 291, 15)
		
		// Valor Pauta 306, 7
		
		// C�digo RMS do Item 313, 8
		
		// C�digo NCM 321, 10
		
		
		
	elseif (SubStr(cLinha, 1, 2) == "09")
		// Sum�rio, finaliza o pedido
	endIf	
	FT_FSKIP()
EndDo
FT_FUSE()

M->C5_OBSPED := cMsgPed
Return

/*���������������������������������������������������������������������������������
�����������������������������������������������������������������������������������
�������������������������������������������������������������������������������Ŀ��
���Fun��o    |  PesqCGC   �Autor � Paulo Bindo                 |Data � 30/01/12 ���
�������������������������������������������������������������������������������Ĵ��
���Descri�ao | Funcao pesquisa no SM0 para qual empresa/filial � destinado a NFe���
�������������������������������������������������������������������������������Ĵ��
���Parametros� clCGC = CNPJ informado no arquivo XML                            ���
�������������������������������������������������������������������������������Ĵ��
���Retorno   � alRet = Array de 2 posicoes                                      ���
���          | 		[ 1 ] = COD. EMPRESA                                        ���
���          | 		[ 2 ] = COD. FILIAL                                         ���
�������������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                         ���
��������������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������������
���������������������������������������������������������������������������������*/
Static Function PesqCGC(clCGC)
Local alAreaSM0
Local aCodEmpFil:= {}

dbSelectArea("SM0")
alAreaSM0 := SM0->(GetArea())
dbGoTop()
Do While !eof() .and. !Empty(clCGC)
	If SM0->M0_CGC = clCGC
		aAdd(aCodEmpFil, {SM0->M0_CODIGO, SM0->M0_CODFIL})
		exit
	Endif
	dbSkip()
Enddo
RestArea(alAreaSM0)
Return aCodEmpFil

// Faz a amarra��o de produto x cliente conforme foi confirmado na inclus�o do pedido
Static Function AtuTabSA7()
Alert("Faz a amarra��o")
Return

// Retorna o alias do cabe�alho
/*Static Function C5Imp()
Local aRet := {}
Local nX
For nX := 1 to M->(fCount())
	aAdd(aRet, {M->(FieldName(nX)), M->(FieldGet(nX)), Nil})
Next nX
Return aRet*/

// Retorna os itens do pedido
/*Static Function C6Imp()
Local aRet := {}
Local aLinha := {}
Local nX
For nCol := 1 to Len(aCols)
	if !aCols[nCol, Len(aHeader) + 1] 
		aLinha := {}
		For nX := 2 to Len(aHeader)
			aAdd(aLinha, {aHeader[nX, 2], aCols[nCol, nX], Nil})
		Next nX
		aAdd(aRet, aLinha)
	endIf	
Next nCol
Return aRet*/