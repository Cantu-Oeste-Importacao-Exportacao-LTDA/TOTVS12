#include 'protheus.ch'
#Include "rwmake.ch" 
#Include "topconn.ch"

User Function SelBco(_cCli,_cLoja,_cDoc,_cPref,_cBco,_cAge,_cCta)
Local aArea	:= GetArea()
Local _aBcos	:= {}
Local _aBcImp	:= {}
Local _lImpBol	:= .T. 
Private _cBcoG,_cAgeG,_cCtaG := ""     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Filial 11 empresa 50 -> Ver impressão de boletos do segmento de Vinho. Diferenciado pois emite pela conta da matriz.

// Verifica se imprime boleto para cliente.
SA1->(DbSelectArea("SA1"))
SA1->(DbSetOrder(1))
SA1->(DbGotop())
SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))
If AllTrim(SA1->A1_FORMPAG) <> "BO"
	_lImpBol := .F.
	MsgAlert("Cliente "+AllTrim(SA1->A1_COD)+"/"+SA1->A1_LOJA+" - "+AllTrim(SA1->A1_NOME)+"."+chr(13)+chr(10)+;
	"N. FISCAL "+_cDoc+". NÃO CONFIGURADO PARA IMPRIMIR BOLETOS.")	
Endif


If _lImpBol // Se impressão de boleto para o cliente estiver habilitada.
	// Busca banco generico
	cSql := "SELECT ZZN.* "
	cSql += "FROM "+RetSqlName("ZZN")+" ZZN "
	cSql += "WHERE ZZN.ZZN_FILIAL = '"+xFilial("ZZN")+"' "
	cSql += "AND ZZN.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZN.ZZN_PRIORI = 'G' "
	cSql += "AND ZZN.ZZN_IMPBOL <> '2' "
	TCQUERY cSql NEW ALIAS "TMPZZN"
	TMPZZN->(DbSelectArea("TMPZZN"))
	TMPZZN->(DbGoTop())
	If !TMPZZN->(EOF())
		_cBcoG	:= TMPZZN->ZZN_BANCO
		_cAgeG	:= TMPZZN->ZZN_AGENCI
		_cCtaG	:= TMPZZN->ZZN_CONTA
	Else
		Alert("Banco generico não cadastrado. "+chr(13)+chr(10)+;
		"A impressão automatica de boletos não será possivel, imprima os boletos manualmente.")
		_lImpBol := .F.
	Endif
	TMPZZN->(DbSelectArea("TMPZZN"))
	DbCloseArea("TMPZZN")
	If _lImpBol
		// Busca bancos disponiveis para o cliente.
		cSql := "SELECT A1.A1_COD, A1.A1_LOJA, A1.A1_FORMPAG ,A1.A1_CEP,A1.A1_BCO1, ZM.ZM_BANCO "
		cSql += "FROM "+RetSqlName("SA1")+" A1,"+RetSqlName("SZM")+" ZM " 
		cSql += "WHERE A1.D_E_L_E_T_ <> '*' AND ZM.D_E_L_E_T_ <> '*' "
		cSql += "AND A1.A1_FILIAL = '"+xFilial("SA1")+"' AND ZM.ZM_FILIAL = '"+xFilial("SZM")+"' "
		cSql += "AND A1.A1_COD = '"+_cCli+"' AND A1.A1_LOJA = '"+_cLoja+"' "
		cSql += "AND ZM.ZM_RAIZCEP = SubStr(A1.A1_CEP,1,5) "
		TCQUERY cSql NEW ALIAS "TMPSZM"
		TMPSZM->(DbSelectArea("TMPSZM"))
		TMPSZM->(DbGoTop())
		
	 	While !TMPSZM->(EOF())
			aAdd(_aBcos,{TMPSZM->ZM_BANCO,'','',''})
			TMPSZM->(DbSkip())
		End
		TMPSZM->(DbSelectArea("TMPSZM"))
		DbCloseArea("TMPSZM")
		
		If Len(_aBcos) > 0                
			For nR := 1 To Len(_aBcos)
				ZZN->(DbSelectArea("ZZN"))
				ZZN->(DbSetOrder(1))
				ZZN->(DbGotop())
				ZZN->(DbSeek(xFilial("ZZN")+_aBcos[nR,1])) 
				While !ZZN->(Eof()) .AND. ZZN->ZZN_BANCO ==  _aBcos[nR,1]
			 		_lBloq	:= .F.
			 		SA6->(dbSelectArea("SA6"))
					SA6->(dbSetOrder(1))
					SA6->(dbGotop())
					If SA6->(dbSeek(xFilial("SA6")+_aBcos[nR,1]+ZZN->ZZN_AGENCI+ZZN->ZZN_CONTA))
						If SA6->A6_MSBLQL == '1' .OR. SA6->A6_BLOCKED == '1'
					 		_lBloq	:= .T.
					 		MsgInfo("Banco "+_aBcos[nR,1]+" Agencia "+ZZN->ZZN_AGENCI+" Conta "+ZZN->ZZN_CONTA+" "+chr(13)+chr(10)+ ;
					 		"Bloqueado no cadastro de bancos. Este cadastro não será considerado nas prioridades.")
						Endif				
						If ZZN->ZZN_IMPBOL <> '2' .AND. !_lBloq .AND. ZZN->ZZN_PRIORI <> '9'
							aAdd(_aBcImp,{_aBcos[nR,1],ZZN->ZZN_AGENCI,ZZN->ZZN_CONTA,ZZN->ZZN_PRIORI})
						Endif
					Endif
					ZZN->(DbSelectArea("ZZN"))	
					ZZN->(DbSkip())
				End
			Next nR
		    If Len(_aBcImp) > 0
				ASort(_aBcImp,,,{ |x,y| x[4] < y[4]})
				Do Case
					Case _aBcImp[1,1] = '104' // Caixa Economica Federal.
						U_BOLCAX(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)
						_lImpBol := .F.						
					Case _aBcImp[1,1] = '001' // Banco do Brasil
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)
						_lImpBol := .F.						
					Case _aBcImp[1,1] = '237' // Bradesco   
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)
						_lImpBol := .F.						
					Case _aBcImp[1,1] = '748' // Sicredi
					Case _aBcImp[1,1] = '422' // Safras
						U_BSaFraBrd(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)
						_lImpBol := .F.						
					Case _aBcImp[1,1] = '341' // Itau
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)
						_lImpBol := .F.						
					Case _aBcImp[1,1] = '320' // BIC Banco
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_aBcImp[1,1],_aBcImp[1,2],_aBcImp[1,3],.T.)					
						_lImpBol := .F.						
				EndCase
			Else
				If AllTrim(_cBcoG) <> '' .and. AllTrim(_cAgeG) <> '' .and. AllTrim(_cCtaG) <> ''
					Do Case
						Case _cBcoG = '104' // Caixa Economica Federal.
							U_BOLCAX(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
							_lImpBol := .F.							
						Case _cBcoG = '001' // Banco do Brasil
							U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
							_lImpBol := .F.							
						Case _cBcoG = '237' // Bradesco 
						  	U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.) // Guilherme
							_lImpBol := .F.						  	
						Case _cBcoG = '748' // Sicredi
						Case _cBcoG = '422' // Safras
							U_BSaFraBrd(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
							_lImpBol := .F.
						Case _cBcoG = '341' // Itau
							U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
							_lImpBol := .F.
						Case _cBcoG = '320' // BIC Banco
							U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)						
							_lImpBol := .F.
					EndCase
				Endif
			Endif
		Else 
			// Se não encontrar nenhum banco para o cliente, imprime boleto generico.
			If AllTrim(_cBcoG) <> '' .and. AllTrim(_cAgeG) <> '' .and. AllTrim(_cCtaG) <> ''
				Do Case
					Case _cBcoG = '104' // Caixa Economica Federal.
						U_BOLCAX(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
						_lImpBol := .F.
					Case _cBcoG = '001' // Banco do Brasil
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
						_lImpBol := .F.
					Case _cBcoG = '237' // Bradesco
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
						_lImpBol := .F.
					Case _cBcoG = '748' // Sicredi
					Case _cBcoG = '422' // Safras
						U_BSaFraBrd(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
						_lImpBol := .F.
					Case _cBcoG = '341' // Itau
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)
						_lImpBol := .F.
					Case _cBcoG = '320' // BIC Banco
						U_BOLASER(_cCli,_cLoja,_cDoc,_cPref,_cBcoG,_cAgeG,_cCtaG,.T.)												
						_lImpBol := .F.
					EndCase
				Endif
		Endif
		If _lImpBol
			SA1->(DbSelectArea("SA1"))
			SA1->(DbSetOrder(1))
			SA1->(DbGotop())
			SA1->(DbSeek(xFilial("SA1")+_cCli+_cLoja))		
			MsgAlert("Cliente "+AllTrim(SA1->A1_COD)+"/"+SA1->A1_LOJA+" - "+AllTrim(SA1->A1_NOME)+"."+chr(13)+chr(10)+;
			"N. FISCAL "+_cDoc+". NÃO FOI POSSÍVEL IMPRIMIR AUTOMATICAMENTE O BOLETO.")			
		Endif
	Endif
Endif

Return  
//EXECBLOCK("chamabol")
User function chamabol()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

_cCli:= 'NOVACHAEL'
_cLoja	:='01  '
_cDoc	:= "121111   "
_cPref	:= "   "
_lAuto	:= .t.	
u_SelBco(_cCli,_cLoja,_cDoc,_cPref)

Return Nil