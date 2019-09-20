#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "XMLXFUN.CH"

#DEFINE VBOX	080
#DEFINE HMARGEM	030

/*/{Protheus.doc} ImpCCe
Impressão de Carta de Correção Eletronica própria ou de terceiros (Arquivo XML).
@type function
@author devair
@since 11/07/2016
@version 1.0
/*/
User Function ImpCCe()
	
	Local aAreaSF1			:= SF1->(GetArea())
	Local aAreaSF2			:= SF2->(GetArea())
	Local aDevice 			:= {}
	Local aIndArq   		:= {}
	Local cIdent			:= RetIdEnti()
	Local cFlPrint			:= ""
	Local cSession 			:= GetPrinterSession()
	Local lAdjustToLegacy	:= .F.
	Local lDisableSetup 	:= .T.
	Local nHRes 			:= 0
	Local nVRes  			:= 0
	Local nDevice			:= 0
	Local nRet 				:= 0
	Local oDanfe			:= Nil
	
	cFlPrint := "DACCE_" + cIdEnt + Dtos(MSDate()) + StrTran(Time(),":","")
	
	aAdd(aDevice,"DISCO")	//1
	aAdd(aDevice,"SPOOL")	//2
	aAdd(aDevice,"EMAIL") 	//3
	aAdd(aDevice,"EXCEL") 	//4
	aAdd(aDevice,"HTML")	//5
	aAdd(aDevice,"PDF")		//6
	
	If CTIsReady()
		DBSelectArea("SF2")
		RetIndex("SF2")
		SF2->(DBClearFilter())
		oDanfe := FWMSPrinter():New(cFlPrint,IMP_PDF,lAdjustToLegacy,,lDisableSetup,,,,.F.,,.F.)
// 		Cria e exibe tela de Setup Customizavel
		ConfImp(oDanfe, cFlPrint)
	EndIf
	
	FreeObj(oDanfe)
	RestArea(aAreaSF2)
	RestArea(aAreaSF1)
	
Return

/*/{Protheus.doc} ConfImp
Função responsável por configurar a impressão.
@type function
@author devair
@since 11/07/2016
@version 1.0
@param oDanfe, objeto, Objeto de impressão.
@param cFlPrint, character, Arquivo de impressão.
/*/
Static Function ConfImp(oDanfe,cFlPrint)

	Local cErro	  	:= ""
	Local cAlerta	:= ""
	Local lExistNfe := .F.
	Private nConsNeg := 0.4 //Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
	Private nConsTex := 0.5 //Constante para concertar o cálculo retornado pelo GetTextWidth.

	oDanfe:SetResolution(78) //Tamanho estipulado para a Danfe.
	oDanfe:SetPortrait()
	oDanfe:SetPaperSize(DMPAPER_A4)
	oDanfe:SetMargin(60,60,60,60)
	oDanfe:lServer := .F.
	oDanfe:SetDevice(IMP_PDF)
	oDanfe:SetViewPDF(.T.)
	
	Private PixelX := oDanfe:nLogPixelX()
	Private PixelY := oDanfe:nLogPixelY()

	RptStatus({|lEnd| VldNf(@oDanfe,@lEnd,@lExistNfe, @cErro, @cAlerta)},"Imprimindo CCe...")

	If lExistNfe
		oDanfe:Preview() //Visualiza antes de imprimir.
	Else
		If !Empty(cErro) .Or. !Empty(cAlerta)
			MsgAlert("Erro: " + cErro + CRLF + cAlerta,"ConfImp")
		Else		
			MsgAlert("Nenhuma NF-e a ser impressa nos parametros utilizados.","ConfImp")
		EndIf
	EndIf
	
Return

/*/{Protheus.doc} VldNf
Função responsável por validar o tipo da NF.
@type function
@author devair
@since 11/07/2016
@version 1.0
@param oDanfe, objeto, Objeto para Impressão.
@param lEnd, lógico, Fim do processo.
@param lExistNfe, lógico, Se existe a NF.
@param cErro, character, Erro.
@param cAlerta, character, Alerta.
/*/
Static Function VldNf(oDanfe,lEnd, lExistNfe, cErro, cAlerta)

	Local aNotas	:= {}
	Local aPergs	:= {}
	Local aRet		:= {}
	Local cDoc 		:= ""
	Local cPath		:= PadR("",150)
	Local cSerie	:= ""
	Local cXML		:= ""
	Local cModalid	:= 0
	Local lPropria	:= .T.
	Local oXmlCCE	:= Nil
			
	aAdd(aPergs,{1,"Nota Fiscal",Space(TamSX3("F2_DOC")[1]),"@!",".T.","",".T.",80,.T.})
	aAdd(aPergs,{1,"Serie",Space(TamSX3("F2_SERIE")[1]),"@!",".T.","",".T.",30,.F.})
	aAdd(aPergs,{2,"Modalidade",OEMToANSI("1 - Saída"),{OEMToANSI("1 - Saída"), "2 - Entrada"},60,"",.T.})
	aAdd(aPergs,{2,"Form. Prop.","1 - Sim",{"1 - Sim", OEMToANSI("2 - Não")},60,"",.T.})
	aAdd(aPergs,{6,"Arquivo XML",cPath,"","",".F.",90,.F.,"Arquivo XML |*.xml |","",GETF_LOCALHARD})
	
	If !ParamBox(aPergs,OEMToANSI("Imprimir CCe"),aRet)
		MsgAlert("Cancelado!","VldNf")
		Return
	EndIf
	
	lPropria := SubStr(aRet[4],1,1) == "1"
	If lPropria
		cDoc := aRet[1]
		cSerie := aRet[2]
		cModalid := SubStr(aRet[3],1,1)
		If cModalid == "1"
			DBSelectArea("SF2")
			If SF2->(DBSeek(xFilial("SF2") + cDoc + cSerie))
				oXmlCCE := GetXmlNf(SF2->F2_CHVNFE,@cErro,@cAlerta)
			EndIf
		Else
			DBSelectArea("SF1")
			If SF1->(DBSeek(xFilial("SF1") + cDoc + cSerie))
				oXmlCCE := GetXmlNf(SF1->F1_CHVNFE,@cErro,@cAlerta)
			EndIf
		EndIf
	Else
//		Leitura do XML.
		cXml := MemoRead(cPath)						
		cXml := FWNoAccent(cXml)
		
		oXmlCCE := XmlParser(cXml,"_",@cErro,@cAlerta)
		
		if oXmlCCE == Nil .and. upper('Input is not proper UTF-8') $ upper(cErro)
			cXml 	:= EncodeUTF8(cXml)
			oXmlCCE := XmlParser(cXml,"_",@cErro,@cAlerta)
		endif
		
	EndIf
	ImpDados(@oDanfe,lPropria, @oXmlCCE, @lExistNfe)
	
Return

/*/{Protheus.doc} GetXmlNf
Função responsável por gerar o XML.
@type function
@author devair
@since 07/07/2016
@version 1.0
@param cChvNFE, character, Chave NF.
@param cErro, character, Erro.
@param cAlerta, character, Alerta.
@return ${character}, ${XML}
/*/
Static Function GetXmlNf(cChvNFE, cErro, cAlerta)
	
	Local cAviso	:= ""
	Local cErro		:= ""
	Local cIdent 	:= RetIdEnti()
	Local cNFes		:= ""
	Local cURL     	:= PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oRetorno	:= Nil
	Local oWS		:= Nil
	Local oXmlExp	:= Nil

	oWS:= WSNFeSBRA():New()
	oWS:cUSERTOKEN := "TOTVS"
	oWS:cID_ENT := cIdEnt
	oWS:_URL := AllTrim(cURL) + "/NFeSBRA.apw"
	oWS:cChvInicial	:= cChvNFE
	oWS:cChvFinal := cChvNFE
	lOk	:= oWS:NFEEXPORTAEVENTO()
	oRetorno := oWS:oWSNFEEXPORTAEVENTORESULT
	cDestino := "C:\"
	If lOk
		cXml := FWNoAccent(oRetorno:CSTRING[1])
		oXmlExp := XmlParser(cXml,"_",@cErro,@cAlerta)
		
		if oXmlExp == Nil .and. upper('Input is not proper UTF-8') $ upper(cErro)
			cXml 	:= EncodeUTF8(cXml)
			oXmlExp := XmlParser(cXml,"_",@cErro,@cAviso)
		endif
	EndIf
	
Return oXmlExp

/*/{Protheus.doc} ImpDados
(long_description)
@type function
@author devair
@since 11/07/2016
@version 1.0
@param oDanfe, objeto, (Descrição do parâmetro)
@param lPropria, ${param_type}, (Descrição do parâmetro)
@param oXmlCCE, objeto, (Descrição do parâmetro)
@param lExistNfe, ${param_type}, (Descrição do parâmetro)
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
Static Function ImpDados(oDanfe, lPropria, oXmlCCE, lExistNfe)

	Local cLogo 	:= "logo" + cEmpAnt + ".bmp"
	Local cLogoD	:= ""
	Local cChave	:= ""
	Local cDtHrRec	:= ""
	Local cDtHrRec1	:= ""
	Local cNumero	:= ""
	Local cProt		:= ""
	Local cSerie	:= ""
	Local cCNPJEmi	:= ""
	Local lLogo 	:= .T.
	Local nDtHrRec1	:= 0
	Local nX 		:= 0
	Local oFont07N  := TFontEx():New(oDanfe,"Times New Roman",06,06,.T.,.T.,.F.) // 2
	Local oFont07   := TFontEx():New(oDanfe,"Times New Roman",06,06,.F.,.T.,.F.) // 3
	Local oFont08   := TFontEx():New(oDanfe,"Times New Roman",07,07,.F.,.T.,.F.) // 4
	Local oFont08N  := TFontEx():New(oDanfe,"Times New Roman",06,06,.T.,.T.,.F.) // 5
	Local oFont12   := TFontEx():New(oDanfe,"Times New Roman",11,11,.F.,.T.,.F.) // 10
	Local oFont12N  := TFontEx():New(oDanfe,"Times New Roman",11,11,.T.,.T.,.F.) // 13
	
//	Texto da Carta de Correção.
	If ValType(oXmlCCE) <> "U"
		cCorrecao := NoAcento(oXmlCCE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_DETEVENTO:_XCORRECAO:TEXT)
		cChave := oXmlCCE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_chNFE:TEXT
		cNumero := SubStr(cChave,26,9)
		cSerie := SubStr(cChave,23,3)
		cCNPJEmi := oXmlCCE:_PROCEVENTONFE:_EVENTO:_INFEVENTO:_CNPJ:TEXT	
//		Conversão Data.
		cDtHrRec := oXmlCCE:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_DHREGEVENTO:TEXT
		nDtHrRec1 := Rat("T",cDtHrRec)
		cProt := oXmlCCE:_PROCEVENTONFE:_RETEVENTO:_INFEVENTO:_NPROT:TEXT	
		lExistNfe := .T.
	EndIf
	
	If nDtHrRec1 <> 0
		cDtHrRec1 := SubStr(cDtHrRec,nDtHrRec1+1,8)
		dDtRecib :=	SToD(StrTran(SubStr(cDtHrRec,1,AT("T",cDtHrRec)-1),"-",""))
	EndIf
	
//	Inicializacao da pagina do objeto grafico.
	If lExistNfe
		oDanfe:StartPage()
		nHPage := oDanfe:nHorzRes()
		nHPage *= (300/PixelX)
		nHPage -= HMARGEM
		nVPage := oDanfe:nVertRes()
		nVPage *= (300/PixelY)
		nVPage -= VBOX
	
		cLogoD := GetSrvProfString("Startpath","") + "/danfe" + cEmpAnt + cFilAnt + ".BMP"
		If !File(cLogoD)
			cLogoD	:= GetSrvProfString("Startpath","") + "/danfe" + cEmpAnt + ".BMP"
			If !File(cLogoD)
				lLogo := .F.
			EndIf
		EndIf
		
//		Definicao do Box - Recibo de entrega.
		oDanfe:Box(000,000,010,501)
		oDanfe:Say(006, 002, "RECEBEMOS DE "+ IIF(lPropria, NoAcento(AllTrim(SM0->M0_NOMECOM)),"TERCEIROS") + ;
							" A NOTIFICAÇÃO DE ALTERAÇÃO DE DADOS DA NOTA FISCAL INDICADA AO LADO", oFont07:oFont)
		oDanfe:Box(009,000,037,101)
		oDanfe:Say(017, 002, "DATA DE RECEBIMENTO", oFont07N:oFont)
		oDanfe:Box(009,100,037,500)
		oDanfe:Say(017, 102, "IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR", oFont07N:oFont)
		oDanfe:Box(000,500,037,603)
		oDanfe:Say(007, 542, "NF-e", oFont08N:oFont)
		oDanfe:Say(017, 510, "N. "+StrZero(Val(cNumero),9), oFont08:oFont)
		oDanfe:Say(027, 510, "SÉRIE "+cSerie, oFont08:oFont)
//		Quadro 1 Identificação do emitente.
		oDanfe:Box(042,000,147,250)
		oDanfe:Say(052,098, "Identificação do emitente",oFont12N:oFont)
		nLinCalc :=	065
		If lPropria
			cStrAux	:= AllTrim(SM0->M0_NOMECOM)
			nForTo := Len(cStrAux)/25
			nForTo += Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*25)+1),25), oFont12N:oFont )
				nLinCalc+=10
			Next nX	
			cStrAux	:= AllTrim(SM0->M0_ENDCOB)
			nForTo := Len(cStrAux)/32
			nForTo += Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
	
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N:oFont)
				nLinCalc+=10
			Next nX
		
			cStrAux	:= "Complemento: "+ AllTrim(SM0->M0_COMPCOB)
			nForTo := Len(cStrAux)/32
			nForTo += Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N:oFont)
				nLinCalc+=10
			Next nX
		
			cStrAux	:= AllTrim(SM0->M0_BAIRCOB)			
			cStrAux	+= " Cep:" + TransForm(AllTrim(SM0->M0_CEPCOB),"@r 99999-999")
			nForTo := Len(cStrAux)/32
			nForTo += Iif(nForTo>Round(nForTo,0),Round(nForTo,0)+1-nForTo,nForTo)
			For nX := 1 To nForTo
				oDanfe:Say(nLinCalc,098,SubStr(cStrAux,Iif(nX==1,1,((nX-1)*32)+1),32),oFont08N:oFont)
				nLinCalc+=10
			Next nX
			oDanfe:Say(nLinCalc,098, AllTrim(SM0->M0_CIDCOB)+"/"+AllTrim(SM0->M0_ESTCOB),oFont08N:oFont)
			nLinCalc += 10
			oDanfe:Say(nLinCalc,098, "Fone: "+AllTrim(SM0->M0_TEL),oFont08N:oFont)
		Else
			oDanfe:Say(nLinCalc,098, "TERCEIROS", oFont12N:oFont)
		EndIf
	
		If lPropria
			If lLogo
				oDanfe:SayBitmap(045,005,cLogoD,080,080)
			Else
				oDanfe:SayBitmap(052,010,cLogo,080,080)
			EndIf
		EndIf
		
//		Codigo de barra.
		oDanfe:Box(042,350,093,603)
		oDanfe:Box(085,350,115,603)
		oDanfe:Say(107,355,TransForm(cChave,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont12N:oFont)
		oDanfe:Box(115,350,147,603)
		oDanfe:Say(127,355,"Consulta de autenticidade no portal nacional da NF-e",oFont12:oFont)
		oDanfe:Say(137,355,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont12:oFont)
//		Quadro 2.
		oDanfe:Box(042,248,147,351)
		oDanfe:Say(055,275, "DACCE",oFont12N:oFont)
		oDanfe:Say(075,258, "DOCUMENTO AUXILIAR DA",oFont07:oFont)
		oDanfe:Say(085,258, "CARTA DE CORREÇÃO ",oFont07:oFont)
		oDanfe:Say(095,258, "ELETRÔNICA",oFont07:oFont)
//		Quadro 4.
		oDanfe:Box(149,000,172,603)
		oDanfe:Say(158,353,"PROTOCOLO DE AUTORIZAÇÃO DE USO",oFont08N:oFont)
		oDanfe:Say(097,355,"CHAVE DE ACESSO DA NF-E",oFont12N:oFont)
		nFontSize := 28
		oDanfe:Code128C(077,370,cChave, nFontSize )
		oDanfe:Say(168,354,cProt+" "+DTOC(dDtRecib)+ " "+cDtHrRec1 ,oFont08:oFont)
//		Quadro 5.
		oDanfe:Box(174,000,197,603)	
		oDanfe:Box(174,280,197,603)
		oDanfe:Say(182,002,"INSCRIÇÃO ESTADUAL EMITENTE",oFont08N:oFont)

		If lPropria
			oDanfe:Say(190,002,SM0->M0_INSC,oFont08:oFont)	
		EndIf
		oDanfe:Say(182,283,"CNPJ EMITENTE",oFont08N:oFont)
		If lPropria
			oDanfe:Say(190,283,TransForm(SM0->M0_CGC,"@r 99.999.999/9999-99"),oFont08:oFont)
		Else
			oDanfe:Say(190,283,TransForm(cCNPJEmi,"@r 99.999.999/9999-99"),oFont08:oFont)
		EndIf

//		Quadro destinatário/remetente.
		oDanfe:Say(205,002,"DADOS DA NOTA FISCAL",oFont08N:oFont)
		oDanfe:Box(207,000,230,450)
		oDanfe:Say(215,002, "SERIE",oFont08N:oFont)
		oDanfe:Say(225,002, cSerie,oFont08:oFont)
		oDanfe:Box(207,280,230,603)
		oDanfe:Say(215,283,"NOTA FISCAL",oFont08N:oFont)
		oDanfe:Say(225,283, StrZero(Val(cNumero),9),oFont08:oFont)	
		oDanfe:Say(240,002,"CORREÇÃO",oFont08N:oFont)
		oDanfe:Box(242,000,850,603)
		nTam := Len(AllTrim(cCorrecao))
		nStep := 145	
		nLin := 249
		For nI := 1 to nTam step nStep	
			oDanfe:Say(nLin,002,SubStr(cCorrecao,nI,nStep),oFont08:oFont)
			nLin += 10
		Next nI
		oDanfe:EndPage()
	EndIf

Return