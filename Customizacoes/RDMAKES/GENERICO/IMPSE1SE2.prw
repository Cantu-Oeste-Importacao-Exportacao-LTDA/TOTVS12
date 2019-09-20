#include "rwmake.ch" 
#include "colors.ch"
#include "Topconn.ch"
#include "Protheus.ch"
// \\192.168.0.106\Protheus10\Fontes2010\Generico


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPSE1SE2 º Autor ³ Adriano Novachaelley Data ³  04/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Importação de SE1 e SE2 para o protheus novo. Substituindo º±±
±±º          ³ codigo do cliente pelo CNPJ/CPF.                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 		                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IMPSE1SE2()
Local aCli := {}
Private cFile := 	Space(100)    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

    
@ 140,100 TO 300,430 DIALOG oDlg1 TITLE "Importação de Fornecedores/Clientes"
@ 010,010 Say "O arquivo DTC:" PIXEL
@ 010,070 Get cFile Size 60, 10 PIXEL
@ 010,140 BUTTON "..." SIZE 10, 10 ACTION (cFile := cGetFile( "DTC | *.DTC" , "Selecione o arquivo DTC", 0,"",.T.)) PIXEL
@ 065,100 BMPBUTTON TYPE 1 ACTION Processa({|| ProcArq() })
@ 065,130 BMPBUTTON TYPE 2 ACTION Finaliza()
ACTIVATE DIALOG oDlg1 CENTER
    
Return()

Static Function ProcArq()
Local cNameFile := Upper(RetFileName(cFile))
if SubStr(cNameFile, 1, 3) == 'SE1'
	ProcSE1()
Else
	ProcSE2()
EndIf
Return

Static Function ProcSE1()
MsOpEndbf(.T.,__LOCALDRIVER,cFile,"TMPSE1",.F.,.F.,.F.,.F.)

ProcRegua(LastRec())
While TMPSE1->(!Eof())
	IncProc()
 	RecLock("SE1",.T.)
	For nR := 1 To SE1->(fCount())
		_cCampo := SE1->(FieldName(nR))
		If _cCampo	$ "E1_CLIENTE/E1_LOJA"		  
			_cCOD	:= SubStr(TMPSE1->E1_CGC,1,iif(Len(AllTrim(TMPSE1->E1_CGC))=14,8,9))
			_cLoja	:= Iif(Len(AllTrim(TMPSE1->E1_CGC))=14,SubStr(TMPSE1->E1_CGC,9,4),"0001")
	    	SE1->E1_CLIENTE	:= _cCOD
	    	SE1->E1_LOJA	:= _cLoja
	 	Else
			nPosicao  := TMPSE1->(FieldPos(_cCampo))
			// verifica se ambos os alias possuem 
			If nPosicao > 0 .And. SE1->(FieldPos(_cCampo)) > 0
				SE1->(FieldPut(nR, TMPSE1->&_cCampo)) 
			Endif
		Endif
	Next nR
  	MsUnlock("SE1")
	TMPSE1->(dbskip())
EndDo

Close(oDlg1)

TMPSE1->(dbCloseArea())


Return

// Processar arquivos de fornecedor          
Static Function ProcSE2()
Local lSomenteEx := MsgBox("Importar somente sem CNPJ","Imp. Fornecedores","YESNO")

SE2->(dbSetOrder(01))
MsOpEndbf(.T.,__LOCALDRIVER,cFile,"TMPSE2",.F.,.F.,.F.,.F.)

ProcRegua(LastRec())
While TMPSE2->(!Eof())
	IncProc()
	// Nao importa os fornecedores do exterior devido a eles nao ter codigo e duplicar o registro na se2
	if Empty(TMPSE2->E2_CGC) .Or. TMPSE2->E2_CGC == "NAOIMP"
		if SE2->(!dbSeek(xFilial("SE2") + TMPSE2->E2_PREFIXO + ;
				TMPSE2->E2_NUM + TMPSE2->E2_PARCELA + TMPSE2->E2_TIPO + TMPSE2->E2_FORNECE + TMPSE2->E2_LOJA))
				            
			RecLock("SE2",.T.)
			For nR := 1 To SE2->(fCount())
				_cCampo := SE2->(FieldName(nR))
				
					nPosicao  := TMPSE2->(FieldPos(_cCampo))
					// Verifica se ambos os alias possuem 
					If nPosicao > 0 .And. SE2->(FieldPos(_cCampo)) > 0
						SE2->(FieldPut(nR, TMPSE2->&_cCampo)) 
					Endif
				
			Next nR		
			MsUnlock("SE2")
		else
			RecLock("TMPSE2", .F.)
			TMPSE2->E2_CGC := "NAOIMP"
			TMPSE2->(MsUnlock())
		EndIf
		TMPSE2->(dbskip())
		Loop
	Endif
	
	if !Empty(TMPSE2->E2_CGC) .And. lSomenteEx .And. TMPSE2->E2_CGC != "NAOIMP"
		TMPSE2->(dbskip())
		Loop
	EndIf
	
 	RecLock("SE2",.T.)
	For nR := 1 To SE2->(fCount())
		_cCampo := SE2->(FieldName(nR))
		If _cCampo	$ "E2_FORNECE/E2_LOJA"
			_cCOD	:= SubStr(TMPSE2->E2_CGC,1,iif(Len(AllTrim(TMPSE2->E2_CGC))=14,8,9))
			_cLoja	:= Iif(Len(AllTrim(TMPSE2->E2_CGC))=14,SubStr(TMPSE2->E2_CGC,9,4),"0001")
	  	SE2->E2_FORNECE	:= _cCOD
	  	SE2->E2_LOJA	:= _cLoja
	 	Else
			nPosicao  := TMPSE2->(FieldPos(_cCampo))
			// Verifica se ambos os alias possuem 
			If nPosicao > 0 .And. SE2->(FieldPos(_cCampo)) > 0
				SE2->(FieldPut(nR, TMPSE2->&_cCampo)) 
			Endif
		Endif
	Next nR
 	MsUnlock("SE2")
	TMPSE2->(dbskip())
EndDo

Close(oDlg1)

TMPSE2->(dbCloseArea())

Return