//Exporta para ARQUIVO .dat
#INCLUDE "protheus.ch"
#include "Fileio.ch" 
#include "rwmake.ch"
#include "topconn.ch"  

User Function ExpNfGM()
  
Private cPerg       := "ExpNfFornecGM"
Private oGeraTxt

Private cString := "ZZW"    

AjustaPerg(cPerg)       

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

dbSelectArea("ZZW")
dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamentoe.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Geração de Arquivo DAT")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo Dat, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " ZZW                                                           "

@ 70,085 BMPBUTTON TYPE 01 ACTION Processa({|| OkGeraDat()})
@ 70,115 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 70,144 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

//Cria as perguntas no dicionário de dados
Static Function AjustaPerg(cPerg)
PutSx1(cPerg,"01","Pacote ?","Pacote ?","Pacote ?", "mv_par01", "C", 30, 0, 0,"G", "", "ZZW", "", "","MV_PAR01")

Return Nil

Static Function OkGeraDat()
Local oDat
Local cArq
Local nArq
Local cPath  
Local cTipo := "Arquivos Dat | *.dat"
Local cSql := "" 
Local cAno  := ""
Local cMes  := ""
Local cDia  := ""
Local cHora := ""
Local cDataHora := ""
Local cNome := ""

if !IncNFZZW()
	Alert("Não há dados para geração do arquivo. Verifique se os pedidos já foram faturados antes da geração do arquivo de NFs.")
	Return nil
EndIf      

  csql := "SELECT Z.ZZW_PACOTE, Z.ZZW_PECA, Z.ZZW_CLIGM, Z.ZZW_PEDCLI, " 
  csql += "Z.ZZW_NFGERA,Z.ZZW_SERGER,Z.ZZW_FORNEC,Z.ZZW_DTNFGE, "
  csql += "Z.ZZW_TIPO,Z.ZZW_NPEDGM,Z.ZZW_QTDE, "
  csql += "Z.ZZW_VAITEM,Z.ZZW_VALIPI,Z.ZZW_VAlICM, "  
  csql += "Z.ZZW_ICMRET,Z.ZZW_CONTAT,Z.ZZW_LINHAP "
  csql += "FROM " + RetSqlName("ZZW") + " Z "
  csql += "WHERE  Z.D_E_L_E_T_<> '*' AND Z.ZZW_PACOTE = '"+MV_PAR01+ "' "
  cSql += " AND Z.ZZW_STATUS = '2'"
 
TcQuery cSql new Alias "ZZWTMP"   

ProcRegua(LastRec())

cAno  := StrZero(Year(dDataBase),4)
cMes  := StrZero(Month(dDataBase),2)
cDia  := StrZero(Day(dDataBase),2)
cHora := SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)

cDataHora := cAno + cMes + cDia + cHora
cNome := "NFFORN"+cDataHora+".dat"
 
cPath := cGetFile( cTipo , "Selecione onde salvar o arquivo", 0,"",.F., GETF_RETDIRECTORY + GETF_LOCALHARD)
if ExistDir(cPath)
	nArq  := FCreate(cPath+cNome)	
else
	Alert("Diretório inválido!")
	ZZWTMP->(DbCloseArea())
	Return nil
EndIf

 
If nArq == -1
   ZZWTMP->(dbCloseArea())
   MsgAlert("Nao foi possível criar o arquivo!")
 Return
EndIf

nCont := 0

dbSelectArea("ZZWTMP")
dbGoTop()
cConteudo := ""
cHeader := ""    
cTrailler:= ""
nGravados := 0

//Grava no inicio do arquivo
cHeader := "HEADER"+cNome
FWrite(nArq, PadR(cHeader,123) + Chr(13) + Chr(10))
While !ZZWTMP->(Eof())
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
  	
	//For nCont := 1 to ZZWTMP->(fCount())

  dbSelectArea("ZZWTMP")      

  cConteudo := PadL(ZZWTMP->ZZW_PECA, 8) 
  cConteudo += PadL(ZZWTMP->ZZW_CLIGM, 6)
  cConteudo += PadL(ZZWTMP->ZZW_NPEDGM, 6)  
  cConteudo += StrZero(Val(ZZWTMP->ZZW_NFGERA), 9) 
  cConteudo += StrZero(Val(ZZWTMP->ZZW_SERGER), 3)
  cConteudo += PadL(ZZWTMP->ZZW_FORNEC, 9)
  cConteudo += SubStr(ZZWTMP->ZZW_DTNFGE, 7, 2) + SubStr(ZZWTMP->ZZW_DTNFGE, 5, 2) + SubStr(ZZWTMP->ZZW_DTNFGE, 1, 4)  //PadL(ZZWTMP->ZZW_DTNFGE, 8)  
  cConteudo += PadL(ZZWTMP->ZZW_TIPO, 1) 
  cConteudo += PadL(ZZWTMP->ZZW_PEDCLI, 9) 
  cConteudo += StrZero(Round(ZZWTMP->ZZW_QTDE, 0), 5) 
  cConteudo += StrZero(ZZWTMP->ZZW_VAITEM * 100, 13)
  cConteudo += StrZero(ZZWTMP->ZZW_VALIPI * 100, 9)
  cConteudo += StrZero(ZZWTMP->ZZW_VALICM * 100, 9)
  cConteudo += StrZero(ZZWTMP->ZZW_ICMRET * 100, 9)
  cConteudo += StrZero(0,9)
  cConteudo += PadR(Trim(SuperGetMv("MV_X_CONGM",,"2Z2R0000")),8)
  cConteudo += PadL(ZZWTMP->ZZW_LINHAP, 5)
  cConteudo += Space(3)
  
 	//Next nCont
 	FWrite(nArq, PadR(cConteudo,129) + Chr(13) + Chr(10))  
 	nGravados++ 
  
  ZZWTMP->(dbSkip())
  
End
//Grava no final do arquivo  
cTrailler := "TRAILLER" + StrZero(nGravados+2,5)
FWrite(nArq, PadR(cTrailler,123) + Chr(13) + Chr(10))
 	
FClose(nArq)

U_RenFile(cPath, cNome)

ZZWTMP->(dbCloseArea())

MsgInfo("Arquivo criado em " + cPath + cNome, "Exportação para Arquivo .dat")
                   

Return Nil

User Function RenFile(cPath, cNome)
Local cEol := CHR(13)+CHR(10)
Local nBat := 0
Local cContBat := ""    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

// Executa um arquivo .bat temporário para renomear o arquivo
nBat := FCreate(cPath+"temp.bat")
cContBat := "@echo ...renomeando arquivo "+Lower(cNome)+"..."+cEol
cContBat += 'cd "'+cPath+'"'+cEol
cContBat += "rename "+Lower(cNome)+" "+Upper(cNome)+cEol
cContBat += "exit"
FWrite(nBat, cContBat)
FClose(nBat)
WinExec(cPath+"temp.bat")

Return nil

Static function IncNFZZW()

Local lRet := .F.
Local cQuery := ""
Local cCodEmp := ""

cCodEmp := SM0->M0_CODIGO

cQuery := "SELECT ZZW.ZZW_CODEMP AS EMP, ZZW.ZZW_CODFIL AS FILIAL, ZZW.ZZW_PACOTE AS PACOTE, ZZW.ZZW_PEDCLI AS PEDCLI, "
cQuery += "       ZZW.ZZW_PECA AS ITEM, ZZW.ZZW_NUMPED AS PEDIDO, D2.D2_DOC AS NF, D2.D2_SERIE AS SERIE, D2.D2_EMISSAO AS EMISSAO, "
cQuery += "       A7.A7_PRODUTO AS PRODUTO, D2.D2_VALIPI AS VALIPI, D2.D2_VALICM AS VALICM, D2.D2_ICMSRET AS ICMSRET, D2.D2_TOTAL AS TOTAL "
cQuery += "FROM "+retSqlName("ZZW")+" ZZW "

cQuery += "INNER JOIN "+retSqlName("SC6")+ " C6 "
cQuery += " ON C6.C6_FILIAL = ZZW.ZZW_CODFIL "
cQuery += "AND C6.C6_NUM = ZZW.ZZW_NUMPED "
cQuery += "AND C6.D_E_L_E_T_ <> '*' "

cQuery += "INNER JOIN " +retSqlName("SA7")+ " A7 "
cQuery += " ON A7.A7_CLIENTE = C6.C6_CLI "
cQuery += "AND A7.A7_LOJA = C6.C6_LOJA "
cQuery += "AND A7.A7_CODCLI = ZZW.ZZW_PECA "
cQuery += "AND A7.D_E_L_E_T_ <> '*' "

cQuery += "INNER JOIN "+ retSqlName("SD2") +" D2 "
cQuery += " ON D2.D2_DOC = C6.C6_NOTA "
cQuery += "AND D2.D2_SERIE = C6.C6_SERIE "
cQuery += "AND D2.D2_COD = A7.A7_PRODUTO "
cQuery += "AND D2.D_E_L_E_T_ <> '*' "

cQuery += "WHERE ZZW.ZZW_NUMPED <> ' ' "
cQuery += "  AND ZZW.ZZW_STATUS = '2' "
cQuery += "  AND ZZW.ZZW_CODEMP = '" + cCodEmp + "' "
cQuery += "  AND ZZW.ZZW_PACOTE = '" + MV_PAR01 + "' "
cQuery += "  AND ZZW.D_E_L_E_T_ <> '*' "

TcQuery cQuery new Alias "ZZWATU"

DbSelectArea("ZZWATU")
DbGoTop()

if ZZWATU->(EOF())
	ZZWATU->(DbCloseArea())
	Return .F.
EndIf

while !ZZWATU->(EOF())
	
	DbSelectArea("ZZW")
	DbSetOrder(4)
	if (DbSeek(xFilial("ZZW") + ZZWATU->PACOTE + ZZWATU->PEDCLI + ZZWATU->ITEM))
    RecLock("ZZW", .F.)  
		
		ZZW->ZZW_NFGERA := ZZWATU->NF
		ZZW->ZZW_SERGER := ZZWATU->SERIE
		ZZW->ZZW_DTNFGE := ZZWATU->EMISSAO
		ZZW->ZZW_VALIPI := ZZWATU->VALIPI
		ZZW->ZZW_VALICM := ZZWATU->VALICM
		ZZW->ZZW_ICMRET := ZZWATU->ICMSRET
		ZZW->ZZW_VAITEM := ZZWATU->TOTAL
		
		ZZW->(MsUnlock())
	else
		Alert("Não encontrei chave na tabela ZZW!"+CHR(13)+CHR(10)+;
					"Filial: "+xFilial("ZZW")+CHR(13)+CHR(10)+;
					"Pacote: "+ZZWATU->PACOTE+CHR(13)+CHR(10)+;
					"Ped. Cliente: "+ZZWATU->PEDCLI+CHR(13)+CHR(10)+;
					"Produto: "+ZZWATU->ITEM)
	EndIf
	ZZWATU->(DbSkip())		
End   

ZZWATU->(DbCloseArea())

lRet := .T.

Return lRet
