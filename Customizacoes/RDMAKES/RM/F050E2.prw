#include 'Protheus.ch'
#include 'totvs.ch'

/*
Ponto de entrada F050E2 para manipulação dos campos antes da 
inclusão do título na SE2, via integração. 

Data: 05/12/2018
*/   
 
User Function F050E2()
	Local aTitulo 	:= PARAMIXB[1]
	Local aRateio 	:= PARAMIXB[2]
	Local nPos 		:= 0
	Local nPosTip	:= 0
	Local nPosNat	:= 0
	
	Conout("INICIO PONTO DE ENTRADA F050E2")	
	
	//Ajusta prefixo
	nPos := aScan( aTitulo,{ |x| x[1] == "E2_PREFIXO"} )
	
	If nPos > 0
		aTitulo[nPos] := {"E2_PREFIXO","GPE",Nil}
	Else 
		aAdd( aTitulo,{"E2_PREFIXO","GPE",Nil} )
	EndIf     
	
	
	//Ajusta a natureza
	nPosTip := aScan( aTitulo,{ |x| x[1] == "E2_TIPO"} )
	nPosNat := aScan( aTitulo,{ |x| x[1] == "E2_NATUREZ"} )
	
	If nPosTip > 0 .And. nPosNat > 0
		Do Case
			Case AllTrim( aTitulo[nPosTip][2] ) == "PRO"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012005",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "COV"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2011004",Nil}	
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "FOL"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012001",Nil}	
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "FER"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012002",Nil}	
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "DEC"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012003",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "RES"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012004",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "INS"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012009",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "FGT"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012010",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "PEN"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012014",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "COS"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012015",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "GRR"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2012037",Nil}
				
			Case AllTrim( aTitulo[nPosTip][2] ) == "IRR"  	
				aTitulo[nPosNat] := {"E2_NATUREZ","2013066",Nil}
		EndCase
	Endif
		           
	Conout("FIM PONTO DE ENTRADA F050E2")	
	
Return {aTitulo,aRateio}