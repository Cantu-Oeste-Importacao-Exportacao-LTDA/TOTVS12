#include "rwmake.ch" 

User Function Rel002()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rel. de condicao de pedido                                                                                                              ³
//³ Com a implementacao do SFA, surgiu a necessidade de nao serem mais impressos os pedidos de venda. Todos os pedidos de venda, tem uma    ³
//³ condicao especifica que e informada no campo OBS. do pedido, no PALM TOP. Nesse relatorio e mostrado o que tem nesse campo, com o       ³
//³ numero do respectivo pedido.                                                                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³REL002    ³       ³                       ³ Data ³ 24.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relatorio de condicao de pedido para faturamento            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio de condicao do pedido")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "REL002" //informacoes no SX1
aLinha   := {}
nLastKey := 0
Titulo   := "Relacao de condicao de pedidos "  
Cabec1   := "Pedido    Condicao"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.


m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "REL002"               //Nome Default do relatorio em Disco

If !Pergunte(NomeProg) //se for cancelada a tela de perguntas, volta para o menu principal
   Return
EndIf

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)


If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| ImpRel() }, "Relacao de condicao de pedido")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif

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

Transp   := MV_PAR01
DataPed  := dtos(MV_PAR02) 
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)

DbSelectArea("SC5")
SC5->(DbSetOrder(2)) //FILIAL+DATAEMISSAO
SC5->(DbGoTop())
SC5->(DbSeek(xFilial("SC5") + DataPed))
SetRegua(SC5->(LastRec()))
@ PRow() + 1, 0  PSay "                                                         Transportador     "+Transp
While SC5->(!EOF()) 
  If SC5->C5_TRANSP == Transp .AND. dTos(SC5->C5_EMISSAO) == DataPed
     @ PRow() +  1,          0  PSay SC5->C5_NUM      Picture "@S6"
     @ PRow()     ,         12  PSay SC5->C5_MENNOTA  Picture "@S55" 
  EndIf

  SC5->(DbSkip())                            
  IncRegua()
  If dTos(SC5->C5_EMISSAO) <> DataPed
     Exit
  EndIf
EndDo

Return