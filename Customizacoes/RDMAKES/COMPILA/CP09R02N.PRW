#include "protheus.ch"
#include "TopConn.ch"
#include "report.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} CP09R02N
Movimentos e Extrato bancário 
@author Augusto Ribeiro/Sivaldo Santos | www.compila.com.br
@since 18/02/2017
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
USER FUNCTION CP09R02N()

Local oReport     
Local aRet	:= {.T.,""}
Private aLote	:= {}


oReport := ReportDef()


If !Empty(oReport:uParam)
	Pergunte(oReport:uParam,.F.)
EndIf				
			
oReport:PrintDialog()

Return(aRet)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º MONTA ESTRUTURA DO RELATORIO                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ReportDef()

Local oReport
Local oSection1
Local oSection2
Local oSection3 

Local cPerg		:= "CP09R02"    
Local cDescRel	:= ""

cDescRel	:= "Conciliador Movimento x Extrato " +CRLF
cDescRel	+= "IMPORTANTE: Este relatório foi desenvolvido para ser impresso no formato A4. Por limitações físicas de espaço "

oReport := TReport():New("CP09R02","Movimento / Extrato Bancario" , cPerg , {|oReport| PrintRel(oReport)} ,cDescRel)

oReport:SetLandscape()
oReport:SetTotalInLine(.F.) 

AjustSX1(cPerg)
Pergunte(oReport:uParam,.F.)

oSection1 := TRSection():New(oReport,"Conta Bancária","BREL")


TRCell():New(oSection1,"A6_COD"  	,	"BREL","BANCO" 			,,6,.F.)
TRCell():New(oSection1,"A6_AGENCIA"	,	"BREL","AGENCIA" 		,,5,.F.)
TRCell():New(oSection1,"A6_NUMCON"  ,	"BREL","CONTA" 			,,10,.F.)
TRCell():New(oSection1,"A6_NOME"  	,	"BREL","NOME BANCO" 	,,40,.F.)


oSection2 := TRSection():New(oSection1,"Movimento x Extrato Bancário","MREL")


TRCell():New(oSection2,"E5_FILIAL"	,	"MREL","EMPRESA" ,,14,.F.)
TRCell():New(oSection2,"E5_DATA"	,	"MREL","DATA MOVIMENTO" ,,10,.F.)
TRCell():New(oSection2,"E5_BANCO"	,	"MREL","BANCO" 		    ,,6,.F.)
TRCell():New(oSection2,"E5_AGENCIA"  ,	"MREL","AGENCIA" 		,,10,.F.)
TRCell():New(oSection2,"E5_CONTA"  	,	"MREL","CONTA" 			,,10,.F.)
TRCell():New(oSection2,"E5_NUMERO"	,	"MREL","DOCUMENTO" 		,,14,.F.)
TRCell():New(oSection2,"E5_HISTOR "	,	"MREL","HISTORICO" 		,,40,.F.)
TRCell():New(oSection2,"VLMOVTO"	,	"MREL","VALOR_MOVTO" 			,"@E 999,999,999.99",18,.F.)
TRCell():New(oSection2,"VLEXTRATO"	,	"MREL","VALOR_EXTRATO" 			,"@E 999,999,999.99",18,.F.)
TRCell():New(oSection2,"E5_RECONC"	,	"MREL","CONCILIADO" 	,,11,.F.)
TRCell():New(oSection2,"ORIGEM"	    ,	"MREL","ORIGEM" 	    ,,11,.F.)

//


 
//TRFUNCTION():New(oCell,cName,cFunction,oBreak,cTitle,cPicture,uFormula,lEndSection,lEndReport,lEndPage,oParent,bCondition,lDisable,bCanPrint) 
TRFunction():New(oSection2:Cell("VLMOVTO"),nil,"SUM",,,,,.T.)	
TRFunction():New(oSection2:Cell("VLEXTRATO"),nil,"SUM",,,,,.T.)	
	
oSection2:SetTotalInLine(.F.)


Return oReport

Static Function PrintRel(oReport)


Local oSection1 := oReport:Section(1)  	
Local oSection2 := oReport:Section(1):Section(1)  	
//Local oSection3 := oReport:Section(1):Section(2)
 	
Local nCount  := 0  
Local nSaldo  := 0
Local nTotPos := 0
Local nTotNeg := 0
Private nTotalExtrato := 0
Private nTotalMovimento:= 0

Private cFilialAtu	:= ""
Private	cBanco 		:= ""
Private cAg 		:=  ""
Private cConta		:= ""


MsgRun("Verificando Registros...",, {|| qBancoN() } )

IF BREL->(!EOF())
	
	DBSelectArea("BREL")
	BREL->(DBGoTop())	
	BREL->( dbEval( {|| nCount++ } ) )	
	BREL->(DBGoTop())
	
	oReport:SetMeter(nCount)			 	
	oReport:StartPage()	
		
	//| BANCOS |
	
	WHILE BREL->(!EOF())
		oReport:IncMeter()
		If oReport:Cancel()
			Exit
		EndIf	
		
		oReport:PrintText("BANCO",,120)
		oReport:SkipLine()
		oSection1:Init()
		oSection1:PrintLine()
		
		/*--------------------------
			MOVIMENTO X EXTRATO  BANCARIO SE5/ ZD2
		---------------------------*/
		qMovN()
		IF MREL->(!EOF())
			oReport:SkipLine()
		    oReport:PrintText("MOVIMENTO X EXTRATO",,120)
			oSection2:Init()
			WHILE MREL->(!EOF())
				If oReport:Cancel()
					Exit
				EndIf	
				
				IF MREL->ORIGEM =="EXTRATO"
				   nTotalExtrato += MREL->VLEXTRATO
				ELSE
				   nTotalMovimento += MREL->VLMOVTO
				ENDIF
				
				oSection2:PrintLine()
				
				MREL->(DBSKIP())
			ENDDO
			 oSection2:Finish()
		 ENDIF
		 		 
	
		 
		BREL->(DBSKIP())
		oSection1:Finish()
	ENDDO 
	
ENDIF

oReport:EndPage()

Return

/*/{Protheus.doc} qBancoN
Query busca bancos conforme parametross
@author Augusto Ribeiro / Sivaldo Santos | www.compila.com.br
@since 20/02/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function qBancoN()
Local cQuery	:= ""


	cQuery := " SELECT A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON, A6_NOME "+CRLF
	cQuery += " FROM "+RetSqlName("SA6")+" SA6 "+CRLF
	cQuery += " WHERE A6_FILIAL BETWEEN  '"+LEFT(MV_PAR01,5)+"' AND '"+LEFT(MV_PAR02,5)+"' "+CRLF
	if !empty(MV_PAR05)
		cQuery += " AND A6_COD = '"+MV_PAR05+"' "+CRLF
	endif
	if !empty(MV_PAR06)
		cQuery += " AND A6_AGENCIA = '"+MV_PAR06+"' "+CRLF
	endif
	if !empty(MV_PAR07)
		cQuery += " AND A6_NUMCON = '"+MV_PAR07+"' "+CRLF
	endif
	cQuery += " AND SA6.D_E_L_E_T_= ' ' "+CRLF 
	cQuery += " ORDER BY  A6_FILIAL, A6_COD, A6_AGENCIA, A6_NUMCON "+CRLF
	
	
	
	If Select("BREL") > 0
		BREL->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGenQRY(,,cQuery),'BREL')

Return()

/*/{Protheus.doc} qMovN
Query busca Movimentos e Extrato conforme parametross
@author Augusto Ribeiro /Sivaldo Santos | www.compila.com.br
@since 20/02/2017
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function qMovN()
Local cQuery	:= ""


cQuery := " SELECT  "+CRLF
cQuery += "     E5_FILIAL, "+CRLF
cQuery += "  	E5_DATA,  "+CRLF
cQuery += "  	E5_NUMERO,   "+CRLF
cQuery += "     E5_BANCO, "+CRLF
cQuery += "  	E5_AGENCIA, "+CRLF
cQuery += "  	E5_CONTA ,	 "+CRLF
cQuery += "     E5_DTDISPO, "+CRLF
cQuery += "  	CASE WHEN E5_RECPAG = 'R' THEN E5_VALOR ELSE (E5_VALOR * -1) END AS VLMOVTO,  "+CRLF
cQuery += "		VLEXTRATO = 0,"+CRLF
cQuery += "  	E5_HISTOR, 	 "+CRLF
cQuery += "  	E5_NATUREZ,   "+CRLF
cQuery += "     ORIGEM = 'MOVIMENTO', "+CRLF
cQuery += "  	CASE WHEN E5_RECONC = 'x' THEN  'S' ELSE 'N' END AS E5_RECONC,  "+CRLF
cQuery += "  	SE5.R_E_C_N_O_ as SE5_RECNO  "+CRLF
cQuery += " FROM "+RetSqlName("SE5")+" SE5 "+CRLF
cQuery += " WHERE E5_FILIAL BETWEEN '"+mv_par01+"' AND '"+mv_par02+"' "
cQuery += " AND E5_DTDISPO BETWEEN '"+DTOS(mv_par03)+"' AND '"+DTOS(mv_par04)+"' "+CRLF
cQuery += " AND E5_BANCO = '"+BREL->A6_COD+"' "+CRLF
cQuery += " AND E5_AGENCIA = '"+BREL->A6_AGENCIA+"' "+CRLF
cQuery += " AND E5_CONTA = '"+BREL->A6_NUMCON+"' "+CRLF
//cQuery += " AND E5_TIPODOC NOT IN ('JR','DC') "+CRLF
cQuery += " AND (E5_TIPODOC NOT IN ('JR','DC','MT')  OR   (E5_TIPODOC = ' ' AND E5_LOTE = ' ')) "+CRLF

If mv_par08 = 1
  cQuery += " AND E5_RECONC ='x' "+CRLF
ElseIf  mv_par08 = 2
  cQuery += " AND E5_RECONC ='' "+CRLF
EndIf 
	 
cQuery += " AND E5_SITUACA <> 'C' "+CRLF
cQuery += " AND UPPER(E5_HISTOR) NOT LIKE 'BX RET CNAB LOTE:%' "+CRLF
cQuery += " AND SE5.D_E_L_E_T_ = ' ' "+CRLF
//cQuery += " ORDER BY E5_DATA, SE5.R_E_C_N_O_ "+CRLF

cQuery += "UNION                      "+CRLF

cQuery += " SELECT                    "+CRLF
cQuery += "		ZD2_FILIAL,           "+CRLF
cQuery += "     ZD2_DATA,             "+CRLF
cQuery += "     ZD2_CODIGO,           "+CRLF
cQuery += "		ZD2_BANCO,            "+CRLF
cQuery += "		ZD2_AGENC,            "+CRLF
cQuery += "		ZD2_CONTA, 	          "+CRLF
cQuery += "		ZD2_TIPO =  '',       "+CRLF
cQuery += "		VLMOVTO = 0,          "+CRLF
cQuery += "		VLEXTRATO = ZD2_VALOR,"+CRLF
cQuery += "		ZD2_DESC,             "+CRLF
cQuery += "     NATRUZA = ' ',         "+CRLF
cQuery += "     ORIGEM = 'EXTRATO',   "+CRLF
cQuery += "		CASE WHEN ZD2_DTCONC = ' ' THEN 'N' ELSE 'S' END AS ZD2_DTCONC,"+CRLF
cQuery += "     ZD2.R_E_C_N_O_ AS RECNO     "+CRLF
cQuery += " FROM "+RetSqlName("ZD2")+" ZD2  "+CRLF
cQuery += " 	WHERE ZD2_FILIAL = ' '       "+CRLF
cQuery += " 		AND ZD2_BANCO = '"+BREL->A6_COD+"' "+CRLF
cQuery += " 		AND ZD2_AGENC = '"+BREL->A6_AGENCIA+"' "+CRLF
cQuery += " 		AND ZD2_CONTA = '"+BREL->A6_NUMCON+"' "+CRLF	
cQuery += " 		AND ZD2_DATA BETWEEN '"+DTOS(MV_PAR03)+"' AND '"+DTOS(MV_PAR04)+"' "+CRLF
	
	IF MV_PAR08 == 1
		cQuery += " AND ZD2_DTCONC <> '' "+CRLF
	ELSEIF  MV_PAR08 == 2
		cQuery += " AND ZD2_DTCONC = ' ' "+CRLF
	ENDIF
	
cQuery += " AND ZD2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += " ORDER BY  E5_DATA "+CRLF



If Select("MREL") > 0
	MREL->(DbCloseArea())
EndIf


DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"MREL", .F., .T.)

TCSetField("MREL","E5_DATA","D",08,00)
//TCSetField("MREL","ZD2_DATA","D",08,00)
//TCSetField("MREL","E5_RECONC","D",08,00)


Return()

/*/{Protheus.doc} AjustSX1
Cria perguntas no SX1
@author Augusto Ribeiro/Sivaldo Santos | www.compila.com.br
@since 26/12/2016
@version 6
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function AjustSX1(cPerg)

Local aArea := GetArea()
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}

aAdd( aHelpEng, "  ")
aAdd( aHelpSpa, "  ")

aHelpPor := {} ; Aadd( aHelpPor, "Filial De")
xPUTSX1( cPerg, "01","Filial De"	,"","","mv_ch1","C",11,0,0,"G","","SM0","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "FiliaL Ate")
xPUTSX1( cPerg, "02","FiliaL Ate"	,"","","mv_ch2","C",11,0,0,"G","","SM0","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. De")
xPUTSX1( cPerg, "03","Data Mov. De","","","mv_ch3","D",08,0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. Ate")
xPUTSX1( cPerg, "04","Data Mov. Ate","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Banco")
xPUTSX1( cPerg, "05","Banco"	,"","","mv_ch5","C",TAMSX3("A6_COD")[1],0,0,"G","","SA6CP9","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Agencia")
xPUTSX1( cPerg, "06","Agencia"	,"","","mv_ch6","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par06","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Conta")
xPUTSX1( cPerg, "07","Conta"	,"","","mv_ch7","C",TAMSX3("A6_NUMCON")[1],0,0,"G","","","","","mv_par07","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Conciliação")
xPUTSX1( cPerg, "08","Conciliação","","","mv_ch8","N",01,0,0,"C","","","","","mv_par08","Conciliados","","","","Não Conciliados","","","Ambos","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )


Return()



/*/{Protheus.doc} xPutSx1
(long_description)
@author DESCONHECIDO
@since 11/09/2018
@version version
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
Static Function xPutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,;
cTipo ,nTamanho,nDecimal,nPresel,cGSC,cValid,;
cF3, cGrpSxg,cPyme,;
cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,;
cDef02,cDefSpa2,cDefEng2,;
cDef03,cDefSpa3,cDefEng3,;
cDef04,cDefSpa4,cDefEng4,;
cDef05,cDefSpa5,cDefEng5,;
aHelpPor,aHelpEng,aHelpSpa,cHelp)

LOCAL aArea := GetArea()
Local cKey
Local lPort := .f.
Local lSpa := .f.
Local lIngl := .f.

cKey := "P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

cPyme    := Iif( cPyme           == Nil, " ", cPyme          )
cF3      := Iif( cF3           == NIl, " ", cF3          )
cGrpSxg := Iif( cGrpSxg     == Nil, " ", cGrpSxg     )
cCnt01   := Iif( cCnt01          == Nil, "" , cCnt01      )
cHelp      := Iif( cHelp          == Nil, "" , cHelp          )

dbSelectArea( "SX1" )
dbSetOrder( 1 )

// Ajusta o tamanho do grupo. Ajuste emergencial para validação dos fontes.
// RFC - 15/03/2007
cGrupo := PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !( DbSeek( cGrupo + cOrdem ))
	
	cPergunt:= If(! "?" $ cPergunt .And. ! Empty(cPergunt),Alltrim(cPergunt)+" ?",cPergunt)
	cPerSpa     := If(! "?" $ cPerSpa .And. ! Empty(cPerSpa) ,Alltrim(cPerSpa) +" ?",cPerSpa)
	cPerEng     := If(! "?" $ cPerEng .And. ! Empty(cPerEng) ,Alltrim(cPerEng) +" ?",cPerEng)
	
	Reclock( "SX1" , .T. )
	
	Replace X1_GRUPO   With cGrupo
	Replace X1_ORDEM   With cOrdem
	Replace X1_PERGUNT With cPergunt
	Replace X1_PERSPA With cPerSpa
	Replace X1_PERENG With cPerEng
	Replace X1_VARIAVL With cVar
	Replace X1_TIPO    With cTipo
	Replace X1_TAMANHO With nTamanho
	Replace X1_DECIMAL With nDecimal
	Replace X1_PRESEL With nPresel
	Replace X1_GSC     With cGSC
	Replace X1_VALID   With cValid
	
	Replace X1_VAR01   With cVar01
	
	Replace X1_F3      With cF3
	Replace X1_GRPSXG With cGrpSxg
	
	If Fieldpos("X1_PYME") > 0
		If cPyme != Nil
			Replace X1_PYME With cPyme
		Endif
	Endif
	
	Replace X1_CNT01   With cCnt01
	If cGSC == "C"               // Mult Escolha
		Replace X1_DEF01   With cDef01
		Replace X1_DEFSPA1 With cDefSpa1
		Replace X1_DEFENG1 With cDefEng1
		
		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2
		
		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3
		
		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4
		
		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	Endif
	
	Replace X1_HELP With cHelp
	
	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	
	MsUnlock()
Else
	
	lPort := ! "?" $ X1_PERGUNT .And. ! Empty(SX1->X1_PERGUNT)
	lSpa := ! "?" $ X1_PERSPA .And. ! Empty(SX1->X1_PERSPA)
	lIngl := ! "?" $ X1_PERENG .And. ! Empty(SX1->X1_PERENG)
	
	If lPort .Or. lSpa .Or. lIngl
		RecLock("SX1",.F.)
		If lPort
			SX1->X1_PERGUNT:= Alltrim(SX1->X1_PERGUNT)+" ?"
		EndIf
		If lSpa
			SX1->X1_PERSPA := Alltrim(SX1->X1_PERSPA) +" ?"
		EndIf
		If lIngl
			SX1->X1_PERENG := Alltrim(SX1->X1_PERENG) +" ?"
		EndIf
		SX1->(MsUnLock())
	EndIf
Endif

RestArea( aArea )

Return