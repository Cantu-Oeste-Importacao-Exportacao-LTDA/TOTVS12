#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCONCATOBS บAutor  ณJean Carlos Saggin  บ Data ณ  14/04/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo que faz a jun็ใo dos campos observa็๕es do cadastro  บฑฑ
ฑฑบ          ณde clientes para um novo campo A1_X_OBSCAD                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConcatObs()

Local aEmp		:= {"07","08","09","10","20","30","31","40","50","60","70"}
Local cSqlCli := ""
Local cMemo		:= ""
Local cObs		:= ""
Local cSqlSyp := ""
Local nTamLin, cLin, cCpo
Private cEol 	:= CHR(13)+CHR(10)                    

// Cria arquivo de log no disco D:\ mostrando os clientes que sofreram altera็ใo.
Private nHdl 	:= fCreate(AllTrim("D:\clientes_alterados.log"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

nTamLin := 600
cLinha  := Space(nTamLin)+cEOL // Variavel para criacao da linha dos registros para gravacao 
nSeqReg	:= 1

// Cabe็alho do arquivo de log
cLinha := PadC(" ## LOG CLIENTES ALTERADOS ## ",65)+cEol+cEol
cLinha += PadC("SEQ",6) + PadC("CODIGO",10) + PadC("LOJA",6) +Space(3)+ PadC("NOME",40) + cEol

// Seleciona todos os registro da tabela A1 exceto os deletados		
cSqlCli := "SELECT A1_COD, A1_LOJA, A1_OBS, A1_OBSRJU "
cSqlCli += "FROM " + RetSqlName("SA1") + " A1 "
cSqlCli += "WHERE (A1_COD BETWEEN '         ' AND 'ZZZZZZZZZ') AND "
cSqlCli += "A1.D_E_L_E_T_ <> '*'"
cSqlCli += "ORDER BY A1_COD, A1_LOJA"

TCQUERY cSqlCli NEW ALIAS "TMPSA1"
DbSelectArea("TMPSA1")
DbGoTop()
                    
While (!TMPSA1->(Eof()))
  	
 	if nSeqReg != 1
 	  cLinha := ""
 	EndIf
  	
 	// Busca a informa็ใo do Campo A1_OBSERV do cadastro do cliente
 	cObs := AllTrim(Posicione("SA1",1,xFilial("SA1") + TMPSA1->A1_COD + TMPSA1->A1_LOJA, "A1_OBSRJU"))

	cLin := ""
	cTmp := ""
	cTmp2 := ""
	Private nCont := 0
  for i := 1 to Len(aEmp)
	  // Seleciona todos os registros da tabela YP com o c๓digo chave do campo A1_OBS  	 						
		cSqlSyp := "SELECT YP_CHAVE, YP_TEXTO FROM SYP"+aEmp[i]+"0 YP "
		cSqlSyp += "WHERE YP_CHAVE = '" + TMPSA1->A1_OBS + "' "
	 			
		TCQUERY cSqlSyp NEW ALIAS "TMPSYP"
		DbSelectArea("TMPSYP")
		DbGoTop()
			
		// Se conseguir encontrar registros de observa็ใo na tabela YP, junta as informa็๕es na variแvel cLin
		if !(EOF("TMPSYP"))
			nCont += 1
			while !(EOF("TMPSYP"))                         
				if Empty(cLin)
					if Rat(StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol), cLin) == 0
						cLin += StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol)
					EndIf
					cTmp2 += "Emp.: " + aEmp[i] + " - " + StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol)
				else 
					if Rat(StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol), cLin) == 0
						cLin += cEol + StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol)
					EndIf
					cTmp2 += cEol + "Emp.: " + aEmp[i] + " - " + StrTran(AllTrim(TMPSYP->YP_TEXTO),'\13\10',cEol)
				EndIf
				TMPSYP->(DbSkip()) 
			EndDo
			DbCloseArea("TMPSYP")
		else
			DbCloseArea("TMPSYP")
		EndIf
  End
  
  if nCont >= 2
  	if Empty(cTmp)
  		cTmp += "Hแ observa็๕es em mais que uma empresa...as inf. abaixo nใo serใo gravadas..." + cEol
  	EndIf
  	cLin := ""
		cTmp += cTmp2
	EndIf
    
	// Se pelo menos uma das variแveis (cLin e cObs) tiverem valor, concatena as informa็๕es
	if !Empty(cLin) .or. !Empty(cObs)
		SA1->(DbSetOrder(01))
		
		// Verifica se conseguiu encontar o cliente
		if SA1->(DbSeek(xFilial("SA1") + TMPSA1->A1_COD + TMPSA1->A1_LOJA))
			RecLock("SA1", .F.)

			// Variแveis que alimentam o arquivo de log
			cLinha += PadR(cValToChar(nSeqReg),6)+PadC(SA1->A1_COD,10)+;
  								PadC(SA1->A1_LOJA,6)+" - "+PadR(SA1->A1_NOME,40) + cEol
  		if Empty(cTmp)
	  		cTmp += "Concatenando informa็๕es do cliente..."+cEol
	  	else
	  		cTmp += cEol+"Concatenando informa็๕es do cliente..."+cEol
	  	EndIf
			
			if Empty(cLin)
				SA1->A1_X_OBCAD := cObs				
			else
				if Rat(cObs, cLin) == 0
					SA1->A1_X_OBCAD := cLin + cEol + cObs				
				Else
					SA1->A1_X_OBCAD := cLin + cEol
				EndIf
			EndIf
			cTmp += "Cliente alterado com SUCESSO!" + cEol + cEol
			SA1->(MsUnlock())
		EndIf
	EndIf
	
	cLinha += cTmp
	
 		// Pr๓ximo registro da tabela temporแria TMPSA1				
	TMPSA1->(DbSkip())
	
	// Controlador sequencial arquivo de log
	nSeqReg++
	
	// Grava็ใo das informa็๕es no arquivo de log
	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
    If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
    	Exit
  	Endif
	EndIf
	
End do

MsgInfo("Altera็๕es Finalizadas")

DbCloseArea("TMPSA1")
fClose(nHdl)

Return