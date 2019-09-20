#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PRODTBPR  ºAutor  ³Microsiga           º Data ³  08/27/08   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Usado para compatibilizar as tabelas de preço de acordo    º±±
±±º          ³ com a tabela base.                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ProdTbPr()
local cAlias := "DA0"
local cAliasIt := "DA1"
local cPerg := "GETAPR"
local cAliasDA1, cAliasDA1M
local cQuery, cItemM
local nPerc := 0
local nItensAlt := 0
Private Titulo    := "Gerar / atualizar tabelas de preço"
Private cDesc1    := "Este programa tem por objetivo a geracao/atualizacao das tabelas de preço"
Private cDesc2    := ""
Private cDesc3    := ""
Private nLastKey  := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// cria/atualiza os parametros
PutSx1(cPerg,"01","Tabela de referencia","Tabela de referencia","Tabela de referencia", "mv_tbba", "C", 3, 0, 0,"G", "", "DA0", "", "","MV_PAR01")
PutSx1(cPerg,"02","Tabela Inicial","Tabela Inicial","Tabela Inicial", "mv_tbin", "C", 3, 0, 0,"G", "", "DA0", "", "","MV_PAR02")
PutSx1(cPerg,"03","Tabela Final","Tabela Final","Tabela Final", "mv_tbfi", "C", 3, 0, 0,"G", "", "DA0", "", "","MV_PAR03")
/*
1 = tabela base
2 = tabela alt inicial
3 = tabela alt final
*/
cAliasDA1 := GetNextAlias()

Pergunte(cPerg)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif


DA0->(dbSetOrder(01))
DA0->(dbSeek(xFilial(cAlias) + mv_par01))
if DA0->(Found())
  cQuery := "Select * from " + RetSqlName("DA1") + " Where DA1_Filial = '" + xFilial("DA1") + "' and DA1_CODTAB = '" + mv_par01 + "'"
  dbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasDA1, .T., .T.)
  
  DA0->(dbSeek(xFilial(cAlias) + mv_par02))
  DA1->(dbSetOrder(03))  
  While (DA0->DA0_CODTAB <= mv_par03) .And. DA0->(!Eof())
    DA1->(dbSetOrder(03))
    DA1->(dbSeek(xFilial(cAliasIt) + DA0->DA0_CODTAB + '0001'))
    nPerc := DA1->DA1_PERDES
    // executa query para pegar o maior código de item da tabela atual, a ser usado na inclusao dos itens que nao existem
    cAliasDA1M := GetNextAlias()
    cQuery := "select max(DA1_ITEM) as ITEM from " + RetSqlName("DA1") + " Where DA1_Filial = '" + ;
    					xFilial("DA1") + "' and DA1_CODTAB = '" + DA0->DA0_CODTAB + "'"
    dbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasDA1M, .T., .T.)
    cItemM := (cAliasDA1M)->ITEM
    cItemM := Soma1(cItemM)
    (cAliasDA1M)->(DbCloseArea())
    
    (cAliasDA1)->(DbGotop())
    DA1->(DbSetOrder(01))
    While (cAliasDA1)->(!Eof())      
      if DA1->(!DbSeek(xFilial(cAliasIt) + DA0->DA0_CodTab + (cAliasDA1)->DA1_CodPro)) // busca pelo produto
        DA1->(RecLock("DA1", .T.))
        DA1->DA1_Filial := xFilial(cAlias)
        DA1->DA1_ITEM := cItemM        
        DA1->DA1_CODTAB := DA0->DA0_CODTAB
        DA1->DA1_VLRDES := 0        
        DA1->DA1_ATIVO  := "1"
        DA1->DA1_DATVIG := Date()
        DA1->DA1_CODPRO := (cAliasDA1)->DA1_CODPRO
        DA1->DA1_ESTADO := (cAliasDA1)->DA1_ESTADO
        DA1->DA1_TPOPER := (cAliasDA1)->DA1_TPOPER
        DA1->DA1_QTDLOT := (cAliasDA1)->DA1_QTDLOT
        DA1->DA1_MOEDA  := (cAliasDA1)->DA1_MOEDA
        DA1->DA1_PERDES := nPerc // percentual aplicado na tabela        
        DA1->(MsUnlock())
        cItemM := Soma1(cItemM)
        nItensAlt++
      EndIf                                    
      (cAliasDA1)->(dbSkip())
    EndDo
    DA0->(dbSkip())
  EndDo  
EndIf

MsgAlert("Foram incluídos " + AllTrim(Str(nItensAlt)) + " produtos nas tabelas informadas.")

Return nil 


Static Function GeraTrab(cAlias)
local aStru
local cQuery
cQuery := "Select * from " + RetSqlNam("DA1") + " Where A1_Filial = '" + xFilial("DA1") + "' and A1_CODTAB = '" + mv_par01 + '"
dbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAlias, .T., .T.)
Return 