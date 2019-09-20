#include "rwmake.ch" 

User Function RJUCS()

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - M_SAIDACOMPROSIGALOJA - " + "INICIO")

SetPrvt("CBCONT,CABEC1,CABEC2,CABEC3,WNREL,NORDEM,CPERG,M_PAG,TREGS,M_MULT,ACOTACAO")
SetPrvt("TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3,CSTRING,ARETURN,NOMEPROG,NLASTKEY")
SetPrvt("AMOEDAS,ACOLSANT,AHEADANT,AHEADER,NMOEDA,NTOTTIT,NXMOEDA,NTITULO,COBS,ACOLS")
SetPrvt("CESTTRAN,NCONT,CCODTRAN,CLOJACLI,CUF,CPLACA,CNOMTRAN,CENDTRAN,CMUNTRAN,CPEDIDO")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Funcao    ³RJU019    ³       ³                       ³      ³11/09/2003³±±
//³Descricao ³Impressao dos Comprovantes de Saida do SigaLoja             ³±±


CbCont    := ""
cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
Tamanho   := "M"
Limite    := 132
Titulo    := "Comprovante de Saida"
cDesc1    := "Este programa tem por objetivo a impressao do Comprovante de Saida"
cDesc2    := ""
cDesc3    := ""
cString   := "SF2"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "RJU007"
nLastKey  := 0    
cPerg     := "RJU007"
WnRel     := "ComSaiSL"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
m_Pag     := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³ 
//³ mv_par03             // Da Serie                             ³ 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

MsgBox("Teste Rafael")			

Pergunte(cPerg)

//LJENDPRINT("N") 
SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)

If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Salva posicoes para movimento da regua de processamento      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRegs     := RecCount()

m_Mult    := 1

If TRegs > 0
   m_Mult := 70 / TRegs
EndIf

aMoedas := {GetMv("MV_Moeda1"), GetMv("MV_Moeda2"), GetMv("MV_Moeda3"), GetMv("MV_Moeda4"), GetMv("MV_Moeda5")}
aCols     := {}
aColsAnt:= aCols
aHeadAnt:= aHeader
aHeader := {}
nMoeda  := 1

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

SF2->(DbSeek(xFilial("SF2") + SL1->L1_DOC + SL1->L1_SERIE , .T.))
//SF2->(DbSeek(xFilial("SF2") + MV_Par01 + MV_Par03, .T.))
 
While SF2->(!Eof()) .And. SF2->F2_Filial == xFilial("SF2");
                    .And. SF2->F2_Doc    >= Mv_Par01;
                    .And. SF2->F2_Doc    <= Mv_Par02
                              
    If SF2->F2_Serie #Mv_Par03
       SF2->(DbSkip())
       Loop
    EndIf
    
    DbSelectArea("SE1")
    SE1->(DbSetOrder(2))
    SE1->(DbSeek(xFilial("SE1") + SF2->F2_Cliente + SF2->F2_Loja;
                               + SF2->F2_Serie   + SF2->F2_Doc))
   
    nTotTit := 0
                                            
    While SE1->E1_Filial  == xFilial("SE1") .And. ;
          SE1->E1_Prefixo == SF2->F2_Serie  .And. ;
          SE1->E1_Num     == SF2->F2_Doc    .And. ;
          SE1->E1_Cliente == SF2->F2_Cliente
     
       nXMoeda    := SE1->E1_Moeda
       nTotTit    := nTotTit + SE1->E1_Valor
               
       SE1->(DbSkip())
    End
   
    nTitulo := 0 
    
    DbSelectArea("SD2")
    SD2->(DbSetOrder(3))
    SD2->(DbSeek(xFilial("SD2") + SF2->F2_Doc     + SF2->F2_Serie;
                               + SF2->F2_Cliente + SF2->F2_Loja))  
   
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
      Aadd(aCols, Array(6))
      nCont := nCont + 1
      aCols[nCont][1] := SD2->D2_Cod
      aCols[nCont][2] := SD2->D2_Local
      aCols[nCont][3] := SD2->D2_Quant
      aCols[nCont][4] := 1
      SC6->(DbSeek(xFilial("SC6") + SD2->D2_Cod + SD2->D2_Pedido + SD2->D2_ItemPv))
	  cPedido := SD2->D2_Pedido
      aCols[nCont][5] := SD2->D2_PrcVen
      aCols[nCont][6] := .F.
      SD2->(DbSkip())
    End
     
    If nTitulo > 0
       @ 200, 1 To 500, 610 Dialog oDlg1 Title "Particular - Pedidos de Venda"
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

	If MsgBox("Imprimir Nota Promissoria?","Nota Promissoria","YESNO")
	  //  Processa( {|| NPRJU()  } , 'Imprimindo Nota Promissoria')
  
	   DbSelectArea("SE1")
	   SE1->(DbSetOrder(1))               // filial+num+pref+parc TIT.RECEB.
	   SA1->(DbSetOrder(1))               // filial+cod para      CLIENTES
	   DbSeek(xFilial()+MV_PAR03+MV_PAR01,.T.)
	   nNotaProm:=val(MV_PAR01)
	   While SE1->(!Eof()) .And. SE1->E1_NUM     <= MV_PAR02;
	                       .And. SE1->E1_PREFIXO == MV_PAR03
   
	         SA1->(DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA))
	         @ 00       ,000  PSay CHR(15)
	         @ 00       ,000  PSay Chr(27) + Chr(67) + Chr(32) //24 Linhas
	         @ PRow()+2 ,061  PSay "NOTA PROMISSORIA"
	         @ PRow()   ,061  PSay "__________________"
	         @ PRow()+4 ,011  PSay "N§ "
	         @ PRow()   ,017  PSay SE1->E1_NUM
	         @ PRow()   ,025  PSay SE1->E1_PREFIXO
	         @ PRow()   ,050  PSay "VENCIMENTO: "
	         @ PRow()   ,065  PSay SE1->E1_VENCTO
	         @ PRow()   ,090  PSay "VALOR R$ "   
	         @ PRow()   ,100  PSay TRANSFORM(SE1->E1_SALDO, "@E 999,999.99")
	         @ PRow()+3 ,011  PSay "Aos "
	         _DIA:=StrTran(StrTran(Extenso(Val(Substr(Dtoc(SE1->E1_VENCTO),1,2))),"REAIS",""),"REAL","")
	         _MES:=UPPER(Mesextenso(Substr(Dtoc(SE1->E1_VENCTO),4,2)))
	         _ANO:=StrTran(StrTran(Extenso(Val("20"+Substr(Dtoc(SE1->E1_VENCTO),7,2))),"REAIS",""),"REAL","")
	         @ PRow()   ,PCol() PSay Lower(_Dia)+"dias do mˆs de "+Lower(_Mes)+" de "+Lower(_Ano)
	         @ PRow()   ,PCol() PSay "pagarei(emos) por esta unica via de Nota Promissoria"
			 @ PRow()+1 ,000    PSay "… RJU COM E BENEF DE FRUTAS VERDURAS LTDA - CGC/MF 78.575.149/0001-96, ou a sua ordem,"
	         @ PRow()   ,PCol() PSay " R$"+TRANSFORM(SE1->E1_SALDO, "@E 999,999.99") 
    	     @ PRow()   ,PCol() PSay " ( "+extenso(SE1->E1_SALDO)+" ), em moeda corrente nacional."
        	 @ PRow()+1 ,000    PSay "Praca de Pagamento: Vitorino - PR "
	         @ PRow()+4 ,000    PSay "Vitorino"
    	     @ PRow()   ,PCol() PSay SE1->E1_EMISSAO
        	 @ PRow()+6 ,000  Psay "______________________________________________________"
	         @ PRow()   ,070  Psay "______________________________________________________"
    	     @ PRow()+1 ,000  Psay SA1->A1_NOME
        	 @ PRow()   ,070  Psay "Avalista: "
			//If mv_par04 == '1'
    	     @ PRow()   ,080  Psay ""   //mv_par05
			//EndIf
	         @ PRow()+1 ,000  Psay "CGC/MF sob o No."
    	     @ PRow()   ,017  Psay Transform(SA1->A1_CGC,"@R 999.999.999/9999-99")
        	 @ PRow()   ,070  Psay "CPF: "
			//If mv_par04 == '1'
    	     @ PRow()   ,080  Psay ""   //mv_par06
			//EndIf
        	 @ PRow()+1 ,000    Psay SA1->A1_End
	         @ PRow()   ,PCol() Psay SA1->A1_Bairro
    	     @ PRow()   ,070  Psay "Endereco: "
			//If mv_par04 == '1'
	         @ PRow()   ,080  Psay ""   //mv_par07
			//EndIf 
 	         @ PRow()+1 ,000  Psay SA1->A1_CEP
	         @ PRow()   ,010  Psay SA1->A1_Mun
	         @ PRow()   ,033  Psay SA1->A1_Est
    	     If SE1->E1_NUM <= MV_PAR02 .And. SE1->E1_PREFIXO == MV_PAR03
        	    RecLock("SE1", .F.)
            	   If SE1->E1_TIPO=="DP "
                	  SE1->E1_TIPO:="NF"
	               Endif
    	           SE1->E1_NUMBCO := "NP"+SE1->E1_PREFIXO+ SE1->E1_NUM     //Grava Nosso Numero
        	    MsUnlock("SE1")
	         EndIf
    	  SE1->(DbSkip())
	      Eject
	   End
	   @ PRow()   ,000 PSay CHR(18)
	EndIf
    SF2->(DbSkip())           
End

Set Printer To
Set Device To Screen

If aReturn[5] == 1
   Set Printer TO 
   OurSpool(WnRel)
Endif

//FT_PFlush()

aCols   := aColsAnt
aHeader := aHeadAnt

Ms_Flush()

ConOut(Time() + " - " + cEmpAnt + cFilAnt + " - M_SAIDACOMPROSIGALOJA - " + "FIM")

Return

//³Funcao    ³Particular³       ³                       ³      ³ 22.09.98 ³±±
//³Descricao ³Entrada dos dados Comprovante de Saida.                     ³±±

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

aCotacao := FuncaMoeda(SF2->F2_Emissao, 1, 1)

//If nXMoeda #1
//   For nCont := 1 To Len(aCols)
//       aCols[nCont][4] := aCols[nCont][4] / aCotacao[nXMoeda]
//   Next
//EndIf

If MsgBox("Imprimir Comprovante de Saida?","Comprovante","YESNO")
   @ 00     , 00        PSay Chr(120) + Chr(0) //Modo Draft
   @ 00     , 00        PSay Chr(18)           //Normal
   @ 00     , 00        PSay 'Nota Fiscal:'
   @ PRow() , PCol()+02 PSay SF2->F2_Serie + ' / ' + SF2->F2_Doc
   @ PRow() , PCol()+05 PSay 'Emissao:'
   @ PRow() , PCol()+02 PSay SF2->F2_Emissao
   @ PRow() , PCol()+05 PSay 'Pedido:'
   @ PRow() , PCol()+02 PSay cPedido
   
   If !Empty(cCodTran)
      @ PRow()+2, 00          PSay 'Destinatario:'
      @ PRow()  , PCol()+02 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
      @ PRow()+1, 00        PSay 'Endereco:    '
      @ PRow()  , PCol()+02 PSay SA1->A1_End
      @ PRow()+1, 00        PSay 'Cidade:      '
      @ PRow()  , PCol()+02 PSay SA1->A1_Mun
      @ PRow()  , PCol()+01 PSay ' - ' + SA1->A1_Est
   Else
      @ PRow()+2, 00        PSay 'Destinatario:'
      @ PRow()  , PCol()+02 PSay cNomTran
      @ PRow()+1, 00        PSay 'Endereco:    '
      @ PRow()  , PCol()+02 PSay cEndTran
      @ PRow()+1, 00        PSay 'Cidade:      '
      @ PRow()  , PCol()+02 PSay cMunTran
      @ PRow()  , PCol()+01 PSay ' - ' + cEstTran
   EndIf
   @ PRow()+1, 00        PSay Repli('-', 80)
   @ PRow()+1, 00        PSay 'Produto'
   
   For nCont := 1 To Len(aCols)
       SB1->(DbSetOrder(1))
       SB1->(DbSeek(xFilial("SB1") + aCols[nCont][1]))
       
       @ PRow()+1, 00       PSay Left(aCols[nCont][1], 7)
       @ PRow()  , PCol()   PSay '/ ' + aCols[nCont][2]
       @ PRow()  , PCol()+1 PSay '- ' + SB1->B1_Desc
       @ PRow()  , PCol()+1 PSay SB1->B1_UM
       @ PRow()  , PCol()+1 PSay aCols[nCont][3]      Picture '@E 9999999.99'
       @ PRow()  , PCol()+1 PSay aCols[nCont][5]      Picture '@E 9999999.99'
       @ PRow()  , PCol()+1 PSay (aCols[nCont][3] * aCols[nCont][5]) Picture '@E 9999999.99'
       
       If PRow() > 20 .And. nCont < Len(aCols)
          @ PRow()+1, 00        PSay Repli('-', 80)
          @ PRow()+2, 00        PSay 'Listagem Parcial dos Produtos, favor anexar a Proxima Pagina!!!'
          Eject
          SETPRC(0,0)
          @ 00      , 00        PSay 'Nota Fiscal:'
          @ PRow()  , PCol()+02 PSay SF2->F2_Serie + ' / ' + SF2->F2_Doc
          @ PRow()  , PCol()+05 PSay 'Emissao:'
          @ PRow()  , PCol()+02 PSay SF2->F2_Emissao
          @ PRow()  , PCol()+05 PSay "Pedido:"
          @ PRow()  , PCol()+02 PSay cPedido
                    
          If !Empty(cCodTran)
             @ PRow()+2, 00        PSay 'Destinatario:'
             @ PRow()  , PCol()+02 PSay SA1->A1_Cod + '/' + SA1->A1_Loja + ' - ' + SA1->A1_Nome
             @ PRow()+1, 00        PSay 'Endereco:    '
             @ PRow()  , PCol()+02 PSay SA1->A1_End
             @ PRow()+1, 00        PSay 'Cidade:      '
             @ PRow()  , PCol()+02 PSay SA1->A1_Mun
             @ PRow()  , PCol()+01 PSay ' - ' + SA1->A1_Est
          Else
             @ PRow()+2, 00        PSay 'Destinatario:'
             @ PRow()  , PCol()+02 PSay cNomTran
             @ PRow()+1, 00        PSay 'Endereco:    '
             @ PRow()  , PCol()+02 PSay cEndTran
             @ PRow()+1, 00        PSay 'Cidade:      '
             @ PRow()  , PCol()+02 PSay cMunTran
             @ PRow()  , PCol()+01 PSay ' - ' + cEstTran
          EndIf
             
          @ PRow()+1, 00 PSay Repli('-', 80)
          @ PRow()+1, 00 PSay 'Produto'      
       EndIf   
   Next
    
   @ PRow() + 1,          61 PSay 'Total:'
   @ PRow()    , PCol() + 02 PSay nTotTit                 Picture '@E 99999999.99'
   @ PRow() + 1,          00 PSay 'Numero da Duplicata:'
   @ PRow()    , PCol() + 02 PSay SF2->F2_Serie + '/' + SF2->F2_Doc
   @ PRow()    , PCol() + 04 PSay 'Valor:'
   @ PRow()    , PCol() + 02 PSay nTotTit                 Picture '@E 99999999.99'
   @ PRow()    , PCol() + 02 PSay '(' + aMoedas[nXMoeda] + ')'
   
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

   SETPRC(0,0)
   Eject
EndIf

Close(oDlg1)

Return
   
//³Descricao ³ Funcoes de Validacao p/ Atualizacao de Variaveis           ³±±
//³ Uso      ³ CANTU                                                      ³±±

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