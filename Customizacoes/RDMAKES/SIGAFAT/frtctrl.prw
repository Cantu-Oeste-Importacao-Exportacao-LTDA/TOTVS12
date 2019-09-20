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

User Function FRTCTRL()
Local aArea := GetArea()
Private cCadastro := "Fretes"
Private aCores := {}

Private aRotina := { {"Pesquisar"  		,"AxPesqui" 				,0 ,1},;
                     {"Visualizar" 		,"U_MntCarga('ZZS',,1)" 	,0 ,2},;
                     {"Montar Carga" 	,"U_MntCarga('ZZS',,3)" 	,0 ,3},;
                     {"Excluir"    		,"U_MntCarga('ZZS',,2)" 	,0 ,4}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())	

mBrowse( 6,1,22,75,"ZZS")

RestArea(aArea)

Return
/*
#############################################################################
### Manutenção da tabela de Fretes x Transportadora                       ###
#############################################################################
*/
User Function FRTTAB()
Private cUf	:= Space(02)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ZZT->(DbSelectArea("ZZT"))
AxCadastro("ZZT")
Return Nil

/*
#############################################################################
### Manutenção da tabela de Fretes x Origem x Destino                     ###
#############################################################################
*/
User Function FRTKM()
Private cUf	:= Space(02)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ZZU->(DbSelectArea("ZZU"))
AxCadastro("ZZU")

Return Nil

/*
#############################################################################
###// 1 - Tela para montagem do romaneio de carga.                        ###
#############################################################################
*/
User Function MntCarga(cAlias, nReg, nOpc)
Local 	aArea := GetArea()
Local 	aButtons  := {}//{ { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2	
Private aHeader := {}
Private aCOLS := {}
Private aColsBKP	:= {}
Private aREG := {}
Private oDlg1
Private oDlg
Private oGet
Private cAlias		:= "ZZS" 
Private cMunOri		:= Space(05)
Private cMunDes		:= Space(05)
Private cUf			:= Space(02)
Private lDel		:= .T.
Private	cOrigem		:= Space(05)
Private _cTpCarga 	:= ""
Private _cTpFin 	:= ""
Private _nFrtFech	:= 0
Private _nTotFre	:= 0
Private _cPedKm		:= ""
Public _cEmpGrp	:= {}
nOpca	:= 2
aEmps	:= {}

_cEmpAtu	:= SM0->(GetArea())
SM0->(DbSelectArea("SM0"))
SM0->(DbSetOrder(1))
SM0->(DbGotop()) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While !SM0->(Eof())
	aAdd(_cEmpGrp,{SM0->M0_CGC})
	SM0->(DbSkip())
End
SM0->(RestArea(_cEmpAtu))
// Monta o aHeader
If nOpc = 3 // Inclusão
	u_WFCalcImp()
	cOrigem	:= Space(05)
	cNMunOri := Space(30)
	cNMunDes := Space(30)
	_cTpCarga := "Fracionada"
	_cTpFin := "Sim"
	_aTpFin	:= {"Sim","Não"}
	_aItens	:= {"Fracionada","Fechada"}
	@ 100, 100 To 320, 650 Dialog oDlg Title "Selecione o local de origem."

	@ 015,010 Say "Tipo Carga :"
	@ 015,060 COMBOBOX _cTpCarga ITEMS _aItens Size 040,10
//	@ 015,100 Say "Valor Frete :"
//	@ 015,140 Get _nFrtFech Picture "@E 999,999.99" When ValidCarga() Size 060,10

	@ 030,010 Say "Estado Origem :"
	@ 030,060 Get cUf Size 015,10 When ValUfOri() F3 "12"

	@ 045,010 Say "Municipio Origem :"
	@ 045,060 Get cMunOri Size 040,10 When ValMunOri() F3 "CC2GER"
	@ 045,110 Get cNMunOri Size 100,10 When .f.

	@ 060,010 Say "Estado Destino :"
	@ 060,060 Get cUf Size 015,10 When ValUfDes() F3 "12"

	@ 075,010 Say "Municipio Destino :"
	@ 075,060 Get cMunDes Size 040,10 When ValMunDes() F3 "CC2GER"
	@ 075,110 Get cNMunDes Size 100,10 When .f.
	
	@ 090,010 Say "Gera Financeiro:"
	@ 090,060 COMBOBOX _cTpFin ITEMS _aTpFin Size 040,10
	
	// Carga Fechada ou Fracionada
	// Gera financeiro ou não.
	Activate Dialog oDlg Center ON INIT ; 
	EnChoiceBar(oDlg,{||nOpca:=1,oDlg:End()} , {||nOpca:=2,oDlg:End()})  CENTER 
	If nOpca = 2
		Return
	Else 
		If _cTpCarga == "Fracionada"
			CC2->(DbSelectArea("CC2"))
			CC2->(DbSetOrder(1))
			CC2->(DbGotop())
			If !CC2->(DbSeek(xFilial("CC2")+cUf+cMunOri))
 				MsgAlert("Municipio invalido.")
				Return
			Endif
		Endif
	Endif
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If AllTrim(SX3->X3_CAMPO) $ "ZZS_SEL/ZZS_EMPRESA/ZZS_NOMEMP/ZZS_NOMFIL/ZZS_FILORI/ZZS_PEDIDO/ZZS_CLIENTE/ZZS_LOJACL/ZZS_NOMCLI/ZZS_UFCLI/ZZS_MUN/ZZS_CODTRA/ZZS_TRANSP/ZZS_CALCFR/ZZS_VLRFIN/ZZS_TPFRET/ZZS_VALFRE/ZZS_TOTNF/ZZS_OBS/ZZS_GERDUP"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif
		Endif
		SX3->(DbSkip())
	End 
ElseIf nOpc = 2 // Exclusão
	lDel	:= .F.
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If AllTrim(SX3->X3_CAMPO) $ "ZZS_SEL/ZZS_EMPRESA/ZZS_NOMEMP/ZZS_NOMFIL/ZZS_FILORI/ZZS_NUMROM/ZZS_PEDIDO/ZZS_CLIENTE/ZZS_LOJACL/ZZS_NOMCLI/ZZS_UFCLI/ZZS_MUN/ZZS_CODTRA/ZZS_TRANSP/ZZS_CALCFR/ZZS_VLRFIN/ZZS_TPFRET/ZZS_VALFRE/ZZS_TOTNF/ZZS_OBS"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif
		Endif
		SX3->(DbSkip())
	End 
ElseIf nOpc = 1 // Visualização 
	lDel	:= .F.
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( cAlias )
	While !EOF() .And. X3_ARQUIVO == cAlias
		If AllTrim(SX3->X3_CAMPO) $ "ZZS_SEL/ZZS_EMPRESA/ZZS_FILORI/ZZS_NOMEMP/ZZS_NOMFIL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_CLIENTE/ZZS_LOJACL/ZZS_NOMCLI/ZZS_UFCLI/ZZS_MUN/ZZS_CODTRA/ZZS_TRANSP/ZZS_CALCFR/ZZS_VLRFIN/ZZS_TPFRET/ZZS_VALFRE/ZZS_TOTNF/ZZS_OBS"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif
		Endif
		SX3->(DbSkip())
	End 
Else
	Return
Endif
nPosSel		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_SEL"}) // Posição codigo da empresa
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
nPosNCli	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMCLI"})   // Posição Nome do Cliente
nPosUfC		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_UFCLI"})   // Posição UF do Cliente 
nPosMunC	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_MUN"})   // Posição Municipio do Cliente 
nPosObs		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_OBS"})   // Posição OBSERVAÇÃO 
nPosDup		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_GERDUP"})   // Posição Financeiro

If nOpc = 3
	SetKey(VK_F6,{||U_BackFil()})
	SetKey(VK_F7,{||U_ORDENA()})
	SetKey(VK_F8,{||U_FILCPO(1)})
	SetKey(VK_F9,{||U_FILCPO(2)}) 
	SetKey(VK_F10,{||U_SUBCPO()})

	//{{"30","01","10"},{"31","01","07"}}
	cEmps := SuperGetMv("MV_X_EMPCMP", ,"{}")//GetMV("MV_X_EMPCMP")
	aEmps := &cEmps  // Transforma a string em array multidimensional
	cSql := "("
	If Len(aEmps) = 0
		MsgInfo("Parametro MV_X_EMPCMP não configurado. Verifique")
		Return
	Endif
	for i := 1 to len(aEmps)
		
		cSql += "SELECT DISTINCT C9.C9_PEDIDO, '"+AllTrim(aEmps[i,1])+"' C9_EMPRESA ,C9.C9_FILIAL, "
		cSql += "C9.C9_CLIENTE, C9.C9_LOJA, Sum(C9.C9_X_VLTOT) AS C9_X_VLTOT, C5.C5_TRANSP, C5.C5_TPFRETE, "
		cSql += "(CASE "
		cSql += "	WHEN C5.C5_TRANSP <> '      ' THEN "
		cSql += "		(SELECT A4.A4_NOME FROM "+"SA4CMP"+" A4 "+"WHERE A4.D_E_L_E_T_ <> '*' AND A4.A4_COD = C5.C5_TRANSP) "
		cSql += "	WHEN C5.C5_TRANSP = '      ' THEN "
		cSql += "       'NAO SELECIONADA' "
		cSql += "END) A4_NOME,	"
		cSql += "A1.A1_NOME, A1.A1_EST, A1.A1_MUN	"		
		cSql += "FROM "+"SC9"+AllTrim(aEmps[i,1])+"0"+" C9, " + "SC5"+AllTrim(aEmps[i,1])+"0"+" C5, SA1CMP A1 "
		cSql += "WHERE C9.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
		cSql += "AND A1.A1_COD = C9.C9_CLIENTE AND A1.A1_LOJA = C9.C9_LOJA "
//		If _cTpCarga <> 'Fracionada'
//			cSql += "AND A1.A1_EST = '"+cUf+"' AND A1.A1_COD_MUN = '"+cMunDes+"' AND A1.A1_FILIAL = '  ' "
//		Endif
		cSql += "AND C9.C9_NFISCAL = '  '"
		cSql += "AND C9.C9_FILIAL BETWEEN '" + aEmps[i, 2]+ "' AND '" + aEmps[i, 3]+ "' " 
		// Validar se CIF=Cobra Frete se FOB=Não cobra frete
		If _cTpFin == "Sim"
			cSql += "AND C5.C5_TPFRETE = 'C' "
		Else
			cSql += "AND C5.C5_TPFRETE = 'F' "		
		Endif
		cSql += "AND C5.C5_FILIAL = C9.C9_FILIAL AND C5.C5_NUM = C9.C9_PEDIDO "    	
		cSql += "AND C5.C5_CLIENTE = C9.C9_CLIENTE AND C5.C5_LOJACLI = C9.C9_LOJA "
		cSql += "AND C9.C9_BLEST = '  ' AND C9.C9_BLCRED = '  ' AND C9.C9_X_CARGA = '         ' "
		cSql += "AND (SELECT COUNT(BC9.C9_PEDIDO) PEDIDOS "
			
		cSql += "FROM SC9"+AllTrim(aEmps[i,1])+"0"+" BC9 "
		cSql += "WHERE BC9.D_E_L_E_T_ <> '*' AND BC9.C9_FILIAL =  C9.C9_FILIAL "
		cSql += "AND BC9.C9_PEDIDO = C9.C9_PEDIDO "
		cSql += "AND (BC9.C9_BLEST <> '  ' OR BC9.C9_BLCRED <> '  ')) = 0 "		
		
		cSql += "GROUP BY C9.C9_PEDIDO, C9.C9_FILIAL, C9.C9_CLIENTE, C9.C9_LOJA, C5.C5_TRANSP, C5.C5_TPFRETE, A1.A1_NOME, A1.A1_EST, A1.A1_MUN "
		
		if i != len(aEmps)
			cSql += " UNION ALL "
		Else
			cSql += " ) ORDER BY C9_EMPRESA, C9_FILIAL, C9_PEDIDO, C9_CLIENTE "
		EndIf
	Next
	MemoWrite("c:\FRTTST.txt",cSql)				
	TCQUERY cSql NEW ALIAS "TMPSC9"
	
	   
	TMPSC9->(dbSelectArea("TMPSC9"))
	TMPSC9->(dbGoTop())
Endif

// Monta o ACols conforme os dados
If (nOpc = 3) // Inclusão
	While !TMPSC9->(EOF() )
			aAdd( aREG, TMPSC9->( RecNo() ) )
			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )	
			aCols[Len(aCols),nPosSel]	:= " "
			aCols[Len(aCols),nPosEmp]	:= TMPSC9->C9_EMPRESA 
			aCols[Len(aCols),nPosFil]	:= TMPSC9->C9_FILIAL  
			_cEmpAtu	:= SM0->(GetArea())
			SM0->(DbSelectArea("SM0"))
			SM0->(DbSetOrder(1))
			SM0->(DbGotop())
			If SM0->(DbSeek(TMPSC9->C9_EMPRESA+TMPSC9->C9_FILIAL))
				aCols[Len(aCols),nPNEmp]	:= SM0->M0_NOME
 				aCols[Len(aCols),nPNFil]	:= SM0->M0_FILIAL
			Endif
			SM0->(RestArea(_cEmpAtu))
			
			aCols[Len(aCols),nPosNCli]	:= TMPSC9->A1_NOME
			aCols[Len(aCols),nPosUfC]	:= TMPSC9->A1_EST
			aCols[Len(aCols),nPosMunC]	:= TMPSC9->A1_MUN			
//			aCols[Len(aCols),nPosRom]	:= "  " Gerado automaticamente após confirmação
			aCols[Len(aCols),nPosPed]	:= TMPSC9->C9_PEDIDO
			aCols[Len(aCols),nPosCli]	:= TMPSC9->C9_CLIENTE		
			aCols[Len(aCols),nPosLoj]	:= TMPSC9->C9_LOJA
			aCols[Len(aCols),nPosCTr]	:= TMPSC9->C5_TRANSP
			aCols[Len(aCols),nPosNTr]	:= TMPSC9->A4_NOME
//			aCols[Len(aCols),nPosBas]	:= 0
			aCols[Len(aCols),nPosFin]	:= 0 
			aCols[Len(aCols),nPosVal]	:= 0	                                                                                         
			aCols[Len(aCols),nPosCalc]	:= "1"
			aCols[Len(aCols),nPosCF]	:= TMPSC9->C5_TPFRETE
			aCols[Len(aCols),nPosDup]	:= SubStr(_cTpFin,1,1)
			// Validar se já existe total da nota no SC9
			aCols[Len(aCols),nPosTNf]	:= TMPSC9->C9_X_VLTOT//u_CalcImpos(TMPSC9->C9_EMPRESA,TMPSC9->C9_FILIAL,TMPSC9->C9_PEDIDO)		
			If _cTpCarga == "Fracionada"
				CalcFrt(TMPSC9->C9_EMPRESA,TMPSC9->C9_FILIAL,TMPSC9->C5_TRANSP,TMPSC9->C9_PEDIDO,Len(aCols)) // Calcular valor do frete.
			Else
				CalcFrt(TMPSC9->C9_EMPRESA,TMPSC9->C9_FILIAL,TMPSC9->C5_TRANSP,TMPSC9->C9_PEDIDO,Len(aCols)) // Calcular valor do frete.
				aCols[Len(aCols),nPosCalc]	:= "6"
			Endif
			
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		TMPSC9->(dbSkip())
	End	
	If _cTpCarga <> "Fracionada"
		CalCarga() // Calcular Carga Fechada
	Endif
ElseIf (nOpc = 2) // Exclusão
	SetKey(VK_F7,{||""})
	SetKey(VK_F8,{||""})
	SetKey(VK_F9,{||""}) 
	SetKey(VK_F10,{||""})
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql := "SELECT ZZS.* FROM ZZSCMP ZZS "
	cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZS.ZZS_NUMROM = '"+ZZS->ZZS_NUMROM+"' "
	TCQUERY cSql NEW ALIAS "TMPZZS"
	TMPZZS->(dbSelectArea("TMPZZS"))
	TMPZZS->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	While !TMPZZS->(Eof())
		aAdd( aREG, TMPZZS->( RecNo() ) )
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		aCols[Len(aCols),nPosEmp]	:= TMPZZS->ZZS_EMPRESA
		aCols[Len(aCols),nPosFil]	:= TMPZZS->ZZS_FILORI
		aCols[Len(aCols),nPNEmp]	:= TMPZZS->ZZS_NOMEMP
		aCols[Len(aCols),nPNFil]	:= TMPZZS->ZZS_NOMFIL		
		aCols[Len(aCols),nPosRom]	:= TMPZZS->ZZS_NUMROM
		aCols[Len(aCols),nPosPed]	:= TMPZZS->ZZS_PEDIDO
		aCols[Len(aCols),nPosCli]	:= TMPZZS->ZZS_CLIENTE		
		aCols[Len(aCols),nPosLoj]	:= TMPZZS->ZZS_LOJACL
		aCols[Len(aCols),nPosCTr]	:= TMPZZS->ZZS_CODTRA
		aCols[Len(aCols),nPosNTr]	:= TMPZZS->ZZS_TRANSP
		aCols[Len(aCols),nPosNCli]	:= TMPZZS->ZZS_NOMCLI
		aCols[Len(aCols),nPosUfC]	:= TMPZZS->ZZS_UFCLI
		aCols[Len(aCols),nPosMunC]	:= TMPZZS->ZZS_MUN						
		aCols[Len(aCols),nPosFin]	:= TMPZZS->ZZS_VLRFIN
		aCols[Len(aCols),nPosVal]	:= TMPZZS->ZZS_VALFRE
		aCols[Len(aCols),nPosCalc]	:= TMPZZS->ZZS_CALCFR
		aCols[Len(aCols),nPosCF]	:= TMPZZS->ZZS_TPFRET			
		aCols[Len(aCols),nPosTNf]	:= TMPZZS->ZZS_TOTNF
		aCols[Len(aCols),nPosObs]	:= TMPZZS->ZZS_OBS
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		If TMPZZS->ZZS_VLRFIN > 0
			_nTotFre += TMPZZS->ZZS_VLRFIN
		Else
			_nTotFre += TMPZZS->ZZS_VALFRE		
		Endif
		If TMPZZS->ZZS_NFOK == 'S'
			_aAreaZZS	:= TMPZZS->(GetArea())
			cSql := "SELECT F2.F2_DOC "
			cSql += "FROM SF2"+TMPZZS->ZZS_EMPRESA+"0"+" F2 "
			cSql += "WHERE F2.D_E_L_E_T_ <> '*' "
			cSql += "AND F2.F2_FILIAL = '"+TMPZZS->ZZS_FILORI+"' "
			cSql += "AND F2.F2_CLIENT = '"+TMPZZS->ZZS_CLIENT+"' AND F2.F2_LOJA = '"+TMPZZS->ZZS_LOJACL+"' "
			cSql += "AND F2.F2_DOC = '"+TMPZZS->ZZS_NFSAI+"' AND F2.F2_SERIE = '"+TMPZZS->ZZS_SERSAI+"' "
			TCQUERY cSql NEW ALIAS "TMPSF2"
//			MemoWrite("c:\boletos.txt",cSql)				
			TMPSF2->(dbSelectArea("TMPSF2"))
			TMPSF2->(dbGoTop())			
			If !TMPSF2->(Eof())	
				MsgAlert("Carga não pode ser alterada pois já possui pedido faturado.")
				TMPZZS->(DbSelectArea("TMPZZS"))
				TMPZZS->(DbCloseArea("TMPZZS"))
				TMPSF2->(DbSelectArea("TMPSF2"))
				TMPSF2->(DbCloseArea("TMPSF2"))							
				Return
			Endif			
			TMPSF2->(DbSelectArea("TMPSF2"))
			TMPSF2->(DbCloseArea("TMPSF2"))
			RestArea(_aAreaZZS)
		Endif
		TMPZZS->(DbSelectArea("TMPZZS"))
		TMPZZS->(dbSkip())
	End
ElseIf (nOpc = 1) // Visualização
	SetKey(VK_F7,{||""})
	SetKey(VK_F8,{||""})
	SetKey(VK_F9,{||""}) 
	SetKey(VK_F10,{||""})
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql := "SELECT ZZS.* FROM ZZSCMP ZZS "
	cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZS.ZZS_NUMROM = '"+ZZS->ZZS_NUMROM+"' "
	TCQUERY cSql NEW ALIAS "TMPZZS"
	TMPZZS->(dbSelectArea("TMPZZS"))
	TMPZZS->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	While !TMPZZS->(Eof())
		aAdd( aREG, TMPZZS->( RecNo() ) )
		aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
		aCols[Len(aCols),nPosEmp]	:= TMPZZS->ZZS_EMPRESA
		aCols[Len(aCols),nPosFil]	:= TMPZZS->ZZS_FILORI
		aCols[Len(aCols),nPNEmp]	:= TMPZZS->ZZS_NOMEMP
		aCols[Len(aCols),nPNFil]	:= TMPZZS->ZZS_NOMFIL		
		aCols[Len(aCols),nPosRom]	:= TMPZZS->ZZS_NUMROM
		aCols[Len(aCols),nPosPed]	:= TMPZZS->ZZS_PEDIDO
		aCols[Len(aCols),nPosCli]	:= TMPZZS->ZZS_CLIENTE		
		aCols[Len(aCols),nPosLoj]	:= TMPZZS->ZZS_LOJACL
		aCols[Len(aCols),nPosCTr]	:= TMPZZS->ZZS_CODTRA
		aCols[Len(aCols),nPosNTr]	:= TMPZZS->ZZS_TRANSP
		aCols[Len(aCols),nPosNCli]	:= TMPZZS->ZZS_NOMCLI
		aCols[Len(aCols),nPosUfC]	:= TMPZZS->ZZS_UFCLI
		aCols[Len(aCols),nPosMunC]	:= TMPZZS->ZZS_MUN						
		aCols[Len(aCols),nPosFin]	:= TMPZZS->ZZS_VLRFIN
		aCols[Len(aCols),nPosVal]	:= TMPZZS->ZZS_VALFRE
		aCols[Len(aCols),nPosCalc]	:= TMPZZS->ZZS_CALCFR
		aCols[Len(aCols),nPosCF]	:= TMPZZS->ZZS_TPFRET			
		aCols[Len(aCols),nPosTNf]	:= TMPZZS->ZZS_TOTNF
		aCols[Len(aCols),nPosObs]	:= TMPZZS->ZZS_OBS 
		If TMPZZS->ZZS_VLRFIN > 0
			_nTotFre += TMPZZS->ZZS_VLRFIN
		Else
			_nTotFre += TMPZZS->ZZS_VALFRE		
		Endif
		aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
		TMPZZS->(DbSelectArea("TMPZZS"))
		TMPZZS->(dbSkip())
	End
EndIf


_nPasseio 		:= 0
ZZS->(DbSelectArea("ZZS"))
DEFINE MSDIALOG oDlg1 TITLE cCadastro From 0,0 To 515, 1275 PIXEL OF oMainWnd

@ 020,003 Say OemToAnsi("Valor Frete :")
@ 020,035 Get _nTotFre Picture "@E 9,999,999.99" Size 50,10 When .f.
/*
@ 020,103 Say OemToAnsi("Passeio:")
@ 020,130 Get _nPasseio Picture "@E 999,999" Size 50,10 When .f.

@ 020,203 Say OemToAnsi("Total:")
@ 020,230 Get 0 Picture "@E 999,999" Size 50,10 When .f.
*/	

If nOpc = 3
	@ 020,400 Say OemToAnsi("F6-Volta Filtro        F7-Ordenar        F8-Filtrar        F9-Remover Excluidos        F10-Atualizar Coluna")
Endif
//                                                       del 
oGet := MSGetDados():New(035,1,255,640,nOpc, , .F., , lDel,{"ZZS_SEL","ZZS_TPFRET","ZZS_VLRFIN"}, , .F.,256)
oGet:oBrowse:nColPos
oGet:oBrowse:Refresh()
//oGet := MSGetDados():New(035,1,355,640,nOpc, , .T., "", .T.,{"ZZ1_BOLETO","ZZ1_CANHOT",;
//"ZZ1_PROCES","ZZ1_HORACA","ZZ1_ORIGEM ","ZZ1_UF","ZZ1_DESTIN","ZZ1_TRANSP","ZZ1_PLACA","ZZ1_VLRFRT"}, , .T., 256)

//ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| GrvDados(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() },,aButtons)
ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| U_ValFRT(nOpc,aHeader,aCols,'INCLUI')}, {|| oDlg1:End() },,aButtons)
If Select("TMPSC9") <> 0
	TMPSC9->(DbCloseArea("TMPSC9"))
Endif
If Select("TMPZZS") <> 0
	TMPZZS->(DbCloseArea("TMPZZS"))
Endif

/********************************************************/
// Função para gravar os dados na tabela, avaliando exclusão e alteração
/********************************************************/
Static Function Exclui()
Local aArea := GetArea()
Local nI := 0
Local nX := 0
Local cItem := "00"

// Exclusão
if (nOpc == 5)
  For nI := 1 To Len( aCOLS )
		dbGoTo(aREG[nI])
		RecLock(cAlias,.F.)
		dbDelete()
		MsUnLock()
	Next nI
  Return
EndIf


RestArea( aArea )
Return

/*
#############################################################################
### Efetua o filtro dos dados com base no campo posicionado               ###
#############################################################################
*/
User Function FILCPO(_nOpc)
Local _aCols  := aCols
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos
Local _nPFre		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
aColsBKP	:= aCols
_nTotFre	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

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
				_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21]})
			_nTotFre += _aCols[nR,_nPFre]			
			Endif
		Next nR
	Endif
Else
	For nR := 1 To Len(_aCols)             
		If !_aCols[nR,21]
			aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
			_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
			_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21]})
		_nTotFre += _aCols[nR,_nPFre]			
		Endif
	Next nR
endif
dlgRefresh(oDlg1)
oGet:oBrowse:Refresh()

If _cTpCarga <> "Fracionada"
	CalCarga()
Endif
n:= 1
Return nil

USER Function Ordena()
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos 
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (nPosis > 0)
	ASort(aCols,,,{ |x,y| x[nPosis] < y[nPosis]})
EndIf     

Return Nil

/*
#############################################################################
### Efetua a substituição dos dados de toda a coluna.                     ###
#############################################################################
*/
User Function SUBCPO()
Local oDlg
Local cConteudo := ""
Local nPosis  := oGet:oBrowse:nColPos
Local cVarAtu := ReadVar()
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If AllTrim(aHeader[nPosis,2]) == 'ZZS_CODTRA'
	cConteudo	:= Space(06)
	@ 100, 100 To 180, 550 Dialog oDlg Title "Selecione a transportadora."
	@ 025,010 Get cConteudo Size 200,10 When .T. F3 "SA4"
	Activate Dialog oDlg Center ON INIT ; 
	EnChoiceBar(oDlg,{||nOpca:=1,oDlg:End()} , {||nOpca:=2,oDlg:End()})  CENTER
    If cConteudo <> ""
		SA4->(DbSelectArea("SA4"))
		SA4->(DbSetOrder(1))
		SA4->(DbGotop())
		If SA4->(DbSeek(xFilial("SA4")+cConteudo))
//			Alteração Transportadora		
			If MsgBox("Atualiza toda a coluna?", "Atenção", "YESNO")
				_nTotFre := 0
				For nR := 1 To Len(aCols)
					aCols[nR,nPosis] 	:= Upper(cConteudo)
					aCols[nR,nPosNTr]   := SA4->A4_NOME
					CalcFrt(aCols[nR,nPosEmp],aCols[nR,nPosFil],aCols[nR,nPosis],aCols[nR,nPosPed],nR)
				Next nR
			Else
				_nTotFre := 0
				aCols[n,nPosis] 	:= Upper(cConteudo)
				aCols[n,nPosNTr]   	:= SA4->A4_NOME
				CalcFrt(aCols[n,nPosEmp],aCols[n,nPosFil],aCols[n,nPosis],aCols[n,nPosPed],n)
			Endif
		Else
			MsgAlert("Transprotadora não cadastrada.")
		Endif
	Endif
ElseIf AllTrim(aHeader[nPosis,2]) == "ZZS_VLRFIN"
	cConteudo	:= 0
	@ 100, 100 To 180, 550 Dialog oDlg Title "Digite o valor do frete."
	@ 025,010 Get cConteudo Picture "@E 9,999,999,999.99"  Size 200,10 When .T.
	Activate Dialog oDlg Center ON INIT ; 
	EnChoiceBar(oDlg,{||nOpca:=1,oDlg:End()} , {||nOpca:=2,oDlg:End()})  CENTER	
	If cConteudo > 0
		For nR := 1 To Len(aCols)
			aCols[nR,nPosis] 	:= cConteudo
		Next nR
	Else
		MsgAlert("Valor inválido.")	
	Endif
ElseIf AllTrim(aHeader[nPosis,2]) == "ZZS_SEL"
	cConteudo	:= Space(01)
	@ 100,100 To 180, 550 Dialog oDlg Title "Dite o conteudo."
	@ 025,010 Get cConteudo Size 30,10 When .T. 
	Activate Dialog oDlg Center ON INIT ; 
	EnChoiceBar(oDlg,{||nOpca:=1,oDlg:End()} , {||nOpca:=2,oDlg:End()})  CENTER
	For nR := 1 To Len(aCols)
		aCols[nR,nPosSel] 	:= Upper(cConteudo)
	Next nR
Else 
	MsgInfo("Alteração não permitina nesta coluna.")
Endif


Return Nil

User Function ValFRT(nOpc,aHeader,aCols,_cTp)
Local _lOk	:= .T.
Local oDlConf	
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If nOpc = 3
	For nR := 1 To Len(aCols)
		If !aCols[nR,21] .and. aCols[nR,nPosSel] == "S"
			SA4->(DbSelectArea("SA4"))
			SA4->(DbSetOrder(1))
			SA4->(dbSeek(xFilial("SA4")+aCols[nR,nPosCTr]))
			SA2->(DbSelectArea("SA2"))
			SA2->(dbSetOrder(3))
			If Empty(SA4->A4_CGC) .Or. SA2->(!dbSeek(xFilial("SA2")+SA4->A4_CGC))
				Alert("Não foi encontrado fornecedor com o mesmo cnpj do transportador " + AllTrim(SA4->A4_NOME) + ". Não será possível gerar o romaneio.")
				_lOk	:= .F.	
			Endif
		Endif
	Next nR
Endif
For _nX	:= 1 To Len(aCols)  // Aqui validar transportadora da empresa.
	If aCols[_nX,nPosVal]+aCols[_nX,nPosFin] = 0 .AND. !aCols[_nX,21] .and. aCols[_nX,nPosSel] == "S" .and. _cTpFin == "Sim"
		SA4->(DbSelectArea("SA4"))
		SA4->(DbSetOrder(1))
		SA4->(dbSeek(xFilial("SA4")+aCols[_nX,nPosCTr]))
		SA2->(DbSelectArea("SA2"))
		SA2->(dbSetOrder(3))
		SA2->(dbSeek(xFilial("SA2")+SA4->A4_CGC))		
	   	nPosicao  := aScan(_cEmpGrp,{|_x| SA2->A2_CGC == _x[1]})
		If nPosicao = 0
	 		Alert("Valor do frete não preenchido para o pedido "+aCols[_nX,nPosPed]+". Verifique.")
			_lOk	:= .F.
		EndIf			

	Endif
Next _nX
If _lOk .AND. nOpc = 3
	nOpca := 3
	_nBase	:= 0
	_nTot	:= 0
	_nTComb	:= 0
	_nTnf	:= 0
	For _nX := 1 To Len (aCols)
		If !aCols[_nX,21] .and. aCols[_nX,nPosSel] == "S"	
//			_nBase	+= aCols[_nX,nPosBas]
			_nTot	+= aCols[_nX,nPosVal]
			_nTComb	+= aCols[_nX,nPosFin]
			_nTnf	+= aCols[_nX,nPosTNf]
		Endif
	Next _nX
  	@ 100, 100 To 320, 570 Dialog oDlConf Title "Valores Frete."
	// nPosBas		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_BASEFR"})  // Base de calculo do frete
	// nPosVal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
	// nPosFin		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // Posição valor do frete combinado (frete final)
	// nPosTNf		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posição Valor total nota fiscal 
	@ 015,010 Say "Verifique se os valores estão corretos para os pedidos selecionados e confirme. "
	@ 030,010 Say "Base de calculo: " 
	@ 030,130 Get _nBase Picture "@E 99,999,999.99" Size 100,10 When .f.
	@ 045,010 Say "Total de frete calculado: "
	@ 045,130 Get _nTot Picture "@E 99,999,999.99" Size 100,10 When .f. 
	@ 060,010 Say "Total de frete combinado: "	
	@ 060,130 Get _nTComb Picture "@E 99,999,999.99" Size 100,10 When .f. 
	@ 075,010 Say "Total notas fiscais: "
	@ 075,130 Get _nTnf Picture "@E 99,999,999.99" Size 100,10 When .f.

//	@ 045,060 Get cMunOri Size 040,10 When ValMunOri() F3 "CC2GER"
//	@ 045,110 Get cNMunOri Size 100,10 When .f.

	Activate Dialog oDlConf Center ON INIT ; 
	EnChoiceBar(oDlConf,{||nOpca:=1,oDlConf:End()} , {||nOpca:=2,oDlConf:End()})  CENTER 
	If nOpca <> 1
		_lOk	:= .F.
	Endif
Endif
If _lOk
	u_FRTGrv(nOpc,aHeader,aCols,_cTp)  
	ODlg1:End()
Endif

Return

/*
#############################################################################
### Função utilizada para o calculo do valor do frete.                    ###
#############################################################################
*/

Static Function CalcFrt(_cEmp,_cFil,_cTransp,_cPed,_nLin)
Local _aArea	:= GetArea()
Local nBasPes	:= 0
Local nBasKm	:= 0
Local nBasNf	:= 0
/*cSql := "SELECT C9.C9_FILIAL,C9.C9_PEDIDO, C9.C9_QTDLIB, C9.C9_PRODUTO, B1.B1_PESO, ZZT.ZZT_VALMIN, ZZT.ZZT_VALKM,ZZT.ZZT_PERCNF, "
cSql += "ZZT.ZZT_VALCUB, ZZT.ZZT_VALPES, "
cSql += "(SELECT ZZU.ZZU_QTDKM FROM ZZUCMP ZZU WHERE ZZU.D_E_L_E_T_ <> '*' AND ZZU.ZZU_UFORI = '"+cUf+"' "
cSql += "AND ZZU.ZZU_MUNORI = '"+cMunOri+"' AND ZZU.ZZU_UFDEST = SA1.A1_EST AND ZZU.ZZU_MUNDES = SA1.A1_COD_MUN) ZZU_QTDKM "
cSql += "FROM SC9"+AllTrim(_cEmp)+"0"+" C9, "+"SB1CMP B1, "+"ZZT"+AllTrim(_cEmp)+"0"+" ZZT, SA1CMP SA1 "
cSql += "WHERE C9.D_E_L_E_T_ <> '*' AND B1.D_E_L_E_T_ <> '*'  AND ZZT.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' "
cSql += "AND C9.C9_FILIAL = '"+_cFil+"'  "
cSql += "AND SA1.A1_FILIAL = '  ' "
cSql += "AND SA1.A1_COD = C9.C9_CLIENTE AND SA1.A1_LOJA = C9.C9_LOJA "
cSql += "AND B1.B1_COD = C9.C9_PRODUTO "
cSql += "AND C9.C9_PEDIDO = '"+_cPed+"' "
cSql += "AND ZZT.ZZT_TRANSP = '"+_cTransp+"' "
cSql += "ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO"*/
_nFrtFech := 0

cSql := "SELECT C9.C9_FILIAL, C9.C9_PEDIDO, C9.C9_QTDLIB, C9.C9_PRODUTO,   B1.B1_PESO, C9.C9_X_VLTOT, "
cSql += "COALESCE(ZZT1.ZZT_VALMIN, 0) AS ZT_VALMIN1, "
cSql += "COALESCE(ZZT1.ZZT_VALKM, 0) AS ZT_VALKM1, "
cSql += "COALESCE(ZZT1.	ZZT_PERCNF, 0) AS ZT_PERCNF1, "
cSql += "COALESCE(ZZT1.ZZT_VALCUB, 0) AS ZT_VALCUB1, "
cSql += "COALESCE(ZZT1.ZZT_VALPES, 0) AS ZT_VALPES1, "
cSql += "COALESCE(ZZT1.ZZT_VLFECH, 0) AS ZT_VLFECH1, "
    
cSql += "COALESCE(ZZT2.ZZT_VALMIN, 0) AS ZT_VALMIN2, "
cSql += "COALESCE(ZZT2.ZZT_VALKM, 0) AS ZT_VALKM2, "
cSql += "COALESCE(ZZT2.ZZT_PERCNF, 0) AS ZT_PERCNF2, "
cSql += "COALESCE(ZZT2.ZZT_VALCUB, 0) AS ZT_VALCUB2, "
cSql += "COALESCE(ZZT2.ZZT_VALPES, 0) AS ZT_VALPES2, "
cSql += "COALESCE(ZZT2.ZZT_VLFECH, 0) AS ZT_VLFECH2, "
    
cSql += "COALESCE(ZZT3.ZZT_VALMIN, 0) AS ZT_VALMIN3, "
cSql += "COALESCE(ZZT3.ZZT_VALKM, 0) AS ZT_VALKM3, "
cSql += "COALESCE(ZZT3.ZZT_PERCNF, 0) AS ZT_PERCNF3, "
cSql += "COALESCE(ZZT3.ZZT_VALCUB, 0) AS ZT_VALCUB3, "
cSql += "COALESCE(ZZT3.ZZT_VALPES, 0) AS ZT_VALPES3, "
cSql += "COALESCE(ZZT3.ZZT_VLFECH, 0) AS ZT_VLFECH3, "
If _cTpCarga == 'Fracionada'
	cSql += "    ( "
	cSql += "        SELECT "
	cSql += "            ZZU.ZZU_QTDKM "
	cSql += "        FROM "
	cSql += "            ZZUCMP ZZU "
	cSql += "        WHERE "
	cSql += "            ZZU.D_E_L_E_T_ <> '*' "
	cSql += "        AND ZZU.ZZU_UFORI = '"+cUf+"' "
	cSql += "        AND ZZU.ZZU_MUNORI = '"+cMunOri+"' "
	cSql += "       AND ZZU.ZZU_UFDEST = SA1.A1_EST "
	cSql += "        AND ZZU.ZZU_MUNDES = SA1.A1_COD_MUN) ZZU_QTDKM "
Else
	cSql += " 0 AS ZZU_QTDKM 
Endif
cSql += " FROM SC9"+AllTrim(_cEmp)+"0"+" C9 "
cSql += "LEFT JOIN SA1CMP SA1 ON SA1.A1_COD = C9.C9_CLIENTE AND SA1.A1_LOJA = C9.C9_LOJA "
cSql += "LEFT JOIN SB1CMP B1 ON B1_COD = C9.C9_PRODUTO "
cSql += "LEFT JOIN ZZT"+AllTrim(_cEmp)+"0"+" ZZT1 ON ZZT1.ZZT_CODMUN = SA1.A1_COD_MUN AND ZZT1.ZZT_UF = SA1.A1_EST AND ZZT1.D_E_L_E_T_ <> '*' "
cSql += "LEFT JOIN ZZT"+AllTrim(_cEmp)+"0"+" ZZT2 ON "
If _cTpCarga == 'Fracionada'
	cSql += "(ZZT2.ZZT_CODMUN = '"+cMunDes+"' OR ZZT2.ZZT_CODMUN IS NULL) AND (ZZT2.ZZT_UF = SA1.A1_EST OR ZZT2.ZZT_UF IS NULL) AND ZZT2.D_E_L_E_T_ <> '*' "
Else
	cSql += "ZZT2.D_E_L_E_T_ <> '*' "
Endif
cSql += "LEFT JOIN ZZT"+AllTrim(_cEmp)+"0"+" ZZT3 ON "
If _cTpCarga == 'Fracionada'
	cSql += "(ZZT3.ZZT_CODMUN = '"+cMunDes+"' OR ZZT3.ZZT_CODMUN IS NULL AND "
	cSql += " ZZT3.ZZT_UF = '"+cUf+"' OR ZZT3.ZZT_UF IS NULL)AND ZZT3.D_E_L_E_T_ <> '*' "
Else
	cSql += "ZZT3.D_E_L_E_T_ <> '*' "
Endif
cSql += "WHERE "
cSql += "    C9.D_E_L_E_T_ <> '*' "
cSql += "AND B1.D_E_L_E_T_ <> '*' "
cSql += "AND SA1.D_E_L_E_T_ <> '*' "
cSql += "AND C9.C9_FILIAL = '"+_cFil+"' "
cSql += "AND SA1.A1_FILIAL = '  ' "
cSql += "AND C9.C9_PEDIDO = '"+_cPed+"' "
cSql += "AND (ZZT1.ZZT_TRANSP = '"+_cTransp+"' OR ZZT1.ZZT_TRANSP IS NULL) "
cSql += "AND (ZZT2.ZZT_TRANSP = '"+_cTransp+"' OR ZZT2.ZZT_TRANSP IS NULL) "
cSql += "AND (ZZT3.ZZT_TRANSP = '"+_cTransp+"' OR ZZT3.ZZT_TRANSP IS NULL) "
If _cTpCarga <> 'Fracionada'
	cSql += "AND (ZZT1.ZZT_CODMUN = '"+cMunDes+"' OR ZZT1.ZZT_CODMUN IS NULL) "
	cSql += "AND (ZZT2.ZZT_CODMUN = '"+cMunDes+"' OR ZZT2.ZZT_CODMUN IS NULL) "
	cSql += "AND (ZZT3.ZZT_CODMUN = '"+cMunDes+"' OR ZZT3.ZZT_CODMUN IS NULL) "
Endif
cSql += "ORDER BY C9.C9_FILIAL, C9.C9_PEDIDO "
//MemoWrite("c:\fretes06.txt",cSql)				
TCQUERY cSql NEW ALIAS "TMPZZT"
TMPZZT->(dbSelectArea("TMPZZT"))
TMPZZT->(dbGoTop())
If _cTpCarga == 'Fracionada'
	IF !TMPZZT->(Eof())
		While !TMPZZT->(Eof())
			nBasPes	:= 0
			nValPes	:= 0
			
			nValKm	:= 0
			nBasKm	:= 0
	
			nBasNf	:= 0
			nValNf	:= 0
			
			nBasMin	:= 0
			
			
			_nValPES	:= Iif(TMPZZT->ZT_VALPES1 > 0,TMPZZT->ZT_VALPES1,Iif(TMPZZT->ZT_VALPES2 >0,TMPZZT->ZT_VALPES2,TMPZZT->ZT_VALPES3))
			_nValKM     := Iif(TMPZZT->ZT_VALKM1 > 0,TMPZZT->ZT_VALKM1,Iif(TMPZZT->ZT_VALKM2 >0,TMPZZT->ZT_VALKM2,TMPZZT->ZT_VALKM3))
			_nValNf		:= Iif(TMPZZT->ZT_PERCNF1 > 0,TMPZZT->ZT_PERCNF1,Iif(TMPZZT->ZT_PERCNF2 >0,TMPZZT->ZT_PERCNF2,TMPZZT->ZT_PERCNF3))
			nValMin		:= Iif(TMPZZT->ZT_VALMIN1 > 0,TMPZZT->ZT_VALMIN1,Iif(TMPZZT->ZT_VALMIN2 >0,TMPZZT->ZT_VALMIN2,TMPZZT->ZT_VALMIN3))
			
			_cChave	:= TMPZZT->C9_FILIAL+TMPZZT->C9_PEDIDO
			
			While !TMPZZT->(Eof()) .AND. TMPZZT->C9_FILIAL+TMPZZT->C9_PEDIDO == _cChave
				// Calculo por peso.
				nBasPes	+= (TMPZZT->C9_QTDLIB * TMPZZT->B1_PESO)
				nValPes	+= ((TMPZZT->C9_QTDLIB * TMPZZT->B1_PESO)*_nValPES)
				
				
				// Calculo por KM.
				If TMPZZT->C9_PEDIDO $ _cPedKm
					_cPedKm += TMPZZT->C9_PEDIDO+"/"
					nBasKm	+= TMPZZT->ZZU_QTDKM
					nValKm	+= (TMPZZT->ZZU_QTDKM *_nValKM)
				Endif
				
				// Calculo pelo valor da nota fiscal
				nBasNf	+= TMPZZT->C9_X_VLTOT //aCols[_nLin,nPosTNf]
				nValNf	+= ((TMPZZT->C9_X_VLTOT * _nValNf)/100)//((aCols[_nLin,nPosTNf] * _nValNf)/100)
				
				_cChave	:= TMPZZT->C9_FILIAL+TMPZZT->C9_PEDIDO			
				TMPZZT->(DbSkip())	
			End
			Do Case
				Case nValPes > nValKm .and. nValPes > nValNf
			  		If nValpes < nValMin
						aCols[_nLin,nPosVal] 	:= nValMin
						aCols[_nLin,nPosCalc]	:= "4"
						_nTotFre				+= nValMin
			  		Else
						aCols[_nLin,nPosVal] 	:= nValPes
						aCols[_nLin,nPosCalc]	:= "1"
						_nTotFre				+= nValPes
					Endif
				Case nValKm > nValPes .and. nValKm > nValNf
					If nValKm < nValMin
						aCols[_nLin,nPosVal] 	:= nValMin
						aCols[_nLin,nPosCalc]	:= "4"
						_nTotFre				+= nValMin					
					Else
						aCols[_nLin,nPosVal] 	:= nValKm
						aCols[_nLin,nPosCalc]	:= "5"
						_nTotFre				+= nValKm					
					Endif
				Case nValNf > nValPes .and. nValNf > nValKm
					If nValNf < nValMin
						aCols[_nLin,nPosVal] 	:= nValMin
						aCols[_nLin,nPosCalc]	:= "4"
						_nTotFre				+= nValMin					
					Else
						aCols[_nLin,nPosVal] 	:= nValNf
						aCols[_nLin,nPosCalc]	:= "2"
						_nTotFre				+= nValNf
					Endif
			End Case
		End
	Else
	//	aCols[_nLin,nPosBas]	:= 0
		aCols[_nLin,nPosFin]	:= 0 
		aCols[_nLin,nPosVal]	:= 0
		aCols[_nLin,nPosCalc] 	:= " "
	Endif
Else
	_nFrtFech := Iif(TMPZZT->ZT_VLFECH1 > 0,TMPZZT->ZT_VLFECH1,Iif(TMPZZT->ZT_VLFECH2 >0,TMPZZT->ZT_VLFECH2,TMPZZT->ZT_VLFECH3))
Endif
dlgRefresh(oDlg1)
TMPZZT->(DbSelectArea("TMPZZT"))
TMPZZT->(DbCloseArea()) 
RestArea(_aArea)

Return Nil 


Static Function CalCarga()
Local _aArea	:= GetArea()
Local nTotGer	:= 0
Local nTotVer	:= 0
Local _nR
//nPosVal		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
//nPosFin		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRFIN"})  // Posição valor do frete combinado (frete final)
//nPosCF		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TPFRET"})  // Posição Tipo do frete (C=Cif F=Fob)
//nPosTNf		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})   // Posição Valor total nota fiscal 
                                                                                         
If _nFrtFech > 0
	For _nR := 1 to Len(aCols)
		If aCols[_nR,nPosTNf] <> 0
			nTotGer	+= NoRound(aCols[_nR,nPosTNf])
		Endif
	Next _nR
	For _nR := 1 to Len(aCols) 
		If aCols[_nR,nPosTNf] <> 0
			aCols[_nR,nPosVal] := ((_nFrtFech * aCols[_nR,nPosTNf])/nTotGer) // ((Valor Total do Frete * Valor da Nota)/ Valor de todas as notas)
		Endif
		aCols[_nR,nPosCalc]	:= "6"
	Next _nR
	For _nR := 1 to Len(aCols) 
		nTotVer	+= aCols[_nR,nPosVal]
	Next _nR 
	Do Case 
		Case nTotVer >  _nFrtFech
			aCols[Len(aCols),nPosVal] := ((aCols[Len(aCols),nPosVal])-(nTotVer-_nFrtFech))
		Case _nFrtFech > nTotVer
			aCols[Len(aCols),nPosVal] := ((aCols[Len(aCols),nPosVal])+(_nFrtFech-nTotVer))	
	End Case
Else
Endif
_nTotFre	:= nTotVer


Return Nil

Static Function ValidCarga()
Local lRet := .F.
If _cTpCarga <> 'Fracionada'
	lRet := .T.
Else
	_nFrtFech := 0
Endif


Return(lRet)

Static Function ValUfOri()
Local lRet := .F.
If _cTpCarga == 'Fracionada'
	lRet := .T.
Endif

Return(lRet)

Static Function ValMunOri()
Local lRet := .F.
If _cTpCarga == 'Fracionada'
	lRet := .T.
Endif

Return(lRet)

Static Function ValUfDes()
Local lRet := .T.
If _cTpCarga == 'Fracionada'
	lRet := .F.
Endif

Return(lRet)

Static Function ValMunDes()
Local lRet := .T.
If _cTpCarga == 'Fracionada'
	lRet := .F.
Endif

Return(lRet)

// Quando valor do frete for digitado, deve ser incluida uma observação
// para explicar o modivo.
User Function FRTValid()
Local lRet	:= .T.
nOpca	:= 2
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If AllTrim(ReadVar()) == "M->ZZS_VLRFIN"
	If M->ZZS_VLRFIN > 0
		_cObs		:= Space(30)
		@ 100, 100 To 200, 650 Dialog oDlg2 Title "Observação."
		@ 020,010 Say "Observação :"
		@ 020,050 Get _cObs Picture "@!"  Size 100,10
		
		Activate Dialog oDlg2 Center ON INIT ; 
		EnChoiceBar(oDlg2,{||nOpca:=1,oDlg2:End()} , {||nOpca:=2,oDlg2:End()})  CENTER 
		
		If nOpca = 2 
			MsgAlert("Quando frete combidado, deve ser digitada uma observação.")
			M->ZZS_VLRFIN		:= 0
			lRet	:= .F.
		Else
			If !Empty(AllTrim(_cObs))
				aCols[n,nPosObs]	:= _cObs
			Else
				MsgAlert("Quando frete combidado, deve ser digitada uma observação.")
				lRet	:= .F.				
			Endif
		Endif
	Else
		aCols[n,nPosObs]	:= "  "
	Endif
Endif

Return lRet

Static Function Atualiza()
	aCols	:= {}
	If Select("TMPSA6") <> 0
		TMPSA6->(DbCloseArea("TMPSA6"))
	Endif
	cSql := "("
	For nR := 1 To Len(aEmps)
		// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
		cSql += "SELECT '"+AllTrim(aEmps[nR,1])+"' A6_EMP,A6.A6_COD,A6.A6_AGENCIA,A6.A6_NOMEAGE,A6.A6_NUMCON,Sum(A6.A6_X_VLGAR) A6_X_VLGAR, "
		cSql += "Coalesce((SELECT Sum(E1.E1_SALDO) FROM "+"SE1"+AllTrim(aEmps[nR,1])+"0"+" E1 "
		cSql += "WHERE E1.E1_FILIAL = '  ' AND E1.D_E_L_E_T_ <> '*' AND "
		cSql += "E1.E1_SALDO > 0 AND E1.E1_NUMBCO <> ' ' AND "
		cSql += "E1.E1_NUMBOR = ' ' AND E1.E1_PORTADO = A6.A6_COD AND "
		cSql += "E1.E1_EMISSAO BETWEEN '20110101' AND '20111231'),0) E1_SALDO "
		cSql += "FROM "+"SA6"+AllTrim(aEmps[nR,1])+"0"+" A6 "
		cSql += "WHERE A6.D_E_L_E_T_ <> '*' AND A6.A6_X_VLGAR > 0 " 
		cSql += "GROUP BY A6.A6_COD, A6.A6_AGENCIA, A6.A6_NOMEAGE, A6.A6_NUMCON "
		if nR != len(aEmps)
			cSql += " UNION ALL "
		Else
			cSql += " ) "
		EndIf	
	Next nR
	TCQUERY cSql NEW ALIAS "TMPSA6"
	TMPSA6->(dbSelectArea("TMPSA6"))
	TMPSA6->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	If !TMPSA6->(Eof())
		While !TMPSA6->(Eof())

			aAdd( aREG, TMPSA6->( RecNo() ) )
			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			_cEmpAtu	:= SM0->(GetArea())
			SM0->(DbSelectArea("SM0"))
			SM0->(DbSetOrder(1))
			SM0->(DbGotop())
			If SM0->(DbSeek(TMPSA6->A6_EMP))
				aCols[Len(aCols),nPEmp]	:= SM0->M0_NOME
			Endif
			SM0->(RestArea(_cEmpAtu))
			
			aCols[Len(aCols),nPBanco]	:= TMPSA6->A6_COD
			aCols[Len(aCols),nPAgenc]	:= TMPSA6->A6_AGENCIA
			aCols[Len(aCols),nPNome]	:= TMPSA6->A6_NOMEAGE
			aCols[Len(aCols),nPConta]	:= TMPSA6->A6_NUMCON
			aCols[Len(aCols),nPLimit]	:= TMPSA6->A6_X_VLGAR
			aCols[Len(aCols),nPValor] 	:= TMPSA6->E1_SALDO
			aCols[Len(aCols),nPSaldo] 	:= (TMPSA6->A6_X_VLGAR-TMPSA6->E1_SALDO)
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			TMPSA6->(DbSelectArea("TMPSA6"))							
		TMPSA6->(DbSkip())
		End
	Else
		If Select("TMPSA6") <> 0
			TMPSA6->(DbCloseArea("TMPSA6"))
		Endif
//		Alert("Romaneio não encontrado.")
		Return
	Endif
oGet:oBrowse:Refresh()	
Return

User Function BackFil() // Retorna Filtro Anterior

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If Len(aColsBKP) > 1
	aCols	:= aColsBKP
Endif
dlgRefresh(oDlg1)
oGet:oBrowse:Refresh()

n:= 1
Return Nil