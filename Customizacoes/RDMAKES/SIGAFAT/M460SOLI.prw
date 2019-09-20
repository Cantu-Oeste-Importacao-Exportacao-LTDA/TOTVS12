#INCLUDE "rwmake.ch"

User Function M460SOLI()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())	


//alert("Executando o ponto de entrada M460SOLI")
_nbsoli := 0 											// BASE DO ICMS SOLIDARIO
_nvsoli := 0                                            // VALOR DO ICMS SOLIDARIO
_soli2 := array(3)                                      // VETOR VAZIO PARA RETORNO

If !GetMV("MV_CONSFIN")
    // Retorna o vetor fazio
    return(_soli2)
Endif

if SC5->C5_RETICM == "1" .and. !Empty(sa1->a1_inscr) .and. SF4->F4_ICM=="S"

	_soli := array(2)										// VETOR DE RETORNO DO ICMS SOLIDARIO ( BASE E VALOR )
	
	nAliqInt :=DaAliqDest(SA1->A1_EST)
	
	nPerIcm2 := AliqIcms(SC5->C5_TIPO,'S',SC5->C5_TIPOCLI)
	
	If nAliqInt <> nPerIcm2
	
		_NBSOLI := ((IcmsItem * 100)/nPerIcm2)
		_NVSOLI := ABS ((_NBSOLI * (nAliqInt/100)) - (_NBSOLI * (nPerIcm2/100)))
	Endif
	
	if _nbsoli <= 0                                         // SE BASE NEGATIVA ZERA OS VALORES
	   _nbsoli := 0
	   _nvsoli := 0
	endif   
	
	_soli[1] := _NBSOLI
	_soli[2] := _NVSOLI

else
	// Retorna o vetor fazio
    return(_soli2)
endif
	                       
Return(_soli)											// RETORNO DA FUNCAO
                                                                             

Static Function DaAliqDest(cEstCliFor)

nPerIcm2:=Val(Subs(GetMV("MV_ESTICM"),AT(cEstCliFor,GetMV("MV_ESTICM"))+2,2))

Return(nPerIcm2)
