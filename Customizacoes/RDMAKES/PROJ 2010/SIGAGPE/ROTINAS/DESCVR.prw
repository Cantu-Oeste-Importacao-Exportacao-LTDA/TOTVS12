
#Include "protheus.ch"
#include "rwmake.ch"
#include "topconn.ch"

User Function DESCVR()  

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
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