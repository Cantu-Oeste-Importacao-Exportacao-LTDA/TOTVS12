#INCLUDE "PROTHEUS.CH"        
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJCOMP10 ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de aprovadores x        º±±
±±º          ³familias (Tabela: Z29).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
*------------------------*
User Function RJCOMP10()
*------------------------*


Private cCadastro := "Aprovadores x Familias"

Private aRotina	:= {{"Pesquisar" ,"AxPesqui"  , 0, 1 ,0 ,.F.},;
					{"Visualizar","U_RJZ29MNT", 0, 2 ,0 ,nil},;
					{"Incluir"   ,"U_RJZ29MNT", 0, 3 ,0 ,nil},;
					{"Alterar"   ,"U_RJZ29MNT", 0, 4, 0 ,nil},;
					{"Excluir"   ,"U_RJZ29MNT", 0, 5, 0 ,nil}}

	dbSelectArea("Z29")
	dbSetOrder(2)
	mBrowse(6,1,22,75,"Z29")  
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ29MNT ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de manutenção sobre cadastro de solicitantes x       º±±
±±º          ³familias (Tabela: Z29).                                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*------------------------------------------*
User Function RJZ29MNT(cAlias, nReg, nOpc)  
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
LOCAL aNoFields	 := {"Z29_CODFAM","Z29_DESFAM"}
LOCAL lAlt := lInc := lExc := .F.

PRIVATE aHeader[0],aCols[0]
PRIVATE oDlg
PRIVATE oGet
       
PUBLIC lInclui := IIf(nOpc==3,.T.,.F.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define a funcao utilizada ( Incl.,Alt.,Visual.,Exclu.)  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
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

		M->&("Z29_CODFAM") := CriaVar("Z29_CODFAM")
		M->&("Z29_DESFAM") := CriaVar("Z29_DESFAM")	           

		cSeek := xFilial("Z29")+cChave
	Else
	    dbSelectArea("Z29")                   
	    nRecOld := Z29->(RecNO())

		M->&("Z29_CODFAM") := Z29->Z29_CODFAM
		M->&("Z29_DESFAM") := Z29->Z29_DESFAM		
		cSeek := xFilial("Z29")+Z29->Z29_CODFAM
		
	EndIf



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem do aHeader e aCols                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhile	:= "Z29->Z29_FILIAL+Z29->Z29_CODFAM"

	FillGetDados(nOPc, "Z29", 2, cSeek, {|| &cWhile }, {||.T.}, aNoFields,/*aYesFields*/,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/ If(nOpc==3, {|| If(aHeader[1][8]=="D", dDataBase , )} ,) ,nOpc==3)

	If nOpc <> 3 
		aCCols := aClone(aCols)
	EndIf
	
	AADD(aObjects, {100, 055, .T., .F.})
	AADD(aObjects, {100, 100, .T., .T.})
	
	aSize := MsAdvSize(.F.)
	aInfo := {aSize[1], aSize[2], aSize[3], aSize[4], 3, 2}

	aPosObj := MsObjSize(aInfo, aObjects)
	
	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	

	@ 048,030 SAY RetTitle("Z29_CODFAM") COLOR CLR_HBLUE SIZE 40,7 OF oDlg PIXEL
	@ 044,070 MSGET M->Z29_CODFAM	When lInc Valid (!VAZIO().AND.EXISTCHAV("Z29",M->Z29_CODFAM).AND.EXISTCPO("Z27",M->Z29_CODFAM,1)) F3 "Z27000" SIZE 30,10 OF oDlg PIXEL
	@ 048,140 SAY RetTitle("Z29_DESFAM") COLOR CLR_HBLUE SIZE 40,7 OF oDlg PIXEL
	@ 044,180 MSGET M->Z29_DESFAM  	When .F. SIZE 100,10 OF oDlg PIXEL
	
	oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpc,"U_RJC29LOK","U_RJC29TOK","",If(!lExc,.T.,.F.),,,,999,)
	
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(oGet:TudoOk(),oDlg:End(),nOpca := 0)},{||oDlg:End()})
	
	If nOpca == 1 .And. nOpc != 2
		If nOpc == 3 // Inclusao
			RJZ29UPD(nOpc)
		Else // Alteracao ou Exclusao
			RJZ29UPD(nOpc, nRecOld, aCCols)
		EndIf
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC29TOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC29TOK(o)
*-----------------------------*
Local lRet := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If Empty(M->Z29_CODFAM) .or. Empty(M->Z29_DESFAM)
		MsgAlert("Os campos Código e Descrição são obrigatórios!")
		lRet := .T.
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJC29LOK ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
User Function RJC29LOK(o)
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
		

		nPCODCCT := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CC" } )
		nPCODCLV := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CLVL" } )
		nPCODAPR := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CODAPR" } )
		
		// Verificar se o item e a descricao do item estao preenchidas
		If !(NaoVazio(aCols[n,nPCODAPR]))
			lRet:=.F.
		EndIf	

		If lRet
			// Verificar se o codigo já  existe na GetDados e se nao esta deletado
			nAcho := aScan(aCols,{ |x| x[nPCODCCT] == aCols[n,nPCODCCT] .and. x[nPCODCLV] == aCols[n,nPCODCLV] .and. x[nPCODAPR] == aCols[n,nPCODAPR] .and. !(x[Len(aCols[n])])})
			If !(aCols[nAcho,Len(aCols[nAcho])]) .And. nAcho > 0 .And. nAcho # n
				Alert("Aprovador/Segmento/Centro de custo já informados!")
				lRet:=.F.
			EndIf	
		EndIf
	
	EndIf
		
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJZ29UPD ºAutor  ³Rafael Parma         º Data ³  14/12/2010 º±±
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
Static Function RJZ29UPD(nOpc, nRecno, aCCols)
*-------------------------------------------------*
Local nPCODCCT := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CC" } )
Local nPCODCLV := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CLVL" } )
Local nPCODAPR := aScan( aHeader, { |x| ALLTRIM(x[2]) == "Z29_CODAPR" } )
		
	// Inclusão
	If nOpc == 3
		
		Begin Transaction
			For nI := 1 to Len(aCols)
				// Caso a linha nao esteja deletada
				If !(aCols[nI,Len(aCols[nI])])
					Reclock("Z29",.T.)
					Z29->Z29_FILIAL := xFilial("Z29")
					Z29->Z29_CODFAM := M->Z29_CODFAM
					Z29->Z29_DESFAM := M->Z29_DESFAM
					For nZ := 1 to Len(aHeader)
						FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
					Next nZ
				EndIf
			Next nI		
		End Transaction
		
	Else
		
		If nOpc == 5 //  Exclusão
			dbSelectArea("Z29")
			dbGoto(nRecno)
			cOldKEY := Z29->Z29_FILIAL+Z29->Z29_CODFAM
			dbSetOrder(2)	//--Z29_FILIAL+Z29_CODFAM+Z29_CODAPR
			dbGoTop()
			If dbSeek ( cOldKEY )
				Begin Transaction
					While !Z29->(EOF()) .and. Z29->Z29_FILIAL + Z29->Z29_CODFAM == cOldKEY
						Reclock("Z29",.F.,.T.)                    
						Z29->(dbDelete())
						Z29->(MsUnlock())
						Z29->(dbSkip())
					EndDo				
				End Transaction
			EndIf
		EndIf
		
		If nOpc == 4	// Alteração
			
			Begin Transaction
				dbSelectArea("Z29")
				dbGoto(nRecno)				
				cOldKEY := Z29->Z29_FILIAL+Z29->Z29_CODFAM
				
				For nI := 1 to Len(aCols)
					// Caso a linha nao esteja deletada
					If !(aCols[nI,Len(aCols[nI])])
						dbSelectArea("Z29")
						dbSetOrder(3)	//--Z29_FILIAL+Z29_CODFAM+Z29_CODAPR+Z29_CC+Z29_CLVL
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][nPCODAPR] + aCols[nI][nPCODCCT] + aCols[nI][nPCODCLV] )
							If Reclock("Z29",.F.)
								Z29->Z29_FILIAL := xFilial("Z29")
								Z29->Z29_CODFAM := M->Z29_CODFAM
								Z29->Z29_DESFAM := M->Z29_DESFAM
								For nZ := 1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z29->(MsUnLock())
							EndIf
						Else
							If Reclock("Z29",.T.)
								Z29->Z29_FILIAL := xFilial("Z29")
								Z29->Z29_CODFAM := M->Z29_CODFAM
								Z29->Z29_DESFAM := M->Z29_DESFAM
								For nZ := 1 to Len(aHeader)
									FieldPut(FieldPos(aHeader[nZ,2]),aCols[nI,nZ])
								Next nZ
								Z29->(MsUnLock())
							EndIf						
						EndIf
					Else
						dbSelectArea("Z29")
						dbSetOrder(3)	//--Z29_FILIAL+Z29_CODFAM+Z29_CODAPR+Z29_CC+Z29_CLVL
						dbGoTop()
						If dbSeek ( cOldKEY + aCols[nI][nPCODAPR] + aCols[nI][nPCODCCT] + aCols[nI][nPCODCLV] )
							If Reclock("Z29",.F.)
								Z29->(dbDelete())
								Z29->(MsUnLock())
							EndIf
						EndIf					
					EndIf
				Next nI		
	    	End Transaction
	    	
		EndIf
	EndIf

Return