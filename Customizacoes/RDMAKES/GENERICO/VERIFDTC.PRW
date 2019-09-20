#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"

User Function VERIFDTC()
Local oDlg1

Private cArqOri := Space(6)
Private cArqComp := Space(6)
Private cArqDif := Space(12) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 400,430 DIALOG oDlg1 TITLE "Comparacao de arquivos"
@ 005,005 TO 060,160
@ 020,010 Say "Arquivo Origem"
@ 020,100 Get cArqOri Size 30, 50
@ 030,010 Say "Arquivo Comparar"
@ 030,100 Get cArqComp Size 30, 50
@ 040,010 Say "Arquivo Diferenca"
@ 040,100 Get cArqDif Size 30, 50
@ 050,010 Say "Arquivos precisam estar na pasta \COMPARAR\"
@ 065,010 BUTTON "Ver X3Ok" Size 30, 10 ACTION Processa( {|| VerX3Ok() } ) 
@ 065,060 BUTTON "Ver Grp" Size 30, 10 ACTION Processa( {|| VerGrupo() } ) 
@ 065,110 BUTTON "Repl Sx2" Size 30, 10 ACTION Processa( {|| CopySX2() } ) 
@ 095,100 BMPBUTTON TYPE 1 ACTION Processa( {|| ProcArq() } ) 
@ 095,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return()

Static Function ProcArq()
Local nArqDif 	:= fCreate("c:\log" + cArqDif + ".txt") // Local para log tabela SA1500
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cChave := ""
Local cIniArq := upper(SubStr(cArqOri, 1, 3))

if cIniArq == "SIX"
	cChave := "AllTrim(INDICE+ORDEM+CHAVE)"
elseif cIniArq == "SX2"
	cChave := "X2_CHAVE"
elseif cIniArq == "SX3"
	cChave := "X3_ARQUIVO+X3_CAMPO"
elseif cIniArq == "SX7"
	cChave := "X7_CAMPO+X7_SEQUENC"
elseif cIniArq == "SXA"
	cChave := "XA_ALIAS+XA_ORDEM"
elseif cIniArq == "SXB"
	cChave := "XB_ALIAS+XB_TIPO+XB_SEQ+XB_COLUNA"
EndIf	
     
if Empty(cChave)
	Alert("Chave nao definida para o tipo de arquivo")
	Return
EndIf

If Empty(cEOL)
	cEOL := CHR(13)+CHR(10)
Else
	cEOL := Trim(cEOL)
	cEOL := &cEOL
Endif

// ALIASES A TRABALHAR                       
cNomArq1 := CriaTrab(nil,.f.) // GetNextAlias()
cNomArq2 := CriaTrab(nil,.f.) // GetNextAlias()
                           
if !File("\COMPARAR\" + cArqOri+GetDBExtension())
	Alert("Arquivo origem \COMPARAR\" + cArqOri + " não existe!")
	Return
EndIf

if !File("\COMPARAR\" + cArqComp+GetDBExtension())
	Alert("Arquivo a comparar \COMPARAR\" + cArqComp + " não existe!")
	Return
EndIf
                      
// ABRE E INDEXA OS DBF
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqOri,"TMPORI",.F.,.F.,.F.,.F.)
//dbSelectArea("TMPORI")
IndRegua("TMPORI",cNomArq1,cChave,,,"Criando Indice Origem...")
TMPORI->(dbSetIndex(cNomArq1+OrdBagExt()))
                       
// ABRE O ARQUIVO A SER COMPARADO
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqComp,"TMPCMP",.F.,.F.,.F.,.F.)
//dbSelectArea("TMPCMP")
IndRegua("TMPCMP",cNomArq2,cChave,,,"Criando Indice comparacao...")
TMPCMP->(dbSetIndex(cNomArq2+OrdBagExt()))


cArqTrbS := CriaTrab( TMPORI->(dbStruct()),.T. )
dbUseArea( .T.,, cArqTrbS,"TRBDIF", .T. , .F. )

ProcRegua(TMPORI->(LastRec()))
//TMPORI->(dbSetOrder(01))
//TMPCMP->(dbSetOrder(01))
nCont := 0
dbSelectArea("TMPORI")
While TMPORI->(!Eof())
	IncProc("Processados "+ cArqOri + " ("+Str(nCont)+")")
	if !TMPCMP->(dbSeek(TMPORI->&cChave))		
		cLin := "Campo " + TMPORI->&cChave + "não encontrado em " + cArqComp
		cLin += cEOL 
		fWrite(nArqDif,cLin,Len(cLin))		    
		
		CopyToTrb(cArqTrbS)
	EndIf
	TMPORI->(dbSkip())
	nCont++
EndDo

dbSelectArea("TRBDIF")
cDestino := "\RESCOMPARA\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf

_cArq := cDestino + AllTrim(cArqDif)

If File(_cArq)
	FErase(_cArq+GetDBExtension())
EndIf

COPY TO &(_cArq)
TRBDIF->(dbCloseArea())

MsgInfo("Arquivo de diferenças copiado para " + _cArq)

/*if MsgBox("Apendar diferenças no arquivo?", "Compara DTC", "YESNO")
	// faz a adicao das diferenças no arquivo
	TRBDIF->(dbGoTop())	
EndIf*/

TMPORI->(dbCloseArea())
TMPCMP->(dbCloseArea())

fErase(cNomArq2+OrdBagExt())
fErase(cNomArq1+OrdBagExt())
      
FClose(nArqDif)

FErase(cArqTrbS+GetDBExtension())

Return

Static Function CopyToTrb()
Local i
Local cCampo
RecLock("TRBDIF", .T.)
For i:= 1 to TMPORI->(FCount())
	TRBDIF->(FieldPut(i, TMPORI->(FieldGet(i))))
Next
TRBDIF->(MsUnlock())
Return

/*****************************************************/
// Acerta a ordem do alias, primeiro por campo e alias e depois por ordem sequencial dos itens
/****************************************************/
Static Function VerOrdem()
Local nArqDif 	:= fCreate("c:\log" + cArqDif + ".txt") // Local para log tabela SA1500
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cChave := ""
Local cIniArq := upper(SubStr(cArqOri, 1, 3))

cEOL := &cEOL

if cIniArq == "SIX"
	cChave := "AllTrim(INDICE+ORDEM+CHAVE)"
elseif cIniArq == "SX2"
	cChave := "X2_CHAVE"
elseif cIniArq == "SX3"
	cChave := "X3_ARQUIVO+X3_CAMPO"
EndIf	
     
if Empty(cChave)
  Alert("Chave nao definida para o tipo de arquivo")
  Return
EndIf


// ALIASES A TRABALHAR                       
cNomArq1 := CriaTrab(nil,.f.) // GetNextAlias()
cNomArq2 := CriaTrab(nil,.f.) // GetNextAlias()
                           
if !File("\COMPARAR\" + cArqOri+GetDBExtension())
	Alert("Arquivo origem \COMPARAR\" + cArqOri + " não existe!")
	Return
EndIf

// abre o arquivo a se corrigido
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqOri,"TMPORI",.F.,.F.,.F.,.F.)

cChave := "X3_ARQUIVO+X3_ORDEM"

IndRegua("TMPORI",cNomArq2,cChave,,,"Criando Indice Ordem...")
TMPORI->(dbSetIndex(cNomArq2+OrdBagExt()))
     
ProcRegua(TMPORI->(LastRec()))
cChaveAnt := ""
nCont := 0  
nCountDup := 0
dbSelectArea("TMPORI")
While TMPORI->(!Eof())
	IncProc("Processados "+ cArqOri + " ("+Str(nCont)+")")
	For i:= 1 to TMPORI->(FCount())
		cField := TMPORI->(FieldName(i))
	
	Next
	
	
	if !Empty(cChaveAnt) .And. (cChaveAnt == TMPORI->&cChave)
	  cLin := "Campo " + TMPORI->&cChave + " com ordem duplicado  para " + cArqOri
		cLin += cEOL 
		fWrite(nArqDif,cLin,Len(cLin))		    
		nCountDup ++
	EndIf
	cChaveAnt := 	TMPORI->&cChave
	TMPORI->(dbSkip())
	nCont++
EndDo
                
MsgInfo(Str(nCountDup) + " registros com ordem duplicada")

fClose(nArqDif)
TMPORI->(dbCloseArea())

fErase(cNomArq2+OrdBagExt())
fErase(cNomArq1+OrdBagExt())
Return Nil

/*****************************************************/
// Acerta a ordem do alias, primeiro por campo e alias e depois por ordem sequencial dos itens
/****************************************************/
Static Function VerGrupo()
Local nArqDif 	:= fCreate("c:\log\log" + cArqDif + ".txt") // Local para log tabela SA1500
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cChave := ""
Local cIniArq := upper(SubStr(cArqOri, 1, 3))

cEOL := &cEOL

if cIniArq == "SX3"
	cChave := "X3_GRPSXG"
EndIf	
     
if Empty(cChave)
  Alert("Chave nao definida para o tipo de arquivo")
  Return
EndIf


// ALIASES A TRABALHAR                       
cNomArq1 := CriaTrab(nil,.f.) // GetNextAlias()
cNomArq2 := CriaTrab(nil,.f.) // GetNextAlias()
                           
if !File("\COMPARAR\" + cArqOri+GetDBExtension())
	Alert("Arquivo origem \COMPARAR\" + cArqOri + " não existe!")
	Return
EndIf

// abre o arquivo a se corrigido
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqOri,"TMPORI",.F.,.F.,.F.,.F.)

// abre o arquivo de ordens
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqComp,"TMPORD",.F.,.F.,.F.,.F.)

// cChave := "X3_ARQUIVO+X3_ORDEM"

IndRegua("TMPORI",cNomArq2,cChave,,,"Criando Indice Ordem...")
TMPORI->(dbSetIndex(cNomArq2+OrdBagExt()))
     
ProcRegua(TMPORI->(LastRec()))
cChaveAnt := ""
nCont := 0  
nCountDup := 0
dbSelectArea("TMPORI")
While TMPORD->(!Eof())
	TMPORI->(dbSeek(TMPORD->XG_GRUPO))
	While TMPORI->(!Eof()) .And. (TMPORI->&cChave == TMPORD->XG_GRUPO)
		IncProc("Processados "+ cArqOri + " ("+Str(nCont)+")")
		if TMPORI->X3_TAMANHO <> TMPORD->XG_SIZE
		  cLin := "Campo " + TMPORI->X3_CAMPO + " com tamanho incorreto no sxg " + AllTrim(Str(TMPORI->X3_TAMANHO)) + " (" + AllTrim(Str(TMPORD->XG_SIZE)) + ") " + cArqOri
			cLin += cEOL 
			fWrite(nArqDif,cLin,Len(cLin))		    
			nCountDup ++
		EndIf
		cChaveAnt := 	TMPORI->&cChave
		TMPORI->(dbSkip())
		nCont++
	EndDo
	TMPORD->(dbSkip())
EndDo
                
MsgInfo(Str(nCountDup) + " registros com sx3 com campos errados")

fClose(nArqDif)
TMPORI->(dbCloseArea())

TMPORD->(dbCloseArea())

fErase(cNomArq2+OrdBagExt())
fErase(cNomArq1+OrdBagExt())
Return Nil

Static Function CopySX2()
Local cChave := ""
Local cIniArq := upper(SubStr(cArqOri, 1, 3))
Local aEmpFile := {}
Local cAliasTmp := "TMPTRB"
Local nI := 1

aAdd(aEmpFile, "000")
aAdd(aEmpFile, "070")
aAdd(aEmpFile, "080")
aAdd(aEmpFile, "090")
aAdd(aEmpFile, "100")
aAdd(aEmpFile, "200")
aAdd(aEmpFile, "300")
aAdd(aEmpFile, "310")
aAdd(aEmpFile, "400")
aAdd(aEmpFile, "600")
aAdd(aEmpFile, "700")

cArqOri := 'sx2500' // sempre como parao o sx2500

cChave := "X2_CHAVE"

If !MsgBox("Replicar arquivo SX2 para as outras empresas com base na 50?", "Replicar SX2", "YESNO")
	Return
EndIf
                         
if !File("\comparar\" + cArqOri+GetDBExtension())
	Alert("Arquivo origem \comparar\" + cArqOri + " não existe!")
	Return
EndIf
                      
// ABRE E INDEXA OS DBF                                               
MsOpEndbf(.T.,"CTREECDX","\comparar\" + cArqOri,"TMPORI",.F.,.F.,.F.,.F.)

cArqTmp := CriaTrab(TMPORI->(dbStruct()), .T. )
DbUseArea(.T.,__LocalDriver,cArqTmp,,.T.,.F.)  

//Use (cArqTmp) alias cAliasTmp

(cArqTmp)->(dbSelectArea(cArqTmp))

// o comando abaixo apenda o sx2 no arquivo atual
APPEND FROM TMPORI
        
// apaga os SX2s atuais da pasta sx2ok
CurDir("\system")

cDiretorio := "\sx2ok"

if !ExistDir(cDiretorio)
	MakeDir(cDiretorio)
EndIf

ProcRegua(9)
// controla a empresa base que se encontra os nomes dos arquivos atuais
cEmpOld := "500"
For nI := 1 to len(aEmpFile)
	IncProc("Processando arquivo sx2"+ aEmpFile[nI])
	cFileNew := cDiretorio + "\sx2" + aEmpFile[nI] + GetDBExtension()
	if File(cFileNew)
		FErase(cFileNew)
	EndIf
	// FRename("\system\sx2" + cEmpFile + GetDBExtension() , cFileNew)
	(cArqTmp)->(dbGoTop())
	while (cArqTmp)->(!Eof())
		if Substr((cArqTmp)->X2_ARQUIVO, 4, 3) == cEmpOld
			RecLock((cArqTmp), .F.)
			(cArqTmp)->X2_ARQUIVO := (cArqTmp)->X2_CHAVE + aEmpFile[nI]
			(cArqTmp)->(MsUnlock())
		EndIf
		(cArqTmp)->(dbskip())
	EndDo
	                 
	// faz a copia
	(cArqTmp)->(dbSelectArea(cArqTmp))
	COPY TO &cFileNew	
	
	cEmpOld := aEmpFile[nI]
Next nI

(cArqTmp)->(dbCloseArea())

// CopyToEmps(cArqOri)

MsgInfo("Arquivo SX2 replicado para todas as empresas")

TMPORI->(dbCloseArea())

Return Nil

Static Function CopyToEmps()
Local cDestino := "\sx2ok\"
Local cDes1 := cDestino + SubStr(cArqOri, 1, 3)  + "070"
Local cDes2 := cDestino + SubStr(cArqOri, 1, 3)  + "080"
Local cDes3 := cDestino + SubStr(cArqOri, 1, 3)  + "090"
Local cDes4 := cDestino + SubStr(cArqOri, 1, 3)  + "100"
Local cDes5 := cDestino + SubStr(cArqOri, 1, 3)  + "200"
Local cDes6 := cDestino + SubStr(cArqOri, 1, 3)  + "300"
Local cDes7 := cDestino + SubStr(cArqOri, 1, 3)  + "310"
Local cDes8 := cDestino + SubStr(cArqOri, 1, 3)  + "400"
Local cDes8 := cDestino + SubStr(cArqOri, 1, 3)  + "500"
Local cDes9 := cDestino + SubStr(cArqOri, 1, 3)  + "600"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf

// _cArq := cDestino + AllTrim(cArqDif)
dbSelectArea("TMPORI")

COPY TO &(cDes1)
COPY TO &(cDes2)
COPY TO &(cDes3)
COPY TO &(cDes4)
COPY TO &(cDes5)
COPY TO &(cDes6)
COPY TO &(cDes7)
COPY TO &(cDes8)
COPY TO &(cDes9)

Return


Static Function VerX3Ok()
Local nArqDif 	:= fCreate("c:\log\log" + cArqDif + ".txt") // Local para log tabela SA1500
Local cEOL    	:= "CHR(13)+CHR(10)"
Local cChave := ""
Local cIniArq := upper(SubStr(cArqOri, 1, 3))
Local aCampos := {"X3_TIPO", "X3_TAMANHO", "X3_DECIMAL", "X3_PICTURE"}

cEOL := &cEOL

if cIniArq == "SX3"
	cChave := "X3_ARQUIVO+X3_CAMPO"
EndIf	
     
if Empty(cChave)
  Alert("Chave nao definida para o tipo de arquivo")
  Return
EndIf


// ALIASES A TRABALHAR                       
cNomArq1 := CriaTrab(nil,.f.) // GetNextAlias()
cNomArq2 := CriaTrab(nil,.f.) // GetNextAlias()
                           
if !File("\COMPARAR\" + cArqOri+GetDBExtension())
	Alert("Arquivo origem \COMPARAR\" + cArqOri + " não existe!")
	Return
EndIf

// abre o arquivo a se corrigido
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqComp,"TMPORI",.F.,.F.,.F.,.F.)

// abre o arquivo de ordens
MsOpEndbf(.T.,"CTREECDX","\COMPARAR\" + cArqOri,"TMPORD",.F.,.F.,.F.,.F.)

// cChave := "X3_ARQUIVO+X3_ORDEM"

IndRegua("TMPORI",cNomArq2,cChave,,,"Criando Indice Ordem...")
TMPORI->(dbSetIndex(cNomArq2+OrdBagExt()))
     
ProcRegua(TMPORI->(LastRec()))
cChaveAnt := ""
nCont := 0
nCountDup := 0

cArqTrbS := CriaTrab( TMPORI->(dbStruct()),.T. )
dbUseArea( .T.,, cArqTrbS,"TRBDIF", .T. , .F. )

dbSelectArea("TMPORI")
While TMPORD->(!Eof())
	IncProc("Processados "+ cArqOri + " ("+Str(nCont)+")")
	if TMPORI->(dbSeek(TMPORD->X3_ARQUIVO+TMPORD->X3_CAMPO))
		lAdicionado := .F.
		For i:= 1 to len(aCampos)//TMPORD->(FCount())
			cCampo := aCampos[i] // TMPORD->(FieldName(i))
			if TMPORD->&cCampo <> TMPORI->&cCampo
				cVal1 := TMPORD->&cCampo
				cVal2 := TMPORI->&cCampo
				
				if ValType(cVal1) != "C"
					cVal1 := AllTrim(Str(cVal1))
				EndIf
				
				if ValType(cVal2) != "C"
					cVal2 := AllTrim(Str(cVal2))
				EndIf
				
				cLin := "Campo " + TMPORD->X3_CAMPO + " com divergencias (XG  " + TMPORD->X3_GRPSXG + ")em " + cCampo + " de " + cVal1 + " para " + cVal2
				cLin += cEOL 
				fWrite(nArqDif,cLin,Len(cLin))				
				lAdiconado := .T.
				if !lAdicionado
					CopyToTrb(cArqTrbS)
				EndIf
			EndIf
		Next
	else
		cLin := "Campo " + TMPORD->X3_CAMPO + " no encontrado "
		cLin += cEOL 
		fWrite(nArqDif,cLin,Len(cLin))		    
	EndIf 
	TMPORD->(dbSkip())
	nCont++	
EndDo
     
dbSelectArea("TRBDIF")
cDestino := "\RESCOMPARA\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf

_cArq := cDestino + AllTrim(cArqDif)

If File(_cArq)
	FErase(_cArq+GetDBExtension())
EndIf

COPY TO &(_cArq)
TRBDIF->(dbCloseArea())

fClose(nArqDif)
TMPORI->(dbCloseArea())

TMPORD->(dbCloseArea())

fErase(cNomArq2+OrdBagExt())
fErase(cNomArq1+OrdBagExt())                          

MsgInfo("Arquivo de diferenças copiado para " + _cArq)

Return NIl