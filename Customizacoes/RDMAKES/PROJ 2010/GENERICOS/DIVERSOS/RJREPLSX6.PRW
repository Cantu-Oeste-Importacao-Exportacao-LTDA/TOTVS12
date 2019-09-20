#include "rwmake.ch"
#include "PROTHEUS.CH"
                        
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao	 ³ RJREPLSX6³ Autor ³ Cleber DP             ³ Data ³ 16/12/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ajusta conteudo dos parametros SX6 conforme planilha pre   ³±±
±±³          ³ configurada.                                               ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ RJU      												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

*------------------------------*
User Function RJREPLSX6()
*------------------------------*                            

Private cArqTxt := "d:\ajustapar.txt"
Private nHdl    := fOpen(cArqTxt,68) 
Private aLin    := {}  // array de linhas do arquivo
Private cEOL    := CHR(13)+CHR(10)
Private cLog    := ""   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

/*
Programa para replicar os parametros que sao compartilhados entre as empresas

Planilha Excel conforme MIT043
------------------------------
Deve conter somente os parametros que sao COMPARTILHADOS
Nome Parametro / Conteudo

Percorre todas as empresas SIGAMAT

Pega parametro e verifica a filial
= Compartilhado
  Altera o conteudo

= Exclusivo
  Deixa um e altera para compartilhado
  Altera o conteudo
  Deleta o restante que esta exclusivo

Se nao existir o parametro, cria LOG para incluir manualmente

Parametros exclusivos nao devem estar na planilha e serao tratados manualmente pelos analistas
*/

If MsgBox("Executar ajuste do SX6 para parametros compartilhados?","Atenção","YESNO")
	Processa( {|| fProc() })
EndIf

Return


//******************************************************************************
Static Function fProc()

If !LeArquivo()
	Return
End

cLog := "AJUSTA PARAMETROS SX6" +cEOL
cLog += "EMPRESA: "+ SM0->M0_CODIGO +cEOL
cLog += cEOL
cLog += "<INICIO>" +cEOL

For i := 1 to Len(aLin)
	AjustaSX6(aLin[i,1], aLin[i,2])
Next

cLog += "<FIM>" +cEOL

cArqLog := "d:\rjreplsx6_"+ SM0->M0_CODIGO +".log"
MemoWrite(cArqLog, cLog)
MsgInfo("Arquivo de log gerado: " +cArqLog+" !","TOTVS")
	
Return


//******************************************************************************
Static Function LeArquivo()

Local nTamFile, nTamLin, cBuffer, nP, cCar
Local cNomePar, cContPar, lParte1

If nHdl == -1
    MsgAlert("O arquivo "+ cArqTxt +" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return .F.
Endif

cBuffer := MemoRead(cArqTxt)
/*
nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := nTamFile+Len(cEOL)
cBuffer  := Space(nTamLin) 

// Leitura do arquivo texto
fRead(nHdl,@cBuffer,nTamLin) 
*/
lParte1 := .T.
cNomePar := ""
cContPar := ""

// Ex:   MV_CBASEAF;"NFE0000001"
//       MV_CBASXXX;"NFE9999999"
For nP := 1 to Len(cBuffer)
	cCar := Substr(cBuffer,nP,1)
	If lParte1
		If cCar <> ";"
			cNomePar := cNomePar + cCar
		Else
			lParte1 := .F.
		End
	Else
		If cCar <> CHR(10)
			If cCar $ " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,:;-_=+()[]{}<>/\|?!@#$%^&*~`'"+'"'
				cContPar := cContPar + cCar
			End
		Else
			If AllTrim(cNomePar) <> ""
				While Len(cNomePar) < 10
					cNomePar := cNomePar + " "
				Enddo
				cContPar := AllTrim(cContPar) + Replicate(" ", 250-Len(AllTrim(cContPar)))
				
				aAdd(aLin, {cNomePar, OemToAnsi(cContPar)})
				lParte1 := .T.
				cNomePar := ""
				cContPar := ""
			End
		End
	End
	
	IncProc()
Next nP

fClose(nHdl)

Return .T.


//******************************************************************************
Static Function AjustaSX6(cNomePar, cContPar)

DbSelectArea("SX6")
DbSetOrder(1)

Set Filter To X6_VAR = cNomePar
DbGoTop()

If SX6->(EOF())
	cLog += "Parametro nao encontrado -->    "+ cNomePar +cEOL
Else
	lFirst := .T.
	While SX6->(!EOF())
		// Altera o primeiro registro encontrado (compartilhado)
		If lFirst
			//If X6_CONTEUD <> cContPar
				cLog += "Parametro Alterado       --> "+ X6_FIL +" "+ X6_VAR +" = "+ cContPar +cEOL
				RecLock("SX6",.F.)
				SX6->X6_FIL     := "  "
				SX6->X6_CONTEUD := cContPar
				SX6->X6_CONTSPA := cContPar
				SX6->X6_CONTENG := cContPar
				MsUnlock()
				lFirst := .F.
			//End
		Else
			// Deleta demais registros (exclusivos por filial)
			RecLock("SX6",.F.)
			dbDelete()
			MsUnlock()
			cLog += "Parametro Excluido       --> "+ X6_FIL +" "+ X6_VAR +cEOL
		End
		
		dbSkip()
	EndDo
End
Set Filter To 

Return

