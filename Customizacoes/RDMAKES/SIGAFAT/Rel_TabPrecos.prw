#include "rwmake.ch" 
#include "topconn.ch" 


//-- RELATORIO NOVO - PAISAGEM
*----------------------
User Function RPRCTAB()
*----------------------

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU,GRUPO,CFILIAL")   

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
U_USORWMAKE(ProcName(),FunName())

cString  := ""
cDesc1   := OemToAnsi("Este programa tem como objetivo a impressao do")
cDesc2   := OemToAnsi("relatorio de tabela de preco.")
cDesc3   := ""
Tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
NomeProg := "RPRCTB" //informacoes no SX1
aLinha   := {}
nLastKey := 0
Titulo   := "Tabela de Preco - Rela豫o de Precos"
		//   123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70        80        90        00        10        20        30        40        50        60        70        80        90        00        10
Cabec1   := "CODIGO   DESCRICAO                                         VALOR    CODIGO   DESCRICAO                                         VALOR"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "RPRTAB"               //Nome Default do relatorio em Disco

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

RptStatus({|| ImpRel() }, "Rela豫o de produtos...")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

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
Local cARMAZ := MV_PAR03
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_GRUPO, B1_UM , DA1_PRCVEN, DA1_PRCMIN, B1_FILVEND FROM "+RetSQLName("SB1")+" SB1 ,"
cQuery += RetSQLName("DA1")+" DA1 WHERE B1_EXPALM = '1' AND B1_COD = DA1_CODPRO  AND "
cQuery += " DA1_FILIAL = '" + xFilial("DA1") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQuery += " DA1_CODTAB >= '"+cTbDe+"' AND DA1_CODTAB <= '"+cTbAte+"' AND B1_LOCPAD "
cQuery += " ='"+cARMAZ+"' AND SB1.D_E_L_E_T_ <> '*' AND DA1.D_E_L_E_T_ <> '*' ORDER BY B1_GRUPO, B1_DESC"
Memowrite("rel_tabprecos.txt",cQuery)	
TCQUERY cQuery NEW ALIAS "TMPB1"
//Adriano
aStruc := dbStruct()
cArqTemp := CriaTrab(aStruc)
dbUseArea( .T. ,, cArqTemp , "TMP" )
APPEND FROM TMPB1
DbSelectArea("TMPB1")
TMPB1->(DbCloseArea())

TMP->(DbSelectArea("TMP"))
TMP->(DbGotop())
While !TMP->(Eof())
	If TMP->B1_UM == "BJ"
 		TMP->(RecLock("TMP",.F.))
		TMP->B1_GRUPO := 'EMBA'
    TMP->(MsUnlock())
	Endif
	TMP->(DbSkip())
End
_cArqInd1  := CriaTrab(NIL,.F.)
_cChave1  := "TMP->B1_GRUPO+TMP->B1_DESC"
IndRegua("TMP",_cArqInd1,_cChave1,,,"Selecionando Registros...")

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
If TMP->B1_GRUPO == 'EMBA'
	@PROW()+1,00  PSay "EMBALADOS"
Else
	@PROW()+1,00  PSay SBM->BM_DESC
Endif
grupo:=TMP->B1_GRUPO
nLin++ 

lImpL := .T.
nTDES := 49

While TMP->(!EOF())
	IncRegua()
    if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       @nLin,00 PSay Repli('-', 220)
       nLin++
       If TMP->B1_GRUPO == 'EMBA'
	       @nLin,00 PSay "EMBALADOS"
       Else
	       @nLin,00 PSay SBM->BM_DESC            
       Endif
       nLin++
       @nLin,00 PSay Repli('-', 220)       
       nLin++
    endIf
    //_filProd:=TMP->B1_FILVEND
    //if AllTrim(_Filial) $ AllTrim(_filProd)
    @nLin,000  PSay SubSTR(TMP->B1_COD,1,14)

    cB1DESC := ALLTRIM(SuBSTR(TMP->B1_DESC,1,49))
    cB1DESC := cB1DESC + IIF (lImpL, REPLI(".",nTDES - LEN(cB1DESC)),"")
    
    @nLin,010  PSay cB1DESC
    @nLin,057  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
    //endIf
    TMP->(dbSkip())  
    if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       nLin++
       @nLin,00 PSay Repli('-', 220)
       nLin++
       If TMP->B1_GRUPO == 'EMBA'
	       @nLin,00 PSay "EMBALADOS"
       Else
	       @nLin,00 PSay SBM->BM_DESC            
       Endif
       nLin++
       @nLin,00 PSay Repli('-', 220)       
       nLin++
    endIf
    If Alltrim(TMP->B1_COD) == "01.0299"
    	MsgBox(Alltrim(TMP->B1_DESC))
    Endif
    //_filProd:=TMP->B1_FILVEND
    //if AllTrim(_Filial) $ AllTrim(_filProd)
    
      @nLin,69  PSay SubSTR(TMP->B1_COD,1,14)

	    cB1DESC := ALLTRIM(SuBSTR(TMP->B1_DESC,1,49))
	    cB1DESC := cB1DESC + IIF (lImpL, REPLI(".",nTDES - LEN(cB1DESC)),"")       
	       
      @nLin,78  PSay cB1DESC
      @nLin,125  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
    
    //endIf
    nLin++
//	@nLin,00 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,09 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,35 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
//  dbSkip()
//	@nLin,50 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,60 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,70 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
   	If nLin > 66
		  Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
   	  nLin := 8
   	Endif
   	
   	If lImpL 
   		lImpL := .F.
   	Else
   		lImpL := .T.
   	EndIf
   		
	dbSelectArea("TMP")
	dbSkip()
Enddo
TMP->(dbCloseArea())
Return



//-- RELATORIO ANTIGO - RETRATO 
*-------------------------*
User Function RPRCTABO()
*-------------------------*

SetPrvt("CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO,ARETURN")
SetPrvt("NOMEPROG,ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2")
SetPrvt("CCANCEL,M_PAG,WNREL")
SetPrvt("PROD,TRANSP,DATAPED,ACHOU,GRUPO,CFILIAL")

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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
Titulo   := "Tabela de Preco - Rela豫o de Precos"
		//   12345678901234567890123456789012345678901234567890123456789012345678901234567890
		//            10       20        30        40        50        60        70        80
Cabec1   := "Codigo   Descricao                 Valor  Codigo   Descricao               Valor"
Cabec2   := ""
cCancel  := "***** Cancelado Pelo Operador *****"
Achou    := .F.
Grupo    := ""
m_Pag    := 1                      //Variavel que acumula numero da pagina
WnRel    := "RPRTAB"               //Nome Default do relatorio em Disco
           

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

RptStatus({|| ImpRel1() }, "Rela豫o de produtos...")// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> RptStatus({|| Execute(ImpRel) }, 'Pedidos de Venda em aberto')

Ms_Flush()                 //Libera fila de relatorios em spool

If aReturn[5] == 1
   Set Printer To
   OurSpool(WnRel)         //Chamada do Spool de Impressao
Endif
Return

Static Function ImpRel1()
Local cQuery := " "
Local nLin   := 8
Local cTbDe  := MV_PAR01
Local cTbAte := MV_PAR02
Local cARMAZ := MV_PAR03
Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_GRUPO, B1_UM, DA1_PRCVEN, DA1_PRCMIN, B1_FILVEND FROM "+RetSQLName("SB1")+" SB1 ,"
cQuery += RetSQLName("DA1")+" DA1 WHERE B1_EXPALM = '1' AND B1_COD = DA1_CODPRO  AND "
cQuery += " DA1_FILIAL = '" + xFilial("DA1") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQuery += " DA1_CODTAB >= '"+cTbDe+"' AND DA1_CODTAB <= '"+cTbAte+"' AND B1_LOCPAD "
cQuery += " ='"+cARMAZ+"' AND SB1.D_E_L_E_T_ <> '*' AND DA1.D_E_L_E_T_ <> '*' ORDER BY B1_GRUPO, B1_DESC"
Memowrite("XXX.txt",cQuery)	
TCQUERY cQuery NEW ALIAS "TMPB1"
//Adriano
aStruc := dbStruct()
cArqTemp := CriaTrab(aStruc)
dbUseArea( .T. ,, cArqTemp , "TMP" )
APPEND FROM TMPB1
DbSelectArea("TMPB1")
TMPB1->(DbCloseArea())

TMP->(DbSelectArea("TMP"))
TMP->(DbGotop())
While !TMP->(Eof())
	If TMP->B1_UM = "BJ"
        TMP->(RecLock("TMP",.F.))
			TMP->B1_GRUPO := 'EMBA'
        TMP->(MsUnlock())
	Endif
	TMP->(DbSkip())
End
_cArqInd1  := CriaTrab(NIL,.F.)
_cChave1  := "TMP->B1_GRUPO+TMP->B1_DESC"
IndRegua("TMP",_cArqInd1,_cChave1,,,"Selecionando Registros...")
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
If TMP->B1_GRUPO == "EMBA"
	@PROW()+1,00  PSay "EMBALADOS"
Else
	@PROW()+1,00  PSay SBM->BM_DESC
Endif
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
       If TMP->B1_GRUPO == "EMBA"
	       @nLin,00 PSay "EMBALADOS"
       Else
	       @nLin,00 PSay SBM->BM_DESC            
       Endif
       nLin++
       @nLin,00 PSay Repli('-', 80)       
       nLin++
    endIf
    //_filProd:=TMP->B1_FILVEND
    //if AllTrim(_Filial) $ AllTrim(_filProd)
    @nLin,00  PSay SubSTR(TMP->B1_COD,1,08)
    @nLin,09  PSay SuBSTR(TMP->B1_DESC,1,20)
    @nLin,31  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
    //endIf
    TMP->(dbSkip())
    if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       nLin++
       @nLin,00 PSay Repli('-', 80)
       nLin++
       If TMP->B1_GRUPO == "EMBA"
	       @nLin,00 PSay "EMBALADOS"
       Else
	       @nLin,00 PSay SBM->BM_DESC            
       Endif
       nLin++
       @nLin,00 PSay Repli('-', 80)       
       nLin++
    endIf
    If Alltrim(TMP->B1_COD) == "01.0299"
    	MsgBox(Alltrim(TMP->B1_DESC))
    Endif
    //_filProd:=TMP->B1_FILVEND
    //if AllTrim(_Filial) $ AllTrim(_filProd)
       @nLin,41  PSay SubSTR(TMP->B1_COD,1,08)
       @nLin,51  PSay SuBSTR(TMP->B1_DESC,1,20)
       @nLin,72  PSay TMP->DA1_PRCVEN  PICTURE "@E 9,999.99"
    //endIf
    nLin++
//	@nLin,00 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,09 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,35 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
//  dbSkip()
//	@nLin,50 PSAY SubSTR(TMP->B1_COD,1,07)
//	@nLin,60 PSAY SuBSTR(TMP->B1_DESC,1,25)
//	@nLin,70 PSAY TMP->DA1_PRCVEN  PICTURE "@E 9,999,999.99"
   	dbSelectArea("TMP")
		dbSkip()
   	If (nLin > 57) .And. TMP->(!EOF()) 
		  Cabec(titulo, cabec1, cabec2, NomeProg, Tamanho, 18)
    	  nLin := 8
   	Endif	
	
Enddo
TMP->(dbCloseArea())
Return




Static Function AjustaSX1() 

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PadR("RPRCTB",len(sx1->x1_grupo))
aRegs:={}
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Tabela De      ","","","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
aAdd(aRegs,{cPerg,"02","Tabela Ate     ","","","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DA0",""})
aAdd(aRegs,{cPerg,"03","Armazem        ","","","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","SZA000",""})


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