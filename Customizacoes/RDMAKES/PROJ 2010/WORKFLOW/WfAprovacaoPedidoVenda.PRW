#include "rwmake.ch"
#include "tbiconn.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TOPCONN.CH"
             
// Job para ser executado via workflow
User Function WfCrPVda(cNewEmp, cNewFil)
StartJob("U_wfblcred",GetEnvServer(), .T.,cNewEmp, cNewFil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

User function wfblcred(cEmp, cFil)
Local 	cSql		:= "" 
//Local cEmpOld := cEmpAnt
//Local cFilOld := cFilAnt
Private _cFil 		:= ""
Private _cVend		:= ""
Private _cCli		:= ""
Private _cLoja		:= ""
Private _cPed		:= ""              
Private _cMail		:= ""
Private _cEmp		:= ""
Private _nValPed	:= 0
Private _nLimite	:= 0
Private _nObsCadas := ""         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !Empty(cEmp)
//	RpcClearEnv()
	RPCSetType(3)
	ConOut("Empresa Parametros : " + cEmp + " / " + cFil)
	Prepare Environment Empresa cEmp Filial cFil
	ConOut("Empresa Atual : " + cEmpAnt + " / " + cFilAnt)
EndIf
SC9->(DbSelectArea("SC9"))
cSql := "SELECT C5.C5_FILIAL, C5.C5_VEND1, C5.C5_X_CLVL,C9.C9_PEDIDO, C9.C9_CLIENTE, C9.C9_LOJA, A1.A1_LC, A1.A1_NOME, "
cSql += "A1.A1_MSALDO, A1.A1_VACUM, A1.A1_DTCADAS, A1.A1_DTNASC, A1.A1_CAPTSOC, C5.C5_CONDPAG, A1.A1_COD, A1.A1_LOJA, "
cSql += "Sum(C9.C9_QTDLIB*C9.C9_PRCVEN) AS VALOR " 
cSql += "FROM "+RetSqlname("SC5")+" C5, "+RetSqlname("SC9")+" C9, "+RetSqlname("SA1")+" A1 "
cSql += "WHERE C5.D_E_L_E_T_ <> '*' AND C9.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
cSql += "AND C5.C5_FILIAL = '"+xFilial("SC5")+"' AND C9.C9_FILIAL = '"+xFilial("SC9")+"' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
cSql += "AND A1.A1_COD = C5.C5_CLIENTE "
cSql += "AND A1.A1_LOJA = C5.C5_LOJACLI "
cSql += "AND C5.C5_FILIAL = C9.C9_FILIAL "
cSql += "AND C5.C5_CLIENTE = C9.C9_CLIENTE "
cSql += "AND C5.C5_LOJACLI = C9.C9_LOJA "
cSql += "AND C9.C9_PEDIDO = C5.C5_NUM "
// cSql += "AND C9.C9_BLCRED = '04' "
cSql += "AND C9.C9_BLCRED <> '"+Space(Len(SC9->C9_BLCRED))+"' "
cSql += "AND C9.C9_BLCRED <> '10' "
cSql += "AND C9.C9_X_ENVWF = ' ' "
cSql += "GROUP BY C5.C5_FILIAL,C5.C5_VEND1,C5.C5_X_CLVL, C9.C9_PEDIDO, C9.C9_CLIENTE,A1.A1_NOME,C9.C9_LOJA,A1.A1_LC, "  
cSql += "A1.A1_MSALDO, A1.A1_VACUM, A1.A1_DTCADAS, A1.A1_DTNASC, A1.A1_CAPTSOC, C5.C5_CONDPAG, A1.A1_COD, A1.A1_LOJA "
//MemoWrite("c:\sqlped.sql", cSql)

TCQUERY cSql NEW ALIAS "TMPSC9"
TMPSC9->(DbSelectArea("TMPSC9"))
TMPSC9->(DbGotop())


While !TMPSC9->(Eof())
	_cEmp		:= cEmpAnt
	_cFil 		:= TMPSC9->C5_FILIAL
	_cVend		:= TMPSC9->C5_VEND1
	ZZR->(DbSelectArea("ZZR"))
	ZZR->(DbSetOrder(1))
	ZZR->(DbGotop())
	If ZZR->(DbSeek(xFilial("ZZR")+TMPSC9->C5_X_CLVL))
		_cMail := AllTrim(ZZR->ZZR_EMAIL)
	Else
		TMPSC9->(DbSelectArea("TMPSC9"))
		TMPSC9->(DbSkip())
 		//Loop  
	Endif
	SA3->(DbSelectArea("SA3"))
	SA3->(DbSetOrder(1))
	SA3->(DbGotop())
	If SA3->(DbSeek(xFilial("SA3")+TMPSC9->C5_VEND1))
		_cVend += " - "+SA3->A3_NOME
	Endif   
	
	SA1->(DbSelectArea("SA1"))
	SA1->(DbSetOrder(1))
	SA1->(DbGotop())
	If SA1->(DbSeek(xFilial("SA1")+TMPSC9->A1_COD+TMPSC9->A1_LOJA))
		_nObsCadas := SA1->A1_X_OBCAD
	Endif

	_cCli		    := TMPSC9->C9_CLIENTE
	_cLoja		  := TMPSC9->C9_LOJA
	_cNome		  := AllTrim(TMPSC9->A1_NOME)
	_cPed		    := TMPSC9->C9_PEDIDO
	_nValPed	  := TMPSC9->VALOR
	_nLimite	  := TMPSC9->A1_LC   
	_nMSaldo    := TMPSC9->A1_MSaldo
	_nVlrAcom   := TMPSC9->A1_VACUM
	_dtCadast   := TMPSC9->A1_DTCADAS
	_dtAbertura := TMPSC9->A1_DTNASC
	_nCapSocial := TMPSC9->A1_CAPTSOC
	_nCondPagto := TMPSC9->C5_CONDPAG
	
	U_wfblcmail(_cEmp,_cFil,_cVend,_cCli,_cLoja,_cNome,_cPed,_nValPed,_nLimite,_nMSaldo,_nVlrAcom,_dtCadast,_dtAbertura,_nCapSocial,_nObsCadas,_cMail)
	SC9->(DbSelectArea("SC9"))
	SC9->(DbSetOrder(1))
	SC9->(DbGotop())
	If SC9->(DbSeek(TMPSC9->C5_FILIAL+TMPSC9->C9_PEDIDO))
		While !SC9->(Eof()) .And. TMPSC9->C5_FILIAL+TMPSC9->C9_PEDIDO == SC9->C9_FILIAL+SC9->C9_PEDIDO
            SC9->(Reclock("SC9",.F.))
		        SC9->C9_X_ENVWF := dDataBase
            SC9->(MsUnlock())	
			SC9->(DbSkip())
		End
	Endif
	
	TMPSC9->(DbSelectArea("TMPSC9"))
	TMPSC9->(DbSkip())
End Do  
TMPSC9->(DbSelectArea("TMPSC9"))
TMPSC9->(DbCloseArea("TMPSC9"))

Return Nil

User Function wfcadMail()
Local _cTab	:= "ZZR"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ZZR->(DbSelectArea("ZZR"))
AxCadastro("ZZR")
Return Nil

User Function wfblcmail(_cEmp,_cFil,_cVend,_cCli,_cLoja,_cNome,_cPed,_nValPed,_nLimite,_nMSaldo,_nVlrAcom,_dtCadast,_dtAbertura,_nCapSocial,_nObsCadas,_cMail)
Local oProcess	:= Nil
Local oHtml		:= Nil
Local _aArea	:= GetArea()          

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

oProcess := TWFProcess():New("WFBLCRED","BLOQUEIO POR LIMITE DE CREDITO")
oProcess:NewTask("WFBLCRED","\workflow\wfblcred.htm")
oProcess:cSubject := dtoc(MsDate())+" - PEDIDO DE VENDA COM BLOQUEIO DE CREDITO - PEDIDO " + _cPed 
oProcess:UserSiga := "000000"   
oHTML := oProcess:oHTML
oHTML:ValByName( 'PEDIDO'		,_cPed)
oHTML:ValByName( 'VENDEDOR'		,_cVend)
oHTML:ValByName( 'FILIAL'		,_cFil + " - " + SM0->M0_FILIAL)
oHTML:ValByName( 'EMPRESA'		,_cEmp + " - " + SM0->M0_NOME)
oHTML:ValByName( 'CLIENTE' 		,_cCli)
oHTML:ValByName( 'LOJA'			, _cLoja)
oHTML:ValByName( 'NOME' 		, _cNome)
oHTML:ValByName( 'MSALDO' 	, TRANSFORM(_nMSaldo,'@E 9,999,999.99' )) 
oHTML:ValByName( 'VLACUM'	 , TRANSFORM(_nVlrAcom,'@E 9,999,999.99' )) 
oHTML:ValByName( 'DTCADAS' , StoD(_dtCadast))
oHTML:ValByName( 'DTABERT' , StoD(_dtAbertura))
oHTML:ValByName( 'CAPSOCIAL'	,TRANSFORM(_nCapSocial,'@E 9,999,999.99' ))    
oHTML:ValByName( 'OBSCADASTRO'	,_nObsCadas)
oHTML:ValByName( 'LIMITE' 	 	,TRANSFORM(_nLimite,'@E 9,999,999.99' ))
oHTML:ValByName( 'FATURADO' 	,TRANSFORM(_nValPed,'@E 9,999,999.99' ))
oHTML:ValByName( 'ANALISEPED' 		,"http://www.cantu.tecnologia.ws/wscotacao/AprovPedVenda.aspx?Emp="+_cEmp+"&Filial="+_cFil+"&Pedido="+_cPed)
                                    

oProcess:cTo := _cMail 
oProcess:Start()
oProcess:Finish()
oProcess:Free()

RestArea(_aArea)

Return()

// Função utilizada para aprovar ou rejeitar pedidos de venda com bloqueio de credito.
/*
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
±±³          ³       2 - Rejeicao                                          ³±±
±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
±±³          ³ExpL3: Numero do pedido a ser liberado                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
±±³          ³venda com base na tabela SC9.                                ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/	

/*
User Function WFBLLIB(nOpc,lAtuCred,cPedido) 
	If nOpc = 1 // Se Financeiro aprovar o pedido efetuo a liberação do mesmo.
		SC9->(DbSelectArea("SC9"))
		cSql := "SELECT * "
		cSql += "FROM "+RetSqlName("SC9")+" "
		cSql += "WHERE D_E_L_E_T_ <> '*' "
		cSql += "AND C9_FILIAL = '"+xFilial("SC9")+"' "
		cSql += "AND C9_BLCRED <> '"+Space(Len(SC9->C9_BLCRED))+"' "
		cSql += "AND C9_BLCRED <> '10' "	
		cSql += "AND C9_PEDIDO = '"+cPedido+"' "
		TCQUERY cSql NEW ALIAS "QRYSC9"
		QRYSC9->(DbSelectArea("QRYSC9"))
		QRYSC9->(DbGotop())
		While !QRYSC9->(Eof())
			SC9->(DbSelectArea("SC9"))
			SC9->(DbSetOrder(1))
			SC9->(DbGotop())
			If SC9->(DbSeek(QRYSC9->C9_FILIAL+QRYSC9->C9_PEDIDO+QRYSC9->C9_ITEM))

//				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//				±±³Parametros³ExpN1: 1 - Liberacao                                         ³±±
//				±±³          ³       2 - Rejeicao                                          ³±±
//				±±³          ³ExpL2: Indica uma Liberacao de Credito                       ³±±
//				±±³          ³ExpL3: Indica uma liberacao de Estoque                       ³±±
//				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
//				±±³Descri‡„o ³Esta rotina realiza a atualizacao da liberacao de pedido de  ³±±
//				±±³          ³venda com base na tabela SC9.                                ³±±
//				±±³          ³                                                             ³±±
//				±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±

				A450grava(nOpc,lAtuCred,.F.)
			Endif
			QRYSC9->(DbSelectArea("QRYSC9"))
			QRYSC9->(DbSkip())
		End
		QRYSC9->(DbSelectArea("QRYSC9"))
		QRYSC9->(DbCloseArea())
	Else // Se financeiro rejeitar o pedido, efetuo a eliminação de residuo dos itens bloqueados.
		 // Flavio verificar aquela questão dos pedidos que podem ter parte dos itens liberados e parte bloqueados.
		SC5->(DbSelectArea("SC5"))
		SC5->(DbSetOrder(1))
		SC5->(DbGotop())
		SC5->(DbSeek(xFilial("SC5")+cPedido))
		
		SC6->(DbSelectArea("SC6"))
		SC6->(DbSetOrder(1))
		SC6->(DbGotop())
		If SC6->(DbSeek(xFilial("SC6")+cPedido))
			While !SC6->(Eof()) .And. SC6->C6_FILIAL+SC6->C6_NUM == SC6->C6_FILIAL+cPedido
//				±±³Parametros³ExpN1: Numero do Registro do SC6                            ³±±
//				±±³          ³ExpL2: Estorna Itens Bloqueados                             ³±±
//				±±³          ³ExpL3: Avalia o Cabecalho do Pedido                         ³±±
				MaResDoFat(SC6->(Recno()),.T.,.t.)			
				SC6->(DbSkip())
			End
		Endif
	Endif
Return Nil 
*/