#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

user function RELDEMONSTRACAO()
Local wnRel
Local cAlias    := "SD2"
Local titulo    := "Relatório de Notas Fiscais de Demonstração"
Local cNomeProg := "RELDEMONSTRACAO"
Local cTamanho  := "G"                                          
Local cPerg     := "RELDEMONST"
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
return

Static Function GeraRel(lEnd, wnRel, cString, cTamanho, cNomeProg, titulo)
Local cabec1, cabec2
Local cRodaTxt  := OemToAnsi("Rodapé")
Local nCntImpr
Local nTipo
Local cTitulo   := OemToAnsi(titulo)
Local aCampos1  := {"M0_NOMECOM","D2_DOC","D2_SERIE","D2_EMISSAO","C5_CLIENTE","A1_NOME","C5_VEND1","A3_NOME"}
Local aCampos2  := {"D2_ITEM", "B1_COD","B1_DESC","D2_QUANT"}
local aCampos3  := {"D1_ITEM", "D1_DOC","D1_SERIE","D1_EMISSAO","D1_QUANT"}
Local aTamCpo1  := {}
Local aTamCpo2  := {}
Local aTamCpo3  := {}
Local cCabec1   := ""
Local cMovi1    := ""
Local cMovi2    := ""
Local cSql      := ""
Local cSqlNfD   := ""
Local cEol      := CHR(13)+CHR(10)
Local nQuant    := 0
Local cString1  := ""
Local cString2  := ""
Local cString3  := ""
Local lPrimeiro := .T.

// Variáveis totalizadoras
local nSaldoPar    := 0
local nSaldoIte    := 0
local nSaldoEnvNf  := 0
local nSaldoDevNf  := 0
local nSaldoEnvCl  := 0
local nSaldoDevCl  := 0
local nSaldoEnv    := 0
local nSaldoDev    := 0
local nSaldoParc   := 0
local nSaldoTot    := 0
local cStringSaldo := ""
local cStringSTot  := ""
local cOldDoc      := ""
local cOldSerie    := ""
local cOldCliente  := ""
local cOldLoja     := ""

//Local oFont1 := TFont():New( 'Courier New',/*uPar2*/,8,/*uPar4*/,.F.,/*uPar6*/,/*uPar7*/,/*uPar8*/,/*uPar9*/,.F.,.F. )

/*public oPrn
oPrn:=TMSPrinter():New()
oPrn:SetPortrait() // ou SetLandscape()
oPrn:SetPage(9)	//Folha A4
oPrn:Setup()
oPrn:Say(0,0," ",oFont1)  */

cCabec1 := PadR("Empresa", len(SM0->M0_NOMECOM))
aAdd(aTamCpo1, len(SM0->M0_NOMECOM))

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos1)
	if DbSeek(aCampos1[i])
		cCabec1 += PadR(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))// + Space(4)
		
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo1, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
	EndIf
Next i
for i := 1 to len(aCampos2)
	if DbSeek(aCampos2[i])
		cMovi1 += PadR(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))// + Space(4)
		
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo2, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
	EndIf
Next i
for i := 1 to len(aCampos3)
	if DbSeek(aCampos3[i])
		if upper(Alltrim(SX3->X3_CAMPO)) == "D1_SERIE"
			cMovi2 += PadR(AllTrim(X3Titulo()), 6)// + Space(4)
		
			Aadd(aTamCpo3, 6)
		elseIf upper(Alltrim(SX3->X3_CAMPO)) == "D1_EMISSAO"
			cMovi2 += PadR(AllTrim(X3Titulo()), 12)// + Space(4)
			
			Aadd(aTamCpo3, 12)
		else
			cMovi2 += PadR(AllTrim(X3Titulo()),iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))// + Space(4)
			
			Aadd(aTamCpo3, iif(Len(X3Titulo()) > SX3->X3_TAMANHO, Len(X3Titulo()), SX3->X3_TAMANHO))
		endIf
	EndIf
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15

cSql := "SELECT SD2.D2_DOC,"                                                         + cEol
cSql += "       SD2.D2_EMISSAO,"                                                     + cEol
cSql += "       SC5.C5_CLIENTE,"                                                     + cEol
cSql += "       SD2.D2_LOJA,"                                                        + cEol
cSql += "       SA1.A1_NOME,"                                                        + cEol
cSql += "       SC5.C5_VEND1,"                                                       + cEol
cSql += "       SA3.A3_NOME,"                                                        + cEol
cSql += "       SB1.B1_COD,"                                                         + cEol
cSql += "       SB1.B1_DESC,"                                                        + cEol
cSql += "       SD2.D2_QUANT,"                                                       + cEol
cSql += "       SD2.D2_FILIAL,"                                                      + cEol
cSql += "       SD2.D2_SERIE,"                                                       + cEol
cSql += "       SD2.D2_ITEM"                                                         + cEol
cSql += "  FROM " + retSqlName("SD2") +" SD2"                                        + cEol
cSql += " INNER JOIN " + retSqlName("SC5") + " SC5 ON SD2.D2_PEDIDO = SC5.C5_NUM"    + cEol
cSql += "   AND SD2.D2_FILIAL = SC5.C5_FILIAL"                                       + cEol
cSql += "   AND SD2.D2_CLIENTE = SC5.C5_CLIENTE"                                     + cEol
cSql += "   AND SD2.D2_LOJA = SC5.C5_LOJACLI"                                        + cEol
cSql += "   AND SC5.D_E_L_E_T_ <> '*'"                                               + cEol
cSql += " INNER JOIN " + retSqlName("SB1") + " SB1 ON SB1.B1_COD = SD2.D2_COD"       + cEol
cSql += "   AND SB1.D_E_L_E_T_ <> '*'"                                               + cEol
cSql += " INNER JOIN " + retSqlName("SA1") + " SA1 ON SA1.A1_COD = SC5.C5_CLIENTE"   + cEol
cSql += "   AND SA1.A1_LOJA = SC5.C5_LOJACLI"                                        + cEol
cSql += "   AND SA1.D_E_L_E_T_ <> '*'"                                               + cEol
cSql += " INNER JOIN " + retSqlName("SA3") + " SA3 ON SA3.A3_COD = SC5.C5_VEND1"     + cEol
cSql += "   AND SA3.D_E_L_E_T_ <> '*'"                                               + cEol
cSql += " WHERE SD2.D_E_L_E_T_ <> '*'"                                               + cEol
//cSql += "   AND SD2.D2_TES = '599'"                                                  + cEol
cSql += "   AND SD2.D2_CF IN ('" + MV_PAR09 + "', '" + MV_PAR10 + "')"               + cEol
cSql += "   AND SD2.D2_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'"    + cEol
cSql += "   AND SA3.A3_COD BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'"        + cEol
cSql += "   AND SA1.A1_COD BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "'"        + cEol
cSql += "   AND SD2.D2_FILIAL BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'"     + cEol
cSql += " ORDER BY SD2.D2_CLIENTE, SD2.D2_LOJA, SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_FILIAL, SD2.D2_ITEM"

TCQUERY cSql NEW ALIAS "NFOTMP"

DbSelectArea("NFOTMP")
NFOTMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if NFOTMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	NFOTMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosEmp := aScan(aCampos1, {|x| AllTrim(x) == "M0_NOMECOM"})
nPosDoc := aScan(aCampos1, {|x| AllTrim(x) == "D2_DOC"})
nPosSer := aScan(aCampos1, {|x| AllTrim(x) == "D2_SERIE"})
nPosEmi := aScan(aCampos1, {|x| AllTrim(x) == "D2_EMISSAO"})
nPosCli := aScan(aCampos1, {|x| AllTrim(x) == "C5_CLIENTE"}) 
nPosNCl := aScan(aCampos1, {|x| AllTrim(x) == "A1_NOME"})
nPosVen := aScan(aCampos1, {|x| AllTrim(x) == "C5_VEND1"})
nPosNVe := aScan(aCampos1, {|x| AllTrim(x) == "A3_NOME"})

nPosItS := aScan(aCampos2, {|x| AllTrim(x) == "D2_ITEM"})
nPosPro := aScan(aCampos2, {|x| AllTrim(x) == "B1_COD"})
nPosNPr := aScan(aCampos2, {|x| AllTrim(x) == "B1_DESC"})
nPosSai := aScan(aCampos2, {|x| AllTrim(x) == "D2_QUANT"})

nPosItE := aScan(aCampos3, {|x| AllTrim(X) == "D1_ITEM"})
nPosDoE := aScan(aCampos3, {|x| AllTrim(x) == "D1_DOC"})
nPosSeE := aScan(aCampos3, {|x| AllTrim(x) == "D1_SERIE"})
nPosEmE := aScan(aCampos3, {|x| AllTrim(x) == "D1_EMISSAO"})
nPosEnt := aScan(aCampos3, {|x| AllTrim(x) == "D1_QUANT"})

nPosSaldEn := 0
for nI = 1 to len(aTamCpo2) - 1
	nPosSaldEn += aTamCpo2[nI]
next

nPosSaldSa := 0
for nI = 1 to len(aTamCpo3) - 1
	nPosSaldSa += aTamCpo3[nI]
next

count to nQuant 
NFOTMP->(DbGoTop())
SetRegua(nQuant)

While !NFOTMP->(EOF())
	IncRegua()
	
	if lPrimeiro
		cabec(titulo, "", "", cNomeProg, cTamanho, 15)
	endIf
	
	if cOldDoc != NFOTMP->D2_DOC .or. cOldSerie != NFOTMP->D2_SERIE
		if !lPrimeiro
			nSaldoParc  := nSaldoEnvNf - nSaldoDevNf
			cSaldoEnvNf := Transform(nSaldoEnvNf,  PesqPict("SD2","D2_QUANT"))
			cSaldoDevNf := Transform(nSaldoDevNf,  PesqPict("SD1","D1_QUANT"))
			cSaldoParc  := Transform(nSaldoParc,   PesqPict("SD1","D1_QUANT"))
			
			cStringSaldo := "Saldo" + space (nPosSaldEn - 5) + cSaldoEnvNf + space(nPosSaldSa + 3) + cSaldoDevNf + space(4) + cSaldoParc
			nSaldoEnvNf := 0
			nSaldoDevNf := 0
			
			li++
			@ li, 0 PSAY cStringSaldo
			li++
			
			if cOldCliente != NFOTMP->C5_CLIENTE .or. cOldLoja != NFOTMP->D2_LOJA
				nSaldoParCL := nSaldoEnvCl - nSaldoDevCl
				cSaldoEnvCl := Transform(nSaldoEnvCl,  PesqPict("SD2","D2_QUANT"))
				cSaldoDevCl := Transform(nSaldoDevCl,  PesqPict("SD1","D1_QUANT"))
				cSaldoParCl := Transform(nSaldoParCl,  PesqPict("SD1","D1_QUANT"))
				
				cStringSCli := "Saldo Cliente" + space (nPosSaldEn - 13) + cSaldoEnvCL + space(nPosSaldSa + 3) + cSaldoDevCL + space(4) + cSaldoParCl
				nSaldoEnvCl := 0
				nSaldoDevCl := 0
			  
				@ li, 0 PSAY cStringSCli
				li++
				@li,0 PSAY __PrtThinLine()
				li++
			endIf
		endIF
		cOldDoc      := NFOTMP->D2_DOC
		cOldSerie    := NFOTMP->D2_SERIE
		cOldCliente  := NFOTMP->C5_CLIENTE
		cOldLoja     := NFOTMP->D2_LOJA
		
		// Monta a String da linha do relatório
		cString1 := PadC(SM0->M0_NOMECOM,                 aTamCpo1[nPosEmp]) +;//Space(4)+;
	             	PadC(NFOTMP->D2_DOC,                  aTamCpo1[nPosDoc]) +;//Space(4)+;
			 				  PadC(NFOTMP->D2_SERIE,                aTamCpo1[nPosSer]) +;//Space(4)+; 
							  PadC(DtoC(StoD(NFOTMP->D2_EMISSAO)),  aTamCpo1[nPosEmi]) +;//Space(4)+;
							  PadC(NFOTMP->C5_CLIENTE,              aTamCpo1[nPosCli]) +;//Space(4)+; 
							  PadR(NFOTMP->A1_NOME,                 aTamCpo1[nPosNCl]) +;//Space(4)+; 
							  PadC(NFOTMP->C5_VEND1,                aTamCpo1[nPosVen]) +;//Space(4)+; 
							  PadC(NFOTMP->A3_NOME,                 aTamCpo1[nPosNVe])
		
		li++
		@ li, 0 PSAY cCabec1
		li++
		@ li, 0 PSAY cString1
		li++
		@li, 0 PSAY cMovi1 + space(4) + cMovi2 + space(4) + "Saldo"
		li++
	endIf
  cQuantSaida := Transform(NFOTMP->D2_QUANT,  PesqPict("SD2","D2_QUANT"))
	cString2 := PadC(NFOTMP->D2_ITEM,  aTamCpo2[nPosItS])+; 
							PadC(NFOTMP->B1_COD,   aTamCpo2[nPosPro])+;
							PadC(NFOTMP->B1_DESC,  aTamCpo2[nPosNPr])+;
							PadL(cQuantSaida,      aTamCpo2[nPosSai])
							
	@ li, 0 PSAY cString2
	
	nSaldoEnv += NFOTMP->D2_QUANT
	nSaldoEnvNf += NFOTMP->D2_QUANT
	nSaldoEnvCl += NFOTMP->D2_QUANT
	nSaldoPar := 0
	
	cSqlNfD := "SELECT SD1.D1_DOC,"                                   + cEol
	cSqlNfD += "       SD1.D1_SERIE,"                                 + cEol
	cSqlNfD += "       SD1.D1_ITEM,"                                  + cEol
	cSqlNfD += "       SD1.D1_QUANT,"                                 + cEol
	cSqlNfD += "       SD1.D1_EMISSAO"                                + cEol
	cSqlNfD += "  FROM " + retSqlName("SD1") + " SD1"                 + cEol
	cSqlNfD += " WHERE SD1.D1_FILIAL  = '" + NFOTMP->D2_FILIAL  + "'" + cEol
	cSqlNfD += "   AND SD1.D1_NFORI   = '" + NFOTMP->D2_DOC     + "'" + cEol
	cSqlNfD += "   AND SD1.D1_SERIORI = '" + NFOTMP->D2_SERIE   + "'" + cEol
	cSqlNfD += "   AND SD1.D1_FORNECE = '" + NFOTMP->C5_CLIENTE + "'" + cEol
	cSqlNfD += "   AND SD1.D1_LOJA    = '" + NFOTMP->D2_LOJA    + "'" + cEol
	cSqlNfD += "   AND SD1.D1_ITEMORI = '" + NFOTMP->D2_ITEM    + "'" + cEol
	cSqlNfD += "   AND SD1.D_E_L_E_T_ <> '*'"                         + cEol
	cSqlNfD += " ORDER BY SD1.D1_DOC, SD1.D1_SERIE"
	
	TCQUERY cSqlNfD NEW ALIAS "NFDTMP"

	DbSelectArea("NFDTMP")
	NFDTMP->(DbGoTop())
	
	While !NFDTMP->(EOF())
		cQuantDevo := Transform(NFDTMP->D1_QUANT,  PesqPict("SD1","D1_QUANT"))
		cEmissao   := SToD(NFDTMP->D1_EMISSAO)
		cString3 := PadC(NFDTMP->D1_ITEM,  aTamCpo3[nPosIte])+; 
								PadC(NFDTMP->D1_DOC,   aTamCpo3[nPosDoE])+;
								PadL(NFDTMP->D1_SERIE, 7)+;
								PadL(cEmissao,         10)+;
								PadC(cQuantDevo,       aTamCpo3[nPosEnt])

		@ li, len(cString2) + 4 PSAY cString3		
		nSaldoPar += NFDTMP->D1_QUANT
		nSaldoDev += NFDTMP->D1_QUANT
		nSaldoDevNf += NFDTMP->D1_QUANT
		nSaldoDevCl += NFDTMP->D1_QUANT
		NFDTMP->(DbSkip())
	endDo
	
	nSaldoIte := NFOTMP->D2_QUANT - nSaldoPar
	cSaldoIte := Transform(nSaldoIte,  PesqPict("SD1","D1_QUANT"))
	
	@ li, len(cString2) + len(cString3) + 8 PSAY cSaldoIte

	nCntImpr++
	li++
	
	if li > 60
		li := 66
		cabec(titulo, "", "", cNomeProg, cTamanho, 15)	
	EndIf
	
	lPrimeiro := .F.
	
	// Imprime totalização dos registros.
	NFOTMP->(DbSkip())
	NFDTMP->(DbCloseArea())
	if NFOTMP->(EOF())
		nSaldoParc  := nSaldoEnvNf - nSaldoDevNf
		cSaldoEnvNf := Transform(nSaldoEnvNf,  PesqPict("SD2","D2_QUANT"))
		cSaldoDevNf := Transform(nSaldoDevNf,  PesqPict("SD1","D1_QUANT"))
		cSaldoParc  := Transform(nSaldoParc,   PesqPict("SD1","D1_QUANT"))
    
    cStringSaldo := "Saldo" + space (nPosSaldEn - 5) + cSaldoEnvNf + space(nPosSaldSa + 3 ) + cSaldoDevNf + space(4) + cSaldoParc
		li++
		@ li, 0 PSAY cStringSaldo
		
		li++
		
		nSaldoParCL := nSaldoEnvCl - nSaldoDevCl
		cSaldoEnvCl := Transform(nSaldoEnvCl,  PesqPict("SD2","D2_QUANT"))
		cSaldoDevCl := Transform(nSaldoDevCl,  PesqPict("SD1","D1_QUANT"))
		cSaldoParCl  := Transform(nSaldoParCl,  PesqPict("SD1","D1_QUANT"))
		
	cStringSCli := "Saldo Cliente" + space (nPosSaldEn - 13) + cSaldoEnvCl + space(nPosSaldSa + 3 ) + cSaldoDevCl + space(4) + cSaldoParCl
		nSaldoEnvCl := 0
		nSaldoDevCl := 0
			
		@ li, 0 PSAY cStringSCli
		li++
		
		nSaldoTot := nSaldoEnv - nSaldoDev
		cSaldoEnv := Transform(nSaldoEnv,  PesqPict("SD2","D2_QUANT"))
		cSaldoDev := Transform(nSaldoDev,  PesqPict("SD1","D1_QUANT"))
		cSaldoTot := Transform(nSaldoTot,  PesqPict("SD1","D1_QUANT"))
		
		cStringSTot := "Saldo Total" + space (nPosSaldEn - 11) + cSaldoEnv + space(nPosSaldSa + 3 ) + cSaldoDev + space(4) + cSaldoTot
		
		li++
		li++
		@ li, 0 PSAY cStringSTot
	EndIf
EndDo  

NFOTMP->(DbCloseArea())

Set Device to Screen
if aReturn[5] = 1
	Set Printer To
	DbCommitAll()
	OurSpool(wnrel)
EndIf          

MS_FLUSH()
return .T.

static function quebraLinha(li, titulo, cNomeProg, cTamanho)
	li++
	if li > 60
		li := 66
		cabec(titulo, "", "", cNomeProg, cTamanho, 15)	
	EndIf
return li

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
	PutSx1(cPerg,"01","Emissão de ?" ,        "Emissão de ?" ,        "Emissão de ?" ,        "mv_ch1","D",08                 ,0,0,"G","","   ","","","MV_PAR01")
	PutSx1(cPerg,"02","Emissão até ?",        "Emissão até ?",        "Emissão até ?",        "mv_ch2","D",08                 ,0,0,"G","","   ","","","MV_PAR02")
	PutSx1(cPerg,"03","Vendedor de ?" ,       "Vendedor de ?",        "Vendedor de ?",        "mv_ch3","C",TAMSX3("A3_COD")[1],0,0,"G","","SA3","","","MV_PAR03")
	PutSx1(cPerg,"04","Vendedor até ?",       "Vendedor até ?",       "Vendedor até ?",       "mv_ch4","C",TAMSX3("A3_COD")[1],0,0,"G","","SA3","","","MV_PAR04")
	PutSx1(cPerg,"05","Cliente de ?",         "Cliente de ?",         "Cliente de ?",         "mv_ch5","C",TAMSX3("A1_COD")[1],0,0,"G","","SA1","","","MV_PAR05")
	PutSx1(cPerg,"06","Cliente até ?",        "Cliente até ?",        "Cliente até ?",        "mv_ch6","C",TAMSX3("A1_COD")[1],0,0,"G","","SA1","","","MV_PAR06")
	PutSx1(cPerg,"07","Filial de ?",          "Filial de ?",          "Filial de ?",          "mv_ch7","C",02                 ,0,0,"G","","   ","","","MV_PAR07")
	PutSx1(cPerg,"08","Filial até ?",         "Filial até ?",         "Filial até ?",         "mv_ch8","C",02                 ,0,0,"G","","   ","","","MV_PAR08")
	PutSx1(cPerg,"09","CFOP dentro Estado ?", "CFOP dentro Estado ?", "CFOP dentro Estado ?", "mv_ch9","C",04                 ,0,0,"G","","   ","","","MV_PAR09")
	PutSx1(cPerg,"10","CFOP fora Estado ?",   "CFOP fora Estado ?",   "CFOP fora Estado ?",   "mv_ch10","C",04                ,0,0,"G","","   ","","","MV_PAR10")
Return Nil