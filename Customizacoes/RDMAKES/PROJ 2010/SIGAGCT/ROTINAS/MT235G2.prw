#INCLUDE "RWMAKE.ch"
#INCLUDE "TOPCONN.ch"
#Include "PROTHEUS.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT235G2   �Autor  �Joel Lipnhraski     � Data �  12/12/11   ���
�������������������������������������������������������������������������͹��
���Desc.     �Integracao PCO durante eliminacao de residuo Pedido de      ���
���	         �compras manual.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MT235G2()  

Local nTipo	  := PARAMIXB[2]   
Local aArea   := GetArea()
Local _RegSC7 := SC7->(Recno())

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If nTipo = 1 //Pedido de Compras
	If SC7->C7_RATEIO = '1' 
		dbSelectArea("SCH")
		dbSetOrder(2)	//CH_FILIAL+CH_PEDIDO+CH_ITEMPD
		dbGoTop()
		If dbSeek ( xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM)
		PCOINILAN("999012")										
			While !SCH->(EOF()) .and. SCH->CH_FILIAL + SCH->CH_PEDIDO + SCH->CH_ITEMPD == xFilial("SCH") + SC7->C7_NUM + SC7->C7_ITEM
				Begin Transaction											
					PCODETLAN("999012","01","MT235G2")
				End Transaction  
				SCH->(dbSkip())		   	
		   	EndDo
		PCOFINLAN("999012")										
		EndIf
	EndIf
EndIf

RestArea(aArea)
dbSelectArea("SC7")
SC7->(dbGoto(_RegSC7))

Return(.T.)