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
User Function MORTGRAN()


Private cCadastro := "Mortalidades | Granja" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z77")
Z77->(dbsetOrder(1))  // FILIAL + COD
Z77->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z77") 

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
AADD(aOpcoes, {"Visualizar"	, "U_MORTVIS()"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_MORTINC()"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "U_MORTALT()"		, 0, 4})
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
User Function MORTVIS(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada 
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z77"

Local aHeader		:= MONTAHEADER(cAlias2,"Z77_DIA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private dDia		:= Z77->Z77_DIA

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z77")
Z77->(dbSetOrder(1)) // FILIAL + SEMANA + DIA
Z77->(dbGoTop())
If Z77->(dbSeek(xFilial("Z77") + DTOS(dDia)))
	While Z77->(!EOF()) .And. Z77->Z77_FILIAL == xFilial("Z77") .And. Z77->Z77_DIA == dDia
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ77 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z77->(FieldGet(nPosZ77))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z77->(dbSkip())
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
	oSay2 := TSay():New(040,010,{||"Dia"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	
	oGet2 := TGet():New(040,040,{|u|if(PCount()>0, dDia:=u, dDia)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDia",,)
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(060,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,'AllwaysTrue()','AllwaysTrue()',"",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

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
User Function MORTINC(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg			//Objeto da tela que esta sendo montada
Local bOk			:= {||Iif(U_MORTLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}   
Local cAlias2		:= "Z77"

Local aHeader		:= MONTAHEADER(cAlias2,"Z77_DIA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private dDia 		:= Date()

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
	oSay2 := TSay():New(040,010,{||"Dia"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	
	oGet2 := TGet():New(040,040,{|u|if(PCount()>0, dDia:=u, dDia)},oDlg,030,004,"@D",{||U_MORTVCB()},CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","dDia",,.T.,,.T.)
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(060,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'U_MORTLOK()','AllwaysTrue()',"+Z77_COD",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������
If nOpcao == 1
   	MORTGRV() 
   	//fAtSaldo()
   	
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
User Function MORTALT(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que ser� o controle de o usu�rio confirmou ou n�o a inclus�o
Local oDlg				 //Objeto da tela que esta sendo montada
//Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bOk			:= {||Iif(U_MORTLOK(),(nOpcao := 1, oDlg:End()),)}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z77"

Local aHeader		:= MONTAHEADER(cAlias2,"Z77_DIA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private dDia		:= Z77->Z77_DIA

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .T.
Private DELETA		:= .F.

//�������������������������������������������������������������������������������
//Executa regras para carregar as informa��es do grid da interface				�
//�������������������������������������������������������������������������������
dbSelectArea("Z77")
Z77->(dbSetOrder(1)) // FILIAL + DIA
Z77->(dbGoTop())
If Z77->(dbSeek(xFilial("Z77") + DTOS(dDia)))
	While Z77->(!EOF()) .And. Z77->Z77_FILIAL == xFilial("Z77") .And. Z77->Z77_DIA == dDia
	
		//���������������������������������������������������������������������������������������������������������������
		//Adiciona item em branco no aCols para vincular as informa��es do registro posicionado no browse				�
		//���������������������������������������������������������������������������������������������������������������
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//�������������������������������������������������������������������������������
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			�
		//�������������������������������������������������������������������������������
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ77 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z77->(FieldGet(nPosZ77))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//�������������������������������������������������������������������������������
		//Atribui .F. para o item do aCols | N�O DELETADO								�
		//�������������������������������������������������������������������������������
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z77->(dbSkip())
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
	oSay2 := TSay():New(040,010,{||"Dia"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	
	oGet2 := TGet():New(040,040,{|u|if(PCount()>0, dDia:=u, dDia)},oDlg,030,004,"@D",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","dDia",,)
	
	//�������������������������������������������������������������������������������
	// Declara��o do MSNEWGETDADOS referente ao grid de itens da interface			�
	//�������������������������������������������������������������������������������
	oBrw1 := MsNewGetDados():New(060,002,aPosObj[2][3],aPosObj[2][4],GD_INSERT + GD_UPDATE + GD_DELETE,'U_MORTLOK()','AllwaysTrue()',"+Z77_COD",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//�������������������������������������������������������������������������������
//Executa m�todo de apresesnta��o de tela criando � barra de bot�es				�
//�������������������������������������������������������������������������������
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})

//�������������������������������������������������������������������������������
//Caso confirmou os dados, grava a inclus�o										�
//�������������������������������������������������������������������������������

If nOpcao == 1
	MORTGRV()
	//fAtSaldo()
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
User Function MORTLOK()

Local lRet 		:= .T.     
Local cAlias	:= GetNextAlias()
Local nPos		:= oBrw1:nAt //Retorna a posi��o atual do meu grid (MsNewGetDados)
Local aHeader	:= oBrw1:aHeader //Grava no aHeaders local o cabe�alho do objeto browse
Local aCols		:= oBrw1:aCols
Local nPosDia	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_DIA"}) //Verifica pelo aHeader a posi��o do campo
Local nPosAvi	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_AVIARI"})  //Verifica pelo aHeader a posi��o do campo

For nI := 1 To Len(aCols)
    
	//-- Verifica se h� lote ativo para o avi�rio
	cSql := "SELECT Z76_SALINI, Z76_LOTE FROM Z76010 "
	cSql += " WHERE Z76_AVIARI = '" + aCols[nI][nPosAvi] + "'"
	cSql += "   AND D_E_L_E_T_ = ' ' "
	cSql += "   AND Z76_DIAINI <= '" + DTOS(dDia) + "'"
	cSql += "   AND Z76_DIAFIM >= '" + DTOS(dDia) + "'"	
        
	TCQUERY cSql NEW ALIAS (cAlias) 
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())  
	
	If (cAlias)->(Eof())     
		ShowHelpDlg("Aten��o",{"N�o existe lote ativo para o avi�rio " + aCols[nI][nPosAvi]}, 5, {"N�o � poss�vel informar mortalidade para um avi�rio sem lote ativo."}, 5)
		Return .F.
	EndIf
	
	If nI != nPos .And. aCols[nI][nPosAvi] == aCols[nPos][nPosAvi] .And. !aCols[nI][Len(aHeader) + 1]
		ShowHelpDlg("Aten��o",{"O c�digo do avi�rio informado j� esta vinculado na linha " + STRZERO(nI,2)}, 5, {"N�o � poss�vel informar mais de uma vez o mesmo avi�rio."}, 5)
		Return .F.
	EndIf 
	
	(cAlias)->(dbCloseArea())
	
Next nI

//�����������������������������������������������������������
//Atualiza o aCols no componente do grid e efetua refresh  	�
//�����������������������������������������������������������
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
User Function MORTVCB()

Local lRet := .T.

//�������������������������������������������������������������������������������
//Verifica se existe tipo de atendimento cadastrado com o c�digo informado   	�
//�������������������������������������������������������������������������������
If INCLUI 
	dbSelectArea("Z77")
	Z77->(dbSetOrder(1))
	Z77->(dbGoTop())
	If Z77->(dbSeek(xFilial("Z77") + DTOS(dDia)))
		ShowHelpDlg("Aten��o", {"J� existe um registro para esse e dia."}, 5, {"Favor utilizar a funcionalidade de alterar."}, 5)
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
Static Function MORTGRV()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader

Do Case
	//�������������������������������������������������������������������������������
	//Executa regras para a inclus�o do cadastro									�
	//�������������������������������������������������������������������������������
	Case INCLUI
		
		//Controle de transa��o
		BEGIN TRANSACTION
			dbSelectArea("Z77")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z77", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ77 := FieldPos(aHeader[nY][2]))
									Z77->(FieldPut(nPosZ77, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						Z77->Z77_FILIAL	:= xFilial("Z77")
						Z77->Z77_DIA	:= dDia
					Z77->(MSUNLOCK())
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
			dbSelectArea("Z77")
			Z77->(dbSetOrder(1)) // FILIAL + DIA
			Z77->(dbGoTop())
			If Z77->(dbSeek(xFilial("Z77") + DTOS(dDia)))
				While Z77->(!EOF()) .And. Z77->Z77_FILIAL == xFilial("Z77") .And. Z77->Z77_DIA == dDia
							
				//�������������������������������������������������������������������������������
				//Efetua � exclus�o do registro posicionado										�
				//�������������������������������������������������������������������������������
				RecLock("Z77", .F.)
					Z77->(DBDELETE())
				Z77->(MSUNLOCK())
			
				Z77->(dbSkip())
				End
			EndIf		
			
			dbSelectArea("Z77")
			For nI := 1 to Len(aCols)
				If !aCols[nI][Len(aHeader) + 1]
					RecLock("Z77", .T.)
						//Passa campo a campo do aHeader para verificar se ele � real
						For nY := 1 to Len(aHeader)
							//Verifica se o campo nY � diferente de virtual, no caso se o campo � real
							If aHeader[nY][10] != "V"
								If !EMPTY(nPosZ77 := FieldPos(aHeader[nY][2]))
									Z77->(FieldPut(nPosZ77, aCols[nI][nY]))
								EndIf
							EndIf
						Next nY
						
						Z77->Z77_FILIAL	:= xFilial("Z77")
						Z77->Z77_DIA	:= dDia
					Z77->(MSUNLOCK())
				EndIf
			Next nI	
					
		END TRANSACTION

	EndCase
	//-- Chama fun��o para recalcular saldo
	RepSaldo()
Return 


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FATSALDO  �Autor  �Gustavo Lattmann    � Data �  22/12/16   ���
�������������������������������������������������������������������������͹��
���Desc.     � Atualiza o saldo de aves de acordo com a mortalidade.      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus                                              	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*
Static Function fAtSaldo()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader  
Local nPosAvi	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_AVIARI"})
Local nPosMor	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_MORTAL"})
Local cSql		:= ""    
Local cAlias	:= GetNextAlias()
Local cAlias2	:= GetNextAlias()

For nI := 1 to Len(aCols)
    
	
	dbSelectArea("Z80")
	Z80->(dbSetOrder(2))
	Z80->(dbGoTop())
	/*
	//-- Busca o saldo do dia anterior
	If Z80->(dbSeek(xFilial("Z80") + PADR(aCols[nI][nPosAvi],2) + DTOS(dDia -1))) 
		nSaldo := Z80->Z80_SALDO - aCols[nI][nPosMor]
	*                                               
	
	cSql := "SELECT Z76_SALINI, Z76_LOTE FROM Z76010 "
	cSql += " WHERE Z76_AVIARI = '" + aCols[nI][nPosAvi] + "'"
	cSql += "   AND D_E_L_E_T_ = ' ' "
	cSql += "   AND Z76_DIAINI <= '" + DTOS(dDia) + "'"
	cSql += "   AND Z76_DIAFIM >= '" + DTOS(dDia) + "'"	
        
	TCQUERY cSql NEW ALIAS (cAlias) 
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())

	//-- Verifica o menor saldo diferente de zero
	cSql := "SELECT MIN(Z80_SALDO) AS SALDO FROM Z80010 "
	cSql += " WHERE Z80_AVIARI = '" + aCols[nI][nPosAvi] + "'"
	cSql += "   AND D_E_L_E_T_ = ' ' "
	cSql += "   AND Z80_SALDO > 0"  
	cSql += "   AND Z80_LOTE = '" + (cAlias)->(Z76_LOTE) + "'"
        
	TCQUERY cSql NEW ALIAS (cAlias2) 
	dbSelectArea(cAlias2)
	(cAlias2)->(dbGoTop())  
   
	If !(cAlias2)->(Eof()) .and. !Empty((cAlias2)->(SALDO))
   		nSaldo := (cAlias2)->(SALDO) - aCols[nI][nPosMor]
	Else
		//-- Caso seja o primeiro lan�ado do lote, busca o saldo inicial		
		nSalIni := (cAlias)->(Z76_SALINI)
		nSaldo := nSalIni - aCols[nI][nPosMor]					            	
 	EndIf
    
	//-- Garante que esta posicionado no registro correto para fazer a altera��o
	Z80->(dbSeek(xFilial("Z80") + PADR(aCols[nI][nPosAvi],2) + DTOS(dDia))) 
    
	//-- Realiza a atualiza��o do saldo
	If !aCols[nI][Len(aHeader) + 1]
		BEGIN TRANSACTION
			RecLock("Z80", .F.)
				Z80->Z80_SALDO	:= nSaldo
			Z80->(MSUNLOCK())
		END TRANSACTION
	EndIf
	(cAlias)->(dbCloseArea())  
	(cAlias2)->(dbCloseArea())
	
Next nI	
	
Return
*/

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
���Programa  �RepSaldo        �Autor  �Gustavo      � Data � 20/09/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o utilizada para recalcular os saldos das aves.        ��� 
���          �													          ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RepSaldo()

Local aCols		:= oBrw1:aCols
Local aHeader	:= oBrw1:aHeader  
Local nPosAvi	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_AVIARI"})
Local nPosMor	:= aScan(aHeader,{|x| ALLTRIM(x[2]) == "Z77_MORTAL"})

Local cSql  := ""
Local cSql2 := ""
Local cAlias	:= GetNextAlias()
Local cAlias2	:= GetNextAlias()

Local nSaldo := 0

//-- Cada execu��o do for � para um avi�rio
For nI := 1 to Len(aCols)
	cSql := "SELECT Z76.Z76_AVIARI, " 
	cSql += "       Z76.Z76_SALINI " 
	cSql += "  FROM Z76010 Z76 "
	cSql += " WHERE Z76.D_E_L_E_T_ = ' ' "
	cSql += "   AND Z76.Z76_AVIARI = " + aCols[nI][nPosAvi]
	
	TCQUERY cSql NEW ALIAS (cAlias) 
	dbSelectArea(cAlias)
	(cAlias)->(dbGoTop())
	
	nSalIni := (cAlias)->(Z76_SALINI)
	
	cSql2 := "SELECT Z80.Z80_FILIAL, " 
	cSql2 += "       Z80.Z80_LOTE, "
	cSql2 += "       Z80.Z80_AVIARI, "
	cSql2 += "       Z80.Z80_DIAINI, " 
	cSql2 += "       Z80.Z80_SALDO, "
	cSql2 += "       Z77.Z77_MORTAL "
	cSql2 += "  FROM Z80010 Z80 "
	cSql2 += " INNER JOIN Z77010 Z77 "
	cSql2 += "    ON Z77.Z77_FILIAL = Z80.Z80_FILIAL "
	cSql2 += "   AND Z77.Z77_AVIARI = Z80.Z80_AVIARI "
	cSql2 += "   AND Z77.Z77_DIA = Z80.Z80_DIAINI "
	cSql2 += "   AND Z77.D_E_L_E_T_ = ' ' "
	cSql2 += " WHERE Z80.D_E_L_E_T_ = ' ' "
	cSql2 += "   AND Z80.Z80_AVIARI = " + aCols[nI][nPosAvi]
	cSql2 += " ORDER BY 1,2,4 "
	
	TCQUERY cSql2 NEW ALIAS (cAlias2) 
	dbSelectArea(cAlias)
	(cAlias2)->(dbGoTop())
	
	While !(cAlias2)->(Eof())
		//-- Primeira vez que esta executando
		If nSaldo == 0
			nSaldo := nSalIni - (cAlias2)->(Z77_MORTAL)
		Else
			nSaldo := nSaldo - (cAlias2)->(Z77_MORTAL)
		EndIf
		
		dbSelectArea("Z80")
		Z80->(dbSetOrder(2)) //FILIAL + AVIARIO + DATA
		Z80->(dbGoTop())
		Z80->(dbSeek(xFilial("Z80")+(cAlias2)->(Z80_AVIARI)+(cAlias2)->(Z80_DIAINI)))
		//BEGIN TRANSACTION
			RecLock("Z80", .F.)
				Z80->Z80_SALDO	:= nSaldo
			Z80->(MSUNLOCK())
		//END TRANSACTION
		
		(cAlias2)->(dbSkip())
	EndDo
	nSaldo := 0
	(cAlias)->(dbCloseArea())  
	(cAlias2)->(dbCloseArea())
Next nI

Return