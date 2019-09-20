#include "rwmake.ch"
#include "protheus.ch"
#Include "DBTREE.CH"

User Function IMPCARR()

Private oImpPed
Static oDlg
Static oButton1
Static oButton2
Static oFont1 := TFont():New("Courier New",,016,,.F.,,,,,.F.,.F.)
Static oLocalArq
Static cLocalArq := Space(30)
Static oSay1
Static oGeraLog
Static lGeraLog := .F.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlg TITLE "Importação Pedidos NEOGRID" FROM 000, 000  TO 150, 410 COLORS 0, 16777215 PIXEL

@ 022, 004 SAY oSay1 PROMPT "Arquivo de Entrada" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 020, 058 MSGET oLocalArq VAR cLocalArq SIZE 141, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 048, 134 BMPBUTTON TYPE 01 ACTION OkImpPed()
@ 048, 053 BMPBUTTON TYPE 02 ACTION Close(oDlg)
@ 036, 058 CHECKBOX oGeraLog VAR lGeraLog PROMPT "Gerar Log de Importação?" SIZE 078, 008 OF oDlg COLORS 0, 16777215 PIXEL
ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function OkImpPed
nSeqRem := 0
cSeqLin	:= StrZero(1,6)
//Private nHdl := fCreate(AllTrim("D:\PedidoNeogrid.txt"))


Private cEOL := "CHR(13)+CHR(10)"
If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

//If nHdl == -1
//    MsgAlert("O arquivo "+mv_par02+".txt nao pode ser gravado!")
//    MsgAlert("O arquivo c:\pagtos_pao_de_acucar.txt nao pode ser gravado!")
//    Return
//Endif

/*Função da Barra de Status da Geração do Arquivo*/
Processa({|| RunCont() },"Processando...")
Return

Static Function RunCont

Local nTamLin, cLin, cCpo
nTamLin := 600
cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao
nSeqReg	:= 1


/* INICIANDO A LEITURA DO ARQUIVO */

if !FILE(AllTrim(cLocalArq)+".txt")
	Alert("Arquivo "+AllTrim(cLocalArq)+".txt"+" Inválido")
	Return
Else
	cFile := AllTrim(cLocalArq)+".txt"
EndIf

// Verifica parâmetro "Gera Log"
Private nHdl
if (lGeraLog == .T.)
	nHdl := fCreate(SubStr(AllTrim(cLocalArq),1,len(AllTrim(cLocalArq)))+".log")
EndIf

cContReg := 0
nTamLin := 125
aPed := {}
Aadd(aPed, {"PEDCLI",    "C", 20 , 0})
Aadd(aPed, {"TIPO",      "C", 01 , 0})
Aadd(aPed, {"TPPEDARQ",  "C", 01 , 0})
Aadd(aPed, {"CLIENTE",   "C", 09 , 0})
Aadd(aPed, {"LOJACLI",   "C", 04 , 0})
Aadd(aPed, {"CLIENT",    "C", 09 , 0})
Aadd(aPed, {"LOJAENT",   "C", 04 , 0})
Aadd(aPed, {"TRANSP",    "C", 05 , 0})
Aadd(aPed, {"TPCLI",     "C", 01 , 0})
Aadd(aPed, {"TPVENDA",   "C", 01 , 0})
Aadd(aPed, {"CONDPAG",   "C", 03 , 0})
Aadd(aPed, {"TABELA",    "C", 03 , 0})
Aadd(aPed, {"VEND1",     "C", 06 , 0})
Aadd(aPed, {"SEGMENTO",  "C", 09 , 0})
Aadd(aPed, {"MENSAGEM",  "C", 120, 0})
Aadd(aPed, {"EMISSAO",   "D", 06 , 0})
Aadd(aPed, {"MOEDA",     "C", 03 , 0})
Aadd(aPed, {"TPFRETE",   "C", 01 , 0})
Aadd(aPed, {"TPLIB",     "C", 01 , 0})
Aadd(aPed, {"TPCARGA",   "C", 01 , 0})
Aadd(aPed, {"DESCFIN",   "N", 05 , 2})
Aadd(aPed, {"DESCCOM",   "N", 05 , 2})
Aadd(aPed, {"DESCPROM",  "N", 05 , 2})

cArq := CriaTrab(aPed, .T.)
Use (cArq) Alias TMPPED Shared New

aItem := {}
Aadd(aItem, {"PEDCLI",   "C", 20 , 0})
Aadd(aItem, {"CLIENTE",  "C", 09 , 0})
Aadd(aItem, {"LOJACLI",  "C", 04 , 0})
Aadd(aItem, {"ITEM",     "C", 03 , 0})
Aadd(aItem, {"PRODUTO",  "C", 14 , 0})
Aadd(aItem, {"DESCPROD", "C", 40 , 0})
Aadd(aItem, {"QTDEPED",  "N", 10 , 2})
Aadd(aItem, {"QTDETRO",  "N", 10 , 2})
Aadd(aItem, {"UNMED",    "C", 02 , 0})
Aadd(aItem, {"PLIQUNI",  "N", 15 , 2})
Aadd(aItem, {"OPER",   	 "C", 03 , 0})
Aadd(aItem, {"IMPUNI", 	 "C", 01 , 0})

cItem := CriaTrab(aItem, .T.)
Use (cItem) Alias TMPITEM Shared New

cChave  := ""
cChaveItem := ""
nDesloc := ""
nPerPar := ""
aCab		:= {}
aCabPv  := {}
aItens	:= {}
aItensPv:= {}

DbSelectArea("SX3")
DbSetOrder(1)
MsSeek("SC5")

While !EOF() .and. SX3->X3_ARQUIVO == "SC5"
	If !(SX3->X3_CAMPO $ "C5_FILIAL") .and. cNivel >= SX3->X3_NIVEL .and. X3Uso(SX3->X3_USADO)
		AADD(aCab, SX3->X3_CAMPO)
	EndIf
	DbSkip()
End
aCabPv := aClone(aCab)

//MsgAlert("Parei Aqui aCabPv = "aCabPv())

DbSelectArea("SX3")
DbSetOrder(1)
MsSeek("SC6")

While !EOF() .and. SX3->X3_ARQUIVO == "SC6"
	If !(AllTrim(SX3->X3_CAMPO) $ "C6_FILIAL") .and. cNivel >= SX3->X3_NIVEL .and. X3Uso(SX3->X3_USADO)
		AADD(aItens, SX3->X3_CAMPO)
	EndIf
	DbSkip()
End
aItensPV := aClone(aItens)

dbSelectArea("TMPPED")

FT_FUse(cFile)
FT_FGOTOP()
ProcRegua(FT_FLastRec())
While !FT_FEof()
	cStr := FT_FReadln()
	cReg := SubStr(cStr,1,2)
	
	
		if cReg == "01"                               /* REGISTRO 01 - CABEÇALHO */
			cChave := AllTrim(SubStr(cStr,9,20))
			if (cChave <> TMPPED->PEDCLI)
				RecLock("TMPPED", .T.)
				TMPPED->TIPO			 := "N"
				TMPPED->TPPEDARQ	 := SubStr(cStr, 6, 3)
				TMPPED->TRANSP		 := " "
				TMPPED->EMISSAO    := dDataBase
				TMPPED->MOEDA			 := "1"
				TMPPED->TPLIB      := "1"
				TMPPED->TPCARGA	   := "1"
				TMPPED->CLIENTE    := SubStr(cStr,181,8)
				TMPPED->LOJACLI    := SubStr(cStr,189,4)
				// Valida se o cliente está cadastrado
				if Empty(Posicione("SA1", 1, xFilial("SA1") + TMPPED->CLIENTE + TMPPED->LOJACLI, "A1_COD"))
					Alert("O Cliente "+TMPPED->CLIENTE+" Loja "+TMPPED->LOJACLI+" não está cadastrado. O pedido será mostrado em tela,"+;
					" porém não será importado para o sistema.")
				EndIf
				TMPPED->CLIENT     := SubStr(cStr,209,8)
				TMPPED->LOJAENT    := SubStr(cStr,217,4)
				TMPPED->TPCLI			 := Posicione("SA1", 1, xFilial("SA1") + TMPPED->CLIENTE + TMPPED->LOJACLI, "A1_TIPO")
				TMPPED->TABELA		 := Posicione("SA1", 1, xFilial("SA1") + TMPPED->CLIENTE + TMPPED->LOJACLI, "A1_TABELA")
				TMPPED->TPVENDA    := "N"
				
				/* Mensagem que será impressa na NF (Período de Entrega)*/
				TMPPED->MENSAGEM	:= "Período Entrega: "+SubStr(cStr,67,2)+"/"+SubStr(cStr,65,2)+"/"+SubStr(cStr,61,4)+" "+;
				SubStr(cStr,69,2)+":"+SubStr(cStr,71,2)+"hs Até: "+;
				SubStr(cStr,67,2)+"/"+SubStr(cStr,65,2)+"/"+SubStr(cStr,61,4)+" "+SubStr(cStr,69,2)+":"+SubStr(cStr,71,2)+"hs"
				
				TMPPED->VEND1     := Posicione("SA1", 01, xFilial("SA1") + iif(!Empty(AllTrim(TMPPED->CLIENTE)), AllTrim(TMPPED->CLIENTE), 0), "A1_VEND")
				TMPPED->TPFRETE  	:= iif((AllTrim(SubStr(cStr,270,3)))=="CIF","C","F")
				TMPPED->PEDCLI  	:= AllTrim(SubStr(cStr,9,20))
			Else
				Alert("Chave "+cChave+" duplicada.")
			EndIf
		elseIf cReg == "02"	                            /* REGISTRO 02 - PAGAMENTO */
			
			//	Tipo 8 – o campo “Cond. Pagto.” Representa os dias de deslocamento e os percentuais de cada parcela na
			//	seguinte forma: [nn,nn,nn].[xx,xx,xx], onde :
			//	• [nn,nn,nn] – são os deslocamentos em dias a partir da data
			//	• [xx,xx,xx] – são os percentuais de cada parcela
			//	Os valores deverão ser separados por vírgula e a soma dos totais dos percentuais deve ser de 100%.
			
			if AllTrim(SubStr(cStr,3,3))=="21"
				cTpCond  := "8"
				if Empty(AllTrim(nDesloc))
					nDesloc := "["+CValToChar(Val(SubStr(cStr,15,3)))+"]"
					nPerPar := "["+CValToChar(Val(SubStr(cStr,41,5))/100)+"]"
				Else
					nDesloc := SubStr(nDesloc,1,Len(nDesloc)-1)+","+CValToChar(Val(SubStr(cStr,15,3)))+"]"
					nPerPar := SubStr(nPerPar,1,Len(nPerPar)-1)+","+CValToChar(Val(SubStr(cStr,41,5))/100)+"]"
				EndIf
				cCondPag := nDesloc+"."+nPerPar
				// MsgAlert("Tipo Cond do Ped.: "+cTpCond+" - Cond: "+cCondPag)
				
			ElseIf AllTrim(SubStr(cStr,3,3))=="1"
				// 	Tipo 1 – o campo “Cond. Pagto.” Indica o deslocamento em dias a partir da data base. Deve-se separar os valores por vírgula.
				//	Exemplo: Tipo – 1
				//	Condição: 00,30,60
				//	Os pagamentos serão efetuados da seguinte forma:
				//	- 1ª parcela à vista
				//	- 2ª parcela 30 dias
				//	- 3ª parcela 60 dias
				
				cTpCond := "1"
				if Empty(AllTrim(nDesloc))
					nDesloc := CValToChar(Val(SubStr(cStr,15,3)))
				Else
					nDesloc := SubStr(nDesloc,1,Len(nDesloc))+","+CValToChar(Val(SubStr(cStr,15,3)))
				EndIf
				cCondPag := nDesloc
				// MsgAlert("Tipo Cond do Ped.: "+cTpCond+" - Cond: "+cCondPag)
				
			ElseIf AllTrim(SubStr(cStr,3,3))=="3"
				/*	9 – essa condição é utilizada quando não há regras predeterminadas, sendo que o usuário poderá informar manualmente as
				parcelas e vencimentos no momento da venda. Desta forma, poderá compor os valores da forma como desejar. Essa opção
				é válida somente para Pedidos de venda e Orçamentos de venda.
				*/
				
				cTpCond := "9"
				nDesloc := "" 	// O Vencimento veio fixo no pedido.
				cCondPag := "" 	// Não tem condição de pagamento
			Else
				MsgInfo("Condição de Pagamento "+AllTrim(SubStr(cStr,3,3))+" não identificada no arquivo.")
			EndIf
			
			
		elseIf cReg == "03"														/* REGISTRO 03 - DESCONTOS E ENCARGOS */
			
			// Busca condição de pagamento do cliente, se existir.
			if Empty(Posicione("SA1", 1, xFilial("SA1") + TMPPED->CLIENTE + TMPPED->LOJACLI, "A1_CONDPAG"))
				
				// Se não encontrou condição no cliente, informa a condição de pagamento conforme veio no pedido.
				if !Empty(AllTrim(cCondPag))
					/*
					// Verifica se existe a condição de pagamento. Se não existe, cadastra.
					if Empty(Posicione("SE4", 2, xFilial("SE4") + cCondPag, "E4_CODIGO"))
					cod := 1
					
					// Procura por código que ainda não foi utilizado
					While(!Empty(Posicione("SE4", 1, xFilial("SE4") + CValToChar(StrZero(cod,3)), "E4_CODIGO")))
					cod += 1
					EndDo
					
					// Quando encontrou código válido, cadastra condição de pagamento
					RecLock("SE4", .T.)
					E4_FILIAL := xFilial("SE4")
					E4_CODIGO := CValToChar(StrZero(cod,3))
					E4_TIPO   := cTpCond
					E4_COND   := cCondPag
					E4_DESCRI := cCondPag+" - PEDIDOS NEOGRID"
					E4_IPI    := "N" // Normal - Distribuído entre as parcelas
					E4_DDD    := "D" // Data do Dia
					E4_ACRES  := "N" // Normal
					E4_MSBLQL := "2" // Não-bloqueada
					MsUnlock("SE4")
					
					TMPPED->CONDPAG := SE4->E4_CODIGO
					MsgInfo("Criado condição de pagamento: "+ TMPPED->CONDPAG) // Criar workflow
					Else
					TMPPED->CONDPAG := Posicione("SE4", 2, xFilial("SE4") + cCondPag, "E4_CODIGO")
					// MsgAlert("Utilizado condição de pagamento "+TMPPED->CONDPAG+" Pedido: "+TMPPED->PEDCLI)
					EndIf
					*/
				Else
					MsgAlert("O pedido "+TMPPED->NRPEDIDO+" está sem condição de pagamento.")
				EndIf
			Else
				TMPPED->CONDPAG := Posicione("SA1", 1, xFilial("SA1") + TMPPED->CLIENTE + TMPPED->LOJACLI, "A1_CONDPAG")
			EndIf
			
			TMPPED->DESCFIN  := Round(Val(SubStr(cStr,3,5))/100,2)          // Percentual desconto financeiro
			TMPPED->DESCCOM  := Round(Val(SubStr(cStr,23,5))/100,2)         // Percentual desconto comercial
			TMPPED->DESCPROM := Round(Val(SubStr(cStr,43,5))/100,2)         // Percentual desconto promocional
			
		elseIf cReg == "04"															/* REGISTRO 04 - ITENS DO PEDIDO */
			dbSelectArea("TMPITEM")
			RecLock("TMPITEM",.T.)
			if (cChaveItem <> TMPITEM->PEDCLI + TMPITEM->ITEM + TMPITEM->PRODUTO) // Verifica se o item do pedido já foi importado
				TMPITEM->PEDCLI 	:= TMPPED->PEDCLI          			// Código do pedido o cliente
				TMPITEM->CLIENTE 	:= TMPPED->CLIENTE         			// Código do cliente
				TMPITEM->LOJACLI 	:= TMPPED->LOJACLI         			// Loja do Cliente
				TMPITEM->ITEM 		:= SubStr(cStr,3,4)        			// Sequência do item no pedido da Neogrid
				TMPITEM->PRODUTO 	:= AllTrim(SubStr(cStr,18,14))  // Código do produto conforme padrão EAN
				TMPITEM->DESCPROD := SubStr(cStr,32,40)           // Descrição do produto
				
				// Se o tipo do pedido for bonificação(002), lê a quantidade do campo de bonificação, senão, lê do campo de itens pedidos.
				if TMPPED->TPPEDARQ = "002"
					TMPITEM->QTDEPED := Round(Val(SubStr(cStr,115,15))/100,2)
					TMPITEM->OPER		 := "04"  // Operação 04 - Bonificação
				Else
					TMPITEM->QTDEPED := Round(Val(SubStr(cStr,100,15))/100,2)
					TMPITEM->OPER 	 := "01"  // Operação 01 - Venda Normal
				EndIf
				
				// Conversão das unidades de medida que vêm no pedido da Neogrid para o padrão do Siga.
				cUnMed := AllTrim(SubStr(cStr, 92, 3))
				If cUnMed == "EA"
					TMPITEM->UNMED := "UN"
				elseIf cUnMed == "KGM"
					TMPITEM->UNMED := "KG"
				elseIf cUnMed == "LTR"
					TMPITEM->UNMED := "L "
				elseIf cUnMed == "MTR"
					TMPITEM->UNMED := "MT"
				elseIf cUnMed == "MTK"
					TMPITEM->UNMED := "M2"
				elseIf cUnMed == "MTQ"
					TMPITEM->UNMED := "M3"
				elseIf cUnMed == "MLT"
					TMPITEM->UNMED := "ML"
				elseIf cUnMed == "TN2"
					TMPITEM->UNMED := "TL"
				else
					cUnMed := AllTrim(SubStr(cStr, 145, 3))
					if cUnMed == "BX"
						TMPITEM->UNMED := "CX"
					elseIf cUnMed == "BJ"
						TMPITEM->UNMED := "BD"
					elseIf cUnMed == "PU"
						TMPITEM->UNMED := "BJ"
					elseIf cUnMed == "BN"
						TMPITEM->UNMED := "FD"
					elseIf cUnMed == "CA"
						TMPITEM->UNMED := "LT"
					elseIf cUnMed == "PC"
						TMPITEM->UNMED := "PC"
					elseIf cUnMed == "RO"
						TMPITEM->UNMED := "RL"
					elseIf cUnMed == "BG"
						TMPITEM->UNMED := "SC"
					else
						TMPITEM->UNMED := cUnMed
					EndIf
				EndIf
				TMPITEM->PLIQUNI	:= Round(Val(SubStr(cStr,198, 15))/100,2) // Preço líquido unitário do pedido.
				TMPITEM->IMPUNI		:= "1" // Unidade de medida que será mostrada na emissão da NF (1- Primeira)
				
				// Verifica se tem itens com troca no pedido
				if Round(Val(SubStr(cStr, 130, 15))/100,2) > 0
					TMPITEM->QTDETRO	:= Round(Val(SubStr(cStr,130,15))/100,2)
					MsgAlert("O item "+AllTrim(TMPITEM->DESCPROD)+" tem "+CValToChar(TMPITEM->QTDETRO)+;
					" "+TMPITEM->UNMED+" de troca no pedido "+AllTrim(TMPITEM->PEDCLI)+"."+;
					" As trocas não serão relacionados no pedido.")
				Else
					TMPITEM->QTDETRO  := 0
				EndIf
				cChaveItem := TMPITEM->PEDCLI + TMPITEM->ITEM + TMPITEM->PRODUTO
			Else
				
			EndIf
						
		elseIf cReg == "09"															/* REGISTRO 09 - RODAPÉ DO PEDIDO */
			MsUnlock("TMPITEM")  
		
			aCabPV:={{"C5_NUM"   		,TMPPED->PEDCLI      	,Nil},; 
							{"C5_TIPO"   		,TMPPED->TIPO       	,Nil},; 
							{"C5_CLIENTE"		,TMPPED->CLIENTE   		,Nil},; 
							{"C5_CLIENT"		,TMPPED->CLIENT   		,Nil},; 
							{"C5_LOJACLI"		,TMPPED->LOJACLI    	,Nil},; 
							{"C5_LOJAENT"		,TMPPED->LOJAENT    	,Nil},; 
							{"C5_CONDPAG"		,TMPPED->CONDPAG						,Nil},; 
							{"C5_TABELA"		,TMPPED->TABELA				,Nil},;
							{"C5_VEND1"			,TMPPED->VEND1		   	,Nil},;
							{"C5_X_CLVL"		,TMPPED->SEGMENTO	  	,Nil}}
			
			aItens := {}
			nItem  := 0
			
			DbSelectArea("TMPITEM")
			DbGoTop()
			While !Eof("TMPITEM")
				nItem++
				aLinha := {}
		
		   	_aTmp := TamSX3("C6_VALOR")
		    
		    /*
		    Aadd(aItem, {"PEDCLI",   "C", 20 , 0})
				Aadd(aItem, {"CLIENTE",  "C", 09 , 0})
				Aadd(aItem, {"LOJACLI",  "C", 04 , 0})
				Aadd(aItem, {"ITEM",     "C", 03 , 0})
				Aadd(aItem, {"PRODUTO",  "C", 14 , 0})
				Aadd(aItem, {"DESCPROD", "C", 40 , 0})
				Aadd(aItem, {"QTDEPED",  "N", 10 , 2})
				Aadd(aItem, {"QTDETRO",  "N", 10 , 2})
				Aadd(aItem, {"UNMED",    "C", 02 , 0})
				Aadd(aItem, {"PLIQUNI",  "N", 15 , 2})
				Aadd(aItem, {"OPER",   	 "C", 03 , 0})
				Aadd(aItem, {"IMPUNI", 	 "C", 01 , 0})
		    */
		
				aadd(aLinha,{"C6_ITEM"		,StrZero(nItem,TamSx3("C6_ITEM")[1]),Nil})
				aadd(aLinha,{"C6_PRODUTO"	,TMPITEM->PRODUTO						,Nil})
				aadd(aLinha,{"C6_QTDVEN"	,TMPITEM->QTDEPED						,Nil})
				aadd(aLinha,{"C6_PRCVEN"	,TMPITEM->PLIQUNI						,Nil})
				aadd(aLinha,{"C6_TES"			,"500"								,Nil}) 
				aadd(aLinha,{"AUTDELETA"	,"N"    							,Nil})
					
				AAdd(aItens,aLinha)
				
				DbSkip()
			End
									
			GravaPed(aCabPV, aItens)
			MsUnlock("TMPPED")
		else
			MsgAlert("Registro "+cReg+" não esperado.")
		EndIf
	
	
	FT_FSkip()
	
End
FT_FUse()

// Verifica se foi gerado log. Se sim, fecha arquivo.
if (lGeraLog == .T.)
	fClose(nHdl)
EndIf
Close(oDlg)

Return


Static Function GravaPed(aCabPV, aItens)

If !Empty(aItens)
	lMsHelpAuto := .T.
	lMsErroAuto := .F.
	
	nMod := nModulo
	nModulo := 5
	
	MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPV,aItens,3 )
	
	If lMsErroAuto
		RollBackSX8()
		MostraErro()
		DisarmTransaction()
	Else
		ConfirmSX8()
		_aRortBKP	:= aRotina
		aRotina 	:= {{ OemToAnsi("Pesquisar")	,"AxPesqui" 	, 0 , 1},;
		{ OemToAnsi("Visualizar")	,"A410Visual" 	, 0 , 2}}
		
		If MSGBOX("Visualizar Pedido "+SC5->C5_NUM+"?","IMPORTAÇÃO DE PEDIDOS","YESNO")
			A410Visual("SC5",SC5->(RecNo()),1)
		Endif
		aRotina	:= _aRortBKP
	Endif
Endif

Return
/*
Static Function ProdCli(cCliente, cLoja, cProduto)
Local cProduto := ""
BeginSql Alias "SA7TMP"
  select A7_CODCLI as CODCLI from %table:SA7% SA7
  where A7_CLIENTE = %exp:cCliente% 
    and A7_LOJA = %exp:cLoja%
    and CODCLI = %exp:cProduto%
    and SA7.%notdel%
    order by CODCLI 
EndSql

SA7TMP->(dbGoTop())
If !Empty(SA7TMP->CODCLI)
cProduto := AllTrim(SA7TMP->CODCLI)
SA7TMP->(dbCloseArea())
Return */