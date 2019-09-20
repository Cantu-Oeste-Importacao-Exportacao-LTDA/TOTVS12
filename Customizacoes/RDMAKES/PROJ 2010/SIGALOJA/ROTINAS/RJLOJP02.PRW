#INCLUDE "protheus.ch"
#INCLUDE "tbiconn.ch"
#INCLUDE "topconn.ch"
#INCLUDE "fileio.ch"
#INCLUDE "rwmake.ch"

 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณRJLOJP02    บAutor ณTOTVS PARANA CENTRALบ Data ณ  27/11/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta็ใo de or็amentos do sistema EECO para o controle de บฑฑ
ฑฑบ          ณlojas.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

/* #### CONFIGURAวีES DO APPSERVER.INI ####

[JOBSIGALOJA]
MAIN=U_RJLOJP02()
ENVIRONMENT=SIGALOJA
PREPAREIN=20,01

[ONSTART]
JOBS=JOBSIGALOJA
REFRESHRATE=60        

#### CONFIGURAวีES DO APPSERVER.INI #### */

*---------------------------------------------------------------------------*
User Function RJLOJP02()
*---------------------------------------------------------------------------*
Private cSRVINI 	:= GetAdv97()
Private cEMPFIL		:= ""
Private cCODEMP		:= ""
Private cCODFIL		:= ""
Private cCODCLV		:= ""
Private nHldIMP		:= 0
Private nHldEXP		:= 0
Private nHldLOG		:= 0
Private aARQUIVOS	:= {}
Private aORCAMENTOS	:= {}
Private cPATHBASE	:= "\eeco"
Private cPATHLOGS	:= cPATHBASE+"\logs\"
Private cPATHREAD	:= cPATHBASE+"\importar\"
Private cPATHWRITE	:= cPATHBASE+"\importados\"   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	conout(TIME()+" - RJLOJP02 - INICIO DA EXECUวรO.")    

	// Recupera empresa/filial do APPSERVER.INI
	cEMPFIL := GetPvProfString( "JOBSIGALOJA", "PREPAREIN", "", cSrvIni )
	cCODEMP := SubSTR(cEMPFIL,1,2)
	cCODFIL := SubSTR(cEMPFIL,4,2)
	
	// Prepara o ambiente NO ERP, jแ abrindo as tabelas
	RPCSetType(3)
	RpcSetEnv ( cCODEMP, cCODFIL,,,,, {"SA1","SA3","SB1","SLQ","SLR"} )

	// Cria็ใo dos diret๓rios
	If !ExistDir(cPATHBASE)
		MakeDir(cPATHBASE)
	EndIf
	If !ExistDir(cPATHLOGS)
		MakeDir(cPATHLOGS)
	EndIf
	If !ExistDir(cPATHREAD)
		MakeDir(cPATHREAD)
	EndIf
	If !ExistDir(cPATHWRITE)
		MakeDir(cPATHWRITE)
	EndIf

	//-- Realiza a leitura dos arquivos a serem importados.
	aDir(cPATHREAD+"*.apv", aARQUIVOS )

	If Len(aARQUIVOS) > 0 
	
		//--Recupera c๓digo do segmento para o or็amento
		cCODCLV := SuperGetMV("MV_X_CSORC",,"001001001")
		
		For nARQ := 1 to Len(aARQUIVOS)
		    
		    aORCAMENTOS	:= {}
			nHldIMP		:= 0
			nHldEXP		:= 0
			nHldLOG		:= 0

			//--Cria็ใo do arquivo para log
		    cARQLOG := SubSTR(aARQUIVOS[nARQ],1,AT(".",aARQUIVOS[nARQ])-1)+"_"+STRTRAN(TIME(),":","")+".log"		
		    nHldLOG :=  fCreate(cPATHLOGS+cARQLOG)
		    
			//--Verifica se houve erro	
			If nHldLOG < 0
				//--Adiciona registro no arquivo de log
				cTEXTO := "ERRO: Nใo foi possivel criar o arquivo " + cARQLOG
				conout(cTEXTO)
			EndIf


			//--Cria็ใo arquivo da pasta importados
			cARQEXP := ALLTRIM(aARQUIVOS[nARQ])
		    nHldEXP := fCreate(cPATHWRITE+cARQEXP)
		    
			//--Verifica se houve erro	
			If nHldEXP < 0
				//--Adiciona registro no arquivo de log
				cTEXTO := "ERRO: Nใo foi possivel criar o arquivo " + cARQEXP
				conout(cTEXTO)
			EndIf


			//--Abre o arquivo para leitura
			cARQIMP := ALLTRIM(cPATHREAD+aARQUIVOS[nARQ])
			nHldIMP := Ft_Fuse(cARQIMP)

			//--Verifica se houve erro	
			If nHldIMP < 0
				//--Adiciona registro no arquivo de log
				cTEXTO := "ERRO: Nใo foi possivel abrir o arquivo " + cARQIMP
				fGravaLog(cTEXTO)
				conout(cTEXTO)
			Else
				cTEXTO := "Arquivo em processamento: " + cARQIMP
				fGravaLog(cTEXTO)
				conout(cTEXTO)
			EndIf


			//Percorre o arquivo
			Ft_FGoTop()
			While !Ft_FEof()
	   			//--Le a linha
	   			cLINARQ := Ft_FReadLn()
	   			cBKPLIN := cLINARQ

	   			If SubSTR(cLINARQ,1,2) == "PV"	//--Pedido

					//--Posi็ใo: 1 = Identifica็ใo do registro
					nPOSPON		:= AT("^",cLINARQ)
					cCODTIP		:= SubSTR(cLINARQ,1,nPOSPON-1)
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 2 = Data de emissใo
					nPOSPON		:= AT("^",cLINARQ)
					dDATEMI		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					dDATEMI		:= CTOD(SubSTR(dDATEMI,1,2)+"/"+SubSTR(dDATEMI,3,2)+"/"+SubSTR(dDATEMI,5,2))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 3 = C๓digo do tipo de faturamento
					nPOSPON		:= AT("^",cLINARQ)
					cCODFAT		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 4 = Informa se ้ um podido de troca T para sim F para nใo.
					nPOSPON		:= AT("^",cLINARQ)
					cTIPPED		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 5 = C๓digo do cliente
					nPOSPON		:= AT("^",cLINARQ)
					cCODCLI		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 6 = C๓digo do produto
					nPOSPON		:= AT("^",cLINARQ)
					cCODPRD		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 7 = Quantidade unitแria
					nPOSPON		:= AT("^",cLINARQ)
					nQTDADE		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					nQTDADE		:= VAL(STRTRAN(nQTDADE,",","."))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 8 = Quantidade por embalagem 
					nPOSPON		:= AT("^",cLINARQ)
					nQTDEMB		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 9 = Valor total do produto
					nPOSPON		:= AT("^",cLINARQ)
					nVLRTOT		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					nVLRTOT		:= VAL(STRTRAN(nVLRTOT,",","."))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 10 = Vazio
					nPOSPON		:= AT("^",cLINARQ)
					cPOSVAZ		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 11 = Percentual de desconto do produto
					nPOSPON		:= AT("^",cLINARQ)
					nPRCDES		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					nPRCDES		:= VAL(STRTRAN(nPRCDES,",","."))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 12 = C๓digo da forma de pagamento
					nPOSPON		:= AT("^",cLINARQ)
					cFRMPAG		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 13 = C๓digo do vendedor
					nPOSPON		:= AT("^",cLINARQ)
					cCODVEN		:= RIGHT(ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1)),6)
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 14 = Data base vencimento 
					nPOSPON		:= AT("^",cLINARQ)
					cDATVCT		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 15 = C๓digo da Transportadora
					nPOSPON		:= AT("^",cLINARQ)
					cCODTRP		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 16 = C๓digo da esp้cie 
					nPOSPON		:= AT("^",cLINARQ)
					cCODESP		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 17 = Vazio
					nPOSPON		:= AT("^",cLINARQ)
					cPOSVAZ		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 18 = Saldo flex do item
					nPOSPON		:= AT("^",cLINARQ)
					cSLDFLX		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					cLINARQ		:= SubSTR(cLINARQ,nPOSPON+1,Len(cLINARQ))
					//--Posi็ใo: 19 = CNPJ cliente
					nPOSPON		:= AT("^",cLINARQ)
					cCNPJCL		:= ALLTRIM(SubSTR(cLINARQ,1,nPOSPON-1))
					
					aAdd (aORCAMENTOS, { dDATEMI, cCNPJCL, cCODPRD, nQTDADE, nVLRTOT, nPRCDES, cCODVEN, aARQUIVOS[nARQ] } )
					
			   	EndIf

				//--Grava linha no arquivo da pasta importados
				fWrite(nHldEXP,cBKPLIN+CHR(13)+CHR(10),Len(cBKPLIN+CHR(13)+CHR(10)))

				//--Adiciona registro no arquivo de log
				cTEXTO := "Leitura da string: " + cBKPLIN
				fGravaLog(cTEXTO)
				conout(cTEXTO)

				Ft_FSkip()
			EndDo 
			//--Fecha arquivo de importacao
			Ft_FUse()
			
			//--Adiciona registro no arquivo de log
			cTEXTO := "Criado copia do arquivo: " + cARQEXP
			fGravaLog(cTEXTO)
			conout(cTEXTO)

			//--Exclui arquivo de importacao
			If fErase(cARQIMP) == 0
				
				//--Adiciona registro no arquivo de log
				cTEXTO := "Excluํdo arquivo: " + cARQIMP
				fGravaLog(cTEXTO)
				conout(cTEXTO)

				If Len(aORCAMENTOS) > 0
					//--Fun็ใo para gravar or็amento
					fImpOrcamento()
				Else
					//--Adiciona registro no arquivo de log
					cTEXTO := "Nใo existem dados a serem importados (PV)."
					fGravaLog(cTEXTO)
					conout(cTEXTO)
				EndIf
	
			Else
				//--Adiciona registro no arquivo de log
				cTEXTO := "ERRO na exclusao do arquivo: " + cARQIMP + " - ERRORCODE: "+cValToChar(FError())+" o orcamento nao foi importado!"
				fGravaLog(cTEXTO)
				conout(cTEXTO)                                     
			EndIf
				
			//--Fecha arquivo log
			fClose(nHldIMP)
			fClose(nHldEXP)
			fClose(nHldLOG)
				
		Next nARQ
	EndIf       
	                                                 
	conout(TIME()+" - RJLOJP02 - FIM DA EXECUวรO.")    
	RpcClearEnv()

Return	

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfImpOrcamentoบAutor ณTOTVS PARANA CENTRALบ Data ณ 27/11/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta็ใo de or็amentos do sistema EECO para o controle de บฑฑ
ฑฑบ          ณlojas.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------------*	        
Static Function fImpOrcamento()
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea()
Local nTOTORC  := 0
Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณExecuta os procedimentos de inclusใo do or็amento\atendimentoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	BEGIN TRANSACTION
	
		dbSelectArea("SA1")
		SA1->(dbSetOrder(3))
		SA1->(dbGoTop())
		If !SA1->( dbSeek(xFilial("SA1") + aORCAMENTOS[01,02] ))
			//--Adiciona registro no arquivo de log
			cTEXTO := "CNPJ nใo localizado no cadastro de clientes: "+aORCAMENTOS[01,02]
			fGravaLog(cTEXTO)
			conout(cTEXTO)
			DISARMTRANSACTION()
			RestArea(aAreaTMP)
			Return .F.		
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "Cliente do orcamento: "+SA1->A1_COD+"-"+SA1->A1_LOJA+"-"+ALLTRIM(SA1->A1_NOME)
			fGravaLog(cTEXTO)
			conout(cTEXTO)
		EndIf


		dbSelectArea("SA3")
		SA3->(dbSetOrder(1))
		SA3->(dbGoTop())
		If !SA3->( dbSeek(xFilial("SA3") + aORCAMENTOS[01,07] ))
			//--Adiciona registro no arquivo de log
			cTEXTO := "Codigo nใo localizado no cadastro de vendedores: "+aORCAMENTOS[01,07]
			fGravaLog(cTEXTO)
			conout(cTEXTO)
			DISARMTRANSACTION()
			RestArea(aAreaTMP)
			Return .F.		
		Else
			//--Adiciona registro no arquivo de log
			cTEXTO := "Vendedor do orcamento: "+SA3->A3_COD+"-"+ALLTRIM(SA3->A3_NOME)
			fGravaLog(cTEXTO)
			conout(cTEXTO)
		EndIf			
	
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComposi็ใo dos itens do or็amentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		aItens := {}
		For nI := 1 To Len(aORCAMENTOS)
			cITEM	:= STRZero(nI,TAMSX3("LR_ITEM")[1])
			nVRUNIT	:= aORCAMENTOS[nI,05]/aORCAMENTOS[nI,04]
			nQUANT	:= aORCAMENTOS[nI,04]
			VLRITEM := aORCAMENTOS[nI,05]
			nDESC	:= aORCAMENTOS[nI,06]
			nTOTORC += VLRITEM
			
			dbSelectArea("SB1")
			SB1->(dbSetOrder(1))
			SB1->(dbGoTop())
			If !SB1->(dbSeek(xFilial("SB1") + aORCAMENTOS[nI,03]))	
				//--Adiciona registro no arquivo de log
				cTEXTO := "C๓digo nใo localizado no cadastro de produtos: "+aORCAMENTOS[nI,03]
				fGravaLog(cTEXTO)
				conout(cTEXTO)
				RollBackSx8()
				DISARMTRANSACTION()
				RestArea(aAreaTMP)
				Return .F.		
			EndIf
			
			aItem	:= {}             
			AADD(aItem ,{"LR_ITEM"		, cITEM				, NIL})
			AADD(aItem ,{"LR_PRODUTO"	, SB1->B1_COD		, NIL})
			AADD(aItem ,{"LR_LOCAL"		, SB1->B1_LOCPAD	, NIL})
			AADD(aItem ,{"LR_QUANT"		, nQUANT			, NIL})
			AADD(aItem ,{"LR_VRUNIT"	, nVRUNIT			, NIL}) 
			AADD(aItem ,{"LR_VLRITEM"	, VLRITEM			, NIL}) 
			AADD(aItem ,{"LR_DESC"		, nDESC				, NIL}) 
			aItem := FWVetByDic(aItem, "SLR")
	
			//--Adiciona registro no arquivo de log
			cTEXTO := "Adicionado produto ao orcamento: "+ALLTRIM(SB1->B1_COD)+"-"+ALLTRIM(SB1->B1_DESC)
			fGravaLog(cTEXTO)
			conout(cTEXTO)
		
			AADD(aItens, aItem)
		Next nI

	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComposi็ใo do cabecalho                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ

		cNUMSEQ	:= GETSXENUM("SL1","L1_NUM")
		dDATEMI := aORCAMENTOS[01,01]
		cCODVEN := aORCAMENTOS[01,07]
		//Guilherme 13/02/14 pegar os 8 primeiros digitos apos alteracao da Eeco, o nro do pedido tera o codigo do vend. VV mais 6 digitos do pedido VV000000 
		cNREECO := LEFT(aORCAMENTOS[01,08],7)  		
		

		aCab	:= {}
		AADD(aCab, {"LQ_NUM"  	, cNUMSEQ	     	, NIL})
		AADD(aCab, {"LQ_VEND"  	, cCODVEN	    	, NIL})
		AADD(aCab, {"LQ_COMIS"	, 0				 	, NIL})
		AADD(aCab, {"LQ_CLIENTE", SA1->A1_COD	 	, NIL})
		AADD(aCab, {"LQ_LOJA"  	, SA1->A1_LOJA    	, NIL})
		AADD(aCab, {"LQ_TIPOCLI", SA1->A1_TIPO  	, NIL})
		AADD(aCab, {"LQ_VLRTOT"	, nTOTORC	     	, NIL})
		AADD(aCab, {"LQ_VLRLIQ"	, nTOTORC			, NIL})
		AADD(aCab, {"LQ_DINHEIR", nTOTORC			, NIL})
		AADD(aCab, {"LQ_DTLIM"	, dDATEMI  		   	, NIL})
		AADD(aCab, {"LQ_X_CLVL"	, cCODCLV  		   	, NIL})
		AADD(aCab, {"LQ_ENDCOB"	, cNREECO  		   	, NIL})

		aCab := FWVetByDic(aCab, "SLQ")      
		
        
		If dDATEMI <> ddatabase
			//--Adiciona registro no arquivo de log
			cTEXTO := "Data or็amento ("+DTOC(dDATEMI)+") diferente da database ("+DTOC(ddatabase)+")."
			fGravaLog(cTEXTO)
			conout(cTEXTO)     
		EndIf
	
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณComposi็ใo do array das formas de pagamentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		aForma	:= {}
		AADD(aForma, {{"L4_DATA"   , ddatabase	       , NIL},;
		              {"L4_VALOR"  , nTOTORC	       , NIL},;
		              {"L4_FORMA"  , "R$             " , NIL},;
		              {"L4_ADMINIS", "               " , NIL},;
		              {"L4_FORMAID", " "               , NIL},;
		              {"L4_MOEDA"  , 0      		   , NIL}})
	    aForma := FWVetByDic(aForma, "SL4", .T.)
	                                   
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณExecuta rotina automแtica de inclusใo do or็amentoณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		nModulo := 12	//--SIGALOJA
		SetFunName("LOJA701")
		MSExecAuto({|a,b,c,d,e,f,g,h| LOJA701(a,b,c,d,e,f,g,h)}, .F., 3, "", "", {}, aCab, aItens, aForma)
	
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		//ณVerifica a ocorr๊ncia de erro na rotina automแticaณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
		If lMsErroAuto
	   		RollBackSx8()
	   		DISARMTRANSACTION()
	   		cMSGERRO := MostraErro()
			//--Adiciona registro no arquivo de log
			cTEXTO := "ERRO na grava็ใo do or็amento: "+cMSGERRO
			fGravaLog(cTEXTO)
			conout(cTEXTO)
	 	Else
			ConfirmSx8()	
			//--Adiciona registro no arquivo de log
			cTEXTO := "Or็amento gravado com sucesso! N๚mero: "+cNUMSEQ
			fGravaLog(cTEXTO)
			conout(cTEXTO)
	 	EndIf
		
	END TRANSACTION

	RestArea(aAreaTMP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma ณfGravaLog    บAutor ณTOTVS PARANA CENTRALบ Data ณ 27/11/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta็ใo de or็amentos do sistema EECO para o controle de บฑฑ
ฑฑบ          ณlojas.                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ TOTVS                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------------*	        
Static Function fGravaLog(cTEXTO)                                                       
*---------------------------------------------------------------------------*	        
Local cSTR := TIME()+" - "+cTEXTO+CHR(13)+CHR(10)
	
	fWrite(nHldLOG,cSTR,Len(cSTR))
	
Return
