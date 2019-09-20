#INCLUDE "FIVEWIN.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"

#DEFINE STRINGNULL		""     
#DEFINE CPATHFILE1		"/neogrid/"
#DEFINE CPATHFILE2		"/neogrid/cobrancainteligente/"
#DEFINE CPATHFILE3		"/cnabs/"
#DEFINE nPHEADARQ			3
#DEFINE nPHEADLOT			4
#DEFINE nPDETALHE			5
#DEFINE nPTRAILOT			6
#DEFINE nPTRAIARQ			7

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFINP05 บAutor  ณTOTVS PARANA CENTRAL บ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Integra็ใo cobran็a inteligente NeoGrid.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/ 
*---------------------------------------------------------------------------*
User Function RJFINP05()
*---------------------------------------------------------------------------*
PRIVATE cAlias 		:= "Z56"

PRIVATE cCadastro	:= OemToAnsi("Cobran็a Inteligente NeoGrid")   

					 					 
PRIVATE aRotina := { 	{ OemToAnsi("Pesquisar")  			,"AxPesqui"   , 0 , 1},;
					 	{ OemToAnsi("Visualizar") 			,"U_RJF05WIN" , 0 , 2},;
					 	{ OemToAnsi("Importar")    			,"U_RJF05IMP" , 0 , 3},;
					 	{ OemToAnsi("Comp. Devolu็๕es")		,"U_RJF05CMP" , 0 , 4},;
					 	{ OemToAnsi("Gerar Arq.Baixas")		,"U_RJF05ABX" , 0 , 5},;
					 	{ OemToAnsi("Rel. Ext. Retorno")  	,"U_RJF05RER" , 0 , 6},;
					 	{ OemToAnsi("Rel. Tot. p/Perํodo") 	,"U_RJF05RTP" , 0 , 7},;
					 	{ OemToAnsi("Legenda")    			,"U_RJF05LEG" , 0 , 8} }
					 					 					 					 
PRIVATE aCores	:= {	{ "Z56_TIPARQ == '09' .AND. Z56_CMPDEV == 'N' .AND. Z56_ARQBXR == 'N'"	, 'BR_VERDE'		},;
						{ "Z56_TIPARQ == '09' .AND. Z56_CMPDEV != 'N' .AND. Z56_ARQBXR == 'N'"	, 'BR_VERMELHO'		},;
						{ "Z56_TIPARQ == '09' .AND. Z56_CMPDEV == 'N' .AND. Z56_ARQBXR != 'N'"	, 'BR_AMARELO'		},;
						{ "Z56_TIPARQ == '09' .AND. Z56_CMPDEV != 'N' .AND. Z56_ARQBXR != 'N'"	, 'BR_PRETO'		},;
						{ "Z56_TIPARQ == '02'" 													, 'BR_BRANCO'		},;
						{ "Z56_TIPARQ == '30'"													, 'BR_AZUL'			} }
 

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Endereca a funcao de BROWSE                                  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	mBrowse(6, 1, 22, 75, cAlias,,,,,,aCores)
	
Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05LEG  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para legenda.                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05LEG()
*---------------------------------------------------------------------------*
Local cTitulo := OemtoAnsi("Legenda")         

Local aCores	:= {	{ 'BR_BRANCO'	, "Arq. confirma็ใo de entrada - Importado."			},;
						{ 'BR_AZUL'		, "Arq. previsใo de pagamento - Importado."			   	},;						
						{ 'BR_VERDE'	, "Arq. baixas - Importado."	   						},;
						{ 'BR_VERMELHO'	, "Arq. baixas - Compensa็๕es de devolu็๕es."	  		},;
						{ 'BR_AMARELO'	, "Arq. baixas - Arquivo de baixas Protheus."  	   		},;
						{ 'BR_PRETO'	, "Arq. baixas - Comp. dev. e Arq. baixas Protheus."	}}
												
	BrwLegenda(cTitulo, "Legenda", aCores)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05IMP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para importa็ใo de arquivo de retorno NeoGrid.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05IMP()                                                       
*---------------------------------------------------------------------------*  

	MsAguarde( {|| F05IMP() }, "Importando arquivos... Aguarde!")	

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF05IMP    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para importa็ใo de arquivo de retorno NeoGrid.       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function F05IMP()                                                       
*---------------------------------------------------------------------------*  

Local aFILESDIR := {}
Local aEMPRESAS := {}
Local aDADOSIMP := {}
Local hFILEIMP
Local hFILELOG

	If !ExistDir(CPATHFILE1)
		MakeDir(CPATHFILE1)
	EndIf

	If !ExistDir(CPATHFILE2)
		MakeDir(CPATHFILE2)
	EndIf

	//-- Realiza a leitura dos arquivos a serem importados.
	
	/*Fernando Luiz, 12/09/14.
	Alterada extensใo padrใo na importa็ใo do arquivo de .ret para .txt 
	pois no retorno da Neogrid o padrใo ้ .txt.*/
	
	cFILTRO := "*"+SubSTR(SM0->M0_CGC,1,8)+"*.txt"
	aDir(CPATHFILE2+cFILTRO, aFILESDIR )

	If Len(aFILESDIR) > 0

		RpcClearEnv()
		RPCSetType(3)
	    PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "FIN" TABLES "Z56","Z57","Z58","Z59"
	    
	    //-- Adiciona ao array todas as empresas/filiais do grupo.
	    dbSelectArea("SM0")
	    nRECSM0 := SM0->(RECNO())
		dbGoTop()
		While !SM0->(EOF())
			aAdd ( aEMPRESAS, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC } )
			SM0->(dbSkip())
		Enddo
		dbGoTo(nRECSM0)
	
		//-- Percorre array com os arquivos a serem importados.
		For _nINDARQ := 1 to Len(aFILESDIR)
		
	    	hFILEIMP := fT_fUse(CPATHFILE2+aFILESDIR[_nINDARQ])
			
			//-- Valida็ใo para abertura do arquivo.
			If hFILEIMP == -1
				//--Arquivo nใo pode ser aberto.
				Loop
			EndIf
			
			fT_fGoTop()
			If !fT_fEof()
				cTEXTO := fT_fReadLn()
				//--Valida็ใo sobre linha do Header de Arquivo = 0
				If SubSTR(cTEXTO,8,1) == "0"
					//--Armazena o CNPJ e nome do arquivo
					aAdd ( aDADOSIMP, { SubSTR(cTEXTO,19,14) , aFILESDIR[_nINDARQ], {}, {}, {}, {}, {} } )
				Else
					//--Arquivo sem registro de Header de Arquivo = 0
				EndIf
			Else
				//--Arquivo vazio.
			EndIf
			fT_fUse()
			
		Next _nINDARQ
		
		If Len(aDADOSIMP) > 0
			//--Ordena registros pelo CNPJ
			aDADOSIMP := aSort( aDADOSIMP,,,{ |x,y| x[01] < y[01] })
			
			//--Percorre arquivos a serem processados.
			For _nINDARQ := 1 to Len(aDADOSIMP)
			  
				//--Nome do arquivo em processamento.
				cFILENAME := SubSTR(aDADOSIMP[_nINDARQ][02],1,Len(aDADOSIMP[_nINDARQ][02])-3)
				                    
				//--Cria็ใo do arquivo de log.
				hFILELOG := fCreate(CPATHFILE2+cFILENAME+"log")
				
				If hFILELOG == -1   				
					conout( "ERRO NA CRIACรO DO ARQUIVO: " + CPATHFILE2+cFILENAME+"log" )				
				EndIf
				
				cSTRING := "Log de processamento do arquivo: "+aDADOSIMP[_nINDARQ][02]
				fGravaLog(hFILELOG,cSTRING) 					
				
				_nPOSEMP := aScan ( aEMPRESAS, { |x| x[03] == aDADOSIMP[_nINDARQ][01] } )
				//--Localiza empresa/filial para importar o arquivo.
				If _nPOSEMP != 0
					
					If cEmpAnt != aEMPRESAS[_nPOSEMP][01] .OR. cFilAnt != aEMPRESAS[_nPOSEMP][02]
						RpcClearEnv()
						RPCSetType(3)
						PREPARE ENVIRONMENT EMPRESA aEMPRESAS[_nPOSEMP][01] FILIAL aEMPRESAS[_nPOSEMP][02] MODULO "FIN" TABLES "Z56","Z57","Z58","Z59"
					EndIf

					//--Arquivo referente a empresa/filial.
					cSTRING := "Arquivo referente a empresa/filial: "+cEmpAnt+"/"+cFilAnt
					fGravaLog(hFILELOG,cSTRING) 					
	
		    		hFILEIMP := fT_fUse(CPATHFILE2+aDADOSIMP[_nINDARQ][02])
					
					//-- Valida็ใo para abertura do arquivo.
					If hFILEIMP == -1
						//--Arquivo nใo pode ser aberto.
						cSTRING := "Arquivo nใo pode ser aberto."
						fGravaLog(hFILELOG,cSTRING) 						
						fClose(hFILELOG)
						Loop
					EndIf      
					
					cZ56_CODBCO := STRINGNULL
					cZ56_CODAGE := STRINGNULL
					cZ56_NUMCON := STRINGNULL
					cZ56_SEQARQ := STRINGNULL
					cZ56_NUMRET := STRINGNULL
					lIDCNAB := .F. 
					
					fT_fGoTop()					
					While !fT_fEof()
						cTEXTO := fT_fReadLn()
						
						//--Registro de Header de Arquivo = 0
						If SubSTR(cTEXTO,8,1) == "0"
							
							cZ56_CODBCO := SubSTR(cTEXTO,1,3)
							cZ56_CODAGE := SubSTR(cTEXTO,53,5)
							cZ56_NUMCON := PadR(SubSTR(cTEXTO,59,12),20)
							cZ56_SEQARQ := SubSTR(cTEXTO,158,6)
							dZ56_DATARQ := CTOD(SubSTR(cTEXTO,144,2)+"/"+SubSTR(cTEXTO,146,2)+"/"+SubSTR(cTEXTO,148,4))
							cZ56_HORARQ := SubSTR(cTEXTO,152,2)+":"+SubSTR(cTEXTO,154,2)
							cZ56_CMPDEV := "N"
							cZ56_ARQBXR := "N"
							cZ56_TIPARQ := STRINGNULL
							
						//--Registro de Header de Lote = 1 
						ElseIf SubSTR(cTEXTO,8,1) == "1"

							cZ56_NUMRET := SubSTR(cTEXTO,184,8)
							aAdd ( aDADOSIMP[_nINDARQ][nPHEADARQ], { 	cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON, cZ56_SEQARQ, dZ56_DATARQ, ;
																		cZ56_HORARQ, cZ56_NUMRET, cZ56_CMPDEV, cZ56_ARQBXR, cZ56_TIPARQ } )            
																												
							//--Adiciona ao array registro referente ao Header de Lote.
							cSTRING := "Adiciona ao array registro referente ao Header de Lote."
							fGravaLog(hFILELOG,cSTRING) 																													
																																		
						//--Registro de Retorno de Detalhe / Segmento T
						ElseIf SubSTR(cTEXTO,8,1) == "3" .and. SubSTR(cTEXTO,14,1) == "T"
						  	
						  	nTAMIMP := Len(aDADOSIMP[_nINDARQ][nPHEADARQ])
						  	If aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][10] == STRINGNULL
						  		cZ56_TIPARQ := SubSTR(cTEXTO,016,02)
						  		aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][10] := cZ56_TIPARQ	
						  	EndIf
						  	
						  	lIDCNAB := .F.               
							cZ57_IDCIN	:= SubSTR(cTEXTO,038,20) 
							cZ57_IDCNAB	:= ALLTRIM(SubSTR(cTEXTO,189,10))
							cCNPJCLIENT	:= SubSTR(cTEXTO,135,14)
							
							dbSelectArea("SE1")
							SE1->(dbSetOrder(19))	//--E1_IDCNAB
							SE1->(dbGoTop())
							If SE1->(dbSeek(cZ57_IDCNAB)).and.cZ57_IDCNAB!=STRINGNULL
								cZ57_FILDOC	:= SE1->E1_FILIAL
								cZ57_CODCLI	:= SE1->E1_CLIENTE
								cZ57_LOJCLI	:= SE1->E1_LOJA
								cZ57_PREFIX	:= SE1->E1_PREFIXO
								cZ57_TITULO	:= SE1->E1_NUM
								cZ57_PARCEL	:= SE1->E1_PARCELA
								cZ57_TIPO	:= SE1->E1_TIPO
								dZ57_DATEMI	:= SE1->E1_EMISSAO
								cZ57_FLAGBX	:= "N"
								nZ57_VLRNOM	:= Val(SubSTR(cTEXTO,82,15))
								aCONTRATO	:= FCONTREDE(SE1->E1_FILIAL, SE1->E1_NUM, SE1->E1_PREFIXO, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_EMISSAO)
								cZ57_CONTRA	:= aCONTRATO[1]
								cZ57_SEQCON	:= aCONTRATO[2]
								If cZ57_CONTRA == STRINGNULL
									cDESCRI := "Contrato de redes nใo localizado para este tํtulo."									
									U_RJF05Z59(XFILIAL("Z57"), cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON, cZ56_SEQARQ, cZ56_NUMRET, cZ57_IDCNAB, cDESCRI)
								EndIf	
								lIDCNAB := .T. 
							Else
								//--IDCNAB nใo localizado.
								cSTRING := "IDCNAB nใo localizado no contas a receber. "+cZ57_IDCNAB
								fGravaLog(hFILELOG,cSTRING) 							

								cDESCRI := "IDCNAB nใo localizado no contas a receber."									
								U_RJF05Z59(XFILIAL("Z57"), cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON, cZ56_SEQARQ, cZ56_NUMRET, cZ57_IDCNAB, cDESCRI)
								
								cZ57_TITULO	:= SubSTR(cTEXTO,059,09)
								cZ57_PREFIX	:= SubSTR(cTEXTO,068,03)
								cCNPJCLIENT	:= SubSTR(cTEXTO,135,14)
								

								cSTRING := "Fun็ใo de busca de tํtulo (Prefixo="+cZ57_PREFIX+" - Tํtulo="+cZ57_TITULO+" - CNPJ="+cCNPJCLIENT+")"
								fGravaLog(hFILELOG,cSTRING) 							

								nRECSE1 := 0
								If fBuscaTIT(cZ57_PREFIX,cZ57_TITULO,STRINGNULL,cCNPJCLIENT,@nRECSE1)

									cSTRING := "Tํtulo localizado ! (Prefixo="+cZ57_PREFIX+" - Tํtulo="+cZ57_TITULO+" - CNPJ="+cCNPJCLIENT+")"
									fGravaLog(hFILELOG,cSTRING) 							

									dbSelectArea("SE1")
									dbGoTop()
									dbGoTo(nRECSE1)
								
									cZ57_IDCNAB	:= SE1->E1_NUM+SubSTR(SE1->E1_PREFIXO,1,1)
									cZ57_FILDOC	:= SE1->E1_FILIAL
									cZ57_CODCLI	:= SE1->E1_CLIENTE
									cZ57_LOJCLI	:= SE1->E1_LOJA
									cZ57_PREFIX	:= SE1->E1_PREFIXO
									cZ57_TITULO	:= SE1->E1_NUM
									cZ57_PARCEL	:= SE1->E1_PARCELA
									cZ57_TIPO	:= SE1->E1_TIPO
									dZ57_DATEMI	:= SE1->E1_EMISSAO
									cZ57_FLAGBX	:= "N"
									nZ57_VLRNOM	:= Val(SubSTR(cTEXTO,82,15))
									aCONTRATO	:= FCONTREDE(SE1->E1_FILIAL, SE1->E1_NUM, SE1->E1_PREFIXO, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_EMISSAO)
									cZ57_CONTRA	:= aCONTRATO[1]
									cZ57_SEQCON	:= aCONTRATO[2]
									If cZ57_CONTRA == STRINGNULL
										cDESCRI := "Contrato de redes nใo localizado para este tํtulo."									
										U_RJF05Z59(XFILIAL("Z57"), cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON, cZ56_SEQARQ, cZ56_NUMRET, cZ57_IDCNAB, cDESCRI)
									EndIf	
									lIDCNAB := .T.
									
	
								Else

									cSTRING := "Tํtulo localizado ! (Prefixo="+cZ57_PREFIX+" - Tํtulo="+cZ57_TITULO+" - CNPJ="+cCNPJCLIENT+")"
									fGravaLog(hFILELOG,cSTRING) 							
								
								EndIf

							EndIf

							//--Adiciona ao array registro referente ao detalhe | segmento T | ID CNAB
							cSTRING := "Adiciona ao array registro referente ao detalhe | segmento T | ID CNAB: "+cZ57_IDCNAB
							fGravaLog(hFILELOG,cSTRING) 								

							
						//--Registro de Retorno de Detalhe / Segmento X
						ElseIf SubSTR(cTEXTO,8,1) == "3" .and. SubSTR(cTEXTO,14,1) == "X"
						
							If lIDCNAB
								dZ57_DATPGT := CTOD(SubSTR(cTEXTO,39,2)+"/"+SubSTR(cTEXTO,41,2)+"/"+SubSTR(cTEXTO,43,4))
								dZ57_DATECR := CTOD(SubSTR(cTEXTO,122,2)+"/"+SubSTR(cTEXTO,124,2)+"/"+SubSTR(cTEXTO,126,4))
								nZ57_VLRTPG := Val(SubSTR(cTEXTO,024,15))/100
								nZ57_VLRTDC := Val(SubSTR(cTEXTO,047,15))/100
								nZ57_VLRABT := Val(SubSTR(cTEXTO,062,15))/100
								nZ57_VLRAP  := Val(SubSTR(cTEXTO,077,15))/100
								nZ57_VLRAN  := Val(SubSTR(cTEXTO,092,15))/100
								nZ57_VLRNOM := Val(SubSTR(cTEXTO,107,15))/100
	
								aAdd ( aDADOSIMP[_nINDARQ][nPDETALHE], { 	"T", 	cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON,	cZ56_SEQARQ, cZ56_NUMRET, ;
																					cZ57_IDCNAB, cZ57_FILDOC, cZ57_CODCLI,	cZ57_LOJCLI, cZ57_PREFIX, ;
																					cZ57_TITULO, cZ57_PARCEL, cZ57_TIPO,	dZ57_DATEMI, cZ57_FLAGBX, ;
																					cZ57_CONTRA, cZ57_SEQCON, dZ57_DATPGT,	dZ57_DATECR, nZ57_VLRTPG, ;
																					nZ57_VLRTDC, nZ57_VLRABT, nZ57_VLRAP,	nZ57_VLRAN,  nZ57_VLRNOM, ;
																					cZ57_IDCIN  } )
							EndIf
							
							//--Adiciona ao array registro referente ao detalhe | segmento T | ID CNAB
							cSTRING := "Adiciona ao array registro referente ao detalhe | segmento X | ID CNAB: "+cZ57_IDCNAB
							fGravaLog(hFILELOG,cSTRING) 								
	
						//--Registro de Retorno de Detalhe / Segmento Z
						ElseIf SubSTR(cTEXTO,8,1) == "3" .and. SubSTR(cTEXTO,14,1) == "Z" 

							If lIDCNAB
								
								cZ58_CODOCR := SubSTR(cTEXTO,018,05)								
								//cZ58_CODCED := SubSTR(cTEXTO,023,20)
								//cZ58_DESOCR := SubSTR(cTEXTO,043,50)
								cZ58_CODCED := SubSTR(cTEXTO,043,50)
								nZ58_VLROCR := Val(SubSTR(cTEXTO,093,15))/100
								cZ58_CMPDOC := SubSTR(cTEXTO,129,09)
								cZ58_CMPSER := SubSTR(cTEXTO,139,03)
								cZ58_DESOCR := STRINGNULL
								cZ58_CODIND	:= STRINGNULL
								cZ58_DESIND	:= STRINGNULL
								cZ58_OPERAC	:= STRINGNULL
								
								dbSelectArea("SA1")
								dbSetOrder(1)
								If dbSeek( xFilial("SA1") + cZ57_CODCLI + cZ57_LOJCLI )
									If !Empty(SA1->A1_X_CRCIN)
										dbSelectArea("Z68")
										dbSetOrder(1)
										If dbSeek(xFilial("Z68")+SA1->A1_X_CRCIN)
											While !Z68->(EOF()) .and. Z68->(Z68_FILIAL+Z68_CODRED) == xFilial("Z68")+SA1->A1_X_CRCIN
												If ALLTRIM(Z68->Z68_CODCED) $ cZ58_CODCED 
													cZ58_CODIND	:= Z68->Z68_CODIND
													cZ58_DESIND	:= Z68->Z68_DESCRI												
													cZ58_OPERAC	:= Z68->Z68_OPERAC												
												EndIf                             
												If ALLTRIM(Z68->Z68_CODCED) $ cZ58_CODOCR
													cZ58_DESOCR := Z68->Z68_DESCRI
													If ALLTRIM(cZ58_CODCED) == STRINGNULL
														cZ58_CODIND	:= Z68->Z68_CODIND
														cZ58_DESIND	:= Z68->Z68_DESCRI												
														cZ58_OPERAC	:= Z68->Z68_OPERAC												
													EndIf
												EndIf
												Z68->(dbSkip())
											Enddo
										EndIf
									EndIf
								EndIf
	
								aAdd ( aDADOSIMP[_nINDARQ][nPDETALHE], { 	"Z", 	cZ56_CODBCO, cZ56_CODAGE, cZ56_NUMCON, cZ56_SEQARQ, cZ56_NUMRET, ;
																					cZ57_IDCNAB, cZ58_CODOCR, cZ58_DESOCR, cZ58_CODCED, nZ58_VLROCR, ;
																					cZ58_CODIND, cZ58_DESIND, cZ58_OPERAC, cZ58_CMPDOC, cZ58_CMPSER } )

								//--Adiciona ao array registro referente ao detalhe | segmento Z | ID CNAB
								cSTRING := "Adiciona ao array registro referente ao detalhe | segmento Z | ID CNAB: "+cZ57_IDCNAB
								fGravaLog(hFILELOG,cSTRING) 								
	
							EndIf
							
						//--Registro de Trailer de Lote = 5
						ElseIf SubSTR(cTEXTO,8,1) == "5"

						//--Registro de Trailer de Arquivo = 9
						ElseIf SubSTR(cTEXTO,8,1) == "9"

						EndIf
						fT_fSkip()
					End While
					fT_fUse()
					
					If cZ56_CODBCO != STRINGNULL .AND. cZ56_CODAGE != STRINGNULL .AND. cZ56_NUMCON != STRINGNULL .AND. cZ56_SEQARQ != STRINGNULL .AND. cZ56_NUMRET != STRINGNULL
						
						Begin Transaction
						
							//--Verifica se o arquivo jแ foi importado.
							cKERYREGZ56 := xFilial("Z56") + cZ56_CODBCO + cZ56_CODAGE + cZ56_NUMCON + cZ56_SEQARQ + cZ56_NUMRET
							dbSelectArea("Z56")
							Z56->(dbSetOrder(1))
							Z56->(dbGoTop())
							If !Z56->(dbSeek(cKERYREGZ56))
								//--Cabe็alho do arquivo
								If Len(aDADOSIMP[_nINDARQ][nPHEADARQ]) > 0	
									nTAMIMP := Len(aDADOSIMP[_nINDARQ][nPHEADARQ])
									If RecLock("Z56",.T.)									
										Z56->Z56_FILIAL := xFilial("Z56")
										Z56->Z56_CODBCO := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][01]
										Z56->Z56_CODAGE := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][02]
										Z56->Z56_NUMCON := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][03]
										Z56->Z56_SEQARQ := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][04]
										Z56->Z56_DATARQ := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][05]
										Z56->Z56_HORARQ := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][06]
										Z56->Z56_NUMRET := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][07]
										Z56->Z56_CMPDEV := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][08]
										Z56->Z56_ARQBXR := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][09]
										Z56->Z56_TIPARQ := aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][10]
										Z56->(MsUnLock())
									EndIf
                  
									//--Dados de header gravados (Z56)
									cSTRING := "Dados de header gravados (Z56) "+cKERYREGZ56
									fGravaLog(hFILELOG,cSTRING) 	
	
								Else
									//--Nใo existem dados de cabe็alho.
									cSTRING := "Nใo existem dados de cabe็alho."
									fGravaLog(hFILELOG,cSTRING) 									
								EndIf
								
								//--Itens de detalhe
								If Len(aDADOSIMP[_nINDARQ][nPDETALHE]) > 0
									For nDET := 1 to Len(aDADOSIMP[_nINDARQ][nPDETALHE])
										If aDADOSIMP[_nINDARQ][nPDETALHE][nDET][01] == "T"
											If RecLock("Z57",.T.)									
												Z57->Z57_FILIAL := xFilial("Z57")
												Z57->Z57_CODBCO := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][02]
												Z57->Z57_CODAGE := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][03]
												Z57->Z57_NUMCON := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][04]
												Z57->Z57_SEQARQ := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][05]
												Z57->Z57_NUMRET := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][06]
												Z57->Z57_IDCNAB := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][07]
												Z57->Z57_FILDOC := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][08]
												Z57->Z57_CODCLI := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][09]
												Z57->Z57_LOJCLI := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][10]
												Z57->Z57_PREFIX := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][11]
												Z57->Z57_TITULO := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][12]
												Z57->Z57_PARCEL := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][13]
												Z57->Z57_TIPO	:= aDADOSIMP[_nINDARQ][nPDETALHE][nDET][14]
												Z57->Z57_DATEMI := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][15]
												Z57->Z57_FLAGBX := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][16]
												Z57->Z57_CONTRA := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][17]
												Z57->Z57_SEQCON := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][18]
												Z57->Z57_DATPGT := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][19]
												Z57->Z57_DATECR := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][20]
												Z57->Z57_VLRTPG := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][21]
												Z57->Z57_VLRTDC := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][22]
												Z57->Z57_VLRABT := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][23]
												Z57->Z57_VLRAJP := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][24]
												Z57->Z57_VLRAJN := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][25]
												Z57->Z57_VLRNOM := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][26]
												Z57->Z57_IDCIN  := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][27]
												Z57->(MsUnLock())
                    						EndIf

											dbSelectArea("SE1")
											SE1->(dbSetOrder(19))	//--E1_IDCNAB
											SE1->(dbGoTop())
											If SE1->(dbSeek(aDADOSIMP[_nINDARQ][nPDETALHE][nDET][07])).and.aDADOSIMP[_nINDARQ][nPDETALHE][nDET][07]!=STRINGNULL
												If RecLock("SE1",.F.)
													If aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][10] == "02"	//--Entrada Confirmada
														SE1->E1_X_IDCIN := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][27]
													ElseIf aDADOSIMP[_nINDARQ][nPHEADARQ][nTAMIMP][10] == "30"	//--Previsใo
														SE1->E1_VENCTO  := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][20]
														SE1->E1_VENCREA := DataValida(aDADOSIMP[_nINDARQ][nPDETALHE][nDET][20])
													EndIf
													SE1->(MsUnLock())
												EndIf              
											EndIf


											//--Dados de detalhe | segmento T | gravados (Z57)
											cSTRING := "Dados de detalhe | segmento T | gravados (Z57) "+cKERYREGZ56
											fGravaLog(hFILELOG,cSTRING) 	
		
										Else	//--Segmento Z
										
											If RecLock("Z58",.T.)									
												Z58->Z58_FILIAL := xFilial("Z58")
												Z58->Z58_CODBCO := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][02]
												Z58->Z58_CODAGE := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][03]
												Z58->Z58_NUMCON := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][04]
												Z58->Z58_SEQARQ := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][05]
												Z58->Z58_NUMRET := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][06]
												Z58->Z58_IDCNAB := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][07]
												Z58->Z58_CODOCR := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][08]
												Z58->Z58_DESOCR := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][09]
												Z58->Z58_CODCED := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][10]
												Z58->Z58_VLROCR := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][11]
												Z58->Z58_CODIND := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][12]
												Z58->Z58_DESIND := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][13]
												Z58->Z58_OPERAC := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][14]
												Z58->Z58_CMPDOC := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][15]
												Z58->Z58_CMPSER := aDADOSIMP[_nINDARQ][nPDETALHE][nDET][16]
												Z58->(MsUnLock())										
											EndIf

											//--Dados de detalhe | segmento Z | gravados (Z58)
											cSTRING := "Dados de detalhe | segmento Z | gravados (Z58) "+cKERYREGZ56
											fGravaLog(hFILELOG,cSTRING) 	

										EndIf
									Next nDET
								Else
									cSTRING := "Nใo existem dados de detalhe."
									fGravaLog(hFILELOG,cSTRING) 									
								EndIf
								
							Else
								//--Arquivo jแ importado.
								cSTRING := "Arquivo jแ importado."
								fGravaLog(hFILELOG,cSTRING) 
							EndIf
							
							//--Renomeia o arquivo importado.
							fRename(CPATHFILE2+aDADOSIMP[_nINDARQ][02], CPATHFILE2+cFILENAME+"imp" )						
							
							cSTRING := "Arquivo renomeado."
							fGravaLog(hFILELOG,cSTRING) 
						
						End Transaction
						
					EndIf
					
				Else
					//--CNPJ nใo existente no sigamat.
					cSTRING := "CNPJ nใo existente no SIGAMAT."
					fGravaLog(hFILELOG,cSTRING) 
				EndIf
				
				cSTRING := "Fim do processamento do arquivo."
				fGravaLog(hFILELOG,cSTRING) 

				//--Fecha arquivo de log.
				fClose(hFILELOG)		
				
			Next _nINDARQ
		EndIf 
	Else
		//--Nใo existem arquivos para importa็ใo.
	EndIf     
	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFCONTREDE บAutor  ณTOTVS PARANA CENTRALบ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para recuperar o contrato relacionado ao tํtulo.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function FCONTREDE(cCodFil, cCodDoc, cCodSer, cCodCli, cCodLoj, dEmissao)               
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()             
Local cAliasTMP	:= GetNextAlias()
Local cNUMCON 	:= STRINGNULL
Local cSEQCON	:= STRINGNULL
Local cCLVL		:= STRINGNULL

	dbSelectArea("SD2")
	dbSetOrder(3)	//D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbGoTop()
	If dbSeek ( cCodFil + cCodDoc + cCodSer + cCodCli + cCodLoj )
		dbSelectArea("SC5")
		dbSetOrder(1)
		dbGoTop()
		If dbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO)
			cCLVL := SC5->C5_X_CLVL
		EndIf
	EndIf		

	If cCLVL != STRINGNULL
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Verifica a exist๊ncia de contratos de redes para o cliente ...       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		cQuery := " SELECT 		Z54.Z54_FILIAL, Z54.Z54_NUMERO, Z54.Z54_SEQUEN,							"
		cQuery += "         	Z54.Z54_TIPOCT, Z54.Z54_CLIENT, Z54.Z54_LOJACL                 			"
		cQuery += " FROM 		"+RetSQLName("Z54")+" Z54												"
		cQuery += " WHERE		Z54.Z54_TIPOCT	= 'C'		 											"
		cQuery += " AND			Z54.Z54_ATIVO		= 'S'		 										"
		cQuery += " AND			(( 	Z54.Z54_CLIENT	= '"+cCodCli+"'  	 								"
		cQuery += " AND				Z54.Z54_LOJACL	= '"+Space(TAMSX3("Z54_LOJACL")[1])+"' )			"	
		cQuery += " OR				( 	Z54.Z54_CLIENT	= '"+cCodCli+"' 								"
		cQuery += " AND				Z54.Z54_LOJACL	= '"+cCodLoj+"' ))									"	
		cQuery += " AND			'"+DTOS(dEmissao)+"' BETWEEN Z54.Z54_DATADE AND Z54.Z54_DATATE			"
		cQuery += " AND			Z54.D_E_L_E_T_ != '*'							 						"
		cQuery += " ORDER BY 	Z54.Z54_LOJACL, Z54.Z54_CLIENT DESC										"

		TCQUERY cQuery NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())   	
	  	While !(cAliasTMP)->(EOF())
			dbSelectArea("Z55")
			dbSetOrder(1)
			dbGoTop()
			If dbSeek ( (cAliasTMP)->(Z54_FILIAL+Z54_NUMERO+Z54_SEQUEN+Z54_TIPOCT+Z54_CLIENT+Z54_LOJACL) )
				While !Z55->(EOF()) .and. Z55->(Z55_FILIAL+Z55_NUMERO+Z55_SEQUEN+Z55_TIPOCT+Z55_CLIENT+Z55_LOJACL) == (cAliasTMP)->(Z54_FILIAL+Z54_NUMERO+Z54_SEQUEN+Z54_TIPOCT+Z54_CLIENT+Z54_LOJACL)
					//--Compara็ใo sobre o segmento
					If ALLTRIM(Z55->Z55_CCLVL) == ALLTRIM(cCLVL)
						cNUMCON := Z55->Z55_NUMERO
						cSEQCON := Z55->Z55_SEQUEN
					EndIf
					Z55->(dbSkip())
				Enddo				
				If cNUMCON != STRINGNULL
					Exit
				EndIf
			EndIf              
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
	
	EndIf
	
	RestArea(aAreaTMP)
		

Return({cNUMCON,cSEQCON})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05WIN  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para visualiza็ใo de registros.                      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05WIN(cAlias, nReg, nOpc, xVar, nOper)
*---------------------------------------------------------------------------*
Local aArea			:= GetArea()
Local aPosObj		:= {}
Local aObjects		:= {}
Local aSize			:= MsAdvSize( .F. )
Local aTravas		:= {}  
Local aAlterEnch	:= {}
Local aCpoEnch		:= {}
Local nModelo		:= 3
Local nRegE			:= 0
Local lColumn		:= .F. 
Local lF3			:= .F. 
Local lMemoria		:= .T.
Local lNoFolder		:= .F. 
Local lProperty		:= .F. 
Local lDelete		:=  IIf ( nOpc == 5 , .T., .F.)
Local bCampo		:= {|nCPO| Field(nCPO)}
Local aPages		:= {}
Local nOpcNewGd		:= IIf ( nOpc == 2 , 0 , GD_INSERT + GD_UPDATE + GD_DELETE )
Local cKERYREG 		:= Z56->(Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)
Local cAliasZ56		:= "Z56"
Local cEntidZ57		:= "Z57"
Local cEntidZ58		:= "Z58"
Local cEntidZ59		:= "Z59"
Local cSeekZ57		:= STRINGNULL
Local cSeekZ58		:= STRINGNULL
Local cSeekZ59		:= STRINGNULL
Local lGravou		:= .F.
Local lTravas		:= .T.
Local nCntFor		:= 0
Local nUsado		:= 0
Local nOpcA			:= 0
Local nOpcVisul		:= 0
Local aRecZ57		:= {}
Local aRecZ58		:= {}
Local aRecZ59		:= {}
Local aButtons   	:= {} 

PRIVATE aColsZ57	:= {}
PRIVATE aHeadZ57	:= {}
PRIVATE oGetZ57
PRIVATE aColsZ58	:= {}
PRIVATE aHeadZ58	:= {}
PRIVATE aColsZ58Cp	:= {}
PRIVATE oGetZ58
PRIVATE aColsZ59	:= {}
PRIVATE aHeadZ59	:= {}
PRIVATE aColsZ59Cp	:= {}
PRIVATE oGetZ59
PRIVATE oDlgEmp

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	aAdd ( aButtons , { "NOTE",		{ || U_RJFP4FIL() }, OemtoAnsi("Filtrar pelo IDCNAB"),	OemtoAnsi("Filtrar")	} )
	aAdd ( aButtons , { "NOTE", 	{ || U_RJFP4CLR() }, OemtoAnsi("Limpar Filtro"),		OemtoAnsi("Limpar") 	} )
	aAdd ( aButtons , { "NOTE", 	{ || U_RJFP4EXP() }, OemtoAnsi("Exportar Excel"),		OemtoAnsi("Exportar") 	} )

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPega os dados dos campos da tabela SZP no SX3 para montagem do Enchoice         ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea(cAliasZ56)
	RegToMemory(cAliasZ56, .T., .T., .T.)                                          

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณAtribui aos Campos registrados os valores do registro da tabela posicionado     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If nOpc != 3
		For i := 1 TO FCount()
			M->&(Eval(bCampo, i)) := FieldGet(i)
		Next i                  
	EndIf
	            
	
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cAliasZ56)
	While !Eof().and.(x3_arquivo==cAliasZ56)
		If X3USO(x3_usado).and.cNivel>=x3_nivel
			AADD(aCpoEnch,x3_campo)
		Endif
		dbSkip()
	End                     

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ57 - TABELA Z57                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ57)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ57 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z57_CODBCO/Z57_CODAGE/Z57_NUMCON/Z57_SEQARQ/Z57_NUMRET" )
			nUsado++
			aAdd(aHeadZ57,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
		EndIf
		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z57                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
	
		dbSelectArea(cEntidZ57)
		dbSetOrder(1)
	 	(cEntidZ57)->(dbGoTop())
	    
		cSeekZ57 := xFilial( cEntidZ57 ) + cKERYREG
	
		If (cEntidZ57)->( MsSeek( cSeekZ57 ) )
			While ( !Eof() .And. cSeekZ57 == Z57->Z57_FILIAL + Z57->(Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET) )
	
				If ( SoftLock(cEntidZ57 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ57,Array(nUsado+1))
					AAdd(aRecZ57, (cEntidZ57)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ57[nCntFor][10] != "V" )
							aColsZ57[Len(aColsZ57)][nCntFor] := Z57->(FieldGet(FieldPos(aHeadZ57[nCntFor][2])))
						Else
							aColsZ57[Len(aColsZ57)][nCntFor] := CriaVar(aHeadZ57[nCntFor,2])
						EndIf
					Next
					aColsZ57[Len(aColsZ57)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ57)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ57 )
		AAdd(aColsZ57,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ57[1,nCntFor] := CriaVar(aHeadZ57[nCntFor,2], .F. )
		Next nCntFor
		aColsZ57[1][nUsado+1] := .F.
	EndIf
	


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ58 - TABELA Z58                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nUsado := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ58)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ58 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z58_CODBCO/Z58_CODAGE/Z58_NUMCON/Z58_SEQARQ/Z58_NUMRET" )
			nUsado++
			aAdd(aHeadZ58,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
		EndIf
		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z58                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
	
		dbSelectArea(cEntidZ58)
		dbSetOrder(1)
	 	(cEntidZ58)->(dbGoTop())
	    
		cSeekZ58 := xFilial( cEntidZ58 ) + cKERYREG
	
		If (cEntidZ58)->( MsSeek( cSeekZ58 ) )
			While ( !Eof() .And. cSeekZ58 == Z58->Z58_FILIAL + Z58->(Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET) )
	
				If ( SoftLock(cEntidZ58 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ58,Array(nUsado+1))
					AAdd(aRecZ58, (cEntidZ58)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ58[nCntFor][10] != "V" )
							aColsZ58[Len(aColsZ58)][nCntFor] := Z58->(FieldGet(FieldPos(aHeadZ58[nCntFor][2])))
						Else
							aColsZ58[Len(aColsZ58)][nCntFor] := CriaVar(aHeadZ58[nCntFor,2])
						EndIf
					Next
					aColsZ58[Len(aColsZ58)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ58)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ58 )
		AAdd(aColsZ58,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ58[1,nCntFor] := CriaVar(aHeadZ58[nCntFor,2], .F. )
		Next nCntFor
		aColsZ58[1][nUsado+1] := .F.
	EndIf
	
	aColsZ58Cp := aClone(aColsZ58)


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aHeadZ59 - TABELA Z59                                        ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	nUsado := 0
	dbSelectArea("SX3")
	dbSetOrder(1)
	dbSeek(cEntidZ59)
	While ( !SX3->( Eof() ) .And. SX3->X3_ARQUIVO==cEntidZ59 )
		If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. ;
				!AllTrim(SX3->X3_CAMPO) $ "Z59_CODBCO/Z59_CODAGE/Z59_NUMCON/Z59_SEQARQ/Z59_NUMRET" )
			nUsado++
			aAdd(aHeadZ59,{AllTrim(X3Titulo()),;
					              SX3->X3_CAMPO,;
					              SX3->X3_PICTURE,;
					              SX3->X3_TAMANHO,;
					              SX3->X3_DECIMAL,;
					              SX3->X3_VALID,;
					              SX3->X3_USADO,;
					              SX3->X3_TIPO,;
					              SX3->X3_F3,;
					              SX3->X3_CONTEXT,;
					              SX3->X3_CBOX,;
					              SX3->X3_RELACAO,;
					              ".T."})				
		EndIf
		SX3->( dbSkip() )
	EndDo        
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontagem do aCols - TABELA Z59                                          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If nOpc != 3
	
		dbSelectArea(cEntidZ59)
		dbSetOrder(1)
	 	(cEntidZ59)->(dbGoTop())
	    
		cSeekZ59 := xFilial( cEntidZ59 ) + cKERYREG
	
		If (cEntidZ59)->( MsSeek( cSeekZ59 ) )
			While ( !Eof() .And. cSeekZ59 == Z59->Z59_FILIAL + Z59->(Z59_CODBCO+Z59_CODAGE+Z59_NUMCON+Z59_SEQARQ+Z59_NUMRET) )
	
				If ( SoftLock(cEntidZ59 ) )
					AAdd(aTravas,{ Alias() , RecNo() })
					AAdd(aColsZ59,Array(nUsado+1))
					AAdd(aRecZ59, (cEntidZ59)->( Recno() ) )
					For nCntFor := 1 To nUsado
						If ( aHeadZ59[nCntFor][10] != "V" )
							aColsZ59[Len(aColsZ59)][nCntFor] := Z59->(FieldGet(FieldPos(aHeadZ59[nCntFor][2])))
						Else
							aColsZ59[Len(aColsZ59)][nCntFor] := CriaVar(aHeadZ59[nCntFor,2])
						EndIf
					Next
					aColsZ59[Len(aColsZ59)][nUsado+1] := .F.
				Else
					lTravas := .F.
				EndIf
				(cEntidZ59)->( dbSkip()   )
			EndDo
		EndIf
	
	EndIf
	
	If Empty( aColsZ59 )
		AAdd(aColsZ59,Array(nUsado+1))
		For nCntFor := 1 To nUsado
			aColsZ59[1,nCntFor] := CriaVar(aHeadZ59[nCntFor,2], .F. )
		Next nCntFor
		aColsZ59[1][nUsado+1] := .F.
	EndIf
	
	aColsZ59Cp := aClone(aColsZ59)
	

	If ( lTravas )

		AAdd( aObjects, { 070, 100, .T., .F. } )
		AAdd( aObjects, { 100, 100, .T., .T. } )

		aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 2 }
		aPosObj := MsObjSize( aInfo, aObjects )

		DEFINE MSDIALOG oDlgEmp TITLE cCadastro FROM aSize[7],00 TO aSize[6],aSize[5] OF oMainWnd PIXEL

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Cabe็alho                                                    ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		Enchoice(cAliasZ56,nRegE,nOpc,,,,aCpoEnch,{013,aPosObj[1,2],105,aPosObj[1,4]},aAlterEnch,nModelo,,,'',oDlgEmp,lF3,lMemoria,lColumn,,lNoFolder,lProperty)
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Pastas                                                       ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		oFolder := TFolder():New( aPosObj[2,1],aPosObj[2,2],{"Tํtulos","Ocorr๊ncias","Opera็๕es"},aPages,oDlgEmp,,,,.T.,.F.,aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1])
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Grid de Exibi็ใo                                             ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			

		oGetZ57 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "AllwaysTrue()", "AllwaysTrue()", , , 000, 99,, STRINGNULL, .T., oFolder:aDialogs[1], aHeadZ57 ,aColsZ57 )
		oGetZ58 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "AllwaysTrue()", "AllwaysTrue()", , , 000, 99,, STRINGNULL, .T., oFolder:aDialogs[2], aHeadZ58 ,aColsZ58 )
		oGetZ59 := MsNewGetDados():New( 5, 5, aPosObj[2,3]-aPosObj[2,1]-20,aPosObj[2,4]-aPosObj[2,2]-6, nOpcNewGd, "AllwaysTrue()", "AllwaysTrue()", , , 000, 99,, STRINGNULL, .T., oFolder:aDialogs[3], aHeadZ59 ,aColsZ59 )

		ACTIVATE MSDIALOG oDlgEmp ON INIT EnchoiceBar(oDlgEmp,{||nOpcA:=1,If(oGetZ57:TudoOk().AND.oGetZ58:TudoOk().AND.oGetZ59:TudoOk(),oDlgEmp:End(),nOpcA:=0)},{||oDlgEmp:End()},,aButtons)
	
	EndIf
	
	For nCntFor := 1 To Len(aTravas)
		dbSelectArea(aTravas[nCntFor][1])
		dbGoto(aTravas[nCntFor][2])
		MsUnLock()
	Next nCntFor

	RestArea( aArea )

Return(lGravou) 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFP4FIL  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAplica filtro pelo IDCNAB.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJFP4FIL()
*---------------------------------------------------------------------------*
Local nPIDCZ57	:= aScan(oGetZ57:aHeader,{|x| AllTrim(x[2])=="Z57_IDCNAB"})
Local nPIDCZ58	:= aScan(oGetZ58:aHeader,{|x| AllTrim(x[2])=="Z58_IDCNAB"})
Local nPIDCZ59	:= aScan(oGetZ59:aHeader,{|x| AllTrim(x[2])=="Z59_IDCNAB"})

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	oGetZ58:aCols := aClone(aColsZ58Cp)
	oGetZ59:aCols := aClone(aColsZ59Cp)
	
	If Len(oGetZ58:aCols) > 0 .and. oGetZ57:nAT != 0
		nI := 1
		While nI <= Len(oGetZ58:aCols)
			If oGetZ57:aCols[oGetZ57:nAT,nPIDCZ57] != oGetZ58:aCols[nI,nPIDCZ58]
				oGetZ58:aCols := aDel(oGetZ58:aCols,nI)
				oGetZ58:aCols := aSize(oGetZ58:aCols,Len(oGetZ58:aCols)-1)
			Else
				nI += 1
			EndIf
		End While 
	EndIf
	
	If Len(oGetZ59:aCols) > 0 .and. oGetZ57:nAT != 0
		nI := 1
		While nI <= Len(oGetZ59:aCols)
			If oGetZ57:aCols[oGetZ57:nAT,nPIDCZ57] != oGetZ59:aCols[nI,nPIDCZ59]
				oGetZ59:aCols := aDel(oGetZ59:aCols,nI)
				oGetZ59:aCols := aSize(oGetZ59:aCols,Len(oGetZ59:aCols)-1)
			Else
				nI += 1
			EndIf
		End While
	EndIf
	
	oGetZ58:ForceRefresh()
	oGetZ59:ForceRefresh()
	oDlgEmp:Refresh()	

Return
                      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFP4EXP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExporta็ใo de registros Microsoft Excel.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJFP4EXP()
*---------------------------------------------------------------------------*
Local aAreaTMP := GetArea()
Local oFwMsEx 	:= NIL
Local oGetSEL	:= NIL
Local cTipo 	:= "Arquivos XLS | *.XLS" 
Local cTitulo 	:= "Gerar XLS"
Local cDirSEL	:= ""
Local cArqSEL	:= "" 
Local cWorkSEL 	:= ""
Local cTableSEL	:= ""

	nARQ := Aviso("Aviso","Selecione de qual aba deseja gerar o arquivo Excel.",{"Tํtulos","Ocorr๊ncias","Opera็๕es","Cancelar"})
	
	If nARQ == 4
		Return
	ElseIf nARQ == 1
		cTableSEL	:= "Rela็ใo de Tํtulos"
		cWorkSEL 	:= "Titulos"
		cArqSEL		:= "Neogrid_Titulos_" + Z56->(Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET) +".xls"
		oGetSEL		:= oGetZ57 		
	ElseIf nARQ == 2
		cTableSEL	:= "Rela็ใo de Ocorr๊ncias"
		cWorkSEL 	:= "Ocorrencias"
		cArqSEL		:= "Neogrid_Ocorrencias_" + Z56->(Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET) +".xls" 		
		oGetSEL		:= oGetZ58
	Else                                                                                                                
		cTableSEL	:= "Rela็ใo de Opera็๕es"
		cWorkSEL 	:= "Operacoes"
		cArqSEL		:= "Neogrid_Operacoes_" + Z56->(Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET) +".xls" 			
		oGetSEL		:= oGetZ59
	EndIf

	cDirSEL := cGetFile( cTipo , "Selecione o local para salvar o arquivo...", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
                                                        
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
	//ณInstancia a classe que permite gerar arquivo XLSณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤะ
	
	oFwMsEx := FWMsExcel():New()	
	
	oFwMsEx:SetBgColorHeader('#C0C0C0') 
	oFwMsEx:SetLineBgColor('#FFFFFF') 
	oFwMsEx:Set2LineBgColor('#FFFFFF')
	
    oFwMsEx:SetFontSize(8)
	oFwMsEx:AddWorkSheet( cWorkSEL )
	oFwMsEx:AddTable( cWorkSEL, cTableSEL )
	
	For nI := 1 to Len(oGetSEL:aHeader)
		oFwMsEx:AddColumn( cWorkSEL, cTableSEL, oGetSEL:aHeader[nI][1], 1, 1)
	Next nI                            
	If nARQ == 2                                                         
		oFwMsEx:AddColumn( cWorkSEL, cTableSEL, "Existe NCC C.R.", 1, 1)
	EndIf

	For nX := 1 to Len(oGetSEL:aCols)
		aDADOS := Array( Len(oGetSEL:aHeader)+IIF(nARQ==2,1,0) )
		For nI := 1 to Len(oGetSEL:aHeader)
			aDADOS[nI] := oGetSEL:aCols[nX][nI]
		Next nI     
		If nARQ == 2
			aDADOS[Len(oGetSEL:aHeader)+1] := fExistSE1(nX)
		EndIf		
		oFwMsEx:AddRow( cWorkSEL, cTableSEL, aClone(aDADOS)  )
	Next nX

	oFwMsEx:Activate()
	
	LjMsgRun( "Gerando o arquivo, aguarde...", cTitulo, {|| oFwMsEx:GetXMLFile( cArqSEL ) } )
	If __CopyFile( cArqSEL, cDirSEL + cArqSEL )
		If MsgYesNo("Deseja abrir o arquivo gerado?","Abrir arquivo")
			oExcelApp := MsExcel():New()
			oExcelApp:WorkBooks:Open( cDirSEL + cArqSEL )
		 	oExcelApp:SetVisible(.T.)
		EndIf
	Else
		MsgInfo( "Arquivo nใo copiado para temporแrio do usuแrio." )
	Endif  

	
	RestArea(aAreaTMP)


Return
            
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFP4CLR  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpa filtro do IDCNAB.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fExistSE1(nPOS)                                                  
*---------------------------------------------------------------------------*
Local cRet := "N"
Local nPIDCZ57	:= aScan(oGetZ57:aHeader,{|x| AllTrim(x[2])=="Z57_IDCNAB"})
Local nPCODCLI	:= aScan(oGetZ57:aHeader,{|x| AllTrim(x[2])=="Z57_CODCLI"})
Local nPLOJCLI	:= aScan(oGetZ57:aHeader,{|x| AllTrim(x[2])=="Z57_LOJCLI"})
Local nPIDCZ58	:= aScan(oGetZ58:aHeader,{|x| AllTrim(x[2])=="Z58_IDCNAB"})
Local nPCMPDOC	:= aScan(oGetZ58:aHeader,{|x| AllTrim(x[2])=="Z58_CMPDOC"})
Local nPCMPSER	:= aScan(oGetZ58:aHeader,{|x| AllTrim(x[2])=="Z58_CMPSER"})	
	
	If !Empty(oGetZ58:aCols[nPOS][nPCMPDOC]) .and. !Empty(oGetZ58:aCols[nPOS][nPCMPSER])			
		nPOSZ57 := aScan ( oGetZ57:aCols, { |x| x[nPIDCZ57] == oGetZ58:aCols[nPOS][nPIDCZ58] } )
		If nPOSZ57 > 0 
			cRet := fBuscaNCC(oGetZ57:aCols[nPOSZ57][nPCODCLI],oGetZ57:aCols[nPOSZ57][nPLOJCLI],oGetZ58:aCols[nPOS][nPCMPDOC],oGetZ58:aCols[nPOS][nPCMPSER])
		EndIf
	EndIf
	        
Return (cRet)
                                      
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFP4CLR  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLimpa filtro do IDCNAB.                                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJFP4CLR()
*---------------------------------------------------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	oGetZ58:aCols := aClone(aColsZ58Cp)
	oGetZ59:aCols := aClone(aColsZ59Cp)
		
	oGetZ58:ForceRefresh()
	oGetZ59:ForceRefresh()
	oDlgEmp:Refresh()	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05CMP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de compensa็๕es de tํtulos recebidos.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05CMP()
*---------------------------------------------------------------------------*

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If Z56->Z56_TIPARQ != "09"
		Aviso("Aviso","Esta opera็ใo poderแ ser realizada apenas para registros de Arq. de baixas NeoGrid.",{"OK"})
		Return
	EndIf

	If Z56->Z56_CMPDEV == "S"
		If Aviso("Aviso","Processo de compensa็๕es jแ realizado para este arquivo! Deseja realizar este procedimento novamente?",{"Sim","Nใo"}) != 1
			Return
		EndIf
	EndIf

	MsAguarde( {|| F05CMP() }, "Compensando tํtulos... Aguarde!")	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF05CMP    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de compensa็๕es de tํtulos recebidos.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function F05CMP()
*---------------------------------------------------------------------------*
Local aAreaTMP  := GetArea()
Local cAliasTMP := GetNextAlias()
Local cFilOld	:= cFilAnt
Local aTITREC	:= {}
Local aTITNCC	:= {}
	
	dbSelectArea("Z57")
	Z57->(dbSetOrder(1))
	Z57->(dbGoTop())
	If Z57->(dbSeek(Z56->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)))
		While !Z57->(EOF()) .and. Z57->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET) == Z56->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)

			aTITREC	:= {}
			aTITNCC	:= {}	
			//--Posiciona sobre tํtulo a receber			
			dbSelectArea("SE1")
			SE1->(dbSetOrder(1))
			SE1->(dbGoTop())
			If SE1->(dbSeek(Z57->(Z57_FILDOC+Z57_PREFIX+Z57_TITULO+Z57_PARCEL+Z57_TIPO)))

				aAdd ( aTITREC, SE1->(RECNO()) )
				nSLDTIT := SE1->E1_SALDO
				cCNPJCLIENT := POSICIONE("SA1",1,XFILIAL("SA1")+Z57->(Z57_CODCLI+Z57_LOJCLI),"A1_CGC")
				
				//--Busca registro de devolu็ใo referente ao documento do tํtulo a receber.
				dbSelectArea("Z58")
				dbSetOrder(1)	//--Z58_FILIAL+Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET+Z58_IDCNAB 
				If dbSeek(Z57->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB))
					While !Z58->(EOF()) .and. 	Z58->(Z58_FILIAL+Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET+Z58_IDCNAB)  == ;
												Z57->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)
						If Z58->Z58_OPERAC == "C" .and. !Empty(Z58->Z58_CMPDOC) .and. !Empty(Z58->Z58_CMPSER)
							nRECSE1 := 0
							If fBuscaTIT(Z58->Z58_CMPSER,Z58->Z58_CMPDOC,"NCC",cCNPJCLIENT,@nRECSE1)
								dbSelectArea("SE1")
								SE1->(dbGoTo(nRECSE1))
								If SE1->E1_SALDO > 0 
									aAdd ( aTITNCC, SE1->(RECNO()) )
									cDESCRI := "Tํtulo de devolu็ใo - prefixo: "+SE1->E1_PREFIXO+" - n๚mero: "+SE1->E1_NUM+" - parcela: "+SE1->E1_PARCELA
									U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)	
								Else                      
									cDESCRI := "Tํtulo de devolu็ใo - prefixo: "+SE1->E1_PREFIXO+" - n๚mero: "+SE1->E1_NUM+" - parcela: "+SE1->E1_PARCELA+" nใo possui saldo."
									U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)								
								EndIf
							Else
								cDESCRI := "Tํtulo de devolu็ใo - prefixo: "+Z58->Z58_CMPSER+" - n๚mero: "+Z58->Z58_CMPDOC+" - CNPJ: "+cCNPJCLIENT+" nใo localizado."
								U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)								
							EndIf
						EndIf
						Z58->(dbSkip())
					Enddo
				EndIf
				

				//--Realiza a compensa็ใo dos tํtulos.
				aAreaCMP := GetArea()
				If Len(aTITNCC) > 0 .AND. Len(aTITREC) > 0

					cFilAnt := Z57->Z57_FILDOC
					PERGUNTE("AFI340",.F.)
	                lContabiliza	:= MV_PAR11 == 1
	                lAglutina		:= MV_PAR08 == 1
	                lDigita			:= MV_PAR09 == 1
	  
	                If !MaIntBxCR(3,aTITREC,,aTITNCC,,{lContabiliza,lAglutina,lDigita,.F.,.F.,.F.},,,,,ddatabase)
	                	Help("XAFCMPAD",1,"HELP","XAFCMPAD","Nใo foi possํvel a compensa็ใo"+CRLF+" do tํtulo com NCC",1,0)
						cDESCRI := "Nใo foi possํvel realizar a compensa็ใo para este tํtulo."
						U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)	
	                Else
						cDESCRI := "Compensa็ใo realizada com sucesso para este tํtulo."
						U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)	
	                EndIf			
				Else
					cDESCRI := "Nใo executado processo de compensa็ใo para este tํtulo (nใo localizadas devolu็๕es)."
					U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)	
				EndIf
				RestArea(aAreaCMP)
				
			Else
				cDESCRI := "IDCNAB nใo localizado no contas a receber."
				U_RJF05Z59(Z57->Z57_FILIAL, Z57->Z57_CODBCO, Z57->Z57_CODAGE, Z57->Z57_NUMCON, Z57->Z57_SEQARQ, Z57->Z57_NUMRET, Z57->Z57_IDCNAB, cDESCRI)	
			EndIf
			
			Z57->(dbSkip())
		Enddo
	EndIf
	
	If RecLock("Z56",.F.)
		Z56->Z56_CMPDEV := "S"
		Z56->(MsUnLock())
	EndIf
	
	If cFilOld != cFilAnt
		cFilAnt := cFilOld
	EndIf
	
	Aviso("Aviso","Processo de compensa็ใo concluํdo!",{"OK"})
	
	RestArea(aAreaTMP)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05Z59  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por gravar registros sobre a tabela de   บฑฑ
ฑฑบ          ณinconsist๊ncias Z59.                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05Z59(cFILIAL, cCODBCO, cCODAGE, cNUMCON, cSEQARQ, cNUMRET, cIDCNAB, cDESCRI)
*---------------------------------------------------------------------------*
Local lRet := .T.
Local aAreaTMP := GetArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If RecLock("Z59",.T.) 
		Z59->Z59_FILIAL := cFILIAL
		Z59->Z59_CODBCO := cCODBCO
		Z59->Z59_CODAGE := cCODAGE
		Z59->Z59_NUMCON := cNUMCON
		Z59->Z59_SEQARQ := cSEQARQ
		Z59->Z59_NUMRET := cNUMRET
		Z59->Z59_IDCNAB := cIDCNAB
		Z59->Z59_DATAIN := ddatabase
		Z59->Z59_HORAIN := SubSTR(Time(),1,5)		
		Z59->Z59_DESCRI := cDESCRI
	Else
		lRet := .F.
	EndIf
		               
	RestArea(aAreaTMP)

Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RER  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio extrato de retorno.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05RER()
*---------------------------------------------------------------------------*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
Private cDesc2			:= "de acordo com os parametros informados pelo usuario."
Private cDesc3			:= ""
Private cPict			:= ""
Private titulo			:= "EXTRATO DE RETORNO - COBRANวA INTELIGENTE NEOGRID"
Private nLin			:= 80
Private Cabec1			:= "BANCO    AGสNCIA   CONTA CORRENTE    SEQ.ARQUIVO   NฺM.RETORNO     DATA RET.   HORA RET."
Private Cabec2			:= ""
Private imprime		:= .T.
Private aOrd			:= {}
Private lEnd			:= .F.
Private lAbortPrint	:= .F.
Private CbTxt			:= ""
Private limite			:= 220
Private tamanho		:= "G"
Private nomeprog		:= "RJF05RER" 
Private nTipo			:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private cbtxt			:= Space(10)
Private cbcont			:= 00
Private CONTFL			:= 01
Private m_pag			:= 01
Private wnrel			:= "RJF05RER"
Private cPerg			:= "RJF05RERX1"
Private cString		:= "Z56"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	dbSelectArea(cString)
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RJF05RERSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RptStatus({|| RJF05RERIMP(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RER  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio extrato de retorno.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function RJF05RERIMP(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*
Local cAliasTMP := GetNextAlias()
Local aTOTGERAL := {0, 0, 0, 0, 0, 0}
Local aOCORECEB := {}
Local aOCOTOTAL := {}
Local aINDTOTAL := {}
 
	cQuery := "	SELECT																" + chr(13)
	cQuery += "			Z56.Z56_FILIAL,												" + chr(13)
	cQuery += "			Z56.Z56_CODBCO,												" + chr(13)
	cQuery += "			Z56.Z56_CODAGE,												" + chr(13)
	cQuery += "			Z56.Z56_NUMCON,												" + chr(13)
	cQuery += "			Z56.Z56_SEQARQ,												" + chr(13)
	cQuery += "			Z56.Z56_DATARQ,												" + chr(13)
	cQuery += "			Z56.Z56_HORARQ,												" + chr(13)
	cQuery += "			Z56.Z56_NUMRET,												" + chr(13)
	cQuery += "			Z56.Z56_CMPDEV,												" + chr(13)
	cQuery += "			Z56.Z56_ARQBXR												" + chr(13)
	cQuery += "	FROM " + RetSQLName("Z56") + " Z56		   							" + chr(13)
	cQuery += "	WHERE 									   							" + chr(13)
	cQuery += "			Z56.Z56_CODBCO BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par01 + "' AND '" + mv_par02 + "'					" + chr(13)
	cQuery += "	AND		Z56.Z56_CODAGE BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par03 + "' AND '" + mv_par04 + "'					" + chr(13)
	cQuery += "	AND		Z56.Z56_NUMCON BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'					" + chr(13)
	cQuery += "	AND		Z56.Z56_SEQARQ BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'					" + chr(13)
	cQuery += "	AND		Z56.Z56_NUMRET BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'					" + chr(13)
	cQuery += "	AND		Z56.Z56_DATARQ BETWEEN										" + chr(13)
	cQuery += "			'" + dtos(mv_par11) + "' AND '" + dtos(mv_par12) + "'		" + chr(13)
	//cQuery += "	AND		Z56.Z56_TIPARQ  = '09'										" + chr(13)
	cQuery += "	AND		Z56.D_E_L_E_T_ != '*'										" + chr(13)
	cQuery += "	ORDER BY															" + chr(13)
	cQuery += "			Z56.Z56_FILIAL,												" + chr(13)
	cQuery += "			Z56.Z56_CODBCO,												" + chr(13)
	cQuery += "			Z56.Z56_CODAGE,												" + chr(13)
	cQuery += "			Z56.Z56_NUMCON,												" + chr(13)
	cQuery += "			Z56.Z56_SEQARQ,												" + chr(13)
	cQuery += "			Z56.Z56_DATARQ,												" + chr(13)
	cQuery += "			Z56.Z56_HORARQ,												" + chr(13)
	cQuery += "			Z56.Z56_NUMRET,												" + chr(13)
	cQuery += "			Z56.Z56_CMPDEV,												" + chr(13)
	cQuery += "			Z56.Z56_ARQBXR												" + chr(13)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	If (cAliasTMP)->(!EOF())
		While (cAliasTMP)->(!EOF())
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Cancelado pelo operador . . .                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao dos dados do relatorio . . .                              ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
			//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
			//"BANCO    AGสNCIA   CONTA CORRENTE    SEQ.ARQUIVO   NUM.RETORNO     DATA RET.   HORA RET."

			@nLin,001 PSAY (cAliasTMP)->Z56_CODBCO
			@nLin,010 PSAY (cAliasTMP)->Z56_CODAGE
			@nLin,020 PSAY (cAliasTMP)->Z56_NUMCON
			@nLin,038 PSAY (cAliasTMP)->Z56_SEQARQ
			@nLin,052 PSAY (cAliasTMP)->Z56_NUMRET
			@nLin,068 PSAY DTOC(STOD((cAliasTMP)->Z56_DATARQ))
			@nLin,080 PSAY (cAliasTMP)->Z56_HORARQ
			nLin += 1
			
			nVLRNOM := 0
			nVLRTPG := 0
			nVLRTDC := 0
			nVLRABT := 0
			nVLRAJP := 0
			nVLRAJN := 0
			aOCORECEB := {}		
			
			//--TITULOS RETORNO NEOGRID 
			dbSelectArea("Z57")
			Z57->(dbSetOrder(1))
			If Z57->(dbSeek((cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)))
				While !Z57->(EOF()) .AND. Z57->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET) == ;
											(cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)
	
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Impressao do cabecalho do relatorio. . .                            ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
					If nLin > 55 
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
	
					//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
					//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
					//"FILIAL   CLIENTE   LOJA  PREF. TอTULO    PARC. TIPO  IDCNAB      CONTRATO        EMISSรO     PAGAMENTO   CRษDITO     VALOR TอTULO    VALOR PAGO      VALOR DESCONTO  VALOR ABAT.     AJUSTES (+)       AJUSTES (-)"
					
			
					@nLin,001 PSAY "FILIAL   CLIENTE   LOJA  PREF. TอTULO    PARC. TIPO  IDCNAB      CONTRATO        EMISSรO     PAGAMENTO   CRษDITO     VALOR TอTULO    VALOR PAGO      VALOR DESCONTO  VALOR ABAT.     AJUSTES (+)       AJUSTES (-)"
					nLin += 1
					@nLin,001 PSAY Z57->Z57_FILDOC
					@nLin,010 PSAY Z57->Z57_CODCLI
					@nLin,020 PSAY Z57->Z57_LOJCLI
					@nLin,026 PSAY Z57->Z57_PREFIX
					@nLin,032 PSAY Z57->Z57_TITULO
					@nLin,042 PSAY Z57->Z57_PARCEL
					@nLin,048 PSAY Z57->Z57_TIPO  
					@nLin,054 PSAY Z57->Z57_IDCNAB
					@nLin,066 PSAY Z57->Z57_CONTRA+"-"+Z57->Z57_SEQCON
					@nLin,082 PSAY DTOC(Z57->Z57_DATEMI)
					@nLin,094 PSAY DTOC(Z57->Z57_DATPGT)
					@nLin,106 PSAY DTOC(Z57->Z57_DATECR)
					@nLin,118 PSAY Z57->Z57_VLRNOM PICTURE "@E 999,999,999.99"
					@nLin,134 PSAY Z57->Z57_VLRTPG PICTURE "@E 999,999,999.99"
					@nLin,150 PSAY Z57->Z57_VLRTDC PICTURE "@E 999,999,999.99"
					@nLin,166 PSAY Z57->Z57_VLRABT PICTURE "@E 999,999,999.99"
					@nLin,182 PSAY Z57->Z57_VLRAJP PICTURE "@E 999,999,999.99"
					@nLin,200 PSAY Z57->Z57_VLRAJN PICTURE "@E 999,999,999.99"
					nLin += 1
					
					nVLRNOM += Z57->Z57_VLRNOM
					nVLRTPG += Z57->Z57_VLRTPG
					nVLRTDC += Z57->Z57_VLRTDC
					nVLRABT += Z57->Z57_VLRABT
					nVLRAJP += Z57->Z57_VLRAJP
					nVLRAJN += Z57->Z57_VLRAJN				
					
					//--OCORRENCIAS RETORNO NEOGRID 
					dbSelectArea("Z58")
					Z58->(dbSetOrder(1))
					If Z58->(dbSeek((cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)+Z57->Z57_IDCNAB))
						lIMPTIT := .T.
						nTOTOCO := 0
						While !Z58->(EOF()) .AND. Z58->(Z58_FILIAL+Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET+Z58_IDCNAB) == ;
													(cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)+Z57->Z57_IDCNAB
	
	
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Impressao do cabecalho do relatorio. . .                            ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
							If nLin > 55 
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
			
							//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
							//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
							//"CำDIGO   DESCRIวรO DA OCORRสNCIA                             CำDIGO CEDENTE        CำDIGO IND.           DESCRIวรO IND.                              OPERAวรO   DOC CMP   SERIE     EXISTE C.R.  VALOR"
			
							If lIMPTIT
								@nLin,001 PSAY "CำDIGO   DESCRIวรO DA OCORRสNCIA                             CำDIGO CEDENTE        CำDIGO IND.           DESCRIวรO IND.                              OPERAวรO   DOC CMP   SERIE     EXISTE C.R.  VALOR"
								lIMPTIT := .F.
								nLin += 1
							EndIf
							@nLin,001 PSAY Z58->Z58_CODOCR
							@nLin,010 PSAY Z58->Z58_DESOCR
							@nLin,062 PSAY Z58->Z58_CODCED
							@nLin,084 PSAY Z58->Z58_CODIND
							@nLin,106 PSAY Z58->Z58_DESIND
							@nLin,150 PSAY Z58->Z58_OPERAC
							@nLin,161 PSAY Z58->Z58_CMPDOC
							@nLin,171 PSAY Z58->Z58_CMPSER
							@nLin,181 PSAY fBuscaNCC(Z57->Z57_CODCLI,Z57->Z57_LOJCLI,Z58->Z58_CMPDOC,Z58->Z58_CMPSER)
							@nLin,194 PSAY Z58->Z58_VLROCR PICTURE "@E 999,999,999.99"
							nTOTOCO += Z58->Z58_VLROCR
							nLin += 1
							
							//--OCORRENCIAS DO RECEBIMENTO
							If Len(aOCORECEB) == 0
								nPOSOCOR := 0
							Else
								nPOSOCOR := aScan( aOCORECEB, { |x| x[1] == Z58->Z58_CODOCR } )
							EndIf
							If nPOSOCOR == 0
								aAdd ( aOCORECEB, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
							Else
								aOCORECEB[nPOSOCOR,03] += Z58->Z58_VLROCR
							EndIf
							
							//--TOTAL DAS OCORRENCIAS
							If Len(aOCOTOTAL) == 0
								nPOSTOTAL := 0
							Else
								nPOSTOTAL := aScan( aOCOTOTAL, { |x| x[1] == Z58->Z58_CODOCR } )
							EndIf
							If nPOSTOTAL == 0
								aAdd ( aOCOTOTAL, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
							Else
								aOCOTOTAL[nPOSTOTAL,03] += Z58->Z58_VLROCR
							EndIf           
							
							
							//--TOTAL DAS OCORRENCIAS INDUSTRIA
							If Len(aINDTOTAL) == 0
								nPOSTOTAL := 0
							Else
								nPOSTOTAL := aScan( aINDTOTAL, { |x| x[1] == Z58->Z58_CODIND } )
							EndIf
							If nPOSTOTAL == 0
								aAdd ( aINDTOTAL, { Z58->Z58_CODIND, Z58->Z58_DESIND, Z58->Z58_VLROCR } )
							Else
								aINDTOTAL[nPOSTOTAL,03] += Z58->Z58_VLROCR
							EndIf           

							
							Z58->(dbSkip()) 
						Enddo
						If nTOTOCO > 0
							@nLin,001 PSAY "TOTAL OCORRสNCIAS: "
							@nLin,194 PSAY nTOTOCO PICTURE "@E 999,999,999.99"
							nLin += 2
						EndIf
					EndIf
			
					//--INCONSISTENCIAS/OCORRENCIAS RETORNO NEOGRID
					dbSelectArea("Z59")
					Z59->(dbSetOrder(1))
					If Z59->(dbSeek((cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)+Z57->Z57_IDCNAB))
						lIMPTIT := .T.
						While !Z59->(EOF()) .AND. Z59->(Z59_FILIAL+Z59_CODBCO+Z59_CODAGE+Z59_NUMCON+Z59_SEQARQ+Z59_NUMRET+Z59_IDCNAB) == ;
													(cAliasTMP)->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)+Z57->Z57_IDCNAB
	
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Impressao do cabecalho do relatorio. . .                            ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
							If nLin > 55 
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
			
	
							//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
							//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
							//"DATA     HORA      OCORRสNCIAS/OPERAวีES"
			
							If lIMPTIT
								@nLin,001 PSAY "DATA     HORA      OCORRสNCIAS/OPERAวีES"
								lIMPTIT := .F.
								nLin += 1
							EndIf
							@nLin,001 PSAY DTOC(Z59->Z59_DATAIN)
							@nLin,010 PSAY Z59->Z59_HORAIN
							@nLin,020 PSAY Z59->Z59_DESCRI
							nLin += 1
							
							Z59->(dbSkip()) 
						Enddo
					EndIf
							
					Z57->(dbSkip()) 
				Enddo
			EndIf
	
			nLin += 1
			@nLin,001 PSAY "TOTAIS DO RECEBIMENTO: "
			@nLin,118 PSAY nVLRNOM PICTURE "@E 999,999,999.99"
			@nLin,134 PSAY nVLRTPG PICTURE "@E 999,999,999.99"
			@nLin,150 PSAY nVLRTDC PICTURE "@E 999,999,999.99"
			@nLin,166 PSAY nVLRABT PICTURE "@E 999,999,999.99"
			@nLin,182 PSAY nVLRAJP PICTURE "@E 999,999,999.99"
			@nLin,200 PSAY nVLRAJN PICTURE "@E 999,999,999.99"
			
			If Len(aOCORECEB) > 0
				For nI := 1 to Len(aOCORECEB)
				
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Impressao do cabecalho do relatorio. . .                            ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู				
					
					If nLin > 55 
						Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
						nLin := 8
					Endif
					
					nLin += 1
					@nLin,001 PSAY aOCORECEB[nI,01]
					@nLin,010 PSAY aOCORECEB[nI,02]
					@nLin,084 PSAY aOCORECEB[nI,03] PICTURE "@E 999,999,999.99"			
				Next nI 
			EndIf
	
	
			aTOTGERAL[1] += nVLRNOM
			aTOTGERAL[2] += nVLRTPG 
			aTOTGERAL[3] += nVLRTDC 
			aTOTGERAL[4] += nVLRABT 
			aTOTGERAL[5] += nVLRAJP 
			aTOTGERAL[6] += nVLRAJN  
							
			IncRegua()
			(cAliasTMP)->(dbSkip())
		Enddo
	
		nLin += 1
		@nLin,001 PSAY "TOTAIS GERAL: "
		@nLin,118 PSAY aTOTGERAL[1] PICTURE "@E 999,999,999.99"
		@nLin,134 PSAY aTOTGERAL[2] PICTURE "@E 999,999,999.99"
		@nLin,150 PSAY aTOTGERAL[3] PICTURE "@E 999,999,999.99"
		@nLin,166 PSAY aTOTGERAL[4] PICTURE "@E 999,999,999.99"
		@nLin,182 PSAY aTOTGERAL[5] PICTURE "@E 999,999,999.99"
		@nLin,200 PSAY aTOTGERAL[6] PICTURE "@E 999,999,999.99"
		
		If Len(aOCOTOTAL) > 0
			nLin += 1
			@nLin,001 PSAY "TOTAL OCORRENCIAS ARQ.:"
			For nI := 1 to Len(aOCOTOTAL)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			
				If nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				nLin += 1
				@nLin,001 PSAY aOCOTOTAL[nI,01]
				@nLin,010 PSAY SubSTR(aOCOTOTAL[nI,02],1,60)
				@nLin,080 PSAY aOCOTOTAL[nI,03] PICTURE "@E 999,999,999.99"			
			Next nI 
		EndIf

		If Len(aINDTOTAL) > 0
			nLin += 1
			@nLin,001 PSAY "TOTAL OCORRENCIAS IND.:"
			For nI := 1 to Len(aINDTOTAL)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			
				If nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				nLin += 1
				@nLin,001 PSAY aINDTOTAL[nI,01]
				@nLin,010 PSAY SubSTR(aINDTOTAL[nI,02],1,60)
				@nLin,080 PSAY aINDTOTAL[nI,03] PICTURE "@E 999,999,999.99"			
			Next nI 
		EndIf
		
	EndIf

	(cAliasTMP)->(dbCloseArea())
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RER  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio extrato de retorno.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function RJF05RERSX1()
*---------------------------------------------------------------------------*
Local aRegs  := {} 


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Banco De            ?","Banco De            ?","Banco De            ?","mv_ch1","C",TAMSX3("Z59_CODBCO")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","",""})
	aAdd(aRegs,{cPerg,"02","Banco At้           ?","Banco At้           ?","Banco At้           ?","mv_ch2","C",TAMSX3("Z59_CODBCO")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","",""})
	aAdd(aRegs,{cPerg,"03","Ag๊ncia De          ?","Ag๊ncia De          ?","Ag๊ncia De          ?","mv_ch3","C",TAMSX3("Z59_CODAGE")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Ag๊ncia At้         ?","Ag๊ncia At้         ?","Ag๊ncia At้         ?","mv_ch4","C",TAMSX3("Z59_CODAGE")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Conta De            ?","Conta De            ?","Conta De            ?","mv_ch5","C",TAMSX3("Z59_NUMCON")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"06","Conta At้           ?","Conta At้           ?","Conta At้           ?","mv_ch6","C",TAMSX3("Z59_NUMCON")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"07","Seq. Arquivo De     ?","Seq. Arquivo De     ?","Seq. Arquivo De     ?","mv_ch7","C",TAMSX3("Z59_SEQARQ")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"08","Seq. Arquivo At้    ?","Seq. Arquivo At้    ?","Seq. Arquivo At้    ?","mv_ch8","C",TAMSX3("Z59_SEQARQ")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"09","N๚mero Retorno De   ?","N๚mero Retorno De   ?","N๚mero Retorno De   ?","mv_ch9","C",TAMSX3("Z59_NUMRET")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","N๚mero Retorno At้  ?","N๚mero Retorno At้  ?","N๚mero Retorno At้  ?","mv_ch0","C",TAMSX3("Z59_NUMRET")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
 	aAdd(aRegs,{cPerg,"11","Data Arquivo De     ?","Data Arquivo De     ?","Data Arquivo De     ?","mv_cha","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"12","Data Arquivo At้    ?","Data Arquivo At้    ?","Data Arquivo At้    ?","mv_chb","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})

	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RTP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio totalizadores por perํodo.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05RTP()
*---------------------------------------------------------------------------*
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
Private cDesc2			:= "de acordo com os parametros informados pelo usuario."
Private cDesc3			:= ""
Private cPict			:= ""
Private titulo			:= "TOTALIZADORES POR PERอODO - COBRANวA INTELIGENTE NEOGRID"
Private nLin			:= 80
Private Cabec1			:= "CำDIGO   LOJA  RAZรO SOCIAL"
Private Cabec2			:= ""
Private imprime		:= .T.
Private aOrd			:= {}
Private lEnd			:= .F.
Private lAbortPrint	:= .F.
Private CbTxt			:= ""
Private limite			:= 132
Private tamanho		:= "M"
Private nomeprog		:= "RJF05RTP" 
Private nTipo			:= 18
Private aReturn		:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey		:= 0
Private cbtxt			:= Space(10)
Private cbcont			:= 00
Private CONTFL			:= 01
Private m_pag			:= 01
Private wnrel			:= "RJF05RTP"
Private cPerg			:= "RJF05RTPX1"
Private cString		:= "Z56"

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())


	dbSelectArea(cString)
	dbSetOrder(1)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RJF05RTPSX1()
	Pergunte(cPerg, .F.)
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	nOrdem:= aReturn[8]

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	RptStatus({|| RJF05RTPIMP(Cabec1,Cabec2,Titulo,nLin,nOrdem) },Titulo)
	
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RTP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio totalizadores por perํodo.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------------------------------------*
Static Function RJF05RTPIMP(Cabec1,Cabec2,Titulo,nLin,nOrdem)
*---------------------------------------------------------------------*
Local cAliasTMP	:= GetNextAlias()
Local cCLIENTE		:= STRINGNULL
Local aOCORECEB := {}
Local aOCOTOTAL := {}
 
	cQuery := "	SELECT																" + chr(13)
	cQuery += "			Z57.Z57_FILIAL,												" + chr(13)
	cQuery += "			Z57.Z57_CODBCO,												" + chr(13)
	cQuery += "			Z57.Z57_CODAGE,												" + chr(13)
	cQuery += "			Z57.Z57_NUMCON,												" + chr(13)
	cQuery += "			Z57.Z57_SEQARQ,												" + chr(13)
	cQuery += "			Z57.Z57_NUMRET, 											" + chr(13)
	cQuery += "			Z57.Z57_CODCLI, 											" + chr(13)
	cQuery += "			Z57.Z57_LOJCLI, 											" + chr(13)
	cQuery += "			Z57.Z57_IDCNAB 												" + chr(13)
	cQuery += "	FROM " + RetSQLName("Z57") + " Z57		   							" + chr(13)
	cQuery += "	INNER JOIN " + RetSQLName("Z56") + " Z56   							" + chr(13)
	cQuery += " ON		Z56.Z56_FILIAL	= Z57.Z57_FILIAL							" + chr(13)
	cQuery += "	AND		Z56.Z56_CODBCO	= Z57.Z57_CODBCO							" + chr(13)
	cQuery += "	AND		Z56.Z56_CODAGE	= Z57.Z57_CODAGE							" + chr(13)
	cQuery += "	AND		Z56.Z56_NUMCON	= Z57.Z57_NUMCON							" + chr(13)
	cQuery += "	AND		Z56.Z56_SEQARQ	= Z57.Z57_SEQARQ							" + chr(13)
	cQuery += "	AND		Z56.Z56_NUMRET	= Z57.Z57_NUMRET							" + chr(13)
//	cQuery += "	AND		Z56.Z56_TIPARQ  = '09'										" + chr(13)	
	cQuery += "	AND		Z56.D_E_L_E_T_ != '*'										" + chr(13)
	cQuery += "	WHERE 									   							" + chr(13)
	cQuery += "			Z57.Z57_CODBCO BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par01 + "' AND '" + mv_par02 + "'					" + chr(13)
	cQuery += "	AND		Z57.Z57_CODAGE BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par03 + "' AND '" + mv_par04 + "'					" + chr(13)
	cQuery += "	AND		Z57.Z57_NUMCON BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par05 + "' AND '" + mv_par06 + "'					" + chr(13)
	cQuery += "	AND		Z57.Z57_CODCLI BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par07 + "' AND '" + mv_par08 + "'					" + chr(13)
	cQuery += "	AND		Z57.Z57_LOJCLI BETWEEN										" + chr(13)
	cQuery += "			'" + mv_par09 + "' AND '" + mv_par10 + "'					" + chr(13)
	cQuery += "	AND		Z57.Z57_DATECR BETWEEN										" + chr(13)
	cQuery += "			'" + dtos(mv_par11) + "' AND '" + dtos(mv_par12) + "'		" + chr(13)
	cQuery += "	AND		Z57.D_E_L_E_T_ != '*'										" + chr(13)
	cQuery += "	ORDER BY															" + chr(13)
	cQuery += "			Z57.Z57_CODCLI, 											" + chr(13)
	cQuery += "			Z57.Z57_LOJCLI, 											" + chr(13)
	cQuery += "			Z57.Z57_FILIAL,												" + chr(13)
	cQuery += "			Z57.Z57_CODBCO,												" + chr(13)
	cQuery += "			Z57.Z57_CODAGE,												" + chr(13)
	cQuery += "			Z57.Z57_NUMCON,												" + chr(13)
	cQuery += "			Z57.Z57_SEQARQ,												" + chr(13)
	cQuery += "			Z57.Z57_NUMRET, 											" + chr(13)
	cQuery += "			Z57.Z57_IDCNAB 												" + chr(13)
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	SetRegua((cAliasTMP)->(RecCount()))
	If (cAliasTMP)->(!EOF())
		While (cAliasTMP)->(!EOF())
	
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Cancelado pelo operador . . .                                       ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			If lAbortPrint
				@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif
		
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao do cabecalho do relatorio. . .                            ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
			If nLin > 55 
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
				
			Endif

			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Impressao dos totalizadores . . .                                   ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			
			If cCLIENTE != (cAliasTMP)->(Z57_CODCLI+Z57_LOJCLI)

				If cCLIENTE != STRINGNULL
				
					If Len(aOCORECEB) > 0
						
						If mv_par13 == 1
							nLin += 1
							@nLin,001 PSAY "TOTALIZADORES: "+SA1->A1_COD+"/"+SA1->A1_LOJA+"-"+SA1->A1_NOME
						EndIf					
						
						For nI := 1 to Len(aOCORECEB)
						
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Impressao do cabecalho do relatorio. . .                            ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
						
							If nLin > 55 
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
							
							nLin += 1
							@nLin,001 PSAY aOCORECEB[nI,01]
							@nLin,010 PSAY aOCORECEB[nI,02]
							@nLin,084 PSAY aOCORECEB[nI,03] PICTURE "@E 999,999,999.99"			
						Next nI
						nLin += 2 
					EndIf					
				
				EndIf
				
				dbSelectArea("SA1")
				dbSetOrder(1)
				dbSeek(xFilial("SA1")+(cAliasTMP)->(Z57_CODCLI+Z57_LOJCLI))
				@nLin,001 PSAY (cAliasTMP)->Z57_CODCLI
				@nLin,010 PSAY (cAliasTMP)->Z57_LOJCLI
				@nLin,016 PSAY SA1->A1_NOME
				nLin += 1
				aOCORECEB := {}
			
			EndIf
			
			//--Tipo Impressใo = Sint้tico
			If mv_par13 == 1

				//--TITULOS RETORNO NEOGRID 
				dbSelectArea("Z57")
				Z57->(dbSetOrder(1))
				If Z57->(dbSeek((cAliasTMP)->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)))
	
					//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
					//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
					//"FILIAL   PREF. TอTULO    PARC. TIPO  IDCNAB      CONTRATO        
			
					@nLin,001 PSAY "FILIAL   PREF. TอTULO    PARC. TIPO  IDCNAB      CONTRATO"
					nLin += 1
					@nLin,001 PSAY Z57->Z57_FILDOC
					@nLin,010 PSAY Z57->Z57_PREFIX
					@nLin,016 PSAY Z57->Z57_TITULO
					@nLin,026 PSAY Z57->Z57_PARCEL
					@nLin,032 PSAY Z57->Z57_TIPO  
					@nLin,038 PSAY Z57->Z57_IDCNAB
					@nLin,050 PSAY Z57->Z57_CONTRA+"-"+Z57->Z57_SEQCON
					nLin += 1
					
					dbSelectArea("Z58")
					Z58->(dbSetOrder(1))
					If Z58->(dbSeek((cAliasTMP)->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)))
						lIMPTIT := .T.
						While !Z58->(EOF()) .AND. Z58->(Z58_FILIAL+Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET+Z58_IDCNAB) == ;
													(cAliasTMP)->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)
	
	
							//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
							//ณ Impressao do cabecalho do relatorio. . .                            ณ
							//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
							If nLin > 55 
								Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
								nLin := 8
							Endif
			
							//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
							//0         1         2         3         4         5         6         7         8         9        10         11		   12        13        14        15        16        17        18        19        20        21        22
							//"CำDIGO   DESCRIวรO DA OCORRสNCIA                             CำDIGO CEDENTE        VALOR"
			
							If lIMPTIT
								@nLin,001 PSAY "CำDIGO   DESCRIวรO DA OCORRสNCIA                             CำDIGO CEDENTE        VALOR"
								lIMPTIT := .F.
								nLin += 1
							EndIf
							@nLin,001 PSAY Z58->Z58_CODOCR
							@nLin,010 PSAY Z58->Z58_DESOCR
							@nLin,062 PSAY Z58->Z58_CODCED
							@nLin,084 PSAY Z58->Z58_VLROCR PICTURE "@E 999,999,999.99"
							nLin += 1
							
							//--OCORRENCIAS DO RECEBIMENTO
							If Len(aOCORECEB) == 0
								nPOSOCOR := 0
							Else
								nPOSOCOR := aScan( aOCORECEB, { |x| x[1] == Z58->Z58_CODOCR } )
							EndIf
							If nPOSOCOR == 0
								aAdd ( aOCORECEB, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
							Else
								aOCORECEB[nPOSOCOR,03] += Z58->Z58_VLROCR
							EndIf
							
							//--TOTAL DAS OCORRENCIAS
							If Len(aOCOTOTAL) == 0
								nPOSTOTAL := 0
							Else
								nPOSTOTAL := aScan( aOCOTOTAL, { |x| x[1] == Z58->Z58_CODOCR } )
							EndIf
							If nPOSTOTAL == 0
								aAdd ( aOCOTOTAL, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
							Else
								aOCOTOTAL[nPOSTOTAL,03] += Z58->Z58_VLROCR
							EndIf
							
							Z58->(dbSkip()) 
						Enddo
					EndIf
				EndIf
			
			
			Else

				dbSelectArea("Z58")
				Z58->(dbSetOrder(1))
				If Z58->(dbSeek((cAliasTMP)->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)))
					While !Z58->(EOF()) .AND. Z58->(Z58_FILIAL+Z58_CODBCO+Z58_CODAGE+Z58_NUMCON+Z58_SEQARQ+Z58_NUMRET+Z58_IDCNAB) == ;
												(cAliasTMP)->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET+Z57_IDCNAB)

						//--OCORRENCIAS DO RECEBIMENTO
						If Len(aOCORECEB) == 0
							nPOSOCOR := 0
						Else
							nPOSOCOR := aScan( aOCORECEB, { |x| x[1] == Z58->Z58_CODOCR } )
						EndIf
						If nPOSOCOR == 0
							aAdd ( aOCORECEB, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
						Else
							aOCORECEB[nPOSOCOR,03] += Z58->Z58_VLROCR
						EndIf
						
						//--TOTAL DAS OCORRENCIAS
						If Len(aOCOTOTAL) == 0
							nPOSTOTAL := 0
						Else
							nPOSTOTAL := aScan( aOCOTOTAL, { |x| x[1] == Z58->Z58_CODOCR } )
						EndIf
						If nPOSTOTAL == 0
							aAdd ( aOCOTOTAL, { Z58->Z58_CODOCR, Z58->Z58_DESOCR, Z58->Z58_VLROCR } )
						Else
							aOCOTOTAL[nPOSTOTAL,03] += Z58->Z58_VLROCR
						EndIf
						
						Z58->(dbSkip()) 
					Enddo
				EndIf
			
			EndIf

			cCLIENTE := (cAliasTMP)->(Z57_CODCLI+Z57_LOJCLI)
			IncRegua()
			(cAliasTMP)->(dbSkip())
		Enddo


		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Impressao dos totalizadores . . .                                   ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
		If Len(aOCORECEB) > 0
			
			If mv_par13 == 1
				nLin += 1
				@nLin,001 PSAY "TOTALIZADORES: "+SA1->A1_COD+"/"+SA1->A1_LOJA+"-"+SA1->A1_NOME
			EndIf					
			
			For nI := 1 to Len(aOCOTOTAL)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			
				If nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				nLin += 1
				@nLin,001 PSAY aOCOTOTAL[nI,01]
				@nLin,010 PSAY aOCOTOTAL[nI,02]
				@nLin,084 PSAY aOCOTOTAL[nI,03] PICTURE "@E 999,999,999.99"			
			Next nI 
		EndIf					


		If Len(aOCOTOTAL) > 0
			nLin += 2
			@nLin,001 PSAY "TOTALIZADORES GERAL"				
			For nI := 1 to Len(aOCOTOTAL)
			
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Impressao do cabecalho do relatorio. . .                            ณ
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู			
			
				If nLin > 55 
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 8
				Endif
				
				nLin += 1
				@nLin,001 PSAY aOCOTOTAL[nI,01]
				@nLin,010 PSAY aOCOTOTAL[nI,02]
				@nLin,084 PSAY aOCOTOTAL[nI,03] PICTURE "@E 999,999,999.99"			
			Next nI 
		EndIf
					
	EndIf

	(cAliasTMP)->(dbCloseArea())
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Finaliza a execucao do relatorio...                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	SET DEVICE TO SCREEN
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	If aReturn[5]==1
	   dbCommitAll()
	   SET PRINTER TO
	   OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05RTP  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio totalizadores por perํodo.                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function RJF05RTPSX1()
*---------------------------------------------------------------------------*
Local aRegs  := {} 


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Banco De            ?","Banco De            ?","Banco De            ?","mv_ch1","C",TAMSX3("Z59_CODBCO")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","",""})
	aAdd(aRegs,{cPerg,"02","Banco At้           ?","Banco At้           ?","Banco At้           ?","mv_ch2","C",TAMSX3("Z59_CODBCO")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SA6","","",""})
	aAdd(aRegs,{cPerg,"03","Ag๊ncia De          ?","Ag๊ncia De          ?","Ag๊ncia De          ?","mv_ch3","C",TAMSX3("Z59_CODAGE")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"04","Ag๊ncia At้         ?","Ag๊ncia At้         ?","Ag๊ncia At้         ?","mv_ch4","C",TAMSX3("Z59_CODAGE")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Conta De            ?","Conta De            ?","Conta De            ?","mv_ch5","C",TAMSX3("Z59_NUMCON")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"06","Conta At้           ?","Conta At้           ?","Conta At้           ?","mv_ch6","C",TAMSX3("Z59_NUMCON")[1],0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"07","Cliente De          ?","Cliente De          ?","Cliente De          ?","mv_ch7","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","",""})
	aAdd(aRegs,{cPerg,"08","Cliente At้         ?","Cliente At้         ?","Cliente At้         ?","mv_ch8","C",TAMSX3("A1_COD")[1],0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","", "SA1","","",""})
	aAdd(aRegs,{cPerg,"09","Loja De             ?","Loja De             ?","Loja De             ?","mv_ch9","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"10","Loja At้            ?","Loja At้            ?","Loja At้            ?","mv_ch0","C",TAMSX3("A1_LOJA")[1],0,0,"G","","mv_par10","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
 	aAdd(aRegs,{cPerg,"11","Data Recebimento De ?","Data Recebimento De ?","Data Recebimento De ?","mv_cha","D",08,0,0,"G","","mv_par11","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"12","Data Recebimento At้?","Data Recebimento At้?","Data Recebimento At้?","mv_chb","D",08,0,0,"G","","mv_par12","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"13","Tipo Impressใo      ?","Tipo Impressใo      ?","Tipo Impressใo      ?","mv_chc","N",01,0,1,"C","","mv_par13","Analํtico","Analํtico","Analํtico","","","Sint้tico","Sint้tico","Sint้tico","","","","","","","","","","","","","","","","", "","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05ABX  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador de arquivo de retorno de bancos para baixa de      บฑฑ
ฑฑบ          ณ tํtulos a receber.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJF05ABX()
*---------------------------------------------------------------------------*
Local lRet 			:= .F.
Private aAreaTMP 	:= GetArea()
Private aDADOSARQ	:= {}

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If Z56->Z56_TIPARQ != "09"
		Aviso("Aviso","Esta opera็ใo poderแ ser realizada apenas para registros de Arq. de baixas NeoGrid.",{"OK"})
		Return
	EndIf


	Processa({|| lRet := RJF05ABXSEL(@aDADOSARQ) },"Processando Arquivo...")
	If lRet
		Processa({|| RJF05ABXARQ(aDADOSARQ) },"Processando Arquivo...")
	EndIf
	RestArea(aAreaTMP)	

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05ABXSELบAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณJanela de sele็ใo de tํtulos.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function RJF05ABXSEL(aDADOSARQ)     
*---------------------------------------------------------------------------*
Private aAreaTMP	:= GetArea()
Private cAliasTMP	:= GetNextAlias()
Private aCampos	:= {}
Private aStruct	:= {}
Private cMarca		:= GetMark()
Private lInverte	:= .F.
Private lConfirm	:= .F.    
Private cDlgTitle	:= "Sele็ใo de tํtulos"
Private nTOTALPAG := 0
Private cZ56_CODBCO := Z56->Z56_CODBCO
Private cZ56_CODAGE := Z56->Z56_CODAGE
Private cZ56_NUMCON := Z56->Z56_NUMCON
Private cZ56_SEQARQ := Z56->Z56_SEQARQ
Private cZ56_NUMRET := Z56->Z56_NUMRET
Private oTOTALPAG, oDlgFIL

	aAdd( aStruct, {"Z57_OK"		, "C", 02, 0} )
	aAdd( aStruct, {"Z57_FILDOC", "C", TAMSX3("Z57_FILDOC")[1], TAMSX3("Z57_FILDOC")[2]} )
	aAdd( aStruct, {"Z57_CODCLI", "C", TAMSX3("Z57_CODCLI")[1], TAMSX3("Z57_CODCLI")[2]} )
	aAdd( aStruct, {"Z57_LOJCLI", "C", TAMSX3("Z57_LOJCLI")[1], TAMSX3("Z57_LOJCLI")[2]} )
	aAdd( aStruct, {"Z57_PREFIX", "C", TAMSX3("Z57_PREFIX")[1], TAMSX3("Z57_PREFIX")[2]} )
	aAdd( aStruct, {"Z57_TITULO", "C", TAMSX3("Z57_TITULO")[1], TAMSX3("Z57_TITULO")[2]} )
	aAdd( aStruct, {"Z57_PARCEL", "C", TAMSX3("Z57_PARCEL")[1], TAMSX3("Z57_PARCEL")[2]} )
	aAdd( aStruct, {"Z57_TIPO"	, "C", TAMSX3("Z57_TIPO")[1]  , TAMSX3("Z57_TIPO")[2]}   )
	aAdd( aStruct, {"Z57_IDCNAB", "C", TAMSX3("Z57_IDCNAB")[1], TAMSX3("Z57_IDCNAB")[2]} )
	aAdd( aStruct, {"Z57_CONTRA", "C", TAMSX3("Z57_CONTRA")[1], TAMSX3("Z57_CONTRA")[2]} )
	aAdd( aStruct, {"Z57_SEQCON", "C", TAMSX3("Z57_SEQCON")[1], TAMSX3("Z57_SEQCON")[2]} )
	aAdd( aStruct, {"Z57_DATEMI", "D", TAMSX3("Z57_DATEMI")[1], TAMSX3("Z57_DATEMI")[2]} )
	aAdd( aStruct, {"Z57_DATPGT", "D", TAMSX3("Z57_DATPGT")[1], TAMSX3("Z57_DATPGT")[2]} )
	aAdd( aStruct, {"Z57_DATECR", "D", TAMSX3("Z57_DATECR")[1], TAMSX3("Z57_DATECR")[2]} )
	aAdd( aStruct, {"Z57_VLRNOM", "N", TAMSX3("Z57_VLRNOM")[1], TAMSX3("Z57_VLRNOM")[2]} )
	aAdd( aStruct, {"Z57_VLRTPG", "N", TAMSX3("Z57_VLRTPG")[1], TAMSX3("Z57_VLRTPG")[2]} )
	aAdd( aStruct, {"Z57_VLRTDC", "N", TAMSX3("Z57_VLRTDC")[1], TAMSX3("Z57_VLRTDC")[2]} )
	aAdd( aStruct, {"Z57_VLRABT", "N", TAMSX3("Z57_VLRABT")[1], TAMSX3("Z57_VLRABT")[2]} )
	aAdd( aStruct, {"Z57_VLRAJP", "N", TAMSX3("Z57_VLRAJP")[1], TAMSX3("Z57_VLRAJP")[2]} )
	aAdd( aStruct, {"Z57_VLRAJN", "N", TAMSX3("Z57_VLRAJN")[1], TAMSX3("Z57_VLRAJN")[2]} )
	
	cArqTrab := CriaTrab(aStruct, .T.)
	dbUseArea(.T.,, cArqTrab ,(cAliasTMP), .F.,.F. )
	dbSelectArea(cAliasTMP)
	Index on Z57_FILDOC+Z57_CODCLI+Z57_LOJCLI+Z57_PREFIX+Z57_TITULO+Z57_PARCEL+Z57_TIPO+Z57_IDCNAB to &cArqTrab


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Atualiza temporarios                                      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("Z57")
	dbSetOrder(1)
	dbGoTop()
	If dbSeek ( Z56->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET) )
		While !Z57->(EOF()) .and. Z57->(Z57_FILIAL+Z57_CODBCO+Z57_CODAGE+Z57_NUMCON+Z57_SEQARQ+Z57_NUMRET) == Z56->(Z56_FILIAL+Z56_CODBCO+Z56_CODAGE+Z56_NUMCON+Z56_SEQARQ+Z56_NUMRET)
			If Z57->Z57_VLRTPG > 0
			    dbSelectArea(cAliasTMP)
			    RecLock(cAliasTMP,.T.)
			    (cAliasTMP)->Z57_OK			:= Space(02)
				(cAliasTMP)->Z57_FILDOC		:= Z57->Z57_FILDOC
				(cAliasTMP)->Z57_CODCLI 	:= Z57->Z57_CODCLI
				(cAliasTMP)->Z57_LOJCLI 	:= Z57->Z57_LOJCLI
				(cAliasTMP)->Z57_PREFIX 	:= Z57->Z57_PREFIX
				(cAliasTMP)->Z57_TITULO 	:= Z57->Z57_TITULO
				(cAliasTMP)->Z57_PARCEL 	:= Z57->Z57_PARCEL
				(cAliasTMP)->Z57_TIPO   	:= Z57->Z57_TIPO
				(cAliasTMP)->Z57_IDCNAB 	:= Z57->Z57_IDCNAB
				(cAliasTMP)->Z57_CONTRA 	:= Z57->Z57_CONTRA
				(cAliasTMP)->Z57_SEQCON 	:= Z57->Z57_SEQCON
				(cAliasTMP)->Z57_DATEMI 	:= Z57->Z57_DATEMI
				(cAliasTMP)->Z57_DATPGT 	:= Z57->Z57_DATPGT
				(cAliasTMP)->Z57_DATECR 	:= Z57->Z57_DATECR
				(cAliasTMP)->Z57_VLRNOM 	:= Z57->Z57_VLRNOM
				(cAliasTMP)->Z57_VLRTPG 	:= Z57->Z57_VLRTPG
				(cAliasTMP)->Z57_VLRTDC 	:= Z57->Z57_VLRTDC
				(cAliasTMP)->Z57_VLRABT 	:= Z57->Z57_VLRABT
				(cAliasTMP)->Z57_VLRAJP 	:= Z57->Z57_VLRAJP
				(cAliasTMP)->Z57_VLRAJN 	:= Z57->Z57_VLRAJN
			    (cAliasTMP)->(MsUnLock())
			EndIf
			Z57->(dbSkip())
		Enddo				
	EndIf              

	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Campos para mostrar no BROWSE padrao                      ณ
	//ณ Necessario quando usando um arquivo qualquer (sem o SX3)  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	aAdd( aCampos, {"Z57_OK"    , "", "", ""} )
	aAdd( aCampos, {"Z57_FILDOC", "", "Filial Doc. ", ""} )
	aAdd( aCampos, {"Z57_CODCLI", "", "Cod. Cliente", ""} )
	aAdd( aCampos, {"Z57_LOJCLI", "", "Loja Cliente", ""} )
	aAdd( aCampos, {"Z57_PREFIX", "", "Prefixo Tit.", ""} )
	aAdd( aCampos, {"Z57_TITULO", "", "Num. Titulo ", ""} )
	aAdd( aCampos, {"Z57_PARCEL", "", "Num. Parcela", ""} )
	aAdd( aCampos, {"Z57_TIPO"  , "", "Tipo Titulo ", ""} )
	aAdd( aCampos, {"Z57_IDCNAB", "", "ID CNAB     ", ""} )
	aAdd( aCampos, {"Z57_CONTRA", "", "Contrato    ", ""} )
	aAdd( aCampos, {"Z57_SEQCON", "", "Seq Contrato", ""} )
	aAdd( aCampos, {"Z57_DATEMI", "", "Data Emissao", ""} )
	aAdd( aCampos, {"Z57_DATPGT", "", "Data Pagto  ", ""} )
	aAdd( aCampos, {"Z57_DATECR", "", "Efet Credito", ""} )
	aAdd( aCampos, {"Z57_VLRNOM", "", "Vlr Nominal ", ""} )
	aAdd( aCampos, {"Z57_VLRTPG", "", "Total Pagto ", ""} )
	aAdd( aCampos, {"Z57_VLRTDC", "", "Tot Desconto", ""} )
	aAdd( aCampos, {"Z57_VLRABT", "", "Tot Abatimen", ""} )
	aAdd( aCampos, {"Z57_VLRAJP", "", "Ajustes Pos.", ""} )
	aAdd( aCampos, {"Z57_VLRAJN", "", "Ajustes Neg.", ""} )


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria dialogo para sele็ใo ...                     ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	dbSelectArea(cAliasTMP)
	dbGoTop()

	DEFINE MSDIALOG oDlgFIL TITLE cDlgTitle From 1,1 To 400,600 OF oMainWnd PIXEL
	
	@ 005, 005 TO 045, 295 OF oDlgFIL PIXEL	
	
	@ 012, 020 SAY OemToAnsi("Banco") OF oDlgFIL PIXEL
	@ 025, 020 GET cZ56_CODBCO SIZE 030,009 WHEN .F. OF oDlgFIL PIXEL
	
	@ 012, 060 SAY OemToAnsi("Ag๊ncia") OF oDlgFIL PIXEL
	@ 025, 060 GET cZ56_CODAGE SIZE 030,009 WHEN .F. OF oDlgFIL PIXEL

	@ 012, 100 SAY OemToAnsi("Conta") OF oDlgFIL PIXEL
	@ 025, 100 GET cZ56_NUMCON SIZE 040,009 WHEN .F. OF oDlgFIL PIXEL

	@ 012, 150 SAY OemToAnsi("Seq. Arquivo") OF oDlgFIL PIXEL
	@ 025, 150 GET cZ56_SEQARQ SIZE 030,009 WHEN .F. OF oDlgFIL PIXEL

	@ 012, 190 SAY OemToAnsi("N๚m. Retorno") OF oDlgFIL PIXEL
	@ 025, 190 GET cZ56_NUMRET SIZE 040,009 WHEN .F. OF oDlgFIL PIXEL

	oMark := MsSelect():New(cAliasTMP,"Z57_OK",,aCampos,@lInverte,@cMarca,{50,1,180,300})
	          
	@ 185, 005 SAY OemToAnsi("Total Pago:") OF oDlgFIL PIXEL
	@ 183, 040 MSGET oTOTALPAG VAR nTOTALPAG SIZE 060,009 PICTURE "@E 999,999,999.99" WHEN .F. OF oDlgFIL PIXEL

	@ 185,230 BMPBUTTON TYPE 1 ACTION ( lConfirm := .T., Close(oDlgFIL) )
	@ 185,260 BMPBUTTON TYPE 2 ACTION ( lConfirm := .F., Close(oDlgFIL) )

	ObjectMethod(oMark:oBrowse,"Refresh()")
	oMark:bMark := {|| fRegSel(oMark, cMarca, oDlgFIL)}
	oMark:oBrowse:lhasMark = .t.
	oMark:oBrowse:lCanAllmark := .t.
	oMark:oBrowse:bAllMark := {|| fMarkAll(oMark, cMarca, oDlgFIL)}

	ACTIVATE MSDIALOG oDlgFIL CENTERED


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Processa registros....                                    ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If lConfirm
	   	dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		While !(cAliasTMP)->(EOF())
	    	If ! Empty((cAliasTMP)->Z57_OK)
	    		aAdd (aDADOSARQ, { Z56->Z56_FILIAL, Z56->Z56_CODBCO, Z56->Z56_CODAGE, Z56->Z56_NUMCON, Z56->Z56_SEQARQ, Z56->Z56_NUMRET, (cAliasTMP)->Z57_IDCNAB } )	    		
	    	EndIf
	    	(cAliasTMP)->(dbSkip())
	 	Enddo          
	EndIf
	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Fecha alias temporarios                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
	dbSelectArea(cAliasTMP)
	dbCloseArea(cAliasTMP)
	FErase(cArqTrab+OrdBagExt())
	FErase(cArqTrab+".*")
	
	RestArea(aAreaTMP) 
	
Return (!Empty(aDADOSARQ))


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfRegSel    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSele็ใo de registros.                                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fRegSel(oMark, cMarca, oDlgFIL)
*---------------------------------------------------------------------------*

	If Marked("Z57_OK")
		RecLock(cAliasTMP,.F.)
		Replace (cAliasTMP)->Z57_OK With cMarca
		(cAliasTMP)->(MsUnlock())
		nTOTALPAG += (cAliasTMP)->Z57_VLRTPG
	Else
		RecLock(cAliasTMP,.F.)
		Replace (cAliasTMP)->Z57_OK With Space(02)
		(cAliasTMP)->(MsUnlock())
		nTOTALPAG -= (cAliasTMP)->Z57_VLRTPG
	Endif
	
	oMark:oBrowse:Refresh(.t.)
	oTOTALPAG:Refresh()
	oDlgFIL:Refresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfMarkAll   บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณSele็ใo de todos registros.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ RJU                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fMarkAll(oMark, cMarca, oDlgFIL)
*---------------------------------------------------------------------------*
Local nREC := (cAliasTMP)->(Recno())    
    
	(cAliasTMP)->(dbGoTop())
	While (cAliasTMP)->(!EOF())
		RecLock(cAliasTMP,.F.)
		If Empty((cAliasTMP)->Z57_OK)
			Replace (cAliasTMP)->Z57_OK With cMarca
			nTOTALPAG += (cAliasTMP)->Z57_VLRTPG
		Else
			Replace (cAliasTMP)->Z57_OK With Space(02)
			nTOTALPAG -= (cAliasTMP)->Z57_VLRTPG
		Endif
		(cAliasTMP)->(MsUnlock())
		(cAliasTMP)->(dbSkip())
	EndDo  
	
	(cAliasTMP)->(dbGoTo(nREC))
	oMark:oBrowse:Refresh(.t.)
	oTOTALPAG:Refresh()
	oDlgFIL:Refresh()

Return .T. 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJF05ABXARQบAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gerador de arquivo de retorno de bancos para baixa de      บฑฑ
ฑฑบ          ณ tํtulos a receber.                                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function RJF05ABXARQ(aDADOSARQ)
*---------------------------------------------------------------------------*

Private cArqRET
Private nHdlRET
               
	cArqRET := fDefArqBaixa()
	
	If cArqRET == STRINGNULL
		Aviso("Aviso","Nใo foi possํvel definir o nome arquivo para gerar o arquivo de baixas.",{"OK"})
		Return
	EndIf
 	

	nHdlRET	:= fCreate(cArqRET)
	If nHdlRET == -1
	    MsgAlert("O arquivo de nome "+cArqRET+" nใo pode ser criado!","Aten็ใo!")
	    Return
	Endif
	
	If ! Z56->Z56_CODBCO $ "001/094/224/422/707"
		Aviso("Aviso","Banco invแlido! Foram tratados apenas os bancos: 001/094/224/422/707",{"OK"})
		Return
	EndIf
	
	If Len(aDADOSARQ) > 0
		
		If Z56->Z56_CODBCO == "001" .or. Z56->Z56_CODBCO == "094" .or. Z56->Z56_CODBCO == "224" .or. Z56->Z56_CODBCO == "707"
			
			nSEQREG := 0
			nTAMLIN	:= 240
			
			//--Registro Header de Arquivo
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--CODIGO DO BANCO
			cTEXTO := Stuff(cTEXTO,01,03,"001")
			//--LOTE DE SERVICO
			cTEXTO := Stuff(cTEXTO,04,04,"0000")
			//--NOME BANCO     
			cTEXTO := Stuff(cTEXTO,103,20,"BANCO DO BRASIL S.A.")
			//--N.VERSAO L.OUT.
			cTEXTO := Stuff(cTEXTO,164,003,"030")
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))

			//--Registro Trailer de Arquivo
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--CODIGO DO BANCO
			cTEXTO := Stuff(cTEXTO,01,03,"001")
			//--LOTE DE SERVICO
			cTEXTO := Stuff(cTEXTO,04,04,"9999")
			//--REGISTRO 
			cTEXTO := Stuff(cTEXTO,08,01,"9")
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))
		
		Else
		
			nSEQREG := 1
			nTAMLIN	:= 400
			
			//--Registro Header de Arquivo
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--Identifica็ใo Registro Header
			cTEXTO := Stuff(cTEXTO,01,01,"0")
			//--Identifica็ใo Arquivo Retorno
			cTEXTO := Stuff(cTEXTO,02,01,"2")
			//--Identifica็ใo Arquivo Retorno P/Extenso    
			cTEXTO := Stuff(cTEXTO,03,07,"RETORNO")
			//--C๓digo Identifica็ใo Do Servi็o
			cTEXTO := Stuff(cTEXTO,10,02,"01")
			//--Identifica็ใo Do Servi็o P/ Extenso
			cTEXTO := Stuff(cTEXTO,12,08,"COBRANCA")
			//--C๓digo De Identifica็ใo Do Banco
			cTEXTO := Stuff(cTEXTO,77,03,"422")
			//--Nome Do Banco Por Extenso
			cTEXTO := Stuff(cTEXTO,80,05,"SAFRA")
			//--N๚mero Seqüencial Do Registro No Arquivo
			cTEXTO := Stuff(cTEXTO,395,06,STRZero(nSEQREG,06))
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))
		
		EndIf
		
		
		For nI := 1 to Len(aDADOSARQ)
			dbSelectArea("Z57")
			dbSetOrder(1)
			If dbSeek ( aDADOSARQ[nI,01] + aDADOSARQ[nI,02] + aDADOSARQ[nI,03] + aDADOSARQ[nI,04] + aDADOSARQ[nI,05] + aDADOSARQ[nI,06] + aDADOSARQ[nI,07] )

				dbSelectArea("SE1")
				SE1->(dbSetOrder(19))	//--E1_IDCNAB
				SE1->(dbGoTop())
				If SE1->(dbSeek(aDADOSARQ[nI,07]))
			
					//--BANCO DO BRASIL
					If Z56->Z56_CODBCO == "001" .or. Z56->Z56_CODBCO == "094" .or. Z56->Z56_CODBCO == "224"  .or. Z56->Z56_CODBCO == "707"
						
						nSEQREG += 1
						//--Registro Segmento T
						cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
						//--CODIGO DO BANCO
						cTEXTO := Stuff(cTEXTO,01,03,"001")
						//--LOTE DE SERVICO
						cTEXTO := Stuff(cTEXTO,04,04,"9999")
						//--SEQUENCIAL
						cTEXTO := Stuff(cTEXTO,08,06,STRZero(nSEQREG,06))
						//--SEGMENTO       
						cTEXTO := Stuff(cTEXTO,14,01,"T")
						//--OCORRENCIA = 06-LIQUIDACAO
						cTEXTO := Stuff(cTEXTO,16,02,"06")
						//--NOSSONUMERO    
						cTEXTO := Stuff(cTEXTO,38,17,SE1->E1_NUMBCO)
						//--NUM.TITULO
						cTEXTO := Stuff(cTEXTO,59,09,Z57->Z57_TITULO)
						//--PARCELA
						cTEXTO := Stuff(cTEXTO,69,03,Z57->Z57_PARCEL)
						//--NUM.DOC.COB.   
						cTEXTO := Stuff(cTEXTO,106,10,Z57->Z57_IDCNAB)
						//--TIPO DO TITULO 
						cTEXTO := Stuff(cTEXTO,117,02,Space(02))
						//--REJEICOES      
						cTEXTO := Stuff(cTEXTO,214,02,"00")
						fWrite(nHdlRET,cTEXTO,Len(cTEXTO))
			
						nSEQREG += 1
						//--Registro Segmento U
						cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
						//--CODIGO DO BANCO
						cTEXTO := Stuff(cTEXTO,01,03,"001")
						//--LOTE DE SERVICO
						cTEXTO := Stuff(cTEXTO,04,04,"9999")
						//--SEQUENCIAL
						cTEXTO := Stuff(cTEXTO,08,06,STRZero(nSEQREG,06))
						//--SEGMENTO       
						cTEXTO := Stuff(cTEXTO,14,01,"U")
						//--OCORRENCIA = 06-LIQUIDACAO
						cTEXTO := Stuff(cTEXTO,16,02,"06")
						//--JUROS              
						cVALOR := FTRFNUM(Z57->Z57_VLRAJP,15)
						cTEXTO := Stuff(cTEXTO,18,15,cVALOR)
						//--DESCONTO        
						cVALOR := FTRFNUM(Z57->Z57_VLRTDC,15)
						cTEXTO := Stuff(cTEXTO,033,15,cVALOR)
						//--ABATIMENTO     
						cVALOR := FTRFNUM(0,15)	//FTRFNUM(Z57->Z57_VLRABT+Z57->Z57_VLRAJN,15)
						cTEXTO := Stuff(cTEXTO,048,15,cVALOR)
						//--IOF                 
						cVALOR := FTRFNUM(0,15)
						cTEXTO := Stuff(cTEXTO,063,15,cVALOR)
						//--VALOR PAGO     
						cVALOR := FTRFNUM(Z57->Z57_VLRTPG,15)
						cTEXTO := Stuff(cTEXTO,078,15,cVALOR)
						//--VLR OUTROS CRED
						cVALOR := FTRFNUM(0,15)
						cTEXTO := Stuff(cTEXTO,123,15,cVALOR)
						//--DATA           
						cVALOR := DTOS(Z57->Z57_DATPGT)
						cVALOR := SUBSTR(cVALOR,7,2)+SUBSTR(cVALOR,5,2)+SUBSTR(cVALOR,1,4)
						cTEXTO := Stuff(cTEXTO,138,08,cVALOR)
						//--DATACREDITO               
						cVALOR := DTOS(Z57->Z57_DATECR)
						cVALOR := SUBSTR(cVALOR,7,2)+SUBSTR(cVALOR,5,2)+SUBSTR(cVALOR,1,4)
						cTEXTO := Stuff(cTEXTO,146,08,cVALOR)
						fWrite(nHdlRET,cTEXTO,Len(cTEXTO))
	
					                                น
					Else	//--BANCO SAFRA
					
						
						nSEQREG += 1
						//--Registro de Segmento
						cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
						//--Identifica็ใo do registro transa็ใo
						cTEXTO := Stuff(cTEXTO,01,01,"1")
						//--Tipo de inscri็ใo da empresa 
						cTEXTO := Stuff(cTEXTO,02,02,"02")
						//--N๚mero de inscri็ใo da empresa 
						cTEXTO := Stuff(cTEXTO,04,14,SM0->M0_CGC)
						//--Identifica็ใo da empresa no banco  
						cTEXTO := Stuff(cTEXTO,18,05,aDADOSARQ[nI,03])
						//--Identifica็ใo da empresa no banco  
						cTEXTO := Stuff(cTEXTO,23,09,SubSTR(aDADOSARQ[nI,04],1,9))
						//--IDCNAB
						cTEXTO := Stuff(cTEXTO,38,10,aDADOSARQ[nI,07])
						//--Identifica็ใo do tํtulo no banco
						cTEXTO := Stuff(cTEXTO,63,09,SuBSTR(SE1->E1_NUMBCO,1,9))
						//--Identifica็ใo da ocorr๊ncia
						cTEXTO := Stuff(cTEXTO,109,02,"06")
						//--Data da ocorr๊ncia no banco   
						cVALOR := DTOS(Z57->Z57_DATPGT)
						cVALOR := SUBSTR(cVALOR,7,2)+SUBSTR(cVALOR,5,2)+SUBSTR(cVALOR,3,2)
						cTEXTO := Stuff(cTEXTO,111,06,cVALOR)
						//--Data de vencimento do tํtulo   
						cVALOR := DTOS(SE1->E1_VENCREA)
						cVALOR := SUBSTR(cVALOR,7,2)+SUBSTR(cVALOR,5,2)+SUBSTR(cVALOR,3,2)
						cTEXTO := Stuff(cTEXTO,147,06,cVALOR)
						//--Valor nominal do tํtulo 
						cVALOR := FTRFNUM(Z57->Z57_VLRNOM,13)
						cTEXTO := Stuff(cTEXTO,153,13,cVALOR)
						//--C๓digo do banco encarregado da cobran็a 
						cTEXTO := Stuff(cTEXTO,166,03,"422")
						//--C๓digo do banco encarregado da cobran็a 
						cTEXTO := Stuff(cTEXTO,169,05,aDADOSARQ[nI,03])
						//--Esp้cie do tํtulo 
						cTEXTO := Stuff(cTEXTO,174,02,"01")
						//--Tarifa de cobran็a 
						cVALOR := FTRFNUM(0,13)
						cTEXTO := Stuff(cTEXTO,176,13,cVALOR)
						//--Valor de outras despesas  
						cVALOR := FTRFNUM(0,13)
						cTEXTO := Stuff(cTEXTO,189,13,cVALOR)
						//--Valor dos encargos da opera็ใo  
						cVALOR := FTRFNUM(0,13)
						cTEXTO := Stuff(cTEXTO,202,13,cVALOR)
						//--Valor do ioc da opera็ใo  
						cVALOR := FTRFNUM(0,13)
						cTEXTO := Stuff(cTEXTO,215,13,cVALOR)
						//--Valor abatimento concedido ou cancelado
						cVALOR := FTRFNUM(0,13)	//FTRFNUM(Z57->Z57_VLRABT+Z57->Z57_VLRAJN,13)
						cTEXTO := Stuff(cTEXTO,228,13,cVALOR)
						//--Valor do desconto concedido 
						cVALOR := FTRFNUM(Z57->Z57_VLRTDC,13)
						cTEXTO := Stuff(cTEXTO,241,13,cVALOR)
						//--Valor lํquido calculado 
						cVALOR := FTRFNUM(Z57->Z57_VLRTPG,13)
						cTEXTO := Stuff(cTEXTO,254,13,cVALOR)
						//--Valor de juros mora pago pelo sacado 
						cVALOR := FTRFNUM(Z57->Z57_VLRAJP,13)
						cTEXTO := Stuff(cTEXTO,267,13,cVALOR)
						//--Valor de outros cr้ditos  
						cVALOR := FTRFNUM(0,13)
						cTEXTO := Stuff(cTEXTO,280,13,cVALOR)
						//--C๓digo de moeda 
						cTEXTO := Stuff(cTEXTO,293,03,"000")
						//--Data Opera็ใo   
						cVALOR := DTOS(Z57->Z57_DATECR)
						cVALOR := SUBSTR(cVALOR,7,2)+SUBSTR(cVALOR,5,2)+SUBSTR(cVALOR,3,2)
						cTEXTO := Stuff(cTEXTO,296,06,cVALOR)
						//--N๚mero seqüencial
						cTEXTO := Stuff(cTEXTO,395,06,STRZero(nSEQREG,06))
						fWrite(nHdlRET,cTEXTO,Len(cTEXTO))				
					
					EndIf
					
				EndIf
				
			EndIf
		Next nI
		

		If Z56->Z56_CODBCO == "001" .or. Z56->Z56_CODBCO == "094" .or. Z56->Z56_CODBCO == "224" .or. Z56->Z56_CODBCO == "707"
			
			//--Registro Header de Lote
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--CODIGO DO BANCO
			cTEXTO := Stuff(cTEXTO,01,03,"001")
			//--LOTE DE SERVICO
			cTEXTO := Stuff(cTEXTO,04,04,"0001")
			//--REGISTRO HEADER
			cTEXTO := Stuff(cTEXTO,08,01,"1")
			//--TIPO OPERACA   
			cTEXTO := Stuff(cTEXTO,09,01,"T")
			//--TIPO DE SERVICO
			cTEXTO := Stuff(cTEXTO,10,02,"01")
			//--LAYOUT DO LOTE 
			cTEXTO := Stuff(cTEXTO,014,03,"020")
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))

			//--Registro Trailer de Lote
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--CODIGO DO BANCO
			cTEXTO := Stuff(cTEXTO,01,03,"001")
			//--LOTE DE SERVICO
			cTEXTO := Stuff(cTEXTO,04,04,"0001")
			//--REGISTRO
			cTEXTO := Stuff(cTEXTO,08,01,"5")
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))
		
		Else
		
			nSEQREG += 1
			//--Registro trailer
			cTEXTO := Space(nTAMLIN)+CHR(13)+CHR(10)
			//--Identifica็ใo registro trailer
			cTEXTO := Stuff(cTEXTO,01,01,"9")
			//--Identifica็ใo do arquivo retorno 
			cTEXTO := Stuff(cTEXTO,02,01,"2")
			//--C๓digo identifica็ใo do servi็o     
			cTEXTO := Stuff(cTEXTO,03,02,"01")
			//--C๓digo de identifica็ใo do banco
			cTEXTO := Stuff(cTEXTO,05,03,"422")
			//--N๚mero seqüencial trailer
			cTEXTO := Stuff(cTEXTO,395,06,STRZero(nSEQREG,06))
			fWrite(nHdlRET,cTEXTO,Len(cTEXTO))

		EndIf
						
	EndIf
	
	If RecLock("Z56",.F.)
		Z56->Z56_ARQBXR := "S"
		Z56->(MsUnLock())
	EndIf
	
	fClose(nHdlRET)
	Aviso("Aviso","Arquivo de baixa: "+cArqRET+CHR(10)+CHR(13)+"Gerado com sucesso!",{"OK"})

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfDefArqBaixaบAutor ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Define arquivo de baixa conforme parโmetros de bancos.     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fDefArqBaixa()
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Local cConta	:= STRINGNULL
Local cRetorno	:= STRINGNULL
               
	dbSelectArea("SEE")
	dbSetOrder(1)
	If dbSeek( xFilial("SEE")+Z56->Z56_CODBCO )
		While !SEE->(EOF()) .and. SEE->(EE_FILIAL+EE_CODIGO) == xFilial("SEE")+Z56->Z56_CODBCO
			If ALLTRIM(SEE->EE_CONTA) $ Z56->Z56_NUMCON .and. ALLTRIM(SEE->EE_AGENCIA) $ Z56->Z56_CODAGE .and. SEE->EE_SUBCTA == "002"	//--Registro de RETORNO
				cConta := SEE->EE_CONTA
				Exit
			EndIf
			SEE->(dbSkip())
		Enddo
	EndIf
	
	If cConta == STRINGNULL
		Aviso("Aviso","Parโmetros de banco nใo localizado para o banco "+Z56->Z56_CODBCO+" ag๊ncia "+Z56->Z56_CODAGE+" e conta "+Z56->Z56_NUMCON,{"OK"})
	Else
		If !Empty(SEE->EE_DIRREC) .and. !Empty(SEE->EE_EXTEN)
			cRetorno := ALLTRIM(SEE->EE_DIRREC)+DTOS(ddatabase)+"."+SEE->EE_EXTEN
		Else
			Aviso("Aviso","Campos de Diret๓rio de recebimento ou Extensใo nใo foram preenchidos nos parโmetros de banco.",{"OK"})
		EndIf
	EndIf

	RestArea(aAreaTMP)

Return (cRetorno)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFTRFNUM    บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Transforma็ใo de variแvel.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function FTRFNUM( nVALOR, nNUMCAR )
*---------------------------------------------------------------------------*
Local cVALOR := Replicate("0",nNUMCAR)

	If nVALOR > 0
		cVALOR := STRTRAN(cValToChar(nVALOR*100),".","")
		cVALOR := Replicate("0",nNUMCAR-Len(cVALOR)) + cVALOR
	EndIf

Return (cVALOR)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGravaLog  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Escreve no arquivo de log.                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fGravaLog(hFILELOG,cSTRING)                                  
*---------------------------------------------------------------------------*
	
	cSTRING := dtoc(ddatabase)+"-"+time()+"-"+cSTRING+chr(13)+chr(10)
	fWrite(hFILELOG,cSTRING,Len(cSTRING))					
	conout(cSTRING)

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBuscaTIT  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Responsแvel pela localiza็ใo do tํtulo.                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fBuscaTIT(cPRF,cNUM,cTIP,cCGC,nRECSE1)   
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Local cAliasTMP	:= GetNextAlias()
Local lRet := .F.

	cQuery := "	SELECT 		SE1.R_E_C_N_O_							"
	cQuery += "	FROM 		" + RetSQLName("SE1") + " SE1			"
	cQuery += "	INNER JOIN	" + RetSQLName("SA1") + " SA1			"
	cQuery += "	ON			SA1.A1_COD		= SE1.E1_CLIENTE		"
	cQuery += "	AND			SA1.A1_LOJA		= SE1.E1_LOJA			"
	cQuery += "	AND			SA1.A1_CGC		= '"+cCGC+"'			"
	cQuery += "	AND			SA1.D_E_L_E_T_	<> '*'					"
	cQuery += "	WHERE		SE1.E1_PREFIXO	= '"+cPRF+"'			"
	cQuery += "	AND			SE1.E1_NUM		= '"+cNUM+"'			"
	If cTIP != STRINGNULL
		cQuery += "	AND		SE1.E1_TIPO		= '"+cTIP+"'			"
	EndIf
	cQuery += "	AND			SE1.D_E_L_E_T_	<> '*'					"
		
	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())   	
  	If !(cAliasTMP)->(EOF())
		dbSelectArea("SE1")
		dbGoTop()
		dbGoTo((cAliasTMP)->R_E_C_N_O_)
		If !SE1->(EOF()) .and. !SE1->(BOF())
			nRECSE1 := (cAliasTMP)->R_E_C_N_O_
			lRet := .T.
		EndIf
	EndIf
	(cAliasTMP)->(dbCloseArea())
	
	RestArea(aAreaTMP)

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBuscaNCC  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  05/07/13  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Responsแvel pela localiza็ใo do tํtulo NCC.                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function fBuscaNCC(cCODCLI,cLOJCLI,cCMPDOC,cCMPSER)                   
*---------------------------------------------------------------------------*
Local aAreaTMP	:= GetArea()
Local cAliasTMP	:= GetNextAlias()
Local cRet := "N"

	cQuery := "	SELECT 		COUNT(*) NUMREC							"
	cQuery += "	FROM      	" + RetSQLName("SE1") + " SE1			"
	cQuery += "	WHERE		SE1.E1_PREFIXO	= '"+cCMPSER+"'			"
	cQuery += "	AND			SE1.E1_NUM		= '"+cCMPDOC+"'			"
	cQuery += "	AND			SE1.E1_CLIENTE	= '"+cCODCLI+"'			"
	cQuery += "	AND			SE1.E1_LOJA		= '"+cLOJCLI+"'			"	
	cQuery += "	AND			SE1.E1_TIPO		= 'NCC'      			"
	cQuery += "	AND			SE1.D_E_L_E_T_	<> '*'					"
		
	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())   	
  	If !(cAliasTMP)->(EOF())		
		If (cAliasTMP)->NUMREC > 0
			cRet := "S"
		EndIf
	EndIf
	(cAliasTMP)->(dbCloseArea())
	
	RestArea(aAreaTMP)

Return (cRet)

