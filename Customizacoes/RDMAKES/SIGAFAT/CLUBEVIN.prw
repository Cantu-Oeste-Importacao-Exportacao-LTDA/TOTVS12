#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MORTGRAN  �Autor  �Gustavo Lattmann    � Data �  15/09/16  ���
�������������������������������������������������������������������������͹��
���Desc.     �Cadastro das informa��es de mortalidade por dia.            ���
���          �Para controle da granja.									  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CLUBEVIN()


Private cCadastro := "Cadastro de Clubes | Vinho" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z81")
Z81->(dbsetOrder(1))  // FILIAL + COD
Z81->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z81") 

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
AADD(aOpcoes, {"Visualizar"	, "U_CLUBVIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_CLUBINC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_CLUBALT()"		, 0, 4})
AADD(aOpcoes, {"Excluir"	, "AxDeleta" 	 	, 0, 5})

Return aOpcoes  


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
User Function CLUBVIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada 
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z81"

Local aHeader		:= MONTAHEADER(cAlias2,"Z81_CLUBE/Z81_DIAINI/Z81_DIAFIM")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cClube		:= Z81->Z81_CLUBE
Private dDiaIni		:= Z81->Z81_DIAINI
Private dDiaFim		:= Z81->Z81_DIAFIM

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z81")
Z81->(dbSetOrder(1)) // FILIAL + CLUBE
Z81->(dbGoTop())
If Z81->(dbSeek(xFilial("Z81") + cClube))
	While Z81->(!EOF()) .And. Z81->Z81_FILIAL == xFilial("Z81") .And. Z81->Z81_CLUBE == cClube
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ81 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z81->(FieldGet(nPosZ81))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z81->(dbSkip())
	EndDo
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
	oSay1 := TSay():New(010,010,{||"Clube"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay2 := TSay():New(010,120,{||"Dia Inicial"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	oSay3 := TSay():New(010,220,{||"Dia Final"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	
	oGet1 := TGet():New(010,040,{|u|if(PCount()>0, cClube:=u, cClube)},oDlg,060,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cClube",,)
	oGet2 := TGet():New(010,160,{|u|if(PCount()>0, dDiaIni:=u, dDiaIni)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDiaIni",,)	
	oGet3 := TGet():New(010,260,{|u|if(PCount()>0, dDiaFim:=u, dDiaFim)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDiaFim",,)		
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,'AllwaysTrue()','AllwaysTrue()',"",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

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
User Function CLUBINC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_CLUBLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z81"

Local aHeader		:= MONTAHEADER(cAlias2,"Z81_CLUBE/Z81_DIAINI/Z81_DIAFIM")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cClube 		:= Space(20)
Private dDiaIni		:= Date()
Private dDiaFim		:= Date()

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
	oSay1 := TSay():New(010,010,{||"Clube"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay2 := TSay():New(010,120,{||"Dia Inicial"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	oSay3 := TSay():New(010,220,{||"Dia Final"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)		

	oGet1 := TGet():New(010,040,{|u|if(PCount()>0, cClube:=u, cClube)},oDlg,060,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cClube",,)
	oGet2 := TGet():New(010,160,{|u|if(PCount()>0, dDiaIni:=u, dDiaIni)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDiaIni",,.T.,,.T.)	
	oGet3 := TGet():New(010,260,{|u|if(PCount()>0, dDiaFim:=u, dDiaFim)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDiaFim",,.T.,,.T.)	 
		

	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'U_CLUBLOK()','AllwaysTrue()',"+Z81_ITEM",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	CLUBGRV()
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
User Function CLUBALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada
//Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bOk			:= {||Iif(U_CLUBLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z81"

Local aHeader		:= MONTAHEADER(cAlias2,"Z81_CLUBE/Z81_DIAINI/Z81_DIAFIM")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cClube		:= Z81->Z81_CLUBE                
Private dDiaIni		:= Z81->Z81_DIAINI
Private dDiaFim		:= Z81->Z81_DIAFIM

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z81")
Z81->(dbSetOrder(1)) // FILIAL + CLUBE
Z81->(dbGoTop())
If Z81->(dbSeek(xFilial("Z81") + cClube))
	While Z81->(!EOF()) .And. Z81->Z81_FILIAL == xFilial("Z81") .And. Z81->Z81_CLUBE == cClube
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ81 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z81->(FieldGet(nPosZ81))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z81->(dbSkip())
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
	oSay1 := TSay():New(010,010,{||"Clube"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay2 := TSay():New(010,120,{||"Dia Inicial"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	oSay3 := TSay():New(010,220,{||"Dia Final"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	
	oGet1 := TGet():New(010,040,{|u|if(PCount()>0, cClube:=u, cClube)},oDlg,060,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cClube",,)
	oGet2 := TGet():New(010,160,{|u|if(PCount()>0, dDiaIni:=u, dDiaIni)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDiaIni",,)	
	oGet3 := TGet():New(010,260,{|u|if(PCount()>0, dDiaFim:=u, dDiaFim)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDiaFim",,)		

	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'U_CLUBLOK()','AllwaysTrue()',"+Z81_ITEM",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������

If nOpcao == 1
	CLUBGRV()
EndIf

Return      

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CAD04VOC     �Autor  �Gustavo         � Data � 04/06/2014   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o de valida��o em torno do codigo da ocorrencia        ���
���          �informada no grid                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CLUBLOK()

Local lRet 		:= .T.
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nPosProd	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z81_PRODUT"}) //Verifica pelo aHeader a posi��o do campo

For nI := 1 To Len(aCols)
	If nI != nPos .And. aCols[nI][nPosProd] == aCols[nPos][nPosProd] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten��o",{"O c�digo do produto j� esta vinculado ao item " + STRZERO(nI,2)}, 5, {"N�o � poss�vel informar mais de uma vez o mesmo c�digo."}, 5)
		Return .F.
	EndIf
Next nI

//�������������������������������������������������������������������������������
//Atualiza o aCols no componente do grid e efetua refresh        				�
//�������������������������������������������������������������������������������
oBrw1:aCols := aCols
oBrw1:oBrowse:Refresh()

Return lRet


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
User Function CLUBVCB()

Local lRet := .T.

//�������������������������������������������������������������������������������
//Verifica se existe tipo de atendimento cadastrado com o c�digo informado   	�
//�������������������������������������������������������������������������������
If INCLUI 
	dbSelectArea("Z81")
	Z81->(dbSetOrder(1))
	Z81->(dbGoTop())
	If Z81->(dbSeek(xFilial("Z81") + cClube))
		ShowHelpDlg("Aten��o", {"J� existe um registro com esse nome."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
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
Static Function CLUBGRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("Z81")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z81", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ81 := FieldPos(aHeader[nY][2]))
									Z81->(FieldPut(nPosZ81, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						Z81->Z81_FILIAL	:= xFilial("Z81")
						Z81->Z81_CLUBE	:= cClube
						Z81->Z81_DIAINI := dDiaIni
						Z81->Z81_DIAFIM := dDiaFim
					Z81->(MSUNLOCK())
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
			dbSelectArea("Z81")
			Z81->(dbSetOrder(1)) // FILIAL + DIA
			Z81->(dbGoTop())
			If Z81->(dbSeek(xFilial("Z81") + cClube))
				While Z81->(!EOF()) .And. Z81->Z81_FILIAL == xFilial("Z81") .And. Z81->Z81_CLUBE == cClube
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("Z81", .F.)
					Z81->(DBDELETE())
				Z81->(MSUNLOCK())
			
				Z81->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("Z81")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z81", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ81 := FieldPos(aHeader[nY][2]))
									Z81->(FieldPut(nPosZ81, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						Z81->Z81_FILIAL	:= xFilial("Z81")
						Z81->Z81_CLUBE	:= cClube
						Z81->Z81_DIAINI := dDiaIni
						Z81->Z81_DIAFIM := dDiaFim					
					Z81->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase

Return


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