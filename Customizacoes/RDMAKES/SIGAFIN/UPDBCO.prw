#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#include "protheus.ch"


User Function UPDPBCO()
Private cCadastro := "Bancos Genericos"
 
Private aRotina := { {"Pesquisar"	,"AxPesqui"							,0,1} 	,;
                	 {"Visualizar"	,"AxVisual"							,0,2} 	,;
                	 {"Incluir"		,'ExecBlock("UPDBCOI",.F.,.F.)'		,0,3} 	,;
                	 {"Alterar"		,'AxAltera'							,0,4}	,;
                	 {"Excluir"		,'AxDeleta'							,0,5}}
 
//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������
 
Private aCampos := { {"ZZN_BANCO","ZZN_AGENCI","ZZN_CONTA","ZZN_PRIORI","ZZN_IMPBOL"} ,;
           {"","","",""} }
 
//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
 
Private cString := "ZZN"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
 
 
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,)

Return 
           
User Function UPDBCOI()
Local lEstorna := .t.
Local _Recno   := Recno()      	
Local _Order   := IndexOrd()
Local nOpcao   := AxInclui('ZZN',,,,,,'U_VALUPDBCO()',,,)     

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return
      
User Function ValUpdBCO()
Local lRet  := .T.
Local aArea	:= GetArea()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

SA6->(DbSelectArea("SA6"))
SA6->(DbSetOrder(1))
SA6->(DbGotop())
If SA6->(DbSeek(xFilial("SA6")+M->ZZN_BANCO+M->ZZN_AGENCI+M->ZZN_CONTA))
	If SA6->A6_MSBLQL == '1' .OR. SA6->A6_BLOCKED == '1'
	  	MsgAlert("Banco bloqueado n�o pode ser selecionado !")
		lRet	:= .F.
	Endif
Else
  	MsgAlert("Banco n�o cadastrado !")
	lRet	:= .F.
Endif
cSql := "SELECT * "
cSql += "FROM "+RetSqlName("ZZN")+" "
cSql += "WHERE ZZN_FILIAL = '"+xFilial("ZZN")+"' "
cSql += "AND D_E_L_E_T_ <> '*' "
cSql += "AND ZZN_BANCO = '"+M->ZZN_BANCO+"' "
cSql += "AND ZZN_AGENCI = '"+M->ZZN_AGENCI+"' "
cSql += "AND ZZN_CONTA = '"+M->ZZN_CONTA+"' "
TCQUERY cSql NEW ALIAS "TMPZZN"
TMPZZN->(DbSelectArea("TMPZZN"))
TMPZZN->(DbGoTop())
If !TMPZZN->(EOF())
  	MsgAlert("Banco j� cadastrado !")
	lRet	:= .F.
Endif
TMPZZN->(DbSelectArea("TMPZZN"))
DbCloseArea("TMPZZN")


Return(lRet) 

User Function UPDBCOE(cAlias, nReg, nOpc)
Local cTudoOk := "(Alert('OK'),.T.)"
Local nOpcao := 0

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

nOpcao := AxDeleta(cAlias,nReg,nOpc)
// Identifica corretamente a op��o definida para o fun��o em aRotinas com mais
// do que os 5 elementos padr�es.
If nOpcao == 1
	MsgInfo("Exclus�o realizada com sucesso!")
ElseIf nOpcao == 2
	MsgInfo("Exclus�o cancelada!")
Endif
Return Nil



// ###################################### Fun��o para visualizar amarra��o CEP x Bancos ###################################

User Function UPDCEP()
Private cCadastro := "Bancos X CEP"
 
Private aRotina := { {"Pesquisar"	,"AxPesqui"							,0,1} 	,;
                	 {"Visualizar"	,"AxVisual"							,0,2} 	}
//                	 {"Incluir"		,'ExecBlock("UPDBCOI",.F.,.F.)'		,0,3} 	}
//                	 {"Excluir"		,'ExecBlock("EXCSim03",.F.,.F.)'	,0,5}	}
 
//���������������������������������������������������������������������Ŀ
//� Monta array com os campos para o Browse                             �
//�����������������������������������������������������������������������
 
Private aCampos := { {"ZM_BANCO","ZM_RAIZCEP"} ,;
           {"","","",""} }
 
//Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
 
Private cString := "SZM"         

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName()) 
 
dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,)

Return 