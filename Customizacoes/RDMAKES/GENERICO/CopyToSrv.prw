#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"

User Function CopyToSrv()
Local oDlg1
Private cArqOri := Space(60)
Private cDirCopy := Space(60)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Copiar arquivo para o servidor"
@ 005,005 TO 060,160
@ 010,010 Say "Arquivo:"
@ 010,050 Get cArqOri Size 92, 30
@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cArqOri := cGetFile( "* | *.*" , "Selecione o arquivo DTC", 0,"",.T.))
@ 030,010 Say "Diretorio Server"
@ 030,050 Get cDirCopy Size 100, 30
@ 055,100 BMPBUTTON TYPE 1 ACTION Processa( {|| ProcArq() } ) 
@ 055,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return()

Static Function ProcArq()

if !ExistDir(cDirCopy)
	MakeDir(cDirCopy)
EndIf

if CPYT2S(cArqOri, cDirCopy, .F.)
	MsgInfo("Arquivo Copiado")
else
	Alert("Erro ao copiar o arquivo")
EndIf
Return


User Function CopyToLoc()
Local oDlg1

Private cArqOri := Space(60)
Private cDirCopy := Space(60)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Copiar arquivo para diretorio local"
@ 005,005 TO 060,160
@ 010,010 Say "Arquivo:"
@ 010,050 Get cArqOri Size 92, 30
@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cArqOri := cGetFile( "* | *.*" , "Selecione o arquivo DTC", 0,"",.T.))
@ 030,010 Say "Diretorio Local"
@ 030,050 Get cDirCopy Size 100, 30
@ 055,100 BMPBUTTON TYPE 1 ACTION Processa( {|| ProcArqLoc() } )
@ 055,130 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1 CENTER
Return()

Static Function ProcArqLoc()
if !ExistDir(cDirCopy)
	MakeDir(cDirCopy)
EndIf

if CPYS2T(cArqOri, cDirCopy, .F.)
	MsgInfo("Arquivo Copiado")
else
	Alert("Erro ao copiar o arquivo")
EndIf
Return