#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELREGDDA ºAutor  ³Roberto Rosin       º Data ³  27/07/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Contingências                                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Planejamento e Controle Orçamentário                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RelCntgcia()
Local wnRel
Local cAlias    := "ALI"
Local titulo    := "Relatório de Contingências"
Local cNomeProg := "RELCNTGCIA"
Local cTamanho  := "G"                                          
Local cPerg     := "RELCTGE"
Private aReturn := {"Zebrado", 1, "Administracao", 1, 2, 1, "",1}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

wnRel := SetPrint(cAlias, cNomeProg,cPerg,@titulo, "", "", "", .F., .F., .F., cTamanho,,.F.)
if Empty(wnRel)
	Return
EndIf

if nLastKey == 27
	return
endIf

SetDefault(aReturn, cAlias)

RptStatus({|lEnd| GeraRel(@lEnd, wnRel, cAlias, cTamanho, cNomeProg, titulo)}, titulo) 
Return

Static Function GeraRel(lEnd, wnRel, cString, cTamanho, cNomeProg, titulo)
  
Local cabec1, cabec2
Local cRodaTxt := OemToAnsi("Rodapé")
Local nCntImpr
Local nTipo
Local cTitulo := OemToAnsi(titulo)
                  
Local aTamCpo := {}
Local cCabec1 := ""
Local cCabecGroup := "" //tem 11 letras... não declarar outra variável com nome cCabecGrou pois VAI dar problema
Local cSql    := ""
Local cEol    := CHR(13)+CHR(10)
Local nQuant  := 0
Local cString := ""
Local cOldAgrupador := "" //variável com mais de 10 letras identificada internamente por cOldAgrupa
Local cAgrupador := ""

// Variáveis totalizadoras
Local nTotal   := 0
Local aTotal   := {}
Local nTotQtde := 0
local nTotParc := 0
local nTotQtdePa := 0

//controle
//controla se é a primeira execução para imprimir ou não os totalizadores do relatório
local lTotaliza := .F.

Local aCampos := {}

//monta o array aCampos de acordo com o parâmetro de agrupador
if MV_PAR09 == 1
	//agrupa por Segmento
	aCampos := {"ALI_DTSOLI","AK5_DESCRI","CTT_DESC01","ALI_CDCNTG","ALJ_VALOR1","ALJ_HIST","ALI_X_OBS"}
	cCabecGroup := "Segmento............: "
elseIf MV_PAR09 == 2
	//agrupa por Centro de Custos
	aCampos := {"ALI_DTSOLI","AK5_DESCRI","CTH_DESC01","ALI_CDCNTG","ALJ_VALOR1","ALJ_HIST","ALI_X_OBS"}
	cCabecGroup := "Centro de Custos....: "
elseIf MV_PAR09 == 3
	//agrupa por Conta Orçamentária
	aCampos := {"ALI_DTSOLI","CTH_DESC01","CTT_DESC01","ALI_CDCNTG","ALJ_VALOR1","ALJ_HIST","ALI_X_OBS"}
	cCabecGroup := "Conta Orçamentária..: "
endIf

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
	if DbSeek(aCampos[i]) .and. aCampos[i] <> "AK5_DESCRI" .and. aCampos[i] <> "CTT_DESC01" .and. aCampos[i] <> "CTH_DESC01" .and. aCampos[i] <> "ALI_X_OBS"
		if(aCampos[i] == "ALJ_HIST")
			cCabec1 += PadC(AllTrim(X3Titulo()),50) + Space(4)
			// Grava num array (aTamCpo) o tamanho dos campos do relatório
			Aadd(aTamCpo, 50)
		else
			cCabec1 += PadC(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO)) + Space(4)
			// Grava num array (aTamCpo) o tamanho dos campos do relatório
			Aadd(aTamCpo, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
		end if
	EndIf

	//campos com descrição ou tamanho personalizados
	if aCampos[i] == "ALI_X_OBS"
		cCabec1 += PadC("Justificativa",50) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 50)
	elseIf(aCampos[i] == "AK5_DESCRI")
		cCabec1 += PadC("Conta Orçamentária",30) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 30)
	elseIf(aCampos[i] == "CTT_DESC01")
		cCabec1 += PadC("Centro de Custos",25) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 25)
	elseIf(aCampos[i] == "CTH_DESC01")
		cCabec1 += PadC("Segmento",30) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 30)
	endIf    
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR04, "@!")

//monta o SELECT
cSql := "SELECT ALI.ALI_FILIAL      AS FILIAL,"       + cEol
cSql += "ALI.ALI_DTSOLI             AS DTSOLI,"       + cEol
cSql += "ALJ.ALJ_CO                 AS CO,"           + cEol
cSql += "AK5.AK5_DESCRI             AS CONTA_ORCA,"   + cEol
cSql += "ALJ.ALJ_CLVLR              AS CLVLR,"        + cEol
cSql += "CTH.CTH_DESC01             AS SEGMENTO,"     + cEol
cSql += "ALJ.ALJ_CC                 AS CC,"           + cEol
cSql += "CTT.CTT_DESC01             AS C_CUSTO,"      + cEol
cSql += "ALI.ALI_CDCNTG             AS CDCNTG,"       + cEol
cSql += "ALJ.ALJ_VALOR1             AS VALOR1,"       + cEol
cSql += "SUBSTR(ALJ.ALJ_HIST,1,50)  AS HISTORICO,"    + cEol
cSql += "SUBSTR(ALI.ALI_X_OBS,1,50) AS X_OBS"         + cEol
cSql += "FROM " + RetSqlName("ALI") + " ALI"     + cEol
cSql += "INNER JOIN " + RetSqlName("ALJ") + " ALJ ON ALI.ALI_FILIAL = ALJ.ALJ_FILIAL AND ALI.ALI_CDCNTG = ALJ.ALJ_CDCNTG AND ALJ.D_E_L_E_T_ <> '*'" + cEol
cSql += "INNER JOIN " + RetSqlName("CTH") + " CTH ON CTH.CTH_CLVL = ALJ.ALJ_CLVLR" + cEol
cSql += "INNER JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO  = ALJ.ALJ_CC"  + cEol
cSql += "INNER JOIN " + RetSqlName("AK5") + " AK5 ON AK5.AK5_CODIGO = ALJ.ALJ_CO"  + cEol
cSql += "WHERE ALI.D_E_L_E_T_ <> '*'"      + cEol
cSql += "AND ALI.ALI_FILIAL = '"  + xFilial("ALI") + "'" + cEol
if !empty(MV_PAR01)//se o parâmetro de Segmento não estiver em branco
  cSql += "AND ALJ.ALJ_CLVLR = '"   + MV_PAR01       + "'" + cEol
endIf
if !empty(MV_PAR02)//se o parâmetro de Centro de Custos não estiver em branco
	cSql += "AND ALJ.ALJ_CC = '"      + MV_PAR02       + "'" +  cEol
endIf
if !empty(MV_PAR03)//se o parâmetro de Conta Orçamentária não estiver em branco
	cSql += "AND ALJ.ALJ_CO = '"      + MV_PAR03       + "'" +  cEol
endIf
//datas inicio e final
cSql += "AND ALI.ALI_DTSOLI BETWEEN '" + Dtos(MV_PAR05) + "' AND '" +Dtos(MV_PAR06) + "'" + cEol

if !empty(MV_PAR07) .or. upper(MV_PAR07) == 'ZZZ'//se o parâmetro de Histórico estiver em branco ou for igual a "zzz"
  cSql += "AND UPPER(ALJ.ALJ_HIST) LIKE '%"  + UPPER(trim(MV_PAR07)) + "%'" + cEol
endIf

if !empty(MV_PAR08) .or. upper(MV_PAR08) == 'ZZZ'//se o parâmetro de Observação estiver em branco ou for igual a "zzz"
  cSql += "AND UPPER(ALI.ALI_X_OBS) LIKE '%" + UPPER(trim(MV_PAR08)) + "%'" + cEol
endIf

//verifica qual o parâmetro de Status e adiciona o filtro de status selecinado
if cOpcao == "1" 
	cSql += "AND ALI.ALI_STATUS = 2 "  +cEol
ElseIf cOpcao == "2"
	cSql += "AND ALI.ALI_STATUS = 3 "  +cEol
ElseIf cOpcao == "3"
	cSql += "AND ALI.ALI_STATUS = 4 "  +cEol
ElseIf cOpcao == "4"
	cSql += "AND ALI.ALI_STATUS = 5 "  +cEol
EndIf

//monta o ORDER BY de acordo com o parâmetro de agrupamento
if MV_PAR09 == 1
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CLVLR, ALJ.ALJ_CO, ALJ.ALJ_CC"
elseIf MV_PAR09 == 2
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CC, ALJ.ALJ_CO, ALJ.ALJ_CLVLR"
elseIf MV_PAR09 == 3
	cSql += "ORDER BY ALI.ALI_FILIAL, ALJ.ALJ_CO, ALJ.ALJ_CLVLR, ALJ.ALJ_CC"
endIf

TCQUERY cSql NEW ALIAS "ALITMP"

DbSelectArea("ALITMP")
ALITMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if ALITMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	ALITMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosDtsoli := aScan(aCampos, {|x| AllTrim(x) == "ALI_DTSOLI"})
nPosCO     := aScan(aCampos, {|x| AllTrim(x) == "ALJ_CO"    })
nPosConta  := aScan(aCampos, {|x| AllTrim(x) == "AK5_DESCRI"})
nPosClvlr  := aScan(aCampos, {|x| AllTrim(x) == "ALJ_CLVLR" })
nPosSegmen := aScan(aCampos, {|x| AlLTrim(x) == "CTH_DESC01"})
nPosCC     := aScan(aCampos, {|x| AllTrim(x) == "ALJ_CC"    })
nPosCCusto := aScan(aCampos, {|x| AllTrim(x) == "CTT_DESC01"})
nPosCdcntg := aScan(aCampos, {|x| AllTrim(x) == "ALI_CDCNTG"})
nPosValor1 := aScan(aCampos, {|x| AllTrim(x) == "ALJ_VALOR1"})
nPosHist   := aScan(aCampos, {|x| AllTrim(x) == "ALJ_HIST"  })
nPosX_Obs  := aScan(aCampos, {|x| AllTrim(x) == "ALI_X_OBS" })

count to nQuant 
ALITMP->(DbGoTop())
SetRegua(nQuant)

While !ALITMP->(EOF())
	IncRegua()
	if li > 60
	  //imprime o cabeçalho do relatório sem a primeira e segunda linhas
		cabec(titulo, "", "", cNomeProg, cTamanho, 15)
	EndIf
	
	//define o conteúdo da variável agrupador segundo o parâmetro de agrupamento.
	//essa variável é utilizada para definir quando alterou o agrupador.
	if MV_PAR09 == 1		
		cAgrupador := ALITMP->SEGMENTO
	elseIf MV_PAR09 == 2
		cAgrupador := ALITMP->C_CUSTO
	elseIf MV_PAR09 == 3
		cAgrupador := ALITMP->CONTA_ORCA
	endIf
	
	//se alterou o agrupador, finaliza o grupo e imprime os totalizadores de grupo
	if cAgrupador <> cOldAgrupador
	  //se não for a primeira vez que está executando o relatório
		if lTotaliza
			li++//quebra linha
			@ li, 0 PSAY __PrtThinLine() //imprime uma linha no relatório
			li++
			//imprime os totalizadores
			@ li, 53 PSAY "Contigências..: " + Transform(nTotQtdePa, "@E 9999") + space(13) + "Total..:" + Transform(nTotParc, "@E 999,999,999.99")
			li++
			@ li, 0 PSAY __PrtThinLine()
			li++
		end if
		
		//define qual é o ultimo agrupador
		if MV_PAR09 == 1		
			@ li, 10 PSAY cCabecGroup + ALITMP->SEGMENTO   + Transform(ALITMP->CLVLR, "@E 9999999999")
			cOldAgrupador := ALITMP->SEGMENTO
		elseIf MV_PAR09 == 2
			@ li, 10 PSAY cCabecGroup + ALITMP->C_CUSTO    + Transform(ALITMP->CC,    "@E 9999999999")
			cOldAgrupador := ALITMP->C_CUSTO
		elseIf MV_PAR09 == 3
			@ li, 10 PSAY cCabecGroup + ALITMP->CONTA_ORCA + Transform(ALITMP->CO,    "@E 9999999999")
			cOldAgrupador := ALITMP->CONTA_ORCA
		endIf
		li++
		@ li, 0 PSAY __PrtThinLine()
		li++
		@ li, 0 PSAY cCabec1
		li++
		@ li, 0 PSAY __PrtThinLine()
		
		//zera os totalizadores de grupo
		nTotParc := 0
		nTotQtdePa := 0
		
		//utilizada para não totalizar quando é a primeira vez que está executando.		
		lTotaliza := .T.
	endif
	nCntImpr++
	li++      
	
	//ajusta as mascaras dos campos nescessários
	cDataSoli := subStr(ALITMP->DTSOLI,7,2) + "/" + subStr(ALITMP->DTSOLI,5,2) + "/" + subStr(ALITMP->DTSOLI,1,4)
	cValor    := Transform(ALITMP->VALOR1, "@E 9,999,999.99")
	
  nTotal := nTotal + ALITMP->VALOR1
  nTotQtde++
  nTotParc := nTotParc + ALITMP->VALOR1
	nTotQtdePa ++

	// Monta a String da linha do relatório conforme o parâmetro MV_PAR09 que define o agrupamento do relatório.	
	if MV_PAR09 == 1
		//agrupa por Segmento
		cString := PadC(cDataSoli,                aTamCpo[nPosDtsoli]) + Space(4)
		cString += PadC(ALITMP->CONTA_ORCA,       aTamCpo[nPosConta ]) + Space(4)
		cString += PadC(ALITMP->C_CUSTO,          aTamCpo[nPosCCusto]) + Space(4)
		cString += PadC(ALITMP->CDCNTG,           aTamCpo[nPosCdcntg]) + Space(4)
		cString += PadC(cValor,                   aTamCpo[nPosValor1]) + Space(4)
		cString += PadC(ALITMP->HISTORICO,        aTamCpo[nPosHist  ]) + Space(4)
		cString += PadC(ALITMP->X_OBS,            aTamCpo[nPosX_Obs ])
	elseIf MV_PAR09 == 2
		//agrupa por Centro de Custos
		cString := PadC(cDataSoli,                aTamCpo[nPosDtsoli]) + Space(4)
		cString += PadC(ALITMP->CONTA_ORCA,       aTamCpo[nPosConta ]) + Space(4)
		cString += PadC(ALITMP->SEGMENTO,         aTamCpo[nPosSegmen]) + Space(4)
		cString += PadC(ALITMP->CDCNTG,           aTamCpo[nPosCdcntg]) + Space(4)
		cString += PadC(cValor,                   aTamCpo[nPosValor1]) + Space(4)
		cString += PadC(ALITMP->HISTORICO,        aTamCpo[nPosHist  ]) + Space(4)
		cString += PadC(ALITMP->X_OBS,            aTamCpo[nPosX_Obs ])
	elseIf MV_PAR09 == 3
		//agrupa por Conta Orçamentária
		cString := PadC(cDataSoli,                aTamCpo[nPosDtsoli]) + Space(4)
		cString += PadC(ALITMP->SEGMENTO,         aTamCpo[nPosSegmen]) + Space(4)
		cString += PadC(ALITMP->C_CUSTO,          aTamCpo[nPosCCusto]) + Space(4)
		cString += PadC(ALITMP->CDCNTG,           aTamCpo[nPosCdcntg]) + Space(4)
		cString += PadC(cValor,                   aTamCpo[nPosValor1]) + Space(4)
		cString += PadC(ALITMP->HISTORICO,        aTamCpo[nPosHist  ]) + Space(4)
		cString += PadC(ALITMP->X_OBS,            aTamCpo[nPosX_Obs ])
	endIf
	                                                            
	@ li, 01 PSAY cString
	
	if li > 60
		li := 66
	EndIf
	
	// Imprime totalização dos registros.
	ALITMP->(DbSkip())
	
	//monta rodapé
 	if ALITMP->(EOF())
 		li++
		@ li, 0 PSAY __PrtThinLine() 
		li++
		@ li, 66 PSAY "Contigências..: " + Transform(nTotQtdePa, "@E 9999") + space(5) + "Total..:" + Transform(nTotParc, "@E 999,999,999.99")
		li++
		@ li, 0 PSAY __PrtThinLine()
		li++
	
    Aadd(aTotal, {"Contigências.:", Transform(nTotQtde, "@E 99,999,999,999")})
    Aadd(aTotal, {"Total........:", Transform(nTotal,   "@E 999,999,999.99")})
    
    li := li + 4
    
    //imprime os totais
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

ALITMP->(DbCloseArea())

Set Device to Screen
if aReturn[5] = 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf          

MS_FLUSH()


Return .T.

Static Function AjustaSX(cPerg) 
	/*explicação dos parâmetros do PutSx1...
	PutSx1(cPerg,;  //Nome do grupo de pergunta
	"01",;          //Ordem de apresentação das perguntas na tela
	"Segmento ?",;  //Texto da pergunta a ser apresentado na tela.
	"Segmento ?",;  //Texto em espanhol a ser apresentado na tela.
	"Segmento ?",;  //Texto em ingles a ser apresentado na tela.
	"mv_ch1",;      //Variavel do item.
	"C",;           //Tipo do conteúdo de resposta da pergunta.
	08,;            //Tamanho do campo para a resposta da pergunta.
	0,;             //Número de casas decimais da resposta, se houver.
	0,;             //Valor que define qual o item do combo estará selecionado na apresentação da tela. Este campo somente poderá ser preenchido quando o parâmetro cGSC for preenchido com "C"
	"G",;           //Estilo de apresentação da pergunta na tela: - "G" - formato que permite editar o conteúdo do campo. - "S" - formato de texto que não permite alteração. - "C" - formato que permite a opção de seleção de dados para o campo.
	"",;            //Validação do item de pergunta.
	"   ",;         //Nome da consulta F3 que poderá ser acionada pela pergunta.
	"",;            //Código do grupo de campos relacionado a pergunta.
	"",;            
	"MV_PAR01")     //Nome do MV_PAR para a utilização nos programas 
	                //Opções da combo... 
	*/
If .T.
	endif
	
	PutSx1(cPerg,"01","Segmento ?",             "Segmento ?",             "Segmento ?",             "mv_ch1","C",10,0,0,"G","","CTH","","","MV_PAR01")
	PutSx1(cPerg,"02","Centro de Custos ?",     "Centro de Custos ?",     "Centro de Custos ?",     "mv_ch2","C",10,0,0,"G","","CTT","","","MV_PAR02")
	PutSx1(cPerg,"03","Conta Orcamentáia ?",    "Conta Orcamentáia ?",    "Conta Orcamentáia ?",    "mv_ch3","C",10,0,0,"G","","AK5","","","MV_PAR03") 
	PutSx1(cPerg,"04","Status ?",               "Status ?",               "Status ?",               "mv_ch4","N",02,0,0,"C","","   ","","","MV_PAR04","Aguardando Lib.","Aguardando Lib.","Aguardando Lib.","Liberado","Liberado","Liberado","Cancelado","Cancelado","Cancelado","Lib out usuário","Lib out usuário","Lib out usuário","Todos","Todos","Todos")
	PutSx1(cPerg,"05","Data Inicio ?",          "Data Inicio ?",          "Data Inicio ?",          "mv_ch5","D",10,0,0,"G","","   ","","","MV_PAR05") 
	PutSx1(cPerg,"06","Data Final ?",           "Data Final ?",           "Data Final ?",           "mv_ch6","D",08,0,0,"G","","   ","","","MV_PAR06")
	PutSx1(cPerg,"07","Histórico contendo ?",   "Histórico contendo ?",   "Histórico contendo ?",   "mv_ch7","C",50,0,0,"G","","   ","","","MV_PAR07")
	PutSx1(cPerg,"08","Observações contendo ?", "Observações contendo ?", "Observações contendo ?", "mv_ch8","C",50,0,0,"G","","   ","","","MV_PAR08")
	PutSx1(cPerg,"09","Totaliza por ?",         "Totaliza por ?",         "Totaliza por ?",         "mv_ch9","C",50,0,0,"C","","   ","","","MV_PAR09","Segmento","Segmento","Segmento","Centro de Custos","Centro de Custos","Centro de Custos","C. Orçamentária","C. Orçamentária","C. Orçamentária")
Return Nil