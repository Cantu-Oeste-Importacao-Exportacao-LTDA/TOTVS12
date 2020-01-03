#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"  
#include "tbiconn.ch"

#DEFINE CDATAINI "20110101"                  // Faixa de data inicial
#DEFINE CDATAFIM "20491231"                  // Faixa de data final

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³UNISE1    ºAutor  ³Jean Saggin         º Data ³  06/08/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Rotina para geração em excel dos títulos do receber e      º±±
±±º          ³ do pagar.                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Financeiro                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß 
+-------------------------------------------+-----------+-----------+--------+
!   Descricao detalhada da atualizacao      !  Nome do  ! Analista  !Data da !
!                                           !Solicitante! Respons.  !Atualiz.!
+-------------------------------------------+-----------+-----------+--------+
! alterado para criar schedule	            !    	    ! jair matos!30/08/13!
+-------------------------------------------+-----------+-----------+--------+

*/
*---------------------*
User function UniSE1()
*---------------------*

Static oDlg
Static oButton1
Static cGetCam:='\financeiro\'
Static oGetCaminho 
Static cGetCaminho := Space(200)
Static oGetDtFim
Static dGetDtFim := StoD(CDATAFIM)
Static oGetDtIni
Static dGetDtIni := StoD(CDATAINI)
Static oSay1
Static oSay2
Static oSay3
Static oComboBox1
Static cTabela:=""
Private lWeb := .F.  


//VERIFICA SE ESTA RODANDO VIA MENU OU SCHEDULE
If Select("SX6") == 0
	
	conout("UNISE1-INICIO SEM INTERFACE.") 
	lEnd:="" 
	cData:=dtos(date())
	cTime := TIME() // Resultado: 10:00:00
	cHora := SUBSTR(cTime, 1, 2) // Resultado: 10
	cMinutos := SUBSTR(cTime, 4, 2) // Resultado: 37
	lWeb := .T.
	RpcSetType(3)
 	Prepare Environment Empresa "40" Filial "01" MODULO "FIN"	
 	
 	conout("UNISE1-CHAMADA DA FUNCAO PARA TITULOS A RECEBER.") 
	GravaCSV(lEnd, cGetCam+"CTAREC_"+cData+cHora+cMinutos, dGetDtIni, dGetDtFim, "1")
	
	conout("UNISE1-CHAMADA DA FUNCAO PARA TITULOS A PAGAR.") 
 	GravaCSV(lEnd, cGetCam+"CTAPAG_"+cData+cHora+cMinutos, dGetDtIni, dGetDtFim, "2") 
 	
 	conout("UNISE1-FIM SEM INTERFACE.") 
 	RESET ENVIRONMENT
 	
 	Return
EndIf

conout("UNISE1-INICIO COM INTERFACE.") 
DEFINE MSDIALOG oDlg TITLE "Unifica Tabela de Títulos" FROM 000, 000  TO 160, 500 COLORS 0, 16777215 PIXEL

@ 013, 052 MSGET oGetCaminho VAR cGetCaminho SIZE 171, 010  OF oDlg COLORS 0, 16777215  PIXEL
@ 014, 004 SAY oSay1 PROMPT "Caminho Arquivo" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 034, 052 MSGET oGetDtIni VAR dGetDtIni SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 036, 005 SAY oSay2 PROMPT "Data Contabil Ini." SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 034, 179 MSGET oGetDtFim VAR dGetDtFim SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
@ 036, 129 SAY oSay3 PROMPT "Data Contabil Fim" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 054, 005 MSCOMBOBOX oComboBox1 VAR cTabela ITEMS {"1=Contas a Receber","2=Contas a Pagar"} SIZE 072, 010 OF oDlg COLORS 0, 16777215 PIXEL
DEFINE SBUTTON oButton1 FROM 054, 210 TYPE 01 ACTION (RptStatus({|lEnd| GravaCSV(@lEnd, cGetCaminho, dGetDtIni, dGetDtFim, cTabela) }, "Aguarde...","Exportando para Excel...", .T.),;
Close(oDlg)) OF oDlg ENABLE
@ 015, 226 SAY oSay4 PROMPT ".csv" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL

ACTIVATE MSDIALOG oDlg CENTERED

Return

*------------------------------------------------------------------------*
Static Function GravaCSV(lEnd, cCaminho, dDataIni, dDataFim, cTabela)
*------------------------------------------------------------------------*

Local cQuery   := ""
Local aEmp     := {}
Local aArea    := SM0->(GetArea('SM0'))
Local cCrLf 	 := Chr(13) + Chr(10)
Local oExcelApp
Local nHandle
Local nCnt := 0
Local aHeader  := {}
Local aFields  := {}
Local cAlias := ""
Local cStr := ""


if cTabela == "1"
	aFields := {"E1_MSEMP", "E1_FILIAL", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_TIPO", "E1_NATUREZ", ;
	"E1_PORTADO", "E1_VALOR", "E1_SALDO", "E1_MULTA", "E1_CLVLCR", "E1_CCC", "E1_CLIENTE", "E1_NOMCLI",;
	"E1_LOJA", "E1_EMISSAO", "E1_EMIS1", "E1_VENCREA", "E1_BAIXA", "E1_DESCONT", "E1_DECRESC", "E1_SITUACA",;
	"E1_AGEDEP","E1_CONTA","E1_MOEDA","E1_NUMBOR","E1_DATABOR","E1_MULTNAT","E1_VEND1","E1_HIST"}
	cAlias := "SE1"
Else
	aFields := {"E1_MSEMP", "E2_FILIAL", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_NATUREZ",;
	"E2_PORTADO", "E2_VALOR", "E2_SALDO", "E2_MULTA", "E2_CLVLDB", "E2_CCD", "E2_FORNECE", "E2_NOMFOR",;
	"E2_LOJA", "E2_EMISSAO", "E2_EMIS1", "E2_VENCREA", "E2_BAIXA", "E2_DESCONT", "E2_DECRESC", "' '",;
	"' '", "' '","E2_MOEDA","E2_NUMBOR","E2_DTBORDE","E2_MULTNAT", "' '","E2_HIST"}
	cAlias := "SE2"
EndIf

// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		If ! "MULTNAT" $ SX3->X3_CAMPO
			Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		EndIf
	Endif  
	
	Do Case
		Case nX == 23 .and. cAlias == "SE2"
			aAdd(aHeader, {"Situacao", ,"@!",2,0,0})
		Case nX == 24 .and. cAlias == "SE2"
			aAdd(aHeader, {"Agencia",  ,"@!",8,0,0})
		Case nX == 25 .and. cAlias == "SE2"
			aAdd(aHeader, {"Conta",    ,"@!",20,0,0})
	EndCase
	
Next nX

DbSelectArea("SM0")
DbSetOrder(01)
DbGoTop()

cCod := "" 
While !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		cCod := SM0->M0_CODIGO
		aAdd(aEmp, SM0->M0_CODIGO)
	EndIf
	SM0->(dbSkip())
End
for i := 1 to len(aEmp)
	cQuery += "SELECT '"+aEmp[i]+"' AS EMP"
	
	for j := 2 to len(aFields)
		cQuery += ", "+aFields[j]
		DO Case
			Case j == 2
				cQuery += " AS FILIAL"
			Case j == 3
				cQuery += " AS PREFIXO"
			case j == 4
				cQuery += " AS TITULO"
			case j == 5
				cQuery += " AS PARCELA"
			case j == 6
				cQuery += " AS TIPO"
			case j == 7
				cQuery += " AS NATUREZA"
			case j == 8
				cQuery += " AS PORTADOR"
			case j == 9
				cQuery += " AS VALOR"
			case j == 10
				cQuery += " AS SALDO"
			case j == 11
				cQuery += "	AS MULTA"
			case j == 12
				cQuery += " AS CLVL"
			case j == 13
				cQuery += " AS CC"
			case j == 14
				cQuery += " AS CLIFOR"
			case j == 15
				cQuery += " AS RAZAO"
			case j == 16
				cQuery += " AS LOJA"
			case j == 17
				cQuery += " AS EMISSAO"
			case j == 18
				cQuery += " AS EMIS1"
			case j == 19
				cQuery += " AS VENCREA"
			case j == 20
				cQuery += " AS BAIXA"
			case j == 21
				cQuery += " AS DESCONTO"
			case j == 22
				cQuery += " AS DECRESCIMO"
			case j == 23
				cQuery += " AS SITUACAO"
			case j == 24
				cQuery += " AS AGENCIA" 
			case j == 25
				cQuery += " AS CONTA"
			case j == 26
				cQuery += " AS MOEDA " 
			case j == 27
				cQuery += " AS NUMBOR " 
			case j == 28
				cQuery += " AS DATABOR " 				
			case j == 29
				cQuery += " AS MULTNAT " 	
			case j == 30
				cQuery += " AS HIST " 	
		
						
		EndCase
	Next j 

	cQuery += " FROM " + cAlias + aEmp[i] + "0 "
	cQuery += "WHERE D_E_L_E_T_ <> '*' "
	cQuery += "  AND "+aFields[18]+" BETWEEN '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFim)+"' "
	cQuery += "  AND "+aFields[10]+" <> 0 "
	
	if i == len(aEmp)
		cQuery += "ORDER BY EMP, FILIAL, PREFIXO, TITULO, PARCELA "
	Else
		cQuery += "UNION ALL "
	EndIf
Next

If !lWeb
	MemoWrite("C:/flux.txt", cQuery)
	if Aviso("Tempo Execução","Essa consulta fará uma varredura em todas as empresas do grupo em busca dos títulos "+;
		"em aberto vencidos e a vencer, portanto pode ser extremamente demorado."+;
		"Para reduzir o tempo de execução é recomendável que sejam escolhidas faixas de datas curtas.",{"Continuar","Cancelar"},3) != 1
		Return
	EndIf
Else
	conout("UNISE1-QUERY: "+cQuery) 
endif  


TCQUERY cQuery NEW ALIAS "SETMP"

if At(".",cCaminho) > 0
	cCaminho := SubStr(cCaminho,1,At(".",cCaminho)-1)
EndIf

If !ExistDir(cGetCam)
	nRet := makeDir(cGetCam)
	If nRet != 0
		conout("Não foi possível criar o diretório "+cGetCam )
	EndIf
EndIf

nHandle := MsfCreate(AllTrim(cCaminho) + ".CSV",0)

If nHandle > 0
	
	// Grava o cabecalho do arquivo
	
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	
	fWrite(nHandle, cCrLf ) // Pula linha
	
	dbSelectArea("SETMP")
	SETMP->(dbGoTop())
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Avalia se o retorno da consulta for vazio.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	if SETMP->(EOF())     
		conout("UNISE1-SEM DADOS A PROCESSAR.") 
		SETMP->(DbCloseArea())
		Return
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	//³Caso o processamento for feito manualmente, mostra régua 
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
	
	If !lWeb
		SetRegua(nCnt)
	endif

	SETMP->(dbGoTop()) 

	while !(SETMP->(EOF()))
		If !lWeb
			IncRegua()
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Transformação dos campos numéricos em string e mascarado para composição do arquivo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		
		// Edison 20/11/19 inicio
		// Tratamento para deixar valor negativo quando for os tipos RA/NCC/PA/NDF
		If SETMP->TIPO  $ "RA /NCC/PA /NDF"
			cValor := Transform(SETMP->VALOR * -1 ,"@E 999,999,999.99")
			cSaldo := Transform(SETMP->SALDO * -1 ,"@E 999,999,999.99")
		Else 
			cValor := Transform(SETMP->VALOR ,"@E 999,999,999.99")
			cSaldo := Transform(SETMP->SALDO, "@E 999,999,999.99")
			
		EndIf
	    
	    // Edison 20/11/19 fim
		
		cMulta := Transform(SETMP->MULTA,      "@E 999,999,999.99")
		cDesco := Transform(SETMP->DESCONTO,   "@E 999,999,999.99")
		cDecre := Transform(SETMP->DECRESCIMO, "@E 999,999,999.99")
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem e gravação da linha no arquivo³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If SETMP->MULTNAT == "1"

			/*
			dbSelectArea("SEV")
			SEV->(DbSetOrder(1))
			If SEV->(dbSeek(SETMP->(FILIAL+PREFIXO+TITULO+PARCELA+TIPO+CLIFOR+LOJA)) )
				While SEV->(!EOF()) .AND. (SEV->EV_FILIAL==SETMP->FILIAL) .AND. (SEV->EV_PREFIXO==SETMP->PREFIXO) .AND. ;
					(SEV->EV_NUM==SETMP->TITULO) .AND. (SEV->EV_PARCELA==SETMP->PARCELA) .AND. ;
					(SEV->EV_TIPO==SETMP->TIPO) .AND. (SEV->EV_CLIFOR==SETMP->CLIFOR) .AND. ;
					(SEV->EV_LOJA==SETMP->LOJA)
			*/
			
			cQuery := "SELECT EV.EV_FILIAL, EV.EV_PREFIXO, EV.EV_NUM, EV.EV_PARCELA, EV.EV_TIPO, 	"
			cQuery += "       EV.EV_CLIFOR, EV.EV_LOJA, EV.EV_NATUREZ, EV.EV_PERC, EV.EV_IDENT		"
			cQuery += "  FROM SEV"+ SETMP->EMP + "0 EV "
			cQuery += " WHERE EV.D_E_L_E_T_	= ' ' "
			cQuery += "   AND EV.EV_FILIAL	= '"+SETMP->FILIAL+"'	"
			cQuery += "   AND EV.EV_PREFIXO	= '"+SETMP->PREFIXO+"'	"
			cQuery += "	  AND EV.EV_NUM		= '"+SETMP->TITULO+"'	"
			cQuery += "	  AND EV.EV_PARCELA	= '"+SETMP->PARCELA+"'	"
			cQuery += "	  AND EV.EV_TIPO	= '"+SETMP->TIPO+"'		"
			cQuery += "	  AND EV.EV_CLIFOR	= '"+SETMP->CLIFOR+"'	"
			cQuery += "	  AND EV.EV_LOJA	= '"+SETMP->LOJA+"'		"			
			TCQUERY cQuery NEW ALIAS "SETEV"
			dbSelectArea("SETEV")
			If !SETEV->(EOF())						
				While !SETEV->(EOF())						
					If SETEV->EV_IDENT == "1" 

						/*
						dbSelectArea("SEZ")
						SEZ->(DbSetOrder(1))
						If SEZ->(dbSeek(SETMP->(FILIAL+PREFIXO+TITULO+PARCELA+TIPO+CLIFOR+LOJA)+SETEV->EV_NATUREZ) )
							While SEZ->(!EOF()) .AND. (SEZ->EZ_FILIAL==SETMP->FILIAL) .AND. (SEZ->EZ_PREFIXO==SETMP->PREFIXO) .AND. ;
								(SEZ->EZ_NUM==SETMP->TITULO) .AND. (SEZ->EZ_PARCELA==SETMP->PARCELA) .AND. ;
								(SEZ->EZ_TIPO==SETMP->TIPO) .AND. (SEZ->EZ_CLIFOR==SETMP->CLIFOR) .AND. ;
								(SEZ->EZ_LOJA==SETMP->LOJA) .AND. (SEZ->EZ_NATUREZ==SETEV->EV_NATUREZ)								
						*/	                                                                                                        
						
						cQuery := "SELECT EZ.EZ_FILIAL, EZ.EZ_PREFIXO, EZ.EZ_NUM, EZ.EZ_PARCELA, EZ.EZ_TIPO, 	"
						cQuery += "       EZ.EZ_CLIFOR, EZ.EZ_LOJA, EZ.EZ_NATUREZ, EZ.EZ_PERC, EZ.EZ_IDENT,		"
						cQuery += "       EZ.EZ_CCUSTO, EZ.EZ_CLVL												"
						cQuery += "  FROM SEZ"+ SETMP->EMP + "0 EZ "
						cQuery += " WHERE EZ.D_E_L_E_T_	= ' ' "
						cQuery += "   AND EZ.EZ_FILIAL	= '"+SETMP->FILIAL+"'		"
						cQuery += "   AND EZ.EZ_PREFIXO	= '"+SETMP->PREFIXO+"'		"
						cQuery += "	  AND EZ.EZ_NUM		= '"+SETMP->TITULO+"'		"
						cQuery += "	  AND EZ.EZ_PARCELA	= '"+SETMP->PARCELA+"'		"
						cQuery += "	  AND EZ.EZ_TIPO	= '"+SETMP->TIPO+"'			"
						cQuery += "	  AND EZ.EZ_CLIFOR	= '"+SETMP->CLIFOR+"'		"
						cQuery += "	  AND EZ.EZ_LOJA	= '"+SETMP->LOJA+"'	   		"			
						cQuery += "	  AND EZ.EZ_NATUREZ	= '"+SETEV->EV_NATUREZ+"'	"							
						TCQUERY cQuery NEW ALIAS "SETEZ"
						dbSelectArea("SETEZ")
						If !SETEZ->(EOF())						
							While !SETEZ->(EOF())						
								If SETEZ->EZ_IDENT == "1"
									cCC    := SETEZ->EZ_CCUSTO
									cCLVL  := SETEZ->EZ_CLVL
									cNATU  := SETEV->EV_NATUREZ
									nVALOR := Round(SETEV->EV_PERC * SETMP->VALOR, 2)     
									nVALOR := Round(SETEZ->EZ_PERC * nVALOR, 2)     
									nSALDO := Round(SETEV->EV_PERC * SETMP->SALDO, 2)
									nSALDO := Round(SETEZ->EZ_PERC * nSALDO, 2)
									nMULTA := Round(SETEV->EV_PERC * SETMP->MULTA, 2)
									nMULTA := Round(SETEZ->EZ_PERC * nMULTA, 2)
									nDESCO := Round(SETEV->EV_PERC * SETMP->DESCONTO, 2)
									nDESCO := Round(SETEZ->EZ_PERC * nDESCO, 2)
									nDECRE := Round(SETEV->EV_PERC * SETMP->DECRESCIMO, 2)
									nDECRE := Round(SETEZ->EZ_PERC * nDECRE, 2)
									cValor := Transform(nVALOR, "@E 999,999,999.99")
									cSaldo := Transform(nSALDO, "@E 999,999,999.99")
									cMulta := Transform(nMULTA, "@E 999,999,999.99")
									cDesco := Transform(nDESCO, "@E 999,999,999.99")
									cDecre := Transform(nDECRE, "@E 999,999,999.99")
			
									fWrite(nHandle, SETMP->EMP      +";"+ SETMP->FILIAL  +";"+ SETMP->PREFIXO +";"+ SETMP->TITULO  +";"+ SETMP->PARCELA +";"+ SETMP->TIPO    +";"+ cNATU	 +";"+;
																	SETMP->PORTADOR +";"+ cValor         +";"+ cSaldo         +";"+ cMulta         +";"+ cCLVL  		+";"+ cCC      		 +";"+;
																	SETMP->CLIFOR   +";"+ SETMP->RAZAO   +";"+ SETMP->LOJA    +";"+ SETMP->EMISSAO +";"+ SETMP->EMIS1   +";"+ SETMP->VENCREA +";"+;
																	SETMP->BAIXA    +";"+ cDesco         +";"+ cDecre         +";"+ SETMP->SITUACAO+";"+ SETMP->AGENCIA +";"+ SETMP->CONTA   +";"+ AllTrim(Str(SETMP->MOEDA,0))+";" +;
																	SETMP->NUMBOR   +";"+ SETMP->DATABOR +";"+ SETMP->HIST  +";")
									
									fWrite(nHandle, cCrLf ) // Pula linha
						
								    
								EndIf
								SETEZ->(dbSkip())
							Enddo							
						EndIf    
						SETEZ->(dbCloseArea())
			        EndIf
			        SETEV->(dbSkip())
				Enddo
			EndIf
			SETEV->(dbCloseArea())
		
		Else
		
			fWrite(nHandle, SETMP->EMP      +";"+ SETMP->FILIAL  +";"+ SETMP->PREFIXO +";"+ SETMP->TITULO  +";"+ SETMP->PARCELA +";"+ SETMP->TIPO    +";"+ SETMP->NATUREZA +";"+;
											SETMP->PORTADOR +";"+ cValor         +";"+ cSaldo         +";"+ cMulta         +";"+ SETMP->CLVL    +";"+ SETMP->CC      +";"+;
											SETMP->CLIFOR   +";"+ SETMP->RAZAO   +";"+ SETMP->LOJA    +";"+ SETMP->EMISSAO +";"+ SETMP->EMIS1   +";"+ SETMP->VENCREA +";"+;
											SETMP->BAIXA    +";"+ cDesco         +";"+ cDecre         +";"+ SETMP->SITUACAO+";"+ SETMP->AGENCIA +";"+ SETMP->CONTA   +";"+ AllTrim(Str(SETMP->MOEDA,0))+";" +;
											SETMP->NUMBOR   +";"+ SETMP->DATABOR +";"+ SETMP->HIST  +";")
		
			fWrite(nHandle, cCrLf ) // Pula linha
			
		EndIf
		
		SETMP->(DbSkip()) 
		
	EndDo
	
	fClose(nHandle)
	
	If !lWeb
		If ! ApOleClient( 'MsExcel' )
			MsgAlert( 'MsExcel nao instalado')
			Return
		EndIf
		
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(AllTrim(cCaminho) + ".CSV") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	Endif 
	
Else
	
	If !lWeb
		MsgAlert("Falha na criação do arquivo")
	Else
		ConOut( Time()+" - Falha na criação do arquivo" )
	Endif
	
Endif

SETMP->(DbCloseArea())

RestArea(aArea)

Return .T.
