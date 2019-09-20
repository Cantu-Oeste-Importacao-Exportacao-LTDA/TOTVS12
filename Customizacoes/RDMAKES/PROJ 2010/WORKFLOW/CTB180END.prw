#include "rwmake.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CTB180END   �Autor  �Dioni Reginatto     � Data �  29/12/11 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado ap�s a inclus�o de CUSTO         -��
�������������������������������������������������������������������������͹��
���Uso       � RJU                                                        ���
�������������������������������������������������������������������������ͼ��                       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                           
*------------------------*
User Function CTB180END()
*------------------------*
Local aArea   := GetArea()
Local cEMAIL  := ""
Local cCTHCOD := CTH->CTH_CLVL  
Local cCTHDES := CTH->CTH_DESC01

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
    
	conout("WF - CTB180END - INICIO DO ENVIO DE EMAIL - NOVO CUSTO CADASTRADO ")
	
	// Busca o email da configuracao
	cEMAIL := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "CTB180EN", "ZWF_EMAIL"))
	If ALLTRIM(cEMAIL) == ""    
		Return
	EndIf

	oProcess := TWFProcess():New( "CTB180END", "NOVO CUSTO CADASTRADO")
	oProcess:NewTask( "CTB180END", "\workflow\inccth.htm")
	
	oProcess:cSubject :=  "WF - NOVO CUSTO CADASTRADO" 

	oHTML := oProcess:oHTML

	oHtml:ValByName("CCTHCOD", cCTHCOD	)	   
	oHtml:ValByName("CCTHDES", cCTHDES	)

	oProcess:cTo  := LOWER(cEMAIL)
			
	ConOut("WF - CTB180END - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - CTB180END - FIM DO ENVIO DE EMAIL - NOVO CUSTO CADASTRADO")

	RestArea(aArea)
	
Return
