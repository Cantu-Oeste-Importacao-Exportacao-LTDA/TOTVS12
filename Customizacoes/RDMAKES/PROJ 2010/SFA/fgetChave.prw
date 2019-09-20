#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ FGETCHAV            ³Autor ³ Microsiga    ³ Data ³30/01/08 ³±±
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
User Function FGETCHAV()

Local oDlgKey
Local cKey     := "" 
Local cCodVend := Space(6)
Local cCodArm  := Space(2)
Local nSaldo   := 0
Local nPDesc   := 0   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

DEFINE MSDIALOG oDlgKey TITLE "Gerador de Chave  - SFA" FROM 150,250 TO 390,500 OF GetWndDefault() PIXEL

@ 010,010 SAY "Vendedor: " PIXEL OF oDlgKey
@ 008,065 MSGET cCodVend SIZE 45,10 F3 "SA3" PIXEL OF oDlgKey

@ 024,010 SAY "Armazem: " PIXEL OF oDlgKey
@ 022,065 MSGET cCodArm  SIZE 45,10 F3 "SZA" PIXEL OF oDlgKey

@ 038,010 SAY "Saldo do Armazem:  -" PIXEL OF oDlgKey
@ 036,065 MSGET nSaldo Picture "999999.99"  SIZE 40,10 PIXEL OF oDlgKey

@ 052,010 SAY "Desconto do Pedido:  -" PIXEL OF oDlgKey
@ 050,065 MSGET nPDesc Picture "999999.99"  SIZE 40,10 PIXEL OF oDlgKey


@ 076, 010 SAY "Data Atual: " + DtoC(Date()) PIXEL OF oDlgKey

@ 085,010 SAY "Chave:" PIXEL OF oDlgKey
@ 083,050 MSGET cKey SIZE 55,10 PIXEL OF oDlgKey WHEN .F.

@ 100,040 BMPBUTTON TYPE 1 ACTION (fGetSenh(cCodVend,cCodArm,nSaldo,nPDesc,@cKey),oDlgKey:Refresh())
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
Static Function fGetSenh(cCodVend,cCodArm,nSaldo,nPDesc,cKey)

Local cKey 		:= ""
Local cKey2   := ""
Local cData   := DtoS(Date())
Local nDia   	:= Val(SubSTR(cData,7,2))
Local nMes  	:= Val(SubSTR(cData,5,2))
Local cSaldo  := ""
Local nValor 	:= 0;

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

cSaldo := AllTrim(Str(Val(cSaldo) + Val(AllTrim(cCodArm))))

cKey := Str(nMes) + cSaldo + AllTrim(Str(nDia))
cKey := AllTrim(cKey)
nValor := val(cKey) % 93791
cKey := Str(nValor)
cKey := AllTrim(cKey)

while (len(cKey) < 5)
  cKey := "0" + cKey
End Do

Return