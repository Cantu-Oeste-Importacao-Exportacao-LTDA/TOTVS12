/*************************************************************
Ponto de entrada utilizado para carregar as variaveis do fluxo
de caixa na hora de visualizar os pedidos no momento de fazer
a liberação do mesmo.

Guilherme Poyer	
09-09-11
**************************************************************/

User Function MT097FIL() 
Local cRet 
Public __aPARCPED := {}			// Array de parcelas (vencimento + valor)
Public __cNUMPEDC := Space(06)	// Número do pedido
Public __cCPGPEDC := Space(03)	// Código condição de pagamento
Public __cFILPEDC := Space(02)	// Código filial
Public __nVALPEDC := 0			// Valor total pedido

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return (cRet)