#include "rwmake.ch"
#include "topconn.ch"
/**********************************************

**********************************************/
User Function ExcelSE5()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg       := "ExcelSE5"
Private oGeraTxt

Private cString := "SE5"

AjustaPerg(cPerg)

dbSelectArea("SA1")
dbSetOrder(1)     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamentoe.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo CSV")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo CSV, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SE5                                                           "

@ 70,085 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraCsv()})
@ 70,115 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,144 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

// Cria as perguntas no dicionário de dados
Static Function AjustaPerg(cPerg)
PutSx1(cPerg,"01","Data Inicial ?","Data Inicial ?","Data Inicial ?", "mv_dti", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Data Final ?","Data Final ?","Data Final ?", "mv_dtf", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
Return Nil

Static Function OkGeraCsv()
Local oExcel
Local cArq
Local nArq
Local cPath
Local cTipo := "Arquivos CSV | *.csv"
Local cSql := "" 

// fazer o sql  
  csql := "SELECT E5_FILIAL, E5_DATA, E5_TIPO, E5_TIPODOC, E5_VALOR, E5_NUMERO, E5_NATUREZ, ED_DESCRIC, " 
  csql += "E5_BANCO, E5_AGENCIA, E5_CONTA, E5_NUMCHEQ, E5_RECPAG, E5_BENEF, " 
  csql += "E5_HISTOR, E5_LOTE, E5_PREFIXO, E5_PARCELA, E5_CLIENTE, E5_LOJA, A1_NOME "
  csql += "FROM " + RetSqlName("SE5") + " SE5 "
  csql += "LEFT JOIN " + RetSqlName("SED") + " SED ON SED.ED_CODIGO = SE5.E5_NATUREZ AND SED.D_E_L_E_T_ <> '*' "
  csql += "LEFT JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = E5_CLIENTE AND A1_LOJA = E5_LOJA AND SA1.D_E_L_E_T_ <> '*' "
  csql += "WHERE E5_TIPODOC in ('DC','JR','MT','BA','MT','CM','D2','J2','M2','C2','V2','CX','CP','TL','VL')  "
  csql += "AND E5_SITUACA <> 'C' "
  csql += "AND E5_BANCO <> ' ' " 
  csql += "AND E5_AGENCIA <> ' ' "
  csql += "AND E5_CONTA <> ' ' "
  cSql += "AND E5_DATA BETWEEN '" + dToS(MV_PAR01) + "' AND '" + dToS(MV_PAR02) + "' "
  csql += "AND SE5.D_E_L_E_T_ <> '*' "
  csql += "ORDER BY A1_NOME, SE5.E5_TIPODOC" 

TcQuery cSql new Alias "SE5TMP"   
/*If !ApOleClient("MSExcel")
 MsgAlert("Microsoft Excel não instalado!")
 Return
EndIf */

ProcRegua(LastRec())
 
cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.F.)
nArq  := FCreate(cPath)
 
If nArq == -1

 SE5TMP->(dbCloseArea())
 MsgAlert("Nao foi possível criar o arquivo!")
 Return
EndIf

// monta os nomes dos campos
nCont := 0
cHeader := ""

dbSelectArea("SX3")
dbSetOrder(2)

//Trim( X3Titulo() )
For nCont := 1 to SE5TMP->(fCount())
	
	// Localizo o campo no sx3
	SX3->(dbSeek(SE5TMP->(FieldName(nCont))))
	
	// adiciono o nome do campo no cHeader
	cHeader += Trim(X3Titulo())	 
	
	// Controla a separação por ;
	if (nCont != SE5TMP->(fCount()))
		cHeader += ";"
	EndIf
Next nCont
 
FWrite(nArq, cHeader + Chr(13) + Chr(10))
 
dbSelectArea("SE5TMP")
dbGoTop()
cConteudo := ""
nGravados := 0
While !SE5TMP->(Eof())
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
 	
 	For nCont := 1 to  SE5TMP->(fCount())
  	
  	if Trim(SE5TMP->(FieldName(nCont))) $ "E5_VALOR"  // conversao de numérico para string
  	  
  		// Controla se o valor é recebimento ou pagamento deixando negativo caso for um pagamento
  		if ((SE5TMP->E5_RECPAG == "P") .or. (SE5TMP->E5_TIPODOC == "DC"))
  			cConteudo += cValToChar(SE5TMP->(FieldGet(nCont) * (-1)))
  		Else
  			cConteudo += cValToChar(SE5TMP->(FieldGet(nCont)))
  		EndIf
  	
  	elseif Trim(SE5TMP->(FieldName(nCont))) $ "E5_DATA"  // conversao de data para string 
  		cConteudo += DtoC(SToD(SE5TMP->(FieldGet(nCont))))
  	
  	else                                                 // Campos do tipo texto
  		cConteudo += StrTran(SE5TMP->(FieldGet(nCont)), ";", ".")
  	EndIf 
  	
  	// Controla a separação por ;
		if (nCont != SE5TMP->(fCount()))
			cConteudo += ";"
		EndIf
	
 	Next nCont
 	
	// E5_DATA
 	FWrite(nArq, cConteudo + Chr(13) + Chr(10))
 	nGravados++
 	SE5TMP->(dbSkip())
End
 
FClose(nArq)

SE5TMP->(dbCloseArea())

MsgInfo("Arquivo criado em " + cPath, "Exportação para Excel")
 
/*oExcel := MSExcel():New()
oExcel:WorkBooks:Open(cPath)
oExcel:SetVisible(.T.)
oExcel:Destroy()*/
Return Nil