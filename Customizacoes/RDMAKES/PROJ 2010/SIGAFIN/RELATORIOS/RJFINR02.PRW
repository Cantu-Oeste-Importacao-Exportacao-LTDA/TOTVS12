#include "rwmake.ch" 
#include "TOPCONN.ch" 
#define PAD_LEFT	0
#define PAD_RIGHT	1                        
#define PAD_CENTER	2                           
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFINR02   บAutor  ณRafael Parma       บ Data ณ  18/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de duplicata, contas a receber.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*-----------------------------*                                               
User Function RJFINR02()
*-----------------------------*
Private cPerg := "DUPLICATA1"  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())
   
	AjustaSX1()
	If Pergunte(cPerg, .T.)
		U_RJFR02P(.T., mv_par01, mv_par02, mv_par03)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJFR02P    บAutor  ณRafael Parma       บ Data ณ  18/11/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImpressใo de duplicata, contas a receber.                   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*------------------------------------------------------* 
User Function RJFR02P(lSE1, cTITINI, cTITFIN, cPREFIXO)      
*------------------------------------------------------* 
Local cAliasTMP := GetNextAlias()

Private oFont08N := TFont():New( "Verdana"    ,,08,,.F.,,,,,.F. )
Private oFont10N := TFont():New( "Verdana"    ,,10,,.F.,,,,,.F. )
Private oFont12N := TFont():New( "Verdana"    ,,12,,.F.,,,,,.F. )
Private oFont14N := TFont():New( "Verdana"    ,,14,,.F.,,,,,.F. )
Private oFont16N := TFont():New( "Verdana"    ,,16,,.F.,,,,,.F. )

Private oFont08B := TFont():New( "Verdana"    ,,08,,.T.,,,,,.F. )
Private oFont10B := TFont():New( "Verdana"    ,,10,,.T.,,,,,.F. )
Private oFont12B := TFont():New( "Verdana"    ,,12,,.T.,,,,,.F. )
Private oFont14B := TFont():New( "Verdana"    ,,14,,.T.,,,,,.F. )
Private oFont16B := TFont():New( "Verdana"    ,,16,,.T.,,,,,.F. )
Private aDADOS := {}
Private oPrn       

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())              

	If lSE1
		
		//-- Impressใo pelo SIGALOJA ou MANUAL
		
		cQuery := "	SELECT 																	" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_NUM,														" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_PREFIXO,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_PARCELA,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_CLIENTE,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_LOJA,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_VENCTO,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_VALOR,													" + CHR(13)+CHR(10)
		cQuery += "			(SELECT SUM(E1_SALDO) FROM " + RetSQLName("SE1") + " E1			" + CHR(13)+CHR(10)
		cQuery += "           WHERE SE1.E1_FILIAL   = '" + xFilial("SE1") + "'				" + CHR(13)+CHR(10)	
  		cQuery += "             AND E1.E1_NUM BETWEEN '" + cTITINI + "' AND '" + cTITFIN + "'" + CHR(13)+CHR(10)			
    	cQuery += "             AND E1.E1_PREFIXO  = '" + cPREFIXO + "'						" + CHR(13)+CHR(10)			
   		cQuery += "             AND E1.E1_TIPO       != 'CH '     							" + CHR(13)+CHR(10)							
		cQuery += "             AND E1.D_E_L_E_T_ = ' ') AS SALDO							" + CHR(13)+CHR(10)
		cQuery += "	FROM " + RetSQLName("SE1") + " SE1										" + CHR(13)+CHR(10)                                                                                               
		cQuery += "	WHERE 																	" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_FILIAL   = '" + xFilial("SE1") + "'						" + CHR(13)+CHR(10)
		cQuery += " AND		SE1.E1_NUM BETWEEN '" + cTITINI + "' AND '" + cTITFIN + "'		" + CHR(13)+CHR(10)	
		cQuery += "	AND		SE1.E1_PREFIXO  = '" + cPREFIXO + "'							" + CHR(13)+CHR(10)
		cQuery += "	AND		SE1.E1_TIPO       != 'CH '     									" + CHR(13)+CHR(10)			
		cQuery += "	AND		SE1.D_E_L_E_T_ = ' '											" + CHR(13)+CHR(10)			
		cQuery += "	ORDER BY																" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_NUM,														" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_PREFIXO,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_PARCELA,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_CLIENTE,													" + CHR(13)+CHR(10)
		cQuery += "			SE1.E1_LOJA 													" + CHR(13)+CHR(10)
		
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)	
		
		dbSelectArea(cAliasTMP)
		dbGoTop()	
		ProcRegua((cAliasTMP)->(RecCount()))   
		
		While !(cAliasTMP)->(EOF())
			aAdd ( aDADOS, { (cAliasTMP)->E1_NUM , (cAliasTMP)->E1_PREFIXO , (cAliasTMP)->E1_PARCELA , (cAliasTMP)->E1_CLIENTE , (cAliasTMP)->E1_LOJA , STOD((cAliasTMP)->E1_VENCTO) , (cAliasTMP)->E1_VALOR , (cAliasTMP)->SALDO } )
			(cAliasTMP)->(dbSkip())
		Enddo
		(cAliasTMP)->(dbCloseArea())
		
		
	Else                             
	
		//-- Impressใo pelo FRONTLOJA
		
		dbSelectArea("SL4")
		dbSetOrder(1)
		dbGoTop()                                   		
		If dbSeek( xFilial("SL4") + cTITINI )       
			nPARC := 1
			While !SL4->(EOF()) .and. SL4->L4_FILIAL + SL4->L4_NUM == xFilial("SL4") + cTITINI
				aAdd ( aDADOS, { SL4->L4_NUM , SL4->L4_FORMA , STRZero(nPARC,TAMSX3("E1_PARCELA")[1]) , SL1->L1_CLIENTE , SL1->L1_LOJA , SL4->L4_DATA , SL4->L4_VALOR } )
				nPARC += 1
				SL4->(dbSkip())
			Enddo
		EndIf
		
	EndIf
		
	If Len(aDADOS) > 0

		oPrn:=TMSPrinter():New()
		oPrn:SetPortrait() 
		oPrn:SetPage(9)	//Folha A4
		oPrn:Setup()        
		
		nColF := 2300
		nLinF := 1800
	
		dbSelectArea("SM0")
		
		For nI := 1 to Len(aDADOS)
            
            dbSelectArea("SA1")
            dbSetorder(1)
            dbSeek( xFilial("SA1") + aDADOS[nI][04] + aDADOS[nI][05] )
            
			oPrn:StartPage()
            nLin := 100
            nCol := 100
			oPrn:Box(nLin,nCol,nLinF,nColF)
		    oPrn:Box(nLin+1,nCol+1,nLinF-1,nColF-1)	
		 	oPrn:Box(nLin+2,nCol+2,nLinF-2,nColF-2)	
            nLin += 020
            nCol += 020			
			oPrn:SayBitmap(nLin,nCol,"lgrl"+cEmpAnt+".bmp",196,94)
			
			nCol += 300
			oPrn:Say( nLin, nCol, UPPER(SM0->M0_NOMECOM),	oFont14B, 100 )			
		    nLin += 100                                                         
		    oPrn:Say( nLin, nCol, ALLTRIM(SM0->M0_ENDCOB), 	oFont12N, 100 )			
		    nCol += 1000                                                                                   
		    oPrn:Say( nLin, nCol, ALLTRIM(SM0->M0_BAIRCOB), oFont12N, 100 )
		    nLin += 060
		    nCol -= 1300
		    oPrn:Say( nLin, nCol, "DADOS DO", oFont10N , 100 )                                                                                             
		    nCol += 300
		    oPrn:Say( nLin, nCol, ALLTRIM(SM0->M0_CIDCOB)+"-"+ALLTRIM(SM0->M0_ESTCOB), oFont12N , 100 )
		    nCol += 1000                                                                                
		    oPrn:Say( nLin, nCol, "CEP: "+TRANSFORM(SM0->M0_CEPCOB,"@R 99999-999"), oFont12N , 100 )
		    nLin += 060                                                                             
		    nCol -= 1300
		    oPrn:Say( nLin, nCol, " CEDENTE", oFont10N , 100 )                                                                                             
		    nCol += 300		    
		    oPrn:Say( nLin, nCol, "CNPJ: "+TRANSFORM(SM0->M0_CGC,"@R 99.999.999/9999-99"), oFont12N , 100 )
		    nCol += 1000                                                                                 
		    oPrn:Say( nLin, nCol, "I.E.: "+ALLTRIM(SM0->M0_INSC), oFont12N, 100 )  
           
		 	
		    			                       
		    nCol := 100
		    nLin += 100
		 	oPrn:Line( nLin, nCol, nLin, nColF )
		 	nLinI := nLin		 	                           
		 	nLin += 020                                    
		 	nCol += 1650               
		 	oPrn:Say( nLin, nCol, "PARA USO DA INST. FINANCEIRA",	oFont08N, 100 )    
			nLin += 010
		 	nCol -= 1400
			oPrn:Say( nLin, nCol, "FATURA",	oFont14B, 100 )  
			nLin += 001	
		 	nCol += 900 
			oPrn:Say( nLin, nCol, "DUPLICATA",	oFont14B, 100 )  						
		 	nLin += 200
		 	nCol := 100
		 	oPrn:Line( nLin, nCol, nLin, nColF )
		 	nCol := 1740
		 	oPrn:Line( nLinI, nCol, nLin, nCol )
			nLin += 030
			nCol := 120
			oPrn:Say( nLin, nCol, "NOTA/PREFIXO:",	oFont10B, 100 )			
			nCol += 500
			oPrn:Say( nLin, nCol, "VALOR:",	oFont10B, 100 )			
			nCol += 500                                                 
			oPrn:Say( nLin, nCol, "TอTULO/PARCELA:",	oFont10B, 100 )	  
			nCol += 480
			oPrn:Say( nLin, nCol, "VALOR PARCELA:",	oFont10B, 100 )		
			nCol += 400
			oPrn:Say( nLin, nCol, "VENCIMENTO:",	oFont10B, 100 )			
			nLin += 070
			nCol := 120
			oPrn:Say( nLin, nCol, aDADOS[nI][01]+"/"+aDADOS[nI][02],	oFont10N, 100 )			
			nCol += 420
			oPrn:Say( nLin, nCol, TRANSFORM(aDADOS[nI][08],"@E 999,999,999.99"),oFont10N, 100,,, PAD_LEFT  )						
			nCol += 580
			oPrn:Say( nLin, nCol, aDADOS[nI][01]+"/",	oFont10N, 100 )			
			nCol += 225
			oPrn:Say( nLin, nCol, IIF(EMPTY(aDADOS[nI][03]),"-",aDADOS[nI][03]),	oFont10N, 100 )
			nCol += 250
			oPrn:Say( nLin, nCol, TRANSFORM(aDADOS[nI][07],"@E 999,999,999.99"),oFont10N, 100,,, PAD_LEFT  )
			nCol += 470
			oPrn:Say( nLin, nCol, DTOC(aDADOS[nI][06]),	oFont10N, 100	)		
		 	nLin += 050
		 	nCol := 100
		 	oPrn:Line( nLin, nCol, nLin, nColF )
			nLin += 040
			nCol := 120                                                     			                                                                
			oPrn:Say( nLin, nCol, "VALOR POR EXTENSO: ("+ALLTRIM(EXTENSO(aDADOS[nI][07]))+")", oFont10N, 100 )			    
			nLin += 060
			nCol := 100 
			oPrn:Line( nLin, nCol, nLin, nColF )
			nLin += 040
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "SACADO:",	oFont10B, 100 )			    
			nCol += 450                                                     
			oPrn:Say( nLin, nCol, ALLTRIM(SA1->A1_NOME)+" ("+SA1->A1_COD+"/"+SA1->A1_LOJA+")",	oFont10N, 100 )
			nLin += 060
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "ENDEREวO:",	oFont10B, 100 )			
			nCol += 450                                                     
			oPrn:Say( nLin, nCol, ALLTRIM(SA1->A1_END),	oFont10N, 100 )
			nLin += 060
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "MUNICอPIO:",	oFont10B, 100 )			
			nCol += 450                                                     
			oPrn:Say( nLin, nCol, ALLTRIM(SA1->A1_MUN)+" - "+ALLTRIM(SA1->A1_EST)+" - CEP: "+TRANSFORM(SA1->A1_CEP,"@R 99999-999"),	oFont10N, 100 )
			nLin += 060
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "CNPJ/CPF:",	oFont10B, 100 )			
			nCol += 450	                                                     
			oPrn:Say( nLin, nCol, TRANSFORM(SA1->A1_CGC,IIF(LEN(ALLTRIM(SA1->A1_CGC))>11,"@R 99.999.999/9999-99","@R 999.999.999-99")),	oFont10N, 100 )
			nLin += 060
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "INSC.EST.:",	oFont10B, 100 )			
			nCol += 450                                                     
			oPrn:Say( nLin, nCol, IIF(EMPTY(SA1->A1_INSCR),"-",SA1->A1_INSCR),	oFont10N, 100 ) 
			nLin += 060
			nCol := 350 
			oPrn:Say( nLin, nCol, "PRAวA DE PAGAMENTO:",	oFont10B, 100 )			
			nCol += 550                                                     
			oPrn:Say( nLin, nCol, ALLTRIM(SA1->A1_MUN)+" - "+ALLTRIM(SA1->A1_EST),	oFont10N, 100 )
			
			
			nLin += 060
			nCol -= 550                                                     
		 	oPrn:Line( nLin, nCol, nLin, nColF )
			nLin += 060
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "RECONHEวO(EMOS) A EXATIDรO DESTA DUPLICATA A IMPORTยNCIA ACIMA QUE PAGAREI(EMOS) ภ	",	oFont10N, 100 )
		    nLin += 050
			nCol += 001
			oPrn:Say( nLin, nCol, UPPER(SM0->M0_NOMECOM),	oFont10B, 100 )
			nLin += 050
			nCol := 350                                                     
			oPrn:Say( nLin, nCol, "A SUA ORDEM NA PRAวA E VENCIMENTO ACIMA INDICADOS.",	oFont10N, 100 )
			                                             
			
			
			nLin += 200
			nCol := 130                                                     
			oPrn:Say( nLin, nCol, "____/____/_______",	oFont10N, 100 )
			nCol += 420
			oPrn:Say( nLin, nCol, "____________________________",	oFont10N, 100 )
			nCol += 740                                                   
			oPrn:Say( nLin, nCol, "__________________________________________",	oFont10N, 100 )
			nLin += 050      
			nCol := 180                                                     
			oPrn:Say( nLin, nCol, "DT. ACEITE",	oFont10N, 100 )
			nCol := 700
			oPrn:Say( nLin, nCol, "ASS. SACADO",	oFont10N, 100 )
			nCol := 1270
			oPrn:Say( nLin, nCol, UPPER(SM0->M0_NOMECOM),	oFont10B, 100 )
			 
			
			oPrn:EndPage()
			IncProc()
			
		Next nI
	
		oPrn:Preview()
		
	Else
		MsgStop("Nใo exitem dados para impressใo com os parโmetros informados!")
	EndIf                          
	

Return 


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAJUSTASX1  บAutor  ณRafael Parma       บ Data ณ  22/09/2010 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo utilizada para verificar/criar no ambiente o grupo   บฑฑ
ฑฑบ          ณde perguntas.                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

*--------------------------*
Static Function AjustaSX1()
*--------------------------*
aRegs  := {} 

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	//ณDefini็ใo dos itens do grupo de perguntas a ser criadoณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
	aAdd(aRegs,{cPerg,"01","Tํtulo De           ?","Tํtulo De           ?","Tํtulo De           ?","mv_ch1","C",TAMSX3("E1_NUM")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","", "SE1","","018",""})
	aAdd(aRegs,{cPerg,"02","Tํtulo At้          ?","Tํtulo At้          ?","Tํtulo At้          ?","mv_ch2","C",TAMSX3("E1_NUM")[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","", "SE1","","018",""})
   //aAdd(aRegs,{cPerg,"03","Parcela De          ?","Parcela De          ?","Parcela De          ?","mv_ch3","C",TAMSX3("E1_PARCELA")[1],0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
   //aAdd(aRegs,{cPerg,"04","Parcela At้         ?","Parcela At้         ?","Parcela At้         ?","mv_ch4","C",TAMSX3("E1_PARCELA")[1],0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	aAdd(aRegs,{cPerg,"05","Prefixo             ?","Prefixo             ?","Prefixo             ?","mv_ch5","C",TAMSX3("E1_PREFIXO")[1],0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","", "","","",""})
	dbSelectArea("SX1")
	dbSetOrder(1) 
	
	For i := 1 To Len(aRegs)
		If !dbSeek(cPerg + aRegs[i,2])
			RecLock("SX1", .T.)
			For j := 1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j, aRegs[i,j])	 
				Endif
			Next
			MsUnlock()
		Endif
	Next         

	
Return Nil