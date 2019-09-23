#INCLUDE "PROTHEUS.CH"        
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCOMP08 ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de família x grupo de   º±±
±±º          ³produtos (Tabela: Z27).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*------------------------*
User Function RJCOMP08()
*------------------------*


Private cCadastro := "Família x Grupo de Produtos"

Private aRotina	:= {{"Pesquisar" ,"AxPesqui"  , 0, 1 ,0 ,.F.},;
					{"Visualizar","U_RJZ27MNT", 0, 2 ,0 ,nil},;
					{"Incluir"   ,"U_RJZ27MNT", 0, 3 ,0 ,nil},;
					{"Alterar"   ,"U_RJZ27MNT", 0, 4, 0 ,nil},;
					{"Excluir"   ,"U_RJZ27MNT", 0, 5, 0 ,nil}}  
					
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	mBrowse(6,1,22,75,"Z27")

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ27MNT ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de família x grupo de   º±±
±±º          ³produtos (Tabela: Z27).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------*
User Function RJZ27MNT(cAlias, nReg, nOpc)  
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
LOCAL aNoFields	 := {"Z27_CODIGO","Z27_DESC"}
LOCAL lAlt := lInc := lExc := .F.

PRIVATE aHeader[0],aCols[0]
PRIVATE oDlg
PRIVATE oGet        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
       
PUBLIC lInclui := IIf(nOpc==3,.T.,.F.)

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
		M->&("Z27_CODIGO") := GETSX8NUM("Z27","Z27_CODIGO")
		M->&("Z27_DESC")   := CriaVar("Z27_DESC")	           
		cSeek := xFilial("Z27")+cChave
	Else
	    dbSelectArea("Z27")                   
	    nRecOld := Z27->(RecNO())
		M->&("Z27_CODIGO") := Z27->Z27_CODIGO
		M->&("Z27_DESC")   := Z27->Z27_DESC		
		cSeek := xFilial("Z27")+Z27->Z27_CODIGO
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e aCols                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhile	:= "Z27->Z27_FILIAL+Z27->Z27_CODIGO"

	FillGetDados(nOPc,"Z27",1,cSeek,{|| &cWhile },{||.T.},aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/ If(nOpc==3, {|| If(aHeader[1][8]=="D", dDataBase , )} ,) ,nOpc==3)

	If nOpc <> 3 
		aCCols := aClone(aCols)
	EndIf
	
	AADD(aObjects, {100, 040, .T., .F.})
	AADD(aObjects, {100, 100, .T., .T.})
	
	aSize := MsAdvSize(.F.)
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 2}

	aPosObj := MsObjSize(aInfo, aObjects)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	

	@ 031,010 SAY RetTitle("Z27_CODIGO")	SIZE 40,7 OF oDlg PIXEL
	@ 031,065 MSGET M->Z27_CODIGO	When lInc Valid (!VAZIO().AND.EXISTCHAV("Z27",M->Z27_CODIGO)) SIZE 30,10 OF oDlg PIXEL
	@ 031,120 SAY RetTitle("Z27_DESC") SIZE 30,7 OF oDlg PIXEL
	@ 031,150 MSGET M->Z27_DESC  	When .T. Valid (!VAZIO()) SIZE 100,10 OF oDlg PIXEL
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_RJC27LOK","U_RJC27TOK","",If(!lExc,.T.,.F.),,,,999,)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpcA:=1,if(oGet:TudoOk(),oDlg:End(),nOpcA := 0)},{||oDlg:End()})
	
	If nOpcA == 1 .And. nOpc != 2
		If nOpc == 3 // Inclusao
			RJZ27UPD(nOpc)
			ConfirmSx8()
		Else // Alteracao ou Exclusao
			RJZ27UPD(nOpc, nRecOld, aCCols)
		EndIf
	ElseIf nOpcA != 1
		RollBackSx8()	
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC27TOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC27TOK(o)
*-----------------------------*
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If Empty(M->Z27_CODIGO) .or. Empty(M->Z27_DESC)
		MsgAlert("Os campos Código e Descrição são obrigatórios!")
		lRet := .T.
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC27LOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC27LOK(o)
*-----------------------------*
LOCAL nPCODGRP := 0
LOCAL nPCODPRD := 0         
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
			If Trim(aHeader[nX][2]) == "Z27_CODGRP"
				nPCODGRP := nX
			EndIf	          
			If Trim(aHeader[nX][2]) == "Z27_PRODUT"
				nPCODPRD := nX
			EndIf	          
		Next nX

		// Verificar se o item e a descricao do item estao preenchidas
		If (Empty(aCols[n,nPCODGRP])) .AND. (Empty(aCols[n,nPCODPRD]))
			Alert("Grupo de produtos ou código do produto deve ser informado!")
			lRet:=.F.
		EndIf	

		If !(Empty(aCols[n,nPCODGRP])) .AND. !(Empty(aCols[n,nPCODPRD]))
			Alert("Deverá ser informado apenas o grupo de produtos ou código do produto!")
			lRet:=.F.
		EndIf	


		If lRet
			// Verificar se o codigo j  existe na GetDados e se nao esta deletado
			If !Empty(aCols[n,nPCODGRP])
				nAcho := aScan(aCols,{ |x| x[nPCODGRP] == aCols[n,nPCODGRP] .and. !(x[Len(aCols[n])])})
				If !(aCols[nAcho,Len(aCols[nAcho])]) .And. nAcho > 0 .And. nAcho # n
					Alert("Grupo de produtos já informado!")
					lRet:=.F.
				EndIf	
			EndIf
			If !Empty(aCols[n,nPCODPRD])
				nAcho := aScan(aCols,{ |x| x[nPCODPRD] == aCols[n,nPCODPRD] .and. !(x[Len(aCols[n])])})
				If !(aCols[nAcho,Len(aCols[nAcho])]) .And. nAcho > 0 .And. nAcho # n
					Alert("Código de produtos já informado!")
					lRet:=.F.
				EndIf	
			EndIf
			
		EndIf
	
	EndIf
		
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ27UPD ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
Static Function RJZ27UPD(nOpc, nRecno, aCCols)
*-------------------------------------------------*

nPCODGRP := aScan(aHeader, { |x| x[2] = "Z27_CODGRP"})
nPCODPRD := aScan(aHeader, { |x| x[2] = "Z27_PRODUT"})

	// Inclusão
	If nOpc == 3
		
		Begin Transaction
			For nI := 1 to Len(aCols)
				// Caso a linha nao esteja deletada
				If !(aCols[nI,Len(aCols[nI])])
					Reclock("Z27",.T.)
					Z27->Z27_FILIAL := xFilial("Z27")
					Z27->Z27_CODIGO := M->Z27_CODIGO
					Z27->Z27_DESC   := M->Z27_DESC
					For nZ:=1 to Len(aHeader)
						FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
					Next nZ
				EndIf
			Next nI		
		End Transaction
		
	Else
		
		If nOpc == 5 //  Exclusão
			dbSelectArea("Z27")
			dbGoto(nRecno)
			cOldKEY := Z27->Z27_FILIAL+Z27->Z27_CODIGO
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( cOldKEY )
				Begin Transaction
					While !Z27->(EOF()) .and. Z27->Z27_FILIAL + Z27->Z27_CODIGO == cOldKEY
						Reclock("Z27",.F.,.T.)                    
						Z27->(dbDelete())
						Z27->(MsUnlock())
						Z27->(dbSkip())
					EndDo				
				End Transaction
			EndIf
		EndIf
		
		If nOpc == 4	// Alteração
			
			Begin Transaction
				dbSelectArea("Z27")
				dbGoto(nRecno)				
				cOldKEY := Z27->Z27_FILIAL+Z27->Z27_CODIGO
				
				For nI := 1 to Len(aCols)
					// Caso a linha nao esteja deletada
					If !(aCols[nI,Len(aCols[nI])]) .and. !Empty(aCols[nI][nPCODGRP])
						dbSelectArea("Z27")
						dbSetOrder(1)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][nPCODGRP] )
							If Reclock("Z27",.F.)
								Z27->Z27_FILIAL := xFilial("Z27")
								Z27->Z27_CODIGO := M->Z27_CODIGO
								Z27->Z27_DESC   := M->Z27_DESC
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z27->(MsUnLock())
							EndIf
						Else
							If Reclock("Z27",.T.)
								Z27->Z27_FILIAL := xFilial("Z27")
								Z27->Z27_CODIGO := M->Z27_CODIGO
								Z27->Z27_DESC   := M->Z27_DESC
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z27->(MsUnLock())
							EndIf						
						EndIf
					ElseIf !(aCols[nI,Len(aCols[nI])]) .and. !Empty(aCols[nI][nPCODPRD])
						dbSelectArea("Z27")
						dbSetOrder(5)
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][nPCODPRD] )
							If Reclock("Z27",.F.)
								Z27->Z27_FILIAL := xFilial("Z27")
								Z27->Z27_CODIGO := M->Z27_CODIGO
								Z27->Z27_DESC   := M->Z27_DESC
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z27->(MsUnLock())
							EndIf
						Else
							If Reclock("Z27",.T.)
								Z27->Z27_FILIAL := xFilial("Z27")
								Z27->Z27_CODIGO := M->Z27_CODIGO
								Z27->Z27_DESC   := M->Z27_DESC
								For nZ:=1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z27->(MsUnLock())
							EndIf						
						EndIf

					ElseIf (aCols[nI,Len(aCols[nI])])
					
						If !Empty(aCols[nI][nPCODGRP])
							dbSelectArea("Z27")
							dbSetOrder(1)
							dbGoTop()
							If dbSeek ( cOldKEY + aCols[nI][nPCODGRP] )
								If Reclock("Z27",.F.)
									Z27->(dbDelete())
									Z27->(MsUnLock())
								EndIf
							EndIf					
						ElseIf !Empty(aCols[nI][nPCODPRD])
							dbSelectArea("Z27")
							dbSetOrder(5)
							dbGoTop()
							If dbSeek ( cOldKEY + aCols[nI][nPCODPRD] )
								If Reclock("Z27",.F.)
									Z27->(dbDelete())
									Z27->(MsUnLock())
								EndIf
							EndIf					
						EndIf
						
					EndIf
				Next nI		
	    	End Transaction
	    	
		EndIf
	EndIf

Return