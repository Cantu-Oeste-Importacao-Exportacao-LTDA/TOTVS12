#include "PROTHEUS.CH"
#include "RWMAKE.CH"  
#include "topconn.ch"

User Function ExpFlCx()
Private cPerg      := "ExpFlCx"
Private oGeraTxt 
Private cString := "SE1" 
Private cString := "SE2"
 
AjustaPerg(cPerg)
 dbSelectArea("SE5")
 dbSetOrder(1)  
  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo CSV")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo CSV, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SE1, SE2 e SE5                                              "

@ 70,085 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraCsv()})
@ 70,115 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,144 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

// Cria as perguntas no dicionário de dados
Static Function AjustaPerg(cPerg)
PutSx1(cPerg,"01","Emissao Inicial ?","Emissao Inicial ?","Emissao Inicial ?", "mv_emi", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Emissao Final ?","Emissao Final ?","Emissao Final ?", "mv_emf", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Vencimento Inicial ?","Vencimento Inicial ?","Vencimento Inicial ?", "mv_vei", "D", 10, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Vencimento Final ?","Vencimento Final ?","Vencimento Final ?", "mv_vef", "D", 10, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Data de Baixa ?","Data de Baixa ?","Data de Baixa ?", "mv_dtb", "D", 10, 0, ,"G", "", "", "", "","MV_PAR05")

Return Nil                
 
Static Function OkGeraCsv()
local oExcel 
Local cArq
Local nArq
Local cPath
Local cTipo := "Arquivos CSV | *.csv"
Local cSql := "" 

Local aDADOSEMP := {}
Local nPos := 0                  
aAreaSM0 := SM0->(GetArea())
SM0->(dbSetOrder(1))
SM0->(dbGoTop())

While ! SM0->(EOF())
	nPos := aScan(aDadosEmp, {|x| x[1] == SM0->M0_CODIGO})
	if (nPos = 0)
		if !(SM0->M0_CODFIL $ "00/99")	
		    aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL} )
		EndIf
	EndIf
	SM0->(dbSkip())
Enddo                                    
RestArea(aAreaSM0)     

cSql:= " SELECT '"+SM0->M0_NOME+"' AS EMPRESA,'"+SM0->M0_CODIGO+"' AS CODEMP," +CRLF
cSql+= " SE1.E1_FILIAL,SE1.E1_TIPO as TIPO,SE1.E1_NUM as NF,SE1.E1_EMISSAO AS EMISSAO,SE1.E1_VENCREA AS VENCIMENTO,SE1.E1_SERIE, "+CRLF
cSql+= " SE1.E1_IRRF AS IRRF, SE1.E1_ISS AS ISS_RETIDO, SE1.E1_INSS AS INSS_RETIDO, SE1.E1_PIS AS PIS_RETIDO,SE1.E1_CLIENTE,SE1.E1_PARCELA, "+CRLF
cSql+= " SE1.E1_COFINS , SE1.E1_CSLL AS CSLL_RETIDO,SE1.E1_PORTADO AS PORTADO,SE1.E1_AGEDEP AS AGEDEP,SE1.E1_CONTA AS CONTA,SE1.E1_CONTRAT AS CONTRATO, "+CRLF                                                                  
cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA') THEN SE1.E1_VALOR * -1  ELSE SE1.E1_VALOR END AS VR_BRUTO, "+CRLF                                           

cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA') THEN SE1.E1_VALOR * -1  ELSE "+CRLF

cSql+= " 	SE1.E1_VALOR-SE1.E1_IRRF-SE1.E1_ISS-SE1.E1_INSS-SE1.E1_PIS-SE1.E1_COFINS-SE1.E1_CSLL END AS VR_LIQUIDO, "+CRLF

cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA','IS-','IR-','IN-','PI-','CF-','CS-') THEN SE1.E1_SALDO * -1  ELSE SE1.E1_SALDO END AS SALDO, "+CRLF

/*cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA') THEN SE1.E1_SALDO * -1  ELSE ( "+CRLF
cSql+= " SE1.E1_SALDO -  case when(SELECT SUM(E1_SALDO) FROM "+RetSqlName("SE1")+" ABC "+CRLF   
cSql+= " WHERE ABC.E1_FILIAL=SE1.E1_FILIAL AND ABC.E1_PREFIXO=SE1.E1_PREFIXO AND ABC.E1_NUM=SE1.E1_NUM  AND "+CRLF
cSql+= " ABC.E1_PARCELA=SE1.E1_PARCELA AND  E1_TIPO IN ('IS-','IR-','IN-','PI-','CF-','CS-')AND ABC.D_E_L_E_T_ <>'*' )is null then 0 "+CRLF
cSql+= " else(SELECT SUM(E1_SALDO) FROM "+RetSqlName("SE1")+" ABC WHERE ABC.E1_FILIAL=SE1.E1_FILIAL AND ABC.E1_PREFIXO=SE1.E1_PREFIXO AND ABC.E1_NUM=SE1.E1_NUM  AND "+CRLF
cSql+= " ABC.E1_PARCELA=SE1.E1_PARCELA AND E1_TIPO IN ('IS-','IR-','IN-','PI-','CF-','CS-') AND ABC.D_E_L_E_T_ <>'*') end) "+CRLF
cSql+= " end as SALDO , "+CRLF*/

cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA','IS-','IR-','IN-','PI-','CF-','CS-') THEN SE1.E1_SALDO * -1  ELSE SE1.E1_SALDO END AS SLDPRINC, "+CRLF

/*cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA') THEN SE1.E1_VALOR * 1   ELSE ( "+CRLF

//RETIRA OS IMPOSTOS DO VALOR
cSql+= " SE1.E1_VALOR -  case when(SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" ABC WHERE ABC.E1_FILIAL=SE1.E1_FILIAL AND ABC.E1_PREFIXO=SE1.E1_PREFIXO AND ABC.E1_NUM=SE1.E1_NUM  AND  "+CRLF
cSql+= " ABC.E1_PARCELA=SE1.E1_PARCELA AND E1_TIPO IN ('IS-','IR-','IN-','PI-','CF-','CS-')AND ABC.D_E_L_E_T_ <>'*' )is null then 0 "+CRLF
cSql+= " else(SELECT SUM(E1_VALOR) FROM "+RetSqlName("SE1")+" ABC WHERE ABC.E1_FILIAL=SE1.E1_FILIAL AND ABC.E1_PREFIXO=SE1.E1_PREFIXO AND ABC.E1_NUM=SE1.E1_NUM AND ABC.E1_PARCELA=SE1.E1_PARCELA AND E1_TIPO IN ('IS-','IR-','IN-','PI-','CF-','CS-') AND ABC.D_E_L_E_T_ <>'*') end) "+CRLF
cSql+= " end - "+CRLF 

//REGRA DA NORDESTE
cSql+= " CASE WHEN SE1.E1_TIPO In ('NCC','RA') THEN ((case when(SELECT SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF
cSql+= " CASE WHEN E5_MOTBX IN ('CMP')THEN  E5_FILORIG ELSE E5_FILIAL END = SE1.E1_FILIAL AND "+CRLF
cSql+= " E5_RECPAG =CASE WHEN E5_MOTBX IN ('CMP')THEN  'R' ELSE 'P' END   AND "+CRLF
cSql+= " E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM  AND "+CRLF 
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND E5_SITUACA<>'C' AND E5_TIPODOC NOT IN ('JR','MT','DC') ) is null then 0 "+CRLF
cSql+= " else(SELECT SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF
cSql+= " CASE WHEN E5_MOTBX IN ('CMP')THEN  E5_FILORIG ELSE E5_FILIAL END = SE1.E1_FILIAL AND "+CRLF                        
cSql+= " E5_RECPAG =CASE WHEN E5_MOTBX IN ('CMP')THEN  'R' ELSE 'P' END   AND "+CRLF                                                                             
cSql+= " E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM   AND "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE  AND E5_SITUACA<>'C' AND E5_TIPODOC NOT IN ('JR','MT','DC') ) end) "+CRLF

 //ESTORNO
cSql+= " - (case when(SELECT SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF 
cSql+= " CASE WHEN E5_MOTBX IN ('CMP')THEN  E5_FILORIG ELSE E5_FILIAL END = SE1.E1_FILIAL AND "+CRLF
cSql+= " E5_RECPAG =CASE WHEN E5_MOTBX IN ('CMP')THEN 'P' ELSE 'R' END   AND "+CRLF
cSql+= " E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM  AND  "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND E5_TIPODOC='ES' AND E5_SITUACA<>'C'  AND E5_TIPODOC NOT IN ('JR','MT','DC') ) is null then 0 "+CRLF
cSql+= " else (SELECT SUM(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF
cSql+= " CASE WHEN E5_MOTBX IN ('CMP')THEN  E5_FILORIG ELSE E5_FILIAL END = SE1.E1_FILIAL AND "+CRLF                        
cSql+= " E5_RECPAG =CASE WHEN E5_MOTBX IN ('CMP')THEN  'P' ELSE 'R' END   AND "+CRLF                                                                              
cSql+= " E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM   AND "+CRLF 
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE  AND E5_TIPODOC='ES' AND E5_SITUACA<>'C' AND E5_TIPODOC NOT IN ('JR','MT','DC') ) end)) "+CRLF
cSql+= " else " +CRLF// 0   END  AS 'SLDPRINC'                                
cSql+= " (case when (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= " E5_FILIAL=SE1.E1_FILIAL  AND E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM  AND  "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND "+CRLF
cSql+= " E5_RECPAG='R'  AND E5_SITUACA<>'C'  AND E5_TIPODOC NOT IN ('JR','MT','DC') ) is null then 0 "+CRLF
cSql+= " else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+"  "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= " E5_FILIAL=SE1.E1_FILIAL   AND E5_PREFIXO=SE1.E1_PREFIXO AND E5_NUMERO=SE1.E1_NUM   AND  "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND      "+CRLF
cSql+= " E5_RECPAG='R'  AND E5_SITUACA<>'C'  AND E5_TIPODOC NOT IN ('JR','MT','DC') ) end - "+CRLF
cSql+= " case when (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO)FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= " E5_FILIAL=SE1.E1_FILIAL   AND E5_PREFIXO=SE1.E1_PREFIXO AND  E5_NUMERO=SE1.E1_NUM  AND  "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND      "+CRLF
cSql+= " E5_RECPAG='P'  AND E5_SITUACA<>'C'  AND E5_TIPODOC NOT IN ('JR','MT','DC') )  is null then 0 "+CRLF
cSql+= " else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO)FROM "+RetSqlName("SE5")+"  "+CRLF 
cSql+= " WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF
cSql+= " E5_FILIAL=SE1.E1_FILIAL   AND  E5_PREFIXO=SE1.E1_PREFIXO AND  E5_NUMERO=SE1.E1_NUM  AND "+CRLF
cSql+= " E5_PARCELA=SE1.E1_PARCELA AND E5_TIPO=SE1.E1_TIPO AND E5_CLIENTE = SE1.E1_CLIENTE AND      "+CRLF
cSql+= " E5_RECPAG='P'  AND E5_SITUACA<>'C'  AND E5_TIPODOC NOT IN ('JR','MT','DC') ) end)"+CRLF
cSql+= " end AS SLDPRINC  , "+CRLF*/

cSql+= " SA1.A1_NOME AS RAZAO_SOCIAL,SA1.A1_CGC AS CGC, SE1.E1_NATUREZ AS COD_NATUREZA, SED.ED_CODIGO AS NATUREZA,SX5.X5_DESCRI AS SITUACAO, "+CRLF
cSql+= " TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') AS IDADE ,"+CRLF
cSql+= " CASE"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') < 0 THEN '0- A VENCER'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') <= 5 THEN '1- ATE 05 DIAS'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') <= 30 THEN '2- DE 06 A 30 DIAS'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') <= 60 THEN '3- DE 31 A 60 DIAS'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') <= 90 THEN '4- DE 61 A 90 DIAS'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') > 90 THEN  '5- ACIMA DE 90 DIAS'"+CRLF
cSql+= " WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE1.E1_VENCTO,'YYYYMMDD') > 180 THEN '6- ACIMA DE 180 DIAS'"+CRLF
cSql+= " ELSE 'VERIFICAR' END AS STATUS, "+CRLF
cSql+= " SE1.E1_CLVLDB, SE1.E1_CLVLCR, SE1.E1_CCD, SE1.E1_CCC "+CRLF
cSql+= " FROM "+RetSqlName("SE1")+" SE1 ,"+CRLF
cSql+= " "+RetSqlName("SX5")+" SX5 ,"+CRLF
cSql+= RetSqlName("SED")+" SED, "+RetSqlName("SA1") +" SA1 "+CRLF
cSql+= " WHERE SE1.E1_NATUREZ = SED.ED_CODIGO AND SE1.E1_CLIENTE = SA1.A1_COD AND  SE1.E1_LOJA = SA1.A1_LOJA AND "+CRLF
cSql+= " SX5.X5_CHAVE = SE1.E1_SITUACA  AND  SE1.E1_TIPO In ('BOL','CC','CH','CN','CR','DH','DP','EF','FI','FT','NCC','NFF','NDC','NCI','NF','NP','R$','RA','RC','TF','VA','VL') AND "+CRLF
cSql+= " SX5.X5_FILIAL = SE1.E1_FILIAL AND SE1.E1_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "+CRLF
cSql+= " SE1.E1_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND "+CRLF
cSql+= " SE1.E1_MOTIVO <> 'DEVOLUCAO' AND  SX5.X5_TABELA='07' AND E1_SALDO >= case when (E1_BAIXA > '"+DTOS(MV_PAR05)+"') THEN 0.0 else  0.1 end AND "+CRLF
cSql+= " SX5.D_E_L_E_T_=' ' AND SED.D_E_L_E_T_=' ' AND SA1.D_E_L_E_T_=' ' AND SE1.D_E_L_E_T_=' '"+CRLF

MemoWrite("\sql_rec.txt",cSql)
  
TcQuery cSql new alias "SE1TMP" 
 
//SE2 ************************************************************************************************
 
cSql:= " SELECT '"+SM0->M0_NOME+"' AS EMPRESA,'"+SM0->M0_CODIGO+"' AS CODEMP, " +CRLF
cSql+= "       SE2.E2_FILIAL,SE2.E2_TIPO as TIPO,SE2.E2_NUM as NF,SE2.E2_EMISSAO AS EMISSAO,SE2.E2_VENCREA AS VENCIMENTO, "+CRLF
cSql+= "       SE2.E2_IRRF AS IRRF, SE2.E2_ISS AS ISS_RETIDO, SE2.E2_INSS AS INSS_RETIDO, SE2.E2_PIS AS PIS_RETIDO, "+CRLF
cSql+= "       SE2.E2_COFINS , SE2.E2_CSLL AS CSLL_RETIDO," +CRLF
cSql+= "       CASE WHEN SE2.E2_TIPO In ('NDF','PA') THEN SE2.E2_VALOR * -1  ELSE SE2.E2_VALOR END AS VR_BRUTO, "+CRLF
cSql+= "       CASE WHEN SE2.E2_TIPO In ('NDF','PA') THEN SE2.E2_VALOR * -1  ELSE SE2.E2_VALOR+SE2.E2_IRRF+SE2.E2_ISS+SE2.E2_INSS+SE2.E2_PIS+SE2.E2_COFINS+SE2.E2_CSLL END AS VR_LIQUIDO, "+CRLF
cSql+= "       CASE WHEN SE2.E2_TIPO In ('NDF','PA') THEN SE2.E2_SALDO * -1  ELSE SE2.E2_SALDO end as SALDO ,"+CRLF

                // REGRA DA NORDESTE
/*
cSql+= "       SE2.E2_VALOR -  CASE WHEN SE2.E2_TIPO In ('NDF','PA') THEN ((case when  (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= "               WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "               E5_FILIAL=SE2.E2_FILIAL  AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM  AND  "+CRLF
cSql+= "               E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND E5_RECPAG='R' AND E5_SITUACA <>'C') is null then 0 "+CRLF
cSql+= "               else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM SE5"+SM0->M0_CODIGO+"0  "+CRLF
cSql+= "               WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "               E5_FILIAL=SE2.E2_FILIAL   AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM   AND  "+CRLF
cSql+= "               E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE  AND E5_RECPAG='R' AND E5_SITUACA <>'C') end) "+CRLF

                                                             //ESTORNO

cSql+= "               - (case when  (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= "               WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "               E5_FILIAL=SE2.E2_FILIAL  AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM  AND  "+CRLF
cSql+= "               E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND E5_RECPAG='P' AND E5_SITUACA <>'C' AND E5_TIPODOC<>'PA') is null then 0 "+CRLF
cSql+= "               else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+"  "+CRLF
cSql+= "               WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "               E5_FILIAL=SE2.E2_FILIAL   AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM   AND  "+CRLF
cSql+= "               E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE  AND E5_RECPAG='P' AND E5_SITUACA <>'C' AND  E5_TIPODOC<>'PA') end)* -1) "+CRLF
cSql+= "               ELSE "+CRLF
                //SEGUE O PADRAO

cSql+= "               (case when (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= " 							WHERE D_E_L_E_T_ <> '*' AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "              E5_FILIAL=SE2.E2_FILIAL  AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM  AND  "+CRLF
cSql+= "              E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND "+CRLF
cSql+= "              E2_TIPO NOT IN ('INS','TX','IR-','ISS','IRF' ) AND E5_RECPAG='P' AND E5_SITUACA <>'C') is null then 0"+CRLF
cSql+= "              else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO) FROM "+RetSqlName("SE5")+"  "+CRLF
cSql+= "              WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "              E5_FILIAL=SE2.E2_FILIAL   AND E5_PREFIXO=SE2.E2_PREFIXO AND E5_NUMERO=SE2.E2_NUM   AND  "+CRLF
cSql+= "              E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND      "+CRLF
cSql+= "              E2_TIPO NOT IN ('INS','TX','IR-','ISS','IRF' ) AND E5_RECPAG='P'  AND E5_SITUACA <>'C') end -"+CRLF
cSql+= "              case when (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO)FROM "+RetSqlName("SE5")+" "+CRLF
cSql+= "              WHERE D_E_L_E_T_ <> '*'  AND E5_DATA <='"+DTOS(MV_PAR05)+"' AND  "+CRLF
cSql+= "            E5_FILIAL=SE2.E2_FILIAL   AND E5_PREFIXO=SE2.E2_PREFIXO AND  E5_NUMERO=SE2.E2_NUM  AND  "+CRLF
cSql+= "            E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND      "+CRLF
cSql+= "            E2_TIPO NOT IN ('INS','TX','IR-','ISS','IRF' ) AND E5_RECPAG='R'AND E5_SITUACA <>'C')  is null then 0 "+CRLF
cSql+= "            else (SELECT SUM(E5_VALOR- E5_VLMULTA -E5_VLJUROS + E5_VLDESCO)FROM "+RetSqlName("SE5")+"  "+CRLF
cSql+= "            WHERE D_E_L_E_T_ <> '*'  AND  E5_DATA <='"+DTOS(MV_PAR05)+"' AND "+CRLF
cSql+= "            E5_FILIAL=SE2.E2_FILIAL   AND  E5_PREFIXO=SE2.E2_PREFIXO AND  E5_NUMERO=SE2.E2_NUM  AND "+CRLF
cSql+= "            E5_PARCELA=SE2.E2_PARCELA AND E5_TIPO=SE2.E2_TIPO AND E5_CLIFOR = SE2.E2_FORNECE AND      "+CRLF
cSql+= "            E2_TIPO NOT IN ('INS','TX','IR-','ISS','IRF' ) AND E5_RECPAG='R' AND E5_SITUACA <>'C') end)"+CRLF
cSql+= "            end   AS SLDPRINC  , "+CRLF */

cSql+= "       CASE WHEN SE2.E2_TIPO In ('NDF','PA') THEN SE2.E2_SALDO * -1  ELSE SE2.E2_SALDO END as SLDPRINC ,"+CRLF
cSql+= "       SA2.A2_NOME AS RAZAO_SOCIAL,SA2.A2_CGC AS CGC, SE2.E2_NATUREZ AS COD_NATUREZA, SED.ED_CODIGO AS NATUREZA, "+CRLF
cSql+= "       TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') AS IDADE ,"+CRLF
cSql+= "       CASE"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') < 0 THEN '0- A VENCER'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') <= 5 THEN '1- ATÉ 05 DIAS'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') <= 30 THEN '2- DE 06 A 30 DIAS'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') <= 60 THEN '3- DE 31 A 60 DIAS'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') <= 90 THEN '4- DE 61 A 90 DIAS'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') > 90 THEN  '5- ACIMA DE 90 DIAS'"+CRLF
cSql+= "       WHEN TO_DATE('"+DTOS(MV_PAR05)+"','YYYYMMDD') - TO_DATE(SE2.E2_VENCTO,'YYYYMMDD') > 180 THEN '6- ACIMA DE 180 DIAS'"+CRLF
cSql+= "       ELSE 'VERIFICAR' END AS STATUS, "+CRLF
cSql+= "       SE2.E2_CLVLDB, SE2.E2_CLVLCR, SE2.E2_CCD, SE2.E2_CCC "+CRLF
cSql+= " FROM  "+RetSqlName("SE2")+" SE2 ,"+CRLF
cSql+= "       "+RetSqlName("SED")+" SED, "+RetSqlName("SA2")+" SA2"+CRLF
cSql+= " WHERE SE2.E2_NATUREZ = SED.ED_CODIGO AND SE2.E2_FORNECE = SA2.A2_COD AND  SE2.E2_LOJA = SA2.A2_LOJA AND "+CRLF
cSql+= "       SE2.E2_TIPO IN ('IFE','COF','IMU','TXA','IES','RES','FER','FOL','BOL','CC','CH','CN','CR','DH','DP','EF','FI','FT','NCC','NCI','NF','NP','R$','RA','RC','TF','VA','VL','PA','PF') AND"+CRLF
cSql+= "       SE2.E2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND "+CRLF
cSql+= "       SE2.E2_VENCREA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' AND "+CRLF
cSql+= "       SE2.E2_MOTIVO <> 'DEVOLUCAO' AND E2_SALDO >= case when (E2_BAIXA > '"+DTOS(MV_PAR05)+"') THEN 0.0 else  0.1 end AND "+CRLF
cSql+= "       SED.D_E_L_E_T_=' ' AND SA2.D_E_L_E_T_=' ' AND SE2.D_E_L_E_T_=' ' "+CRLF

MemoWrite("\sql_pag.txt",cSql)

TcQuery cSql new alias "SE2TMP"  

ProcRegua(LastRec())

cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo a receber", 0,"",.F.)
nArq  := FCreate(cPath)
If nArq == -1 
 
 SE1TMP->(dbCloseArea())
 SE2TMP->(dbCloseArea()) 
 MsgAlert("Não foi possível criar o arquivo!")
 Return
EndIf 

//Monta os nomes dos campos
nCont := 0
cHeader := ""                                                                                                         
dbSelectArea("SX3")

dbSetOrder(2)

for ncont := 1 to SE1TMP->(fCount())

	// Localizo o campo no sx3
	SX3->(dbSeek(SE1TMP->(FieldName(nCont))))
	
	// adiciono o nome do campo no cHeader
    cNome:= Trim(X3Titulo()) 
    
    if Empty(cNome)
 	  cNome := SE1TMP->(FieldName(nCont))    
    EndIf
    
	cHeader += cNome 
	
	// Controla a separação por ;
	if (nCont != SE1TMP->(fCount()))
		cHeader += ";"
	EndIf
Next nCont
 
FWrite(nArq, cHeader + Chr(13) + Chr(10))

dbSelectArea("SE1TMP")

dbGoTop() 

cConteudo := ""
nGravados := 0
While !SE1TMP->(Eof())  
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")

	// Controla a separação por ";" do SE1		
 	For nCont := 1 to SE1TMP->(fCount())  	    	    
                      
 	  // Converte o valores que são numéricos
 	  if SE1TMP->(FieldName(nCont)) $ "SLDPRINC/SALDO/VR_LIQUIDO/VR_BRUTO/E1_COFINS/CSLL_RETIDO,IRRF/ISS_RETIDO/INSS_RETIDO/PIS_RETIDO/"
 	  	cConteudo += StrTran(cValToChar(SE1TMP->(FieldGet(nCont))), ".", ",")
 	  Elseif SE1TMP->(FieldName(nCont)) $ "EMISSAO/VENCIMENTO"
 	  	cConteudo += dToC(SToD(SE1TMP->(FieldGet(nCont))))
 	  Else
 	  	cConteudo += cValToChar(SE1TMP->(FieldGet(nCont)))
 	  EndIf
 	  	

		if (nCont != SE1TMP->(fCount()))  
			 cConteudo += ";" 
			
		EndIf
	
 	Next nCont 
  
 	FWrite(nArq, cConteudo + Chr(13) + Chr(10))             

 	nGravados++
 	SE1TMP->(dbSkip())
 	SE2TMP->(dbSkip())    
End

FClose(nArq)

SE1TMP->(dbCloseArea())

cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo a pagar", 0,"",.F.)
nArq  := FCreate(cPath)

If nArq == -1 
 
 SE2TMP->(dbCloseArea()) 
 MsgAlert("Não foi possível criar o arquivo!")
 Return
EndIf 

//Monta os nomes dos campos
nCont := 0
cHeader := ""                                                                                                         
dbSelectArea("SX3")

dbSetOrder(2)

for ncont := 1 to SE2TMP->(fCount())

	// Localizo o campo no sx3
	SX3->(dbSeek(SE2TMP->(FieldName(nCont))))
	
	// adiciono o nome do campo no cHeader
    cNome:= Trim(X3Titulo()) 
    
    if Empty(cNome)
 	  cNome := SE2TMP->(FieldName(nCont))    
    EndIf
    
	cHeader += cNome 
	
	// Controla a separação por ;
	if (nCont != SE2TMP->(fCount()))
		cHeader += ";"
	EndIf
Next nCont
 
FWrite(nArq, cHeader + Chr(13) + Chr(10))

dbSelectArea("SE2TMP")
dbGoTop() 

cConteudo := ""
nGravados := 0
While !SE2TMP->(Eof())  
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
 
    //Controle separaçao por ";" do SE2
  	For nCont := 1 to SE2TMP->(fCount())  	    	    
                      
 	  	// Converte o valores que são numéricos
 	  if SE2TMP->(FieldName(nCont)) $ "SLDPRINC/SALDO/VR_LIQUIDO/VR_BRUTO/E2_COFINS/CSLL_RETIDO,IRRF/ISS_RETIDO/INSS_RETIDO/PIS_RETIDO/"
 	  	cConteudo += StrTran(cValToChar(SE2TMP->(FieldGet(nCont))), ".", ",")
 	  Elseif SE2TMP->(FieldName(nCont)) $ "EMISSAO/VENCIMENTO"
 	  	cConteudo += dToC(SToD(SE2TMP->(FieldGet(nCont))))
 	  Else
 	  	cConteudo += cValToChar(SE2TMP->(FieldGet(nCont)))
 	  EndIf

 
		if (nCont != SE2TMP->(fCount()))  
			 cConteudo += ";"
		EndIf
	
 	Next nCont
 			
 	FWrite(nArq, cConteudo + Chr(13) + Chr(10))             

 	nGravados++
 	SE2TMP->(dbSkip())    
End

FClose(nArq)

SE2TMP->(dbCloseArea()) 
     
MsgInfo("Arquivo criado em " + cPath, "Exportação para Excel")
 
Return Nil
