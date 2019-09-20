#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MANSFLEX  ºAutor  ³TI - Jean           º Data ³  01/07/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Schedule Recálculo Base Saldo Flex Pedidos                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function ManSFlex()

Local nPrcTab := 0
Local nPrcVen := 0
Local nPerc := 0
Local cArmazem := ""
Local nBaseFlex := 0
Local cChave := ""        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/* SQL para buscar os itens que não tiveram o saldo flex calculado num período de/até */
BEGINSQL Alias "TMPSC6"
	SELECT C6_FILIAL, C6_NUM, C6_ITEM, C6_PRODUTO, C6_LOCAL, C6_PRCTAB, C6_PRCVEN, C5_EMISSAO, C5_SIM3G, C6_X_SFLEX 
	FROM %table:SC6% C6
		INNER JOIN %table:SC5% C5 
		ON (C6_FILIAL = C5_FILIAL
				AND C6_NUM = C5_NUM
				AND C6_CLI = C5_CLIENTE
				AND C6_LOJA = C5_LOJACLI
				AND (C5_EMISSAO >= %exp:dDataBase-10%            // Dia Atual -10 até dia atual
				AND C5_EMISSAO <= %exp:dDataBase%)
				AND C5.D_E_L_E_T_ <> '*'
				AND C6.D_E_L_E_T_ <> '*')
		WHERE C6_PRCTAB <> 0
	  	AND C6_X_SFLEX = 0
ENDSQL     

aStruct := TMPSC6->(dbStruct())
cArq    := CriaTrab(aStruct, .T.)
Use (cArq) Alias TMPPED Shared New                                                                             
TMPSC6->(DbGotop())
dbSelectArea("TMPSC6")
While TMPSC6->(!Eof())
	nBaseFlex := 0
	nPrcTab := TMPSC6->C6_PRCTAB
	cArmazem := TMPSC6->C6_LOCAL                               
	
	/* Busca percentual de tolerância do cadastro de armazém.*/
	nPerc := Posicione("SZA",1,xFilial("SZA") + cArmazem, "ZA_DESCSYN")
	nPerc := nPerc/100                                                                   
	
	/* Cálculo da Base do Saldo Flex */
	nBaseFlex := nPrcTab - (nPrcTab * nPerc)
	
	cChave := C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	DbSelectArea("SC6")
	DbSetOrder(1)
	
	/* Atribui o valor da base do flex no campo C6_X_SFLEX */
	if DbSeek(cChave)
		RecLock("SC6", .F.)
		SC6->C6_X_SFLEX := nBaseFlex
		MsUnlock("SC6")
	EndIf
	TMPSC6->(DbSkip())
EndDo

TMPPED->(DbCloseArea())
TMPSC6->(DbCloseArea())

Return(nil)
