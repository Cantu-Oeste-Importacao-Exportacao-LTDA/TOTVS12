#include "rwmake.ch"     
#include "topconn.ch"  

//O ponto de entrada F460SE1 sera utilizado para informar dados necessarios à gravacao complementar, dos titulos gerados apos a liquidacao
//Guilherme 12/06/2013

User Function F460SE1()
Local cMotBx	:= "02" // "02 – Pagamento da dívida" 
Local aArea		:= GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                          

If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. Empty(AllTrim(SE1->E1_PEFINMB)) .AND. (SE1->E1_SALDO == 0)			
  		SE1->(Reclock("SE1",.F.))
			SE1->E1_PEFINMB := cMotBx	
		  SE1->(MsUnlock("SE1")) 
Endif

RestArea(aArea)

Return