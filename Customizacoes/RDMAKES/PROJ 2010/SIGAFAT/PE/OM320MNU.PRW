#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM320MNU    ºAutor  ³Rafael Parma      º Data ³  29/10/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para adicionar opção ao menu da rotina de  º±±
±±º          ³retorno de cargas.                                          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       

*---------------------------*
User Function OM320MNU()     
*---------------------------*

Local cPARATIVO := ALLTRIM(SuperGetMV("MV_X_AWCFC",,"N"))      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona opção Conf. de Itens ao menu da rotina de retorno de cargas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If cPARATIVO == "S"
		aAdd(aRotina,{'Conf. Itens'  ,'U_RJO320CI' , 0 , 5, 0 , NIL})
	EndIf

Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJO320CI    ºAutor  ³Rafael Parma      º Data ³  03/11/2010 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para conferência de itens fiscais, retorno º±±
±±º          ³de cargas.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/       

*---------------------------*
User Function RJO320CI()
*---------------------------*
Local aArea        := GetArea()
Local nOpcNewReg   := GD_INSERT + GD_UPDATE + GD_DELETE
Local aPosObj      := {}
Local aObjects     := {}
Local aSize        := MsAdvSize( .F. )
Local aGet         := {}
Local aTravas      := {}
Local aEntidade    := {}
Local aRecZ19      := {}
Local aChave       := {}
Local aAlterEnch   := {}

Local cSeekZ19     := ""
Local cEntidade    := "Z19"
Local lGravou      := .F.
Local lTravas      := .T.
Local nOpcUPD      := 4
Local nCntFor      := 0
Local nUsado       := 0
Local nPosUser     := 0
Local nOpcA        := 0
Local nScan        := 0
Local nLoop        := 0

Local oDlg
Local oGetD
Local oGetCpo

PRIVATE aCols      := {}
PRIVATE aHeader    := {}
PRIVATE aDados	   := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Código da carga³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	cDAKCOD := DAK->DAK_COD
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Montagem do aHeader
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("DAI_SEQUEN")
	nUsado++
	aadd(aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("DAI_NFISCA")
	nUsado++
	aadd(aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )

	dbSelectArea("SX3")
	dbSetOrder(2)
	dbSeek("DAI_SERIE")
	nUsado++
	aadd(aHeader,{ AllTrim(X3Titulo()),;
		SX3->X3_CAMPO,;
		SX3->X3_PICTURE,;
		SX3->X3_TAMANHO,;
		SX3->X3_DECIMAL,;
		SX3->X3_VALID,;
		SX3->X3_USADO,;
		SX3->X3_TIPO,;
		SX3->X3_ARQUIVO,;
		SX3->X3_CONTEXT } )
                            
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Adiciona ítens de conferência cadastrados na tabela Z18(ITENS DE CONFERENCIA)³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("Z18")	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Z18_FILIAL+Z18_CODIGO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSetOrder(1)	
	dbGoTop()    
	dbSeek ( xFilial("Z18") )
	While !Z18->(EOF()) .AND. Z18->Z18_FILIAL == xFilial("Z18")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Todos os campos adicionados tem a configuração do campo Z19_VALITE³
		//³mas com o título da tabela Z18                                    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If Z18->Z18_ATIVO == "S"			
			dbSelectArea("SX3")
			dbSetOrder(2)
			dbSeek("Z19_VALITE")
			nUsado++
			cTITULO := lower(AllTrim(Z18->Z18_TITULO))
			cTITULO := Upper(SubSTR(cTITULO,1,1)) + SubSTR(cTITULO,2,Len(cTITULO))
			cCodCpo := Z18->Z18_CODIGO  
			
			aAdd(aHeader,{cTITULO,;
              SX3->X3_CAMPO+cCodCpo,;
              SX3->X3_PICTURE,;
              SX3->X3_TAMANHO,;
              SX3->X3_DECIMAL,;
              SX3->X3_VALID,;
              SX3->X3_USADO,;
              SX3->X3_TIPO,;
              SX3->X3_F3,;
              SX3->X3_CONTEXT,;
              iif(UPPER(cTITULO) == "JUSTIFICATIVA", "1=Falta de assinatura;2=NF Retornada", SX3->X3_CBOX),;
              SX3->X3_RELACAO,;
              ".T."})				
	
			aAdd( aAlterEnch, SX3->X3_CAMPO+cCodCpo)			
			
		EndIf
		Z18->(dbSkip())
	Enddo

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Montagem dos dados do grid ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
  
  nPosJus := 0
  nPosJus := aScan(aHeader, {|x| Upper(AllTrim(x[1])) == "JUSTIFICATIVA"})
  
	dbSelectArea("DAI")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( xFilial("DAI") + DAK->DAK_COD )
		While !DAI->(EOF()) .and. DAI->DAI_FILIAL == xFilial("DAI") .and. DAI->DAI_COD == DAK->DAK_COD
			AAdd(aCols,Array(nUsado+1))
			aCols[Len(aCols)][01] := DAI->DAI_SEQUEN
			aCols[Len(aCols)][02] := DAI->DAI_NFISCA
			aCols[Len(aCols)][03] := DAI->DAI_SERIE
			If nUsado > 3
				For nI := 4 to nUsado
					if nI == nPosJus 
						aCols[Len(aCols)][nI] := " "	
					Else
						aCols[Len(aCols)][nI] := "N"
					EndIf
				Next nI
			EndIf
			aCols[Len(aCols)][nUsado+1] := .F.			
			DAI->(dbSkip())			
		Enddo
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Alteração dos dados adicionais de conferência, caso já tenham sido cadastrados uma vez.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If Len(aCols) > 0 .and. nUsado > 3
		For nI := 1 to Len(aCols)            
			For nJ := 4 to nUsado                                                                                   
			
				dbSelectArea(cEntidade)
				dbSetOrder(4)	//Z19_FILIAL+Z19_CARGA+Z19_NOTAFI+Z19_SERIEN+Z19_CODITE
		 		(cEntidade)->(dbGoTop())
			 	If dbSeek ( xFilial(cEntidade) + cDAKCOD + aCols[nI,02] + aCols[nI,03] + SubSTR(aHeader[nJ,2],11,6) )
			 		aCols[nI][nJ] := Z19->Z19_VALITE
			 	EndIf			
			                                   
			Next nJ		
		Next nI
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Visualizacão ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !Empty(DAK->DAK_DTACCA)
		nOpcNewReg := 2
		
		dbSelectArea(cEntidade)
		dbSetOrder(4)	//Z19_FILIAL+Z19_CARGA+Z19_NOTAFI+Z19_SERIEN+Z19_CODITE
 		(cEntidade)->(dbGoTop())
	 	If !dbSeek ( xFilial(cEntidade) + cDAKCOD )
			if Aviso( "Atenção", "Conferência não realizada para esta carga!", {"Continuar?", "Cancelar?"}, 2 )	!= 1
				Return
			EndIf
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Monta janela ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If ( lTravas )

		AAdd( aObjects, { 100, 036, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlg TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 021,005 SAY OemToAnsi("Número carga:") SIZE 050,009 OF oDlg PIXEL 
		@ 020,060 GET oGetCpo VAR cDAKCOD SIZE 030,009 OF oDlg PIXEL WHEN .F.

		oGetDAT := MsNewGetDados():New( aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4], nOpcNewReg, "AllwaysTrue()", "AllwaysTrue()", "", aAlterEnch , 0, Len(aCols),,, .T.,, aHeader ,aCols )

		ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg, {|| iif(ValidaGrid(oGetDAT),{nOpcA:=1,oDlg:End()},)} , {||oDlg:End()})
		

		If ( nOpcA == 1 )
			Begin Transaction
				RJO320GRV(nUsado)
			End Transaction
			
			if Aviso("Controle de Caixas","Deseja fazer o retorno das caixas enviadas na carga?",{"Sim","Não"},2) != 2
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Chamada rotina controle de caixas.³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				Aadd(aDados, xFilial("DAK"))
				Aadd(aDados, DAK->DAK_COD)
				Aadd(aDados, 'Entrada')
				
				U_CTRL_CAIX(aDados)	
				
			EndIf
			
		EndIf
   
	EndIf
	
	RestArea( aArea )

Return(lGravou)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡Ì¿
//³Função responsável pela validação do GRID³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ‡ÌÙ

Static Function ValidaGrid(oGetDAT)
Local aCols   := oGetDAT:aCols
Local aHeader := oGetDAT:aHeader
Local lRet    := .T.
Local nPosCan := 0
Local nPosJus := 0
Local nPosNf  := 0
Local nPosSer := 0
Local nI      := 0
Local cIncons := ""

nPosCan := aScan(aHeader, {|x| Upper(AllTrim(x[1])) == "CANHOTO NF"})
nPosJus := aScan(aHeader, {|x| Upper(AllTrim(x[1])) == "JUSTIFICATIVA"})
nPosNf  := aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_NFISCA"})
nPosSer := aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_SERIE"})

for nI := 1 to len(aCols)
	if aCols[nI,nPosCan] == "N"
	  if Empty(aCols[nI, nPosJus])
	  	lRet    := .F.
	  	cIncons += " - NF "+Trim(aCols[nI,nPosNf])+" Serie "+Trim(aCols[nI,nPosSer])+ " = "+;
	  						 "Selecione uma justificativa. "+CHR(13)+CHR(10)
	  EndIf
	ElseIf !aCols[nI,nPosCan] $ "S/N" 
		lRet    := .F.
		cIncons += " - NF "+Trim(aCols[nI,nPosNf])+" Serie "+Trim(aCols[nI,nPosSer])+ " = "+;
	  					 "Defina se o canhoto foi recebido (S/N). "+CHR(13)+CHR(10)
	Else
		if !Empty(aCols[nI, nPosJus])
			lRet    := .F.
			cIncons += " - NF "+Trim(aCols[nI,nPosNf])+" Serie "+Trim(aCols[nI,nPosSer])+ " = "+;
	  					   "Se o canhoto foi recebido, não é necessário justificativa. "+CHR(13)+CHR(10)
		EndIf
	EndIf	
Next nI

If !Empty(cIncons)
	Aviso("Inconsistências encontradas...",cIncons,{"Ok"},3)	
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJO320GRV  ºAutor  ³Rafael Parma       º Data ³  03/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Função utilizada para gravação dos dados.                    ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/                                    

*------------------------------------*
Static Function RJO320GRV(nUsado)
*------------------------------------*
Local aCols     := oGetDAT:aCols
Local aHead     := oGetDAT:aHeader
Local aDados    := {}
Local nPosJus   := 0
Local nPosCan   := 0

nPosJus := aScan(aHead, {|x| Upper(AllTrim(x[1])) == "JUSTIFICATIVA"})
nPosCan := aScan(aHead, {|x| Upper(AllTrim(x[1])) == "CANHOTO NF"})

	If Len(aCols) > 0
		For nI := 1 to Len(aCols)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Adiciona no array de dados do workflow os canhotos sem assinatura³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		  cJust := ""
			if aCols[nI, nPosCan] == "N" 
				if aCols[nI, nPosJus] == "1"
					cJust := "Falta de Assinatura"	
				Elseif aCols[nI, nPosJus] == "2"
					cJust := "NF Retornada"
				EndIf                   
			
				Aadd(aDados, {aCols[nI, 03], aCols[nI, 02], cJust})
			EndIf
			
			If nUsado > 3
				For nJ := 4 to nUsado
					dbSelectArea("Z19")
					dbSetOrder(4)	//Z19_FILIAL+Z19_CARGA+Z19_NOTAFI+Z19_SERIEN+Z19_CODITE
			 		dbGoTop()
				 	If dbSeek ( xFilial("Z19") + DAK->DAK_COD + aCols[nI,02] + aCols[nI,03] + SubSTR(aHead[nJ,2],11,6) )
				 		If RecLock("Z19",.F.) 
				 			Z19->Z19_VALITE := aCols[nI,nJ]
				 			Z19->(MsUnLock())
				 		EndIf
				 	Else
				 		If RecLock("Z19",.T.) 
				 			Z19->Z19_FILIAL := xFilial("Z19")
				 			Z19->Z19_CARGA	:= DAK->DAK_COD
				 			Z19->Z19_NOTAFI	:= aCols[nI,02]
				 			Z19->Z19_SERIEN	:= aCols[nI,03]
				 			Z19->Z19_CODITE := SubSTR(aHead[nJ,2],11,6)
				 			Z19->Z19_VALITE := aCols[nI,nJ]
				 			Z19->(MsUnLock())
				 		EndIf
				 	EndIf				
				Next nJ
			EndIf	
		Next nI	
	EndIf
	
	if Len(aDados) > 0
		EnvMail(aDados)
	EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função responsável pelo envio do workflow dos canhotos sem assinatura³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function EnvMail(aDados)
Local cCarga   := DAK->DAK_COD
Local cPlaca   := DAK->DAK_CAMINH
Local cEmail   := AllTrim(SuperGetMv("MV_X_CONFIT",,"suporte.microsiga@grupocantu.com.br"))
Local nI       := 0
Local oProcess
Local oHtml
Local cProcess := OemToAnsi("008080") // Numero do Processo
cStatus  			 := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Canhotos Não Assinados"))
oProcess:NewTask(cStatus,"\workflow\wfconfitens.html")
oProcess:cSubject := OemToAnsi("FILIAL "+ SM0->M0_FILIAL +" CARGA " + AllTrim(cCarga) + " - CANHOTOS NÃO ASSINADOS.")
  
oProcess:cTo := AllTrim(cEmail)
                                    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Preenchimento do cabeçalho do workflow³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

oHTML:= oProcess:oHTML		
oHtml:ValByName("CCARGA"   ,AllTrim(cCarga))
oHtml:ValByName("CFILIAL"  ,SM0->M0_FILIAL)
oHtml:ValByName("CVEICULO", AllTrim(cPlaca))

For nI := 1 to len(aDados)
	Aadd((oHtml:ValByName( "IT.SERIE" ))   , aDados[nI, 01])
	Aadd((oHtml:ValByName( "IT.NF" ))      , aDados[nI, 02])
	Aadd((oHtml:ValByName( "IT.JUSTIFIC" )), aDados[nI, 03])
Next nI

oHtml:ValByName("NTOTNAODEV",Transform(Len(aDados), '@E 999'))

oProcess:Start()
oProcess:Finish()

Return 