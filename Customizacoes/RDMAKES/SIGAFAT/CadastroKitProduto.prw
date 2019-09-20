#Include "PROTHEUS.CH"
#Include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CadKitProd �Autor  �Flavio Dias         � Data �  10/07/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � CAdastro de Kit de produtos para o Pocket                   ���
�������������������������������������������������������������������������͹��
���Uso       � Cantu Vitorino - SFA                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CadKitProd()
Private cCadastro := "Kit de Produtos"
Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
								    {"Visualizar", "U_ManKitPr", 0, 2},;								    
								    {"Incluir", "U_ManKitPr", 0, 3},;
								    {"Alterar", "U_ManKitPr", 0, 4},;
								    {"Excluir", "U_ManKitPr", 0, 5}}
Private cAlias := "ZZD"      

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea(cAlias)
DbSetOrder(01)
MBrowse(6, 1, 22, 75, cAlias)
Return Nil

/******************************************/
// Fun��o que faz a manuten��o no ZZD e ZZE, manipulando os dados de kit de produto
/******************************************/
User Function ManKitPr(cAlias, nReg, nOpc)
//�������������������������Ŀ
//� Declaracao de Variaveis �
//��������������������������� 
Local  _aCpoEnchoice	:= {}      
Local  _aHeaderSave := {}
Local  _aColsSave   := {}
Local  _cTitulo		:= ""
Local  _cAliasEnchoice	:= ""
Local  _cAliasGetD  := ""
Local  _cLinOk      := ""
Local  _cTudOk      := ""
Local  _cFieldOk    := ""
Local  _nUsado      := 0
Local  _ni          := 0 
Local  _nPosIt      := 0
Local  _nOpcE       := 0 
Local  _nOpcG       := 0
Local _cOpcao 		:= "V"
Private _bHabilita	:= .T. // Variavel utilizada no X3_WHEN dos campos do SZ3
// seta a op��o usada

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if nOpc == 3
  _cOpcao := "I"
Elseif nOpc == 4
  _cOpcao := "A"
Elseif nOpc == 5
  _cOpcao := "E"
EndIf
//��������������������������������������������������������������Ŀ
//� Opcoes de acesso para a Modelo 3                             �
//����������������������������������������������������������������
Do Case
	Case _cOpcao ="I"; _nOpcE:=3 ; _nOpcG:=3; _bHabilita := .T. 
	Case _cOpcao ="A"; _nOpcE:=4 ; _nOpcG:=3; _bHabilita := .F. 
	Case _cOpcao ="V"; _nOpcE:=2 ; _nOpcG:=2; _bHabilita := .F. 
	Case _cOpcao ="E"; _nOpcE:=2 ; _nOpcG:=2; _bHabilita := .F. 
EndCase
//�����������������������������������������������������������Ŀ
//�Se o aHeader e o aCols estiverem declarados (se esta       �
//�rotina estiver sendo chamada de outra qq, como o MATA103), �
//�guardo os valores dos mesmos para depois restaurar.        �
//�������������������������������������������������������������
If (Type("aHeader")!="U")
  _aHeaderSave := aClone(aHeader)
  _aColsSave   := aClone(aCols)    
  aHeader       := {}
  aCols            := {}
EndIf
//��������������������������������������������������������������Ŀ
//� Cria variaveis M->????? da Enchoice                          �
//����������������������������������������������������������������
dbSelectArea("ZZD")
RegToMemory(("ZZD"),(_cOpcao = "I"))
//�����������������������������������������������������Ŀ
//� Cria cabecalho da gride                             �
//�������������������������������������������������������
dbSelectArea("SX3")
dbSeek("ZZE")
aHeader:={}
While !Eof().And.(X3_ARQUIVO = "ZZE")                               //�
  If (x3_campo = "ZZE_FILIAL") .Or. (x3_campo = "ZZE_CODKIT")       //�Suprimir o codigo da gride 
	  dbSkip()                                                        //�Caso queira suprimir algum 
	  Loop                                                            //�campo da grid acrescenta-lo
  EndIf                                                             //�junto ao campo zo_mat
																					   //�
  If X3USO(x3_usado).And.cNivel>=x3_nivel                           //�Criacao da gride SZG
    _nUsado:=_nUsado+1                                              //�O primeiro campo da chave do 
	  Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;         //�indice deve ser retirado da grid
	  x3_tamanho, x3_decimal,"AllwaysTrue()",;                        //�obrigatoriamente. Neste caso
	  x3_usado, x3_tipo, x3_arquivo, x3_context } )                   //� "ZO_MAT"
  Endif                                                                   //�
  dbSkip()                                                              //�
End                                                                         //�

aCols:={}

//��������������������������Ŀ
//�Adicionando Itens no gride�
//����������������������������
dbSelectArea("ZZE")
dbSetOrder(1)
dbSeek(xFilial("ZZE")+M->ZZD_CODKIT)
While (!Eof()) .And. (ZZE_CODKIT = M->ZZD_CODKIT) .And. (ZZE_FILIAL = xFilial("ZZE"))
  aADD(aCols,Array(_nUsado+1))
  For _ni:=1 to _nUsado
		If aHeader[_ni,10] = "V"
			aCols[Len(aCols),_ni]:=CriaVar(aHeader[_ni,2])
		Else
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		EndIf
	Next 
	aCols[Len(aCols),_nUsado+1]:=.F.
	ZZE->(dbSkip())
End     

If (Len(aCols) = 0)   
  aCols:= {Array(_nUsado+1)}
  aCols[1,_nUsado+1]:=.F.
	For _ni:=1 to _nUsado
	  aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next
//	_nPosIt := aScan(aHeader, { |x| x[2] = "ZG_SEQ"})
//	aCols[1,_nPosIt] := "01"
EndIf
//��������������������������������������������������������������Ŀ
//� Executa a Modelo 3                                           �
//����������������������������������������������������������������
_cTitulo:="Kit de Produtos"
_cAliasEnchoice:="ZZD"
_cAliasGetD:="ZZE"
_cLinOk:="AllwaysTrue()"
_cTudOk:="AllwaysTrue()"
_cFieldOk:="AllwaysTrue()"
_aCpoEnchoice := {}
//��������������������������������������������������������������Ŀ
//� Cabecalho do ZZD                                             �
//����������������������������������������������������������������
dbSelectArea("SX3")
dbSeek("ZZD")
While !Eof() .And. X3_ARQUIVO == cAlias  
	If X3USO(x3_usado).And.cNivel>=x3_nivel
		Aadd(_aCpoEnchoice,x3_campo)
	Endif
	dbSkip()
End    

_lRet:=Modelo3(cCadastro,_cAliasEnchoice,_cAliasGetD,_aCpoEnchoice,_cLinOk,_cTudOk,_nOpcE,_nOpcG,_cFieldOk)
//��������������������������������������������������������������Ŀ
//� Executar processamento                                       �
//����������������������������������������������������������������
If _lRet
  If _cOpcao = "I" .Or. _cOpcao = "A"
	   GravaDados(_cOpcao)
  Elseif _cOpcao = "E"
	   ExcluiDados()
  EndIf
Endif

//������������������������������Ŀ
//�Se existe o aHeader backupeado�
//��������������������������������
If Len(_aHeaderSave) > 0    
  aHeader := aClone(_aHeaderSave)
  aCols   := aClone(_aColsSave)    
EndIf
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Funcao    �GravaDados�Autor �FLAVIO Dias           � Data � 07/10/2008 ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao que gravara os dados da Modelo 3...                 ���
���          � _cOpcao = Opcao de Operacao ("INCLUIR" ou "ALTERAR")       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 - CEPROMAT                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GravaDados(_cOpcao)
Local _nPosDel      := Len(aHeader) + 1
Local _nPosIt      := aScan(aHeader, { |x| x[2] = "ZZE_CODPRO"})
Local _cCampo     := ""
Begin Transaction
//������������������Ŀ
//�Gravo o Cabecalho �    Caso precise gravar dados na tabela de cabecalho Habilite
//��������������������

dbSelectArea("SX3") // Posiciono o SX3 pra gravar o cabecalho
dbSeek("ZZD")

If RecLock("ZZD", (_cOpcao = "I"))

	While !SX3->(Eof()) .And. (SX3->X3_ARQUIVO = cAlias)
		_cCampo := SX3->X3_CAMPO
		If _cCampo = "ZZD_FILIAL"
  		&_cCampo := xFilial("ZZD") 
		Else
	    If X3USO(SX3->X3_USADO) .And. (cNivel>=SX3->X3_NIVEL)
		    &_cCampo := M->&_cCampo    
	  	Endif
  	EndIf
		SX3->(dbSkip())
	End 
  MsUnlock()                     
  //�����������������Ŀ
	//�Grava os itens...�
	//�������������������
	dbSelectArea("ZZE")
	dbSetOrder(1)
	//�������������������Ŀ
	//�Varrendo o aCols...�
	//���������������������
	For _ni := 1 to Len(aCols)
	  //���������������������������������������Ŀ
	  //�Se encontrou o item gravado no banco...�
	  //����������������������������������������� 
		dbSelectArea("ZZE")
		dbSetOrder(1)
		If dbSeek(xFilial("ZZE") + M->ZZD_CODKIT + aCols[_ni][_nPosIt])
  		// Se a linha estiver deletada...
 			If (aCols[_ni][_nPosDel])
	  		RecLock("ZZE",.F.)
	  		dbDelete()
	  		MsUnLock()
 		  Else
	   	  //����������������Ŀ
	   	  //�Altera o Item...�
	   	  //������������������
	  	  RecLock("ZZE",.F.)
	  	  For _nii := 1 to Len(aHeader)
	  		  _cCampo := ALLTRIM(aHeader[_nii,2])
	  		  &_cCampo := aCols[_ni, _nii]
	      Next
	  	  MSUnlock()
 		  EndIf      
    Else
      If !(aCols[_ni][_nPosDel])
	      RecLock("ZZE",.T.)
	  		ZZE_FILIAL := xFilial("ZZE")
	  		ZZE_CODKIT := M->ZZD_CODKIT
		   	For _nii := 1 to Len(aHeader)
					_cCampo := ALLTRIM(aHeader[_nii,2])
					&_cCampo := aCols[_ni, _nii]
		   	Next
 				MSUnlock()
  		EndIf
		EndIf
	Next  
EndIf
End Transaction
Return           
/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������ͻ��
���Funcao    �ExcluiDados�Autor �FLAVIO SILVA        � Data � 13/05/2002 ���
��������������������������������������������������������������������������͹��
���Desc.     � Funcao que excluira os dados da Modelo 3...                 ���
��������������������������������������������������������������������������͹��
���Uso       � AP5 - CEPROMAT                                              ���
��������������������������������������������������������������������������ͼ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
*/
Static Function ExcluiDados()
Begin Transaction
  dbSelectArea("ZZE")
  dbSetOrder(01)
  dbSeek(xFilial("ZZE") + M->ZZD_CODKIT)
  While !EOF() .And.     ZZE_CODKIT == M->ZZD_CODKIT
    RecLock("ZZE",.F.)
    dbDelete()
    MSUnlock()
    dbSkip()     
  End
  dbSelectArea("ZZD")
  RecLock("ZZD",.F.)
  dbDelete()
  MSUnlock()
End Transaction
Return