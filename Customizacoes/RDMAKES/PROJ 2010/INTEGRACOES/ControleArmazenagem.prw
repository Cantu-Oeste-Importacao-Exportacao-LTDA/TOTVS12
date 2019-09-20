#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#include "protheus.ch"
#include "TBICONN.CH"
#include "fileio.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณGNFTRCARG บAutor  ณ                     บ Data ณ 29/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que monta a tela para selecionar a carga e a s้rie   บฑฑ
ฑฑบ          ณque se deseja gerar a transfer๊ncia.                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*--------------------------*
User Function GNFTRCARG()   
*--------------------------*
Local   aCpos         := {}
local   cPerg         := "DEVOARMAZE"
Private cSerie        := Space(TAMSX3("F2_SERIE")[1])
Private lProcessa     := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณPerguntas de data e nota fiscalณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	AJUSTASX1(cPerg)
	If !Pergunte(cPerg,.T.)
		Return
	EndIf
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณBusca as notas de saํda de acordo com as perguntas para mostrar no listณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cEMPFIL := "%'"+cEmpAnt+cFilAnt+"'%"
	cCODEMP := "%'"+cEmpAnt+"'%"
	cCODFIL := "%'"+cFilAnt+"'%"
	
	BeginSql Alias "TMPSF2"   
		SELECT	DISTINCT F2.F2_FILIAL, F2.F2_DOC, F2.F2_EMISSAO, F2.F2_SERIE, 
	 	F2.F2_VALBRUT, F2.F2_PBRUTO, F2.F2_CLIENTE, F2.F2_LOJA, F2.F2_TRANSP
		FROM %TABLE:SF2% F2, %TABLE:SD2% D2 
		WHERE F2.F2_FILIAL 	= D2.D2_FILIAL
		AND F2.F2_DOC 		= D2.D2_DOC
		AND F2.F2_SERIE		= D2.D2_SERIE
		AND F2.F2_CLIENTE	= D2.D2_CLIENTE
		AND F2.F2_LOJA 		= D2.D2_LOJA
		AND F2.F2_FILIAL 	= %XFILIAL:SF2%
		AND F2.F2_EMISSAO 	BETWEEN %EXP:DTOS(MV_PAR01)% AND %EXP:DTOS(MV_PAR02)%
		AND F2.F2_DOC     	BETWEEN %EXP:MV_PAR03% AND %EXP:MV_PAR04%
		AND F2.F2_SERIE   	BETWEEN %EXP:MV_PAR05% AND %EXP:MV_PAR06%
		AND F2.F2_TIPO		<> 'B'
		AND	(	%Exp:cEMPFIL%||D2.D2_PEDIDO||D2.D2_COD IN (
				SELECT Z38.Z38_CODEMP||Z38.Z38_CODFIL||Z38.Z38_PEDORI||Z38.Z38_PRODUT
				FROM %TABLE:Z38% Z38
				WHERE Z38.Z38_FILIAL = %XFILIAL:Z38%
				AND   Z38.Z38_CODEMP = %Exp:cCODEMP%
				AND   Z38.Z38_CODFIL = %Exp:cCODFIL%
				AND	  Z38.Z38_PEDORI = D2.D2_PEDIDO
				AND   Z38.Z38_PRODUT = D2.D2_COD
				AND   Z38.Z38_PEDSAI = ' '
				AND   Z38.%NOTDEL%	)
		OR 		%Exp:cEMPFIL%||D2.D2_PEDIDO||D2.D2_COD NOT IN (
				SELECT Z38.Z38_CODEMP||Z38.Z38_CODFIL||Z38.Z38_PEDORI||Z38.Z38_PRODUT
				FROM %TABLE:Z38% Z38
				WHERE Z38.Z38_FILIAL = %XFILIAL:Z38%
				AND   Z38.Z38_CODEMP = %Exp:cCODEMP%
				AND   Z38.Z38_CODFIL = %Exp:cCODFIL%
				AND	  Z38.Z38_PEDORI = D2.D2_PEDIDO
				AND   Z38.Z38_PRODUT = D2.D2_COD
				AND   Z38.Z38_PEDSAI <> ' '
				AND   Z38.%NOTDEL%	)
		)
		AND F2.%NOTDEL%
		AND D2.%NOTDEL%
		ORDER BY F2.F2_FILIAL, F2.F2_DOC, F2.F2_SERIE
	EndSql
	conout(GetLastQuery()[2])
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณMonta um array com os campos para montar o arquivo de trabalhoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aDbf := {}
	Aadd(aDbf, {"F2_OK",      "C", 2                       , 0})
	Aadd(aDbf, {"F2_DOC",     "C", TAMSX3("F2_DOC")    [1] , 0})
	Aadd(aDbf, {"F2_SERIE",   "C", TAMSX3("F2_SERIE")  [1] , 0})
	Aadd(aDbf, {"F2_CLIENTE", "C", TAMSX3("F2_CLIENTE")[1] , 0})
	Aadd(aDbf, {"F2_LOJA",    "C", TAMSX3("F2_LOJA")   [1] , 0})
	Aadd(aDbf, {"F2_EMISSAO", "D", TAMSX3("F2_EMISSAO")[1] , 0})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCria o arquivo de trabalho que serแ mostrado no listณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cArq := CriaTrab(aDbf, .T.)
	Use (cArq) Alias TMPSQL Shared New
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCarrega o arquivo de trabalho com os dados selecionados na consultaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	TMPSF2->(DbGotop())
	cChaveNF := ""
	dbSelectArea("TMPSQL")
	While TMPSF2->(!Eof())
		If (cChaveNF <> TMPSF2->F2_DOC+TMPSF2->F2_SERIE)
			RecLock("TMPSQL", .T.)
			TMPSQL->F2_DOC     := TMPSF2->F2_DOC
			TMPSQL->F2_SERIE   := TMPSF2->F2_SERIE
			TMPSQL->F2_CLIENTE := TMPSF2->F2_CLIENTE
			TMPSQL->F2_LOJA    := TMPSF2->F2_LOJA
			TMPSQL->F2_EMISSAO := SToD(TMPSF2->F2_EMISSAO)
			TMPSQL->(MsUnlock())
			cChaveNF := TMPSF2->F2_DOC+TMPSF2->F2_SERIE
		EndIf
		TMPSF2->(DbSkip())
	EndDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณControla o indice da tabela temporแriaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cArqInd := CriaTrab(NIL, .F.)
	IndRegua("TMPSQL", cArqInd, "F2_DOC+F2_SERIE",,, "Selecionando Registros...")
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณMonta os campos no Browseณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	AAdd(aCpos, {"F2_OK"     , ,""            , "@!"})
	AAdd(aCpos, {"F2_DOC"    , , "Nota Fiscal", PesqPict("SF2", "F2_DOC")})
	AAdd(aCpos, {"F2_SERIE"  , , "S้rie"      , PesqPict("SF2", "F2_SERIE")})
	AAdd(aCpos, {"F2_CLIENTE", , "Cliente"    , PesqPict("SF2", "F2_CLIENTE")})
	AAdd(aCpos, {"F2_LOJA"   , , "Loja"       , PesqPict("SF2", "F2_LOJA")})
	AAdd(aCpos, {"F2_EMISSAO", , "Emissใo"    , PesqPict("SF2", "F2_EMISSAO")})
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณMonta o Dialog com o MsSelectณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	linverte := .F.
	cMarca := GetMark(,"TMPSQL", "F2_OK")
	@ 001,001 TO 400,700 DIALOG oDlg TITLE "Selecione as Notas Fiscais"
	oMark := MsSelect():New("TMPSQL",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,350})
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	@ 180,260 BMPBUTTON TYPE 01 ACTION (lProcessa:=.T.,Close(oDlg))
	@ 180,310 BMPBUTTON TYPE 02 ACTION (lProcessa:=.F.,Close(oDlg))
	ACTIVATE DIALOG oDlg CENTERED
	    
	If lProcessa
	         
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณBusca os documentos que estใo marcadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		aDocs := {}        
		dbSelectArea("TMPSQL")
		TMPSQL->(dbGoTop())
		While TMPSQL->(!Eof())
			If IsMark("F2_OK", ThisMark(), ThisInv())
				aAdd(aDocs, TMPSQL->F2_DOC + TMPSQL->F2_SERIE+ TMPSQL->F2_CLIENTE + TMPSQL->F2_LOJA)			
			EndIf
			TMPSQL->(dbSkip())
		EndDo

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณApaga os arquivos temporแriosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		TMPSQL->(dbCloseArea())
		If File(cArqInd+OrdBagExt())
			Ferase(cArqInd+OrdBagExt())
		EndIf
		If File(cArq+GetDBExtension())                              
			FErase(cArq+GetDBExtension())
		Endif
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณInclusao documento de saida  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		If Len(aDocs) == 0
			MsgInfo("Nenhuma nota selecionada, verifique!")
		Else 
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณAbre janela para serie da nf ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			cSerie := infoSerie()
	
			cArqLog := ""			
			MsAguarde( {|| GNFTRANSF("R", "P00000", aDocs, cSerie, @cArqLog) }, "Processando... Aguarde!")	
			fShowLog(cArqLog)			
		EndIf
	Else
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณApaga os arquivos temporแriosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		TMPSQL->(dbCloseArea())
		If File(cArqInd+OrdBagExt())
			Ferase(cArqInd+OrdBagExt())
		EndIf
		If File(cArq+GetDBExtension())                              
			FErase(cArq+GetDBExtension())
		Endif
	EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณGNFTRANSF บAutor  ณ                     บ Data ณ 29/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que gera as notas de transfer๊ncia referente a uma   บฑฑ
ฑฑบ          ณsaํda em determinada filal.                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GNFTRANSF(cTipoCLi, cVendedor, aNotas, cSerie, cFILOG)
Local lRet        := .T.
Local aCabNF      := {}
Local aIteNF      := {}
Local aOrigem     := {}
Local cNotaFat    := ""
Local cSerFat     := ""
Local cOPERA      := "75" //--opera็ใo de devolu็ใo de armazenagem
Local cNFOri      := ""
Local cSeriOri    := ""
Local cItemOri    := ""
Local cSql        := ""
Local nPosProduto := 0
Local aProdutos   := {}
Local aOrigProd   := {}
Private aPedidos  := {}
Private cArqLog   := "\logarmazenagem\gnftransf_emp"+cEmpAnt+"_fil"+cFilAnt+"_data"+dtos(ddatabase)+"_hora"+STRTran(Time(),":","")+".log" 
Private nHdlLog   := fCreate(cArqLog)
                                                                     
cFILOG := cArqLog

cTEXTO := "Inicio do processamento das notas fiscais."
fwritelog(nHdlLog,cTEXTO)

cTEXTO := "Usuario: "+ALLTRIM(cUserName)+" empresa: "+cEmpAnt+" filial: "+cFilAnt
fwritelog(nHdlLog,cTEXTO)

For nX := 1 to len(aNotas)
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	SD2->(dbGoTop())
	If SD2->(dbSeek(xFilial("SD2") + aNotas[nX]))
		cTEXTO := "Processamento notas fiscal: "+SD2->D2_DOC+"/"+SD2->D2_SERIE
		fwritelog(nHdlLog,cTEXTO)
		While !SD2->(eof()) .and. (SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == xFilial("SD2") + aNotas[nX] )
			dbSelectArea("Z38")
			Z38->(dbSetOrder(01))
			Z38->(dbGoTop())
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			//ณVerifica se o pedido jแ foi incluํdo na tabela de armazenagemณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
			If (Z38->(!dbSeek(xFilial("Z38") + cEmpAnt + cFilAnt + SD2->D2_PEDIDO + SD2->D2_COD))) .or. ((Z38->(dbSeek(xFilial("Z38") + cEmpAnt + cFilAnt + SD2->D2_PEDIDO + SD2->D2_COD))) .and. empty(Z38->Z38_PEDSAI))
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณAlimenta um array com os produtos e as quantidades das notas selecionadasณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				nPosProduto := aScan(aProdutos, {|x| x[1] == SD2->D2_COD})
				If nPosProduto == 0
					aAdd(aProdutos,{SD2->D2_COD, SD2->D2_QUANT})
				Else
					aProdutos[nPosProduto,2] += SD2->D2_QUANT
				EndIf
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				//ณAlimenta um array com os pedidos que estใo sendo processadosณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
				aAdd(aPedidos, {SD2->D2_PEDIDO, SD2->D2_CLIENTE, SD2->D2_LOJA, SD2->D2_COD, SD2->D2_QUANT, SD2->D2_PRCVEN})
				cTEXTO := "Adicionado item "+SD2->D2_ITEM+" para processamento."
				fwritelog(nHdlLog,cTEXTO)
			Else
				cTEXTO := "Item "+SD2->D2_ITEM+" de nota fiscal jแ processado."
				fwritelog(nHdlLog,cTEXTO)
			EndIf
			SD2->(dbSkip())
		Enddo
	Else
		cTEXTO := "Chave nota fiscal nao localizada: "+aNotas[nX]
		fwritelog(nHdlLog,cTEXTO)
	EndIf
Next nX              


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณGera o pedido de venda na empresa Armaz้mณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If Len(aProdutos) > 0
	
	aCabPV 	:= {}
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณseta o cliente como a empresa atualณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	
	cCli := Substr(SM0->M0_CGC, 1, 8)
	cLoja := Substr(SM0->M0_CGC, 9, 4)
	cTEXTO := "Incluindo pedido e nota fiscal de saํda na plataforma." 
	fwritelog(nHdlLog,cTEXTO)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณGera um array com o cabe็alho do pedidoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aCabPv := { {"C5_TIPO"   , "N"          , Nil},; //Tipo de Pedido
			    {"C5_CLIENTE", cCli         , Nil},; // Codigo do cliente
			    {"C5_LOJACLI", cLoja        , Nil},; // Loja do cliente
			    {"C5_TIPOCLI", cTipoCli     , Nil},; // Revenda 				 
			    {"C5_VEND1"  , cVendedor    , Nil},; // Vendedor	
			    {"C5_TABELA" , "   "        , Nil},; // Tabela
			    {"C5_CONDPAG", "001"        , Nil},; // Condicao Pagamento
			    {"C5_X_CLVL" , "005003002"  , Nil}}  // Segmento - Verificar se cria parโmetro.
					 
	aItePV := {}
	nItem := 1
	
	For nI := 1 to len(aProdutos)
		aOrigProd := buscaOrigem(aProdutos[nI,1], cCli, cLoja, aProdutos[nI,2], nHdlLog)
		if !empty(aOrigProd)
			aAdd(aOrigem, aOrigProd)
		endIf
	Next nI
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณGrava os pedidos na tabela de armazenagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	For nI := 1 to len(aPedidos)
		If aPedidos[nI,7] .and. (Z38->(!dbSeek(xFilial("Z38") + cEmpAnt + cFilAnt + SD2->D2_PEDIDO + SD2->D2_COD)))
			BEGIN TRANSACTION
				RecLock("Z38", .T.)	
					Z38->Z38_FILIAL := xFilial("Z38")
					Z38->Z38_CODEMP := cEmpAnt
					Z38->Z38_CODFIL := cFilAnt
					Z38->Z38_PEDORI := aPedidos[nI,1]
					Z38->Z38_CLIENT := aPedidos[nI,2]
					Z38->Z38_LOJACL := aPedidos[nI,3]
					Z38->Z38_PRODUT := aPedidos[nI,4]
					Z38->Z38_QUANT  := aPedidos[nI,5]
					Z38->Z38_PRCVEN := aPedidos[nI,6]
				Z38->(MsUnlock())
			END TRANSACTION    			
			cTEXTO := "Pedido: "+aPedidos[nI,1]+" produto: "+ALLTRIM(aPedidos[nI,4])+" incluido com sucesso na tabela de armazenagem."
			fwritelog(nHdlLog,cTEXTO)
		EndIf
	Next nI
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณGera um array com os ํtens do pedido de venda da Plataforma para retorno de armazenagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	for nI := 1 to len(aOrigem)
		If !len(aOrigem[nI]) == 0
			For nJ := 1 to len(aOrigem[nI])
				If !len(aOrigem[nI,nJ]) == 0
					aLinha := {}
					aadd(aLinha,{"C6_ITEM"   , StrZero(nItem,TamSx3("C6_ITEM")[1]) 			,Nil})
					aadd(aLinha,{"C6_NFORI"  , aOrigem[nI,nJ,3]                    			,Nil})
					aadd(aLinha,{"C6_SERIORI", aOrigem[nI,nJ,4]                    			,Nil})
					aadd(aLinha,{"C6_PRODUTO", aOrigem[nI,nJ,5]                    			,Nil})
					aadd(aLinha,{"C6_ITEMORI", aOrigem[nI,nJ,6]                    			,Nil})
					aadd(aLinha,{"C6_QTDVEN" , aOrigem[nI,nJ,7]                    			,Nil})
					aadd(aLinha,{"C6_PRCVEN" , aOrigem[nI,nJ,8]                    			,Nil})
					aadd(aLinha,{"C6_OPER"   , cOPERA                              			,Nil})
					aadd(aLinha,{"C6_VALOR"  , Round(aOrigem[nI,nJ,7]*aOrigem[nI,nJ,8],2) 	,Nil})
					aadd(aLinha,{"C6_IDENTB6", aOrigem[nI,nJ,9]                    			,Nil})
					//aadd(aLinha,{"C6_QTDLIB" , aOrigem[nI,nJ,7]                  			,Nil})
					//aadd(aLinha,{"C6_LOCAL"  , "PNENAC"                          			,Nil})
					//aadd(aLinha,{"C6_ENTREG", dDataBase  						   			,Nil})
					//aadd(aLinha,{"C6_TES", "785"	   	  						   			,Nil})
					aAdd(aItePV, aLinha)
					nItem++
				endIf
			Next nJ
		EndIf
	Next nI
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefine as variแveis cEmp e cFil para mudar para a empresa armazemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	dbSelectArea("Z47")
	Z47->(dbSetOrder(1))
	Z47->(dbGoTop())
	If (Z47->(dbSeek(xFilial("Z47")+cEmpAnt+cFilAnt)))
		cEmp := Z47->Z47_EMPARM
		cFil := Z47->Z47_FILARM
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณChama a fun็ใo para incluir o pedido de venda na empresa Armazemณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//StartJob("U_PVNFARMAZ", GetEnvServer(), .T., cEmpAnt, cFilAnt, aPedidos, aCabPV, aItePV, cSerie, cEmp, cFil, @cTEXTO, cArqTmp, cArqLog)
		lRet := U_PVNFARMAZ(cEmpAnt, cFilAnt, aPedidos, aCabPV, aItePV, cSerie, cEmp, cFil, nHdlLog)
	Else 
		lRet := .F.
		cTEXTO := "Nใo foram encontradas amarra็๕es entre a empresa ("+cEmpAnt+") filial ("+cFilAnt+") e o seu armaz้m."
		fwritelog(nHdlLog,cTEXTO)
	EndIf	
EndIf

cTEXTO := "Fim do processamento."
fwritelog(nHdlLog,cTEXTO)
fClose(nHdlLog)

			
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณPVNFARMAZ บAutor  ณ                     บ Data ณ 29/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que faz a inclusใo do pedido de venda e ap๓s o fatu- บฑฑ
ฑฑบ          ณramento do mesmo.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function PVNFARMAZ(cEmpOri, cFilOri, aPedidos, aCabPed, aItens, cSerie, cEmp, cFil, nHdlLog) 

Private CLRF := chr(13) + chr(10)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

cTEXTO := "Abrindo novo ambiente - Empresa: "+cEmp+" Filial: "+cFil
fwritelog(nHdlLog,cTEXTO)

RpcClearEnv()
RpcSetType(3)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAltera a empresa logada para a empresa armaz้mณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
RpcSetEnv(cEmp, cFil,,,,GetEnvServer())

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณBusca a pr๓xima n๚mera็ใo do sistema e adiciona no array de cabe็alho do pedidoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
cNumPed := GetSxeNum("SC5","C5_NUM")
aAdd(aCabPed, {"C5_NUM", cNumPed, Nil})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRetorna a n๚mera็ใo, pois ้ preciso passar o n๚mero para o SX8 por้m o mesmo incrementa sozinhoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
ROLLBACKSX8()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama a rotina para gera็ใo do pedido na empresaณ
//ณPlataforma passando por parโmetro um array com oณ
//ณcabe็alho do pedido, um array com os campos do  ณ
//ณpedido e um n๚mero indicando que a opera็ใo que ณ
//ณserแ feita ้ inclusใo                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

MSExecAuto({|x,y,z| Mata410(x,y,z)},aCabPed,aItens,3)
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณVerifica se o pedido foi incluํdoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
dbSelectArea("SC5")
SC5->(dbSetOrder(01))
SC5->(dbGoTop())
lIncluido := SC5->(dbSeek(xFilial("SC5") + cNumPed))
	
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณatualiza o n๚mero do pedido na tabela Z38ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
if (lIncluido)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณConfirma a utiliza็ใo do n๚mero no SX8ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	ConfirmSX8()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณPara cada pedido que estแ sendo processado, verifica se foi atendido e atualiza a tabela de armazenagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	For nI := 1 to len(aPedidos)
		If aPedidos[nI,7]
			BEGIN TRANSACTION
				dbSelectArea("Z38")
				Z38->(dbSetOrder(1))
				Z38->(dbGoTop())
				Z38->(dbSeek(xFilial("Z38")+cEmpOri+cFilOri+aPedidos[nI,1]))
				while (Z38->(!EOF())) .and. (Z38->Z38_FILIAL == xFilial("Z38") .and. Z38->Z38_CODEMP == cEmpOri .and. Z38->Z38_CODFIL == cFilOri .and. Z38->Z38_PEDORI == aPedidos[nI,1])
					RECLOCK("Z38", .F.)
					Z38->Z38_PEDSAI := cNumPed
					Z38->(MSUNLOCK())
					Z38->(dbSkip())
				Enddo
			END TRANSACTION
		EndIF
	Next nI 

	cTEXTO := "Numero do pedido gerado: "+cNumPed
	fwritelog(nHdlLog,cTEXTO)

Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณSe nใo incluiu retorna a n๚mer็ใo no SX8ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	RollBackSX8()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณMostra o erro para o usuแrioณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	cErro := MostraErro("\")
	cTEXTO := "Nใo foi possํvel gerar o pedido. Erro : "+cErro
	fwritelog(nHdlLog,cTEXTO)
	
EndIf

If (lIncluido)
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณGera o faturamento do pedido     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณverificar a s้rie a ser utilizadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
 	lIncluido := FatPedido(cNumPed, cSerie, cEmpOri, cFilOri, aPedidos, nHdlLog)
EndIf 

Return (lIncluido)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณFATPEDIDO บAutor  ณ                     บ Data ณ 30/10/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera o faturamento do pedido.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function FatPedido(cPedido, cSerie, cEmpOri, cFilOri, aPedidos, nHdlLog)
Local lRet := .T.
	                 

cSql := "SELECT C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM, C9.C9_SEQUEN, C9.C9_QTDLIB, C9.C9_PRCVEN, C9.C9_PRODUTO, F4.F4_ISS, C9_QTDLIB2, "
cSql += "B2_LOCAL, C9.R_E_C_N_O_ AS C9_RNO, "
cSql += "  C6.R_E_C_N_O_ AS C6_RNO, "
cSql += "  C5.R_E_C_N_O_ AS C5_RNO, "
cSql += "  F4.R_E_C_N_O_ AS F4_RNO, "
cSql += "  E4.R_E_C_N_O_ AS E4_RNO, "
cSql += "  B1.R_E_C_N_O_ AS B1_RNO, "
cSql += "  B2.R_E_C_N_O_ AS B2_RNO "

cSql += "FROM "+RetSqlName("SC9")+" C9 "
cSql += "LEFT JOIN "+RetSqlName("SC6")+" C6 ON C9.C9_FILIAL = C6.C6_FILIAL AND C9.C9_PEDIDO = C6.C6_NUM AND C9.C9_ITEM = C6.C6_ITEM "
cSql += "LEFT JOIN "+RetSqlName("SC5")+" C5 ON C9.C9_FILIAL = C5.C5_FILIAL AND C9.C9_PEDIDO = C5.C5_NUM "
cSql += "LEFT JOIN "+RetSqlName("SF4")+" F4 ON F4.F4_CODIGO = C6.C6_TES "
cSql += "LEFT JOIN "+RetSqlName("SE4")+" E4 ON E4.E4_CODIGO = C5.C5_CONDPAG "
cSql += "LEFT JOIN "+RetSqlName("SB1")+" B1 ON B1.B1_COD = C9.C9_PRODUTO "
cSql += "LEFT JOIN "+RetSqlName("SB2")+" B2 ON B2.B2_FILIAL = C6.C6_FILIAL AND B2.B2_COD = C6.C6_PRODUTO AND B2.B2_LOCAL = C6.C6_LOCAL "
cSql += "WHERE C6.D_E_L_E_T_ <> '*'  "
cSql += "  AND C9.D_E_L_E_T_ <> '*' "
cSql += "  AND C5.D_E_L_E_T_ <> '*' "
cSql += "  AND F4.D_E_L_E_T_ <> '*' "
cSql += "  AND E4.D_E_L_E_T_ <> '*' "
cSql += "  AND B1.D_E_L_E_T_ <> '*' "
cSql += "  AND B2.D_E_L_E_T_ <> '*' "
cSql += "  AND C9.C9_FILIAL = '"+xFilial("SC9")+"' "
cSql += "  AND C5_NUM = '"+cPedido+"' "
// Removido filtro para permitir faturamento mesmo com bloqueio
//cSql += "  AND C9_BLCRED = '  ' AND C9_BLEST = '  ' "
cSql += "ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_ITEM "

TcQuery cSql NEW ALIAS "TMPPED"
cPed := TMPPED->C9_PEDIDO  
If !TMPPED->(Eof())
	While TMPPED->(!Eof())
	  aPvlNfs := {}
	  dbSelectArea("TMPPED")
	  TMPPED->(dbGoTop())
		While cPed == TMPPED->C9_PEDIDO
			aadd(aPvlNfs,{ 			TMPPED->C9_PEDIDO,;
									TMPPED->C9_ITEM,;
									TMPPED->C9_SEQUEN,;
									TMPPED->C9_QTDLIB,;
									TMPPED->C9_PRCVEN,;
									TMPPED->C9_PRODUTO,;
									TMPPED->F4_ISS=="S",;
									TMPPED->C9_RNO,;
									TMPPED->C5_RNO,;
									TMPPED->C6_RNO,;
									TMPPED->E4_RNO,;
									TMPPED->B1_RNO,;
									TMPPED->B2_RNO,;
									TMPPED->F4_RNO,;
									TMPPED->B2_LOCAL,;
									0,;
									TMPPED->C9_QTDLIB2})
						
			TMPPED->(dbSkip())
		EndDo
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณFun็ใo do Protheus para gerar notas fiscais de saํda a partir de pedidos de venda liberadosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

		Pergunte("MT460A", .F.)	  
		aParam460 := ARRAY(30)
		For nI := 1 To 30
			aParam460[nI] := &("MV_PAR" + STRZERO(nI, 2))
		Next nI
	
		aNotas := {}
		nItemNF	:= A460NUMIT(cSerie)
		AADD(aNotas, {})
		
		For nI := 1 To Len(aPvlNfs)
			If Len(aNotas[Len(aNotas)]) >= nItemNF
				AADD(aNotas, {})
			EndIf
			AADD(aNotas[Len(aNotas)], aClone(aPvlNfs[nI]))
		Next nI
		                        
		
		For nI := 1 To Len(aNotas)
			cNotaSaida := MAPVLNFS(aNotas[nI], cSerie, aParam460[1]==1, aParam460[2]==1, aParam460[3]==1, aParam460[4]==1, aParam460[5]==1, aParam460[7], aParam460[8], aParam460[16]==1, aParam460[16]==2)
			conout("Nota gerada: "+cNotaSaida)
		Next nI
		
	EndDo
Else
	lRet := .F.
	cTEXTO := "Nใo hแ pedido a faturar. Verifique bloqueios no pedido:"+cPedido
	fwritelog(nHdlLog,cTEXTO)	
EndIf
TMPPED->(dbCloseArea())                 
        

If lRet
	dbSelectArea("SD2")
	SD2->(dbSetOrder(08))
	SD2->(dbGoTop())
	If SD2->(dbSeek( xFilial("SD2") + cPedido))
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณAtualiza o n๚mero das notas fiscais na tabela de Armazenagemณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cNumeroNf := SD2->D2_DOC
		cSerieNf  := SD2->D2_SERIE
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณInicia o controle de transa็ใoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		For nI := 1 to len(aPedidos)
			If aPedidos[nI,7]
				BEGIN TRANSACTION
					dbSelectArea("Z38")
					Z38->(dbSetOrder(2))
					Z38->(dbGoTop())
					Z38->(dbSeek(xFilial("Z38")+cEmpOri+cFilOri+cPedido))
					While (Z38->(!EOF())) .and. (Z38->Z38_FILIAL == xFilial("Z38") .and. Z38->Z38_CODEMP == cEmpOri .and. Z38->Z38_CODFIL == cFilOri .and. Z38->Z38_PEDSAI == cPedido)
						RECLOCK("Z38", .F.)
						Z38->Z38_NFSAI  := cNumeroNf
						Z38->Z38_SERSAI := cSerieNf
						Z38->(MSUNLOCK())
						Z38->(dbSkip())
					Enddo
				END TRANSACTION
			EndIf
		Next nI
		
		cTEXTO := "Numero/serie da nota fiscal gerada: "+SD2->D2_DOC+"/"+SD2->D2_SERIE
		fwritelog(nHdlLog,cTEXTO)	

		U_GEWFRETARMA(SD2->D2_DOC, SD2->D2_SERIE, SD2->D2_CLIENTE, SD2->D2_LOJA)
	
	Else
		lRet := .F.
		cTEXTO := "Nใo foi possํvel gerar a NF de saํda."
		fwritelog(nHdlLog,cTEXTO)	
	EndIf
EndIf	

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณbuscaOrigem บAutor  ณRoberto Rosin      บ Data ณ 21/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca a nota fiscal de origem dos produtos que tenha saldo  บฑฑ
ฑฑบ          ณna empresa armazem, ordenando pela nota mais antiga         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function buscaOrigem(cCodProd, cEmpresa, cLoja, nQtde, nHdlLog)
local cOldEmp     := cEmpAnt
local cOldFil     := cFilAnt
local cItem       := ""
local cCrlf       := char(13) + char(10)
Local cAliasSB6   := getNextAlias()
local nQtAtend    := 0
local lAtendido   := .T.
local aOrig       := {}
local CLRF := chr(13) + chr(10)

cTEXTO := "Buscando notas fiscais de origem para o produto: "+cCodProd
fwritelog(nHdlLog,cTEXTO)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefine as variแveis cEmp e cFil para mudar para a empresa armazemณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
dbSelectArea("Z47")
Z47->(dbSetOrder(1))
Z47->(dbGoTop())
If (Z47->(dbSeek(xFilial("Z47")+cEmpAnt+cFilAnt)))
	cEmp := Z47->Z47_EMPARM
	cFil := Z47->Z47_FILARM
Else
	cTEXTO := "Nใo foram encontradas amarra็๕es entre a empresa atual e o seu armaz้m. "
	fwritelog(nHdlLog,cTEXTO)
	Return
EndIf

RpcClearEnv()
RpcSetType(3)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAltera empresa e filial para 34-01ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
RpcSetEnv(cEmp, cFil,,,,GetEnvServer())

cSql := "SELECT B6.B6_FILIAL, B6.B6_CLIFOR, B6.B6_LOJA, B6.B6_PRODUTO, B6.B6_LOCAL, B6.B6_DOC, B6.B6_SERIE, B6.B6_QUANT, B6.B6_SALDO, B6.B6_EMISSAO, B6.B6_IDENT, B6.B6_PRUNIT" + cCrlf
cSql += "FROM "+RetSqlName("SB6")+" B6"             + cCrlf
cSql += "WHERE B6.B6_FILIAL = '"+xFilial("SC9")+"'" + cCrlf
cSql += "AND B6.B6_PRODUTO = '" + cCodProd + "'"    + cCrlf
cSql += "AND B6.B6_CLIFOR =  '" + cEmpresa + "'"    + cCrlf
cSql += "AND B6.B6_LOJA =    '" + cLoja + "'"       + cCrlf
cSql += "AND B6.B6_TIPO = 'D'"                      + cCrlf
cSql += "AND B6_SALDO > 0"                          + cCrlf
cSql += "AND B6.D_E_L_E_T_ <> '*'"                  + cCrlf
cSql += "ORDER BY B6.B6_EMISSAO"                    + cCrlf

TcQuery cSql NEW ALIAS (cAliasSB6)
nQuant := 0
dbSelectArea(cAliasSB6)
if !(cAliasSB6)->(Eof())
	while !(cAliasSB6)->(Eof())
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณVerifica o saldo da nota na tabela de controle de poder de terceirosณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		if (cAliasSB6)->B6_SALDO >= (nQtde - nQtAtend)

			cTEXTO := "Verificando saldo na tabela de poder de terceiros."
			fwritelog(nHdlLog,cTEXTO)
					
			dbSelectArea("SD1")
			SD1->(dbSetOrder(4))
			SD1->(dbGoTop())
			dbSeek(xFilial("SD1")+(cAliasSB6)->B6_IDENT)
			cItem := SD1->D1_ITEM
			
			aAdd(aOrig, {(cAliasSB6)->B6_CLIFOR,;
				          (cAliasSB6)->B6_LOJA,;
				          (cAliasSB6)->B6_DOC,;
				          (cAliasSB6)->B6_SERIE,;
				          (cAliasSB6)->B6_PRODUTO,;
				          cItem,;
				          nQtde - nQtAtend,;
				          (cAliasSB6)->B6_PRUNIT,;
				          (cAliasSB6)->B6_IDENT})
				          
			
			nQtAtend += (nQtde - nQtAtend)
			exit
		else
			
			dbSelectArea("SD1")
			SD1->(dbSetOrder(4))
			SD1->(dbGoTop())
			dbSeek(xFilial("SD1")+(cAliasSB6)->B6_IDENT)
			cItem := SD1->D1_ITEM
			
			aAdd(aOrig, {(cAliasSB6)->B6_CLIFOR,;
				          (cAliasSB6)->B6_LOJA,;
				          (cAliasSB6)->B6_DOC,;
				          (cAliasSB6)->B6_SERIE,;
				          (cAliasSB6)->B6_PRODUTO,;
				          cItem,;
				          (cAliasSB6)->B6_SALDO,;
				          (cAliasSB6)->B6_PRUNIT,;
				          (cAliasSB6)->B6_IDENT})
			
			nQtAtend += (cAliasSB6)->B6_SALDO
		endIf
		
		(cAliasSB6)->(dbSkip())
	endDo
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณSe o saldo total para o produto for menor que a quantidade solicitadaณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	if nQtAtend < nQtde
		nSaldo := nQtAtend
		aOrig := {}
		cTEXTO := "O produto " + ALLTRIM(cCodProd) + " nใo tem saldo suficiente para devolu็ใo. "
		cTEXTO += "Saldo solicitado " + Transform(nQtde, PesqPict("SD2", "D2_QUANT")) + "Saldo Disponํvel " + Transform(nSaldo, PesqPict("SD2", "D2_QUANT"))
		fwritelog(nHdlLog,cTEXTO)
		lAtendido := .F.
	endIf
	
	for nJ := 1 to len(aPedidos)
		if aPedidos[nJ,4] == cCodProd
			aAdd(aPedidos[nJ], lAtendido)
		endIf
	next nJ
else
	lAtendido := .F.
	for nJ := 1 to len(aPedidos)
		if aPedidos[nJ,4] == cCodProd
			aAdd(aPedidos[nJ], lAtendido)
		endIf
	next nJ

	cTEXTO := "Nใo foram encontradas notas de origem com saldo para o produto: " + cCodProd
	fwritelog(nHdlLog,cTEXTO)
endIf


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณretorna a empresa e filial para empresa e filial logadasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
RpcClearEnv()
RpcSetType(3)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAltera empresa e filial para 30-01ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
RpcSetEnv(cOldEmp, cOldFil,,,,GetEnvServer())

return aOrig

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1 บAutor  ณRoberto Rosin       บ Data ณ  31/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de cria็ใo de grupo de perguntas no SX1              บฑฑ
ฑฑบ          ณ(Passada por Marcelo Joner em treinamento)                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณTotvs Paranแ Central                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AJUSTASX1(cPerg)
local i := 0
aRegs  	:= {}  
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}
aHelp4  := {}
aHelp5  := {}
aHelp6  := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
                                                                                                                                                                                                                                                         
aAdd(aRegs, {cPerg,"01","Emissใo De      ","Emissใo De      ","Emissใo De      ", "mv_ch1" ,"D", TAMSX3("F2_EMISSAO")[1]   ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",   "","", PesqPict("SF2", "F2_EMISSAO")})
aAdd(aRegs, {cPerg,"02","Emissใo At้     ","Emissใo At้     ","Emissใo At้     ", "mv_ch2" ,"D", TAMSX3("F2_EMISSAO")[1]   ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"",   "","", PesqPict("SF2", "F2_EMISSAO")})
aAdd(aRegs, {cPerg,"03","Nota De         ","Nota De         ","Nota De         ", "mv_ch3" ,"C", TAMSX3("F2_DOC")    [1]   ,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SF2","",   "","", PesqPict("SF2", "F2_DOC")    })
aAdd(aRegs, {cPerg,"04","Nota At้        ","Nota At้        ","Nota At้        ", "mv_ch4" ,"C", TAMSX3("F2_DOC")    [1]   ,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","SF2","",   "","", PesqPict("SF2", "F2_DOC")    })
aAdd(aRegs, {cPerg,"05","S้rie De        ","S้rie De        ","S้rie De        ", "mv_ch5" ,"C", TAMSX3("F2_SERIE")  [1]   ,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","   ","",   "","", PesqPict("SF2", "F2_SERIE")  })
aAdd(aRegs, {cPerg,"06","S้rie At้       ","S้rie At้       ","S้rie At้       ", "mv_ch6" ,"C", TAMSX3("F2_SERIE")  [1]   ,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","   ","",   "","", PesqPict("SF2", "F2_SERIE")  })

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณMontagem do Help de cada item do Grupo de Perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
AADD(aHelp1 , "Informe a data inicial de emissใo da nota  ") 
AADD(aHelp2 , "Informe a data final da emissใo da nota    ") 
AADD(aHelp3 , "Informe o n๚mero inicial de emissใo da nota")
AADD(aHelp4 , "Informe o n๚mero final de emissใo da nota  ")
AADD(aHelp5 , "Informe a s้rie inicial de emissใo da nota ")
AADD(aHelp6 , "Informe a s้rie final de emissใo da nota   ") 
        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRealiza a grava็ใo dos itens do grupo de perguntas no SX1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
dbSelectArea("SX1")
dbSetOrder(1)                                                    
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RECLOCK("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
		SX1->(MSUNLOCK())
	Endif
Next

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAtualiza o Help dos parametros no arquivo de Help   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PutSX1Help("P." + cPerg + "01.", aHelp1 , aHelp1 , aHelp1 )
PutSX1Help("P." + cPerg + "02.", aHelp2 , aHelp2 , aHelp2 )
PutSX1Help("P." + cPerg + "03.", aHelp3 , aHelp3 , aHelp3 )
PutSX1Help("P." + cPerg + "04.", aHelp4 , aHelp4 , aHelp4 )
PutSX1Help("P." + cPerg + "05.", aHelp5 , aHelp5 , aHelp5 )
PutSX1Help("P." + cPerg + "06.", aHelp6 , aHelp6 , aHelp6 )

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณbuscProdQuantบAutor  ณRoberto Rosin     บ Data ณ 01/12/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera um array com os produtos das notas passadas por parโme-บฑฑ
ฑฑบ          ณtro e a quantidade total desses produtos em todas as notas  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static function buscProdQuant(aNotas)
aMovNotas := {}
aPedidos  := {}
aRet      := {}

for nI := 1 to len(aNotas)
	dbSelectArea("SD2")
	SD2->(dbSetOrder(3))
	SD2->(dbGoTop())
	if SD2->(dbSeek(xFilial("SD2")+aNotas[nI]))
		while !SD2->(eof()) .and. (SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE + SD2->D2_CLIENTE + SD2->D2_LOJA == xFilial("SD2") + aNotas[nI] )
			nPosProduto := aScan(aMovNotas, {|x| x[1] == SD2->D2_COD})
			if nPosProduto == 0
				aAdd(aMovNotas,{SD2->D2_COD, SD2->D2_QUANT})
			else
				aMovNotas[nPosProduto,2] += SD2->D2_QUANT
			endIf
			aAdd(aPedidos, {SD2->D2_DOC, SD2->D2_COD, SD2->D2_CLIENTE, SD2->D2_LOJA, SD2->D2_QUANT, SD2->D2_PRCVEN, SD2->D2_CLVL})
			SD2->(dbSkip())
		endDo
	endIf
	
aAdd(aRet, aMovNotas, aPedidos)
next nI

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDescomentar para teste de conte๚do do array         ณ
//ณMostra uma mensagem com os produtos e as quantidadesณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
/*cMensagem := ""
cCLRF := chr(13) + chr(10)
for nI := 1 to len(aMovNotas)
	cMensagem += "Produto: " + aMovNotas[nI,1] + " - Quantidade: " + transform(aMovNotas[nI,2], pesqPict("SD2","D2_QUANT")) + cCLRF
next nI
Aviso("Processo Armazenagem",cMensagem,{"OK"},3)*/

return aRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณINFOSERIE บAutor  ณRoberto Rosin        บ Data ณ 20/11/2012 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra uma tela para o usuแrio informar a s้rie da nota fis-บฑฑ
ฑฑบ          ณcal de saํda para armazenagem que serแ utilizada            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
static Function infoSerie()                                      
Static oDlgSerie
local oButton1
local oSay1
local oSerie
local cSerie := space(3)

  DEFINE MSDIALOG oDlgSerie TITLE "Serie Nota Armazenagem" FROM 000, 000  TO 080, 180 COLORS 0, 16777215 PIXEL
    @ 004, 004 SAY oSay1 PROMPT "Serie" SIZE 015, 007 OF oDlgSerie COLORS 0, 16777215 PIXEL
    @ 003, 020 MSGET oSerie VAR cSerie SIZE 060, 010 OF oDlgSerie COLORS 0, 16777215 PIXEL
    @ 018, 055 BUTTON oButton1 PROMPT "Ok" SIZE 025, 012 ACTION {||oDlgSerie:End()} OF oDlgSerie PIXEL
  ACTIVATE MSDIALOG oDlgSerie CENTERED

Return cSerie


static function ENVWFERRO(cErro)

Local aArea	:= GetArea()
Local nTotNf	:= 0
Local cStatus	:= SPACE(6)
Local cEmails	:= ALLTRIM(GETMV("HAHAHA",,"roberto.rosin@grupocantu.com.br"))
Local cLocal	:= ALLTRIM(GETMV("MV_WFDIR",,"\WORKFLOW"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณCaso existam e-mails, encaminha workflow aos mesmosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
If !EMPTY(cEmails)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDeclara objeto de envio do workflow aos e-mailsณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oProcess := TWFProcess():New("HAHAHAHA", " Erro: Documento de retorno de Armazenagem" + cDoc)
	oProcess:NewTask(cStatus, cLocal + "\wf_erarma.htm")
	oProcess:cSubject := ("Erro: Documento de retorno de Armazenagem " + cDoc)
	oProcess:cTo := cEmails	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณCarrega variaveis do arquivo de modelo do workflow ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oHTML:= oProcess:oHTML		
	oHtml:ValByName("Erro"      , cErro)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณEfetua o envio do workflow ap๓s a sua montagemณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	oProcess:Start()
EndIf

RestArea(aArea)

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณGRAVALOG บAutor  ณRoberto Rosin     บ Data ณ 04/01/2013     บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para gravar log das transa็๕es feitas e dos erros  บฑฑ
ฑฑบ          ณque ocorrer na execu็ใo da rotina de devolu็ใo de armazenageบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function GRAVALOG(cTexto, cArquivo, lTemporario)
local cBuffer := cTexto
local cConteudo := ''
local nHOrigem, nHDestino
local nBytesLidos, nBytesFalta, nTamArquivo
local lCopiaOk := .T.

default lTemporario := .T.

if lTemporario
	//Cria o arquivo de destino
	nHDestino := FCreate(cArquivo, FC_NORMAL)
	FWRITE(nHDestino, cBuffer)
else
	nHDestino := nHOrigem := FOPEN(cArquivo, FO_READWRITE)
	//testa a abertura do arquivo
	if nHOrigem == -1
		nHDestino := FCreate(cArquivo, FC_NORMAL)
		FWRITE(nHDestino, cBuffer)
	else
		//tamanho do arquivo
		nTamArqui := fSeek(nHOrigem,0,2)
		
		//Move o ponteiro do arquivo de origem para o inicio do arquivo
		fSeek(nHOrigem,0)
		
		//L๊ os dados do arquivo
		nBytesLidos := FRead(nHOrigem, cConteudo, nTamArqui)
		
		cBuffer := cConteudo + cTexto
		FWRITE(nHDestino, cBuffer)
	endIf
endIf


//Fecha os arquivos de origem e destino
FCLOSE(nHDestino)
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณ ABRELOG  บAutor  ณ Roberto Rosin       บ Data ณ 11/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณL๊ os arquivos temporแrios de log gerados pelo processo     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------*
User Function ABRELOG(aLogs)   
*-------------------------------*

Local cRetorno := ""
Local nX       := 1  
Local cEol     := CHR(13)+CHR(10)

if Len(aLogs) > 0
	for nX := 1 to len(aLogs)
		cRetorno += aLogs[nX] + cEol
	Next nX
EndIf                   

/*
local cBuffer := space(1)
local nHOrigem, nHDestino
local nBytesLidos, nBytesFalta, nTamArquivo
local lCopiaOk := .T.


//abre o arquivo
nHOrigem := FOPEN(cArqLog, FO_READ)

//testa a abertura do arquivo
if nHOrigem == -1
	return
endIf

//tamanho do arquivo
nTamArqui := fSeek(nHOrigem,0,2)

//Move o ponteiro do arquivo de origem para o inicio do arquivo
fSeek(nHOrigem,0)

//L๊ os dados do arquivo
nBytesLidos := FRead(nHOrigem, cBuffer, nTamArqui)

cRetorno := cBuffer

fClose(nHOrigem)
*/

Return cRetorno
    


Static Function fwritelog(nHdlLog,cTEXTO)

	cTEXTO := DTOC(ddatabase) + "-" + TIME() + "-" + cTEXTO + CHR(10) + CHR(13)
	fWrite(nHdlLog,cTEXTO,Len(cTEXTO))
	conout(cTEXTO)
	
Return

       

Static Function fShowLog(cArqLog)

Private cTxtLog := ""
Private oDlgLog, oMemo

	nHldLog := fOpen(cArqLog,68)
	nTamLog := fSeek(nHldLog,0,2)
	If nTamLog >= 1048576	//--Limite maximo 1MB (String size overflow!)
		nTamLog := 1048575
		Aviso("Aviso","Arquivo com mais de 1MB, nใo serแ exibido todo seu conte๚do, caso necessแrio solicite o arquivo para consulta ao departamento de TI, arquivo:"+cArqLog,{"OK"},3)
	EndIf
	fSeek(nHldLog,0,0)
	fRead(nHldLog,@cTxtLog,nTamLog)
	fClose(nHldLog)
	
	DEFINE MSDIALOG oDlgLog TITLE "Log de processo" FROM 00,00 TO 500,700 PIXEL
	TSay():New(005,005,{|| "Arquivo: "+cArqLog },oDlgLog,,,,,,.T.,,,340,200,,,,.T.,,.T.)	
	@ 020,015 GET oMemo VAR cTxtLog MEMO SIZE 320,200 OF oDlgLog PIXEL READONLY
	TButton():New( 230,270, '&Ok',oDlgLog,{||oDlgLog:End()},060,015,,,,.T.,,,,,,)
	
	ACTIVATE MSDIALOG oDlgLog CENTERED
	
Return
