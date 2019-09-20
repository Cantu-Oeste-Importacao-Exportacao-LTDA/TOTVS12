#include "rwmake.ch" 
#include "topconn.ch" 


//
//Dioni 03/02/2012
//RELATORIO DE RELAÇAO DE PREÇOS EM EXCEL - TABELA
//RELATÓRIO RETRATO PARA O INDUSTRIALIZADO EM EXCEL


*-------------------------*
User Function RELTPEXC()
*-------------------------*

Local cPerg    := "RELTPEXC"
Local cCaminho := ""    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1(cPerg)

if !(Pergunte(cPerg))
	 Return nil
EndIf
                                                                                     

// Verifica se o caminho para salvar o arquivo é válido.
if !(ExistDir(AllTrim(MV_PAR04)))
	Alert("Diretório para salvar o arquivo não existe. Verifique o caminho informado!")
	Return nil
else
	cCaminho := AllTrim(MV_PAR04)
EndIf

RptStatus({|lEnd| GrvArq(@lEnd, cCaminho) }, "Aguarde...","Exportando para Excel...", .T.)

Return nil

Static function GrvArq(lEnd, cCaminho)
Local cQuery   := "" 
Local cTbDe  := MV_PAR01
Local cTbAte := MV_PAR02
Local cARMAZ := MV_PAR03
Local cCrLf 	 := Chr(13) + Chr(10)
Local cArquivo := "RELTPEXC"
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
Local aFields  := {"B1_COD", "B1_DESC", "DA1_PRCVEN"} 

// Define propriedades dos campos baseado no SX3
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
  If SX3->(DbSeek(aFields[nX]))
    Aadd(aHeader, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                   SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
  Endif
Next nX


cQuery := " SELECT B1_FILIAL, B1_COD, B1_DESC, B1_GRUPO, B1_UM, DA1_PRCVEN, DA1_PRCMIN, B1_FILVEND FROM "+RetSQLName("SB1")+" SB1 ,"
cQuery += RetSQLName("DA1")+" DA1 WHERE B1_EXPALM = '1' AND B1_COD = DA1_CODPRO  AND "
cQuery += " DA1_FILIAL = '" + xFilial("DA1") + "' AND B1_FILIAL = '" + xFilial("SB1") + "' AND "
cQuery += " DA1_CODTAB >= '"+cTbDe+"' AND DA1_CODTAB <= '"+cTbAte+"' AND B1_LOCPAD "
cQuery += " ='"+cARMAZ+"' AND SB1.D_E_L_E_T_ <> '*' AND DA1.D_E_L_E_T_ <> '*' ORDER BY B1_GRUPO, B1_DESC"
//Memowrite("XXX.txt",cQuery)	
TCQUERY cQuery NEW ALIAS "TMP"

// Força o sistema a criar um arquivo
nHandle := MsfCreate(AllTrim(cCaminho) + cArquivo + ".CSV",0)

If nHandle > 0
		
	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	dbSelectArea("TMP")
	TMP->(dbGoTop())                       
  
  While !TMP->(Eof())
    	If TMP->B1_UM = "BJ"
         TMP->(RecLock("TMP",.F.))
	  	   TMP->B1_GRUPO := 'EMBA'
         TMP->(MsUnlock())
	    Endif
  	TMP->(DbSkip())
  End
  _cArqInd1  := CriaTrab(NIL,.F.)
  _cChave1  := "TMP->B1_GRUPO+TMP->B1_DESC"
  SM0->(DbSetOrder(1))
  dbSelectArea("SM0")                   // * Sigamat.emp
  _Filial :=SM0->M0_CODFIL

  dbSelectArea("TMP")
  dbGoTop()
  SetRegua(TMP->(LastRec()))

  dbSelectArea("SBM")
  dbSetOrder(1)
  dbGotop()
  SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
  If TMP->B1_GRUPO == "EMBA"
	   fWrite(nHandle, cCrLf ) // Pula linha
	   fWrite(nHandle, "EMBALADOS" +";")
  Else
 	  fWrite(nHandle, cCrLf ) // Pula linha
 	  fWrite(nHandle, SBM->BM_DESC +";") 
  Endif
  grupo:=TMP->B1_GRUPO
  fWrite(nHandle, cCrLf ) // Pula linha
  While TMP->(!EOF())
	  if TMP->B1_GRUPO <> GRUPO
       SBM->(dbGotop())
       SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
       grupo:=TMP->B1_GRUPO
       fWrite(nHandle, cCrLf ) // Pula linha
       If TMP->B1_GRUPO == "EMBA"
	        fWrite(nHandle, cCrLf ) // Pula linha
	        fWrite(nHandle, "EMBALADOS" +";")
       Else
	        fWrite(nHandle, cCrLf ) // Pula linha
	        fWrite(nHandle, SBM->BM_DESC +";")
       Endif
       //fWrite(nHandle, cCrLf ) // Pula linha     
       //fWrite(nHandle, cCrLf ) // Pula linha
       endIf
       // Grava registro
       fWrite(nHandle, cCrLf ) // Pula linha 
       fWrite(nHandle, cValToChar(TMP->B1_COD) +";"+ TMP->B1_DESC +";"+ cValToChar(Transform(TMP->DA1_PRCVEN, "@E 999,999,999.99")) +";")
   
       //para gerar em duas colunas
      // TMP->(dbSkip())
     /*  if TMP->B1_GRUPO <> GRUPO
          SBM->(dbGotop())
          SBM->(dbSeek(xFilial("SBM")+AllTrim(TMP->B1_GRUPO)))
          grupo:=TMP->B1_GRUPO 
          fWrite(nHandle, cCrLf ) // Pula linha
          //fWrite(nHandle, cCrLf ) // Pula linha
          if TMP->B1_GRUPO == "EMBA"
	           fWrite(nHandle, cCrLf ) // Pula linha
	           fWrite(nHandle, "EMBALADOS" +";")
          Else
	          fWrite(nHandle, cCrLf ) // Pula linha
	          fWrite(nHandle, SBM->BM_DESC +";")            
          Endif
          fWrite(nHandle, cCrLf ) // Pula linha
                  
       endIf
       If Alltrim(TMP->B1_COD) == "01.0299"
    	    MsgBox(Alltrim(TMP->B1_DESC))
       Endif
          
       fWrite(nHandle, ";"+cValToChar(TMP->B1_COD) +";"+ TMP->B1_DESC +";"+ cValToChar(Transform(TMP->DA1_PRCVEN, "@E 999,999,999.99"))) 
       */
   	 //dbSelectArea("TMP")
		 dbSkip()
   TMP->(dbSkip())
  Enddo

  fClose(nHandle)
  CpyS2T(SubStr(cCaminho,3,len(AllTrim(cCaminho))) + cArquivo + ".CSV", SubStr(cCaminho,1,2), .T.)
	
  /*If ! ApOleClient( 'MsExcel' )
	   	MsgAlert( 'MsExcel nao instalado')
		  Return
  EndIf
	
  oExcelApp := MsExcel():New()
  oExcelApp:WorkBooks:Open(AllTrim(cCaminho) + cArquivo + ".CSV") // Abre uma planilha 
  oExcelApp:SetVisible(.T.)
	*/
  MsgInfo("Arquivo "+AllTrim(cCaminho) + cArquivo + ".csv"+" gerado com sucesso.")
	
Else
 	MsgAlert("Falha na criação do arquivo")
Endif
TMP->(dbCloseArea())
Return .T.
//Return


Static Function AjustaSX1(cPerg) 

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PadR("RELTPEXC",len(sx1->x1_grupo))
aRegs:={}

PutSx1(cPerg,"01","Tabela de ?"    ,"Tabela de ?"    ,"Tabela de ?"    ,"mv_ch1" ,"C",15,0,0,"G","","DA0", "", "","MV_PAR01")
PutSx1(cPerg,"02","Tabela ate ?"    ,"Tabela ate ?"    ,"Tabela ate ?"    ,"mv_ch2" ,"C",15,0,0,"G","","DA0", "", "","MV_PAR02")
PutSx1(cPerg,"03","Armazem ?"    ,"Armazem ?"    ,"Armazem ?"    ,"mv_ch3" ,"C",15,0,0,"G","","SZA000", "", "","MV_PAR03")
PutSx1(cPerg,"04","Local Arquivo ?"    ,"Local Arquivo ?"    ,"Local Arquivo ?"    ,"mv_ch4" ,"C",15,0,0,"G","","", "", "","MV_PAR04")
       
Return