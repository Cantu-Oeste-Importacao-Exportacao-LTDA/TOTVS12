#include "rwmake.ch"
#include "topconn.ch"
#include "Protheus.ch"
/*/
+----------+----------+-------+-----------------------+------+----------+
|Programa  |SLDVNDM   | Autor | Flavio Dias           | Data | 20/08/08 |
+----------+----------+-------+-----------------------+------+----------+                     
|EMPRESA   | CANTU - CHAPECO                                            |
|Descricao | Relatorio Diário/Mensal enviado por email, com o credito   |
|          | devedor ou credor de cada vendedor. Os filtros de vendedor |
|					 | e email estão no array aConf, devido a ser usado o mesmo   |
|					 | fonte para várias empresas. 																|
|          | Esse relatorio é enviado por email, para os emails         |
|          | cadastrados na tabela ZWF. Isso e separado por empresa     |
|          | pelo fato de que os codigos de vendedores diferem de empre-|
|          | sa para empresa.                                           |
+----------+------------------------------------------------------------+
|Uso       | SIGAFIN - Especifico Cantu                                 |
+----------+------------------------------------------------------------+
/*/

User Function SLDVND01()   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv("01","01","","","","",{"SC5","SA3"})
U_SLDVNDM("SLDVND01")
Return Nil

User Function SLDVND02() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv("02","01","","","","",{"SC5","SA3"})
U_SLDVNDM("SLDVND02")
Return Nil

User Function SLDVND10()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv("10","01","","","","",{"SC5","SA3"})
U_SLDVNDM("SLDVND10")
Return Nil

User Function SLDVND40           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

RPCSetEnv("40","01","","","","",{"SC5","SA3"})
U_SLDVNDM("SLDVND40")
Return Nil


User Function SLDVNDMA()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

U_SLDVNDM("MANUAL")
Return Nil

/**************************************
 Função genérica para gerar os email para os responsáveis
 *************************************/
User Function SLDVNDM(cNameFunc)
Local oProcess
Local cQuery  := ""
Local cQuerySfa  := ""	
Local cQuerySZE  := ""
Local cEmail  := ""
Local cEmailC := ""
Local cEmailO := ""
Local lFlag   := .F.
Local nDesc   := 0
Local aArea   := GetArea()
Local dtDe    := ""
Local dtAte   := ""
Local TOT     := 0  // Totalizador geral
Local TOTSFA  := 0
Local TOTVEND := 0  // Totalizador por vendedor
Local cAux    := 0 //Armazena o codigo do vendor anterior
LOCAL count   := 0
Local cEmisD := ""
Local cEmisM := ""
Local cEmisDC5 := ""
Local cEmisMC5 := ""
Local aConf := {}
Local i
Local nTotVend, nTotTab
Local nPrVen, nPrTab, nPerDesc, nDescLivre
Local lManual := (cNameFunc == "MANUAL")
Local dDataDe := dDataBase
Local dDataAte := dDataBase
Local cMailEnv := Space(200)
Local oDlg
Local lCont := .T.               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
Conout("Empresa atual: " + cEmpAnt)
cQuery := " SELECT ZWF_ATIVO, ZWF_EMAIL, ZWF_EMAILC, ZWF_EMAILO FROM "+RetSQLName("ZWF")
cQuery += " WHERE "
cQuery += " ZWF_USERFC = '" + cNameFunc + "' AND "  // cada empresa tem a sua funçao específica
cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SC5")+"%' AND "
cQuery += " D_E_L_E_T_ <> '*' "

TCQUERY cQuery NEW ALIAS "TMP"
//MEMOWRITE("TESTE.SQL",CQUERY)

if (lManual)
	@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Informe os parâmetros"
	@ 010,010 Say "Data Inicial: " PIXEL
	@ 010,070 Get dDataDe Size 60, 10 PIXEL
	@ 025,010 Say "Data Final: " PIXEL
	@ 025,070 Get dDataAte Size 60, 10 PIXEL
	@ 040,010 Say "Email: " PIXEL
	@ 040,070 Get cMailEnv Size 60, 10 PIXEL	
	@ 065,100 BMPBUTTON TYPE 1 ACTION (lCont := .T., Close(oDlg1)) 
	@ 065,130 BMPBUTTON TYPE 2 ACTION (lCont := .F., Close(oDlg1))
	ACTIVATE DIALOG oDlg1 CENTER
EndIf	

ConOut("Inicializando o processo")
dbSelectArea("TMP")
If !TMP->(EOF()) .Or. cNameFunc == "MANUAL"
	If (lCont) // quando efetuado manualmente
		conout("WF - SLDVNDM - INICIO DO ENVIO DE EMAIL SALDOS POR VENDEDOR - "+DTOS(DDATABASE-1))
		            
		// faz o cálculo da data
		dtAte := if(!lManual, DtoS(DDATABASE-1), DtoS(dDataAte))
		dtDe := if(!lManual, Left(DtoS(DDATABASE-1),6) + "01", DtoS(dDataDe)) // pega o ano e o mes + 01 (para iniciar no primeiro dia do mes)
		
		//cEmisM := "(C5_EMISSAO between '" + dtDe + "' AND '" + dtAte + "')"
		cEmisM := "between '" + dtDe + "' AND '" + dtAte + "'" 
		//cEmisD := "(C5_EMISSAO = '" + dtAte + "')"
		cEmisD := "between '" + dtAte + "' AND '" + dtAte + "'"
								 
				           // Filial, Local, Email, 																	Emissao, Desc Emissao, mensal?, EmissBkp
		if (cEmpAnt == "01")
			Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "001001001"})
			Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisD, "Diario", .F., "001001001"})
			Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "002001002"})
			Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisD, "Diario", .F., "002001002"})
		elseif (cEmpAnt == "02")
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisD, "Diario", .F., cEmisDC5})
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisM, "Mensal", .T., cEmisMC5})
		elseif (cEmpAnt == "10")
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisD, "Diario", .F., "001001001"})
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "001001001"})
		  Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisD, "Diario", .F., "002001002"})
		  Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "002001002"})
		elseif (cEmpAnt == "40")
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisD, "Diario", .F., "001001001"})		  
		  Aadd(aConf, {"01", "NACION", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "001001001"})
		  Aadd(aConf, {"01", "IMPORT", "suporte@cantu.com.br", cEmisD, "Diario", .F., "001001002"})		  
		  Aadd(aConf, {"01", "IMPORT", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "001001002"})
		  Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisD, "Diario", .F., "002001002"})
		  Aadd(aConf, {"01", "INDUST", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "002001002"})
		  Aadd(aConf, {"01", "PNEIMP", "suporte@cantu.com.br", cEmisD, "Diario", .F., "005001006"})		  
		  Aadd(aConf, {"01", "PNEIMP", "suporte@cantu.com.br", cEmisM, "Mensal", .T., "005001006"})
		EndIf
		
		For i := 1 to Len(aConf)
			oProcess := TWFProcess():New( "SLDVNDM", "SALDOS POR VENDEDOR")
			oProcess:NewTask( "SLDVNDM", "\workflow\sldvndm2.html" )
			// localiza a empresa e filial
			SM0->(DbSeek(cEmpAnt + aConf[i,1]))
			
			oProcess:cSubject := "Relatorio de Saldos " + aConf[i, 5] + " por Vendedor " + Iif(aConf[i, 6], " de " + ;
								if(lManual, DToC(dDataDe), DToC(SToD(Left(DtoS(DDATABASE-1),6)+"01"))) + " até ", " do dia ") + iif(lManual, DToC(dDataATe), DTOC(DDATABASE-1)) + ;
								" - Armazém " + aConf[i, 2] + " - " + SM0->M0_FILIAL
								
			oHTML := oProcess:oHTML
	
			oHtml:ValByName("DATA1", dDataBase - 1)
			oHtml:ValByName("ATE"  , Iif(aConf[i, 6], " de " + DToC(if(lManual, dDataDe, SToD(Left(DtoS(DDATABASE-1),6)+"01"))) + " até ", " do dia "))
			oHtml:ValByName("TIPO", aConf[i, 5])
			oHtml:ValByName("ARMAZEM", aConf[i, 2])
			
			cQuerySfa := "SELECT C5_FILIAL AS C5FILIAL, A3_COD, A3_NOME, SUM(C6_QTDENT * (C6_PRCVEN - C6_PRCTAB)) AS SALDO, "
			cQuerySfa += " SUM(C5_SLDSFA) AS SALDOSFA, "
			// Adicionado o preço vendido e o preço de tabela
			cQuerySfa += " SUM(C6_QTDENT * C6_PRCVEN) AS VENDIDO, SUM(C6_QTDENT * C6_PRCTAB) AS TABELA "
   		cQuerySfa += "FROM " + RetSQLName("SC5")
   		cQuerySfa += " INNER JOIN " + RetSQLName("SC6") + " ON C6_NUM = C5_NUM AND C6_FILIAL = C5_FILIAL "
   		cQuerySfa += " Inner join " + RetSqlName("SA3") + " on (C5_Vend1 = A3_Cod and C5_Filial = '" + aConf[i, 1] + "'"
   		cQuerySfa += " and ((A3_Filial = C5_FILIAL) OR (A3_Filial = '  '))) "
   		cQuerySfa += " WHERE C5_EMISSAO " + aConf[i, 4] + " AND (" + RetSQLName("SC6") + ".D_E_L_E_T_ <> '*') "
   		cQuerySfa += " AND (A3_Armazem LIKE '%" + aConf[i,2] + "%') AND (C6_PRCTAB > 0) AND C5_X_CLVL = '" + aConf[i, 7] + "'"
   		cQuerySfa += " AND C5_FILIAL = '" + aConf[i, 1] + "' AND C6_LOCAL = '" + aConf[i, 2] + "' GROUP BY C5_FILIAL, A3_COD, A3_NOME ORDER BY A3_COD"
	    

			cQuerySZE := " SELECT SUBSTR(P.IDLOCALFILIALFATURAMENTO, 4, 2) AS FILIAL, A3_COD, A3_NOME, Z22_CODCVL, Z22_ARMAZ, "
			cQuerySZE += "    SUM(I.QUANTIDADE * I.PRECOVENDA) AS VENDIDO, "
			cQuerySZE += "    SUM(I.QUANTIDADE * I.PRECOORIGINAL) AS TABELA "
			cQuerySZE += " FROM PEDIDO P "
			cQuerySZE += " INNER JOIN " + RetSQLName("SA3") + " ON (SUBSTR(P.IDUSUARIO, 1, 6) = A3_COD AND ((A3_FILIAL = SUBSTR(P.IDLOCAL, 4, 2)) OR A3_FILIAL = '  ')) "
			cQuerySZE += "   AND A3_COD IN (SELECT A3_COD FROM "+ RetSqlName("SA3") +" WHERE A3_ARMAZEM LIKE '%" + aConf[i,2] + "%') "
			cQuerySZE += " INNER JOIN PEDIDOPRODUTO I ON (P.IDPEDIDO = I.IDPEDIDO) "
			cQuerySZE += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON (TRIM(B1_COD) = TRIM(I.IDPRODUTO) AND SB1.D_E_L_E_T_ <> '*') "
      cQuerySZE += " LEFT JOIN " + RetSQLName("Z22") + " Z22 on (SB1.B1_LOCPAD = Z22_ARMAZ and SUBSTR(P.IDUSUARIO, 1, 6) = Z22_CODVEN AND Z22.D_E_L_E_T_ <> '*') "
			cQuerySZE += "	 WHERE TO_CHAR(P.DATAPEDIDO, 'YYYYMMDD') " + aConf[i, 4]
			cQuerySZE += "	  AND (SUBSTR(P.IDLOCALFILIALFATURAMENTO, 4, 2) = '" + aConf[i, 1] + "' ) " 
			cQuerySZE += "    AND SUBSTR(P.IDLOCALFILIALFATURAMENTO, 1, 2) = '" + cEmpAnt + "' "
			cQuerySZE += "    AND Z22_CODCVL = '" + aConf[i, 7] + "' AND P.IDNPEDIDOLIDO = 1 " // Somente pedidos sincronizados
			cQuerySZE += " GROUP BY SUBSTR(P.IDLOCALFILIALFATURAMENTO, 4, 2), A3_COD, A3_NOME, Z22_CODCVL, Z22_ARMAZ "
			
			cQuerySZE += "  UNION ALL "

			cQuerySZE += " SELECT ZE_FILIAL AS FILIAL, A3_COD, A3_NOME, Z22_CODCVL, Z22_ARMAZ, "
			cQuerySZE += "  SUM(ZE_QTDVEN * ZE_PRCVEN) AS VENDIDO, "
			cQuerySZE += "  SUM(ZE_QTDVEN * ZE_PRCTAB) AS TABELA "
			cQuerySZE += " FROM " + RetSqlName("SZE") 
			cQuerySZE += " INNER JOIN " + RetSQLName("SA3") + " SA3 ON (ZE_VEND = A3_COD AND SA3.D_E_L_E_T_ <> '*' "
			cQuerySZE += "   AND A3_COD IN (SELECT A3_COD FROM "+ RetSqlName("SA3") +" WHERE A3_ARMAZEM LIKE '%" + aConf[i,2] + "%') "
			cQuerySZE += "   AND ((A3_Filial = ZE_FILIAL) OR A3_FILIAL = '  '))	"
      cQuerySZE += " INNER JOIN " + RetSQLName("Z22") + " Z22 ON (TRIM(Z22_ARMAZ) = TRIM(ZE_LOCAL) AND ZE_VEND = Z22.Z22_CODVEN) "
      cQuerySZE += " WHERE ZE_EMISSAO " + aConf[i, 4]
	    cQuerySZE += "   AND (ZE_FILIAL = '" + aConf[i, 1] + "') "        
			cQuerySZE += " GROUP BY ZE_FILIAL, A3_COD, A3_NOME, ZE_LOCAL, Z22_CODCVL, Z22_ARMAZ "
			cQuerySZE += " ORDER BY A3_COD "
			
			if (i == 1)
				MEMOWRITE("\SLDSFA.SQL",CQUERYSFA)
				MEMOWRITE("\SLDMOBILE.SQL",cQuerySZE)
			EndIf
			
			TCQUERY cQuerySfa NEW ALIAS "TMPSFA"
			TCQUERY cQuerySZE NEW ALIAS "TMPPLM"

			dbSelectArea("TMPSFA")
			dbGoTop()
			TOT := 0
			TOTSFA := 0			
			nTotVend := 0
			nTotTab := 0

			TMPSFA->(DbGoTop())
			While TMPSFA->(!EOF())
			
			  nDescLi := 0
			  
			  // Alterado para desconsiderar o valor de desconto permitido no palm
			  SZA->(DbSetOrder(02))
			  SZA->(DbSeek(aConf[i,1] + aConf[i,2]))
			  // Só usa o desconto livre se ZA_SENHA estiver como 1, do contrário nao considera, devido ao caso do Pneu, 
			  // no cálculo de saldo.
			  
			  // por enquanto nao calcula, devido a ser necessário acertos
			  if (SZA->(FieldPos("ZA_DESCSYN")) > 0) .And. (SZA->ZA_SENHA == "1")
			  	// tira o desconto que pode ser dado do preço de tabela			  
			  	nDescLi := SZA->ZA_DESCSYN
			  EndIf
			  
			  nPrTab := TMPSFA->TABELA - (TMPSFA->TABELA * (nDescLi / 100))
			  nPrVen := TMPSFA->VENDIDO
			  nPerDesc := Round((1-(nPrVen/nPrTab)) * 100, 2)
			  
        // ConOut(TMPSFA->A3_COD + " " + Str(nDescLi, 12, 2) + " -> " + TRANSFORM( nPrTab,'@E 999,999,999.99' ) + " - " +TRANSFORM( nPrVen,'@E 999,999,999.99' ))
        // ConOut("Desconto Livre: " + Str(nDescLi, 12, 2) + " Preco tabela = " + Str(TMPSFA->TABELA))
        
			  AAdd((oHtml:ValByName( "IT.CODIGO" )), TMPSFA->A3_COD )
			  AAdd((oHtml:ValByName( "IT.VENDEDOR" )), TMPSFA->A3_NOME )
			  AAdd((oHtml:ValByName( "IT.SALDO"  )), TRANSFORM( nPrVen - nPrTab ,'@E 999,999,999.99' ) )
			  AAdd((oHtml:ValByName( "IT.PERDESC"  )), TRANSFORM( (1-(nPrVen / nPrTab)) * 100 ,'@E 999.99' ) )
			  TOT := TOT + (nPrVen - nPrTab)
			  
			  nTotVend += nPrVen
			  nTotTab += nPrTab
			  
			  // Localiza no que veio de origem do palm
			  TMPPLM->(DbGoTop())
			  lEncontrou := .F.
			  While TMPPLM->(!Eof()) .And. !lEncontrou
			    if TMPSFA->A3_COD == TMPPLM->A3_COD
			      lEncontrou := .T.
			    Else
			      TMPPLM->(DbSkip())
					EndIf
				EndDo
			  
				if (lEncontrou)
					nPrTab := TMPPLM->TABELA - (TMPPLM->TABELA * (nDescLi / 100))
					AAdd((oHtml:ValByName( "IT.SALDOSFA"  )), TRANSFORM( TMPPLM->VENDIDO - nPrTab ,'@E 999,999,999.99') )
					TOTSFA += TMPPLM->VENDIDO - nPrTab
				else
					AAdd((oHtml:ValByName( "IT.SALDOSFA"  )), "----" ) 
				EndIf

				TMPSFA->(dbSkip())
 			End
			
			AAdd((oHtml:ValByName( "IT.CODIGO"  )), "<strong>TOTAL</strong>")
			AAdd((oHtml:ValByName( "IT.VENDEDOR"  )), " ")
			AAdd((oHtml:ValByName( "IT.SALDO"  )), "<strong>"+TRANSFORM( TOT ,'@E 999,999,999.99')+"</strong>")
			AAdd((oHtml:ValByName( "IT.SALDOSFA"  )), "<strong>"+TRANSFORM( TOTSFA ,'@E 999,999,999.99')+"</strong>")
			AAdd((oHtml:ValByName( "IT.PERDESC"  )), "<strong>"+TRANSFORM( (1-(nTotVend / nTotTab)) * 100 ,'@E 999.99')+"</strong>")
	    
	    // verificar linha abaixo que é alterada para fazer testes
			cEmail  := aConf[i, 3] // "microsiga@cantu.com.br"
			cEmailC := TMP->ZWF_EMAILC
			cEmailO := TMP->ZWF_EMAILO
			oProcess:cTo  := iif(lManual, cMailEnv, LOWER(cEmail))
			oProcess:cCC  := iif(!lManual, LOWER(cEmailC), "")
			oProcess:cBCC := iif(!lManual, LOWER(cEmailO), "")
			oProcess:Start()
			oProcess:Finish()
			lFlag := .T.
			TMPSFA->(dbCloseArea())
			TMPPLM->(dbCloseArea())
			ConOut("Email Enviado Para " + cEmail)
		Next
		Conout("WF - SLDVNDM - FIM DO ENVIO DE EMAIL SALDOS POR VENDEDOR - "+dToS(DDATABASE))
	EndIf
EndIf
TMP->(dbCloseArea())
If lFlag .And. !lManual 
	cQuery := " UPDATE " + RetSQLName("ZWF") + " SET ZWF_ULTEXC = '"+DTOS(dDataBase)+"'"
	cQuery += " WHERE ZWF_USERFC = 'SLDVNDM' AND "
	cQuery += " ZWF_LISFIL LIKE '%"+xFilial("SF2")+"%' AND "
	cQuery += " D_E_L_E_T_ <> '*' "
	TCSQLEXEC(cQuery)
Endif
RestArea(aArea)
Return