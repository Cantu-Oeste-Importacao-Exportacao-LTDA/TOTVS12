#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "protheus.ch"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �GRUPOPROD  �Autor  �Gustavo Lattmann    � Data �  16/02/15  ���
�������������������������������������������������������������������������͹��
���Desc.     � Manuten��o cadastro de grupos resumidos de produto		  ���
���          �															  ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function GRUPOPROD()     

Private cCadastro := "Grupo Anal�tico Produto" //Variavel padr�o para o t�tulo do mBrowse
Private aRotina	:= MENUDEF() //Vari�vel padr�o para as op��es do mBrowse
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("Z72")
Z72->(dbsetOrder(1))  // FILIAL + COD
Z72->(dbGoTop())

//Os parametros s�o padr�es do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z72") //Compenente para gerar a tela sobre a tabela Z72

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
AADD(aOpcoes, {"Visualizar"	, "AxVisual"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "AxInclui"		, 0, 3})
AADD(aOpcoes, {"Alterar"	, "AxAltera"		, 0, 4})
AADD(aOpcoes, {"Excluir"	, "AxDeleta"   		, 0, 5})

Return aOpcoes                       
