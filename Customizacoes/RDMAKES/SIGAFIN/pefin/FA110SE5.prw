//O ponto de entrada FA110SE5 ser� utilizado na grava��o de 
//dados complementares na baixa a receber autom�tica. Ser� executado ap�s gravar o SE5.

User Function FA110SE5()
Local cMotBx	:= "01" // "01 � Pagamento da d�vida" 
Local aArea		:= GetArea()       

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())                                                                   

If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)
  		SE1->(Reclock("SE1",.F.))
			SE1->E1_PEFINMB := cMotBx	
		  SE1->(MsUnlock("SE1")) 
Endif

RestArea(aArea)

Return()