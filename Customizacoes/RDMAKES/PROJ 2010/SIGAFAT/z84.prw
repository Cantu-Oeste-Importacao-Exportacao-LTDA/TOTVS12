#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


user function z84()

Private cCadastro := "Tabela de Pre็o | Oracle" //Variavel padrใo para o tํtulo do mBrowse
Private aRotina	:= MENUDEF() //Variแvel padrใo para as op็๕es do mBrowse
    
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z84")
Z84->(dbsetOrder(1))  // FILIAL + COD
Z84->(dbGoTop())

//Os parametros sใo padr๕es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z84") 

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMENUDEF     บAutor  ณGustavo          บ Data ณ 16/02/2015   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Op็๕es que irใo compor o menu na tela.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Analise BI                                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MENUDEF()
Local aOpcoes := {}

AADD(aOpcoes, {"Pesquisar"	, "AxPesqui"   		, 0, 1})
AADD(aOpcoes, {"Visualizar"	, "U_Z84VIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_Z84INC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_Z84ALT()"		, 0, 4})
AADD(aOpcoes, {"Excluir"	, "AxDeleta" 	 	, 0, 5})

Return aOpcoes  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMONTAHEADER     บAutor  ณGustavo      บ Data ณ 04/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para efetuar เ composi็ใo do Array com os  บฑฑ 
ฑฑบ          ณdetalhes de campos para o componente MsNewGetDados          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Treinamento ADVPL                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MONTAHEADER(cTabela, cNoCampos)

Local aCampos := {}

Default cTabela 	:= ""
Default cNoCampos	:= ""

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbGoTop())
//Verifica no SX3 registros com o conte๚do cTabela pelo indice 1.
If SX3->(dbSeek(cTabela))
	//Enquanto nใo for fim de arquivo e o arquivo for igual a tabela (SZ3).
	While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTabela
		//Se o campo for usado e que o nํvel do usuแrio for maior que o nํvel do campo e nใo for os campos
		//passados no cNoCampos (que sใo os campos que estใo no cabe็alho da tela).
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(ALLTRIM(SX3->X3_CAMPO) $ cNoCampos)
			//Adiciona os campos conforme documenta็ใo do aHeader
			AADD(aCampos, {Trim(X3Titulo()),;
							SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							SX3->X3_TAMANHO,;
							SX3->X3_DECIMAL,;
							SX3->X3_VALID,;
							SX3->X3_USADO,;
							SX3->X3_TIPO,;
							SX3->X3_F3,;
							SX3->X3_CONTEXT,;
							SX3->X3_CBOX,;
							SX3->X3_RELACAO,;
							SX3->X3_WHEN,;
							SX3->X3_VISUAL,;
							SX3->X3_VLDUSER})
		EndIF
		SX3->(dbSkip())	
	EndDo
EndIf
Return aCampos 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCAD04INC     บAutor  ณGustavo         บ Data ณ 04/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para realizar a inclusใo de interface modelo 2.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Treinamento ADVPL                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Parametros passados pelo mBrowse por padrใo
//Tabela que esta sendo manipulada, r_e_c_n_o, op็ใo do browse.
User Function Z84INC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que serแ o controle de o usuแrio confirmou ou nใo a inclusใo
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_Z84LOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z84"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z84_CODIGO/Z84_DESCRI/Z84_DTINI/Z84_HORAIN/Z84_DTFIM/Z84_HORAFI/Z84_ATIVO/Z84_DESCLI/Z84_RENTAB/Z84_PRCCUS/Z84_DESCON/Z84_ACRESC/Z84_TIPO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Space(3)			//-- C๓digo tabela
Private cDesc		:= Space(30)		//-- Descri็ใo tabela
Private dDataIni	:= Date()			//-- Data inicial
Private cHoraIni	:= "  :  "			//-- Hora Inicial
Private dDataFim	:= Date()			//-- Data Final	
Private cHoraFim	:= "  :  "			//-- Hora Final
Private cAtivo		:= Space(1)			//-- Tabela Ativa Sim ou Nใo
Private	cDescont	:= Space(1)			//-- Usa desconto Lista
Private cTipo 		:= Space(1)			//-- Tipo
Private nRent		:= 0				//-- Rentabilidade %
Private nPrcCust	:= 0				//-- Pre็o Custo %
Private nDescont	:= 0				//-- Desconto %
Private nAcresc		:= 0				//-- Acrescimo %
Private aItens		:= {"Sim","Nใo"}	//-- Itens para compor Sim e nใo combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .F.
Private INCLUI		:= .T.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// Montagem dos parโmetros para cria็ใo da tela de exibi็ใo com redimensionamento automatico     				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Declara็ใo da interface e demais componentes da interface		ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Declara็ใo componentes TSAY/TGET para os campos do cabe็alho da interface		ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",/*{||U_MORTVCB()}*/,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C๓digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri็ใo",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre็o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	// Declara็ใo do MSNEWGETDADOS referente ao grid de itens da interface			ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa m้todo de apresesnta็ใo de tela criando เ barra de bot๕es				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Caso confirmou os dados, grava a inclusใo										ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
If nOpcao == 1
   	Z84GRV() 
EndIf

Return   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCAD04VIS     บAutor  ณGustavo         บ Data ณ 04/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para realizar a altera็ใo de interface modelo 2.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Treinamento ADVPL                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Parametros passados pelo mBrowse por padrใo
//Tabela que esta sendo manipulada, r_e_c_n_o, op็ใo do browse.
User Function Z84VIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que serแ o controle de o usuแrio confirmou ou nใo a inclusใo
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_Z84LOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z84"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z84_CODIGO/Z84_DESCRI/Z84_DTINI/Z84_HORAIN/Z84_DTFIM/Z84_HORAFI/Z84_ATIVO/Z84_DESCLI/Z84_RENTAB/Z84_PRCCUS/Z84_DESCON/Z84_ACRESC/Z84_TIPO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Z84->Z84_CODIGO	//-- C๓digo tabela
Private cDesc		:= Z84->Z84_DESCRI		//-- Descri็ใo tabela
Private dDataIni	:= Z84->Z84_DTINI		//-- Data inicial
Private cHoraIni	:= Z84->Z84_HORAIN		//-- Hora Inicial
Private dDataFim	:= Z84->Z84_DTFIM		//-- Data Final	
Private cHoraFim	:= Z84->Z84_HORAFI 		//-- Hora Final
Private cAtivo		:= Z84->Z84_ATIVO		//-- Tabela Ativa Sim ou Nใo
Private	cDescont	:= Z84->Z84_DESCLI		//-- Usa desconto Lista
Private cTipo 		:= Z84->Z84_TIPO			//-- Tipo
Private nRent		:= Z84->Z84_RENTAB		//-- Rentabilidade %
Private nPrcCust	:= Z84->Z84_PRCCUS		//-- Pre็o Custo %
Private nDescont	:= Z84->Z84_DESCON 		//-- Desconto %
Private nAcresc		:= Z84->Z84_ACRESC		//-- Acrescimo %
Private aItens		:= {"Sim","Nใo"}	//-- Itens para compor Sim e nใo combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa regras para carregar as informa็๕es do grid da interface				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
dbSelectArea("Z84")
Z84->(dbSetOrder(3)) // FILIAL + codigo+ nome
Z84->(dbGoTop())
If Z84->(dbSeek(xFilial("Z84") + cCod))
	While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
	
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Adiciona item em branco no aCols para vincular as informa็๕es do registro posicionado no browse				ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ84 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z84->(FieldGet(nPosZ84))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Atribui .F. para o item do aCols | NรO DELETADO								ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z84->(dbSkip())
	End
EndIf

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// Montagem dos parโmetros para cria็ใo da tela de exibi็ใo com redimensionamento automatico     				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Declara็ใo da interface e demais componentes da interface		ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Declara็ใo componentes TSAY/TGET para os campos do cabe็alho da interface		ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C๓digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri็ใo",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre็o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	// Declara็ใo do MSNEWGETDADOS referente ao grid de itens da interface			ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa m้todo de apresesnta็ใo de tela criando เ barra de bot๕es				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCAD04ALT     บAutor  ณGustavo         บ Data ณ 04/06/2014   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para realizar a altera็ใo de interface modelo 2.    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Treinamento ADVPL                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
//Parametros passados pelo mBrowse por padrใo
//Tabela que esta sendo manipulada, r_e_c_n_o, op็ใo do browse.
User Function Z84ALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que serแ o controle de o usuแrio confirmou ou nใo a inclusใo
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_Z84LOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z84"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z84_CODIGO/Z84_DESCRI/Z84_DTINI/Z84_HORAIN/Z84_DTFIM/Z84_HORAFI/Z84_ATIVO/Z84_DESCLI/Z84_RENTAB/Z84_PRCCUS/Z84_DESCON/Z84_ACRESC/Z84_TIPO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Z84->Z84_CODIGO		//-- C๓digo tabela
Private cDesc		:= Z84->Z84_DESCRI		//-- Descri็ใo tabela
Private dDataIni	:= Z84->Z84_DTINI		//-- Data inicial
Private cHoraIni	:= Z84->Z84_HORAIN		//-- Hora Inicial
Private dDataFim	:= Z84->Z84_DTFIM		//-- Data Final	
Private cHoraFim	:= Z84->Z84_HORAFI 		//-- Hora Final
Private cAtivo		:= Z84->Z84_ATIVO		//-- Tabela Ativa Sim ou Nใo
Private	cDescont	:= Z84->Z84_DESCLI		//-- Usa desconto Lista
Private cTipo 		:= Z84->Z84_TIPO		//-- Tipo
Private nRent		:= Z84->Z84_RENTAB		//-- Rentabilidade %
Private nPrcCust	:= Z84->Z84_PRCCUS		//-- Pre็o Custo %
Private nDescont	:= Z84->Z84_DESCON 		//-- Desconto %
Private nAcresc		:= Z84->Z84_ACRESC		//-- Acrescimo %
Private aItens		:= {"Sim","Nใo"}		//-- Itens para compor Sim e nใo combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa regras para carregar as informa็๕es do grid da interface				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
dbSelectArea("Z84")
Z84->(dbSetOrder(3)) // FILIAL + CODIGO
Z84->(dbGoTop())
If Z84->(dbSeek(xFilial("Z84") + cCod))
	While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
	
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Adiciona item em branco no aCols para vincular as informa็๕es do registro posicionado no browse				ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ84 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z84->(FieldGet(nPosZ84))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Atribui .F. para o item do aCols | NรO DELETADO								ณ
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z84->(dbSkip())
	End
EndIf

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// Montagem dos parโmetros para cria็ใo da tela de exibi็ใo com redimensionamento automatico     				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Declara็ใo da interface e demais componentes da interface		ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Declara็ใo componentes TSAY/TGET para os campos do cabe็alho da interface		ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCod",,.T.,,.T.,,,"C๓digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri็ใo",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre็o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	// Declara็ใo do MSNEWGETDADOS referente ao grid de itens da interface			ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa m้todo de apresesnta็ใo de tela criando เ barra de bot๕es				ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Caso confirmou os dados, grava a inclusใo										ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
If nOpcao == 1
   	Z84GRV() 
EndIf

Return  



 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณZ84ATCPO   บAutor  ณGustavo Lattmann   บ Data ณ 16/06/2017   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณFun็ใo responsแvel por atualizar os campos do aCols          บฑฑ
ฑฑบ         ณ											                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ AP                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z84ATCPO()

Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRODUT"})
Local nAtuPrc	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_ATUPRC"})
Local nPreco	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRECO"}) 
Local nCuProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_CUPROD"}) 
Local nReProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_REPROD"}) 
Local nDeProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_DEPROD"}) 
Local nAcProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_ACPROD"}) 
//Local nIntEst	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_INTEST"}) 
//Local nEstoq	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_ESTOQ"})
Local nStatIn	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_STATIN"})  

//-- Indiferente do campo que seja atualizado muda o status da integra็ใo
aCols[n][nStatIn] := 0

//-- Campo do aCols que esta posicionado 
If __READVAR ==  "M->Z84_PRECO"  
	If aCols[n][nAtuPrc] == "S"
		aCols[n][nReProd] := Round(M->Z84_PRECO * ((100 - nRent) / 100),2)
		aCols[n][nCuProd] := Round(M->Z84_PRECO * ((100 - nPrcCust) / 100),2)		
		aCols[n][nDeProd] := nDescont
		aCols[n][nAcProd] := nAcresc
	EndIf
	/*
	If aCols[n][nIntEst] == "S"
		//Busca estoque da SB2
		aCols[n][nEstoq] := U_Z84EST(xFilial("SB2"),aCols[n][nProdut])
	EndIf    	
    */
EndIf

//-- Caso seja alterado o produto limpa os campos
If __READVAR ==  "M->Z84_PRODUT"    
	aCols[n][nReProd] := 0
	aCols[n][nCuProd] := 0
	aCols[n][nDeProd] := 0
	aCols[n][nAcProd] := 0
	aCols[n][nPreco] := 0
EndIf

//-- Caso seja alterado para nใo atualizar o pre็o limpa demais campos
If __READVAR ==  "M->Z84_ATUPRC"    
	If M->Z84_ATUPRC == "N"
		aCols[n][nReProd] := 0
		aCols[n][nCuProd] := 0
		aCols[n][nDeProd] := 0
		aCols[n][nAcProd] := 0
	EndIf    	

EndIf

/*
//-- Ajusta o estoque de acordo com o campo de integra็ใo
If __READVAR ==  "M->Z84_INTEST"    
	If M->Z84_INTEST == "S"
		//Busca estoque da SB2
		aCols[n][nEstoq] := U_Z84EST(xFilial("SB2"),aCols[n][nProdut])
	EndIf
	If M->Z84_INTEST == "N"
		aCols[n][nEstoq] := 0
	EndIf     	

EndIf
*/

oBrw1:Refresh()

Return .T.


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณZ84LOK    บAutor  ณGustavo Lattmann   บ Data ณ 16/06/2017    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณFun็ใo responsแvel pela valida็ใo das linhas no MsNewGetDadosบฑฑ
ฑฑบ         ณaltera็ใo e exclusใo de dados na base.                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ AP                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z84LOK()

Local lRet		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi็ใo atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe็alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRODUT"})
Local nPreco	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRECO"}) 
Local nCuProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_CUPROD"}) 
Local nReProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_REPROD"})


For nI := 1 To Len(aCols)
	If nI != nPos .And. aCols[nI][nProdut] == aCols[nPos][nProdut] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten็ใo",{"O c๓digo do produto informado jแ esta vinculado na linha " + STRZERO(nI,2)}, 5, {"Nใo ้ possํvel informar o mesmo produto mais de uma vez na mesma tabela."}, 5)
		Return .F.
	EndIf 
	If aCols[nI][nPreco] < aCols[nI][nReProd] .or. aCols[nI][nPreco] < aCols[nI][nCuProd]
		ShowHelpDlg("Aten็ใo",{"O pre็o de venda nใo pode ser menor que a rentabilidade ou o custo."}, 5, {"Ajuste o produto " + aCols[nI][nProdut]}, 5)
		Return .F.
	EndIf
	If aCols[nI][nReProd] < aCols[nI][nCuProd]
		ShowHelpDlg("Aten็ใo",{"O custo nใo pode ser maior que a rentabilidade."}, 5, {"Ajuste o produto " + aCols[nI][nProdut]}, 5)
		Return .F.
	EndIf
Next nI

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณZ84TOK    บAutor  ณGustavo Lattmann   บ Data ณ 19/06/2017    บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณFun็ใo responsแvel pela valida็ใo na confirma็ใo.			  บฑฑ
ฑฑบ         ณ										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ 	                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function Z84TOK()

Local lRet  := .T.
Local lHora	:= .T.


//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Verifica se existe alguma tabela com o mesmo c๓digo jแ cadastrada.   	ณ
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
If INCLUI
	dbSelectArea("Z84")
	Z84->(dbSetOrder(1))
	Z84->(dbGoTop())
	If Z84->(dbSeek(xFilial("Z84") + cCod))
		ShowHelpDlg("Aten็ใo", {"Jแ existe uma tabela cadastrada com esse c๓digo."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
		lRet := .F.			
	EndIf
EndIf

If dDataIni > dDataFim
	ShowHelpDlg("Aten็ใo", {"Data inicial nใo pode ser maior que data final."}, 5, {"Favor ajustar data inicial e final."}, 5)
	lRet := .F.
EndIf

lHora := VldHora(cHoraIni)

If !lHora
	ShowHelpDlg("Aten็ใo", {"Hora inicial invแlida."}, 5, {"Favor ajustar hora inicial para um valor entre 00:00 e 23:59."}, 5)
	lRet := .F.
EndIf

lHora := VldHora(cHoraFim)

If !lHora 
	ShowHelpDlg("Aten็ใo", {"Hora final invแlida."}, 5, {"Favor ajustar hora final para um valor entre 00:00 e 23:59."}, 5)
	lRet := .F.
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณVldHora    บAutor  ณGustavo Lattmann   บ Data ณ 19/06/2017   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.    ณVแlida se a hora informada esta no padrใo 24h.				  บฑฑ
ฑฑบ         ณ										                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso      ณ 	                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldHora(cHora)

If Val(Subs(cHora, 1, 2)) < 0 .Or. Val(Subs(cHora, 1, 2)) > 23 .Or.; 
     Val(Subs(cHora, 4, 2)) < 0 .Or. Val(Subs(cHora, 1, 2)) > 59 
     Return .F. 
EndIf 

Return .T.

 /*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณZ84GRV    บAutor  ณGustavo Lattmann   บ Data ณ 16/06/2017   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel pela execu็ใo de regras de inclusใo,     บฑฑ
ฑฑบ          ณaltera็ใo e exclusใo de dados na base.                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Z84GRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

//Ajusta o Tipo para gravar s๓ F/I/V
cTipo := Substr(cTipo,1,1)

Do Case
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Executa regras para a inclusใo do cadastro									ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	Case INCLUI
		
		//Controle de transa็ใo
		BEGIN TRANSACTION
			dbSelectArea("Z84")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z84", .T.)
						//Passa campo a campo do aHeader para verificar se ele ้ real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY ้ diferente de virtual, no caso se o campo ้ real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ84 := FieldPos(aHeader[nY][2]))
									Z84->(FieldPut(nPosZ84, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						Z84->Z84_FILIAL	:= xFilial("Z84")
						Z84->Z84_CODIGO	:= cCod
						Z84->Z84_DESCRI := cDesc
						Z84->Z84_DTINI	:= dDataIni
						Z84->Z84_HORAIN := cHoraIni
						Z84->Z84_DTFIM	:= dDataFim
						Z84->Z84_HORAFI := cHoraFim
						Z84->Z84_ATIVO	:= cAtivo							
						Z84->Z84_TIPO 	:= cTipo
						Z84->Z84_DESCLI	:= cDescont
						Z84->Z84_RENTAB := nRent
						Z84->Z84_PRCCUS := nPrcCust
						Z84->Z84_DESCON := nDescont
						Z84->Z84_ACRESC := nAcresc
						
					Z84->(MSUNLOCK())
				EndIf
			Next nI	
		
		END TRANSACTION
	
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Executa regras para a altera็ใo do cadastro									ณ
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ		
	Case ALTERA
	
		BEGIN TRANSACTION
		
			//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			//Realiza a exclusใo de todos os registros existentes atualmente				ณ
			//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			dbSelectArea("Z84")
			Z84->(dbSetOrder(1)) // FILIAL + DIA
			Z84->(dbGoTop())
			If Z84->(dbSeek(xFilial("Z84") + cCod))
				While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
							
				//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
				//Efetua เ exclusใo do registro posicionado										ณ
				//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
				RecLock("Z84", .F.)
					Z84->(DBDELETE())
				Z84->(MSUNLOCK())
			
				Z84->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("Z84")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z84", .T.)
						//Passa campo a campo do aHeader para verificar se ele ้ real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY ้ diferente de virtual, no caso se o campo ้ real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ84 := FieldPos(aHeader[nY][2]))
									Z84->(FieldPut(nPosZ84, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						Z84->Z84_FILIAL	:= xFilial("Z84")
						Z84->Z84_CODIGO	:= cCod
						Z84->Z84_DESCRI := cDesc
						Z84->Z84_DTINI	:= dDataIni
						Z84->Z84_HORAIN := cHoraIni
						Z84->Z84_DTFIM	:= dDataFim
						Z84->Z84_HORAFI := cHoraFim
						Z84->Z84_ATIVO	:= cAtivo							
						Z84->Z84_TIPO 	:= cTipo
						Z84->Z84_DESCLI	:= cDescont
						Z84->Z84_RENTAB := nRent
						Z84->Z84_PRCCUS := nPrcCust
						Z84->Z84_DESCON := nDescont
						Z84->Z84_ACRESC := nAcresc
					Z84->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase

Return 