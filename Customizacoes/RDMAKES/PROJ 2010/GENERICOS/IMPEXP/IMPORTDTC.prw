#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include "rwmake.ch"
// Importa Tabelas CTREE para TopConnect
 
*------------------------------*
User Function IMPORTDTC()
*------------------------------*
Private cOrigem := "\tabgpe\"+Space(50)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importar arquivos"
// @ 005,005 TO 060,160
@ 010,010 Say "Diretorio:" PIXEL
@ 010,070 Get cOrigem Size 60, 10 PIXEL
//@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "DTC | *.dtc" , "Selecione o arquivo DTC", 0,"",.T.)) PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION Processa( {|| fCheckTab() })
@ 065,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER


//If MsgBox("Efetuar a importacao dos arquivos GPE para o Banco?","Importar arquivos GPE","YESNO")
	
//EndIf
Return

*------------------------------*
Static Function fCheckTab()
*------------------------------*
Local aTables := {}
dbSelectArea("SX2")

SX2->(dbGoTop())

// a tabela TMR nao pode ser incluida devido a ela ser criada automaticamente, porém com dados errados.
While SX2->(!Eof())                                                                  
	if (SubStr(SX2->X2_CHAVE, 1, 2) $ "SR/SP/SQ/TL/TM/TN/TO/RC/" .Or. SX2->X2_CHAVE $ "LA1/RB7/RB8/RF0/RFE/RFB/SPG/SPH") .And. !(SX2->X2_CHAVE $ "TMR")
		aAdd(aTables,{SX2->X2_CHAVE}) 
	EndIf
	SX2->(dbSkip()) 
EndDo

ProcRegua(len(aTables))
 
 // Empresas
	nI := 1  
	cSTREMP := StrZero(nI,2)
  
	cOri := AllTrim(cOrigem)

	If !File(cOri)
		MAKEDIR(cOri)
	EndIf
     
	For nJ := 1 to Len(aTables)
		cArquivo := RetSqlName(aTables[nJ,1]) // +cSTREMP+"0"  
  	
		IncProc("Processando tabela "+ cArquivo)       
  	
		cFile := lower(cOri + cArquivo + GetDBExtension())
  	  	
		If File(cFile)
			
   		// limpa a tabela
			ExecDelete(aTables[nJ,1])
			
    	MsOpEndbf(.T.,"CTREECDX",cFile,"TAB",.F.,.F.,.F.,.F.)
    
    	CopyToTbl(aTables[nJ,1])
    	
    	
   	EndIf  
 
  Next nJ
   
 MsgInfo("Importado tabelas do diretorio " + cOri)

Return

// Faz um append da tabela dtc no top, limpando os dados dela antes
Static Function CopyToTbl(cTab)
// abre a tabela
     
TAB->(DbSelectArea("TAB"))
TAB->(DbGotop())

TAB->(dbGoTop())
While TAB->(!Eof())
	RecLock(cTab,.T.)
	for iX := 1 to TAB->(FCount())
		cCampo := TAB->(FieldName(iX))
		nPos := (cTab)->(FieldPos(cCampo))
		if (nPos > 0)
			// seta o campo
			(cTab)->(FieldPut(nPos, TAB->&cCampo))
		EndIf
	Next
//	(cTab)->(DBCOMMIT())
	(cTab)->(MsUnLock())
	TAB->(dbSkip())
EndDo
TAB->(dbCloseArea())
dbSelectArea(cTab)
dbCloseArea()
Return

static Function ExecZap(cTab)
cTabela := RetSqlName(cTab)
cAlias := "TMPTBL"
USE (cTabela) ALIAS (cAlias) EXCLUSIVE NEW VIA "TOPCONN"
If NetErr()
	MsgStop("Nao foi possivel abrir "+cTabela+" em modo EXCLUSIVO.")
Else
	ZAP
USE
Endif
Return

Static Function ExecDelete(cTab)
Local cSql := "Drop Table " + RetSqlName(cTab)
Local cSqlDel := "Delete from " + RetSqlName(cTab)
//if select(cTab) > 0
//TcSqlExec(cSql)
// exclui a tabela
if !TcDelFile(RetSqlName(cTab))
	//Alert("Não foi possível abrir tabela " + RetSqlName(cTab))
	TcSqlExec(cSqlDel) // se nao excluiu, exclui os registros
EndIf
dbSelectArea(cTab)
//EndIf
Return