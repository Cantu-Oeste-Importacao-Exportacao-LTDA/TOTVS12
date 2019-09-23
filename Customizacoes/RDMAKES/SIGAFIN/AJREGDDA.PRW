#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJREGDDA  ºAutor  ³Jean           º Data ³  10/07/11        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para ajuste dos registro da tabela FIG            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function AJREGDDA()
Local aArea        := GetArea()
Local nReg         := 0
Local cSql         := ""
Local aFields      := {"FIG_FILIAL", "FIG_FORNEC", "FIG_LOJA", "FIG_TITULO", "FIG_VENCTO", "FIG_VALOR", "E5_DOCUMEN", "FIG_CNPJ", "FIG_CODBAR", "R_E_C_N_O_"}                                                   
Local aAlterFields := {}
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFieldFill   := {}
Local cUserDda     := ""
Local aOrdem       := {}
Local oCboOrd      
Local nCboOrd
Local oOrdem
Local oCheckBo1
Local lCheckBo1    := .T.
Static oMSNewGe1
Static oDlg
Local oF7, oDel          
Private aColsOld := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//cUserDda := AllTrim(SubStr(cUsuario, 7, 15))

// Valida se usuário tem direito de acesso a essa rotina.                        
DbSelectArea("ZZY")
DbSetOrder(1)
if !DbSeek(xFilial("ZZY") + cUsername)
		Alert("Usuáro "+cUsername+" não possui direito de acesso a essa rotina! :( ")
		Return	              
else
	if (ZZY->ZZY_AJDDA != "1")
		Alert("Usuáro "+cUsername+" não possui acesso a alterar registros do DDA! :( ")
		Return		
	EndIf
EndIf


// Pega as configurações de campos do SX3 e atribui para o array aHeaderEx
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
for Nx := 1 to len(aFields)
	if DbSeek(aFields[Nx])
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Aadd(aOrdem, AllTrim(X3Titulo()))                                                                      
	EndIf                                                                                                    
  if aFields[Nx] == "R_E_C_N_O_"
  	Aadd(aHeaderEx, {"Recno","R_E_C_N_O_","@E 999,999",6,0})
  EndIf
Next Nx                       

// Atribui funções aos botões do teclado.
SetKey(VK_F7,{||U_FRMPESQ()})
SetKey(VK_F6,{||RptStatus({|lEnd| U_PESQAUT(@lEnd) }, "Aguarde...","Buscando Títulos para Conciliar...", .T.)})

cSql := "SELECT FIG_FILIAL, FIG_FORNEC, FIG_LOJA, FIG_TITULO, FIG_VENCTO, "
cSql += " FIG_VALOR, FIG_CNPJ, FIG_CODBAR, R_E_C_N_O_ FROM " + retSqlName("FIG") + " FIG "
cSql += "WHERE FIG_CONCIL <> '1' "
cSql += "  AND FIG_X_OK <> 'S' "
cSql += "  AND FIG.D_E_L_E_T_ <> '*' "

TcQuery cSql New Alias "FIGTMP"  

DbSelectArea("FIGTMP")
FIGTMP->(DbGoTop())

While !FIGTMP->(EOF())                 
	Aadd(aFieldFill, {FIG_FILIAL,;
										FIG_FORNEC,;
										FIG_LOJA,;
										FIG_TITULO,;
										StoD(FIG_VENCTO),;
										FIG_VALOR,;
										Space(50),;
										FIG_CNPJ,;
										FIG_CODBAR,;
										R_E_C_N_O_,;
										.F.})                                       	
	FIGTMP->(DbSkip())
End

FIGTMP->(DbCloseArea())

aColsEx  := aClone(aFieldFill)
aColsOld := aClone(aColsEx)

	DEFINE MSDIALOG oDlg TITLE "Registros Não Processados" FROM 000, 000  TO 600, 1350 COLORS 0, 16777215 PIXEL
	oMSNewGe1 := MsNewGetDados():New( 030, 001, 259, 670, GD_INSERT + GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields, 0, Len(aColsEx), "AllwaysTrue",, "AllwaysTrue", oDlg, aHeaderEx, aColsEx)	
	oMSNewGe1:oBrowse:Refresh()
	
  @ 263, 010 SAY oF7  PROMPT "F7 = Conciliar " SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
  @ 263, 050 SAY oF6  PROMPT "F6 = Automático " SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
  @ 263, 090 SAY oDel PROMPT "DEL = Deletar " SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
  
  @ 263, 130 SAY oOrdem PROMPT "Ordenar Por " SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
  @ 262, 160 MSCOMBOBOX oCboOrd VAR nCboOrd ITEMS aOrdem SIZE 072, 010 OF oDlg COLORS 0, 16777215 ON CHANGE OrdenaGrid(nCboOrd) PIXEL              
  
  @ 278, 010 CHECKBOX oCheckBo1 VAR lCheckBo1 WHEN PermiteAlt() PROMPT "Conciliação Automática" SIZE 097, 008 OF oDlg COLORS 0, 16777215 PIXEL
  
  @ 277, 080 BUTTON oButton3 PROMPT "Reprocessar" WHEN !lCheckBo1 ACTION (Reprocessar()) SIZE 040, 012 OF oDlg PIXEL
  
 	ACTIVATE MSDIALOG oDlg CENTER ON INIT; 	
	EnchoiceBar(oDlg,{|| GravaFIG(lCheckBo1), oDlg:End(), oDlg:End(), Nil }, {|| oDlg:End() })

RestArea(aArea)
	
Return         

Static Function Reprocessar()
Local i := 0
Local oGet1
Local oGet2
Local oSay1
Local oSay2         
Local aAlterFields
Local aColsRe      := {}
Local aHeaderRe    := {} 
Local aFields      := {"FIG_FILIAL", "FIG_FORNEC", "FIG_LOJA", "FIG_VENCTO", "FIG_TITULO", "FIG_VALOR", "E5_DOCUMEN", "FIG_CODBAR", "R_E_C_N_O_"}                                                   
Local aAlterFields := {}
Local aFieldFill   := {}
Static oDlgReprocessa
Private dGet1 := Date(dDataBase)
Private dGet2 := Date(dDataBase)
Private oMSNewGe2

// Pega as configurações de campos do SX3 e atribui para o array aHeaderRe
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
for i := 1 to len(aFields)
	if DbSeek(aFields[i])
		Aadd(aHeaderRe, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	EndIf                                                                                                    
  if aFields[i] == "R_E_C_N_O_"
  	Aadd(aHeaderRe, {"Recno", "R_E_C_N_O_", "@E 999,999", 6, 0})
  EndIf
Next i                       


  DEFINE MSDIALOG oDlgReprocessa TITLE "Registros Ajustados e Não Conciliados" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
		oMSNewGe2 := MsNewGetDados():New( 046, 001, 200, 350, GD_INSERT + GD_DELETE + GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields, 0, Len(aColsRe),;
		 						 "AllwaysTrue",, "AllwaysTrue", oDlgReprocessa, aHeaderRe, aColsRe)	
		oMSNewGe2:oBrowse:Refresh()    

    @ 031, 070 MSGET oGet1 VAR dGet1 SIZE 060, 010 OF oDlgReprocessa COLORS 0, 16777215 PIXEL
    @ 031, 197 MSGET oGet2 VAR dGet2 SIZE 060, 010 OF oDlgReprocessa COLORS 0, 16777215 ON CHANGE Processa({|| GridProc()},"Buscando Registros...") PIXEL
    @ 032, 033 SAY oSay1 PROMPT "Processados De" SIZE 043, 007 OF oDlgReprocessa COLORS 0, 16777215 PIXEL
    @ 032, 150 SAY oSay2 PROMPT "Processados Até" SIZE 044, 007 OF oDlgReprocessa COLORS 0, 16777215 PIXEL
	
	ACTIVATE MSDIALOG oDlgReprocessa CENTER ON INIT; 	
	EnchoiceBar(oDlgReprocessa,{|| U_ProcGravaE2(aClone(oMsNewGe2:aCols),aClone(oMsNewGe2:aHeader)),;
	oDlgReprocessa:End(), Nil }, {|| oDlgReprocessa:End() }) 

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄP¿
//³Função que atualiza o Grid toda vez que houverem mudanças no filtro.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPÙ

Static Function GridProc()
Local cSql := ""
Local cEol := CHR(13)+CHR(10)
Local aFieldFill := {}
Local aColsRe    := {}

cSql := "SELECT FIG.FIG_FILIAL, FIG.FIG_FORNEC, FIG.FIG_LOJA, FIG.FIG_VENCTO, FIG.FIG_TITULO, FIG.FIG_VALOR, "	+cEol
cSql += "E2_FILIAL||E2.E2_PREFIXO||E2_NUM||E2_PARCELA||E2_TIPO||E2_FORNECE||E2_LOJA AS CHAVE, "	+cEol
cSql += "FIG.FIG_CODBAR, FIG.R_E_C_N_O_ FROM "+retSqlName("FIG")+" FIG "												+cEol

cSql += "INNER JOIN "+retSqlName("SE2")+" E2 "																									+cEol
cSql += " ON E2.E2_FILIAL = FIG.FIG_FILIAL "                                                    +cEol
cSql += "AND E2.E2_FORNECE = FIG.FIG_FORNEC "                                                   +cEol
cSql += "AND E2.E2_LOJA = FIG.FIG_LOJA "                                                        +cEol
cSql += "AND E2.E2_VENCTO = FIG.FIG_VENCTO "                                                    +cEol
cSql += "AND E2.E2_VALOR = FIG.FIG_VALOR "                                                      +cEol

cSql += "WHERE FIG.FIG_X_OK = 'S' "                                                             +cEol
cSql += "  AND FIG.FIG_CONCIL = '2' "                                                           +cEol
cSql += "  AND FIG.FIG_DATA BETWEEN '"+DtoS(dGet1)+"' AND '"+DtoS(dGet2)+"' "                   +cEol
cSql += "  AND FIG.D_E_L_E_T_ <> '*' "                                                          +cEol
cSql += "  AND E2.D_E_L_E_T_ <> '*' "                                                           +cEol
cSql += "  AND E2.E2_PREFIXO NOT IN ('PRV','ANT') "                                             +cEol

TCQUERY cSql NEW ALIAS "FIGSE2"

DbSelectArea("FIGSE2")
FIGSE2->(DbGoTop())

While !FIGSE2->(EOF())                 
	Aadd(aFieldFill, {FIG_FILIAL,;
										FIG_FORNEC,;
										FIG_LOJA,;
										StoD(FIG_VENCTO),;
										FIG_TITULO,;
										FIG_VALOR,;
										CHAVE,;
										FIG_CODBAR,;
										R_E_C_N_O_,;
										.F.})                                       	
	FIGSE2->(DbSkip())
End

FIGSE2->(DbCloseArea())
aColsRe  := aClone(aFieldFill)

oMSNewGe2:aCols := aClone(aColsRe)
oMSNewGe2:ForceRefresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a gravação dos dados no título conciliado e na tabela do DDA.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function ProcGravaE2(aColsGra, aHeaderGra)
Local i := 0
Local aHeader := aClone(aHeaderGra)
Local aCols   := aClone(aColsGra)
Local nPosBar := 0 
Local nPosDoc := 0 
Local nPosFil := 0
Local nPosFor := 0
Local nPosLoj := 0
Local nPosVen := 0
Local nPosTit := 0
Local nPosRec := 0
Local nCont   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
nPosFor := aScan(aHeader, {|x| AllTrim(x[2]) == "FIG_FORNEC"})
nPosLoj := aScan(aHeader, {|x| AllTrim(x[2]) == "FIG_LOJA"})
nPosVen := aScan(aHeader, {|x| AllTrim(x[2]) == "FIG_VENCTO"})
nPosTit := aScan(aHeader, {|x| AllTrim(x[2]) == "FIG_TITULO"})
nPosFil := aScan(aHeader, {|x| AlLTrim(x[2]) == "FIG_FILIAL"})
nPosBar := aScan(aHeader, {|x| AllTrim(x[2]) == "FIG_CODBAR"})
nPosDoc := aScan(aHeader, {|x| AllTrim(x[2]) == "E5_DOCUMEN"})
nPosRec := aScan(aHeader, {|x| AllTrim(x[2]) == "R_E_C_N_O_"})

if Len(aCols) == 0
	MsgInfo("Nenhum Título Conciliado.")
	Return nCont
EndIf

aTemp := {}
for i := 1 to len(aCols)
	Begin Transaction
		DbSelectArea("SE2")
		SE2->(DbSetOrder(1))
		If DbSeek(aCols[i, nPosDoc])
			RecLock("SE2", .F.)
				SE2->E2_CODBAR := aCols[i, nPosBar]
			SE2->(MsUnlock())
		EndIf 
		
		DbSelectArea("FIG")                             
		FIG->(DbGoTo(aCols[i, nPosRec]))
		RecLock("FIG", .F.)
			FIG->FIG_CONCIL := '1'
			FIG->FIG_DTCONC := dDataBase
			FIG->FIG_USCONC := AllTrim(SubStr(cUsuario, 7, 15))
			FIG->FIG_DDASE2 := SubStr(aCols[i, nPosDoc],01,02)+"|"+SubStr(aCols[i, nPosDoc],03,03)+"|"+;
												 SubStr(aCols[i, nPosDoc],06,09)+"|"+SubStr(aCols[i, nPosDoc],15,03)+"|"+;
												 SubStr(aCols[i, nPosDoc],18,03)+"|"+SubStr(aCols[i, nPosDoc],21,09)+"|"+;
												 SubStr(aCols[i, nPosDoc],30,04)+"|"

			// Grava registro na tabela de log
			aTmp := {FIG->(Recno()), dDataBase, SubStr(cUsuario, 7, 15)}
			cMensagem := "Registro conciliado com o título '"+aCols[i, nPosDoc]+"' ."
			U_GRVZZZ(aTmp, cMensagem)
		
		FIG->(MsUnlock())
	End Transaction
	nCont++
Next i   

MsgInfo("Processo de conciliação concluído.")

Return nCont


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que valida se o usuário tem permissão de mecher no parâmetro³
//³de Conciliação Automática.                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function PermiteAlt()
Local lPermite := .F.

DbSelectArea("ZZY")
if ZZY->ZZY_CONCIL == "1"
	lPermite := .T.  
EndIf

Return lPermite


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz a Ordenação do Grid de Acordo com a Preferência do Usuário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function OrdenaGrid(nCboOrd)
Local aColsTmp   := aClone(oMSNewGe1:aCols)
Local aHeaderTmp := oMSNewGe1:aHeader
Local nCol       := aScan(aHeaderTmp, {|x| AllTrim(x[1]) == nCboOrd})                                   
Local bSort      := { |x,y| x[nCol] < y[nCol] }

aColsTmp := aSort(aColsTmp,,,bSort)

oMSNewGe1:aCols := aClone(aColsTmp)       
oMSNewGe1:ForceRefresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
//³Função chamada ao pressionar o botão OK da tela de Registros³
//³Não Preparados.                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ

Static Function GravaFIG(lConcilia)
Local aColsTmp   := oMSNewGe1:aCols
Local aColsGra   := {}
Local aHeaderTmp := oMSNewGe1:aHeader
Local nPosRec, nPosChv, nPosFil, nPosFor, nPosLoj, nPosVen, nPosVal
Local lDeleted   := .F.
Local cChvAnt    := ""
Local nCntDel    := 0
Local nCntAlt    := 0
Local aTmp       := {}
Local cMensagem  := " "
Local nConcil    := 0

// Busca a posição dos campos dentro do array aHeaderTmp
nPosChv := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "E5_DOCUMEN"})
nPosFil := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FILIAL"})
nPosFor := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FORNEC"})
nPosLoj := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_LOJA"})
nPosVen := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VENCTO"})
nPosVal := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VALOR"})
nPosTit := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_TITULO"})
nPosCGC := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_CNPJ"})

DbSelectArea("FIG")         
DbSetOrder(2)		

for i := 1 to len(aColsTmp)
	
	// Cria chave baseada no aColsOld (aCols original, sem alterações)
	cChvAnt := aColsOld[i, nPosFil] + aColsOld[i, nPosFor] + aColsOld[i, nPosLoj] +; 
			  DtoS(aColsOld[i, nPosVen]) + aColsOld[i, nPosTit] 
	
	// Valida se a linha está deletada e elimina o registro da tabela FIG
	lDeleted := GDDeleted(i, aHeaderTmp, aColsTmp)
	cUser := ""
	if lDeleted
  	if FIG->(DbSeek(cChvAnt))
      
      // Valida se o usuário tem permissão de excluir registro
      DbSelectArea("ZZY")
      ZZY->(DbSetOrder(1))                                             
      cUser := AllTrim(SubStr(cUsuario, 7, 15))
      DbSeek(xFilial("ZZY") + cUser)
      if ZZY->ZZY_EXCLUI == "2"
      	MsgStop("Usuário "+cUser+" não tem permissão para excluir registros :( "+CHR(13)+CHR(10)+;
      					"As linhas excluídas não sofrerão alterações!","Item NÃO excluído")
      else
 	      // Alimenta variáveis e invoca função que grava na tabela de log.
      	aTmp := {FIG->(RecNo()), dDataBase, SubStr(cUsuario, 7, 15)}
	      cMensagem := "Registro Excluído."
	      U_GRVZZZ(aTmp, cMensagem)
	      
	   		// Se o usuário tem permissão, exclui o registro da tabela FIG
	  		RecLock("FIG", .F.)
	  		FIG->(DbDelete())
	  		FIG->(MsUnlock())
	  		nCntDel++		
      EndIf
  	EndIf
	EndIf 
	
	// Valida se houve conciliação antes de gravar as alterações na tabela FIG
	if !Empty(aColsTmp[i, nPosChv])	.and. !lDeleted
					 		 
		if FIG->(DbSeek(cChvAnt))
			
			// Gravação de log 
			aTmp := {FIG->(Recno()), dDataBase, SubStr(cUsuario, 7, 15)}
			If FIG->FIG_FILIAL != aColsTmp[i, nPosFil]
					cMensagem := "Alterado de Filial "+FIG->FIG_FILIAL+" para a filial "+aColsTmp[i, nPosFil]+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndIf
			If FIG->FIG_FORNEC != aColsTmp[i, nPosFor]
					cMensagem := "Alterado de Fornec. "+AllTrim(FIG->FIG_FORNEC)+" para o Fornec. "+AllTrim(aColsTmp[i, nPosFor])+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndIf
			If FIG->FIG_LOJA   != aColsTmp[i, nPosLoj]
					cMensagem := "Alterado de Loja "+FIG->FIG_LOJA+" para Loja "+aColsTmp[i, nPosLoj]+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndIf
			If AllTrim(FIG->FIG_NOMFOR) != AllTrim(Posicione("SA2", 01, xFilial("SA2") + aColsTmp[i, nPosFor] + aColsTmp[i, nPosLoj], "A2_NREDUZ"))
					cMensagem := "Nome reduzido alterado de "+AllTrim(FIG->FIG_NOMFOR)+" para "+AllTrim(Posicione("SA2", 01, xFilial("SA2") + aColsTmp[i, nPosFor] + aColsTmp[i, nPosLoj], "A2_NREDUZ"))+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndIf
			If FIG->FIG_CNPJ   != aColsTmp[i, nPosCGC]
					cMensagem := "CGC alterado de "+AllTrim(FIG->FIG_CNPJ)+" para "+AllTrim(aColsTmp[i, nPosCGC])+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndIf
			if FIG->FIG_X_OK   != "S"
					cMensagem := "Registro foi ajustado pelo usuário "+SubStr(cUsuario, 7, 15)+"."
					U_GRVZZZ(aTmp, cMensagem)
			EndiF
			
			// Armazena valores no array que será utilizado para conciliação com SE2
			aAdd(aColsGra, aColsTmp[i])
			
			// Grava as alterações dos registros na tabela FIG
			RecLock("FIG", .F.)			
			FIG->FIG_FILIAL := aColsTmp[i, nPosFil]
			FIG->FIG_FORNEC := aColsTmp[i, nPosFor]
			FIG->FIG_LOJA   := aColsTmp[i, nPosLoj]
			FIG->FIG_NOMFOR := Posicione("SA2", 01, xFilial("SA2") + aColsTmp[i, nPosFor] + aColsTmp[i, nPosLoj], "A2_NREDUZ")
			FIG->FIG_CNPJ   := aColsTmp[i, nPosCGC]
			FIG->FIG_X_OK   := "S"
			FIG->(MsUnlock())
			nCntAlt++
		else
			MsgStop("Não encontrei registro com a chave: "+cChvAnt, "Registro não encontrado")
		EndIf
	EndIf 
Next i

// Valida se o Checkbox de integração automática está marcado.
nConcil := 0
if lConcilia
	nConcil := U_ProcGravaE2(aColsGra, aHeaderTmp)
EndIf

Aviso("Registro(s) Alterado(s)",AllTrim(Str(nCntAlt))+" registro(s) alterado(s). "+CHR(13)+CHR(10)+;
		AllTrim(Str(nCntDel))+" registro(s) apagado(s)."+CHR(13)+CHR(10)+;
		AllTrim(Str(nConcil))+" registro(s) conciliado(s).",{"Ok"})

Return            


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz a busca dos títulos no E2 quando pressionada a tecla F7³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User function BuscaTit(aResult)
Local cChave     := Space(50)
Local cSql       := ""
Local cVarAtu    := ReadVar()
Local nPosCol    := oMSNewGe1:oBrowse:nColPos
Local aColsTmp   := oMSNewGe1:aCols
Local aHeaderTmp := oMSNewGe1:aHeader
Local nPos       := oMSNewGe1:oBrowse:nAt
Local nPosFil, nPosFor, nPosLoj, nPosTit, nPosVal, nPosChv               
Local cEol       := CHR(13) + CHR(10)
Local nMetodo    := 0                              
Local aCab       := {"E2_FILIAL", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_VENCTO", "E2_VALOR", "E2_TIPO", "E2_FORNECE", "E2_LOJA"}
Local aHeaderEx  := {}
Local aDados     := {}
Local aColsEx    := {}
Local aAlterFields := {}
Local cDescMetodo := ""
Local aStruTrb   := {}
Local aBrowse    := {}
Local cArqEmp    := ""
Local lRetorno   := .F.               
Local bOk        := {|| lRetorno:=.T.,oDlgSE2:End()}
Local bCancel    := {|| oDlgSE2:End()}
Local nCnt       := 0
Local aSelect    := {}  
Private lInverte := .F. 
Private cMarca
Private oBrwTrb       
Private oDlgSE2                      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Atribui características aos campos do array de acordo com as configurações do campo na tabela
DbSelectArea("SX3")
SX3->(DbSetOrder(2))

Aadd(aStruTrb, {"OK","C",02,0})
Aadd(aBrowse,  {"OK",,""})

for Nx := 1 to len(aCab)
	if DbSeek(aCab[Nx])
		Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  	Aadd(aStruTrb, {SX3->X3_CAMPO, SX3->X3_TIPO, SX3->X3_TAMANHO, SX3->X3_DECIMAL})
  	Aadd(aBrowse, {SX3->X3_CAMPO,,AllTrim(X3Titulo())})
	EndIf
Next Nx 

if select ("TRBTMP") > 0
	TRBTMP->(DbCloseArea())
EndIf                

cMarca := GetMark()

cArqEmp := CriaTrab(aStruTrb)
dbUseArea(.T., "LOCAL", cArqEmp, "TRBTMP")                                                                   

// Busca a posição dos campos no array
nPosFil := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FILIAL"})
nPosFor := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FORNEC"})
nPosLoj := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_LOJA"})
nPosVen := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VENCTO"})
nPosVal := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VALOR"})
nPosChv := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "E5_DOCUMEN"})
nPosTit := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_TITULO"})
nPosCGC := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_CNPJ"})

lAchou  := .F.
nMetodo := 1

// Faz buscas na tabela de títulos seguindo os níveis da variável nMetodo. 
// Só termina o loop quando encontrar dados que atendam ao método que está sendo utilizado ou depois que todos os métodos já
// tenham sido repassados.

while !lAchou .and. nMetodo <= 5 .and. aResult[1] == "1"
	
	do case
		case nMetodo == 1		// Fornecedor, Vencimento e Valor
			cDescMetodo := "Fornec: "+ aColsTmp[nPos, nPosFor] +" - Vencto: "+ DtoC(aColsTmp[nPos, nPosVen]) +" - Valor: "+cValToChar(aColsTmp[nPos, nPosVal])	
		case nMetodo == 2   // Raiz CNPJ, Vencimento e Valor 
			cDescMetodo := "Fornec: "+ SubStr(aColsTmp[nPos, nPosCGC],1,8) +" - Vencto: "+ DtoC(aColsTmp[nPos, nPosVen]) +;
									   " - Valor: "+cValToChar(aColsTmp[nPos, nPosVal])			
		case nMetodo == 3   // Fornecedor e Valor
			cDescMetodo := "Fornec: "+ aColsTmp[nPos, nPosFor] +" - Valor: "+cValToChar(aColsTmp[nPos, nPosVal])
		case nMetodo == 4   // Vencimento e Valor
			cDescMetodo := "Vencto: "+ DtoC(aColsTmp[nPos, nPosVen]) +" - Valor: "+cValToChar(aColsTmp[nPos, nPosVal])
		case nMetodo == 5   // Valor
			cDescMetodo := "Valor: "+cValToChar(aColsTmp[nPos, nPosVal])
	EndCase
		
	// Montagem do SQL de acordo com o método adequado
	cSql := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VENCTO, E2_VALOR, E2_TIPO, E2_FORNECE, E2_LOJA " + cEol
	cSql += " FROM "+retSqlName("SE2")+" E2 "                                                                      + cEol
	cSql += "WHERE E2.D_E_L_E_T_ <> '*' "                                                                          + cEol
	cSql += "  AND E2.E2_VALOR = E2.E2_SALDO "                                                                     + cEol
	cSql += "  AND E2.E2_TIPO NOT IN ('PA','PR') "                                                                 + cEol
	
	do case
		case nMetodo == 1
			cSql += "  AND E2.E2_FORNECE = '"+ aColsTmp[nPos, nPosFor]       +"' "                                     + cEol
			cSql += "  AND E2.E2_VENCTO  = '"+ DtoS(aColsTmp[nPos, nPosVen]) +"' "                                     + cEol
			cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[nPos, nPosVal])  +"  "                                     + cEol
		case nMetodo == 2
			cSql += "  AND E2.E2_FORNECE = '"+ SubStr(aColsTmp[nPos, nPosCGC],1,8) +"' "                               + cEol
			cSql += "  AND E2.E2_VENCTO  = '"+ DtoS(aColsTmp[nPos, nPosVen]) +"' "                                     + cEol
			cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[nPos, nPosVal])  +"  "                                     + cEol		
		case nMetodo == 3
		  cSql += "  AND E2.E2_FORNECE = '"+ aColsTmp[nPos, nPosFor]       +"' "                                     + cEol
		  cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[nPos, nPosVal])  +"  "                                     + cEol
		case nMetodo == 4
			cSql += "  AND E2.E2_VENCTO  = '"+ DtoS(aColsTmp[nPos, nPosVen]) +"' "                                     + cEol
			cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[nPos, nPosVal])  +"  "                                     + cEol
		case nMetodo == 5
			cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[nPos, nPosVal])  +"  "                                     + cEol
	EndCase
	
	TCQUERY cSql NEW ALIAS "SE2TMP"
	
	DbSelectArea("SE2TMP")
	SE2TMP->(DbGoTop())

	if SE2TMP->(EOF())
		lAchou := .F.
		nMetodo++
		SE2TMP->(DbCloseArea())
	else
		lAchou := .T.
	EndIf
	
End    

// Pesquisa personalizada
if aResult[1] == "2"
	nMetodo := 6
	cDescMetodo := "Personalizado: "+AllTrim(aResult[2])
	
	// Montagem do SQL de acordo com o método adequado
	cSql := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VENCTO, E2_VALOR, E2_TIPO, E2_FORNECE, E2_LOJA " + cEol
	cSql += " FROM "+retSqlName("SE2")+" E2 "                                                                      + cEol
	cSql += "WHERE E2.D_E_L_E_T_ <> '*' "                                                                          + cEol
	cSql += "  AND E2.E2_VALOR   = E2.E2_SALDO "                                                                   + cEol
	cSql += "  AND E2.E2_TIPO NOT IN ('PA','PR') "                                                                 + cEol
	cSql += "  AND E2.E2_FILIAL  = '" + SubStr(aResult[2],01,02) +"' "                                             + cEol
	cSql += "  AND E2.E2_PREFIXO = '" + SubStr(aResult[2],03,03) +"' "                                             + cEol
	cSql += "  AND E2.E2_NUM     = '" + SubStr(aResult[2],06,09) +"' "                                             + cEol
	cSql += "  AND E2.E2_PARCELA = '" + SubStr(aResult[2],15,03) +"' "                                             + cEol
	cSql += "  AND E2.E2_TIPO    = '" + SubStr(aResult[2],18,03) +"' "                                             + cEol
	cSql += "  AND E2.E2_FORNECE = '" + SubStr(aResult[2],21,09) +"' "                                             + cEol
	cSql += "  AND E2.E2_LOJA    = '" + SubStr(aResult[2],30,04) +"' "                                             + cEol
	
	TCQUERY cSql NEW ALIAS "SE2TMP"
	
	DbSelectArea("SE2TMP")
	SE2TMP->(DbGoTop())
	
	if SE2TMP->(EOF())
		SE2TMP->(DbCloseArea())
	else
		lAchou := .T.
	EndIf	
EndIf

if lAchou
  
  // Grava os itens da tabela temporária no aCols para o usuário selecionar
	While !SE2TMP->(EOF())
	  RecLock("TRBTMP", .T.)
	  TRBTMP->OK := Space(2)
	  TRBTMP->E2_FILIAL  := SE2TMP->E2_FILIAL
	  TRBTMP->E2_PREFIXO := SE2TMP->E2_PREFIXO
	  TRBTMP->E2_NUM     := SE2TMP->E2_NUM
	  TRBTMP->E2_PARCELA := SE2TMP->E2_PARCELA
	  TRBTMP->E2_TIPO    := SE2TMP->E2_TIPO
	  TRBTMP->E2_FORNECE := SE2TMP->E2_FORNECE
	  TRBTMP->E2_LOJA    := SE2TMP->E2_LOJA
	  TRBTMP->E2_VENCTO  := StoD(SE2TMP->E2_VENCTO)
	  TRBTMP->E2_VALOR   := SE2TMP->E2_VALOR
	  TRBTMP->(MsUnlock())                  
	  
		SE2TMP->(DbSkip())
	End                          
	
	SE2TMP->(DbCloseArea())
else 
	MsgStop("Não existe título a ser conciliado para esse registro!","Título não localizado")
	Return
EndIf	

  DEFINE MSDIALOG oDlgSE2 TITLE "Contas a Pagar" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL
	  oBrwTrb := MsSelect():New("TRBTMP","OK",,aBrowse,@lInverte,@cMarca,{016,001,100,250})
		oBrwTrb:oBrowse:lCanAllmark := .T.
		Eval(oBrwTrb:oBrowse:bGoTop)
		oBrwTrb:oBrowse:Refresh()  
	
    @ 112, 001 SAY oMetodo PROMPT "Filtro: " SIZE 023, 007 OF oDlgSE2 COLORS 0, 16777215 PIXEL
    @ 112, 018 SAY oMet PROMPT cValToChar(nMetodo) SIZE 015, 007 OF oDlgSE2 COLORS 0, 16777215 PIXEL
    @ 112, 028 SAY oDescMetodo PROMPT cDescMetodo SIZE 145, 007 OF oDlgSE2 COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlgSE2 ON INIT (EnchoiceBar(oDlgSE2,bOk,bCancel,,)) CENTERED VALID lRetorno
  
TRBTMP->(DbGoTop())  

while !TRBTMP->(Eof())
	if !Empty(TRBTMP->OK)
		nCnt++
		Aadd(aSelect, TRBTMP->E2_FILIAL)
		Aadd(aSelect, TRBTMP->E2_PREFIXO)
		Aadd(aSelect, TRBTMP->E2_NUM)
		Aadd(aSelect, TRBTMP->E2_PARCELA)
		Aadd(aSelect, TRBTMP->E2_TIPO)
		Aadd(aSelect, TRBTMP->E2_FORNECE)
		Aadd(aSelect, TRBTMP->E2_LOJA)	
	EndIf
	TRBTMP->(DbSkip())
End                                         

// Valida se o usuário selecionou algum título.
if nCnt == 0
	MsgAlert("Nenhum título selecionado.")
	if Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		TRBTMP->(dbCloseArea())
		Ferase(cArqEmp + OrdBagExt())
	EndIf	
  Return nil

// Valida se o usuário selecionou mais que um título.  
elseIf nCnt > 1
	MsgStop("Selecione apenas um título para cada conciliação.")
	if Select("TRBTMP") > 0
		dbSelectArea("TRBTMP")
		TRBTMP->(dbCloseArea())
		Ferase(cArqEmp + OrdBagExt())
	EndIf
	Return nil
	
else
	cChave := MontaChave(aSelect)
endIf

// Verifica o arquivo temporário ainda existe, se sim, apaga.
if Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	TRBTMP->(dbCloseArea())
	Ferase(cArqEmp + OrdBagExt())
EndIf               

lIgual := .T.
lGrava := .T.
cDif   := ""                                                                       
nOpc   := 0

// Grava informações do título do SE2 no aCols da FIG.
DbSelectArea("SE2")
DbSetOrder(1)
if DbSeek(cChave)
	if (aColsTmp[nPos, nPosFil] != SE2->E2_FILIAL)
		cDif += PadR("Filial DDA: "+aColsTmp[nPos, nPosFil],35) + PadR(" Filial Tit: "+SE2->E2_FILIAL,35)+cEol
	EndIf
	
	if (aColsTmp[nPos, nPosFor] != SE2->E2_FORNECE) .and. !Empty(aColsTmp[nPos, nPosFor])
		cDif += PadR("Fornec DDA: "+aColsTmp[nPos, nPosFor],35) + PadR(" Fornec Tit: "+SE2->E2_FORNECE,35)+cEol
	EndIf                                                                                
	
	if (aColsTmp[nPos, nPosLoj] != SE2->E2_LOJA) .and. !Empty(aColsTmp[nPos, nPosLoj])
		cDif += PadR("Loja DDA..: "+aColsTmp[nPos, nPosLoj],35) + PadR(" Loja Tit..: "+SE2->E2_LOJA,35)+cEol
	EndIf                                                                             
	
	if (aColsTmp[nPos, nPosVen] != SE2->E2_VENCTO)
		cDif += PadR("Vencto DDA: "+DtoC(aColsTmp[nPos, nPosVen]),35) + PadR(" Vencto Tit: "+DtoC(SE2->E2_VENCTO),35)+cEol
	EndIf                                                                               
	
	if (aColsTmp[nPos, nPosVal] != SE2->E2_VALOR)
		cDif += PadR("Valor DDA.: "+cValToChar(aColsTmp[nPos, nPosVal]),35) + PadR(" Valor Tit.: "+cValToChar(SE2->E2_VALOR),35)+cEol
	EndIf                                                                              
	
	if !Empty(cDif)
		lIgual := .F.
	EndIf          
	
	if !lIgual
		lGrava := MsgYesNo(cDif, "Divergência entre Título e DDA. Confirma conciliação??")
	EndIf
	
	// Grava no array da tabela FIG as alterações nos registros de acordo com o título do SE2                
	if lGrava
		
		// Valida se o valor do título é igual ao valor do DDA
		if (aColsTmp[nPos, nPosVal] != SE2->E2_VALOR)
			MsgStop("Você está tentando conciliar registros com valores diferentes. Essa operação não é permitida!","Atenção")
			Return
		EndIf
		
		// Valida se o vencimento do título é igual ao valor do DDA
		if (aColsTmp[nPos, nPosVen] != SE2->E2_VENCTO)
			DbSelectArea("ZZY")
			DbSetOrder(1)
			DbSeek(xFilial("ZZY") + AllTrim(SubStr(cUsuario,7,15)))
			
			nOpc := Aviso("Vencimentos diferentes", "O título que está tentando conciliar está com vencimento "+CHR(13)+CHR(10)+; 
										"diferente do DDA. O que deseja fazer? ",{"Ajust.Vencto","Ignorar"},3)
			
			// Valida cadastro de usuário se tem permissão para executar a operação desejada.
			if nOpc == 1
				if ZZY->ZZY_PRORRO == "1"
					RecLock("SE2", .F.)
					SE2->E2_VENCTO := aColsTmp[nPos, nPosVen]
					SE2->(MsUnlock())
				else
					MsgStop("O usuário "+AllTrim(SubStr(cUsuario,7,15))+" não tem permissão para alterar vencimento do título! :(")
					Return
				EndIf
			elseIf nOpc == 2
				if ZZY->ZZY_VENDIF != "1"
					MsgStop("O usuário "+AllTrim(SubStr(cUsuario,7,15))+" não tem permissão para conciliar com vencimentos diferentes! :(")
					Return
				EndIf
			EndIf
			
		EndIf   
		
		aColsTmp[nPos, nPosChv] := cChave
		aColsTmp[nPos, nPosFil] := SE2->E2_FILIAL
		aColsTmp[nPos, nPosFor] := SE2->E2_FORNECE
		aColsTmp[nPos, nPosLoj] := SE2->E2_LOJA
		aColsTmp[nPos, nPosCGC] := Posicione("SA2", 01, xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_CGC")
	EndIf
else
	MsgStop("Não foi localizado o titulo na tabela SE2 com a chave: "+AllTrim(cChave),"Título não localizado." )		
EndIf
  
Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÛA¿
//³Monta a chave com os itens do array a Select³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ÛAÙ

Static function MontaChave(aSelect)
Local cChave := ""
Local i := 0
for i := 1 to len(aSelect)
	cChave += aSelect[i]
Next i              

Return cChave



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Função da tela de tipo de pesquisa (Automática ou Personalizada)³
//³para encontrar os títulos do E2. Opção F7                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ

User Function FrmPesq()
Local oBtOk
Local oGetChv
Local cGetChv := Space(50)
Local oTipoPesq
Local oTpChave
Local oTpPesq
Local nTpPesq := "1"                                                            
Static oDlgPesq

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  DEFINE MSDIALOG oDlgPesq TITLE "Selecione a Forma de Pesquisa" FROM 000, 000  TO 080, 420 COLORS 0, 16777215 PIXEL

    @ 004, 056 MSCOMBOBOX oTpPesq VAR nTpPesq ITEMS {"1=Automática","2=Personalizada"} SIZE 145, 010 OF oDlgPesq COLORS 0, 16777215 PIXEL
    @ 006, 009 SAY oTipoPesq PROMPT "Tipo de Pesquisa" SIZE 044, 007 OF oDlgPesq COLORS 0, 16777215 PIXEL
    @ 023, 011 SAY oTpChave PROMPT "Chave:" SIZE 025, 007 OF oDlgPesq COLORS 0, 16777215 PIXEL
    @ 021, 037 MSGET oGetChv VAR cGetChv SIZE 125, 010 OF oDlgPesq WHEN (nTpPesq=="2") COLORS 0, 16777215 F3 "SE2DDA" PIXEL
    DEFINE SBUTTON oBtOk FROM 020, 174 TYPE 01 OF oDlgPesq ENABLE ACTION (ExecFil(nTpPesq, cGetChv), Close(oDlgPesq))
    
  ACTIVATE MSDIALOG oDlgPesq CENTERED

Return                                                                                             

Static Function ExecFil(nTpPesq, cChave)
Local aResult := {nTpPesq, cChave}

U_BuscaTit(aResult)

Return


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que faz a procura automática dos títulos no E2 usando ³
//³o filtro padrão (Fornecedor + Vencimento + Valor)            ³
//³Essa função é chamada pela tecla F6.                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function PesqAut(lEnd)
Local cChave     := Space(50)
Local cSql       := ""
Local cVarAtu    := ReadVar()
Local aColsTmp   := oMSNewGe1:aCols
Local aHeaderTmp := oMSNewGe1:aHeader
Local nPosFil, nPosFor, nPosLoj, nPosTit, nPosVal, nPosChv               
Local cEol       := CHR(13) + CHR(10)
Local aTemp      := {}
Local i := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Busca a posição dos campos no array
nPosFil := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FILIAL"})
nPosFor := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_FORNEC"})
nPosLoj := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_LOJA"})
nPosVen := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VENCTO"})
nPosVal := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_VALOR"})
nPosChv := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "E5_DOCUMEN"})
nPosTit := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_TITULO"})
nPosCGC := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "FIG_CNPJ"})

lAchou  := .F.
nMetodo := 1
nQtdReg := 0
SetRegua(len(aColsTmp))

for i := 1 to len(aColsTmp)
	IncRegua()		
	cSql := "SELECT E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_VENCTO, E2_VALOR, E2_TIPO, E2_FORNECE, E2_LOJA " + cEol
	cSql += " FROM "+retSqlName("SE2")+" E2 "                                                                      + cEol
	cSql += "WHERE E2.D_E_L_E_T_ <> '*' "                                                                          + cEol
	cSql += "  AND E2.E2_VALOR   = E2.E2_SALDO "                                                                   + cEol
	cSql += "  AND E2.E2_CODBAR   = ' '        "                                                                   + cEol
	cSql += "  AND E2.E2_FORNECE = '"+ aColsTmp[i, nPosFor]       +"' "                                            + cEol
	cSql += "  AND E2.E2_LOJA =    '"+ aColsTmp[i, nPosLoj]       +"' "                                            + cEol
	cSql += "  AND E2.E2_VENCTO  = '"+ DtoS(aColsTmp[i, nPosVen]) +"' "                                            + cEol
	cSql += "  AND E2.E2_VALOR   = " + Str(aColsTmp[i, nPosVal])  +"  "                                            + cEol
	cSql += "  AND E2.E2_TIPO NOT IN ('PA','PR') "                                                                 + cEol
	
	TCQUERY cSql NEW ALIAS "SE2TMP"
	
	DbSelectArea("SE2TMP")
	SE2TMP->(DbGoTop())
  count to nQtdReg  
  
  SE2TMP->(DbGoTop())
  
  if nQtdReg > 1
  	lAchou := .F.
  	SE2TMP->(DbCloseArea())
  else
  	if SE2TMP->(EOF())
			lAchou := .F.
			SE2TMP->(DbCloseArea())
		else
			lAchou := .T.
		EndIf
  EndIf

	if lAchou
	  aTemp := {}
		While !SE2TMP->(EOF())
	    Aadd(aTemp, SE2TMP->E2_FILIAL)
	    Aadd(aTemp,	SE2TMP->E2_PREFIXO)
	    Aadd(aTemp, SE2TMP->E2_NUM)
	    Aadd(aTemp, SE2TMP->E2_PARCELA)
	    Aadd(aTemp, SE2TMP->E2_TIPO)
	    Aadd(aTemp,	SE2TMP->E2_FORNECE)
	    Aadd(aTemp, SE2TMP->E2_LOJA)
			SE2TMP->(DbSkip())
		End                          
		
		SE2TMP->(DbCloseArea())
		
		cChave := MontaChave(aTemp)               
		lGrava := .T.
		
		// Grava informações do título do SE2 no aCols da FIG.
		DbSelectArea("SE2")
		DbSetOrder(1)
		if DbSeek(cChave)
	
			// Grava no array da tabela FIG as alterações nos registros de acordo com o título do SE2                
			if lGrava			
				aColsTmp[i, nPosChv] := cChave
				aColsTmp[i, nPosFil] := SE2->E2_FILIAL
			EndIf
		EndIf
	EndIf	                                         
Next i
  
Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJREGDDA  ºAutor  Jean                 º Data ³  12/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Cadastro de usuários para controle das rotinas de DDA      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ManZZY()
Local oCancela
Local oCboAjust
Local oCboProrroga
Local oCboVencto
Local oCboExclui
Local oCboConcil
Local oFntPers := TFont():New("Calibri",,014,,.F.,,,,,.F.,.F.)
Local oGetUser
Local oGroup1
Local oGroup2
Local oOk
Local oSayDda
Local oSayPror
Local oSayUsr
Local oSayVen
Local oSayExclui
Local oSayConcil
Static oDlgDda           
Private cGetUser     := Space(15)
Private nCboAjust    := 2
Private nCboProrroga := 2
Private nCboVencto   := 2
Private nCboExclui   := 2
Private nCboConcil   := 2
Private lReturn := .T.               

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


  DEFINE MSDIALOG oDlgDda TITLE "Usuário DDA " FROM 000, 000  TO 230, 400 COLORS 0, 16777215 PIXEL

    @ 010, 067 MSGET      oGetUser     VAR cGetUser Valid (!Empty(cGetUser) .and. BuscaDados()) SIZE 108, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers F3 "US3" PIXEL
    @ 012, 040 SAY oSayUsr     PROMPT "Usuário:"           SIZE 021, 007 OF oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL
    @ 025, 016 SAY oSayPror    PROMPT "Permite Prorrogar:" SIZE 046, 007 OF oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL
    @ 022, 066 MSCOMBOBOX oCboProrroga VAR nCboProrroga ITEMS {"1=Sim","2=Não"} SIZE 024, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers PIXEL
    @ 038, 020 SAY oSayVen     PROMPT "Vencto Diferente:"  SIZE 045, 007 OF oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL
    @ 034, 066 MSCOMBOBOX oCboVencto   VAR nCboVencto   ITEMS {"1=Sim","2=Não"} SIZE 024, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers PIXEL
    @ 046, 066 MSCOMBOBOX oCboAjust    VAR nCboAjust    ITEMS {"1=Sim","2=Não"} SIZE 024, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers PIXEL
    @ 049, 033 SAY oSayDda     PROMPT "Ajusta DDA:"        SIZE 031, 007 OF oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL  
    @ 061, 032 SAY oSayExclui  PROMPT "Excluir DDA:"       SIZE 032, 007 OF oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL
    @ 058, 066 MSCOMBOBOX oCboExclui   VAR nCboExclui   ITEMS {"1=Sim","2=Não"} SIZE 024, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers PIXEL
    @ 073, 016 SAY oSayConcil  PROMPT "Alt. Param Concil:" SIZE 046, 007 of oDlgDda FONT oFntPers COLORS 0, 16777215 PIXEL
    @ 070, 066 MSCOMBOBOX oCboConcil   VAR nCboConcil   ITEMS {"1=Sim","2=Não"} SIZE 024, 010 OF oDlgDda COLORS 0, 16777215 FONT oFntPers PIXEL
    
    @ 093, 004 BUTTON oOk      PROMPT "Ok"                 SIZE 089, 015 OF oDlgDda FONT oFntPers ACTION (Salvar(),LimpaCpos(lReturn))    PIXEL
    @ 093, 097 BUTTON oCancela PROMPT "Cancelar"           SIZE 097, 015 OF oDlgDda FONT oFntPers ACTION oDlgDda:End() PIXEL

  ACTIVATE MSDIALOG oDlgDda CENTERED

Return                                                                                                                


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü¢1L¿
//³Função chamada ao sair do campo "usuário".                  ³
//³Essa função busca os dados do usuário digitado na tabela ZZY³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄü¢1LÙ

Static Function BuscaDados()
DbSelectArea("ZZY")
DbSetOrder(1)
if DbSeek(xFilial("ZZY") + AllTrim(cGetUser))
	nCboProrroga := ZZY->ZZY_PRORRO
	nCboVencto   := ZZY->ZZY_VENDIF
	nCboAjust    := ZZY->ZZY_AJDDA
	nCboExclui   := ZZY->ZZY_EXCLUI
	nCboConcil   := ZZY->ZZY_CONCIL
else
	nCboProrroga := 2
	nCboVencto   := 2
	nCboAjust    := 2
	nCboExclui   := 2              
	nCboConcil   := 2
EndIf
Return .T.


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função chamada ao clicar sobre o OK da tela de cadastro.          ³
//³Ela verifica se o usuário digitado existe, caso exista, o mesmo é ³
//³alterado de acordo com os parâmetros escolhido, senão,            ³
//³é realizado um novo cadastro.                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Salvar()

DbSelectArea("ZZY")
DbSetOrder(1)
if DbSeek(xFilial("ZZY") + AllTrim(cGetUser))
  RecLock("ZZY", .F.)
  ZZY->ZZY_PRORRO := Transform(nCboProrroga,"@!")
  ZZY->ZZY_VENDIF := Transform(nCboVencto,"@!")
  ZZY->ZZY_AJDDA  := Transform(nCboAjust,"@!")
  ZZY->ZZY_EXCLUI := Transform(nCboExclui,"@!")
  ZZY->ZZY_CONCIL := Transform(nCboConcil,"@!")
  ZZY->(MsUnlock())
  MsgInfo("Usuário "+AllTrim(cGetUser)+" alterado com sucesso :)")
else
	RecLock("ZZY", .T.)
	ZZY->ZZY_USUARI := cGetUser
  ZZY->ZZY_PRORRO := Transform(nCboProrroga,"@!")
  ZZY->ZZY_VENDIF := Transform(nCboVencto,"@!")
  ZZY->ZZY_AJDDA  := Transform(nCboAjust,"@!")
  ZZY->ZZY_EXCLUI := Transform(nCboExclui,"@!")
  ZZY->ZZY_CONCIL := Transform(nCboConcil,"@!")
	ZZY->(MsUnlock())
  MsgInfo("Usuário "+AllTrim(cGetUser)+" cadastrado com sucesso :)")
EndIf                                            

lReturn := MsgYesNo("Deseja cadastrar/alterar outro usuário?","")
if !lReturn
	oDlgDda:End()
EndIf

Return                                                                                                    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função chamada caso o usuário deseja alterar/incluir outro³
//³cadastro após dar o Ok.                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function LimpaCpos(lReturn)
if lReturn
	cGetUser     := Space(15)
	nCboProrroga := 2
	nCboVencto   := 2
	nCboAjust    := 2
	nCboExclui   := 2
	nCboConcil   := 2
End
Return                     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AJREGDDA  ºAutor  Jean           º Data ³  12/09/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função chamada para gravar registros de log na tabela Z34  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function GrvZZZ(aDadosFig, cMensagem)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("Z34")
DbSetOrder(1)
RecLock("Z34", .T.)
Z34->Z34_RECFIG := aDadosFig[1]
Z34->Z34_DTALT  := aDadosFig[2]
Z34->Z34_USUARI := aDadosFig[3]
Z34->Z34_LOGALT := cMensagem
Z34->(MsUnlock())
Return
