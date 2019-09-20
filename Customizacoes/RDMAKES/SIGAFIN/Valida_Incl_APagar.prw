#INCLUDE "rwmake.ch"
#include "TOTVS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ FA050INC บ Autor ณ Adriano Novachaelley Data ณ  27/12/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ O ponto de entrada FA050INC sera utilizado na validacao da บฑฑ
ฑฑบ          ณ inclusao de titulos no contas a pagar.                     บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ FINA050 -> Contas a Pagar / FINA750-> Func. Ctas. A Pagar  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
// Validar a quantidade de digitos do campo SE2->E2_NUM 
// Deve ser igual ao tamanho padrao do campo.

User Function FA050INC()                                                               
Local lRet	:= .T.
Local _aArea	:= GetArea()  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

If AllTrim(FunName()) $ "FINA750/FINA050" .And. Inclui

	If Len(AllTrim(M->E2_NUM)) <> TamSX3("E2_NUM")[1] 
		MsgAlert("O campo No. Titulo deve ser preenchido com "+AllTrim(Str((TamSX3("E2_NUM")[1])))+" caracteres.")
	    lRet	:= .F.
	Endif
	
EndIf

	//--Valida็ใo de campos contแbeis.
	lRet := FVALDIV()
	
	//--Rafael - 03/08/2011 - Adicionada valida็ใo para inclusใo de tํtulo de tipo = PA.
	If Inclui .and. lRet .and. ALLTRIM(M->E2_TIPO) == "PA" .and. ALLTRIM(SuperGetMV("MV_X_CSIPA",,"N")) == "S"

		If ! ALLTRIM(UPPER(cUserName)) $ ALLTRIM(UPPER(SuperGetMV("MV_X_USIPA",,"")))
			nRet := Aviso("Aviso", 	"Para realizar a inclusใo de tํtulo com tipo = PA ้ necessแria libera็ใo de superior, deseja continuar?", {"Sim","Nใo"}, 2) 			
			If nRet == 1
				lRet := fLogSUP()
			Else
				lRet := .F.
			EndIf
		EndIf
		
	EndIf


RestArea(_aArea)

Return(lRet)
                              


*----------------------------*
Static Function FVALDIV()
*----------------------------*

Local aArea := GetArea()
Local lRet  	:= .T.
Local cConta    := ""
Local cCCusto   := ""
Local cItemCta  := ""
Local cClasVlr  := ""
Local cNatureza := M->E2_NATUREZ

	cCCusto  := M->E2_CCD
	cItemCta := M->E2_ITEMD
	cClasVlr := M->E2_CLVLDB 

If SuperGetMV("MV_X_VALEN",,.T.)

	dbSelectArea("SED")
	dbSetOrder(1) // FILIAL + CODIGO
	If dbSeek( xFilial() + cNatureza ) 
		
		cConta   := SED->ED_DEBITO
		
		If Empty(cConta)
			Return(lRet)
		End	
		
		dbSelectArea("CT1")
		dbSetOrder(1) // FILIAL + CONTA
		If dbSeek(xFilial() + cConta)
		
			//--Centro de Custo ้ obrigat๓rio!
			If CT1->CT1_CCOBRG = "1" .and. Empty(cCCusto)
				
				If M->E2_RATEIO == "S"
					If Select("TMP") > 0
						lRateio := .F.
						TMP->(dbGoTop())
						While TMP->(!EOF())
							If !Empty(TMP->CTJ_CCD)
								lRateio := .T.
							EndIf
							TMP->(dbSkip())
						Enddo
						If ! lRateio
							Aviso( "Centro de Custo Obrigat๓rio !", "Favor informar o C. Custo Deb. no RATEIO, conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
							"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 )
	                    	lRet := .F.
						EndIf
					EndIf
				Else
					If ALLTRIM(FUNNAME()) == "GPEM670"
						If !RC1->(EOF())
							M->E2_CCD := RC1->RC1_CC
						EndIf
					Else				
						Aviso( "Centro de Custo Obrigat๓rio !", "Favor informar o C. Custo Deb., conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 )
						lRet := .F.
					EndIf
				EndIf
				
			//--Item Contแbil ้ obrigat๓rio!
			ElseIf CT1->CT1_ITOBRG = "1" .and. Empty(cItemCta)
			
				If M->E2_RATEIO == "S"
					If Select("TMP") > 0
						lRateio := .F.
						TMP->(dbGoTop())
						While TMP->(!EOF())
							If !Empty(TMP->CTJ_ITEMD)
								lRateio := .T.
							EndIf
							TMP->(dbSkip())
						Enddo
						If ! lRateio
							Aviso( "Centro de Trabalho Obrigat๓rio !", "Favor informar o Item Ctb. Deb. no RATEIO,  conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
							"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 ) 
							lRet := .F.
						EndIf
					EndIf
				Else
					If ALLTRIM(FUNNAME()) != "GPEM670"
						Aviso( "Centro de Trabalho Obrigat๓rio !", "Favor informar o Item Ctb. Deb.,  conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 ) 
						lRet := .F.					
					EndIf          
				EndIf
				
			//--Classe de Valor ้ obrigat๓rio!
			ElseIf CT1->CT1_CLOBRG = "1" .and. Empty(cClasVlr)

				If M->E2_RATEIO == "S"
					If Select("TMP") > 0
						lRateio := .F.
						TMP->(dbGoTop())
						While TMP->(!EOF())
							If !Empty(TMP->CTJ_CLVLDB)
								lRateio := .T.
							EndIf
							TMP->(dbSkip())
						Enddo
						If ! lRateio
							Aviso( "Segmento Obrigat๓rio!", "Favor informar o Segmento Deb. no RATEIO,  conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
							"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 )
							lRet := .F.
						EndIf
					EndIf
				Else
					If ALLTRIM(FUNNAME()) != "GPEM670"				
						Aviso( "Segmento Obrigat๓rio!", "Favor informar o Segmento Deb.,  conforme obrigatoriedade da Conta Contแbil. "+CHR(13)+CHR(10)+CHR(13)+CHR(10)+;
						"Qualquer d๚vida entre em contato com o Departamento Contแbil."+CHR(13)+CHR(10)+CHR(13)+CHR(10)+" U_FA050INC ", { "Ok" }, 3 )
						lRet := .F.
					EndIf
				EndIf
					
			Endif
			
		Endif
	Endif
Endif
RestArea(aArea)

Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfLogSUP    บAutor  ณRafael Parma       บ Data ณ  03/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณJanela de login do superior, autorizando inclusใo de tํtulo บฑฑ
ฑฑบ          ณtipo = PA.                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*----------------------------------------*
Static Function fLogSUP()
*----------------------------------------*
Local lRet := .T.
Private cUSRSUP := Space(15)
Private cPASSUP := Space(15)
Private nOpcao  := 0
Private oDlgPASS

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณJanela de autoriza็ใo                                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	DEFINE MSDIALOG oDlgPASS FROM 000,000 TO 160,200 TITLE "Autoriza็ใo de inclusใo"  OF oDlgPASS PIXEL
	@ 005, 005 TO 050, 095 OF oDlgPASS  PIXEL 
	@ 013,010 SAY "Usuแrio:" OF oDlgPASS PIXEL
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfValPass   บAutor  ณRafael Parma       บ Data ณ  03/08/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina para valida็ใo de usuแrio/senha do superior.         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-------------------------------------------------*
Static Function fValPass(cUSRSUP, cPASSUP, nOpcao)
*-------------------------------------------------*
Local lRet	:= .T.	

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณVerifica se o usuario digitado tem permissao                            ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	If ! ALLTRIM(cUSRSUP) $ ALLTRIM(SuperGetMV("MV_X_USIPA",,""))
		Aviso("Aviso", "Este usuแrio nใo foi definido como superior.", {"OK"}, 2)
		lRet:=.F.
	EndIf


	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณPesquisa no arquivo de senhas o usuario e valida a senha digitada       ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
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
	EndIf
	         	
Return (lRet)
