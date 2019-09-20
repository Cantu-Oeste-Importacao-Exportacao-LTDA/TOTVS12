#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function LOGDDA()
Local oButton1, oButton2, oButton3
Local oComboBo1
Local oDtFim, oDtIni
Local oFntAlt      := TFont():New("Calibri",,014,,.F.,,,,,.F.,.F.)
Local oGetDate, oGetUsr
Local oGroup1, oGroup2
Local oSay1, oSay2, oSay3, oSay4, oUsr
Static oDlgLog                 
Private aCab       := {"Z34_DTALT", "FIG_VALOR", "FIG_CNPJ", "FIG_NOMFOR", "Z34_RECFIG"}
Private aCab2      := {"Z34_LOGALT", "Z34_DTALT", "Z34_USUARI"}       
Private aStruTrb   := {}
Private aStruTrb2  := {}
Private dDtFim     := dDtIni     := dDataBase
Private aHeaderEx  := {}
Private aHeaderEx2 := {}
Private nComboBo1  := "1"
Private lInverte   :=.F.                                      
Private cMarca          
Private nPosRec    := 0 
Private dGetDate   := dDataBase
Private cGetUsr    := Space(15) 
Public oBrwTrb, oBrwTrb2             
Public aBrowse     := {}
Public aBrowse2    := {}    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


DbSelectArea("SX3")
DbSetOrder(2)
for i := 1 to len(aCab)
	if DbSeek(aCab[i])
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	Aadd(aStruTrb, {SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
  	Aadd(aBrowse,  {SX3->X3_CAMPO,,AllTrim(X3Titulo())})
	EndIf	
Next i 

for i := 1 to len(aCab2)
	if DbSeek(aCab2[i])
		Aadd(aHeaderEx2, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Aadd(aStruTrb2, {SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
    Aadd(aBrowse2,  {SX3->X3_CAMPO,,AllTrim(X3Titulo())})
	EndIf
Next i

cMarca := GetMark()

if select ("TRBTMP") > 0
	TRBTMP->(DbCloseArea())
EndIf                

cArqEmp := CriaTrab(aStruTrb)
dbUseArea(.T., "LOCAL", cArqEmp, "TRBTMP")

if select ("TRBTMP2") > 0
	TRBTMP2->(DbCloseArea())
EndIf                

cArqEmp := CriaTrab(aStruTrb2)
dbUseArea(.T., "LOCAL", cArqEmp, "TRBTMP2")

  DEFINE MSDIALOG oDlgLog TITLE "Consulta de Logs DDA" FROM 000, 000  TO 500, 700 COLORS 0, 16777215 PIXEL
                                                                           
    oBrwTrb := MsSelect():New("TRBTMP","",,aBrowse,@lInverte,@cMarca,{077,002,248,128})
		oBrwTrb:oBrowse:lCanAllmark := .F.
		Eval(oBrwTrb:oBrowse:bGoTop)
		oBrwTrb:oBrowse:Refresh()
		oBrwTrb:oBrowse:bChange := {|| Atualizar2()}

    oBrwTrb2 := MsSelect():New("TRBTMP2","",,aBrowse2,@lInverte,@cMarca,{011,135,160,350})
		oBrwTrb2:oBrowse:lCanAllmark := .F.
		Eval(oBrwTrb2:oBrowse:bGoTop)
		oBrwTrb2:oBrowse:Refresh()
    oBrwTrb2:oBrowse:bChange := {|| AtuaCampos()}
    
    @ 010, 035 MSGET oDtIni   VAR dDtIni   SIZE 060, 009 OF oDlgLog COLORS 0, 16777215 FONT oFntAlt PIXEL
    @ 025, 035 MSGET oDtFim   VAR dDtFim   SIZE 060, 009 OF oDlgLog COLORS 0, 16777215 FONT oFntAlt PIXEL
    @ 179, 167 MSGET oGetUsr  VAR cGetUsr  SIZE 084, 009 OF oDlgLog COLORS 0, 16777215 FONT oFntAlt READONLY PIXEL
		@ 193, 167 MSGET oGetDate VAR dGetDate SIZE 060, 009 OF oDlgLog COLORS 0, 16777215 FONT oFntAlt READONLY PIXEL    
    @ 012, 006 SAY oSay1 PROMPT "Data Ini:"  SIZE 025, 007 OF oDlgLog FONT oFntAlt COLORS 0, 16777215 PIXEL
    @ 027, 006 SAY oSay2 PROMPT "Data Fim:"  SIZE 025, 007 OF oDlgLog FONT oFntAlt COLORS 0, 16777215 PIXEL
    @ 042, 006 SAY oSay3 PROMPT "Tipo:"      SIZE 025, 007 OF oDlgLog FONT oFntAlt COLORS 0, 16777215 PIXEL
    @ 181, 140 SAY oUsr  PROMPT "Usuário:"   SIZE 025, 007 OF oDlgLog FONT oFntAlt COLORS 0, 16777215 PIXEL
    @ 195, 138 SAY oSay4 PROMPT "Data Alt.:" SIZE 025, 007 OF oDlgLog FONT oFntAlt COLORS 0, 16777215 PIXEL
    @ 040, 035 MSCOMBOBOX oComboBo1 VAR nComboBo1 ITEMS {"1=Todos","2=Excluídos"} SIZE 072, 009 OF oDlgLog COLORS 0, 16777215 FONT oFntAlt PIXEL
    @ 054, 072 BUTTON oButton1 PROMPT "Atualizar" SIZE 054, 015 OF oDlgLog FONT oFntAlt ACTION Atualizar() PIXEL
    @ 054, 011 BUTTON oButton3 PROMPT "Cancelar"  SIZE 054, 015 OF oDlgLog FONT oFntAlt ACTION oDlgLog:End() PIXEL
    @ 226, 283 BUTTON oButton2 PROMPT "Sair"      SIZE 060, 016 OF oDlgLog FONT oFntAlt ACTION oDlgLog:End() PIXEL 


  ACTIVATE MSDIALOG oDlgLog CENTERED

Return                           

Static Function AtuaCampos()
DbSelectArea("TRBTMP2")
cGetUsr  := TRBTMP2->Z34_USUARI
dGetDate := TRBTMP2->Z34_DTALT
oBrwTrb2:oBrowse:Refresh()
Return

Static Function Atualizar()
Local cSql := ""
Local cEol := CHR(13)+CHR(10)

if select ("TRBTMP") > 0
	TRBTMP->(DbCloseArea())
EndIf                

cArqEmp := CriaTrab(aStruTrb)
dbUseArea(.T., "LOCAL", cArqEmp, "TRBTMP")

cSql += "SELECT DISTINCT Z34.Z34_DTALT, FIG.FIG_VALOR, FIG.FIG_CNPJ, FIG.FIG_NOMFOR, Z34.Z34_RECFIG "                        +cEol
cSql += "FROM "+ retSqlName("FIG") +" FIG "                                                                                  +cEol
cSql += "INNER JOIN "+ retSqlName("Z34") +" Z34 "                                                                            +cEol
cSql += " ON  FIG.R_E_C_N_O_ = Z34.Z34_RECFIG "                                                                              +cEol
cSql += "AND Z34.Z34_DTALT BETWEEN '"+dToS(dDtIni)+"' AND '"+dToS(dDtFim)+"' "                                               +cEol
cSql += "AND Z34.D_E_L_E_T_ <> '*' "                                                                                         +cEol
if nComboBo1 == "2"
	cSql += "AND FIG.D_E_L_E_T_ = '*' "                                                                                        +cEol
EndIf
cSql += "ORDER BY Z34.Z34_DTALT, FIG.FIG_VALOR "                                                                             +cEol

TCQUERY cSql NEW ALIAS "FIGTMP"

DbSelectArea("FIGTMP")
FIGTMP->(DbGoTop())

if FIGTMP->(EOF())
	FIGTMP->(DbCloseArea())
	Return        
else
	While !FIGTMP->(EOF())
	RecLock("TRBTMP", .T.)
	TRBTMP->Z34_DTALT  := StoD(FIGTMP->Z34_DTALT)
	TRBTMP->FIG_VALOR  := FIGTMP->FIG_VALOR
	TRBTMP->FIG_CNPJ   := FIGTMP->FIG_CNPJ
	TRBTMP->FIG_NOMFOR := FIGTMP->FIG_NOMFOR	
	TRBTMP->Z34_RECFIG := FIGTMP->Z34_RECFIG
	TRBTMP->(MsUnlock())
	FIGTMP->(DbSkip())
	EndDo   
	FIGTMP->(DbCloseArea())
EndIf

Eval(oBrwTrb:oBrowse:bGoTop)
oBrwTrb:oBrowse:Refresh()

Atualizar2()
AtuaCampos()

Return                                             

Static Function Atualizar2()
Local cSql := ""
Local cEol := CHR(13) + CHR(10)

if select ("TRBTMP2") > 0
	TRBTMP2->(DbCloseArea())
EndIf                

cArqEmp := CriaTrab(aStruTrb2)
dbUseArea(.T., "LOCAL", cArqEmp, "TRBTMP2")

DbSelectArea("TRBTMP")
nValRec := TRBTMP->Z34_RECFIG

cSql += "SELECT Z34.Z34_DTALT, Z34.Z34_USUARI, Z34.Z34_LOGALT FROM "+retSqlName("Z34")+ " Z34 "                      +cEol
cSql += "INNER JOIN "+retSqlName("FIG")+ " FIG "                                                                     +cEol  
cSql += " ON FIG.R_E_C_N_O_ = Z34.Z34_RECFIG "                                                                       +cEol
cSql += "AND Z34.Z34_RECFIG = "+ Str(nValRec) + " "                                                                  +cEol
cSql += "AND Z34.D_E_L_E_T_ <> '*' "                                                                                 +cEol

TCQUERY cSql New Alias "Z34TMP"

DbSelectArea("Z34TMP")
Z34TMP->(DbGoTop())

if Z34TMP->(EOF())
	Z34TMP->(DbCloseArea())
	Return
else
	while !Z34TMP->(EOF())
		RecLock("TRBTMP2", .T.)
		TRBTMP2->Z34_LOGALT := Z34TMP->Z34_LOGALT
		TRBTMP2->Z34_DTALT  := StoD(Z34TMP->Z34_DTALT)
		TRBTMP2->Z34_USUARI := Z34TMP->Z34_USUARI
		TRBTMP2->(MsUnlock())
		Z34TMP->(DbSkip())
	EndDo
	Z34TMP->(DbCloseArea())
EndIf

AtuaCampos()

Eval(oBrwTrb2:oBrowse:bGoTop)
oBrwTrb2:oBrowse:Refresh()

Return