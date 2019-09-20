#include "rwmake.ch"
#include "tbiconn.ch"
#include "topconn.ch"
User Function WFNPEPLM()
Local cEmp := "10"
Local oProcess
Local nRegSM0 
Local lTemPed := .F.
Local cNameFunc := "WFNPEPLM"
Local cArqDbf := ""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Abre as tabelas que vao ser utilizadas
RPCSetEnv("50","01","","","","",{"SC5"})


nRegSM0 := SM0->(Recno())
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = '" + cNameFunc + "' AND "  // cada empresa tem a sua funçao específica
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"

If !TMP->(EOF())
	oProcess := TWFProcess():New( "PedPlm", "Bloqueio de Clientes")
	oProcess:NewTask( "PedPlm", "\workflow\pedplm_sc5.html" )
	oProcess:cSubject := "Pedidos de venda incluídos em " + DTOC(DDATABASE -1)
									
	oHTML := oProcess:oHTML
	
	nCont := 0
	
	oHtml:ValByName( "DATA", DTOC(DDATABASE -1))
	
	// cria uma cópia do arquivo SM0
	
	aStructSM := SM0->(dbStruct())
  cArqDbf := CriaTrab(aStructSM, .T.)

	Use (cArqDbf) Alias TRB Shared New
  
  nRecSM0 := SM0->(Recno())                   
  
  SM0->(dbgotop())
  
  While SM0->(!Eof())
  	if TRB->(!Eof())
  		TRB->(dbgotop())
  	Endif
  	lFind := .F.
  	While TRB->(!Eof())
  		if TRB->M0_CODIGO == SM0->M0_CODIGO
  			lFind := .T.
  			exit
  		EndIf
  		TRB->(dbskip())
  	EndDo  
  	if !lFind // adiciona o registro
			dbselectarea("TRB")
 			RecLock("TRB", .T.)
 			TRB->M0_CODIGO = SM0->M0_CODIGO
 			TRB->M0_FILIAL = SM0->M0_FILIAL
 			TRB->M0_NOME = SM0->M0_NOME			
 			TRB->(MsUnlock())
		Endif
		SM0->(dbskip())  		
  EndDo
  
  // volta o arquivo de empresas par ao lugar anterior
	SM0->(dbGoTo(nRegSM0))
  
	TRB->(dbgotop())
	
	dbSelectArea("SM0")
	dbSeek(cEmp,.T.)
	
	while TRB->(!Eof())
		cEmp := TRB->M0_CODIGO
		// faz todo o controle
		// obtém o número de pedidos pelo sistema
		GetPedSC5(cEmp)
		
		GetPedSZE(cEmp)
		lTemPed := .F.
		While TMPSC5->(!Eof())
			lTemPed := .T.
			SM0->(dbSeek(cEmp + TMPSC5->C5_Filial,.T.))
			AAdd((oHtml:ValByName( "IT.EMPR" )),  TRB->M0_NOME)
			AAdd((oHtml:ValByName( "IT.FILIAL" )), TMPSC5->C5_Filial + " - " + TRB->M0_FILIAL)
			AAdd((oHtml:ValByName( "IT.PEDSC5" )), TMPSC5->NumPed)
			
			// obtém os dados de número de pedidos do palm
			if (PosiSZE(TMPSC5->C5_Filial))
				AAdd((oHtml:ValByName( "IT.PALM" )), TMPSZE->NumPed)
			else
				AAdd((oHtml:ValByName( "IT.PALM" )), 0)
			EndIf
			TMPSC5->(DbSkip())
		EndDo
		if (lTemPed)
			AAdd((oHtml:ValByName( "IT.EMPR" )), "------")
			AAdd((oHtml:ValByName( "IT.FILIAL" )), "------")	
			AAdd((oHtml:ValByName( "IT.PEDSC5" )), "------")
			AAdd((oHtml:ValByName( "IT.PALM" )), "------")
		EndIf
		// fecha os arquivos abertos
		TMPSC5->(DbCloseArea())
		TMPSZE->(DbCloseArea())
		TRB->(dbskip())
	EndDo
	TRB->(DbCloseArea())
	// envia o email com a lista de pedidos
	oProcess:cTo  := TMP->ZWF_EMAIL
	oProcess:cCC  := TMP->ZWF_EMAILC
	oProcess:cBCC := TMP->ZWF_EMAILO
	oProcess:Start()
	oProcess:Finish()	
	
	// seta a data de execução	
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = '" + cNameFunc + "' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)
	TMP->(DbCloseArea())
Endif


Return(.T.)

/**********************************************
 verifica se existe a tabela na empresa
 e obtém o número de pedidos sincronizados no palm
 **********************************************/
Static Function GetPedSZE(cEmp)
Local cQuery
Local cArq
Local aStruct
If MsFile("SZE" + cEmp + "0" , NIL , __cRdd)
	cQuery := "Select ze_filial, count(distinct ZE_COTAC) as numped from " + "SZE" + cEmp + "0"  + ;
  		" where ze_emissao = '" + DToS(dDataBase - 1) + "' and d_e_l_e_t_ <> '*' group by ze_filial"
	TCQUERY cQuery NEW ALIAS "TMPSZE"
else // cria um arquivo vazio
  aStruct := SZE->(dbStruct())
  cArq := CriaTrab(aStruct)
  Use &cArq Alias TMPSZE New
EndIf
Return

/**********************************************
 verifica se existe a tabela na empresa
 e obtém o número de pedidos incluídos no sistema
 **********************************************/
Static Function GetPedSC5(cEmp)
Local cQuery := "Select c5_filial, count(distinct c5_num) as numped from " + "SC5" + cEmp + "0"  + ;
  	" where c5_emissao = '" + DToS(dDataBase - 1) + "' and d_e_l_e_t_ <> '*' group by c5_filial"
TCQUERY cQuery NEW ALIAS "TMPSC5"
Return Nil

/**********************************************
 Posiciona o arquivo de pedidos do palm na filial que está sendo processada
 **********************************************/
Static function PosiSZE(cFilSC5)
Local lFind := .F.
TMPSZE->(DbGoTop())

While TMPSZE->(!Eof())
  if TMPSZE->ZE_FILIAL = cFilSC5
    lFind := .T.
    Exit
  EndIf
  TMPSZE->(DbSkip())
EndDo
Return lFind