#INCLUDE "parmtype.ch""
#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


user function Z85()

Private cCadastro := "Tabela de Pre�o | Oracle" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z85")
Z85->(dbsetOrder(1))  // FILIAL + PRODUTO
Z85->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z85") 

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
AADD(aOpcoes, {"Visualizar"	, "U_Z85VIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_Z85INC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_Z85ALT()"		, 0, 4})
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
User Function Z85INC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_Z85LOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z85"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z85_CODIGO")
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
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z85LOK()",/*"U_Z85TOK()"*/,"+Z85_ITEM",,0,999,"U_Z85ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	Z85GRV() 
EndIf

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z85ALT       �Autor  �Gustavo         � Data � 31/07/2017   ���
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
User Function Z85ALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_Z85LOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z85"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z85_CODIGO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Z85->Z85_CODIGO			//-- C�digo tabela

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.    

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z85")
Z85->(dbSetOrder(2)) // FILIAL + CODIGO
Z85->(dbGoTop())
If Z85->(dbSeek(xFilial("Z85") + cCod))
	While Z85->(!EOF()) .And. Z85->Z85_FILIAL == xFilial("Z85") .And. Z85->Z85_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ85 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z85->(FieldGet(nPosZ85))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z85->(dbSkip())
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
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,"U_Z85LOK()",/*"U_Z85TOK()"*/,"+Z85_ITEM",,0,999,"U_Z85ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
Aadd( aButtons, {"BUSCA", {|| GdSeek(oBrw1,cTitulo)}, "Busca", "Busca" , {|| .T.}} )

oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg,bOk,bCancel,,@aButtons)}) 

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	Z85GRV() 
EndIf

Return               

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z85ALT       �Autor  �Gustavo         � Data � 31/07/2017   ���
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
User Function Z85VIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||oDlg:End()}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z85"
Local cTitulo		:= "Busca Produtos Tabela"

Local aHeader		:= MONTAHEADER(cAlias2,"Z85_CODIGO")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}
Local aButtons 		:= {}

Private oBrw1
Private cCod		:= Z85->Z85_CODIGO			//-- C�digo tabela

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.      


//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z85")
Z85->(dbSetOrder(2)) // FILIAL + CODIGO
Z85->(dbGoTop())
If Z85->(dbSeek(xFilial("Z85") + cCod))
	While Z85->(!EOF()) .And. Z85->Z85_FILIAL == xFilial("Z85") .And. Z85->Z85_CODIGO == cCod
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ85 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z85->(FieldGet(nPosZ85))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z85->(dbSkip())
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
	oBrw1 := MsNewGetDados():New(070,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,"U_Z85LOK()",/*"U_Z85TOK()"*/,"+Z85_ITEM",,0,999,"U_Z85ATCPO()",'',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

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
���Programa �Z85LOK    �Autor  �Gustavo Lattmann   � Data � 16/06/2017    ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel pela valida��o das linhas no MsNewGetDados���
���         �altera��o e exclus�o de dados na base.                       ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Z85LOK()

Local lRet		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z85_PRODUT"})

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
���Programa �Z85ATCPO   �Autor  �Gustavo Lattmann   � Data � 16/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel por atualizar os campos do aCols          ���
���         �											                  ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Z85ATCPO()

Local nProdut	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z85_PRODUT"})
Local nTpEst	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z85_TPEST"}) 
Local nEstoq	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z85_ESTOQ"})
Local nStatIn	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z85_STATIN"})  
Local aArea 	:= GetArea()

//-- Indiferente do campo que seja atualizado muda o status da integra��o
aCols[n][nStatIn] := 0

//-- Campo do aCols que esta posicionado 
If __READVAR ==  "M->Z85_PRODUT"  
	If aCols[n][nTpEst] $ "A/C"   
		aCols[n][nEstoq] := U_Z85EST(xFilial("SB2"),aCols[n][nProdut])
	EndIf
EndIf    
If __READVAR ==  "M->Z85_TPEST"
	//If aCols[n][nTpEst] == "B"    
	If M->Z85_TPEST == "B" 
		aCols[n][nEstoq] := 0
	Else
		aCols[n][nEstoq] := U_Z85EST(xFilial("SB2"),aCols[n][nProdut])		
	EndIf
EndIf	

oBrw1:Refresh()

RestArea(aArea)

Return .T.

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z85GRV    �Autor  �Gustavo Lattmann   � Data � 16/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de inclus�o,     ���
���          �altera��o e exclus�o de dados na base.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Z85GRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("Z85")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z85", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ85 := FieldPos(aHeader[nY][2]))
									Z85->(FieldPut(nPosZ85, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						Z85->Z85_FILIAL	:= xFilial("Z85")
						Z85->Z85_CODIGO	:= cCod
						
					Z85->(MSUNLOCK())
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
			dbSelectArea("Z85")
			Z85->(dbSetOrder(2)) // FILIAL + CODIGO
			Z85->(dbGoTop())
			If Z85->(dbSeek(xFilial("Z85") + cCod))
				While Z85->(!EOF()) .And. Z85->Z85_FILIAL == xFilial("Z85") .And. Z85->Z85_CODIGO == cCod
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("Z85", .F.)
					Z85->(DBDELETE())
				Z85->(MSUNLOCK())
			
				Z85->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("Z85")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z85", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ85 := FieldPos(aHeader[nY][2]))
									Z85->(FieldPut(nPosZ85, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						Z85->Z85_FILIAL	:= xFilial("Z85")
						Z85->Z85_CODIGO	:= cCod
					Z85->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase

Return 

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �Z85EST   �Autor  �Gustavo Lattmann   � Data � 16/06/2017   ���
�������������������������������������������������������������������������͹��
���Desc.    �Fun��o respons�vel por buscar o estoque do produto na SB2    ���
���         �caso campo de integra��o de estoque seja SIM                 ���
�������������������������������������������������������������������������͹��
���Uso      � AP                                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Z85EST(cFilEmp,cProduto)

Local cSql 		:= ""
Local cAlias 	:= GetNextAlias()
Local nEstoque 	:= 0

dbSelectArea("SB1")	
SB1->(dbSetOrder(1))
SB1->(dbGoTop())
SB1->(dbSeek(xFilial("SB1")+cProduto))

cSql += "SELECT (B2_QATU - B2_RESERVA) AS ESTOQUE " 
cSql += "  FROM " + RetSqlName("SB2") + " B2"
cSql += " INNER JOIN " + RetSqlName("SBZ") + " BZ "
cSql += "    ON BZ_FILIAL = B2_FILIAL "
cSql += "   AND BZ_COD = B2_COD "
cSql += " WHERE B2_FILIAL = '" + cFilEmp + "'"
cSql += "   AND B2_COD = '" + SB1->B1_COD + "'"
cSql += "   AND B2_LOCAL = BZ_LOCPAD "
cSql += "   AND B2.D_E_L_E_T_ = ' ' "

TCQUERY cSql NEW ALIAS (cAlias)

dbSelectArea(cAlias)
(cAlias)->(dbGoTop())
if !(cAlias)->(EOF())
	If (cAlias)->ESTOQUE > 0
		nEstoque := Round((cAlias)->ESTOQUE,2)
	EndIf
EndIf 

(cAlias)->(dbCloseArea())

Return nEstoque


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Z85       �Autor  �Microsiga           � Data �  07/31/17   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function Z85JOB()

Local cEmpIni 	:= "40"
Local cFilIni 	:= "01"
Local cSql	  	:= ""	
Local cCod		:= ""
Local cAlias  	:= GetNextAlias()
Local nEstoque 	:= 0
Local aEmp		:= {}

//�����������������������������������������������������������������������Ŀ
//�Posiciona o sistema em uma empresa para dar in�cio na sele��o dos dados�
//�������������������������������������������������������������������������
RpcClearEnv()
RpcSetType(3)
RpcSetEnv(cEmpIni, cFilIni,,,, GetEnvServer(),{ "Z85" })

dbSelectArea("SM0")
dbSetOrder(1)
dbGoTop()
       
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, {SM0->M0_CODIGO, SM0->M0_CODFIL})
	EndIf
	SM0->(dbSkip())
End

//-- Executa o job para cada empresa
For nI := 1 to Len(aEmp)
	//RpcClearEnv()
	//RpcSetType(3)
	//RpcSetEnv(aEmp[nI][1], aEmp[nI][2],,,, GetEnvServer(),{ "Z85" })
	
	Conout("Z85JOB - Iniciando atualizacao de estoque para empresa " + cEmpAnt)
		
	cSql := "SELECT DISTINCT Z85_FILIAL, Z85_PRODUT " 
	cSql += "  FROM Z85400" //+ RetSQLName("Z85") 
	cSql += " WHERE D_E_L_E_T_ = ' ' "
	cSql += "   AND Z85_TPEST IN ('A','C') "   //-- Se considera estoque real
	
	TCQUERY cSql NEW ALIAS (cAlias) 
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	//-- Executa para cada produto
	While !(cAlias)->(Eof())
		//-- Busca estoque atualizado
		nEstoque := U_Z85EST((cAlias)->Z85_FILIAL,(cAlias)->Z85_PRODUT)
		
		Conout("Z85JOB - Filial " + (cAlias)->Z85_FILIAL + " Produto " + (cAlias)->Z85_PRODUT + " estoque atual " + Str(nEstoque))
		
		dbSelectArea("Z85")
		Z85->(dbSetOrder(1)) // FILIAL + PRODUTO
		Z85->(dbGoTop())
		Z85->(dbSeek(xFilial("Z85") + (cAlias)->Z85_PRODUT))
		While !Z85->(Eof()) .and. Z85->Z85_PRODUT == (cAlias)->Z85_PRODUT
			If Z85->Z85_INTEST == "S"
				RecLock("Z85",.F.)
				Z85->Z85_ESTOQ := nEstoque
				Z85->(MSUNLOCK())
			EndIf
			Z85->(dbSkip())
		EndDo
		(cAlias)->(dbSkip())
	EndDo
	(cAlias)->(dbCloseArea())
Next nI

//-- Exclu� registros deletados da tabela
cSql := "DELETE Z84400" //+ RetSQLName("Z85") 
cSql += " WHERE D_E_L_E_T_ = '*' "

If (TCSQLExec(cSql) < 0)
	Return Conout("TCSQLError() " + TCSQLError()) 
Else
	Conout("Z85JOB - Limpeza de tabela executada. ")
EndIf 

Return

