#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

User Function MNTA7651()         
Local _aArea	:= GetArea()
Local cAliasSE2 := GetNextAlias()
Local _cPrefixo	:= SuperGetMV("MV_MULPREF",,"MUL")	// Prefixo para o titulo da multa.
Local _cTipo	:= SuperGetMV("MV_MULTIPO",,"BOL")	// Tipo do titulo da multa.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If Inclui .AND. !Empty(TRX->TRX_DTVECI) .AND. TRX->TRX_PAGTO == '2'
		
	TRZ->(DbSelectArea("TRZ"))
	TRZ->(DbSetOrder(1))
	If TRZ->(DbSeek(xFilial("TRZ")+TRX->TRX_CODOR))
		_cFornec	:= TRZ->TRZ_X_FOR
	Endif
	SA2->(DbSelectArea("SA2"))
	SA2->(DbSetOrder(1))
	If SA2->(DbSeek(xFilial("SA2")+_cFornec)) 
		_cNatu		:= SA2->A2_NATUREZ 	
		_cFornec	:= SA2->A2_COD 		
		_cLoja		:= SA2->A2_LOJA 	
		
		_cSql := "SELECT MAX(SE2.E2_NUM) E2_NUM	"
		_cSql += "FROM "+RetSqlName("SE2")+" SE2 "
		_cSql += "WHERE SE2.E2_FILIAL = '"+xFilial('SE2')+"' "
		_cSql += "AND SE2.E2_PREFIXO = '"+_cPrefixo+"' "
		_cSql += "AND SE2.E2_TIPO = '"+_cTipo+"' "
		TCQUERY _cSql NEW ALIAS cAliasSE2
		   
		_cTitulo := StrZero(Val(cAliasSE2->E2_NUM)+1,6)
		cAliasSE2->(DbCloseArea())
		
		_cHistor  	:= "REF. MULTA: "+TRX->TRX_MULTA
		_cPrefixo 	:= "MUL"   		
		_cTipo    	:= "NF"			

		_dEmissao	:= Date()
		_dVecto		:= TRX->TRX_DTVECI
		_nVlr		:= TRX->TRX_VALOR
		                                              
		
		aDados := {}
		AADD(aDados,{"E2_PREFIXO"	,_cPrefixo		,nil})
		AADD(aDados,{"E2_NUM"		,_cTitulo		,nil})
		AADD(aDados,{"E2_TIPO"		,_cTipo			,nil})
		AADD(aDados,{"E2_NATUREZ"	,_cNatu			,nil})
		AADD(aDados,{"E2_FORNECE"	,_cFornec		,nil})
		AADD(aDados,{"E2_LOJA"		,_cLoja			,nil})
		AADD(aDados,{"E2_EMISSAO"	,_dEmissao		,nil})
		AADD(aDados,{"E2_VENCTO"	,_dVecto		,nil})
		AADD(aDados,{"E2_VALOR"		,_nVlr			,nil})
		AADD(aDados,{"E2_HIST"		,_cHistor		,nil})
		AADD(aDados,{"E2_ORIGEM"	,FunName()		,nil})
		AADD(aDados,{"E2_X_MULTA"	,TRX->TRX_MULTA	,nil})
		
		lMsErroAuto := .f.
		MSExecAuto({|x,y,z| FINA050(x,y,z)},aDados,,3)
		If lMsErroAuto
			MostraErro()
			Alert("Nao foi possível incluir titulo financeiro.")
		Endif	
	Else 
		Alert("Fornecedor do orgão autuador não cadastrado. Titulo financeiro não será incluido.")
	Endif
Endif
// Se não for inclusão ou alteração efetua a exclusão do titulo no financeiro.
If !Inclui .AND. !Altera
	cSql := "SELECT E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_NATUREZ, E2_FORNECE, E2_LOJA "
	cSql += "FROM "+RetSqlName("SE2")+"  "
	cSql += "WHERE E2_FILIAL = '"+xFilial("SE2")+"' "
	cSql += "AND D_E_L_E_T_ <> '*' "
	cSql += "AND E2_X_MULTA = '"+TRX->TRX_MULTA+"' "
	TCQUERY cSql NEW ALIAS "TMPE2"
	TMPE2->(DbSelectArea("TMPE2"))
	TMPE2->(DbGotop())
	If 	!TMPE2->(Eof())
		aVetor :={	{"E2_PREFIXO"	,TMPE2->E2_PREFIXO	,Nil},;
					{"E2_NUM"		,TMPE2->E2_NUM		,Nil},;
					{"E2_FORNECE"	,TMPE2->E2_FORNECE	,Nil},;
					{"E2_LOJA"		,TMPE2->E2_LOJA		,Nil},;					
					{"E2_PARCELA"	,TMPE2->E2_PARCELA	,Nil},;
					{"E2_TIPO"		,TMPE2->E2_TIPO		,Nil},;			
					{"E2_NATUREZ"	,TMPE2->E2_NATUREZ	,Nil}}
		lMsErroAuto := .f.
		MSExecAuto({|x,y,z| Fina050(x,y,z)},aVetor,,5)
		If lMsErroAuto
			MostraErro()
			Alert("Não foi possível excluir titulo financeiro.")
		Endif		
	Else
		Alert("Lançamento financeiro não encontrado.")
	Endif
	TMPE2->(DbCloseArea())
Endif

Return()