#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GETCHAVN            ³Autor ³ Microsiga    ³ Data ³30/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Geração de chave para o SFA					 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/


/***************************************************************
// Função disponível apenas para Beto e Diretoria do Pneu para permitir 
// geração de desconto acima de MV_DESMPNE na venda de Pneu.
 ***************************************************************/
User Function GetChavD() 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

	// verifique sempre a senha informada no parametro abaixo, pois ela só pode ser conhecida pelo gerente geral.
	if AllTrim(SuperGetMV("MV_SENPNB")) == GetSePnB()
		U_GetChavN(.T., .T.)
	Else
		MsgInfo("Não autorizado a gerar senha.", "Atenção")
	EndIf
Return Nil


/**********************************************
 Função para pedir a autorizacao para gerar a senha
 **********************************************/
Static Function GetSePnB()
Local cCodigo := Space(6)
Local oDlg

DEFINE MSDIALOG oDlgKey TITLE "Autorizar geração de senha SFA" FROM 150,250 TO 300,510 OF GetWndDefault() PIXEL
@ 15, 10 Say "Informe o código de acesso para gerar senha:" PIXEL OF oDlgKey
@ 30, 10 Get cCodigo Size 60, 10 PIXEL OF oDlgKey
@ 60,040 BMPBUTTON TYPE 1 ACTION Close(oDlgKey)

ACTIVATE MSDIALOG oDlgKey CENTERED

// Caso nao seja informado, seta o valor abaixo, 
// devido a poder acessar de uma empresa que não está configurada e 
// liberar senha por esta empresa
if empty(cCodigo)
  cCodigo := "%%%%%%" 
EndIf

Return AllTrim(cCodigo)

          
/******************************************************
 Funçao chamada no menu para a geracao de senha pelo novo algorítimo
 Mudado devido a problemas no algoritimo anterior.
 ******************************************************/
User Function GetChav2()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

U_GetChavN(.F., .T.)
Return Nil

/******************************************************
 Funçao chamada no menu para a geracao de senha pelo algorítimo antigo e mais segura
 Mudado devido a problemas no algoritimo novo, gerando senhas muito parecidas.
 ******************************************************/
User Function GetChav3()         

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

U_GETCHAVN(.F., .F.)
Return Nil


/*************************************************
 Função para gerar chave do SFA, sendo que o parametro 
 passado é referente a geração de senha para o pneu (desconto máximo)
 O segundo parametro é devido a ser reformulado a geracao de senha.
 se for passado como verdadeiro, chama a nova funcao de gerar senha 
 devido a antiga estar com problemas
 *************************************************/
User Function GETCHAVN(lDescM, lVer2)
Local oDlgKey
Local cKey     := "" 
Local cCodVend := Space(6)
Local cCodArm  := Space(2)
Local nSaldo   := 0
Local nPDesc   := 0
Local cNumPed  := Replicate('0', 6)
     
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

if Empty(lDescM)
	lDescM := .F.
EndIf

if Empty(lVer2)
	lVer2 := .F.
EndIf

DEFINE MSDIALOG oDlgKey TITLE "Gerador de Chave  - SFA" FROM 150,250 TO 390,500 OF GetWndDefault() PIXEL

@ 010,010 SAY "Vendedor: " PIXEL OF oDlgKey
@ 008,065 MSGET cCodVend SIZE 45,10 F3 "SA3" PIXEL OF oDlgKey

@ 023,010 SAY "Armazem: " PIXEL OF oDlgKey
@ 021,065 MSGET cCodArm  SIZE 45,10 F3 "SZA" PIXEL OF oDlgKey

@ 036,010 SAY "Saldo do Armazem:" PIXEL OF oDlgKey
@ 034,065 MSGET nSaldo Picture "@E 999999.99"  SIZE 40,10 PIXEL OF oDlgKey

@ 049,010 SAY "Desconto do Pedido:" PIXEL OF oDlgKey
@ 047,065 MSGET nPDesc Picture "@E 999999.99"  SIZE 40,10 PIXEL OF oDlgKey

if !lVer2
	@ 064,010 SAY "Numero do Pedido:" PIXEL OF oDlgKey
	@ 062,065 MSGET cNumPed Picture "999999" F3 "SC5" SIZE 45,10 PIXEL OF oDlgKey
EndIf

@ 076, 010 SAY "Data Atual:" + DtoC(Date()) PIXEL OF oDlgKey

@ 085,010 SAY "Chave:" PIXEL OF oDlgKey
@ 083,050 MSGET cKey SIZE 55,10 PIXEL OF oDlgKey WHEN .F.

if (lVer2)
	@ 100,040 BMPBUTTON TYPE 1 ACTION (fGetSen2(cCodVend,cCodArm,nSaldo,nPDesc,@cKey, lDescM),oDlgKey:Refresh())
Else
	@ 100,040 BMPBUTTON TYPE 1 ACTION (fGetSenh(cCodVend,cCodArm,nSaldo,nPDesc,@cKey, lDescM, cNumPed),oDlgKey:Refresh())
EndIf

@ 100,070 BMPBUTTON TYPE 2 ACTION Close(oDlgKey)

ACTIVATE MSDIALOG oDlgKey CENTERED

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ fProcSFA            ³Autor ³ Microsiga    ³ Data ³30/01/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Geração de chave para o SFA					 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fProcSFA(cCodVend,cCodArm,nSaldo,cKey)

//Local oDlgKey2
//Local cKey 	:= ""
Local cData     := DtoS(Date())
Local cHora     := Time()
Local nHora 	:= Val(SubSTR(cHora,len(cHora)-4,1))
Local cHora1 	:= STR(Iif(nHora<3,nHora+7,nHora-2),1)
Local cHora2 	:= STR(Iif(nHora>5,nHora-4,nHora+4),1)
Local cHora3 	:= STR(Iif(nHora<=2,nHora+5,Iif(nHora<=4,nHora-3,nHora-1)),1)
Local nDia   	:= Val(SubSTR(cData,len(cData)-1,2))
Local nDia1  	:= IIf(nDia > 15,nDia-8,nDia+37)
Local cData1 	:= STR(nDia1,2)
Local cData2 	:= SubStr(cData1,2,1)
Local nSaldoX	:= nSaldo + nHora + nDia1
Local cSaldo    := AllTrim(StrTran(Str(nSaldoX,,2), ".", ","))
Local nPosDec   := AT(",",cSaldo)
Local cDecSaldo := SubStr(cSaldo,nPosDec+1,2)
Local cIntSaldo := SubStr(cSaldo,1,nPosDec-1)
Local nSaldo1 	:= Val(cDecSaldo)
Local cSaldo1 	:= SubSTR(STR(Iif(nSaldo1 > 50,nSaldo1-22,nSaldo1+22),2),1,1)
Local nSaldo2 	:= Val(SubSTR(cIntSaldo,1,1))
Local cSaldo2 	:= STR(Iif(nSaldo2 > 5,nSaldo2-3,nSaldo2+3),1)
Local cSaldo3 	:= ""
Local nSaldo3 	:= 0

If len(cIntSaldo) >= 2
	nSaldo3 := Val(SubSTR(cIntSaldo,2,1))
	cSaldo3 := STR(Iif(nSaldo3 > 5,nSaldo3-2,nSaldo3+2),1)
Else
	cSaldo3 := "D"
EndIf

cKey := ""
cKey += cHora3
cKey += cSaldo2
cKey += SubSTR(cCodVend,len(cCodVend)-2,1)
cKey += cData2
cKey += SubSTR(cCodArm,2,1)
cKey += cHora2
cKey += cSaldo1
cKey += SubSTR(cCodVend,len(cCodVend)-1,1)
cKey += cHora1
cKey += cSaldo3

/*DEFINE MSDIALOG oDlgKey2 TITLE "Gerador de Chave - SFA" FROM 150,250 TO 250,450 OF GetWndDefault() PIXEL

@ 012,010 SAY "Chave:" PIXEL OF oDlgKey2
@ 010,040 MSGET cKey SIZE 40,10 PIXEL OF oDlgKey2 WHEN .F.

@ 030,033 BUTTON "Fechar" SIZE 35,11 PIXEL ACTION Close(oDlgKey2)

ACTIVATE MSDIALOG oDlgKey2 CENTERED*/

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ fProcSFANew         ³Autor ³ Flavio Dias  ³ Data ³06/05/08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Geração de chave para o SFA- nova versão                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³         ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista    ³ Data   ³Motivo da Alteracao                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³            ³        ³                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fGetSenh(cCodVend,cCodArm,nSaldo,nPDesc,cKey, lDescM,cNumPed)

Local cKey 		:= ""
Local cKey2   := ""
Local cData   := DtoS(Date())
Local nDia   	:= Val(SubSTR(cData,7,2))
Local nMes  	:= Val(SubSTR(cData,5,2))
Local cSaldo  := ""
Local nValor 	:= 0
Local cVend := StrTran(cCodVend, '.', '')
/*****************************************************
 Parte de validação para o Pneu, armazém 05
 *****************************************************/
if (cCodArm == "05")
	// Pneu só libera senha por percentual
	nSaldo := 0
	
	nDescMax := SuperGetMV("MV_DESMPNE", , 10)
	
	if (nPDesc == 0)
	  Alert("Para o armazém 05 só pode ser gerada senha pelo percentual de desconto!")
		Return
	EndIf
	
	if (nPDesc > nDescMax) .And. (!lDescM)
		Alert("Desconto acima de " + AllTrim(STR(nDescMax)) + "% só poderá ser efetuado pela diretoria." + ; 
			chr(13) + chr(10) + "Informe-se com seu superior.")
		Return
	EndIf
EndIf

// caso nao tenha saldo, calcula pelo desconto informado
if nSaldo <= 0
  nSaldo := nPDesc
EndIf

cSaldo := AllTrim(Str(Iif(nSaldo > 0,nSaldo * 7, nSaldo * (-7)) * 100))

if (nDia < 10) 
  nDia += 30
EndIf
  
if (nMes < 10)
  nMes += 11
EndIf

cSaldo := AllTrim(Str((Val(cSaldo) + Val(AllTrim(cCodArm)) + Val(AllTrim(cVend))) * 7))

cKey := Str(nMes) + cSaldo + AllTrim(Str(nDia))
cKey := AllTrim(cKey)
nValor := (val(cKey) + (val(AllTrim(cNumPed)) * 731)) % 93791
cKey := Str(nValor)
cKey := AllTrim(cKey)

while (len(cKey) < 5)
  cKey := "0" + cKey
End Do

Return

/*********************************************************** 
 Funcao de geracao de senha que usa apenas concatenacao de string e soma
 devido ao uso da multiplicacao e arredondamento estar causando erro na 
 geracao de senha para o palm.
 ***********************************************************/
Static Function fGetSen2(cCodVend,cCodArm,nSaldo,nPDesc,cKey, lDescM)

Local cKey 		:= ""
Local cKey2   := ""
Local cData   := DtoS(Date())
Local nDia   	:= Val(SubSTR(cData,7,2))
Local nMes  	:= Val(SubSTR(cData,5,2))
Local cSaldo  := ""
Local nValor 	:= 0
Local nDescMax := 99
/*****************************************************
 Parte de validação para o Pneu, armazém 05
 *****************************************************/
if (cCodArm == "05")
	// Pneu só libera senha por percentual
	nSaldo := 0
	
	nDescMax := SuperGetMV("MV_DESMPNE")
	
	if (nPDesc == 0)
	  Alert("Para o armazém 05 só pode ser gerada senha pelo percentual de desconto!")
		Return
	EndIf
	
	if (nPDesc > nDescMax) .And. (!lDescM)
		Alert("Desconto acima de " + AllTrim(STR(nDescMax)) + "% só poderá ser efetuado pela diretoria." + ; 
			chr(13) + chr(10) + "Informe-se com seu superior.")
		Return
	EndIf
EndIf

// caso nao tenha saldo, calcula pelo desconto informado
if nSaldo <= 0
	nSaldo := nPDesc
EndIf

cSaldo := AllTrim(Str(Iif(nSaldo > 0,nSaldo, nSaldo * (-1)) * 1000))

if (nDia < 10) 
  nDia += 30
EndIf
  
if (nMes < 10)
  nMes += 11
EndIf

cSaldo := AllTrim(Str(Val(cSaldo) + Val(AllTrim(cCodArm))))

cKey := Str(nMes) + cSaldo + AllTrim(Str(nDia))
cKey := AllTrim(cKey)
cKey := StrZero(Val(cKey), 10)
cTmp := cKey
cKey := AllTrim(Str(val(SubStr(cTmp, 1, 1)) + val(SubStr(cTmp, 3, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 2, 1)) + val(SubStr(cTmp, 5, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 6, 1)) + val(SubStr(cTmp, 4, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 8, 1)) + val(SubStr(cTmp, 10, 1))))
cKey += AllTrim(Str(val(SubStr(cTmp, 9, 1)) + val(SubStr(cTmp, 7, 1))))
if len(cKey) > 5
  cKey := SubStr(cKey, Len(cKey) - 4, 5)
EndIf

cKey := AllTrim(cKey)

while (len(cKey) < 5)
  cKey := "0" + cKey
EndDo

Return