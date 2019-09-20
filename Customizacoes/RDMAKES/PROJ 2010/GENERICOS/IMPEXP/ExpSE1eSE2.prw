#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include "rwmake.ch"
// Exporta tabela SE1 do TOP para CTREE
User Function ExpSE1()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Efetuar a cópia do arquivo SE1 para DTC?","Copia Arquivo SE1","YESNO")
	Processa( {|| fExpSE1() })
EndIf
Return

*------------------------------*
Static Function fExpSE1()     
*------------------------------*
Local aTables 	:= {}
Local aTempStru	:= {}
Local aEstrSE1	:= {}
  
DbSelectArea("SE1")
aEstrSE1 	:= SE1->(dbStruct())
aTempStru 	:= SE1->(dbStruct())

Aadd(aTempStru,{"E1_CGC","C",014,0})
cArqTrab3 := CriaTrab(aTempStru,.T.)
DbUseArea(.T.,__LocalDriver,cArqTrab3,,.T.,.F.)  
//DbUseArea(.T.,"CTREECDX",cArqTrab3,,.T.,.F.)

cDestino := "\TABSE1\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf
     
dbSelectArea("SE1")
SE1->(dbSetFilter({|| E1_SALDO > 0},'E1_SALDO > 0'))         
DbSelectArea(cArqTrab3)
APPEND FROM SE1
DbSelectArea(cArqTrab3)
DbGotop()
ProcRegua(RecCount())
nReg	:= 0
While !Eof()
	IncProc("Processando tabela "+ cArqTrab3+" registros "+AllTrim(Str(nReg)))
	SA1->(DbSelectArea("SA1"))
	SA1->(DbSetorder(1))
	SA1->(DbGotop())
	cChave	:= xFilial("SA1")+E1_CLIENTE+E1_LOJA
	If SA1->(DbSeek(cChave))
	    RecLock(cArqTrab3,.F.)
			E1_CGC	:= SA1->A1_CGC
	    MsUnLock()	
	Endif
	nReg += 1
	DbSelectArea(cArqTrab3)
	DbSkip()
End
COPY TO &(cDestino+RetSqlName("SE1"))
   
Alert("Copiado Tabelas para o diretorio \TABSE1\")

Return

// Exporta tabela SE2 TOP para CTREE
User Function ExpSE2()     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Efetuar a cópia do arquivo SE2 para DTC?","Copia Arquivo SE2","YESNO")
	Processa( {|| fExpSE2() })
EndIf
Return

*------------------------------*
Static Function fExpSE2()     
*------------------------------*
Local aTables 	:= {}
Local aTempStru	:= {}
Local aEstrSE2	:= {}
  
DbSelectArea("SE2")
aEstrSE1 	:= SE2->(dbStruct())
aTempStru 	:= SE2->(dbStruct())
Aadd(aTempStru,{"E2_CGC","C",014,0})
cArqTrab3 := CriaTrab(aTempStru,.T.)
DbUseArea(.T.,__LocalDriver,cArqTrab3,,.T.,.F.)  
//DbUseArea(.T.,"CTREECDX",cArqTrab3,,.T.,.F.)

cDestino := "\TABSE2\"

If !File(cDestino)
	MAKEDIR(cDestino)
EndIf
     
dbSelectArea("SE2")
SE2->(dbSetFilter({|| E2_SALDO > 0},'E2_SALDO > 0'))         
DbSelectArea(cArqTrab3)
APPEND FROM SE2
DbSelectArea(cArqTrab3)
DbGotop()
ProcRegua(RecCount())
nReg	:= 0
While !Eof()
	IncProc("Processando tabela "+ cArqTrab3+" registros "+AllTrim(Str(nReg)))
	SA2->(DbSelectArea("SA2"))
	SA2->(DbSetorder(1))
	SA2->(DbGotop())
	cChave	:= xFilial("SA2")+E2_FORNECE+E2_LOJA
	If SA2->(DbSeek(cChave))
	    RecLock(cArqTrab3,.F.)
			E2_CGC	:= SA2->A2_CGC
	    MsUnLock()	
	Endif
	nReg += 1
	DbSelectArea(cArqTrab3)
	DbSkip()
End
COPY TO &(cDestino+RetSqlName("SE2"))
   
Alert("Copiado Tabelas para o diretorio \TABSE2\")

Return