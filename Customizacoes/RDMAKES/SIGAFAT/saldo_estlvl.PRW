#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PRINT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELESTLVL  ºAutor  ³Guilherme Kaminski º Data ³  21/10/2014 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatório demonstrativo do posicionamento de estoque de     º±±
±±º          ³forma analitica ou simplicada.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³CANTU                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
   

USER FUNCTION RELESTLVL()    

Private cDesc     := "O relatório tem como objetivo a impressão"
Private cDesc1    := "da posicao de estoque" 
Private wnrel     := "RELESTLVL" //nome do arquivo que vai ser gravado no servidor 
Private aReturn   := {"Zebrado", 1,"Administracao", 2, 2, 1,"",0}
Private cString   := "SB2"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0     
Private cPerg 	:= "RELESTLVL"         
Private titulo    := "RELATORIO DE POSICAO DE ESTOQUE"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Executa funções de verificação do grupo de perguntas utilizado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ


AJUSTASX1(cPerg)    

If PERGUNTE(cPerg, .T.)       

   	wnrel	 := SetPrint(cString,wnrel,,titulo,cDesc,cDesc1,,.F.,,.T.,tamanho)
   
   if nLastKey == 27
      Return
   endIf
   
   SetDefault(aReturn, cString)
   if nLastKey == 27
	return
endIf

EndIf	                                       
 


RptStatus( {|| RESIN() }, "Aguarde...", "Processando o relatório...",.T.)
  
Return
        
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SALDO_ESTLVLºAutor  ³Guilherme Kaminskiº Data ³  11/13/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela impressão do relátorio da forma    º±±
±±º          ³ sintética                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


Static Function RESIN()     

Local nLastKey  := 0
Local nomeprog  := "RELESTLVL"  // nome do programa que aparece no cabecalho do relatorio
Local wnrel     := "RELESTLVL" //nome do arquivo que vai ser gravado no servidor  
Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local cAlias 	:= GetNextAlias()     
Local cString    := "SB2"    


BeginSql Alias cAlias
SELECT PRODUTO.B1_COD  AS CODIGO,
  (PRODUTO.B1_DESC)  AS DESCRICAO,
 PRODUTO.B1_CONV  AS QT_CAIXA,
( SELECT TRUNC((SUM(EST.B2_QATU - EST.B2_RESERVA)),3) 
    FROM %table:SB2% EST 
    WHERE EST.B2_COD = PRODUTO.B1_COD ) AS ESTOQUE ,
( SELECT TRUNC(SUM(C6.C6_QTDVEN),3) 
    FROM %table:SC6% C6 
    WHERE C6.C6_BLQ = ' ' 
     AND C6.C6_NOTA = '         ' 
     AND C6.C6_FILIAL = %xFilial:SC6%
     AND C6.D_E_L_E_T_ = ' ' 
     AND C6.C6_PRODUTO = PRODUTO.B1_COD ) AS PEDIDO_VENDA,
  ( SELECT TRUNC((SUM(C7.C7_QUANT)),3) 
    FROM %table:SC7% C7 
    WHERE C7.D_E_L_E_T_ = ' ' 
     AND C7.C7_RESIDUO = ' ' 
     AND C7.C7_ENCER = ' ' 
     AND  C7.C7_PRODUTO = PRODUTO.B1_COD ) AS PEDIDO_COMPRA
  FROM SB1CMP PRODUTO 
  WHERE 0=0 AND PRODUTO.B1_COD between %Exp:MV_PAR01% and %Exp:MV_PAR02%
    AND  PRODUTO.D_E_L_E_T_ = ' '  
      ORDER BY PRODUTO.B1_COD
EndSql        
                  
SetRegua(0)

aCabec(cAlias)              
 
@ Prow() + 2,          00 Psay 'Codigo'
@ Prow()    ,          15 Psay 'Descrição'
@ Prow()    ,          44 Psay 'Qnt. Caixas'
@ prow()    ,          57 Psay 'Qnt. Estoque'
@ Prow()    ,          71 Psay 'Q. pd. Venda'
@ Prow()    ,          85 Psay 'Q. pd. Compra'
@ Prow() + 1,          00 Psay Repli('-', 90)             



While (cAlias)->(!Eof())     
            
	@ Prow() + 1,          00 Psay ((cAlias)->CODIGO)
	@ Prow()    ,          15 Psay SubStr((cAlias)->DESCRICAO,1,20)        
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Quebra em linhas a descrição do produto caso seja maior que 20 caracteres³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	If len(AllTrim((cAlias)->DESCRICAO)) > 20
  		   @ PRow()+1  , 20 PSay SubStr((cAlias)->DESCRICAO,21,20)           
	EndIf
		
    @ Prow()    ,          44 Psay ((cAlias)->QT_CAIXA)	
    @ Prow()    ,          57 Psay ((cAlias)->ESTOQUE)	
    @ Prow()    ,          71 Psay ((cAlias)->PEDIDO_VENDA)
    @ Prow()    ,          86 Psay ((cAlias)->PEDIDO_COMPRA)

    If Prow() > 63    
       
        @ Prow() + 2,          00 Psay 'Codigo'
    	@ Prow()    ,          15 Psay 'Descrição'
    	@ Prow()    ,          44 Psay 'Qnt. Caixas'
    	@ prow()    ,          57 Psay 'Qnt. Estoque'
    	@ Prow()    ,          71 Psay 'Q. pd. Venda'
    	@ Prow()    ,          85 Psay 'Q. pd. Compra'
    	@ Prow() + 1,          00 Psay Repli('-', 90) 
		While (cAlias)->(!Eof())     
		
			@ Prow() + 1,          00 Psay ((cAlias)->CODIGO)
		    @ Prow()    ,          15 Psay SubStr((cAlias)->DESCRICAO,1,20)   
		    
    	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Quebra em linhas a descrição do produto caso seja maior que 20 caracteres³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
			If len(AllTrim((cAlias)->DESCRICAO)) > 20
  		   		@ PRow()+1  , 20 PSay SubStr((cAlias)->DESCRICAO,21,20)
			EndIf
		  
		    @ Prow()    ,          44 Psay ((cAlias)->QT_CAIXA)     
		    @ Prow()    ,          57 Psay ((cAlias)->ESTOQUE)      
		    @ Prow()    ,          71 Psay ((cAlias)->PEDIDO_VENDA) 
		    @ Prow()    ,          86 Psay ((cAlias)->PEDIDO_COMPRA)    
		    (cAlias)->(dbSkip())
		EndDo    
   EndIf  
   (cAlias)->(dbSkip())
Enddo      

//    Seta o dispositivo de impressão
    If aReturn[5] == 1
	    Set Printer To
	    Commit
        ourspool(wnrel) //Chamada do Spool de Impressao
    Endif
 	SetPrc(0,0)	
    MS_FLUSH() //Libera fila de relatorios em spool
    
SetPrc(0,0)	
//RestArea(Area)
Return .T.
 

 
Static Function aCabec(cAlias)
@ PRow(), 00 PSay AvalImp(132) // seta o tamanho do relatório	
@ PRow()    ,          00 PSay Repli('-',90)                  
@ PRow() + 1,          00 PSay 'Filial: ' + SM0->M0_NOME
@ PRow()    ,          35 PSay Date()
@ PRow()    ,          66 PSay 'Hora: ' + Time()
@ PRow() + 1,          00 PSay Repli('-', 90)           

Return  



Static Function AjustaSX1( cPerg )
**********************************
       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Definição dos itens do grupo de perguntas a ser criado³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
PutSx1(cPerg, "01","Produto de ?   		","","","mv_ch1","C",08,00,0,"G","","SB1","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""     )
PutSx1(cPerg, "02","Produto ate ?  		","","","mv_ch2","C",08,00,0,"G","","SB1","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""     )



Return

