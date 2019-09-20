#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FrtClass                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para classificação dos CTRC´s   				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


User Function FrtClass()
Private cPerg  		:= "FRTCLASS"
Private aRotina 	:= {{"Pesquisar", "AxPesqui", 0, 1},;
                    	{"Visualizar", "AxVisual", 0, 2},;
                    	{"Incluir", "AxInclui", 0, 3},;
                    	{"Alterar", "AxAltera", 0, 4},;
                    	{"Excluir", "AxDeleta", 0, 5}}
Private oGeraTxt  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
                  	
DbSelectArea("ZZS")
//FRTFAT
ValidPerg() 
Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Classificação CTRC")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa filtra todas as Pré-Notas referente aos CTRC´s"
@ 18,018 Say " vinculados a uma determinada fatura da transportadora.      "
@ 26,018 Say "                                                             "

@ 60,090 BMPBUTTON TYPE 01 ACTION ClassOK()
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered


Return

Static Function ClassOk()

Processa({|| FRTCLOK() },"Processando...")
Close(oGeraTxt)
Return Nil


Static Function FRTCLOK()
Local cSql		:= ""
Local nCl		:= 0
Private FTPref	:= 'FAT'
Private FTTP	:= 'FT'
Private FTNat	:= Space(10)
Private FTDtDe	:= Stod('20100101')
Private FTDTAt	:= Stod('20991231')
Private FTForn	:= ""
Private FTLoja	:= ""
Private	FTFat	:= mv_par01
Private FTCLVL  := Space(TAMSX3("CTH_CLVL")[1])

cSql := "SELECT F1.F1_FILIAL, F1.F1_DOC, F1.F1_SERIE, F1.F1_FORNECE, F1.F1_LOJA "
cSql += "FROM "+RetSqlName("SF1")+" F1 "
cSql += "WHERE F1.D_E_L_E_T_ <> '*' "
cSql += "AND F1.F1_FILIAL = '"+xFilial("SF1")+"' "
cSql += "AND F1.F1_X_FATTR = '"+FTFat+"' AND F1.F1_STATUS = ' ' "
TCQUERY cSql NEW ALIAS "TMPSF1"

TMPSF1->(DbSelectArea("TMPSF1"))
TMPSF1->(DbGotop())
While !TMPSF1->(Eof())
	_TMPArea	:= TMPSF1->(GetArea())
	FTForn		:= TMPSF1->F1_FORNECE
	FTLoja		:= TMPSF1->F1_LOJA
	SF1->(DbSelectArea("SF1"))
	SF1->(DbSetOrder(1))
	SF1->(Dbgotop())
	If SF1->(DbSeek(xFilial("SF1")+TMPSF1->F1_DOC+TMPSF1->F1_SERIE+TMPSF1->F1_FORNECE+TMPSF1->F1_LOJA))
		A103NFiscal("SF1",Recno(),4)
		nCl		+= 1
		SE2->(DbSelectArea("SE2"))
		SE2->(DbSetOrder(6))
		If SE2->(DbSeek(xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC))
			FTNat	:= SE2->E2_NATUREZ
			FTCLVL	:= SE2->E2_CLVLDB
			While !SE2->(Eof()) .AND. xFilial("SE2")+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM == ;
								xFilial("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_PREFIXO+SF1->F1_DOC
				SE2->(RecLock("SE2", .F.))
					SE2->E2_X_FATTR := SF1->F1_X_FATTR
				SE2->(MsUnlock())
				SE2->(DbSkip())										
			End
		Endif
	Endif
	RestArea(_TMPArea)
	TMPSF1->(DbSkip())	
End
TMPSF1->(DbSelectArea("TMPSF1"))
TMPSF1->(DbCloseArea())
cSql := "SELECT E2.E2_FILIAL, E2.E2_NUM, E2.E2_FORNECE, E2.E2_LOJA, E2.E2_X_FATTR,E2.E2_NATUREZ,E2.E2_CLVLDB "
cSql += "FROM "+RetSqlName("SE2")+" E2 "
cSql += "WHERE E2.D_E_L_E_T_ <> '*' "
cSql += "AND E2.E2_FILIAL = '"+xFilial("SE2")+"' "
cSql += "AND E2.E2_X_FATTR = '"+FTFat+"' "
TCQUERY cSql NEW ALIAS "TMPSE2"
TMPSE2->(DbSelectArea("TMPSE2"))
TMPSE2->(DbGotop())
If !TMPSE2->(Eof())
	If MsgBox("Deseja aglutinar a fatura financeira agora?", "Atenção", "YESNO")
		FTNat	:= TMPSE2->E2_NATUREZ
		FTCLVL	:= TMPSE2->E2_CLVLDB			
		FTForn	:= TMPSE2->E2_FORNECE
		FTLoja	:= TMPSE2->E2_LOJA			
		FINA290() // FATURA A PAGAR
	Endif
Endif
TMPSE2->(DbSelectArea("TMPSE2"))
TMPSE2->(DbCloseArea())	

Return Nil


Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Numero Fatura    ","","","mv_ch1","C",09,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","FRTFAT","",""})

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
