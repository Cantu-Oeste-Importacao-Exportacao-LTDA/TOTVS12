#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


user function z84()

Private cCadastro := "Tabela de Pre�o | Oracle" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z84")
Z84->(dbsetOrder(1))  // FILIAL + COD
Z84->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z84") 

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MENUDEF     �Autor  �Gustavo          � Data � 16/02/2015   ���
�������������������������������������������������������������������������͹��
���Desc.     � Op��es que ir�o compor o menu na tela.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Analise BI                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MONTAHEADER     �Autor  �Gustavo      � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada para efetuar � composi��o do Array com os  ��� 
���          �detalhes de campos para o componente MsNewGetDados          ���
�������������������������������������������������������������������������͹��
���Uso       � Treinamento ADVPL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MONTAHEADER(cTabela, cNoCampos)

Local aCampos := {}

Default cTabela 	:= ""
Default cNoCampos	:= ""

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbGoTop())
//Verifica no SX3 registros com o conte�do cTabela pelo indice 1.
If SX3->(dbSeek(cTabela))
	//Enquanto n�o for fim de arquivo e o arquivo for igual a tabela (SZ3).
	While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTabela
		//Se o campo for usado e que o n�vel do usu�rio for maior que o n�vel do campo e n�o for os campos
		//passados no cNoCampos (que s�o os campos que est�o no cabe�alho da tela).
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(ALLTRIM(SX3->X3_CAMPO) $ cNoCampos)
			//Adiciona os campos conforme documenta��o do aHeader
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04INC     �Autor  �Gustavo         � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para realizar a inclus�o de interface modelo 2.     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Treinamento ADVPL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Parametros passados pelo mBrowse por padr�o
//Tabela que esta sendo manipulada, r_e_c_n_o, op��o do browse.
User Function Z84INC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
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
Private cCod		:= Space(3)			//-- C�digo tabela
Private cDesc		:= Space(30)		//-- Descri��o tabela
Private dDataIni	:= Date()			//-- Data inicial
Private cHoraIni	:= "  :  "			//-- Hora Inicial
Private dDataFim	:= Date()			//-- Data Final	
Private cHoraFim	:= "  :  "			//-- Hora Final
Private cAtivo		:= Space(1)			//-- Tabela Ativa Sim ou N�o
Private	cDescont	:= Space(1)			//-- Usa desconto Lista
Private cTipo 		:= Space(1)			//-- Tipo
Private nRent		:= 0				//-- Rentabilidade %
Private nPrcCust	:= 0				//-- Pre�o Custo %
Private nDescont	:= 0				//-- Desconto %
Private nAcresc		:= 0				//-- Acrescimo %
Private aItens		:= {"Sim","N�o"}	//-- Itens para compor Sim e n�o combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .F.
Private INCLUI		:= .T.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//���������������������������������������������������������������������������������������������������������������
// Montagem dos par�metros para cria��o da tela de exibi��o com redimensionamento automatico     				�
//���������������������������������������������������������������������������������������������������������������
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//���������������������������������������������������������������
//Declara��o da interface e demais componentes da interface		�
//���������������������������������������������������������������
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//�������������������������������������������������������������������������������
	//Declara��o componentes TSAY/TGET para os campos do cabe�alho da interface		�
	//�������������������������������������������������������������������������������
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",/*{||U_MORTVCB()}*/,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C�digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri��o",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre�o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	Z84GRV() 
EndIf

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04VIS     �Autor  �Gustavo         � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para realizar a altera��o de interface modelo 2.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Treinamento ADVPL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Parametros passados pelo mBrowse por padr�o
//Tabela que esta sendo manipulada, r_e_c_n_o, op��o do browse.
User Function Z84VIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
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
Private cCod		:= Z84->Z84_CODIGO	//-- C�digo tabela
Private cDesc		:= Z84->Z84_DESCRI		//-- Descri��o tabela
Private dDataIni	:= Z84->Z84_DTINI		//-- Data inicial
Private cHoraIni	:= Z84->Z84_HORAIN		//-- Hora Inicial
Private dDataFim	:= Z84->Z84_DTFIM		//-- Data Final	
Private cHoraFim	:= Z84->Z84_HORAFI 		//-- Hora Final
Private cAtivo		:= Z84->Z84_ATIVO		//-- Tabela Ativa Sim ou N�o
Private	cDescont	:= Z84->Z84_DESCLI		//-- Usa desconto Lista
Private cTipo 		:= Z84->Z84_TIPO			//-- Tipo
Private nRent		:= Z84->Z84_RENTAB		//-- Rentabilidade %
Private nPrcCust	:= Z84->Z84_PRCCUS		//-- Pre�o Custo %
Private nDescont	:= Z84->Z84_DESCON 		//-- Desconto %
Private nAcresc		:= Z84->Z84_ACRESC		//-- Acrescimo %
Private aItens		:= {"Sim","N�o"}	//-- Itens para compor Sim e n�o combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z84")
Z84->(dbSetOrder(3)) // FILIAL + codigo+ nome
Z84->(dbGoTop())
If Z84->(dbSeek(xFilial("Z84") + cCod))
	While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ84 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z84->(FieldGet(nPosZ84))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z84->(dbSkip())
	End
EndIf

//���������������������������������������������������������������������������������������������������������������
// Montagem dos par�metros para cria��o da tela de exibi��o com redimensionamento automatico     				�
//���������������������������������������������������������������������������������������������������������������
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//���������������������������������������������������������������
//Declara��o da interface e demais componentes da interface		�
//���������������������������������������������������������������
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//�������������������������������������������������������������������������������
	//Declara��o componentes TSAY/TGET para os campos do cabe�alho da interface		�
	//�������������������������������������������������������������������������������
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C�digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri��o",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre�o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
		oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

Return  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04ALT     �Autor  �Gustavo         � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para realizar a altera��o de interface modelo 2.    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Treinamento ADVPL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Parametros passados pelo mBrowse por padr�o
//Tabela que esta sendo manipulada, r_e_c_n_o, op��o do browse.
User Function Z84ALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
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
Private cCod		:= Z84->Z84_CODIGO		//-- C�digo tabela
Private cDesc		:= Z84->Z84_DESCRI		//-- Descri��o tabela
Private dDataIni	:= Z84->Z84_DTINI		//-- Data inicial
Private cHoraIni	:= Z84->Z84_HORAIN		//-- Hora Inicial
Private dDataFim	:= Z84->Z84_DTFIM		//-- Data Final	
Private cHoraFim	:= Z84->Z84_HORAFI 		//-- Hora Final
Private cAtivo		:= Z84->Z84_ATIVO		//-- Tabela Ativa Sim ou N�o
Private	cDescont	:= Z84->Z84_DESCLI		//-- Usa desconto Lista
Private cTipo 		:= Z84->Z84_TIPO		//-- Tipo
Private nRent		:= Z84->Z84_RENTAB		//-- Rentabilidade %
Private nPrcCust	:= Z84->Z84_PRCCUS		//-- Pre�o Custo %
Private nDescont	:= Z84->Z84_DESCON 		//-- Desconto %
Private nAcresc		:= Z84->Z84_ACRESC		//-- Acrescimo %
Private aItens		:= {"Sim","N�o"}		//-- Itens para compor Sim e n�o combos
Private aTipos		:= {"Flv","Industrializados","Vinhos"}

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z84")
Z84->(dbSetOrder(3)) // FILIAL + CODIGO
Z84->(dbGoTop())
If Z84->(dbSeek(xFilial("Z84") + cCod))
	While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ84 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z84->(FieldGet(nPosZ84))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z84->(dbSkip())
	End
EndIf

//���������������������������������������������������������������������������������������������������������������
// Montagem dos par�metros para cria��o da tela de exibi��o com redimensionamento automatico     				�
//���������������������������������������������������������������������������������������������������������������
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//���������������������������������������������������������������
//Declara��o da interface e demais componentes da interface		�
//���������������������������������������������������������������
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//�������������������������������������������������������������������������������
	//Declara��o componentes TSAY/TGET para os campos do cabe�alho da interface		�
	//�������������������������������������������������������������������������������
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCod",,.T.,,.T.,,,"C�digo",1)
	oGet2 := TGet():New(035,030,{|u|if(PCount()>0, cDesc:=u, cDesc)},oDlg,090,010,"@!",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDesc",,.T.,,.T.,,,"Descri��o",1)
	oGet3 := TGet():New(035,130,{|u|if(PCount()>0, dDataIni:=u, dDataIni)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataIni",,.T.,,.T.,,,"Data Inicial",1)
	oGet4 := TGet():New(035,180,{|u|if(PCount()>0, cHoraIni:=u, cHoraIni)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraIni",,.T.,,.T.,,,"Hora Inicial",1)
	oGet5 := TGet():New(035,220,{|u|if(PCount()>0, dDataFim:=u, dDataFim)},oDlg,030,010,"@D",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDataFim",,.T.,,.T.,,,"Data Final",1)
	oGet6 := TGet():New(035,270,{|u|if(PCount()>0, cHoraFim:=u, cHoraFim)},oDlg,020,010,"99:99",{||U_Z84TOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cHoraFim",,.T.,,.T.,,,"Hora Final",1)
	
	cAtivo := aItens[1]
	cDescont := aItens[1]
	
	oCombo1 := TComboBox():New(035,300,{|u|if(PCount()>0,cAtivo:=u,cAtivo)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cAtivo',"Ativo?",1)
	oCombo2 := TComboBox():New(035,340,{|u|if(PCount()>0,cDescont:=u,cDescont)},aItens,030,13,oDlg,,,,,,.T.,,,,,,,,,'cDescont',"Desconto Lista?",1)

	oGet7 := TGet():New(035,400,{|u|if(PCount()>0, nRent:=u, nRent)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nRent",,.T.,,.T.,,,"Rentabilidade %",1)
	oGet8 := TGet():New(035,450,{|u|if(PCount()>0, nPrcCust:=u, nPrcCust)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nPrcCust",,.T.,,.T.,,,"Pre�o Custo %",1)			
	oGet9 := TGet():New(035,490,{|u|if(PCount()>0, nDescont:=u, nDescont)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nDescont",,.T.,,.T.,,,"Desconto %",1)
	oGet10 := TGet():New(035,530,{|u|if(PCount()>0, nAcresc:=u, nAcresc)},oDlg,040,010,"@E 999.9",{||Positivo()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","nAcresc",,.T.,,.T.,,,"Acrescimo %",1)			

	oCombo3 := TComboBox():New(035,570,{|u|if(PCount()>0,cTipo:=u,cTipo)},aTipos,050,13,oDlg,,,,,,.T.,,,,,,,,,'cTipo',"Tipo",1)		
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z84LOK()","U_Z84TOK()","+Z84_ITEM",,0,999,"U_Z84ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	Z84GRV() 
EndIf

Return  



 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �Z84ATCPO   �Autor  �Gustavo Lattmann   � Data � 16/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel por atualizar os campos do aCols          ���
���         �											                  ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

//-- Indiferente do campo que seja atualizado muda o status da integra��o
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

//-- Caso seja alterado para n�o atualizar o pre�o limpa demais campos
If __READVAR ==  "M->Z84_ATUPRC"    
	If M->Z84_ATUPRC == "N"
		aCols[n][nReProd] := 0
		aCols[n][nCuProd] := 0
		aCols[n][nDeProd] := 0
		aCols[n][nAcProd] := 0
	EndIf    	

EndIf

/*
//-- Ajusta o estoque de acordo com o campo de integra��o
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
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �Z84LOK    �Autor  �Gustavo Lattmann   � Data � 16/06/2017    ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o das linhas no MsNewGetDados���
���         �altera��o e exclus�o de dados na base.                       ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Z84LOK()

Local lRet		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRODUT"})
Local nPreco	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_PRECO"}) 
Local nCuProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_CUPROD"}) 
Local nReProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z84_REPROD"})


For nI := 1 To Len(aCols)
	If nI != nPos .And. aCols[nI][nProdut] == aCols[nPos][nProdut] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten��o",{"O c�digo do produto informado j� esta vinculado na linha " + STRZERO(nI,2)}, 5, {"N�o � poss�vel informar o mesmo produto mais de uma vez na mesma tabela."}, 5)
		Return .F.
	EndIf 
	If aCols[nI][nPreco] < aCols[nI][nReProd] .or. aCols[nI][nPreco] < aCols[nI][nCuProd]
		ShowHelpDlg("Aten��o",{"O pre�o de venda n�o pode ser menor que a rentabilidade ou o custo."}, 5, {"Ajuste o produto " + aCols[nI][nProdut]}, 5)
		Return .F.
	EndIf
	If aCols[nI][nReProd] < aCols[nI][nCuProd]
		ShowHelpDlg("Aten��o",{"O custo n�o pode ser maior que a rentabilidade."}, 5, {"Ajuste o produto " + aCols[nI][nProdut]}, 5)
		Return .F.
	EndIf
Next nI

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �Z84TOK    �Autor  �Gustavo Lattmann   � Data � 19/06/2017    ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o na confirma��o.			  ���
���         �										                      ���
�������������������������������������������������������������������������͹��
���Uso      � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Z84TOK()

Local lRet  := .T.
Local lHora	:= .T.


//�����������������������������������������������������������������������
//Verifica se existe alguma tabela com o mesmo c�digo j� cadastrada.   	�
//�����������������������������������������������������������������������
If INCLUI
	dbSelectArea("Z84")
	Z84->(dbSetOrder(1))
	Z84->(dbGoTop())
	If Z84->(dbSeek(xFilial("Z84") + cCod))
		ShowHelpDlg("Aten��o", {"J� existe uma tabela cadastrada com esse c�digo."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
		lRet := .F.			
	EndIf
EndIf

If dDataIni > dDataFim
	ShowHelpDlg("Aten��o", {"Data inicial n�o pode ser maior que data final."}, 5, {"Favor ajustar data inicial e final."}, 5)
	lRet := .F.
EndIf

lHora := VldHora(cHoraIni)

If !lHora
	ShowHelpDlg("Aten��o", {"Hora inicial inv�lida."}, 5, {"Favor ajustar hora inicial para um valor entre 00:00 e 23:59."}, 5)
	lRet := .F.
EndIf

lHora := VldHora(cHoraFim)

If !lHora 
	ShowHelpDlg("Aten��o", {"Hora final inv�lida."}, 5, {"Favor ajustar hora final para um valor entre 00:00 e 23:59."}, 5)
	lRet := .F.
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �VldHora    �Autor  �Gustavo Lattmann   � Data � 19/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.    �V�lida se a hora informada esta no padr�o 24h.				  ���
���         �										                      ���
�������������������������������������������������������������������������͹��
���Uso      � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function VldHora(cHora)

If Val(Subs(cHora, 1, 2)) < 0 .Or. Val(Subs(cHora, 1, 2)) > 23 .Or.; 
     Val(Subs(cHora, 4, 2)) < 0 .Or. Val(Subs(cHora, 1, 2)) > 59 
     Return .F. 
EndIf 

Return .T.

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z84GRV    �Autor  �Gustavo Lattmann   � Data � 16/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de inclus�o,     ���
���          �altera��o e exclus�o de dados na base.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Z84GRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

//Ajusta o Tipo para gravar s� F/I/V
cTipo := Substr(cTipo,1,1)

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("Z84")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z84", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
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
	
	
	//�������������������������������������������������������������������������������
	//Executa regras para a altera��o do cadastro									�
	//�������������������������������������������������������������������������������		
	Case ALTERA
	
		BEGIN TRANSACTION
		
			//�������������������������������������������������������������������������������
			//Realiza a exclus�o de todos os registros existentes atualmente				�
			//�������������������������������������������������������������������������������
			dbSelectArea("Z84")
			Z84->(dbSetOrder(1)) // FILIAL + DIA
			Z84->(dbGoTop())
			If Z84->(dbSeek(xFilial("Z84") + cCod))
				While Z84->(!EOF()) .And. Z84->Z84_FILIAL == xFilial("Z84") .And. Z84->Z84_CODIGO == cCod
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
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
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
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