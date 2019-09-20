#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCONFNC  ºAutor  ³Alessandro    º Data ³  01/06/12     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório Desconto Contrato Fornecedor                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro / Estoque                                       º±±                         
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                            

User function RELCONFNC()
Local wnRel
Local cAlias   := "Z30"
Local titulo   := "Relatório Desconto Contrato Fornecedor"
Local cNomeProg := "RELCONFNC"
Local cTamanho  := "G"                                                       
Local cPerg     := "RELCON"
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
Local aCampos := {"Z30_FILIAL", "Z30_FORNEC", "Z30_NOMFOR", "Z30_LOJFOR", "Z30_NUMERO", "Z30_DATINI", "Z30_DATFIN", "Z31_PERDES"}
Local aTamCpo := {}
Local cCabec1 := ""
Local cSql    := ""
Local cEol    := CHR(13) + CHR(10)
Local cString := ""
Local nQuant  := 0

// Variáveis totalizadoras
Local nLidos     := 0
Local nNumCont   := 0
Local nFornec    := 0
Local nLoja  	 := 0
Local nFilial    := 0

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
		
		if DbSeek(aCampos[i])
			cCabec1 += PadC(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO)) + Space(4)
			
			// Grava num array (aTamCpo) o tamanho dos campos do relatório
			Aadd(aTamCpo, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
		Endif
	
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR07, "@!")
dbSelectArea("Z30") 

cSql := "SELECT DISTINCT Z31_PERDES AS PERDESC, Z30_NUMERO AS NUMCONT, Z30_FORNEC AS CODFORNEC, Z30_NOMFOR AS NOMEFORNEC, Z30_LOJFOR AS LOJAFORNEC,"  +cEol                   +cEol
cSql += "Z30_DATINI AS DATAINICIO, Z30_FILIAL AS FILIAL, Z30_DATFIN AS DATAFINAL FROM "+ RetSQLName("Z30") +" Z30 "          +cEol
cSql += "INNER JOIN "+ RetSQLName("Z31") +" Z31 ON Z30_NUMERO = Z31_NUMERO" +cEol
cSql += "WHERE Z30.D_E_L_E_T_ <> '*' "	+cEol
cSql += "  AND Z31.D_E_L_E_T_ <> '*' "	+cEol
cSql += "  AND Z30.Z30_DATINI   BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "     +cEol
cSql += "  AND Z30.Z30_FORNEC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "                 +cEol

if cOpcao == "1"
	cSql += "ORDER BY NUMCONT"
	
ElseIf cOpcao	== "2"
	cSql += "ORDER BY FORNECEDOR"

ElseIf cOpcao == "3"
	cSql += " ORDER BY LOJAFORNEC"

ElseIf cOpcao == "4"
	cSql += " ORDER BY FILIAL"
EndIf 
	
TCQUERY cSql NEW ALIAS "Z30TMP"

DbSelectArea("Z30TMP")
Z30TMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if Z30TMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	Z30TMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosFil := aScan(aCampos, {|x| AllTrim(x) == "Z30_FILIAL"})
nPosCFor := aScan(aCampos, {|x| AllTrim(x) == "Z30_FORNEC"})
nPosFor := aScan(aCampos, {|x| AllTrim(x) == "Z30_NOMFOR"})
nPosLoj := aScan(aCampos, {|x| AllTrim(x) == "Z30_LOJFOR" })
nPosNumC := aScan(aCampos, {|x| AllTrim(x) == "Z30_NUMERO"})
nPosDatIni := aScan(aCampos, {|x| AllTrim(x) == "Z30_DATINI"})
nPosDatFin := aScan(aCampos, {|x| AllTrim(x) == "Z30_DATFIN"})
nPosPerDes := aScan(aCampos, {|x| AllTrim(x) == "Z31_PERDES"})


count to nQuant 
Z30TMP->(DbGoTop())
SetRegua(nQuant)  


nLidos     := 0
nNumCont   := 0
nFornec    := 0
nLoja  	   := 0
nFilial    := 0


While !Z30TMP->(EOF())
	IncRegua()
/*	if nLidos = 0
		nNumCont := Z30TMP->NUMCONT
		nFornec    := Z30TMP->CODFORNEC
   		nLoja      := Z30TMP->LOJAFORNEC
		nFilial		 := Z30TMP->FILIAL
	end
	       */
	if li > 60
		cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
		@ li, 0 PSAY __PrtThinLine()
	EndIf
	nCntImpr++
	li++      
	
  cDtIni := Dtoc(StoD(Z30TMP->DATAINICIO))
  cDtFin := Dtoc(StoD(Z30TMP->DATAFINAL))

	// Monta a String da linha do relatório 
	cPerDesc	:= Transform(Z30TMP->PERDESC, "@E 999")
	
	cString := PadC(Z30TMP->FILIAL,     aTamCpo[nPosFil]) + Space(4)+; 
						 PadC(Z30TMP->CODFORNEC, aTamCpo[nPosCFor]) + Space(4)+;
						 PadC(Z30TMP->NOMEFORNEC,       aTamCpo[nPosFor]) + Space(4)+; 
						 PadC(Z30TMP->LOJAFORNEC,       aTamCpo[nPosLoj]) + Space(4)+;
						 PadC(Z30TMP->NUMCONT,       aTamCpo[nPosNumC]) + Space(4)+;
						 PadC(cDtIni,             aTamCpo[nPosDatIni]) + Space(4)+;
						 PadC(cDtFin,             aTamCpo[nPosDatFin])+ Space(4)+;
						 PadC(cPerDesc,             aTamCpo[nPosPerDes])
                             
 
                                                                                              
 						@ li, 01 PSAY cString
					 
							if li > 60
								li := 66
                             EndIf
						  //nLidos     ++
						 
	Z30TMP->(DbSkip())  
 Enddo
Z30TMP->(DbCloseArea())

Set Device to Screen
if aReturn[5] = 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf          

MS_FLUSH()

Return .T.

Static Function AjustaSX(cPerg)
	PutSx1(cPerg,"01","Data Início De ?"  ,"Data Início De ?"  ,"Data Início De ?"  ,"mv_ch1" ,"D",08,0,0,"G","","   ", "", "","MV_PAR01")
	PutSx1(cPerg,"02","Data Início Até ?" ,"Data Início Até ?" ,"Data Início Até ?" ,"mv_ch2" ,"D",08,0,0,"G","","   ", "", "","MV_PAR02")
	PutSx1(cPerg,"03","Fornecedor de ?" ,"Fornecedor de ?" ,"Fornecedor de ?" ,"mv_ch3" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR03")
	PutSx1(cPerg,"04","Fornecedor até ?","Fornecedor até ?","Fornecedor até ?","mv_ch4" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR04")
	PutSx1(cPerg,"05","Filial De ?" ,"Filial De ?" ,"Filial De ?" ,"mv_ch5" ,"C",02,0,0,"G","","   ", "", "","MV_PAR05")
	PutSx1(cPerg,"06","Filial Até ?","Filial Até ?","Filial Até ?","mv_ch6" ,"C",02,0,0,"G","","   ", "", "","MV_PAR06")
	PutSx1(cPerg,"07","Ordenar por ?"  ,"Ordenar por ?"  ,"Ordenar por ?"  ,"mv_ch7" ,"N",01,0,1,"C","","   ", "", "","MV_PAR07","Nro Contrato","Nro Contrato","Nro Contrato","Fornecedor","Fornecedor","Fornecedor","Loja Fornecedor","Loja Fornecedor","Loja Fornecedor","Filial","Filial","Filial")
	

Return Nil