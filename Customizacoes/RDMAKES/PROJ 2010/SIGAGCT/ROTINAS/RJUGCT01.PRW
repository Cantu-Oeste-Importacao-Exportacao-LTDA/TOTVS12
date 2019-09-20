#include "msole.ch"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUGCT01   ºAutor  ³Rafael Parma       º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para geração de títulos provisórios sobre contratos.º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------*
User Function RJUGCT01(lVIS,lINC)
*--------------------------------*

Private oDlgMAIN 
Private oPainel1
Private oPainel2
Private oPainel3
Private oButton1
Private oGetPRV
Private aCols 	:= {}
Private aHeader := {}
Private aAltCPO := {}
Private n		:= 1

Private cTEXTO1	:= ""
Private nVLRCON := 0
Private nNUMPAR := 0
Private dDATAIN := ddatabase  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("CN1")
	dbSetOrder(1)
	If dbSeek(xFilial("CN1")+CN9->CN9_TPCTO)		
		If CN1->CN1_CTRFIX != "2"
			Aviso("Aviso","Contrato com controle físico/financeiro, rotina não disponível.",{"OK"})
			Return
		EndIf
	EndIf

	aAdd(aHeader, {"Parcela",		"PARCEL",	"@!",				03,	00,	"AllwaysTrue()","","C","", "V"})
	aAdd(aHeader, {"Competência",	"VIGENC",	"@D",				08,	00,	"AllwaysTrue()","","D","", "R"}) 
	aAdd(aHeader, {"Valor",			"VALORP",	"@E 999,999.99",	14,	02,	"AllwaysTrue()","","N","", "V"})
	
	If ! lVIS
		aAdd(aAltCPO, "VIGENC")
		aAdd(aAltCPO, "VALORP")
	EndIf
		
	cTEXTO1 += "Assistente responsável pela definição de títulos provisórios do contrato."
	
	//--Carrega dados do contrato
	fLoadPRV()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definição do dialogo principal.                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DEFINE FONT oTXTBOLD11 NAME "Tahoma" SIZE 0, -11 BOLD
	
	oDlgMAIN := MSDialog():New(0,0,400,700,"Títulos provisórios",,,,,CLR_BLACK,CLR_WHITE,,,.T.)

	//--Painel 1                
	oPainel1 := TPanel():New( 000,000,,oDlgMAIN,,.F.,.F.,,,400,700,.T.,.F. )
	oPainel1:lVisible := .T. 
	
	@ 007,007 SAY "Títulos provisórios"		SIZE 100,010 OF oPainel1 PIXEL FONT oTXTBOLD11
	@ 020,007 MSGET cTEXTO1					SIZE 340,100 WHEN .F. OF oPainel1 PIXEL
	
	@ 180,190 BUTTON oButton1 PROMPT "Avançar"	SIZE 060,11 OF oPainel1 PIXEL ACTION fActPNL(oPainel1,oPainel2,lINC)
	@ 180,270 BUTTON oButton1 PROMPT "Cancelar"	SIZE 060,11 OF oPainel1 PIXEL ACTION Close(oDlgMAIN)
		

	//--Painel 2              
	oPainel2 := TPanel():New( 000,000,,oDlgMAIN,,.F.,.F.,,,400,700,.T.,.F. )
	oPainel2:lVisible := .F.

	@ 007,007 SAY "Títulos provisórios"		SIZE 100,010 OF oPainel2 PIXEL FONT oTXTBOLD11

	@ 026,007 SAY "Valor da parcela: "		SIZE 070,010 OF oPainel2 PIXEL 
	@ 024,070 MSGET nVLRCON					WHEN !lVIS SIZE 050,010 PICTURE "@E 999,999,999.99" WHEN .T. OF oPainel2 PIXEL

	@ 040,007 SAY "Número de parcelas: "	SIZE 070,010 OF oPainel2 PIXEL 
	@ 038,070 MSGET nNUMPAR					WHEN !lVIS SIZE 050,010 PICTURE "@E 999,999,999" WHEN .T. OF oPainel2 PIXEL

	@ 054,007 SAY "Data inicial competência: "	SIZE 070,010 OF oPainel2 PIXEL 
	@ 052,070 MSGET dDATAIN				   		WHEN !lVIS SIZE 050,010 WHEN .T. OF oPainel2 PIXEL

	@ 180,110 BUTTON oButton1 PROMPT "Voltar"	SIZE 060,11 OF oPainel2 PIXEL ACTION fActPNL(oPainel2,oPainel1,lINC)
	@ 180,190 BUTTON oButton1 PROMPT "Avançar"	SIZE 060,11 OF oPainel2 PIXEL ACTION fActPNL(oPainel2,oPainel3,lINC)
	@ 180,270 BUTTON oButton1 PROMPT "Cancelar"	SIZE 060,11 OF oPainel2 PIXEL ACTION Close(oDlgMAIN)


	//--Painel 3                
	oPainel3 := TPanel():New( 000,000,,oDlgMAIN,,.F.,.F.,,,400,700,.T.,.F. )
	oPainel3:lVisible := .F.

	@ 007,007 SAY "Títulos provisórios"		SIZE 100,010 OF oPainel3 PIXEL FONT oTXTBOLD11

	oGetPRV := MsNewGetDados():New( 026, 007, 140, 340, GD_UPDATE , "AllwaysTrue()", "AllwaysTrue()", , aAltCPO, , Len(aCols),, "", .F., oPainel3, aHeader ,aCols )

	@ 180,110 BUTTON oButton1 PROMPT "Voltar"		SIZE 060,11 OF oPainel3 PIXEL ACTION fActPNL(oPainel3,oPainel2,)
	@ 180,190 BUTTON oButton1 PROMPT "Finalizar"	SIZE 060,11 OF oPainel3 PIXEL ACTION fIncPRV(lVIS)
	@ 180,270 BUTTON oButton1 PROMPT "Cancelar"		SIZE 060,11 OF oPainel3 PIXEL ACTION Close(oDlgMAIN)


	oDlgMAIN:Activate(,,,.T.)

	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fActPNL     ºAutor  ³Rafael Parma      º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para exibição dos paineis.                          º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------------------------*
Static Function fActPNL(oPnlORI,oPnlDES,lINC)            
*--------------------------------------------------*
       
	If oPnlORI == oPainel2 .and. oPnlDES == oPainel3 .and. lINC
		fUpdPRV()
	EndIf
		
	Do case
		case oPnlDES == oPainel1		
			oPainel1:lVisible := .T.
			oPainel2:lVisible := .F.
			oPainel3:lVisible := .F.
		case oPnlDES == oPainel2		
			oPainel1:lVisible := .F.
			oPainel2:lVisible := .T.
			oPainel3:lVisible := .F.
		case oPnlDES == oPainel3		
			oPainel1:lVisible := .F.
			oPainel2:lVisible := .F.
			oPainel3:lVisible := .T.
	Endcase
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fUpdPRV     ºAutor  ³Rafael Parma      º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para definição de títulos provisórios.              º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------------------------*
Static Function fUpdPRV()            
*--------------------------------------------------*
      
	//--Popula array com os dados
	
	oGetPRV:aCols := {}
	If nVLRCON > 0 .and. nNUMPAR > 0 .and. !Empty(dDATAIN)		
		nANOATU := Year(dDATAIN)
		nMESATU := Month(dDATAIN)
		nDIAATU := Day(dDATAIN)
		For nI := 1 to nNUMPAR     
		
			nDIAUSE := nDIAATU
			If nDIAATU == 31 .and. ( nMESATU == 4 .or. nMESATU == 6 .or. nMESATU == 9 .or. nMESATU == 11 )
				nDIAUSE := 30
			Endif
			If nMESATU == 2 .and. nDIAUSE > 28
				nDIAUSE := 28
			EndIf
				
			dDATAATU := DataValida(CTOD(cValToChar(nDIAUSE)+"/"+cValToChar(nMESATU)+"/"+cValToChar(nANOATU)),.F.)
			aAdd( oGetPRV:aCols, Array( Len( oGetPRV:aHeader ) + 1 ) )
			oGetPRV:aCols[nI,01] := STRZero(nI,03) 			
			oGetPRV:aCols[nI,02] := dDATAATU        
			oGetPRV:aCols[nI,03] := nVLRCON
			oGetPRV:aCols[nI,04] := .F. 			
			
			nMESATU += 1			
			If nMESATU > 12
				nANOATU += 1
				nMESATU := 1
			EndIf
			 
		Next nI		
	EndIf
	
	oGetPRV:Refresh(.T.)
	oPainel3:Refresh()
	oDlgMAIN:Refresh()

Return     


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fIncPRV     ºAutor  ³Rafael Parma      º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para inclusão de títulos provisórios.               º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------------------------*
Static Function fIncPRV(lVIS)            
*--------------------------------------------------* 
Private lMsErroAuto := .F.
Private cPRFTIT := "GC "
Private cNATTIT := SuperGetMV("MV_CNNAT")
Private cTIPTIT := "PR "

	
	If ! lVIS
	    
		If nVLRCON == 0 .or. nNUMPAR == 0 .or. Empty(dDATAIN)
			Aviso("Atenção","Todos os campos Valor do Contrato, Número de Parcelas e Data de Competência devem ser preenchidos.",{"OK"})
			Return
		EndIf
		
		Begin Transaction
		
			//--Elimina registros antigos
			dbSelectArea("Z33")
			dbSetOrder(1)
			dbGoTop()    
			If dbSeek( xFilial("Z33")+CN9->CN9_NUMERO )			
				dbSelectArea("CNC")
				dbSetOrder(1)
				If dbSeek ( xFilial("CNC") + CN9->CN9_NUMERO )			
				
					While !Z33->(EOF()) .and. Z33->Z33_FILIAL+Z33->Z33_CONTRA == xFilial("Z33")+CN9->CN9_NUMERO

						If !Empty(Z33->Z33_MEDICA)
							Z33->(dbSkip())
							Loop
						EndIf
		
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
							
			  			If RecLock("Z33",.F.)
			  				Z33->(dbDelete())
			  				Z33->(MsUnLock())
			  			EndIf     
			  			
						Z33->(dbSkip()) 		
					Enddo
				EndIf		
			EndIf
				
			//--Inclusão de novos registros
			If Len(oGetPRV:aCols) > 0
			
				dbSelectArea("CNC")
				dbSetOrder(1)
				If dbSeek ( xFilial("CNC") + CN9->CN9_NUMERO ) 
				
					cNUMTIT := GetSXENUM("Z33","Z33_TITULO")
					ConfirmSx8()
					
					For nI := 1 to Len(oGetPRV:aCols)
					
						If RecLock("Z33",.T.)								
							Z33->Z33_FILIAL	:= xFilial("Z33")
							Z33->Z33_CONTRA	:= CN9->CN9_NUMERO
							Z33->Z33_PARCEL	:= oGetPRV:aCols[nI,01]
							Z33->Z33_COMPET := oGetPRV:aCols[nI,02]
							Z33->Z33_VALOR  := oGetPRV:aCols[nI,03]
							Z33->Z33_TITULO := cNUMTIT
							Z33->(MsUnLock())
							
							lMsErroAuto := .F. 
							
							aTitulo := {	{"E2_FILIAL"	, xFilial("SE2")		,	Nil},;      
											{"E2_PREFIXO"	, cPRFTIT				,	Nil},;      
							  				{"E2_NUM"		, cNUMTIT				,	Nil},;      
											{"E2_PARCELA"	, Z33->Z33_PARCEL		,	Nil},;      
											{"E2_NATUREZ"	, cNATTIT				,	Nil},;      
											{"E2_TIPO"		, cTIPTIT	    		,	Nil},;      
											{"E2_FORNECE"	, CNC->CNC_CODIGO		,	Nil},;      
											{"E2_LOJA"		, CNC->CNC_LOJA			,	Nil},;
											{"E2_EMISSAO"	, ddatabase		  		,	Nil},;
											{"E2_VENCTO"	, Z33->Z33_COMPET  		,	Nil},;									
											{"E2_VENCREA"	, Z33->Z33_COMPET  		,	Nil},;
											{"E2_ORIGEM"	, "CNTA100"				,	Nil},;																													
											{"E2_MDCONTR"	, CN9->CN9_NUMERO		,	Nil},;
											{"E2_VALOR"		, Z33->Z33_VALOR  		,	Nil} }      
						
							MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,3)
							
							If lMsErroAuto
								DisarmTransaction()
								Mostraerro()
								Exit
							EndIf							
							
						EndIf				
					Next nI          
					
				EndIf
			EndIf 
		
		End Transaction
	
	EndIf
		
	Close(oDlgMAIN)
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLoadPRV    ºAutor  ³Rafael Parma      º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para carregar títulos provisórios no array.         º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------------------------*
Static Function fLoadPRV()                          
*--------------------------------------------------*
Local nI := 1

	nVLRCON := 0
	nNUMPAR := 0
	dDATAIN := ddatabase 
	
	dbSelectArea("Z33")
	dbSetOrder(1)
	dbGoTop()    
	If dbSeek( xFilial("Z33")+CN9->CN9_NUMERO )
		While !Z33->(EOF()) .and. Z33->Z33_FILIAL+Z33->Z33_CONTRA == xFilial("Z33")+CN9->CN9_NUMERO

			If !Empty(Z33->Z33_MEDICA)
				Z33->(dbSkip())
				Loop
			EndIf
			
			aAdd( aCols, Array(4) )
			aCols[Len(aCols),01] := Z33->Z33_PARCEL	
			aCols[Len(aCols),02] := Z33->Z33_COMPET
			aCols[Len(aCols),03] := Z33->Z33_VALOR 
			aCols[Len(aCols),04] := .F. 
			nVLRCON := Z33->Z33_VALOR
			nNUMPAR += 1
			If Len(aCols) == 1
				dDATAIN := Z33->Z33_COMPET
			EndIf
			
			Z33->(dbSkip()) 		
		Enddo
	EndIf
	
Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUGCT1EX   ºAutor  ³Rafael Parma      º Data ³  12/12/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Função para exclusão de títulos provisórios.               º±±
±±º          ³                                                            º±±  
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ TOTVS                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßißßßßßßßßßß
*/
*--------------------------------------------------*
User Function RJUGCT1E()
*--------------------------------------------------*
Private lMsErroAuto := .F.
Private cPRFTIT := "GC "
Private cNATTIT := SuperGetMV("MV_CNNAT")
Private cTIPTIT := "PR "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	Begin Transaction
	
		dbSelectArea("Z33")
		dbSetOrder(1)
		dbGoTop()    
		If dbSeek( xFilial("Z33")+CN9->CN9_NUMERO )
		    
			dbSelectArea("CNC")
			dbSetOrder(1)
			If dbSeek ( xFilial("CNC") + CN9->CN9_NUMERO )
			
				While !Z33->(EOF()) .and. Z33->Z33_FILIAL+Z33->Z33_CONTRA == xFilial("Z33")+CN9->CN9_NUMERO
				
					If !Empty(Z33->Z33_MEDICA)
						Z33->(dbSkip())
						Loop
					EndIf
					
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
  					
  					If RecLock("Z33",.F.)  			            	
	  					Z33->(dbDelete())
	  					Z33->(MsUnLock())
	  				EndIf
	  				
					Z33->(dbSkip()) 		
				Enddo
			EndIf
		
		EndIf      
		
	End Transaction
		
	
Return
