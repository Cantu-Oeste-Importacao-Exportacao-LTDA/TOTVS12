#include "rwmake.ch" 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMA035INC  บAutor  ณRafael Parma        บ Data ณ  24/02/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de entrada executado ap๓s a inclusใo do grupo de produ-ฑฑ
ฑฑบ          ณtos, realiza o envio de workflow informativo.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ                       
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                           
*------------------------*
User Function MA035INC()
*------------------------*
Local aArea   := GetArea()
Local cEMAIL  := ""
Local cSBMCOD := SBM->BM_GRUPO    
Local cSBMDES := SBM->BM_DESC 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
    
	conout("WF - MA035INC - INICIO DO ENVIO DE EMAIL - GRUPO DE PRODUTOS ")
	
	// Busca o email da configuracao
	cEMAIL := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "MA035INC", "ZWF_EMAIL"))
	If ALLTRIM(cEMAIL) == ""    
		Return
	EndIf

	oProcess := TWFProcess():New( "MA035INC", "GRUPO DE PRODUTOS")
	oProcess:NewTask( "MA035INC", "\workflow\incsbm.html")
	
	oProcess:cSubject :=  "WF - GRUPO DE PRODUTOS" 

	oHTML := oProcess:oHTML

	oHtml:ValByName("CSBMCOD", cSBMCOD	)	
	oHtml:ValByName("CSBMDES", cSBMDES	)

	oProcess:cTo  := LOWER(cEMAIL)
			
	ConOut("WF - MA035INC - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - MA035INC - FIM DO ENVIO DE EMAIL - GRUPO DE PRODUTOS")

	RestArea(aArea)
	
Return


