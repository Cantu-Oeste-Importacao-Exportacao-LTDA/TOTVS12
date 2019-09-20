#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function ImpPedGM()
Local cFile
Local cStr
Local aCpos := {}                                                                                 
Local cEol := CHR(13)+CHR(10)
Local cCliNCad := ""
Local aTmp := {}     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cFile := cGetFile( "arquivos de pedido GM | *.*" , "Selecione o arquivo enviado pela GM", 0,"",.T.)
if !File(cFile)
	Alert("Caminho espeficicado não é válido.")
	Return nil
EndIf       

DbSelectArea("ZZW")
ZZW->(dbSetOrder(2))

if !Empty(cFile)
	nHdl := FT_FUSE(cFile)           		
	nCount := 0
	nImp := 0
	// Le o Header
	cStr := Ft_Freadln()
	cPacote := SubStr(cStr, 7, 50)
	FT_FSKIP()
	// Vai para as linhas
	cStr := Ft_Freadln()
		
	lFound := ZZW->(dbSeek(xFilial("ZZW") + cPacote))
	
	cItem := "001"
	
	While !FT_FEOF() .And. SubStr(cStr, 1, 8) != "TRAILLER" .And. !lFound
		nCount ++
		cStr := Ft_Freadln()  	
//  	aCpos := SeparaCpos(cStr, ";")
	  if SubStr(cStr, 1, 8) != "TRAILLER"
		  RecLock("ZZW", .T.)
	  	ZZW->ZZW_PACOTE := cPacote
	  	ZZW->ZZW_PECA := SubStr(cStr, 1, 8)
	  	ZZW->ZZW_CLIGM := SubStr(cStr, 9, 6)
	  	ZZW->ZZW_PEDCLI := SubStr(cStr, 44, 9) 
	  	ZZW->ZZW_QTDE := Val(SubStr(cStr, 21, 5))
	  	ZZW->ZZW_DTPED := SubStr(cStr, 30, 4) + SubStr(cStr, 28, 2) + SubStr(cStr, 26, 2)
	  	ZZW->ZZW_FORNEC := SubStr(cStr, 34, 9)
	  	ZZW->ZZW_TIPO := SubStr(cStr, 43, 1)
	  	ZZW->ZZW_NPEDGM := SubStr(cStr, 15, 6) //SubStr(cStr, 44, 9)
	  	ZZW->ZZW_HORA := SubStr(cStr, 53, 6)
	  	ZZW->ZZW_LINHAP := SubStr(cStr, 59, 5)
	  	ZZW->ZZW_STATUS := "1" // Importado
	  	ZZW->ZZW_ITEM := cItem
  		cItem := Soma1(cItem)
  	  
  	  aTmp := GetCliGM(ZZW->ZZW_CLIGM)
  	  if Empty(aTmp[1])
  	  	if Empty(cCliNCad)
  	  		cCliNCad := "As concessionárias abaixo precisam estar vinculadas a um cadastro de cliente: "+cEol
  	  		cCliNCad += ZZW->ZZW_CLIGM + cEol
  	  	else                        
  	  		cCliNCad += ZZW->ZZW_CLIGM + cEol
  	  	EndIf 
  	  EndIf
  	
  		ZZW->(MsUnlock())
  	EndIf
  	FT_FSKIP()
	EndDo
	
	FT_FUSE()
	fClose(nHdl)
EndIf
	if !Empty(cCliNCad)
		Aviso("CONCESSIONÁRIAS NÃO CADASTRADAS",cCliNCad,{"OK"},2)
	EndIf
	MsgInfo("Arquivo '"+cFile+"' importado.")
Return

/****************************************************************
 Geração dos pedidos de Venda para a GM, alimentando também a 
 quantidade que vai ser entregue (estoque)
 ***************************************************************/
User Function GeraPedGM()
Local oDlg
Local lRet		:= .T.
Local _aArea	:= GetArea()

Local aAlterFields 		:= {"QTDEPROD", "UNITPROD", "TOTPROD"}
Local _cCliente := Space(Len(SA1->A1_COD))
Local _cLojaCli := Space(Len(SA1->A1_LOJA))
Local _cTipoCli := Space(Len(SA1->A1_TIPO))
Local _cCondPg := Space(Len(SE4->E4_CODIGO))
Local _cVend := Space(Len(SA3->A3_COD))
Local _cSegm := Space(Len(CTH->CTH_CLVL))
Local _cCond := Space(Len(SE4->E4_CODIGO))
Local _cTran := Space(Len(SA4->A4_COD))
Local oGDCpos
Local _cTpCli			:= Space(01)
Local _cCondPg			:= Space(03)
Local _cTabPrc			:= Space(03)
Local _cOper := Space(2)
Local _cDescOper := Space(20)
Local oPnl1
Local oPnl2
Local oDlg1
Local oGetTb
Local _cPacote := Space(50)
Local _cTabPrc := Space(3)
Local aPedsGM := {} 
Local aTipo := {"F=Cons.Final","L=Produtor Rural","R=Revendedor","S=Solidario","X=Exportacao"}
Local cCliPadGM := PadL(Trim(SuperGetMv("MV_X_CLIGM",,"59275792 0001")), 13)
Local cCliPad := SubStr(cCliPadGM, 1, 9)
Local cLojaPad := SubStr(cCliPadGM, 10, 4)
Local nX := 0
Local cMensagem := ""
Local cEst := ""
Local cValTemp := Space(22)
Local cOrdem := ""
Local cRazao := ""

Private aColsEx := {}
Private aHeaderEx := {}
Private lCont := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Seta o código da tabela como default "006"
_cTabPrc := "006"

// Fazer validação para os campos abaixo, se o pacote existe e se existe a tabela de preço
DEFINE MSDIALOG oDlg1 TITLE "Informe o código do Pacote" From 1,1 To 150,400 OF oMainWnd PIXEL
@ 020,005 Say "Pacote:" SIZE 025, 007  OF oPnl1 COLORS 0, 16777215 PIXEL
@ 020,050 MSGET _cPacote F3 "ZZW"  SIZE 100,005 valid (!empty(_cPacote) .and.; 
																												existCpo("ZZW",_cPacote,2) .and.; 
																												validaPacote(_cPacote)) OF oPnl1 COLORS 0, 16777215 PIXEL 

@ 035,005 Say "Tabela de Preço" OF oDlg1 COLORS 0, 16777215 PIXEL
@ 035,050 MsGet oGetTb Var _cTabPrc PICTURE "@!" 	Size  040,005 F3 "DA0" valid (empty(_cTabPrc) .or. existCpo("DA0",_cTabPrc)) OF oDlg1 COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;      
EnchoiceBar(oDlg1,{|| lCont := .T., oDlg1:End()}, {|| lCont := .F., oDlg1:End()}, ,{})

// se não clicou em ok, cancela a execução
if !lCont
	Return
EndIf

// Monta as colunas do grid de produtos, para preencher quantidade a entregar, valor unitário e total

Aadd(aHeaderEx, {"Produto","CODPROD","@!",12,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Desc. Produto","DESORIG","@!",40,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Unid","UNIDORIG","@!",2,0,"AllwaysTrue()","","C","", "V"})
Aadd(aHeaderEx, {"Quantidade","QTDEPROD","@E 999,999.99",14,2,"u_MultQtd1()","","N","", "V"})
Aadd(aHeaderEx, {"Unitario","UNITPROD","@E 9,999,999.99999",14,5,"u_MultQtd2()","","N","", "V"})
Aadd(aHeaderEx, {"Total","TOTPROD","@E 9,999,999.99",14,2,"AllwaysTrue()","","N","", "V"})  
Aadd(aHeaderEx, {"Qtde Solicitada","QTDESOLIC","@E 999,999.99",14,2,"AllwaysTrue()","","N","", "V"})  
Aadd(aHeaderEx, {"Cod. Prod. GM","CODPRODGM","@!",14,2,"AllwaysTrue()","","N","", "V"})
Aadd(aHeaderEx, {"Pedido Cliente GM","PEDCONGM","@!",14,2,"AllwaysTrue()","","N","", "V"})


// Parametriza quais indices de pesquisa para as tabelas
// Produto X Cliente
SA7->(DbSetOrder(3))

// Tabela de integração GM
ZZW->(DbSetOrder(3)) // Pacote + Cliente

// Itens da tabela de preço
DA1->(dbSetOrder(1))
                           
// faz a execução se o pacote existir
If ZZW->(DbSeek(xFilial("ZZW") + Trim(_cPacote)))
  
	// Faz um loop para todos os itens do pacote
	While !ZZW->(Eof()) .AND. xFilial("ZZW")+_cPacote == ZZW->ZZW_FILIAL + ZZW->ZZW_PACOTE // valido para processar o pacote inteiro
			
		// busca o cliente para localizar o produto
		_cCliGM := ZZW->ZZW_CLIGM
		//aCli := GetCliGM(_cCliGM)
		
		// Loop por cliente do pacote
		While !ZZW->(Eof()) .AND. xFilial("ZZW")+_cPacote+_cCliGM == ZZW->ZZW_FILIAL + ZZW->ZZW_PACOTE + ZZW->ZZW_CLIGM // enquanto for o mesmo cliente de entrega
		  
			// Valida se o pedido está sem prenchimento
			if Empty(ZZW->ZZW_NUMPED)
				
				// Localizo o produto (codigo da peça) retornado pela gm, buscando qual o código de produto vinculado no sistema
				
				// Se não localizar, emitir alerta e não processar
				
				SA7->(dbSeek(xFilial("SA7") + cCliPad + cLojaPad + ZZW->ZZW_PECA))
				
				// Localiza o produto
				SB1->(DbSetorder(1)) //ordem: B1_COD
				SB1->(DbSeek(xFilial("SB1")+SA7->A7_PRODUTO))
				
				// Localiza o preço do produto conforme tabela de preço criada
				// para buscar o preço do produto e alimentar no grid
				DA1->(dbSeek(xFilial("DA1")+ _cTabPrc + SA7->A7_PRODUTO))
				
				// Adiciona o item na lista
				aAdd(aColsEx, {SB1->B1_COD,;
									SB1->B1_DESC,;
									SB1->B1_UM,;
								  ZZW->ZZW_QTDE,;							
									DA1->DA1_PRCVEN,;
						      DA1->DA1_PRCVEN * ZZW->ZZW_QTDE,; 
						      ZZW->ZZW_QTDE,;
									ZZW->ZZW_PECA,;
									ZZW->ZZW_PEDCLI,;
									.F.}) 
         
			EndIf
			
			ZZW->(DbSkip())
		End
		
		if !Empty(aColsEx)
			Aadd(aPedsGM, {aColsEx, _cCliGM})
			_cCliGM := ZZW->ZZW_CLIGM
		EndIf		
		
		aColsEx := {}
	End
Else
	MsgInfo("Pacote não encontrado.")
	Return
Endif

// Faz loop para gerar pedido para cada cliente de entrega diferente
For nX := 1 to len(aPedsGM)

	aColsEx := aPedsGM[nX, 1]
	
	_cCliGM := aPedsGM[nX, 2]
	
	aCli := GetCliGM(_cCliGM)

	
	_cCliente := aCli[1]
	_cLojaCli := aCli[2]
	_cNomeCli := Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_NOME")
	_cTipoCli := Posicione("SA1", 01, xFilial("SA1") + aCli[1] + aCli[2], "A1_TIPO")
	
	_cOper := "01"
	
	lCont := .F.   

	if empty(_cCliente)
		Alert("O Cliente não foi encontrado.")
		Return nil
	EndIf    
	
	// Seta algumas informações como default para os pedidos da GM
	_cCondPg  := "133"
	_cVend    := "P00206"
	_cSegm    := "005001023"
	_cTran    := "000056"
		
	// Monta a tela do pedido
	DEFINE MSDIALOG oDlg TITLE "Gerar Pedido de Venda - " + Trim(_cNomeCli) FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
	            
	@ 000,000 MSPANEL oPnl1 SIZE 250, 050 OF oDlg COLORS 0, 16777215 RAISED
	@ 005,005 Say "Cliente:" SIZE 025, 007  OF oPnl1 COLORS 0, 16777215 PIXEL 
	@ 005,030 MSGET _cCliente SIZE 040,005 OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SA1" When .F.
	@ 005,075 Say "Loja:" SIZE 025, 007 OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 005,090 MSGET _cLojaCli SIZE 010,005 Valid !Empty(_cLojaCli)  OF oPnl1 COLORS 0, 16777215 PIXEL When .F.
	@ 005,110 MSGET _cNomeCli SIZE 120,005 OF oPnl1 COLORS 0, 16777215 PIXEL When .F. 
	
	@ 020,005  Say "Operação:" OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 020,030 MSGET _cOper SIZE 020,005 Valid EXISTCPO("SX5",_cOper) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "DJ"  
	 
	@ 020,055  Say "Tipo Cliente:" OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 032, 085 MSCOMBOBOX oComboBo1 VAR _cTipoCli ITEMS aTipo SIZE 120,010 OF oDlg COLORS 0, 16777215 PIXEL

	@ 020,215  Say "Cond. Pagto:" OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 020,230 MSGET _cCondPg SIZE 020,005 Valid EXISTCPO("SE4",_cCondPg) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SE4" 
		                                          
	@ 035,005  Say "Vendedor:" OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 035,030 MSGET _cVend SIZE 040,005 Valid EXISTCPO("SA3",_cVend) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SA3"
	
	@ 035,075  Say "Segmento:" OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 035,100 MSGET _cSegm SIZE 040,005 Valid EXISTCPO("CTH",_cSegm) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "CTH" 
	
	@ 035,145  Say "Transp:"   OF oPnl1 COLORS 0, 16777215 PIXEL
	@ 035,170 MSGET _cTran SIZE 040,005 Valid EXISTCPO("SA4",_cTran) OF oPnl1 COLORS 0, 16777215 PIXEL F3 "SA4"
	    
	@ 040, 000 MSPANEL oPnl2 SIZE 250, 196 OF oDlg COLORS 0, 16777215 RAISED
			
	oGDCpos := MsNewGetDados():New( 000, 000, 232, 250, 3, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,GD_UPDATE, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oPnl2, aHeaderEx, aColsEx)
	    		
	oPnl1:Align := CONTROL_ALIGN_TOP
	oPnl2:Align := CONTROL_ALIGN_ALLCLIENT
	oGDCpos:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
	                                
	ACTIVATE MSDIALOG oDlg CENTER ON INIT ;      
	EnchoiceBar(oDlg,{|| lCont := .T., oDlg:End() }, {|| lCont := .F., oDlg:End() }, ,{})
	        
	// Valida se foi dado ok
	if !lCont
		Loop
	EndIf
	
	aColsEx := oGDCpos:aCols
	
	// Valida UF de destino
	cEst   := Posicione("SA1", 1, xFilial("SA1") + _cCliente + _cLojaCli, "A1_EST")
	cOrdem := Posicione("ZZW", 4, xFilial("ZZW") + _cPacote + aColsEx[1, 9] + aColsEx[1, 8], "ZZW_NPEDGM")
	cRazao := Posicione("SA1", 1, xFilial("SA1") + _cCliente + _cLojaCli, "A1_NOME")
	                                       
	if cEst == "SP"
		cValTemp := "DENTRO DO ESTADO DE SP"	
	Else
		cValTemp := "FORA DO ESTADO DE SP"
	EndIf
	
	cMensagem := "CLI ENT "+PadR(cRazao, 30)+" ORDEM GM "+cOrdem+" PED SAP "+aColsEx[1, 9] + " PEÇA " + aColsEx[1,8] + " " + cValTemp

	aCabPV 	:= {}
	
	aCabPV:={{"C5_TIPO",    "N"           ,Nil},; // Tipo de pedido
					 {"C5_CLIENTE", cCliPad   	  ,Nil},; // Codigo do cliente padrao GM
					 {"C5_LOJACLI", cLojaPad      ,Nil},; // Loja do cliente padrao GM  
					 {"C5_MENNOTA", cMensagem     ,Nil},; // Concessionária de entrega e Num. Ped. do Cliente
					 {"C5_TIPOCLI", _cTipoCli     ,Nil},; // Loja do cliente destino mercadoria
	 				 {"C5_CONDPAG", _cCondPg		  ,Nil},;
	 				 {"C5_TRANSP",  _cTran        ,Nil},; 
					 {"C5_TABELA",  _cTabPrc		  ,Nil},;
					 {"C5_VEND1",   _cVend			  ,Nil},;
					 {"C5_PEDCLI",  aColsEx[1, 9] ,Nil},; // Pedido do cliente
					 {"C5_X_CLVL",  _cSegm	    	,Nil}}
			
	aItens 		:= {}
	nItem 		:= 0   

	For nIt := 1 To Len(aColsEx)
    
		nItem++
		aLinha := {}
	
		_aTmp := TamSX3("C6_VALOR")
	
		aadd(aLinha,{"C6_ITEM"		,StrZero(nItem,TamSx3("C6_ITEM")[1]),Nil})
		aadd(aLinha,{"C6_PRODUTO"	,aColsEx[nIt,1]						,Nil})
		aadd(aLinha,{"C6_QTDVEN"	,aColsEx[nIt,4]   				,Nil})      //	aadd(aLinha,{"C6_QTDVEN"	,aColsEx[nIt,4]						,Nil})
		aadd(aLinha,{"C6_PRCVEN"	,aColsEx[nIt,5]						,Nil})
  	aadd(aLinha,{"C6_VALOR"		,aColsEx[nIt,6]						,Nil})
		aadd(aLinha,{"C6_ENTREG"	,dDataBase  							,Nil})
		aadd(aLinha,{"C6_OPER"	  ,_cOper   	  						,Nil}) 
//		aadd(aLinha,{"AUTDELETA"	,"N"    		  					,Nil})
			
		AAdd(aItens,aLinha)               
		
			
	
	NEXT nIt
	
	If !Empty(aItens)
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
	 
//	 	nMod := nModulo
//	 	nModulo := 5
	
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPV,aItens,3 )
		  
	  // Caso deu erro, cancela
		If lMsErroAuto
			RollBackSX8()
			MostraErro()
			DisarmTransaction()
	//			Break
		Else // Confirma a gravação
			ConfirmSX8()
	   	aRotina 	:= {{ OemToAnsi("Pesquisar")	,"AxPesqui" 	, 0 , 1},;
							{ OemToAnsi("Visualizar")	,"A410Visual" 	, 0 , 2}}
							
			// Atualiza a informação do pedido no ZZW
			GrvPedZZW(_cPacote, _cCliGM, SC5->C5_NUM)
			
			If MSGBOX("Visualizar Pedido "+SC5->C5_NUM+"?","IMPORTAÇÃO DE PEDIDOS","YESNO")
				A410Visual("SC5",SC5->(RecNo()),1)
			Endif
			
		Endif
	Endif
Next Nx

RestArea(_aArea)
Return (lRet)

Static Function GrvPedZZW(cPacote, cCliGM, cPedido)

DbSelectArea("ZZW")
ZZW->(dbSetOrder(03))
ZZW->(dbSeek(xFilial("ZZW") + cPacote + cCliGM))
While ZZW->ZZW_FILIAL+ZZW->ZZW_PACOTE+ZZW->ZZW_CLIGM == xFilial("ZZW")+cPacote+cCliGM
  
	RecLock("ZZW", .F.)
	ZZW->ZZW_NUMPED := cPedido
	ZZW->ZZW_CODEMP := cEmpAnt
	ZZW->ZZW_CODFIL := cFilAnt
	
	ZZW->(MsUnlock())
	
	ZZW->(dbSkip())	
EndDo
	

Return

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0 
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ" 
Local cTio   := "ãõ"
Local cCecid := "çÇ"

if Empty(cString)
	Return cString
EndIf

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf		
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("ao",nY,1))
		EndIf		
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next
For nX:=1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	If Asc(cChar) < 32 .Or. Asc(cChar) > 123
		cString:=StrTran(cString,cChar,".")
	Endif
	If cChar $ '&'
		cString:=StrTran(cString,cChar,"E")
	Endif
Next nX
cString := Upper(cString)
Return cString

Static Function SeparaCpos(cStr, cSep)
Local nPos
Local cParte := ""
Local cCarac := ""
Local cCaracOld := ""
Local aCpos := {}
For nPos := 1 to Len(cStr)
	cCarac := substr(cStr, nPos, 1)
	if cCarac == cSep 
		aAdd(aCpos, cParte)
		cParte := ""
	elseif nPos == Len(cStr)
		cParte := cParte + cCarac
		aAdd(aCpos, cParte)
	elseif cCarac == cCaracOld .and. cCarac == cSep
		aAdd(aCpos, "")
	else	
		cParte := cParte + cCarac
	End
	cCaracOld := cCarac
Next nPos
Return aCpos

Static function GetCliGM(cCliGM)
Local aCli := {}
Local cSql := "select a1_cod, a1_loja from " + RetSqlName("SA1") + " where A1_X_CLIGM = '" + cCliGM + "' and d_e_l_e_t_ <> '*' "
TcQuery cSql New Alias "CLIGM"
aAdd(aCli, CLIGM->A1_COD)
aAdd(aCli, CLIGM->A1_LOJA)
CLIGM->(dbCloseArea())
Return aCli

//Multiplica e atualiza o Grid
User function MultQtd1()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aCols[N,6]:= M->QTDEPROD*aCols[n,5]
return .T.    
 
//Multiplica e atualiza o Grid
User function MultQtd2()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

aCols[N,6]:= aCols[n,4]*M->UNITPROD
return .T.     

Static Function validaPacote(_cPacote)
Local lRet := .T.
Local cQuery := ""
Local aCliente := {}
Local cEol := CHR(13)+CHR(10)
Local cErros := ""
Local cCliGm := ""

cQuery := "SELECT * FROM "+retSqlName("ZZW")+ " "
cQuery += "WHERE ZZW_PACOTE = '" + _cPacote + "' "
cQuery += "  AND ZZWCMP.D_E_L_E_T_ <> '*' "
                                                
TCQuery cQuery New Alias "ZZWTEMP"

DbSelectArea("ZZWTEMP")
ZZWTEMP->(DbGoTop())

while !ZZWTEMP->(EOF())
	aCliente := GetCliGM(ZZWTEMP->ZZW_CLIGM)
	if Empty(aCliente[1])
		lRet := .F.
		cErros += "Código GM "+AllTrim(ZZWTEMP->ZZW_CLIGM)+" não está vinculado a um cadastro de cliente."+cEol
	EndIf                                                                                                    
	
	cCliGm := PadL(Trim(SuperGetMv("MV_X_CLIGM",,"59275792 0001")), 13) 
	cCodProdCli := Posicione("SA7", 3, xFilial("SA3") + cCliGm + ZZWTEMP->ZZW_PECA, "A7_PRODUTO")
	
	if Empty(cCodProdCli)
		lRet := .F.
		cErros += "Produto da Gm "+AllTrim(ZZWTEMP->ZZW_PECA)+" não está vinculado a um produto da Cantu para o cliente "+cCliGm+"."+cEol
	EndIf
		                
	ZZWTEMP->(DbSkip())
End                     

if !lRet
	Aviso("INCONSISTÊNCIAS NO PACOTE "+AllTrim(_cPacote),cErros,{"OK"},3)
EndIf

ZZWTEMP->(DbCloseArea())

Return lRet


/****************************************************************
 Geração dos pedidos de Venda para a GM, alimentando também a 
 quantidade que vai ser entregue (estoque)
 ***************************************************************/
User Function GeraRemGM()
Local oDlg
Local lRet		:= .T.
Local _aArea	:= GetArea()
Local _cCliente := Space(Len(SA1->A1_COD))
Local _cLojaCli := Space(Len(SA1->A1_LOJA))
Local _cTipoCli := Space(Len(SA1->A1_TIPO))
Local _cCondPg := Space(Len(SE4->E4_CODIGO))
Local _cVend := Space(Len(SA3->A3_COD))
Local _cSegm := Space(Len(CTH->CTH_CLVL))
Local _cCond := Space(Len(SE4->E4_CODIGO))
Local _cTabPrc			:= Space(03)
Local oPnl1
Local oPnl2
Local oDlg1
Local oGetTb
Local _cPacote := Space(50)
Local _cTabPrc := Space(3)
Local aPedsGM := {} 
Local cCliPadGM := PadL(Trim(SuperGetMv("MV_X_CLIGM",,"59275792 0001")), 13)
Local nX := 0
Local aPed := {}
Local _aCli := {}
Local _cCodCliGm := ""
Local _cNfGm := ""
Local _cSerNfGm := ""

Private lCont := .F.
// Faz a seleção de um pacote de integração para processar o mesmo.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Fazer validação para os campos abaixo, se o pacote existe e se existe a tabela de preço
DEFINE MSDIALOG oDlg1 TITLE "Informe o código do Pacote para gerar as remessas" From 1,1 To 150,400 OF oMainWnd PIXEL
@ 020,005 Say "Pacote:" SIZE 025, 007  OF oPnl1 COLORS 0, 16777215 PIXEL
@ 020,050 MSGET _cPacote F3 "ZZWREM"  SIZE 100,005 valid (!empty(_cPacote) .and.; 
																												existCpo("ZZW",_cPacote,2)) OF oPnl1 COLORS 0, 16777215 PIXEL 

@ 035,005 Say "Tabela de Preço" OF oDlg1 COLORS 0, 16777215 PIXEL
@ 035,050 MsGet oGetTb Var _cTabPrc PICTURE "@!" 	Size  040,005 F3 "DA0" valid (empty(_cTabPrc) .or. existCpo("DA0",_cTabPrc)) OF oDlg1 COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg1 CENTER ON INIT ;      
EnchoiceBar(oDlg1,{|| lCont := .T., oDlg1:End()}, {|| lCont := .F., oDlg1:End()}, ,{})

// se não clicou em ok, cancela a execução
if !lCont
	Return
EndIf

// busca os pedidos já gerados
aPed := GetPedOk(_cPacote)
SC5->(dbSetOrder(01))


For nX := 1 to Len(aPed)
	         
	SC5->(dbSeek(xFilial("SC5") + aPed[nX, 1]))
	
	_cCodCliGm := Posicione("ZZW", 4, xFilial("ZZW") + _cPacote + aPed[Nx, 4], "ZZW_CLIGM")
	_aCli := GetCliGm(_cCodCliGm)
	_cCliente := _aCli[1]
	_cLojaCli := _aCli[2]
	
	_cNomeCli := Posicione("SA1", 01, xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI, "A1_NOME")
	
	_cTipoCli := Posicione("SA1", 01, xFilial("SA1") + _cCliente + _cLojaCli, "A1_TIPO")
	
	_cOper := "05" // SIMPLES REMESSA
	                                          
	_cNfGm    := Posicione("ZZW", 4, xFilial("ZZW") + _cPacote + aPed[Nx, 4], "ZZW_NFGM")
	_cSerNfGm := Posicione("ZZW", 4, xFilial("ZZW") + _cPacote + aPed[Nx, 4], "ZZW_SERGM") 
	
	_cMensagem := "Nota de Transp. ref. NF: " + _cNfGm + " Série: " + _cSerNfGm + " Razão Social: " + PadL(_cNomeCli,40)

	aCabPV 	:= {}
	
	aCabPV:={{"C5_TIPO"   	,"N"       			,Nil},; // Tipo de pedido
			{"C5_CLIENTE"	,_cCliente   	 				,Nil},; // Codigo do cliente padrao GM
			{"C5_CLIENT"	,_cCliente   					,Nil},; // Codigo do cliente destino mercadoria
			{"C5_LOJACLI"	,_cLojaCli     				,Nil},; // Loja do cliente padrao GM
			{"C5_LOJAENT"	,_cLojaCli    				,Nil},; // Loja do cliente destino mercadoria   
			{"C5_TIPOCLI"	,_cTipoCli    				,Nil},; // Loja do cliente destino mercadoria
	 		{"C5_CONDPAG"	,SC5->C5_CONDPAG 			,Nil},; 
			{"C5_TABELA"	,SC5->C5_TABELA				,Nil},;
			{"C5_VEND1"	  ,SC5->C5_VEND1 		    ,Nil},; // Código do Vendedor
			{"C5_MENNOTA"	,_cMensagem   		    ,Nil},; // Mensagem com observações para NF
			{"C5_PEDCLI"  ,SC5->C5_NUM					,Nil},; // Pedido do cliente
			{"C5_X_CLVL"  ,SC5->C5_X_CLVL  			,Nil}}
			
	aItens 		:= {}

	SC6->(dbSetOrder(01))	
	SC6->(dbSeek(xFilial("SC6") + SC5->C5_NUM))
	
	SD2->(dbSetOrder(08))
	
	While SC6->C6_FILIAL + SC6->C6_NUM == SC5->C5_FILIAL + SC5->C5_NUM
    
    // Busca os valores finais da tabela sd2
		SD2->(dbSeek(xFilial("SD2") + SC6->C6_NUM + SC6->C6_ITEM))
		                                        
		// Valor + Impostos (IPI + ST)
		nValTot := SD2->D2_TOTAL+ SD2->D2_VALIPI + SD2->D2_ICMSRET
		
		// Ajusta o novo preço unitário
		nVUni := nValTot / SD2->D2_QUANT
		
		aLinha := {}
		aadd(aLinha,{"C6_ITEM"		,SC6->C6_ITEM,Nil})
		aadd(aLinha,{"C6_PRODUTO"	,SC6->C6_PRODUTO					,Nil})
		aadd(aLinha,{"C6_QTDVEN"	,SC6->C6_QTDVEN   				,Nil})      //	aadd(aLinha,{"C6_QTDVEN"	,aColsEx[nIt,4]						,Nil})
		aadd(aLinha,{"C6_PRCVEN"	,nVUni        						,Nil})
  	aadd(aLinha,{"C6_VALOR"		,nValTot									,Nil})
		aadd(aLinha,{"C6_ENTREG"	,dDataBase  							,Nil})
		aadd(aLinha,{"C6_OPER"		,_cOper   	  						,Nil}) 
			
		AAdd(aItens,aLinha)
			
		SC6->(dbSkip())
	EndDo                    
	
	If !Empty(aItens)
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
	 
		MSExecAuto({|x,y,z|Mata410(x,y,z)},aCabPV,aItens,3 )
		  
	  // Caso deu erro, cancela
		If lMsErroAuto
			RollBackSX8()
			MostraErro()
			DisarmTransaction()
	//			Break
		Else // Confirma a gravação
			
			// atualiza o status na zzw			
			ZZW->(dbGoTo(aPed[nX, 5]))
			RecLock("ZZW", .F.)        
			ZZW->ZZW_STATUS := '3'
			ZZW->(MsUnlock())
			
	   	aRotina 	:= {{ OemToAnsi("Pesquisar")	,"AxPesqui" 	, 0 , 1},;
							{ OemToAnsi("Visualizar")	,"A410Visual" 	, 0 , 2}}
							
			// Atualiza a informação do pedido no ZZW
			GrvPedZZW(_cPacote, _cCodCliGm, SC5->C5_NUM)
			
			If MSGBOX("Visualizar Pedido "+SC5->C5_NUM+"?","Pedido de Remessa","YESNO")
				A410Visual("SC5",SC5->(RecNo()),1)
			Endif
			
		Endif
	Endif
		
Next nX

RestArea(_aArea)
Return (lRet)

Static Function GetPedOk(_cPacote)
Local aPeds := {}
Local cSql := ""
cSql := "SELECT DISTINCT ZZW_NUMPED, ZZW_NFGERA, ZZW_SERGER, ZZW_PEDCLI, R_E_C_N_O_ AS CODREG FROM " + RetSqlName("ZZW") 
cSql += " WHERE ZZW_PACOTE =  '" + _cPacote + "' AND ZZW_STATUS = '2' "
cSql += "   AND ZZW_NFGM <> ' ' "
cSql += "   AND ZZW_CODEMP = '" + cEmpAnt + "' AND ZZW_CODFIL = '" + cFilAnt + "' "
TcQuery cSql New Alias "TMPZZW"

While TMPZZW->(!Eof())
	aAdd(aPeds, {TMPZZW->ZZW_NUMPED, TMPZZW->ZZW_NFGERA, TMPZZW->ZZW_SERGER, TMPZZW->ZZW_PEDCLI, TMPZZW->CODREG})
	TMPZZW->(dbSkip())
EndDo
TMPZZW->(dbCloseArea())

Return aPeds