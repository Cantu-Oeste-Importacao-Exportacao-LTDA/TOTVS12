#include "rwmake.ch"
#include "topconn.ch"
/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³FA050FIN  ºAutor  ³Eder Gasparin       º Data ³  15/12/06   º±±
±±ºDesc.     ³ Workflow de envio de mensagem na baixa de contas a pagar   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/
User Function FA050FIN()    
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local cEmailC := ""
Local cEmailO := ""                      
Local lFlag   := .F.                     
Local nPerc   := GetMV("MV_PERMAXD")
Local nDesc   := 0
Local aArea   := GetArea()    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                   
If SE2->E2_MULTA <> 0
   nDesc := Round((SE2->E2_MULTA * 100) / SE2->E2_VALOR,0)
elseIf SE2->E2_JUROS <> 0 
     nDesc := Round((SE2->E2_JUROS * 100) / SE2->E2_VALOR,0)  
EndIf

If nDesc <= nPerc
	Return
Endif

cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'FA050FIN' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SE1")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"

dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"	
		conout("WF - FA050FIN - INICIO DO ENVIO DE EMAIL CONTAS A PAGAR - "+SE2->E2_PREFIXO+"/"+SE2->E2_NUM+"/"+SE2->E2_PARCELA)
		oProcess := TWFProcess():New( "FA050FIN", "BAIXA CONTAS A PAGAR")
		oProcess:NewTask( "FA050FIN", "\WORKFLOW\FA050FIN.HTML" )
		oProcess:cSubject := "Notificação de Baixa Contas a Pagar"
		oHTML := oProcess:oHTML	
		oHtml:ValByName( "EMPRESA"  , SM0->M0_CODIGO+"-"+UPPER(SM0->M0_NOMECOM) )    
		oHtml:ValByName( "FILIAL"   , SM0->M0_CODFIL+"-"+UPPER(SM0->M0_FILIAL)  )
		oHtml:ValByName( "USUARIO"  , UPPER(SubSTR(cUsuario,7,15)) )
		oHtml:ValByName( "HORA"     , time() )
		oHtml:ValByName( "DATA"     , dDataBase )
		oHtml:ValByName( "TITULO"   , SE2->E2_PREFIXO+"/"+SE2->E2_NUM+"/"+SE2->E2_PARCELA)
		oHtml:ValByName( "FORNECED.", SE2->E2_FORNECE+"/"+SE2->E2_LOJA+" - "+SubSTR(Posicione("SA2",1,xFilial("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NOME"),1,20))
		oHtml:ValByName( "EMISSAO"  , DTOC(SE2->E2_EMISSAO) )
		oHtml:ValByName( "VENCTO"   , DTOC(SE2->E2_VENCREA) )
		oHtml:ValByName( "VALOR"    , TRANSFORM( SE2->E2_VALOR   ,'@E 9,999,999.99' ) )
		If SE2->E2_JUROS <> 0 
   		   oHtml:ValByName( "JUROS."   , TRANSFORM( SE2->E2_JUROS  ,'@E 9,999,999.99' ) )
		elseIf SE2->E2_MULTA <> 0
             oHtml:ValByName( "JUROS."   , TRANSFORM( SE2->E2_MULTA  ,'@E 9,999,999.99' ) )		  
		EndIf

		
		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO 
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()         
		
		conout("WF - FA050FIN - FIM DO ENVIO DE EMAIL BAIXAS A PAGAR - "+SE2->E2_PREFIXO+"/"+SE2->E2_NUM+"/"+SE2->E2_PARCELA)
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

Return