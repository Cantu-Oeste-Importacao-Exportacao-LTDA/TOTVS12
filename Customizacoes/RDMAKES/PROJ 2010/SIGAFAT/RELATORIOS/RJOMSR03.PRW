#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "PRINT.CH"
#INCLUDE "FONT.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJOMSR03  บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de confer๊ncia das notas fiscais emitidas.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJOMSR03()
*---------------------------------------------------------------------------*
Private cTitulo		:= "Relat๓rio de confer๊ncia das notas fiscais emitidas"
Private cLogoImg	:= "lgrl" + cEmpAnt + ".bmp"
Private cPerg		:= "RJOMSR03X1"
Private nheight07	:= 7
Private nHeight08	:= 8
Private nHeight09	:= 9
Private nHeight10	:= 10
Private nHeight11	:= 11
Private nHeight12	:= 12
Private nheight13	:= 13
Private nHeight15	:= 15
Private lBold		:= .T.
Private lUnderLine	:= .T. 
Private oFont1		:= TFont():New( "Arial",,nheight07,,lBold,,,,,!lUnderLine )
Private oFont2		:= TFont():New( "Arial",,nheight09,,lBold,,,,,!lUnderLine )
Private oFont3		:= TFont():New( "Arial",,nheight09,,!lBold,,,,,!lUnderLine )
Private oFont4		:= TFont():New( "Arial",,nheight08,,!lBold,,,,,!lUnderLine )
Private oFont5		:= TFont():New( "Arial",,nHeight13,,lBold,,,,,!lUnderLine )
Private oFont6		:= TFont():New( "Arial",,nheight15,,lBold,,,,,!lUnderLine )
Private oFont7		:= TFont():New( "Arial",,nheight12,,lBold,,,,,!lUnderLine )
Private oFont8		:= TFont():New( "Arial",,nheight08,,lBold,,,,,!lUnderLine )

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	AjustaSX1()
	lRet := Pergunte(cPerg,.T.)
	
	If lRet == .T.	
		Processa( {|| FIMPREL() },cTitulo,"Aguarde....." )
	EndIf
	
Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPREL   บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRelat๓rio de confer๊ncia das notas fiscais emitidas.        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function FIMPREL()
*---------------------------------------------------------------------------*
Private nLinha		:= 0
Private nPagina		:= 0
Private nColuna		:= 50
Private nIncremento	:= 50
Private aSTATUSNFE	:= {}
Private lFirst		:= .T.
Private hEnter		:= CHR(10) + CHR(13)
Private oPrinter	:= TMSPrinter():New()
Private oBrush		:= TBrush():New(,CLR_GRAY)
Private	cAliasSF3	:= GetNextAlias()
Private	cAliasSD1	:= GetNextAlias()


	// Sele็ใo de notas fiscais de entradas (formulario proprio) e notas de saidas..
	cQuery := "SELECT                                                                                               "+hEnter
	cQuery += "  TIPO,                                                                                              "+hEnter
	cQuery += "  DELETADO,                                                                                          "+hEnter
	cQuery += "  F3_FILIAL ,                                                                                        "+hEnter
	cQuery += "  F3_NFISCAL,                                                                                        "+hEnter
	cQuery += "  F3_SERIE,                                                                                          "+hEnter
	cQuery += "  F3_ENTRADA,                                                                                        "+hEnter
	cQuery += "  F3_CFO,                                                                                            "+hEnter
	cQuery += "  F3_OBSERV,                                                                                         "+hEnter
	cQuery += "  F3_CODRSEF,                                                                                        "+hEnter	
	cQuery += "  F2_CHVNFE,                                                                                         "+hEnter
	cQuery += "  SUM (VALCONT_F3)  AS VALCONT,                                                                      "+hEnter
	cQuery += "  SUM (BASEICM_F3)  AS BASEICM,                                                                      "+hEnter
	cQuery += "  SUM (VALICM_F3)   AS VALICM                                                                        "+hEnter
	cQuery += "FROM                                                                                                 "+hEnter
	cQuery += "  (                                                                                                  "+hEnter
	cQuery += "    SELECT                                                                                           "+hEnter
	cQuery += "      'S'               AS TIPO,                                                                     "+hEnter
	cQuery += "      SF2.D_E_L_E_T_    AS DELETADO,                                                                 "+hEnter
	cQuery += "      F3_FILIAL         AS F3_FILIAL,                                                                "+hEnter
	cQuery += "      F3_NFISCAL        AS F3_NFISCAL,                                                               "+hEnter
	cQuery += "      F3_SERIE          AS F3_SERIE,                                                                 "+hEnter
	cQuery += "      F3_ENTRADA        AS F3_ENTRADA,                                                               "+hEnter
	cQuery += "      F3_CFO            AS F3_CFO,                                                                   "+hEnter
	cQuery += "      F3_OBSERV         AS F3_OBSERV,                                                                "+hEnter
	cQuery += "  	 F3_CODRSEF		   AS F3_CODRSEF,                                                               "+hEnter	
	cQuery += "      F2_CHVNFE         AS F2_CHVNFE,                                                                "+hEnter
	cQuery += "      SUM (F3_VALCONT)  AS VALCONT_F3,                                                               "+hEnter
	cQuery += "      SUM (F3_BASEICM)  AS BASEICM_F3,                                                               "+hEnter
	cQuery += "      SUM (F3_VALICM)   AS VALICM_F3                                                                 "+hEnter
	cQuery += "    FROM                                                                                             "+hEnter
	cQuery += "    "+RetSqlName("SF3")+" SF3,                                                                       "+hEnter
	cQuery += "    "+RetSqlName("SF2")+" SF2                                                                        "+hEnter
	cQuery += "    WHERE                                                                                            "+hEnter
	cQuery += "          SF3.F3_FILIAL       BETWEEN  '" + MV_PAR03 + "'  AND '" + MV_PAR04 + "'                    "+hEnter
	cQuery += "      AND SF3.F3_ENTRADA      BETWEEN  '" + dToS(MV_PAR01) + "'  AND '" + dToS(MV_PAR02) + "'        "+hEnter
	cQuery += "      AND SF3.F3_FILIAL       = SF2.F2_FILIAL                                                        "+hEnter
	cQuery += "      AND SF3.F3_NFISCAL      = SF2.F2_DOC                                                           "+hEnter
	cQuery += "      AND SF3.F3_SERIE        = SF2.F2_SERIE                                                         "+hEnter
	cQuery += "      AND SF3.F3_CLIEFOR      = SF2.F2_CLIENTE                                                       "+hEnter
	cQuery += "      AND SF3.F3_LOJA         = SF2.F2_LOJA                                                          "+hEnter
	cQuery += "      AND SF3.F3_ENTRADA      = SF2.F2_EMISSAO                                                       "+hEnter
	
	If mv_par05 == 1    
		cQuery += "      AND TRIM(SF2.F2_CHVNFE) IS NULL                                                            "+hEnter
	EndIf
	
	cQuery += "      AND SF3.D_E_L_E_T_  <> '*'                                                                     "+hEnter
	cQuery += "    GROUP BY                                                                                         "+hEnter
	cQuery += "      'S',                                                                                           "+hEnter
	cQuery += "      SF2.D_E_L_E_T_,                                                                                "+hEnter
	cQuery += "      F3_FILIAL,                                                                                     "+hEnter
	cQuery += "      F3_NFISCAL,                                                                                    "+hEnter
	cQuery += "      F3_SERIE,                                                                                      "+hEnter
	cQuery += "      F3_ENTRADA,                                                                                    "+hEnter
	cQuery += "      F3_CFO,                                                                                        "+hEnter
	cQuery += "      F3_OBSERV,                                                                                     "+hEnter
	cQuery += "  	 F3_CODRSEF,                                                                                    "+hEnter	
	cQuery += "      F2_CHVNFE                                                                                      "+hEnter
	cQuery += "    UNION ALL                                                                                        "+hEnter
	cQuery += "    SELECT                                                                                           "+hEnter
	cQuery += "      'E'             AS TIPO,                                                                       "+hEnter
	cQuery += "      SF1.D_E_L_E_T_  AS DELETADO,                                                                   "+hEnter
	cQuery += "      F3_FILIAL       AS F3_FILIAL,                                                                  "+hEnter
	cQuery += "      F3_NFISCAL      AS F3_NFISCAL,                                                                 "+hEnter
	cQuery += "      F3_SERIE        AS F3_SERIE,                                                                   "+hEnter
	cQuery += "      F3_ENTRADA      AS F3_ENTRADA,                                                                 "+hEnter
	cQuery += "      F3_CFO          AS F3_CFO,                                                                     "+hEnter
	cQuery += "      F3_OBSERV       AS F3_OBSERV,                                                                  "+hEnter
	cQuery += "		 F3_CODRSEF      AS F3_CODRSEF,                                                                 "+hEnter	
	cQuery += "      F1_CHVNFE       AS F1_CHVNFE,                                                                  "+hEnter
	cQuery += "      SUM(F3_VALCONT) AS VALCONT_F3,                                                                 "+hEnter
	cQuery += "      SUM(F3_BASEICM) AS BASEICM_F3,                                                                 "+hEnter
	cQuery += "      SUM(F3_VALICM)  AS VALICM_F3                                                                   "+hEnter
	cQuery += "    FROM                                                                                             "+hEnter
	cQuery += "    "+RetSqlName("SF3")+" SF3,                                                                       "+hEnter
	cQuery += "    "+RetSqlName("SF1")+" SF1                                                                        "+hEnter
	cQuery += "    WHERE                                                                                            "+hEnter
	cQuery += "          SF3.F3_FILIAL       BETWEEN  '" + MV_PAR03 + "'  AND '" + MV_PAR04 + "'                    "+hEnter
	cQuery += "      AND SF3.F3_ENTRADA      BETWEEN  '" + dToS(MV_PAR01) + "'  AND '" + dToS(MV_PAR02) + "'        "+hEnter
	cQuery += "      AND SF3.F3_FILIAL   = SF1.F1_FILIAL                                                            "+hEnter
	cQuery += "      AND SF3.F3_NFISCAL  = SF1.F1_DOC                                                               "+hEnter
	cQuery += "      AND SF3.F3_SERIE    = SF1.F1_SERIE                                                             "+hEnter
	cQuery += "      AND SF3.F3_CLIEFOR  = SF1.F1_FORNECE                                                           "+hEnter
	cQuery += "      AND SF3.F3_LOJA     = SF1.F1_LOJA                                                              "+hEnter
	cQuery += "      AND SF3.F3_ENTRADA  = SF1.F1_DTDIGIT                                                           "+hEnter
	cQuery += "      AND (SF3.F3_CFO     > '5000' OR SF3.F3_FORMUL = 'S')                                           "+hEnter
	
	If mv_par05 == 1    
		cQuery += "      AND TRIM(SF1.F1_CHVNFE) IS NULL                                                            "+hEnter
	EndIf
	
	cQuery += "      AND SF3.D_E_L_E_T_  <> '*'                                                                     "+hEnter
	cQuery += "    GROUP BY                                                                                         "+hEnter
	cQuery += "      'E',                                                                                           "+hEnter
	cQuery += "      SF1.D_E_L_E_T_,                                                                                "+hEnter
	cQuery += "      F3_FILIAL,                                                                                     "+hEnter
	cQuery += "      F3_NFISCAL,                                                                                    "+hEnter
	cQuery += "      F3_SERIE,                                                                                      "+hEnter
	cQuery += "      F3_ENTRADA,                                                                                    "+hEnter
	cQuery += "      F3_CFO,                                                                                        "+hEnter
	cQuery += "      F3_OBSERV,                                                                                     "+hEnter
	cQuery += "  	 F3_CODRSEF,                                                                                    "+hEnter	
	cQuery += "      F1_CHVNFE )                                                                                    "+hEnter
	cQuery += "GROUP BY                                                                                             "+hEnter
	cQuery += "  TIPO,                                                                                              "+hEnter
	cQuery += "  DELETADO,                                                                                          "+hEnter
	cQuery += "  F3_FILIAL,                                                                                         "+hEnter
	cQuery += "  F3_NFISCAL,                                                                                        "+hEnter
	cQuery += "  F3_SERIE,                                                                                          "+hEnter
	cQuery += "  F3_ENTRADA,                                                                                        "+hEnter
	cQuery += "  F3_CFO,                                                                                            "+hEnter
	cQuery += "  F3_OBSERV,                                                                                         "+hEnter
	cQuery += "  F3_CODRSEF,                                                                                        "+hEnter	
	cQuery += "  F2_CHVNFE                                                                                          "+hEnter
	cQuery += "ORDER BY                                                                                             "+hEnter
	cQuery += "  F3_FILIAL,                                                                                         "+hEnter
	cQuery += "  F3_NFISCAL,                                                                                        "+hEnter
	cQuery += "  F3_SERIE,                                                                                          "+hEnter
	cQuery += "  DELETADO                                                                                           "+hEnter
	
	MemoWrite("RJOMSR03.SQL",cQuery)
	TcQuery changequery(cQuery) New Alias (cAliasSF3)
	
	If Alias() <> (cAliasSF3)
		MsgBox("cAliasSF3 - Parโmetros Invแlidos!")
		Return .F.
	Endif 
	
	nNUMREG := 0                
	dbSelectArea(cAliasSF3) 
	(cAliasSF3)->(dbGoTop())  
	While !(cAliasSF3)->(EOF())
		nNUMREG++
		(cAliasSF3)->(dbSkip())
	Enddo
	
	If ( nNUMREG == 0 )                                                           
		MsgBox("Nใo hแ dados para listar! Verifique os parโmetros.")
		(cAliasSF3)->(dbCloseArea())
		Return
	EndIf
	
	oPrinter:Setup()
	
	
	// recupera todas as NFs selecionadas
	aLLNOTAS := {}
	dbSelectArea(cAliasSF3)
	(cAliasSF3)->(dbGoTop())
	While !(cAliasSF3)->(EOF())
		aAdd ( aLLNOTAS, {(cAliasSF3)->F3_FILIAL, (cAliasSF3)->F3_NFISCAL, (cAliasSF3)->F3_SERIE, (cAliasSF3)->TIPO, (cAliasSF3)->DELETADO, (cAliasSF3)->F2_CHVNFE } )
		(cAliasSF3)->(dbSkip())
	Enddo
	
	// verifica todas as notas fiscais, e soma quantidade de registros (nfs duplicadas com registros deletados)
	If Len(aLLNOTAS) > 0
		aNOTAS := {}
		dbSelectArea(cAliasSF3)
		(cAliasSF3)->(dbGoTop())
		While ! (cAliasSF3)->(EOF())
			
			If Len(aNOTAS) > 0
				nPOS := aScan ( aNOTAS , {|x| 	x[1] == (cAliasSF3)->F3_FILIAL  .and. ;
												x[2] == (cAliasSF3)->F3_NFISCAL .and. ;
												x[3] == (cAliasSF3)->F3_SERIE   .and. ;
												x[4] == (cAliasSF3)->TIPO } )
			Else
				nPOS := 0
			EndIf
			
			If nPOS == 0
				aAdd ( aNOTAS, {(cAliasSF3)->F3_FILIAL, (cAliasSF3)->F3_NFISCAL, (cAliasSF3)->F3_SERIE, (cAliasSF3)->TIPO, "", "", 1 } )
			Else
				aNOTAS[nPOS,7] += 1
			EndIf
			(cAliasSF3)->(dbSkip())
		Enddo                
	EndIf
		
	// adiciona ao array aNOTASOK somente as notas fiscais duplicadas
	If Len(aNOTAS) > 0
		aNOTASOK := {}
		For nI := 1 to Len(aNOTAS)
			If aNOTAS[nI,7] > 1
				aAdd ( aNOTASOK , {aNOTAS[nI,1], aNOTAS[nI,2], aNOTAS[nI,3], aNOTAS[nI,4], aNOTAS[nI,5], aNOTAS[nI,6], aNOTAS[nI,7]} )
			EndIf
		Next nI
	EndIf       
	
	// percorre todo o array aNOTASOK, e identifica todas notas fiscais relacionadas array aLLNOTAS.
	If Len(aNOTASOK) > 0
		For nI := 1 to Len(aNOTASOK)
			nPOSDEL := 0
			nPOSACT := 0
			nPOSCHV := 0
			nNUMREG := 0
			For nJ := 1 to Len(aLLNOTAS)
				If 	aLLNOTAS[nJ,1] == aNOTASOK[nI,1] .and. aLLNOTAS[nJ,2] == aNOTASOK[nI,2] .and. ;
					aLLNOTAS[nJ,3] == aNOTASOK[nI,3] .and. aLLNOTAS[nJ,4] == aNOTASOK[nI,4]
					
					// posicao do registro deletado
					If aLLNOTAS[nJ,5] == "*"
						nPOSDEL := nJ
					Else       
					// posicao do registro ativo
						nPOSACT := nJ
					EndIf         
					// posicao do registro com chave
					If ALLTRIM(aLLNOTAS[nJ,6]) != "" 
						nPOSCHV := nJ
				    EndIf
				    
				    nNUMREG += 1
				    			    
				EndIf           
				
				// se jแ encontrou o n๚mero registro do documento atual, encerra o la็o.
				If nNUMREG == aNOTASOK[nI,7]
					Exit
				EndIf
				
			Next nJ
			                                               
			// identifica as prioridades de impressใo
			// 1- Nota fiscal nใo deletada
			// 2- Nota fiscal deletada com chave
			// 3- Nota fiscal deletada  
			
			If nPOSACT != 0
				aNOTASOK[nI,5] := aLLNOTAS[nPOSACT,5]
				aNOTASOK[nI,6] := aLLNOTAS[nPOSACT,6]
			Else
				If nPOSCHV != 0
					aNOTASOK[nI,5] := aLLNOTAS[nPOSCHV,5]
					aNOTASOK[nI,6] := aLLNOTAS[nPOSCHV,6]
				Else
					aNOTASOK[nI,5] := aLLNOTAS[nPOSDEL,5]
					aNOTASOK[nI,6] := aLLNOTAS[nPOSDEL,6]			
				EndIf
			EndIf
			
		Next nI	
	EndIf
		
	nLinha    		:= 50
	nColuna  		:= 50
	nIncremento		:= 0
	nTOTCONT		:= 0
	nTOTBSICMS		:= 0
	nTOTICMS		:= 0
	nTOTDIP			:= 0
	nTOTGERCONT		:= 0
	nTOTGERBSICMS	:= 0
	nTOTGERICMS		:= 0
	nTOTGERDIP		:= 0
	nPagina			+= 1
	
	oPrinter:SetLandscape()
	oPrinter:StartPage()
	oPrinter:SayBitmap( nLinha+000, nColuna+000, cLogoImg , 365, 152 )
	oPrinter:Say( 2020, 0070, "Sit. NFE: [1] NFe Recebida - [2] NFe Assinada - [3] NFe com falha no schema XML - [4] NFe transmitida - [5] NFe com problemas - [6] NFe autorizada - [7] Cancelamento  ", oFont2, 100 )
	oPrinter:Say( 2080, 0070, "Sit. Canc.: [1] NFe Recebida - [2] NFe Cancelada - [3] NFe com falha de cancelamento/inutiliza็ใo ", oFont2, 100 )
	oPrinter:Say( 2150, 0070, "Rel. RJOMSR03", oFont2, 100 )
	oPrinter:Say( 2150, 1300, cTitulo, oFont2, 100 )
	oPrinter:Say( 2150, 2940, "Pแg. "+ALLTRIM(STR(nPagina)), oFont2, 100 )
	nIncremento += 030
	
	//SUPERIOR
	oPrinter:Line( 0020, 0030,0020, 3160 )
	//ESQUERDO
	oPrinter:Line( 0020, 0030,2200, 0030 )
	//DIREITO
	oPrinter:Line( 0020, 3160,2200, 3160 )
	//INFERIOR
	oPrinter:Line( 2200, 0030,2200, 3160 )
	oPrinter:Box( 300, 040, 2010, 3150 )
	
	
	cSTATUSDOC  := ""
	cPROTOCVAZ  := ""
	cCHAVEVAZ	:= ""
	
	If mv_par05 == 1 
		cCHAVEVAZ :=  "Sim"
	Else                                                                   
		cCHAVEVAZ :=  "Nใo"
	EndIf         
	If mv_par06 == 1 
		cPROTOCVAZ :=  "Sim"
	Else                                                                   
		cPROTOCVAZ :=  "Nใo"
	EndIf  
	If Empty(mv_par07)
		cSTATUSDOC :=  "Todos"
	Else                                                                   
		cSTATUSDOC :=  cValToChar(mv_par07)
	EndIf
	
	
	oPrinter:Say( nLinha+nIncremento, nColuna+1300, cTitulo, oFont2, 100 )
	nIncremento	+= 080
	oPrinter:Say( nLinha+nIncremento, nColuna+0400, "Perํodo: " +SubSTR(dtoc(mv_par01),1,2) + "/"  +SubSTR(dtoc(mv_par01),4,2) + "/"  +SubSTR(dtoc(mv_par01),9,2) +" เ " +SubSTR(dtoc(mv_par02),1,2) + "/"  +SubSTR(dtoc(mv_par02),4,2) + "/"  +SubSTR(dtoc(mv_par02),9,2), oFont1, 100 )
	oPrinter:Say( nLinha+nIncremento, nColuna+770, "Chave Vazia: "+ cCHAVEVAZ, oFont1, 100 )
	oPrinter:Say( nLinha+nIncremento, nColuna+1000, "Protocolo Vazio: "+ cPROTOCVAZ, oFont1, 100 )
	oPrinter:Say( nLinha+nIncremento, nColuna+1300, "Status: "+ cSTATUSDOC, oFont1, 100 )
	oPrinter:Say( nLinha+nIncremento, nColuna+1800, "Emissใo: "+DTOC(DDATABASE), oFont1, 100 )
	oPrinter:Box( 210, 040, 300, 3150 ) 
	
	nIncremento	+= 60
	nColunaCab	:= 0
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Fil", oFont2, 100 )
	nColunaCab += 75
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "NF", oFont2, 100 )
	nColunaCab += 110
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Serie", oFont2, 100 )
	nColunaCab += 100
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Dt NF", oFont2, 100 )
	nColunaCab += 110
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "CFOP", oFont2, 100 )
	nColunaCab += 175
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Vlr.NF", oFont2, 100 )
	nColunaCab += 150
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Base ICMS", oFont2, 100 )
	nColunaCab += 250
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "ICMS Trib", oFont2, 100 )
	nColunaCab += 350
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "DPI", oFont2, 100 )
	nColunaCab += 100
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Observa็ใo", oFont2, 100 )
	nColunaCab += 425
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Protocolo", oFont2, 100 )
	nColunaCab += 300
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Chave NFe", oFont2, 100 )
	nColunaCab += 685
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Sit.NFe", oFont2, 100 )
	nColunaCab += 120
	oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Sit.Canc", oFont2, 100 )
	
	nIncremento	+= 45
	nTOTALDOC	:= 0      
	nNUMREG		:= 0
	
	dbSelectArea(cAliasSF3)
	(cAliasSF3)->(dbGoTop())
	While (cAliasSF3)->(!EOF())
		
		nNUMREG		+= 1
		If nIncremento > 1845
			
			oPrinter:EndPage()
			oPrinter:SetLandscape()
			oPrinter:StartPage()
			
			nLinha		:= 50
			nColuna		:= 50
			nIncremento	:= 0
			nPagina		+= 1
			
			oPrinter:SayBitmap( nLinha+000, nColuna+000, cLogoImg , 365, 152 )
			oPrinter:Say( 2020, 0070, "Sit. NFE: [1] NFe Recebida - [2] NFe Assinada - [3] NFe com falha no schema XML - [4] NFe transmitida - [5] NFe com problemas - [6] NFe autorizada - [7] Cancelamento  ", oFont2, 100 )
			oPrinter:Say( 2080, 0070, "Sit. Canc.: [1] NFe Recebida - [2] NFe Cancelada - [3] NFe com falha de cancelamento/inutiliza็ใo ", oFont2, 100 )
			oPrinter:Say( 2150, 0070, "Rel. RJOMSR03", oFont2, 100 )
			oPrinter:Say( 2150, 1300, cTitulo, oFont2, 100 )
			oPrinter:Say( 2150, 2940, "Pแg. "+ALLTRIM(STR(nPagina)), oFont2, 100 )
			nIncremento += 030
			
			//SUPERIOR
			oPrinter:Line( 0020, 0030,0020, 3160 )
			//ESQUERDO
			oPrinter:Line( 0020, 0030,2200, 0030 )
			//DIREITO
			oPrinter:Line( 0020, 3160,2200, 3160 )
			//INFERIOR
			oPrinter:Line( 2200, 0030,2200, 3160 ) 
			oPrinter:Box( 300, 040, 2010, 3150 )   
			
			oPrinter:Say( nLinha+nIncremento, nColuna+1300, cTitulo, oFont2, 100 )
			nIncremento += 080
			oPrinter:Say( nLinha+nIncremento, nColuna+0400, "Perํodo: " +SubSTR(dtoc(mv_par01),1,2) + "/"  +SubSTR(dtoc(mv_par01),4,2) + "/"  +SubSTR(dtoc(mv_par01),9,2) +" เ " +SubSTR(dtoc(mv_par02),1,2) + "/"  +SubSTR(dtoc(mv_par02),4,2) + "/"  +SubSTR(dtoc(mv_par02),9,2), oFont1, 100 )
			oPrinter:Say( nLinha+nIncremento, nColuna+770,  "Chave Vazia: "+ cCHAVEVAZ, oFont1, 100 )
			oPrinter:Say( nLinha+nIncremento, nColuna+1000, "Protocolo Vazio: "+ cPROTOCVAZ, oFont1, 100 )		
			oPrinter:Say( nLinha+nIncremento, nColuna+1300, "Status: "+ cSTATUSDOC, oFont1, 100 )		
			oPrinter:Say( nLinha+nIncremento, nColuna+1800, "Emissใo: "+DTOC(DDATABASE), oFont1, 100 )
			oPrinter:Box( 210, 040, 300, 3150 ) 
			
			nIncremento += 60
			nColunaCab := 0
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Fil", oFont2, 100 )
			nColunaCab += 75
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "NF", oFont2, 100 )
			nColunaCab += 110
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Serie", oFont2, 100 )
			nColunaCab += 100
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Dt NF", oFont2, 100 )
			nColunaCab += 110
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "CFOP", oFont2, 100 )
			nColunaCab += 175
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Vlr.NF", oFont2, 100 )
			nColunaCab += 150
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Base ICMS", oFont2, 100 )
			nColunaCab += 250
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "ICMS Trib", oFont2, 100 )
			nColunaCab += 350
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "DPI", oFont2, 100 )
			nColunaCab += 100
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Observa็ใo", oFont2, 100 )
			nColunaCab += 425
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Protocolo", oFont2, 100 )
			nColunaCab += 300
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Chave NFe", oFont2, 100 )
			nColunaCab += 685
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Sit.NFe", oFont2, 100 )
			nColunaCab += 120
			oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, "Sit.Canc", oFont2, 100 )
			
			nIncremento += 45
		Endif
		
		cNUMDOC := (cAliasSF3)->F3_FILIAL + (cAliasSF3)->F3_NFISCAL + (cAliasSF3)->F3_SERIE
		
		nPOS := 0
	    If Len(aNOTASOK) > 0
			nPOS := aScan ( aNOTASOK , {|x| 	x[1] == (cAliasSF3)->F3_FILIAL  .and. ;
										   		x[2] == (cAliasSF3)->F3_NFISCAL .and. ;
										  		x[3] == (cAliasSF3)->F3_SERIE   .and. ;
										  		x[4] == (cAliasSF3)->TIPO } )
	    EndIf
		
		
		While (cAliasSF3)->(!EOF()) .and. (cAliasSF3)->F3_FILIAL + (cAliasSF3)->F3_NFISCAL + (cAliasSF3)->F3_SERIE == cNUMDOC
		
			If nPOS != 0
					If 	(cAliasSF3)->F3_FILIAL != aNOTASOK[nPOS,1] .OR. (cAliasSF3)->F3_NFISCAL != aNOTASOK[nPOS,2] .OR. ;
						(cAliasSF3)->F3_SERIE  != aNOTASOK[nPOS,3] .OR. (cAliasSF3)->TIPO       != aNOTASOK[nPOS,4] .OR. ;
						(cAliasSF3)->DELETADO  != aNOTASOK[nPOS,5] .OR. (cAliasSF3)->F2_CHVNFE  != aNOTASOK[nPOS,6] 
	
						(cAliasSF3)->(dbSkip())
						Loop
					EndIf
			EndIf		
		    
		
			// Consulta Status NFE - (LIB)			
	    	aSTATUSNFE := U_RJURETNFE((cAliasSF3)->F3_FILIAL, (cAliasSF3)->F3_NFISCAL, (cAliasSF3)->F3_SERIE)
	
			/*BEGINDOC
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ!ฟ
			//ณ aSTATUSNFE[1]= STATUS           ณ
			//ณ aSTATUSNFE[2]= STATUS CANCELADO ณ
			//ณ aSTATUSNFE[3]= PROTOCOLO        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ!ู
			ENDDOC*/
	        
			If Empty(mv_par07)
				If mv_par06 == 2
					FIMPDOC()
				Else
					If Empty(aSTATUSNFE[3])
						FIMPDOC()
					EndIf
				EndIf					
			ElseIf aSTATUSNFE[1] == mv_par07
				If mv_par06 == 2
					FIMPDOC()
				Else
					If Empty(aSTATUSNFE[3])
						FIMPDOC()
					EndIf
				EndIf			
			EndIf 
			
			
			(cAliasSF3)->(dbSkip())
		Enddo                 
		
		nTOTDIP		:= 0
		nTOTCONT	:= 0                                               
		nTOTICMS	:= 0
		nTOTBSICMS	:= 0
	
	Enddo
	dbSelectArea(cAliasSF3)
	(cAliasSF3)->(dbCloseArea())	
	

	If nIncremento > 1850
		
		oPrinter:EndPage()
		oPrinter:SetLandscape()
		oPrinter:StartPage()
		
		nLinha		:= 50
		nColuna		:= 50
		nIncremento := 0
		nPagina		+= 1      
		
		oPrinter:SayBitmap( nLinha+000, nColuna+000, cLogoImg , 365, 152 )
		oPrinter:Say( 2020, 0070, "Sit. NFE: [1] NFe Recebida - [2] NFe Assinada - [3] NFe com falha no schema XML - [4] NFe transmitida - [5] NFe com problemas - [6] NFe autorizada - [7] Cancelamento  ", oFont2, 100 )
		oPrinter:Say( 2080, 0070, "Sit. Canc.: [1] NFe Recebida - [2] NFe Cancelada - [3] NFe com falha de cancelamento/inutiliza็ใo ", oFont2, 100 )
		oPrinter:Say( 2150, 0070, "Rel. RJOMSR03", oFont2, 100 )
		oPrinter:Say( 2150, 1300, cTitulo, oFont2, 100 )
		oPrinter:Say( 2150, 2940, "Pแg. "+ALLTRIM(STR(nPagina)), oFont2, 100 )
		nIncremento += 030
		
		//SUPERIOR
		oPrinter:Line( 0020, 0030,0020, 3160 ) 
		//ESQUERDO
		oPrinter:Line( 0020, 0030,2200, 0030 )
		//DIREITO
		oPrinter:Line( 0020, 3160,2200, 3160 ) 
		//INFERIOR
		oPrinter:Line( 2200, 0030,2200, 3160 ) 
		oPrinter:Box( 0300, 0040, 2010, 3150 )   
		
		
		nIncremento += 000
		oPrinter:Say( nLinha+nIncremento, nColuna+1300, cTitulo, oFont2, 100 )
		nIncremento += 080
		oPrinter:Say( nLinha+nIncremento, nColuna+0400, "Perํodo: " +SubSTR(dtoc(mv_par01),1,2) + "/"  +SubSTR(dtoc(mv_par01),4,2) + "/"  +SubSTR(dtoc(mv_par01),9,2) +" เ " +SubSTR(dtoc(mv_par02),1,2) + "/"  +SubSTR(dtoc(mv_par02),4,2) + "/"  +SubSTR(dtoc(mv_par02),9,2), oFont1, 100 )
		oPrinter:Say( nLinha+nIncremento, nColuna+0770, "Chave Vazia: "+ cCHAVEVAZ, oFont1, 100 )
		oPrinter:Say( nLinha+nIncremento, nColuna+1000, "Protocolo Vazio: "+ cPROTOCVAZ, oFont1, 100 )	
		oPrinter:Say( nLinha+nIncremento, nColuna+1300, "Status: "+ cSTATUSDOC, oFont1, 100 )	
		oPrinter:Say( nLinha+nIncremento, nColuna+1800, "Emissใo: "+DTOC(DDATABASE), oFont1, 100 )
		oPrinter:Box( 210, 040, 300, 3150 )
			
		nIncremento += 80
		oPrinter:Say( nLinha+nIncremento,0080, "Total Geral ", oFont2, 100 )
		oPrinter:Say( nLinha+nIncremento,0775, Transform(nTOTGERCONT,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1000, Transform(nTOTGERBSICMS,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1225, Transform(nTOTGERICMS,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1450, Transform(nTOTGERDIP,"@E 99,999,999.99"), oFont3, 100,,,1 )
		
	Else
		
		nIncremento += 80
		oPrinter:Say( nLinha+nIncremento,0080, "Total Geral ", oFont2, 100 )
		oPrinter:Say( nLinha+nIncremento,0775, Transform(nTOTGERCONT,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1000, Transform(nTOTGERBSICMS,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1225, Transform(nTOTGERICMS,"@E 99,999,999.99"), oFont3, 100,,,1 )
		oPrinter:Say( nLinha+nIncremento,1450, Transform(nTOTGERDIP,"@E 99,999,999.99"), oFont3, 100,,,1 )
	
	EndIf
	
	oPrinter:Preview()
	

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFIMPDOC   บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para impressใo do documento.                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function FIMPDOC()                                                    
*---------------------------------------------------------------------------*

	cOBSERVACOES := SubSTR((cAliasSF3)->F3_OBSERV,1,15)
	
	//http://tdn.totvs.com/pages/releaseview.action?pageId=6076078
	
	If "110/301/302/303/304/305/306" $ ALLTRIM((cAliasSF3)->F3_CODRSEF)
		cOBSERVACOES := "USO DENEGADO"
	ElseIf "102" $ ALLTRIM((cAliasSF3)->F3_CODRSEF)
		cOBSERVACOES := "INUTILIZADO"
	EndIf
	

	dbSelectArea(cAliasSF3)
	If (cAliasSF3)->F3_FILIAL + (cAliasSF3)->F3_NFISCAL + (cAliasSF3)->F3_SERIE == cNUMDOC 
		nIncremento += 45
		nColunaCab := 25
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, (cAliasSF3)->F3_FILIAL, oFont3, 100,,,1 )
		nColunaCab += 175
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, (cAliasSF3)->F3_NFISCAL, oFont3, 100,,,1 )
		nColunaCab += 050 
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, (cAliasSF3)->F3_SERIE, oFont3, 100,,,1 )
		nColunaCab += 125 
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, SubSTR((cAliasSF3)->F3_ENTRADA,7,2) + "/" +SubSTR((cAliasSF3)->F3_ENTRADA,5,2) + "/" +SubSTR((cAliasSF3)->F3_ENTRADA,3,2), oFont3, 100,,,1 )
		nColunaCab += 100
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, (cAliasSF3)->F3_CFO, oFont3, 100,,,1 )
		nColunaCab += 175 
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, Transform((cAliasSF3)->VALCONT,"@E 99,999,999.99"), oFont3, 100,,,1 )
		nColunaCab += 225
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, Transform((cAliasSF3)->BASEICM,"@E 99,999,999.99"), oFont3, 100,,,1 )
		nColunaCab += 225
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, Transform((cAliasSF3)->VALICM,"@E 99,999,999.99"), oFont3, 100,,,1 )
		nColunaCab += 300 
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, cOBSERVACOES, oFont3, 100,,,0 )
		nColunaCab += 400 
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, aSTATUSNFE[3], oFont3, 100,,,0 )
		nColunaCab += 300
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, (cAliasSF3)->F2_CHVNFE, oFont3, 100,,,0 )
		nColunaCab += 825
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, STR(aSTATUSNFE[1]), oFont3, 100,,,1 )
		nColunaCab += 050
		oPrinter:Say( nLinha+nIncremento, nColuna+nColunaCab, IIF(ALLTRIM(STR(aSTATUSNFE[2])) = "0" ," ",STR(aSTATUSNFE[2])), oFont3, 100,,,1 )
		
		// valida se ้ nota de entrada, caso afirmativo busca informacoes se existe valor na DIP
		nVALDIP := 0
		If (cAliasSF3)->F3_CFO < "5000"
			
			cQuery := " SELECT 	SUM(D1_VALIMP3) 	NVALDIP							" + hEnter
			cQuery += " FROM 	"+RetSqlName("SD1")+" SD1							" + hEnter
			cQuery += " WHERE	SD1.D1_FILIAL	= '" + (cAliasSF3)->F3_FILIAL +  "'	" + hEnter
			cQuery += " AND		SD1.D1_DOC 		= '" + (cAliasSF3)->F3_NFISCAL + "'	" + hEnter
			cQuery += " AND 	SD1.D1_SERIE	= '" + (cAliasSF3)->F3_SERIE +   "'	" + hEnter
			cQuery += " AND 	SD1.D_E_L_E_T_	<> '*' 								" + hEnter
			MemoWrite("RJOMSR03SD1.SQL",cQuery)
		   
			TcQuery changequery(cQuery) new alias (cAliasSD1)
			
			If Alias() <> (cAliasSD1)
				MsgBox("cAliasSD1 - Parโmetros Invแlidos!")
				Return .F.
			Endif
			
		Endif
		
		If select(cAliasSD1) > 0
			dbSelectArea(cAliasSD1)
			If !(cAliasSD1)->(EOF())
				nVALDIP := (cAliasSD1)->NVALDIP
			EndIf
		Endif
		
		oPrinter:Say( nLinha+nIncremento, 1450, Transform(nVALDIP,"@E 99,999,999.99"), oFont3, 100,,,1 )
		
		nTOTCONT		:= nTOTCONT 		+ (cAliasSF3)->VALCONT
		nTOTBSICMS		:= nTOTBSICMS 		+ (cAliasSF3)->BASEICM
		nTOTICMS		:= nTOTICMS 		+ (cAliasSF3)->VALICM
		nTOTDIP			:= nTOTDIP 			+ nVALDIP
		nTOTGERCONT		:= nTOTGERCONT		+ nTOTCONT
		nTOTGERBSICMS	:= nTOTGERBSICMS 	+ nTOTBSICMS
		nTOTGERICMS		:= nTOTGERICMS	 	+ nTOTICMS
		nTOTGERDIP		:= nTOTGERDIP 		+ nTOTDIP
		
	EndIf		
	
	If select(cAliasSD1) > 0
		(cAliasSD1)->(dbCloseArea())
	Endif 
	   
Return  


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJURETNFE บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por retornar o STATUS do documento junto บฑฑ
ฑฑบ          ณa tabela SPED050 (SPED/NFE).                                บฑฑ
ฑฑบRetornos: ณ*Param1-Situa็๕es: [1] NFe Recebida - [2] NFe Assinada  -   บฑฑ
ฑฑบ          ณ[3] NFe com falha no schema XML - [4] NFe transmitida  -    บฑฑ
ฑฑบ          ณ[5] NFe com problemas - [6] NFe autorizada - [7] Cancelamentoฑฑ
ฑฑบ          ณ*Param2-Situa็๕es cancelamento: [1] NFe Recebida - [2] NFe  บฑฑ
ฑฑบ          ณCancelada - [3] NFe com falha de cancelamento/inutiliza็ใo  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJURETNFE(cFILDOC, cNUMDOC, cSERDOC)
*---------------------------------------------------------------------------*
Local aAreaTMP  := GetArea()
Local cIDENTE   := ""		//ID empresa             
Local cPROTONF  := ""		//ID Protocolo NFE
Local nSTATNFE  := 0		//ID status NFE
Local nSTATNFC  := 0		//ID status NFE/CANCELADA
Local cKEYDOC   := cSERDOC + cNUMDOC
Local cFILNFE   := cFILDOC
Local cAliasTMP := GetNextAlias()
Local nCONNSPED := U_RJUCONSPED()
Local cCNPJ		:= ""        
Local cINSCEST	:= ""      

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	If nCONNSPED > 0      
		
		If cFILNFE != nil
			dbSelectArea("SM0")
			SM0->(dbSetOrder(1))
			SM0->(dbGoTop())
			SM0->(dbSeek(cEmpAnt + cFILNFE))
			While SM0->(!EOF()) .AND. SM0->M0_CODIGO == cEmpAnt .AND. SM0->M0_CODFIL <= cFILNFE			
				cCNPJ		:= SM0->M0_CGC
				cINSCEST	:= SM0->M0_INSC
				SM0->(DBSKIP())
			enddo
		EndIf		
		
		cQuery := " SELECT ID_ENT, CNPJ  		 				" + chr(10)+chr(13)
		cQuery += " FROM SPED001 								" + chr(10)+chr(13)
		If cFILNFE == nil
			cQuery += " WHERE CNPJ 	= '" + SM0->M0_CGC + "'		" + chr(10)+chr(13)
		  	cQuery += " AND   IE 	= '" + SM0->M0_INSC + "'	" + chr(10)+chr(13)		
        Else 
			cQuery += " WHERE CNPJ	= '" + cCNPJ + "'			" + chr(10)+chr(13)
		  	cQuery += " AND   IE	= '" + cINSCEST + "'		" + chr(10)+chr(13)
		EndIf
		cQuery += " AND   D_E_L_E_T_ <> '*' 					" + chr(10)+chr(13)

		
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	   	If !(cAliasTMP)->(EOF())
	   		cIDENTE := (cAliasTMP)->ID_ENT
	   	EndIf
		(cAliasTMP)->(dbCloseArea())
		
		//-- select para identifcar a nota fiscal (status sefaz)
		cQuery := " SELECT	S1.STATUS 		SNFE,				" + chr(10)+chr(13)
		cQuery += "     	S1.STATUSCANC 	SNFC, 				" + chr(10)+chr(13)		
		cQuery += "     	S1.NFE_PROT 	PROTNF				" + chr(10)+chr(13)		
		cQuery += " FROM SPED050 S1								" + chr(10)+chr(13)
		cQuery += " WHERE S1.R_E_C_N_O_ =  						" + chr(10)+chr(13)
		cQuery += " 	( SELECT MAX(S2.R_E_C_N_O_) 	 		" + chr(10)+chr(13)
		cQuery += "  	FROM SPED050 S2							" + chr(10)+chr(13)
		cQuery += " 	WHERE S2.ID_ENT = '" + cIDENTE + "' 	" + chr(10)+chr(13)
		cQuery += " 	AND S2.NFE_ID   = '" + cKEYDOC + "' 	" + chr(10)+chr(13)
		cQuery += " 	AND S2.D_E_L_E_T_ <> '*' ) 				" + chr(10)+chr(13)
		
		TCQUERY ChangeQuery(cQuery) NEW ALIAS (cAliasTMP)
		dbSelectArea(cAliasTMP)
		(cAliasTMP)->(dbGoTop())
	   	nSTATNFE := (cAliasTMP)->SNFE
	   	nSTATNFC := (cAliasTMP)->SNFC
	   	cPROTONF := (cAliasTMP)->PROTNF	   	
		(cAliasTMP)->(dbCloseArea())
		
		//--finaliza conexใo com banco SPED
		TCUnLink(nCONNSPED)
		
	EndIf     
	
	RestArea(aAreaTMP)
	
Return ({nSTATNFE,nSTATNFC,cPROTONF})


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRJUCONSPED บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo responsแvel por abrir conexใo com db/sevidor SPED/NFEบฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
User Function RJUCONSPED()
*---------------------------------------------------------------------------*
Local nCONNLOC := 0
Local cCONSPED := SuperGetMV("MV_X_SCON",,'{"ORACLE/NFE","192.168.220.5", 7891}')
Local aCONSPED := &(cCONSPED)   

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
//ณChama fun็ใo para monitor uso de fontes customizadosณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ
U_USORWMAKE(ProcName(),FunName())

	TCConType("TCPIP")
	nCONNLOC := TCLink(aCONSPED[1],aCONSPED[2],aCONSPED[3])
	
	If nCONNLOC <= 0
		Alert("Falha na conexใo TOPCONN ("+cDBSPED+" - "+cIPSPED+") - ID-Erro: " + Alltrim(STR(nCONNLOC)) )
		TCUnLink(nCONNLOC)
	EndIf     

Return (nCONNLOC)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAjustaSX1 บAutor  ณTOTVS PARANA CENTRALบ Data ณ  22/08/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณFun็ใo para cria็ใo de parโmetros.                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณRJU                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
*---------------------------------------------------------------------------*
Static Function AjustaSX1()                                                                             
*---------------------------------------------------------------------------*
Local aRegs := {}

	aAdd(aRegs,{cPerg,"01","Data Inicial            ?","","","mv_ch1","D",08,0,0,"C","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"02","Data Final              ?","","","mv_ch2","D",08,0,0,"C","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"03","Filial Inicial          ?","","","mv_ch3","C",02,0,0,"C","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"04","Filial Final            ?","","","mv_ch4","C",02,0,0,"C","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"05","Somente Chave Vazia     ?","","","mv_ch5","N",01,0,1,"C","","mv_par05","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"06","Somente Protocolo Vazio ?","","","mv_ch6","N",01,0,1,"C","","mv_par06","Sim","Sim","Sim","","","Nใo","Nใo","Nใo","","","","","","","","","","","","",""})
	aAdd(aRegs,{cPerg,"07","Status                  ?","","","mv_ch7","N",01,0,0,"C","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	dbSelectArea("SX1")
	dbSetOrder(1)
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
	Next i
	
Return
