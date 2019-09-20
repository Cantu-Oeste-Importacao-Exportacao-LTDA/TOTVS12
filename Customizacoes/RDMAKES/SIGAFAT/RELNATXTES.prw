#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELNATXTES     ºAutor  J&@Nº             Data ³  21/06/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório para fins de conferência das TES de entrada  x   º±±
±±º          ³ Natureza financeira                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Faturamento                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RelNatXTes()
Local cPerg := "RELNATXTES" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSx(cPerg)

if !Pergunte(cPerg, .T.)
	MsgInfo("Operação Finalizada pelo Usuário.")
	Return
EndIf

RptStatus({|lEnd| GravaCSV(@lEnd) }, "Aguarde...","Buscando informações...", .T.)

Return Nil

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*¿
//³Função que faz a geração do arquivo CSV³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*Ù

Static Function GravaCSV(lEnd)
Local cSql    := ""
Local cCod    := ""
Local cEol    := ""
Local aEmp    := {}   
Local aArea   := {}      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Array de campos do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
//Gustavo 22/05/14 - Alterado para imprimir campo D1_CONTA
Local aFields := {"EMP","D1_FILIAL","E2_CLVLDB","D1_TIPO","D1_SERIE","D1_DOC","D1_FORNECE","D1_LOJA","D1_TES","E2_NATUREZ",;
									"F4_ESTOQUE","D1_CONTA","D1_CC","D1_RATEIO","DE_CLVL","D1_EMISSAO","D1_DTDIGIT","F1_VALBRUT","F1_USUARIO","MULTINAT"}
Local aHeader := {}
Local nCount  := 0       
Local cPath   := ""                       
Local cTipo   := "Arquivos CSV | *.csv"
Local cCrLf   := CHR(13) + CHR(10)

cEol := cCrLf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca informações no dicionário de dados para compor o cabeçalho do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX3")
DbSetOrder(02)
For i := 1 to len(aFields)
	if SX3->(DbSeek(aFields[i]))
		Aadd(aHeader, {AllTrim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
   		                 	SX3->X3_USADO,;
		                 	SX3->X3_TIPO,;
		                 	SX3->X3_F3,;
		                 	SX3->X3_CONTEXT,;
		                 	SX3->X3_CBOX,;
		                 	SX3->X3_RELACAO})
  	Else
	  	if aFields[i] == "EMP"
	  		Aadd(aHeader, {"Empresa","EMP","@!",2,0})  
		ElseIf aFields[i] == "MULTINAT"	
			Aadd(aHeader, {"Multi Natureza","MULTINAT","@!",3,0})  	
	  	EndIf
	EndIf
Next i
                                                                                                                                               
cSql := ""                                                                                                                                                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Efetua a montagem do comando SQL que vai fazer a busca das informações ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql += "SELECT '"+ SM0->M0_CODIGO +"' AS EMP, FILIAL, SEGMENTO, TIPO, SERIE, DOC, FORNECEDOR, LOJA, TES, NATUREZA, ESTOQUE, CONTA, RATEIODOC, "	+ cEol
cSql += "      CONTA_RATEIO, RATEIO, SEG_RATEIO, SEG_ITEM, EMISSAO, LANCAMENTO, TOTAL, USUARIO, SEGMENTODOC, CONTADOC, CC, MULTINAT FROM ( "+ cEol
cSql += "      SELECT DISTINCT D1.D1_FILIAL AS FILIAL, E2.E2_CLVLDB AS SEGMENTO, D1.D1_TIPO AS TIPO, D1.D1_SERIE AS SERIE, D1.D1_DOC AS DOC, "               	+ cEol
cSql += "                        D1.D1_FORNECE AS FORNECEDOR, D1.D1_LOJA AS LOJA, D1.D1_TES AS TES, E2.E2_NATUREZ AS NATUREZA, "            + cEol
cSql += "                        F4.F4_ESTOQUE AS ESTOQUE, D1.D1_CONTA AS CONTA, DE.DE_CONTA AS CONTA_RATEIO, D1.D1_CC, DE.DE_CC, " 	    + cEol
cSql += "						 	 D1.D1_RATEIO AS RATEIO, DE.DE_CLVL AS SEG_RATEIO, F1.F1_USUARIO AS USUARIO,		"					+ cEol
cSql += "                        D1.D1_CLVL AS SEG_ITEM, D1.D1_EMISSAO AS EMISSAO, D1.D1_DTDIGIT AS LANCAMENTO, F1.F1_VALBRUT AS TOTAL, " 	+ cEol

cSql += "                       (CASE "																										+ cEol
cSql += "                          WHEN D1.D1_RATEIO = '1' THEN DE.DE_CLVL "																+ cEol
cSql += "                        ELSE "																										+ cEol
cSql += " 								D1.D1_CLVL		"																					+ cEol
cSql += "                        END ) AS SEGMENTODOC,		"																				+ cEol

cSql += "                         (CASE "																									+ cEol
cSql += "                          WHEN D1.D1_RATEIO = '1'	"																				+ cEol 
cSql += "                            THEN DE.DE_CONTA "																						+ cEol
cSql += "                           ELSE "																									+ cEol
cSql += "                            D1.D1_CONTA "																							+ cEol
cSql += "                          END) AS CONTADOC, "																						+ cEol

cSql += "                         (CASE "																									+ cEol
cSql += "                          WHEN D1.D1_RATEIO = '1' "																				+ cEol
cSql += "                            THEN 'Sim' "																							+ cEol
cSql += "                          ELSE "																									+ cEol
cSql += "                            'Não' "																								+ cEol
cSql += "                          END) AS RATEIODOC, "																						+ cEol

cSql += "                         (CASE "																									+ cEol
cSql += "                          WHEN D1.D1_RATEIO = '1' "																				+ cEol
cSql += "                            THEN DE.DE_CC "																						+ cEol
cSql += "                          ELSE "																									+ cEol
cSql += "                            D1.D1_CC "																								+ cEol
cSql += "                          END) AS CC, "																							+ cEol
cSql += "                          (CASE "                                                                                                  + cEol
cSql += "                          WHEN (SELECT COUNT(*) FROM "+ retSqlName("SEV") +" EV "													+ cEol
cSql += "								 WHERE EV.D_E_L_E_T_ = ' ' AND EV.EV_FILIAL = D1.D1_FILIAL "										+ cEol 
cSql += "                                AND EV.EV_NUM = D1.D1_DOC AND EV.EV_PREFIXO = D1.D1_SERIE 	"										+ cEol
cSql += "								 AND EV.EV_CLIFOR = D1.D1_FORNECE AND EV.EV_LOJA = D1.D1_LOJA ) > 0 "								+ cEol
cSql += "                              THEN 'Sim' "																							+ cEol			
cSql += "                           ELSE "																									+ cEol
cSql += "                              'Não' "																								+ cEol
cSql += "                          End) as MULTINAT " 																						+ cEol

cSql += "        FROM "+ retSqlName("SD1") +" D1 "                                                                         					+ cEol
        
cSql += "        INNER JOIN "+ retSqlName("SF4") +" F4 "                                                                                    + cEol
cSql += "         ON F4.F4_CODIGO = D1.D1_TES "                                                                                             + cEol
cSql += "        AND F4.D_E_L_E_T_ = ' ' "                                                                                                 + cEol
        
cSql += "        INNER JOIN "+ retSqlName("SF1") +" F1 "                                                                                    + cEol
cSql += "         ON F1.F1_SERIE = D1.D1_SERIE "                                                                                            + cEol
cSql += "        AND F1.F1_DOC = D1.D1_DOC "                                                                                                + cEol
cSql += "        AND F1.F1_FORNECE = D1.D1_FORNECE "                                                                                        + cEol
cSql += "        AND F1.F1_LOJA = D1.D1_LOJA "                                                                                              + cEol
cSql += "        AND F1.D_E_L_E_T_ = ' ' "                                                                                                 + cEol

if MV_PAR07 == 1
		cSql += "        AND F1.F1_TIPO <> 'D' "                                                                                            + cEol
EndIf
        
cSql += "        INNER JOIN "+ retSqlName("SE2") +" E2 "                                                                                    + cEol
cSql += "         ON E2.E2_FILIAL = D1.D1_FILIAL "                                                                                          + cEol
cSql += "        AND E2.E2_PREFIXO = D1.D1_SERIE "                                                                                          + cEol
cSql += "        AND E2.E2_NUM = D1.D1_DOC "                                                                                                + cEol
cSql += "        AND E2.E2_FORNECE = D1.D1_FORNECE "                                                                                        + cEol
cSql += "        AND E2.E2_LOJA = D1.D1_LOJA "                                                                                              + cEol
cSql += "        AND E2.E2_NATUREZ BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' "                                                          + cEol
cSql += "        AND E2.D_E_L_E_T_ = ' ' "                                                                                                 + cEol
cSql += "        AND E2.E2_ORIGEM <> 'FINA050' "                                                                                            + cEol
        
cSql += "        LEFT JOIN "+ retSqlName("SDE") +" DE "                                                                                     + cEol
cSql += "         ON DE.D_E_L_E_T_ = ' ' "                                                                                                 + cEol
cSql += "        AND DE.DE_FILIAL = D1.D1_FILIAL "                                                                                          + cEol
cSql += "        AND DE.DE_SERIE = D1.D1_SERIE "                                                                                            + cEol
cSql += "        AND DE.DE_DOC = D1.D1_DOC "                                                                                                + cEol
cSql += "        AND DE.DE_FORNECE = D1.D1_FORNECE "                                                                                        + cEol
cSql += "        AND DE.DE_LOJA = D1.D1_LOJA "                                                                                              + cEol
cSql += "        AND DE.DE_ITEMNF = D1.D1_ITEM "                                                                                            + cEol
         
cSql += "        WHERE D1.D1_DTDIGIT BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' "                                            + cEol
cSql += "          AND D1.D1_TES BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "                                                            + cEol
cSql += "          AND D1.D_E_L_E_T_ = ' ' "	                                                                                            + cEol
   
cSql += "        GROUP BY D1.D1_FILIAL, E2.E2_CLVLDB, D1.D1_TIPO, D1.D1_SERIE, D1.D1_DOC, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_TES, E2.E2_NATUREZ, "        + cEol
cSql += "                 F4.F4_ESTOQUE, D1.D1_CONTA, DE.DE_CONTA, D1.D1_RATEIO, DE.DE_CLVL, D1.D1_CLVL, D1.D1_EMISSAO, D1.D1_DTDIGIT,  "   + cEol
cSql += "				  F1.F1_VALBRUT, F1.F1_USUARIO,  D1.D1_CC, DE.DE_CC																"	+ cEol
cSql += "        ORDER BY D1.D1_FILIAL, E2.E2_CLVLDB, D1.D1_TIPO, D1.D1_SERIE, D1.D1_DOC, D1.D1_FORNECE, D1.D1_LOJA, D1.D1_TES, E2.E2_NATUREZ, "        + cEol
cSql += "                 F4.F4_ESTOQUE, D1.D1_CONTA, DE.DE_CONTA, D1.D1_RATEIO, DE.DE_CLVL,D1.D1_CLVL, D1.D1_EMISSAO, D1.D1_DTDIGIT,  "    + cEol
cSql += "				  F1.F1_VALBRUT, F1.F1_USUARIO,  D1.D1_CC, DE.DE_CC	) "                                                            	+ cEol

cSql := ChangeQuery(cSql)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄf¿
//³Faz a montagem da tabela temporária retornando o alias TBTMP³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄfÙ

TCQUERY cSql NEW ALIAS "TBTMP"

DbSelectArea("TBTMP")
TBTMP->(DbGotop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz a contagem do número de registros ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Count to nCount

TBTMP->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Utiliza variável nCount para saber se a tabela temporária está vazia.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !nCount > 0
	MsgInfo("Não há informações a serem processadas com os filtros informados.")
	TBTMP->(DbCloseArea())
	Return 
EndIf

nArq  := 0
cNome := "RELNATXTES"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ^
//³Função que gera interface para o usuário informar o diretório onde o sistema vai gravar o arquivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ^

cPath := cGetFile( cTipo , "Selecione o local para salvar o arquivo...", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Verifica se o diretório informado pelo usuário existe
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

If ExistDir(cPath)
	nArq  := MsfCreate(AllTrim(cPath) + cNome + ".CSV",0)
Else
	Alert("Local inválido para salvar o arquivo!")
	TBTMP->(DbCloseArea())
	Return
EndIf     

If nArq > 0
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava cabeçalho do arquivo³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	aEval(aHeader, {|e, nX| fWrite(nArq, Upper(e[1]) + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nArq, cCrLf )
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Séta a régua de processamento de acordo com a qtde de registros da tabela temporária.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetRegua(nCount)
	
	cEstoque := ""
	//cRateio  := ""
	cValor   := ""
	
	While !TBTMP->(EOF())
		IncRegua()
	  
	  if TBTMP->ESTOQUE == "S"
	  	cEstoque := "Sim"
	  Else
	  	cEstoque := "Não"
	  EndIf      
	  
	  //Gustavo 09/06/2014 - Se houver rateio deve buscar as informações da tabela de rateio e não do item
	  /*if TBTMP->RATEIO == "1" 
	  	cRateio 	:= "Sim" 
	  	cSegmento   := TBTMP->SEG_RATEIO
	  	cConta		:= TBTMP->CONTA_RATEIO
	  Else
	  	cRateio 	:= "Não"
	  	cSegmento   := TBTMP->SEG_ITEM 
  		cConta		:= TBTMP->CONTA
	  EndIf
	  */
	  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Formata valores como string para poderem ser gravadas no relatório³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	  	dDtEmiss := SubStr(TBTMP->EMISSAO, 07, 02) + "/" + SubStr(TBTMP->EMISSAO, 05, 02) + "/" + SubStr(TBTMP->EMISSAO, 01, 04)                                      
	  	dDtDigit := SubStr(TBTMP->LANCAMENTO, 07, 02) + "/" + SubStr(TBTMP->LANCAMENTO, 05, 02) + "/" + SubStr(TBTMP->LANCAMENTO, 01, 04)                                      
	  	cValor   := Transform(TBTMP->TOTAL,"@E 999,999,999.99")
	  
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Faz a montagem da string da linha do relatório³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		fWrite(nArq, TBTMP->EMP +";"+ TBTMP->FILIAL +";"+ TBTMP->SEGMENTO +";"+ TBTMP->TIPO +";" + TBTMP->SERIE +";"+ TBTMP->DOC +";"+ TBTMP->FORNECEDOR +";"+ TBTMP->LOJA +";"+;
									  TBTMP->TES +";"+ TBTMP->NATUREZA +";"+ cEstoque +";"+ TBTMP->CONTADOC +";" + TBTMP->CC +";" + TBTMP->RATEIODOC +";"+ TBTMP->SEGMENTODOC +";"+ dDtEmiss +";"+;
									  dDtDigit + ";" + cValor + ";" + TBTMP->USUARIO + ";" + TBTMP->MULTINAT)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Grava a linha no arquivo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		fWrite(nArq, cCrLf ) 
	
		TBTMP->(DbSkip())
	EndDo
	
	TBTMP->(DbCloseArea())
  
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Fecha o arquivo que estava sendo gravado³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	fClose(nArq)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Disponibiliza o arquivo gerado no diretório escolhido pelo usuário
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	CpyS2T(SubStr(cPath,3,len(AllTrim(cPath))) + cNome + ".CSV", SubStr(cPath,1,2), .T.)
	
	MsgInfo("Processo concluído com sucesso :) ")
	
Else
	Alert("Falha na criação do arquivo!")
Endif

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Atualiza perguntas do relatório
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function AjustaSX(cPerg)
	PutSx1(cPerg,"01","Data Digit. Inicial ?" ,"Data Digit. Inicial ?" ,"Data Digit. Inicial ?" , "mv_par01", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
	PutSx1(cPerg,"02","Data Digit. Final ?"   ,"Data Digit. Final ?"   ,"Data Digit. Final ?"   , "mv_par02", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
	PutSx1(cPerg,"03","Natureza Inicial ?"    ,"Natureza Inicial ?"    ,"Natureza Inicial ?"    , "mv_par03", "C", 10, 0, ,"G", "", "SED", "", "","MV_PAR03")
	PutSx1(cPerg,"04","Natureza Final ?"      ,"Natureza Final ?"      ,"Natureza Final ?"      , "mv_par04", "C", 10, 0, ,"G", "", "SED", "", "","MV_PAR04")
	PutSx1(cPerg,"05","TES Inicial ?"         ,"TES Inicial ?"         ,"TES Inicial ?"         , "mv_par05", "C", 03, 0, ,"G", "", "SF4", "", "","MV_PAR05")
	PutSx1(cPerg,"06","TES Final ?"           ,"TES Final ?"           ,"TES Final ?"           , "mv_par06", "C", 03, 0, ,"G", "", "SF4", "", "","MV_PAR06")
	PutSx1(cPerg,"07","Considera Devolução ?" ,"Considera Devolução ?" ,"Considera Devolução ?" , "mv_par07", "N", 01, 0, ,"C", "", "", "", "","MV_PAR07","Sim","Sim","Sim", "","Nao","Nao","Nao")
Return Nil