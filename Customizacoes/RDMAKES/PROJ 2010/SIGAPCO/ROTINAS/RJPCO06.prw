#INCLUDE "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � RJPCO06 � Autor � Joel Lipnharski       �Data � 27/05/2011 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � FUNCAO PARA TRATAR A GERACAO DOS LANCAMENTOS DO PCO         ��
���          � NAS REVISOES DO MOD. GESTAO DE CONTRATOS                    ��
�������������������������������������������������������������������������Ĵ��
���Uso		 � CANTU                             	    				  ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function RJPCO06()

Local aAlias    := GetArea()    

Local cFil     := CNF->CNF_FILIAL
Local cCont    := CNF->CNF_CONTRA
Local cRev     := CNF->CNF_REVISA 
Local cRevAnt  := ""
Local cNum     := CNF->CNF_NUMERO
Local cParc    := CNF->CNF_PARCEL     
Local nRet     := CNF->CNF_VLPREV

Local _Reg     := CNF->(Recno())
Local _Ind     := CNF->(IndexORD())  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
     
If !Empty(cRev)
	cRev := val(cRev)
	cRevAnt := STRZERO(cRev-1,3)
EndIf

If !Empty(cRevAnt)
	If cRevAnt = '000'
		cRevAnt := '   '
	EndIf
	DbSelectArea("CNF")         	
	DbSetOrder(3)
	DbGoTop()
	If DbSeek(cFil+cCont+cRevAnt+cNum+cParc)
		nRet := CNF->CNF_SALDO
	EndIf
EndIf
         
DbSelectArea("CNF")
DbSetOrder(_Ind)
DbGoTo(_Reg)

RestArea(aAlias)

RETURN nRet