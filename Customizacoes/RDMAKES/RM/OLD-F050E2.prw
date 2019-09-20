#include 'Protheus.ch'
#include 'totvs.ch'

/*
Ponto de entrada F050E2 para manipula��o dos campos antes da 
inclus�o do t�tulo na SE2, via integra��o. 

Data: 05/12/2018
*/   

User Function F050E2()
	Local aTitulo := PARAMIXB[1]
	Local aRateio := PARAMIXB[2]
	Local nPos := 0
	
	Conout("INICIO PONTO DE ENTRADA F050E2")	
	
	nPos := aScan( aTitulo,{ |x| x[1] == "E2_PREFIXO"} )
	If nPos > 0
	      aTitulo[nPos] := {"E2_PREFIXO","GPE",Nil}
	Else 
	      aAdd( aTitulo,{"E2_PREFIXO","GPE",Nil} )
	EndIf     
	           
	Conout("FIM PONTO DE ENTRADA F050E2")	
	
Return {aTitulo,aRateio}