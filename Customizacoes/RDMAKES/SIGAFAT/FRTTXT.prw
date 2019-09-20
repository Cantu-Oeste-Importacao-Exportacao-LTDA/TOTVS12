#Include "RwMake.ch"
#Include "topconn.ch"

User Function FRTTXT()

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Logistica"
Local cPict        := ""
Local titulo       := "Logistica"
Local nLin         := 80
Local Cabec1       := ""
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd         := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 80
Private tamanho    := "P"
Private nomeprog   := "FRTTXT"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "FRTTXT"
Private cPerg      := "FRTTXT"
Private cString    := "SD2"    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

ValidPerg(cPerg)
//wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

ExpExcell(Cabec1,Cabec2,Titulo,nLin)

If nLastKey == 27
	Return
Endif

//SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

Return


Static Function ExpExcell(Cabec1,Cabec2,Titulo,nLin)
Local _cQrySD2:=""
Pergunte(cPerg,.t.)
DbSelectArea("SD2")

/*
_cQrySD2+="SELECT *"
_cQrySD2+=" FROM " + RetSqlName("SF2")+" SF2, "
_cQrySD2+= RetSqlName("SD2")+" SD2, "
_cQrySD2+= RetSqlName("SB1")+" SB1, "
_cQrySD2+= RetSqlName("SA1")+" SA1, "
_cQrySD2+= RetSqlName("SA3")+" SA3  "
_cQrySD2+=" WHERE SF2.D_E_L_E_T_ <> '*' AND SD2.D_E_L_E_T_ <> '*' AND SA1.D_E_L_E_T_ <> '*' AND SB1.D_E_L_E_T_ <> '*' AND SA3.D_E_L_E_T_ <> '*' AND "
_cQrySD2+=" D2_FILIAL = F2_FILIAL AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE AND B1_COD = D2_COD AND "
_cQrySD2+=" A3_COD = F2_VEND1 AND "                                      
_cQrySD2+=" F2_HORA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"' AND F2_FILIAL = '"
_cQrySD2+=xFilial("SF2")+"' "
/*
cArquivo := "c:\SQLNotas.SQL"
nHdl     := fCreate(cArquivo)
cDetalhe := _cQrySD2
Fwrite(nHdl,cDetalhe,Len(cDetalhe))
FClose(nHdl)

If Select("SD2SQL") > 0
	SD2SQL->(DbCloseArea())
Endif

TCQUERY _cQrySD2 NEW ALIAS "SD2SQL"
TCSetField("SD2SQL","DATA_NF","D")
TCSetField("SD2SQL","SAIDA","N",14,2)//TESTE TOTAL
*/


cEmps := SuperGetMv("MV_X_EMPCMP", ,"{}")//GetMV("MV_X_EMPCMP")
aEmps := &cEmps  // Transforma a string em array multidimensional
cSql := "("
If Len(aEmps) = 0
	MsgInfo("Parametro MV_X_EMPCMP não configurado. Verifique")
	Return
Endif
u_WFCalcImp()
for i := 1 to len(aEmps)
	
	cSql += "SELECT C9.C9_PEDIDO, '"+AllTrim(aEmps[i,1])+"' C9_EMPRESA ,C9.C9_FILIAL,C9.C9_PRODUTO,C9.C9_LOTECTL,C9.C9_NFISCAL,C9.C9_X_CARGA, "
	cSql += "C9.C9_SERIENF,C9.C9_CLIENTE, C9.C9_LOJA, C9.C9_X_VLTOT, C5.C5_VEND1,C5.C5_TRANSP, C5.C5_TPFRETE, C9.C9_QTDLIB,C5.C5_DTHRALT, "
	cSql += "C5.C5_EMISSAO, "
	cSql += "(CASE "
	cSql += "	WHEN C5.C5_TRANSP <> '      ' THEN "
	cSql += "		(SELECT A4.A4_NOME FROM "+"SA4CMP"+" A4 "+"WHERE A4.D_E_L_E_T_ <> '*' AND A4.A4_COD = C5.C5_TRANSP) "
	cSql += "	WHEN C5.C5_TRANSP = '      ' THEN "
	cSql += "       'NAO SELECIONADA' "
	cSql += "END) A4_NOME,	"	
	cSql += "A1.A1_NOME, A1.A1_EST, A1.A1_MUN	"		
	cSql += "FROM "+"SC9"+AllTrim(aEmps[i,1])+"0"+" C9, " + "SC5"+AllTrim(aEmps[i,1])+"0"+" C5, SA1CMP A1 "
	cSql += "WHERE C9.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
	cSql += "AND A1.A1_COD = C9.C9_CLIENTE AND A1.A1_LOJA = C9.C9_LOJA "
//		If _cTpCarga <> 'Fracionada'
//			cSql += "AND A1.A1_EST = '"+cUf+"' AND A1.A1_COD_MUN = '"+cMunDes+"' AND A1.A1_FILIAL = '  ' "
//		Endif
	cSql += "AND C9.C9_NFISCAL = '         ' "
	cSql += "AND C9.C9_FILIAL BETWEEN '" + aEmps[i, 2]+ "' AND '" + aEmps[i, 3]+ "' "
	cSql += "AND C5.C5_EMISSAO BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	cSql += "AND C5.C5_FILIAL = C9.C9_FILIAL AND C5.C5_NUM = C9.C9_PEDIDO "    	
	cSql += "AND C5.C5_CLIENTE = C9.C9_CLIENTE AND C5.C5_LOJACLI = C9.C9_LOJA "
	cSql += "AND C9.C9_BLEST = '  ' AND C9.C9_BLCRED = '  ' " //AND C9.C9_X_CARGA = '         ' "
//	cSql += "GROUP BY C9.C9_PEDIDO, C9.C9_FILIAL, C9.C9_CLIENTE, C9.C9_LOJA, C5.C5_TRANSP, C5.C5_TPFRETE, A1.A1_NOME, A1.A1_EST, A1.A1_MUN "
	cSql += "UNION ALL "
	
	cSql += "SELECT C9.C9_PEDIDO, '"+AllTrim(aEmps[i,1])+"' C9_EMPRESA ,C9.C9_FILIAL,C9.C9_PRODUTO,C9.C9_LOTECTL,C9.C9_NFISCAL,C9.C9_X_CARGA, "
	cSql += "C9.C9_SERIENF,C9.C9_CLIENTE, C9.C9_LOJA, C9.C9_X_VLTOT, C5.C5_VEND1,C5.C5_TRANSP, C5.C5_TPFRETE, C9.C9_QTDLIB,C5.C5_DTHRALT, "
	cSql += "C5.C5_EMISSAO, "
	cSql += "(CASE "
	cSql += "	WHEN C5.C5_TRANSP <> '      ' THEN "
	cSql += "		(SELECT A4.A4_NOME FROM "+"SA4CMP"+" A4 "+"WHERE A4.D_E_L_E_T_ <> '*' AND A4.A4_COD = C5.C5_TRANSP) "
	cSql += "	WHEN C5.C5_TRANSP = '      ' THEN "
	cSql += "       'NAO SELECIONADA' "
	cSql += "END) A4_NOME,	"                            
	cSql += "A1.A1_NOME, A1.A1_EST, A1.A1_MUN	"		
	cSql += "FROM "+"SC9"+AllTrim(aEmps[i,1])+"0"+" C9, " + "SC5"+AllTrim(aEmps[i,1])+"0"+" C5, SA1CMP A1 "
	cSql += "WHERE C9.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' AND A1.D_E_L_E_T_ <> '*' "
	cSql += "AND A1.A1_COD = C9.C9_CLIENTE AND A1.A1_LOJA = C9.C9_LOJA "
	cSql += "AND C9.C9_FILIAL BETWEEN '" + aEmps[i, 2]+ "' AND '" + aEmps[i, 3]+ "' "
	cSql += "AND C5.C5_EMISSAO BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' "
	cSql += "AND C5.C5_FILIAL = C9.C9_FILIAL AND C5.C5_NUM = C9.C9_PEDIDO "    	
	cSql += "AND C5.C5_CLIENTE = C9.C9_CLIENTE AND C5.C5_LOJACLI = C9.C9_LOJA "
	cSql += "AND C9.C9_NFISCAL <> '         ' "	
//	cSql += "AND C9.C9_BLEST <> '  ' AND C9.C9_BLCRED <> '  ' "	
	if i != len(aEmps)
		cSql += " UNION ALL "
	Else
		cSql += " ) ORDER BY C9_EMPRESA, C9_FILIAL, C9_PEDIDO, C9_CLIENTE "
	EndIf
Next 
MemoWrite("c:\frttxt.txt",cSql)				
TCQUERY cSql NEW ALIAS "TMPSC9"
   
TMPSC9->(dbSelectArea("TMPSC9"))
TMPSC9->(dbGoTop())

TMPSC9->(DbGoTop())

	cArquivo := alltrim(MV_PAR05)+"\LOGISTICA.TXT"
	nHdl     := fCreate(cArquivo)

	cDetalhe := "DT_INI;"+"HR_INI;"+"DT_FIM;"+"HR_FIM;"+"CNPJ;"+"SERIE;"+"N_FISCAL;"+"EMISSAO;"+"HORA;"+"CLIENTE;"+;
				"RAZAO;"+"CID_ENTR;"+"UF_ENTR;"+"TRANSP;"+"NOME_TRA;"+"VENDEDOR;"+"ITEM;"+"PRODUTO;"+"QUANT;"+"VALOR;"+"LOTE;"+;
				"PEDIDO;"+"CARGA"+Chr(13)+Chr(10)
	Fwrite(nHdl,cDetalhe,Len(cDetalhe))

	Do While TMPSC9->(!Eof())
		_cEmpAtu	:= SM0->(GetArea())
		SM0->(DbSelectArea("SM0"))
		SM0->(DbSetOrder(1))
		SM0->(DbGotop())
		SM0->(DbSeek(TMPSC9->C9_EMPRESA+TMPSC9->C9_FILIAL))
			_cCGC	:= SM0->M0_CGC
		SM0->(RestArea(_cEmpAtu))					
		cDetalhe := DTOC(MV_PAR01)+";"+;
					MV_PAR03+";"+;
					DTOC(MV_PAR02)+";"+;
					MV_PAR04+";"+;
					_cCGC+";"+;
					Iif(Empty(AllTrim(TMPSC9->C9_NFISCAL)),"000",TMPSC9->C9_SERIENF)+";"+;
					Iif(Empty(AllTrim(TMPSC9->C9_NFISCAL)),"000000000",TMPSC9->C9_NFISCAL)+";"+;
					DtoC(StoD(C5_EMISSAO))+";"+;
					SubStr(TMPSC9->C5_DTHRALT,10,5)+";"+;
					TMPSC9->C9_CLIENTE+";"+;
					TMPSC9->A1_NOME+";"+;
					TMPSC9->A1_MUN+";"+;
					TMPSC9->A1_EST+";"+;
					TMPSC9->C5_TRANSP+";"+;
					TMPSC9->A4_NOME+";"+;
					Posicione("SA3",1,xfilial("SA3")+TMPSC9->C5_VEND1,"A3_NOME")+";"+;
					TMPSC9->C9_PRODUTO+";"+;
					Posicione("SB1",1,xfilial("SB1")+TMPSC9->C9_PRODUTO,"B1_DESC")+";"+;
				    ALLTRIM(STR(TMPSC9->C9_QTDLIB,10,4))+";"+;
					ALLTRIM(STR(TMPSC9->C9_X_VLTOT,10,2))+";"+;
					TMPSC9->C9_LOTECTL+";"+;
					TMPSC9->C9_PEDIDO+";"+;
					TMPSC9->C9_X_CARGA+Chr(13)+Chr(10)
							
				
		Fwrite(nHdl,cDetalhe,Len(cDetalhe))

		MsUnlock()
		
		TMPSC9->(DbSkip())
	Enddo

	FClose(nHdl)
	TMPSC9->(DbSelectArea("SC9"))
	TMPSC9->(DbCloseArea())
	
	MsgInfo("ARQUIVO GERADO "+alltrim(mv_par05)+"\LOGISTICA.XLS")
	fClose(nHdl)
	
//	oExcelApp:= MsExcel():New()
//	oExcelApp:WorkBooks:Open(alltrim(mv_par05)+"\LOGISTICA.XLS")
//	oExcelApp:SetVisible(.T.)	
	
Return


Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
Aadd(aRegs,{cPerg,"01","Data PED de    ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data PED ate   ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Hora de       ?","","","mv_ch3","C",05,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Hora ate      ?","","","mv_ch4","C",05,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Local Arquivo ?","","","mv_ch5","C",30,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
Next
dbSelectArea(_sAlias)
Return
