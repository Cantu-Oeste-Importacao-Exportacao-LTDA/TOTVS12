#INCLUDE "TOTVS.CH"                                                             
#INCLUDE "FILEIO.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUXISYS บAutor  ณRafael Parma         บ Data ณ  31/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma responsแvel pela interface de integra็ใo Protheus eบฑฑ
ฑฑบ          ณImport SYS.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿ 
*/

#DEFINE STRINGNULL		""				//--String null                          
#DEFINE nLIMITEREG		1000			//--Limite de registros por arquivo exportado
#DEFINE CPATHFILES		"/importsys/"	//--Path de escrita/leitura de arquivos servidor protheus                                                      
// BASETESTE GUILHERME
//#DEFINE CPATHARQIM		"C:\Softway\Base Desen\IN_OUT\INTERFACES\Saida\"	//--Path de escrita/leitura de arquivos a importar do servidor Import SYS  
//#DEFINE CPATHARQEX		"C:\Softway\Base Desen\IN_OUT\ArquivosTxt\"			//--Path de escrita/leitura de arquivos a exportar para servidor Import SYS

//Caminhos Base de Produ็ใo
//#DEFINE CPATHARQIM		"C:\Softway\Base Desen\IN_OUT\INTERFACES\Saida\"	//--Path de escrita/leitura de arquivos a importar do servidor Import SYS  
#DEFINE CPATHARQIM		"C:\Softway\Base_SFWPROD\IN_OUT\INTERFACES\Saida\"	//--Path de escrita/leitura de arquivos a importar do servidor Import SY  Alterado 04-06-12 porque no importsys estava gerando nessa pasta os arquivos
#DEFINE CPATHARQEX		"C:\Softway\Base_SFWPROD\IN_OUT\ArquivosTxt\"		//--Path de escrita/leitura de arquivos a exportar para servidor Import SYS

#DEFINE CENDOFFILE		"CHR(10)+CHR(13)"	//--Final de linha
#DEFINE CFILESE4_1		"cpg_"			//--SE4 - Interface: BS_PROFILE_BROKER - Condi็ใo de pagamento
#DEFINE CFILESB1_1		"prh_"			//--SB1 - Interface: BG_PRODUTO - Produto header
#DEFINE CFILESB1_2		"prpar_"		//--SB1 - Interface: BG_PRODUTO_PARCEIRO - Produto parceiro
#DEFINE CFILESB1_3		"prumc_"		//--SB1 - Interface: BG_PRODUTO_UN_MED_CONV_ESP - Unidade de medida
#DEFINE CFILESB1_4		"primp_"		//--SB1 - Interface: BG_PRODUTO_IMPORTADOR - Produto importador   
#DEFINE CFILESB1_5		"prdsc_" 		//--SB1 - Interface: BG_PRODUTO_DESCRICAO - Descri็ใo dos produtos na liguagem portugues Guilherme 11/06/12 orientado pelo Cicero da Becomex
#DEFINE CFILESA1_1		"parh_"			//--SA1/SA2 - Interface: BG_PARCEIRO_HEADER - Parceiros header 
#DEFINE CFILESA1_2		"parfun_"		//--SA1/SA2 - Interface: BG_PARCEIRO_FUNCAO - Parceiros fun็ใo 
#DEFINE CFILESA1_3		"parcon_"		//--SA1/SA2 - Interface: BG_CONTATO_PARCEIRO - Contato parceiro
#DEFINE CFILESA1_4		"parcom_"		//--SA1/SA2 - Interface: BG_COMPLEMENTAR_PARCEIRO - Parceiros complementar
#DEFINE CFILESC7_1		"ordimp_"		//--SC7 - Interface: IS_ORDEM_IMPORTACAO_HEADER - Cabe็alho pedido de compras
#DEFINE CFILESC7_2		"itord_"		//--SC7 - Interface: IS_ITENS_ORDEM_IMPORTACAO - Itens pedido de compras
#DEFINE CFILESE2_1		"spdesp_"		//--SE2 - Interface: V_IS_API_SP_DESP - Solicita็ใo de pagamento
#DEFINE CFILESE2_2		"fath_"			//--SE2 - Interface: V_IS_API_FATURA_IMP - Faturas de importa็ใo/adiantamentos
#DEFINE CFILESE2_3		"detparfat_"	//--SE2 - Interface: V_IS_API_ITEM_PARC_PRAZOS_FAT - Detalhes de Parcelas de faturas de importa็ใo
#DEFINE CFILESF1_1		"nf_"			//--SF1 - Interface: V_BS_API_NFE_NFC - Nota Fiscal de Entrada / Complementar header
#DEFINE CFILESF1_2		"itnf_"			//--SD1 - Interface: V_BS_API_ITEM_NFE_NFC - Nota Fiscal de Entrada / Complementar itens



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUXESYS บAutor  ณRafael Parma         บ Data ณ  31/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma responsแvel pela exporta็ใo das interfaces de inte-บฑฑ
ฑฑบ          ณgra็ใo Protheus vs. Import SYS.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
  
*--------------------------------*
User Function RJUXESYS()
*--------------------------------*
Private cDATAHORA := dtos(Date()) + time() + "-"
Private hFILESE4_1
Private hFILESB1_1
Private hFILESB1_2
Private hFILESB1_3
Private hFILESB1_4
Private hFILESB1_5
Private hFILESA1_1
Private hFILESA1_2
Private hFILESA1_3
Private hFILESA1_4
Private hFILESC7_1
Private hFILESC7_2

	/**
		Interface para exporta็ใo de arquivos Import SYS: RJUXESYS()
		Deverแ ser utilizado atrav้s de schedule: (U_RJUXESYS())
	**/

	cARQUIVO := "SE4"
	fProcSE4()
	cARQUIVO := "SB1"
	fProcSB1() 
	cARQUIVO := "SA1"
	fProcSA1()
	cARQUIVO := "SC7"
	fProcSC7()

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUXISYS บAutor  ณRafael Parma         บ Data ณ  31/08/2011 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrograma responsแvel pela importa็ใo das interfaces de inte-บฑฑ
ฑฑบ          ณgra็ใo Protheus vs. Import SYS.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------------*
User Function RJUXISYS(cARQUIVO)
*--------------------------------*                 
Private hFILESE2_1
Private hFILESE2_2
Private hFILESF1_1
Private hFILESD1_1

	/**
		Interface para importa็ใo de arquivos Import SYS: RJUXISYS()
		Deverแ ser utilizado atrav้s de schedule: (U_RJUXISYS())
	**/
	
	cARQUIVO := "SE2"
	fProcSE2()
	cARQUIVO := "SF1"
	fProcSF1()
                         
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSA1    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SA1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSA1()               
*---------------------------------------*
Local cSTRING   := STRINGNULL
Local cARQUIVO  := "SA1"
Local nREGISTRO := 0
Local cAliasTMP := GetNextAlias()

	CONOUT(TIME()+"-SA1-INICIO EXPORTACAO DE CLIENTES/FORNECEDORES.")
	
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "COM" TABLES "SB1"  
		
	cQuery := "	SELECT DISTINCT PARCEIRO 	"
	cQuery += "	FROM ( 		"
	cQuery += "		SELECT DISTINCT SA1.A1_COD || SA1.A1_LOJA PARCEIRO FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ != '*' AND SA1.A1_EST != 'EX' AND A1_X_ESYS = 'S' "
	cQuery += "		UNION ALL	"
	cQuery += "		SELECT DISTINCT SA2.A2_COD || SA2.A2_LOJA PARCEIRO FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ != '*' AND SA2.A2_EST != 'EX' AND A2_X_ESYS = 'S' "
	cQuery += "		UNION ALL	"
	cQuery += "		SELECT 'C' || SA1.A1_COD || SA1.A1_LOJA PARCEIRO FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ != '*' AND SA1.A1_EST = 'EX' AND A1_X_ESYS = 'S' "
	cQuery += "		UNION ALL	"
	cQuery += "		SELECT 'F' || SA2.A2_COD || SA2.A2_LOJA PARCEIRO FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ != '*' AND SA2.A2_EST = 'EX' AND A2_X_ESYS = 'S' "
	cQuery += "		)	"
	
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)                                                                 
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    While !(cAliasTMP)->(EOF())
    	
    	//--Controle de arquivos
    	If nREGISTRO == 0
    		fBegFile(cARQUIVO)
    	ElseIf nREGISTRO == nLIMITEREG
    		fEndFile(cARQUIVO)
    		fBegFile(cARQUIVO)
    		nREGISTRO := 0    		
    	EndIf	
    	
    	//--Cliente/Fornecedor
    	lSA1 := .F.
    	lSA2 := .F.    	
    	If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "C"
	    	dbSelectArea("SA1")
	    	dbSetOrder(1)
	    	dbSeek( xFilial("SA1") + SubSTR( (cAliasTMP)->PARCEIRO, 2, TAMSX3("A1_COD")[1]+TAMSX3("A1_LOJA")[1] ) )
	    	lSA1 := .T.
	    ElseIf SubSTR((cAliasTMP)->PARCEIRO,1,1) == "F"
	    	dbSelectArea("SA2")
	    	dbSetOrder(1)
	    	dbSeek( xFilial("SA2") + SubSTR( (cAliasTMP)->PARCEIRO, 2, TAMSX3("A2_COD")[1]+TAMSX3("A2_LOJA")[1] ) )
	    	lSA2 := .T.	    
		Else
	    	dbSelectArea("SA1")
	    	dbSetOrder(1)
	    	If dbSeek( xFilial("SA1") + (cAliasTMP)->PARCEIRO )
	    		lSA1 := .T.
	    	Else
	    		dbSelectArea("SA2")
		    	dbSetOrder(1)
		    	dbSeek( xFilial("SA2") + (cAliasTMP)->PARCEIRO )
	    		lSA2 := .T.
	    	EndIf
	    EndIf
    	
    	                     
		//--SA1/SA2 - Interface: BG_PARCEIRO_HEADER - Parceiros header 
		
    	cSTRING := STRINGNULL    	
    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	1
    	If lSA1
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "C"    		
    			cCAMPO := "C"+IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		Else                                                                                                                   
    			cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		EndIf
    	Else                                                    
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "F"    		                                                               
    			cCAMPO := "F"+IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		Else                                                                                                                   		
    			cCAMPO := IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		EndIf
    	EndIf
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_URF	A	7	21
    	/* NULLO
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_EST)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_EST)
    	EndIf   
    	*/
    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--COD_PAIS	A	3	28
    	If lSA1
    		cCAMPO := SubSTR(SA1->A1_CODPAIS,2,4)
    	Else
    		cCAMPO := SubSTR(SA2->A2_CODPAIS,2,4)
    	EndIf
    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NOME_FANTASIA	A	120	31
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_NREDUZ)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_NREDUZ)
    	EndIf
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	
    	cSTRING += cCAMPO + Space(120-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--COD_HOLDING	A	20	151
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--RAZAO_SOCIAL	A	120	171
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_NOME)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_NOME)
    	EndIf    	
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	
    	cSTRING += cCAMPO + Space(120-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CNPJ	A	18	291
    	If lSA1
    		If ALLTRIM(SA1->A1_PESSOA) == 'J' // Guilherme 11/06/12 Caso nใo seja Juridico, nใo preenche essa posi็ใo. Orientado pelo Cicero da Becomex
	    		cCAMPO := ALLTRIM(SA1->A1_CGC)
	    	Else    
	    		cCAMPO := STRINGNULL				//--CNPJ	A	18	291
	    	EndIf
    	Else
    		If ALLTRIM(SA2->A2_TIPO) == 'J'  // Guilherme 11/06/12 Caso nใo seja Juridico, nใo preenche essa posi็ใo. Orientado pelo Cicero da Becomex
    			cCAMPO := ALLTRIM(SA2->A2_CGC)
    		Else
    			cCAMPO := STRINGNULL				//--CNPJ	A	18	291
    		EndIf
    	EndIf    	    	
    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--INSCRICAO_ESTADUAL	A	30	309
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_INSCR)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_INSCR)
    	EndIf    	    	
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CIDADE	A	35	339
    	If lSA1
    		cCAMPO := ALLTRIM(SubSTR(SA1->A1_MUN,1,35))
    	Else
    		cCAMPO := ALLTRIM(SubSTR(SA2->A2_MUN,1,35))
    	EndIf
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    		    	    	
    	cSTRING += cCAMPO + Space(35-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--COMPLEMENTO	A	50	374
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_COMPLEMEN)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_COMPLEMEN)
    	EndIf                                        
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    		
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--ESTADO	A	30	424
    	If lSA1
    		dbSelectArea("SX5")
    		dbSetOrder(1)
    		dbSeek(xFilial("SX5")+"12"+SA1->A1_EST)
    		//cCAMPO := ALLTRIM(SX5->X5_DESCRI)+"-"+SA1->A1_EST  Colocado apenas a sigla do Estado a pedido do Anderson /// Guilherme
    		cCAMPO := SA1->A1_EST
    	Else
    		dbSelectArea("SX5")
    		dbSetOrder(1)
    		dbSeek(xFilial("SX5")+"12"+SA2->A2_EST)
    		//cCAMPO := ALLTRIM(SX5->X5_DESCRI)+"-"+SA2->A2_EST     Colocado apenas a sigla do Estado a pedido do Anderson /// Guilherme
    		cCAMPO := SA2->A2_EST
    	EndIf    	
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))    	
    	cCAMPO := STRINGNULL				//--CEP	A	20	454
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_CEP)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_CEP)
    	EndIf    	
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--OBS	A	250	474    	
    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))                  	
    	cCAMPO := STRINGNULL				//--EMAIL	A	50	724
    	If lSA1
    		cCAMPO := ALLTRIM(SubSTR(SA1->A1_EMAIL,1,50))
    	Else
    		cCAMPO := ALLTRIM(SubSTR(SA2->A2_EMAIL,1,50))
    	EndIf    	
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    	
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--LOGRADOURO	A	200	774
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_END)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_END)
    	EndIf    	
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    	
    	cSTRING += cCAMPO + Space(200-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NUMERO	A	6	974
    	cSTRING += cCAMPO + Space(06-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--TELEFAX	A	40	980
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_FAX)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_FAX)
    	EndIf
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := "1"						//--COD_VINCULACAO	A	2	1020
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--BAIRRO_PARC	A	25	1022
    	If lSA1
    		cCAMPO := SubSTR(SA1->A1_BAIRRO,1,25)
    		cCAMPO := ALLTRIM(cCAMPO)
    	Else
    		cCAMPO := SubSTR(SA2->A2_BAIRRO,1,25)
    		cCAMPO := ALLTRIM(cCAMPO)
    	EndIf
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    		
    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CAIXA_POSTAL_PARC	A	20	1047    	
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--TEL_PARC	A	40	1067        
    	If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_TEL)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_TEL)
    	EndIf    	
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--COD_PARCEIRO_EMPRESA	A	20	1107
    	If lSA1
    		cCAMPO := IIF(SA1->A1_MSBLQL=="2","A","I")
    	Else
    		cCAMPO := IIF(SA2->A2_MSBLQL=="2","A","I")
    	EndIf    	
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--AFILIADO	A	1	1127
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CPF	A	14	1128
    	If lSA1
	   		If ALLTRIM(SA1->A1_PESSOA) == 'F' // Guilherme 11/06/12 Caso nใo seja Fisico, nใo preenche essa posi็ใo. Orientado pelo Cicero da Becomex
	   			cCAMPO := ALLTRIM(SA1->A1_CGC)
	   		Else
	   			cCAMPO := STRINGNULL				//--CPF	A	14	1128      
	   		End
    	Else
    		If ALLTRIM(SA2->A2_TIPO) == 'F'   //Guilherme 11/06/12 Caso nใo seja Fisico, nใo preenche essa posi็ใo. Orientado pelo Cicero da Becomex
    				cCAMPO := ALLTRIM(SA2->A2_CGC)
    		Else
    				cCAMPO := STRINGNULL				//--CPF	A	14	1128
    		EndIf
    	EndIf    	    	
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--FLEX_FIELD1	A	240	1142
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--FLEX_FIELD2	A	240	1382
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--COD_PARCEIRO_EMPRESA1	A	20	1622
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--FLEX_FIELD3	A	240	1642
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--DUNS_NUMBER	A	25	1882
    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--PLANT_CODE	A	10	1907
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CAMINHO_LOGO	A	32	1917
    	cSTRING += cCAMPO + Space(32-LEN(cCAMPO))
    	cCAMPO := "0"						//--COD_VINCULACAO_SISBACEN	N	47	1949
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CLASSIFICACAO	A	1	1996
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NOTIFICAR	A	1	1997
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--PREFERENCIAL	A	1	1998
   		//Guilherme 04/05/12 adicionada a verificacao da natureza juridica, pois o mesmo deve estar na posicao 1999    	
   		If lSA1
    		cCAMPO := ALLTRIM(SA1->A1_PESSOA)
    	Else
    		cCAMPO := ALLTRIM(SA2->A2_TIPO)
    	EndIf    
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NATUREZA_JURIDICA	A	1	1999
    	// Guilherme 04/05/12 retirado a verificacao da natureza juridica, pois o mesmo deve estar na posicao 1999    	
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CANAL_BANCARIO	A	200	2000
    	cSTRING += cCAMPO + Space(200-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--ID_REGIAO	N	47	2200
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NOTIFICAR_IMPORTADOR	A	1	2247
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--CLASSIFICACAO_IMPORTADOR	A	50	2248
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NUM_REG_ORGAO_IMPORTADOR	A	20	2298
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--PORTE_EMPRESA	A	15	2318
    	cSTRING += cCAMPO + Space(15-LEN(cCAMPO))
    	cCAMPO := STRINGNULL				//--NUM_REFERENCIA_CORPORATIVO	A	50	2333
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := "N"						//--EMITE_NOTAFISCAL	A	1	2383
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := "N"						//--INTENCAO_FINANCIAMENTO	A	1	2384
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO)) 
    	
    	fWrtFile(cSTRING, hFILESA1_1)


		//--SA1/SA2 - Interface: BG_PARCEIRO_FUNCAO - Parceiros fun็ใo
		
    	cSTRING := STRINGNULL    	
    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	1
    	If lSA1
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "C"    		
    			cCAMPO := "C"+IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		Else                                                                                                                   
    			cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		EndIf
    	Else                                                    
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "F"    		                                                               
    			cCAMPO := "F"+IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		Else                                                                                                                   		
    			cCAMPO := IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		EndIf
    	EndIf

    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := "IMEX"							//--COD_FUNCAO_PARCEIRO	A	20	21
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ATIVO	A	1	41
    	If lSA1
    		cCAMPO := IIF(SA1->A1_MSBLQL=="2","S","N")
    	Else
    		cCAMPO := IIF(SA2->A2_MSBLQL=="2","S","N")
    	EndIf    	    	
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD1	A	240	42
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD2	A	240	282
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD3	A	240	522
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))

		
    	fWrtFile(cSTRING, hFILESA1_2)		

		 
		//--SA1/SA2 - Interface: BG_CONTATO_PARCEIRO - Contato parceiro

    	cSTRING := STRINGNULL    	
    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	1
    	lProc  := .F.
    	If lSA1                                                                                                   
    		If !Empty(SA1->A1_CONTATO)
    			lProc := .T.
    		EndIf

    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "C"    		
    			cCAMPO := "C"+IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		Else                                                                                                                   
    			cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		EndIf
    		
    		cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    	Else
    		If !Empty(SA2->A2_CONTATO)
    			lProc := .T.
    		EndIf

    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "F"    		                                                               
    			cCAMPO := "F"+IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		Else                                                                                                                   		
    			cCAMPO := IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		EndIf
    	EndIf
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_FUNCAO_CONTATO	A	20	21
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NOME_CONTATO_PARC	A	50	41
    	If lSA1
    		cCAMPO := SA1->A1_CONTATO
    	Else
    		cCAMPO := SA2->A2_CONTATO
    	EndIf
    	If chr(9) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(9),"")
    	EndIf    
    	If chr(13) $ cCAMPO
    		cCAMPO := STRTRAN(cCAMPO,chr(13),"")
    	EndIf        	    		    	    	
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TELEFONE_CONTATO_PARC	A	60	91
    	cSTRING += cCAMPO + Space(60-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FAX_CONTATO_PARC	A	60	151
    	cSTRING += cCAMPO + Space(60-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMAIL_CONTATO_PARC	A	250	211
    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))

		If lProc
    		fWrtFile(cSTRING, hFILESA1_3)		
  		EndIf

		
		//--SA1/SA2 - Interface: BG_COMPLEMENTAR_PARCEIRO - Parceiros complementar


    	cSTRING := STRINGNULL    	
    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	1
    	If lSA1
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "C"    		
    			cCAMPO := "C"+IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		Else                                                                                                                   
    			cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
    		EndIf
    	Else                                                    
    		If SubSTR((cAliasTMP)->PARCEIRO,1,1) == "F"    		                                                               
    			cCAMPO := "F"+IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		Else                                                                                                                   		
    			cCAMPO := IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
    		EndIf
    	EndIf
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--METODO_TRANSPORTE	A	2	21
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PORC_COMISSAO	N	47	23
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_PROCURADOR	N	47	70
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REGISTRO	A	10	117
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REG_SDA	A	8	127
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MATRICULA_INSS	A	12	135
    	cSTRING += cCAMPO + Space(12-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--INSCRICAO_MUNICIPAL	A	10	147
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := "0"								//--ID_IDIOMA	N	47	157
    	If lSA1                                                                                                   
    		dbSelectArea("SYA")
    		dbSetOrder(1)
    		If dbSeek(xFilial("SYA")+SA1->A1_PAIS)
    			If ALLTRIM(SYA->YA_IDIOMA) == "INGLES"
    				cCAMPO := "1"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "ESP."
    				cCAMPO := "2"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "ALEMAO"
    				cCAMPO := "3"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "FRANCE"
    				cCAMPO := "4"
				EndIf    				
    		EndIf    		
    	Else
    		dbSelectArea("SYA")
    		dbSetOrder(1)
    		If dbSeek(xFilial("SYA")+SA2->A2_PAIS)
    			If ALLTRIM(SYA->YA_IDIOMA) == "INGLES"
    				cCAMPO := "1"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "ESP."
    				cCAMPO := "2"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "ALEMAO"
    				cCAMPO := "3"
    			ElseIf ALLTRIM(SYA->YA_IDIOMA) == "FRANCE"
    				cCAMPO := "4"
				EndIf    				
    		EndIf    		
    	EndIf    	
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := "1"								//--COD_VINCULACAO	N	47	204
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_GRUPO_IMPORTADOR	N	47	251
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_ATIVIDADE_ECONOMICA	A	4	298
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DOCUMENTO	A	40	302
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_ZONA_SEC	A	8	342
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DESC_ZONA_SEC	A	30	350
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ATIVIDADE_ECONOMICA_EST	A	13	380
    	cSTRING += cCAMPO + Space(13-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_CODESP	A	6	393
    	cSTRING += cCAMPO + Space(06-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DATA_PROPOSTA	D	14	399
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--LOGOTIPO	A	40	413
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VENCIMENTO_CREDENCIAMENTO	D	14	453
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FUNDAP	A	1	467
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ISF	A	4	468
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SECEX	A	20	472
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--INSCRICAO_SUFRAMA	A	9	492
    	cSTRING += cCAMPO + Space(09-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ALERTA_CREDENCIAMENTO	A	10	501
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--INSMUNIC	A	5	511
    	cSTRING += cCAMPO + Space(05-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TIPO	A	1	516
    	If lSA1                                                                                                   
    		cCAMPO := IIF(SA1->A1_EST=="EX","I","N")
    	Else
    		cCAMPO := IIF(SA2->A2_EST=="EX","I","N")
    	EndIf
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PREFIXO	A	5	517
    	cSTRING += cCAMPO + Space(05-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TIPO_TRANSPORTE	A	1	522
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_CONTA_CONTABIL	A	20	523
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NUM_APOLICE_SEGURADORA_PARC	A	20	543
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DT_VIGENCIA_INICIO	D	14	563
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DT_VIGENCIA_FIM	D	14	577
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REF_CLIENTE	A	20	591
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REF_CLIENTE_IMP	A	20	611
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DT_APOLICE_SEGURADORA_PARC	D	14	631
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ALIADO_FAB	A	1	645
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ALIADO_IMP	A	1	646
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FREE_TIME	A	47	647
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DESCRICAO_BANCO	A	4000	694
    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SUB_CONTA_CONTABIL	A	20	4694
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := "N"								//--HUB	A	1	4714
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SUB_HUB	A	10	4715
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TAXA	N	47	4725
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--IC_VALOR_DESPESA_SEGURO	A	1	4772
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--IC_FORMULA_DESPESA_SEGURO	A	1	4773
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FORMULA	A	150	4774
    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
		
		fWrtFile(cSTRING, hFILESA1_4)
                              
		//--Atualiza FLAG
		If lSA1
			fUpdESYS("SA1", SA1->(RECNO()) )
		Else
			fUpdESYS("SA2", SA2->(RECNO()) )
		EndIf    
		
    	nREGISTRO += 1
    	(cAliasTMP)->(dbSkip())
    	
    Enddo
	                          
	If nREGISTRO != 0
		fEndFile(cARQUIVO)
	EndIf
	
	RpcClearEnv()
	
	CONOUT(TIME()+"-SA1-FIM EXPORTACAO DE CLIENTES/FORNECEDORES.")


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSB1    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SB1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSB1()               
*---------------------------------------*
Local cSTRING   := STRINGNULL
Local cARQUIVO  := "SB1"
Local nREGISTRO := 0
Local aDADOSIMP := {}
Local cAliasTMP := GetNextAlias()
Local cAliasPAR := GetNextAlias()
                                                                                                             
	CONOUT(TIME()+"-SB1-INICIO EXPORTACAO DE PRODUTOS.")

	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "COM" TABLES "SB1"  

	cQuery := "	SELECT R_E_C_N_O_ FROM " + RetSQLName(cARQUIVO) + " WHERE D_E_L_E_T_ != '*' AND B1_X_ESYS = 'S' AND B1_POSIPI != '"+Space(TAMSX3("B1_POSIPI")[1])+"' AND B1_POSIPI != '99999999' "
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)                                                                 
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
	If !(cAliasTMP)->(EOF())      
	
		//--Sele็ใo de importadores.
		cQuery := "	SELECT DISTINCT PARCEIRO 	"
		cQuery += "	FROM ( 		"
		cQuery += "		SELECT DISTINCT SA1.A1_COD || SA1.A1_LOJA PARCEIRO FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ != '*' AND SA1.A1_EST != 'EX' AND SA1.A1_X_IMPOR = 'S' "
		cQuery += "		UNION ALL	"
		cQuery += "		SELECT DISTINCT SA2.A2_COD || SA2.A2_LOJA PARCEIRO FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ != '*' AND SA2.A2_EST != 'EX' AND SA2.A2_X_IMPOR = 'S' "
		cQuery += "		UNION ALL	"
		cQuery += "		SELECT 'C' || SA1.A1_COD || SA1.A1_LOJA PARCEIRO FROM " + RetSQLName("SA1") + " SA1 WHERE SA1.D_E_L_E_T_ != '*' AND SA1.A1_EST = 'EX' AND SA1.A1_X_IMPOR = 'S' "
		cQuery += "		UNION ALL	"
		cQuery += "		SELECT 'F' || SA2.A2_COD || SA2.A2_LOJA PARCEIRO FROM " + RetSQLName("SA2") + " SA2 WHERE SA2.D_E_L_E_T_ != '*' AND SA2.A2_EST = 'EX' AND SA2.A2_X_IMPOR = 'S' "
		cQuery += "		)	"
		
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasPAR)                                                                 

	    dbSelectArea(cAliasPAR)
	    (cAliasPAR)->(dbGoTop())
	    While !(cAliasPAR)->(EOF())

	    	lSA1 := .F.
	    	lSA2 := .F.    	
	    	If SubSTR((cAliasPAR)->PARCEIRO,1,1) == "C"
		    	dbSelectArea("SA1")
		    	dbSetOrder(1)
		    	dbSeek( xFilial("SA1") + SubSTR( (cAliasPAR)->PARCEIRO, 2, TAMSX3("A1_COD")[1]+TAMSX3("A1_LOJA")[1] ) )
		    	lSA1 := .T.
		    ElseIf SubSTR((cAliasPAR)->PARCEIRO,1,1) == "F"
		    	dbSelectArea("SA2")
		    	dbSetOrder(1)
		    	dbSeek( xFilial("SA2") + SubSTR( (cAliasPAR)->PARCEIRO, 2, TAMSX3("A2_COD")[1]+TAMSX3("A2_LOJA")[1] ) )
		    	lSA2 := .T.	    
			Else
		    	dbSelectArea("SA1")
		    	dbSetOrder(1)
		    	If dbSeek( xFilial("SA1") + (cAliasPAR)->PARCEIRO )
		    		lSA1 := .T.
		    	Else
		    		dbSelectArea("SA2")
			    	dbSetOrder(1)
			    	dbSeek( xFilial("SA2") + (cAliasPAR)->PARCEIRO )
		    		lSA2 := .T.
		    	EndIf
		    EndIf
		    
	    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	1
	    	If lSA1
	    		If SubSTR((cAliasPAR)->PARCEIRO,1,1) == "C"    		
	    			cCAMPO := "C"+IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
	    		Else                                                                                                                   
	    			cCAMPO := IIF(LEN(ALLTRIM(SA1->A1_COD))==TAMSX3("A1_COD")[1],SA1->A1_COD,ALLTRIM(SA1->A1_COD)+".")+SA1->A1_LOJA
	    		EndIf
	    		aAdd ( aDADOSIMP, {cCAMPO, SA1->A1_NOME } )
	    	Else                                                    
	    		If SubSTR((cAliasPAR)->PARCEIRO,1,1) == "F"    		                                                               
	    			cCAMPO := "F"+IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
	    		Else                                                                                                                   		
	    			cCAMPO := IIF(LEN(ALLTRIM(SA2->A2_COD))==TAMSX3("A2_COD")[1],SA2->A2_COD,ALLTRIM(SA2->A2_COD)+".")+SA2->A2_LOJA
	    		EndIf                                      
	    		aAdd ( aDADOSIMP, {cCAMPO, SA2->A2_NOME } )
	    	EndIf
	    	
			(cAliasPAR)->(dbSkip())
		Enddo
		(cAliasPAR)->(dbCloseArea())
	EndIf
	

    //--Processamento de produtos.
    While !(cAliasTMP)->(EOF())
    	
    	//--Controle de arquivos
    	If nREGISTRO == 0
    		fBegFile(cARQUIVO)
    	ElseIf nREGISTRO == nLIMITEREG
    		fEndFile(cARQUIVO)
    		fBegFile(cARQUIVO)
    		nREGISTRO := 0    		
    	EndIf	
    	
    	//--Produtos
    	dbSelectArea(cARQUIVO)
    	dbGoTo((cAliasTMP)->R_E_C_N_O_)

    	//--Indicador de produtos
    	dbSelectArea("SBZ")
    	dbSetOrder(1)
    	If dbSeek(xFilial("SBZ")+SB1->B1_COD)
    		lIndicador := .T.
    	Else
    		lIndicador := .F.
    	EndIf 
    	
    	//--NCM do produto
    	dbSelectArea("SYD")
    	dbSetOrder(1)
    	If dbSeek(xFilial("SYD")+SB1->B1_POSIPI)
    		lNCM := .T.
    	Else
    		lNCM := .F.
    	EndIf 
    	               
    	    	
		//--SB1 - Interface: BG_PRODUTO - Produto header

    	cSTRING := STRINGNULL    	                     	
    	cCAMPO := ALLTRIM(SB1->B1_COD)				//--PART_NUMBER	A	100	1
    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
    	cCAMPO := "241"								//--COD_ORGANIZACAO	A	100	101  
    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_RECIPIENTE	A	2	201
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TP_EMBALAGEM	A	2	203
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CNPJ	A	18	205
    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_DISPOSITIVO	N	47	223
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_UM)				//--UNIDADE_ESTOQUE	A	4	270
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NALADINCCA	A	10	274
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := SubSTR(SB1->B1_POSIPI,01,08)		//--NCM	A	8	284
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NALADISH	A	8	292
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--LINHA_PRODUTO	A	8	300
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))                              
			cCAMPO := CVALTOCHAR(SB1->B1_PESBRU)		//--PESO_BRUTO	N	47	308    	
    	//cCAMPO := STRTRAN(cCAMPO,".","")			//--PESO_BRUTO	N	47	308
    	//cCAMPO := STRTRAN(cCAMPO,",",".")			//--PESO_BRUTO	N	47	308
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := CVALTOCHAR(SB1->B1_PESO)			//--PESO_LIQUIDO	N	47	355
    	//cCAMPO := STRTRAN(cCAMPO,".","")			//--PESO_LIQUIDO	N	47	355
    	//cCAMPO := STRTRAN(cCAMPO,",",".")			//--PESO_LIQUIDO	N	47	355
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REGISTRO_MS	A	30	402
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VALIDADE	D	14	432
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NECESSITA_LI	A	1	446
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--RECOF	A	1	447
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--REDUCAO_ICMS	N	47	448
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_ONU	A	18	495
    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SEQ_SUFRAMA	A	18	513
    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NAO_TRIBUTAVEL	A	1	531
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--IPI_ESPECIFICO	A	1	532
    	If lIndicador
    		If SBZ->BZ_IPI != 0
    			cCAMPO := "S"						//--IPI_ESPECIFICO	A	1	532
    		EndIf
    	EndIf    			
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--II_ESPECIFICO	A	1	533
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--II	N	47	534
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--IPI	N	47	581
    	If lIndicador
    		If SBZ->BZ_IPI != 0                                                
    			cCAMPO := CVALTOCHAR(SBZ->BZ_IPI)	//--IPI	N	47	581
		    	cCAMPO := STRTRAN(cCAMPO,".","")	//--IPI	N	47	581
		    	cCAMPO := STRTRAN(cCAMPO,",",".")	//--IPI	N	47	581		    	
			EndIf
		EndIf		    	
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VALOR_UNITARIA	N	47	628
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CAPACIDADE_UNITARIA	N	47	675
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FATOR_CONVERSAO	N	47	722
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_DESC)				//--DESCRICAO_RESUMIDA	A	250	769
    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
    	cCAMPO := DTOS(Date())					//--ATUALIZACAO	D	14	1019
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_MSBLQL)			//--STATUS	A	1	1033
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_UM)				//--UNIDADE_PESO	A	4	1034
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_UM)				//--COD_UNIDADE_QTDE	A	4	1038
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_UNIDADE_COMERCIALIZADA	A	4	1042
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_UNIDADE_UNITARIA	A	4	1046
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))                           
    	cCAMPO := STRINGNULL			   							//--PESO_QUILO	N	47	1050  Guilherme 11/06/12
    	//cCAMPO := CVALTOCHAR(SB1->B1_PESO)			//--PESO_QUILO	N	47	1050  Comentado ap๓s contato com Cicero da Becomex pois esse campo deve ir em branco
    	//cCAMPO := STRTRAN(cCAMPO,".","")			//--PESO_QUILO	N	47	1050
    	//cCAMPO := STRTRAN(cCAMPO,",",".")			//--PESO_QUILO	N	47	1050    	
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))								//--
    	cCAMPO := STRINGNULL 											//--PESO_QUILO	N	47	1050  Guilherme 11/06/12
    	//cCAMPO := CVALTOCHAR(SB1->B1_PESO)			//--PESO_UNID_COMERCIALIZADA	N	47	1097 Comentado ap๓s contato com Cicero da Becomex pois esse campo deve ir em branco
    	//cCAMPO := STRTRAN(cCAMPO,".","")			//--PESO_UNID_COMERCIALIZADA	N	47	1097
    	//cCAMPO := STRTRAN(cCAMPO,",",".")			//--PESO_UNID_COMERCIALIZADA	N	47	1097
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_EXTERNO_GIP	A	20	1144
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ULTIMO_INFORMANTE	N	47	1164
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TSP	A	4	1211
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TIPO_RECOF	A	1	1215
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--OBS	A	200	1216
    	cSTRING += cCAMPO + Space(200-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PESO_RATEAVEL	A	1	1416
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NECESSITA_REVISAO	A	1	1417
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	If SB1->B1_TIPO == "EM" .and. !Empty(SB1->B1_X_TPEMB)
    		cCAMPO := "E"							//--TIPO_PRODUTO	A	20	1418
    	Else
    		cCAMPO := "P"							//--TIPO_PRODUTO	A	20	1418
    	EndIf    		
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_ORIGEM)			//--PROCEDENCIA	A	1	1438    	
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CHASSI	A	1	1439
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ESPECIFICACAO_TECNICA	A	80	1440
    	cSTRING += cCAMPO + Space(80-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MATERIA_PRIMA_BASICA	A	1	1520
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--AUTOMATICO	A	1	1521
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_ORIGEM)			//--COD_ORIGEM	A	1	1522
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MATERIAL_GENERICO	A	1	1523
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CARGA_PERIGOSA	A	1	1524
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_UNIDADE_VENDA	A	4	1525
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD1	A	240	1529
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD2	A	240	1769
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD3	A	240	2009
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	/*cCAMPO := STRINGNULL						//--DESCRICAO_DETALHADA	A	4000	2249
    	If lNCM
    		cCAMPO := SYD->YD_DESC_P				//--DESCRICAO_DETALHADA	A	4000	2249	Comentado para mandar a descri็ใo simplificada informado pelo Cicero. Guilherme 14/06/12
    	EndIf
    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO)) */
    	cCAMPO := ALLTRIM(SB1->B1_DESC)				//--DESCRICAO_RESUMIDA	A	4000	2249
    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_PAIS_ORIGEM	A	3	6249
    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
    	cCAMPO := "0"								//--CICLO_PRODUTIVO	N	47	6252
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PART_NUMBER_FORNECEDOR	A	40	6299
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLAG_ATUALIZA_ICMS	A	1	6339
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_DISPOSITIVO_IPI	N	47	6340
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CODIGO_MOEDA	A	3	6387
    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VALOR_UNITARIO	N	47	6390
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_PROD	A	2	6437
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_PRODUCAO	A	2	6439
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PROCEDENCIA_EXP	A	1	6441
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO)) 
    	cCAMPO := STRINGNULL						//--ID_ANUENCIA	N	47	6442
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PESO_METRO_CUBICO	N	47	6489
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--HTS	A	10	6536
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NOME_COMERCIAL	A	250	6546
    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_MODELO	N	47	6796
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--UNIDADE_FRACIONADA	A	1	6843
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DIF_PESO_EMB	N	47	6844
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CLASS_PROD_RECOF	A	1	6891
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := "20110101"						//--DATA_INICIO	D	14	6892
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DATA_FIM	D	14	6906
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DATA_INSERT_MOV	D	14	6920
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_CORPORATIVO	A	100	6934
    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DATA_GER_LEG	D	14	7034
    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PROCEDENCIA_INFO	A	50	7048
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_PROD_SUFRAMA	A	4	7098
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PX_EXP_TIPOINS	A	1	7102
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TIPO_PROD_SUFRAMA	A	4	7103
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_DETALHE_SUFRAMA	N	47	7107
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VALOR_UNITARIO_REAL	N	47	7154
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NECESSITA_REVISAO_PEXPAM	A	1	7201
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MODELO	N	47	7202
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PX_MODELO_PADRAO	N	47	7249
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD4	A	240	7296
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD5	A	240	7536
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD6	A	240	7776
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD7	A	240	8016
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD8	A	240	8256
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD9	A	240	8496
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD10	A	240	8736
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLEX_FIELD11	A	240	8976
    	cSTRING += cCAMPO + Space(240-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PIS_COFINS_TIPO_APLIC	A	1	9216
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PIS	N	47	9217
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COFINS	N	47	9264
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PIS_COFINS_RED_BASE	N	47	9311
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MODELO_PROD_SUFRAMA	A	4	9358
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_SISCOMEX_UNIDADE_NCM	A	4	9362
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PART_NUMBER_CLIENTE	A	30	9366
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SUPERFICIE_UNITARIA	N	47	9396
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := ALLTRIM(SB1->B1_LOCPAD)			//--LOCAL_ESTOQUE	A	10	9443
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_UNIDADE_SUPERFICIE	A	4	9453
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--RATEIO_PRODUTO_ACABADO	A	1	9457
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PIS_COFINS_COD_UN_ESPEC	A	4	9458
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--RECUPERA_IMPOSTOS	A	1	9462
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FLAG_NO_RAF	A	1	9463
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NOTA_COMPL_TIPI	A	2	9464
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--IPI_REDUZIDO	N	47	9466
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--SUJEITO_LOTE	A	1	9513
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--MARCA_COMERCIAL	A	50	9514
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TIPO_EMBALAGEM	A	150	9564
    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NUM_LIBERACAO_BRASILIA	A	50	9714
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TEMPERATURA_CONSERVACAO	A	10	9764
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--UMIDADE	A	10	9774
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--LUMINOSIDADE	A	80	9784
    	cSTRING += cCAMPO + Space(80-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMBALAGEM_SECUNDARIA	A	50	9864
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FORMA_FISICA	A	50	9914
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--FINALIDADE	A	50	9964
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ITEM_PRODUTIVO_RC	A	1	10014
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMBALAGEM_PRIMARIA	A	50	10015
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DESCRICAO_ANVISA	A	250	10065
    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--VOLUME	N	47	10315
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_UNIDADE_MEDIDA_DIMENSAO	A	4	10362
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_MATERIAL	A	30	10366
    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))    	
    	cCAMPO := "N"								//--FLAG_EMBALAGEM	A	1	10396
    	If SB1->B1_TIPO == "EM" .and. !Empty(SB1->B1_X_TPEMB)
    		cCAMPO := "S"							//--FLAG_EMBALAGEM	A	1	10396
    	EndIf
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_TP_EMB	A	20	10397
    	If SB1->B1_TIPO == "EM" .and. !Empty(SB1->B1_X_TPEMB)
	    	cCAMPO := ALLTRIM(SB1->B1_X_TPEMB)		//--EMB_TP_EMB	A	20	10397
    	EndIf
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_NCM	A	8	10417
    	If SB1->B1_TIPO == "EM" .and. !Empty(SB1->B1_X_TPEMB)    	
	    	cCAMPO := SubSTR(SB1->B1_POSIPI,01,08)	//--EMB_NCM	A	8	10417
    	EndIf
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_DESC_TP_EMB	A	200	10425
    	If SB1->B1_TIPO == "EM" .and. !Empty(SB1->B1_X_TPEMB)   	
	    	dbSelectArea("SJF")
	    	dbSetOrder(1)	    	
	    	If dbSeek(xFilial("SJF")+SubSTR(SB1->B1_X_TPEMB,1,TAMSX3("JF_CODIGO")[1]))
	    		cCAMPO := ALLTRIM(SJF->JF_DESC)		//--EMB_DESC_TP_EMB	A	200	10425
	    	EndIf
    	EndIf
    	cSTRING += cCAMPO + Space(200-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_TP_EMBALAGEM_SISCOMEX	A	2	10625
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_COD_UNIDADE_MEDIDA_DIM	A	4	10627
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_COD_UNIDADE_MEDIDA_PESO	A	4	10631
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_ALTURA	N	47	10635
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_LARGURA	N	47	10682
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_COMPRIMENTO	N	47	10729
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_PESO_EMBALAGEM	N	47	10776
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_IC_ALTURA_VARIAVEL	A	1	10823
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_IC_CONTAINER	A	1	10824
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_IC_PRIMARIA	A	1	10825
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_IC_PADRAO	A	1	10826
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_IC_RETORNAVEL	A	1	10827
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_ABREVIACAO_TP_EMB	A	2	10828
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_PRECO	N	47	10830
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_POSICAO_RELATORIO	A	1	10877
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_COD_MOEDA	A	25	10878
    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_TARA	N	47	10903
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_VOLUME	N	47	10950
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_VOLUME_MAXIMO	N	47	10997
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_PESO_MAXIMO	N	47	11044
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--EMB_ID_EMB_TP_DESIGNACAO	A	20	11091
    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--CLASSE_RISCO	A	40	11111
    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_RISCO	A	25	11151
    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_ESTRUTURA_ATUAL	N	47	11176
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_SISTEMA	N	47	11223
    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
    	
		fWrtFile(cSTRING, hFILESB1_1)
		
		
		//--SB1 - Interface: BG_PRODUTO_PARCEIRO - Produto parceiro
        
		If !Empty(SB1->B1_X_CODFB) .AND. !Empty(SB1->B1_X_LOJFB)
		
	    	cSTRING := STRINGNULL    	                     	
	    	cCAMPO := ALLTRIM(SB1->B1_COD)				//--PART_NUMBER	A	100	1
	    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
	    	cCAMPO := STRINGNULL						//--COD_PARCEIRO	A	20	101
			cCAMPO := IIF(LEN(ALLTRIM(SB1->B1_X_CODFB))==TAMSX3("A2_COD")[1],SB1->B1_X_CODFB,ALLTRIM(SB1->B1_X_CODFB)+".")+SB1->B1_X_LOJFB    	
	    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))    	
	    	cCAMPO := "241"								//--COD_ORGANIZACAO	A	100	121
	    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
	    	cCAMPO := "IMEX"							//--COD_FUNCAO_PARCEIRO	A	20	221
	    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
	    	cCAMPO := STRINGNULL						//--PART_NUMBER_PARCEIRO	A	50	241
	    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
	    	cCAMPO := STRINGNULL						//--IC_DEFAULT	A	20	291
	    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
	    	cCAMPO := STRINGNULL						//--STATUS	A	1	311
	    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
	    	cCAMPO := STRINGNULL						//--SEGMENTO1	A	100	312
	    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
	                                                                     
			fWrtFile(cSTRING, hFILESB1_2)
		
		EndIf

		//-- SB1 - Interface: BG_PRODUTO_UN_MED_CONV_ESP - Unidade de medida		        

     	If !Empty(SB1->B1_SEGUM)
	     	
	     	cSTRING := STRINGNULL    	                     	
	    	cCAMPO := ALLTRIM(SB1->B1_COD)				//--PART_NUMBER	A	100	1
	    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
	    	cCAMPO := "241"								//--COD_ORGANIZACAO	A	100	101
	    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
	    	cCAMPO := ALLTRIM(SB1->B1_SEGUM)			//--COD_UNIDADE_DESTINO	A	4	201
	    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
			cCAMPO := CVALTOCHAR(SB1->B1_CONV)			//--FATOR_CONVERSAO	N	47	205
	    	cCAMPO := STRTRAN(cCAMPO,".","")			//--FATOR_CONVERSAO	N	47	205
	    	cCAMPO := STRTRAN(cCAMPO,",",".")			//--FATOR_CONVERSAO	N	47	205
	    	cSTRING += cCAMPO + Space(47-LEN(cCAMPO))
	                                                                     
			fWrtFile(cSTRING, hFILESB1_3)
		
		EndIf
			
		
		//--SB1 - Interface: BG_PRODUTO_IMPORTADOR - Produto importador
		
     	If Len(aDADOSIMP) > 0
     		For nI := 1 to Len(aDADOSIMP)
	     	
		     	cSTRING := STRINGNULL    	                     	
		    	cCAMPO := ALLTRIM(SB1->B1_COD)				//--PART_NUMBER	A	100	1
		    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
		    	cCAMPO := "241"								//--COD_ORGANIZACAO	A	100	101
		    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
		    	cCAMPO := aDADOSIMP[nI,01]					//--COD_PARCEIRO	A	20	201
		    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
				cCAMPO := "N"								//--DIFERIMENTO_PRODUTOS	A	1	221
		    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
		                              
				fWrtFile(cSTRING, hFILESB1_4)
		  	Next nI
	  	EndIf 
	  	
	  //--SB1 - Interface: BG_PRODUTO_DESCRICAO - Descri็ใo dos produtos Guilherme 12/06/12
	  cSTRING := STRINGNULL    	                     	
    cCAMPO 	:= ALLTRIM(SB1->B1_COD)	//--PART_NUMBER	A	100	1
    cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
   	cCAMPO 	:= "241"								//--COD_ORGANIZACAO	A	100	101
   	cSTRING += cCAMPO + Space(100-LEN(cCAMPO)) 
   	cCAMPO 	:= "0"                  //--CODIGO_IDIOMA A 20 201
   	cSTRING	+= cCAMPO + Space(20-LEN(cCAMPO))  
   	cCAMPO 	:= ALLTRIM(SB1->B1_DESC) //--DESCRICAO_RESUMIDA A 250 221
   	cSTRING	+= cCAMPO + Space(250-LEN(cCAMPO))
   	cCAMPO  := ALLTRIM(SB1->B1_DESC) //--DESCRICAO_DETALHADA	A	4000	471
	  cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
	  cCAMPO  := STRINGNULL						//--DESCRICAO_VENDA	A	250	4471
	  cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
	  fWrtFile(cSTRING, hFILESB1_5)   	      	
    //--SB1 - Interface BG_PRODUTO_DESCRICAO Fim
    
		//--Atualiza FLAG
		If RecLock("SB1",.F.)
			fUpdESYS("SB1", SB1->(RECNO()) )
		EndIf
    	
    	nREGISTRO += 1
    	(cAliasTMP)->(dbSkip())
    	
    Enddo
	                          
	If nREGISTRO != 0
		fEndFile(cARQUIVO)
	EndIf
	
	RpcClearEnv()
	
	CONOUT(TIME()+"-SB1-FIM EXPORTACAO DE PRODUTOS.")

Return



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSE4    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SE4.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSE4()               
*---------------------------------------*
Local cSTRING   := STRINGNULL
Local cARQUIVO  := "SE4"
Local nREGISTRO := 0
Local cAliasTMP := GetNextAlias() 

	CONOUT(TIME()+"-SE4-INICIO EXPORTACAO DE CONDICAO DE PAGAMENTO.")
  
	RpcClearEnv()
	RPCSetType(3)
	
	PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "COM" TABLES "SE4"

	cQuery := "	SELECT R_E_C_N_O_ FROM " + RetSQLName(cARQUIVO) + " WHERE D_E_L_E_T_ != '*' AND E4_TIPO = '1' AND E4_X_ESYS = 'S' "
	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)                                                                 
	
	dbSelectArea(cAliasTMP)
	(cAliasTMP)->(dbGoTop())
    While !(cAliasTMP)->(EOF())
    	
    	//--Controle de arquivos
    	If nREGISTRO == 0
    		fBegFile(cARQUIVO)
    	ElseIf nREGISTRO == nLIMITEREG
    		fEndFile(cARQUIVO)
    		fBegFile(cARQUIVO)
    		nREGISTRO := 0    		
    	EndIf	
    	
    	//--Condi็ใo de pagamento
    	dbSelectArea(cARQUIVO)
    	dbGoTo((cAliasTMP)->R_E_C_N_O_)
    	                     
    	//--SE4 - Interface: BS_PROFILE_BROKER - Condi็ใo de pagamento
    	
    	cSTRING := STRINGNULL    	
    	cCAMPO := ALLTRIM(SE4->E4_CODIGO)			//--COND_PAGAMENTO	50	1
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := "1"								//--COD_COB_CAMBIAL	1	51
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_AGENTE_IMP	5	52
    	cSTRING += cCAMPO + Space(05-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--BANCO	3	57
    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--AGENCIA	4	60
    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_MOD_PAGTO	2	64
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_INST_FINANC	2	66
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_MOT_SEM_COB	2	68
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PARCELAS	8	70
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--PERIODICIDADE	8	78
    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TPO_PERIODICIDADE	1	86
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NO_CHARGE	1	87
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_TAXA_JURO	10	88
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--TAXA_JURO	10	98
    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
    	cCAMPO := "F"								//--TIPO_PARCELA	1	108
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--GERAR_PARC_AUTO	1	109
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--DESCR_TIPO_PAGTO	50	110
    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--COD_FRM_COBR	2	160
    	cSTRING += cCAMPO + Space(02-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--ID_DATA_BASE	1	162
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	cCAMPO := STRINGNULL						//--NรO_GERAR_INDFAT	1	163
    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
    	
		fWrtFile(cSTRING, hFILESE4_1)
        
		//--Atualiza FLAG
		fUpdESYS("SE4", SE4->(RECNO()) )
    	
    	nREGISTRO += 1
    	(cAliasTMP)->(dbSkip())
    	
    Enddo
	                          
	If nREGISTRO != 0
		fEndFile(cARQUIVO)
	EndIf
	
	RpcClearEnv()
	
	CONOUT(TIME()+"-SE4-FIM EXPORTACAO DE CONDICAO DE PAGAMENTO.")

Return
    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSC7    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SC7.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSC7()               
*---------------------------------------*
Local cSTRING   := STRINGNULL         
Local cPEDIDO   := STRINGNULL         
Local cARQUIVO  := "SC7"
Local nREGISTRO := 0
Local aEMPRESAS := {}
Local cAliasTMP := GetNextAlias()

	CONOUT(TIME()+"-SC7-INICIO EXPORTACAO DE PEDIDO DE COMPRAS.")
  
	RpcClearEnv()
	RPCSetType(3)

	PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "COM" TABLES "SA2","SB1","SC7"

  //-- Adiciona ao array todas as empresas do grupo
  dbSelectArea("SM0")
  nRECSM0 := SM0->(RECNO())
	dbGoTop()
	While !SM0->(EOF()) 
		If SM0->M0_CODIGO != "11" .and. SM0->M0_CODIGO != "33" //Gustavo 23/01/15 - Tratativa devido a problemas na licen็a das empresas
			aAdd ( aEMPRESAS, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC } )
		EndIf
		SM0->(dbSkip())             
	Enddo
	dbGoTo(nRECSM0)       
	
	If Len(aEMPRESAS) > 0
	
		_cODEMPRESA := STRINGNULL

		For _nINDEMP := 1 to Len(aEMPRESAS)
                	
  			If _cODEMPRESA != aEMPRESAS[_nINDEMP,01] 
			
				_cODEMPRESA := aEMPRESAS[_nINDEMP,01]
			
				RpcClearEnv()
				RPCSetType(3)
	
	     		PREPARE ENVIRONMENT EMPRESA aEMPRESAS[_nINDEMP,01] FILIAL aEMPRESAS[_nINDEMP,02] MODULO "COM" TABLES "SA2","SB1","SC7"
	     		
	     		CONOUT(TIME()+"-SC7-EMPRESA/FILIAL: "+cEmpAnt+"/"+cFilAnt)
	     		
			Else				
				Loop			
			EndIf	                	


			cPEDIDO := STRINGNULL
			cQuery := "	SELECT R_E_C_N_O_, C7_FILIAL, C7_NUM, C7_ITEM FROM " + RetSQLName(cARQUIVO) + " WHERE D_E_L_E_T_ != '*' AND C7_X_ESYS = 'S' ORDER BY C7_FILIAL, C7_NUM, C7_ITEM "
			
			TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)                                                                 		
			
			dbSelectArea(cAliasTMP)
			(cAliasTMP)->(dbGoTop())
			If !(cAliasTMP)->(EOF())
			    
			    If nREGISTRO == 0
			    	//--Controle de arquivos
			    	fBegFile(cARQUIVO)
			    EndIf
			    
			    While !(cAliasTMP)->(EOF())
			    	
			    	//--Pedido de compras
			    	dbSelectArea(cARQUIVO)
			    	dbGoTo((cAliasTMP)->R_E_C_N_O_)
			            
					//--Produto
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)
					
					//--SC7 - Interface: IS_ORDEM_IMPORTACAO_HEADER - Cabe็alho pedido de compras
				    	
					If cPEDIDO != SC7->C7_NUM 
					
						CONOUT(TIME()+"-SC7-EXPORTACAO PEDIDO: "+SC7->C7_NUM)
						
				    	cSTRING := STRINGNULL    	
				    	cCAMPO := STRINGNULL						//--AREA_NEGOCIO	A	20	1		    	
				    	If cEmpAnt == "50"
				    		cCAMPO := "CANTU"
				    	Else
				    		cCAMPO := "LEVEL TRADE"
				    	EndIf
				    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--CODIGO_COMPRADOR	A	8	21
				    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--COD_IMPORTADOR	A	20	29
				    	nPOSE := aScan(aEMPRESAS, {|x| x[1]==cEmpAnt .and. x[2] ==SC7->C7_FILIAL })
				    	cCODORG := SubSTR(aEMPRESAS[nPOSE,03],1,8)+"."+SubSTR(aEMPRESAS[nPOSE,03],9,4)
				    	cCAMPO := cCODORG		    	
				    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--COD_INCOTERM	A	3	49
				    	cCAMPO := ALLTRIM(SC7->C7_X_INCOT)			//--COD_INCOTERM	A	3	49
				    	If Empty(SC7->C7_X_INCOT)                                                 
				    		cCAMPO := "EXW"							//--COD_INCOTERM	A	3	49
				    	EndIf				    	
				    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
				    	cCAMPO := ALLTRIM(SC7->C7_COND)				//--COND_PAGTO	A	50	52
				    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
				    	cCAMPO := DTOS(SC7->C7_DATPRF)				//--DATA_LIMITE	D	8	102
				    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
				    	cCAMPO := DTOS(SC7->C7_EMISSAO)				//--DATA_PEDIDO	D	8	110
				    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
				    	cCAMPO := DTOS(SC7->C7_DATPRF)				//--DATA_PREVISTA	D	8	118
				    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
				    	cCAMPO := SC7->C7_NUM						//--NUM_PEDIDO	A	16	126
				    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))
				    	cCAMPO := "A"								//--COD_STATUS	A	1	142
				    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))				    	
				    	cCAMPO := STRINGNULL						//--TIPO_PEDIDO	A	3	143				    	
				    	If Empty(SC7->C7_X_TOIMP)
							cCAMPO := "001"							//--TIPO_PEDIDO	A	3	143				    					    	
				    	Else
					    	dbSelectArea("CTH")
					    	dbSetOrder(5) // Troquei a ordem do indice por nao estar encontrando os registros com esse indice
					    	If dbSeek(xFilial("CTH")+SC7->C7_X_TOIMP)                              
					    		cCAMPO := ALLTRIM(CTH->CTH_X_CIS)	//--TIPO_PEDIDO	A	3	143				    					    	
								Else
									cCAMPO := "001"						//--TIPO_PEDIDO	A	3	143				    					    	
								EndIf				    		
				    	EndIf
				    	cSTRING += cCAMPO + Space(03-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--NUM_REQUISICAO	A	15	146
				    	cSTRING += cCAMPO + Space(15-LEN(cCAMPO))
				    	cCAMPO := "N"								//--COD_PRIORIDADE	A	1	161
				    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--DETALHE_TIPO	A	60	162
				    	cSTRING += cCAMPO + Space(60-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--SEMANA_DESEJADA	A	7	222
				    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--SEMANA_CONFIRMADA	A	7	229
				    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
				    	cCAMPO := "N"								//--REMESSA	A	1	236
				    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--OBS	A	3500	237
				    	cSTRING += cCAMPO + Space(3500-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--COD_ADQUIRENTE	A	41	3737
				    	If !Empty(SC7->C7_X_CADQU) .and. !Empty(SC7->C7_X_LADQU)
					    	dbSelectArea("SA1")
					    	dbSetOrder(1)
					    	dbSeek(xFilial("SA1")+SC7->C7_X_CADQU+SC7->C7_X_LADQU)
					    	If SA1->A1_EST == "EX"
								cCAMPO := "C"
							EndIf				    					    	
				    		cCAMPO += IIF(LEN(ALLTRIM(SC7->C7_X_CADQU))==TAMSX3("A2_COD")[1],SC7->C7_X_CADQU,ALLTRIM(SC7->C7_X_CADQU)+".")+SC7->C7_X_LADQU
				    	EndIf
				    	cSTRING += cCAMPO + Space(41-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--LOCATION_CODE	A	30	3778
				    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--COD_VIA_TRANSPORTE	A	15	3808
				    	If Empty(SC7->C7_X_VTRAN)
					    	dbSelectArea("SX5")
					    	dbSetOrder(1)
					    	If dbSeek(xFilial("SX5")+"Y3"+SC7->C7_X_VTRAN)                              
					    		cCAMPO := ALLTRIM(SX5->X5_DESCRI)	//--COD_VIA_TRANSPORTE	A	15	3808
							EndIf				    					    	
						EndIf
						If cCAMPO == STRINGNULL
							cCAMPO := "MARITIMO"					//--COD_VIA_TRANSPORTE	A	15	3808						
						EndIf
				    	cSTRING += cCAMPO + Space(15-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--ORIGEM_AGENTE_CARGA	A	100	3823
				    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--ID_INTERFACE	A	10	3923
				    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--OFFICE	A	4	3933
				    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--NOME_CLIENTE	A	40	3937
				    	cSTRING += cCAMPO + Space(40-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--POOL_ID	A	14	3977
				    	cSTRING += cCAMPO + Space(14-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--PROJECT_CODE	A	20	3991
				    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--AVIEXP	N	15	4011
				    	cSTRING += cCAMPO + Space(15-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--ID_TIPO	N	8	4026
				    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--COD_AGENTE_CARGA	A	20	4034
				    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--ORIGEM_INCOTERM	A	30	4054
				    	cSTRING += cCAMPO + Space(30-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD1	A	150	4084
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD2	A	150	4234
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD3	A	150	4384
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD4	A	150	4534
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD5	A	150	4684
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD6	A	150	4834
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD7	A	150	4984
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD8	A	150	5134
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD9	A	150	5284
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--FLEX_FIELD10	A	150	5134
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--NOME COMPRADOR	A	100	5134
				    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--EMAIL COMPRADOR	A	150	5284
				    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
				    	cCAMPO := STRINGNULL						//--TELEFONE COMPRADOR	A	50	5434
				    	cSTRING += cCAMPO + Space(50-LEN(cCAMPO))
				    	
						fWrtFile(cSTRING, hFILESC7_1)
				
					EndIf
				
			
			
					//--SC7 - Interface: IS_ITENS_ORDEM_IMPORTACAO - Itens pedido de compras	    	                     
			
			    	cSTRING := STRINGNULL    	
			    	cCAMPO := ALLTRIM(SC7->C7_CC)				//--CENTRO_CUSTO	A	12	1
			    	cSTRING += cCAMPO + Space(12-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--CODIGO_FORNECEDOR	A	20	13
			    	dbSelectArea("SA2")
			    	dbSetOrder(1)
			    	dbSeek(xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA)
			    	If SA2->A2_EST == "EX"
						cCAMPO := "F"
					EndIf		    	
			    	cCAMPO += IIF(LEN(ALLTRIM(SC7->C7_FORNECE))==TAMSX3("A2_COD")[1],SC7->C7_FORNECE,ALLTRIM(SC7->C7_FORNECE)+".")+SC7->C7_LOJA
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--COD_EXTERNO_CFOP	A	25	33
			    	/*
			    	If !Empty(SC7->C7_TES)
			    		cCAMPO := ALLTRIM(POSICIONE("SF4",1,xFilial("SF4")+SC7->C7_TES,"F4_CF"))
			    	EndIf
			    	*/
			    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--COD_FABRICANTE	A	20	58
			    	If !Empty(SB1->B1_X_CODFB) .and. !Empty(SB1->B1_X_LOJFB)
				    	dbSelectArea("SA2")
				    	dbSetOrder(1)
				    	dbSeek(xFilial("SA2")+SB1->B1_X_CODFB+SB1->B1_X_LOJFB)
				    	If SA2->A2_EST == "EX"
							cCAMPO := "F"
						EndIf		    	
						cCAMPO += IIF(LEN(ALLTRIM(SB1->B1_X_CODFB))==TAMSX3("A2_COD")[1],SB1->B1_X_CODFB,ALLTRIM(SB1->B1_X_CODFB)+".")+SB1->B1_X_LOJFB		    	
			    	EndIf
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--CONTA_CONTABIL	A	20	78
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := DTOS(SC7->C7_DATPRF)				//--DATA_PREVISTA	D	8	98
			    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--DESCRICAO	A	250	106
			    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--ITEM_CONTRATO	N	7	356
			    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(SC7->C7_ITEM)				//--ITEM_PEDIDO	N	7	363
			    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--MOEDA	A	25	370	
			    	//-- 1-BRL-REAIS/2-USD-DOLLAR/4-EUR-EURO/5-JPY-IENE/6-ARS-PESO ARGENTINO/7-CLP-PESO CHILENO
			    	If SC7->C7_MOEDA == 2
						cCAMPO := "USD"
			    	ElseIf SC7->C7_MOEDA == 4
						cCAMPO := "EUR"
			    	ElseIf SC7->C7_MOEDA == 5
						cCAMPO := "JPY"
			    	ElseIf SC7->C7_MOEDA == 6
						cCAMPO := "ARS"
			    	ElseIf SC7->C7_MOEDA == 7
						cCAMPO := "CLP"
			    	Else
						cCAMPO := "REAL"
					EndIf		
			    	cSTRING += cCAMPO + Space(25-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(SC7->C7_FLUXO)			//--NO_CHARGE	A	1	395
			    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--NUM_CONTRATO	A	20	396
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(SC7->C7_NUM)				//--NUM_PEDIDO	A	16	416
			    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))
			    	cCAMPO := "241"								//--ORGANIZACAO	A	100	432
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(SC7->C7_PRODUTO)			//--PART_NUMBER	A	100	532
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(CVALTOCHAR(SB1->B1_PESO))	//--PESO_LIQUIDO	N	21	632
			    	cSTRING += cCAMPO + Space(21-LEN(cCAMPO))                                  
			    	cCAMPO := STRINGNULL						//--PN_FABRICANTE	A	100	653
			    	cCAMPO := ALLTRIM(SB1->B1_X_CODFA)			//--PN_FABRICANTE	A	100	653
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(CVALTOCHAR(SC7->C7_PRECO))//--PRECO_LIQ	N	21	753
			    	cSTRING += cCAMPO + Space(21-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--PROFIT_CENTER	A	10	774
			    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
			    	cCAMPO := ALLTRIM(CVALTOCHAR(SC7->C7_QUANT))//--QTD_PEDIDO	N	18	784
			    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
			    	cCAMPO := "A"								//--STATUS	A	1	802
			    	cSTRING += cCAMPO + Space(01-LEN(cCAMPO))
			    	cCAMPO := "KG"								//--UNIDADE_PESO	A	4	803
			    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
			    				  
			    	If !ALLTRIM(SB1->B1_UM) == "T"
			    		cCAMPO := ALLTRIM(SB1->B1_UM)				//--UNID_MED_ITEM_PEDIDO	A	4	807
			    	Else
							cCAMPO := "TON"				//--UNID_MED_ITEM_PEDIDO	A	4	807			    				
						EndIF
			    	
			    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--UNID_MED_PRECO	A	4	811
			    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--SUB_CONTA	A	20	815
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD1	A	100	835
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD2	A	100	935
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD3	A	100	1035
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD4	A	100	1135
			    	cSTRING += cCAMPO + Space(100-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD5	A	4000	1235
			    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD6	A	4000	5235
			    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD7	A	4000	9235
			    	cSTRING += cCAMPO + Space(4000-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD8	A	150	13235
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD9	A	150	13385
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD10	A	150	13535
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--BIN_LOCATION	A	10	13685
			    	cSTRING += cCAMPO + Space(10-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--DEPOSITO	A	4	13695
			    	cSTRING += cCAMPO + Space(04-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--GRUPO_MERCADORIA	A	20	13699
			    	cSTRING += cCAMPO + Space(20-LEN(cCAMPO))
			    	cCAMPO := "N"								//--INTERNAL_ORDER	A	12	13719
			    	cSTRING += cCAMPO + Space(12-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--PRIORIDADE	A	8	13731
			    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--ID_AGRUPAMENTO	N	8	13739
			    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--NUM_ORDEM_REF_ERP_EXP	A	16	13747
			    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--ITEM_ORDEM_REF_ERP_EXP	A	7	13763
			    	cSTRING += cCAMPO + Space(07-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD11	A	150	13770
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD12	A	150	13920
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD13	A	150	14070
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD14	A	150	14220
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD15	A	150	14370
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD16	A	150	14520
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD17	A	150	14670
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD18	A	150	14820
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD19	A	150	14970
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD20	A	150	15120
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD21	A	150	15270
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD22	A	150	15420
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD23	A	150	15570
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD24	A	150	15720
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD25	A	150	15870
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD26	A	150	16020
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD27	A	150	16170
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD28	A	150	16320
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD29	A	150	16470
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD30	A	150	16620
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD31	A	150	16770
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD32	A	150	16920
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD33	A	150	17070
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD34	A	150	17220
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FLEX_FIELD35	A	150	17370
			    	cSTRING += cCAMPO + Space(150-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--CODIGO_LOCAL_DEPOSITO	N	8	17520
			    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--FATOR_CONVERSAO	N	18	17528
			    	cSTRING += cCAMPO + Space(18-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--CHK_AGENCIAMENTO_COLETA	N	8	17546
			    	cSTRING += cCAMPO + Space(08-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--MARCA_COMERCIAL	A	250	17554
			    	cSTRING += cCAMPO + Space(250-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--NUM_NFS_NAC_DE	N	16	17804
			    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--NUM_ITEM_NFS_NAC_DE	N	16	17820
			    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))
			    	cCAMPO := STRINGNULL						//--ID_ITEM_REF_NAC_DE	N	16	17836
			    	cSTRING += cCAMPO + Space(16-LEN(cCAMPO))	
					fWrtFile(cSTRING, hFILESC7_2)	    	
			    	cPEDIDO := SC7->C7_NUM 
			    	
			    	//--Atualiza FLAG
			    	fUpdESYS("SC7", SC7->(RECNO()) )
			    	
			    	nREGISTRO += 1
			    	(cAliasTMP)->(dbSkip())
			    	
				Enddo
			EndIf    
			
	    Next _nINDEMP		

		If nREGISTRO != 0
			fEndFile(cARQUIVO)
		EndIf

	EndIf
	
	RpcClearEnv()
			    
	CONOUT(TIME()+"-SC7-FIM EXPORTACAO DE PEDIDO DE COMPRAS.")

Return
    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSE2    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SE2.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSE2()               
*---------------------------------------*
Local cSTRING   := STRINGNULL
Local cARQUIVO  := "SE2"
Local nREGISTRO := 0
Local aEMPRESAS := {}
Local aARQUIVOS := {}
Local aARQUIVO1 := {}
Local aARQUIVO2 := {}
Local aTITULOS  := {}
Local nTamLin   := 0
Local nTamFile  := 0
Local nBtLidos  := 0
Local cBuffer   := STRINGNULL                 
Local nINUMTIT  := 1    
Local cICODTIP  := "PR" 
Local cIPRFIMP  := "SYS"
Local cICODNAT  := STRINGNULL            

Private lMsErroAuto := .F.
Private cFILELOG, hFILELOG
   
	CONOUT(TIME()+"-SE2-INICIO IMPORTACAO DE ORDENS DE PAGAMENTO.")
	
	//-- Realiza a leitura dos arquivos a serem importados.
	aDir(CPATHFILES+CFILESE2_1+"*.txt", aARQUIVOS )

	If Len(aARQUIVOS) > 0
	
	    PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "FIN" TABLES "SA2","SED","SE2"
	    
	    cDATAHORA := dtos(Date()) + time() + "-"
	    
	    CONOUT(TIME()+"ARQUIVO: "+aARQUIVOS[1])
	    
	    //-- Adiciona ao array todas as empresas/filiais do grupo
	    dbSelectArea("SM0")
	    nRECSM0 := SM0->(RECNO())
		dbGoTop()
		While !SM0->(EOF())
			aAdd ( aEMPRESAS, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC } )
			SM0->(dbSkip())
		Enddo
		dbGoTo(nRECSM0)
		
		For _nINDARQ := 1 to Len(aARQUIVOS)

	    	cFILELOG := CPATHFILES+"LOG_"+aARQUIVOS[_nINDARQ]
	    	hFILELOG := fCreate(cFILELOG)
	    	
	    	aTITULOS := {}

			If hFILELOG == -1   				
				conout( "ERRO NA CRIACAO DO ARQUIVO: " + cFILELOG )				
			EndIf

			hFILESE2_1 := fOpen(lower(CPATHFILES+aARQUIVOS[_nINDARQ]) , FO_READWRITE,, .F. )


			If hFILESE2_1 == -1   				
				
				cSTRING := cDATAHORA + "ERRO NA ABERTURA DO ARQUIVO: " +CPATHFILES+aARQUIVOS[_nINDARQ]+ "- FERROR: " + str(ferror(),4) + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG,cSTRING,Len(cSTRING))
				
			Else

				cSTRING := cDATAHORA + "INICIO LEITURA DO ARQUIVO: " +CPATHFILES+aARQUIVOS[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG,cSTRING,Len(cSTRING))

				nTamFile := fSeek(hFILESE2_1,0,2)
				fSeek(hFILESE2_1,0,0)
				nTamLin  := 719
				cBuffer  := Space(nTamLin)
				
				nBtLidos := fRead(hFILESE2_1,@cBuffer,nTamLin)
				nCOUNTLN := 0
				
				While nBtLidos >= nTamLin
								    	
			    	nCOUNTLN += 1    		//--Contador de linhas
			
					cSP_ID					:= SubSTR(cBuffer,001,047)		//--SP_ID	N	47	1		
					cSP_EMBARQUE_NUM		:= SubSTR(cBuffer,048,012)		//--SP_EMBARQUE_NUM	A	12	48
					cSP_EMBARQUE_ANO		:= SubSTR(cBuffer,060,004)		//--SP_EMBARQUE_ANO	A	4	60
					cSP_EMPRESA				:= SubSTR(cBuffer,064,020)		//--SP_EMPRESA	A	20	64	
					cSP_AREA_NEGOCIO		:= SubSTR(cBuffer,084,020)		//--SP_AREA_NEGOCIO	A	20	84
					cSP_ORGANIZACAO			:= SubSTR(cBuffer,104,100)		//--SP_ORGANIZACAO	A	100	104
					cSP_DATA_CADASTRO		:= SubSTR(cBuffer,204,014)		//--SP_DATA_CADASTRO	D	19	204
					cSP_DATA_VENCIMENTO		:= SubSTR(cBuffer,218,014)		//--SP_DATA_VENCIMENTO	D	14	223
					cSP_DATA_LIBERACAO		:= SubSTR(cBuffer,232,014)		//--SP_DATA_LIBERACAO	D	14	237
					cSP_CREDOR				:= SubSTR(cBuffer,246,047)		//--SP_COD_CREDOR	N	47	251	
					cSP_COD_MOEDA			:= SubSTR(cBuffer,293,025)		//--SP_COD_MOEDA	A	25	298
					cSP_RAZAO_ESPECIAL		:= SubSTR(cBuffer,318,050)		//--SP_RAZAO_ESPECIAL	A	50	323
					cSP_FORMA_PAGTO			:= SubSTR(cBuffer,368,050)		//--SP_FORMA_PAGTO	A	50	373
					cSP_NUM_DOCUMENTO		:= SubSTR(cBuffer,418,020)		//--SP_NUM_DOCUMENTO	A	20	423
					cSP_SERIE_DOCUMENTO		:= SubSTR(cBuffer,438,006)		//--SP_SERIE_DOCUMENTO	A	6	443
					cSP_TIPO				:= SubSTR(cBuffer,444,002)		//--SP_TIPO	A	2	449
					cSP_STATUS				:= SubSTR(cBuffer,446,004)		//--SP_STATUS	A	4	451
					cSP_CDESPESA			:= SubSTR(cBuffer,450,020)		//--SP_COD_DESPESA	A	20	455
					cSP_COD_DESP			:= SubSTR(cBuffer,470,047)		//--SP_COD_CREDOR_DESPESA	N	47	475
					cSP_VR_PREVISTO_DESP 	:= SubSTR(cBuffer,517,047)		//--SP_VR_PREVISTO_DESPESA	N	47	522
					cSP_VR_ADIANTADO_DESP	:= SubSTR(cBuffer,564,047)		//--SP_VR_ADIANTADO_DESPESA	N	47	569
					cSP_VR_REAL_DESPESA		:= SubSTR(cBuffer,611,047)		//--SP_VR_REAL_DESPESA	N	47	616
					cSP_VR_A_PAGAR_DESP		:= SubSTR(cBuffer,658,047)		//--SP_VR_A_PAGAR_DESPESA	N	47	663
					cSP_COD_PROCESSO		:= SubSTR(cBuffer,705,012)		//--SP_COD_PROCESSO	A	12	710
					
	                cSP_EMPRESA := ALLTRIM(STRTRAN(cSP_EMPRESA,"."," "))
	                If SubSTR(cSP_EMPRESA,1,1) $ "CF"
	                	cSP_EMPRESA := SubSTR(cSP_EMPRESA,2,Len(cSP_EMPRESA))
	                EndIf
	                cSP_CREDOR := ALLTRIM(STRTRAN(cSP_CREDOR,"."," "))
	                If SubSTR(cSP_CREDOR,1,1) $ "CF"
	                	cSP_CREDOR := SubSTR(cSP_CREDOR,2,Len(cSP_CREDOR))
	                EndIf
	                
	                cSP_COD_MOEDA := ALLTRIM(SubSTR(cSP_COD_MOEDA,1,4))
	                If cSP_COD_MOEDA == "REAL"
	                	nMOEDA := 1
	                ElseIf cSP_COD_MOEDA == "USD"
	                	nMOEDA := 2
	                ElseIf cSP_COD_MOEDA == "EUR"
	                	nMOEDA := 4
	                ElseIf cSP_COD_MOEDA == "JPY"
	                	nMOEDA := 5
	                ElseIf cSP_COD_MOEDA == "ARS"	
	                	nMOEDA := 6
	                ElseIf cSP_COD_MOEDA == "CLP"
	                	nMOEDA := 7
	                Else
	                	nMOEDA := 1
	                EndIf 
	                
	                
                	cSTRING := cDATAHORA + "LEITURA LINHA - "+cValToChar(nCOUNTLN) + &(CENDOFFILE)
                	conout(cSTRING)

                	fWrite(hFILELOG,cSTRING,Len(cSTRING))	 
                	
	                dbSelectArea("SA2")
	                dbSetOrder(1)
	                If dbSeek( xFilial("SA2") + cSP_EMPRESA )

	                	cSTRING := cDATAHORA + "FORNECEDOR LOCALIZADO - "+cSP_EMPRESA + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG,cSTRING,Len(cSTRING))			         	

	                
	                	nPOS := aScan ( aEMPRESAS, {|x| x[3] == SA2->A2_CGC } )
	                	
	                	If nPOS != 0

			                dbSelectArea("SA2")
			                dbSetOrder(1)
			                If dbSeek( xFilial("SA2") + cSP_CREDOR )
		
                                /**
                                	Quando tํtulo for adiantamento serใo unificados todos os registros com o mesmo ID
                                	e incluํdo um ๚nico tํtulo, para pagamentos e presta็ใo de contas serแ criado um
                                	tํtulo para cada registro.
                                **/
                                
                                If Len(aTITULOS) == 0 
                                	nPOSTIT := 0
                                ElseIf cSP_TIPO != "01"	//--Adiantamento
                                	nPOSTIT := 0
                                Else
                                	nPOSTIT := aScan( aTITULOS, {|x| x[9] == cSP_ID })
                                EndIf
                                	
				                If nPOSTIT == 0 
				                    
				                	nIValTIT := Val(cSP_VR_A_PAGAR_DESP)
				                	If nIValTIT < 0
				                		nIValTIT := nIValTIT * (-1)
				                	EndIf
				                	
				                	If nIValTIT != 0
					                
						                aAdd ( aTITULOS, {	aEMPRESAS[nPOS,01]+aEMPRESAS[nPOS,02], ;
						                					SubSTR(cSP_CREDOR,1,TAMSX3("A2_COD")[1]), ;
						                					SubSTR(cSP_CREDOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]), ;
						                					stod(cSP_DATA_CADASTRO), ;
						                					stod(cSP_DATA_VENCIMENTO), ;
						                					nIValTIT, ;
						                					nMOEDA, ;
						                					ALLTRIM(cSP_RAZAO_ESPECIAL), ;
						                					cSP_ID, ;
						                					cSP_COD_PROCESSO, ;
						                					cSP_TIPO, ;
						                					cSP_CDESPESA } ) 
						                					
										cSTRING := cDATAHORA + "NOVO TITULO - " + cSP_ID + " - FAVORECIDO - "+SubSTR(cSP_CREDOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cSP_CREDOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cSP_VR_A_PAGAR_DESP)) + &(CENDOFFILE)
				                		conout(cSTRING)
				                		fWrite(hFILELOG,cSTRING,Len(cSTRING))			                					
		
									EndIf
									
								Else
								
							   		aTITULOS[nPOSTIT,06] += Val(cSP_VR_A_PAGAR_DESP) 

									cSTRING := cDATAHORA + "ADICAO DO TITULO - " + cSP_ID + " - FAVORECIDO - "+SubSTR(cSP_CREDOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cSP_CREDOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cSP_VR_A_PAGAR_DESP)) - " - VALOR TOTAL - "+ cValToChar(aTITULOS[nPOSTIT,06]) +  &(CENDOFFILE)
			                		conout(cSTRING)
			                		fWrite(hFILELOG,cSTRING,Len(cSTRING))			                					

							   				
								EndIf
					                					
								cSTRING := cDATAHORA + "EMPRESA/FILIAL - " + aEMPRESAS[nPOS,01]+"/"+aEMPRESAS[nPOS,02] + " - FAVORECIDO - "+SubSTR(cSP_CREDOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cSP_CREDOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cSP_VR_A_PAGAR_DESP)) + &(CENDOFFILE)
		                		conout(cSTRING)
		                		fWrite(hFILELOG,cSTRING,Len(cSTRING))			                					
		      				
		      				Else
								
								cSTRING := cDATAHORA + "FAVORECIDO NAO LOCALIZADO CADASTRO DE FORNECEDOR "+SubSTR(cSP_CREDOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cSP_CREDOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cSP_VR_A_PAGAR_DESP)) + &(CENDOFFILE)
		                		conout(cSTRING)
		                		fWrite(hFILELOG,cSTRING,Len(cSTRING))			                					

		      				
		      				EndIf
				         	
			         	Else

		                	cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA SIGAMAT - "+cSP_EMPRESA + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG,cSTRING,Len(cSTRING))			         	
			         	
			         	Endif
			         
			         Else                                    
			         
	                	cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA COMO FORNECEDOR - "+cSP_EMPRESA + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG,cSTRING,Len(cSTRING))			         
			         
			         EndIf
			                
				    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				    //ณ Leitura da proxima linha do arquivo texto.                          ณ
				    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				    nBtLidos := fRead(hFILESE2_1,@cBuffer,nTamLin) 
				
				    dbSkip()
				EndDo
				
                If Len(aTITULOS) > 0
                                
                	//--Ordena registros por empresa + filial
                	aTITULOS := aSort(aTITULOS,,,{|x,y| x[1]<y[1]})
                	_cODEMPFIL := STRINGNULL
                	
                	For _nIND := 1 to Len(aTITULOS)
                	
                		If _cODEMPFIL != aTITULOS[_nIND,01] 
							
							_cODEMPFIL := aTITULOS[_nIND,01]
							
							RpcClearEnv()
							RPCSetType(3)
	
				     		PREPARE ENVIRONMENT EMPRESA SubSTR(aTITULOS[_nIND,01],1,2) FILIAL SubSTR(aTITULOS[_nIND,01],3,2) MODULO "FIN" TABLES "SA2","SED","SE2"
				     		
		                	cSTRING := cDATAHORA + "INCLUSAO DE TITULOS EMPRESA/FILIAL: " + cEmpAnt + "/" + cFilAnt + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG,cSTRING,Len(cSTRING))
		                	

                		EndIf

						//--Natureza do tํtulo
						If aTITULOS[_nIND,11] == "11" //--Adiantamento
							cICODNAT  := SuperGetMV("MV_X_ICNAT",,"2011009")
						Else                                                							
							cICODNAT  := fGetNAT(ALLTRIM(aTITULOS[_nIND,12]))
						EndIf
						
						//--Define n๚mero e parcela do tํtulo
						cNUMTITIMP := STRZero(Val(aTITULOS[_nIND,10]),TAMSX3("E2_NUM")[1])						
						cPARTITIMP := fGetNextParc(cEmpAnt,cFilAnt,cIPRFIMP,cNUMTITIMP,cICODTIP)

	                	cSTRING := cDATAHORA + "INCLUSAO TITULO: " + cNUMTITIMP + " PARCELA: " +cPARTITIMP+  " - FAVORECIDO: " + aTITULOS[_nIND,02] +"/"+ aTITULOS[_nIND,03] + " - ID IMPORT SYS: " + aTITULOS[_nIND,09] + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG,cSTRING,Len(cSTRING))

						//--Verifica se jแ existe registro na base
						If ! fChkIDISYS(cARQUIVO,cEmpAnt,cFilAnt,aTITULOS[_nIND,09])
						
							lMsErroAuto := .F.                
							aTitulo := {	{"E2_FILIAL"	, cFilAnt				 		   	,	Nil},;      
											{"E2_PREFIXO"	, cIPRFIMP		 				   	,	Nil},;      
							  				{"E2_NUM"		, cNUMTITIMP						,	Nil},;      
											{"E2_PARCELA"	, cPARTITIMP						,	Nil},;      
											{"E2_TIPO"		, cICODTIP				 			,	Nil},;      
											{"E2_NATUREZ"	, cICODNAT						   	,	Nil},;  					
											{"E2_FORNECE"	, aTITULOS[_nIND,02]				,	Nil},;      
											{"E2_LOJA"		, aTITULOS[_nIND,03]				,	Nil},;    
											{"E2_EMISSAO"	, aTITULOS[_nIND,04]			   	,	Nil},;
											{"E2_VENCTO"	, aTITULOS[_nIND,05]			   	,	Nil},;
											{"E2_VENCREA"	, DataValida(aTITULOS[_nIND,05])	,	Nil},;
											{"E2_VALOR"		, aTITULOS[_nIND,06]			   	,	Nil},;                                          
											{"E2_MOEDA"		, aTITULOS[_nIND,07]				,	Nil},;											
											{"E2_HIST"		, aTITULOS[_nIND,08]				,	Nil},;										
											{"E2_X_IDSYS"	, aTITULOS[_nIND,09]				,	Nil},;											
											{"E2_X_PRSYS"	, aTITULOS[_nIND,10]				,	Nil}} 
							
												
					    	aAreaXTMP := GetArea()
					    	dbSelectArea(cARQUIVO)
							MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
							RestArea(aAreaXTMP)
							
							If lMsErroAuto
			                	cSTRING := cDATAHORA + "ERRO INCLUSAO TITULO - " + cNUMTITIMP + " - PARCELA: " +cPARTITIMP + " ID IMPORT SYS: " + aTITULOS[_nIND,09] + " - ERRO: "+MostraErro() + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG,cSTRING,Len(cSTRING))	                           
							Else			                	
			                	cSTRING := cDATAHORA + "OK INCLUSAO TITULO: " + cNUMTITIMP + " - PARCELA: " +cPARTITIMP+ " - ID IMPORT SYS: " + aTITULOS[_nIND,09] + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG,cSTRING,Len(cSTRING))								
							EndIf 
						
						Else

		                	cSTRING := cDATAHORA + "ERRO REGISTRO Jม EXISTENTE NO PROTHEUS - ID IMPORT SYS: " + aTITULOS[_nIND,09] + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG,cSTRING,Len(cSTRING))								
					
						EndIf	
                		
                	Next _nIND
                	                
                EndIf

				cSTRING := cDATAHORA + "FIM LEITURA DO ARQUIVO: " +CPATHFILES+aARQUIVOS[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG,cSTRING,Len(cSTRING))
			
			EndIf
				
	    	//-- Fecha arquivos.	
	    	fClose(hFILESE2_1)
	    	fClose(hFILELOG)
	    	
	    	//-- Renomeia o arquivo processado.
	    	fRename(CPATHFILES+aARQUIVOS[_nINDARQ] , CPATHFILES+"OK_"+aARQUIVOS[_nINDARQ] )
	
    	Next _nINDARQ
	                          
	EndIf 
	
	CONOUT(TIME()+"-SE2-FIM IMPORTACAO DE ORDENS DE PAGAMENTO.")




	CONOUT(TIME()+"-SE2-INICIO IMPORTACAO DE FATURAS/ADIANTAMENTOS.")
	
	//-- Realiza a leitura dos arquivos a serem importados.
	
	aARQUIVO1 := {}
	aARQUIVO2 := {}

	aDir(CPATHFILES+CFILESE2_2+"*.txt", aARQUIVO1 )
	aDir(CPATHFILES+CFILESE2_3+"*.txt", aARQUIVO2 )

	If Len(aARQUIVO1) > 0
	
	    PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "FIN" TABLES "SA2","SED","SE2"
	    
	    cDATAHORA := dtos(Date()) + time() + "-"
	    
	    //-- Adiciona ao array todas as empresas/filiais do grupo
	    dbSelectArea("SM0")
	    nRECSM0 := SM0->(RECNO())
		dbGoTop()
		While !SM0->(EOF())
			aAdd ( aEMPRESAS, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC } )
			SM0->(dbSkip())
		Enddo
		dbGoTo(nRECSM0)
		
		For _nINDARQ := 1 to Len(aARQUIVO1)

	    	cFILELOG1 := lower(CPATHFILES+"LOG_"+aARQUIVO1[_nINDARQ])
	    	hFILELOG1 := fCreate(cFILELOG1)
	    	
	    	aTITULOS := {}

			If hFILELOG1 == -1   				
				conout( "ERRO NA CRIACAO DO ARQUIVO: " + cFILELOG1 )				
			EndIf
			
			If Len(aARQUIVO1) != Len(aARQUIVO2)
				cSTRING := cDATAHORA + "NUMERO DE ARQUIVOS DE CABECALHO DIFERENTE DO NUMERO DE ARQUIVO DE ITENS DE FATURAS."
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
				fClose(hFILELOG1)
				Exit
			EndIf			

			hFILESE2_2 := fOpen(lower(CPATHFILES+aARQUIVO1[_nINDARQ]) , FO_READWRITE,, .F. )
			
			nPOSDET := 0
			For nDET := 1 to Len(aARQUIVO2)
				conout(SubSTR(aARQUIVO2[nDET],11,14),"-",SubSTR(aARQUIVO1[_nINDARQ],6,14))
				If SubSTR(aARQUIVO2[nDET],11,14) == SubSTR(aARQUIVO1[_nINDARQ],6,14)
			  	nPOSDET := nDET
			 	EndIf
			Next nDET
			
			If nPOSDET != 0
				//hFILESE2_3 := fOpen(lower(CPATHFILES+aARQUIVO2[_nINDARQ]) , FO_READWRITE,, .F. )
				hFILESE2_3 := fOpen(lower(CPATHFILES+aARQUIVO2[nPOSDET]) , FO_READWRITE,, .F. )
			Else
				
				cSTRING := cDATAHORA + "ARQUIVO DETFAT NAO LOCALIZADO: " +CPATHFILES+"DETPARFAT_"+SubSTR(aARQUIVO1[_nINDARQ],6,14) + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
        
	    	//-- Fecha arquivos.	
	    	fClose(hFILESE2_2)
	    	fClose(hFILELOG1)
				Loop
				
			EndIf
      

			If hFILESE2_2 == -1   				
				
				cSTRING := cDATAHORA + "ERRO NA ABERTURA DO ARQUIVO: " +CPATHFILES+aARQUIVO1[_nINDARQ]+ "- FERROR: " + str(ferror(),4) + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
				
			Else

				cSTRING := cDATAHORA + "#### INICIO LEITURA DO ARQUIVO - CABECALHO: " +CPATHFILES+aARQUIVO1[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))

				nTamFile := fSeek(hFILESE2_2,0,2)
				fSeek(hFILESE2_2,0,0)
				nTamLin  := 4727
				cBuffer  := Space(nTamLin)
				
				nBtLidos := fRead(hFILESE2_2,@cBuffer,nTamLin)
				nCOUNTLN := 0
				
				While nBtLidos >= nTamLin
								    	
			    	nCOUNTLN += 1    		//--Contador de linhas
			
					cFAT_FAT_ID							:= SubSTR(cBuffer,001,047)		//--FAT_FATURA_ID	N	47	1		
					cFAT_EMPRESA						:= SubSTR(cBuffer,048,041)		//--FAT_EMPRESA	A	41	48
					cFAT_NUM_FATURA						:= SubSTR(cBuffer,089,018)		//--FAT_NUM_FATURA	A	18	89
					cFAT_TIPO_FATURA					:= SubSTR(cBuffer,107,047)		//--FAT_TIPO_FATURA	N	47	107
					cFAT_DT_FT							:= SubSTR(cBuffer,154,014)		//--FAT_DATA_FATURA	D	14	154
					cFAT_EXPORTADOR	   					:= SubSTR(cBuffer,168,041)		//--FAT_COD_EXPORTADOR	A	41	168
					cFAT_EMBARQUE_NUM					:= SubSTR(cBuffer,209,012)		//--FAT_EMBARQUE_NUM	A	12	209
					cFAT_EMBARQUE_ANO					:= SubSTR(cBuffer,221,004)		//--FAT_EMBARQUE_ANO	A	4	221
					cFAT_NUMERO_CONHECIMENT 			:= SubSTR(cBuffer,225,018)		//--FAT_NUMERO_CONHECIMENTO	A	18	225
					cFAT_DT_CNT							:= SubSTR(cBuffer,243,014)		//--FAT_DATA_CONHECIMENTO	D	14	243
					cFAT_NUM_DI							:= SubSTR(cBuffer,257,016)		//--FAT_NUM_DI	A	16	257
					cFAT_TIPO_DI						:= SubSTR(cBuffer,273,001)		//--FAT_TIPO_DI	A	1	273
					cFAT_DRGDI							:= SubSTR(cBuffer,274,014)		//--FAT_DATA_REGISTRO_DI	D	14	274
					cFAT_AREA_NEGOCIO					:= SubSTR(cBuffer,288,020)		//--FAT_AREA_NEGOCIO	A	20	288
					cFAT_COND_PAGTO						:= SubSTR(cBuffer,308,050)		//--FAT_COND_PAGTO	A	50	308
					cFAT_INCOTERM						:= SubSTR(cBuffer,358,010)		//--FAT_INCOTERM	A	10	358
					cFAT_COD_MOEDA						:= SubSTR(cBuffer,368,025)		//--FAT_COD_MOEDA	A	25	368
					cFAT_TAXA_FATURA					:= SubSTR(cBuffer,393,047)		//--FAT_TAXA_FATURA	N	47	393
					cFAT_TAXA_DI						:= SubSTR(cBuffer,440,047)		//--FAT_TAXA_DI	N	47	440
					cFAT_VMCV_TOTAL		 				:= SubSTR(cBuffer,487,047)		//--FAT_VMCV_TOTAL	N	47	487
					cFAT_COD_AGENTE_CARGA				:= SubSTR(cBuffer,534,020)		//--FAT_COD_AGENTE_CARGA	A	20	534
					cFAT_DPRVCH 						:= SubSTR(cBuffer,554,014)		//--FAT_DATA_PREVISAO_CHEGADA	D	14	554
					cFAT_DTCHG							:= SubSTR(cBuffer,568,014)		//--FAT_DATA_CHEGADA	D	14	568
					cFAT_DESMB 							:= SubSTR(cBuffer,582,014)		//--FAT_DATA_DESEMBARACO_DI	D	14	582
					cFAT_COD_EXTERNO_COND_P				:= SubSTR(cBuffer,596,010)		//--FAT_COD_EXTERNO_COND_PAGTO	A	10	596
					cFAT_ORGANIZACAO_AREA_N 			:= SubSTR(cBuffer,606,100)		//--FAT_ORGANIZACAO_AREA_NEGOCIO	A	100	606
					cFAT_COD_PROCESSO					:= SubSTR(cBuffer,706,012)		//--FAT_COD_PROCESSO	A	12	706
					cFAT_FLAG_ASSUNCAO_DIVI 			:= SubSTR(cBuffer,718,001)		//--FAT_FLAG_ASSUNCAO_DIVIDA	A	1	718
					cFAT_COD_UNIDADE_NEGOCI 			:= SubSTR(cBuffer,719,020)		//--FAT_COD_UNIDADE_NEGOCIO	A	20	719
					cFAT_DCRPR 							:= SubSTR(cBuffer,739,014)		//--FAT_DATA_CRIACAO_PROCESSO_SIST	D	14	739
					cFAT_OBS_FATURA						:= SubSTR(cBuffer,753,1500)		//--FAT_OBS_FATURA	A	1500	753
					cFAT_PARCELAS_TOTAL					:= SubSTR(cBuffer,2253,047)		//--FAT_PARCELAS_TOTAL	N	47	2253
					cFAT_COD_ADQUIRENTE					:= SubSTR(cBuffer,2300,041)		//--FAT_COD_ADQUIRENTE	A	41	2300
					cFAT_USERNAME						:= SubSTR(cBuffer,2341,015)		//--FAT_USERNAME	A	4000	2341
					cFAT_DTVEN							:= SubSTR(cBuffer,2356,014) 	//--FAT_DATA_VENCIMENTO	D	14	2356  2356,014 Guilherme
					cFAT_CATEGORIA_MOEDA	  			:= SubSTR(cBuffer,2370,002)		//--FAT_CATEGORIA_MOEDA	A	2	2370
					cFAT_TIPO_IMPORTACAO	 			:= SubSTR(cBuffer,2372,002)		//--FAT_TIPO_IMPORTACAO	A	2	2372
					cFAT_PRVSA 							:= SubSTR(cBuffer,2374,014)		//--FAT_DATA_PREVISAO_SAIDA	D	14	2374
					cFAT_TIPO_CONHEC_PROCES 			:= SubSTR(cBuffer,2388,015)		//--FAT_TIPO_CONHEC_PROCESSO	A	15	2388
					cFAT_FATURA_SERVICO	   				:= SubSTR(cBuffer,2403,001)		//--FAT_FATURA_SERVICO	A	1	2403
					cFAT_FLAG_BACK_TO_BACK 				:= SubSTR(cBuffer,2404,001)		//--FAT_FLAG_BACK_TO_BACK	A	1	2404

					
	                cFAT_EMPRESA := ALLTRIM(STRTRAN(cFAT_EMPRESA,"."," "))
	                If SubSTR(cFAT_EMPRESA,1,1) $ "CF"
	                	cFAT_EMPRESA := SubSTR(cFAT_EMPRESA,2,Len(cFAT_EMPRESA))
	                EndIf
	                cFAT_EXPORTADOR := ALLTRIM(STRTRAN(cFAT_EXPORTADOR,"."," "))
	                If SubSTR(cFAT_EXPORTADOR,1,1) $ "CF"
	                	cFAT_EXPORTADOR := SubSTR(cFAT_EXPORTADOR,2,Len(cFAT_EXPORTADOR))
	                EndIf
	                
	                cFAT_COD_MOEDA := ALLTRIM(SubSTR(cFAT_COD_MOEDA,1,4))
	                If cFAT_COD_MOEDA == "REAL"
	                	nMOEDA := 1
	                ElseIf cFAT_COD_MOEDA == "USD"
	                	nMOEDA := 2
	                ElseIf cFAT_COD_MOEDA == "EUR"
	                	nMOEDA := 4
	                ElseIf cFAT_COD_MOEDA == "JPY"
	                	nMOEDA := 5
	                ElseIf cFAT_COD_MOEDA == "ARS"	
	                	nMOEDA := 6
	                ElseIf cFAT_COD_MOEDA == "CLP"
	                	nMOEDA := 7
	                Else
	                	nMOEDA := 1
	                EndIf 
	                
	                
                	cSTRING := cDATAHORA + "LEITURA LINHA - "+cValToChar(nCOUNTLN) + &(CENDOFFILE)
                	conout(cSTRING)

                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))	 
                	
	                dbSelectArea("SA2")
	                dbSetOrder(1)
	                If dbSeek( xFilial("SA2") + cFAT_EMPRESA )

	                	cSTRING := cDATAHORA + "FORNECEDOR LOCALIZADO - "+cFAT_EMPRESA + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))			         	

	                
	                	nPOS := aScan ( aEMPRESAS, {|x| x[3] == SA2->A2_CGC } )
	                	
	                	If nPOS != 0

			                dbSelectArea("SA2")
			                dbSetOrder(1)
			                If dbSeek( xFilial("SA2") + cFAT_EXPORTADOR )
		
                                If Len(aTITULOS) == 0 
                                	nPOSTIT := 0
                                Else
                                	nPOSTIT := aScan( aTITULOS, {|x| x[9] == cFAT_FAT_ID })
                                EndIf
                                	
				                If nPOSTIT == 0 
				                    
				                	nIValTIT := Val(cFAT_PARCELAS_TOTAL)
				                	If nIValTIT < 0
				                		nIValTIT := nIValTIT * (-1)
				                	EndIf
				                	
				                	If nIValTIT != 0
					                
						                aAdd ( aTITULOS, {	aEMPRESAS[nPOS,01]+aEMPRESAS[nPOS,02], ;
						                					SubSTR(cFAT_EXPORTADOR,1,TAMSX3("A2_COD")[1]), ;
						                					SubSTR(cFAT_EXPORTADOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]), ;
						                					stod(cFAT_DT_FT), ;
						                					stod(cFAT_DTVEN), ;
						                					nIValTIT, ;
						                					nMOEDA, ;
						                					ALLTRIM(cFAT_OBS_FATURA), ;
						                					cFAT_FAT_ID, ;
						                					cFAT_COD_PROCESSO, ;
						                					{}	 } ) 
						                					
										cSTRING := cDATAHORA + "NOVO TITULO - " + cFAT_FAT_ID + " - FAVORECIDO - "+SubSTR(cFAT_EXPORTADOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cFAT_EXPORTADOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(nIValTIT) + &(CENDOFFILE)
				                		conout(cSTRING)
				                		fWrite(hFILELOG1,cSTRING,Len(cSTRING))			                					
		
									EndIf
									
								Else
								
							   		aTITULOS[nPOSTIT,06] += Val(cFAT_PARCELAS_TOTAL) 

									cSTRING := cDATAHORA + "ADICAO DO TITULO - " + cFAT_FAT_ID + " - FAVORECIDO - "+SubSTR(cFAT_EXPORTADOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cFAT_EXPORTADOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cFAT_PARCELAS_TOTAL)) - " - VALOR TOTAL - "+ cValToChar(aTITULOS[nPOSTIT,06]) +  &(CENDOFFILE)
			                		conout(cSTRING)
			                		fWrite(hFILELOG1,cSTRING,Len(cSTRING))			                					

							   				
								EndIf
					                					
								cSTRING := cDATAHORA + "EMPRESA/FILIAL - " + aEMPRESAS[nPOS,01]+"/"+aEMPRESAS[nPOS,02] + " - FAVORECIDO - "+SubSTR(cFAT_EXPORTADOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cFAT_EXPORTADOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cFAT_PARCELAS_TOTAL)) + &(CENDOFFILE)
		                		conout(cSTRING)
		                		fWrite(hFILELOG1,cSTRING,Len(cSTRING))			                					
		      				
		      				Else
								
								cSTRING := cDATAHORA + "FAVORECIDO NAO LOCALIZADO CADASTRO DE FORNECEDOR "+SubSTR(cFAT_EXPORTADOR,1,TAMSX3("A2_COD")[1]) + "/" + SubSTR(cFAT_EXPORTADOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]) + " VALOR - "+ cValToChar(Val(cFAT_PARCELAS_TOTAL)) + &(CENDOFFILE)
		                		conout(cSTRING)
		                		fWrite(hFILELOG1,cSTRING,Len(cSTRING))			                					

		      				
		      				EndIf
				         	
			         	Else

		                	cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA SIGAMAT - "+cFAT_EMPRESA + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))			         	
			         	
			         	Endif
			         
			         Else                                    
			         
	                	cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA COMO FORNECEDOR - "+cFAT_EMPRESA + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))			         
			         
			         EndIf
			                
				    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				    //ณ Leitura da proxima linha do arquivo texto.                          ณ
				    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				    nBtLidos := fRead(hFILESE2_2,@cBuffer,nTamLin) 
				
				    dbSkip()
				EndDo
				
                If Len(aTITULOS) > 0
                
					cSTRING := cDATAHORA + "INICIO LEITURA DO ARQUIVO - ITENS: " +CPATHFILES+aARQUIVO2[nPOSDET] + &(CENDOFFILE)
					conout(cSTRING)
					fWrite(hFILELOG1,cSTRING,Len(cSTRING))
	
					nTamFile2 := fSeek(hFILESE2_3,0,2)
					fSeek(hFILESE2_3,0,0)
					nTamLin2  := 4727
					cBuffer2  := Space(nTamLin2)
					
					nBtLidos2 := fRead(hFILESE2_3,@cBuffer2,nTamLin2)
					nCOUNTLN := 0
					
					While nBtLidos2 >= nTamLin2
									    	
				    	nCOUNTLN += 1    		//--Contador de linhas

						cSTRING := cDATAHORA + "LEITURA DA LINHA: " + cValToChar(nCOUNTLN) +  &(CENDOFFILE)
						conout(cSTRING)
						fWrite(hFILELOG1,cSTRING,Len(cSTRING))


						cPFT_FAT_ID						:= SubSTR(cBuffer2,001,047)	//--PARCELA_FATURA_ID 	  			N	47	1
						
						//-- Verifica se existe cabe็alho para o item
						nPOS := aScan( aTITULOS, {|x| x[9] == cPFT_FAT_ID })
						
						If nPOS == 0
						
							cSTRING := cDATAHORA + "NAO LOCALIZADO CABECALHO PARA O ITEM: PARCELA_FATURA_ID: " + ALLTRIM(cPFT_FAT_ID) +  &(CENDOFFILE)
							conout(cSTRING)
							fWrite(hFILELOG1,cSTRING,Len(cSTRING))

							nBtLidos2 := fRead(hFILESE2_3,@cBuffer2,nTamLin2)
							dbSkip()
							Loop
								
						EndIf							
						
						cPFT_CODPARCELA					:= SubSTR(cBuffer2,048,047)	//--PARCELA_COD_PARCELA	   			N	47	48
						cPFT_ID_TIPO_PAGTO				:= SubSTR(cBuffer2,095,047)	//--PARCELA_ID_TIPO_PAGTO			N	47	95
						cPFT_ID_DATA_BASE				:= SubSTR(cBuffer2,142,047)	//--PARCELA_ID_DATA_BASE			N	47	142
						cPFT_NUM_DIAS					:= SubSTR(cBuffer2,189,047)	//--PARCELA_NUM_DIAS	  			N	47	189
						cPFT_PERCENTUAL					:= SubSTR(cBuffer2,236,047)	//--PARCELA_PERCENTUAL	   			N	47	236/8
						cPFT_VALOR_PARCELA				:= SubSTR(cBuffer2,283,047)	//--PARCELA_VALOR_PARCELA			N	47	283/8
						cPFT_D_VENCIMENTO				:= SubSTR(cBuffer2,330,014)	//--PARCELA_DATA_VENCIMENTO			D	14	330
						cPFT_COD_EXTERNO				:= SubSTR(cBuffer2,344,100)	//--PARCELA_COD_EXTERNO	   			A	100	344
						cPFT_ID_ROF						:= SubSTR(cBuffer2,444,047)	//--PARCELA_ID_ROF					N	47	444
						cPFT_COD_FRM_COBR				:= SubSTR(cBuffer2,491,002)	//--PARCELA_COD_FRM_COBR	 		A	2	491
						cPFT_VLR_COMISSAO				:= SubSTR(cBuffer2,193,047)	//--PARCELA_VLR_COMISSAO_PARCELA	N	47	493
						cPFT_ID_FINANCIAMENTO			:= SubSTR(cBuffer2,540,047)	//--PARCELA_ID_FINANCIAMENTO 		N	47	540
						cPFT_NUM_CONTRATO				:= SubSTR(cBuffer2,587,010)	//--PARCELA_NUM_CONTRATO	 		A	10	587
						cPFT_BANCO						:= SubSTR(cBuffer2,597,005)	//--PARCELA_ BANCO			 		A	5	597
						cPFT_PRACA						:= SubSTR(cBuffer2,602,004)	//--PARCELA_PRACA		  	  		A	4	602
						cPFT_OBSERVACAO					:= SubSTR(cBuffer2,606,200)	//--PARCELA_OBSERVACAO	  	  		A	200	606
						cPFT_IDC_PARC_CONT				:= SubSTR(cBuffer2,806,001)	//--PARCELA_IDC_PARC_CONTABILIZADA	A	1	806
						cPFT_RAZAO_ESPECIAL				:= SubSTR(cBuffer2,807,002)	//--PARCELA_RAZAO_ESPECIAL	  		A	2	807
						cPFT_ID_CONTRATO				:= SubSTR(cBuffer2,809,047)	//--PARCELA_ID_CONTRATO	   	   		N	47	809
						cPFT_COD_PARCELA_ORIG			:= SubSTR(cBuffer2,856,047)	//--PARCELA_COD_PARCELA_ORIGINAL	N	47	856
						
		                aAdd ( aTITULOS[nPOS][11], {	SubSTR(cPFT_FAT_ID,21,27)+SubSTR(cPFT_CODPARCELA,28,20), ;
		                								Val(cPFT_VALOR_PARCELA), 	;
					                					stod(cPFT_D_VENCIMENTO), 	;
					                					ALLTRIM(cPFT_OBSERVACAO)	} ) 
		                					
						cSTRING := cDATAHORA + "FATURA - " + ALLTRIM(cFAT_FAT_ID) + " - PARCELA - " + ALLTRIM(cPFT_CODPARCELA) + " VALOR - "+ cPFT_VALOR_PARCELA + &(CENDOFFILE)
                		conout(cSTRING)
                		fWrite(hFILELOG1,cSTRING,Len(cSTRING))			                					

					    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					    //ณ Leitura da proxima linha do arquivo texto.                          ณ
					    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					
					    nBtLidos2 := fRead(hFILESE2_3,@cBuffer2,nTamLin2)
					
					    dbSkip()
					EndDo


                	//--Ordena registros por empresa + filial
                	aTITULOS := aSort(aTITULOS,,,{|x,y| x[1]<y[1]})
                	_cODEMPFIL := STRINGNULL
                	
                	For _nIND := 1 to Len(aTITULOS)
                	
                		If _cODEMPFIL != aTITULOS[_nIND,01] 
							
							_cODEMPFIL := aTITULOS[_nIND,01]
							
							RpcClearEnv()
							RPCSetType(3)
	
				     		PREPARE ENVIRONMENT EMPRESA SubSTR(aTITULOS[_nIND,01],1,2) FILIAL SubSTR(aTITULOS[_nIND,01],3,2) MODULO "FIN" TABLES "SA2","SED","SE2"
				     		
		                	cSTRING := cDATAHORA + "INCLUSAO DE TITULOS FATURAS EMPRESA/FILIAL: " + cEmpAnt + "/" + cFilAnt + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
		                	

                		EndIf
                        
						
						If Len(aTITULOS[_nIND][11]) > 0
						
							For _nITEM := 1 to Len(aTITULOS[_nIND][11])

								//--Natureza do tํtulo
								cICODNAT  := SuperGetMV("MV_X_ICNAT",,"2011009")
								
								//--Define n๚mero e parcela do tํtulo
								cNUMTITIMP := STRZero(Val(aTITULOS[_nIND,10]),TAMSX3("E2_NUM")[1])						
								cPARTITIMP := fGetNextParc(cEmpAnt,cFilAnt,cIPRFIMP,cNUMTITIMP,cICODTIP)
		
			                	cSTRING := cDATAHORA + "INCLUSAO TITULO: " + cNUMTITIMP + " PARCELA: " +cPARTITIMP+  " - FAVORECIDO: " + aTITULOS[_nIND,02] +"/"+ aTITULOS[_nIND,03] + " - ID IMPORT SYS: " + aTITULOS[_nIND,09] + " - ID PROTHEUS: " + aTITULOS[_nIND,11][_nITEM,01] + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
		
								//--Verifica se jแ existe registro na base
								If ! fChkIDISYS(cARQUIVO,cEmpAnt,cFilAnt,aTITULOS[_nIND,11][_nITEM,01])
								
									lMsErroAuto := .F.                
									aTitulo := {	{"E2_FILIAL"	, cFilAnt				 				   	,	Nil},;      
													{"E2_PREFIXO"	, cIPRFIMP		 						   	,	Nil},;      
									  		  		{"E2_NUM"		, cNUMTITIMP								,	Nil},;      
													{"E2_PARCELA"	, cPARTITIMP								,	Nil},;      
													{"E2_TIPO"		, cICODTIP				 	  				,	Nil},;      
													{"E2_NATUREZ"	, cICODNAT					  			   	,	Nil},;  					
													{"E2_FORNECE"	, aTITULOS[_nIND,02]		   				,	Nil},;      
													{"E2_LOJA"		, aTITULOS[_nIND,03]		   				,	Nil},;    
													{"E2_EMISSAO"	, aTITULOS[_nIND,04]					   	,	Nil},;
													{"E2_VENCTO"	, aTITULOS[_nIND,11][_nITEM,03]			   	,	Nil},;
													{"E2_VENCREA"	, DataValida(aTITULOS[_nIND,11][_nITEM,03])	,	Nil},;
													{"E2_VALOR"		, aTITULOS[_nIND,11][_nITEM,02] 		   	,	Nil},;                                          
													{"E2_MOEDA"		, aTITULOS[_nIND,07]		 				,	Nil},;											
													{"E2_HIST"		, aTITULOS[_nIND,11][_nITEM,04]				,	Nil},;										
													{"E2_X_IDSYS"	, aTITULOS[_nIND,11][_nITEM,01]				,	Nil},;											
													{"E2_X_PRSYS"	, aTITULOS[_nIND,10]		 				,	Nil}}
									
														
							    	aAreaXTMP := GetArea()
							    	dbSelectArea(cARQUIVO)
									MSExecAuto({|x,y| FINA050(x,y)}, aTitulo, 3)
									RestArea(aAreaXTMP)
									
									If lMsErroAuto
					                	cSTRING := cDATAHORA + "ERRO INCLUSAO TITULO - " + cNUMTITIMP + " - PARCELA: " +cPARTITIMP + " ID IMPORT SYS: " + aTITULOS[_nIND,09] +  " - ID PROTHEUS: " + aTITULOS[_nIND,11][_nITEM,01] + " - ERRO: "+MostraErro() + &(CENDOFFILE)
					                	conout(cSTRING)
					                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))	                           
									Else			                	
					                	cSTRING := cDATAHORA + "OK INCLUSAO TITULO: " + cNUMTITIMP + " - PARCELA: " +cPARTITIMP+ " - ID IMPORT SYS: " + aTITULOS[_nIND,09] + " - ID PROTHEUS: " + aTITULOS[_nIND,11][_nITEM,01] + &(CENDOFFILE)
					                	conout(cSTRING)
					                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
									EndIf 
								
								Else
		
				                	cSTRING := cDATAHORA + "ERRO REGISTRO Jม EXISTENTE NO PROTHEUS - ID IMPORT SYS: " + aTITULOS[_nIND,09] + " - ID PROTHEUS: " + aTITULOS[_nIND,11][_nITEM,01]+ &(CENDOFFILE)
				                	conout(cSTRING)
				                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
							
								EndIf	
		                
		                	Next _nITEM
		                	
		                Else

		                	cSTRING := cDATAHORA + "NAO EXISTEM PARCELAS PARA ESTA FATURA - ID IMPORT SYS: " + aTITULOS[_nIND,09]+ &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
                
		                EndIf		
                	Next _nIND
                	                
                EndIf

				cSTRING := cDATAHORA + "FIM LEITURA DO ARQUIVO: " +CPATHFILES+aARQUIVO1[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
			
			EndIf
				
	    	//-- Fecha arquivos.	
	    	fClose(hFILESE2_2)
	    	fClose(hFILESE2_3)	    	
	    	fClose(hFILELOG1)

	    	//-- Renomeia os arquivos processados.
	    	fRename(CPATHFILES+aARQUIVO1[_nINDARQ] , CPATHFILES+"OK_"+aARQUIVO1[_nINDARQ] )
	    	fRename(CPATHFILES+aARQUIVO2[nPOSDET]  , CPATHFILES+"OK_"+aARQUIVO2[_nINDARQ] )
	
    	Next _nINDARQ
	                          
	EndIf 
	
	CONOUT(TIME()+"-SE2-FIM IMPORTACAO DE ADIANTAMENTOS.")


Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfProcSF1    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณProcessamento arquivo SF1.                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fProcSF1()               
*---------------------------------------*
Local cSTRING   := STRINGNULL
Local cARQUIVO  := "SF1"
Local nREGISTRO := 0
Local aEMPRESAS := {}
Local aARQUIVO1 := {}
Local aARQUIVO2 := {}
Local aDADOSDOC := {}
Local nTamLin   := 0
Local nTamFile  := 0
Local nBtLidos  := 0
Local cBuffer   := STRINGNULL                 

Private lMsErroAuto := .F.
Private cFILELOG1, hFILELOG1
Private cFILELOG2, hFILELOG2

	CONOUT(TIME()+"-SF1-INICIO IMPORTACAO DE PRE-NOTAS.")
	
	//-- Realiza a leitura dos arquivos a serem importados.
	aDir(CPATHFILES+CFILESF1_1+"*.txt", aARQUIVO1 )
	aDir(CPATHFILES+CFILESF1_2+"*.txt", aARQUIVO2 )  
	

	If Len(aARQUIVO1) > 0 
	
	    PREPARE ENVIRONMENT EMPRESA "40" FILIAL "01" MODULO "FIN" TABLES "SA2","SED","SE2","SB1"
	    
	    cDATAHORA := dtos(Date()) + time() + "-"	
	
	    //-- Adiciona ao array todas as empresas/filiais do grupo
	    dbSelectArea("SM0")
	    nRECSM0 := SM0->(RECNO())
		dbGoTop()
		While !SM0->(EOF())
			aAdd ( aEMPRESAS, { SM0->M0_CODIGO, SM0->M0_CODFIL, SM0->M0_CGC } )
			SM0->(dbSkip())
		Enddo
		dbGoTo(nRECSM0)
		
		For _nINDARQ := 1 to Len(aARQUIVO1)

	    	cFILELOG1 := CPATHFILES+"LOG_"+aARQUIVO1[_nINDARQ]
	    	hFILELOG1 := fCreate(cFILELOG1)
	    	
	    	aDADOSDOC := {}

			If hFILELOG1 == -1   				
				conout( "ERRO NA CRIACAO DO ARQUIVO: " + cFILELOG1 )				
			EndIf
            
			If Len(aARQUIVO1) != Len(aARQUIVO2)
				cSTRING := cDATAHORA + "NUMERO DE ARQUIVOS DE CABECALHO DIFERENTE DO NUMERO DE ARQUIVO DE ITENS DE NOTA FISCAL."
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
				fClose(hFILELOG1)
				Exit
			EndIf

			hFILESF1_1 := fOpen(lower(CPATHFILES+aARQUIVO1[_nINDARQ]) , FO_READWRITE,, .F. )
			hFILESF1_2 := fOpen(lower(CPATHFILES+aARQUIVO2[_nINDARQ]) , FO_READWRITE,, .F. )

			If hFILESF1_1 == -1   				
				
				cSTRING := cDATAHORA + "ERRO NA ABERTURA DO ARQUIVO: " +CPATHFILES+aARQUIVO1[_nINDARQ]+ " - FERROR " + str(ferror(),4) + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))
				
			Else

				cSTRING := cDATAHORA + "INICIO LEITURA DO ARQUIVO - CABECALHO: " +CPATHFILES+aARQUIVO1[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))

				nTamFile := fSeek(hFILESF1_1,0,2)
				fSeek(hFILESF1_1,0,0)
				nTamLin  := 10324 + Len(&(CENDOFFILE))
				cBuffer  := Space(nTamLin)
								
				nBtLidos := fRead(hFILESF1_1,@cBuffer,nTamLin)				
				nCOUNTLN := 0  
				
				CONOUT("nTamLin="+CVALTOCHAR(nTamLin))
				CONOUT("nBtLidos="+CVALTOCHAR(nBtLidos))
				
				While nBtLidos >= nTamLin
				
			    	If chr(13) $ cBuffer
			    		cBuffer := STRTRAN(cBuffer,chr(13),"")
			    	EndIf    
			    	
			    	nCOUNTLN += 1    		//--Contador de linhas
			    			    					
					cNF_ID						:= SubSTR(cBuffer,001,047)		//--NF_ID	N	47	1
					cNF_EMPRESA					:= SubSTR(cBuffer,048,020)		//--NF_EMPRESA	A	20	48
					cNF_NUMNF					:= SubSTR(cBuffer,068,020)		//--NF_NUMNF	A	20	68
					cNF_SERIE	  				:= SubSTR(cBuffer,088,005)		//--NF_SERIE	A	5	88
					cNF_DTEMIS	   				:= SubSTR(cBuffer,093,014)		//--NF_DTEMIS	D	14	93
					cNF_CLIFOR	  				:= SubSTR(cBuffer,107,020)		//--NF_CLIFOR	A	20	107
					cNF_NATOPE	 				:= SubSTR(cBuffer,127,005)		//--NF_NATOPE	A	5	127
					cNF_NATOPE_DESCRICAO		:= SubSTR(cBuffer,132,120)		//--NF_NATOPE_DESCRICAO	A	120	132
					cNF_FLIMPR	   				:= SubSTR(cBuffer,252,001)		//--NF_FLIMPR	A	1	252
					cNF_CDTRAN	   				:= SubSTR(cBuffer,253,020)		//--NF_CDTRAN	A	20	253
					cNF_ESTADO	  				:= SubSTR(cBuffer,273,030)		//--NF_ESTADO	A	30	273
					cNF_VRTOTAL	  				:= SubSTR(cBuffer,303,047)		//--NF_VRTOTAL	N	47	303
					cNF_VRMERCA	   				:= SubSTR(cBuffer,350,047)		//--NF_VRMERCA	N	47	350
					cNF_VRICMS	  				:= SubSTR(cBuffer,397,047)		//--NF_VRICMS	N	47	397
					cNF_VRIPI	  				:= SubSTR(cBuffer,444,047)		//--NF_VRIPI	N	47	444
					cNF_VRFRETE	 				:= SubSTR(cBuffer,491,047)		//--NF_VRFRETE	N	47	491
					cNF_VRSEGURO	   			:= SubSTR(cBuffer,538,047)		//--NF_VRSEGURO	N	47	538
					cNF_VRDESPESA	  			:= SubSTR(cBuffer,585,047)		//--NF_VRDESPESA	N	47	585
					cNF_BASEICMS	  			:= SubSTR(cBuffer,632,047)		//--NF_BASEICMS	N	47	632
					cNF_DESPESAS_BASEICMS		:= SubSTR(cBuffer,679,047)		//--NF_DESPESAS_BASEICMS	N	47	679
					cNF_OUTRAICMS	  			:= SubSTR(cBuffer,726,047)		//--NF_OUTRAICMS	N	47	726
					cNF_ISENTAICMS	 			:= SubSTR(cBuffer,773,047)		//--NF_ISENTAICMS	N	47	773
					cNF_BASEIPI	   				:= SubSTR(cBuffer,820,047)		//--NF_BASEIPI	N	47	820
					cNF_OUTRAIPI   				:= SubSTR(cBuffer,867,047)		//--NF_OUTRAIPI	N	47	867
					cNF_ISENTAIPI  				:= SubSTR(cBuffer,914,047)		//--NF_ISENTAIPI	N	47	914
					cNF_PESOLI	  				:= SubSTR(cBuffer,961,047)		//--NF_PESOLI	N	47	961
					cNF_PESOBR	 				:= SubSTR(cBuffer,1008,047)		//--NF_PESOBR	N	47	1008
					cNF_VIATRA	 				:= SubSTR(cBuffer,1055,001)		//--NF_VIATRA	A	1	1055
					cNF_MEIOTRA	 				:= SubSTR(cBuffer,1056,036)		//--NF_MEIOTRA	A	36	1056
					cNF_TPNOTA	  				:= SubSTR(cBuffer,1092,002)		//--NF_TPNOTA	A	2	1092
					cNF_EMB_QTDE				:= SubSTR(cBuffer,1094,047)		//--NF_EMB_QTDE	N	47	1094
					cNF_FRETE_ED				:= SubSTR(cBuffer,1141,001)		//--NF_FRETE_ED	A	1	1141
					cNF_FOB_MO	   				:= SubSTR(cBuffer,1142,047)		//--NF_FOB_MO	N	47	1142
					cNF_FRETE_MO	  			:= SubSTR(cBuffer,1189,047)		//--NF_FRETE_MO	N	47	1189
					cNF_SEGURO_MO	  			:= SubSTR(cBuffer,1236,047)		//--NF_SEGURO_MO	N	47	1236
					cNF_ACRESCIMOS	  			:= SubSTR(cBuffer,1283,047)		//--NF_ACRESCIMOS	N	47	1283
					cNF_DEDUCOES	   			:= SubSTR(cBuffer,1330,047)		//--NF_DEDUCOES	N	47	1330
					cNF_BASE_II	  				:= SubSTR(cBuffer,1377,047)		//--NF_BASE_II	N	47	1377
					cNF_II	  					:= SubSTR(cBuffer,1424,047)		//--NF_II	N	47	1424
					cNF_NUM_DI     				:= SubSTR(cBuffer,1471,013)		//--NF_NUMERO_DI	A	13	1471
					cNF_TIPO_DI	   				:= SubSTR(cBuffer,1484,001)		//--NF_TIPO_DI	A	1	1484
					cNF_TAXA_DI	  				:= SubSTR(cBuffer,1485,047)		//--NF_TAXA_DI	N	47	1485
					cNF_DATA_REGISTRO_DI		:= SubSTR(cBuffer,1532,014)		//--NF_DATA_REGISTRO_DI	D	14	1532
					cNF_DATA_DESEMBARACO		:= SubSTR(cBuffer,1546,014)		//--NF_DATA_DESEMBARACO	D	14	1546
					cNF_DI_COD_URF_ENTRADA		:= SubSTR(cBuffer,1560,007)		//--NF_DI_COD_URF_ENTRADA	A	7	1560
					cNF_DI_COD_URF_DESPACHO		:= SubSTR(cBuffer,1567,007)		//--NF_DI_COD_URF_DESPACHO	A	7	1567
					cNF_EMBARQUE	   			:= SubSTR(cBuffer,1574,015)		//--NF_EMBARQUE	A	15	1574
					cNF_EMBARQUE_ANO	 		:= SubSTR(cBuffer,1589,004)		//--NF_EMBARQUE_ANO	A	4	1589
					cNF_REF_EMBARQUE_CLIENTE	:= SubSTR(cBuffer,1593,020)		//--NF_REF_EMBARQUE_CLIENTE	A	20	1593
					cNF_REF_EMBARQUE_DESPACHANTE:= SubSTR(cBuffer,1613,020)		//--NF_REF_EMBARQUE_DESPACHANTE	A	20	1613
					cNF_EMBARQUE_AREA_NEGOCIO	:= SubSTR(cBuffer,1633,020)		//--NF_EMBARQUE_AREA_NEGOCIO	A	20	1633
					cNF_MOEDA	   				:= SubSTR(cBuffer,1653,025)		//--NF_MOEDA	A	25	1653
					cNF_DTEXTRAC	  			:= SubSTR(cBuffer,1678,014)		//--NF_DTEXTRAC	D	14	1678
					cNF_BASEPIS					:= SubSTR(cBuffer,1692,047)		//--NF_BASEPIS	N	47	1692
					cNF_VRT_PIS	   				:= SubSTR(cBuffer,1739,047)		//--NF_VRT_PIS	N	47	1739
					cNF_BASECOFINS	   			:= SubSTR(cBuffer,1786,047)		//--NF_BASECOFINS	N	47	1786
					cNF_VRT_COFINS	  			:= SubSTR(cBuffer,1833,047)		//--NF_VRT_COFINS	N	47	1833
					cNF_TIPO_DEC_SISCOMEX		:= SubSTR(cBuffer,1880,002)		//--NF_TIPO_DEC_SISCOMEX	A	2	1880
					cNF_STATUS	 				:= SubSTR(cBuffer,1882,040)		//--NF_STATUS	A	40	1882
					cNF_CF_NOME      			:= SubSTR(cBuffer,1922,120)		//--NF_CLIFOR_NOME	A	120	1922
					cNF_OBSERVACAO	  			:= SubSTR(cBuffer,2042,4000)	//--NF_OBSERVACAO	A	4000	2042
					cNF_COD_PROCESSO			:= SubSTR(cBuffer,6042,012)		//--NF_COD_PROCESSO	A	12	6042
					cNF_COD_UNIDADE_NEGOCIO		:= SubSTR(cBuffer,6054,020)		//--NF_COD_UNIDADE_NEGOCIO	A	20	6054
					cNF_DATA_CRIACAO_PROCESSO_SI:= SubSTR(cBuffer,6074,014)		//--NF_DATA_CRIACAO_PROCESSO_SIS	D	14	6074
					cNF_ESPECIE_VOLUME	  		:= SubSTR(cBuffer,6088,120)		//--NF_ESPECIE_VOLUME	A	120	6088
					cNF_MARCA_VOLUME	  		:= SubSTR(cBuffer,6208,020)		//--NF_MARCA_VOLUME	A	20	6208
					cNF_NUMERO_VOLUME	 		:= SubSTR(cBuffer,6228,020)		//--NF_NUMERO_VOLUME	A	20	6228
					cNF_INCOTERM	   			:= SubSTR(cBuffer,6248,003)		//--NF_INCOTERM	A	3	6248
					cNF_ID_NFE	   				:= SubSTR(cBuffer,6251,047)		//--NF_ID_NFE	N	47	6251
					cNF_NUM_cNF_NFE	   			:= SubSTR(cBuffer,6298,020)		//--NF_NUM_NF_NFE	A	20	6298
					cNF_NUM_CONHECIMENTO		:= SubSTR(cBuffer,6318,018)		//--NF_NUM_CONHECIMENTO	A	18	6318
					cNF_TAXA_FRETE	   			:= SubSTR(cBuffer,6336,047)		//--NF_TAXA_FRETE	N	47	6336
					cNF_TAXA_SEGURO	   			:= SubSTR(cBuffer,6383,047)		//--NF_TAXA_SEGURO	N	47	6383
					cNF_TAXA_FOB				:= SubSTR(cBuffer,6430,047)		//--NF_TAXA_FOB	N	47	6430
					cNF_DATA_CONHECIMENTO		:= SubSTR(cBuffer,6477,014)		//--NF_DATA_CONHECIMENTO	D	14	6477
					cNF_MOEDA_SEGURO	 		:= SubSTR(cBuffer,6491,025)		//--NF_MOEDA_SEGURO	A	25	6491
					cNF_MOEDA_FRETE	  			:= SubSTR(cBuffer,6516,025)		//--NF_MOEDA_FRETE	A	25	6516
					cNF_DATA_ENTRADA_SAIDA		:= SubSTR(cBuffer,6541,014)		//--NF_DATA_ENTRADA_SAIDA	D	14	6541
					cNF_BASEICMS_OUTRAS	 		:= SubSTR(cBuffer,6555,047)		//--NF_BASEICMS_OUTRAS	N	47	6555
					cNF_BASEICMS_ISENTA	  		:= SubSTR(cBuffer,6602,047)		//--NF_BASEICMS_ISENTA	N	47	6602
					cNF_BASEIPI_OUTRAS	  		:= SubSTR(cBuffer,6649,047)		//--NF_BASEIPI_OUTRAS	N	47	6649
					cNF_BASEIPI_ISENTA	  		:= SubSTR(cBuffer,6696,047)		//--NF_BASEIPI_ISENTA	N	47	6696
					cNF_DI_LOCAL_URF_DESPACHO	:= SubSTR(cBuffer,6743,120)		//--NF_DI_LOCAL_URF_DESPACHO	A	120	6743
					cNF_DI_COD_IBGE_URF_DESPACHO:= SubSTR(cBuffer,6863,007)		//--NF_DI_COD_IBGE_URF_DESPACHO	A	7	6863
					cNF_DI_UF_URF_DESPACHO		:= SubSTR(cBuffer,6870,002)		//--NF_DI_UF_URF_DESPACHO	A	2	6870
					cNF_DI_COD_IBGE_IMPORTADOR	:= SubSTR(cBuffer,6872,007)		//--NF_DI_COD_IBGE_IMPORTADOR	A	7	6872
					cNF_DI_INSC_SUFRAMA_IMPORTAD:= SubSTR(cBuffer,6879,009)		//--NF_DI_INSC_SUFRAMA_IMPORTADOR	A	9	6879
					cNF_CNPJ_TRANSP_LOCAL		:= SubSTR(cBuffer,6888,018)		//--NF_CNPJ_TRANSP_LOCAL	A	18	6888
					cNF_INSC_ESTADUAL_TRANSP_LOC:= SubSTR(cBuffer,6906,030)		//--NF_INSC_ESTADUAL_TRANSP_LOCAL	A	30	6906
					cNF_RAZAO_SOCIAL_TRANSP_LOCA:= SubSTR(cBuffer,6936,120)		//--NF_RAZAO_SOCIAL_TRANSP_LOCAL	A	120	6936
					cNF_ENDERECO_TRANSP_LOCAL	:= SubSTR(cBuffer,7056,258)		//--NF_ENDERECO_TRANSP_LOCAL	A	258	7056
					cNF_CIDADE_TRANSP_LOCAL		:= SubSTR(cBuffer,7314,035)		//--NF_CIDADE_TRANSP_LOCAL	A	35	7314
					cNF_UF_TRANSP_LOCAL			:= SubSTR(cBuffer,7349,030)		//--NF_UF_TRANSP_LOCAL	A	30	7349
					cNF_NFE_SEFAZ_STATUS		:= SubSTR(cBuffer,7379,040)		//--NF_NFE_SEFAZ_STATUS	A	40	7379
					cNF_NFE_SEFAZ_PROTOCOLO		:= SubSTR(cBuffer,7419,020)		//--NF_NFE_SEFAZ_PROTOCOLO	A	20	7419
					cNF_NFE_SEFAZ_COD_REGIAO	:= SubSTR(cBuffer,7439,002)		//--NF_NFE_SEFAZ_COD_REGIAO	A	2	7439
					cNF_NFE_SEFAZ_EXERC_CONTABIL:= SubSTR(cBuffer,7441,002)		//--NF_NFE_SEFAZ_EXERC_CONTABIL	A	2	7441
					cNF_NFE_SEFAZ_MES			:= SubSTR(cBuffer,7443,002)		//--NF_NFE_SEFAZ_MES	A	2	7443
					cNF_NFE_SEFAZ_CNPJ			:= SubSTR(cBuffer,7445,014)		//--NF_NFE_SEFAZ_CNPJ	A	14	7445
					cNF_NFE_SEFAZ_MODELO_NF		:= SubSTR(cBuffer,7459,002)		//--NF_NFE_SEFAZ_MODELO_NF	A	2	7459
					cNF_NFE_SEFAZ_SERIE_NF		:= SubSTR(cBuffer,7461,003)		//--NF_NFE_SEFAZ_SERIE_NF	A	3	7461
					cNF_NFE_SEFAZ_NUMERO_NF		:= SubSTR(cBuffer,7464,009)		//--NF_NFE_SEFAZ_NUMERO_NF	A	9	7464
					cNF_NFE_SEFAZ_NUMERO_ALEATOR:= SubSTR(cBuffer,7473,009)		//--NF_NFE_SEFAZ_NUMERO_ALEATORIO	A	9	7473
					cNF_NFE_SEFAZ_DIGITO_CTRLE	:= SubSTR(cBuffer,7482,001)		//--NF_NFE_SEFAZ_DIGITO_CTRLE	A	1	7482
					cNF_NFE_SEFAZ_CHAVE_ACESSO	:= SubSTR(cBuffer,7483,044)		//--NF_NFE_SEFAZ_CHAVE_ACESSO	A	44	7483
					cNF_NFE_SEFAZ_ELETRONICA	:= SubSTR(cBuffer,7527,001)		//--NF_NFE_SEFAZ_ELETRONICA	A	1	7527
					cNF_NFE_SEFAZ_FORMATO_DANFE	:= SubSTR(cBuffer,7528,047)		//--NF_NFE_SEFAZ_FORMATO_DANFE	N	47	7528
					cNF_NFE_SEFAZ_FORMA_NF		:= SubSTR(cBuffer,7575,047)		//--NF_NFE_SEFAZ_FORMA_NF	N	47	7575
					cNF_NFE_SEFAZ_PROCESSO_EMISS:= SubSTR(cBuffer,7622,047)		//--NF_NFE_SEFAZ_PROCESSO_EMISS_NF	N	47	7622
					cNF_NFE_SEFAZ_VERSAO_EMISSAO:= SubSTR(cBuffer,7669,020)		//--NF_NFE_SEFAZ_VERSAO_EMISSAO_NF	A	20	7669
					cNF_NFE_SEFAZ_TIPO_PAGTO_FAT:= SubSTR(cBuffer,7689,001)		//--NF_NFE_SEFAZ_TIPO_PAGTO_FATURA	A	1	7689
					cNF_DTCANCEL				:= SubSTR(cBuffer,7690,014)		//--NF_DTCANCEL	D	14	7690
					cNF_OBSCANCEL				:= SubSTR(cBuffer,7704,2000)	//--NF_OBSCANCEL	A	2000	7704
					cNF_TAXA_DOLAR_REGISTRO_DI	:= SubSTR(cBuffer,9704,047)		//--NF_TAXA_DOLAR_REGISTRO_DI	N	47	9704
					cNF_NUMERO_cNF_EXTERNO		:= SubSTR(cBuffer,9751,020)		//--NF_NUMERO_NF_EXTERNO	A	20	9751
					cNF_SERIE_cNF_EXTERNO		:= SubSTR(cBuffer,9771,005)		//--NF_SERIE_NF_EXTERNO	A	5	9771
					cNF_NUM_CTRLE_EXTERNO		:= SubSTR(cBuffer,9776,020)		//--NF_NUM_CTRLE_EXTERNO	A	20	9776
					cNF_NFC_CHAVE_ACESSO_ENTRADA:= SubSTR(cBuffer,9796,044)		//--NF_NFC_CHAVE_ACESSO_ENTRADA	A	44	9796
					cNF_NFC_COD_REGIAO_ENTRADA	:= SubSTR(cBuffer,9840,002)		//--NF_NFC_COD_REGIAO_ENTRADA	A	2	9840
					cNF_NFC_EXERC_CONTABIL_ENTRA:= SubSTR(cBuffer,9842,002)		//--NF_NFC_EXERC_CONTABIL_ENTRADA	A	2	9842
					cNF_NFC_MES_ENTRADA			:= SubSTR(cBuffer,9844,002)		//--NF_NFC_MES_ENTRADA	A	2	9844
					cNF_NFC_CNPJ_ENTRADA		:= SubSTR(cBuffer,9846,014)		//--NF_NFC_CNPJ_ENTRADA	A	14	9846
					cNF_NFC_MODELO_cNF_ENTRADA	:= SubSTR(cBuffer,9860,002)		//--NF_NFC_MODELO_NF_ENTRADA	A	2	9860
					cNF_NFC_SERIE_cNF_ENTRADA	:= SubSTR(cBuffer,9862,003)		//--NF_NFC_SERIE_NF_ENTRADA	A	3	9862
					cNF_NFC_NUMERO_cNF_ENTRADA	:= SubSTR(cBuffer,9865,009)		//--NF_NFC_NUMERO_NF_ENTRADA	A	9	9865
					cNF_MOTIVO_CONTINGENCIA		:= SubSTR(cBuffer,9874,256)		//--NF_MOTIVO_CONTINGENCIA	A	256	9874
					cNF_DATA_CONTINGENCIA		:= SubSTR(cBuffer,10130,014)	//--NF_DATA_CONTINGENCIA	D	14	10130
					cNF_VAGAO					:= SubSTR(cBuffer,10144,020)	//--NF_VAGAO	A	20	10144
					cNF_BALSA					:= SubSTR(cBuffer,10164,020)	//--NF_BALSA	A	20	10164
					cNF_CRT	  					:= SubSTR(cBuffer,10184,001)	//--NF_CRT	A	1	10184
					cNF_cTAXA_EMISSAO_DI		:= SubSTR(cBuffer,10185,047)	//--TAXA_EMISSAO_DI	N	47	10185
					cNF_MARINHA_MERCANTE		:= SubSTR(cBuffer,10232,047)	//--MARINHA_MERCANTE	N	47	10232
					cNF_ANTIDUMPING				:= SubSTR(cBuffer,10279,047)	//--ANTIDUMPING	N	47	10279
					
					/*
					cNF_AMBIENTE_PROD_HOMOL		:= SubSTR(cBuffer,10185,001)	//--NF_AMBIENTE_PROD_HOMOL	A	1	10185					
					cNF_QTDE_VOLUME	   			:= SubSTR(cBuffer,10186,047)	//--NF_QTDE_VOLUME	N	47	10186
					cNF_ESPECIE_VOLUME_DESCRICAO:= SubSTR(cBuffer,10233,120)	//--NF_ESPECIE_VOLUME_DESCRICAO	A	120	10233
					cNF_VLR_ICMS_SUB			:= SubSTR(cBuffer,10353,047)	//--NF_VLR_ICMS_SUB	N	47	10353
					cNF_BS_ICMS_SUB				:= SubSTR(cBuffer,10400,047)	//--NF_BS_ICMS_SUB	N	47	10400
					cNF_COD_TIPO_DOCTO_CARGA	:= SubSTR(cBuffer,10447,005)	//--NF_COD_TIPO_DOCTO_CARGA	N	5	10447
					*/
					
                    
	                cNF_EMPRESA := ALLTRIM(STRTRAN(cNF_EMPRESA,"."," "))
	                If SubSTR(cNF_EMPRESA,1,1) $ "CF"
	                	cNF_EMPRESA := SubSTR(cNF_EMPRESA,2,Len(cNF_EMPRESA))
	                EndIf             
	                
	                cNF_CLIFOR := ALLTRIM(STRTRAN(cNF_CLIFOR,"."," "))   
	                If SubSTR(cNF_CLIFOR,1,1) $ "CF"
	                	cNF_CLIFOR := SubSTR(cNF_CLIFOR,2,Len(cNF_CLIFOR))
	                EndIf
                               
                	cSTRING := cDATAHORA + "LEITURA DO ARQUIVO CABECALHO - LINHA: "+cValToChar(nCOUNTLN) + &(CENDOFFILE)
                	conout(cSTRING)
                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))	

	                dbSelectArea("SA2")
	                dbSetOrder(1)
	                If dbSeek( xFilial("SA2") + cNF_EMPRESA )
	                
	                	nPOS := aScan ( aEMPRESAS, {|x| x[3] == SA2->A2_CGC } )

	                	If nPOS != 0

			                dbSelectArea("SA2")
			                dbSetOrder(1)
			                If dbSeek( xFilial("SA2") + cNF_CLIFOR )
                                
								/**
									1-EMPRESA/FILIAL, 2-F1_TIPO, 3-F1_EMISSAO, 4-F1_FORNECE, 5-F1_LOJA, 6-F1_VALBRUT, 7-F1_VALMERC,
									8-F1_VALICM, 9-F1_VALIPI, 10-F1_FRETE, 11-F1_SEGURO, 12-F1_DESPESA, 13-F1_BASEICM, 14-F1_BASEIPI,
									15-F1_PESOL, 16-F1_X_TIPTR, 17-F1_X_NAVIO, 18-F1_X_TPFRT, 19-F1_X_TXTHC, 20-F1_X_VLRII, 21-F1_X_NUMDI,
									22-F1_X_TXSIS, 23-F1_X_DATDI, 24-F1_X_DATDE, 25-F1_X_NUMBL, 26-F1_X_UFDI, 27-F1_X_LOCDI, 28-F1_X_MICRT,
									29-F1_X_NUMFT, 30-F1_X_IDSYS, 31-F1_X_PRSYS, 32-F1_X_NDSYS, 33-F1_X_SDSYS, 34-ITENS NF, 35-F1_X_MARME,
									36-F1_X_ANTID
								**/
								
								aAdd ( aDADOSDOC, { aEMPRESAS[nPOS,01]+aEMPRESAS[nPOS,02],;
													cNF_TPNOTA,;
													stod(cNF_DTEMIS),;
													SUBSTR(cNF_CLIFOR,1,TAMSX3("A2_COD")[1]),;
													SUBSTR(cNF_CLIFOR,TAMSX3("A2_COD")[1]+1,TAMSX3("A2_LOJA")[1]),;
													VAL(cNF_VRTOTAL),;
													VAL(cNF_VRMERCA),;
													VAL(cNF_VRICMS),;
													VAL(cNF_VRIPI),;
													VAL(cNF_VRFRETE),;
													VAL(cNF_VRSEGURO),;
													VAL(cNF_VRDESPESA),;
													VAL(cNF_BASEICMS),;
													VAL(cNF_BASEIPI),;
													VAL(cNF_PESOLI),; 
													ALLTRIM(cNF_VIATRA),;
													ALLTRIM(cNF_MEIOTRA),;
													ALLTRIM(cNF_FRETE_ED),;
													VAL(cNF_ACRESCIMOS)-VAL(cNF_DEDUCOES),;
													VAL(cNF_II),;
													ALLTRIM(cNF_NUM_DI),;
													VAL(cNF_cTAXA_EMISSAO_DI),;
													SubSTR(cNF_DATA_REGISTRO_DI,1,8),;
													SubSTR(cNF_DATA_DESEMBARACO,1,8),;
													ALLTRIM(cNF_NUM_CONHECIMENTO),; 
													ALLTRIM(cNF_DI_UF_URF_DESPACHO),;
													ALLTRIM(cNF_DI_LOCAL_URF_DESPACHO),;
													ALLTRIM(cNF_CRT),;
													Space(0),;
													ALLTRIM(cNF_ID),;
													ALLTRIM(cNF_EMPRESA),;
													ALLTRIM(cNF_NUMNF),;
													ALLTRIM(cNF_SERIE),;
													{},;
													VAL(cNF_MARINHA_MERCANTE),;
													VAL(cNF_ANTIDUMPING),;    // })
													Val(cNF_TAXA_DI ) }) //Incluido por Guilherme 20/03/12 para receber o valor da taxa cambial do importsys			                                   
													CONOUT(SubSTR(cNF_DATA_REGISTRO_DI,1,8))
			                Else

			                	cSTRING := cDATAHORA + "FAVORECIDO NAO LOCALIZADO CADASTRO DE FORNECEDOR - "+cNF_CLIFOR + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))										
			                
			                EndIf

						Else
							
							cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA SIGAMAT - "+cNF_EMPRESA + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
											
						EndIf

					Else
					
	                	cSTRING := cDATAHORA + "EMPRESA/FILIAL NAO LOCALIZADA COMO FORNECEDOR - "+cNF_EMPRESA + &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
	    			
	    			EndIf
					
				    //ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				    //ณ Leitura da proxima linha do arquivo texto.                          ณ
				    //ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				
				    nBtLidos := fRead(hFILESF1_1,@cBuffer,nTamLin) 
				
				    dbSkip()
				EndDo
					
                    
     			If Len(aDADOSDOC) > 0
     			
	     			//-- LEITURA DO ARQUIVO DE ITENS:
	
					cSTRING := cDATAHORA + "INICIO LEITURA DO ARQUIVO - ITENS: " +CPATHFILES+aARQUIVO2[_nINDARQ] + &(CENDOFFILE)
					conout(cSTRING)
					fWrite(hFILELOG1,cSTRING,Len(cSTRING))
						
					nTamFile2 := fSeek(hFILESF1_2,0,2)
					fSeek(hFILESF1_2,0,0)
					nTamLin2  := 11798 //11797
					cBuffer2  := Space(nTamLin2)
					
					nBtLidos2 := fRead(hFILESF1_2,@cBuffer2,nTamLin2)
					
					nCOUNTLN := 0
                    
					While nBtLidos2 >= nTamLin2
	
				    	If chr(13) $ cBuffer
				    		cBuffer := STRTRAN(cBuffer,chr(13),"")
				    	EndIf    
				    	
				    	nCOUNTLN += 1    		//--Contador de linhas
				    	
						cSTRING := cDATAHORA + "LEITURA DO ARQUIVO ITENS - LINHA: " +cValToChar(nCOUNTLN) + &(CENDOFFILE)
						conout(cSTRING)
						fWrite(hFILELOG1,cSTRING,Len(cSTRING))
					    	
						cIT_NFID					:= SubSTR(cBuffer2,001,047)		//--NF_ITE_NFID	N	47	1
						cIT_EMPRESA					:= SubSTR(cBuffer2,048,020)		//--NF_ITE_EMPRESA	A	20	48
						cIT_NUMNF					:= SubSTR(cBuffer2,068,020)		//--NF_ITE_NUMNF	A	20	68
						cIT_SERIE					:= SubSTR(cBuffer2,088,005)		//--NF_ITE_SERIE	A	5	88
					
		                cIT_EMPRESA := ALLTRIM(STRTRAN(cIT_EMPRESA,"."," "))
		                If SubSTR(cIT_EMPRESA,1,1) $ "CF"
		                	cIT_EMPRESA := SubSTR(cIT_EMPRESA,2,Len(cIT_EMPRESA))
		                EndIf             
							
						//-- Verifica cabe็alho com item da nota fiscal
						nPOS := aScan ( aDADOSDOC, {|x| x[30] == ALLTRIM(cIT_NFID) .and. x[31] == ALLTRIM(cIT_EMPRESA) ,;
														x[32] == ALLTRIM(cIT_NUMNF) .and. x[33] == ALLTRIM(cIT_SERIE) } )
						
						If nPOS == 0
						
							cSTRING := cDATAHORA + "NAO LOCALIZADO CABECALHO PARA O ITEM: ITE_NFID: " + ALLTRIM(cIT_NFID) + " - ITE_EMPRESA: "+ ALLTRIM(cIT_EMPRESA) + " - ITE_NUMNF: "+ ALLTRIM(cIT_NUMNF) + " - ITE_SERIE: " + ALLTRIM(cIT_SERIE) + &(CENDOFFILE)
							conout(cSTRING)
							fWrite(hFILELOG1,cSTRING,Len(cSTRING))

							nBtLidos2 := fRead(hFILESF1_2,@cBuffer2,nTamLin2)
							dbSkip()
							Loop
								
						EndIf						
						
						cIT_DTEMIS					:= SubSTR(cBuffer2,093,014)		//--NF_ITE_DTEMIS	D	14	93
						cIT_NUMITE					:= SubSTR(cBuffer2,107,047)		//--NF_ITE_NUMITE	N	47	107
						cIT_CODPROD					:= SubSTR(cBuffer2,154,100)		//--NF_ITE_CODPROD	A	100	154
						cIT_QTDE					:= SubSTR(cBuffer2,254,047)		//--NF_ITE_QTDE	N	47	254
						cIT_PRUNIT					:= SubSTR(cBuffer2,301,047)		//--NF_ITE_PRUNIT	N	47	301
						cIT_CLIFOR					:= SubSTR(cBuffer2,348,020)		//--NF_ITE_CLIFOR	A	20	348
						cIT_NATOPE					:= SubSTR(cBuffer2,368,005)		//--NF_ITE_NATOPE	A	5	368
						cIT_PERICMS					:= SubSTR(cBuffer2,373,047)		//--NF_ITE_PERICMS	N	47	373
						cIT_CDICMS					:= SubSTR(cBuffer2,420,002)		//--NF_ITE_CDICMS	A	2	420
						cIT_BASEICMS				:= SubSTR(cBuffer2,422,047)		//--NF_ITE_BASEICMS	N	47	422
						cIT_PERIPI					:= SubSTR(cBuffer2,469,047)		//--NF_ITE_PERIPI	N	47	469
						cIT_CDIPI					:= SubSTR(cBuffer2,516,001)		//--NF_ITE_CDIPI	A	1	516
						cIT_BASEIPI					:= SubSTR(cBuffer2,517,047)		//--NF_ITE_BASEIPI	N	47	517
						cIT_PEDIDO					:= SubSTR(cBuffer2,564,016)		//--NF_ITE_PEDIDO	A	16	564
						cIT_ITEM_PED				:= SubSTR(cBuffer2,580,007)		//--NF_ITE_ITEM_PED	A	7	580
						cIT_UNIDA					:= SubSTR(cBuffer2,587,004)		//--NF_ITE_UNIDA	A	4	587
						cIT_CLAFIS					:= SubSTR(cBuffer2,591,008)		//--NF_ITE_CLAFIS	A	8	591
						cIT_VRTTITE					:= SubSTR(cBuffer2,599,047)		//--NF_ITE_VRTTITE	N	47	599
						cIT_VRIPI					:= SubSTR(cBuffer2,646,047)		//--NF_ITE_VRIPI	N	47	646
						cIT_VRICMS					:= SubSTR(cBuffer2,693,047)		//--NF_ITE_VRICMS	N	47	693
						cIT_SITTRIB					:= SubSTR(cBuffer2,740,001)		//--NF_ITE_SITTRIB	A	1	740
						cIT_TPNOTA					:= SubSTR(cBuffer2,741,002)		//--NF_ITE_TPNOTA	A	2	741
						cIT_EMBARQUE_NUM			:= SubSTR(cBuffer2,743,015)		//--NF_ITE_EMBARQUE_NUM	A	15	743
						cIT_EMBARQUE_ANO			:= SubSTR(cBuffer2,758,004)		//--NF_ITE_EMBARQUE_ANO	A	4	758
						cIT_FLAG_NF					:= SubSTR(cBuffer2,762,001)		//--NF_ITE_FLAG_NF	A	1	762
						cIT_PESO_LI					:= SubSTR(cBuffer2,763,047)		//--NF_ITE_PESO_LI	N	47	763
						cIT_ALIQ_II					:= SubSTR(cBuffer2,810,047)		//--NF_ITE_ALIQ_II	N	47	810
						cIT_FOB_MO					:= SubSTR(cBuffer2,857,047)		//--NF_ITE_FOB_MO	N	47	857
						cIT_DESCRICAO				:= SubSTR(cBuffer2,904,4000)	//--NF_ITE_DESCRICAO	A	4000	904
						cIT_VL_FRETE_RATEADO		:= SubSTR(cBuffer2,4904,047)	//--NF_ITE_VL_FRETE_RATEADO	N	47	4904
						cIT_VL_SEGURO_RATEADO		:= SubSTR(cBuffer2,4951,047)	//--NF_ITE_VL_SEGURO_RATEADO	N	47	4951
						cIT_NM_NUM_INVOICE			:= SubSTR(cBuffer2,4998,018)	//--NF_ITE_NM_NUM_INVOICE	A	18	4998
						cIT_NM_ID_INVOICE			:= SubSTR(cBuffer2,5016,047)	//--NF_ITE_NM_ID_INVOICE	N	47	5016
						cIT_NM_EXTERNO_CFOP			:= SubSTR(cBuffer2,5063,147)	//--NF_ITE_NM_EXTERNO_CFOP	A	147	5063
						cIT_NM_ADICAO				:= SubSTR(cBuffer2,5210,047)	//--NF_ITE_NM_ADICAO	N	47	5210
						cIT_VL_QTDE_ESTATISTICA		:= SubSTR(cBuffer2,5257,047)	//--NF_ITE_VL_QTDE_ESTATISTICA	N	47	5257
						cIT_BAS_PIS					:= SubSTR(cBuffer2,5304,047)	//--NF_ITE_BASEPIS	N	47	5304
						cIT_ALIQ_PIS				:= SubSTR(cBuffer2,5351,047)	//--NF_ITE_ALIQ_PIS	N	47	5351
						cIT_VRPIS					:= SubSTR(cBuffer2,5398,047)	//--NF_ITE_VRPIS	N	47	5398
						cIT_BAS_COF  				:= SubSTR(cBuffer2,5445,047)	//--NF_ITE_BASECOFINS	N	47	5445
						cIT_ALIQ_COFINS				:= SubSTR(cBuffer2,5492,047)	//--NF_ITE_ALIQ_COFINS	N	47	5492
						cIT_VRCOFINS				:= SubSTR(cBuffer2,5539,047)	//--NF_ITE_VRCOFINS	N	47	5539
						cIT_BASE_II					:= SubSTR(cBuffer2,5586,047)	//--NF_ITE_BASE_II	N	47	5586
						cIT_VRII					:= SubSTR(cBuffer2,5633,047)	//--NF_ITE_VRII	N	47	5633
						cIT_ORGANIZACAO				:= SubSTR(cBuffer2,5680,100)	//--NF_ITE_ORGANIZACAO	A	100	5680
						cIT_FOB						:= SubSTR(cBuffer2,5780,047)	//--NF_ITE_FOB	N	47	5780
						cIT_VRDESPESA				:= SubSTR(cBuffer2,5827,047)	//--NF_ITE_VRDESPESA	N	47	5827
						cIT_NUMEX					:= SubSTR(cBuffer2,5874,020)	//--NF_ITE_NUMEX	A	20	5874
						cIT_GERACAO_PEDIDO			:= SubSTR(cBuffer2,5894,014)	//--NF_ITE_GERACAO_PEDIDO	D	14	5894
						cIT_PREVISAO_PEDIDO			:= SubSTR(cBuffer2,5908,014)	//--NF_ITE_PREVISAO_PEDIDO	D	14	5908
						cIT_ID_ITEM_FATURA			:= SubSTR(cBuffer2,5922,047)	//--NF_ITE_ID_ITEM_FATURA	N	47	5922
						cIT_CFOP_INTERFACE			:= SubSTR(cBuffer2,5969,050)	//--NF_ITE_CFOP_INTERFACE	A	50	5969
						cIT_CFOP_FLEX1				:= SubSTR(cBuffer2,6019,050)	//--NF_ITE_CFOP_FLEX1	A	50	6019
						cIT_CFOP_FLEX2				:= SubSTR(cBuffer2,6069,050)	//--NF_ITE_CFOP_FLEX2	A	50	6069
						cIT_CFOP_FLEX3				:= SubSTR(cBuffer2,6119,050)	//--NF_ITE_CFOP_FLEX3	A	50	6119
						cIT_DISPLEG_ICMS			:= SubSTR(cBuffer2,6169,050)	//--NF_ITE_DISPLEG_ICMS	A	50	6169
						cIT_DISPLEG_IPI				:= SubSTR(cBuffer2,6219,050)	//--NF_ITE_DISPLEG_IPI	A	50	6219
						cIT_TIPO_PRODUTO			:= SubSTR(cBuffer2,6269,020)	//--NF_ITE_TIPO_PRODUTO	A	20	6269
						cIT_AREA_NEGOCIO			:= SubSTR(cBuffer2,6289,020)	//--NF_ITE_AREA_NEGOCIO	A	20	6289
						cIT_DESPESAS_BASEICMS		:= SubSTR(cBuffer2,6309,047)	//--NF_ITE_DESPESAS_BASEICMS	N	47	6309
						cIT_BASEICMS_ISENTA			:= SubSTR(cBuffer2,6356,047)	//--NF_ITE_BASEICMS_ISENTA	N	47	6356
						cIT_BASEIPI_ISENTA			:= SubSTR(cBuffer2,6403,047)	//--NF_ITE_BASEIPI_ISENTA	N	47	6403
						cIT_BASEPIS_ISENTA			:= SubSTR(cBuffer2,6450,047)	//--NF_ITE_BASEPIS_ISENTA	N	47	6450
						cIT_BASECOFINS_ISENTA		:= SubSTR(cBuffer2,6497,047)	//--NF_ITE_BASECOFINS_ISENTA	N	47	6497
						cIT_BASEICMS_OUTRAS			:= SubSTR(cBuffer2,6544,047)	//--NF_ITE_BASEICMS_OUTRAS	N	47	6544
						cIT_BASEIPI_OUTRAS			:= SubSTR(cBuffer2,6591,047)	//--NF_ITE_BASEIPI_OUTRAS	N	47	6591
						cIT_BASEPIS_OUTRAS			:= SubSTR(cBuffer2,6638,047)	//--NF_ITE_BASEPIS_OUTRAS	N	47	6638
						cIT_BASECOFINS_OUTRAS		:= SubSTR(cBuffer2,6685,047)	//--NF_ITE_BASECOFINS_OUTRAS	N	47	6685
						cIT_GRUPO_MERCADORIA		:= SubSTR(cBuffer2,6732,100)	//--NF_ITE_GRUPO_MERCADORIA	A	100	6732
						cIT_ID_CORPORATIVO			:= SubSTR(cBuffer2,6832,100)	//--NF_ITE_ID_CORPORATIVO	A	100	6832
						cIT_VLR_ITEM				:= SubSTR(cBuffer2,6932,047)	//--NF_ITE_VLR_ITEM	N	47	6932
						cIT_CST						:= SubSTR(cBuffer2,6979,003)	//--NF_ITE_CST	A	3	6979
						cIT_NR_REG_LI				:= SubSTR(cBuffer2,6982,010)	//--NF_ITE_NR_REG_LI	A	10	6982
						cIT_ID_ADICAO				:= SubSTR(cBuffer2,6992,047)	//--NF_ITE_ID_ADICAO	N	47	6992
						cIT_ID_ITEM_ADICAO			:= SubSTR(cBuffer2,7039,047)	//--NF_ITE_ID_ITEM_ADICAO	N	47	7039
						cIT_NM_ITEM_ADICAO			:= SubSTR(cBuffer2,7086,047)	//--NF_ITE_NM_ITEM_ADICAO	N	47	7086
						cIT_DEDUCAO_ADICAO			:= SubSTR(cBuffer2,7133,047)	//--NF_ITE_DEDUCAO_ADICAO	N	47	7133
						cIT_PERC_REDUCAO_BASE_ICMS	:= SubSTR(cBuffer2,7180,047)	//--NF_ITE_PERC_REDUCAO_BASE_ICMS	N	47	7180
						cIT_CST_IPI					:= SubSTR(cBuffer2,7227,002)	//--NF_ITE_CST_IPI	A	2	7227
						cIT_CST_PIS_COFINS			:= SubSTR(cBuffer2,7229,002)	//--NF_ITE_CST_PIS_COFINS	A	2	7229
						cIT_COD_FABRICANTE			:= SubSTR(cBuffer2,7231,020)	//--NF_ITE_COD_FABRICANTE	A	20	7231
						cIT_CAPAC_UNIT_QTDE_IPI		:= SubSTR(cBuffer2,7251,047)	//--NF_ITE_CAPAC_UNIT_QTDE_IPI	N	47	7251
						cIT_CAPAC_UNIT_VALOR_IPI	:= SubSTR(cBuffer2,7298,047)	//--NF_ITE_CAPAC_UNIT_VALOR_IPI	N	47	7298
						cIT_PIS_COFINS_TIPO_APLIC	:= SubSTR(cBuffer2,7345,001)	//--NF_ITE_PIS_COFINS_TIPO_APLIC	A	1	7345
						cIT_PIS_COFINS_QTDE_ESPEC	:= SubSTR(cBuffer2,7346,047)	//--NF_ITE_PIS_COFINS_QTDE_ESPEC	N	47	7346
						cIT_TIPO_PROD				:= SubSTR(cBuffer2,7393,001)	//--NF_ITE_TIPO_PROD	A	1	7393
						cIT_VLR_DESP_FORA_BASE_ICMS	:= SubSTR(cBuffer2,7394,047)	//--NF_ITE_VLR_DESP_FORA_BASE_ICMS	N	47	7394
						cIT_PAIS_ORIGEM				:= SubSTR(cBuffer2,7441,050)	//--NF_ITE_PAIS_ORIGEM	A	50	7441
						cIT_MOEDA_NEG				:= SubSTR(cBuffer2,7491,025)	//--NF_ITE_MOEDA_NEG	A	25	7491
						cIT_NFC_DESCRICAO_ENTRADA	:= SubSTR(cBuffer2,7516,4000)	//--NF_ITE_NFC_DESCRICAO_ENTRADA	A	4000	7516
						cIT_NFC_DESPESAS			:= SubSTR(cBuffer2,11516,047)	//--NF_ITE_NFC_DESPESAS	N	47	11516
						cIT_FLAG_RECUP_CRED_II		:= SubSTR(cBuffer2,11563,001)	//--NF_ITE_FLAG_RECUP_CRED_II	A	1	11563
						cIT_FLAG_RECUP_CRED_IPI		:= SubSTR(cBuffer2,11564,001)	//--NF_ITE_FLAG_RECUP_CRED_IPI	A	1	11564
						cIT_FLAG_RECUP_CRED_ICMS	:= SubSTR(cBuffer2,11565,001)	//--NF_ITE_FLAG_RECUP_CRED_ICMS	A	1	11565
						cIT_FLAG_RECUP_CRED_PIS		:= SubSTR(cBuffer2,11566,001)	//--NF_ITE_FLAG_RECUP_CRED_PIS	A	1	11566
						cIT_FLAG_RECUP_CRED_COFINS	:= SubSTR(cBuffer2,11567,001)	//--NF_ITE_FLAG_RECUP_CRED_COFINS	A	1	11567
						cIT_OUTRAS_DESP_ACESSORIAS	:= SubSTR(cBuffer2,11568,047)	//--NF_ITE_OUTRAS_DESP_ACESSORIAS	N	47	11568
						cIT_INDTOT					:= SubSTR(cBuffer2,11615,001)	//--NF_ITE_INDTOTA	1	11615
						cIT_VL_FRETE_RATEADO_NFE	:= SubSTR(cBuffer2,11616,047)	//--NF_ITE_VL_FRETE_RATEADO_NFE	N	47	11616
						cIT_VL_SEGURO_RATEADO_NFE	:= SubSTR(cBuffer2,11663,047)	//--NF_ITE_VL_SEGURO_RATEADO_NFE	N	47	11663
						cIT_COD_UN_NEGOCIO			:= SubSTR(cBuffer2,11710,020)	//--NF_ITE_COD_UN_NEGOCIO	A	20	11710
						cIT_NUM_NF_NFE				:= SubSTR(cBuffer2,11730,020)	//--NF_ITE_NUM_NF_NFE	A	20	11730
						cIT_VRTOTAL_NF				:= SubSTR(cBuffer2,11750,047)	//--NF_ITE_VRTOTAL_NF	N	47	11750
						/*
						cNUM_ATO_DRAWBACK			:= SubSTR(cBuffer2,11797,013)	//--NUM_ATO_DRAWBACK	A	13	11797
						cIT_IA_COD_EXTERNO_CFOP		:= SubSTR(cBuffer2,11810,025)	//--NF_ITE_IA_COD_EXTERNO_CFOP	A	25	11810
						cIT_INF_COD_EXTERNO_CFOP	:= SubSTR(cBuffer2,11835,025)	//--NF_ITE_INF_COD_EXTERNO_CFOP	A	25	11835
						cIT_ID_CFOP_COMPLEMENTAR	:= SubSTR(cBuffer2,11860,047)	//--NF_ITE_ID_CFOP_COMPLEMENTAR	N	47	11860
						cIT_CNPJ					:= SubSTR(cBuffer2,11907,014)	//--NF_ITE_CNPJ	A	14	11907
						cIT_DESCNATOPE				:= SubSTR(cBuffer2,11921,120)	//--NF_ITE_DESCNATOPE	A	120	11921
						cIT_COD_PROCESSO			:= SubSTR(cBuffer2,12041,015)	//--NF_ITE_COD_PROCESSO	A	15	12041
						cIT_INCOTERM				:= SubSTR(cBuffer2,12056,003)	//--NF_ITE_INCOTERM	A	3	12056
						cIT_NUMERO_DI				:= SubSTR(cBuffer2,12059,013)	//--NF_ITE_NUMERO_DI	A	13	12059
						cIT_DATA_REGISTRO_DI		:= SubSTR(cBuffer2,12072,014)	//--NF_ITE_DATA_REGISTRO_DI	D	14	12072
						cIT_SEQ_IT_ADICAO			:= SubSTR(cBuffer2,12086,003)	//--NF_ITE_SEQ_IT_ADICAO	N	3	12086
						cIT_TAXA_DI					:= SubSTR(cBuffer2,12089,047)	//--NF_ITE_TAXA_DI	N	47	12089
						cIT_MOEDA_FRETE				:= SubSTR(cBuffer2,12136,025)	//--NF_ITE_MOEDA_FRETE	A	25	12136
						cIT_FRETE_MO				:= SubSTR(cBuffer2,12161,047)	//--NF_ITE_FRETE_MO	N	47	12161
						cIT_TAXA_FRETE				:= SubSTR(cBuffer2,12208,047)	//--NF_ITE_TAXA_FRETE	N	47	12208
						cIT_MOEDA_SEGURO			:= SubSTR(cBuffer2,12255,025)	//--NF_ITE_MOEDA_SEGURO	A	25	12255
						cIT_SEGURO_MO				:= SubSTR(cBuffer2,12280,047)	//--NF_ITE_SEGURO_MO	N	47	12280
						cIT_TAXA_SEGURO				:= SubSTR(cBuffer2,12327,047)	//--NF_ITE_TAXA_SEGURO	N	47	12327
						cIT_DEDUCAO					:= SubSTR(cBuffer2,12374,047)	//--NF_ITE_DEDUCAO	N	47	12374
						cIT_NUMERO_NF_EXTERNO		:= SubSTR(cBuffer2,12421,020)	//--NF_ITE_NUMERO_NF_EXTERNO	A	20	12421
						cIT_SERIE_NF_EXTERNO		:= SubSTR(cBuffer2,12441,005)	//--NF_ITE_SERIE_NF_EXTERNO	A	5	12441
						cIT_CODIGOBARRAS			:= SubSTR(cBuffer2,12446,150)	//--NF_ITE_CODIGOBARRAS	A	150	12446
						*/
						
						/***	DADOS DO ARRAY DE ITENS:
							1-D1_ITEM, 2-D1_COD, 3-D1_DESCRI, 4-D1_QUANT, 5-D1_VUNIT, 6-D1_PEDIDO, 7-D1_ITEMPC, 8-D1_VALOR,
							9-D1_VALIPI, 10-D1_VALICM, 11-D1_PESO, 12-D1_ALIQII, 13-D1_VALFRE, 14-D1_SEGURO, 15-F1_X_NUMFT
						***/
	
						nQTDEIT := VAL(cIT_QTDE)
						If nQTDEIT < 0
							nQTDEIT := nQTDEIT * -1
						EndIf
						nPRCUNT := VAL(cIT_PRUNIT) 
						If nPRCUNT < 0
							nPRCUNT := nPRCUNT * -1
						EndIf
						nVRTTIT := VAL(cIT_VRTTITE)
						If nVRTTIT < 0
							nVRTTIT := nVRTTIT * -1
						EndIf
						nVRIPIT := VAL(cIT_VRIPI)
						If nVRIPIT < 0
							nVRIPIT := nVRIPIT * -1
						EndIf
						nVRICMS := VAL(cIT_VRICMS)
						If nVRICMS < 0
							nVRICMS := nVRICMS * -1
						EndIf
						nPESOIT := VAL(cIT_PESO_LI)
						If nPESOIT < 0
							nPESOIT := nPESOIT * -1
						EndIf
						nALIQII := VAL(cIT_ALIQ_II)
						If nALIQII < 0
							nALIQII := nALIQII * -1
						EndIf
						nVRFRET := VAL(cIT_VL_FRETE_RATEADO)
						If nVRFRET < 0
							nVRFRET := nVRFRET * -1
						EndIf
						nVRSEGU := VAL(cIT_VL_SEGURO_RATEADO)
						If nVRSEGU < 0
							nVRSEGU := nVRSEGU * -1
						EndIf						
						nBASPIS := VAL(cIT_BAS_PIS)
						If nBASPIS < 0
							nBASPIS := nBASPIS * -1
						EndIf
						nALQPIS := VAL(cIT_ALIQ_PIS)						
						If nALQPIS < 0
							nALQPIS := nALQPIS * -1
						EndIf
						nVALPIS := VAL(cIT_VRPIS)
						If nVALPIS < 0
							nVALPIS := nVALPIS * -1
						EndIf
						nBASCOF := VAL(cIT_BAS_COF)
						If nBASCOF < 0
							nBASCOF := nBASCOF * -1
						EndIf
						nALQCOF := VAL(cIT_ALIQ_COFINS)
						If nALQCOF < 0
							nALQCOF := nALQCOF * -1
						EndIf
						nVALCOF := VAL(cIT_VRCOFINS)
						If nVALCOF < 0
							nVALCOF := nVALCOF * -1
						EndIf
						
						
						aAdd ( aDADOSDOC[nPOS][34], {	STRZero(Val(cIT_NUMITE),TAMSX3("D1_ITEM")[1]),		;
														ALLTRIM(cIT_CODPROD), 								;
														ALLTRIM(cIT_DESCRICAO),								;
														nQTDEIT,											;
														nPRCUNT,											;
														ALLTRIM(SubSTR(cIT_PEDIDO,1,6)), 					;
														STRZero(Val(cIT_ITEM_PED),TAMSX3("C7_ITEM")[1]),	;
														nVRTTIT,				   							;
														nVRIPIT,   				 							;
														nVRICMS,				 							;
														nPESOIT,		 									;
														nALIQII,				 							;
														nVRFRET,											;
														nVRSEGU,  											;
														ALLTRIM(cIT_NM_NUM_INVOICE),						;
														nBASCOF,  											;
														nALQCOF,  											;
														nVALCOF,  											;
														nBASPIS,  											;
														nALQPIS,  											;
														nVALPIS												})
				
							
						//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
						//ณ Leitura da proxima linha do arquivo texto.                          ณ
						//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		
						nBtLidos2 := fRead(hFILESF1_2,@cBuffer2,nTamLin2)    						
						dbSkip()						
						
	     			Enddo
	

					cSTRING := cDATAHORA + "FIM LEITURA DO ARQUIVO - ITENS: " +CPATHFILES+aARQUIVO2[_nINDARQ] + &(CENDOFFILE)
					conout(cSTRING)
					fWrite(hFILELOG1,cSTRING,Len(cSTRING))


                	//--Ordena registros por empresa + filial
                	aDADOSDOC := aSort(aDADOSDOC,,,{|x,y| x[1]<y[1]})
                	_cODEMPFIL := STRINGNULL
                	
                	For _nIND := 1 to Len(aDADOSDOC)
                	
                		//--Verifica se existe item para o cabecalho
                		If Len(aDADOSDOC[_nIND,34]) == 0

							cSTRING := cDATAHORA + "NAO LOCALIZADO ITENS PARA O CABECALHO: NF_NFID: " + aDADOSDOC[_nIND,30] + " - NF_EMPRESA: "+ aDADOSDOC[_nIND,31] + " - NF_NUMNF: "+ aDADOSDOC[_nIND,32] + " - NF_SERIE: " + aDADOSDOC[_nIND,33] + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
                			Loop
                		
                		EndIf    
                		
                        //--Verifica se jแ existe registro na base
						If fChkIDISYS(cARQUIVO,SubSTR(aDADOSDOC[_nIND,01],1,2),SubSTR(aDADOSDOC[_nIND,01],3,2),aDADOSDOC[_nIND,30])

		                	cSTRING := cDATAHORA + "ERRO REGISTRO Jม EXISTENTE NO PROTHEUS - ID IMPORT SYS: " + aDADOSDOC[_nIND,30] + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
                			Loop
						
						EndIf
		                	                		
                		
                		If _cODEMPFIL != aDADOSDOC[_nIND,01] 
							
							_cODEMPFIL := aDADOSDOC[_nIND,01]
							
							RpcClearEnv()
							RPCSetType(3)
	
				     		PREPARE ENVIRONMENT EMPRESA SubSTR(aDADOSDOC[_nIND,01],1,2) FILIAL SubSTR(aDADOSDOC[_nIND,01],3,2) MODULO "FIN" TABLES "SA2","SED","SE2"
				     		
		                	cSTRING := cDATAHORA + "INCLUSAO DE PRE-NOTA EMPRESA/FILIAL: " + cEmpAnt + "/" + cFilAnt + &(CENDOFFILE)
		                	conout(cSTRING)
		                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
		                	

                		EndIf
                            
                        //--Define n๚mero e serie da pre-nota
                        cNumero := STRINGNULL
                  		cSerie  := SuperGetMV("MV_X_SDIM",,"")
						
						If ALLTRIM(cSerie) == ""
							lRetorno := SX5NumNota(.F.)
							DO WHILE !lRetorno
						    	lRetorno := SX5NumNota(.F.)
						    ENDDO                        
						    cNumero := NxTSx5Nota(cSerie,.F.)
						Else
							cNumero := NxTSx5Nota(cSerie,.F.)
						EndIf    
						
						cINUMDOC := cNumero
						cISERDOC := cSerie 

						/**
							1-EMPRESA/FILIAL, 2-F1_TIPO, 3-F1_EMISSAO, 4-F1_FORNECE, 5-F1_LOJA, 6-F1_VALBRUT, 7-F1_VALMERC,
							8-F1_VALICM, 9-F1_VALIPI, 10-F1_FRETE, 11-F1_SEGURO, 12-F1_DESPESA, 13-F1_BASEICM, 14-F1_BASEIPI,
							15-F1_PESOL, 16-F1_X_TIPTR, 17-F1_X_NAVIO, 18-F1_X_TPFRT, 19-F1_X_TXTHC, 20-F1_X_VLRII, 21-F1_X_NUMDI,
							22-F1_X_TXSIS, 23-F1_X_DATDI, 24-F1_X_DATDE, 25-F1_X_NUMBL, 26-F1_X_UFDI, 27-F1_X_LOCDI, 28-F1_X_MICRT,
							29-F1_X_NUMFT, 30-F1_X_IDSYS, 31-F1_X_PRSYS, 32-F1_X_NDSYS, 33-F1_X_SDSYS, 34-ITENS NF
						**/
							
						aCabec := {}
						aadd(aCabec,{"F1_TIPO"   	, IIF(aDADOSDOC[_nIND,02]=="NE","N","C")	})
						aadd(aCabec,{"F1_FORMUL" 	, "S"										})
						aadd(aCabec,{"F1_DOC"    	, cINUMDOC									})
						aadd(aCabec,{"F1_SERIE"  	, cISERDOC									})
						aadd(aCabec,{"F1_EMISSAO"	, aDADOSDOC[_nIND,03]						})
						aadd(aCabec,{"F1_FORNECE"	, aDADOSDOC[_nIND,04]						})
						aadd(aCabec,{"F1_LOJA"   	, aDADOSDOC[_nIND,05]						})
						aadd(aCabec,{"F1_ESPECIE"	, "SPED"									})
						aadd(aCabec,{"F1_VALBRUT"	, aDADOSDOC[_nIND,06]						})
						aadd(aCabec,{"F1_VALMERC"	, aDADOSDOC[_nIND,07]						})
						aadd(aCabec,{"F1_VALICM"	, aDADOSDOC[_nIND,08]						})
						aadd(aCabec,{"F1_VALIPI"	, aDADOSDOC[_nIND,09]						})
						aadd(aCabec,{"F1_FRETE"		, aDADOSDOC[_nIND,10]						})
						aadd(aCabec,{"F1_SEGURO"	, aDADOSDOC[_nIND,11]						})
						aadd(aCabec,{"F1_DESPESA"	, aDADOSDOC[_nIND,12]						})
						aadd(aCabec,{"F1_BASEICM"	, aDADOSDOC[_nIND,13]						})
						aadd(aCabec,{"F1_BASEIPI"	, aDADOSDOC[_nIND,14]						})
						aadd(aCabec,{"F1_PESOL"		, aDADOSDOC[_nIND,15]						})						
						aadd(aCabec,{"F1_X_TIPTR"	, aDADOSDOC[_nIND,16]						})
						aadd(aCabec,{"F1_X_NAVIO"	, aDADOSDOC[_nIND,17]						})
						aadd(aCabec,{"F1_X_TPFRT"	, IIF(aDADOSDOC[_nIND,18]=="E","A","P")		})
						aadd(aCabec,{"F1_X_TXTHC"	, aDADOSDOC[_nIND,19]						})
						aadd(aCabec,{"F1_X_VLRII"	, aDADOSDOC[_nIND,20]						})
						aadd(aCabec,{"F1_X_NUMDI"	, aDADOSDOC[_nIND,21]						})
						aadd(aCabec,{"F1_X_TXSIS"	, aDADOSDOC[_nIND,22]						})
						aadd(aCabec,{"F1_X_DATDI"	, STOD(aDADOSDOC[_nIND,23])					})
						aadd(aCabec,{"F1_X_DATDE"	, STOD(aDADOSDOC[_nIND,24])					})
						aadd(aCabec,{"F1_X_NUMBL"	, aDADOSDOC[_nIND,25]						})
						aadd(aCabec,{"F1_X_UFDI"	, aDADOSDOC[_nIND,26]						})
						aadd(aCabec,{"F1_X_LOCDI"	, aDADOSDOC[_nIND,27]						})
						aadd(aCabec,{"F1_X_MICRT"	, aDADOSDOC[_nIND,28]						})
						aadd(aCabec,{"F1_X_IDSYS"	, aDADOSDOC[_nIND,30]						})
						aadd(aCabec,{"F1_X_PRSYS"	, aDADOSDOC[_nIND,31]						})
						aadd(aCabec,{"F1_X_NDSYS"	, aDADOSDOC[_nIND,32]						})
						aadd(aCabec,{"F1_X_SDSYS"	, aDADOSDOC[_nIND,33]						})
						aadd(aCabec,{"F1_X_MARME"	, aDADOSDOC[_nIND,35]						})						
						aadd(aCabec,{"F1_X_ANTID"	, aDADOSDOC[_nIND,36]						})	  
											
						

	                	cSTRING := cDATAHORA + "EXECAUTO - CABECALHO DOCUMENTO DE ENTRADA - DOC: "+cINUMDOC+" SERIE: "+cISERDOC+" FORNECEDOR/LOJA: "+aDADOSDOC[_nIND,04]+"/"+aDADOSDOC[_nIND,05]+ &(CENDOFFILE)
	                	conout(cSTRING)
	                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
			
				        
						aItens := {}

                        If Len(aDADOSDOC[_nIND,34]) > 0
                            
                            aadd(aCabec,{"F1_X_NUMFT"	, aDADOSDOC[_nIND,34][01,15]			})
                            
                            For _nINDIT := 1 to Len(aDADOSDOC[_nIND,34])

								dbSelectArea("SC7")
								dbSetOrder(1)
								If dbSeek( SubSTR(aDADOSDOC[_nIND,01],3,4) + aDADOSDOC[_nIND,34][_nINDIT,06] + aDADOSDOC[_nIND,34][_nINDIT,07] )
								
									dbSelectArea("SB1")
									dbSetOrder(1)
									dbSeek(xFilial("SB1")+ALLTRIM(aDADOSDOC[_nIND,34][_nINDIT,02]) )
									
									If RecLock("SC7",.F.)
					          SC7->C7_TXMOEDA := aDADOSDOC[_nIND,37]
          					SC7->(MsUnLock())
         					EndIf       
									
									aLinha := {}
									aadd(aLinha,{"D1_ITEM"  	, aDADOSDOC[_nIND,34][_nINDIT,01]	, nil	})
									aadd(aLinha,{"D1_COD"  		, aDADOSDOC[_nIND,34][_nINDIT,02]	, nil	})
									aadd(aLinha,{"D1_DESCRI"	, SB1->B1_DESC						, nil	})
									aadd(aLinha,{"D1_QUANT"  	, aDADOSDOC[_nIND,34][_nINDIT,04]	, nil	})
									aadd(aLinha,{"D1_VUNIT"  	, aDADOSDOC[_nIND,34][_nINDIT,05]	, nil	})
									aadd(aLinha,{"D1_PEDIDO"  	, aDADOSDOC[_nIND,34][_nINDIT,06]	, nil	})
									aadd(aLinha,{"D1_ITEMPC"  	, aDADOSDOC[_nIND,34][_nINDIT,07]	, nil	})
									aadd(aLinha,{"D1_VALOR"  	, aDADOSDOC[_nIND,34][_nINDIT,08]	, nil	})
									aadd(aLinha,{"D1_VALIPI"  	, aDADOSDOC[_nIND,34][_nINDIT,09]	, nil	})
									aadd(aLinha,{"D1_VALICM"  	, aDADOSDOC[_nIND,34][_nINDIT,10]	, nil	})
									aadd(aLinha,{"D1_PESO"		, aDADOSDOC[_nIND,34][_nINDIT,11]	, nil	})
									aadd(aLinha,{"D1_ALIQII"	, aDADOSDOC[_nIND,34][_nINDIT,12]	, nil	})
									aadd(aLinha,{"D1_VALFRE"	, aDADOSDOC[_nIND,34][_nINDIT,13]	, nil	})
									aadd(aLinha,{"D1_SEGURO"	, aDADOSDOC[_nIND,34][_nINDIT,14]	, nil	})
									aadd(aLinha,{"D1_TES"		, SC7->C7_TES			 			, nil	})	
									aadd(aLinha,{"D1_CLVL"		, SC7->C7_CLVL 						, nil	})
									aadd(aLinha,{"D1_CC"		, SC7->C7_CC  						, nil	})
									aadd(aLinha,{"D1_CONTA"		, SC7->C7_CONTA  					, nil	})
									aadd(aLinha,{"D1_ITEMCTA"	, SC7->C7_ITEMCTA 					, nil	})
									aadd(aLinha,{"D1_BASIMP5"	, aDADOSDOC[_nIND,34][_nINDIT,16]	, nil	})
									aadd(aLinha,{"D1_ALQIMP5"	, aDADOSDOC[_nIND,34][_nINDIT,17]	, nil	})
									aadd(aLinha,{"D1_VALIMP5"	, aDADOSDOC[_nIND,34][_nINDIT,18]	, nil	})
									aadd(aLinha,{"D1_BASIMP6"	, aDADOSDOC[_nIND,34][_nINDIT,19]	, nil	})
									aadd(aLinha,{"D1_ALQIMP6"	, aDADOSDOC[_nIND,34][_nINDIT,20]	, nil	})
									aadd(aLinha,{"D1_VALIMP6"	, aDADOSDOC[_nIND,34][_nINDIT,21]	, nil	})
									
									aadd(aItens,aLinha)

				                	cSTRING := cDATAHORA + "EXECAUTO - ITENS DOCUMENTO DE ENTRADA - ITEM: "+aDADOSDOC[_nIND,34][_nINDIT,01]+" PRODUTO: "+aDADOSDOC[_nIND,34][_nINDIT,02]+" QUANTIDADE: "+cValToChar(aDADOSDOC[_nIND,34][_nINDIT,04])+" PEDIDO/ITEM: "+aDADOSDOC[_nIND,34][_nINDIT,06]+"/"+aDADOSDOC[_nIND,34][_nINDIT,07]+ &(CENDOFFILE)
				                	conout(cSTRING)
				                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
			

								Else
				
				                	cSTRING := cDATAHORA + "NAO FOI LOCALIZADO PEDIDO DE COMPRAS FILIAL/NUMERO/ITEM: "+SubSTR(aDADOSDOC[_nIND,01],3,4)+"/"+aDADOSDOC[_nIND,34][_nINDIT,06]+"/"+aDADOSDOC[_nIND,34][_nINDIT,07]+" - PARCEIRO: " + cNF_CLIFOR + &(CENDOFFILE)
				                	conout(cSTRING)
				                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))
								
								EndIf
																		
							Next _nINDIT    
												
						EndIf
							
						
						If Len(aCabec) > 0 .and. Len(aItens) > 0  
							
							lMsErroAuto := .F.
							MsExecAuto({|x,y,z|Mata140(x,y,z)},aCabec,aItens,3)
						
							If lMsErroAuto     
							
			                	cSTRING := cDATAHORA + "ERRO INCLUSAO DOCUMENTO ENTRADA/SERIE: " + cINUMDOC + "/" + cISERDOC + " - NF_NFID: " + aDADOSDOC[_nIND,30] + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))	

			                	cSTRING := MostraErro()
			                	conout(cSTRING)
			                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))	
							
							Else
			                
			                	cSTRING := cDATAHORA + "OK INCLUSAO DOCUMENTO ENTRADA/SERIE: " + cINUMDOC + "/" + cISERDOC + " - NF_NFID: " + aDADOSDOC[_nIND,30] + &(CENDOFFILE)
			                	conout(cSTRING)
			                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
							
							EndIf 
						
						EndIf
																									
				    Next _nIND
                    
				Else

                	cSTRING := cDATAHORA + "NAO FORAM LOCALIZADOS CABECALHO DE DOCUMENTOS." + &(CENDOFFILE)
                	conout(cSTRING)
                	fWrite(hFILELOG1,cSTRING,Len(cSTRING))								
				
				EndIf
			
				cSTRING := cDATAHORA + "FIM LEITURA DO ARQUIVO - CABECALHO: " +CPATHFILES+aARQUIVO1[_nINDARQ] + &(CENDOFFILE)
				conout(cSTRING)
				fWrite(hFILELOG1,cSTRING,Len(cSTRING))

			EndIf
				
	    	//-- Fecha arquivos.	
	    	fClose(hFILESF1_1)
	    	fClose(hFILESF1_2)
	    	fClose(hFILELOG1)	    	
	    	
	    	//-- Renomeia o arquivo processado.
	    	fRename(CPATHFILES+aARQUIVO1[_nINDARQ] , CPATHFILES+"OK_"+aARQUIVO1[_nINDARQ] )
	    	fRename(CPATHFILES+aARQUIVO2[_nINDARQ] , CPATHFILES+"OK_"+aARQUIVO2[_nINDARQ] )

	
    	Next _nINDARQ
	                          
	EndIf 
	
	CONOUT(TIME()+"-SF1-FIM IMPORTACAO DE PRE-NOTAS.")

Return




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfBegFile    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณInicializa็ใo do arquivo texto.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*---------------------------------------*
Static Function fBegFile(cARQUIVO)               
*---------------------------------------*
Local lRet  := .T.
Local cHORA := STRTRAN(TIME(),":","")

Local cNOMESE4_1 := CPATHFILES + CFILESE4_1 + dtos(Date()) + cHORA + ".TXT"

Local cNOMESB1_1 := CPATHFILES + CFILESB1_1 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESB1_2 := CPATHFILES + CFILESB1_2 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESB1_3 := CPATHFILES + CFILESB1_3 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESB1_4 := CPATHFILES + CFILESB1_4 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESB1_5 := CPATHFILES + CFILESB1_5 + dtos(Date()) + cHORA + ".TXT"

Local cNOMESA1_1 := CPATHFILES + CFILESA1_1 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESA1_2 := CPATHFILES + CFILESA1_2 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESA1_3 := CPATHFILES + CFILESA1_3 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESA1_4 := CPATHFILES + CFILESA1_4 + dtos(Date()) + cHORA + ".TXT"

Local cNOMESC7_1 := CPATHFILES + CFILESC7_1 + dtos(Date()) + cHORA + ".TXT"
Local cNOMESC7_2 := CPATHFILES + CFILESC7_2 + dtos(Date()) + cHORA + ".TXT"


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Cria o arquivo texto                                                ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If cARQUIVO == "SE4" 
		hFILESE4_1 := fCreate(cNOMESE4_1)	
		If hFILESE4_1 == -1
		    Return (.F.)
		Endif
	
	ElseIf cARQUIVO == "SB1"
		hFILESB1_1 := fCreate(cNOMESB1_1)	
		If hFILESB1_1 == -1
		    Return (.F.)
		Endif
		hFILESB1_2 := fCreate(cNOMESB1_2)	
		If hFILESB1_2 == -1
		    Return (.F.)
		Endif
		hFILESB1_3 := fCreate(cNOMESB1_3)	
		If hFILESB1_3 == -1
		    Return (.F.)
		Endif
		hFILESB1_4 := fCreate(cNOMESB1_4)	
		If hFILESB1_4 == -1
		    Return (.F.)
		Endif
		hFILESB1_5 := fCreate(cNOMESB1_5)	
		If hFILESB1_5 == -1
		    Return (.F.)
		Endif

	ElseIf cARQUIVO == "SA1"
		hFILESA1_1 := fCreate(cNOMESA1_1)	
		If hFILESA1_1 == -1
		    Return (.F.)
		Endif
		hFILESA1_2 := fCreate(cNOMESA1_2)	
		If hFILESA1_2 == -1
		    Return (.F.)
		Endif
		hFILESA1_3 := fCreate(cNOMESA1_3)	
		If hFILESA1_3 == -1
		    Return (.F.)
		Endif
		hFILESA1_4 := fCreate(cNOMESA1_4)	
		If hFILESA1_4 == -1
		    Return (.F.)
		Endif

	ElseIf cARQUIVO == "SC7"
		hFILESC7_1 := fCreate(cNOMESC7_1)	
		If hFILESC7_1 == -1
		    Return (.F.)
		Endif
		hFILESC7_2 := fCreate(cNOMESC7_2)	
		If hFILESC7_2 == -1
		    Return (.F.)
		Endif
	EndIf
	
	
Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfWrtFile    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEscreve no arquivo texto.                                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function fWrtFile(cLin,hFILE)           
*---------------------------------------*
Local lRet := .T.
Local cSTR := cLin
	
	cSTR := cSTR + chr(13)+chr(10)
	
   	If fWrite(hFILE,cSTR,Len(cSTR)) != Len(cSTR)
   		Return (.F.)
   	EndIf
	
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfEndFile    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFinaliza็ใo do arquivo texto.                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
Static Function fEndFile(cARQUIVO)
*---------------------------------------*

	If cARQUIVO == "SE4" 
		fClose(hFILESE4_1)
	ElseIf cARQUIVO == "SB1"
		fClose(hFILESB1_1)
		fClose(hFILESB1_2)
		fClose(hFILESB1_3)
		fClose(hFILESB1_4)
		fClose(hFILESB1_5)
	ElseIf cARQUIVO == "SA1"
		fClose(hFILESA1_1)
		fClose(hFILESA1_2)
		fClose(hFILESA1_3)
		fClose(hFILESA1_4)
	ElseIf cARQUIVO == "SC7"
		fClose(hFILESC7_1)
		fClose(hFILESC7_2)
	EndIf
	
Return 




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJCFSYS     บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de c๓pia de arquivos entre servidores Protheus e     บฑฑ
ฑฑบ          ณImport SYS. Deverแ ser realizado schedule do smartclient no บฑฑ
ฑฑบ          ณservidor do Import SYS, com a seguinte configura็ใo:        บฑฑ
ฑฑบ          ณ..\SMARTCLIENT.EXE -P=U_RJCFSYS -E=Protheus10 -C=externo2   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------*
User Function RJCFSYS()
*---------------------------------------*
Local aFSERVER := {}
Local aFCLIENT := {}

        
	CONOUT("RJCFSYS-INICIO COPIA DE ARQUIVOS.")
	                                  
	//--C๓pia de interfaces de saida
	
	For nINDFILE := 1 to 12	//--N๚mero de intercaces de saida
		
		aFSERVER := {}
		
		Do case
			case nINDFILE == 1	
				aDir(CPATHFILES+CFILESE4_1+"*.txt", aFSERVER )
			case nINDFILE == 2
				aDir(CPATHFILES+CFILESB1_1+"*.txt", aFSERVER )
			case nINDFILE == 3	
				aDir(CPATHFILES+CFILESB1_2+"*.txt", aFSERVER )
			case nINDFILE == 4	
				aDir(CPATHFILES+CFILESB1_3+"*.txt", aFSERVER )
			case nINDFILE == 5	
				aDir(CPATHFILES+CFILESB1_4+"*.txt", aFSERVER ) 
			case nINDFILE == 6	
				aDir(CPATHFILES+CFILESB1_5+"*.txt", aFSERVER )	
			case nINDFILE == 7	
				aDir(CPATHFILES+CFILESA1_1+"*.txt", aFSERVER )
			case nINDFILE == 8	
				aDir(CPATHFILES+CFILESA1_2+"*.txt", aFSERVER )
			case nINDFILE == 9	
				aDir(CPATHFILES+CFILESA1_3+"*.txt", aFSERVER )
			case nINDFILE == 10	
				aDir(CPATHFILES+CFILESA1_4+"*.txt", aFSERVER )
			case nINDFILE == 11	
				aDir(CPATHFILES+CFILESC7_1+"*.txt", aFSERVER )
			case nINDFILE == 12	
				aDir(CPATHFILES+CFILESC7_2+"*.txt", aFSERVER )	
		EndCase
					
		If Len(aFSERVER) > 0		
			For nI := 1 to Len(aFSERVER)
				CONOUT("RJCFSYS-PROCESSANDO ARQUIVO PROTHEUS:" + CPATHFILES+aFSERVER[nI])
				nHld := fOpen(CPATHFILES+aFSERVER[nI], FO_READWRITE )
				If nHld != -1
					fClose(nHld)
					CpyS2T( CPATHFILES+aFSERVER[nI], CPATHARQEX, .F. )
					FRENAME( CPATHFILES+aFSERVER[nI], SubSTR(CPATHFILES+aFSERVER[nI],1,Len(CPATHFILES+aFSERVER[nI])-3)+"COPIADO" )
					CONOUT("RJCFSYS-ARQUIVO COPIADO E RENOMEADO: "+CPATHFILES+aFSERVER[nI])
				Else
					CONOUT("RJCFSYS-ARQUIVO NAO PODE SER COPIADO E RENOMEADO: "+CPATHFILES+aFSERVER[nI])
				EndIf
				
			Next nI
		EndIf    
	
	Next nINDFILE

	
	//--C๓pia de interfaces de entrada    
	
	For nINDFILE := 1 to 5	//--N๚mero de interfaces de entrada
		
		aFCLIENT := {}
		
		Do case
			case nINDFILE == 1
				aDir(UPPER(CPATHARQIM+CFILESE2_1+"*.txt"), aFCLIENT )
			case nINDFILE == 2
				aDir(UPPER(CPATHARQIM+CFILESE2_2+"*.txt"), aFCLIENT )
			case nINDFILE == 3
				aDir(UPPER(CPATHARQIM+CFILESE2_3+"*.txt"), aFCLIENT )
			case nINDFILE == 4
				aDir(UPPER(CPATHARQIM+CFILESF1_1+"*.txt"), aFCLIENT )
			case nINDFILE == 5
				aDir(UPPER(CPATHARQIM+CFILESF1_2+"*.txt"), aFCLIENT )
		EndCase
			
		If Len(aFCLIENT) > 0
			For nI := 1 to Len(aFCLIENT)                                                 
				CONOUT("RJCFSYS-PROCESSANDO ARQUIVO IMPORTSYS:" + CPATHARQIM+aFCLIENT[nI] )
				nHld := fOpen(CPATHARQIM+aFCLIENT[nI], FO_READWRITE )
				If nHld != -1
					fClose(nHld)
					CpyT2S( CPATHARQIM+aFCLIENT[nI], CPATHFILES )
					FRENAME( CPATHARQIM+aFCLIENT[nI], SubSTR(CPATHARQIM+aFCLIENT[nI],1,Len(CPATHARQIM+aFCLIENT[nI])-3)+"COPIADO" )
					CONOUT("RJCFSYS-ARQUIVO COPIADO E RENOMEADO: "+CPATHARQIM+aFCLIENT[nI])
				Else
					CONOUT("RJCFSYS-ARQUIVO NAO PODE SER COPIADO E RENOMEADO: "+CPATHARQIM+aFCLIENT[nI])
				EndIf
			Next nI
		EndIf
	
	Next nINDFILE
	
	CONOUT("RJCFSYS-FIM COPIA DE ARQUIVOS.")
	

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetNextParcบAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo de retorno da parcela do tํtulo.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*----------------------------------------------------------------*
Static Function fGetNextParc(cEMPR,cFILI,cPREF,cNUME,cTIPO)
*----------------------------------------------------------------*
Local cAliasSE2 := GetNextAlias()
Local cPARCELA  := STRINGNULL

	cQuery := " SELECT MAX(E2_PARCELA) E2_PARCELA	"+chr(10)+chr(13)
	cQuery += " FROM SE2"+cEMPR+"0					"+chr(10)+chr(13)
	cQuery += " WHERE	E2_FILIAL  = '"+cFILI+"'	"+chr(10)+chr(13)
	cQuery += " AND 	E2_PREFIXO = '"+cPREF+"'	"+chr(10)+chr(13)	
	cQuery += " AND 	E2_NUM	   = '"+cNUME+"'	"+chr(10)+chr(13)	
	cQuery += " AND 	E2_TIPO	   = '"+cTIPO+"'	"+chr(10)+chr(13)	
	cQuery += " AND		D_E_L_E_T_ != '*'			"+chr(10)+chr(13)

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSE2)                                                                 
	
	dbSelectArea(cAliasSE2)
	(cAliasSE2)->(dbGoTop())
    If !(cAliasSE2)->(EOF())                          
    	cPARCELA := STRZero(Val((cAliasSE2)->E2_PARCELA)+1,TAMSX3("E2_PARCELA")[1])
    Else
    	cPARCELA := STRZero(1,TAMSX3("E2_PARCELA")[1])
    EndIf
    (cAliasSE2)->(dbCloseArea())
 
Return (cPARCELA)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfChkIDISYS  บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por verificar se o registro jแ foi impor-บฑฑ
ฑฑบ          ณtado no Protheus.                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                
*----------------------------------------------------------------*
Static Function fChkIDISYS(cARQU,cEMPR,cFILI,cCHAV)               
*----------------------------------------------------------------*
Local lRet := .F.
Local cAliasSYS := GetNextAlias()

	If cARQU == "SE2"

		cQuery := " SELECT E2_X_IDSYS IDSYS				"+chr(10)+chr(13)
		cQuery += " FROM SE2"+cEMPR+"0					"+chr(10)+chr(13)
		cQuery += " WHERE	E2_FILIAL  = '"+cFILI+"'	"+chr(10)+chr(13)
		cQuery += " AND 	E2_X_IDSYS = '"+cCHAV+"'	"+chr(10)+chr(13)	
		cQuery += " AND		D_E_L_E_T_ != '*'			"+chr(10)+chr(13)
	
	Else
	
		cQuery := " SELECT F1_X_IDSYS IDSYS				"+chr(10)+chr(13)
		cQuery += " FROM SF1"+cEMPR+"0					"+chr(10)+chr(13)
		cQuery += " WHERE	F1_FILIAL  = '"+cFILI+"'	"+chr(10)+chr(13)
		cQuery += " AND 	F1_X_IDSYS = '"+cCHAV+"'	"+chr(10)+chr(13)	
		cQuery += " AND		D_E_L_E_T_ != '*'			"+chr(10)+chr(13)

	EndIf

	TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasSYS)                                                                 
	
	dbSelectArea(cAliasSYS)
	(cAliasSYS)->(dbGoTop())
    If !(cAliasSYS)->(EOF())                          
    	If !Empty( (cAliasSYS)->IDSYS )
    		lRet := .T.
    	EndIf
    EndIf
    (cAliasSYS)->(dbCloseArea())
	             
Return (lRet)




/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfUpdESYS    บAutor  ณRafael Parma      บ Data ณ  31/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por atualizar o registro como exportado  บฑฑ
ฑฑบ          ณao Import SYS.                                              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                
*----------------------------------------------------------------*
Static Function fUpdESYS(cARQUIVO,nRECARQ)               
*----------------------------------------------------------------*

	cSqlUPD := " UPDATE " + RetSQLName(cARQUIVO) + " SET "+SubSTR(cARQUIVO,2,2)+"_X_ESYS = ' ' WHERE R_E_C_N_O_ = "+cValToChar(nRECARQ)
	TCSQLEXEC(cSqlUPD)
	
Return
                                                                  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfGetNAT     บAutor  ณRafael Parma      บ Data ณ  24/11/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por recuperar a natureza do tํtulo.      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณCANTU                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/                                                                
*----------------------------------------------------------------*
Static Function fGetNAT(cDESPESA)
*----------------------------------------------------------------*
Local cNAT := SuperGetMV("MV_X_ICNAT",,"2015032")
Local aDADOS := {}

	aAdd ( aDADOS, {"Ad. Tarif. Aeroport.",		"2015032"} )
	aAdd ( aDADOS, {"Anแlise de LI",			"2015032"} )
	aAdd ( aDADOS, {"ANTECIPAวรO ICMS",	   		"2013002"} )
	aAdd ( aDADOS, {"Antidumping",				"2015032"} )
	aAdd ( aDADOS, {"Armaz Marit 1",			"2015032"} )
	aAdd ( aDADOS, {"Armaz Z SEC 1",			"2015032"} )
	aAdd ( aDADOS, {"Armaz Aerea Mult 1",		"2015032"} )
	aAdd ( aDADOS, {"Armaz Aerea Mult 2",		"2015032"} )
	aAdd ( aDADOS, {"Armazem Geral",			"2015032"} )
	aAdd ( aDADOS, {"Armazenagem 1",			"2015032"} )
	aAdd ( aDADOS, {"Armazenagem 2",			"2015032"} )
	aAdd ( aDADOS, {"Autentic Documentos",		"2015032"} )
	aAdd ( aDADOS, {"Avaria de Container",		"2015032"} )
	aAdd ( aDADOS, {"Capatazia",				"2015032"} )
	aAdd ( aDADOS, {"Carregamento",				"2015032"} )
	aAdd ( aDADOS, {"Cert Fumiga็ใo",			"2015032"} )
	aAdd ( aDADOS, {"CIF",						"2015032"} )	//--nใo definido
	aAdd ( aDADOS, {"COFINS Devido",			"2015032"} )
	aAdd ( aDADOS, {"COFINS Importa็ใo",		"2015032"} )
	aAdd ( aDADOS, {"Collect Free",		  		"2015032"} )
	aAdd ( aDADOS, {"Com. Despachante",	 		"2015032"} )
	aAdd ( aDADOS, {"Com. Emissใo LI",			"2015032"} )
	aAdd ( aDADOS, {"Consultoria T้cnica",		"2015032"} )
	aAdd ( aDADOS, {"Contrato de Cambio",		"2015032"} )
	aAdd ( aDADOS, {"Custos Coleta",			"2015032"} )
	aAdd ( aDADOS, {"Dedu็๕es",			  		"2015032"} )	//--nใo definido
	aAdd ( aDADOS, {"Delivery Free",			"2015032"} )
	aAdd ( aDADOS, {"Demurrage",				"2015032"} )
	aAdd ( aDADOS, {"Desp Origem",				"2015032"} )
	aAdd ( aDADOS, {"Desunitiza็ใo",			"2015032"} )
	aAdd ( aDADOS, {"Desunitiza็ใo MECANI",		"2015032"} )
	aAdd ( aDADOS, {"Detention Origem",	   		"2015032"} )
	aAdd ( aDADOS, {"Devolu็ใo CTNR",			"2015032"} )
	aAdd ( aDADOS, {"Diverg Peso",				"2015032"} )
	aAdd ( aDADOS, {"DTAS",				   		"2015032"} )
	aAdd ( aDADOS, {"Escolta",					"2015032"} )
	aAdd ( aDADOS, {"FOB",						"2015032"} )	//--nใo definido
	aAdd ( aDADOS, {"Frete Agente Carga",		"2015032"} )
	aAdd ( aDADOS, {"Frete Complementar",		"2015032"} )
	aAdd ( aDADOS, {"Frete Inter. Collect",		"2015032"} )
	aAdd ( aDADOS, {"Frete Inter. Prepaid",		"2015032"} )
	aAdd ( aDADOS, {"Frete Internacional",		"2015032"} )
	aAdd ( aDADOS, {"Frete Local",				"2015032"} )
	aAdd ( aDADOS, {"Frete Remo็ใo",			"2015032"} )
	aAdd ( aDADOS, {"Frete Rodoviแrio",	   		"2015032"} )
	aAdd ( aDADOS, {"Fumiga็ใo",				"2015032"} )
	aAdd ( aDADOS, {"ICMS",				   		"2015032"} )
	aAdd ( aDADOS, {"ICMS Complementar",		"2015032"} )
	aAdd ( aDADOS, {"ICMS Devido",				"2015032"} )
	aAdd ( aDADOS, {"II",						"2015032"} )
	aAdd ( aDADOS, {"II Complementar",			"2015032"} )
	aAdd ( aDADOS, {"II Devido",				"2015032"} )
	aAdd ( aDADOS, {"Incinera็ใo",				"2015032"} )
	aAdd ( aDADOS, {"IPI",				  		"2015032"} )
	aAdd ( aDADOS, {"IPI Complementar",			"2015032"} )
	aAdd ( aDADOS, {"IPI Devido",				"2015032"} )
	aAdd ( aDADOS, {"ISPS",				   		"2015032"} )
	aAdd ( aDADOS, {"Lavagem de Container",		"2015032"} )
	aAdd ( aDADOS, {"Levante",					"2015032"} )
	aAdd ( aDADOS, {"Levante EADI",		   		"2015032"} )
	aAdd ( aDADOS, {"Marinha Mercante",	   		"2015032"} )
	aAdd ( aDADOS, {"Monitoramento Eletri",		"2015032"} )
	aAdd ( aDADOS, {"Multa (outros)",			"2013056"} )
	aAdd ( aDADOS, {"Multa LI Posterior",		"2013056"} )
	aAdd ( aDADOS, {"Outras Despesas",			"2015032"} )
	aAdd ( aDADOS, {"Outro Acr้scimo",			"2015032"} )
	aAdd ( aDADOS, {"Pesagem",					"2015032"} )
	aAdd ( aDADOS, {"PIS Devido",				"2015032"} )
	aAdd ( aDADOS, {"PIS Importa็ใo",			"2015032"} )
	aAdd ( aDADOS, {"Posicionamento",			"2015032"} )
	aAdd ( aDADOS, {"DAS",						"2015032"} )
	aAdd ( aDADOS, {"Seguro Intern.",			"2015032"} )
	aAdd ( aDADOS, {"Separa็ใo",				"2015032"} )
	aAdd ( aDADOS, {"Taxa de Libera็ใo",		"2015032"} )
	aAdd ( aDADOS, {"Taxa de Desconsolida็ใo",	"2015032"} )
	aAdd ( aDADOS, {"Taxa Emissใo DI",			"2015032"} )
	aAdd ( aDADOS, {"Taxa Emissใo LI",			"2015032"} )
	aAdd ( aDADOS, {"Taxas Courier",			"2015032"} )
	aAdd ( aDADOS, {"Tx Agente de Carga",		"2015032"} )
	aAdd ( aDADOS, {"Valor aduaneiro",			"2015032"} )	//--nใo definido
	
	nPOS := aScan ( aDADOS, {|x| x[1] == ALLTRIM(cDESPESA) } )
	
	If nPOS != 0
		If ALLTRIM(aDADOS[nPOS,02]) != ""
			cNAT := aDADOS[nPOS,02]
		EndIf
	EndIf    
	         
	cNAT := cNAT + Space( TAMSX3("ED_CODIGO")[1]-Len(cNAT) )


Return (cNAT)