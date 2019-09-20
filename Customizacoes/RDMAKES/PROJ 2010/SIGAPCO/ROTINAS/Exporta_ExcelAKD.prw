#include "rwmake.ch"
#include "topconn.ch"

/**********************************************

**********************************************/

User Function ExcelAKD()
                       
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private cPerg      := "ExcelAKD"
Private oGeraTxt           

AjustaPerg(cPerg)
 dbSelectArea("AKD")
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
@ 26,018 Say " AKD                                                       "

@ 70,085 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraCsv()})
@ 70,115 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,144 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

// Cria as perguntas no dicionário de dados
Static Function AjustaPerg(cPerg)
PutSx1(cPerg,"01","Data Inicial ?","Data Inicial ?","Data Inicial ?", "mv_dti", "D", 10, 0, ,"G", "", "", "", "","MV_PAR01")
PutSx1(cPerg,"02","Data Final ?","Data Final ?","Data Final ?", "mv_dtf", "D", 10, 0, ,"G", "", "", "", "","MV_PAR02")
PutSx1(cPerg,"03","CC De ?","CC De ?","CC De ?", "mv_cci", "C", 09, 0, ,"G", "", "CTT", "", "","MV_PAR03")
PutSx1(cPerg,"04","CC Até ?","CC Até ?","CC Até ?", "mv_ccf", "C", 09, 0, ,"G", "", "CTT", "", "","MV_PAR04")
PutSx1(cPerg,"05","Segmento De ?","Segmento De ?","Segmento De ?", "mv_sei", "C", 09, 0, ,"G", "", "CTH", "", "","MV_PAR05")
PutSx1(cPerg,"06","Segmento Até ?","Segmento Até ?","Segmento Até ?", "mv_sef", "C", 09, 0, ,"G", "", "CTH", "", "","MV_PAR06")
PutSx1(cPerg,"07","Conta Orc. De ?","Conta Orc. De ?","Conta Orc. De ?", "mv_coi", "C", 20, 0, ,"G", "", "AK5", "", "","MV_PAR07")
PutSx1(cPerg,"08","Conta Orc. Até ?","Conta Orc. Até ?","Conta Orc. Até ?", "mv_cof", "C", 20, 0, ,"G", "", "AK5", "", "","MV_PAR08")
Return Nil
 
Static Function OkGeraCsv()
local oExcel
Local cArq
Local nArq
Local cPath
Local cTipo := "Arquivos CSV | *.csv"
Local cSql := "" 

   csql := "SELECT AKD_DATA, AKD_CO, AK5.AK5_DESCRI, AKD_TPSALD, AKD_TIPO, AKD_HIST, AKD_COSUP, AKSUP.AK5_DESCRI AS DESCRISUP, AKD_VALOR1,  "
   csql += "AKD_CC, CTT.CTT_DESC01 , AKD_CLVLR, CTH.CTH_DESC01 " 
   csql += "FROM " + RetSqlName("AKD") + " AKD "
   csql += "LEFT JOIN " + RetSqlName("AK5") + " AK5 ON AKD.AKD_CO = AK5.AK5_CODIGO " 
   csql += "LEFT JOIN " + RetSqlName("AK5") + " AKSUP ON AKD.AKD_COSUP = AKSUP.AK5_CODIGO " 
   csql += "LEFT JOIN " + RetSqlName("CTH") + " CTH ON CTH.CTH_CLVL = AKD.AKD_CLVLR " 
   csql += "LEFT JOIN " + RetSqlName("CTT") + " CTT ON CTT.CTT_CUSTO = AKD.AKD_CC " 
   csql += "WHERE AKD.D_E_L_E_T_ <> '*' "  
   csql += "AND AK5.D_E_L_E_T_ <> '*' "
   csql += "AND AKSUP.D_E_L_E_T_ <> '*' "
   csql += "AND CTH.D_E_L_E_T_ <> '*' "
   csql += "AND CTT.D_E_L_E_T_ <> '*' "
   csql += "AND AKD_CO BETWEEN '" + MV_PAR07 + "' AND '" + MV_PAR08 + "' "
   csql += "AND AKD_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
   csql += "AND AKD_CLVLR BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
   csql += "AND AKD_DATA BETWEEN '" + dToS(MV_PAR01) + "' AND '" + dToS(MV_PAR02) + "' "

TcQuery cSql new Alias "AKDTMP"

ProcRegua(LastRec())
 
cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.F.)
nArq  := FCreate(cPath)
 
If nArq == -1 
 
 AKDTMP->(dbCloseArea()) 
 
 MsgAlert("Nao foi possível criar o arquivo!")
 Return
EndIf

// monta os nomes dos campos
nCont := 0
cHeader := ""

dbSelectArea("SX3")
dbSetOrder(2)

//Trim( X3Titulo() )
For nCont := 1 to AKDTMP->(fCount())
	
	// Localizo o campo no sx3
	if(SX3->(dbSeek(AKDTMP->(FieldName(nCont)))))
		cHeader += Trim(X3Titulo())
	elseif AKDTMP->(FieldName(nCont)) == "DESCRISUP"
		cHeader += "Desc. CO Superior"
	else
		cHeader := " "
	EndIf
	
	// adiciono o nome do campo no cHeader
		 
	
	// Controla a separação por ;
	if (nCont != AKDTMP->(fCount()))
		cHeader += ";"
	EndIf
Next nCont

cHeader += ";Valor Orçado;Valor Previsto;Valor Realizado;Previso + Realizado"
 
FWrite(nArq, cHeader + Chr(13) + Chr(10))
 
dbSelectArea("AKDTMP")
dbGoTop()
cConteudo := ""
nGravados := 0
While !AKDTMP->(Eof())
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
 	
 	For nCont := 1 to  AKDTMP->(fCount())
	
  if Trim(AKDTMP->(FieldName(nCont))) $ "AKD_VALOR1"  // conversao de numérico para string
		if (AKDTMP->AKD_TIPO == "2")
  		cConteudo += Strtran(cValToChar(AKDTMP->(FieldGet(nCont) * (-1))), ".", ",")
    Else 
    	cConteudo += StrTran(cValToChar(AKDTMP->(FieldGet(nCont))), ".", ",")      	
   	EndIf 
  	     
    elseif Trim(AKDTMP->(FieldName(nCont))) $ "AKD_DATA"  // conversao de data para string 
   	 	cConteudo += DtoC(SToD(AKDTMP->(FieldGet(nCont))))
  	
   	else                                                 // Campos do tipo texto
 	    cConteudo += AKDTMP->(FieldGet(nCont)) //, ".")
  	EndIf 
  	
		// Controla a separação por ;
		if (nCont != AKDTMP->(fCount()))
			cConteudo += ";"
		EndIf
	
	Next nCont
	
	nValor := iif(AKDTMP->AKD_TIPO == "2", AKDTMP->AKD_VALOR1 * (-1), AKDTMP->AKD_VALOR1)
	
	cOrcado := Strtran(cValToChar(iif(AKDTMP->AKD_TPSALD = "OR", nValor, 0)), ".", ",")
	cPrevisto := Strtran(cValToChar(iif(AKDTMP->AKD_TPSALD = "PR", nValor, 0)), ".", ",")
	cRealizado := Strtran(cValToChar(iif(AKDTMP->AKD_TPSALD = "RE", nValor, 0)), ".", ",")
	cEmpenhado := Strtran(cValToChar(iif(AKDTMP->AKD_TPSALD $ "PR/RE", nValor, 0)), ".", ",")
	cConteudo += ";" + cOrcado + ";" + cPrevisto + ";" + cRealizado + ";" + cEmpenhado 
 	
	// AKD_DATA
	FWrite(nArq, cConteudo + Chr(13) + Chr(10))             

	nGravados++
	AKDTMP->(dbSkip())
End
 
FClose(nArq)

AKDTMP->(dbCloseArea())
     
MsgInfo("Arquivo criado em " + cPath, "Exportação para Excel")
 
 
Return Nil
Static Function NewDlg1()

Return

