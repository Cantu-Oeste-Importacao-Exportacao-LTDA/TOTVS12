#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMANPARCTE  บAutor  ณTOTVS II           บ Data ณ  21/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para manute็ใo dos parโmetros da rotina de          บฑฑ
ฑฑบ          ณ importa็ใo de Ct-e                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Especํficos Cantu                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------*
User Function MANPARCTE()                                      
*-------------------------*
Static oBtnAlt
Static oBtnExc
Static oBtnFec
Static oBtnInc
Static oBtnPes                 
Static oBtnSal
Static oCboPreNta
Static oGetCon
Static oGetDesCon
Static oGetDesTes
Static oGetDirOri
Static oGetEma                      
Static oGetEmp
Static oGetFil
Static oGetNom
Static oGetTes
Static oGetUsu
Static oGroup1
Static oGrpBrw
Static oGrpCpo
Static oLbEma
Static oLbEmp
Static oLbFil
Static oLbNome
Static oLbPas
Static oLbPre
Static oLbTES
Static oLbUsr
Static oSay1
Static oGetCC
Static oGetDesCC
Static oLbCC
Static oLbNat
Static oLbPro
Static oLbSeg
Static oDesSeg
Static oGetSeg
Static oLbTom

Private oDlgPar  
Private cCboTom := "S"
Private lFind   := .F.                                 // Define se encontrou os parโmetros para a empresa e filial
Private lCanAlt := .F.                                 // Define se habilita o formulแrio para edi็ใo
Private lAltera := .F.                                 // Indica se o registro estแ sendo alterado
Private lInclui := .F.                                 // Indica se o registro estแ sendi incluํdo
Private cGetCon    := Space(TamSx3("E4_CODIGO")[01])
Private nCboPreNta := '1'    
Private cGetDesCon := Space(TamSx3("E4_DESCRI")[01])
Private cGetDesTes := Space(TamSx3("F4_FINALID")[01])
Private cGetDirOri := Space(200) 
Private cGetEma    := Space(200) 
Private cGetEmp    := Space(02)                       // M0_CODIGO
Private cGetFil    := Space(02)                       // M0_CODFIL
Private cGetNom    := Space(15)                       // M0_FILIAL 
Private cGetTes    := Space(TamSx3("F4_CODIGO")[01])   
Private cGetUsu    := SuperGetMv("MV_X_ADCTE", .F., Space(200))  // MV_X_ADCTE
Private lAdmin     := Lower(cUserName) $ Lower(cGetUsu)
Private cGetCC     := Space(TamSx3("CTT_CUSTO") [01])
Private cGetDesCC  := Space(TamSx3("CTT_DESC01")[01])
Private cGetNat    := Space(TamSX3("ED_CODIGO") [01])  
Private cDesNat    := Space(TamSX3("ED_DESCRIC")[01])
Private cGetPro    := Space(TamSX3("B1_COD")    [01])
Private cDesPro    := Space(TamSX3("B1_DESC")   [01])
Private cGetSeg    := Space(TamSX3("CTH_CLVL")  [01])
Private cDesSeg    := Space(TamSX3("CTH_DESC01")[01])

fAtualiza()

  DEFINE MSDIALOG oDlgPar TITLE "Parโmetros" FROM 000, 000  TO 520, 700 COLORS 0, 16777215 PIXEL

    @ 001, 002 GROUP oGrpBrw TO 258, 347                                 OF oDlgPar COLOR 0, 16777215 PIXEL
    @ 005, 005 GROUP oGrpCpo TO 236, 344 PROMPT "   Empresa / Filial   " OF oGrpBrw COLOR 0, 16777215 PIXEL  
    @ 064, 008 GROUP oGroup1 TO 232, 341 PROMPT "   Parametros   "       OF oGrpCpo COLOR 0, 16777215 PIXEL
    
    @ 241, 305 BUTTON oBtnFec PROMPT "Fechar"      SIZE 037, 012 WHEN .T.                                   OF oGrpBrw ACTION oDlgPar:End()     PIXEL
    @ 241, 228 BUTTON oBtnSal PROMPT "Salvar"      SIZE 037, 012 WHEN (lAltera .or. lInclui)  .and. lAdmin  OF oGrpBrw ACTION fSal()            PIXEL
    @ 241, 189 BUTTON oBtnAlt PROMPT "Alterar"     SIZE 037, 012 WHEN (lFind .and. !lAltera)  .and. lAdmin  OF oGrpBrw ACTION fAlt()            PIXEL
    @ 241, 151 BUTTON oBtnInc PROMPT "Incluir"     SIZE 037, 012 WHEN (!lFind .and. !lInclui) .and. lAdmin  OF oGrpBrw ACTION fInc()            PIXEL
    @ 078, 305 BUTTON oBtnPes PROMPT " ... "       SIZE 014, 012 WHEN (lAltera .or. lInclui)  .and. lAdmin  OF oGroup1 ACTION fGetDir()         PIXEL
    @ 241, 266 BUTTON oBtnExc PROMPT "Excluir"     SIZE 037, 012 WHEN (lFind .and. !lAltera   .and. !lInclui) .and. lAdmin OF oGrpBrw ACTION fExc()            PIXEL
    @ 105, 295 BUTTON oBtnCon PROMPT "Configurar " SIZE 040, 012 WHEN (lAltera .or. lInclui)  .and. lAdmin .and. cCboTom == 'N' OF oGrpBrw ACTION fTesPad() PIXEL
    
    @ 021, 015 SAY oLbEmp  PROMPT "Empresa"                SIZE 025, 007 OF oGrpCpo COLORS 0, 16777215 PIXEL
    @ 035, 015 SAY oLbFil  PROMPT "Filial"                 SIZE 025, 007 OF oGrpCpo COLORS 0, 16777215 PIXEL
    @ 049, 015 SAY oLbNome PROMPT "Nome"                   SIZE 025, 007 OF oGrpCpo COLORS 0, 16777215 PIXEL
    @ 080, 016 SAY oLbPas  PROMPT "Pasta de Origem do XML" SIZE 063, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 093, 016 SAY oLbPre  PROMPT "Gera Pr้ Nota Aut"      SIZE 062, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 107, 016 SAY oLbTom  PROMPT "Tomador / TES Pad. "    SIZE 058, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 123, 016 SAY oSay1   PROMPT "Cond. Pag. Padrใo"      SIZE 058, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 219, 016 SAY oLbUsr  PROMPT "Usuแrios master"        SIZE 052, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 139, 016 SAY oLbCC   PROMPT "Centro de Custo"        SIZE 052, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 155, 016 SAY oLbNat  PROMPT "Natureza "              SIZE 052, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 171, 016 SAY oLbPro  PROMPT "Produto Padrใo "        SIZE 052, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 187, 016 SAY oLbEma  PROMPT "Email inconsist๊ncias"  SIZE 055, 007 OF oGroup1 COLORS 0, 16777215 PIXEL
    @ 203, 016 SAY oLbSeg  PROMPT "Segmento Padrใo"        SIZE 055, 007 OF oGroup1 COLORS 0, 16777215 PIXEL 
        
    @ 020, 042 MSGET oGetEmp    VAR cGetEmp    SIZE 016, 010 OF oGrpCpo WHEN .F. COLORS 0, 16777215 PIXEL
    @ 034, 042 MSGET oGetFil    VAR cGetFil    SIZE 016, 010 OF oGrpCpo WHEN .F. COLORS 0, 16777215 PIXEL
    @ 048, 042 MSGET oGetNom    VAR cGetNom    SIZE 148, 010 OF oGrpCpo WHEN .F. COLORS 0, 16777215 READONLY PIXEL
    @ 078, 079 MSGET oGetDirOri VAR cGetDirOri SIZE 224, 010 OF oGroup1 WHEN .T. COLORS 0, 16777215 READONLY PIXEL
	  @ 105, 106 MSGET oGetTes    VAR cGetTes    SIZE 026, 010 OF oGroup1 WHEN (lInclui .or. lAltera) .and. cCboTom == 'S' COLORS 0, 16777215 F3 "SF4" VALID fDesTes() PIXEL
		@ 105, 136 MSGET oGetDesTes VAR cGetDesTes SIZE 145, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    @ 121, 079 MSGET oGetCon    VAR cGetCon    SIZE 026, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 F3 "SE4" VALID fDesCon() PIXEL
    @ 121, 109 MSGET oGetDesCon VAR cGetDesCon SIZE 172, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL    
    @ 217, 079 MSGET oGetUsu    VAR cGetUsu    SIZE 240, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    @ 137, 079 MSGET oGetCC     VAR cGetCC     SIZE 052, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 F3 "CTT" VALID fDesCC()  PIXEL
    @ 137, 131 MSGET oGetDesCC  VAR cGetDesCC  SIZE 150, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    @ 153, 079 MSGET oGetNat    VAR cGetNat    SIZE 052, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 F3 "SED" VALID fDesNat()  PIXEL
    @ 153, 131 MSGET oDesNat    VAR cDesNat    SIZE 150, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    @ 169, 079 MSGET oGetPro    VAR cGetPro    SIZE 052, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 F3 "SB1" VALID fDesPro()  PIXEL
    @ 169, 131 MSGET oDesPro    VAR cDesPro    SIZE 150, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    @ 185, 079 MSGET oGetEma    VAR cGetEma    SIZE 240, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 PIXEL
    @ 201, 079 MSGET oGetSeg    VAR cGetSeg    SIZE 052, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 F3 "CTH" VALID fDesSeg() PIXEL
    @ 201, 131 MSGET oDesSeg    VAR cDesSeg    SIZE 150, 010 OF oGroup1 WHEN .F. COLORS 0, 16777215 PIXEL
    
    @ 092, 079 MSCOMBOBOX oCboPreNta VAR nCboPreNta ITEMS {"1=Automatico","2=Manual"} SIZE 071, 010 OF oGroup1 WHEN (lInclui .or. lAltera) COLORS 0, 16777215 PIXEL
    @ 105, 079 MSCOMBOBOX oCboTom    VAR cCboTom    ITEMS {"S=Sim","N=Nao"}           SIZE 026, 010 OF oGroup1 WHEN (lInclui .or. lAltera) ON CHANGE fAltTom() COLORS 0, 16777215 PIXEL    
    
  ACTIVATE MSDIALOG oDlgPar CENTERED

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAltTom บAutor  ณTOTVS II           บ Data ณ  21/01/15      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para limpar campos de TES quando a filial nใo for   บฑฑ
ฑฑบ          ณ tomadora.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAltTom()

If cCboTom == 'N'
	cGetTes    := Space(TamSx3("F4_CODIGO")[01])
	cGetDesTes := Space(TamSx3("F4_FINALID")[01])
EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfTesPad บAutor  ณTOTVS II           บ Data ณ  21/01/15      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para configura็ใo de TES padrใo quando a filial nใo บฑฑ
ฑฑบ          ณ for tomadora.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fTesPad()

Local nX

Static oDlgGrp
Static oBtnCan
Static oBtnOk
Static oGetGrp

Private aHeaderEx    := {}
Private aColsEx      := {}
Private aFields      := {"ZBD_CST","ZBD_TES"}
Private aAlterFields := {"ZBD_CST","ZBD_TES"}
Private oDadosGrp

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                     SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

fLoadGrid()

  DEFINE MSDIALOG oDlgGrp TITLE "CST x TES " FROM 000, 000  TO 250, 200 COLORS 0, 16777215 PIXEL

    @ 109, 019 BUTTON oBtnOk  PROMPT "Ok"      SIZE 037, 012 ACTION fGrvGrp()     OF oDlgGrp PIXEL
    @ 109, 058 BUTTON oBtnCan PROMPT "Cancela" SIZE 037, 012 ACTION oDlgGrp:End() OF oDlgGrp PIXEL
  	
  	oDadosGrp := MsNewGetDados():New( 002, 001, 107, 096, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 90, "AllwaysTrue", "", "AllwaysTrue", oDlgGrp, aHeaderEx, aColsEx)
    
  ACTIVATE MSDIALOG oDlgGrp CENTERED

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGrvGrp บAutor  ณTOTVS II           บ Data ณ  21/01/15      บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por gravar as altera็๕es feitas no grid.บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGrvGrp(oGetGrp)

Local aCols   := oDadosGrp:aCols
Local aHeader := oDadosGrp:aHeader
Local nPosCST := aScan(aHeader, {|x| AllTrim(x[02]) == "ZBD_CST"})
Local nPosTes := aScan(aHeader, {|x| AllTrim(x[02]) == "ZBD_TES"})
Local i       := 0

If Len(aCols) > 0 

	For i := 1 to Len(aCols)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ ฟ
		//ณValida se linha foi deletadaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ 

		if aCols[i][Len(aHeader)+1]
			DbSelectArea("ZBD")
			ZBD->(DbSetOrder(3))
			If DbSeek(xFilial("ZBD") + cEmpAnt + cFilAnt + aCols[i][nPosCST])
				RecLock("ZBD", .F.)
				ZBD->(DbDelete())
				ZBD->(MsUnlock())
			EndIf
		Else
			If !Empty(aCols[i][nPosCST])
				
				DbSelectArea("ZBD")
				ZBD->(DbSetOrder(3))
				If DbSeek(xFilial("ZBD") + cEmpAnt + cFilAnt + aCols[i][nPosCST])
					RecLock("ZBD", .F.)
					ZBD->ZBD_TES := aCols[i, nPosTes]
					ZBD->(MsUnlock())
				Else
					RecLock("ZBD", .T.)
					ZBD->ZBD_FILIAL := xFilial("ZBD")
					ZBD->ZBD_CODEMP := cEmpAnt
					ZBD->ZBD_CODFIL := cFilAnt
					ZBD->ZBD_CST    := aCols[i][nPosCST]
					ZBD->ZBD_TES    := aCols[i][nPosTes]
					ZBD->(MsUnlock())
				EndIf
				
			EndIf
		EndIf	
	Next i 
Else
	If	MsgYesNo("Nใo foi encontrado nenhuma amarra็ใo de CST x TES para essa empresa e filial. Deseja sair assim mesmo?")
		Return
	EndIf
EndIf

oDlgGrp:End()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLoadGrid บAutor  ณTOTVS II           บ Data ณ  21/01/15    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para carregar os dados dos grupos de fornecedores x บฑฑ
ฑฑบ          ณ TES Padrใo                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fLoadGrid()

aColsEx := {}

DbSelectArea("ZBD")
ZBD->(DbSetOrder(1))
If DbSeek(xFilial("ZBD") + cEmpAnt + cFilAnt)
	While !ZBD->(EOF()) .and. ZBD->ZBD_FILIAL+ZBD->ZBD_CODEMP+ZBD->ZBD_CODFIL == xFilial("ZBD")+cEmpAnt+cFilAnt
		aAdd(aColsEx, {ZBD->ZBD_CST,;
								   ZBD->ZBD_TES,;
								   .F.})
		ZBD->(DbSkip())
	EndDo
Else
	aAdd(aColsEx, {Space(TamSX3("ZBD_CST")[01]),;
								 Space(TamSX3("ZBD_TES")[01]),;
								 .F.})
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesSeg บAutor  ณTOTVS II              บ Data ณ  14/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida o preenchimento do campo de Segmento     บฑฑ
ฑฑบ          ณ e popula o campo da descri็ใo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesSeg()

Local lRet := .T.

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณValida se o segmento ้ analํtico.ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

lRet := Len(AllTrim(cGetSeg)) == 9

if lRet
	lRet := ExistCpo("CTH", cGetSeg, 1)
	cDesSeg := Posicione("CTH", 1, xFilial("CTH") + cGetSeg, "CTH_DESC01")
Else
	MsgAlert("Segmento "+ AlLTrim(cGetSeg) +" nใo deve receber movimentos. ")
EndIf                                

oDlgPar:CommitControls()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesPro บAutor  ณTOTVS II              บ Data ณ  14/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida o preenchimento do campo de Produto      บฑฑ
ฑฑบ          ณ e popula o campo da descri็ใo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesPro()

Local lRet := .T.

lRet := ExistCpo("SB1", cGetPro, 1)

cDesPro := Posicione("SB1", 1, xFilial("SB1") + cGetPro, "B1_DESC")
oDlgPar:CommitControls()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesCC  บAutor  ณTOTVS II              บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida o preenchimento do campo de Centro Custo บฑฑ
ฑฑบ          ณ e popula o campo da descri็ใo                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesCC()

Local lRet := .T.

lRet := ExistCpo("CTT", cGetCC, 1)

cGetDesCC := Posicione("CTT", 1, xFilial("CTT") + cGetCC, "CTT_DESC01")
oDlgPar:CommitControls()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesTes บAutor  ณTOTVS II              บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida o preenchimento do campo da TES e        บฑฑ
ฑฑบ          ณ popula o campo da descri็ใo                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesTes()

Local lRet := .T.

lRet := ExistCpo("SF4", cGetTes, 1)

cGetDesTes := Posicione("SF4", 1, xFilial("SF4") + cGetTes, "F4_FINALID")
oDlgPar:CommitControls()

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesCon บAutor  ณTOTVS II              บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida a condi็ใo de pagamento e preenche       บฑฑ
ฑฑบ          ณ o campo da descri็ใo                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesCon() 

Local lRet := .T.

lRet := ExistCpo("SE4", cGetCon, 1)

cGetDesCon := Posicione("SE4", 1, xFilial("SE4") + cGetCon, "E4_DESCRI")
oDlgPar:CommitControls()	

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAlt บAutor  ณTOTVS II                   Data ณ  29/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo executada no momento do click do botใo Alterar      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAlt()
	lAltera := .T.
	lInclui := .F. 
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfInc บAutor  ณTOTVS II                   Data ณ  29/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo executada no momento do click do botใo Incluir      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fInc()
	
	lInclui := .T.
	lCanAlt := .F.
	lAltera := .F.
	
	cGetEmp := cEmpAnt
	cGetFil := cFilAnt
	cGetNom := SM0->M0_NOME
	
	oDlgPar:CommitControls()
	
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfExc บAutor  ณTOTVS II                 บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo de exclusใo de registro                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fExc()

Local lExclui := .F.

DbSelectArea("ZBA")
ZBA->(DbSetOrder(1))

if DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt )
	lExclui := MsgYesNo("Deseja realmente excluir as configura็๕es da filial "+ AllTrim(SM0->M0_NOME) +"?", "Confirme a exclusใo...")
	
	if lExclui
		Reclock("ZBA", .F.)
		DbDelete()
		ZBA->(MsUnlock())
	EndIf
	
EndIf

lInclui := .F.
lCanAlt := .F.
lAltera := .F.

fAtualiza()

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  fGetDir บAutor  ณTOTVS II               บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para busca de diret๓rio padrใo de onde o sistema    บฑฑ
ฑฑบ          ณ farแ a leitura dos xmls dos Ct-e                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fGetDir()

cGetDirOri := cGetFile("Pastas | *.*", "Selecione a pasta de origem dos xmls...", 1, "c:\", .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ), .F., .T.)

If !ExistDir(cGetDirOri)
	MsgAlert("A pasta "+ AllTrim(cGetDirOri) +" nใo ้ vแlida :( "+ CHR(13)+CHR(10) +"Tente novamente!")
	fGetDir()
EndIf

oDlgPar:CommitControls()

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSal บAutor  ณTOTVS II                 บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para salvar o registro que estแ sendo incluํdo ou   บฑฑ
ฑฑบ          ณ alterado.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fSal()

DbSelectArea("ZBA")
ZBA->(DbSetOrder(1))

if DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt)
	
	Reclock("ZBA", .F.)
	
	ZBA->ZBA_DIRORI := cGetDirOri
	ZBA->ZBA_TES    := cGetTes
	ZBA->ZBA_CONPAG := cGetCon
	ZBA->ZBA_EMAIL  := cGetEma
	ZBA->ZBA_GERPRE := nCboPreNta
	ZBA->ZBA_CC     := cGetCC
	ZBA->ZBA_NATURE := cGetNat
	ZBA->ZBA_CODPRO := cGetPro
	ZBA->ZBA_CLVL   := cGetSeg
	ZBA->ZBA_TOMADO := cCboTom
	
  ZBA->(MsUnlock())

Else
	
	RecLock("ZBA", .T.)
	
	ZBA->ZBA_CODEMP := cGetEmp
	ZBA->ZBA_CODFIL := cGetFil 
	ZBA->ZBA_DIRORI := cGetDirOri
	ZBA->ZBA_TES    := cGetTes
	ZBA->ZBA_CONPAG := cGetCon
	ZBA->ZBA_EMAIL  := cGetEma
	ZBA->ZBA_GERPRE := nCboPreNta
	ZBA->ZBA_CC     := cGetCC
	ZBA->ZBA_NATURE := cGetNat
	ZBA->ZBA_CODPRO := cGetPro
	ZBA->ZBA_CLVL   := cGetSeg
	ZBA->ZBA_TOMADO := cCboTom
	
	ZBA->(MsUnlock())
		
EndIf 

lInclui := .F.
lAltera := .F.
lCanAlt := .T.

fAtualiza()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfAtualiza บAutor  ณTOTVS II            บ Data ณ  28/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo responsแvel por atualizar dados no formulแrio de    บฑฑ
ฑฑบ          ณ acordo com a empresa e filial em que o usuแrio estแ logado.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fAtualiza()

DbSelectArea("ZBA")
ZBA->(DbSetOrder(1))
if DbSeek(xFilial("ZBA") + cEmpAnt + cFilAnt)
	lFind := .T.
	
	cGetEmp := ZBA->ZBA_CODEMP
	cGetFil := ZBA->ZBA_CODFIL
	cGetNom := SM0->M0_NOME
	
	cGetDirOri := ZBA->ZBA_DIRORI
	cGetTes    := ZBA->ZBA_TES
	cGetDesTes := Posicione("SF4", 1, xFilial("SF4") + ZBA->ZBA_TES   , "F4_FINALID")
	cGetCon    := ZBA->ZBA_CONPAG
	cGetDesCon := Posicione("SE4", 1, xFilial("SE4") + ZBA->ZBA_CONPAG, "E4_DESCRI" )    
	cGetEma		 := ZBA->ZBA_EMAIL
	nCboPreNta := ZBA->ZBA_GERPRE
	cGetCC     := ZBA->ZBA_CC
	cGetDesCC  := Posicione("CTT", 1, xFilial("CTT") + ZBA->ZBA_CC    , "CTT_DESC01")
	cGetNat    := ZBA->ZBA_NATURE
	cDesNat    := Posicione("SED", 1, xFilial("SED") + ZBA->ZBA_NATURE, "ED_DESCRIC")
	cGetPro    := ZBA->ZBA_CODPRO
	cDesPro    := Posicione("SB1", 1, xFilial("SB1") + ZBA->ZBA_CODPRO, "B1_DESC"   )
	cGetSeg    := ZBA->ZBA_CLVL
	cDesSeg    := Posicione("CTH", 1, xFilial("CTH") + ZBA->ZBA_CLVL, "CTH_DESC01"  )
	cCboTom    := ZBA->ZBA_TOMADO

Else 
  
  lFind := .F.                                       	
  
	nCboPreNta := '1'
	cGetCon    := Space(TamSx3("E4_CODIGO")[01])
	cGetDesCon := Space(TamSx3("E4_DESCRI")[01])
	cGetDesTes := Space(TamSx3("F4_FINALID")[01])
	cGetDirOri := Space(200)
	cGetEma    := Space(200)                      
	cGetEmp    := Space(02)                       
	cGetFil    := Space(02)                       
	cGetNom    := Space(15)                       
	cGetTes    := Space(TamSx3("F4_CODIGO")[01])
	cGetCC     := Space(TamSx3("CTT_CUSTO")[01])
	cGetDesCC  := Space(TamSx3("CTT_DESC01")[01])       
	cGetNat    := Space(TamSX3("ED_CODIGO") [01])  
	cDesNat    := Space(TamSX3("ED_DESCRIC")[01])
	cGetPro    := Space(TamSX3("B1_COD")    [01])
	cDesPro    := Space(TamSX3("B1_DESC")   [01])
	cGetSeg    := Space(TamSX3("CTH_CLVL")  [01])
	cDesSeg    := Space(TamSX3("CTH_DESC01")[01])
	cCboTom    := "S"
	
EndIf        

if ValType("oDlgPar") == "O"
	oDlgPar:CommitControls()
EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDesNat บAutor  ณTOTVS II              บ Data ณ  14/12/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo que valida e retorna descri็ใo da natureza          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MANPARCTE                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function fDesNat()

Local lRet := .T.

lRet := ExistCpo("SED", cGetNat, 1)

cDesNat := Posicione("SED", 1, xFilial("SED") + cGetNat, "ED_DESCRIC")
oDlgPar:CommitControls()

Return lRet