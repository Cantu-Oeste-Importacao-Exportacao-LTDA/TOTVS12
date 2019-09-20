#INCLUDE "Protheus.ch"

USER FUNCTION ATUSRA()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿎hama fun豫o para monitor uso de fontes customizados�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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
