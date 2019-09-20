#INCLUDE "rwmake.ch"
#INCLUDE "vkey.ch"
#include "TopConn.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Programa para controle do faturamento do frete						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
// Validar nota
// Validar canhoto
// Validar valor retornado do frete no pedido
// Verificar frete cobrado adicional de reentrega


User Function FRTCons()
Local 	aArea 		:= GetArea()
Local 	aButtons  	:= {} //{ { "S4WB011N"   , { || U_Ordenagrd() }, OemtoAnsi("OrdenaGrid"), OemtoAnsi("OrdenaGrid") } } //"Busca Produto"
Local 	oTPanel1
Local 	oTPAnel2
Local   cCpos 		:= "ZZS_NOMEMP/ZZS_NOMFIL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_NFSAI/ZZS_CLIENT/ZZS_NOMCLI/ZZS_TOTNF/ZZS_CODTRA/ZZS_TRANSP/ZZS_NUMCTR/ZZS_SERCTR/ZZS_DTCTRC/ZZS_NUMFAT/ZZS_VENTIT/ZZS_CANHOT/ZZS_SEGMEN/ZZS_CC/ZZS_VALFRE/ZZS_VLRFIN/ZZS_VLRCTR/ZZS_VLRDIF/ZZS_JUSVLD/ZZS_FORMPG/ZZS_CALCFR/ZZS_EMPRES/ZZS_FILORI/ZZS_DTFAT/ZZS_MUN/ZZS_UFCLI"
Local   aCpos 		:= StrToKArr(cCpos, "/")
Private oDlg1
Private oDlg
Private oGet
Private oGeraTxt
Private cAlias		:= "ZZS" 
Private cMunOri		:= Space(05)
Private cUf			:= Space(02)
Private cCadastro 	:= "Retorno de entregas"
Private lRefresh 	:= .T.
Private aHeader 	:= {}
Private aCols 		:= {}
Private cPerg  		:= "FRTCONSULT"
Private aRotina 	:= {{"Pesquisar", "AxPesqui", 0, 1},;
                    	{"Visualizar", "AxVisual", 0, 2},;
                    	{"Incluir", "AxInclui", 0, 3},;
                    	{"Alterar", "AxAltera", 0, 4},;
                    	{"Excluir", "AxDeleta", 0, 5}}
nOpc				:= 3
nOpca				:= 2
aEmps				:= {}
               
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
// Monta o aHeader
dbSelectArea("SX3")
dbSetOrder(2)// Campo

For nX := 1 to Len(aCpos)
	SX3->(dbSeek(aCpos[nX]))
	If X3Uso(X3_USADO) .And. cNivel >= X3_NIVEL
		aAdd( aHeader, { Trim( X3Titulo() ),X3_CAMPO,X3_PICTURE,X3_TAMANHO,X3_DECIMAL,X3_VALID,X3_USADO,X3_TIPO,X3_ARQUIVO,X3_VISUAL,X3_CONTEXT})
	Endif
End 	

aAdd(aHeader, {"Rec No", "RNO", "", 12, 0, , , , "A", "R"})
// Tela de parametros
ValidPerg() 
Pergunte(cPerg,.F.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Conferencia de fretes")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa seleciona todas as notas fiscais vinculadas a "
@ 18,018 Say " romaneios de carga conforme os parametros informados.       "
@ 26,018 Say "                                                             "

@ 60,090 BMPBUTTON TYPE 01 ACTION Close(oGeraTxt)
@ 60,120 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered


// Monta o ACols conforme os dados
If (nOpc = 3) // Inclusão
 	SetKey(VK_F7,{||ORDENA()})
	SetKey(VK_F8,{||FILCPO(1)})
	SetKey(VK_F9,{||FILCPO(2)}) 
//winexec
//waitrun	
	SetKey(VK_F10,{||AbreEXC()})
	// Busco os codigos das empresas que estão vinculadas a um romaneio de carga.
	cSql := "SELECT ZZS.*, ZZS.R_E_C_N_O_ AS RNO FROM ZZSCMP ZZS "
	cSql += "WHERE ZZS.D_E_L_E_T_ <> '*' "
	cSql += "AND ZZS.ZZS_CODTRA BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
	cSql += "AND ZZS.ZZS_NUMROM BETWEEN '"+mv_par03+"' AND '"+mv_par04+"' "
	If mv_par05 = 1
		cSql += "AND ZZS.ZZS_NFSAI <> ' ' "
	Elseif mv_par05 = 2
		cSql += "AND ZZS.ZZS_NFSAI = ' ' "
	Endif
//Sql += "AND ZZS.ZZS_NFOK = 'S' AND ZZS.ZZS_NUMCTR = ' ' 
//	cSql += "AND ZZS"
	TCQUERY cSql NEW ALIAS "TMPZZS"
	
	TCSETFIELD("TMPZZS","ZZS_DTCTRC","D",08,0)
	TCSETFIELD("TMPZZS","ZZS_VENTIT","D",08,0)
	TCSETFIELD("TMPZZS","ZZS_DTFAT","D",08,0)	
	
	TMPZZS->(dbSelectArea("TMPZZS"))
	TMPZZS->(dbGoTop())
//	{ {"01", "01", "98"}, {"02", "01", "98"}}
	If !TMPZZS->(Eof())
		While !TMPZZS->(Eof())

			aAdd( aCOLS, Array( Len( aHeader ) + 1 ) )
			For nX := 1 to Len(aHeader)
				If AllTrim(aHeader[nX, 2]) == "ZZS_DTCTR"
					aCols[Len(aCols), nX] := TMPZZS->ZZS_DTFAT
				ElseIf AllTrim(aHeader[nX, 2]) == "ZZS_VLRCTR" 
					aCols[Len(aCols), nX] := Iif(TMPZZS->ZZS_VLRFIN > 0,TMPZZS->ZZS_VLRFIN,TMPZZS->ZZS_VALFRE)
				Else
					aCols	[Len(aCols), nX] := TMPZZS->(FieldGet(FieldPos(aHeader[nX, 2])))
				Endif
			Next nX			
			aCOLS[Len(aCOLS),Len(aHeader)+1] := .F.
			
			TMPZZS->(DbSelectArea("TMPZZS"))							
			TMPZZS->(DbSkip())
		End	
	Else
		If Select("TMPZZS") <> 0
			TMPZZS->(DbCloseArea("TMPZZS"))
		Endif
		Alert("Nenhuma carga encontrada. Verifique os parametros.")
		Return
	Endif
EndIf

_nCarga			:= 0
_nPasseio 		:= 0
ZZS->(DbSelectArea("ZZS"))
ZZS->(DbSetOrder(01))
DEFINE MSDIALOG oDlg1 TITLE cCadastro From 0,0 To 515, 1275 PIXEL OF oMainWnd
/*
@ 020,003 Say OemToAnsi("Carga:")
@ 020,030 Get _nCarga Picture "@E 999,999" Size 50,10 When .f.

@ 020,103 Say OemToAnsi("Passeio:")
@ 020,130 Get _nPasseio Picture "@E 999,999" Size 50,10 When .f.

@ 020,203 Say OemToAnsi("Total:")
@ 020,230 Get 0 Picture "@E 999,999" Size 50,10 When .f.
*/	
If nOpc = 3
//	@ 020,460 Say OemToAnsi("F7-Ordenar  F10- Marca Todos  F10- Marca Todos")
	@ 020,460 Say OemToAnsi("F7-Ordenar    F8-Filtrar    F9-Remover Excluidos   F10-Exporta p/ Excel")
Endif
//                                                       del  // "ZZS_NUMCTR","ZZS_DTCTRC","ZZS_NUMFAT","ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG"
oGet := MSGetDados():New(035,1,255,640,nOpc,,, "", .T.,{"ZZS_NUMCTR","ZZS_SERCTR","ZZS_DTCTRC","ZZS_NUMFAT",;
					"ZZS_VENTIT","ZZS_CANHOT","ZZS_VLRCTR","ZZS_FORMPG","ZZS_CODTRA"}, , .F., Len(aCols),)
oGet:oBrowse:nColPos


//ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| GrvEmb(nOpc), ODlg1:End(), Nil }, {|| oDlg1:End() },,aButtons)
ACTIVATE MSDIALOG oDlg1 ON INIT EnchoiceBar(oDlg1,{|| oDlg1:End()},{|| oDlg1:End() },,aButtons)
If Select("TMPZZS") <> 0
	TMPZZS->(DbCloseArea("TMPZZS"))
Endif

Return




          





Static Function Ordena()
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos 

if (nPosis > 0)
	ASort(aCols,,,{ |x,y| x[nPosis] < y[nPosis]})
EndIf     

Return Nil

/*
#############################################################################
### Efetua o filtro dos dados com base no campo posicionado               ###
#############################################################################
*/
Static Function FILCPO(_nOpc)
Local _aCols  := aCols
Local cVarAtu := ReadVar()
Local nPosis  := oGet:oBrowse:nColPos
//Local _nPFre		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})  // Valor do Frete
_nTotFre	:= 0

If nPosis > 0
	cComp	  := aCols[n,nPosis]
	aCols := {}
Endif
If _nOpc = 1
	If nPosis > 0
		For nR := 1 To Len(_aCols)             
			If _aCols[nR,nPosis] == cComp
				aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
				_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
				_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21],;
				_aCols[nR,22],_aCols[nR,23],_aCols[nR,24],_aCols[nR,25],_aCols[nR,26],_aCols[nR,27],_aCols[nR,28],_aCols[nR,29],;
				_aCols[nR,30],_aCols[nR,31],_aCols[nR,32]})
//			_nTotFre += _aCols[nR,_nPFre]			
			Endif
		Next nR
	Endif
Else
	For nR := 1 To Len(_aCols)             
		If !_aCols[nR,31]
			aAdd(aCols,{_aCols[nR,1],_aCols[nR,2],_aCols[nR,3],_aCols[nR,4],_aCols[nR,5],_aCols[nR,6],_aCols[nR,7],;
			_aCols[nR,8],_aCols[nR,9],_aCols[nR,10],_aCols[nR,11],_aCols[nR,12],_aCols[nR,13],_aCols[nR,14],;
			_aCols[nR,15],_aCols[nR,16],_aCols[nR,17],_aCols[nR,18],_aCols[nR,19],_aCols[nR,20],_aCols[nR,21],;
			_aCols[nR,22],_aCols[nR,23],_aCols[nR,24],_aCols[nR,25],_aCols[nR,26],_aCols[nR,27],_aCols[nR,28],_aCols[nR,29],;
			_aCols[nR,30],_aCols[nR,31],_aCols[nR,32]})
//		_nTotFre += _aCols[nR,_nPFre]			
		Endif
	Next nR
endif
dlgRefresh(oDlg1)
oGet:oBrowse:Refresh()

n:= 1
Return nil

Static Function AbreEXC()
Local n_NOMCLI	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NOMCLI"})
Local n_MUN		:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_MUN"})
Local n_UFCLI	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_UFCLI"})
Local n_TOTNF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})
Local n_NUMCTR	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NUMCTR"})
Local n_VALFRE	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFRE"})
Local n_VALFIN	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VALFIN"})
Local n_VLRCTR	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_VLRCTR"})
Local n_CODTRA	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_CODTRA"})
Local n_TRANSP	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TRANSP"})
Local n_NFSAI	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_NFSAI"})
Local n_DTFAT	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_DTFAT"})
Local n_TOTNF	:= aScan(aHeader,{|x| AllTrim(x[2]) == "ZZS_TOTNF"})
Private cArqTxt := "c:\frete.xls"
Private nHdl    := fCreate(cArqTxt)


Private cEOL    := "CHR(13)+CHR(10)"

If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    Return
Endif

//"ZZS_NOMEMP/ZZS_NOMFIL/ZZS_NUMROM/ZZS_PEDIDO/ZZS_NFSAI/ZZS_CLIENT/ZZS_NOMCLI/ZZS_TOTNF/ZZS_CODTRA/ZZS_TRANSP/ZZS_NUMCTR/ZZS_SERCTR/ZZS_DTCTRC/ZZS_NUMFAT/ZZS_VENTIT/ZZS_CANHOT/ZZS_SEGMEN/ZZS_CC/ZZS_VALFRE/ZZS_VLRFIN/ZZS_VLRCTR/ZZS_VLRDIF/ZZS_JUSVLD/ZZS_FORMPG/ZZS_CALCFR/ZZS_EMPRES/ZZS_FILORI/"
cLin    := "NUM_NF;DATA_CARREGAMENTO;NOME_CLIENTE;CIDADE_DESTINO;UF_DESTINO;VLR_NF;COD_TRANSPORTADORA;NOME_TRANSPORTADORA;"
cLin += cEOL
//aHeader[nPosCTR,1]
//Numero CTRC
 
fWrite(nHdl,cLin,Len(cLin))
For nR := 1 To Len(aCols)
//NUM_NF;DATA_CARREGAMENTO;NOME_CLIENTE;CIDADE_DESTINO;UF_DESTINO;VLR_NF;COD_TRANSPORTADORA;NOME_TRANSPORTADORA;
	cLin := AllTrim(aCols[nR,n_NFSAI])
	cLin += ";"
	cLin += DtoC(aCols[nR,n_DTFAT])
	cLin += ";" 
	cLin += AllTrim(aCols[nR,n_NOMCLI])
	cLin += ";" 
	cLin += AllTrim(aCols[nR,n_MUN])
	cLin += ";" 
	cLin += AllTrim(aCols[nR,n_UFCLI])
	cLin += ";" 
	cLin += AllTrim(Str(aCols[nR,n_TOTNF]))
	cLin += ";" 	
	cLin += AllTrim(aCols[nR,n_CODTRA])
	cLin += ";"
	cLin += AllTrim(aCols[nR,n_TRANSP])		
	cLin += ";"
	cLin += cEOL 	
	fWrite(nHdl,cLin,Len(cLin))
Next nR

fClose(nHdl)

oExcelApp:= MsExcel():New()
oExcelApp:WorkBooks:Open(cArqTxt)
oExcelApp:SetVisible(.T.)

Return nil

Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
aAdd(aRegs,{cPerg,"01","Transp. Inicial  ","","","mv_ch1","C",06,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SA4","",""})
aAdd(aRegs,{cPerg,"02","Transp. Final    ","","","mv_ch2","C",06,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","SA4","",""})
aAdd(aRegs,{cPerg,"03","Carga Inicial    ","","","mv_ch3","C",09,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Carga Final      ","","","mv_ch4","C",09,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Com NF Emitida  ?","","","mv_ch5","N",01,0,0,"C","        ","mv_par05","Sim","Sim","Sim","","","Não","Não","Não","","","Ambos","Ambos","Ambos","","","","","","","","","","","","",""})


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