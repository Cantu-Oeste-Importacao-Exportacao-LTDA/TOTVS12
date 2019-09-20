#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

// Ultimo Fechamento + MV_DIASBLQ menor ou igual a Date() ' Bloqueia movimentações.
// Para fazer o agendamento :
// U_BLQMOV({'AA','BB'})  
// 'AA' = EMPRESA
// 'BB' = FILIAL INICIAL      


User Function BlqMov(aParm)
Local aFils	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If	Select('SX2') == 0						
	RPCSetType( 3 )					
	RpcSetEnv(aParm[1,1],aParm[1,2],,,,GetEnvServer(),{ })
    DbSelectArea("SM0")
    SM0->(DbGotop())
    While !SM0->(Eof())
		aAdd(aFils,{SM0->M0_CODIGO,SM0->M0_CODFIL})
    	SM0->(DbSkip())
    End 
    For nR := 1 To Len(aFils)
		RpcSetEnv(aFils[nR,1],aFils[nR,2],,,,GetEnvServer(),{ })
		If SuperGetMv("MV_ULMES")+SuperGetMv("MV_BLQDIAS",,365) <= Date()
			PutMv("MV_DBLQMOV",Date())  
		Endif
		RpcClearEnv() // Zera ambiente para possibilitar o posicionamento na proxima filial.
    Next nR
EndIf

Return  