#include "rwmake.ch"
#include "topconn.ch"

/**********************************************
 Função responsável para gerar o aquivo para
 atualização de cadastro utilizada pelo Serasa
 Deve ser usada somente para Clientes
 **********************************************/
 
User Function ExpCadSerasa()
Local cSql
Local nCount := 1
Local cArquivo := "01"
Local cFileSave := "c:\Cad_Serasa_"+ cEmpAnt + "_"
Local cFileEx := ".txt"
Local cLin := ""
Private nHdl    := 0 // fCreate(cArqTxt)
Private cEOL    := CHR(13)+CHR(10)
cSql := "select a1_pessoa, a1_cgc, a1_est from " + RetSQLName("SA1")
cSql += " where d_e_l_e_t_ <> '*'"

TCQUERY cSql NEW ALIAS "TMPCLI"  

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

While TMPCLI->(!Eof())
	// não manda clientes do exterior
	If (TMPCLI->A1_EST == "EX") .Or. (AllTrim(A1_CGC) == "")
		TMPCLI->(DbSkip())
		Loop
	EndIf
	     
	// gera a linha do arquivo
	if TMPCLI->A1_PESSOA == "F"
	  cLin := A1_EST + AllTrim(A1_CGC)
	else
		cLin := AllTrim(A1_CGC)
	EndIf
	
	cLin := cLin + cEOL
	
	If (nCount == 1)
		// Cria o aquivo e adiciona as linhas iniciais
		cArqTxt := cFileSave + cArquivo + cFileEx
		nHdl := fCreate(cArqTxt)
		// adiciona as linhas
    GravaLinha("1" + cEOL)
    GravaLinha("C" + cEOL)
    GravaLinha("N" + cEOL)
	EndIf
	
	GravaLinha(cLin)
	
  nCount ++
  
  If (nCount == 5000)
  	cArquivo := Soma1(cArquivo)
  	nCount := 1
  	fClose(nHdl)
  	nHdl := 0
  EndIf
  
  TMPCLI->(dbSkip())
EndDo

TMPCLI->(dbCloseArea())

if (nHdl <> 0)
  fClose(nHdl)
EndIf

MsgInfo("Arquivos gerados em C:\ com o nome Cad_Serasa_" + cEmpAnt + "_xx.txt", "Atenção")

Return

Static Function GravaLinha(cLin)
fWrite(nHdl,cLin,Len(cLin))
Return Nil