#include "Protheus.ch"
#include "Topconn.ch"

User Function Cobranca()
Local aArea := GetArea()
Private cCadastro := "Telecobrança - Gerar"
Private aCores := {}

Private aRotina := {{"Pesquisar"			,"AxPesqui"		,0 ,1} ,;
					{"Clientes da Lista"	,"U_MntLista"	,0 ,2} ,;
					{"Gerar Lista"			,"U_ListaCob"	,0 ,3} ,;
					{"Alterar Cabecalho"	,"U_MntLista"	,0 ,4} ,;                     
					{"Finalizar"			,"U_MntLista"	,0 ,5} ,;
					{"Agendados"			,"U_MntLista"	,0 ,6},;
					{"Relatório"			,"U_ReListCob"	,0, 7}}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

mBrowse( 6,1,22,75,"ZZI")
// retorna o ambiente anterior
RestArea(aArea)
Return

// Funcao que gera a lista de cobrança
User Function ListaCob()
Local cPerg := "COBRRJU"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaPerg(cPerg)
if Pergunte(cPerg, .T.)
	Processa( {|| GeraLista() }, "Selecionando Clientes")
EndIf

Return


// Função que gera a lista de cobrança
Static Function GeraLista()
Local aArq := {}
Local aCpos := {}
Local cPerg := "COBRRJU"
Local oSay1, oGet1, oPanel1, oBt1, oBt2, oGet2, oSay2, oBt4
Local lValLista := .T.  
Local cSitua := MV_PAR11
Local cSit := ""
Local cTipo := MV_PAR12
Local cTp := "" 
Local cTipoCli := MV_PAR13
Local cTpCli := ""
Local cRisCli := MV_PAR14
Local cRis := ""
Local cSql := ""
Local tmp := ""

Private cUserCob := Space(15)
Private cNomeLista := Space(60)
Private lInverte := .F.
Private cMarca := ""
Private nSaldoA := 0
Private nSaldoV := 0                      

Private oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Monta String com as situações de títulos informados pelo usuário                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Nesse primeiro 'for' o sistema apenas faz a junção das situações sem caracter separador.
for i := 1 to len(AllTrim(cSitua))
  if IsDigit(SubStr(cSitua, 1, 1)) .or. IsAlpha(SubStr(cSitua, 1, 1))
  	cSit += SubStr(cSitua, 1, 1)
  	cSitua := SubStr(cSitua, 2, len(AllTrim(cSitua)))
  Else
  	cSitua := SubStr(cSitua, 2, len(AllTrim(cSitua)))
  EndIf                                             
Next

// No segundo 'for' as situações são montadas com vírgula e aspas (para ser usada no sql)
cSitua := ""
for i := 1 to len(cSit)
	if Empty(cSitua)
		cSitua := "'" + Substr(cSit,1,1) + "'"
	Else
		cSitua += ",'" + Substr(cSit,1,1) + "'"
	EndIf
	cSit := SubStr(cSit, 2, len(cSit))                                                  				
Next                                



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄH¿
//³Monta String com os tipos de títulos informados pelo usuário³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄHÙ

for i := 1 to len(AllTrim(cTipo))
  
  // Verifica se o caractere é numérico, alfabético ou estiver contido em (-,$). Qualquer caracter
  // diferente disso, o sistema vai entender como um separador.
  if IsDigit(SubStr(cTipo, 1, 1)) .or. IsAlpha(SubStr(cTipo, 1, 1)) .or. SubStr(cTipo, 1, 1) $ '-/$' 
  	
  	// tmp = variável temporária que vai armazenando os caracteres válidos
  	tmp += SubStr(cTipo, 1, 1)
  	
  	// depois de avaliado, o caractere é eliminado da string
  	cTipo := SubStr(cTipo, 2, len(AllTrim(cTipo)))  	
  Else

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄalor¿
		//³Se não era um caractere válido, o sistema encontrou um separador. Nessa hora, ele descarrega o valor³
		//³armazenado na variável temporária tmp.                                                              ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄalorÙ
    
		// verifica se a variável que vai receber os tipos está vazia, se estiver, grava o valor de tmp entre áspas simples,
		// caso contrário, acrescenta uma vírgola e acrescenta valor da var temporária.
  	if Empty(cTp) 
	  	cTp := "'" + tmp + "'"
  	Else
  		cTp += ",'" + tmp + "'"
  	EndIf
  	tmp := ""
  	cTipo := SubStr(cTipo, 2, len(AllTrim(cTipo)))
  EndIf
Next   

// Grava o último valor da variável tmp depois de sair do loop.
if !Empty(tmp)
 	if Empty(cTp)
  	cTp := "'" + tmp + "'"
 	Else
 		cTp += ",'" + tmp + "'"
 	EndIf
 	tmp := ""
EndIf                                           



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratativa dos Tipos de Clientes informados pelo usuário.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

for i := 1 to len(AllTrim(cTipoCli))
  if IsDigit(SubStr(cTipoCli, 1, 1))
  	tmp += SubStr(cTipoCli, 1, 1)
  	cTipoCli := SubStr(cTipoCli, 2, len(AllTrim(cTipoCli)))  	
  Else

  	if Empty(cTpCli) 
	  	cTpCli := "'" + tmp + "'"
  	Else
  		cTpCli += ",'" + tmp + "'"
  	EndIf
  	tmp := ""
  	cTipoCli := SubStr(cTipoCli, 2, len(AllTrim(cTipoCli)))
  EndIf
Next   

if !Empty(tmp)
 	if Empty(cTpCli)
  	cTpCli := "'" + tmp + "'"
 	Else
 		cTpCli += ",'" + tmp + "'"
 	EndIf
 	tmp := ""
EndIf                                           


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratativa dos Riscos de Clientes informados pelo usuário.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

for i := 1 to len(AllTrim(cRisCli))
  if IsAlpha(SubStr(cRisCli, 1, 1))
  	tmp += SubStr(cRisCli, 1, 1)
  	cRisCli := SubStr(cRisCli, 2, len(AllTrim(cRisCli)))  	
  Else

  	if Empty(cRis) 
	  	cRis := "'" + tmp + "'"
  	Else
  		cRis += ",'" + tmp + "'"
  	EndIf
  	tmp := ""
  	cRisCli := SubStr(cRisCli, 2, len(AllTrim(cRisCli)))
  EndIf
Next   

if !Empty(tmp)
 	if Empty(cRis)
  	cRis := "'" + tmp + "'"
 	Else
 		cRis += ",'" + tmp + "'"
 	EndIf
 	tmp := ""
EndIf                                           

aAdd(aArq, {"CODIGO","C",09,0})
aAdd(aArq, {"LOJA","C",04,0})
aAdd(aArq, {"NOME","C",80,0})
aAdd(aArq, {"SALDO","N",14,2})
aAdd(aArq, {"ZZI_OK","C",02,0})
aAdd(aArq, {"OBSCOB","M",10,0})
aAdd(aArq, {"NUMLST","C",09,0})
aAdd(aArq, {"SITCOB","C",10,0})
        										
cSql := " SELECT 		SA1.A1_COD,  																								"
cSql += "  				SA1.A1_LOJA, 																								"
cSql += "  				SA1.A1_NOME, 																								"
cSql += "  				SUM(CASE WHEN E1_TIPO IN ('AB-', 'NCC', 'RA') THEN E1_SALDO * (-1) ELSE E1_SALDO END) AS SALDO, 			"
cSql += "  				(SELECT SUM(CASE WHEN E.E1_TIPO IN ('AB-', 'NCC', 'RA') THEN E.E1_SALDO * (-1) ELSE E.E1_SALDO END) 		"
cSql += "  					FROM "+RetSqlName("SE1")+" E 																			"
cSql += "     				WHERE 	E.E1_VENCREA BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' 						"
cSql += "     				AND 	E.E1_FILIAL BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' 									"
cSql += "     				AND 	E.E1_CLVLCR BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' 									"
cSql += "     				AND 	((E.E1_VEND1 BETWEEN '" + MV_PAR08 + "' AND '" + MV_PAR09 + "') OR " + "(E.E1_VEND1 = ' ')) 	"
// Se a pergunta Situações de Títulos for preenchida, adiciona filtro no sql.
If !Empty(cSitua)
	cSql += "     			AND 	E.E1_SITUACA IN (" + cSitua + ") 															"
EndIf                                               
// Se a pergunta Tipos de Títulos for preenchida, adiciona filtro no sql.
if !Empty(cTp)
	cSql += "     			AND 	E.E1_TIPO NOT IN (" + cTp + ") 																	"
EndIf
cSql += "     				AND 	E.D_E_L_E_T_ <> '*' 																			"
cSql += "     				AND 	E.E1_CLIENTE = SA1.A1_COD 																		"
cSql += "  				) AS SALDOCLI 																								"
cSql += " FROM 			"+RetSqlName("SE1")+" SE1 																					"
cSql += " 				INNER JOIN "+RetSqlName("SA1")+" SA1 																		"
cSql += " 				ON SA1.	A1_COD 			= SE1.E1_CLIENTE 																	"
cSql += " 				AND 	SA1.A1_LOJA 	= SE1.E1_LOJA 																		"   
cSql += " 				AND		SA1.D_E_L_E_T_ <> '*' 																				"
cSql += " 				WHERE 	SE1.E1_FILIAL 	BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' 									"
cSql += "  				AND 	SE1.E1_VENCREA 	BETWEEN '" + DtoS(MV_PAR01) + "' AND '" + DtoS(MV_PAR02) + "' 						"
cSql += "  				AND 	SE1.E1_CLVLCR 	BETWEEN '" + MV_PAR06 + "' AND '" + MV_PAR07 + "' 									"
If !Empty(cSitua)
	cSql += "  			AND 	SE1.E1_SITUACA  IN (" + cSitua + ") 															"
EndIf
If !Empty(cTp)
	cSql += "  			AND 	SE1.E1_TIPO 	NOT IN (" + cTp + ") 																"
EndIf 
cSql += "  				AND		SE1.E1_SALDO > 0 																					"
cSql += "  				AND 	SE1.D_E_L_E_T_ <> '*' 																				"
If !Empty(cTpCli)
	cSql += " 			AND 	(SA1.A1_X_SCOBR IN (" + cTpCli + ") OR A1_X_SCOBR = ' ') 											"
EndIf
If !Empty(cRis)
	cSql += " 			AND 	SA1.A1_RISCO IN (" + cRis + ") 																		"
EndIF
cSql += " GROUP BY 		SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME 																		"
cSql += " HAVING 		SUM(CASE WHEN SE1.E1_TIPO IN ('AB-', 'NCC', 'RA') THEN SE1.E1_SALDO * (-1) ELSE SE1.E1_SALDO END) 			"
cSql += " 				BETWEEN "+Str(MV_PAR05)+" AND "+Str(MV_PAR10)+" 															"
cSql += " ORDER BY 		SALDOCLI DESC, SA1.A1_LOJA 																					"

memowrite("cobranca_cantu.sql",cSql)


TCQUERY cSql NEW ALIAS "TMPCOB"

SA1->(dbSetOrder(01))

cArq := CriaTrab( aArq,.T. )
dbUseArea( .T.,, cArq,"TRBCOB", .T. , .F. )

While TMPCOB->(!Eof())
  
// SaldoCliente(TMPCOB->A1_COD, TMPCOB->A1_LOJA)

	SA1->(dbSeek(xFilial("SA1") + TMPCOB->A1_COD + TMPCOB->A1_LOJA))
	RecLock("TRBCOB", .T.)
	TRBCOB->CODIGO := TMPCOB->A1_COD
	TRBCOB->LOJA := TMPCOB->A1_LOJA
	TRBCOB->NOME := TMPCOB->A1_NOME
	TRBCOB->SALDO := TMPCOB->SALDO
//	TRBCOB->SALDOA := nSaldoA
//	TRBCOB->SALDOV := nSaldoV
	
	TRBCOB->OBSCOB := Substr(SA1->A1_X_OBCOB, 1, 1000)
	TRBCOB->NUMLST := GetLstCob(TMPCOB->A1_COD, TMPCOB->A1_LOJA)
	TRBCOB->SITCOB := GetSitCli(SA1->A1_X_SCOBR)
	TRBCOB->(MsUnlock())
	TMPCOB->(dbSkip())
EndDo

TMPCOB->(dbCloseArea())

dbSelectArea("TRBCOB")

// seta no início para iniciar a cobrança
TRBCOB->(dbGoTop())

cMarca := GetMark(,"TRBCOB", "ZZI_OK")

lInverte := .T.

aCpos := {}

AAdd(aCpos, {"ZZI_OK", " "," ", ""})
aAdd(aCpos, {"CODIGO", "", "Codigo", ""})
aAdd(aCpos, {"LOJA", "", "Loja", ""})
aAdd(aCpos, {"NOME", "", "Nome", ""})
aAdd(aCpos, {"SALDO", "", "Saldo", "@E 9,999,999.99"})
//aAdd(aCpos, {"SALDOV", "", "Vencido", "@E 9,999,999.99"})
//aAdd(aCpos, {"SALDOA", "", "A Vencer", "@E 9,999,999.99"})
aAdd(aCpos, {"SITCOB", "", "Sit. Cliente", ""})
aAdd(aCpos, {"OBSCOB", "", "Dados da Cobranca", ""})
aAdd(aCpos, {"NUMLST", "", "Cod. Lista", ""})
                                         
lCont := .F.
//cMarca := GetMark(,"TRBSA2", "A2_OK")

DEFINE MSDIALOG oDlg TITLE "Selecione os clientes para gerar a lista de cobrança" FROM 001, 001  TO 400,800 COLORS 0, 16777215 PIXEL
// @ 001,001 TO 400,800 DIALOG oDlg TITLE "Selecione os clientes para gerar a lista de cobrança"
oMark := MsSelect():New("TRBCOB",aCpos[1,1],,aCpos,@lInverte,@cMarca,{1,1,170,400})
oMark:oBrowse:lhasMark = .t.
oMark:oBrowse:lCanAllmark := .t.
@ 175,001 MSPANEL oPanel1 SIZE 400, 20 OF oDlg COLORS 0, 16777215 RAISED
@ 003,005 Say oSay1 PROMPT "Usuário Responsável: " SIZE 056, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 002,060 MSGET oGet1 VAR cUserCob Valid !Empty(cUserCob) F3 "US3" Size 040, 007 OF oPanel1 COLORS 0, 16777215 PIXEL

@ 003,110 Say oSay2 PROMPT "Nome da Lista: " SIZE 056, 007 OF oPanel1 COLORS 0, 16777215 PIXEL
@ 002,150 MSGET oGet2 VAR cNomeLista PICTURE "@!" Valid !Empty(cNomeLista) Size 100, 007 OF oPanel1 COLORS 0, 16777215 PIXEL

//@ 012, 007 GET oObsCob VAR cObsCob F3 "SA1" OF oPanel1 MULTILINE SIZE 352, 085 COLORS 0, 16777215 HSCROLL PIXEL
@ 002,260 BUTTON oBt4 Prompt "Dados Cob" SIZE 030, 010 OF oPanel1  ACTION DadosCob() PIXEL
@ 002,295 BUTTON oBt3 Prompt "Títulos" SIZE 030, 010 OF oPanel1  ACTION Processa( {|| VerTitulos() }, "Selecionando Títulos") PIXEL
@ 002,330 BUTTON oBt1 Prompt "Ok" SIZE 030, 010 OF oPanel1  ACTION (lCont := VldLista()) PIXEL
@ 002,365 BUTTON oBt2 Prompt "Cancela" SIZE 030, 010 OF oPanel1  ACTION (oDlg:End()) PIXEL
ACTIVATE DIALOG oDlg CENTERED

if !lCont
	TRBCOB->(dbCloseArea())
	Return
EndIf 

lValLista := MsgYesNo("Incluir clientes que possuem cobranças pendentes em outras listas?","Clientes em cobrança")

cCodigo := GetSXENum("ZZI","ZZI_CODIGO")
            
dbSelectArea("TRBCOB")
TRBCOB->(dbGoTop())
cSeq := "0001"
While TRBCOB->(!Eof())
	
	if IsMark("ZZI_OK", ThisMark(), ThisInv()) .And. (lValLista .Or. Empty(TRBCOB->NUMLST))
		RecLock("ZZJ", .T.)
		ZZJ->ZZJ_CODLIS := cCodigo
		ZZJ->ZZJ_SEQUEN := cSeq
		ZZJ->ZZJ_CODCLI := TRBCOB->CODIGO
		ZZJ->ZZJ_LOJCLI := TRBCOB->LOJA
		ZZJ->ZZJ_NOMECL := TRBCOB->NOME
		ZZJ->ZZJ_SALDO  := TRBCOB->SALDO
		ZZJ->ZZJ_STATUS := "01" // Aberto
		ZZJ->(MsUnlock())
		cSeq := Soma1(cSeq)
	EndIf
	
	dbSelectArea("TRBCOB")
	TRBCOB->(dbSkip())
EndDo
TRBCOB->(dbCloseArea())

// Grava os dados no ZZI conforme seleção da listagem para gerar
RecLock("ZZI", .T.)
ZZI->ZZI_CODIGO := cCodigo
ZZI->ZZI_NOMELI := cNomeLista // "LISTA TESTE EM " + dToC(dDataBase) + " - " + Time()
ZZI->ZZI_STATUS := "1" // Em Aberto
ZZI->ZZI_USUARI := cUserCob                                       
ZZI->ZZI_VCTDE	:= MV_PAR01
ZZI->ZZI_VCTATE	:= MV_PAR02
ZZI->(MsUnlock())
ConfirmSX8()

Return

Static Function VldLista()
Local lOk := .T.

if Empty(cNomeLista)
	lOk := .F.
	MsgInfo("Informe o nome da lista de cobrança.")
End


if Empty(cUserCob)
	lOk := .F.
	MsgInfo("Selecione o Usuário.")
End


if lOk 
	PswOrder(2)
	if !PswSeek(Trim(cUserCob)) // , .T.
		lOk := .F.
		MsgInfo("Usuário Inválido.")
	EndIf
End

// Valida se tem algum cliente marcado
if lOk
	lOk := .F.  
	
	TRBCOB->(dbGoTop())
	
	dbSelectArea("TRBCOB")
	
	While TRBCOB->(!Eof())
	
		if IsMark("ZZI_OK", ThisMark(), ThisInv()) 	
			lOk := .T.
			Exit
		
		EndIf
	
		dbSelectArea("TRBCOB")
	
		TRBCOB->(dbSkip())
	EndDo
	
	TRBCOB->(dbGoTop())
	
	if !lOk
		MsgInfo("Selecione um ou mais clientes da lista.")
	EndIf
	
EndIf

if lOk
	oDlg:End()
EndIf

Return lOk


// Monta a tela de interface dos itens da cobranca
User Function MntLista(cAlias, nReg, nOpc)
Local lCont := .T.
Local lExclui := .T.    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if (nOpc == 2)
	BrowseZZJ("ZZJ_CODLIS == '" + ZZI->ZZI_CODIGO + "'", .F., ZZI->ZZI_STATUS)
	Return
elseif (nOpc == 6)             // .AND. DTOS(ZZJ_DATAPR) <=  '" + dToS(dDataBase) + "' .AND. DTOS(ZZJ_DATAPR) != '        '
	BrowseZZJ("ZZJ_STATUS = '05'", .T., "1")
	Return
EndIf


if ZZI->ZZI_STATUS == "4"
	MsgInfo("Lista já encerrada", "Lista de Cobrança")
	Return
EndIf
//MsgInfo("Efetua a alteração/exclusao/finalizacao da lista", "Lista de Cobrança")
if nOpc == 4
	AxAltera(cAlias, nReg, nOpc)
elseif (nOpc == 5)
	lCont := MsgYesNo("Todos os atendimentos não executados serão finalizados. Continuar?","Cancelar/Finalizar Atendimentos")
	
	If lCont
		// Exclui da ZZJ
		dbSelectArea("ZZJ")
		dbSetOrder(01)
		cSeq := "0001"
		While ZZJ->(dbSeek(xFilial("ZZJ") + ZZI->ZZI_CODIGO + cSeq))
			RecLock("ZZJ", .F.)
			if ZZJ->(ZZJ->ZZJ_STATUS = "01")
				//ZZJ->(dbDelete())
				ZZJ->ZZJ_STATUS := "06" // Não Efetuado
			Else
				lExclui := .F.
			EndIf
			
			ZZJ->(MsUnlock())
			cSeq := Soma1(cSeq)
		EndDo
		
		// Exclui da ZZI ou finaliza a lista
		RecLock("ZZI", .F.)
		
		//if lExclui
		//	ZZI->(dbDelete())
		//else
		ZZI->ZZI_STATUS := "4"
		//EndIf
		
		ZZI->(MsUnlock())	
		//	MsgInfo("Não implementado!")
	EndIf
End
Return

// Faz a tela do atendimento para o usuário gerado
User Function AtendeCob()
Local aArea := GetArea()
Local cFiltro := ""
Local cFilAgenda := ""
Local cCodCob := ""
Local aIndexZZJ := {}

Private cCadastro := "Telecobrança - Gerar"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		 {"Visualizar" ,"U_AtendCobr" ,0 ,2} ,;
                     {"Atender"    ,"U_AtendCobr" ,0 ,4} ,;
                     {"Cancelar"   ,"U_AtendCobr" ,0 ,5} ,;
                     {"Reagendar"  ,"U_AtendCobr" ,0 ,6} ,;
                     {"Finalizar"  ,"U_AtendCobr" ,0 ,6} ,;
                     {"Cadastro"   ,"U_RJVISSA1"  ,0 ,7} ,;
                     {"Observações","U_RJOBSSA1"  ,0 ,7} ,;
                     {"Contatos"   ,"U_RJCONSA1"  ,0 ,7} }

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())                   
                           
// Busca qual cobrança é a primeira para o usuário executar
//cUserCob := SubStr(cUsuario, 7, 15)       
//cUserCob := PADR(UsrRetName(__cUserId), TAMSX3("ZZI_USUARI")[1])
cUserCob := PADR(cUserName, TAMSX3("ZZI_USUARI")[1])


// avalia se tem atendimentos agendados para realizar
// Por enquanto está sem controle de usuário, verificar para implementar
// Verificar para gerar nova lista com os atendimentos agendados
dbSelectArea("ZZJ")               // .AND. DTOS(ZZJ_DATAPR) <=  '" + dToS(dDataBase) + "' .AND. DTOS(ZZJ_DATAPR) != '        '
cFilAgenda := "ZZJ_STATUS == '05' .AND. ZZJ_USUARI == '" + cUserCob + "' "  // Somente os agendados
bFiltraBrw 	:= {|| FilBrowse("ZZJ",@aIndexZZJ,@cFilAgenda)}
Eval(bFiltraBrw)
dbGoTop()

if ZZJ->(!Eof()) .And. MsgYesNo("Deseja efetuar os atendimentos agendados?","Atender agenda")	
	mBrowse( 6,1,22,75,"ZZJ")
	EndFilBrw("ZZJ",aIndexZZJ)
	RestArea(aArea)
	Return
EndIf

EndFilBrw("ZZJ",aIndexZZJ)

//cFiltro := "ZZI_USUARI == '" + SubStr(cUsuario, 7, 15) + "' .And. ZZI_STATUS == '1'"
dbSelectArea("ZZI")
dbSetOrder(03)

lFound := dbSeek(xFilial("ZZI") + cUserCob + "2") // Busca primeiro em atendimento

if !lFound
	lFound := dbSeek(xFilial("ZZI") + cUserCob + "1") // Busca as em aberto
EndIf

if lFound
	cCodCob := ZZI->ZZI_CODIGO	
EndIf

// Seta o filtro de cobrança para o usuário atual
dbSelectArea("ZZJ")
dbSetOrder(01)

cFiltro := "ZZJ_CODLIS == '" + cCodCob +"'"
bFiltraBrw 	:= {|| FilBrowse("ZZJ",@aIndexZZJ,@cFiltro)}
Eval(bFiltraBrw)
dbGoTop()
mBrowse( 6,1,22,75,"ZZJ")

EndFilBrw("ZZJ",aIndexZZJ)
RestArea(aArea)
Return

// Busca o saldo de titulos a vencer e vencidos para o cliente
/*Static Function SaldoCliente(cCod, cLoja)
Local cSql1
Local cSql2

cSql1 := "SELECT SUM(E1_SALDO) AS SALDO FROM " + RetSqlName("SE1") + " WHERE E1_SALDO > 0"
cSql1 += " AND E1_VENCREA <= '" + DToS(dDataBase) + "' AND D_E_L_E_T_ <> '*' AND E1_TIPO IN ('NF')"
cSql1 += " AND E1_CLIENTE = '" + cCod + "' AND E1_LOJA = '" + cLoja + "' "

cSql2 := "SELECT SUM(E1_SALDO) AS SALDO FROM " + RetSqlName("SE1")
cSql2 += " WHERE E1_VENCREA > '" + DToS(dDataBase) + "' AND D_E_L_E_T_ <> '*' AND E1_TIPO IN ('NF')"
cSql2 += " AND E1_CLIENTE = '" + cCod + "' AND E1_LOJA = '" + cLoja + "' "

TcQuery cSql1 NEW ALIAS "TMPSAL"
nSaldoV := TMPSAL->SALDO
TMPSAL->(dbCloseArea())

TcQuery cSql2 NEW ALIAS "TMPSAL"
nSaldoA := TMPSAL->SALDO
TMPSAL->(dbCloseArea())
Return*/

Static Function AjustaPerg(cPerg)
cPerg := PADR(cPerg, Len(SX1->X1_GRUPO))
//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
PutSx1(cPerg,"01","Vencimento de ?","Vencimento De ?","Vencimento Ate ?","mv_ch1"  , "D", 8,0,0,"G","", "", "", "", "MV_PAR01")
PutSx1(cPerg,"02","Vencimento ate ?","Vencimento Ate ?","Vencimento Ate ?","mv_ch2", "D", 8,0,0,"G","", "", "", "", "MV_PAR02")
PutSx1(cPerg,"03","Filial de ?"    ,"Filial de ?"    ,"Filial de ?"    , "mv_ch3"  , "C", 2,0,0,"G","", "", "", "", "MV_PAR03")
PutSx1(cPerg,"04","Filial ate ?"   ,"Filial ate ?"   ,"Filial ate?"    , "mv_ch4"  , "C", 2,0,0,"G","", "", "", "", "MV_PAR04")
PutSx1(cPerg,"05","Valor minimo"   ,"Valor mínimo?"  ,"Valor mínimo?"  , "mv_ch5"  , "N",14,2,0,"G","", "", "", "", "MV_PAR05")
PutSx1(cPerg,"06","Segmento de ?"  ,"Segmento de ?"  ,"Segmento de ?"  , "mv_ch6"  , "C", 9,0,0,"G","", "CTH", "", "","MV_PAR06")
PutSx1(cPerg,"07","Segmento ate ?" ,"Segmento ate ?" ,"Segmento ate ?" , "mv_ch7"  , "C", 9,0,0,"G","", "CTH", "", "","MV_PAR07")
PutSx1(cPerg,"08","Vendedor de ?"  ,"Vendedor de ?"  ,"Vendedor de ?"  , "mv_ch8"  , "C", 6,0,0,"G","", "SA3", "", "","MV_PAR08")
PutSx1(cPerg,"09","Vendedor ate ?" ,"Vendedor ate ?" ,"Vendedor ate ?" , "mv_ch9"  , "C", 6,0,0,"G","", "SA3", "", "","MV_PAR09")
PutSx1(cPerg,"10","Valor Máximo ?" ,"Valor Máximo ?" ,"Valor Máximo ?" , "mv_chA"  , "N",14,2,0,"G","", "", "", "", "MV_PAR10")
PutSx1(cPerg,"11","Situações Tit ?","Situações Tit ?","Situações Tit ?", "mv_chB"  , "C",35,0,0,"G","", "", "", "", "MV_PAR11")
PutSx1(cPerg,"12","Tipos Titulos ?","Tipos Titulos ?","Tipos Titulos ?", "mv_chC"  , "C",35,0,0,"G","", "", "", "", "MV_PAR12")
PutSx1(cPerg,"13","Situa. Client ?","Situa. Client ?","Situa. Client ?", "mv_chD"  , "C",35,0,0,"G","", "", "", "", "MV_PAR13")
PutSx1(cPerg,"14","Riscos Client ?","Riscos Client ?","Riscos Client ?", "mv_chE"  , "C",25,0,0,"G","", "", "", "", "MV_PAR14")
Return

// Faz a visualização
Static Function BrowseZZJ(cFiltro, lAgendado, cStatus)
Local aIndexZZJ := {}
Local cFiltroInt := cFiltro
Local aArea := GetArea()
Local aRotinaBkp := aRotina

Local cEmpOri := SM0->M0_CODIGO
Local cFilOri := SM0->M0_CODFIL

aRotina := {}
//RpcClearEnv()
//RPCSetType(3)

//RpcSetEnv("30", "01",,,,GetEnvServer())
//MsgInfo("Trocou environment")

//RpcClearEnv()
//RPCSetType(3)

//RpcSetEnv(cEmpOri, cFilOri,,,,GetEnvServer())

//MsgInfo("Voltou")

dbSelectArea("ZZJ")
bFiltraBrw 	:= {|| FilBrowse("ZZJ",@aIndexZZJ,@cFiltroInt)}
Eval(bFiltraBrw)
dbGoTop()
// {"Alterar"    ,"AxAltera" ,0 ,4} ,;  
// Exibe um cadstro de itens, podendo o usuário administrador alterar
//AxCadastro("ZZJ")

aAdd(aRotina, {"Pesquisar"  ,"AxPesqui" ,0 ,1})
aAdd(aRotina, {"Visualizar" ,"U_AtendCobr" ,0 ,2}) // a visualizaçao é dos dados da cobrança

if !lAgendado .And. (cStatus != "4")
	aAdd(aRotina, {"Incluir"    ,"AxInclui" ,0 ,3})
EndIf

if (cStatus != "4")
	aAdd(aRotina, {"Excluir"    ,"AxDeleta" ,0 ,5})
EndIf

aAdd(aRotina, {"Cadastro"    ,"U_RJVISSA1()" ,0 ,6})
aAdd(aRotina, {"Observações" ,"U_RJOBSSA1()" ,0 ,6})
aAdd(aRotina, {"Contatos"    ,"U_RJCONSA1()" ,0 ,6})

mBrowse(10,10,22,75,"ZZJ")

EndFilBrw("ZZJ",aIndexZZJ)
RestArea(aArea)

aRotina := aRotinaBkp

Return

User Function ProxSeqZZJ()
Local cSeq := "0001"             

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cSql := " SELECT MAX(ZZJ_SEQUEN) + 1 AS SEQ FROM " + RetSqlName("ZZJ") + " WHERE ZZJ_FILIAL = '"+XFILIAL("ZZJ")+"' AND ZZJ_CODLIS = '"+ZZI->ZZI_CODIGO+"' AND D_E_L_E_T_ <> '*' "
TcQuery cSql NEW ALIAS "TMPSEQ"
cSeq := PadL(TMPSEQ->SEQ, 4, "0")
TMPSEQ->(dbCloseArea())
Return cSeq

// Faz a busca dos títulos e monta o aging por período para cada título
Static Function VerTitulos()
Local cTV07 := "Vecidos a 7"
Local cTV14 := "Vecidos a 14"
Local cTV30 := "Vecidos a 30"
Local cTV60 := "Vecidos a 60"
Local cTV90 := "Vecidos a 90"
Local cTVM90 := "Vecidos > 90"
Local cTVTot := "Vencido Total"
Local cTA07 := "A Vencer em 7"
Local cTA14 := "A Vencer em 14"
Local cTAM15 := "A Vencer > 15"
Local cTATot := "A Vencer Total"
Local oButton1
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"E1_FILIAL","E1_TIPO","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_EMISSAO","E1_VENCREA","E1_SITUACA","E1_SALDO","TV07","TV14","TV30","TV60","TV90","TVM90","TA07","TA14","TA30","TA60","TA90","TAM90"}
Local aAlterFields := {}
Static oMSNewGe1
Static oDlg2

	// Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
    
     	if (aFields[nX] == "E1_SITUACA")
    		Aadd(aHeaderEx, {"Situacao","E1_SITUACA","",15,0,,,"C"})
    	else 
      	Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    EndIf
    Endif
  Next nX
  
  aAdd(aHeaderEx, {cTVTot,"TVTOT","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTV07,"TV07","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTV14,"TV14","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTV30,"TV30","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTV60,"TV60","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTV90,"TV90","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTVM90,"TVM90","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTATot,"TATOT","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTA07,"TA07","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTA14,"TA14","@E 9,999,999.99",12,2,,,"N"})
  aAdd(aHeaderEx, {cTAM15,"TAM15","@E 9,999,999.99",12,2,,,"N"})
  

	// Carrega as informações dos títulos a vencer do cliente
  BeginSql Alias "TMPTAB"
  	SELECT 	E1_FILIAL, E1_TIPO, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_EMISSAO, 
  			E1_VENCREA, E1_VENCORI, E1_VALOR, E1_SALDO, E1_SITUACA
  	FROM 	%TABLE:SE1% SE1
  	WHERE 	SE1.E1_FILIAL	<> %Exp:Space(TAMSX3("E1_FILIAL")[1])% 
  	AND 	SE1.E1_CLIENTE	= %Exp:TRBCOB->CODIGO% 
  	AND 	SE1.E1_LOJA 	= %Exp:TRBCOB->LOJA%
  	AND		SE1.E1_SALDO 	> 0 
  	AND 	SE1.%Notdel%
  	ORDER BY E1_VENCREA, E1_FILIAL
  EndSql
  
  nTotTV07 := 0
 	nTotTV14 := 0
 	nTotTV30 := 0
 	nTotTV60 := 0
 	nTotTV90 := 0
 	nTotTVM90 := 0
 	nTotTVTot := 0
 	nTotTA07 := 0
 	nTotTA14 := 0
 	nTotTAM15 := 0
 	nTotTATot := 0 	
 	nTotSaldo := 0
  
  dbSelectArea("TMPTAB")
    
  While TMPTAB->(!Eof())
  	//
  	aFieldFill := {}
  	//"E1_FILIAL","E1_TIPO","E1_PREFIXO","E1_NUM","E1_PARCELA","E1_EMISSAO","E1_VENCREA","E1_SITUACA","E1_SALDO","TV07","TV14","TV30","TV60","TV90","TVM90","TA07","TA14","TA30","TA60","TA90","TAM90"
  	aAdd(aFieldFill, E1_FILIAL)
  	aAdd(aFieldFill, E1_TIPO)
  	aAdd(aFieldFill, E1_PREFIXO)
  	aAdd(aFieldFill, E1_NUM)
  	aAdd(aFieldFill, E1_PARCELA)
  	aAdd(aFieldFill, SToD(E1_EMISSAO))
  	aAdd(aFieldFill, SToD(E1_VENCREA))
  	aAdd(aFieldFill, GetSitCob(E1_SITUACA))
  	aAdd(aFieldFill, GetValSE1(E1_SALDO, E1_TIPO))
  	
  	nTotSaldo += GetValSE1(E1_SALDO, E1_TIPO)
  	
  	nDias := dDataBase - SToD(E1_VENCREA)
  	
  	nTV07 := 0
  	nTV14 := 0
  	nTV30 := 0
  	nTV60 := 0
  	nTV90 := 0
  	nTVM90 := 0
  	nTVTot := 0
  	nTA07 := 0
  	nTA14 := 0
  	nTAM15 := 0
  	nTATot := 0
  	
  	if (nDias > 90)
  		nTVM90 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTVM90 += nTVM90
  	elseif (nDias > 60)
  		nTV90 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTV90 += nTV90
  	elseif (nDias > 30)
  		nTV60 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTV60 += nTV60
  	elseif (nDias > 14)
  		nTV30 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTV30 += nTV30
  	elseif (nDias > 7)
  		nTV14 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTV14 += nTV14
  	elseif (nDias >= 0)
  		nTV07 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTV07 += nTV07
  	elseif (nDias > -7)
  		nTA07 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTA07 += nTA07
  	elseif (nDias > -14)
  		nTA14 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTA14 += nTA14
  	elseif (nDias < -14)
  		nTAM15 := GetValSE1(E1_SALDO, E1_TIPO)
  		nTotTAM15 += nTAM15
  	EndIf
  	
  	aAdd(aFieldFill, nTV07+nTV14+nTV30+nTV60+nTV90+nTVM90)
  	aAdd(aFieldFill, nTV07)
  	aAdd(aFieldFill, nTV14)
  	aAdd(aFieldFill, nTV30)
  	aAdd(aFieldFill, nTV60)
  	aAdd(aFieldFill, nTV90)
  	aAdd(aFieldFill, nTVM90)
  	
  	aAdd(aFieldFill, nTA07+nTA14+nTAM15)
  	aAdd(aFieldFill, nTA07)
  	aAdd(aFieldFill, nTA14)
  	aAdd(aFieldFill, nTAM15)  	
  	
  	nTotTVTot += nTV07+nTV14+nTV30+nTV60+nTV90+nTVM90
  	nTotTATot += nTA07+nTA14+nTAM15
  	
  	Aadd(aFieldFill, .F.)
  	Aadd(aColsEx, aFieldFill)  
  	
		TMPTAB->(dbSkip())
		
  EndDo
  
  TMPTAB->(dbCloseArea())
  
  // Adiciona uma linha com os valores totais
  aFieldFill := {}
  aAdd(aFieldFill, "--")
	aAdd(aFieldFill, "--")
	aAdd(aFieldFill, "---")
 	aAdd(aFieldFill, "--TOTAL--")
 	aAdd(aFieldFill, "---")
 	aAdd(aFieldFill, "        ")
 	aAdd(aFieldFill, "        ")
 	aAdd(aFieldFill, "")
 	aAdd(aFieldFill, nTotSaldo)
 	
 	aAdd(aFieldFill, nTotTVTot)
 	aAdd(aFieldFill, nTotTV07)
 	aAdd(aFieldFill, nTotTV14)
 	aAdd(aFieldFill, nTotTV30)
 	aAdd(aFieldFill, nTotTV60)
 	aAdd(aFieldFill, nTotTV90)
 	aAdd(aFieldFill, nTotTVM90)
 	aAdd(aFieldFill, nTotTATot)
 	aAdd(aFieldFill, nTotTA07)
 	aAdd(aFieldFill, nTotTA14)
 	aAdd(aFieldFill, nTotTAM15)
 	

 	
 	aAdd(aFieldFill, .F.)
 	
 	Aadd(aColsEx, aFieldFill)
  
  DEFINE MSDIALOG oDlg2 TITLE "Aging do Cliente" FROM 000, 000  TO 400, 700 COLORS 0, 16777215 PIXEL
    oMSNewGe1 := MsNewGetDados():New( 006, 001, 179, 345, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlg2, aHeaderEx, aColsEx)
    @ 183, 154 BUTTON oButton1 PROMPT "Ok" Action (oDlg2:End()) SIZE 037, 012 OF oDlg2 PIXEL
  ACTIVATE MSDIALOG oDlg2 CENTERED
  
Return

// Funcao que exibe os dados completos da cobrança
Static Function DadosCob()
Local oDlgObs
Local oPnObs
Local cObsCob := TRBCOB->OBSCOB
DEFINE MSDIALOG oDlgObs TITLE "Dados da cobrança" FROM 001, 001  TO 240, 600 COLORS 0, 16777215 PIXEL
@ 001, 001 MSPANEL oPnObs SIZE 599, 238 OF oDlgObs COLORS 0, 16777215 RAISED
@ 015, 007 GET oObsCob VAR cObsCob OF oPnObs MULTILINE SIZE 285, 085 COLORS 0, 16777215 HSCROLL PIXEL
//@ 100, 200 BUTTON oBt1 Prompt "Ok" SIZE 030, 010 OF oPnObs  ACTION (oDlgObs:End()) PIXEL
ACTIVATE DIALOG oDlgObs CENTER ON INIT ;
EnchoiceBar(oDlgObs,{|| oDlgObs:End(), Nil }, {|| oDlgObs:End() })

Return


Static Function GetValSE1(nValOri, cTipo)
Local nValor := nValOri
nValor := iif(cTipo $ "AB-/NCC/RA ", nValor * (-1), nValor)
Return nValor

Static Function GetSitCob(cSit)
Local aSituacao := { {"0", "Carteira"}, {"1", "Cob.Simples"}, {"2","Descontada"},{"3","Caucionada"},;
					{"4","Vinculada"},{"5","Advogado"},{"6","Judicial"}, {"7", "Cob Caucao Descont"}}
Local cDescSit := ""
Local nPos := aScan(aSituacao, {|x| x[1] == cSit})
cDescSit := iif(nPos > 0, aSituacao[nPos][2], "")
Return cDescSit

// Ob
Static Function GetLstCob(cCod, cLoja)
Local cLista := Space(6)
Local cSql
cSql := "SELECT ZZJ_CODLIS FROM " + RetSqlName("ZZJ") + " ZZJ WHERE ZZJ_FILIAL = '"+XFILIAL("ZZJ")+"' AND ZZJ_CODCLI = '"+cCod+"' "
cSql += "AND ZZJ_LOJCLI = '" + cLoja + "' AND ZZJ_STATUS IN ('01', '05') AND D_E_L_E_T_ <> '*' "

TCQuery cSql NEW ALIAS "ZZJTMP"

if ZZJTMP->(!Eof())
	cLista := ZZJTMP->ZZJ_CODLIS
EndIf

dbCloseArea("ZZJTMP")

Return cLista

// Retorna a situação da cobrança
Static Function GetSitCli(cSitCob)
Local cDescSit := ""

Do Case
	Case cSitCob == "01"
		cDescSit := "01-Equipe CR"
	Case cSitCob == "02"
		cDescSit := "02-Terceirizada"
	Case cSitCob == "03"
		cDescSit := "03-CR Transportadora"
	Case cSitCob == "04"
		cDescSit := "04-Cheque Devolvido"
	Case cSitCob == "05"
		cDescSit := "05-Conf. Divida"
	Case cSitCob == "06"
		cDescSit := "06-Juridico"
	Case cSitCob == "07"
		cDescSit := "07-Cheque Pre"
	Case cSitCob == "08"
		cDescSit := "08-Comprov. Banco"
	Case cSitCob == "09"
		cDescSit := "09-PDD"
		// 01=Equipe CR;02=Tercerizada;03=CR Transp;04=Cheque Devol;05=Conf. Divida;06=Juridico;07=Cheque Pre;08=Comprov. Banco;09=PDD
EndCase

return cDescSit

// Faz o cadastro de permissões X Usuários
User Function ManZZO()
AxCadastro("ZZO", "Permissões do atendimento Telecobrança")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

User Function ObsCobr(lParam, cCODCLI, cLOJCLI )

Local oObsCob
Local oButton1
Local oSitCli
Local oCliente
Local oLoja
Local oNomeCli
Local aButtons := {}
Local oGroup1
Local oSay1, oSay2, oSay3, oSay4
Local aSitua := {"  ", "01=Equipe CR", "02=Tercerizada", "03=CR Transp", "04=Cheque Devol", "05=Conf. Divida", ;
										"06=Juridico", "07=Cheque Pre", "08=Comprov. Banco", "09=PDD"}
Local nOpc := 0
Private cCliente := Space(9)
Private cLoja := Space(4)
Private lEdita := .F.
Private cNomeCli := Space(41)
Private cObsCob := Space(1)
Private cSitCli
Static oDlgCli

Default lParam := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If lParam
		cCliente := cCODCLI
		cLoja := cLOJCLI
		VldCli()
	EndIf 
 Aadd( aButtons, {"Contatos", {|| fContatos()}, "Contatos...", "Contatos" , {|| .T.}} )

  DEFINE MSDIALOG oDlgCli TITLE "Informações Cob. Clientes" FROM 000, 000  TO 450, 700 COLORS 0, 16777215 PIXEL

    @ 042, 003 SAY oSay1 PROMPT "Cliente: " SIZE 025, 007 OF oDlgCli COLORS 0, 16777215 PIXEL
    @ 040, 034 MSGET oCliente VAR cCliente SIZE 135, 010 VALID VldCli() OF oDlgCli COLORS 0, 16777215 F3 "SA1" PIXEL // ON CHANGE (nOpc:=0,cNomeCli:="", cObsCob:="",cSitCli:="")
    @ 042, 198 SAY oSay2 PROMPT "Loja: " SIZE 025, 007 OF oDlgCli COLORS 0, 16777215 PIXEL
    @ 040, 231 MSGET oLoja VAR cLoja SIZE 035, 010 VALID VldCli() OF oDlgCli COLORS 0, 16777215 PIXEL
//    DEFINE SBUTTON FROM 015, 287 TYPE 01 ACTION(cObsCob:=DadosCli(cCliente,cLoja,2), ;
//		 			    																	cNomeCli:=DadosCli(cCliente,cLoja,1), ;
//						    																cSitCli:=DadosCli(cCliente,cLoja,3), ;
//						    																iif(!DadosCli(cCliente,cLoja,4),nOpc:=0,nOpc:=1)) ENABLE OF oDlgCli
    @ 075, 000 GROUP oGroup1 TO 200, 350 PROMPT "Cobrança Cliente: " OF oDlgCli COLOR 0, 16777215 PIXEL
	@ 090, 004 GET oObsCob VAR cObsCob WHEN lEdita OF oDlgCli MULTILINE SIZE 341, 107 COLORS 0, 16777215 HSCROLL PIXEL
    @ 204, 041 COMBOBOX oSitCli VAR cSitCli ITEMS aSitua WHEN lEdita SIZE 072, 010 OF oDlgCli COLORS 0, 16777215 PIXEL
    @ 206, 009 SAY oSay3 PROMPT "Situação: " SIZE 025, 007 OF oDlgCli COLORS 0, 16777215 PIXEL
    @ 055, 034 MSGET oNomeCli VAR cNomeCli SIZE 232, 010 OF oDlgCli COLORS 0, 16777215 READONLY PIXEL
    @ 057, 004 SAY oSay4 PROMPT "Nome: " SIZE 025, 007 OF oDlgCli COLORS 0, 16777215 PIXEL
                                                                                                   
    oGroup1:Align := CONTROL_ALIGN_BOTTOM

  ACTIVATE MSDIALOG oDlgCli CENTERED ON INIT ;
	EnchoiceBar(oDlgCli,{|| AltCli(cCliente, cLoja, cObsCob, cSitCli, nOpc), oDlgCli:End() }, {|| oDlgCli:End() },,@aButtons)

Return

Static Function fContatos()
Local aAreaTMP := GetArea()
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1")+cCliente+cLoja )
		U_FCONRJU("SA1",SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME)
	EndIf

	RestArea(aAreaTMP)
Return
                                                    
/*Static Function DadosCli(cCliente, cLoja, nOpc)	
DbSelectArea("SA1")
DbSetOrder(01)

if (DbSeek(xFilial("SA1")+cCliente+cLoja))
	if nOpc == 1
		Return SA1->A1_NOME
	ElseIf nOpc == 2
		Return SA1->A1_X_OBCOB
	ElseIf nOpc == 3
		Return SA1->A1_X_SCOBR
	Else
		Return .T.
	EndIf
EndIf

Return nil*/

/*********************************************************
 Função que altera os dados da cobrança e situação de cobrança
 *********************************************************/
Static Function AltCli(cCliente, cLoja, cObsCob, cSitCli, nOpc)
//  if nOpc = 1
DbSelectArea("SA1")
DbSetOrder(01)
if (DbSeek(xFilial("SA1")+cCliente+cLoja))
	if (!(cObsCob == SA1->A1_X_OBCOB) .or. !(cSitCli == SA1->A1_X_SCOBR))
		RecLock("SA1", .F.)
		SA1->A1_X_OBCOB := cObsCob
		SA1->A1_X_SCOBR := cSitCli
		SA1->(MsUnlock())
		MsgAlert("Cliente alterado!")	
	else
		MsgAlert("Nenhuma alteração foi realizada")
	EndIf
Else
	MsgAlert("Cliente não encontrado!")
EndIf
Return           

// Flavio - 19/10/2011
// Faz a validação do cliente, se o mesmo possui cliente e loja e caso positivo, habilita os campos para edição
Static Function VldCli()
Local lRet := .T.
SA1->(dbSetOrder(01))
if !SA1->(dbSeek(xFilial("SA1") + cCliente))
  lRet := .F.
EndIf

if SA1->(dbSeek(xFilial("SA1") + cCliente + cLoja))
	cNomeCli := SA1->A1_NOME
	cObsCob := SA1->A1_X_OBCOB
	cSitCli := SA1->A1_X_SCOBR
	lEdita := .T.
else
	cNomeCli := ""
	cObsCob := ""
	cSitCli := ""
	lEdita := .F.
EndIf
Return .T.  


//--Visualizacao do cadastro do cliente.
User Function RJVISSA1()  

Local aAreaTMP := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1")+ZZJ->ZZJ_CODCLI+ZZJ->ZZJ_LOJCLI )
		SA1->(AxInclui("SA1",SA1->(RECNO()),2))
	EndIf        
	
	RestArea(aAreaTMP)

Return 


//--Contatos do cadastro do cliente.
User Function RJCONSA1()  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SA1")
	dbSetOrder(1)
	If dbSeek( xFilial("SA1")+ZZJ->ZZJ_CODCLI+ZZJ->ZZJ_LOJCLI )
		U_FCONRJU("SA1",SA1->A1_COD,SA1->A1_LOJA,SA1->A1_NOME)
	EndIf

Return
	
//--Janela de contato RJU
User Function FCONRJU(cTABCON,cCODCON,cLOJCON,cNOMCON)

Local aAreaTMP	:= GetArea()                        

Private aHeader		:= {}
Private aCols		:= {}
Private aFldsTMP	:= {}
Private aTravas		:= {}
Private aRecZ69		:= {}
Private aColsAlt	:= {}
Private nUsado		:= 0
Private lConfirma 	:= .F.
Private lTravas 	:= .T.
Private oDlgCON    
Private oGrdCON

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("Z69")
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO=="Z69" )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .and. ! AllTrim(SX3->X3_CAMPO) $ "Z69_FILIAL|Z69_ALIAS|Z69_COD|Z69_LOJA" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()) ,;
                         SX3->X3_CAMPO       ,;
                         SX3->X3_PICTURE     ,;
                         SX3->X3_TAMANHO     ,;
                         SX3->X3_DECIMAL     ,;
                         SX3->X3_VALID       ,;
                         SX3->X3_USADO       ,;
                         SX3->X3_TIPO        ,;
                         SX3->X3_F3          ,;
                         SX3->X3_CONTEXT     ,;
                         SX3->X3_CBOX        ,;
                         SX3->X3_RELACAO     ,;
                         SX3->X3_WHEN        ,;
                         SX3->X3_VISUAL      ,;
                         SX3->X3_VLDUSER     ,;
                         SX3->X3_PICTVAR     ,;
   						".T."       } )
				aAdd (aColsAlt, SX3->X3_CAMPO)
		EndIf
    	SX3->(dbSkip())
    Enddo
    
	dbSelectArea("Z69")
	dbSetOrder(1)
	If dbSeek( xFilial("Z69") + cTABCON + cCODCON + cLOJCON )
		While !Z69->(EOF()) .and. Z69->(Z69_FILIAL+Z69_ALIAS+Z69_COD+Z69_LOJA) ==  xFilial("Z69") + cTABCON + cCODCON + cLOJCON
			If ( SoftLock("Z69" ) )
				AAdd(aTravas,{ Alias() , RecNo() })
				AAdd(aCols,Array(nUsado+1))
				AAdd(aRecZ69, Z69->( Recno() ) )
				For nCntFor := 1 To nUsado
					If ( aHeader[nCntFor][10] != "V" )
						aCols[Len(aCols)][nCntFor] := Z69->(FieldGet(FieldPos(aHeader[nCntFor][2])))
					Else
						aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
					EndIf
				Next
				aCols[Len(aCols)][nUsado+1] := .F.				
			Else
				lTravas := .F.
			EndIf

			Z69->(dbSkip())
		Enddo
	Else    
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[Len(aCols),nUsado+1] := .F.
	EndIf
	
    If lTravas
		DEFINE MSDIALOG oDlgCON TITLE "Contatos "+ALLTRIM(cNOMCON) FROM 001, 001 TO 340, 800 COLORS 0, 16777215 PIXEL
		oGrdCON := MsNewGetDados():New( 005, 005, 150, 400, GD_INSERT+GD_UPDATE+GD_DELETE, 	"AllwaysTrue", "AllwaysTrue", "" , aColsAlt,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgCON, aHeader, aCols)
		ACTIVATE MSDIALOG oDlgCON CENTERED ON INIT EnchoiceBar(oDlgCON,{|| lConfirma := .T., If(oGrdCON:TudoOk(),oDlgCON:End(),lConfirma:=.F.), Nil }, {|| oDlgCON:End() })
	Else
		Aviso("Aviso","Contatos deste cliente estão em edição!",{"OK"})
	EndIf
		
	If lConfirma
		RJGRVCON(aRecZ69,cTABCON,cCODCON,cLOJCON)
	EndIf

	RestArea(aAreaTMP)

Return


//--Grava contatos do cliente
Static Function RJGRVCON(aRecZ69,cTABCON,cCODCON,cLOJCON)

Private aHeader		:= oGrdCON:aHeader
Private aCols		:= oGrdCON:aCols


	For nLoop := 1 To Len(aCols)
		lGravou := .T.
		If GDDeleted( nLoop )
			If nLoop <= Len( aRecZ69 )
				Z69->( MsGoto( aRecZ69[ nLoop ] ) ) 	
				RecLock( "Z69", .F. )
				Z69->( dbDelete() )
				Z69->( MsUnlock() ) 		
			EndIf
		Else
			
			If nLoop <= Len( aRecZ69 )
				Z69->( MsGoto( aRecZ69[ nLoop ] ) ) 	
				RecLock( "Z69", .F. )
			Else
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Inclui e grava os campos chave                                         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RecLock( "Z69", .T. ) 		
				Z69->Z69_FILIAL := xFilial( "Z69" )
				Z69->Z69_ALIAS  := cTABCON
				Z69->Z69_COD	:= cCODCON
				Z69->Z69_LOJA	:= cLOJCON
				
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava os demais campos                                                 ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			For nLoop2 := 1 To Len( aHeader )
				If ( aHeader[nLoop2,10] <> "V" ) .And. !( AllTrim( aHeader[nLoop2,2] ) $ "Z69_FILIAL|Z69_ALIAS|Z69_COD|Z69_LOJA" )
					Z69->(FieldPut(FieldPos(aHeader[nLoop2,2]),aCols[nLoop,nLoop2]))
				EndIf
			Next nLoop2

			Z69->( MsUnlock() )

		EndIf

	Next nLoop         
	

Return                


//--Observacoes do cadastro do cliente.
User Function RJOBSSA1()  
Local aAreaTMP := GetArea()      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	U_ObsCobr(.T., ZZJ->ZZJ_CODCLI, ZZJ->ZZJ_LOJCLI )	
	RestArea(aAreaTMP)

Return
