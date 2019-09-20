#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"
                               
#DEFINE CIPSERVER 	"192.168.205.30"          // IP do servi็o Protheus responsแvel pela importa็ใo dos pedidos
#DEFINE MAX_PED  	30                  	  // Tamanho mแximo da fila para importa็ใo de pedidos       
#DEFINE MAX_HORA  	"23:59:59"               // Ponto de corte inicial para libera็ใo automแtica de pedidos
#DEFINE MIN_HORA  	"00:00:01"               // Ponto de corte final para libera็ใo automแtica de pedidos
#DEFINE LCORTA		.F.                  	// Indica se os itens sem saldo no controle de lotes deverใo ser cortados.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPPEDORA บAutor  ณGustavo Lattmann   บ Data ณ  27/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo para importa็ใo dos pedidos do CRM Oracle		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

*--------------------------*
User Function IMPPEDORA()    
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
ConOut("IMPPEDORA - INICIANDO IMPORTACAO DE PEDIDOS") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera empresa/filial do APPSERVER.INIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2) 
cCODFIL := SubSTR(cEMPFIL,4,2)

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
	ConOut("IMPPEDORA - EXECUTANDO PARA EMPRESA "+cEmpIni) 
Else
	ConOut("IMPPEDORA - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN") 
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
While !LockByName(iif(!Empty(cCODEMP),"IMPPEDORA"+cCODEMP,"IMPPEDORA"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois jแ esta sendo executada!")
		Return
	EndIf		
EndDo

ConOut("IMPPEDORA - CONECTANDO NO BANCO INTERMEDIมRIO...")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTฟ
//ณBusca quais empresas tem pedido para importar e ordena pela que tem maisณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤTู
cSql := "SELECT DISTINCT ROWID, EMPRCBPD, FILICBPD, COUNT(*) AS QUANT FROM ORACLEFUSION.CRM_CBPD PED "
cSql += " WHERE PED.STATCBPD = 0"                                                
cSql += "   AND PED.EMPRCBPD <> ' ' "
cSql += "   AND PED.FILICBPD <> ' ' "
cSql += "   AND TRIM(PED.EMPRCBPD) IN ('01','02','06','07','09','10','40') "  
cSql += " GROUP BY ROWID, EMPRCBPD, FILICBPD "
cSql += " ORDER BY QUANT DESC "

TcQuery cSql New Alias "EMPFIL"

DbSelectArea("EMPFIL")

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno nใo ้ vazioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If EMPFIL->(Eof())
	EMPFIL->(DbCloseArea())	
	ConOut("IMPPEDORA - SEM PEDIDOS A IMPORTAR") 
	Return  
EndIf

While EMPFIL->(!Eof())
	nTmpQtd := 0
	If nQtdPed >= MAX_PED
		Exit               
	Else
		If (nQtdPed + EMPFIL->QUANT) > MAX_PED
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

For nEmp := 1 To Len(aEmpFil)           

	If AllTrim(aEmpFil[nEmp,01]) != cEmpAnt .or. AllTrim(aEmpFil[nEmp,02]) != cFilAnt
		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv(AllTrim(Transform(aEmpFil[nEmp,01], "@! 99")), AllTrim(Transform(aEmpFil[nEmp,02], "@! 99" )),,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })	
	EndIf
		
	ConOut("IMPPEDORA - BUSCANDO PEDIDOS DA EMPRESA "+Trim(aEmpFil[nEmp,01])+" FILIAL "+Trim(aEmpFil[nEmp,02]))
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "0"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cSql := "SELECT ROWID, "                     						               +cEol
	cSql += "		CAST(PEDIDO.CODICBPD AS VARCHAR(9)) AS IDPEDIDO, " 	               +cEol
	cSql += "       PEDIDO.STATCBPD, "                                                 +cEol
	cSql += "       PEDIDO.EMISCBPD AS DTPEDIDO, "						               +cEol
	cSql += "       PEDIDO.SEGECBPD AS SEGMENTO, " 				                       +cEol
	cSql += "       CAST(PEDIDO.MSG_CBPD AS VARCHAR(3000)) AS OBS, "                   +cEol
	cSql += "       TRIM(PEDIDO.EMPRCBPD) AS EMPRESA, "	                               +cEol
	cSql += "       TRIM(PEDIDO.FILICBPD) AS FILIAL, "                                 +cEol
	cSql += "       PEDIDO.TABECBPD AS TABELA, " 				                       +cEol
	cSql += "       PEDIDO.CONDCBPD AS FORMAPAGAMENTO, " 					           +cEol
	cSql += "       PEDIDO.VENDCBPD AS VENDEDORERP, "				                   +cEol
	cSql += "       PEDIDO.CLIECBPD AS CLIENTE, " 				                       +cEol
	cSql += "       PEDIDO.LOJACBPD AS LOJA, "				                           +cEol
	cSql += "       PEDIDO.TIPOCBPD AS OPER, "				                           +cEol	
	cSql += "       PEDIDO.TPCLCBPD AS TIPOCLI, "			                           +cEol		
	cSql += "       PEDIDO.ORDECBPD AS ORDEM "				                           +cEol
	cSql += " FROM ORACLEFUSION.CRM_CBPD PEDIDO "                  					   +cEol
	cSql += "WHERE PEDIDO.EMPRCBPD = '"+ AllTrim(aEmpFil[nEmp, 01]) +"' "              +cEol
	cSql += "  AND PEDIDO.FILICBPD = '"+ AllTrim(aEmpFil[nEmp, 02]) +"' "              +cEol
	cSql += "  AND PEDIDO.STATCBPD = 0 "                                               +cEol
	cSql += "  AND PEDIDO.OBS_CBPD <> 'CUPOM' "                                        +cEol	
	cSql += "  AND ROWNUM <= "+ AllTrim(Str(aEmpFil[nEmp, 03]))                        +cEol
	cSql += "ORDER BY PEDIDO.CODICBPD"
	
	TCQUERY Upper(cSql) NEW ALIAS "PEDIDO"
	
	DbSelectArea("PEDIDO")
	PEDIDO->(DbGoTop())
	
	aPedidos := {}
	
	while !PEDIDO->(eof()) 
		aAdd(aPedidos, {PEDIDO->IDPEDIDO,;                         //1
										PEDIDO->STATCBPD,;         //2
										PEDIDO->DTPEDIDO,;         //3
										PEDIDO->SEGMENTO,;         //4
										PEDIDO->OBS,;              //5
										Trim(PEDIDO->EMPRESA),;    //6
										Trim(PEDIDO->FILIAL),;     //7
										PEDIDO->TABELA,;           //8
										PEDIDO->FORMAPAGAMENTO,;   //9
										PEDIDO->VENDEDORERP,;      //10
										PEDIDO->CLIENTE,;          //11
										PEDIDO->LOJA,;             //12
										PEDIDO->OPER,;             //13
										PEDIDO->TIPOCLI,;          //14
										PEDIDO->ORDEM})            //15

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

ConOut("IMPPEDORA - FIM DA EXECUCAO")

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
Private lConsFin := .F.
  
	lAguarda := .F.
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณChamada da fun็ใo para fazer o ajuste do status dos pedidos em processamentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	AltStatus(aPedidos)     	   
	
	For nX := 1 to len(aPedidos)   
	    
		cFilNew := aPedidos[nX, 07]  
		lConsFin := Iif(aPedidos[nX, 14] == "F",.T.,.F.)     
		
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))
		
		//-- Valida se o pedido deste vendedor deve cair em outra filial (PROJETO VASO STR)  
		//-- Gustavo 17/05/17 - Se for pessoa juridica e pedido de vinho, deve avaliar em qual filial o pedido entrarแ
	/*	If (aPedidos[nX, 04] == "001001001") .or. (Substr(aPedidos[nX, 04],1,3) == "003" .and. (SA1->A1_PESSOA == "J"))
			dbSelectArea("SA3")
			SA3->(dbSetOrder(1))
			SA3->(dbGoTop())
			SA3->(dbSeek(xFilial("SA3") + aPedidos[nX, 10]))
			If SA3->A3_X_LWEB .and. !Empty(SA3->A3_GRUPO)             
				cEmpNew := Substr(SA3->A3_GRUPO,1,2)
				cFilNew	:= Substr(SA3->A3_GRUPO,3,2)
			
				If !(cEmpAnt == cEmpNew .and. cFilAnt == cFilNew)
					Conout("IMPPEDORA - MUDANDO A FILIAL DO PEDIDO")
					//-- Posiona na nova empresa e filial
					RpcClearEnv()
					RpcSetType(3)
					RpcSetEnv(cEmpNew, cFilNew,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })
					
					AtuFilial(aPedidos[nX])
	            EndIf
			EndIf			
		    SA3->(dbCloseArea())
		Endif 
		*/
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณValida se jแ existe algum pedido cadastrado no sistema com o mesmo c๓digo de Licita็ใo.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		aTemp  := {}
		//aAdd(aTemp, {"C5_FILIAL"  ,aPedidos[nX, 07], Nil})
		aAdd(aTemp, {"C5_FILIAL"  ,cFilNew, Nil})		
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
				
		ConOut("IMPPEDORA - ID PEDIDO " + aPedidos[nX, 01])

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณMontagem do cabe็alho do pedido.ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		aAdd(aCabPed, {"C5_FILIAL",  cFilNew,Nil})
		aAdd(aCabPed, {"C5_TIPO",    "N", Nil})		
		aAdd(aCabPed, {"C5_COTACAO", aPedidos[nX, 01],Nil})
		aAdd(aCabPed, {"C5_CLIENTE", aPedidos[nX, 11],Nil})		
		aAdd(aCabPed, {"C5_LOJACLI", aPedidos[nX, 12],Nil})
		aAdd(aCabPed, {"C5_CLIENT" , aPedidos[nX, 11],Nil})
		aAdd(aCabPed, {"C5_LOJAENT", aPedidos[nX, 12],Nil})
        
    	cOper    := aPedidos[nX, 13]
  
		//-- Gustavo - Aberta tabela pra cima
		//dbSelectArea("SA1")
		//SA1->(dbSetOrder(01))

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAvalia bloqueio do clienteณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))
			If SA1->A1_MSBLQL == '1'
				cErro := "CLIENTE "+ aPedidos[nX, 11] +"/"+ aPedidos[nX, 12] +" - "+ SubStr(SA1->A1_NOME, 01, 30) +" ESTA BLOQUEADO."                    
				GrvStatus(aPedidos[nX, 01], -1, cErro)
				EnviaErro(cErro, {}, {}, 1)
				Loop
			EndIf
		Else
			cErro := "CLIENTE "+ aPedidos[nX, 11] +" LOJA "+ aPedidos[nX, 12] +" NรO ENCONTRADO"                    
			GrvStatus(aPedidos[nX, 01], -1, cErro)
			EnviaErro(cErro, {}, {}, 1)
			Loop  		
		EndIf	    
		
		//-- Alterado caso seja bonifi็ใo trazer a condi็ใo 350		
		cCondPag := Iif(cOper == "04", "350", aPedidos[nX, 09])     
		
		//-- Bonifica็ใo consumidor final empresa 10 deve puxar Opera็ใo 05
		If cOper == "04" .and. (cEmpAnt == "10" .or. (cEmpAnt == "02" .and. cFilAnt == "03")) .and. lConsFin
			cOper := "05"		
		Endif 
			
		aAdd(aCabPed, {"C5_TIPOCLI",aPedidos[nX, 14],Nil})
		aAdd(aCabPed, {"C5_TABELA" ,aPedidos[nX, 08],Nil})
  		aAdd(aCabPed, {"C5_CONDPAG",cCondPag,Nil}) 
//		aAdd(aCabPed, {"C5_CONDPAG",aPedidos[nX, 09],Nil})
  		aAdd(aCabPed, {"C5_VEND1"  ,aPedidos[nX, 10],Nil})
	  	aAdd(aCabPed, {"C5_PEDCLI" ," ",Nil})
	  	aAdd(aCabPed, {"C5_MENNOTA",iif(Empty(aPedidos[nX, 05]), " ", aPedidos[nX, 05]),Nil})
	  	aAdd(aCabPed, {"C5_EMISSAO",StoD(aPedidos[nX, 03]),Nil})
	  	aAdd(aCabPed, {"C5_DTHRALT",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil}) 
 		aAdd(aCabPed, {"C5_X_DTINC",DToS(dDataBase) + ' ' + Substr(Time(), 1, 5),Nil})
  		aAdd(aCabPed, {"C5_X_ORDEM",Substr(aPedidos[nX, 15],1,40),Nil})
  	
	  	cNumPed := GetSxeNum("SC5","C5_NUM")
  	
  		aAdd(aCabPed, {"C5_NUM"    ,cNumPed,Nil})
  		aAdd(aCabPed, {"C5_X_TPLIC","1",Nil})
   		aAdd(aCabPed, {"C5_X_CLVL" ,aPedidos[nX, 04],Nil})		
		
		lSemItens := .F.
  		ConfirmSX8()
  	  	
   		aItemPed := BuscaItens(aPedidos[nX, 01], cNumPed, @lSemItens)
		
	  	If lSemItens                                       
			cErro := "PEDIDO SEM PRODUTOS"
			GrvStatus(aPedidos[nX, 01], -1, cErro)
			EnviaErro(cErro, aCabPed, aItemPed, 1)                                     
			Loop
		Else 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณChamada de uma nova thread para a inclusใo do pedidoณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			StartJob("U_JOBORAINT", GetEnvServer(), lAguarda, cEmpAnt, cFilAnt, aClone(aCabPed), aClone(aItemPed), lSemItens, cNumPed, aPedidos[nX, 01], cIP, cPort)
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
Static Function BuscaItens(cPedido, cNumPed, lSemItens)     
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
//Local cTpCli 		:= ""
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

cSql := "SELECT DISTINCT (ITENS.PRODMVPD) AS CODIGO, " 				            +cEol
cSql += "       ITENS.QUANMVPD AS QUANTIDADE, "                                 +cEol
cSql += "       ITENS.PRUNMVPD AS PRECOVENDA, " 			                    +cEol
cSql += "       ITENS.TOTAMVPD AS TOTALVENDA, " 			                    +cEol
cSql += "       ITENS.TABEMVPD, "			 	 			                    +cEol
cSql += "       ITENS.CODICBPD "                                                +cEol
cSql += "FROM  ORACLEFUSION.CRM_MVPD ITENS "                           			+cEol 
cSql += "INNER JOIN ORACLEFUSION.CRM_CBPD CAB"					 				+cEol
cSql += " ON CAB.CODICBPD = ITENS.CODICBPD"								 		+cEol
cSql += "WHERE CAB.CODICBPD = "+ cPedido 

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
//cTpCli := Posicione("SA1", 01, xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12], "A1_TIPO")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

While (ITENS->(!Eof()))	    
    
	If Empty(AllTrim(ITENS->CODIGO))
		ConOut("IMPPEDORA - CODIGO DO PRODUTO INFORMADO NAO ENCONTRADO PARA PEDIDO " + aPedidos[nX, 01])

		lSemItens := .T. 
		ITENS->(dbCloseArea())
		Return aItem
	EndIf	
	
	//-- Gustavo 23/02/17 - Calcular 10% de IPI quando consumidor final do vinho
	/*
	If cEmpAnt == "10" .and. lConsFin .and. aPedidos[nX, 04] == "003001001"
		nValor := Round(ITENS->TOTALVENDA * 1.1, 2)
		nPrcVen := Round(nValor / ITENS->QUANTIDADE, 5)   
		
	Else
		nPrcVen := Round(ITENS->TOTALVENDA / ITENS->QUANTIDADE,5)
		nValor := ITENS->TOTALVENDA
	EndIf
	*/  
	nPrcVen := Round(ITENS->TOTALVENDA / ITENS->QUANTIDADE,TamSX3("C6_PRCVEN")[2])
	nValor := ITENS->TOTALVENDA
	//-- Gustavo 23/02/17 - FIM

	
	lMudaTES  := .F.
	cItemNovo := Soma1(cItemNovo)
	aAdd(aItemLinha, {"C6_NUM"        ,cNumPed,Nil})
	aAdd(aItemLinha, {"C6_ITEM"       ,cItemNovo,Nil})  
	aAdd(aItemLinha, {"C6_PRODUTO"    ,AllTrim(ITENS->CODIGO),Nil})
	aAdd(aItemLinha, {"C6_QTDVEN"	  ,ITENS->QUANTIDADE,Nil})
	aAdd(aItemLinha, {"C6_PRCVEN"	  ,nPrcVen,Nil})  
						

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

	DbSelectArea("SB1")
	SB1->(dbSetOrder(01))
	SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->CODIGO)))    

	aAdd(aItemLinha, {"C6_DESCRI",SB1->B1_DESC,Nil})
	aAdd(aItemLinha, {"C6_PRCTAB",Round(ITENS->TABEMVPD,TamSX3("C6_PRCTAB")[2]),Nil})
	aAdd(aItemLinha, {"C6_VALOR" ,nValor,Nil})
	aAdd(aItemLinha, {"C6_LOCAL" ,SBZ->BZ_LOCPAD,Nil})
	aAdd(aItemLinha, {"C6_OPER"	 ,cOper,Nil})
	aAdd(aItemLinha, {"C6_QTDEMP",0,Nil})   
	//-- Gustavo 09/03/17 - Clientes que deve sair em quilos na nota
	If ALLTRIM(SA1->A1_XIDIOMA) == "S" .and. SB1->B1_UM $ "SC/CX"              
		aAdd(aItemLinha, {"C6_IMPUNI"	  ,"2",Nil})  		
	EndIf
	//-- Gustavo 09/03/17 FIM

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se ้ para o pedido entrar liberado no sistema ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lLibPed .And. (aPedidos[nX, 04] != '003001001')
		aAdd(aItemLinha, {"C6_QTDLIB",ITENS->QUANTIDADE,Nil})
	Else
		aAdd(aItemLinha, {"C6_QTDLIB",0,Nil})	
	EndIf

	aAdd(aItemLinha, {"C6_X_VLORI",Round(ITENS->QUANTIDADE * ITENS->PRECOVENDA,TamSX3("C6_X_VLORI")[2]),Nil})
  
	aAdd(aItem, aItemLinha)
	ConOut("ITEM: "    +AllTrim(ITENS->CODIGO)+;
				 " DESC: "   +SubStr(SB1->B1_DESC, 01, 20)+;
				 " QUANT: "  +Transform(ITENS->QUANTIDADE,"@E 9,999,999.999")+;
		 		 " VL UN: "  +Transform(ITENS->PRECOVENDA,"@E 9,999,999.99")+;
		 		 " VL TOT: " +Transform((ITENS->QUANTIDADE * ITENS->PRECOVENDA),"@E 9,999,999.99")+;
		 		 " OPER: "   +cOper)

	aItemLinha := {}                                                                     
	
	ITENS->(dbskip())
	
EndDo

ITENS->(dbCloseArea())
  
Return aItem


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
Local cMailCC := SuperGetMV("MV_X_S3GER", , "sfa@cantu.com.br")

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
  
	nValTot  := 0 //aPedidos[nX, 9]
	cCotacao := aPedidos[nX, 01]
EndIf

cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido Com Erro Oracle"))
oProcess:NewTask(cStatus,"\workflow\wfpedcomerro.htm")
oProcess:cSubject := OemToAnsi("Pedido cliente "+ AllTrim(cNomeCli) +" Valor R$ "+ AllTrim(Transform(nValTot, "@E 9,999,999.99")) +;
															 " nใo sincronizado - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := "microsiga@cantu.com.br;" + SA3->A3_EMAIL
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
/*
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

oProcess := TWFProcess():New(cProcess,OemToAnsi("Pedido de Venda Recebido Oracle"))
oProcess:NewTask(cStatus,"\workflow\wfpedsincronizado.htm")
oProcess:cSubject := OemToAnsi("BARUZITO - Pedido cliente " + cNomeCli + " recebido - " + SM0->M0_NOME + " / " + SM0->M0_FILIAL)

SA3->(dbSetOrder(01))
SA3->(dbSeek(xFilial("SA3") + cVend))

cEmail    := "microsiga@cantu.com.br," + SA3->A3_EMAIL
cNomeVend := SA3->A3_COD + " - " + AllTrim(SA3->A3_NREDUZ)

oProcess:cTo := ALLTRIM(cEmail) 
oProcess:cCC := "sfa2@cantu.com.br" 
       
       */                             
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ฟ
//ณPreenchimento do cabe็alho do pedidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ0ู
/*
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
*/
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณJOBORAINT บAutor  ณMicrosiga           บ Data ณ  14/03/13   บฑฑ
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
User Function JOBORAINT(cEmp, cFil, aCabPed, aItemPed, lSemItens, cNumPed, idPedido, cIP, cPort)      
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
//Local cCondCC	:= SuperGetMV("MV_X_ORACC",,"951/952/953/954/955/957")    

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
		cErro := "PEDIDO INCLUIDO FALTANDO "+ AllTrim(Str(nQtdeEco - nQtdERP)) +" ITENS. NUMERO NO PROTHEUS: "+ cNumPed
		GrvStatus(AllTrim(cIdPedido), -1, cErro)	
		EnviaErro(cErro, aCabPed, aItemPed, 2)
	Else
		GrvStatus(idPedido, 2, "PEDIDO PROTHEUS "+ AllTrim(cNumPed), cNumPed)
		EnviaPedOk(cNumPed, aCabPed, aItemPed)			
	
		cHORA := TIME()
		
	    //-- Realiza libera็ใo total do pedido
		If (SuperGetMV("MV_LPAEECO",,.F.) .and. (cHORA >= MIN_HORA .and. cHORA <= MAX_HORA))  
			
			dbSelectArea("SC5")
			SC5->(dbSetOrder(1))
			conout("1-LIBERANDO PEDIDO: "+cNumPed)
			If SC5->(dbSeek(xFilial("SC5")+cNumPed))
				aPvlNfs   := {}
				aRegistros := {}
				aBloqueio := {{"","","","","","","",""}} 
				ConOut("2-LIBERANDO PEDIDO: "+cNumPed)  
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
		//-- Libera apenas cr้dito	
		ElseIf (SC5->C5_CONDPAG $ "951/952/953/954/955/957") 
			Conout("6-LIBERANDO CREDITO: "+cNumPed)
			SC6->(DBSelectArea("SC6"))
	 		SC6->(DBSetOrder(1))
		    SC6->(MsSeek(xFilial("SC6")+SC5->C5_NUM))
		    Begin Transaction
		    	While SC6->C6_NUM == SC5->C5_NUM .AND. SC6->(!EOF())
		        	MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,.T.,.F.,.F.,.T.) //Libera cr้dito e avalia estoque
       			SC6->(dBSkip())
			    EndDo
     
    			MaLiberOk({ SC5->C5_NUM },.T.)
		     End Transaction
		EndIf
	EndIf

Else

//	GrvStatus(cIdPedido, -1, "ERRO NA EXECUCAO DO MSEXECAUTO")

	if !ExistDir("\PEDORA")
		MakeDir("\PEDORA")
	EndIf                                                                          
	cErro := MostraErro("\PEDORA")
	
	GrvStatus(cIdPedido, -1, "ERRO " + cErro)
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
cSql += "  AND C5.C5_X_TPLIC  = '1' " //Flag para pedidos integrados - Oracle
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
	cSql += "  FROM ORACLEFUSION.CRM_MVPD ITENS "                                   
	cSql += " INNER JOIN ORACLEFUSION.CRM_CBPD PED "                                   	
	cSql += "    ON PED.CODICBPD = ITENS.CODICBPD "	
	cSql += " WHERE PED.CODICBPD = '"+ AllTrim(aCabPed[nPosCot][2]) + "'"
	
	TCQUERY cSql NEW ALIAS "ITENSORA"
	
	DbSelectArea("ITENSORA")
	ITENSORA->(DbGoTop())
	
	nQtdeEco := ITENSORA->QUANT
	
	ITENSORA->(DbCloseArea()) 
	
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
Static Function GrvStatus(cPedido, nStatus, cMsg, cPedidoERP)
Local cSql := " "

ConOut("IMPPEDORACLE - PEDIDO: "+ cPedido +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
			 iif(nStatus == -1, "ERRO DE INTEGRACAO", iif(nStatus == 1, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET STATCBPD = '"+ AllTrim(Str(nStatus)) +"', MSINCBPD = '"+ AllTrim(cMsg) +"', SIGACBPD = '" + Alltrim(cPedidoERP) + "' WHERE CODICBPD = '"+ AllTrim(cPedido) +"'" 

TcSqlExec(cSql)

Return     


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel por atualizar a filial nos casos de estoque unico ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function AtuFilial(aPedidos)

cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET EMPRCBPD = '"+ cEmpAnt +"', FILICBPD = '"+ cFilAnt +"', ORIGCBPD = '" + aPedidos[06]+aPedidos[07] + "' WHERE CODICBPD = '"+ AllTrim(aPedidos[01]) +"'" 	


TcSqlExec(cSql)

Return               


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel pela grava็ใo de erro na tabela intermediแria                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Static Function GrvErro(cPedido, cMsgErro)
Local cSql := " "

ConOut("IMPPEDORACLE - PEDIDO: "+ cPedido +" - MOSTRAERRO: "+ cMsgErro)

cMsgErro := SubSTR(STRTRAN(cMsgErro,chr(10)+chr(13),"*"),1,3999)

//@AQUI
//cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET STATCBPD SET MSERCBPD = '"+cMsgErro+"' WHERE CODICBPD = "+ cPedido + "'"
cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET STATCBPD = '-1', MSINCBPD = '"+cMsgErro+"' WHERE CODICBPD = '"+ cPedido + "'"
TcSqlExec(cSql)

Return 
       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo utilizada para avaliar Threads em execu็ใoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
*--------------------------------*
Static Function FreeAllThreads()
*--------------------------------*

Local aUserInfoArray := GetUserInfoArray()
Local cEnvServer	 := GetEnvServer()
Local cComputerName	 := GetComputerName()
Local nThreads		 := 0
Local lFreeThreads   := .F.

aEval( aUserInfoArray , { |aThread| IF(;
											( aThread[2] == cComputerName );
											.and.;
											( aThread[5] == "U_JOBORAINT" );
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
ฑฑบPrograma  ณMONITORA บAutor  ณGustavo Lattmann      บ Data ณ  01/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina desenvolvida com a finalidade de reimportar/excluir บฑฑ
ฑฑบ          ณ pedidos com problema de integra็ใo do Oracle Sales Cloud   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Faturamento                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*------------------------------*
User Function MONITORA()
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
Private oDlg
Private aCboFiltro := {"1=Erro de integra็ใo","2=Nใo integrado","3=Em processo de integra็ใo","4=Integrado com sucesso","5=Pedido bloqueado","6=Aguardando autoriza็ใo","7=Autoriza็ใo recusada","8=Todos os pedidos"}
Private aCampos    := {}
Private aCpos      := {}
Private cTrab 
Private cIndic
Private oMark
Private cPerg      := "MONITORA"      
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
	//MV_PAR09 := 1                                      
	
	if Select("PED_ORACLE") > 0
		PED_EECO->(DbCloseArea())
	EndIf
	
	aCpos := {}
	
	aAdd(aCpos, {"MARK"    , "C" , 02, 0})
	aAdd(aCpos, {"EMPRESA" , "C" , 02, 0})
	aAdd(aCpos, {"FILIAL"  , "C" , 02, 0})
	aAdd(aCpos, {"IDPEDIDO", "C" , 06, 0})
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
	
	dbUseArea( .T.,,cTrab,"PED_ORACLE",.F. )
	dbSelectArea("PED_ORACLE")
	cChave1  := "EMPRESA+FILIAL+IDPEDIDO"
	
	IndRegua("PED_ORACLE",cIndic,cChave1,,,"Selecionando Registros...")
	dbSelectArea("PED_ORACLE")
	
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

	
	aAdd(aCores,{"PED_ORACLE->STATUS == -1","BR_VERMELHO"})
	aAdd(aCores,{"PED_ORACLE->STATUS == 0" ,"BR_BRANCO"  })
	aAdd(aCores,{"PED_ORACLE->STATUS == 1" ,"BR_AMARELO" })
	aAdd(aCores,{"PED_ORACLE->STATUS == 2" ,"BR_VERDE"   })
	aAdd(aCores,{"PED_ORACLE->STATUS == 3" ,"BR_CINZA"   })
	aAdd(aCores,{"PED_ORACLE->STATUS == 4" ,"BR_LARANJA" })
	aAdd(aCores,{"PED_ORACLE->STATUS == 5" ,"BR_PRETO"   })
	

  	DEFINE MSDIALOG oDlg TITLE "Monitor Pedidos Protheus x Oracle Sales Cloud" FROM 000, 000  TO 500, 900 COLORS 0, 16777215 PIXEL

    @ 212, 001 GROUP oGrpBtn TO 248, 449 OF oDlg COLOR 0, 16777215 PIXEL
    oMark := MsSelect():New("PED_ORACLE", "MARK", , aCampos, @lInverte, cMarca, {030, 001, 210, 450},,,,,aCores)
 		ObjectMethod(oMark:oBrowse,"Refresh()")
 		oMark:oBrowse:lhasMark := .T.
 		oMark:oBrowse:lCanAllmark := .T.
		oMark:oBrowse:Refresh()
    
    @ 011, 002 MSCOMBOBOX oCboFiltro VAR nCboFiltro ITEMS aCboFiltro ON CHANGE CarregaDados() SIZE 146, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 004, 003 SAY oLbFiltro PROMPT "Filtro:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

    @ 010, 160 BUTTON oBtnPesq  PROMPT "&Parโmetros"        SIZE 060, 013 OF oDlg ACTION FindOrder() 		PIXEL
    @ 010, 225 BUTTON oBtnPesq  PROMPT "&Re&fresh"        	SIZE 060, 013 OF oDlg ACTION CarregaDados()		PIXEL
    @ 220, 055 BUTTON oBtnPesq  PROMPT "&Legenda"   	 			SIZE 060, 013 OF oDlg ACTION fLegenda() 		PIXEL
    @ 220, 120 BUTTON oBtnVis   PROMPT "&Visualizar Pedido" SIZE 060, 013 OF oDlg ACTION Visualiza() 		PIXEL
    @ 220, 185 BUTTON oBtnErros PROMPT "Erros &Integra็ใo"  SIZE 060, 013 OF oDlg ACTION ErrosInt() 		PIXEL
    @ 220, 250 BUTTON oBtnExc   PROMPT "&Excluir Pedido"    SIZE 060, 013 OF oDlg ACTION ExcPed() 			PIXEL
    @ 220, 315 BUTTON oBtnRepr  PROMPT "&Reimportar"	  	  SIZE 060, 013 OF oDlg ACTION ReprocPed()		PIXEL
    @ 220, 380 BUTTON oBtnClose PROMPT "&Fechar"            SIZE 060, 013 OF oDlg ACTION fCloseDlg()		PIXEL

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHฟ
	//ณFaz carga inicial dos dados com base nos parโmetros defaultsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤHู
	
	RptStatus({|lEnd| CarregaDados(1,@lEnd)}, "Aguarde...","Buscando pedidos...", .T.)

	ACTIVATE MSDIALOG oDlg CENTERED                                                                  

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

*-------------------------------------*
Static Function fCloseDlg()
*-------------------------------------*
	PED_ORACLE->(DbCloseArea())
	Close(oDlg)

Return


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

DbSelectArea("PED_ORACLE")
PED_ORACLE->(DbGoTop())
Do While !PED_ORACLE->(Eof())
    RecLock("PED_ORACLE",.F.)
    DbDelete()
    MsUnlock() 
    PED_ORACLE->(DbSkip())
Enddo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFaz uma busca pelos pedidos da empresa posicionada no la็o do FOR e que estใo com status "0"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cSql := "SELECT CAST(PEDIDO.CODICBPD AS VARCHAR(9)) AS IDPEDIDO, "                 +cEol
cSql += "       PEDIDO.STATCBPD AS STATUS, "                                       +cEol
cSql += "       PEDIDO.EMISCBPD AS DTPEDIDO, "						               +cEol
cSql += "       PEDIDO.SEGECBPD AS SEGMENTO, " 				                       +cEol
cSql += "       CAST(PEDIDO.MSG_CBPD AS VARCHAR(3000)) AS OBS, "                   +cEol
cSql += "       TRIM(PEDIDO.EMPRCBPD) AS EMPRESA, "	                               +cEol
cSql += "       TRIM(PEDIDO.FILICBPD) AS FILIAL, "                                 +cEol
cSql += "       PEDIDO.TABECBPD AS TABELA, " 				                       +cEol
cSql += "       PEDIDO.CONDCBPD AS FORMAPAGAMENTO, " 					           +cEol
cSql += "       PEDIDO.VENDCBPD AS VENDEDORERP, "				                   +cEol
cSql += "       PEDIDO.CLIECBPD AS CLIENTE, " 				                       +cEol
cSql += "       PEDIDO.LOJACBPD AS LOJA, "				                           +cEol
cSql += "       PEDIDO.TIPOCBPD AS OPER, "				                           +cEol	
cSql += "       PEDIDO.TPCLCBPD AS TIPOCLI, "			                           +cEol		
cSql += "       DBMS_LOB.SUBSTR(PEDIDO.MSINCBPD, 4000, 1 ) AS ERRO"		           +cEol			
cSql += " FROM ORACLEFUSION.CRM_CBPD PEDIDO "                  					   +cEol
cSql += "WHERE PEDIDO.EMISCBPD BETWEEN '"+ DtoS(mv_par01) +"' AND '"+ DtoS(mv_par02) +"' "  +cEol
cSql += "  AND PEDIDO.CLIECBPD BETWEEN '"+ mv_par03       +"' AND '"+ mv_par04       +"' "  +cEol
cSql += "  AND PEDIDO.LOJACBPD BETWEEN '"+ mv_par05       +"' AND '"+ mv_par06       +"' "  +cEol
cSql += "  AND PEDIDO.VENDCBPD BETWEEN '"+ mv_par07       +"' AND '"+ mv_par08       +"'"  +cEol 

//Guilherme 16/02/17 - Alterado para mostrar todas as filiais da empresa selecionada.
cSql += "  AND TRIM(PEDIDO.EMPRCBPD) = '"+ cEmpAnt +"' "                             +cEol
If mv_par09 == 2
	cSql += "  AND TRIM(PEDIDO.FILICBPD) = '"+ cFilAnt +"' "                             +cEol    
EndIf           
//Guilherme 16/02/17 - FIM

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida็ใo de status conforme sele็ใo do usuแrioณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Do Case
	Case nCboFiltro == '1'
		cSql += "  AND PEDIDO.STATCBPD = -1 "                                                 +cEol
	Case nCboFiltro == '2'
		cSql += "  AND PEDIDO.STATCBPD = 0 "                                                  +cEol
	Case nCboFiltro == '3'
		cSql += "  AND PEDIDO.STATCBPD = 1 "                                                  +cEol
	Case nCboFiltro == '4'
		cSql += "  AND PEDIDO.STATCBPD = 2 "                                                  +cEol
	Case nCboFiltro == '5'
		cSql += "  AND PEDIDO.STATCBPD = 3 "                                                  +cEol
	Case nCboFiltro == '6'
		cSql += "  AND PEDIDO.STATCBPD = 4 "                                                  +cEol
	Case nCboFiltro == '7'
		cSql += "  AND PEDIDO.STATCBPD = 5 "                                                  +cEol
EndCase

cSql += "ORDER BY PEDIDO.EMPRCBPD, PEDIDO.FILICBPD"

TCQUERY cSql NEW ALIAS "PEDIDO"

DbSelectArea("PEDIDO")
PEDIDO->(DbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se o retorno da busca for vaziaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If PEDIDO->(eof())

	If nExec == 2
		PED_ORACLE->(DbGoTop())
		ObjectMethod(oMark:oBrowse,"Refresh()")
		oDlg:Refresh()
	EndIf

	PEDIDO->(DbCloseArea())
	Return .T.
EndIf

aPedidos := {}

while !PEDIDO->(eof())
	
	dbSelectArea("PED_ORACLE")
	
	RecLock("PED_ORACLE", .T.)
	PED_ORACLE->MARK     := "  "
	PED_ORACLE->EMPRESA  := PEDIDO->EMPRESA
	PED_ORACLE->FILIAL   := PEDIDO->FILIAL
	PED_ORACLE->IDPEDIDO := PEDIDO->IDPEDIDO 
	PED_ORACLE->VENDEDOR := PEDIDO->VENDEDORERP
	PED_ORACLE->CLIENTE  := PEDIDO->CLIENTE
	PED_ORACLE->LOJA     := PEDIDO->LOJA
	PED_ORACLE->RAZAO    := Space(30) 
	PED_ORACLE->DTPEDIDO := StoD(PEDIDO->DTPEDIDO)
//	PED_ORACLE->VALOR    := PEDIDO->VALORTOTAL
	PED_ORACLE->STATUS   := PEDIDO->STATUS
	PED_ORACLE->ERRO     := PEDIDO->ERRO  
	PED_ORACLE->(MsUnlock())

	PEDIDO->(DbSkip())
EndDo

PEDIDO->(DbCloseArea()) 

PED_ORACLE->(DbGoTop())

if !PED_ORACLE->(EOF())
	while !PED_ORACLE->(EOF())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPreenche razใo social do cliente com base nas informa็๕es contidas no banco de produ็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		RecLock("PED_ORACLE", .F.)
			PED_ORACLE->RAZAO := SubStr(Posicione("SA1", 1, xFilial("SA1") + PED_ORACLE->CLIENTE + PED_ORACLE->LOJA, "A1_NOME"), 01, 30)
		PED_ORACLE->(MsUnlock())
		
		PED_ORACLE->(DbSkip())
		
	EndDo
	
	PED_ORACLE->(DbGoTop())
	
EndIf

ObjectMethod(oMark:oBrowse,"Refresh()")
oDlg:Refresh()

Return .T.



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

Static Function fLegenda()

Local cTitulo := OemtoAnsi("Legenda")

Local aCores	:= {	{ 'BR_VERMELHO'	, "Erro de integra็ใo" 		 	},;
						{ 'BR_BRANCO'   , "Nใo integrado"				},;
						{ 'BR_AMARELO'	, "Em processo de integra็ใo"	},;
						{ 'BR_VERDE'	, "Integrado com sucesso"  		},;
						{ 'BR_CINZA'	, "Bloqueado"   				},;
						{ 'BR_LARANJA'	, "Aguardando autoriza็ใo"		},;
						{ 'BR_PRETO'	, "Autoriza็ใo recusada"  		}}											
												
	BrwLegenda(cTitulo, "Legenda", aCores)


Return          


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

Static Function ReprocPed(oDlg)
 
Local nRECPED := PED_ORACLE->(RECNO())
Local aPEDIDO := {}

Private cIP   := CIPSERVER
Private cPort := FGETPORT()

	dbSelectArea("PED_ORACLE")
	PED_ORACLE->(DbGoTop())
	Do While !PED_ORACLE->(Eof())
		If !Empty(PED_ORACLE->MARK) 
			If ( PED_ORACLE->STATUS == -1 .OR. PED_ORACLE->STATUS == 0 .OR. PED_ORACLE->STATUS == 1 )
				nPOSEMP := 0
				If Len(aPEDIDO) > 0
					nPOSEMP := aScan (aPEDIDO, {|x| x[1] == PED_ORACLE->EMPRESA .and. x[2] == PED_ORACLE->FILIAL })
				EndIf          
				If nPOSEMP == 0
					aAdd (aPEDIDO, {PED_ORACLE->EMPRESA, PED_ORACLE->FILIAL, {} })
					nPOSEMP := Len(aPEDIDO)
				EndIf
				aAdd ( aPEDIDO[nPOSEMP][3], PED_ORACLE->IDPEDIDO ) 
			Else
				aPEDIDO := {}
				Aviso("Aviso","Somente podem ser reprocessados pedidos com os status (Erro de integra็ใo/Nใo integrado/Em processo de integra็ใo ).",{"OK"})
				Exit
			EndIf
		EndIf
	   PED_ORACLE->(DbSkip())
	Enddo
	PED_ORACLE->(dbGoTo(nRECPED))
	
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
		cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET STATCBPD = 0 WHERE CODICBPD = "+ cValToChar(aPedido[nI][03][nJ])      //@aqui
		TcSqlExec(cSql)
		nCnt++
	Next nJ	
	Sleep(1000)
Next nI

Aviso("Pedidos reprocessando...", "Foram marcados "+cValToChar(nCnt)+" pedidos para serem reprocessados.", {"Ok"}, 2 )

Return          

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
Static Function FindOrder()

if (Pergunte(cPerg, .T.))
	CarregaDados()
EndIf

Return

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

Static Function Visualiza()

Local nRECPED 		:= PED_ORACLE->(RECNO())
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
Private oItensPV, oDlg 
Private cEol      	:= CHR(13)+CHR(10)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem dos campos de cabecalho                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea("PED_ORACLE")
	PED_ORACLE->(DbGoTop())
	Do While !PED_ORACLE->(Eof())
		If !Empty(PED_ORACLE->MARK)
			CAB_EMPRESA  := PED_ORACLE->EMPRESA
			CAB_FILIAL   := PED_ORACLE->FILIAL
			CAB_IDPEDIDO := PED_ORACLE->IDPEDIDO
			CAB_VENDEDOR := PED_ORACLE->VENDEDOR
			CAB_CLIENTE  := PED_ORACLE->CLIENTE
			CAB_LOJA     := PED_ORACLE->LOJA
			CAB_RAZAO    := PED_ORACLE->RAZAO
			CAB_DTPEDIDO := PED_ORACLE->DTPEDIDO
			CAB_VALOR    := PED_ORACLE->VALOR
			CAB_STATUS   := PED_ORACLE->STATUS
			CAB_ERRO     := PED_ORACLE->ERRO  
		    Exit
		EndIf
	   PED_ORACLE->(DbSkip())
	Enddo
	PED_ORACLE->(dbGoTo(nRECPED))
	
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
	Aadd(aHeadITE,{"Desc. Unit.",  		"ITE_DESUNI", "@E 999,999,999.99",	TAMSX3("C6_VALOR")[1], 		TAMSX3("C6_VALOR")[2], 		, ,"N",, }) 
//	Aadd(aHeadITE,{"Desc. Total",  		"ITE_DESTOT", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
//	Aadd(aHeadITE,{"Valor ST",  		"ITE_SUBTRI", "@E 999,999,999.99",	TAMSX3("C6_QTDVEN")[1], 	TAMSX3("C6_QTDVEN")[2], 	, ,"N",, }) 
//	Aadd(aHeadITE,{"Promo็ใo", 	   		"ITE_PROMOC", "",	 				1,							0,							, ,"C",, }) 
//	Aadd(aHeadITE,{"Bonificado",	   	"ITE_BONIFI", "",	 				1,							0,							, ,"C",, }) 

	DEFINE MSDIALOG oDlg TITLE "Visualiza็ใo do pedido "+cValToChar(CAB_IDPEDIDO) FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL

	@ 005,005 TO 070,440
	@ 010,010 SAY		oCPOTIT PROMPT "Empresa" 		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,045 MSGET 	oCPODAT VAR CAB_EMPRESA 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,100 SAY		oCPOTIT PROMPT "Filial" 		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,135 MSGET 	oCPODAT VAR CAB_FILIAL	 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,190 SAY		oCPOTIT PROMPT "Id. Pedido"		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 010,225 MSGET 	oCPODAT VAR CAB_IDPEDIDO 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 025,010 SAY		oCPOTIT PROMPT "Cliente"		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025,045 MSGET 	oCPODAT VAR CAB_CLIENTE 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025,100 SAY		oCPOTIT PROMPT "Loja"	 		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025,135 MSGET 	oCPODAT VAR CAB_LOJA	 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025,190 SAY		oCPOTIT PROMPT "Razใo Social"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 025,225 MSGET 	oCPODAT VAR CAB_RAZAO	 		SIZE 150, 007 OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 040,010 SAY		oCPOTIT PROMPT "Vendedor" 		SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040,045 MSGET 	oCPODAT VAR CAB_VENDEDOR 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040,100 SAY		oCPOTIT PROMPT "Data Pedido"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040,135 MSGET 	oCPODAT VAR CAB_DTPEDIDO 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040,190 SAY		oCPOTIT PROMPT "Valor Pedido"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 040,225 MSGET 	oCPODAT VAR CAB_VALOR	 		SIZE 040, 007 PICTURE "@E 999,999.99" OF oDlg COLORS 0, 16777215 PIXEL
	
	@ 055,010 SAY		oCPOTIT PROMPT "Status Pedido"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055,045 MSGET 	oCPODAT VAR CAB_STATUS	 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055,100 SAY		oCPOTIT PROMPT "Msg Integra็ใo"	SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 055,135 MSGET 	oCPODAT VAR CAB_ERRO	 		SIZE 240, 007 OF oDlg COLORS 0, 16777215 PIXEL
	
	oItensPV := MsNewGetDados():New( 080, 5, 205, 440, 3, "AllwaysTrue()", "AllwaysTrue()", , , 000, 999,, "", .T., oDlg, aHeadITE ,aColsITE )

	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"         SIZE 056, 013 OF oDlg ACTION Close(oDlg) PIXEL
	
	RptStatus({|lEnd| LoadItens(CAB_IDPEDIDO,lEnd)}, "Aguarde...","Atualizando itens do pedido no Grid...", .T.)
	
	ACTIVATE MSDIALOG oDlg CENTERED
	

Return                          

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

Static Function LoadItens(cCodigo,lEND)

Local nY := 0  
Local cEol := CHR(13)+CHR(10)

oItensPV:aCols := {}
	
	cSql := "SELECT ITENS.PRODMVPD AS CODIGO, " 						            +cEol
	cSql += "       ITENS.QUANMVPD AS QUANTIDADE, "                                 +cEol
//	cSql += "       ITENS.PRUNMVPD AS VLRUNITARIO, "			                   +cEol
	cSql += "       ITENS.PRUNMVPD AS PRECOVENDA, " 			                    +cEol
	cSql += "       ITENS.TABEMVPD, "			 	 			                    +cEol
	cSql += "       ITENS.DESCMVPD AS DESCUNIT, "						            +cEol
	//cSql += "       ITENS.descontoitem as desctotal, "                              +cEol
	//cSql += "       ITENS.valorunitariobruto as vlrstrib, "                         +cEol
	//cSql += "		  ITENS.promocao, "   						                      +cEol
	//cSql += "       ITENS.bonificado, "                                             +cEol
	//cSql += "       ITENS.embalagem as unidade, "                                   +cEol
	//cSql += "       ITENS.codigokit, "  	                                          +cEol
	cSql += "       ITENS.CODICBPD "                                                +cEol
	cSql += "FROM  ORACLEFUSION.CRM_MVPD ITENS "                           			+cEol 
	cSql += "INNER JOIN ORACLEFUSION.CRM_CBPD CAB"					 				+cEol
	cSql += " ON CAB.CODICBPD = ITENS.CODICBPD"								 		+cEol
	cSql += "WHERE CAB.CODICBPD = "+ cCodigo //Faz a busca pela chave primaria da tabela
		
	TCQUERY cSql NEW ALIAS "ITENS"
	
	dbSelectArea("ITENS")
	ITENS->(dbGoTop())
	If (ITENS->(!Eof()))	
		While (ITENS->(!Eof()))	
			
			aAdd(oItensPV:aCols, Array(Len(oItensPV:aHeader)+1))
			oItensPV:aCols[Len(oItensPV:aCols),01] := ITENS->CODIGO
			oItensPV:aCols[Len(oItensPV:aCols),02] := Space(TamSX3("B1_DESC")[01]) 
			oItensPV:aCols[Len(oItensPV:aCols),03] := ITENS->QUANTIDADE
			oItensPV:aCols[Len(oItensPV:aCols),04] := ITENS->PRECOVENDA
			oItensPV:aCols[Len(oItensPV:aCols),05] := Round(ITENS->QUANTIDADE * ITENS->PRECOVENDA,2)
			oItensPV:aCols[Len(oItensPV:aCols),06] := ITENS->DESCUNIT
			//oItensPV:aCols[Len(oItensPV:aCols),07] := ITENS->desctotal
		   	//oItensPV:aCols[Len(oItensPV:aCols),08] := ITENS->vlrstrib
			//oItensPV:aCols[Len(oItensPV:aCols),09] := ITENS->promocao
			//oItensPV:aCols[Len(oItensPV:aCols),10] := itens->bonificado
			oItensPV:aCols[Len(oItensPV:aCols),Len(oItensPV:aHeader)+1] := .F.
			
			ITENS->(dbSkip())
		Enddo
	Else 
		aAdd(oItensPV:aCols, Array(Len(oItensPV:aHeader)+1))
		oItensPV:aCols[Len(oItensPV:aCols),Len(oItensPV:aHeader)+1] := .F.
	EndIf
	ITENS->(dbCloseArea()) 
	
	If Len(oItensPV:aCols) > 0 .and. ValType(oItensPV:aCols[01, 01]) == "C"
		
		For nY := 1 to Len(oItensPV:aCols)
			oItensPV:aCols[nY, 02] := Posicione("SB1", 1, xFilial("SB1") + oItensPV:aCols[nY, 01], "B1_DESC")
		Next nY

	EndIf
	
	oItensPV:Refresh()
	oDlg:Refresh()
	
Return                       

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

Static Function ExcPed()

Local nRECPED := PED_ORACLE->(RECNO())
Local aDELETE := {}

	dbSelectArea("PED_ORACLE")
	PED_ORACLE->(DbGoTop())
	Do While !PED_ORACLE->(Eof())
		If !Empty(PED_ORACLE->MARK)
			If PED_ORACLE->STATUS == -1 .OR. PED_ORACLE->STATUS == 5
				aAdd (aDELETE, PED_ORACLE->IDPEDIDO)
			EndIf
		EndIf
	   PED_ORACLE->(DbSkip())
	Enddo
	PED_ORACLE->(dbGoTo(nRECPED))
	
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

Static Function fProcExc(aDELETE,lEnd)
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณExclui os itens primeiro devido a restri็ใo de integridade.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Begin Transaction
		For nI := 1 to Len(aDELETE)
			cSql := "DELETE FROM ORACLEFUSION.CRM_MVPD WHERE CODICBPD = "+ aDELETE[nI]
			TCSQLExec(cSql)
			cSql := "DELETE FROM ORACLEFUSION.CRM_CBPD WHERE CODICBPD = "+ aDELETE[nI]
			TCSQLExec(cSql)
		Next nI       
	End Transaction
	
	//--Recarrega os pedidos no grid principal.
	CarregaDados()

Return

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
Local nRECPED := PED_ORACLE->(RECNO())
Local cIdPedido := ""
Local cErroPedido := ""
Private oMemo, oDlg 

	dbSelectArea("PED_ORACLE")
	PED_ORACLE->(DbGoTop())
	Do While !PED_ORACLE->(Eof())
		If !Empty(PED_ORACLE->MARK)
			cIdPedido := PED_ORACLE->IDPEDIDO
			Exit
		EndIf
	   PED_ORACLE->(DbSkip())
	Enddo
	PED_ORACLE->(dbGoTo(nRECPED))
	
	If cIdPedido == ""
		Aviso("Aviso","Nenhum pedido foi selecionado para visualiza็ใo de erros.",{"OK"})
		Return
	EndIf

	cSql := "SELECT TRIM(DBMS_LOB.SUBSTR(MSINCBPD, 4000, 1)) AS MOSTRAERRO FROM ORACLEFUSION.CRM_CBPD WHERE CODICBPD = "+ cIdPedido
	
	TCQUERY cSql NEW ALIAS "ERROPED"
	
	dbSelectArea("ERROPED")
	ERROPED->(dbGoTop())
	If !ERROPED->(EOF())
		cErroPedido := STRTRAN(ERROPED->MOSTRAERRO,"*",chr(10)+chr(13))			 
	EndIf
	ERROPED->(dbCloseArea())
	
	If Empty(cErroPedido)
		Aviso("Aviso","Nใo existem dados para visualiza็ใo.",{"OK"})
		Return
	EndIf
		
	DEFINE MSDIALOG oDlg TITLE "Erros de integra็ใo do pedido "+ cIdPedido FROM 000,000 TO 500,900 COLORS 0,16777215 PIXEL
	@ 015,015 GET oMemo VAR cErroPedido MEMO SIZE 420,200 OF oDlg PIXEL READONLY
	@ 220,380 BUTTON oBtnClose PROMPT "&Fechar"  SIZE 056, 013 OF oDlg ACTION Close(oDlg) PIXEL
	
	ACTIVATE MSDIALOG oDlg CENTERED


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

Static Function CriaSx1(cPerg)
	PutSx1(cPerg,"01","Emissao De:"    ,"Emissao De:"    ,"Emissao De:"    ,"mv_ch1","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par01",""   ,"","","Date()",""   )
	PutSx1(cPerg,"02","Emissao Ate: "  ,"Emissao Ate: "  ,"Emissao Ate: "  ,"mv_ch2","D",08,0,0,"G","NaoVazio",""   ,"","","mv_par02",""   ,"","","Date()",""   )
	PutSx1(cPerg,"03","Cliente De: "   ,"Cliente De: "   ,"Cliente De: "   ,"mv_ch3","C",09,0,0,"G",""        ,"SA1","","","mv_par03")
	PutSx1(cPerg,"04","Cliente Ate: "  ,"Cliente Ate: "  ,"Cliente Ate: "  ,"mv_ch4","C",09,0,0,"G","NaoVazio","SA1","","","mv_par04") 
	PutSx1(cPerg,"05","Loja De: "      ,"Loja De: "      ,"Loja De: "      ,"mv_ch5","C",04,0,0,"G",""        ,""   ,"","","mv_par05")
	PutSx1(cPerg,"06","Loja Ate: "     ,"Loja Ate: "     ,"Loja Ate: "     ,"mv_ch6","C",04,0,0,"G","NaoVazio",""   ,"","","mv_par06")
	PutSx1(cPerg,"07","Vendedor De: "  ,"Vendedor: "	 ,"Vendedor: "	   ,"mv_ch7","C",06,0,0,"G",""        ,"SA3","","","mv_par07")
	PutSx1(cPerg,"08","Vendedor Ate: " ,"Vendedor Ate: " ,"Vendedor Ate: " ,"mv_ch8","C",06,0,0,"G","NaoVazio","SA3","","","mv_par08")
	//Guilherme 16/02/17 - Alterado para mostrar todas as filiais da empresa selecionada.
	PutSx1(cPerg,"09","Todas Filiais?" ,"Todas Filiais?" ,"Todas Filiais?" ,"mv_ch9","N",01,0,0,"C",""        ,""   ,"","","mv_par09","1=Sim","","","" ,"2=Nao")
	//Guilherme 16/02/17 - FIM
Return


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