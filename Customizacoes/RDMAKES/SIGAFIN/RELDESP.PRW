#INCLUDE "rwmake.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  ณRELCIT  บAutorณJoseane Buzzi Schiochet บ Data ณ  18/04/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de despesas                         			  บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function RELDESP()
  

Local cPerg := "RELDESP"
Local cPerg := PadR(cPerg,10," ")

Private aDados := {}
Private aCabec := {}  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

VldPerg(cPerg)  //Verificar se as Perguntas existem no SX1, se nao existir cria

AjusteSX1(cPerg)
If Pergunte(cPerg,.T.)
	Processa({|| GeraRel() },"Processando...","Selecionando Registros... ")
EndIf

aCabec := {"EMPRESA","FILIAL","DATA","TIPO_E2","TIPO_E5","PREFIXO","TITULO","PARCELA","FORNECEDOR","LOJA",;
	       "NOME_FORN","NATUREZA","NAT_DESP","HISTORICO","SEGMTO","CCUSTO","VALOR","NATUREZ_RATEIO",;
	       "SEGRAT","CCRAT","RATEIO_NAT","SEGRAT_1","CCRAT_1","RATEIO_SEGMTO"}

MsgRun( "Aguarde...." , "Gerando Planilha Excel no Client" , { ||DlgToExcel({ {"ARRAY", "DESPESAS", aCabec, aDados} }) } )

Return


Static Function GeraRel()  

Local cEol 		:= CHR(10) + CHR(13)
Local cSql 		:= "" 
Local aEmp 		:= {}                                                                                                                                                  
Local cEmp		:= ""
Local cCod      := ""


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณAbre a tabela de empresas do sistema e adiciona o c๓digo da empresa no aEmpณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()
       
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, SM0->M0_CODIGO)
	EndIf
	SM0->(dbSkip())
End

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณEfetua a montagem do comando SQL que vai fazer a busca das informa็๕es ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
For i := 1 to Len(aEmp)

cQuery := " SELECT DISTINCT '" + aEmp[i] + "' AS EMPRESA, ' ' AS RECPAG, E2_FILIAL AS FILIAL, TO_DATE(E2_EMIS1,'YYYYMMDD') AS DATA, E2_TIPO AS TIPO_E2, '-' AS TIPO_E5, E2_PREFIXO AS PREFIXO, E2_NUM AS TITULO, "
cQuery += "        E2_PARCELA AS PARCELA, E2_FORNECE AS FORNECEDOR, E2_LOJA AS LOJA, E2_NOMFOR AS NOME_FORN, E2_NATUREZ||'-'||ED_DESCRIC AS NATUREZA, "
cQuery += "        CASE WHEN ED_NATDESP = '1' THEN 'Sim' ELSE 'Nao' END AS NAT_DESP,"
cQuery += "        E2_HIST AS HISTORICO, "
cQuery += "        E2_CLVLDB AS SEGMTO, E2_CCD AS CCUSTO,"
cQuery += "        E2_VLCRUZ AS VALOR, EZ_NATUREZ AS NATUREZ_RATEIO, EZ_CLVL AS SEGRAT, EZ_CCUSTO AS CCRAT, "
cQuery += "        CASE WHEN EZ_PERC > 0 THEN"
cQuery += "        ROUND((EZ_PERC * E2_VLCRUZ)/(SELECT COUNT(DISTINCT EZ_NATUREZ) FROM SEZ" + aEmp[i] + "0 WHERE EZ_FILIAL = E2_FILIAL AND EZ_NUM = E2_NUM AND EZ_CLIFOR = E2_FORNECE AND EZ_LOJA = E2_LOJA AND EZ_PREFIXO = E2_PREFIXO AND EZ_PARCELA = E2_PARCELA AND EZ_TIPO = E2_TIPO AND EZ_RECPAG = 'P' AND SEZ.D_E_L_E_T_ <> '*') ,4) "
cQuery += "        ELSE NULL"
cQuery += "        END AS RATEIO_NAT,"
cQuery += "        DE_CLVL AS SEGRAT_1, DE_CC AS CCRAT_1,DE_ITEMNF,  "
cQuery += "        ROUND((D1_TOTAL/(SELECT SUM(D1_TOTAL) FROM SD1" + aEmp[i] + "0 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_FILIAL = DE_FILIAL AND D1_SERIE = DE_SERIE"
cQuery += "                                             AND D1_DOC = DE_DOC AND DE_FORNECE = D1_FORNECE AND DE_LOJA = D1_LOJA)*DE_PERC/100)*E2_VLCRUZ,4) AS RATEIO_SEGMTO"
cQuery += "   FROM SE2" + aEmp[i] + "0 E2 "
cQuery += "   LEFT JOIN SEDCMP SED ON (SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = E2_NATUREZ)"
cQuery += "   LEFT JOIN SDE" + aEmp[i] + "0 SDE ON (DE_FILIAL = E2_FILIAL AND DE_DOC = E2_NUM AND DE_SERIE = E2_PREFIXO AND DE_FORNECE = E2_FORNECE AND DE_LOJA = E2_LOJA AND SDE.D_E_L_E_T_ <> '*')"
cQuery += "   LEFT JOIN SEZ" + aEmp[i] + "0 SEZ ON (DE_FILIAL IS NULL AND EZ_FILIAL = E2_FILIAL AND EZ_NUM = E2_NUM AND EZ_CLIFOR = E2_FORNECE AND EZ_LOJA = E2_LOJA AND EZ_PREFIXO = E2_PREFIXO AND EZ_PARCELA = E2_PARCELA AND EZ_TIPO = E2_TIPO AND EZ_RECPAG = 'P' AND SEZ.D_E_L_E_T_ <> '*' AND EZ_IDENT= '1' )"
cQuery += "   LEFT JOIN SD1" + aEmp[i] + "0 D1 ON (DE_FILIAL = D1_FILIAL AND DE_DOC = D1_DOC AND DE_SERIE = D1_SERIE AND DE_FORNECE = D1_FORNECE AND DE_LOJA = D1_LOJA AND DE_ITEMNF = D1_ITEM AND D1.D_E_L_E_T_ <> '*')"
cQuery += "  WHERE E2.D_E_L_E_T_ <> '*'"
cQuery += "    AND E2_EMIS1 BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' " 
cQuery += "    AND E2_ORIGEM <> 'FINA376'"
cQuery += "    AND E2_FATURA <> 'NOTFAT' "
cQuery += "    AND ED_NATDESP = '1'" //SOMENTE NATUREZA DE DESPESA
cQuery += "  UNION ALL"
cQuery += " SELECT '" + aEmp[i] + "' AS EMPRESA, E5_RECPAG AS RECPAG, E5_FILIAL AS FILIAL, TO_DATE(E5_DATA,'YYYYMMDD') AS DATA, '-' AS TIPO_E2, E5_TIPODOC AS TIPO_E5, E5_PREFIXO AS PREFIXO, E5_NUMERO AS TITULO, "
cQuery += "        E5_PARCELA AS PARCELA, E5_CLIFOR AS FORNECEDOR, E5_LOJA AS LOJA, E5_BENEF AS NOME_FORN, E5_NATUREZ||'-'||ED_DESCRIC AS NATUREZA, 
cQuery += "        CASE WHEN ED_NATDESP = '1' THEN 'Sim' ELSE 'Nao' END AS NAT_DESP,"
cQuery += "        E5_HISTOR AS HISTORICO, "
cQuery += "        CASE WHEN E5_CLVLDB <> ' ' THEN E5_CLVLDB ELSE E5_CLVLCR END AS SEGMTO, "
cQuery += "        CASE WHEN E5_CCD <> ' ' THEN E5_CCD ELSE E5_CCC END AS CCUSTO,"
cQuery += "        E5_VALOR AS VALOR, EZ_NATUREZ AS NATUREZ_RATEIO, EZ_CLVL AS SEGRAT, EZ_CCUSTO AS CCRAT, "
cQuery += "        CASE WHEN EZ_PERC > 0 THEN"
cQuery += "        ROUND((EZ_PERC * E5_VALOR)/(SELECT COUNT(DISTINCT EZ_NATUREZ) FROM SEZ" + aEmp[i] + "0 WHERE E5_FORNECE <> ' ' AND DE_FILIAL IS NULL AND EZ_FILIAL = E5_FILIAL AND EZ_NUM = E5_NUMERO AND EZ_CLIFOR = E5_CLIFOR AND EZ_LOJA = E5_LOJA AND EZ_PREFIXO = E5_PREFIXO AND EZ_PARCELA = E5_PARCELA AND EZ_TIPO = E5_TIPO AND EZ_RECPAG = E5_RECPAG AND SEZ.D_E_L_E_T_ <> '*') ,4) "
cQuery += "        ELSE NULL"
cQuery += "        END AS RATEIO_NAT,"
cQuery += "        DE_CLVL AS SEGRAT_1, DE_CC AS CCRAT_1,DE_ITEMNF,  "
cQuery += "        ROUND((D1_TOTAL/(SELECT SUM(D1_TOTAL) FROM SD1" + aEmp[i] + "0 D1 WHERE D1.D_E_L_E_T_ <> '*' AND D1_FILIAL = DE_FILIAL AND D1_SERIE = DE_SERIE"
cQuery += "                                             AND D1_DOC = DE_DOC AND DE_FORNECE = D1_FORNECE AND DE_LOJA = D1_LOJA)*DE_PERC/100)*E5_VALOR,4) AS RATEIO_SEGMTO"
cQuery += "   FROM SE5" + aEmp[i] + "0 E5 "
cQuery += "   LEFT JOIN SEDCMP SED ON (SED.D_E_L_E_T_ <> '*' AND ED_CODIGO = E5_NATUREZ)"
cQuery += "   LEFT JOIN SDE" + aEmp[i] + "0 SDE ON (E5_FORNECE <> ' ' AND DE_FILIAL = E5_FILIAL AND DE_DOC = E5_NUMERO AND DE_SERIE = E5_PREFIXO AND DE_FORNECE = E5_CLIFOR AND DE_LOJA = E5_LOJA AND SDE.D_E_L_E_T_ <> '*')"
cQuery += "   LEFT JOIN SEZ" + aEmp[i] + "0 SEZ ON (E5_FORNECE <> ' ' AND DE_FILIAL IS NULL AND EZ_FILIAL = E5_FILIAL AND EZ_NUM = E5_NUMERO AND EZ_CLIFOR = E5_CLIFOR AND EZ_LOJA = E5_LOJA AND EZ_PREFIXO = E5_PREFIXO AND EZ_PARCELA = E5_PARCELA AND EZ_TIPO = E5_TIPO AND EZ_RECPAG = E5_RECPAG AND SEZ.D_E_L_E_T_ <> '*' AND EZ_IDENT= '1')"
cQuery += "   LEFT JOIN SD1" + aEmp[i] + "0 D1 ON (E5_FORNECE <> ' ' AND DE_FILIAL = D1_FILIAL AND DE_DOC = D1_DOC AND DE_SERIE = D1_SERIE AND DE_FORNECE = D1_FORNECE AND DE_LOJA = D1_LOJA AND DE_ITEMNF = D1_ITEM AND D1.D_E_L_E_T_ <> '*')"
cQuery += "  WHERE E5.D_E_L_E_T_ <> '*'"
cQuery += "    AND E5_DATA BETWEEN '"+ DtoS(MV_PAR01) +"' AND '"+ DtoS(MV_PAR02) +"' " 
cQuery += "    AND E5_SITUACA <> 'C' "
cQuery += "    AND E5_NUMCHEQ <> '%*' "
cQuery += "    AND (
cQuery += "         (E5_MOEDA = 'M1' AND ED_NATDESP = '1') "
cQuery += "          OR (E5_CLIENTE <> ' ' AND ED_NATDESP = '1') " //SE FOR CR E NAT DESP 
cQuery += "          OR E5_TIPODOC IN ('DC','JR','CM','MT','DB')"
cQuery += "         )"
TCQUERY cQuery NEW ALIAS "TMPDSP"

ProcRegua(TMPDSP->(RecCount()))	

DO WHILE TMPDSP->(!EOF())
	
	cMsgProc := ALLTRIM("Empresa: "+TMPDSP->EMPRESA+" Filial: "+TMPDSP->FILIAL)
	IncProc(OemToAnsi(cMsgProc))   
		
	aAdd(aDados,{	TMPDSP->EMPRESA,;
					TMPDSP->FILIAL,;	
					TMPDSP->DATA,;
					TMPDSP->TIPO_E2,;
					TMPDSP->TIPO_E5,;
					TMPDSP->PREFIXO,;	
					TMPDSP->TITULO,;	
					TMPDSP->PARCELA,;
					TMPDSP->FORNECEDOR,;	
					TMPDSP->LOJA,;	
					TMPDSP->NOME_FORN,;	
					TMPDSP->NATUREZA,;	
					TMPDSP->NAT_DESP,;
					TMPDSP->HISTORICO,;	
					TMPDSP->SEGMTO+'-'+ALLTRIM(Posicione("CTH", 01, xFilial("CTH") + TMPDSP->SEGMTO, "CTH_DESC01")),;
					TMPDSP->CCUSTO+'-'+ALLTRIM(Posicione("CTT",1,xFilial("CTT")+TMPDSP->CCUSTO,"CTT_DESC01")),;	
					IIF(      (TMPDSP->RECPAG == 'P' .AND. ALLTRIM(TMPDSP->TIPO_E5)=='DC') ;
					     .OR. (TMPDSP->RECPAG == 'R' .AND. ALLTRIM(TMPDSP->TIPO_E5)<>'DC');
					     .OR. (ALLTRIM(TMPDSP->TIPO_E2) $ 'NDF/PA/'), TMPDSP->VALOR, TMPDSP->VALOR*-1),;	
					TMPDSP->NATUREZ_RATEIO,;	
					TMPDSP->SEGRAT+'-'+ALLTRIM(Posicione("CTH", 01, xFilial("CTH") + TMPDSP->SEGRAT, "CTH_DESC01")),;	
					TMPDSP->CCRAT+'-'+ALLTRIM(Posicione("CTT",1,xFilial("CTT")+TMPDSP->CCRAT,"CTT_DESC01")),;	
					IIF(      (TMPDSP->RECPAG == 'P' .AND. ALLTRIM(TMPDSP->TIPO_E5)=='DC') ;
					     .OR. (TMPDSP->RECPAG == 'R' .AND. ALLTRIM(TMPDSP->TIPO_E5)<>'DC');
					     .OR. (ALLTRIM(TMPDSP->TIPO_E2) $ 'NDF/PA/'), TMPDSP->RATEIO_NAT, TMPDSP->RATEIO_NAT*-1)	,;
					TMPDSP->SEGRAT_1+'-'+ALLTRIM(Posicione("CTH", 01, xFilial("CTH") + TMPDSP->SEGRAT_1, "CTH_DESC01")),;	
					TMPDSP->CCRAT_1+'-'+ALLTRIM(Posicione("CTT",1,xFilial("CTT")+TMPDSP->CCRAT_1,"CTT_DESC01")),;	
					IIF(      (TMPDSP->RECPAG == 'P' .AND. ALLTRIM(TMPDSP->TIPO_E5)=='DC') ;
					     .OR. (TMPDSP->RECPAG == 'R' .AND. ALLTRIM(TMPDSP->TIPO_E5)<>'DC');
					     .OR. (ALLTRIM(TMPDSP->TIPO_E2) $ 'NDF/PA/'), TMPDSP->RATEIO_SEGMTO, TMPDSP->RATEIO_SEGMTO*-1)})                                                                                   

	TMPDSP->(dbSkip())
ENDDO										                                               			
TMPDSP->(dbCloseArea())

Next i                                        

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVLDPERG  บAutor  ณGustavo Lattmann     บ Data ณ  07/03/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pelo parโmetros informados pelo usuแrio  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณProtheus                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function VldPerg(cPerg)

PutSX1(cPerg,"01","Data de "	,"Data de "   ,"Data de "  ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR01","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")
PutSX1(cPerg,"02","Data at้ "	,"Data at้ "  ,"Data at้ " ,"MV_CH1","D",008,0,0,"G","","","","","MV_PAR02","","","","","","","","","", "", "", "", "", "", "", "", {"","","",""}, {"","","",""}, {"","",""}, "")

Return

