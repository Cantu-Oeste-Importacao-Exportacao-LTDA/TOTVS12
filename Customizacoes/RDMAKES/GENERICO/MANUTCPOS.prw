#Include "Protheus.ch"
#include "rwmake.ch"
/******************************************************
 Fun��o gen�rica utilizada para fazer a manuten��o de cadastro
 modelo1, permitindo que seja alterado apenas alguns campos
 os quais s�o passado por parametro.
 
*O primeiro parametro � o alias da manuten��o
*Segundo parmetro � uma string dos campos que podem ser alterados,
 separados por / 
*O terceiro parametro � o nome do cadastro
 *****************************************************/
User Function MANUTCPOS(cAlias, cCposAlt, cCad)
Private cCadastro := cCad
Private aRotina := {}
Private aFixe := {}

Private aCampos := {} // array que cont�m os campos utilizados
Private aCmpAlt := {} // array que cont�m os campos alteraveis  


//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

aArea := GetArea()
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAlias)
While(!Eof() .And. SX3->x3_ARQUIVO == cAlias)
	if (X3Uso(SX3->X3_USADO))
		Aadd(aCampos, X3_CAMPO)	
	EndIf
	SX3->(dbSkip())
EndDo
                  
RestArea(aArea)
nCont := 0
aCmpAlt := StrToKArr(cCposAlt, "/")

aAdd(aRotina, {"Pesquisar" , "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar"   , "U_EdtCmps", 0, 4})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return

User Function EdtCmps(cAlias, nReg, nOpc)
AxAltera(cAlias, nReg, nOpc, aCampos, aCmpAlt)
Return