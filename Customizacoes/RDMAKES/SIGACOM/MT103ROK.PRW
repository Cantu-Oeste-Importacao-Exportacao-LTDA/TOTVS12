#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
//³Inicia validação dos valores utilizados no rateio dos itens ³
//³o documento de entrada.                                     ³
//³Se houver um pedido que deu origem ao documento de ³entrada,³
//o rateio deve ser distribuído de acordo com o pedido.        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ

User function MT103ROK()
Local aArea := GetArea()
Local lRet   := .T.
Local lValid := .T.
Local lBloq  := SuperGetMv("MV_BLQLRAT",,"N") == "S"
Local nPosCLVL   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CLVL"})
Local nPosCC     := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CC"})
Local nPosCTA    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_CONTA"})
Local nPosIte    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_ITEM"})
Local nPosRateio := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_RATEIO"})
Local nPosPed    := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_PEDIDO"})
Local nPosProd   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_COD"})
Local nPosItPc   := aScan(aOrigHeader, { |x| AllTrim(x[2]) = "D1_ITEMPC"})
Local nPosDEClVl := aScan(aHeader, { |x| AllTrim(x[2]) = "DE_CLVL"})
Local nPosDECC   := aScan(aHeader, { |x| AllTrim(x[2]) = "DE_CC"})
Local nPosDECta  := aScan(aHeader, { |x| AllTrim(x[2]) = "DE_CONTA"})
Local nPosDEPerc := aScan(aHeader, { |x| AllTrim(x[2]) = "DE_PERC"})
Local nPercRat := 0
Local nValor   := 0
Local nPerc    := 0              
Local cClVl, cCC, cCta, nPos
Local cMsg     := "Inconsistências entre pedido e documento de entrada: "+CHR(13)+CHR(10)
Local cProduto := ""
Local cNumero  := ""
Local cFornece := ""
Local cLoja1   := ""
Local cItem    := ""
Local cDocum   := ""
Local cSerieNF := ""
Local cChave   := ""
Local cEol     := CHR(13)+CHR(10)
Local nItemDC  := oGetDados:oBrowse:nAt // obtido do objeto, pois o N não confere mais com a linha do item do documento de entrada

// Usa variáveis de sistema para pegar informações do cabeçalho do documento de entrada.			
cDocum   := cNFiscal
cSerieNF := cSerie
cFornece := cA100For
cLoja1   := cLoja

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if lRet                 

	if aOrigAcols[nItemDC][nPosPed] != " " //.and. aOrigAcols[i, nPosRateio] == "1" 
  		
  	// Atribui o valor dos campos do aCols nas variáveis
		cProduto := aOrigAcols[nItemDC][nPosProd]
		cItem    := aOrigAcols[nItemDC][nPosIte]
		cNumero  := aOrigAcols[nItemDC][nPosPed]
		cItemPed := aOrigAcols[nItemDC][nPosItPc]
		
		for j := 1 to Len(aCols)
			nPercRat := aCols[j][nPosDEPerc]
			cClVl    := aCols[j][nPosDEClvl]
			cCC      := aCols[j][nPosDECC] 
			cCta		 := aCols[j][nPosDECta]
			
			cQuery := "SELECT C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_CLVL, C7.C7_CC, C7.C7_CONTA, C7.C7_TOTAL AS VALOR" //, ( "
//      cQuery += "	SELECT SUM(C7.C7_TOTAL) FROM " + retSqlName("SC7") + " C7 "
//      cQuery += " WHERE C7.C7_FILIAL  = '" + xFilial("SC7") + "' "
//      cQuery += "   AND C7.C7_PRODUTO = '" + cProduto + "' "
//      cQuery += "   AND C7.C7_NUM     = '" + cNumero + "' "
//      cQuery += "   AND C7.C7_FORNECE = '" + cFornece + "' "
//      cQuery += "   AND C7.C7_LOJA    = '" + cLoja1 + "' "
//      cQuery += "   AND C7.D_E_L_E_T_ = ' ' "
//      cQuery += " ) AS TOTPROD "
			cQuery += " FROM " + retSqlName("SC7") + " C7 "
			cQuery += "WHERE C7.C7_FILIAL  = '" + xFilial("SC7") + "' "
			cQuery += "	 AND C7.C7_PRODUTO = '" + cProduto + "' "
			cQuery += "  AND C7.C7_CLVL    = '" + cClvl + "' "
			cQuery += "  AND C7.C7_CC      = '" + cCC + "' "
			cQuery += "  AND C7.C7_CONTA   = '" + cCta + "' "
			cQuery += "	 AND C7.C7_NUM     = '" + cNumero + "' "
			cQuery += "	 AND C7.C7_FORNECE = '" + cFornece + "' "
			cQuery += "	 AND C7.C7_LOJA    = '" + cLoja1 + "' "
			// Flavio - 25/04/2012 - Adicionado o filtro do item do pedido
			cQuery += "	 AND C7.C7_ITEM    = '" + cItemPed + "' "
			cQuery += "  AND C7.D_E_L_E_T_ <> '*' "
//				cQuery += "GROUP BY C7.C7_FILIAL, C7.C7_PRODUTO, C7.C7_CLVL, C7.C7_CC, C7.C7_CONTA " 
			
			TCQUERY cQuery NEW ALIAS "SC7TMP"
			
			DbSelectArea("SC7TMP")
			SC7->(DbGoTop())
			if !SC7TMP->(EOF())
				nValor := SC7TMP->VALOR
				nPerc  := 100
			Else
				nValor := 0
				nPerc  := 0
			EndIf			
			SC7TMP->(DbCloseArea())
			
			// Avalia se o percentual rateado do item do pedido está igual ao percentual rateado do item no documento de entrada.
      if nPerc != nPercRat
      	cMsg += "PEDIDO: " + cNumero + cEOL  + cEOL
      	cMsg += "Segmento: "        + cClVl + cEOL
      	cMsg += "Centro de Custo: " + cCC   + cEOL
      	cMsg += "Conta Contábil: "  + cCta  + cEOL
      	cMsg += "Percentual rateado do item " + AllTrim(cProduto) +;
       	        " para o segmento, centro de custo e conta contábil acima: " + Str(nPerc) + "%" + cEOL + cEOL
       	
      	cMsg += "DOCUMENTO DE ENTRADA " + cDocum + cEOL + cEOL
      	cMsg += "Segmento: "        + cClVl  + cEOL
      	cMsg += "Centro de Custo: " + cCC    + cEOL
      	cMsg += "Conta Contábil: "  + cCta   + cEOL
      	cMsg += "Percentual rateado do item " + AllTrim(cProduto) +;
       	        " para o segmento, centro de custo e conta contábil acima: " + Str(nPercRat) + "%" + cEOL + cEOL
        	
      	lValid := .F.
        	        	
    	EndIf											
		Next j
		
		// Avalia se o parâmetro de bloqueio está habilitado e o percentual de rateio não está igual.
  	if lBloq .and. !lValid
    	Aviso("Rateio difere do pedido",cMsg,{"OK"},3)
    	lRet := .F.
    ElseIf !lValid
    	Aviso("Rateio difere do pedido",cMsg,{"OK"},3)
    	//MsgAlert(cMsg)	
    EndIf
  			 
  EndIf
  
EndIf

RestArea(aArea)

Return lRet