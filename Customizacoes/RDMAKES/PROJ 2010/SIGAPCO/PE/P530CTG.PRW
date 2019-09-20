#Include "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณP530CTGบ   Autor:Guilherme Poyer       บ Data ณ  04/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc. ณ O ponto de entrada P530CTG possibilita validar as conting๊nciasบฑฑ
ฑฑบ solicitadas na tela de utiliza็ใo de conting๊ncia or็amentแria.			  บฑฑ
ฑฑบ Este ponto de entrada ้ chamado ao utilizar a op็ใo conting๊ncia na   บฑฑ     
ฑฑบ integra็ใo entre o m๓dulo que estแ realizando o processo com o m๓dulo บฑฑ
ฑฑบ de Planejamento e Controle Or็amentแrio.                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ SIGAPCO                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function P530CTG()
Local aCT 		:= paramixb[1] 
Local aCTaux	:= aCT
Local nI 			:= 0

If CDow(DDAtabase) == 'Monday'
	dDtAux	:= DDAtabase - 4 
Else
	dDtAux	:= DDAtabase - 3
EndIf

//Verifica de traz para frente as contingencias que estใo dentro do prazo de um dia estipulado pela Sra. Marcia.
For nI:=Len(aCTaux) to 1 step -1
	if aCTaux[nI][4] < dDtAux      				
		ADel(aCT,nI)		
		aSize(aCT, Len(aCT)-1)	
	EndIF
Next nI    

Return aCT