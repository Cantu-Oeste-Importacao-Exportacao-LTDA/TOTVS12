#include "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA330BX   º Autor ³ DEVAIR F TONON     º Data ³  28/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ O ponto de entrada FA330BX está disponível para            º±± 
±±º          ³ acesso ao dados dos títulos a receber que serão baixados.  º±±     	
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Salesforce                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
                       
user function FA330BX()    
    local	lMVXINTSF	:= .F.
    local 	lMVXSFJOB	:= .F.
    
     
	//se titulos marcados no markbrowse for NF ira processar  
	lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	
	if alltrim(SE1->E1_TIPO) == "NF"
		if FindFunction("U_SFTIT001") .and. lMVXINTSF
			if lMVXSFJOB                                                                       
				StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
			else
				U_SFTIT001()
			endif
		endif
	endif
	
return
      

// 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F330VEEX  º Autor ³ DEVAIR F TONON     º Data ³  28/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada para gravação de dados ao Excluir e       º±± 
±±º          ³ Estornar a compensação de títulos a Receber                º±±     	
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Salesforce                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function F330VEEX() //após confirmação do estorno
    local aAreaSE1 := SE1->(GETAREA())
    local	lMVXINTSF	:= .F.
    local 	lMVXSFJOB	:= .F.
    
	//se no estorno, os titulos escolhidos no markbrowse for tipo NF
      
	lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	                                                		
	if alltrim(SE1->E1_TIPO) == "NF"
		if FindFunction("U_SFTIT001") .and. lMVXINTSF
			if lMVXSFJOB                                                                       
				StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
			else
				U_SFTIT001()
			endif
		endif
	endif             
	
	RestArea(aAreaSE1)
	
return 


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ FA330SE1  º Autor ³ DEVAIR F TONON     º Data ³  28/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ O ponto de entrada FA330SE1 é utilizado na gravacao        º±± 
±±º          ³ complementar do SE1 na compensacao.                        º±±     	
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Salesforce                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function FA330SE1()
     
    local	lMVXINTSF	:= .F.
    local 	lMVXSFJOB	:= .F.
    
    lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	
	if alltrim(SE1->E1_TIPO) == "NF"
		if FindFunction("U_SFTIT001") .and. lMVXINTSF
			if lMVXSFJOB                                                                       
				StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
			else
				U_SFTIT001()
			endif
		endif
	endif
	
return        


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ F330DESC  º Autor ³ DEVAIR F TONON     º Data ³  28/04/15  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Define se na compensação de títulos a receber é calculado  º±± 
±±º          ³ o desconto financeiro. Para o cáculo do desconto é levado  º±±     	
±±º          ³ em consideração o percentual de desconto informado no      º±±
±±º          ³ campo E1_DESCFIN. Esta operação de desconto em compensação º±±
±±º          ³ é uma particularidade do Módulo OMS.                       º±±
±±º          ³                                                            º±±
±±º          ³ ESSE PE SÓ ESTA SENDO USADO PARA TRATAR ESTORNO DE COMPEN  º±±
±±º          ³ SAÇÃO DE TITULO PARA ENVIAR AO SALESFORCE                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Salesforce                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user function F330DESC()
	local aAreaSE1 := SE1->(GETAREA())    
	local lMVXINTSF	:= .F.
    local lMVXSFJOB	:= .F.
    
    
    lMVXINTSF := GetMv('MV_X_INTSF', .F. ,.F.)
	lMVXSFJOB := GetMv('MV_X_SFJOB', .F. ,.F.)
	                                                  			
	if alltrim(SE1->E1_TIPO) == "NF"
		if FindFunction("U_SFTIT001") .and. lMVXINTSF
			if lMVXSFJOB                                                                       
				StartJob('U_SFTIT001',GetEnvServer(),.F., SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, lMVXSFJOB, cEmpAnt, SE1->E1_FILIAL )       
			else
				U_SFTIT001()
			endif
		endif
	endif


    RestArea(aAreaSE1)
    
    /*
     
     O RETORNO DEVE SEMPRE .F. PARA NAO SOMAR O DESCONTO FINANCEIRO NO SALDO QUANDO ESTORNAR A COMPENSACAO. EXCETO SE HOUVER REGRA FINANCEIRA
     PARA SOMAR, SE HOUVER O RETORNO DEVE SER .T.
     
    */
return .F.
