#include "rwmake.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณDOCDEBIT บAutor  ณRoberto Rosin        บ Data ณ 16/01/2013  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma para a impressใo de notas fiscais de d้bito para   บฑฑ
ฑฑบ          ณfiliais.                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DOCDEBIT()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
LOCAL oDlg       := NIL
LOCAL cString    := "SC7"
LOCAL cPerg      := "DOCDEBIT"
PRIVATE titulo   := ""
PRIVATE nLastKey := 0
PRIVATE nomeProg := FunName()
Private nTotal   := 0
Private nSubTot  := 0
Private nL       := 0
AjustaSx1(cPerg)
If ! Pergunte(cPerg,.T.)
	Return
Endif    


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Variaveis utilizadas para parametros					  		ณ
//ณ mv_par01				// Numero da PT                   		ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
wnrel := FunName()            //Nome Default do relatorio em Disco

PRIVATE cTitulo  := "Impressใo do Pedido de Vendas"
PRIVATE oPrn     := NIL
PRIVATE oFont1   := NIL
PRIVATE oFont2   := NIL
PRIVATE oFont3   := NIL
PRIVATE oFont4   := NIL
PRIVATE oFont5   := NIL
PRIVATE oFont6   := NIL
Private nLastKey := 0
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

DEFINE FONT oFont1 NAME "Times New Roman" SIZE 0,20 BOLD   OF oPrn
DEFINE FONT oFont2 NAME "Times New Roman" SIZE 0,14 BOLD   OF oPrn
DEFINE FONT oFont3 NAME "Times New Roman" SIZE 0,14        OF oPrn
DEFINE FONT oFont4 NAME "Times New Roman" SIZE 0,14 ITALIC OF oPrn
DEFINE FONT oFont5 NAME "Times New Roman" SIZE 0,14        OF oPrn
DEFINE FONT oFont6 NAME "Courier New" BOLD

/*oFont06  := TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
oFont08  := TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
oFont10  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
oFont14  := TFont():New("Arial",14,14,,.F.,,,,.T.,.F.)
oFont16  := TFont():New("Arial",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
oFont06  := TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Arial",06,06,,.T.,,,,.T.,.F.)*/

oFont07  := TFont():New("Times New Roman",07,07,,.F.,,,,.T.,.F.)
oFont08  := TFont():New("Times New Roman",08,08,,.F.,,,,.T.,.F.)
oFont08N := TFont():New("Times New Roman",08,08,,.T.,,,,.T.,.F.)
oFont10  := TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
oFont11  := TFont():New("Times New Roman",11,11,,.F.,,,,.T.,.F.)
oFont14  := TFont():New("Times New Roman",14,14,,.F.,,,,.T.,.F.)
oFont16  := TFont():New("Times New Roman",16,16,,.F.,,,,.T.,.F.)
oFont10N := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
oFont12  := TFont():New("Times New Roman",10,10,,.F.,,,,.T.,.F.)
oFont12N := TFont():New("Times New Roman",10,10,,.T.,,,,.T.,.F.)
oFont16N := TFont():New("Times New Roman",16,16,,.T.,,,,.T.,.F.)
oFont14N := TFont():New("Times New Roman",14,14,,.T.,,,,.T.,.F.)
oFont06  := TFont():New("Times New Roman",06,06,,.F.,,,,.T.,.F.)
oFont06N := TFont():New("Times New Roman",06,06,,.T.,,,,.T.,.F.)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Tela de Entrada de Dados - Parametros                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nLastKey  := IIf(LastKey() == 27,27,nLastKey)

If nLastKey == 27
	Return
Endif

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Inicio do lay-out / impressao                                ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

oPrn := TMSPrinter():New(cTitulo)
oPrn:Setup()
oPrn:SetPortrait()//SetPortrait() //SetLansCape()
oPrn:StartPage()
Imprimir()
oPrn:EndPage()
oPrn:End()
oPrn:Print()

/*
DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL
@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

@ 015,017 SAY "Esta rotina tem por objetivo imprimir"   OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 030,017 SAY "o impresso customizado:"                 OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE
@ 045,017 SAY "Notas de d้bito"                         OF oDlg PIXEL Size 150,010 FONT oFont6 COLOR CLR_HBLUE

@ 06,167 BUTTON "&Imprime" 		SIZE 036,012 ACTION oPrn:Print()   	OF oDlg PIXEL
@ 28,167 BUTTON "Pre&view" 		SIZE 036,012 ACTION oPrn:Preview() 	OF oDlg PIXEL
@ 49,167 BUTTON "Sai&r"    		SIZE 036,012 ACTION oDlg:End()     	OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
*/
oPrn:End()

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณImprimir  บAutor  ณ Roberto Rosin       บ Data ณ 16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta e imprime o relat๓rio                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION Imprimir()

Orcamento()
Ms_Flush()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออ`ออออออออหออออออัออออออออออออปฑฑ
ฑฑบPrograma  ณOrcamento บAutor  ณ Roberto Rosin       บ Data ณ 16/01/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o relat๓rio                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
STATIC FUNCTION Orcamento()
local nPedido := 0
Local cCliFor := "" //Variavel para tratar na impressใo caso seja cliente ou fornecedor 

/*cDia := SubStr(DtoS(dDataBase),7,2)
cMes := SubStr(DtoS(dDataBase),5,2)
cAno := SubStr(DtoS(dDataBase),1,4)
cMesExt := MesExtenso(Month(dDataBase))
cDataImpressao := cDia+" de "+cMesExt+" de "+cAno

cPercICMS := GetMv("MV_ESTICM")*/ 

cCep := SUBSTR(ALLTRIM(SM0->M0_CEPCOB),1,5) + "-" + SUBSTR(ALLTRIM(SM0->M0_CEPCOB),6,9)

dbSelectArea("SF2")
SF2->(dbSetOrder(1))
SF2->(dbGoTop())
SF2->(dbSeek(xFilial("SF2")+MV_PAR01+MV_PAR03))

while(!SF2->(EOF()) .and. SF2->F2_DOC <= MV_PAR02)

	if SF2->F2_SERIE = MV_PAR03
		dbSelectArea("SD2")
		SD2->(dbSetOrder(3))
		SD2->(dbGoTop())
		SD2->(dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
		
		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		SF4->(dbGoTop())
		SF4->(dbSeek(xFilial("SF4")+SD2->D2_TES))
		
		dbSelectArea("SA1")
		SA1->(dbSetOrder(1))
		SA1->(dbGoTop())
		SA1->(dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)) 
		
		dbSelectArea("SA2")
		SA2->(dbSetOrder(1))
		SA2->(dbGoTop())
		SA2->(dbSeek(xFilial("SA2")+SF2->F2_CLIENTE+SF2->F2_LOJA))
		
		dbSelectArea("SE1")
		SE1->(dbSetOrder(2))
		SE1->(dbGoTop())
		SE1->(dbSeek(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
		
		oPrn:StartPage()
		oPrn:box(nL+0079,0079,nL+0620,1740) //Identifica็ใo do Emitente
		oPrn:box(nL+0079,1740,nL+0620,2473) //N๚mero do documento
		oPrn:box(nL+0630,0079,nL+0720,2473) //Natureza da Opera็ใo
		oPrn:box(nL+0730,0079,nL+0820,0825) //Inscri็ใo Estadual
		oPrn:box(nL+0730,0825,nL+0820,1649) //INSC.ESTADUAL DO SUBST.TRIB.
		oPrn:box(nL+0730,1649,nL+0820,2473) //CNPJ
		
		oPrn:box(nL+0870,0079,nL+0960,1113) //NOME/RAZรO SOCIAL
		oPrn:box(nL+0870,1113,nL+0960,2039) //CNPJ/CPF
		oPrn:box(nL+0870,2045,nL+0960,2473) //DATA DE EMISSรO
		
		oPrn:box(nL+0960,0079,nL+1050,0944) //ENDEREวO
		oPrn:box(nL+0960,0944,nL+1050,1555) //BAIRRO/DISTRITO
		oPrn:box(nL+0960,1555,nL+1050,2039) //CEP
		oPrn:box(nL+0960,2045,nL+1050,2473) //DATA ENTRADA/SAIDA
		
		oPrn:box(nL+1050,0079,nL+1140,0608) //MUNICอPIO
		oPrn:box(nL+1050,0608,nL+1140,1030) //FONE/FAX
		oPrn:box(nL+1050,1030,nL+1140,1377) //UF
		oPrn:box(nL+1050,1377,nL+1140,2039) //INSCRIวรO ESTADUAL
		oPrn:box(nL+1050,2045,nL+1140,2473) //HORA ENTRADA/SAIDA
		
		oPrn:box(nL+1180,0079,nL+1370,0345) //FATURA
		oPrn:box(nL+1180,0345,nL+1370,0611) //FATURA
		oPrn:box(nL+1180,0611,nL+1370,0877) //FATURA
		oPrn:box(nL+1180,0877,nL+1370,1143) //FATURA
		oPrn:box(nL+1180,1143,nL+1370,1409) //FATURA
		oPrn:box(nL+1180,1409,nL+1370,1675) //FATURA
		oPrn:box(nL+1180,1675,nL+1370,1941) //FATURA
		oPrn:box(nL+1180,1941,nL+1370,2207) //FATURA
		oPrn:box(nL+1180,2207,nL+1370,2473) //FATURA
		
		oPrn:box(nL+1410,0079,nL+1500,0560) //BASE DE CALCULO DO ICMS
		oPrn:box(nL+1410,0560,nL+1500,0866) //VALOR DO ICMS
		oPrn:box(nL+1410,0866,nL+1500,1511) //BASE DE CALCULO DO ICMS SUBSTITUIวรO
		oPrn:box(nL+1410,1511,nL+1500,2029) //VALOR DO ICMS SUBSTITUIวรO
		oPrn:box(nL+1410,2029,nL+1500,2473) //VALOR TOTAL DOS PRODUTOS
		
		oPrn:box(nL+1500,0079,nL+1590,0476) //VALOR DO FRETE
		oPrn:box(nL+1500,0476,nL+1590,0835) //VALOR DO SEGURO
		oPrn:box(nL+1500,0835,nL+1590,1236) //DESCONTO
		oPrn:box(nL+1500,1236,nL+1590,1733) //OUTRAS DESPESAS ACESSำRIAS
		oPrn:box(nL+1500,1733,nL+1590,2071) //VALOR DO IPI
		oPrn:box(nL+1500,2071,nL+1590,2473) //VALOR TOTAL DA NOTA
		
		oPrn:box(nL+1630,0073,nL+2490,0274) //COD. PROD
		oPrn:box(nL+1630,0274,nL+2490,0899) //DESCRIวรO DO PROD./SERV.
		oPrn:box(nL+1630,0899,nL+2490,1035) //NCM/SH
		oPrn:box(nL+1630,1035,nL+2490,1109) //CST
		oPrn:box(nL+1630,1109,nL+2490,1205) //CFOP
		oPrn:box(nL+1630,1205,nL+2490,1257) //UN
		oPrn:box(nL+1630,1257,nL+2490,1511) //QUANT.
		oPrn:box(nL+1630,1511,nL+2490,1722) //V.UNITARIO
		oPrn:box(nL+1630,1722,nL+2490,1870) //V.TOTAL
		oPrn:box(nL+1630,1870,nL+2490,2014) //BC.ICMS
		oPrn:box(nL+1630,2014,nL+2490,2134) //V.ICMS
		oPrn:box(nL+1630,2134,nL+2490,2240) //V.IPI
		oPrn:box(nL+1630,2240,nL+2490,2367) //A.ICMS
		oPrn:box(nL+1630,2367,nL+2490,2473) //A.IPI
		
		oPrn:box(nL+2530,0073,nL+2620,0618) //INSCRIวรO MUNICIPAL
		oPrn:box(nL+2530,0618,nL+2620,1236) //VALOR TOTAL DOS SERVIวOS
		oPrn:box(nL+2530,1236,nL+2620,1855) //BASE DE CมLCULO DO ISSQN
		oPrn:box(nL+2530,1855,nL+2620,2473) //VALOR DO ISSQN
		
		oPrn:box(nL+2660,0073,nL+3230,1395) //INFORMAวีES COMPLEMENTARES
		oPrn:box(nL+2660,1395,nL+3230,2473) //RESERVADO AO FISCO
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณIdentifica็ใo do Emitente e do documentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cBitMap := "logo" + cEmpAnt + ".bmp"
		oPrn:SayBitmap(nL+0160,0130,cBitMap,nL+0350,0200)
		
		oPrn:Say(nL+0150,0500,"Identifica็ใo do Emitente"                              ,oFont12N)
		oPrn:Say(nL+0180,0500,ALLTRIM(SM0->M0_NOMECOM)                                 ,oFont14N)
		oPrn:Say(nL+0240,0500,ALLTRIM(SM0->M0_ENDCOB)                                  ,oFont08 )
		oPrn:Say(nL+0280,0500,"Complemento: " + ALLTRIM(SM0->M0_COMPCOB)               ,oFont08 )
		oPrn:Say(nL+0320,0500,ALLTRIM(SM0->M0_BAIRCOB) + " " + cCep                    ,oFont08 )
		oPrn:Say(nL+0360,0500,ALLTRIM(SM0->M0_CIDCOB)  + "/" + ALLTRIM(SM0->M0_ESTCOB) ,oFont08 )
		
		oPrn:Say(nL+0240,1800,"NOTA DE DษBITO"                                         ,oFont12N)
		//oPrn:Say(nL+0240,1800,"Documento para transfer๊ncia"                           ,oFont12N)
		//oPrn:Say(nL+0290,1800,"de d้bito entre filiais."                               ,oFont12N)
		oPrn:Say(nL+0350,1800,"Nบ " + SF2->F2_DOC                                      ,oFont12N)
		oPrn:Say(nL+0380,1800,"S้rie " + SF2->F2_SERIE                                 ,oFont12N)
		oPrn:Say(nL+0410,1800,"Folha 01/01"                                            ,oFont12N)
		
		oPrn:Say(nL+0640,0100,"NATUREZA DA OPERAวรO"                                   ,oFont08N)
		oPrn:Say(nL+0670,0100,SF4->F4_TEXTO                                            ,oFont08 )
		
		oPrn:Say(nL+0740,0100,"INSCRIวรO ESTADUAL"                                     ,oFont08N)
		oPrn:Say(nL+0770,0100,SM0->M0_INSC                                             ,oFont08 )
		
		oPrn:Say(nL+0740,0835,"INSC.ESTADUAL DO SUBST.TRIB."                           ,oFont08N)
		//oPrn:Say(nL+0770,0835,supergetmv("MV_SUBTRIB")                                 ,oFont08 )
		
		cCnpj := substr(SM0->M0_CGC,01,2)+"."+;
		         substr(SM0->M0_CGC,03,3)+"."+;
		         substr(SM0->M0_CGC,06,3)+"/"+;
		         substr(SM0->M0_CGC,09,4)+"-"+;
		         substr(SM0->M0_CGC,13,2)
		oPrn:Say(nL+0740,1659,"CNPJ"                                                   ,oFont08N)
		oPrn:Say(nL+0770,1659,cCnpj                                                    ,oFont08 )
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณDESTINATมRIO/REMETENTEณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ       
		
		//Gustavo 26/06/2014
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณVerifica se ้ nota de devolu็ใo, se for deverแ utilizar as informa็๕es de fornecedorณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		
		If SF2->F2_TIPO == "D"
			cCliFor := "SA2->A2_"
		Else
			cCliFor := "SA1->A1_"
		EndIf
		//Fim Gustavo 26/06/2014
		
		cData := DToS(SF2->F2_EMISSAO)
		cEmissao := substr(cData, 7,2)+'/'+substr(cData, 5,2)+'/'+substr(cData, 1,4)
		
		oPrn:Say(nL+0840,0100,"DESTINATมRIO/REMETENTE"                                 		,oFont08N)
		
		oPrn:Say(nL+0880,0100,"NOME/RAZรO SOCIAL"                                      		,oFont08N)
		oPrn:Say(nL+0910,0100,&(cCliFor+"NOME")                                       		,oFont08 )
		
		oPrn:Say(nL+0880,1123,"CPF/CNPJ"                                               		,oFont08N)
		oPrn:Say(nL+0910,1123,transform(&(cCliFor+"CGC"), pesqPict("SA1","A1_CGC"))         ,oFont08 )
		
		oPrn:Say(nL+0880,2055,"DATA DE EMISSรO"                                        		,oFont08N)
		oPrn:Say(nL+0910,2055,cEmissao                                                 		,oFont08 )
		
		oPrn:Say(nL+0970,0100,"ENDEREวO"                                               		,oFont08N)
		oPrn:Say(nL+1000,0100,&(cCliFor+"END")                                              ,oFont08 )
		
		oPrn:Say(nL+0970,0954,"BAIRRO/DISTRITO"                                       		,oFont08N)
		oPrn:Say(nL+1000,0954,&(cCliFor+"BAIRRO")                                           ,oFont08 )
		
		oPrn:Say(nL+0970,1565,"CEP"                                                    		,oFont08N)
		oPrn:Say(nL+1000,1565,transform(&(cCliFor+"CEP"), pesqPict("SA1","A1_CEP"))         ,oFont08 )
		
		oPrn:Say(nL+0970,2055,"DATA ENTRADA/SAอDA"                                     		,oFont08N)
		oPrn:Say(nL+1000,2055,cEmissao                                                 		,oFont08 )
		
		oPrn:Say(nL+1060,0100,"MUNICอPIO"                                              		,oFont08N)
		oPrn:Say(nL+1090,0100,&(cCliFor+"MUN")                                              ,oFont08 )
		
		oPrn:Say(nL+1060,0618,"FONE/FAX"                                               		,oFont08N)
		oPrn:Say(nL+1090,0618,transform(&(cCliFor+"TEL"), pesqPict("SA1","A1_TEL"))         ,oFont08 )
		
		oPrn:Say(nL+1060,1040,"UF"                                                     		,oFont08N)
		oPrn:Say(nL+1090,1040,&(cCliFor+"EST")                                              ,oFont08 )
		
		oPrn:Say(nL+1060,1387,"INSCRIวรO ESTADUAL"                                     		,oFont08N)
		oPrn:Say(nL+1090,1387,&(cCliFor+"INSCR")                                            ,oFont08 )
		
		oPrn:Say(nL+1060,2055,"HORA ENTRADA/SAอDA"                                     		,oFont08N)
		oPrn:Say(nL+1090,2055,SF2->F2_HORA                                             		,oFont08 )	
		
		//ฺฤฤฤฤฤฤฤ
		//ณFATURAณ
		//ภฤฤฤฤฤฤฤ
		oPrn:Say(nL+1150,0100,"FATURA"                                                 		,oFont08N)
		
		nColuna := 100
		while (!SE1->(eof()) .and. SE1->E1_FILIAL  = SF2->F2_FILIAL;
		                     .and. SE1->E1_CLIENTE = SF2->F2_CLIENTE;
		                     .and. SE1->E1_LOJA    = SF2->F2_LOJA;
		                     .and. SE1->E1_PREFIXO = SF2->F2_SERIE;
		                     .and. SE1->E1_NUM     = SF2->F2_DOC)
			
			oPrn:Say(nL+1210,nColuna,SE1->E1_PREFIXO + " " +SE1->E1_NUM                             ,oFont08 )
			oPrn:Say(nL+1250,nColuna,DToC(SE1->E1_VENCTO)                                           ,oFont08 )
			oPrn:Say(nL+1290,nColuna,ALLTRIM(transform(SE1->E1_VALOR, pesqpict("SE1", "E1_VALOR"))) ,oFont08 )
			
			nColuna += 266
			SE1->(dbSkip())
		endDo
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณCALCULO DO IMPOSTOณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		oPrn:Say(nL+1380,0100,"CALCULO DO IMPOSTO"                                     ,oFont08N)
		
		oPrn:Say(nL+1420,0100,"BASE DE CALCULO DO ICMS"                                ,oFont08N)
		//oPrn:Say(nL+1450,0100,transform(SF2->F2_BASEICM, pesqPict("SF2","F2_BASEICM")) ,oFont08 )
		
		oPrn:Say(nL+1420,0570,"VALOR DO ICMS"                                          ,oFont08N)
		//oPrn:Say(nL+1450,0570,transform(SF2->F2_VALICM, pesqPict("SF2","F2_VALICM"))   ,oFont08 )
		
		oPrn:Say(nL+1420,0876,"BASE DE CALCULO DO ICMS SUBSTITUIวรO"                   ,oFont08N)
		//oPrn:Say(nL+1450,0876,DToS(SF2->F2_EMISSAO)                                    ,oFont08 )
		
		oPrn:Say(nL+1420,1521,"VALOR DO ICMS SUBSTITUIวรO"                             ,oFont08N)
		//oPrn:Say(nL+1450,1521,transform(SF2->F2_ICMSRET, pesqPict("SF2","F2_ICMSRET")) ,oFont08 )
		
		oPrn:Say(nL+1420,2039,"VALOR TOTAL DOS PRODUTOS"                               ,oFont08N)
		//oPrn:Say(nL+1450,2039,DToS(SF2->F2_EMISSAO)                                    ,oFont08 )
		
		oPrn:Say(nL+1510,0100,"VALOR DO FRETE"                                         ,oFont08N)
		oPrn:Say(nL+1540,0100,""                                                       ,oFont08 )
		
		oPrn:Say(nL+1510,0486,"VALOR DO SEGURO"                                        ,oFont08N)
		oPrn:Say(nL+1540,0486,""                                                       ,oFont08 )
		
		cDesconto := ""
		if SF2->F2_DESCONT > 0
			cDesconto := transform(SF2->F2_DESCONT,pesqpict("SF2","F2_DESCONT"))
		endIf
		
		oPrn:Say(nL+1510,0845,"DESCONTO"                                               ,oFont08N)
		oPrn:Say(nL+1540,0845,cDesconto                                                ,oFont08 )
		
		oPrn:Say(nL+1510,1246,"OUTRAS DESPESAS ACESSำRIAS"                             ,oFont08N)
		oPrn:Say(nL+1540,1246,""                                                       ,oFont08 )
		
		oPrn:Say(nL+1510,1743,"VALOR DO IPI"                                           ,oFont08N)
		//oPrn:Say(nL+1540,1743,transform(SF2->F2_VALIPI,pesqpict("SF2","F2_VALIPI"))    ,oFont08 )
		
		oPrn:Say(nL+1510,2081,"VALOR TOTAL DA NOTA"                                    ,oFont08N)
		
		oPrn:Say(nL+1600,0100,"DADOS DO PRODUTO/SERVIวO"                               ,oFont08N)
		
		oPrn:Say(nL+1640,0100,"COD. PROD"                                              ,oFont08N)
		oPrn:Say(nL+1640,0284,"DESCRIวรO DO PROD./SERV."                               ,oFont08N)
		oPrn:Say(nL+1640,0909,"NCM/SH"                                                 ,oFont08N)
		oPrn:Say(nL+1640,1045,"CST"                                                    ,oFont08N)
		oPrn:Say(nL+1640,1119,"CFOP"                                                   ,oFont08N)
		oPrn:Say(nL+1640,1210,"UN"                                                     ,oFont08N)
		oPrn:Say(nL+1640,1267,"QUANT."                                                 ,oFont08N)
		oPrn:Say(nL+1640,1521,"V.UNITARIO"                                             ,oFont08N)
		oPrn:Say(nL+1640,1732,"V. TOTAL"                                               ,oFont08N)
		oPrn:Say(nL+1640,1880,"BC.ICMS"                                                ,oFont08N)
		oPrn:Say(nL+1640,2024,"V.ICMS"                                                 ,oFont08N)
		oPrn:Say(nL+1640,2144,"V.IPI"                                                  ,oFont08N)
		oPrn:Say(nL+1640,2250,"A.ICMS"                                                 ,oFont08N)
		oPrn:Say(nL+1640,2377,"A.IPI"                                                  ,oFont08N)
		
		nLinha := 1670
		nValorTotal := 0
		while(!SD2->(EOF()) .and. SD2->D2_FILIAL  == SF2->F2_FILIAL ;
		                    .and. SD2->D2_DOC     == SF2->F2_DOC    ;
		                    .and. SD2->D2_SERIE   == SF2->F2_SERIE  ;
		                    .and. SD2->D2_CLIENTE == SF2->F2_CLIENTE;
		                    .and. SD2->D2_LOJA    == SF2->F2_LOJA   )
		                    
			oPrn:Say(nL+nLinha,0100,transform(SD2->D2_COD    , pesqPict("SD2","D2_COD"))       ,oFont07 )
			oPrn:Say(nL+nLinha,0284,posicione("SB1",1,xFilial("SB1")+SD2->D2_COD, "B1_DESC")   ,oFont07 )
			oPrn:Say(nL+nLinha,0909,posicione("SB1",1,xFilial("SB1")+SD2->D2_COD, "B1_POSIPI") ,oFont07 )
			oPrn:Say(nL+nLinha,0909,posicione("SB1",1,xFilial("SB1")+SD2->D2_COD, "B1_POSIPI") ,oFont07 )
			oPrn:Say(nL+nLinha,1045,SD2->D2_CLASFIS                                            ,oFont07 )
			oPrn:Say(nL+nLinha,1119,SD2->D2_CF                                                 ,oFont07 )
			oPrn:Say(nL+nLinha,1210,SD2->D2_UM                                                 ,oFont07 )
			oPrn:Say(nL+nLinha,1267,transform(SD2->D2_QUANT  , pesqPict("SD2","D2_QUANT"))     ,oFont07 )
			oPrn:Say(nL+nLinha,1521,transform(SD2->D2_PRCVEN , pesqPict("SD2","D2_PRCVEN"))    ,oFont07 )
			oPrn:Say(nL+nLinha,1732,transform(SD2->D2_TOTAL  , pesqPict("SD2","D2_TOTAL"))     ,oFont07 )
			oPrn:Say(nL+nLinha,1880,transform(SD2->D2_BASEICM, pesqPict("SD2","D2_BASEICM"))   ,oFont07 )
			oPrn:Say(nL+nLinha,2024,transform(SD2->D2_VALICM , pesqPict("SD2","D2_VALICM"))    ,oFont07 )
			oPrn:Say(nL+nLinha,2134,transform(SD2->D2_VALIPI , pesqPict("SD2","D2_VALIPI"))    ,oFont07 )
			oPrn:Say(nL+nLinha,2290,transform(SD2->D2_PICM   , pesqPict("SD2","D2_PICM"))      ,oFont07 )
			oPrn:Say(nL+nLinha,2410,transform(SD2->D2_IPI    , pesqPict("SD2","D2_IPI"))       ,oFont07 )
			
			nValorTotal += SD2->D2_TOTAL
			nPedido := SD2->D2_PEDIDO
			nLinha += 30
			
			SD2->(dbSkip())               
		endDo
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณValores totaisณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		oPrn:Say(nL+1450,2039,transform(nValorTotal, pesqPict("SD2","D2_TOTAL"))       ,oFont08 )//valor total dos produtos
		oPrn:Say(nL+1540,2081,transform(nValorTotal, pesqPict("SD2","D2_TOTAL"))       ,oFont08 )//valor total da nota
		
		oPrn:Say(nL+2500,0100,"CALCULO DO ISSQN"                                       ,oFont08N)
		
		oPrn:Say(nL+2540,0100,"INSCRIวรO MUNICIPAL"                                    ,oFont08N)
		oPrn:Say(nL+2570,0100,""                                                       ,oFont08 )
		
		oPrn:Say(nL+2540,0628,"VALOR TOTAL DOS SERVIวOS"                               ,oFont08N)
		oPrn:Say(nL+2570,0628,""                                                       ,oFont08 )
		
		oPrn:Say(nL+2540,1246,"BASE DE CALCULO DO ISSQN"                               ,oFont08N)
		oPrn:Say(nL+2570,1246,""                                                       ,oFont08 )
		
		oPrn:Say(nL+2540,1865,"VALOR DO ISSQN"                                         ,oFont08N)
		oPrn:Say(nL+2570,1865,""                                                       ,oFont08 )
	
		oPrn:Say(nL+2630,0100,"DADOS ADICIONAIS"                                       ,oFont08N)
		
		oPrn:Say(nL+2670,0100,"INFORMAวีES COMPLEMENTARES"                             ,oFont08N)
		oPrn:Say(nL+2700,0100,"DOCUMENTO SEM VALOR FISCAL"                             ,oFont08N)
		oPrn:Say(nL+2730,0100,"Pedido Nบ " + posicione("SC5",1,xFilial("SC5")+nPedido,"C5_NUM") ,oFont08N)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณObserva็ใo do pedido ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		cObs := posicione("SC5",1,xFilial("SC5")+nPedido,"C5_OBSPED ")
		cDadosAdicionais := ""
		cEol := Chr(13)+Chr(10)
		cDados := ""
		nCaracteres := len(allTrim(cObs))
		nPos := 0
		nLinha := 2760
		nUltQueb := 1
		aDadosAdicionais := {}
		aObs := {}
		
		for nI := 1 to len(cObs)
			if subStr(cObs,nI,2) == cEol .or. nI == len(cObs)
				aAdd(aObs, subStr(cObs, nUltQueb, nI - iif(nI == len(cObs), nUltQueb - 1, nUltQueb)))
				nUltQueb := nI + 2
			endIf
		next nI
		
		
		for nI := 1 to len(aObs)
			while nPos < nCaracteres
				nCaracteres := len(aObs[nI])
				cDados := substr(aObs[nI],nPos + 1,iIf(nCaracteres - nPos > 100, 100, nCaracteres - nPos + 1))
				aAdd(aDadosAdicionais, cDados)
				nPos += 100//iif(nPos == 1, 101, 100)
			endDo
			nPos := 0
		next nI
		
		for nI := 1 to len(aDadosAdicionais)
			oPrn:Say(nL+nLinha,0100,aDadosAdicionais[nI]                                         ,oFont08N)
			nLinha += 30
		next nI
		//oPrn:Say(nL+2760,0100,cDadosAdicionais                                         ,oFont08N)
		
		oPrn:Say(nL+2670,1405,"RESERVADO"                                              ,oFont08N)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณQuebra de pแginaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		oPrn:EndPage()
	
	endIf
	
	SF2->(dbSkip())
endDo

return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1 บAutor  ณRoberto Rosin       บ Data ณ  31/10/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cria็ใo de grupo de perguntas no SX1            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecํfico Cantu                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AJUSTASX1(cPerg)

aRegs   := {}
aHelp1  := {}
aHelp2  := {}
aHelp3  := {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
AADD(aRegs, {cPerg,"01","Nota Fiscal De?   ","Nota Fiscal De?   ","Nota Fiscal De?   ","mv_ch1" ,"C",TAMSX3("F2_DOC")[1]   ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","", PesqPict("SF2", "F2_DOC"  )})
AADD(aRegs, {cPerg,"02","Nota Fiscal At้?  ","Nota Fiscal At้?  ","Nota Fiscal At้?  ","mv_ch2" ,"C",TAMSX3("F2_DOC")[1]   ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SF2","","","", PesqPict("SF2", "F2_DOC"  )})
AADD(aRegs, {cPerg,"03","Serie ?           ","Serie ?           ","Serie ?           ","mv_ch2" ,"C",TAMSX3("F2_SERIE")[1] ,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","   ","","","", PesqPict("SF2", "F2_SERIE")})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณMontagem do Help de cada item do Grupo de Perguntasณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
AADD(aHelp1 , "Informe o numero do documento de saida     ")
AADD(aHelp2 , "Informe o numero do documento de saida     ")
AADD(aHelp3 , "Informe a serie do documento de saida      ")
 
        
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณRealiza a grava็ใo dos itens do grupo de perguntas no SX1ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
dbSelectArea("SX1")
dbSetOrder(1)
dbGoTop()
For i := 1 To Len(aRegs)
	If !dbSeek(padR(cPerg,10) + aRegs[i,2])
		RECLOCK("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])
				Endif
			Next
		SX1->(MSUNLOCK())
	Endif
Next  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAtualiza o Help dos parametros no arquivo de Help   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
PutSX1Help("P." + cPerg + "01.", aHelp1 , aHelp1 , aHelp1 )
PutSX1Help("P." + cPerg + "02.", aHelp2 , aHelp2 , aHelp2 )
PutSX1Help("P." + cPerg + "03.", aHelp3 , aHelp3 , aHelp3 )

Return