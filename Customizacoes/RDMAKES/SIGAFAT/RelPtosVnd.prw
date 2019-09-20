/*********************************************************
 Relatório de número de pontos obtidos por vendedor em determinado período
 o relatório busca as informaçoes de pontos de cada produto e
 traz o total de pontos obtidos no período para as filiais informadas.
 Obtém também as devoluções e desconta os pontos obtidos das mesmas.
 *********************************************************/
 /* Exemplo de relatório
 cod/loja - Nome cliente |   cod - nome produto    | Valor comprado (soma d2) | Unidades  | Pontos por unidade |  Total Ptos
 
 Agrupado por código de cliente e loja
 */
 
User Function RelPtosVnd()
Local nLastKey  := 0
Local cPerg 		:= PadR("PTOVND", Len(SX1->X1_GRUPO))
Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local nPtoVnd   := 0
Local nPtoTot   := 0
Local nPtoCli   := 0
Local cAliasTmp := GetNextAlias()
Local cChaveCli := ""
Local cProd     := ""
Local nPtosCli, nFatCli, nQtdVend
Local nPtosTot := 0, nFatTot:= 0, nQtdTot:= 0

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SD2"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Pontos do Cliente"
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são de Pontos do Cliente.    "
Private cDesc3    := "                             " 
Private cabec1    := "Cliente  /    Cod - Nome produto                                      Valor Comprado        Qtde   Ptos/Unid           Total Ptos"
Private wnrel     := "PTOVND"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "PTOVND"  // nome do programa que aparece no cabecalho do relatorio

SetPrvt("ALINHA,NLASTKEY,CABEC2")
SetPrvt("CCANCEL,M_PAG")  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

if !Pergunte(cPerg, .T.)
	Return
EndIf

if nLastKey == 27
  return
endIf

wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)

if nLastKey == 27
  return
endIf


SetDefault(aReturn,cString)
if nLastKey == 27
	return
endIf

BeginSql Alias cAliasTmp
	select sum(D2_QTSEGUM) as d2_qtdven, sum(d2_total) as d2_total, b1_numptos, b1_cod, b1_desc, a1_cod, a1_loja, a1_nome, f2_filial
	from %table:SD2% SD2
	INNER JOIN %table:SF2% SF2 on f2_filial = d2_filial and f2_doc = d2_doc and d2_serie = f2_serie
	INNER JOIN %table:SA1% SA1 on a1_loja = f2_loja and a1_cod = f2_cliente
	INNER JOIN %table:SB1% SB1 on B1_filial = d2_filial and B1_COD = d2_cod
	where sd2.d_e_l_e_t_ = ' '
	and sa1.d_e_l_e_t_ = ' '
	and sf2.d_e_l_e_t_ = ' '
	and sb1.d_e_l_e_t_ = ' '
	and f2_cliente >= %Exp:MV_PAR01%
	and f2_cliente <= %Exp:MV_PAR02%
	and f2_emissao >= %Exp:MV_PAR03%
	and f2_emissao <= %Exp:MV_PAR04%
	and b1_numptos > 0
	and F2_FILIAL in ('07', '09', '11')
	group by b1_numptos, b1_cod, b1_desc, a1_cod, a1_loja, a1_nome, f2_filial
	order by a1_cod, a1_loja, b1_desc
EndSql

PrCabec(cabec1)
PrtCabCli((cAliasTmp)->A1_COD + " / " + (cAliasTmp)->A1_LOJA + " - " + AllTrim((cAliasTmp)->A1_NOME))
cChaveCli := (cAliasTmp)->A1_COD + (cAliasTmp)->A1_LOJA 

// inicializa variáveis
nPtosCli := 0
nFatCli := 0
nQtdVend := 0

While (cAliasTmp)->(!Eof())
	if (PRow() > 58)
		Eject
		SETPRC(0,0)
		PrCabec(cabec1)
		PrtCabCli((cAliasTmp)->A1_COD + " / " + (cAliasTmp)->A1_LOJA + " - " + AllTrim((cAliasTmp)->A1_NOME))
	EndIf
	// avalia o filtro de filial e o de clientes
	if !((cAliasTmp)->F2_FILIAL $ MV_PAR05) .Or. ((cAliasTmp)->A1_COD $ MV_PAR06)
		(cAliasTmp)->(dbskip())
		Loop
	EndIf
	
	if cChaveCli != (cAliasTmp)->A1_COD + (cAliasTmp)->A1_LOJA	
		cChaveCli := (cAliasTmp)->A1_COD + (cAliasTmp)->A1_LOJA		
		
		if (PRow() > 55) .And. !Empty(cChaveCli)
			Eject
			SETPRC(0,0)
			PrCabec(cabec1)
			PrtTot(nFatCli, nQtdVend, nPtosCli)
			PrtCabCli((cAliasTmp)->A1_COD + " / " + (cAliasTmp)->A1_LOJA + " - " + AllTrim((cAliasTmp)->A1_NOME))
		else
			PrtTot(nFatCli, nQtdVend, nPtosCli)
		EndIf		
		
		if !Empty(cChaveCli)
			PrtCabCli((cAliasTmp)->A1_COD + " / " + (cAliasTmp)->A1_LOJA + " - " + AllTrim((cAliasTmp)->A1_NOME))
		EndIf
		
		nPtosCli := 0
		nFatCli := 0
		nQtdVend := 0
	EndIf
	
	@ PRow() + 1,   05 PSay AllTrim((cAliasTmp)->B1_COD) + ' - ' + AllTrim((cAliasTmp)->B1_DESC)
	@ PRow()    ,   70 PSay (cAliasTmp)->D2_TOTAL Picture '@E 999,999,999.99'
	@ PRow()    ,   87 PSay (cAliasTmp)->D2_QTDVEN Picture '@E 999,999.99'
	@ PRow()    ,   102 PSay (cAliasTmp)->B1_NUMPTOS Picture '@E 9,999.99'
	@ PRow()    ,   115 PSay ((cAliasTmp)->B1_NUMPTOS * (cAliasTmp)->D2_QTDVEN) Picture '@E 999,999,999.99'
	
	nPtosCli += ((cAliasTmp)->B1_NUMPTOS * (cAliasTmp)->D2_QTDVEN)
	nFatCli += (cAliasTmp)->D2_TOTAL
	nQtdVend += (cAliasTmp)->D2_QTDVEN
	
  nPtosTot += ((cAliasTmp)->B1_NUMPTOS * (cAliasTmp)->D2_QTDVEN)
  nFatTot += (cAliasTmp)->D2_TOTAL
	nQtdTot += (cAliasTmp)->D2_QTDVEN
	
	If LastKey()==286 // ALT + A
		@ PRow(),00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	(cAliasTmp)->(DbSkip())
EndDo

PrtTot(nFatTot, nQtdTot, nPtosTot)

//    Set Device to Screen
If aReturn[5] == 1
	Set Printer To
  Commit
  ourspool(wnrel) //Chamada do Spool de Impressao
Endif
SetPrc(0,0)	
MS_FLUSH() //Libera fila de relatorios em spool
//EndIf
SetPrc(0,0)	
//RestArea(Area)
Return .T.

Static Function AjustaSX(cPerg)
PutSx1(cPerg,"01","Cliente Inicial ?","Cliente Inicial ?","Cliente Inicial ?", "mv_cin", "C", 6, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Cliente Final ?","Cliente Final ?","Cliente Final ?", "mv_cfi", "C", 6, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","Data Inicial ?","Data Inicial ?","Data Inicial ?", "mv_din", "D", 8, 0, ,"G", "", "", "", "","MV_PAR03")
PutSx1(cPerg,"04","Data Final ?","Data Final ?","Data Final ?", "mv_dfi", "D", 8, 0, ,"G", "", "", "", "","MV_PAR04")
PutSx1(cPerg,"05","Filiais ?","Filiais ?","Filiais  ?", "mv_fil", "C", 20, 0, ,"G", "", "", "", "","MV_PAR05")
PutSx1(cPerg,"06","Exceto Clientes ?","Exceto Clientes ?","Exceto Clientes ?", "mv_ecl", "C", 60, 0, ,"G", "", "", "", "","MV_PAR06")
Return Nil

Static Function PrCabec(cCabec)
Cabec("Rel de Pontos do Cliente", cCabec, "", "RelPtoVnd", "M", 18)
/*@ 00, 00 PSay AvalImp(132) // seta o tamanho do relatório
@ PRow()    ,          00 PSay Repli('-', 132)
@ PRow() + 1,          00 PSay cCabec
@ PRow() + 1,          00 PSay Repli('-', 132)*/
Return NIl

Static Function PrtTot(nFat, nQtdVen, nPtos)
@ PRow()+1  ,          00 PSay Repli('-', 132)
@ PRow()+1  ,          02 PSay "Totais =>"
@ PRow()    ,          70 PSay nFat Picture '@E 999,999,999.99' 
@ PRow()    ,          87 PSay nQtdVen Picture '@E 999,999.99' 
@ PRow()    ,         115 PSay nPtos Picture '@E 999,999,999.99'
@ PRow()+1  ,          00 PSay Repli('-', 132)
Return Nil

Static Function PrtCabCli(cCab)
//@ PRow()+1  ,          00 PSay Repli('-', 60)
@ PRow()+1    ,          00 PSay cCab
//@ PRow()+1  ,          00 PSay Repli('-', 60)
Return Nil



/*******************************
 Eporta os dados para um arquivo de texto com espaçamento fixo.
 *******************************/
User Function ExpPtosVnd()
Local nLastKey  := 0
Local cPerg 		:= "PTOVND"
Local m_pag     :=  1         // Variavel que acumula numero da pagina
Local nPtoVnd   := 0
Local nPtoTot   := 0
Local nPtoCli   := 0
Local cAliasTmp := GetNextAlias()
Local cChaveCli := ""
Local cProd     := ""
Local nPtosCli, nFatCli, nQtdVend
Local nPtosTot := 0, nFatTot:= 0, nQtdTot:= 0

Private aReturn   := {"Especial", 1,"Administracao", 1, 2, 1,"",1}
Private cString   := "SD2"  // nome do arquivo a ser impresso
Private tamanho   := "M"    // P(80c), M(132c),G(220c)
Private nLastKey  := 0
Private titulo    := "Rel de Pontos do Cliente"
Private cDesc1    := "Este programa fará a impres- "
Private cDesc2    := "são de Pontos do Cliente.    "
Private cDesc3    := "                             " 
Private cabec1    := "Cliente  /    Cod - Nome produto                                      Valor Comprado        Qtde   Ptos/Unid           Total Ptos"
Private wnrel     := "PTOVND"  // nome do arquivo que sera gerado em disco
Private nomeprog  := "PTOVND"  // nome do programa que aparece no cabecalho do relatorio

cEOL    := "CHR(13)+CHR(10)"
cEOL	:= &cEOL

SetPrvt("ALINHA,NLASTKEY,CABEC2")
SetPrvt("CCANCEL,M_PAG") 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

if !Pergunte(cPerg, .T.)
	Return
EndIf

if nLastKey == 27
  return
endIf

//wnrel := SetPrint(cString,wnrel,,titulo,cDesc1,cDesc2,cDesc3,.F.,,.T.,tamanho)

if nLastKey == 27
  return
endIf


// SetDefault(aReturn,cString)
if nLastKey == 27
	return
endIf

BeginSql Alias cAliasTmp
	select sum(D2_QTSEGUM) as d2_qtdven, sum(d2_total) as d2_total, b1_numptos, b1_cod, b1_desc, a1_cod, a1_loja, a1_nome, a1_cgc, f2_filial
	from %table:SD2% SD2
	INNER JOIN %table:SF2% SF2 on f2_filial = d2_filial and f2_doc = d2_doc and d2_serie = f2_serie
	INNER JOIN %table:SA1% SA1 on a1_loja = f2_loja and a1_cod = f2_cliente
	INNER JOIN %table:SB1% SB1 on B1_filial = d2_filial and B1_COD = d2_cod
	where sd2.d_e_l_e_t_ = ' '
	and sa1.d_e_l_e_t_ = ' '
	and sf2.d_e_l_e_t_ = ' '
	and sb1.d_e_l_e_t_ = ' '
	and f2_cliente >= %Exp:MV_PAR01%
	and f2_cliente <= %Exp:MV_PAR02%
	and f2_emissao >= %Exp:MV_PAR03%
	and f2_emissao <= %Exp:MV_PAR04%
	and b1_numptos > 0
	and F2_FILIAL in ('07', '09', '11')
	group by b1_numptos, b1_cod, b1_desc, a1_cod, a1_loja, a1_nome, a1_cgc, f2_filial
	order by a1_cod, a1_loja, b1_desc
EndSql

//Cria e abre arquivo texto
nHdl	:= fCreate("c:\PtosCli_Vinho.txt")
cLinha := ""

While (cAliasTmp)->(!Eof())
	// avalia o filtro de filial e o de clientes
	if !((cAliasTmp)->F2_FILIAL $ MV_PAR05) .Or. ((cAliasTmp)->A1_COD $ MV_PAR06)
		(cAliasTmp)->(dbskip())
		Loop
	EndIf
	
	cLinha := (cAliasTmp)->F2_FILIAL + (cAliasTmp)->A1_COD + (cAliasTmp)->A1_LOJA + (cAliasTmp)->A1_CGC +PadR((cAliasTmp)->A1_NOME, 60)
	cLinha += (cAliasTmp)->B1_COD + PadR((cAliasTmp)->B1_DESC, 60) + Str((cAliasTmp)->B1_NUMPTOS, 5, 0)
	cLinha += Str((cAliasTmp)->d2_qtdven, 12, 2) + Str((cAliasTmp)->d2_qtdven * (cAliasTmp)->B1_NUMPTOS, 12, 2)
	cLinha += Str((cAliasTmp)->D2_TOTAL, 12, 2) + cEOL
	fWrite(nHdl,cLinha,Len(cLinha))
	(cAliasTmp)->(dbskip())
EndDo

MsgInfo("Arquivo criado com sucesso em c:\PtosCli_Vinho.txt", "Atenção")
fClose(nHdl)

Return .T.