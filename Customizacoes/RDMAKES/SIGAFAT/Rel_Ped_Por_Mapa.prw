#include "rwmake.ch" 

User Function Rel001()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Rel. de pedidos por mapa de carga                                                                                                       ³
//³ Com a implementacao do SFA, surgiu a necessidade de nao serem mais impressos os pedidos de venda. Dessa forma, todos os mapas de carga  ³
//³ que fossem alterados na hora do carregamento, implicariam diretamente na alteracao do respectivo pedido, antes q o mesmo fosse faturado.³
//³ para isso foi criado esse relatorio, para que os produtos que faltaram durante o carregamento, possam ser localizados, ou seja, saber   ³
//³ quais os pedidos que tem esses produtos, por transportador                                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,PROD1,PROD2,PROD3,PROD4,PROD5,PROD6,PROD7,TRANSP,DATAPED,ACHOU,PROCPROD")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³REL001    ³       ³                       ³ Data ³ 23.11.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relatorio de prod/pedido por transportador.                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio de Prod/Pedido por transportador")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "REL001"
aLinha   := {}
nLastKey := 0
cAmb     := GetEnvServer()
Titulo   := "Rel de Prod/Ped Transp " + cAmb
Cabec1   := "Pedido     Cod.Produto      Descr. Produto              Quantidade"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
ProcProd := 0

m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "REL001"               //Nome Default do relatorio em Disco

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

RptStatus({|| ImpRel() }, "Relacao de Prod/Pedido por transportador")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')
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
Prod     := MV_PAR02
Prod1    := MV_PAR03
Prod2    := MV_PAR04
Prod3    := MV_PAR05
Prod4    := MV_PAR06
Prod5    := MV_PAR07
Prod6    := MV_PAR08
DataPed  := dtos(MV_PAR09)

DbSelectArea("SC5")
SC5->(DbSetOrder(6)) //FILIAL+DATAEMISSAO+TRANSPORTADOR
SC5->(DbGoTop())
SC5->(DbSeek(xFilial("SC5") + DataPed + Transp))

DbSelectArea("SC6")
SC6->(DbSetOrder(1)) //FILIAL+NUMERODOPEDIDO
SC6->(DbGoTop())

SetRegua(SC5->(LastRec()))
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
  
While SC5->(!Eof()) 
  If SC5->C5_Transp = Transp
     SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))      
     achou:=.F.     
     While !Achou
       If SC6->C6_Num <> SC5->C5_NUM
          Achou:=.T.
          Exit
       EndIf
       While ProcProd <= 6
         If ProcProd=0
            Prod:= MV_PAR02
         elseIf ProcProd=1 
            Prod:=Prod1
         elseif ProcProd=2 
            Prod:=Prod2
         elseif ProcProd=3 
            Prod:=Prod3
         elseif ProcProd=4 
            Prod:=Prod4
         elseif ProcProd=5 
            Prod:=Prod5
         elseif ProcProd=6 
            Prod:=Prod6
         EndIf
         If ALLTRIM(SC6->C6_PRODUTO) = ALLTRIM(Prod)
            @ PRow() + 1 ,          0  PSay SC6->C6_Num          
            @ PRow()     ,         13  PSay SubSTR(SC6->C6_Produto,1,9)
            @ PRow()     ,         27  PSay SC6->C6_Descri Picture "@S25"
            @ PRow()     ,         55  PSay SC6->C6_QtdVen
         EndIf
         ProcProd:=ProcProd+1
       End 
       ProcProd:=0                       
       SC6->(DbSkip())                          
     End
  EndIf
  SC5->(DbSkip())                            
  IncRegua()
  If dTos(SC5->C5_EMISSAO) <> DataPed  
     Exit
  EndIf
EndDo
Return
