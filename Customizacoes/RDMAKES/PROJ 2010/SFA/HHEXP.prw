#INCLUDE "rwmake.ch"
#include "Topconn.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ HEXPSA1B            ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Comlementa fltro de exportacao de clientes                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SFA CRM 8.0                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HEXPSA1B()

Local cQuery	:= PARAMIXB[1]
Local cId		:= HGU->HGU_CODBAS   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())    

cQuery := "FROM "+RetSqlName("SA1")+" SA1, "  + RetSqlName("ZZ5") + " ZZ5 "
cQuery += "WHERE SA1.A1_FILIAL='" + xFilial("SA1") + "' AND "
cQuery += " A1_COD = ZZ5_CLIENT AND A1_LOJA = ZZ5_LOJA AND ZZ5_FILIAL ='" + xFilial("ZZ5") + "' AND "
cQuery += " ZZ5.D_E_L_E_T_ <> '*' AND ZZ5_VEND = '" + cId + "' AND "
If SuperGetMv("MV_SFA1BLQ",,"S") == "N"
	cQuery += "SA1.A1_MSBLQL <> '1' AND "
EndIf
cQuery += "SA1.D_E_L_E_T_ = ' ' "

MEMOWRITE("sqlsa1.SQL",cQuery)

Return cQuery


// Teste de exportação de duplicatas
User Function XEXPHE1()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq
Local cAliasHE1
Local cResult := ""
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("Início da exportacao de Duplicatas para o vendedor " + cID)

// exclui os clientes do HA1
cQrDel := "Delete from " + RetSqlName("HE1") + " WHERE HE1_FILIAL = '"  + xFilial("HE1") + "'"
TCSQLExec(cQrDel)

cQuery := "select E1_FILIAL, E1_PREFIXO, E1_CLIENTE, E1_LOJA, E1_TIPO, E1_EMISSAO, E1_VENCTO, E1_SALDO, E1_NUM, E1_PARCELA, E1_PREFIXO "

cResult := U_HEXPSE1B()

cQuery += " " + cResult

cQuery := ChangeQuery(cQuery)

cAliasHE1 := GetNextAlias()

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasHE1,.T.,.T.)

dbSelectArea("SE1")
dbSetOrder(01)
dbSeek(xFilial("SE1"))
DbSelectArea("HE1")
While (cAliasHE1)->(!Eof())
	RecLock("HE1",.T.)
	HE1_ID := cId  
	HE1_VER := HHNextVer("","HE1")
	HE1_CLI := (cAliasHE1)->E1_CLIENTE
	HE1_LOJA := (cAliasHE1)->E1_LOJA
	HE1_TIPO := (cAliasHE1)->E1_TIPO
	HE1_EMISS := CToD((cAliasHE1)->E1_EMISSAO)
	HE1_VENCTO := CToD((cAliasHE1)->E1_VENCTO)
	HE1_SALDO := (cAliasHE1)->E1_SALDO
	HE1_NUM := (cAliasHE1)->E1_NUM
	HE1_PARCEL := (cAliasHE1)->E1_PARCELA
	HE1_PREFIX := (cAliasHE1)->E1_PREFIXO
	HE1_INTR := "I"
	HE1_FILIAL := (cAliasHE1)->E1_FILIAL
	HE1->(MsUnlock())	
	(cAliasHE1)->(dbSkip())
EndDo
HHUpdCtr("","HE1")
ConOut("Final da exportacao de Duplicatas para o vendedor " + cID)

(cAliasHE1)->(DbCloseArea())
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ HEXPSE1B            ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Comlementa fltro de exportacao de duplicatas               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SFA CRM 8.0                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HEXPSE1B()
//Local cQueryPad := PARAMIXB[1]
Local cId		:= HGU->HGU_CODBAS
Local cQuery	:= ""
Local cSepAba   := If("|"$MVABATIM,"|",",")
Local cSepAnt   := If("|"$MVPAGANT,"|",",")	
Local cSepNeg   := If("|"$MV_CRNEG,"|",",")
Local cSepProv  := If("|"$MVPROVIS,"|",",")
Local cSepRec   := If("|"$MVRECANT,"|",",")
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cQuery += "FROM " + RetSqlName("SE1") + " SE1,  " + RetSqlName("ZZ5") + " ZZ5 "
cQuery += "WHERE ZZ5_CLIENT = E1_CLIENTE AND ZZ5_LOJA = E1_LOJA AND "
cQuery += "ZZ5_FILIAL ='" + xFilial("ZZ5") + "' AND "
cQuery += "SE1.E1_FILIAL = '" + xFilial("SE1") + "' AND "
cQuery += "SE1.E1_VENCTO >= '" + DTOS(dDataBase - 365) + "' AND "
cQuery += " ZZ5.D_E_L_E_T_ <> '*' AND ZZ5_VEND = '" + cId + "' AND "
cQuery += "SE1.E1_STATUS = 'A' AND "
cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,cSepAba)  + " AND "
cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " AND "
cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " AND "
cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " AND "
cQuery += "SE1.E1_TIPO NOT IN " + FormatIn(MVTAXA,,3)  + " AND "
cQuery += "SE1.D_E_L_E_T_ = ' ' "

Return cQuery


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ HEXPSC5A            ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Adiciona campos de saldo para exportacao de pedido         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SFA CRM 8.0                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function HEXPSC5A()
Local aDados := PARAMIXB[1]
aadd(aDados,{"HC5_SLDSFA","C5_SLDSFA"}) // Saldo SFA

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return aDados

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ HHSCR01             ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Fltra exportacao de produtos atraves do script do vendedor ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SFA CRM 8.0                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

/*User Function HHSCR01()

Local cTable	:= PARAMIXB[1]
Local cAlias	:= PARAMIXB[2]
Local cId		:= PARAMIXB[3]
Local aRet 		:= {}
Local nCont := 0
Local cVend := ""
Local aArea := GetArea()


If "HB1" $ cAlias
	AADD(aRet,"HB1_LOCPAD")
	dbSelectArea("SA3")
	dbSetOrder(01)
	If (dbSeek(xFilial("SA3") + cId)) .and. (!EMPTY(SA3->A3_ARMAZEM))
		cLocPad := SA3->A3_ARMAZEM
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica os armazens validos                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cLocPad	:= AllTrim(cLocPad) + "/"
		nX		:= At("/", cLocPad)
		While nX > 0
			AADD(aRet,Substr(cLocPad, 1, nX - 1))
			cLocPad	:= Substr(cLocPad, nX + 1, Len(cLocPad))
			nX		:= At("/", cLocPad)
		EndDo
	EndIf
Elseif ("HCF" $ cAlias) .And. (SA3->(FieldPos("A3_SFCOND")) > 0)
	// altera o parametro do HCF de acordo com a configuração do vendedor, em relaçao a tes inteligente
	// localiza no sa3
	cVend := SubStr(cID, 1, 6)
	SA3->(DbSetOrder(01))
	SA3->(DbSeek(xFilial("SA3") + cVend))
	if !Empty(SA3->A3_SFCOND)
		// localiza no HCF e altera o valor do campo da condição inteligente
		HCF->(DbSetOrder(01))
		HCF->(DbSeek(xFilial("HCF") + cVend + "MV_SFCONDI"))
		
		if HCF->(Found())
			RecLock("HCF", .F.)
			HCF->HCF_VALOR := SA3->A3_SFCOND
			HCF->(MsUnlock())
		EndIf
	EndIf
	RestArea(aArea)
EndIf
     
Return aRet */

/***************************************************************/
// Função para adicionar campos da tabela de condição de pagamento no palm
// 30/10/08 - Adicionado o campo E4_BLOQ para o palm devido a ser necessário para venda no vinho

User Function HEXPSE4A()
Local aDados := PARAMIXB[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (SE4->(FieldPos("E4_BLOQ")) > 0)
  AAdd(aDados,{'HE4_BLOQ','E4_BLOQ'})
EndIf
Return aDados

/***************************************************************/
// Função para exportar as condicoes de pagamento para o palm, ficando exclusiva e devido a erro com o a funcao padrao - 14-12-2010

User Function HEXPSE4()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq
Local cAliasHE4                  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("Início da exportacao de Condicao de Pagamento " + cID)

// exclui os clientes do HA1
cQrDel := "Delete from " + RetSqlName("HE4") + " WHERE HE4_FILIAL = '"  + xFilial("HE4") + "' AND HE4_ID = '" + cId + "' " 
TCSQLExec(cQrDel)

dbSelectArea("SE4")
dbSetOrder(01)
dbGoTop()
While SE4->(!Eof()) .And. SE4->E4_FILIAL = xFilial("SE4")
	RecLock("HE4", .T.)
	HE4->HE4_FILIAL := xFilial("HE4")
	HE4->HE4_ID := cId
	HE4->HE4_VER := HHNextVer("","HE4")
	HE4->HE4_CODIGO := SE4->E4_CODIGO
	HE4->HE4_DESCRI := SE4->E4_DESCRI
	HE4->HE4_TIPO := SE4->E4_TIPO
	HE4->HE4_COND := SE4->E4_COND
	HE4->HE4_BLOQ := SE4->E4_BLOQ
	HE4->HE4_INTR := "I"
	HE4->(MsUnlock())
	SE4->(dbskip())
EndDo

HHUpdCtr("","HE4")
ConOut("Final da exportacao de condicao de pagamento " + cID)

SE4->(dbCloseArea())
HE4->(dbCloseArea())

Return Nil

/***************************************************************/
// Função para exportar os produtos para o palm, ficando exclusiva e devido a erro com o a funcao padrao - 14-12-2010
User Function HEXPSB1()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq
Local cLocVend := Posicione("SA3", 01, xFilial("SA3") + cId, "A3_ARMAZEM")
Local aGrupos := {}
Local aArq := GetNextAlias()
Local aArqInd := ""
Local cSqlProd := ""             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("Início da exportacao de Produtos para " + cID)

// exclui os produtos do HB1
cQrDel := "Delete from " + RetSqlName("HB1") + " WHERE HB1_FILIAL = '"  + xFilial("HB1") + "' AND HB1_ID = '" + cId + "' "
TCSQLExec(cQrDel)

cSqlProd := "select distinct da1_codpro from " + RetSqlName("DA1") +  " da1 where da1_prcven > 0 and da1_codtab in "
cSqlProd += " (select distinct zz5_tabela from " + RetSqlName("ZZ5") + " ZZ5 where zz5_vend = '" + cId + "' and d_e_l_e_t_ <> '*' "
cSqlProd += " and zz5_filial = '" + xFilial("ZZ5") + "') and da1_filial = '" + xFilial("DA1") + "' and d_e_l_e_t_ <> '*' ORDER BY DA1_CODPRO "

TcQuery cSqlProd NEW ALIAS "SB1TAB"

dbSelectArea("SB1TAB")

//dbSelectArea("DA1")
//dbSetOrder(02)

dbSelectArea("SB1")
dbSetOrder(01)
SB1->(dbGotop())
//While SB1->(!Eof()) .And. SB1->B1_FILIAL = xFilial("SB1")
While SB1TAB->(!Eof())

	// Localiza o produto no SB1
	SB1->(dbSeek(xFilial("SB1") + SB1TAB->DA1_CODPRO))
	
	// Valida se tem o produto na tabela de preço da filial
	//lTemTab := DA1->(dbSeek(xFilial("DA1") + SB1->B1_COD))
	
	if !(B1_LOCPAD $ cLocVend) .or. SB1->B1_EXPALM <> "1" // .or. !lTemTab
		SB1TAB->(dbskip()) // Move o cursor da tabela temporaria e nao o sb1
		loop
	EndIf
	
	SBZ->(dbSetOrder(01))
	SBZ->(dbSeek(xFilial("SBZ") + SB1->B1_COD))
	
	dbSelectArea("SB1")
	
	if aScan(aGrupos, SB1->B1_GRUPO) == 0
		aAdd(aGrupos, SB1->B1_GRUPO)
	EndIf
	
	RecLock("HB1", .T.)
	HB1->HB1_FILIAL := xFilial("HB1")
	HB1->HB1_ID := cId
	HB1->HB1_INTR := "I"
	HB1->HB1_GRUPO := SB1->B1_GRUPO
	HB1->HB1_COD := SB1->B1_COD
	HB1->HB1_DESC := SB1->B1_DESC
	HB1->HB1_UM := SB1->B1_UM
	HB1->HB1_PICM := SB1->B1_PICM
	HB1->HB1_IPI := SB1->B1_IPI
	HB1->HB1_QE := SB1->B1_QE
	HB1->HB1_PE := SB1->B1_PE
	HB1->HB1_EST := ""//SB1->B1_EST
	// Usa a tes do indicador do produto
	HB1->HB1_TS := SBZ->BZ_TS // B1_TS
	HB1->HB1_SEGUM := SB1->B1_SEGUM
	HB1->HB1_PBRUTO := SB1->B1_PESBRU
	HB1->HB1_TIPCON := SB1->B1_TIPCONV
	HB1->HB1_GRTRIB := SB1->B1_GRTRIB
	//HB1->HB1_VLRICM := SB1->B1_VLRICM
	//HB1->HB1_VLRIPI := SB1->B1_VLRIPI
	HB1->HB1_CONV := SB1->B1_CONV
	
	// Verificar o local padrao do produto, pois dependendo do vendedor ele deve ser alterado
	// Se for empresa 50, filial 01, e tiver o local import deve ser usado nacion
	HB1->HB1_LOCPAD := if(cEmpAnt == "50" .And. cFilAnt == "01" .And. SB1->B1_LOCPAD == "IMPORT", "NACION",SB1->B1_LOCPAD)
	HB1->HB1_DESMAX := SB1->B1_DESCMAX
	HB1->HB1_VER := HHNextVer("","HB1")
	HB1->(MsUnlock())
	//SB1->(dbskip())
	SB1TAB->(dbSkip())
EndDo

SB1TAB->(dbCloseArea())

HHUpdCtr("","HB1")
ConOut("Final da exportacao de produtos para " + cID)
SB1->(dbCloseArea())
HB1->(dbCloseArea())

// Faz a exportaçao dos grupos de produtos com base apenas nos grupos utilizados nos produtos

ConOut("Inicio da exportaçao de Grupos para " + cId)

// exclui os produtos do HBM
cQrDel := "Delete from " + RetSqlName("HBM") + " WHERE HBM_FILIAL = '"  + xFilial("HBM") + "' AND HBM_ID = '" + cId + "' "
TCSQLExec(cQrDel)
                    
dbSelectArea("SBM")
SBM->(dbGoTop())
While xFilial("SBM") == SBM->BM_FILIAL .And. SBM->(!Eof())

	if (aScan(aGrupos, SBM->BM_GRUPO) == 0)
		SBM->(dbSkip())
		loop	
	EndIf
	
	RecLock("HBM", .T.)
	
	HBM->HBM_FILIAL := xFilial("HBM")
	HBM->HBM_ID := cId
	HBM->HBM_GRUPO := SBM->BM_GRUPO
	HBM->HBM_DESC := SBM->BM_DESC
	HBM->HBM_INTR := "I"
	HBM->HBM_VER := HHNextVer("","HBM")
	HBM->(MsUnlock())
	
	SBM->(dbSkip())
EndDo

HHUpdCtr("","HBM")
ConOut("Final da exportaçao de Grupos para " + cId)

Return Nil

// Funcao para exportar a tabela de preço e itens da tabela de preço para o vendedor
User Function HHEXPDA0()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ConOut("Início da exportacao de Tabela de Preço para " + cID)

// exclui os itens das tabelas de preço
cQrDel := "Delete from " + RetSqlName("HPR") + " WHERE HPR_FILIAL = '"  + xFilial("HPR") + "' AND HPR_ID = '" + cId + "' "
TCSQLExec(cQrDel)
                             
// exclui as tabela de preço
cQrDel := "Delete from " + RetSqlName("HTC") + " WHERE HTC_FILIAL = '"  + xFilial("HTC") + "' AND HTC_ID = '" + cId + "' "
TCSQLExec(cQrDel)

cQuery := "select da0.* from "  + RetSqlName("DA0") + " DA0 WHERE DA0_FILIAL = '" + xFilial("DA0") + "' AND D_E_L_E_T_ <> '*' "
cQuery += " AND EXISTS (SELECT ZZ5_TABELA FROM " + retSqlName("ZZ5") + " WHERE ZZ5_FILIAL = '" + xFilial("ZZ5") + "' "
cQuery += " and zz5_vend = '" + cId + "' and d_e_l_e_t_ <> '*' and zz5_tabela = DA0_CODTAB) "

TCQUERY cQuery NEW ALIAS "DA0TMP"

While DA0TMP->(!Eof())
	RecLock("HTC", .T.)
	
	HTC->HTC_FILIAL := xFilial("HTC")
	HTC->HTC_ID := cId
	HTC->HTC_TAB := DA0TMP->DA0_CODTAB
	HTC->HTC_DESCRI := DA0TMP->DA0_DESCRI
	HTC->HTC_COND := DA0TMP->DA0_CONDPG
	HTC->HTC_DATATE := StoD(DA0TMP->DA0_DATATE)
	HTC->HTC_HORATE := DA0TMP->DA0_HORATE
	HTC->HTC_DATADE := StoD(DA0TMP->DA0_DATDE)
	HTC->HTC_HORADE := DA0TMP->DA0_HORADE
	HTC->HTC_TPHORA := DA0TMP->DA0_TPHORA
	HTC->HTC_INTR := "I"
	HTC->HTC_VER := HHNextVer("","HTC")
	HTC->HTC_QTDLOT := 0
	
	HTC->(MsUnlock())
	
	DA0TMP->(dbSkip())
EndDo

DA0TMP->(dbCloseArea())

cQuery := "select da1.* from "  + RetSqlName("DA1") + " DA1 WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND D_E_L_E_T_ <> '*' "
cQuery += " AND EXISTS (SELECT ZZ5_TABELA FROM " + retSqlName("ZZ5") + " WHERE ZZ5_FILIAL = '" + xFilial("ZZ5") + "' "
cQuery += " and zz5_vend = '" + cId + "' and d_e_l_e_t_ <> '*' and zz5_tabela = DA1_CODTAB) AND DA1_PRCVEN > 0 "

TCQUERY cQuery NEW ALIAS "DA1TMP"

While DA1TMP->(!Eof())
	RecLock("HPR", .T.)

	HPR->HPR_FILIAL := xFilial("HPR")
	HPR->HPR_ID := cId
	HPR->HPR_GRUPO := DA1TMP->DA1_GRUPO
	HPR->HPR_PROD := DA1TMP->DA1_CODPROD
	HPR->HPR_TAB := DA1TMP->DA1_CODTAB
	HPR->HPR_UNI := DA1TMP->DA1_PRCVEN	
	HPR->HPR_ITEM  := DA1TMP->DA1_ITEM
	HPR->HPR_QTDLOT := DA1TMP->DA1_QTDLOT
	HPR->HPR_INDLOT := DA1TMP->DA1_INDLOT
	HPR->HPR_INTR := "I"
	HPR->HPR_VER := HHNextVer("","HPR")

	HPR->(MsUnlock())
	
	DA1TMP->(dbSkip())
EndDo

DA1TMP->(dbCloseArea())

HHUpdCtr("","HPR")
HHUpdCtr("","HTC")
ConOut("Final da exportacao de Tabelas de Preco para " + cID)
   
HPR->(dbCloseArea())
HTC->(dbCloseArea())
DA0->(dbCloseArea())
DA1->(dbCloseArea())

Return Nil

/************************************************
 Exportaçao de transportador, para exportar somente 
 aqueles que eles podem usar
*/
User Function XEXPHA4()
Local cQuery, cQrDel
Local cId := HGU->HGU_CODBAS
Local cArq

Local cTransp := ""

cTransp := Posicione("SA3", 01, xFilial("SA3") + cId, "A3_HPAGE")

ConOut("Início da exportacao de Transportadores para " + cID)
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// exclui os clientes do HA1
cQrDel := "Delete from " + RetSqlName("HA4") + " WHERE HA4_FILIAL = '"  + xFilial("HA4") + "' AND HA4_ID = '" + cId + "' " 
TCSQLExec(cQrDel)

// Considera os registros excluidos
if select("HA4") > 0
	HA4->(dbCloseArea())
EndIf

// Considera os registros excluídos
SET DELETED OFF

dbSelectArea("SA4")
dbSetOrder(01)
While SA4->(!Eof()) .And. SA4->A4_FILIAL = xFilial("SA4")

	if !(SA4->A4_COD $ cTransp)
		SA4->(dbskip())
		loop
	EndIf
	
	RecLock("HA4", .T.)
	HA4->HA4_FILIAL := xFilial("HA4")
	HA4->HA4_ID := cId
	HA4->HA4_INTR := "I"
	HA4->HA4_VER := HHNextVer("","HA4")
	HA4->HA4_COD := SA4->A4_COD
	HA4->HA4_NOME := SA4->A4_NREDUZ
	HA4->HA4_CGC  := SA4->A4_CGC
	HA4->(MsUnlock())
	SA4->(dbskip())
EndDo

SET DELETED ON

HHUpdCtr("","HA4")
ConOut("Final da exportacao de transportadores para " + cID)

SA4->(dbCloseArea())
HA4->(dbCloseArea())

Return Nil