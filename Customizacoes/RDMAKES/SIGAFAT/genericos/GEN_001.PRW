#include "rwmake.ch" 
User Function GEN001() //GENERICO 001 - PODE SER USADO POR QUALQUER EMPRESA
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ GEN001  ¦ Autor ¦   Eder Gasparin       ¦ Data ¦ 10/04/08  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Relatorio de pedidos por vendedor                          ¦¦¦
¦¦¦		       Seu objetivo e trazer informacoes sobre os pedidos feitos  ¦¦¦
¦¦¦		       pelo palm. Originalmente solicitado pela cantu Recife.     ¦¦¦ 
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico cliente CANTU - Generico                        ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU")

cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("Relatorio de condicao do pedido")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "REL003" //informacoes no SX1
aLinha   := {}
nLastKey := 0
Titulo   := "Relacao de condicao de pedidos "  
Cabec1   := "Pedido    Condicao"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.

m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "REL003"               //Nome Default do relatorio em Disco

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

RptStatus({|| ImpRel() }, "Relacao de condicao de pedido")

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif
Return


//Descri‡„o ³Impressao do Relatorio de pedidos de venda em aberto        ³±±
Static Function ImpRel()

Vendedor   := MV_PAR01
DataPed    := dtos(MV_PAR02) 
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)

DbSelectArea("HC5")
HC5->(DbSetOrder(3)) //FILIAL+COD. VENDEDOR + Emissao
HC5->(DbGoTop())
HC5->(DbSeek(xFilial("HC5") + Vendedor + DataPed))
SetRegua(HC5->(LastRec()))

//@ PRow() + 1, 0  PSay "                                                         Transportador     "+Transp
     @ PRow() +  1, 00  PSay dataPed      Picture "@S6" //numero do pedido no PALM
     @ PRow() +  1, 00  PSay Vendedor      Picture "@S6" //numero do pedido no PALM
/*     @ PRow() +  1, 00  PSay HC5->HC5_COTAC      Picture "@S6" //numero do pedido no PALM
     @ PRow()     , 12  PSay HC5->HC5_MENOTA     Picture "@S55" 
     @ PRow() +  1, 20  PSay HC5->HC5_NUM        Picture "@S6" //numero do pedido no SISTEMA     
     @ PRow() +  1, 30  PSay HC5->HC5_CLI        Picture "@S6"  
/*While HC5->(!EOF()) 
  If HC5->HC5_ID == Transp .AND. dTos(HC5->HC5_EMISS) == DataPed
     @ PRow() +  1, 00  PSay HC5->HC5_COTAC      Picture "@S6" //numero do pedido no PALM
     @ PRow()     , 12  PSay HC5->HC5_MENOTA     Picture "@S55" 
     @ PRow() +  1, 20  PSay HC5->HC5_NUM        Picture "@S6" //numero do pedido no SISTEMA     
     @ PRow() +  1, 30  PSay HC5->HC5_CLI        Picture "@S6"  
     @ PRow() +  1, 40  PSay HC5->HC5_LOJA       Picture "@S6" 
  EndIf

  HC5->(DbSkip())                            
  IncRegua()
  If dTos(HC5->HC5_EMISS) <> DataPed
     Exit
  EndIf
EndDo  */
Return