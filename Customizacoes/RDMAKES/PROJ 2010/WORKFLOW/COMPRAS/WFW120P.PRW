/*
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ WFW120P  ¦ Autor ¦   LINCOLN P. ROSSETTO ¦ Data ¦ 16/04/08 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ "Ponto de entrada que é executado após a geração de um     ¦¦¦
¦¦¦          ¦ Pedido de Compra que envia o Workflow para os aprovadores  ¦¦¦
¦¦¦          ¦ para serem liberadas ou não.                               ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦---ALTERAÇÕES-----------------------------------------------¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦¦          ¦                                                            ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico para CANTU.                                     ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Sol. Cust.¦ 04186080415-01                                             ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
*/
USER FUNCTION WFW120P() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* Rafael - 04/01/2011 
	Chamada da função de envio de workflow no ponto de entrada MT120FIM
	EXECBLOCK("CTMAT01",.F.,.F.)
*/

RETURN