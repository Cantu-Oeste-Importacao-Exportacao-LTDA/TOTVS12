#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para controle do faturamento do frete						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Validar nota
// Validar canhoto
// Validar valor retornado do frete no pedido
// Verificar frete cobrado adicional de reentrega


User Function FRTRetEnt()
Local 	aArea 		:= GetArea()
Local 	aButtons  	:= {} //{ { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2
Local   cCpos 		:= "ZZS_NOMEMP/ZZS_NOMFIL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_NFSAI/ZZS_CLIENT/ZZS_NOMCLI/ZZS_TOTNF/ZZS_CODTRA/ZZS_TRANSP/ZZS_NUMCTR/ZZS_SERCTR/ZZS_DTCTRC/ZZS_NUMFAT/ZZS_VENTIT/ZZS_CANHOT/ZZS_SEGMEN/ZZS_CC/ZZS_VALFRE/ZZS_VLRFIN/ZZS_VLRCTR/ZZS_VLRDIF/ZZS_JUSVLD/ZZS_FORMPG/ZZS_CALCFR/ZZS_EMPRES/ZZS_FILORI/"
Local   aCpos 		:= StrToKArr(cCpos, "/")
Private oDlg1
Private oDlg
Private oGet
Private oGeraTxt
Private cAlias		:= "ZZS" 
Private cMunOri		:= Space(05)
Private cUf			:= Space(02)
Private cCadastro 	:= "Retorno de entregas"
Private lRefresh 	:= .T.
Private aHeader 	:= {}
Private aCols 		:= {}
Private cPerg  		:= "FRTRETENT0"
Private aRotina 	:= {{"Pesquisar", "AxPesqui", 0, 1},;
                    	{"Visualizar", "AxVisual", 0, 2},;
                    	{"Incluir", "AxInclui", 0, 3},;
                    	{"Alterar", "AxAltera", 0, 4},;
                    	{"Excluir", "AxDeleta", 0, 5}}
nOpc				:= 3
nOpca				:= 2
aEmps				:= {}
                            
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
// Monta o aHeader
dbSelectArea("SX3")
dbSetOrder(2)// Campo

For nX := 1 to Len(aCpos)
	SX3->(dbSeek(aCpos[nX]))
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
	Endif
End 	

aAdd(aHeader, {"Rec No", "RNO", "", 12, 0, , , , "A", "R"})
// Tela de parametros
ValidPerg() 
Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Conferencia de fretes")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa seleciona todas as notas fiscais vinculadas a "
@ 18,018 Say " romaneios de carga conforme os parametros informados.       "
@ 26,018 Say "                                                             "

@ 60,090 BMPBUTTON TYPE 01 ACTION Close(oGeraTxt)
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered


// Monta o ACols conforme os dados
If (nOpc = 3) // Inclusão
 	SetKey(VK_F7,{||ORDENA()})
	SetKey(VK_F8,{||FILCPO(1)})
	SetKey(VK_F9,{||FILCPO(2)}) 
	SetKey(VK_F10,{||SUBCPO()})
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql := "SELECT ZZS.*, ZZS.R_E_C_N_O_ AS RNO FROM ZZSCMP ZZS "
	cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZS.ZZS_CODTRA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cSql += "AND ZZS.ZZS_NUMROM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	cSql += "AND ZZS.ZZS_NFOK = 'S' AND ZZS.ZZS_NUMCTR = ' ' AND ZZS.ZZS_NFSAI <> ' ' "
//	cSql += "AND ZZS"
	TCQUERY cSql NEW ALIAS "TMPZZS"
	
	TCSETFIELD("TMPZZS","ZZS_DTCTRC","D",08,0)
	TCSETFIELD("TMPZZS","ZZS_VENTIT","D",08,0)
	TCSETFIELD("TMPZZS","ZZS_DTFAT","D",08,0)	
	
	TMPZZS->(dbSelectArea("TMPZZS"))
	TMPZZS->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	If !TMPZZS->(Eof())
		While !TMPZZS->(Eof())

			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			For nX := 1 to Len(aHeader)
				If AllTrim(aHeader[nX, 2]) == "ZZS_DTCTR"
					aCols[Len(aCols), nX] := TMPZZS->ZZS_DTFAT
				ElseIf AllTrim(aHeader[nX, 2]) == "ZZS_VLRCTR" 
					aCols[Len(aCols), nX] := Iif(TMPZZS->ZZS_VLRFIN > 0,TMPZZS->ZZS_VLRFIN,TMPZZS->ZZS_VALFRE)
				Else
					aCols	[Len(aCols), nX] := TMPZZS->(FieldGet(FieldPos(aHeader[nX, 2])))
				Endif
			Next nX			
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			
			TMPZZS->(DbSelectArea("TMPZZS"))							
			TMPZZS->(DbSkip())
		End	
	Else
		If Select("TMPZZS") <> 0
			TMPZZS->(DbCloseArea("TMPZZS"))
		Endif
		Alert("Nenhuma carga encontrada. Verifique os parametros.")
		Return
	Endif
EndIf

_nCarga			:= 0
_nPasseio 		:= 0
ZZS->(DbSelectArea("ZZS"))
ZZS->(DbSetOrder(01))
DEFINE MSDIALOG oDlg1 TITLE cCadastro From 0,0 To 515, 1275 PIXEL OF oMainWnd
/*
@ 020,003 Say OemToAnsi("Carga:")
@ 020,030 Get _nCarga Picture "@E 999,999" Size 50,10 When .f.

@ 020,103 Say OemToAnsi("Passeio:")
@ 020,130 Get _nPasseio Picture "@E 999,999" Size 50,10 When .f.

@ 020,203 Say OemToAnsi("Total:")
@ 020,230 Get 0 Picture "@E 999,999" Size 50,10 When .f.
*/	
If nOpc = 3
//	@ 020,460 Say OemToAnsi("F7-Ordenar  F10- Marca Todos  F10- Marca Todos")
	@ 020,460 Say OemToAnsi("F7-Ordenar    F8-Filtrar    F9-Remover Excluidos   F10-Atualizar Coluna")
Endif
//                                                       del  // "ZZS_NUMCTR","ZZS_DTCTRC","ZZS_NUMFAT","ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG"
oGet := MSGetDados():New(035,1,255,640,nOpc,"U_FRTLIOK","U_FRTTOK", "", .T.,{"ZZS_NUMCTR","ZZS_SERCTR","ZZS_DTCTRC","ZZS_NUMFAT",;
					"ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG","ZZS_CODTRA"}, , .F., Len(aCols), "U_FrtEntVld")
oGet:oBrowse:nColPos


//ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| GrvEmb(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() },,aButtons)
ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| IIf(u_FRTTOK(),GrvEmb(nOpc),.f.)},{|| oDlg1:End() },,aButtons)
If Select("TMPZZS") <> 0
	TMPZZS->(DbCloseArea("TMPZZS"))
Endif

Return

User Function FRTTOK()
Local lRet	:= .T.
Local cVarAtu 	:= ReadVar()
Local nPosis  	:= oGet:oBrowse:nColPos
Local nLinAt 	:= oGet:oBrowse:nAt
Local cCpo 		:= aHeader[nPosis, 2]
Local nPosFrt 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})
Local nPosComb 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})
Local nPosDif 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRDIF"})
Local nPosJust 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_JUSVLD"})
Local nPosNCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMCTR"})
Local nPosSCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SERCTR"})
Local nPosNFat 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMFAT"})
Local nPosTra	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local nPosEmp	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_EMPRES"})
Local nPosCli	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CLIENT"})
Local nPosEmi	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_DTCTRC"})
Local nPosVen	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VENTIT"})
Local nPosCan	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CANHOT"})
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRCTR"})
Local nPosFpg	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FORMPG"})
Local nPosTNf	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posição Valor total nota fiscal 
Local aAreaZZS	:= TMPZZS->(GetArea())
Local _nPass	:= 0
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

For _nX := 1 To Len(aCols)
	If !Empty(aCols[_nX,nPosNCtr])
	  	If Empty(AllTrim(DtoS(aCols[_nX,nPosEmi]))) .and. lRet
	  		MsgInfo("Data de emissão inválida. Verifique")
			lRet := .F.
	  	Endif
	  	If Empty(AllTrim(DtoS(aCols[_nX,nPosVen]))) .and. lRet
	  		MsgInfo("Data de vencimento inválida. Verifique")
			lRet := .F.
	  	Endif  		
	  	If Empty(AllTrim(aCols[_nX,nPosNFat])) .and. lRet
	  		MsgInfo("Número de fatura inválida. Verifique")
			lRet := .F.
	  	Endif
	  	If Empty(AllTrim(aCols[_nX,nPosCan])) .and. lRet
	  		MsgInfo("Campo para canhoto não preenchido. Verifique")
	 		lRet := .F.
	  	Endif  			
	  	If Empty(AllTrim(aCols[_nX,nPosCan])) .and. lRet
	  		MsgInfo("Valor do frete não preenchido. Verifique")
			lRet := .F.
	  	Endif
	  	If Empty(AllTrim(aCols[_nX,nPosFpg])) .and. lRet
	  		MsgInfo("Forma de pagamento não selecionada. Verifique")
			lRet := .F.
		Endif    		
	  	If Empty(AllTrim(aCols[_nX,nPosSCtr])) .and. lRet
	  		MsgInfo("Forma de pagamento não selecionada. Verifique")
			lRet := .F.
		Endif    			
	  	If aCols[_nX,nPosVal] <= 0
	  		MsgInfo("Valor inválido. Verifique")
			lRet := .F.
		Endif 		
		If lRet
			_nPass += 1
		Endif
	Endif
Next _nX 
If lRet .and. _nPass > 0
	nOpca := 3
	_nTFre	:= 0
	_nTnf	:= 0
	_nTComb	:= 0
	_nTCTRC	:= 0
	_nTDive	:= 0
	For _nX := 1 To Len (aCols)
		If !aCols[_nX,29] .and. !Empty(aCols[_nX,nPosNCtr])
			_nTFre	+= aCols[_nX,nPosFrt]
			_nTComb	+= aCols[_nX,nPosComb]
			_nTnf	+= aCols[_nX,nPosTNf]
			_nTCTRC += aCols[_nX,nPosVal]
			_nTDive	+= aCols[_nX,nPosDif]
		Endif
	Next _nX
  	@ 100, 100 To 320, 570 Dialog oDlConf Title "Valores Frete."
	@ 015,010 Say "Verifique se os valores estão corretos para os pedidos selecionados e confirme. "
	@ 030,010 Say "Valor total do frete: " 
	@ 030,130 Get _nTFre Picture "@E 99,999,999.99" Size 100,10 When .f.
	@ 045,010 Say "Valor total frete combinado: "
	@ 045,130 Get _nTComb Picture "@E 99,999,999.99" Size 100,10 When .f. 
	@ 060,010 Say "Valor total CTRC: "	
	@ 060,130 Get _nTCTRC Picture "@E 99,999,999.99" Size 100,10 When .f. 
	@ 075,010 Say "Valor total divergente: "
	@ 075,130 Get Iif(_nTComb> 0,(_nTCTRC-_nTComb),(_nTCTRC-_nTFre)) Picture "@E 99,999,999.99" Size 100,10 When .f.

//	@ 045,060 Get cMunOri Size 040,10 When ValMunOri() F3 "CC2GER"
//	@ 045,110 Get cNMunOri Size 100,10 When .f.

	Activate Dialog oDlConf Center ON INIT ; 
	EnChoiceBar(oDlConf,{||nOpca:=1,oDlConf:End()} , {||nOpca:=2,oDlConf:End()})  CENTER 
	If nOpca <> 1
		lRet	:= .F.
	Endif
Endif

Return lRet

User Function FRTLIOK()
Local lRet	:= .T.
Local cVarAtu 	:= ReadVar()
Local nPosis  	:= oGet:oBrowse:nColPos
Local nLinAt 	:= oGet:oBrowse:nAt
Local cCpo 		:= aHeader[nPosis, 2]
Local nPosFrt 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})
Local nPosComb 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})
Local nPosDif 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRDIF"})
Local nPosJust 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_JUSVLD"})
Local nPosNCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMCTR"})
Local nPosSCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SERCTR"})
Local nPosNFat 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMFAT"})
Local nPosTra	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local nPosEmp	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_EMPRES"})
Local nPosCli	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CLIENT"})
Local nPosEmi	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_DTCTRC"})
Local nPosVen	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VENTIT"})
Local nPosCan	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CANHOT"})
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRCTR"})
Local nPosFpg	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FORMPG"})
//Local nPosTran	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local aAreaZZS	:= TMPZZS->(GetArea())
                                 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If !Empty(aCols[n,nPosNCtr])
  	If Empty(AllTrim(DtoS(aCols[n,nPosEmi])))
  		MsgInfo("Data de emissão inválida. Verifique")
		lRet := .F.
  	Endif
  	If Empty(AllTrim(DtoS(aCols[n,nPosVen])))
  		MsgInfo("Data de vencimento inválida. Verifique")
		lRet := .F.
  	Endif  		
  	If Empty(AllTrim(aCols[n,nPosNFat]))
  		MsgInfo("Número de fatura inválida. Verifique")
		lRet := .F.
  	Endif
  	If Empty(AllTrim(aCols[n,nPosCan]))
  		MsgInfo("Campo para canhoto não preenchido. Verifique")
 		lRet := .F.
  	Endif  			
  	If Empty(AllTrim(aCols[n,nPosCan]))
  		MsgInfo("Valor do frete não preenchido. Verifique")
		lRet := .F.
  	Endif
  	If Empty(AllTrim(aCols[n,nPosFpg]))
  		MsgInfo("Forma de pagamento não selecionada. Verifique")
		lRet := .F.
	Endif    		
  	If Empty(AllTrim(aCols[n,nPosSCtr]))
  		MsgInfo("Forma de pagamento não selecionada. Verifique")
		lRet := .F.
	Endif
  	If aCols[n,nPosVal] <= 0
  		MsgInfo("Valor inválido. Verifique")
		lRet := .F.
	Endif 	    			
Endif


Return lRet

/*********************************************************
 Função de validação dos dados no grid, deve-se atentar para cada coluna
 ********************************************************/
User Function FrtEntVld()
Local lOk := .T.
Local cVarAtu 	:= ReadVar()
Local nPosis  	:= oGet:oBrowse:nColPos
Local nLinAt 	:= oGet:oBrowse:nAt
Local cCpo 		:= aHeader[nPosis, 2]
Local nPosFrt 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})
Local nPosComb 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})
Local nPosDif 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRDIF"})
Local nPosJust 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_JUSVLD"})
Local nPosNCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMCTR"})
Local nPosSCtr 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SERCTR"})
Local nPosNFat 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMFAT"})
Local nPosTra	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local nPosEmp	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_EMPRES"})
Local nPosCli	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CLIENT"})
Local nPosEmi	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_DTCTRC"})
Local nPosVen	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VENTIT"})
Local nPosCan	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CANHOT"})
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRCTR"})
Local nPosFpg	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FORMPG"})
Local aAreaZZS	:= TMPZZS->(GetArea())
Local nPosRno 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "RNO"})  // recno

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// "ZZS_NUMCTR","ZZS_DTCTRC","ZZS_NUMFAT","ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG"
If (cCpo == "ZZS_VLRCTR")
	nValCtr := &cVarAtu
	nValFrt := Round(aCols[nLinAt, nPosFrt],2)
	nValComb := Round(aCols[nLinAt, nPosComb],2) 
	nValFrt := Iif(nValComb > 0, nValComb, nValFrt)
	If (nValCtr > nValFrt)
		If !(JusVlFrt(nLinAt, nPosJust))
			(&cVarAtu) := 0
			nValCtr := 0
			nValFrt := 0
		EndIf
	Else
		aCols[nLinAt, nPosJust] := Space(30)
	EndIf
	If (nValCtr >= 0)  	
		aCols[nLinAt, nPosDif] := (nValCtr-nValFrt)
	Else
		aCols[nLinAt, nPosDif] := 0
	EndIf
Elseif (cCpo == "ZZS_VENTIT")	
	If (&cVarAtu) < dDataBase
		MsgInfo("Data de vencimento inválido. Verifique")
		lOk	:= .F.
	Endif
Elseif (cCpo == "ZZS_DTCTRC")	
	If (&cVarAtu) > dDataBase
		MsgInfo("Data de emissão inválida. Verifique")
		lOk	:= .F.                	
	Endif	
Elseif (cCpo == "ZZS_NUMCTR")
	cVal := &cVarAtu
	If !Empty(cVal)
		//aCols[nLinAt, nPosNCtr] := PadL(Trim(cVal), 9, '0')
		(&cVarAtu) := PadL(Trim(cVal), 9, '0')
	EndIf
	/*elseif (cCpo == "ZZS_SERCTR")
	 cVal := &cVarAtu
		if !Empty(cVal)
			//aCols[nLinAt, nPosNCtr] := PadL(Trim(cVal), 3, '0')
			(&cVarAtu) := PadL(Trim(cVal), 3, '0')
		EndIf*/
ElseIf (cCpo == "ZZS_SERCTR")
	For _nR	:= 1 To Len(aCols)
	    If _nR <> n
		  	If aCols[_nR,nPosTra]+aCols[_nR,nPosNCtr]+aCols[_nR,nPosSCtr] == aCols[n,nPosTra]+aCols[n,nPosNCtr]+(&cVarAtu)
		  		If aCols[_nR,nPosCli] <> aCols[n,nPosCli]
			  		MsgInfo("CTRC já utilizado em outra nota. Verifique")
			  		lOk	:= .F.
		  		Endif
		  	Endif
		  	If lOk 
				cSql := "SELECT F1.F1_DOC "
				cSql += "FROM SF1"+aCols[_nR,nPosEmp]+"0"+" F1 "
				cSql += "WHERE F1.D_E_L_E_T_ <> '*' "
				cSql += "AND F1.F1_FORNECE = '"+aCols[_nR,nPosTra]+"' "
				cSql += "AND F1.F1_DOC = '"+aCols[_nR,nPosNCtr]+"' AND F1.F1_SERIE = '"+aCols[_nR,nPosSCtr]+"' "
				TCQUERY cSql NEW ALIAS "TMPSF1"
			
				TMPSF1->(dbSelectArea("TMPSF1"))
				TMPSF1->(dbGoTop())				
				If !Eof()
			  		MsgInfo("CTRC já lançado em outra nota. Verifique")
			  		lOk	:= .F.					
				Endif
				TMPSF1->(dbSelectArea("TMPSF1"))				
				TMPSF1->(dbCloseArea("TMPSF1"))								
		  	Endif
	  	Endif
	Next _nR
Elseif (cCpo == "ZZS_NUMFAT")
	cVal := &cVarAtu
	If !Empty(cVal)
		//aCols[nLinAt, nPosNCtr] := PadL(Trim(cVal), 9, '0')
		(&cVarAtu) := PadL(Trim(cVal), 9, '0')
	EndIf
ElseIf (cCpo == "ZZS_CODTRA")
	_cTrAtu	:= ""
	SA4->(dbSetOrder(1))
	SA4->(dbSeek(xFilial("SA4")+aCols[nLinAt,nPosTra]))
	_cTrAtu	:= SubStr(SA4->A4_CGC,1,8)
	
	SA4->(dbSetOrder(1))
	SA4->(dbSeek(xFilial("SA4")+M->ZZS_CODTRA))
	If SubSTr(SA4->A4_CGC,1,8) <> _cTrAtu
		MsgAlert("Filial diferente do transportador atual. Verifique.")
		lOk	:= .F.
	Else
		nRno := aCols[nLinAt, nPosRno]
		ZZS->(DbGoTo(nRno))
		RecLock("ZZS", .F.)	
			ZZS->ZZS_CODTRA := aCols[nLinAt,nPosTra]
		ZZS->(MsUnlock())	
		
	Endif
EndIf
RestArea(aAreaZZS)

Return lOk
          
// Solicita digitação de justificativa valor do ctrc maior que o combinado
Static Function JusVlFrt(nLin, nCol)
Local cJust := Space(30)
Local oDlg2
Local lOk := .F.

/*
// Se estiver prenchido não solicita novamente para preencher
if !Empty(aCols[nLin, nCol])
	Return .T.
EndIf*/

_cObs		:= Space(30)
@ 100, 100 To 200, 650 Dialog oDlg2 Title "Observação."
@ 020,010 Say "Observação :"
@ 020,050 Get cJust Picture "@!"  Size 150,10
		
Activate Dialog oDlg2 Center ON INIT ; 
EnChoiceBar(oDlg2,{||lOk := .T.,oDlg2:End()} , {||lOk :=.F.,oDlg2:End()})  CENTER 

if (lOk) .And. Empty(cJust)
	lOk := .F.
	MsgInfo("Necessário informar a justificativa.")
EndIf

if (lOk)
	aCols[nLin, nCol] := cJust
EndIf
Return lOk

Static Function GrvEmb()
Local nPosCtr 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NUMCTR"})
Local nPosSerCtr 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_SERCTR"})
Local nPosRom 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NUMROM"})
Local nPosDtCtr 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_DTCTRC"})    // data ctrc
Local nPosNumFt 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NUMFAT"}) // numero fatura
Local nPosPed 		:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_PEDIDO"})   // pedido
Local nPosVenTit	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VENTIT"})  // vencimento do titulo
Local nPosVlFin		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // valor frete combinado
Local nPosCanh		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CANHOT"})  // canhoto
Local nPosVlCtr		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRCTR"})   // valor frete retornado
Local nPosFormPg 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FORMPG"})  // forma de pagamento
Local nPosRno 		:= aScan(aHeader,{|x| AllTrim(x[2]) == "RNO"})  // recno

Local _aCols	:= aCols
Local lGrava	:= .F.
Local lExclui	:= .F.
Local nTotNF	:= 0
Local lOK := .T.


// fazer a validação dos dados digitados
// Valida os números dos CTRCs digitados
For nX := 1 to len(aCols)
	if !Empty(Trim(aCols[nX, nPosCtr] + aCols[nX, nPosSerCtr])) .and. !aCOLS[nX,Len(aHeader)+1] 
		ValidaCTR(aCols[nX, nPosCtr], aCols[nX, nPosSerCtr])
		if !lOk
			Return	
		EndIf
	EndIf
Next nX

// Fazer validação entre as colunas do array quanto ao número e série do ctrc

// Validar os campos de data

For nX := 1 to len(aCols)
	nRno := aCols[nX, nPosRno]
	ZZS->(DbGoTo(nRno))
	RecLock("ZZS", .F.)
	ZZS->ZZS_NUMCTR := aCols[nX, nPosCtr]
	ZZS->ZZS_SERCTR := aCols[nX, nPosSerCtr]
	ZZS->ZZS_DTCTRC := aCols[nX, nPosDtCtr]
		
	ZZS->ZZS_NUMFAT := aCols[nX, nPosNumFt]
	ZZS->ZZS_VENTIT := aCols[nX, nPosVenTit]
	ZZS->ZZS_CANHOT := aCols[nX, nPosCanh]
	ZZS->ZZS_VLRCTR := aCols[nX, nPosVlCtr]
	ZZS->ZZS_FORMPG := aCols[nX, nPosFormPg]
	ZZS->(MsUnlock())	
Next nX
  
// Faz controle para gerar pre-nota de entrada com os itens que tiverem romaneio preenchidos
GeraPreNf()

ODlg1:End()


Return

// Função que vare o aCols verificando se o ctrc é único por cliente e se já existe um ctrc cobrado para o mesmo cliente
Static Function ValidaCTR(cNum, cSerie)
Local cSql := "SELECT R_E_C_N_O_ AS RNO FROM ZZSCMP ZZS WHERE D_E_L_E_T_ <> '*' AND ZZS_NUMCTR = '" + cNum + "' AND ZZS_SERCTR = '" + cSerie + "' "
Local nRno := 0
TcQuery cSql NEW Alias "ZZSCTR"
if ! ZZSCTR->(Eof())
	nRno := ZZSCTR->RNO
EndIf
ZZSCTR->(dbCloseArea())
Return nRno

// Função para gerar as pré-notas de entrada com os valores específicos para cada conhecimento de transporte
Static Function GeraPreNf()
Local aCabec := {}
Local aDetItens := {}
Local aDetItem := {}
//Local cTipo := "N"
Local aForn := ""
Local nPosCtr := aScan(aHeader, {|x| Trim(x[2]) == "ZZS_NUMCTR"})
Local nPosSerCtr := aScan(aHeader, {|x| Trim(x[2]) == "ZZS_SERCTR"})
Local nPosRno := aScan(aHeader, {|x| Trim(x[2]) == "RNO"})
Local aNotas := {}
Local cProdFrt := "98020035"
Local nX, cChave
Local lGrava := .F.
Local aClass	:= {}

SA4->(dbSetOrder(1))
SA2->(dbSetOrder(3))

aSort(aCols,,, {|x,y| x[nPosCtr]<y[nPosCtr]})

For nX := 1 to Len(aCols)
	if !Empty(aCols[nX, nPosCtr])
		aAdd(aNotas, {aCols[nX, nPosCtr], aCols[nX, nPosSerCtr], aCols[nX, nPosRno]})
	EndIf
Next nX
If Len(aNotas) > 0
	nGeraAt := 1
	cChave := aNotas[nGeraAt, 1] + aNotas[nGeraAt, 2]
	While nGeraAt <= Len(aNotas)
		// Posiciona a ZZS
		ZZS->(dbGoTo(aNotas[nGeraAt, 3]))
		
		// Localiza o fornecedor
		SA4->(dbSeek(xFilial("SA4")+ZZS->ZZS_CODTRA))
		SA2->(dbSeek(xFilial("SA2")+SA4->A4_CGC))
		
		aCabec := {}
		aAdd(aCabec, {"F1_FILIAL"	,ZZS->ZZS_FILORI, nil})
		aAdd(aCabec, {"F1_FORMUL"	,"N", nil})
		aAdd(aCabec, {"F1_TIPO"		,"N", nil})
		aAdd(aCabec, {"F1_FORNECE"	,SA2->A2_COD, nil})
		aAdd(aCabec, {"F1_LOJA"		,SA2->A2_LOJA, nil})
		aAdd(aCabec, {"F1_EST"		,SA2->A2_EST, nil})
		aAdd(aCabec, {"F1_DOC"		,PadL(ZZS->ZZS_NUMCTR, 9, "0"), nil})
		aAdd(aCabec, {"F1_SERIE"	,ZZS->ZZS_SERCTR, nil})
		aAdd(aCabec, {"F1_EMISSAO"	,ZZS->ZZS_DTCTRC, nil})
		aAdd(aCabec, {"F1_ESPECIE"	,"CTR", nil})
		aAdd(aCabec, {"F1_X_FATTR"	,ZZS->ZZS_NUMFAT, nil}) // Fatura Transportadora
		
		if cChave == aNotas[nGeraAt, 1] + aNotas[nGeraAt, 2]
			ZZS->(dbGoTo(aNotas[nGeraAt, 3]))		
		  aDetItem := {}
			aAdd(aDetItem, {"D1_FILIAL"	,ZZS->ZZS_FILORI, Nil})
			aAdd(aDetItem, {"D1_COD"	,cProdFrt, Nil})
			
			// busca os dados do produto
			SB1->(dbSetOrder(01))
			SB1->(dbSeek(xFilial("SB1") + cProdFrt))
			
			aAdd(aDetItem, {"D1_DESCRI", Trim(SB1->B1_DESC) + " NF " + ZZS->ZZS_NFSAI, Nil})	
			aAdd(aDetItem, {"D1_UM", SB1->B1_UM, Nil})
	//		aAdd(aDetItem, {"D1_LOCAL", SB1->B1_LOCPAD, Nil})
	
			aAdd(aDetItem, {"D1_QUANT", 1, Nil})
			aAdd(aDetItem, {"D1_VUNIT", ZZS->ZZS_VLRCTR, Nil})
			aAdd(aDetItem, {"D1_TOTAL", ZZS->ZZS_VLRCTR, Nil})
			aAdd(aDetItem, {"D1_CLVL",  ZZS->ZZS_SEGMEN, Nil})
			aAdd(aDetItem, {"D1_CC",  ZZS->ZZS_CC, Nil})
			aAdd(aDetItens, aDetItem)
		EndIf
		
		// Se for o último item grava
		if nGeraAt == Len(aNotas)
			lGrava := .T.
		else
			lGrava := (cChave != aNotas[nGeraAt+1, 1] + aNotas[nGeraAt+1, 2])	
		EndIf
		
		nGeraAt++
		If nGeraAt <= Len(aNotas)
			cChave := aNotas[nGeraAt, 1] + aNotas[nGeraAt, 2]	
		Endif
		if lGrava
			// faz a inclusão dos dados
	  	    conout("antes job")
			StartJob("U_GrvFrtEnt",GetEnvServer(), .T.,ZZS->ZZS_EMPRES, ZZS->ZZS_FILORI, aCabec,aDetItens)
			Conout("dpois Job")
			SF1->(DbSelectArea("SF1"))
			SF1->(DbSetOrder(1))
			SF1->(Dbgotop())
			If SF1->(DbSeek(xFilial("SF1")+PadL(ZZS->ZZS_NUMCTR, 9, "0")+ZZS->ZZS_SERCTR+SA2->A2_COD+SA2->A2_LOJA))
				SF1->(RecLock("SF1", .F.))
					SF1->F1_X_FATTR := ZZS->ZZS_NUMFAT
				SF1->(MsUnlock())// 1				2				3				4				5			6			7			8
				aAdd(aClass,{ZZS->ZZS_EMPRES,ZZS->ZZS_FILORI,SF1->F1_FILIAL,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE,ZZS->ZZS_NUMFAT})
			Endif
			/*lMsErroAuto := .F.		
			MSExecAuto({|x,y,z|   MATA140(x,y,z)}, aCabec, aDetItens, 3)
					
			If lMsErroAuto
				mostraerro() // se ocorrer erro no sigaauto gera mensagem de informação do erro  
				MsgBox("Pré-nota não incluída.")
			EndIf*/
			
			aDetItens := {}	                                                    
		EndIf
	EndDo
	If MsgBox("Deseja classificar os CTRC´s agora?", "Atenção", "YESNO")
		If Len(aClass) > 0
			For _nR	:= 1 To Len(aClass)
		//		aAdd(aClass,{ZZS->ZZS_EMPRES,ZZS->ZZS_FILORI,SF1->F1_FILIAL,SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_DOC,SF1->F1_SERIE})
	//			A103NFiscal(cAlias,nReg,nOpcx,lWhenGet)
				If cEmpAnt + cFilAnt == aClass[_nR,1] + aClass[_nR,2]
					SF1->(DbSelectArea("SF1"))
					SF1->(DbSetOrder(1))
					SF1->(Dbgotop())
					If SF1->(DbSeek(aClass[_nR,3]+aClass[_nR,6]+aClass[_nR,7]+aClass[_nR,4]+aClass[_nR,5]))
						A103NFiscal("SF1",Recno(),4)
						SE2->(DbSelectArea("SE2"))
						SE2->(DbSetOrder(6))
						If SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC))				
							While !SE2->(Eof()) .AND. xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == ;
												xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC
								SE2->(RecLock("SE2", .F.))
									SE2->E2_X_FATTR := SF1->F1_X_FATTR
								SE2->(MsUnlock())
								SE2->(DbSkip())										
							End
						Endif						
					Endif
				Else
					MsgInfo("Empresa/Filial diferente da atual. Para classificação deve estar na filial correta.")
				Endif
			Next _nR
			U_FrtClass()			
//			FINA290() // FATURA A PAGAR      
		Endif
	Endif
Endif

Return

// Função para gravar a pre-nota devido as diferentes empresa e filiais que é operado
User Function GrvFrtEnt(cEmp, cFil, aCab, aItens)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetType(3)
RpcSetEnv(cEmp, cFil,,,"COM")

lMsErroAuto := .F.		
MSExecAuto({|x,y,z|   MATA140(x,y,z)}, aCab, aItens, 3)

If lMsErroAuto
	ConOut(mostraerro()) // se ocorrer erro no sigaauto gera mensagem de informação do erro  
	MsgBox("Pré-nota não incluída.")
EndIf

RpcClearEnv()
Return

Static Function Ordena()
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos 

if (nPosis > 0)
	ASort(aCols,,,{ |x,y| x[nPosis] < y[nPosis]})
EndIf     

Return Nil

/*
#############################################################################
### Efetua a substituição dos dados de toda a coluna.                     ###
#############################################################################
*/
Static Function SUBCPO()
Local oDlg
Local cConteudo := ""
Local nPosis  := oGet:oBrowse:nColPos
Local cVarAtu := ReadVar()
// "ZZS_DTCTRC","ZZS_NUMFAT","ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG"

If AllTrim(aHeader[nPosis,2]) $ "ZZS_DTCTRC/ZZS_NUMFAT/ZZS_VENTIT/ZZS_CANHOT/ZZS_FORMPG/ZZS_SERCTR"
	For nR := 1 To Len(aCols)
		aCols[nR,nPosis] 	:= aCols[n,nPosis]
	Next nR
Else
	MsgInfo("Alteração não permitina nesta coluna.")
Endif


Return Nil

/*
#############################################################################
### Efetua o filtro dos dados com base no campo posicionado               ###
#############################################################################
*/
Static Function FILCPO(_nOpc)
Local _aCols  := aCols
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos
//Local _nPFre		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
_nTotFre	:= 0

If nPosis > 0
	cComp	  := aCols[n,nPosis]
	aCols := {}
Endif
If _nOpc = 1
	If nPosis > 0
		For nR := 1 To Len(_aCols)             
			If _aCols[nR,nPosis] == cComp
				aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
				_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
				_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21],;
				_aCols[nR,22],_aCols[nR,23],_aCols[nR,24],_aCols[nR,25],_aCols[nR,26],_aCols[nR,27],_aCols[nR,28],_aCols[nR,29]})
//			_nTotFre += _aCols[nR,_nPFre]			
			Endif
		Next nR
	Endif
Else
	For nR := 1 To Len(_aCols)             
		If !_aCols[nR,29]
			aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
			_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
			_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21],;
			_aCols[nR,22],_aCols[nR,23],_aCols[nR,24],_aCols[nR,25],_aCols[nR,26],_aCols[nR,27],_aCols[nR,28],_aCols[nR,29]})
//		_nTotFre += _aCols[nR,_nPFre]			
		Endif
	Next nR
endif
dlgRefresh(oDlg1)
oGet:oBrowse:Refresh()

n:= 1
Return nil

Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Transp. Inicial  ","","","mv_ch1","C",06,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA4","",""})
aAdd(aRegs,{cPerg,"02","Transp. Final    ","","","mv_ch2","C",06,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA4","",""})
aAdd(aRegs,{cPerg,"03","Carga Inicial    ","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Carga Final      ","","","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
dbSelectArea(_sAlias)
Return
