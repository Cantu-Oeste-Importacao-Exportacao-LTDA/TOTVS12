// Funcoes Utilizadas no CNAB a Pagar BANCO DO BRASIL.

//----------
User Function HdMod2BB()                   
//Rotina chamada no Header do Arquivo para inicializar a variavel auxiliar de soma do total de lote.

Public nTotLoBB := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

Return(.T.)

//----------
User Function TrMod2BB()
//Rotina chamada no Trailer do Arquivo para zerar a variavel auxiliar de soma do total de lote.

nTotLoBB := 0                    

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

Return(.T.)

//----------
User Function TOTLOTE()
//Rotina chamada no Trailer do Lote afim de devolver o valor total do lote.             

Local TotalLote := 0             

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())
      
If nTotLoBB = 0
	nTotLoBB := SomaValor()
Else
    TotalLote:=SomaValor()-nTotLoBB
    nTotLoBB := TotalLote
Endif

TotalLote:=StrZero(nTotLoBB,18)

Return(TotalLote)
//----------