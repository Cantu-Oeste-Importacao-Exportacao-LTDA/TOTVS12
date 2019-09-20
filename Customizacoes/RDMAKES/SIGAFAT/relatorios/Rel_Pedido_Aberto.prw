#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

User Function Rju025()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL,") 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝JU025    �       �                       � Data � 14.12.98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿝elatorio de Pedidos em aberto                              낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
cString  := "SC6"
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio de Pedidos de Venda em aberto")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RJU025"
aLinha   := {}
nLastKey := 0
Titulo   := "Relacao de Pedidos em aberto"
Cabec1   := "Pedido    Data    Produto     Vendedor                 Cliente"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"

m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "RJU025"               //Nome Default do relatorio em Disco

Pergunte(NomeProg)

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

SetDefault(aReturn, cString)

if nLastKey == 27
   Set Filter To
   Return
Endif

RptStatus({|| ImpRel() }, 'Pedidos de Venda em aberto')// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif

Ms_Flush()                 //Libera fila de relatorios em spool

Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿔mpRel    �       �                       � Data � 14.12.98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿔mpressao do Relatorio de pedidos de venda em aberto        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function ImpRel
Static Function ImpRel()

DbSelectArea("SC6")

SC6->(DbSetOrder(4))
SC6->(DbGoTop())
SetRegua(SC6->(LastRec()))

Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
SC5->(DbSetOrder(1))

SA3->(DbSetOrder(1))
While SC6->(!Eof()) .And. Empty(SC6->C6_Nota) .And. Empty(SC6->C6_Serie)
   SC5->(DbGoTop())   
   SC5->(DbSeek(xFilial("SC5") + SC6->C6_Num))   
   If SC6->C6_Cli >= MV_PAR01 .And. SC6->C6_Cli <= MV_PAR02
      If SC5->C5_Vend1 >= MV_PAR03 .And. SC5->C5_Vend1 <= MV_PAR04
         If SC5->C5_Emissao >= MV_PAR05 .And. SC5->C5_Emissao <= MV_PAR06
            SA3->(DbSetOrder(1))
            SA3->(DbGoTop())   
            SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
               
            If PRow() > 55
               Eject
               Cabec(Titulo, Cabec1, Cabec2, NomeProg, Tamanho, 18)
            EndIf         

            @ PRow() + 1 ,          0  PSay SC6->C6_Num
            @ PRow()     , PCol() + 2  PSay SC5->C5_Emissao
            @ PRow()     , PCol() + 2  PSay SC6->C6_Item
            @ PRow()     , PCol() + 2  PSay Left(SC6->C6_Produto, 6)
            @ PRow()     , PCol() + 2  PSay SC5->C5_Vend1
            @ PRow()     , PCol() + 2  PSay SA3->A3_NReduz
            @ PRow()     , PCol() + 2  PSay SC6->C6_Cli
            @ PRow()     , PCol() + 2  PSay SC6->C6_Loja
         EndIf
      EndiF
   EndIf         
   SC6->(DbSkip())       
   IncRegua()
End

Return
