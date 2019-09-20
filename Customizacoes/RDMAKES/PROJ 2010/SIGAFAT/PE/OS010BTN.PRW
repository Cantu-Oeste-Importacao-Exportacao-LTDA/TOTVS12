#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"
                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณOS010BTN  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAdiciona botใo a Enchoice rotina de cadastro de tabela pre็oบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function OS010BTN()
Local aButtons := {}   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	aAdd( aButtons, {"REPLICA", {|| U_REPTABPC()}, "Replicar Tabela", "Replicar Tabela" , {||.T.}} )

Return(aButtons)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณREPTABPC  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para replica็ใo de tabela de pre็o.                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function REPTABPC()
                                    
Local aAreaTMP		:= GetArea()
Private oFONTTAB	:= TFont():New('Courier new',,-12,.T.)
Private aEMPRESA	:= {}
Private cEMPRESA	:= ""
Private cCODTAB		:= Space(TAMSX3("DA0_CODTAB")[1])
Private lCODTAB		:= .T.
Private lREPLICA	:= .F.
Private oDlgREP, oCOMBO, oCHECK, oGETCOD


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณChama fun็ใo para monitor uso de fontes customizadosณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SM0")
	nRECEMP := SM0->(RECNO())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While !SM0->(EOF())
		If ! ( SM0->M0_CODIGO == cEmpAnt .and. SM0->M0_CODFIL == cFilAnt )
			aAdd (	aEMPRESA, SM0->M0_CODIGO+"/"+SM0->M0_CODFIL+"-"+ALLTRIM(UPPER(SM0->M0_FILIAL))+"-"+ALLTRIM(UPPER(SM0->M0_NOME)) )
		EndIf
		SM0->(dbSkip())
	Enddo
	SM0->(dbGoTo(nRECEMP))
	cEMPRESA := aEMPRESA[1]

	DEFINE MSDIALOG oDlgREP TITLE "Replica็ใo da Tabela de Pre็o" FROM 001,001 TO 210,420 PIXEL
	
	TSay():New(005,005,{|| "Replicar Tabela de Pre็o: "+M->DA0_CODTAB+"-"+ALLTRIM(M->DA0_DESCRI) },oDlgREP,,oFONTTAB,,,,.T.,CLR_RED,CLR_WHITE,200,20)
	
	TSay():New(025,005,{|| "Replicar para Empresa/Filial: " },oDlgREP,,,,,,.T.,,,100,010,,,,.T.,,.T.)	
	oCOMBO := TComboBox():Create(oDlgREP,{|u|if(PCount()>0,cEMPRESA:=u,cEMPRESA)},035,005,aEMPRESA,150,20,,,,,,.T.,,,,,,,,,'cCombo')

	@ 050,005 CHECKBOX oCHECK VAR lCODTAB PROMPT "Manter C๓digo" SIZE 60,007 PIXEL OF oDlgREP ON CLICK(fUpdFlag())
	
	TSay():New(065,005,{|| "Novo C๓digo: " },oDlgREP,,,,,,.T.,,,050,010,,,,.T.,,.T.)	
	@ 064,050 MSGET oGETCOD VAR cCODTAB SIZE 030,10 WHEN !lCODTAB OF oDlgREP PIXEL                                                                 

	TButton():New(086,080,'&Replicar',oDlgREP,{||lREPLICA:=.T.,IIF(fValForm(),oDlgREP:End(),)},050,010,,,,.T.,,,,,,)
	TButton():New(086,140,'&Fechar',oDlgREP,{||lREPLICA:=.F.,oDlgREP:End()},050,010,,,,.T.,,,,,,)
	
	ACTIVATE MSDIALOG oDlgREP CENTERED         
	
	If lREPLICA                     
		aDA0TMP := {}
		aDA1TMP := {}		
		fPopVet("DA0",@aDA0TMP,xFilial("DA0"),M->DA0_CODTAB,cCODTAB)
		fPopVet("DA1",@aDA1TMP,xFilial("DA1"),M->DA0_CODTAB,cCODTAB)
		cEMPDES := SubSTR(cEMPRESA,1,2)
		cFILDES := SubSTR(cEMPRESA,4,2)
		RptStatus( { |lEnd| fReplTABPRC(aDA0TMP, aDA1TMP, IIF(!Empty(cCODTAB),cCODTAB,M->DA0_CODTAB), cEMPDES, cFILDES ) }, "Aguarde...","Replicando tabela de pre็o...", .T.)
		MsgInfo("Processo concluํdo!"+chr(13)+"Tabela replicada para empresa/filial: "+cEMPRESA)
	EndIf
		
	RestArea(aAreaTMP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdFlag  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para atualiza็ใo de campos da janela.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fUpdFlag()

	cCODTAB	:= Space(TAMSX3("DA0_CODTAB")[1])
	oGETCOD:Refresh()
	oDlgREP:Refresh()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfReplTABPRCบAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para atualiza็ใo de campos da janela.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fReplTABPRC(aDA0TMP, aDA1TMP, cCODTAB, cEMPDES, cFILDES)
Local aAreaTMP	:= GetArea()
Local cEMPORI	:= cEmpAnt
Local cFILORI	:= cFilAnt

	RpcClearEnv()
	RpcSetType(3)	
	RpcSetEnv(cEMPDES,cFILDES,,,,GetEnvServer(),{"DA0","DA1"})
	
	Begin Transaction
		//--Elimina registros
		fDelReg("DA0", xFilial("DA0")+cCODTAB)
		fDelReg("DA1", xFilial("DA1")+cCODTAB)
		//--Inclui registros
		fIncReg("DA0", aDA0TMP)
		fIncReg("DA1", aDA1TMP)
	End Transaction
	
	RpcClearEnv()
	RpcSetEnv(cEMPORI,cFILORI,,,,GetEnvServer(),{"DA1","DA1"})	

	RestArea(aAreaTMP)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfPopVet    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para popular vetores de registros.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fPopVet(cTABELA, aDADOSTMP, cCODFIL, cCODTAB, cNEWCOD)
Local cWHILE := IIF(cTABELA=="DA0","DA0->(DA0_FILIAL+DA0_CODTAB)","DA1->(DA1_FILIAL+DA1_CODTAB)")

	dbSelectArea(cTABELA)
	dbSetOrder(1)
	dbSeek(cCODFIL+cCODTAB)
	While !(cTABELA)->(EOF()) .and. &(cWHILE) == cCODFIL+cCODTAB
	    aAdd (aDADOSTMP, { {} } )
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek(cTABELA)
		While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == cTABELA
			If SX3->X3_TIPO != "V" .and. (cTABELA)->(FieldPos(SX3->X3_CAMPO)) > 0
				If "CODTAB" $ SX3->X3_CAMPO .and. !Empty(cNEWCOD)
					aAdd ( aDADOSTMP[Len(aDADOSTMP),01], { SX3->X3_CAMPO, cNEWCOD } )
				Else
					aAdd ( aDADOSTMP[Len(aDADOSTMP),01], { SX3->X3_CAMPO, (cTABELA)->&(SX3->X3_CAMPO) } )
				EndIf
			EndIf
			SX3->(dbSkip())
		Enddo
		(cTABELA)->(dbSkip())		
	Enddo
	
Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDelReg    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para exclusใo de registros.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fDelReg(cTABELA, cCHAVE)
Local cWHILE := IIF(cTABELA=="DA0","DA0->(DA0_FILIAL+DA0_CODTAB)","DA1->(DA1_FILIAL+DA1_CODTAB)")

	dbSelectArea(cTABELA)
	dbSetOrder(1)
	dbSeek(cCHAVE)
	While !(cTABELA)->(EOF()) .and. &(cWHILE) == cCHAVE
		RecLock(cTABELA,.F.)
		(cTABELA)->(dbDelete())
		(cTABELA)->(MsUnLock())
		(cTABELA)->(dbSkip())		
	Enddo
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfIncReg    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para inclusใo de registros.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fIncReg(cTABELA, aTMPINC)

	If Len(aTMPINC) > 0
		For nI := 1 to Len(aTMPINC)
			RecLock(cTABELA,.T.)
			For nJ := 1 to Len(aTMPINC[nI,01])
				If (cTABELA)->(FieldPos(aTMPINC[nI,01][nJ,01])) > 0
					If "FILIAL" $ aTMPINC[nI,01][nJ,01] 
						(cTABELA)->&(aTMPINC[nI,01][nJ,01]) := xFilial(cTABELA)
					Else
						(cTABELA)->&(aTMPINC[nI,01][nJ,01]) := aTMPINC[nI,01][nJ,02]
					EndIf
				EndIf
			Next nJ
			(cTABELA)->(MsUnLock())
		Next nI
	EndIf
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfValForm   บAutor  ณTOTVS PARANA CENTRALบ Data ณ  19/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para valida็ใo do formulแrio.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fValForm()
Local lRet := .T.

	If !lCODTAB .and. Empty(cCODTAB)
		MsgInfo("Novo C๓digo estแ vazio!")
		lRet := .F.
	EndIf

Return (lRet)