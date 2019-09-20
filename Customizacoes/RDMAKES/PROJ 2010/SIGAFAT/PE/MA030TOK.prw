#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
                           
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA030TOK  �Autor  �TOTVS PARANA CENTRAL� Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Valida��o na altera��o do cadastro de clientes.             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �RJU                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*---------------------------------------------------------------------------*
User Function MA030TOK()
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea()
Local lRet := .T. 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())  
                                                                         
	//--Demais valida��es devem ser adicionadas acima...
	If ALTERA .AND. lRet	
		//--Chamada da rotina para grava��o de logs de altera��o de registros
	 	If !IsBlind()
			RptStatus({|lEnd| U_RJLOGCHK("SA1", SA1->(RECNO()), SA1->(A1_FILIAL+A1_COD+A1_LOJA), @lEnd)}, "Aguarde...","Atualizando logs de altera��o...", .T.)
		Else
			U_RJLOGCHK("SA1", SA1->(RECNO()), SA1->(A1_FILIAL+A1_COD+A1_LOJA) )
		EndIf
	EndIf      
	
	RestArea(aAreaTMP)
	
Return (lRet)  