#Include 'Protheus.ch'


/*/{Protheus.doc} cpoCard
Gravar informações complementares no Titulo do conta
a receber pelo o Venda direta.
@author Fabio Sales | www.compila.com.br
@since 13/01/2019
@version undefined
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/

User Function LJDEPSE1()

	//|Local aParcelas := PARAMIXB[1]
	
	Local alAreaAll	:= {}
	Local alAreaSL1	:= {}	
	Local alAreaSL4	:= {}	
	
	IF SE1->E1_TIPO == "CC" .OR. SE1->E1_TIPO == "CD" 
	
		alAreaAll	:= GetArea
		alAreaSL1	:= SL1->(GetArea)	
		alAreaSL4	:= SL4->(GetArea)
		
		DBSELECTAREA("SL1")
		SL1->(DBSETORDER(2)) //| L1_FILIAL + L1_SERIE + L1_DOC + L1_PDV
		
		IF SL1->(DBSEEK(SE1->E1_FILIAL + SE1->E1_PREFIXO + SE1->E1_NUM ))
			
			clFilSL1	:= SL1->L1_FILIAL
			clNumSL1	:= SL1->L1_NUM
			
			DBSELECTAREA("SL4")
			SL4->(DBSETORDER(1)) //| L4_FILIAL + L4_NUM + L4_ORIGEM
						
			IF SL4->(DBSEEK(clFilSL1 + clNumSL1))								
										
				WHILE SL4->(!EOF) .AND. clFilSL1 == SL4->L4_FILIAL .AND. clNumSL1 == SL4->L4_NUM
				
					IF SE1->E1_DOCTEF == SL4->L4_DOCTEF .AND. SE1->E1_NSUTEF == SL4->L4_NSUTEF .AND. EMPTY(SE1->E1_XCODAUT)
					
						SE1->(RecLock("SE1",.F.))
								 					 			
							SE1->E1_XCODAUT := SL4->L4_AUTORIZ
							
		 				SE1->(MsUnLock())
		 				
		 				Exit
		 				
					ENDIF
					
					SL4->(DBSKIP())
				ENDDO
			
			ENDIF
						
		ENDIF	
		
		RestArea(alAreaAll)
		RestArea(alAreaSL1)
		RestArea(alAreaSL4)
		
	ENDIF	

Return