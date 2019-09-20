#Include "PROTHEUS.CH"
#Include "rwmake.CH"
#Include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDSIM3GºAutor  ³Flavio Dias        º Data ³  01/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funções para importacao do pedido que vem pelo SIM3G e    º±±
±±º          ³  deve ser inserido no sistema                  						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ImpSIM3G()
Local aItemPed   := {}
Local cErro      := ""
Local aEmpFil    := {}
Local cSql       := ""
Local cEol       := CHR(13)+CHR(10)

Local cServerIni := GetAdv97()
Local cIP        := "192.168.220.6"
Local cPort      := GetPvProfString( "TCP", "port", "11001", cServerIni)

Private aCabPed   := {}
Private lSemItens := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("IP: " + cIP)

RpcSetEnv("30", "01",,,,"SIM3G",{ "SC5", "SC6", "SF4", "SA1" })	

BeginSql alias "EMPPED"
	SELECT  DISTINCT IDLOCALFILIALFATURAMENTO AS IDLOCALFAT
	FROM PEDIDO PED	
	WHERE IDNPEDIDOLIDO = 0
	ORDER BY 1
EndSql

While EMPPED->(!Eof())
	aAdd(aEmpFil, AllTrim(EMPPED->IDLOCALFAT))
	EMPPED->(dbSkip())
EndDo

For nEmp := 1 to len(aEmpFil)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
	//³Libera o Environment³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
	
	RpcClearEnv() 
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Não consumir licensa de uso³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RPCSetType(3)	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta a empresa e filial que está no laço do FOR³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	RpcSetEnv(SubStr(aEmpFil[nEmp], 1, 2), SubStr(aEmpFil[nEmp], 4, 2),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "0"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cSql := "SELECT PED.IDPEDIDO, IDNPEDIDOLIDO, NUMEROPEDIDO as NUMPED, NUMEROPEDIDOCLIENTE as NUMPEDCLI, " +cEol
	cSql += " HORATRANSMISSAO, cast(OBSERVACAOPEDIDO as varchar(3000)) AS OBSPED, "                          +cEol
	cSql += " cast(OBSERVACAONOTAFISCAL as varchar(3000)) AS OBSNF, "                                        +cEol
	cSql += " TO_CHAR(DATAATUALIZACAO, 'yyyymmdd') as DATAATUALIZACAO, "                                     +cEol
	cSql += " TO_CHAR(DATATRANSMISSAO, 'yyyymmdd') as DATATRANSMISSAO, "                                     +cEol
	cSql += " TO_CHAR(DATAPEDIDO, 'yyyymmdd') as DATAPEDIDO, VALORTOTAL, "                                   +cEol
	cSql += " IDLOCALFILIALFATURAMENTO, IDTABELAPRECO, IDCONDICAOPAGAMENTO, "                                +cEol
	cSql += " IDPARCEIROTRANSPORTADORA AS CODTRANSP, IDUSUARIO, "                                            +cEol
	cSql += " IDTIPOPEDIDO, IDLOCAL, sglTipoTransporte AS TPTANSP, dataEntrega "                             +cEol
	cSql += "FROM PEDIDO PED "                                                                               +cEol
	cSql += " LEFT JOIN PEDIDOENTREGA ENT ON (PED.idPedido = ENT.idPedido) "                                 +cEol
	cSql += " WHERE IDNPEDIDOLIDO = 0 "                                                                      +cEol
	cSql += "   and IDLOCALFILIALFATURAMENTO = '"+ aEmpFil[nEmp] +"' "                                       +cEol
	cSql += " ORDER BY IDLOCALFILIALFATURAMENTO, IDPEDIDO "                                                  +cEol
	
	Conout(cSql)
	
	TCQUERY cSql NEW ALIAS "CABPED"
	
	DbSelectArea("CABPED")
	
	While (CABPED->(!Eof()))
		
		aCabPed := {}
				
		ConOut("Processando Pedido " + AllTrim(CABPED->NUMPED))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do cabeçalho do pedido.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd(aCabPed, {"C5_FILIAL",SubStr(CABPED->IDLOCALFILIALFATURAMENTO, 4, 2),Nil})
		aAdd(aCabPed, {"C5_TIPO","N",Nil})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
		//³Adiciona ao campo Licitação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù
		
		aAdd(aCabPed, {"C5_COTACAO",SubStr(CABPED->NUMPED, 1, 9),Nil})
		                   
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD¿
		//³Obtém código do cliente.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÙ
		
		aCli := StrToKArr(AllTrim(CABPED->IDLOCAL), '-')
		aAdd(aCabPed, {"C5_CLIENTE",aCli[1],Nil})		
		aAdd(aCabPed, {"C5_LOJACLI",aCli[2],Nil})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Seta a operação de acordo com o tipo do pedido.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cOper := iif("CF" $ CABPED->IDTIPOPEDIDO, "03", "01")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o pedido for bonificação, seta operação "04"³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if ("PB" $ CABPED->IDTIPOPEDIDO) 
			cOper := "04"
		EndIF
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona o sistema no cliente correto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		SA1->(dbSetOrder(01))
		if SA1->(dbSeek(xFilial("SA1") + Substr(CABPED->IDLOCAL, 1, 9) + Substr(CABPED->IDLOCAL,11,4)))
			cTipoCli := SA1->A1_TIPO 
			Conout("Cliente "+AllTrim(SubStr(SA1->A1_NOME,1,30))+ " posicionado." +;
						 "Tipo do Cliente: "+Trim(cTipoCli))
		Else
			Conout("Cliente não posicionado corretamente. Verificar...")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Se o cliente estiver bloqueado, envia workflow informando o vendedor.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if (SA1->A1_MSBLQL == "1")
			cErro := "<STRONG>Cliente " + aCli[1]  + "/" + aCli[2] + " - " + AllTrim(SA1->A1_NREDUZ) + ;
						" está bloqueado. Verifique com o setor financeiro.</STRONG>"
			EnviaErro(cErro)
		EndIf
		                        
		cEmpFil := cEmpAnt + cFilAnt
				
		aAdd(aCabPed, {"C5_TIPOCLI",cTipoCli,Nil})
		aAdd(aCabPed, {"C5_TABELA" ,AllTrim(CABPED->IDTABELAPRECO),Nil})
		aAdd(aCabPed, {"C5_CONDPAG",Substr(CABPED->IDCONDICAOPAGAMENTO, 1, 3),Nil})
  	aAdd(aCabPed, {"C5_VEND1"  ,SubStr(CABPED->IDUSUARIO, 1, 6),Nil})
  	aAdd(aCabPed, {"C5_TRANSP" ,CABPED->CODTRANSP,Nil})
  	aAdd(aCabPed, {"C5_PEDCLI" ,CABPED->NUMPEDCLI,Nil})
  	aAdd(aCabPed, {"C5_OBSPED" ,iif(Empty(CABPED->OBSPED), " ", CABPED->OBSPED),Nil})
  	aAdd(aCabPed, {"C5_MENNOTA",iif(Empty(CABPED->OBSNF), " ", CABPED->OBSNF),Nil})
  	aAdd(aCabPed, {"C5_EMISSAO",SToD(CABPED->DATATRANSMISSAO),Nil})
  	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Somente seta o tipo de transporte (CIF ou FOB) se informado pelo Sim3G³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
  	if !Empty(CABPED->TPTANSP)
  		aAdd(aCabPed, {"C5_TPFRETE",SubStr(CABPED->TPTANSP, 1, 1),Nil})
  	EndIf
  	
  	aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
  	
  	cNumPed := GetSxeNum("SC5","C5_NUM")
  	
  	aAdd(aCabPed, {"C5_NUM",cNumPed,Nil})
  	aAdd(aCabPed, {"C5_SIM3G",.T.,Nil})
  	
  	ConOut("Transportador: " + CABPED->CODTRANSP)  	
		
		lSemItens := .F.
  	
  	ConfirmSX8()
  	  	
  	aItemPed := MontaItenPed(CABPED->IDPEDIDO, cNumPed)
		
  	If lSemItens                                       

 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
			//³Atualiza o pedido com status "-3" caso o pedido não contenha itens. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ

			cSqlUpd := "Update pedido set IDNPEDIDOLIDO = -3 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
			TcSqlExec(cSqlUpd)
			cErro := "<STRONG>Pedido sem itens</STRONG>"
			ConOut("Pedido: " + AllTrim(Str(CABPED->IDPEDIDO,0)) + " sem itens.")
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Envia Workflow informando que pedido está sem itens.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			EnviaErro(cErro)
					
		Else 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Se pedido está correto, inicia tread de inclusão.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			StartJob("U_JobIncPed", GetEnvServer(), .F., cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, CABPED->IDPEDIDO, cIP, cPort)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Marca pedido com status "2 - Em processamento"³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cSqlUpd := "Update pedido set IDNPEDIDOLIDO = 2 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
			TcSqlExec(cSqlUpd)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Aguarda 2 seguntos até o término da execução do comando SQL³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
			sleep(2000) 
  	
  	EndIf
  	
		CABPED->(DbSkip())
	
	EndDo	
	
	CABPED->(dbCloseArea())

Next

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Libera o ambiente que estava em uso.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

RpcClearEnv() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDSIM3GºAutor  ³Flavio Dias        º Data ³  11/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que monta os itens do pedido.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaItenPed(cIdPedido, cNumPed)
Local aItemLinha 	:= {}
Local aItem      	:= {}
Local cItemNovo  	:= PadL("00", Len(SC6->C6_ITEM))
Local cWhere     	:= "IDPEDIDO = " + AllTrim(Str(cIdPedido,0)) + " AND (IDNEXCLUIDOERP <> 1 OR IDNEXCLUIDOERP IS NULL)"  // Flavio - 06/01/2012 - remove os itens excluídos pela manutenção
Local i, cTpConv, nFatConv
Local aArea      	:= GetArea()
Local cLocal    	:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ \»\\»\¿
//³Parâmetro que aramazena se deve zerar o preço de tabela quando vêm do palm.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù

Local lPrcTab    	:= SuperGetMV("MV_PRCTABP", ,.F.)  
Local cTesForaUF 	:= ""
Local cTesST 			:= ""
Local cSql   			:= ""
Local cUFsST 			:= ""
Local cTesCP 			:= ""
Local cUFsCP 			:= ""
Local cTpCli 			:= ""
Local cClVl  			:= Space(6)
Local cVend  			:= Space(6)
Local lUfDif 			:= .F.
Local lLibPed 		:= SuperGetMV("MV_X_PSFAL", , .T.)
Local lMudaTES 		:= .F.
Local cTes 				:= ""
Local cCfop 			:= ""
Local cEol 				:= CHR(13)+CHR(10)
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca dos itens relacionados ao pedido que está sendo processado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "SELECT IDPEDIDOPRODUTO, IDPRODUTO, QUANTIDADE, PRECOORIGINAL, PRECOVENDA, PRECOVENDASEMTRIBUTACAO as PRECOSTRIB, 	IDPEDIDO, "+cEol
cSql += " IDEMBALAGEMCOMERCIALIZADA as UNIDADE, QUANTIDADEUNIT AS QTDSEGUN, LOTE, IDTABELAPRECO AS TABPRC "                            +cEol  
cSql += "FROM PEDIDOPRODUTO "                                                                                                          +cEol
cSql += "WHERE "+ cWhere +" "                                                                                                          +cEol
cSql += "ORDER BY IDPEDIDOPRODUTO "                                                                                                    +cEol

Conout(cSql)

TCQUERY cSql NEW ALIAS "ITEPED"
DbSelectArea("ITEPED")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no cliente para buscar o Estado e o Tipo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aCli := StrToKArr(AllTrim(CABPED->IDLOCAL), '-')
cUFCli := Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_EST")
cTpCli := Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_TIPO")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia amarração de armazem x vendedor para buscar segmento que será atribuído no pedido.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if ITEPED->(!Eof())
  
  DbSelectArea("SBZ")
  SBZ->(dbSetOrder(01))
	SBZ->(dbSeek(xFilial("SBZ") + AllTrim(ITEPED->IDPRODUTO)))
  cLocal := SBZ->BZ_LOCPAD
	
	cVend := SubStr(CABPED->IDUSUARIO, 1, 6)
	cClVl := Space(6)
	dbSelectArea("Z22")
	dbSetOrder(01)
	dbSeek(xFilial("Z22") + cVend)
	
	While (xFilial("Z22") + cVend == Z22->Z22_FILIAL + Z22->Z22_CODVEN) .And. !Eof()
		if (Z22->Z22_ARMAZ == cLocal)
			cClVl := Z22->Z22_CODCVL
			Exit
		EndIf
		Z22->(dbSkip())
	EndDo
	
	Z22->(dbCloseArea())
	
	if !Empty(cClVl)
		aAdd(aCabPed, {"C5_X_CLVL",cClVl,Nil})		
	EndIf
	
	ConOut("Classe de valor: " + cClVl)
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso não for encontrado segmento na amarração arm. x vend. x segmento, envia workflow para vendedor informando.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if Empty(cClVl)
	cErro := "<STRONG>Segmento não cadastrado para o armazém " + cLocal +" , vendedor " + cVend + ". Favor cadastrar.</STRONG>"
	EnviaErro(cErro)
EndIf 

dbSelectArea("ITEPED")

lSemItens := ITEPED->(Eof())

While (ITEPED->(!Eof()))	

	lMudaTES := .F.
	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLinha, {"C6_NUM",cNumPed,Nil})
	aAdd(aItemLinha, {"C6_ITEM",cItemNovo,Nil})  
	
	aAdd(aItemLinha, {"C6_PRODUTO",AllTrim(ITEPED->IDPRODUTO),Nil})
	
	SB1->(dbSetOrder(01))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(ITEPED->IDPRODUTO)))
	
	dbSelectArea("SBZ")
	SBZ->(dbSetOrder(1))
	SBZ->(dbSeek ( xFilial("SBZ") + AllTrim(ITEPED->IDPRODUTO)))
	
	cTesForaUF := ""
	cTesST := ""
	cUFsST := ""
	cTesCP := ""
	cUFsCP := ""
	
	BEGINSQL alias "ZZATMP"
		SELECT ZZA_PRODUT, ZZA_GRUPO, ZZA_TESUFD, ZZA_TESST, ZZA_UFSST, ZZA_TESCRP, ZZA_UFSCRP FROM %TABLE:ZZA% ZZA
		WHERE ZZA_FILIAL = %XFILIAL:ZZA%
		AND (ZZA_GRUPO = %EXP:SB1->B1_GRUPO% OR ZZA_PRODUT = %EXP:SB1->B1_COD%)
		AND %NOTDEL%
		ORDER BY ZZA_PRODUT, ZZA_GRUPO
	ENDSQL
	
	While ZZATMP->(!Eof())
		
		if !Empty(ZZATMP->ZZA_TESUFD)
			cTesForaUF := ZZATMP->ZZA_TESUFD
		EndIf
		
		if !Empty(ZZATMP->ZZA_TESST) .And. (cUFCli $ ZZATMP->ZZA_UFSST)
			cTesST := ZZATMP->ZZA_TESST
			cUFsST := ZZATMP->ZZA_UFSST
		EndIf
		
		if !Empty(ZZATMP->ZZA_TESCRP) .And. (cUFCli $ ZZATMP->ZZA_UFSCRP)
			cTesCP := ZZATMP->ZZA_TESCRP
			cUFsCP := ZZATMP->ZZA_UFSCRP
		EndIf
		
		ZZATMP->(dbSkip())
		
	EndDo		
	
	dbCloseArea("ZZATMP")
	
	// obtém se a uf do cliente é diferente da empresa	
	/*if !Empty(cTesForaUF)
		lUfDif := Posicione("SA1", 01, xFilial("SA1") + Substr(CABPED->IDLOCAL, 1, 6) + Substr(CABPED->IDLOCAL, 8, 2), "A1_EST") != SM0->M0_ESTCOB
	EndIf*/
	
	// obtém o fator de conversão, a ser usado logo abaixo, na conversão para a segunda unidade.
	nFatConv := Iif(SB1->B1_TIPCONV == "M", 1 / SB1->B1_Conv, SB1->B1_Conv)

	aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})	
	
	aAdd(aItemLinha, {"C6_QTDVEN",ITEPED->QUANTIDADE,Nil})
	// aAdd(aItemLinha, {"C6_PRUNIT",ITEPED->PRECOORIGINAL,Nil})
	aAdd(aItemLinha, {"C6_PRCVEN",ITEPED->PRECOVENDA,Nil})
	aAdd(aItemLinha, {"C6_PRCTAB",ITEPED->PRECOORIGINAL,Nil})
	aAdd(aItemLinha, {"C6_VALOR",Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2),Nil})
	aAdd(aItemLinha, {"C6_ENTREG",dDataBase,Nil})
	//aAdd(aItemLinha, {"C6_UM",SB1->B1_UM,Nil})	
	
	aAdd(aItemLinha, {"C6_LOCAL", cLocal,Nil})
	
	// Valida se a tabela de preço é promocional
	// Flavio - 22/09/2011
	if !Empty(ITEPED->TABPRC)		
		aAdd(aItemLinha, {"C6_X_TAPRO",ITEPED->TABPRC,Nil})
		aAdd(aItemLinha, {"C6_X_PROMO","S",Nil})
	else
		aAdd(aItemLinha, {"C6_X_PROMO","N",Nil})
	EndIf

	ConOut(AllTrim(ITEPED->IDPRODUTO))
	ConOut(AllTrim(SB1->B1_DESC))
	ConOut(AllTrim(Str(ITEPED->QUANTIDADE)))
	ConOut(Str(ITEPED->PRECOVENDA))
	
	cTes := ""
	
	SF4->(dbSetOrder(01))
	
	if("PB" $ CABPED->IDTIPOPEDIDO)
		cOper := "04"
	else
		cOper := ""
	EndIf
	
	// apenas seta o tipo de operação caso não seja pneu ou bonificação
	if Substr(cClVl, 1, 3) == "005" .Or. cOper == "04"
		
		// seta apenas a operaçao que está sendo analisada, pois a conversao ja fica automatica
		if Empty(cOper)
			cOper := iif("CF" $ CABPED->IDTIPOPEDIDO, "03", "01")
		EndIf
		
		// Jean (18/10/2012) - Tratativa para que todos os pedidos do segmento de pneus entrem com a seguinte regra:
		// Quando o tipo de cliente for Consumidor Final, usa operação "03", caso contrário, usa operação "01"
		
		if Substr(cClVl, 1, 3) == "005"
			if cTpCli == "S"
				cOper := "01"
			Else
				cOper := "03"
			EndIf
			ConOut("Segmento de Pneu: "+trim(cClvl)+" Tipo de Operação: "+trim(cOper))
		EndIf
		
		aAdd(aItemLinha, {"C6_OPER",cOper,Nil})
	else
		SF4->(dbSeek(xFilial("SF4") + SBZ->BZ_TS))
		cTes := SBZ->BZ_TS
		lMudaTES := .T.
		//aAdd(aItemLinha, {"C6_TES",SBZ->BZ_TS,Nil})
		//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
 	EndIf
	                                             
	// avaliacao da mudança de TES na RJU
	ConOut("Avalia mudança de TES " + cTesForaUF)
	if !lUfDif
		ConOut("UF do cliente igual da empresa")
	EndIF
	
	// Busca a Tes do indicador de produto
	
	
	// Altera a tes caso a mesma tenha sido informada e a venda é para fora do estado.
	If lUfDif .And. !Empty(cTesForaUF) .And. (cOper != "04")
		cTes := cTesForaUF
		lMudaTES := .T.
		
		//AADD(aItemLinha,{"C6_TES",cTesForaUF,Nil})
		//SF4->(dbSeek(xFilial("SF4") + cTesForaUF))
		//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
		//ConOut("Mudou a tes do produto " + AllTrim(ITEPED->IDPRODUTO) + " para " + cTesForaUF)
	EndIf
	
	// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtos
	if (cUFCli $ cUFsST .And. !Empty(cTesST)) .And. (cOper != "04")
		cTes := cTesST
		lMudaTES := .T.
		
		//AADD(aItemLinha,{"C6_TES",cTesST,Nil})		
		//SF4->(dbSeek(xFilial("SF4") + cTesST))
		//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
		
		// Muda o tipo do cliente para solidário
		aAdd(aCabPed, {"C5_TIPOCLI","S",Nil})
		
		//ConOut("Mudou a tes do produto " + AllTrim(ITEPED->IDPRODUTO) + " para " + cTesST)
	EndIf
	
	// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de Credito Presumido para alguns produtos
	if (cUFCli $ cUFsCP .And. !Empty(cTesCP)) .And. (cOper != "04")
		cTes := cTesCP
		lMudaTES := .T.
		//AADD(aItemLinha,{"C6_TES",cTesCP,Nil})
		
		//SF4->(dbSeek(xFilial("SF4") + cTesCP))
		//aAdd(aItemLinha, {"C6_CF",iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3),Nil})
		
		//ConOut("Mudou a tes do produto " + AllTrim(ITEPED->IDPRODUTO) + " para " + cTesCP)
	EndIf 
	
	if lMudaTES .And. !Empty(cTes) .And. (cOper != "04")
		AADD(aItemLinha,{"C6_TES",cTes,Nil})
		
		SF4->(dbSeek(xFilial("SF4") + cTes))
		cCfop := iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3)
		
		If Left(cCfop,4) == "6405"
			cCfop := "6404"+SubStr(cCfop,5,Len(cCfop)-4)
		Endif
		
		ConOut("CFOP: " + cCfop)
		
		aAdd(aItemLinha, {"C6_CF", cCfop, Nil})
		
		ConOut("Mudou a tes do produto " + AllTrim(ITEPED->IDPRODUTO) + " para " + cTes)
	EndIf
	
	ConOut("Tes: " + cTes)
	
	// Seta a segunda unidade
	if !Empty(ITEPED->UNIDADE)
		nVlrSUn :=  Round(Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2) / ITEPED->QTDSEGUN, 2)
		
		aAdd(aItemLinha, {"C6_PRCSU", nVlrSUn,Nil})
		
		// seta a primeria unidade, devido a alterar a segunda
		AADD(aItemLinha,{"C6_QTDVEN",ITEPED->QUANTIDADE,Nil})
		aAdd(aItemLinha, {"C6_UNSVEN", ITEPED->QTDSEGUN,Nil})
		
		// seta a primeira unidade, devido a alterar a segunda		
		// Tem que adicionar novamente o campo, independente de ele já existir,
  	// pois se alterar o conteúdo do campo existente vai dar erro ao inserir o pedido no SC6
		AADD(aItemLinha,{"C6_PRCVEN",(ITEPED->QTDSEGUN * nVlrSUn) / ITEPED->QUANTIDADE,Nil})
		
		aAdd(aItemLinha, {"C6_IMPUNI","2",Nil})
	endif
	
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})
	                 // Se for vinho tem que vir o pedido sem liberação
	ConOut("Libera Pedido T/F : ")
	ConOut(lLibPed)
	if lLibPed .And. (cClVl != '003001001')
		aAdd(aItemLinha, {"C6_QTDLIB",ITEPED->QUANTIDADE,Nil})
	else
		aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})	
	EndIf
	
	if !Empty(ITEPED->LOTE)
		aAdd(aItemLinha, {"C6_LOTECTL",ITEPED->LOTE,Nil})
	EndIf
	
	// Armazena o valor original do item para retornar para o SFA
	aAdd(aItemLinha, {"C6_X_VLORI",Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2),Nil})
			
	ITEPED->(dbskip())
	
	// adiciona no array de itens	
	aAdd(aItem, aItemLinha)
	
	// limpa pra nao duplicar as informações
	aItemLinha := {}
EndDo

ITEPED->(dbCloseArea())
  
Return aItem

/*********************************************************************************
 Faz o processo de enviar o email caso ocorreu erro
 *********************************************************************************/
Static Function EnviaErro(cErro)
Local cVend := SubStr(CABPED->IDUSUARIO, 1, 6)
Local cEmailVend := ""
Local cCli := Substr(CABPED->IDLOCAL, 1, 6)
Local cLojaCli := Substr(CABPED->IDLOCAL, 8, 6)
Local oProcess
Local oHtml
Local cProcess := OemToAnsi("008080") // Numero do Processo
Local aCli := StrToKArr(AllTrim(CABPED->IDLOCAL), '-')

Local cMailCC := SuperGetMV("MV_X_S3GER", , "sim3g@grupocantu.com.br")

cStatus  := OemToAnsi("001011")
cCli := aCli[1]
cLojaCli := aCli[2]

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido"))
oProcess:NewTask(cStatus,"\workflow\wfpedcomerro.htm")
oProcess:cSubject := OemToAnsi("Erro no pedido " + AllTrim(CABPED->NUMPED) + ". Não foi sincorinizado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail := SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

oProcess:cTo := ALLTRIM(cEmail) // "microsiga@grupocantu.com.br"
oProcess:cCC := cMailCC //  ""
                                    
// Preenchimento do cabeçalho do pedido
oHtml:= oProcess:oHTML		
oHtml:ValByName("DATA"   , DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE", cCli + " - " + cLojaCli + Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"))
oHtml:ValByName("VENDEDOR" , cNomeVend)
oHtml:ValByName("PEDSIM" , AllTrim(CABPED->NUMPED))
oHtml:ValByName("VALORTOTAL",Transform(CABPED->VALORTOTAL, '@E 999,999,999.99'))
oHtml:ValByName("ERRO", cErro)

oProcess:Start()
oProcess:Finish()
Return Nil                                                                      

/*********************************************************************************
 Faz o processo de enviar o email para o vendedor confirmando da sincronização
 *********************************************************************************/
Static Function EnviaPedOk(cPedSiga)
Local cVend := SubStr(CABPED->IDUSUARIO, 1, 6)
Local cEmailVend := ""
Local cCli := ""
Local cLojaCli := ""
Local oProcess
Local oHtml
Local cProcess := OemToAnsi("008080") // Numero do Processo
Local aCli := StrToKArr(AllTrim(CABPED->IDLOCAL), '-')
cStatus  := OemToAnsi("001011")
cCli := aCli[1]
cLojaCli := aCli[2]

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido"))
oProcess:NewTask(cStatus,"\workflow\wfpedsincronizado.htm")
oProcess:cSubject := OemToAnsi("Pedido " + AllTrim(CABPED->NUMPED) + " recebido - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail := SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)
  
oProcess:cTo := ALLTRIM(cEmail) // "microsiga@grupocantu.com.br"
oProcess:cCC := "sim3g@grupocantu.com.br" // ""
                                    
// Preenchimento do cabeçalho do pedido
oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"   ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE", cCli + " - " + cLojaCli + Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"))
oHtml:ValByName("VENDEDOR", cNomeVend)
oHtml:ValByName("PEDSIM" ,AllTrim(CABPED->NUMPED))
oHtml:ValByName("PEDSIGA",cPedSiga)
oHtml:ValByName("VALORTOTAL",Transform(CABPED->VALORTOTAL, '@E 999,999,999.99'))

oProcess:Start()
oProcess:Finish()
Return Nil


User Function JobIncPed(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort)
Local cIdPedido := "%" + AllTrim(Str(idPedido,0)) + "%"
Local cWhere := "% PED.IDPEDIDO = " + AllTrim(Str(idPedido,0)) + " %"
Local cSql := ""
Local cEnv := GetEnvServer()
Local oSrv
Local lExist := .F.

Private aCli := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

oSrv := rpcconnect(cIP, Val(cPort), cEnv, cEmp, cFil)
if !(valtype(oSrv) == "O")
	ConOut("Nao conectou no servidor")
	ConOut("Server: " + cIP + cPort)
	Return
EndIf


RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmp, cFil,,,,GetEnvServer(),{ "SA1" })	
// Cria o alias de cabeçalho de pedido

cSql :=	" SELECT  PED.IDPEDIDO, IDNPEDIDOLIDO, NUMEROPEDIDO as NUMPED, NUMEROPEDIDOCLIENTE as NUMPEDCLI, "
cSql +=	" HORATRANSMISSAO, "
cSql +=	"	TO_CHAR(DATAATUALIZACAO, 'yyyymmdd') as DATAATUALIZACAO, "
cSql +=	"	TO_CHAR(DATATRANSMISSAO, 'yyyymmdd') as DATATRANSMISSAO, "
cSql +=	"	TO_CHAR(DATAPEDIDO, 'yyyymmdd') as DATAPEDIDO, VALORTOTAL, "
cSql +=	"	IDLOCALFILIALFATURAMENTO, IDTABELAPRECO, IDCONDICAOPAGAMENTO, "
cSql +=	"	IDUSUARIO, IDTIPOPEDIDO, IDLOCAL "
cSql +=	"	FROM PEDIDO PED "
cSql +=	"	WHERE PED.IDPEDIDO = " + AllTrim(Str(idPedido,0))
cSql +=	"	ORDER BY IDLOCALFILIALFATURAMENTO, IDPEDIDO "

TcQuery cSql New alias "CABPED"

aCli := StrToKArr(AllTrim(CABPED->IDLOCAL), '-')

ConOut("Cliente : " + CABPED->IDLOCAL)

lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valida se já existe algum pedido cadastrado no sistema com o mesmo código de Licitação.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

lExist := AvalLicit(aCabPed)
	                         
if !lSemItens .and. !lExist
	MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItemPed,3)
EndIf
  
SC5->(dbSetOrder(01))
lSincr := SC5->(dbSeek(xFilial("SC5") + cNumPed))
if lSincr
	ConOut("Pedido " + cNumPed + " sincronizado.")
else
	ConOut("Pedido " + cNumPed + " não sincronizado.")
EndIf

If lSincr .or. lExist
	cSqlUpd := "Update pedido set IDNPEDIDOLIDO = 1 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
	oSrv:callproc("TcSqlExec", cSqlUpd)
	
	if !lExist
		EnviaPedOk(cNumPed)			
		ConOut("Pedido Sincronizado com Sucesso")
	EndIf
	
elseif !lSemItens
	cSqlUpd := "Update pedido set IDNPEDIDOLIDO = -1 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
	
	oSrv:callproc("TcSqlExec", cSqlUpd)
	
	if !ExistDir("\SIM3G")
		MakeDir("\SIM3G")
	EndIf
	cErro := MostraErro("\SIM3G")
	ConOut("Pedido nao sincronizado:")
	ConOut(cErro)
	cErro := StrTran(cErro, chr(13) + chr(10), '<br/>')	
	EnviaErro(cErro)	
EndIf

ConOut("Pedido " + AllTrim(CABPED->NUMPEDCLI) + " processado")
rpcdisconnect(oSrv)
CABPED->(dbCloseArea())
RpcClearEnv()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDSIM3GºAutor  ³Jean Saggin        º Data ³  03/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função criada pra validar se o pedido já foi importado     º±±
±±º          ³ para o sistema uma vez.                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Rotina de Integração de Pedidos Sim3G x Microsiga          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function AvalLicit(aCabPed)
Local lRet := .F.
Local cSql := ""
Local nPosFil := aScan(aCabPed, {|x| AllTrim(x[1]) == "C5_FILIAL"})
Local nPosLic := aScan(aCabPed, {|x| Alltrim(x[1]) == "C5_COTACAO"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta SQL que faz a busca do pedido pelo campo C5_CONTACAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "SELECT C5.C5_NUM FROM "+retSqlName("SC5")+" C5 "
cSql += "WHERE C5.C5_FILIAL = '"+ aCabPed[nPosFil][2] +"' "
cSql += "  AND C5.C5_COTACAO = '"+ aCabPed[nPosLic][2] +"' "
cSql += "  AND C5.D_E_L_E_T_ <> '*' "

TCQUERY cSql NEW ALIAS "C5LIC"

DbSelectArea("C5LIC")
C5LIC->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se a tabela temporária é um arquivo vazio.
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

if C5LIC->(EOF())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se a tabela estiver vazia, fecha tab. temporária e retorna .F. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	C5LIC->(DbCloseArea())
	Return .F.            
	
Else
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se tabela tiver conteúdo, retorna mensagem no console informando o número do pedido encontrado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Conout("Foi encontrado o pedido número "+AllTrim(C5LIC->C5_NUM)+" com o código de licitação "+;
				 Trim(aCabPed[nPosLic][2])+". Pedido já importado anteriormente.")
	lRet := .T.                                                                    
	C5LIC->(DbCloseArea())
EndIf               

Return lRet