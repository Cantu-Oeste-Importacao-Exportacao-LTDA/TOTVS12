#include "topconn.ch"
#include "rwmake.ch"

// Exportação tabela SE5 do TOP para CTREE
                                
*------------------------------*
User Function RJEXPSE5()        
*------------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If MsgBox("Efetuar a exportação do arquivo SE5 para DTC?","Copia Arquivo SE1","YESNO")
		Processa( {|| fExpSE51() })
		Processa( {|| fExpSE52() })
	EndIf                    
	
Return

*------------------------------*
Static Function fExpSE51()     
*------------------------------*
Local cAliasTMP := GetNextAlias()
Local aTables 	:= {}
Local aTempStru	:= {}
Local aEstrSE1	:= {}

	dbSelectArea("SE5")
	aStrucTMP := SE5->(dbStruct())
	
	aAdd(aStrucTMP,{"E5_CGC","C",014,0})
	cArqTrab := CriaTrab(aStrucTMP,.T.)
	dbUseArea(.T.,__LocalDriver,cArqTrab,,.T.,.F.)  
	
	cDestino := "\TABSE5\"
	
	If !File(cDestino)
		MAKEDIR(cDestino)
	EndIf
	
	cFIELDSE5 := ""
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SE5")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SE5"
		cFIELDSE5 += SX3->X3_CAMPO + ","
		SX3->(dbSkip())
	Enddo
	cFIELDSE5 := SubSTR(cFIELDSE5,1,Len(cFIELDSE5)-1)
	     
	dbSelectArea("SE1")
	SET FILTER TO SE1->E1_SALDO > 0 .AND. SE1->E1_EMISSAO <= CTOD("01/01/2011")
	SE1->(dbGoTop())
	ProcRegua(RecCount())

	While !SE1->(EOF())
            
		IncProc("Processando título SE1: "+SE1->E1_NUM)
		
		cQuery := " SELECT 	" + cFIELDSE5
		cQuery += " FROM 	" + RetSQLName("SE5") + "	SE5					"
		cQuery += " WHERE 													"
		cQuery += " 		SE5.E5_FILIAL 	= '" + SE1->E1_FILIAL 	+ "'	"
		cQuery += " AND		SE5.E5_PREFIXO 	= '" + SE1->E1_PREFIXO 	+ "'	"		
		cQuery += " AND		SE5.E5_NUMERO 	= '" + SE1->E1_NUM 		+ "'	"
		cQuery += " AND		SE5.E5_PARCELA 	= '" + SE1->E1_PARCELA 	+ "'	"
		cQuery += " AND		SE5.E5_TIPO 	= '" + SE1->E1_TIPO 	+ "'	"
		cQuery += " AND		SE5.E5_CLIFOR 	= '" + SE1->E1_CLIENTE 	+ "'	"
		cQuery += " AND		SE5.E5_LOJA 	= '" + SE1->E1_LOJA 	+ "'	"
		cQuery += " AND		SE5.D_E_L_E_T_ != '*'							"												
		
		memowrite("RJEXPSX5.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		While !(cAliasTMP)->(EOF())        
			RecLock(cArqTrab,.T.)
			For nR := 1 To (cArqTrab)->(FCount())
				cCampo := (cArqTrab)->(FieldName(nR))				
				nPosicao  := (cAliasTMP)->(FieldPos(cCampo)) 
				If nPosicao > 0 .And. (cArqTrab)->(FieldPos(cCampo)) > 0
					(cArqTrab)->(FieldPut(nR, (cAliasTMP)->&cCampo)) 
				Endif				
			Next nR		
			MsUnlock(cArqTrab)			
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		dbSelectArea("SE1")
		SE1->(dbSkip())
	Enddo
	
	dbSelectArea("SE1")
	SET FILTER TO
	
	dbSelectArea(cArqTrab)
	dbGoTop()
	While !(cArqTrab)->(EOF())                                              
		IncProc("Atualizando CGC: "+(cArqTrab)->E5_CLIFOR+"-"+(cArqTrab)->E5_LOJA)	
		dbSelectArea("SA1")                                                 		
		dbSetorder(1)
		dbGoTop()
		If dbSeek( xFilial("SA1") + (cArqTrab)->E5_CLIFOR + (cArqTrab)->E5_LOJA )	    
		    If RecLock(cArqTrab,.F.)                  
				If ! Empty(SA1->A1_CGC)
					cCODCLI	:= SubSTR(SA1->A1_CGC,1,IIf(Len(AllTrim(SA1->A1_CGC))==14,8,9))
					cCODLOJ	:= IIf(Len(AllTrim(SA1->A1_CGC))==14,SubSTR(SA1->A1_CGC,9,4),"0001")		    
					(cArqTrab)->E5_CGC		:= SA1->A1_CGC
					(cArqTrab)->E5_ARQRAT   := SA1->A1_CGC
					(cArqTrab)->E5_LOJA		:= cCODLOJ
					(cArqTrab)->E5_CLIFOR	:= cCODCLI
					If !Empty((cArqTrab)->E5_CLIENTE)
						(cArqTrab)->E5_CLIENTE	:= cCODCLI
					EndIf
				EndIf
				(cArqTrab)->E5_BANCO	:= ""
				(cArqTrab)->E5_CONTA	:= ""
				(cArqTrab)->E5_AGENCIA	:= ""
		    	(cArqTrab)->(MsUnLock())
		  	EndIf
		EndIf
		dbSelectArea(cArqTrab)
		(cArqTrab)->(dbSkip())
	Enddo
	
	dbSelectArea(cArqTrab)
	COPY TO &(cDestino+RetSqlName("SE5")+"_SE1")
	(cArqTrab)->(dbCloseArea())
	   
		
	
Return       



*------------------------------*
Static Function fExpSE52()     
*------------------------------*
Local cAliasTMP := GetNextAlias()
Local aTables 	:= {}
Local aTempStru	:= {}
Local aEstrSE1	:= {}

	dbSelectArea("SE5")
	aStrucTMP := SE5->(dbStruct())
	
	aAdd(aStrucTMP,{"E5_CGC","C",014,0})
	cArqTrab := CriaTrab(aStrucTMP,.T.)
	dbUseArea(.T.,__LocalDriver,cArqTrab,,.T.,.F.)  
	
	cDestino := "\TABSE5\"
	
	If !File(cDestino)
		MAKEDIR(cDestino)
	EndIf
	
	cFIELDSE5 := ""
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbGoTop()
	dbSeek("SE5")
	While !SX3->(EOF()) .AND. SX3->X3_ARQUIVO == "SE5"
		cFIELDSE5 += SX3->X3_CAMPO + ","
		SX3->(dbSkip())
	Enddo
	cFIELDSE5 := SubSTR(cFIELDSE5,1,Len(cFIELDSE5)-1)
	     
	dbSelectArea("SE2")
	SET FILTER TO SE2->E2_SALDO > 0 .AND. SE2->E2_EMISSAO <= CTOD("01/01/2011")
	SE2->(dbGoTop())
	ProcRegua(RecCount())

	While !SE2->(EOF())
            
		IncProc("Processando título SE2: "+SE2->E2_NUM)
		
		cQuery := " SELECT 	" + cFIELDSE5
		cQuery += " FROM 	" + RetSQLName("SE5") + "	SE5					"
		cQuery += " WHERE 													"
		cQuery += " 		SE5.E5_FILIAL 	= '" + SE2->E2_FILIAL 	+ "'	"
		cQuery += " AND		SE5.E5_PREFIXO 	= '" + SE2->E2_PREFIXO 	+ "'	"		
		cQuery += " AND		SE5.E5_NUMERO 	= '" + SE2->E2_NUM 		+ "'	"
		cQuery += " AND		SE5.E5_PARCELA 	= '" + SE2->E2_PARCELA 	+ "'	"
		cQuery += " AND		SE5.E5_TIPO 	= '" + SE2->E2_TIPO 	+ "'	"
		cQuery += " AND		SE5.E5_CLIFOR 	= '" + SE2->E2_FORNECE 	+ "'	"
		cQuery += " AND		SE5.E5_LOJA 	= '" + SE2->E2_LOJA 	+ "'	"
		cQuery += " AND		SE5.D_E_L_E_T_ != '*'							"												
		
		memowrite("RJEXPSX5.SQL",cQuery)
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		While !(cAliasTMP)->(EOF())        
			RecLock(cArqTrab,.T.)
			For nR := 1 To (cArqTrab)->(FCount())
				cCampo := (cArqTrab)->(FieldName(nR))				
				nPosicao  := (cAliasTMP)->(FieldPos(cCampo)) 
				If nPosicao > 0 .And. (cArqTrab)->(FieldPos(cCampo)) > 0
					(cArqTrab)->(FieldPut(nR, (cAliasTMP)->&cCampo)) 
				Endif				
			Next nR		
			MsUnlock(cArqTrab)			
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		dbSelectArea("SE2")
		SE2->(dbSkip())
	Enddo
	
	dbSelectArea("SE2")
	SET FILTER TO
	
	dbSelectArea(cArqTrab)
	dbGoTop()
	While !(cArqTrab)->(EOF())                                              
		IncProc("Atualizando CGC: "+(cArqTrab)->E5_CLIFOR+"-"+(cArqTrab)->E5_LOJA)	
		dbSelectArea("SA2")                                                 		
		dbSetorder(1)
		dbGoTop()
		If dbSeek( xFilial("SA2") + (cArqTrab)->E5_CLIFOR + (cArqTrab)->E5_LOJA )	    
		    If RecLock(cArqTrab,.F.)                  
				If ! Empty(SA2->A2_CGC)
					cCODCLI	:= SubSTR(SA2->A2_CGC,1,IIf(Len(AllTrim(SA2->A2_CGC))==14,8,9))
					cCODLOJ	:= IIf(Len(AllTrim(SA2->A2_CGC))==14,SubSTR(SA2->A2_CGC,9,4),"0001")		    
					(cArqTrab)->E5_CGC		:= SA2->A2_CGC
					(cArqTrab)->E5_ARQRAT   := SA2->A2_CGC
					(cArqTrab)->E5_LOJA		:= cCODLOJ
					(cArqTrab)->E5_CLIFOR	:= cCODCLI
					If !Empty((cArqTrab)->E5_FORNECE)
						(cArqTrab)->E5_FORNECE	:= cCODCLI
					EndIf					
				EndIf
				(cArqTrab)->E5_BANCO	:= ""
				(cArqTrab)->E5_CONTA	:= ""
				(cArqTrab)->E5_AGENCIA	:= ""
		    	(cArqTrab)->(MsUnLock())
		  	EndIf
		EndIf
		dbSelectArea(cArqTrab)
		(cArqTrab)->(dbSkip())
	Enddo
	
	dbSelectArea(cArqTrab)
	COPY TO &(cDestino+RetSqlName("SE5")+"_SE2")
	(cArqTrab)->(dbCloseArea())
	   
	MsgInfo("Tabela SE5 exportada para o diretorio \TABSE5\")
		
	
Return                


*------------------------------*
User Function RJDELSE5()        
*------------------------------*              
Local nReg := 0
Local nPrc := 0  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
		          
	If MsgBox("Efetuar acerto da SE5?","Acerta SE5","YESNO")
		
		For nI := 1 to 2
			
			If nI == 1
				cArquivo := lower("\TABSE5\"+RetSqlName("SE5")+"_SE2.dtc")
			Else
				cArquivo := lower("\TABSE5\"+RetSqlName("SE5")+".dtc")	
			EndIf
		
			If !File(cArquivo)
				Alert(cArquivo+" - Arquivo inexistente!")
				Return
			EndIf
	
			MsOpEndbf(.T.,__LOCALDRIVER,cArquivo,"TMPSE5",.F.,.F.,.F.,.F.)
			
			dbSelectArea("TMPSE5")		
			TMPSE5->(dbGoTop())
			ProcRegua(LastRec())
			While TMPSE5->(!EOF())
				IncProc()       
				dbSelectArea("SE5")
				dbSetOrder(2)
				dbGoTop()
				cNUM := TMPSE5->E5_NUMERO+Space(3)
				cPAR := TMPSE5->E5_PARCELA+Space(1)
				cCLI := TMPSE5->E5_CLIFOR+Space(3)
				cLOJ := TMPSE5->E5_LOJA+Space(2)
				If dbSeek(TMPSE5->E5_FILIAL+TMPSE5->E5_TIPODOC+TMPSE5->E5_PREFIXO+cNUM+cPAR+TMPSE5->E5_TIPO+ ;
						DtoS(TMPSE5->E5_DATA)+cCLI+cLOJ+TMPSE5->E5_SEQ)
					If RecLock("SE5",.F.)
						SE5->(dbDelete())
						SE5->(MsUnLock())
					EndIf
					nReg += 1
				EndIf
				nPrc += 1
				TMPSE5->(dbSkip())
			Enddo
			
			TMPSE5->(dbCloseArea())
	  
	  Next nI

	EndIf       
	
	Alert("Total registros deletados: "+cValToChar(nReg) + " total processados: "+cValtoChar(nPrc))             
	
Return