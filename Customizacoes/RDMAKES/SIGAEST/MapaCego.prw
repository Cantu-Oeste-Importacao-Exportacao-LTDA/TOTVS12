#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAPACEGO  ºAutor  ³Flavio Dias				 º Data ³  07/10/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Impressão do Mapa Cego com os produtos da NF de Entrada     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MapaCego()

SetPrvt("CABEC1,CABEC2,CABEC3,WNREL,NORDEM,TAMANHO,LIMITE,TITULO,CDESC1,CDESC2,CDESC3")
SetPrvt("CSTRING,ARETURN,NOMEPROG,NLASTKEY,CPERG,M_PAG,NLI,NTOTITENS,NVLRBRUTO")
SetPrvt("NBASEICM,NTOTICM")
SetPrvt("xNOME_EMP,xEND_EMP,xCOMP_EMP,xBAIR_EMP,xTEL_EMP,xFAX_EMP,xCEP_EMP")
SetPrvt("xCID_EMP,xEST_EMP,xCGC_EMP,xINSC_EMP")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Funcao    ³ RJU008   ³       ³                       ³ Data ³ 03/09/98 ³±±
//³Descricao ³ Nota Fiscal de Entrada                                     ³±±
//³Uso       ³ CANTU                                                      ³±±

cabec1    := ""
cabec2    := ""
cabec3    := ""
wnrel     := ""
nOrdem    := 0
Tamanho   := "P"
Limite    := 132
Titulo    := "Mapa Cego"
cDesc1    := "Este programa tem por objetivo a impressao do Mapa Cego"
cDesc2    := ""
cDesc3    := ""
cString   := "SF1"
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg  := "MapaCego"
nLastKey  := 0
cPerg     := "RJU008"
WnRel     := "MapaCego"
m_Pag     := 1  //Variaveis utilizadas para Impressao do Cabecalho e Rodape

//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Da Nota Fiscal                       ³
//³ mv_par02             // Ate a Nota Fiscal                    ³ 
//³ mv_par03             // Da Serie                             ³ 
//³ mv_par04             // NF Produtor n.º                      ³ 

If ! Pergunte(cPerg)
   Return
Endif

//³ Envia controle para a funcao SETPRINT                        ³
WnRel := SetPrint(cString, wnrel, cPerg, Titulo, cDesc1, cDesc2, cDesc3, .F.,"")

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

//³Selecao de Chaves para os arquivos                            ³
SA2->(DbSetOrder(1))               // filial+cod           Fornecedores
SA3->(DbSetOrder(1))               // filial+cod           Vendedores
SA4->(DbSetOrder(1))               // filial+cod           Transportadoras
SB1->(DbSetOrder(1))               // filial+cod           Produtos
SF1->(dbSetOrder(1))               // filial + doc + serie + fornec. + loja + tipo    Cab. Nota Fiscal
SD1->(DbSetOrder(1))               // filial+doc+serie     Itens NF
SM0->(DbSetOrder(1))

dbSelectArea("SM0")                   // * Sigamat.emp
xNOME_EMP := SM0->M0_NOMECOM
xEND_EMP  := SM0->M0_ENDCOB  
xTEL_EMP  := SM0->M0_TEL
xCID_EMP  := SM0->M0_CIDCOB
xCGC_EMP  := SM0->M0_CGC 

SF1->(DbSeek(xFilial("SF1") + Mv_Par01 + Mv_Par03 + Mv_Par05 + Mv_Par06,.T.))
SetDefault(aReturn, cString)

If LastKey() == 27 .OR. nLastKey == 27
   Return
Endif

SETPRC(0,0)
While SF1->(!Eof()) .And. SF1->F1_Filial  == xFilial("SF1") ;
                    .And. SF1->F1_Doc     <= AllTrim(Mv_Par02) ;
                    .And. SF1->F1_Serie   <= AllTrim(Mv_Par03) ;
                    .And. SF1->F1_Fornece == AllTrim(Mv_Par05) ;
                    .And. SF1->F1_Loja    == AllTrim(Mv_Par06)
          
   If SF1->F1_Formul == "N" .Or. SF1->F1_Serie #Mv_Par03
      SF1->(DbSkip())
      Loop
   EndIf
      
   SA2->(DbSeek(xFilial("SA2") + SF1->F1_Fornece + SF1->F1_Loja))
   SD1->(DbSeek(xFilial("SD1") + SF1->F1_Doc + SF1->F1_Serie + SF1->F1_Fornece + SF1->F1_Loja))
   SF4->(DbSeek(xFilial("SF4") + SD1->D1_TES))
                                               
   nLi        := 0
   nTotItens  := 20                   
   nVlrBruto  := 0
                    
   Cabec("MAPA  CEGO", "", "", NomeProg, Tamanho, 1)
   
   @ PRow() + 1, 00 PSay "Nota Fiscal:"   
   @ PRow()    , 15 PSay SF1->F1_SERIE + " / " + SF1->F1_DOC
   @ PRow() + 1, 00 PSay "Fornecedor:"
   @ PRow()    , 15 PSay AllTrim(SA2->A2_Cod) + "/" + SA2->A2_Loja + " - " + SA2->A2_Nome
   @ PRow() + 1, 00 PSay Replicate("-", 80)
   @ PRow() + 1, 00 PSay "Produto"
   @ PRow()    , 65 PSay "Quantidade"
   @ PRow() + 1, 00 PSay Replicate("-", 80)

   While !SD1->(Eof()) .And. SD1->D1_Filial  == xFilial("SD1");
                       .And. Sd1->D1_Filial  == SF1->F1_Filial;
                       .And. SD1->D1_Doc     == SF1->F1_Doc;
                       .And. SD1->D1_Serie   == SF1->F1_Serie;
                       .And. SD1->D1_Fornece == SF1->F1_Fornece;
                       .And. SD1->D1_Loja    == SF1->F1_Loja
                       
   		If PRow() > 62
   			Cabec("MAPA  CEGO", "", "", NomeProg, Tamanho, 1)
   			@ PRow() + 1,  00 PSay "Produto"
   			@ PRow()    , 100 PSay "Quantidade"
   			@ PRow() + 1,  00 PSay Replicate("-", 80)
   		EndIf
          
      SB1->(DbSeek(xFilial("SB1")+SD1->D1_Cod))       // PRODUTO      
	  
      //@ PRow()+1, 00   PSay Chr(27) + Chr(15)
      @ PRow()+1, 001  PSay AllTrim(SD1->D1_Cod) + " / "  + AllTrim(SB1->B1_LOCPAD) + " - " + AllTrim(SB1->B1_DESC)
      @ PRow()  , 65  PSay Replicate("_", 15)
      SD1->(DbSkip())
   End
   
   @ PRow() + 1, 00 PSay Replicate("-", 80)
   @ PRow() + 1, 00 PSay "Usuario: " + cUserName
   
   @ PRow() + 2, 00 PSay Replicate("_", 20)
   @ PRow()    , 25 PSay Replicate("_", 20)
   @ PRow()    , 50 PSay Replicate("_", 30)
   @ PRow() + 1, 05 PSay "Estoque"
   @ PRow()    , 30 PSay "Frete"
   @ PRow()    , 60 PSay "Conferente"
   
   SF1->(DbSkip())
   Eject
End

SetPgEject(.F.) 
Ms_Flush()                      //Libera fila de relatorios em spool
Set Device  To Screen
Set Printer To
If aReturn[5] == 1
   Set Printer TO 
   OurSpool(WnRel)
Endif