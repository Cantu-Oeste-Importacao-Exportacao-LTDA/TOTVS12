#INCLUDE "rwmake.ch"

/** 
	Esse PE substitui o filtro padrão do sistema, inclusive o PE M450FIL.
**/

User Function M450FLB()  

/*
If MV_PAR01 == 1
	//_cCond := '(C9_BLCRED=="01".Or.C9_BLCRED=="04".Or.C9_BLCRED == "09")'
	_cCond := '(C9_BLCRED $ "01/04/09")'
EndIf
*/

Local cCondicao := '(dTos(C9_DATALIB)>="'+DTOS(dDataBase-02)+'")'

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MV_PAR01 == 1 .or. mv_par01 == 3 
	If ( mv_par01 == 1 )
		cCondicao+=' .And. (C9_BLCRED $ "01/04")'
	ElseIf (mv_par01 == 3)
		cCondicao+=' .And. (C9_BLCRED $ "01/04/09")'
	Endif
EndIf

Return (cCondicao)