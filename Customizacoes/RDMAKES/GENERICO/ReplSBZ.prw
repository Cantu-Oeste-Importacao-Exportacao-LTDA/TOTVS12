#include "rwmake.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "TBICONN.CH"
#include "colors.ch"

// Inclusao de Dados indicadores dos produtos com base em um registro selecionado. 
// Tabela SBZ


User Function ReplSBZ()
Local cAlias 		:= "SBZ"
Private cCadastro 	:= "Replicar complemento de Produto"
Private aRotina 	:= {}
Private aCampos 	:= {}
Private	aProduto	:= {}
Private aEmpr		:= {}
Private	aProdOri	:= {}
Private _cEmpAnt	:= cEmpAnt
Private _cFilAnt	:= cFilAnt
Private aAreaSM0 	:= SM0->(GetArea())
aAdd(aRotina, {"Pesquisar"		, "AxPesqui"		,0,1})
aAdd(aRotina, {"Visualizar"		, "AxVisual"		,0,2})
aAdd(aRotina, {"Replicar para"	, "U_RepSBZ"		,0,3})

dbSelectArea(cAlias)
dbSetOrder(1)
mBrowse(6, 1, 22, 75, cAlias)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return nil

User Function RepSBZ() 
Local cDlgTitle := "Produtos DESTINO"
Local aCampos   := {}
Local cMarca    := GetMark()
Local lInverte  := .f.     
LOCAL nOpca		:= 2
Local aArea		:= GetArea()
Local cAliasBZ := "TMPSBZ"
Local nCont		:= 0 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

_cPrI  			:= space(15)
_DesProdI 		:= space(30)
_cGrI			:= Space(4)
_DesGRPI		:= Space(30)
 
_cPrF 	 		:= space(15)
_DesProdF 		:= space(30) 
_cGrF			:= Space(4)
_DesGRPF		:= Space(30)
_aCampos 		:= {}

AADD(_aCampos,{ "B1_OK"   	, "C" ,02,0 } )  // 
AADD(_aCampos,{ "B1_COD"	, "C" ,15,0 } )  // Codigo
AADD(_aCampos,{ "B1_DESC" 	, "C" ,45,0 } )  // Descrição
_cArqTrb1  := CriaTrab(_aCampos)
_cArqInd1  := CriaTrab(NIL,.F.)

dbUseArea( .T.,,_cArqTrb1,"TRBB1",.F. )
dbSelectArea("TRBB1")
_cChave1  := "B1_COD"
IndRegua("TRBB1",_cArqInd1,_cChave1,,,"Selecionando Registros...")
dbSelectArea("TRBB1")
  
aCampos := {}
AADD(aCampos,{"B1_OK"		,"" ,"Ok"      		," " })
AADD(aCampos,{"B1_COD"		,"" ,"Codigo"     	," " })
AADD(aCampos,{"B1_DESC"		,"" ,"Descrição"    ," " })

DEFINE MSDIALOG oDlg TITLE cDlgTitle From 3,1 To 450,700 OF oMainWnd PIXEL
    
@ 013,001 TO 74,350

@ 015,010 Say OemToAnsi("Produto Inicial")
@ 015,045 Get _cPrI PICTURE '@!' 	Size 40,10 F3 "SB1" 
@ 015,090 Get _DesProdI PICTURE '@!' 	Size 160,10 When .F.  
@ 027,010 Say OemToAnsi("Produto Final")
@ 027,045 Get _cPrF	PICTURE '@!' 	Size 40,10 F3 "SB1" Valid NaoVazio()
@ 027,090 Get _DesProdF PICTURE '@!' 	Size 160,10 When .F.  
@ 039,010 Say OemToAnsi("Grupo Inicial")
@ 039,045 Get _cGrI	PICTURE '@!' 	Size 40,10 F3 "SBM" 
@ 039,090 Get _DesGRPI PICTURE '@!' 	Size 160,10 When .F.  
@ 051,010 Say OemToAnsi("Grupo Final")
@ 051,045 Get _cGrF	PICTURE '@!' 	Size 40,10 F3 "SBM" Valid NaoVazio() .and. u_Produtos()
@ 051,090 Get _DesGRPF PICTURE '@!' 	Size 160,10 When .F.  

oMark := MsSelect():New("TRBB1","B1_OK",,aCampos,@lInverte,@cMarca,{75,1,220,350})
ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:oBrowse:lhasMark = .T.
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:Refresh()           

ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER

IF (nOpca == 1)
	// Gravo os codigos dos produtos de destino.
	aProduto	:= {}
 	TRBB1->(DbSelectArea("TRBB1"))
  	TRBB1->(DbGotop())
  	While !TRBB1->(Eof())
		If TRBB1->(Marked("B1_OK"))
			AADD(aProduto,{TRBB1->B1_COD})
		Endif
		TRBB1->(DbSkip())	
	End     	
  	TRBB1->(DbSelectArea("TRBB1"))
	TRBB1->(DbCloseArea()) 
	// Buscar dados de Empresas/Filiais no SIGAMAT.EMP 
  	MsAguarde( {||  }, "Aguarde...", "Incluindo dados... " )
	If Len(aProduto) > 0
		// Gravo os dados do produto de origem.
		aProdOri	:= {}
		_cPrdOri	:= ""
		_cPrdOri	:= SBZ->BZ_COD
		SBZ->(DbSelectArea("SBZ"))
		SBZ->(DbGotop())
		// Selecionar as configurações do produto de origem de todas as filiais.
		cSql := "SELECT * FROM "+RetSqlName("SBZ")
		cSql += " WHERE D_E_L_E_T_ <> '*' "
		cSql += " AND BZ_COD = '"+_cPrdOri+"' "
		cSql += " ORDER BY BZ_FILIAL"
		TCQUERY cSql NEW ALIAS "TMPSBZ"
				
		ProcRegua(Len(aProduto))
	    // Gravar a estrutura da tabela SBZ.
 		For nR := 1 To SBZ->(fCount())
			_cCampo := SBZ->(FieldName(nR))
			AADD(aProdOri,{_cCampo,SBZ->&_cCampo})
		Next nR
		// Leitura de todos os produtos DESTINO selecionados.
		nCont := 0
		For nX := 1 To Len(aProduto)
			TMPSBZ->(DbSelectArea("TMPSBZ"))
			TMPSBZ->(DbGotop())					
			While !TMPSBZ->(Eof())
				SBZ->(DbSelectArea("SBZ"))
				SBZ->(DbGotop())
				// Se o INDICADOR do produto destino não existir.
				IF !SBZ->(DbSeek(TMPSBZ->BZ_FILIAL+aProduto[nX,1]))
					SBZ->(RecLock("SBZ", .T.))
					For I := 1 To Len(aProdOri)
						_cCampo := aProdOri[I,1]
				 		If _cCampo $ "BZ_COD"
							SBZ->&_cCampo	:= aProduto[nX,1]
				 		Else 
				 			If !AllTrim(_cCampo) $ "BZ_UCALSTD/BZ_UCOM/BZ_CONINI/BZ_DATREF"
								SBZ->&_cCampo	:= 	TMPSBZ->&_cCampo
							Endif
						Endif
					Next I				
					nCont += 1
					SBZ->(MsUnlock("SBZ")) 
				Endif
				TMPSBZ->(DbSkip())
			End
		Next nX
		TMPSBZ->(DbSelectArea("TMPSBZ"))
		TMPSBZ->(DbCloseArea())			
		MsgInfo(AllTrim(Str(nCont))+" registros foram incluidos.")
	Endif
	RestArea(aArea)
Else 
  	TRBB1->(DbSelectArea("TRBB1"))
	TRBB1->(DbCloseArea()) 
	RestArea(aArea)
Endif

RestArea(aArea)
RestArea(aAreaSM0)

Return 

User Function EmpSel()
Local _cFilOri	:= cFilAnt
Local _aArea	:= GetArea() 
Local cDlgTitle  := "Empresas/Filiais DESTINO"
Local aCampos    := {}
Local cMarca
Local lInverte   := .f.     
Local aArea		:= GetArea()
LOCAL nOpca		:= 2 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

_aCampos := {}

AADD(_aCampos,{ "M0_OK"   		, "C" ,02,0 } )
AADD(_aCampos,{ "M0_EMP"		, "C" ,02,0 } )  	
AADD(_aCampos,{ "M0_CODFIL" 	, "C" ,02,0 } )  
AADD(_aCampos,{ "M0_FILIAL" 	, "C" ,45,0 } )  
_cArqTrb1  := CriaTrab(_aCampos)
_cArqInd1  := CriaTrab(NIL,.F.)

dbUseArea( .T.,,_cArqTrb1,"TRBM0",.F. )
dbSelectArea("TRBM0")
_cChave1  := "M0_EMP+M0_CODFIL"
IndRegua("TRBM0",_cArqInd1,_cChave1,,,"Selecionando Registros...")
dbSelectArea("TRBM0")
cMarca     := GetMark()
aCampos := {}
AADD(aCampos,{"M0_OK"				,"" ,"Ok"      		," " })
AADD(aCampos,{"M0_EMP"				,"" ,"Empresa"     	," " })
AADD(aCampos,{"M0_CODFIL"			,"" ,"Filial"     	," " })
AADD(aCampos,{"M0_FILIAL"			,"" ,"Descrição"    ," " })

SM0->(DbSelectArea("SM0"))
SM0->(dbSetOrder(1))
SM0->(dbGoTop())
While !SM0->(Eof())
	If SM0->M0_CODIGO == _cEmpAnt
		TRBM0->(DbSelectArea("TRBM0"))
		TRBM0->(RecLock("TRBM0", .T.))
			TRBM0->M0_EMP		:= SM0->M0_CODIGO
			TRBM0->M0_CODFIL	:= SM0->M0_CODFIL
			TRBM0->M0_FILIAL	:= SM0->M0_FILIAL		
		TRBM0->(MsUnlock("TRBM0")) 
	Endif
	SM0->(DbSkip())
End
TRBM0->(DbGoTop())
DEFINE MSDIALOG oDlg TITLE cDlgTitle From 3,1 To 450,700 OF oMainWnd PIXEL
    
@ 013,001 TO 74,350

oMark := MsSelect():New("TRBM0","M0_OK",,aCampos,@lInverte,@cMarca,{022,1,220,350})
ObjectMethod(oMark:oBrowse,"Refresh()")
oMark:oBrowse:lhasMark = .T.
oMark:oBrowse:lCanAllmark := .T.
oMark:oBrowse:Refresh()           

ACTIVATE MSDIALOG oDlg ON INIT EnChoiceBar(oDlg,{||nOpca:=1,if(TudoOk(),oDlg:End(),.f.) } , {||nOpca:=2,oDlg:End()})  CENTER
// Gravo os dados das empresas/filiais destino.
aEmpr	:= {}
If nOpca == 1
	TRBM0->(DbSelectArea("TRBM0"))
	TRBM0->(DbGotop())
	While !TRBM0->(Eof())
		If TRBM0->(Marked("M0_OK"))
			AADD(aEmpr,{TRBM0->M0_EMP,TRBM0->M0_CODFIL})
		Endif
		TRBM0->(DbSkip())	
	End     	
Endif
TRBM0->(DbSelectArea("TRBM0"))
TRBM0->(DbCloseArea())

cFilAnt	:= _cFilOri
RestArea(aAreaSM0) 

Return Nil

// Seleção de produtos.
User Function Produtos()
Local lRet	:= .T. 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cSql := "SELECT B1.B1_FILIAL, B1.B1_COD, B1.B1_DESC "
cSql += "FROM "+RetSqlName("SB1")+"  B1 "
cSql += "WHERE B1.B1_FILIAL = '"+xFilial("SB1")+"' "
cSql += "AND B1.D_E_L_E_T_ <> '*' "
cSql += "AND B1.B1_COD BETWEEN '"+_cPrI+"' AND '"+_cPrF+"' " 
cSql += "AND B1.B1_GRUPO BETWEEN '"+_cGrI+"' AND '"+_cGrF+"' "
cSql += "ORDER BY B1.B1_COD "
TCQUERY cSql NEW ALIAS "TMPB1"
   
DbSelectArea("TMPB1")
TMPB1->(DbGotop()) 

While !TMPB1->(Eof())
	TRBB1->(RecLock("TRBB1", .T.))
		TRBB1->B1_COD	:= TMPB1->B1_COD
		TRBB1->B1_DESC	:= TMPB1->B1_DESC
	TRBB1->(MsUnlock("TRBB1"))
	TMPB1->(DbSkip())
End
TMPB1->(DbSelectArea("TMPB1"))
TMPB1->(DbCloseArea()) 
_DesProdI	:= POSICIONE("SB1",1,xFilial("SB1")+_cPrI,"B1_DESC")
_DesProdF	:= POSICIONE("SB1",1,xFilial("SB1")+_cPrF,"B1_DESC")
_DesGRPI	:= POSICIONE("SBM",1,xFilial("SBM")+_cGrI,"BM_DESC")
_DesGRPF	:= POSICIONE("SBM",1,xFilial("SBM")+_cGrF,"BM_DESC")
dlgRefresh(oDlg)

TRBB1->(DbSelectArea("TRBB1"))
TRBB1->(DbGotop())

ObjectMethod(oMark:oBrowse,"Refresh()")

Return