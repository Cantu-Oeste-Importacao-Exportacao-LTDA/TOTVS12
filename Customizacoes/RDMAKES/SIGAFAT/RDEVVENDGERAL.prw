#include "rwmake.ch" 

User Function RDEVVENGERAL()

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN,NOMEPROG,NLASTKEY,TITULO,CABEC1")
SetPrvt("CABEC2,CPERG,m_Pag,CCANCEL,WNREL,NCONT,_CPAG,nTotDevol,MotDevol,cMotivo")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Funcao    ³RDEVVEND  ³       ³                       ³ Data ³15/10/2003³±±
//³Descri‡„o ³Relatorio de Devoluções de Venda.                           ³±±

cPerg    := "RDEVEN"
Pergunte(cPerg,.T.)
cString  := "SD1"
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio de Devolução de Vendas por Periodo")
cDesc3   := ""
Tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RDEVVEND"
nLastKey := 0
Titulo   := "Relatorio de Devoluções de Vendas do Periodo "+Substr(Dtoc(MV_PAR01),1,2)+"/"+Substr(Dtoc(MV_PAR01),4,2)+"/"+Substr(Dtoc(MV_PAR01),7,2)+" a "+Substr(Dtoc(MV_PAR02),1,2)+"/"+Substr(Dtoc(MV_PAR02),4,2)+"/"+Substr(Dtoc(MV_PAR02),7,2)
Cabec1   := "Codigo   Descricao                                                                                                          Venda"
Cabec2   := "" 
cCancel  := "***** Cancelado Pelo Operador *****"
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "Rel Dev Vend"         //Nome Default do relatorio em Disco
nCont    := 0
_cPag    :=1


WnRel := SetPrint(cString,WnRel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

SetDefault(aReturn,cString)

if nLastKey == 27
   Set Filter To
   Return
Endif

lAbortPrint := lEnd := .F.
Processa( {|lEnd| GeraTmp() }, "Arquivo de Trabalho")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> Processa( {|lEnd| Execute(GeraTmp) }, "Arquivo de Trabalho")

lAbortPrint := lEnd := .F.
RptStatus({|lAbortPrint| ImpRel() }, 'Relatorio de Vendas')// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|lAbortPrint| Execute(ImpRel) }, 'Relatorio de Vendas')

DbCloseArea("TRB")

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif

Ms_Flush()                 //Libera fila de relatorios em spool

Return

//************************************************************************************

//³Funcao    ³GeraTmp   ³       ³                       ³ Data ³15/10/2003³±±
//³Descricao ³Gera Arquivo de Trabalho Temporario                         ³±±

Static Function GeraTmp()
aDbf  := {}                        
Aadd(aDbf,{"COD"    , "C", 07, 0})
Aadd(aDbf,{"DESC"   , "C", 30, 0})
Aadd(aDbf,{"DOC"    , "C", 06, 0})
Aadd(aDbf,{"SERIE"  , "C", 03, 0})
Aadd(aDbf,{"TIPO"   , "C", 01, 0})
Aadd(aDbf,{"EMISSAO", "D", 08, 0})
Aadd(aDbf,{"VALOR"  , "N", 14, 4})
Aadd(aDbf,{"CLIENTE", "C", 06, 0})
Aadd(aDbf,{"LOJA"   , "C", 02, 0})
Aadd(aDbf,{"VEND"   , "C", 06, 0})
Aadd(aDbf,{"CUSTO"  , "N", 14, 4})
Aadd(aDbf,{"MOTDEV" , "C", 02, 0})
Aadd(aDbf,{"DESCMOT", "C", 30, 0})

cArq    := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New

DbSelectArea("SD1")
SD1->(DbSetOrder(3))                   //Emissao + DOC + Prefixo + FORNECEDOR

SD1->(DbSeek(xFilial("SD1")+DTOS(MV_PAR01),.T.))
RegInic:=SD1->(RecNo())
SD1->(DbSeek(xFilial("SD1")+DTOS(MV_PAR02+1),.T.))
RegFim := SD1->(RecNo())
ProcRegua(RegFim-RegInic)

SD1->(DbGoTop())

SD1->(DbSeek(xFilial("SD1") + Dtos(MV_PAR01), .T.))

While SD1->(!Eof()) .And. SD1->D1_EMISSAO >= MV_PAR01 .And. SD1->D1_Emissao <= MV_PAR02
 
   IF SD1->D1_TIPO == "D"
 
      SA1->(DbSetOrder(1))
      SA1->(DbSeek(xFilial("SA1") + SD1->D1_FORNECE + SD1->D1_Loja))

      SB1->(DbSetOrder(1))
      SB1->(DbSeek(xFilial("SB1") + SD1->D1_COD))

      SX5->(DbSetOrder(1))
      SX5->(DbSeek(xFilial("SX5") + "43" + SD1->D1_MOTDEV))

      RecLock("TRB", .T.)
         TRB->COD    := SD1->D1_COD
         TRB->DESC   := SB1->B1_DESC
         TRB->DOC    := SD1->D1_DOC
         TRB->SERIE  := SD1->D1_SERIE  
         TRB->TIPO   := SD1->D1_TIPO
         TRB->EMISSAO:= SD1->D1_EMISSAO
         TRB->VALOR  := SD1->D1_TOTAL
         TRB->CLIENTE:= SD1->D1_FORNECE
         TRB->LOJA   := SD1->D1_LOJA
         TRB->VEND   := SA1->A1_VEND
         TRB->CUSTO  := SD1->D1_CUSTO
         TRB->MOTDEV := SD1->D1_MOTDEV  
         TRB->DESCMOT:= SX5->X5_DESCRI
      MsUnLock("TRB")
   EndIf

   SD1->(DbSkip())
   If lEnd
      Return
   EndIf
   IncProc()
EndDo
Return

//³Funcao    ³ImpRel    ³       ³                       ³ Data ³15/10/2003³±±
//³Descricao ³Impressao do Relatorio Devoluções de Vendas                 ³±±

Static Function ImpRel()
Local motDevol:=''
totalMot:=0
DbSelectArea("TRB")
cArqInd := CriaTrab(NIL, .F.)
//controla o indice da tabela temporaria
IndRegua("TRB", cArqInd, "MOTDEV",,, "Selecionando Registros...")
SetRegua(TRB->(LastRec()))
TRB->(DbGoTop())
nTotal  := 0
nTotDevol  := 0           
cMotivo := ''
motDevol:=0
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
While TRB->(!Eof())
   totalMot:=totalMot+TRB->VALOR
   motDevol:=TRB->MOTDEV 
   cMotivo:=TRB->DESCMOT
   TRB->(DbSkip())
   if motDevol <> TRB->MOTDEV
      @ PRow()+1   ,   2 PSay motDevol
      @ PRow()     ,   9 PSay cMotivo
      @ PRow()     , 115 PSay totalMot     Picture '@E 99,999,999.99'
      nTotDevol:=nTotDevol+TotalMot
      totalMot:=0
   endIf
//      IncRegua()
   If PRow() > 53
      Eject
      Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
   EndIf         
End
@ PRow()   +1,   9 PSay 'Total'
@ PRow()   +1, 115 PSay nTotDevol    Picture '@E 99,999,999.99'   
Return