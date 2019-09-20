#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCARTAFORNEC  ºAutor  ³Alessandro    º Data ³  01/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Cartas de Fornecedores                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Estoque                                       º±±                         
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            

User function RelCrtForn()
Local wnRel
Local cAlias   := "Z45"
Local titulo   := "Relatório Cartas de Fornecedores"
Local cNomeProg := "RELCARTAFORNEC"
Local cTamanho  := "G"                                                       
Local cPerg     := "RELCARTA"
Private aReturn := {"Zebrado", 1, "Administracao", 2, 2, 1, "",1} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                                                                   	
AjustaSX(cPerg)

wnRel := SetPrint(cAlias, cNomeProg,cPerg,@titulo, "", "", "", .F., .F., .F., cTamanho,,.F.)
if Empty(wnRel)
	Return
EndIf

SetDefault(aReturn, cAlias)

RptStatus({|lEnd| GeraRel(@lEnd, wnRel, cAlias, cTamanho, cNomeProg, titulo)}, titulo)

Return                                                                         

Static Function GeraRel(lEnd, wnRel, cString, cTamanho, cNomeProg, titulo)
Local cabec1, cabec2
Local cRodaTxt := OemToAnsi("Rodapé")
Local nCntImpr
Local nTipo
Local cTitulo := OemToAnsi(titulo)
Local aCampos := {"Z45_FILIAL", "A2_NOME", "Z45_LOJA", "Z45_SERIE", "Z45_DOC", "B1_DESC", "Z45_QTDE", "Z45_PRECO", "FICAPOR", "Z45_DESC", "Z45_DTDOC",;
								"Z45_DTCART"}
Local aTamCpo := {}
Local cCabec1 := ""
Local cSql    := ""
Local cEol    := CHR(13)+CHR(10)
Local cEol    := CHR(13) + CHR(10)
Local cString := ""
Local nQuant  := 0

// Variáveis totalizadoras
Local aDesc      := {}
Local aQtd       := {}
Local aTotalQtd  := {}
Local aTotalDesc := {}
Local nDocumento := 0
Local nFornec    := 0
Local nProd			 := 0
Local nFilial		 := 0
Local nConcil    := 0
Local nNConcil   := 0
Local nAjust     := 0
Local nNAjust    := 0
Local nDesc	     := 0
Local nQtd	     := 0
Local nTotalDesc := 0
Local nTotalQtd	 := 0

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
	if aCampos[i] != "A2_NOME" .and. aCampos[i] != "B1_DESC"
		
		if DbSeek(aCampos[i])
			cCabec1 += PadC(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO)) 
			
			// Grava num array (aTamCpo) o tamanho dos campos do relatório
			Aadd(aTamCpo, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
		Endif
	Endif
	
		If aCampos[i] == "FICAPOR"
			cCabec1 += PadC("Valor Final", 15)
			Aadd(aTamCpo, 15)
		Endif
		
		If aCampos[i] == "A2_NOME"
			cCabec1 += PadC("Fornecedor", 30)
			Aadd(aTamCpo, 30)
		Endif
		
		If aCampos[i] == "B1_DESC"
			cCabec1 += PadC("Produto", 30)
			Aadd(aTamCpo, 30)
		Endif
		
	
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR09, "@!")
dbSelectArea("Z45") 

cSql := "SELECT B1_DESC AS PRODUTO, A2_NOME AS FORNECEDOR, Z45_FILIAL AS FILIAL, Z45_FORNEC, Z45_SERIE AS SERIE, Z45_DOC AS DOCUMENTO,  "       +cEol
cSql += "Z45_LOJA AS LOJA, Z45_DTDOC AS DATADOCUMENTO, Z45_DTCART AS DATACARTA, Z45_PRODUT, MAX(Z45.R_E_C_N_O_), "          										+cEol
cSql += "Z45_QTDE AS QTDE, Z45_PRECO AS PRECO, (Z45_DESC * Z45_QTDE) AS DESCONTO, (Z45_PRECO - Z45_DESC) AS FICAPOR  " 													+cEol
cSql += "FROM " +retSqlName("Z45")+ " Z45 " 																																																		+cEol
cSql += "INNER JOIN " + RetSQLName("SA2") + " A2 ON Z45.Z45_FORNEC = A2.A2_COD AND Z45.Z45_LOJA = A2.A2_LOJA AND A2.D_E_L_E_T_ <> '*' "					+cEol
cSql += "INNER JOIN " + RetSQLName("SB1") + " B1 ON Z45.Z45_PRODUT = B1.B1_COD AND B1.D_E_L_E_T_ <> '*' " 																			+cEol
cSql += "WHERE Z45.D_E_L_E_T_ <> '*' "																																																					+cEol
cSql += "  AND Z45.Z45_FILIAL BETWEEN '"+ MV_PAR01 + "' AND '" + MV_PAR02 + "' " 																																+cEol
cSql += "  AND Z45.Z45_DTCART BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "     																							+cEol
cSql += "  AND Z45.Z45_FORNEC BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "                 																							+cEol
cSql += "  AND Z45.Z45_LOJA   BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "                																								+cEol  
cSql += "GROUP BY B1_DESC, A2_NOME, Z45_FILIAL, Z45_FORNEC, Z45_SERIE, Z45_DOC, Z45_LOJA, Z45_DTDOC, Z45_DTCART, " 															+cEol  
cSql += "Z45_PRODUT, Z45_QTDE, Z45_PRECO, Z45_DESC, Z45_QTDE, Z45_PRECO, Z45_DESC " 																														+cEol

if cOpcao == "1"
	cSql += "ORDER BY DOCUMENTO"
	
ElseIf cOpcao	== "2"
	cSql += "ORDER BY FORNECEDOR"

ElseIf cOpcao == "3"
	cSql += " ORDER BY PRODUTO " 
	
ElseIf cOpcao == "4" 
  cSql += " ORDER BY FILIAL"

EndIf

TCQUERY cSql NEW ALIAS "Z45TMP"

DbSelectArea("Z45TMP")
Z45TMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if Z45TMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	Z45TMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosFil := aScan(aCampos, {|x| AllTrim(x) == "Z45_FILIAL"})
nPosFor := aScan(aCampos, {|x| AllTrim(x) == "A2_NOME"})
nPosLoj := aScan(aCampos, {|x| AllTrim(x) == "Z45_LOJA"})
nPosSer := aScan(aCampos, {|x| AllTrim(x) == "Z45_SERIE" })
nPosPre := aScan(aCampos, {|x| AllTrim(x) == "Z45_PRECO"})
nPosQTD := aScan(aCampos, {|x| AllTrim(x) == "Z45_QTDE"})
nPosDtCart := aScan(aCampos, {|x| AllTrim(x) == "Z45_DTCART"})
nPosDtDoc := aScan(aCampos, {|x| AllTrim(x) == "Z45_DTDOC"})
nPosDoc := aScan(aCampos, {|x| AllTrim(x) == "Z45_DOC"})
nPosProd  := aScan(aCampos, {|x| AllTrim(x) == "B1_DESC"})
nPosDesc	:= aScan(aCampos, {|x| AllTrim(x) == "Z45_DESC"})
nPosFicaP	:= aScan(aCampos, {|x| AllTrim(x) == "FICAPOR"})


count to nQuant 
Z45TMP->(DbGoTop())
SetRegua(nQuant)

nDesc := 0
nQtd  := 0
nDocumento := ""   
nlidos		 := 0
nTotalDesc := 0
nTotalQtd	 := 0
nFornec		 := 0
nProd			 := 0
nFilial		 := 0

While !Z45TMP->(EOF())
	IncRegua()
	if nlidos = 0
		nDocumento := Z45TMP->DOCUMENTO
		nFornec    := Z45TMP->FORNECEDOR
		nProd      := Z45TMP->PRODUTO
		nFilial		 := Z45TMP->FILIAL
	end
	
	if li > 60
		cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
		@ li, 0 PSAY __PrtThinLine()
	EndIf
	nCntImpr++
	li++      
	
	cPreco	:= Transform(Z45TMP->PRECO, "@E 999,999,999.99")
	cDesconto  := Transform(Z45TMP->DESCONTO, "@E 999,999,999.99")
	cFicaPor  := Transform(Z45TMP->FICAPOR, "@E 999,999,999.99")
  cDtCart := Dtoc(StoD(Z45TMP->DATACARTA))
  cDtDoc := Dtoc(StoD(Z45TMP->DATADOCUMENTO))
  
  	// Imprime totalização dos subgrupos.
if cOpcao == "1"      
   If  nDocumento != Z45TMP->DOCUMENTO
	   Aadd(aQtd, {" ", Transform(nQtd,  "@E 999,999")})		
	
	   li := li
		for i := 1 to len(aQtd)
		 
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
		 nCntImpr++
		 li++      
		 @ li, 110 PSAY aQtd[i, 1] + aQtd[i, 2]	
    Next i 
    
   Endif 
   
   If nDocumento != Z45TMP->DOCUMENTO     				
		 	Aadd(aDesc, {" ", Transform(nDesc,  "@E 999,999.99")})
		 	
	    li := li - 1
    for i := 1 to len(aDesc)
    
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
					nCntImpr++
				 	li++      
			@ li, 162 PSAY aDesc[i, 1] + aDesc[i, 2]
					li 	  := li + 2
				  aQtd  := {}
				  aDesc := {}
				  nDesc := 0
				  nQtd  := 0	
    Next i 
	 EndIf
 EndIf 
 
 if cOpcao == "2"      
   If  nFornec != Z45TMP->FORNECEDOR
	   Aadd(aQtd, {" ", Transform(nQtd,  "@E 999,999")})		
	
	   li   := li
		for i := 1 to len(aQtd)
		 
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
		 nCntImpr++
		 li++      
		 @ li, 110 PSAY aQtd[i, 1] + aQtd[i, 2]	
    Next i 
    
   Endif 
   
   If nFornec != Z45TMP->FORNECEDOR     				
		 	Aadd(aDesc, {" ", Transform(nDesc,  "@E 999,999.99")})
		 	
	    li  := li - 1
    for i := 1 to len(aDesc)
    
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
					nCntImpr++
				 	li++      
			@ li, 162 PSAY aDesc[i, 1] + aDesc[i, 2]
					li    := li + 2
				  aQtd  := {}
				  aDesc := {}
				  nDesc := 0
				  nQtd  := 0	
    Next i 
	 EndIf
 EndIf
 
 if cOpcao == "3"      
   If  nProd != Z45TMP->PRODUTO
	   Aadd(aQtd, {" ", Transform(nQtd,  "@E 999,999")})		
	
	   li   := li
		for i := 1 to len(aQtd)
		 
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
		 nCntImpr++
		 li++      
		 @ li, 110 PSAY aQtd[i, 1] + aQtd[i, 2]	
    Next i 
    
   Endif 
   
   If nProd != Z45TMP->PRODUTO     				
		 	Aadd(aDesc, {" ", Transform(nDesc,  "@E 999,999.99")})
		 	
	    li  := li - 1
    for i := 1 to len(aDesc)
    
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
					nCntImpr++
				 	li++      
			@ li, 162 PSAY aDesc[i, 1] + aDesc[i, 2]
					li    := li + 2
				  aQtd  := {}
				  aDesc := {}
				  nDesc := 0
				  nQtd  := 0	
    Next i 
	 EndIf
 EndIf
 
 if cOpcao == "4"     
   If  nFilial != Z45TMP->FILIAL
	   Aadd(aQtd, {" ", Transform(nQtd,  "@E 999,999")})		
	
	   li   := li
		for i := 1 to len(aQtd)
		 
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
		 nCntImpr++
		 li++      
		 @ li, 110 PSAY aQtd[i, 1] + aQtd[i, 2]	
    Next i 
    
   Endif 
   
   If nFilial != Z45TMP->FILIAL   				
		 	Aadd(aDesc, {" ", Transform(nDesc,  "@E 999,999.99")})
		 	
	    li  := li - 1
    for i := 1 to len(aDesc)
    
	    	If li > 60
					cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
					@ li, 0 PSAY __PrtThinLine()                              
				EndIf
					nCntImpr++
				 	li++      
			@ li, 162 PSAY aDesc[i, 1] + aDesc[i, 2]
					li    := li + 2
				  aQtd  := {}
				  aDesc := {}
				  nDesc := 0
				  nQtd  := 0	
    Next i 
	 EndIf
 EndIf
	
	// Monta a String da linha do relatório
	cString := PadC(Z45TMP->FILIAL,     aTamCpo[nPosFil]) +;
						 PadC(Z45TMP->FORNECEDOR, aTamCpo[nPosFor]) +;
						 PadC(Z45TMP->LOJA,       aTamCpo[nPosLoj]) +; 
						 PadC(Z45TMP->SERIE,       aTamCpo[nPosSer]) +;
						 PadC(Z45TMP->DOCUMENTO,       aTamCpo[nPosDoc]) +;
						 PadC(Z45TMP->PRODUTO,		aTamCpo[nPosProd]) +; 
						 PadC(Z45TMP->QTDE,		aTamCpo[nPosQTD]) +;
						 PadC(cPreco,             aTamCpo[nPosPre]) +;
						 PadC(cFicaPor,             aTamCpo[nPosFicaP]) +;						 
						 PadC(cDesconto,             aTamCpo[nPosDesc]) +; 
						 PadC(cDtDoc,             aTamCpo[nPosDtDoc]) +;
						 PadC(cDtCart,             aTamCpo[nPosDtCart])
						 
						 
				 	 nFornec    := Z45TMP->FORNECEDOR
				 	 nDocumento := Z45TMP->DOCUMENTO
				 	 nProd			:= Z45TMP->PRODUTO
				 	 nFilial		:= Z45TMP->FILIAL	 
           nDesc      += Z45TMP->DESCONTO
           nQtd       += Z45TMP->QTDE
           nTotalQtd  += Z45TMP->QTDE
           nTotalDesc += Z45TMP->DESCONTO 
           nLidos     ++
           
           
           
	@ li, 01 PSAY cString
					 
	if li > 60
		li := 66	
	EndIf
	
	
	// Imprime totalização dos registros.
	Z45TMP->(DbSkip())
          
EndDo

		If  nDocumento != Z45TMP->DOCUMENTO
	
	 	Aadd(aQtd, {" ", Transform(nQtd,  "@E 999,999")})		

    li    := li + 1
    for i := 1 to len(aQtd)
    	if li > 60
				cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
				@ li, 0 PSAY __PrtThinLine()                              
			EndIf
			nCntImpr++
			li++      
			@ li, 111 PSAY aQtd[i, 1] + aQtd[i, 2]	
    Next i
 	EndIf
	
		if Z45TMP->(EOF()) 
		
	 	Aadd(aDesc, {" ", Transform(nDesc,  "@E 999,999.99")})
	 	
    li      := li - 1
    for i   := 1 to len(aDesc)
    	if li > 60
				cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
				@ li, 0 PSAY __PrtThinLine()                              
			EndIf
			nCntImpr++
			li++      
			@ li, 162 PSAY aDesc[i, 1] + aDesc[i, 2]	
    Next i
    
	If  nTotalQtd > 0
	
	 Aadd(aTotalQtd, {"TOTAL DA QUANTIDADE....: ",PadR(Transform(nTotalQtd,  "@E 999,999"),10)})		

    li      := li + 1
    for i   := 1 to len(aTotalQtd)
    	if li > 60
				cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
				@ li, 0 PSAY __PrtThinLine()                              
			EndIf
			nCntImpr++
			li++      
			@ li, 5 PSAY aTotalQtd[i, 1] + aTotalQtd[i, 2]	
    Next i
	EndIf
		If  nTotalDesc > 0
	
			 	Aadd(aTotalDesc, {"TOTAL DESCONTOS........: ", PadL(Transform(nTotalDesc,  "@E 999,999.99"),10)})		
		
		    li      := li + 1
		    for i   := 1 to len(aTotalDesc)
		    	if li > 60
						cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
						@ li, 0 PSAY __PrtThinLine()                              
					EndIf
					nCntImpr++
					li++      
					@ li, 5 PSAY aTotalDesc[i, 1] + aTotalDesc[i, 2]	
		    Next i  
    EndIf
EndIf  

Z45TMP->(DbCloseArea())

Set Device to Screen
if aReturn[5] = 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf          

MS_FLUSH()

Return .T.

Static Function AjustaSX(cPerg)
	PutSx1(cPerg,"01","Filial  De ?"     ,"Filial De ?"      ,"Filial De ?"      ,"mv_ch1" ,"C",02,0,0,"G","","   ", "", "","MV_PAR01")
	PutSx1(cPerg,"02","Filial Até ?"     ,"Filial Até ?"     ,"Filial Até ?"     ,"mv_ch2" ,"C",02,0,0,"G","","   ", "", "","MV_PAR02")
	PutSx1(cPerg,"03","Data Carta De ?"  ,"Data Carta De ?"  ,"Data Carta De ?"  ,"mv_ch3" ,"D",08,0,0,"G","","   ", "", "","MV_PAR03")
	PutSx1(cPerg,"04","Data Carta Até ?" ,"Data Carta Até ?" ,"Data Carta Até ?" ,"mv_ch4" ,"D",08,0,0,"G","","   ", "", "","MV_PAR04")
	PutSx1(cPerg,"05","Fornecedor de ?"  ,"Fornecedor de ?"  ,"Fornecedor de ?"  ,"mv_ch5" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR05")
	PutSx1(cPerg,"06","Fornecedor até ?" ,"Fornecedor até ?" ,"Fornecedor até ?" ,"mv_ch6" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR06")
	PutSx1(cPerg,"07","Loja De ?"        ,"Loja De ?"        ,"Loja De ?"        ,"mv_ch7" ,"C",04,0,0,"G","","   ", "", "","MV_PAR07")
	PutSx1(cPerg,"08","Loja Até ?"       ,"Loja Até ?"       ,"Loja Até ?"       ,"mv_ch8" ,"C",04,0,0,"G","","   ", "", "","MV_PAR08")
	PutSx1(cPerg,"09","Ordenar por ?"    ,"Ordenar por ?"    ,"Ordenar por ?"    ,"mv_ch9" ,"N",01,0,1,"C","","   ", "", "","MV_PAR09","Nro Nota","Nro Nota","Nro Nota","Fornecedor","Fornecedor","Fornecedor","Produto","Produto","Produto","Filial","Filial","Filial")
	

Return Nil