#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDSIM3GºAutor  ³JEAN SAGGIN        º Data ³  01/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Funções para importacao do pedido que vem pelo SIM3G e    º±±
±±º          ³  deve ser inserido no sistema                  						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function SIM3GAND()    
*--------------------------*

#DEFINE MAX_PED 10

Local aItemPed   := {}
Local cErro      := ""
Local aEmpFil    := {}
Local cSql       := ""
Local cEol       := CHR(13)+CHR(10)

Local cServerIni := GetAdv97()
//@qui
Local cIP        := "192.168.220.6"
//Local cIP        := "192.168.220.50"
Local cPort      := GetPvProfString( "TCP", "port", "20002", cServerIni)

Private aCabPed   := {}
Private cSegmento := ""
Private lSemItens := .F.          
Private nLock     := 0
Private nQtdPed   := 0    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//U_USORWMAKE(ProcName(),FunName())

ConOut("IMPPEDSIM_AND - INICIANDO EXECUCAO")
RpcSetType(3)
RpcSetEnv("30", "01",,,,"SIM3G",{ "SC5", "SC6", "SF4", "SA1" })	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLock := 0
While !LockByName("IMPPEDAND",.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)                                    	
	If nLock > 10                                 
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
		Return
	EndIf		
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Seleção das diferentes empresas e filiais que contém pedidos a importar³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "SELECT DISTINCT IDLOCALFILIALFATURAMENTO AS IDLOCALFAT, COUNT(*) AS QUANT FROM MOD_PEDIDO PED "  +cEol
cSql += "WHERE IDNPEDIDOLIDO = 0 "                                                                        +cEol
cSql += "GROUP BY IDLOCALFILIALFATURAMENTO "
cSql += "ORDER BY QUANT DESC "

TCQUERY cSql NEW ALIAS "EMPPED"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se o retorno não é vazio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if EMPPED->(EOF())
	EMPPED->(DbCloseArea())	
	ConOut("IMPPEDSIM_AND - SEM PEDIDOS A IMPORTAR")
	Return
EndIf

While EMPPED->(!Eof())
	nTmpQtd := 0
	if nQtdPed >= MAX_PED
		Exit               
	Else
		if (nQtdPed + EMPPED->QUANT) > MAX_PED
			nTmpQtd := MAX_PED - nQtdPed
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPPED->IDLOCALFAT, nTmpQtd})
		Else
			nTmpQtd := EMPPED->QUANT
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPPED->IDLOCALFAT, nTmpQtd})
		EndIf                                                      
	EndIf
	EMPPED->(dbSkip())
EndDo

EMPPED->(DbCloseArea())

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
	
	RpcSetEnv(SubStr(aEmpFil[nEmp, 01], 1, 2), SubStr(aEmpFil[nEmp, 01], 4, 2),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "0"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cSql := "SELECT PED.IDPEDIDO, IDNPEDIDOLIDO, NUMEROPEDIDO as NUMPED, NUMEROPEDIDOCLIENTE as NUMPEDCLI, " +cEol
	cSql += " HORATRANSMISSAO, IDSEGMENTO, cast(OBSERVACAOPEDIDO as varchar(3000)) AS OBSPED, "              +cEol
	cSql += " cast(OBSERVACAONOTAFISCAL as varchar(3000)) AS OBSNF, "                                        +cEol
	cSql += " TO_CHAR(DATAATUALIZACAO, 'yyyymmdd') as DATAATUALIZACAO, "                                     +cEol
	cSql += " TO_CHAR(DATATRANSMISSAO, 'yyyymmdd') as DATATRANSMISSAO, "                                     +cEol
	cSql += " TO_CHAR(DATAPEDIDO, 'yyyymmdd') as DATAPEDIDO, VALORTOTAL, "                        					 +cEol
	cSql += " IDLOCALFILIALFATURAMENTO, IDTABELAPRECO, IDCONDICAOPAGAMENTO, "                                +cEol
	cSql += " IDPARCEIROTRANSPORTADORA AS CODTRANSP, IDUSUARIO, "                                            +cEol
	cSql += " IDTIPOPEDIDO, IDLOCAL, sglTipoTransporte AS TPTANSP, dataEntrega "                             +cEol
	cSql += "FROM MOD_PEDIDO PED "                                                                           +cEol
	cSql += " LEFT JOIN MOD_PEDIDOENTREGA ENT ON (PED.idPedido = ENT.idPedido) "                             +cEol
	cSql += " WHERE IDNPEDIDOLIDO = 0 "                                                                      +cEol
	cSql += "   AND TRIM(IDLOCALFILIALFATURAMENTO) = '"+ AllTrim(aEmpFil[nEmp, 01]) +"' "                    +cEol
 	cSql += "   AND ROWNUM <= " + AllTrim(Str(aEmpFil[nEmp, 02]))                                            +cEol
	cSql += " ORDER BY IDLOCALFILIALFATURAMENTO, IDPEDIDO "                                                  +cEol
	
	Conout("IMPPEDSIM_AND - EMP/FIL: "+ AllTrim(aEmpFil[nEmp, 01]) +" QTD PED: "+ AllTrim(Str(aEmpFil[nEmp, 02])))
	
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
  	aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
  	
  	cNumPed := GetSxeNum("SC5","C5_NUM")
  	
  	aAdd(aCabPed, {"C5_NUM",cNumPed,Nil})
  	aAdd(aCabPed, {"C5_SIM3GM",.T.,Nil})
  	aAdd(aCabPed, {"C5_X_CLVL", CABPED->IDSEGMENTO,Nil})		
		
		ConOut("Classe de valor: " + CABPED->IDSEGMENTO)
  	
  	ConOut("Transportador: " + CABPED->CODTRANSP)  	
		
		lSemItens := .F.
  	
  	ConfirmSX8()
  	  	
  	aItemPed := MontaItenPed(CABPED->IDPEDIDO, cNumPed)
		
  	If lSemItens                                       

 			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
			//³Atualiza o pedido com status "-3" caso o pedido não contenha itens. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ

			cSqlUpd := "Update MOD_PEDIDO set IDNPEDIDOLIDO = -3 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
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
			
			//U_JobPedAnd(cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, CABPED->IDPEDIDO, cIP, cPort)
			StartJob("U_JOBPEDAND", GetEnvServer(), .F., cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, CABPED->IDPEDIDO, cIP, cPort)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Marca pedido com status "2 - Em processamento"³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cSqlUpd := "Update MOD_PEDIDO set IDNPEDIDOLIDO = 2 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia threads em execução e aguarda até que todos os pedidos sejam incluídos pra finalizar a rotina
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

While !FreeAllThreads()
	Sleep(10000)
End Do

ConOut("IMPPEDSIM_AND - FIM DA EXECUCAO")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Libera o ambiente que estava em uso.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù 

RpcClearEnv() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAITENPED ºAutor  ³Flavio Dias      º Data ³  11/01/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que monta os itens do pedido.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------------------------*
Static Function MontaItenPed(cIdPedido, cNumPed)     
*---------------------------------------------------*

Local aItemLinha 	:= {}
Local aItem      	:= {}
Local cItemNovo  	:= PadL("00", Len(SC6->C6_ITEM))
Local cWhere     	:= "IDPEDIDO = " + AllTrim(Str(cIdPedido,0)) + " AND (IDNEXCLUIDOERP <> 1 OR IDNEXCLUIDOERP IS NULL)"  // Flavio - 06/01/2012 - remove os itens excluídos pela manutenção
Local i, cTpConv, nFatConv
Local aArea      	:= GetArea()
Local cLocal    	:= "" 
Local cTesForaUF 	:= ""
Local cTesST 			:= ""
Local cSql   			:= ""
Local cUFsST 			:= ""
Local cTesCP 			:= ""
Local cUFsCP 			:= ""
Local cTpCli 			:= ""
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
cSql += "FROM MOD_PEDIDOPRODUTO "                                                                                                      +cEol
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtém o fator de conversão, a ser usado logo abaixo, na conversão para a segunda unidade.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	nFatConv := Iif(SB1->B1_TIPCONV == "M", 1 / SB1->B1_Conv, SB1->B1_Conv)

	aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})	
	aAdd(aItemLinha, {"C6_QTDVEN",ITEPED->QUANTIDADE,Nil})
	aAdd(aItemLinha, {"C6_PRCVEN",ITEPED->PRECOVENDA,Nil})
	aAdd(aItemLinha, {"C6_PRCTAB",ITEPED->PRECOORIGINAL,Nil})
	aAdd(aItemLinha, {"C6_VALOR",Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2),Nil})
	aAdd(aItemLinha, {"C6_ENTREG",dDataBase,Nil})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
	//³Jean - 22/07/13 - Ajustado para buscar o armazém do indicador de produto³
	//³Caso o produto não tiver indicador, busca o armazém padrão.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ
	
	DbSelectArea("SBZ")
	DbSetOrder(1)
	
	if DbSeek(xFilial("SBZ") + SB1->B1_COD)
		aAdd(aItemLinha, {"C6_LOCAL",SBZ->BZ_LOCPAD,Nil})
	Else
		aAdd(aItemLinha, {"C6_LOCAL",SB1->B1_LOCPAD,Nil})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a tabela de preço é promocional³
	//³Flavio - 22/09/2011                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³apenas seta o tipo de operação caso não seja pneu ou bonificação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if Substr(CABPED->IDSEGMENTO, 1, 3) == "005" .Or. cOper == "04"
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³seta apenas a operaçao que está sendo analisada, pois a conversao ja fica automatica³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if Empty(cOper)
			cOper := iif("CF" $ CABPED->IDTIPOPEDIDO, "03", "01")
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Jean (18/10/2012) - Tratativa para que todos os pedidos do segmento de pneus entrem com a seguinte regra:³
		//³Quando o tipo de cliente for Consumidor Final, usa operação "03", caso contrário, usa operação "01"    	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		if Substr(CABPED->IDSEGMENTO, 1, 3) == "005"
			if cTpCli == "S"
				cOper := "01"
			Else
				cOper := "03"
			EndIf
			ConOut("Segmento de Pneu: "+trim(CABPED->IDSEGMENTO)+" Tipo de Operação: "+trim(cOper))
		EndIf
		
		aAdd(aItemLinha, {"C6_OPER",cOper,Nil})
	else
		SF4->(dbSeek(xFilial("SF4") + SBZ->BZ_TS))
		cTes := SBZ->BZ_TS
		lMudaTES := .T.
 	EndIf
	                                             
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³avaliacao da mudança de TES na RJU³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	ConOut("Avalia mudança de TES " + cTesForaUF)
	if !lUfDif
		ConOut("UF do cliente igual da empresa")
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca a Tes do indicador de produto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Altera a tes caso a mesma tenha sido informada e a venda é para fora do estado.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lUfDif .And. !Empty(cTesForaUF) .And. (cOper != "04")
		cTes := cTesForaUF
		lMudaTES := .T.
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	if (cUFCli $ cUFsST .And. !Empty(cTesST)) .And. (cOper != "04")
		cTes := cTesST
		lMudaTES := .T.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Muda o tipo do cliente para solidário³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd(aCabPed, {"C5_TIPOCLI","S",Nil})
		
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de Credito Presumido para alguns produtos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if (cUFCli $ cUFsCP .And. !Empty(cTesCP)) .And. (cOper != "04")
		cTes := cTesCP
		lMudaTES := .T.
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
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Seta a segunda unidade³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !Empty(ITEPED->UNIDADE)
		nVlrSUn :=  Round(Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2) / ITEPED->QTDSEGUN, 2)
		
		aAdd(aItemLinha, {"C6_PRCSU", nVlrSUn,Nil})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³seta a primeria unidade, devido a alterar a segunda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		AADD(aItemLinha,{"C6_QTDVEN",ITEPED->QUANTIDADE,Nil})
		aAdd(aItemLinha, {"C6_UNSVEN", ITEPED->QTDSEGUN,Nil})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³seta a primeira unidade, devido a alterar a segunda		                              ³
		//³Tem que adicionar novamente o campo, independente de ele já existir,                 ³
		//³pois se alterar o conteúdo do campo existente vai dar erro ao inserir o pedido no SC6³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		AADD(aItemLinha,{"C6_PRCVEN",(ITEPED->QTDSEGUN * nVlrSUn) / ITEPED->QUANTIDADE,Nil})
		
		aAdd(aItemLinha, {"C6_IMPUNI","2",Nil})
	endif
	
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Se for vinho tem que vir o pedido sem liberação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	ConOut("Libera Pedido T/F : ")
	ConOut(lLibPed)
	if lLibPed .And. (CABPED->IDSEGMENTO != '003001001')
		aAdd(aItemLinha, {"C6_QTDLIB",ITEPED->QUANTIDADE,Nil})
	else
		aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})	
	EndIf
	
	if !Empty(ITEPED->LOTE)
		aAdd(aItemLinha, {"C6_LOTECTL",ITEPED->LOTE,Nil})
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Armazena o valor original do item para retornar para o SFA³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aAdd(aItemLinha, {"C6_X_VLORI",Round(ITEPED->QUANTIDADE * ITEPED->PRECOVENDA,2),Nil})
			
	ITEPED->(dbskip())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³adiciona no array de itens	³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aAdd(aItem, aItemLinha)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³limpa pra nao duplicar as informações³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	aItemLinha := {}
EndDo

ITEPED->(dbCloseArea())
  
Return aItem

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o processo de enviar o email caso ocorreu erro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*---------------------------------*
Static Function EnviaErro(cErro)   
*---------------------------------*

Local cVend := SubStr(CABPED->IDUSUARIO, 1, 6)
Local cEmailVend := ""
Local cCli := Substr(CABPED->IDLOCAL, 1, 6)
Local cLojaCli := Substr(CABPED->IDLOCAL, 8, 6)
Local oProcess
Local oHtml

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄN
//³Numero do Processo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄN

Local cProcess := OemToAnsi("008080") 
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

//@qui
oProcess:cTo := ALLTRIM(cEmail)
oProcess:cCC := cMailCC        
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz o processo de enviar o email para o vendedor confirmando da sincronização³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function EnviaPedOk(cPedSiga)
Local cVend := SubStr(CABPED->IDUSUARIO, 1, 6)
Local cEmailVend := ""
Local cCli := ""
Local cLojaCli := ""
Local oProcess
Local oHtml
Local cProcess := OemToAnsi("008080") 
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

//@qui  
oProcess:cTo := ALLTRIM(cEmail) 
oProcess:cCC := "sim3g@grupocantu.com.br" 
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBPEDAND ºAutor  ³Microsiga           º Data ³  14/03/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina chamada pela função StartJob para fazer a inclusão	º±±
±±º          ³ do pedido no Protheus.                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                               	º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------------------------------------------------------------------------------*
User Function JobPedAnd(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort)    
*--------------------------------------------------------------------------------------------------*

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
//U_USORWMAKE(ProcName(),FunName())

RpcClearEnv()

RpcSetType(3)
RpcSetEnv(cEmp, cFil,,,,GetEnvServer(),{ "SA1" })	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Cria o alias de cabeçalho de pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql :=	" SELECT  PED.IDPEDIDO, IDNPEDIDOLIDO, NUMEROPEDIDO as NUMPED, NUMEROPEDIDOCLIENTE as NUMPEDCLI, "
cSql +=	" HORATRANSMISSAO, "
cSql +=	"	TO_CHAR(DATAATUALIZACAO, 'yyyymmdd') as DATAATUALIZACAO, "
cSql +=	"	TO_CHAR(DATATRANSMISSAO, 'yyyymmdd') as DATATRANSMISSAO, "
cSql +=	"	TO_CHAR(DATAPEDIDO, 'yyyymmdd') as DATAPEDIDO, VALORTOTAL, "
cSql +=	"	IDLOCALFILIALFATURAMENTO, IDTABELAPRECO, IDCONDICAOPAGAMENTO, "
cSql +=	"	IDUSUARIO, IDTIPOPEDIDO, IDLOCAL "
cSql +=	"	FROM MOD_PEDIDO PED "
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
	cSqlUpd := "Update MOD_PEDIDO set IDNPEDIDOLIDO = 1 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
	//oSrv:callproc("TcSqlExec", cSqlUpd)
	TcSqlExec(cSqlUpd)
	
	if !lExist
		EnviaPedOk(cNumPed)			
		ConOut("Pedido Sincronizado com Sucesso")
	EndIf
	
elseif !lSemItens
	cSqlUpd := "Update MOD_PEDIDO set IDNPEDIDOLIDO = -1 WHERE IDPEDIDO = " + AllTrim(Str(CABPED->IDPEDIDO,0))
	
	//oSrv:callproc("TcSqlExec", cSqlUpd)
	TcQqlExec(cSqlUpd)
	
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
//rpcdisconnect(oSrv)
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
*-----------------------------------*
Static Function AvalLicit(aCabPed)   
*-----------------------------------*

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
cSql += "  AND C5.C5_SIM3GM = 'T' "
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função utilizada para avaliar Threads em execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function FreeAllThreads()

Local aUserInfoArray := GetUserInfoArray()
Local cEnvServer		 := GetEnvServer()
Local cComputerName	 := GetComputerName()
Local nThreads			 := 0
Local lFreeThreads   := .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_JOBPEDAND" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )