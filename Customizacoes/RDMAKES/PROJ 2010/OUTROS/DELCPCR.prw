#INCLUDE "rwmake.ch"

*----------------------
User Function DELCPCR()
*----------------------

Local cPrefixo := Space(3)
Local cNumero  := Space(6)                        
Local cParcela := Space(2)
Local cTipo    := Space(3)
Private lSE1 := .f.
Private lSE2 := .f.     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

PswOrder(2)  // nome do usuario .. //
If PswSeek( AllTrim(cUserName),.t.)  // cUserName = Usuario Logado.. //
	If cUserName <> "Raquel"	
		MsgBox("Rotina não disponivel para este usuário!")
		Return 
	Endif
Endif

	@ 140,040 TO 400,600 DIALOG oDlg1 TITLE "Exclusão de CP/RC"         
	@ 20,020  CHECKBOX "Contas a Pagar"   VAR lSE2
	@ 30,020  CHECKBOX "Contas a Receber" VAR lSE1                     
    @ 40, 020 Say "Prefixo:"
    @ 50, 020 Say "Numero :"
    @ 60, 020 Say "Parcela:"   
    @ 70, 020 Say "Tipo   :"

    @ 40,080  Get cPrefixo  size 40,10
    @ 50,080  Get cNumero   size 40,10
    @ 60,080  Get cParcela  size 40,10
    @ 70,080  Get cTipo     size 40,10

	@ 90,050 BMPBUTTON TYPE 1 ACTION Processa( {|| ExcTit(lSE1,lSE2,cPrefixo,cNumero,cParcela,cTipo) } ) 
	
 	ACTIVATE DIALOG oDlg1 
	
	
	
Return

      

*-----------------------------------------------------------------
Static Function ExcTit(lSE1,lSE2,cPrefixo,cNumero,cParcela,cTipo)
*-----------------------------------------------------------------

If lSE1
	dbSelectArea("SE1")
	dbSetOrder(1)
	dbGoTop()	
	If dbSeek(xFilial("SE1")+cPrefixo+cNumero+cParcela+cTipo)
		RecLock("SE1",.f.)
        SE1->(dbDelete())
        SE1->(MsUnlock())  
        MsgBox("Titulo Excluido! Chave: "+cPrefixo+"-"+cNumero+"-"+cParcela+"-"+cTipo)
	Else
		MsgBox("Titulo não localizado!")
  	Endif
EndIf                                        
 
If lSE2
	dbSelectArea("SE2")
	dbSetOrder(1)
	dbGoTop()	
	If dbSeek(xFilial("SE2")+cPrefixo+cNumero+cParcela+cTipo)
		RecLock("SE2",.f.)
        SE2->(dbDelete())
        SE2->(MsUnlock())  
        MsgBox("Titulo Excluido! Chave: "+cPrefixo+"-"+cNumero+"-"+cParcela+"-"+cTipo)
	Else
		MsgBox("Titulo não localizado!")
  	Endif
EndIf                                        
	
	

Return 