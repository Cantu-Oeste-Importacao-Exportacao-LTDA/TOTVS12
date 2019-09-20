#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RELCONFITE     ºAutor  ³Microsiga      º Data ³  14/02/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Relatório relacionado às conferências de canhotos          º±±
±±º          ³ retornados na carga.                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ OMS - Gestão de Distribuição                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function RelConfIte()

Local cDesc1         	:= "Este programa tem como objetivo imprimir um relatorio "
Local cDesc2         	:= "dos canhotos de notas devolvidos x carga."
Local cDesc3        	:= ""
Local cPict          	:= ""
Local titulo        	:= "RELATÓRIO CANHOTOS DEVOLVIDOS"
Local nLin         		:= 80
Local Cabec1       		:= " "
Local Cabec2       		:= " "
Local imprime      		:= .T.
Local aOrd 						:= {}
Private lEnd         	:= .F.
Private lAbortPrint  	:= .F.
Private CbTxt        	:= ""
Private limite        := 80
Private tamanho       := "P"
Private nomeprog      := "RELCONFITE" 
Private nTipo         := 18
Private aReturn       := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey      := 0
Private cbtxt      		:= Space(10)
Private cbcont     		:= 00
Private CONTFL     		:= 01
Private m_pag      		:= 01
Private wnrel     		:= "RELCONFITE" 
Private cPerg					:= "RELCONFITE"
Private cString				:= ""      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Chama função para monitor uso de fontes customizados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
U_USORWMAKE(ProcName(),FunName())

AjustaSX1()

Pergunte(cPerg,.F.)
                        
wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.F.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função principal que fará a geração do relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local cChave 	:= ""
Local cSql 		:= ""                                          
Local cEol    := CHR(13)+CHR(10)
Local aFields := {"DAI_COD","DAI_SEQUEN","DAI_SERIE","DAI_NFISCA","DAI_DATA"}
Local aCampos := {}
Local aHeader := {}
Local aDados  := {}
Local nX      := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Busca dados no dicionário para montar o cabeçalho do relatório.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetRegua(Len(aFields))

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
for nX := 1 to Len(aFields)
	IncRegua()
	if SX3->(DbSeek(aFields[nX]))
		Aadd(aCampos, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO})
	EndIf	
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<¿
//³Busca campos do cadastro de Itens de Conferência³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ<Ù

cSql := "SELECT Z18.Z18_CODIGO, Z18.Z18_TITULO FROM "+RetSqlName("Z18")+" Z18 "  +cEol
cSql += "WHERE Z18.D_E_L_E_T_ <> '*' "                                   				 +cEol
cSql += "  AND Z18.Z18_FILIAL = '"+ xFilial("Z18") +"' "                     		 +cEol

TCQUERY cSql NEW ALIAS "Z18TMP"

DbSelectArea("Z18TMP")
Z18TMP->(DbGoTop())

if !Z18TMP->(EOF())
	SetRegua(RecCount())
	
	While !Z18TMP->(EOF())
		IncRegua()
		Aadd(aCampos, {Z18TMP->Z18_TITULO, Z18TMP->Z18_CODIGO, "@!",;
									 iif(Z18TMP->Z18_TITULO == "JUSTIFICATIVA",30,Len(AllTrim(Z18TMP->Z18_TITULO)))})
		Z18TMP->(DbSkip())
	EndDo
EndIf  

Z18TMP->(DbCloseArea())
cSql		:= ""
nX 			:= 0
nTamCpo	:= 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPPÍİ¿
//³Montagem dos tamanhos de campos para o cabeçalho e corpo do relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄPP^I àÙ

SetRegua(Len(aCampos))
for nX := 1 to len(aCampos)
	IncRegua()
	nTamCpo := iif(len(aCampos[nX,01]) >= aCampos[nX,04], Len(aCampos[nX,01])+1, aCampos[nX,04]+2)
	Aadd(aHeader, {aCampos[nX,01], aCampos[nX,02], aCampos[nX,03], nTamCpo})		
Next nX

nX 		 := 0
Cabec1 := "PERIODO DE "+DTOC(MV_PAR03)+" A "+DTOC(MV_PAR04)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Montagem do cabeçalho do relatório de forma dinâmica³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

for nX := 1 to len(aHeader)
	Cabec2 	+= UPPER(PadC(aCampos[nX,01],aHeader[nX, 04]))
Next nX

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia a busca de dados no banco³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cSql := "SELECT DAI.DAI_COD, DAI.DAI_SEQUEN, DAI.DAI_SERIE, DAI.DAI_NFISCA, DAI.DAI_DATA, Z18.Z18_CODIGO,  " +cEol
cSql += "       Z19.Z19_VALITE "                                                                             +cEol
cSql += "FROM "+RetSqlName("DAI")+" DAI "                                                                    +cEol

cSql += "LEFT JOIN "+ RetSqlName("Z18")+" Z18 "                                                              +cEol
cSql += " ON Z18.Z18_FILIAL = DAI.DAI_FILIAL "                                                               +cEol
cSql += "AND Z18.D_E_L_E_T_ <> '*' "                                                                         +cEol

cSql += "LEFT JOIN "+ RetSqlName("Z19")+" Z19 "                                                              +cEol
cSql += " ON Z19.Z19_FILIAL = DAI.DAI_FILIAL "                                                               +cEol
cSql += "AND Z19.Z19_CARGA = DAI.DAI_COD "                                                                   +cEol
cSql += "AND Z19.Z19_NOTAFI = DAI.DAI_NFISCA "                                                               +cEol
cSql += "AND Z19.Z19_SERIEN = DAI.DAI_SERIE "                                                                +cEol
cSql += "AND Z19.Z19_CODITE = Z18.Z18_CODIGO "                                                               +cEol

cSql += "WHERE DAI_FILIAL = '"+ xFilial("DAI") +"' "                                                         +cEol
cSql += "  AND DAI.DAI_COD BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "                                   +cEol
cSql += "  AND DAI.DAI_SERIE BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "                                 +cEol
cSql += "  AND DAI.DAI_NFISCA BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' "                                +cEol
cSql += "  AND DAI.DAI_DATA BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"' "                      +cEol    //alterado Gustavo 08/01/14 
cSql += "  AND DAI.D_E_L_E_T_ <> '*' "                                                                       +cEol

if MV_PAR09 != 3
	cSql += "   AND Z19.Z19_FILIAL || Z19.Z19_CARGA || Z19.Z19_SERIEN || Z19.Z19_NOTAFI IN ( "                 +cEol
	cSql += "        SELECT DISTINCT Z19.Z19_FILIAL || Z19_CARGA || Z19.Z19_SERIEN || Z19.Z19_NOTAFI FROM "+ RetSqlName("Z19")+" Z19 " +cEol
        
	cSql += "        INNER JOIN "+ RetSqlName("Z18")+" Z18 "                                                   +cEol
	cSql += "         ON Z18.Z18_FILIAL = Z19.Z19_FILIAL "                                                     +cEol
	cSql += "        AND Z18.D_E_L_E_T_ <> '*' "                                                               +cEol
        
	cSql += "        WHERE DAI_FILIAL = '"+ xFilial("DAI") +"' "                                               +cEol
	cSql += "          AND DAI.DAI_COD BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "                         +cEol
	cSql += "          AND DAI.DAI_SERIE BETWEEN '"+ MV_PAR05 +"' AND '"+ MV_PAR06 +"' "                       +cEol
	cSql += "          AND DAI.DAI_NFISCA BETWEEN '"+ MV_PAR07 +"' AND '"+ MV_PAR08 +"' "                      +cEol
	cSql += "          AND DAI.DAI_DATA BETWEEN '"+ DTOS(MV_PAR03) +"' AND '"+ DTOS(MV_PAR04) +"' "            +cEol    //alterado Gustavo 08/01/14 
	cSql += "          AND Z18.Z18_TITULO = 'CANHOTO NF' "                                                     +cEol
	
	if MV_PAR09 == 1
		cSql += "          AND Z19.Z19_VALITE = 'N' "                                                            +cEol
	Else
		cSql += "          AND Z19.Z19_VALITE = 'S' "                                                            +cEol
	EndIf                                          
	
	cSql += "          AND DAI.D_E_L_E_T_ <> '*' "                                                             +cEol
	cSql += ") "
EndIf

cSql += "ORDER BY DAI.DAI_COD, DAI.DAI_SEQUEN, Z18.Z18_CODIGO "                                              +cEol       

TCQUERY cSql NEW ALIAS "DAITMP"

DbSelectArea("DAITMP")
DAITMP->(DbGoTop())

SetRegua(RecCount())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Enquanto não for final da tabela temporária, monta os dados no array de dados³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

if !DAITMP->(EOF())

	cChave 	 := ""
	nPosCod  := 0
	nPosTit  := 0
	nPosDes  := 0
	cDescri  := ""
	
	While !DAITMP->(EOF())
		IncRegua()
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do Array de Dados do relatório³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
    if cChave != DAITMP->DAI_COD + DAITMP->DAI_SEQUEN
    	Aadd(aDados, {DAITMP->DAI_COD,;
    								DAITMP->DAI_SEQUEN,;
    								DAITMP->DAI_SERIE,;
    								DAITMP->DAI_NFISCA,;
    								DAITMP->DAI_DATA,;
    								,;
    								,})	
    EndIf 
    
    nPosCod := aScan(aHeader, {|x| AllTrim(x[2]) == DAITMP->Z18_CODIGO})
    cDescri := aHeader[nPosCod, 01]
    
    aDados[Len(aDados),nPosCod] := iif(DAITMP->Z19_VALITE == "S", "SIM",;
    															 iif(DAITMP->Z19_VALITE == "N", "NÃO",; 
    															 iif(DAITMP->Z19_VALITE == "1","FALTA DE ASSINATURA",;
    															 iif(DAITMP->Z19_VALITE == "2","NF RETORNADA"," "))))
 
    cChave := DAITMP->DAI_COD + DAITMP->DAI_SEQUEN
		
		DAITMP->(DbSkip())
	EndDo	
EndIf

cDados 		:= ""  
cCarga 		:= ""
cCargaAnt := ""
nTotNRec  := 0
nTotRec   := 0
nCarNRec  := 0
nCarRec   := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Faz a leitura das posições dos campos no aHeader³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

nPosCod 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_COD"})
nPosSeq 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_SEQUEN"})
nPosSer 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_SERIE"})
nPosNot 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_NFISCA"})
nPosDat 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "DAI_DATA"})
nPosCan   := aScan(aHeader, {|x| AllTrim(x[1]) == "CANHOTO NF"})
nPosJus   := aScan(aHeader, {|x| AllTrim(x[1]) == "JUSTIFICATIVA"})

if Len(aDados) > 0
	SetRegua(Len(aDados))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia o processamento dos dados e a gravação no relatório³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	for nX := 1 to len(aDados)
		IncRegua()					
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Caso for identificado mais que 60 linhas, vai para próxima página³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		If nLin > 60
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 9
    Endif		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem do cabeçalho com o código da carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cCarga := PADC(aDados[nX, nPosCod], aHeader[nPosCod, 04], " ")                    
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Montagem da linha com os dados das notas de cada carga³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		cDados := PADC(Space(01), aHeader[nPosCod, 04], " ")+;
							PADC(aDados[nX, nPosSeq], aHeader[nPosSeq, 04], " ")+;
							PADC(aDados[nX, nPosSer], aHeader[nPosSer, 04], " ")+;
							PADC(aDados[nX, nPosNot], aHeader[nPosNot, 04], " ")+;
							PADC(DTOC(STOD(aDados[nX, nPosDat])), aHeader[nPosDat, 04], " ")+;
		          PADC(aDados[nX, nPosCan], aHeader[nPosCan, 04], " ")+;
		          PADR(aDados[nX, nPosJus], aHeader[nPosJus, 04], " ")                                         
		
		if aDados[nX, nPosCan] == "SIM"
			nTotRec++
			nCarRec++
		Else
			nCarNRec++
			nTotNRec++
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Imprime o cabeçalho com o código da carga a cada vez que ³
		//³for diferente da carga anterior                          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		
		if cCarga != cCargaAnt
			if nX != 1
				
				nLin += 1
				@nLin, 040 PSAY EscPont("CAN. NÃO REC", 30) + PADL(Transform(nCarNRec, "@E 999,999"),10," ")
				nCarNRec := 0                                                                              
				nLin += 1
				
				@nLin, 040 PSAY EscPont("CAN. RECEBIDOS", 30) + PADL(Transform(nCarRec, "@E 999,999"),10," ")
				nCarRec := 0
				nLin += 2
				
			EndIf
			
			@nLin, 000 PSAY cCarga
			nLin += 1	
		EndIf      
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		//³Imprime a linha com os dados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
		
		@nLin, 000 PSAY cDados
		 		
		nLin += 1
		
		cCargaAnt := cCarga
		
	Next nX      
	
	nLin += 1
	@nLin, 040 PSAY EscPont("CAN. NÃO REC", 30) + PADL(Transform(nCarNRec, "@E 999,999"),10," ")
	nLin += 1
	
	@nLin, 040 PSAY EscPont("CAN. RECEBIDOS", 30) + PADL(Transform(nCarRec, "@E 999,999"),10," ")
	nLin += 2

	@nLin, 000 PSAY Replicate("-",80)
	nLin += 1
	
	@nLin, 000 PSAY EscPont("TOTAL CANHOTOS NÃO RECEBIDOS", 70) + PADL(Transform(nTotNRec, "@E 999,999"),10," ")
	nLin += 1
	
	@nLin, 000 PSAY EscPont("TOTAL CANHOTOS RECEBIDOS", 70) + PADL(Transform(nTotRec, "@E 999,999"),10," ")
	nLin += 1
	
EndIf             

SET DEVICE TO SCREEN

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função para completar a string com pontilhado.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function EscPont(cString, nTam)
Local cRet := ""

cRet := AllTrim(cString)
if Len(cString) < nTam
	for i := Len(cString) to nTam-1
		cRet += "."	
	Next i
Else
	cRet := SubStr(cString, 01, nTam-1)
EndIf

cRet += ":"

Return cRet

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Função criada para gravar os parâmetros.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function AjustaSX1()
Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)

cPerg := PADR(cPerg,10)
aAdd(aRegs,{cperg,"01","Carga De:          ?","","","mv_ch1","C",06,0,0,"G","        ","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","DAK",""})
aAdd(aRegs,{cperg,"02","Carga Ate:         ?","","","mv_ch2","C",06,0,0,"G","naovazio","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","DAK",""})
aAdd(aRegs,{cPerg,"03","Emissao De:        ?","","","mv_ch3","D",08,0,0,"G","        ","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Emissao Ate:       ?","","","mv_ch4","D",08,0,0,"G","naovazio","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"05","Serie Nota De:     ?","","","mv_ch5","C",03,0,0,"G","        ","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Serie Nota Ate:    ?","","","mv_ch6","C",03,0,0,"G","naovazio","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Nota Fiscal De:    ?","","","mv_ch7","C",09,0,0,"G","        ","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Nota Fiscal Ate:   ?","","","mv_ch8","C",09,0,0,"G","naovazio","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"09","Lista:             ?","","","mv_ch9","N",01,0,1,"C","        ","mv_par09","Somente Nao Recebidos","Somente Nao Recebidos","Somente Nao Recebidos","","","Somente Recebidos","Somente Recebidos","Somente Recebidos","Todos","Todos","Todos","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
dbSelectArea(_sAlias)

Return
