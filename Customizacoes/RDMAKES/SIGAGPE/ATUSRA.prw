#INCLUDE "Protheus.ch"

USER FUNCTION ATUSRA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SRA")
dbSetOrder(1)
dbGoTop("SRA")

While SRA->(!Eof())
	dbSelectArea("SR6")
	dbSetOrder(1)
	dbSeek(xFilial( "SR6" ) + SRA->RA_TNOTRAB )
	If !Found()
		RecLock("SRA",.F.)
		RA_X_DTURN := SPACE(50)
		MsUnlock()
	Endif
	RecLock("SRA",.F.)
	RA_X_DTURN := SR6->R6_DESC
	MsUnlock()
	
	dbSelectArea("SRJ")
	dbSetOrder(1)
	dbSeek(xFilial( "SRJ" ) + SRA->RA_CODFUNC )
	If !Found()
		RecLock("SRA",.F.)
		RA_X_DESCF := SPACE(50)
		MsUnlock()
	Endif
	RecLock("SRA",.F.)
	RA_X_DESCF := SRJ->RJ_DESC
	MsUnlock()
	
	SRA->(DBSKIP())
	dbSelectArea( "SRA" )
	
ENDDO
alert("Atualizacao efetuada.")
RETURN
