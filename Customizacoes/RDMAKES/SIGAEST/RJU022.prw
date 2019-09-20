#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

User Function RJU022()        // incluido pelo assistente de conversao do AP5 IDE em 10/05/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL,NCONT,ADBF,CARQ")
SetPrvt("CARQIND,") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RJU022    ³       ³                       ³ Data ³ 26.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Relatorio de Custos.                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
cString  := "SB2"
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao de um")
cDesc2   := OemToAnsi("Relatorio contendo quantidade e custo de Estoque")
cDesc3   := ""
Tamanho  := "G"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RJU022"
aLinha   := {}
nLastKey := 0

Titulo   := "Relatorio de Custos"
Cabec1   := "Produto"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"

m_Pag    := 0                      //Variavel que acumula numero da pagina

WnRel    := "RJU022"               //Nome Default do relatorio em Disco

nCont    := 0

If !Pergunte("RJU022")
   Return
EndIf

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

SetDefault(aReturn, cString)

if nLastKey == 27
   Set Filter To
   Return
Endif

Processa( {|| GeraTmp() }, "Arquivo de Trabalho")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Processa( {|| Execute(GeraTmp) }, "Arquivo de Trabalho")

RptStatus({|| ImpRel() }, 'Relatorio de Custos')// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Relatorio de Custos')

DbSelectArea("TRB")
DbCloseArea("TRB")

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
±±³Fun‡„o    ³GeraTmp   ³       ³                       ³ Data ³ 28.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Gera Arquivo de Trabalho Temporario                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function GeraTmp
Static Function GeraTmp()
aDbf  := {}
Aadd(aDbf,{"Cod"     , "C", 15, 0})
Aadd(aDbf,{"Local"   , "C", 02, 0})
Aadd(aDbf,{"Desc"    , "C", 30, 0})
Aadd(aDbf,{"Quant"   , "N", 12, 2})
Aadd(aDbf,{"Total"   , "N", 12, 2})
Aadd(aDbf,{"Custo"   , "N", 14, 4})

cArq    := CriaTrab(aDbf, .T.)
Use (cArq) Alias TRB Shared New

DbSelectArea("SB2")
SB2->(DbGoTop())
SB2->(DbSetOrder(01))
SB2->(DbSeek(xFilial("SB2")))

ProcRegua(SB2->(LastRec()))

While SB2->(!Eof()) .AND. SB2->B2_FILIAL == xFilial("SB2")
   If SB2->B2_Cod >= MV_Par01 .And. SB2->B2_Cod   <= MV_Par02;
                              .And. SB2->B2_Local >= MV_Par03;
                              .And. SB2->B2_Local <= MV_Par04

      If (MV_PAR05 == 2 .And. SB2->B2_QAtu <> 0) .Or. MV_PAR05 == 1 
         If (MV_PAR06 == 1 .And. SB2->B2_QAtu  < 0) .Or.;
            (MV_PAR06 == 1 .And. SB2->B2_VAtu1 < 0) .Or.;
            (MV_PAR06 == 1 .And. SB2->B2_CM1   < 0) .Or.;
            MV_PAR06 == 2
         
            SB1->(DbSetOrder(1))
            SB1->(DbSeek(xFilial("SB1") + SB2->B2_Cod))
            
            RecLock("TRB", .T.)
              TRB->Cod     := SB2->B2_Cod
              TRB->Local   := SB2->B2_Local
              TRB->Desc    := SB1->B1_Desc  
              TRB->Quant   := SB2->B2_QAtu
              TRB->Total   := (SB2->B2_QAtu*SB2->B2_CM1)    // SB2->B2_VAtu1
              TRB->Custo   := SB2->B2_CM1
            MsUnLock("TRB")
         EndIf
      EndIf
   EndIf

   SB2->(DbSkip())

   IncProc()
EndDo

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ImpRel    ³       ³                       ³ Data ³ 26.11.98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do Relatorio de Custos                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Function ImpRel
Static Function ImpRel()

DbSelectArea("TRB")
TRB->(DbGoTop())

cArqInd := CriaTrab(NIL, .F.)

IndRegua("TRB", cArqInd, "Local+Desc+Cod",,, "Selecionando Registros...")
SetRegua(TRB->(LastRec()))
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)

While TRB->(!Eof())
   @ PRow() + 1 ,          00  PSay AllTrim(TRB->Cod) + ' / ' + TRB->Local
   @ PRow()     , PCol() +  2  PSay TRB->Desc
   @ PRow()     , PCol() +  2  PSay TRB->Quant    Picture '@E 9999999.99'
   @ PRow()     , PCol() +  2  PSay TRB->Total    Picture '@E 99999999.99'
   @ PRow()     , PCol() +  2  PSay TRB->Custo    Picture '@E 99999.9999'

   If PRow() > 60
      //Eject
      Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
   EndIf
   TRB->(DbSkip())
   IncRegua()
End
Roda(0, "", "P")
Return
