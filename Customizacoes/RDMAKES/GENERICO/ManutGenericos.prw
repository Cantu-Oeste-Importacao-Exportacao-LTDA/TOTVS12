#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANUTGENERICOS�Autor  �Diversos        � Data �  07/03/13   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fonte que armazena fun��es gen�ricas                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//������������������������������������������������������������������������������������Ŀ
//� Funcao criada para Alterar os dados de Origem, Grupo Tribut�rio, Tes,              �
//� Exporta para Palm, Filial de Venda, Peso Bruto, Peso L�quido,                      �
//� Unidade de Medida, Bloqueado, Segunda Unidade de Medida, Conversao,                �
//� Tipo da Conversao, Pre�o de Venda e Desconto M�ximo                                �
//�                                                                                    �
//� * Fun�ao modificada para para que seja poss�vel alterar apenas determinados campos �
//�  do cadastro do produto.                                                           �
//��������������������������������������������������������������������������������������

User Function MANUTPROD()
Local cCad := "Manuten��o de Produtos para filiais"     


//���������������������������������������������������������
//�alterado para buscar os campos a alterar de um parametro�
//���������������������������������������������������������

Local cB1CposAlt := SuperGetMV("MV_B1ALTCP", ," ")
U_MANUTCPOS("SB1", cB1CposAlt, cCad)              

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//���������������Ŀ
//�Desconto Maximo�
//�����������������

User Function MANDMAX()
Local cCad := "Manuten��o de Desconto Maximo"
U_MANUTCPOS("SB1", "B1_DESCMAX", cCad)                                                 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//�����������������
//�Desconto Cliente�
//�����������������

User Function MANDCLI()
Local cCad := "Manuten��o de Desconto Cliente"
U_MANUTCPOS("SA1", "A1_X_DESC", cCad)                                                 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.



User Function MANSZ7()
Local cTab	:= "SZ7"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.


User Function MANSRE()
Local cTab	:= "SRE"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.

//���������������������������������������������������������Ŀ
//�Programa utilizado para alimentar descontos na tabela ZZ0�
//�����������������������������������������������������������



User Function MANZZ0()
Local cTab	:= "ZZ0"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.

//���������������������������������������������������������l
//�Programa utilizado para gravar kits de produtos e duzias�
//���������������������������������������������������������l

User Function MANZZ1()
Local cTab	:= "ZZ1"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .T.


User Function MANZZF()
Local cTab	:= "ZZF"
AxCadastro(cTab, "Amarra��o Tabela x Kit")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .T.

//��������������������������������������������������������Ŀ
//�Alterado para buscar os campos a alterar de um parametro�
//����������������������������������������������������������

User Function MANSE1()
Local cCad := "Manuten��o de T�tulos"
Local cCposAlt := "E1_CLVLCR/E1_CLVLDB/E1_CCC/E1_CCD/E1_NATUREZ"
U_MANUTCPOS("SE1", cCposAlt, cCad)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//�����������������������������������������4�
//�Corte da comissao X Segmento para o Pneu�
//�����������������������������������������4�

User Function MANZZL()
Local cTab := "ZZL"
AxCadastro(cTab)                 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//�����������������������������������Ŀ
//�Cadastro de vendedor real x virtual�
//�������������������������������������

User Function MANZZM()
Local cTab := "ZZM"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//���������������������������������������������������������������Ŀ
//�Prazo m�dio m�ximo e condicao de pagamento x cliente x segmento�
//�����������������������������������������������������������������

User Function MANZZP()
Local cTab := "ZZP"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//����������������������������������Ŀ
//�Cadastro Vendedores por Supervisor�
//������������������������������������

User Function MANZZQ()
Local cTab := "ZZQ"
AxCadastro(cTab)                 

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return           

//�������������������������������������������������������������������������������Ŀ
//�Fun��o para retornar o n�mero da conta do ita� sem o tra�o separador do d�gito.�
//���������������������������������������������������������������������������������

User Function RetCItau(cConta,nOpc)
Local cNewConta := ""

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//���������������������Ŀ
//�Retorna conta inteira�
//�����������������������

if nOpc = 1 
	cNewConta := SubStr(AllTrim(cConta),1,len(AllTrim(cConta))-2) // N�mero da Conta
	cNewConta += SubStr(AllTrim(cConta),len(AllTrim(cConta)),1) // D�gito da Conta	

//�������������������������$�
//�Retorna conta sem d�gito�
//�������������������������$�

ElseIf nOpc = 2 
	cNewConta := SubStr(AllTrim(cConta),1,len(AllTrim(cConta))-2) // N�mero da Conta
ElseIf nOpc = 3
	cNewConta := SubStr(AllTrim(cConta),len(AllTrim(cConta)),1) // D�gito da Conta	

Else
	MsgInfo("Par�metros inv�lidos na fun��o RetCItau.")
	cNewConta := "0"
EndIf

Return cNewConta

//�����������������������������������������������������������������������������Ŀ
//�Fun��o para retornar o n�mero da conta do favorecido para o arquivo do SISPAG�
//�������������������������������������������������������������������������������

User Function RetAgeConFav(cFornecedor, cLoja)
Local cAgeCon  := ""
Local cAgencia := ""
Local cConta   := ""
Local cDac     := ""

DbSelectArea("SA2")
DbSetOrder(1)
DbSeek(xFilial("SA2") + cFornecedor + cLoja)
cAgencia := AllTrim(SA2->A2_AGENCIA)
cConta   := AllTrim(SA2->A2_NUMCON)
cDac     := AllTrim(SA2->A2_DIGCON)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())


if SA2->A2_BANCO $ '341/409'
	cAgeCon := "0"                                          // Zeros
	cAgeCon += SubStr(cAgencia,1,4)         								// Ag�ncia Creditada
	cAgeCon += Space(1)                                    // Branco
	cAgeCon += "000000"                                    // Zeros
	
	if At("-",cConta) > 0                                   // Conta
		cAgeCon += StrZero(Val(SubStr(cConta,1,len(cConta)-2)),6)
		cDac    := SubStr(cDac,len(cDac),1)
	Else
		if len(cConta) > 6
			cAgeCon += StrZero(Val(SubStr(cConta,1,6)),6)
			cDac    := SubStr(cDac,len(cDac),1)
		Else
			cAgeCon += StrZero(Val(SubStr(cConta,1,5)),6)          	
			cDac    := SubStr(cDac,len(cDac),1)
		EndIf
	EndIf
	
	cAgeCon += Space(1)                                     // Complemento
	cAgeCon += cDac                                         // DAC

ElseIf !Empty(SA2->A2_BANCO)
	cAgeCon := StrZero(Val(SubStr(cAgencia,1,5)),5)         // Ag�ncia
	cAgeCon += Space(1)                                     // Branco	
	
	if At("-",cConta) > 0                                   // Conta
		cAgeCon += StrZero(Val(SubStr(cConta,1,len(cConta)-2)),12)
		cDac    := SubStr(cDac,len(cDac),1)
	Else
		cAgeCon += StrZero(Val(cConta),12)
		cDac    := "0"	
	EndIf

	cAgeCon += Space(1)                                     // Complemento  
	cAgeCon += cDac                                         // DAC

EndIf

if len(cAgeCon) != 20
	cAgeCon := StrZero(0,20)
EndIf

Return cAgeCon

//��������������������������������������Ŀ
//�Permitir altera��o do lote do produto.�
//����������������������������������������

User Function MANB1LOTE()
Local cAlias := "SB1"
Private cCadastro := "Manuten��o de Lote do Produto"
Private aRotina := {}
aAdd(aRotina, {"Pesquisar", "AxPesqui", 0, 1})
aAdd(aRotina, {"Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"Alterar", "U_ALTB1LOTE", 0, 4})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)
Return

User Function ALTB1LOTE()
Local oDlg
Local oGet
Local aRastro := {"S=Sub Lote", "L=Lote", "N=N�o Utiliza", " "}
Local lCont := .F.
Private cB1_RASTRO := SB1->B1_RASTRO

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 200, 600 Dialog oDlg Title "Alterar Lote Produto"
@ 18, 10 Say "Produto: " + Trim(SB1->B1_DESC)
@ 28, 10 SAY "Rastro:"  
@ 28, 50 COMBOBOX cB1_RASTRO Items aRastro SIZE 60, 10 

ACTIVATE DIALOG oDlg CENTER ON INIT ;      
EnchoiceBar(oDlg,{|| lCont := .T., ODlg:End(), Nil }, {|| oDlg:End() })
if lCont
	RecLock("SB1", .F.)
	SB1->B1_RASTRO := cB1_RASTRO
	SB1->(MsUnlock())
EndIf
Return

//�����������������������������������������������
//�Fun��o para a escrever uma string ao contr�rio
//�����������������������������������������������

User Function EscreveContrario(cTexto)
Local cString := AllTrim(cTexto)
Local       i := 0
Local cRet    := ""

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

for i := len(cString) to 1 step -1
	cRet += SubStr(cString, i, 1)	
Next i                        

Aviso("String modificada",cRet,{"Ok"},3)                              

Return nil


//����������������������������������������������������������������
//�Fun��o gen�rica para manuten��o da tabela Z36 - Pra�as x Banco�
//����������������������������������������������������������������

User Function MANZ36()
Local cAlias := "Z36"
AxCadastro(cAlias)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return


User Function MANSZ8()
Local cTab	:= "SZ8"
AxCadastro(cTab, "Amarra��o de Tabelas x Vendedor")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.


//ESTOQUE RESERVADO PARA VENDEDOR

User Function MANSZZ()
Local cTab	:= "SZZ"
AxCadastro(cTab, "Estoque x Produto X Vendedor")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.

//ESTOQUE RESERVADO PARA VENDEDOR

User Function MANSZY()
Local cTab	:= "SZY"
AxCadastro(cTab, "Filial x Tabela x Cliente")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.



//SEM�FORO ESTOQUES VINHO


User Function MANSZ9()
Local cTab	:= "SZ9"
AxCadastro(cTab, "Sem�foro Estoques Vinho")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return .t.

//�����������������������������������������������������������������������������������������Ŀ
//�Fun��o utilizada para valida��o da pra�a de cobran�a quando o controle de CEP � por faixa�
//�������������������������������������������������������������������������������������������

User Function ValCepFaixa(cBanco, cUF, cCep)
Local lFound := .F.

DbSelectArea("Z36")
Z36->(DbSetOrder(1))
DbSeek(xFilial("Z36") + cBanco + cUF)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

while !lFound .and. (Z36->Z36_BANCO == cBanco .and. Z36->Z36_UF == cUF)
	lFound := cCep >= Z36->Z36_CEPINI .and. cCep <= Z36->Z36_CEPFIM
	Z36->(DbSkip())
EndDo

Return lFound

//������������������������������������������������������������������������
//�Fun��o utilizada para manuten��o de tabelas do cat�logo para integra��o
//������������������������������������������������������������������������

User Function MANZ37()
AxCadastro("Z37", "Tabelas do cat�logo")

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return Nil 


//�������������������������������������������������������������������������Ŀ
//�Fun��o utilizada para manuten��o da tabela de Transportador x Cidade x UF�
//���������������������������������������������������������������������������

User function MANZZV()
Local cTab := "ZZV"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return



User function MANSZA()
Local cTab := "SZA"
AxCadastro(cTab)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//���������������������������������������������������������������������������������������Ŀ
//�Fun��o utilizada nos gatilhos dos campos C5_CLIENTE, C5_LOJACLI, C5_CLIENT e C5_LOJAENT�
//�para atribuir no pedido de vendas o c�digo do  transportador padr�o.                   �
//�����������������������������������������������������������������������������������������

User Function RetTransp(cCliente, cLoja)
Local cTransp := ""
DbSelectArea("SA1")
SA1->(DbSetOrder(1))

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If DbSeek(xFilial("SA1")+cCliente+cLoja)
	DbSelectArea("ZZV")
	ZZV->(DbSetOrder(2))
	if DbSeek(xFilial("ZZV")+SA1->A1_EST+SA1->A1_COD_MUN)
		cTransp := ZZV->ZZV_TRANSP
	EndIf
EndIf
Return cTransp 

//�������������������������������������������������������������������������������Ŀ
//�Fun��o respons�vel por fazer a manuten��o dos cadastros de Itens de Confer�ncia�
//���������������������������������������������������������������������������������

User Function ManZ18()
Local cAlias := "Z18"
AxCadastro(cAlias)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return

//��������������������������������������������������������������������������������������Ŀ
//�Fun��o para retornar o valor do campo E1_DECRESC no Lan�amento Padr�o da Contabilidade�
//����������������������������������������������������������������������������������������

User Function E1DECRESC()
Local aArea := GetArea()
Local cRet := " "

DbSelectArea("SE1")
SE1->(DbSetOrder(1))

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (SE1->(DbSeek(SE5->E5_FILIAL + SE5->E5_PREFIXO + SE5->E5_NUMERO + SE5->E5_PARCELA + SE5->E5_TIPO)))
	cRet := SE1->E1_DECRESC
EndIf

RestArea(aArea)

Return cRet

//���������������������������������������������������������������������������������������������������������Ŀ
//�Fun��o respons�vel pela valida��o do desconto do cliente em rela��o � sua categoria (OnTrade ou OffTrade)�
//�����������������������������������������������������������������������������������������������������������
*----------------------------*
User Function ValDescCat()    
*----------------------------*

Local lRet			:= .T.
Local nOnTrade 	:= SuperGetMV("MV_ONTRADE",,0)
Local nOffTrade := SuperGetMV("MV_OFFTRADE",,0)
Local nDelicat	:= SuperGetMV("MV_DELICAT",,0)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Do Case

	//������������������Ŀ
	//�Categoria On Trade�
	//��������������������
	
	Case M->A1_X_CATEG == '1' .and. M->A1_X_DESC > nOnTrade
		lRet := .F.
		MsgAlert("Desconto m�ximo para o canal ON TRADE � "+Transform(nOnTrade,"@E 999.99")+" %.")

	//�������������������Ŀ
	//�Categoria Off Trade�
	//���������������������
	
	Case M->A1_X_CATEG == '2' .and. M->A1_X_DESC > nOffTrade
		lRet := .F.
		MsgAlert("Desconto m�ximo para o canal OFF TRADE � "+Transform(nOffTrade,"@E 999.99")+" %.")

	//����������������������Ŀ
	//�Categoria Delicatessen�
	//������������������������
	
	Case M->A1_X_CATEG == '3' .and. M->A1_X_DESC > nDelicat
		lRet := .F.
		MsgAlert("Desconto m�ximo para o canal DELICATESSEN � "+Transform(nOffTrade,"@E 999.99")+" %.")  
		
	//�����������������������Ŀ
	//�Outros ou Nenhuma op��o�
	//�������������������������
	
	Case (M->A1_X_CATEG == '4' .or. M->A1_X_CATEG == ' ') .and. M->A1_X_DESC > 0
		lRet := .F.
		MsgAlert("Selecione o canal para que o sistema permita atribuir valor de desconto.")   
				
EndCase

Return lRet

//�������������������������������������������������Ŀ
//�Fun��o utilizada no lan�amento Padr�o 651 Seq 009�
//���������������������������������������������������

User Function LP651009(cGrupo,cTpProd,cProd,cSeg)

Local cDebit := SDE->DE_CONTA
Local hEnter	:= CHR(10) + CHR(13)   
	
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
		
If SUBSTR(cGrupo,1,4)='1707'
	cDebit := "3210301014"
	
ElseIf SUBSTR(cGrupo,1,2)='99/98' .AND. !cSeg $'004001001/004001002' 
	cDebit := "3210103027"
	
ElseIf (cTpProd$("ME/MP") .AND. !SUBSTR(cGrupo,1,2) $ '09/10/11/12' .AND. cProd <>"01060005")
	cDebit := "3210103040"
	
ElseIf SUBSTR(cGrupo,1,2)='99/98' .AND. cSeg $ '004001001/004001002'
	cDebit := SD1->D1_CONTA     

ElseIf SUBSTR(cGrupo,1,2) $ '09/10/11/12'.AND. cSeg $ '004001001/004001002'
	cDebit := "3110203022"
	
ElseIf SUBSTR(cGrupo,1,2) $ '09/10/11/12'.AND. !cSeg $ '004001001/004001002'
	cDebit := "3210103076"
EndIf

Return (cDebit) 

//����������������������������������Ŀ
//�Fun��o executada no LP 596 Seq 002�
//������������������������������������

User Function LP596002(cPar01)
Local nVal := 0                      
Local cSql := ""
Local cOrigem := SubStr(cPar01,01,18)
Local aArea := GetArea()

DbSelectArea("SE1")
SE1->(DbSetOrder(1))

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (DbSeek(xFilial("SE1") + cOrigem))

	//�������������������������������������������������������������������������������������Ŀ
	//�Select para retornar o valor do desconto quando for uma compensa��o de t�tulo por NCC�
	//���������������������������������������������������������������������������������������
	
	cSql := "SELECT E5.E5_VLDESCO FROM " + RetSqlName("SE5")+ " E5 " 
	cSql += "WHERE E5.E5_FILIAL  = '"+ SE1->E1_FILIAL +"' "
	cSql += "  AND E5.E5_PREFIXO = '"+ SE1->E1_PREFIXO +"' "
	cSql += "  AND E5.E5_NUMERO  = '"+ SE1->E1_NUM +"' "
	cSql += "  AND E5.E5_PARCELA = '"+ SE1->E1_PARCELA +"' "
	cSql += "  AND E5.E5_CLIFOR  = '"+ SE1->E1_CLIENTE +"' "
	cSql += "  AND E5.E5_LOJA    = '"+ SE1->E1_LOJA +"' "
	cSql += "  AND E5.E5_MOTBX   = 'CMP' "
	cSql += "  AND E5.D_E_L_E_T_ <> '*'	"

	TCQUERY cSql NEW ALIAS "SE5TMP"
	
	DbSelectArea("SE5TMP")
	SE5TMP->(DbGoTop())
	
	if !SE5TMP->(EOF())
		nVal := SE5TMP->E5_VLDESCO	
	EndIf                       
	
	SE5TMP->(DbCloseArea())

EndIf

RestArea(aArea)

Return nVal

//��������������������������������������������������������������������������������Ŀ
//�Fun��o executada no LP 596 Seq 002 para retornar valor do desconto incondicional�
//�do t�tulo de origem.                                                            �
//����������������������������������������������������������������������������������

/* Comentado pois esta dando duplicidade no nome com o LP596002.
User Function LP596002_2(cPar01)
Local nVal := 0
Local cOrigem := SubStr(cPar01,01,18)
Local aArea := GetArea()

DbSelectArea("SE1")
SE1->(DbSetOrder(1))

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

if (DbSeek(xFilial("SE1") + cOrigem))
	nVal := SE1->E1_DECRESC
EndIf

Return nVal  */

//�������������������������������������
//�Rotina QTDE MULTIPLA X PRODUTO (Z53)
//�������������������������������������

User Function MANZ53()
Local cAlias := "Z53"

axCadastro(cAlias)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP597001 �Autor  �Jean Carlos P Saggin � Data �  13/02/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o utilizada no lan�amento padr�o 597 Seq. 001         ���
���          � para retornar natureza do t�tulo de origem.                ���
�������������������������������������������������������������������������͹��
���Uso       � Contabilidade Gerencial                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------*
User Function LP597001()
*------------------------*

Local aArea  := GetArea()
Local cRet   := "" 
Local cChave := SubStr(SE5->E5_DOCUMEN, 01, 18)  // Prefixo + Num + Parcela + Tipo

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("SE2")
SE2->(DbSetOrder(1))
if SE2->(DbSeek(xFilial("SE2") + cChave))
	cRet := SE2->E2_NATUREZ
EndIf

RestArea(aArea)

Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZA5�Autor  �Jean Carlos Saggin      � Data �  28/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Uvas                                           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Dados adicionais do produto                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZA5()
Local cAlias := "ZA5"

AxCadastro(cAlias)

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_RETCHVNF�Autor  �Jean Carlos Saggin  � Data �  05/03/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Retorna Chave da NF-e dos t�tulos que est�o sendo inclusos ���
���          � no border� do contas a receber.                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPECIFICOS CANTU                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
*------------------------*
User Function RETCHVNF()
*------------------------*

Local cRet  := Space(44)
Local aArea := GetArea()

//��������������������������������������������������������������������������Ŀ
//�Posicionamento na tabela SF2 para retornar chave da nota fiscal eletr�nica�
//����������������������������������������������������������������������������
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("SF2")
SF2->(DbSetOrder(1))
If SF2->(DbSeek(SE1->E1_FILIAL + SE1->E1_NUM + SE1->E1_PREFIXO + SE1->E1_CLIENTE + SE1->E1_LOJA))
	If !Empty(SF2->F2_CHVNFE)
		cRet := SF2->F2_CHVNFE 
	Else 
		MsgInfo("Chave da NF-e n�o encontrada para o t�tulo "+ AllTrim(SE1->E1_NUM) +" prefixo "+ AllTrim(SE1->E1_PREFIXO))
	EndIf
EndIf

RestArea(aArea)
Return cRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZC0 �Autor  �Jean Carlos Saggin     � Data �  16/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Manuten��o do cadastro de transportadora x cliente e loja  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICOS CANTU ALIMENTOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*-----------------------*
User Function MANZC0()
*-----------------------*

Private cAliasTmp    := "ZC0"
Private cCadastro  := "Transportador x Cliente"
Private aRotina    := {}

aAdd(aRotina, {"&Pesquisar",  "AxPesqui", 0, 1})
aAdd(aRotina, {"&Visualizar", "AxVisual", 0, 2})
aAdd(aRotina, {"&Incluir",    "U_ZC0Inc", 0, 3})
aAdd(aRotina, {"&Alterar",    "U_ZC0Alt", 0, 4})
aAdd(aRotina, {"&Excluir",    "U_ZC0Del", 0, 5})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())
                                                   
DbSelectArea(cAliasTmp)
(cAliasTmp)->(DbSetOrder(1))

mBrowse(6, 1, 22, 75, cAliasTmp)

Return 

*-------------------------*
User Function ZC0Inc()
*-------------------------*

Local nReg  := (cAliasTmp)->(Recno())
Local aCpos := {"ZC0_FILIAL","ZC0_CODCLI","ZC0_CODLOJ","ZC0_RAZAO","ZC0_CODTRA","ZC0_NOMTRA","ZC0_PRAZO"} 

AxInclui(cAliasTmp,nReg,3,,,aCpos,"U_ZC0TOK()",,,,,,,)

Return                           

*-------------------------*
User Function ZC0TOK()
*-------------------------*

Local lRet    := .T.
Local nPrzTra := 0

nPrzTra := Posicione("SA4", 1, xFilial("SA4") + ZC0->ZC0_CODTRA, "A4_X_PRAZO")

If ZC0->ZC0_PRAZO > nPrzTra
	lRet := MsgYesNo("O prazo de entrega padr�o do transportador � maior do que o prazo "+;
					         "m�dio de entrega acordado com o cliente. Deseja mesmo utilizar esse transportador?","Atencao!")
EndIf

Return lRet                          

*-------------------------*
User Function ZC0Alt()
*-------------------------*

Local nReg  := (cAliasTmp)->(Recno())
Local aCpos := {"ZC0_FILIAL","ZC0_CODCLI","ZC0_CODLOJ","ZC0_RAZAO","ZC0_CODTRA","ZC0_NOMTRA","ZC0_PRAZO"} 

AxAltera(cAliasTmp,nReg,4,,aCpos,,,"U_ZC0TOK()",,,) 

Return

*-------------------------*                               
User Function ZC0Del()
*-------------------------*

Local nReg  := (cAliasTmp)->(Recno())

If MsgYesNo("Deseja realmente apagar essa linha?","Atencao")
	RecLock(cAliasTmp, .F.)
	(cAliasTmp)->(DbDelete())
	(cAliasTmp)->(MsUnLock())
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fValIndic �Autor  �Jean Carlos Saggin  � Data �  29/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o usada pra validar indicador do produto na inclus�o  ���
���          � ou altera��o de uma tabela de pre�o.                       ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICOS CANTU ALIMENTOS                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

*----------------------------------*
User Function fValIndic(cProduto)
*----------------------------------*
           
Local lRet  := .T.
Local aArea := GetArea()

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������

U_USORWMAKE(ProcName(),FunName())

//���������������������������������������������Ŀ
//�Valida exist�ncia de indicador para o produto�
//�����������������������������������������������

DbSelectArea("SBZ") 
SBZ->(DbSetOrder(1))
if !DBSeek(xFilial("SBZ") + cProduto)
	Alert("N�o existe indicador cadastrado para o produto "+ Trim(cProduto) +" na filial "+ xFilial("SBZ") )
	lRet := .F. 
Else

	//���������������������������������������������Ŀ
	//�Valida exist�ncia de saldo inicial do produto�
	//�����������������������������������������������
	
	DbSelectArea("SB9")
	SB9->(DbSetOrder(1))
	If !DbSeek(xFilial("SB9") + SBZ->BZ_COD + SBZ->BZ_LOCPAD )
		Alert("N�o existe saldo inicial para o produto "+ Trim(SBZ->BZ_COD) +" no armaz�m "+ SBZ->BZ_LOCPAD +" na filial "+ xFilial("SB9"))
		lRet := .F.
	EndIf
EndIf

RestArea(aArea)

Return lRet
