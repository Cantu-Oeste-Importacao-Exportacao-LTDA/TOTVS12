#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONT_PRECO_VENDAºAutor ³Eder Gasparin  º Data ³  10/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE na finalização do pedido de venda	 					  º±±
±±º          ³ Sempre que finaliza o pedido o sistema armazena no campo	  º±±
±±º          ³ C5_SLDPED a diferença entre o valor de venda e o valor de  º±±
±±º          ³ tabela dos produtos vendidos. Isso para cada pedido.		  º±±
±±º          ³ Esse campo e atualizado somente na venda com digitacao	  º±±
±±º          ³ manual. Na venda por palm o campo alimentado e o C5_SLDSFA º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico cliente CANTU                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA410T()
Local funcao := funName()
Local lRet := .T.
Local cArm := ""
Local cVend := ""
Local lZeraPrc := SuperGetMV("MV_PRCTABS", ,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If FindFunction("U_USORWMAKE")
	U_USORWMAKE(ProcName(),FunName())
EndIf

DbSelectArea("DA1")
DA1->(DbSetOrder(1)) // FILIAL, CODIGO DA TABELA E CODIGO DO PRODUTO
DA1->(DbGoTop())
if AllTrim(funcao) == "MATA410" .And. (Inclui .Or. Altera) //verifica se é na inclusao do pedido, pra q não seja chamado em outras rotinas
	cVend := M->C5_VEND1
	nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
	nPosPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"}) // para obter qual a posição do campo no acols do preco de venda.
	nPosPrUnit := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"}) // para obter qual a posição do campo no acols do preco de tabela.
	nPosQtde   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"}) // para obter qual a posição do campo no acols da quantidade vendida.
	nPosArm    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"}) // para obter qual a posição do campo no acols do armazém do produto.
	nPosPrcTab := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCTAB"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosDescto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosDescVl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosVlOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_VLORI"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	
	SE4->(dbSetOrder(01))
	SE4->(dbSeek(xFilial("SE4") + M->C5_CONDPAG))
	
	nReaj := SE4->E4_REAJUST
	
	nPrcVen:=0
	nPrUnit:=0
	saldo:=0
	for i:=1 to len(acols)
		DA1->(DbGoTop())
		nProduto := acols[i, nPosProduto] // codigo do produto
		nPrcVen  := nPrcVen  + acols[i,nPosPrcVen]  //preco de venda
		DbSelectArea("DA1")
		DA1->(DbSetOrder(01))
		// Validar para buscar o campo reajuste da condicao de pagamento e aplicar o indice sobre o preco atual do produto
		if DbSeek(xFilial("DA1") + M->C5_TABELA + AllTrim(nProduto)) //posiciona na tabela de precos
			
			if (SubStr(M->C5_X_CLVL, 1, 3) = "005") // Venda de Pneus
				// calcula o valor unitario do item de acordo com o percentual de rajuste aplicado na condicao de pagamento para o pneu
				nPrUnit := DA1->DA1_PRCVEN * ( 1 + (nReaj / 100))
			else
				nPrUnit := DA1->DA1_PRCVEN // obtém o valor sem o reajuste
			EndIf
			
			// seta o preço de tabela caso tenha sido alterado
			if (nPosPrcTab > 0)
				if (acols[i,nPosPrcTab] != nPrUnit)
					acols[i,nPosPrcTab] := nPrUnit
				EndIf
			EndIf
		else
			nPrUnit := 0
		endif
		
		// limpa a coluna padrao de preço unitário e desconto, se estiver configurado
		if lZeraPrc
			acols[i,nPosPrUnit] := 0
			acols[i,nPosDescto] := 0
			acols[i,nPosDescVl] := 0
		EndIf
		
		nQtde := acols[i,nPosQtde] //qtde vendida
		
		if !(aCols[i,Len(aHeader)+1]) // verifica se a linha esta excluida, somente utiliza as linhas ativas
			saldo := saldo + ((nPrcVen-nPrUnit)*nQtde)
		endIf
		
		nPrcVen:=0
		nPrUnit:=0
		nQtde:=0
		nDesc := 0
		
		cArmaz := aCols[i, nPosArm]
		
		SZA->(dbSetOrder(01))
		
		if SZA->(dbSeek(xFilial("SZA") + cArmaz))
			nDesc := SZA->ZA_DESCSYN
			nDesc := nDesc / 100
		EndIf
		
		// aCols[i][nPosVFlex] :=  (aCols[i,nPosPrcTab] * (1 - nDesc))  - (aCols[i, nPosPrcVen])
		
		// grava o preco original quando o pedido for digitado manualmente, na inclusao somente
		if INCLUI .Or. (SUBSTR(M->C5_X_CLVL, 1, 3) != '005')
			aCols[i][nPosVlOri] := aCols[i, nPosPrcVen] * aCols[i][nPosQtde]
		EndIf
	Next
	SC5->C5_SLDPED:=saldo
endIf
Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
//³ Função para permitir ou não a inclusão do pedido de venda,                         ³
//³ validando apenas para o armazém 05.                                                ³
//³ ----------------------------------------------------------                         ³
//³ Flavio - 10/03/09                                                                  ³
//³ Adicionado validaçao de preço para o Pneu, nao permitindo desconto maior           ³
//³ do que a estipulada no parametro MV_DESMPNR para os produtos.                      ³
//³ Quando informado maior é solicitado senha para gravação do pedido.                 ³
//³ -----------------------------------------------------------                        ³
//³ Flavio - 05/11/09                                                                  ³
//³ Adicionado validacao no campo C6_CLASFIS para impedir o faturamento de um item     ³
//³ quando está faltando a origem ou o cst da TES.                                     ³
//³ Feito validação devido a ocorrer problemas na transimissao da NFe, sendo necessário³
//³ excluir a NF, alterar o pedido e faturar novamente.                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
*-----------------------*
User Function MT410TOK()
*-----------------------*
Local lRet 			:= .T.
Local aErrCalc 		:= {}
Local nValVend 		:= 0
Local nValTab  		:= 0
Local cArm 			:= ""
Local cVend 		:= M->C5_VEND1
Local nOpc 			:= ParamIxb[1]
Local nOpcInc 		:= 3
Local nPerMax 		:= SuperGetMV("MV_DESMPNR",,10)
Local cTesNC 		:= SuperGetMV("MV_TESNCP",,"740/636")
Local lValCfop 		:= SuperGetMV("MV_VALCFO",,.F.)
Local lZeraPrc 		:= SuperGetMV("MV_PRCTABS", ,.F.)
Local lSim3g 		:= iif(SC5->(FieldPos("C5_SIM3G")) > 0, M->C5_SIM3G, .F.)
Local lSim3GM		:= iif(SC5->(FieldPos("C5_SIM3GM")) > 0, M->C5_SIM3GM, .F.)
Local leEco			:= iif(SC5->(FieldPos("C5_X_EECO")) > 0, M->C5_X_EECO, .F.)
Local lB2BVertis	:= iif(SC5->(FieldPos("C5_X_IB2B")) > 0, M->C5_X_IB2B=="S", .F.)
Local lValCst  		:= SuperGetMV("MV_VLDOCST", ,.T.)
Local nPVlOri 		:= 0             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If FindFunction("U_USORWMAKE")
	U_USORWMAKE(ProcName(),FunName())
EndIf	

//Gustavo - 01/04/2014 17:09
//Quando for pedido de complemento de ICMS, ou complemento de preço não deve passar pelo 
//ponto de entrada para executar o padrão e gravar o pedido com a quantidade zerada.
If M->C5_TIPO == "I" .or. M->C5_TIPO == "C"
	Return .T.
EndIf         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GUSTAVO - 23/04/15 - CHAMADA DO CALCULO DE VOLUMES CUSTOMIZADO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aErrCalc := {}
If FindFunction("U_CALCVOL")
	aErrCalc := U_CALCVOL(aHeader,aCols)     
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 23/04/15 - VALIDACAO PARAMETROS DO CADASTRO DOS VINHOS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	
	If Len(aErrCalc) > 0
		cStrErr := ""
		For nLin := 1 to Len(aErrCalc)
			cStrErr += "PRODUTO "+ Trim(aErrCalc[nLin][01]) +" "+ SuBStr(aErrCalc[nLin][02], 01, 30) +" "+ CHR(13)+CHR(10) + Trim(aErrCalc[nLin][03]) +" "+ CHR(13)+CHR(10)	
		Next nLin
		Aviso("Erro de parametrização do produto", cStrErr, {"Ok"}, 3)
		Return .F.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 23/04/15 - FIM DA VALIDACAO PARAMETROS DO CADASTRO DOS VINHOS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³GUSTAVO - 23/04/15 - FIM DA CHAMADA DO CALCULO DE VOLUMES CUSTOMIZADO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("DA1")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³FILIAL, CODIGO DA TABELA E CODIGO DO PRODUTO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

DA1->(DbSetOrder(1))
DA1->(DbGoTop())

SE4->(dbSetOrder(01))
SE4->(dbSeek(xFilial("SE4") + M->C5_CONDPAG))
nReaj := IIf(SE4->(FieldPos("F4_REAJUST"))!=0,SE4->E4_REAJUST,0)

if (SuperGetMV("MV_BLDPED",,.F.) == .T.) 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³verifica se é na inclusao do pedido, pra q não seja chamado em outras rotinas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Inclui .Or. Altera
		nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
		nPosPrcVen := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
		nPosPrUnit := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
		nPosQtde   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
		nPosArm    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_LOCAL"})
		nPosTes    := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
		nPosPrcTab := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCTAB"})
		nPosDescto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"})
		nPosDescVl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
		nPVlOri   	:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_VLORI"})
		
		nPrcVen:=0
		nPrUnit:=0
		saldo:=0
		
		for i:=1 to len(acols)
			DA1->(DbGoTop())
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¢
			//³Código do Produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¢
			
			nProduto := acols[i, nPosProduto]
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³preco de venda³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			nPrcVen  := nPrcVen  + acols[i,nPosPrcVen]
			DbSelectArea("DA1")
			
			if lSim3g .or. lSim3GM .or. leEco .or. lB2BVertis
				nPrUnit := acols[i,nPosPrcTab]
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ
				//³posiciona na tabela de precos³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂ
				
			elseif DbSeek(xFilial("DA1") + M->C5_TABELA + AllTrim(nProduto))
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Venda de Pneus³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				if (SubStr(M->C5_X_CLVL, 1, 3) = "005")
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄh¿
					//³calcula o valor unitario do item de acordo com o percentual de rajuste aplicado na condicao ³
					//³de pagamento para o pneu                                                                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄhÙ
					
					nPrUnit := DA1->DA1_PRCVEN * ( 1 + (nReaj / 100))
				else
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³obtém o valor sem o reajuste³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					
					nPrUnit := DA1->DA1_PRCVEN
				EndIf
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³seta o preço de tabela caso tenha sido alterado³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				
				if (acols[i,nPosPrcTab] != nPrUnit)
					acols[i,nPosPrcTab] := nPrUnit
				EndIf
			else
				nPrUnit := 0
			endif
			
			nQtde    := acols[i,nPosQtde] //qtde vendida
			// verifica se a linha esta excluida, somente utiliza as linhas ativas
			
			if !(aCols[i,Len(aHeader)+1]) .And. !(aCols[i, nPosTes] $ cTesNC) // tes que nao sao consideras para desconto
				saldo := saldo + ((nPrcVen-nPrUnit)*nQtde)
				// Acumula a soma do total vendido e a soma do total
				if (nPrUnit > 0)
					nValVend += (nPrcVen * nQtde)
					nValTab += (nPrUnit * nQtde)
					cArm := aCols[i, nPosArm]
				EndIf
			endIf
			
			nPrcVen := 0
			nPrUnit := 0
			nQtde := 0
			nDesc := 0
			cArmaz := aCols[i, nPosArm]
			
			SZA->(dbSetOrder(01))
			if SZA->(dbSeek(xFilial("SZA") + cArmaz))
				nDesc := SZA->ZA_DESCSYN
				nDesc := nDesc / 100
			EndIf
			
		Next
		
		/* GUSTAVO 16/11/16 - REGRA VÁLIDA APENAS PARA O PNEU		
		// toda a venda de pneu obedece a regra de desconto máximo de 16%        
		If ( Type("l410Auto") <> "U" .And. !l410Auto )
			if (SubStr(M->C5_X_CLVL, 1, 3) = "005") .And. (nValVend > 0)// venda de Pneus
				// filial 11 tem o desconto de IPI e ICMS ST sobre o preço de tabela
				nPerDesc := (1- (nValVend / nValTab)) * 100
				// MV_DESMPNR é o limite máximo, nao pode nunca exceder este valor sem a utilização de senha.
				// Se vier por SFA, nao valida o desconto
				if (nPerDesc > nPerMax) .And. (!lSim3g) .and. (!lSim3GM) .and. (!leEco) .and. (!lB2BVertis) 
					MsgInfo("O valor do desconto não pode execeder " + AllTrim(Str(nPerMax)) + " %. " + ;
					"Verifique os valores digitados ou solicite senha para seu superior!", "Atenção")
					lRet := ValSenha(cVend, Round(nPerDesc, 2))
				EndIf
			EndIf
		EndIf
		*/
	EndIf
EndIf

//verifica se é na inclusao do pedido, pra q não seja chamado em outras rotinas
if (Inclui .Or. Altera) .And. lRet .And. lValCfop
	// pedido normal
	nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
	nPosCF := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"}) // para obter qual a posição do campo no acols ser refere ao cfop.
	if M->C5_TIPO == 'N' .And. lRet
		lMesmaUF := (SM0->M0_ESTCOB == Posicione('SA1', 01,xFilial("SA1") + M->C5_CLIENTE +M->C5_LOJACLI, 'A1_EST'))
		for i:= 1 to Len(aCols)
			lRet := lRet .And. ((lMesmaUF .And. SubStr(aCols[i, nPosCF], 1, 1) == '5') .Or.;
			(!lMesmaUF .And. SubStr(aCols[i, nPosCF], 1, 1) != '5'))
			if (!lRet)
				Alert('Verifique o Cfop do produto ' + AllTrim(aCols[i, nPosProduto]) + '.')
				return lRet
			EndIf
		Next i
	EndIf
EndIf

// Validação da origem e do cst da tes, para que se algum deles estiver em branco nao permitir salvar o pedido
if (Inclui .Or. Altera) .And. lRet .And. lValCst
	// pedido normal
	nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
	nPosClasFi := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	for i:= 1 to Len(aCols)
		cClasFis := aCols[i, nPosClasFi]
		cOrigem := AllTrim(SubStr(cClasFis, 1, 1))
		cCSt := AllTrim(SubStr(cClasFis, 2, 2))
		lRet := lRet .And. (cOrigem != "" .And. cCst != "")
		if (!lRet)
			if (cOrigem == "")
				Alert('Origem do produto ' + AllTrim(aCols[i, nPosProduto]) + ' não informada. Verifique com o responsável pelo cadastro.')
			elseif(cCst == "")
				Alert('CST da TES não informada para o produto ' + AllTrim(aCols[i, nPosProduto]) + '. Verifique com o responsável pela TES.')
			EndIf
			Return lRet
		EndIf
	Next i
EndIf 

// parte do controle de zerar o preço de tabela para evitar que seja gerado desconto
if (Inclui .Or. Altera) .And. lRet .And. lZeraPrc
	nPosProduto:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
	nPosPrUnit := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"}) // para obter qual a posição do campo no acols do preco de tabela.
	nPosPrcTab := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCTAB"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosDescto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCONT"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosDescVl := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	nPosVFlex  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_SFLEX"}) // para obter qual a posição do campo no acols do Preco de tabela a ser gravado o valor.
	
	for i:=1 to len(acols)
		nProduto := acols[i, nPosProduto] // codigo do produto
		// se vem pelo sim3g nao calcula preço unitário, já está calculado
		if lSim3g .or. lSim3GM .or. leEco .or. lB2BVertis 
			nPrUnit := acols[i,nPosPrcTab]
		elseif DbSeek(xFilial("DA1") + M->C5_TABELA + AllTrim(nProduto)) //posiciona na tabela de precos
			// nPrUnit := DA1->DA1_PRCVEN // para obter o valor de tabela
			
			if (SubStr(M->C5_X_CLVL, 1, 3) = "005") // Venda de Pneus
				// calcula o valor unitario do item de acordo com o percentual de rajuste aplicado na condicao de pagamento para o pneu
				nPrUnit := DA1->DA1_PRCVEN * ( 1 + (nReaj / 100))
			else
				nPrUnit := DA1->DA1_PRCVEN // obtém o valor sem o reajuste
			EndIf
			
			// seta o preço de tabela caso tenha sido alterado
			if (nPrUnit > 0) .and. (acols[i,nPosPrcTab] != nPrUnit)
				acols[i,nPosPrcTab] := nPrUnit
			EndIf
		else
			nPrUnit := 0
		endif
		
		// limpa a coluna padrao de preço unitário e desconto, se estiver configurado
		acols[i,nPosPrUnit] := 0
		acols[i,nPosDescto] := 0
		acols[i,nPosDescVl] := 0
		
	Next
EndIf
aArea := GetArea()
// valida se o vendedor do pedido existe cadastro de vendedores da filial
SA3->(dbSetOrder(01))
lVendOK := SA3->(dbSeek(xFilial("SA3") + M->C5_VEND1))

RestArea(aArea)
// valida se o vendedor está bloqueado
if lVendOK
	lVendOK := SA3->A3_MSBLQL <> "1"
EndIf

if !(lVendOk)
	Alert('Verifique o vendedor ' + AllTrim(M->C5_VEND1) + ' pois o mesmo não está cadastrado na filial atual.')
	lRet := .F.
EndIf

// atualiza data e hora de alteração do pedido

if SC5->(FieldPos("C5_DTHRALT") > 0)
	M->C5_DTHRALT := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
EndIf

if (lRet)
	lRet := ValVendSeg()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³faz a chamada para reduzir o valor do ST e IPI na inclusão do Item via SFA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if (lRet)
	CalcImpos()
EndIf

Return lRet


/* GUSTAVO 16/11/16 - REGRA VÁLIDA APENAS PARA O PNEU
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Funçao para pedir senha quando desconto for maior do que 10% para o Pneu.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function ValSenha(cVend, nDesc)
Local oDlgKey
Local cKey     := Space(5)
Local cCodVend := cVend
Local cCodArm  := "05"
Local nSaldo   := 0
Local nPDesc   := 0

Private lSenhaOK := .F.

DEFINE MSDIALOG oDlgKey TITLE "Liberar desconto do pedido" FROM 150,270 TO 390,520 OF GetWndDefault() PIXEL

@ 010,010 SAY "Vendedor: " PIXEL OF oDlgKey
@ 010,065 SAY cCodVend PIXEL OF oDlgKey

@ 024,010 SAY "Armazem: " PIXEL OF oDlgKey
@ 024,065 SAY cCodArm  PIXEL OF oDlgKey

@ 038,010 SAY "Descto do Armazem:  -" PIXEL OF oDlgKey
@ 038,065 SAY nDesc Picture "999999.99" PIXEL OF oDlgKey

@ 050, 010 SAY "Data Atual: " + DtoC(Date()) PIXEL OF oDlgKey

@ 057, 010 SAY "Obtenha a senha com seu gerente e informe abaixo." PIXEL OF oDlgKey

@ 071,010 SAY "Chave:" PIXEL OF oDlgKey
@ 069,050 MSGET cKey SIZE 55,10 PIXEL OF oDlgKey

@ 100,040 BMPBUTTON TYPE 1 ACTION (fGetSenh(cCodVend,cCodArm,nDesc,cKey, oDlgKey),oDlgKey:Refresh())
@ 100,070 BMPBUTTON TYPE 2 ACTION Close(oDlgKey)

ACTIVATE MSDIALOG oDlgKey CENTERED

Return lSenhaOK


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Função que valida a senha e retorna verdadeiro ou falso, de acordo com o conteúdo da mesma³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fGetSenh(cCodVend,cCodArm,nPDesc,cKeyUsr, oDlgKey)

Local cKey 		:= ""
Local cKey2   := ""
Local cData   := DtoS(Date())
Local nDia   	:= Val(SubSTR(cData,7,2))
Local nMes  	:= Val(SubSTR(cData,5,2))
Local cSaldo  := ""
Local nValor 	:= 0
Local nDescMax := 99
Local nSaldo := nPDesc

cSaldo := AllTrim(Str(Iif(nSaldo > 0,nSaldo, nSaldo * (-1)) * 1000))

if (nDia < 10)
	nDia += 30
EndIf

if (nMes < 10)
	nMes += 11
EndIf

cSaldo := AllTrim(Str(Val(cSaldo) + Val(AllTrim(cCodArm))))

cKey := Str(nMes) + cSaldo + AllTrim(Str(nDia))
cKey := AllTrim(cKey)
cKey := StrZero(Val(cKey), 10)
cTmp := cKey
cKey := AllTrim(Str(val(SubStr(cTmp, 1, 1)) + val(SubStr(cTmp, 3, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 2, 1)) + val(SubStr(cTmp, 5, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 6, 1)) + val(SubStr(cTmp, 4, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 8, 1)) + val(SubStr(cTmp, 10, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 9, 1)) + val(SubStr(cTmp, 7, 1))))
if len(cKey) > 5
	cKey := SubStr(cKey, Len(cKey) - 4, 5)
EndIf

cKey := AllTrim(cKey)

while (len(cKey) < 5)
	cKey := "0" + cKey
EndDo

lSenhaOk := (cKey == cKeyUsr)
if (!lSenhaOK)
	Alert("Senha incorreta! Verifique as informações digitadas!", "Atenção")
Else
	MsgInfo("Senha Correta!", "Validar Senha")
	Close(oDlgKey)
EndIf

Return


Static Function fGetSen2(cCodVend,cCodArm,nSaldo,nPDesc,cKey, lDescM)

Local cKey 		:= ""
Local cKey2   := ""
Local cData   := DtoS(Date())
Local nDia   	:= Val(SubSTR(cData,7,2))
Local nMes  	:= Val(SubSTR(cData,5,2))
Local cSaldo  := ""
Local nValor 	:= 0
Local nDescMax := 99

/*****************************************************
Parte de validação para o Pneu, armazém 05
****************************************************
if (cCodArm == "05")
	// Pneu só libera senha por percentual
	nSaldo := 0
	
	nDescMax := SuperGetMV("MV_DESMPNE")
	
	if (nPDesc == 0)
		Alert("Para o armazém 05 só pode ser gerada senha pelo percentual de desconto!")
		Return
	EndIf
	
	if (nPDesc > nDescMax) .And. (!lDescM)
		Alert("Desconto acima de " + AllTrim(STR(nDescMax)) + "% só poderá ser efetuado pela diretoria." + ;
		chr(13) + chr(10) + "Informe-se com seu superior.")
		Return
	EndIf
EndIf

// caso nao tenha saldo, calcula pelo desconto informado
if nSaldo <= 0
	nSaldo := nPDesc
EndIf

cSaldo := AllTrim(Str(Iif(nSaldo > 0,nSaldo, nSaldo * (-1)) * 1000))

if (nDia < 10)
	nDia += 30
EndIf

if (nMes < 10)
	nMes += 11
EndIf

cSaldo := AllTrim(Str(Val(cSaldo) + Val(AllTrim(cCodArm))))

cKey := Str(nMes) + cSaldo + AllTrim(Str(nDia))
cKey := AllTrim(cKey)
cKey := StrZero(Val(cKey), 10)
cTmp := cKey
cKey := AllTrim(Str(val(SubStr(cTmp, 1, 1)) + val(SubStr(cTmp, 3, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 2, 1)) + val(SubStr(cTmp, 5, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 6, 1)) + val(SubStr(cTmp, 4, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 8, 1)) + val(SubStr(cTmp, 10, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 9, 1)) + val(SubStr(cTmp, 7, 1))))
if len(cKey) > 5
	cKey := SubStr(cKey, Len(cKey) - 4, 5)
EndIf

cKey := AllTrim(cKey)

while (len(cKey) < 5)
	cKey := "0" + cKey
EndDo

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M410LIOKºAutor  ³Jean           º Data ³  04/03/13   	      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada na Validação da Linha do Pedido de Venda³ º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M410LIOK(uPar)
Local lOk := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³CFOP de Deterioração³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Local cCFDet := "5927"

Local nPosCFO := 0
Local nPosPrc := 0
Local nPosLoc := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica a posição dos campos na planilha³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nPosCFO := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_CF"})
nPosPrc := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRCVEN"})
nPosLoc := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_LOCAL"})
nPosPro := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"})
nPosTes := aScan(aHeader, {|x| AllTrim(x[2]) == "C6_TES"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If FindFunction("U_USORWMAKE")
	U_USORWMAKE(ProcName(),FunName())
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Verifica se o CFOP utilizado é de deterioração.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if AllTrim(aCols[n, nPosCFO]) == cCFDet
	
	DbSelectArea("SB2")
	SB2->(DbSetOrder(1))
	If SB2->(DbSeek(xFilial("SB2") + aCols[n, nPosPro] + aCols[n, nPosLoc]))
		if aCols[n, nPosPrc] < SB2->B2_CM1
			lOk := .F.
			Alert("O produto "+ AllTrim(aCols[n, nPosPro]) +" não pode ser incluído com valor unitário menor que o custo "+;
			"para a operação de deterioração."+CHR(13)+CHR(10)+;
			"Custo do produto: R$ "+ AllTrim(Transform(SB2->B2_CM1,"@E 999,999,999.99")))
		EndIf
	EndIf
	
EndIf

//Gustavo 11/06/2014 - Não permitir que seja utilizada uma TES que gere financeiro quando for transferência entre filiais
For nI := 1 to len(aCols)
 	dbSelectArea("SF4")
 	dbSetOrder(1)
 	dbGoTop()
 	If dbSeek( xFilial("SF4") + aCols[nI][nPosTes] )
		If SF4->F4_DUPLIC == "S" .And. AllTrim(M->C5_CLIENTE) == AllTrim(SUBSTR(SM0->M0_CGC,1,8)) .And. !SF4->F4_CODIGO $ SuperGetMV("MV_X_TESTR",.F.,"")
			lOk := .F.
			ShowHelpDlg("Atenção",{"Não é possível fazer transferência entre filiais com TES que movimente financeiro."}, 5,{"Verifique a TES informada."}, 5)
		EndIf			  
	EndIf
Next nI
//Gustavo 11/06/2014 - Fim
Return lOk

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funçao criada para que seja armazenada a data da exclusao de um pedido³
//³ que será sincronizado no SFA                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function A410EXC()
Local lOk := .T.                 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
If FindFunction("U_USORWMAKE")
	U_USORWMAKE(ProcName(),FunName())
EndIf

if SC5->(FieldPos("C5_DTHRALT") > 0)
	RecLock("SC5", .F.)
	SC5->C5_DTHRALT := DToS(dDataBase) + ' ' + Substr(Time(), 1, 5)
	SC5->(MsUnlock())
EndIf

lOk := U_ValPedFrt(SC5->C5_NUM)

If lOk 
	If SC5->C5_X_IB2B == "S" .and. FunName() != "RJFATB2B"
		Aviso("Pedido B2B","Pedido incluído pela integração B2B Vertis, para excluí-lo deverá ser alterado o status deste pedido para cancelado pela rotina de Pedidos B2B.",{"OK"})
		lOk := .F.
	EndIf
EndIf

Return lOk


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³MA410Impos³ Autor ³ Eduardo Riera         ³ Data ³06.12.2001 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ma410Impos()                                                 ³±±
±±³          ³Funcao de calculo dos impostos contidos no pedido de venda   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta funcao efetua os calculos de impostos (ICMS,IPI,ISS,etc)³±±
±±³          ³com base nas funcoes fiscais, a fim de possibilitar ao usua- ³±±
±±³          ³rio o valor de desembolso financeiro.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function CalcImpos()

Local aArea		:= GetArea()
Local aFisGet	 := {}
Local aFisGetSC5:= {}
Local aEntr     := {}

Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nPCodPro  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPVlOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_VLORI"})
Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0
Local nPosCpo   := 0
Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local dDataCnd  := M->C5_EMISSAO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pode ser forçado a fazer o cálculo quando o valor é digitado manualmente com o preço que o vendedor repassa³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDescIpi  := SuperGetMv("MV_X_FCIPI", ,.F.) .Or. M->C5_SIM3G .Or. M->C5_SIM3GM .or. M->C5_X_EECO .or. M->C5_X_IB2B=="S"

if !Inclui .Or. (SubStr(M->C5_X_CLVL, 1, 3) != '005') .Or. !cDescIpi
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca referencias no SC6³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca referencias no SC5³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Inicializa a funcao fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MaFisSave()
MaFisEnd()
MaFisIni(M->C5_CLIENTE,;								// 1-Codigo Cliente/Fornecedor
M->C5_LOJAENT,;												// 2-Loja do Cliente/Fornecedor
IIf(M->C5_TIPO$'DB',"F","C"),;				// 3-C:Cliente , F:Fornecedor
M->C5_TIPO,;													// 4-Tipo da NF
M->C5_TIPOCLI,;												// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aCols)
		
		nQtdPeso := 0
		
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
			
			nItem++
			
			If nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aCols[nX][nPNfOri]) .And. !Empty(aCols[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPNfOri]+aCols[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][nPCodPro]+aCols[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					Endif
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o preco de lista                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			nValMerc  := aCols[nX][nPTotal]
			nPrcLista := NoRound(nValMerc/aCols[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])
			nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")
			nDesconto := 0
			nPrcLista += nAcresFin
			nValMerc  += nDesconto
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Agrega os itens para a funcao fiscal         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			MaFisAdd(aCols[nX][nPProduto],;   	// 1-Codigo do Produto ( Obrigatorio )
			aCols[nX][nPTES],;	   						// 2-Codigo do TES ( Opcional )
			aCols[nX][nPQtdVen],;  						// 3-Quantidade ( Obrigatorio )
			nPrcLista,;		  									// 4-Preco Unitario ( Obrigatorio )
			0,; 															// 5-Valor do Desconto ( Opcional )
			"",;	   													// 6-Numero da NF Original ( Devolucao/Benef )
			"",;															// 7-Serie da NF Original ( Devolucao/Benef )
			nRecOri,;													// 8-RecNo da NF Original no arq SD1/SD2
			0,;																// 9-Valor do Frete do Item ( Opcional )
			0,;																// 10-Valor da Despesa do item ( Opcional )
			0,;																// 11-Valor do Seguro do item ( Opcional )
			0,;																// 12-Valor do Frete Autonomo ( Opcional )
			nValMerc,;												// 13-Valor da Mercadoria ( Obrigatorio )
			0)																// 14-Valor da Embalagem ( Opiconal )
		EndIf
		
	Next nX
EndIf

nValOri := 0 		// acumula o valor original dos itens, verificando se ao aplicar novamente o IPI vai ficar ok
nDesFin := 0 		// Desconto financeiro ou acréscimo, para fechar o valor dos itens com o pedido

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³faz o desconto do valor unitario com base no valor de icms retido, calculando proporcionalmente pelo valor do item e do total³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

For nX := 1 to Len(aCols)
	If !aCols[nX][Len(aHeader)+1]
		nValMerc  := aCols[nX][nPTotal]
		nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
		nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³obtém os valores de impostos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		nValIpi := MaFisRet(nX,"IT_VALIPI")
		nValSol := MaFisRet(nX,"IT_VALSOL")
		
		ConOut(Replicate("-", 80))
		
		ConOut("Produto " + AllTrim(aCols[nX][nPProduto]))
		ConOut("Valor Total " + AllTrim(Str(aCols[nX][nPTotal])))
		ConOut("Valor IPI " + AllTrim(Str(nValIpi)))
		ConOut("Valor Sub Trib " + AllTrim(Str(nValSol)))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Zera o preço de lista padrão do siga, para nao ocorrer erro³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		aCols[nX][nPPrUnit] := 0
		aCols[nX][nPVlOri] := aCols[nX, nPPrcVen] * aCols[nX][nPQtdVen]
		nValItem := Round((nValMerc * nValMerc) / (nValMerc + nValSol + nValIpi), 2)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄl
		//³calcula o preço unitario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄlÙ
		
		nValItem := nValItem / aCols[nX][nPQtdVen]
		
		ConOut("Valor Corrigido Unit " + AllTrim(Str(nValItem)))
		aCols[nX, nPPrcVen] := nValItem
		
		aCols[nX, nPTotal] := Round(nValItem * aCols[nX][nPQtdVen],2)
		ConOut("Valor Corrigido Tot " + AllTrim(Str(aCols[nX, nPTotal])))
		ConOut(Replicate("-", 80))
	EndIf
Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@¿
//³Faz o cálculo do desconto quando não vier pelo SIM3G³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@Ù

MaFisEnd()
RestArea(aArea)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a chamada do recalculo para acertar as diferencas de valores que ocorreram³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ReCalcImp()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Faz o recalculo do imposto depois de descoberto o valor unitario, para ficar o valor exato na NF.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
*---------------------------*
Static Function ReCalcImp()
*---------------------------*
Local aArea		:= GetArea()
Local aFisGet	 := {}
Local aFisGetSC5:= {}
Local aEntr     := {}

Local nPTotal   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local nPValDesc := aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
Local nPPrUnit  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
Local nPPrcVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
Local nPQtdVen  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
Local nPDtEntr  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
Local nPProduto := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPTES     := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
Local nPItemOri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
Local nPCodPro  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local nPVlOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_X_VLORI"})

Local nUsado    := Len(aHeader)
Local nX        := 0
Local nAcerto   := 0
Local nPrcLista := 0
Local nValMerc  := 0
Local nDesconto := 0
Local nAcresFin := 0
Local nQtdPeso  := 0
Local nRecOri   := 0
Local nPosEntr  := 0
Local nItem     := 0
Local nY        := 0
Local nPosCpo   := 0
Local cDescIpi  := SuperGetMv("MV_X_FCIPI", ,.F.) .Or. M->C5_SIM3G .Or. M->C5_SIM3GM .or. M->C5_X_EECO .or. M->C5_X_IB2B=="S"

Local lDtEmi    := SuperGetMv("MV_DPDTEMI",.F.,.T.)

Local dDataCnd  := M->C5_EMISSAO

if !(Inclui .And. cDescIpi)
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca referencias no SC6³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo

aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Busca referencias no SC5³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Inicializa a funcao fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

MaFisSave()
MaFisEnd()
MaFisIni(M->C5_CLIENTE,;						// 1-Codigo Cliente/Fornecedor
M->C5_LOJAENT,;										// 2-Loja do Cliente/Fornecedor
IIf(M->C5_TIPO$'DB',"F","C"),;		// 3-C:Cliente , F:Fornecedor
M->C5_TIPO,;											// 4-Tipo da NF
M->C5_TIPOCLI,;										// 5-Tipo do Cliente/Fornecedor
Nil,;
Nil,;
Nil,;
Nil,;
"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Agrega os itens para a funcao fiscal³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(aCols)
		
		nQtdPeso := 0
		
		If Len(aCols[nX])==nUsado .Or. !aCols[nX][nUsado+1]
			
			nItem++
			
			If nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(aCols[nX][nPNfOri]) .And. !Empty(aCols[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+aCols[nX][nPNfOri]+aCols[nX][nPSerOri]+M->C5_CLIENTE+M->C5_LOJACLI+aCols[nX][nPCodPro]+aCols[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					Endif
				Endif
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Calcula o preco de lista³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			
			nValMerc  := aCols[nX][nPTotal]
			nPrcLista := NoRound(nValMerc/aCols[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])
			nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")
			nDesconto := 0
			nPrcLista += nAcresFin
			nValMerc  += nDesconto
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Agrega os itens para a funcao fiscal³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			
			MaFisAdd(aCols[nX][nPProduto],;   	// 1-Codigo do Produto ( Obrigatorio )
			aCols[nX][nPTES],;	   						// 2-Codigo do TES ( Opcional )
			aCols[nX][nPQtdVen],;  						// 3-Quantidade ( Obrigatorio )
			nPrcLista,;		  									// 4-Preco Unitario ( Obrigatorio )
			0,; 															// 5-Valor do Desconto ( Opcional )
			"",;	   													// 6-Numero da NF Original ( Devolucao/Benef )
			"",;															// 7-Serie da NF Original ( Devolucao/Benef )
			nRecOri,;													// 8-RecNo da NF Original no arq SD1/SD2
			0,;																// 9-Valor do Frete do Item ( Opcional )
			0,;																// 10-Valor da Despesa do item ( Opcional )
			0,;																// 11-Valor do Seguro do item ( Opcional )
			0,;																// 12-Valor do Frete Autonomo ( Opcional )
			nValMerc,;												// 13-Valor da Mercadoria ( Obrigatorio )
			0)																// 14-Valor da Embalagem ( Opiconal )
		EndIf
		
	Next nX
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄX¿
//³Desconto financeiro ou acréscimo, para fechar o valor dos itens com o pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄXÙ

nDesFin := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³faz o desconto do valor unitario com base no valor de icms retido, calculando proporcionalmente pelo valor do item e do total³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if M->C5_SIM3G .or. M->C5_SIM3GM .or. M->C5_X_EECO .or. M->C5_X_IB2B=="S"
	For nX := 1 to Len(aCols)
		If !aCols[nX][Len(aHeader)+1]
			nValMerc  := aCols[nX][nPTotal]
			nAcresFin := A410Arred(aCols[nX][nPPrcVen]*M->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(aCols[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			//³obtém os valores de impostos³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ?
			
			nValIpi := MaFisRet(nX,"IT_VALIPI")
			nValSol := MaFisRet(nX,"IT_VALSOL")
			
			ConOut(Replicate("-", 80))
			ConOut("Valores Recalculados:")
			
			ConOut("-> Produto " + AllTrim(aCols[nX][nPProduto]))
			ConOut("-> Valor Total " + AllTrim(Str(aCols[nX][nPTotal])))
			ConOut("-> Valor IPI " + AllTrim(Str(nValIpi)))
			ConOut("-> Valor Sub Trib " + AllTrim(Str(nValSol)))
			ConOut("-> Valor Original " + AllTrim(Str(aCols[nX][nPVlOri])))
			ConOut("-> Valor Tot + Imposto " + AllTrim(Str(aCols[nX][nPTotal] + nValIpi + nValSol)))
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³adiciona o desconto financeiro a ser dado                                                ³
			//³valor que vai ficar menos o valor original, para dar a diferenca como desconto financeiro³
			//³Flavio - Removido o icms complementar                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			nDesFin +=  (nValMerc + nValIpi + nValSol) - aCols[nX][nPVlOri]
			
			ConOut(Replicate("-", 80))
		EndIf
		
	Next
	
	if (nDesFin > 0)
		M->C5_DESCONT := nDesFin
	EndIf
	
EndIf

MaFisEnd()
RestArea(aArea)
Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao para bloquear o pedido de venda quando nao encontrado ³
//³ dados na tabela zz5 de  vendedor x cliente x segmento        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*-----------------------------*
Static Function ValVendSeg()
*-----------------------------*
Local aAreaTMP 	:= GetArea()
Local nPOSARM 	:= aScan( aHeader, {|x| AllTrim(Upper(x[2])) == "C6_LOCAL" })
Local cCODARM 	:= ""
Local cMVBlqSeg := SuperGetMV("MV_X_SEGMO", , .F.)
Local cMVBlqArm := SuperGetMV("MV_X_SEARM", , .F.)
Local lOk 			:= .T.
Local cLocal 		:= ""
Local cClVl 		:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Se não tiver linha, pula a validação³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

if (n > Len(aCols))
	Return lOk
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³se nao efetua o bloqueio retorna sempre como ok, ou se nao for pedido de venda normal ou se vier pelo SIM3G³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !cMVBlqSeg .Or. M->C5_TIPO <> 'N' .Or. M->C5_SIM3G .Or. !(Inclui .Or. Altera) .or. M->C5_SIM3GM .or. M->C5_X_EECO .or. M->C5_X_IB2B=="S"
	Return .T.
EndIf

If !Empty(M->C5_VEND1) .and. !Empty(M->C5_X_CLVL)
	dbSelectArea("Z22")
	dbSetOrder(1)
	dbGoTop()
	lOk := dbSeek(xFilial("Z22") + M->C5_VEND1 + AllTrim(M->C5_X_CLVL))
	
	if !lOk
		Aviso("Aviso","Não foi localizado relacionamento de Armazém X Vendedor X Segmento (Z22) para os dados deste pedido!", {"OK"}, 2)
	EndIf
Else
	Aviso("Erro","Por favor informar os campos Vendedor e Segmento!", {"OK"}, 2)
	lOk := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso não valide o bloqueio de segmento, passa adiante³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If !cMVBlqArm
	Return lOk
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Flavio - 28/09/2011                   ³
//³Adicionado validação do armazém também³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cLocal := aCols[n, nPOSARM]
dbSelectArea("Z22")
dbSetOrder(01)
dbSeek(xFilial("Z22") + M->C5_VEND1)
While (xFilial("Z22") + M->C5_VEND1 == Z22->Z22_FILIAL + Z22->Z22_CODVEN) .And. !Eof()
	if (Z22->Z22_ARMAZ == cLocal)
		cClVl := Z22->Z22_CODCVL
		Exit
	EndIf
	Z22->(dbSkip())
EndDo

if Empty(cClVl) .Or. cClVl <> M->C5_X_CLVL
	lOk := .F.
	MsgBox("Verifique o segmento " + M->C5_X_CLVL + " pois não há dados de Vendedor X Segmento X Armazém cadastrados.", "Atenção")
	If MsgBox("Utilizar o segmento " + cClVl + " para o pedido?", "Atenção", "YESNO")
		M->C5_X_CLVL := cClVl
	EndIf
EndIf

RestArea(aAreaTMP)

Return lOk
