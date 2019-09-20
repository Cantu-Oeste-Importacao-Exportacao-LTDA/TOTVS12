#include "rwmake.ch"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function CliSegPer()

Local oGetDataFim
Local dGetDataFim := Date()
Local oGetDataIni
Local dGetDataIni := Date()
Local oGetSegFim
Local cGetSegFim := "ZZZZZZZZZ"
Local oGetSegIni
Local cGetSegIni := "         "
Local oGetVendFim
Local cGetVendFim := "ZZZZZZ"
Local oGetVendIni
Local cGetVendIni := "      "
Local oPeriodoAte
Local oPeriodoDe
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSButton1
Local oSButton2
Static oDlg

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

  DEFINE MSDIALOG oDlg TITLE "Clientes Cadastrados no Período" FROM 000, 000  TO 180, 500 COLORS 0, 16777215 PIXEL

    @ 020, 012 SAY oPeriodoDe PROMPT "Período De:" SIZE 032, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017, 049 MSGET oGetDataIni VAR dGetDataIni SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL
       
    @ 020, 123 SAY oPeriodoAte PROMPT "Período Até: " SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 017, 163 MSGET oGetDataFim VAR dGetDataFim SIZE 048, 010 OF oDlg COLORS 0, 16777215 PIXEL

    @ 035, 007 SAY oSay1 PROMPT "Segmento De:" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 049 MSGET oGetSegIni VAR cGetSegIni SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "CTH" PIXEL
    
    @ 035, 118 SAY oSay2 PROMPT "Segmento Até: " SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 033, 163 MSGET oGetSegFim VAR cGetSegFim SIZE 060, 010 OF oDlg COLORS 0, 16777215 F3 "CTH" PIXEL
    
    @ 052, 008 SAY oSay3 PROMPT "Vendedor De:" SIZE 036, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 049, 049 MSGET oGetVendIni VAR cGetVendIni SIZE 047, 010 OF oDlg COLORS 0, 16777215 F3 "SA3" PIXEL
    
    @ 051, 120 SAY oSay4 PROMPT "Vendedor Até: " SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 049, 163 MSGET oGetVendFim VAR cGetVendFim SIZE 047, 010 OF oDlg COLORS 0, 16777215 F3 "SA3" PIXEL
    
    DEFINE SBUTTON oSButton1 FROM 071, 188 TYPE 01 OF oDlg ENABLE ACTION RptStatus({|lEnd| GeraRel(@lEnd, dGetDataIni, dGetDataFim,; 
    																																								cGetSegIni, cGetSegFim, cGetVendIni, cGetVendFim)}, "Aguarde...","Exportando para Excel...", .T.)
    DEFINE SBUTTON oSButton2 FROM 071, 152 TYPE 02 OF oDlg ENABLE ACTION Close(oDlg)

  ACTIVATE MSDIALOG oDlg CENTERED

Return                                                                            

Static Function GeraRel(lEnd, dGetDataIni, dGetDataFim, cGetSegIni, cGetSegFim, cGetVendIni, cGetVendFim)
Local cSql := ""
Local aEmp := {}
Local cCod := ""      
Local cEol := CHR(13) + CHR(10)
Local aArea := SM0->(GetArea())
Local aFields := {"ZZ5_VEND", "ZZ5_SEGMEN", "ZZ5_CLIENT", "ZZ5_LOJA", "A1_NOME", "A1_EST", "A1_MUN", "A1_DTCADAS"}
Local aHeader := {}
Local cNome := ""
Local cPath := ""
Local cTipo := "Arquivos Csv | *.csv"
Local nQtdReg := 0
Local nArq

// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

DbSelectArea("SM0")
SM0->(DbGoTop())

while !SM0->(EOF())
	if cCod != SM0->M0_CODIGO
		Aadd(aEmp, SM0->M0_CODIGO)
		cCod := SM0->M0_CODIGO
	else
		cCod := SM0->M0_CODIGO
	EndIf
	SM0->(DbSkip())
End

RestArea(aArea)

cSql := 'SELECT DISTINCT VEND, SEGMENTO, CLIENTE, LOJA, RAZAO, ESTADO, MUNICIPIO, DTCADASTRO  FROM ( '                 +cEol
                         
for i := 1 to len(aEmp)
  cSql += 'SELECT DISTINCT ZZ5.ZZ5_VEND AS VEND, ZZ5.ZZ5_SEGMEN AS SEGMENTO, ZZ5.ZZ5_CLIENT AS CLIENTE, '              +cEol
  cSql += 'ZZ5.ZZ5_LOJA AS LOJA, A1.A1_NOME AS RAZAO, A1.A1_EST AS ESTADO, A1.A1_MUN AS MUNICIPIO, '                   +cEol
  cSql += 'A1.A1_DTCADAS AS DTCADASTRO FROM ZZ5' +aEmp[i]+ '0 ZZ5 '
  //                                                                                                                     +cEol
	cSql += 'INNER JOIN ' +retSqlName("SA1")+ ' A1 '                                                                     +cEol
  cSql += ' ON A1.A1_COD = ZZ5.ZZ5_CLIENT '                                                                            +cEol
  cSql += 'AND A1.A1_LOJA = ZZ5.ZZ5_LOJA '                                                                             +cEol
  cSql += "AND A1.A1_DTCADAS BETWEEN '" +DtoS(dGetDataIni)+ "' AND '" +DtoS(dGetDataFim)+ "' "                         +cEol
  cSql += "AND A1.D_E_L_E_T_ <> '*' "                                                                                  +cEol

  cSql += "WHERE ZZ5.ZZ5_SEGMEN BETWEEN '" +cGetSegIni+ "' AND '" +cGetSegFim+ "' "                                    +cEol
  cSql += "  AND ZZ5.ZZ5_CLIENT <> ' ' "                                                                               +cEol
  cSql += "  AND ZZ5.ZZ5_LOJA <> ' ' "                                                                                 +cEol
  cSql += "  AND ZZ5.ZZ5_VEND BETWEEN '" +cGetVendIni+ "' AND '" +cGetVendFim+ "' "                                    +cEol
  
  if (i != len(aEmp))
  	cSql += "UNION ALL "                                                                                               +cEol
  else 
  	cSql += ") "                                                                                                       +cEol
		cSql += "ORDER BY VEND, SEGMENTO, CLIENTE, LOJA"                                                                   +cEol
  EndIf
  
Next i

TCQUERY cSql NEW ALIAS "CLITMP"

DbSelectArea("CLITMP")
CLITMP->(DbGoTop())

count to nQtdReg

cNome := "Clientes_Novos.csv"
 
cPath := cGetFile(cTipo, "Selecione onde salvar o arquivo", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
if ExistDir(cPath)
	nArq  := FCreate(cPath+cNome)	
else
	Alert("Diretório inválido!")
	CLITMP->(DbCloseArea())
	Return nil
EndIf
     

If nArq > 0
		
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nArq, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nArq, cEol ) // Pula linha

	dbSelectArea("CLITMP")
	CLITMP->(DbGoTop())
	
	SetRegua(nQtdReg)
	CLITMP->(dbGoTop())
	while !(CLITMP->(EOF()))
		IncRegua()
		fWrite(nArq, VEND +";"+ SEGMENTO +";"+ CLIENTE +";"+ LOJA +";"+ RAZAO +";"+ ESTADO +";"+ MUNICIPIO +";"+ DTCADASTRO +";")
		fWrite(nArq, cEol) // Pula linha
		
	  CLITMP->(DbSkip())
	EndDo
	
	CLITMP->(DbCloseArea())

	fClose(nArq)
	
	CpyS2T(SubStr(cPath,3,len(AllTrim(cPath))) + cNome, SubStr(cPath,1,2), .T.)
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cPath) + cNome) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
		MsgAlert("Falha na criação do arquivo")
Endif
     
      
Aviso("Gravação do Arquivo","Arquivo Gravado com Sucesso em: "+cPath+cNome,{"Ok"})

Return .T.