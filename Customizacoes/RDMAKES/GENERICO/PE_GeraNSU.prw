#include "rwmake.ch" 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PE_GERANSU�Autor  �Flavio Dias         � Data �  08/01/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gera�ao do NSU para SC                                     ���
���          � Pontos de entrada de nf de sa�da e entrada                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Nota fiscal de sa�da
User Function MTASF2()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())

U_GeraNSU(SF2->F2_DOC, SF2->F2_Serie, SF2->F2_Cliente, SF2->F2_LOJA, SF2->F2_EMISSAO, SF2->F2_HORA, "S", "")

Return Nil

// Nota fiscal de entrada

*------------------------*
User Function MT100AGR()             
*------------------------*

Local aArea := GetArea()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())

//���������������������������������������������������������������������Ŀ
//�02/06/15 - VALIDA SE FOI CHAMADO PELA CLASSIFICA��O AUTOMATICA DE CTE�
//�����������������������������������������������������������������������

If !ISINCALLSTACK("U_SCHCLACTE")

	// so gera se for formulario proprio
	if (SF1->F1_FORMUL == "S")
	  U_GeraNSU(SF1->F1_DOC, SF1->F1_Serie, SF1->F1_FORNECE, SF1->F1_Loja, SF1->F1_EMISSAO, Left(Time(), 5), "E", "")
	EndIf
	RestArea(aArea)
	
	//�����������������������
	//�Rotina de Armazenagem�
	//�����������������������
	
	U_GERAARMAZENAGEM()
	
	/*
	���������������������������������������������`���������������������������ͻ��
	���Programa  �SF1100I   �Autor  �Roberto Rosin        � Data � 12/03/2013 ���
	���Desc.     �Verifica se na nota de venda teve desconto e atualiza esse  ���
	���          �desconto na nota fiscal de entrada para contabiliza��o      ���
	�������������������������������������������������������������������������͹��
	*/
	aArea := getArea()
	If SF1->F1_TIPO == "D"
		dbSelectArea("SD1")
		SD1->(dbSetOrder(1))
		SD1->(dbGoTop())
		SD1->(dbSeek(SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA))
		While(SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
			
			//nPercDecre := posicione("SD2", 3, xFilial("SD2") + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI, "D2_X_PDECR")
			nPercDecre := 0
			cTipoDecre := ""
			dbSelectArea("SD2")
			dbSetOrder(3)
			dbGoTop()
			If dbSeek(SD1->D1_FILIAL + SD1->D1_NFORI + SD1->D1_SERIORI + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_COD + SD1->D1_ITEMORI)
				nPercDecre := SD2->D2_X_PDECR
				cTipoDecre := SD2->D2_X_TPDEC
			EndIf
			
			If nPercDecre != 0
				nDecrec := Round(SD1->D1_TOTAL * (nPercDecre / 100), 2)
				RecLock("SD1", .F.)
				SD1->D1_X_DECRE := nDecrec
				SD1->D1_X_PDECR := nPercDecre
				SD1->D1_X_TPDEC := cTipoDecre
				SD1->(MsUnlock()) 
			EndIf
					
			SD1->(dbskip())
		EndDo
	EndIf

EndIf

restArea(aArea)

Return Nil