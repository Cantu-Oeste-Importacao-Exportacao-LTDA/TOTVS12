#include "rwmake.ch"
#include "topconn.ch"

/**********************************************

**********************************************/

User Function ExcelCT2()
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg      := "ExcelCT2"
Private oGeraTxt            


AjustaPerg(cPerg)

 dbSelectArea("CT2")
 dbSetOrder(1)  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo CSV")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo CSV, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " CT2                                                        "

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
local oExcel
Local cArq
Local nArq
Local cPath
Local cTipo := "Arquivos CSV | *.csv"
Local cSql := "" 

   csql := "SELECT CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_DEBITO, CT2_CREDIT,  CT2_VALOR, CT2_HIST, "
   csql += "CT2.CT2_CCC, CT2_CCD, CT2_CLVLDB, CT2_CLVLCR " 
   csql += "FROM " + RetSqlName("CT2") + " CT2 "
   csql += "WHERE CT2.D_E_L_E_T_ <> '*' "
   csql += "AND CT2_DATA BETWEEN '" + dToS(MV_PAR01) + "' AND '" + dToS(MV_PAR02) + "' "
   
TcQuery cSql new Alias "CT2TMP"

ProcRegua(LastRec())
 
cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.F.)
nArq  := FCreate(cPath)
 
If nArq == -1 
 
 CT2TMP->(dbCloseArea()) 
 
 MsgAlert("Nao foi possível criar o arquivo!")
 Return
EndIf

// monta os nomes dos campos
nCont := 0
cHeader := ""

dbSelectArea("SX3")
dbSetOrder(2)

//Trim( X3Titulo() )
For nCont := 1 to CT2TMP->(fCount())
	
	// Localizo o campo no sx3
	SX3->(dbSeek(CT2TMP->(FieldName(nCont))))
	
	// adiciono o nome do campo no cHeader
	cHeader += Trim(X3Titulo())	 
	
	// Controla a separação por ;
	if (nCont != CT2TMP->(fCount()))
		cHeader += ";"
	EndIf
Next nCont
 
FWrite(nArq, cHeader + Chr(13) + Chr(10))
 
dbSelectArea("CT2TMP")
dbGoTop()
cConteudo := ""
nGravados := 0
While !CT2TMP->(Eof())
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
 	
 	For nCont := 1 to  CT2TMP->(fCount())
	
  	if Trim(CT2TMP->(FieldName(nCont))) $ "CT2_VALOR"  // conversao de numérico para string
      	cConteudo += cValToChar(CT2TMP->(FieldGet(nCont)))          	
      	
   	EndIf 
  	     
    if Trim(CT2TMP->(FieldName(nCont))) $ "CT2_DATA"  // conversao de data para string 
   	 	 cConteudo += DtoC(SToD(CT2TMP->(FieldGet(nCont))))
  	
   	else                                                 // Campos do tipo texto
 	     cConteudo += cValToChar(CT2TMP->(FieldGet(nCont)), ";")//, ".")
  	
  	EndIf 
  	
  	// Controla a separação por ;
		if (nCont != CT2TMP->(fCount()))
			 cConteudo += ";"
		EndIf
	
 	Next nCont
 	
	// CT2_DATA
 	FWrite(nArq, cConteudo + Chr(13) + Chr(10))             
 	
 	nGravados++
 	CT2TMP->(dbSkip())
End
 
FClose(nArq)

CT2TMP->(dbCloseArea())

MsgInfo("Arquivo criado em " + cPath, "Exportação para Excel")
 
 
Return Nil
Static Function NewDlg1()
/*
A tag abaixo define a criação e ativação do novo diálogo. Você pode colocar esta tag
onde quer que deseje em seu código fonte. A linha exata onde esta tag se encontra, definirá
quando o diálogo será exibido ao usuário.
Nota: Todos os objetos definidos no diálogo serão declarados como Local no escopo da
função onde a tag se encontra no código fonte.
*/


Return

