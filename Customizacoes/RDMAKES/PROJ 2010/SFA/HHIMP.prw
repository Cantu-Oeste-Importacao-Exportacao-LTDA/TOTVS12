/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ HHHC5PRE            ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Modulo de Pedidos        					 			                  ³±±
±±³			     ³ Adiciona campos de saldo para gravar pedido                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SFA CRM 8.0                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Flavio     ³ 09/07/10 Tratamento de ICMS ST para alguns produtos      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HHHC5PRE()
Local aCab		:= PARAMIXB[1]
Local aItens	:= PARAMIXB[2]
Local aRet		:= {}
Local i, cTpConv, nFatConv
Local aArea := GetArea()
Local cLocal := ""
Local lPrcTab := SuperGetMV("MV_PRCTABP", ,.F.)  // parametro que aramazena se deve zerar o preço de tabela qdo vem do palm
Local cTesForaUF := ""
Local lUfDif := .F.
Local cUFsST := ""
Local cTesST := ""
Local cUFCli := ""
Local cTesCP := ""
Local cUFsCP := ""
Local cCliLoja := ""
Local cProd := ""
Local lMudaTCli := .F.
Local lLibPed := SuperGetMV("MV_X_PSFAL", , .T.)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("SC6")
HC6->(DbSetOrder(1))
Conout("Ponto de Entrada HHHC5PRE")
HC6->(DbSeek(AllTrim(HC5->HC5_FILIAL + HC5->HC5_ID + HC5->HC5_COTAC)))
               
// busca o cliente e a loja
cCliLoja := HC5->HC5_CLI + HC5->HC5_LOJA

ConOut("Cliente + Loja = " + cCliLoja)

cUFCli := Posicione("SA1", 01, xFilial("SA1") + cCliLoja, "A1_EST")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

for i:= 1 to len(aItens)
	// Obtém o local do item do pedido e para localizar o mesmo na tabela z22
	cLocal := HC6->HC6_LOCAL
	/*********************************************/
	// Controle de alteração de tes automaticamente, 
	// para venda fora do estado, deve ser trocado a tes pela
	// tes cadastrada no campo b1_tsufdif, quando informada
	
	DbSelectArea("SB1")
	dbSetOrder(01)
	dbSeek(xFilial("SB1") + AllTrim(HC6->HC6_PROD))
	
	// obtém o fator de conversão, a ser usado logo abaixo, na conversão para a segunda unidade.
	nFatConv := Iif(SB1->B1_TIPCONV == "M", 1 / SB1->B1_Conv, SB1->B1_Conv)
	
	// Flavio - 02-01-2011
	// alterado para buscar estas configuracoes da tabela ZZA ao invez do produto	                    
	
	BEGINSQL alias "ZZATMP"
		SELECT ZZA_PRODUT, ZZA_GRUPO, ZZA_TESUFD, ZZA_TESST, ZZA_UFSST, ZZA_TESCRP, ZZA_UFSCRP FROM %TABLE:ZZA% ZZA
		WHERE ZZA_FILIAL = %XFILIAL:ZZA%
		AND (ZZA_GRUPO = %EXP:SB1->B1_GRUPO% OR ZZA_PRODUT = %EXP:SB1->B1_COD%)
		AND %NOTDEL%
		ORDER BY ZZA_PRODUT, ZZA_GRUPO
	ENDSQL
	
/*	ZZA->(dbSetOrder(01))
	lFound := ZZA->(dbSeek(xFilial("ZZA") + SB1->B1_COD)) // por produto
	
	if !lFound // por grupo
		ZZA->(dbSetOrder(02))
		lFound := ZZA->(dbSeek(xFilial("ZZA") + SB1->B1_GRUPO)) 
	endIf*/
	
	While ZZATMP->(!Eof())
		//if (lFound)
		cTesForaUF := ZZATMP->ZZA_TESUFD
		cTesST := ZZATMP->ZZA_TESST
		cUFsST := ZZATMP->ZZA_UFSST
		cTesCP := ZZATMP->ZZA_TESCRP
		cUFsCP := ZZATMP->ZZA_UFSCRP
		//EndIf
		
		ConOut("Avalia mudança de TES " + cTesForaUF + " Produto : " + HC6->HC6_PROD)
		
		if !lUfDif
			ConOut("UF do cliente igual da empresa")
		EndIF	
		
		// Altera a tes caso a mesma tenha sido informada e a venda é para fora do estado.
		If lUfDif .And. !Empty(cTesForaUF)
			AADD(aItens[i],{"C6_TES",cTesForaUF,Nil})
			ConOut("Mudou a tes do produto " + AllTrim(HC6->HC6_PROD) + " para " + cTesForaUF)
		EndIf
		
		// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtos
		if (cUFCli $ cUFsST .And. !Empty(cTesST))
			lMudaTCli := .T.
			AADD(aItens[i],{"C6_TES",cTesST,Nil})
			ConOut("Mudou a tes do produto " + AllTrim(HC6->HC6_PROD) + " para " + cTesST)
		EndIf
		
		// Flavio - 03/05/2011
		// Alterado para operar com mais de uma configuracao por produto e tambem para tratar o crédito presumido
		// avalia a troca da tes no credito presumido
		if (cUFCli $ cUFsCP .And. !Empty(cTesCP))
			AADD(aItens[i],{"C6_TES",cTesCP,Nil})
			ConOut("Mudou a tes do produto " + AllTrim(HC6->HC6_PROD) + " para " + cTesCP)
		EndIf
		
		ZZATMP->(dbSkip())
		
	EndDo
	
	dbCloseArea("ZZATMP")
	
	// faz o cálculo de conversão da segunda unidade	
	/*if HC6->(FieldPos("HC6_UNSVEN")) > 0
		// só adiciona a segunda unidade se existir valor, para situações  de ter o campo e ter a versão antiga no palm
		AADD(aItens[i],{"C6_UNSVEN",Iif(HC6->HC6_UNSVEN > 0 .And. HC6->HC6_IMPUNI == "2", HC6->HC6_UNSVEN, HC6->HC6_QTDVEN / nFatConv),Nil})
		// seta a primeria unidade, devido a alterar a segunda
		AADD(aItens[i],{"C6_QTDVEN",Iif(HC6->HC6_UNSVEN > 0 .And. HC6->HC6_IMPUNI == "2", HC6->HC6_UNSVEN * nFatConv, HC6->HC6_QTDVEN),Nil})
	EndIf*/
	
	// Teste para alterar o valor dos produtos da filial 11 de pneumatico, 
	// devido a ser necessário reduzir o valor de IPI dos produtos vendidos pelo palm
	// se for filial 11 e venda de pneu, desconta o valor do IPI e nao usa segunda unidade
	/*if (HC6->HC6_FILIAL == "11") .And. (HC6->HC6_GRUPO $ "0023/0038/0040")
	  ReduzValIPI(aItens[i])
	  
	// uso de segunda unidade de medida, para hortifruti e outros
	Elseif (HC6->(FieldPos("HC6_PRCSU")) > 0) 
  	// só adiciona a segunda unidade se existir valor, para situações  de ter o campo e ter a versão antiga no palm
		AADD(aItens[i],{"C6_PRCSU",Iif(HC6->HC6_PRCSU > 0 .And. HC6->HC6_IMPUNI == "2", HC6->HC6_PRCSU, HC6->HC6_PRCVEN * nFatConv),Nil})
		// seta a primeira unidade, devido a alterar a segunda		
		// Tem que adicionar novamente o campo, independente de ele já existir,
    // pois se alterar o conteúdo do campo existente vai dar erro ao inserir o pedido no SC6
		AADD(aItens[i],{"C6_PRCVEN",Iif(HC6->HC6_PRCSU > 0 .And. HC6->HC6_IMPUNI == "2", HC6->HC6_PRCSU / nFatConv, HC6->HC6_PRCVEN),Nil})	  
	EndIf*/
	
	// verifica se o campo existe
  /*if HC6->(FieldPos("HC6_IMPUNI")) > 0
		// só adiciona a segunda unidade se existir valor, para situações  de ter o campo e ter a versão antiga no palm
		AADD(aItens[i],{"C6_IMPUNI",Iif(HC6->HC6_IMPUNI == "2", "2", "1"),Nil})		  
	EndIf*/
	
	/**********************************************************************
	 Controle para o preço de tabela, removendo o mesmo do campo c6_prunit e gravando no c6_prctab
	 removendo também o valor do desconto
	 Ajustes necessários devido a aparecer desconto no faturamento, na NF eletronica
	 **********************************************************************/
	// se estiver configurado para zerar o desconto no pedido que vem pelo palm, zera os campos
	if lPrcTab
		AADD(aItens[i],{"C6_PRUNIT",0,Nil})
		// joga o preço de tabela no campo C6_PRCTAB
		AADD(aItens[i],{"C6_PRCTAB",HC6->HC6_PRUNIT,Nil})
		// zera o percentual de desconto
		AADD(aItens[i],{"C6_DESCONT",0,Nil})
	EndIf
	
	// Seta se o pedido deve vir como liberado ou nao
	if !lLibPed // Por padrao vem como liberado, caso precise vir sem liberacao tem que adicionar zero na quantidade liberada
		AADD(aItens[i],{"C6_QTDLIB",0,Nil})
	EndIf
		
	/**********************************************/
	// Parte de fazer o backup dos dados que vem do palm para comparar com os dados que ficaram efetivos no pedido
	
	DbSelectArea("SZE")
	DbSetOrder(02)
	// Localiza se o registro existe nos dados de importação do palm, se existir apenas atualiza, senao insere o registro
	if (DbSeek(xFilial("SZE") + HC5->HC5_ID + HC5->HC5_COTAC + AllTrim(HC6->HC6_PROD)))
		RecLock("SZE", .F.)
	Else
		RecLock("SZE", .T.)
		SZE->ZE_FILIAL := xFilial("SZE")
		SZE->ZE_VEND := HC5->HC5_ID
		SZE->ZE_COTAC := HC5->HC5_COTAC
		SZE->ZE_CLIENTE := HC5->HC5_CLI
		SZE->ZE_LOJA := HC5->HC5_LOJA
		SZE->ZE_LOCAL := HC6->HC6_Local
		SZE->ZE_PROD := HC6->HC6_PROD	  
	  // campos Adicionados
	EndIf
	
	// alterado para setar a data base, para a data do pedido no sze ficar na mesma data do SC6500
	SZE->ZE_EMISSAO := dDataBase
	SZE->ZE_SLDSFA := HC5->HC5_SLDSFA
	SZE->ZE_QTDVEN := HC6->HC6_QTDVEN
	SZE->ZE_PRCTAB := HC6->HC6_PRUNIT
	SZE->ZE_PRCVEN := HC6->HC6_PRCVEN
	
	MsUnlock()
	// Fim da parte de backup dos dados		
	
	HC6->(dbSkip())
Next
              
// Avalia se deve mudar o tipo do cliente para Solidário no pedido de venda, situacao de tratamento de icms solidário
if (lMudaTCli)
	AADD(aCab,{"C5_TIPOCLI","S",Nil})
EndIf

AADD(aCab,{"C5_SLDSFA",HC5->HC5_SLDSFA,Nil})

// Verificar para buscar a configuracao da tabela Z22
cClVl := ""
dbSelectArea("Z22")
dbSetOrder(01)
dbSeek(xFilial("Z22") + HC5->HC5_ID)
While (xFilial("Z22") + HC5->HC5_ID == Z22->Z22_FILIAL + Z22->Z22_CODVEN)
	if (Z22->Z22_ARMAZ == cLocal)
		cClVl := Z22->Z22_CODCVL
		Exit
	EndIf
	Z22->(dbSkip())
EndDo

Z22->(dbCloseArea())

if Empty(cClVl)
	ConOut("Não sincronizado por não ter segmento informado na tabela Z22")
EndIf

// Seta a classe de valor conforme o armazém da venda do item no sfa
AADD(aCab,{"C5_X_CLVL",cClVl,Nil})

aRet := {aCab,aItens}

RestArea(aArea)

Return aRet

/*************************************************************
 Função que deduz o valor do IPI do preço vendido do produto, 
 pois no caso do Pneu, é fechado com o cliente o preço final
 e depois é deduzido o valor do IPI do preço de venda.
 Uso: Filial 11, venda de Pneu para Consumidor Final apenas
 ************************************************************/
/*Static Function ReduzValIPI(aItem)
Local nPosFil := aScan(aItem, {|x| x[1] == "C6_FILIAL"})
Local nPosItem := aScan(aItem, {|x| x[1] == "C6_PRODUTO"})
Local nPosPreco := aScan(aItem, {|x| x[1] == "C6_PRCVEN"})
Local cGrupo := ""
Local nIpi := 0
Local i
Local nPreco := 0
ConOut("Reduz valor do IPI")
If HC6->HC6_FILIAL == "11"
  // De acordo com o grupo é um percentual de IPI a ser descontado do valor
  nIpi:= Posicione("SB1", 01, HC6->HC6_FILIAL + HC6->HC6_PROD, "B1_IPI")
  cGrupo := HC6->HC6_GRUPO
  ConOut("Pos Preco: " + str(nPosPreco, 6, 2))
  ConOut("Grupo " + cGrupo)
  ConOut("IPI " + Str(nIpi, 3, 0))
  ConOut("Preço atual : " + Str(aItem[nPosPreco, 2], 9, 2))
  if (cGrupo $ "0023/0038/0040")
    if nIpi == 15
      nPreco := aItem[nPosPreco, 2] * 0.8695652174

    Elseif nIpi == 2
      nPreco := aItem[nPosPreco, 2] * 0.9803921569
    EndIf
    // tem que adicionar novamente o campo, independente de ele já existir, 
    // pois se alterar o conteúdo do campo existente vai dar erro ao inserir o pedido no SC6
    aAdd(aItem, {"C6_PRCVEN", Round(nPreco, 4), Nil})
	EndIf
EndIf
Return*/