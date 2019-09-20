#include "rwmake.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "TBICONN.CH"
#include "colors.ch"


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AltPedSIM  Autor ³ Adriano Novachaelley Data ³  20/01/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Alterar Status do pedido de -1 para 0. Status que permite   ±±
±±º          ³ que o Protheus re-importe o pedido de venda.               º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico para Cantu                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Faz a reimportação de pedido de venda que deram erro
User Function AltPedSIM(lExclui)
ManPedSIM(.F.)                   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

// Função para excluir os pedidos do sim3g que deram erro
// Flavio - 08/07/2011
User Function ExcPedSIM()
ManPedSIM(.T.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

/********************************************************************************************************************************/
/********************************************************************************************************************************/

Static Function ManPedSIM(lExclui) 
Local cDlgTitle := ""
Local aCampos   := {}
Local cMarca    := GetMark()
Local lInverte  := .f.     
LOCAL nOpca		:= 2
Local aArea		:= GetArea()

Private lEmProc := .F.
Private oMark
_aCampos 		:= {}

AADD(_aCampos,{ "OK"       , "C" ,02,0 } )  //
AADD(_aCampos,{ "DATAPED"  , "D" ,08,0 } ) 
AADD(_aCampos,{ "NUMPED"   , "C" ,15,0 } )  // NUMEROPEDIDO
AADD(_aCampos,{ "CLIENTE"  , "C" ,09,0 } )  // CODIGO CLIENTE
AADD(_aCampos,{ "LOJA"     , "C" ,04,0 } )  // LOJA CLIENTE
AADD(_aCampos,{ "NOMECLI"  , "C" ,50,2 } )  // Nome Cliente
AADD(_aCampos,{ "IDPEDIDO" , "N" ,14,0 } )  // ID Pedido
_cArqTrb1  := CriaTrab(_aCampos)
_cArqInd1  := CriaTrab(NIL,.F.)

dbUseArea( .T.,,_cArqTrb1,"TRPED",.F. )
dbSelectArea("TRPED")
_cChave1  := "NUMPED"
IndRegua("TRPED",_cArqInd1,_cChave1,,,"Selecionando Registros...")
dbSelectArea("TRPED")
  
aCampos := {}
AADD(aCampos,{"OK"       ,"" ,"Ok"           ," " })
AADD(aCampos,{"DATAPED"  ,"" ,"Data Pedido"  ," " })
AADD(aCampos,{"NUMPED"   ,"" ,"Pedido"       ," " })
AADD(aCampos,{"CLIENTE"  ,"" ,"Codigo"       ," " })
AADD(aCampos,{"LOJA"     ,"" ,"Loja"         ," " })
AADD(aCampos,{"NOMECLI"  ,"" ,"Nome cliente" ," " })
AADD(aCampos,{"IDPEDIDO" ,"" ,"ID Pedido"    ," " })


DEFINE MSDIALOG oDlg TITLE cDlgTitle From 3,1 To 450,800 OF oMainWnd PIXEL
    
@ 013,001 TO 74,400

@ 020,002 Say OemToAnsi("Selecione os pedidos que deseja " + if(lExclui, "Excluir", "importar novamente"))

@ 020,160 CHECKBOX "Em Processamento" VAR lEmProc
@ 020,220 BUTTON "Atualiza" Size 40, 10 Action SelDados()
if !lExclui	
	@ 020,280 BUTTON "Ver produtos" Size 40, 10 Action EditaIT()
EndIf

oMark := MsSelect():New("TRPED","OK",,aCampos,@lInverte,@cMarca,{035,1,220,400})
ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:oBrowse:lhasMark = .T.
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:Refresh()           
SelDados()
ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER

IF (nOpca == 1)
//	Alert("Update não habilitado.") // Remover após habilitar e efetuar teste do UPDATE abaixo comentado.
	_nPedAtu	:= 0
 	TRPED->(DbSelectArea("TRPED"))
  	TRPED->(DbGotop())
  	While !TRPED->(Eof())
		If TRPED->(Marked("OK"))
//			Habilitar para atualizar pedidos
			cSql := "UPDATE PEDIDO SET idnpedidolido = " + if(lExclui, "-2 ", "0 ")
			cSql += "WHERE NUMEROPEDIDO = '"+AllTrim(TRPED->NUMPED)+"' "
			cSql += "AND SubStr(IDLOCALFILIALFATURAMENTO, 1, 2) = '"+cEmpAnt+"' " 
			cSql += "AND SubStr(IDLOCALFILIALFATURAMENTO, 4, 2) = '"+cFilAnt+"' " 
			cSql += "AND SubStr(IDLOCAL,1,9) = '"+TRPED->CLIENTE+"' "
			cSql += "AND SubStr(IDLOCAL,11,4) = '"+TRPED->LOJA+"' "
			TCSqlExec(cSql) // Executa update. 
			_nPedAtu += 1
		Endif
		TRPED->(DbSkip())	
	End     	
	MsgInfo(AllTrim(Str(_nPedAtu))+" PEDIDOS FORAM ATUALIZADOS")
  	TRPED->(DbSelectArea("TRPED"))
	TRPED->(DbCloseArea()) 
	RestArea(aArea)	
Else 
  TRPED->(DbSelectArea("TRPED"))
	TRPED->(DbCloseArea()) 
	RestArea(aArea)
Endif

Return 

/********************************************************************************************************************************/
/********************************************************************************************************************************/

// Seleção de dados
Static Function SelDados()
Local lRet	:= .T.

dlgRefresh(oDlg)

cSql := "SELECT PED.NUMEROPEDIDO as NUMPED, TO_CHAR(DATAPEDIDO, 'YYYYMMDD') AS DATAPED, PED.VALORTOTAL AS TOTAL, A1.A1_COD, A1.A1_LOJA ,A1.A1_NOME, PED.IDPEDIDO "
cSql += "FROM PEDIDO PED, "+RetSqlName("SA1")+" A1 "
cSql += "WHERE A1.D_E_L_E_T_ <> '*' AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
cSql += "AND A1.A1_COD = SubStr(PED.IDLOCAL,1,9) AND A1.A1_LOJA = SubStr(PED.IDLOCAL,11,4)  " 
cSql += "AND (idnpedidolido = -1 " + iif(lEmProc, " or idnpedidolido = 2)", ")")
cSql += "AND SubStr(PED.IDLOCALFILIALFATURAMENTO, 1, 2) = '"+cEmpAnt+"' " // Empresa Atual
cSql += "AND SubStr(PED.IDLOCALFILIALFATURAMENTO, 4, 2) = '"+cFilAnt+"' " // Filial Atual
cSql += "ORDER BY PED.NUMEROPEDIDO "

TCQUERY cSql NEW ALIAS "TMPPED"
   
DbSelectArea("TMPPED")
TMPPED->(DbGotop())           

aCampos := {}
AADD(aCampos,{"OK"       ,"" ,"Ok"           ," " })
AADD(aCampos,{"DATAPED"  ,"" ,"Data Pedido"  ," " })
AADD(aCampos,{"NUMPED"   ,"" ,"Pedido"       ," " })
AADD(aCampos,{"CLIENTE"  ,"" ,"Codigo"       ," " })
AADD(aCampos,{"LOJA"     ,"" ,"Loja"         ," " })
AADD(aCampos,{"NOMECLI"  ,"" ,"Nome cliente" ," " })
AADD(aCampos,{"IDPEDIDO" ,"" ,"ID Pedido"    ," " })

dbSelectArea("TRPED")
Zap

While !TMPPED->(Eof())
	TRPED->(RecLock("TRPED", .T.))
	TRPED->CLIENTE	:= TMPPED->A1_COD
	TRPED->LOJA		  := TMPPED->A1_LOJA
	TRPED->NUMPED	  := TMPPED->NUMPED
	TRPED->NOMECLI	:= TMPPED->A1_NOME
	TRPED->IDPEDIDO := TMPPED->IDPEDIDO
	TRPED->DATAPED  := SToD(TMPPED->DATAPED)
	TRPED->(MsUnlock("TRPED"))
	TMPPED->(DbSkip())                                                                                                       
End
TMPPED->(DbSelectArea("TMPPED"))
TMPPED->(DbCloseArea()) 

TRPED->(DbSelectArea("TRPED"))
TRPED->(DbGotop())

ObjectMethod(oMark:oBrowse,"Refresh()")

Return

 
/********************************************************************************************************************************/
/********************************************************************************************************************************/

// Função que faz a edição dos itens, permitindo excluir algum produto que esteja com problema
Static Function EditaIT()
Local oDlg2
Local oMSNewGe1
Local lCont := .F.
Local cSql := ""
Local aColsEx := {}
Local aHeaderEx := {}

Aadd(aHeaderEx, {"Id Item","IDITEM","@E 9999999999",16,0,"","","N"})
Aadd(aHeaderEx, {"Codigo","IDPRODUTO","@E 9999999999",15,0,"","","C"})
Aadd(aHeaderEx, {"Descrição","B1_DESC","@!",60,0,"","","C"})
Aadd(aHeaderEx, {"Quantidade","QUANTIDADE","@E 99,999.99999",12,5,"","","N"})
Aadd(aHeaderEx, {"Preço Unit","PRECOVENDA","@E 99,999.99999",12,5,"","","N"})
Aadd(aHeaderEx, {"Unidade","UNIDADE","@!",4,0,"","","C"})
Aadd(aHeaderEx, {"Qtd Seg. UM.","QTDSEGUN","@E 99,999.99999",12,5,"","","N"})
Aadd(aHeaderEx, {"Lote","LOTE","@!",15,0,"","","C"})

cSql := "SELECT IDPEDIDOPRODUTO AS IDITEM, IDPRODUTO, QUANTIDADE, PRECOVENDA, IDEMBALAGEMCOMERCIALIZADA as UNIDADE, QUANTIDADEUNIT AS QTDSEGUN, LOTE "
cSql += " FROM PEDIDOPRODUTO WHERE IDPEDIDO = "  + AllTrim(Str(TRPED->IDPEDIDO,0)) + " AND (IDNEXCLUIDOERP <> 1 OR IDNEXCLUIDOERP IS NULL)"
TcQuery cSql New Alias "TMPITE"

SB1->(dbSetOrder(01))

if TMPITE->(!Eof())
	While TMPITE->(!Eof())
		aCol := {}
		aAdd(aCol, TMPITE->IDITEM)
		aAdd(aCol, TMPITE->IDPRODUTO)
		SB1->(dbSeek(xFilial("SB1") + AllTrim(TMPITE->IDPRODUTO)))
		aAdd(aCol, SB1->B1_DESC)
		aAdd(aCol, TMPITE->QUANTIDADE)
		aAdd(aCol, TMPITE->PRECOVENDA)
		aAdd(aCol, iif(Empty(TMPITE->UNIDADE), SB1->B1_UM, TMPITE->UNIDADE))
		aAdd(aCol, TMPITE->QTDSEGUN)
		aAdd(aCol, TMPITE->LOTE)
		
		aAdd(aCol, .F.)
		aAdd(aColsEx, aCol)
		
		TMPITE->(dbSkip())
	EndDo
else
	aAdd(aColsEx, {0, "", "", 0, 0, "", 0, "", .F.}	)
EndIf

TMPITE->(dbCloseArea())

DEFINE MSDIALOG oDlg2 TITLE "Itens do pedido" From 3,1 To 355,700 OF oMainWnd PIXEL
    
@ 013,001 TO 74,350

@ 020,002 Say OemToAnsi("Exclua os itens com problema.")

oMSNewGe1 := MsNewGetDados():New( 015, 001, 179, 348, GD_DELETE, "AllwaysTrue", "AllwaysTrue", "", {}, 0, Len(aColsEx), "AllwaysTrue",, "AllwaysTrue", oDlg2, aHeaderEx, aColsEx)	
oMSNewGe1:oBrowse:Refresh()

ACTIVATE MSDIALOG oDlg2 ON INIT EnChoiceBar(oDlg2,{||lCont := .T.,oDlg2:End() } , {||oDlg2:End()})  CENTER

if (lCont)
	aColsEx := oMSNewGe1:aCols

	For nX := 1 to len(aColsEx)
		if aColsEx[nX, Len(aColsEx[nX])] .And. (aColsEx[nX,1] != 0)
			TcSqlExec("Update PEDIDOPRODUTO set IDNEXCLUIDOERP = 1 WHERE IDPEDIDOPRODUTO = " + AllTrim(Str(aColsEx[nX,1],0)) )
		EndIf
	Next nX
	
EndIf

Return