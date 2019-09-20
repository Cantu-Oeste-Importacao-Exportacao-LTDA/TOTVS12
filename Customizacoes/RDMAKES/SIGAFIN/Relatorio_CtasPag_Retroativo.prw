#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

User function SE2Retro()
Static oDlg
Static oButton1
Static oGetCaminho
Static cGetCaminho := Space(200)
Static oGetDtFim
Static dGetDtFim := Date()
Static oGetDtIni
Static dGetDtIni := Date()
Static oGetDtBs
Static dGetDtBs := Date()
Static oSay1
Static oSay2
Static oSay3     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  DEFINE MSDIALOG oDlg TITLE "Exporta tabela de títulos a pagar" FROM 000, 000  TO 160, 500 COLORS 0, 16777215 PIXEL

    @ 013, 052 MSGET oGetCaminho VAR cGetCaminho SIZE 171, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 014, 004 SAY oSay1 PROMPT "Caminho Arquivo" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 052 MSGET oGetDtIni VAR dGetDtIni SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 036, 005 SAY oSay2 PROMPT "Data Emissão Ini." SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 179 MSGET oGetDtFim VAR dGetDtFim SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 036, 129 SAY oSay3 PROMPT "Data Emissão Fim" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 054, 052 MSGET oGetDtBs VAR dGetDtBs SIZE 060, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 056, 004 SAY oSay3 PROMPT "Data Base" SIZE 046, 007 OF oDlg COLORS 0, 16777215 PIXEL
    DEFINE SBUTTON oButton1 FROM 054, 210 TYPE 01 ACTION (RptStatus({|lEnd| GravaCSV(@lEnd, cGetCaminho, dGetDtIni, dGetDtFim, dGetDtBs) }, "Aguarde...","Exportando para Excel...", .T.),;
    																											Close(oDlg)) OF oDlg ENABLE
	 @ 015, 226 SAY oSay4 PROMPT ".csv" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
  
  ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function GravaCSV(lEnd, cCaminho, dDataIni, dDataFim, dDataBs)

Local cQuery   := ""
Local aEmp     := {}
Local aArea    := SM0->(GetArea())
Local cCrLf 	 := Chr(13) + Chr(10)
Local oExcelApp
Local nHandle
Local nCnt := 0
Local aHeader  := {}
Local aFields  := {"E2_FILIAL", "E2_PREFIXO", "E2_NUM", "E2_PARCELA", "E2_TIPO", "E2_NATUREZ", ;
									"E2_PORTADO", "E2_VALOR", "E2_CLVLDB", "E2_CLVLCR", "E2_CCD", "E2_FORNECE", "E2_NOMFOR", ;
									"E2_LOJA", "E2_EMISSAO", "E2_EMIS1", "E2_VENCREA", "E2_BAIXA", "E2_DESCONT", ;
									"E2_DECRESC", "E2_SALDO"} 
									
// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nItem := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nItem]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nItem

cQuery += "SELECT E2.R_E_C_N_O_ AS E2_RNO FROM " + RetSqlName("SE2") + " E2 "
cQuery += "WHERE E2.D_E_L_E_T_ <> '*' "
cQuery += " AND E2.E2_EMISSAO BETWEEN '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFim)+"' "
cQuery += " AND NOT (E2.E2_BAIXA < '"+DtoS(dDataBs)+"' AND E2.E2_SALDO = 0) "
//cQuery += " AND E2_SITUACA <> '2' "
cQuery += "ORDER BY E2_FILIAL, E2_RNO"

TCQUERY cQuery NEW ALIAS "SE2TMP"

if At(".",cCaminho) > 0
	cCaminho := SubStr(cCaminho,1,At(".",cCaminho)-1)
EndIf

nHandle := MsfCreate(AllTrim(cCaminho) + ".CSV",0)
	
If nHandle > 0
		
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	dbSelectArea("SE2TMP")
	SE2TMP->(dbGoTop())                       

	while !(SE2TMP->(EOF()))
		nCnt ++
	  SE2TMP->(DbSkip())
	EndDo
	
	SetRegua(nCnt)
	SE2TMP->(dbGoTop())
	
	while !(SE2TMP->(EOF()))
		IncRegua()
		
		dbSelectArea("SE2")
		dbGoto(SE2TMP->E2_RNO)
		
		nSaldo := SaldoTit(SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO, SE2->E2_NATUREZ, "P", SE2->E2_FORNECE, 1, , dDataBs, SE2->E2_LOJA, SE2->E2_FILIAL)
				
		fWrite(nHandle, E2_FILIAL +";"+ E2_PREFIXO +";"+ E2_NUM +";"+ E2_PARCELA +";"+ E2_TIPO +";"+ E2_NATUREZ +";"+;
										E2_PORTADO +";"+ StrTran(cValToChar(E2_VALOR), ".", ",") +";"+ E2_CLVLDB +";"+ E2_CLVLCR +";"+ E2_CCD +";"+; 
										E2_FORNECE +";"+ E2_NOMFOR +";"+ E2_LOJA +";"+ dToC(E2_EMISSAO) +";"+ dToC(E2_EMIS1) +";"+ dToC(E2_VENCREA) +";"+;
									  dToC(E2_BAIXA) +";"+ StrTran(cValToChar(E2_DESCONT), ".", ",") +";"+ ;
									  StrTran(cValToChar(E2_DECRESC), ".", ",") +";"+ StrTran(cValToChar(nSaldo), ".", ",") +";")
		fWrite(nHandle, cCrLf ) // Pula linha
		
		SE2TMP->(DbSkip())
	EndDo
	
	SE2TMP->(DbCloseArea())

	fClose(nHandle)
	CpyS2T(SubStr(cCaminho,3,len(AllTrim(cCaminho))) + ".CSV", SubStr(cCaminho,1,2), .T.)
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cCaminho) + ".CSV") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
		MsgAlert("Falha na criação do arquivo")
Endif

RestArea(aArea)
Return .T.