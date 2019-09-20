#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
##############################################################################
###Job para calcular o valor da nota fiscal com base nos pedidos de venda. ###
###Este valor é gravado na tabela SC9->C9_X_VLTOT para posterior utilização###
###no calculo do valor do frete.                                           ###
##############################################################################
*/                           

User Function WFCalcImp()
Local cSql := ""

cSql += "SELECT DISTINCT C9.C9_PEDIDO, C9.C9_FILIAL "
cSql += "FROM "+RetSqlName("SC9")+" C9 "
cSql += "WHERE C9.D_E_L_E_T_ <> '*' "
cSql += "AND C9.C9_NFISCAL = '  ' AND C9.C9_X_VLTOT = 0 "
cSql += "AND C9.C9_FILIAL = '" + xFilial("SC9") + "' "
cSql += "AND C9.C9_BLEST = '  ' AND C9.C9_BLCRED = '  ' AND C9.C9_X_CARGA = '         ' "

TcQuery cSql NEW ALIAS "SC9PED"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While SC9PED->(!Eof())
	CalcImpos(SC9PED->C9_FILIAL,SC9PED->C9_PEDIDO)
	SC9PED->(dbSkip())
EndDo

SC9PED->(dbCloseArea())

Return

/*
##############################################################################
###Função utilizada para calcular o valor total das notas fiscais com      ###
###base nos pedidos de venda liberados no SC9.                             ###
##############################################################################
*/                           

Static Function CalcImpos(_cFil,_cPed)

Local aArea		 := GetArea()
Local aFisGet	 := {}
Local aFisGetSC5 := {}
Local aEntr      := {}                
Local _IaCOLS	 := {}
Local nPTotal    := 0
Local nPValDesc  := 0
Local nPPrUnit   := 0
Local nPPrcVen   := 0
Local nPQtdVen   := 0
Local nPDtEntr   := 0
Local nPProduto  := 0
Local nPTES      := 0
Local nPNfOri    := 0
Local nPSerOri   := 0
Local nPItemOri  := 0
Local nPCodPro   := 0
Local nPVlOri    := 0
Local nUsado     := 0
Local nX         := 0
Local nAcerto    := 0
Local nPrcLista  := 0
Local nValMerc   := 0
Local nDesconto  := 0
Local nAcresFin  := 0
Local nQtdPeso   := 0
Local nRecOri    := 0
Local nPosEntr   := 0
Local nItem      := 0
Local nY         := 0 
Local nPosCpo    := 0
Local lDtEmi     := SuperGetMv("MV_DPDTEMI",.F.,.T.)
Local _aHeader	 := {}
Local cSql := ""
		

DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("SC6")

While !EOF() .And. X3_ARQUIVO == "SC6"
	If AllTrim(SX3->X3_CAMPO) $ "C6_VALOR/C6_VALDESC/C6_PRUNIT/C6_PRCVEN/C6_ENTREG/C6_PRODUTO/C6_TES/C6_NFORI/C6_SERIORI/C6_ITEMORI/C6_QTDVEN/C6_ITEM/"
		If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
			aAdd( _aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
		Endif
	Endif
	SX3->(DbSkip())
End

nPTotal   := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
nPValDesc := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_VALDESC"})
nPPrUnit  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_PRUNIT"})
nPPrcVen  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_PRCVEN"})
nPQtdVen  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})
nPDtEntr  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_ENTREG"})
nPProduto := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
nPTES     := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_TES"})
nPNfOri   := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_NFORI"})
nPSerOri  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})
nPItemOri := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})
nPCodPro  := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
nPVlOri   := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_X_VLORI"})
nPItem    := aScan(_aHeader,{|x| AllTrim(x[2])=="C6_ITEM"})
nUsado    := Len(_aHeader)

cSql := "SELECT C5.C5_CLIENTE,C5.C5_LOJAENT,C5.C5_TIPO,C5.C5_TIPO,C5.C5_TIPOCLI, C5.C5_ACRSFIN, "
cSql += "C6.C6_VALOR, C6.C6_VALDESC, C6.C6_PRUNIT, C6.C6_PRCVEN, C6.C6_ENTREG, C6.C6_PRODUTO, C6.C6_QTDVEN, "
cSql += "C6.C6_TES, C6.C6_NFORI, C6.C6_SERIORI, C6.C6_ITEMORI, C6.C6_ITEM "
cSql += "FROM " + RetSqlName("SC6")+" C6, "+RetSqlName("SC5")+" C5 "
cSql += "WHERE C5.D_E_L_E_T_ <> '*' AND C6.D_E_L_E_T_ <> '*' "
cSql += "AND C5.C5_FILIAL = '"+_cFil+"' AND C6.C6_FILIAL = '"+_cFil+"' "
cSql += "AND C5.C5_NUM = '"+_cPed+"' AND C6.C6_NUM = '"+_cPed+"' "
cSql += "AND C6.C6_NUM = C6.C6_NUM AND C6.C6_CLI = C5.C5_CLIENTE "
cSql += "AND C6.C6_LOJA = C5.C5_LOJAENT "       // adicionar sc9 para validar total do item = 0
TCQUERY cSql NEW ALIAS "TMPSC6"

   
TMPSC6->(dbSelectArea("TMPSC6"))
TMPSC6->(dbGoTop())
While !TMPSC6->(Eof())
	aAdd( _IaCOLS, Array( Len( _aHeader ) + 1 ) )
	_IaCOLS[Len(_IaCOLS),nPTotal]	:= TMPSC6->C6_VALOR
	_IaCOLS[Len(_IaCOLS),nPValDesc]	:= TMPSC6->C6_PRUNIT
	_IaCOLS[Len(_IaCOLS),nPPrcVen]	:= TMPSC6->C6_PRCVEN
	_IaCOLS[Len(_IaCOLS),nPQtdVen]	:= TMPSC6->C6_QTDVEN
	_IaCOLS[Len(_IaCOLS),nPDtEntr]	:= TMPSC6->C6_ENTREG		
	_IaCOLS[Len(_IaCOLS),nPProduto]	:= TMPSC6->C6_PRODUTO
	_IaCOLS[Len(_IaCOLS),nPTES]		:= TMPSC6->C6_TES
	_IaCOLS[Len(_IaCOLS),nPNfOri]	:= TMPSC6->C6_NFORI
	_IaCOLS[Len(_IaCOLS),nPSerOri]	:= TMPSC6->C6_SERIORI
	_IaCOLS[Len(_IaCOLS),nPItemOri]	:= TMPSC6->C6_ITEMORI
	_IaCOLS[Len(_IaCOLS),nPCodPro]	:= TMPSC6->C6_PRODUTO
	_IaCOLS[Len(_IaCOLS),nPItem]	  := TMPSC6->C6_ITEM
	
//	_IaCOLS[Len(_IaCOLS),nPosCalc]	:= TMPSC6->C6_X_VLORI
	_IaCOLS[Len(_IaCOLS),Len(_aHeader)+1] := .F.
TMPSC6->(dbSkip())
End

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC6                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGet	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC6")
While !Eof().And.X3_ARQUIVO=="SC6"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGet,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGet,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca referencias no SC5                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aFisGetSC5	:= {}
dbSelectArea("SX3")
dbSetOrder(1)
MsSeek("SC5")
While !Eof().And.X3_ARQUIVO=="SC5"
	cValid := UPPER(X3_VALID+X3_VLDUSER)
	If 'MAFISGET("'$cValid
		nPosIni 	:= AT('MAFISGET("',cValid)+10
		nLen		:= AT('")',Substr(cValid,nPosIni,Len(cValid)-nPosIni))-1
		cReferencia := Substr(cValid,nPosIni,nLen)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	If 'MAFISREF("'$cValid
		nPosIni		:= AT('MAFISREF("',cValid) + 10
		cReferencia	:=Substr(cValid,nPosIni,AT('","MT410",',cValid)-nPosIni)
		aAdd(aFisGetSC5,{cReferencia,X3_CAMPO,MaFisOrdem(cReferencia)})
	EndIf
	dbSkip()
EndDo
aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializa a funcao fiscal                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MaFisSave()
MaFisEnd()
MaFisIni(TMPSC6->C5_CLIENTE,;					// 1-Codigo Cliente/Fornecedor
	TMPSC6->C5_LOJAENT,;						// 2-Loja do Cliente/Fornecedor
	IIf(TMPSC6->C5_TIPO$'DB',"F","C"),;			// 3-C:Cliente , F:Fornecedor
	TMPSC6->C5_TIPO,;							// 4-Tipo da NF
	TMPSC6->C5_TIPOCLI,;						// 5-Tipo do Cliente/Fornecedor
	Nil,;
	Nil,;
	Nil,;
	Nil,;
	"MATA461")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Agrega os itens para a funcao fiscal         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nPTotal > 0 .And. nPValDesc > 0 .And. nPPrUnit > 0 .And. nPProduto > 0 .And. nPQtdVen > 0 .And. nPTes > 0
	For nX := 1 To Len(_IaCOLS)

		nQtdPeso := 0

		If Len(_IaCOLS[nX])==nUsado .Or. !_IaCOLS[nX][nUsado+1]

			nItem++
		
			If nPNfOri > 0 .And. nPSerOri > 0 .And. nPItemOri > 0
				If !Empty(_IaCOLS[nX][nPNfOri]) .And. !Empty(_IaCOLS[nX][nPItemOri])
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+_IaCOLS[nX][nPNfOri]+_IaCOLS[nX][nPSerOri]+TMPSC6->C5_CLIENTE+TMPSC6->C5_LOJAENT+_IaCOLS[nX][nPCodPro]+_IaCOLS[nX][nPItemOri]))
						nRecOri := SD1->(Recno())
					Endif
				Endif
			Endif
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calcula o preco de lista                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nValMerc  := _IaCOLS[nX][nPTotal]			
			nPrcLista := NoRound(nValMerc/_IaCOLS[nX][nPQtdVen],TamSX3("C6_PRCVEN")[2])			
			nAcresFin := A410Arred(_IaCOLS[nX][nPPrcVen]*TMPSC6->C5_ACRSFIN/100,"D2_PRCVEN")
			nValMerc  += A410Arred(_IaCOLS[nX][nPQtdVen]*nAcresFin,"D2_TOTAL")		
			nDesconto := 0
			nPrcLista += nAcresFin
			nValMerc  += nDesconto

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Agrega os itens para a funcao fiscal         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			MaFisAdd(_IaCOLS[nX][nPProduto],;   		// 1-Codigo do Produto ( Obrigatorio )
				_IaCOLS[nX][nPTES],;	   				// 2-Codigo do TES ( Opcional )
				_IaCOLS[nX][nPQtdVen],;  				// 3-Quantidade ( Obrigatorio )
				nPrcLista,;		  				   		// 4-Preco Unitario ( Obrigatorio )
				0,; 									// 5-Valor do Desconto ( Opcional )
				"",;	   								// 6-Numero da NF Original ( Devolucao/Benef )
				"",;									// 7-Serie da NF Original ( Devolucao/Benef )
				nRecOri,;								// 8-RecNo da NF Original no arq SD1/SD2
				0,;										// 9-Valor do Frete do Item ( Opcional )
				0,;										// 10-Valor da Despesa do item ( Opcional )
				0,;										// 11-Valor do Seguro do item ( Opcional )
				0,;										// 12-Valor do Frete Autonomo ( Opcional )
				nValMerc,;								// 13-Valor da Mercadoria ( Obrigatorio )
				0)										// 14-Valor da Embalagem ( Opiconal )				
		EndIf

	Next nX
EndIf

SC9->(dbSetOrder(01)) // PEDIDO, ITEM
// Faz o desconto do valor unitario com base no valor de icms retido, calculando proporcionalmente pelo valor do item e do total
_nTotal:= 0
For nX := 1 to Len(_IaCOLS)	
	If !_IaCOLS[nX][Len(_aHeader)+1]
	
		nValMerc  := _IaCOLS[nX][nPTotal]		
		// obtém os valores de impostos, no caso usei apenas IPI e ST, atualmente funciona 100% no Pneus		
		nValIpi := MaFisRet(nX,"IT_VALIPI")
		nValSol := MaFisRet(nX,"IT_VALSOL")
		_nTotal += (nValSol+nValIpi+nValMerc)
		// somar com o valor total por item o valor dos impostos
		
		if (SC9->(dbSeek(xFilial("SC9") + _cPed + _IaCOLS[nX, nPItem])))
			RecLock("SC9", .F.)
			SC9->C9_X_VLTOT := (nValSol+nValIpi+nValMerc)
			SC9->(MsUnlock())
		EndIf
		
	EndIf
Next

TMPSC6->(dbSelectArea("TMPSC6"))
TMPSC6->(dbCloseArea())

MaFisEnd()
RestArea(aArea)

Return(_nTotal)