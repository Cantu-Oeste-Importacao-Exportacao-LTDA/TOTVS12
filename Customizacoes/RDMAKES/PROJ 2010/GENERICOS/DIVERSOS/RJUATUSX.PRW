#include "topconn.ch"
#include "tbiconn.ch"
#include "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RJUATUSX  º Autor ³ Rafael Parma       º Data ³  24/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de ajuste do dicionário x banco de dados.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*-------------------------*
User Function RJUATUSX()
*-------------------------*
Private aEMPRESAS := {} 
Private oProcUPD   
Private nHdlLOG  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	oProcUPD := MsNewProcess():New({|| fUpdEMP(cEmpAnt, cFilAnt) },"Processando tabelas para empresa "+cEmpAnt+" " ,"Aguarde!",.F.)
	oProcUPD:Activate()

	MsgInfo("Processo concluído!")
		
		
Return

*------------------------------------------*
Static Function fUpdEMP(cCODEMP, cCODFIL)
*------------------------------------------*

	cArqTXT := "\system\rjuatusx_"+cCODEMP+"_"+dtos(ddatabase)+"_"+StrTran(time(),":","")+".log"
	nHdlLOG := fCreate(cArqTXT)
	
	If nHdlLOG == -1
		Alert("Impossível criar arquivo de log!")
		Return
	EndIf 
	
	cTXT := time()+" 0-INICIO AJUSTES EMPRESA "+cCODEMP+chr(13)+chr(10)
	fWrite(nHdlLOG,cTXT,Len(cTXT))			

	cAliasTMP := GetNextAlias()
	cAliasCON := GetNextAlias()
	
	cQuery := "	SELECT SUBSTR(TABLE_NAME,1,3) X2_CHAVE, TABLE_NAME			" + chr(13)+chr(10)
	cQuery += "	FROM ALL_TABLES												" + chr(13)+chr(10)
	cQuery += "	WHERE OWNER = 'TOTVS10'										" + chr(13)+chr(10) // Atencao ao nome do usuario no banco
	cQuery += "	AND SUBSTR(TABLE_NAME,4,2) IN ('"+cCODEMP+"','CMP') 		" + chr(13)+chr(10)
	cQuery += "	AND SUBSTR(TABLE_NAME,1,3) NOT IN ('TRB','TRD','TRX') 		" + chr(13)+chr(10)
	cQuery += "	AND LENGTH(TABLE_NAME) = 6									" + chr(13)+chr(10)
	cQuery += "	ORDER BY 1													" + chr(13)+chr(10)
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		
		oProcUPD:IncRegua1((cAliasTMP)->X2_CHAVE)
            
		cQuery := " SELECT COUNT(*) AS REG FROM " + (cAliasTMP)->TABLE_NAME 
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasCON)
		
		dbSelectArea(cAliasCON)
		(cAliasCON)->(dbGoTop())			
		lFlag := .F.
		If (cAliasCON)->REG > 0
			lFlag := .T.
		EndIf 
		(cAliasCON)->(dbCloseArea())
	
            
		If ! lFlag 
			If (cAliasTMP)->X2_CHAVE != "CTO"
				cTXT := time()+" 1-TABELA "+(cAliasTMP)->X2_CHAVE+" - SEM REGISTROS, ELIMINADA DA BASE DE DADOS."+chr(13)+chr(10)
				fWrite(nHdlLOG,cTXT,Len(cTXT))			
					
				TcDelFile((cAliasTMP)->TABLE_NAME)
			EndIf
			(cAliasTMP)->(dbSkip())			
			Loop
		EndIf 
		
		
		If (cAliasTMP)->X2_CHAVE $ "SX5/TMR/SJ1/SJ2/SKJ/SZN/SZT/SCT/SD2/SC6"
			(cAliasTMP)->(dbSkip())
			Loop
		EndIf
		
		dbSelectArea("SX2")
		dbSetOrder(1)
		dbSeek((cAliasTMP)->X2_CHAVE)
		
		dbSelectArea((cAliasTMP)->X2_CHAVE)
		
		If RecCount() != 0
		
			dbCloseArea()
			X31UpdTable((cAliasTMP)->X2_CHAVE)	
			
			If __GetX31Error()

				cTXT := time()+" 2-TABELA "+(cAliasTMP)->X2_CHAVE+" - COM REGISTROS, ERRO AO AJUSTAR DICIONARIO."+chr(13)+chr(10)
				fWrite(nHdlLOG,cTXT,Len(cTXT))
							
				cTXT := __GetX31Trace()+chr(13)+chr(10) 
				fWrite(nHdlLOG,cTXT,Len(cTXT))
				
			Else

				cTXT := time()+" 1-TABELA "+(cAliasTMP)->X2_CHAVE+" - COM REGISTROS, REALIZADOS AJUSTES CONFORME DICIONARIO."+chr(13)+chr(10)
				fWrite(nHdlLOG,cTXT,Len(cTXT))			

				dbSelectArea((cAliasTMP)->X2_CHAVE)
				dbCloseArea()
					
			EndIf
			  							
		Else
                
			dbCloseArea()
			
			cTXT := time()+" 1-TABELA "+(cAliasTMP)->X2_CHAVE+" - SEM REGISTROS."+chr(13)+chr(10)
			fWrite(nHdlLOG,cTXT,Len(cTXT))			
				
			//TcDelFile((cAliasTMP)->TABLE_NAME)
			
		EndIf
		
		(cAliasTMP)->(dbSkip())

	Enddo

 	(cAliasTMP)->(dbCloseArea())

	cTXT := time()+" 9-FIM AJUSTES EMPRESA "+cCODEMP+chr(13)+chr(10)
	fWrite(nHdlLOG,cTXT,Len(cTXT))
	fClose(nHdlLOG)	  			

Return