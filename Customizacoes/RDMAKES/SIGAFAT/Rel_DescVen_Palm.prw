#include "rwmake.ch" 

User Function Rel003()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rel. de percentual de desconto, por vendedor                                                                                            ³
//³ Esse relatorio informa o percentual de desconto (medio) que cada vendedor esta praticando.                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("VENDINI,VENDFIM,DATAINI,DATAFIN,ACHOU, ACUMPRCTAB, ACUMPRCVEND,DESCONTO") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³REL003    ³       ³                       ³ Data ³ 24.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relatorio de desconto medio, por vendedor.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio desconto medio, por vendedor")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "REL003" //informacoes no SX1
aLinha   := {}
nLastKey := 0
Titulo   := "Relacao de desconto medio, por vendedor "
Cabec1   := " Cod.Vendedor    Vendedor                                 Desc. Medio Periodo"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
AcumPrcTab:=0
AcumPrcVend:=0
Desconto:=0
M_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "REL003"               //Nome Default do relatorio em Disco

Pergunte(NomeProg)

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

SetDefault(aReturn, cString)

if nLastKey == 27
   Set Filter To
   Return
Endif

RptStatus({|| ImpRel() }, "Relacao de condicao de pedido para faturamento")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif

Ms_Flush()                 //Libera fila de relatorios em spool

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpRel    ³       ³                       ³ Data ³ 14.12.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Relatorio de pedidos de venda em aberto        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function ImpRel
Static Function ImpRel()
DataIni  := dtos(MV_PAR01)
DataFim  := dtos(MV_PAR02)
VendIni  := MV_PAR03
VendFim  := MV_PAR04

DbSelectArea("SC5")
SC5->(DbSetOrder(2)) //FILIAL+DATAEMISSAO+NUMERODOPEDIDO
SC5->(DbGoTop())
SC5->(DbSeek(xFilial("SC5") + DataIni))

DbSelectArea("SC6")
SC6->(DbSetOrder(1)) //FILIAL+NUMERODOPEDIDO
SC6->(DbGoTop())

DA1->(DbSetOrder(1)) //FILIAL+CODIGODATABEL+CODIGODOPRODUTO
DA1->(DbGoTop())
DA1->(DbSeek(xFilial("DA1") + "002"))

SA3->(DbSetOrder(1)) //FILIAL+CODIGODOVENDEDOR
SA3->(DbGoTop())
SA3->(DbSeek(xFilial("SA3") + VendIni))

SetRegua(SC5->(LastRec()))
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
If (substr(VendIni,1,2)) ="  "
   SA3->(DbGoTop())
   VendIni:=SA3->A3_COD
   SA3->(DbSeek(xFilial("SA3") + VendIni))
EndIf

If (substr(VendFim,1,2)) ="ZZ"
   SA3->(DbGoBottom())
   VendFim:=SA3->A3_COD
   SA3->(DbSeek(xFilial("SA3") + VendFim))
EndIf

While SA3->A3_Cod >=VendIni .And. SA3->A3_Cod<= VendFim
  SC5->(DbGoTop())
  SC6->(DbGoTop())  
  SC5->(DbSeek(xFilial("SC5") + DataIni))
  While dTos(SC5->C5_EMISSAO)>= DataIni .And. dTos(SC5->C5_EMISSAO)<= DataFim
    If SC5->C5_Vend1 = SA3->A3_Cod
       SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))      
       SA3->(DbGoTop())
       SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
       While (SC6->C6_Num = SC5->C5_Num)
         DA1->(DbGoTop())
         DA1->(DbSeek(xFilial("DA1") + "002" + SC6->C6_Produto))
         If DA1->DA1_PrcMin <> DA1->DA1_PrcVen //isso para nao somar o valor dos produtos em promocao
            AcumPrcTab:= DA1->DA1_PrcVen+AcumPrcTab                    
            AcumPrcVend:= SC6->C6_PrcVen+AcumPrcVend 
         End
         SC6->(DbSkip())                          
        End
    EndIf          
    SC5->(DbSkip())                            
  EndDo
  If AcumPrcTab > 0 
     @ PRow() + 1 ,          4  PSay   SA3->A3_COD
     @ PRow()     ,         17  PSay   SA3->A3_Nome  Picture "@S25"
     Desconto:= (AcumPrcVend*100)/AcumPrcTab 
     Desconto:=100-Desconto
     @ PRow(), 45 PSay Desconto Picture "@E 9,999.99"
     AcumPrcTab:=0
     AcumPrcVend:=0
     IncRegua() 
  EndIf
  SA3->(DbSkip())                              
EndDo  
Return