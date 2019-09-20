#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

// Replicar Tabela customizada de prefixos Z1 da empresa 50 Filial 01 (SX5500)
// para todas as empresas/filiais cadastradas no SIGAMAT.EMP.
// Adriano 
*--------------------------*
User Function IncPref()
*--------------------------*
	MsAguarde( {|| ProcSer("Z1")}, "Aguarde...", "Processando dados..." )
Return

User Function ReplSX5()
Local oDlg
Local cTab := Space(4)   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

@ 100, 100 To 250, 310 Dialog oDlg Title "Replica SX5"
@  30,  10 Say "Tabela do SX5 " 
@  30,  55 Get cTab size 40,10  Picture "@!" 
@  50,  30 BmpButton Type 01 Action ProcSer(AllTrim(cTab))
@  50,  75 BmpButton Type 02 Action Close(oDlg)
ACTIVATE DIALOG oDlg CENTERED

Return Nil


Static Function ProcSer(cTab)
Local aSerie	:= {}
Local aDADOSEMP	:= {}
Local cEMPATU 	:= cEmpAnt
Local cFILATU 	:= cFilAnt
Local cMODIMP 	:= "FAT"
Local aTabX5    := {}

If cEmpAnt <> '50'
	MsgAlert("Deve estar posicionado na empresa 50 Filial 01.")
	Return
Endif

SX5->(DbSelectArea("SX5"))
SX5->(DbSetOrder(1))      
SX5->(DbGotop())

aTabX5 := {}

if SX5->(DbSeek(xFilial("SX5")+"00" + PadR(cTab, 6, ' ')))
	aTabX5 := {SX5->X5_CHAVE, SX5->X5_DESCRI, SX5->X5_DESCSPA, SX5->X5_DESCENG}
EndIf

SX5->(DbSeek(xFilial("SX5")+cTab))  
While !SX5->(Eof()) .AND. SX5->X5_FILIAL == '01' .AND. SX5->X5_TABELA ==  cTab 
	aAdd(aSerie,{SX5->X5_CHAVE,SX5->X5_DESCRI})
	SX5->(DbSkip())
End
If Len(aSerie) > 0
	dbSelectArea("SM0")
	aAreaSM0 := SM0->(GetArea())
	SM0->(dbSetOrder(1))
	SM0->(dbGoTop())
	While ! SM0->(EOF())
		If SM0->M0_CODIGO != "00"
			nPOS := aScan ( aDADOSEMP, { |x| x[1] == SM0->M0_CODIGO } )
			If nPOS == 0
				aAdd ( aDADOSEMP, { SM0->M0_CODIGO, SM0->M0_CODFIL } )
			EndIf
		EndIf
		SM0->(dbSkip())
	Enddo
	RestArea(aAreaSM0)

	For nR := 1 To Len(aDADOSEMP)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Prepara ambiente/módulo                                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		dbSelectArea("SM0")
		dbSetOrder(1)
		If !dbSeek ( aDADOSEMP[nR][01] )
			Alert("Empresa "+aDADOSEMP[nR][01]+" não existente no SIGAMAT.")
			Loop   
		EndIf
		
		RpcClearEnv()
		RPCSetType(3)
		                                              
		PREPARE ENVIRONMENT EMPRESA (aDADOSEMP[nR][01]) FILIAL (aDADOSEMP[nR][02]) MODULO cMODIMP 
		
		
		dbSelectArea("SM0")
		aAreaSM0 := SM0->(GetArea())
		SM0->(dbSetOrder(1))
		SM0->(dbGoTop())
		SM0->(dbSeek(aDADOSEMP[nR][01]))
		//MsgInfo("Empresa "+SM0->M0_CODIGO+" Filial "+SM0->M0_CODFIL)
		While !SM0->(EOF()) .and. SM0->M0_CODIGO == aDADOSEMP[nR][01]
			SX5->(dbSelectArea("SX5"))
			SX5->(dbSetOrder(1))
			SX5->(dbGoTop())
			
			// Verifica se a tabela 00 existe e caso não exista cria a mesma
			if len(aTabX5) > 0 .And. SX5->(!DbSeek(SM0->M0_CODFIL+"00" + PadR(cTab, 6, ' ')))
				SX5->(RecLock("SX5",.T.))
						SX5->X5_FILIAL := SM0->M0_CODFIL
						SX5->X5_TABELA	:= "00"
						SX5->X5_CHAVE	:= aTabX5[1]
						SX5->X5_DESCRI	:= aTabX5[2]
						SX5->X5_DESCSPA	:= aTabX5[3]
						SX5->X5_DESCENG	:= aTabX5[4]
				SX5->(MsUnLock())
			EndIf			

			For nE := 1 To Len(aSerie)
				SX5->(dbSelectArea("SX5"))
				SX5->(dbSetOrder(1))
				SX5->(dbGoTop())
				If !SX5->(dbSeek( SM0->M0_CODFIL + cTab + aSerie[nE,1] )) 
					SX5->(RecLock("SX5",.T.))
						SX5->X5_FILIAL := SM0->M0_CODFIL
						SX5->X5_TABELA	:= cTab
						SX5->X5_CHAVE	:= aSerie[nE,1]
						SX5->X5_DESCRI	:= aSerie[nE,2]
						SX5->X5_DESCSPA	:= aSerie[nE,2]
						SX5->X5_DESCENG	:= aSerie[nE,2]
					SX5->(MsUnLock())
				Endif
			Next nE
			dbSelectArea("SM0")
			SM0->(dbSkip())
		Enddo
		RestArea(aAreaSM0)
	Next nR
	RpcClearEnv()
	RPCSetType(3)
	                                              
	PREPARE ENVIRONMENT EMPRESA (cEMPATU) FILIAL (cFILATU) MODULO cMODIMP 	
	RestArea(aAreaSM0)
Endif

MsgInfo("processo concluido!")	
Return