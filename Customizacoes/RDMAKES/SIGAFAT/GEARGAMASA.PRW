#include "rwmake.ch"
#include "protheus.ch"
#include "Topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GEARGAMASAºAutor  ³Roberto Rosin       º Data ³  09/11/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera arquivo de integração com a empresa Gamasa             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP Integração com empresa parceira.                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

user function GEARGAMASA()
local cPerg := "GEARGAMASA" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//monta as perguntas
AjustaSX(cPerg)

//mostra a tela de perguntas
pergunte(cPerg)

//chama a função para gerar o arquivo exibindo uma régua de status
RptStatus({|lENd| montaArqui() }, "Processando...")
return

//função que monta o arquivo
static function montaArqui()
local cSql   := ""
local cEol   := CHR(13)+CHR(10)
local cLinha := ""

//monta o sql
cSql += "SELECT SF2.F2_DOC,"                 + cEol
cSql += "SF2.F2_SERIE,"                      + cEol
cSql += "SF2.F2_VALBRUT,"                    + cEol
cSql += "SF2.F2_CLIENTE,"                    + cEol
cSql += "SF2.F2_LOJA,"                       + cEol
cSql += "SA1.A1_CGC,"                        + cEol
cSql += "SA1.A1_NOME,"                       + cEol
cSql += "SA1.A1_END,"                        + cEol
cSql += "SA1.A1_BAIRRO,"                     + cEol
cSql += "SA1.A1_MUN,"                        + cEol
cSql += "SA1.A1_CEP,"                        + cEol
cSql += "SF2.F2_DOC,"                        + cEol
cSql += "SD2.D2_PEDIDO,"                     + cEol
cSql += "SB1.B1_COD,"                        + cEol
cSql += "SB1.B1_DESC,"                       + cEol
cSql += "SD2.D2_QTDEFAT,"                    + cEol
cSql += "SD2.D2_VALBRUT,"                    + cEol
cSql += "SD2.D2_PESO,"                       + cEol
cSql += "SF2.F2_EMISSAO,"                    + cEol
cSql += "SA1.A1_INSCR,"                      + cEol
cSql += "SA1.A1_EST,"                        + cEol
cSql += "SB1.B1_QE,"                         + cEol
cSql += "SD2.D2_UM,"                         + cEol
cSql += "SF2.F2_PBRUTO"                      + cEol
cSql += "FROM " + RetSqlName("SF2") + " SF2" + cEol
cSql += "INNER JOIN " + RetSqlName("SD2") + " SD2 ON SF2.F2_FILIAL  = SD2.D2_FILIAL"        + cEol
cSql += "                     AND SF2.F2_DOC     = SD2.D2_DOC "                             + cEol
cSql += "                     AND SF2.F2_SERIE   = SD2.D2_SERIE "                           + cEol
cSql += "                     AND SF2.F2_CLIENTE = SD2.D2_CLIENTE "                         + cEol
cSql += "                     AND SF2.F2_LOJA    = SD2.D2_LOJA"                             + cEol
cSql += "                     AND SD2.D_E_L_E_T_ <> '*'"                                    + cEol
//CLIENTE
cSql += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD   = SF2.F2_CLIENTE"          + cEol
cSql += "                                AND SA1.A1_LOJA = SF2.F2_LOJA"                      + cEol
cSql += "                                AND SA1.D_E_L_E_T_ <> '*'"                          + cEol
//PRODUTO
cSql += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_COD = SD2.D2_COD"                + cEol
cSql += "                     AND SB1.D_E_L_E_T_ <> '*'"                                     + cEol
cSql += "WHERE SF2.F2_EMISSAO BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "'" + cEol
cSql += "  AND SF2.D_E_L_E_T_ <> '*'"                                                        + cEol
cSql += "  AND SF2.F2_FILIAL = '"      + SM0->M0_CODFIL + "'"                                + cEol
cSql += "  AND SF2.F2_DOC BETWEEN '"   + MV_PAR03       + "' AND '" + MV_PAR04 + "'"         + cEol
cSql += "  AND SF2.F2_SERIE BETWEEN '" + MV_PAR05       + "' AND '" + MV_PAR06 + "'"         + cEol
cSql += "ORDER BY SF2.F2_DOC"

//gera uma tabela temporária com os dados obtidos na consulta SQL
TCQUERY cSql NEW ALIAS "SF2TMP"

//
DbSelectArea("SF2TMP")
//posiciona no primeiro registro
SF2TMP->(DbGoTop())

// Se a tabela estiver vazia, retorna mensagem que não há dados para o usuário.
if SF2TMP->(EOF())
	Aviso("Tabela Vazia", "Não há dados a serem exibidos.",{"Ok"})
	SF2TMP->(DbCloseArea())
	Return	
EndIf

count to nQuant 
SF2TMP->(DbGoTop())
setRegua(nQuant)

//monta o caminho do arquivo com o parâmetro 07, "Caminho Arquivo", nome da empresa logada e data base
cArqui := alltrim(MV_PAR07) + alltrim(SM0->M0_NOME) + gravaData(dDataBase, .F., 8) + ".txt"
//monta o arquivo
nHandle := fCreate(cArqui)

//se não conseguiu montar o arquivo gera um erro e interrompe a execução
if nHandle == -1
	msgInfo("Erro na criação do arquivo")
	return
endIf

//percore a tabela temporária
While !SF2TMP->(EOF())
	//incrementa a régua de status
	incRegua()
	
	//formata os valores números de acordo com o que é pedido no Layout
	cValorNota := replace(transform(SF2TMP->F2_VALBRUT, "@E 9999999.99"),",","")
	cQuanProd  := replace(transform(SF2TMP->D2_QTDEFAT, "@E  999999.99"),",","")
	cValoProd  := replace(transform(SF2TMP->D2_VALBRUT, "@E  999999.99"),",","")
	cPesoProd  := replace(transform(SF2TMP->D2_PESO,    "@E  99999.999"),",","")
	cPesoNota  := replace(transform(SF2TMP->F2_PBRUTO,  "@E 999999.999"),",","")
	cIncrEstad := replace(replace(A1_INSCR,".",""),"-","")
	
	//adiciona na variável cLinha todos os campos
	cLinha += padr("",6)//código do embarcador
	cLinha += gravaData(dDataBase, .F., 8) //data de geração do arquivo
	cLinha += substr(SF2TMP->F2_DOC,4,6)   //nota fiscal
	cLinha += padr(SF2TMP->F2_SERIE,3)     //série nota fiscal
	cLinha += cValorNota                   //VALOR TOTAL DA NOTA
	cLinha += space(6)                     //substr(SF2TMP->F2_CLIENTE, len(trim(SF2TMP->F2_CLIENTE)) - 6,len(trim(SF2TMP->F2_CLIENTE)))//código do cliente
	cLinha += space(2)                     //loja do cliente
	cLinha += padR(SF2TMP->A1_CGC,15)      //CNPJ do cliente
	cLinha += padR(SF2TMP->A1_NOME,40)     //nome do cliente
	cLinha += padR(SF2TMP->A1_END,30)      //endereço de entrega
	cLinha += padR(SF2TMP->A1_BAIRRO,20)   //bairro de entrega
	cLinha += padR(SF2TMP->A1_MUN,20)      //municipio de entrega
	cLinha += padR(SF2TMP->A1_CEP,8)       //CEP de entrega
	cLinha += padR(SF2TMP->D2_QTDEFAT,3)   //quantidade de caixas por produto
	cLinha += padR(SF2TMP->D2_PEDIDO,6)    //número do pedido
	cLinha += padR(SF2TMP->B1_COD,15)      //código do produto
	cLinha += padR(SF2TMP->B1_DESC,30)     //descrição do produto
	cLinha += cQuanProd                    //quantidade de items
	cLinha += cValoProd                    //Valor do Item
	cLinha += cPesoProd                    //Peso bruto total do produto
	cLinha += space(1)                     //tipo de nota fiscal
	cLinha += space(1)                     //tipo de entrega
	cLinha += padR(SF2TMP->F2_EMISSAO,8)   //data de emissão
	cLinha += padR(cIncrEstad,20)          //inscrição estadual
	cLinha += padR(SF2TMP->A1_EST,2)       //sigla do estado de entrega
	cLinha += padR(SF2TMP->B1_QE,6)        //quantidade de produtos por caixa
	cLinha += space(3)                     //série nota fiscal retorno
	cLinha += space(8)                     //cubagem
	cLinha += padR(SF2TMP->D2_UM,2)        //unidade de medida
	cLinha += space(8)                     //preço de remessa do item
	cLinha += cPesoNota                    //peso bruto da nota fiscal
	cLinha += padR(SM0->M0_CGC,15)         //CNPJ do fornecedor para identificação do remetente
	cLinha += cEol                         //quebra a linha
	
	//escreve a linha no arquivo
	fWrite(nHandle, cLinha, len(cLinha))
	
	//limpa a variável cLinha
	cLinha := ""
	
	//passa para o próximo registro da tabela temporária
	SF2TMP->(DbSkip())
endDo

//fecha o arquivo
fClose(nHandle)

//fecha a tabela temporária
SF2TMP->(DbCloseArea())
                 
//informa que o arquivo foi gerado
msgInfo("Arquivo gerado com sucesso em " + cArqui)
return .T.

//monta as perguntas...
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
	PutSx1(cPerg,"01","Data Nota de ?",     "Data Pedido de ?",    "Data Pedido de ?",    "mv_ch1" ,"D",08,0,0,"G","","   ","","","MV_PAR01")
	PutSx1(cPerg,"02","Data Nota até ?",    "Data Pedido até ?",   "Data Pedido até ?",   "mv_ch2" ,"D",08,0,0,"G","","   ","","","MV_PAR02")
	PutSx1(cPerg,"03","Nota de ?",          "Nota de ?",           "Nota de ?",           "mv_ch3" ,"C",09,0,0,"G","","   ","","","MV_PAR03") 
	PutSx1(cPerg,"04","Nota até ?",         "Nota até ?",          "Nota até ?",          "mv_ch4" ,"C",09,0,0,"G","","   ","","","MV_PAR04")
	PutSx1(cPerg,"05","Serie de ?",         "Serie de ?",          "Serie de ?",          "mv_ch5" ,"C",03,0,0,"G","","   ","","","MV_PAR05") 
	PutSx1(cPerg,"06","Serie até ?",        "Serie até ?",         "Serie até ?",         "mv_ch6" ,"C",03,0,0,"G","","   ","","","MV_PAR06")
	PutSx1(cPerg,"07","Caminho Arquivo",    "Caminho Arquivo",     "Camiho Arquivo",      "mv_ch7" ,"C",80,0,0,"G","","   ","","","MV_PAR07")
Return Nil