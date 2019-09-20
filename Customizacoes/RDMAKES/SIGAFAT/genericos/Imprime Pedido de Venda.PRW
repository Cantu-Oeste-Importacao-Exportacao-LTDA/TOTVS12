#include "rwmake.ch"
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ IMP_PED  ¦ Autor ¦  Eder Gasparin       ¦ Data ¦ 22/01/08  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Impressao de Pedido de Venda                               ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico cliente CANTU - Empresa Genérico                ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

User Function IMP_PED()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

SetPrvt("NSOMANOTA,NITENS,CORDC9") //cria somente as variaveis definidas pelo usuario

   cString   := "SC6"  // nome do arquivo a ser impresso
   tamanho   := "P"    // P(80c), M(132c),G(220c)
   nLastKey  := 0
   titulo    := "TITULO DA CABECALHO"
   cDesc1    := "Este programa listara ......."
   cDesc2    := "continua descricao .........."
   cDesc3    := "continua descricao .........." 
   cabec1    := "Linha1 do titulo de cabecalhos"
   cabec2    := "Linha2 do titulo de cabecalhos"
   aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
   nomeprog  := "MATA410"  // nome do programa que aparece no cabecalho do relatorio
   wnrel     := "MATA410"  // nome do arquivo que sera gerado em disco
   cPerg  	 := "IMPPED"
   m_pag     :=  1         // Variavel que acumula numero da pagina

   If !Pergunte(cPerg)
      Return
   EndIf
   nPedido   := mv_Par01

   wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)   
   if nLastKey == 27
      return
   endIf
	
   SetDefault(aReturn,cString)
   if nLastKey == 27
	  return
   endIf
   
   //³Selecao de Chaves para os arquivos                            ³
   SA1->(DbSetOrder(1))               // filial+cod           Clientes
   SA3->(DbSetOrder(1))               // filial+cod           Vendedores
   SA4->(DbSetOrder(1))               // filial+cod           Transportadoras
   SB1->(DbSetOrder(1))               // filial+cod           Produtos
   SC5->(DbSetOrder(1))               // filial+ped           Ped. Vendas
   SC6->(DbSetOrder(1))               // filial+ped+item      It. De PV

   SC5->(DbSelectArea("SC5"))
   SC5->(DbSeek(xFilial("SC5") + nPedido))

   SC6->(DbSelectArea("SC6"))
   SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))

   SA4->(DbSelectArea("SA4"))
   SA4->(DbSeek(xFilial("SA4") + SC5->C5_TRANSP))

   SA1->(DbSelectArea("SA1"))
   SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENTE))
   
   setPrc(0,0)	
   CAB_PED() //imprime cabecalho do pedido
   @ Prow()    ,          00 PSay Chr(27) + Chr(18)           //Modo Normal	
   SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))
   nSomaNota := 0
   nItens    := 1
   cOrdC9    := SC9->(IndexOrd())
   SC9->(DbSetOrder(1))     //Pedido + Item + Sequencia
   
   While SC6->(!Eof()) .And. SC6->C6_Filial == xFilial("SC6");
                    	.And. SC6->C6_Num    == SC5->C5_Num
		@ PRow() + 1, 01 PSay StrZero(nItens, 2)
		@ PRow()    , 05 PSay Left(SC6->C6_PRODUTO, 7)
		@ PRow()    , 14 PSay SubStr(SC6->C6_DESCRI,1,30)
		if len(AllTrim(SC6->C6_DESCRI)) > 30
  		   @ PRow()+1  , 14 PSay SubStr(SC6->C6_DESCRI,31,30)           
		endIf
		nSomaNota := nSomaNota + (SC6->C6_PrcVen * SC6->C6_QtdVen)
		if SC6->C6_IMPUNI == "1"	// IMPRESSAO 1 UN MEDIDA		
    		@ PRow()    , 39 PSay SC6->C6_QtdVen  Picture '@E 999,999.99'
			@ PRow()    , 53 PSay SC6->C6_UM
    		@ PRow()    , 57 PSay SC6->C6_PrcVen  Picture '@E 999,999.99'  
		else
			@ PRow()    , 39 PSay SC6->C6_UNSVEN Picture '@E 999,999.99' //QUANTIDADE
    		@ PRow()    , 53 PSay SC6->C6_SEGUM  
    		@ PRow()    , 57 PSay SC6->C6_PrcSu  Picture '@E 999,999.99'      		
		endIf
		@ PRow()    , 70 PSay SC6->C6_Valor   Picture '@E 999,999.99'  
		@ PRow() + 1, 00 PSay Repli('-', 80)
		nItens := nItens + 1
		SC6->(DbSkip())
		if PRow() > 52  
			@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
			@ PRow() + 1,         00 PSay "Solicitante:"
			@ PRow()    , PCol() + 2 PSay SC5->C5_Vend1
			SA3->(DbSetOrder(1))
			SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
			@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
			@ PRow() + 2,         15 PSay 'Listagem parcial! Favor anexar proxima pagina.'
			Eject
		    SETPRC(0,0)
            CAB_PED() //imprime cabecalho do pedido
   	    endIf
	Enddo
	@ PRow() + 1, 064 PSay 'TOTAL:'
	@ PRow() + 0, 070 PSay nSomaNota        Picture '@E 999,999.99'
	@ PRow() + 1, 000 PSay Repli('-', 80)
	SC9->(DbSetOrder(cOrdC9))

	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
	@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
	@ PRow()    ,         43 PSay "( ) - 1   ( ) - 2   ( ) - 3   ( ) - 4"
	@ PRow() + 1,         00 PSay "Solicitante:"
	@ PRow()    , PCol() + 2 PSay SC5->C5_Vend1
	@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
	@ PRow() + 2,         00 PSay "Obs."+ SC5->C5_MenNota
  	If aReturn[5] = 3 //** Direto na Porta 
	Endif	
	
    #IFNDEF WINDOWS
      If LastKey()==286 // ALT + A
          @PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
          Exit
      Endif
    #ENDIF
    If aReturn[5] == 1
	    Set Printer To
	    Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
    Endif
 	SetPrc(0,0)	
    MS_FLUSH() //Libera fila de relatorios em spool
SetPrc(0,0)	
Return .T.

Static Function CAB_PED // imprime cabeçalho do pedido
   @ PRow()    ,          00 PSay Repli('-', 80)
   @ PRow() + 1,          00 PSay 'Cantu'
   @ PRow()    ,          35 PSay DtoC(SC5->C5_Emissao)
   @ PRow()    ,          66 PSay 'Hora: ' + Time()
   @ PRow() + 1,          00 PSay Repli('-', 80)
   @ PRow() + 1,          00 PSay 'PEDIDO       : '  + SC5->C5_Num
   @ PRow() + 1,          00 PSay 'Cliente      : '  + SC5->C5_Cliente + "/" + SC5->C5_LojaCli
   @ PRow()    , PCol() + 02 PSay SA1->A1_Nome
   @ PRow() + 1,          00 PSay 'Transportador: '  + SC5->C5_Transp
   @ PRow()    , PCol() + 05 PSay SA4->A4_Nome
   @ PRow() + 1,          00 PSay Repli('-', 80)
   @ Prow() + 1,          00 PSay Chr(27) + Chr(120) + Chr(0) //Modo Draft
   @ PRow() + 2,          00 PSay 'Item'      
   @ PRow()    ,          05 PSay 'Codigo'	
   @ PRow()    ,          14 PSay 'Descricao'		
   @ PRow()    ,          44 PSay 'Quant.'	
   @ PRow()    ,          52 PSay 'Fator'		
   @ PRow()    ,          58 PSay 'Vlr.Unit.'
   @ PRow()    ,          71 PSay 'Vlr.Total'	
   @ PRow() + 1,          00 PSay Repli('-', 80)
Return .T.
