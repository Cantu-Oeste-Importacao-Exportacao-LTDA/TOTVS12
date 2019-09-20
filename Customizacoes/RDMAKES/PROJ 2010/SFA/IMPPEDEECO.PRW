#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE CIPSERVER 	"192.168.220.6"          // IP do serviço Protheus responsável pela importação dos pedidos
#DEFINE MAX_PED  	10                   	// Tamanho máximo da fila para importação de pedidos       
#DEFINE MAX_HORA  	"17:00:00"               // Ponto de corte inicial para liberação automática de pedidos
#DEFINE MIN_HORA  	"05:00:00"               // Ponto de corte final para liberação automática de pedidos
#DEFINE LCORTA		.F.                  	// Indica se os itens sem saldo no controle de lotes deverão ser cortados.  



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPPEDEECO ºAutor  ³JEAN SAGGIN        º Data ³  27/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Função para importação dos pedidos do sistema de força    º±±
±±º          ³  de vendas eEco                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Schedule                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function IMPPEDEECO()    
*--------------------------*
Local aItemPed   := {}
Local cErro      := ""
Local aEmpFil    := {}
Local cSql       := ""
Local cTipoCli   := ""

Private cIP        := CIPSERVER
Private cPort      := FGETPORT()

Private aCabPed   := {}
Private cSegmento := ""
Private lSemItens := .F.           
Private cEmpIni		:= "50"
Private cFilIni		:= "01"
Private nX        := 0
Private aPedidos  := {}
Private nLock     := 0
Private nQtdPed   := 0
Private cEol      := CHR(13)+CHR(10)
Private lAguarda  := .F.       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("IMPPEDEECO - INICIANDO IMPORTACAO DE PEDIDOS") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Recupera empresa/filial do APPSERVER.INI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2)
cCODFIL := SubSTR(cEMPFIL,4,2)

//@qui..
//cCODEMP := "50"
//cCODFIL := "01"

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
	ConOut("IMPPEDEECO - EXECUTANDO PARA EMPRESA "+cEmpIni) 
Else
	ConOut("IMPPEDEECO - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN") 
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o sistema em uma empresa para dar início na seleção dos dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RpcClearEnv()
RPCSetType(3)

RpcSetEnv(cEmpIni, cFilIni,,,,"EECO",{ "SC5", "SC6", "SF4", "SA1" })	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criação de arquivo temporário sobre a execução da rotina³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"IMPPEDEECO"+cCODEMP,"IMPPEDEECO"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)                                    	
	If nLock > 10                                 
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois já esta sendo executada!")
		Return
	EndIf		
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Busca quais empresas tem pedido para importar e ordena pela que tem mais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ

cSql := "select distinct empresa, filial, count(*) as quant from eeco_pedido ped "
cSql += "where ped.status = 0" 
cSql += "  and ped.empresa <> ' ' "
cSql += "  and ped.filial <> ' ' " 

//@qui...
//cSql += "  and Trim(ped.empresa) = '50' "
//cSql += "  and Trim(ped.filial) = '01' "

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cSql += "  and ped.empresa = '"+cCODEMP+"' "
EndIf
cSql += "group by empresa, filial "
cSql += "order by quant desc "

TcQuery cSql New Alias "empfil"

DbSelectArea("empfil")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se o retorno não é vazio³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if empfil->(Eof())
	empfil->(DbCloseArea())	
	ConOut("IMPPEDEECO - SEM PEDIDOS A IMPORTAR")
	Return
EndIf

While empfil->(!Eof())
	nTmpQtd := 0
	if nQtdPed >= MAX_PED
		Exit               
	Else
		if (nQtdPed + empfil->quant) > MAX_PED
			nTmpQtd := MAX_PED - nQtdPed
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {empfil->empresa, empfil->filial, nTmpQtd})
		Else
			nTmpQtd := empfil->quant
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {empfil->empresa, empfil->filial, nTmpQtd})
		EndIf                                                      
	EndIf 
	empfil->(dbSkip())
EndDo

empfil->(DbCloseArea())

For nEmp := 1 to len(aEmpFil)           

	If !Empty(cCODEMP) .and. !Empty(cCODFIL)
		cFilAnt := aEmpFil[nEmp,02]	                                        
	Else
		RpcClearEnv()
		RPCSetType(3)		
		RpcSetEnv(Transform(aEmpFil[nEmp,01], "@! 99"), Transform(aEmpFil[nEmp,02], "@! 99" ),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	EndIf
		
	ConOut("IMPPEDEECO - BUSCANDO PEDIDOS DA EMPRESA "+aEmpFil[nEmp,01]+" FILIAL "+aEmpFil[nEmp,02])
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "0"³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	cSql := "select pedido.idpedido, "                                                 +cEol
	cSql += "       pedido.status, "                                                   +cEol
	cSql += "       to_char(pedido.dtpedido, 'yyyymmdd') as dtpedido, "                +cEol
	cSql += "       to_char(pedido.dtpedido, 'hh24:mi:ss') as horapedido, "            +cEol
	cSql += "       SubStr(pedido.segmento,01,09) as segmento, "                       +cEol
	cSql += "       cast(pedido.obs as varchar(3000)) as obs, "                        +cEol
	cSql += "       to_char(pedido.dataprocessamento, 'yyyymmdd') as dtdispon, "       +cEol
	cSql += "       to_char(pedido.dataprocessamento, 'hh24:mi:ss') as horadispon, "   +cEol
	cSql += "       pedido.valortotal, "                                               +cEol
	cSql += "       Trim(pedido.empresa) as empresa, "                                 +cEol
	cSql += "       Trim(pedido.filial) as filial, "                                   +cEol
	cSql += "       SubStr(pedido.tabela,01,03) as tabela, "                           +cEol
	cSql += "       SubStr(pedido.formapagamento,01,03) as formapagamento, "           +cEol
	cSql += "       pedido.codtrans, "                                                 +cEol
	cSql += "       SubStr(pedido.vendedorerp,01,06) as vendedorerp, "                 +cEol
	cSql += "       SubStr(pedido.cliente,01,09) as cliente, "                         +cEol
	cSql += "       SubStr(pedido.loja,01,04) as loja, "                               +cEol
	cSql += "       to_char(pedido.dataentrega, 'yyyymmdd') as dataentrega "           +cEol
	cSql += "from eeco_pedido pedido "                                                 +cEol
	cSql += "where pedido.empresa = '"+ AllTrim(aEmpFil[nEmp, 01]) +"' "               +cEol
	cSql += "  and pedido.filial = '"+ AllTrim(aEmpFil[nEmp, 02]) +"' "                +cEol
	cSql += "  and pedido.status = 0 "                                                 +cEol
	cSql += "  and rownum <= "+ AllTrim(Str(aEmpFil[nEmp, 03]))                        +cEol
	cSql += "order by pedido.idpedido"
	
	TCQUERY Upper(cSql) NEW ALIAS "pedido"
	
	DbSelectArea("pedido")
	pedido->(DbGoTop())
	
	aPedidos := {}
	
	while !pedido->(eof())
		aAdd(aPedidos, {pedido->idpedido,; 
										pedido->status,;
										pedido->dtpedido,; 
										pedido->horapedido,;
										SubStr(pedido->segmento,01,09),;
										pedido->obs,;
										pedido->dtdispon,;
										pedido->horadispon,;
										pedido->valortotal,;
										Trim(pedido->empresa),;
										Trim(pedido->filial),;
										SubStr(pedido->tabela,01,03),;
										SubStr(pedido->formapagamento,01,03),;
										pedido->codtrans,;
										SubStr(pedido->vendedorerp,01,06),;
										SubStr(pedido->cliente,01,09),;
										SubStr(pedido->loja,01,04),;
										pedido->dataentrega})
		pedido->(DbSkip())
	EndDo
	
	pedido->(DbCloseArea())
	
	If Len(aPedidos) > 0
		IncluiPedido(aPedidos)     
	EndIf

Next nEmp

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia threads em execução e aguarda até que todos os pedidos sejam incluídos pra finalizar a rotina
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

While !FreeAllThreads()
	Sleep(10000)
End Do

ConOut("IMPPEDEECO - FIM DA EXECUCAO")

RpcClearEnv() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IncluiPedido ºAutor  ³Jean Saggin      º Data ³  29/05/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que monta os itens do pedido.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IncluiPedido(aPedidos)     
  
	lAguarda := .F.
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Chamada da função para fazer o ajuste do status dos pedidos em processamento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	AltStatus(aPedidos)     	   
	
	For nX := 1 to len(aPedidos)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valida se já existe algum pedido cadastrado no sistema com o mesmo código de Licitação.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aTemp  := {}
		aAdd(aTemp, {"C5_FILIAL"  ,aPedidos[nX, 11], Nil})
		aAdd(aTemp, {"C5_COTACAO" ,AllTrim(Str(aPedidos[nX, 01],0)), Nil})
			
		lExist := AvalLicit(aTemp)
		
		if lExist
			GrvStatus(AllTrim(Str(aPedidos[nX, 01],0)), 2, "PEDIDO JA IMPORTADO ANTERIORMENTE")
			Loop
		EndIf
		
		aCabPed := {}
		cErro 	:= ' '
				
		ConOut("IMPPEDEECO - ID PEDIDO " + AllTrim(Str(aPedidos[nX, 01],0)))

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do cabeçalho do pedido.³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		aAdd(aCabPed, {"C5_FILIAL",  aPedidos[nX, 11], Nil})
		aAdd(aCabPed, {"C5_TIPO",    "N", Nil})		
		aAdd(aCabPed, {"C5_COTACAO", AllTrim(Str(aPedidos[nX, 01],0)), Nil})
		aAdd(aCabPed, {"C5_CLIENTE", aPedidos[nX, 16],Nil})		
		aAdd(aCabPed, {"C5_LOJACLI", aPedidos[nX, 17],Nil})
    
		cOper    := " "
		lConsFin := .F.
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Posiciona o sistema na tabela de clientes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
		DbSelectArea("SA1")
		SA1->(dbSetOrder(01))
		if SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 16] + aPedidos[nX, 17]))
			cTipoCli := AllTrim(SA1->A1_TIPO)
			cDesTipo := iif(cTipoCli == 'F',"CONSUMIDOR FINAL",iif(cTipoCli == 'L',"PRODUTOR RURAL",;
									iif(cTipoCli == 'R',"REVENDEDOR"      ,iif(cTipoCli == 'S',"SOLIDARIO",;
									iif(cTipoCli == 'X',"EXPORTACAO"      ," "))))) 
			Conout("IMPPEDEECO - CLIENTE: "+AllTrim(SubStr(SA1->A1_NOME,1,30))+ " ("+ cDesTipo +")")
		Else
			cErro := "CLIENTE "+ aPedidos[nX, 16] +" LOJA "+ aPedidos[nX, 17] +" NÃO ENCONTRADO"                    
			GrvStatus(AllTrim(Str(aPedidos[nX, 01],0)), -1, cErro)
			EnviaErro(cErro, {}, {}, 1)
			Loop     
		EndIf
    
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Avalia bloqueio do cliente³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if SA1->A1_MSBLQL == '1'
			cErro := "CLIENTE "+ aPedidos[nX, 16] +"/"+ aPedidos[nX, 17] +" - "+ SubStr(SA1->A1_NOME, 01, 30) +" ESTÁ BLOQUEADO."                    
			GrvStatus(AllTrim(Str(aPedidos[nX, 01],0)), -1, cErro)
			EnviaErro(cErro, {}, {}, 1)
			Loop
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
		//³Avalia se cliente é consumidor final³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù
		
		lConsFin := AllTrim(SA1->A1_TIPO) == 'F'
		if lConsFin
			cOper := '03' 
		Else
			cOper := '01' 
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Avalia se a condição de pagamento do pedido é '350' - Bonificação³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
		if aPedidos[nX, 13] == '350'
			cOper := '04' 
		EndIF
			
		aAdd(aCabPed, {"C5_TIPOCLI",cTipoCli,Nil})
		aAdd(aCabPed, {"C5_TABELA" ,aPedidos[nX, 12],Nil})
		aAdd(aCabPed, {"C5_CONDPAG",aPedidos[nX, 13],Nil})
  	aAdd(aCabPed, {"C5_VEND1"  ,aPedidos[nX, 15],Nil})
  	aAdd(aCabPed, {"C5_PEDCLI" ," ",Nil})
  	aAdd(aCabPed, {"C5_MENNOTA",iif(Empty(aPedidos[nX, 06]), " ", aPedidos[nX, 06]),Nil})
  	aAdd(aCabPed, {"C5_EMISSAO",StoD(aPedidos[nX, 03]),Nil})
  	aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil}) 
 		aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
  	
  	cNumPed := GetSxeNum("SC5","C5_NUM")
  	
  	aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
  	aAdd(aCabPed, {"C5_X_EECO" ,.T.,Nil})
  	aAdd(aCabPed, {"C5_X_CLVL" ,aPedidos[nX, 05],Nil})		
		
		lSemItens := .F.
  	ConfirmSX8()
  	  	
  	aItemPed := BuscaItens(AllTrim(Str(aPedidos[nX, 01],0)), cNumPed, @lSemItens)
		
  	If lSemItens                                       
			cErro := "PEDIDO SEM PRODUTOS"
			GrvStatus(AllTrim(Str(aPedidos[nX, 01],0)), -1, cErro)
			EnviaErro(cErro, aCabPed, aItemPed, 1)                                     
			Loop
		Else 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Chamada de uma nova thread para a inclusão do pedido³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			StartJob("U_JOBPEDEECO", GetEnvServer(), lAguarda, cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort)

  	EndIf
	
	Next nX
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³BuscaItens   ºAutor  ³Jean Saggin      º Data ³  29/05/13   º±±
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
Static Function BuscaItens(cIdPedido, cNumPed, lSemItens)     
*---------------------------------------------------*

Local aItemLinha 	:= {}
Local i, nFatConv := 0
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

Private aItem     := {}   
Private aCortes   := {}
Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
      
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca dos itens relacionados ao pedido que está sendo processado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "select SubStr(itens.codigoauxiliar_item,01,15) as codigo, "            +cEol
cSql += "       itens.quantidade, "                                             +cEol
cSql += "       itens.valorunitarionormal as vlrunitario, "                     +cEol
cSql += "       itens.valorunitariobruto as precovenda, "                       +cEol
cSql += "       itens.descontoitem / itens.quantidade as descunit, "            +cEol
cSql += "       itens.descontoitem as desctotal, "                              +cEol
cSql += "       itens.valorunitariobruto as vlrstrib, "                         +cEol
cSql += "				itens.promocao, "   				                                    +cEol
cSql += "       itens.bonificado, "                                             +cEol
cSql += "       itens.embalagem as unidade, "                                   +cEol
cSql += "       itens.codigokit, "                                              +cEol
cSql += "       itens.idpedido "                                                +cEol
cSql += "from eeco_itens itens "                                                +cEol
cSql += "where idpedido = "+ cIdPedido

TCQUERY cSql NEW ALIAS "itens"

dbSelectArea("itens")
itens->(dbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Avalia se o pedido tem itens³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

If itens->(Eof())
	lSemItens := .T.
	itens->(DbCloseArea())
	Return aItem
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona no cliente para buscar o Estado e o Tipo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cUFCli := Posicione("SA1", 01, xFilial("SA1") + aPedidos[nX, 16] + aPedidos[nX, 17], "A1_EST")
cTpCli := Posicione("SA1", 01, xFilial("SA1") + aPedidos[nX, 16] + aPedidos[nX, 17], "A1_TIPO")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

While (itens->(!Eof()))	
	
	lMudaTES  := .F.
	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLinha, {"C6_NUM"        ,cNumPed,Nil})
	aAdd(aItemLinha, {"C6_ITEM"       ,cItemNovo,Nil})  
	aAdd(aItemLinha, {"C6_PRODUTO"    ,AllTrim(itens->codigo),Nil})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Posiciona na tabela de produto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

	DbSelectArea("SB1")
	SB1->(dbSetOrder(01))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(itens->codigo)))
	
	lLote := .F.
	lLote := SB1->B1_RASTRO == "L"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratativa da segunda unidade de medida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lSegUn  := .F.
	nQtdPUM := 0
	nValPUM := 0
	
	If !Empty(itens->unidade)
		Do Case
			Case AllTrim(itens->unidade) == SB1->B1_UM
				aAdd(aItemLinha, {"C6_IMPUNI", "1", Nil})
				aAdd(aItemLinha, {"C6_QTDVEN",itens->quantidade,Nil})
				aAdd(aItemLinha, {"C6_PRCVEN",itens->precovenda,Nil})				

			Case AllTrim(itens->unidade) == SB1->B1_SEGUM
				lSegUn := .T.
				aAdd(aItemLinha, {"C6_IMPUNI", "2", Nil})
				aAdd(aItemLinha, {"C6_UNSVEN", itens->quantidade, Nil})
				aAdd(aItemLinha, {"C6_PRCSU", itens->precovenda, Nil}) 

				if Trim(SB1->B1_TIPCONV) == 'M'
					nQtdPUM := Round(itens->quantidade / SB1->B1_CONV,TamSx3("C6_QTDVEN")[02])
					nValPUM := Round(itens->precovenda * SB1->B1_CONV,TamSx3("C6_PRCVEN")[02])
				Else 
					nQtdPUM := Round(itens->quantidade * SB1->B1_CONV,TamSx3("C6_QTDVEN")[02])
					nValPUM := Round(itens->precovenda / SB1->B1_CONV,TamSx3("C6_PRCVEN")[02])	
				EndIf
				
				aAdd(aItemLinha, {"C6_QTDVEN", nQtdPUM, Nil})
				aAdd(aItemLinha, {"C6_PRCVEN", nValPUM, Nil})
		EndCase	    
	Else
		aAdd(aItemLinha, {"C6_QTDVEN",itens->quantidade,Nil})
		aAdd(aItemLinha, {"C6_PRCVEN",itens->precovenda,Nil})						
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Posiciona na tabela de Indicador de Produto³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SBZ")
	SBZ->(dbSetOrder(1))
	SBZ->(dbSeek ( xFilial("SBZ") + AllTrim(itens->codigo)))
	
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
		
		If !Empty(ZZATMP->ZZA_TESUFD)
			cTesForaUF := ZZATMP->ZZA_TESUFD
		EndIf
		
		If !Empty(ZZATMP->ZZA_TESST) .And. (cUFCli $ ZZATMP->ZZA_UFSST)
			cTesST := ZZATMP->ZZA_TESST
			cUFsST := ZZATMP->ZZA_UFSST
		EndIf
		
		If !Empty(ZZATMP->ZZA_TESCRP) .And. (cUFCli $ ZZATMP->ZZA_UFSCRP)
			cTesCP := ZZATMP->ZZA_TESCRP
			cUFsCP := ZZATMP->ZZA_UFSCRP
		EndIf
		
		ZZATMP->(dbSkip())
		
	EndDo		
	
	ZZATMP->(dbCloseArea())

	aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})	
	aAdd(aItemLinha, {"C6_PRCTAB",iif((AllTrim(itens->promocao) == 'T' .or. AllTrim(itens->bonificado) == 'T' .or. !Empty(AllTrim(itens->codigokit))),0,itens->vlrunitario),Nil})
	aAdd(aItemLinha, {"C6_VALOR" ,Round(itens->quantidade * itens->precovenda,2),Nil})
	aAdd(aItemLinha, {"C6_ENTREG",iif(AllTrim(aPedidos[nX, 18]) >= DtoS(dDataBase),StoD(aPedidos[nX, 18]),dDataBase),Nil})
	aAdd(aItemLinha, {"C6_LOCAL" ,SBZ->BZ_LOCPAD,Nil})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Tratativa tabela promocional³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	If AllTrim(itens->promocao) == 'T'
		aAdd(aItemLinha, {"C6_X_PROMO","S",Nil})
	Else
		aAdd(aItemLinha, {"C6_X_PROMO","N",Nil})
	EndIf
 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Gravação do código do kit no pedido de venda
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	if !Empty(AllTrim(itens->codigokit))
		aAdd(aItemLinha, {"C6_X_KIT", AllTrim(itens->codigokit), Nil})
	EndIf

	cTes := ""
	
	SF4->(dbSetOrder(01))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³apenas seta o tipo de operação caso seja pneu ou bonificação³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	If Substr(aPedidos[nX, 05], 1, 3) == "005" .Or. cOper == "04"

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Jean (18/10/2012) - Tratativa para que todos os pedidos do segmento de pneus entrem com a seguinte regra:³
		//³Quando o tipo de cliente for Consumidor Final, usa operação "03", caso contrário, usa operação "01"    	³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

		If Substr(aPedidos[nX, 05], 1, 3) == "005"
			if cTpCli == "S"
				cOper := "01"
			Else
				cOper := "03"
			EndIf
		EndIf
	Else
		SF4->(dbSeek(xFilial("SF4") + SBZ->BZ_TS))
		cTes := SBZ->BZ_TS
		lMudaTES := .T.
 	EndIf

	aAdd(aItemLinha, {"C6_OPER",cOper,Nil})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
	//³JEAN - 14/04/2014 - Tratativa para testar alteração de CFOP para filial do vinhos SP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù	
	
	if Substr(aPedidos[nX, 05], 1, 3) != "003"
	
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
		
		If (cUFCli $ cUFsST .And. !Empty(cTesST)) .And. (cOper != "04")
			cTes := cTesST
			lMudaTES := .T.		
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de Credito Presumido para alguns produtos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If (cUFCli $ cUFsCP .And. !Empty(cTesCP)) .And. (cOper != "04")
			cTes := cTesCP
			lMudaTES := .T.
		EndIf 
		
		If lMudaTES .And. !Empty(cTes) .And. (cOper != "04")
			AADD(aItemLinha,{"C6_TES",cTes,Nil})
			
			SF4->(dbSeek(xFilial("SF4") + cTes))
			cCfop := iif(lUfDif, "6", "5") + Substr(SF4->F4_CF, 2, 3)
			
			If Left(cCfop,4) == "6405"
				cCfop := "6404"+SubStr(cCfop,5,Len(cCfop)-4)
			Endif
	
			aAdd(aItemLinha, {"C6_CF", cCfop, Nil})
	
		EndIf
		
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
	//³JEAN FIM - 14/04/2014 - Tratativa para testar alteração de CFOP para filial do vinhos SP³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
	
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se é pro pedido entrar liberado no sistema³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lLibPed .And. (aPedidos[nX, 05] != '003001001')
		aAdd(aItemLinha, {iif(lSegUn,"C6_QTDLIB2","C6_QTDLIB"),itens->quantidade,Nil})
	Else
		aAdd(aItemLinha, {iif(lSegUn,"C6_QTDLIB2","C6_QTDLIB"),0,Nil})	
	EndIf

	aAdd(aItemLinha, {"C6_X_VLORI",Round(itens->quantidade * itens->precovenda,2),Nil})
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼
	//³Chamada da função para preenchimento automático da safra no item do pedido³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¼
	
	lSafraAut := SuperGetMv("MV_X_SFAUT",,.F.) .and. lLote .and. aPedidos[nX, 05] == "003001001"  

	if lSafraAut 
		fSafraAuto(aItemLinha)
		lAguarda := .T.
  Else
		aAdd(aItem, aItemLinha)
		ConOut("ITEM: "    +AllTrim(itens->codigo)+;
					 " DESC: "   +SubStr(SB1->B1_DESC, 01, 20)+;
					 " QUANT: "  +Transform(itens->quantidade,"@E 9,999,999.999")+;
			 		 " UN: "     +iif(!Empty(itens->unidade),SubStr(itens->unidade,01,02),"  ")+;
			 		 " VL UN: "  +Transform(itens->precovenda,"@E 9,999,999.99")+;
			 		 " VL TOT: " +Transform((itens->quantidade * itens->precovenda),"@E 9,999,999.99")+;
			 		 " OPER: "   +cOper)
	EndIf
	
	aItemLinha := {}                                                                     
	
	itens->(dbskip())
	
EndDo

itens->(dbCloseArea())
  
Return aItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSafraAuto ºAutor Jean Carlos Saggin     Data ³  09/02/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pelo preenchimento automático da safra  º±±
±±º          ³ no pedido de venda do eEco.                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Integração eEco                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------------------*
Static Function fSafraAuto(aItemLinha)
*-------------------------------------*

Local cSqlB8    := ""
Local nPosCod   := 0
Local nPosLoc   := 0
Local nPosQtd   := 0
Local nQtdTmp   := 0
Local nPosLot   := 0
Local nPosVlO   := 0
Local nPosPrc   := 0
Local nPosUm    := 0
Local nPosQtL   := 0
Local nPosQt2   := 0
Local nPosVlr   := 0
Local nPosIte   := 0
Local nPosOpe   := 0
Local nPosNum   := 0
Local nPosPrT   := 0
Local nPosEnt   := 0                                             
Local nPosPrM   := 0  
Local nPosKit   := 0
Local nQAtu     := 0
Local nQPed     := 0
Local cEol      := CHR(13)+CHR(10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Valoriza as variáveis de acordo com a posição de cada uma no vetor³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nPosCod := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRODUTO"})
nPosLoc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOCAL"})
nPosQtd := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDVEN"})
nPosPrc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCVEN"})
nPosVlO := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_VLORI"})
nPosUm  := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_IMPUNI"})
nPosQtl := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB"})
nPosQt2 := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB2"})
nPosVlr := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_VALOR"})
nPosIte := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ITEM"})
nPosOpe := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_OPER"})
nPosNum := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_NUM"})
nPosPrT := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCTAB"})
nPosEnt := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ENTREG"})
nPosPrM := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_PROMO"})
nPosKit := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_KIT"})

DbSelectArea("SB2")
SB2->(DbSetOrder(1))
SB2->(DbSeek(xFilial("SB2") + PadR(aItemLinha[nPosCod][02], TamSX3("B1_COD")[01]) + aItemLinha[nPosLoc][02]))

nQAtu   := SB2->B2_QATU
nQPed   := SB2->B2_QPEDVEN
nQtdVen := aItemLinha[nPosQtd][02]
nPrcVen := aItemLinha[nPosPrc][02]
cProdut := aItemLinha[nPosCod][02]
cArmaz  := aItemLinha[nPosLoc][02]
nPreco  := aItemLinha[nPosPrc][02]
cUmPed  := aItemLinha[nPosUm ][02]
cOper   := aItemLinha[nPosOpe][02]                           
cNumPV  := aItemLinha[nPosNum][02]
nPrcTab := aItemLinha[nPosPrT][02]
dDtEnt  := aItemLinha[nPosEnt][02]
cPromo  := aItemLinha[nPosPrM][02]
cKit    := iif(nPosKit > 0, aItemLinha[nPosKit][02], " ")

nLoop   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄT¿
//³Avalia se o produto ainda tem saldo em estoque antes de buscar as safras³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄTÙ

if ( nQAtu - nQPed ) > 0
	DbSelectArea("SB8")
	SB8->(DbSetOrder(1))
	SB8->(DbSeek(xFilial("SB8") + PadR(aItemLinha[nPosCod][02], TamSX3("B1_COD")[01]) + aItemLinha[nPosLoc][02]))
	
	nSldB8 := 0
	cChave := xFilial("SB8") + PadR(aItemLinha[nPosCod][02], TamSX3("B1_COD")[01]) + Trim(aItemLinha[nPosLoc][02])
	
	While !SB8->(EOF()) .and. (SB8->B8_FILIAL + SB8->B8_PRODUTO + Trim(SB8->B8_LOCAL) == cChave)
		nSldB8 := SB8->B8_SALDO - SB8->B8_EMPENHO
		
		if nSldB8 > 0
		  if nSldB8 > nQPed
		  	nSldB8 -= nQPed
		  	nQPed := 0
		  	
		  	nLoop++
		  	
		  	nPosLot := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOTECTL"})
		  	
		  	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Depois do primeiro loop, vai adicionando itens no pedido³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				if nLoop > 1
					cItemNovo := Soma1(cItemNovo)
					aAdd(aItemLinha, {"C6_ITEM", cItemNovo, Nil})
				EndIf
		  	
		  	if nQtdVen > nSldB8

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
					//³Ajustes de quantidades e valores referente a quebra de saldos por lote³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
					
					if nLoop = 1
						aItemLinha[nPosQtd][02] := nSldB8
						aItemLinha[nPosVlO][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
						if aItemLinha[nPosUm ][02] == '1'
							aItemLinha[nPosQtL][02] := nSldB8
						ElseIf aItemLinha[nPosUm ][02] == '2'
							aItemLinha[nPosQt2][02] := nSldB8
						EndIf
						aItemLinha[nPosVlr][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Avalia se o campo Lote já existe no vetor antes de gravar a informação³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						if nPosLot > 0
							aItemLinha[nPosLot][02] := SB8->B8_LOTECTL	
						Else
							aAdd(aItemLinha, {"C6_LOTECTL", SB8->B8_LOTECTL, Nil})
						EndIf
					Else
						
						aAdd(aItemLinha, {"C6_NUM"    , cNumPV   , Nil })
						aAdd(aItemLinha, {"C6_PRCTAB" , nPrcTab  , Nil})
						aAdd(aItemLinha, {"C6_ENTREG" , dDtEnt   , Nil})
						aAdd(aItemLinha, {"C6_PRODUTO", cProdut  , Nil})
						aAdd(aItemLinha, {"C6_QTDVEN" , nSldB8   , Nil})
						aAdd(aItemLinha, {"C6_PRCVEN" , nPrcVen  , Nil})
						aAdd(aItemLinha, {"C6_X_PROMO", cPromo   , Nil})
						aAdd(aItemLinha, {"C6_X_KIT"  , cKit     , Nil})
						aAdd(aItemLinha, {"C6_X_VLORI", nSldB8 * nPreco, Nil})
						aAdd(aItemLinha, {"C6_IMPUNI" , cUmPed   , Nil})
						
						if cUmPed == "1"
							aAdd(aItemLinha, {"C6_QTDLIB" , nSldB8 , Nil})
						ELse
							aAdd(aItemLinha, {"C6_QTDLIB2", nSldB8 , Nil})
						EndIf                                        
						                              
						aAdd(aItemLinha, {"C6_VALOR"  , nSldB8 * nPreco, Nil})
						aAdd(aItemLinha, {"C6_LOCAL"  , cArmaz   , Nil})
						aAdd(aItemLinha, {"C6_OPER"   , cOper    , Nil})           
						aAdd(aItemLinha, {"C6_LOTECTL", SB8->B8_LOTECTL, Nil})
						
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³Atualiza as variáveis de acordo com a posição de cada uma no vetor³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						
						nPosCod := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRODUTO"})
						nPosLoc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOCAL"})
						nPosQtd := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDVEN"})
						nPosPrc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCVEN"})
						nPosVlO := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_VLORI"})
						nPosUm  := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_IMPUNI"})
						nPosQtl := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB"})
						nPosQt2 := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB2"})
						nPosVlr := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_VALOR"})
						nPosIte := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ITEM"})
						nPosOpe := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_OPER"})
						nPosNum := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_NUM"})
						nPosPrT := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCTAB"})
						nPosEnt := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ENTREG"})
						nPosPrM := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_PROMO"})
						nPosKit := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_KIT"})
						
					EndIf
					
					aAdd(aItem, aItemLinha)
					nQtdVen -= nSldB8
					
				Else
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
					//³Ajustes de quantidades e valores referente a quebra de saldos por lote³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄr
		
					aItemLinha[nPosQtd][02] := nQtdVen
					aItemLinha[nPosVlO][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
					if aItemLinha[nPosUm ][02] == '1'
						aItemLinha[nPosQtL][02] := nQtdVen
					ElseIf aItemLinha[nPosUm ][02] == '2'
						aItemLinha[nPosQt2][02] := nQtdVen
					EndIf
					aItemLinha[nPosVlr][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
		
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Avalia se o campo Lote já existe no vetor antes de gravar a informação³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					if nPosLot > 0
						aItemLinha[nPosLot][02] := SB8->B8_LOTECTL
					Else                                          
						aAdd(aItemLinha, {"C6_LOTECTL", SB8->B8_LOTECTL, Nil})
					EndIf
					
					aAdd(aItem, aItemLinha)
					nQtdVen := 0
							
				EndIf 
				
				ConOut("ITEM: "    +aItemLinha[nPosCod][02]+;
							 " DESC: "   +SubStr(Posicione("SB1", 1, xFilial("SB1") + aItemLinha[nPosCod][02], "B1_DESC"), 01, 20)+;
							 " QUANT: "  +Transform(aItemLinha[nPosQtd][02],"@E 9,999,999.999")+;
							 " UN: "     +fGetUM(aItemLinha[nPosCod][02], aItemLinha[nPosUm ][02])+;
							 " VL UN: "  +Transform(aItemLinha[nPosPrc][02],"@E 9,999,999.99")+;
							 " VL TOT: " +Transform((aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02]),"@E 9,999,999.99")+;
							 " OPER: "   +aItemLinha[nPosOpe][02])		

				aItemLinha := {}
		  	
		  Else
		  	nQPed -= nSldB8
			EndIf
			
		EndIf
		
		SB8->(DbSkip())
	EndDo
EndIf  

if nQtdVen > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia se deve deve cortar o saldo de itens que não tem em estoque³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if LCORTA
		aAdd(aCortes, {aItemLinha[nPosCod][02], nQtdVen})  
		ConOut("Cortando Item código: "+ aItemLinha[nPosCod][02] +" Quant. "+ Transform(nQtdVen,"@E 9,999,999.999"))
	Else 
		nPosLot := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOTECTL"})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Adiciona o saldo que não tem nos lotes com safra em branco³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if nLoop > 0
			cItemNovo := Soma1(cItemNovo) 
			
			aAdd(aItemLinha, {"C6_ITEM"   , cItemNovo, Nil})
			aAdd(aItemLinha, {"C6_NUM"    , cNumPV   , Nil })
			aAdd(aItemLinha, {"C6_PRCTAB" , nPrcTab  , Nil})
			aAdd(aItemLinha, {"C6_ENTREG" , dDtEnt   , Nil})
			aAdd(aItemLinha, {"C6_PRODUTO", cProdut  , Nil})
			aAdd(aItemLinha, {"C6_QTDVEN" , nQtdVen  , Nil})
			aAdd(aItemLinha, {"C6_PRCVEN" , nPrcVen  , Nil})
			aAdd(aItemLinha, {"C6_X_PROMO", cPromo   , Nil})
			aAdd(aItemLinha, {"C6_X_KIT"  , cKit     , Nil})
			aAdd(aItemLinha, {"C6_X_VLORI", nQtdVen * nPreco, Nil})
			aAdd(aItemLinha, {"C6_IMPUNI" , cUmPed   , Nil})
			
			if cUmPed == "1"
				aAdd(aItemLinha, {"C6_QTDLIB" , nQtdVen , Nil})
			ELse
				aAdd(aItemLinha, {"C6_QTDLIB2", nQtdVen , Nil})
			EndIf                                        
			                              
			aAdd(aItemLinha, {"C6_VALOR"  , nQtdVen * nPreco, Nil})
			aAdd(aItemLinha, {"C6_LOCAL"  , cArmaz   , Nil})
			aAdd(aItemLinha, {"C6_OPER"   , cOper    , Nil})           
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza as variáveis de acordo com a posição de cada uma no vetor³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			nPosCod := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRODUTO"})
			nPosLoc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOCAL"})
			nPosQtd := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDVEN"})
			nPosPrc := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCVEN"})
			nPosVlO := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_VLORI"})
			nPosUm  := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_IMPUNI"})
			nPosQtl := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB"})
			nPosQt2 := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_QTDLIB2"})
			nPosVlr := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_VALOR"})
			nPosIte := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ITEM"})
			nPosOpe := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_OPER"})
			nPosNum := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_NUM"})
			nPosPrT := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_PRCTAB"})
			nPosEnt := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_ENTREG"})
			nPosPrM := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_PROMO"})
			nPosKit := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_KIT"})
		
		Else
			aItemLinha[nPosQtd][02] := nQtdVen
			aItemLinha[nPosVlO][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
			
			if aItemLinha[nPosUm ][02] == '1'
				aItemLinha[nPosQtL][02] := nQtdVen
			ElseIf aItemLinha[nPosUm ][02] == '2'
				aItemLinha[nPosQt2][02] := nQtdVen
			EndIf
			aItemLinha[nPosVlr][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
	      
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
			//³Grava vazio no campo de lote para que, posteriormente, alguém avalie³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ 
			
			if nPosLot > 0
				aItemLinha[nPosLot][02] := " "  
			EndIf
		
		EndIf

		aAdd(aItem, aItemLinha)
		
		ConOut("ITEM: "    +aItemLinha[nPosCod][02]+;
					 " DESC: "   +SubStr(Posicione("SB1", 1, xFilial("SB1") + aItemLinha[nPosCod][02], "B1_DESC"), 01, 20)+;
					 " QUANT: "  +Transform(aItemLinha[nPosQtd][02],"@E 9,999,999.999")+;
					 " UN: "     +fGetUM(aItemLinha[nPosCod][02], aItemLinha[nPosUm ][02])+;
					 " VL UN: "  +Transform(aItemLinha[nPosPrc][02],"@E 9,999,999.99")+;
					 " VL TOT: " +Transform((aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02]),"@E 9,999,999.99")+;
					 " OPER: "   +aItemLinha[nPosOpe][02])
						 
	EndIf
	
EndIf

Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável por buscar a unidade de medida do produto conforme escolha do representante³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*------------------------------------*
Static Function fGetUM(cCodigo, cUm)  
*------------------------------------*

Local cRet := " "                     

if cUm == '1'
	cRet := Posicione("SB1", 1, xFilial("SB1") + cCodigo, "B1_UM")
Else                                                            
	cRet := Posicione("SB1", 1, xFilial("SB1") + cCodigo, "B1_SEGUM")
EndIf

Return cRet


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz o processo de enviar o email caso ocorreu erro³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 

*--------------------------------------------------------*
Static Function EnviaErro(cErro, aCabPed, aItemPed, nOpc)   
*--------------------------------------------------------*

Local cVend      := ""
Local cEmailVend := ""
Local cNomeCli   := "" 
Local cCli       := "" 
Local cLojaCli   := "" 
Local cCotacao   := ""
Local oProcess
Local oHtml

Local nPosVen    := 0
Local nPosCli    := 0
Local nPosLoj    := 0
Local nPosCot    := 0
Local nPosVal    := 0 

Local cProcess := OemToAnsi("008080") 
Local cMailCC := SuperGetMV("MV_X_S3GER", , "sim3g@grupocantu.com.br")

if nOpc == 2
	nPosVen := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_VEND1"})
	nPosCli := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_CLIENTE"})
	nPosLoj := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_LOJACLI"})
	nPosCot := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_COTACAO"})
	nPosVal := aScan(aItemPed[01], {|x| AllTrim(x[01]) == "C6_VALOR"})
	
	cVend    := aCabPed[nPosVen, 02]
	cCli     := aCabPed[nPosCli, 02]
	cLojaCli := aCabPed[nPosLoj, 02]
	cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)
	cCotacao := aCabPed[nPosCot, 02]
	
	nValTot := 0
	
	for n := 1 to len(aItemPed)
		nPosVal := aScan(aItemPed[n], {|x| AllTrim(x[01]) == "C6_VALOR"})
		nValTot += aItemPed[n][nPosVal][02]	
	Next n       
	
ElseIf nOpc == 1

	cVend    := aPedidos[nX, 15]
	cCli     := aPedidos[nX, 16]
	cLojaCli := aPedidos[nX, 17]
	cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)		
  
	nValTot  := aPedidos[nX, 09]
	cCotacao := AllTrim(Str(aPedidos[nX, 01],0))
EndIf

cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Com Erro"))
oProcess:NewTask(cStatus,"\workflow\wfpedcomerro.htm")
oProcess:cSubject := OemToAnsi("Pedido cliente "+ AllTrim(cNomeCli) +" Valor R$ "+ AllTrim(Transform(nValTot, "@E 9,999,999.99")) +;
															 " não sincronizado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

//@qui                           
oProcess:cTo := AllTrim(cEmail)
oProcess:cCC := cMailCC
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

oHtml:= oProcess:oHTML		
oHtml:ValByName("DATA",       DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE",    cCli + " - " + cLojaCli + ": " + SubStr(cNomeCli,01,30))
oHtml:ValByName("VENDEDOR",   cNomeVend)
oHtml:ValByName("PEDSIM",     cCotacao)
oHtml:ValByName("VALORTOTAL", Transform(nValTot, '@E 999,999,999.99'))
oHtml:ValByName("ERRO",       cErro)   

oProcess:Start()
oProcess:Finish()             

Return Nil                                                                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz o processo de enviar o email para o vendedor confirmando da sincronização³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*------------------------------------*
Static Function EnviaPedOk(cPedSiga, aCabPed, aItemPed)  
*------------------------------------*

Local cVend      := ""
Local cEmailVend := ""
Local cCli       := ""
Local cLojaCli   := ""
Local cNomeCli   := ""
Local nValTot    := 0
Local oProcess
Local oHtml
Local cProcess   := OemToAnsi("008080") 

Local nPosVen    := 0
Local nPosCli    := 0
Local nPosLoj    := 0
Local nPosCot    := 0
Local nPosVal    := 0

nPosVen := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_VEND1"})
nPosCli := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_CLIENTE"})
nPosLoj := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_LOJACLI"})
nPosCot := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_COTACAO"})
nPosVal := aScan(aItemPed[01], {|x| AllTrim(x[01]) == "C6_VALOR"})

cVend    := aCabPed[nPosVen, 02]
cCli     := aCabPed[nPosCli, 02]
cLojaCli := aCabPed[nPosLoj, 02]
cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)

nValTot := 0

for n := 1 to len(aItemPed)
	nPosVal := aScan(aItemPed[n], {|x| AllTrim(x[01]) == "C6_VALOR"})
	nValTot += aItemPed[n][nPosVal][02]	
Next n

cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido"))
oProcess:NewTask(cStatus,"\workflow\wfpedsincronizado.htm")
oProcess:cSubject := OemToAnsi("Pedido cliente " + cNomeCli + " R$ "+ Transform(nValTot, "@E 9,999,999.99") +;
															 " recebido - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

//@qui  
oProcess:cTo := ALLTRIM(cEmail) 
oProcess:cCC := "sim3g@grupocantu.com.br" 
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0¿
//³Preenchimento do cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ0Ù

oHTML:= oProcess:oHTML		
oHtml:ValByName("DATA"      ,DTOC(dDataBase) + " " + SubStr(Time(), 1, 5))
oHtml:ValByName("CLIENTE"   ,cCli + "/" + cLojaCli + " - " + cNomeCli)
oHtml:ValByName("VENDEDOR"  ,cNomeVend)
oHtml:ValByName("PEDSIM"    ,aCabPed[nPosCot, 02])
oHtml:ValByName("PEDSIGA"   ,cPedSiga)
oHtml:ValByName("VALORTOTAL",Transform(nValTot, '@E 9,999,999.99'))

oProcess:Start()
oProcess:Finish()                                              

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³JOBPEDEECO ºAutor  ³Microsiga           º Data ³  14/03/13   º±±
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
User Function JOBPEDEECO(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort)      
*--------------------------------------------------------------------------------------------------*
Local cIdPedido 	:= AllTrim(Str(idPedido,0))
Local cSql 			:= ""
Local cEnv 			:= GetEnvServer()
Local oSrv
Local lExist 		:= .F.
Local cNumPed		:= ""
Local nPosPed		:= 0  
Local lFind			:= .F.
Private aEmpLib	  	:= {{"50","01","001001001"}} // Indica empresa filial e segmento para os pedidos cairem liberados 

nPosPed := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_NUM"})
cNumPed := aCabPed[nPosPed][02]
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Tenta inicializar conexão no server com IP e Porta 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

oSrv := RpcConnect(cIP, Val(cPort), cEnv, Transform(cEmp, "@! 99"), Transform(cFil, "@! 99" ))
if !(valtype(oSrv) == "O")
	ConOut("JOBPEDEECO - NÃO CONSEGUIU CONECTAR NO SERVIDOR...")
	ConOut("JOBPEDEECO - IP: " + cIP + " PORT: " + cPort)
	GrvStatus(cIdPedido, 0, "NÃO CONSEGUIU CONECTAR NO SERVIDOR")
	Return                                     
EndIf        	

RpcClearEnv()
RpcSetType(3)
RpcSetEnv(Transform(cEmp, "@! 99"), Transform(cFil, "@! 99" ),,,,GetEnvServer(),{ "SA1" })	

lMsErroAuto := .F.
	                         
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItemPed,3)

Sleep(1000)
lSincr := AvalLicit(aCabPed)

If lSincr
	
	GrvStatus(cIdPedido, 2, "PEDIDO SINCRONIZADO")	
	GrvErro(cIdPedido, "")
	EnviaPedOk(cNumPed, aCabPed, aItemPed)			

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chamada da funcao para liberacao do pedido.
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	//Gustavo 30/12/2014 - Verifica se o pedido pertence a empresa que possua regra de liberação
	For nI := 1 To Len(aEmpLib)
		If aEmpLib[nI][1] + aEmpLib[nI][2] + aEmpLib[nI][3] == cEmpAnt + cFilAnt + SC5->C5_X_CLVL
			lFind := .T.
		EndIf
	Next nI
	
	cHORA := TIME()
	If (SuperGetMV("MV_LPAEECO",,.F.) .and. (cHORA >= MAX_HORA .or. cHORA <= MIN_HORA)) .or. lFind
		
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		conout("1-LIBERANDO PEDIDO: "+cNumPed)
		If SC5->(dbSeek(xFilial("SC5")+cNumPed))
			aPvlNfs   := {}
			aRegistros := {}
			aBloqueio := {{"","","","","","","",""}} 
			conout("2-LIBERANDO PEDIDO: "+cNumPed)  
			Ma410LbNfs(2,@aPvlNfs,@aBloqueio)		
			Ma410LbNfs(1,@aPvlNfs,@aBloqueio)				
			DbSelectArea("SC6")
			SC6->(DbSetOrder(1))
			SC6->(dbGoTop())
			SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))  
			While SC6->(!Eof()) .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM = SC5->C5_NUM
			    If (SC6->C6_QTDLIB > 0)
				    aAdd(aRegistros,SC6->(RecNo()))
				EndIf
				SC6->(DbSkip())
			EndDo  
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Libera por Total de Pedido                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ( Len(aRegistros) > 0 )
				Begin Transaction       
					conout("3-LIBERANDO PEDIDO: "+cNumPed)
					SC6->(MaAvLibPed(SC5->C5_NUM,.T.,.F.,.F.,aRegistros,Nil,Nil,Nil,Nil))
				End Transaction
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o Flag do Pedido de Venda                                      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Begin Transaction
				SC6->(MaLiberOk({SC5->C5_NUM},.F.))
				conout("4-LIBERANDO PEDIDO: "+cNumPed)
			End Transaction
			conout("5-LIBERANDO PEDIDO: "+cNumPed)
			FMILBITENS(cNumPed)
		EndIf
	EndIf

Else

	GrvStatus(cIdPedido, -1, "ERRO NA EXECUCAO DO MSEXECAUTO")

	if !ExistDir("\EECO")
		MakeDir("\EECO")
	EndIf
	cErro := MostraErro("\EECO")
	
	GrvErro(cIdPedido, cErro)
	
	ConOut(cErro)
	cErro := StrTran(cErro, chr(13) + chr(10), '<br/>')	
	EnviaErro(cErro, aCabPed, aItemPed, 2)	                                  
	
EndIf

RpcDisconnect(oSrv)

RpcClearEnv()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável por validar se o pedido já foi integrado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-----------------------------------*
Static Function AvalLicit(aCabPed)   
*-----------------------------------*

Local lRet := .F.
Local cSql := ""
Local nPosCot := aScan(aCabPed, {|x| Alltrim(x[1]) == "C5_COTACAO"})
Local nPosFil := aScan(aCabPed, {|x| AllTrim(x[1]) == "C5_FILIAL"})

cSql := "SELECT C5.C5_NUM FROM "+retSqlName("SC5")+" C5 "
cSql += "WHERE C5.C5_FILIAL = '"+ aCabPed[nPosFil][2] +"' "
cSql += "  AND C5.C5_COTACAO = '"+ aCabPed[nPosCot][2] +"' "
cSql += "  AND C5.C5_X_EECO = 'T' "
cSql += "  AND C5.D_E_L_E_T_ <> '*' "

TCQUERY cSql NEW ALIAS "C5LIC"

DbSelectArea("C5LIC")
C5LIC->(DbGoTop())

if C5LIC->(EOF())
	
	C5LIC->(DbCloseArea())
	Return .F.            
	
Else

	lRet := .T.                                                                    
	C5LIC->(DbCloseArea())
EndIf               

Return lRet                                                         
                          


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função responsável pela alteração do status inicial dos pedidos que serão processados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function AltStatus(aPedidos)
Local cSql := " "
Local n   := 0

For n := 1 to len(aPedidos)
	GrvStatus(AllTrim(Str(aPedidos[n, 01],0)), 1, "INICIANDO INTEGRACAO")
Next n

Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de status do processamento na tabela intermediária³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GrvStatus(cPedido, nStatus, cMsg)
Local cSql := " "

ConOut("IMPPEDEECO - PEDIDO: "+ cPedido +" STATUS: ("+ AllTrim(Str(nStatus,0)) +") "+;
			 iif(nStatus == -1, "ERRO DE INTEGRACAO", iif(nStatus == 1, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "update eeco_pedido set status = "+ AllTrim(Str(nStatus,0)) +", msgproc = '"+ AllTrim(cMsg) +"' where idpedido = "+ cPedido
TcSqlExec(cSql)

Return                    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela gravação de erro na tabela intermediária                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function GrvErro(cPedido, cMsgErro)
Local cSql := " "

ConOut("IMPPEDEECO - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubSTR(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)

cSql := "update eeco_pedido set mostraerro = '"+cMsgErro+"' where idpedido = "+ cPedido
TcSqlExec(cSql)

Return 
       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função utilizada para avaliar Threads em execução³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*--------------------------------*
Static Function FreeAllThreads()
*--------------------------------*

Local aUserInfoArray := GetUserInfoArray()
Local cEnvServer		 := GetEnvServer()
Local cComputerName	 := GetComputerName()
Local nThreads			 := 0
Local lFreeThreads   := .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_JOBPEDEECO" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ALTPEDEECO ºAutor  ³Jean C. P. Saggin  º Data ³  22/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina desenvolvida com a finalidade de reimportar/excluir º±±
±±º          ³ pedidos com problema de integração.                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------*
User Function ALTPEDEECO()
*------------------------------*

Local oBtnClose
Local oBtnErros
Local oBtnExc
Local oBtnPesq
Local oBtnRepr
Local oBtnVis
Local oCboFiltro       
Local oGrpBtn
Local oLbFiltro
 
Private nCboFiltro := '1'
Private oDlgeEco
Private aCboFiltro := {"1=Erro de integração","2=Não integrado","3=Em processo de integração","4=Integrado com sucesso","5=Pedido bloqueado","6=Aguardando autorização","7=Autorização recusada","8=Todos os pedidos"}
Private aCampos    := {}
Private aCpos      := {}
Private cTrab 
Private cIndic
Private oMark
Private cPerg      := "ALTPEDEECO"      
Private lInverte   := .F. 
Private cMarca     := GetMark()
Private aCores     := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
	//³Chama função para manutenção do grupo de perguntas da rotina³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
	
	CriaSx1(cPerg)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Faz a pergunta apenas para gravar o conteúdo default nos parâmetros³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !Pergunte(cPerg, .T.)
		Return
	EndIf
	
	MV_PAR01 := Date()                 // Emissão De
	MV_PAR02 := Date()                 // Emissao Até
	MV_PAR03 := Space(09)              // CLiente Ini
	MV_PAR04 := "ZZZZZZZZZ"            // CLiente Fin
	MV_PAR05 := Space(04)              // Loja Ini
	MV_PAR06 := "ZZZZ"                 // Loja Fin
	MV_PAR07 := Space(06)              // Vend. De
	MV_PAR08 := "ZZZZZZ"               // Vend. Ate    
	MV_PAR09 := 2                                      
	
	if Select("PED_EECO") > 0
		PED_EECO->(DbCloseArea())
	EndIf
	
	aCpos := {}
	
	aAdd(aCpos, {"MARK"    , "C" , 02, 0})
	aAdd(aCpos, {"EMPRESA" , "C" , 02, 0})
	aAdd(aCpos, {"FILIAL"  , "C" , 02, 0})
	aAdd(aCpos, {"IDPEDIDO", "N" , 07, 0})
	aAdd(aCpos, {"VENDEDOR", "C" , 06, 0})
	aAdd(aCpos, {"CLIENTE" , "C" , 09, 0})
	aAdd(aCpos, {"LOJA"    , "C" , 04, 0})
	aAdd(aCpos, {"RAZAO"   , "C" , 30, 0})
	aAdd(aCpos, {"DTPEDIDO", "D" , 08, 0})
	aAdd(aCpos, {"VALOR"   , "N" , 12, 2})
	aAdd(aCpos, {"STATUS"  , "N" , 02, 0})
	aAdd(aCpos, {"ERRO"    , "C" , 90, 0})     
	
	cTrab  := CriaTrab(aCpos)
	cIndic := CriaTrab(NIL, .F.)
	
	dbUseArea( .T.,,cTrab,"PED_EECO",.F. )
	dbSelectArea("PED_EECO")
	cChave1  := "EMPRESA+FILIAL+STR(IDPEDIDO)"
	
	IndRegua("PED_EECO",cIndic,cChave1,,,"Selecionando Registros...")
	dbSelectArea("PED_EECO")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos da tabela temporária³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aAdd(aCampos, {"MARK"    , "", " "          , "@!"})
	aAdd(aCampos, {"EMPRESA" , "", "Empresa"    , "@!"})
	aAdd(aCampos, {"FILIAL"  , "", "Filial"     , "@!"})
	aAdd(aCampos, {"IDPEDIDO", "", "Id. Pedido" , "@!"})
	aAdd(aCampos, {"VENDEDOR", "", "Vendedor"   , "@!"})
	aAdd(aCampos, {"CLIENTE" , "", "Cliente"    , "@!"})
	aAdd(aCampos, {"LOJA"    , "", "Loja"       , "@!"})
	aAdd(aCampos, {"RAZAO"   , "", "Razão Soc." , "@!"})
	aAdd(aCampos, {"DTPEDIDO", "", "Data Pedido", })
	aAdd(aCampos, {"VALOR"   , "", "Vlr Pedido" , "@E 9,999,999.99"})
	aAdd(aCampos, {"STATUS"  , "", "Status"     , "@E 99"})
	aAdd(aCampos, {"ERRO"    , "", "Msg Integr.", "@!"})
	
	aAdd(aCores,{"PED_EECO->STATUS == -1","BR_VERMELHO"})
	aAdd(aCores,{"PED_EECO->STATUS == 0" ,"BR_BRANCO"  })
	aAdd(aCores,{"PED_EECO->STATUS == 1" ,"BR_AMARELO" })
	aAdd(aCores,{"PED_EECO->STATUS == 2" ,"BR_VERDE"   })
	aAdd(aCores,{"PED_EECO->STATUS == 3" ,"BR_CINZA"   })
	aAdd(aCores,{"PED_EECO->STATUS == 4" ,"BR_LARANJA" })
	aAdd(aCores,{"PED_EECO->STATUS == 5" ,"BR_PRETO"   })
	

  	DEFINE MSDIALOG oDlgeEco TITLE "Monitor Pedidos Protheus x eEco" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

    @ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlgeEco COLOR 0, 16777215 PIXEL
    oMark := MsSelect():New("PED_EECO", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
 		ObjectMethod(oMark:oBrowse,"Refresh()")
 		oMark:oBrowse:lhasMark := .T.
 		oMark:oBrowse:lCanAllmark := .T.
		oMark:oBrowse:Refresh()
    
    @ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltro ITEMS aCboFiltro ON CHANGE CarregaDados() SIZE 146, 010 OF oDlgeEco COLORS 0, 16777215 PIXEL
    @ 004, 003 SAY oLbFiltro PROMPT "Filtro:" SIZE 025, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL

    @ 010, 160 BUTTON oBtnPesq  PROMPT "&Parâmetros"        SIZE 060, 013 OF oDlgeEco ACTION FindOrder() 		PIXEL
    @ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	SIZE 060, 013 OF oDlgeEco ACTION CarregaDados()		PIXEL
    @ 220, 055 BUTTON oBtnPesq  PROMPT "&Legenda"   	 			SIZE 060, 013 OF oDlgeEco ACTION fLegenda() 		PIXEL
    @ 220, 120 BUTTON oBtnVis   PROMPT "&Visualizar Pedido" SIZE 060, 013 OF oDlgeEco ACTION Visualiza() 		PIXEL
    @ 220, 185 BUTTON oBtnErros PROMPT "Erros &Integração"  SIZE 060, 013 OF oDlgeEco ACTION ErrosInt() 		PIXEL
    @ 220, 250 BUTTON oBtnExc   PROMPT "&Excluir Pedido"    SIZE 060, 013 OF oDlgeEco ACTION ExcPed() 			PIXEL
    @ 220, 315 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	  SIZE 060, 013 OF oDlgeEco ACTION ReprocPed()		PIXEL
    @ 220, 380 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 060, 013 OF oDlgeEco ACTION fCloseDlg()		PIXEL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
	//³Faz carga inicial dos dados com base nos parâmetros defaults³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ
	
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlgeEco CENTERED                                                                  


Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³fCloseDlg    ºAutor  ³Jean C. Saggin  º  Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Encerra janela principal.                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------*
Static Function fCloseDlg()
*-------------------------------------*
	PED_EECO->(DbCloseArea())
	Close(oDlgeEco)
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³CarregaDados ºAutor  ³Jean C. Saggin  º  Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável por carregar os dados no grid.          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------*
Static Function CarregaDados(nExec,lEnd)
*-------------------------------------*

Local cSql := ""
Local cEol := CHR(13)+CHR(10)          

Default nExec := 2

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a limpeza dos dados do arquivo temporário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(cPerg, .F.)

DbSelectArea("PED_EECO")
PED_EECO->(DbGoTop())
Do While !PED_EECO->(Eof())
    RecLock("PED_EECO",.F.)
    DbDelete()
    MsUnlock() 
   PED_EECO->(DbSkip())
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz uma busca pelos pedidos da empresa posicionada no laço do FOR e que estão com status "0"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "select pedido.idpedido, "                                                 +cEol
cSql += "       pedido.status, "                                                   +cEol
cSql += "       to_char(pedido.dtpedido, 'yyyymmdd') as dtpedido, "                +cEol
cSql += "       to_char(pedido.dtpedido, 'hh24:mi:ss') as horapedido, "            +cEol
cSql += "       SubStr(pedido.segmento,01,09) as segmento, "                       +cEol
cSql += "       cast(pedido.msgproc as varchar(3000)) as msgproc, "                +cEol
cSql += "       to_char(pedido.dataprocessamento, 'yyyymmdd') as dtdispon, "       +cEol
cSql += "       to_char(pedido.dataprocessamento, 'hh24:mi:ss') as horadispon, "   +cEol
cSql += "       pedido.valortotal, "                                               +cEol
cSql += "       Trim(pedido.empresa) as empresa, "                                 +cEol
cSql += "       Trim(pedido.filial) as filial, "                                   +cEol
cSql += "       SubStr(pedido.tabela,01,03) as tabela, "                           +cEol
cSql += "       SubStr(pedido.formapagamento,01,03) as formapagamento, "           +cEol
cSql += "       pedido.codtrans, "                                                 +cEol
cSql += "       SubStr(pedido.vendedorerp,01,06) as vendedorerp, "                 +cEol
cSql += "       SubStr(pedido.cliente,01,09) as cliente, "                         +cEol
cSql += "       SubStr(pedido.loja,01,04) as loja, "                               +cEol
cSql += "       to_char(pedido.dataentrega, 'yyyymmdd') as dataentrega  "          +cEol
cSql += "from eeco_pedido pedido "                                                 +cEol
cSql += "where to_char(pedido.dtpedido,'yyyymmdd') between '"+ DtoS(mv_par01) +"' and '"+ DtoS(mv_par02) +"' "  +cEol
cSql += "  and SubStr(pedido.cliente,01,09)        between '"+ mv_par03       +"' and '"+ mv_par04       +"' "  +cEol
cSql += "  and SubStr(pedido.loja,01,04)           between '"+ mv_par05       +"' and '"+ mv_par06       +"' "  +cEol
cSql += "  and SubStr(pedido.vendedorerp,01,06)    between '"+ mv_par07       +"' and '"+ mv_par08       +"' "  +cEol

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se deve mostrar apenas os pedidos da Emp/Filial que o usuário está posicionado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par09 == 1
	cSql += "  and Trim(pedido.empresa) = '"+ cEmpAnt +"' "                             +cEol
	cSql += "  and Trim(pedido.filial) = '"+ cFilAnt +"' "                              +cEol
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação de status conforme seleção do usuário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case nCboFiltro == '1'
		cSql += "  and pedido.status = -1 "                                                 +cEol
	Case nCboFiltro == '2'
		cSql += "  and pedido.status = 0 "                                                  +cEol
	Case nCboFiltro == '3'
		cSql += "  and pedido.status = 1 "                                                  +cEol
	Case nCboFiltro == '4'
		cSql += "  and pedido.status = 2 "                                                  +cEol
	Case nCboFiltro == '5'
		cSql += "  and pedido.status = 3 "                                                  +cEol
	Case nCboFiltro == '6'
		cSql += "  and pedido.status = 4 "                                                  +cEol
	Case nCboFiltro == '7'
		cSql += "  and pedido.status = 5 "                                                  +cEol
EndCase

cSql += "order by pedido.empresa, pedido.filial, pedido.idpedido"


TCQUERY cSql NEW ALIAS "pedido"

DbSelectArea("pedido")
pedido->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Avalia se o retorno da busca for vazia³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If pedido->(eof())

	If nExec == 2
		PED_EECO->(DbGoTop())
		ObjectMethod(oMark:oBrowse,"Refresh()")
		oDlgeEco:Refresh()
	EndIf

	pedido->(DbCloseArea())
	Return .T.
EndIf

aPedidos := {}

while !pedido->(eof())
	
	dbSelectArea("PED_EECO")
	
	RecLock("PED_EECO", .T.)
	PED_EECO->MARK     := "  "
	PED_EECO->EMPRESA  := SubStr(pedido->empresa, 01,02)
	PED_EECO->FILIAL   := SubStr(pedido->filial,01,02)
	PED_EECO->IDPEDIDO := pedido->idpedido 
	PED_EECO->VENDEDOR := SubStr(pedido->vendedorerp,01,06)
	PED_EECO->CLIENTE  := SubStr(pedido->cliente,01,09)
	PED_EECO->LOJA     := SubStr(pedido->loja,01,04)
	PED_EECO->RAZAO    := SubStr(Posicione("SA1", 1, xFilial("SA1") + SubStr(pedido->cliente,01,09) + SubStr(pedido->loja,01,04), "A1_NOME"), 01, 30)
	PED_EECO->DTPEDIDO := StoD(pedido->dtpedido)
	PED_EECO->VALOR    := pedido->valortotal
	PED_EECO->STATUS   := pedido->status
	PED_EECO->ERRO     := pedido->msgproc
	PED_EECO->(MsUnlock())

	pedido->(DbSkip())
EndDo

pedido->(DbCloseArea()) 

PED_EECO->(DbGoTop())

ObjectMethod(oMark:oBrowse,"Refresh()")
oDlgeEco:Refresh()

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³fLegenda  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para legenda.                                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fLegenda()

Local cTitulo := OemtoAnsi("Legenda")

Local aCores	:= {	{ 'BR_VERMELHO'	, "Erro de integração" 		 		},;
										{ 'BR_BRANCO'   , "Não integrado"							},;
										{ 'BR_AMARELO'	, "Em processo de integração"	},;
										{ 'BR_VERDE'		, "Integrado com sucesso"  		},;
										{ 'BR_CINZA'		, "Bloqueado"   							},;
										{ 'BR_LARANJA'	, "Aguardando autorização"		},;
										{ 'BR_PRETO'		, "Autorização recusada"  		}}											
												
	BrwLegenda(cTitulo, "Legenda", aCores)


Return          


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ReprocPed ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada pelo botão de reprocessamento.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ReprocPed(oDlgeEco)
 
Local nRECPED := PED_EECO->(RECNO())
Local aPEDIDO := {}

Private cIP   := CIPSERVER
Private cPort := FGETPORT()

	dbSelectArea("PED_EECO")
	PED_EECO->(DbGoTop())
	Do While !PED_EECO->(Eof())
		If !Empty(PED_EECO->MARK) 
			If ( PED_EECO->STATUS == -1 .OR. PED_EECO->STATUS == 0 .OR. PED_EECO->STATUS == 1 )
				nPOSEMP := 0
				If Len(aPEDIDO) > 0
					nPOSEMP := aScan (aPEDIDO, {|x| x[1] == PED_EECO->EMPRESA .and. x[2] == PED_EECO->FILIAL })
				EndIf          
				If nPOSEMP == 0
					aAdd (aPEDIDO, {PED_EECO->EMPRESA, PED_EECO->FILIAL, {} })
					nPOSEMP := Len(aPEDIDO)
				EndIf
				aAdd ( aPEDIDO[nPOSEMP][3], PED_EECO->IDPEDIDO )
			Else
				aPEDIDO := {}
				Aviso("Aviso","Somente podem ser reprocessados pedidos com os status (Erro de integração/Não integrado/Em processo de integração ).",{"OK"})
				Exit
			EndIf
		EndIf
	   PED_EECO->(DbSkip())
	Enddo
	PED_EECO->(dbGoTo(nRECPED))
	
	If Len(aPEDIDO) == 0
		Aviso("Aviso","Nenhum pedido valido foi selecionado para reimportação.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a reimportação do(s) pedido(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf
	
	RptStatus({|lEnd| fProcRep(aPEDIDO,lEnd)}, "Aguarde...","Reimportando o(s) pedido(s) selecionado(s)...", .T.)
	
	CarregaDados()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³fProcRep  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para inclusão de pedidos.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------*	
Static Function fProcRep(aPEDIDO,lEnd)
*-------------------------------------*
Local nI   := 0
Local nJ   := 0
Local nCnt := 0
Local cSql := " "

SetRegua(Len(aPedido))

For nI := 1 to Len(aPEDIDO)
  IncRegua()
	For nJ := 1 to Len(aPEDIDO[nI][03])
		cSql := "update eeco_pedido set status = 0 where idpedido = "+ cValToChar(aPedido[nI][03][nJ])
		TcSqlExec(cSql)
		nCnt++
	Next nJ	
	Sleep(1000)
Next nI

Aviso("Pedidos reprocessando...", "Foram marcados "+cValToChar(nCnt)+" pedidos para serem reprocessados.", {"Ok"}, 2 )

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FindOrder ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada pelo botão de busca de pedidos.             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FindOrder()

if (Pergunte(cPerg, .T.))
	CarregaDados()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³Visualiza ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada para visualizar o pedido de vendas antes    º±±
±±º          ³ da importação para o Protheus.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Visualiza()

Local nRECPED 		:= PED_EECO->(RECNO())
Local CAB_EMPRESA	:= ""
Local CAB_FILIAL	:= ""
Local CAB_IDPEDIDO	:= ""
Local CAB_VENDEDOR	:= ""
Local CAB_CLIENTE	:= ""
Local CAB_LOJA		:= ""
Local CAB_RAZAO		:= ""
Local CAB_DTPEDIDO	:= ctod("")
Local CAB_VALOR		:= 0
Local CAB_STATUS	:= ""
Local CAB_ERRO		:= ""
Private aHeadITE	:= {}
Private aColsITE	:= {}
Private oItensPV, oDlgeEco 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem dos campos de cabecalho                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("PED_EECO")
	PED_EECO->(DbGoTop())
	Do While !PED_EECO->(Eof())
		If !Empty(PED_EECO->MARK)
			CAB_EMPRESA  := PED_EECO->EMPRESA
			CAB_FILIAL   := PED_EECO->FILIAL
			CAB_IDPEDIDO := PED_EECO->IDPEDIDO
			CAB_VENDEDOR := PED_EECO->VENDEDOR
			CAB_CLIENTE  := PED_EECO->CLIENTE
			CAB_LOJA     := PED_EECO->LOJA
			CAB_RAZAO    := PED_EECO->RAZAO
			CAB_DTPEDIDO := PED_EECO->DTPEDIDO
			CAB_VALOR    := PED_EECO->VALOR
			CAB_STATUS   := PED_EECO->STATUS
			CAB_ERRO     := PED_EECO->ERRO
		    Exit
		EndIf
	   PED_EECO->(DbSkip())
	Enddo
	PED_EECO->(dbGoTo(nRECPED))
	
	If CAB_EMPRESA == ""
		Aviso("Aviso","Nenhum pedido foi selecionado para visualização.",{"OK"})
		Return 
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Montagem dos campos de itens                                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Aadd(aHeadITE,{"Produto", 	   		"ITE_CODPRD", "",	 				15,							0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Descrição", 	   	"ITE_DESPRD", "",	 				TAMSX3("B1_DESC")[1], 		0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Quantidade",   		"ITE_QTDADE", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Preço Venda",	   	"ITE_PRCVEN", "@E 999,999,999.99",	TAMSX3("C6_PRCVEN")[1],		TAMSX3("C6_PRCVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Valor Total",	   	"ITE_VLRTOT", "@E 999,999,999.99",	TAMSX3("C6_VALOR")[1],		TAMSX3("C6_VALOR")[2], 		, ,"N",, }) 
	Aadd(aHeadITE,{"Desc. Unit.",  		"ITE_DESUNI", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Desc. Total",  		"ITE_DESTOT", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Valor ST",  		"ITE_SUBTRI", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Promoção", 	   		"ITE_PROMOC", "",	 				1,							0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Bonificado",	   	"ITE_BONIFI", "",	 				1,							0,							, ,"C",, }) 

	DEFINE MSDIALOG oDlgeEco TITLE "Visualização do pedido "+cValToChar(CAB_IDPEDIDO) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL

	@ 005,005 TO 070,440
	@ 010,010 SAY		oCPOTIT PROMPT "Empresa" 			SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 010,045 MSGET 	oCPODAT VAR CAB_EMPRESA 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 010,100 SAY		oCPOTIT PROMPT "Filial" 			SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 010,135 MSGET 	oCPODAT VAR CAB_FILIAL	 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 010,190 SAY		oCPOTIT PROMPT "Id. Pedido"		SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 010,225 MSGET 	oCPODAT VAR CAB_IDPEDIDO 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	@ 025,010 SAY		oCPOTIT PROMPT "Cliente"			SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,045 MSGET 	oCPODAT VAR CAB_CLIENTE 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,100 SAY		oCPOTIT PROMPT "Loja"	 				SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,135 MSGET 	oCPODAT VAR CAB_LOJA	 			SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,190 SAY		oCPOTIT PROMPT "Razão Social"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,225 MSGET 	oCPODAT VAR CAB_RAZAO	 			SIZE 150, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	@ 040,010 SAY		oCPOTIT PROMPT "Vendedor" 		SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,045 MSGET 	oCPODAT VAR CAB_VENDEDOR 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,100 SAY		oCPOTIT PROMPT "Data Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,135 MSGET 	oCPODAT VAR CAB_DTPEDIDO 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,190 SAY		oCPOTIT PROMPT "Valor Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,225 MSGET 	oCPODAT VAR CAB_VALOR	 			SIZE 040, 007 PICTURE "@E 999,999.99" OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	@ 055,010 SAY		oCPOTIT PROMPT "Status Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,045 MSGET 	oCPODAT VAR CAB_STATUS	 			SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,100 SAY		oCPOTIT PROMPT "Msg Integração"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,135 MSGET 	oCPODAT VAR CAB_ERRO	 				SIZE 240, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	oItensPV := MsNewGetDados():New( 080, 5, 205, 440, 3, "AllwaysTrue()", "AllwaysTrue()", , , 000, 999,, "", .T., oDlgeEco, aHeadITE ,aColsITE )

	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 056, 013 OF oDlgeEco ACTION Close(oDlgeEco) PIXEL
	
	RptStatus({|lEnd| LoadItens(CAB_IDPEDIDO,lEnd)}, "Aguarde...","Atualizando itens do pedido no Grid...", .T.)
	
	ACTIVATE MSDIALOG oDlgeEco CENTERED
	

Return                          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³LoadItens ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Popula array dos itens.                                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function LoadItens(cIdPedido,lEND)

	oItensPV:aCols := {}
	
	cSql := "select SubStr(itens.codigoauxiliar_item,01,15) as codigo, "  
	cSql += "       itens.quantidade, "                                   
	cSql += "       itens.valorunitarionormal as vlrunitario, "           
	cSql += "       itens.valorunitariobruto as precovenda, "             
	cSql += "       itens.descontoitem / itens.quantidade as descunit, " 
	cSql += "       itens.descontoitem as desctotal, "                   
	cSql += "       itens.valorunitariobruto as vlrstrib, "              
	cSql += "				itens.promocao, "                            
	cSql += "       itens.bonificado, "                                  
	cSql += "       itens.embalagem as unidade, "                        
	cSql += "       itens.codigokit, "                                   
	cSql += "       itens.idpedido "                                     
	cSql += "from eeco_itens itens "                                     
	cSql += "where idpedido = "+ cValToChar(cIdPedido)
	
	TCQUERY cSql NEW ALIAS "itens"
	
	dbSelectArea("itens")
	itens->(dbGoTop())
	If (itens->(!Eof()))	
		While (itens->(!Eof()))	
		
			dbSelectArea("SB1")
			SB1->(dbSetOrder(01))
			SB1->(dbSeek(xFilial("SB1") + AllTrim(itens->codigo)))
			
			aAdd(oItensPV:aCols, Array(Len(oItensPV:aHeader)+1))
			oItensPV:aCols[Len(oItensPV:aCols),01] := itens->codigo
			oItensPV:aCols[Len(oItensPV:aCols),02] := SB1->B1_DESC
			oItensPV:aCols[Len(oItensPV:aCols),03] := itens->quantidade
			oItensPV:aCols[Len(oItensPV:aCols),04] := itens->precovenda
			oItensPV:aCols[Len(oItensPV:aCols),05] := Round(itens->quantidade*itens->precovenda,2)
			oItensPV:aCols[Len(oItensPV:aCols),06] := itens->descunit
			oItensPV:aCols[Len(oItensPV:aCols),07] := itens->desctotal
			oItensPV:aCols[Len(oItensPV:aCols),08] := itens->vlrstrib
			oItensPV:aCols[Len(oItensPV:aCols),09] := itens->promocao
			oItensPV:aCols[Len(oItensPV:aCols),10] := itens->bonificado
			oItensPV:aCols[Len(oItensPV:aCols),Len(oItensPV:aHeader)+1] := .F.
			
			itens->(dbSkip())
		Enddo
	Else 
		aAdd(oItensPV:aCols, Array(Len(oItensPV:aHeader)+1))
		oItensPV:aCols[Len(oItensPV:aCols),Len(oItensPV:aHeader)+1] := .F.
	EndIf
	itens->(dbCloseArea())
	
	oItensPV:Refresh()
	oDlgeEco:Refresh()
	
Return                       


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ExcPed    ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada para fazer a exclusão do pedido da tabela   º±±
±±º          ³ de integração.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ExcPed()

Local nRECPED := PED_EECO->(RECNO())
Local aDELETE := {}

	dbSelectArea("PED_EECO")
	PED_EECO->(DbGoTop())
	Do While !PED_EECO->(Eof())
		If !Empty(PED_EECO->MARK)
			If PED_EECO->STATUS == -1 .OR. PED_EECO->STATUS == 5
				aAdd (aDELETE, PED_EECO->IDPEDIDO)
			EndIf
		EndIf
	   PED_EECO->(DbSkip())
	Enddo
	PED_EECO->(dbGoTo(nRECPED))
	
	If Len(aDELETE) == 0
		Aviso("Aviso","Nenhum pedido foi selecionado para exclusão.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a exclusão do(s) pedido(s) selecionado(s)?",{"Sim","Não"}) != 1
			Return
		EndIf
	EndIf
	
	RptStatus({|lEnd| fProcExc(aDELETE,lEnd)}, "Aguarde...","Excluindo pedido(s) selecionado(s)...", .T.)
	
Return                       



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³fProcExc  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada para fazer a exclusão do pedido da tabela   º±±
±±º          ³ de integração.                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fProcExc(aDELETE,lEnd)
	                                           
	Begin Transaction
		For nI := 1 to Len(aDELETE)
			cSql := "delete from eeco_itens where idpedido = "+ cValToChar(aDELETE[nI])
			TCSQLExec(cSql)
			cSql := "delete from eeco_pedido where idpedido = "+ cValToChar(aDELETE[nI])
			TCSQLExec(cSql)
		Next nI       
	End Transaction
	
	//--Recarrega os pedidos no grid principal.
	CarregaDados()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³ErrosInt  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada para mostrar detalhadamente os erros de     º±±
±±º          ³ integração.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
Static Function ErrosInt()          
*----------------------------*
Local nRECPED := PED_EECO->(RECNO())
Local cIdPedido := 0
Local cErroPedido := ""
Private oMemo, oDlgeEco 

	dbSelectArea("PED_EECO")
	PED_EECO->(DbGoTop())
	Do While !PED_EECO->(Eof())
		If !Empty(PED_EECO->MARK)
			cIdPedido := PED_EECO->IDPEDIDO
			Exit
		EndIf
	   PED_EECO->(DbSkip())
	Enddo
	PED_EECO->(dbGoTo(nRECPED))
	
	If cIdPedido == 0
		Aviso("Aviso","Nenhum pedido foi selecionado para visualização de erros.",{"OK"})
		Return
	EndIf

	cSql := "select trim(mostraerro) mostraerro from eeco_pedido where idpedido = "+ cValToChar(cIdPedido)
	
	TCQUERY cSql NEW ALIAS "erroped"
	
	dbSelectArea("erroped")
	erroped->(dbGoTop())
	If !erroped->(EOF())
		cErroPedido := STRTRAN(erroped->mostraerro,"*",chr(10)+chr(13))			 
	EndIf
	erroped->(dbCloseArea())
	
	If Empty(cErroPedido)
		Aviso("Aviso","Não existem dados para visualização.",{"OK"})
		Return
	EndIf
		
	DEFINE MSDIALOG oDlgeEco TITLE "Erros de integração do pedido "+cValToChar(cIdPedido) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErroPedido MEMO SIZE 420,200 OF oDlgeEco PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlgeEco ACTION Close(oDlgeEco) PIXEL
	
	ACTIVATE MSDIALOG oDlgeEco CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³CriaSX1   ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função de manutenção do grupo de perguntas                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CriaSx1(cPerg)
	PutSx1(cPerg,"01","Emissao De:"    ,"Emissao De:"    ,"Emissao De:"    ,"mv_ch1","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par01",""   ,"","","Date()",""   )
	PutSx1(cPerg,"02","Emissao Ate: "  ,"Emissao Ate: "  ,"Emissao Ate: "  ,"mv_ch2","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par02",""   ,"","","Date()",""   )
	PutSx1(cPerg,"03","Cliente De: "   ,"Cliente De: "   ,"Cliente De: "   ,"mv_ch3","C",09,0,0,"G",""        ,"SA1","","","mv_par03")
	PutSx1(cPerg,"04","Cliente Ate: "  ,"Cliente Ate: "  ,"Cliente Ate: "  ,"mv_ch4","C",09,0,0,"G","NaoVazio","SA1","","","mv_par04") 
	PutSx1(cPerg,"05","Loja De: "      ,"Loja De: "      ,"Loja De: "      ,"mv_ch5","C",04,0,0,"G",""        ,""   ,"","","mv_par05")
	PutSx1(cPerg,"06","Loja Ate: "     ,"Loja Ate: "     ,"Loja Ate: "     ,"mv_ch6","C",04,0,0,"G","NaoVazio",""   ,"","","mv_par06")
	PutSx1(cPerg,"07","Vendedor De: "  ,"Vendedor: "	   ,"Vendedor: "	   ,"mv_ch7","C",06,0,0,"G",""        ,"SA3","","","mv_par07")
	PutSx1(cPerg,"08","Vendedor Ate: " ,"Vendedor Ate: " ,"Vendedor Ate: " ,"mv_ch8","C",06,0,0,"G","NaoVazio","SA3","","","mv_par08")
	PutSx1(cPerg,"09","Ped. Emp/Fil: " ,"Ped. Emp/Fil: " ,"Ped. Emp/Fil: " ,"mv_ch9","C",01,0,0,"C",""        ,""   ,"","","mv_par09","1=Sim","","","2" ,"2=Nao")
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FGETPORT  ºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a porta de execucao do protheus server.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FGETPORT()
Return(GetPvProfString( "TCP", "port", "20003", GetAdv97()))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFunção    ³FMILBITENSºAutor  ³Jean Carlos Saggin  º Data ³  19/12/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Liberacao de credito/estoque do pedido.                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ALTPEDEECO                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function FMILBITENS(cNUMPED)

Local aAreaTMP := GetArea()
Local cPedido  := cNUMPED

	lQuery := .T.
	bValid := {|| .T.}				
	cAliasSC9 := "A450LIBMAN"
	cQuery := "SELECT C9_FILIAL,C9_PEDIDO,C9_BLCRED,R_E_C_N_O_ SC9RECNO"
	cQuery += "FROM "+RetSqlName("SC9")+" SC9 "
	cQuery += "WHERE SC9.C9_FILIAL = '"+xFilial("SC9")+"' AND "
	cQuery += "SC9.C9_PEDIDO = '"+cPedido+"' AND "
	cQuery += "(SC9.C9_BLEST <> '  ' OR "
	cQuery += "SC9.C9_BLCRED <> '  ' ) AND "
	cQuery += "SC9.C9_BLCRED NOT IN('10','09') AND "
	cQuery += "SC9.C9_BLEST <> '10' AND "
	cQuery += "SC9.D_E_L_E_T_ = ' ' "		

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC9,.T.,.T.)
	nTotRec := SC9->(LastRec())
	
	While ( !Eof() .And. (cAliasSC9)->C9_FILIAL == xFilial("SC9") .And.;
			(cAliasSC9)->C9_PEDIDO == cPedido .And. Eval(bValid) ) 				
			
		SC9->(MsGoto((cAliasSC9)->SC9RECNO))
	
		If !( (Empty(SC9->C9_BLCRED) .And. Empty(SC9->C9_BLEST)) .Or.;
				(SC9->C9_BLCRED=="10" .And. SC9->C9_BLEST=="10") .Or.;
				SC9->C9_BLCRED=="09" )
				
			/** 
			Obs- Não será chamada função padrão (a450Grava), pois caso o produto possua lote não realiza a liberação com saldo inferior. 
			a450Grava(1,.T.,.T.)
			**/ 
		             
		    dbSelectArea("SC6")
		    dbSetOrder(1)
		    SC6->(dbGoTop())
		    If SC6->(dbSeek(xFilial("SC6")+SC9->C9_PEDIDO+SC9->C9_ITEM+SC9->C9_PRODUTO))
				If RecLock("SC9",.F.)
					SC9->C9_BLCRED  := Space(TAMSX3("C9_BLCRED")[1])
					SC9->C9_BLEST   := Space(TAMSX3("C9_BLEST")[1]) 
					SC9->C9_LOTECTL := SC6->C6_LOTECTL
					SC9->C9_DTVALID := SC6->C6_DTVALID
				EndIf				 
			EndIf		
		EndIf
		
		dbSelectArea(cAliasSC9)
		dbSkip()
	
	EndDo

	dbSelectArea(cAliasSC9)
	dbCloseArea()
	dbSelectArea("SC9")
	
	RestArea(aAreaTMP)

Return
