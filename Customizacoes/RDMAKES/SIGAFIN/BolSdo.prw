#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ BolSdo   º Autor ³ Adriano Novachaelley Data ³  31/08/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para acompanhamento do saldo das garantias        º±±
±±º          ³ bancarias. Utiliza todos os titulos da SE1 que possuirem   º±±
±±º          ³ boleto emitito, mas que ainda não foram enviados ao Banco  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Dpto Financeiro Cantu                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function BolSdo()
Local 	aArea := GetArea()
Local 	aButtons  := {} //{ { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2	
Private aREG 	:= {}
Private oDlg1
Private oDlg
Private oGet
Private cAlias	:= "SA6" 
Private cMunOri	:= Space(05)
Private cUf	:= Space(02)
Private cCadastro := "Acompanhamento de saldos"
Private lRefresh := .T.
Private aHeader := {}
Private aCols := {}
Private _nGarant := 0
Private _nEmitido	:= 0
Private _nSaldo	:= 0
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
	dDtIni	:= Date()
	dDtFin	:= Date()	
	@ 100, 100 To 290, 550 Dialog oDlg Title "Parametros iniciais"
	@ 025,010 Say "Emissão Inicial: "
	@ 025,050 Get dDtIni Size 040,10 

	@ 040,010 Say "Emissão Final: "
	@ 040,050 Get dDtFin Size 040,10 
	
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
		If AllTrim(SX3->X3_CAMPO) $ "A6_FILIAL/A6_COD/A6_AGENCIA/A6_NOME/A6_NUMCON/A6_LIMCRED"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
				If AllTrim(SX3->X3_CAMPO) == "A6_FILIAL"
					aAdd( aHeader, { "Empresa","A6_EMP",X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
				Endif
			Endif
			If AllTrim(SX3->X3_CAMPO) == "A6_FILIAL"
				aAdd( aHeader, { "Empresa","A6_EMP",X3_PICTURE,15,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})				
//				aAdd( aHeader, { "Filial","A6_FIL",X3_PICTURE,15,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif			
		Endif
		SX3->(DbSkip())
	End 	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek( "SE1" )
	While !EOF() .And. X3_ARQUIVO == "SE1"
		If AllTrim(SX3->X3_CAMPO) $ "E1_VALOR/E1_SALDO"
			If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
				aAdd( aHeader, { Trim( "Garantia Emitida"),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif
			If AllTrim(SX3->X3_CAMPO) $ "E1_SALDO"
				aAdd( aHeader, { Trim( "Saldo Garantia"),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
			Endif			
		Endif
		SX3->(DbSkip())
	End 	
Else
	Return
Endif
                                        
nPBanco	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_COD"}) // Posição codigo do banco
nPAgenc	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_AGENCIA"}) // Posição codigo da agencia
nPNome	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_NOME"}) // Posição nome da agencia
nPConta	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_NUMCON"}) // Posição numero da conta
nPLimit	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_LIMCRED"}) // Posição limite configurado
nPValor	:= aScan(aHeader,{|x| AllTrim(x[2]) == "E1_VALOR"}) // Posição valor emitido
nPSaldo	:= aScan(aHeader,{|x| AllTrim(x[2]) == "E1_SALDO"}) // Posição SALDO emitido
nPEmp	:= aScan(aHeader,{|x| AllTrim(x[2]) == "A6_EMP"}) // Posição SALDO emitido

// Monta o ACols conforme os dados
If (nOpc = 3) // Inclusão
	SetKey(VK_F6,{||Atualiza()})
	SetKey(VK_F7,{||Ordena()})
	SetKey(VK_F8,{||FilCPO(1)})
	SetKey(VK_F9,{||FilCPO(2)}) 
	cEmps := GetMV("MV_X_EMGAR")
	aEmps := &cEmps  // Transforma a string em array multidimensional
	cSql := "("
	For nR := 1 To Len(aEmps)
		// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
		cSql += "SELECT '"+AllTrim(aEmps[nR,1])+"' A6_EMP,A6.A6_COD,A6.A6_AGENCIA,A6.A6_NREDUZ,A6.A6_NUMCON,Sum(A6.A6_X_VLGAR) A6_X_VLGAR, "
		cSql += "Coalesce((SELECT Sum(E1.E1_SALDO) FROM "+"SE1"+AllTrim(aEmps[nR,1])+"0"+" E1 "
		cSql += "WHERE E1.E1_FILIAL BETWEEN '  ' AND 'ZZ' AND E1.D_E_L_E_T_ <> '*' AND "
		cSql += "E1.E1_SALDO > 0 AND E1.E1_NUMBCO <> ' ' AND "
		cSql += "E1.E1_NUMBOR = ' ' AND E1.E1_PORTADO = A6.A6_COD AND "
		cSql += "E1.E1_AGEDEP = A6.A6_AGENCIA AND E1.E1_CONTA = A6.A6_NUMCON AND "
		cSql += "E1.E1_EMISSAO BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFin)+"'),0) E1_SALDO "
		cSql += "FROM "+"SA6"+AllTrim(aEmps[nR,1])+"0"+" A6 "
		cSql += "WHERE A6.D_E_L_E_T_ <> '*' AND A6.A6_X_VLGAR > 0 " 
		cSql += "GROUP BY A6.A6_COD, A6.A6_AGENCIA, A6.A6_NREDUZ, A6.A6_NUMCON "
		if nR != len(aEmps)
			cSql += " UNION ALL "
		Else
			cSql += " ) "
		EndIf	
	Next nR
//	MemoWrite("c:\boletos.txt",cSql)	
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
			aCols[Len(aCols),nPNome]	:= TMPSA6->A6_NREDUZ
			aCols[Len(aCols),nPConta]	:= TMPSA6->A6_NUMCON
			aCols[Len(aCols),nPLimit]	:= TMPSA6->A6_X_VLGAR
			aCols[Len(aCols),nPValor] 	:= TMPSA6->E1_SALDO
			aCols[Len(aCols),nPSaldo] 	:= (TMPSA6->A6_X_VLGAR-TMPSA6->E1_SALDO)
			_nGarant 					+= TMPSA6->A6_X_VLGAR
			_nEmitido 					+= TMPSA6->E1_SALDO
			_nSaldo						+= (TMPSA6->A6_X_VLGAR-TMPSA6->E1_SALDO)
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
EndIf

TMPSA6->(DbSelectArea("TMPSA6"))
DEFINE MSDIALOG oDlg1 TITLE cCadastro From 0,0 To 525, 1175 PIXEL OF oMainWnd

@ 020,003 Say OemToAnsi("Garantia :")
@ 020,030 Get _nGarant Picture "@E 999,999,999.99" Size 50,10 When .f.

@ 020,103 Say OemToAnsi("Emitido :")
@ 020,130 Get _nEmitido Picture "@E 999,999,999.99" Size 50,10 When .f.

@ 020,203 Say OemToAnsi("Saldo :")
@ 020,230 Get _nSaldo Picture "@E 999,999,999.99" Size 50,10 When .f.

If nOpc = 3
	@ 020,420 Say OemToAnsi("F6-Atualizar  F7-Ordenar    F8-Filtrar        F9-Remover Deletados")
Endif
//                                                       del 
oGet := MSGetDados():New(035,1,255,580,nOpc, , .F., "", .T.,{""}, , .F., 256)
oGet:oBrowse:nColPos


ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| GrvEmb(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() },,aButtons)
If Select("TMPSA6") <> 0
	TMPSA6->(DbCloseArea("TMPSA6"))
Endif

Return

Static Function GrvEmb()

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
		aCols[_nR,nPosVal] := ((_nFrtFech * aCols[_nR,nPosTNf])/nTotGer) 
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
                   
Static Function UpdDat()
cSql := "SELECT E1_PORTADO, E1_AGEDEP, Sum(E1_SALDO) "
cSql += "FROM "+RetSqlName("SE1")+" "
cSql += "WHERE E1_FILIAL = '  ' AND D_E_L_E_T_ <> '*' "
cSql += "AND E1_SALDO > 0 "
cSql += "AND E1_NUMBCO <> ' ' AND E1_NUMBOR = ' ' "
cSql += "AND E1_EMISSAO BETWEEN '"+dDtIni+"' AND '"+dDtFin+"'
cSql += "GROUP BY E1_PORTADO, E1_AGEDEP "
TCQUERY cSql NEW ALIAS "TMPSE1"
TMPSE1->(dbSelectArea("TMPSE1"))
TMPSE1->(dbGoTop())
While !TMPSE1->(Eof())

TMPSE1->(DbSkip())
End

Return

Static Function Ordena()
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos 

if (nPosis > 0)
	ASort(aCols,,,{ |x,y| x[nPosis] < y[nPosis]})
EndIf     

Return Nil

Static Function FILCPO(_nOpc)
Local _aCols  := aCols
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos
_nGarant 	:= 0
_nEmitido 	:= 0
_nSaldo		:= 0

If nPosis > 0
	cComp	  := aCols[n,nPosis]
	aCols := {}
Endif
If _nOpc = 1
	If nPosis > 0
		For nR := 1 To Len(_aCols)             
			If _aCols[nR,nPosis] == cComp
				aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
				_aCols[nR,8],_aCols[nR,9]})
				_nGarant 	+= _aCols[nR,nPLimit]
				_nEmitido 	+= _aCols[nR,nPValor]
				_nSaldo		+= _aCols[nR,nPSaldo]				
			Endif
		Next nR
	Endif
Else
	For nR := 1 To Len(_aCols)             
		If !_aCols[nR,9]
			aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
			_aCols[nR,8],_aCols[nR,9]})
			_nGarant 	+= _aCols[nR,nPLimit]
			_nEmitido 	+= _aCols[nR,nPValor]
			_nSaldo		+= _aCols[nR,nPSaldo]							
		Endif
	Next nR
endif
n:= 1
Return nil

Static Function Atualiza()
_nGarant	:= 0
_nEmitido 	:= 0
_nSaldo		:= 0
aCols	:= {}
If Select("TMPSA6") <> 0
	TMPSA6->(DbCloseArea("TMPSA6"))
Endif
cSql := "("
For nR := 1 To Len(aEmps)
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql += "SELECT '"+AllTrim(aEmps[nR,1])+"' A6_EMP,A6.A6_COD,A6.A6_AGENCIA,A6.A6_NREDUZ,A6.A6_NUMCON,Sum(A6.A6_X_VLGAR) A6_X_VLGAR, "
	cSql += "Coalesce((SELECT Sum(E1.E1_SALDO) FROM "+"SE1"+AllTrim(aEmps[nR,1])+"0"+" E1 "
	cSql += "WHERE E1.E1_FILIAL BETWEEN '  ' AND 'ZZ' AND E1.D_E_L_E_T_ <> '*' AND "
	cSql += "E1.E1_SALDO > 0 AND E1.E1_NUMBCO <> ' ' AND "
	cSql += "E1.E1_NUMBOR = ' ' AND E1.E1_PORTADO = A6.A6_COD AND "
	cSql += "E1.E1_AGEDEP = A6.A6_AGENCIA AND E1.E1_CONTA = A6.A6_NUMCON AND "
	cSql += "E1.E1_EMISSAO BETWEEN '"+DtoS(dDtIni)+"' AND '"+DtoS(dDtFin)+"'),0) E1_SALDO "
	cSql += "FROM "+"SA6"+AllTrim(aEmps[nR,1])+"0"+" A6 "
	cSql += "WHERE A6.D_E_L_E_T_ <> '*' AND A6.A6_X_VLGAR > 0 " 
	cSql += "GROUP BY A6.A6_COD, A6.A6_AGENCIA, A6.A6_NREDUZ, A6.A6_NUMCON "
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
		aCols[Len(aCols),nPNome]	:= TMPSA6->A6_NREDUZ
		aCols[Len(aCols),nPConta]	:= TMPSA6->A6_NUMCON
		aCols[Len(aCols),nPLimit]	:= TMPSA6->A6_X_VLGAR
		aCols[Len(aCols),nPValor] 	:= TMPSA6->E1_SALDO
		aCols[Len(aCols),nPSaldo] 	:= (TMPSA6->A6_X_VLGAR-TMPSA6->E1_SALDO)
		_nGarant 					+= TMPSA6->A6_X_VLGAR
		_nEmitido 					+= TMPSA6->E1_SALDO
		_nSaldo						+= (TMPSA6->A6_X_VLGAR-TMPSA6->E1_SALDO)			
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