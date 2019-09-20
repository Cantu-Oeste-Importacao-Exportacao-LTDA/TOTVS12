#include "totvs.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA330BX   � Autor � DEVAIR F TONON     � Data �  28/04/15  ���
�������������������������������������������������������������������������͹��
���Descricao � O ponto de entrada FA330BX est� dispon�vel para            ��� 
���          � acesso ao dados dos t�tulos a receber que ser�o baixados.  ���     	
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro / Salesforce                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F330VEEX  � Autor � DEVAIR F TONON     � Data �  28/04/15  ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada para grava��o de dados ao Excluir e       ��� 
���          � Estornar a compensa��o de t�tulos a Receber                ���     	
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro / Salesforce                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
user function F330VEEX() //ap�s confirma��o do estorno
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FA330SE1  � Autor � DEVAIR F TONON     � Data �  28/04/15  ���
�������������������������������������������������������������������������͹��
���Descricao � O ponto de entrada FA330SE1 � utilizado na gravacao        ��� 
���          � complementar do SE1 na compensacao.                        ���     	
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro / Salesforce                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � F330DESC  � Autor � DEVAIR F TONON     � Data �  28/04/15  ���
�������������������������������������������������������������������������͹��
���Descricao � Define se na compensa��o de t�tulos a receber � calculado  ��� 
���          � o desconto financeiro. Para o c�culo do desconto � levado  ���     	
���          � em considera��o o percentual de desconto informado no      ���
���          � campo E1_DESCFIN. Esta opera��o de desconto em compensa��o ���
���          � � uma particularidade do M�dulo OMS.                       ���
���          �                                                            ���
���          � ESSE PE S� ESTA SENDO USADO PARA TRATAR ESTORNO DE COMPEN  ���
���          � SA��O DE TITULO PARA ENVIAR AO SALESFORCE                  ���
�������������������������������������������������������������������������͹��
���Uso       � Financeiro / Salesforce                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
