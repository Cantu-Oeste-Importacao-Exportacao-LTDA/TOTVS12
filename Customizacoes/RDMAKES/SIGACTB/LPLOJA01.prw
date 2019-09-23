#include "protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LPFATLJ01  �Autor  �Regis Stucker     � Data �  24/01/2011 ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte para verificar a forma de pagamento utilizado        ���
���          � na venda do SigaLoja.                                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Lan�amento Padr�o - Faturamento / Cantu                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LPLOJA01(cPar)

Local nVlr 		:= 0
Local hEnter	:= CHR(10) + CHR(13) 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())  

cQuery := ""
cQuery += "SELECT SUM(E1_VALOR) nSoma FROM " + RetSqlName("SE1") +   " E1  " + hEnter  
cQuery += "WHERE E1_FILIAL = '" + xFilial("SE1")  +"'             " + hEnter

if cPar $ "CC/CD"
 cQuery += "  AND (E1_ORIGEM  = 'LOJA701' OR E1_ORIGEM = 'LOJA010')                  " + hEnter
Else
 cQuery += "  AND E1_CLIENTE = '" + SF2->F2_CLIENTE +"'           " + hEnter
 cQuery += "  AND E1_LOJA  = '" + SF2->F2_LOJA   +"'           " + hEnter  
EndIf

cQuery += "  AND E1_PREFIXO = '" + SF2->F2_SERIE   +"'             " + hEnter
cQuery += "  AND E1_NUM    = '" + SF2->F2_DOC     +"'              " + hEnter

If cPar $ "R$/DP/FI/CH/CC/CD"       
 cQuery += "  AND E1_TIPO  = '" + cPar            +" '              " + hEnter 
Else
 cQuery += "  AND E1_TIPO NOT IN ('R$ ','DP ','FI ','CH ','CC ','CD ')    " + hEnter 
EndIf

cQuery += "  AND D_E_L_E_T_ = ' '                        " + hEnter         

TCQUERY cQuery NEW ALIAS "SE1FIL"
//Aviso("sql",cQuery,{"Ok"},3)
SE1FIL->(DbGotop())

 nVlr := SE1FIL->nSoma

DBCloseArea("SE1FIL")

Return (nVlr)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP620001  �Autor  �Jean C. P. Saggin   � Data �  26/08/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Lp Criado pra retornar tipo do t�tulo no SE1               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICOS CANTU ALIMENTOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*---------------------------*
User Function RETTPTIT()
*---------------------------*

Local aArea := GetArea()
Local cRet  := ""

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())  

DbSelectArea("SE1")
SE1->(DBSetOrder(2))

If SE1->(DbSeek(xFilial("SE1") + SF2->F2_CLIENTE + SF2->F2_LOJA + SF2->F2_SERIE + SF2->F2_DOC ))
	cRet := SE1->E1_TIPO	
EndIf

RestArea(aArea)

Return cRet






