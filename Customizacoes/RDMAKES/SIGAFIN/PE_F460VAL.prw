#include "rwmake.ch"

User Function F460VAL() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("cBanco,_aArea")

	_aArea := GetArea() 
	// pega a posicao do campo banco
	nPos6 := aScan(aHeader,{|x|UPPER(AllTrim(x[2]))=="E1_BCOCHQ"})	
	// recebe o codigo do banco
	cBanco := aCols[n,nPos6]
	// altera o campo historico do cheque
	RecLock("SE1",.F.)
		SE1->E1_HIST := SE1->E1_TIPO+" LIQ "+StrZero(Val(GetMv('MV_NUMLIQ')), 6)+" "+cBanco
	MsUnLock("SE1") 
	
	//-- RAFAEL - 09/02/2011 - GRAVAR DADOS DE CLASSE DE VALOR, CENTRO DE CUSTO E ITEM CONTABIL. 
	// Carlos Eduardo - 20/04/2012 - Incluido a gravação do vendedor1 nos titulos de liquidação
	If RecLock("SE1",.F.)
		SE1->E1_CCC    := __cCODCC 
		SE1->E1_ITEMC  := __cITEMC
		SE1->E1_CLVLCR := __cCLVLC
		SE1->E1_VEND1  := __cVEND1
		SE1->(MsUnLock())
	Endif  

RestArea(_aArea)

Return