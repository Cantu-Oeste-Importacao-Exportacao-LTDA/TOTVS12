//Gerando ARQUIVO TEXTO 13/09/11  

#INCLUDE "protheus.ch"
#include "Fileio.ch" 
#include "rwmake.ch"
#include "topconn.ch"  

User Function ExpEstGM()

Private cPerg       := "ExpEstoqueGM"
Private oGeraTxt

Private cString := "ZZW"     

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())
 
AjustaPerg(cPerg)

dbSelectArea("ZZW")
dbSetOrder(1)                

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamentoe.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                             l

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

	if !IncQtdZZW() //chamada da funçao 
		Alert("Não foi possível gerar o arquivo. Verifique se foram gerados os pedidos referente ao pacote informado.")
		Return
	EndIf
	   
  csql := "SELECT Z.ZZW_PACOTE, Z.ZZW_PECA, Z.ZZW_CLIGM, Z.ZZW_PEDCLI, " 
  csql += "Z.ZZW_QTDENT,Z.ZZW_DTPED,Z.ZZW_FORNEC,Z.ZZW_TIPO,Z.ZZW_NPEDGM,Z.ZZW_PESO, " 
  csql += "Z.ZZW_VOLUME,Z.ZZW_LINHAP "
  csql += "FROM " + RetSqlName("ZZW") + " Z "
  csql += "WHERE  Z.D_E_L_E_T_<> '*' AND Z.ZZW_PACOTE = '"+MV_PAR01+ "'
  csql += "AND Z.ZZW_STATUS = '1' "
  csql += "AND Z.ZZW_NUMPED > '0' " 
  
TcQuery cSql new Alias "ZZWTMP"   

ProcRegua(LastRec())
 
cAno  := StrZero(Year(dDataBase),4)
cMes  := StrZero(Month(dDataBase),2)
cDia  := StrZero(Day(dDataBase),2)
cHora := SubStr(Time(),1,2)+SubStr(Time(),4,2)+SubStr(Time(),7,2)

cDataHora := cAno + cMes + cDia + cHora
cNome := "ESTQFO"+cDataHora+".dat"
 
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
cHeader := PadR("HEADER"+cNome,84)
FWrite(nArq, cHeader + Chr(13) + Chr(10))
While !ZZWTMP->(Eof())
	cConteudo := ""
	
	// Controle do processamento
	IncProc("Processados "+ cValToChar(nGravados) +" registros")
  	
 
	For nCont := 1 to  ZZWTMP->(fCount())


  dbSelectArea("ZZWTMP")
      
     cConteudo := PadL(ZZWTMP->ZZW_PECA, 8) 
     cConteudo += PadL(ZZWTMP->ZZW_CLIGM, 6)
     cConteudo += PadL(ZZWTMP->ZZW_NPEDGM, 6)  
     cConteudo += StrZero(Round(ZZWTMP->ZZW_QTDENT, 0), 5) 
     cConteudo += SubStr(ZZWTMP->ZZW_DTPED, 7, 2) + SubStr(ZZWTMP->ZZW_DTPED, 5, 2) + SubStr(ZZWTMP->ZZW_DTPED, 1, 4)  //PadL(ZZW->ZZW_DTPED, 8) 
     cConteudo += PadL(ZZWTMP->ZZW_FORNEC, 9)
     cConteudo += PadL(ZZWTMP->ZZW_TIPO, 1)  
     cConteudo += PadL(ZZWTMP->ZZW_PEDCLI, 9)
     cConteudo += StrZero(Round(ZZWTMP->ZZW_PESO, 0), 7)
     cConteudo += StrZero(Round(ZZWTMP->ZZW_VOLUME, 0), 5)  
     cConteudo += PadL(ZZWTMP->ZZW_LINHAP, 5)              
     
 	Next nCont
  	FWrite(nArq, PadR(cConteudo,84) + Chr(13) + Chr(10))  
   	nGravados++ 
   	 //Grava no banco o campo Status da tabela ZZW para 3
  DbSelectArea("ZZW")
  DbSetOrder(4)

  //altera o status da tabela para 2
  if DbSeek(xFilial("ZZW") + ZZWTMP->ZZW_PACOTE + ZZWTMP->ZZW_PEDCLI + ZZWTMP->ZZW_PECA)
     RecLock("ZZW")
     ZZW->ZZW_STATUS := "2"
     ZZW->(MsUnlock())
  // else
  //    MsgInfo("Tabela sem registro.")
  EndIf
   	
 	ZZWTMP->(dbSkip())
 	
End
//Grava no final do arquivo  
cTrailler := "TRAILLER" + StrZero(nGravados+2,5)
FWrite(nArq, PadR(cTrailler,84) + Chr(13) + Chr(10))
 	
FClose(nArq)

U_RenFile(cPath, cNome)

ZZWTMP->(dbCloseArea())

MsgInfo("Arquivo criado em " + cPath, "Exportação para Arquivo .dat")
                   
Return Nil


//Atualiza a qtdeEnt
Static function IncQtdZZW()
Local lRet := .F.
Local cQuery := ""
Local cCodEmp := ""
Local cEol    := CHR(13)+CHR(10)

cCodEmp := SM0->M0_CODIGO

cQuery := "SELECT ZZW.ZZW_CODEMP AS EMP, ZZW.ZZW_CODFIL AS FILIAL, ZZW.ZZW_PACOTE AS PACOTE, ZZW.ZZW_PEDCLI AS PEDCLI, " 	+cEol
cQuery += "ZZW.ZZW_PECA AS ITEM, ZZW.ZZW_NUMPED AS PEDIDO, ZZW.ZZW_QTDENT AS QTDEENT, ZZW.ZZW_VAITEM AS TOTITE,  "       	+cEol
cQuery += "C6.C6_QTDVEN, C6.C6_VALOR AS TOTAL, A1.A1_COD, A1.A1_LOJA, A7.A7_PRODUTO  "                                   	+cEol
cQuery += "FROM " + RetSqlName("ZZW") + " ZZW "                                                                          	+cEol
                                                                                                                         
cQuery += "INNER JOIN " + RetSqlName("SA1") + " A1 "                                                                    	+cEol
cQuery += " ON A1.A1_X_CLIGM = ZZW.ZZW_CLIGM "                                                                           	+cEol
cQuery += "AND A1.D_E_L_E_T_ <> '*' "  																																										+cEol

cQuery += "INNER JOIN " + RetSqlName("SC6") + " C6 "                                                                     	+cEol
cQuery += " ON C6.C6_FILIAL = ZZW.ZZW_CODFIL "                                                                           	+cEol
cQuery += "AND C6.C6_NUM = ZZW.ZZW_NUMPED "                                                                             	+cEol
cQuery += "AND C6.D_E_L_E_T_ <> '*' "                                                                                    	+cEol

cQuery += "INNER JOIN " + RetSqlName("SA7") + " A7 "                                                                     	+cEol
cQuery += " ON A7.A7_CLIENTE = C6.C6_CLI "                                                                              	+cEol
cQuery += "AND A7.A7_LOJA = C6.C6_LOJA "                                                                                 	+cEol
cQuery += "AND A7.A7_CODCLI = ZZW.ZZW_PECA "                                                                             	+cEol
cQuery += "AND A7.D_E_L_E_T_ <> '*' "                                                                                    	+cEol
     
cQuery += "WHERE ZZW.ZZW_NUMPED <> ' ' "                                                                                 	+cEol
cQuery += "AND ZZW.ZZW_STATUS = '1' "                                                                                    	+cEol
cQuery += "AND C6.C6_PRODUTO = A7.A7_PRODUTO "                                                                           	+cEol
cQuery += "AND ZZW.ZZW_CODEMP = '" + cCodEmp + "' "                                                                      	+cEol
cQuery += "AND ZZW.ZZW_PACOTE = '" + MV_PAR01 + "' "                                                                     	+cEol
cQuery += "AND ZZW.D_E_L_E_T_ <> '*' "

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄL¿
//³Mensagem com comando SQL para avaliar conteúdo gerado no arquivo³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄLÙ
/*
If Aviso("SQL", cQuery, {"Continuar?", "Parar?"}, 3) != 1
	Return .F.
EndIf
*/
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
		
		ZZW->ZZW_QTDENT := ZZWATU->C6_QTDVEN
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
