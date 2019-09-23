/*
#include "rwmake.ch"
#include "protheus.ch"



DESCONTINUADO DEVIDO AS NOVAS TABELAS FK* NO MODULO FINANCEIRO


//No momento da chamada a tabela SE5 está posicionada na última movimentação gravada. 
// Exemplo de utilização: 
// Atualização do histórico da movimentação bancária 
User Function SE5FI080() 
// Verificar validação abaixo para que ao fazer uma baixa manual de juro, desconto ou correção monetária 
// seja gravado o segmento e o centro de custo no título, fazer teste na base de teste.

Local cCamposE5 := PARAMIXB

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (SE5->E5_RECPAG == "P")
	if (Empty(SE5->E5_CLVLDB) .And. Empty(SE5->E5_CLVLCR) .And. Empty(SE5->E5_CCC) .And. Empty(SE5->E5_CCD))
	  // Busca o título posicionado no SE2
	  if !(Empty(SE2->E2_CLVLDB) .And. Empty(SE2->E2_CLVLCR) .And. Empty(SE2->E2_CCC) .And. Empty(SE2->E2_CCD))
	  	RecLock('SE5',.F.)
	  		if (SE5->E5_TIPODOC $ 'DC/')// Inverte as contas quando for desconto -- ou correçao monetária a crédito
	  			SE5->E5_CLVLDB := SE2->E2_CLVLCR
	  			SE5->E5_CLVLCR := SE2->E2_CLVLDB
	  			SE5->E5_CCC := SE2->E2_CCD
	  			SE5->E5_CCD := SE2->E2_CCC	  		
	  		else	  		
	  			SE5->E5_CLVLDB := SE2->E2_CLVLDB
	  			SE5->E5_CLVLCR := SE2->E2_CLVLCR
	  			SE5->E5_CCC := SE2->E2_CCC
	  			SE5->E5_CCD := SE2->E2_CCD	  		
	  		EndIf
	  	SE5->(MsUnlock())
//	  else
	  	// solicita centro de custo e segmento para a baixa 
	  EndIf
	EndIf
EndIf

Return cCamposE5


// Ponto de entrada ao fazer baixa automática
User Function FA090SE5()
Local cHist := ParamIXB[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Grava o segmento e centro de custo quando efetuado baixa automática, chamando a rotina acima devido a usar o mesmo critério
U_SE5FI080()
Return cHist
*/