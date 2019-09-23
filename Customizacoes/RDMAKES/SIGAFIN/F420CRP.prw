#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F420CRP  �Autor  �Edison G. Barbieri   � Data �  19/12/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � O ponto de entrada F420CRP  ser� executado ap�s excluir os ���
���          � arquivos de trabalho utilizados nesta rotina e antes       ���
���          � de encerr�-la.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-------------------------*
User Function F420CRP()   
*-------------------------*

Local aArea := GetArea()
Private lStatus := .F.  


//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//����������������������������������������������������� 
U_USORWMAKE(ProcName(),FunName())

//If !Empty(cArqTemp) //Verificar se � chamado pelo programa certo
If iif(TYPE("cArqTemp") == "C", !Empty(cArqTemp),.F.) //Verificar se � chamado pelo programa certo
	
	cDiret   := cArqAux     //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o.
	cArq 	 := cArqTemp    //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o.
	cSubCta	 := cTipo       //Variavel recebe o valor no programa GETARQFIN e valoriza no P.E em quest�o. 
	cCaminho := "\CNABS\PAGAR\OUTBOX\"    
	
	If !Empty(Alltrim(cDiret))  
	
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
				CONOUT("F420CRP - "+cArq+" COPIADO DO DIR. "+cDiret+" PARA "+cCaminho)			
			Else
				CONOUT("F420CRP - ERRO AO COPIAR O ARQUIVO!")
			EndIf		
			
		EndIf
	
	Else
		CONOUT("F420CRP - DIRETORIO VAZIO, N�O SER� EFETUADA A C�PIA!")
	EndIf	
	
EndIf

RestArea(aArea)      

Return 