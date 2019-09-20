User Function FA070CAN() 

local lMVXINTSF	:= .F.
local lMVXSFJOB	:= .F.
                    
// Se o titulo foi enviado ao SERASA PEFIN e houver um motivo de BAIXA DO SERASA e 
// ainda não foi solicitado ao SERASA a exclusão do titulo, libero novamente o preenchimento to motivo de baixa PEFIN.

If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. !Empty(AllTrim(SE1->E1_PEFINMB)) .AND. Empty(AllTrim(SE1->E1_PEFINEX))
	RecLock("SE1",.F.)
		SE1->E1_PEFINMB := Space(6)
	MsUnlock("SE1")   
Endif


	/*
	
	Restaura o saldo do titulo para para Salesforce quando cancelada a baixa
	
	@author devair.tonon
	@since 13/02/2015
	@version 1.0
	
	*/ 
	lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	
	if FindFunction("U_SFTIT001") .and. lMVXINTSF
		if lMVXSFJOB                                                                       
			StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
		else
			U_SFTIT001()
		endif
	endif

Return Nil