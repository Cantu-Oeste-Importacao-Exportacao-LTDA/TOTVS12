#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
                               
#DEFINE CIPSERVER 	"192.168.205.30"          // IP do servi็o Protheus responsแvel pela importa็ใo dos pedidos
#DEFINE MAX_PED  	30                   	  // Tamanho mแximo da fila para importa็ใo de pedidos       
#DEFINE MAX_HORA  	"23:59:59"               // Ponto de corte inicial para libera็ใo automแtica de pedidos
#DEFINE MIN_HORA  	"00:00:01"               // Ponto de corte final para libera็ใo automแtica de pedidos
#DEFINE LCORTA		.F.                  	// Indica se os itens sem saldo no controle de lotes deverใo ser cortados.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPPEDEECO บAutor  ณJEAN SAGGIN        บ Data ณ  27/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo para importa็ใo dos pedidos do sistema de for็a    บฑฑ
ฑฑบ          ณ  de vendas eEco                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Schedule                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

/******STATUS DOS PEDIDOS**********
[ -1 | PEDIDO COM ERRO			  ]
[ 0  | PRONTO PARA PROCESSAMENTO  ]
[ 1  | PEDIDO EM PROCESSAMENTO	  ]
[ 2  | PEDIDO JA EXISTE COM NUMERO]
**********************************/

*--------------------------*
User Function IMPPEDNEO()    
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
Private cEmpIni	  := "01"
Private cFilIni	  := "01"
Private nX        := 0
Private aPedidos  := {}
Private nLock     := 0
Private nQtdPed   := 0
Private cEol      := CHR(13)+CHR(10)
Private lAguarda  := .F.     

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

ConOut("IMPPEDEECO - INICIANDO IMPORTACAO DE PEDIDOS") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera empresa/filial do APPSERVER.INIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

//@qui
cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2) 
cCODFIL := SubSTR(cEMPFIL,4,2)

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
	ConOut("IMPPEDNEOGRID - EXECUTANDO PARA EMPRESA "+cEmpIni) 
Else
	ConOut("IMPPEDNEOGRID - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN") 
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona o sistema em uma empresa para dar inํcio na sele็ใo dos dadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmpIni, cFilIni,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria็ใo de arquivo temporแrio sobre a execu็ใo da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"IMPPEDNEO"+cCODEMP,"IMPPEDNEO"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois jแ esta sendo executada!")
		Return
	EndIf		
EndDo

ConOut("IMPPEDNEOGRID - CONECTANDO NO BANCO INTERMEDIมRIO...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTฟ
//ณBusca quais empresas tem pedido para importar e ordena pela que tem maisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTู

cSql := "SELECT DISTINCT EMPRCBPD, FILICBPD, COUNT(*) AS QUANT FROM  EDI_CBPD PED "
cSql += " WHERE PED.STATCBPD = 0"                                                
cSql += "   AND PED.EMPRCBPD <> ' ' "
cSql += "   AND PED.FILICBPD <> ' ' "
cSql += "   AND TRIM(PED.EMPRCBPD) IN ('01','02','06','07','09','10','40') "  
cSql += " GROUP BY EMPRCBPD, FILICBPD "
cSql += " ORDER BY QUANT DESC "

TcQuery cSql New Alias "EMPFIL"

DbSelectArea("EMPFIL")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno nใo ้ vazioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if EMPFIL->(Eof())
	EMPFIL->(DbCloseArea())	
	ConOut("IMPPEDNEOGRID - SEM PEDIDOS A IMPORTAR") 
	Return  
EndIf

While EMPFIL->(!Eof())
	nTmpQtd := 0
	if nQtdPed >= MAX_PED
		Exit               
	Else
		if (nQtdPed + EMPFIL->quant) > MAX_PED
			nTmpQtd := MAX_PED - nQtdPed
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPFIL->EMPRCBPD, EMPFIL->FILICBPD, nTmpQtd})
		Else
			nTmpQtd := EMPFIL->QUANT
			nQtdPed += nTmpQtd
			aAdd(aEmpFil, {EMPFIL->EMPRCBPD, EMPFIL->FILICBPD, nTmpQtd})
		EndIf                                                      
	EndIf 
	EMPFIL->(dbSkip())
EndDo
                               	
EMPFIL->(DbCloseArea())

For nEmp := 1 to len(aEmpFil)           

	If AllTrim(aEmpFil[nEmp,01]) != cEmpAnt .or. AllTrim(aEmpFil[nEmp,02]) != cFilAnt
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(AllTrim(Transform(aEmpFil[nEmp,01], "@! 99")), AllTrim(Transform(aEmpFil[nEmp,02], "@! 99" )),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	EndIf
		
	ConOut("IMPPEDNEOGRID - BUSCANDO PEDIDOS DA EMPRESA "+Trim(aEmpFil[nEmp,01])+" FILIAL "+Trim(aEmpFil[nEmp,02]))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "0"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cSql := "SELECT PEDIDO.PEDICBPD AS IDPEDIDO, "                                     +cEol
	cSql += "       PEDIDO.STATCBPD, "                                                 +cEol
	cSql += "       PEDIDO.EMISCBPD AS DTPEDIDO, "						               +cEol
//	cSql += "       TO_CHAR(PEDIDO.dtpedido, 'hh24:mi:ss') as horapedido, "            +cEol
	cSql += "       PEDIDO.SEGECBPD AS SEGMENTO, " 				                       +cEol
	cSql += "       CAST(PEDIDO.MSG_CBPD AS VARCHAR(3000)) AS OBS, "                   +cEol
//	cSql += "       TO_CHAR(PEDIDO.dataprocessamento, 'yyyymmdd') as dtdispon, "       +cEol
//	cSql += "       TO_CHAR(PEDIDO.dataprocessamento, 'hh24:mi:ss') as horadispon, "   +cEol
//	cSql += "       PEDIDO.valortotal, "                                               +cEol
	cSql += "       TRIM(PEDIDO.EMPRCBPD) AS EMPRESA, "	                               +cEol
	cSql += "       TRIM(PEDIDO.FILICBPD) AS FILIAL, "                                 +cEol
	cSql += "       PEDIDO.TABECBPD AS TABELA, " 				                       +cEol
	cSql += "       PEDIDO.CONDCBPD AS FORMAPAGAMENTO, " 					           +cEol
//	cSql += "       PEDIDO.codtrans, "                                                 +cEol
	cSql += "       PEDIDO.VENDCBPD AS VENDEDORERP, "				                   +cEol
	cSql += "       PEDIDO.CLIECBPD AS CLIENTE, " 				                       +cEol
	cSql += "       PEDIDO.LOJACBPD AS LOJA "				                           +cEol
//	cSql += "       to_char(PEDIDO.dataentrega, 'yyyymmdd') as dataentrega "           +cEol
	cSql += " FROM EDI_CBPD PEDIDO "                               					   +cEol
	cSql += "WHERE PEDIDO.EMPRCBPD = '"+ AllTrim(aEmpFil[nEmp, 01]) +"' "              +cEol
	cSql += "  AND PEDIDO.FILICBPD = '"+ AllTrim(aEmpFil[nEmp, 02]) +"' "              +cEol
	cSql += "  AND PEDIDO.STATCBPD = 0 "                                               +cEol
	cSql += "  AND ROWNUM <= "+ AllTrim(Str(aEmpFil[nEmp, 03]))                        +cEol
	cSql += "ORDER BY PEDIDO.PEDICBPD"
	
	TCQUERY Upper(cSql) NEW ALIAS "PEDIDO"
	
	DbSelectArea("PEDIDO")
	PEDIDO->(DbGoTop())
	
	aPedidos := {}
	
	while !PEDIDO->(eof())
		aAdd(aPedidos, {PEDIDO->IDPEDIDO,; 
										PEDIDO->STATCBPD,;
										PEDIDO->DTPEDIDO,; 
										PEDIDO->SEGMENTO,;
										PEDIDO->OBS,;
										Trim(PEDIDO->EMPRESA),;
										Trim(PEDIDO->FILIAL),;
										PEDIDO->TABELA,;
										PEDIDO->FORMAPAGAMENTO,;
										PEDIDO->VENDEDORERP,;
										PEDIDO->CLIENTE,;
										PEDIDO->LOJA})

		PEDIDO->(DbSkip())
	EndDo
	
	PEDIDO->(DbCloseArea())
	
	If Len(aPedidos) > 0
		IncluiPedido(aPedidos)           
	EndIf
	
Next nEmp

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAvalia threads em execu็ใo e aguarda at้ que todos os pedidos sejam incluํdos pra finalizar a rotina
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

While !FreeAllThreads()
	Sleep(10000)
End Do

ConOut("IMPPEDNEOGRID - FIM DA EXECUCAO")

RpcClearEnv() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncluiPedido บAutor  ณJean Saggin      บ Data ณ  29/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que monta os itens do pedido.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IncluiPedido(aPedidos)     

Local lErrGrv  := .F.
Local nQtdERP  := 0
Local nQtdeEco := 0
  
	lAguarda := .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamada da fun็ใo para fazer o ajuste do status dos pedidos em processamentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AltStatus(aPedidos)     	   
	
	For nX := 1 to len(aPedidos)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se jแ existe algum pedido cadastrado no sistema com o mesmo c๓digo de Licita็ใo.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aTemp  := {}
		aAdd(aTemp, {"C5_FILIAL"  ,aPedidos[nX, 07], Nil})
		aAdd(aTemp, {"C5_COTACAO" ,aPedidos[nX, 01], Nil})
		
		cPedSinc := ""
		aPedSinc := AvalLicit(aTemp)
		cPedSinc := aPedSinc[01]
		nQtdERP  := aPedSinc[02]
		nQtdeEco := aPedSinc[03]  
			
		lExist  := !Empty(cPedSinc)
		
		if lExist
			
			lErrGrv := nQtdERP < nQtdeEco
			
			If lErrGrv
				cErro := "PEDIDO INCLUIDO FALTANDO "+ AllTrim(Str(nQtdeEco - nQtdERP)) +" ITENS. NUMERO NO PROTHEUS: "+ cPedSinc

				GrvStatus(Alltrim(aPedidos[nX, 01]), -1, cErro)
				EnviaErro(cErro, {}, {}, 1)
			Else
				GrvStatus(AllTrim(aPedidos[nX, 01]), 2, "PEDIDO JA EXISTE COM NUMERO "+ cPedSinc)
			EndIf
			
			Loop
		EndIf
		
		aCabPed := {}
		cErro 	:= ' '
				
		ConOut("IMPPEDNEOGRID - ID PEDIDO " + aPedidos[nX, 01])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do cabe็alho do pedido.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		aAdd(aCabPed, {"C5_FILIAL",  aPedidos[nX, 07],Nil})
		aAdd(aCabPed, {"C5_TIPO",    "N", Nil})		
		aAdd(aCabPed, {"C5_COTACAO", "EDI"+aPedidos[nX, 01],Nil})
		aAdd(aCabPed, {"C5_CLIENTE", aPedidos[nX, 11],Nil})		
		aAdd(aCabPed, {"C5_LOJACLI", aPedidos[nX, 12],Nil})
		aAdd(aCabPed, {"C5_CLIENT" , aPedidos[nX, 11],Nil})
		aAdd(aCabPed, {"C5_LOJAENT", aPedidos[nX, 12],Nil})
    
		cOper    := " "
		lConsFin := .F.
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณPosiciona o sistema na tabela de clientesณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
		DbSelectArea("SA1")
		SA1->(dbSetOrder(01))
		if SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))
			cTipoCli := AllTrim(SA1->A1_TIPO)
			cDesTipo := iif(cTipoCli == 'F',"CONSUMIDOR FINAL",iif(cTipoCli == 'L',"PRODUTOR RURAL",;
									iif(cTipoCli == 'R',"REVENDEDOR"      ,iif(cTipoCli == 'S',"SOLIDARIO",;
									iif(cTipoCli == 'X',"EXPORTACAO"      ," "))))) 
			Conout("IMPPEDNEOGRID - CLIENTE: "+AllTrim(SubStr(SA1->A1_NOME,1,30))+ " ("+ cDesTipo +")")
		Else
			cErro := "CLIENTE "+ aPedidos[nX, 11] +" LOJA "+ aPedidos[nX, 12] +" NรO ENCONTRADO"                    
			
			GrvStatus(aPedidos[nX, 01], -1, cErro)
			
			EnviaErro(cErro, {}, {}, 1)
			Loop     
		EndIf
    
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAvalia bloqueio do clienteณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		if SA1->A1_MSBLQL == '1'
			cErro := "CLIENTE "+ aPedidos[nX, 11] +"/"+ aPedidos[nX, 12] +" - "+ SubStr(SA1->A1_NOME, 01, 30) +" ESTม BLOQUEADO."                    
			
			GrvStatus(aPedidos[nX, 01], -1, cErro)
			
			EnviaErro(cErro, {}, {}, 1)
			Loop
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
		//ณAvalia se cliente ้ consumidor finalณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
		
		lConsFin := AllTrim(SA1->A1_TIPO) == 'F'
		if lConsFin
			cOper := '03' 
		Else
			cOper := '01' 
		EndIf

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAvalia se a condi็ใo de pagamento do pedido ้ '350' - Bonifica็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู		
		If aPedidos[nX, 9] == '350'
			cOper := '04' 
		EndIf
			
		aAdd(aCabPed, {"C5_TIPOCLI",cTipoCli,Nil})
		aAdd(aCabPed, {"C5_TABELA" ,aPedidos[nX, 08],Nil})
		aAdd(aCabPed, {"C5_CONDPAG",aPedidos[nX, 09],Nil})
  		aAdd(aCabPed, {"C5_VEND1"  ,aPedidos[nX, 10],Nil})
	  	aAdd(aCabPed, {"C5_PEDCLI" ," ",Nil})
	  	aAdd(aCabPed, {"C5_MENNOTA",iif(Empty(aPedidos[nX, 05]), " ", aPedidos[nX, 05]),Nil})
	  	aAdd(aCabPed, {"C5_EMISSAO",StoD(aPedidos[nX, 03]),Nil})
	  	aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil}) 
 		aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
  	
	  	cNumPed := GetSxeNum("SC5","C5_NUM")
  	
  		aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
  		aAdd(aCabPed, {"C5_X_TPLIC","2",Nil})
   		aAdd(aCabPed, {"C5_X_CLVL" ,aPedidos[nX, 04],Nil})		
		
		lSemItens := .F.
  		ConfirmSX8()
  	  	
   		aItemPed := BuscaItens(aPedidos[nX, 01], cNumPed, @lSemItens)
		
  	If lSemItens                                       
			cErro := "PEDIDO SEM PRODUTOS"
			
			GrvStatus(aPedidos[nX, 01], -1, cErro)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณJEAN 26/05/15 REMOVIDO ENVIO DE EMAIL DE PED. COM ERROณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			EnviaErro(cErro, aCabPed, aItemPed, 1)                                     
			
			Loop
		Else 

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณChamada de uma nova thread para a inclusใo do pedidoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

			StartJob("U_JOBNEOINT", GetEnvServer(), lAguarda, cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort)
			//U_JOBEECOINT(cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort)
			
  	EndIf
	
	Next nX
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBuscaItens   บAutor  ณJean Saggin      บ Data ณ  29/05/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que monta os itens do pedido.                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------*
Static Function BuscaItens(cIdPedido, cNumPed, lSemItens)     
*---------------------------------------------------*

Local aItemLinha 	:= {}
Local i, nFatConv 	:= 0
Local aArea      	:= GetArea()
Local cLocal    	:= ""
Local cTesForaUF 	:= ""
Local cTesST 		:= ""
Local cSql   		:= ""
Local cUFsST 		:= ""
Local cTesCP 		:= ""
Local cUFsCP 		:= ""
Local cTpCli 		:= ""
Local cVend  		:= Space(6)
Local lUfDif 		:= .F.
Local lLibPed 		:= SuperGetMV("MV_X_PSFAL", , .T.)
Local lMudaTES 		:= .F.
Local cTes 			:= ""
Local cCfop 		:= ""
Local cEol 			:= CHR(13)+CHR(10)

Private aItem     := {}   
Private aCortes   := {}
Private cItemNovo := PadL("00", Len(SC6->C6_ITEM))
      
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณBusca dos itens relacionados ao pedido que estแ sendo processado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cSql := "SELECT ITENS.PRODMVPD AS CODIGO, " 						            +cEol
cSql += "       ITENS.QUANMVPD AS QUANTIDADE, "                                 +cEol
//cSql += "       ITENS.valorunitarionormal as vlrunitario, "                   +cEol
cSql += "       ITENS.PRUNMVPD AS PRECOVENDA, " 			                    +cEol
cSql += "       ITENS.TABEMVPD, "			 	 			                    +cEol
//cSql += "       ITENS.descontoitem / ITENS.quantidade as descunit, "            +cEol
//cSql += "       ITENS.descontoitem as desctotal, "                              +cEol
//cSql += "       ITENS.valorunitariobruto as vlrstrib, "                         +cEol
//cSql += "		  ITENS.promocao, "   						                      +cEol
//cSql += "       ITENS.bonificado, "                                             +cEol
//cSql += "       ITENS.embalagem as unidade, "                                   +cEol
//cSql += "       ITENS.codigokit, "  	                                          +cEol
cSql += "       ITENS.CODICBPD "                                                +cEol
cSql += "FROM  EDI_MVPD ITENS "                                      			+cEol 
cSql += "INNER JOIN EDI_CBPD CAB"								 				+cEol
cSql += " ON CAB.CODICBPD = ITENS.CODICBPD"								 		+cEol
cSql += "WHERE CAB.PEDICBPD = "+ cIdPedido

TCQUERY cSql NEW ALIAS "ITENS"

dbSelectArea("ITENS")
ITENS->(dbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAvalia se o pedido tem itensณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If ITENS->(Eof())
	lSemItens := .T.
	ITENS->(DbCloseArea())
	Return aItem
EndIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona no cliente para buscar o Estado e o Tipoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cUFCli := Posicione("SA1", 01, xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12], "A1_EST")
cTpCli := Posicione("SA1", 01, xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12], "A1_TIPO")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

While (ITENS->(!Eof()))	    
    
	If Empty(AllTrim(ITENS->CODIGO))
		ConOut("IMPPEDNEOGRID - CODIGO DO PRODUTO INFORMADO NAO ENCONTRADO PARA PEDIDO" + aPedidos[nX, 01])

		lSemItens := .T. 
		ITENS->(dbCloseArea())
		Return aItem
	EndIf	
	
	lMudaTES  := .F.
	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLinha, {"C6_NUM"        ,cNumPed,Nil})
	aAdd(aItemLinha, {"C6_ITEM"       ,cItemNovo,Nil})  
	aAdd(aItemLinha, {"C6_PRODUTO"    ,AllTrim(ITENS->CODIGO),Nil})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณPosiciona na tabela de produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	DbSelectArea("SB1")
	SB1->(dbSetOrder(01))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->CODIGO)))
	
	
	lLote := .F.
	lLote := SB1->B1_RASTRO == "L"
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณTratativa da segunda unidade de medidaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
/*
	lSegUn  := .F.
	nQtdPUM := 0
	nValPUM := 0
	
	If !Empty(ITENS->UNIDADE)
		Do Case
			Case AllTrim(ITENS->UNIDADE) == SB1->B1_UM
				aAdd(aItemLinha, {"C6_IMPUNI", "1", Nil})
				aAdd(aItemLinha, {"C6_QTDVEN",ITENS->QUANTIDADE,Nil})
				aAdd(aItemLinha, {"C6_PRCVEN",ITENS->PRECOVENDA,Nil})				

			Case AllTrim(ITENS->unidade) == SB1->B1_SEGUM
				lSegUn := .T.
				aAdd(aItemLinha, {"C6_IMPUNI", "2", Nil})
				aAdd(aItemLinha, {"C6_UNSVEN", ITENS->quantidade, Nil})
				aAdd(aItemLinha, {"C6_PRCSU", ITENS->precovenda, Nil}) 

				if Trim(SB1->B1_TIPCONV) == 'M'
					nQtdPUM := Round(ITENS->quantidade / SB1->B1_CONV,TamSx3("C6_QTDVEN")[02])
					nValPUM := Round(ITENS->precovenda * SB1->B1_CONV,TamSx3("C6_PRCVEN")[02])
				Else 
					nQtdPUM := Round(ITENS->quantidade * SB1->B1_CONV,TamSx3("C6_QTDVEN")[02])
					nValPUM := Round(ITENS->precovenda / SB1->B1_CONV,TamSx3("C6_PRCVEN")[02])	
				EndIf
				
				aAdd(aItemLinha, {"C6_QTDVEN", nQtdPUM, Nil})
				aAdd(aItemLinha, {"C6_PRCVEN", nValPUM, Nil})
		EndCase	    
	Else
		aAdd(aItemLinha, {"C6_QTDVEN",ITENS->quantidade,Nil})
		aAdd(aItemLinha, {"C6_PRCVEN",ITENS->precovenda,Nil})						
	EndIf
*/
		aAdd(aItemLinha, {"C6_QTDVEN",ITENS->QUANTIDADE,Nil})
		aAdd(aItemLinha, {"C6_PRCVEN",ITENS->PRECOVENDA,Nil})						

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPosiciona na tabela de Indicador de Produtoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	dbSelectArea("SBZ")
	SBZ->(dbSetOrder(1))
	SBZ->(dbSeek ( xFilial("SBZ") + AllTrim(ITENS->CODIGO)))
	
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
	aAdd(aItemLinha, {"C6_PRCTAB",Round(ITENS->TABEMVPD,2),Nil})
	aAdd(aItemLinha, {"C6_VALOR" ,Round(ITENS->QUANTIDADE * ITENS->PRECOVENDA,2),Nil})
//	aAdd(aItemLinha, {"C6_ENTREG",iif(AllTrim(aPedidos[nX, 18]) >= DtoS(dDataBase),StoD(aPedidos[nX, 18]),dDataBase),Nil})
	aAdd(aItemLinha, {"C6_LOCAL" ,SBZ->BZ_LOCPAD,Nil})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณTratativa tabela promocionalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
/*	
	If AllTrim(ITENS->promocao) == 'T'
		aAdd(aItemLinha, {"C6_X_PROMO","S",Nil})
	Else
		aAdd(aItemLinha, {"C6_X_PROMO","N",Nil})
	EndIf
 
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณGrava็ใo do c๓digo do kit no pedido de venda
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	if !Empty(AllTrim(ITENS->codigokit))
		aAdd(aItemLinha, {"C6_X_KIT", AllTrim(ITENS->codigokit), Nil})
	EndIf
*/
	cTes := ""
	
	SF4->(dbSetOrder(01))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณapenas seta o tipo de opera็ใo caso seja pneu ou bonifica็ใoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	If cOper == "04"

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณJean (18/10/2012) - Tratativa para que todos os pedidos do segmento de pneus entrem com a seguinte regra:ณ
		//ณQuando o tipo de cliente for Consumidor Final, usa opera็ใo "03", caso contrแrio, usa opera็ใo "01"    	ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

		If Substr(aPedidos[nX, 04], 1, 3) == "005"
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ฟ
	//ณJEAN - 14/04/2014 - Tratativa para testar altera็ใo de CFOP para filial do vinhos SPณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ู	
/*	
	if cEmpAnt == "20"
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAltera a tes caso a mesma tenha sido informada e a venda ้ para fora do estado.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If lUfDif .And. !Empty(cTesForaUF) .And. (cOper != "04")
			cTes := cTesForaUF
			lMudaTES := .T.
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณavalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		
		If (cUFCli $ cUFsST .And. !Empty(cTesST)) .And. (cOper != "04")
			cTes := cTesST
			lMudaTES := .T.		
		EndIf
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณavalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de Credito Presumido para alguns produtosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
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
*/	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ฟ
	//ณJEAN FIM - 14/04/2014 - Tratativa para testar altera็ใo de CFOP para filial do vinhos SPณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ`ู
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se ้ pro pedido entrar liberado no sistemaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If lLibPed .And. (aPedidos[nX, 04] != '003001001')
		aAdd(aItemLinha, {"C6_QTDLIB",ITENS->QUANTIDADE,Nil})
	Else
		aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})	
	EndIf

	aAdd(aItemLinha, {"C6_X_VLORI",Round(ITENS->QUANTIDADE * ITENS->PRECOVENDA,2),Nil})
  
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤผ
	//ณChamada da fun็ใo para preenchimento automแtico da safra no item do pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤผ
	
	lSafraAut := SuperGetMv("MV_X_SFAUT",,.F.) .and. lLote .and. aPedidos[nX, 04] == "003001001"  

	if lSafraAut 
		//fSafraAuto(aItemLinha)
		lAguarda := .T.
 	Else
		aAdd(aItem, aItemLinha)
		ConOut("ITEM: "    +AllTrim(ITENS->CODIGO)+;
					 " DESC: "   +SubStr(SB1->B1_DESC, 01, 20)+;
					 " QUANT: "  +Transform(ITENS->QUANTIDADE,"@E 9,999,999.999")+;
			 		 " VL UN: "  +Transform(ITENS->PRECOVENDA,"@E 9,999,999.99")+;
			 		 " VL TOT: " +Transform((ITENS->QUANTIDADE * ITENS->PRECOVENDA),"@E 9,999,999.99")+;
			 		 " OPER: "   +cOper)
	EndIf
	
	aItemLinha := {}                                                                     
	
	ITENS->(dbskip())
	
EndDo

ITENS->(dbCloseArea())
  
Return aItem

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSafraAuto บAutor Jean Carlos Saggin     Data ณ  09/02/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel pelo preenchimento automแtico da safra  บฑฑ
ฑฑบ          ณ no pedido de venda do eEco.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Integra็ใo eEco                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValoriza as variแveis de acordo com a posi็ใo de cada uma no vetorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
//nPosPrM := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_PROMO"})
//nPosKit := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_X_KIT"})

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTฟ
//ณAvalia se o produto ainda tem saldo em estoque antes de buscar as safrasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTู

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
		  	
		  	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณDepois do primeiro loop, vai adicionando itens no pedidoณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				if nLoop > 1
					cItemNovo := Soma1(cItemNovo)
					aAdd(aItemLinha, {"C6_ITEM", cItemNovo, Nil})
				EndIf
		  	
		  	if nQtdVen > nSldB8

					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤr
					//ณAjustes de quantidades e valores referente a quebra de saldos por loteณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤr
					
					if nLoop = 1
						aItemLinha[nPosQtd][02] := nSldB8
						aItemLinha[nPosVlO][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
						if aItemLinha[nPosUm ][02] == '1'
							aItemLinha[nPosQtL][02] := nSldB8
						ElseIf aItemLinha[nPosUm ][02] == '2'
							aItemLinha[nPosQt2][02] := nSldB8
						EndIf
						aItemLinha[nPosVlr][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณAvalia se o campo Lote jแ existe no vetor antes de gravar a informa็ใoณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						
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
						
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณAtualiza as variแveis de acordo com a posi็ใo de cada uma no vetorณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
						
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
		
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤr
					//ณAjustes de quantidades e valores referente a quebra de saldos por loteณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤr
		
					aItemLinha[nPosQtd][02] := nQtdVen
					aItemLinha[nPosVlO][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
					if aItemLinha[nPosUm ][02] == '1'
						aItemLinha[nPosQtL][02] := nQtdVen
					ElseIf aItemLinha[nPosUm ][02] == '2'
						aItemLinha[nPosQt2][02] := nQtdVen
					EndIf
					aItemLinha[nPosVlr][02] := Round(aItemLinha[nPosQtd][02] * aItemLinha[nPosPrc][02], 2)
		
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAvalia se o campo Lote jแ existe no vetor antes de gravar a informa็ใoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAvalia se deve deve cortar o saldo de itens que nใo tem em estoqueณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	if LCORTA
		aAdd(aCortes, {aItemLinha[nPosCod][02], nQtdVen})  
		ConOut("Cortando Item c๓digo: "+ aItemLinha[nPosCod][02] +" Quant. "+ Transform(nQtdVen,"@E 9,999,999.999"))
	Else 
		nPosLot := aScan(aItemLinha, {|x| AllTrim(x[01]) == "C6_LOTECTL"})
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAdiciona o saldo que nใo tem nos lotes com safra em brancoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
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
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAtualiza as variแveis de acordo com a posi็ใo de cada uma no vetorณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
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
	      
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
			//ณGrava vazio no campo de lote para que, posteriormente, algu้m avalieณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู 
			
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel por buscar a unidade de medida do produto conforme escolha do representanteณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Faz o processo de enviar o email caso ocorreu erroณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู 

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

	cVend    := aPedidos[nX, 10]
	cCli     := aPedidos[nX, 11]
	cLojaCli := aPedidos[nX, 12]
	cNomeCli := SubStr(Posicione("SA1", 01, xFilial("SA1") + cCli + cLojaCli, "A1_NOME"), 01, 30)		
  
	nValTot  := 0//aPedidos[nX, 9]
	cCotacao := aPedidos[nX, 01]
EndIf

cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Com Erro Neogrid"))
oProcess:NewTask(cStatus,"\workflow\wfpedcomerro.htm")
oProcess:cSubject := OemToAnsi("Pedido cliente "+ AllTrim(cNomeCli) +" Valor R$ "+ AllTrim(Transform(nValTot, "@E 9,999,999.99")) +;
															 " nใo sincronizado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := "microsiga@cantu.com.br"
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

//@qui                           
oProcess:cTo := AllTrim(cEmail)
oProcess:cCC := cMailCC
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณPreenchimento do cabe็alho do pedidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู

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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz o processo de enviar o email para o vendedor confirmando da sincroniza็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido Neogrid"))
oProcess:NewTask(cStatus,"\workflow\wfpedsincronizado.htm")
oProcess:cSubject := OemToAnsi("NEOGRID - Pedido cliente " + cNomeCli + " recebido - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := "microsiga@cantu.com.br"
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

//@qui  
oProcess:cTo := ALLTRIM(cEmail) 
oProcess:cCC := "sim3g@grupocantu.com.br" 
//oProcess:cTo := "suporte.microsiga@grupocantu.com.br"
                                    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณPreenchimento do cabe็alho do pedidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJOBNEOINT บAutor  ณMicrosiga           บ Data ณ  14/03/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina chamada pela fun็ใo StartJob para fazer a inclusใo	บฑฑ
ฑฑบ          ณ do pedido no Protheus.                                     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                               	บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------------------------------------------------------------------------------*
User Function JOBNEOINT(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort)      
*--------------------------------------------------------------------------------------------------*
Local cIdPedido := AllTrim(idPedido)
Local cSql 		:= ""
Local cEnv 		:= GetEnvServer()
Local oSrv
Local lExist 	:= .F.
Local cNumPed	:= ""
Local nPosPed	:= 0
Local aPedSinc  := {}
Local nQtdERP   := 0
Local nQtdeEco  := 0        

nPosPed := aScan(aCabPed, {|x| AllTrim(x[01]) == "C5_NUM"})
cNumPed := aCabPed[nPosPed][02]

RpcClearEnv()
RpcSetType(3)
RpcSetEnv(AllTrim(Transform(cEmp, "@! 99")), AllTrim(Transform(cFil, "@! 99" )),,,,GetEnvServer(),{ "SA1" })	

lMsErroAuto := .F.
                
MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItemPed,3)

Sleep(1000)

cPedSinc := ""
aPedSinc := AvalLicit(aCabPed)
cPedSinc := aPedSinc[01]
nQtdERP  := aPedSinc[02]
nQtdeEco := aPedSinc[03]

lSincr   := !Empty(cPedSinc)
                            
If lSincr
	
	if nQtdERP < nQtdeEco
		cErro := "PEDIDO INCLUIDO FALTANDO "+ AllTrim(Str(nQtdeEco - nQtdERP)) +" ITENS. NUMERO NO PROTHEUS: "+ cPedSinc
		GrvStatus(AllTrim(aPedidos[nX, 01]), -1, cErro)	
		EnviaErro(cErro, aCabPed, aItemPed, 2)
	Else
		GrvStatus(cIdPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cPedSinc))
		EnviaPedOk(cNumPed, aCabPed, aItemPed)			
	
		cHORA := TIME()
		If SuperGetMV("MV_LPAEECO",,.F.) .and. (cHORA >= MIN_HORA .and. cHORA <= MAX_HORA) 
			
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
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณLibera por Total de Pedido                                              ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If ( Len(aRegistros) > 0 )
					Begin Transaction       
						conout("3-LIBERANDO PEDIDO: "+cNumPed)
						SC6->(MaAvLibPed(SC5->C5_NUM,.T.,.F.,.F.,aRegistros,Nil,Nil,Nil,Nil))
					End Transaction
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณAtualiza o Flag do Pedido de Venda                                      ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				Begin Transaction
					SC6->(MaLiberOk({SC5->C5_NUM},.F.))
					conout("4-LIBERANDO PEDIDO: "+cNumPed)
				End Transaction
				conout("5-LIBERANDO PEDIDO: "+cNumPed)
				FMILBITENS(cNumPed)
			EndIf
		EndIf
	EndIf

Else

	GrvStatus(cIdPedido, -1, "ERRO NA EXECUCAO DO MSEXECAUTO")

	if !ExistDir("\EDINEO")
		MakeDir("\EDINEO")
	EndIf
	cErro := MostraErro("\EDINEO")
	
	GrvErro(cIdPedido, cErro)
	
	ConOut(cErro)
	cErro := StrTran(cErro, chr(13) + chr(10), '<br/>')	
	EnviaErro(cErro, aCabPed, aItemPed, 2)	                                  
	
EndIf

RpcClearEnv()

Return

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel por validar se o pedido jแ foi integradoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

*-----------------------------------*
Static Function AvalLicit(aCabPed)   
*-----------------------------------*

Local cRet := ""
Local cSql := ""

Local nQtdeEco := 0           // armazena quantidade de itens do pedido no eEco
Local nQtdERP  := 0           // armazena quantidade de itens do pedido no Protheus

Local nPosCot  := aScan(aCabPed, {|x| Alltrim(x[1]) == "C5_COTACAO"})
Local nPosFil  := aScan(aCabPed, {|x| AllTrim(x[1]) == "C5_FILIAL"})

cSql := "SELECT C5.C5_NUM FROM "+retSqlName("SC5")+" C5 "
cSql += "WHERE C5.C5_FILIAL  = '"+ aCabPed[nPosFil][2] +"' "
cSql += "  AND C5.C5_COTACAO = '"+ PadR(aCabPed[nPosCot][2], TamSX3("C5_COTACAO")[1]) +"' "
cSql += "  AND C5.C5_X_TPLIC  = '2' "
cSql += "  AND C5.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS "C5LIC"

DbSelectArea("C5LIC")
C5LIC->(DbGoTop())

if C5LIC->(EOF())
	
	C5LIC->(DbCloseArea())
	Return {"",0,0}            
	
Else
    
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณJEAN - 07/08/15 - INICIO - Ajuste para validar tamb้m item do pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
    
	cSql := "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM  EDI_MVPD ITENS "                                   
	cSql += " INNER JOIN EDI_CBPD PED "                                   	
	cSql += "    ON PED.CODICBPD = ITENS.CODICBPD "	
	cSql += " WHERE PED.PEDICBPD = '"+ AllTrim(aCabPed[nPosCot][2]) + "'"
	
	TCQUERY cSql NEW ALIAS "ITENSNEO"
	
	DbSelectArea("ITENSNEO")
	ITENSNEO->(DbGoTop())
	
	nQtdeEco := ITENSNEO->QUANT
	
	ITENSNEO->(DbCloseArea()) 
	
	cSql := "SELECT COUNT(*) AS QUANT "
	cSql += "  FROM "+ RetSqlName("SC6") +" C6 "
	cSql += " WHERE C6.C6_FILIAL = '"+ xFilial("SC6") +"' "
	cSql += "   AND C6.C6_NUM = '"+ C5LIC->C5_NUM  +"' "
	cSql += "   AND C6.D_E_L_E_T_ = ' ' "
	
	TCQUERY cSql NEW ALIAS "ITENSERP"
	
	DbSelectArea("ITENSERP")
	ITENSERP->(DbGoTop())
	
	nQtdERP := ITENSERP->QUANT
	
	ITENSERP->(DbCloseArea())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณJEAN - 07/08/15 - INICIO - Ajuste para validar tamb้m item do pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ	

	cRet := C5LIC->C5_NUM
	C5LIC->(DbCloseArea())
	
EndIf               

Return {cRet, nQtdERP, nQtdeEco}                                                         
                          


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณFun็ใo responsแvel pela altera็ใo do status inicial dos pedidos que serใo processadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

Static Function AltStatus(aPedidos)
Local cSql := " "
Local n   := 0

For n := 1 to len(aPedidos)
	GrvStatus(AllTrim(aPedidos[n, 01]), 1, "INICIANDO INTEGRACAO")
Next n

Return 


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de status do processamento na tabela intermediแriaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function GrvStatus(cPedido, nStatus, cMsg)
Local cSql := " "

ConOut("IMPPEDNEOGRID - PEDIDO: "+ cPedido +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
			 iif(nStatus == -1, "ERRO DE INTEGRACAO", iif(nStatus == 1, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "UPDATE  EDI_CBPD SET STATCBPD = "+ AllTrim(Str(nStatus,0)) +", MSERCBPD = '"+ AllTrim(cMsg) +"' WHERE PEDICBPD = '"+ cPedido +"'"
TcSqlExec(cSql)

Return                    


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de erro na tabela intermediแria                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Static Function GrvErro(cPedido, cMsgErro)
Local cSql := " "

ConOut("IMPPEDNEOGRID - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubSTR(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)

cSql := "UPDATE EDI_CBPD SET STATCBPD SET MSERCBPD = '"+cMsgErro+"' WHERE PEDICBPD = "+ cPedido + "'"
TcSqlExec(cSql)

Return 
       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo utilizada para avaliar Threads em execu็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
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
											( aThread[5] == "U_JOBNEOINT" );
											.and.;
											( aThread[6] == cEnvServer ),;
											++nThreads,;
											NIL )})

lFreeThreads	:= ( nThreads == 0 )

Return( lFreeThreads )


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTEECOINT บAutor  ณJean C. P. Saggin  บ Data ณ  22/10/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina desenvolvida com a finalidade de reimportar/excluir บฑฑ
ฑฑบ          ณ pedidos com problema de integra็ใo.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
*------------------------------*
User Function ALTEECOINT()
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
Private aCboFiltro := {"1=Erro de integra็ใo","2=Nใo integrado","3=Em processo de integra็ใo","4=Integrado com sucesso","5=Pedido bloqueado","6=Aguardando autoriza็ใo","7=Autoriza็ใo recusada","8=Todos os pedidos"}
Private aCampos    := {}
Private aCpos      := {}
Private cTrab 
Private cIndic
Private oMark
Private cPerg      := "ALTPEDEECO"      
Private lInverte   := .F. 
Private cMarca     := GetMark()
Private aCores     := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณChama fun็ใo para manuten็ใo do grupo de perguntas da rotinaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	
	CriaSx1(cPerg)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz a pergunta apenas para gravar o conte๚do default nos parโmetrosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If !Pergunte(cPerg, .T.)

		Return
	EndIf
	
	MV_PAR01 := Date()                 // Emissใo De
	MV_PAR02 := Date()                 // Emissao At้
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
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณCampos da tabela temporแriaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aAdd(aCampos, {"MARK"    , "", " "          , "@!"})
	aAdd(aCampos, {"EMPRESA" , "", "Empresa"    , "@!"})
	aAdd(aCampos, {"FILIAL"  , "", "Filial"     , "@!"})
	aAdd(aCampos, {"IDPEDIDO", "", "Id. Pedido" , "@!"})
	aAdd(aCampos, {"VENDEDOR", "", "Vendedor"   , "@!"})
	aAdd(aCampos, {"CLIENTE" , "", "Cliente"    , "@!"})
	aAdd(aCampos, {"LOJA"    , "", "Loja"       , "@!"})
	aAdd(aCampos, {"RAZAO"   , "", "Razใo Soc." , "@!"})
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

    @ 010, 160 BUTTON oBtnPesq  PROMPT "&Parโmetros"        SIZE 060, 013 OF oDlgeEco ACTION FindOrder() 		PIXEL
    @ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	SIZE 060, 013 OF oDlgeEco ACTION CarregaDados()		PIXEL
    @ 220, 055 BUTTON oBtnPesq  PROMPT "&Legenda"   	 			SIZE 060, 013 OF oDlgeEco ACTION fLegenda() 		PIXEL
    @ 220, 120 BUTTON oBtnVis   PROMPT "&Visualizar Pedido" SIZE 060, 013 OF oDlgeEco ACTION Visualiza() 		PIXEL
    @ 220, 185 BUTTON oBtnErros PROMPT "Erros &Integra็ใo"  SIZE 060, 013 OF oDlgeEco ACTION ErrosInt() 		PIXEL
    @ 220, 250 BUTTON oBtnExc   PROMPT "&Excluir Pedido"    SIZE 060, 013 OF oDlgeEco ACTION ExcPed() 			PIXEL
    @ 220, 315 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	  SIZE 060, 013 OF oDlgeEco ACTION ReprocPed()		PIXEL
    @ 220, 380 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 060, 013 OF oDlgeEco ACTION fCloseDlg()		PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณFaz carga inicial dos dados com base nos parโmetros defaultsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlgeEco CENTERED                                                                  

Return          

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfCloseDlg    บAutor  ณJean C. Saggin  บ  Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Encerra janela principal.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
/*
*-------------------------------------*
Static Function fCloseDlg()
*-------------------------------------*
	PED_EECO->(DbCloseArea())
	Close(oDlgeEco)

Return
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCarregaDados บAutor  ณJean C. Saggin  บ  Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por carregar os dados no grid.          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
/*
*-------------------------------------*
Static Function CarregaDados(nExec,lEnd)
*-------------------------------------*

Local cSql := ""
Local cEol := CHR(13)+CHR(10)          

Default nExec := 2

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz a limpeza dos dados do arquivo temporแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Pergunte(cPerg, .F.)

DbSelectArea("PED_EECO")
PED_EECO->(DbGoTop())
Do While !PED_EECO->(Eof())
    RecLock("PED_EECO",.F.)
    DbDelete()
    MsUnlock() 
   PED_EECO->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "0"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
cSql += "from eeco.eeco_pedido@INTEGRA pedido "                                                 +cEol
cSql += "where to_char(pedido.dtpedido,'yyyymmdd') between '"+ DtoS(mv_par01) +"' and '"+ DtoS(mv_par02) +"' "  +cEol
cSql += "  and SubStr(pedido.cliente,01,09)        between '"+ mv_par03       +"' and '"+ mv_par04       +"' "  +cEol
cSql += "  and SubStr(pedido.loja,01,04)           between '"+ mv_par05       +"' and '"+ mv_par06       +"' "  +cEol
cSql += "  and SubStr(pedido.vendedorerp,01,06)    between '"+ mv_par07       +"' and '"+ mv_par08       +"' "  +cEol

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se deve mostrar apenas os pedidos da Emp/Filial que o usuแrio estแ posicionado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If mv_par09 == 1
	cSql += "  and Trim(pedido.empresa) = '"+ cEmpAnt +"' "                             +cEol
	cSql += "  and Trim(pedido.filial) = '"+ cFilAnt +"' "                              +cEol
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida็ใo de status conforme sele็ใo do usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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

//If Aviso("sql", cSql, {"Continuar?","Parar?"}, 3) == 2
//	Return
//EndIf

TCQUERY cSql NEW ALIAS "pedido"

DbSelectArea("pedido")
pedido->(DbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno da busca for vaziaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
	PED_EECO->RAZAO    := Space(30) 
	PED_EECO->DTPEDIDO := StoD(pedido->dtpedido)
	PED_EECO->VALOR    := pedido->valortotal
	PED_EECO->STATUS   := pedido->status
	PED_EECO->ERRO     := pedido->msgproc
	PED_EECO->(MsUnlock())

	pedido->(DbSkip())
EndDo

pedido->(DbCloseArea()) 

PED_EECO->(DbGoTop())

if !PED_EECO->(EOF())
	while !PED_EECO->(EOF())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPreenche razใo social do cliente com base nas informa็๕es contidas no banco de produ็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		RecLock("PED_EECO", .F.)
			PED_EECO->RAZAO := SubStr(Posicione("SA1", 1, xFilial("SA1") + PED_EECO->CLIENTE + PED_EECO->LOJA, "A1_NOME"), 01, 30)
		PED_EECO->(MsUnlock())
		
		PED_EECO->(DbSkip())
		
	EndDo
	
	PED_EECO->(DbGoTop())
	
EndIf

ObjectMethod(oMark:oBrowse,"Refresh()")
oDlgeEco:Refresh()

Return .T.

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfLegenda  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para legenda.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function fLegenda()

Local cTitulo := OemtoAnsi("Legenda")

Local aCores	:= {	{ 'BR_VERMELHO'	, "Erro de integra็ใo" 		 		},;
										{ 'BR_BRANCO'   , "Nใo integrado"							},;
										{ 'BR_AMARELO'	, "Em processo de integra็ใo"	},;
										{ 'BR_VERDE'		, "Integrado com sucesso"  		},;
										{ 'BR_CINZA'		, "Bloqueado"   							},;
										{ 'BR_LARANJA'	, "Aguardando autoriza็ใo"		},;
										{ 'BR_PRETO'		, "Autoriza็ใo recusada"  		}}											
												
	BrwLegenda(cTitulo, "Legenda", aCores)


Return          
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณReprocPed บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada pelo botใo de reprocessamento.              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
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
				Aviso("Aviso","Somente podem ser reprocessados pedidos com os status (Erro de integra็ใo/Nใo integrado/Em processo de integra็ใo ).",{"OK"})
				Exit
			EndIf
		EndIf
	   PED_EECO->(DbSkip())
	Enddo
	PED_EECO->(dbGoTo(nRECPED))
	
	If Len(aPEDIDO) == 0
		Aviso("Aviso","Nenhum pedido valido foi selecionado para reimporta็ใo.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a reimporta็ใo do(s) pedido(s) selecionado(s)?",{"Sim","Nใo"}) != 1
			Return
		EndIf
	EndIf
	
	RptStatus({|lEnd| fProcRep(aPEDIDO,lEnd)}, "Aguarde...","Reimportando o(s) pedido(s) selecionado(s)...", .T.)
	
	CarregaDados()

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfProcRep  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para inclusใo de pedidos.                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     
/*
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
		cSql := "update eeco.eeco_pedido@INTEGRA set status = 0 where idpedido = "+ cValToChar(aPedido[nI][03][nJ])
		TcSqlExec(cSql)
		nCnt++
	Next nJ	
	Sleep(1000)
Next nI

Aviso("Pedidos reprocessando...", "Foram marcados "+cValToChar(nCnt)+" pedidos para serem reprocessados.", {"Ok"}, 2 )

Return          
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFindOrder บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada pelo botใo de busca de pedidos.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function FindOrder()

if (Pergunte(cPerg, .T.))
	CarregaDados()
EndIf

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณVisualiza บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para visualizar o pedido de vendas antes    บฑฑ
ฑฑบ          ณ da importa็ใo para o Protheus.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
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

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem dos campos de cabecalho                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

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
		Aviso("Aviso","Nenhum pedido foi selecionado para visualiza็ใo.",{"OK"})
		Return 
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem dos campos de itens                                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	Aadd(aHeadITE,{"Produto", 	   		"ITE_CODPRD", "",	 				15,							0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Descri็ใo", 	   	"ITE_DESPRD", "",	 				TAMSX3("B1_DESC")[1], 		0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Quantidade",   		"ITE_QTDADE", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Pre็o Venda",	   	"ITE_PRCVEN", "@E 999,999,999.99",	TAMSX3("C6_PRCVEN")[1],		TAMSX3("C6_PRCVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Valor Total",	   	"ITE_VLRTOT", "@E 999,999,999.99",	TAMSX3("C6_VALOR")[1],		TAMSX3("C6_VALOR")[2], 		, ,"N",, }) 
	Aadd(aHeadITE,{"Desc. Unit.",  		"ITE_DESUNI", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Desc. Total",  		"ITE_DESTOT", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Valor ST",  		"ITE_SUBTRI", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
	Aadd(aHeadITE,{"Promo็ใo", 	   		"ITE_PROMOC", "",	 				1,							0,							, ,"C",, }) 
	Aadd(aHeadITE,{"Bonificado",	   	"ITE_BONIFI", "",	 				1,							0,							, ,"C",, }) 

	DEFINE MSDIALOG oDlgeEco TITLE "Visualiza็ใo do pedido "+cValToChar(CAB_IDPEDIDO) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL

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
	@ 025,190 SAY		oCPOTIT PROMPT "Razใo Social"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 025,225 MSGET 	oCPODAT VAR CAB_RAZAO	 			SIZE 150, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	@ 040,010 SAY		oCPOTIT PROMPT "Vendedor" 		SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,045 MSGET 	oCPODAT VAR CAB_VENDEDOR 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,100 SAY		oCPOTIT PROMPT "Data Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,135 MSGET 	oCPODAT VAR CAB_DTPEDIDO 		SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,190 SAY		oCPOTIT PROMPT "Valor Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 040,225 MSGET 	oCPODAT VAR CAB_VALOR	 			SIZE 040, 007 PICTURE "@E 999,999.99" OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	@ 055,010 SAY		oCPOTIT PROMPT "Status Pedido"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,045 MSGET 	oCPODAT VAR CAB_STATUS	 			SIZE 040, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,100 SAY		oCPOTIT PROMPT "Msg Integra็ใo"	SIZE 035, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	@ 055,135 MSGET 	oCPODAT VAR CAB_ERRO	 				SIZE 240, 007 OF oDlgeEco COLORS 0, 16777215 PIXEL
	
	oItensPV := MsNewGetDados():New( 080, 5, 205, 440, 3, "AllwaysTrue()", "AllwaysTrue()", , , 000, 999,, "", .T., oDlgeEco, aHeadITE ,aColsITE )

	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 056, 013 OF oDlgeEco ACTION Close(oDlgeEco) PIXEL
	
	RptStatus({|lEnd| LoadItens(CAB_IDPEDIDO,lEnd)}, "Aguarde...","Atualizando itens do pedido no Grid...", .T.)
	
	ACTIVATE MSDIALOG oDlgeEco CENTERED
	

Return                          
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณLoadItens บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Popula array dos itens.                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function LoadItens(cIdPedido,lEND)

Local nY := 0

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
	cSql += "from eeco.eeco_itens@INTEGRA itens "                                     
	cSql += "where idpedido = "+ cValToChar(cIdPedido)
	
	TCQUERY cSql NEW ALIAS "itens"
	
	dbSelectArea("itens")
	itens->(dbGoTop())
	If (itens->(!Eof()))	
		While (itens->(!Eof()))	
			
			aAdd(oItensPV:aCols, Array(Len(oItensPV:aHeader)+1))
			oItensPV:aCols[Len(oItensPV:aCols),01] := itens->codigo
			oItensPV:aCols[Len(oItensPV:aCols),02] := Space(TamSX3("B1_DESC")[01]) 
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
	
	If Len(oItensPV:aCols) > 0 .and. ValType(oItensPV:aCols[01, 01]) == "C"
		
		For nY := 1 to Len(oItensPV:aCols)
			oItensPV:aCols[nY, 02] := Posicione("SB1", 1, xFilial("SB1") + oItensPV:aCols[nY, 01], "B1_DESC")
		Next nY

	EndIf
	
	oItensPV:Refresh()
	oDlgeEco:Refresh()
	
Return                       

*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณExcPed    บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para fazer a exclusใo do pedido da tabela   บฑฑ
ฑฑบ          ณ de integra็ใo.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
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
		Aviso("Aviso","Nenhum pedido foi selecionado para exclusใo.",{"OK"})
		Return
	Else
		If Aviso("Aviso","Confirmar a exclusใo do(s) pedido(s) selecionado(s)?",{"Sim","Nใo"}) != 1
			Return
		EndIf
	EndIf
	
	RptStatus({|lEnd| fProcExc(aDELETE,lEnd)}, "Aguarde...","Excluindo pedido(s) selecionado(s)...", .T.)
	
Return                       

*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณfProcExc  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para fazer a exclusใo do pedido da tabela   บฑฑ
ฑฑบ          ณ de integra็ใo.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
Static Function fProcExc(aDELETE,lEnd)
	                                           
	Begin Transaction
		For nI := 1 to Len(aDELETE)
			cSql := "delete from eeco.eeco_itens@INTEGRA where idpedido = "+ cValToChar(aDELETE[nI])
			TCSQLExec(cSql)
			cSql := "delete from eeco.eeco_pedido@INTEGRA where idpedido = "+ cValToChar(aDELETE[nI])
			TCSQLExec(cSql)
		Next nI       
	End Transaction
	
	//--Recarrega os pedidos no grid principal.
	CarregaDados()

Return
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณErrosInt  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para mostrar detalhadamente os erros de     บฑฑ
ฑฑบ          ณ integra็ใo.                                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
		Aviso("Aviso","Nenhum pedido foi selecionado para visualiza็ใo de erros.",{"OK"})
		Return
	EndIf

	cSql := "select trim(mostraerro) mostraerro from eeco.eeco_pedido@INTEGRA where idpedido = "+ cValToChar(cIdPedido)
	
	TCQUERY cSql NEW ALIAS "erroped"
	
	dbSelectArea("erroped")
	erroped->(dbGoTop())
	If !erroped->(EOF())
		cErroPedido := STRTRAN(erroped->mostraerro,"*",chr(10)+chr(13))			 
	EndIf
	erroped->(dbCloseArea())
	
	If Empty(cErroPedido)
		Aviso("Aviso","Nใo existem dados para visualiza็ใo.",{"OK"})
		Return
	EndIf
		
	DEFINE MSDIALOG oDlgeEco TITLE "Erros de integra็ใo do pedido "+cValToChar(cIdPedido) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErroPedido MEMO SIZE 420,200 OF oDlgeEco PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlgeEco ACTION Close(oDlgeEco) PIXEL
	
	ACTIVATE MSDIALOG oDlgeEco CENTERED


Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณCriaSX1   บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de manuten็ใo do grupo de perguntas                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
/*
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
*/

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFGETPORT  บAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a porta de execucao do protheus server.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGETPORT()
Return(GetPvProfString( "TCP", "port", "20007", GetAdv97()))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFMILBITENSบAutor  ณJean Carlos Saggin  บ Data ณ  19/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Liberacao de credito/estoque do pedido.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ALTPEDEECO                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
			Obs- Nใo serแ chamada fun็ใo padrใo (a450Grava), pois caso o produto possua lote nใo realiza a libera็ใo com saldo inferior. 
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