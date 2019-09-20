#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

User function SE1Retro()
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

  DEFINE MSDIALOG oDlg TITLE "Exporta tabela de títulos a receber" FROM 000, 000  TO 160, 500 COLORS 0, 16777215 PIXEL

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
Local aFields  := {"E1_FILIAL", "E1_PREFIXO", "E1_NUM", "E1_PARCELA", "E1_TIPO", "E1_NATUREZ", ;
									"E1_PORTADO", "E1_VALOR", "E1_CLVLCR", "E1_CLVLDB", "E1_CCC", "E1_CLIENTE", "E1_NOMCLI", ;
									"E1_LOJA", "E1_EMISSAO", "E1_EMIS1", "E1_VENCREA", "E1_BAIXA", "E1_DESCONT", ;
									"E1_DECRESC", "E1_SALDO"} 
									
// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

cQuery += "SELECT E1.R_E_C_N_O_ AS E1_RNO FROM " + RetSqlName("SE1") + " E1 "
cQuery += "WHERE E1.D_E_L_E_T_ <> '*' "
//cQuery += "  AND E1.E1_EMIS1 BETWEEN '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFim)+"' "
cQuery += " AND E1.E1_EMISSAO BETWEEN '"+DtoS(dDataIni)+"' AND '"+DtoS(dDataFim)+"' "
cQuery += " AND NOT (E1.E1_BAIXA < '"+DtoS(dDataBs)+"' AND E1.E1_SALDO = 0) "
cQuery += " AND E1_SITUACA <> '2' "
cQuery += "ORDER BY E1_FILIAL, E1_RNO"

TCQUERY cQuery NEW ALIAS "SE1TMP"

if At(".",cCaminho) > 0
	cCaminho := SubStr(cCaminho,1,At(".",cCaminho)-1)
EndIf

nHandle := MsfCreate(AllTrim(cCaminho) + ".CSV",0)
	
If nHandle > 0
		
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	dbSelectArea("SE1TMP")
	SE1TMP->(dbGoTop())                       

	while !(SE1TMP->(EOF()))
		nCnt ++
	  SE1TMP->(DbSkip())
	EndDo
	
	SetRegua(nCnt)
	SE1TMP->(dbGoTop())
	
	while !(SE1TMP->(EOF()))
		IncRegua()
		
		dbSelectArea("SE1")
		dbGoto(SE1TMP->E1_RNO)
		
		nSaldo := SaldoTit(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_NATUREZ, "R", SE1->E1_CLIENTE, 1, , dDataBs, SE1->E1_LOJA, SE1->E1_FILIAL)
				
		fWrite(nHandle, E1_FILIAL +";"+ E1_PREFIXO +";"+ E1_NUM +";"+ E1_PARCELA +";"+ E1_TIPO +";"+ E1_NATUREZ +";"+;
										E1_PORTADO +";"+ StrTran(cValToChar(E1_VALOR), ".", ",") +";"+ E1_CLVLCR +";"+ E1_CLVLDB +";"+ E1_CCC +";"+; 
										E1_CLIENTE +";"+ E1_NOMCLI +";"+ E1_LOJA +";"+ dToC(E1_EMISSAO) +";"+ dToC(E1_EMIS1) +";"+ dToC(E1_VENCREA) +";"+;
									  dToC(E1_BAIXA) +";"+ StrTran(cValToChar(E1_DESCONT), ".", ",") +";"+ ;
									  StrTran(cValToChar(E1_DECRESC), ".", ",") +";"+ StrTran(cValToChar(nSaldo), ".", ",") +";")
		fWrite(nHandle, cCrLf ) // Pula linha
		
		SE1TMP->(DbSkip())
	EndDo
	
	SE1TMP->(DbCloseArea())

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