#include "rwmake.ch"     
#include "topconn.ch"

//O ponto de entrada FA330CMP � utilizado ap�s a confirma��o dos t�tulos selecionados.
//Guilherme 17/06/13 para fazer movimenta��es do PEFIN atrav�s da rotina de compensa��es.      
User Function FA330CMP()
Local cMotBx	:= "02" // "02 � Pagamento da d�vida" 
Local aArea		:= GetArea()                            
Local nTotal  := 0      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

For i:=1 to Len(aTitulos)
  If (ValType(aTitulos[i][9]) == 'N')
		nTotal += aTitulos[i][9] // Soma do total a ser baixado para verificar se a nota original vai ser baixada total				
	Endif	
Next i  

If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO >= nTotal) 
	SE1->(Reclock("SE1",.F.))
	SE1->E1_PEFINMB := cMotBx	                    //Nota original a ser compensada.
	SE1->(MsUnlock("SE1"))  
	
	For i:=1 to Len(aTitulos)
		cNum   := aTitulos[i][2] // Numero
		cPrfx  := aTitulos[i][1] // Prefixo
		cParce := aTitulos[i][3] // parcela
		cTipo	 := aTitulos[i][4] // Tipo
		dbSelectArea("SE1")
		dbSetOrder(1)
		If dbseek(xFilial("SE1")+cPrfx+cNum+cParce+cTipo)	
			If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) 
				SE1->(Reclock("SE1",.F.))
				SE1->E1_PEFINMB := cMotBx	
				SE1->(MsUnlock("SE1")) 
			Endif		                //verifica��o dos titulos da SE1 que vao ser compensados na nota de origem, mas tem que verificar a rotina do PEFIN
		EndIf	
	Next i		
Endif

RestArea(aArea)	

Return