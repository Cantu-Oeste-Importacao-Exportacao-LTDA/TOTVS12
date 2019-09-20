#include "rwmake.ch" 
                          
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FRTENTREG  �Autor  �Microsiga          � Data �  19/11/2010 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada localizado ap�s a grava��o dos dados da    ���
���          �venda - FRONTLOJA. Impress�o de duplicata.                  ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*-----------------------------*
User Function FRTENTREG()
*-----------------------------*
Local aArea := GetArea()
Local bReturn := .F.            

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

	//���������������������������������������������������������������������������Ŀ
	//� Ativa chamada da rotina de impress�o de duplicata, opera��o de vendas     �
	//�����������������������������������������������������������������������������	
	If ALLTRIM(SuperGetMV("MV_X_ATIDP",,"N")) == "S"
      
		//���������������������������������������������������������������������Ŀ
		//� Se condi��o de pagamento diferente de "� vista"                     �
		//�����������������������������������������������������������������������		
	  DbSelectArea("SL4")       
	  DbGotop()
	 	DbSetOrder(1)
		MsSeek(xFilial("SL4")+SL1->L1_NUM)            
		While !Eof() .And. (xFilial("SL1") == SL4->L4_FILIAL .And. SL1->L1_NUM == SL4->L4_NUM) .AND. bReturn = .F.
			If ALLTRIM(SL4->L4_FORMA) $ "CC/CD/R$/CH"     
				dbskip()
			Else      
				bReturn := .T.
			EndIf   
		EndDo                    
		                                             
		If bReturn = .T.
			U_RJFR02P(.F., SL1->L1_NUM, SL1->L1_NUM, "")
		EndIf
	
	EndIf 
	
	RestArea(aArea)

Return