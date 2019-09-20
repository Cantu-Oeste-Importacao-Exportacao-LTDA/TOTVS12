#INCLUDE "rwmake.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ XEXPHA1             ³Autor ³ Flavio Dias  ³ Data ³17/09/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exportacao do cadastro de clientes - Personalizado	 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function XEXPHA1()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq
Local cAliasSA1    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*ConOut("Exclusão de produtos para o vendedor " + cID)
// Exclusao dos produtos, antes de gerar os mesmos, pois o proximo job vai executar os produtos.
// Migrado para cá devido a náo poder usar o ponto de entrada para filtro no hb1, 
// pois gera um delete que elimita todos os produtos das outras filiais
cQrDelProd := "Delete from " + RetSqlName("HB1") + " where hb1_filial = '" + xFilial("HB1") + "'"
TCSQLExec(cQrDelProd)*/

ConOut("Início da exportacao de clientes para o vendedor " + cID)

// exclui os clientes do HA1
cQrDel := "Delete from " + RetSqlName("HA1") + " WHERE HA1_ID = '"  + cId + "'"

TCSQLExec(cQrDel)

cQuery2 := " Insert into " + RetSqlName("HA1") + "(HA1_ATR, HA1_BAIRRO, HA1_CALSUF ,HA1_CEP, HA1_CGC, HA1_COD, HA1_COND, HA1_DTNASC, " // HA1_EMAIL,
cQuery2 += " HA1_END, HA1_EST, HA1_FAX, HA1_FILIAL, HA1_GRPTRB, HA1_GRPVEN, HA1_INSCR, HA1_INSCRM, HA1_INTR, "
cQuery2 += " HA1_LC, HA1_LOJA, HA1_MAIDUP, HA1_MATR, HA1_MCOMPR, HA1_METR, HA1_MSALDO, HA1_MUN, HA1_NATURE, HA1_NOME, "
cQuery2 += " HA1_NREDUZ, HA1_NROCOM, HA1_NROPAG, HA1_PAGATR, HA1_PRICOM, HA1_REGIAO, HA1_RG , HA1_RISCO, HA1_SALDUP,"
cQuery2 += " HA1_SALPDL, HA1_SALPED, HA1_TABELA, HA1_TEL, HA1_TIPO, HA1_TITPRO, HA1_TPFRET, HA1_TRANSP, HA1_ULTCOM, "
cQuery2 += " HA1_ULTVIS, HA1_VACUM, HA1_VENCLC, HA1_VEND, HA1_ID, R_E_C_N_O_, HA1_VER ) "
 
cQuery2 += " select A1_ATR,A1_BAIRRO,A1_CALCSUF,A1_CEP,A1_CGC,A1_COD,A1_COND,A1_DTNASC,A1_END, " // A1_EMAIL,
cQuery2 += " A1_EST,A1_FAX,A1_FILIAL, A1_GRPTRIB,A1_GRPVEN,A1_INSCR,A1_INSCRM, 'I', "
cQuery2 += " A1_LC,A1_LOJA,A1_MAIDUPL,A1_MATR,A1_MCOMPRA,A1_METR,A1_MSALDO,A1_MUN,A1_NATUREZ,A1_NOME, "
cQuery2 += " A1_NREDUZ,A1_NROCOM,A1_NROPAG,A1_PAGATR,A1_PRICOM,A1_REGIAO,A1_RG,A1_RISCO,A1_SALDUP, "
cQuery2 += " A1_SALPEDL,A1_SALPED, " 

cQuery2 += " (SELECT max(SUBSTR(ZZ5_TABELA,1,3))  FROM " + RetSqlName("ZZ5" ) + " ZZ5 WHERE A1_COD = ZZ5_CLIENT AND A1_LOJA = ZZ5_LOJA "
cQuery2 += " AND   ZZ5.D_E_L_E_T_ <> '*' AND ZZ5_VEND = '" + cId + "' AND  ZZ5_FILIAL ='" + xFilial("ZZ5") + "'), "
                                                 // A1_TRANSP
cQuery2 += " A1_TEL,A1_TIPO,A1_TITPROT,A1_TPFRET,'XXXXXX',A1_ULTCOM, "    // busca a tabela da tabela relacional e nao do cliente
cQuery2 += " A1_ULTVIS,A1_VACUM,A1_VENCLC,A1_VEND, '" + cID + "', " + RetSqlName("HA1") + "_RNO.NEXTVAL , "   + AllTrim(Str(HHNextVer("","HA1"))) + " "

cQuery2 += "FROM "+RetSqlName("SA1")+" SA1 "
cQuery2 += "WHERE SA1.A1_FILIAL='" + xFilial("SA1") + "' AND "

If SuperGetMv("MV_SFA1BLQ",,"S") == "N"
	cQuery2 += "SA1.A1_MSBLQL <> '1' AND "
EndIf
cQuery2 += "SA1.D_E_L_E_T_ = ' ' "

cQuery2 += " AND EXISTS (SELECT ZZ5_CLIENT FROM " + RetSqlName("ZZ5") + " ZZ5 WHERE A1_COD = ZZ5_CLIENT AND A1_LOJA = ZZ5_LOJA AND ZZ5_FILIAL ='" + xFilial("ZZ5") + "' AND "
cQuery2 += " ZZ5.D_E_L_E_T_ <> '*' AND ZZ5_VEND = '" + cId + "') "


MemoWrite("\qrinserepalm.sql",cQuery2)

TCSQLExec(cQuery2)

HHUpdCtr("","HA1")
ConOut("Final da exportacao de clientes para o vendedor " + cID)

Return