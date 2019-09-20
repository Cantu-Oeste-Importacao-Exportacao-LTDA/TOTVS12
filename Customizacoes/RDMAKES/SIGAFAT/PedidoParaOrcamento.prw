#Include "PROTHEUS.CH"
#Include "rwmake.ch"
/************************************************
 Função para transferir pedidos de venda para orçamento 
 de venda, a serem impressos diretamente no siga loja.
 
 Criar campo C5_OK caractere (2), contexto Virtual, Propriedade Alterar
 Usado para marcação apenas (nao cria fisicamente o banco de dados)
 ************************************************/
// Loja701(acab, aIte, 3) // inclusão dos valores na tabela
User Function Ped2OrcL()
Local aSL1 := {}
Local aSL2 := {}
Local aSL4 := {}
Local lOk 
Private cIndexName := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

lOk := SelSC5()

SC5->(DbGoTop())
While !(SC5->(Eof())) .And. lOk

	aSL1 := {}
	
	cNumOrc := CriaVar("L1_NUM")

	aAdd( aSL1, { "L1_FILIAL", 		xFilial("SL1") } )
	aAdd( aSL1, { "L1_EMISSAO", 	SC5->C5_EMISSAO } )
	aAdd( aSL1, { "L1_NUM",	 			cNumOrc } )
	aAdd( aSL1, { "L1_COMIS",			SC5->C5_COMIS1 } )
	aAdd( aSL1, { "L1_VEND2",     SC5->C5_VEND2 })
	aAdd( aSL1, { "L1_VEND3",     SC5->C5_VEND3 })
	aAdd( aSL1, { "L1_CLIENTE",		SC5->C5_CLIENTE } )
	aAdd( aSL1, { "L1_LOJA",			SC5->C5_LOJACLI } )
	aAdd( aSL1, { "L1_TIPOCLI",		SC5->C5_TIPOCLI } )
	aAdd( aSL1, { "L1_DESCONT",		SC5->C5_DESCONT + SC5->C5_DESCFI } ) // DESCONTO 1 + DESCONTO FINANCEIRO
//	aAdd( aSL1, { "L1_DESCNF",		0 } )
	aAdd( aSL1, { "L1_DTLIM",			dDataBase } )
//	aAdd( aSL1, { "L1_PARCELA",		0 } )
	aAdd( aSL1, { "L1_CONDPG",		SC5->C5_CONDPAG } )
//	aAdd( aSL1, { "L1_FORMPG",		"" )
	aAdd( aSL1, { "L1_CONFVEN",		"SSSSSSSSNSSS" } )
	aAdd( aSL1, { "L1_HORA",			Time() } )
	aAdd( aSL1, { "L1_TPFRET",		SC5->C5_TPFRETE } )
	aAdd( aSL1, { "L1_IMPRIME",	 	"1N" } )
//	aAdd( aSL1, { "L1_TIPODES", 	 } )         // ver o que por
//	aAdd( aSL1, { "L1_ESTACAO", 	cEstacao } ) // ver o que por
	aAdd( aSL1, { "L1_MOEDA", 	  SC5->C5_MOEDA } )	   
	aAdd( aSL1, { "L1_TXMOEDA", 	SC5->C5_TXMOEDA  } )// ver o que por	   
	   
	   
	aAdd( aSL1, { "L1_VEND", 	SC5->C5_VEND1 } )
	aAdd( aSL1, { "L1_FRETE", SC5->C5_FRETE	 } )
	aAdd( aSL1, { "L1_SEGURO", SC5->C5_SEGURO	 } )
	aAdd( aSL1, { "L1_DESPESA", SC5->C5_DESPESA	 } )
	aAdd( aSL1, { "L1_X_CLVL", SC5->C5_X_CLVL	 } )
	
	aSL2 := {} 	
	// adiciona os itens no pedido no array
	SC6->(DbSetOrder(01))
	SC6->(DbSeek(xFilial('SC6') + SC5->C5_NUM))
	while sc6->c6_filial + sc6->c6_num = sc5->c5_filial + sc5->c5_num
		//cItem := SomaIt( cItem )
		// usado devido a ser necessário passar assim
		aAdd( aSL2, {} )
		aAdd( aSL2[Len(aSL2)], { "L2_FILIAL", 	SC6->C6_FILIAL } )
		aAdd( aSL2[Len(aSL2)], { "L2_NUM", 		cNumOrc } )
		aAdd( aSL2[Len(aSL2)], { "L2_ITEM",		SC6->C6_ITEM } )
		aAdd( aSL2[Len(aSL2)], { "L2_PRODUTO",	SC6->C6_PRODUTO } )
		aAdd( aSL2[Len(aSL2)], { "L2_DESCRI", 	SC6->C6_DESCRI } )
		aAdd( aSL2[Len(aSL2)], { "L2_QUANT", 	SC6->C6_QTDVEN } )
		aAdd( aSL2[Len(aSL2)], { "L2_VRUNIT", 	SC6->C6_PRCVEN } )
		aAdd( aSL2[Len(aSL2)], { "L2_VLRITEM", 	SC6->C6_VALOR } )

		aAdd( aSL2[Len(aSL2)], { "L2_LOCAL", 	SC6->C6_LOCAL } )
		aAdd( aSL2[Len(aSL2)], { "L2_UM", 		SC6->C6_UM } )
		aAdd( aSL2[Len(aSL2)], { "L2_DESC", 	SC6->C6_DESCONT } )
		aAdd( aSL2[Len(aSL2)], { "L2_VALDESC", 	SC6->C6_VALDESC } )

		aAdd( aSL2[Len(aSL2)], { "L2_TES", 		SC6->C6_TES } )
		aAdd( aSL2[Len(aSL2)], { "L2_CF", 		SC6->C6_CF } )
		aAdd( aSL2[Len(aSL2)], { "L2_EMISSAO", 	SC5->C5_EMISSAO } )
		aAdd( aSL2[Len(aSL2)], { "L2_GRADE", 	"N" } )
		aAdd( aSL2[Len(aSL2)], { "L2_VEND",		SC5->C5_VEND1 } )
		aAdd( aSL2[Len(aSL2)], { "L2_TABELA",	SC5->C5_TABELA } )
		aAdd( aSL2[Len(aSL2)], { "L2_PRCTAB", 	0 } )
		// Flavio - Adicionar a informação do lote na importação do orçamento de venda.
		aAdd( aSL2[Len(aSL2)], { "L2_LOTECTL",SC6->C6_LOTECTL } )

		SC6->(DbSkip())
	EndDo		
	// Adiciona o pagamento, mas em branco
	aSL4 := {}
	aAdd( aSL4, {} )
	aAdd( aSL4[Len(aSL4)], { "L4_FILIAL",		xFilial("SL4") } )
	aAdd( aSL4[Len(aSL4)], { "L4_NUM", 			cNumOrc	} )
	aAdd( aSL4[Len(aSL4)], { "L4_DATA", 		dDataBase } )
	AAdd( aSL4[Len(aSL4)], { "L4_TROCO", 0 } )
	// faz a gravação do orçamento		
	lGrava := Lj7GrvOrc( aSL1, aSL2, aSL4, .T., .F. )[1]
	
	if (lGrava)
		// faz o estorno da liberação, deleta do sc5 o pedido e deleta do sc6 os itens
		ExcluiPed()
	EndIf
		
	SC5->(DbSkip())
EndDo
          
RetIndex("SC5")

fErase(cIndexName+OrdBagExt())
			
Return Nil

/***********************************
 Função responsável por mostrar os pedidos do sc5 e permitir a seleção de alguns deles
 ***********************************/
Static Function SelSC5()
Local lOk := .F.
Local cPerg := PadR("SC5SL1", len(sx1->x1_grupo))

ValidPerg(cPerg)
dbSelectArea("SC5")
dbSetOrder(01)
if Pergunte(cPerg)
	cIndexName := Criatrab(Nil,.F.)
	cIndexKey  := 	"C5_FILIAL+C5_NUM"
	cFilter    := 	"C5_EMISSAO >= STOD('" + DtoS(MV_PAR01) + "') .And. C5_EMISSAO <= STOD('" + ;
						DtoS(MV_PAR02) + "') .And. EMPTY(C5_NOTA) .And. " + ;
						"C5_VEND1 >= '" + MV_PAR03 + "' .And. C5_VEND1 <= '" + MV_PAR04 + "' .And. " + ;
						"C5_FILIAL == '" + xFilial("SC5") + "' .And. UPPER(SUBSTR(C5_MENNOTA, 1, 5)) = 'CUPOM'"
						
	IndRegua("SC5", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
	dbSelectArea("SE1")
	#IFNDEF TOP                     
		dbSetIndex(cIndexName + OrdBagExt())
	#ENDIF
	dbGoTop()	
  @ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecao de Pedidos"
  @ 001,001 TO 170,350 BROWSE "SC5" MARK "C5_OK"
  @ 180,310 BMPBUTTON TYPE 01 ACTION (lOk := .T.,Close(oDlg))
  @ 180,280 BMPBUTTON TYPE 02 ACTION (lOk := .F.,Close(oDlg))
  ACTIVATE DIALOG oDlg CENTERED
EndIf
Return lOk

Static Function ValidPerg(cPerg)

Private _sAlias := Alias()
Private aRegs   := {}
Private i,j

dbSelectArea("SX1")
dbSetOrder(1)

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Emissao de?          ","","","mv_ch1","D",08,00,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Emissao ate?         ","","","mv_ch2","D",08,00,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"03","Numero de?           ","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"04","Numero ate?          ","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Vendedor de?         ","","","mv_ch3","C",06,00,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Vendedor ate?        ","","","mv_ch4","C",06,00,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"07","Cliente de?          ","","","mv_ch9","C",06,00,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
//aAdd(aRegs,{cPerg,"08","Cliente ate?         ","","","mv_cha","C",06,00,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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

// faz o estorno dos itens e a exclusão dos mesmos também
Static Function ExcluiPed()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona Clientes                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA1")
dbSetOrder(1)
MsSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

nMCusto :=  If(SA1->A1_MOEDALC > 0, SA1->A1_MOEDALC, Val(SuperGetMv("MV_MCUSTO")))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Estorna o Item do Pedido de Venda                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SC6")
dbSetOrder(1)
MsSeek(xFilial("SC6")+SC5->C5_NUM)
While (SC5->C5_FILIAL + SC5->C5_NUM = SC6->C6_FILIAL + SC6->C6_NUM)

	dbSelectArea("SF4")
	dbSetOrder(1)
	MsSeek(xFilial("SF4")+SC6->C6_TES)

//	RecLock("SC6")

	If ( SF4->F4_ESTOQUE == "S" )
		dbSelectArea("SB2")
		dbSetOrder(1)
		MsSeek(xFilial( "SB2" ) + SC6->C6_PRODUTO + SC6->C6_LOCAL)

		RecLock("SB2")
		
		SB2->B2_QPEDVEN -= (SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE	)
		SB2->B2_QPEDVE2 -= ConvUM(SB2->B2_COD, SC6->C6_QTDVEN-SC6->C6_QTDENT-SC6->C6_QTDEMP-SC6->C6_QTDRESE, 0, 2)				
		MsUnLock()
	EndIf
	
	If ( SF4->F4_DUPLIC == "S" )
		nQtdVen := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
		If ( nQtdVen > 0 )
			RecLock("SA1")
			SA1->A1_SALPED -= xMoeda( nQtdVen * SC6->C6_PRCVEN , SC5->C5_MOEDA , nMCusto , SC5->C5_EMISSAO )
			MsUnLock()
		EndIf
	EndIf

	dbSelectArea("SC9")
	dbSetOrder(1)
	MsSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM)

	While ( !Eof() .And. SC9->C9_FILIAL == xFilial("SC9") .And.;
			SC9->C9_PEDIDO == SC6->C6_NUM .And.;
			SC9->C9_ITEM   == SC6->C6_ITEM )

		If ( SC9->C9_BLCRED <> "10"  .And. SC9->C9_BLEST <> "10" )
			Begin Transaction
				a460Estorna(.T.)
			End Transaction
		EndIf

		dbSelectArea("SC9")
		dbSkip()
	EndDo

	dbSelectArea("SC6")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava os lancamentos nas contas orcamentarias SIGAPCO    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	PcoDetLan("000100","02","MATA410")
	RecLock("SC6")
	dbDelete()		
	SC6->(DbSkip())
EndDo

// deleta do SC5
dbSelectArea("SC5")
RecLock("SC5")
dbDelete()

Return Nil