#include "rwmake.ch"     
#include "topconn.ch"  

//O ponto de entrada F460CANC sera utilizado apos a confirmacao do concelamento de liquidacao. 
//Se o retorno for diferente de 1, o cancelamento da liquidacao nao sera confirmado.
//Guilherme 12/06/2013
User Function F460CANC()
aArea := GetArea()
nOpcao:= PARAMIXB[1]
cLiq	:= SE1->E1_NUMLIQ
cClie := SE1->E1_CLIENTE
cLoja := SE1->E1_LOJA   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If .T.
EndIf

If nOpcao == 1
	cSql := "SELECT E5.E5_FILIAL,E5.E5_NUMERO,E5.E5_TIPO,E5.E5_CLIFOR,E5.E5_LOJA,E5.E5_PREFIXO,E5.E5_PARCELA,E5.E5_DOCUMEN,E5.E5_TIPODOC "
	cSql += " FROM "+RetSqlName("SE5")+" E5 "
	cSql += "WHERE E5.D_E_L_E_T_ <> '*' "
	cSql += "  AND E5.E5_FILIAL  = '"+xFilial("SE5")+"' "
	cSql += "  AND E5.E5_CLIFOR  = '"+cClie+"' "
	cSql += "  AND E5.E5_LOJA    = '"+cLoja+"' "
	cSql += "  AND E5.E5_DOCUMEN = '"+cLiq+"' "
	cSql += "  AND E5.E5_TIPODOC = 'BA' "
	cSql += "ORDER BY E5.E5_FILIAL,E5.E5_NUMERO "
	TcQuery cSql New Alias "TMPSE5"
	
	dbSelectArea("TMPSE5")
	dbgoTop()

	While TMPSE5->(!Eof())
		
		dbSelectArea("SE1") 
		dbsetorder(2)
		If dbseek(xFilial("SE1")+TMPSE5->E5_CLIFOR+TMPSE5->E5_LOJA+TMPSE5->E5_PREFIXO+TMPSE5->E5_NUMERO+TMPSE5->E5_PARCELA+TMPSE5->E5_TIPO)		
			If !Empty(AllTrim(SE1->E1_PEFININ)) .AND. !Empty(AllTrim(SE1->E1_PEFINMB)) .AND. Empty(AllTrim(SE1->E1_PEFINEX))
				RecLock("SE1",.F.)
					SE1->E1_PEFINMB := Space(6)
				MsUnlock("SE1")   
			Endif     
		Endif		
		
		TMPSE5->(dbSkip())	         
	End Do	               
	
	TMPSE5->(dbCloseArea())
EndIf      

RestArea(aArea)

Return(nOpcao)