#include "rwmake.ch"  

//Funcao para impressao do Comprovante de Doacao   
//02/05/2003 Solicitado por Accacio Modena.

User Function DOACAO()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//DECLARACAO DE VARIAVEIS
SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NOMEPROG,NLASTKEY,CPERG,ACOLS,TREGS")
SetPrvt("M_MULT,AMOEDAS,ACOLSANT,AHEADANT,AHEADER,NMOEDA,NXMOEDA,NTITULO,NCONT,CCODTRAN")
SetPrvt("COBS,CLOJACLI,CUF,CPLACA,CNOMTRAN,CENDTRAN,CMUNTRAN,CESTTRAN,CPEDIDO,ACOTACAO")

//Inicializacao da Variaveis
Titulo    := "Comprovante de Saida"
cDesc1    := "Este programa tem por objetivo a impressao do Comprovante de Saida"
cDesc2    := ""
cDesc3    := ""
cString   := "SF2"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "RJU007"
nLastKey  := 0    
cPerg     := "RJU007"
WnRel     := "ComSai"

//Variaveis utilizadas para parametros
//mv_par01             // Da Nota Fiscal
//mv_par02             // Ate a Nota Fiscal
//mv_par03             // Da Serie

Pergunte(cPerg)

SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)

If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

TRegs     := RecCount()   //Salva posicoes para movimento da regua de processamento

m_Mult    := 1

If TRegs > 0
   m_Mult := 70 / TRegs
EndIf

aMoedaS  := {GetMv("MV_Moeda1"), GetMv("MV_Moeda2"), GetMv("MV_Moeda3"), GetMv("MV_Moeda4"), GetMv("MV_Moeda5")}
aColsAnt  := aCols
aHeadAnt  := aHeader
aHeader   := {}
nMoeda    := 1

DbSelectArea("SX3")
SX3->(DbSetOrder(2))

SX3->(DbSeek("D2_COD"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

SX3->(DbSeek("D2_LOCAL"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

SX3->(DbSeek("D2_QUANT"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture        ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , ".F."                  ,;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo        ,;
               SX3->X3_Context })

Aadd(aHeader, {'Moeda'              , 'nMoeda'        , '9'                    ,;
               1                    , 0               , "nMoeda > 0 .And. nMoeda < 6" ,;
               SX3->X3_Usado        , 'N'             , "SD1"                  ,;
               SX3->X3_Context })


SX3->(DbSeek("D2_PRCVEN"))

Aadd(aHeader, {Trim(SX3->X3_Titulo) , SX3->X3_Campo   , SX3->X3_Picture     ,;
               SX3->X3_Tamanho      , SX3->X3_Decimal , "ExecBlock('_Valid02', .F., .F.)",;
               SX3->X3_Usado        , SX3->X3_Tipo    , SX3->X3_Arquivo     ,;
               SX3->X3_Context })

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
SF2->(DbSeek(xFilial("SF2") + MV_Par01 + MV_Par03, .T.))
 
While SF2->(!Eof()) .And. SF2->F2_Filial == xFilial("SF2");
                    .And. SF2->F2_Doc    <= Mv_Par02
          
   If SF2->F2_Serie #Mv_Par03
      SF2->(DbSkip())
      Loop
   EndIf
      
   nTitulo := 0 
    
   DbSelectArea("SD2")
   SD2->(DbSetOrder(3))
   SD2->(DbSeek(xFilial("SD2")+SF2->F2_Doc+SF2->F2_Serie+SF2->F2_Cliente+SF2->F2_Loja))
   
   DbSelectArea("SA1")
   SA1->(DbSetOrder(1))
   SA1->(DbSeek(xFilial("SA1") + SF2->F2_Cliente + SF2->F2_Loja))
       
   aCols     := {}
   cOBS      := Space(50)
   nCont     := 0   
   cCodTran  := SA1->A1_Cod
   cLojaCli  := SA1->A1_Loja
   cUF       := Space(2)
   cPlaca    := Space(8)
   cNomTran  := SA1->A1_Nome
   cEndTran  := SA1->A1_End
   cMunTran  := SA1->A1_Mun
   cEstTran  := SA1->A1_Est
      
   DbSelectArea("SC6")
   SC6->(DbSetOrder(2))   //Filial+Produto+Num+Item
   SETPRC(0,0)
   While SD2->D2_Filial == xFilial("SD2") .And. SD2->D2_Doc     == SF2->F2_Doc;
                                          .And. SD2->D2_Serie   == SF2->F2_Serie;
                                          .And. SD2->D2_Cliente == SF2->F2_Cliente;
                                          .And. SD2->D2_Loja    == SF2->F2_Loja
     nTitulo := 1
     
     Aadd(aCols, Array(7))
     nCont := nCont + 1
     
     aCols[nCont][1] := SD2->D2_Cod
     aCols[nCont][2] := SD2->D2_Local
     aCols[nCont][3] := SD2->D2_Quant
     aCols[nCont][4] := 1
     
     SC6->(DbSeek(xFilial("SC6") + SD2->D2_Cod + SD2->D2_Pedido + SD2->D2_ItemPv))
     
     cPedido := SD2->D2_Pedido

     aCols[nCont][5] := SD2->D2_PrcVen
     aCols[nCont][7] := .F.
     SB1->(DbSeek(xFilial("SB1") + aCols[nCont][1]))      
	 If SC6->C6_IMPUNI == "1"
     	aCols[nCont][6] := SB1->B1_UM
     Else
          // Alterado por Geraldo em 28/05/2005 para fazer conversão de/para segunda unidade de medida
          // Não deverá ser feito faturamento parcial para que esta rotina funcione carretamente
        aCols[nCont][6] := SB1->B1_SEGUM
		aCols[nCont][3] := SC6->C6_UNSVEN
  		aCols[nCont][5] := IIF(SB1->B1_TIPCONV=="M",SD2->D2_PrcVen/SB1->B1_CONV,SD2->D2_PrcVen*SB1->B1_CONV)
     EndIf

     SD2->(DbSkip())
   End
     
   If nTitulo > 0
      @ 200, 1 To 500, 610 Dialog oDlg1 Title "Comprovante de Doação"
      @ 5, 5 To 93, 300 Multiline
      @ 100, 250 Button "_Ok" Size 50, 20 Action Particular()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==>       @ 100, 250 Button "_Ok" Size 50, 20 Action Execute(Particular)
      @ 100,  10 Say "Nota Fiscal:"
      @ 100,  50 Say SF2->F2_Serie + ' / ' + SF2->F2_Doc
      @ 110,  10 Say "Cliente:"
      @ 110,  50 Say SF2->F2_Cliente + '/' + SF2->F2_Loja + ' - ' + SA1->A1_Nome
      @ 135,  10 Say "Observacoes:"
      @ 135,  50 Get cOBS                 Picture '@!S42'
      Activate Dialog oDlg1 Centered      
   Else
      MsgInfo("Nao Existem registros que atendam aos parametros!!!")   
   EndIf
   SF2->(DbSkip())           
End
 
Set Printer To
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO 
   OurSpool(WnRel)
Endif

FT_PFlush()

aCols   := aColsAnt
aHeader := aHeadAnt


//Funcao para Entrada dos dados Comprovante de Saida.
Static Function Particular()
@ 100, 100 To 380, 650 Dialog oDlg Title "Particular"
@  10,  10 Say "Nota Fiscal"
@  10, 130 Say "Pedido" 
@  20,  10 Say "Cliente"
@  40,  10 Say "Transportador"
@  50,  10 Say "Endereco"
@  60,  10 Say "Municipio"
@  60, 175 Say "Estado"
@  70,  10 Say "Placa"
@  70, 175 Say "Estado"

@  10,  55 Say SF2->F2_Serie + '/' + SF2->F2_Doc
@  10, 155 Say cPedido
@  20,  55 Say SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome

@  40,  55 Get cCodTran  Picture "@S6" Valid Atualiza() F3 "SA1"// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  40,  55 Get cCodTran  Picture "@S6" Valid Execute(Atualiza) F3 "SA1"
@  40, 105 Get cNomTran  Picture "@S28"                   When Empty(cCodTran)
@  50,  55 Get cEndTran  Picture '@S37'                   When Empty(cCodTran)
@  60,  55 Get cMunTran  Picture '@S20'                   When Empty(cCodTran)
@  60, 250 Get cEstTran  Picture '@! XX'                  When Empty(cCodTran)
@  70,  55 Get cPlaca    Picture '@!S10 XXX-XXXX'
@  70, 250 Get cUF       Picture '@! XX'

@ 120, 235 BmpButton Type 01 Action Close(oDlg)

Activate Dialog oDlg Center

//aCotacao := FuncaMoeda(SF2->F2_Emissao, 1, 1)

//If nXMoeda #1
//   For nCont := 1 To Len(aCols)
//       aCols[nCont][4] := aCols[nCont][4] / aCotacao[nXMoeda]
//   Next
//EndIf

If MsgBox("Imprimir Comprovante de Devolucao?","Comprovante","YESNO")
   @ 00        ,          00 PSay Chr(27) + Chr(120) + Chr(0) //Modo Draft
   @ 00        ,          00 PSay Chr(17)
   @ 00        ,          00 PSay Chr(27) + Chr(67) + Chr(33)
   @ 00        , 40          PSay 'D O A C A O'
   @ PRow()+1  , 00          PSay 'Nota Fiscal:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_Serie + ' / ' + SF2->F2_Doc
   @ PRow()    , PCol() + 05 PSay 'Emissao:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_Emissao
   @ PRow()    , PCol() + 05 PSay 'Pedido:'
   @ PRow()    , PCol() + 02 PSay cPedido
   
   If !Empty(cCodTran)
      @ PRow() + 2, 00          PSay 'Destinatario:'
      @ PRow()    , PCol() + 02 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
      @ PRow() + 1, 00          PSay 'Endereco:    '
      @ PRow()    , PCol() + 02 PSay SA1->A1_End
      @ PRow() + 1, 00          PSay 'Cidade:      '
      @ PRow()    , PCol() + 02 PSay SA1->A1_Mun
      @ PRow()    , PCol() + 01 PSay ' - ' + SA1->A1_Est
   Else
      @ PRow() + 2, 00          PSay 'Destinatario:'
      @ PRow()    , PCol() + 02 PSay cNomTran
      @ PRow() + 1, 00          PSay 'Endereco:    '
      @ PRow()    , PCol() + 02 PSay cEndTran
      @ PRow() + 1, 00          PSay 'Cidade:      '
      @ PRow()    , PCol() + 02 PSay cMunTran
      @ PRow()    , PCol() + 01 PSay ' - ' + cEstTran
   EndIf
      
   @ PRow() + 1,          00 PSay Repli('-', 80)
   @ PRow() + 1,          00 PSay 'Produto'
   
   For nCont := 1 To Len(aCols)
       SB1->(DbSetOrder(1))
       SB1->(DbSeek(xFilial("SB1") + aCols[nCont][1]))
       
       @ PRow() + 1,         00 PSay Left(aCols[nCont][1], 7)
       @ PRow()    , PCol()     PSay '/ ' + aCols[nCont][2]
       @ PRow()    , PCol() + 1 PSay '- ' + SB1->B1_Desc
       @ PRow()    , PCol() + 1 PSay aCols[nCont][6]
       @ PRow()    , PCol() + 1 PSay aCols[nCont][3]      Picture '@E 9999999.99'
       @ PRow()    , PCol() + 1 PSay aCols[nCont][5]      Picture '@E 9999999.99'
       @ PRow()    , PCol() + 1 PSay (aCols[nCont][3] * aCols[nCont][5]) Picture '@E 9999999.99'
       
       If PRow() > 20 .And. nCont < Len(aCols)
          @ PRow() + 1,          00 PSay Repli('-', 80)
          @ PRow() + 2, 00 PSay 'Listagem Parcial dos Produtos, favor anexar a Proxima Pagina!!!'
          
          Eject
          SETPRC(0,0)
          @ 00        , 40          PSay 'D O A C A O'
          @ PRow()+1  , 00          PSay 'Nota Fiscal:'
          @ PRow()    , PCol() + 05 PSay 'Emissao:'
          @ PRow()    , PCol() + 02 PSay SF2->F2_Emissao
          @ PRow()    , PCol() + 05 PSay "Pedido:"
          @ PRow()    , PCol() + 02 PSay cPedido
                    
          If !Empty(cCodTran)
             @ PRow() + 2, 00          PSay 'Destinatario:'
             @ PRow()    , PCol() + 02 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
             @ PRow() + 1, 00          PSay 'Endereco:    '
             @ PRow()    , PCol() + 02 PSay SA1->A1_End
             @ PRow() + 1, 00          PSay 'Cidade:      '
             @ PRow()    , PCol() + 02 PSay SA1->A1_Mun
             @ PRow()    , PCol() + 01 PSay ' - ' + SA1->A1_Est
          Else
             @ PRow() + 2, 00          PSay 'Destinatario:'
             @ PRow()    , PCol() + 02 PSay cNomTran
             @ PRow() + 1, 00          PSay 'Endereco:    '
             @ PRow()    , PCol() + 02 PSay cEndTran
             @ PRow() + 1, 00          PSay 'Cidade:      '
             @ PRow()    , PCol() + 02 PSay cMunTran
             @ PRow()    , PCol() + 01 PSay ' - ' + cEstTran
          EndIf
             
          @ PRow() + 1,          00 PSay Repli('-', 80)
          @ PRow() + 1,          00 PSay 'Produto'      
       EndIf   
   Next
    
   @ PRow() + 1,          61 PSay 'Total:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_ValMerc  Picture "@E 999,999,999.99"
   @ PRow() + 1,          00 PSay 'Numero da Duplicata:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_Serie + '/' + SF2->F2_Doc
   @ PRow()    , PCol() + 04 PSay 'Valor:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_ValMerc  Picture "@E 999,999,999.99"
//   @ PRow()    , PCol() + 02 PSay '(' + aMoedaS[nXMoeda] + ')'
   
   @ PRow() + 2,          00 PSay ''
   
   If !Empty(cOBS)
      @ PRow()    ,          00 PSay 'Observacao:'
      @ PRow()    , PCol() + 02 PSay cOBS
   EndIf
   
   If !Empty(cPlaca)
      @ PRow()    ,          64 PSay 'Placa:'
      @ PRow()    , PCol() + 02 PSay cPlaca
   EndIf
   
   DbSelectArea("SA3")
   SA3->(DbSetOrder(1))
   SA3->(DbSeek(xFilial("SA3") + SF2->F2_Vend1))

   @ PRow() + 1, 00 PSay Repl('-', 80)
   @ PRow() + 1, 00 PSay "Usuario:     " + SubStr(cUsuario, 07, 15)
   @ PRow() + 1, 00 PSay "Solicitante: " + SF2->F2_Vend1 + ' - ' + SA3->A3_Nome
   Eject
   SETPRC(0,0)
EndIf

Close(oDlg1)

Return
   
//Funcoes de Validacao p/ Atualizacao de Variaveis
Static Function Atualiza()

DbSelectArea("SA1")
SA1->(DbSetOrder(1))
SA1->(DbSeek(xFilial("SA1") + cCodTran + SA1->A1_Loja))
cNomTran  := SA1->A1_Nome
cLojaCli  := SA1->A1_Loja
cEndTran  := SA1->A1_End
cMunTran  := SA1->A1_Mun
cEstTran  := SA1->A1_Est

Return(.T.) 