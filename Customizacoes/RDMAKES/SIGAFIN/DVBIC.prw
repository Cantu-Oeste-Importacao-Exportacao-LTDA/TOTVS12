
/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`¿
//³Programa criado para calcular o dígito verificador do nosso número para o banco Bic.³
//³Esse cálculo é usado no programa RJRETCNAB que faz o ajuste dos arquivos de retorno.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ`Ù
ENDDOC*/

User Function DVBic(cNossoNum)   
Local i     := 0
Local nCont := 0
Local cPeso := 0
Local Resto := 0
Local cCart := "09"
Local DV_NN := Space(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	nCont   := 0
  cPeso   := 2 // Carteira + Radical + Matricula + Nosso Numero (Radical e matrícula estao no NumBoleta)
  nBoleta := cCart + cNossoNum            // carteira + nosso número
  For i := 13 To 1 Step -1
    nCont := nCont + (Val(SUBSTR(nBoleta,i,1))) * cPeso
    cPeso := cPeso + 1
    If cPeso == 8
      cPeso := 2
    Endif
  Next
   
  Resto := ( nCont % 11 )
  
  Do Case
    Case Resto == 1
 		  DV_NN := "P"
 	  Case Resto == 0
     	DV_NN := "0"
  OtherWise
     Resto   := ( 11 - Resto )
     DV_NN := AllTrim(Str(Resto))
   		 EndCase

Return(DV_NN)                                                                                           



/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função criada para retornar o número da conta formatada para o cnab do banco safra³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/

User Function ContaSafra(conta)
Local cConta := "000000000"  
conta := AllTrim(conta)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if !Empty(conta)
	cConta := StrZero(Val(SubStr(conta,1,Len(conta)-2)),8)+SubStr(conta,Len(conta),1)
EndIf

Return (cConta)          

User Function DvItau(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)                    

User Function DVNNBrad(cNNum)
Local i     := 0
Local nCont := 0
Local cPeso := 0
Local Resto := 0
Local cCart := "09"
Local DV_NN := Space(1)

nCont   := 0
cPeso   := 2
// Carteira(02) + Ano (02) + NumBoleto (9)
nBoleta := cCart + Right(Str(Year(dDataBase)),2) + cNNum 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
		  
For i := 13 To 1 Step -1		      
	nCont := nCont + (Val(SUBSTR(nBoleta,i,1))) * cPeso		       
	cPeso := cPeso + 1		      
	If cPeso == 8
		cPeso := 2
	Endif		      
Next
		   
Resto := ( nCont % 11 )		  
		  
Do Case
	Case Resto == 1
		DV_NN := "P"
	Case Resto == 0
		DV_NN := "0"
OtherWise
	Resto   := ( 11 - Resto )
	DV_NN := AllTrim(Str(Resto))
EndCase

Return(DV_NN)