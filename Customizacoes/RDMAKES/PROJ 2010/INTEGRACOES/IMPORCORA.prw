#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.ch"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"         

#DEFINE MAX_PED  	30                  	  // Tamanho mแximo da fila para importa็ใo de pedidos       

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIMPORCORA บAutor  ณGustavo Lattmann   บ Data ณ  05/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ  Fun็ใo para importa็ใo dos or็amentos do CRM Oracle		  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 

*--------------------------*
User Function IMPORCORA()    
*--------------------------*
Local aItemPed   := {}
Local cErro      := ""
Local aEmpFil    := {}
Local cSql       := ""
Local cTipoCli   := ""       

//Private cIP        := CIPSERVER
//Private cPort      := FGETPORT()

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
ConOut("IMPORCORA - INICIANDO IMPORTACAO DE PEDIDOS") 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera empresa/filial do APPSERVER.INIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
cEMPFIL := "0101" //GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2) 
cCODFIL := SubSTR(cEMPFIL,3,2)

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
	ConOut("IMPORCORA - EXECUTANDO PARA EMPRESA "+cEmpIni) 
Else
	ConOut("IMPORCORA - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN") 
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona o sistema em uma empresa para dar inํcio na sele็ใo dos dadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmpIni, cFilIni,,,, GetEnvServer(),{ "SL1", "SL2", "SL4", "SA1" })	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria็ใo de arquivo temporแrio sobre a execu็ใo da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"IMPORCORA"+cCODEMP,"IMPORCORA"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois jแ esta sendo executada!")
		Return
	EndIf		
EndDo

ConOut("IMPORCORA - CONECTANDO NO BANCO INTERMEDIมRIO...")

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
	ConOut("IMPORCORA - SEM ORวAMENTOS A IMPORTAR") 
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
		RpcSetEnv(AllTrim(Transform(aEmpFil[nEmp,01], "@! 99")), AllTrim(Transform(aEmpFil[nEmp,02], "@! 99" )),,,,GetEnvServer(),{ "SL1", "SL2", "SL4", "SA1" })	
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
	cSql += "       PEDIDO.OBS_CBPD AS OBSERVACAO "			                           +cEol	
	cSql += " FROM ORACLEFUSION.CRM_CBPD PEDIDO "                  					   +cEol
	cSql += "WHERE PEDIDO.EMPRCBPD = '"+ AllTrim(aEmpFil[nEmp, 01]) +"' "              +cEol
	cSql += "  AND PEDIDO.FILICBPD = '"+ AllTrim(aEmpFil[nEmp, 02]) +"' "              +cEol
	cSql += "  AND PEDIDO.STATCBPD = 0 "                                               +cEol
	cSql += "  AND PEDIDO.OBS_CBPD = 'CUPOM' "                                         +cEol
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
										PEDIDO->TIPOCLI})          //14

		PEDIDO->(DbSkip())
	EndDo
	
	PEDIDO->(DbCloseArea())
	
	If Len(aPedidos) > 0 
		IncluiOrcamento(aPedidos)
	EndIf
	
Next nEmp


ConOut("IMPORCORA - FIM DA EXECUCAO")

RpcClearEnv() 

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIncluiOrcamento บAutorณGustavo Lattmann บData ณ  03/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Cantu                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/     
Static Function IncluiOrcamento(aPedidos)		

Local cNumDAV     := Space(TamSX3("L1_NUMORC")[1])
Local cNumOrc     := Space(TamSX3("L1_NUM")[1])
Local aLog        := {}
Local aSLQ        := {}
Local aSLR        := {}
Local aSL4        := {}
Local lOk         := .F.


Private cItemNovo 	:= PadL("00", Len(SC6->C6_ITEM))
Private lMsHelpAuto := .T. // Variavel de controle interno do ExecAuto
Private lMsErroAuto := .F. // Variavel que informa a ocorr๊ncia de erros no ExecAuto
Private INCLUI      := .T. // Variavel necessแria para o ExecAuto identificar que se trata de uma inclusใo
Private ALTERA      := .F. // Variavel necessแria para o ExecAuto identificar que se trata de uma inclusใo//Indica inclusใo

lMsHelpAuto         := .T.
lMsErroAuto         := .F.

nModulo := 12	//--SIGALOJA
                                
//AltStatus(aPedidos)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณExecuta os procedimentos de inclusใo do or็amento\atendimentoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

	
For nX := 1 to len(aPedidos)

	cNumOrc := GETSXENUM("SL1", "L1_NUM")
	cNumDAV := GETSXENUM("SL1", "L1_NUMORC")
	aSLQ    := {}
	aSLR    := {}
	aSL4    := {}
		
	dBSelectArea( "SL1" )
	SL1->(dBSetOrder(13))
	SL1->(dBGoTop())
	While SL1->(dBSeek(xFilial("SL1") + "P" + cNumDAV))
		cNumDAV := GetSxENum("SL1", "L1_NUMORC")
		SL1->(dBGoTop())
	Enddo

	dBSelectArea( "SL1" )
	SL1->(dBSetOrder(1))
	SL1->(dBGoTop())
	While SL1->(dBSeek(xFilial("SL1") + cNumOrc))
		cNumOrc := GetSxENum("SL1", "L1_NUM")
		SL1->(dBGoTop())
	Enddo

	SL1->(dbGoTop())

	dBSelectArea("SA1")
	SA1->(dbSetOrder(1)) 
	SA1->(dbGoTop())
	SA1->(dbSeek(xFilial("SA1") + aPedidos[nX, 11] + aPedidos[nX, 12]))
		
	aSLQ := { { "L1_FILIAL" , xFilial( "SL1" )                  , Nil },;
	          { "L1_EMISSAO", STOD(aPedidos[nX, 03])            , Nil },;
	          { "L1_NUM"    , cNumOrc                           , Nil },;
	          { "L1_NUMORC" , cNumDAV                           , Nil },;
	          { "L1_TPORC"  , "P"                               , Nil },;
	          { "L1_COMIS"  , 0				                    , Nil },;
	          { "L1_VEND2"  , ""			                    , Nil },;
	          { "L1_VEND3"  , ""			                    , Nil },;
	          { "L1_CLIENTE", aPedidos[nX, 11]                  , Nil },;
	          { "L1_LOJA"   , aPedidos[nX, 12]                  , Nil },;
	          { "L1_TIPOCLI", aPedidos[nX, 14]                  , Nil },;
	          { "L1_DESCONT", 0									, Nil },;
	          { "L1_DTLIM"  , dDataBase                         , Nil },;
	          { "L1_CONDPG" , aPedidos[nX, 09]                  , Nil },;
	          { "L1_CONFVEN", "SSSSSSSSNSSS"                    , Nil },;
	          { "L1_HORA"   , Time()                            , Nil },;
	          { "L1_TPFRET" , ""			                    , Nil },;
	          { "L1_IMPRIME", "1N"                              , Nil },;
	          { "L1_MOEDA"  , 1			                        , Nil },;
	          { "L1_TXMOEDA", 0					                , Nil },;
	          { "L1_VEND"   , aPedidos[nX, 10]                  , Nil },;
	          { "L1_FRETE"  , 0				                    , Nil },;
	          { "L1_SEGURO" , 0				                    , Nil },;
	          { "L1_DESPESA", 0				                    , Nil },;
	          { "L1_X_CLVL" , aPedidos[nX, 04]                  , Nil }}
	
			
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณRealiza a busca dos itensณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cSql := "SELECT ITENS.PRODMVPD AS CODIGO, " 		   	+cEol
	cSql += "       ITENS.QUANMVPD AS QUANTIDADE, "        	+cEol
	cSql += "       ITENS.PRUNMVPD AS PRECOVENDA, " 	  	+cEol
	cSql += "       ITENS.TOTAMVPD AS TOTAL, " 			    +cEol				
	cSql += "       ITENS.TABEMVPD, "			 	 		+cEol
	cSql += "       ITENS.CODICBPD "                        +cEol
	cSql += "FROM  ORACLEFUSION.CRM_MVPD ITENS "            +cEol 
	cSql += "INNER JOIN ORACLEFUSION.CRM_CBPD CAB"			+cEol
	cSql += " ON CAB.CODICBPD = ITENS.CODICBPD"				+cEol
	cSql += "WHERE CAB.CODICBPD = "+ aPedidos[nX, 01] 
	
	TCQUERY cSql NEW ALIAS "ITENS"
	
	dbSelectArea("ITENS")
	ITENS->(dbGoTop())
	
	GrvStatus(AllTrim(aPedidos[nX, 01]), 1, "INICIANDO INTEGRACAO")
	
	While (ITENS->(!Eof()))
		
		cItemNovo := Soma1(cItemNovo)  
	
		DbSelectArea("SB1")
		SB1->(dbSetOrder(01))
		SB1->(dbSeek(xFilial("SB1") + AllTrim(ITENS->CODIGO)))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPosiciona na tabela de Indicador de Produtoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SBZ")
		SBZ->(dbSetOrder(1))
		SBZ->(dbSeek ( xFilial("SBZ") + AllTrim(ITENS->CODIGO)))
		
		aAdd( aSLR, { { "L2_FILIAL" , xFilial( "SL2" )		, Nil },;
		              { "L2_NUM"    , cNumOrc         		, Nil },;
		              { "L2_ITEM"   , cItemNovo	    		, Nil },;
		              { "L2_PRODUTO", ITENS->CODIGO			, Nil },;
		              { "L2_DESCRI" , SB1->B1_DESC  		, Nil },;
		              { "L2_QUANT"  , ITENS->QUANTIDADE 	, Nil },;
		              { "L2_VRUNIT" , ITENS->PRECOVENDA		, Nil },;
		              { "L2_VLRITEM", ITENS->TOTAL	 		, Nil },;
		              { "L2_LOCAL"  , SBZ->BZ_LOCPAD   		, Nil },;
		              { "L2_UM"     , SB1->B1_TIPO      	, Nil },;
		              { "L2_DESC"   , 0						, Nil },;
		              { "L2_VALDESC", 0				 		, Nil },;
		              { "L2_TES"    , SBZ->BZ_TS	    	, Nil },;
		              { "L2_CF"     , "5102"	      		, Nil },;
		              { "L2_EMISSAO", STOD(aPedidos[nX, 03]), Nil },;
		              { "L2_GRADE"  , "N"             		, Nil },;
		              { "L2_VEND"   , aPedidos[nX, 10]  	, Nil },;
		              { "L2_TABELA" , aPedidos[nX, 08]  	, Nil },;
		              { "L2_PRCTAB" , 0                 	, Nil },;
		              { "L2_LOTECTL", ""					, Nil }})
		
		ITENS->(dBSkip())
	
	Enddo
	
	ITENS->(DbCloseArea())
	
	aAdd( aSL4, { { "L4_FILIAL" , xFilial( "SL4" )                          , NIL },;
				  { "L4_NUM"    , cNumOrc	                                , NIL },;
				  { "L4_DATA"   , ddatabase	                                , NIL },;
				  { "L4_FORMA"  , Padr( "R$", TamSX3( "L4_FORMA" )[ 1 ] )   , NIL },;
				  { "L4_ADMINIS", Padr( "R$", TamSX3( "L4_ADMINIS" )[ 1 ] ) , NIL },;
				  { "L4_FORMAID", Padr( "R$", TamSX3( "L4_FORMAID" )[ 1 ] ) , NIL },;
				  { "L4_MOEDA"  , 1			        	         	        , NIL } } )
				
	aSL4 := FWVetByDic( aSL4, "SL4", .T. )
	
	Begin Transaction
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณExecuta rotina automแtica de inclusใo do or็amentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		lGrava := Lj7GrvOrc( aSLQ, aSLR, aSL4, .T., .F. )[1]
		
		If !lGrava
			RollBackSx8()
			DISARMTRANSACTION()
			conout( "IMPORCORA - ERRO na grava็ใo do or็amento: "+MostraErro() )     
			GrvStatus(AllTrim(aPedidos[nX, 01]), -1, "ORวAMENTO NรO INTEGRADO")
		Else
			ConfirmSx8()
			conout( "IMPORCORA - Or็amento gravado com sucesso! N๚mero: "+cNumOrc )
			GrvStatus(AllTrim(aPedidos[nX, 01]), 2, "ORวAMENTO"+cNumOrc)			
		Endif
    
	End Transaction
	
Next nX

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvStatus บAutor  ณMicrosiga           บ Data ณ  05/05/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvStatus(cPedido, nStatus, cMsg, cPedidoERP)
Local cSql := " "

ConOut("IMPPRACPRA - PEDIDO: "+ cPedido +" STATUS: ("+ Alltrim(Str(nStatus)) +") "+;
			 iif(nStatus == -1, "ERRO DE INTEGRACAO", iif(nStatus == 1, "INICIANDO INTEGRACAO", iif(nStatus == 2, "INTEGRADO COM SUCESSO", "NAO INICIADO"))))
			 
cSql := "UPDATE ORACLEFUSION.CRM_CBPD SET STATCBPD = '"+ AllTrim(Str(nStatus)) +"', MSERCBPD = '"+ AllTrim(cMsg) +"', SIGACBPD = '" + Alltrim(cPedidoERP) + "' WHERE CODICBPD = '"+ AllTrim(cPedido) +"'" 

TcSqlExec(cSql)
