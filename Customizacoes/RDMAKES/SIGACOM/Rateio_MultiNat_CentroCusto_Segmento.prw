#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

//---------------------------------------------//
User Function MT103MNT()
//---------------------------------------------//
Local aHeadSev   := PARAMIXB[1]
Local aColsSev   := PARAMIXB[2]
Local nPosNat    := aScan(aHeadSev, {|x| x[2] = "EV_NATUREZ"})
Local nPosPerc   := aScan(aHeadSev, {|x| x[2] = "EV_PERC"})
Local nPosRateio := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"} )
Local nPosProd	 := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"} )
// Somente preenche caso tiver rateio como S em algum item.
lRatear := .F.    

//Gustavo 06/10/2016 - Ajustado para a Central XML
If Len(aColsSev) < 1
	Return
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For nX := 1 to Len(aCols)     
	lRatear := lRatear .Or. ( aCols[nX, nPosRateio] == '1' .And. !Empty(aCols[nX, nPosProd]) )
Next nX

// Preenche por padrao com uma natureza e com 100 no percentual%
if (Len(aColsSev) < 1 .Or. Empty(aColsSev[1,nPosNat]) .Or. (aColsSev[1,nPosNat] <> MAFISRET(,"NF_NATUREZA")))  .And. lRatear
	if Empty(aColsSev[1,nPosNat])
		aColsSev[1,nPosNat] := MAFISRET(,"NF_NATUREZA")
		aColsSev[1,nPosPerc] := 100                    
	EndIf
EndIf
        
// Faz a validacao para quando existir rateio, garantir que a natureza do rateio seja a mesma informada no título.
if Len(aColsSev) = 1 
	if !Empty(aColsSev[1,nPosNat]) .And. (aColsSev[1,nPosNat] <> MAFISRET(,"NF_NATUREZA")) .And. lRatear
		aColsSev[1,nPosNat] := MAFISRET(,"NF_NATUREZA")
		aColsSev[1,nPosPerc] := 100
	EndIf
EndIf            


Return aColsSev

//---------------------------------------------//
User Function MT100RTX()
//---------------------------------------------//

Local aHeaderDE := ParamIXB[1]
Local aColsDE   := ParamIXB[2]
Local aRet := {}
Local nPosCLVL   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CLVL"})
Local nPosCC     := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CC"})
Local nPosCTA    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CONTA"})
Local nPosIte    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_ITEM"})
Local nPosRateio := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_RATEIO"} )
Local nPosPed    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_PEDIDO"})
Local nPosProd   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_COD"})
Local nPosItCt   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_ITEMCTA"})
Local nPosDEItem := aScan(aHeaderDE,   { |x| AlLTrim(x[2]) = "DE_ITEM"})
Local nPosDEClVl := aScan(aHeaderDE,   { |x| AllTrim(x[2]) = "DE_CLVL"})
Local nPosDECC   := aScan(aHeaderDE,   { |x| AllTrim(x[2]) = "DE_CC"})
Local nPosDECta  := aScan(aHeaderDE,   { |x| AllTrim(x[2]) = "DE_CONTA"})
Local nPosDEPerc := aScan(aHeaderDE,   { |x| AllTrim(x[2]) = "DE_PERC"})
Local nPosDEItCt := aScan(aHeaderDE,   { |x| AlLTrim(x[2]) = "DE_ITEMCTA"})
Local nQuant    := 0    
Local nControla := 0  
Local nPerc     := 0
Local nTotPerc  := 0
Local cClVl, cCC, cCta, nPos
Local cQuery := ""
Local cProduto, cNumero, cFornece, cLoja1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// busca os dados
cClVl    := aOrigAcols[N, nPosCLVL]
cCC      := aOrigAcols[N, nPosCC]
cCta     := aOrigAcols[N, nPosCTA]
cItem    := aOrigAcols[N, nPosIte]
cItemCta := aOrigAcols[N, nPosItCt]
cProduto := aOrigAcols[N, nPosProd]
cNumero  := aOrigAcols[N, nPosPed]

cFornece := cA100For
cLoja1   := cLoja


nPos  := aScan(aColsDE,{|x| x[1] == cItem})
    
lRatear := .F.
// Valida se deve ratear ou não, somente rateia caso tenha mais de um segmento ou centro de custo na nota ou manual, caso o usuário informou
For nX := 1 to Len(aOrigAcols)
	lRatear := lRatear .Or. (((aOrigAcols[nX, nPosCLVL] != cClVl) .Or. (aOrigAcols[nX, nPosCC] != cCta)) .And. !Empty(aOrigAcols[nX, 2])) ; // item em branco nao valida
							.Or. (aOrigAcols[nX, nPosRateio] == "2")
Next nX

if lRatear
	aAdd(aColsDE, {cItem, {Array(Len(aHeaderDE) + 1)}})		
	nPos := Len(aColsDe)
EndIf
                 
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Rateio automático para a seguinte situação:
Quando for lançado várias linhas para o mesmo item no pedido de compras e for lançado
apenas uma linha no documento de entrada contendo o rateio baseado nas quantidades
estipuladas no pedido. Nesse caso, deve ser descomentado tudo o que estiver entre o 
bloco de código demarcado por "Início rateio automático" e "Fim rateio automático"
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
*/

// Jean - Início rateio automático
if lRatear 

	if Len(aRet) = 0
		aAdd(aRet, Array(Len(aHeaderDE) + 1))
	/*
		cQuery := "SELECT C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_CLVL, C7.C7_CC, C7.C7_CONTA, C7.C7_ITEMCTA, SUM(C7.C7_TOTAL) AS VALOR, ( "
	    cQuery += "	SELECT SUM(C7.C7_TOTAL) FROM " + retSqlName("SC7") + " C7 "
    	cQuery += " WHERE C7.C7_FILIAL  = '" + xFilial("SC7") + "' "
	    cQuery += "   AND C7.C7_PRODUTO = '" + cProduto + "' "
    	cQuery += "   AND C7.C7_NUM     = '" + cNumero + "' "
	    cQuery += "   AND C7.C7_FORNECE = '" + cFornece + "' "
    	cQuery += "   AND C7.C7_LOJA    = '" + cLoja1 + "' "
	    cQuery += " ) AS TOTPROD "
		cQuery += " FROM " + retSqlName("SC7") + " C7 "
		cQuery += "WHERE C7.C7_FILIAL  = '" + xFilial("SC7") + "' "
		cQuery += "	 AND C7.C7_PRODUTO = '" + cProduto + "' "
		cQuery += "	 AND C7.C7_NUM     = '" + cNumero + "' "
		cQuery += "	 AND C7.C7_FORNECE = '" + cFornece + "' "
		cQuery += "	 AND C7.C7_LOJA    = '" + cLoja1 + "' "
		cQuery += "  AND C7.D_E_L_E_T_ <> '*' "
		cQuery += "GROUP BY C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_CLVL, C7.C7_CC, C7.C7_CONTA, C7.C7_ITEMCTA " 
		
		TCQUERY cQuery NEW ALIAS "SC7TMP"
		
		DbSelectArea("SC7TMP")
		SC7TMP->(DbGoTop())
		Count to nQuant
		SC7TMP->(DbGoTop())
		
		// Valida se o retorno do SQL não for uma tabela vazia.
		if nQuant > 0
			
			while !SC7TMP->(EOF())      
				nControla += 1
				nPerc := Round((SC7TMP->VALOR * 100)/SC7TMP->TOTPROD,2)
			  nTotPerc += nPerc
			  
			  // Valida se o total da soma dos percentuais é igual a 100%. Se não for, ajusta.
			  if nControla == nQuant
			  	if nTotPerc != 100
			  		if nTotPerc > 100
			  		  nPerc -= nTotPerc - 100
			  		else
			  			nPerc += 100 - nTotPerc	
			  		EndIf
			  	EndIf
			  EndIf
			  
				If nControla > 1
					aAdd(aRet, Array(Len(aHeaderDE) + 1))
				Endif

				aRet[nControla][nPosDEItem] := StrZero(nControla,2)            
				
				aRet[nControla][nPosDEPerc] := CriaVar(aHeaderDE[nPosDEPerc][2])
				aRet[nControla][nPosDEPerc] := nPerc 
				
				aRet[nControla][nPosDECC]   := CriaVar(aHeaderDE[nPosDECC][2])
				aRet[nControla][nPosDECC]   := SC7TMP->C7_CC
				
				aRet[nControla][nPosDECta]  := CriaVar(aHeaderDE[nPosDECta][2])
				aRet[nControla][nPosDECta]  := SC7TMP->C7_CONTA
				
				aRet[nControla][nPosDEClVl] := CriaVar(aHeaderDE[nPosDEClVl][2])
				aRet[nControla][nPosDEClVl] := SC7TMP->C7_CLVL 
				
				aRet[nControla][nPosDEItCt] := CriaVar(aHeaderDE[nPosDEItCt][2])
				aRet[nControla][nPosDEItCt] := SC7TMP->C7_ITEMCTA
				
				aRet[nControla][Len(aHeaderDE)+1] := .F.
				
				SC7TMP->(dbSkip())
			Enddo
			
		else			
			
			For nX := 1 To Len(aHeaderDE) - 2
				If Trim(aHeaderDE[nX][2]) == "DE_ITEM"
					aRet[1][nX] := "01"
				Else
					aRet[1][nX] := CriaVar(aHeaderDE[nX][2])
				EndIf
				aRet[1][Len(aHeaderDE)+1] := .F.
			Next nX	
			
		EndIf    
		
		SC7TMP->(dbCloseArea())
	*/		
	EndIf
	/*
	if !(nQuant > 0)
	*/
		if Empty(aRet[1, nPosDEClVl])
			aRet[1, nPosDEPerc] := 100
			aRet[1, nPosDEClVl] := cClVl
			aRet[1, nPosDECC]   := cCC
			aRet[1, nPosDECta]  := cCta		
			aRet[1, nPosDeItCt] := cItemCta
			aRet[1, nPosDEItem] := "01"
		EndIf
		
		aRet[1][Len(aHeaderDE)+1] := .F.
	/*	
	EndIf  
	*/       
EndIf      

//  Jean - Fim rateio automático

aColsDE[nPos, 2] := aRet
 

Return aRet
     


//---------------------------------------------//
User Function ValRatCC()                         
//---------------------------------------------//
Local lRet := .T.          
Local nPosCLVL   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CLVL"})
Local nPosCC     := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CC"})
Local nPosCTA    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_CONTA"})
Local nPosIte    := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_ITEM"})
Local nPosRateio := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_RATEIO"} )
Local nPosProd   := aScan(aHeader,{|x| AllTrim(x[2]) == "D1_COD"} )
Local cClVl, cCC, cCta, nPos

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// busca os dados
cClVl := aCols[1, nPosCLVL]
cCC   := aCols[1, nPosCC]
cCta  := aCols[1, nPosCTA]
cItem := aCols[1, nPosIte]
    
//lRatear := .F.
lRatAll := .F.
// Valida se deve ratear ou não, somente rateia caso tenha mais de um segmento ou centro de custo na nota ou manual, caso o usuário informou
For nX := 2 to Len(aCols)
	lRatear := .F.                                                                  
	lRatear := lRatear .Or. (((aCols[nX, nPosCLVL] != cClVl) .Or. (aCols[nX, nPosCC] != cCC)) ) // Segmento ou 
			
	lRatear := lRatear .Or. (aCols[nX, nPosRateio] == "1") // valida se o item está como rateio

	lRatear := lRatear .And. !aCols[nX, Len(aHeader) + 1] // Valida se a linha está excluída

	lRatear := lRatear .And. !Empty(aCols[nX, nPosProd]) // Valida se o código está em branco (sem produto)
							
	if lRatear
		lRatAll := lRatAll .or. lRatear 
	EndIf
	
Next nX

if lRatAll //(nPos = 0)
	For nX := 1 to Len(aCols)
		if !(aCols[nX, nPosRateio] == "1") .And. !Empty(aCols[nX, nPosProd])
			lRet := .F.
		EndIf
	Next nX
EndIf

if !lRet
	Aviso("RATEIO SEGMENTO/CENTRO DE CUSTO","Será necessário informar Rateio como 'S' para todos os itens da Nota Fiscal.",{"OK"},2)
EndIf         

Return lRet 