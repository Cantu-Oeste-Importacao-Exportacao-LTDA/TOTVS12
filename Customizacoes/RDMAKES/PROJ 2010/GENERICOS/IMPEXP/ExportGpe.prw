#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"
#include "rwmake.ch"
// Exporta tabelas do TOP para CTREE
 
*------------------------------*
User Function COPIADTC()        
*------------------------------*    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

If MsgBox("Efetuar a cópia dos arquivos GPE para DTC?","Copia Arquivos GPE","YESNO")
	Processa( {|| fCheckTab() })
EndIf
Return

*------------------------------*
Static Function fCheckTab()     
*------------------------------*
Local aTables := {}
dbSelectArea("SX2")

SX2->(dbGoTop())

While SX2->(!Eof())
	if (SubStr(SX2->X2_CHAVE, 1, 2) $ "SR/SP/SQ/TL/TM/TN/TO/RC/" .Or. SX2->X2_CHAVE $ "LA1/RB7/RB8/RF0/RFE/RFB/SPG/SPH/SM2") //.And. !(SX2->X2_CHAVE $ "SRD/SPG/SPH")
		aAdd(aTables,{SX2->X2_CHAVE})
	EndIf
	SX2->(dbSkip())
  
/*    - Família SR*
  - Familia SP* 
  - Familia SQ*
  - Familia TL*
  - Familia TM*
  - Familia TN*
  - Familia TO*
  - Familia RC*
  - LA1
  - RB7 
  - RB8
  - RF0  
  - RFE 
  - RFB*/
  
EndDo

ProcRegua(len(aTables))

/* aAdd(aTables,{'CTT'}) 
 aAdd(aTables,{'SA6'})
 aAdd(aTables,{'SBM'})
 aAdd(aTables,{'SC6'})
 aAdd(aTables,{'SI3'})
 aAdd(aTables,{'QA1'})
 aAdd(aTables,{'QA6'})
 aAdd(aTables,{'QA7'})
 aAdd(aTables,{'QED'})
 aAdd(aTables,{'QEE'})
 aAdd(aTables,{'QEG'})
 aAdd(aTables,{'QEJ'})
 aAdd(aTables,{'QEX'})
 aAdd(aTables,{'QF1'})
 aAdd(aTables,{'QPD'})
 aAdd(aTables,{'QPE'})
 aAdd(aTables,{'QPF'})
 aAdd(aTables,{'QPG'})
 aAdd(aTables,{'QPX'})
 aAdd(aTables,{'RCE'})
 aAdd(aTables,{'RCF'})
 aAdd(aTables,{'RCG'})
 aAdd(aTables,{'RCS'})
 aAdd(aTables,{'RCU'})
 aAdd(aTables,{'RG3'})
 aAdd(aTables,{'SM2'})
 aAdd(aTables,{'SR2'})
 aAdd(aTables,{'SR3'})
 aAdd(aTables,{'SR4'})
 aAdd(aTables,{'SR6'})
 aAdd(aTables,{'SR7'})
 aAdd(aTables,{'SR8'})
 aAdd(aTables,{'SR9'})
 aAdd(aTables,{'SRA'})
 aAdd(aTables,{'SRB'})
 aAdd(aTables,{'SRC'})
 aAdd(aTables,{'SRD'})
 aAdd(aTables,{'SRF'})
 aAdd(aTables,{'SRG'})
 aAdd(aTables,{'SRH'})
 aAdd(aTables,{'SRJ'})
 aAdd(aTables,{'SRR'})
 aAdd(aTables,{'SRS'})
 aAdd(aTables,{'SRT'})
 aAdd(aTables,{'SRV'})
 aAdd(aTables,{'SRZ'})
 aAdd(aTables,{'SZ0'})*/
 
 // Empresas
  nI := 1  
  cSTREMP := StrZero(nI,2)
  
  cDestino := "\TABGPE\"

	If !File(cDestino)
		MAKEDIR(cDestino)
	EndIf
     
  cEMP := SM0->M0_CODIGO
  
  For nJ := 1 to Len(aTables)
  	
     
  cArquivo := RetSqlName(aTables[nJ,1]) // +cSTREMP+"0"
  
  IncProc("Processando tabela "+ cArquivo)
       
		dbSelectArea(aTables[nJ,1])
		dbGoTop()
		If !EOF()
			COPY TO &(cDestino+cArquivo)
		EndIf
		dbCloseArea(aTables[nJ,1])
		

  Next nJ
  
  // Copia o arquivo de moedas
  if !File("\TABGPE\SM2CMP.DTC") .And. cEmpAnt == "50"
  	dbSelectArea("SM2")
		dbGoTop()
		If !EOF()  	
			COPY TO &("\TABGPE\SM2CMP.DTC")
		EndIf
		dbCloseArea("SM2")
		                  
		// ARQUIVO CVN
		dbSelectArea("CVN")
		dbGoTop()
		If !EOF()  	
			COPY TO &("\TABGPE\CVNCMP.DTC")
		EndIf
		dbCloseArea("CVN")
	EndIf
  
   
 MsgInfo("Copiado Tabelas para o diretorio \TABGPE\")

Return