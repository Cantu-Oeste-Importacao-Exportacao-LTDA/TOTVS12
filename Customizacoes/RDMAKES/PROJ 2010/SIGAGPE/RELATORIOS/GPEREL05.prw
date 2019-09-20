#INCLUDE "COLORS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FONT.CH"
#INCLUDE "PRINT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGPEREL05   บAutor  ณTOTVS CASCAVEL     บ Data ณ  01/07/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de registros de tํtulos integra็ใo SIGAGPE-SIGAFINบฑฑ
ฑฑบ          ณTabela RC1.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User function GPEREL05

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "RELATำRIO DE TอTULOS GPE"
Local cPict        := ""
Local titulo       := "RELATำRIO DE TอTULOS GPE"
Local nLin         := 80
Local Cabec1       := "TIPO TอTULO                                MATRICULA   NOME                                                 CENTRO CUSTO                                        EMISSรO       VENCIMENTO             VALOR"
Local Cabec2       := ""
Local imprime      := .T.   
Local nCotac       := 0
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 220
Private tamanho    := "G"
Private nomeprog   := "GPEREL05" 
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Contabilidade", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cPerg      := "GPEREL05X1"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "GPEREL05" 
   
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
     
	AjustaSx1()
	Pergunte(cPerg,.F.)                                                                      
	wnrel := SetPrint("RC1",NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,.F.,Tamanho,,.F.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,"RC1")
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac) },Titulo)
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunReport  บAutor  ณTOTVS CASCAVEL     บ Data ณ  01/07/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de registros de tํtulos integra็ใo SIGAGPE-SIGAFINบฑฑ
ฑฑบ          ณTabela RC1.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunReport(Cabec1,Cabec2,Titulo,nLin,nCotac)

Local cAliasTMP := GetNextAlias()
Local nTOTCOD	:= 0
Local cAUXCOD	:= ""
Local nTOTCCC	:= 0
Local cAUXCCC	:= ""
Local nTOTGRL	:= 0

	If MV_PAR01 == NIL .OR. Empty(MV_PAR01)
		MV_PAR01 := Date()
	Endif
	
	If MV_PAR02 == NIL .OR. Empty(MV_PAR02)
		MV_PAR02 := Date()
	Endif
	   
	If MV_PAR03 == NIL .OR. Empty(MV_PAR03)
		MV_PAR03 := Date()
	Endif       
	
	If MV_PAR04 == NIL .OR. Empty(MV_PAR04)
		MV_PAR04 := Date()
	Endif
	
	cQuery := "	SELECT 												" 
	cQuery += "	RC1_CODTIT, 										" 
	cQuery += "	RC1_DESCRI, 										" 
	cQuery += "	RC1_CC,												"
	cQuery += "	RC1_MAT,											"
	cQuery += "	RC1_EMISSA, 										" 
	cQuery += "	RC1_VENCTO, 										" 
	cQuery += "	RC1_VALOR			 								" 
	cQuery += " FROM " + RetSQLName("RC1") + " RC1 					" 
	cQuery += " WHERE	RC1_FILIAL	=  '" + xFilial("RC1") + "'		" 
	cQuery += "	AND		RC1_EMISSA	>= '" + DTOS(MV_PAR01) + "' 	"
	cQuery += "	AND 	RC1_EMISSA	<= '" + DTOS(MV_PAR02) + "' 	"
	cQuery += "	AND 	RC1_VENCTO	>= '" + DTOS(MV_PAR03) + "' 	"
	cQuery += "	AND 	RC1_VENCTO	<= '" + DTOS(MV_PAR04) + "' 	"
	cQuery += "	AND 	RC1_CODTIT	>= '" + UPPER(MV_PAR05) + "' 	"
	cQuery += "	AND 	RC1_CODTIT	<= '" + UPPER(MV_PAR06) + "' 	"
	cQuery += "	AND 	D_E_L_E_T_	<> '*'  						" 
	cQuery += " ORDER BY 											"
	cQuery += "	RC1_CODTIT, 										" 
	cQuery += "	RC1_CC,												"
	cQuery += "	RC1_MAT,											"
	cQuery += "	RC1_VENCTO	 										" 
	
	                         
	TCQUERY cQuery NEW ALIAS (cAliasTMP)
	(cAliasTMP)->(dbGoTop()) 
	While !(cAliasTMP)->(EOF())
	
	  	dbSelectArea("SRA")
	  	dbSetOrder(1)
	  	dbSeek( xFilial("SRA")+(cAliasTMP)->RC1_MAT )    

	  	dbSelectArea("CTT")
	  	dbSetOrder(1)
	  	dbSeek( xFilial("CTT")+(cAliasTMP)->RC1_CC )    
	    
		
		//--TOTALIZADORES	  	
	  	If !Empty(cAUXCOD) .and. cAUXCOD != (cAliasTMP)->RC1_CODTIT+"-"+(cAliasTMP)->RC1_DESCRI

		  	If nLin >= 55
		 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)     
				nLin := 9
		  	Endif                              
		  		
	  		@ nLin, 001 PSAY "TOTAL CENTRO DE CUSTO --------> "+cAUXCCC
	  		@ nLin, 188 PSAY nTOTCCC Picture "@E 999,999,999.99" 
	  		nLin += 1
	  		@ nLin, 001 PSAY "TOTAL DO TIPO DE TอTULO ------> "+cAUXCOD
	  		@ nLin, 188 PSAY nTOTCOD Picture "@E 999,999,999.99" 
	  		nLin += 1
		  	@ nLin,001 PSAY __PrtThinLine()        
		  	nLin += 2
		  	
		  	nTOTCCC := 0
		  	nTOTCOD := 0

	  	ElseIf !Empty(cAUXCCC) .and. cAUXCCC != (cAliasTMP)->RC1_CC+"-"+CTT->CTT_DESC01

		  	If nLin >= 55
		 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)     
				nLin := 9
		  	Endif                              
		  		
	  		@ nLin, 001 PSAY "TOTAL CENTRO DE CUSTO --------> "+cAUXCCC
	  		@ nLin, 188 PSAY nTOTCCC Picture "@E 999,999,999.99" 
		  	nLin += 2
	  	    
	  		nTOTCCC := 0
	  		
	  	EndIf

	  	If nLin >= 55
	 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)     
			nLin := 9
	  	Endif                              
	  	
		@ nLin, 001 PSAY SubSTR((cAliasTMP)->RC1_CODTIT+"-"+(cAliasTMP)->RC1_DESCRI,1,40)
		@ nLin, 043 PSAY (cAliasTMP)->RC1_MAT
		@ nLin, 055 PSAY SubSTR(SRA->RA_NOME,1,50)
		@ nLin, 108 PSAY SubSTR((cAliasTMP)->RC1_CC+"-"+CTT->CTT_DESC01,1,50)	
	  	@ nLin, 160 PSAY TRANSFORM( STOD((cAliasTMP)->RC1_EMISSA), '@D 99/99/99')
		@ nLin, 174 PSAY TRANSFORM( STOD((cAliasTMP)->RC1_VENCTO), '@D 99/99/99')
		@ nLin, 188 PSAY (cAliasTMP)->RC1_VALOR Picture "@E 999,999,999.99" 
	  	nLin += 1

		nTOTCOD	+= (cAliasTMP)->RC1_VALOR
		cAUXCOD	:= (cAliasTMP)->RC1_CODTIT+"-"+(cAliasTMP)->RC1_DESCRI
		nTOTCCC	+= (cAliasTMP)->RC1_VALOR
		cAUXCCC	:= (cAliasTMP)->RC1_CC+"-"+CTT->CTT_DESC01
		nTOTGRL	+= (cAliasTMP)->RC1_VALOR
	
	    (cAliasTMP)->(dbSkip())  	
	Enddo 
	(cAliasTMP)->(dbCloseArea())
	
  	
  	If !Empty(cAUXCOD)
	  	If nLin >= 55
	 		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)     
			nLin := 9
	  	Endif                              
	  		
  		@ nLin, 001 PSAY "TOTAL CENTRO DE CUSTO --------> "+cAUXCCC
  		@ nLin, 188 PSAY nTOTCCC Picture "@E 999,999,999.99" 
  		nLin += 1
  		@ nLin, 001 PSAY "TOTAL DO TIPO DE TอTULO ------> "+cAUXCOD
  		@ nLin, 188 PSAY nTOTCOD Picture "@E 999,999,999.99" 
  		nLin += 1
	  	@ nLin,001 PSAY __PrtThinLine()        
	  	nLin += 1
  		@ nLin, 001 PSAY "TOTAL GERAL DO RELATำRIO -----> "
  		@ nLin, 188 PSAY nTOTGRL Picture "@E 999,999,999.99" 

	EndIf
	
	
	SET DEVICE TO SCREEN
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	MS_FLUSH()
	
Return 

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1  บAutor  ณTOTVS CASCAVEL     บ Data ณ  01/07/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de registros de tํtulos integra็ใo SIGAGPE-SIGAFINบฑฑ
ฑฑบ          ณTabela RC1.                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function AjustaSX1()
Local aAreaTMP	:= GetArea()
Local aRegs		:= {}

	
	//Grupo/Ordem/Pergunta/PerSPA/PerENG/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSPA1/DefENG1/Cnt01/Var02/Def02/DefSPA2/DefENG2/Cnt02/Var03/Def03/DefSPA3/DefENG3/Cnt03/Var04/Def04/DefSPA4/DefENG4/Cnt04/Var05/Def05/DefSPA5/DefENG5/Cnt05/F3/GRPSXG
	aAdd(aRegs,{cperg,"01","Dt Emis. de ?",    "","","mv_ch1"  ,"D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"02","Dt Emis. ate ?",   "","","mv_ch2"  ,"D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"03","Dt Venc. de ?",    "","","mv_ch3"  ,"D",08,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"04","Dt Venc. ate ?",   "","","mv_ch4"  ,"D",08,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cperg,"05","Tipo de?",         "","","mv_ch5"  ,"C",03,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","RC0","","",""})
	aAdd(aRegs,{cperg,"06","Tipo ate?",        "","","mv_ch6"  ,"C",03,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","","RC0","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	For i:=1 to Len(aRegs)
		If !dbSeek(cperg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	
	RestArea(aAreaTMP)	
	
Return