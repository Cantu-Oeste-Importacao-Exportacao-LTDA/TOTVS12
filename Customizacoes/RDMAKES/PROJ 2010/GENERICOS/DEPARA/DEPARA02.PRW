#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³DEPARA02  º Autor ³ Rafael Parma       º Data ³  22/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa de/para sobre:                                    º±±
±±º          ³ Contas a Pagar: Fornecedor, Loja, Natureza, Conta Contábil.º±±
±±º          ³ Contas a Receber: Cliente, Loja, Natureza, Vendedor, Conta º±±
±±º          ³ Contábil.                                                  º±±
±±º          ³ Fornecedores: Condição Pagamento, Conta Contábil, Natureza.º±±
±±º          ³ Clientes: Condição Pagamento, Vendedor, Conta Contábil,    º±± 
±±º          ³ Tabela de Preço, Natureza.                                 º±±
±±º          ³ Ativos: Cabeçalho: Grupo, Código/Loja Fornecedor.          º±±
±±º          ³ Ativos: Itens: Conta, Cta Desp Dep, Cta Dep Acum.          º±±
±±º          ³ Grupo Bens (Ativos): Conta, Cta Desp Depr, Cta Dep Acum.   º±±
±±º          ³ Controle CIAP: Código/Loja Fornecedor Código/Loja Cliente. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
*---------------------------*
User Function DEPARA02()
*---------------------------*

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Public STRING_NULL := ""
Public oDlgWin, nHdlLOG  

Private lCheckSE1 := .F.
Private lCheckSE2 := .F.
Private lCheckSA1 := .F.
Private lCheckSA2 := .F.
Private lCheckSN1 := .F.
Private lCheckSNG := .F.
Private lCheckSF9 := .F.
Private lCheckRC0 := .F.
Private aCheckDAT := {"Verificar", "Atualizar"}
Private cCheckDAT := STRING_NULL

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

        
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Montagem da tela de processamento.                                  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 200,001 TO 470,380 DIALOG oDlgWin TITLE OemToAnsi("Programa de/para sobre SIGAFIN/SIGAATF")
	@ 010,010 TO 140,180
	@ 018,018 Say " Este programa irá atualizar os registros das seguintes tabelas:"
	@ 028,018 CHECKBOX "Contas a Pagar" 	VAR lCheckSE2
	@ 038,018 CHECKBOX "Contas a Receber" 	VAR lCheckSE1
	@ 048,018 CHECKBOX "Fornecedores" 		VAR lCheckSA2
	@ 058,018 CHECKBOX "Clientes" 			VAR lCheckSA1
	@ 068,018 CHECKBOX "Ativos" 			VAR lCheckSN1
	@ 078,018 CHECKBOX "Grupos de Bens" 	VAR lCheckSNG				
	@ 088,018 CHECKBOX "Controle CIAP" 		VAR lCheckSF9
	@ 098,018 CHECKBOX "GPE (RC0/RC1)" 		VAR lCheckRC0
	@ 108,018 Say "Operação: "
	@ 108,055 COMBOBOX cCheckDAT ITEMS aCheckDAT  SIZE 040,010
	
	@ 118,112 BMPBUTTON TYPE 01 ACTION ( Processa({|| fProcDADOS(cCheckDAT=="Atualizar") },"Processando...") )
	@ 118,142 BMPBUTTON TYPE 02 ACTION Close(oDlgWin)
	
	Activate Dialog oDlgWin Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fProcDADOS Autor ³ Rafael Parma       º Data ³  23/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Função responsável por executar de/para sobre as tabelas   º±±
±±º          ³ relacionadas.                                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

*-------------------------------------*
Static Function fProcDADOS(lUpdate)
*------------------------------------*
Private aDADOSIMP := {}	// Tabelas e campos
Private aDADOSEMP := {}	// Empresas
Private aDADOSDIV := {} // Dados de/para
Private aCLONEIMP := {}	// Clone tabelas e campos
Private cAliasTMP := GetNextAlias()

Private aDADOSCLI := {}	// Clientes
Private aDADOSFOR := {}	// Fornecedores
Private aDADOSNAT := {}	// Naturezas
Private aDADOSCTA := {}	// Contas
Private aDADOSCPG := {}	// Condição de pagamento
Private aDADOSVEN := {}	// Vendedores
Private aDADOSTPR := {}	// Tabela de preço
Private aDADOSGAT := {}	// Grupo ativo

Private cEMPATU := cEmpAnt
Private cFILATU := cFilAnt
Private cMODATU := cModulo
Private cMODIMP := "FIN"

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Popula array com códigos antigos/novos                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	
//	fUpdARRAY(@aDADOSCLI,"cli.txt")
//	fUpdARRAY(@aDADOSFOR,"for.txt")
	fUpdARRAY(@aDADOSNAT,"nat.txt")
//	fUpdARRAY(@aDADOSCTA,"cta.txt")
	fUpdARRAY(@aDADOSCPG,"cpg.txt")
	fUpdARRAY(@aDADOSVEN,"ven.txt")
//	fUpdARRAY(@aDADOSTPR,"trp.txt")					
//	fUpdARRAY(@aDADOSGAT,"gat.txt")

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Popula array com tabelas e campos                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
     
	aAdd ( aDADOSIMP, { "RC0", "RC0_NATURE"	, "NATUREZ"		} )		// NATUREZA
	aAdd ( aDADOSIMP, { "RC1", "RC1_NATURE"	, "NATUREZ"		} )		// NATUREZA
                                              
	aAdd ( aDADOSIMP, { "SE1", "E1_NATUREZ"	, "NATUREZ"		} )		// NATUREZA
	aAdd ( aDADOSIMP, { "SE1", "E1_VEND1"	, "VEND"		} )		// VENDEDOR

/*
	CAMPOS JÁ CORRETOS	
	aAdd ( aDADOSIMP, { "SE1", "E1_CLIENTE"	, "CLIENTE"		} )		// CLIENTE
	aAdd ( aDADOSIMP, { "SE1", "E1_LOJA"	, "LOJA"		} )		// LOJA

	CAMPOS NÃO PREENCHIDOS
	aAdd ( aDADOSIMP, { "SE1", "E1_DEBITO"	, "CONTA"		} )		// CONTA CONTABIL DEBITO
	aAdd ( aDADOSIMP, { "SE1", "E1_CREDIT"	, "CONTA"		} )		// CONTA CONTABIL CREDITO	
*/
	
	aAdd ( aDADOSIMP, { "SE2", "E2_NATUREZ"	, "NATUREZ"		} )		// NATUREZA
/*
	CAMPOS JÁ CORRETOS
	aAdd ( aDADOSIMP, { "SE2", "E2_FORNECE"	, "FORNECE"		} )		// FORNECEDOR
	aAdd ( aDADOSIMP, { "SE2", "E2_LOJA"	, "LOJA" 		} )		// LOJA

	CAMPOS NÃO PREENCHIDOS
	aAdd ( aDADOSIMP, { "SE2", "E2_CONTAD"	, "CONTA"  		} )		// CONTA CONTABIL	
	aAdd ( aDADOSIMP, { "SE2", "E2_DEBITO"	, "CONTA"		} )		// CONTA CONTABIL DEBITO
	aAdd ( aDADOSIMP, { "SE2", "E2_CREDIT"	, "CONTA"		} )		// CONTA CONTABIL CREDITO
*/
	

	aAdd ( aDADOSIMP, { "SA1", "A1_NATUREZ"	, "NATUREZ"		} )		// NATUREZA
//	aAdd ( aDADOSIMP, { "SA1", "A1_COND"	, "CONDPG"		} )		// CONDICAO PAGAMENTO

	aAdd ( aDADOSIMP, { "SA2", "A2_NATUREZ"	, "NATUREZ"		} )		// NATUREZA
//	aAdd ( aDADOSIMP, { "SA2", "A2_COND"	, "CONDPG" 		} )		// CONDICAO PAGAMENTO


/*
	aAdd ( aDADOSIMP, { "SA1", "A1_VEND"	, "VEND" 		} )		// VENDEDOR 		- CAMPO VAZIO
	aAdd ( aDADOSIMP, { "SA1", "A1_CONTA"	, "CONTA"		} )		// CONTA CONTABIL 	- APSDU
	aAdd ( aDADOSIMP, { "SA1", "A1_TABELA"	, "TABPRC" 		} )		// TABELA PRECO 	- SERA' VERIFICADO POSTERIORMENTE
	aAdd ( aDADOSIMP, { "SA2", "A2_CONTA"	, "CONTA"		} )		// CONTA CONTABIL 	- APSDU
*/


/*                                            
	CADASTROS NAO REALIZADOS
	
	aAdd ( aDADOSIMP, { "SN1", "N1_GRUPO"	, "GRUPO"		} )		// GRUPO   
	aAdd ( aDADOSIMP, { "SN1", "N1_FORNEC"	, "FORNECE"		} )		// CODIGO FORNECEDOR     
	aAdd ( aDADOSIMP, { "SN1", "N1_LOJA"   	, "LOJA"		} )		// LOJA FORNECEDOR
	aAdd ( aDADOSIMP, { "SN3", "N3_CCONTAB" , "CONTA"		} )		// CONTA   
	aAdd ( aDADOSIMP, { "SN3", "N3_CDEPREC"	, "CONTA"		} )		// CTA DESP DEP   
	aAdd ( aDADOSIMP, { "SN3", "N3_CCDEPR"  , "CONTA"	 	} )		// CTA DEP ACUM      

	aAdd ( aDADOSIMP, { "SNG", "NG_CCONTAB"	, "CONTA" 		} )		// CONTA   
	aAdd ( aDADOSIMP, { "SNG", "NG_CDEPREC" , "CONTA"		} )		// CTA DESP DEP   
	aAdd ( aDADOSIMP, { "SNG", "NG_CCDEPR"  , "CONTA" 		} )		// CTA DEP ACUM      

	aAdd ( aDADOSIMP, { "SF9", "F9_FORNECE" , "FORNECE"		} )		// CODIGO FORNECEDOR
	aAdd ( aDADOSIMP, { "SF9", "F9_LOJAFOR" , "LOJA"		} )		// LOJA FORNECEDOR
	aAdd ( aDADOSIMP, { "SF9", "F9_CLIENTE" , "CLIENTE" 	} )		// CODIGO CLIENTE    
	aAdd ( aDADOSIMP, { "SF9", "F9_LOJACLI" , "LOJA"	 	} )		// LOJA CLIENTE 
*/	
	
	aCLONEIMP := aClone(aDADOSIMP)     


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Popula array com código EMPRESA, FILIAL                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If !SM0->M0_CODIGO $ "00/70"
			If Len(aDADOSEMP) == 0
				nPOS := 0
			Else
				nPOS := aScan ( aDADOSEMP, { |x| x[1] == SM0->M0_CODIGO } )
			EndIf
			If nPOS == 0
				aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL } )
			EndIf		
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

 	
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento dos registros por empresas                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  	                                 
	For nE := 1 to Len(aDADOSEMP)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Prepara ambiente/módulo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SM0")
		dbSetOrder(1)
		If !dbSeek ( aDADOSEMP[nE][01] )
			Alert("Empresa "+aDADOSEMP[nE][01]+" não existente no SIGAMAT.")
			Loop   
		EndIf

		RpcClearEnv()
		RPCSetType(3)
		                                              
		PREPARE ENVIRONMENT EMPRESA (aDADOSEMP[nE][01]) FILIAL (aDADOSEMP[nE][02]) MODULO cMODIMP
		
		cArqTxt := "\procdepara\DEPARA02_"+aDADOSEMP[nE][01]+"_"+cMODIMP+"_"+dtos(ddatabase)+"_"+StrTran(time(),":","")+".log"
		nHdlLOG := fCreate(cArqTxt)
		cTXT := StrTran(time(),":","")+"-0-INICIO PROCESSAMENTO"+chr(13)+chr(10)
		fWrite(nHdlLOG,cTXT,Len(cTXT))
	
		For nI := 1 to Len(aDADOSIMP)
		
			If aDADOSIMP[nI][01] $ "SA1/SA2"
				If nE > 1
					Loop
				EndIf
			EndIf

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica flags de operações                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
			If ! lCheckSE1 .and. aDADOSIMP[nI][01] == "SE1"
				Loop
			EndIf
			If ! lCheckSE2 .and. aDADOSIMP[nI][01] == "SE2"
				Loop
			EndIf
			If ! lCheckSA1 .and. aDADOSIMP[nI][01] == "SA1"
				Loop
			EndIf
			If ! lCheckSA2 .and. aDADOSIMP[nI][01] == "SA2"
				Loop
			EndIf
			If ! lCheckSNG .and. aDADOSIMP[nI][01] == "SNG"
				Loop
			EndIf
			If ! lCheckSF9 .and. aDADOSIMP[nI][01] == "SF9"
				Loop
			EndIf
			If ! lCheckSN1 .and. aDADOSIMP[nI][01] $ "SN1/SN3"
				Loop
			EndIf
			If ! lCheckRC0 .and. aDADOSIMP[nI][01] $ "RC0/RC1"
				Loop
			EndIf
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Salta campo LOJA                                                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

			If "LOJA" $ aDADOSIMP[nI][02]
				Loop
			EndIf			

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Seleciona área de dados                                             ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    		
    		TcRefresh(RetSQLName(aDADOSIMP[nI][01]))
    		If TCCanOpen(RetSQLName(aDADOSIMP[nI][01]))
    			
    			dbSelectArea(aDADOSIMP[nI][01])  
    			cTXT := StrTran(time(),":","")+"-1-INICIO TABELA: "+aDADOSIMP[nI][01]+" CAMPO: "+aDADOSIMP[nI][02]+chr(13)+chr(10)
				fWrite(nHdlLOG,cTXT,Len(cTXT))
  		
  				cNFIELD := aDADOSIMP[nI][02]
  				cSFIELD := aDADOSIMP[nI][02]
  				cUFIELD1 := aDADOSIMP[nI][02]
  				cUFIELD2 := STRING_NULL
  				If "FORNECE" $ aDADOSIMP[nI][03] .or. "CLIENTE" $ aDADOSIMP[nI][03]
  					If aDADOSIMP[nI][01] == "SE1"
  						cSFIELD += "||E1_LOJA"
  						cUadFIELD2 := "E1_LOJA"   
  					ElseIf aDADOSIMP[nI][01] == "SE2"
  						cSFIELD += "||E2_LOJA"  
  						cUFIELD2 := "E2_LOJA"    
  					ElseIf aDADOSIMP[nI][01] == "SN1"
  						cSFIELD += "||N1_LOJA"  
  						cUFIELD2 := "N1_LOJA"   
  					ElseIf aDADOSIMP[nI][01] == "SF9"
  						If aDADOSIMP[nI][02] == "F9_CLIENTE"
  							cSFIELD += "||F9_LOJACLI"  
  							cUFIELD2 := "F9_LOJACLI"   
  						Else 
  							cSFIELD += "||F9_LOJAFOR"  
  							cUFIELD2 := "F9_LOJAFOR"   
  						EndIf                       
  					EndIf
  				EndIf

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Cria campo temporário na tabela                                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				          
				If lUpdate
	    			nTAMSX3 := TAMSX3(aDADOSIMP[nI][02])[1]
	    			nTAMSUP := TAMSX3(aDADOSIMP[nI][02])[1]	    			
	    			If "FORNECE" $ aDADOSIMP[nI][03] .or. "CLIENTE" $ aDADOSIMP[nI][03]
	    				nTAMSX3 += TAMSX3("A1_LOJA")[1]                     
	    				nTAMSUB := TAMSX3("A1_LOJA")[1]    			
	    				cTAMSUB := cValToChar(nTAMSUB)
	    			EndIf
	    			cTAMSX3 := cValToChar(nTAMSX3)	    			
	    			cTAMSUP := cValToChar(nTAMSUP)	    			
	    			cQuery  := " ALTER TABLE " + RetSQLName(aDADOSIMP[nI][01]) + " ADD ( " + ALLTRIM(cNFIELD) + "_X CHAR("+cTAMSX3+") ) "
	    			TcSqlExec(cQuery)
				EndIf	    			

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Atualização do novo campo                                           ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				aDADOSTMP := {}
				
				cQuery := "	SELECT 	DISTINCT ( TAB." + ALLTRIM(cSFIELD) + " ) CODIGO  		" + CHR(13)+CHR(10)
				cQuery += "	FROM 	" + RetSQLName(aDADOSIMP[nI][01]) + " TAB				" + CHR(13)+CHR(10)
				cQuery += "	WHERE 	TAB.D_E_L_E_T_ != '*'									" + CHR(13)+CHR(10)

				TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Popula array com código anterior e novo somente p/ verbas da tabela ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

				dbSelectArea(cAliasTMP)
				(cAliasTMP)->(dbGoTop())
				While (cAliasTMP)->(!EOF())		
				
					If aDADOSIMP[nI][03] == "CLIENTE"					
						nPOSAR := aScan ( aDADOSCLI, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSCLI[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "FORNECE"					
						nPOSAR := aScan ( aDADOSFOR, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSFOR[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "NATUREZ"					
						//nPOSAR := aScan ( aDADOSNAT, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == (cAliasTMP)->CODIGO } )
						nPOSAR := aScan ( aDADOSNAT, {|x| x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSNAT[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
 							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "CONTA"					
						nPOSAR := aScan ( aDADOSCTA, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSCTA[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "VEND"					
						nPOSAR := aScan ( aDADOSVEN, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSVEN[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "TABPRC"					
						nPOSAR := aScan ( aDADOSTPR, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSTPR[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "CONDPG"					
						//nPOSAR := aScan ( aDADOSCPG, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == (cAliasTMP)->CODIGO } )
						nPOSAR := aScan ( aDADOSCPG, {|x| x[02] == ALLTRIM((cAliasTMP)->CODIGO) } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSCPG[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf

					If aDADOSIMP[nI][03] == "GRUPO"					
						nPOSAR := aScan ( aDADOSGAT, {|x| x[01] == aDADOSEMP[nE][01] .and. x[02] == (cAliasTMP)->CODIGO } )
						If nPOSAR != 0
							aAdd (aDADOSTMP, { (cAliasTMP)->CODIGO, aDADOSGAT[nPOSAR][03] } )
						ElseIf !Empty((cAliasTMP)->CODIGO)			
			    			cTXT := StrTran(time(),":","")+"-2-ERRO: CODIGO RELACIONADO NÃO ENCONTRADO: "+aDADOSIMP[nI][03]+" - "+(cAliasTMP)->CODIGO+chr(13)+chr(10)
							fWrite(nHdlLOG,cTXT,Len(cTXT))							
						EndIf
					EndIf						

					(cAliasTMP)->(dbSkip())
				Enddo 
				(cAliasTMP)->(dbCloseArea())

				          
				If lUpdate

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza tabela novo campo com novo código.                         ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
					If Len(aDADOSTMP) > 0
						For nT := 1 to Len(aDADOSTMP)								
							cQuery := "	UPDATE " + RetSQLName(aDADOSIMP[nI][01]) + " SET " + ALLTRIM(cNFIELD) + "_X = '" + aDADOSTMP[nT][02] + "' "							
							cQuery += "	WHERE " + ALLTRIM(cSFIELD) + " = '"+aDADOSTMP[nT][01]+"' AND D_E_L_E_T_ != '*' "
							TcSqlExec(cQuery)								
						Next nT
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Atualiza campo original com valor do campo novo.                    ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If cUFIELD2 == STRING_NULL                                                                                                     
						cQuery := "	UPDATE " + RetSQLName(aDADOSIMP[nI][01]) + " SET " + ALLTRIM(cUFIELD1) + " = " + ALLTRIM(cNFIELD) + "_X "
						cQuery += "	WHERE " + ALLTRIM(cUFIELD1) + "_X != '" + Space(nTAMSX3) + "' AND D_E_L_E_T_ != '*' "
					Else
						cQuery := "	UPDATE " + RetSQLName(aDADOSIMP[nI][01]) + " SET " + ALLTRIM(cUFIELD1) + " = SUBSTR(" + ALLTRIM(cNFIELD) + "_X,1,"+cTAMSUP+") "
						cQuery +=  ", " + ALLTRIM(cUFIELD2) + " = SUBSTR(" + ALLTRIM(cNFIELD) + "_X,"+cTAMSUP+"+1,"+cTAMSUB+") "
						cQuery += "	WHERE " + ALLTRIM(cNFIELD) + "_X != '" + Space(nTAMSX3) + "' AND D_E_L_E_T_ != '*' "
					EndIf					
					
					TcSqlExec(cQuery)								
	
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Elimina o novo campo auxiliar.                                      ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	    			cQuery  := " ALTER TABLE " + RetSQLName(aDADOSIMP[nI][01]) + " DROP ( " + ALLTRIM(cNFIELD) + "_X ) "
	    			TcSqlExec(cQuery)
				
				EndIf
					
				TcRefresh(RetSQLName(aDADOSIMP[nI][01]))
				If TCCanOpen(RetSQLName(aDADOSIMP[nI][01]))
					dbSelectArea(aDADOSIMP[nI][01])
				EndIf

    			cTXT := StrTran(time(),":","")+"-3-FIM TABELA: "+aDADOSIMP[nI][01]+chr(13)+chr(10)
				fWrite(nHdlLOG,cTXT,Len(cTXT))				
				
			EndIf
			IncProc()
					
		Next nI    	                          
		
		cTXT := StrTran(time(),":","")+"-9-FIM PROCESSAMENTO"+chr(13)+chr(10)
		fWrite(nHdlLOG,cTXT,Len(cTXT))		
		
		fClose(nHdlLOG)
		    
    Next nE
	
	
	Close(oDlgWin)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura ambiente de origem.                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO (cMODATU)	
	
	MsgInfo("Processo concluído com sucesso! Verifique o arquivo de log: "+cArqTxt)


Return 

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ fUpdARRAY  Autor ³ Rafael Parma       º Data ³  23/11/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Popula array com dados de arquivo ANSI externo.            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ RJU                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/   
*------------------------------------------*
Static Function fUpdARRAY(aDADOS,cARQUIVO)       
*------------------------------------------*

Local cArqTXT := "\procdepara\"+cARQUIVO
Local nTamFile, nTamLin, cBuffer, nBtLidos

Private nHdl   := fOpen(cArqTXT,68)
Private cEOL  := "CHR(13)+CHR(10)"
	
	If nHdl == -1
	    MsgAlert("O arquivo de nome "+cArqTXT+" não pode ser aberto! Verifique os parâmetros.","Atenção!")
	    Return
	Endif

	aDADOS := {}
	nTamFile := fSeek(nHdl,0,2)
	fSeek(nHdl,0,0)
	nTamLin  := 91
	cBuffer  := Space(nTamLin) 
	
	nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto
	
	ProcRegua(nTamFile) // Numero de registros a processar
	nProc := 0
	While nBtLidos >= nTamLin
	    nProc += 1
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Incrementa a regua                                                  ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    IncProc()
	
	
		aAdd( aDADOS, { ALLTRIM(SubSTR(cBuffer,01,30)), ALLTRIM(SubSTR(cBuffer,31,30)), ALLTRIM(SubSTR(cBuffer,61,30)) } )
	
	    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	    //³ Leitura da proxima linha do arquivo texto.                          ³
	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	
	    dbSkip()
	EndDo
	
	fClose(nHdl)

Return