#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELREGDDA ºAutor  ³Jean                º Data ³  11/04/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de registros de DDA                              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RelRegDDA()
Local wnRel
Local cAlias   := "FIG"
Local titulo   := "Relatórios de Registros de DDA"
Local cNomeProg := "RELREGDDA"
Local cTamanho  := "G"                                          
Local cPerg     := "RELDDA"
Private aReturn := {"Zebrado", 1, "Administracao", 2, 2, 1, "",1}  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

if Aviso("Etapa 01","Após Declaração de Variáveis...",{"Continuar","Abortar"},2) != 1
	Return nil
EndIf

wnRel := SetPrint("ABC"/*cAlias*/, cNomeProg,cPerg,@titulo, "", "", "", .F., .F., .F., cTamanho,,.F.)
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
Local aCampos := {"FIG_FILIAL","FIG_FORNEC", "FIG_LOJA", "FIG_CNPJ", "FIG_NOMFOR", "FIG_VALOR", "FIG_VENCTO",;
									"FIG_DATA", "FIG_CONCIL", "FIG_DTCONC", "FIG_X_OK"}
Local aTamCpo := {}
Local cCabec1 := ""
Local cSql    := ""
Local cEol    := CHR(13)+CHR(10)
Local nQuant  := 0
Local cString := ""
Local cEol    := CHR(13) + CHR(10)

// Variáveis totalizadoras
Local nConcil  := 0
Local nNConcil := 0
Local nAjust   := 0
Local nNAjust  := 0
Local aTotal   := {}

if Aviso("Etapa 04","Na função GeraRel()...",{"Continuar","Abortar"},2) != 1
	Return nil
EndIf

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
	if DbSeek(aCampos[i])
		cCabec1 += PadC(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO)) + Space(4)
		
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
	EndIf
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR07, "@!")

cSql := "SELECT FIG_FILIAL AS FILIAL, FIG_FORNEC AS FORNECEDOR, FIG_LOJA AS LOJA, FIG_CNPJ AS CNPJ, "                     +cEol
cSql += "FIG_NOMFOR AS NOME, FIG_VALOR AS VALOR, FIG.FIG_VENCTO AS VENCIMENTO, FIG.FIG_DATA AS DATAIMPORTACAO, "          +cEol
cSql += "FIG_CONCIL AS CONCILIADO, FIG_DTCONC AS DATACONCILIACAO, FIG_X_OK AS AJUSTADO FROM " +retSqlName("FIG")+ " FIG " +cEol
cSql += "WHERE FIG.D_E_L_E_T_ <> '*' "
cSql += "  AND FIG.FIG_DATA   BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' "     +cEol
cSql += "  AND FIG.FIG_FORNEC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "                 +cEol
cSql += "  AND FIG.FIG_VENCTO BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "' "     +cEol

if cOpcao == "1" 
	cSql += "  AND FIG.FIG_CONCIL = '1' "  +cEol
ElseIf cOpcao == "2"
	cSql += "  AND FIG.FIG_CONCIL <> '1' " +cEol
ElseIf cOpcao == "3"
	cSql += "  AND FIG.FIG_X_OK = 'S' "    +cEol
ElseIf cOpcao == "4"
	cSql += "  AND FIG.FIG_X_OK <> 'S' "   +cEol
EndIf

cSql += "ORDER BY FILIAL, DATAIMPORTACAO, FORNECEDOR DESC, LOJA "                                 +cEol

TCQUERY cSql NEW ALIAS "FIGTMP"

DbSelectArea("FIGTMP")
FIGTMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if FIGTMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	FIGTMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosFil := aScan(aCampos, {|x| AllTrim(x) == "FIG_FILIAL"})
nPosFor := aScan(aCampos, {|x| AllTrim(x) == "FIG_FORNEC"})
nPosLoj := aScan(aCampos, {|x| AllTrim(x) == "FIG_LOJA"})
nPosCnp := aScan(aCampos, {|x| AllTrim(x) == "FIG_CNPJ"}) 
nPosNom := aScan(aCampos, {|x| AllTrim(x) == "FIG_NOMFOR"})
nPosVal := aScan(aCampos, {|x| AllTrim(x) == "FIG_VALOR"})
nPosVen := aScan(aCampos, {|x| AllTrim(x) == "FIG_VENCTO"})
nPosDat := aScan(aCampos, {|x| AllTrim(x) == "FIG_DATA"})
nPosCon := aScan(aCampos, {|x| AllTrim(x) == "FIG_CONCIL"})
nPosDtC := aScan(aCampos, {|x| AllTrim(x) == "FIG_DTCONC"})
nPosOk  := aScan(aCampos, {|x| AllTrim(x) == "FIG_X_OK"})

count to nQuant 
FIGTMP->(DbGoTop())
SetRegua(nQuant)

While !FIGTMP->(EOF())
	IncRegua()
	if li > 60
		cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
		@ li, 0 PSAY __PrtThinLine()
	EndIf
	nCntImpr++
	li++      
	
	cValor  := Transform(FIGTMP->VALOR, "@E 999,999,999.99")
	cConcil := iif(FIGTMP->CONCILIADO != "1", "Não", "Sim")
	cAjust  := iif(FIGTMP->AJUSTADO != "S", "Não", "Sim")
	
	iif(FIGTMP->CONCILIADO != "1", nNConcil++, nConcil++)
	iif(FIGTMP->AJUSTADO != "S", nNAjust++, nAjust++)
	
	// Monta a String da linha do relatório
	cString := PadC(FIGTMP->FILIAL,     aTamCpo[nPosFil]) +Space(4)+;
						 PadC(FIGTMP->FORNECEDOR, aTamCpo[nPosFor]) +Space(4)+;
						 PadC(FIGTMP->LOJA,       aTamCpo[nPosLoj]) +Space(4)+; 
						 PadC(FIGTMP->CNPJ,       aTamCpo[nPosCnp]) +Space(4)+;
						 PadC(FIGTMP->NOME,       aTamCpo[nPosNom]) +Space(4)+; 
						 PadR(cValor,             aTamCpo[nPosVal]) +Space(4)+; 
						 PadC(DtoC(StoD(FIGTMP->VENCIMENTO)),      aTamCpo[nPosVen]) +Space(4)+; 
						 PadC(DtoC(StoD(FIGTMP->DATAIMPORTACAO)),  aTamCpo[nPosDat]) +Space(4)+;
						 PadC(cConcil,            aTamCpo[nPosCon]) +Space(4)+;
						 PadC(DtoC(StoD(FIGTMP->DATACONCILIACAO)), aTamCpo[nPosDtC]) +Space(4)+; 
						 PadC(cAjust,             aTamCpo[nPosOk ]) 
	
	@ li, 01 PSAY cString
	
	if li > 60
		li := 66	
	EndIf
	
	// Imprime totalização dos registros.
	FIGTMP->(DbSkip())
	if FIGTMP->(EOF())
		
		Aadd(aTotal, {"Conciliados.....:", Transform(nConcil,  "@E 999,999")})
		Aadd(aTotal, {"Não conciliados.:", Transform(nNConcil, "@E 999,999")})
		Aadd(aTotal, {"Ajustados.......:", Transform(nAjust,   "@E 999,999")})
    Aadd(aTotal, {"Não Ajustados...:", Transform(nNAjust,  "@E 999,999")})
    
    li := li + 4
    for i := 1 to len(aTotal)
    	if li > 60
				cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
				@ li, 0 PSAY __PrtThinLine()
			EndIf
			nCntImpr++
			li++      
			@ li, 10 PSAY aTotal[i, 1] + aTotal[i, 2]	
    Next i
	EndIf
	
EndDo  

FIGTMP->(DbCloseArea())

Set Device to Screen
if aReturn[5] = 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf          

MS_FLUSH()

Return .T.

Static Function AjustaSX(cPerg)
	PutSx1(cPerg,"01","Importado De ?"  ,"Importado De ?"  ,"Importado De ?"  ,"mv_ch1" ,"D",08,0,0,"G","","   ", "", "","MV_PAR01")
	PutSx1(cPerg,"02","Importado Até ?" ,"Importado Até ?" ,"Importado Até ?" ,"mv_ch2" ,"D",08,0,0,"G","","   ", "", "","MV_PAR02")
	PutSx1(cPerg,"03","Fornecedor de ?" ,"Fornecedor de ?" ,"Fornecedor de ?" ,"mv_ch3" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR03")
	PutSx1(cPerg,"04","Fornecedor até ?","Fornecedor até ?","Fornecedor até ?","mv_ch4" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR04")
	PutSx1(cPerg,"05","Vencimento De ?" ,"Vencimento De ?" ,"Vencimento De ?" ,"mv_ch5" ,"D",08,0,0,"G","","   ", "", "","MV_PAR05")
	PutSx1(cPerg,"06","Vencimento Até ?","Vencimento Até ?","Vencimento Até ?","mv_ch6" ,"D",08,0,0,"G","","   ", "", "","MV_PAR06")
	PutSx1(cPerg,"07","Totaliza por ?"  ,"Totaliza por ?"  ,"Totaliza por ?"  ,"mv_ch7" ,"N",01,0,1,"C","","   ", "", "","MV_PAR07","1=Conciliados","1=Conciliados","1=Conciliados","2=Não Concilia","2=Não Concilia","2=Não Concilia","3=Ajustados","3=Ajustados","3=Ajustados","4=Não Ajust","4=Não Ajust","4=Não Ajust","5=Todos","5=Todos","5=Todos")
Return Nil