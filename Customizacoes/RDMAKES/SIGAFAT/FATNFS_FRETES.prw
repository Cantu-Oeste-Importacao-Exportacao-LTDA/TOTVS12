#include "TopConn.ch"
#include "Protheus.ch"
#INCLUDE "rwmake.ch"



User Function FatNFS(cCarga, cSerie)
Local aPvlNfs := {}
Local nX
Local cSql := ""
Local aNumPeds := {}
Local oDlg1
Local lCont    := .F.
Private _aNFWf	:= {}   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Empty(cCarga)
	cCarga := Space(9)
	cSerie := Space(3)
	@ 150,1 TO 280,300 DIALOG oDlg1 TITLE "Informe a carga a ser faturada"
	@ 015,004 Say "Carga: "
	@ 014,050 Get cCarga Size 40, 10  When .T. F3 "ZZSROM" Picture "@!"
	@ 030,004 Say "Série NF: "
	@ 029,050 Get cSerie Size 40, 10 Picture "@!"
	@ 045,080 BMPBUTTON TYPE 1 ACTION (lCont := .T., Close(oDlg1))
	@ 045,120 BMPBUTTON TYPE 2 ACTION (lCont := .F., Close(oDlg1))
	ACTIVATE DIALOG oDlg1 CENTERED           	
EndIf

If lCont
	cSql := "SELECT C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM, C9.C9_SEQUEN, C9.C9_QTDLIB, C9.C9_PRCVEN, C9.C9_PRODUTO, F4.F4_ISS, "
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
	cSql += "  AND C9_X_CARGA = '"+cCarga+"' "
	cSql += "  AND C9_BLCRED = '  ' "
	cSql += "ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM "
	// fazer laço para controlar o faturamento por pedido, gerando uma nf para cada e alimentando o array apvlnfs posicionando todos os alias separadamente
	
	TcQuery cSql NEW ALIAS "TMPCRG"
	cPed := TMPCRG->C9_PEDIDO
	If !TMPCRG->(Eof())
		While TMPCRG->(!Eof())
		  aPvlNfs := {}
		  dbSelectArea("TMPCRG")
			While cPed == TMPCRG->C9_PEDIDO
				aadd(aPvlNfs,{ C9_PEDIDO,;
										C9_ITEM,;
										C9_SEQUEN,;
										C9_QTDLIB,;
										C9_PRCVEN,;
										C9_PRODUTO,;
										F4_ISS=="S",;
										C9_RNO,;
										C5_RNO,;
										C6_RNO,;
										E4_RNO,;
										B1_RNO,;
										B2_RNO,;
										F4_RNO,;
										B2_LOCAL,0})
				TMPCRG->(dbSkip())
			EndDo
			
			aAdd(aNumPeds,aPvlNfs[Len(aPvlNfs), 1])
			
			cPed := TMPCRG->C9_PEDIDO
			Pergunte("MT460A",.F.) 
			MaPvlNfs(aPvlNfs,cSerie,.F.,.F.,.F.,.T.,.F.,0,0,.F.,.F.)							
			// MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF)
		//	TMPCRG->(dbSkip())
		EndDo
		
		dbSelectArea("TMPCRG")
		TMPCRG->(dbCloseArea())
		
		// Faz a parte de gravar os títulos no financeiro.
		For nX := 1 to Len(aNumPeds)
			LancaPrv(aNumPeds[nX], cCarga)
		Next nX
		U_FRTWFFT(_aNFWf)
		MsgAlert("Carga faturada.")
	Else 
		Alert("Carga não encontrada ou já faturada.")
		dbSelectArea("TMPCRG")
		TMPCRG->(dbCloseArea())		
	Endif
Endif

Return Nil

/**************************************************
 Função que prepara o lançamento do título provisório para o transportador
 **************************************************/
Static Function LancaPrv(cPedido, cCarga)
Local cCodNF
Local cSerieNF
Local nValFrt
Local cCgcFor
Local _cCLVL := ""
Public _cEmpGrp	:= {}
Public _cCCLogi	:= ALLTRIM(SuperGetMv("MV_X_CCLOGI", ,"020206004"))
_cEmpAtu	:= SM0->(GetArea())
SM0->(DbSelectArea("SM0"))
SM0->(DbSetOrder(1))
SM0->(DbGotop())
While !SM0->(Eof())
	aAdd(_cEmpGrp,{SM0->M0_CGC})
	SM0->(DbSkip())
End
SM0->(RestArea(_cEmpAtu))

SD2->(dbSetOrder(8))
ZZS->(dbSetOrder(4))
SA4->(dbSetOrder(1))
SA2->(dbSetOrder(3))
SF2->(dbSetOrder(1))
SA3->(dbSetOrder(1))
if SD2->(!dbSeek(xFilial("SD2")+cPedido))
	Alert("Não foi faturada a NF para o pedido "+cPedido+". Verifique.")
	Return
EndIf
_cCLVL := SD2->D2_CLVL

cCodNF := SD2->D2_DOC
cSerieNF := SD2->D2_SERIE
// Alimenta Array para envio de WorkFlow
aAdd(_aNFWf,{cEmpAnt,cFilAnt,SD2->D2_DOC,SD2->D2_SERIE,cCarga,SD2->D2_EMISSAO})

// Obtém o valor do frete na tabela zzs
ZZS->(dbSeek(xFilial("ZZS")+cEmpAnt + cFilAnt + cCarga + cPedido))
nValFrt := if(ZZS->ZZS_VLRFIN > 0, ZZS->ZZS_VLRFIN, ZZS->ZZS_VALFRE)
// MARCA PEDIDO COMO FATURADO
RecLock("ZZS", .F.)
	ZZS->ZZS_NFOK 	:= "S"
	ZZS->ZZS_NFSAI 	:= SD2->D2_DOC // Num NF
	ZZS->ZZS_SERSAI := SD2->D2_SERIE // Serie NF
	ZZS->ZZS_SEGMEN := _cCLVL // Segmento
	ZZS->ZZS_CC 	:= _cCCLogi  //SD2->D2_CCUSTO // Centro Custo
	ZZS->ZZS_DTFAT	:= SD2->D2_EMISSAO // Data de Emissão NFS
ZZS->(MsUnlock())

SA4->(dbSeek(xFilial("SA4")+ZZS->ZZS_CODTRA))
cCgcFor := SA4->A4_CGC

If ZZS->ZZS_GERDUP <> "S"
	Return
Endif

If Empty(cCgcFor) .Or. SA2->(!dbSeek(xFilial("SA2")+cCgcFor))
	Alert("Não foi encontrado fornecedor com o mesmo cnpj do transportador " + cCgcFor + ". Não será gerado provisório.")
else	
   	nPosicao  := aScan(_cEmpGrp,{|_x| SA2->A2_CGC == _x[1]})
	If nPosicao = 0
		// Lança a nota no financeiro a pagar, deixado padrão com 30 dias para pagamento
		LancaNF(cCodNF, cSerieNF, nValFrt, SA2->A2_COD, SA2->A2_LOJA, dDataBase + 30, cCarga,_cCLVL)
	EndIf			
EndIf  
Return

/**************************************************
 Função que efetua o lançamento do título provisório 
 para o transportador referente a determinada carga
 **************************************************/
Static Function LancaNF(cCodNF, cSerieNF, nValFrt, cFornece, cLoja, dVencto, cCarga,cCLVL)
Local aTitulo := {}
Local cNatFrt := ALLTRIM(SuperGetMv("MV_X_NTFRT", ,"2110005"))
Local cCCFrt  := ALLTRIM(SuperGetMv("MV_X_CCFRT", ,"020206004"))

lMsErroAuto := .F.
cHistor := "Frete Ref NF " + cCodNF + "-" + cSerieNF + ", Carga " + cCarga
aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")	, Nil },;
							{"E2_PREFIXO"	, cSerieNF		 		, Nil },;
 							{"E2_NUM"		, cCodNF	 		      , Nil },;
							{"E2_PARCELA"	, "FR1"				    , Nil },;
							{"E2_TIPO"		, "PR "				    , Nil },;
							{"E2_NATUREZ"	, cNatFrt				  , Nil },;
							{"E2_FORNECE"	, cFornece		    , Nil },;
							{"E2_LOJA"		, cLoja			      , Nil },;
							{"E2_EMISSAO"	, dDataBase		 	  , Nil },;
							{"E2_VENCTO"	, dVencto				  , Nil },;
							{"E2_VENCREA"	, DataValida(dVencto)	, Nil },;
							{"E2_VALOR"		, nValFrt			  	, Nil },;
							{"E2_HIST"		, cHistor			  	, Nil },;
							{"E2_CLVLDB"	, cCLVL  				, Nil },;
							{"E2_CCD"		, cCCFrt		 	    , Nil } }

MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)

If lMsErroAuto
//	DisarmTransaction()
	Mostraerro()
EndIf
Return
User Function TestaPRV()
Local oDlg1
Local lCont    := .T.
Local cCarga := Space(9)
Local cPedido := Space(6)
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Empty(cCarga)
	cCarga := Space(9)
	cPedido := Space(6)
	@ 150,1 TO 280,300 DIALOG oDlg1 TITLE "Informe pedido e carga para testar lançamento do provisório"
	@ 015,004 Say "Carga: "
	@ 014,050 Get cCarga Size 40, 10 Picture "@!" F3 "ZZSROM"
	@ 030,004 Say "Pedido: "
	@ 029,050 Get cPedido Size 40, 10 Picture "@!" F3 "SC5"
	@ 045,080 BMPBUTTON TYPE 1 ACTION (lCont := .T., Close(oDlg1))
	@ 045,120 BMPBUTTON TYPE 2 ACTION (lCont := .F., Close(oDlg1))
	ACTIVATE DIALOG oDlg1 CENTERED           	
EndIf
      
if lCont
	LancaPrv(cPedido, cCarga)
EndIf
Return
