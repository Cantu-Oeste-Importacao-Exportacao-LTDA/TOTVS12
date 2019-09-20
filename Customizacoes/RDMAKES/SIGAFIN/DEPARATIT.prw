#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DEPARATIT ºAutor  ³Microsiga           º Data ³  05/14/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função que será utilizada para fazer De/Para nos títulos   º±±
±±º          ³ alterando Banco/Agência e Conta a que está relacionado     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function DeParaTit()       
Local nX
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFieldFill   := {}
Local aFields      := {"A6_COD", "A6_AGENCIA", "A6_DVAGE", "A6_NUMCON", "A6_DVCTA", "AGENC","DVAGENC","CONTA","DVCONTA"}
Local aAlterFields := {"AGENC","DVAGENC","CONTA","DVCONTA"}
Local cSql         := ""       
Local nCount       := 0
Static oDlgDePara
Static oGrpBancos 
Private oGetBancos    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    
    elseIf aFields[Nx] == "AGENC"
    	if SX3->(DbSeek("A6_AGENCIA"))
    		Aadd(aHeaderEx, {"Nova Agenc","AGENC",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	
    	EndIf
    
    elseIf aFields[Nx] == "DVAGENC"
    	if SX3->(DbSeek("A6_DVAGE"))
    		Aadd(aHeaderEx, {"Dv Agencia","DVAGENC",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	
    	EndIf
    
    elseIf aFields[Nx] == "CONTA"
    	if SX3->(DbSeek("A6_NUMCON"))
    		Aadd(aHeaderEx, {"Nova Conta","CONTA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	
    	EndIf
    	
    elseIf aFields[Nx] == "DVCONTA"
    	if SX3->(DbSeek("A6_DVCTA"))
    		Aadd(aHeaderEx, {"Dv Conta","DVCONTA",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})	
    	EndIf
    
    Endif
  Next nX               
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca todos os cadastros de bancos, exceto os registros do tipo Caixa³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

  cSql := "SELECT A6_COD, A6_AGENCIA, A6_DVAGE, A6_NUMCON, A6_DVCTA  FROM "+RetSqlName("SA6")+" A6 "
	cSql += "WHERE A6.D_E_L_E_T_ <> '*' "
	cSql += "  AND A6.A6_COD NOT BETWEEN 'C  ' AND 'CZZ' "
	cSql += "  AND A6.A6_BLOCKED <> '1' "
	cSql += "ORDER BY A6_COD, A6_AGENCIA, A6_DVAGE, A6_NUMCON, A6_DVCTA "
  
  TCQUERY cSql NEW ALIAS "SA6TMP"
  
  DbSelectArea("SA6TMP")
  SA6TMP->(DbGoTop())
    
  if SA6TMP->(EOF())
  	SA6TMP->(DbCloseArea())
  	Alert("Não foram encontrados cadastros de bancos.")
  	Return
  EndIf                                                
  
  While !SA6TMP->(EOF())
  	aAdd(aFieldFill, {SA6TMP->A6_COD, SA6TMP->A6_AGENCIA, SA6TMP->A6_DVAGE, SA6TMP->A6_NUMCON, SA6TMP->A6_DVCTA,; 
  									  SA6TMP->A6_AGENCIA, SA6TMP->A6_DVAGE, SA6TMP->A6_NUMCON, SA6TMP->A6_DVCTA, .F.})
  	
  	SA6TMP->(DbSkip())
  EndDo
  
  SA6TMP->(DbCloseArea())
  
  aColsEx := aClone(aFieldFill)

  DEFINE MSDIALOG oDlgDePara TITLE "De/Para Títulos" FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
    
    oGetBancos := MsNewGetDados():New( 012, 003, 245, 398, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aAlterFields, 0, Len(aColsEx), "AllwaysTrue", "", "AllwaysTrue", oDlgDePara, aHeaderEx, aColsEx)
    oGetBancos:oBrowse:Refresh()
    
    @ 004, 001 GROUP oGrpBancos TO 248, 298 PROMPT "  Bancos da Empresa:  " OF oDlgDePara COLOR 0, 16777215 PIXEL
    
  ACTIVATE MSDIALOG oDlgDePara CENTER ON INIT	EnchoiceBar(oDlgDePara,{|| AltTitFin(), oDlgDePara:End(), oDlgDePara:End(), Nil }, {|| oDlgDePara:End() })

Return
                                                                                  
                                                                                  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a validação dos dados e alteração nas tabelas.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AltTitFin()
Local i          := 0
Local nPosCod    := 0
Local nPosAge    := 0
Local nPosDvAge  := 0
Local nPosCon    := 0
Local nPosDvCon  := 0
Local nPosNAge   := 0
Local nPosNDvAge := 0
Local nPosNCon   := 0
Local nPosNDvCon := 0
Local aColsTmp   := oGetBancos:aCols
Local aHeaderTmp := oGetBancos:aHeader
Local cSql       := ""
Local cCodigo, cAgencia, cConta := ""
Local aBcoDe     := {}
Local aBcoPara   := {}

nPosCod    := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "A6_COD"})
nPosAge    := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "A6_AGENCIA"})
nPosDvAge  := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "A6_DVAGE"})
nPosCon    := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "A6_NUMCON"})
nPosDvCon  := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "A6_DVCTA"})
nPosNAge   := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "AGENC"})
nPosNDvAge := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "DVAGENC"})
nPosNCon   := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "CONTA"})
nPosNDvCon := aScan(aHeaderTmp, {|x| AllTrim(x[2]) == "DVCONTA"})

for i := 1 to len(aColsTmp)
	if aColsTmp[i, nPosAge] != aColsTmp[i, nPosNAge] .or. aColsTmp[i, nPosDvAge] != aColsTmp[i, nPosNDvAge] .or.;
		 aColsTmp[i, nPosCon] != aColsTmp[i, nPosNCon] .or. aColsTmp[i, nPosDvCon] != aColsTmp[i, nPosNDvCon]
		 
		 aBcoDe   := {aColsTmp[i, nPosCod], aColsTmp[i, nPosAge], aColsTmp[i, nPosDvAge], aColsTmp[i, nPosCon], aColsTmp[i, nPosDvCon]}
		 aBcoPara := {aColsTmp[i, nPosNAge], aColsTmp[i, nPosNDvAge], aColsTmp[i, nPosNCon], aColsTmp[i, nPosNDvCon]}
		 
		 RptStatus({|lEnd| fAltSE1(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Contas a Receber (SE1)"    , .T.)
		 
		 RptStatus({|lEnd| fAltSE5(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Movimentos Bancários (SE5)", .T.)
		 
		 RptStatus({|lEnd| fAltSE8(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Saldos Bancários (SE8)", .T.)
		 
		 RptStatus({|lEnd| fAltSE9(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Contratos Bancários (SE9)", .T.)
		 
		 RptStatus({|lEnd| fAltSEA(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Titulos Enviados ao Banco (SEA)", .T.)
		 
		 RptStatus({|lEnd| fAltSEF(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Cheques (SEF)", .T.)
		 
		 RptStatus({|lEnd| fAltSEG(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Aplicações (SEG)", .T.)
		 
		 RptStatus({|lEnd| fAltSEH(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Aplicações/Empréstimo (SEH)", .T.)
		 
		 RptStatus({|lEnd| fAltSEI(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Mov. de Aplic./Empr. (SEI)", .T.)
		 
		 RptStatus({|lEnd| fAltSEL(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Recibos (SEL)", .T.)
		 
		 RptStatus({|lEnd| fAltSEE(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Parâmetros de Bancos (SEE)"  , .T.)
		 
		 RptStatus({|lEnd| fAltSA6(aBcoDe, aBcoPara, @lEnd)}, "Aguarde...","Atualizando Tabela de Cadastro de Bancos (SA6)"  , .T.)
	   
	EndIf

Next i

MsgInfo("Processo Concluído com Sucesso!")

Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SE1³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSE1(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SE1")
	
	cSql := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO FROM "+ retSqlName("SE1") +" E1 "
	cSql += "WHERE E1.D_E_L_E_T_ <> '*' "
	cSql += "  AND E1.E1_PORTADO = '"+ aBcoDe[01] +"' "
	cSql += "  AND E1.E1_AGEDEP  = '"+ aBcoDe[02] +"' "
	cSql += "  AND E1.E1_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO"
	
	TCQUERY cSql NEW ALIAS "SE1TMP"
	
	DbSelectArea("SE1TMP")
	SE1TMP->(DbGoTop())
	
	count to nCount
	
	SE1TMP->(DbGoTop())
	
	if SE1TMP->(EOF())
		SE1TMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SE1TMP->(EOF())
		IncRegua()      
		DbSelectArea("SE1")
		SE1->(DbSetOrder(1))
		cChave := SE1TMP->E1_FILIAL + SE1TMP->E1_PREFIXO + SE1TMP->E1_NUM + SE1TMP->E1_PARCELA + SE1TMP->E1_TIPO
				
		if (DbSeek(cChave)) 
			RecLock("SE1", .F.) 
				SE1->E1_AGEDEP := aBcoPara[01]
				SE1->E1_CONTA  := aBcoPara[03]
			SE1->(MsUnlock())
		else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SE1TMP->(DbSkip())
	EndDo
	
	SE1TMP->(DbCloseArea())
	
EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SE5³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSE5(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SE5")
	
	cSql := "SELECT E5_FILIAL || E5_DATA || E5_BANCO || E5_AGENCIA || E5_CONTA || E5_NUMCHEQ AS CHAVE FROM "+ retSqlName("SE5") +" E5 "
	cSql += "WHERE E5.D_E_L_E_T_ <> '*' "
	cSql += "  AND E5.E5_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND E5.E5_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND E5.E5_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY CHAVE "
	
	TCQUERY cSql NEW ALIAS "SE5TMP"
	
	DbSelectArea("SE5TMP")
	SE5TMP->(DbGoTop())
	
	count to nCount
	
	SE5TMP->(DbGoTop())
	
	if SE5TMP->(EOF())
		SE5TMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SE5TMP->(EOF())
		IncRegua()         
		DbSelectArea("SE5")
		SE5->(DbSetOrder(1))
		cChave := SE5TMP->CHAVE
		
		if DbSeek(cChave)
			RecLock("SE5", .F.)
				SE5->E5_AGENCIA := aBcoPara[01]
				SE5->E5_CONTA   := aBcoPara[03]
			SE5->(MsUnlock())
		else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SE5TMP->(DbSkip())
	EndDo
	
	SE5TMP->(DbCloseArea())
	
EndIf

Return .T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SE8³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSE8(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := 0

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SE8")
	
	cSql := "SELECT E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_DTSALAT FROM "+ retSqlName("SE8") +" E8 "
	cSql += "WHERE E8.D_E_L_E_T_ <> '*' "
	cSql += "  AND E8.E8_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND E8.E8_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND E8.E8_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY E8_FILIAL, E8_BANCO, E8_AGENCIA, E8_CONTA, E8_DTSALAT"
	
	TCQUERY cSql NEW ALIAS "SE8TMP"
	
	DbSelectArea("SE8TMP")
	SE8TMP->(DbGoTop())
	
	count to nCount
	
	SE8TMP->(DbGoTop())
	
	if SE8TMP->(EOF())
		SE8TMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SE8TMP->(EOF())
		IncRegua()       
		DbSelectArea("SE8")
		SE8->(DbSetOrder(1))
		cChave := SE8TMP->E8_FILIAL + SE8TMP->E8_BANCO + SE8TMP->E8_AGENCIA + SE8TMP->E8_CONTA + SE8TMP->E8_DTSALAT
		
		if DbSeek(cChave)
			RecLock("SE8", .F.)
				SE8->E8_AGENCIA := aBcoPara[01]
				SE8->E8_CONTA   := aBcoPara[03]
			SE8->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SE8TMP->(DbSkip())
	EndDo
	
	SE8TMP->(DbCloseArea())
	
EndIf

Return .T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SE9³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSE9(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0      
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SE9")
	
	cSql := "SELECT E9_FILIAL, E9_NUMERO, E9_BANCO, E9_AGENCIA FROM "+ retSqlName("SE9") +" E9 "
	cSql += "WHERE E9.D_E_L_E_T_ <> '*' "
	cSql += "  AND E9.E9_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND E9.E9_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND E9.E9_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY E9_FILIAL, E9_NUMERO, E9_BANCO, E9_AGENCIA"
		
	TCQUERY cSql NEW ALIAS "SE9TMP"
	
	DbSelectArea("SE9TMP")
	SE9TMP->(DbGoTop())
	
	count to nCount
	
	SE9TMP->(DbGoTop())
	
	if SE9TMP->(EOF())
		SE9TMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SE9TMP->(EOF())
		IncRegua()       
		DbSelectArea("SE9")
		SE9->(DbSetOrder(1))
		cChave := SE9TMP->E9_FILIAL + SE9TMP->E9_NUMERO + SE9TMP->E9_BANCO + SE9TMP->E9_AGENCIA
		
		if DbSeek(cChave)
			RecLock("SE9", .F.)
				SE9->E9_AGENCIA := aBcoPara[01]
				SE9->E9_CONTA   := aBcoPara[03]
			SE9->(MsUnlock())
		Else
			Alert("Não encontrei chave: "+cChave)
		EndIf
		SE9TMP->(DbSkip())
	EndDo
	
	SE9TMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEA³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEA(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEA")
	
	cSql := "SELECT EA_FILIAL, EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_TIPO, EA_FORNECE, EA_LOJA FROM "+ retSqlName("SEA") +" EA "
	cSql += "WHERE EA.D_E_L_E_T_ <> '*' "
	cSql += "  AND EA.EA_PORTADO = '"+ aBcoDe[01] +"' "
	cSql += "  AND EA.EA_AGEDEP  = '"+ aBcoDe[02] +"' "
	cSql += "  AND EA.EA_NUMCON  = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EA_FILIAL, EA_NUMBOR, EA_PREFIXO, EA_NUM, EA_PARCELA, EA_TIPO, EA_FORNECE, EA_LOJA"
		
	TCQUERY cSql NEW ALIAS "SEATMP"
	
	DbSelectArea("SEATMP")
	SEATMP->(DbGoTop())
	
	count to nCount
	
	SEATMP->(DbGoTop())
	
	if SEATMP->(EOF())
		SEATMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SEATMP->(EOF())
		IncRegua()
		DbSelectArea("SEA")
		SEA->(DbSetOrder(1))
		cChave := SEATMP->EA_FILIAL + SEATMP->EA_NUMBOR + SEATMP->EA_PREFIXO + SEATMP->EA_NUM + SEATMP->EA_PARCELA + SEATMP->EA_TIPO +;
						  SEATMP->EA_FORNECE + SEATMP->EA_LOJA
		if DbSeek(cChave)		
			RecLock("SEA", .F.)
				SEA->EA_AGEDEP := aBcoPara[01]
				SEA->EA_NUMCON := aBcoPara[03]
			SEA->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SEATMP->(DbSkip())
	EndDo
	
	SEATMP->(DbCloseArea())
	
EndIf

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEF³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEF(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0        
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEF")
	
	cSql := "SELECT EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM FROM "+ retSqlName("SEF") +" EF "
	cSql += "WHERE EF.D_E_L_E_T_ <> '*' "
	cSql += "  AND EF.EF_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND EF.EF_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND EF.EF_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EF_FILIAL, EF_BANCO, EF_AGENCIA, EF_CONTA, EF_NUM"
		
	TCQUERY cSql NEW ALIAS "SEFTMP"
	
	DbSelectArea("SEFTMP")
	SEFTMP->(DbGoTop())
	
	count to nCount
	
	SEFTMP->(DbGoTop())
	
	if SEFTMP->(EOF())
		SEFTMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SEFTMP->(EOF())
		IncRegua()       
		DbSelectArea("SEF")
		SEF->(DbSetOrder(1))
		cChave := SEFTMP->EF_FILIAL + SEFTMP->EF_BANCO + SEFTMP->EF_AGENCIA + SEFTMP->EF_CONTA + SEFTMP->EF_NUM
		
		if DbSeek(cChave)
			RecLock("SEF", .F.)
				SEF->EF_AGENCIA := aBcoPara[01]
				SEF->EF_CONTA   := aBcoPara[03]
			SEF->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SEFTMP->(DbSkip())
	EndDo
	
	SEFTMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEG³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEG(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEG")
	
	cSql := "SELECT EG_FILIAL, EG_TIPO, EG_BANCO, EG_AGENCIA, EG_CONTA, EG_DATA FROM "+ retSqlName("SEG") +" EG "
	cSql += "WHERE EG.D_E_L_E_T_ <> '*' "
	cSql += "  AND EG.EG_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND EG.EG_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND EG.EG_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EG_FILIAL, EG_TIPO, EG_BANCO, EG_AGENCIA, EG_CONTA, EG_DATA"
		
	TCQUERY cSql NEW ALIAS "SEGTMP"
	
	DbSelectArea("SEGTMP")
	SEGTMP->(DbGoTop())
	
	count to nCount
	
	SEGTMP->(DbGoTop())
	
	if SEGTMP->(EOF())
		SEGTMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SEGTMP->(EOF())
		IncRegua()       
		DbSelectArea("SEG")
		SEG->(DbSetOrder(1))
		cChave := SEGTMP->EG_FILIAL + SEGTMP->EG_TIPO + SEGTMP->EG_BANCO + SEGTMP->EG_AGENCIA + SEGTMP->EG_CONTA + SEGTMP->EG_DATA
		
		if DbSeek(cChave)
			RecLock("SEG", .F.)
				SEG->EG_AGENCIA := aBcoPara[01]
				SEG->EG_CONTA   := aBcoPara[03]
			SEG->(MsUnlock())
		Else
			Alert("Não encontrei chave: "+cChave)
		EndIf
		SEGTMP->(DbSkip())
	EndDo
	
	SEGTMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEH³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEH(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEH")
	
	cSql := "SELECT EH_FILIAL, EH_NUMERO, EH_REVISAO FROM "+ retSqlName("SEH") +" EH "
	cSql += "WHERE EH.D_E_L_E_T_ <> '*' "
	cSql += "  AND EH.EH_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND EH.EH_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND EH.EH_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EH_FILIAL, EH_NUMERO, EH_REVISAO"
		
	TCQUERY cSql NEW ALIAS "SEHTMP"
	
	DbSelectArea("SEHTMP")
	SEHTMP->(DbGoTop())
	
	count to nCount
	
	SEHTMP->(DbGoTop())
	
	if SEHTMP->(EOF())
		SEHTMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SEHTMP->(EOF())
		IncRegua()       
		DbSelectArea("SEH")
		SEH->(DbSetOrder(1))
		cChave := SEHTMP->EH_FILIAL + SEHTMP->EH_NUMERO + SEHTMP->EH_REVISAO

		if DbSeek(cChave)
			RecLock("SEH", .F.)
				SEH->EH_AGENCIA := aBcoPara[01]
				SEH->EH_CONTA   := aBcoPara[03]
			SEH->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SEHTMP->(DbSkip())
	EndDo
	
	SEHTMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEI(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEI")
	
	cSql := "SELECT EI_FILIAL, EI_APLEMP, EI_NUMERO, EI_REVISAO, EI_MOTBX, EI_DTDIGIT, EI_TIPODOC, EI_SEQ FROM "+ retSqlName("SEI") +" EI "
	cSql += "WHERE EI.D_E_L_E_T_ <> '*' "
	cSql += "  AND EI.EI_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND EI.EI_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND EI.EI_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EI_FILIAL, EI_APLEMP, EI_NUMERO, EI_REVISAO, EI_MOTBX, EI_DTDIGIT, EI_TIPODOC, EI_SEQ "
		
	TCQUERY cSql NEW ALIAS "SEITMP"
	
	DbSelectArea("SEITMP")
	SEITMP->(DbGoTop())
	
	count to nCount
	
	SEITMP->(DbGoTop())
	
	if SEITMP->(EOF())
		SEITMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SEITMP->(EOF())
		IncRegua()       
		DbSelectArea("SEI")
		SEI->(DbSetOrder(2))
		cChave := SEITMP->EI_FILIAL + SEITMP->EI_APLEMP + SEITMP->EI_NUMERO + SEITMP->EI_REVISAO +;
							SEITMP->EI_MOTBX + SEITMP->EI_DTDIGIT + SEITMP->EI_TIPODOC + SEITMP->EI_SEQ
		
		if DbSeek(cChave)
			RecLock("SEI", .F.)
				SEI->EI_AGENCIA := aBcoPara[01]
				SEI->EI_CONTA   := aBcoPara[03]
			SEI->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		EndIf
		SEITMP->(DbSkip())
	EndDo
	
	SEITMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará as alterações na tabela SEL³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEL(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

if aBcoDe[02] != aBcoPara[01] .or. aBcoDe[04] != aBcoPara[03]
	
	DbSelectArea("SEL")
	
	cSql := "SELECT EL_FILIAL, EL_RECIBO, EL_TIPODOC, EL_PREFIXO, EL_NUMERO, EL_PARCELA, EL_TIPO FROM "+ retSqlName("SEL") +" EL "
	cSql += "WHERE EL.D_E_L_E_T_ <> '*' "
	cSql += "  AND EL.EL_BANCO   = '"+ aBcoDe[01] +"' "
	cSql += "  AND EL.EL_AGENCIA = '"+ aBcoDe[02] +"' "
	cSql += "  AND EL.EL_CONTA   = '"+ aBcoDe[04] +"' "
	cSql += "ORDER BY EL_FILIAL, EL_RECIBO, EL_TIPODOC, EL_PREFIXO, EL_NUMERO, EL_PARCELA, EL_TIPO"
	
	TCQUERY cSql NEW ALIAS "SELTMP"
	
	DbSelectArea("SELTMP")
	SELTMP->(DbGoTop())
	
	count to nCount
	
	SELTMP->(DbGoTop())
	
	if SELTMP->(EOF())
		SELTMP->(DbCloseArea())
		Return
	EndIf   
	
	SetRegua(nCount)
	
	While !SELTMP->(EOF())
		IncRegua()        
		DbSelectArea("SEL")
		SEL->(DbSetOrder(1))
		cChave := SELTMP->EL_FILIAL + SELTMP->EL_RECIBO + SELTMP->EL_TIPODOC + SELTMP->EL_PREFIXO +; 
							SELTMP->EL_NUMERO + SELTMP->EL_PARCELA + SELTMP->EL_TIPO
							
  	if DbSeek(cChave)
			RecLock("SEL", .F.)
				SEL->EL_AGENCIA := aBcoPara[01]
				SEL->EL_CONTA   := aBcoPara[03]
			SEL->(MsUnlock())
		Else
			Alert("Chave não encontrada: "+cChave)
		Endif
		SELTMP->(DbSkip())
	EndDo
	
	SELTMP->(DbCloseArea())
	
EndIf

Return .T.  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a alteração de dados na tabela SA6³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSA6(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

DbSelectArea("SA6")

cSql := "SELECT A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON FROM "+ retSqlName("SA6") +" A6 "
cSql += "WHERE A6.D_E_L_E_T_ <> '*' "
cSql += "  AND A6.A6_COD     = '"+ aBcoDe[01] +"' "
cSql += "  AND A6.A6_AGENCIA = '"+ aBcoDe[02] +"' "
cSql += "  AND A6.A6_DVAGE   = '"+ aBcoDe[03] +"' "
cSql += "  AND A6.A6_NUMCON  = '"+ aBcoDe[04] +"' "
cSql += "  AND A6.A6_DVCTA   = '"+ aBcoDe[05] +"' "
cSql += "ORDER BY A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON "

TCQUERY cSql NEW ALIAS "SA6ALT"

DbSelectArea("SA6ALT")
SA6ALT->(DbGoTop())

count to nCount

SA6ALT->(DbGoTop())

if SA6ALT->(EOF())
	SA6ALT->(DbCloseArea())
	Return
EndIf 

SetRegua(nCount)

While !SA6ALT->(EOF())
	IncRegua()       
	DbSelectArea("SA6")
	SA6->(DbSetOrder(1))
	cChave := SA6ALT->A6_FILIAL + SA6ALT->A6_COD + SA6ALT->A6_AGENCIA + SA6ALT->A6_NUMCON
	
	if DbSeek(cChave)
		RecLock("SA6", .F.)
			SA6->A6_AGENCIA := aBcoPara[01]
			SA6->A6_DVAGE   := aBcoPara[02]
			SA6->A6_NUMCON  := aBcoPara[03]
			SA6->A6_DVCTA   := aBcoPara[04]
		SA6->(MsUnlock())
	Else
		Alert("Chave não encontrada: "+cChave)
	EndIf 
	
	SA6ALT->(DbSkip())
EndDo

SA6ALT->(DbCloseArea())

Return .T.         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que fará a alteração de dados na tabela SEE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function fAltSEE(aBcoDe, aBcoPara, lEnd)
Local cSql   := ""
Local nCount := 0
Local      i := 0       
Local cChave := ""

DbSelectArea("SEE")

cSql := "SELECT EE_FILIAL, EE_CODIGO, EE_AGENCIA, EE_CONTA, EE_SUBCTA FROM "+ retSqlName("SEE") +" EE "
cSql += "WHERE EE.D_E_L_E_T_ <> '*' "
cSql += "  AND EE.EE_CODIGO  = '"+ aBcoDe[01] +"' "
cSql += "  AND EE.EE_AGENCIA = '"+ aBcoDe[02] +"' "
cSql += "  AND EE.EE_DVAGE   = '"+ aBcoDe[03] +"' "
cSql += "  AND EE.EE_CONTA   = '"+ aBcoDe[04] +"' "
cSql += "  AND EE.EE_DVCTA   = '"+ aBcoDe[05] +"' "
cSql += "ORDER BY EE_FILIAL, EE_CODIGO, EE_AGENCIA, EE_CONTA, EE_SUBCTA "

TCQUERY cSql NEW ALIAS "SEETMP"

DbSelectArea("SEETMP")
SEETMP->(DbGoTop())

count to nCount

SEETMP->(DbGoTop())

if SEETMP->(EOF())
	SEETMP->(DbCloseArea())
	Return
EndIf 

SetRegua(nCount)

While !SEETMP->(EOF())
	IncRegua()       
	DbSelectArea("SEE")
	SEE->(DbSetOrder(1))
	cChave := SEETMP->EE_FILIAL + SEETMP->EE_CODIGO + SEETMP->EE_AGENCIA + SEETMP->EE_CONTA + SEETMP->EE_SUBCTA
	
	if DbSeek(cChave)
		RecLock("SEE", .F.)
			SEE->EE_AGENCIA := aBcoPara[01]
			SEE->EE_DVAGE   := aBcoPara[02]
			SEE->EE_CONTA   := aBcoPara[03]
			SEE->EE_DVCTA   := aBcoPara[04]
		SEE->(MsUnlock()) 
	Else
		Alert("Chave não encontrada: "+cChave)
	EndIf
	SEETMP->(DbSkip())
EndDo

SEETMP->(DbCloseArea())

Return .T.        