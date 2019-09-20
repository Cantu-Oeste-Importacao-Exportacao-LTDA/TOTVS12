#include "PROTHEUS.CH"
#include "RWMAKE.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSD2460    ºAutor  ³Rafael Parma       º Data ³  10/02/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ P.E. utilizado para gravar dados de segmento, centro de cus-±±
±±º          ³ to e item contabil no item do documento de devolução com   º±±
±±º          ³ base nos dados do documento de entrada de origem.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------*
User Function MSD2460()
*---------------------------*                       
Local aArea   := GetArea()
Local cConta	:= "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//-- Documento devolução
	If SD2->D2_TIPO == "D"  
	
		dbSelectArea("SD1")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek ( xFilial("SD1") + SD2->D2_NFORI + SD2->D2_SERIORI + SD2->D2_CLIENTE + SD2->D2_LOJA + SD2->D2_COD + SD2->D2_ITEMORI )
			If RecLock("SD2",.F.)
				SD2->D2_CLVL    := SD1->D1_CLVL
				SD2->D2_CCUSTO  := SD1->D1_CC
				SD2->D2_ITEMCC  := SD1->D1_ITEMCTA
				SD2->(MsUnLock())
			EndIf		
		EndIf      

	EndIf
	
	//--Atualização da conta contábil de acordo com a operação do pedido.
	dbSelectArea("SC6")
	dbSetOrder(1) 	//C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
	If dbSeek ( xFilial("SC6") + SD2->D2_PEDIDO + SD2->D2_ITEMPV )
		If ! Empty(SC6->C6_X_OPER)
     
     //--Removida a chamada da função - 17/02/2014
		 //	cCONTA := U_RJCOMP12(2,SC6->C6_X_OPER,SD2->D2_CLIENTE,SD2->D2_LOJA,If(SD2->D2_TIPO$'DB',"F","C"),SD2->D2_COD)
			If ALLTRIM(cCONTA) != ""
				If RecLock("SD2",.F.) 
					SD2->D2_CONTA := cCONTA
					SD2->(MsUnLock())
				EndIf
			EndIf
			
		EndIf	
	EndIf	
	
	RestArea(aArea)
		
Return