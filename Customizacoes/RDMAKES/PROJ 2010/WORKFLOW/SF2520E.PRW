#include "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSF2520E   บAutor  ณMicrosiga           บ Data ณ  18/07/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Workflow de envio de mensagem na exclusao de nota fiscal   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - TOP                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------*
User Function SF2520E()     
*---------------------*
Local oProcess
Local cQuery  := ""
Local cEmail  := ""
Local cEmailC := ""
Local cEmailO := ""                      
Local lFlag   := .F.
Local aArea   := GetArea()  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
              
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = 'SF2520E' AND "
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
MEMOWRITE("TESTE.SQL",CQUERY)	
dbSelectArea("TMP")
If !TMP->(EOF())
	If TMP->ZWF_ATIVO == "S"
		conout("WF - SF2520E - INICIO DO ENVIO DE EMAIL EXCLUSAO NOTA FISCAL - "+SF2->F2_DOC+"/"+SF2->F2_SERIE)
		oProcess := TWFProcess():New( "SF2520E", "EXCLUSAO NOTA FISCAL SAIDA")
		oProcess:NewTask( "SF2520E", "\WORKFLOW\SF2520E.HTML" )
		oProcess:cSubject := "Notifica็ใo de Exclusใo de Nota Fiscal"
		oHTML := oProcess:oHTML	
		oHtml:ValByName( "EMPRESA"  , SM0->M0_CODIGO+"-"+UPPER(SM0->M0_NOMECOM) )    
		oHtml:ValByName( "FILIAL"   , SM0->M0_CODFIL+"-"+UPPER(SM0->M0_FILIAL)  )
		oHtml:ValByName( "USUARIO"  , UPPER(SubSTR(cUsuario,7,15)) )
		oHtml:ValByName( "HORAATU"  , time() )
		oHtml:ValByName( "DDATABASE", dDataBase )
		oHtml:ValByName( "NOTAF"    , SF2->F2_DOC+"/"+SF2->F2_SERIE 			)
		oHtml:ValByName( "CLIENTE"  , SF2->F2_CLIENTE+"/"+SF2->F2_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_NOME"))
		oHtml:ValByName( "EMISSAO"  , DTOC(SF2->F2_EMISSAO)	 )

		dbSelectArea("SD2")
		dbSetOrder(3)
		If dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
			While !EOF() .and. SD2->D2_FILIAL+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA == ;
							   xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		       AAdd( (oHtml:ValByName( "IT.CODIGO" )), SD2->D2_COD )		              
		       AAdd( (oHtml:ValByName( "IT.DESCRI" )), Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC") )		              
		       AAdd( (oHtml:ValByName( "IT.QUANT"  )), TRANSFORM( SD2->D2_QUANT ,'@E 9,999,999.99' ) )		              
		       AAdd( (oHtml:ValByName( "IT.PRCVEN" )), TRANSFORM( SD2->D2_PRCVEN,'@E 9,999,999.99' ) )		              
		       AAdd( (oHtml:ValByName( "IT.TOTAL"  )), TRANSFORM( SD2->D2_TOTAL ,'@E 9,999,999.99' ) )		              
		       SD2->(dbSkip())
			Enddo
		Endif	    

		cEmail  := TMP->ZWF_EMAIL
		cEmailC := TMP->ZWF_EMAILC
		cEmailO := TMP->ZWF_EMAILO 
		oProcess:cTo  := LOWER(cEmail)
		oProcess:cCC  := LOWER(cEmailC)
		oProcess:cBCC := LOWER(cEmailO)
		oProcess:Start()
		oProcess:Finish()
		conout("WF - SF2520E - FIM DO ENVIO DE EMAIL EXCLUSAO NOTA FISCAL - "+SF2->F2_DOC+"/"+SF2->F2_SERIE)
		lFlag := .T.
	Endif	
Endif      

TMP->(dbCloseArea())
                    
If lFlag
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'SF2520E' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)	
Endif
	
RestArea(aArea)

Return