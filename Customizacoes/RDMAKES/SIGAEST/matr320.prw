#INCLUDE "UMATR320.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR320  ³ Autor ³ Nereu Humberto Junior ³ Data ³ 30/06/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Resumo das entradas e saidas                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function MATR320()
Local oReport    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


/*
FILIAL (Visão Contábil) / MÊS 02/2011 (R$)
 
(=) ESTOQUE INICIO MÊS

(+) TOTAL ENTRADAS POR COMPRA MÊS
 
(+) TOTAL ENTRADAS POR TRANSFERENCIA MÊS (entre filiais)

(+/-) AJUSTES POR INVENTÁRIO E/OU MOVIMENTAÇÕES INTERNAS

(-) TOTAL BAIXA POR CUSTO MERCADORIAS VENDIDAS MÊS
 
(-) TOTAL SAIDAS POR TRASNFERENCIA FILIAL MÊS
 
(=) SALDO ESTOQUE FINAL MÊS

*/


MATR320R3()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MATR320R3 ³ Autor ³ Eveli Morasco         ³ Data ³ 31/03/93 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Resumo das entradas e saidas (Antigo)                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Marcelo Pim.³18/12/97³13695A³Ajuste no saldo final de acordo c/a moeda.³±±
±±³Rodrigo Sar.³01/04/98³13615A³Inclusao da Perg. mv_par10                ³±±
±±³Rodrigo Sar.³22/07/98³15188A³Inclusao de tratamento poder terceiros    ³±±
±±³Edson   M.  ³17/11/98³xxxxxx³Substituicao do Gotop por Seeek no SB1.   ³±±
±±³Patricia Sal³04/01/00³xxxxxx³Inclusao Perg. Almoxarifado Ate.          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                      
//Adriano
Static Function MATR320R3
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL Tamanho  := "G"
LOCAL titulo   := STR0001	//"Resumo das Entradas e Saidas"
LOCAL cDesc1   := STR0002	//"Este programa mostra um resumo ,por tipo de material ,de todas  as  suas"
LOCAL cDesc2   := STR0003	//"entradas e saidas. A coluna SALDO INICIAL  e' o  resultado da  soma  das"
LOCAL cDesc3   := STR0004	//"outras colunas do relatorio e nao o saldo inicial cadastrado no estoque."
LOCAL cString  := "SB1"
LOCAL wnrel    := "MATR320"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis tipo Private padrao de todos os relatorios         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE aReturn:= { OemToAnsi(STR0005), 1,OemToAnsi(STR0006), 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nLastKey := 0 ,cPerg := "MTR320"
Private _cFil	:= "" // Adriano
_cFil	:= VerEmp()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao utilizada para verificar a ultima versao do fonte        ³
//³ SIGACUSA.PRX aplicados no rpo do cliente, assim verificando     |
//| a necessidade de uma atualizacao nestes fontes. NAO REMOVER !!!	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
IF !(FindFunction("SIGACUSA_V") .and. SIGACUSA_V() >= 20060321)
    Final("Atualizar SIGACUSA.PRX !!!")
Endif

AjustaSX1() //-- Inclui a 12a pergunta

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01     // Almoxarifado De                              ³
//³ mv_par02     // Almoxarifado Ate                             ³
//³ mv_par03     // Tipo inicial                                 ³
//³ mv_par04     // Tipo final                                   ³
//³ mv_par05     // Produto inicial                              ³
//³ mv_par06     // Produto Final                                ³
//³ mv_par07     // Emissao de                                   ³
//³ mv_par08     // Emissao ate                                  ³
//³ mv_par09     // moeda selecionada ( 1 a 5 )                  ³
//³ mv_par10     // Saldo a considerar : Atual / Fechamento      ³
//³ mv_par11     // Considera Saldo MOD: Sim / Nao               ³
//³ mv_par12     // Imprime OPs geradas pelo SIGAMNT? Sim / Nao  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C320Imp(@lEnd,wnRel,cString,tamanho,titulo)},titulo)

Return NIL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C320IMP  ³ Autor ³ Rodrigo de A. Sartorio³ Data ³ 12.12.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR320  		                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function C320Imp(lEnd,WnRel,cString,tamanho,titulo)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis locais exclusivas deste programa                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL cRodaTxt := ""
LOCAL nCntImpr := 0
LOCAL lContinua := .T. ,cMoeda ,lPassou:=.F.,lTotal:=.F.,cCampo
LOCAL nTotComp,nTotCons,nTotProc,nTotTrans,nTotProd,nTotEnTerc,nTotSaTerc
LOCAL nTotVend,nTotSaldo,nTotSant,nTotOutr,nTotDevVen,nTotDevCom,_nETotFil,_nSTotFil
LOCAL cTipAnt
LOCAL nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc,_nETrfFil,_nSTrfFil
LOCAL nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
LOCAL nValor := 0
LOCAL cAliasTop:= CriaTrab(,.F.)
LOCAL cQuery   := ""
LOCAL cQueryD1 := ""
LOCAL cQueryD2 := ""
LOCAL cQueryD3 := ""
LOCAL cQueryB1A:= ""
LOCAL cQueryB1C:= ""
LOCAL cQueryB1 := ""
LOCAL cProduto := ""
LOCAL lQuery   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contadores de linha e pagina                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE li := 80 ,m_pag := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa os codigos de caracter Comprimido/Normal da impressora ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nTipo  := IIF(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona o simbolo da moeda escolhida ao titulo            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cMoeda := LTrim(Str(mv_par09))
cMoeda := IIF(cMoeda=="0","1",cMoeda)
If Type("NewHead")#"U"
	NewHead += STR0007+AllTrim(GetMv("MV_SIMB"+cMoeda))+" - "+STR0035+dtoc(mv_par07,"ddmmyy")+STR0036+dtoc(mv_par08,"ddmmyy")			//" EM "
Else
	Titulo  += STR0007+AllTrim(GetMv("MV_SIMB"+cMoeda))+" - "+STR0035+dtoc(mv_par07,"ddmmyy")+STR0036+dtoc(mv_par08,"ddmmyy")		   //" EM "
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta os Cabecalhos                                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Cabec1 := STR0008		//"TIPO            SALDO          COMPRAS    MOVIMENTACOES      REQUISICOES   TRANSFERENCIAS         PRODUCAO           VENDAS       TRANSF. P/     DEVOLUCAO DE     DEVOLUCAO DE  ENTRADA PODER  SAIDA PODER        SALDO"
Cabec2 := STR0009 +Iif(mv_par10 == 1,STR0010,Iif(mv_par10 == 2,STR0011,STR0012))    //"              INICIAL                          INTERNAS    PARA PRODUCAO                                                           PROCESSO            VENDAS          COMPRAS    TERCEIROS      TERCEIROS"###"        ATUAL"###"DO FECHAMENTO"###" DO MOVIMENTO"

******************      12   9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 9,999,999,999.99 999,999,999.99 999,999,999.99 9,999,999,999.99
******************      0         1         2         3         4         5         6         7         8         9        10        11        12        13        14        15        16        17        18        19        20        21        22
******************      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
// Posicoes (000,005,022,039,056,073,089,106,123,140,157,174,189,204)

#IFDEF TOP
	If !(TcSrvType()=="AS/400") .And. !("POSTGRES" $ TCGetDB())
		// **** ATENCAO - O ORDER BY UTILIZA AS POSICOES DO SELECT, SE ALGUM CAMPO
		// **** FOR INCLUIDO NA QUERY OU ALTERADO DE LUGAR DEVE SER REVISTA A SINTAXE
		// **** DO ORDER BY
		// 1 ARQ
		// 2 PRODUTO
		// 3 TIPO
		// 4 UM
		// 5 GRUPO
		// 6 DESC
		// 7 DATA
		// 8 TES
		// 9 CF
		// 10 SEQUENCIA
		// 11 DOCUMENTO
		// 12 SERIE
		// 13 QUANTIDADE
		// 14 QUANT2UM
		// 15 ARMAZEM
		// 17 OP
		// 19 FORNECEDOR
		// 20 LOJA
		// 22 TIPO NF
		// 23 CUSTO
		// 24 RECNO
	    
	    lQuery := .T.
		cQueryD1:= "SELECT 'SD1' ARQ,SB1.B1_COD PRODUTO,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D1_DTDIGIT DATA,D1_TES TES,D1_CF CF,D1_NUMSEQ SEQUENCIA,D1_DOC DOCUMENTO,D1_SERIE SERIE,D1_QUANT QUANTIDADE,D1_QTSEGUM QUANT2UM,D1_LOCAL ARMAZEM,'' OP,D1_FORNECE FORNECEDOR,D1_LOJA LOJA,D1_TIPO TIPONF,D1_CUSTO"
		// COLOCA A MOEDA DO CUSTO
		If mv_par09 > 1
			cQueryD1+= Str(mv_par09,1,0)
        EndIf
		cQueryD1 += " CUSTO,SD1.R_E_C_N_O_ NRECNO FROM " 	
		cQueryD1 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD1")+ " SD1 , "+ RetSqlName("SF4")+" SF4 "
		cQueryD1 += " WHERE SB1.B1_COD = D1_COD AND D1_FILIAL = '"+xFilial("SD1")+"'"
		cQueryD1 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD1.D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
		cQueryD1 += " AND D1_DTDIGIT >= '"+DTOS(mv_par07)+"' AND D1_DTDIGIT <= '"+DTOS(mv_par08)+"'"
		cQueryD1 += " AND D1_ORIGLAN <> 'LF'"
		cQueryD1 += " AND D1_LOCAL >= '"+mv_par01+"'"+" AND D1_LOCAL <= '"+mv_par02+"'"
		If cPaisLoc <> "BRA"
			cQueryD1 += " AND D1_REMITO = '" + Space(TamSx3("D1_REMITO")[1]) + "' "
		EndIf	
		#IFDEF SHELL
			cQueryD1 += " AND D1_CANCEL <> 'S'"
		#ENDIF
		cQueryD1 += " AND SD1.D_E_L_E_T_<>'*' AND SF4.D_E_L_E_T_<>'*'"

		cQueryD2 := " SELECT 'SD2',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D2_EMISSAO,D2_TES,D2_CF,D2_NUMSEQ,D2_DOC,D2_SERIE,D2_QUANT,D2_QTSEGUM,D2_LOCAL,'',D2_CLIENTE,D2_LOJA,D2_TIPO,D2_CUSTO"
		cQueryD2 += Str(mv_par09,1,0)
		cQueryD2 += ",SD2.R_E_C_N_O_ SD2RECNO FROM "
		cQueryD2 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD2")+ " SD2 , "+ RetSqlName("SF4")+" SF4 "
		cQueryD2 += " WHERE SB1.B1_COD = D2_COD AND D2_FILIAL = '"+xFilial("SD2")+"'"
		cQueryD2 += " AND F4_FILIAL = '"+xFilial("SF4")+"' AND SD2.D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S'"
		cQueryD2 += " AND D2_EMISSAO >= '"+DTOS(mv_par07)+"' AND D2_EMISSAO <= '"+DTOS(mv_par08)+"'"
		cQueryD2 += " AND D2_ORIGLAN <> 'LF'"
		cQueryD2 += " AND D2_LOCAL >= '"+mv_par01+"'"+" AND D2_LOCAL <= '"+mv_par02+"'"
		If cPaisLoc <> "BRA"
			cQueryD2 += " AND D2_REMITO = '" + Space(TamSx3("D2_REMITO")[1]) + "' "
		EndIf	

		#IFDEF SHELL
			cQueryD2 += " AND D2_CANCEL <> 'S'"
		#ENDIF
		cQueryD2 += " AND SD2.D_E_L_E_T_<>'*' AND SF4.D_E_L_E_T_<>'*'"

		cQueryD3 := " SELECT 'SD3',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,D3_EMISSAO,D3_TM,D3_CF,D3_NUMSEQ,D3_DOC,'',D3_QUANT,D3_QTSEGUM,D3_LOCAL,D3_OP,'','','',D3_CUSTO"
		cQueryD3 += Str(mv_par09,1,0)
		cQueryD3 += ",SD3.R_E_C_N_O_ SD3RECNO FROM "
		cQueryD3 += RetSqlName("SB1") + " SB1 , "+ RetSqlName("SD3")+ " SD3 "
		cQueryD3 += " WHERE SB1.B1_COD = D3_COD AND D3_FILIAL = '"+xFilial("SD3")+"' AND "
		cQueryD3 += " D3_EMISSAO >= '"+DTOS(mv_par07)+"' AND D3_EMISSAO <= '"+DTOS(mv_par08)+"'"

		If SuperGetMV('MV_D3ESTOR', .F., 'N') == 'N'
			cQueryD3 += " AND D3_ESTORNO <> 'S'"
		EndIf
		If SuperGetMV('MV_D3SERVI', .F., 'N') == 'N' .And. IntDL()
			cQueryD3 += " AND ( (D3_SERVIC = '   ') OR (D3_SERVIC <> '   ' AND D3_TM <= '500')  "
			cQueryD3 += " OR  (D3_SERVIC <> '   ' AND D3_TM > '500' AND D3_LOCAL ='"+SuperGetMV('MV_CQ', .F., '98')+"') )"
		EndIf		                                 
		
		cQueryD3 += " AND D3_LOCAL >= '"+mv_par01+"'"+" AND D3_LOCAL <= '"+mv_par02+"'"
		cQueryD3 += " AND SD3.D_E_L_E_T_<>'*'"

		cQueryB1:= "SELECT 'SB1',SB1.B1_COD,SB1.B1_TIPO,SB1.B1_UM,SB1.B1_GRUPO,SB1.B1_DESC,'','','','','','',0,0,'','','','','',0,0"
		cQueryB1 += " FROM "
		cQueryB1 += RetSqlName("SB1") + " SB1 "
		cQueryB1 += " WHERE SB1.B1_COD >= '"+mv_par05+"' AND SB1.B1_COD <= '"+mv_par06+"'"

        cQueryB1A:= " AND SB1.B1_COD >= '"+mv_par05+"' AND SB1.B1_COD <= '"+mv_par06+"'"
		cQueryB1C:= " SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_TIPO >= '"+mv_par03+"' AND SB1.B1_TIPO <= '"+mv_par04+"' AND"
		cQueryB1C+= " SB1.D_E_L_E_T_<>'*'"

		cQuery := cQueryD1+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryD2+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryD3+cQueryB1A+" AND "+cQueryB1C+" UNION ALL "+cQueryB1+" AND "+cQueryB1C
		cQuery += " ORDER BY 3,2,1" //3-TIPO/2-PRODUTO/1-ARQ

		cQuery:=ChangeQuery(cQuery)
		MsAguarde({|| dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),cAliasTOP,.F.,.T.)},STR0015)
		SetRegua(LastRec())
		dbSelectArea(cAliasTop)	
	
		Store 0 TO nTotComp,nTotCons,nTotProc,nTotTrans,nTotProd,nTotEnTerc,nTotSaTerc
		Store 0 TO nTotVend,nTotSaldo,nTotSant,nTotOutr,nTotDevVen,nTotDevCom,_nETotFil,_nSTotFil
	
		While lContinua .And. !EOF()
		
			If lEnd
				@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
				lContinua := .F.
				Exit
			EndIf
	        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	        //³ Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  ³
		    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        	If !Empty(aReturn[7])
	            dbSelectArea("SB1") 
	            dbSetOrder(1) 
	            If dbSeek(xFilial()+(cAliasTop)->PRODUTO)
    	 	    	If !&(aReturn[7])
      		        	dbSelectArea(cAliasTop)
		    		    dbSkip()
				        Loop
		        	Endif   
			    Else
   	    	    	dbSelectArea(cAliasTop)
            		dbSkip()
				    Loop
		       	Endif
  		       	dbSelectArea(cAliasTop)
		    Endif   
			
			cTipant := (cAliasTop)->B1_TIPO
			Store 0 TO 	nSalant,nCompras,nReqCons,nReqProd,nEntrTerc,nSaiTerc,_nETrfFil,_nSTrfFil
			Store 0 TO 	nReqTrans,nProducao,nVendas,nSaldoAtu,nReqOutr,nDevVendas,nDevComprs
			lPassou := .F.
		
			While !EOF() .And. (cAliasTop)->B1_TIPO == cTipAnt
			
				If lEnd
					@ PROW()+1,001 PSay STR0013	//"CANCELADO PELO OPERADOR"
					lContinua := .F.
					Exit
				EndIf
		
   		        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		        //³ Filtra Registros de Acordo com a Pasta  Filtro da Janela de Impressao  ³
			    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        		If !Empty(aReturn[7])
		            dbSelectArea("SB1") 
		            dbSetOrder(1) 
	    	        If dbSeek(xFilial()+(cAliasTop)->PRODUTO)
    	 		    	If !&(aReturn[7])
      		    	    	dbSelectArea(cAliasTop)
		    			    dbSkip()
					        Loop
			        	Endif   
				    Else
   	    	    		dbSelectArea(cAliasTop)
            			dbSkip()
					    Loop
			       	Endif
  			       	dbSelectArea(cAliasTop)
		    	Endif   
		        
		        cProduto  := (cAliasTop)->PRODUTO
				IncRegua()
		
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Saldo final e inicial dos almoxarifados                      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SB2")
				dbSeek(xFilial()+cProduto+mv_par01,.T.)
				While !EOF() .And. B2_FILIAL+B2_COD == xFilial()+cProduto .And. B2_LOCAL <= mv_par02
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Verifica se deve somar custo da Mao de Obra no Saldo Final   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If	!(IsProdMod(SB2->B2_COD) .And. mv_par11 == 2)
						IF mv_par10==1
							nSaldoAtu := nSaldoAtu + &("B2_VATU"+cMoeda)
						Elseif mv_par10 == 2
							nSaldoAtu := nSaldoAtu + &("B2_VFIM"+cMoeda)
						Else
							aSaldoAtu	:= CalcEst(SB2->B2_COD,SB2->B2_LOCAL,mv_par08+1)
							nSaldoAtu 	:= nSaldoAtu + aSaldoAtu[mv_par09+1]
						EndIF
					EndIf	
					dbSkip()
				EndDo
		
				lPassou := IIF(nSaldoAtu > 0,.t.,lPassou)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SB1 - Verifica Produtos Sem Movimento						 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SB1"
					dbSkip()
				EndDo



				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SD1 - Pesquisa as Entradas de um determinado produto         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD1"

					dbSelectArea("SF4")
					dbSeek(xFilial()+(cAliasTop)->TES)
					dbSelectArea(cAliasTop)
				
					If SF4->F4_ESTOQUE == "S"
						nValor := (cAliasTop)->CUSTO
						If SF4->F4_PODER3 == "N"
							If (cAliasTop)->TIPONF == "D"
								nDevVendas  += nValor
							Else
								SA2->(DbSelectArea("SA2"))
								SA2->(DbSetOrder(1))
								SA2->(DbGotop())
								SA2->(DbSeek(xFilial("SA2")+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA))
								If SubStr(SA2->A2_CGC,1,8) $ _cFil
									_nETrfFil += nValor // Aqui fazer transferencias 
								Else
									nCompras += nValor
								Endif

								dbSelectArea(cAliasTop)								
							EndIf
						Else	
							nEntrTerc += nValor
						EndIf
						lPassou := .T.
					EndIf
					dbSkip()
				EndDo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SD2 - Pesquisa Vendas                                        ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD2"
			
					dbSelectArea("SF4")
					dbSeek(xFilial()+(cAliasTop)->TES)
					dbSelectArea(cAliasTop)
					If SF4->F4_ESTOQUE == "S"
						nValor := (cAliasTop)->CUSTO
						If SF4->F4_PODER3 == "N"
							If (cAliasTop)->TIPONF == "D"
								nDevComprs += nValor
							Else
								SA1->(DbSelectArea("SA1"))
								SA1->(DbSetOrder(1))
								SA1->(DbGotop())
								SA1->(DbSeek(xFilial("SA1")+(cAliasTop)->FORNECEDOR+(cAliasTop)->LOJA))
								If SubStr(SA1->A1_CGC,1,8) $ _cFil
									_nSTrfFil += nValor
								Else
									nVendas  += nValor
								Endif
							EndIf
						Else
							nSaiTerc += nValor
						EndIf
						lPassou := .T.
					EndIf
					dbSkip()
				EndDo

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ SD3 - Pesquisa requisicoes                                   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea(cAliasTop)
				While !Eof() .And. (cAliasTop)->PRODUTO == cProduto .And. Alltrim((cAliasTop)->ARQ) == "SD3"

					nValor := (cAliasTop)->CUSTO
				
					If (cAliasTop)->TES > "500"
						nValor := nValor*-1
					EndIf
			
					If Substr((cAliasTop)->CF,1,2) == "PR"
						nProducao += nValor
					ElseIf allTrim((cAliasTop)->CF)$"RE4/DE4"
						nReqTrans += nValor
					ElseIf Empty((cAliasTop)->OP) .And. Substr((cAliasTop)->CF,3,1) != "3"
						nReqCons += nValor
					ElseIf !Empty((cAliasTop)->OP)
						nReqProd += nValor
					Else
						nReqOutr += nValor
					EndIf
					lPassou := .T.
					dbSkip()
				EndDo
				dbSelectArea(cAliasTop)
			EndDo
		
			If lPassou
				lTotal:=.T.
				If li > 55
					Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
				EndIf
				li++
				nSalant := nSaldoAtu-nCompras-nReqProd-nReqCons-nProducao+nVendas-nReqTrans-nReqOutr-nDevVendas+nDevComprs-nEntrTerc+nSaiTerc-_nETrfFil+_nSTrfFil
				// Posicoes (000,005,022,039,056,073,089,106,123,140,157,174,189,204)
				@ li,000 PSay cTipant
				@ li,005 PSay nSalant    Picture TM(nSalant,16)
				@ li,022 PSay nCompras   Picture TM(nCompras,16) 
				@ LI,039 Psay _nETrfFil 	 Picture TM(nReqCons,16)
				@ li,056 PSay (nReqCons+nReqProd+nReqTrans+nProducao+nReqOutr+nEntrTerc+nSaiTerc)  Picture TM(nReqCons,16)
				@ li,073 PSay nVendas    Picture TM(nVendas,16)
				@ li,089 Psay _nSTrfFil Picture TM(nVendas,16)
//				@ li,073 PSay nReqTrans  Picture TM(nReqTrans,16) ok
//				@ li,089 PSay nProducao  Picture TM(nProducao,16) ok
//				@ li,106 PSay nVendas    Picture TM(nVendas,16) ok
//				@ li,123 PSay nReqOutr   Picture TM(nReqOutr,16) ok
				@ li,106 PSay nDevVendas Picture TM(nDevVendas,16) 
				@ li,123 PSay nDevComprs Picture TM(nDevComprs,16)
				@ li,140 PSay nSaldoAtu  Picture TM(nSaldoAtu,16)
//				@ li,174 PSay nEntrTerc  Picture TM(nCompras,14)
//				@ li,189 PSay nSaiTerc   Picture TM(nVendas,14)

				nTotSant  += nSalant
				_nETotFil  += _nETrfFil
				_nSTotFil += _nSTrfFil
				nTotComp  += nCompras
				nTotCons  += nReqCons
				nTotProc  += nReqProd
				nTotTrans += nReqTrans
				nTotProd  += nProducao
				nTotVend  += nVendas
				nTotEnTerc+= nEntrTerc
				nTotSaTerc+= nSaiTerc
				nTotSaldo += nSaldoAtu
				nTotOutr  += nReqOutr
				nTotDevVen+= nDevVendas
				nTotDevCom+= nDevComprs
			EndIf
			dbSelectArea(cAliasTop)
		EndDo

    Endif
#ENDIF

If lTotal
	li++;li++
	If li > 55
		Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo)
	EndIf

	@ li,000 PSay STR0014	//"TOT.:"
	@ li,005 PSay nTotSant  PicTure tm(nTotSant ,16)
	@ li,022 PSay nTotComp  PicTure tm(nTotComp ,16)
	@ li,039 PSay _nETotFil  PicTure tm(nTotCons ,16)
	@ li,056 Psay (nTotCons+nTotProd+nTotTrans+nTotProd+nTotOutr+nTotEnTerc+nTotSaTerc+nTotDevVen+nTotDevCom)  PicTure tm(nTotVend ,16)	
	@ li,073 PSay nTotVend  PicTure tm(nTotVend ,16)	
	@ li,089 Psay _nSTotFil  PicTure tm(nTotVend ,16)	
//	@ li,056 PSay nTotProc  PicTure tm(nTotProc ,16)
//	@ li,073 PSay nTotTrans PicTure tm(nTotTrans,16)
//	@ li,089 PSay nTotProd  PicTure tm(nTotProd ,16)
	@ li,106 PSay nTotDevVen PicTure tm(nTotDevVen,16)
	@ li,123 PSay nTotDevCom PicTure tm(nTotDevCom,16)
	@ li,140 PSay nTotSaldo PicTure tm(nTotSaldo,16)
//	@ li,123 PSay nTotOutr  PicTure tm(nTotOutr ,16)
//	@ li,140 PSay nTotDevVen PicTure tm(nTotDevVen,16)
//	@ li,157 PSay nTotDevCom PicTure tm(nTotDevCom,16)
//	@ li,174 PSay nTotEnTerc Picture TM(nTotComp,14)
//	@ li,189 PSay nTotSaTerc Picture TM(nTotVend,14)

EndIf

If li != 80
	Roda(nCntImpr,cRodaTxt,Tamanho)
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restauras as ordens principais dos arquivos envolvidos       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(1)
dbSelectArea("SD2")
dbSetOrder(1)
dbSelectArea("SD3")
dbSetOrder(1)

#IFDEF TOP
    If lQuery 
		(cAliasTop)->(dbCloseArea())
    Endif		
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Devolve a condicao original do arquivo principal             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(cString)
dbSetOrder(1)
dbClearFilter()

If aReturn[5] = 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³AjustaSX1 ³ Autor ³ Fernando Joly Siquini ³ Data ³30.06.2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³Cria a 12a pergunta                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function AjustaSX1()

Local aHelpPor := {} 
Local aHelpEng := {} 
Local aHelpSpa := {} 
Local nTamSX1  := Len(SX1->X1_GRUPO)

aAdd(aHelpPor, 'Considera ou nao as OPs geradas pelo    ')
aAdd(aHelpPor, 'modulo de Manutencao de Ativos          ')
aAdd(aHelpPor, 'neste relatorio                         ')

aAdd( aHelpEng, 'It considers or not the POs generated by')
aAdd( aHelpEng, 'the Asset Maintenance module            ')
aAdd( aHelpEng, 'in this report                          ')

aAdd( aHelpSpa, 'Considera o no las OPs generadas por el ')
aAdd( aHelpSpa, 'modulo de Mantenimiento De Activos      ')
aAdd( aHelpSpa, 'en este informe                         ')

PutSx1( 'MTR320','12','Considera OPs do SIGAMNT     ?','¿Considera OPs do SIGAMNT    ?','Consider POs from SIGAMNT    ?','mv_chc',;
'N',1,0,1,'C','','','','N','mv_par12','Sim','Si','Yes','',;
'Nao','No','No','','','','','','','','','',;
aHelpPor,aHelpEng,aHelpSpa)

dbSelectArea("SX1")
dbSetOrder(1)
If SX1->(DbSeek (PADR("MTR320",nTamSX1)+"12"))
	RecLock("SX1",.F.)
	Replace SX1->X1_PYME With "N"
	MsUnLock()
EndIf

Return Nil


Static Function VerEmp()
Local cRet		:= ""
Local _aAreaSM0	:= GetArea()
SM0->(DbSelectArea("SM0"))
SM0->(DbGotop())
While !SM0->(Eof())
	If !SubStr(SM0->M0_CGC,1,8) $ cRet
		cRet	+= SubStr(SM0->M0_CGC,1,8)+"/"
	Endif
	SM0->(DbSkip())
End
RestArea(_aAreaSM0)
Return(cRet)