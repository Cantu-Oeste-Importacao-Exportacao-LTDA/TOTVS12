/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦ TABLAR   ¦ Autor ¦  Eder Gasparin       ¦ Data ¦ 23/07/08  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ Tabela de preços feita especialmente para impressão das    ¦¦¦
¦¦¦          ¦ lojas LAR. Devido ao fato de que todos os produtos  sao    ¦¦¦
¦¦¦          ¦ vendidos em kg e alguns produtos, vendidos exclusivamente  ¦¦¦
¦¦¦          ¦ para essas lojas, nao correspondem a quantidade de kgs,    ¦¦¦
¦¦¦          ¦ vendidas para os outros clientes.                          ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ Especifico CANTU - Lojas lar Cantu - Cvel                  ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/
#include "rwmake.ch" 
#include "topconn.ch" 
*----------------------
User Function TABLAR()
*----------------------

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU,GRUPO,CFILIAL")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("relatorio de tabela de preco.")
cDesc3   := ""
Tamanho  := "P"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RPRCTB" //informacoes no SX1
aLinha   := {}
nLastKey := 0
Titulo   := "Tabela de Preco - Lojas Lar"                                    
		//   1234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70
Cabec1   := "Codigo  Descricao                 Valor  Codigo   Descricao               Valor"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "TABLAR"               //Nome Default do relatorio em Disco

AjustaSX1()

If !Pergunte(NomeProg) //se for cancelada a tela de perguntas, volta para o menu principal
   Return
EndIf
                                                                                     
Titulo   := "Relacao de Precos - Tabela: "+MV_PAR01
WnRel := SetPrint(cString, WnRel, NomeProg, Titulo, cDesc1, cDesc2, cDesc3, .F., "",, Tamanho)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

SetDefault(aReturn, cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

RptStatus({|| ImpRel() }, "Relação de produtos...")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif
Return

Static Function ImpRel()
Local cQuery := " "
Local nLin   := 8
Local cTbDe  := MV_PAR01
Local cTbAte := MV_PAR02
Local cFx    := MV_PAR03
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_GRUPO, DA1_PRCVEN, DA1_PRCMIN, B1_FILVEND, B1_CONV, B1_TIPCONV FROM "+RetSQLName("SB1")+" SB1 ,"
cQuery += RetSQLName("DA1")+" DA1 WHERE DA1.DA1_FILIAL = SB1.B1_FILIAL AND DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND SB1.B1_EXPALM = '1' AND SB1.B1_COD = DA1.DA1_CODPRO  AND"
cQuery += " DA1.DA1_CODTAB >= '"+cTbDe+"' AND DA1.DA1_CODTAB <= '"+cTbAte+"' AND SUBSTR(SB1.B1_COD,1,2)"
cQuery += " ='"+cFx+"' AND SB1.D_E_L_E_T_ <> '*' AND DA1.D_E_L_E_T_ <> '*' ORDER BY SB1.B1_GRUPO,SB1.B1_DESC"

/*cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_GRUPO, DA1_PRCVEN, DA1_PRCMIN, B1_FILVEND, B1_CONV, B1_TIPCONV FROM "+RetSQLName("SB1")+" SB1 ,"
cQuery += RetSQLName("DA1")+" DA1 WHERE SB1.B1_EXPALM = '1' AND SB1.B1_COD = DA1.DA1_CODPRO  AND"
cQuery += " DA1.DA1_CODTAB >= '"+cTbDe+"' AND DA1.DA1_CODTAB <= '"+cTbAte+"' AND SUBSTR(SB1.B1_COD,1,2)"
cQuery += " ='"+cFx+"' AND SB1.D_E_L_E_T_ <> '*' AND DA1.D_E_L_E_T_ <> '*' ORDER BY SB1.B1_GRUPO,SB1.B1_DESC"*/
Memowrite("XXX.txt",cQuery)	
TCQUERY cQuery NEW ALIAS "TMP"

SM0->(DbSetOrder(1))
dbSelectArea("SM0")                   // * Sigamat.emp
_Filial :=SM0->M0_CODFIL

dbSelectArea("TMP")
dbGoTop()
SetRegua(TMP->(LastRec()))

dbSelectArea("SBM")
dbSetOrder(1)
dbGotop()
SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
@PROW()+1,00  PSay SBM->BM_DESC
grupo:=TMP->B1_GRUPO
nLin++
While TMP->(!EOF())
	IncRegua()
    if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       @nLin,00 PSay Repli('-', 80)
       nLin++
       @nLin,00 PSay SBM->BM_DESC            
       nLin++
       @nLin,00 PSay Repli('-', 80)       
       nLin++
    endIf
    _filProd:=TMP->B1_FILVEND
    if AllTrim(_Filial) $ AllTrim(_filProd)
       @nLin,00  PSay SubSTR(TMP->B1_COD,1,07)
       @nLin,08  PSay SuBSTR(TMP->B1_DESC,1,22)
       if AllTrim(TMP->B1_TIPCONV) = 'M'
	        @nLin,31  PSay (TMP->DA1_PRCVEN)/(TMP->B1_CONV) PICTURE "@E 9,999.99"
       else
	        @nLin,31  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
       endIf 
    endIf
    TMP->(dbSkip())
    if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       nLin++
       @nLin,00 PSay Repli('-', 80)
       nLin++
       @nLin,00 PSay SBM->BM_DESC            
       nLin++
       @nLin,00 PSay Repli('-', 80)       
       nLin++
    endIf
    If Alltrim(TMP->B1_COD) == "01.0299"
    	MsgBox(Alltrim(TMP->B1_DESC))
    Endif
    _filProd:=TMP->B1_FILVEND
    if AllTrim(_Filial) $ AllTrim(_filProd)
       @nLin,41  PSay SubSTR(TMP->B1_COD,1,07)
       @nLin,50  PSay SuBSTR(TMP->B1_DESC,1,22)
       if AllTrim(TMP->B1_TIPCONV) = 'M'
	        @nLin,72  PSay (TMP->DA1_PRCVEN)/(TMP->B1_CONV) PICTURE "@E 9,999.99"
       else
	        @nLin,72  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
       endIf 
    endIf
    nLin++
//	@nLin,00 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,09 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,35 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
//  dbSkip()
//	@nLin,50 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,60 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,70 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
   	If nLin > 55 
		  Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
    	  nLin := 8
   	Endif	
	dbSelectArea("TMP")
	dbSkip()
Enddo
TMP->(dbCloseArea())
Return


Static Function AjustaSX1() 

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PadR("RPRCTB", len(sx1->x1_grupo))
aRegs:={}
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Tabela De      ","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
aAdd(aRegs,{cPerg,"02","Tabela Ate     ","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
aAdd(aRegs,{cPerg,"03","Faixa Produto  ","","","mv_ch3","C",02,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)        
Return