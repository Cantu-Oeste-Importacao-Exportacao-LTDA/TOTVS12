#include "rwmake.ch"
User Function Rju004()

SetPrvt("TITULO,CDESC1,CDESC2,CDESC3,CSTRING,AORD")
SetPrvt("WNREL,LBLOQUEADO,CPEDIDOS,CPERG,ARETURN,NLASTKEY")
SetPrvt("TAMANHO,NTIPO,NPAG,ADBF,CARQ,CARQIND")
SetPrvt("CENTREG,CPROD,CDESC,CLOCAL,CORDEM,CUM")
SetPrvt("NSOMAPRODU,NPED,NPESO,nSomaPeso,nTotalPeso,ntotitem,nitenstotal,nitem")   

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())


/*
+-----------+------------------------------------------+------+----------+
| Funcao    | RJU004                                   | Data | 06.06.06 |
+-----------+------------------------------------------+------+----------+
| Descricao | Romaneio de Cargas                                         |
+-----------+------------------------------------------------------------+
*/  
cString  := "SF2"
cDesc1   := OemToAnsi("Este programa tem como objetivo emitir um ")
cDesc2   := OemToAnsi("romaneio de carga de produtos.")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RJU004"
aLinha   := {}
nLastKey := 0
Titulo   := "Romaneio de Vendas - Pronta Entrega"
//           00       10        20        30        40        50        60        70        80       
//           12345678901234567890123456789012345678901234567890123456789012345678901234567890
Cabec1   := "Codigo  Descricao                          Peso   Quant  Fator  Separ/Carreg/Cxs"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"

m_Pag    := 1                      //Variavel que acumula numero da pagina

WnRel    := "RJU004"               //Nome Default do relatorio em Disco

Pergunte(NomeProg)

WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",.F., Tamanho)

SetDefault(aReturn, cString,,,"P",1)

if nLastKey == 27
   Set Filter To
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Periodo Inicial                      �
//� mv_par02             // Periodo Final                        �
//� mv_par03             // Do Entregador                        �
//� mv_par04             // Ate o Entregador                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Processa( {|| GeraTmp() }, "Arquivo de Trabalho")
Return

//쿑uncao    � GeraTmp  �       �                       � Data � 18/11/98 낢�
//쿏escricao � Gera o Arquivo de Trabalho do Romaneio                     낢�

Static Function GeraTmp()
aDbf := {}
Aadd(aDbf,{"Emissao" , "D", 08, 0})
Aadd(aDbf,{"Transp " , "C", 06, 0})
Aadd(aDbf,{"Produto" , "C", 15, 0})
Aadd(aDbf,{"Desc"    , "C", 30, 0})
Aadd(aDbf,{"Grupo"   , "C",  4, 0})
Aadd(aDbf,{"Local"   , "C", 02, 0})
Aadd(aDbf,{"Quant"   , "N", 15, 2})
Aadd(aDbf,{"Pedido"  , "C", 06, 0})
Aadd(aDbf,{"UM"      , "C", 02, 0})
Aadd(aDbf,{"Ordem"   , "N", 04, 0})
Aadd(aDbf,{"Peso"    , "N", 15, 2})
Aadd(aDbf,{"CXKL"    , "C", 01, 0})

ProcRegua(SC5->(LastRec()))

cArq := CriaTrab(aDbf, .T.)

Use (cArq) Alias TRB Shared New

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao dos Indices e arquivos                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
SA4->(DbSetOrder(1))   // Filial+Codigo
SB1->(DbSetOrder(1))   // Filial+Codigo do Produto
SC5->(DbSetOrder(2))   // Filial+Emissao+Numero
SC6->(DbSetOrder(1))   // Filial+Numero

SC5->(DbSeek(xFilial("SC5") + DToS(Mv_Par01), .T.) )
SETPRC(0,0)  

While SC5->(!Eof()) .And. SC5->C5_Emissao >= Mv_Par01 .And. SC5->C5_Emissao <= Mv_Par02
   IncProc()
   
   If !Empty(SC5->C5_NOTA)
      SC5->(DbSkip())
      Loop
   Endif   		
   
   If SC5->C5_Transp >= Mv_Par03 .And. SC5->C5_Transp <= Mv_Par04
      
      //If Empty(SC5->C5_Roman)

         SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))

         While SC6->(!Eof()) .And. SC6->C6_Num == SC5->C5_Num 
             nPeso := 0
             SB1->(DbSeek(xFilial("SB1") + SC6->C6_Produto))
	             If mv_par05 == 1            
		             If SubSTR(SB1->B1_COD,1,3) == "03."
			             nPeso := SC6->C6_QTDVEN * SB1->B1_PESO
		    	         RecLock("TRB", .T.)
		        	       TRB->Emissao := SC5->C5_Emissao
		            	   TRB->Transp  := SC5->C5_Transp 
			               TRB->Produto := SC6->C6_Produto 
		    	           TRB->Desc    := SB1->B1_Desc
		        	       TRB->Grupo   := SB1->B1_Grupo
			               TRB->Local   := SC6->C6_Local
		        	       TRB->Pedido  := SC6->C6_Num
                           if SC6->C6_ImpUni == "1" //primeira unidade de medida
  		                     TRB->UM      := SC6->C6_UM
   		    	             TRB->Quant   := SC6->C6_QtdVen			                  
			               else 
			                  TRB->UM := SC6->C6_SEGUM
   		    	              TRB->Quant   := SC6->C6_UnsVen
                           endIf
//		    	           TRB->Ordem   := SB1->B1_SeqCarr
		        	       TRB->Peso    := nPeso
		        	       TRB->CXKL    := SC6->C6_IMPUNI
		            	 MsUnlock("TRB")                  
			      	Endif
				Else
		             If SubSTR(SB1->B1_COD,1,3) <> "03."
			             nPeso := SC6->C6_QTDVEN * SB1->B1_PESO
		    	         RecLock("TRB", .T.)
		        	       TRB->Emissao := SC5->C5_Emissao
		            	   TRB->Transp  := SC5->C5_Transp 
			               TRB->Produto := SC6->C6_Produto 
		    	           TRB->Desc    := SB1->B1_Desc
		        	       TRB->Grupo   := SB1->B1_Grupo
			               TRB->Local   := SC6->C6_Local
		    	           TRB->Quant   := SC6->C6_QtdVen
		        	       TRB->Pedido  := SC6->C6_Num
			               TRB->UM      := SC6->C6_UM
//		    	           TRB->Ordem   := SB1->B1_SeqCarr
		        	       TRB->Peso    := nPeso
		        	       TRB->CXKL    := SC6->C6_IMPUNI
		            	 MsUnlock("TRB")         
			 		Endif
				Endif		                     
	            SC6->(DbSkip())    					                       
         Enddo
      //EndIf
   EndIf
   
   SC5->(DbSkip())
End

TRB->(DbGoTop())

If LastRec() == 0
   MsgInfo("ATENCAO!!! Nao Foram encontrados pedidos que satisfacam os parametros digitados.", "Romaneio")
   DbSelectArea("TRB")
   TRB->(DbCloseArea("TRB"))
   Return
EndIf

cArqInd := CriaTrab(NIL,.f.)

DbSelectArea("TRB")

IndRegua("TRB", cArqInd, "StrZero(TRB->Ordem, 4)+Transp+Desc+Local+UM",,, "Selecionando Registros...")

RptStatus({|| Rel004() }, "Mapa de separacao")

Return


//쿑un뇙o    쿝el004    �       �                       � Data � 01.09.98 낢�
//쿏escri뇙o 쿔mpressao do corpo do relatorio                             낢�

Static Function Rel004()
cEntreg    := TRB->Transp
cProd      := TRB->Produto
cDesc      := TRB->Desc
cLocal     := TRB->Local
cOrdem     := StrZero(TRB->Ordem, 4)
cUM        := TRB->UM
nsomaprodu := 0
nSomaPeso  := 0
nTotalPeso := 0
ntotitem   := 0
nitenstotal:= 0
SETPRC(0,0)
CabcPar()
SetRegua(TRB->(LastRec()))
TRB->( DbGotop() )
While TRB->(!Eof() )
   cPedidos  := ""
   IncRegua()
   While TRB->(!Eof()) .And. cEntreg == TRB->Transp
      While cProd == TRB->Produto .And. TRB->transp == cEntreg ;
                                  .And. TRB->Local  == cLocal  ;
                                  .And. TRB->UM     == cUM     ;
                                  .And. TRB->(!Eof())
         If cPedidos == ""
            cPedidos  := TRB->Pedido
         Else
            If !TRB->Pedido $ cPedidos
               cPedidos  := cPedidos  + ", " + TRB->Pedido
            EndIf
         End
	     SB1->(DbSeek(xFilial("SB1")+TRB->PRODUTO))       // PRODUTO
//		 If TRB->CXKL == "1"         
	         nSomaProdu := nSomaProdu + TRB->QUANT
  //  	 Else 
	     //    nSomaProdu := nSomaProdu + (TRB->QUANT*SB1->B1_CONV)
	//         cUM := SB1->B1_SEGUM	         
    //	 Endif
    	 
    	 nSomaPeso  := nSomaPeso  + TRB->Peso      
         ntotitem   := ntotitem + TRB->QUANT   		
         TRB->(DbSkip())
      End
   
      If PRow() == 48
         @ 55        , 09 PSay SubStr(cUsuario, 07, 15)
         @ 56        , 00 PSay '-------------------------   -------------------------   ------------------------'
         @ PRow() + 2, 00 PSay '        Emitente                   Conferente                Placa do Veiculo   '
         Eject
         CabcPar()
      EndIf
//      @ PRow() + 2, 01          PSay cOrdem
      @ PRow() + 2,          00 PSay Left(cProd, 7)
      @ PRow() + 0,          08 PSay cDesc Picture '@!S30'
//      @ PRow() + 0, PCol() +  1 PSay cLocal
      @ PRow() + 0,          39 PSay nSomaPeso          Picture "@E 9,999.99"
      @ PRow() + 0,          47 PSay nSomaProdu         Picture "@E 9,999.99"
      @ PRow() + 0,          59 PSay cUM
      @ PRow() + 0,          64 PSay '_____|_____|____'
      @ PRow() + 0, 0           PSay Repl("_",61)
      cProd      := TRB->Produto
      cDesc      := TRB->Desc
      cOrdem     := StrZero(TRB->Ordem, 4)
      nTotalPeso := nTotalPeso + nSomaPeso
      nSomaPeso  := 0
      nSomaProdu := 0
      cLocal     := TRB->Local
      cUM        := TRB->UM
      nitenstotal:= nitenstotal+1      
   End

   If PRow() == 53
      Eject
      CabCPar()
   EndIf
   
   @ PRow() + 2, 00 PSay Repl("-", 80)
   @ PRow() + 1, 00 PSay ''
   @ PRow() + 1, 00 PSay "Peso Total da Carga : "    
   @ PRow()    , 25 PSay nTotalPeso     Picture "@E 999,999,999.99"
   @ PRow() + 1, 00 PSay "Tot. Itens do Mapa  : "    
   @ PRow()    , 25 PSay nItenstotal     Picture "@E 999,999,999.99"
   @ PRow() + 1, 00 PSay "Pedidos:" 
   
   For nPed := 1 To Len(cPedidos) Step 71
       If nPed == 1
          @ PRow()    , 09 PSay SubStr(cPedidos, nPed, 71)
       Else
          @ PRow() + 1, 08 PSay SubStr(cPedidos, nPed, 71)
       EndIf
   Next 

   Eject
   CabCPar()
   @ 24, 00 PSay "CONTROLE DE CAIXAS"
   @ 26, 00 PSay " T I P O  DESCRI플O                                                      QTDE
   @ 28, 00 PSay "|  X01  | Bagulho.....................................................|________|"
   @ 30, 00 PSay "|  X02  | Valor  .....................................................|________|"
   @ 32, 00 PSay "|  X03  | Caixa de 1/2 ...............................................|________|"
   @ 34, 00 PSay "|  X04  | Banana .....................................................|________|"
   @ 36, 00 PSay "|  X05  | Mam�o  .....................................................|________|"
   @ 38, 00 PSay "|  X06  | Pl�stica ...................................................|________|"

//   @ 47, 00 PSay Repl("-", 80)
   @ 48, 00 PSay "Separador:______________________________________________________________________"
   @ 50, 00 PSay "Hr. Inicio Separacao:__________________Hr. Final Separacao:_____________________"
   @ 52, 00 PSay "Hr. Inicio Separacao Ceasa:____________Hr. Final Separacao Ceasa________________"
   @ 54, 00 PSay "Carregador:_____________________________________________________________________"
   @ 56, 00 PSay "Hr. Inicio Conferencia:________________Hr. Final Conferencia:___________________"
//   @ 57, 00 PSay Repl("-", 80)

   @ 60        , 09 PSay SubStr(cUsuario, 07, 15)
   @ 61        , 02 PSay '-------------------------   -------------------------   ---------------------'
   @ PRow() + 2, 02 PSay '        Emitente                   Conferente              Placa do Veiculo  '   
   cEntreg := TRB->Transp
   
   If !TRB->(Eof())
      Eject
      CabCPar()
   EndIf
End

If aReturn[5] = 3 //** Direto na Porta 
	Eject
Endif

//Eject
DbSelectArea("TRB")
TRB->(DbCloseArea("TRB"))
Set Device To Screen
If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)
Endif
FT_PFlush()
Return


