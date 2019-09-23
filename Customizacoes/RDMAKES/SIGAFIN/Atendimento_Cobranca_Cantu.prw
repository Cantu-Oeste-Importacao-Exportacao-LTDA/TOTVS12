#Include "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
//--------------------------------------------------------------
/*/{Protheus.doc} AtendCobr
Description                                                     
                                                                
@param xParam Parameter Description                             
@return xRet Return Description                                 
@author Flavio Dias - diasflav@gmail.com                                              
@since 14/4/2011                                                   
/*/                                                             
//--------------------------------------------------------------
User Function AtendCobr(cAlias, nReg, nOpc)
Local aAreaTMP := GetArea()
Local cObsCob := ""  // SA1->A1_X_OBCOB
Local oObsCob
Local oCliente
Local cCliente := ""
Local oButton1
Local oButton2
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oGetSCli
Local cSitCli := ""
Local oISitCli := {"  ", "01=Equipe CR", "02=Tercerizada", "03=CR Transp", "04=Cheque Devol", "05=Conf. Divida", ;
										"06=Juridico", "07=Cheque Pre", "08=Comprov. Banco", "09=PDD"}
Local oTelefone
Local cTelefone := ""
Local cTit := "Atendimento Cobrança"
Local aButtons := {}
Static oFolder1
Static oDlg
Static aSituacao := { {"0", "Carteira"}, {"1", "Cob.Simples"}, {"2","Descontada"},{"3","Caucionada"},;
					{"4","Vinculada"},{"5","Advogado"},{"6","Judicial"}, {"7", "Cob Caucao Descont"},;
					{"A", "Cob. Terceirizada"}, {"B", "CR Transportadora"}, {"C", "Cheque Devolvido"},;
					{"D", "Confissao de Divida"}, {"E", "Juridico"}, {"F", "Carteira Protesto"},;
					{"G", "Carteira Acordo"}, {"H", "Cob. Terceirizada"}, {"I", "Cheque Pre"},; 
					{"J", "Comprovante de Banco"} }
Static cStatus := "" // status do atendimento, de acordo com a opcao

Aadd( aButtons, {"Contatos", {|| U_RJCONSA1()}, "Contatos...", "Contatos" , {|| .T.}} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


if (nOpc == 5) // Reagendar
	ProrAtend()
	Return
elseif (nOpc == 6) // finalizar lista
	FinalCob()
	Return
EndIf

// permite alterar um atendimento já efetuado
If !(ZZJ->ZZJ_STATUS $ "01/02/03/05/06") 
	MsgInfo("Atendimento já finalizado")
	Return
EndIf

If nOpc == 4
	ZZO->(dbSetOrder(01))
	If ZZO->(!dbSeek(xFilial("ZZO")+cUserName))
	  MsgInfo("Necessário cadastrar permissão para cancelar atendimento.")
	  Return
	EndIf
	
	If !ZZO->ZZO_CANCEL
	  Alert("Usuário sem permissão para cancelar atendimento.")
	  Return
	EndIf	
EndIf
                                                                      // R = Reagendar
cStatus := iif(nOpc == 2, "", iif(nOpc == 3, "A", iif(nOpc == 4, "C", "R")))
					
// Faz o posiconamento no cliente e obtém os dados dele
SA1->(dbSetOrder(01))
SA1->(dbSeek(xFilial("SA1") + ZZJ->ZZJ_CODCLI + ZZJ->ZZJ_LOJCLI))

cTit := TRIM(SA1->A1_NOME) + " - " + cTit
cTelefone := SA1->A1_DDD + SA1->A1_TEL
If !Empty(SA1->A1_TELEX)
	cTelefone2 := SA1->A1_DDD + SA1->A1_TELEX
ElseIf !Empty(SA1->A1_FAX)
  cTelefone2 := SA1->A1_DDD + SA1->A1_FAX
Else
  cTelefone2 := ""
EndIf
	
cCliente := SA1->A1_NREDUZ
cObsCob := SA1->A1_X_OBCOB // SA1->A1_X_OBCOB
cSitCli := SA1->A1_X_SCOBR
nVlrNom := ZZJ->ZZJ_SALDO
nVlrJur := ZZJ->ZZJ_SALDO

dbSelectArea("ZZI")
dbSetOrder(2)
dbSeek(xFilial("ZZI")+ZZJ->ZZJ_CODLIS)
conout("lista ZZJ="+ZZJ->ZZJ_CODLIS)
conout("lista ZZI="+ZZI->ZZI_CODIGO)


  DEFINE MSDIALOG oDlg TITLE cTit FROM 000, 000  TO 590, 750 COLORS 0, 16777215 PIXEL
    
    @ 048, 005 FOLDER oFolder1 SIZE 380, 114 OF oDlg ITEMS "Titulos Vencidos","Titulos Pagos","Titulos a Vencer" COLORS 0, 16777215 PIXEL
	fGD_TitPG()     
    fGD_TitAV()     
    fGD_TitAb(nOpc) 
    @ 082, 017 BUTTON oButton3 PROMPT "Prorogar" SIZE 037, 012 ACTION Prorogar() OF oFolder1:aDialogs[1] PIXEL
    @ 082, 069 BUTTON oButton4 PROMPT "Posição Tit" SIZE 037, 012 ACTION Posicao() OF oFolder1:aDialogs[1] PIXEL
    @ 082, 121 BUTTON oButton1 PROMPT "Posicao Cli" SIZE 037, 012 ACTION FC010CON() OF oFolder1:aDialogs[1] PIXEL
    @ 082, 173 BUTTON oButton2 PROMPT "Calc. Juros" SIZE 037, 012 ACTION FCALCJUR() OF oFolder1:aDialogs[1] PIXEL
    @ 160, 005 MSPANEL oPanel1 SIZE 380, 078 OF oDlg COLORS 0, 16777215 RAISED
    @ 012, 007 GET oObsCob VAR cObsCob WHEN (nOpc == 3) OF oPanel1 MULTILINE SIZE 352, 044 COLORS 0, 16777215 HSCROLL PIXEL
    
	@ 069, 007 Say oSay4 PROMPT "Situação Cliente:"  SIZE 071, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 068, 070 COMBOBOX oGetSCli VAR cSitCli ITEMS oISitCli WHEN (nOpc == 3) OF oPanel1 SIZE 060, 007 COLORS 0, 16777215 PIXEL
                                                                                     
    @ 006, 006 SAY oSay1 PROMPT "Dados da cobrança" SIZE 071, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
    @ 030, 005 MSPANEL oPanel2 SIZE 390, 022 OF oDlg COLORS 0, 16777215 RAISED
    @ 005, 005 SAY oSay2 PROMPT "Nome Fantasia" SIZE 042, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 005, 046 MSGET oCliente  VAR cCliente     SIZE 114, 007 WHEN .F. OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 005, 170 SAY oSay3 PROMPT "Telefones:"     SIZE 030, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 005, 196 MSGET oTelefone VAR cTelefone    SIZE 071, 007 WHEN .F. OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 005, 280 MSGET oTelefone2 VAR cTelefone2    SIZE 071, 007 WHEN .F. OF oPanel2 COLORS 0, 16777215 PIXEL
    
    
		
  ACTIVATE MSDIALOG oDlg CENTERED ON INIT ;
	EnchoiceBar(oDlg,{|| GrvDados(cObsCob, nOpc, cSitCli), Nil }, {|| oDlg:End() },,aButtons)
	
	
	RestArea(aAreaTMP)
	
Return

//------------------------------------------------ 
Static Function fGD_TitPG()
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {} //E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, E1_VENCREA, E1_VENCORI, E1_VALOR, E1_SALDO, E1_SITUACA
Local aFields := {"E1_MSEMP", "E1_FILIAL", "E1_TIPO", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_EMISSAO", "E1_VENCREA", "E1_BAIXA", "E1_VALOR"}
Local aAlterFields := {}
Static oGD_TitPG

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
  Aadd(aHeaderEx, {"Atraso Pag.","E1_DIASATR","",6,0, , ,"N"})

  // Define field values
  /*For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)*/
  
  // Carrega as informações dos títulos baixados do cliente
  BeginSql Alias "TMPTAB"
  	SELECT 		%Exp:cEmpAnt% AS E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, 
  				E1_EMISSAO, E1_VENCREA, E1_VENCORI, E1_VALOR, E1_SALDO, E1_SITUACA, E1_BAIXA
  	FROM 		%TABLE:SE1% SE1
  				WHERE 	SE1.E1_FILIAL	<> %Exp:Space(TAMSX3("E1_FILIAL")[1])% 
  				AND		SE1.E1_CLIENTE	= %Exp:ZZJ->ZZJ_CODCLI% 
  				AND		SE1.E1_LOJA		= %Exp:ZZJ->ZZJ_LOJCLI%  		
  				AND 	SE1.E1_SALDO 	<= 0 
  				AND 	SE1.%Notdel%
  	ORDER BY 	SE1.E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA
  	
  EndSql                 
  conout(GetLastQuery()[2])
  
  dbSelectArea("TMPTAB")
  
  While TMPTAB->(!Eof())
  	aFieldFill := {E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, SToD(E1_EMISSAO), SToD(E1_VENCREA), SToD(E1_BAIXA), ; 
  									E1_VALOR, SToD(E1_BAIXA) - SToD(E1_VENCREA), /*, GetSitTit(E1_SITUACA)*/, .F.}
  	aAdd(aColsEx, aFieldFill)
  	TMPTAB->(dbSkip())
  EndDo
  
  TMPTAB->(dbCloseArea())

  oGD_TitPG := MsNewGetDados():New( 000, 000, 100, 362, , "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[2], aHeaderEx, aColsEx)

Return

//------------------------------------------------
Static Function fGD_TitAb(nOpc)
//------------------------------------------------ 
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"E1_MSEMP", "E1_FILIAL", "E1_TIPO", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_PORTADO", "E1_EMISSAO",; 
									"E1_VENCREA", "E1_VENCORI", "E1_VALOR", "E1_SALDO", "E1_PORCJUR", "E1_VALJUR", "E1_CORREC",; 
									"E1_ACRESC", "E1_DECRESC", "E1_DESCJUR", "E1_DESCONT", "E1_HIST"}//, "E1_SITUACA"}
Local aAlterFields := {"E1_DESCJUR", "E1_DESCONT", "E1_HIST", "E1_X_SCOBR"} // "E1_VENCREA", "E1_SITUACA"
Local nValNom := 0
Local nValJur := 0
Local nValSld := 0
Local nValAcr := 0
Local nValDec := 0

Static oGD_TitAb

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
  // Adiciona os campos customizados
  aAdd(aHeaderEx, {"Situacao","E1_SITUACA","",15,0, , ,"C"})
  
  SX3->(DbSeek("E1_X_SCOBR"))
  
  aAdd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
                       
  aAdd(aHeaderEx, {"Dias atraso","E1_DIASATR","", 6,0, , ,"N"})
  
	SX3->(DbSeek("E1_VALOR"))
  aAdd(aHeaderEx, {"Vlr. Juros ","E1_JUR"    ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})  
  aAdd(aHeaderEx, {"Vlr. Total ","E1_TOTAL"  ,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
                       
	//  Aadd(aHeaderEx, {"","E1_SITUACA","",30,0, , ,"C"})

  // Define field values
  /*For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)*/
  
  // Carrega as informações dos títulos em aberto do cliente
  
	cWHERESQL := "%%"
	If !Empty(ZZI->ZZI_VCTDE) .AND. !Empty(ZZI->ZZI_VCTATE)
		cWHERESQL := "% SE1.E1_VENCREA >= '" + DTOS(ZZI->ZZI_VCTDE) + "' AND SE1.E1_VENCREA <= '" + DTOS(ZZI->ZZI_VCTATE) + "' %"
	Else
		cWHERESQL := "% SE1.E1_VENCREA <= '" + DTOS(ddatabase) + "' %"
	EndIf
	 

  BeginSql Alias "TMPTAB"
  
  	SELECT 	%EXP:CEMPANT% AS E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_PORTADO, 
  			E1_EMISSAO, E1_VENCREA, E1_VENCORI, E1_VALOR, E1_SALDO, E1_PORCJUR, E1_VALJUR, E1_CORREC, 
  			E1_ACRESC, E1_DECRESC, E1_DESCJUR, E1_DESCONT, E1_SITUACA, E1_X_SCOBR, E1_HIST  
  	FROM %TABLE:SE1% SE1
  			WHERE 	SE1.E1_FILIAL	<> %Exp:Space(TAMSX3("E1_FILIAL")[1])% 
  			AND 	SE1.E1_CLIENTE 	= %Exp:ZZJ->ZZJ_CODCLI% 
  			AND 	SE1.E1_LOJA 	= %Exp:ZZJ->ZZJ_LOJCLI%
  			AND 	%Exp:cWHERESQL%
  			AND 	SE1.E1_SALDO 	> 0 
  			AND 	SE1.%Notdel%
  	ORDER BY E1_VENCORI //E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA
  	
  EndSql   
  conout(GetLastQuery()[2])
  
  dbSelectArea("TMPTAB")
  
  nValNom := 0
  nValSld := 0
  nValJur := 0
  nValAcr := 0
  nValDec := 0
  nValTot := 0
  
  While TMPTAB->(!Eof())
  	aFieldFill := {E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_PORTADO, SToD(E1_EMISSAO), SToD(E1_VENCREA), SToD(E1_VENCORI), ;
  									E1_VALOR, E1_SALDO, E1_PORCJUR, E1_VALJUR, E1_CORREC, E1_ACRESC, E1_DECRESC, E1_DESCJUR, E1_DESCONT, E1_HIST, ;
  									GetSitTit(E1_SITUACA), E1_X_SCOBR, dDataBase - SToD(E1_VENCREA), ;
  									iif(E1_TIPO $ "AB-/NCC/RA",0,Round((dDataBase - SToD(E1_VENCREA)) * E1_VALJUR,2)), ;
  									E1_SALDO + iif(E1_TIPO $ "AB-/NCC/RA",0,Round((dDataBase - SToD(E1_VENCREA)) * E1_VALJUR,2)) + ;
  						      E1_CORREC + E1_ACRESC - E1_DECRESC - E1_DESCJUR - E1_DESCONT, .F.}
  	aAdd(aColsEx, aFieldFill)
  	
  	if E1_TIPO $ "AB-/NCC/RA"
  		nValNom += (E1_VALOR * (-1))
  		nValSld += (E1_SALDO * (-1))
  		nValJur += 0
  	Else                  
  		nValJur += Round((dDataBase - SToD(E1_VENCREA)) * E1_VALJUR,2)
  		nValNom += E1_VALOR
			nValSld += E1_SALDO
  	EndIf 
  			                    	
  	nValAcr += E1_ACRESC
  	nValDec += E1_DECRESC
  	nValTot += E1_SALDO + iif(E1_TIPO $ "AB-/NCC/RA",0,Round((dDataBase - SToD(E1_VENCREA)) * E1_VALJUR,2)) + ;
  						 E1_CORREC + E1_ACRESC - E1_DECRESC - E1_DESCJUR - E1_DESCONT
  	
  	TMPTAB->(dbSkip())
  EndDo
  
  TMPTAB->(dbCloseArea())
  
	// Adiciona uma linha com os valores totais
  aFieldFill := {}
  aAdd(aFieldFill, "--")
	aAdd(aFieldFill, "--")
	aAdd(aFieldFill, "--")
	aAdd(aFieldFill, "---")
 	aAdd(aFieldFill, "  TOTAL  ")
 	aAdd(aFieldFill, "---")
 	aAdd(aFieldFill, "---")
 	aAdd(aFieldFill, "        ")
 	aAdd(aFieldFill, "        ")
 	aAdd(aFieldFill, "        ")
 	aAdd(aFieldFill, nValNom)
 	aAdd(aFieldFill, nValSld)
 	aAdd(aFieldFill, 0)
 	aAdd(aFieldFill, 0)
 	aAdd(aFieldFill, 0)
 	aAdd(aFieldFill, nValAcr)
  aAdd(aFieldFill, nValDec) 	 	 	
 	aAdd(aFieldFill, 0)
 	aAdd(aFieldFill, 0)
 	aAdd(aFieldFill, " ")
 	aAdd(aFieldFill, " ")
  aAdd(aFieldFill, " ") 	 
  aAdd(aFieldFill, " ") 	
  aAdd(aFieldFill, nValJur) 	
  aAdd(aFieldFill, nValTot) 	             			
 	 	
 	aAdd(aFieldFill, .F.)
 	
 	Aadd(aColsEx, aFieldFill)


  oGD_TitAb := MsNewGetDados():New( 000, 000, 080, 362, nOpc, "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[1], aHeaderEx, aColsEx)

Return

//------------------------------------------------
Static Function fGD_TitAV()
//------------------------------------------------
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"E1_MSEMP", "E1_FILIAL", "E1_TIPO", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_EMISSAO", "E1_VENCREA", "E1_VENCORI", "E1_VALOR", "E1_SALDO"}//, "E1_SITUACA"}
Local aAlterFields := {}
Static oGD_TitAV

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  // Define field values
  /*For nX := 1 to Len(aFields)
    If DbSeek(aFields[nX])
      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
    Endif
  Next nX
  Aadd(aFieldFill, .F.)
  Aadd(aColsEx, aFieldFill)*/
  
  // Carrega as informações dos títulos a vencer do cliente
	cWHERESQL := "%%"
	If !Empty(ZZI->ZZI_VCTDE) .AND. !Empty(ZZI->ZZI_VCTATE)
		cWHERESQL := "% SE1.E1_VENCREA > '" + DTOS(ZZI->ZZI_VCTATE) + "' %"
	Else
		cWHERESQL := "% SE1.E1_VENCREA > '" + DTOS(dDataBase) + "' %"
	EndIf  
  
  BeginSql Alias "TMPTAB"

  	SELECT 		%EXP:CEMPANT% AS E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, 
  				E1_EMISSAO, E1_VENCREA, E1_VENCORI, E1_VALOR, E1_SALDO, E1_SITUACA
  	FROM 		%TABLE:SE1% SE1
  				WHERE 	SE1.E1_FILIAL	<> %Exp:Space(TAMSX3("E1_FILIAL")[1])% 
  				AND		SE1.E1_CLIENTE	= %Exp:ZZJ->ZZJ_CODCLI% 
  				AND 	SE1.E1_LOJA 	= %Exp:ZZJ->ZZJ_LOJCLI%
  				AND 	%Exp:cWHERESQL%
  				AND 	SE1.E1_SALDO 	> 0 
  				AND		SE1.%Notdel%
  	ORDER BY 	SE1.E1_FILIAL, SE1.E1_PREFIXO, SE1.E1_NUM, SE1.E1_PARCELA
  EndSql   
  conout(GetLastQuery()[2])
  
  dbSelectArea("TMPTAB")
  
  While TMPTAB->(!Eof())
  	aFieldFill := {E1_MSEMP, E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, SToD(E1_EMISSAO),SToD(E1_VENCREA), SToD(E1_VENCORI), ;
  									E1_VALOR, E1_SALDO, /*GetSitTit(E1_SITUACA), */.F.}
  	aAdd(aColsEx, aFieldFill)
  	TMPTAB->(dbSkip())
  EndDo
  
  TMPTAB->(dbCloseArea())
                                                         // GD_INSERT+GD_DELETE+GD_UPDATE
  oGD_TitAV := MsNewGetDados():New( 000, 000, 100, 362, , "AllwaysTrue", "AllwaysTrue", "", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[3], aHeaderEx, aColsEx)

Return

Static Function GrvDados(cObsCob, nOpc, cSitCli)
Local aCols := oGD_TitAb:aCols
Local aHeader := oGD_TitAb:aHeader
Local nX := 1
Local nRecZZJ := ZZJ->(RecNo())
Local aEmpOld := {SM0->M0_CODIGO, SM0->M0_CODFIL}
Local aAreaZZJ := ZZJ->(GetArea())
Local nPosFil := nPosTip := nPosPre := nPosNum := nPosPar := nPosVen := nPosHis := nPosSit := 0


if (nOpc == 2)
	oDlg:End()
	Return
elseif (nOpc == 4)
	RecLock("ZZJ", .F.)
	ZZJ->ZZJ_STATUS := "04"
	ZZJ->ZZJ_DATAAT := dDataBase
	ZZJ->ZZJ_USUARI := cUserName
	ZZJ->(MsUnlock())
	oDlg:End()
	Return
EndIf

SA1->(dbSetOrder(01))
SA1->(dbSeek(xFilial("SA1") + ZZJ->ZZJ_CODCLI + ZZJ->ZZJ_LOJCLI))
RecLock("SA1", .F.)
//SA1->A1_X_OBCOB := cObsCob
SA1->A1_X_OBCOB := cObsCob

if SA1->A1_X_SCOBR != cSitCli
	SA1->A1_X_SCOBR := cSitCli
EndIf

SA1->(MsUnlock())

RecLock("ZZJ", .F.)
ZZJ->ZZJ_STATUS := iif(cStatus == "A", "02", if(cStatus = "P", "03", "04")) // fica prorogado cobrança mas sem data de agendamento
ZZJ->ZZJ_DATAAT := dDataBase
ZZJ->ZZJ_DATAPR := CToD("  /  /  ") // limpa a data de agendamento devido a ser um atendimento
ZZJ->ZZJ_USUARI := cUserName
ZZJ->(MsUnlock())

// Seta a lista como em atendimento
ZZI->(dbSetOrder(02))
ZZI->(dbSeek(xFilial("ZZI") + ZZJ->ZZJ_CODLIS))

if ZZI->ZZI_STATUS == "1"
	RecLock("ZZI", .F.)
	ZZI->ZZI_STATUS := "2"
	ZZI->ZZI_DATAAT := dDataBase
	ZZI->(MsUnlock())
EndIf

// Ordena o aCols para que seja rápida a troca de environment e seja trocado somente uma vez
aCols := aSort(aCols,,, {|X,Y| (X[1]+X[2]) < (Y[1]+Y[2])})

// Faz a gravação dos dados
// alimenta a variavel com os dados da filial atual
cEmpFil := cEmpAnt + cFilAnt //aCols[1, 1] + aCols[1, 2]

// Busca Posição dos campos dentro do aHeader
nPosFil := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_FILIAL'})
nPosTip := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_TIPO'})
nPosPre := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_PREFIXO'})
nPosNum := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_NUM'})
nPosPar := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_PARCELA'})
nPosVen := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_VENCREA'})
nPosHis := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_HIST'})
nPosSit := aScan(aHeader,{|x| AllTrim(x[2]) == 'E1_X_SCOBR'})

For nX := 1 to len(aCols)

  dbSelectArea("SE1")
	SE1->(dbSetOrder(01))
	if SE1->(dbSeek(aCols[nX, nPosFil] + aCols[nX, nPosPre] + aCols[nX, nPosNum] +aCols[nX, nPosPar] +aCols[nX, nPosTip]))
		if (aCols[nx, nPosVen] != SE1->E1_VENCREA) .Or. (SE1->E1_HIST != aCols[nX, nPosHis]) .Or. (SE1->E1_X_SCOBR != aCols[nX, nPosSit])  // valida se foi alterado			
//			MsgInfo("Inicio da gravação da cobrança")
			RecLock("SE1")
			SE1->E1_HIST := aCols[nX, nPosHis]
			
			if (SE1->E1_X_SCOBR != aCols[nX, nPosSit])
				SE1->E1_X_SCOBR := aCols[nX, nPosSit]
			EndIf
			
			// Calcula a data válida se foi alterado o vencimento
			if (SE1->E1_VENCREA != aCols[nX, nPosVen])
				SE1->E1_VENCREA := aCols[nX, nPosVen]
				SE1->E1_VENCREA := DataValida(aCols[nX, nPosVen], .T.)
			EndIf
			
			SE1->(MsUnlock())
			
			// fazer a gravação na tabela de logs de cobrança do título *** verificar a necessidade ***
	
			// mandar emai avisando o responável sobre a cobrança
			// informa que foi alterado o vencimento ou o histórico do título
	    if (SE1->E1_VENCREA != aCols[nX, nPosVen])
	    	SendWF(aCols[nX, nPosVen], .T.)
	    EndIf
//	    MsgInfo("Fim da gravação da cobrança")
		EndIf
	EndIf		

Next nX

//RpcClearEnv()
//RPCSetType(3)
//RpcSetEnv(aEmpOld[1], aEmpOld[2],,,,GetEnvServer())

oDlg:End()
// restaura o filtro da ZZJ
//RestFilZZJ()
Return

// faz o diálogo para selecionar qual data de prorogação para o título
Static Function Prorogar()
Local nDataTit := aScan(oGD_TitAb:aHeader,{|x| AllTrim(x[2]) == 'E1_VENCREA'})
Local dDataTit := oGD_TitAb:aCols[oGD_TitAb:nAt, nDataTit]
Local oDlgP
Local oPanel1
Local oSay1
Local oDataTit

ZZO->(dbSetOrder(01))
if ZZO->(!dbSeek(xFilial("ZZO")+cUserName))
  MsgInfo("Necessário cadastrar permissão para efetuar prorogação de títulos.")
  Return
EndIf

if (!ZZO->ZZO_PROROG)
	Alert("Usuário sem permissão para efetuar reagendamento.")
	Return
EndIf

if Empty(cStatus)
	MsgInfo("Faça o atendimento para poder prorogar o título")
	Return
EndIf

DEFINE MSDIALOG oDlgP TITLE "Prorogar título" FROM 000, 000  TO 070, 350 COLORS 0, 16777215 PIXEL

  @ 012, 005 MSPANEL oPanel1 SIZE 340, 055 OF oDlgP COLORS 0, 16777215 RAISED
  @ 007, 007 SAY oSay1 PROMPT "Novo Vencimento" SIZE 060, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
  @ 005, 0050 GET oDataTit VAR dDataTit OF oPanel1 SIZE 60, 010 COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlgP CENTERED ON INIT ;
	EnchoiceBar(oDlgP,{|| AltData(dDataTit, oDlgP), Nil }, {|| oDlgP:End() })

Return

Static function AltData(dDataTit, oDlgP)
Local nPosVen := aScan(oGD_TitAb:aHeader,{|x| AllTrim(x[2]) == 'E1_VENCREA'})
Local nVenOri := aScan(oGD_TitAb:aHeader,{|x| AllTrim(x[2]) == 'E1_VENCORI'})
Local nPosVlr := aScan(oGD_TitAb:aHeader,{|x| AllTrim(x[2]) == 'E1_VALOR'})
Local lOk := .T.
Local nValMax := ZZO->ZZO_PRVALM
Local nDias := ZZO->ZZO_DIASPR

// Valida prorogação para até 30 dias e valor menor que 5.000
if (dDataTit - oGD_TitAb:aCols[oGD_TitAb:nAt, nVenOri]) > nDias
	MsgInfo("Não pode ser prorogado para mais de " + Transform(nDias, "@E 999") + " dias")
	lOk := .F.	
EndIf

if oGD_TitAb:aCols[oGD_TitAb:nAt, nPosVlr] > nValMax
	MsgInfo("Não pode ser prorogado título com valor maior que " + Transform(nValMax, "@E 999,999,999"))
	lOk := .F.	
EndIf

if lOk
	oGD_TitAb:aCols[oGD_TitAb:nAt, nPosVen] := dDataTit
//	oGD_TitAb:aCols[oGD_TitAb:nAt, len(oGD_TitAb:aCols[oGD_TitAb:nAt])] := .T. // seta que foi alterado
	cStatus := "P"
	oDlgP:End()
EndIf
Return lOk

Static Function ProrAtend() // Faz a prorogaçao do atendimento para determinada data
Local dDataReag := dDataBase + 7
Local oDlgP
Local lCont := .F.

ZZO->(dbSetOrder(01))
if ZZO->(!dbSeek(xFilial("ZZO")+cUserName))
  MsgInfo("Necessário cadastrar permissão para efetuar reagendamento")
  Return
EndIf

if (!ZZO->ZZO_REAGEN)
	Alert("Usuário sem permissão para efetuar reagendamento")
	Return
EndIf

DEFINE MSDIALOG oDlgP TITLE "Reagendar Atendimento" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL

	@ 022, 005 MSPANEL oPanel1 SIZE 340, 055 OF oDlgP COLORS 0, 16777215 RAISED
	@ 017, 007 SAY oSay1 PROMPT "Reagendar para" SIZE 060, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
	@ 015, 050 GET oDataTit VAR dDataReag OF oPanel1 SIZE 60, 010 COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlgP CENTERED ON INIT ;
EnchoiceBar(oDlgP,{|| lCont := .T., oDlgP:End(), Nil }, {|| oDlgP:End() })

if ((dDataReag - dDataBase) > ZZO->ZZO_REAGDI)
	Alert("Usuário só pode reagendar atendimento para até " + Transform(ZZO->ZZO_REAGDI, "@E 999") + " dias.")
	Return
EndIf
	
if (lCont)
	RecLock("ZZJ", .F.)
	ZZJ->ZZJ_DATAPR := dDataReag
	ZZJ->ZZJ_STATUS := "05" // REAGENDADO
	ZZJ->ZZJ_USUARI := cUserName
	ZZJ->(MsUnlock())
	
	SendWF(dDataReag, .F.) // reagendado o atendimento
EndIf

// manda workflow que foi reagendado o atendimento
Return

Static Function GetSitTit(cSit)
Local cDescSit := ""
Local nPos := aScan(aSituacao, {|x| x[1] == cSit})
cDescSit := iif(nPos > 0, aSituacao[nPos][2], "")
Return cDescSit

Static Function SendWF(dDataNova, lTit)
// faz o processo de mandar o workflow
Return

Static Function Posicao()
Local nX := oGD_TitAb:nAt
Local aCols := oGD_TitAb:aCols 
Local aArea := GetArea()
Local aEmpOld := {SM0->M0_CODIGO, SM0->M0_CODFIL}

//RpcClearEnv()
//RPCSetType(3)
//RpcSetEnv(aCols[nX, 1], aCols[nX, 2],,,,GetEnvServer())

dbSelectArea("SE1")
SE1->(dbSetOrder(01))

if SE1->(dbSeek(aCols[nX, 2] + aCols[nX, 4] + aCols[nX, 5] +aCols[nX, 6] +aCols[nX, 3]))
	Fc040Con() // chama função padrão do microsiga
else
	MsgInfo("Título não encontrado")
EndIf

//RpcClearEnv()
//RPCSetType(3)
//RpcSetEnv(aEmpOld[1], aEmpOld[2],,,,GetEnvServer())

RestArea(aArea)
Return

Static Function FinalCob()
Local lOk := .T.
Local cSeq
Local lFinalizar := .F.
Local lPodeFinal := .F. 

ZZO->(dbSetOrder(01))
if ZZO->(!dbSeek(xFilial("ZZO")+cUserName))
	MsgInfo("Necessário cadastrar permissão para finalizar a lista de cobrança.")
	Return
EndIf

lPodeFinal := ZZO->ZZO_FINLST

dbSelectArea("ZZJ")
dbSetOrder(01)
cSeq := "0001"

lFinalizar := MsgBox("Finalizar atendimentos não efetuados caso existam?", "Atendimentos não efetuados", "YESNO")

if lFinalizar .And. !lPodeFinal
	MsgInfo("Usuário não tem permissão para finalizar a lista de cobrança sem finalizar os atendimentos. " + ;
							"Será finalizada a lista somente se todos os atendimentos foram efetuados.")
	lFinalizar := .F.
EndIf

While ZZJ->(dbSeek(xFilial("ZZJ") + ZZI->ZZI_CODIGO + cSeq))
	if ZZJ->ZZJ_STATUS == "01"
		If lFinalizar
			RecLock("ZZJ", .F.)
			ZZJ->ZZJ_STATUS := "06" // Não Atendido
			ZZJ->ZZJ_USUARI := cUserName
			ZZJ->(MsUnlock())
		else
			lOk := .F.
		EndIf
	EndIf	
	cSeq := Soma1(cSeq)
EndDo

if !lOk
	MsgInfo("Há atendimentos não realizados. Efetue os atendimentos ou solicite ao superior para finalizar a lista.","Atendimentos pendentes")
else
	RecLock("ZZI", .F.)
	ZZI->ZZI_STATUS := "4"
	ZZI->(MsUnlock())
	MsgInfo("Lista finalizada com sucesso!","Lista de Cobrança")
EndIf

Return

// Restaura o filtro previamente efetuado na rotina
Static Function RestFilZZJ()
Local aIndexZZJ := {}
dbSelectArea("ZZJ")
bFiltraBrw 	:= {|| FilBrowse("ZZJ",@aIndexZZJ,@cFiltroCob)}
Eval(bFiltraBrw)
Return
          
*------------------------------------------------------------------------*
Static Function fCalcJur()
*------------------------------------------------------------------------*
Local aHeadJUR := {}
Local aColsJUR := {}
Local aAltFJUR := {}
Local aFldsJUR := {"E1_MSEMP", "E1_FILIAL", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_EMISSAO","E1_VENCREA", "E1_VENCORI", "E1_VALOR", "E1_SALDO"}

Local aHeadVCT := {}
Local aColsVCT := {}
Local aAltFVCT := {"E1_NEWVCT"}

Private cPerg	:= "ATENDCOBRC"


//Fernando Luiz (30/09/14). Alterado p/ que no Atendimento de Cobrança traga o percentual de juros na calculadora conforme perc. padrão da empresa
//utilizada. Criado o parâmetro MV_X_PJUR que irá trazer o valor solicitado. Conteúdo anterior da variável nPercDef = 5.
Private nPercDef	:= SuperGetMv("MV_X_PJUR", ,5)
Private nPercJuro	:= nPercDef
Private nSaldoTit	:= 0
Private nSaldoNew	:= 0

Private lContinua  := .F.
                      
Private oButton1
Private oButton2
Private oGD_Juros
Private oGD_Venct
Private oDlgJuros
Private oSaldoTit
Private oSaldoNew     
Private oPercJuro
                   
	AjustaSX1()
	
	//-- Grid de títulos
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For nX := 1 to Len(aFldsJUR)
    	If SX3->(dbSeek(aFldsJUR[nX]))
      		Aadd(aHeadJUR, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
        					SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Next nX


	SX3->(dbSeek("E1_VALOR"))
	aAdd(aHeadJUR, {"Valor Calculado","E1_NEWTOT",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    

	//-- Grid de vencimentos
	SX3->(dbSeek("E1_EMISSAO"))
	aAdd(aHeadVCT, {"Novo Vencto","E1_NEWVCT",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,"",;
                       		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})

	SX3->(dbSeek("E1_VALOR"))
	aAdd(aHeadVCT, {"Valor Parcela","E1_NEWTOT",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    
    aAdd ( aColsVCT, {ddatabase, 0, .F.} )
	
    If !Pergunte(cPerg,.T.)
    	Return
    EndIf
	
	If mv_par01 == 1
   		fPopula(oGD_TitAb,@aColsJUR)
   		cTIT := "Títulos Vencidos"
	ElseIf mv_par01 == 2        
		fPopula(oGD_TitAb,@aColsJUR)
		cTIT := "Títulos A Vencer"
	Else                        
		fPopula(oGD_TitAb,@aColsJUR)
		fPopula(oGD_TitAV,@aColsJUR)
		cTIT := "Títulos Vencidos e A Vencer"
	EndIf                  
	
	If Len(aColsJUR) == 0
		Aviso("Aviso","Não existem dados para cálculo de juros.",{"OK"})
		Return
	EndIf
	

	DEFINE MSDIALOG oDlgJuros TITLE "Cálculo de Juros - "+cTIT FROM 001, 001  TO 470, 750 COLORS 0, 16777215 PIXEL
	
	@ 009, 017 SAY oSay1 PROMPT "Perc. Juros:" SIZE 050, 007 OF oDlgJuros
	@ 009, 024 GET oPercJuro VAR nPercJuro PICTURE "@E 999.99" SIZE 60, 010 OF oDlgJuros 
	@ 010, 017 SAY oSay1 PROMPT "Saldo Títulos:" SIZE 050, 007 OF oDlgJuros
	@ 010, 024 GET oSaldoTit VAR nSaldoTit PICTURE "@E 999,999,999.99" WHEN .F. SIZE 60, 010 OF oDlgJuros 
	@ 011, 017 SAY oSay1 PROMPT "Valor Calculado:" SIZE 050, 007 OF oDlgJuros
	@ 011, 024 GET oSaldoNew VAR nSaldoNew PICTURE "@E 999,999,999.99" WHEN .F. SIZE 60, 010 OF oDlgJuros 
	
	oGD_Juros := MsNewGetDados():New( 040, 005, 100, 362, GD_UPDATE+GD_DELETE, 				"AllwaysTrue", "AllwaysTrue", "" , aAltFJUR,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgJuros, aHeadJUR, aColsJUR)
	oGD_Venct := MsNewGetDados():New( 150, 005, 200, 120, GD_INSERT+GD_UPDATE+GD_DELETE, 	"AllwaysTrue", "AllwaysTrue", "" , aAltFVCT,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgJuros, aHeadVCT, aColsVCT)

	@ 017, 040 BUTTON oButton1 PROMPT "Calcular Juros" 	SIZE 040, 012 ACTION FCALCJ() OF oDlgJuros
	@ 017, 052 BUTTON oButton2 PROMPT "Limpar Dados" 	SIZE 040, 012 ACTION FCLEAR() OF oDlgJuros
    
	//--Calculo dos juros na abertura da janela
	FCALCJ()
	
	ACTIVATE MSDIALOG oDlgJuros CENTERED ON INIT EnchoiceBar(oDlgJuros,{|| lContinua := .T., oDlgJuros:End(), Nil }, {|| oDlgJuros:End() })
	
Return


*------------------------------------------------------------------------*
Static Function fPopula(oObj,aColsTIT)
*------------------------------------------------------------------------*
Local aColsLOC		:= aClone(oObj:aCols)
Local aHeadLOC		:= aClone(oObj:aHeader)
Local nE1_MSEMP		:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_MSEMP"}) 
Local nE1_FILIAL	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_FILIAL"})  
Local nE1_PREFIXO	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_PREFIXO"}) 
Local nE1_NUM		:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_NUM"}) 
Local nE1_PARCELA	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_PARCELA"}) 
Local nE1_EMISSAO	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_EMISSAO"}) 
Local nE1_VENCREA	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_VENCREA"})  
Local nE1_VENCORI	:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_VENCORI"}) 
Local nE1_VALOR		:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_VALOR"}) 
Local nE1_SALDO		:= aScan(aHeadLOC,{|x| AllTrim(x[2])=="E1_SALDO"}) 

	For nI := 1 to Len(aColsLOC)
		If aColsLOC[nI,nE1_MSEMP] != "--"
			aAdd ( aColsTIT, {	aColsLOC[nI,nE1_MSEMP]		,;
						   		aColsLOC[nI,nE1_FILIAL]		,;
								aColsLOC[nI,nE1_PREFIXO]	,;
								aColsLOC[nI,nE1_NUM]		,;
								aColsLOC[nI,nE1_PARCELA]	,;
								aColsLOC[nI,nE1_EMISSAO]	,;
								aColsLOC[nI,nE1_VENCREA]		,;
								aColsLOC[nI,nE1_VENCORI]	,;
								aColsLOC[nI,nE1_VALOR]		,;
								aColsLOC[nI,nE1_SALDO]		,;
								0 			,;
								.F.  		} )	

		EndIf
	Next nI

Return


*------------------------------------------------------------------------*
Static Function FCLEAR()                                                  
*------------------------------------------------------------------------*

	oGD_Juros:aCols := {}
	oGD_Venct:aCols := {}
	nPercJuro := nPercDef  
	
	aAdd ( oGD_Venct:aCols, {ddatabase, 0, .F.} )	
	If mv_par01 == 1
   		fPopula(oGD_TitAb,@oGD_Juros:aCols)
	ElseIf mv_par01 == 2        
		fPopula(oGD_TitAb,@oGD_Juros:aCols)
	Else                        
		fPopula(oGD_TitAb,@oGD_Juros:aCols)
		fPopula(oGD_TitAV,@oGD_Juros:aCols)
	EndIf
            
    FCALCJ()          
	oGD_Juros:ForceRefresh()
	oGD_Venct:ForceRefresh()
	oSaldoNew:Refresh()
	oDlgJuros:Refresh()

Return
                       

*------------------------------------------------------------------------*
Static Function FCALCJ()                                                  
*------------------------------------------------------------------------*
Local dMAXDATA := ctod("")
Local nTOTPARC := 0
                 
	//--Recupera maior data pagamento
	For nI := 1 to Len(oGD_Venct:aCols)                  
		If !oGD_Venct:aCols[nI][Len(oGD_Venct:aHeader)+1]
			If oGD_Venct:aCols[nI][01] > dMAXDATA
				dMAXDATA := oGD_Venct:aCols[nI][01]
			EndIf
			nTOTPARC += 1
		EndIf
	Next nI                          
	
    //--Chamada da funcao de calculo de juros por registro
	nSaldoNew := 0
	nSaldoTit := 0
	For nI := 1 to Len(oGD_Juros:aCols)
		If !oGD_Juros:aCols[nI][Len(oGD_Juros:aHeader)+1]
			FJURTIT(nI,dMAXDATA)
		EndIf
	Next nI

	//--Atualiza valor das parcelas
	For nI := 1 to Len(oGD_Venct:aCols)                  
		If !oGD_Venct:aCols[nI][Len(oGD_Venct:aHeader)+1]
			oGD_Venct:aCols[nI][02] := Round ( nSaldoNew / nTOTPARC, 2)
		EndIf
	Next nI

	oGD_Juros:ForceRefresh()
	oGD_Venct:ForceRefresh()
	oSaldoNew:Refresh()
	oDlgJuros:Refresh()

Return
                    

*------------------------------------------------------------------------*
Static Function FJURTIT(nP,dMAXDATA)                                                  
*------------------------------------------------------------------------*
Local nE1_SALDO	:= aScan(oGD_Juros:aHeader,{|x| AllTrim(x[2])=="E1_SALDO"}) 
Local nE1_NEWTOT:= aScan(oGD_Juros:aHeader,{|x| AllTrim(x[2])=="E1_NEWTOT"}) 
Local nE1_VENCREA:= aScan(oGD_Juros:aHeader,{|x| AllTrim(x[2])=="E1_VENCREA"}) 
   	
   	nSldTit := oGD_Juros:aCols[nP][nE1_SALDO]
   	If dMAXDATA > oGD_Juros:aCols[nP][nE1_VENCREA]	   	
	   	nDiaTit := (dMAXDATA - oGD_Juros:aCols[nP][nE1_VENCREA])/30
	   	nPerTit := nPercJuro/100
	   	nJurTit := Round ( nSldTit * (( 1 + nPerTit ) ^ nDiaTit), 2)
	Else           
		nJurTit := nSldTit
	EndIf
	oGD_Juros:aCols[nP][nE1_NEWTOT] := nJurTit
	nSaldoTit += nSldTit
	nSaldoNew += nJurTit

Return
      

*------------------------------------------------------------------------*
Static Function AJUSTASX1()                                               
*------------------------------------------------------------------------*
Local aRegs  := {}                                                        

AADD(aRegs,{cPerg,"01","Filtrar Títulos ? ","","","mv_ch1","N",1,0,2,"C","","mv_par01","Vencidos","","","","","A Vencer","","","","","Ambos","","","","","","","","","","","","","","","","","","@!"})

dbSelectArea("SX1")
dbSetOrder(1)
For i := 1 To Len(aRegs)
	If !dbSeek(cPerg + aRegs[i,2])
		RecLock("SX1", .T.)
		For j := 1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j, aRegs[i,j])	 
			Endif
		Next
		MsUnlock()
	Endif
Next  

Return
