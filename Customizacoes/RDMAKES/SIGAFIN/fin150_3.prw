#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FIN150_3  �Autor  �Guilherme Poyer     � Data �  19/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada FIN150_3 ser� executado ap�s excluir os ���
���          � arquivos de trabalho utilizados nesta rotina e antes       ���
���          � de encerr�-la.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------*
User Function FIN150_3()   
*-------------------------*

Private lStatus := .F.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//����������������������������������������������������� 

U_USORWMAKE(ProcName(),FunName())

If !Empty(cArqTemp) //Verificar se � chamado pelo programa certo
	
	cDiret   := cArqAux     //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o.
	cArq 	   := cArqTemp    //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o.
	cSubCta	 := cTipo       //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o. 
	cCaminho := iif(cSubCta == "001","\CNABS\RECEBER\OUTBOX\",iif(cSubCta == "003", "\CNABS\PAGAR\OUTBOX\", ""))
	
	If !Empty(Alltrim(cDiret))  
	
		If cSubCta == "001"
			
			if !ExistDir("\CNABS\RECEBER\")
				MakeDir("\CNABS\RECEBER")
			EndIf 
			
			if !ExistDir("\CNABS\RECEBER\OUTBOX\")
				MakeDir("\CNABS\RECEBER\OUTBOX")
			EndIf
			
		If cSubCta == "003"
			
			if !ExistDir("\CNABS\PAGAR\")
				MakeDir("\CNABS\PAGAR")
			EndIf 
			
			if !ExistDir("\CNABS\PAGAR\OUTBOX\")
				MakeDir("\CNABS\PAGAR\OUTBOX")
			EndIf
				
			
			
			cArqIn   := Alltrim(cDiret)+Alltrim(cArq)
			cArqDest := Alltrim(cCaminho)+Alltrim(cArq)
			
			lStatus := FRename(AllTrim(cArqAux)+Alltrim(cArq),AllTrim(cCaminho)+Alltrim(cArq)) 
			If lStatus != -1	
				CONOUT("FIN150_3 - "+cArq+" COPIADO DO DIR. "+cDiret+" PARA "+cCaminho)			
			Else
				CONOUT("FIN150_3 - ERRO AO COPIAR O ARQUIVO!")
			EndIf		
			EndIf
		EndIf
	
	Else
		CONOUT("FIN150_3 - DIRETORIO VAZIO, N�O SER� EFETUADA A C�PIA!")
	EndIf	
	
EndIf

Return  