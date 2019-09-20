#INCLUDE "PROTHEUS.CH"        
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCOMP14 ºAutor  ³Rafael Parma         º Data ³  27/04/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de compradores x famíliaº±±
±±º          ³de produtos (Tabela: Z44).                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*------------------------*
User Function RJCOMP14()
*------------------------*


Private cCadastro := "Compradores x Famílias"

Private aRotina	:= {{"Pesquisar" ,"AxPesqui"  , 0, 1 ,0 ,.F.},;
					{"Visualizar","U_RJZ44MNT", 0, 2 ,0 ,nil},;
					{"Incluir"   ,"U_RJZ44MNT", 0, 3 ,0 ,nil},;
					{"Alterar"   ,"U_RJZ44MNT", 0, 4, 0 ,nil},;
					{"Excluir"   ,"U_RJZ44MNT", 0, 5, 0 ,nil}}  
					
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	mBrowse(6,1,22,75,"Z44")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ44MNT ºAutor  ³Rafael Parma         º Data ³  27/04/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de compradores x famíliaº±±
±±º          ³de produtos (Tabela: Z44).                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------*
User Function RJZ44MNT(cAlias, nReg, nOpc)  
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
LOCAL aNoFields	 := {"Z44_CODCOM","Z44_NOMCOM"}
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
		M->&("Z44_CODCOM") := CriaVar("Z44_CODCOM")
		M->&("Z44_NOMCOM") := CriaVar("Z44_NOMCOM")	           
		cSeek := xFilial("Z44")+cChave
	Else
	    dbSelectArea("Z44")                   
	    nRecOld := Z44->(RecNO())
		M->&("Z44_CODCOM") := Z44->Z44_CODCOM
		M->&("Z44_NOMCOM") := Z44->Z44_NOMCOM		
		cSeek := xFilial("Z44")+Z44->Z44_CODCOM
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e aCols                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhile	:= "Z44->Z44_FILIAL+Z44->Z44_CODCOM"

	FillGetDados(nOPc,"Z44", 2, cSeek,{|| &cWhile },{||.T.},aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/ If(nOpc==3, {|| If(aHeader[1][8]=="D", dDataBase , )} ,) ,nOpc==3)

	If nOpc <> 3 
		aCCols := aClone(aCols)
	EndIf
	
	AADD(aObjects, {100, 040, .T., .F.})
	AADD(aObjects, {100, 100, .T., .T.})
	
	aSize := MsAdvSize(.F.)
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 2}

	aPosObj := MsObjSize(aInfo, aObjects)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	

	@ 042,010 SAY RetTitle("Z44_CODCOM")	SIZE 40,7 OF oDlg PIXEL
	@ 040,060 MSGET M->Z44_CODCOM	When lInc Valid (!VAZIO().AND.EXISTCHAV("Z44",M->Z44_CODCOM).AND.EXISTCPO("SY1",M->Z44_CODCOM,1).AND.FUPDNOME()) F3 "SY1" SIZE 30,10 OF oDlg PIXEL
	@ 042,110 SAY RetTitle("Z44_NOMCOM") SIZE 30,7 OF oDlg PIXEL
	@ 040,160 MSGET M->Z44_NOMCOM  	When .F. SIZE 100,10 OF oDlg PIXEL
	
	oGet := MSGetDados():New(aPosObj[2,1]+15,aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_RJC44LOK","U_RJC44TOK","",If(!lExc,.T.,.F.),,,,999,)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(oGet:TudoOk(),oDlg:End(),nOpca := 0)},{||oDlg:End()})
	
	If nOpca == 1 .And. nOpc != 2
		If nOpc == 3 // Inclusao
			RJZ44UPD(nOpc)
		Else // Alteracao ou Exclusao
			RJZ44UPD(nOpc, nRecOld, aCCols)
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC44TOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC44TOK(o)
*-----------------------------*
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If Empty(M->Z44_CODCOM) .or. Empty(M->Z44_NOMCOM)
		MsgAlert("Os campos Código e Descrição são obrigatórios!")
		lRet := .T.
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC44LOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC44LOK(o)
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
			If Trim(aHeader[nX][2]) == "Z44_CODFAM"
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
±±ºPrograma  ³FUPDNOME ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
Static Function FUPDNOME() 
*-------------------------------------------------*
    If !SY1->(EOF())
		M->Z44_NOMCOM := SY1->Y1_NOME
	EndIf
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ44UPD ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
Static Function RJZ44UPD(nOpc, nRecno, aCCols)
*-------------------------------------------------*

	// Inclusão
	If nOpc == 3
		
		Begin Transaction
			For nI := 1 to Len(aCols)
				// Caso a linha nao esteja deletada
				If !(aCols[nI,Len(aCols[nI])])
					Reclock("Z44",.T.)
					Z44->Z44_FILIAL := xFilial("Z44")
					Z44->Z44_CODCOM := M->Z44_CODCOM
					Z44->Z44_NOMCOM := M->Z44_NOMCOM
					For nZ:=1 to Len(aHeader)
						FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
					Next nZ
				EndIf
			Next nI		
		End Transaction
		
	Else
		
		If nOpc == 5 //  Exclusão
			dbSelectArea("Z44")
			dbGoto(nRecno)
			cOldKEY := Z44->Z44_FILIAL+Z44->Z44_CODCOM
			dbSetOrder(2)
			dbGoTop()
			If dbSeek ( cOldKEY )
				Begin Transaction
					While !Z44->(EOF()) .and. Z44->Z44_FILIAL + Z44->Z44_CODCOM == cOldKEY
						Reclock("Z44",.F.,.T.)                    
						Z44->(dbDelete())
						Z44->(MsUnlock())
						Z44->(dbSkip())
					EndDo				
				End Transaction
			EndIf
		EndIf
		
		If nOpc == 4	// Alteração
			
			Begin Transaction
				dbSelectArea("Z44")
				dbGoto(nRecno)				
				cOldKEY := Z44->Z44_FILIAL+Z44->Z44_CODCOM
				
				For nI := 1 to Len(aCols)
					// Caso a linha nao esteja deletada
					If !(aCols[nI,Len(aCols[nI])])
						dbSelectArea("Z44")
						dbSetOrder(2)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][01] )
							If Reclock("Z44",.F.)
								Z44->Z44_FILIAL := xFilial("Z44")
								Z44->Z44_CODCOM := M->Z44_CODCOM
								Z44->Z44_NOMCOM := M->Z44_NOMCOM
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z44->(MsUnLock())
							EndIf
						Else
							If Reclock("Z44",.T.)
								Z44->Z44_FILIAL := xFilial("Z44")
								Z44->Z44_CODCOM := M->Z44_CODCOM
								Z44->Z44_NOMCOM := M->Z44_NOMCOM
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z44->(MsUnLock())
							EndIf						
						EndIf
					Else
						dbSelectArea("Z44")
						dbSetOrder(2)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][01] )
							If Reclock("Z44",.F.)
								Z44->(dbDelete())
								Z44->(MsUnLock())
							EndIf
						EndIf					
					EndIf
				Next nI		
	    	End Transaction
	    	
		EndIf
	EndIf

Return