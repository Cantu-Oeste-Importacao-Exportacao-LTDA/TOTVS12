/*---------------------------------------------------------------------------+
!                       FICHA TECNICA DO PROGRAMA                            !
+----------------------------------------------------------------------------+
!                          DADOS DO PROGRAMA                                 !
+------------------+---------------------------------------------------------+
!Autor             ! Silvio Rodrigues Lima - SMSTI                           !
+------------------+---------------------------------------------------------+
!Descricao         ! Programa utilizado no roteiro de cálculo para limitar   !
!                  ! o pagamento do adicional por tempo de serviço           !
+------------------+---------------------------------------------------------+
!Nome              ! TMPSR115 e TMPSR116                                     !
+------------------+---------------------------------------------------------+
!Data de Criação   ! 05/11/2013                                              !
+------------------+--------------------------------------------------------*/

#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "font.ch"

// TELA DE CADASTRO DOS LIMITES %

User Function GPET001()

Local   cAlias     := "ZTS"
Private cCadastro  := "Percentual Limite Tempo de Serviço"
Private aRotina    := {} 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AADD(aRotina,{"Pesquisar" ,"AxPesqui" ,0,1})
AADD(aRotina,{"Visualizar","AxVisual" ,0,2})
AADD(aRotina,{"Incluir" ,"AxInclui" ,0,3})
AADD(aRotina,{"Alterar" ,"AxAltera",0,4})
AADD(aRotina,{"Excluir" ,"AxDeleta",0,5})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6,1,22,75,cAlias)

Return Nil


User function TMPSR115(cRot)

Local cVerba    := "115"
Local nValVerba := fBuscaPD(cVerba)
Local cPercent  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbselectarea("ZTS")
dbSetorder(1)
If dbSeek(SRA->RA_FILIAL+cVerba)
	cPercent := str(ZTS->ZTS_PERC,5,2)
ENDIF

IF SRA->RA_SITFOLH <> "D" .AND. !empty(cPercent)
	
	/*
	cQuery := "  SELECT "
	cQuery += "  RR_VALOR VALORPAGO"
	cQuery += "  FROM "
	cQuery += "  " + RetSQLName("SRC") + " SRC  "
	cQuery += "  INNER JOIN " + RetSQLName("SRR") + " SRR ON RC_DATA = RR_DATA AND RR_PD = 115 AND SRR.D_E_L_E_T_ <> '*' "
	cQuery += "  WHERE RC_MAT = '"+SRA->RA_MAT+"' AND RC_FILIAL = '"+SRA->RA_FILIAL+"' AND RC_PD = '177' AND SRC.D_E_L_E_T_ <> '*' "
	TcQuery cQuery new Alias "VFOL"
	nValPagoFer := VFOL->VALORPAGO
	*/
	
	IF cRot = "P"
		
		nValFolha := fBuscaPD("101") / 100 * val(cPercent)
		
		IF fBuscaPD(cVerba) > nValFolha
			FGERAVERBA(cVerba,nValFolha, Val(StrTran(cPercent, ",", ".")), " ", , "V", , , , dData_Pgto, .T.)
		ELSE
			FGERAVERBA(cVerba,fBuscaPD(cVerba), 0, " ", , "V", , , , dData_Pgto, .T.)
		ENDIF
		
	ELSEIF cRot = "F"
		
		nValFerias := fBuscaPD("177") / 100 * val(cPercent)
		
		IF fBuscaPD(cVerba) > nValFerias
			FGERAVERBA(cVerba,nValFerias, Val(StrTran(cPercent, ",", ".")), " ", , "V", , , , dData_Pgto, .T.)
		ELSE
			FGERAVERBA(cVerba,fBuscaPD(cVerba), 0, " ", , "V", , , , dData_Pgto, .T.)
		ENDIF
		
	ENDIF
	
ENDIF

ZTS->(dbCloseArea())
SRA->(dbCloseArea())

Return



User function TMPSR116(cRot)

Local cVerba    := "116"
Local nValVerba := fBuscaPD(cVerba)
Local cPercent  := ""

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbselectarea("ZTS")
dbSetorder(1)
If dbSeek(SRA->RA_FILIAL+cVerba)
	cPercent := str(ZTS->ZTS_PERC,5,2)
ENDIF

IF SRA->RA_SITFOLH <> "D" .AND. !empty(cPercent)
	
	/*
	cQuery := "  SELECT "
	cQuery += "  RR_VALOR VALORPAGO"
	cQuery += "  FROM "
	cQuery += "  " + RetSQLName("SRC") + " SRC  "
	cQuery += "  INNER JOIN " + RetSQLName("SRR") + " SRR ON RC_DATA = RR_DATA AND RR_PD = 115 AND SRR.D_E_L_E_T_ <> '*' "
	cQuery += "  WHERE RC_MAT = '"+SRA->RA_MAT+"' AND RC_FILIAL = '"+SRA->RA_FILIAL+"' AND RC_PD = '177' AND SRC.D_E_L_E_T_ <> '*' "
	TcQuery cQuery new Alias "VFOL"
	nValPagoFer := VFOL->VALORPAGO
	*/
	
	IF cRot = "P"
		
		nValFolha := fBuscaPD("101") / 100 * val(cPercent)
		
		IF fBuscaPD("116") > nValFolha
			FGERAVERBA(cVerba,nValFolha, Val(StrTran(cPercent, ",", ".")), " ", , "V", , , , dData_Pgto, .T.)
		ELSE
			FGERAVERBA(cVerba,fBuscaPD("116"), 0, " ", , "V", , , , dData_Pgto, .T.)
		ENDIF
		
	ELSEIF cRot = "F"
		
		nValFerias := fBuscaPD("177") / 100 * val(cPercent)
		
		IF fBuscaPD(cVerba) > nValFerias
			FGERAVERBA(cVerba,nValFerias, Val(StrTran(cPercent, ",", ".")), " ", , "V", , , , dData_Pgto, .T.)
		ELSE
			FGERAVERBA(cVerba,fBuscaPD(cVerba), 0, " ", , "V", , , , dData_Pgto, .T.)
		ENDIF
		
	ENDIF
	
ENDIF

ZTS->(dbCloseArea())
SRA->(dbCloseArea())

Return
