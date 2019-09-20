/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCOAKDCHV �Autor  �Totvs	             � Data �  29/08/2014 ���
�������������������������������������������������������������������������͹��
���Desc.     �Alteracao na chave de lancamento PCO.                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function PCOAKDCHV()

Local cRet
Local cProcesso	:= Paramixb[1]
Local cItem 	:= Paramixb[2]
Local lDelet 	:= Paramixb[3]
Local cChave 	:= Paramixb[4]
Local aArea		:= GetArea()
Local cTamFil   := len(ALLTRIM(cFilAnt)) 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DO CASE
    
	//Somente se n�o gravou a sequencia na chave da AKD   //N�o deve gravar a sequencia nessa chave, pois no campo AKD_CHAVE n�o est� gravando a sequencia. Ricardo
	CASE cProcesso == '000052' .AND. cItem = '01' .AND. ( len(ALLTRIM(cChave)) = 17+cTamFil ) //.and. !lDelet	
		cRet := Padr(Substr(ALLTRIM(cChave),1,15),Len(AKD->AKD_CHAVE))   
	
    OTHERWISE       
	    cRet := cChave	
    	
ENDCASE

RestArea(aArea)

Return(cRet)