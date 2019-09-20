#include "rwmake.ch"
User Function ImpPed()
Local cString   := "SC5"  // nome do arquivo a ser impresso
Local tamanho   := "P"    // P(80c), M(132c),G(220c)
Local nLastKey  := 0
Local titulo    := "TITULO DO CABECALHO"
Local cDesc1    := "Este programa fará a impres- "
Local cDesc2    := "são de pedidos de Venda.     "
Local cDesc3    := "                             " 
Local cabec1    := "Linha1 do titulo de cabecalhos"
Local cabec2    := "Linha2 do titulo de cabecalhos"
Local nomeprog  := "IMPPED"  // nome do programa que aparece no cabecalho do relatorio
Local wnrel     := "IMPPED"  // nome do arquivo que sera gerado em disco
Local cPerg 		:= "IMPPE2"
Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAliasTmp := GetNextAlias()

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SC5"  // nome do arquivo a ser impresso
Private tamanho   := "P"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Pedidos de Venda"
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são de pedidos de Venda.     "
Private cDesc3    := "                             " 
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

Pergunte(cPerg, .T.)

if nLastKey == 27
  return
endIf

wnrel:=SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)

if nLastKey == 27
  return
endIf


SetDefault(aReturn,cString)
if nLastKey == 27
	return
endIf

BeginSql Alias cAliasTmp
	select c5_filial, c5_num, c5_emissao, C5_VEND1, 
	c5_cliente, c5_lojacli, c5_transp, c5_CondPag, C5_MenNota
	from %table:SC5%
	where d_e_l_e_t_ = ' '
	and c5_vend1 >= %Exp:MV_PAR01%
	and c5_vend1 <= %Exp:MV_PAR02%
	and c5_emissao >= %Exp:MV_PAR03%
	and c5_emissao <= %Exp:MV_PAR04%
	order by c5_vend1, c5_num
EndSql

PrCabec(cAliasTmp)

While (cAliasTmp)->(!Eof())
	SC6->(DbsetOrder(01))   
	SC6->(DbSeek(xFilial("SC6") + (cAliasTmp)->C5_Num))
	SA4->(DbsetOrder(01))
	SA4->(DbSeek(xFilial("SA4") + (cAliasTmp)->C5_Transp))
	SA1->(DbsetOrder(01))
	SA1->(DbSeek(xFilial("SA1") + (cAliasTmp)->C5_Cliente + (cAliasTmp)->C5_LojaCli))
	@ PRow() + 1,          00 PSay "PEDIDO       : " + (cAliasTmp)->C5_Num
	@ PRow() + 1,          00 PSay "Cliente      : " + (cAliasTmp)->C5_Cliente + "/" + (cAliasTmp)->C5_LojaCli
	@ PRow()    ,          36 PSay SA1->A1_Nome
	@ PRow() + 1,          00 PSay "Transportador: " + (cAliasTmp)->C5_Transp
	@ PRow()    ,          36 PSay SA4->A4_Nome
	@ PRow() + 1,          00 PSay "Cond de Pagto: " + (cAliasTmp)->C5_CondPag
	@ PRow()    ,          36 PSay AllTrim(SE4->E4_Descri)
	@ PRow() + 1,          00 PSay "CNPJ         : " 
	@ PRow()    , PCol() + 00 PSay SA1->A1_CGC Picture "@R 99.999.999/9999-99"
	@ PRow()    ,          36 PSay AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST)
	@ PRow() + 1,          00 PSay Repli('-', 80)
	
	@ PRow() + 2,          00 PSay 'Item'
	@ PRow()    ,          05 PSay 'Codigo'
	@ PRow()    ,          14 PSay 'Descricao'
	@ PRow()    ,          44 PSay 'Quant.'
	@ PRow()    ,          52 PSay 'Fator'
	@ PRow()    ,          58 PSay 'Vlr.Unit.'
	@ PRow()    ,          71 PSay 'Vlr.Total'
	@ PRow() + 1,          00 PSay Repli('-', 80)
	@ Prow()    ,          00 PSay Chr(27) + Chr(18)           //Modo Normal	
	SC6->(DbSeek(xFilial("SC6") + (cAliasTmp)->C5_Num))
	nSomaNota := 0
	nItens    := 1
	cOrdC9    := SC9->(IndexOrd())
	SC9->(DbSetOrder(1))     //Pedido + Item + Sequencia
	While SC6->(!Eof()) .And. SC6->C6_Filial == xFilial("SC6");
	                    	.And. SC6->C6_Num    == (cAliasTmp)->C5_Num
		@ PRow() + 1, 01 PSay StrZero(nItens, 2)
		@ PRow()    , 05 PSay Left(SC6->C6_PRODUTO, 7)
		@ PRow()    , 14 PSay SubStr(SC6->C6_DESCRI,1,30)
		if len(AllTrim(SC6->C6_DESCRI)) > 30
			@ PRow()+1  , 14 PSay SubStr(SC6->C6_DESCRI,31,30)           
		endIf
		nSomaNota := nSomaNota + (SC6->C6_PrcVen * SC6->C6_QtdVen)
//		if SC6->C6_IMPUNI == "1"	// IMPRESSAO 1 UN MEDIDA		
		@ PRow()    , 39 PSay SC6->C6_QtdVen  Picture '@E 999,999.99'
		@ PRow()    , 53 PSay SC6->C6_UM
		@ PRow()    , 57 PSay SC6->C6_PrcVen  Picture '@E 999,999.99'  
//		else
//			@ PRow()    , 39 PSay SC6->C6_UNSVEN Picture '@E 999,999.99' //QUANTIDADE
//	    @ PRow()    , 53 PSay SC6->C6_SEGUM  
//	    @ PRow()    , 57 PSay SC6->C6_PrcSu  Picture '@E 999,999.99'      		
//		endIf
		@ PRow()    , 70 PSay SC6->C6_Valor   Picture '@E 999,999.99'  
		@ PRow() + 1, 00 PSay Repli('-', 80)
		nItens := nItens + 1
		SC6->(DbSkip())
		if PRow() > 52  
			@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
			@ PRow() + 1,         00 PSay "Solicitante:"
			@ PRow()    , PCol() + 2 PSay (cAliasTmp)->C5_Vend1
			SA3->(DbSetOrder(1))
			SA3->(DbSeek(xFilial("SA3") + (cAliasTmp)->C5_Vend1))
			@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
			@ PRow() + 2,         15 PSay 'Listagem parcial! Favor anexar proxima pagina.'
			Eject
		  SETPRC(0,0)
		  @ PRow(), 00 PSay AvalImp(80) // seta o tamanho do relatório	
	 		@ PRow()    ,          00 PSay Repli('-', 80)
	 		@ PRow() + 1,          00 PSay "PEDIDO       : " + (cAliasTmp)->C5_Num
	  	@ PRow() + 1,          00 PSay "Cliente      : " + (cAliasTmp)->C5_Cliente + "/" + (cAliasTmp)->C5_LojaCli
		  @ PRow()    , PCol() + 12 PSay SA1->A1_Nome
		  @ PRow() + 1,          00 PSay "Transportador: " + (cAliasTmp)->C5_Transp
		  @ PRow()    , PCol() + 15 PSay SA4->A4_Nome
		  @ PRow() + 1,          00 PSay "Cond de Pagto: " + (cAliasTmp)->C5_CondPag
		  @ PRow()    , PCol() + 18 PSay AllTrim(SE4->E4_Descri)
		  @ PRow() + 1,          00 PSay "CNPJ         : " 
		  @ PRow()    , PCol() + 00 PSay SA1->A1_CGC Picture "@R 99.999.999/9999-99"  +  "   " + AllTrim(SA1->A1_MUN) + " - " + SA1->A1_EST
		  @ PRow() + 1,          00 PSay Repli('-', 80)
		  @ PRow() + 1,          00 PSay 'ITEM'      
		  @ PRow()    ,          05 PSay 'CODIGO'	
		  @ PRow()    ,          14 PSay 'DESCRICAO'		
		  @ PRow()    ,          44 PSay 'QUANT.'	
		  @ PRow()    ,          52 PSay 'UND.'		
		  @ PRow()    ,          58 PSay 'VLR.UNIT.'
		  @ PRow()    ,          71 PSay 'VLR.TOTAL'	
		  @ PRow() + 1,          00 PSay Repli('-', 80)
	   	endIf
	Enddo
	@ PRow() + 1, 064 PSay 'TOTAL:'
	@ PRow() + 0, 070 PSay nSomaNota        Picture '@E 999,999.99'
	@ PRow() + 1, 000 PSay Repli('-', 80)
	SC9->(DbSetOrder(cOrdC9))
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + (cAliasTmp)->C5_Vend1))
	@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
	@ PRow()    ,         43 PSay "( ) - 1   ( ) - 2   ( ) - 3   ( ) - 4"
	@ PRow() + 1,         00 PSay "Solicitante:"
	@ PRow()    , PCol() + 2 PSay (cAliasTmp)->C5_Vend1
	@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
	@ PRow() + 2,         00 PSay "Obs."+ (cAliasTmp)->C5_MenNota
	@ PRow() + 1, 000 PSay Repli('-', 80)
	
	#IFNDEF WINDOWS
	If LastKey()==286 // ALT + A
	  @PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
	  Exit
	Endif
	#ENDIF
	(cAliasTmp)->(DbSkip())
EndDo
//    Set Device to Screen
If aReturn[5] == 1
	Set Printer To
  Commit
  ourspool(wnrel) //Chamada do Spool de Impressao
Endif
SetPrc(0,0)	
MS_FLUSH() //Libera fila de relatorios em spool
//EndIf
SetPrc(0,0)	
//RestArea(Area)
Return .T.

Static Function AjustaSX(cPerg)
PutSx1(cPerg,"01","Vendedor Inicial ?","Vendedor Inicial ?","Vendedor Inicial ?", "mv_vin", "C", 6, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Vendedor Final ?","Vendedor Final ?","Vendedor Final ?", "mv_fin", "C", 6, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Data Inicial ?","Data Inicial ?","Data Inicial ?", "mv_din", "D", 8, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Data Final ?","Data Final ?","Data Final ?", "mv_dfi", "D", 8, 0, ,"G", "", "", "", "","MV_PAR04")
Return Nil

Static Function PrCabec(cAliasTmp)
@ PRow(), 00 PSay AvalImp(80) // seta o tamanho do relatório	
@ PRow()    ,          00 PSay Repli('-', 80)
@ PRow() + 1,          00 PSay 'Cantu'
@ PRow()    ,          35 PSay SToD((cAliasTmp)->C5_Emissao)
@ PRow()    ,          66 PSay 'Hora: ' + Time()
@ PRow() + 1,          00 PSay Repli('-', 80)
Return NIl