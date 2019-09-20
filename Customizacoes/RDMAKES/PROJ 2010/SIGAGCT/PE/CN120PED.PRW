#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CN120PED   ºAutor  ³Rafael Parma       º Data ³  01/06/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de entrada executado no encerramento da medição, no   º±±
±±º          ³momento em que é gerado o pedido de compras.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*--------------------------*
User Function CN120PED()
*--------------------------*
Local aAreaTMP := GetArea()
Local nNUMPRV  := 0
Local nMESMED  := Month(ddatabase)
Local nANOMED  := Year(ddatabase)
Local aCABPED  := ParamIxb[1]
Local aITEPED  := ParamIxb[2]
Private cPRFTIT := "GC "
Private cNATTIT := SuperGetMV("MV_CNNAT")
Private cTIPTIT := "PR "
Private lMsErroAuto := .F.

Public __aRECZ33 := {}
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
	
	//--Tratamento de títulos provisórios...
	dbSelectArea("CNC")
	dbSetOrder(1)
	If dbSeek ( xFilial("CNC") + CN9->CN9_NUMERO )

		//--Exclusão do provisório do mês de competência...
		dbSelectArea("Z33")
		dbSetOrder(1)
		dbGoTop()    
		dbSeek( xFilial("Z33")+CN9->CN9_NUMERO )
		While !Z33->(EOF()) .and. Z33->Z33_FILIAL+Z33->Z33_CONTRA == xFilial("Z33")+CN9->CN9_NUMERO
			If nMESMED == Month(Z33->Z33_COMPET) .and. nANOMED == Year(Z33->Z33_COMPET)
					
				lMsErroAuto := .F. 
				
				aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		,	Nil},;      
								{"E2_PREFIXO"	, cPRFTIT				,	Nil},;      
				  				{"E2_NUM"		, Z33->Z33_TITULO		,	Nil},;      
								{"E2_PARCELA"	, Z33->Z33_PARCEL		,	Nil},;      
								{"E2_TIPO"		, cTIPTIT	    		,	Nil},;      
								{"E2_FORNECE"	, CNC->CNC_CODIGO		,	Nil},;      
								{"E2_LOJA"		, CNC->CNC_LOJA			,	Nil},;																	
								{"E2_VALOR"		, Z33->Z33_VALOR  		,	Nil} }      
			
				MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
				If lMsErroAuto
					DisarmTransaction()
					Mostraerro()
					Exit
				EndIf
				
				aAdd (__aRECZ33, Z33->(RECNO()) )
								
			ElseIf ( Month(Z33->Z33_COMPET) < nMESMED .and. Year(Z33->Z33_COMPET) == nANOMED ) .OR. Year(Z33->Z33_COMPET) < nANOMED
				nNUMPRV += 1
			EndIf

			Z33->(dbSkip()) 		
		Enddo			

		nRET := 0
		If nNUMPRV > 0
			nRET := Aviso("Aviso","Existem provisórios de competências anteriores, deseja excluí-los?",{"Sim","Não"})
		EndIf
		
		//--Exclusão do provisório de competências anteriores...
		If nRET == 1
			dbSelectArea("Z33")
			dbSetOrder(1)
			dbGoTop()    
			dbSeek( xFilial("Z33")+CN9->CN9_NUMERO )
			While !Z33->(EOF()) .and. Z33->Z33_FILIAL+Z33->Z33_CONTRA == xFilial("Z33")+CN9->CN9_NUMERO
				If ( Month(Z33->Z33_COMPET) < nMESMED .and. Year(Z33->Z33_COMPET) == nANOMED ) .OR. Year(Z33->Z33_COMPET) < nANOMED
				
					lMsErroAuto := .F. 
					aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		,	Nil},;      
									{"E2_PREFIXO"	, cPRFTIT				,	Nil},;      
					  				{"E2_NUM"		, Z33->Z33_TITULO		,	Nil},;      
									{"E2_PARCELA"	, Z33->Z33_PARCEL		,	Nil},;      
									{"E2_TIPO"		, cTIPTIT	    		,	Nil},;      
									{"E2_FORNECE"	, CNC->CNC_CODIGO		,	Nil},;      
									{"E2_LOJA"		, CNC->CNC_LOJA			,	Nil},;																	
									{"E2_VALOR"		, Z33->Z33_VALOR  		,	Nil} }      
				
					MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,5)
					If lMsErroAuto
						DisarmTransaction()
						Mostraerro()
						Exit
					EndIf
					
					aAdd (__aRECZ33, Z33->(RECNO()) )
		  		
		  		EndIf	  				
				Z33->(dbSkip()) 		
			Enddo
		EndIf		
	EndIf
		
	RestArea(aAreaTMP)
	
Return ({aCABPED,aITEPED})