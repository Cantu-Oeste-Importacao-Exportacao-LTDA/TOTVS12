#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAARMAZENAGEMºAutor  ³Roberto Rosin  º Data ³ 10/11/2012  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera as notas de saída de armazenagem automáticamente quandoº±±
±±º          ³for documento de entrada e no cadastro de TES inteligente   º±±
±±º          ³estiver marcado para gerar armazenagem. É chamado no PE aposº±±
±±º          ³a inclusão da nota fiscal e nesse mesmo fonte na tela para  º±±
±±º          ³corrigir as notas que podem ter dado algum erro na inclusão º±±
±±º          ³do documento de entrada                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GERAARMAZENAGEM()
Local aArea        := GetArea()
private cMsgProc   := ""
private lExecutado := .F.
Public CLRF        := chr(13) + chr(10)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cMsgProc += Time() + " => " + "Processando Nota Fiscal " + SF1->F1_SERIE + "/" + SF1->F1_DOC + CLRF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se o documento já foi processado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("Z48")
Z48->(dbSetOrder(1))
Z48->(dbGoTop())
if !(Z48->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
	GERAPVARMAZ(@cMsgProc)
else
	if EMPTY(Z48->Z48_PEDIDO)
		GERAPVARMAZ(@cMsgProc)
	endIF
	
	cMsgProc += Time() + " => O pedido de armazenagem já foi gerado. Nº " + Z48->Z48_PEDIDO + CLRF
	
	if empty(Z48->Z48_NFARMA)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Gera a nota fiscal do pedido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		FatPedido(Z48->Z48_PEDIDO, '1', @cMsgProc)
	else
		cMsgProc += Time() + " => Nota fiscal de remessa para armazenagem já gerada. Nº " + Z48->Z48_NFARMA + "/" + Z48->Z48_SERARM + CLRF
	endIf
endIf

if lExecutado
	Aviso("Processo Armazenagem",cMsgProc,{"OK"},3)
endIF

RestArea(aArea)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAPVARMAZºAutor  ³ Roberto Rosin      º Data ³ 19/11/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera pedido de venda para armazenagem para a empresa armazemº±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function GERAPVARMAZ(cMsgProc)

Local _cOper     := "74"//Remessa para Armazenagem
Local cCli       := ""
Local cLoja      := ""
Local cTipoCli   := ""
Local nItem      := 1
Local cNumPed    := 0
Local lPrimeiro  := .T.
Local lInsePedi  := .F.
Local aLinha     := {}
Local aItensPed  := {}
Local aCabPed    := {}
Local aLinha     := {}
Local aAreaEmpr  := {}      
Local cSeg		 := ""	

dbSelectArea("SD1")
SD1->(dbSetOrder(1))
SD1->(dbGoTop())
if (SD1->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
	
	while (SD1->(!eof())) .and. (SD1->D1_FILIAL  = SF1->F1_FILIAL  .and.;
	                             SD1->D1_DOC     = SF1->F1_DOC     .and.;
	                             SD1->D1_SERIE   = SF1->F1_SERIE   .and.;
	                             SD1->D1_FORNECE = SF1->F1_FORNECE .and.;
	                             SD1->D1_LOJA    = SF1->F1_LOJA)
		
		aLinha := {}
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Se o tipo de operação for 50 - AQUISICAO DE MERCADORIA - ARMAZENAGEM, gera a armazenagem do produto.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		if SD1->D1_X_OPER == '50'
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Variável para mostrar a mensagem de processamento ou não³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			lExecutado := .T.
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Monta um array com os campos do movimento do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			aadd(aLinha,{"C6_ITEM"   , StrZero(nItem,TamSx3("C6_ITEM")[1]) ,Nil})
			aadd(aLinha,{"C6_PRODUTO", SD1->D1_COD                         ,Nil})
			aadd(aLinha,{"C6_QTDVEN" , SD1->D1_QUANT                       ,Nil})
			aadd(aLinha,{"C6_PRCVEN" , SD1->D1_VUNIT                       ,Nil})
			aadd(aLinha,{"C6_OPER"   , _cOper                              ,Nil})
		
			aAdd(aItensPed, aLinha)
			nItem++
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Se for a primeira vez que estiver no laço, monta um array com os dados do cabeçalho do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			if lPrimeiro
				lPrimeiro := .F.
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				//³Busca na tabela de Empresa X Armazém, qual é o armazém cadastrado para a empresa atual³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
				dbSelectArea("Z47")
				Z47->(dbSetOrder(1))
				Z47->(dbGoTop())
				if (Z47->(dbSeek(xFilial("Z47")+cEmpAnt+cFilAnt)))
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Salva os dados da empresa que está logada no sistema³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					aAreaEmpr := SM0->(GetArea())
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Selecoiona os dados da empresa armazém para gerar o pedido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					SM0->(DbSelectArea("SM0"))
					SM0->(dbSetOrder(1))
					SM0->(dbGoTop())
					While !SM0->(Eof())
						If Z47->Z47_EMPARM == SM0->M0_CODIGO .and. Z47->Z47_FILARM  == SM0->M0_CODFIL
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							//³Posiciona no cadastro de clientes para buscar os dados da empresa armazem³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
							dbSelectArea("SA1")
							SA1->(dbSetOrder(3))
							SA1->(dbGoTop())
							SA1->(dbSeek(xFilial("SA1")+SM0->M0_CGC))
								cCli     := SA1->A1_COD
								cLoja    := SA1->A1_LOJA
								cTipoCli := SA1->A1_TIPO
							exit
						Endif
						SM0->(DbSkip())
					endDo
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Reposiciona na empresa logada³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					RestArea(aAreaEmpr)    
				

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Caso o segmento seja de pneus, deverá fixar o segmento de transferencia³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If Substr(SD1->D1_CLVL,1,3) == "005"
						cSeg := "005003002"
					Else
						cSeg := SD1->D1_CLVL 					
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					//³Monta um array com os dados do cabeçalho do pedido³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
					aCabPed:= {{"C5_TIPO"   , "B"          , Nil},; // Tipo de pedido
	             			    {"C5_CLIENTE", cCli        , Nil},; // Codigo do cliente
			             	    {"C5_LOJACLI", cLoja       , Nil},; // Loja do cliente
			                  	{"C5_TIPOCLI", cTipoCli    , Nil},; // Revenda
			                  	{"C5_VEND1"  , "P00000"    , Nil},; // Vendedor
			                  	{"C5_TABELA" , "   "       , Nil},; // Tabela
			                  	{"C5_CONDPAG", "001"       , Nil},; // Condicao Pagamento
  				                {"C5_X_CLVL" , cSeg		   , Nil}}  // Segmento	
			                	//Gustavo 15/08/2014 - Tratativa de segmento para o pneus
   			                	//{"C5_X_CLVL" , SD1->D1_CLVL, Nil}}  // Segmento
                                            	
				else
					Alert("Empresa x Armazém não cadastrados. Favor realizar o cadastro do armazém para a empresa atual.")
					return nil
				endIf
				
			endIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Define que vai inserir o pedido de venda para a empresa que vai armazenar o produto³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			lInsePedi := .T.
		endIf
		SD1->(dbSkip())
	endDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Se a nota fiscal vai gerar pedido de venda para armazenagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	if lInsePedi
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica o próximo número de pedido no controle de númeração³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cNumPed := GetSxeNum("SC5","C5_NUM")
		aAdd(aCabPed, {"C5_NUM", cNumPed, Nil})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Retorna a númeração, pois é preciso passar o número para o SX8 porém o mesmo incrementa sozinho³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		ROLLBACKSX8()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Executa rotina padrão para a inclusão de pedido³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cMsgProc += Time() + " => " + "Gravando pedido -> " + cNumPed + CLRF
		MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItensPed,3)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se o pedido foi incluído³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		dbSelectArea("SC5")
		SC5->(dbSetOrder(01))
		SC5->(dbGoTop())
		lIncluido := SC5->(dbSeek(xFilial("SC5") + cNumPed))
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Verifica se o pedido foi incluído e confirma ou retorna a númeração do controle de númeração³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		if (lIncluido)
			ConfirmSX8()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Grava na tabela de Nota x Pedido Armazenagem o número da nota de entrada e o pedido de armazenagem³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			BEGIN TRANSACTION
				RecLock("Z48", .T.)	
 					Z48->Z48_FILIAL := xFilial("Z48")
					Z48->Z48_NFENTR := SF1->F1_DOC
					Z48->Z48_SEENTR := SF1->F1_SERIE
					Z48->Z48_FORNEC := SF1->F1_FORNECE
					Z48->Z48_LOJA   := SF1->F1_LOJA
					Z48->Z48_PEDIDO := cNumPed
				Z48->(MsUnlock())
			END TRANSACTION
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Gera a nota fiscal do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			FatPedido(cNumPed, "1", @cMsgProc)
		else
			ROLLBACKSX8()
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			//³Mostra o erro para o usuário³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			cErro := MostraErro("\")
			cMsgProc += Time() + " => " + "Não foi possível gerar o pedido. Erro : " + CLRF
			cMsgProc += cErro + CLRF
		endIf
	endIf
endIf

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FATPEDIDO ºAutor  ³Roberto Rosin        º Data ³ 12/11/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o faturamento do pedido.                               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FatPedido(cPedido, cSerie, cMsgProc)
Local cSql    := ""
local cPed    := ""
local cAlias  := getNextAlias() 
local aPvlNfs := {}


cMsgProc += Time() + " => " + "Processando a NF de saída para armazenagem " + CLRF

cSql := "SELECT C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM, C9.C9_SEQUEN, C9.C9_QTDLIB, C9.C9_PRCVEN, C9.C9_PRODUTO, F4.F4_ISS, C9_QTDLIB2, "
cSql += "B2_LOCAL, C9.R_E_C_N_O_ AS C9_RNO, "
cSql += "  C6.R_E_C_N_O_ AS C6_RNO, "
cSql += "  C5.R_E_C_N_O_ AS C5_RNO, "
cSql += "  F4.R_E_C_N_O_ AS F4_RNO, "
cSql += "  E4.R_E_C_N_O_ AS E4_RNO, "
cSql += "  B1.R_E_C_N_O_ AS B1_RNO, "
cSql += "  B2.R_E_C_N_O_ AS B2_RNO "

cSql += "FROM "+RetSqlName("SC9")+" C9 "
cSql += "LEFT JOIN "+RetSqlName("SC6")+" C6 ON C9.C9_FILIAL = C6.C6_FILIAL AND C9.C9_PEDIDO = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM "
cSql += "LEFT JOIN "+RetSqlName("SC5")+" C5 ON C9.C9_FILIAL = C5.C5_FILIAL AND C9.C9_PEDIDO = C5.C5_NUM "
cSql += "LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4.F4_CODIGO = C6.C6_TES "
cSql += "LEFT JOIN "+RetSqlName("SE4")+" E4 ON E4.E4_CODIGO = C5.C5_CONDPAG "
cSql += "LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD = C9.C9_PRODUTO "
cSql += "LEFT JOIN "+RetSqlName("SB2")+" B2 ON B2.B2_FILIAL = C6.C6_FILIAL AND B2.B2_COD = C6.C6_PRODUTO AND B2.B2_LOCAL = C6.C6_LOCAL "
cSql += "WHERE C6.D_E_L_E_T_ <> '*'  "
cSql += "  AND C9.D_E_L_E_T_ <> '*' "
cSql += "  AND C5.D_E_L_E_T_ <> '*' "
cSql += "  AND F4.D_E_L_E_T_ <> '*' "
cSql += "  AND E4.D_E_L_E_T_ <> '*' "
cSql += "  AND B1.D_E_L_E_T_ <> '*' "
cSql += "  AND B2.D_E_L_E_T_ <> '*' "
cSql += "  AND C9.C9_FILIAL = '"+xFilial("SC9")+"' "
cSql += "  AND C5_NUM = '"+cPedido+"' "
cSql += "ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM "

/*if Aviso("Sql",cSql,{"Sim","Não"},3) != 1
	Return Nil
EndiF*/

TcQuery cSql NEW ALIAS (cAlias)
cPed := (cAlias)->C9_PEDIDO
If !(cAlias)->(Eof())
	While (cAlias)->(!Eof())
		aPvlNfs := {}
		dbSelectArea(cAlias)
		(cAlias)->(dbGoTop())
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Monta um array com para passar por parâmetro para montar a nota³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		While cPed == (cAlias)->C9_PEDIDO
				aadd(aPvlNfs,{ (cAlias)->C9_PEDIDO,;
								 (cAlias)->C9_ITEM,;
								 (cAlias)->C9_SEQUEN,;
								 (cAlias)->C9_QTDLIB,;
								 (cAlias)->C9_PRCVEN,;
								 (cAlias)->C9_PRODUTO,;
								 (cAlias)->F4_ISS=="S",;
								 (cAlias)->C9_RNO,;
								 (cAlias)->C5_RNO,;
								 (cAlias)->C6_RNO,;
								 (cAlias)->E4_RNO,;
								 (cAlias)->B1_RNO,;
								 (cAlias)->B2_RNO,;
								 (cAlias)->F4_RNO,;
								 (cAlias)->B2_LOCAL,;
								 0,;
								 (cAlias)->C9_QTDLIB2})
							
			(cAlias)->(dbSkip())
		EndDo
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Função do Protheus para gerar notas fiscais de saída a partir de pedidos de venda liberados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		cMsgProc += Time() + " => " + "Inserindo a NF de saída para armazenagem" + CLRF
		cSerie := infoSerie()
		Pergunte("MT460A",.F.)
		cNotaSaida := MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.T.,.F.,0,0,.F.,.F.)
	EndDo
else
	Return
EndIf

dbSelectArea("SD2")
SD2->(dbSetOrder(08))
SD2->(dbGoTop())

if SD2->(dbSeek( xFilial("SD2") + cPedido))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Atualiza o número das notas fiscais na tabela de Armazenagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	cNumeroNf := SD2->D2_DOC
	cSerieNf  := SD2->D2_SERIE
	cArmazem  := SD2->D2_CLIENTE
	cLojaArma := SD2->D2_LOJA
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Inicia o controle de transação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	BEGIN TRANSACTION
		dbSelectArea("Z48")
		Z48->(dbSetOrder(1))
		Z48->(dbGoTop())
		if (Z48->(dbSeek(SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)))
			RECLOCK("Z48", .F.)
				Z48->Z48_NFARMA := cNumeroNf
				Z48->Z48_SERARM := cSerieNf
				Z48->Z48_ARMAZE := cArmazem
				Z48->Z48_LOJAAR := cLojaArma
			Z48->(MSUNLOCK())
		endIF
	END TRANSACTION
		
	cMsgProc += Time() + " => " + "Faturado NF de saída Nº: " + SD2->D2_SERIE + "/" + SD2->D2_DOC + CLRF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama a função para gerar o Workflow de nota de armazenagem³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_GEWFARMAZENAGEM(cNumeroNf,cSerieNf,cArmazem,cLojaArma)
else
	cMsgProc += Time() + " => " + "Não foi possível gerar a NF de saída. Erro: " + CLRF

EndIf
(cAlias)->(dbCloseArea())
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CORRNFARMAZENºAutor  ³Roberto Rosin     º Data ³ 19/11/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Tela para corrigir as notas que ocorreu algum erro no momen-º±±
±±º          ³to da inclusão do documento de entrada                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function CORRNFARMAZEN()
local cPerg := "GERAARMAZE"
local cFilial := ""
local cDoc    := ""
local cSerie  := ""
local cForn   := ""
local cLoja   := ""
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ajustaSX1(cPerg)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Monta uma tela de perguntas para informar o documento que será reprocessado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
if !Pergunte(cPerg, .T.)
	return nil
endIf

cFilial := MV_PAR01
cDoc    := MV_PAR02
cSerie  := MV_PAR03
cForn   := MV_PAR04
cLoja   := MV_PAR05

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Posiciona o registro no documento informado e chama a função para reprocessar o documento³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SF1")
SF1->(dbSetOrder(1))
SF1->(dbGoTop())
if SF1->(dbSeek(cFilial+cDoc+cSerie+cForn+cLoja))
	U_GERAARMAZENAGEM()
else
	Alert("Não foi encontrado o documento de entrada!")
endIF

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJUSTASX1 ºAutor  ³Roberto Rosin       º Data ³  31/10/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função de criação de grupo de perguntas no SX1              º±±
±±º          ³(Passada por Marcelo Joner em treinamento)                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Totvs Paraná Central                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function AJUSTASX1(cPerg)

aRegs  	:= {}  
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}
aHelp4  := {}
aHelp5  := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ                                                                                                                                                                                                                                                             
AADD(aRegs, {cPerg,"01","Filial     ","Filial     ","Filial     ","mv_ch1" ,"C",2                       ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",   "","", "@1"})
AADD(aRegs, {cPerg,"02","Documento  ","Documento  ","Documento  ","mv_ch2" ,"C",TAMSX3("F1_DOC")[1]     ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF1","",   "","", PesqPict("SF1", "F1_DOC")})
AADD(aRegs, {cPerg,"03","Serie      ","Serie      ","Serie      ","mv_ch3" ,"C",TAMSX3("F1_SERIE")[1]   ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SF1","",   "","", PesqPict("SF1", "F1_DOC")})
AADD(aRegs, {cPerg,"04","Fornecedor ","Fornecedor ","Fornecedor ","mv_ch4" ,"C",TAMSX3("F1_FORNECE")[1] ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SF1","",   "","", PesqPict("SF1", "F1_FORNECE")})
AADD(aRegs, {cPerg,"05","Loja       ","Loja       ","Loja       ","mv_ch5" ,"C",TAMSX3("F1_LOJA")[1]    ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","SF1","",   "","", PesqPict("SF1", "F1_LOJA")})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Montagem do Help de cada item do Grupo de Perguntas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
AADD(aHelp1 , "Informe o número da filial que o documento ") 
AADD(aHelp1 , "de entrada foi lançado                     ") 
AADD(aHelp2 , "Informe o numero do documento de enrtada   ") 
AADD(aHelp3 , "Informe a série do documento de enrtada    ")
AADD(aHelp4 , "Informe o fornecedor do documento de entra-")
AADD(aHelp4 , "da                                         ")
AADD(aHelp5 , "Informe a loja do fornecedor do documento  ")
AADD(aHelp5 , "de entrada                                 ") 

        
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Realiza a gravação dos itens do grupo de perguntas no SX1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
dbSelectArea("SX1")
dbSetOrder(1)                                                    
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RECLOCK("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
		SX1->(MSUNLOCK())
	Endif
Next  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza o Help dos parametros no arquivo de Help   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PutSX1Help("P." + cPerg + "01.", aHelp1 , aHelp1 , aHelp1 )
PutSX1Help("P." + cPerg + "02.", aHelp2 , aHelp2 , aHelp2 )
PutSX1Help("P." + cPerg + "03.", aHelp3 , aHelp3 , aHelp3 )
PutSX1Help("P." + cPerg + "04.", aHelp4 , aHelp4 , aHelp4 )
PutSX1Help("P." + cPerg + "05.", aHelp5 , aHelp5 , aHelp5 )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ`ÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³INFOSERIE ºAutor  ³Roberto Rosin        º Data ³ 20/11/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Mostra uma tela para o usuário informar a série da nota fis-º±±
±±º          ³cal de saída para armazenagem que será utilizada            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Específico Cantu                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static Function infoSerie()                                      
Static oDlgSerie
local oButton1
local oSay1
local oSerie
local cSerie := space(3)

  DEFINE MSDIALOG oDlgSerie TITLE "Serie Nota Armazenagem" FROM 000, 000  TO 080, 180 COLORS 0, 16777215 PIXEL

    @ 004, 004 SAY oSay1 PROMPT "Serie" SIZE 015, 007 OF oDlgSerie COLORS 0, 16777215 PIXEL
    @ 003, 020 MSGET oSerie VAR cSerie SIZE 060, 010 OF oDlgSerie COLORS 0, 16777215 PIXEL
    @ 018, 055 BUTTON oButton1 PROMPT "Ok" SIZE 025, 012 ACTION {||oDlgSerie:End()} OF oDlgSerie PIXEL
  ACTIVATE MSDIALOG oDlgSerie

return cSerie