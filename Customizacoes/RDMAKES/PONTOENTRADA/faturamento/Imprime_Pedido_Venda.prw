#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MATA410   ºAutor  ³Microsiga           º Data ³  12/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ PE para impressao de pedido de venda executado após inclu- º±±
±±º          ³ são ou alteração							                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico Cantu                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterado  ³ Gustavo Lattmann 21/10/14 - Incluídos novos campos no rela-º±±
±±º			 ³ tório para atender algumas particularidades da Level		  º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±± 
±±ºAlterado  ³ Gustavo Lattmann 08/12/14 - Incluídos novo controle em relaº±±
±±º			 ³ cao aos campos de uso exclusivo do porcelanato			  º±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATA410()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if isInCallStack("U_IMPPDCSV")
	return
endif

SetPrvt("NSOMANOTA,NITENS,CORDC9","NPESOTOTAL") //cria somente as variaveis definidas pelo usuario

nOpc := AVISO("Pedido de Venda", "Deseja Imprimir Pedido de Venda?", { "Resumido", "Detalhado", "Não" }, 1)

If nOpc == 3
	Return
ElseIf nOpc == 1 

   	tamanho   := "P"    // P(80c), M(132c),G(220c)
   	nTamanho  := 80

ElseIf nOpc == 2
   
   	tamanho   := "M"    // P(80c), M(132c),G(220c)
   	nTamanho  := 120

EndIf

nLastKey  := 0
cString   := "SC6"  // nome do arquivo a ser impresso
titulo    := "Pedido " + SC5->C5_NUM
cDesc1    := "Este programa irá imprimir um espelho do pedido de venda"  
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
wnrel     := "MATA410"  // nome do arquivo que sera gerado em disco
m_pag     :=  1         // Variavel que acumula numero da pagina

wnrel	 := SetPrint(cString,wnrel,,titulo,cDesc1,,,.F.,,.T.,tamanho)
If nLastKey == 27
	return
EndIf

SetDefault(aReturn,cString)
If nLastKey == 27
	Return
EndIf
   
SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))
SA4->(DbSeek(xFilial("SA4") + SC5->C5_Transp))     
SE4->(DbSeek(xFilial("SE4") + SC5->C5_CONDPAG))
SA1->(DbSeek(xFilial("SA1") + SC5->C5_Cliente + SC5->C5_LojaCli))    
DA0->(DbSeek(xFilial("DA0") + SC5->C5_Tabela ))   
  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
//³Imprime o cabeçalho do pedido³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
SetPrc(0,0)	
	@ PRow()    ,          00 PSay Repli('-', nTamanho)
 	@ PRow() + 1,          00 PSay SM0->M0_NOME
  	@ PRow()    ,          35 PSay DtoC(SC5->C5_Emissao)
   	@ PRow()    ,          45 PSay 'Hora: ' + Time()
   	@ PRow() + 1,          00 PSay Repli('-', nTamanho)
   	@ PRow() + 1,          00 PSay "Pedido       : " + SC5->C5_Num      
   	@ PRow()    ,          45 PSay "Licitação    : " + SC5->C5_COTACAO   
   	@ PRow() + 1,          00 PSay "Cliente      : " + SC5->C5_Cliente + "/" + SC5->C5_LojaCli
   	@ PRow()    ,          45 PSay SA1->A1_Nome
   	@ PRow() + 1,          00 PSay "CNPJ         : " 
   	@ PRow()    , PCol() + 00 PSay SA1->A1_CGC Picture "@R 99.999.999/9999-99"
   	@ PRow()    ,          45 PSay AllTrim(SA1->A1_MUN) + " - " + AllTrim(SA1->A1_EST)      
   	@ PRow() + 1,          00 PSay "E-mail       : " + SA1->A1_EMAIL   
   	@ PRow() + 1,          00 PSay "Transportador: " 
	@ PRow()    , PCol() + 00 PSay SA4->A4_CGC Picture "@R 99.999.999/9999-99"
   	@ PRow()    ,          45 PSay SA4->A4_Nome 
   	@ PRow() + 1,          00 PSay "Cod Transp   : " + SC5->C5_Transp    
   	@ PRow()    ,          45 PSay SA4->A4_EMAIL   
   	@ PRow() + 1,          00 PSay "Cond de Pagto: " + SC5->C5_CondPag
   	@ PRow()    ,          45 PSay AllTrim(SE4->E4_Descri)   
   	@ PRow() + 1,          00 PSay "Tabela Preço : " + SC5->C5_Tabela    
   	@ PRow()    ,          45 PSay AllTrim(DA0->DA0_DESCRI)
   	@ PRow() + 1,          00 PSay Repli('-', nTamanho)
   	
   	@ PRow() + 2,          00 PSay 'Item'      
   	@ PRow()    ,          04 PSay 'Codigo'	
   	@ PRow()    ,          20 PSay 'Descricao'		
   	@ PRow()    ,          46 PSay 'Quant.'	
   	@ PRow()    ,          52 PSay 'Fator'		
   	@ PRow()    ,          58 PSay 'Vlr.Unit.'
   	@ PRow()    ,          71 PSay 'Vlr.Total'	
   	
   	//Detalhado
   	If nOpc == 2
	   	@ PRow()    ,          84 PSay 'Lote'
	   	@ PRow()    ,          98 PSay 'Peso'      
	   	@ PRow()    ,         108 PSay 'Volume'         
   	EndIf 
   	
   	@ PRow() + 1,          00 PSay Repli('-', nTamanho)
   	@ Prow()    ,          00 PSay Chr(27) + Chr(18)           //Modo Normal	
   	SC6->(DbSeek(xFilial("SC6") + SC5->C5_Num))
   	nSomaNota := 0
   	nPesoTotal := 0
   	nItens    := 1
   	cOrdC9    := SC9->(IndexOrd())
   	SC9->(DbSetOrder(1))     //Pedido + Item + Sequencia
   	While SC6->(!Eof()) .And. SC6->C6_Filial == xFilial("SC6") .And. SC6->C6_Num == SC5->C5_Num
   
		@ PRow() + 1, 01 PSay StrZero(nItens, 2)
		@ PRow()    , 04 PSay Left(SC6->C6_PRODUTO, 15)
   		@ PRow()    , 20 PSay SubStr(SC6->C6_DESCRI,1,20)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Quebra em linhas a descrição do produto caso seja maior que 20 caracteres³
   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		If len(AllTrim(SC6->C6_DESCRI)) > 20
  		   @ PRow()+1  , 20 PSay SubStr(SC6->C6_DESCRI,21,20)           
		EndIf
	
   		nSomaNota 	+= (SC6->C6_PrcVen * SC6->C6_QtdVen)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica em qual unidade de medida foi realizada a venda³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SC6->C6_IMPUNI == "1"	// IMPRESSAO 1 UN MEDIDA		
	    	@ PRow()    , 41 PSay SC6->C6_QtdVen  	Picture '@E 999,999.99'
			@ PRow()    , 53 PSay SC6->C6_UM
	    	@ PRow()    , 57 PSay SC6->C6_PrcVen  	Picture '@E 999,999.99'  
		Else
			@ PRow()    , 41 PSay SC6->C6_UNSVEN 	Picture '@E 999,999.99' //QUANTIDADE
	    	@ PRow()    , 53 PSay SC6->C6_SEGUM  
	    	@ PRow()    , 57 PSay SC6->C6_PrcSu 	Picture '@E 999,999.99'      		
		EndIf
   
   		@ PRow()    , 70 PSay SC6->C6_Valor    		Picture '@E 999,999.99'     
	
   		//detalhado
   		If nOpc == 2
	   		@ PRow()    , 82 PSay Alltrim(SC6->C6_LOTECTL)
		
	   		SB1->(DbSeek(xFilial("SB1") + SC6->C6_Produto))
	   		@ PRow()	, 96 Psay (SC6->C6_QTDVEN * SB1->B1_PESO) Picture '@E 999,999.99'
			@ PRow()	, 106 Psay SC6->C6_UNSVEN	Picture '@E 999,999.99'    
			nPesoTotal 	+= (SC6->C6_QTDVEN * SB1->B1_PESO)
		EndIf				
		@ PRow() + 1, 00 PSay Repli('-', nTamanho)
		nItens := nItens + 1
		SC6->(DbSkip())

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pula para a próxima página do relatório³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If PRow() > 52  
			@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
			@ PRow() + 1,         00 PSay "Solicitante:"
			@ PRow()    , PCol() + 2 PSay SC5->C5_Vend1
			SA3->(DbSetOrder(1))
			SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
			@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
			@ PRow() + 2,         15 PSay 'Listagem parcial! Favor anexar proxima pagina.'
			Eject
		    SETPRC(0,0)
	 		@ PRow()    ,          00 PSay Repli('-', nTamanho)
	 		@ PRow() + 1,          00 PSay "PEDIDO       : " + SC5->C5_Num
	  		@ PRow() + 1,          00 PSay "Cliente      : " + SC5->C5_Cliente + "/" + SC5->C5_LojaCli
		    @ PRow()    , PCol() + 12 PSay SA1->A1_Nome
		    @ PRow() + 1,          00 PSay "Transportador: " + SC5->C5_Transp
		    @ PRow()    , PCol() + 15 PSay SA4->A4_Nome
		    @ PRow() + 1,          00 PSay "Cond de Pagto: " + SC5->C5_CondPag
		    @ PRow()    , PCol() + 18 PSay AllTrim(SE4->E4_Descri)
		    @ PRow() + 1,          00 PSay "CNPJ         : " 
		    @ PRow()    , PCol() + 00 PSay SA1->A1_CGC Picture "@R 99.999.999/9999-99"  +  "   " + AllTrim(SA1->A1_MUN) + " - " + SA1->A1_EST
		    @ PRow() + 1,          00 PSay Repli('-', nTamanho)
		    @ PRow() + 1,          00 PSay 'ITEM'      
		    @ PRow()    ,          05 PSay 'CODIGO'	
		    @ PRow()    ,          14 PSay 'DESCRICAO'		
		    @ PRow()    ,          44 PSay 'QUANT.'	
		    @ PRow()    ,          52 PSay 'UND.'		
		    @ PRow()    ,          58 PSay 'VLR.UNIT.'
		    @ PRow()    ,          71 PSay 'VLR.TOTAL'	  		    
		    @ PRow() + 1,          00 PSay Repli('-', nTamanho)
   	    EndIf
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime rodapé com totais e observações³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ PRow() + 1, 064 PSay 'TOTAL:'
	@ PRow() 	, 070 PSay nSomaNota        Picture '@E 999,999.99'  
	If nOpc = 2
		@ PRow() 	, 096 Psay nPesoTotal	  	Picture '@E 999,999.99'  
	EndIf
	@ PRow() + 1, 000 PSay Repli('-', nTamanho)
	SC9->(DbSetOrder(cOrdC9))
	DbSelectArea("SA3")
	SA3->(DbSetOrder(1))
	SA3->(DbSeek(xFilial("SA3") + SC5->C5_Vend1))
	@ PRow() + 1,         00 PSay "Usuario:      " + SubStr(cUsuario, 07, 15)
	@ PRow()    ,         43 PSay "( ) - 1   ( ) - 2   ( ) - 3   ( ) - 4"
	@ PRow() + 1,         00 PSay "Solicitante:"
	@ PRow()    , PCol() + 2 PSay SC5->C5_Vend1
	@ PRow()    , PCol() + 2 PSay ' - ' + SA3->A3_NReduz
	@ PRow() + 2,         00 PSay "Mensagem Nota: "+ SC5->C5_MenNota     
	@ PRow() + 1, 		  00 PSay "Obs Pedido   : "+ SubStr(SC5->C5_OBSPED,1,80)
	If len(AllTrim(SC5->C5_OBSPED)) > 80
	   @ PRow()+1  , 10 PSay SubStr(SC5->C5_OBSPED,81,80)           
	EndIf		
	
    #IFNDEF WINDOWS
      If LastKey()== 286 // ALT + A
          @PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
          Exit
      Endif
    #ENDIF
	//    Set Device to Screen
    If aReturn[5] == 1
    	Set Printer To
    Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
    Endif
 	SetPrc(0,0)	
    MS_FLUSH() //Libera fila de relatorios em spool
	SetPrc(0,0)	

Return