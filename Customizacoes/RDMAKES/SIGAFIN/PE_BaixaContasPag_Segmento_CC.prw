/*
#include "rwmake.ch"
#include "protheus.ch"



DESCONTINUADO DEVIDO AS NOVAS TABELAS FK* NO MODULO FINANCEIRO


//No momento da chamada a tabela SE5 est� posicionada na �ltima movimenta��o gravada. 
// Exemplo de utiliza��o: 
// Atualiza��o do hist�rico da movimenta��o banc�ria 
User Function SE5FI080() 
// Verificar valida��o abaixo para que ao fazer uma baixa manual de juro, desconto ou corre��o monet�ria 
// seja gravado o segmento e o centro de custo no t�tulo, fazer teste na base de teste.

Local cCamposE5 := PARAMIXB

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (SE5->E5_RECPAG == "P")
	if (Empty(SE5->E5_CLVLDB) .And. Empty(SE5->E5_CLVLCR) .And. Empty(SE5->E5_CCC) .And. Empty(SE5->E5_CCD))
	  // Busca o t�tulo posicionado no SE2
	  if !(Empty(SE2->E2_CLVLDB) .And. Empty(SE2->E2_CLVLCR) .And. Empty(SE2->E2_CCC) .And. Empty(SE2->E2_CCD))
	  	RecLock('SE5',.F.)
	  		if (SE5->E5_TIPODOC $ 'DC/')// Inverte as contas quando for desconto -- ou corre�ao monet�ria a cr�dito
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


// Ponto de entrada ao fazer baixa autom�tica
User Function FA090SE5()
Local cHist := ParamIXB[1]

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// Grava o segmento e centro de custo quando efetuado baixa autom�tica, chamando a rotina acima devido a usar o mesmo crit�rio
U_SE5FI080()
Return cHist
*/