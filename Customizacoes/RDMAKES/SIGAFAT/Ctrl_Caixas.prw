#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MAN_CAIX ºAutor  ³Gustavo Lattmann     º Data ³  13/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria um grid para a consulta dos registros.                 º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MAN_CAIX()

Private cCadastro := "Controle de Caixaria" //Variavel padrão para o título do mBrowse
Private aRotina	:= MENUDEF() //Variável padrão para as opções do mBrowse

dbSelectArea("SZR")
SZR->(dbsetOrder(1))
SZR->(dbGoTop())

//Os parametros são padrões do tamanho da tela que abriu
mBrowse(6,1,22,75,"SZR") //Compenente para gerar a tela sobre a tabela SZR

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MENUDEFºAutor  ³Gustavo Lattmann       º Data ³  13/08/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Define as rotinas que serão apresentadas no browse.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MENUDEF()
Local aOpcoes := {}

AADD(aOpcoes, {"Pesquisa"	, "AxPesqui"	, 0, 1})
AADD(aOpcoes, {"Visualiza"	, "AxVisual"	, 0, 2})
AADD(aOpcoes, {"Inclui"		, "U_CTRL_CAIX"	, 0, 3})
AADD(aOpcoes, {"Exclui"		, "AxDeleta"	, 0, 5})

Return aOpcoes
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTRL_CAIXASºAutor  ³Microsiga           º Data ³  29/01/13  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função utilizada para fazer o controle de caixarias.       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS - Gestão de Distribuição                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

USER FUNCTION CTRL_CAIX(aDados)

Static oDlg
Local cDlgTitle	:= "Controle de caixas"
Local nOpca	  	:= 3
Local nX        := 0
Local lOpen     := .T.

Private aHeaderCx 	 := {}
Private aColsCx   	 := {}
Private aFieldFill 	 := {}
Private aFields      := {"ZR_TPCAIXA","ZR_QUANT","ZR_LOCAL"}
Private aAlterFields := {"ZR_TPCAIXA","ZR_QUANT","ZR_LOCAL"}            

Private cMapa	:= Space(06) 															
Private cTransp	:= Space(06) 															
Private cDesTra	:= Space(20)	 														
Private cMoto	:= Space(06) 															
Private cEol    := CHR(13)+CHR(10)												
Private cPed1	:= "" 		   															
Private cPed2	:= "" 		   															
Private cPed3	:= "" 		   															
Private cDesMot	:= Space(20) 															
Private lTpCli  := iif(ValType(aDados)=="A",.F.,.T.)      
Private aTPCli	:= {'Cliente','Produtores','Filiais','Generico'} 
Private cTPCli	:= 'Cliente'           
Private lTpMov  := iif(ValType(aDados)=="A",.F.,.T.)
Private aTPMov	:= {'Saída','Entrada','Saida Ajuste'} 		
Private cTPMov	:= iif(ValType(aDados)=="A",aDados[03],'Saída')
Private cConfer	:= Space(60) 															
Private dData   := Date()
Private cUser   := Upper(SubStr(cUsuario, 07, 15))
Private lBlqMapa := .T.

Private oGetCx 
Private cCODDAK := iif(ValType(aDados)=="A",aDados[02],nil)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona informação dos campos aos Arrays³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DbSelectArea("SX3")
SX3->(DbGoTop())
SX3->(DbSetOrder(2))

for nX := 1 to Len(aFields)
	if DbSeek(aFields[nX])
		aAdd(aHeaderCx,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	EndIf
Next nX

If cCODDAK<>nil
	cMapa:=cCODDAK

	VerMapa()
		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆJ¿
	//³Caso o código do mapa vier por parâmetro na chamada da função, atualiza o grid com as informações³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄˆJÙ

	AtuaGrid(cTPMov,.F.)

EndIf

DEFINE MSDIALOG oDlg TITLE cDlgTitle FROM 003, 001  TO 470, 410 COLORS 0, 16777215 PIXEL

@ 010, 005 SAY oLbTpMov PROMPT "Tipo Movimentação" 	SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 010, 055 SAY oLbTpCad PROMPT "Tipo Cliente"      	SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 010, 098 SAY oLbMapa  PROMPT "Mapa"				SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 010, 145 SAY oLbData  PROMPT "Data"				SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 030, 005 SAY oLbMotor PROMPT "Motorista"			SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 030, 055 SAY oLbNmMot PROMPT "Nome Motorista"		SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL                
@ 050, 005 SAY oLbTrans PROMPT "Transportador"		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 050, 055 SAY oLbNmTra PROMPT "Nome Transportador" SIZE 050, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 160, 005 SAY oLbUser  PROMPT "Usuario"			SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL                               
@ 160, 055 SAY oLbConf  PROMPT "Conferente" 		SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL      
@ 177, 005 SAY oLbPed   PROMPT "Pedidos"			SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL

@ 017, 005 MSCOMBOBOX oTpMov VAR cTpMov ITEMS aTpMov SIZE 050, 009 OF oDlg COLORS 0, 16777215 WHEN lTpMov ON CHANGE (VerMapa(),AtuaGrid(cTpMov, .T.), AtuMapa(),;
															iif(cTpMov == 'Saida Ajuste', {cTpCli := 'Generico',lTpCli := .F.,cMapa := " "},lTpCli := .T.)) PIXEL
															
@ 017, 055 MSCOMBOBOX oTpCli VAR cTPCli ITEMS aTPCli SIZE 040, 009 OF oDlg COLORS 0, 16777215 WHEN lTpCli ON CHANGE (VerMapa(),AtuaGrid(cTpMov, .T.), AtuMapa()) PIXEL

@ oGetCx := MsNewGetDados():New(078, 005, 160, 200, GD_INSERT+GD_DELETE+GD_UPDATE, "U_ValidaLinha()", "U_ValidaTudo()","",; 
																aAlterFields,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlg, aHeaderCx, aColsCx)

@ 017, 098 MSGET oGetMapa VAR cMapa 	SIZE 040, 009 WHEN lBlqMapa 	OF oDlg COLORS 0, 16777215 VALID (VerMapa() .and. AtuaGrid(cTpMov, .T.)) F3 "DAK" PIXEL
@ 017, 145 MSGET oGetDate VAR dData 	SIZE 055, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL
@ 037, 005 MSGET oGetMoto VAR cMoto 	SIZE 050, 009 WHEN .T. 			OF oDlg COLORS 0, 16777215 VALID VerMot() F3 "DA4" PIXEL 
@ 037, 055 MSGET oGetNmMo VAR cDesMot 	SIZE 145, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL
@ 057, 005 MSGET oGetTran VAR cTransp 	SIZE 050, 009 WHEN .F.			OF oDlg COLORS 0, 16777215 PIXEL
@ 057, 055 MSGET oGetDesT VAR cDesTra 	SIZE 145, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL
@ 167, 005 MSGET oGetUser VAR cUser   	SIZE 050, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL 
@ 167, 055 MSGET oGetConf VAR cConfer 	SIZE 145, 009 WHEN .T.			OF oDlg COLORS 0, 16777215 PIXEL 
@ 184, 005 MSGET oGetPed1 VAR cPed1 	SIZE 195, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL 
@ 197, 005 MSGET oGetPed2 VAR cPed2 	SIZE 195, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL  
@ 210, 005 MSGET oGetPed3 VAR cPed3 	SIZE 195, 009 WHEN .F. 			OF oDlg COLORS 0, 16777215 PIXEL  

ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER

IF (nOpca == 1) 
  	MsAguarde( {|| Grava()}, "Aguarde...", "Atualizando dados..." )
Endif	

Return(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Pesquisa dados do mapa de cargas e atualiza variaveis.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function VerMapa()
Local lRet			:= .T.
Local cPedidos	:= ""
Local nPass			:= 0
Local nNrPed		:= 1

if !Empty(cMapa)
	
	cSql := "SELECT DAK.DAK_FILIAL, DAK.DAK_COD, DAK.DAK_MOTORI, DAI.DAI_PEDIDO FROM "+ RetSqlName("DAI")+ " DAI " +cEol
	cSql += "INNER JOIN "+ RetSqlName("DAK")+ " DAK "																															 +cEol	
	cSql += "   ON DAK.DAK_FILIAL = DAI.DAI_FILIAL "                                                               +cEol
	cSql += "  AND DAK.DAK_COD = DAI.DAI_COD "                                                                     +cEol
	cSql += "  AND DAK.D_E_L_E_T_ <> '*' "                                                                         +cEol
	cSql += "WHERE DAI.D_E_L_E_T_ <> '*' "                                                                         +cEol
	cSql += "  AND DAI.DAI_FILIAL = '"+xFilial("DAI")+"' "                                                         +cEol
	cSql += "  AND DAI.DAI_COD 		= '"+cMapa+"' "                                                                +cEol
	
	TCQUERY cSql NEW ALIAS "TMPDAI"
	
	DbSelectArea("TMPDAI")
	TMPDAI->(DbGotop())   
	
	If !TMPDAI->(Eof())
		cPedidos	:= ""     
		cTransp 	:= " " 
		
		//Caso haja o motorista informado no mapa irá preencher.		
		cMoto := TMPDAI->DAK_MOTORI 
			
		While !TMPDAI->(Eof())
			cPedidos	+= TMPDAI->DAI_PEDIDO+","
			TMPDAI->(DbSkip())
		End
		
		cPed1 := "" 
		cPed2 := "" 
		cPed3 := ""
		
		For nR := 1 To Len(cPedidos)
			If !Empty(SubStr(cPedidos,nR,1))
				Do Case 
					Case nPass <= 62
						cPed1 	+= SubStr(cPedidos,nR,1)
					Case nPass >= 62 .AND. nPass <= 125
						cPed2 	+= SubStr(cPedidos,nR,1)		
					Case nPass > 125
						cPed3 	+= SubStr(cPedidos,nR,1)
				EndCase
				nPass	+= 1
			Endif
		Next nR 
		
		cDesTra := SubStr(POSICIONE("SA4",1,xFilial("SA4")+cTransp,"A4_NOME"),1,20)
		dlgRefresh(oDlg) 
		
	Else
		Alert("O Mapa informado não é válido!")
		lRet	:= .F.
	Endif 
	
	If Select("TMPDAI") > 0
		TMPDAI->(DbCloseArea())
	Endif
	
Else
	cPed1 	 := "" 
	cPed2 	 := "" 
	cPed3 	 := ""	
	cTransp  := Space(6)
	cDesTra  := Space(20)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se o mapa deve estar preenchido de acordo com o tipo de movimentação escolhida³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if cTpMov $ 'Entrada/Saída' .and. cTpCli == 'Cliente'
		lRet := .F.
	EndIf
	
EndIf

Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função que valida os dados informados.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function TudoOk()
Local lRet	 := .T.
Local cErros := ""
Local aCols  := oGetCx:aCols

cErros := ""

If cTPCli == 'Cliente' .AND. !cTPMov $ 'Saida Ajuste'
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida se a carga informada existe.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	DbSelectArea("DAK")
	DAK->(DbSetOrder(1))
	If !DbSeek(xFilial("DAK") + cMapa) .or. Empty(cMapa)
		cErros += "Informe um mapa válido para essa operação!" +cEol
		lRet := .F.
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida código do motorista.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if !VerMot() 
		cErros += "Informe um código de motorista válido!" +cEol
		lRet := .F.
	EndIf
	                                              
Endif 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Validação para utilizar cliente Genérico quando estiver sendo feito ajuste.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if cTPMov == 'Saida Ajuste' .and. cTpCli != 'Generico'
 	cErros += "Para movimentações de Saida Ajuste, use o tipo de cliente Generico."+cEol
	lRet := .F.
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@
//³Valida se foi digitado alguma coisa no grid.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ@

if !U_ValidaTudo()
	cErros += "Verifique a digitação da planilha pois há informações inconsistentes." +cEol
	lRet := .F.
EndIf

if !lRet
	Aviso("Inconsistências Encontradas...",cErros,{"Ok"},2)
EndIf

Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função utilizada para atualizar o nome do motorista de acordo com o código informado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function VerMot()
Local lRet	:= .T.

//Validação para não posicionar no primeiro registro da tabela motorista mesmo que 
//código do motorista seja branco.
If Empty(AllTrim(cMoto))
	cDesMot := ""
Else	
	cDesMot := POSICIONE("DA4",1,xFilial("DA4")+cMoto,"DA4_NOME") 
EndIf

If Empty(AllTrim(cDesMot)) .and. !Empty(cMapa)
	lRet	:= .F.
Endif

dlgRefresh(oDlg)
Return(lRet)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função utilizada para gravar/atualizar as informações 
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function Grava()
Local nX     	:= 0
Local aCols  	:= oGetCx:aCols
Local aHeader := oGetCx:aHeader
Local nPosTp 	:= 0
Local nPosQtd := 0
Local nPosLoc := 0
Local lGrava  := .T.

nPosTp  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_TPCAIXA"})
nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_QUANT"})
nPosLoc := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_LOCAL"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definição do Tipo do Cliente³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case cTpCli == 'Cliente'
		cTpCli	:= "1"
	Case cTpCli	== 'Produtores'
		cTpCli	:= "2"
	Case cTpCli	== 'Filiais'
		cTpCli	:= "3"       
	Case cTpCli == 'Generico'
		cTpCli 	:= "4"
EndCase           

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Definição Tipos de Movimentos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Do Case
	Case cTPMov == 'Saída'
		cTpMov 	:= "1"
	Case cTPMov == 'Entrada'
		cTPMov	:= "2"
	Case cTPMov == 'Saida Ajuste'
		cTPMov	:= "3"		 
EndCase            

for nX := 1 to len(aCols)
	
	lGrava := .T.
	
	DbSelectArea("SZR")	
	SZR->(DbSetOrder(2))
	SZR->(DbGoTop())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Caso o registro existir, apenas faz update no registro existente. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if DbSeek(xFilial("SZR") + cMapa + cTpMov + aCols[nX, nPosTp]) .and. !Empty(cMapa)
		lGrava := .F.
	EndIf
  
  if DbSeek(xFilial("SZR") + cMapa + cTpMov + aCols[nX, nPosTp]) .and. aCols[nX, Len(aHeader)+1] == .T.
    RecLock("SZR",.F.)
    SZR->(DbDelete())
    SZR->(MsUnlock())                     
    
  ElseIf aCols[nX, Len(aHeader)+1] != .T.
  	RecLock("SZR", lGrava)
		SZR->ZR_FILIAL 	:= xFilial("SZR")  	
		SZR->ZR_MAPA	:= cMapa
	  	SZR->ZR_TPMOV	:= cTpMov
	  	SZR->ZR_TPCAD	:= cTpCli
	 	SZR->ZR_TPCAIXA	:= aCols[nX, nPosTp]
	 	SZR->ZR_QUANT	:= aCols[nX, nPosQtd]
	 	SZR->ZR_LOCAL   := aCols[nX, nPosLoc]
	 	SZR->ZR_DATA	:= Date()
	 	SZR->ZR_TRANSP	:= cTransp
	 	SZR->ZR_PEDIDOS	:= AllTrim(cPed1+cPed2+cPed3)
	 	SZR->ZR_USUARIO	:= Upper(SubStr(cUsuario, 07, 15))
	 	SZR->ZR_CONFER	:= Upper(cConfer)
	 	SZR->ZR_MOTORIS	:= cMoto
		MsUnLock("SZR")	
	EndIf
	
Next nX

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pela atualização do grid com os tipos de caixas já lançados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AtuaGrid(cTpMov,lAtua)
Local cSql 	:= ""
Local cTipo := ""
                 
Do Case
	Case cTpMov == 'Saída'
		cTipo := '1'
	Case cTpMov == 'Entrada'
		cTipo := '2'
	Case cTpMov == 'Saida Ajuste'
		cTipo := '3'
EndCase 

If cTipo == '2'
	cMoto := fCodMot() 
	VerMot()
EndIf

aFieldFill := {}

cSql := "SELECT ZR.ZR_FILIAL, ZR.ZR_MAPA, ZR.ZR_TPMOV, ZR.ZR_TPCAD, ZR.ZR_TPCAIXA, ZR.ZR_QUANT, "											+cEol 
cSql += "	      ZR.ZR_LOCAL, ZR.ZR_DATA, ZR.ZR_TRANSP, ZR.ZR_CONFER, ZR.ZR_MOTORIS FROM "+ RetSqlName("SZR")+ " ZR " 	+cEol
cSql += "WHERE ZR.D_E_L_E_T_ <> '*' "                                                             										+cEol
cSql += "  AND ZR.ZR_FILIAL = '"+xFilial("SZR")+"' "                                              										+cEol
cSql += "  AND ZR.ZR_MAPA 	= '"+cMapa+"' "                                                       										+cEol
cSql += "  AND ZR.ZR_MAPA   <> ' ' "                                                       									      		+cEol
cSql += "  AND ZR.ZR_TPMOV 	= '"+cTipo+"' "                                                       										+cEol

TCQUERY cSql NEW ALIAS "SZRTMP"

DbSelectArea("SZRTMP")
SZRTMP->(DbGoTop())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso a tabela temporária esteja vazia, faz o retorno da função.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if SZRTMP->(EOF())
	Aadd(aFieldFill, {' ',0,' ',.F.})
	if lAtua
		oGetCx:aCols := aClone(aFieldFill)
		oGetCx:ForceRefresh()
	EndIf

	if Empty(AllTrim(cMoto))
		cMoto 	:= Space(06)  
  EndIf
  	
	cConfer := Space(60)
	VerMot()                       

	SZRTMP->(DbCloseArea())
	Return .T.
	
EndIf   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Caso não for preenchido mapa, significa que é mov. de ajuste, então não deve ter motorista³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if Empty(cMapa)
	cMoto 	:= Space(06)
	cConfer := Space(60)
Else
	cMoto 	:= SZRTMP->ZR_MOTORIS
	cConfer := SZRTMP->ZR_CONFER 
EndIf                          

VerMot()

While !SZRTMP->(EOF())
	Aadd(aFieldFill, {ZR_TPCAIXA,;
						ZR_QUANT,;
						ZR_LOCAL,;
							.F.})
	SZRTMP->(DbSkip())
EndDo

aColsCx := aClone(aFieldFill)

if lAtua
	oGetCx:aCols := aClone(aFieldFill)
	oGetCx:ForceRefresh()
EndIf

SZRTMP->(DbCloseArea())

Return .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ¿
//³Função executada para validar conteúdo digitado na linha do grid³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Ù

User Function ValidaLinha()
Local lRet 	  := .T.
Local aCols   := oGetCx:aCols
Local aHeader := oGetCx:aHeader
Local nPosTp  := 0
Local nPosQtd := 0
Local cErros  := ""
Local nLin    := oGetCx:nAt
Local cUsos   := ""
                                 
cErros := ""

nPosTp  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_TPCAIXA"})
nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_QUANT"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Len(aCols) > 0
	if !aCols[nLin,nPosTp] $ "1/2/3/4/5/6"
		lRet := .F.
		cErros += "Selecione um tipo de Caixa!" +cEol
	EndIf
		
	If aCols[nLin,nPosQtd] < 0
		lRet := .F.
		cErros += "Quantidade de Caixas é inválida!" +cEol
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida para que seja incluído apenas uma linha para cada tipo de caixa.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	for i := 1 to Len(aCols)
		if aCols[i, nPosTp] $ cUsos .and. aCols[i, Len(aHeader)+1] == .F.
			lRet := .F.
			cErros += "Tipo de Caixa já utilizado em outra linha!" +cEol
		ElseIf aCols[i, Len(aHeader)+1] == .F.
			cUsos += aCols[i, nPosTp]+"/"	
		EndIf
	Next i
	                                             	
EndIf

if !lRet
	Aviso("Inconsistência na Linha!",cErros,{"Ok"},2)
EndIf

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´[¿
//³Função utilizada na validação gerado do grid.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´[Ù

User Function ValidaTudo()
Local lRet  	:= .T.
Local aCols 	:= oGetCx:aCols
Local aHeader := oGetCx:aHeader
Local nPosTp  := 0
Local nPosQtd := 0
Local cErros  := ""
Local nX      := 0 
Local cUsos   := ""

cErros := ""
                  
nPosTp  := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_TPCAIXA"})
nPosQtd := aScan(aHeader, {|x| AllTrim(x[2]) == "ZR_QUANT"})

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Len(aCols) > 0
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Valida para que seja incluído apenas uma linha para cada tipo de caixa.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	for i := 1 to Len(aCols)
		
		if !aCols[i,nPosTp] $ "1/2/3/4/5/6"
			lRet := .F.
		EndIf
			
		If aCols[i,nPosQtd] <= 0
			lRet := .F.
		EndIf        
		
		if aCols[i, nPosTp] $ cUsos .and. aCols[i, Len(aHeader)+1] == .F.
			lRet := .F.
		ElseIf aCols[i, Len(aHeader)+1] == .F.
			cUsos += aCols[i, nPosTp]+"/"	
		EndIf        
		
	Next i
	                                             	
EndIf

Return lRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Função responsável pela atualização do campo Mapa de acordo com Tp. Movto e Tp.Cli.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

Static Function AtuMapa()

Do Case
	Case cTpMov == 'Saída' .and. cTpCli == 'Cliente'
		lBlqMapa := .T.
		if Empty(cMapa)
			cMapa := Space(06)
		EndIf
		
	Case cTpMov == 'Saída' .and. cTpCli $ 'Produtores/Filiais/Generico'
		lBlqMapa := .F.
		cMapa    := Space(06)
		
	Case cTpMov == 'Entrada' .and. cTpCli == 'Cliente' 
		lBlqMapa := .T.
		if Empty(cMapa)
			cMapa := Space(06)
		EndIf          
	
	Case cTpMov == 'Entrada' .and. cTpCli $ 'Produtores/Filiais/Generico'
		lBlqMapa := .F.
		if Empty(cMapa)
			cMapa := Space(06)
		EndIf          
	
	Case cTpMov == 'Saida Ajuste'
		lBlqMapa := .F.
		cMapa    := Space(06)		   
		
EndCase

Return 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Função para retornar o código do motorista caso seja uma entrada³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ

Static Function fCodMot()
Local cRet := Space(06)

dbSelectArea("SZR")
SZR->(dbSetOrder(1))

If SZR->(dbSeek(xFilial("SZR")+cMapa))
	cRet := SZR->ZR_MOTORIS
EndIf

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Manutencao dos motoristas usados no controle de caixas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function ManSZQ()
	AxCadastro("SZQ")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
	
Return