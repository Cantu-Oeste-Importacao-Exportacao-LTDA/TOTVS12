#INCLUDE "PROTHEUS.CH"
#INCLUDE "xmlxfun.CH"
#INCLUDE "TOPCONN.CH"


User Function ExpXmlPro()
Local cModelo := ''
Local cXml := '' , oXml
Local nL := 0
Local nSaldo := 0
Local aItens := {}
Local aFTPKmv := {}
Local aFTPPS  := {}
Local cFolderFTP := ""
Local cModo 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//U_USORWMAKE(ProcName(),FunName())

RpcSetType(3)
RpcSetEnv("30","01")

aFTPKmv := StrToKArr(SuperGetMv("MVX_FTPKMV",.F.,"www.kmvpneus.com.br;21;kmvpneus;topgear"),";")
aFTPPS  := StrToKArr(SuperGetMv("MVX_FTPPS" ,.F.,"www.pneustore.com.br;21;pneustore;topgear"),";")
cFolderFTP := SuperGetMv("MVX_FOLDPR" ,.F.,"/acceptance/produtos")

Makedir("\Adena\produtos\")
cDir := GetSrvProfString("ROOTPATH","") + "Adena/Produtos"

//sql
cQuery := "SELECT ZX0_EMPEXP, ZX0_FILEXP, ZX0_LOCAL, B1_COD "
cQuery += " FROM " + RetSqlName("SB1") + " SB1, " + RetSqlName("ZX0") + "  ZX0   "
cQuery += " WHERE (B1_COD = ZX0_PRODUT OR B1_GRUPO = ZX0_GRUPO) AND "
cQuery += " SB1.D_E_L_E_T_ <> '*' AND"
cQuery += " ZX0.D_E_L_E_T_ <> '*'"   
cQuery += " AND B1_GRUPO <> ' '"    
cQuery += " ORDER BY ZX0_EMPEXP, ZX0_FILEXP, ZX0_LOCAL, B1_COD"

cQuery := ChangeQuery(cQuery)

If Select("WORK") != 0
	WORK->( DbCloseArea() )
EndIf

TCQUERY cQuery NEW ALIAS "WORK"
dbSelectArea("WORK")

//soma o saldo de todas as empresas e armazens
If WORK->(!EOF())
	
	While WORK->(!EOF())
		
		If WORK->ZX0_EMPEXP <> "30"
			EmpOpenFile("SB2","SB2",1,.T.,WORK->ZX0_EMPEXP,@cModo)
		EndIf
		
		dbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		SB2->(DbSeek(WORK->ZX0_FILEXP+WORK->B1_COD+WORK->ZX0_LOCAL))
		
		nSaldo := SaldoSB2()
		
		If nSaldo > 0
			
			If ( nPos :=  AScan(aItens,{|x| x[1] == Alltrim(WORK->B1_COD)} ) ) > 0   //somar com os ja existentes
				aItens[nPos][2] += nSaldo
			else
				aadd(aItens,{Alltrim(WORK->B1_COD),nSaldo})
			EndIf
		Endif
		
		SB2->( dbCloseArea() )
		
		WORK->(dbSkip())
		
	EndDo
	
EndIf

//separa o estoque, conforme regra passada por Rafael
// 1 -  4       100% pneustore
// 5 - 10        60% pneustore 40%kmv
// acima de 11   70% pneustore 30%kmv

aItensPS := {}
aItensKM := {}

For i:=1 To len(aItens)
	
	cCodProd := aItens[i][1]
	nSaldo   := aItens[i][2]
	
	IF (nSaldo <= 4)
		
		aAdd(aItensPS,{cCodProd,nSaldo})
		
	ELSEIF (nSaldo >= 5 .AND. nSaldo <= 10 )
		
		aAdd(aItensPS,{cCodProd,ROUND((nSaldo*0.6),0)})
		aAdd(aItensKM,{cCodProd,(nSaldo - ROUND((nSaldo*0.6),0))})
		
	ELSE
		
		aAdd(aItensPS,{cCodProd,ROUND((nSaldo*0.7),0)})
		aAdd(aItensKM,{cCodProd,(nSaldo - ROUND((nSaldo*0.7),0))})
		
	ENDIF
	
Next

/**********************
Gera xml Pneustore
**********************/
cModelo := ''
cModelo +=  '<?xml version="1.0" encoding="UTF-8"?>'
cModelo += 	'<estoques>'
cModelo += 	'<estoque>'
cModelo +=  '<sku></sku>'
cModelo += 	'<saldo></saldo>'
cModelo += 	'</estoque>'
cModelo += 	'</estoques>'

CREATE oXML XMLSTRING cModelo SETASARRAY _Estoques:_Estoque

nXmlStatus := XMLError()

If ( nXmlStatus == XERROR_SUCCESS )
	
	oXml:__XML:_ENCODING:TEXT := RemAspas(oXml:__XML:_ENCODING:TEXT)
	oXml:__XML:_VERSION:TEXT := RemAspas(oXml:__XML:_VERSION:TEXT)
	
Endif

nL := 0
For j:=1 To Len(aItensPS)
	nL++
	oXml:_Estoques:_Estoque[nL]:_SKU:TEXT   := Alltrim(aItensPS[j][1])
	oXml:_Estoques:_Estoque[nL]:_saldo:TEXT := Alltrim(Str(aItensPS[j][2]))  
	ADDNODE oXml:_Estoques:_Estoque NODE '_Estoque' ON oXML
Next

// Ao fim do processo , gera a string XML correspondente ao Objeto

SAVE oXml XMLSTRING cXml

MemoWrite(cDir+"\estoque.xml",cXml)

If FTPConnect(aFTPPS[1],Val(aFTPPS[2]),aFTPPS[3],aFTPPS[4])
	If FTPDirChange(cFolderFTP)
		if !FTPUPLOAD( "/adena/produtos/estoque.xml" , "estoque.xml" )
			//	Aviso( "CEXPKTN", "Nao foi possivel enviar arquivo!!", {"Ok"} )
		Endif
		
		FTPDISCONNECT()
	endif
Endif


If FErase("/adena/produtos/estoque.xml"  ) != 0
	//	Aviso( "CEXPKTN	", "erro ao excluir arquivos", {"Ok"} )
Endif

/************
Gera xml KMV
************/
cModelo := ''
cModelo +=  '<?xml version="1.0" encoding="UTF-8"?>'
cModelo += 	'<estoques>'
cModelo += 	'<estoque>'
cModelo +=  '<sku></sku>'
cModelo += 	'<saldo></saldo>'
cModelo += 	'</estoque>'
cModelo += 	'</estoques>'

CREATE oXML XMLSTRING cModelo SETASARRAY _Estoques:_Estoque

nXmlStatus := XMLError()

If ( nXmlStatus == XERROR_SUCCESS )
	
	oXml:__XML:_ENCODING:TEXT := RemAspas(oXml:__XML:_ENCODING:TEXT)
	oXml:__XML:_VERSION:TEXT := RemAspas(oXml:__XML:_VERSION:TEXT)
	
Endif 

nL := 0
For j:=1 To Len(aItensKM)
	nL++
	oXml:_Estoques:_Estoque[nL]:_SKU:TEXT := Alltrim(aItensKM[j][1])
	oXml:_Estoques:_Estoque[nL]:_saldo:TEXT := Alltrim(Str(aItensKM[j][2]))   
	ADDNODE oXml:_Estoques:_Estoque NODE '_Estoque' ON oXML
Next

ADDNODE oXml:_Estoques:_Estoque NODE '_Estoque' ON oXML

// Ao fim do processo , gera a string XML correspondente ao Objeto

SAVE oXml XMLSTRING cXml

MemoWrite(cDir+"\estoque.xml",cXml)

If FTPConnect(aFTPKmv[1],Val(aFTPKmv[2]),aFTPKmv[3],aFTPKmv[4])
	If FTPDirChange(cFolderFTP)
		If !FTPUPLOAD( "/adena/produtos/estoque.xml"  , "estoque.xml" )
			//	Aviso( "CEXPKTN", "Nao foi possivel enviar arquivo!!", {"Ok"} )
		Endif
		
		FTPDISCONNECT()
	endif
Endif

If FErase("/adena/produtos/estoque.xml"  ) != 0
	//	Aviso( "CEXPKTN	", "erro ao excluir arquivos", {"Ok"} )
Endif

Return

Static function RemAspas(cx)

if left(cx,1) == '"' .and. right(cx,1) == '"'
	
	return substr(cx,2,len(cx)-2)
	
Elseif left(cx,1) == "'" .and. right(cx,1) == "'"
	
	return substr(cx,2,len(cx)-2)
	
Endif

return cx
