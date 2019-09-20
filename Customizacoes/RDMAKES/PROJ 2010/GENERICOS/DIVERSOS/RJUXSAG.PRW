#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUXSAG   บ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Programa para integra็ใo de arquivos Protheus x SAG.       บฑฑ
ฑฑบ          ณ Executado atrav้s de schedule: (U_RJUXSAG())               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------*
User Function RJUXSAG()      
*---------------------------* 

	// Tem que iniciar por starjob pois nใo ้ possํvel trocar de empresa diretamente.
	StartJob("U_RJUExSag",GetEnvServer(), .T.,"01", "01")
	
Return

// Flavio - 31/01/2011
// Criado nova fun็ใo devido a nใo ser possํvel trocar de empresa diretamente na execu็ใo do schedule.
*---------------------------*
User Function RJUExSag()     
*---------------------------*
Public STRING_NULL := ""
Public aDICIONARIO := {}
Public aDADOSEXP   := {}
Public aCABECIMP   := {}
Public aDADOSIMP   := {}
Public cTRIGGER    := "G"
Public cTABLE      := "T"
Public cINDEX      := "I" 

RPCSetType(3)	
Prepare Environment Empresa "01" Filial "01"

// Somente pode processar se estiver na filial 01, caso contrแrio obt้m o parโmetro mv_estneg de outra filial.
if (cFilAnt != "01")
	ConOut("RJUXSAG - Filial nใo ้ 01, cancelado o processo")
	Return
EndIf  

//--Cria็ใo de arquivo temporแrio sobre a execu็ใo da rotina, devido a execu็ใo N vezes pelo schedule decorrente das threads
nLock := 0
While !LockByName("RJUXSAG",.T.,.F.,.T.)
	nLock += 1
	Sleep(1000)                                    	
	If nLock > 200                                 
		ConOut("RJUXSAG - CONTROLE DE SEMมFORO - Rotina finalizada pois jแ esta sendo executada!")
		Return
	EndIf		
EndDo
                          
Public cOWNPRD := SuperGetMv("MV_X_UPSAG",,"TOTVS10")
Public cDATPRD := SuperGetMv("MV_X_DPSAG",,"ORACLE/TOTVS10")
Public cSRVPRD := SuperGetMv("MV_X_SPSAG",,"192.168.210.13")            
Public cOWNINT := SuperGetMv("MV_X_UISAG",,"TOTVS10")
Public cDATINT := SuperGetMv("MV_X_DISAG",,"ORACLE/SAG")
Public cSRVINT := SuperGetMv("MV_X_SISAG",,"192.168.210.13")
Public nPORTOP := 7890

Public hENTER  := chr(10)+chr(13)

Public nHCONNPRD := FOPENCON(cDATPRD,cSRVPRD,nPORTOP)
Public nHCONNINT := FOPENCON(cDATINT,cSRVINT,nPORTOP)
                                          

	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" INICIO EXECUCAO.")

	//-- Falha na abertura das conex๕es.
	If nHCONNPRD < 0 .or. nHCONNINT < 0
		//-- Encerra conex๕es abertas.
		TCUnLink(nHCONNINT)                     
		TCUnLink(nHCONNPRD) 
		Return		
	EndIf

	//-- Atualiza็๕es de estruturas de dicionแrio, database intermediแrio.
	TCSETCONN(nHCONNINT)
	FDEFDICINT(aDICIONARIO)


	//-- Atualiza็๕es de estruturas de dicionแrio, database protheus.	
	TCSETCONN(nHCONNPRD)	
	FDEFDICPRD(aDICIONARIO)

	
	//-- Busca de registros a serem exportados, database protheus.
	
	FSELREGPRD(aDADOSEXP)

	
	//-- Exporta็ใo de registros database intermediแrio.
	
	TCSETCONN(nHCONNINT)
	FEXPREGINT(aDADOSEXP)

	
	//-- Importa็ใo de registros database intermediแrio.
	TCSETCONN(nHCONNINT)
	FIMPREGINT(aDADOSIMP)

                                                                  
	//-- Encerra conex๕es abertas.
	TCUnLink(nHCONNINT)                     
	TCUnLink(nHCONNPRD) 

	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" FIM EXECUCAO.")

	   
Return  
       

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPREGINTบ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca de registros a serem importados database intermediแ- บฑฑ
ฑฑบ          ณrio, realiza importa็ใo database protheus.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------*
Static Function FIMPREGINT(aDADOSIMP)          
*---------------------------------------------*
Private cNOMTAB := STRING_NULL
Private cLSTCPO := STRING_NULL
Private cLSTVLR := STRING_NULL
Private cCPOCTL := STRING_NULL
Private cAliasTMP := GetNextAlias()
Private lMsErroAuto := .F.         


	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" INICIO - PROCESSO DE IMPORTACAO DE DADOS")

	//-- Defini็ใo dos campos de leitura, e sele็ใo dos tํtulos a importar, database intermediแrio.
	If Len(aDICIONARIO) > 0
		cNOMTAB := "SD3010"
		nPOS := aScan ( aDICIONARIO, {|x| x[1] == cTABLE .and. x[2] == cNOMTAB } )
		If nPOS != 0
			For nK := nPOS to Len(aDICIONARIO)
				If aDICIONARIO[nK,01] == cTABLE .and. aDICIONARIO[nK,02] == cNOMTAB
					cLSTCPO += aDICIONARIO[nK,03]+","
					aAdd ( aCABECIMP, { aDICIONARIO[nK,03] } )
				Else
					Exit
				EndIf		    
			Next nK
	
			If cLSTCPO != STRING_NULL			
				cLSTCPO := SubSTR(cLSTCPO,1,Len(cLSTCPO)-1)
				FADDIMP(nPOS)				
			EndIf
		EndIf
		nLENCABEC := Len(aCABECIMP)		    
		
	EndIf        
	
	

	//-- Inclusใo dos movimentos internos, database protheus.
	TCSETCONN(nHCONNPRD)

	If Len(aDADOSIMP) > 0
		
		Begin Transaction
			For nKIND := 1 to Len(aDADOSIMP)
				
                
				nPCODTPM := aScan( aCABECIMP, {|x| x[1] == "D3_TM" 		 	} )	//Tipo Movimento				
				nPCODPRD := aScan( aCABECIMP, {|x| x[1] == "D3_COD"			} )	//Produto
				nPCODCNT := aScan( aCABECIMP, {|x| x[1] == "D3_CONTA"		} )	//Conta
				nPQUANTD := aScan( aCABECIMP, {|x| x[1] == "D3_QUANT"		} )	//Quantidade NF
				nPCUSTO1 := aScan( aCABECIMP, {|x| x[1] == "D3_CUSTO1"		} )	//Valor
				nPDOCUME := aScan( aCABECIMP, {|x| x[1] == "D3_DOC"			} )	//Documento
				nPEMISSA := aScan( aCABECIMP, {|x| x[1] == "D3_EMISSAO"		} )	//Emissใo 
				nPCODCLV := aScan( aCABECIMP, {|x| x[1] == "D3_CLVL"		} )	//Segmento
				nPCODITE := aScan( aCABECIMP, {|x| x[1] == "D3_ITEMCTA"		} )	//Local Trabalho
				nPCODCTC := aScan( aCABECIMP, {|x| x[1] == "D3_CC"			} )	//Centro de custo
				nPKEYSAG := aScan( aCABECIMP, {|x| x[1] == "R_E_C_N_O_"		} )	//C๓digo de Integra็ใo
				nPCODORD := aScan( aCABECIMP, {|x| x[1] == "D3_OP"  		} ) //Ordem produ็ใo
				nPCODORD := aScan( aCABECIMP, {|x| x[1] == "D3_LOCAL"  		} ) //Armazem
				nPOPRINT := aScan( aCABECIMP, {|x| x[1] == "OPERACAO_INT"  	} )	//Opera็ใo											
				
				
				dbSelectArea("SB1")
				dbSetOrder(1)
				If dbSeek( xFilial("SB1") + ALLTRIM(aDADOSIMP[nKIND,nPCODPRD]) )
					          
					nTIPOP := 3					
					cCODFILINC := ""
					lIncluiSD3 := .T.					
					lMsErroAuto	:= .F.                                 
										
					cDocSD3   := ALLTRIM(aDADOSIMP[nKIND,nPDOCUME])
					cDocSD3   := IIF(Len(cDocSD3)>=TAMSX3("D3_DOC")[1],SubSTR(cDocSD3,1,TAMSX3("D3_DOC")[1]),cDocSD3+Space(TAMSX3("D3_DOC")[1]-Len(cDocSD3)))						
					
					If ! ALLTRIM(aDADOSIMP[nKIND,nPCODTPM]) $ "111/511"
						
						aArraySD3  := {	{"D3_FILIAL"	,"01"								,Nil	},;					
										{"D3_TM"		,ALLTRIM(aDADOSIMP[nKIND,nPCODTPM])	,Nil	},;					
										{"D3_COD"		,ALLTRIM(aDADOSIMP[nKIND,nPCODPRD])	,Nil	},;									
										{"D3_UM"		,SB1->B1_UM							,Nil	},;									
										{"D3_CONTA"		,ALLTRIM(aDADOSIMP[nKIND,nPCODCNT])	,Nil	},;
										{"D3_QUANT"		,aDADOSIMP[nKIND,nPQUANTD]			,Nil	},;
										{"D3_CUSTO1"	,aDADOSIMP[nKIND,nPCUSTO1]			,Nil	},;
										{"D3_DOC"		,ALLTRIM(aDADOSIMP[nKIND,nPDOCUME])	,Nil	},;
										{"D3_EMISSAO"	,stod(aDADOSIMP[nKIND,nPEMISSA])	,Nil	},;
										{"D3_CLVL"		,"007001001"						,Nil	},;
										{"D3_ITEMCTA"	,ALLTRIM(aDADOSIMP[nKIND,nPCODITE])	,Nil	},;
										{"D3_CC"		,ALLTRIM(aDADOSIMP[nKIND,nPCODCTC])	,Nil	},;
										{"D3_LOCAL"		,SB1->B1_LOCPAD						,Nil	},; 
										{"D3_X_KSAG"	,aDADOSIMP[nKIND,nPKEYSAG]			,Nil	},;
										{"D3_X_OPSAG"	,aDADOSIMP[nKIND,nPCODORD]			,Nil	}}
	

						//--VERIFICA SE JA EXISTE O MOVIMENTO NA BASE
						dbSelectArea("SD3")
						dbSetOrder(2)	//--D3_FILIAL+D3_DOC+D3_COD
						If dbSeek( xFilial("SD3") + cDocSD3 + SB1->B1_COD )
							If SD3->D3_TM == ALLTRIM(aDADOSIMP[nKIND,nPCODTPM])
								lIncluiSD3 := .F.
							EndIf
						EndIf


						//-- Execauto movimento interno.
						If lIncluiSD3
							aAreaTMP := GetArea()
							MSExecAuto({|x,y| mata240(x,y)}, aArraySD3, nTIPOP)
							cCODFILINC := SD3->D3_FILIAL
							RestArea(aAreaTMP)
						EndIf
						
					Else
					    ConOut( "B7_COD: "   +ALLTRIM(aDADOSIMP[nKIND,nPCODPRD])+" "+;
					    		"B7_LOCAL: " +SB1->B1_LOCPAD+" "+;
					    		"B7_TIPO: "  +SB1->B1_TIPO+" "+;
					    		"B7_DOC: "   +ALLTRIM(aDADOSIMP[nKIND,nPDOCUME])+" "+;
					    		"B7_QUANT: " +Transform(aDADOSIMP[nKIND,nPQUANTD], "@E 9,999,999.99")+" "+;
					    		"B7_DATA: "  +aDADOSIMP[nKIND,nPEMISSA])
					    		
						aArraySB7  := {	{"B7_FILIAL"	,"01"								,Nil	},;					
                        				{"B7_COD"		,ALLTRIM(aDADOSIMP[nKIND,nPCODPRD])	,Nil	},;	
                        				{"B7_LOCAL"		,SB1->B1_LOCPAD						,Nil	},;	
                        				{"B7_TIPO"		,SB1->B1_TIPO						,Nil	},;	
                        				{"B7_DOC"		,ALLTRIM(aDADOSIMP[nKIND,nPDOCUME])	,Nil	},;	
                        				{"B7_QUANT"		,aDADOSIMP[nKIND,nPQUANTD]			,Nil	},;	
                        				{"B7_DATA"		,stod(aDADOSIMP[nKIND,nPEMISSA])	,Nil	}}	
                        				                        				

						//-- Execauto movimento inventแrio.
						dbSelectArea("SB7")
						aAreaTMP := GetArea()						
						MSExecAuto({|x,y| mata270(x,y)}, aArraySB7, .F. ,nTIPOP) 					
						cCODFILINC := SB7->B7_FILIAL
						RestArea(aAreaTMP)                                 
					
					EndIf
					
					If lMsErroAuto					
						aDADOSIMP[nKIND,nLENCABEC-1] := .F.
						aDADOSIMP[nKIND,nLENCABEC] := MostraErro()
						CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" ERRO INCLUSAO DO REGISTRO (CHAVE SAG: "+cValToChar(aDADOSIMP[nKIND,nPKEYSAG])+")")
						CONOUT(aDADOSIMP[nKIND,nLENCABEC])
						cErroTit := "Erro ao importar, Tipo Mov " + ALLTRIM(aDADOSIMP[nKIND,nPCODTPM]) + ", Produto " + ALLTRIM(aDADOSIMP[nKIND,nPCODPRD]) + ;
							", quantidade " + Str(aDADOSIMP[nKIND,nPQUANTD]) + ", emissใo " + aDADOSIMP[nKIND,nPEMISSA] + ", custo " + Str(aDADOSIMP[nKIND,nPCUSTO1])
						MailErro(aDADOSIMP[nKIND,nLENCABEC], cErroTit)
					Else                                              
						
						If ! ALLTRIM(aDADOSIMP[nKIND,nPCODTPM]) $ "111/511"

							
							If lIncluiSD3
								CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" OK INCLUSAO MOV. INTERNO (CHAVE SAG: "+cValToChar(aDADOSIMP[nKIND,nPKEYSAG])+")")
								aDADOSIMP[nKIND,nLENCABEC] := "IMPORTACAO OK"
								aDADOSIMP[nKIND,nLENCABEC-1] := .F.
							Else
								CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" DOCUMENTO JA EXISTENTE NA BASE DE DADOS (CHAVE SAG: "+cValToChar(aDADOSIMP[nKIND,nPKEYSAG])+")")
								aDADOSIMP[nKIND,nLENCABEC] := "DOCUMENTO JA EXISTENTE NA BASE DE DADOS"
								aDADOSIMP[nKIND,nLENCABEC-1] := .T.
							EndIf
	
							If ALLTRIM(cCODFILINC) != "01" .AND. ALLTRIM(cCODFILINC) != ""
								cErroTit := "IMPORTAวรO SAG FILIAL INCORRETA = "+SD3->D3_FILIAL
								cErroMsg := "Problema ao importar MOV.INTERNO (FILIAL INCORRETA = "+SD3->D3_FILIAL+"), Tipo Mov " + ALLTRIM(aDADOSIMP[nKIND,nPCODTPM]) + ", Produto " + ALLTRIM(aDADOSIMP[nKIND,nPCODPRD]) + ;
								", quantidade " + Str(aDADOSIMP[nKIND,nPQUANTD]) + ", emissใo " + aDADOSIMP[nKIND,nPEMISSA] + ", custo " + Str(aDADOSIMP[nKIND,nPCUSTO1])
								MailErro(cErroMsg, cErroTit)
							EndIf
							
                        Else 

							CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" OK INCLUSAO INVENTARIO (CHAVE SAG: "+cValToChar(aDADOSIMP[nKIND,nPKEYSAG])+")")
							aDADOSIMP[nKIND,nLENCABEC-1] := .T.
							aDADOSIMP[nKIND,nLENCABEC] := "IMPORTACAO OK"
	
							If ALLTRIM(cCODFILINC) != "01" .AND. ALLTRIM(cCODFILINC) != ""
								cErroTit := "IMPORTAวรO SAG FILIAL INCORRETA = "+SB7->B7_FILIAL
								cErroMsg := "Problema ao importar INVENTARIO (FILIAL INCORRETA = "+SB7->B7_FILIAL+"), Tipo Mov " + ALLTRIM(aDADOSIMP[nKIND,nPCODTPM]) + ", Produto " + ALLTRIM(aDADOSIMP[nKIND,nPCODPRD]) + ;
								", quantidade " + Str(aDADOSIMP[nKIND,nPQUANTD]) + ", emissใo " + aDADOSIMP[nKIND,nPEMISSA] + ", custo " + Str(aDADOSIMP[nKIND,nPCUSTO1])
								MailErro(cErroMsg, cErroTit)
							EndIf                        
							
	                    EndIf
							
					EndIf 
				Else
					aDADOSIMP[nKIND,nLENCABEC] := .F.	
				EndIf
				
			Next nKIND
			
			//-- Atualiza registros como processados, database intermediแrio.
			TCSETCONN(nHCONNINT)
			For nK := 1 to Len(aDADOSIMP)  
				If aDADOSIMP[nK,nLENCABEC-1]
					cUPD := "'E'"
				Else
					cUPD := "'S'"
				EndIf				
				cQuery := " UPDATE " + cNOMTAB + " SET STATUS_INT = " + cUPD + ", ERROMENS_INT = '" + SubSTR(aDADOSIMP[nK,nLENCABEC],1,200) + "' WHERE R_E_C_N_O_ = " + cValToChar(aDADOSIMP[nK,nPKEYSAG])
				Conout(Alltrim(cQuery))
				TCSqlExec(cQuery)				
			Next nK
			
		End Transaction                                      
	EndIf
	
	                                    
	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" FIM - PROCESSO DE IMPORTACAO DE DADOS")
	
Return

                     
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFADDIMP   บ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para sele็ใo de campos e montagem dos comandos de   บฑฑ
ฑฑบ          ณ inclusใo database protheus.                                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*--------------------------------*
Static Function FADDIMP(nPOS)
*--------------------------------*
Local cQuery := STRING_NULL
		
	cQuery := "	SELECT 	" + cLSTCPO 
	cQuery += " FROM 	" + cNOMTAB 
	cQuery += " WHERE OPERACAO_INT IN ('I','E') AND STATUS_INT NOT IN ('S','E','I') ORDER BY D3_EMISSAO, R_E_C_N_O_ "
	
	cLSTCPO := STRING_NULL
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())

	//-- Processamento de registros selecionados.
	While !(cAliasTMP)->(EOF())
		aAdd ( aDADOSIMP, Array(Len(aCABECIMP)+2)  )
		For nB := 1 to Len(aCABECIMP)
			aDADOSIMP[Len(aDADOSIMP),nB] := &((cAliasTMP)+"->"+aCABECIMP[nB,01])
		Next nB                
		aDADOSIMP[Len(aDADOSIMP),Len(aCABECIMP)+1] := .F.
		(cAliasTMP)->(dbSkip())
		
	Enddo
	
	(cAliasTMP)->(dbCloseArea())

	
Return

 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFSELREGPRDบ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Busca de registros a serem exportados, database protheus.  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------*
Static Function FSELREGPRD(aDADOSEXP)          
*---------------------------------------------*
Private cNOMTAB := STRING_NULL
Private cLSTCPO := STRING_NULL
Private cLSTVLR := STRING_NULL
Private cCPOCTL := STRING_NULL
Private lSIGAMAT  := .T.
Private cAliasTMP := GetNextAlias() 
Private cAliasSAG := GetNextAlias()

	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" INICIO - PROCESSO DE EXPORTACAO DE DADOS")

	If Len(aDICIONARIO) > 0                  
		//--Percorre array de dicionแrio com campos/tabelas
		For nK := 1 to Len(aDICIONARIO)
			
			If aDICIONARIO[nK,01] == cTABLE .and. ! aDICIONARIO[nK,02] $ "SIGAMAT/SD3010"
			
				//-- Adiciona nome dos campos a lista.
				If cNOMTAB != STRING_NULL .and. cNOMTAB != aDICIONARIO[nK,02]
					
					nPOS := aScan ( aDICIONARIO, {|x| x[1] == cTRIGGER .and. x[3] == cNOMTAB })
					FADDEXP(nPOS)					
					cLSTCPO := aDICIONARIO[nK,03]+","
				
				Else
					If aDICIONARIO[nK,07]
						cLSTCPO += aDICIONARIO[nK,03]+","
					EndIf
				EndIf		    
				
				cNOMTAB := aDICIONARIO[nK,02]
		         
		    /* deve ser enviada uma ๚nica vez...
		    ElseIf aDICIONARIO[nK,01] == cTABLE .and. aDICIONARIO[nK,02] == "SIGAMAT" .and. lSIGAMAT
		    	
		    	lSIGAMAT := .F.
				
				dbSelectArea("SM0")
				aAreaSM0 := SM0->(GetArea())
				SM0->(dbSetOrder(1))
				SM0->(dbSeek("0101"))				
				cLSTCPO := "M0_CODIGO,M0_CODFIL,M0_NOME,STATUS_INT,OPERACAO_INT"
				cLSTVLR := "'"+SM0->M0_CODIGO+"','"+SM0->M0_CODFIL+"','"+SM0->M0_NOME+"','I','I'"
				RestArea(aAreaSM0)
				
				aAdd ( aDADOSEXP, {aDICIONARIO[nK,02], cLSTCPO, cLSTVLR } ) 
				
				cLSTCPO := STRING_NULL
				cLSTVLR := STRING_NULL
		    		                            
		  	*/
		    EndIf
		
		Next nK

		//-- Chamada fun็ใo para sele็ใo de registros.
		If cNOMTAB != STRING_NULL

			nPOS := aScan ( aDICIONARIO, {|x| x[1] == cTRIGGER .and. x[3] == cNOMTAB })
			FADDEXP(nPOS)					
		
		EndIf		    

	EndIf
	                                    

Return

                       
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFADDEXP   บ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para sele็ใo de campos e montagem dos comandos de   บฑฑ
ฑฑบ          ณ inclusใo database intermediแrio.                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*--------------------------------*
Static Function FADDEXP(nPOS)
*--------------------------------*


	If nPOS != 0
		
		//-- Monta comando de sele็ใo dos registros.
		cCPOCTL := aDICIONARIO[nPOS,04]+"X_SAG"
		cCPOFIL := aDICIONARIO[nPOS,04]+"FILIAL"
		cQuery := "	SELECT " + cLSTCPO 
		cQuery += " CASE WHEN " + cCPOCTL + " IN ('I','A') AND D_E_L_E_T_ = '*' THEN 'E' " 
		cQuery += " WHEN " + cCPOCTL + " = 'A' AND D_E_L_E_T_ != '*' THEN 'A' "
		cQuery += " ELSE 'I' END SAG "
		cQuery += " FROM " + cNOMTAB 
		cQuery += " WHERE " + cCPOCTL + " != ' ' "
		
		//--Filtro sobre os registros da filial 01 quando tabela nใo compartilhada.
		If ! "CMP" $ cNOMTAB
			cQuery += " AND " + cCPOFIL + " = '01' "
		EndIf
        
		//--Tratamentos especificos para determinadas tabelas.
		If cNOMTAB == "CTDCMP"
			cQuery += " AND CTD_X_CC != '"+Space(TAMSX3("CTD_X_CC")[1])+"' "
		
		ElseIf cNOMTAB == "SBMCMP"
			cQuery += " ORDER BY LENGTH(TRIM(BM_GRUPO)) "
		
		ElseIf cNOMTAB == "CT2010"
            
			//--Lote: 008890 - Folha de pagamento
			//--Lote: 008860 - Ativo deprecia็ใo
			//--Lote: 008850 - Movimentos financeiros ( para este lote somente contas contแbeis com campo CT1_X_ESAG = 'S' )
			cQuery += " AND CT2_LOTE IN ('008890','008860','008850') "
			cQuery += " AND ( ( 	CT2_LOTE  = '008850'  "
			cQuery += " 	AND ( 	CT2_DEBITO IN ( SELECT CT1_CONTA FROM CT1CMP CT1 WHERE CT1.CT1_X_ESAG = 'S' AND CT1.D_E_L_E_T_ != '*')		"
			cQuery += " 	OR	 	CT2_CREDIT IN ( SELECT CT1_CONTA FROM CT1CMP CT1 WHERE CT1.CT1_X_ESAG = 'S' AND CT1.D_E_L_E_T_ != '*') ) 	"
			cQuery += " 	)	OR  CT2_LOTE != '008850' ) "
			
		EndIf 

		//--Ordena registros pelo RECNO
		If ! cNOMTAB $ "CT2010/SIGAMAT/SBMCMP"                           
			cQuery += " ORDER BY R_E_C_N_O_ "
		EndIf
				
		cLSTCPO := STRING_NULL
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		nPOS := aScan ( aDICIONARIO, {|x| x[1] == cTABLE .and. x[2] == cNOMTAB })
		
		
		//--Montagem da instru็ใo de inclusใo de registros nas tabelas de integra็ใo.
		If nPOS != 0  
			
			While !(cAliasTMP)->(EOF())
				cLSTCPO := STRING_NULL
				cLSTVLR := STRING_NULL
				For nB := nPOS to Len(aDICIONARIO)
					If aDICIONARIO[nB,01] != cTABLE .or. aDICIONARIO[nB,02] != cNOMTAB
						Exit
					EndIf
					If aDICIONARIO[nB,03] == "STATUS_INT"
						Exit
					EndIf
					If ! aDICIONARIO[nB,07]
						Loop
					EndIf 
					cCPOVLR := &((cAliasTMP)+"->"+aDICIONARIO[nB,03])
					If ValType(cCPOVLR)=="C"
						cCPOVLR := STRTRAN(cCPOVLR,"'","")
						cCPOVLR := STRTRAN(cCPOVLR,"&","E")
					EndIf
					cLSTCPO	+= aDICIONARIO[nB,03]+","
					cLSTVLR += IIF(ValType(cCPOVLR)=="C","'"+cCPOVLR+"'",cValToChar(cCPOVLR))+","
				Next nB
				
				If cNOMTAB $ "CT1CMP/CTDCMP/CTTCMP/SB1CMP/SD1010/SD2010"
					If cNOMTAB == "CT1CMP"                               
						//-- Defini็ใo da classe (nํvel) da conta contแbil.
						nLENCPO := Len(ALLTRIM((cAliasTMP)->CT1_CONTA))
						If nLENCPO == 1
							nCLASSE := 1
						ElseIf nLENCPO == 2
							nCLASSE := 2
						ElseIf nLENCPO == 3         
							nCLASSE := 3    
						ElseIf nLENCPO == 5
							nCLASSE := 4
						ElseIf nLENCPO == 7             
							nCLASSE := 5
						Else
							nCLASSE := 6
						EndIf										
						cLSTCPO += "CT1_CLASSE,"
						cLSTVLR += cValToChar(nCLASSE)+","
						
					ElseIf cNOMTAB == "CTDCMP"                              
						//-- Defini็ใo da classe (nํvel) do item contแbil.
						nLENCPO := Len(ALLTRIM((cAliasTMP)->CTD_ITEM))
						If nLENCPO == 2
							nCLASSE := 1
						ElseIf nLENCPO == 4
							nCLASSE := 2
						Else
							nCLASSE := 3
						EndIf             									
						cLSTCPO += "CTD_CLASSE,"
						cLSTVLR += cValToChar(nCLASSE)+","

					ElseIf cNOMTAB == "CTTCMP"
						//-- Defini็ใo da classe (nํvel) do centro de custo.
						nLENCPO := Len(ALLTRIM((cAliasTMP)->CTT_CUSTO))
						If nLENCPO == 2
							nCLASSE := 1
						ElseIf nLENCPO == 4
							nCLASSE := 2
						ElseIf nLENCPO == 6
							nCLASSE := 3
						Else
							nCLASSE := 4
						EndIf             																		
						cLSTCPO += "CTT_CLASSE,"
						cLSTVLR += cValToChar(nCLASSE)+","
					
					ElseIf cNOMTAB == "SB1CMP"
						//-- Campo que define se o produto possui estrutura.
						dbSelectArea("SG1")
						dbSetOrder(1)
						If dbSeek(xFilial("SG1")+(cAliasTMP)->B1_COD)
							nEST := 1
						Else
							nEST := 0
						EndIf
						cLSTCPO += "B1_SG1,"
						cLSTVLR += "'"+cValToChar(nEST)+"',"
					
					ElseIf cNOMTAB == "SD1010"
						
						//-- Movimento de estoque para o produto
						cEST := "S"
						cQuerySAG := " SELECT D1_TES FROM " + cNOMTAB + " WHERE R_E_C_N_O_ = "+cValToChar((cAliasTMP)->R_E_C_N_O_)
						TCQUERY ChangeQuery( cQuerySAG ) NEW ALIAS (cAliasSAG)
						dbSelectArea(cAliasSAG)
						(cAliasSAG)->(dbGoTop())
						If !(cAliasSAG)->(EOF())
							dbSelectArea("SF4")
							dbSetOrder(1)
							If dbSeek(xFilial("SF4")+(cAliasSAG)->D1_TES)
								If SF4->F4_ESTOQUE != "S"
									cEST := "N"
								EndIf
							EndIf
						EndIf					
						(cAliasSAG)->(dbCloseArea())
	
						cLSTCPO += "D1_ESTOQUE,"
						cLSTVLR += "'"+cEST+"',"

					ElseIf cNOMTAB == "SD2010"
						
						//-- Movimento de estoque para o produto
						cEST := "S"
						cQuerySAG := " SELECT D2_TES FROM " + cNOMTAB + " WHERE R_E_C_N_O_ = "+cValToChar((cAliasTMP)->R_E_C_N_O_)
						TCQUERY ChangeQuery( cQuerySAG ) NEW ALIAS (cAliasSAG)
						dbSelectArea(cAliasSAG)
						(cAliasSAG)->(dbGoTop())
						If !(cAliasSAG)->(EOF())
							dbSelectArea("SF4")
							dbSetOrder(1)
							If dbSeek(xFilial("SF4")+(cAliasSAG)->D2_TES)
								If SF4->F4_ESTOQUE != "S"
									cEST := "N"
								EndIf
							EndIf
						EndIf					
						(cAliasSAG)->(dbCloseArea())
	
						cLSTCPO += "D2_ESTOQUE,"
						cLSTVLR += "'"+cEST+"',"

					EndIf						
					
				EndIf 
				
				cLSTCPO += "STATUS_INT,OPERACAO_INT"
				cLSTVLR += "'I','" + (cAliasTMP)->SAG + "'"
				
				aAdd ( aDADOSEXP, {cNOMTAB, cLSTCPO, cLSTVLR } )
				
				(cAliasTMP)->(dbSkip())
			Enddo
			
		EndIf 
		
		(cAliasTMP)->(dbCloseArea())
	Endif
	
Return
					
	
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFEXPREGINTบ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Exporta็ใo de registros database intermediแrio.            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------*
Static Function FEXPREGINT(aDADOSEXP)          
*---------------------------------------------*


	If Len(aDADOSEXP) > 0
		
		Begin Transaction
		
			For nK := 1 to Len(aDADOSEXP)                                                                                      
				cQuery := " INSERT INTO " + aDADOSEXP[nK,01] + " (" + aDADOSEXP[nK,02] + ") VALUES (" + aDADOSEXP[nK,03] + ")"
				TCSqlExec(cQuery)      

			Next nK 
			                    
			//-- Seta conexใo base protheus.
			TCSETCONN(nHCONNPRD)           
			//-- Executa update sobre os registros importados.
			For nK := 1 to Len(aDICIONARIO)
				If aDICIONARIO[nK,01] == cTRIGGER
					cFIELD := aDICIONARIO[nK,04]+"X_SAG"
					cCAMPL := aDICIONARIO[nK,04]+"X_LSAG"
					cCONTL := DTOC(ddatabase)+"-"+SubSTR(Time(),1,5)
					cQuery := " UPDATE " + aDICIONARIO[nK,03] + " SET " + cFIELD + " = ' ', " + cCAMPL + " = '" + cCONTL + "' WHERE " + cFIELD + " != ' ' "
					TCSqlExec(cQuery)
				EndIf
			Next nK                      				
		
		End Transaction
		
	EndIf                             

	CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+" FIM - PROCESSO DE EXPORTACAO DE DADOS")

Return
	


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFOPENCON  บ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Fun็ใo para abertura de conex๕es com database.             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------*
Static Function FOPENCON(cDATABASE, cSERVER, nPORTOP)
*---------------------------------------------*
Local nCONN := TCLink(cDATABASE,cSERVER,nPORTOP)     

	If nCONN < 0
		conout(FUNNAME() + "- FALHA NA ABERTURA DA CONEXAO: "+cDATABASE+" SERVIDOR: "+cSERVER)
	EndIf

Return (nCONN)
                                                           
 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDEFDICINTบ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Defini็ใo das estruturas de tabelas, campos e indices,     บฑฑ
ฑฑบ          ณ database de integra็ใo.                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*---------------------------------------------*
Static Function FDEFDICINT(aDICIONARIO)
*---------------------------------------------*
Local cNAMEOBJ := STRING_NULL
Local cNAMETAB := STRING_NULL
Local cTYPETAB := STRING_NULL 
Local cAliasTMP := GetNextAlias()

    /*
    	Estrutura: aDICIONARIO
    	[1] - T=Tabela
	    	[2] - Nome
    		[3] - Campo
	    	[4] - Tipo
    		[5] - Tamanho                                                          
    		[6] - Decimal
    		[7] - Existe base protheus
    	[1] - I=Indice
    		[2]	- Nome
    		[3]	- Tabela
    		[4] - Campo
    */   
                     
    //-- Tabela: Empresas (SIGAMAT)
	aAdd ( aDICIONARIO, { cTABLE, "SIGAMAT"	, "M0_CODIGO"	, "C"	, 2							, 0					   		,.F.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SIGAMAT"	, "M0_CODFIL"	, "C"	, 2							, 0					   		,.F. 	} )	//C๓digo Filial
	aAdd ( aDICIONARIO, { cTABLE, "SIGAMAT"	, "M0_NOME"		, "C"	, 20						, 0					   		,.F. 	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SIGAMAT"	, "STATUS_INT"	, "C"	, 1							, 0					   		,.F. 	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SIGAMAT"	, "OPERACAO_INT", "C"	, 1							, 0							,.F. 	} )	//Opera็ใo		
	//-- Indice: I_MAT_01
	aAdd ( aDICIONARIO, { cINDEX, "I_MAT_01", "SIGAMAT", "M0_CODIGO"	} )
	aAdd ( aDICIONARIO, { cINDEX, "I_MAT_01", "SIGAMAT", "M0_CODFIL"	} )


    //-- Tabela: Centro de custos (CTTCMP)
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "CTT_CUSTO"	, "C"	, TAMSX3("CTT_CUSTO")[1]	, TAMSX3("CTT_CUSTO")[2]	, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "CTT_DESC01"	, "C"	, TAMSX3("CTT_DESC01")[1]	, TAMSX3("CTT_DESC01")[2]	, .T.	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "CTT_BLOQ"	, "C"	, TAMSX3("CTT_BLOQ")[1]		, TAMSX3("CTT_BLOQ")[2]		, .T.	} )	//Bloqueado
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "CTT_CLASSE"	, "N"	, 1	   						, 0  						, .F.	} )	//Grau
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "CTTCMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo
	//-- Indice: I_CTT_01
	aAdd ( aDICIONARIO, { cINDEX, "I_CTT_01", "CTTCMP", "CTT_CUSTO"	} )


    //-- Tabela: Plano de Contas (CT1CMP)
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "CT1_CONTA"	, "C"	, TAMSX3("CT1_CONTA")[1]	, TAMSX3("CT1_CONTA")[2]	, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "CT1_DESC01"	, "C"	, TAMSX3("CT1_DESC01")[1]	, TAMSX3("CT1_DESC01")[2]	, .T.	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "CT1_BLOQ"	, "C"	, TAMSX3("CT1_BLOQ")[1]		, TAMSX3("CT1_BLOQ")[2]		, .T.	} )	//Bloqueado	
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "CT1_CLASSE"	, "N"	, 1	   						, 0  						, .F.	} )	//Grau    
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "CT1CMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_CT1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_CT1_01", "CT1CMP", "CT1_CONTA"	} )


    //-- Tabela: Local de trabalho (CTDCMP)
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "CTD_ITEM"	, "C"	, TAMSX3("CTD_ITEM")[1]		, TAMSX3("CTD_ITEM")[2]		, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "CTD_DESC01"	, "C"	, TAMSX3("CTD_DESC01")[1]	, TAMSX3("CTD_DESC01")[2]	, .T.	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "CTD_BLOQ"	, "C"	, TAMSX3("CTD_BLOQ")[1]		, TAMSX3("CTD_BLOQ")[2]		, .T.	} )	//Bloqueado
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "CTD_X_CC"	, "C"	, TAMSX3("CTD_X_CC")[1]		, TAMSX3("CTD_X_CC")[2]		, .T.	} )	//Centro de Custo
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "CTD_CLASSE"	, "N"	, 1	   						, 0  						, .F.	} )	//Grau           	
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "CTDCMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_CT1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_CTD_01", "CTDCMP", "CTD_ITEM"	} )	 


    //-- Tabela: Produtos (SB1CMP)
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_COD"		, "C"	, TAMSX3("B1_COD")[1]  		, TAMSX3("B1_COD")[2]  		, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_DESC"		, "C"	, TAMSX3("B1_DESC")[1]		, TAMSX3("B1_DESC")[2] 		, .T.	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_UM"		, "C"	, TAMSX3("B1_UM")[1]   		, TAMSX3("B1_UM")[2]   		, .T.	} )	//Unidade (Ex: CX, UN)
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_CONTA"	, "C"	, TAMSX3("B1_CONTA")[1]		, TAMSX3("B1_CONTA")[2]		, .T.	} )	//Conta Gerencial/Contแbil
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_GRUPO"	, "C"	, TAMSX3("B1_GRUPO")[1]		, TAMSX3("B1_GRUPO")[2]		, .T.	} )	//Grupo
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_UREV"		, "C"	, TAMSX3("B1_UREV")[1] 		, TAMSX3("B1_UREV")[2] 		, .T.	} )	//Data de Cadastro
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_EMIN"		, "N"	, TAMSX3("B1_EMIN")[1]		, TAMSX3("B1_EMIN")[2] 		, .T.	} )	//Estoque Mํn.
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_EMAX"		, "N"	, TAMSX3("B1_EMAX")[1]		, TAMSX3("B1_EMAX")[2] 		, .T.	} )	//Estoque Mแx.
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_MSBLQL"	, "C"	, TAMSX3("B1_MSBLQL")[1]	, TAMSX3("B1_MSBLQL")[2] 	, .T.	} )	//Bloqueado
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_LOCPAD"	, "C"	, TAMSX3("B1_LOCPAD")[1]	, TAMSX3("B1_LOCPAD")[2] 	, .T.	} )	//Armazem
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "B1_SG1" 		, "C"	, 1	   						, 0  						, .F.	} )	//Produto Composto
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SB1CMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SB1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SB1_01", "SB1CMP", "B1_COD"	} )
	                                                                                                     

    //-- Tabela: Grupo produtos (SBMCMP)
	aAdd ( aDICIONARIO, { cTABLE, "SBMCMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SBMCMP"	, "BM_GRUPO"	, "C"	, TAMSX3("BM_GRUPO")[1]		, TAMSX3("BM_GRUPO")[2]		, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SBMCMP"	, "BM_DESC"		, "C"	, TAMSX3("BM_DESC")[1]		, TAMSX3("BM_DESC")[2] 		, .T.	} )	//Descri็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SBMCMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SBMCMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SBM_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SBM_01", "SBMCMP", "BM_COD"	} )	 

	
    //-- Tabela: Clientes (SA1CMP)
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_COD"		, "C"	, TAMSX3("A1_COD")[1]  		, TAMSX3("A1_COD")[2]		, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_LOJA"		, "C"	, TAMSX3("A1_LOJA")[1] 		, TAMSX3("A1_LOJA")[2] 		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_PESSOA"	, "C"	, TAMSX3("A1_PESSOA")[1]	, TAMSX3("A1_PESSOA")[2]	, .T.	} )	//Tipo (F / J)
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_NOME"		, "C"	, TAMSX3("A1_NOME")[1] 		, TAMSX3("A1_NOME")[2]		, .T.	} )	//Razใo Social
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_NREDUZ"	, "C"	, TAMSX3("A1_NREDUZ")[1]	, TAMSX3("A1_NREDUZ")[2]	, .T.	} )	//Nome Fantasia
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_CGC" 		, "C"	, TAMSX3("A1_CGC")[1]		, TAMSX3("A1_CGC")[2]  		, .T.	} )	//CPF/CNPJ
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_EST" 		, "C"	, TAMSX3("A1_EST")[1]		, TAMSX3("A1_EST")[2]  		, .T.	} )	//UF	
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_INSCR" 	, "C"	, TAMSX3("A1_INSCR")[1]		, TAMSX3("A1_INSCR")[2]		, .T.	} )	//IE
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_PFISICA"	, "C"	, TAMSX3("A1_PFISICA")[1]	, TAMSX3("A1_PFISICA")[2]	, .T.	} )	//RG
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_DTCADAS"	, "C"	, TAMSX3("A1_DTCADAS")[1]	, TAMSX3("A1_DTCADAS")[2]	, .T.	} )	//Data de Cadastro
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_END"		, "C"	, TAMSX3("A1_END")[1]		, TAMSX3("A1_END")[2]		, .T.	} )	//End. Logradouro
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_COMPLEM"	, "C"	, TAMSX3("A1_COMPLEM")[1]	, TAMSX3("A1_COMPLEM")[2]	, .T.	} )	//End. Complemento
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_BAIRRO"	, "C"	, TAMSX3("A1_BAIRRO")[1]	, TAMSX3("A1_BAIRRO")[2]	, .T.	} )	//End. Bairro
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_COD_MUN"	, "C"	, TAMSX3("A1_COD_MUN")[1]	, TAMSX3("A1_COD_MUN")[2]	, .T.	} )	//End. Cidade
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_CEP"		, "C"	, TAMSX3("A1_CEP")[1]  		, TAMSX3("A1_CEP")[2]  		, .T.	} )	//End. CEP
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_TEL" 		, "C"	, TAMSX3("A1_TEL")[1]  		, TAMSX3("A1_TEL")[2]  		, .T.	} )	//Telefone (1)
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_FAX"		, "C"	, TAMSX3("A1_FAX")[1]  		, TAMSX3("A1_FAX")[2]  		, .T.	} )	//Telefone (2)
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_EMAIL"	, "C"	, TAMSX3("A1_EMAIL")[1]		, TAMSX3("A1_EMAIL")[2]		, .T.	} )	//Email   
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "A1_MSBLQL"	, "C"	, TAMSX3("A1_MSBLQL")[1]	, TAMSX3("A1_MSBLQL")[2]	, .T.	} )	//Bloqueado 
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SA1CMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SA1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SA1_01", "SA1CMP", "A1_COD"	} )	
	aAdd ( aDICIONARIO, { cINDEX, "I_SA1_01", "SA1CMP", "A1_LOJA"	} )	

    //-- Tabela: Fornecedores (SA2CMP)
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_COD"		, "C"	, TAMSX3("A2_COD")[1] 		, TAMSX3("A2_COD")[2]  		, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_LOJA"		, "C"	, TAMSX3("A2_LOJA")[1]		, TAMSX3("A2_LOJA")[2] 		, .T.	} )	//C๓digo de Integra็ใo	
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_TIPO"		, "C"	, TAMSX3("A2_TIPO")[1]		, TAMSX3("A2_TIPO")[2]		, .T.	} )	//Tipo (F / J)
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_NOME"		, "C"	, TAMSX3("A2_NOME")[1] 		, TAMSX3("A2_NOME")[2]		, .T.	} )	//Razใo Social
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_NREDUZ"	, "C"	, TAMSX3("A2_NREDUZ")[1]	, TAMSX3("A2_NREDUZ")[2]	, .T.	} )	//Nome Fantasia
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_CGC" 		, "C"	, TAMSX3("A2_CGC")[1]  		, TAMSX3("A2_CGC")[2]		, .T.	} )	//CPF/CNPJ
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_EST" 		, "C"	, TAMSX3("A2_EST")[1]  		, TAMSX3("A2_EST")[2]		, .T.	} )	//UF	
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_INSCR" 	, "C"	, TAMSX3("A2_INSCR")[1]		, TAMSX3("A2_INSCR")[2]		, .T.	} )	//IE
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_PFISICA"	, "C"	, TAMSX3("A2_PFISICA")[1]	, TAMSX3("A2_PFISICA")[2]	, .T.	} )	//RG  	
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_PRICOM"	, "C"	, TAMSX3("A2_PRICOM")[1]	, TAMSX3("A2_PRICOM")[2]	, .T.	} )	//Data de Cadastro
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_END"		, "C"	, TAMSX3("A2_END")[1]  		, TAMSX3("A2_END")[2]		, .T.	} )	//End. Logradouro
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_COMPLEM"	, "C"	, TAMSX3("A2_COMPLEM")[1]	, TAMSX3("A2_COMPLEM")[2]	, .T.	} )	//End. Complemento
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_BAIRRO"	, "C"	, TAMSX3("A2_BAIRRO")[1]	, TAMSX3("A2_BAIRRO")[2]	, .T.	} )	//End. Bairro
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_COD_MUN"	, "C"	, TAMSX3("A2_COD_MUN")[1]	, TAMSX3("A2_COD_MUN")[2]	, .T.	} )	//End. Cidade
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_CEP"		, "C"	, TAMSX3("A2_CEP")[1]  		, TAMSX3("A2_CEP")[2]  		, .T.	} )	//End. CEP
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_TEL" 		, "C"	, TAMSX3("A2_TEL")[1]  		, TAMSX3("A2_TEL")[2]  		, .T.	} )	//Telefone (1)
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_FAX"		, "C"	, TAMSX3("A2_FAX")[1]  		, TAMSX3("A2_FAX")[2] 		, .T.	} )	//Telefone (2)
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_EMAIL"	, "C"	, TAMSX3("A2_EMAIL")[1]		, TAMSX3("A2_EMAIL")[2]		, .T.	} )	//Email   
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "A2_MSBLQL"	, "C"	, TAMSX3("A2_MSBLQL")[1]	, TAMSX3("A2_MSBLQL")[2]	, .T.	} )	//Bloqueado 
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SA2CMP"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SA2_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SA2_01", "SA2CMP", "A2_COD"	} )	  
	aAdd ( aDICIONARIO, { cINDEX, "I_SA2_01", "SA2CMP", "A2_LOJA"	} )	
	
    //-- Tabela: Notas de Entrada (SF1010)
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_FILIAL"	, "C"	, TAMSX3("F1_FILIAL")[1]	, TAMSX3("F1_FILIAL")[2]	, .T.	} )	//Filial
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_FORNECE"	, "C"	, TAMSX3("F1_FORNECE")[1]	, TAMSX3("F1_FORNECE")[2]	, .T.	} )	//Fornecedor
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_LOJA"		, "C"	, TAMSX3("F1_LOJA")[1] 		, TAMSX3("F1_LOJA")[2] 		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_ESPECIE"	, "C"	, TAMSX3("F1_ESPECIE")[1]	, TAMSX3("F1_ESPECIE")[2]	, .T.	} )	//Esp้cie
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_SERIE"	, "C"	, TAMSX3("F1_SERIE")[1]		, TAMSX3("F1_SERIE")[2]		, .T.	} )	//S้rie da NF
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_DOC" 		, "C"	, TAMSX3("F1_DOC")[1]  		, TAMSX3("F1_DOC")[2]		, .T.	} )	//N๚mero da NF
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_TIPO" 	, "C"	, TAMSX3("F1_TIPO")[1] 		, TAMSX3("F1_TIPO")[2] 		, .T.	} )	//Natureza
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_EMISSAO"	, "C"	, TAMSX3("F1_EMISSAO")[1]	, TAMSX3("F1_EMISSAO")[2]	, .T.	} )	//Data de Emissใo 	
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_DTDIGIT"	, "C"	, TAMSX3("F1_DTDIGIT")[1]	, TAMSX3("F1_DTDIGIT")[2]	, .T.	} )	//Data Digita็ใo  	
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_PLACA"	, "C"	, TAMSX3("F1_PLACA")[1]		, TAMSX3("F1_PLACA")[2]		, .T.	} )	//Placa do Transporte
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_VALMERC"	, "N"	, TAMSX3("F1_VALMERC")[1]	, TAMSX3("F1_VALMERC")[2]	, .T.	} )	//Valor dos Produtos
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_FRETE"	, "N"	, TAMSX3("F1_FRETE")[1]		, TAMSX3("F1_FRETE")[2]		, .T.	} )	//Valor do Frete
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_DESCONT"	, "N"	, TAMSX3("F1_DESCONT")[1]	, TAMSX3("F1_DESCONT")[2]	, .T.	} )	//Valor do Desconto
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_DESPESA"	, "N"	, TAMSX3("F1_DESPESA")[1]	, TAMSX3("F1_DESPESA")[2]	, .T.	} )	//Valor Outros
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_BASEICM"	, "N"	, TAMSX3("F1_BASEICM")[1]	, TAMSX3("F1_BASEICM")[2]	, .T.	} )	//Base ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_VALICM"	, "N"	, TAMSX3("F1_VALICM")[1]	, TAMSX3("F1_VALICM")[2]	, .T.	} )	//Valor ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_BASEIPI"	, "N"	, TAMSX3("F1_BASEIPI")[1]	, TAMSX3("F1_BASEIPI")[2]	, .T.	} )	//Base IPI
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_VALIPI"	, "N"	, TAMSX3("F1_VALIPI")[1]	, TAMSX3("F1_VALIPI")[2]	, .T.	} )	//Valor IPI
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_BRICMS"	, "N"	, TAMSX3("F1_BRICMS")[1]	, TAMSX3("F1_BRICMS")[2]	, .T.	} )	//Base ICMSST
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "F1_ICMSRET"	, "N"	, TAMSX3("F1_ICMSRET")[1]	, TAMSX3("F1_ICMSRET")[2]	, .T.	} )	//Valor ICMSST
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SF1010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SF1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SF1_01", "SF1010", "R_E_C_N_O_"	} )		    
	
    //-- Tabela: Rateios contabeis (SDE010)
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_FILIAL"	, "C"	, TAMSX3("DE_FILIAL")[1]	, TAMSX3("DE_FILIAL")[2]	, .T.	} )	//Filial
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_DOC"		, "C"	, TAMSX3("DE_DOC")[1]  		, TAMSX3("DE_DOC")[2]  		, .T.	} )	//Documento
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_SERIE" 	, "C"	, TAMSX3("DE_SERIE")[1]		, TAMSX3("DE_SERIE")[2]		, .T.	} )	//Serie
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_FORNECE"	, "C"	, TAMSX3("DE_FORNECE")[1]	, TAMSX3("DE_FORNECE")[2]	, .T.	} )	//Fornecedor
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_LOJA" 	, "C"	, TAMSX3("DE_LOJA")[1]		, TAMSX3("DE_LOJA")[2]		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_ITEMNF" 	, "C"	, TAMSX3("DE_ITEMNF")[1]	, TAMSX3("DE_ITEMNF")[2]	, .T.	} )	//Item NF
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_ITEM" 	, "C"	, TAMSX3("DE_ITEM")[1]		, TAMSX3("DE_ITEM")[2]		, .T.	} )	//Item
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_CC"	 	, "C"	, TAMSX3("DE_CC")[1]		, TAMSX3("DE_CC")[2]		, .T.	} )	//Centro custo
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_CONTA" 	, "C"	, TAMSX3("DE_CONTA")[1]		, TAMSX3("DE_CONTA")[2]		, .T.	} )	//Conta contabil
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_ITEMCTA" 	, "C"	, TAMSX3("DE_ITEMCTA")[1]	, TAMSX3("DE_ITEMCTA")[2]	, .T.	} )	//Item contabil
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_CLVL" 	, "C"	, TAMSX3("DE_CLVL")[1]		, TAMSX3("DE_CLVL")[2]		, .T.	} )	//Classe valor
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_PERC"		, "N"	, TAMSX3("DE_PERC")[1] 		, TAMSX3("DE_PERC")[2]		, .T.	} )	//Percentual
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "DE_CUSTO1"	, "N"	, TAMSX3("DE_CUSTO1")[1]	, TAMSX3("DE_CUSTO1")[2]	, .T.	} )	//Custo1
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SDE010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo		
	//-- Indice: I_SDE_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SDE_01", "SDE010", "R_E_C_N_O_"	} )	 
	
    
    //-- Tabela: Itens Notas de Entrada (SD1010)
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_FILIAL"	, "C"	, TAMSX3("D1_FILIAL")[1]	, TAMSX3("D1_FILIAL")[2]	, .T.	} )	//Filial
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_FORNECE"	, "C"	, TAMSX3("D1_FORNECE")[1]	, TAMSX3("D1_FORNECE")[2]	, .T.	} )	//Fornecedor
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_LOJA"		, "C"	, TAMSX3("D1_LOJA")[1] 		, TAMSX3("D1_LOJA")[2]		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_DOC"		, "C"	, TAMSX3("D1_DOC")[1]  		, TAMSX3("D1_DOC")[2]  		, .T.	} )	//Documento
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_SERIE"	, "C"	, TAMSX3("D1_SERIE")[1]		, TAMSX3("D1_SERIE")[2]		, .T.	} )	//Serie				
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_ITEM"		, "C"	, TAMSX3("D1_ITEM")[1]  	, TAMSX3("D1_ITEM")[2]	 	, .T.	} )	//Item 
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_COD"		, "C"	, TAMSX3("D1_COD")[1]  		, TAMSX3("D1_COD")[2]		, .T.	} )	//Produto					
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_UM"		, "C"	, TAMSX3("D1_UM")[1]   		, TAMSX3("D1_UM")[2]		, .T.	} )	//Unidade
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_CF" 		, "C"	, TAMSX3("D1_CF")[1]   		, TAMSX3("D1_CF")[2]   		, .T.	} )	//CFOP
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_CLASFIS"	, "C"	, TAMSX3("D1_CLASFIS")[1]	, TAMSX3("D1_CLASFIS")[2]	, .T.	} )	//CST
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_QUANT"	, "N"	, TAMSX3("D1_QUANT")[1]		, TAMSX3("D1_QUANT")[2]		, .T.	} )	//Quantidade NF
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_TOTAL" 	, "N"	, TAMSX3("D1_TOTAL")[1]		, TAMSX3("D1_TOTAL")[2]		, .T.	} )	//Valor
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_VALDESC"	, "N"	, TAMSX3("D1_VALDESC")[1] 	, TAMSX3("D1_VALDESC")[2]	, .T.	} )	//Desconto
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_BASEICM"	, "N"	, TAMSX3("D1_BASEICM")[1]	, TAMSX3("D1_BASEICM")[2]	, .T.	} )	//Base ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_PICM"		, "N"	, TAMSX3("D1_PICM")[1] 		, TAMSX3("D1_PICM")[2]		, .T.	} )	//Aliq. ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_VALICM"	, "N"	, TAMSX3("D1_VALICM")[1]	, TAMSX3("D1_VALICM")[2]	, .T.	} )	//Valor ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_BRICMS"	, "N"	, TAMSX3("D1_BRICMS")[1]	, TAMSX3("D1_BRICMS")[2]	, .T.	} )	//Base ICMS ST
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_ICMSRET"	, "N"	, TAMSX3("D1_ICMSRET")[1]	, TAMSX3("D1_ICMSRET")[2]	, .T.	} )	//Valor ICMS ST
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_BASEIPI"	, "N"	, TAMSX3("D1_BASEIPI")[1]	, TAMSX3("D1_BASEIPI")[2]	, .T.	} )	//Base IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_IPI"		, "N"	, TAMSX3("D1_IPI")[1]		, TAMSX3("D1_IPI")[2]		, .T.	} )	//Aliq. IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_VALIPI"	, "N"	, TAMSX3("D1_VALIPI")[1]	, TAMSX3("D1_VALIPI")[2]	, .T.	} )	//Valor IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_DESPESA"	, "N"	, TAMSX3("D1_DESPESA")[1]	, TAMSX3("D1_DESPESA")[2]	, .T.	} )	//Valor Outros
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_CONTA"	, "C"	, TAMSX3("D1_CONTA")[1]		, TAMSX3("D1_CONTA")[2]		, .T.	} )	//Conta Gerencial
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_CC" 		, "C"	, TAMSX3("D1_CC")[1]  		, TAMSX3("D1_CC")[2]   		, .T.	} )	//Centro de Custo
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_CUSTO"  	, "N"	, TAMSX3("D1_CUSTO")[1]  	, TAMSX3("D1_CUSTO")[2] 	, .T.	} )	//Custo
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_ITEMCTA"  , "C"	, TAMSX3("D1_ITEMCTA")[1]  	, TAMSX3("D1_ITEMCTA")[2] 	, .T.	} )	//Item contabil
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "D1_ESTOQUE"  , "C"	, 1						  	, 0						 	, .F.	} )	//Movimento Estoque
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	aAdd ( aDICIONARIO, { cTABLE, "SD1010"	, "ERROMENS_INT", "C"	, 250  						, 0  						, .F.	} )	//Opera็ใo	

	//-- Indice: I_SD1_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SD1_01", "SD1010", "R_E_C_N_O_"	} )		
	

	
    //-- Tabela: Lan็amentos contแbeis (CT2010)
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_DATA"	, "C"	, TAMSX3("CT2_DATA")[1]		, TAMSX3("CT2_DATA")[2]		, .T.	} )	//Data
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_LOTE"	, "C"	, TAMSX3("CT2_LOTE")[1]   	, TAMSX3("CT2_LOTE")[2]		, .T.	} )	//N๚mero do lote
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_SBLOTE"	, "C"	, TAMSX3("CT2_SBLOTE")[1]  	, TAMSX3("CT2_SBLOTE")[2]	, .T.	} )	//N๚mero do SubLote
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_DOC"		, "C"	, TAMSX3("CT2_DOC")[1] 		, TAMSX3("CT2_DOC")[2]		, .T.	} )	//N๚mero do documento
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_MOEDLC"	, "C"	, TAMSX3("CT2_MOEDLC")[1] 	, TAMSX3("CT2_MOEDLC")[2]	, .T.	} )	//Moeda Lancamento
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_HIST"	, "C"	, TAMSX3("CT2_HIST")[1] 	, TAMSX3("CT2_HIST")[2]		, .T.	} )	//Historico
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_DEBITO"	, "C"	, TAMSX3("CT2_DEBITO")[1]	, TAMSX3("CT2_DEBITO")[2]	, .T.	} )	//Cta Debito  
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_CREDIT"	, "C"	, TAMSX3("CT2_CREDIT")[1]	, TAMSX3("CT2_CREDIT")[2]	, .T.	} )	//Cta Credito
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_CCD"		, "C"	, TAMSX3("CT2_CCD")[1] 		, TAMSX3("CT2_CCD")[2]		, .T.	} )	//C Custo Deb 
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_CCC"		, "C"	, TAMSX3("CT2_CCC")[1] 		, TAMSX3("CT2_CCC")[2] 		, .T.	} )	//C Custo Cred
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_ITEMD"	, "C"	, TAMSX3("CT2_ITEMD")[1]	, TAMSX3("CT2_ITEMD")[2]	, .T.	} )	//C Trabalho D
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_ITEMC"	, "C"	, TAMSX3("CT2_ITEMC")[1]	, TAMSX3("CT2_ITEMC")[2]	, .T.	} )	//C Trabalho C
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_CLVLDB"	, "C"	, TAMSX3("CT2_CLVLDB")[1]	, TAMSX3("CT2_CLVLDB")[2]	, .T.	} )	//Segmento Deb
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_CLVLCR"	, "C"	, TAMSX3("CT2_CLVLCR")[1]	, TAMSX3("CT2_CLVLCR")[2]	, .T.	} )	//Segmento Cre
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "CT2_VALOR"	, "N"	, TAMSX3("CT2_VALOR")[1]	, TAMSX3("CT2_VALOR")[2]	, .T.	} )	//Valor		
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "CT2010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SRD_01
	aAdd ( aDICIONARIO, { cINDEX, "I_CT2_01", "CT2010", "R_E_C_N_O_"	} )	 
	
	
    //-- Tabela: Notas de Saํda (SF2010)
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_FILIAL"	, "C"	, TAMSX3("F2_FILIAL")[1]	, TAMSX3("F2_FILIAL")[2]	, .T.	} )	//Filial
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_CLIENTE"	, "C"	, TAMSX3("F2_CLIENTE")[1]	, TAMSX3("F2_CLIENTE")[2]	, .T.	} )	//Cliente
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_LOJA"		, "C"	, TAMSX3("F2_LOJA")[1]		, TAMSX3("F2_LOJA")[2] 		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_ESPECIE"	, "C"	, TAMSX3("F2_ESPECIE")[1]	, TAMSX3("F2_ESPECIE")[2]	, .T.	} )	//Esp้cie
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_SERIE"	, "C"	, TAMSX3("F2_SERIE")[1]		, TAMSX3("F2_SERIE")[2]		, .T.	} )	//S้rie da NF
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_DOC" 		, "C"	, TAMSX3("F2_DOC")[1] 		, TAMSX3("F2_DOC")[2]  		, .T.	} )	//N๚mero da NF
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_TIPO" 	, "C"	, TAMSX3("F2_TIPO")[1] 		, TAMSX3("F2_TIPO")[2]		, .T.	} )	//Natureza
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_EMISSAO"	, "C"	, TAMSX3("F2_EMISSAO")[1]	, TAMSX3("F2_EMISSAO")[2]	, .T.	} )	//Data de Emissใo 	
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_PLACA"	, "C"	, TAMSX3("F2_PLACA")[1]		, TAMSX3("F2_PLACA")[2]		, .T.	} )	//Placa do Transporte
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_VALMERC"	, "N"	, TAMSX3("F2_VALMERC")[1]	, TAMSX3("F2_VALMERC")[2]	, .T.	} )	//Valor dos Produtos
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_FRETE"	, "N"	, TAMSX3("F2_FRETE")[1]		, TAMSX3("F2_FRETE")[2]		, .T.	} )	//Valor do Frete
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_DESCONT"	, "N"	, TAMSX3("F2_DESCONT")[1]	, TAMSX3("F2_DESCONT")[2]	, .T.	} )	//Valor do Desconto
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_DESPESA"	, "N"	, TAMSX3("F2_DESPESA")[1]	, TAMSX3("F2_DESPESA")[2]	, .T.	} )	//Valor Outros
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_BASEICM"	, "N"	, TAMSX3("F2_BASEICM")[1]	, TAMSX3("F2_BASEICM")[2]	, .T.	} )	//Base ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_VALICM"	, "N"	, TAMSX3("F2_VALICM")[1]	, TAMSX3("F2_VALICM")[2]	, .T.	} )	//Valor ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_BASEIPI"	, "N"	, TAMSX3("F2_BASEIPI")[1]	, TAMSX3("F2_BASEIPI")[2]	, .T.	} )	//Base IPI
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_VALIPI"	, "N"	, TAMSX3("F2_VALIPI")[1]	, TAMSX3("F2_VALIPI")[2]	, .T.	} )	//Valor IPI
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_BRICMS"	, "N"	, TAMSX3("F2_BRICMS")[1]	, TAMSX3("F2_BRICMS")[2]	, .T.	} )	//Base ICMSST
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "F2_ICMSRET"	, "N"	, TAMSX3("F2_ICMSRET")[1]	, TAMSX3("F2_ICMSRET")[2]	, .T.	} )	//Valor ICMSST
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SF2010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SF2_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SF2_01", "SF1010", "R_E_C_N_O_"	} )		    
	
    
    //-- Tabela: Itens Notas de Saํda (SD2010)
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_FILIAL"	, "C"	, TAMSX3("F2_FILIAL")[1]	, TAMSX3("F2_FILIAL")[2]	, .T.	} )	//Filial
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CLIENTE"	, "C"	, TAMSX3("F2_CLIENTE")[1]	, TAMSX3("F2_CLIENTE")[2]	, .T.	} )	//Fornecedor
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_LOJA"		, "C"	, TAMSX3("D2_LOJA")[1] 		, TAMSX3("D2_LOJA")[2]		, .T.	} )	//Loja
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_SERIE"	, "C"	, TAMSX3("F2_SERIE")[1]		, TAMSX3("F2_SERIE")[2]		, .T.	} )	//S้rie da NF
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_DOC" 		, "C"	, TAMSX3("F2_DOC")[1] 		, TAMSX3("F2_DOC")[2]  		, .T.	} )	//N๚mero da NF
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_COD"		, "C"	, TAMSX3("D2_COD")[1]  		, TAMSX3("D2_COD")[2]  		, .T.	} )	//Produto
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_UM"		, "C"	, TAMSX3("D2_UM")[1]  		, TAMSX3("D2_UM")[2]   		, .T.	} )	//Unidade
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CF" 		, "C"	, TAMSX3("D2_CF")[1]   		, TAMSX3("D2_CF")[2]  		, .T.	} )	//CFOP
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CLASFIS"	, "C"	, TAMSX3("D2_CLASFIS")[1]	, TAMSX3("D2_CLASFIS")[2]	, .T.	} )	//CST
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_QUANT"	, "N"	, TAMSX3("D2_QUANT")[1]		, TAMSX3("D2_QUANT")[2]		, .T.	} )	//Quantidade NF
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_TOTAL" 	, "N"	, TAMSX3("D2_TOTAL")[1]		, TAMSX3("D2_TOTAL")[2]		, .T.	} )	//Valor
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_DESCON"	, "C"	, TAMSX3("D2_DESCON")[1]	, TAMSX3("D2_DESCON")[2]	, .T.	} )	//Desconto
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_BASEICM"	, "N"	, TAMSX3("D2_BASEICM")[1]	, TAMSX3("D2_BASEICM")[2]	, .T.	} )	//Base ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_PICM"		, "N"	, TAMSX3("D2_PICM")[1]		, TAMSX3("D2_PICM")[2] 		, .T.	} )	//Aliq. ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_VALICM"	, "N"	, TAMSX3("D2_VALICM")[1]	, TAMSX3("D2_VALICM")[2]	, .T.	} )	//Valor ICMS
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_BRICMS"	, "N"	, TAMSX3("D2_BRICMS")[1]	, TAMSX3("D2_BRICMS")[2]	, .T.	} )	//Base ICMS ST
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_ICMSRET"	, "N"	, TAMSX3("D2_ICMSRET")[1]	, TAMSX3("D2_ICMSRET")[2]	, .T.	} )	//Valor ICMS ST
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_BASEIPI"	, "N"	, TAMSX3("D2_BASEIPI")[1]	, TAMSX3("D2_BASEIPI")[2]	, .T.	} )	//Base IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_IPI"		, "N"	, TAMSX3("D2_IPI")[1] 		, TAMSX3("D2_IPI")[2]  		, .T.	} )	//Aliq. IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_VALIPI"	, "N"	, TAMSX3("D2_VALIPI")[1]	, TAMSX3("D2_VALIPI")[2]	, .T.	} )	//Valor IPI
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_DESPESA"	, "N"	, TAMSX3("D2_DESPESA")[1]	, TAMSX3("D2_DESPESA")[2]	, .T.	} )	//Valor Outros
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CONTA"	, "C"	, TAMSX3("D2_CONTA")[1]		, TAMSX3("D2_CONTA")[2]		, .T.	} )	//Conta Gerencial
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CCUSTO"	, "C"	, TAMSX3("D2_CCUSTO")[1]	, TAMSX3("D2_CCUSTO")[2]	, .T.	} )	//Centro de Custo 
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_ITEMCC"   , "C"	, TAMSX3("D2_ITEMCC")[1]  	, TAMSX3("D2_ITEMCC")[2] 	, .T.	} )	//Item contabil
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_CUSTO1"	, "N"	, TAMSX3("D2_CUSTO1")[1]	, TAMSX3("D2_CUSTO1")[2]	, .T.	} )	//Custo
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "D2_ESTOQUE"  , "C"	, 1						  	, 0						 	, .F.	} )	//Movimento Estoque
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SD2010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SD2_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SD2_01", "SD2010", "R_E_C_N_O_"	} )	
	                                                                           
	
    //-- Tabela: Movimento interno (SD3010)
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "R_E_C_N_O_"	, "N"	, 12						, 0  						, .T.	} )	//C๓digo de Integra็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_COD"		, "C"	, TAMSX3("D3_COD")[1]  		, TAMSX3("D3_COD")[2]  		, .T.	} )	//Produto
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_UM"		, "C"	, TAMSX3("D3_UM")[1]   		, TAMSX3("D3_UM")[2]   		, .T.	} )	//Unidade
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_TM" 		, "C"	, TAMSX3("D3_TM")[1]   		, TAMSX3("D3_TM")[2]   		, .T.	} )	//Tipo Movimenta็ใo
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_CONTA"	, "C"	, TAMSX3("D3_CONTA")[1]		, TAMSX3("D3_CONTA")[2]		, .T.	} )	//Conta
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_OP"   	, "C"	, TAMSX3("D3_OP")[1]		, TAMSX3("D3_OP")[2]   		, .T.	} )	//Conta
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_QUANT"	, "N"	, TAMSX3("D3_QUANT")[1]		, TAMSX3("D3_QUANT")[2]		, .T.	} )	//Quantidade NF
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_CUSTO1" 	, "N"	, TAMSX3("D3_CUSTO1")[1]	, TAMSX3("D3_CUSTO1")[2]	, .T.	} )	//Valor
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_LOCAL" 	, "C"	, TAMSX3("D3_LOCAL")[1]		, TAMSX3("D3_LOCAL")[2]		, .T.	} )	//Armazem 
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_DOC"	 	, "C"	, TAMSX3("D3_DOC")[1]  		, TAMSX3("D3_DOC")[2]  		, .T.	} )	//Documento
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_EMISSAO" 	, "C"	, TAMSX3("D3_EMISSAO")[1]	, TAMSX3("D3_EMISSAO")[2]	, .T.	} )	//Emissใo 
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_CLVL" 	, "C"	, TAMSX3("D3_CLVL")[1] 		, TAMSX3("D3_CLVL")[2] 		, .T.	} )	//Segmento
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_ITEMCTA" 	, "C"	, TAMSX3("D3_ITEMCTA")[1]	, TAMSX3("D3_ITEMCTA")[2]	, .T.	} )	//Local Trabalho
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "D3_CC"   	, "C"	, TAMSX3("D3_CC")[1]		, TAMSX3("D3_CC")[2]   		, .T.	} )	//Centro de custo
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "STATUS_INT"	, "C"	, 1	   						, 0  						, .F.	} )	//Status
	aAdd ( aDICIONARIO, { cTABLE, "SD3010"	, "OPERACAO_INT", "C"	, 1	   						, 0  						, .F.	} )	//Opera็ใo	
	//-- Indice: I_SD3_01
	aAdd ( aDICIONARIO, { cINDEX, "I_SD3_01", "SD3010", "R_E_C_N_O_"	} )	  
	
	
	//-- Montagem comandos DDL
	If Len(aDICIONARIO) > 0
		cCOMMAND := STRING_NULL
		For nI := 1 to Len(aDICIONARIO)
			
			If cNAMEOBJ == STRING_NULL
				cNAMEOBJ := aDICIONARIO[nI,02]
			EndIf        
			
			If cNAMEOBJ != aDICIONARIO[nI,02]
				
				//-- Consulta existencia do objeto no database.
				cQuery := "	SELECT COUNT(*) NUMREG                  " + hENTER
				cQuery += "	FROM ALL_OBJECTS						" + hENTER
				cQuery += "	WHERE OWNER 	= '"+cOWNINT +"'		" + hENTER
				cQuery += "	AND OBJECT_NAME = '"+cNAMEOBJ+"'		" + hENTER
				cQuery += "	AND OBJECT_TYPE = 'TABLE'	 			" + hENTER
			
				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())
				nNUMREG := (cAliasTMP)->NUMREG
				(cAliasTMP)->(dbCloseArea())
				
				//-- Nใo existe o objeto no database.
				If nNUMREG == 0
					cCOMMAND := SubSTR(cCOMMAND,1,Len(cCOMMAND)-1)
					If cTYPETAB == cTABLE
				   		cCOMMAND := "CREATE TABLE " + cOWNINT + "." + cNAMEOBJ + " (" + cCOMMAND + ")
					Else
						cCOMMAND := "CREATE INDEX " + cOWNINT + "." + cNAMEOBJ + " ON " + cOWNINT + "." + cNAMETAB + " (" + cCOMMAND + ")
					EndIf
					//-- Executa comando de cria็ใo das tabelas no database.
					TCSqlExec(cCOMMAND)
				EndIf
				
				cCOMMAND := STRING_NULL				
			EndIf        
			
			If aDICIONARIO[nI,01] == cTABLE
				If aDICIONARIO[nI,04] == "C"
					cTYPE := " VARCHAR2("+cValToChar(aDICIONARIO[nI,05])+") DEFAULT '"+Space(aDICIONARIO[nI,05])+"' NOT NULL ENABLE,"
				Else				
					cTYPE := " NUMBER DEFAULT 0.0 NOT NULL ENABLE,"
				EndIf	
				cCOMMAND += aDICIONARIO[nI,03] + cTYPE
			Else
				cCOMMAND += aDICIONARIO[nI,04] + ","
			EndIf				
			
			cTYPETAB := aDICIONARIO[nI,01]
			cNAMEOBJ := aDICIONARIO[nI,02]
			cNAMETAB := aDICIONARIO[nI,03]
			
		Next nI 

	EndIf


Return

       
 
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDEFDICPRDบ Autor ณ Rafael Parma       บ Data ณ  10/03/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Defini็ใo das estruturas de campos e triggers, database    บฑฑ
ฑฑบ          ณ protheus.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
*-------------------------------------------*
Static Function FDEFDICPRD(aDICIONARIO)
*-------------------------------------------*
Local aFIELDS := {}
Local aSTRUCT := {}
Local aARQUPD := {}
Local nI      := 0
Local nJ      := 0
Local lSX3	  := .F.
Local cTexto  := STRING_NULL
Local cAlias  := STRING_NULL
Local cOrdem  := STRING_NULL
Local cLSTRG  := STRING_NULL
Local cAliasTMP := GetNextAlias()

	//-- Monta array com campos do dicionแrio.
	aSTRUCT := {"X3_ARQUIVO","X3_ORDEM","X3_CAMPO","X3_TIPO","X3_TAMANHO","X3_DECIMAL","X3_TITULO" ,"X3_TITSPA"  ,"X3_TITENG", "X3_DESCRIC","X3_DESCSPA","X3_DESCENG","X3_PICTURE","X3_VALID","X3_USADO","X3_RELACAO","X3_F3","X3_NIVEL","X3_RESERV","X3_CHECK","X3_TRIGGER","X3_PROPRI","X3_BROWSE","X3_VISUAL","X3_CONTEXT","X3_OBRIGAT","X3_VLDUSER","X3_CBOX","X3_CBOXSPA","X3_CBOXENG","X3_PICTVAR","X3_WHEN","X3_INIBRW","X3_GRPSXG","X3_FOLDER","X3_PYME","X3_CONDSQL","X3_CHKSQL","X3_IDXSRV","X3_ORTOGRA","X3_IDXFLD","X3_TELA"}
	aAdd(aFIELDS, {"CT1","01", "CT1_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"CT2","01", "CT2_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"CTD","01", "CTD_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"CTT","01", "CTT_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SB1","01", "B1_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SBM","01", "BM_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})	
	aAdd(aFIELDS, {"SA1","01", "A1_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SA2","01", "A2_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SF1","01", "F1_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SD1","01", "D1_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SDE","01", "DE_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SF2","01", "F2_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SD2","01", "D2_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SD3","01", "D3_X_SAG"	,"C" ,  1, 0 ,"Exp. SAG","Exp. SAG","Exp. SAG","Exportar SAG", "Exportar SAG", "Exportar SAG", "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SD3","01", "D3_X_KSAG"	,"N" , 12, 0 ,"Chave SAG","Chave SAG","Chave SAG","Chave SAG", "Chave SAG", "Chave SAG", 	   "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	aAdd(aFIELDS, {"SD3","01", "D3_X_OPSAG"	,"C" , 20, 0 ,"OP SAG","OP SAG","OP SAG","OP SAG", "OP SAG", "OP SAG",						   "@!",""        ,"€€€€€€€€€€€€€€ ",""			,""	     ,0			,"þA"	,""		   ,""			,"U"		,"N"		,"V"		,"R"			 ,""		   ,""			,""		  ,""		   ,""			,""			 ,""		,""			,""			,""		,""	  ,""		   ,""		   ,""		   ,"N"		   ,"N"		   ,""})
	
	//-- Atualizando dicionario de dados.
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nI:= 1 To Len(aFIELDS)
		If !Empty(aFIELDS[nI][1])
			If !dbSeek(aFIELDS[nI,3])	
				dbSelectArea("SX3")
				dbSetOrder(1)
				dbSeek(aFIELDS[nI,1]+"ZZ",.T.)
				If SX3->X3_ARQUIVO+SX3->X3_ORDEM == aFIELDS[nI,1]+"ZZ"
					cOrdem := "ZZ"
				Else
					dbSkip(-1)
					If SX3->X3_ARQUIVO == aFIELDS[nI,1]
						cOrdem := Soma1(SX3->X3_ORDEM)
					Else
						cOrdem := "01"
					EndIf
				EndIf
				dbSelectArea("SX3")
				dbSetOrder(2)
				lSX3 := .T.
				If !(aFIELDS[nI,1]$cAlias)
					cAlias += aFIELDS[nI,1]+"/"
					aAdd(aARQUPD,aFIELDS[nI,1])
				EndIf
				
				RecLock("SX3",.T.)
				For nJ:=1 To Len(aFIELDS[nI])		
					If FieldPos(aSTRUCT[nJ])>0
						FieldPut(FieldPos(aSTRUCT[nJ]),aFIELDS[nI,nJ])
					EndIf
				Next nJ
				SX3->X3_ORDEM := cOrdem
				dbCommit()        
				MsUnLock()
			EndIf
		EndIf
	Next nI
	
	
	//-- Atualizando estruturas no database.
	If lSX3
		__SetX31Mode(.F.)
		For nI := 1 To Len(aARQUPD)
			
			If Select(aARQUPD[nI]) > 0
				dbSelecTArea(aARQUPD[nI])
				dbCloseArea()
			EndIf
					
			X31UpdTable(aARQUPD[nI])
			
			If __GetX31Error()
				aDADOSIMP[nK,nPKEYSAG]
				CONOUT(ALLTRIM(FUNNAME())+"-"+TIME()+__GetX31Trace())
        	Else
				dbSelecTArea(aARQUPD[nI])
				dbCloseArea()        	
        	EndIf
		Next nI 
		
	EndIf		   
	       
	//-- Defini็ใo de triggers para atualiza็ใo de campos de controle.
	aAdd ( aDICIONARIO, { cTRIGGER, "TCT1SAG" , "CT1CMP", "CT1_", STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TCT2SAG" , "CT2010", "CT2_", STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TCTDSAG" , "CTDCMP", "CTD_", STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TCTTSAG" , "CTTCMP", "CTT_", STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSB1SAG" , "SB1CMP", "B1_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSBMSAG" , "SBMCMP", "BM_"	, STRING_NULL } )	
	aAdd ( aDICIONARIO, { cTRIGGER, "TSA1SAG" , "SA1CMP", "A1_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSA2SAG" , "SA2CMP", "A2_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSF1SAG" , "SF1010", "F1_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSD1SAG" , "SD1010", "D1_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSDESAG" , "SDE010", "DE_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSF2SAG" , "SF2010", "F2_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSD2SAG" , "SD2010", "D2_"	, STRING_NULL } )
	aAdd ( aDICIONARIO, { cTRIGGER, "TSD3SAG" , "SD3010", "D3_"	, STRING_NULL } )

	If Len(aDICIONARIO) > 0
		For nI := 1 to Len(aDICIONARIO)
			If aDICIONARIO[nI,01] == cTRIGGER
				
				//-- Define estrutura da trigger.
				cTRGNAM := aDICIONARIO[nI,02]
				cTABNAM := aDICIONARIO[nI,03]
				cFILNAM := aDICIONARIO[nI,04]
				
				cQuery := "	CREATE OR REPLACE TRIGGER "+cOWNPRD+"."+cTRGNAM+"	" + hENTER
			    cQuery += "	BEFORE INSERT OR UPDATE 							" + hENTER
			    cQuery += "	ON "+cOWNPRD+"."+cTABNAM+" 							" + hENTER
			    cQuery += "	FOR EACH ROW 										" + hENTER
			    cQuery += "	BEGIN		 										" + hENTER
			    cQuery += "	  IF INSERTING THEN 	 							" + hENTER
			    cQuery += "	    :NEW."+cFILNAM+"X_SAG := 'I';	 				" + hENTER
			    cQuery += "	  END IF;	 										" + hENTER
			    cQuery += "	  IF UPDATING AND :OLD."+cFILNAM+"X_SAG != 'A' 		" + hENTER
			    
			    nPOS := aScan ( aDICIONARIO, { |x| x[1] == cTABLE .and. x[2] == cTABNAM } )
			    If nPOS != 0
			    	cQuery += "	AND (									 	 	" + hENTER
			    	For nH := nPOS to Len(aDICIONARIO)
			    		If aDICIONARIO[nH,01] != cTABLE .or. aDICIONARIO[nH,02] != cTABNAM
			    			Exit
			    		ElseIf aDICIONARIO[nH,07]
				    		If nH != nPOS      
				    			cQuery += "	OR									 " + hENTER
				    		EndIf				    		
			    			cQuery += "	:OLD."+aDICIONARIO[nH,03]+" != :NEW."+aDICIONARIO[nH,03]
			    		EndIf
			    	Next nH                                                                   
			    	cQuery += "	OR :OLD.D_E_L_E_T_ != :NEW.D_E_L_E_T_			" + hENTER
			    	cQuery += "	)										 	 	" + hENTER
			    EndIf
			    cQuery += "	  THEN :NEW."+cFILNAM+"X_SAG := 'A';				" + hENTER
			    cQuery += "	  END IF;				 							" + hENTER
			    cQuery += "	END;				 								" + hENTER				
			    aDICIONARIO[nI,05] := cQuery

				
				//-- Consulta existencia do objeto no database.
				cQuery := "	SELECT COUNT(*) NUMREG                  " + hENTER
				cQuery += "	FROM ALL_OBJECTS						" + hENTER
				cQuery += "	WHERE OWNER 	= '"+cOWNPRD+"'			" + hENTER
				cQuery += "	AND OBJECT_NAME = '"+cTRGNAM+"'			" + hENTER
				cQuery += "	AND OBJECT_TYPE = 'TRIGGER'	 			" + hENTER
			
				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())
				nNUMREG := (cAliasTMP)->NUMREG
				(cAliasTMP)->(dbCloseArea())
                
				//-- Executa comando de cria็ใo da trigger no database.
				If nNUMREG == 0
					TCSqlExec(aDICIONARIO[nI,05])				
				EndIf

			EndIf
		Next nI
	EndIf

	
Return

// Fun็ใo que envia o email ap๓s o processamento de uma integra็ใo.
Static Function MailErro(cMsg, cTit)
Local cEmail := "processos@cantu.com.br"
Local oProcess
Local cProcess := OemToAnsi("00808") // Numero do Processo
cStatus  := OemToAnsi("001011")

oProcess := TWFProcess():New(cProcess,OemToAnsi("Erro sincroniza็ใo SAG"))
oProcess:NewTask(cStatus,"\workflow\errosag.html")
oProcess:cSubject := OemToAnsi(cTit)

oHTML:= oProcess:oHTML		

oProcess:cTo := ALLTRIM(cEmail) // "microsiga@grupocantu.com.br"
oProcess:cCC := ALLTRIM("suporte.microsiga@grupocantu.com.br") // "microsiga@grupocantu.com.br"
oHTML:ValByName("MSG", cMsg)
                                    
oProcess:Start()
oProcess:Finish()
Return .T.