/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ7014    �Autor  �Joel Lipnharski     � Data �  11/08/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �PE para n�o ativar an�lise de cr�dito Controle de Lojas     ���
���          �caso a Forma de Pagamento seja R$, CC, CD                   ���
���          �se alguma das parcelas n�o for R$, CC, CD efetua a an�lise  ���
�������������������������������������������������������������������������͹��
���Uso       � GRUPO CANTU                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LJ7014()

Local bReturn := .T.
Local nPos    := 0

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())                       

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - LJ7014 - " + "INICIO")
                                 
For nPos := 1 to Len( aPgtos )
	If aPgtos[ nPos ][3] $ "R$/CC/CD"
		bReturn := .F.
	Else
	    bReturn := .T.
	EndIf
Next nPos

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - LJ7014 - " + "FIM")

Return (bReturn)