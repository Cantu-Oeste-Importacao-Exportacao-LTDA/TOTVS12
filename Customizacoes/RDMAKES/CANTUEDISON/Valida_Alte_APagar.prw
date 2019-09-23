/*#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "TopConn.ch"

*/

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA050ALT  � Autor � Edison greski Barbieri   �  19/03/19   ���
�������������������������������������������������������������������������͹��
���Descricao � O ponto de entrada FA050ALT sera utilizado na validacao da ���
���          � Altera��o de titulos no contas a pagar.                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � FINA050 -> Contas a Pagar / FINA750-> Func. Ctas. A Pagar  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*
User Function FA050ALT()  
Local aArea   := GetArea()                                                             
Local URet	:= .T. 

    //�����������������������������������������������������
	//�Chama fun��o para monitor uso de fontes customizados�
	//�����������������������������������������������������
	U_USORWMAKE(ProcName(),FunName())  
  
   If  M->E2_X_CDAGP != " " .and.  M->E2_X_AVCTO == "S" .and.  M->E2_VENCREA != M->E2_VENCORI  
         MsgBox("N�o � poss�vel altera��o do vencimento para esse t�tulo. Firmado acordo de pagamento com o Fornecedor.","Alerta","ERRO")
         URet := .F. 	
	Endif
	  
   
RestArea(aArea)	
				
Return URet	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���������������������������������������������`���������������������������ͻ��
���Programa  �ALVCTOWF  �Autor  �Edison Greski Barbieri�Data � 21/03/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pelo envio de workflow quando ocorreu    ���
���          �Altera��o de t�tulos contas a pagar, qunado tem c�digo de   ���
���          �Agendamento de pagamentos.                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu Oeste                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
User Function ALVCTOWF()
Local aArea     := GetArea() 
Local cStatus 	:= SPACE(6)
Local cEmails	:= AllTrim(Posicione("PT2", 01, xFilial("PT2") + SE2->E2_FORNECE + SE2->E2_LOJA, "PT2_EMAIL"))
Local cAssunto	:= "AGENDAMENTO DE PAGAMENTO CANTU: T�TULO = " +M->E2_NUM+ " - FILIAL " + cFilAnt + " " + ALLTRIM(UPPER(FWFilialName()))
    

	//�������������������������������������
	//�Monta o objeto de envio do workflow�
	//�������������������������������������
	oProcess := TWFProcess():New("WFRM", "FINANCEIRO")
	oProcess:NewTask(cStatus,"\workflow\titulo_agendado_fin.html")
	oProcess:cSubject := cAssunto
	oProcess:cTo  := cEmails
	                        
	//�������������������������������
	//�Monta o cabe�alho do workflow�
	//�������������������������������
	oHtml:= oProcess:oHTML 
	oHtml:ValByName("VENCIMENTO" , DTOC(M->E2_VENCTO)) 
	oHtml:ValByName("FORNECEDOR" , M->E2_FORNECE + "/" + M->E2_LOJA)
	oHtml:ValByName("TITULO"     , M->E2_NUM + "  PARCELA: " + M->E2_PARCELA)
	oHtml:ValByName("VALOR"      , M->E2_VALOR) 
	
	//������������������
	//�Envia o workflow�
	//������������������
	oProcess:Start()


RestArea(aArea)	
Return */