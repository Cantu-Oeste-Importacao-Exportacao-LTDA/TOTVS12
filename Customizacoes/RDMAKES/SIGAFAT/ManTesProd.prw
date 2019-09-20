#include "rwmake.ch" 
#include "Topconn.ch"
#include "Protheus.ch"
User Function ManTesProd()       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AxCadastro("ZZA")
Return Nil
                                           
// Função executada em gatilho que seta a tes do produto conforme configurações na ZZA
User Function SetTesPrd()
Local nPosProd:= aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})// para obter qual a posição do campo no acols do codigo do produto.
Local nPosTes := aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})// para obter qual a posição do campo no acols da tes.
Local nPosCFO := aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})// para obter qual a posição do campo no acols da tes.
Local cTesForaUF := ""
Local lUfDif := .F.
Local cUFsST := ""
Local cTesST := ""
Local cUFCli := ""
Local lFound := .F.
Local cCfop  := ""                                      
Local cTes   := ""
Local cUFsCP := ""
Local cTesCP := ""
Local aArea := GetArea()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

cUFCli := Posicione("SA1", 01, xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI, "A1_EST")
lUfDif := (cUFCli <> SM0->M0_ESTCOB)

SB1->(dbsetorder(01))
SB1->(dbSeek(xFilial("SB1") + aCols[N, nPosProd])) 


BEGINSQL alias "ZZATMP"
	SELECT ZZA_PRODUT, ZZA_GRUPO, ZZA_TESUFD, ZZA_TESST, ZZA_UFSST, ZZA_TESCRP, ZZA_UFSCRP FROM %TABLE:ZZA% ZZA
	WHERE ZZA_FILIAL = %XFILIAL:ZZA%
	AND (ZZA_GRUPO = %EXP:SB1->B1_GRUPO% OR ZZA_PRODUT = %EXP:SB1->B1_COD%)
	AND %NOTDEL%
	ORDER BY ZZA_PRODUT, ZZA_GRUPO
ENDSQL

/*ZZA->(dbSetOrder(01))
lFound := ZZA->(dbSeek(xFilial("ZZA") + SB1->B1_COD)) // por produto

if !lFound // por grupo
	ZZA->(dbSetOrder(02))
	lFound := ZZA->(dbSeek(xFilial("ZZA") + SB1->B1_GRUPO)) 
endIf*/
WHILE ZZATMP->(!Eof())
	//if (lFound)
	cTesForaUF := ZZATMP->ZZA_TESUFD
	cTesST := ZZATMP->ZZA_TESST
	cUFsST := ZZATMP->ZZA_UFSST
	cTesCP := ZZATMP->ZZA_TESCRP
	cUFsCP := ZZATMP->ZZA_UFSCRP
	//EndIf
	
	// Altera a tes caso a mesma tenha sido informada e a venda é para fora do estado.
	If lUfDif .And. !Empty(cTesForaUF)
		cTes := cTesForaUF
		aCols[N, nPosTes] := cTesForaUF
		ConOut("Mudou a tes do produto " + AllTrim(aCols[N, nPosProd]) + " para " + cTesForaUF)
	EndIf
	
	// avalia se deve mudar o tipo do cliente e a tes do produto quanto ao tratamento de ST para alguns produtos
	if (cUFCli $ cUFsST .And. !Empty(cTesST))
		M->C5_TIPOCLI := "S"
		cTes := cTesST
		aCols[N, nPosTes] := cTesST
		ConOut("Mudou a tes do produto " + AllTrim(aCols[N, nPosProd]) + " para " + cTesST)
	EndIf
	
	// avalia a troca da tes no credito presumido
	// Alert(cUFsCP)
	if (cUFCli $ cUFsCP .And. !Empty(cTesCP))
		cTes := cTesCP
		aCols[N, nPosTes] := cTesCP
		ConOut("Mudou a tes do produto " + AllTrim(aCols[N, nPosProd]) + " para " + cTesCP)
	EndIf
	
	// se mudou a tes, muda também o cfop conforme a tes
	if !Empty(cTes)
		SF4->(dbSetOrder(01))
		SF4->(dbSeek(xFilial("SF4") + cTes))
		cCfop := SF4->F4_CF
		if lUfDif
			cCfop := "6" + SubStr(SF4->F4_CF, 2, 3)
		else
			cCfop := "5" + SubStr(SF4->F4_CF, 2, 3)
		EndIf
		aCols[N, nPosCFO] := cCfop
	else
		cTes := aCols[N, nPosTes] // retorna o proprio conteúdo
	EndIf
	
	ZZATMP->(dbSkip())
EndDo
	
dbCloseArea("ZZATMP")

RestArea(aArea)

if Empty(cTes)
	cTes := aCols[N, nPosTes]
EndIF

Return cTes