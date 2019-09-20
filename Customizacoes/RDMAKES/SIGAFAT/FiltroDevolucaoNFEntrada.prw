#INCLUDE "rwmake.ch"                     
#INCLUDE "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ M410PCDV บ Autor ณ Adriano Novachaelley Data ณ  22/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Ponto de entrada utilizado para filtrar notas fiscais de   บฑฑ
ฑฑบ          ณ origem. Quando tipo da nota fiscal for DEVOLUCAO           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ PEDIDO DE VENDA (MATA410) -> BOTAO RETORNAR                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
                                
User Function M410PCDV()
Local cRet			:= "" 
Local nPNfOri   := aScan(aHeader,{|x| AllTrim(x[2])=="C6_NFORI"}) 		// Posi็ใo C6_NFORI
Local nPSerOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_SERIORI"})   // Posi็ใo C6_SERIORI
Local nPIteOri  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_ITEMORI"})		// Posi็ใo C6_ITEMORI     
Local nPclasfi  := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CLASFIS"})		// Posi็ใo C6_CLASFIS      
Local nDiaDev	:= SuperGetMv("MV_DIASDEV",,60)                       // Dias considerados para filtro. 
Local aColsBKP	:= aCols   
Local aArea  	:= GetArea()
aCols := {}    

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


For nR := 1 To Len(aColsBKP)
	cSql := "SELECT D1.D1_FILIAL, D1.D1_DOC, D1.D1_SERIE, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_CLASFIS "
	cSql += "FROM "+RetSqlName("SD1")+" D1 "
	cSql += "WHERE D1.D_E_L_E_T_ <> '*' "
	cSql += "AND D1.D1_FILIAL = '"+xFilial("SD1")+"' "
	cSql += "AND D1.D1_FORNECE = '"+cFornece+"' AND D1.D1_LOJA = '"+cLoja+"' "
	cSql += "AND D1.D1_DOC = '"+aColsBKP[nR,nPNfOri]+"' AND D1.D1_SERIE = '"+aColsBKP[nR,nPSerOri]+"' "
	cSql += "AND D1.D1_ITEM = '"+aColsBKP[nR,nPIteOri]+"' "
	cSql += "AND D1.D1_DTDIGIT >= '"+DtoS(Date()-nDiaDev)+"'" "
	TcQuery cSql NEW ALIAS "TMPD1"
	TMPD1->(dbSelectArea("TMPD1"))
	TMPD1->(dbGoTop())	
	If !TMPD1->(Eof())   
		aColsbkp[nR,nPclasfi] := TMPD1->D1_CLASFIS
		AADD(aCols,aColsBKP[nR])
	Else
		Alert("Nota fiscal "+aColsBKP[nR,nPNfOri]+" nใo pode ser devolvida, verificar o parametro MV_DIASDEV!")
	Endif
	TMPD1->(dbSelectArea("TMPD1"))
	TMPD1->(DbCloseArea())

Next nR             

RestArea(aArea)

Return()