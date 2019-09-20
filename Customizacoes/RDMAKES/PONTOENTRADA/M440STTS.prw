#include "rwmake.ch"

//-----------------------
// Ponto de entrada para apos a confirmacao do pedido ou liberacao do mesmo libere o estoque automaticamente
// independente se tenha estoque ou nao, pois a empresa trabalha com estoque negativo
// Data Criacao: 16/06/05
//-----------------------
User Function M440STTS()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	U_LibEstoque()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se pedido esta liberado e seta flag.             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	lRet := .F.
	MsAguarde( {|| lRet := U_RJCHKSC9(SC5->C5_NUM) }, "Verificando liberação do pedido... Aguarde!")		
	If lRet
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "N"
			SC5->(MsUnLock())				
		EndIf
	Else
		If RecLock("SC5",.F.)
			SC5->C5_X_BLQ := "S"
			SC5->(MsUnLock())				
		EndIf	
	EndIf
	
		
Return .t.



User Function LibEstoque()
Local _PedidoSC5 := SC5->C5_NUM                                 
ConOut("Liberação de estoque para o pedido - Teste")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If AllTrim(Upper(GetMv("MV_LIBESTA"))) == "S"
   dbSelectArea("SC9")
   dbSetOrder(1)                        
   dbGotop()
   If dbSeek(xFilial("SC9") + _PedidoSC5)
      While !SC9->(eof()) .AND. SC9->C9_FILIAL + SC9->C9_PEDIDO == xFilial("SC9") + _PedidoSC5
            RecLock("SC9",.f.)
            SC9->C9_BLEST := "  "
            SC9->(MsUnlock())
            dbSelectArea("SC9")
            dbSetOrder(1)                        
            SC9->(dbSkip())
      EndDo 
   Endif
Endif
Return .T.