#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#Include "topconn.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE 'TBICONN.CH'               
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE CDIRSRV     "/fatauto/"              // Diret๓rio utilizado pela rotina para gravar os arquivos temporแrios
#DEFINE CDIRLOC     "c:\tmp\"                // Diret๓rio local utilizado para gravar os arquivos temporแrios

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuncao    ณFATCPX   ณ Autor ณMailson			        ณ Data ณ 19/02/14 ณฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function CAFATAUT()

Local aAreaSM0
Local i            := 0
Private cIP        := getServerIP()
Private cPort      := FGETPORT()
Private cEmpIni	   := "01"
Private cFilIni	   := "01"
Private aErros     := {}
Private aEmp       := {}   


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRecupera empresa/filial do APPSERVER.INIณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cEMPFIL := GetJobProfString("PREPAREIN", "")
cCODEMP := SubSTR(cEMPFIL,1,2)
cCODFIL := SubSTR(cEMPFIL,4,2)

//@qui..
//cCODEMP := "31"
//cCODFIL := "01"

If !Empty(cCODEMP) .and. !Empty(cCODFIL)
	cEmpIni	:= cCODEMP
	cFilIni	:= cCODFIL
	ConOut("FATAUTO - EXECUTANDO PARA EMPRESA "+cEmpIni)
Else
	ConOut("FATAUTO - PARAMETRO DE EMPRESA/FILIAL NAO ENCONTRADO - PREPAREIN")
	Return
EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona o sistema em uma empresa para dar inํcio na sele็ใo dos dadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//@qui...
RpcClearEnv()
RPCSETTYPE(3)
RpcSetEnv(cEmpIni, cFilIni,,,,"FATAUT",)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria็ใo de arquivo temporแrio sobre a execu็ใo da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
//@qui...
nLock := 0
While !LockByName(iif(!Empty(cCODEMP),"FATAUT"+cCODEMP,"FATAUT"),.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - Rotina finalizada pois jแ esta sendo executada!")
		aAdd(aErros, "O PROCESSO DE FAT. AUTOM. FICOU PRESO NA EMPRESA "+ cCODEMP +" FILIAL "+ cCODFIL +". ==> ENTRE EM CONTATO COM A EQUIPE DE T.I.")
		fAvalErros()
		Return
	EndIf
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJEAN - 18/08/14 - Adiciona as diferentes filiais da empresa que estแ sendo processadaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

aEmp := {}

cSql := "select '"+ AllTrim(cEmpAnt) +"' as empresa, zx5.zx5_filial from "+ RetSqlName("zx5") +" zx5 " +CHR(13)+CHR(10)
cSql += "where zx5.d_e_l_e_t_ = ' ' "                                                                  +CHR(13)+CHR(10)
cSql += "  and zx5.zx5_ativo  = '1' "                                                                  +CHR(13)+CHR(10)
cSql += "order by empresa, zx5.zx5_filial "

TcQuery cSql New Alias "zx5tmp"

DbSelectArea("zx5tmp")
zx5tmp->(DbGoTop())

If zx5tmp->(EOF())
	zx5tmp->(DbCloseArea())
	Return	
EndIf

While !zx5tmp->(EOF())
	aAdd(aEmp, {Trim(zx5tmp->empresa), zx5tmp->zx5_filial})
	zx5tmp->(dbSkip())
EndDo                                            

/*DbSelectArea("SM0")
SM0->(DbGoTop())
While !SM0->(EOF())
	If (SM0->M0_CODIGO == cEmpAnt) .and. (SM0->M0_CODFIL != "99")
		aAdd(aEmp, {SM0->M0_CODIGO, SM0->M0_CODFIL})
	EndIf
	SM0->(DbSkip())
EndDo
*/

If Len(aEmp) > 0
	For i := 1 to Len(aEmp)
		
			StartJob("U_FATAUTO", GetEnvServer(), .T., aEmp[i, 01], aEmp[i, 02], cIp, cPort)
			Sleep(1000)
		
	Next i
EndIf

ConOut("FATAUTO - FIM DA EXECUCAO NA EMPRESA "+ cEmpAnt)
RPCSETTYPE(3)
RpcSetEnv(cEmpIni, cFilIni,,,,"FATAUT",)

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAvalErros บAutor  ณJean Carlos Saggin บ Data ณ  10/06/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo criada para avaliar os erros que aconteceram no     บฑฑ
ฑฑบ          ณ processamento dos pedidos e notificar o responsแvel.       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAvalErros()

Local oHtml
Local nX    := 0
Local cDest := U_RETZX5()
Local oProcess

if Empty(cDest)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe nใo existir e-mail cadastrado para a filial, finaliza a fun็ใo.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Return nil
	
EndIf

if Len(aErros) > 0
	
	oProcess := TWFProcess():New("FATCPXERR",OemToAnsi("Inconsist๊ncias"))
	oProcess:NewTask("FATCPXERR","\workflow\wffatinco.htm")
	oProcess:cSubject := OemToAnsi("FAT. AUTO. " +Upper(AllTrim(SubStr(SM0->M0_NOMECOM, 01, 30)))+" INCONSISTสNCIAS ENCONTRADAS! ")
	oProcess:cTo := cDest
	
	oHTML := oProcess:oHTML
	
	for nX := 1 to Len(aErros)
		
		AAdd( (oHtml:ValByName( "IT.ERROS" )), aErros[nX] )
		
	Next nX
	
	oProcess:Start()
	oProcess:Finish()
	
EndIf

Return nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFGETPORT  Autor ณJean Carlos Saggin      ณ Data ณ 21/05/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a porta de execucao do protheus server.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FGETPORT()
Return(GetPvProfString( "TCP", "port", "20005", GetAdv97()))

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFun็ใo    ณFATAUTO     บAutor  ณJean Carlos Saggin  บ Data ณ  21/05/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Efetua o faturamento automแtico da empresa/filial.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATAUTO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function FATAUTO(cEmp, cFil, cIp, cPort)

Local aPvlNfs   := {}
Local nPrcVen   := 0
Local aNotas    :={}
Local cNota     := ""
Local cSerie    := ""
Local cEol      := CHR(13)+CHR(10)
Local nX        := 0
Local lContinua := .T.
Local cEnv      := GetEnvServer()

Private aPedidos  := {}
Private aItPed    := {}
Private nItemNf   := 100
Private lImprimiu := .F.
Private lFim      := .F.
Private cTssOk    := ""
Private aErros    := {}    

RpcClearEnv()
RPCSETTYPE(3)
RpcSetEnv(cEmp, cFil,,,,GetEnvServer(),{ "SC5", "SC6", "SF4", "SA1" })

cSerie  := Padr(GETMV("MVP_SERIE",.F.,"2"),3)
nItemNf := GETMV("MV_NUMITEN")

ConOut("FATAUTO - BUSCANDO PEDIDOS EMPRESA "+ cEmpAnt +" FILIAL "+ cFilAnt)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJEAN - 22/07/14 - SQL PARA BUSCAR PEDIDOS SEM AVALIAR SC9ณ 
//ณMailson - 02/11/14 - incluidos campos TID, AUTO e INST   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery := "SELECT C5.C5_FILIAL, C5.C5_NUM, C5.C5_CLIENTE, C5.C5_LOJACLI, C5.C5_XTID, C5.C5_XAUTO, C5.C5_XINST " +cEol
cQuery += " FROM " + RetSqlName("SC5") + " C5 " +cEol
cQuery += "WHERE C5.C5_FILIAL = '"+ xFilial("SC5") +"' "                                                        +cEol
cQuery += "  AND C5.C5_NOTA   = '        ' "                                                                    +cEol
cQuery += "  AND C5.C5_TRANSP <> '      ' "                                                                     +cEol
cQuery += "  AND C5.C5_X_FATAU = 'S' "                                                                          +cEol
cQuery += "  AND C5.D_E_L_E_T_ = ' ' "                                                                          +cEol
cQuery += "ORDER BY C5.C5_FILIAL, C5.C5_NUM"

TCQUERY cQuery NEW ALIAS "work"
dbSelectArea("work")
dbgoTop()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณJEAN - 22/07/14 - Valida se o retorno da consulta for nulo  
//ณMailson - 02/11/14 - incluidos campos TID, AUTO e INST   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

If work->(EOF())
	work->(DbCloseArea())
	Return Nil
Else
	While work->(!EOF())
		aAdd(aPedidos, {work->c5_filial,;      // 01 Filial
		work->c5_num,;                         // 02 N๚mero do Pedido
		work->c5_cliente,;                     // 03 Cliente
		work->c5_lojacli})	                   // 07 Inst			
		work->(DbSkip())
	EndDo
	work->(DbCloseArea())
EndIf

for nX := 1 to Len(aPedidos)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJEAN 23/07/14 - INICIA ROTINA PARA RETORNAR ITENS DO PEDIDOณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	aItPed := fGetItPed(aPedidos[nX])
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJEAN - 22/07/14 - INICIA VALIDAวรO DE BLOQUEIOS DO PEDIDOณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	lContinua := fAvBlqPed(aItPed)
	
	if !lContinua
		Loop
	EndIf
	
	DBSelectArea("SC5")
	SC5->(DBSetOrder(1))
	SC5->(DBSeek(xFilial("SC5")+aPedidos[nX, 02]))
	
	DBSelectArea("SC6")
	SC6->(DBSetOrder(1))
	SC6->(DBSeek(xFilial("SC6")+aPedidos[nX, 02]))

	
	While SC6->(!EOF()) .And. SC6->C6_FILIAL == cFilAnt .And. SC6->C6_NUM == SC5->C5_NUM
		
		SC9->(DbSetOrder(1))
		SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM
		
		SE4->(DbSetOrder(1))
		SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO
		
		SB1->(DbSetOrder(1))
		SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO
		
		SB2->(DbSetOrder(1))
		SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL
		
		SF4->(DbSetOrder(1))
		SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
		
		nPrcVen := SC9->C9_PRCVEN
		If ( SC5->C5_MOEDA <> 1 )
			nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
		EndIf
		
		Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
		SC9->C9_ITEM,;
		SC9->C9_SEQUEN,;
		SC9->C9_QTDLIB,;
		nPrcVen,;
		SC9->C9_PRODUTO,;
		.F.,;
		SC9->(RecNo()),;
		SC5->(RecNo()),;
		SC6->(RecNo()),;
		SE4->(RecNo()),;
		SB1->(RecNo()),;
		SB2->(RecNo()),;
		SF4->(RecNo()),;
		SB2->B2_LOCAL,;
		0,;
		SC9->C9_QTDLIB2})
		
		SC6->(DbSkip())
	EndDo
	
	If Len(aPvlNfs) > 0
		
		DBSelectArea("SC9")
		ConOut("FATAUTO - INICIANDO FATURAMENTO DO PEDIDO "+ Trim(SC5->C5_NUM))
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณChamada da fun็ใo padrใo para fatura	mento do pedidoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		Pergunte("MT460A",.F.)
		cNota := MaPvlNfs(aPvlNfs,cSerie, .F., .F., .F., .T., .F., 0, 0, .F.,.F.)
		
		If !Empty(cNota)
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ8ฟ
			//ณJEAN - 23/07/14 - VALIDANDO EXISTENCIA DA NFณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ8ู
			
			Sleep(1000)
			
			DBSelectArea("SF2")
			SF2->(DBSetOrder(1))
			if !DbSeek(xFilial("SF2") + cNota + cSerie)
				aAdd(aErros, "ERRO AO TENTAR FATURAR O PEDIDO "+ aPedidos[nX, 02] +" ==> NUMERACAO DE NOTA ("+ cNota +") PODE TER SIDO INUTILIZADA.")
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณJEAN - 23/07/14 - AVALIA SE A NOTA FICOU VINCULADA A ALGUM PEDIDO NA C9ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				DBSelectArea("SC9")
				SC9->(DbSetOrder(1))
				if DbSeek(xFilial("SC9") + aPedidos[nX, 02])
					While SC9->(!EOF()) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == aPedidos[nX, 02]
						
						if SC9->C9_NFISCAL == cNota
							RecLock("SC9", .F.)
							SC9->C9_NFISCAL := " "
							SC9->C9_SERIENF := " "
							SC9->(MsUnlock())
						EndIf
						
						SC9->(DbSkip())
					EndDo
				EndIf
				
				Loop
				
			EndIf
			
			cTssOk := U_RetTssOk()
			If Empty(cTssOk)
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณChamada da fun็ใo responsแvel pela transmissใo da notaณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				
				ConOut("FATAUTO - INICIANDO TRANSMISSAO DA NOTA "+ Trim(cNota))
				NfeTrans(cNota,cNota,cSerie,"SF2",.F.)
			Else
				
				ConOut("FATAUTO - ERRO AO TENTAR TRANSMITIR NOTA "+ Trim(cNota))
				aAdd(aErros, "ERRO AO TENTAR TRANSMITIR NOTA "+ Trim(cNota) +" ==> SERVIวO DE TRANSMISSAO PAROU ("+ cTssOk +")")
				
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณChamada da fun็ใo para grava็ใo de dados na tabela ZB9 - NFs para gerar boletosณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			ConOut("FATAUTO - GRAVANDO DADOS DA NOTA "+ Trim(cNota) +" PARA POSTERIOR IMPRESSAO DOS BOLETOS")
			GrvInfNf(aPedidos[nX, 03],	aPedidos[nX, 04], CNOTA, CSERIE)
			
		EndIf
		
	EndIf
	
	aPvlNfs := {}
	cNota   := ""
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤAฟ
	//ณMarca  o danfe como "impresso"ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤAู
	
	DBSelectArea("SF2")
	RecLock("SF2",.F.)
	SF2->F2_FIMP := "S"
	MsUnlock()
	
Next nX

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณVerifica se ainda existe a tabela temporแria para finalizแ-la.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If Select("work") != 0
	work->( DbCloseArea() )
EndIf

fAvalErros()

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvInfNf    บAutor  ณMicrosiga         บ Data ณ  21/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel pela grava็ใo das informa็๕es de notas  บฑฑ
ฑฑบ          ณ na tabela ZB9 (Temp. para gera็ใo de boletos)              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATAUTO                                                    บฑฑ  
ฑฑณMailson - 02/11/14 - incluidos campos TID, AUTO e INST   			  ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvInfNf(cCliente, cLoja, cDoc, cSerie)

DbSelectArea("ZB9")
DbSetOrder(1)

RecLock("ZB9", .T.)
ZB9->ZB9_FILIAL := xFilial("ZB9")
ZB9->ZB9_CODEMP := cEmpAnt
ZB9->ZB9_CODFIL := cFilAnt
ZB9->ZB9_CODCLI := cCliente
ZB9->ZB9_CODLOJ := cLoja
ZB9->ZB9_NUMDOC := cDoc
ZB9->ZB9_SERIE  := cSerie
ZB9->ZB9_OK     := "2"    
ZB9->(MsUnlock())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNOVO2     บAutor  ณMicrosiga           บ Data ณ  28-03-12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de transmissao da nfe                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function NfeTrans(cNfIni,cNfFim,cSerie,pTipoES,lCanc)

Local cURL        := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local aArea       := GetArea()
Local cNotaIni    := ""
Local cNotaFim    := ""
Local lCTe        := .F.
Local lRetorno    := .F.
Local cModalidade	:= ""
Local cVersao		  := ""
Local _cChave     := ""

Local cConSped := SuperGetMV("MV_X_SCON", , '{"ORACLE/NFE","192.168.220.201",7892}') //Producao
Local aConSped := &cConSped

cNfIni:=Padr(cNfIni,TamSx3("F2_DOC")[1])
cSerie:=Padr(cSerie,TamSx3("F2_SERIE")[1])
_cChave:=cNfIni+cSerie

cSerie   := cSerie
cNotaIni := cNfIni
cNotaFim := cNfIni

dbselectarea("SF2")
dbsetorder(1)
IF !dbseek(xFilial("SF2")+_cChave)
	ConOut("Documento nใo localizado")
	Return .F.
Endif

aArea    := GetArea()

dbselectarea("SD2")
dbsetorder(1)
dbseek(xFilial("SD2")+_cChave)

cIdEnt := GetIdEnt()

If !Empty(cIdEnt)
	
	cAmbiente:= "1-Produ็ใo"
	cModalidade:="1-Normal"
	//cVersao:="2.00"
	cVersao := "3.10"
	
	If !Empty(cModalidade) .AND. !Empty(cVersao)
		_cTT := SpedNFeTrf(aArea[1],cSerie,cNotaIni,cNotaFim,cIdEnt,cAmbiente,cModalidade,cVersao,.T., lCTe, .T.)
		
	EndIf
	
EndIf

RestArea(aArea)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetIdEnt   บAutor			     บ Data ณ  17/04/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRecupera o numero do indentificador da filial				  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetIdEnt()
Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณObtem o codigo da entidade                                              ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := SM0->M0_NOME
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
If oWs:ADMEMPRESAS()
	cIdEnt  := oWs:cADMEMPRESASRESULT
Else
	Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"Identidade"},3)
	//Enviar email de conting๊ncia quanto a transmissใo
EndIf

RestArea(aArea)

Return(cIdEnt)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMAILCPX    บAutor  ณMicrosiga           บ Data ณ  21/05/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo chamada para fazer envio do workflow contendo o     บฑฑ
ฑฑบ          ณ boleto bancแrio do cliente.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MailCPX(aFiles,cCliente,cNumNota,cSerieNF,cCGCCli)

Local cTo := ""
Local cCC := ""

Local oProcess
Local oHtml
     
Conout("FATAUTO - INICIANDO ENVIO DE E-MAIL PARA CLIENTE")

If !Empty(ALLTRIM(Posicione("SA1",3,xFilial("SA1")+cCGCCli,"A1_NOME")))
	cTo := ALLTRIM(Posicione("SA1",3,xFilial("SA1")+cCGCCli,"A1_EMAIL"))
	cCC := U_RETZX5()
else
	cTo:= ALLTRIM(Posicione("SA2",3,xFilial("SA2")+cCGCCli,"A2_EMAIL"))
endif

If Empty(cTo)
	ConOut("Email nใo enviado,email cliente vazio")
	RETURN .F.
ENDIF

oProcess := TWFProcess():New("FATAUTO",OemToAnsi("Boleto"))
oProcess:NewTask("FATAUTO","\workflow\wffatcpx.htm")
oProcess:cSubject := OemToAnsi(Upper(AllTrim(SubStr(SM0->M0_NOMECOM, 01, 30)))+" NF-e: "+ALLTRIM(cNumNota)+"/"+ALLTRIM(cSerieNF))

For nCtrl := 1 to Len(aFiles)
	oProcess:AttachFile(aFiles[nCtrl, 01])
Next nCtrl

oProcess:cTo := cTo
oProcess:cCC := cCC

oHTML:= oProcess:oHTML

oHtml:ValByName("DATA"   ,DTOC(dDataBase))
oHtml:ValByName("EMP"    ,ALLTRIM(SM0->M0_NOMECOM) + " - " + SM0->M0_FILIAL)
oHtml:ValByName("CLIFORN",ALLTRIM(cCliente))
oHtml:ValByName("NOTA"   ,AllTrim(cSerieNF) + " - " + cNumNota)

oProcess:Start()
oProcess:Finish()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRETZX5    บAutor  ณMicrosiga           บ Data ณ  26/05/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ RETORNA EMAILS DO FATURAMENTO                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------*
User Function RETZX5()
*-----------------------*
Local cRet := ""
Local cSQL := ""
                
cSQL := "select zx5_email from "+ RetSqlName("ZX5") + " zx5 "
cSQL += "where zx5_filial = '"+ xFilial("ZX5") +"' "
cSQL += "  and d_e_l_e_t_ = ' ' "

TCQUERY cSQL NEW ALIAS "zx5fil" 

DbSelectArea("zx5fil")
zx5fil->(DbGoTop())

If !zx5fil->(EOF())
	If !Empty(zx5fil->zx5_email)
		cRet := zx5fil->zx5_email
	Else
		ConOut("RETZX5 - ENDERECO DE EMAIL NAO ENCONTRADO PARA FILIAL "+ xFilial("ZX5"))
	EndIf	
EndIf

zx5fil->(DBCloseArea())

Return cRet                                                

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAvBlqPed    บAutor  ณJean Carlos Saggin บ Data ณ  22/07/14 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel pelas valida็๕es de bloqueios nos       บฑฑ
ฑฑบ          ณ pedidos de vendas.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAvBlqPed(aItens)

Local lRet    := .T.
Local i       := 0
Local aMsgBlq := {}
Local lNaoAva := .F.
Local lBlqFin := .F.
Local lBlqEst := .F.
Local lBlqWMS := .F.

for i := 1 to Len(aItens)
	
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	if DbSeek(aItens[i, 01] + aItens[i, 02] + aItens[i, 03])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณJEAN - 23/07/14 - AVALIA MOTIVOS DE BLOQUEIO FINANCEIROณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		Do Case
			Case SC9->C9_BLCRED == '01'
				lBlqFin := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" ESTA COM 'BLOQUEIO DE CREDITO POR VALOR(01)'")
				
			Case SC9->C9_BLCRED == '04'
				lBlqFin := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" BLOQUEOU PORQUE 'A DATA DO LIMITE DE CREDITO DO CLIENTE VENCEU(04)'")
				
			Case SC9->C9_BLCRED == '05'
				lBlqFin := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" ESTA COM 'BLOQUEIO DE CREDITO POR ESTORNO(05)'")
				
			Case SC9->C9_BLCRED == '06'
				lBlqFin := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" ESTA COM 'BLOQUEIO DE CREDITO POR RISCO(06)'")
				
			Case SC9->C9_BLCRED == '09'
				lBlqFin := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" BLOQUEOU PORQUE 'O CREDITO FOI REJEITADO MANUALMENTE(09)'")
		EndCase
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณJEAN - 23/07/14 - AVALIA MOTIVOS DE BLOQUEIO DE ESTOQUEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		
		Do Case
			Case SC9->C9_BLEST == '02'
				lBlqEst := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" BLOQUEOU POR 'ESTOQUE(02)'")
				
			Case SC9->C9_BLEST == '03'
				lBlqEst := .T.
				aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" FOI 'BLOQUEADO MANUALMENTE POR ESTOQUE(03)'")
		EndCase
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ€
		//ณJEAN - 23/07/14 - AVALIA MOTIVOS DE BLOQUEIO DE WMSณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ€
		
		if SC9->C9_BLWMS $ ("01/02/03/05/06/07")
			lBlqWMS := .T.
			aAdd(aMsgBlq, "PED. "+ aItens[i, 02] +" ==> PRODUTO "+ aItens[i, 04] +" NA LINHA "+ aItens[i, 03] +" FOI 'BLOQUEADO POR WMS("+SC9->C9_BLWMS+")'")
		EndIf
		
	Else
		lNaoAva := .T.
		lRet    := .F.
	EndIf
	
Next i

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua chamada da rotina de "Libera็ใo de Pedido"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if lNaoAva
	
	DBSelectArea("SC5")
	SC5->(dbSetOrder(1))
	
	If SC5->(dbSeek(aItens[01, 01] + aItens[01, 02]))
		
		ConOut("FATAUTO - CHAMANDO ROTINA DE LIBERACAO DO PEDIDO "+ aItens[01, 02])
		aPvlNfs    := {}
		aRegistros := {}
		aBloqueio  := {{"","","","","","","",""}}
		
		Ma410LbNfs(2,@aPvlNfs,@aBloqueio)
		Ma410LbNfs(1,@aPvlNfs,@aBloqueio)
		
	EndIf
	
EndIf

if lBlqFin .or. lBlqEst .or. lBlqWMS
	lRet := .F.
	for j := 1 to Len(aMsgBlq)
		aAdd(aErros, aMsgBlq[j])
	Next j
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetItPed  บAutor  ณJean Carlos Saggin บ Data ณ  22/07/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por retornar os itens do pedido         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGetItPed(aPed)
Local aRet := {}

DbSelectArea("SC6")
SC6->(DbSetOrder(1))
if SC6->(DbSeek(aPed[01] + aPed[02]))
	
	While !SC6->(EOF()) .and. (SC6->C6_FILIAL + SC6->C6_NUM == aPed[01] + aPed[02])
		aAdd(aRet, {SC6->C6_FILIAL,;           // 01 Filial
		SC6->C6_NUM,;               // 02 N๚mero do Pedido
		SC6->C6_ITEM,;              // Sequencial da Linha do Pedido
		SC6->C6_PRODUTO,;           // C๓digo do Produto
		SC6->C6_LOCAL,;             // C๓digo do Armaz้m
		SC6->C6_TES})               // TES de Saํda
		SC6->(DbSkip())
	EndDo
	
EndIf

Return (aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRetTssOk   บAutor  ณMicrosiga           บ Data ณ  13/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que avalia disponibilidade do servi็o de TSS.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATAUTO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------*
User Function RetTssOk()
*-------------------------*
Local aArea  := GetArea()
Local cIdEnt := ""
Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
Local oWs
Local cRet   := " "
Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
                                 
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณObtem o codigo da entidade
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

oWS := WsSPEDAdm():New()
oWS:cUSERTOKEN := "TOTVS"

oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")
oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM
oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
oWS:oWSEMPRESA:cCEP_CP     := Nil
oWS:oWSEMPRESA:cCP         := Nil
oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
oWS:oWSEMPRESA:cINDSITESP  := ""
oWS:oWSEMPRESA:cID_MATRIZ  := ""
oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"

If oWs:ADMEMPRESAS()
	cIdEnt := oWs:cADMEMPRESASRESULT
Else
	cRet := IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3))
EndIf

RestArea(aArea)

Return cRet

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณFun็ใo responsแvel por fazer todo o processo de gera็ใo dos boletosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

*------------------------*
User Function FPROCBOL()
*------------------------*

Local cSql    := ""
Local cEmpIni := "01"         // Empresa pela qual a rotina vai acessar o sistema
Local cFilIni := "01"         // Filial pela qual a rotina vai acessar o sistema
Local aEmpFil := {}           // Empresas e filiais que tem boleto para serem processados
Local nX      := 0            // Variแvel controladora do loop de processamento das empresas e filiais
Local aFiles  := {}
Local aEmail  := {}
Local nDoc    := 0            // Variแvel de controle do la็o do for para os n๚meros de documentos

Private aErros      := {}
Private cAutoriza   := ""
Private cCodAutDPEC := ""
Private cEntidade   := ""
Private cFileXML    := ""
Private aFileDnf    := {}
Private aNota       := {}
Private aXml        := {}
Private cModalidade := ""
Private aDocumento  := {}
     
ConOut("BOLAUTO - INICIANDO ROTINA DE GERACAO DE BOLETOS AUTOMATICA")

RpcClearEnv()
RPCSETTYPE(3)
PREPARE ENVIRONMENT EMPRESA cEmpIni FILIAL cFilIni MODULO "FIN" TABLES "ZB9"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณCria็ใo de arquivo temporแrio sobre a execu็ใo da rotina, devido a execu็ใo N vezes pelo schedule decorrente das threadsณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

nLock := 0
While !LockByName("BOLAUTO",.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)
	If nLock > 10
		ConOut("CONTROLE DE SEMAFORO - BOLAUTO JA SE ENCONTRA EM EXECUCAO!")
		Return
	EndIf
EndDo

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณAvalia se conseguiu se posicionar na empresa e filial...ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if Empty(cEmpAnt)
	ConOut("BOLAUTO - NรO FOI POSSอVEL ABRIR A ROTINA DE GERACAO DE BOLETOS AUTOMATICA")
	aAdd(aErros, "GERACAO DE BOL. AUTOMATICA ==> NรO FOI POSSอVEL INICIAR O PROCESSAMENTO. ACIONE O T.I. IMEDIATAMENTE!")
	fAvalErros()
	Return Nil
EndIf

cSql := "SELECT DISTINCT ZB9.ZB9_CODEMP, ZB9.ZB9_CODFIL FROM "+ RetSqlName("ZB9") +" ZB9 "
cSql += "WHERE ZB9.ZB9_FILIAL = '"+ xFilial("ZB9") +"' "
cSql += "  AND ZB9.ZB9_OK     = '2' "
cSql += "  AND ZB9.D_E_L_E_T_ = ' ' "
cSql += "GROUP BY ZB9.ZB9_CODEMP, ZB9.ZB9_CODFIL "

cSql := ChangeQuery(cSql)

TCQUERY cSql NEW ALIAS "ZB9TMP"

DbSelectArea("ZB9TMP")
ZB9TMP->(DbGoTop())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se encontrou algum boleto para ser gerado.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if ZB9TMP->(EOF())
	ConOut("BOLAUTO - NAO HA BOLETOS PARA SEREM GERADOS!")
	ZB9TMP->(DbCloseArea())
	Return
EndIf

While !ZB9TMP->(EOF())
	aAdd(aEmpFil, {ZB9TMP->ZB9_CODEMP, ZB9TMP->ZB9_CODFIL})
	ZB9TMP->(DbSkip())
EndDo

ZB9TMP->(DbCloseArea())

For nX := 1 to Len(aEmpFil)
	
	if aEmpFil[nX, 01] != cEmpAnt .or. aEmpFil[nX, 02] != cFilAnt
		
		fAvalErros()
		
		RpcClearEnv()
		RPCSETTYPE(3)
		PREPARE ENVIRONMENT EMPRESA aEmpFil[nX, 01] FILIAL aEmpFil[nX, 02] MODULO "FIN" TABLES "ZB9"
		
	EndIf
	
	cEntidade := GetIdEnt()
	
	ConOut("BOLAUTO - INICIANDO PROCESSAMENTO NA EMPRESA "+ cEmpAnt +" FILIAL "+ cFilAnt)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFaz o loop na tabela ZB9 chamando a rotina de impressใo de boletos.ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	DbSelectArea("ZB9")
	ZB9->(DbSetOrder(2))
	If ZB9->(DbSeek(xFilial("ZB9") + cEmpAnt + cFilAnt + '2'))
		aDocumento := {}  
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
		//ณEstrutura aDocumentoณ
		//ณ[01] Documento      ณ
		//ณ[02] Serie          ณ
		//ณ[03] Cliente        ณ
		//ณ[04] Loja           ณ
		//ณ[05] Recno          ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ู  
		
		While !ZB9->(EOF()) .and. (xFilial("ZB9") + cEmpAnt + cFilAnt + '2' == ZB9->ZB9_FILIAL + ZB9->ZB9_CODEMP + ZB9->ZB9_CODFIL + ZB9->ZB9_OK)
			aAdd(aDocumento, {ZB9->ZB9_NUMDOC,; 
							  ZB9->ZB9_SERIE,; 
							  ZB9->ZB9_CODCLI,; 
							  ZB9->ZB9_CODLOJ,; 
							  ZB9->(Recno())})
			ZB9->(DbSkip())	
		EndDo
	EndIf	
	
	if Len(aDocumento) > 0
		For nDoc := 1 to Len(aDocumento)
		
			ConOut("BOLAUTO - PROCESSANDO DOCUMENTO "+ aDocumento[nDoc][01] +" SERIE "+ aDocumento[nDoc][02])

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณAvalia se o documento foi excluํdo na F2 para finalizar processo na ZB9ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			DbSelectArea("SF2")
			SF2->(DBSetOrder(1))
			If !SF2->(DbSeek(xFilial("SF2") + aDocumento[nDoc][01] + aDocumento[nDoc][02]))
				
				fGrvStatus(aDocumento[nDoc][05], '1', "")
				
				aAdd(aErros, "BOLAUTO - NF-e "+ aDocumento[nDoc][01] +" SERIE "+ aDocumento[nDoc][02] +" ==> DOCUMENTO EXCLUIDO! ")
				
				Loop
				
			EndIf
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณJEAN - 08/09/14 - AVALIA SE FOI AUTORIZADO EMISSรO DO DANFEณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			lAutoriza := fAvalNFe(aDocumento[nDoc][02], aDocumento[nDoc][01])
			
			if !lAutoriza
				ConOut("BOLAUTO - NF-e "+ aDocumento[nDoc][01] +" SERIE "+ aDocumento[nDoc][02] +" AINDA NAO HOMOLOGADA PELA SEFAZ! ")
				aAdd(aErros, "BOLAUTO - NF-e "+ aDocumento[nDoc][01] +" SERIE "+ aDocumento[nDoc][02] +" ==> SE ESSA NOTIFICACAO FOR REINCIDENTE, RETRANSMITA O DOCUMENTO! ")
				Loop
			EndIf
			
			aFileDnf := fProcDnf(aDocumento[nDoc][02], aDocumento[nDoc][01])
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณSele็ใo do banco para o processo de gera็ใo do boleto.ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			
			cQuery := "SELECT * FROM " + RetSqlName("ZX6") + ;
			" WHERE ZX6_LIMITE > ZX6_VALUSO AND D_E_L_E_T_ <> '*'" + ;
			" ORDER BY ZX6_PRIOR"
			
			cQuery := ChangeQuery(cQuery)
			
			TCQUERY cQuery NEW ALIAS "WORKZX6"
			dbSelectArea("WORKZX6")
			dbgoTop()
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณJEAN - 27/07/14 - Valida se o retorno da consulta nใo foi uma tabela vaziaณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			if WORKZX6->(EOF())
				WORKZX6->( DbCloseArea() )
				aAdd(aErros, "NOTA: "+ aDocumento[nDoc][01] +" ==> NAO HA BANCOS NO CADASTRO DE PRIORIDADES PARA EMISSAO DOS BOLETOS!")
				Loop
			EndIf
			
			lImprimiu := .F.
			lFim      := .F.
			
			While !WORKZX6->(EOF()) .and. !lImprimiu .and. !lFim
				
				aTmp := {}
				Conout("BOLAUTO - INICIANDO IMPRESSAO DE BOLETOS REFERENTE A NOTA "+ Trim(aDocumento[nDoc][01]))
				
				DbSelectArea("SE1")
				SE1->(DbSetOrder(1))
				if DBSeek(xFilial("SE1") +aDocumento[nDoc][02] + aDocumento[nDoc][01])

					If !Empty(SE1->E1_NUMBCO)
						lImprimiu := .T.
					Else
						aTmp := U_BOLETOS(aDocumento[nDoc][03],	aDocumento[nDoc][04], aDocumento[nDoc][01], aDocumento[nDoc][02], WORKZX6->ZX6_BANCO,WORKZX6->ZX6_AGEN, WORKZX6->ZX6_CONTA, "001",.T.)
					EndIf 
					
				Else
					aTmp := U_BOLETOS(aDocumento[nDoc][03],	aDocumento[nDoc][04], aDocumento[nDoc][01], aDocumento[nDoc][02], WORKZX6->ZX6_BANCO,WORKZX6->ZX6_AGEN, WORKZX6->ZX6_CONTA, "001",.T.)
				EndIf   
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณInicializa็ใo de variแveis totalizadoras das empresas 30 e 31ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤbฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				nTot := 0
				
				If Len(aTmp) == 0
					
					fGrvStatus(aDocumento[nDoc][05], '1', "")
					
					lImprimiu := .T.
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSomar titulos ja emitidos na empresa 30 na data do faturamentoณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					cQuery := ""
					cQuery := "SELECT SUM(E1_VALOR) AS VALOR FROM "+ RetSqlName("SE1") +" "
					cQuery += "WHERE E1_PORTADO = '"+WORKZX6->ZX6_BANCO+"' AND E1_AGEDEP = '"+WORKZX6->ZX6_AGEN+"' AND E1_CONTA ='"+WORKZX6->ZX6_CONTA+"'"
					cQuery += " AND D_E_L_E_T_  = ' '   AND E1_EMISSAO = '" + DtoS(dDataBase) + "'"
					cQuery := ChangeQuery(cQuery)
					
					If Select("WORKE131") != 0
						WORKE131->( DbCloseArea() )
					EndIf
					
					TCQUERY cQuery NEW ALIAS "WORKE131"
					nTot:= WORKE131->VALOR
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณupdate no saldo da ZX6ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					DBSelectArea("ZX6")
					ZX6->(dbgoTo(WORKZX6->R_E_C_N_O_))
					
					RECLOCK("ZX6",.F.)
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณSomar o valor faturado da nota mais o que ja foi emitido para este portador nesta dataณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					ZX6->ZX6_VALUSO := nTot
					
					ZX6->(MsUnlock())
					
				Else
					
					aFiles := {}
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณJEAN - 10/09/14 - VALIDA SE ARQUIVO EXISTE ANTES DE ADICIONAR ภ VARIมVEL AFILESณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					if File(cFileXML)
						aAdd(aFiles, {cFileXML})
					EndIf
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณJEAN - 10/09/14 - VALIDA SE ARQUIVO EXISTE ANTES DE ADICIONAR ภ VARIมVEL AFILESณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					If File(aFileDnf[01] + aFileDnf[02])
						if CpyT2S(aFileDnf[01] + aFileDnf[02], CDIRSRV, .F.)
							aAdd(aFiles, {CDIRSRV + aFileDnf[02]})
						EndIf
					EndIf
					
					if Len(aFiles) > 0
						aEmail := {}
						
						aAdd(aEmail, {Upper(AllTrim(SubStr(Posicione("SA1",1, xFilial("SA1") + aDocumento[nDoc][03] + aDocumento[nDoc][04], "A1_NOME"),01,30))),;
						Posicione("SA1",1, xFilial("SA1") + aDocumento[nDoc][03] + aDocumento[nDoc][04], "A1_CGC"),;
						aDocumento[nDoc][01],;
						aDocumento[nDoc][02]})
						
						If Len(aEmail) > 0
							U_MailCPX(aFiles,aEmail[01,01],aEmail[01,03],aEmail[01,04],aEmail[01,02])
						Endif
					EndIf
					
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณAtribui เ variแvel aErros os erros retornados pela rotina de emissใo de boletos.ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					cErros := ""
					
					for nY := 1 to Len(aTmp)
						aAdd(aErros, aTmp[nY])
						cErros += aTmp[nY] + CHR(13)+CHR(10)
					Next nY
					
					fGrvStatus(aDocumento[nDoc][05], '1', AnsiToOem(cErros))
					
				EndIf
				
				WORKZX6->(DbSkip())
				
			EndDo
			
			WORKZX6->( DbCloseArea() )
			
			if !lImprimiu
				aAdd(aErros, "BOLETOS REFERENTE A NOTA "+ Trim(aDocumento[nDoc][01])+" NAO PUDERAM SER IMPRESSOS!")
			EndIf

		Next nDoc 
		
	EndIf
	
Next nX

fAvalErros()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณPosiciona o sistema na empresa que iniciou a execu็ใo da rotinaณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
RPCCLEARENV()
RPCSETTYPE(3)
PREPARE ENVIRONMENT EMPRESA (cEmpIni) FILIAL (cFilIni) MODULO "FIN"

ConOut("BOLAUTO - FIM DA EXECUCAO.")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAvalNFe   บAutor  ณJean Carlos Saggin บ Data ณ  08/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que retorna se o xml foi validado ou nใo na Sefaz   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAvalNFe(cSerie, cNumDoc)
Local lRet      := .F.
Local cFileTmp  := ""
Local cChaveNf	:= ""

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
If DbSeek(xFilial("SF2") + cNumDoc + cSerie)
	
	aNota := {}
	
	aAdd(aNota, .F.)
	aAdd(aNota, "S")
	aAdd(aNota, SF2->F2_EMISSAO)
	aAdd(aNota, cSerie)
	aAdd(aNota, cNumDoc)
	aAdd(aNota, SF2->F2_CLIENTE)
	aAdd(aNota, SF2->F2_LOJA)
	
	aNotas := {}
	aAdd(aNotas, aNota)
	cModalidade := "1"
	
	aXml := U_RJGetXML(cEntidade,aNotas,@cModalidade)
	
	cProtocolo := aXml[01][01]
	cRetorno   := aXml[01][02]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJEAN - 10/09/14 - cAutoriza - Variแvel privada que precisa ser alimentada para gera็ใo do danfe em .pdfณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cAutoriza   := cProtocolo
	cCodAutDPEC := aXml[01][05]
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do Nome do arquivo XMLณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cFileTmp := SubStr(NfeIdSPED(cRetorno,"Id"),4)
	if !Empty(cFileTmp)
		cFileName :=  cFileTmp + "-nfe.xml"
	Else
		cFileName := ""
		cFileTmp  := ""
		Return lRet
	EndIF
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAdiciona o layout do protocolo antes da tag xml da nfeณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cCabProt := '<?xml version="1.0" encoding="UTF-8"?>' + chr(13) + chr(10)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤLฟ
	//ณse a versao for 2.0 tem que mudar a tag, atualmente deixada fixaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤLู
	
	cCabProt += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="2.00">' + chr(13) + chr(10)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
	//ณGUILHERME 27-03-15 adicionado esse tratamento para que quando for passada mais de uma nota     ณ
	// o sistema nao continue tratando todas como autorizadas                                         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู
	If !Empty(alltrim(cAutoriza))
		cXml := GetXmlCLi(cSerie, cNumDoc, cEntidade) + chr(13) + chr(10)
	Else
		cXml := ""	
	EndIf
	
	if Empty(cXml)
		Return lRet
	Else
		If !Empty(cFileTmp)
			grvChave(cSerie, cNumDoc, cFileTmp) //Grava a chave	
		Else
			Conout("FATCPX - fAvalNFe - Chave nใo foi encontrada e nใo serแ preenchida na nota "+cNumDoc+" "+cSerie)
		EndIf
	EndIf
	
	cFinProt := "</nfeProc>"
	
	cRetorno := cRetorno + chr(13) + chr(10)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณmonta o xml com o cabecalho e finalizacao do protocolo de envio, mesmo sem o protocolo da nfe aindaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	cXmlEnv := cCabProt + cRetorno + cXml + cFinProt
	
	IF !ExistDir(CDIRSRV)
		MakeDir(CDIRSRV)
	EndIf
	
	cFile := CDIRSRV + cFileName
	nHdl := FCreate(cFile)
	fWrite(nHdl,cXmlEnv,Len(cXmlEnv))
	FClose(nHdl)
	
	cFileXML := cFile
	lRet     := .T.
	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetXmlCli   บAutor  ณJean Saggin       บ Data ณ  16/12/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que faz a busca do XML atrav้s do TSS               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------------------*
Static Function GetXmlCLi(cSerie, cNF, cIdent)
*--------------------------------------*
Local nConSped := 0
Local cXmlCli := ""
Local cConSped := SuperGetMV("MV_X_SCON", , '{"ORACLE/NFE","192.168.220.5",7891}') //Producao
Local aConSped := &cConSped
Local cSql := ""
Local cNfSerie := PadL(cSerie, TAMSX3("F2_SERIE")[1]) + cNF
Local aArea := GetArea()
Local cTabela := "SPED054"
Local cAlias := "TMP"

TCConType("TCPIP")

nConSped  := TCLink(aConSped[1],aConSped[2],aConSped[3])

If nConSped < 0
	ConOut("Falha na conexใo TOPCONN para buscar o xml. Erro " + Alltrim(Str(nConSped)))
	TCUnLink(nConSped)
	break
	Return ""
Endif

TCSetConn(nConSped)

BeginSql Alias "TMP054"
	SELECT SPED054.R_E_C_N_O_ RNO FROM SPED054 LEFT JOIN SPED001 ON SPED054.ID_ENT = SPED001.ID_ENT
	WHERE sped001.id_ent = %EXP:cIdent% AND NFE_ID = %EXP:cNfSerie% AND CSTAT_SEFR = '100'
	ORDER BY LOTE DESC
EndSql

dbSelectArea("TMP054")

nRec := TMP054->RNO

TMP054->(dbCloseArea())

Use &(cTabela) ALIAS &(cAlias) SHARED NEW VIA "TOPCONN"

if Select(cAlias) > 0
	
	dbSelectArea("TMP")
	
	TMP->(dbGoTo(nRec))
	
	cXmlCli := TMP->XML_PROT
	
	TMP->(dbCloseArea())
EndIf

TCUnLink(nConSped)

RestArea(aArea)

Return cXmlCli

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcDnf  บAutor  ณJean Carlos Saggin  บ Data ณ  10/09/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que serแ responsแvel por fazer a impressใo do danfe บฑฑ
ฑฑบ          ณ em formato .pdf                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fProcDnf(cSerie, cNumDoc)

Local cEmail    := ""
Local aEnv      := {aNota[4], aNota[5], aNota[6], aNota[7], aNota[2], aXml[1]}
Local aParam    := {cNumDoc, cNumDoc, cSerie, 1, 2}
Local cFilePDF  := ""
Local cNum      := aEnv[2]
Local cSerie    := aEnv[1]
Local oDanfePDF

Private lInJob  := .T.

cAviso   := ""
cErro    := ""

oNfe     := XmlParser(aEnv[6][2],"_",@cAviso,@cErro)
oNfeDPEC := XmlParser(aEnv[6][4],"_",@cAviso,@cErro)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณJEAN 11/09/14 Seta os parโmetros que sใo usados na impressใo da danfeณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

if !Empty(aParam)
	For nX := 1 to len(aParam)
		cPar := "MV_PAR" + StrZero(nX, 2)
		&cPar := aParam[nX]
	Next nX
EndIf

lAdjustToLegacy := .F.
lDisableSetup   := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
//ณJEAN 11/09/14 INSTANCIA A CLASSE FWMSPRINTER PARA IMPRESSAO DO DANFEณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู

oDanfePDF := FWMsPrinter():New(cEmpAnt + cFilAnt + Trim(cSerie) + Trim(cNum) + ".rel", IMP_PDF, lAdjustToLegacy, , lDisableSetup, , , , .F., , .F. )

oDanfePDF:SetResolution(78) // Tamanho estipulado para a Danfe
oDanfePDF:SetPortrait()
oDanfePDF:SetPaperSize(DMPAPER_A4)
oDanfePDF:SetMargin(60,60,60,60)

Private PixelX := oDanfePDF:nLogPixelX()
Private PixelY := oDanfePDF:nLogPixelY()
Private nConsNeg := 0.4 // Constante para concertar o cแlculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.5 // Constante para concertar o cแlculo retornado pelo GetTextWidth.

U_ImpDet(@oDanfePDF,oNfe,cAutoriza,cModalidade,oNfeDPEC,cCodAutDPEC,aXml[1, 6],aXml[1, 7],aNota)

oDanfePDF:SetDevice(IMP_PDF)
oDanfePDF:cPathPDF := CDIRLOC
oDanfePDF:SetDevice(IMP_PDF)
oDanfePDF:SetViewPDF(.F.)

oDanfePDF:Print()

cFileName := Substr(oDanfePDF:cFileName, 1, Len(oDanfePDF:cFileName) - 4) + ".pdf"

aDoc := {}
aAdd(aDoc, oDanfePDF:cPathPDF)
aAdd(aDoc, cFileName)

FreeObj(oDanfePDF)
oDanfePDF := Nil

Return aDoc

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPฟ
//ณGUILHERME 16/01/15 GRAVAR CHAVE DA NOTA NAS TABELAS SF2,SF3,SFT      ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤPู
Static Function grvChave(cSerie, cNumDoc, cChaveNf)
	
	Local cOper		 := "S" //Notas de Saida. 

	DbSelectArea("SF2")
	DbSetOrder(1)
	If DbSeek(xFilial("SF2")+cNumDoc+cSerie)
		RecLock("SF2", .F.)
			SF2->F2_CHVNFE := cChaveNf
		MsUnlock("SF2") 	
	Else
		Conout("FATCPX - GRVCHV - Nota/Serie "+cNumDoc+"/"+cSerie+" Nใo encontrada na SF2")
	EndIf 
	
	DbSelectArea("SF3")
	DbSetOrder(6)
	If DbSeek(xFilial("SF3")+cNumDoc+cSerie)
		While (SF3->F3_FILIAL+SF3->F3_NFISCAL+SF3->F3_SERIE == xFilial("SF3")+cNumDoc+cSerie)
			RecLock("SF3", .F.)
				SF3->F3_CHVNFE := cChaveNf
			MsUnlock("SF3")
			
			SF3->(DbSkip()) 	
		End Do  
	EndIf
	
	DbSelectArea("SFT")
	DbSetOrder(6)
	If DbSeek(xFilial("SFT")+cOper+cNumDoc+cSerie)	
		While (SFT->FT_FILIAL+SFT->FT_TIPOMOV+SFT->FT_NFISCAL+SFT->FT_SERIE == xFilial("SFT")+cOper+cNumDoc+cSerie)			
			RecLock("SFT", .F.)
				SFT->FT_CHVNFE := cChaveNf
			MsUnlock("SFT") 
			
			SFT->(DbSkip())			
		End Do
	EndIf	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvStatus บAutor  ณJean Carlos Saggin บ Data ณ  24/03/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para gravar status na tabela ZB9                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FATCPX                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGrvStatus(nRecno, cStatus, cLog)

Local aArea := GetArea()

DbSelectArea("ZB9")
ZB9->(DbGoTo(nRecno))

RecLock("ZB9", .F.)
ZB9->ZB9_OK  := cStatus
ZB9->ZB9_LOG := cLog
ZB9->(MsUnlock())

RestArea(aArea)

Return     