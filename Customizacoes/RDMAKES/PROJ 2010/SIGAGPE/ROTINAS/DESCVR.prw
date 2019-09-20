
#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function DESCVR()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("ZVR")
DbGoTop()
	
	IF DbSeek(SRA->RA_FILIAL+SRA->MAT+"082013")  
		RecLock("SRC",.t.)
		FGERAVERBA("466",FbuscaPd("215+222","V"),,,,"V",,,,,,)         
		MsUnLock() 
	ELSE
		RecLock("SRC",.f.)	
		MsUnLock() 
	EndIf
 

QRY->(dbCloseArea())

Return     


Return