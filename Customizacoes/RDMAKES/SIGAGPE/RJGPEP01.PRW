#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "DBINFO.CH"
#INCLUDE "PRCONST.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJGPEP01  ºAutor  ³Luiz Gamero Prado   º Data ³  24/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Progama para identificar os valores provisionados mes a mes º±±
±±º          ³da multa do fgts 50% rescisao (tabela SRD)                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ P10 - Especifico GRUPO CANTU                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User function RJGPEP01()
Local _Vlr     := 0
Local _Filial  := SRA->RA_FILIAL
Local _Mat     := SRA->RA_MAT
Local _Pd      := "890"
Local _Complem := .F.
Local _dtGera  := iif(type("M->RG_DTGERAR") <> "U",dtos(M->RG_DTGERAR),dtos(Ddatabase))   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Valida se a tabela temporaria esta aberta, caso afirmativo fecha a mesma
If Select("TMPBXMULTFGT") > 0
	DbSelectArea( "TMPBXMULTFGT" )
	cArq := DbInfo(DBI_FULLPATH)
	cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
	DbCloseArea()
	FErase(cArq)
EndIf

If Select("TMPSRG") > 0
	DbSelectArea( "TMPSRG" )
	cArq := DbInfo(DBI_FULLPATH)
	cArq := AllTrim(SubStr(cArq,Rat("\",cArq)+1))
	DbCloseArea()
	FErase(cArq)
EndIf

// SELECT PARA VERIFICAR SE NAO É RESCISAO COMPLEMENTAR, CASO SEJA RESCISAO COMPLEMENTAR NAO PODE BAIXAR NOVAMENTE AS PROVISOES

cQuery := " "
cQuery += " select rg_dtgerar "
cQuery += " from  "+RetSqlName("SRG")+" srg "
cQuery += " where srg.rg_filial = '" +_Filial+ "' and "
cQuery += " srg.rg_mat = '" +_Mat + "' and "
cQuery += " srg.d_e_l_e_t_ <> '*' "
MemoWrite("TMPSRG.TXT",cQuery)
TcQuery cQuery NEW ALIAS "TMPSRG"
If Alias() <> "TMPSRG"
	MsgBox("TMPSRG - Parâmetros Inválidos!")
	Return .f.
Endif
dbSelectArea("TMPSRG")
dbGoTop("TMPSRG")

WHILE TMPSRG->(!EOF())
	if StoD(tmpsrg->rg_dtgerar) <> stod(_dtgera)
		_Complem := .T.
	EndIf
	TMPSRG->(DBSKIP())
ENDDO

If _Complem = .F. // se nao for rescisao complementar, efetua apuracao valor multa fgts
 
	// SELECT PARA IDENTIFICAR O VALOR QUE FOI PROVISIONADO
	cQuery := " "
	cQuery += " select sum(rd_valor) vlr  "
	cQuery += " from  "+RetSqlName("SRD")+" srd "
	cQuery += " where srd.rd_filial = '" +_Filial+ "' and "
	cQuery += " srd.rd_mat = '" +_Mat + "' and "
	cQuery += " srd.rd_pd = '" +_PD + "' and "
	cQuery += " srd.d_e_l_e_t_ <> '*' "
	
	MemoWrite("TMPBXMULTFGT.TXT",cQuery)
	TcQuery cQuery NEW ALIAS "TMPBXMULTFGT"
	If Alias() <> "TMPBXMULTFGT"
		MsgBox("TMPBXMULTFGT - Parâmetros Inválidos!")
		Return .f.
	Endif
	
	dbSelectArea("TMPBXMULTFGT")
	dbGoTop("TMPBXMULTFGT")
	_Vlr := TMPBXMULTFGT->vlr
endif

Return _Vlr