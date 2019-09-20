#include "protheus.ch"
#INCLUDE "rwmake.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma   RELITEMCTB   Autor: Jean               º Data ³  08/29/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Relatório com a funcionalidade de exportação de dados                  ¹±±
±±³para excel para atender a necessidade do setor de                      ¹±±
±±³transporte.                                                            ¹±±
±±³Mostra os itens comprados por Item contábil (placa) ou                 ¹±±
±±³por fornecedor/loja. 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User function relItemCtb()
Local cPerg    := "RELITCTB"
Local cCaminho := "" 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX(cPerg)

if !(Pergunte(cPerg))
	 Return nil
EndIf 

// Verifica se o caminho para salvar o arquivo é válido.
if !(ExistDir(AllTrim(MV_PAR10)))
	Alert("Diretório para salvar o arquivo não existe. Verifique o caminho informado!")
	Return nil
else
	cCaminho := AllTrim(MV_PAR10)
EndIf

RptStatus({|lEnd| GrvArq(@lEnd, cCaminho) }, "Aguarde...","Exportando para Excel...", .T.)

Return nil

Static function GrvArq(lEnd, cCaminho)
Local cQuery   := ""
Local cCrLf 	 := Chr(13) + Chr(10)
Local cArquivo := "RELITEMCTB"
Local cQuant   := ""
Local cVUnit   := ""
Local cTotal   := ""
Local cCusto   := ""
Local cChave   := ""
Local nHandle  
Local nCnt     := 0
Local nTotal   := 0
Local nCusto   := 0
Local nControl := 0
Local oExcelApp
Local aHeader  := {}
Local aFields  := {"D1_ITEMCTA", "CTD_DESC01", "D1_COD", "B1_DESC", "D1_QUANT", "D1_UM", "D1_VUNIT", ;
									"D1_TOTAL", "D1_CUSTO", "D1_FORNECE", "D1_LOJA", "A2_NOME", "D1_EMISSAO", "D1_LOCAL"} 

// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX

// Inicia a busca pelos dados no banco.
cQuery := "SELECT D1_ITEMCTA, CTD_DESC01, D1_COD, B1_DESC, D1_QUANT, D1_UM, D1_VUNIT, D1_TOTAL, "                           
cQuery += "       D1_CUSTO, D1_FORNECE, D1_LOJA, A2_NOME, D1_EMISSAO, D1_LOCAL FROM " + retSqlName("SD1") + " D1 "            

cQuery += "INNER JOIN " + retSqlName("CTD") + " CTD "                                                                         
cQuery += " ON CTD.CTD_ITEM = D1.D1_ITEMCTA "                                                                                 
cQuery += "AND CTD.D_E_L_E_T_ <> '*' "                                                                                        

cQuery += "INNER JOIN " + retSqlName("SA2") + " A2 "                                                                          
cQuery += " ON A2.A2_COD = D1.D1_FORNECE "                                                                                    
cQuery += "AND A2.A2_LOJA = D1.D1_LOJA "
cQuery += "AND A2.D_E_L_E_T_ <> '*' "             

cQuery += "INNER JOIN " + retSqlName("SB1") + " B1 "
cQuery += " ON B1.B1_COD = D1.D1_COD "
cQuery += "AND B1.D_E_L_E_T_ <> '*'"

cQuery += "WHERE D1.D1_COD BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
cQuery += "  AND D1.D1_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' "
cQuery += "  AND D1.D1_FORNECE BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
cQuery += "  AND D1.D1_ITEMCTA BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
cQuery += "  AND D1.D_E_L_E_T_ <> '*' "

if MV_PAR09 == 1
	cQuery += "ORDER BY D1.D1_ITEMCTA	"
Else                  
	cQuery += "ORDER BY D1.D1_FORNECE, D1.D1_LOJA "
EndIf  

TCQUERY cQuery NEW ALIAS "SD1TMP"

// Força o sistema a criar um arquivo
nHandle := MsfCreate(AllTrim(cCaminho) + cArquivo + ".CSV",0)
	
If nHandle > 0
		
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	dbSelectArea("SD1TMP")
	SD1TMP->(dbGoTop())                       
  
	// Percorre a tabela temporária pela primeira vez para contar os registros.
	// A soma destes, será utilizada para compor a régua de processamento.
	while !(SD1TMP->(EOF()))
		nCnt ++
	  SD1TMP->(DbSkip())
	EndDo
	
	SetRegua(nCnt)
	SD1TMP->(dbGoTop())
	
	while !(SD1TMP->(EOF()))
		IncRegua()
    
    nControl++ 
		// Transforma as variáveis numéricas.
		cQuant := Transform(D1_QUANT, "@E 999999999.99999999")
		cVUnit := Transform(D1_VUNIT, "@E 999,999,999.99")
		cTotal := Transform(D1_TOTAL, "@E 999,999,999.99")
		cCusto := Transform(D1_CUSTO, "@E 999,999,999.99")	
    
    // Avalia se a totalização será por ItemCtbl ou por Fornecedor/Loja  
		if MV_PAR09 == 1
      
      if cChave == D1_ITEMCTA 
				fWrite(nHandle, D1_ITEMCTA +";"+ CTD_DESC01 +";"+ D1_COD +";"+ B1_DESC +";"+ cQuant +";"+ D1_UM +";"+ cVUnit +";"+;
											cTotal +";"+ cCusto +";"+ D1_FORNECE +";"+ D1_LOJA +";"+ A2_NOME +";"+ D1_EMISSAO +";"+; 
											D1_LOCAL +";")
				fWrite(nHandle, cCrLf ) // Pula linha
				nTotal += D1_TOTAL
				nCusto += D1_CUSTO
      Else
      	if nControl != 1
	      	// Totaliza o último registro com a chave cChave
	      	fWrite(nHandle, "TOTAL" +";"+ ";"+ ";"+ ";"+ ";"+ ";"+ ";"+ Transform(nTotal, "@E 999,999,999.99") +";"+ Transform(nCusto, "@E 999,999,999.99") +";")
	      	fWrite(nHandle, cCrLf )
	      	fWrite(nHandle, cCrLf )
	      	nTotal := 0
	      	nCusto := 0     
      	EndIf
      	
      	// Grava próximo registro após totalização.
      	fWrite(nHandle, D1_ITEMCTA +";"+ CTD_DESC01 +";"+ D1_COD +";"+ B1_DESC +";"+ cQuant +";"+ D1_UM +";"+ cVUnit +";"+;
											cTotal +";"+ cCusto +";"+ D1_FORNECE +";"+ D1_LOJA +";"+ A2_NOME +";"+ D1_EMISSAO +";"+; 
											D1_LOCAL +";")
				fWrite(nHandle, cCrLf ) 
				nTotal += D1_TOTAL
				nCusto += D1_CUSTO
      EndIf
			
		else
			// Verifica se é o mesmo fornecedor/loja ao entrar no próximo registro. Caso for, continua gravando, senão totaliza.
			if cChave == D1_FORNECE + D1_LOJA
				
				fWrite(nHandle, D1_ITEMCTA +";"+ CTD_DESC01 +";"+ D1_COD +";"+ B1_DESC +";"+ cQuant +";"+ D1_UM +";"+ cVUnit +";"+;
											cTotal +";"+ cCusto +";"+ D1_FORNECE +";"+ D1_LOJA +";"+ A2_NOME +";"+ D1_EMISSAO +";"+; 
											D1_LOCAL +";")
				fWrite(nHandle, cCrLf ) // Pula linha
				nTotal += D1_TOTAL
				nCusto += D1_CUSTO
      Else
      	if nControl != 1
	      	// Totaliza o último registro com a chave cChave
	      	fWrite(nHandle, "TOTAL" +";"+ ";"+ ";"+ ";"+ ";"+ ";"+ ";"+ Transform(nTotal, "@E 999,999,999.99") +";"+ Transform(nCusto, "@E 999,999,999.99") +";")
	      	fWrite(nHandle, cCrLf )
	      	fWrite(nHandle, cCrLf )
	      	nTotal := 0
	      	nCusto := 0     
      	EndIf
      	
      	// Grava próximo registro após totalização.
      	fWrite(nHandle, D1_ITEMCTA +";"+ CTD_DESC01 +";"+ D1_COD +";"+ B1_DESC +";"+ cQuant +";"+ D1_UM +";"+ cVUnit +";"+;
											cTotal +";"+ cCusto +";"+ D1_FORNECE +";"+ D1_LOJA +";"+ A2_NOME +";"+ D1_EMISSAO +";"+; 
											D1_LOCAL +";")
				fWrite(nHandle, cCrLf ) 
				nTotal += D1_TOTAL
				nCusto += D1_CUSTO
      EndIf
      
		EndIf
		
		// Verifica se é o último registro da tabela.
		if nControl == nCnt
			if nControl != 1
      	fWrite(nHandle, "TOTAL" +";"+ ";"+ ";"+ ";"+ ";"+ ";"+ ";"+ Transform(nTotal, "@E 999,999,999.99") +";"+ Transform(nCusto, "@E 999,999,999.99") +";")
      	fWrite(nHandle, cCrLf )
      	fWrite(nHandle, cCrLf )
      	nTotal := 0
      	nCusto := 0     
     	EndIf                    
		EndIf
		
	  if MV_PAR09 == 1
    	cChave := D1_ITEMCTA
    Else
    	cChave := D1_FORNECE + D1_LOJA
    EndIf
		
	  SD1TMP->(DbSkip())
	EndDo
	
	SD1TMP->(DbCloseArea())

	fClose(nHandle)
	CpyS2T(SubStr(cCaminho,3,len(AllTrim(cCaminho))) + cArquivo + ".CSV", SubStr(cCaminho,1,2), .T.)
	
	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf
	
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(cCaminho) + cArquivo + ".CSV") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
	
	MsgInfo("Arquivo "+AllTrim(cCaminho) + cArquivo + ".csv"+" gerado com sucesso.")
	
Else
		MsgAlert("Falha na criação do arquivo")
Endif

Return .T.
                                 

// Faz a inclusão das perguntas automaticamente no SX1
Static Function AjustaSX(cPerg)
	PutSx1(cPerg,"01","Produto de ?"    ,"Produto de ?"    ,"Produto de ?"    ,"mv_ch1" ,"C",15,0,0,"G","","SB1", "", "","MV_PAR01")
	PutSx1(cPerg,"02","Produto até ?"   ,"Produto até ?"   ,"Produto até ?"   ,"mv_ch2" ,"C",15,0,0,"G","","SB1", "", "","MV_PAR02")
	PutSx1(cPerg,"03","Emissão de ?"    ,"Emissão até ?"   ,"Emissão até ?"   ,"mv_ch3" ,"D",08,0,0,"G","","   ", "", "","MV_PAR03")
	PutSx1(cPerg,"04","Emissão até ?"   ,"Emissão até ?"   ,"Emissão até ?"   ,"mv_ch4" ,"D",08,0,0,"G","","   ", "", "","MV_PAR04")
	PutSx1(cPerg,"05","Fornecedor de ?" ,"Fornecedor de ?" ,"Fornecedor de ?" ,"mv_ch5" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR05")
	PutSx1(cPerg,"06","Fornecedor até ?","Fornecedor até ?","Fornecedor até ?","mv_ch6" ,"C",09,0,0,"G","","SA2", "", "","MV_PAR06")
	PutSx1(cPerg,"07","Item Ctbl de ?"  ,"Item Ctbl de ?"  ,"Item Ctbl de ?"  ,"mv_ch7" ,"C",09,0,0,"G","","CTD", "", "","MV_PAR07")
	PutSx1(cPerg,"08","Item Ctbl até ?" ,"Item Ctbl até ?" ,"Item Ctbl até ?" ,"mv_ch8" ,"C",09,0,0,"G","","CTD", "", "","MV_PAR08")
	PutSx1(cPerg,"09","Totaliza por ?"  ,"Totaliza por ?"  ,"Totaliza por ?"  ,"mv_ch9" ,"N",01,0,1,"C","","   ", "", "","MV_PAR09","Item Ctbl","Item Ctbl","Item Ctbl","","Fornecedor","Fornecedor","Fornecedor")
	PutSx1(cPerg,"10","Local Arquivo ?" ,"Local Arquivo ?" ,"Local Arquivo ?" ,"mv_ch10","C",50,0,0,"G","","   ", "", "","MV_PAR10")
Return Nil