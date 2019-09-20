#include "rwmake.ch"     
#include "topconn.ch"   

// Ponto:	Após a baixa do título a receber. 
// Neste momento todos os registros já foram atualizados e destravados e a contabilização já foi efetuada.	
// Observações	Utilizado para gravação de dados complementares.
// Retorno Esperado:	Nenhum	
 
User Function SACI008()

Local cMotBx	:= "01 – Pagamento da dívida" 
Local aMotBx	:= {} 
Local aArea		:= GetArea()
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local cEmailC := ""
Local cEmailO := ""                                  	
Local lFlag   := .F.                     
Local nPerc   := GetMV("MV_PERMAXD")
Local nDesc   := 0     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                     
// Gravação de dados complementares na gravação da SE5 conforme SE1.

RecLock("SE5",.F.)
SE5->E5_CLVLDB	:= SE1->E1_CLVLDB
SE5->E5_CLVLCR	:= SE1->E1_CLVLCR
SE5->E5_CCD		:= SE1->E1_CCD
SE5->E5_CCC		:= SE1->E1_CCC
SE5->E5_ITEMD	:= SE1->E1_ITEMD
SE5->E5_ITEMC	:= SE1->E1_ITEMC
SE5->(MsUnLock())



//--------------------------------//
//--Tratamento contrato de redes
//--------------------------------//
dbSelectArea("Z54")
dbSetOrder(1)
dbGoTop()
If dbSeek(SE1->(E1_FILIAL+E1_NUM+E1_PARCELA))
	While !Z54->(EOF()) .AND. Z54->(Z54_FILIAL+Z54_NUMERO+Z54_SEQUEN) == SE1->(E1_FILIAL+E1_NUM+E1_PARCELA)
		If Z54->Z54_TIPOCT == "P" .AND. Z54->(Z54_CLIENT+Z54_LOJACL) == SE1->(E1_CLIENTE+E1_LOJA) .AND. SE1->E1_TIPO == "NCC"
			If RecLock("Z54",.F.)
				Z54->Z54_ATIVO := "N"
				Z54->(MsUnLock())
				Exit
			EndIf	
		EndIf
		Z54->(dbSkip())
	Enddo
EndIf    



If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
  MsgAlert("Entrou no IF do SACI008")
	aAdd(aMotBx,"01 – Pagamento da dívida")
	aAdd(aMotBx,"02 – Renegociação da dívida")
	aAdd(aMotBx,"03 – Por solicitação do cliente")
	aAdd(aMotBx,"04 – Ordem judicial")
	aAdd(aMotBx,"05 – Correção de endereço.")
	aAdd(aMotBx,"06 – Atualização do valor – valorização")
	aAdd(aMotBx,"07 – Atualização do valor–pagamento parcial")
	aAdd(aMotBx,"08 – Atualização de data")
	aAdd(aMotBx,"09 – Correção do nome")
	aAdd(aMotBx,"10 – Correção do número do contrato")
	aAdd(aMotBx,"11 – Correção de varios dados (valor+datas+etc)")
	aAdd(aMotBx,"12 – Baixa por perda de controle de base")
	aAdd(aMotBx,"13 – Motivo não identificado")
	aAdd(aMotBx,"14 – Pontualização da dívida")
	aAdd(aMotBx,"15 – Baixa por concessão de crédito")
	aAdd(aMotBx,"16 – Incorporação / mudança de titularidade")
	aAdd(aMotBx,"17 – Comunicado devolvido dos correios")
	aAdd(aMotBx,"18 – Correção de dados do coobrigado / avalista")
	aAdd(aMotBx,"19 – Renegociação da dívida por acordo")
	aAdd(aMotBx,"20 – Pagamento da dívida por pagamento bancário")
	aAdd(aMotBx,"21 – Analise de documentos")
	aAdd(aMotBx,"22 – Correção de dados pela loja / filial")
	aAdd(aMotBx,"23 – Pagamento da dívida por emissão de Nota Promissória")
	aAdd(aMotBx,"24 – Análise de documento por seguro")
	aAdd(aMotBx,"25 – Devolução ou troca de bem financiado")
	
	@ 000,000 TO 130,350 DIALOG oDlg1 TITLE "Motivos de baixas SERAS PEFIN"
	@ 015,010 Say "Motivos de baixas PEFIN:"
	@ 025,010 COMBOBOX cMotBx ITEMS aMotBx SIZE 155,50
	@ 040,010 BMPBUTTON TYPE 1 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER
	
	SE1->(Reclock("SE1",.F.))
	SE1->E1_PEFINMB := cMotBx	
	SE1->(MsUnlock("SE1"))
Endif


// parte de envio do workflow
// mesclado do fonte que enviava email

// verifica se o desconto esta dentro do maximo do parametro
nDesc := Round((SE1->E1_DESCONT * 100) / SE1->E1_VALOR,0)
If nDesc <= nPerc
	RestArea(aArea)
	Return
Endif

cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'SACI008' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SE1")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"	
		conout("WF - SACI008 - INICIO DO ENVIO DE EMAIL BAIXAS A RECEBER - "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"/"+SE1->E1_PARCELA)
		oProcess := TWFProcess():New( "SACI008", "BAIXA CONTAS A RECEBER")
		oProcess:NewTask( "SACI008", "\WORKFLOW\SACI008.HTML" )
		oProcess:cSubject := "Notificação de Baixa Contas a Receber"
		oHTML := oProcess:oHTML	
		oHtml:ValByName( "EMPRESA"  , SM0->M0_CODIGO+"-"+UPPER(SM0->M0_NOMECOM) )    
		oHtml:ValByName( "FILIAL"   , SM0->M0_CODFIL+"-"+UPPER(SM0->M0_FILIAL)  )
		oHtml:ValByName( "USUARIO"  , UPPER(SubSTR(cUsuario,7,15)) )
		oHtml:ValByName( "HORA"     , time() )
		oHtml:ValByName( "DATA"     , dDataBase )
		oHtml:ValByName( "TITULO"   , SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"/"+SE1->E1_PARCELA)
		oHtml:ValByName( "CLIENTE"  , SE1->E1_CLIENTE+"/"+SE1->E1_LOJA+" - "+SubSTR(Posicione("SA1",1,xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,"A1_NOME"),1,20))
		oHtml:ValByName( "EMISSAO"  , DTOC(SE1->E1_EMISSAO) )
		oHtml:ValByName( "VENCTO"   , DTOC(SE1->E1_VENCREA) )
		oHtml:ValByName( "VALOR"    , TRANSFORM( SE1->E1_VALOR   ,'@E 9,999,999.99' ) )
		oHtml:ValByName( "DESCONT"  , TRANSFORM( SE1->E1_DESCONT ,'@E 9,999,999.99' ) )
	
		
		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO 
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()         
		
		conout("WF - SACI008 - FIM DO ENVIO DE EMAIL BAIXAS A RECEBER - "+SE1->E1_PREFIXO+"/"+SE1->E1_NUM+"/"+SE1->E1_PARCELA)
		lFlag := .T.
	Endif	
Endif      

TMP->(dbCloseArea())
                    
If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'SACI008' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SE1")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif

RestArea(aArea)

Return(.T.)
