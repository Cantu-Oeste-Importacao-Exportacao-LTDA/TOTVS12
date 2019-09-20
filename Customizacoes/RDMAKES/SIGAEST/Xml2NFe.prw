#Include "PROTHEUS.CH"
#Include "rwmake.CH"
#INCLUDE "COLORS.CH"

#DEFINE VBOX      080
#DEFINE VSPACE    008
#DEFINE HSPACE    010
#DEFINE SAYVSPACE 008
#DEFINE SAYHSPACE 008
#DEFINE HMARGEM   030
#DEFINE VMARGEM   030
#DEFINE MAXITEM   022                                                // Máximo de produtos para a primeira página
#DEFINE MAXITEMP2 060                                                // Máximo de produtos para as páginas adicionais
#DEFINE MAXITEMC  030                                                // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN 080                                                // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG    007                                                // Máximo de dados adicionais por página

Static aUltChar2pix
Static aUltVChar2pix

/*/////////////////////////////////////////////////
Função que le um aquivo xml e cria variaveis com os dados do mesmo
O tipo do xml deve ser formato de intercambio ou da própria NFe , com a tag inicial NFe
//////////////////////////////////////////////////*/
User Function Xml2NFe()
Local cPerg := "IMPXMLNF"
Local cAviso := ""
Local cErro := ""
Local cTipo := "Arquivos Xml | *.xml"
Private cFileNF	:= cGetFile( cTipo , "Selecione o arquivo xml recebido", 0,"",.T.,GETF_LOCALHARD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Empty(cFileNF)
	Return
EndIf

nHdl := FOpen(cFileNF)
cXml := FReadStr(nHdl, 999999)

FClose(nHdl)	
oNFProc := XmlParser(cXml,"_",@cAviso,@cErro)

oNfe := iif(Type("oNFProc:_nfeProc")=="U", oNFProc, oNFProc:_nfeProc)

if !Empty(cAviso)
 Alert(cAviso, "Aviso")
endIf

if !Empty(cErro)
 Alert(cErro, "Erro")
endIf

ImportaXml(oNFe)
Return

Static Function ImportaXml(oNFe)
Local aTamanho      := {}
Local aHrEnt 		    := {}
Local aAux          := {}
Local nHPage        := 0 
Local nVPage        := 0 
Local nPosV         := 0
Local nPosVOld      := 0
Local nPosH         := 0
Local nPosHOld      := 0
Local nAuxH         := 0
Local nAuxV         := 0
Local nX            := 0
Local nY            := 0
Local nTamanho      := 0
Local nFolha        := 1
Local nFolhas       := 0
Local nItem         := 0
Local nMensagem     := 0
Local nBaseICM      := 0
Local nValICM       := 0
Local nValIPI       := 0
Local nPICM         := 0
Local nPIPI         := 0
Local nFaturas      := 0
Local nVTotal       := 0
Local nQtd          := 0
Local nVUnit        := 0
Local nVolume	    := 0
Local cAux          := ""
Local cSitTrib      := ""
Local lPreview      := .F.
Local nLenFatura        
Local nLenVol  
Local nLenDet 
Local nLenSit     
Local nLenItens     := 0
Local nLenMensagens := 0
Local nLen          := 0
Local lImpAnfav     := GetNewPar("MV_IMPANF",.F.)

Private oNF        := oNFe:_NFe
Private oEmitente  := oNF:_InfNfe:_Emit
Private oIdent     := oNF:_InfNfe:_IDE
Private oDestino   := oNF:_InfNfe:_Dest
Private oTotal     := oNF:_InfNfe:_Total
Private oTransp    := oNF:_InfNfe:_Transp
Private oDet       := oNF:_InfNfe:_Det
Private oFatura    := IIf(Type("oNF:_InfNfe:_Cobr")=="U",Nil,oNF:_InfNfe:_Cobr)
Private oImposto   := Nil
Private nPrivate   := 0
Private nPrivate2  := 0
Private nXAux	     := 0
Private aItens     := {}
Private aSitTrib   := {}
Private aTransp    := {}
Private aDest      := {}
Private aFaturas   := {}
Private aISSQN     := {}
Private aTotais    := {}
Private aMensagem  := {}    
Private cVersao	   := oNfe:_Nfe:_InfNfe:_Versao:TEXT	


nFaturas := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as variaveis de impressao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aSitTrib,"00")
aadd(aSitTrib,"10")
aadd(aSitTrib,"20")
aadd(aSitTrib,"30")
aadd(aSitTrib,"40")
aadd(aSitTrib,"41")
aadd(aSitTrib,"50")
aadd(aSitTrib,"51")
aadd(aSitTrib,"60")
aadd(aSitTrib,"70")
aadd(aSitTrib,"90")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Destinatario ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aDest := {oDestino:_EnderDest:_Xlgr:Text+IIF(", SN"$oDestino:_EnderDest:_Xlgr:Text,"",", "+oDestino:_EnderDest:_NRO:Text + IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", " + oDestino:_EnderDest:_xcpl:Text)),;
			oDestino:_EnderDest:_XBairro:Text,;
			IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
			IIF(Type("oIdent:_DSaiEnt")=="U","",oIdent:_DSaiEnt:Text),;//			oIdent:_DSaiEnt:Text,;
			oDestino:_EnderDest:_XMun:Text,;
			IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
			oDestino:_EnderDest:_UF:Text,;
			oDestino:_IE:Text,;
			""}            

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Imposto³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aTotais := {"","","","","","","","","","",""}
aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),"@ze 999,999,999.99")
aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),"@ze 9,999,999.99")
aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),"@ze 999,999,999.99")
aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),"@ze 9,999,999.99")
aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),"@ze 9,999,999.99")
aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),"@ze 9,999,999.99")
aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT),"@ze 9,999,999.99")
aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),"@ze 9,999,999.99")
aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@ze 9,999,999.99")
aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@ze 9,999,999.99")
aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@ze 999,999,999.99")	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Faturas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If nFaturas > 0
	For nX := 1 To 3
		aAux := {}
		For nY := 1 To Min(9, nFaturas)
			Do Case
				Case nX == 1
					If nFaturas > 1
						AAdd(aAux, AllTrim(oFatura:_Dup[nY]:_nDup:TEXT))
					Else
						AAdd(aAux, AllTrim(oFatura:_Dup:_nDup:TEXT))
					EndIf
				Case nX == 2
					If nFaturas > 1
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup[nY]:_dVenc:TEXT)))
					Else
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup:_dVenc:TEXT)))
					EndIf
				Case nX == 3
					If nFaturas > 1
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup[nY]:_vDup:TEXT), "@E 9999,999,999.99")))
					Else
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup:_vDup:TEXT), "@E 9999,999,999.99")))
					EndIf
			EndCase
		Next nY
		If nY <= 9
			For nY := nY To 9
				AAdd(aAux, Space(20))
			Next nY
		EndIf
		AAdd(aFaturas, aAux)
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro transportadora                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTransp := {"","0","","","","","","","","","","","","","",""}
                                   
If Type("oTransp:_ModFrete")<>"U"
	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
EndIf
If Type("oTransp:_Transporta")<>"U"
	aTransp[01] := IIf(Type("oTransp:_Transporta:_xNome:TEXT")<>"U",oTransp:_Transporta:_xNome:TEXT,"")
//	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
	aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
	aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
	aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
	If Type("oTransp:_Transporta:_CNPJ:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	ElseIf Type("oTransp:_Transporta:_CPF:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CPF:TEXT,"@r 999.999.999-99")
	EndIf
	aTransp[07] := IIf(Type("oTransp:_Transporta:_xEnder:TEXT")<>"U",oTransp:_Transporta:_xEnder:TEXT,"")
	aTransp[08] := IIf(Type("oTransp:_Transporta:_xMun:TEXT")<>"U",oTransp:_Transporta:_xMun:TEXT,"")
	aTransp[09] := IIf(Type("oTransp:_Transporta:_UF:TEXT")<>"U",oTransp:_Transporta:_UF:TEXT,"")
	aTransp[10] := IIf(Type("oTransp:_Transporta:_IE:TEXT")<>"U",oTransp:_Transporta:_IE:TEXT,"")
EndIf
If Type("oTransp:_Vol")<>"U"
    If ValType(oTransp:_Vol) == "A"
	    nX := nPrivate
		    nLenVol := Len(oTransp:_Vol)
	    	For nX := 1 to nLenVol
    		nXAux := nX
    		nVolume += IIF(!Type("oTransp:_Vol[nXAux]:_QVOL:TEXT")=="U",Val(oTransp:_Vol[nXAux]:_QVOL:TEXT),0)
	    Next nX
	    aTransp[11]	:= AllTrim(str(nVolume))
		aTransp[12]	:= IIf(Type("oTransp:_Vol:_Esp")=="U","Diversos","")
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		If  Type("oTransp:_Vol[1]:_PesoB") <>"U"
            	nPesoB := Val(oTransp:_Vol[1]:_PesoB:TEXT)
   				aTransp[15] := AllTrim(str(nPesoB))
  			EndIf
  		If Type("oTransp:_Vol[1]:_PesoL") <>"U"
            nPesoL := Val(oTransp:_Vol[1]:_PesoL:TEXT)
			aTransp[16] := AllTrim(str(nPesoL))
		EndIf
    Else
		aTransp[11] := IIf(Type("oTransp:_Vol:_qVol:TEXT")<>"U",oTransp:_Vol:_qVol:TEXT,"")    
		aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		aTransp[15] := IIf(Type("oTransp:_Vol:_PesoB:TEXT")<>"U",oTransp:_Vol:_PesoB:TEXT,"")
		aTransp[16] := IIf(Type("oTransp:_Vol:_PesoL:TEXT")<>"U",oTransp:_Vol:_PesoL:TEXT,"")		
    EndIf
    aTransp[15] := strTRan(aTransp[15],".",",")
    aTransp[16] := strTRan(aTransp[16],".",",")    
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Dados do Produto / Serviço ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

nLenDet := Len(oDet)
For nX := 1 To nLenDet
	nPrivate := nX
	nVTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)
	nQtd     := Val(oDet[nX]:_Prod:_qTrib:TEXT)
	nVUnit   := Val(oDet[nX]:_Prod:_vUnCom:TEXT)
	nBaseICM := 0
	nValICM  := 0
	nValIPI  := 0
	nPICM    := 0
	nPIPI    := 0
	oImposto := oDet[nX]
	cSitTrib := ""
	If Type("oImposto:_Imposto")<>"U"
		If Type("oImposto:_Imposto:_ICMS")<>"U"
			nLenSit := Len(aSitTrib)
			For nY := 1 To nLenSit
				nPrivate2 := nY
		 		If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
		 			If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT")<>"U"
			 			nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
			 			nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
			 			nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT"))
			 		EndIf
			 		cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_ORIG:TEXT")
			 		cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT")
		 		EndIf
			Next nY
		EndIf
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
			EndIf
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
				nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf
		EndIf
	EndIf
	aadd(aItens,{oDet[nX]:_Prod:_cProd:TEXT,;
					oDet[nX]:_Prod:_xProd:TEXT,;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					oDet[nX]:_Prod:_utrib:TEXT,;
					nQtd,;
					nVUnit,;
					nVTotal,;
					nBaseICM,;
					nValICM,;
					nValIPI,;
					nPICM,;
					nPIPI})
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro ISSQN ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

aISSQN := {"","","",""}
If Type("oEmitente:_IM:TEXT")<>"U"
	aISSQN[1] := oEmitente:_IM:TEXT
EndIf  
If Type("oTotal:_ISSQNtot")<>"U"
	aISSQN[2] := Val(oTotal:_ISSQNtot:_vServ:TEXT)
	aISSQN[3] := Val(oTotal:_ISSQNtot:_vBC:TEXT)
	aISSQN[4] := Val(oTotal:_ISSQNtot:_vISS:TEXT)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro de informacoes complementares ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cModalidade := "1" // devido ao excesso de validacoes
aMensagem := {}
If Type("oIdent:_tpAmb:TEXT")<>"U" .And. oIdent:_tpAmb:TEXT=="2"
	cAux := "DANFE emitida no ambiente de homologação - SEM VALOR FISCAL"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf
If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If oIdent:_tpEmis:TEXT=="4"
	cAux := "Danfe emitida em contingencia - DPEC "
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If (Type("oIdent:_tpEmis:TEXT")<>"U" .And. !oIdent:_tpEmis:TEXT$"1,4")
	cAux := "DANFE emitida em contingência"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. !cModalidade $ "1,4,5") .And. Empty(cCodAutSef) 
	cAux := "DANFE emitida em contingência devido a problemas técnicos - será necessária a substituição."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. cModalidade $ "5" .And. oIdent:_tpEmis:TEXT=="4") 
	cAux := "DANFE impresso em contingência"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
	cAux := "DPEC regularmento recebido pela Receita Federal do Brasil."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (Type("oIdent:_tpEmis:TEXT")<>"U" .And. oIdent:_tpEmis:TEXT$"5")
	cAux := "DANFE emitida em contingência FS-DA"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo	
EndIf

If Type("oNF:_InfNfe:_infAdic:_infCpl:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_InfCpl:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf
 
If Type("oNF:_INFNFE:_IDE:_NFREF:_REFNF:_NNF:TEXT")<>"U" 
	cAux := "Numero da nota original : " + oNF:_INFNFE:_IDE:_NFREF:_REFNF:_NNF:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf Type("oNF:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT")<>"U"
	cAux := "Chave de acesso da NF-E referenciada: " + oNF:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

InsereAuto()

Return .T.

*---------------------------*
Static Function InsereAuto() 
*---------------------------*

Local aCabec    := {}
Local aDetItens := {}
Local aDetItem  := {}
Local aForn     := ""
Local cDirAnt   := CurDir()
Local cLocPad   := ""

Private cTipoNF := "N"

if !AjustaItens()
	Return
EndIf

// copia o arquivo xml para o servidor, na estrutura
// XmlNfe/cnpjEmpDest/Ano-Mes    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// copia o arquivo xml para o servidor, na estrutura							³
// XmlNfe/cnpjEmpDest/Ano-Mes                                                   ³
// Gustavo - 05/02/15                                                           ³
// Tratativa para xml layout 3.10 já que houve mudança na tag de Data de emissão³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If cVersao >= "3.10"
	cEmiss 	:= SubStr(oIdent:_DHEmi:TEXT, 1, 7)     
	cDtEmis	:= Substr(oIdent:_DHEmi:TEXT,1,10)
Else
	cEmiss 	:= SubStr(oIdent:_DEmi:TEXT, 1, 7)   
	cDtEmis	:= oIdent:_DEmi:TEXT
EndIf

if (Type("oDestino:_CNPJ")=="O")
	cAux := oDestino:_CNPJ:Text
elseif (Type("oDestino:_CPF")=="O")
	cAux := oDestino:_CPF:Text
else
	cAux := ""
EndIf


cDirServer := "\xmlnfe\" + iif(!empty(cAux), cAux, "noemp") + "\" + cEmiss
           
// Cria diretorio por diretorio
CurDir("\")
if !ExistDir("\xmlnfe")
	MakeDir("\xmlnfe")
EndIf

CurDir("\xmlnfe")
if !ExistDir(cAux)
	MakeDir(cAux)
EndIf            

CurDir("\xmlnfe\" + cAux)
if !ExistDir(cEmiss)
	MakeDir(cEmiss)
EndIf

if !ExistDir(cDirServer)
	MakeDir(cDirServer)
EndIf

// Copia o arquivo xml da NFe para o servidor, para manter uma cópia do mesmo
CPYT2S(cFileNF, cDirServer, .T.)

aForn := BuscaForn(cTipoNF)

// Volta para o diretório inicial
CurDir(cDirAnt)

// Verifica se a nota já foi incluída e cancela caso isso ocorreu, para nao duplicar.
SF1->(dbSetOrder(01))

// se localizou a NF incluida, mostra a mesma para ediçao // nf + serie + fornecedor + loja
if SF1->(dbSeek(xFilial("SF1") + PadL(oIdent:_nNF:Text, 9, "0") + ;
						 PadR(oIdent:_Serie:Text, 3, ' ') + aForn[1] + aForn[2]))
	Alert("Nota Fiscal já foi incluída. Verifique.")
	Return
EndIf

// Verifica se o destinatário é a empresa que está sendo incluida a NF
// Nome da empresa destinatária
cNome := oDestino:_XNome:Text
If (cAux <> AllTrim(SM0->M0_CGC))
	ShowHelpDlg("Destinatário Divergente", {"Nota fiscal destinada a Empresa " + cNome + " (CNPJ/CPF: " + cAux + ")." },5,;
											{"Verifique se a empresa onde a importação está sendo realizada está correta."},5)
	Return	
EndIf

// Monta o cabeçalho e itens
// Cabeçalho
aAdd(aCabec, {"F1_FILIAL" , xFilial("SF1"), nil})
aAdd(aCabec, {"F1_FORMUL" , "N", nil})
aAdd(aCabec, {"F1_TIPO"   , cTipoNF, nil})
aAdd(aCabec, {"F1_FORNECE", aForn[1], nil})
aAdd(aCabec, {"F1_LOJA"   , aForn[2], nil})
aAdd(aCabec, {"F1_EST"    , oEmitente:_EnderEmit:_UF:Text, nil})
aAdd(aCabec, {"F1_DOC"    , PadL(oIdent:_nNF:Text, 9, "0"), nil})
aAdd(aCabec, {"F1_SERIE"  , oIdent:_Serie:Text, nil})
//aAdd(aCabec, {"F1_EMISSAO", SToD(StrTran(oIdent:_dEmi:Text, '-', '')), nil})
aAdd(aCabec, {"F1_EMISSAO", SToD(StrTran(cDtEmis, '-', '')), nil})
aAdd(aCabec, {"F1_ESPECIE", "SPED", nil})
// Adriano Verifica se é empresa do GRUPO CANTU
_lEmpGrp	:= .F.
_aSM0Area	:= SM0->(GetArea())
_cCGC		:= SubStr(POSICIONE("SA2",1,xFilial("SA2")+aForn[1]+aForn[2],"A2_CGC"),1,8)

SM0->(DbSelectArea("SM0"))
SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While !SM0->(Eof())
	If _cCGC == SubStr(SM0->M0_CGC,1,8)
		_lEmpGrp := .T.
	Endif
	SM0->(DbSkip())
End
RestArea(_aSM0Area)

For i:= 1 to Len(aItens)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 16/09 - TRATATIVA PRA BUSCAR CODIGO DO ARMAZÉM DO INDICADOR DO PRODUTO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
  cLocPad := Posicione("SBZ",1, xFilial("SBZ") + aItens[i, 1], "BZ_LOCPAD")
  
  aDetItem := {}
	aAdd(aDetItem, {"D1_ITEM"   , PadL(AllTrim(Str(i)), 4, "0"), nil})
	aAdd(aDetItem, {"D1_COD"    , aItens[i, 1] , Nil})
	aAdd(aDetItem, {"D1_DESCRI" , aItens[i, 2] , Nil})
	
	// busca os dados do produto
	SB1->(dbSetOrder(01))
	SB1->(dbSeek(xFilial("SB1") + aItens[i, 1]))
	
	aAdd(aDetItem, {"D1_UM"     , SB1->B1_UM, Nil})

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³JEAN - 16/09 - TRATATIVA PRA BUSCAR CODIGO DO ARMAZÉM DO INDICADOR DO PRODUTO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	aAdd(aDetItem, {"D1_LOCAL"  , Iif(!Empty(cLocPad),cLocPad,SB1->B1_LOCPAD), Nil})
	aAdd(aDetItem, {"D1_QUANT"  , aItens[i, 5] , Nil})
	aAdd(aDetItem, {"D1_VUNIT"  , aItens[i, 6] , Nil})
	aAdd(aDetItem, {"D1_BASEICM", aItens[i, 8] , Nil})
	aAdd(aDetItem, {"D1_VALICM" , aItens[i, 9] , Nil})
	aAdd(aDetItem, {"D1_VALIPI" , aItens[i, 10], Nil})
	aAdd(aDetItem, {"D1_PICM"   , aItens[i, 11], Nil})
	aAdd(aDetItem, {"D1_IPI"    , aItens[i, 12], Nil})
	aAdd(aDetItem, {"AUTDELETA" , "N", Nil})

	aAdd(aDetItens, aDetitem)
Next

lMsErroAuto := .F.

MSExecAuto({|x,y,z|   MATA140(x,y,z)}, aCabec, aDetItens, 3)

If lMsErroAuto
  MostraErro() // se ocorrer erro no sigaauto gera mensagem de informação do erro  
  MsgBox("Nota fiscal não incluida. Verifique.")
else
	SF1->(dbSetOrder(01))
	// se localizou a NF incluida, mostra a mesma para ediçao // nf + serie + fornecedor + loja
	if SF1->(dbSeek(xFilial("SF1") + PadL(oIdent:_nNF:Text, 9, "0") + ;
							 PadR(oIdent:_Serie:Text, 3, ' ') + aForn[1] + aForn[2]))
// Adriano Marca se é empresa do GRUPO CANTU
	If _lEmpGrp
		SF1->(Reclock("SF1",.F.))
			SF1->F1_FORGRP := "S"
		SF1->(MsUnlock("SF1"))
	Endif							 
		A140NFiscal("SF1", SF1->(RecNo()), 4)
	EndIf
Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DANFE     ºAutor  ³Marcos Taranta      º Data ³  10/01/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Pega uma posição (nTam) na string cString, e retorna o      º±±
±±º          ³caractere de espaço anterior.                               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function EspacoAt(cString, nTam)

Local nRetorno := 0
Local nX       := 0

/**
 * Caso a posição (nTam) for maior que o tamanho da string, ou for um valor
 * inválido, retorna 0.
 */
If nTam > Len(cString) .Or. nTam < 1
	nRetorno := 0
	Return nRetorno
EndIf

/**
 * Procura pelo caractere de espaço anterior a posição e retorna a posição
 * dele.
 */
nX := nTam
While nX > 1
	If Substr(cString, nX, 1) == " "
		nRetorno := nX
		Return nRetorno
	EndIf
	
	nX--
EndDo

/**
 * Caso não encontre nenhum caractere de espaço, é retornado 0.
 */
nRetorno := 0
Return nRetorno

Static Function ConvDate(cData)
Local dData
cData  := StrTran(cData,"-","")
dData  := Stod(cData)
Return PadR(StrZero(Day(dData),2)+ "/" + StrZero(Month(dData),2)+ "/" + StrZero(Year(dData),4),15)

Static Function ValidPerg(cPerg)
cPerg := PADR(cPerg, Len(SX1->X1_GRUPO))
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Arquivo Xml","Arquivo Xml","Arquivo Xml","mv_ch1","C",99,0,0,"G","", "", "", "","MV_PAR01")
Return


///////////////////////////////////////////////////////
// Funcao que mostra os produtos e solicita ao usuario para
// adequar os mesmos de acordo com o cadastro da filial
/////////////////////////////////////////////////////////
*----------------------------*
Static Function AjustaItens()
*----------------------------*

Local oButton1
Local aHeaderEx    := {}
Local aAlterFields := {"CODPROD"}
Local aColsEx      := {}
Local aTipoNF      := {"N=Normal","D=Devolucao","B=Beneficiamento"}
Local oPnl1, oPnl2
Local lCont        := .T.
Local cEmitente    := ""
Local aBt          := {"RELATORIO",{||U_PrtXmlNFe(oNfe)}, "Visualizar Nota Fiscal", "Imprimir"}

Static oDlg
Static oGDCpos

Aadd(aHeaderEx, {"Produto"        ,"CODPROD" ,"@!"                ,07,0,"!Vazio()"     ,"","C","SB1", "V"})
Aadd(aHeaderEx, {"Cod. Original"  ,"CODORIG" ,"@!"                ,12,0,"AllwaysTrue()","","C",""   , "V"})
Aadd(aHeaderEx, {"Desc. Original" ,"DESORIG" ,"@!"                ,40,0,"AllwaysTrue()","","C",""   , "V"})
Aadd(aHeaderEx, {"Unid"           ,"UNIDORIG","@!"                ,02,0,"AllwaysTrue()","","C",""   , "V"})
Aadd(aHeaderEx, {"Quantidade"     ,"QTDEPROD","@E 999,999.99"     ,14,2,"AllwaysTrue()","","N",""   , "V"})
Aadd(aHeaderEx, {"Unitario"       ,"UNITPROD","@E 9,999,999.99999",14,5,"AllwaysTrue()","","N",""   , "V"})
Aadd(aHeaderEx, {"Total"          ,"TOTPROD" ,"@E 9,999,999.99"   ,14,2,"AllwaysTrue()","","N",""   , "V"})
  
// Se for do grupo, o codigo do produto é o mesmo e informa o mesmo que está na danfe

_lEmpGrp	:= .F.
_aSM0Area	:= SM0->(GetArea())

_cCGC := iIf (Type("oEmitente:_CNPJ")=="U", oEmitente:_CPF:TEXT, oEmitente:_CNPJ:TEXT)

SM0->(DbSelectArea("SM0"))
SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While !SM0->(Eof())
	If SubStr(_cCGC,1,8) == SubStr(SM0->M0_CGC,1,8)
		_lEmpGrp := .T.
	Endif
	SM0->(DbSkip())
End
RestArea(_aSM0Area)

// Adiciona os Itens
for i:= 1 to len(aItens)
	aAdd(aColsEx, {iif(_lEmpGrp, aItens[i, 1],Space(Len(SD1->D1_COD))),;
							aItens[i, 1],;
							aItens[i, 2],;
							aItens[i, 4],;
							aItens[i, 5],;
							aItens[i, 6],;
							aItens[i, 7],;
							.F.})
Next							

cObs := ""

For i:= 1 to Len(aMensagem)
  cObs := aMensagem[i] + char(13) + char(10)
Next

// Traz os dados do fornecedor, basendo-se que o tipo de nota é normal. Se nao existir traz em branco.
U_ValidForn(@cEmitente, oDlg)

  DEFINE MSDIALOG oDlg TITLE "Informe os Itens" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
            
    @ 000, 000 MSPANEL oPnl1 SIZE 250, 090 OF oDlg COLORS 0, 16777215 RAISED
		    
    @ 05, 05 Say "Tipo NF" SIZE 025, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 05, 30 ComboBox cTipoNF Items aTipoNF Size 50, 90 VALID U_ValidForn(@cEmitente, oDlg) OF oPnl1 COLORS 0, 16777215 PIXEL
    
    @ 05, 120 Say "Natureza" SIZE 025, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 05, 160 Say oIdent:_Natop:Text OF oPnl1 COLORS 0, 16777215 PIXEL
    
    @ 16, 05 Say "Emissao     " + iif(oIdent:_tpEmis:Text == "1", "1- Normal", "2 - Contingencia") OF oPnl1 COLORS 0, 16777215 PIXEL   
    
    @ 16, 120 Say "Ambiente   " SIZE 025, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 16, 160 Say iif(oIdent:_tpAmb:Text == "1", "1 - Produção", "2 - Homologacao") OF oPnl1 COLORS 0, 16777215 PIXEL
    
    @ 27, 05 Say "Emitente " OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 25, 30 Get cEmitente SIZE 190, 007 when .F. OF oPnl1 COLORS 0, 16777215 PIXEL
    
    @ 37, 05 Say "Emit. Xml " OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 37, 30 Say oEmitente:_xNome:Text SIZE 190, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
    
    @ 45, 05  Say "Observações" OF oPnl1 COLORS 0, 16777215 PIXEL
    @ 53, 05  Get cObs MEMO Size 200, 30 when .F. OF oPnl1 COLORS 0, 16777215 PIXEL
    
		@085, 000 MSPANEL oPnl2 SIZE 250, 196 OF oDlg COLORS 0, 16777215 RAISED
		
		oGDCpos := MsNewGetDados():New( 000, 000, 232, 250, 3, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,0, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oPnl2, aHeaderEx, aColsEx)
    		
		oPnl1:Align := CONTROL_ALIGN_TOP
    oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
    oGDCpos:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT

  ACTIVATE MSDIALOG oDlg CENTER ON INIT ;      
		EnchoiceBar(oDlg,{|| lCont := .T. , ImpXmlOk(oDlg)}, {|| lCont := .F., oDlg:End() }, ,{aBt})
  
// Seta os campos alterados de volta para os itens corretos que devem ser informados
// Sempre que usado msnewgetdados, tem que buscar a propriedade acol do grid ao invez do aCols original passado como parametro
SB1->(dbSetOrder(01))
For i:= 1 to len(oGDCpos:aCols)
	aItens[i, 1] := oGDCpos:aCols[i, 1]
	// Busca a descrição
	SB1->(dbSeek(xFilial("SB1") + AllTrim(oGDCpos:aCols[i, 1])))
	aItens[i, 2] := SB1->B1_DESC
Next

Return lCont

Static Function ImpXmlOk()
Local lOk := .T.
SB1->(dbSetOrder(01))
for i:= 1 to len(oGDCpos:aCols)
	if (Empty(oGDCpos:aCols[i, 1]))	
		Alert("Produto não iformado para a linha " + Str(i, 1, 0), "Atenção")
		lOk := .F.		
	else
		lEncontrou := SB1->(dbSeek(xFilial("SB1") + oGDCpos:aCols[i, 1]))
    if !lEncontrou
    	Alert("Produto " + oGDCpos:aCols[i, 1] + " não existe.", "Atenção")
    	lOk := .F.
    elseif (SB1->B1_MSBLQL == "1")
      Alert("Produto " + oGDCpos:aCols[i, 1] + " está bloqueado para uso.", "Atenção")
    	lOk := .F.
    EndIf
	EndIf
Next

if (lOk)
	ODlg:End()
Endif

Return 

User Function ValidForn(cEmitente, oDlg)
Local aCodLoja := BuscaForn(cTipoNF)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !Empty(cTipoNF)
	cEmitente := aCodLoja[1] + "/" + aCodLoja[2] + " - " + AllTrim(aCodLoja[3])
	
	if (type("ODlg") <> "U")
		oDlg:Refresh()
	EndIf
	
EndIf
Return !Empty(cTipoNF)

Static Function BuscaForn(cTipo)
Local aCodLoja := {"", "", ""}
Local cCpfCnpj := iIf (Type("oEmitente:_CNPJ")=="U", oEmitente:_CPF:TEXT, oEmitente:_CNPJ:TEXT)
// Obtém de acordo com o tipo da NF a ser lançado, já previamente informado
if (cTipo $ "BD")
	SA1->(DbSetOrder(3))
	If SA1->(dbSeek(xFilial("SA1")+cCpfCnpj))
		aCodLoja[1] := SA1->A1_COD
		aCodLoja[2] := SA1->A1_LOJA		
		aCodLoja[3] := SA1->A1_NOME
	EndIf
Else
	SA2->(DbSetOrder(3))
	If SA2->(dbSeek(xFilial("SA2")+cCpfCnpj))
		aCodLoja[1] := SA2->A2_COD
		aCodLoja[2] := SA2->A2_LOJA
		aCodLoja[3] := SA2->A2_NOME
	EndIf
EndIf
Return aCodLoja
                        

User Function MT140ROT()
Local aRot := {{ "Importar XML"   ,"U_Xml2NFe", 0 , 3}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return aRot


// Função para imprimir a NF com base no xml passado
User Function PrtXmlNFe(oNfe)
Local aArea     := GetArea()

Local oDanfe

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

oDanfe := TMSPrinter():New("DANFE - DOCUMENTO AUXILIAR DA NOTA FISCAL ELETRÔNICA")
oDanfe:SetPortrait()
oDanfe:Setup()

Private PixelX := oDanfe:nLogPixelX()
Private PixelY := oDanfe:nLogPixelY()
	
RptStatus({|lEnd| ImpDet(@oDanfe,oNFe,"",oIdent:_tpEmis:Text,nil,"",nil)}, "Imprimindo Danfe...")

oDanfe:Preview()
RestArea(aArea)
Return Nil


Static Function ImpDet(oDanfe,oNfe,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)

PRIVATE oFont10N   := TFontEx():New(oDanfe,"Times New Roman",09,09,.T.,.T.,.F.)// 1
PRIVATE oFont07N   := TFontEx():New(oDanfe,"Times New Roman",06,06,.T.,.T.,.F.)// 2
PRIVATE oFont07    := TFontEx():New(oDanfe,"Times New Roman",06,06,.F.,.T.,.F.)// 3
PRIVATE oFont08    := TFontEx():New(oDanfe,"Times New Roman",07,07,.F.,.T.,.F.)// 4
PRIVATE oFont08N   := TFontEx():New(oDanfe,"Times New Roman",07,07,.T.,.T.,.F.)// 5
PRIVATE oFont09N   := TFontEx():New(oDanfe,"Times New Roman",08,08,.T.,.T.,.F.)// 6
PRIVATE oFont09    := TFontEx():New(oDanfe,"Times New Roman",08,08,.F.,.T.,.F.)// 7
PRIVATE oFont10    := TFontEx():New(oDanfe,"Times New Roman",09,09,.F.,.T.,.F.)// 8
PRIVATE oFont11    := TFontEx():New(oDanfe,"Times New Roman",10,10,.F.,.T.,.F.)// 9
PRIVATE oFont12    := TFontEx():New(oDanfe,"Times New Roman",11,07,.F.,.T.,.F.)// 10
PRIVATE oFont11N   := TFontEx():New(oDanfe,"Times New Roman",10,06,.T.,.T.,.F.)// 11
PRIVATE oFont18N   := TFontEx():New(oDanfe,"Times New Roman",17,17,.T.,.T.,.F.)// 12

PrtDanfe(@oDanfe,oNfe,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³PrtDanfe  ³ Autor ³Eduardo Riera          ³ Data ³16.11.2006³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Impressao do formulario DANFE grafico conforme laytout no   ³±±
±±³          ³formato retrato                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ PrtDanfe()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto grafico de impressao                          ³±±
±±³          ³ExpO2: Objeto da NFe                                        ³±±
±±³          ³ExpC3: Codigo de Autorizacao do fiscal                (OPC) ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function PrtDanfe(oDanfe,oNFE,cCodAutSef,cModalidade,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)

Local aTamanho      := {}
Local aSitTrib      := {}
Local aTransp       := {}
Local aDest         := {}
Local aHrEnt 		:= {}
Local aFaturas      := {}
Local aItens        := {}
Local aISSQN        := {}
Local aTotais       := {}
Local aAux          := {}
Local nHPage        := 0 
Local nVPage        := 0 
Local nPosV         := 0
Local nPosVOld      := 0
Local nPosH         := 0
Local nPosHOld      := 0
Local nAuxH         := 0
Local nAuxV         := 0
Local nX            := 0
Local nY            := 0
Local nTamanho      := 0
Local nFolha        := 1
Local nFolhas       := 0
Local nItem         := 0
Local nMensagem     := 0
Local nBaseICM      := 0
Local nValICM       := 0
Local nValIPI       := 0
Local nPICM         := 0
Local nPIPI         := 0
Local nFaturas      := 0
Local nVTotal       := 0
Local nQtd          := 0
Local nVUnit        := 0
Local nVolume	    := 0
Local cAux          := ""
Local cSitTrib      := ""
Local aMensagem     := {}
Local lPreview      := .F.
Local nLenFatura        
Local nLenVol  
Local nLenDet 
Local nLenSit     
Local nLenItens     := 0
Local nLenMensagens := 0
Local nLen          := 0
Local lImpAnfav     := GetNewPar("MV_IMPANF",.F.)

Default cDtHrRecCab:= ""

nFaturas := IIf(oFatura<>Nil,IIf(ValType(oNF:_InfNfe:_Cobr:_Dup)=="A",Len(oNF:_InfNfe:_Cobr:_Dup),1),0)
oDet := IIf(ValType(oDet)=="O",{oDet},oDet)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Carrega as variaveis de impressao                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aSitTrib,"00")
aadd(aSitTrib,"10")
aadd(aSitTrib,"20")
aadd(aSitTrib,"30")
aadd(aSitTrib,"40")
aadd(aSitTrib,"41")
aadd(aSitTrib,"50")
aadd(aSitTrib,"51")
aadd(aSitTrib,"60")
aadd(aSitTrib,"70")
aadd(aSitTrib,"90")
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Destinatario                                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aDest := {oDestino:_EnderDest:_Xlgr:Text+IIF(", SN"$oDestino:_EnderDest:_Xlgr:Text,"",", "+oDestino:_EnderDest:_NRO:Text + IIf(Type("oDestino:_EnderDest:_xcpl")=="U","",", " + oDestino:_EnderDest:_xcpl:Text)),;
			oDestino:_EnderDest:_XBairro:Text,;
			IIF(Type("oDestino:_EnderDest:_Cep")=="U","",Transform(oDestino:_EnderDest:_Cep:Text,"@r 99999-999")),;
			IIF(Type("oIdent:_DSaiEnt")=="U","",oIdent:_DSaiEnt:Text),;//			oIdent:_DSaiEnt:Text,;
			oDestino:_EnderDest:_XMun:Text,;
			IIF(Type("oDestino:_EnderDest:_fone")=="U","",oDestino:_EnderDest:_fone:Text),;
			oDestino:_EnderDest:_UF:Text,;
			oDestino:_IE:Text,;
			""}	
aadd(aHrEnt,"")				
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do Imposto                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTotais := {"","","","","","","","","","",""}
aTotais[01] := Transform(Val(oTotal:_ICMSTOT:_vBC:TEXT),"@ze 999,999,999.99")
aTotais[02] := Transform(Val(oTotal:_ICMSTOT:_vICMS:TEXT),"@ze 9,999,999.99")
aTotais[03] := Transform(Val(oTotal:_ICMSTOT:_vBCST:TEXT),"@ze 999,999,999.99")
aTotais[04] := Transform(Val(oTotal:_ICMSTOT:_vST:TEXT),"@ze 9,999,999.99")
aTotais[05] := Transform(Val(oTotal:_ICMSTOT:_vProd:TEXT),"@ze 9,999,999.99")
aTotais[06] := Transform(Val(oTotal:_ICMSTOT:_vFrete:TEXT),"@ze 9,999,999.99")
aTotais[07] := Transform(Val(oTotal:_ICMSTOT:_vSeg:TEXT),"@ze 9,999,999.99")
aTotais[08] := Transform(Val(oTotal:_ICMSTOT:_vDesc:TEXT),"@ze 9,999,999.99")
aTotais[09] := Transform(Val(oTotal:_ICMSTOT:_vOutro:TEXT),"@ze 9,999,999.99")
aTotais[10] := 	Transform(Val(oTotal:_ICMSTOT:_vIPI:TEXT),"@ze 9,999,999.99")
aTotais[11] := 	Transform(Val(oTotal:_ICMSTOT:_vNF:TEXT),"@ze 999,999,999.99")	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Faturas                                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFaturas > 0
	For nX := 1 To 3
		aAux := {}
		For nY := 1 To Min(9, nFaturas)
			Do Case
				Case nX == 1
					If nFaturas > 1
						AAdd(aAux, AllTrim(oFatura:_Dup[nY]:_nDup:TEXT))
					Else
						AAdd(aAux, AllTrim(oFatura:_Dup:_nDup:TEXT))
					EndIf
				Case nX == 2
					If nFaturas > 1
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup[nY]:_dVenc:TEXT)))
					Else
						AAdd(aAux, AllTrim(ConvDate(oFatura:_Dup:_dVenc:TEXT)))
					EndIf
				Case nX == 3
					If nFaturas > 1
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup[nY]:_vDup:TEXT), "@E 9999,999,999.99")))
					Else
						AAdd(aAux, AllTrim(TransForm(Val(oFatura:_Dup:_vDup:TEXT), "@E 9999,999,999.99")))
					EndIf
			EndCase
		Next nY
		If nY <= 9
			For nY := nY To 9
				AAdd(aAux, Space(20))
			Next nY
		EndIf
		AAdd(aFaturas, aAux)
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro transportadora                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTransp := {"","0","","","","","","","","","","","","","",""}
                                   
If Type("oTransp:_ModFrete")<>"U"
	aTransp[02] := IIF(Type("oTransp:_ModFrete:TEXT")<>"U",oTransp:_ModFrete:TEXT,"0")
EndIf

If Type("oTransp:_Transporta")<>"U"
	aTransp[01] := IIf(Type("oTransp:_Transporta:_xNome:TEXT")<>"U",oTransp:_Transporta:_xNome:TEXT,"")
	aTransp[03] := IIf(Type("oTransp:_VeicTransp:_RNTC")=="U","",oTransp:_VeicTransp:_RNTC:TEXT)
	aTransp[04] := IIf(Type("oTransp:_VeicTransp:_Placa:TEXT")<>"U",oTransp:_VeicTransp:_Placa:TEXT,"")
	aTransp[05] := IIf(Type("oTransp:_VeicTransp:_UF:TEXT")<>"U",oTransp:_VeicTransp:_UF:TEXT,"")
	If Type("oTransp:_Transporta:_CNPJ:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	ElseIf Type("oTransp:_Transporta:_CPF:TEXT")<>"U"
		aTransp[06] := Transform(oTransp:_Transporta:_CPF:TEXT,"@r 999.999.999-99")
	EndIf
	aTransp[07] := IIf(Type("oTransp:_Transporta:_xEnder:TEXT")<>"U",oTransp:_Transporta:_xEnder:TEXT,"")
	aTransp[08] := IIf(Type("oTransp:_Transporta:_xMun:TEXT")<>"U",oTransp:_Transporta:_xMun:TEXT,"")
	aTransp[09] := IIf(Type("oTransp:_Transporta:_UF:TEXT")<>"U",oTransp:_Transporta:_UF:TEXT,"")
	aTransp[10] := IIf(Type("oTransp:_Transporta:_IE:TEXT")<>"U",oTransp:_Transporta:_IE:TEXT,"")
EndIf
If Type("oTransp:_Vol")<>"U"
    If ValType(oTransp:_Vol) == "A"
	    nX := nPrivate
		    nLenVol := Len(oTransp:_Vol)
	    	For nX := 1 to nLenVol
    		nXAux := nX
    		nVolume += IIF(!Type("oTransp:_Vol[nXAux]:_QVOL:TEXT")=="U",Val(oTransp:_Vol[nXAux]:_QVOL:TEXT),0)
	    Next nX
	    aTransp[11]	:= AllTrim(str(nVolume))
		aTransp[12]	:= IIf(Type("oTransp:_Vol:_Esp")=="U","Diversos","")
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		If  Type("oTransp:_Vol[1]:_PesoB") <>"U"
            	nPesoB := Val(oTransp:_Vol[1]:_PesoB:TEXT)
   				aTransp[15] := AllTrim(str(nPesoB))
  			EndIf
  		If Type("oTransp:_Vol[1]:_PesoL") <>"U"
            nPesoL := Val(oTransp:_Vol[1]:_PesoL:TEXT)
			aTransp[16] := AllTrim(str(nPesoL))
		EndIf
    Else
		aTransp[11] := IIf(Type("oTransp:_Vol:_qVol:TEXT")<>"U",oTransp:_Vol:_qVol:TEXT,"")    
		aTransp[12] := IIf(Type("oTransp:_Vol:_Esp")=="U","",oTransp:_Vol:_Esp:TEXT)
		aTransp[13] := IIf(Type("oTransp:_Vol:_Marca")=="U","",oTransp:_Vol:_Marca:TEXT)
		aTransp[14] := IIf(Type("oTransp:_Vol:_nVol:TEXT")<>"U",oTransp:_Vol:_nVol:TEXT,"")
		aTransp[15] := IIf(Type("oTransp:_Vol:_PesoB:TEXT")<>"U",oTransp:_Vol:_PesoB:TEXT,"")
		aTransp[16] := IIf(Type("oTransp:_Vol:_PesoL:TEXT")<>"U",oTransp:_Vol:_PesoL:TEXT,"")		
    EndIf
    aTransp[15] := strTRan(aTransp[15],".",",")
    aTransp[16] := strTRan(aTransp[16],".",",")    
EndIf



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro Dados do Produto / Serviço                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLenDet := Len(oDet)
For nX := 1 To nLenDet
	nPrivate := nX
	nVTotal  := Val(oDet[nX]:_Prod:_vProd:TEXT)//-Val(IIF(Type("oDet[nPrivate]:_Prod:_vDesc")=="U","",oDet[nX]:_Prod:_vDesc:TEXT))
	nQtd     := Val(oDet[nX]:_Prod:_qTrib:TEXT)
	nVUnit   := Val(oDet[nX]:_Prod:_vUnCom:TEXT)
	nBaseICM := 0
	nValICM  := 0
	nValIPI  := 0
	nPICM    := 0
	nPIPI    := 0
	oImposto := oDet[nX]
	cSitTrib := ""
	If Type("oImposto:_Imposto")<>"U"
		If Type("oImposto:_Imposto:_ICMS")<>"U"
			nLenSit := Len(aSitTrib)
			For nY := 1 To nLenSit
				nPrivate2 := nY
		 		If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2])<>"U"
		 			If Type("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nPrivate2]+":_VBC:TEXT")<>"U"
			 			nBaseICM := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_VBC:TEXT"))
			 			nValICM  := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_vICMS:TEXT"))
			 			nPICM    := Val(&("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_PICMS:TEXT"))
			 		EndIf
			 		cSitTrib := &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_ORIG:TEXT")
			 		cSitTrib += &("oImposto:_Imposto:_ICMS:_ICMS"+aSitTrib[nY]+":_CST:TEXT")
		 		EndIf
			Next nY
		EndIf
		If Type("oImposto:_Imposto:_IPI")<>"U"
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT")<>"U"
				nValIPI := Val(oImposto:_Imposto:_IPI:_IPITrib:_vIPI:TEXT)
			EndIf
			If Type("oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT")<>"U"
				nPIPI   := Val(oImposto:_Imposto:_IPI:_IPITrib:_pIPI:TEXT)
			EndIf
		EndIf
	EndIf
	aadd(aItens,{oDet[nX]:_Prod:_cProd:TEXT,;
					SubStr(oDet[nX]:_Prod:_xProd:TEXT,1,MAXITEMC),;
					IIF(Type("oDet[nPrivate]:_Prod:_NCM")=="U","",oDet[nX]:_Prod:_NCM:TEXT),;
					cSitTrib,;
					oDet[nX]:_Prod:_CFOP:TEXT,;
					oDet[nX]:_Prod:_utrib:TEXT,;
					AllTrim(TransForm(nQtd,TM(nQtd,TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]))),;
					AllTrim(TransForm(nVUnit,TM(nVUnit,TamSX3("D2_PRCVEN")[1],4))),;
					AllTrim(TransForm(nVTotal,TM(nVTotal,TamSX3("D2_TOTAL")[1],TamSX3("D2_TOTAL")[2]))),;
					AllTrim(TransForm(nBaseICM,TM(nBaseICM,TamSX3("D2_BASEICM")[1],TamSX3("D2_BASEICM")[2]))),;
					AllTrim(TransForm(nValICM,TM(nValICM,TamSX3("D2_VALICM")[1],TamSX3("D2_VALICM")[2]))),;
					AllTrim(TransForm(nValIPI,TM(nValIPI,TamSX3("D2_VALIPI")[1],TamSX3("D2_BASEIPI")[2]))),;
					AllTrim(TransForm(nPICM,"@r 99.99%")),;
					AllTrim(TransForm(nPIPI,"@r 99.99%"))})
	cAux := AllTrim(SubStr(oDet[nX]:_Prod:_xProd:TEXT,(MAXITEMC + 1)))
	While !Empty(cAux)
		aadd(aItens,{"",;
					SubStr(cAux,1,MAXITEMC),;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					""})
		cAux := SubStr(cAux,(MAXITEMC + 1))
	EndDo
	
	If (Type("oNf:_infnfe:_det[nPrivate]:_Infadprod:TEXT") <> "U" .Or. Type("oNf:_infnfe:_det:_Infadprod:TEXT") <> "U") .And. lImpAnfav 
		cAux := AllTrim(SubStr(oDet[nX]:_Infadprod:TEXT,1))
	
		While !Empty(cAux)
			aadd(aItens,{"",;
					SubStr(cAux,1,MAXITEMC),;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					"",;
					""})
			cAux := SubStr(cAux,(MAXITEMC + 1))
		EndDo
	EndIf	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro ISSQN                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aISSQN := {"","","",""}
If Type("oEmitente:_IM:TEXT")<>"U"
	aISSQN[1] := oEmitente:_IM:TEXT
EndIf  
If Type("oTotal:_ISSQNtot")<>"U"
	aISSQN[2] := Transform(Val(oTotal:_ISSQNtot:_vServ:TEXT),"@ze 999,999,999.99")	
	aISSQN[3] := Transform(Val(oTotal:_ISSQNtot:_vBC:TEXT),"@ze 999,999,999.99")	
	aISSQN[4] := Transform(Val(oTotal:_ISSQNtot:_vISS:TEXT),"@ze 999,999,999.99")	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro de informacoes complementares                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aMensagem := {}
If Type("oIdent:_tpAmb:TEXT")<>"U" .And. oIdent:_tpAmb:TEXT=="2"
	cAux := "DANFE emitida no ambiente de homologação - SEM VALOR FISCAL"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf
If Type("oNF:_InfNfe:_infAdic:_infAdFisco:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_infAdFisco:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If !Empty(cCodAutSef) .AND. oIdent:_tpEmis:TEXT<>"4"
	cAux := "Protocolo: "+cCodAutSef
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf !Empty(cCodAutSef) .AND. oIdent:_tpEmis:TEXT=="4" .AND. cModalidade $ "1"
	cAux := "Protocolo: "+cCodAutSef
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
	cAux := "DANFE emitida anteriormente em contingência DPEC"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If !Empty(cCodAutDPEC) .And. oIdent:_tpEmis:TEXT=="4"
	cAux := "Número de Registro DPEC: "+cCodAutDPEC
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf

If (Type("oIdent:_tpEmis:TEXT")<>"U" .And. !oIdent:_tpEmis:TEXT$"1,4")
	cAux := "DANFE emitida em contingência"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. !cModalidade $ "1,4,5") .And. Empty(cCodAutSef) 
	cAux := "DANFE emitida em contingência devido a problemas técnicos - será necessária a substituição."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (!Empty(cModalidade) .And. cModalidade $ "5" .And. oIdent:_tpEmis:TEXT=="4") 
	cAux := "DANFE impresso em contingência"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
	cAux := "DPEC regularmento recebido pela Receita Federal do Brasil."
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf (Type("oIdent:_tpEmis:TEXT")<>"U" .And. oIdent:_tpEmis:TEXT$"5")
	cAux := "DANFE emitida em contingência FS-DA"
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo	
EndIf

If Type("oNF:_InfNfe:_infAdic:_infCpl:TEXT")<>"U"
	cAux := oNF:_InfNfe:_infAdic:_InfCpl:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf
 
If Type("oNF:_INFNFE:_IDE:_NFREF:_REFNF:_NNF:TEXT")<>"U" 
	cAux := "Numero da nota original : " + oNF:_INFNFE:_IDE:_NFREF:_REFNF:_NNF:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
ElseIf Type("oNF:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT")<>"U"
	cAux := "Chave de acesso da NF-E referenciada: " + oNF:_INFNFE:_IDE:_NFREF:_REFNFE:TEXT
	While !Empty(cAux)
		aadd(aMensagem,SubStr(cAux,1,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN) - 1, MAXMENLIN)))
		cAux := SubStr(cAux,IIf(EspacoAt(cAux, MAXMENLIN) > 1, EspacoAt(cAux, MAXMENLIN), MAXMENLIN) + 1)
	EndDo
EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do numero de folhas                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nFolhas := 1
nLenItens := Len(aItens)
nLen := nLenItens + Len(aMensagem)
If nLen > (MAXITEM + Min(Len(aMensagem), MAXMSG))
	nFolhas += Int((nLen - (MAXITEM + Min(Len(aMensagem), MAXMSG))) / MAXITEMP2)
	If Mod((nLen - (MAXITEM + Min(Len(aMensagem), MAXMSG))), MAXITEMP2) > 0
		nFolhas++
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao do objeto grafico                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oDanfe == Nil
	lPreview := .T.
	oDanfe 	:= TMSPrinter():New("DANFE - Documento Auxiliar da Nota Fiscal Eletrônica")
	oDanfe:SetPortrait()
	oDanfe:Setup()
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao da pagina do objeto grafico                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:StartPage()
oDanfe:SetPaperSize(9)
nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Box - Recibo de entrega                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamanho := ImpBox(0,0,0,nHPage-Char2Pix(oDanfe,Repl("X",22),oFont10N),;
	{	{"RECEBEMOS DE "+oEmitente:_xNome:Text+" OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO"},;
		{{"DATA DE RECEBIMENTO"," "},{"IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR",PadR(" ",200)}}},;
	oDanfe)
	
aTamanho := ImpBox(0,nHPage-Char2Pix(oDanfe,Repl("X",20),oFont10N),0,nHPage,;
	{	{{PadC("NF-e",20),PadC("N. "+StrZero(Val(oIdent:_NNf:Text),9),20),PadC("SÉRIE "+oIdent:_Serie:Text,20)}}},;
		oDanfe,2)

nPosV    := aTamanho[1]+(VBOX/2)
oDanfe:Line(nPosV,HMARGEM,nPosV,nHPage) 
nPosV    += (VBOX/2)
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro destinatário/remetente                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Do Case
	Case Type("oDestino:_CNPJ")=="O"
		cAux := TransForm(oDestino:_CNPJ:TEXT,"@r 99.999.999/9999-99")
	Case Type("oDestino:_CPF")=="O"
		cAux := TransForm(oDestino:_CPF:TEXT,"@r 999.999.999-99")
	OtherWise
		cAux := Space(14)
EndCase
aTamanho := ImpBox(nPosV,0,0,nHPage-Char2Pix(oDanfe,Repl("X",22),oFont08),;
	{	{{"NOME/RAZÃO SOCIAL",oDestino:_XNome:TEXT},{"CNPJ/CPF",cAux}},;
		{{"ENDEREÇO",aDest[01]},{"BAIRRO/DISTRITO",aDest[02]},{"CEP",aDest[03]}},;
		{{"MUNICIPIO",aDest[05]},{"FONE/FAX",aDest[06]},{"UF",aDest[07]},{"INSCRIÇÃO ESTADUAL",aDest[08]}}},;
	oDanfe,1,"DESTINATÁRIO/REMETENTE")
	
aTamanho := ImpBox(nPosV,nHPage-Char2Pix(oDanfe,Repl("X",20),oFont08),0,nHPage,;
	{	{{"DATA DE EMISSÃO",ConvDate(oIdent:_DEmi:TEXT)}},;
		{{"DATA ENTRADA/SAÍDA", Iif( Empty(aDest[4]),"",ConvDate(aDest[4]) )  }},;
		{{"HORA ENTRADA/SAÍDA",aHrEnt[1]}}},;
	oDanfe,1,"")
nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro fatura                                                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAux := {{{},{},{},{},{},{},{},{},{}}}
nY := 0
For nX := 1 To Len(aFaturas)
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][1])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][2])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][3])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][4])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][5])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][6])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][7])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][8])
	nY++
	aadd(Atail(aAux)[nY],aFaturas[nX][9])
	If nY >= 9
		nY := 0
	EndIf
Next nX

aTamanho := ImpBox(nPosV,0,0,nHPage,aAux,oDanfe,4,"FATURA",{"R","R","R","R","R","R","R","R","R"})
nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do imposto                                                      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"BASE DE CALCULO DO ICMS",aTotais[01]},{"VALOR DO ICMS",aTotais[02]},{"BASE DE CALCULO DO ICMS SUBSTITUIÇÃO",aTotais[03]},{"VALOR DO ICMS SUBSTITUIÇÃO",aTotais[04]},{"VALOR TOTAL DOS PRODUTOS",aTotais[05]}},;
		{{"VALOR DO FRETE",aTotais[06]},{"VALOR DO SEGURO",aTotais[07]},{"DESCONTO",aTotais[08]},{"OUTRAS DESPESAS ACESSÓRIAS",aTotais[09]},{"VALOR DO IPI",aTotais[10]},{"VALOR TOTAL DA NOTA",aTotais[11]}}},;
	oDanfe,1,"CALCULO DO IMPOSTO")
nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transportador/Volumes transportados                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"RAZÃO SOCIAL",aTransp[01]},{"FRETE POR CONTA","0-EMITENTE/1-DESTINATARIO [" + aTransp[02] + "]"},{"CÓDIGO ANTT",aTransp[03]},{"PLACA DO VEÍCULO",aTransp[04]},{"UF",aTransp[05]},{"CNPJ/CPF",aTransp[06]}},;
		{{"ENDEREÇO",aTransp[07]},{"MUNICIPIO",aTransp[08]},{"UF",aTransp[09]},{"INSCRIÇÃO ESTADUAL",aTransp[10]}},;
		{{"QUANTIDADE",aTransp[11]},{"ESPECIE",aTransp[12]},{"MARCA",aTransp[13]},{"NUMERAÇÃO",aTransp[14]},{"PESO BRUTO",aTransp[15]},{"PESO LIQUIDO",aTransp[16]}}},;
	oDanfe,1,"TRANSPORTADOR/VOLUMES TRANSPORTADOS")

nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAux := {{{"COD.PROD."},{"DESCRIÇÃO DO PRODUTO/SERVIÇO"},{"NCM/SH"},{"CST"},{"CFOP"},{"UN"},{"QUANTIDADE"},{"V.UNITARIO"},{"V.TOTAL"},;
		{"BC.ICMS"},{"V.ICMS"},{"V.IPI"},{"A.ICM"},{"A.IPI"}}}
nY := 0
nLenItens := Len(aItens)
For nX := 1 To MIN(MAXITEM,nLenItens)
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][02])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])	
	If nY >= 14
		nY := 0
	EndIf
Next nX
For nX := MIN(MAXITEM,nLenItens) To MAXITEM
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	nY++
	aadd(Atail(aAux)[nY],"")
	If nY >= 14
		nY := 0
	EndIf	
Next nX

aTamanho := ImpBox(nPosV,0,0,nHPage,;
	aAux,;
	oDanfe,3,"DADOS DO PRODUTO / SERVIÇO",{"L","L","L","L","L","L","R","R","R","R","R","R","R","R"},0,;
	{.T., .F., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T.})
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pontilhado entre os produtos/serviços³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Monta o pontilhado
If Len(aAux) > 0
	If Len(aAux[1]) > 1
		If Len(aAux[1][2]) > 3
			// 3 pois com apenas uma linha de produtos o array terá 3, uma para o cabeçalho dos campos, uma linha do produto em si e outra em branco
			// Calcula a posição vertical do pontilhado (utiliza-se oFont08 para o calculo pois na função ImpBox é a fonte usada neste box
			nAuxV := nPosV + ((Char2PixV(oDanfe, "X", oFont08) + SAYVSPACE) * 3)
			For nX := 3 To Len(aAux[1][2])
				nAuxV += SAYVSPACE
				If !Empty(aAux[1][1][nX]) .And. Empty(aAux[1][1][nX - 1])
					// Estamos tratando um novo produto com uma linha de descrição de um produto anterior antes dele
					// Escreve o pontilhado
					For nY := HMARGEM To nHPage
						oDanfe:Say(nAuxV, nY, ".", oFont08:oFont)
						nY += 20
					Next nY
				EndIf
				nAuxV += (Char2PixV(oDanfe, "X", oFont08) + SAYVSPACE * 2)
			Next nX
		EndIf
	EndIf
EndIf

nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Calculo do ISSQN                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{{"INSCRIÇÃO MUNICIPAL",aISSQN[1]},{"VALOR TOTAL DOS SERVIÇOS",aISSQN[2]},{"BASE DE CÁLCULO DO ISSQN",aISSQN[3]},{"VALOR DO ISSQN",aISSQN[4]}}},;
	oDanfe,1,"CáLCULO DO ISSQN")
nPosV    := aTamanho[1]+VSPACE
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados Adicionais                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV+(VSPACE/2)
nPosV += VBOX*4
nPosHOld := HMARGEM
nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS ADICIONAIS",oFont11N:oFont)
nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	oDanfe:Box(nPosVOld,nPosHOld,nVPage,nPosH)
	nAuxH := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont11N),nAuxH,"INFORMAÇÕES COMPLEMENTARES",oFont11N:oFont)	
	nAuxH := (nHPage/2)+10
	oDanfe:Box(nPosVOld,nAuxH+305,nVPage,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont07N),nAuxH+320,"RESERVADO AO FISCO",oFont11N:oFont)	
	nAuxH := nPosHOld+010
	nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
	nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	nLenMensagens := Len(aMensagem)
	nMensagem := 1
	For nX := nMensagem To Min(nLenMensagens, MAXMSG)
		nPosVOld += Char2PixV(oDanfe,"X",oFont12)*2
		oDanfe:Say(nPosVOld,nAuxH,aMensagem[nX],oFont12:oFont)
		nMensagem++
	Next nX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalizacao da pagina do objeto grafico                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:EndPage()
nItem := MAXITEM+1
nLenItens := Len(aItens)
nLenMensagens := Len(aMensagem)
While nItem <= nLenItens .Or. nMensagem <= nLenMensagens
	DanfeCpl(oDanfe,aItens,aMensagem,@nItem,@nMensagem,oNFe,oIdent,oEmitente,@nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)
EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finaliza a Impressão                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
If lPreview
	oDanfe:Preview()
EndIf
Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definicao do Cabecalho do documento                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)

Local aTamanho   := {}
Local aUF		 := {}
Local cLogo      := FisxLogo("1")
Local nHPage     := 0
Local nVPage     := 0 
Local nPosVOld   := 0
Local nPosH      := 0
Local nPosHOld   := 0
Local nAuxV      := 0
Local nAuxH      := 0
Local cChaveCont := ""
Local cDataEmi   := ""
Local cDigito    := ""
Local cTPEmis    := ""
Local cValIcm    := ""
Local cICMSp     := ""
Local cICMSs     := "" 
Local cUF		 := ""
Local cCNPJCPF	 := ""

Private oDPEC    := oNfeDPEC

Default cCodAutSef := ""
Default cCodAutDPEC:= ""
Default cDtHrRecCab:= ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do Array de UF                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aadd(aUF,{"RO","11"})
aadd(aUF,{"AC","12"})
aadd(aUF,{"AM","13"})
aadd(aUF,{"RR","14"})
aadd(aUF,{"PA","15"})
aadd(aUF,{"AP","16"})
aadd(aUF,{"TO","17"})
aadd(aUF,{"MA","21"})
aadd(aUF,{"PI","22"})
aadd(aUF,{"CE","23"})
aadd(aUF,{"RN","24"})
aadd(aUF,{"PB","25"})
aadd(aUF,{"PE","26"})
aadd(aUF,{"AL","27"})
aadd(aUF,{"MG","31"})
aadd(aUF,{"ES","32"})
aadd(aUF,{"RJ","33"})
aadd(aUF,{"SP","35"})
aadd(aUF,{"PR","41"})
aadd(aUF,{"SC","42"})
aadd(aUF,{"RS","43"})
aadd(aUF,{"MS","50"})
aadd(aUF,{"MT","51"})
aadd(aUF,{"GO","52"})
aadd(aUF,{"DF","53"})
aadd(aUF,{"SE","28"})
aadd(aUF,{"BA","29"})
aadd(aUF,{"EX","99"})

nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 1                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosVOld := nPosV
nPosV    := nPosV + 380
nPosHOld := HMARGEM
nPosH    := 1128
	//oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH)
	// nao iprime bitmat devido a ser nf de fornecedor
//	oDanfe:SayBitmap(nPosVOld+5,nPosHOld+5,cLogo,300,090)	
	nAuxV := nPosVOld + SAYVSPACE
    nAuxH := nPosHOld+SAYHSPACE+320
	oDanfe:Say(nAuxV,nAuxH,"identificação do Emitente",oFont08N:oFont)
	nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE+100	
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_xNome:Text,oFont08N:oFont)
	nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xLgr:Text+", "+oEmitente:_EnderEmit:_Nro:Text,oFont10:oFont)
	nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE
	If Type("oEmitente:_EnderEmit:_xCpl") <> "U"
	    oDanfe:Say(nAuxV,nAuxH,"Complemento: " + oEmitente:_EnderEmit:_xCpl:TEXT,oFont10:oFont)
		nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE
	EndIf
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xBairro:Text+" Cep:"+TransForm(IIF(Type("oEmitente:_EnderEmit:_Cep")=="U","",oEmitente:_EnderEmit:_Cep:Text),"@r 99999-999"),oFont10:oFont)
	nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,oEmitente:_EnderEmit:_xMun:Text+"/"+oEmitente:_EnderEmit:_UF:Text,oFont10:oFont)  
	nAuxV += Char2PixV(oDanfe,"X",oFont08N)+SAYVSPACE
	oDanfe:Say(nAuxV,nAuxH,"Fone: "+IIf(Type("oEmitente:_EnderEmit:_Fone")=="U","",oEmitente:_EnderEmit:_Fone:Text),oFont10:oFont)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 2                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosHOld := nPosH+HSPACE
nPosH    := nPosHOld + 360
nAuxV := nPosVOld
oDanfe:Say(nAuxV,nPosHOld,"DANFE",oFont18N:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont18N) + (SAYVSPACE*3)
nAuxH := nPosHOld
oDanfe:Say(nAuxV,nAuxH,"DOCUMENTO AUXILIAR DA",oFont07:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont08) + SAYVSPACE
oDanfe:Say(nAuxV,nAuxH,"NOTA FISCAL ELETRÔNICA",oFont07:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont08) + SAYVSPACE
oDanfe:Say(nAuxV+10,nAuxH,"0-ENTRADA",oFont08:oFont)
oDanfe:Say(nAuxV+40,nAuxH,"1-SAÍDA"  ,oFont08:oFont)
oDanfe:Box(nAuxV+10,nAuxH+170,nAuxV+50,nAuxH+210)
oDanfe:Say(nAuxV+15,nAuxH+180,oIdent:_TpNf:Text,oFont08:oFont)
nAuxV += 10
//oDanfe:Say(nAuxV,nAuxH,IIf(oIdent:_TpNf:Text=="1","SAÍDA","ENTRADA"),oFont18N:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont18N) + (SAYVSPACE*3)
oDanfe:Say(nAuxV,nAuxH,"N. "+StrZero(Val(oIdent:_NNf:Text),9),oFont10N:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
oDanfe:Say(nAuxV,nAuxH,"SÉRIE "+oIdent:_Serie:Text,oFont10N:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
oDanfe:Say(nAuxV,nAuxH,"FOLHA "+StrZero(nFolha,2)+"/"+StrZero(nFolhas,2),oFont10N:oFont)
nAuxV += Char2PixV(oDanfe,"X",oFont11) + SAYVSPACE
nPosHOld := nPosH+HSPACE
nPosH    := nHPage
//oDanfe:Box(nPosVOld,nPosHOld,nPosV,nPosH) 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Codigo de barra                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If nFolha == 1
	oDanfe:Box(260,1430,nPosV,nPosH) 
	oDanfe:Box(260,1100,nPosV,nPosH) 
	oDanfe:Box(510,1430,nPosV,nPosH) 
	oDanfe:Box(420,1430,nPosV,nPosH) 
	oDanfe:Box(520,1430,nPosV,nPosH) 
	MSBAR3("CODE128",2.4*(300/PixelY),12.55*(299/PixelX),SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.9,/*lBanner*/,/*cFont*/,"C",.F.)
	oDanfe:Say(430,1463,"CHAVE DE ACESSO DA NF-E",oFont07N:oFont)	
	oDanfe:Say(450,1463,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont10N:oFont)		
Else
	oDanfe:Box(030,1448,nPosV,nPosH) 
	oDanfe:Box(030,1108,nPosV,nPosH) 
	oDanfe:Box(260,1448,nPosV,nPosH) 
	oDanfe:Box(180,1448,nPosV,nPosH)
	oDanfe:Box(270,1448,nPosV,nPosH) 	 
	MSBAR3("CODE128",0.37*(300/PixelY),12.4*(299/PixelX),SubStr(oNF:_InfNfe:_ID:Text,4),oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.9,/*lBanner*/,/*cFont*/,"C",.F.)
	oDanfe:Say(200,1463,"CHAVE DE ACESSO DA NF-E",oFont07N:oFont)	
	oDanfe:Say(225,1463,TransForm(SubStr(oNF:_InfNfe:_ID:Text,4),"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999 9999"),oFont10N:oFont)	
EndIf

If !Empty(cCodAutDPEC) .And. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"4"
	cUF      := aUF[aScan(aUF,{|x| x[1] == oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_UF:Text})][02]
	cDataEmi := Substr(oNF:_InfNfe:_IDE:_DEMI:Text,9,2)
	cTPEmis  := "4"
	cValIcm  := StrZero(Val(StrTran(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VNF:TEXT,".","")),14)
	cICMSp   := iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VICMS:TEXT)>0,"1","2")
	cICMSs   :=iif(Val(oDPEC:_ENVDPEC:_INFDPEC:_RESNFE:_VST:TEXT)>0,"1","2")
ElseIF (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25"
	cUF      := aUF[aScan(aUF,{|x| x[1] == oNFe:_NFE:_INFNFE:_DEST:_ENDERDEST:_UF:Text})][02]
	cDataEmi := Substr(oNFe:_NFE:_INFNFE:_IDE:_DEMI:Text,9,2)
	cTPEmis  := oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT
	cValIcm  := StrZero(Val(StrTran(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT,".","")),14)
	cICMSp   := iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VICMS:TEXT)>0,"1","2")
	cICMSs   :=iif(Val(oNFe:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VST:TEXT)>0,"1","2")
EndIf
If !Empty(cUF) .And. !Empty(cDataEmi) .And. !Empty(cTPEmis) .And. !Empty(cValIcm) .And. !Empty(cICMSp) .And. !Empty(cICMSs)
	If Type("oNF:_InfNfe:_DEST:_CNPJ:Text")<>"U"
		cCNPJCPF := oNF:_InfNfe:_DEST:_CNPJ:Text
		If cUf == "99"
			cCNPJCPF := STRZERO(val(cCNPJCPF),14)
		EndIf
	ElseIf Type("oNF:_INFNFE:_DEST:_CPF:Text")<>"U"
		cCNPJCPF := oNF:_INFNFE:_DEST:_CPF:Text
		cCNPJCPF := STRZERO(val(cCNPJCPF),14)
	Else
		cCNPJCPF := ""
	EndIf
	cChaveCont += cUF+cTPEmis+cCNPJCPF+cValIcm+cICMSp+cICMSs+cDataEmi
	cChaveCont := cChaveCont+Modulo11(cChaveCont)
EndIf	

If !Empty(cChaveCont) .And. Empty(cCodAutDPEC) .And. !(Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900)
	If nFolha == 1
		If !Empty(cChaveCont)
			MSBAR3("CODE128",4.5*(300/PixelY),12.4*(300/PixelX),cChaveCont,oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.9,/*lBanner*/,/*cFont*/,"C",.F.)	
		EndIf
	Else
		If !Empty(cChaveCont)	
			MSBAR3("CODE128",2.4*(300/PixelY),12.4*(300/PixelX),cChaveCont,oDanfe,/*lCheck*/,/*Color*/,/*lHorz*/,.02960,0.9,/*lBanner*/,/*cFont*/,"C",.F.)	
		EndIf
	EndIf		
Else
	If nFolha == 1
		oDanfe:Say(560,1463,"Consulta de autenticidade no portal nacional da NF-e",oFont10:oFont)	
		oDanfe:Say(590,1463,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont10:oFont)		
	Else
		oDanfe:Say(300,1463,"Consulta de autenticidade no portal nacional da NF-e",oFont10:oFont)	
		oDanfe:Say(330,1463,"www.nfe.fazenda.gov.br/portal ou no site da SEFAZ Autorizada",oFont10:oFont)			
	EndIf
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Quadro 4                                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nPosV += VSPACE
aTamanho := ImpBox(nPosV,0,0,nHPage,;
	{	{	{"NATUREZA DA OPERAÇÃO",oIdent:_NATOP:TEXT},;
			{IIF(!Empty(cCodAutDPEC),"NÚMERO DE REGISTRO DPEC",IIF(((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1","PROTOCOLO DE AUTORIZAÇÃO DE USO",IIF((oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"25","DADOS DA NF-E",""))),;
			IIF(!Empty(cCodAutDPEC),cCodAutDPEC+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),IIF(!Empty(cCodAutSef) .And. ((Val(oNF:_INFNFE:_IDE:_SERIE:TEXT) >= 900).And.(oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"2") .Or. (oNFe:_NFE:_INFNFE:_IDE:_TPEMIS:TEXT)$"1",cCodAutSef+" "+AllTrim(ConvDate(oNF:_InfNfe:_IDE:_DEMI:Text))+" "+AllTrim(cDtHrRecCab),TransForm(cChaveCont,"@r 9999 9999 9999 9999 9999 9999 9999 9999 9999")))}},;
		{	{"INSCRIÇÃO ESTADUAL",IIf(Type("oEmitente:_IE:TEXT")<>"U",oEmitente:_IE:TEXT,"")},;
			{"INSC.ESTADUAL DO SUBST.TRIB.",IIf(Type("oEmitente:_IEST:TEXT")<>"U",oEmitente:_IEST:TEXT,"")},;
			{"CNPJ",TransForm(oEmitente:_CNPJ:TEXT,IIf(Len(oEmitente:_CNPJ:TEXT)<>14,"@r 999.999.999-99","@r 99.999.999/9999-99"))}}},;
	oDanfe)
	
nPosV := aTamanho[1]

nFolha++      
Return(nPosV)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Impressao do Complemento da NFe                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function DanfeCpl(oDanfe,aItens,aMensagem,nItem,nMensagem,oNFe,oIdent,oEmitente,nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)

Local nAuxV         := 0
Local nX            := 0
Local nY            := 0
Local nHPage        := 0 
Local nVPage        := 0 
Local nPosV         := VMARGEM
Local aAux          := {}
Local nLenItens     := Len(aItens)
Local nLenMensagens := Len(aMensagem)
Local nItemOld	    := nItem
Local nMensagemOld  := nMensagem
Local nForItens     := 0
Local nForMensagens := 0
Local lItens        := .F.
Local lMensagens    := .F.

If (nLenItens - (nItemOld - 1)) > 0
	lItens := .T.
EndIf
If (nLenMensagens - (nMensagemOld - 1)) > 0
	lMensagens := .T.
EndIf

oDanfe:StartPage()
nPosV := DanfeCab(oDanfe,nPosV,oNFe,oIdent,oEmitente,@nFolha,nFolhas,cCodAutSef,oNfeDPEC,cCodAutDPEC,cDtHrRecCab)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nHPage := oDanfe:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oDanfe:nVertRes() 
nVPage *= (300/PixelY)
nVPage -= VBOX
nPosV  += (VBOX/2)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados do produto ou servico                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAux := {{{"COD.PROD."},{"DESCRIÇÃO DO PRODUTO/SERVIÇO"},{"NCM/SH"},{"CST"},{"CFOP"},{"UN"},{"QUANTIDADE"},{"V.UNITARIO"},{"V.TOTAL"},;
		{"BC.ICMS"},{"V.ICMS"},{"V.IPI"},{"A.ICM"},{"A.IPI"}}}
nY := 0
nForItens := Min(nLenItens, MAXITEMP2 + (nItemOld - 1) - Min(nLenMensagens - (nMensagemOld - 1), Int(MAXITEMP2 / 2)))
For nX := nItem To nForItens
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][01])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][02])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][03])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][04])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][05])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][06])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][07])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][08])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][09])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][10])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][11])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][12])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][13])
	nY++
	aadd(Atail(aAux)[nY],aItens[nX][14])	
	If nY >= 14
		nY := 0
	EndIf
	nItem++
Next nX

If lItens
	aTamanho := ImpBox(nPosV,0,Iif(lMensagens, 0, nVPage),nHPage,;
		aAux,;
		oDanfe,3,"DADOS DO PRODUTO / SERVIÇO",{"L","L","L","L","L","L","R","R","R","R","R","R","R","R"},0,;
		{.T., .F., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T., .T.})
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pontilhado entre os produtos/serviços³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Monta o pontilhado
	If Len(aAux) > 0
		If Len(aAux[1]) > 1
			If Len(aAux[1][2]) > 3
				// 3 pois com apenas uma linha de produtos o array terá 3, uma para o cabeçalho dos campos, uma linha do produto em si e outra em branco
				// Calcula a posição vertical do pontilhado (utiliza-se oFont08 para o calculo pois na função ImpBox é a fonte usada neste box
				nAuxV := nPosV + ((Char2PixV(oDanfe, "X", oFont08) + SAYVSPACE) * 3)
				For nX := 3 To Len(aAux[1][2])
					nAuxV += SAYVSPACE
					If !Empty(aAux[1][1][nX]) .And. Empty(aAux[1][1][nX - 1])
						// Estamos tratando um novo produto com uma linha de descrição de um produto anterior antes dele
						// Escreve o pontilhado
						For nY := HMARGEM To nHPage
							oDanfe:Say(nAuxV, nY, ".", oFont08:oFont)
							nY += 20
						Next nY
					EndIf
					nAuxV += (Char2PixV(oDanfe, "X", oFont08) + SAYVSPACE * 2)
				Next nX
			EndIf
		EndIf
	EndIf
	
	nPosV := aTamanho[1]+VSPACE
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Dados Adicionais³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lMensagens
	nPosVOld := nPosV+(VSPACE/2)
	nPosV += VBOX*4
	nPosHOld := HMARGEM
	nPosH    := nHPage
	oDanfe:Say(nPosVOld,nPosHold,"DADOS ADICIONAIS",oFont11N:oFont)
	nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
	nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	oDanfe:Box(nPosVOld,nPosHOld,nVPage,nPosH)
	nAuxH := nPosHOld+010
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont11N),nAuxH,"INFORMAÇÕES COMPLEMENTARES",oFont11N:oFont)
	nAuxH := (nHPage/2)+10
	oDanfe:Box(nPosVOld,nAuxH+305,nVPage,nPosH)
	oDanfe:Say(nPosVOld+Char2PixV(oDanfe,"X",oFont07N),nAuxH+320,"RESERVADO AO FISCO",oFont11N:oFont)
	nAuxH := nPosHOld+010
	nPosV    += Char2PixV(oDanfe,"X",oFont11N)*2
	nPosVOld += Char2PixV(oDanfe,"X",oFont11N)*2
	nLenMensagens := Len(aMensagem)
	nForMensagens := Min(nLenMensagens, MAXITEMP2 + (nMensagemOld - 1) - (nItem - nItemOld))
	For nX := nMensagem To nForMensagens
		nPosVOld += Char2PixV(oDanfe,"X",oFont12)*2
		oDanfe:Say(nPosVOld,nAuxH,aMensagem[nX],oFont12:oFont)
		nMensagem++
	Next nX
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Finalizacao da pagina do objeto grafico                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oDanfe:EndPage()
Return(.T.)


Static Function Char2Pix(oDanfe,cTexto,oFont)
Local nX := 0
DEFAULT aUltChar2pix := {}
nX := aScan(aUltChar2pix,{|x| x[1] == cTexto .And. x[2] == oFont:oFont})

If nX == 0
	
	//aadd(aUltChar2pix,{cTexto,oFont:oFont,oDanfe:GetTextWidht(cTexto,oFont)*(300/PixelX)})
	aadd(aUltChar2pix,{cTexto,oFont:oFont, oFont:GetTextWidht(cTexto) *(300/PixelX)})
	
	nX := Len(aUltChar2pix)
EndIf

Return(aUltChar2pix[nX][3])


Static Function Char2PixV(oDanfe,cChar,oFont)
Local nX := 0
DEFAULT aUltVChar2pix := {}

cChar := SubStr(cChar,1,1)
nX := aScan(aUltVChar2pix,{|x| x[1] == cChar .And. x[2] == oFont:oFont})
If nX == 0                                                                    
	//aadd(aUltVChar2pix,{cChar,oFont:oFont,oDanfe:GetTextWidht(cChar,oFont)*(300/PixelY)})
	aadd(aUltVChar2pix,{cChar,oFont:oFont, oFont:GetTextWidht(cChar) *(300/PixelY)})
	nX := Len(aUltVChar2pix)
EndIf

Return(aUltVChar2pix[nX][3])

Static Function ImpBox(nPosVIni,nPosHIni,nPosVFim,nPosHFim,aImp,oDanfe,nTpFont,cTitulo,aAlign,nColAjuste,aColAjuste)
Local aTamanho      := {}
Local nX            := 0
Local nY            := 0
Local nZ            := 0
Local nLenColAjuste := 0
Local nMaxnX        := Len(aImp)
Local nMaxnY        := 0
Local nMaxnZ        := 0
Local nPosV1        := nPosVIni
Local nPosV2        := nPosVIni
Local nPosH1        := nPosHIni
Local nPosH2        := nPosHIni
Local nAuxH         := 0
Local nAuxV         := 0
Local nTam          := 0
Local nDif          := 0
Local nMaxTam       := 0
//Local cMaxTam       := ""
Local aFont         := {{oFont07N,oFont08},{oFont10N,oFont11},{oFont11N,oFont12},{oFont08,oFont08}}
Local lTitulo       := .T.
Local lTemTit       := .F.
Local nCharPix
Local nLenAlign
Local nForAlign
Local nLenTam

DEFAULT nTpFont    := 1
DEFAULT aAlign     := {}
DEFAULT nColAjuste := 0
/**
 * Caso o nColAjuste seja 0, este array terá quais campos irão receber o ajuste
 * de tamanho, utilizando booleano para cada coluna do box.
 */
DEFAULT aColAjuste := {}

For nX := 1 To nMaxnX

	nMaxnY  := Len(aImp[nX])
	nPosV1  := IIF(nPosV1 == 0 , VMARGEM , nPosV1 )
	nPosV2  := nPosV1 + VBOX	
	
	/**
	 * O array é limpo para as próximas dimensões.
	 */
	aTamanho := {}
	
	/**
	 * Completa o array de ajuste de colunas de acordo com o número de posições
	 * que o array de dados possui.
	 */
	If Len(aColAjuste) < nMaxnY
		For nY := (Len(aColAjuste) + 1) To nMaxnY
			AAdd(aColAjuste, .T.)
		Next nY
	EndIf
	
	//----------------------------------------
	// [TODO - Confirmar lógica]
	// Foi alterado para aumentar performance
	//----------------------------------------
	/*
	For nY := 1 To nMaxnY
		If Len(aAlign) < nY
			aadd(aAlign,"L")
		EndIf
	Next nY
	*/	              
	/**
	 * Popula o array de alinhamentos para bater o número de posições com o array
	 * de dados.
	 * Adiciona alinhamentos a esquerda ("L") para tanto.
	 */
	nLenAlign := Len(aAlign)
	nForAlign := (nMaxnY - nLenAlign)
	If nForAlign > 0
		For nY := 1 To nForAlign
			aadd(aAlign,"L")
		Next nY
	Endif 
	//----------------------------------------
	
	/**
	 * Popula as posições vazias do array aTamanho com o tamanho flexível que o
	 * Box terá, caso o número de posições dele não bata com o número de posições
	 * do array aImp.
	 */
	For nY := 1 To nMaxnY
		If Valtype(aImp[nX][nY]) == "A"
			nMaxnZ := Len(aImp[nX][nY])
			nMaxTam := 0 //cMaxTam:= ""
			For nZ := 1 To nMaxnZ
				If nMaxTam < (oDanfe:GetTextWidth(aImp[nX][nY][nZ], aFont[nTpFont][IIf(nZ==1, 1, 2)]:oFont) + HSPACE * 2) //cMaxTam < Len(AllTrim(aImp[nX][nY][nZ]))
					nMaxTam := oDanfe:GetTextWidth(aImp[nX][nY][nZ], aFont[nTpFont][IIf(nZ==1, 1, 2)]:oFont) + HSPACE * 2 //cMaxTam := AllTrim(aImp[nX][nY][nZ])
				EndIf
			Next nZ
			//aadd(aTamanho,(Char2Pix(oDanfe,cMaxTam,aFont[nTpFont][2])+HSPACE+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)))
			AAdd(aTamanho, nMaxTam)
		Else
			//aadd(aTamanho,(Char2Pix(oDanfe,aImp[nX][nY],aFont[nTpFont][2])+HSPACE))
			AAdd(aTamanho, oDanfe:GetTextWidth(aImp[nX][nY], aFont[nTpFont][2]:oFont) + HSPACE * 2)
		EndIf
	Next nY
    /**
     * Caso o tamanho de cada coluna somados não de o tamanho total da página,
     * o espaço restante é ou distribuido igualmente entre as colunas (caso
     * nColAjuste == 0) ou na coluna especificada na variável nColAjuste.
     */
    nTam := 0
    nLenTam := Len(aTamanho)
    For nY := 1 To nLenTam
		nTam += aTamanho[nY]
	Next nY	
	If nTam <= (nPosHFim - nPosHIni)
		If nColAjuste == 0
			nLenColAjuste := 0
			For nY := 1 To Len(aColAjuste)
				If aColAjuste[nY]
					nLenColAjuste++
				EndIf
			Next nY
			nDif := Int(((nPosHFim - nPosHIni - IIF(nPosHIni == 0 , HMARGEM , nPosHIni )) - nTam) / nLenColAjuste)
			nLenTam := Len(aTamanho)
		    For nY := 1 To nLenTam
		    	If aColAjuste[nY]
					aTamanho[nY] += nDif
				EndIf
			Next nY
		Else
			nDif := Int(((nPosHFim - nPosHIni - IIF(nPosHIni == 0 , HMARGEM , nPosHIni )) - nTam))
			aTamanho[nColAjuste] += nDif
		EndIf
	EndIf
	
	/**
	 * Desenha o(s) box(es) e a(s) informação(ões).
	 */
	For nY := 1 To nMaxnY
		nPosH1 := IIF(nPosH1 == 0 , HMARGEM , nPosH1 )
		If cTitulo <> Nil .And. lTitulo
			lTitulo := .F.
			lTemTit := .T.
			oDanfe:Say(nPosV1,nPosH1,cTitulo,aFont[nTpFont][1]:oFont)	

			nCharPix := Char2PixV(oDanfe,"X",aFont[nTpFont][1])+SAYVSPACE
			nPosV1 += nCharPix 
			nPosV2 += nCharPix
		EndIf		
		If Valtype(aImp[nX][nY]) == "A"

			nMaxnZ := Len(aImp[nX][nY])
			If nY == nMaxnY
				nPosH2 := nPosHFim
				If nMaxnY > 1
					nPosH1 := Max(nPosH1,nPosHFim-aTamanho[nY])
				EndIf
			Else
				nPosH2 := Min(nPosHFim,nPosH1+aTamanho[nY])
			EndIf

			If nMaxnZ >= 2 .And. nY == 1
				If nPosVFim <> 0
					nPosV2 := nPosVFim
				Else
					nAuxV := 0
					For nZ := 1 To nMaxnZ
						nAuxV += Char2PixV(oDanfe,"X",aFont[nTpFont][IIf(nZ==1,1,2)])+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)
					Next nZ
					nAuxV := Int(nAuxV/(VBOX + VSPACE))
					nPosV2 += (VBOX + VSPACE)*nAuxV
				EndIf
			EndIf
			oDanfe:Box(nPosV1,nPosH1,nPosV2,nPosHFim)
			If aAlign[nY] == "R"
				nAuxH := nPosH2 - HSPACE
			Else
				nAuxH := nPosH1 + SAYHSPACE
			EndIf
			nAuxV := nPosV1
			For nZ := 1 To nMaxnZ									
				nAuxV += Char2PixV(oDanfe,"X",aFont[nTpFont][IIf(nZ==1,1,2)])+IIF(nZ>1,SAYVSPACE*nTpFont,-1*SAYVSPACE)
				
				/**
				 * Trata o tag [ e ].
				 */
				cInf := ""
				cBox := ""
				
				If At("[", aImp[nX][nY][nZ]) > 0 .And. At("]", aImp[nX][nY][nZ]) > 0 .And. (At("]", aImp[nX][nY][nZ]) - At("[", aImp[nX][nY][nZ])) > 0
					If At("[", aImp[nX][nY][nZ]) > 1
						cInf := Substr(aImp[nX][nY][nZ], 1, At("[", aImp[nX][nY][nZ]) - 1)
					EndIf
					cBox := Substr(aImp[nX][nY][nZ], At("[", aImp[nX][nY][nZ]) + 1, At("]", aImp[nX][nY][nZ]) - At("[", aImp[nX][nY][nZ]) - 1)
				Else
					cInf := aImp[nX][nY][nZ]
				EndIf
				
				If aAlign[nY] == "R"
					oDanfe:Say(nAuxV,;
						nAuxH - (oDanfe:GetTextWidth(aImp[nX][nY][nZ], aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + IIf(!Empty(cBox), oDanfe:GetTextWidth(cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE * 4, 0)),;
						aImp[nX][nY][nZ],;
						aFont[nTpFont][IIf(nZ==1,1,2)]:oFont)
					If !Empty(cBox)    // Monta o box caso exista
						oDanfe:Box(nAuxV - VSPACE,;
							nAuxH - (oDanfe:GetTextWidth(cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE * 3),;
							nAuxV + oDanfe:GetTextHeight("X", aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + VSPACE,;
							nAuxH - HSPACE)
						oDanfe:Say(nAuxV, nAuxH - (oDanfe:GetTextWidth(cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE * 2), cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont)
					EndIf
				Else
					oDanfe:Say(nAuxV,nAuxH,cInf,aFont[nTpFont][IIf(nZ==1,1,2)]:oFont)
					If !Empty(cBox)    // Monta o box caso exista
						oDanfe:Box(nAuxV - VSPACE,;
							nAuxH + oDanfe:GetTextWidth(cInf, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE,;
							nAuxV + oDanfe:GetTextHeight("X", aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + VSPACE,;
							nAuxH + oDanfe:GetTextWidth(cInf, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE + oDanfe:GetTextWidth(cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE * 2)
						oDanfe:Say(nAuxV, nAuxH + oDanfe:GetTextWidth(cInf, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont) + HSPACE * 2, cBox, aFont[nTpFont][IIf(nZ==1,1,2)]:oFont)
					EndIf
				EndIf
			Next nZ
			nPosH1 := nPosH2
		Else
			If nY == nMaxnY
				nPosH2 := nPosHFim
			Else
				nPosH2 := Min(nPosHFim,aTamanho[nY])
			EndIf
			
			oDanfe:Box(nPosV1,nPosH1,nPosV2,nPosHFim)
			If aAlign[nY] == "R"
				nAuxH := nPosH2 - Char2Pix(oDanfe,aImp[nX][nY],aFont[nTpFont][2]) - HSPACE
			Else
				nAuxH := nPosH1 + SAYHSPACE
			EndIf
			nAuxV := nPosV1+Char2PixV(oDanfe,aImp[nX][nY],aFont[nTpFont][2])
			oDanfe:Say(nAuxV,nAuxH,aImp[nX][nY],aFont[nTpFont][2]:oFont)
			nPosH1 := nPosH2
		EndIf
    Next nY
    nPosV1 := nPosV2 + IIF(lTemTit,0,VSPACE)
    nPosV2 := 0
    nPosH1 := nPosHIni
    nPosH2 := 0
Next nX

Return({nPosV1,nPosH1})