#include "rwmake.ch"
#include "protheus.ch"

User Function GeraNSU(cNF, cSerie, cCliForn, cLoja, dDtGera, cHrGera, cTipo, cMotivo)
Local cNsu := ""
Local cAlias := "SZC"
Local cNum       

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

// Verificar as empresas que usam e as filiais
If (cEmpAnt == "50" .And. (cFilAnt == "05" .Or. cFilAnt == "11")) .Or. cEmpAnt == "10" .Or. cEmpAnt == "08"	
	DbSelectArea(cAlias)
	RecLock(cAlias, .T.)
	cNsu := GetSXENum(cAlias, "ZC_NSU")	
	ZC_FILIAL := xFilial(cAlias)
	ZC_NSU := cNsu
	ZC_NF := cNF
	ZC_SERIE := cSerie
	ZC_FORCLI := cCliForn
	ZC_LOJA := cLoja
	ZC_DTGERA := dDtGera
	ZC_HRGERA := Left(cHrGera, 5)
	ZC_TIPDOC := cTipo
	ZC_MOTIVO := cMotivo
	MsUnLock(cAlias)
	ConfirmSX8()	
EndIf
Return cNsu


// Fun��o responsavel por atualizar a data e hora de impress�o e obter a descri��o do NSU quando gerado
User Function Atu_NSU(cNF, cSerie, cCliForn, cLoja, cTipo)
Local cAlias := "SZC"
Local cMsgNsu := ""

//�����������������������������������������������������
//�Chama fun��o para monitor uso de fontes customizados�
//�����������������������������������������������������
U_USORWMAKE(ProcName(),FunName())

If (cEmpAnt == "50" .And. (cFilAnt == "05" .Or. cFilAnt == "11")) .Or. cEmpAnt == "10" .Or. cEmpAnt == "08"	
	DbSelectArea(cAlias)
	DbSetOrder(2) // ZC_FILIAL+ZC_TIPDOC+ZC_NF+ZC_SERIE+ZC_FORCLI+ZC_LOJA
	if DbSeek(xFilial(cAlias) + cTipo + cNF + cSerie + cCliForn + cLoja)
	  // obt�m toda a descri��o da NF com relacao ao NSU a ser impressa
	  //cMsgNsu := "Impress�o da Nota Fiscal: " + DToC(Date()) + " " + Left(Time(), 5) + chr(13) + chr(10)
	  
	  cMsgNsu := "NSU " + ZC_NSU// + chr(13) + chr(10)
    
    //cMsgNsu += "Gera��o do NSU: " + DToC(ZC_DTGERA) + " " + ZC_HRGERA	  
	  // atualiza a data e hora de impress�o
	  RecLock(cAlias, .F.)
	  ZC_DTIMPR := Date()
	  ZC_HRIMPR := Left(Time(), 5)	  
	  MsUnLock(cAlias)
	EndIf
EndIf
Return cMsgNsu