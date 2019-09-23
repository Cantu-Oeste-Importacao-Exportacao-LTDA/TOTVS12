#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PRODGRAN  �Autor  �Gustavo Lattmann     � Data �  15/09/16   ���
�������������������������������������������������������������������������͹��
���Desc.     �Informe da produ��o por dia dos avi�rios.                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PADGRAN()     

Private cCadastro := "Cadastro Padr�es | Granja" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z79")
Z79->(dbsetOrder(1))  // FILIAL + RACA + SEMANA
Z79->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z79") 

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
AADD(aOpcoes, {"Visualizar"	, "U_PADVIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_PADINC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_PADALT()"		, 0, 4})
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
���Programa  �CAD04ALT     �Autor  �Gustavo         � Data � 05/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pela altera��o, chamado no mBrowse      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PADVIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z79"

Local aHeader		:= MONTAHEADER(cAlias2,"Z79_RACA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cRaca		:= Z79->Z79_RACA

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z79")
Z79->(dbSetOrder(1)) //FILIAL + RACA + SEMANA
Z79->(dbGoTop())
If Z79->(dbSeek(xFilial("Z79") + cRaca))
	While Z79->(!EOF()) .And. Z79->Z79_FILIAL == xFilial("Z79") .And. Z79->Z79_RACA == cRaca
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ79 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z79->(FieldGet(nPosZ79))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z79->(dbSkip())
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
	oSay1 := TSay():New(010,004,{||"Ra�a"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
    
	aItens  := {"Hy-Line Brown","Hy-Line W-36","Hisex Brown","Hisex White","Codorna"}
	cCombo1 := aItens[Val(cRaca)]
	oCombo1 := TComboBox():New(008,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItens,100,20,oDlg,,,,,,.T.,,,,,,,,,'cCombo1') 
	oCombo1:lReadOnly := .T.

	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,/*'U_PRODLOK()'*/,'AllwaysTrue()',"+Z79_COD",,0,999,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})


Return


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
User Function PADINC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z79"

Local aHeader		:= MONTAHEADER(cAlias2,"Z79_RACA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}   
Local lHasButton 	:= .T.

Private oBrw1
Private cRaca		:= SPACE(5) //Receber� o conte�do do c�digo digitado no oGet1
//Private dDia 		:= Date()

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
	oSay1 := TSay():New(010,004,{||"Ra�a"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
    
	aItens  := {"Hy-Line Brown","Hy-Line W-36","Hisex Brown","Hisex White","Codorna"}
	cCombo1 := aItens[1]
	oCombo1 := TComboBox():New(008,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItens,100,20,oDlg,,,,,,.T.,,,,,,,,,'cCombo1')
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'AllwaysTrue()','AllwaysTrue()',"+Z79_SEMANA",,0,999,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	PADGRV()
EndIf

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04ALT     �Autor  �Gustavo         � Data � 05/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pela altera��o, chamado no mBrowse      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PADALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z79"

Local aHeader		:= MONTAHEADER(cAlias2,"Z79_RACA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cRaca		:= Z79->Z79_RACA

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z79")
Z79->(dbSetOrder(1)) // FILIAL + RACA
Z79->(dbGoTop())
If Z79->(dbSeek(xFilial("Z79") + cRaca))
	While Z79->(!EOF()) .And. Z79->Z79_FILIAL == xFilial("Z79") .And. Z79->Z79_RACA == cRaca
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ79 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z79->(FieldGet(nPosZ79))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z79->(dbSkip())
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
	oSay1 := TSay():New(010,004,{||"Ra�a"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
    
	aItens  := {"Hy-Line Brown","Hy-Line W-36","Hisex Brown","Hisex White","Codorna"}
	cCombo1 := aItens[Val(cRaca)] //cCombo1 := aItens[1]
	oCombo1 := TComboBox():New(008,040,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},aItens,100,20,oDlg,,,,,,.T.,,,,,,,,,'cCombo1')
	oCombo1:lReadOnly := .T.
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'AllwaysTrue()','AllwaysTrue()',"+Z79_SEMANA",,0,999,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
	PADGRV()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04VAT     �Autor  �Gustavo         � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o de valida��o do cabe�alho da rotina.		          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Treinamento ADVPL                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PADVCB()

Local lRet := .T.

//�������������������������������������������������������������������������������
//Verifica se existe tipo de atendimento cadastrado com o c�digo informado   	�
//�������������������������������������������������������������������������������
If INCLUI 
	dbSelectArea("Z79")
	Z79->(dbSetOrder(1))
	Z79->(dbGoTop())
	If Z79->(dbSeek(xFilial("Z79") + cRaca))
		ShowHelpDlg("Aten��o", {"J� existe um padr�o registrado para essa ra�a."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
		lRet := .F.			
	EndIf
EndIf

Return lRet       


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04GRV     �Autor  �Gustavo         � Data � 05/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o respons�vel pela execu��o de regras de inclus�o,     ���
���          �altera��o e exclus�o de dados na base.                      ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PADGRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader            

If cCombo1 == "Hy-Line Brown"
	cRaca := "1"
Elseif cCombo1 == "Hy-Line W-36"
	cRaca := "2"
Elseif cCombo1 == "Hisex Brown"
	cRaca := "3"
Elseif cCombo1 == "Hisex White"
	cRaca := "4"
Elseif cCombo1 == "Codorna"
	cRaca := "5"		
EndIf

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("Z79")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z79", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ79 := FieldPos(aHeader[nY][2]))
									Z79->(FieldPut(nPosZ79, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						Z79->Z79_FILIAL	:= xFilial("Z79")
						Z79->Z79_RACA	:= cRaca
					Z79->(MSUNLOCK())
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
			dbSelectArea("Z79")
			Z79->(dbSetOrder(1)) // FILIAL + CODIGO
			Z79->(dbGoTop())
			If Z79->(dbSeek(xFilial("Z79") + cRaca))
				While Z79->(!EOF()) .And. Z79->Z79_FILIAL == xFilial("Z79") .And. Z79->Z79_RACA == cRaca
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("Z79", .F.)
					Z79->(DBDELETE())
				Z79->(MSUNLOCK())
			
				Z79->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("Z79")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z79", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ79 := FieldPos(aHeader[nY][2]))
									Z79->(FieldPut(nPosZ79, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						Z79->Z79_FILIAL	:= xFilial("Z79")
						Z79->Z79_RACA	:= cRaca
					Z79->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase

Return