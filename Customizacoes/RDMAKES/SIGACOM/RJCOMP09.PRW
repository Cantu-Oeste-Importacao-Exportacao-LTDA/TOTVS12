#INCLUDE "PROTHEUS.CH"        
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCOMP09 ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de solicitantes x       º±±
±±º          ³famílias (Tabela: Z28).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*------------------------*
User Function RJCOMP09()
*------------------------*


Private cCadastro := "Solicitantes x Famílias"

Private aRotina	:= {{"Pesquisar" ,"AxPesqui"  , 0, 1 ,0 ,.F.},;
					{"Visualizar","U_RJZ28MNT", 0, 2 ,0 ,nil},;
					{"Incluir"   ,"U_RJZ28MNT", 0, 3 ,0 ,nil},;
					{"Alterar"   ,"U_RJZ28MNT", 0, 4, 0 ,nil},;
					{"Excluir"   ,"U_RJZ28MNT", 0, 5, 0 ,nil}}  
					
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	mBrowse(6,1,22,75,"Z28")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ28MNT ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de solicitantes x       º±±
±±º          ³famílias (Tabela: Z28).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------*
User Function RJZ28MNT(cAlias, nReg, nOpc)  
*------------------------------------------*
LOCAL nOpcA		 := 0
LOCAL nRecOld	 := 0
LOCAL aObjects	 := {}
LOCAL aPosObj 	 := {}
LOCAL aInfo	 	 := {}
LOCAL aSize	 	 := {}
LOCAL cChave	 := ""
LOCAL aCCols     := {}
LOCAL cSeek		 := ""
LOCAL cWhile 	 := ""
LOCAL aNoFields	 := {"Z28_USRSOL","Z28_NOMSOL"}
LOCAL lAlt := lInc := lExc := .F.

PRIVATE aHeader[0],aCols[0]
PRIVATE oDlg
PRIVATE oGet
       
PUBLIC lInclui := IIf(nOpc==3,.T.,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	Do Case
		Case aRotina[nOpc][4] == 3 //Inclusao
			lInc := .T.
		Case aRotina[nOpc][4] == 4 //Alteracao
			lAlt := .T.
		OtherWise  // Exclusao ou Visualizacao
			lExc := .T.
	EndCase
	
	If nOpc == 3
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicializa variaveis p/ criar gets fixos com tamanho correto ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		M->&("Z28_USRSOL") := CriaVar("Z28_USRSOL")
		M->&("Z28_NOMSOL") := CriaVar("Z28_NOMSOL")	           
		cSeek := xFilial("Z28")+cChave
	Else
	    dbSelectArea("Z28")                   
	    nRecOld := Z28->(RecNO())
		M->&("Z28_USRSOL") := Z28->Z28_USRSOL
		M->&("Z28_NOMSOL") := Z28->Z28_NOMSOL		
		cSeek := xFilial("Z28")+Z28->Z28_USRSOL
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e aCols                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhile	:= "Z28->Z28_FILIAL+Z28->Z28_USRSOL"

	FillGetDados(nOPc,"Z28",1,cSeek,{|| &cWhile },{||.T.},aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/ If(nOpc==3, {|| If(aHeader[1][8]=="D", dDataBase , )} ,) ,nOpc==3)

	If nOpc <> 3 
		aCCols := aClone(aCols)
	EndIf
	
	AADD(aObjects, {100, 040, .T., .F.})
	AADD(aObjects, {100, 100, .T., .T.})
	
	aSize := MsAdvSize(.F.)
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 2}

	aPosObj := MsObjSize(aInfo, aObjects)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	

	@ 031,010 SAY RetTitle("Z28_USRSOL")	SIZE 40,7 OF oDlg PIXEL
	@ 031,065 MSGET M->Z28_USRSOL	When lInc Valid (!VAZIO().AND.EXISTCHAV("Z28",M->Z28_USRSOL).AND.EXISTCPO("SAI",M->Z28_USRSOL,2)) F3 "US2" SIZE 30,10 OF oDlg PIXEL
	@ 031,120 SAY RetTitle("Z28_NOMSOL") SIZE 30,7 OF oDlg PIXEL
	@ 031,150 MSGET M->Z28_NOMSOL  	When .F. SIZE 100,10 OF oDlg PIXEL
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_RJC28LOK","U_RJC28TOK","",If(!lExc,.T.,.F.),,,,999,)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(oGet:TudoOk(),oDlg:End(),nOpca := 0)},{||oDlg:End()})
	
	If nOpca == 1 .And. nOpc != 2
		If nOpc == 3 // Inclusao
			RJZ28UPD(nOpc)
		Else // Alteracao ou Exclusao
			RJZ28UPD(nOpc, nRecOld, aCCols)
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC28TOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina auxiliar de validação do browse.                     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RJC28TOK(o)
*-----------------------------*
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If Empty(M->Z28_USRSOL) .or. Empty(M->Z28_NOMSOL)
		MsgAlert("Os campos Código e Descrição são obrigatórios!")
		lRet := .T.
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC28LOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina auxiliar de validação da linha.                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-----------------------------*
User Function RJC28LOK(o)
*-----------------------------*
LOCAL nPCODFAM := 0         
LOCAL lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se linha do acols foi preenchida            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If Len(aCols) > 1
		If !(aCols[n,Len(aCols[n])]) .And. !(CheckCols(n,aCols))
			lRet:=.F.
		EndIf
	EndIf	
	
	If lRet .And. !(aCols[n,Len(aCols[n])])
		
		// Localizacao posicao dos campos obrigatorios no acols
		For nX = 1 To Len(aHeader)
			If Trim(aHeader[nX][2]) == "Z28_CODFAM"
				nPCODFAM := nX
				Exit
			EndIf	
		Next nX
		
		// Verificar se o item e a descricao do item estao preenchidas
		If !(NaoVazio(aCols[n,nPCODFAM]))
			lRet:=.F.
		EndIf	

		If lRet
			// Verificar se o codigo j  existe na GetDados e se nao esta deletado
			nAcho := aScan(aCols,{ |x| x[nPCODFAM] == aCols[n,nPCODFAM] .and. !(x[Len(aCols[n])])})
			If !(aCols[nAcho,Len(aCols[nAcho])]) .And. nAcho > 0 .And. nAcho # n
				Alert("Família de produtos já informado!")
				lRet:=.F.
			EndIf	
		EndIf
	
	EndIf
		
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ28UPD ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina auxiliar de gravação de dados.                       º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*-------------------------------------------------*
Static Function RJZ28UPD(nOpc, nRecno, aCCols)
*-------------------------------------------------*

	// Inclusão
	If nOpc == 3
		
		Begin Transaction
			For nI := 1 to Len(aCols)
				// Caso a linha nao esteja deletada
				If !(aCols[nI,Len(aCols[nI])])
					Reclock("Z28",.T.)
					Z28->Z28_FILIAL := xFilial("Z28")
					Z28->Z28_USRSOL := M->Z28_USRSOL
					Z28->Z28_NOMSOL := M->Z28_NOMSOL
					For nZ:=1 to Len(aHeader)
						FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
					Next nZ
				EndIf
			Next nI		
		End Transaction
		
	Else
		
		If nOpc == 5 //  Exclusão
			dbSelectArea("Z28")
			dbGoto(nRecno)
			cOldKEY := Z28->Z28_FILIAL+Z28->Z28_USRSOL
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( cOldKEY )
				Begin Transaction
					While !Z28->(EOF()) .and. Z28->Z28_FILIAL + Z28->Z28_USRSOL == cOldKEY
						Reclock("Z28",.F.,.T.)                    
						Z28->(dbDelete())
						Z28->(MsUnlock())
						Z28->(dbSkip())
					EndDo				
				End Transaction
			EndIf
		EndIf
		
		If nOpc == 4	// Alteração
			
			Begin Transaction
				dbSelectArea("Z28")
				dbGoto(nRecno)				
				cOldKEY := Z28->Z28_FILIAL+Z28->Z28_USRSOL
				
				For nI := 1 to Len(aCols)
					// Caso a linha nao esteja deletada
					If !(aCols[nI,Len(aCols[nI])])
						dbSelectArea("Z28")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][01] )
							If Reclock("Z28",.F.)
								Z28->Z28_FILIAL := xFilial("Z28")
								Z28->Z28_USRSOL := M->Z28_USRSOL
								Z28->Z28_NOMSOL := M->Z28_NOMSOL
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z28->(MsUnLock())
							EndIf
						Else
							If Reclock("Z28",.T.)
								Z28->Z28_FILIAL := xFilial("Z28")
								Z28->Z28_USRSOL := M->Z28_USRSOL
								Z28->Z28_NOMSOL := M->Z28_NOMSOL
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z28->(MsUnLock())
							EndIf						
						EndIf
					Else
						dbSelectArea("Z28")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][01] )
							If Reclock("Z28",.F.)
								Z28->(dbDelete())
								Z28->(MsUnLock())
							EndIf
						EndIf					
					EndIf
				Next nI		
	    	End Transaction
	    	
		EndIf
	EndIf

Return