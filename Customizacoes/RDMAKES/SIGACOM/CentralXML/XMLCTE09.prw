#Include 'Protheus.ch'


/*/{Protheus.doc} XMLCTE09
(Ponto de entrada Central XML - no lançamento de Frete sobre Vendas - permite customização)
@type function
@author marce
@since 11/10/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function XMLCTE09()
	// Recebe o registro posicionada da SF2 
	Local	aNfOri		:= ParamIxb
	
	Local	nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
	Local	nPosOper	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_OPER"})
	Local	nPosCodPrd	:= 	aScan(aItem,{|x| AllTrim(x[1]) == "D1_COD"})
	Local	nPosClVl	:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CLVL"})
	Local	nPosCC		:=  aScan(aItem,{|x| AllTrim(x[1]) == "D1_CC"})
	Local	nLenItem	:= Len(aItem)
	// Variável aInfIcmsCte existe por causa da função sfVldAlqIcms que alimenta o array Private
	//aInfIcmsCte	:= {{"ICM","ICMS",nBaseIcms,nAliqIcms,nValIcms}}
	
	// Se não preencheu o campo TES - Por não ter TES inteligente configurado ou TES Padrão de entrada vazio no cadastro de produto
	If nPosTes == 0
		Aadd(aItem,{"D1_TES"  	,"038"  	,Nil})	
		nPosTes		:=	aScan(aItem,{|x| AllTrim(x[1]) == "D1_TES"})
		nLenItem	:= Len(aItem)
	Endif
	
	If nPosTes <> 0	
		If cEmpAnt+cFilAnt $ "0101"	// Se for empresa 01 / filial 01
			DbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+"IG060080")
			aItem[nPosCodPrd,2]		:= SB1->B1_COD				 	
		Endif	
			
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(aNfOri[1]+aNfOri[2]+aNfOri[3]+aNfOri[4]+aNfOri[5])
			// Regra 1 - Valor de ICMS destacado no CTe e valor de ICMS destacado na Nota fiscal
			// TES 038
			If aInfIcmsCTe[1,5] > 0 .And. SF2->F2_VALICM > 0				
				aItem[nPosTes,2] := "038"
			// Regra 2 - Se o CTe ou a nota não tiverem ICMS destacado não toma crédito de ICMS
			// TES 039
			ElseIf  aInfIcmsCTe[1,5] == 0 .Or. SF2->F2_VALICM == 0
				aItem[nPosTes,2] := "039"
			Endif			
			If nPosOper <> 0			
				aDel(aItem,nPosOper)
				aSize(aItem,nLenItem-1)
			Endif	
			/*		
			// Segmento	
			If nPosClVl <> 0
				aItem[nPosClVl,2]	:= 
			Else
				Aadd(aItem,{"D1_CLVL" 	,SF2->F2_DOC		               				,Nil})
				nLenItem	:= Len(aItem)
			Endif
			
			// Centro de Custo
			If nPosCC <> 0
				aItem[nPosCC,2]		:=
			Else 
				Aadd(aItem,{"D1_CC" 	,SF2->F2_DOC		               				,Nil})
				nLenItem	:= Len(aItem)
			Endif*/
		Else
			aItem[nPosTes,2] := "038"	
			If nPosClVl <> 0
				aItem[nPosClVl,2]	:= "999001001"
			Else
				Aadd(aItem,{"D1_CLVL" 	,"999001001"		               				,Nil})
				nLenItem	:= Len(aItem)
			Endif
			
			// Centro de Custo
			If nPosCC <> 0
				aItem[nPosCC,2]		:= "020202001"
			Else 
				Aadd(aItem,{"D1_CC" 	,"020202001"		               				,Nil})
				nLenItem	:= Len(aItem)
			Endif		
			If nPosOper <> 0			
				aDel(aItem,nPosOper)
				aSize(aItem,nLenItem-1)
			Endif			
						
		Endif		
	Endif
Return