#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"


/* Programa de exportação tabelas da folha RC*. */
*-------------------------*
User Function RJUEXPRC()
*-------------------------*  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	If MsgBox("Efetuar a cópia dos arquivos(RC) GPE para DTC?","Copia Arquivos GPE","YESNO")
		Processa( {|| fCheckTab() })
	EndIf
	
Return

*------------------------------*
Static Function fCheckTab()     
*------------------------------*

Local cAliasTMP := GetNextAlias()

	cQuery := "	SELECT NAME 							"+chr(13)+chr(10)
	cQuery += "	FROM SYSIBM.SYSTABLES 					"+chr(13)+chr(10)
	cQuery += "	WHERE 									"+chr(13)+chr(10)
	cQuery += "	SUBSTR(CREATOR, 1, 7) = 'DB2INST' 		"+chr(13)+chr(10)
	cQuery += "	AND TYPE 	= 'T' 						"+chr(13)+chr(10)
	cQuery += "	AND SUBSTR(NAME,1,2) = 'RC' 			"+chr(13)+chr(10)
	cQuery += "	AND LENGTH(NAME) > 6					"+chr(13)+chr(10)
	cQuery += "	ORDER BY NAME 							"+chr(13)+chr(10)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	cDestino := "\TABGPERC\"

	If !File(cDestino)
		MAKEDIR(cDestino)
	EndIf
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
        
		cAliasPRC := ALLTRIM((cAliasTMP)->NAME)
		IncProc("Processando tabela: " + cAliasPRC )
    // aArea := GetArea()                                              
		dbUseArea(.T., "TOPCONN",cAliasPRC, "TMP1", .F., .F.)
		
		COPY TO &(cDestino+cAliasPRC)
    
    //CopyToTbl(cAliasPRC)       
    
    dbCloseArea("TMP1")
    
    // RestArea(aArea)
	  dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbSkip())
	Enddo
	(cAliasTMP)->(dbCloseArea())	
	
	MsgInfo("Processo concluído!")

Return

*-----------------------------------------------*
Static Function CopyToTbl(cAliasPRC)
*-----------------------------------------------*
Local aStruct := TMP1->(dbStruct())

	cArqTrab := CriaTrab( aStruct, .T. ) + GetDBExtension()
	
	dbUseArea(.T.,,cArqTrab,"TRB",.F.,.F.)					 
	dbSelectArea("TRB")
	dbGoTop()			
	TMP1->(dbGoTop())
	While TMP1->(!EOF())
		RecLock("TRB",.T.)
		For iX := 1 to TMP1->(FCount())
			cCampo := TMP1->(FieldName(iX))
			nPos := TRB->(FieldPos(cCampo))
			If (nPos > 0)
				TRB->(FieldPut(nPos, TMP1->&cCampo))
			EndIf
		Next
		TRB->(MsUnLock())
		TMP1->(dbSkip())
	EndDo
	TRB->(dbCloseArea())
	
	Frename(cArqTrab , (lower(cAliasPRC)+GetDBExtension()) )

Return