#Include "RwMake.ch"
#Include "topconn.ch"

User Function CANTU999()

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
Private nomeprog   := "INCTBR02"
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "RCTB02"
Private cPerg      := "INDC03"
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

_cQrySD2+=" SELECT F2_SERIE, F2_DOC, F2_EMISSAO, F2_HORA, A1_COD, A1_NOME, A1_MUN, A1_EST, F2_TRANSP, A3_NOME, D2_COD, B1_DESC, D2_QUANT, D2_PESO,"
_cQrySD2+="        D2_TOTAL, D2_VALIPI, D2_ICMSRET, D2_LOTECTL, F2_TPFRETE, A1_CGC"
_cQrySD2+="   FROM "+RetSqlName("SF2")+" SF2"
_cQrySD2+="        LEFT JOIN "+RetSqlName("SD2")+" D2 ON (D2.D_E_L_E_T_ <> '*' AND D2_FILIAL = F2_FILIAL AND D2_DOC = F2_DOC AND D2_SERIE = F2_SERIE "
_cQrySD2+="                                AND F2_CLIENTE = D2_CLIENTE AND F2_LOJA = D2_LOJA)"
_cQrySD2+="        LEFT JOIN "+RetSqlName("SB1")+" B1 ON (B1.D_E_L_E_T_ <> '*' AND B1_COD = D2_COD)"
_cQrySD2+="        LEFT JOIN "+RetSqlName("SA1")+" A1 ON (A1.D_E_L_E_T_ <> '*' AND A1_COD = F2_CLIENTE AND A1_LOJA = F2_LOJA)"  
_cQrySD2+="        LEFT JOIN "+RetSqlName("SA3")+" A3 ON (A3.D_E_L_E_T_ <> '*' AND A3_COD = F2_VEND1)"
_cQrySD2+="  WHERE SF2.D_E_L_E_T_ <> '*'" 
_cQrySD2+="    AND D2_TES NOT IN ('630','644','544','582') "
_cQrySD2+="    AND F2_HORA BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' AND F2_EMISSAO BETWEEN '"+DTOS(MV_PAR01)+ "' AND '"+DTOS(MV_PAR02)+"' "
_cQrySD2+="    AND F2_FILIAL = '"+xFilial("SF2")+"' "
_cQrySD2+="  ORDER BY F2_DOC "

/*
cArquivo := "c:\SQLNotas.SQL"
nHdl     := fCreate(cArquivo)
cDetalhe := _cQrySD2
Fwrite(nHdl,cDetalhe,Len(cDetalhe))
FClose(nHdl)
*/
If Select("SD2SQL") > 0
	SD2SQL->(DbCloseArea())
Endif

TCQUERY _cQrySD2 NEW ALIAS "SD2SQL"
TCSetField("SD2SQL","DATA_NF","D")
TCSetField("SD2SQL","SAIDA","N",14,2)//TESTE TOTAL

SD2SQL->(DbGoTop())

	cArquivo := alltrim(MV_PAR05)+"\LOGISTICA.TXT"
	nHdl     := fCreate(cArquivo)

	cDetalhe := "DT_INI;"+"HR_INI;"+"DT_FIM;"+"HR_FIM;"+"CNPJ;"+"SERIE;"+"N_FISCAL;"+"EMISSAO;"+"HORA;"+"CLIENTE;"+;
				"RAZAO;"+"CID_ENTR;"+"UF_ENTR;"+"TRANSP;"+"NOME_TRA;"+"VENDEDOR;"+"ITEM;"+"PRODUTO;"+"QUANT;"+"PESO;"+"VALOR;"+"LOTE;"+"TIPOFRETE;"+"CGC"+Chr(13)+Chr(10)
	Fwrite(nHdl,cDetalhe,Len(cDetalhe))

	Do While SD2SQL->(!Eof())
		cDetalhe := DTOC(MV_PAR01)+";"+;
					MV_PAR03+";"+;
					DTOC(MV_PAR02)+";"+;
					MV_PAR04+";"+;
					SM0->M0_CGC+";"+;
					SD2SQL->F2_SERIE+";"+;
					SD2SQL->F2_DOC+";"+;
					DTOC(STOD(SD2SQL->F2_EMISSAO))+";"+;
					SD2SQL->F2_HORA+";"+;
					SD2SQL->A1_COD+";"+;
					SD2SQL->A1_NOME+";"+;
					SD2SQL->A1_MUN+";"+;
					SD2SQL->A1_EST+";"+;
					SD2SQL->F2_TRANSP+";"+;
					Posicione("SA4",1,xfilial("SA4")+SD2SQL->F2_TRANSP,"A4_NOME")+";"+;
					SD2SQL->A3_NOME+";"+;             
					SD2SQL->D2_COD+";"+;
					SD2SQL->B1_DESC+";"+;
					ALLTRIM(STR(SD2SQL->D2_QUANT,10,4))+";"+;
					transform(SD2SQL->D2_PESO, PesqPict("SD2", "D2_PESO"))+";"+;
					ALLTRIM(STR(SD2SQL->D2_TOTAL + SD2SQL->D2_VALIPI + SD2SQL->D2_ICMSRET, 10,2)) +";"+;
					SD2SQL->D2_LOTECTL+";"+;
					IIF(ALLTRIM(SD2SQL->F2_TPFRETE) == 'C','0',IIF(ALLTRIM(SD2SQL->F2_TPFRETE) == 'F','1',''))+";"+;
					ALLTRIM(SD2SQL->A1_CGC)+Chr(13)+Chr(10)
							                       				
		Fwrite(nHdl,cDetalhe,Len(cDetalhe))

		MsUnlock()
		
		SD2SQL->(DbSkip())
	Enddo

	FClose(nHdl)
	
	MsgInfo("ARQUIVO GERADO "+alltrim(mv_par05)+"\LOGISTICA.TXT")
	
Return


Static Function ValidPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
Aadd(aRegs,{cPerg,"01","Data NF de    ?","","","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"02","Data NF ate   ?","","","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
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
