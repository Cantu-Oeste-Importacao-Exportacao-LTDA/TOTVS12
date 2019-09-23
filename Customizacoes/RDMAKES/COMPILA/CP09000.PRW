
#Include "Protheus.Ch"
//#Include "rwmake.Ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE 'FWMVCDEF.CH'
//#INCLUDE "FWMBROWSE.CH"      
//#INCLUDE 'TBICONN.CH'



/* - FWMVCDEF
MODEL_OPERATION_INSERT para inclusão;
MODEL_OPERATION_UPDATE para alteração;
MODEL_OPERATION_DELETE para exclusão.
MODEL_OPERATION_VIEW para visualizacao.
*/



/*/{Protheus.doc} CP09CSE5
Realiza a conciliação do recno do SE5 passado.
@author Augusto Ribeiro | www.compila.com.br
@since 28/12/2016
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09CSE5(nRecSE5, dDtDisp,lDescon)
Local lPanelFin		:= IsPanelFin()
LOCAL nSldIniRec	:= 0		/*nSaldoIni Saldo anterior (Reconciliados)*/
LOCAL nSldFinRec	:= 0		/*nSaldoAtu Saldo atual (Reconciliados)*/
LOCAL nSldIniBanc	:= 0		/*nSaldoGer Saldo anterior (Bancario)*/
LOCAL nSldFinBanc	:= 0		/*Saldo Atual (Bancario)*/
Local nOpca 		:= 0
LOCAL cIndex1		:= ""
LOCAL aStruct		:= {}
LOCAL dDTLimRec		:= GetMV("MV_DATAREC")
Local lF380Grv		:= ExistBlock("F380GRV",.F.,.F.)
LOCAL aCampos		:= {}
LOCAL oDlg			:= NIL
LOCAL oQtdaP		:= NIL
LOCAL oQtdaR		:= NIL
LOCAL oValRec		:= NIL
LOCAL oValPag		:= NIL
LOCAL oValIni		:= NIL
Local oValAtu		:= NIL
Local oValRecT		:= NIL
Local oValGer		:= NIL
LOCAL oMark			:= 0
LOCAL lInverte		:= .f.
Local lAtuSaldo		:= .F.
Local lAtSalRec1	:= .F.
Local lAtSalRec2	:= .F.
Local nReconc		:= 0
Local cReconAnt		:= ""
Local aSize			:= {}
Local oPanel		:= NIL
Local cKeyCheque	:= ""  
Local lAltDt		:= .T.
Local aButtons		:= {}
Local lSaldoAtu		:= .F.
Local aArea			:= {}
Local nLinha		:= 0
Local nSize			:= 0
Local aColuna		:= {}
Local lF380VLD		:= ExistBlock("F380VLD",.F.,.F.) 
LOCAL lL380VLD		:= .F.
Local lF380AlDt 	:= ExistBlock("F380AlDt")
Local nPosVlr		:= 0
Local nValTit		:= 0
Local nTamFil		:= 0
Local nTamKey  	:= 0
Local nTamTipo   	:= 0
Local oTButtonP := Nil // Botão de pesquisa

// Variaveis para montar o indice de pesquisa
Local cIndex2 := CTOD("  /  /  ")  // Data Disponibilidade
Local cIndex3 := "" 					// Natureza
Local cIndex4 := 0 					// Valor Movimento
Local cIndex5 := "" 					// Receber/Pagar
Local cIndex6 := "" 					// Número
Local cIndex7 := "" 					// Beneficiário
/*
Gestao - inicio */
Local cFilAtu		:= cFilAnt
Local lOK			:= .F.
/* GESTAO - fim
*/
Local oModelMov := NIL 		//FWLoadModel("FINM030")
Local oSubFK5	:= NIL
Local oSubFKA	:= NIL
Local cCamposE5 := ""
Local lRet		:= .T.
Local cIdProc	 := "" 
Local cGeraFK6  := 'C2|CM|CX|DC|J2|JR|M2|MT|VM'

PRIVATE cIndexSE5 := ""
PRIVATE cMarca	 := GetMark()
PRIVATE lCtrlCheq	:= .F.


Default lDescon := .F.

IF lDescon
	cMark	:= ""
ELSE
	cMark	:= "X"
ENDIF

nTamFil := TamSX3("E5_FILIAL")[1]
nTamKey := TamSX3("E5_PREFIXO")[1]+TamSX3("E5_NUMERO")[1]+TamSX3("E5_PARCELA")[1] + 1
nTamTipo := TamSX3("E5_TIPO")[1]




dbSelectArea("SE5")
dbGoTo(nRecSE5)

//Caso a filial não seja totalmente compartilhada ajusto cFilAnt
If FWModeAccess("SE5",3)== "C"
	//Se filial de origem preenchida
	If !Empty(SE5->E5_FILORIG)
		cFilAnt := SE5->E5_FILORIG
	Else
	//Se filial de origem vazia (inconsistência de base)
		SM0->(dbSetOrder(1))
		SM0->(MsSeek(cEmpAnt+Alltrim(xFilial("SE5",SE5->E5_FILIAL))))
		cFilAnt := SM0->M0_CODFIL
	Endif
Else // Se a Filial é totalmente exclusiva, deve usar o _FILIAL
	cFilAnt := SE5->E5_FILIAL				
Endif
		  
//Carrega o Model de acordo com o tipo de registro da SE5
If SE5->E5_TIPODOC $ "BA|VL|V2|ES|LJ|CP"
	If (!Empty(SE5->E5_LOTE) .And. SE5->E5_TABORI == "FK5") .Or. ;	//Baixa por Lote
		(Alltrim(SE5->E5_TIPODOC) == "ES" .And. Empty(SE5->E5_MOTBX) .And. !Empty(SE5->E5_NUMCHEQ)) .Or.; //Estorno de movimento bancário
	    (Substr(SE5->E5_KEY,nTamKey,nTamTipo) $ MVPAGANT) .OR.;		//Movimento PA
	    (SE5->E5_TABORI == "FK5" .and. Alltrim(SE5->E5_ORIGEM) $ "FINA840|FINA850" ) .OR.;  //Movimentos de Recibo ou Ordem de Pago
	    ((!Empty(SE5->E5_KEY)) .and. SE5->E5_TABORI == "FK5")   //Baixas Estornadas cujo titulo foi excluido	
	    	
		oModelMov := FWLoadModel("FINM030")
	Else
		If SE5->E5_TABORI == "FK1" .OR. (SE5->E5_RECPAG == "R" .and. SE5->E5_TIPODOC <> "ES" .and. !SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG) .Or. (SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC == "ES" .and. !SE5->E5_TIPO $ MVPAGANT+"/"+MV_CPNEG);
			.OR. (SE5->E5_RECPAG == "P" .and. SE5->E5_TIPODOC <> "ES" .and. SE5->E5_TIPO $ MVRECANT+"/"+MV_CRNEG)  
				oModelMov := FWLoadModel("FINM010") //baixa a receber / RA
		Else
				oModelMov := FWLoadModel("FINM020")  //  Baixas a pagar / PA
		Endif
	EndIf	
Else
	If ! SE5->E5_TIPODOC $ cGeraFK6
		oModelMov := FWLoadModel("FINM030")				
	Else
		oModelMov := Nil  //Valores acessórios migra ao migrar a baixa
	EndIf	
EndIf
				
If Empty(SE5->E5_IDORIG) // se não houve migração
	oModelMov := Nil
EndIf


//Verifico se nao estava reconciliado anteriormente
If lCtrlCheq .and. cPaisLoc $ "ARG|DOM|EQU" .and. FUNNAME() $ "FINA095/FINA096"
	SEF->(DbSetOrder(6))                
	IF SEF->( DbSeek( xFilial("SEF")+SE5->E5_RECPAG+If(SE5->E5_RECPAG=="R",(SE5->E5_BCOCHQ+SE5->E5_AGECHQ+SE5->E5_CTACHQ+SUBSTR(SE5->E5_NUMERO,1,TAMSX3("EF_NUM")[1])),(SE5->E5_BANCO+SE5->E5_AGENCIA+SE5->E5_CONTA+SUBSTR(IIf(cPaisLoc == "ARG",SE5->E5_NUMERO,SE5->E5_NUMCHEQ),1,TAMSX3("EF_NUM")[1])))+SE5->E5_PREFIXO ))
		RecLock("SEF")                                            
		SEF->EF_RECONC := IIf(!lDescon,"x"," ")
		SEF->(MSUnlock())
	Endif
Endif
cReconAnt := SE5->E5_RECONC
If ValType(oModelMov) <> "U" 
	//Define os campos que não existem na FK5 e que serão gravados apenas na E5, para que a gravação da E5 continue igual
	cCamposE5 := "{"
	cCamposE5 += "{'E5_RECONC', '"  + IIf(!lDescon,"x"," ") + "'}"													
	cCamposE5 += "}"
	
	oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
	oModelMov:Activate()
	oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5 
	oModelMov:SetValue( "MASTER", "E5_CAMPOS", cCamposE5 ) //Informa os campos da SE5 que serão gravados indepentes de FK5
	
	//Posiciona a FKA com base no IDORIG da SE5 posicionada
	oSubFKA := oModelMov:GetModel( "FKADETAIL" )
	If SE5->E5_TABORI == "FK1" .OR. SE5->E5_TABORI == "FK2" 
		If oSubFKA:SeekLine( { {"FKA_TABORIG", SE5->E5_TABORI }, {"FKA_IDORIG", SE5->E5_IDORIG } } )
			cIdProc := oSubFKA:GetValue("FKA_IDPROC")
			oSubFKA:SeekLine( { {"FKA_TABORIG", "FK5" }, {"FKA_IDPROC", cIdProc } } )
		EndIf
		
	Else
		oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )
	EndIf
	
	//Dados do movimento
	oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )					
	If !lDescon
		oSubFK5:SetValue( "FK5_DTCONC", dDataBase )
	Else
		oSubFK5:SetValue( "FK5_DTCONC", CTOD("") )
	Endif

	If SE5->E5_DTDISPO # SE5->E5_DTDISPO
		dOldDispo := SE5->E5_DTDISPO
		lAtuSaldo := .T.
		oSubFK5:SetValue( "FK5_DTDISP", SE5->E5_DTDISPO )
		AltDtFilho( SE5->E5_DTDISPO )
	Endif
	
	If oModelMov:VldData()
       oModelMov:CommitData()
	Else
		lRet := .F.
		cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
		cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
		cLog += cValToChar(oModelMov:GetErrorMessage()[6])
		
		Help( ,,"MF380REC1",,cLog, 1, 0 )
	Endif

	oModelMov:DeActivate()
	oModelMov:Destroy()
	oModelMov:=NIL
Else
	Reclock("SE5", .F.)
	SE5->E5_RECONC := IIf(!lDescon,"x"," ")
	If SE5->E5_DTDISPO <> SE5->E5_DTDISPO
		SE5->E5_DTDISPO := SE5->E5_DTDISPO
	EndIf
	SE5->(MsUnlock())				
EndIf
//Acerto E5_DTDISPO dos titulos baixados com cheque para melhor apresentacao no
//relatorio de fluxo de caixa realizado
If lAtuSaldo .AND. !EMPTY(SE5->E5_NUMCHEQ)
	dbSelectArea("SE5")							
	dbSetOrder(11)
	If MsSeek(xFilial("SE5")+SE5->(E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ))
		cKeyCheque := SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
		While !Eof() .and. cKeyCheque == SE5->(E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+E5_NUMCHEQ)
			If lF380AlDt	
				lAltDt:=ExecBlock("F380AlDt",.F.,.F.)
			EndIf	
			If lAltDt
				If SE5->( Recno() ) == nRecSE5 .Or. lF380AlDt
					oModelMov := FWLoadModel("FINM030") //Recarrega o Model de movimentos para pegar o campo do relacionamento (SE5->E5_IDORIG)
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) //Alteração
					oModelMov:Activate()
					oModelMov:SetValue( "MASTER", "E5_GRV", .T. ) //habilita gravação de SE5 
					
					//Posiciona a FKA com base no IDORIG da SE5 posicionada
					oSubFKA := oModelMov:GetModel( "FKADETAIL" )
					oSubFKA:SeekLine( { {"FKA_IDORIG", SE5->E5_IDORIG } } )	
					
					//Dados do movimento
					oSubFK5 := oModelMov:GetModel( "FK5DETAIL" )					
					oSubFK5:SetValue( "FK5_DTDISP", SE5->E5_DTDISPO )
					
					If oModelMov:VldData()
				       oModelMov:CommitData()
					Else
				       	lRet := .F.
					    cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
					    cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
					    cLog += cValToChar(oModelMov:GetErrorMessage()[6])        	
			        
				       	Help( ,,"MF380REC2",,cLog, 1, 0 )	
					Endif

					oModelMov:DeActivate()
					oModelMov:Destroy()
					oModelMov:=NIL

				EndIf
			EndIf	
			
			dbSkip()
		Enddo
	Endif
	dbGoTo( nRecSE5 )
Endif

If lF380Grv
	ExecBlock("F380GRV",.F.,.F.)
EndIf	

//Verifico atualizacao do saldo conciliado
DO CASE
	CASE Empty(cReconAnt) .and. !Empty(SE5->E5_RECONC)
		nReconc := 1 	//Se foi reconciliado agora 			
	CASE !Empty(cReconAnt) .and. Empty(SE5->E5_RECONC)
		nReconc := 2 	//Se foi desconciliado agora
	CASE !Empty(cReconAnt) .and. !Empty(SE5->E5_RECONC)
    nReconc := 3	//Nao foi alterada a situacao anterior, mas ja estava conciliado
CASE Empty(cReconAnt) .and. Empty(SE5->E5_RECONC)		
    nReconc := 3	//Nao foi alterada a situacao anterior, mas nao estava conciliado
END CASE				

If lAtuSaldo  // atualiza saldo bancario se alterou o E5_DTDISPO
	lAtuSaldo := .F.

	//Atualiza saldo conciliado na data antiga
	lAtSalRec1 := IIF( !Empty(SE5->E5_RECONC) .AND. (nReconc == 2 .or. nReconc == 3), .T., .F.)
	//Atualiza saldo conciliado na data nova
	lAtSalRec2 := IIF( !Empty(SE5->E5_RECONC) .AND. nReconc != 4, .T., .F.)

	If SE5->E5_RECPAG == "P"
		AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dOldDispo,SE5->E5_VALOR,"+",lAtSalRec1)
		AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"-",lAtSalRec2)
	Else
		AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,dOldDispo,SE5->E5_VALOR,"-",lAtSalRec1)
		AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,"+",lAtSalRec2)
	Endif
Else
	//Atualiza apenas o saldo reconciliado
	If nReconc == 2	//Desconciliou
		If Alltrim(SE5->E5_TIPODOC) $ "TR;BD"
			nValTit := SE5->E5_VALOR
			aAreaSE5	:= SE5->( GetArea() )
			dbSelectArea("SE5")
			SE5->(dbsetorder(2))
			if SE5->(dbseek(SE5->E5_FILIAL+"I2"+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DTOS(E5_DATA)+ SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ))
				nValTit += SE5->E5_VALOR 
			EndIf
			RestArea( aAreaSE5 )
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,nValTit,IIF(SE5->E5_RECPAG == "P","+","-"),.T.,.F.)
		Else
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,IIF(SE5->E5_RECPAG == "P","+","-"),.T.,.F.)
		EndIf			
	Endif
	If nReconc == 1	//Conciliou
		If Alltrim(SE5->E5_TIPODOC) $ "TR;BD"
			nValTit := SE5->E5_VALOR
			aAreaSE5	:= SE5->( GetArea() )
			dbSelectArea("SE5")
			SE5->(dbsetorder(2))
			if SE5->(dbseek(SE5->E5_FILIAL+"I2"+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+DTOS(E5_DATA)+ SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ))
				nValTit += SE5->E5_VALOR 
			EndIf
			RestArea( aAreaSE5 )
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,nValTit,IIF(SE5->E5_RECPAG == "P","-","+"),.T.,.F.)
		Else
			AtuSalBco(SE5->E5_BANCO,SE5->E5_AGENCIA,SE5->E5_CONTA,SE5->E5_DTDISPO,SE5->E5_VALOR,IIF(SE5->E5_RECPAG == "P","-","+"),.T.,.F.)
		EndIf			
	Endif
Endif

Return(lRet)


/*/{Protheus.doc} CP09INC5
Inclui movimentação bancária
@author Augusto Ribeiro | www.compila.com.br
@since 02/01/2017
@version 6
@param cOpc, cOpc == "PAGAR", cOpc == "RECEBER"
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09INC5(nValor, cHist, cBanco, cAgenc, cConta, cNatOper, cCcusto, cCCC, cCCD, cCLLVCR, cCLLVDB)
Local aRet	:= {.f.,""}
Local nOpc := 0
Local aFINA100 := {}
//Local cNaturez	:= "D002" //| ### |
Local cAutoLog, cMemo

Default cCcusto	:= ""

Private lMsErroAuto := .F.


cNaturez	:= cNatOper


IF nValor <> 0 .AND. !EMPTY(cBanco) .AND. !EMPTY(cAgenc) .AND. !EMPTY(cConta)
	
	
	IF nValor > 0
		nOpc := 4	
	ELSE
		nOpc := 3
	ENDIF
	
	If nOpc == 3 .or. nOpc == 4
		
		lMsErroAuto := .F.
		aFINA100 := {}
		If nOpc == 3 
			/*
			aFINA100 := { {"E5_DATA" ,dDataBase ,Nil},;
			{"E5_MOEDA" ,"M1" ,Nil},;
			{"E5_VALOR" ,nValor*-1 ,Nil},;
			{"E5_NATUREZ" ,cNaturez,Nil},;
			{"E5_BANCO" ,cBanco ,Nil},;
			{"E5_AGENCIA" ,cAgenc ,Nil},;
			{"E5_CONTA" ,cConta ,Nil},;
			{"E5_CCUSTO" ,cCcusto ,Nil},;
			{"E5_BENEF" ,"" ,Nil},;
			{"E5_HISTOR" ,cHist ,Nil}}
			*/
			
			aadd(aFINA100, {"E5_DATA" ,dDataBase ,Nil})
			aadd(aFINA100, {"E5_MOEDA" ,"M1" ,Nil})
			aadd(aFINA100, {"E5_VALOR" ,nValor*-1 ,Nil})
			
			//MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,3)
			
		ElseIf nOpc == 4
			/*
			aFINA100 := { {"E5_DATA" ,dDataBase ,Nil},;
			{"E5_MOEDA" ,"M1" ,Nil},;
			{"E5_VALOR" ,nValor ,Nil},;
			{"E5_NATUREZ" ,cNaturez,Nil},;
			{"E5_BANCO" ,cBanco ,Nil},;
			{"E5_AGENCIA" ,cAgenc ,Nil},;
			{"E5_CONTA" ,cConta ,Nil},;
			{"E5_CCUSTO" ,cCcusto ,Nil},;
			{"E5_HISTOR" ,cHist ,Nil}}
			*/
			
			aadd(aFINA100, {"E5_DATA" ,dDataBase ,Nil})
			aadd(aFINA100, {"E5_MOEDA" ,"M1" ,Nil})
			aadd(aFINA100, {"E5_VALOR" ,nValor ,Nil})
			
			//MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,4)
		
		ENDIF
		
		IF !EMPTY(cCCC)
			aadd(aFINA100, {"E5_CCC" ,cCCC ,Nil})
		ENDIF
		IF !EMPTY(cCCD)
			aadd(aFINA100, {"E5_CCD" ,cCCD ,Nil})
		ENDIF
		IF !EMPTY(cCLLVCR)
			aadd(aFINA100, {"E5_CLVLCR" ,cCLLVCR ,Nil})
		ENDIF
		IF !EMPTY(cCLLVDB)
			aadd(aFINA100, {"E5_CLVLDB" ,cCLLVDB ,Nil})
		ENDIF		
		aadd(aFINA100, {"E5_NATUREZ" ,cNaturez,Nil})
		aadd(aFINA100, {"E5_BANCO" ,cBanco ,Nil})
		aadd(aFINA100, {"E5_AGENCIA" ,cAgenc ,Nil})
		aadd(aFINA100, {"E5_CONTA" ,cConta ,Nil})
		aadd(aFINA100, {"E5_CCUSTO" ,cCcusto ,Nil})
		aadd(aFINA100, {"E5_BENEF" ,"" ,Nil})
		aadd(aFINA100, {"E5_HISTOR" ,cHist ,Nil})	
		
		MSExecAuto({|x,y,z| FinA100(x,y,z)},0,aFINA100,nOpc)
		
	
		If 	lMsErroAuto									
			//MostraErro()
			cAutoLog	:= alltrim(NOMEAUTOLOG())
	
			cMemo := STRTRAN(MemoRead(cAutoLog),'"',"")
			cMemo := STRTRAN(cMemo,"'","")
	
			//| Apaga arquivo de Log
			Ferase(cAutoLog)
	
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Le Log da Execauto e retorna mensagem amigavel ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aRet[2] := U_CPXERRO(cMemo)
	
			IF EMPTY(aRet[2])
				aRet[2]	:= alltrim(cMemo)
			ENDIF
	
			DisarmTransaction()
		Else
			aRet[1]	:= .T.
		EndIf 
	endif
	
ELSE
	aRet[2]	:= "Parametros inválidos. Valor = 0 ou Banco, agencia e conta não informado"
ENDIF



Return(aRet)



/*/{Protheus.doc} CP09VINC
Vincula ZD2 e SE5 conciliados
@author Augusto Ribeiro | www.compila.com.br
@since 05/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09VINC(nRecZD2, aRecSE5)
Local aRet	:= {.f., ""}
Local nI


IF !EMPTY(nRecZD2) .AND. !EMPTY(aRecSE5) 
	DBSELECTAREA("ZD2")
	ZD2->(DBGOTO(nRecZD2))
	
	
	begin transaction
		
	DBSELECTAREA("SE5")
	for nI:= 1 to Len(aRecSE5)
		SE5->(DBGOTO(aRecSE5[nI]))
	
		RECLOCK("ZD3",.T.)
			ZD3->ZD3_CODEXT	:= ZD2->ZD2_CODIGO
			ZD3->ZD3_SE5IND	:=  2
			ZD3->ZD3_SE5CHV	:= SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA+E5_SEQ)
			ZD3->ZD3_SE5REC	:= SE5->(RECNO())
		MSUNLOCK()
		
	next nI
	
	
	IF EMPTY(ZD2->ZD2_DTCONC)
		RECLOCK('ZD2',.F.)
			ZD2->ZD2_DTCONC	:= DDATABASE
		MSUNLOCK()	
	ENDIF

	END transaction

	aRet[1]	:= .T.
ELSE
	aRet[2]	:= "Parametros inválidos"	
ENDIF

Return(aRet)






/*/{Protheus.doc} CP09CONC
Realiza conciliação dos Recnos EXTRATO e MOVIMENTO bancario passados.
@author Augusto Ribeiro | www.compila.com.br
@since 25/01/2017
@version version
@param aSE5Rec, aRecnos SE5 a serem conciliados
@param aZD2Rec, aRecnos SE5 a serem conciliados
@return aRet, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09CONC(aSE5Rec, aZD2Rec)
Local aRet	:= {.F., ""}
Local nI, nY, cCodZD3, nTotCpo
Local cItem		:= "000"
Local aDadosInc	:= {}
Local _cCodEmp, _cCodFil, _cFilNew

//IF !EMPTY(aSE5Rec) .AND. !EMPTY(aZD2Rec)

	
	aDadosInc	:= {}
	
	BEGIN TRANSACTION 
	
	
	
	IF !EMPTY(aZD2Rec)
		
		/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 11:57:35 AM
			Grava cabecalho da conciliação
		------------------------------------------------------------------------------------------*/
		RegToMemory("ZD5", .T., .F.)
		RecLock("ZD5", .T.)
		
		nTotCpo	:= ZD5->(FCOUNT()) 
		For nI := 1 To nTotCpo
			cNameCpo	:= ALLTRIM(ZD5->(FIELDNAME(nI)))
			nPosAux	:= aScan(aDadosInc, { |x| AllTrim(x[1]) == cNameCpo })  
			IF nPosAux > 0
				FieldPut(nI, aDadosInc[nPosAux, 2])
			ELSE
				FieldPut(nI, M->&(cNameCpo) )
			ENDIF
		Next nI
		
		ZD5->(MsUnLock())		
		CONFIRMSX8()
		
		
		/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 11:57:35 AM
			Grava  Itens Conciliados - Extrato
		------------------------------------------------------------------------------------------*/
		cItem		:= "000"	
		nTotCpo		:= ZD6->(FCOUNT())
		DBSELECTAREA("ZD2") 
		FOR nY := 1 to len(aZD2Rec)
		
			//| Posiciona registros |
			ZD2->(DBGOTO(aZD2Rec[nY]))
		
			cItem		:= SOMA1(cItem)
			aDadosInc	:= {}
			AADD(aDadosInc, {"ZD6_CODIGO",	ZD5->ZD5_CODIGO})
			AADD(aDadosInc, {"ZD6_ITEM", 	cItem })
			AADD(aDadosInc, {"ZD6_CODEXT",	ZD2->ZD2_CODIGO})
			AADD(aDadosInc, {"ZD6_ZD2REC",	ZD2->(RECNO()) })
			AADD(aDadosInc, {"ZD6_VALOR",	ZD2->ZD2_VALOR})
			
	
			RegToMemory("ZD6", .T., .F.)
			
		
			RecLock("ZD6", .T.)
			For nI := 1 To nTotCpo
				cNameCpo	:= ALLTRIM(ZD6->(FIELDNAME(nI)))
				nPosAux	:= aScan(aDadosInc, { |x| AllTrim(x[1]) == cNameCpo })  
				IF nPosAux > 0
					FieldPut(nI, aDadosInc[nPosAux, 2])
				ELSE
					FieldPut(nI, M->&(cNameCpo) )
				ENDIF
			Next nI
			
			ZD6->(MsUnLock())
			
			
			DBSELECTAREA("ZD2")	
			IF EMPTY(ZD2->ZD2_DTCONC)
				RECLOCK('ZD2',.F.)
					ZD2->ZD2_DTCONC	:= DDATABASE
					ZD2->ZD2_CODCON	:= ZD5->ZD5_CODIGO
				MSUNLOCK()	
			ENDIF
			
			
		NEXT nY
	ENDIF
	
	
	IF !EMPTY(aSE5Rec)
		/*------------------------------------------------------ Augusto Ribeiro | 25/01/2017 - 11:57:35 AM
			Grava  Itens Conciliados - Movimento Bancário
		------------------------------------------------------------------------------------------*/
		cItem		:= "000"	
		nTotCpo		:= ZD7->(FCOUNT())
		DBSELECTAREA("SE5") 
		FOR nY := 1 to len(aSE5Rec)
		
			//| Posiciona registros |
			SE5->(DBGOTO(aSE5Rec[nY]))
			
			
			 /*---------------------------------------
				Realiza a TROCA DA FILIAL CORRENTE 
			-----------------------------------------*/
			_cCodEmp 	:= SM0->M0_CODIGO
			_cCodFil	:= SM0->M0_CODFIL
			_cFilNew	:= SE5->E5_FILIAL //| CODIGO DA FILIAL DE DESTINO 
			
			IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
				CFILANT := _cFilNew
				opensm0(_cCodEmp+CFILANT)
			ENDIF
			
		 	/*--------------------------
		 		Realiza Conciliação do registro incluido
			---------------------------*/					 		
	 		lRetConc	:= U_CP09CSE5(SE5->(recno()))
	 		//lRetConc	:= .T.
	 		
	 		IF !EMPTY(aZD2Rec)
		 		IF lRetConc
		 			
					cItem		:= SOMA1(cItem)
					aDadosInc	:= {}
					AADD(aDadosInc, {"ZD7_CODIGO",	ZD5->ZD5_CODIGO})
					AADD(aDadosInc, {"ZD7_ITEM", 	cItem })
					AADD(aDadosInc, {"ZD7_SE5IND",	2})
					AADD(aDadosInc, {"ZD7_SE5CHV",	SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA+E5_SEQ)})
					AADD(aDadosInc, {"ZD7_SE5REC",	SE5->(RECNO())})
					AADD(aDadosInc, {"ZD7_VALOR",	IIF(SE5->E5_RECPAG == 'R', SE5->E5_VALOR, SE5->E5_VALOR*-1)})
				
					
					RegToMemory("ZD7", .T., .F.)
					
					RecLock("ZD7", .T.)
					For nI := 1 To nTotCpo
						cNameCpo	:= ALLTRIM(ZD7->(FIELDNAME(nI)))
						nPosAux	:= aScan(aDadosInc, { |x| AllTrim(x[1]) == cNameCpo })  
						IF nPosAux > 0
							FieldPut(nI, aDadosInc[nPosAux, 2])
						ELSE
							FieldPut(nI, M->&(cNameCpo) )
						ENDIF
					Next nI
					
					ZD7->(MsUnLock())		
				ELSE
					aRet[2]	:= "Falha na Conciliação do registros de valor["+alltrim(str(SE5->E5_VALOR))+"]SE5["+SE5->(E5_FILIAL+E5_TIPODOC+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO)+DTOS(SE5->E5_DATA)+SE5->(E5_CLIFOR+E5_LOJA+E5_SEQ)+"]"
					DISARMTRANSACTION()
					EXIT
		 		ENDIF
		 	ENDIF
	
			/*---------------------------------------
				Restaura FILIAL  
			-----------------------------------------*/
			IF _cCodEmp+_cCodFil <> _cCodEmp+_cFilNew
				CFILANT := _cCodFil
				opensm0(_cCodEmp+CFILANT)			 			
			ENDIF    		
			
		NEXT nY
	ENDIF

	END TRANSACTION 

/*
ELSE
	aRet[2]	:= "Parametros inválidos"	
ENDIF
*/

IF EMPTY(aRet[2])
	aRet[1]	:= .T. 
ENDIF


Return(aRet)






/*/{Protheus.doc} NextZD3
Retorna próxima código para inclusao do registro
@author Augusto Ribeiro | www.compila.com.br
@since 25/01/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function NextZD3()
Local cRet	:= ""


DBSELECTAREA("ZD3")
ZD3->(DBSETORDER(1)) //| 
ZD3->(DbGoBotton())
IF ZD3->(EOF())
	cRet	:= SOMA1(STRZERO(0,TAMSX3("ZD3_CODIGO")[1]))
ELSE
	ZD3->(DbGoBotton())
	cRet	:= SOMA1(ZD3->ZD3_CODIGO)
ENDIF

Return(cRet	)






/*/{Protheus.doc} CP09CSA6
Consulta padrão para listar somente bancos da filial posicionada
@author Augusto Ribeiro | www.compila.com.br
@since 26/01/2017
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09CSA6()
Local lRet		:= .F.
Local lContinua	:= .F.
Local cQuery	:= ""
Local cTitulo	:= "Bancos"
Local cAliasTab	:= "SA6"
Local aBtnAdd, oModel, cFilFilter

cQuery := " SELECT A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME,  SA6.R_E_C_N_O_ AS TAB_RECNO  "+CRLF
cQuery += " FROM "+RetSqlName("SA6")+" SA6 "+CRLF
cQuery += " WHERE ( A6_FILIAL LIKE '#CAMPO_BUSCA#%'
cQuery += " 	OR A6_COD LIKE '#CAMPO_BUSCA#%'  "+CRLF
cQuery += " 	OR A6_AGENCIA LIKE '#CAMPO_BUSCA#%'  "+CRLF
cQuery += " 	OR A6_NUMCON LIKE '#CAMPO_BUSCA#%'  "+CRLF
cQuery += " 	OR A6_NOME LIKE '%#CAMPO_BUSCA#%'  ) "+CRLF
cQuery += " AND A6_BLOCKED <> '1' "+CRLF		
cQuery += " AND D_E_L_E_T_ = ' ' "+CRLF	


lRet	:= U_CPXCPAD(cTitulo, cAliasTab, cQuery, aBtnAdd)


Return(lRet)




/*/{Protheus.doc} CP09DCON
Desconcilia extrato. Ao utilizar um dos parametros da funcao, automaticamente o outro será desconsiderado.
@author Augusto Ribeiro | www.compila.com.br
@since 16/02/2017
@version 6
@param cCodCon, Condigo da Conciliacao
@param nRecSE5, Recno do SE5
@param lChkSE5, Verifica se o titulo esta conciliado no financeiro
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CP09DCON(cCodCon, nRecSE5, lChkSE5)
local aRet	:= {.F., ""}
Local nCpoRec	:= TAMSX3("ZD7_SE5REC")[1]
Local cRecSE5	:= ""

Default lChkSE5	:= .F.


IF EMPTY(cCodCon) .AND. !EMPTY(nRecSE5)
	
	cRecSE5	:= PADR(ALLTRIM(STR(nRecSE5)), nCpoRec)
	
	DBSELECTAREA("ZD7")
	ZD7->(DBSETORDER(2)) //| 
	IF ZD7->(DBSEEK(cRecSE5)) 
		cCodCon	:= ZD7->ZD7_CODIGO
				
	ENDIF

ENDIF


IF !EMPTY(cCodCon)
	
	DBSELECTAREA("ZD5")
	ZD5->(DBSETORDER(1)) //| 
	IF ZD5->(DBSEEK(xfilial("ZD5")+cCodCon)) 
		
		
		
		BEGIN TRANSACTION
		
		
			/*--------------------------
			ITENS CONCILIADOS MOV. BANCARI
			---------------------------*/
			DBSELECTAREA("ZD7")
			ZD7->(DBSETORDER(1))  
			IF ZD7->(DBSEEK(xfilial("ZD7")+ZD5->ZD5_CODIGO)) 
				WHILE ZD7->(!EOF()) .AND. ZD7->ZD7_CODIGO == ZD5->ZD5_CODIGO
				
					//| Verifica se o titulo no financeiro esta conciliado|
					IF lChkSE5
						SE5->(DBGOTO(ZD7->ZD7_SE5REC))
						IF !EMPTY(SE5->E5_RECONC)
							aRet[2]	:= "Titulo no financeiro esta conciliado. Primeiro desconcile o titulo antes de excluir este registro"
							DISARMTRANSACTION()
							EXIT
						ENDIF
					ENDIF 
				
					RECLOCK("ZD7",.F.)
						DBDELETE()
					MSUNLOCK()
					ZD7->(DBSKIP()) 
				ENDDO
			ENDIF
		
		
			IF EMPTY(aRet[2])
				
				/*--------------------------
				ITENS CONCILIADOS - EXTRATO   
				---------------------------*/
				DBSELECTAREA("ZD6")
				ZD6->(DBSETORDER(1))  
				IF ZD6->(DBSEEK(xfilial("ZD6")+ZD5->ZD5_CODIGO)) 
					WHILE ZD6->(!EOF()) .AND. ZD6->ZD6_CODIGO == ZD5->ZD5_CODIGO
						RECLOCK("ZD6",.F.)
							DBDELETE()
						MSUNLOCK()
						ZD6->(DBSKIP()) 
					ENDDO
				ENDIF
			
	
				
				
				/*--------------------------
				EXTRATO OFX                   
				---------------------------*/
				DBSELECTAREA("ZD2")
				ZD2->(DBSETORDER(5))  
				IF ZD2->(DBSEEK(xfilial("ZD2")+ZD5->ZD5_CODIGO)) 
					WHILE ZD2->(!EOF()) .AND. ZD2->ZD2_CODCON == ZD5->ZD5_CODIGO
						RECLOCK("ZD2",.F.)
							ZD2->ZD2_DTCONC := CRIAVAR("ZD2_DTCONC",.F.)
							ZD2->ZD2_CODCON	:= ""
						MSUNLOCK()
						ZD2->(DBSKIP()) 
						
						aRet[1]	:= .T.
					ENDDO
				ENDIF			
	
	
				/*--------------------------
				CONCILIACAO BANCARIA          
				---------------------------*/
				DBSELECTAREA("ZD5")
				RECLOCK("ZD5",.F.)
					DBDELETE()
				MSUNLOCK()
			ENDIF
				
		
		END TRANSACTION
	ENDIF

ENDIF

Return(aRet)



