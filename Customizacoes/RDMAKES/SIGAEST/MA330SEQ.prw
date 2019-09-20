/*
±±ºPrograma ³MA330SEQ ºAutor ³Microsiga º Data ³ 11/04/02 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc. ³Altera a ordem das movimentacoes(DE7/RE7), produtos = "PA", º±±
±±º ³na rotina do calculo do custo medio º±±
   Rotina para acerto de custo desmontagem de produtos.
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MA330SEQ()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

_cOrdem := ParamIxb[1]
//_cProd := GetAdvFval("SB1","B1_TIPO",xFilial("SB1") + SD3->D3_COD,1)
If ParamIxb[2] == "SD3"
If D3_CF $ "RE6"//"RE7/DE7"
_cOrdem := "299"
Endif
Endif
Return(_cOrdem)