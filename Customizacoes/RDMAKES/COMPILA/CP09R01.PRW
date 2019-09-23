#include "protheus.ch"
#include "TopConn.ch"
#include "report.ch"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

/*/{Protheus.doc} CP09R01
Resumo em Excel do Lote de Faturamnto Antecipado Zatix.
@author Augusto Ribeiro | www.compila.com.br
@since 17/12/2016
@version undefined
@param param
@return return, return_description
@example
(examples)
@see (links_or_references)
/*/
USER FUNCTION CP09R01()

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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ MONTA ESTRUTURA DO RELATORIO                                          บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function ReportDef()

Local oReport
Local oSection1

Local cPerg		:= "CP09R01"    
Local cDescRel	:= ""

cDescRel	:= "Lan็amentos do Extrato nใo conciliado"

oReport := TReport():New("CP09R01","Extrato Bancario" , cPerg , {|oReport| PrintRel(oReport)} ,cDescRel)
oReport:SetLandscape()
oReport:SetTotalInLine(.F.) 

AjustSX1(cPerg)
Pergunte(oReport:uParam,.F.)

oSection1 := TRSection():New(oReport,"Extrato Bancแrio","TREL") 

/*
TRCell():New(oSection1,"NOME"		,"TCLI","CLIENTE" 		,,40,.F.)
TRCell():New(oSection1,"CGC"		,"TCLI","CPF/CNPJ"		,,14,.F. )
TRCell():New(oSection1,"DTATIVA"	,"TCLI","DT ATIVACAO"	,,10,.F.,{|| DTOCY(STOD(TCLI->DTATIVA)) } )
TRCell():New(oSection1,"NSERIE"		,"TCLI","NUM SERIR" 	,,24,.F.)
TRCell():New(oSection1,"TECNO"		,"TCLI","TECNOLOGIA"	,,40,.F. )
TRCell():New(oSection1,"DOCORIG"	,"TCLI","NF ORIGEM"		,,10,.F. )
*/

TRCell():New(oSection1,"ZD2_TIPO",	"TREL","TIPO" 					,,6,.F.)
TRCell():New(oSection1,"ZD2_DATA",	"TREL","DATA MOVIMENTO" 		,,14,.F.)
TRCell():New(oSection1,"ZD2_VALOR",		"TREL","VALOR" 				,"@E 999,999,999.99",16,.F.)
TRCell():New(oSection1,"ZD2_DESC",		"TREL","DESCRICAO" 			,,40,.F.)
TRCell():New(oSection1,"ZD2_DTCONC",	"TREL","DATA CONCILIACAO" 	,,10,.F.)

Return oReport



Static Function PrintRel(oReport)


	Local oSection1 := oReport:Section(1)  	
	Local nCount	:= 0  
  

	MsgRun("Verificando Registros...",, {|| qConc() } )

	
	DBSelectArea("TREL")
	TREL->(DBGoTop())	
	TREL->( dbEval( {|| nCount++ } ) )	
	TREL->(DBGoTop())
	
	oReport:SetMeter(nCount)			 	
	oReport:StartPage()	
	oSection1:Init()
	
	While TREL->( !Eof() )
		
		If oReport:Cancel()
			Exit
		EndIf		
		
		oSection1:PrintLine()								
				
		TREL->( dbSkip() )	
	EndDo
	oSection1:Finish()
	oReport:EndPage()
	
Return



/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบ SELECIONA TODAS AS ANTENAS DO CLIENTE DEFINIDO NO PARAMETRO           บฑฑ
ฑฑศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function qConc()
Local cQuery 	:= ""
Local cDigConta	:= ""

	/*------------------------------------------------------ Augusto Ribeiro | 14/01/2017 - 4:28:50 PM
		Busca digito da conta para contactenar na busca
	------------------------------------------------------------------------------------------*/
	cQuery := " SELECT A6_DVCTA "+CRLF
	cQuery += " FROM "+RetSqlName("SA6")+" SA6 "+CRLF
	cQuery += " WHERE A6_COD = '"+MV_PAR01+"' "+CRLF
	cQuery += " AND A6_AGENCIA = '"+MV_PAR02+"' "+CRLF
	cQuery += " AND A6_NUMCON = '"+MV_PAR03+"' "+CRLF
	cQuery += " AND A6_BLOCKED <> '1' "+CRLF
	cQuery += " AND A6_DVCTA <> '' "+CRLF
	cQuery += " AND SA6.D_E_L_E_T_= ' ' "+CRLF 
	
	
	If Select("TREL") > 0
		TREL->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGenQRY(,,cQuery),'TREL')
	IF TREL->(!EOF())
		cDigConta	:=  TREL->A6_DVCTA
	ENDIF
	
	TREL->(DbCloseArea())
	
	

	cQuery := " SELECT ZD2_TIPO, ZD2_DATA, ZD2_VALOR, ZD2_DESC, ZD2_DTCONC "+CRLF
	cQuery += " FROM "+RetSqlName("ZD2")+" ZD2 "+CRLF
	cQuery += " WHERE ZD2_FILIAL = '"+XFILIAL("ZD2")+"' "+CRLF
	cQuery += " AND ZD2_BANCO IN ('"+PADL(MV_PAR01,TAMSX3("ZD2_BANCO")[1],"0")+"', '"+MV_PAR01+"') "+CRLF
	cQuery += " AND ZD2_AGENC = '"+MV_PAR02+"' "+CRLF
	//cQuery += " AND CONVERT(INT, ZD2_CONTA) =  "+ALLTRIM(STR(val(alltrim(MV_PAR03)+cDigConta)))+" "+CRLF
	cQuery += " AND ZD2_CONTA = '09722' "+CRLF      
	cQuery += " AND ZD2_DATA BETWEEN '"+DTOS(MV_PAR04)+"' AND '"+DTOS(MV_PAR05)+"' "+CRLF
	IF MV_PAR06 == 1
		cQuery += " AND ZD2_DTCONC <> '' "+CRLF
	ELSEIF  MV_PAR06 == 2
		cQuery += " AND ZD2_DTCONC = ' ' "+CRLF
	ENDIF
	cQuery += " AND ZD2.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " ORDER BY ZD2_DATA, ZD2_FITID "+CRLF
	
	

	DBUseArea(.T.,"TOPCONN", TCGenQry(,,cQuery),"TREL", .F., .T.)
	
	TCSetField("TREL","ZD2_DATA","D",08,00)
	TCSetField("TREL","ZD2_DTCONC","D",08,00)
	
Return




/*/{Protheus.doc} AjustSX1
Cria perguntas no SX1
@author Augusto Ribeiro | www.compila.com.br
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


aHelpPor := {} ; Aadd( aHelpPor, "Banco")
xPUTSX1( cPerg, "01","Banco"	,"","","mv_ch1","C",TAMSX3("A6_COD")[1],0,0,"G","","SA6","","","mv_par01","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Agencia")
xPUTSX1( cPerg, "02","Agencia"	,"","","mv_ch2","C",TAMSX3("A6_AGENCIA")[1],0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Conta")
xPUTSX1( cPerg, "03","Conta"	,"","","mv_ch3","C",TAMSX3("A6_NUMCON")[1],0,0,"G","","","","","mv_par03","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. De")
xPUTSX1( cPerg, "04","Data Mov. De","","","mv_ch4","D",08,0,0,"G","","","","","mv_par04","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Data Mov. Ate")
xPUTSX1( cPerg, "05","Data Mov. Ate","","","mv_ch5","D",08,0,0,"G","","","","","mv_par05","","","","","","","","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

aHelpPor := {} ; Aadd( aHelpPor, "Concilia็ใo")
xPUTSX1( cPerg, "06","Concilia็ใo","","","mv_ch6","N",01,0,0,"C","","","","","mv_par06","Conciliados","","","","Nใo Conciliados","","","Ambos","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa )

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

// Ajusta o tamanho do grupo. Ajuste emergencial para valida็ใo dos fontes.
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