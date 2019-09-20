#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �INFADVIN  �Autor  �Jean Carlos Saggin  � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de informa��es adicionais do vinho.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�ficos Cantu                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function InfAdVin()

Static oDlgVin
Static oBtnSa2
Static oBtnSa3
Static oBtnSa3
Static oBtnSal
Static oBtnAro
Static oBtnClose
Static oBtnEx2
Static oBtnEx3
Static oBtnEx4
Static oBtnExc
Static oBtnHar
Static oBtnPre
Static oBtnTip
Static oBtnUvas
Static oGroup1
Static oGrpAro
Static oGrpCad
Static oGrpCom
Static oGrpGer
Static oGrpPre

Private oGetHar
Private oGetCom
Private oGetAro
Private oGetPre
Private aOldHar
Private aOldCom
Private aOldAro
Private aOldPre       

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())        

  DEFINE MSDIALOG oDlgVin TITLE "INFORMACOES ADICIONAIS DO VINHO" FROM 000, 000  TO 550, 1100 COLORS 0, 16777215 PIXEL

    @ 001, 002 GROUP oGrpGer TO 273, 547 OF oDlgVin COLOR 0, 16777215 PIXEL
    
    @ 006, 008 GROUP oGrpCad TO 093, 130 PROMPT "  Cadastros B�sicos   " OF oGrpGer COLOR 0, 16777215 PIXEL
    @ 042, 011 BUTTON oBtnUvas PROMPT "&Uvas"            SIZE 056, 022 OF oGrpCad ACTION U_MANZB2() PIXEL
    @ 068, 011 BUTTON oBtnAro  PROMPT "A&romas"          SIZE 056, 022 OF oGrpCad ACTION U_MANZB4() PIXEL
    @ 016, 069 BUTTON oBtnTip  PROMPT "&Tipos de Vinhos" SIZE 056, 022 OF oGrpCad ACTION U_MANZA8() PIXEL
    @ 042, 069 BUTTON oBtnPre  PROMPT "&Premia��es"      SIZE 056, 022 OF oGrpCad ACTION U_MANZB6() PIXEL
    @ 016, 011 BUTTON oBtnHar  PROMPT "&Harmoniza��es"   SIZE 056, 022 OF oGrpCad ACTION U_MANZB1() PIXEL
    
    @ 006, 132 GROUP oGroup1 TO 093, 318 PROMPT "  Harmoniza��es do Vinho  " OF oGrpGer COLOR 0, 16777215 PIXEL
    @ 077, 238 BUTTON oBtnSal PROMPT "&Salvar"  SIZE 037, 012 OF oGroup1 ACTION SAVZB5() PIXEL
    @ 077, 277 BUTTON oBtnExc PROMPT "&Excluir" SIZE 037, 012 OF oGroup1 ACTION EXCZB5() PIXEL
    fGetHar()
    
    @ 006, 320 GROUP oGrpCom TO 093, 541 PROMPT "  Composi��o do Vinho  " OF oGrpGer COLOR 0, 16777215 PIXEL
    @ 077, 461 BUTTON oBtnSa2 PROMPT "Sa&lvar" SIZE 037, 012 OF oGrpCom ACTION SAVZB3() PIXEL    
    @ 077, 500 BUTTON oBtnEx2 PROMPT "Excluir" SIZE 037, 012 OF oGrpCom ACTION EXCZB3() PIXEL
    fGetCom()
    
    @ 095, 008 GROUP oGrpAro TO 182, 235 PROMPT "  Aromas do Vinho  " OF oGrpGer COLOR 0, 16777215 PIXEL
    @ 165, 155 BUTTON oBtnSa3 PROMPT "Sal&var" SIZE 037, 012 OF oGrpAro ACTION SAVZB8() PIXEL
    @ 165, 194 BUTTON oBtnEx3 PROMPT "Excluir" SIZE 037, 012 OF oGrpAro ACTION EXCZB8() PIXEL
    fGetAro()
    
    @ 095, 238 GROUP oGrpPre TO 182, 541 PROMPT "  Premia��es x Vinho x Safra  " OF oGrpGer COLOR 0, 16777215 PIXEL
    @ 165, 461 BUTTON oBtnSa4 PROMPT "Salvar"  SIZE 037, 012 OF oGrpPre ACTION SAVZB7() PIXEL                                      
    @ 165, 500 BUTTON oBtnEx4 PROMPT "Excluir" SIZE 037, 012 OF oGrpPre ACTION EXCZB7() PIXEL
    fGetPre()
    
    @ 246, 478 BUTTON oBtnClose PROMPT "&Fechar" SIZE 064, 023 OF oGrpGer ACTION oDlgVin:End() PIXEL
  
  ACTIVATE MSDIALOG oDlgVin CENTERED

Return

//������������������������������������������������������������������
//�Fun��o que far� a montagem e atualiza��o do grid de Harmoniza��es�
//������������������������������������������������������������������

Static Function fGetHar()

Local nX
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFields      := {"ZB5_CODARM", "ZB5_DESARM"}
Local aAlterFields := {"ZB5_CODARM"}

	//���������������������������������Ŀ
	//�Define as propriedades dos campos�
	//�����������������������������������
	
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
	//��������������������������������������Ŀ
	//�Carrega Armoniza��es do vinho no grid.�
	//����������������������������������������
	
	aColsEx := {}
	
	DbSelectArea("ZB5")
	ZB5->(DbSetOrder(2))
	if DbSeek(xFilial("ZB5") + SB1->B1_COD)
		While !ZB5->(EOF()) .and. (ZB5->ZB5_FILIAL + ZB5->ZB5_CODVIN == xFilial("ZB5") + SB1->B1_COD)
			aAdd(aColsEx, {ZB5->ZB5_CODARM, ZB5->ZB5_DESARM, .F.})
			ZB5->(DBSkip())
		EndDo
	EndIf
  
  aOldHar := aClone(aColsEx)

  oGetHar := MsNewGetDados():New( 014, 135, 075, 315, GD_INSERT + GD_UPDATE, "U_ZB5LOK()", "U_ZB5TOK()", " ", aAlterFields,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgVin, aHeaderEx, aColsEx)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB5LOK  �Autor  �Jean Carlos Saggin    � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida��o da linha do grid na tabela ZB5                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB5LOK()

Local lRet    := .T.
Local nX      := 0
Local aCols   := oGetHar:aCols
Local aHeader := oGetHar:aHeader
Local nLinha  := oGetHar:nAt
Local nPosCod := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB5_CODARM"})

//���������������������������������������Ŀ
//�Avalia duplica��o de registros no grid.�
//�����������������������������������������

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		If (aCols[nLinha, nPosCod] == aCols[nX, nPosCod]) .and. (nLinha != nX)
			lRet := .F.
			MsgAlert("A harmoniza��o "+ aCols[nLinha, nPosCod] +" j� est� vinculada a esse vinho!")
		EndIf
	EndIf
Next nX

Return lRet 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB5TOK  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida dados de todo o grid da ZB5                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB5TOK()

Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local aCols   := oGetHar:aCols
Local aHeader := oGetHar:aHeader
Local nPosCod := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB5_CODARM"})

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		for nY := 1 to Len(aCols)
			If (aCols[nX, nPosCod] == aCols[nY, nPosCod]) .and. (nX != nY) .and. aCols[nX, Len(aHeader)+1] != .T.
				lRet := .F.
				MsgAlert("A harmoniza��o "+ aCols[nY, nPosCod] +" foi vinculada mais que uma vez ao mesmo vinho!")
			EndIf
		Next nY
	EndIf
Next nX

Return lRet 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCZB5  �Autor  �Jean Carlos Saggin    � Data �  08/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de exclus�o de registros da tabela ZB5              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EXCZB5()

Local nLinha  := oGetHar:nAt         

oGetHar:aCols[nLinha, Len(oGetHar:aHeader)+1] := !oGetHar:aCols[nLinha, Len(oGetHar:aHeader)+1] // Seta a linha como (des)deletada
oGetHar:ForceRefresh()

Return     

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SAVZB5  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para salvar dados na tabela ZB5                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SAVZB5()

Local nX      := 0
Local lFound  := .F.
Local aCols   := oGetHar:aCols
Local aHeader := oGetHar:aHeader
Local nPosCod := 0

nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB5_CODARM"})

for nX := 1 to Len(aCols)

	DbSelectArea("ZB5")
	ZB5->(DbSetOrder(1))
  
	if Len(aOldHar) >= nX
		if aOldHar[nX, nPosCod] != aCols[nX, nPosCod]
			If DbSeek(xFilial("ZB5") + aOldHar[nX, nPosCod] + SB1->B1_COD)
		 		RecLock("ZB5", .F.)
				ZB5->ZB5_CODARM := aCols[nX, nPosCod]
				ZB5->ZB5_DESARM := Posicione("ZB1", 1, xFilial("ZB1") + aCols[nX, nPosCod], "ZB1_DESC")
		 		ZB5->(MsUnlock())
			EndIf
		EndIf
	EndIf
	
	if aCols[nX, Len(aHeader)+1] != .T.
		If !DbSeek(xFilial("ZB5") + aCols[nX, nPosCod] + SB1->B1_COD)
			RecLock("ZB5", .T.)
			ZB5->ZB5_FILIAL := xFilial("ZB5")
			ZB5->ZB5_CODARM := aCols[nX, nPosCod]
			ZB5->ZB5_DESARM := Posicione("ZB1", 1, xFilial("ZB1") + aCols[nX, nPosCod], "ZB1_DESC")
			ZB5->ZB5_CODVIN := SB1->B1_COD
			ZB5->ZB5_DESVIN := SubStr(SB1->B1_DESC, 01, TamSx3("ZB5_DESVIN")[1])
			ZB5->(MsUnlock())
		EndIf
	Else
		If DbSeek(xFilial("ZB5") + aCols[nX, nPosCod] + SB1->B1_COD)
			RecLock("ZB5", .F.)
			ZB5->(DbDelete())
			ZB5->(MsUnlock())	
		EndIf	
	EndIf	
Next nX

oGetHar:ForceRefresh()
aOldHar := aClone(oGetHar:aCols)

Return

//������������������������������������������������������������Ŀ
//�Fun��o que far� a atualiza��o do grid de Composi��o do Vinho�
//��������������������������������������������������������������

Static Function fGetCom()

Local nX
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFields      := {"ZB3_CODUVA", "ZB3_DESUVA","ZB3_PERCEN"}
Local aAlterFields := {"ZB3_CODUVA","ZB3_PERCEN"}

  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
	//�����������������������������������������������Ŀ
	//�Popula os dados de composi��o do vinho no grid.�
	//�������������������������������������������������
	
	aColsEx := {}
	
	DbSelectArea("ZB3")
	ZB3->(DbSetOrder(1))
	If DbSeek(xFilial("ZB3") + SB1->B1_COD)
		While !ZB3->(EOF()) .and. (ZB3->ZB3_FILIAL + ZB3->ZB3_COD == xFilial("ZB3") + SB1->B1_COD)
			aAdd(aColsEx, {ZB3->ZB3_CODUVA,; 
										 Posicione("ZB2", 1, xFilial("ZB2") + ZB3->ZB3_CODUVA, "ZB2_DESCRI"),; 
										 ZB3->ZB3_PERCEN,; 
										 .F.})
			ZB3->(DbSkip())
		EndDo
	EndIf
  
  aOldCom := aClone(aColsEx)

  oGetCom := MsNewGetDados():New( 014, 324, 075, 538, GD_INSERT+GD_UPDATE, "U_ZB3LOK()", "U_ZB3TOK()", "", aAlterFields,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgVin, aHeaderEx, aColsEx)

Return  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB3LOK  �Autor  �Jean Carlos Saggin    � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar linha na tabela ZB3                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB3LOK()

Local lRet    := .T.
Local nX      := 0
Local aCols   := oGetCom:aCols
Local aHeader := oGetCom:aHeader
Local nLinha  := oGetCom:nAt
Local nPosCod := 0          
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB3_CODUVA"})

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//���������������������������������������Ŀ
//�Avalia duplica��o de registros no grid.�
//�����������������������������������������

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		If (aCols[nLinha, nPosCod] == aCols[nX, nPosCod]) .and. (nLinha != nX)
			lRet := .F.
			MsgAlert("A uva "+ aCols[nLinha, nPosCod] +" j� est� vinculada a esse vinho!")
		EndIf
	EndIf
Next nX

Return lRet    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB3TOK  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida o grid da tabela ZB3                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB3TOK()

Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local aCols   := oGetCom:aCols
Local aHeader := oGetCom:aHeader
Local nPosCod := 0
Local nPosPer := 0
Local nTotPer := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB3_CODUVA"})
nPosPer := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB3_PERCEN"})

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		
		nTotPer += aCols[nX, nPosPer]    
		
		for nY := 1 to Len(aCols)
			If (aCols[nX, nPosCod] == aCols[nY, nPosCod]) .and. (nX != nY) .and. aCols[nX, Len(aHeader)+1] != .T.
				lRet := .F.
				MsgAlert("A uva "+ aCols[nY, nPosCod] +" foi vinculada mais que uma vez a esse vinho!")
			EndIf
		Next nY
		
		if (aCols[nX, nPosPer] <= 0) .or. (aCols[nX, nPosPer] > 100)
				lRet := .F.
				MsgAlert("Informe o % para a uva "+ aCols[nY, nPosCod] +" na composi��o do vinho!")			
		EndIf
	EndIf
Next nX

If nTotPer != 100
	lRet := .F.
	MsgAlert("A soma dos percentuais das uvas que comp�em o vinho deve totalizar 100%, caso contr�rio, os dados n�o poder�o ser gravados!")				
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCZB3  �Autor  �Jean Carlos Saggin    � Data �  08/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de exclus�o de registros da tabela ZB3              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EXCZB3()

Local nLinha  := oGetCom:nAt         

oGetCom:aCols[nLinha, Len(oGetCom:aHeader)+1] := !oGetCom:aCols[nLinha, Len(oGetCom:aHeader)+1] // Seta a linha como (des)deletada
oGetCom:ForceRefresh()

Return    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SAVZB3  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para salvar dados na tabela ZB3                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SAVZB3()

Local nX      := 0
Local lFound  := .F.
Local aCols   := oGetCom:aCols
Local aHeader := oGetCom:aHeader
Local nPosCod := 0
Local nPosPer := 0

nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB3_CODUVA"})
nPosPer := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB3_PERCEN"})

//��������������������������������������������������Ŀ
//�Valida o grid antes de realizar qualquer altera��o�
//����������������������������������������������������

If !U_ZB3TOK()
	Return
EndIf

for nX := 1 to Len(aCols)

	DbSelectArea("ZB3")
	ZB3->(DbSetOrder(1))
 
	//������������������������������������������������������������������Ŀ
	//�Valida os dados antigos pra ver se algum registro n�o foi alterado�
	//��������������������������������������������������������������������

	if Len(aOldCom) >= nX
		if aOldCom[nX, nPosCod] != aCols[nX, nPosCod]
			If DbSeek(xFilial("ZB3") + SB1->B1_COD + aOldCom[nX, nPosCod])
		 		RecLock("ZB3", .F.)
				ZB3->ZB3_CODUVA := aCols[nX, nPosCod]
		 		ZB3->(MsUnlock())
			EndIf
		EndIf
	EndIf
	
	if aCols[nX, Len(aHeader)+1] != .T.
	
		//�����������������������������������������������������������Ŀ
		//�Valida se a uva j� comp�e o vinho antes de fazer a inclus�o�
		//�������������������������������������������������������������
		
		If !DbSeek(xFilial("ZB3") + SB1->B1_COD + aCols[nX, nPosCod])
			RecLock("ZB3", .T.)
			ZB3->ZB3_FILIAL := xFilial("ZB3")
			ZB3->ZB3_CODUVA := aCols[nX, nPosCod]
			ZB3->ZB3_COD    := SB1->B1_COD
			ZB3->ZB3_PERCEN := aCols[nX, nPosPer]
			ZB3->(MsUnlock())
		Else
			
			//����������������������������������������������������������Ŀ
			//�Valida se apenas o percentual est� diferente do cadastrado�
			//������������������������������������������������������������
			
			If ZB3->ZB3_PERCEN != aCols[nX, nPosPer]
				RecLock("ZB3", .F.)
				ZB3->ZB3_PERCEN := aCols[nX, nPosPer]
				ZB3->(MsUnlock())	
			EndIf
		EndIf
	Else
		
		//�������������������������������Ŀ
		//�Valida se foi deletado no grid.�
		//���������������������������������
		
		If DbSeek(xFilial("ZB3") + SB1->B1_COD + aCols[nX, nPosCod])
			RecLock("ZB3", .F.)
			ZB3->(DbDelete())
			ZB3->(MsUnlock())	
		EndIf	
	EndIf	
Next nX

oGetCom:ForceRefresh()
aOldCom := aClone(oGetCom:aCols)

Return

//��������������������������������������������������������Ŀ
//�Fun��o que far� a atualiza��o do grid de Aromas do Vinho�
//����������������������������������������������������������

Static Function fGetAro()

Local nX
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFields      := {"ZB8_CODARO","ZB8_DESARO"}
Local aAlterFields := {"ZB8_CODARO"}

  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX
  
  aColsEx := {}
  
  DbSelectArea("ZB8")
  ZB8->(DbSetOrder(2))
  If DbSeek(xFilial("ZB8") + SB1->B1_COD)
  	While !ZB8->(EOF()) .and. (ZB8->ZB8_FILIAL + ZB8->ZB8_CODVIN == xFilial("ZB8") + SB1->B1_COD)
  		aAdd(aColsEx, {ZB8->ZB8_CODARO, Posicione("ZB4", 1, xFilial("ZB4") + ZB8->ZB8_CODARO, "ZB4_DESARO"), .F.})
  		ZB8->(DbSkip())
  	EndDo
  EndIf
  
  aOldAro := aClone(aColsEx)
	
  oGetAro := MsNewGetDados():New( 103, 010, 163, 232, GD_INSERT+GD_UPDATE, "U_ZB8LOK()", "U_ZB8TOK()", "", aAlterFields,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgVin, aHeaderEx, aColsEx)

Return   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB8LOK  �Autor  �Jean Carlos Saggin    � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar linha na tabela ZB8                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB8LOK()

Local lRet    := .T.
Local nX      := 0
Local aCols   := oGetAro:aCols
Local aHeader := oGetAro:aHeader
Local nLinha  := oGetAro:nAt
Local nPosCod := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB8_CODARO"})

//���������������������������������������Ŀ
//�Avalia duplica��o de registros no grid.�
//�����������������������������������������

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		If (aCols[nLinha, nPosCod] == aCols[nX, nPosCod]) .and. (nLinha != nX)
			lRet := .F.
			MsgAlert("O aroma "+ aCols[nLinha, nPosCod] +" j� est� relacionado a esse vinho!")
		EndIf
	EndIf
Next nX

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB8TOK  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida dados de todo o grid da ZB8                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB8TOK()

Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local aCols   := oGetAro:aCols
Local aHeader := oGetAro:aHeader
Local nPosCod := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB8_CODARO"})

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		for nY := 1 to Len(aCols)
			If (aCols[nX, nPosCod] == aCols[nY, nPosCod]) .and. (nX != nY) .and. aCols[nX, Len(aHeader)+1] != .T.
				lRet := .F.
				MsgAlert("O aroma "+ aCols[nY, nPosCod] +" foi vinculada mais que uma vez ao mesmo vinho!")
			EndIf
		Next nY
	EndIf
Next nX

Return lRet   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCZB8  �Autor  �Jean Carlos Saggin    � Data �  08/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de exclus�o de registros da tabela ZB8              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EXCZB8()

Local nLinha  := oGetAro:nAt         

oGetAro:aCols[nLinha, Len(oGetAro:aHeader)+1] := !oGetAro:aCols[nLinha, Len(oGetAro:aHeader)+1] // Seta a linha como (des)deletada
oGetAro:ForceRefresh()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SAVZB8  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para salvar dados na tabela ZB8                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SAVZB8()

Local nX      := 0
Local lFound  := .F.
Local aCols   := oGetAro:aCols
Local aHeader := oGetAro:aHeader
Local nPosCod := 0

nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB8_CODARO"})

If !U_ZB8TOK()
	Return
EndIf

for nX := 1 to Len(aCols)

	DbSelectArea("ZB8")
	ZB8->(DbSetOrder(1))
  
	if Len(aOldHar) >= nX
		if aOldHar[nX, nPosCod] != aCols[nX, nPosCod]
			If DbSeek(xFilial("ZB8") + aOldHar[nX, nPosCod] + SB1->B1_COD)
		 		RecLock("ZB8", .F.)
				ZB8->ZB8_CODARO := aCols[nX, nPosCod]
				ZB8->ZB8_DESARO := Posicione("ZB4", 1, xFilial("ZB4") + aCols[nX, nPosCod], "ZB4_DESARO")
		 		ZB8->(MsUnlock())
			EndIf
		EndIf
	EndIf
	
	if aCols[nX, Len(aHeader)+1] != .T.
		If !DbSeek(xFilial("ZB8") + aCols[nX, nPosCod] + SB1->B1_COD)
			RecLock("ZB8", .T.)
			ZB8->ZB8_FILIAL := xFilial("ZB8")
			ZB8->ZB8_CODARO := aCols[nX, nPosCod]
			ZB8->ZB8_CODVIN := SB1->B1_COD
			ZB8->(MsUnlock())
		EndIf
	Else
		If DbSeek(xFilial("ZB8") + aCols[nX, nPosCod] + SB1->B1_COD)
			RecLock("ZB8", .F.)
			ZB8->(DbDelete())
			ZB8->(MsUnlock())	
		EndIf	
	EndIf	
Next nX

oGetAro:ForceRefresh()
aOldAro := aClone(oGetAro:aCols)

Return

//�������������������������������������������������������������
//�Fun��o que far� a atualiza��o do grid de Premia��es do Vinho�
//�������������������������������������������������������������

Static Function fGetPre()

Local nX
Local aHeaderEx    := {}
Local aColsEx      := {}
Local aFields      := {"ZB7_CODPRE","ZB7_DESPRE","ZB7_ANO","ZB7_SAFRA"}
Local aAlterFields := {"ZB7_CODPRE","ZB7_ANO","ZB7_SAFRA"}

  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  aColsEx := {}
  
  DBSelectArea("ZB7")
  ZB7->(DbSetOrder(1))
  If DbSeek(xFilial("ZB7") + SB1->B1_COD)
  	While !ZB7->(EOF()) .and. (ZB7->ZB7_FILIAL + ZB7->ZB7_CODVIN == xFilial("ZB7") + SB1->B1_COD)
  		aAdd(aColsEx, {ZB7->ZB7_CODPRE, Posicione("ZB6",1,xFilial("ZB6") + ZB7->ZB7_CODPRE,"ZB6_NOMPRE"), ZB7->ZB7_ANO, ZB7->ZB7_SAFRA, .F.})
  		ZB7->(DbSkip())
  	EndDo
  EndIf
  
  aOldPre := aClone(aColsEx)
	
  oGetPre := MsNewGetDados():New( 103, 241, 163, 538, GD_INSERT+GD_UPDATE, "U_ZB7LOK()", "U_ZB7TOK()", "", aAlterFields,, 99, "AllwaysTrue", "", "AllwaysTrue", oDlgVin, aHeaderEx, aColsEx)

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB7LOK  �Autor  �Jean Carlos Saggin    � Data �  07/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o para validar linha na tabela ZB7                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ZB7LOK()

Local lRet    := .T.
Local nX      := 0
Local aCols   := oGetPre:aCols
Local aHeader := oGetPre:aHeader
Local nLinha  := oGetPre:nAt
Local nPosCod := 0
Local nPosAno := 0
Local nPosSaf := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_CODPRE"})
nPosAno := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_ANO"})
nPosSaf := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_SAFRA"})

//���������������������������������������Ŀ
//�Avalia duplica��o de registros no grid.�
//�����������������������������������������

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.
		If (aCols[nLinha, nPosCod] + aCols[nLinha, nPosAno] + aCols[nLinha, nPosSaf] == aCols[nX, nPosCod] + aCols[nX, nPosAno] + aCols[nX, nPosSaf]) .and. (nLinha != nX)
			lRet := .F.
			MsgAlert("A premia��o "+ aCols[nLinha, nPosCod] +" ocorrida no ano "+ aCols[nLinha, nPosAno] +" j� est� cadastrada para a safra "+ aCols[nLinha, nPosSaf] +"!")
		EndIf
		
		//���������������������������������������������������������
		//�Valida se o ano da premia��o � maior que o ano da safra.�
		//���������������������������������������������������������
		
		if !aCols[nX, nPosAno] > aCols[nX, nPosSaf]
			lRet := .F.
			MsgAlert("O ano da premia��o ("+ aCols[nLinha, nPosAno] +") n�o pode ser maior que o ano da safra ("+ aCols[nLinha, nPosSaf] +")!")	
		EndIf
		
	EndIf
Next nX

Return lRet    	

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ZB7TOK  �Autor  �Microsiga           � Data �  12/08/14     ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida grid da tabela ZB7                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User function ZB7TOK()

Local lRet    := .T.
Local nX      := 0
Local nY      := 0
Local aCols   := oGetPre:aCols
Local aHeader := oGetPre:aHeader
Local nPosCod := 0
Local nPosAno := 0
Local nPosSaf := 0          

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_CODPRE"})
nPosAno := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_ANO"})
nPosSaf := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_SAFRA"})

for nX := 1 to Len(aCols)
	if aCols[nX, Len(aHeader)+1] != .T.     // Se n�o � uma linha deletada.
	
		//�����������������������������
		//�Valida registros duplicados.�
		//�����������������������������
		
		for nY := 1 to Len(aCols)             
			If (aCols[nY, nPosCod] + aCols[nY, nPosAno] + aCols[nY, nPosSaf] == aCols[nX, nPosCod] + aCols[nX, nPosAno] + aCols[nX, nPosSaf]) .and. (nX != nY) .and. aCols[nX, Len(aHeader)+1] != .T.
				lRet := .F.
				MsgAlert("A premia��o "+ aCols[nX, nPosCod] +" ocorrida no ano "+ aCols[nX, nPosAno] +" j� foi vinculada para a safra "+ aCols[nX, nPosSaf] +"!")
			EndIf
		Next nY
		
		//���������������������������������������������������������
		//�Valida se o ano da premia��o � maior que o ano da safra.�
		//���������������������������������������������������������
		
		if !aCols[nX, nPosAno] > aCols[nX, nPosSaf]
			lRet := .F.
			MsgAlert("O ano da premia��o ("+ aCols[nX, nPosAno] +") n�o pode ser maior que o ano da safra ("+ aCols[nX, nPosSaf] +")!")	
		EndIf
		
	EndIf
Next nX

Return lRet  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXCZB7  �Autor  �Jean Carlos Saggin    � Data �  11/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina de exclus�o de registros da tabela ZB7              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function EXCZB7()

Local nLinha  := oGetPre:nAt         

oGetPre:aCols[nLinha, Len(oGetPre:aHeader)+1] := !oGetPre:aCols[nLinha, Len(oGetPre:aHeader)+1] // Seta a linha como (des)deletada
oGetPre:ForceRefresh()

Return    

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �SAVZB7  �Autor  �Jean Carlos Saggin    � Data �  12/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para salvar dados na tabela ZB7                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � INFADVIN                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function SAVZB7()

Local nX      := 0
Local lFound  := .F.
Local aCols   := oGetPre:aCols
Local aHeader := oGetPre:aHeader
Local nPosCod := 0
Local nPosAno := 0
Local nPosSaf := 0          
                         
nPosCod := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_CODPRE"})
nPosAno := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_ANO"})
nPosSaf := aScan(aHeader, {|x| AllTrim(x[02]) == "ZB7_SAFRA"})

//��������������������������������������������������Ŀ
//�Valida o grid antes de realizar qualquer altera��o�
//����������������������������������������������������

If !U_ZB7TOK()
	Return
EndIf

for nX := 1 to Len(aCols)

	DbSelectArea("ZB7")
	ZB7->(DbSetOrder(1))
 
	//������������������������������������������������������������������Ŀ
	//�Valida os dados antigos pra ver se algum registro n�o foi alterado�
	//��������������������������������������������������������������������

	if Len(aOldPre) >= nX
		if (aOldPre[nX, nPosCod] != aCols[nX, nPosCod]) .or.;
	     (aOldPre[nX, nPosAno] != aCols[nX, nPosAno]) .or.;
	     (aOldPre[nX, nPosSaf] != aCols[nX, nPosSaf])
	     
			If DbSeek(xFilial("ZB7") + SB1->B1_COD + aOldPre[nX, nPosCod] + aOldPre[nX, nPosAno] + aOldPre[nX, nPosSaf])
		 		RecLock("ZB7", .F.)
				ZB7->ZB7_CODPRE := aCols[nX, nPosCod]
				ZB7->ZB7_ANO    := aCols[nX, nPosAno]
				ZB7->ZB7_SAFRA  := aCols[nX, nPosSaf]
		 		ZB7->(MsUnlock())
			EndIf
			
		EndIf
	EndIf
	
	if aCols[nX, Len(aHeader)+1] != .T.
	
		//�����������������������������������������������������������Ŀ
		//�Valida se a uva j� comp�e o vinho antes de fazer a inclus�o�
		//�������������������������������������������������������������
		
		If !DbSeek(xFilial("ZB7") + SB1->B1_COD + aCols[nX, nPosCod] + aCols[nX, nPosAno] + aCols[nX, nPosSaf])
			RecLock("ZB7", .T.)
			ZB7->ZB7_FILIAL := xFilial("ZB7")
			ZB7->ZB7_CODPRE := aCols[nX, nPosCod]
			ZB7->ZB7_CODVIN := SB1->B1_COD
			ZB7->ZB7_ANO    := aCols[nX, nPosAno]
			ZB7->ZB7_SAFRA  := aCols[nX, nPosSaf]
			ZB7->(MsUnlock())
		EndIf
	Else
		
		//�������������������������������Ŀ
		//�Valida se foi deletado no grid.�
		//���������������������������������
		
		If DbSeek(xFilial("ZB7") + SB1->B1_COD + aCols[nX, nPosCod] + aCols[nX, nPosAno] + aCols[nX, nPosSaf])
			RecLock("ZB7", .F.)
			ZB7->(DbDelete())
			ZB7->(MsUnlock())	
		EndIf	
	EndIf	
Next nX

oGetPre:ForceRefresh()
aOldPre := aClone(oGetPre:aCols)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZB2  �Autor  �Jean Carlos Saggin    � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pelo cadastro de Uvas                   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZB2()

Local cAlias := "ZB2"
Local cCadastro := "Cadastro de Uvas"
Local cFunExc   := "U_ZB2EXC()"
Local cFunALt   := "U_ZB2ALT()"
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

AxCadastro(cAlias, OemToAnsi(cCadastro), cFunExc, cFunAlt)

Return Nil  

//���������������������������������������������������������������������P�
//�Fun��o respons�vel por validar a exclus�o de registros da tabela ZB2�
//���������������������������������������������������������������������P�

User Function ZB2EXC()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//������������������������������������������������������Ŀ
//�Valida o uso da chave na tabela de Composi��o do Vinho�
//��������������������������������������������������������

DbSelectArea("ZB3")
ZB3->(DbSetOrder(2))
if DBSeek(xFilial("ZB3") + ZB2->ZB2_CODUVA)
	lRet := .F.
EndIf

if !lRet
	Alert("N�o foi poss�vel fazer a exclus�o da uva porque a mesma est� relacionada a composi��o de um vinho! ")
EndIf

Return lRet      

//���������������������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar a altera��o de registros na tabela ZB2�
//�����������������������������������������������������������������������

User Function ZB2ALT()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//������������������������������������������������������Ŀ
//�Valida o uso da chave na tabela de Composi��o do Vinho�
//��������������������������������������������������������

DbSelectArea("ZB3")
ZB3->(DbSetOrder(2))
if DBSeek(xFilial("ZB3") + M->ZB2_CODUVA)
	lRet := .F.
EndIf

if !lRet
	Alert("N�o foi poss�vel alterar o c�digo "+ Upper(M->ZB2_CODUVA) +" porque o mesmo est� relacionado a composi��o de um vinho! ")
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZB4  �Autor  �Jean Carlos Saggin    � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pelo cadastro de Aromas                 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZB4()

Local cAlias := "ZB4"
Local cCadastro := "Cadastro de Aromas"
Local cFunExc   := "U_ZB4EXC()"
Local cFunALt   := "U_ZB4ALT()"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

AxCadastro(cAlias, OemToAnsi(cCadastro), cFunExc, cFunAlt)

Return Nil

//������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar exclus�es na tabela ZB4�
//��������������������������������������������������������

User Function ZB4EXC()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//�����������������������������������������������Ŀ
//�Avalia a exist�ncia de v�nculo com a tabela ZB8�
//�������������������������������������������������

DbSelectArea("ZB8")
ZB8->(DbSetOrder(1))
if DbSeek(xFilial("ZB8") + ZB4->ZB4_CODIGO)
	lRet := .F.
EndIf
             
If !lRet 
	Alert("N�o ser� poss�vel excluir o aroma "+ ZB4->ZB4_CODIGO +" porque o mesmo est� relacionado a um vinho!")
EndIf

Return lRet

//�������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar altera��es na tabela ZB4�
//���������������������������������������������������������

User Function ZB4ALT()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

//�����������������������������������������������Ŀ
//�Avalia a exist�ncia de v�nculo com a tabela ZB8�
//�������������������������������������������������

DbSelectArea("ZB8")
ZB8->(DbSetOrder(1))
if DbSeek(xFilial("ZB8") + M->ZB4_CODIGO)
	lRet := .F.
EndIf
             
If !lRet 
	Alert("N�o ser� poss�vel alterar o c�digo "+ M->ZB4_CODIGO +" porque o mesmo est� relacionado a um vinho!")
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZA8  �Autor  �Jean Carlos Saggin    � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pelo cadastro de Tipos de Vinhos        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZA8()

Local cAlias := "ZA8"
Local cCadastro := "Tipos de Vinhos"
Local cFunExc   := "U_ZA8EXC()"
Local cFunALt   := "U_ZA8ALT()"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

AxCadastro(cAlias, OemToAnsi(cCadastro), cFunExc, cFunAlt)

Return Nil  

//������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar exclus�es na tabela ZA8�
//��������������������������������������������������������

User Function ZA8EXC()

Local lRet     := .T.
Private lFound := .F.
    
//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

MsAguarde( {||fFindVin(ZB8->ZA8_SIGLA)}, "Validando exclus�o... Aguarde!")

if lFound
	lRet := .F.
	Alert("O tipo de vinho "+ Upper(ZB8->ZA8_SIGLA) +" n�o pode ser exclu�do porque existe(m) "+; 
				" vinho(s) vinculado(s) a ele!")
EndIf

Return lRet          

//�������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar altera��es na tabela ZA8�
//���������������������������������������������������������

User Function ZA8ALT()

Local lRet     := .T.
Private lFound := .F.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

MsAguarde( {||fFindVin(M->ZA8_SIGLA)}, "Validando altera��o... Aguarde!")

if lFound
	lRet := .F.
	Alert("O tipo de vinho "+ Upper(M->ZA8_SIGLA) +" n�o pode ser alterado porque existe(m) "+; 
				" vinho(s) vinculado(s) a ele!")
EndIf

Return lRet     

//���������������������������������������������������������������������Ŀ
//�Fun��o respons�vel por buscar vinhos pelo tipo no cadastro de produto�
//�����������������������������������������������������������������������

Static Function fFindVin(cTipo)

Local cSql   := ""
Local cEOL   := CHR(13)+CHR(10)

lFound := .F. 

cSql := "select count(*) as quant from "+ RetSqlName("SB1") +" b1 " +cEol
cSql += "where b1.d_e_l_e_t_ <> '*' "                               +cEol
cSql += "  and b1.b1_x_tpvin = '"+ cTipo +"' "                      

TcQuery cSql New Alias "sb1temp"

DbSelectArea("sb1temp")
sb1temp->(DbGoTop())

//������������������������������������������������������Ŀ
//�Avalia se a pesquisa no banco encontrou algum produto.�
//��������������������������������������������������������

if !sb1temp->(EOF())
	lFound := .T.
EndIf 

sb1temp->(DbCloseArea())

Return 

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZB6  �Autor  �Jean Carlos Saggin    � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pelo cadastro de Premia��es             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZB6()

Local cAlias := "ZB6"
Local cCadastro := "Cadastro de Premia��es"
Local cFunExc   := "U_ZB6EXC()"
Local cFunALt   := "U_ZB6ALT()"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

AxCadastro(cAlias, OemToAnsi(cCadastro), cFunExc, cFunAlt)

Return Nil 

//���������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar as exclus�es da tabela ZB6�
//�����������������������������������������������������������

User Function ZB6EXC()

Local lRet := .T.                

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("ZB7")
ZB7->(DbSetOrder(2))
if DBSeek(xFilial("ZB7") + ZB6->ZB6_CODPRE)
	lRet := .F.
EndIf        

if !lRet
	Alert("N�o ser� poss�vel excluir a premia��o c�d. "+ ZB6->ZB6_CODPRE +" porque a mesma j� possui v�nculos com vinhos!")	
EndIf

Return lRet                       

//����������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar as altera��es na tabela ZB6�
//������������������������������������������������������������

User Function ZB6ALT()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("ZB7")
ZB7->(DbSetOrder(2))
if DBSeek(xFilial("ZB7") + M->ZB6_CODPRE)
	lRet := .F.
EndIf        

if !lRet
	Alert("N�o ser� poss�vel alterar a premia��o c�d. "+ M->ZB6_CODPRE +" porque a mesma j� possui v�nculos com vinhos!")	
EndIf

Return lRet

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MANZB1  �Autor  �Jean Carlos Saggin    � Data �  04/08/14   ���
�������������������������������������������������������������������������͹��
���Desc.     � Fun��o respons�vel pelo cadastro de Armoniza��es           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Cantu                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MANZB1()

Local cAlTmp := "ZB1"
Local cCadastro := "Cadastro de Harmoniza��es"
Local cFunExc   := "U_ZB1EXC()"
Local cFunAlt   := "U_ZB1ALT()"

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea(cAlTmp)

AxCadastro(cAlTmp, OemToAnsi(cCadastro), cFunExc, cFunAlt)

Return Nil                

//���������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar as exclus�es da tabela ZB6�
//�����������������������������������������������������������

User Function ZB1EXC()

Local lRet := .T.                

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("ZB5")
ZB5->(DbSetOrder(1))
if DBSeek(xFilial("ZB5") + ZB1->ZB1_SIGLA)
	lRet := .F.
EndIf        

if !lRet
	Alert("N�o ser� poss�vel excluir a harmoniza��o c�d. "+ ZB1->ZB1_SIGLA +" porque a mesma j� possui v�nculos com vinhos!")	
EndIf

Return lRet                       

//����������������������������������������������������������Ŀ
//�Fun��o respons�vel por validar as altera��es na tabela ZB6�
//������������������������������������������������������������

User Function ZB1ALT()

Local lRet := .T.

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

DbSelectArea("ZB5")
ZB5->(DbSetOrder(1))
if DBSeek(xFilial("ZB5") + M->ZB1_SIGLA)
	lRet := .F.
EndIf        

if !lRet
	Alert("N�o ser� poss�vel alterar a harmoniza��o c�d. "+ M->ZB1_SIGLA+" porque a mesma j� possui v�nculos com vinhos!")	
EndIf

Return lRet