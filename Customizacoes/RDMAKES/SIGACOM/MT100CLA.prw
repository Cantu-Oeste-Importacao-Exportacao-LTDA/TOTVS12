#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT100CLA     �Autor  �TOTVS II         � Data �  22/01/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada executado ao clicar na op��o classifica��o���
���          � do documento de entrada                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�ficos Cantu                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------*
User Function MT100CLA()
*------------------------*

Local aArea   := GetArea()
Local cNfOri  := ""
Local cQuery  := ""
Local cChave  := SF1->F1_FILIAL + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA
Local cForne  := SF1->F1_FORNECE
Local cLoja   := SF1->F1_LOJA
Local cMsgTmp := ""  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If Trim(SF1->F1_ESPECIE) == "CTE"

	DbSelectArea("SD1")
	SD1->(DbSetOrder(1))
	If DbSeek(cChave)
		If !Empty(SD1->D1_NFORI)
			cNfOri  := SD1->D1_NFORI
			cSerOri := SD1->D1_SERIORI
		EndIf
		
		cQuery := "select d1_serie, d1_doc from "+ RetSqlName("SD1") +" d1 "
		cQuery += "where d1.d_e_l_e_t_ = ' ' "
		cQuery += "  and d1.d1_nfori   = '"+ cNfOri +"' "
		cQuery += "  and d1.d1_seriori = '"+ cSerOri +"' "
		cQuery += "  and d1.d1_fornece = '"+ SF1->F1_FORNECE +"' "
		cQuery += "  and d1.d1_loja    = '"+ SF1->F1_LOJA +"' "
		cQuery += "  and d1.d1_doc    <> '"+ SF1->F1_DOC +"' "
		
		TcQuery cQuery new alias "d1temp"
		
		DbSelectArea("d1temp")
		d1temp->(dbGoTop())
		
		If !d1temp->(EOF())
			While !d1temp->(EOF())
				cMsgTmp += d1temp->d1_serie + "  " + d1temp->d1_doc + CHR(13)+CHR(10)
				d1temp->(DbSkip())
			EndDo
		EndIf
		
		d1temp->(DbCLoseArea())
		
	EndIf
	
	If !Empty(cMsgTmp)
		Aviso("Encontrei outros CTEs referente � mesma NF de origem:", cMsgTmp, {"Ok"}, 3)
	EndIf
	
EndIf

RestArea(aArea)
Return