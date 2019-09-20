#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"   
#INCLUDE "COLORS.CH" 
#INCLUDE "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFINP03  ºAutor  ³Gustavo Lattmann    º Data ³  09/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina carta desconto fornecedor.                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RJFINP03()

Private cCadastro := "Carta Desconto Fornecedor" //Variavel padrão para o título do mBrowse
Private aRotina	:= MENUDEF() //Variável padrão para as opções do mBrowse


dbSelectArea("Z45")
Z45->(dbsetOrder(1))  
Z45->(dbGoTop())

//Os parametros são padrões do tamanho da tela que abriu
mBrowse(6,1,22,75,"Z45") 

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFINP03  ºAutor  ³Microsiga           º Data ³  11/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MENUDEF()
Local aOpcoes := {}

AADD(aOpcoes, {"Pesquisar"	, "AxPesqui"   		, 0, 1})
AADD(aOpcoes, {"Visualizar"	, "U_2RJFINP03"		, 0, 2})
AADD(aOpcoes, {"Incluir"	, "U_3RJFINP03()"	, 0, 3})
AADD(aOpcoes, {"Excluir"	, "U_5RJFINP03"  	, 0, 5})

Return aOpcoes 

                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MONTAHEADER  ºAutor  ³Microsiga           º Data ³  11/09/16º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MONTAHEADER(cTabela, cNoCampos)

Local aCampos := {}

Default cTabela 	:= ""
Default cNoCampos	:= ""

dbSelectArea("SX3")
SX3->(dbSetOrder(1))
SX3->(dbGoTop())
//Verifica no SX3 registros com o conteúdo cTabela pelo indice 1.
If SX3->(dbSeek(cTabela))
	//Enquanto não for fim de arquivo e o arquivo for igual a tabela (SZ3).
	While SX3->(!EOF()) .And. SX3->X3_ARQUIVO == cTabela
		//Se o campo for usado e que o nível do usuário for maior que o nível do campo e não for os campos
		//passados no cNoCampos (que são os campos que estão no cabeçalho da tela).
		If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. !(ALLTRIM(SX3->X3_CAMPO) $ cNoCampos)
			//Adiciona os campos conforme documentação do aHeader
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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CAD04ALT     ºAutor  ³Gustavo         º Data ³ 05/06/2014   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela alteração, chamado no mBrowse      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function 2RJFINP03(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que será o controle de o usuário confirmou ou não a inclusão
Local oDlg				 //Objeto da tela que esta sendo montada
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z45"

Local aHeader		:= MONTAHEADER(cAlias2,"Z45_DOC/Z45_SERIE/Z45_FORNEC/Z45_LOJA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cDoc		:= Z45->Z45_DOC
Private cSerie		:= Z45->Z45_SERIE
Private cFornece	:= Z45->Z45_FORNEC
Private cLoja		:= Z45->Z45_LOJA

Private VISUAL		:= .T.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .F.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa regras para carregar as informações do grid da interface				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
dbSelectArea("Z45")
Z45->(dbSetOrder(1)) //FILIAL + DOC + SERIE + FORNECEDOR + LOJA
Z45->(dbGoTop())
If Z45->(dbSeek(xFilial("Z45") + cDoc + cSerie + cFornece + cLoja))
	While Z45->(!EOF()) .And. Z45->Z45_FILIAL == xFilial("Z45") .And. Z45->Z45_DOC == cDoc .And. Z45->Z45_SERIE == cSerie .And. Z45->Z45_FORNEC == cFornece
	
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Adiciona item em branco no aCols para vincular as informações do registro posicionado no browse				³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ45 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z45->(FieldGet(nPosZ45))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Atribui .F. para o item do aCols | NÃO DELETADO								³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z45->(dbSkip())
	End
EndIf

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// Montagem dos parâmetros para criação da tela de exibição com redimensionamento automatico     				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Declaração da interface e demais componentes da interface		³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Declaração componentes TSAY/TGET para os campos do cabeçalho da interface		³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oSay1 := TSay():New(010,010,{||"Documento"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay2 := TSay():New(010,090,{||"Serie"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay3 := TSay():New(010,150,{||"Fornecedor"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay4 := TSay():New(010,230,{||"Loja"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	
	
	oGet1 := TGet():New(010,040,{|u|if(PCount()>0, cDoc:=u, cDoc)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
	oGet2 := TGet():New(010,110,{|u|if(PCount()>0, cSerie:=u, cSerie)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSerie",,)
	oGet3 := TGet():New(010,180,{|u|if(PCount()>0, cFornece:=u, cFornece)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFornece",,)	
	oGet4 := TGet():New(010,250,{|u|if(PCount()>0, cLoja:=u, cLoja)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLoja",,)		
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	// Declaração do MSNEWGETDADOS referente ao grid de itens da interface			³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,'AllwaysTrue()','AllwaysTrue()',"",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa método de apresesntação de tela criando à barra de botões				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)})


Return                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³5RJFINP03  ºAutor  ³Gustavo Lattmann   º Data ³  11/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Interface da exclusão de carta de desconto.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function 5RJFINP03(cAlias, nReg, nOpc) 

Local nOpcao		:= 2 //Variavel que será o controle de o usuário confirmou ou não a inclusão
Local oDlg				 //Objeto da tela que esta sendo montada
Local bOk			:= {||(nOpcao := 1, oDlg:End())}
Local bCancel		:= {||oDlg:End()}        
Local cAlias2		:= "Z45"

Local aHeader		:= MONTAHEADER(cAlias2,"Z45_DOC/Z45_SERIE/Z45_FORNEC/Z45_LOJA")
Local aCols			:= {}
Local aSize			:= {}
Local aObjects		:= {}
Local aInfo			:= {}
Local aPosObj		:= {}

Private oBrw1
Private cDoc		:= Z45->Z45_DOC
Private cSerie		:= Z45->Z45_SERIE
Private cFornece	:= Z45->Z45_FORNEC
Private cLoja		:= Z45->Z45_LOJA

Private VISUAL		:= .F.
Private INCLUI		:= .F.
Private ALTERA		:= .F.
Private DELETA		:= .T.

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa regras para carregar as informações do grid da interface				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
dbSelectArea("Z45")
Z45->(dbSetOrder(1)) //FILIAL + DOC + SERIE + FORNECEDOR + LOJA
Z45->(dbGoTop())
If Z45->(dbSeek(xFilial("Z45") + cDoc + cSerie + cFornece + cLoja))
	While Z45->(!EOF()) .And. Z45->Z45_FILIAL == xFilial("Z45") .And. Z45->Z45_DOC == cDoc .And. Z45->Z45_SERIE == cSerie .And. Z45->Z45_FORNEC == cFornece
	
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Adiciona item em branco no aCols para vincular as informações do registro posicionado no browse				³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		AADD(aCols, Array(Len(aHeader) + 1))
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Com base no registro posicionado no SZ3, atualiza os campos do aCols			³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		For nX := 1 To Len(aHeader)
			If aHeader[nX][10] != "V"
				If !EMPTY(nPosZ45 := FieldPos(aHeader[nX][2]))
					aCols[Len(aCols)][nX] := Z45->(FieldGet(nPosZ45))
				EndIf
			Else
				aCols[Len(aCols)][nX] := CriaVar(aHeader[nX,2])
			EndIf
		Next nX
		
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		//Atribui .F. para o item do aCols | NÃO DELETADO								³
		//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
		aCols[Len(aCols)][Len(aHeader) + 1] := .F.
		
		Z45->(dbSkip())
	End
EndIf

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
// Montagem dos parâmetros para criação da tela de exibição com redimensionamento automatico     				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
aSiZe 	:= MsAdvSize()
Aadd(aObjects, {025, 100, .T., .T.})
Aadd(aObjects, {075, 100, .T., .T.})
aInfo 	:= {aSize[1], aSize[2], aSize[3], aSize[4], 2, 2}
aPosObj := MsObjSize(aInfo, aObjects,.T.)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Declaração da interface e demais componentes da interface		³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg := MSDialog():New(aSize[7],0,aSize[6],aSize[5],cCadastro,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Declaração componentes TSAY/TGET para os campos do cabeçalho da interface		³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oSay1 := TSay():New(010,010,{||"Documento"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay2 := TSay():New(010,090,{||"Serie"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay3 := TSay():New(010,150,{||"Fornecedor"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)
	oSay4 := TSay():New(010,230,{||"Loja"},oDlg,,,.F.,.F.,.F.,.T.,CLR_HBLUE,CLR_WHITE,032,008)	
	
	
	oGet1 := TGet():New(010,040,{|u|if(PCount()>0, cDoc:=u, cDoc)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDoc",,)
	oGet2 := TGet():New(010,110,{|u|if(PCount()>0, cSerie:=u, cSerie)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cSerie",,)
	oGet3 := TGet():New(010,180,{|u|if(PCount()>0, cFornece:=u, cFornece)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFornece",,)	
	oGet4 := TGet():New(010,250,{|u|if(PCount()>0, cLoja:=u, cLoja)},oDlg,030,004,"@!",,CLR_HRED,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLoja",,)		
	
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	// Declaração do MSNEWGETDADOS referente ao grid de itens da interface			³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	oBrw1 := MsNewGetDados():New(030,002,aPosObj[2][3],aPosObj[2][4],/*GD_INSERT + GD_UPDATE + GD_DELETE*/,'AllwaysTrue()','AllwaysTrue()',"",,0,99,'AllwaysTrue()','',/*'U_CAD04VDEL()'*/,oDlg,aHeader,aCols)

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//Executa método de apresesntação de tela criando à barra de botões				³
//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
oDlg:Activate(,,,.T.,,,{||EnchoiceBar(oDlg, bOk, bCancel)}) 

If nOpcao == 1
	fExcCarta()
EndIf


Return      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fExcCarta  ºAutor  ³Microsiga           º Data ³  11/09/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função responsável pela exclusão da carta de desconto.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fExcCarta()   

Local nDesc := 0


	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	//Realiza a exclusão de todos os registros existentes atualmente				³
	//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	dbSelectArea("Z45")
	Z45->(dbSetOrder(1))
	Z45->(dbGoTop())
	If Z45->(dbSeek(xFilial("Z45") + cDoc + cSerie + cFornece + cLoja))
		While Z45->(!EOF()) .And. Z45->Z45_FILIAL == xFilial("Z45") .And. Z45->Z45_DOC == cDoc .And. Z45->Z45_SERIE == cSerie .And. Z45->Z45_FORNEC == cFornece
		
			//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			//Efetua à exclusão do registro posicionado										³
			//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
			BEGIN TRANSACTION
				RecLock("Z45", .F.)
					Z45->(DBDELETE())
				Z45->(MSUNLOCK())
			    
			    //-- Calcula o desconto total da carta
				nDesc += Z45->Z45_QTDE * Z45->Z45_DESC
			END TRANSACTION
		Z45->(dbSkip())
		
		EndDo
		
		//-- Diminui o valor do descrecimo no titulo referente a carta
		dbSelectArea("SE2")
		SE2->(dbSetOrder(6))
		SE2->(dbGoTop())
		If SE2->(dbSeek(xFilial("SE2") + cFornece + cLoja + cSerie + cDoc ))
		    //Verificar o saldo
			BEGIN TRANSACTION
				RecLock("SE2", .F.)
					SE2->E2_X_VAUTD -= nDesc
					SE2->E2_DECRESC -= nDesc
					SE2->E2_SDDECRE -= nDesc
				SE2->(MSUNLOCK())
			END TRANSACTION        
		EndIf
						
	EndIf		
			


Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJFINP03    ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de geração/impressão de autorização de desconto sobreº±±
±±º          ³títulos a receber.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 

*-------------------------------*
User Function 3RJFINP03()
*-------------------------------*
Private STRING_NULL := ""
Private cMarca := GetMark()
Private cPerg  := "RJFINP0003"
Private cUSERDESC := ALLTRIM(SuperGetMv("MV_X_NRDES",,"Parametro MV_X_NRDES não cadastrado"))
Private cMAILDESC := ALLTRIM(SuperGetMv("MV_X_ERDES",,"Parametro MV_X_ERDES não cadastrado"))
Private cFAXDESC  := ALLTRIM(SuperGetMv("MV_FAXAUTD", ,"Parametro MV_FAXAUTD não cadastrado"))
Private aDESCONTO := {}
Private aDADOSTIT := {}   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	AjustaSX1()
	If Pergunte(cPerg,.T.)
    	fSelSE2()
	EndIf           
		
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSelSE2     ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para filtro de títulos de acordo com parâmetros.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*------------------------------------------*
Static Function fSelSE2()
*------------------------------------------*
Private cAliasTMP := GetNextAlias()

	cQuery := "	SELECT												"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_PREFIXO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_NUM,										"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_PARCELA,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_TIPO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_FORNECE,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_LOJA,									"+CHR(10)+CHR(13)
	cQuery += "		SA2.A2_NOME,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VALOR,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VENCREA									"+CHR(10)+CHR(13)								
	cQuery += "	FROM " + RetSQLName("SE2") + " SE2          		"+CHR(10)+CHR(13)
	cQuery += "	INNER JOIN " + RetSQLName("SA2") + " SA2			"+CHR(10)+CHR(13)
	cQuery += "	ON 	SE2.E2_FORNECE = SA2.A2_COD						"+CHR(10)+CHR(13)
	cQuery += "	AND	SE2.E2_LOJA    = SA2.A2_LOJA					"+CHR(10)+CHR(13)	
	cQuery += "	WHERE												"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_FILIAL  = '"+xFilial("SE2")+"'			"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.E2_SALDO   > 0 								"+CHR(10)+CHR(13)		
	cQuery += " AND	SE2.E2_EMISSAO BETWEEN '"+ DTOS(mv_par01) +"'	"+CHR(10)+CHR(13)
	cQuery += " AND						   '"+ DTOS(mv_par02) +"'	"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.E2_VENCREA BETWEEN '"+ DTOS(mv_par03) +"'	"+CHR(10)+CHR(13)
	cQuery += " AND						   '"+ DTOS(mv_par04) +"'	"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.E2_FORNECE BETWEEN '"+ mv_par05 +"'			"+CHR(10)+CHR(13)
	cQuery += " AND						   '"+ mv_par06 +"'			"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.E2_LOJA    BETWEEN '"+ mv_par07 +"'			"+CHR(10)+CHR(13)
	cQuery += " AND						   '"+ mv_par08 +"'			"+CHR(10)+CHR(13)
	cQuery += " AND	SE2.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)
	cQuery += " AND	SA2.D_E_L_E_T_ != '*'							"+CHR(10)+CHR(13)	
	cQuery += " ORDER BY											"+CHR(10)+CHR(13)	
	cQuery += "		SA2.A2_NOME,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_FORNECE,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_LOJA,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_EMISSAO,									"+CHR(10)+CHR(13)
	cQuery += "		SE2.E2_VENCREA									"+CHR(10)+CHR(13)								
	
	MemoWrite("RJFINP03.SQL",cQuery)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		aAdd ( aDADOSTIT, { (cAliasTMP)->E2_PREFIXO,;
							(cAliasTMP)->E2_NUM,	;
							(cAliasTMP)->E2_PARCELA,;
							(cAliasTMP)->E2_TIPO,	;							
							(cAliasTMP)->E2_FORNECE,;
							(cAliasTMP)->E2_LOJA,	;
							(cAliasTMP)->A2_NOME,	;
							(cAliasTMP)->E2_VALOR,	;
							(cAliasTMP)->E2_EMISSAO,;
							(cAliasTMP)->E2_VENCREA } )
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())
	
	If Len(aDADOSTIT) > 0
		fMarkSE2(aDADOSTIT)
	Else
		MsgInfo("Nenhum registro foi localizado com os parâmetros informados.")
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSelSE2     ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para marcação de títulos de acordo com parâmetros.   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*---------------------------------*
Static Function fMarkSE2(aDADOSTIT)     
*---------------------------------* 
Private aArea     := GetArea()
Private cEMPEXEC  := cEmpAnt
Private nOpcao    := 0
Private aCampos   := {}
Private lInverte  := .F.    
Private cDlgTitle := "Selecionar Títulos"
Private oDlgFIL

	aStruct := {}
	aAdd( aStruct, {"E2_OK"  	 ,"C", 02, 0} )
	aAdd( aStruct, {"E2_PREFIXO" ,"C", TAMSX3("E2_PREFIXO")[1], 0} )
	aAdd( aStruct, {"E2_NUM" 	 ,"C", TAMSX3("E2_NUM")[1], 	0} )
	aAdd( aStruct, {"E2_PARCELA" ,"C", TAMSX3("E2_PARCELA")[1], 0} )
	aAdd( aStruct, {"E2_TIPO" 	 ,"C", TAMSX3("E2_TIPO")[1], 	0} )
	aAdd( aStruct, {"E2_FORNECE" ,"C", TAMSX3("E2_FORNECE")[1], 0} )
	aAdd( aStruct, {"E2_LOJA" 	 ,"C", TAMSX3("E2_LOJA")[1], 	0} )
	aAdd( aStruct, {"A2_NOME" 	 ,"C", TAMSX3("A2_NOME")[1], 	0} )
	aAdd( aStruct, {"E2_VALOR" 	 ,"N", TAMSX3("E2_VALOR")[1], TAMSX3("E2_VALOR")[2]} )
	aAdd( aStruct, {"E2_EMISSAO" ,"D", 8, 0} )
	aAdd( aStruct, {"E2_VENCREA" ,"D", 8, 0} )		

	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,"TMPSE2", .F.,.F. )
	dbSelectArea("TMPSE2")
	Index on E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA to &cArqTrab


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza temporarios                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aDADOSTIT) > 0
		For nINDFIL := 1 to Len(aDADOSTIT)
		    dbSelectArea("TMPSE2")
		    RecLock("TMPSE2",.T.)
		    TMPSE2->E2_OK	:= Space(02)
		    TMPSE2->E2_PREFIXO	:= aDADOSTIT[nINDFIL,01]
		    TMPSE2->E2_NUM		:= aDADOSTIT[nINDFIL,02]
		    TMPSE2->E2_PARCELA	:= aDADOSTIT[nINDFIL,03]
		    TMPSE2->E2_TIPO		:= aDADOSTIT[nINDFIL,04]		    		    
		    TMPSE2->E2_FORNECE	:= aDADOSTIT[nINDFIL,05]
		    TMPSE2->E2_LOJA		:= aDADOSTIT[nINDFIL,06]
		    TMPSE2->A2_NOME		:= aDADOSTIT[nINDFIL,07]		    		    
		    TMPSE2->E2_VALOR	:= aDADOSTIT[nINDFIL,08]
		    TMPSE2->E2_EMISSAO	:= stod(aDADOSTIT[nINDFIL,09])
		    TMPSE2->E2_VENCREA	:= stod(aDADOSTIT[nINDFIL,10])
		    MsUnLock("TMPSE2")
		Next nINDFIL
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Campos para mostrar no BROWSE padrao                      ³
	//³ Necessario quando usando um arquivo qualquer (sem o SX3)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	AADD(aCampos,{"E2_OK"  		,"" 	," "        	," " })
	AADD(aCampos,{"E2_PREFIXO"	,"" 	,"Prefixo"  	," " })
	AADD(aCampos,{"E2_NUM" 		,"" 	,"Número"  		," " })
	AADD(aCampos,{"E2_PARCELA"	,""		,"Parcela"  	," " })
	AADD(aCampos,{"E2_TIPO"		,"" 	,"Tipo"  		," " })
	AADD(aCampos,{"E2_FORNECE"	,"" 	,"Fornecedor"  	," " })
	AADD(aCampos,{"E2_LOJA"		,"" 	,"Loja"  		," " })
	AADD(aCampos,{"A2_NOME"		,"" 	,"Nome"  		," " })
	AADD(aCampos,{"E2_VALOR"	,"" 	,"Valor"  		," " })
	AADD(aCampos,{"E2_EMISSAO"	,"" 	,"Emissão"  	," " })
	AADD(aCampos,{"E2_VENCREA"	,"" 	,"Vencimento"  	," " })


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Cria dialogo para usuario selecionar as filiais   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("TMPSE2")
	dbGoTop()

	DEFINE MSDIALOG oDlgFIL TITLE cDlgTitle From 1,1 To 400,700 OF oMainWnd PIXEL
	
	oMark := MsSelect():New("TMPSE2","E2_OK",,aCampos,@lInverte,@cMarca,{1,1,180,350})
          
	@ 185,270 BMPBUTTON TYPE 1 ACTION (nOpcao := 1, Close(oDlgFIL) )
	@ 185,300 BMPBUTTON TYPE 2 ACTION (nOpcao := 2, Close(oDlgFIL) )

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fRegSel(oMark, cMarca, oDlgFIL)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(oMark, cMarca, oDlgFIL)}


	ACTIVATE MSDIALOG oDlgFIL CENTERED


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processa filiais selecionadas                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    If nOpcao == 1
	   	aDADOSTIT := {}
	   	dbSelectArea("TMPSE2")
		dbGoTop()
		While ! TMPSE2->(EOF())
	    	If ! Empty(TMPSE2->E2_OK)   	    	
	    		aAdd ( aDADOSTIT, { TMPSE2->E2_PREFIXO, TMPSE2->E2_NUM, TMPSE2->E2_PARCELA, TMPSE2->E2_TIPO, TMPSE2->E2_FORNECE, TMPSE2->E2_LOJA, ;
	    						  	TMPSE2->A2_NOME, TMPSE2->E2_VALOR, TMPSE2->E2_EMISSAO, TMPSE2->E2_VENCREA })
	    	EndIf
	    	TMPSE2->(dbSkip())
	 	Enddo          
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Fecha alias temporarios                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
	dbSelectArea("TMPSE2")
	dbCloseArea("TMPSE2")
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*")
	
	If nOpcao == 1 .and. Len(aDADOSTIT) > 0
		fSetDESC()
	Else
		MsgInfo("Nenhum título foi selecionado.")
	EndIf
	
	RestArea(aArea) 
	
Return 


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Contador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*-----------------------------------------------*
Static Function fRegSel(oMark, cMarca, oDlgFIL)
*-----------------------------------------------*

	If Marked("E2_OK")
		RecLock("TMPSE2",.F.)
		Replace TMPSE2->E2_OK With cMarca
		MsUnlock()
	Else
		RecLock("TMPSE2",.F.)
		Replace TMPSE2->E2_OK With Space(02)
		MsUnlock()
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oDlgFIL:Refresh()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Marcador de registros                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

*------------------------------------------------*
Static Function fMarkAll(oMark, cMarca, oDlgFIL)
*------------------------------------------------*
Local nREC := Recno()    
    
	dbGoTop()
	While !EOF()
		RecLock("TMPSE2",.F.)
		If Empty(TMPSE2->E2_OK)
			Replace TMPSE2->E2_OK With cMarca
		Else
			Replace TMPSE2->E2_OK With Space(02)
		Endif
		MsUnlock()
		dbSkip()
	EndDo  
	
	dbGoTo(nREC)
	oMark:oBrowse:Refresh(.t.)
	oDlgFIL:Refresh()

Return .T. 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fSetDESC    ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para definição de descontos sobre itens do documento.º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------------*
Static Function fSetDESC() 
*------------------------------------------------*
Private aCols := {}
Private aHeader := {}
Private nVALDESC := 0
Private cHISTADE := Space(200)
Private oGETDESC
Private oGETHIST

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta janela com titulos selecionados para edicao de valores  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("D1_ITEM")                                                                                         
	AADD(aHeader,{ TRIM("Item")			, x3_campo, x3_picture, TAMSX3("D1_ITEM")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Produto")		, x3_campo, x3_picture, TAMSX3("D1_COD")[1]		, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Descrição")	, x3_campo, x3_picture, TAMSX3("D1_DESCRI")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Quantidade")	, x3_campo, x3_picture, TAMSX3("D1_QUANT")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Vlr.Unitário")	, x3_campo, x3_picture, TAMSX3("D1_VUNIT")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	AADD(aHeader,{ TRIM("Vlr.Total")	, x3_campo, x3_picture, TAMSX3("D1_TOTAL")[1]	, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	dbSeek("D1_VALDESC")
	AADD(aHeader,{ TRIM("Desc.Unitário"), x3_campo, x3_picture, x3_tamanho, x3_decimal, x3_valid, x3_usado, x3_tipo, x3_arquivo, x3_context } )	        	   	
	
	For nQ := 1 to Len(aDADOSTIT)
                   
		aCols := {}
		dbSelectArea("SD1")
		dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM 
		dbGoTop()
		dbSeek( xFilial("SD1")+aDADOSTIT[nQ,02]+aDADOSTIT[nQ,01]+aDADOSTIT[nQ,05]+aDADOSTIT[nQ,06] )
		While !SD1->(EOF()) .and. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == xFilial("SD1")+aDADOSTIT[nQ,02]+aDADOSTIT[nQ,01]+aDADOSTIT[nQ,05]+aDADOSTIT[nQ,06]
			aAdd ( aCols, {SD1->D1_ITEM, SD1->D1_COD, SD1->D1_DESCRI, SD1->D1_QUANT, SD1->D1_VUNIT, SD1->D1_TOTAL, SD1->D1_X_VUNAD, SD1->D1_EMISSAO } )
			SD1->(dbSkip())
		Enddo
	                       
		dbSelectArea("SE2")
		dbSetOrder(1)  //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                    
		dbGoTop()
		If dbSeek ( xFilial("SE2") + aDADOSTIT[nQ,01] + aDADOSTIT[nQ,02] + aDADOSTIT[nQ,03] + aDADOSTIT[nQ,04] + aDADOSTIT[nQ,05] + aDADOSTIT[nQ,06] )
			If !Empty(SE2->E2_X_HAUTD)
				cHISTADE :=	SE2->E2_X_HAUTD
			Else
				cHISTADE := Space(200)
			EndIf
		Else
			cHISTADE := Space(200)
		EndIf
                       
	                           
		If Len(aCols) > 0
		                           
			nOpcao   := 0
			nVALDESC := 0
		cDOCUMEN := aDADOSTIT[nQ,02]+"/"+aDADOSTIT[nQ,01]
			cFORNECE := aDADOSTIT[nQ,05]+"/"+aDADOSTIT[nQ,06]+"-"+aDADOSTIT[nQ,07]			
			fCalcDESC(@nVALDESC,oGETDESC,aCols,.F.)
			
			@ 001,001 TO 425,700 DIALOG oDlgMULTI TITLE "Desconto sobre itens do documento"
			@ 006,005 SAY "Fornecedor: " SIZE 040,010 OF oDlgMULTI PIXEL 
			@ 005,050 GET oGET VAR cFORNECE SIZE 150,010 OF oDlgMULTI PIXEL WHEN .F.
			@ 006,210 SAY "Documento: " SIZE 040,010 OF oDlgMULTI PIXEL 
			@ 005,250 GET oGET VAR cDOCUMEN SIZE 050,010 OF oDlgMULTI PIXEL WHEN .F.
			@ 020,005 TO 170,345 MULTILINE MODIFY VALID fCalcDESC(@nVALDESC,oGETDESC,aCols,.T.) 
			@ 181,005 SAY "Total do desconto: R$ " SIZE 060,010 OF oDlgMULTI PIXEL 
			@ 180,070 GET oGETDESC VAR nVALDESC SIZE 050,010 PICTURE "@E 999,999.99" OF oDlgMULTI PIXEL WHEN .F.
			@ 196,005 SAY "Histórico: " SIZE 060,010 OF oDlgMULTI PIXEL 
			@ 195,070 GET oGETHIST VAR cHISTADE SIZE 200,010 OF oDlgMULTI PIXEL WHEN .T.

			@ 195,280 BMPBUTTON TYPE 1 ACTION (nOpcao := 1, Close(oDlgMULTI) )
			@ 195,310 BMPBUTTON TYPE 2 ACTION (nOpcao := 2, Close(oDlgMULTI) )			
			
			ACTIVATE DIALOG oDlgMULTI CENTERED
			
			If nOpcao == 1
				For nR := 1 to Len(aCols)
					If aCols[nR,07] > 0
						/*	1-DOC		2-SERIE		3-FORNECE		4-LOJA		5-ITEM		6-CODIGO	
							7-DESCRICAO		8-QUANT		9-VALOR UN	10-VAL DESC	11-EMISSAO	12-TOTAL DESC.	13-POSICAO TIT 14-HIST TIT*/
						nVALTOT := aCols[nR,07]*aCols[nR,04]
						aAdd ( aDESCONTO, { aDADOSTIT[nQ,02], 	;
											aDADOSTIT[nQ,01], 	;
											aDADOSTIT[nQ,05], 	;
											aDADOSTIT[nQ,06], 	;
											aCols[nR,01], 		;
											aCols[nR,02], 		;
											aCols[nR,03], 		;
											aCols[nR,04], 		;
											aCols[nR,05], 		;
											aCols[nR,07], 		;
											aCols[nR,08],		;
											nVALTOT,			;
											nQ,					;
											cHISTADE } )						
						
					EndIf
				Next nR
			EndIf
			
		EndIf
	
	Next nQ 
	
	If Len(aDESCONTO) > 0
		Begin Transaction
		For nT := 1 to Len(aDESCONTO)
			dbSelectArea("SD1")
			dbSetOrder(1)	//D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM 
			dbGoTop()
			If dbSeek( xFilial("SD1")+aDESCONTO[nT,01]+aDESCONTO[nT,02]+aDESCONTO[nT,03]+aDESCONTO[nT,04]+aDESCONTO[nT,06]+aDESCONTO[nT,05] )
				If RecLock("SD1",.F.)
					SD1->D1_X_VUNAD := aDESCONTO[nT,10]
					SD1->(MsUnLock())
				EndIf
			EndIf			
		Next nT
		End Transaction
		fImpAUTDES()
	EndIf

		

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCalcDESC   ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para calculo do desconto total sobre o documento.    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------------*
Static Function fCalcDESC(nVALDESC,oGETDESC,aCols,lUpd)
*-------------------------------------------------------*
	
	nVALDESC := 0
	For nI := 1 to Len(aCols)
		nVALDESC += aCols[nI][04]*aCols[nI][07]
	Next nI 
	If lUpd
		oGETDESC:Refresh()
	EndIf

Return .T.   

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fImpAUTDES  ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para impressão da autorização de desconto.           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------------------------------*
Static Function fImpAUTDES()
*--------------------------------------------------*
Local lBold	     := .T.
Local lUnderLine := .T.
Local dDtDoc

Private oFont07B := TFont():New( "Arial",,07,,lBold,,,,,!lUnderLine )
Private oFont08B := TFont():New( "Arial",,08,,lBold,,,,,!lUnderLine )
Private oFont09B := TFont():New( "Arial",,09,,lBold,,,,,!lUnderLine )
Private oFont10B := TFont():New( "Arial",,10,,lBold,,,,,!lUnderLine )
Private oFont11B := TFont():New( "Arial",,11,,lBold,,,,,!lUnderLine )
Private oFont13B := TFont():New( "Arial",,13,,lBold,,,,,!lUnderLine )
Private oFont12B := TFont():New( "Arial",,12,,lBold,,,,,!lUnderLine )
Private oFont14B := TFont():New( "Arial",,14,,lBold,,,,,!lUnderLine )

Private oFont07N := TFont():New( "Arial",,07,,!lBold,,,,,!lUnderLine )
Private oFont08N := TFont():New( "Arial",,08,,!lBold,,,,,!lUnderLine )
Private oFont09N := TFont():New( "Arial",,09,,!lBold,,,,,!lUnderLine )
Private oFont10N := TFont():New( "Arial",,10,,!lBold,,,,,!lUnderLine )
Private oFont11N := TFont():New( "Arial",,11,,!lBold,,,,,!lUnderLine )
Private oFont13N := TFont():New( "Arial",,13,,!lBold,,,,,!lUnderLine )
Private oFont12N := TFont():New( "Arial",,12,,!lBold,,,,,!lUnderLine )
Private oFont14N := TFont():New( "Arial",,14,,!lBold,,,,,!lUnderLine )

Private nLin := 50
Private nCol := 50

	oPrn  := TMSPrinter():New()
	//oPen  := TPen():New(,7,CLR_BLACK,oPrn)
	
	oPrn:SetPortrait()
	oPrn:Setup()

    cDOC := STRING_NULL
	For nY := 1 to Len(aDESCONTO)
	
		If cDOC != aDESCONTO[nY,01]+aDESCONTO[nY,02]+aDESCONTO[nY,03]+aDESCONTO[nY,04]

		 	If cDOC != STRING_NULL
				oPrn:EndPage()
			EndIf                                                                                    
			
			cDOC := aDESCONTO[nY,01]+aDESCONTO[nY,02]+aDESCONTO[nY,03]+aDESCONTO[nY,04]              
			
			oPrn:StartPage()
			nLin := 50
			nCol := 50
	
			//SUPERIOR
			oPrn:Line( 0030, 0030, 0030, 2300 )
			//SUPERIOR TITULO	
			oPrn:Line( 0200, 0030, 0200, 2300 )
			//ESQUERDO
			oPrn:Line( 0030, 0030, 3200, 0030 )
			//DIREITO
			oPrn:Line( 0030, 2300, 3200, 2300 )
			//INFERIOR
			oPrn:Line( 3200, 0030, 3200, 2300 )
			
			dbSelectArea("SA2")
			dbSetOrder(1)
			dbGoTop()
			dbSeek ( xFilial("SA2") + aDESCONTO[nY,03] + aDESCONTO[nY,04] )
			
		  	// TITULO
		 	oPrn:SayBitmap( nLin, 100, "logo"+cEmpAnt+".bmp", 200, 080 )                    
			oPrn:Say( nLin, 0560, "DE: "+ALLTRIM(UPPER(SM0->M0_NOME))+" - " + ALLTRIM(UPPER(SM0->M0_CIDCOB))+ "/" + SM0->M0_ESTCOB + " - FONE/FAX: " + SM0->M0_TEL, oFont11B, 100 )
			nLin += 080
			oPrn:Say( nLin, 0560, "PARA: "+ALLTRIM(UPPER(SA2->A2_NOME)), oFont11B, 100 )
			
			nLin += 150
			nCol := 720
			oPrn:Say( nLin, nCol, "AUTORIZAÇÃO DE DESCONTO", oFont14B, 100 )
		
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ DADOS DA EMPRESA		                                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nLin += 150
			nCol := 100
			oPrn:Say( nLin, nCol, "A empresa "+UPPER(ALLTRIM(SM0->M0_NOMECOM))+"," , oFont11N, 100 )		
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "da qual V.Sa. é fornecedor de mercadorias, solicita desconto referente a Nota Fiscal descriminada abaixo:" , oFont11N, 100 )

			nLin += 100                                                                    
			nCol := 120
			oPrn:Say( nLin, nCol, "NFE" , oFont11N, 100 )				
			nCol += 250                                                                                 
			oPrn:Say( nLin, nCol, "EMISSÃO" , oFont11N, 100 )				
			nCol += 250                                                                                 
			oPrn:Say( nLin, nCol, "PRODUTO" , oFont11N, 100 )				
			nCol += 500                                                                                 
			oPrn:Say( nLin, nCol, "QUANT." , oFont11N, 100 )				
			nCol += 250                                                                                 
			oPrn:Say( nLin, nCol, "PREÇO" , oFont11N, 100 )				
			nCol += 250                                                                                 
			oPrn:Say( nLin, nCol, "FICA POR" , oFont11N, 100 )				
			nCol += 250                                                                                 
			oPrn:Say( nLin, nCol, "DESCONTO" , oFont11N, 100 )				
			nLin += 080                                                                    

			/*	1-DOC		2-SERIE		3-FORNECE		4-LOJA		5-ITEM		6-CODIGO	
				7-DESCRICAO		8-QUANT		9-VALOR UN	10-VAL DESC	11-EMISSAO	12-TOTAL DESC.	13-POSICAO TIT */


			nTOTALDESC := 0
			For nR := nY to Len(aDESCONTO)
				If cDOC != aDESCONTO[nR,01]+aDESCONTO[nR,02]+aDESCONTO[nR,03]+aDESCONTO[nR,04]					
					Exit
				EndIf      
				nCol := 120
				oPrn:Say( nLin, nCol, aDESCONTO[nR,01] , oFont10N, 100 )				
				nCol += 250                                                                                 
				oPrn:Say( nLin, nCol, DTOC(aDESCONTO[nR,11]) , oFont10N, 100 )				
				nCol += 250                                                                                 
				oPrn:Say( nLin, nCol, SubSTR(aDESCONTO[nR,07],1,22) , oFont10N, 100 )				
				nCol += 510                                                                                 
				oPrn:Say( nLin, nCol, TRANSFORM(aDESCONTO[nR,08],"@E 999999.99") , oFont10N, 100 )				
				nCol += 260                                                                                 
				oPrn:Say( nLin, nCol, TRANSFORM(aDESCONTO[nR,09],"@E 999,999.99") , oFont10N, 100 )				
				nCol += 260                                                                                 
				oPrn:Say( nLin, nCol, TRANSFORM(aDESCONTO[nR,09]-aDESCONTO[nR,10],"@E 999,999.99"), oFont10N, 100 )				
				nCol += 260                                                                                 
				oPrn:Say( nLin, nCol, TRANSFORM(aDESCONTO[nR,12],"@E 999,999.99") , oFont10N, 100 )				
				nTOTALDESC += aDESCONTO[nR,12]
				nLin += 060 
								
			Next nR
			
			nLin += 080             
			nCol := 100                                                                     
			oPrn:Say( nLin, nCol, "O desconto será aplicado sobre o(s) produto(s) descrito(s) referente ao valor combinado com o comprador." , oFont11N, 100 )
					
			nLin += 080                                                                                  
			oPrn:Say( nLin, nCol, "Solicitamos o desconto de R$ "  + TRANSFORM(nTOTALDESC,"@E 999,999.99"), oFont12N, 100 )
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "(" + ALLTRIM(Extenso(nTOTALDESC)) + ")." , oFont12N, 100 )
			nLin += 100                                                                                  
			oPrn:Say( nLin, nCol, "Sobre o valor total da nota fiscal, que será aplicado quando do pagamento das mercadorias pelo departamento financeiro." , oFont11N, 100 )
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "Por questão de ordem, seu pagamento será confirmado junto ao financeiro da empresa somente após a devolução deste " , oFont11N, 100 )
			nLin += 060                                                                                  
			oPrn:Say( nLin, nCol, "documento assinado por V.Sa." , oFont11N, 100 )
	
			nLin += 080                                                                                  
			oPrn:Say( nLin, nCol, "Favor enviar esta autorização assinada A/C de "+cUSERDESC+;
														" no FAX número: "+cFAXDESC+", ou para o e-mail: " , oFont11N, 100 )
			nLin += 060                                                                                   
			oPrn:Say( nLin, nCol, cMAILDESC , oFont11N, 100 )
	        
	        cHISTDESC := ALLTRIM(aDESCONTO[nY,14])
			If cHISTDESC != STRING_NULL
				nLin += 080                                                                                  
				If Len(cHISTDESC) <= 100
					oPrn:Say( nLin, nCol, "Observações: "+cHISTDESC , oFont11N, 100 )
				Else                                                                 
					oPrn:Say( nLin, nCol, "Observações: "+SubSTR(cHISTDESC,1,100) , oFont11N, 100 )
					nLin += 060
					oPrn:Say( nLin, nCol, SubSTR(cHISTDESC,101,Len(cHISTDESC)), oFont11N, 100 )
				EndIf
			EndIf
			
			nLin += 150
			nCol := 200                                                                                  
			oPrn:Say( nLin, nCol, ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB+", " + StrZero(Day(ddatabase),2) + " de " + MesExtenso(MONTH(ddatabase)) + " de "+STR(YEAR(ddatabase),4) , oFont12N, 100 )
	
			nLin += 200
			nCol := 560                                                                                  
			oPrn:Say( nLin, nCol, Replicate("_",50) , oFont10N, 100 )
			nLin += 060
			nCol := 600                                                                                  
			oPrn:Say( nLin, nCol, ALLTRIM(UPPER(SM0->M0_NOMECOM)) , oFont10N, 100 )
	
	
			nLin += 200
			nCol := 560                                                                                  
			oPrn:Say( nLin, nCol, Replicate("_",50) , oFont10N, 100 )
			nLin += 060
			nCol := 600                                                                                  
			oPrn:Say( nLin, nCol, ALLTRIM(UPPER(SA2->A2_NOME)) , oFont10N, 100 )
	
	
			nLin += 200
			nCol := 600                                                                                  
			oPrn:Say( nLin, nCol, ALLTRIM(UPPER(SM0->M0_NOMECOM)) , oFont10N, 100 )
			nCol := 610
			nLin += 060
			oPrn:Say( nLin, nCol, ALLTRIM(UPPER(SM0->M0_ENDCOB))+", CEP: "+SM0->M0_CEPCOB+", "+ALLTRIM(SM0->M0_CIDCOB)+"/"+SM0->M0_ESTCOB , oFont10N, 100 )
			nCol := 620
			nLin += 060
			oPrn:Say( nLin, nCol, "CNPJ: "+SM0->M0_CGC+" IE: "+SM0->M0_INSC , oFont10N, 100 )
			
			//-- Atualiza decrescimo sobre o título --//
			dbSelectArea("SE2")
			dbSetOrder(1)  //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                    
			dbGoTop()
			If dbSeek ( xFilial("SE2") + aDADOSTIT[aDESCONTO[nY,13],01] + aDADOSTIT[aDESCONTO[nY,13],02] + aDADOSTIT[aDESCONTO[nY,13],03] + ;
						aDADOSTIT[aDESCONTO[nY,13],04] + aDADOSTIT[aDESCONTO[nY,13],05] + aDADOSTIT[aDESCONTO[nY,13],06] )
				If RecLock("SE2",.F.)
					SE2->E2_X_VAUTD += nTOTALDESC
					SE2->E2_DECRESC += nTOTALDESC
					SE2->E2_SDDECRE += nTOTALDESC
					SE2->E2_X_HAUTD += aDESCONTO[nY,14]
					SE2->(MsUnLock())					
				EndIf
			EndIf 
		EndIf				
 	Next nY
 	
  // FOR criado para gravar todos os dados na tabela Z45 - Alessandro 02/06/2012   
  
	For nY := 1 to Len(aDESCONTO)
		DbSelectArea("Z45")
		Z45->(DbSetOrder(1))
		If !DbSeek(xFilial("Z45") + aDADOSTIT[aDESCONTO[nY,13],01] + aDADOSTIT[aDESCONTO[nY,13],02] + aDADOSTIT[aDESCONTO[nY,13],05] +;
				aDADOSTIT[aDESCONTO[nY,13],06] )
			RecLock("Z45", .T.)
			Z45->Z45_FILIAL := xFilial("SE2")
			Z45->Z45_SERIE  := aDADOSTIT[aDESCONTO[nY,13],01]
			Z45->Z45_DOC    := aDADOSTIT[aDESCONTO[nY,13],02]
		 	Z45->Z45_DESC	:= aDESCONTO[nY, 10]
			Z45->Z45_FORNEC := aDADOSTIT[aDESCONTO[nY,13],05]
			Z45->Z45_LOJA   := aDADOSTIT[aDESCONTO[nY,13],06]
			
			dDtDoc := Posicione("SF1", 1, xFilial("SF1") + aDADOSTIT[aDESCONTO[nY,13],02] + aDADOSTIT[aDESCONTO[nY,13],01] +; 
													aDADOSTIT[aDESCONTO[nY,13],05] + aDADOSTIT[aDESCONTO[nY,13],06], "F1_EMISSAO")
													
			Z45->Z45_DTDOC	:= dDtDoc
			Z45->Z45_DTCART	:= dDatabase
			Z45->Z45_PRODUT	:= aDESCONTO[nY,6]
			Z45->Z45_QTDE	:= aDESCONTO[nY,8]
			Z45->Z45_PRECO	:= aDESCONTO[nY,9]
				                                            
			Z45->(MsUnlock())
			
		EndIf
	Next ny	
		 
	If cDOC != STRING_NULL
		oPrn:EndPage()
		oPrn:Preview()
	EndIf

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AjustaSX1   ºAutor  ³Rafael Parma      º Data ³  13/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para criação de parâmetros para rotina.              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
*-----------------------------*
Static Function AjustaSX1()
*-----------------------------*
aRegs  := {} 
aAdd(aRegs,{cPerg,"01","Emissão De      ?","Emissão De      ?","Emissão De      ?","mv_ch1","D",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"02","Emissão Até     ?","Emissão Até     ?","Emissão Até     ?","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"03","Vencimento De   ?","Vencimento De   ?","Vencimento De   ?","mv_ch3","D",8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"04","Vencimento Até  ?","Vencimento Até  ?","Vencimento Até  ?","mv_ch4","D",8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"05","Fornecedor De   ?","Fornecedor De   ?","Fornecedor De   ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","",""})
aAdd(aRegs,{cPerg,"06","Fornecedor Até  ?","Fornecedor Até  ?","Fornecedor Até  ?","mv_ch5","C",TAMSX3("A2_COD")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "SA2","","",""})
aAdd(aRegs,{cPerg,"07","Loja De         ?","Loja De         ?","Loja De         ?","mv_ch6","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
aAdd(aRegs,{cPerg,"08","Loja Até        ?","Loja Até        ?","Loja Até        ?","mv_ch7","C",TAMSX3("A2_LOJA")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

Return Nil
