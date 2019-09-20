#include "rwmake.ch" 
#include "topconn.ch" 

User Function GP070GRV()
Local cFil := PARAMIXB[1]
Local cMat := PARAMIXB[2]
Local nTpProv := PARAMIXB[3]
Local nValAnt := 0
Local aArea := GetArea()                       
// Local nRno := SRT->(RecNo())
Local cSql := ""  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//alert(nTpProv)

if (nTpProv == 4)
	Return Nil
EndIf

// Flavio - 11/04/2011
// Removido daqui o cálculo devido fazer o cálculo da provisão diretamente no BI

/*cSql := "SELECT RT_VALOR FROM " + RetSqlName("SRT") + " SRT WHERE D_E_L_E_T_ <> '*' AND RT_DATACAL < '" + dToS(SRT->RT_DATACAL) + "' AND "
cSql += " RT_MAT = '" + cMat + "' AND RT_FILIAL = '" + cFil + "' AND RT_TIPPROV = '" + AllTrim(STR(nTpProv)) + "'  "
cSql += " AND RT_VERBA = '" + SRT->RT_VERBA + "' AND RT_CC = '" + AllTrim(SRT->RT_CC) + "' ORDER BY RT_DATACAL DESC "

// SRT->(dbGoTo(nRno))  
alert(SRT->RT_VALOR)

if Month(SRT->RT_DATACAL) > 1
  
  TCQUERY cSql NEW ALIAS "SRTTMP"
  
  if SRTTMP->(!Eof())
		nValAnt :=  SRTTMP->RT_VALOR 
	EndIf
	
	SRTTMP->(dbCloseArea())	
EndIf

RecLock("SRT", .F.)
SRT->RT_VALMES := SRT->RT_VALOR - nValAnt
SRT->RT_X_CLVL := Posicione("SRA", 01, xFilial("SRA") + SRT->RT_MAT, "RA_X_SEGME")
SRT->(MsUnlock())*/

// Abaixo Prado
If nTpProv != 4
	IF RecLock( "SRT" , .F. )
		
		RT_X_CLVL  := SRA->RA_X_SEGME
 		SRT->( MsUnlock() )
		
	EndIF
EndIf

RestArea(aArea)

Return Nil