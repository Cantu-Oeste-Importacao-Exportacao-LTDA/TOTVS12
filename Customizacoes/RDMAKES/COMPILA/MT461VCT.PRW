



/*/{Protheus.doc} MT461VCT
Alteração no vencimento e valor do título

	aVencto - Observações
	Estrutura do array aVencto
	[1]Título
	[1][1]Data do Vencimento
	[1][2] Valor da Parcela
@author Augusto Ribeiro | www.compila.com.br
@since 02/01/2019
@version undefined
@param param
@return aVencto(array_of_record), rray contendo os novos vencimentos, deverá enviar data de vencimento e valor de cada parcela.


@example
(examples)
@see (links_or_references)
/*/
User Function MT461VCT()
Local aParam	:= PARAMIXB
Local aRet		:= {}
Local nI, nY
Local nTotParc	:= 0

aRet	:= PARAMIXB[1]
aRetAux	:= ParcForma(aParam)
IF LEN(aRetAux) > 0
	aRet	:= ACLONE(aRetAux)
ENDIF

Return(aRet)




/*/{Protheus.doc} ParcForma
Retorna parcelas de acordo com a forma de pagamento
@author Augusto Ribeiro | www.compila.com.br
@since 02/01/2019
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function ParcForma(aParam)
Local  aRet		:= {}
Local aArea		:= getArea()
Local aAreaZE1	:= ZE1->(getArea())
Local nI, nY
Local nTotParc := 0
Local nVlrParc := 0 
Local nQtdParc	:= 0 
Local nQtdPrazo	:= 30

IF LEN(aParam) > 0

	DBSELECTAREA("ZE1")
	ZE1->(DBSETORDER(1)) //| 
	cChvPed	:= SC5->C5_FILIAL+SC5->C5_NUM 
	IF ZE1->(DBSEEK(cChvPed )) 
	

		/*--------------------------------------------------
			Somar Valor total das parcelas originais
		
		FOR nI := 1 to len(aParam[1])
			FOR nY := 1 to len(aParam[1,nY])
				nTotParc += aParam[1,nY,2]	
			NEXT nY	
		next nI	
		---------------------------------------------------*/		
	
		WHILE ZE1->(!EOF()) .and. cChvPed == ZE1->ZE1_FILIAL+ZE1->ZE1_PEDIDO 
			
			nVlrParc	:= ZE1->ZE1_VALOR/ZE1->ZE1_QTDE
			
			FOR nI := 1 TO ZE1->ZE1_QTDE
				nQtdPrazo	:= 30
				IF ALLTRIM(ZE1->ZE1_FORMPG) == "CD"
					nQtdPrazo	:= 2	
				ENDIF
			
				aadd(aRet, {dDataBase+(nI*nQtdPrazo), nVlrParc})
			NEXT nI
		
			ZE1->(DBSKIP()) 
		ENDDO
			
	ENDIF

ENDIF


RestArea(aAreaZE1)
RestArea(aArea)

Return(aRet)


