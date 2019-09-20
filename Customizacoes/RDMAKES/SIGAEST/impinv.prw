#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"

// Importação de Inventario conforme layout pre-definido.
// Exemplo de layout:
// PRODUTO ; QUANTIDADE
// 000000000000001	;	21
// 51.110	;	1

User Function ImpInv()

Private oGeraTxt
Private cPerg := "IMPINV0000"
ValidPerg()
Pergunte(cPerg,.F.)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 200,001 TO 380,380 DIALOG oLeTxt TITLE OemToAnsi("Lançamento de inventário")
@ 002,010 TO 080,190
@ 010,018 Say " Programa para importação de inventário. "
@ 018,018 Say " "
@ 60,090 BMPBUTTON TYPE 01 ACTION OkLeTxt()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oLeTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oLeTxt Centered

Return()

// Verifica arquivo
Static Function OkLeTxt()      
Private nHdl    := FT_FUSE(mv_par02)

If nHdl == -1
   MsgAlert("O arquivo " + mv_par02 + " não pode ser aberto! Verifique se o arquivo existe.","Atencao!")
   Return
Endif

Processa({|| RunCont() },"Processando...")

Return

// Processa arquivo
Static Function RunCont()
Local cProd 	:= ""
Local cQuant 	:= ""
Local nVer 		:= 0
aProduto		:= {}
FT_FGOTOP()

While !FT_FEOF()
	cLin := Ft_Freadln()
	For nR := 1 To Len(cLin)
		If SubStr(cLin,nR,1) == ";"
			nVer := 1
		Endif
		If nVer = 0
			If !Empty(SubStr(cLin,nR,1)) .AND. SubStr(cLin,nR,1) <> '	'
				cProd += SubStr(cLin,nR,1)
			Endif
		Else
			If !Empty(SubStr(cLin,nR,1)) .AND. SubStr(cLin,nR,1) <> '	' .AND. SubStr(cLin,nR,1) <> ";" 
				cQuant += SubStr(cLin,nR,1)
			Endif
		Endif 
	Next nR
	aAdd(aProduto,{cProd,Val(cQuant)})
	nVer := 0
	cProd 	:= ""
	cQuant  := ""
	FT_FSKIP()
End
FT_FUSE()
fClose(nHdl)
Close(oLeTxt)

If MsgBox ("Confirma lançamento de inventário?","Escolha","YESNO")
	For nR := 1 To Len(aProduto)
		cSql := "SELECT B1.B1_TIPO "
		cSql += "FROM "+RetSqlName("SB1")+" B1 "
		cSql += "WHERE B1.B1_FILIAL = '"+xFilial("SB1")+"' "
		cSql += "AND B1.D_E_L_E_T_ <> '*' "
		cSql += "AND B1.B1_COD = '"+aProduto[nR,1]+"' "
		TCQUERY cSql NEW ALIAS "TMPSB1"
		DbSelectArea("TMPSB1")
		TMPSB1->(DbGotop())
		If !TMPSB1->(Eof())		
			lMsErroAuto := .F.
			aItem:={{"B7_COD"	,aProduto[nR,1]		,Nil},;
		            {"B7_LOCAL"	,mv_par03			,Nil},;
		            {"B7_TIPO" 	,TMPSB1->B1_TIPO	,Nil},;
		            {"B7_DOC"  	,mv_par04			,Nil},;
		            {"B7_QUANT"	,aProduto[nR,2]		,Nil},;
		            {"B7_DATA" 	,mv_par01			,Nil}}
		            				
			MSExecAuto({|x,y| MATA270(x,y)},aItem,3) 	
			If lMsErroAuto
				MostraErro()
			Endif
		Else
			
		Endif
		TMPSB1->(DbCloseArea("TMPSB1"))
	Next nR
	
Endif

MS_FLUSH()

Return()

Static Function ValidPerg()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DEFSP1/DFENG1/Cnt01/Var02/Def02/DEFSP1/DFENG1/Cnt02/Var03/Def03/DEFSP1/DFENG1/Cnt03/Var04/Def04/DEFSP1/DFENG1/Cnt04/Var05/Def05/DEFSP1/DFENG1/Cnt05
aAdd(aRegs,{cPerg,"01","Data Fechamento       ?","","","mv_ch1","D",08,0,0,"G",""        ,"mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Local do Arquivo      ?","","","mv_ch2","C",50,0,0,"F",""        ,"mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Armazem               ?","","","mv_ch3","C",02,0,0,"C",""        ,"mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Documento             ?","","","mv_ch4","C",06,0,0,"C",""        ,"mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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