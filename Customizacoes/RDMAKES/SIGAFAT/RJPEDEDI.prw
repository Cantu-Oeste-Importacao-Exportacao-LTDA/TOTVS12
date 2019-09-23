#Include "Protheus.ch"
#Include "TopConn.ch"
#Include "rwmake.ch"
#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJPEDEDI  ºAutor  ³FV SISTEMAS - FLAVIO  Data ³  27/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Importação de pedidos do EDI Neogrid para o sistema        º±±
±±º          ³ As pastas devem ser configuradas através de parâmetros     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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
cPathPed := cGetFile( "*", "Diretório de Importação Neogrid", 1, cPathPed, .T., GETF_RETDIRECTORY  + GETF_LOCALHARD, .T.)
MakeDir(cPathPed + "old\")

aFiles := Directory(cPathPed +"*.txt")
For nFileImp := 1 to Len(aFiles)
	cFileImp := cPathPed + aFiles[nFileImp,1]
	cFileMov := cPathPed + "old\" + aFiles[nFileImp,1]
	
	// valida a primeira linha para importação e troca da filial
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
		MsgAlert("Não há filial cadastrada com o cnpj " + cStr + ". Pedido não será importado." + chr(13) + chr(10) + "Arquivo: " + cFileImp)
	else
		MsgInfo("Arquivo " + cFileImp + " refere-se a empresa " + aEmp[1] + ". Deverá efetuada a importação na empresa correta.")
	endIf
Next nX

Return

// usa o ponto de entrada para alimentar as variáveis na tela, se chamado pela rotina de inclusão
User Function M410INIC()
if IsIncallStack("U_RJPEDEDI")
	ImpPed(cFileImp)	
endIf
Return

/*User Function MT410INC()
// Grava a amarração de produtos
if IsIncallStack("U_RJPEDEDI")
	
endIf
Return*/

// Faz a importação do pedido da Neogrid no Protheus
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

// Faz a importação conforme o layout
FT_FUSE(cArquivo)
FT_FGOTOP()
While !FT_FEOF()
	cLinha := FT_FREADLN()
	if empty(cLinha)
		exit
	endIf
	if (SubStr(cLinha, 1, 2) == "01")
		// Cabeçalho
		cMsgPed := ""
		/*
		Registro 01 - CABEÇALHO (uma única ocorrência)	Obrig	Tipo	Tam	Dec	Início	Fim
		Tipo de Registro	S	AN	2		0	1
		Função Mensagem	S	AN	3		2	4
		Tipo de Pedido	S	AN	3		5	7
		Número do Pedido do Comprador	S	AN	20		8	27
		Número do Pedido do Sistema de Emissão	N	AN	20		28	47
		Data - Hora de Emissão do Pedido	S	N	12		48	59
		Data - Hora Inicial do Período de Entrega	S	N	12		60	71
		Data - Hora Final do Período de Entrega	S	N	12		72	83
		Número do Contrato	N	AN	15		84	98
		Lista de Preços	N	AN	15		99	113
		EAN de Localização do Fornecedor	S	N	13		114	126
		EAN de Localização do Comprador	S	N	13		127	139
		EAN de Localização de Cobrança da Fatura	S	N	13		140	152
		EAN de Localização do Local de Entrega	S	N	13		153	165
		CNPJ do Fornecedor	S	N	14		166	179
		CNPJ do Comprador	S	N	14		180	193
		CNPJ do Local da Cobrança da Fatura	S	N	14		194	207
		CNPJ do Local de Entrega	S	N	14		208	221
		Tipo de Código da Transportadora	N	AN	3		222	224
		Código da Transportadora	N	N	14		225	238
		Nome da Transportadora	N	AN	30		239	268
		Condição de Entrega (tipo de frete)	S	AN	3		269	271
		Seção do Pedido	S	N	3		272	274
		Observação do Pedido	S	AN	40		275	314
			*/
		
		/*Código	Descrição do Código
		9	Original (Transmissão Inicial)
		16	Proposta
		31	Cópia (Mensagem é cópia de original já enviado)
		42	Confirmação (pedido enviado por outros meios)
		46	Provisória
		*/
		cFuncMsg := Trim(SubStr(cLinha, 3, 3))
		/*Código	Descrição
		000	Pedido com condições especiais
		001	Pedido Normal
		002	Pedido de Mercadorias Bonificadas
		003	Pedido de Consignação
		004	Pedido Vendor
		005	Pedido Compror
		006	Pedido de Demonstração
		*/
		aTpPed := {{"000",	"Pedido com condições especiais"},;
				{"001", "Pedido Normal"},;
				{"002",	"Pedido de Mercadorias Bonificadas"},;
				{"003",	"Pedido de Consignação"},;
				{"004",	"Pedido Vendor"},;
				{"005",	"Pedido Compror"},;
				{"006",	"Pedido de Demonstração"}}
		cStr := Trim(SubStr(cLinha, 6, 3))
		if (cStr != "001")
			cMsgPed += "Tipo Pedido : " + aTpPed[aScan(aTpPed, {|x|x[1] == cStr}), 2] + cCLRF			
		endIf
		
		M->C5_TIPO := "N"
		
		// Número de pedido do comprador
		cPedComp := Trim(SubStr(cLinha, 9, 20)) // grava para a linha de itens
		M->C5_MENNOTA := PadR("Pedido do Cliente: " + cPedComp, Len(SC5->C5_MENNOTA))
		
		// Número de pedido no sistema de emissão
		// cPedEmis := Trim(SubStr(cLinha, 29, 20))
		// Data Emissão
		cStr := SubStr(cLinha, 49, 12)
		M->C5_EMISSAO := StoD(SubStr(cStr, 1, 8))
		
		// Entrega De
		cEntDe := SubStr(cLinha, 61, 12)
		
		// Entrega até
		cEntAte := SubStr(cLinha, 73, 12) 
		
		if !Empty(cEntAte)
			cMsgPed += "Entrega de : " + dToC(StoD(SubStr(cEntDe, 1, 8))) + " até " + dToC(StoD(SubStr(cEntAte, 1, 8))) + cCLRF
		endIf
		
		// Nro Contrato
		cStr := AllTrim(SubStr(cLinha, 85, 15))
		
		if !Empty(cStr)
			cMsgPed += "Contrato : " + cStr + cCLRF
		endIf
		
		// Lista de Preços
		//cLstPrc := AllTrim(SubStr(cLinha, 100, 15))
		
		// Cnpj Fornecedor
		// Já validado na entrada do arquivo
		//cStr := SubStr(cLinha, 167, 14)
		
		// Cnpj Comprador
		// verificar gatilhos
		cStr := SubStr(cLinha, 181, 14)
		SA1->(dbSetOrder(03))
		if SA1->(dbSeek(xFilial("SA1") + cStr))
			M->C5_CLIENTE := SA1->A1_COD
			cStr := SA1->A1_LOJA
			
			// Chama função de atualização dos dados do cliente
			A410Cli("M->C5_CLIENTE",M->C5_CLIENTE)
			RUNTRIGGER(1,,, "C5_CLIENTE")		
			
			M->C5_LOJACLI := cStr
			A410Loja("M->C5_LOJACLI", M->C5_LOJACLI)
		endIf
		
		
		// Cnpj Cobrança
		cStr := SubStr(cLinha, 195, 14)
		cMsgPed += "Cnpj Cobrança : " + cStr + cCLRF
		
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
		
		/*Código	Descrição
			1	Básico
			3	Data Fixa (Pagamento realizado na data ou período estipulado no pedido)
			20	Multa
			21	Pagamento Parcelado
			22	Desconto por Antecipação de Pagamento
			B01	Pagamento com Dias de Concentração
			JRM	Juros de Mora			
		*/
		// Tipo Vencimento
		cTpVenc := Trim(SubStr(cLinha, 3, 3))
		
		/*Código	Descrição
		1	Data do Pedido
		3	Data do Contrato
		5	Data da Fatura
		9	Data de Recebimento da Fatura
		21	Data de Recebimento das Mercadorias pelo Comprador
		66	Data Especificada (no campo Data de Vencimento)
		81	Data do Embarque (conforme documentos de transporte)
		*/		
		// Referência da Data
		cRefDT := AllTrim(SubStr(cLinha, 6, 3))
		
		/*Código	Descrição
		1	Na data de referência
		3	Após data de referência
		4	Final do período de dez dias contendo a data de referência (fora a dezena)
		5	Final do período de duas semanas contendo a data de referência (fora duas semanas)
		6	Final do mês contendo a data de referência (fora o mês)
		10	Final da semana contendo a data de referência (fora a semana)
		10E	Final da quinzena contendo a data de referência (fora quinzena)
		*/
		// Referencia de Tempo da Data
		cRefTp := AllTrim(SubStr(cLinha, 9, 3))
		
		/*
		Código	Descrição
		3M	Trimestre
		6M	Semestre
		CD	Dias do Calendário (incluindo fins-de-semana e feriados)
		D	Dia
		H	Hora
		M	Mês
		W	Semana
		WD	Dias Úteis (excluindo fins-de-semana e feriados)
		Y	Ano
		*/
		// Tipo de Período
		cRefPer := AllTrim(SubStr(cLinha, 12, 3))
		
		// Quantidade Período
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
		// Não efetuado, verificar caso seja necessário
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
		
		// Número Seqüencial da Linha de Item
		cItem := SubStr(cLinha, 3, 4)
		
		// Número do Item no Pedido
		cStr := SubStr(cLinha, 7, 5)
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_ITEMPC"})
		
		if (nPos > 0) .And. cStr != "00000"
			aCols[nACols, nPos] := cStr
		EndIf
		
		// Seta o pedido de compra na parte de itens
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_NUMPCOM"})
		aCols[nACols, nPos] := cPedComp
		
		// Qualificador de Alteração
		cAltItem := SubStr(cLinha, 12, 3)
		
		// Tipo de Código do Produto
		cTpCod := SubStr(cLinha, 15, 3)
		lProd := .F.
		// Código do Produto
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
			If MsgYesNo('Atencao, produto '+cStr+' não encontrado na amarração prod. x Cliente. Deseja incluir?' )
				@ 65,153 To 229,600 Dialog oDlgPrd Title OemToAnsi("Inclusão Amarração")
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
		
		// Referência do Produto
		//cRefProd := SubStr(cLinha, 72, 20)
		
		// Unidade de Medida
		cUnMed := SubStr(cLinha, 92, 3)
		
		// Número Unidades Consumo na Embalagem Pedida
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
		
		// Número de Embalagens
		cNumEmb := SubStr(cLinha, 148, 5)
		
		// Valor Bruto Linha Item
		cStr := SubStr(cLinha, 153, 5)
		
		// Valor Líquido Linha Item
		//cStr := SubStr(cLinha, 168, 5)
		
		// Preço Bruto Unitário
		cStr := SubStr(cLinha, 183, 15)
		
		nPosTot := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_VALOR"})
		aCols[nAcols, nPosTot] := Val(cStr) / 100 * (Val(cQtdPed) / 100)
		
		nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRCVEN"})
		
		// Prc Uni = Total / Quantidade
		aCols[nACols, nPos] := aCols[nAcols, nPosTot] / aCols[nAcols, nPosQt]
		
		// Preço Líquido Unitário
		cPrcLiq := SubStr(cLinha, 198, 15)
		
		// Base do Preço Unitário
		cBsPrcUn := SubStr(cLinha, 213, 5)
		
		// Unidade de Medida da Base do Preço Unitário
		cUMPrcUn := SubStr(cLinha, 218, 3)
		
		// Valor Unitário do Desconto Comercial
		cDesUnCo := SubStr(cLinha, 221, 15)
		
		// Percentual do Desconto Comercial
		cPerDes := SubStr(cLinha, 236, 5)
		
		// Valor Unitário do IPI
		cValIPI := SubStr(cLinha, 241, 15)
		
		// Alíquota de IPI
		//cStr := SubStr(cLinha, 256, 5)
		
		//if Val(cStr) > 0
		//	nPos := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_NUMPCOM"})
		//	aCols[nACols, nPos] := cPedComp		
		//endIf
		
		// Valor Unitário da Despesa Acessória Tributada
		//cVlDeAT := SubStr(cLinha, 261, 15)
		
		// Valor Unitário da Despesa Acessória Não Tributada
		//cVlDeAN := SubStr(cLinha, 276, 15)
		
		// Valor de Encargo de Frete
		//cVlEnFrt := SubStr(cLinha, 291, 15)
		
		// Valor Pauta 306, 7
		
		// Código RMS do Item 313, 8
		
		// Código NCM 321, 10
		
		
		
	elseif (SubStr(cLinha, 1, 2) == "09")
		// Sumário, finaliza o pedido
	endIf	
	FT_FSKIP()
EndDo
FT_FUSE()

M->C5_OBSPED := cMsgPed
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    |  PesqCGC   ³Autor ³ Paulo Bindo                 |Data ³ 30/01/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao | Funcao pesquisa no SM0 para qual empresa/filial é destinado a NFe³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ clCGC = CNPJ informado no arquivo XML                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ alRet = Array de 2 posicoes                                      ³±±
±±³          | 		[ 1 ] = COD. EMPRESA                                        ³±±
±±³          | 		[ 2 ] = COD. FILIAL                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/
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

// Faz a amarração de produto x cliente conforme foi confirmado na inclusão do pedido
Static Function AtuTabSA7()
Alert("Faz a amarração")
Return

// Retorna o alias do cabeçalho
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