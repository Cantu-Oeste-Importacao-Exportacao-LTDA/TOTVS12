#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para montagem de carga    						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// VALIDAR QUANDO CARGA FECHADA.
// VERIFICAR EXCLUSÃO DE PEDIDO.


User Function FRTSep()
Local 	aArea := GetArea()
Local 	aButtons  := {} //{ { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2	
Private aREG 	:= {}
Private oDlg1
Private oDlg
Private oGet
Private cAlias	:= "ZZS" 
Private cMunOri	:= Space(05)
Private cUf	:= Space(02)
Private cCadastro := "Confirmação de separação."
Private lRefresh := .T.
Private aHeader := {}
Private aCols := {}
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
                    {"Visualizar", "AxVisual", 0, 2},;
                    {"Incluir", "AxInclui", 0, 3},;
                    {"Alterar", "AxAltera", 0, 4},;
                    {"Excluir", "AxDeleta", 0, 5}}
nOpc	:= 3
nOpca	:= 2
aEmps	:= {}   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

 
// Monta o aHeader
If nOpc = 3 // Inclusão
	cRomane	:= Space(09)
	@ 100, 100 To 190, 550 Dialog oDlg Title "Digite numero da carga."
	@ 025,010 Say "Carregamento: "
	@ 025,050 Get cRomane Size 040,10 When .T. F3 "ZZSROM" Picture "@!"
	Activate Dialog oDlg Center ON INIT ; 
	EnChoiceBar(oDlg,{||nOpca:=1,oDlg:End()} , {||nOpca:=2,oDlg:End()})  CENTER 
	If nOpca = 2 
		Return
	Else
		//	validar confirmação
	Endif
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
//		If AllTrim(SX3->X3_CAMPO) $ "ZZS_SEL/ZZS_EMPRESA/ZZS_FILIAL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_CLIENTE/ZZS_LOJACL/ZZS_CODTRA/ZZS_TRANSP/ZZS_CALCFR/ZZS_VLRFIN/ZZS_TPFRET/ZZS_BASEFR/ZZS_VALFRE/ZZS_TOTNF"
		If AllTrim(SX3->X3_CAMPO) $ "ZZS_SEPOK/ZZS_EMPRESA/ZZS_FILORI/ZZS_NOMEMP/ZZS_NOMFIL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_CLIENTE/ZZS_LOJACL/ZZS_CODTRA/ZZS_TRANSP/ZZS_TOTNF/ZZS_CALCFR/ZZS_VALFRE"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif
		Endif
		SX3->(DbSkip())
	End 	
Else
	Return
Endif
nPosSep		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SEPOK"}) // Posição codigo da empresa
nPosEmp		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_EMPRES"}) // Posição codigo da empresa
nPosFil		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_FILORI"})  // Posição codigo filial
nPNEmp		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMEMP"}) // Posição nome da empresa
nPNFil		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMFIL"})  // Posição nome filial
nPosCalc 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CALCFR"})  // Tipo do calculo utilizado
nPosRom		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMROM"})  // Posição codigo do romaneio
nPosPed		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_PEDIDO"})  // Posição pedido de venda
nPosCli 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CLIENT"})  // Posição codigo do cliente
nPosLoj 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_LOJACL"})  // Posição loja do cliente
nPosCTr		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})  // Posição codigo do transportador
nPosNTr		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TRANSP"})  // Posição nome do transportador
nPosBas		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_BASEFR"})  // Base de calculo do frete
nPosVal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
nPosFin		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // Posição valor do frete combinado (frete final)
nPosCF		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TPFRET"})  // Posição Tipo do frete (C=Cif F=Fob)
nPosTNf		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posição Valor total nota fiscal

// Monta o ACols conforme os dados
If (nOpc = 3) // Inclusão
	SetKey(VK_F7,{||Ordena()})
	SetKey(VK_F8,{||SUBCPO(1)})
	SetKey(VK_F9,{||SUBCPO(2)}) 
	SetKey(VK_F10,{||""})
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql := "SELECT ZZS.* FROM ZZSCMP ZZS "
	cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZS.ZZS_NUMROM = '"+cRomane+"' AND ZZS.ZZS_NFOK <> 'S' "
//	cSql += "AND ZZS"
	TCQUERY cSql NEW ALIAS "TMPZZS"
	TMPZZS->(dbSelectArea("TMPZZS"))
	TMPZZS->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	If !TMPZZS->(Eof())
		While !TMPZZS->(Eof())

			aAdd( aREG, TMPZZS->( RecNo() ) )
			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
//				aCols[Len(aCols),nPosSel]	:= " "
			aCols[Len(aCols),nPosEmp]	:= TMPZZS->ZZS_EMPRES
			aCols[Len(aCols),nPosFil]	:= TMPZZS->ZZS_FILORI
			aCols[Len(aCols),nPNEmp]	:= TMPZZS->ZZS_NOMEMP
			aCols[Len(aCols),nPNFil]	:= TMPZZS->ZZS_NOMFIL	
			aCols[Len(aCols),nPosRom]	:= TMPZZS->ZZS_NUMROM
			aCols[Len(aCols),nPosPed]	:= TMPZZS->ZZS_PEDIDO
			aCols[Len(aCols),nPosCli]	:= TMPZZS->ZZS_CLIENT
			aCols[Len(aCols),nPosLoj]	:= TMPZZS->ZZS_LOJACL
			aCols[Len(aCols),nPosCTr]	:= TMPZZS->ZZS_CODTRA
			aCols[Len(aCols),nPosNTr]	:= TMPZZS->ZZS_TRANSP
			aCols[Len(aCols),nPosSep]	:= TMPZZS->ZZS_SEPOK
			aCols[Len(aCols),nPosTNf]	:= TMPZZS->ZZS_TOTNF
			aCols[Len(aCols),nPosCalc]	:= TMPZZS->ZZS_CALCFR
			aCols[Len(aCols),nPosVal]:= TMPZZS->ZZS_VALFRE
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			TMPZZS->(DbSelectArea("TMPZZS"))							
		TMPZZS->(DbSkip())
		End	
	Else
		If Select("TMPZZS") <> 0
			TMPZZS->(DbCloseArea("TMPZZS"))
		Endif
		Alert("Carga não encontrada ou já faturada.")
		Return
	Endif
EndIf

_nCarga			:= 0
_nPasseio 		:= 0
ZZS->(DbSelectArea("ZZS"))
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
	@ 020,460 Say OemToAnsi("F7-Ordenar    F8-Marca Todos    F9-Desmarca Todos")
Endif
//                                                       del 
oGet := MSGetDados():New(035,1,255,640,nOpc, , .F., "", .F.,{"ZZS_SEPOK"}, , .F., 256)
oGet:oBrowse:nColPos


ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| GrvEmb(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() },,aButtons)
If Select("TMPZZS") <> 0
	TMPZZS->(DbCloseArea("TMPZZS"))
Endif

Return

Static Function GrvEmb()
Local nPosSep 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_SEPOK"})
Local nPosRom 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_NUMROM"})
Local nPosFil 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_FILIAL"})
Local nPosEmp 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_EMPRES"})
Local nPosPed 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "ZZS_PEDIDO"})
Local nPosVal	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
Local nPosFin	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // Posição valor do frete combinado (frete final)
Local nPosCF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TPFRET"})  // Posição Tipo do frete (C=Cif F=Fob)
Local nPosTNf	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posição Valor total nota fiscal
Local nPosCalc 	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CALCFR"})  // Tipo do calculo utilizado
Local _aCols	:= aCols
Local lGrava	:= .F.
Local lExclui	:= .F.
Local nTotNF	:= 0
_nFrtFech	:= 0
// Aqui recalcular quando pedido for excluido na separação.
If aCols[1,nPosCalc] = "6"
	For nX := 1 To Len(aCols)
		_nFrtFech += aCols[nX,nPosVal]
	Next nX
	CalCarga()	
Endif

For nX := 1 to len(aCols)
	ZZS->(DbSelectArea("ZZS"))
	ZZS->(DbSetOrder(2))
	ZZS->(DbGotop())
	If ZZS->(DbSeek(xFilial("ZZS")+aCols[nX,nPosEmp]+aCols[nX,nPosRom]+aCols[nX,nPosPed]))
		If 	aCols[nX, nPosSep] <> 'X'
			RecLock("ZZS", .F.)
				ZZS->ZZS_SEPOK 	:= aCols[nX, nPosSep]
				ZZS->ZZS_VALFRE	:= aCols[nX, nPosVal]
		  	ZZS->(MsUnlock())
		  	lGrava	:= .T.
	   	Else
			RecLock("ZZS", .F.)
				ZZS->(DbDelete())
		  	ZZS->(MsUnlock())
	  		lExclui := .T.
	  	Endif
	 Endif
	 
Next nX
If lExclui
	aCols := {}
	For nR := 1 To Len(_aCols)             
		If _aCols[nR, nPosSep] == 'X'
			aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
			_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14]})
		Endif
	Next nR
	If Len(aCols) > 0
		u_FRTGrv(2,aHeader,aCols,'SEPARA',aCols[1,nPosRom])
	Endif
Endif

If lGrava
	MsgAlert("Gravação efetuada com sucesso.")
Endif

ODlg1:End()
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
Static Function SUBCPO(nTp)
Local oDlg
Local cConteudo := ""
Local nPosis  := oGet:oBrowse:nColPos
Local cVarAtu := ReadVar()


If nTp = 1
	If AllTrim(aHeader[nPosis,2]) == 'ZZS_SEPOK'
		For nR := 1 To Len(aCols)
			aCols[nR,nPosis] 	:= 'S'
		Next nR
	Else 
		MsgInfo("Alteração não permitina nesta coluna.")
	Endif
Endif
If nTp = 2
	If AllTrim(aHeader[nPosis,2]) == 'ZZS_SEPOK'
		For nR := 1 To Len(aCols)
			aCols[nR,nPosis] 	:= ' '
		Next nR
	Else 
		MsgInfo("Alteração não permitina nesta coluna.")
	Endif
Endif

Return Nil  


Static Function CalCarga()
Local _aArea	:= GetArea()
Local nTotGer	:= 0
Local nTotVer	:= 0
Local _nR
                                                                                         
For _nR := 1 to Len(aCols)
	If aCols[_nR,nPosTNf] <> 0 .And. aCols[_nR, nPosSep] <> 'X'
		nTotGer	+= NoRound(aCols[_nR,nPosTNf])
	Endif
Next _nR

For _nR := 1 to Len(aCols) 
	If aCols[_nR,nPosTNf] <> 0 .and. aCols[_nR, nPosSep] <> 'X'
		aCols[_nR,nPosVal] := ((_nFrtFech * aCols[_nR,nPosTNf])/nTotGer) // ((Valor Total do Frete * Valor da Nota)/ Valor de todas as notas)
	Endif
	If aCols[_nR, nPosSep] == 'X'
		aCols[_nR,nPosVal] := 0
	Endif
	aCols[_nR,nPosCalc]	:= "6"
Next _nR
For _nR := 1 to Len(aCols) 
	If aCols[_nR, nPosSep] <> 'X'
		nTotVer	+= aCols[_nR,nPosVal]
	Endif
Next _nR 

Do Case 
	Case nTotVer >  _nFrtFech
		aCols[Len(aCols),nPosVal] := ((aCols[Len(aCols),nPosVal])-(nTotVer-_nFrtFech))
	Case _nFrtFech > nTotVer
		aCols[Len(aCols),nPosVal] := ((aCols[Len(aCols),nPosVal])+(_nFrtFech-nTotVer))	
End Case

Return