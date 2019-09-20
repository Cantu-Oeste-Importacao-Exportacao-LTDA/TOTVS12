#include "rwmake.ch"     
#include "topconn.ch"

//O ponto de entrada FA330EAC é  utilizado na exclusão de compensação de contas a receber, antes da contabilização.
//Guilherme 18/06/13 para tratar os titulos conpensados e limpar  a flag do motivo de baixa do PEFIN se houver.
User Function FA330EAC()
Local cMotBx	:= "02" // "02 – Pagamento da dívida" 
Local aArea		:= GetArea()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                          

DbSelectArea("SE1")
dbSetOrder(2)
If Dbseek(xFilial("SE1")+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO)                                                       
	If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. !Empty(AllTrim(SE1->E1_PEFINMB)) .AND. Empty(AllTrim(SE1->E1_PEFINEX))
		RecLock("SE1",.F.)
		SE1->E1_PEFINMB := Space(6)
		MsUnlock("SE1")   
	Endif 
EndIf	    

RestArea(aArea)	

Return 