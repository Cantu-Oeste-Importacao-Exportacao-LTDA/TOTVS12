#include "TOTVS.CH"
#include "RWMAKE.CH"
#include "TOPCONN.CH"
#INCLUDE "URZUM.CH"
                           
/*                      		
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT120OK    ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação da inclusão do pedido de compras.     º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*----------------------------*
User Function MT120OK()
*----------------------------*
Local lRet := .T.        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// PERMITIDO TEMPORARIAMENTE
If (! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645/GESCTRL") //.And. (!ALLTRIM(FUNNAME()) == "MATA121")
	lRet := fCheckCON()
EndIf

/*
//-- Verifica se existe contrato ativo para o fornecedor/item do pedido de venda. --//
If ! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645"
lRet := fCheckCON()
EndIf

*/


/* Pedidos incluídos pelas seguintes rotinas não serão considerados:
.CNTA120  - gestão de contratos
.RJFINP01 - geração de comissões
.MNTA650  - abastecimentos
.MNTA645  - abastecimento automatico
*/

If lRet .and. ALLTRIM(SuperGetMV("MV_X_APRGB",,"N")) == "S" .and. ! ALLTRIM(FUNNAME()) $ "RPC/CNTA260/CNTA120/RJFINP01/MNTA650/MNTA645" .and. ! "RJFINP01" $ FUNNAME()
	if Type("__GCTNUM") == 'C'
		U_RJ120PAR(.F., @lRet,.T., .T.) // Indica que é a nova gestão de contratos
	else
		U_RJ120PAR(.T., @lRet,.T.)
	endif
	If lRet
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Data prevista de entrega                                                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nPDATPRF := aScan(aHeader,{|x| AllTrim(x[2])=="C7_DATPRF"})
		If !Empty(aCols[01][nPDATPRF])
			dPDATPRF := aCols[01][nPDATPRF]
		EndIf
		nVALPED := aValores[06]
		
		MsAguarde( { ||	 lRet := U_RJ120VCP(dPDATPRF,nVALPED) }, "Verificando datas de pagamento..."  )
	EndIf
EndIf

/*  Edison dia 16/09/15 não é mais utilizado affil
//// Inicio Afill - Ponto em que o sistema da Afill valida o pedido de compras
If lRet
	If !IsBlind()
		lRet := U_UZPCVIMP("GERAL")
	
		If !lRet
			MsgStop(MSGPI1,"Pedido Importado")
		EndIf
		/// Fim Afill
	EndIf
EndIf
  
*/
Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fValCP     ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação da condição de pagamento para inclusãoº±±
±±º          ³do pedido de compras.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*------------------------------------------*
User Function RJ120VCP(dPDATPRF,nVALPED)
*------------------------------------------*
Local aArea    := GetArea()
Local lRet     := .T.
Local lBlq     := .F.     
Local aDADOS   := {} 
Local nNumDayPas := SuperGetMV("MV_X_NDMPS",,0)
Local lNumDayPas := .F.
Local cFormpg := ALLTRIM(SA2->A2_FORMPAG)
Local cForcdp := ALLTRIM(SA2->A2_COND)

Public __cUSRSUP := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Recupera vencimentos/valores da condição de pagamento                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	if Type("__GCTNUM") == 'C'
		aPARCELA := __aPARGCT
	else
		aPARCELA := __aPARCPED
	endif
	
	
	If Len(aPARCELA) > 0
		For nI := 1 to Len(aPARCELA)
			aAdd ( aDADOS, { aPARCELA[nI][01], aPARCELA[nI][02], lBlq } )

			If aPARCELA[nI][01] < ( ddatabase + nNumDayPas )
				lNumDayPas := .T.
			EndIf			
			
		Next nI
	EndIf  

	If ! lNumDayPas
	
		If Len(aDADOS) > 0
			For nI := 1 to Len(aDADOS)  
	
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica disponibilidade da data de vencimento                          ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
				lBlq := .T.
				dbSelectArea("Z10")
				dbSetOrder(1)
				dbGoTop()
				If dbSeek ( xFilial("Z10") + dtos(aDADOS[nI][01]) )
					If Z10->Z10_BLOQ == "N"
						/* RETIRADA VALIDACAO DE SALDO.
						If U_RJFC01SC() >= aDADOS[nI][02]
							lBlq := .F.
						EndIf        
						*/
						lBlq := .F.
					EndIf
				EndIf				
				aDADOS[nI][03] := lBlq
				If lBlq
					lRet := .F.
				EndIf				
	
			Next nI						
		EndIf               
	
	Else
		lRet := .F.
	EndIf
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se usuario deseja incluir pedido com data bloqueada            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	If !lRet
		Aviso("Aviso", "Data(s) de vencimento(s) bloqueada(s) ou sem saldo!", {"OK"}, 2)
		If MsgYesNo("Deseja realmente incluir o pedido com autorização do superior ?")
			lRet := fLogSUP()
		EndIf
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Validação da forma e condição de pagamento.³
	//³Edison G. Barbieri             30/09/2019  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lRet                                                        		
			Do Case
				Case cForcdp != Alltrim(M->cCondicao)   
					 MsgBox("Divergencia na CONDIÇÃO DE PAGAMENTO para este fornecedor, entrar em contato com o cadastro para ajuste ou lançar com a que esta pré configurada, CONDICAO: " + cForcdp + " , tel: 46 2101-4091!","Alerta","ERRO")
					 lRet := .F.
				 	   
			End Case
	EndIf
	
	RestArea(aArea)
	
		
Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLogSUP    ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Janela de login do superior, autorizando inclusão do pedido º±±
±±º          ³de compras.                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*----------------------------------------*
Static Function fLogSUP()
*----------------------------------------*
Local lRet := .T.
Private cUSRSUP := Space(15)
Private cPASSUP := Space(15)
Private nOpcao  := 0
Private oDlgPASS

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Janela de autorização                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	DEFINE MSDIALOG oDlgPASS FROM 000,000 TO 160,200 TITLE "Autorização de inclusão"  OF oDlgPASS PIXEL
	@ 005, 005 TO 050, 095 OF oDlgPASS  PIXEL 
	@ 013,010 SAY "Usuário:" OF oDlgPASS PIXEL
	@ 012,040 GET cUSRSUP  SIZE 050,10 WHEN .T. VALID (!Vazio()) OF oDlgPASS PIXEL
	@ 028,010 SAY "Senha:" OF oDlgPASS PIXEL
	@ 027,040 GET cPASSUP  SIZE 050,10 WHEN .T. PASSWORD VALID (!Vazio()) OF oDlgPASS PIXEL
				
	DEFINE SBUTTON FROM 060, 040 TYPE 1 ACTION ( fValPass(cUSRSUP, cPASSUP, @nOpcao) )  ENABLE OF oDlgPASS PIXEL
	DEFINE SBUTTON FROM 060, 070 TYPE 2 ACTION (oDlgPASS:End()) ENABLE OF oDlgPASS PIXEL
	
	ACTIVATE MSDIALOG oDlgPASS CENTERED
	
	If nOpcao == 0
		lRet := .F.		
	EndIf

Return (lRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fValPass   ºAutor  ³Rafael Parma       º Data ³  07/10/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação de usuário/senha do superior.         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------*
Static Function fValPass(cUSRSUP, cPASSUP, nOpcao)
*-------------------------------------------------*
Local lRet	:= .T.
	

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se o usuario digitado tem permissao                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If !(AllTrim(cUSRSUP)$AllTrim(SuperGetMV("MV_X_USPDC",,"N")))
		Aviso("Aviso", "Este usuário não foi definido como superior.", {"OK"}, 2)
		lRet:=.F.
	EndIf


	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Pesquisa no arquivo de senhas o usuario e valida a senha digitada       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If lRet
		PswOrder(2)
		PswSeek(cUSRSUP,.T.)
		If !PswName(cPASSUP)
			HELP("",1,"INVSENHA")
			lRet := .F.
		EndIf
	EndIf
	
	If lRet
		nOpcao := 1
		oDlgPASS:End()
		__cUSRSUP := cUSRSUP
	EndIf
	         
	
Return (lRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fCheckCON  ºAutor  ³Rafael Parma       º Data ³  13/06/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina para validação de contrato ativo para o fornecedor/  º±±
±±º          ³produtos no módulo de gestão de contratos.                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³RJU                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
*-------------------------------------------------*
Static Function fCheckCON()                        
*-------------------------------------------------*
Local lRet      := .T.
Local lBloqPED  := ALLTRIM(SuperGetMV("MV_X_IPCCT",,"N"))=="S"
Local nPOSPROD  := aScan(aHeader,{|x| AllTrim(x[2])=="C7_PRODUTO"})
Local cPRODUTO  := ""
Local cTEXTMSG  := ""
Local cAliasTMP := GetNextAlias()

	If Len(aCols) > 0 .and. nPOSPROD > 0
		For nI := 1 to Len(aCols)
			If ! aCols[nI,Len(aHeader)+1]
				If ! aCols[nI,nPOSPROD] $ cPRODUTO
					cPRODUTO := "'"+aCols[nI,nPOSPROD]+"',"
				EndIf
			EndIf
		Next nI
	EndIf    
	
	If cPRODUTO != ""
	
		cPRODUTO := SubSTR(cPRODUTO,1,Len(cPRODUTO)-1)

		cQuery := "	SELECT DISTINCT(CN9.CN9_NUMERO||CNB.CNB_PRODUT) CN9_NUMERO			"+chr(10)+chr(13)
		cQuery += "	FROM " + RetSQLName("CN9") + " CN9									"+chr(10)+chr(13)
		cQuery += "	INNER JOIN " + RetSQLName("CNA") + " CNA							"+chr(10)+chr(13)
		cQuery += "	ON  CNA.CNA_FILIAL = CN9.CN9_FILIAL									"+chr(10)+chr(13)
		cQuery += "	AND CNA.CNA_CONTRA = CN9.CN9_NUMERO									"+chr(10)+chr(13)
		cQuery += "	AND CNA.CNA_REVISA = CN9.CN9_REVISA									"+chr(10)+chr(13)
		cQuery += "	INNER JOIN " + RetSQLName("CNB") + " CNB							"+chr(10)+chr(13)
		cQuery += "	ON  CNB.CNB_FILIAL = CN9.CN9_FILIAL									"+chr(10)+chr(13)
		cQuery += "	AND CNB.CNB_CONTRA = CN9.CN9_NUMERO									"+chr(10)+chr(13)
		cQuery += "	AND CNB.CNB_REVISA = CN9.CN9_REVISA									"+chr(10)+chr(13)
		cQuery += "	WHERE CN9.CN9_FILIAL  = '" + xFilial("CN9") + "'					"+chr(10)+chr(13)
		cQuery += "	AND   CN9.CN9_SITUAC  = '05'										"+chr(10)+chr(13)
		cQuery += "	AND   CNA.CNA_FORNEC  = '" + cA120Forn + "'							"+chr(10)+chr(13)
		cQuery += "	AND   CNA.CNA_LJFORN  = '" + cA120Loj  + "'							"+chr(10)+chr(13)		
		cQuery += "	AND   CNB.CNB_PRODUT IN (" + cPRODUTO  + ") 						"+chr(10)+chr(13)
		cQuery += "	AND   CNA.D_E_L_E_T_ != '*'											"+chr(10)+chr(13)
		cQuery += "	AND   CNB.D_E_L_E_T_ != '*'											"+chr(10)+chr(13)
		cQuery += "	AND   CN9.D_E_L_E_T_ != '*'											"+chr(10)+chr(13)
		     
		TCQUERY ChangeQuery( cQuery ) NEW ALIAS (cAliasTMP)
		
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
		
		nTAMCON := TAMSX3("CN9_NUMERO")[1]
		nTAMPRD := TAMSX3("CNB_PRODUT")[1]
		If !(cAliasTMP)->(EOF())
		
			While !(cAliasTMP)->(EOF())
				cTEXTMSG += "CONTRATO: "+SubSTR((cAliasTMP)->CN9_NUMERO,1,nTAMCON)+" - PRODUTO: "+SubSTR((cAliasTMP)->CN9_NUMERO,nTAMCON+1,nTAMPRD)+CHR(10)+CHR(13)
				(cAliasTMP)->(dbSkip())
			Enddo
		    
			cTEXTMSG := "Existe(m) contrato(s) vigente(s) para este fornecedor/loja e produto(s) deste pedido, conforme relação abaixo:"+CHR(10)+CHR(13)+cTEXTMSG			
			Aviso("Atenção", cTEXTMSG, {"OK"}, 3 )
			
			If lBloqPED
				lRet := .F.
			EndIf
		
		EndIf
		(cAliasTMP)->(dbCloseArea())
		
	EndIf    
	
Return (lRet)