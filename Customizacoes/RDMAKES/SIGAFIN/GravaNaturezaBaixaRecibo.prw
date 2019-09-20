#include "rwmake.ch"

/*********************************************************
 Fonte para gravar a natureza no se5, quando efetuada baixa por recibo,
 devido a muitas vezes este valor n�o ser gravado no se5.
 *********************************************************/
 
/*********************************************************
 PE executado ap�s gravar cada baixa
 *********************************************************/ 
//Guilherme 14/06/13 para sinalizar os titulos com PEFIN baixados pela rotina de recebimentos diversos. 
User Function FA087BAIXA()   
Local cMotBx	:= "02" // "02 � Pagamento da d�vida" 
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

Return Nil
  
Static Function GrvNatRecibo()
Local cNatureza := SEL->EL_NATUREZ

if !Empty(cNatureza)
	RecLock("SE5")
	SE5->E5_NATUREZ := cNatureza
	SE5->(MsUnlock())
EndIf

Return .T.