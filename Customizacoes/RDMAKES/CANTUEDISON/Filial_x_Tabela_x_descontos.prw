#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


user function FILTABDC()

Private cCadastro := "Filial x Tabela x Descontos" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("ZDT")
ZDT->(dbsetOrder(1))  // FILIAL + COD TABELA
ZDT->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"ZDT") 

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MENUDEF     �Autor  �Edison          � Data � 24/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     � Op��es que ir�o compor o menu na tela.                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � OESTE                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function MENUDEF()
Local aOpcoes := {}

//AADD(aOpcoes, {"Pesquisar"	, "AxPesqui"   		, 0, 1})
AADD(aOpcoes, {"Visualizar"	, "U_ZDTVIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_ZDTINC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_ZDTALT()"		, 0, 4})
AADD(aOpcoes, {"Excluir"	, "AxDeleta" 	 	, 0, 5})

Return aOpcoes  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MONTAHEADER     �Autor  �Edison      � Data � 24/06/2019   ���
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
���Programa  �ZDTINC     �Autor  �Edison            � Data � 24/04/2019   ���
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
User Function ZDTINC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_ZDTLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZDT"
Local cTitulo		:= "Busca Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZDT_FILIAL")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cFil		:= cFilant

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
oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cFil:=u, cFil)},oDlg,020,010,"@!",{||U_ZDTTOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFil",,.T.,,.T.,,,"C�d Filial",1)
			
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	 oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_ZDTLOK()","U_ZDTTOK()","+ZDT_ITEM",,0,999,,'',,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	ZDTGRV() 
EndIf

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZDTVIS     �Autor  �Edison         � Data � 24/06/2019      ���
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
User Function ZDTVIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_ZDTLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZDT"
Local cTitulo		:= "Busca Filiais da Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZDT_FILIAL")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= ZDT->ZDT_TABELA			//-- C�digo Tabela
Private cFil		:= ZDT->ZDT_FILIAL          //- C�digo Filial


Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("ZDT")
ZDT->(dbSetOrder(1)) // FILIAL + codigo
ZDT->(dbGoTop())
If ZDT->(dbSeek(xFilial("ZDT")))
	While ZDT->(!EOF()) .And. ZDT->ZDT_FILIAL == xFilial("ZDT")
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ4, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZDT := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := ZDT->(FieldGet(nPosZDT))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		ZDT->(dbSkip())
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
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cFil:=u, cFil)},oDlg,020,010,"@!",{||U_ZDTTOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cfil",,.T.,,.T.,,,"C�digo Filial",1)


	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
  oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,"U_ZDTLOK()","U_ZDTTOK()","+ZDT_ITEM",,0,999,,'',,oDlg,aHeader,aCols)

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
���Programa  �ZDTALT     �Autor  �Edison         � Data � 24/06/2019      ���
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
User Function ZDTALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_ZDTLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZDT"
Local cTitulo		:= "Busca Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZDT_FILIAL")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= ZDT->ZDT_TABELA			//-- C�digo Tabela
Private cFil		:= ZDT->ZDT_FILIAL			//-- C�digo filial

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("ZDT")
ZDT->(dbSetOrder(1)) // FILIAL 
ZDT->(dbGoTop())
If ZDT->(dbSeek(xFilial("ZDT"))) 
	While ZDT->(!EOF()) .And. ZDT->ZDT_FILIAL == xFilial("ZDT") 
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZDT := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := ZDT->(FieldGet(nPosZDT))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		ZDT->(dbSkip())
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
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cFil:=u, cFil)},oDlg,020,010,"@!",{||U_ZDTTOK()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFil",,.T.,,.T.,,,"C�d Filial",1)
		
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
    oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_ZDTLOK()","U_ZDTTOK()","+ZDT_ITEM",,0,999,,'',,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	ZDTGRV() 
EndIf

Return  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ZDTLOK    �Autor  �Edison G. Barbieri   � Data � 24/06/2019  ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o das linhas no MsNewGetDados���
���         �altera��o e exclus�o de dados na base.                       ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZDTLOK()

Local lRet		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nTabela	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZDT_TABELA" })

For nI := 1 To Len(aCols)
	If nI != nPos .And. aCols[nI][nTabela] == aCols[nPos][nTabela] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten��o",{"A tabela ja esta vinvulada a essa filial linha " + STRZERO(nI,2)}, 5, {"Favor verificar."}, 5)
		Return .F.
	EndIf 
	
Next nI

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ZDTTOK    �Autor  �Edison G. Barbieri   � Data � 24/06/2019  ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o na confirma��o.			  ���
���         �										                      ���
�������������������������������������������������������������������������͹��
���Uso      � 	                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZDTTOK()

//�����������������������������������������������������������������������
//Verifica se existe alguma tabela com o mesmo c�digo j� cadastrada.   	�
//�����������������������������������������������������������������������
If INCLUI
	dbSelectArea("ZDT")
	ZDT->(dbSetOrder(1))
	ZDT->(dbGoTop())
	If ZDT->(dbSeek(xFilial("ZDT")))
		ShowHelpDlg("Aten��o", {"J� existe uma filial cadastrada."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
		lRet := .F.			
	EndIf
EndIf

Return lRet

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZDTGRV    �Autor  �Edison G. Barbieri � Data � 24/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de inclus�o,     ���
���          �altera��o e exclus�o de dados na base.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ZDTGRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("ZDT")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("ZDT", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZDT := FieldPos(aHeader[nY][2]))
									ZDT->(FieldPut(nPosZDT, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						ZDT->ZDT_FILIAL	:= xFilial("ZDT")
											
						
					ZDT->(MSUNLOCK())
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
			dbSelectArea("ZDT")
			ZDT->(dbSetOrder(1)) // FILIAL
			ZDT->(dbGoTop())
			If ZDT->(dbSeek(xFilial("ZDT")))
				While ZDT->(!EOF()) .And. ZDT->ZDT_FILIAL == xFilial("ZDT")
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("ZDT", .F.)
					ZDT->(DBDELETE())
				ZDT->(MSUNLOCK())
			
				ZDT->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("ZDT")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("ZDT", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZDT := FieldPos(aHeader[nY][2]))
									ZDT->(FieldPut(nPosZDT, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						ZDT->ZDT_FILIAL	:= cFil
						
													
					ZDT->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase

Return 