#include "rwmake.ch"

User Function Frm001()

SetPrvt("NPERCICM,NVALFRETE,NBASFRETE,NVALICM,NCREDPRES,AITEMS")
SetPrvt("CCOMBO")     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Fun‡„o    ³FRM001    ³       ³                       ³ Data ³ 19.10.98 ³±±
//³Descri‡„o ³Formula para digitacao dos valores de frete e base de calc. ³±±
//³          ³Utilizado na mensagem da nota fiscal de Saida.              ³±±

nPercICM  := 7
nValFrete := 0
nBasFrete := 0
nValICM   := 0
nCredPres := 0
aItems    := {"Freteiro", "Transportadora"}
cCombo    := aItems[1]

@ 100, 100 To 300, 310 Dialog oDlg Title "Pedido " + SC5->C5_Num
@  10,  10 ComboBox cCombo Items aItems Size 50, 90
@  30,  10 Say "Valor do Frete"
@  40,  10 Say "Percentual ICMS"
@  50,  10 Say "Base de Calculo"
@  60,  10 Say "Valor do ICMS"
@  70,  10 Say "Credito Presumido" 
@  30,  55 Get nValFrete size 40,10  Picture "@E 9999999.99" Valid Calcula()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  30,  55 Get nValFrete   Picture "@E 9999999.99" Valid Execute(Calcula)
@  40,  55 Get nPercICM  size 40,10  Picture "@E 9999999.99" Valid nPercICM < 100 .And. Calcula()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  40,  55 Get nPercICM    Picture "@E 9999999.99" Valid nPercICM < 100 .And. Execute(Calcula)
@  50,  55 Get nBasFrete size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  50,  55 Get nBasFrete   Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  60,  55 Get nValICM   size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  60,  55 Get nValICM     Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  70,  55 Get nCredPres size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  70,  55 Get nCredPres   Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  85,  70 BmpButton Type 01 Action Close(oDlg)
Activate Dialog oDlg Centered

@ PRow() + 01,          00 PSay 'ICMS S/Frete Subs.Trib.Dec 3860/97 de 18.12.97'
@ PRow() + 01,          00 PSay 'Vlr Frete:'
@ PRow() + 00, PCol() + 02 PSay AllTrim(Transform(nValFrete, '@E 999999.99'))
@ PRow() + 00, PCol() + 02 PSay 'B.Calc:'
@ PRow() + 00, PCol() + 02 PSay AllTrim(Transform(nBasFrete, '@E 999999.99'))
@ PRow() + 00, PCol() + 02 PSay 'Vlr. ICMS:'
@ PRow() + 00, PCol() + 02 PSay AllTrim(Transform(nValICM,   '@E 999999.99'))

If nCredPres > 0
  @ PRow() + 01,          00 PSay 'Cred.Presumido: R$'
  @ PRow() + 00, PCol() + 02 PSay AllTrim(Transform(nCredPres, '@E 999999.99'))
  @ PRow() + 00, PCol() + 02 PSay 'Cfe Art.51 Inc X do RICMS-PR'
EndIf

RecLock("SF2", .F.)
	SF2->F2_FRETE   := nValFrete
	SF2->F2_ICMFRET := nValICM	
MsUnlock("SF2")

Return

Static Function Calcula()
nBasFrete := nValFrete
nValICM   := IIf(aScan(aItems, cCombo) == 1, (nBasFrete * 0.8), nBasFrete)
nValICM   := nValICM * (nPercICM / 100)
nCredPres := IIf(aScan(aItems, cCombo) == 1, nBasFrete * (nPercICM / 100), 0)
nCredPres := IIf(aScan(aItems, cCombo) == 1, nCredPres - nValICM, 0)
Return(.T.)


User Function Frm002()
Local cResult := ""
SetPrvt("NPERCICM,NVALFRETE,NBASFRETE,NVALICM,NCREDPRES,AITEMS")
SetPrvt("CCOMBO")                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//³Fun‡„o    ³FRM001    ³       ³                       ³ Data ³ 19.10.98 ³±±
//³Descri‡„o ³Formula para digitacao dos valores de frete e base de calc. ³±±
//³          ³Utilizado na mensagem da nota fiscal de Saida.              ³±±

nPercICM  := 7
nValFrete := 0
nBasFrete := 0
nValICM   := 0
nCredPres := 0
aItems    := {"Freteiro", "Transportadora"}
cCombo    := aItems[1]

@ 100, 100 To 300, 310 Dialog oDlg Title "Pedido " + SC5->C5_Num
@  10,  10 ComboBox cCombo Items aItems Size 50, 90
@  30,  10 Say "Valor do Frete"
@  40,  10 Say "Percentual ICMS"
@  50,  10 Say "Base de Calculo"
@  60,  10 Say "Valor do ICMS"
@  70,  10 Say "Credito Presumido" 
@  30,  55 Get nValFrete size 40,10  Picture "@E 9999999.99" Valid Calcula()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  30,  55 Get nValFrete   Picture "@E 9999999.99" Valid Execute(Calcula)
@  40,  55 Get nPercICM  size 40,10  Picture "@E 9999999.99" Valid nPercICM < 100 .And. Calcula()// Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  40,  55 Get nPercICM    Picture "@E 9999999.99" Valid nPercICM < 100 .And. Execute(Calcula)
@  50,  55 Get nBasFrete size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  50,  55 Get nBasFrete   Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  60,  55 Get nValICM   size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  60,  55 Get nValICM     Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  70,  55 Get nCredPres size 40,10  Picture "@E 9999999.99" Valid Calcula() When .F.  // Substituido pelo assistente de conversao do AP5 IDE em 10/05/01 ==> @  70,  55 Get nCredPres   Picture "@E 9999999.99" Valid Execute(Calcula) When '.F.'
@  85,  70 BmpButton Type 01 Action Close(oDlg)
Activate Dialog oDlg Centered

cResult := 'ICMS S/Frete Subs.Trib.Dec 3860/97 de 18.12.97. '
cResult += 'Vlr Frete: ' + AllTrim(Transform(nValFrete, '@E 999999.99')) + ". "
cResult += 'B.Calc: ' + AllTrim(Transform(nBasFrete, '@E 999999.99')) + ". Vlr. ICMS:" + AllTrim(Transform(nValICM,   '@E 999999.99'))

If nCredPres > 0
   cResult += '. Cred.Presumido: R$' + AllTrim(Transform(nCredPres, '@E 999999.99'))  + ' Cfe Art.51 Inc X do RICMS-PR'
EndIf

RecLock("SF2", .F.)
	SF2->F2_FRETE   := nValFrete
	SF2->F2_ICMFRET := nValICM
MsUnlock("SF2")

Return cResult