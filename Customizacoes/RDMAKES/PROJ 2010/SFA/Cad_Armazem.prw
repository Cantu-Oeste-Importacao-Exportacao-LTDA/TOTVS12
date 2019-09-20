#INCLUDE "rwmake.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ CADARM              ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Cadastro de armazens        					 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CADARM()

Private cCadastro := "Cadastro de Mensagens"
Private aCores := {}

Private aRotina := { {"Pesquisar"  ,"AxPesqui" ,0 ,1} ,;
             		     {"Visualizar" ,"AxVisual" ,0 ,2} ,;
                     {"Incluir"    ,"u_fInclui" ,0 ,3} ,;
                     {"Alterar"    ,"u_fAltera" ,0 ,4} ,;
                     {"Excluir"    ,"AxDeleta" ,0 ,5} }

Private aCampos	:=	{	{"Codigo"  , "ZA_CODARM" , "@!"} ,;
						{"Vendedor", "ZA_SENHA"  ,     }	}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SZA")
dbSetOrder(1)

mBrowse( 6,1,22,75,"SZA",aCampos,,,,,)
Return

user function fAltera()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
	nOpca := AxAltera( "SZA",SZA->(Recno()),4,,,,,"U_TudoOkAlt()")	
return .T.

user function fInclui()
				 //AxInclui( cAlias,          nReg, nOpc, aAcho, cFunc, aCpos,         cTudoOk, lF3, cTransact, aButtons, aParam, aAuto, lVirtual, lMaximized, cTela, lPanelFin, oFather, aDim, uArea)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
	nOpca := AxInclui(  "SZA",SZA->(Recno()),    3,      ,      ,      , "U_TudoOkInc()",.F.)
return .T.

static function enviaEmail()
	Local lExecuta := .T.

	cProcID    := iif(altera, "Alteração de Armazem ", "Inclusão de novo Armazem ")
	cAssunto   := iif(altera, "Aviso: Armazem alterado ", "Aviso: novo Armazem ")
	cInclualte := iif(altera, "ALTERACAO DE ARMAZEM ", "INCLUSAO NOVO ARMAZEM")
	cProcess   := OemToAnsi("000001") // Numero do Processo
	cStatus    := OemToAnsi("001000")
	
	oProcess := TWFProcess():New(cProcess,OemToAnsi(cProcID))
	oProcess:NewTask(cStatus,"\workflow\cantu\wfinc_arm.html")
	oProcess:cSubject := OemToAnsi(cAssunto + M->ZA_CODARM )
	
	oProcess:cTo := SuperGetMv('MV_X_ARMNO',,"") //parametro criado no cfg -> atualizaçao-> cadastro ->paramentros
	oHtml:= oProcess:oHtml

	oHtml:ValByName( "INCLUALTE", cInclualte )
	oHtml:ValByName( "CODIGO",    CEMPANT )
	oHtml:ValByName( "EMPRESA",   SM0->M0_NOMECOM )
	oHtml:ValByName( "FILIAL",    M->ZA_FILIAL )
	oHtml:ValByName( "CODARM",    M->ZA_CODARM )
	oHtml:ValByName( "SIM3G",     M->ZA_SIM3G )
	oHtml:ValByName( "SEGMENT",   M->ZA_SEGMENT )
	oHtml:ValByName( "TEL",       M->ZA_TEL )
	oHtml:ValByName( "USUARIO",   cUsername)
	
	if altera
		oHtml:ValByName( "ALTERACOES","Alterações: " + cAlteracao)
	endIf
	
	oProcess:Start()
return

User function TudoOKAlt()       
	//variável pública que contém uma tabela em HTML com as alterações
	public cAlteracao := u_TbAlteraWF("SZA")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())	

	enviaEmail()
Return .T.

User function TudoOkInc()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Chama função para monitor uso de fontes customizados³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	U_USORWMAKE(ProcName(),FunName())
		
	enviaEmail()
Return .T.

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ XEXPHZA             ³Autor ³ Microsiga    ³ Data ³28/12/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Exportacao do cadastro de armazens			 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function XEXPHZA()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("SZA")
dbSetOrder(01)
dbSeek(xFilial("SZA"))
While SZA->(!Eof()) .And. SZA->ZA_FILIAL == xFilial("SZA")

	dbSelectArea("HZA")
	dbSetOrder(1)
	If !dbSeek(xFilial("HZA") + SZA->ZA_CODARM + AllTrim(SZA->ZA_GRUPO))
		RecLock("HZA",.T.)
	Else
		RecLock("HZA",.F.)
	EndIf
	HZA->HZA_FILIAL	:= xFilial("HZA")
	HZA->HZA_ID		:= ""
	HZA->HZA_CODARM	:= SZA->ZA_CODARM
	HZA->HZA_SENHA	:= SZA->ZA_SENHA
	HZA->HZA_TEL	:= SZA->ZA_TEL
	HZA->HZA_SALDO	:= 0
	HZA->HZA_INTR	:= "I"
	HZA->HZA_SENHAP := SZA->ZA_SENHAPD
	HZA->HZA_MAXDES := SZA->ZA_MAXDESC
	HZA->HZA_GRUPO  := SZA->ZA_GRUPO
	// seta o valor somente se o campo existir
	if (HZA->(FieldPos("HZA_DESCRE")) > 0)
	  HZA->HZA_DESCRE := SZA->ZA_DESCREV
	EndIf
	// seta o valor somente se o campo existir
	if (HZA->(FieldPos("HZA_DESSYN")) > 0)
	  HZA->HZA_DESSYN := SZA->ZA_DESCSYN
	EndIf
	
	HZA->HZA_VER	:= HHNextVer("","HZA")
	HZA->(MsUnlock())
	
	SZA->(dbSkip())
	
EndDo

HHUpdCtr("","HZA")	

Return NIL
