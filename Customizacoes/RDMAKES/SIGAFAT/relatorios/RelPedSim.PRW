#include "rwmake.ch" 
#include "protheus.ch"
#include "Topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELPEDSIM ºAutor  ³Roberto Rosin       º Data ³  07/08/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório de Pedidos SIM3g Importados                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Vendas                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function RelPedSim()
Local wnRel
Local cAlias    := "SC5"
Local titulo    := "Relatório de Pedidos Sim3g"
Local cNomeProg := "RELPEDSIM"
Local cTamanho  := "G"                                          
Local cPerg     := "RELPEDSIM"
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

// Variáveis totalizadoras
local cDataTran := ""
local cEmissNota := ""

Local aCampos := {"NUMEROPEDIDO", "DATATRANSMISSAO", "HORATRANSMISSAO", "C5_NUM", "F2_EMISSAO", "F2_HORA", "F2_DOC"}

// Cria o cabeçalho do relatório com o nome padrão dos campos de acordo com o SX3
DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCampos)
	if DbSeek(aCampos[i]) .and. aCampos[i] <> "NUMEROPEDIDO" .and. aCampos[i] <> "DATATRANSMISSAO" .and. aCampos[i] <> "HORATRANSMISSAO" .and. aCampos[i] <> "C5_NUM" .and. aCampos[i] <> "F2_DOC"
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

	if aCampos[i] == "NUMEROPEDIDO"
		cCabec1 += PadC("Num. Pedi. SIM 3G",20) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 20)
	elseIf(aCampos[i] == "DATATRANSMISSAO")
		cCabec1 += PadC("Data Transmissão",20) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 20)
	elseIf(aCampos[i] == "HORATRANSMISSAO")
		cCabec1 += PadC("Hora Transmissão",20) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 20)
	elseIf(aCampos[i] == "C5_NUM") 
		cCabec1 += PadC("Pedido Siga", 12) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 12)
	elseIf(aCampos[i] == "F2_DOC") 
		cCabec1 += PadC("Nota Fiscal", 12) + Space(4)
		// Grava num array (aTamCpo) o tamanho dos campos do relatório
		Aadd(aTamCpo, 12)
	endIf    
Next i

nCntImpr := 0
li     := 80
m_pag  := 1
nTipo  := 15
cOpcao := Transform(MV_PAR04, "@!") 

//monta o SELECT

cSql := "SELECT PEDI.NUMEROPEDIDO AS PED_SIM3G,"                 + cEol
cSql += "TO_CHAR(PEDI.DATATRANSMISSAO,'YYYYMMDD') AS DT_TR_PED," + cEol
cSql += "PEDI.HORATRANSMISSAO AS H_TR_PED,"       + cEol
cSql += "SC5.C5_NUM AS PED_SIGA,"                 + cEol
cSql += "SF2.F2_EMISSAO AS EMIS_NOTA,"            + cEol
cSql += "SF2.F2_HORA AS HORA_NOTA,"               + cEol
cSql += "SF2.F2_DOC AS NUMENOTA"                  + cEol
cSql += "FROM " + RetSqlName("SC5") + " SC5"      + cEol
cSql += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON SC5.C5_FILIAL = SD2.D2_FILIAL AND SC5.C5_NUM = SD2.D2_PEDIDO AND SC5.C5_CLIENTE = SD2.D2_CLIENTE AND SC5.C5_LOJACLI = SD2.D2_LOJA AND SD2.D_E_L_E_T_ <> '*'"  + cEol
cSql += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL AND SF2.F2_CLIENTE = SD2.D2_CLIENTE AND SF2.F2_LOJA = SD2.D2_LOJA AND SF2.F2_DOC = SD2.D2_DOC AND SF2.D_E_L_E_T_ <> '*'"        + cEol
cSql += "INNER JOIN PEDIDO PEDI ON TRIM(SC5.C5_COTACAO) = TRIM(SUBSTR(PEDI.NUMEROPEDIDO,1,9)) AND SC5.C5_SIM3G = 'T' AND PEDI.IDLOCALFILIALFATURAMENTO = '" + cEmpAnt + "#" + cFilAnt + "' AND PEDI.IDLOCAL = SC5.C5_CLIENTE ||'-'|| SC5.C5_LOJACLI "   + cEol

cSql += "WHERE SC5.D_E_L_E_T_ <> '*'"     + cEol
cSql += "AND SC5.C5_FILIAL = '"  + xFilial("SC5") + "' " + cEol
cSql += "AND SC5.C5_EMISSAO BETWEEN '" + DtoS(MV_PAR05) + "' AND '" + DtoS(MV_PAR06) + "'"  + cEol
cSql += "AND SF2.F2_EMISSAO BETWEEN '" + DtoS(MV_PAR09) + "' AND '" + DtoS(MV_PAR10) + "'"  + cEol

//if !empty(MV_PAR01) .and. MV_PAR02 != "ZZZZZZZZZZ"
  cSql += "AND PEDI.NUMEROPEDIDO BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "'" + cEol
//endIf
//if !empty(MV_PAR03) .and. MV_PAR04 != "ZZZZZZZZZZ"
	cSql += "AND SC5.C5_NUM BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'" + cEol
//endIf
//if !empty(MV_PAR07) .and. MV_PAR08 != "ZZZZZZZZZZ"
	cSql += "AND SF2.F2_DOC BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "'" + cEol
//endIf
cSql += "GROUP BY PEDI.NUMEROPEDIDO, TO_CHAR(PEDI.DATATRANSMISSAO,'YYYYMMDD'), PEDI.HORATRANSMISSAO, SC5.C5_NUM, SF2.F2_EMISSAO, SF2.F2_HORA, SF2.F2_DOC"  + cEol
cSql += "ORDER BY PEDI.NUMEROPEDIDO"

/*
if Aviso("Continuar??",cSql,{"Sim","Não"},3) != 1
	Return nil
EndIf
*/

TCQUERY cSql NEW ALIAS "SC5TMP"

DbSelectArea("SC5TMP")
SC5TMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if SC5TMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	SC5TMP->(DbCloseArea())
	Return nil	
EndIf                  

// Busca a posição do campo no array de campos para saber qual o tamanho do campo no relatório
nPosPSim3g := aScan(aCampos, {|x| AllTrim(x) == "NUMEROPEDIDO"   })
nPosTransP := aScan(aCampos, {|x| AllTrim(x) == "DATATRANSMISSAO"})
nPosHTranP := aScan(aCampos, {|x| AllTrim(x) == "HORATRANSMISSAO"})
nPosPSiga  := aScan(aCampos, {|x| AllTrim(x) == "C5_NUM"         })
nPosEmisNo := aScan(aCampos, {|x| AlLTrim(x) == "F2_EMISSAO"     })
nPosHoraNo := aScan(aCampos, {|x| AllTrim(x) == "F2_HORA"        })
nPosNumeNo := aScan(aCampos, {|x| AllTrim(x) == "F2_DOC"         })

count to nQuant 
SC5TMP->(DbGoTop())
SetRegua(nQuant)

While !SC5TMP->(EOF())
	IncRegua()
 	if li > 60
		cabec(titulo, cCabec1, "", cNomeProg, cTamanho, 15)
		@ li, 0 PSAY __PrtThinLine()
	EndIf
	li++
	
	cDataTran := StoD(SC5TMP->DT_TR_PED)
	cEmisNota := StoD(SC5TMP->EMIS_NOTA)
	
	//ajusta as mascaras dos campos nescessários 
 	cString := PadC(SC5TMP->PED_SIM3G, aTamCpo[nPosPSim3g]) + Space(4)
	cString += PadC(cDataTran,         aTamCpo[nPosTransP]) + Space(4)
	cString += PadC(SC5TMP->H_TR_PED,  aTamCpo[nPosHTranP]) + Space(4)
	cString += PadC(SC5TMP->PED_SIGA,  aTamCpo[nPosPSiga ]) + Space(4)
	cString += PadC(cEmisNota,         aTamCpo[nPosEmisNo]) + Space(4)
	cString += PadC(SC5TMP->HORA_NOTA, aTamCpo[nPosHoraNo]) + Space(4)
	cString += PadC(SC5TMP->NUMENOTA,  aTamCpo[nPosNumeNo])
	                                            
	@ li, 01 PSAY cString
	
	if li > 60
		li := 66	
	EndIf
	
	// Imprime totalização dos registros.
	SC5TMP->(DbSkip())
	
EndDo

SC5TMP->(DbCloseArea())

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
	
	PutSx1(cPerg,"01","Pedido SIM 3G de ?",         "Pedido SIM 3G de ?",        "Pedido SIM 3G de ?",        "mv_ch1" ,"C",10,0,0,"G","","   ","","","MV_PAR01")
	PutSx1(cPerg,"02","Pedido SIM 3G até ?",        "Pedido SIM 3G até ?",       "Pedido SIM 3G até ?",       "mv_ch2" ,"C",10,0,0,"G","","   ","","","MV_PAR02")
	PutSx1(cPerg,"03","Pedido Siga de ?",           "Pedido Siga de ?",          "Pedido Siga de ?",          "mv_ch3" ,"C",10,0,0,"G","","   ","","","MV_PAR03")
	PutSx1(cPerg,"04","Pedido Siga até ?",          "Pedido Siga até ?",         "Pedido Siga até ?",         "mv_ch4" ,"C",10,0,0,"G","","   ","","","MV_PAR04")	
	PutSx1(cPerg,"05","Data Pedido (Inicio) ?",     "Data Pedido (Inicio) ?",    "Data Pedido (Inicio) ?",    "mv_ch5" ,"D",08,0,0,"G","","   ","","","MV_PAR05") 
	PutSx1(cPerg,"06","Data Pedido (Final) ?",      "Data Pedido (Final) ?",     "Data Pedido (Final) ?",     "mv_ch6" ,"D",08,0,0,"G","","   ","","","MV_PAR06")
	PutSx1(cPerg,"07","Nota Fiscal de ?",           "Nota Fiscal de ?",          "Nota Fiscal de ?",          "mv_ch7" ,"C",10,0,0,"G","","   ","","","MV_PAR07")
	PutSx1(cPerg,"08","Nota Fiscal até ?",          "Nota Fiscal até ?",         "Nota Fiscal até ?",         "mv_ch8" ,"C",10,0,0,"G","","   ","","","MV_PAR08")
	PutSx1(cPerg,"09","Emissão Nota (Inicio) ?",    "Data Nota (Inicio) ?",      "Data NOta (Inicio) ?",      "mv_ch9" ,"D",08,0,0,"G","","   ","","","MV_PAR09") 
	PutSx1(cPerg,"10","Emissão Nota (Final) ?",     "Data NOta (Final) ?",       "Data Nota (Final) ?",       "mv_ch10","D",08,0,0,"G","","   ","","","MV_PAR10")
Return Nil