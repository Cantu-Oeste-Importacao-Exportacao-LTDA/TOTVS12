#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


user function TCTRTABP()
Private cCadastro := "Torre Controle Tabela Estoque" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("ZET")
ZET->(dbsetOrder(1))  // FILIAL + PRODUTO
ZET->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"ZET") 

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MENUDEF     �Autor  �Edison          � Data � 16/02/2015   ���
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

AADD(aOpcoes, {"Visualizar"	, "U_ZETVIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_ZETINC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_ZETALT()"		, 0, 4})
AADD(aOpcoes, {"Excluir"	, "AxDeleta" 	 	, 0, 5})


Return aOpcoes  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MONTAHEADER     �Autor  �Edison      � Data � 19/06/2019    ���
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
���Programa  �CAD04INC     �Autor  �Edison         � Data � 04/06/2014   ���
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
User Function ZETINC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_ZETLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZET"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZET_CODIGO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Space(3)			//-- C�digo tabela

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

	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_ZETLOK()",/*"U_ZETTOK()"*/,"+ZET_ITEM",,0,999,"U_ZETATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	ZETGRV() 
EndIf

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZETALT       �Autor  �Edison         � Data � 31/07/2017   ���
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
User Function ZETALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_ZETLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZET"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZET_CODIGO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= ZET->ZET_CODIGO			//-- C�digo tabela

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.    

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("ZET")
ZET->(dbSetOrder(2)) // FILIAL + CODIGO
ZET->(dbGoTop())
If ZET->(dbSeek(xFilial("ZET") + cCod))
	While ZET->(!EOF()) .And. ZET->ZET_FILIAL == xFilial("ZET") .And. ZET->ZET_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZET := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := ZET->(FieldGet(nPosZET))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		ZET->(dbSkip())
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
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",/*{||U_MORTVCB()}*/,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C�digo",1)

	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_ZETLOK()",/*"U_ZETTOK()"*/,"+ZET_ITEM",,0,999,"U_ZETATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	ZETGRV() 
EndIf

Return               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZETALT       �Autor  �Edison         � Data � 31/07/2017   ���
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
User Function ZETVIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||oDlg:End()}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "ZET"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"ZET_CODIGO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= ZET->ZET_CODIGO			//-- C�digo tabela

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.      


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("ZET")
ZET->(dbSetOrder(2)) // FILIAL + CODIGO
ZET->(dbGoTop())
If ZET->(dbSeek(xFilial("ZET") + cCod))
	While ZET->(!EOF()) .And. ZET->ZET_FILIAL == xFilial("ZET") .And. ZET->ZET_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZET := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := ZET->(FieldGet(nPosZET))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		ZET->(dbSkip())
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
	oGet1 := TGet():New(035,005,{|u|if(PCount()>0, cCod:=u, cCod)},oDlg,020,010,"@!",/*{||U_MORTVCB()}*/,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCod",,.T.,,.T.,,,"C�digo",1)

	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,"U_ZETLOK()",/*"U_ZETTOK()"*/,"+ZET_ITEM",,0,999,"U_ZETATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

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
���Programa �ZETLOK    �Autor  �Edison G. Barbieri   � Data � 19/06/2019    ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o das linhas no MsNewGetDados���
���         �altera��o e exclus�o de dados na base.                       ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZETLOK()

Local lRet		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_PRODUT"})


For nI := 1 To Len(aCols)
	If nI != nPos .And. aCols[nI][nProdut] == aCols[nPos][nProdut] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten��o",{"O c�digo do produto informado j� esta vinculado na linha " + STRZERO(nI,2)}, 5, {"N�o � poss�vel informar o mesmo produto mais de uma vez na mesma tabela."}, 5)
		Return .F.
	EndIf 
Next nI

Return lRet

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ZETATCPO   �Autor  �Edison G. Barbieri   � Data � 19/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel por atualizar os campos do aCols          ���
���         �											                  ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ZETATCPO()

Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_PRODUT"})
Local nTpEst	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_TPEST"}) 
Local nEst01	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_E4001"})
Local nEst04	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_E4004"})
Local nEst05	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "ZET_E4005"})
Local aArea 	:= GetArea()


//-- Campo do aCols que esta posicionado 
If __READVAR ==  "M->ZET_PRODUT"  
	If aCols[n][nTpEst] $ "A/C"   
		aCols[n][nEst01] := U_ZETEST01(xFilial("SB2"),aCols[n][nProdut])
		aCols[n][nEst04] := U_ZETEST04(xFilial("SB2"),aCols[n][nProdut])
		aCols[n][nEst05] := U_ZETEST05(xFilial("SB2"),aCols[n][nProdut])
	EndIf
EndIf    

If __READVAR ==  "M->ZET_TPEST" 
	If M->ZET_TPEST == "B" 
		aCols[n][nEst01] := 0
		aCols[n][nEst04] := 0
		aCols[n][nEst05] := 0
	Else
		aCols[n][nEst01] := U_ZETEST01(xFilial("SB2"),aCols[n][nProdut])
		aCols[n][nEst04] := U_ZETEST04(xFilial("SB2"),aCols[n][nProdut])
		aCols[n][nEst05] := U_ZETEST05(xFilial("SB2"),aCols[n][nProdut])		
	EndIf
EndIf	

oBrw1:Refresh()

RestArea(aArea)

Return .T.

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZETGRV    �Autor  �Edison G. Barbieri   � Data � 19/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de inclus�o,     ���
���          �altera��o e exclus�o de dados na base.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ZETGRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader


Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("ZET")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("ZET", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZET := FieldPos(aHeader[nY][2]))
									ZET->(FieldPut(nPosZET, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						ZET->ZET_FILIAL	:= xFilial("ZET")
						ZET->ZET_CODIGO	:= cCod
						
					ZET->(MSUNLOCK())
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
			dbSelectArea("ZET")
			ZET->(dbSetOrder(2)) // FILIAL + CODIGO
			ZET->(dbGoTop())
			If ZET->(dbSeek(xFilial("ZET") + cCod))
				While ZET->(!EOF()) .And. ZET->ZET_FILIAL == xFilial("ZET") .And. ZET->ZET_CODIGO == cCod
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("ZET", .F.)
					ZET->(DBDELETE())
				ZET->(MSUNLOCK())
			
				ZET->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("ZET")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("ZET", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZET := FieldPos(aHeader[nY][2]))
									ZET->(FieldPut(nPosZET, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						ZET->ZET_FILIAL	:= xFilial("ZET")
						ZET->ZET_CODIGO	:= cCod
					ZET->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase
	
	
// chama job para a exclussao dos deletados
U_ZETJOB()

Return 

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ZETEST01   �Autor  �Edison G. Barbieri   � Data � 19/06/2019   ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel por buscar o estoque do produto na SB2    ���
���         �caso campo de integra��o de estoque seja SIM                 ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Fun��o responsavel pela busca do saldo no momento do cadastro (estoque real) filial 01
User Function ZETEST01(cCodEmp,cProduto)

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local nEstoque01 	:= 0


dbSelectArea("SB1")	
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
SB1->(dbSeek(xFilial("SB1")+cProduto))

cSql += "SELECT B2_QATU AS ESTOQUE01 " 
cSql += "  FROM " + RetSqlName("SB2") + " B2"
cSql += " INNER JOIN " + RetSqlName("SBZ") + " BZ "
cSql += "    ON BZ_FILIAL = B2_FILIAL "
cSql += "   AND BZ_COD = B2_COD "
cSql += " WHERE B2_FILIAL = '01'"
cSql += "   AND B2_COD = '" + SB1->B1_COD + "'"
cSql += "   AND B2_LOCAL = BZ_LOCPAD "
cSql += "   AND B2.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS (cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
if !(cAlias)->(EOF())
	If (cAlias)->ESTOQUE01 > 0
		nEstoque01 := Round((cAlias)->ESTOQUE01,2)
	EndIf
EndIf 

(cAlias)->(dbCloseArea())

Return nEstoque01


// Fun��o responsavel pela busca do saldo no momento do cadastro (estoque real) filial 04
User Function ZETEST04(cCodEmp,cProduto)

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local nEstoque04 	:= 0


dbSelectArea("SB1")	
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
SB1->(dbSeek(xFilial("SB1")+cProduto))

cSql += "SELECT B2_QATU AS ESTOQUE04 " 
cSql += "  FROM " + RetSqlName("SB2") + " B2"
cSql += " INNER JOIN " + RetSqlName("SBZ") + " BZ "
cSql += "    ON BZ_FILIAL = B2_FILIAL "
cSql += "   AND BZ_COD = B2_COD "
cSql += " WHERE B2_FILIAL = '04'"
cSql += "   AND B2_COD = '" + SB1->B1_COD + "'"
cSql += "   AND B2_LOCAL = BZ_LOCPAD "
cSql += "   AND B2.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS (cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
if !(cAlias)->(EOF())
	If (cAlias)->ESTOQUE04 > 0
		nEstoque04 := Round((cAlias)->ESTOQUE04,2)
	EndIf
EndIf 

(cAlias)->(dbCloseArea())

Return nEstoque04

// Fun��o responsavel pela busca do saldo no momento do cadastro (estoque real) filial 05
User Function ZETEST05(cCodEmp,cProduto)

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local nEstoque05 	:= 0


dbSelectArea("SB1")	
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
SB1->(dbSeek(xFilial("SB1")+cProduto))

cSql += "SELECT B2_QATU AS ESTOQUE05 " 
cSql += "  FROM " + RetSqlName("SB2") + " B2"
cSql += " INNER JOIN " + RetSqlName("SBZ") + " BZ "
cSql += "    ON BZ_FILIAL = B2_FILIAL "
cSql += "   AND BZ_COD = B2_COD "
cSql += " WHERE B2_FILIAL = '05'"
cSql += "   AND B2_COD = '" + SB1->B1_COD + "'"
cSql += "   AND B2_LOCAL = BZ_LOCPAD "
cSql += "   AND B2.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS (cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
if !(cAlias)->(EOF())
	If (cAlias)->ESTOQUE05 > 0
		nEstoque05 := Round((cAlias)->ESTOQUE05,2)
	EndIf
EndIf 

(cAlias)->(dbCloseArea())

Return nEstoque05


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZET       �Autor  �Microsiga           � Data �  21/06/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZETJOB()

//-- Exclu� registros deletados da tabela
cSql := "DELETE ZET400" //+ RetSQLName("ZET") 
cSql += " WHERE D_E_L_E_T_ = '*' "

If (TCSQLExec(cSql) < 0)
	Return Conout("TCSQLError() " + TCSQLError()) 
Else
	Conout("ZETJOB - Limpeza de tabela executada. ")
EndIf 

Return
