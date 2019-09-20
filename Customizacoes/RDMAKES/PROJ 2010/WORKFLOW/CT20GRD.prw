#include "rwmake.ch" 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CT20GRD   �Autor  �Dioni Reginatto     � Data �  28/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada executado ap�s a inclus�o da Conta Contabil-��
���          �em plano de contas.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � RJU                                                        ���
�������������������������������������������������������������������������ͼ��                       
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                           
*------------------------*
User Function CT20GRD()
*------------------------*
Local aArea   := GetArea()
Local cEMAIL  := ""
Local cCT1CON := CT1->CT1_CONTA    
Local cCT1DES := CT1->CT1_DESC01

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
    
	conout("WF - CT20GRD - INICIO DO ENVIO DE EMAIL - CONTAS CONT�BEIS ")
	
	// Busca o email da configuracao
	cEMAIL := ALLTRIM(Posicione("ZWF", 01, xFilial("ZWF") + "CT20GRD", "ZWF_EMAIL"))
	If ALLTRIM(cEMAIL) == ""    
		Return
	EndIf

	oProcess := TWFProcess():New( "CT20GRD", "CONTA CONT�BEIS")
	oProcess:NewTask( "CT20GRD", "\workflow\incct1.htm")
	
	oProcess:cSubject :=  "WF - CONTAS CONT�BEIS" 

	oHTML := oProcess:oHTML

	oHtml:ValByName("CCT1CON", cCT1CON	)	   
	oHtml:ValByName("CCT1DES", cCT1DES	)

	oProcess:cTo  := LOWER(cEMAIL)
			
	ConOut("WF - CT20GRD - E-MAIL ENVIADO PARA: " + oProcess:cTo)

	// inicia o processo de envio de workflow
	oProcess:Start()	
	
	// finaliza o processo
	oProcess:Finish()
	
	conout("WF - CT20GRD - FIM DO ENVIO DE EMAIL - CONTAS CONT�BEIS")

	RestArea(aArea)
	
Return
