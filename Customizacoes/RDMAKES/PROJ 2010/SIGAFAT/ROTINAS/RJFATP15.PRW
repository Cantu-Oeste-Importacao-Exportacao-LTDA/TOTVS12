#INCLUDE "TOPCONN.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJLOGCHK  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  04/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVerifica altera็ใo no conte๚do de campos.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJLOGCHK(cTABALT,nRECALT,cCHVALT)
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea() 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	Begin Transaction
		dbSelectArea(cTABALT)
		dbGoTo(nRECALT)
		If !(cTABALT)->(EOF()).AND.!(cTABALT)->(BOF())
			dbSelectArea("SX3")
			dbSetOrder(1)
			If dbSeek(cTABALT)
				While !SX3->(EOF()) .and. SX3->X3_ARQUIVO == cTABALT
					If X3USO(SX3->X3_USADO)
			  			If M->&(SX3->X3_CAMPO) != (cTABALT)->&(SX3->X3_CAMPO)
			  				U_RJLOGGRV(cTABALT,cCHVALT,SX3->X3_CAMPO,SX3->X3_TIPO,(cTABALT)->&(SX3->X3_CAMPO),M->&(SX3->X3_CAMPO))	
			  			EndIf
			  		EndIf
			  		SX3->(dbSkip())
		  		Enddo
		  	EndIf
	    EndIf
	End Transaction
	    
	RestArea(aAreaTMP)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJLOGGRV  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  04/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInclusใo de registro na tabela de logs de altera็ใo (Z70).  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJLOGGRV(cTABALT,cCHVALT,cCPOALT,cTIPCPO,cCONANT,cCONNOV)
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
	
	Do Case
		Case cTIPCPO == "N"
			cCONANT := cValToChar(cCONANT)
			cCONNOV := cValToChar(cCONNOV)
		Case cTIPCPO == "D"
			cCONANT := dToC(cCONANT)
			cCONNOV := dToC(cCONNOV)
		Case cTIPCPO == "L"
			If cCONANT
				cCONANT := ".T."	
			Else                    
				cCONANT := ".F."	
			EndIf
			If cCONNOV
				cCONNOV := ".T."	
			Else                    
				cCONNOV := ".F."	
			EndIf
	EndCase
	
	dbSelectArea("Z70")
	If RecLock("Z70",.T.)
		Z70->Z70_FILIAL	:= xFilial("Z70")
		Z70->Z70_ALIAS	:= RetSQLName(cTABALT)
		Z70->Z70_CHAVE	:= cCHVALT
		Z70->Z70_CAMPO	:= cCPOALT
		Z70->Z70_DATA	:= ddatabase
		Z70->Z70_HORA	:= time()
		Z70->Z70_USUARI	:= UPPER(ALLTRIM(cusername))
		Z70->Z70_CONANT	:= cCONANT
		Z70->Z70_CONNOV	:= cCONNOV
		Z70->(MsUnLock())
	EndIf
	RestArea(aAreaTMP)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJLOGVIS  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  04/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณVisualiza็ใo de registros da tabela de logs de altera็ใo.   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJLOGVIS(cTABALT,cCHVALT)
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Private aHeader	:= {}
Private aCols	:= {}
Private nUsado	:= 0
Private oDlgLOG, oGrdLOG                      

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek("Z70")
	While ( !SX3->(EOF()) .and. SX3->X3_ARQUIVO == "Z70" )
		If ( X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL .and. ! AllTrim(SX3->X3_CAMPO) $ "Z70_FILIAL|Z70_ALIAS|Z70_CHAVE" )
			nUsado++
			aadd(aHeader,{ AllTrim(X3Titulo()) ,;
                         SX3->X3_CAMPO       ,;
                         SX3->X3_PICTURE     ,;
                         SX3->X3_TAMANHO     ,;
                         SX3->X3_DECIMAL     ,;
                         SX3->X3_VALID       ,;
                         SX3->X3_USADO       ,;
                         SX3->X3_TIPO        ,;
                         SX3->X3_F3          ,;
                         SX3->X3_CONTEXT     ,;
                         SX3->X3_CBOX        ,;
                         SX3->X3_RELACAO     ,;
                         SX3->X3_WHEN        ,;
                         SX3->X3_VISUAL      ,;
                         SX3->X3_VLDUSER     ,;
                         SX3->X3_PICTVAR     ,;
   						".T."       } )
		EndIf
    	SX3->(dbSkip())
    Enddo
    
	nCHVTAM := Len(cCHVALT)
	cCHVREG := xFilial("Z70") + RetSQLName(cTABALT) + cCHVALT
	dbSelectArea("Z70")
	dbSetOrder(1)
	If dbSeek( cCHVREG )
		While !Z70->(EOF()) .and. Z70->(Z70_FILIAL+Z70_ALIAS+SUBSTR(Z70_CHAVE,1,nCHVTAM)) ==  cCHVREG
			AAdd(aCols,Array(nUsado+1))
			For nCntFor := 1 To nUsado
				If ( aHeader[nCntFor][10] != "V" )
					aCols[Len(aCols)][nCntFor] := Z70->(FieldGet(FieldPos(aHeader[nCntFor][2])))
				Else
					aCols[Len(aCols)][nCntFor] := CriaVar(aHeader[nCntFor,2])
				EndIf
			Next nCntFor
			aCols[Len(aCols)][nUsado+1] := .F.				
			Z70->(dbSkip())
		Enddo
	Else    
		AAdd(aCols,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aCols[1,nCntFor] := CriaVar(aHeader[nCntFor,2], .F. )
		Next nCntFor
		aCols[Len(aCols),nUsado+1] := .F.
	EndIf
	
	aCols := aSort(aCols,,,{|x,y| x[2]>y[2]})
	
	DEFINE MSDIALOG oDlgLOG TITLE "Logs de Altera็๕es" FROM 001, 001 TO 340, 800 COLORS 0, 16777215 PIXEL
	oGrdLOG := MsNewGetDados():New( 005, 005, 140, 400, , "AllwaysTrue", "AllwaysTrue", "", {},, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgLOG, aHeader, aCols)
	TButton():New( 150,250, '&Visualizar',oDlgLOG,{||fConteudo()},060,012,,,,.T.,,,,,,)
	TButton():New( 150,320, '&Fechar',oDlgLOG,{||oDlgLOG:End()},060,012,,,,.T.,,,,,,)
	ACTIVATE MSDIALOG oDlgLOG CENTERED 
	
	RestArea(aAreaTMP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfConteudo บAutor  ณTOTVS PARANA CENTRALบ Data ณ  04/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela com conte๚do anterior e novo do campo.               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fConteudo()
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Private nCPOANT	:= aScan(oGrdLOG:aHeader,{|x| AllTrim(x[2])=="Z70_CONANT"})
Private nCPONOV	:= aScan(oGrdLOG:aHeader,{|x| AllTrim(x[2])=="Z70_CONNOV"})
Private cCPOANT	:= oGrdLOG:aCols[oGrdLOG:nAt,nCPOANT]
Private cCPONOV	:= oGrdLOG:aCols[oGrdLOG:nAt,nCPONOV]
Private oDlgCON, oCPOANT, oCPONOV

	DEFINE MSDIALOG oDlgCON TITLE "Visualiza็ใo do conte๚do alterado" FROM 001,001 TO 300,600 PIXEL
	TSay():New(005,005,{|| "Conte๚do Anterior: " },oDlgCON,,,,,,.T.,,,100,010,,,,.T.,,.T.)	
	TSay():New(005,150,{|| "Conte๚do Novo: " },oDlgCON,,,,,,.T.,,,100,010,,,,.T.,,.T.)	
	@ 020,005 GET oCPOANT VAR cCPOANT MEMO SIZE 140,100 OF oDlgCON PIXEL READONLY
	@ 020,150 GET oCPONOV VAR cCPONOV MEMO SIZE 140,100 OF oDlgCON PIXEL READONLY
	TButton():New( 130,220,'&Fechar',oDlgCON,{||oDlgCON:End()},060,012,,,,.T.,,,,,,)
	
	ACTIVATE MSDIALOG oDlgCON CENTERED
		
	RestArea(aAreaTMP)

Return